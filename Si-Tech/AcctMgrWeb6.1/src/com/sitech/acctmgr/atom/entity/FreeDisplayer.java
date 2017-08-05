package com.sitech.acctmgr.atom.entity;

import static org.apache.commons.collections.MapUtils.getString;
import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.utils.DateUtils;
import org.apache.commons.lang.StringUtils;

import com.sitech.acctmgr.atom.domains.free.FamilyFreeFeeUserEntity;
import com.sitech.acctmgr.atom.domains.free.FreeUseInfoEntity;
import com.sitech.acctmgr.atom.domains.prod.PdPrcInfoEntity;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.domains.query.FreeMinBill;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.net.Client;
import com.sitech.acctmgr.net.ClientFactory;
import com.sitech.acctmgr.net.ParseDataException;
import com.sitech.acctmgr.net.ResponseData;
import com.sitech.acctmgr.net.ServerInfo;
import com.sitech.acctmgr.net.free.FreeResponseBody;
import com.sitech.acctmgr.net.free.FreeResponseHeader;
import com.sitech.acctmgr.net.impl.FreeClient;
import com.sitech.acctmgr.net.impl.FreeResponseData;
import com.sitech.jcf.core.exception.BusiException;

/**
 * Created by wangyla on 2016/6/16.
 */
public class FreeDisplayer extends BaseBusi implements IFreeDisplayer {
    private IControl control;
    private IProd prod;
    private IBillAccount billAccount;
    private IGroup group;
    private IUser user;

    @Override
    public List<FreeMinBill> getFreeDetailList(String phoneNo, int queryYM, String busiCode) {
        UserInfoEntity uie = user.getUserEntityByPhoneNo(phoneNo, true);
        long idNo = uie.getIdNo();
        String userGroupId = uie.getGroupId();

        ChngroupRelEntity groupInfo = group.getRegionDistinct(userGroupId, "2", control.getProvinceId(idNo));
        String regionCode = groupInfo.getRegionCode();
        List<FreeMinBill> allList = new ArrayList<>();
        allList.addAll(this.getFreeDetailList(phoneNo, queryYM, busiCode, null, "FREEMINQRY", regionCode)); // 小机上的语音、短信类信息
        allList.addAll(this.getFreeDetailList(phoneNo, queryYM, busiCode, null, "FREEQRYCLOUD", regionCode)); // 云机上的GPRS信息
        return allList;
    }

    @Override
    public List<FreeMinBill> getFreeDetailList(String phoneNo, int queryYM, String busiCode, String queryType) {
        UserInfoEntity uie = user.getUserEntityByPhoneNo(phoneNo, true);
        long idNo = uie.getIdNo();
        String userGroupId = uie.getGroupId();

        ChngroupRelEntity groupInfo = group.getRegionDistinct(userGroupId, "2", control.getProvinceId(idNo));
        String regionCode = groupInfo.getRegionCode();
        return this.getFreeDetailList(phoneNo, queryYM, busiCode, queryType, "FREEQRYCLOUD", regionCode); // 默认查询云机GPRS
    }

    private List<FreeMinBill> getFreeDetailList(String phoneNo, int queryYM, String busiCode, String queryType, String routName, String regionCode) {

        String yearMonth = String.format("%6d", queryYM);

        // 获取免费分钟数路由信息
        String ph = phoneNo.substring(0, 7);
        ServerInfo si = control.getPhoneRouteConf(ph, routName);

        long start = System.currentTimeMillis();

        ClientFactory factory = ClientFactory.getInstance();
        Client client = factory.getClient(FreeClient.class);
        client.setRequestArgs(phoneNo, yearMonth, busiCode, queryType);
        client.getServerProxy().setServerInfo(si);
        FreeResponseData freeRespData = null;
        ResponseData respData = client.getResponseData();

        try {

            respData.parse();

        } catch (ParseDataException pe) {
            log.error(pe.getMessage());
            throw new BusiException(AcctMgrError.getErrorCode("0000", "50002"), "服务端返回数据错误，请检查!");
        }

        if (respData instanceof FreeResponseData) {
            freeRespData = (FreeResponseData) respData;
        } else {
            freeRespData = new FreeResponseData();
        }

        FreeResponseHeader header = freeRespData.getRespHeader();
        List<FreeResponseBody> body = freeRespData.getRespBody();

        long end = System.currentTimeMillis();

        log.debug("调用计费接口消耗[" + (end - start) + "]毫秒");

        String status = header.getStatus();
        int size = header.getRecordNum();

        // 免费分钟数列表
        List<FreeMinBill> list = new ArrayList<>();

        if ("1".equals(status)) {
            FreeMinBill freeMinBill = null;
            for (int i = 0; i < size; i++) {
                freeMinBill = new FreeMinBill();
                FreeResponseBody b = body.get(i);
                String bc = b.getBusicode();
                String uc = b.getUnitcode();
                String unitName = this.getUnitName(uc, bc);// 单位名称
                String busiName = this.getBusiName(bc); // 业务名称
                String typename = this.getFavTypeName(b.getFavtype(), b.getFavcode());// 优惠类型名称
                long total = Long.parseLong(b.getFreesum());
                long used = Long.parseLong(b.getFreecurrent());
                long remain = (total - used > 0) ? (total - used) : 0;

                long lastTotal = Long.parseLong(b.getSubfreesum()); // 上月结转总量
                long lastUsed = Long.parseLong(b.getSubfreecurrence()); // 上月结转使用量
                long lastRemain = (lastTotal - lastUsed > 0) ? (lastTotal - lastUsed) : 0; // 上月结转剩余量
                lastUsed = (lastTotal > lastUsed) ? lastUsed : lastTotal;

                if (total <= 0 && lastTotal <= 0 && used <= 0) { /* 过滤掉全为0的无效记录 */
                    continue;
                }

                long realFree = 0;
                if (queryType != null && queryType.equals("a")) {
                    realFree = Long.parseLong(b.getRealfree());
                }

                long prcId = Long.parseLong(b.getPrcId().trim());
                PdPrcInfoEntity pdPrcInfo = prod.getPdPrcInfo(String.format("M0%05d", prcId));// TODO 资费转换，暂时为前面加M0，后续会变化
                String pdPrcName = (pdPrcInfo == null) ? "未知" : pdPrcInfo.getProdPrcName();
                String prcType = (pdPrcInfo == null) ? "" : pdPrcInfo.getPrcType();

                //获取优先级
                int priority = this.getPrcIdPriority(bc, String.format("M0%05d", prcId), regionCode);

                freeMinBill.setBusiCode(bc);
                freeMinBill.setBusiName(busiName);
                freeMinBill.setFavCode(b.getFavcode()); // 优惠类别
                freeMinBill.setFavType(b.getFavtype());
                freeMinBill.setFavTypeName(typename);
                freeMinBill.setUnitCode(uc);
                freeMinBill.setUnitName(unitName);
                freeMinBill.setLongUsed(used);
                freeMinBill.setUsed(String.format("%d", used)); // TODO 默认按整型输出,后续补充按unitcode的输出
                freeMinBill.setLongTotal(total);
                freeMinBill.setTotal(String.format("%d", total));
                freeMinBill.setLongRemain(remain);
                freeMinBill.setRemain(String.format("%d", remain));
                freeMinBill.setLongLastTotal(lastTotal);
                freeMinBill.setLastTotal(String.format("%d", lastTotal));
                freeMinBill.setLongLastUsed(lastUsed);
                freeMinBill.setLastUsed(String.format("%d", lastUsed));
                freeMinBill.setLongLastRemain(lastRemain);
                freeMinBill.setLastRemain(String.format("%d", lastRemain));
                freeMinBill.setLongRealFree(realFree);
                freeMinBill.setRealFree(String.format("%d", realFree));
                freeMinBill.setReferenceNo(b.getReferenceno());
                freeMinBill.setProdPrcId(String.format("M0%05d", prcId));
                freeMinBill.setProdPrcName(pdPrcName);
                freeMinBill.setYearMonth(yearMonth);
                freeMinBill.setReserve(header.getReserv());
                freeMinBill.setEffDate(b.getEffdate());
                freeMinBill.setPriority(priority);
                freeMinBill.setProductId(b.getProductId());
                freeMinBill.setInstanceId(b.getInstanceId());
                freeMinBill.setPrcType(prcType);

                if (bc.equals("3") && StringUtils.isNotEmpty(b.getFavClass().trim()) && StringUtils.isNotEmpty(b.getFavClassJz().trim())) {
                    String favClass = b.getFavClass().trim();
                    String favClassJz = b.getFavClassJz().trim();
                    String favClassName = billAccount.getGprsFavClassName(favClass);
                    String favClassJzName = billAccount.getGprsFavClassName(favClassJz);
                    String limitType = "";
                    String regionType = "";
                    if (StringUtils.isNotEmpty(favClassName) && StringUtils.isNotEmpty(favClassJzName)) {
                        if (favClassName.contains("定向") || favClassJzName.contains("定向")) {
                            limitType = "02";
                        } else {
                            limitType = "01";
                        }

                        if (favClassName.contains("省内") || favClassJzName.contains("省内")) {
                            regionType = "02";
                        } else {
                            regionType = "01";
                        }
                    }

                    freeMinBill.setLimitType(limitType);
                    freeMinBill.setRegionType(regionType);
                    freeMinBill.setFavClass(favClass);
                    freeMinBill.setFavClassName(favClassName);
                    freeMinBill.setFavClassJz(favClassJz);
                    freeMinBill.setFavClassJzName(favClassJzName);
                }

                list.add(freeMinBill);
            }
            return list;

        } else if ("2".equals(status)) {
            /* 无优惠信息 */
            log.error("无优惠信息返回");
            return list;

        } else if ("7".equals(status)) {
            /* 请求非法 */
            log.error("非法请求");
            throw new BusiException(AcctMgrError.getErrorCode("0000", "50002"), "非法请求");
        } else if ("8".equals(status)) {
            /* 通信包错误 */
            log.error("通信包错误");
            throw new BusiException(AcctMgrError.getErrorCode("0000", "50003"), "通信包错误");
        } else if ("9".equals(status)) {
            /* 处理错误 */
            log.error("服务端处理错误");
            throw new BusiException(AcctMgrError.getErrorCode("0000", "50004"), "服务端处理错误");
        }

        return list;
    }

    @Override
    public Map<String, FreeUseInfoEntity> getFreeTotalInfo(String phoneNo, int queryYM, String busiCode) {
        return this.getFreeTotalInfo(phoneNo, queryYM, busiCode, null);
    }

    @Override
    public Map<String, FreeUseInfoEntity> getFreeTotalInfo(String phoneNo, int queryYM, String busiCode, String queryType) {

        List<FreeMinBill> freeDetailList = this.getFreeDetailList(phoneNo, queryYM, busiCode, queryType);
        return this.getFreeTotalInfo(freeDetailList);
    }

    @Override
    public Map<String, FreeUseInfoEntity> getFreeTotalInfo(List<FreeMinBill> inFreeList) {
        Map<String /*busi_code*/, FreeUseInfoEntity> indexMap = new HashMap<>();

        long total = 0; // 总应优惠量，不含结转
        long used = 0; // 已使用优惠量
        long remain = 0; // 剩余优惠量
        String unitCode;
        long outMeal = 0;
        String busiCode;
        for (FreeMinBill freeBill : inFreeList) {
            busiCode = freeBill.getBusiCode();
            total = freeBill.getLongTotal();
            used = freeBill.getLongUsed();
            remain = freeBill.getLongRemain();
            unitCode = freeBill.getUnitCode();

			/* 1:语音 2:短信 3:GPRS 4:VPMN 5:WLAN 6:国际漫游 7:彩信 8:CMWAP R:结转流量 */
            if (!(freeBill.getBusiCode().equals("1") || freeBill.getBusiCode().equals("2") ||
                    freeBill.getBusiCode().equals("3") || freeBill.getBusiCode().equals("4") ||
                    freeBill.getBusiCode().equals("5") || freeBill.getBusiCode().equals("7") ||
                    freeBill.getBusiCode().equals("8") || freeBill.getBusiCode().equals("R") ||
                    freeBill.getBusiCode().equals("6")
            )) {
                continue;

            }

            if (total <= 0 && used <= 0 && freeBill.getLongLastTotal() <= 0 && freeBill.getLongLastUsed() <= 0) {
                continue;
            }

            // 套餐内流量
            if (busiCode.equals("3") && freeBill.getFavType().equals("0002")) {
                outMeal = freeBill.getLongUsed();
            }

            String key = busiCode + "^" + freeBill.getUnitCode();
            if (indexMap.containsKey(key)) {
                FreeUseInfoEntity freeEntity = indexMap.get(key);
                freeEntity.setLongTotal(total + freeEntity.getLongTotal());
                freeEntity.setLongUsed(used + freeEntity.getLongUsed());
                freeEntity.setLongRemain(remain + freeEntity.getLongRemain());
                freeEntity.setLongOutMeal(outMeal + freeEntity.getLongOutMeal());

            } else {
                FreeUseInfoEntity freeEntity = new FreeUseInfoEntity();
                freeEntity.setLongTotal(total);
                freeEntity.setLongUsed(used);
                freeEntity.setLongRemain(remain);
                freeEntity.setLongOutMeal(outMeal);
                freeEntity.setUnit(unitCode);
                freeEntity.setUnitName(freeBill.getUnitName());
                indexMap.put(key, freeEntity);
            }

        }

        return indexMap;

    }

    @Override
    public Map<String, Long> getFreeTotalMap(String phoneNo, int queyYm, String busiCode) {
        Map<String, Long> outFreeMap = new HashMap<>();

        Map<String, FreeUseInfoEntity> freeMap = this.getFreeTotalInfo(phoneNo, queyYm, busiCode);

        FreeUseInfoEntity freeEnt = null;
        long voiceTotal = 0;
        long voiceUsed = 0;
        long voiceRemain = 0;
        long smsTotal = 0;
        long smsUsed = 0;
        long smsRemain = 0;
        long gprsTimeTotal = 0; // 按时长统计的流量
        long gprsTimeUsed = 0;
        long gprsTimeRemain = 0;
        long gprsTotal = 0; // 按kb统计的流量
        long gprsUsed = 0;
        long gprsRemain = 0;
        long gprsOutMeal = 0; // 套餐外使用流量总量
        long mmsTotal = 0;
        long mmsUsed = 0;
        long mmsRemain = 0;
        long cmwapTotal = 0;
        long cmwapUsed = 0;
        long cmwapRemain = 0;
        long vpmnTotal = 0;
        long vpmnUsed = 0;
        long vpmnRemain = 0;
        for (String key : freeMap.keySet()) {
            String[] arr = key.split("\\^");
            busiCode = arr[0];
            String unitCode = arr[1];
            freeEnt /*FreeUseInfoEntity*/ = freeMap.get(key);
            if (busiCode.equals("1")) {
                voiceTotal += freeEnt.getLongTotal();
                voiceUsed += freeEnt.getLongUsed();
                voiceRemain += freeEnt.getLongRemain();
            } else if (busiCode.equals("2")) {
                smsTotal += freeEnt.getLongTotal();
                smsUsed += freeEnt.getLongUsed();
                smsRemain += freeEnt.getLongRemain();
            } else if (busiCode.equals("3") || busiCode.equals("R")) { // GPRS和结转；结转量累加到GPRS总量中
                if (unitCode.equals("3")) { // 按分钟数统计
                    gprsTimeTotal += freeEnt.getLongTotal();
                    gprsTimeUsed += freeEnt.getLongUsed();
                    gprsTimeRemain += freeEnt.getLongRemain();
                } else if (unitCode.equals("4")) {
                    gprsTotal += freeEnt.getLongTotal();
                    gprsUsed += freeEnt.getLongUsed();
                    gprsRemain += freeEnt.getLongRemain();

                    gprsOutMeal += freeEnt.getLongOutMeal();
                }

            } else if (busiCode.equals("7")) {
                mmsTotal += freeEnt.getLongTotal();
                mmsUsed += freeEnt.getLongUsed();
                mmsRemain += freeEnt.getLongRemain();
            } else if (busiCode.equals("8")) {
                cmwapTotal += freeEnt.getLongTotal();
                cmwapUsed += freeEnt.getLongUsed();
                cmwapRemain += freeEnt.getLongRemain();
            } else if (busiCode.equals("4")) {
                vpmnTotal += freeEnt.getLongTotal();
                vpmnUsed += freeEnt.getLongUsed();
                vpmnRemain += freeEnt.getLongRemain();
            }
        }

        safeAddToMap(outFreeMap, "VOICE_TOTAL", voiceTotal);
        safeAddToMap(outFreeMap, "VOICE_USED", voiceUsed);
        safeAddToMap(outFreeMap, "VOICE_REMAIN", voiceRemain);

        safeAddToMap(outFreeMap, "SMS_TOTAL", smsTotal);
        safeAddToMap(outFreeMap, "SMS_USED", smsUsed);
        safeAddToMap(outFreeMap, "SMS_REMAIN", smsRemain);

        safeAddToMap(outFreeMap, "GPRSTIME_TOTAL", gprsTimeTotal);
        safeAddToMap(outFreeMap, "GPRSTIME_USED", gprsTimeUsed);
        safeAddToMap(outFreeMap, "GPRSTIME_REMAIN", gprsTimeRemain);

        safeAddToMap(outFreeMap, "GPRS_TOTAL", gprsTotal);
        safeAddToMap(outFreeMap, "GPRS_USED", gprsUsed);
        safeAddToMap(outFreeMap, "GPRS_REMAIN", gprsRemain);
        safeAddToMap(outFreeMap, "GPRS_OUT_MEAL", gprsOutMeal);

        safeAddToMap(outFreeMap, "MMS_TOTAL", mmsTotal);
        safeAddToMap(outFreeMap, "MMS_USED", mmsUsed);
        safeAddToMap(outFreeMap, "MMS_REMAIN", mmsRemain);

        safeAddToMap(outFreeMap, "CMWAP_TOTAL", cmwapTotal);
        safeAddToMap(outFreeMap, "CMWAP_USED", cmwapUsed);
        safeAddToMap(outFreeMap, "CMWAP_REMAIN", cmwapRemain);

        safeAddToMap(outFreeMap, "VPMN_TOTAL", vpmnTotal);
        safeAddToMap(outFreeMap, "VPMN_USED", vpmnUsed);
        safeAddToMap(outFreeMap, "VPMN_REMAIN", vpmnRemain);

        return outFreeMap;
    }

    @Override
    public Map<String, Long> getFreeTotalMap(List<FreeMinBill> inFreeList) {
        return this.getFreeTotalMap(inFreeList, null);
    }

    @Override
    public Map<String, Long> getFreeTotalMap(List<FreeMinBill> inFreeList, List<String> detailCodeList) {
        Map<String, Long> outFreeMap = new HashMap<>();
        long voiceTotal = 0;
        long voiceUsed = 0;
        long voiceRemain = 0;
        long smsTotal = 0;
        long smsUsed = 0;
        long smsRemain = 0;
        long gprsTimeTotal = 0; // 按时长统计的流量
        long gprsTimeUsed = 0;
        long gprsTimeRemain = 0;
        long gprsTotal = 0; // 用户订购流量总量（含套餐及附加资费套餐）
        long gprsUsed = 0; // 用户订购流量使用总量
        long gprsRemain = 0; // 用户订购流量剩余量
        long mealGprsTotal = 0; // 主套餐资费的流量总量
        long mealGprsUsed = 0; // 主套餐资费的流量使用量
        long mealGprsRemain = 0; // 主套餐资费的流量剩余量
        long addedGprsTotal = 0; // 流量附加资费流量总量
        long addedGprsUsed = 0; // 流量附加资费流量总使用量
        long addedGprsRemain = 0; // 流量附加资费流量剩余量
        long mmsTotal = 0;
        long mmsUsed = 0;
        long mmsRemain = 0;
        long cmwapTotal = 0;
        long cmwapUsed = 0;
        long cmwapRemain = 0;
        long vpmnTotal = 0;
        long vpmnUsed = 0;
        long vpmnRemain = 0;
        long wlanTimeTotal = 0; // 按分钟数计量的wlan总量
        long wlanTimeUsed = 0; // 按分钟数计量的wlan 使用总量
        long wlanTimeRemain = 0;
        long wlanTimeOut = 0; // wlan 超出套餐使用量
        long wlanGprsTotal = 0;
        long wlanGprsUsed = 0;
        long wlanGprsRemain = 0;
        long wlanGprsOut = 0;


        String busiCode = null;
        String unitCode = null;
        for (FreeMinBill freeEnt : inFreeList) {
            busiCode = freeEnt.getBusiCode();
            unitCode = freeEnt.getUnitCode();

            if (freeEnt.getFavType().equals("0002")) {
                // 套餐外流量不在此做计算
                continue;
            }

            long longUsedTmp = (freeEnt.getLongTotal() > freeEnt.getLongUsed()) ? freeEnt.getLongUsed() : freeEnt.getLongTotal();

            if (busiCode.equals("1")) {
                voiceTotal += freeEnt.getLongTotal();
                voiceUsed += freeEnt.getLongUsed();
                voiceRemain += freeEnt.getLongRemain();
            } else if (busiCode.equals("2")) {
                smsTotal += freeEnt.getLongTotal();
                smsUsed += freeEnt.getLongUsed();
                smsRemain += freeEnt.getLongRemain();
            } else if (busiCode.equals("3") || busiCode.equals("R")) { // GPRS和结转；结转量累加到GPRS总量中
                String favType = freeEnt.getFavType();
                boolean mealFlag/* 套餐内资费标识 */ = this.isSpecifiedPrcId(favType, detailCodeList);
                if (mealFlag) {
                    mealGprsTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    mealGprsUsed += longUsedTmp + freeEnt.getLongLastUsed();
                    mealGprsRemain += freeEnt.getLongRemain() + freeEnt.getLongLastRemain();
                } else {
                    if (unitCode.equals("3")) { // 按分钟数统计
                        gprsTimeTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                        gprsTimeUsed += longUsedTmp + freeEnt.getLongLastUsed();
                        gprsTimeRemain += freeEnt.getLongRemain() + freeEnt.getLongLastRemain();
                    } else if (unitCode.equals("4")) {
                        addedGprsTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                        addedGprsUsed += longUsedTmp + freeEnt.getLongLastUsed();
                        addedGprsRemain += freeEnt.getLongRemain() + freeEnt.getLongLastRemain();
                    }
                }

            } else if (busiCode.equals("4")) {
                vpmnTotal += freeEnt.getLongTotal();
                vpmnUsed += freeEnt.getLongUsed();
                vpmnRemain += freeEnt.getLongRemain();
            } else if (busiCode.equals("5")) {

                if (unitCode.equals("3")) {
                    if (!freeEnt.getFavType().equals("0003")) {
                        wlanTimeTotal += freeEnt.getLongTotal();
                        wlanTimeUsed += longUsedTmp;
                        wlanTimeRemain += freeEnt.getLongRemain();
                        wlanTimeOut += (freeEnt.getLongTotal() < freeEnt.getLongUsed()) ? (freeEnt.getLongUsed() - freeEnt.getLongTotal()) : 0;
                    }

                } else if (unitCode.equals("4")) {

                    if (freeEnt.getFavType().equals("0003")) {

                    } else {
                        wlanGprsTotal += freeEnt.getLongTotal();
                        wlanGprsUsed += longUsedTmp;
                        wlanGprsRemain += freeEnt.getLongRemain();
                    }

                }

            } else if (busiCode.equals("7")) {
                mmsTotal += freeEnt.getLongTotal();
                mmsUsed += freeEnt.getLongUsed();
                mmsRemain += freeEnt.getLongRemain();
            } else if (busiCode.equals("8")) {
                cmwapTotal += freeEnt.getLongTotal();
                cmwapUsed += freeEnt.getLongUsed();
                cmwapRemain += freeEnt.getLongRemain();
            }
        }

        safeAddToMap(outFreeMap, "VOICE_TOTAL", voiceTotal);
        safeAddToMap(outFreeMap, "VOICE_USED", voiceUsed);
        safeAddToMap(outFreeMap, "VOICE_REMAIN", voiceRemain);

        safeAddToMap(outFreeMap, "SMS_TOTAL", smsTotal);
        safeAddToMap(outFreeMap, "SMS_USED", smsUsed);
        safeAddToMap(outFreeMap, "SMS_REMAIN", smsRemain);

        safeAddToMap(outFreeMap, "GPRSTIME_TOTAL", gprsTimeTotal);
        safeAddToMap(outFreeMap, "GPRSTIME_USED", gprsTimeUsed);
        safeAddToMap(outFreeMap, "GPRSTIME_REMAIN", gprsTimeRemain);

        gprsTotal = mealGprsTotal + addedGprsTotal;
        gprsUsed = mealGprsUsed + addedGprsUsed;
        gprsRemain = mealGprsRemain + addedGprsRemain;
        safeAddToMap(outFreeMap, "GPRS_TOTAL", gprsTotal);
        safeAddToMap(outFreeMap, "GPRS_USED", gprsUsed);
        safeAddToMap(outFreeMap, "GPRS_REMAIN", gprsRemain);

        safeAddToMap(outFreeMap, "MEAL_GPRS_TOTAL", mealGprsTotal);
        safeAddToMap(outFreeMap, "MEAL_GPRS_USED", mealGprsUsed);
        safeAddToMap(outFreeMap, "MEAL_GPRS_REMAIN", mealGprsRemain);

        safeAddToMap(outFreeMap, "ADDED_GPRS_TOTAL", addedGprsTotal);
        safeAddToMap(outFreeMap, "ADDED_GPRS_USED", addedGprsUsed);
        safeAddToMap(outFreeMap, "ADDED_GPRS_REMAIN", addedGprsRemain);


        safeAddToMap(outFreeMap, "WLAN_TIME_TOTAL", wlanTimeTotal);
        safeAddToMap(outFreeMap, "WLAN_TIME_USED", wlanTimeUsed);
        safeAddToMap(outFreeMap, "WLAN_TIME_REMAIN", wlanTimeRemain);
        safeAddToMap(outFreeMap, "WLAN_TIME_OUT", wlanTimeOut);

        safeAddToMap(outFreeMap, "WLAN_GPRS_TOTAL", wlanGprsTotal);
        safeAddToMap(outFreeMap, "WLAN_GPRS_USED", wlanGprsUsed);
        safeAddToMap(outFreeMap, "WLAN_GPRS_REMAIN", wlanGprsRemain);
        safeAddToMap(outFreeMap, "WLAN_GPRS_OUT", wlanGprsOut);

        safeAddToMap(outFreeMap, "MMS_TOTAL", mmsTotal);
        safeAddToMap(outFreeMap, "MMS_USED", mmsUsed);
        safeAddToMap(outFreeMap, "MMS_REMAIN", mmsRemain);

        safeAddToMap(outFreeMap, "CMWAP_TOTAL", cmwapTotal);
        safeAddToMap(outFreeMap, "CMWAP_USED", cmwapUsed);
        safeAddToMap(outFreeMap, "CMWAP_REMAIN", cmwapRemain);

        safeAddToMap(outFreeMap, "VPMN_TOTAL", vpmnTotal);
        safeAddToMap(outFreeMap, "VPMN_USED", vpmnUsed);
        safeAddToMap(outFreeMap, "VPMN_REMAIN", vpmnRemain);

        return outFreeMap;
    }

    @Override
    public Map<String, Long> getFamlilyFreeTotalMap(List<FreeMinBill> inFreeList, String chatFlag) {
        Map<String, Long> outFreeMap = new HashMap<>();

        long voiceTotal = 0;
        long voiceUsed = 0;
        long smsTotal = 0;
        long smsUsed = 0;
        long gprsTotal = 0; // 按kb统计的流量
        long gprsUsed = 0;
        long mmsTotal = 0;
        long mmsUsed = 0;
        long cmwapTotal = 0;
        long cmwapUsed = 0;

        Map<String, String> famPrcidMap = this.getFamilyChatPrcIdMap();
        String chatPrcId = this.getFamilyChatPrcId(famPrcidMap);

        String busiCode = "";
        for (FreeMinBill freeEnt : inFreeList) {
            busiCode = freeEnt.getBusiCode();
            String prcId = freeEnt.getProdPrcId();
            if (chatFlag.equals(CommonConst.FAMILY_CHAT_FLAG_YES) && prcId.equals(chatPrcId)) { // 随意畅聊业务
                if (busiCode.equals("1")) {
                    voiceTotal += freeEnt.getLongTotal();
                    voiceUsed += freeEnt.getLongUsed();
                }
            } else if (this.isFamlilyPrcId(prcId, chatFlag, famPrcidMap)
                    && !chatFlag.equals(CommonConst.FAMILY_CHAT_FLAG_YES) /* 非家庭畅聊，指亲情网业务ABC */
                    && !prcId.equals(chatPrcId)) {

                if (busiCode.equals("1")) { // 语音
                    voiceTotal += freeEnt.getLongTotal();
                    voiceUsed += freeEnt.getLongUsed();
                } else if (busiCode.equals("2")) { // 短信
                    smsTotal += freeEnt.getLongTotal();
                    smsUsed += freeEnt.getLongUsed();
                } else if (busiCode.equals("3")) { //GPRS
                    gprsTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    gprsUsed += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                } else if (busiCode.equals("7")) { // 彩信
                    mmsTotal += freeEnt.getLongTotal();
                    mmsUsed += freeEnt.getLongUsed();
                } else if (busiCode.equals("8")) { //CMWAP
                    mmsTotal += freeEnt.getLongTotal();
                    mmsUsed += freeEnt.getLongUsed();
                }
            }
        }


        safeAddToMap(outFreeMap, "VOICE_TOTAL", voiceTotal);
        safeAddToMap(outFreeMap, "VOICE_USED", voiceUsed);

        safeAddToMap(outFreeMap, "SMS_TOTAL", smsTotal);
        safeAddToMap(outFreeMap, "SMS_USED", smsUsed);

        safeAddToMap(outFreeMap, "GPRS_TOTAL", gprsTotal);
        safeAddToMap(outFreeMap, "GPRS_USED", gprsUsed);

        safeAddToMap(outFreeMap, "MMS_TOTAL", mmsTotal);
        safeAddToMap(outFreeMap, "MMS_USED", mmsUsed);

        safeAddToMap(outFreeMap, "CMWAP_TOTAL", cmwapTotal);
        safeAddToMap(outFreeMap, "CMWAP_USED", cmwapUsed);

        return outFreeMap;
    }

    @Override
    public Map<String, Long> getGprsFreeTotalMap(List<FreeMinBill> inFreeList) {


        long outGprsTotal = 0; // 套餐外总流量
        long grpSharedGprsTotal = 0; // 集团共享流量总量
        long grpSharedGprsUsed = 0; // 集团共享流量已使用量
        long grpSharedUnityUsed = 0; // 集团共享个人流量使用量
        long gprsTotal = 0; // 总流量 ，含 结转流量
        long gprsUsed = 0; // 总使用量，含 结转使用量
        long memberSharedTotal = 0; // 成员共享总量
        long memberSharedUsed = 0; // 成员共享已使用量
        long gprs3GTotal = 0;


        int curYm = DateUtils.getCurYm();

        for (FreeMinBill freeEnt : inFreeList) {
            String busiCode = freeEnt.getBusiCode();
            if (!busiCode.equals("3")) {
                continue;
            }

            String favCode = freeEnt.getFavCode();
            int queryYm = Integer.parseInt(freeEnt.getYearMonth());

            long longUsedTmp = 0;
            if (freeEnt.getLongTotal() < freeEnt.getLongUsed()) {
                longUsedTmp = freeEnt.getLongTotal();
            } else {
                longUsedTmp = freeEnt.getLongUsed();
            }

            if (freeEnt.getFavType().equals("0002")) {
                outGprsTotal += freeEnt.getLongUsed(); // 套餐外流量
            } else {

                if (favCode.equals("e")) {
                    // 集团共享集团部分
                    if (queryYm == curYm) {
                        grpSharedGprsTotal += freeEnt.getLongTotal();
                    }
                    grpSharedGprsUsed += longUsedTmp;
                } else if (favCode.equals("f")) {
                    // 集团共享个人部分
                    if (queryYm == curYm) {
                        grpSharedGprsTotal += freeEnt.getLongTotal();
                    }
                    grpSharedUnityUsed += longUsedTmp;
                } else if (favCode.equals("1")) {
                    memberSharedTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    memberSharedUsed += longUsedTmp + freeEnt.getLongLastUsed();
                } else {
                    gprsTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    gprsUsed += longUsedTmp + freeEnt.getLongLastUsed();

                    if (!this.is4GPrcId(freeEnt.getProdPrcId())) {
                        gprs3GTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    }

                }
            }
        }


        //组装Map内容
        Map<String, Long> outFreeMap = new HashMap<>();
        safeAddToMap(outFreeMap, "OUT_GPRS_TOTAL", outGprsTotal);
        safeAddToMap(outFreeMap, "GRP_SHARED_TOTAL", grpSharedGprsTotal);
        safeAddToMap(outFreeMap, "GRP_SHARED_USED", grpSharedGprsUsed);
        safeAddToMap(outFreeMap, "GRP_SHARED_UNITY_USED", grpSharedUnityUsed);
        safeAddToMap(outFreeMap, "MBR_SHARED_TOTAL", memberSharedTotal);
        safeAddToMap(outFreeMap, "MBR_SHARED_USED", memberSharedUsed);
        safeAddToMap(outFreeMap, "GPRS_TOTAL", gprsTotal);
        safeAddToMap(outFreeMap, "GPRS_USED", gprsUsed);
        safeAddToMap(outFreeMap, "GPRS_3G_TOTAL", gprs3GTotal);

        return outFreeMap;
    }

    private boolean isSpecifiedPrcId(String checkRateCode, List<String> sourceList) {
        boolean flag = false;

        if (sourceList == null || sourceList.isEmpty()) {
            flag = false;
        } else {
            for (String tmpStr : sourceList) {
                if (checkRateCode.equals(tmpStr)) {
                    flag = true;
                    break;
                }
            }
        }

        return flag;
    }

    /**
     * 功能：获取单位名称
     *
     * @param unitcode
     * @param busicode
     * @return
     */
    private String getUnitName(String unitcode, String busicode) {
        String unitname = null;

        if ("1".equals(unitcode)) {
            unitname = "条";
        } else if ("2".equals(unitcode)) {
            unitname = "6秒";
        } else if ("3".equals(unitcode)) {
            unitname = "分钟";
        } else if ("4".equals(unitcode)) {
            unitname = "KB";
        } else {
            unitname = "此单位[" + unitcode + "]未定义";
        }

        return unitname;
    }

    /**
     * 功能：获取业务代码名称
     *
     * @param busicode
     * @return
     */
    private String getBusiName(String busicode) {
        Map<String, String> map = new HashMap<String, String>();

        safeAddToMap(map, "0", "所有业务");
        safeAddToMap(map, "1", "语音业务");
        safeAddToMap(map, "2", "短信业务");
        safeAddToMap(map, "3", "GPRS业务");
        safeAddToMap(map, "4", "VPMN业务");
        safeAddToMap(map, "5", "WLAN业务");
        safeAddToMap(map, "6", "国际漫游业务");
        safeAddToMap(map, "7", "彩信业务");
        safeAddToMap(map, "8", "CMWAP业务");
        safeAddToMap(map, "R", "结转流量");
        safeAddToMap(map, "Y", "统付业务");
        safeAddToMap(map, "U", "4G共享GPRS业务");
        safeAddToMap(map, "V", "4G共享GPRS业务");
        safeAddToMap(map, "W", "4G共享GPRS业务");
        safeAddToMap(map, "T", "4G共享GPRS业务");

        return getString(map, busicode);
    }

    /**
     * 功能：获取优惠类型名称
     *
     * @param favType 优惠类型 //@param freeIndex
     * @param favCode 优惠类别
     * @return
     */
    private String getFavTypeName(String favType, String favCode) {
        String string1 = "--";

        // TODO 需要确定favtype名称的取法
        if (favType.equals("0002")) {
            string1 = "套餐外使用";
        } else if (favType.equals("0003")) {
            string1 = "套餐内优惠";
        }

        return string1;
    }

    /**
     * 功能：获取资费优先级
     *
     * @param pdProdPrcId
     * @return
     */
    private Integer getPrcIdPriority(String busiCode, String pdProdPrcId, String regionCode) {
        Integer priority = 0;
        if (busiCode.equals("3")) {
            priority = billAccount.getGprsMinOrder(pdProdPrcId, regionCode);
            if (priority == null) {
                priority = 0;
            }
        } else if (busiCode.equals("5")) {
            priority = billAccount.getWlanOrder(pdProdPrcId, regionCode);
            if (priority == null) {
                priority = 0;
            }
        }

        return priority;
    }

    @Override
    public boolean is4GPrcId(String prcId) {
        /* //老表从SOFFERID_ONLY4G从数据，不准确
        long codeClass = 1044; // 4G资费配置
        String codeId = prcId;
        List<PubCodeDictEntity> pubValueList = control.getPubCodeList(codeClass, codeId, null, null);
        return pubValueList.size() > 0 ? true : false;*/

        PdPrcInfoEntity prcInfo = prod.getPdPrcInfo(prcId);
        return prcInfo == null ? false : (prcInfo.getUseRange().charAt(6) == '1' ? true : false);
    }

    /**
     * 判断资费是否是家庭共享资费
     *
     * @param prcId
     * @param chatFlag    畅聊标识 ，这里传0
     * @param famPrcidMap
     * @return
     */
    private boolean isFamlilyPrcId(String prcId, String chatFlag, Map<String, String> famPrcidMap) {
        boolean flag = false;
        String key = new StringBuilder().append(prcId).append("^").append(chatFlag).toString();
        if (famPrcidMap.containsKey(key)) {
            flag = true;
        }

        return flag;
    }

    private Map<String, String> getFamilyChatPrcIdMap() {
        Map<String, String> prcIdMap = new HashMap<>();
        long codeClass = 1043;

        List<PubCodeDictEntity> pubValueList = control.getPubCodeList(codeClass, null, null, null);
        for (PubCodeDictEntity pubValue : pubValueList) {
            String key = pubValue.getCodeId() + "^" + pubValue.getStatus();
            if (!prcIdMap.containsKey(key)) {
                prcIdMap.put(key, pubValue.getCodeId());
            }
        }

        return prcIdMap;
    }

    /**
     * 获取家庭畅聊套餐的资费ID
     *
     * @param famPrcidMap
     * @return
     */
    private String getFamilyChatPrcId(Map<String, String> famPrcidMap) {
        String chatPrcId = "";
        for (String key : famPrcidMap.keySet()) {
            String chatFlag = key.split("\\^")[1];
            if (chatFlag.equals(CommonConst.FAMILY_CHAT_FLAG_YES)) { // 畅聊标识为1
                chatPrcId = famPrcidMap.get(key);
                break;
            }
        }
        return chatPrcId;
    }

    /**
     * 功能：判断资费是否是gprs叠加包
     */
    @Override
    public boolean isAddedGprs(String prcId) {
        // 这两个资费ID是叠加包的固定资费；//TODO CRM定下资费代码后需要做对应
        // 后续这两值配置到 pub_codedef_dict表中
        long codeClass = 1045; // 流量叠加包资费
//        String codeId = String.format("%d", prcId);
        String codeId = prcId;
        List<PubCodeDictEntity> pubValueList = control.getPubCodeList(codeClass, codeId, null, null);
        return pubValueList.size() > 0 ? true : false;
    }

    @Override
    public PubCodeDictEntity getFamPrcIdInfo(String prcId) {
        long codeClass = 1043; // 家庭资费配置
//        String codeId = String.format("%d", prcId);
        String codeId = prcId;
        List<PubCodeDictEntity> pubValueList = control.getPubCodeList(codeClass, codeId, null, null);
        return pubValueList.size() > 0 ? pubValueList.get(0) : null;
    }

    @Override
    public List<FamilyFreeFeeUserEntity> getFamilyFreeFeeList(String phoneNo, int queryYm) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "PHONE_NO", phoneNo);
        safeAddToMap(inMap, "YEAR_MONTH", String.format("%6d", queryYm));
        List<FamilyFreeFeeUserEntity> result = baseDao.queryForList("remind_month_free_fee_user.qryFamilyFreeInfo", inMap);
        return result;
    }

    @Override
    public Map<String, Long> getFreeClassMap(List<FreeMinBill> inFreeList) {
        // 流量分类信息汇总   favClass
        long outGprsTotal = 0;// 套餐外流量
        long gprsTotal = 0;
        long gprsUsed = 0;
        long gprsRemain = 0;

        for (FreeMinBill freeEnt : inFreeList) {
            String busiCode = freeEnt.getBusiCode();
            String favCode = freeEnt.getFavCode();

            long longUsedTmp = 0;

            if (freeEnt.getLongTotal() < freeEnt.getLongUsed()) {
                longUsedTmp = freeEnt.getLongTotal();
            } else {
                longUsedTmp = freeEnt.getLongUsed();
            }
            if (busiCode.equals("3")) {
                if (favCode.equals("0002")) {
                    outGprsTotal += freeEnt.getLongUsed();
                } else if (!favCode.equals("e") || !favCode.equals("f") || !favCode.equals("1")) {
                    gprsTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    gprsUsed += longUsedTmp + freeEnt.getLongLastUsed();
                    gprsRemain += freeEnt.getLongRemain() + freeEnt.getLongLastRemain();
                }
            }
        }

        Map<String, Long> outMap = new HashMap<>();
        safeAddToMap(outMap, "GPRS_TOTAL", gprsTotal); //MapUtils.
        safeAddToMap(outMap, "GPRS_REMAIN", gprsRemain);
        safeAddToMap(outMap, "GPRS_USED", gprsUsed);
        safeAddToMap(outMap, "OUT_GPRS", outGprsTotal);
        return outMap;
    }

    public IControl getControl() {
        return control;
    }

    public void setControl(IControl control) {
        this.control = control;
    }

    public IProd getProd() {
        return prod;
    }

    public void setProd(IProd prod) {
        this.prod = prod;
    }

    public IBillAccount getBillAccount() {
        return billAccount;
    }

    public void setBillAccount(IBillAccount billAccount) {
        this.billAccount = billAccount;
    }

    public IGroup getGroup() {
        return group;
    }

    public void setGroup(IGroup group) {
        this.group = group;
    }

    public IUser getUser() {
        return user;
    }

    public void setUser(IUser user) {
        this.user = user;
    }
}
