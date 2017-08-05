package com.sitech.acctmgr.atom.impl.free;

import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.cust.GrpCustInfoEntity;
import com.sitech.acctmgr.atom.domains.cust.GrpUserInfoEntity;
import com.sitech.acctmgr.atom.domains.free.*;
import com.sitech.acctmgr.atom.domains.query.FreeMinBill;
import com.sitech.acctmgr.atom.domains.record.ActQueryOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserGroupMbrEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserPrcEntity;
import com.sitech.acctmgr.atom.domains.user.UsersvcAttrEntity;
import com.sitech.acctmgr.atom.dto.free.*;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.DateComparator;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.common.utils.UnitUtils;
import com.sitech.acctmgr.inter.free.IFree;
import com.sitech.acctmgrint.atom.busi.intface.IShortMessage;
import com.sitech.billing.qdetail.common.util.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

import java.util.*;

import static org.apache.commons.collections.MapUtils.getString;

/**
 * Created by wangyla on 2016/7/13.
 */
@ParamTypes({@ParamType(c = SFreeCarryOverQueryInDTO.class, m = "carryOverQuery", oc = SFreeCarryOverQueryOutDTO.class),
        @ParamType(c = SFreeFlowDetailQueryInDTO.class, m = "flowDetailQuery", oc = SFreeFlowDetailQueryOutDTO.class),
        @ParamType(c = SFreeWlanDetailQueryInDTO.class, m = "wlanDetailQuery", oc = SFreeWlanDetailQueryOutDTO.class),
        @ParamType(c = SFreeUserFreeQueryInDTO.class, m = "userFreeQuery", oc = SFreeUserFreeQueryOutDTO.class),
        @ParamType(c = SFreeGprsQueryInDTO.class, m = "gprsQuery", oc = SFreeGprsQueryOutDTO.class),
        @ParamType(c = SFreeVpmnQueryInDTO.class, m = "vpmnQuery", oc = SFreeVpmnQueryOutDTO.class),
        @ParamType(c = SFreeShareQueryInDTO.class, m = "shareQuery", oc = SFreeShareQueryOutDTO.class),
        @ParamType(c = SFreeChoiceQueryInDTO.class, m = "choiceQuery", oc = SFreeChoiceQueryOutDTO.class),
        @ParamType(c = SFreeAllQueryInDTO.class, m = "allQuery", oc = SFreeAllQueryOutDTO.class),
        @ParamType(c = SFreeAverageGprsQueryInDTO.class, m = "averageGprsQuery", oc = SFreeAverageGprsQueryOutDTO.class),
        @ParamType(c = SFreeClassQueryInDTO.class, m = "classQuery", oc = SFreeClassQueryOutDTO.class),
        @ParamType(c = SFreeDayQueryInDTO.class, m = "dayQuery", oc = SFreeDayQueryOutDTO.class),
        @ParamType(c = SFreeSmsQueryInDTO.class, m = "smsQuery", oc = SFreeSmsQueryOutDTO.class)})
public class SFree extends AcctMgrBaseService implements IFree {
    private IFreeDisplayer freeDisplayer;
    private IUser user;
    private ICust cust;
    private ILogin login;
    private IProd prod;
    private IBillAccount billAccount;
    private IRecord record;
    private IPreOrder preOrder;
    private IControl control;
    private IGroup group;
    private IShortMessage shortMessage;
    private IGoods goods;

    private final static String GPRS_UNIT_KB = "KB";
    private final static String GPRS_UNIT_MB = "MB";
    private final static String GPRS_UNIT_GB = "GB";


    @Override
    public OutDTO carryOverQuery(InDTO inParam) {
        SFreeCarryOverQueryInDTO inDTO = (SFreeCarryOverQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        String phoneNo = inDTO.getPhoneNo();
        int queryYm = inDTO.getYearMonth();
        //补充用户流量资费名称列表获取
        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        List<String> gprsNameList = new ArrayList<>();
        gprsNameList = prod.getGprsPrcNameList(userInfo.getIdNo());

        List<CarryOverGPRSEntity> carryInfoList = new ArrayList<>();
        List<FreeMinBill> freeDetailList = freeDisplayer.getFreeDetailList(phoneNo, queryYm, "R");
        for (FreeMinBill freeEnt : freeDetailList) {
            String favCode = freeEnt.getFavCode();
            if (freeEnt.getBusiCode().equals("R") && freeEnt.getLongLastTotal() > 0) {
                StringBuilder sb = new StringBuilder(freeEnt.getProdPrcName());
                if (favCode.equals("1")) {
                    sb.append("内闲时");
                } else if (favCode.equals("2")) {
                    sb.append("内国内");
                } else if (favCode.equals("3")) {
                    sb.append("内省内");
                }

                CarryOverGPRSEntity carryEnt = new CarryOverGPRSEntity();
                carryEnt.setTotal(String.format("%.2f", freeEnt.getLongLastTotal() / 1024.0));
                carryEnt.setUsed(String.format("%.2f", freeEnt.getLongLastUsed() / 1024.0));
                carryEnt.setUnitName("MB");
                carryEnt.setProductName(sb.toString());

                carryInfoList.add(carryEnt);
            }
        }

        SFreeCarryOverQueryOutDTO outDTO = new SFreeCarryOverQueryOutDTO();
        outDTO.setGprsNameList(gprsNameList);
        outDTO.setCarryInfoList(carryInfoList);

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    @Override
    public OutDTO flowDetailQuery(InDTO inParam) {
        SFreeFlowDetailQueryInDTO inDTO = (SFreeFlowDetailQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());
        List<FlowDetailEntity> flowList = this.getFlowDetail(inDTO.getPhoneNo(), inDTO.getYearMonth());
        SFreeFlowDetailQueryOutDTO outDTO = new SFreeFlowDetailQueryOutDTO();
        outDTO.setFlowList(flowList);

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;

    }

    private List<FlowDetailEntity> getFlowDetail(String phoneNo, int queryYm) {
        List<FlowDetailEntity> outList = new ArrayList<>();

        UserInfoEntity uie = user.getUserEntityByPhoneNo(phoneNo, true);
        long idNo = uie.getIdNo();

        List<FreeMinBill> freeDetailList = freeDisplayer.getFreeDetailList(phoneNo, queryYm, "Y");
        for (FreeMinBill freeEnt : freeDetailList) {
            if (!freeEnt.getBusiCode().equals("Y")) {
                continue;
            }

            FlowDetailEntity flowEnt = new FlowDetailEntity();
            String sceneName = "";
            String flowType = "";
            String productName = "";
            String flowName = "";
            String favType = freeEnt.getFavType();
            if (favType.startsWith("j")) {
                sceneName = "全时段，";
            } else if (favType.startsWith("J")) {
                sceneName = "闲时，";
            }

            //产品名称的获取
            UsersvcAttrEntity uae = user.getUsersvcAttr(idNo, "23B201475");
            productName = uae != null ? uae.getAttrValue() : "未知";
            uae = user.getUsersvcAttr(idNo, "23B201443,23B201475");
            flowName = uae != null ? uae.getAttrValue() : "未知";

            String favCode = freeEnt.getFavCode();
            StringBuilder sb = new StringBuilder();
            StringBuilder sb2 = new StringBuilder();
            if (favCode.equals("0")) {
                sb.append(sceneName).append("定向流量，指定用户，全量统付");
                sb2.append(productName).append("业务专属流量统付");
                favType = "j";
                flowType = "1";
            } else if (favCode.equals("1")) {
                sb.append(sceneName).append("定向流量，指定用户，全量统付");
                sb2.append(productName).append("业务专属流量统付");
                favType = "j";
                flowType = "1";
            } else if (favCode.equals("2")) {
                sb.append(sceneName).append("通用流量，指定用户，限量统付");
                sb2.append(productName).append("通用流量统付");
                favType = "j";
                flowType = "0";
            } else if (favCode.equals("3")) {
                sb.append(sceneName).append("通用流量，指定用户，全量统付");
                sb2.append(productName).append("通用流量统付");
                favType = "j";
                flowType = "0";
            } else if (favCode.equals("4")) {
                sb.append(sceneName).append("定向流量，不限用户，限量统付");
                sb2.append(productName).append("业务专属流量统付");
                favType = "J";
                flowType = "1";
            } else if (favCode.equals("5")) {
                sb.append(sceneName).append("定向流量， 不限用户，全量统付");
                sb2.append(productName).append("业务专属流量统付");
                favType = "J";
                flowType = "1";
            } else if (favCode.equals("a")) {
                sb.append(sceneName).append("定向流量，指定用户，定额统付");
                sb2.append(productName).append("业务专属流量统付");
                favType = "j";
                flowType = "1";
            } else if (favCode.equals("c")) {
                sb.append(sceneName).append("通用流量，指定用户，定额统付");
                sb2.append(productName).append("通用流量统付");
                favType = "j";
                flowType = "0";
            }

            sceneName = sb.toString();
            productName = sb2.toString();

            long total = freeEnt.getLongTotal();
            long used = freeEnt.getLongUsed();

            if ("1".equals(flowType) && used <= 0) {
                continue;
            }

            String percent = "--";
            if (total > 0) {
                percent = String.format("%.2f%%", used * 1.0 * 100 / total);
            }

            flowEnt.setSceneName(sceneName);
            flowEnt.setProductName(productName);
            flowEnt.setFavType(favType);
            flowEnt.setProductId(freeEnt.getProductId());
            flowEnt.setTotal(String.format("%.2f", total * 1.0 / 1024));
            flowEnt.setUsed(String.format("%.2f", used * 1.0 / 1024));
            flowEnt.setUnitName("MB");
            flowEnt.setPercent(percent);
            flowEnt.setFlowName(flowName);

            outList.add(flowEnt);
        }

        return outList;
    }

    @Override
    public OutDTO wlanDetailQuery(InDTO inParam) {
        SFreeWlanDetailQueryInDTO inDTO = (SFreeWlanDetailQueryInDTO) inParam;
        log.debug("inDto= " + inDTO.getMbean());
        String phoneNo = inDTO.getPhoneNo();
        List<FreeMinBill> freeDetailList = freeDisplayer.getFreeDetailList(phoneNo, inDTO.getYearMonth(), "5");
        if (freeDetailList == null || freeDetailList.isEmpty()) {
            throw new BusiException(AcctMgrError.getErrorCode("8123", "20001"), "用户无优惠信息！");
        }

        Map<String, FreeUseInfoEntity> freeTotalMap = freeDisplayer.getFreeTotalInfo(freeDetailList);

        FreeUseInfoEntity wlanTime = new FreeUseInfoEntity();
        FreeUseInfoEntity wlanGprs = new FreeUseInfoEntity();
        for (String key : freeTotalMap.keySet()) {
            String unitCode = key.split("\\^")[1];
            if (unitCode.equals("3")) {
                wlanTime = freeTotalMap.get(key);
                wlanTime.setTotal(String.format("%d", wlanTime.getLongTotal()));
                wlanTime.setUsed(String.format("%d", wlanTime.getLongUsed()));
                wlanTime.setRemain(String.format("%d", wlanTime.getLongRemain()));
            } else if (unitCode.equals("4")) {
                wlanGprs = freeTotalMap.get(key);
                wlanGprs.setTotal(String.format("%.2f", wlanGprs.getLongTotal() / 1024.0));
                wlanGprs.setUsed(String.format("%.2f", wlanGprs.getLongUsed() / 1024.0));
                wlanGprs.setRemain(String.format("%.2f", wlanGprs.getLongRemain() / 1024.0));
                wlanGprs.setUnitName("MB");
            }
        }

        List<FreeDetailEntity> freeList = this.getMealFreeList(freeDetailList, GPRS_UNIT_MB);

        SFreeWlanDetailQueryOutDTO outDTO = new SFreeWlanDetailQueryOutDTO();
        outDTO.setWlanTime(wlanTime);
        outDTO.setWlanGprs(wlanGprs);
        outDTO.setWlanList(freeList);

        log.debug("outDto= " + outDTO.toJson());
        return outDTO;
    }

    @Override
    public OutDTO userFreeQuery(InDTO inParam) {
        SFreeUserFreeQueryInDTO inDTO = (SFreeUserFreeQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        String loginNo = inDTO.getLoginNo();
        String loginGroup = inDTO.getGroupId();
        if (StringUtils.isEmpty(loginGroup) && StringUtils.isNotEmpty(loginNo)) {
            LoginEntity loginInfo = login.getLoginInfo(loginNo, inDTO.getProvinceId());
            loginGroup = loginInfo.getGroupId();
        }

        String phoneNo = inDTO.getPhoneNo();
        UserInfoEntity userInfo = user.getUserInfo(phoneNo);
        long idNo = userInfo.getIdNo();
        long contractNo = userInfo.getContractNo();

        String regionCode = group.getRegionDistinct(loginGroup, "2", inDTO.getProvinceId()).getRegionCode();

        List<FreeMinBill> freeDetailList = freeDisplayer.getFreeDetailList(phoneNo, inDTO.getYearMonth(), "0");
        List<FreeMinBill> mealFreeList = new ArrayList<>();
        for (FreeMinBill freeEnt : freeDetailList) {
            String busiCode = freeEnt.getBusiCode();

            if (freeEnt.getFavType().equals("0002")) {
                continue;
            }

            if (busiCode.equals("1") || busiCode.equals("2") || busiCode.equals("3")
                    || busiCode.equals("4") || busiCode.equals("7") || busiCode.equals("8")) {
                mealFreeList.add(freeEnt);
            }
        }

        //主套餐对应的二批资费列表，供获取主套餐内资费流量信息获取
        List<String> rateCodeList = new ArrayList<>();
        UserPrcEntity mainPrcInfo = prod.getUserPrcidInfo(idNo, false);
        if (mainPrcInfo != null) {
            rateCodeList = billAccount.getRateCode(mainPrcInfo.getProdPrcid(), "0", regionCode); //detail_type='0'
        }
        // 获取优惠信息汇总信息
        Map<String, Long> freeMap = freeDisplayer.getFreeTotalMap(freeDetailList, rateCodeList);

        List<FreeDetailEntity> freeList = this.getMealFreeList(mealFreeList, GPRS_UNIT_KB);

        /*记录查询日志，并发送统一接触*/
        long querySn = control.getSequence("seq_system_sn");
        ActQueryOprEntity oprEntity = new ActQueryOprEntity();
        oprEntity.setQuerySn(querySn);
        oprEntity.setQueryType("0");
        oprEntity.setOpCode(inDTO.getOpCode());
        oprEntity.setContactId(String.format("%d", contractNo));
        oprEntity.setIdNo(idNo);
        oprEntity.setPhoneNo(phoneNo);
        oprEntity.setBrandId(userInfo.getBrandId());
        oprEntity.setLoginNo(inDTO.getLoginNo());
        oprEntity.setLoginGroup(loginGroup);
        oprEntity.setProvinceId(inDTO.getProvinceId());
        oprEntity.setHeader(inDTO.getHeader());
        oprEntity.setRemark("用户优惠信息查询");
        record.saveQueryOpr(oprEntity, false);

        /*需要下发统一操作接触，给用户做满意度调查，下发短信*/
        Map<String, Object> queryInfoMap = new HashMap<String, Object>();
        queryInfoMap.put("Header", inDTO.getHeader());

        //报文OPR_INFO节点内容
        queryInfoMap.put("PAY_SN", querySn);
        queryInfoMap.put("LOGIN_NO", inDTO.getLoginNo());
        queryInfoMap.put("GROUP_ID", inDTO.getGroupId());
        queryInfoMap.put("OP_CODE", inDTO.getOpCode());
        queryInfoMap.put("REGION_ID", regionCode);
        queryInfoMap.put("OP_NOTE", "用户优惠信息查询");
        queryInfoMap.put("CUST_ID_TYPE", "1");
        queryInfoMap.put("CUST_ID_VALUE", phoneNo);
        queryInfoMap.put("OP_TIME", DateUtils.getCurDate(DateUtils.DATE_FORMAT_YYYYMMDDHHMISS));
        queryInfoMap.put("ID_NO", idNo);
        queryInfoMap.put("CONTRACT_NO", contractNo);
        preOrder.sendOprCntt(queryInfoMap);

        SFreeUserFreeQueryOutDTO outDTO = new SFreeUserFreeQueryOutDTO();
        outDTO.setBrandName(userInfo.getBrandName());
        outDTO.setSmsTotal(freeMap.get("SMS_TOTAL"));
        outDTO.setSmsUsed(freeMap.get("SMS_USED"));
        outDTO.setMmsTotal(freeMap.get("MMS_TOTAL"));
        outDTO.setMmsUsed(freeMap.get("MMS_USED"));
        outDTO.setVoiceTotal(freeMap.get("VOICE_TOTAL"));
        outDTO.setVoiceUsed(freeMap.get("VOICE_USED"));
        outDTO.setVpmnTotal(freeMap.get("VPMN_TOTAL"));
        outDTO.setVpmnUsed(freeMap.get("VPMN_USED"));
        outDTO.setVpmnRemain(freeMap.get("VPMN_REMAIN"));
        outDTO.setCmwapTotal(freeMap.get("CMWAP_TOTAL"));
        outDTO.setCmwapUsed(freeMap.get("CMWAP_USED"));
        outDTO.setMealGprsTotal(freeMap.get("MEAL_GPRS_TOTAL"));
        outDTO.setMealGprsUsed(freeMap.get("MEAL_GPRS_USED"));
        outDTO.setAddedGprsTotal(freeMap.get("ADDED_GPRS_TOTAL"));
        outDTO.setAddedGprsUsed(freeMap.get("ADDED_GPRS_USED"));
        outDTO.setGprsTotal(freeMap.get("GPRS_TOTAL"));
        outDTO.setGprsUsed(freeMap.get("GPRS_USED"));
        outDTO.setFreeList(freeList);

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    @Override
    public OutDTO gprsQuery(InDTO inParam) {
        SFreeGprsQueryInDTO inDTO = (SFreeGprsQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        String phoneNo = inDTO.getPhoneNo();
        int queryYm = inDTO.getYearMonth();

        int curYm = DateUtils.getCurYm();

        long outGprsTotal = 0; // 套餐外总流量
        long grpSharedGprsTotal = 0; // 集团共享流量总量
        long grpSharedGprsUsed = 0; // 集团共享流量已使用量
        long grpSharedUnityUsed = 0; // 集团共享个人流量使用量
        long gprsTotal = 0; // 总流量 ，含 结转流量
        long gprsUsed = 0; // 总使用量，含 结转使用量
        long vpmnTotal = 0; // vpmn 总优惠量
        long vpmnUsed = 0; // vpmn 总使用量
        long memberSharedTotal = 0; // 成员共享总量
        long memberSharedUsed = 0; // 成员共享已使用量
        long gprs3GTotal = 0;
        String flowFlag = "0";
        String gprsTypeFlag = "0"; // 流量类型
        boolean usedUpFlag = false;

        UserInfoEntity uie = user.getUserEntityByPhoneNo(phoneNo, true);
        long idNo = uie.getIdNo();
        long contractNo = uie.getContractNo();
        String brandId = uie.getBrandId();

        /**
         * 1、明细列表返回时，本月流量和结转流量的明细要分开展示； 2、流量加油包需要合并展示，如资费名称（加油包个数）
         * 3、需要返回3G流量问题，供CRM使用
         */
        List<FreeDetailEntity> freeList = new ArrayList<>();
        List<FreeMinBill> gprsAddedList = new ArrayList<>(); // 流量叠加包资费明细列表
        List<FreeMinBill> gprsMealList = new ArrayList<>(); // 套餐内流量明细列表
        List<FreeMinBill> freeDetailList = freeDisplayer.getFreeDetailList(phoneNo, queryYm, "0");
        if (freeDetailList == null || freeDetailList.isEmpty()) {
            throw new BusiException(AcctMgrError.getErrorCode("8123", "20001"), "用户无优惠信息！");
        }

        for (FreeMinBill freeEnt : freeDetailList) {
            String busiCode = freeEnt.getBusiCode();
            String favCode = freeEnt.getFavCode();

            long longUsedTmp = 0;
            if (freeEnt.getLongTotal() < freeEnt.getLongUsed()) {
                longUsedTmp = freeEnt.getLongTotal();
                usedUpFlag = true;
            } else {
                longUsedTmp = freeEnt.getLongUsed();
                usedUpFlag = false;
            }
            if (busiCode.equals("3")) {
                if (freeEnt.getFavType().equals("0002")) {
                    outGprsTotal += freeEnt.getLongUsed(); // 套餐外流量
                } else {

                    if (favCode.equals("e")) {
                        // 集团共享集团部分
                        if (queryYm == curYm) {
                            grpSharedGprsTotal += freeEnt.getLongTotal();
                            gprsTypeFlag = usedUpFlag ? "1" : "0";
                        }
                        grpSharedGprsUsed += longUsedTmp;
                    } else if (favCode.equals("f")) {
                        // 集团共享个人部分
                        if (queryYm == curYm) {
                            grpSharedGprsTotal += freeEnt.getLongTotal();
                            gprsTypeFlag = usedUpFlag ? "1" : "0";
                        }
                        grpSharedUnityUsed += longUsedTmp;
                    } else if (favCode.equals("1")) {
                        memberSharedTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                        memberSharedUsed += longUsedTmp + freeEnt.getLongLastUsed();
                    } else {
                        gprsTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                        gprsUsed += longUsedTmp + freeEnt.getLongLastUsed();

                        if (!freeDisplayer.isAddedGprs(freeEnt.getProdPrcId())) {
                            // 套餐内流量，非叠加包
                            gprsMealList.add(freeEnt);
                        } else {
                            // 套餐外流量叠加包，明细展示时按资费合并
                            gprsAddedList.add(freeEnt);

                        }

                        if (!freeDisplayer.is4GPrcId(freeEnt.getProdPrcId())) {
                            gprs3GTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                        }

                    }

                }
            }

            if (busiCode.equals("4")) {
                vpmnTotal += freeEnt.getLongTotal();
                vpmnUsed += freeEnt.getLongUsed();
            }

            if (busiCode.equals("Y")) {
                if (favCode.equals("2") || favCode.equals("3") || favCode.equals("c")) {
                    gprsTotal += freeEnt.getLongTotal();
                    gprsUsed += freeEnt.getLongUsed();

                    if (flowFlag.equals("0")) {
                        flowFlag = "1";
                    }
                }
            }
        }

        freeList.addAll(getMealFreeList(gprsMealList, GPRS_UNIT_GB));
        freeList.addAll(getAddedFreeList(gprsAddedList, GPRS_UNIT_GB));

        {
            this.sendMsg(idNo, inDTO.getLoginNo(), inDTO.getOpCode(), phoneNo);

            ActQueryOprEntity oprEntity = new ActQueryOprEntity();
            oprEntity.setQueryType("gprs");
            oprEntity.setOpCode(inDTO.getOpCode());
            oprEntity.setContactId(String.format("%d", contractNo));
            oprEntity.setIdNo(idNo);
            oprEntity.setPhoneNo(phoneNo);
            oprEntity.setBrandId(brandId);
            oprEntity.setLoginNo(inDTO.getLoginNo());
            oprEntity.setLoginGroup(inDTO.getGroupId());
            oprEntity.setProvinceId(inDTO.getProvinceId());
            oprEntity.setHeader(inDTO.getHeader());
            oprEntity.setRemark("套餐优惠推荐短信下发");
            record.saveQueryOpr(oprEntity, false);
        } //这块发短信和记日志顺序不可对调

        SFreeGprsQueryOutDTO outDTO = new SFreeGprsQueryOutDTO();

        outDTO.setOutGprsTotal(String.format("%.2f", outGprsTotal / 1024.0));
        outDTO.setGprs3GTotal(String.format("%.2f", gprs3GTotal / 1024.0));
        outDTO.setFlowFlag(flowFlag);
        outDTO.setGprsTypeFlag(gprsTypeFlag);
        outDTO.setGprsTotal(String.format("%.2f", gprsTotal / 1024.0));
        outDTO.setGprsUsed(String.format("%.2f", gprsUsed / 1024.0));
        outDTO.setGprsRemain(String.format("%.2f", (gprsTotal - gprsUsed) / 1024.0));
        outDTO.setVpmnTotal(String.format("%d", vpmnTotal));
        outDTO.setVpmnUsed(String.format("%d", vpmnUsed));
        outDTO.setVpmnRemain(String.format("%d", (vpmnTotal - vpmnUsed)));
        outDTO.setGrpSharedGprsTotal(String.format("%.2f", grpSharedGprsTotal / 1024.0));
        outDTO.setGrpSharedGprsUsed(String.format("%.2f", grpSharedGprsUsed / 1024.0));
        outDTO.setGrpSharedUnityUsed(String.format("%.2f", grpSharedUnityUsed / 1024.0));
        outDTO.setMemberFlag(memberSharedTotal > 0 ? "0" : "1");
        outDTO.setMemberSharedUsed(String.format("%.2f", memberSharedUsed / 1024.0));
        outDTO.setMemberSharedRemain(String.format("%.2f", (memberSharedTotal - memberSharedUsed) / 1024.0));
        outDTO.setUnitName("GB");
        outDTO.setFreeList(freeList);

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    private List<FreeDetailEntity> getMealFreeList(List<FreeMinBill> inFreeList, String gprsUnit) {
        List<FreeDetailEntity> outList = new ArrayList<>();

        for (FreeMinBill freeEnt : inFreeList) {
            long longUsedTmp = (freeEnt.getLongTotal() < freeEnt.getLongUsed()) ? freeEnt.getLongTotal() : freeEnt.getLongUsed();
            FreeDetailEntity freeDetailEnt = new FreeDetailEntity();
            freeDetailEnt.setBusiCode(freeEnt.getBusiCode());
            freeDetailEnt.setBusiName(freeEnt.getBusiName());
            freeDetailEnt.setTotal(freeEnt.getTotal());
            freeDetailEnt.setLongTotal(freeEnt.getLongTotal());
            freeDetailEnt.setUsed(String.format("%d", longUsedTmp));
            freeDetailEnt.setLongUsed(longUsedTmp);
            freeDetailEnt.setRemain(freeEnt.getRemain());
            freeDetailEnt.setLongRemain(freeEnt.getLongRemain());
            freeDetailEnt.setFavType(freeEnt.getFavType());
            freeDetailEnt.setPriority(String.valueOf(freeEnt.getPriority()));
            freeDetailEnt.setProdPrcidName(freeEnt.getProdPrcName());
            freeDetailEnt.setProdPrcId(freeEnt.getProdPrcId());
            freeDetailEnt.setUnit(freeEnt.getUnitCode());
            freeDetailEnt.setUnitName(freeEnt.getUnitName());
            freeDetailEnt.setCarryFlag("N");
            outList.add(freeDetailEnt);

            if (freeEnt.getLongLastTotal() > 0) {
                FreeDetailEntity lastFreeDetailEnt = new FreeDetailEntity();
                lastFreeDetailEnt.setBusiCode(freeEnt.getBusiCode());
                lastFreeDetailEnt.setBusiName(freeEnt.getBusiName());
                lastFreeDetailEnt.setTotal(freeEnt.getLastTotal());
                lastFreeDetailEnt.setLongTotal(freeEnt.getLongLastTotal());
                lastFreeDetailEnt.setUsed(freeEnt.getLastUsed());
                lastFreeDetailEnt.setLongUsed(freeEnt.getLongLastUsed());
                lastFreeDetailEnt.setRemain(freeEnt.getLastRemain());
                lastFreeDetailEnt.setLongRemain(freeEnt.getLongLastRemain());
                lastFreeDetailEnt.setFavType(freeEnt.getFavType());
                lastFreeDetailEnt.setPriority(String.valueOf(freeEnt.getPriority()));
                lastFreeDetailEnt.setProdPrcidName(freeEnt.getProdPrcName() + "上月结转流量");
                lastFreeDetailEnt.setProdPrcId(freeEnt.getProdPrcId());
                lastFreeDetailEnt.setUnit(freeEnt.getUnitCode());
                lastFreeDetailEnt.setUnitName(freeEnt.getUnitName());
                lastFreeDetailEnt.setCarryFlag("Y");

                outList.add(lastFreeDetailEnt);
            }
        }


        for (FreeDetailEntity freeEnt : outList) {
            String busiCode = freeEnt.getBusiCode();
            String unitCode = freeEnt.getUnit();
            if (busiCode.equals("3") /*GPRS流量*/
                    || (busiCode.equals("5") && unitCode.equals("4")) /*WLAN 按流量计算*/
                    || busiCode.equals("R") /*结转流量*/
                    ) {

                freeEnt.setUnitName(gprsUnit);
                freeEnt.setTotal(UnitUtils.trans(freeEnt.getLongTotal(), gprsUnit));
                freeEnt.setUsed(UnitUtils.trans(freeEnt.getLongUsed(), gprsUnit));
                freeEnt.setRemain(UnitUtils.trans(freeEnt.getLongRemain(), gprsUnit));

            }
        }
        return outList;

    }

    /**
     * 功能：流量查询功能附加套餐推荐短信
     *
     * @param idNo
     * @param loginNo
     * @param opCode
     * @param phoneNo
     */
    private void sendMsg(long idNo, String loginNo, String opCode, String phoneNo) {

        int curYm = DateUtils.getCurYm();
        int favCount = 0; // 推荐短信下发次数计数
        String templateId = "";
        String queryType = "gprs";

        String prcIds = "M055491,M055492,M055493,M043912,M042939";

        if (!loginNo.equals("newapp")) {

            favCount = record.getSmsSendCount(phoneNo, curYm, queryType, opCode, "newapp");
            if (favCount < 3) {
                if (!goods.isOrderGoods(idNo, prcIds)) { //未订购指定的资费
                    favCount = prod.getFavCount(idNo, "3");

                    if (favCount > 0) {
                        templateId = "311100812302";//02
                    } else {
                        favCount = prod.getFavCount(idNo, "2");

                        if (favCount > 0) {
                            templateId = "311100812301";//01
                        } else {
                            templateId = "311100812300";//00
                        }
                    }

                    Map<String, Object> dataMap = new HashMap<String, Object>();

                    MBean msgBean = new MBean();
                    msgBean.addBody("PHONE_NO", phoneNo);
                    msgBean.addBody("LOGIN_NO", loginNo);
                    msgBean.addBody("OP_CODE", opCode);
                    msgBean.addBody("CHECK_FLAG", true);
                    msgBean.addBody("DATA", dataMap);
                    msgBean.addBody("TEMPLATE_ID", templateId);
                    String sendFlag = control.getPubCodeValue(2011, "DXFS", null);           // 0:直接发送 1:插入短信接口临时表 2：外系统有问题，直接不发送短信
                    if (sendFlag.equals("0")) {
                        msgBean.addBody("SEND_FLAG", 0);
                    } else if (sendFlag.equals("1")) {
                        msgBean.addBody("SEND_FLAG", 1);
                    } else if (sendFlag.equals("2")) {

                    }

                    if (sendFlag.charAt(0) != '2') {
                        shortMessage.sendSmsMsg(msgBean, 1);
                    }

                } else {
                    log.info("用户已办理资费，不需要提示推荐");
                    return;
                }

            } else {
                log.info("本月推送达到3次，不需要再次推送");
                return;
            }
        }
    }

    /**
     * 流量叠加包按资费合并，并展示叠加包个数
     *
     * @param inFreeList
     * @return
     */
    private List<FreeDetailEntity> getAddedFreeList(List<FreeMinBill> inFreeList, String gprsUnit) {
        List<FreeDetailEntity> outList = new ArrayList<>();

        Map<String, FreeDetailEntity> indexMap = new HashMap<>();
        Map<String, Integer> numMap = new HashMap<>(); // //流量叠加包个数
        for (FreeMinBill freeEnt : inFreeList) {
            String prcId = freeEnt.getProdPrcId();
            if (indexMap.containsKey(prcId)) {
                FreeDetailEntity oldEnt = indexMap.get(prcId);
                long oldTotal = oldEnt.getLongTotal();
                long oldUsed = oldEnt.getLongUsed();
                long oldRemain = oldEnt.getLongRemain();

                long newTotal = oldTotal + freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                long newUsed = oldUsed + freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                long newRemain = oldRemain + freeEnt.getLongRemain() + freeEnt.getLongLastRemain();
                oldEnt.setLongTotal(newTotal);
                oldEnt.setLongUsed(newUsed);
                oldEnt.setLongRemain(newRemain);

                oldEnt.setTotal(UnitUtils.trans(newTotal, gprsUnit));
                oldEnt.setUsed(UnitUtils.trans(newUsed, gprsUnit));
                oldEnt.setRemain(UnitUtils.trans(newRemain, gprsUnit));

                Integer numNew = numMap.get(prcId) + 1;
                if (freeEnt.getLongLastTotal() > 0) {
                    numNew++;
                }
                numMap.put(prcId, numNew);
            } else {
                FreeDetailEntity freeDetailEnt = new FreeDetailEntity();
                freeDetailEnt.setBusiCode(freeEnt.getBusiCode());
                freeDetailEnt.setBusiName(freeEnt.getBusiName());
                freeDetailEnt.setLongTotal(freeEnt.getLongTotal() + freeEnt.getLongLastTotal());
                freeDetailEnt.setLongUsed(freeEnt.getLongUsed() + freeEnt.getLongLastUsed());
                freeDetailEnt.setLongRemain(freeEnt.getLongRemain() + freeEnt.getLongLastRemain());
                freeDetailEnt.setFavType(freeEnt.getFavType());
                freeDetailEnt.setPriority(String.valueOf(freeEnt.getPriority()));
                freeDetailEnt.setProdPrcidName(freeEnt.getProdPrcName());
                freeDetailEnt.setProdPrcId(freeEnt.getProdPrcId());
                freeDetailEnt.setUnit(freeEnt.getUnitCode());

                freeDetailEnt.setUnitName(gprsUnit);
                freeDetailEnt.setTotal(UnitUtils.trans(freeEnt.getLongTotal(), gprsUnit));
                freeDetailEnt.setUsed(UnitUtils.trans(freeEnt.getLongUsed(), gprsUnit));
                freeDetailEnt.setRemain(UnitUtils.trans(freeEnt.getLongRemain(), gprsUnit));

                int prcNum = 1;
                if (freeEnt.getLongLastTotal() > 0) {
                    prcNum += 1;
                }

                indexMap.put(prcId, freeDetailEnt);
                numMap.put(prcId, prcNum);
            }
        }

        StringBuilder sb = null;
        for (String key : indexMap.keySet()) {

            FreeDetailEntity detailEnt = indexMap.get(key);
            if (numMap.containsKey(key)) {
                String oldPrcName = detailEnt.getProdPrcidName();
                sb = new StringBuilder();
                sb.append(oldPrcName).append("(").append(numMap.get(key)).append("个)");
                detailEnt.setProdPrcidName(sb.toString());
            }

            outList.add(detailEnt);
        }

        return outList;
    }

    @Override
    public OutDTO vpmnQuery(InDTO inParam) {
        SFreeVpmnQueryInDTO inDTO = (SFreeVpmnQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());
        UserGroupMbrEntity grpInfo = user.getGroupInfo(inDTO.getPhoneNo(), CommonConst.GROUP_TYPE_VPMN);
        if (grpInfo == null) {
            throw new BusiException(AcctMgrError.getErrorCode("8417", "20001"), "该用户不是vpmn集团用户！");
        }
        long grpIdNo = grpInfo.getGroupIdNo();
        // 需要确定VPMN集团的群组类型代码
        UserInfoEntity grpUserInfo = user.getUserEntityByIdNo(grpIdNo, true);
        GrpUserInfoEntity grpInfoEnt = getGrpUserInfo(grpUserInfo.getCustId(), inDTO.getProvinceId());

        Map<String, Long> freeMap = freeDisplayer.getFreeTotalMap(inDTO.getPhoneNo(), inDTO.getYearMonth(), "4");

        if (freeMap.get("VPMN_TOTAL") == 0 && freeMap.get("VPMN_USED") == 0) {
            throw new BusiException(AcctMgrError.getErrorCode("8123", "20001"), "用户无优惠信息！");
        }

        SFreeVpmnQueryOutDTO outDTO = new SFreeVpmnQueryOutDTO();
        outDTO.setVpmnRemain(freeMap.get("VPMN_REMAIN"));
        outDTO.setVpmnTotal(freeMap.get("VPMN_TOTAL"));
        outDTO.setVpmnUsed(freeMap.get("VPMN_USED"));

        outDTO.setUnitId(grpInfoEnt.getUnitId());
        outDTO.setUnitName(grpInfoEnt.getUnitName());
        outDTO.setContactPhone(grpInfoEnt.getContactPhone());
        outDTO.setContactPerson(grpInfoEnt.getContactName());

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    /**
     * 功能：获取集团客户经理信息
     *
     * @param grpCustId
     * @param provinceId
     * @return
     */
    private GrpUserInfoEntity getGrpUserInfo(Long grpCustId, String provinceId) {
        GrpUserInfoEntity grpInfoEnt = new GrpUserInfoEntity();
        GrpCustInfoEntity grpCustInfo = cust.getGrpCustInfo(grpCustId, null);
        long unitId = grpCustInfo.getUnitId();

        CustInfoEntity custInfo = cust.getCustInfo(grpCustId, null);
        String unitName = custInfo.getBlurCustName();

        String staffLogin /* 客户经理工号 */ = cust.getGrpContactStaff(grpCustId);

        LoginEntity staffInfo = login.getLoginInfo(staffLogin, provinceId);

        grpInfoEnt.setUnitId(unitId);
        grpInfoEnt.setUnitName(unitName);
        grpInfoEnt.setContactName(staffInfo.getLoginName());
        grpInfoEnt.setContactPhone(staffInfo.getContactPhone());
        return grpInfoEnt;
    }// /:~

    @Override
    public OutDTO shareQuery(InDTO inParam) {
        SFreeShareQueryInDTO inDTO = (SFreeShareQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        user.getUserEntityByPhoneNo(inDTO.getPhoneNo(), true);

        List<FreeMinBill> shareList = freeDisplayer.getFreeDetailList(inDTO.getPhoneNo(), inDTO.getYearMonth(), "W", "a");
        long gprsTotal = 0; // 总GPRS，含结转流量
        long usedGprs = 0; // 总使用量，含 结转使用量
        long gprsNativeTotal = 0;
        long gprsNativeUsed = 0;
        long gprsMemberNativeTotal = 0;

        long gprsNationalTotal = 0;
        long gprsNationalUsed = 0;
        long gprsMemberNationalTotal = 0;

        long gprsSharedTotal = 0;
        long gprsSharedUsed = 0;
        long gprsMemberShareTotal = 0; // 成员共享总流量
        long gprsMemberShareUsed = 0; // 成员共享已使用流量
        long gprsMemberNativeSharedTotal = 0; // 成员本地共享总流量
        long gprsMemberNativeSharedUsed = 0; // 成员本地共享总使用量
        long gprsMemberNationalSharedTotal = 0; // 成员全国共享总流量
        long gprsMemberNationalSharedUsed = 0; // 成员全国共享总使用量
        long gprsMemberRealFreeTotal = 0; // 副卡总的优惠量

        String typeFlag = "2"; //流量共享开通状态,0：主卡；1：副卡；2：未开通
        Map<String, Shared4GInfoEntity> indexMap = new HashMap<>();

        for (FreeMinBill freeEnt : shareList) {
            String busiCode = freeEnt.getBusiCode();
            String favCode = freeEnt.getFavCode();
            if (busiCode.equals("U")) {
                gprsTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                usedGprs += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();

                if (favCode.equals("0")) {
                    gprsNativeTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    gprsNativeUsed += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                    gprsMemberNativeTotal += freeEnt.getLongUsed() + freeEnt.getLongLastUsed(); // 副卡用户非共享的本地已使用流量
                } else if (favCode.equals("1")) {
                    gprsNationalTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    gprsNationalUsed += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                    gprsMemberNationalTotal += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                }
            }

            if (busiCode.equals("V")) {
                gprsTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                usedGprs += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                gprsSharedTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                gprsSharedUsed += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();

                if (favCode.equals("g")) {
                    gprsNativeTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    gprsNativeUsed += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                } else if (favCode.equals("e")) {
                    gprsNationalTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    gprsNationalUsed += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                }
                typeFlag = "0";
            }

            if (busiCode.equals("T")) {
                gprsTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                usedGprs += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                gprsMemberShareTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                gprsMemberShareUsed += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();

                if (favCode.equals("h")) { /*本地共享*/
                    gprsNativeTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    gprsNativeUsed += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                    gprsMemberNativeSharedTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    gprsMemberNativeSharedUsed += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                } else if (favCode.equals("f")) { /*国内共享*/
                    gprsNationalTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    gprsNationalUsed += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                    gprsMemberNationalSharedTotal += freeEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    gprsMemberNationalSharedUsed += freeEnt.getLongUsed() + freeEnt.getLongLastUsed();
                }

                typeFlag = "1";
            }

            if (busiCode.equals("W")) {
                String key = "";
                if (favCode.equals("e") || favCode.equals("g")) {
                    key = freeEnt.getReferenceNo() + "^" + "e";
                } else if (favCode.equals("f") || favCode.equals("h")) {
                    key = freeEnt.getReferenceNo() + "^" + "f";
                } else {
                    continue;
                }

                if (indexMap.containsKey(key)) {
                    Shared4GInfoEntity shareMemEnt = indexMap.get(key);
                    shareMemEnt.setLongSharedUsed(freeEnt.getLongRealFree() + shareMemEnt.getLongSharedUsed());
                } else {
                    Shared4GInfoEntity shareMemEnt = new Shared4GInfoEntity();
                    shareMemEnt.setMemPhone(freeEnt.getReferenceNo());
                    shareMemEnt.setLongSharedUsed(freeEnt.getLongRealFree()); /*成员个人使用情况*/
                    indexMap.put(key, shareMemEnt);
                }

                gprsMemberRealFreeTotal += freeEnt.getLongRealFree();

            }
        }

        List<Shared4GInfoEntity> share4GList = new ArrayList<>();
        for (String key : indexMap.keySet()) {
            Shared4GInfoEntity shareMemEnt = indexMap.get(key);
            shareMemEnt.setSharedUsed(String.format("%d", shareMemEnt.getLongSharedUsed()));
            share4GList.add(shareMemEnt);
        }

        SFreeShareQueryOutDTO outDTO = new SFreeShareQueryOutDTO();
        outDTO.setTypeFlag(typeFlag);
        outDTO.setMemUseList(share4GList);
        //集团规范要求返回KB
        outDTO.setGprsTotal(String.format("%d", gprsTotal));
        outDTO.setGprsNativeTotal(String.format("%d", gprsNativeTotal));
        outDTO.setGprsNativeUsed(String.format("%d", gprsNativeUsed));
        outDTO.setGprsNativeRemain(String.format("%d", (gprsNativeTotal - gprsNativeUsed)));
        outDTO.setGprsNationalTotal(String.format("%d", gprsNationalTotal));
        outDTO.setGprsNationalUsed(String.format("%d", gprsNationalUsed));
        outDTO.setGprsNationalRemain(String.format("%d", (gprsNationalTotal - gprsNationalUsed)));
        outDTO.setGprsSharedTotal(String.format("%d", gprsSharedTotal));
        outDTO.setGprsSharedUsed(String.format("%d", gprsSharedUsed));
        outDTO.setGprsSharedRemain(String.format("%d", (gprsSharedTotal - gprsSharedUsed)));
        outDTO.setGprsMemberNationalTotal(String.format("%d", gprsMemberNationalTotal));
        outDTO.setGprsMemberNativeTotal(String.format("%d", gprsMemberNativeTotal));
        outDTO.setGprsMemberShareTotal(String.format("%d", gprsMemberShareTotal));
        outDTO.setGprsMemberShareUsed(String.format("%d", gprsMemberShareUsed));
        outDTO.setGprsMemberShareRemain(String.format("%d", (gprsMemberShareTotal - gprsMemberShareUsed)));
        outDTO.setGprsMemberNativeSharedTotal(String.format("%d", gprsMemberNativeSharedTotal));
        outDTO.setGprsMemberNativeSharedUsed(String.format("%d", gprsMemberNativeSharedUsed));
        outDTO.setGprsMemberNativeSharedRemain(String.format("%d", (gprsMemberNativeSharedTotal - gprsMemberNativeSharedUsed)));
        outDTO.setGprsMemberNationalSharedTotal(String.format("%d", gprsMemberNationalSharedTotal));
        outDTO.setGprsMemberNationalSharedUsed(String.format("%d", gprsMemberNationalSharedUsed));
        outDTO.setGprsMemberNationalSharedRemain(String.format("%d", (gprsMemberNationalSharedTotal - gprsMemberNationalSharedUsed)));
        outDTO.setGprsMemberRealFreeTotal(String.format("%d", gprsMemberRealFreeTotal));

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    @Override
    public OutDTO choiceQuery(InDTO inParam) {
        SFreeChoiceQueryInDTO inDto = (SFreeChoiceQueryInDTO) inParam;
        String phoneNo = inDto.getPhoneNo();
        // 获取当前年月
        int curYm = DateUtils.getCurYm();
        String busiCode = "0";// 全部

        List<FreeMinBill> freeList = freeDisplayer.getFreeDetailList(phoneNo, curYm, busiCode);
        Map<String, Long> freeMap = freeDisplayer.getFreeTotalMap(freeList);

        SFreeChoiceQueryOutDTO outDto = new SFreeChoiceQueryOutDTO();
        outDto.setTotalFavTime(freeMap.get("VOICE_TOTAL"));
        outDto.setTotalUsedTime(freeMap.get("VOICE_USED"));
        outDto.setTotalRemainTime(freeMap.get("VOICE_REMAIN"));

        outDto.setTotalFavMsg(freeMap.get("SMS_TOTAL"));
        outDto.setTotalUsedTime(freeMap.get("SMS_USED"));
        outDto.setTotalRemainMsg(freeMap.get("SMS_REMAIN"));

        outDto.setTotalGprs(freeMap.get("GPRS_TOTAL"));
        return outDto;
    }

    @Override
    public OutDTO allQuery(InDTO inParam) {
        SFreeAllQueryInDTO inDTO = (SFreeAllQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        String phoneNo = inDTO.getPhoneNo();
        int queryYm = inDTO.getYearMonth();

        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        String groupId = userInfo.getGroupId();

        int lastDay = DateUtils.getLastDayOfMonth(queryYm);
        String lastDate = String.format("%06d%02d235959", queryYm, lastDay);

        String regionCode = group.getRegionDistinct(groupId, "2", inDTO.getProvinceId()).getRegionCode();

        List<FreeMinBill> freeDetailList = freeDisplayer.getFreeDetailList(phoneNo, queryYm, "0");
        List<FreeDetailEntity> freeList = new ArrayList<>();
        long outTotal = 0;
        for (FreeMinBill freeEnt : freeDetailList) {
            String busiCode = freeEnt.getBusiCode();
            String unitCode = freeEnt.getUnitCode();
            String shareFlag = "";

            if (freeEnt.getFavType().equals("0002")) {
                if (busiCode.equals("5")) { //WLAN 业务不包含套餐外的业务量，直接过滤
                    continue;
                } else if (busiCode.equals("3")) { //GPRS业务将套餐外的总使用量
                    outTotal += freeEnt.getLongUsed();
                    continue;
                }
            }

            if (busiCode.equals("1") || busiCode.equals("2") || busiCode.equals("3")
                    || busiCode.equals("5")
                    || busiCode.equals("7") || busiCode.equals("8")) {

                long longUsedTmp = (freeEnt.getLongTotal() < freeEnt.getLongUsed()) ? freeEnt.getLongTotal() : freeEnt.getLongUsed();
                long outTmp = (freeEnt.getLongTotal() < freeEnt.getLongUsed()) ? freeEnt.getLongUsed() - freeEnt.getLongTotal() : 0;
                long remainTmp = (freeEnt.getLongTotal() < freeEnt.getLongUsed()) ? 0 : freeEnt.getLongTotal() - freeEnt.getLongUsed();
                FreeDetailEntity freeDetailEnt = new FreeDetailEntity();
                freeDetailEnt.setBusiCode(freeEnt.getBusiCode());
                freeDetailEnt.setBusiName(freeEnt.getBusiName());
                freeDetailEnt.setTotal(freeEnt.getTotal());
                freeDetailEnt.setUsed(String.format("%d", freeEnt.getLongUsed()));
                freeDetailEnt.setRemain(String.format("%d", remainTmp));
                freeDetailEnt.setOut(String.format("%d", outTmp));
                freeDetailEnt.setFavType(freeEnt.getFavType());
                freeDetailEnt.setPriority(String.valueOf(freeEnt.getPriority()));
                freeDetailEnt.setProdPrcidName(freeEnt.getProdPrcName());
                freeDetailEnt.setProdPrcId(freeEnt.getProdPrcId());
                freeDetailEnt.setEffDate(freeEnt.getEffDate());
                freeDetailEnt.setUnit(freeEnt.getUnitCode());
                freeDetailEnt.setUnitName(freeEnt.getUnitName());
                freeDetailEnt.setGprsLimitType(freeEnt.getLimitType());
                freeDetailEnt.setGprsRegionType(freeEnt.getRegionType());
                if (busiCode.equals("3")) {
                    freeDetailEnt.setCarryFlag("N");

                    if (freeDisplayer.is4GPrcId(freeEnt.getProdPrcId())) {
                        shareFlag = billAccount.isSharePrcId(freeEnt.getProdPrcId(), regionCode) ? "Y" : "N";
                    } else {
//                        shareFlag = "X";
                    }
                    freeDetailEnt.setShareFlag(shareFlag);
                }
                Map<String, String> timeMap = prod.getPrcValidInfo(Long.parseLong(freeEnt.getInstanceId()));
                String expDate = (timeMap != null) ? getString(timeMap, "EXP_DATE") : "";
                freeDetailEnt.setExpDate(expDate);
                freeList.add(freeDetailEnt);

                if (freeEnt.getLongLastTotal() > 0) {
                    FreeDetailEntity lastFreeDetailEnt = new FreeDetailEntity();
                    lastFreeDetailEnt.setBusiCode(freeEnt.getBusiCode());
                    lastFreeDetailEnt.setBusiName(freeEnt.getBusiName());
                    lastFreeDetailEnt.setTotal(freeEnt.getLastTotal());
                    lastFreeDetailEnt.setUsed(freeEnt.getLastUsed());
                    lastFreeDetailEnt.setRemain(String.format("%d", freeEnt.getLongLastTotal() - freeEnt.getLongLastUsed()));
                    lastFreeDetailEnt.setOut("0"); //结转使用量不会大于总结转量
                    lastFreeDetailEnt.setFavType(freeEnt.getFavType());
                    lastFreeDetailEnt.setPriority(String.valueOf(freeEnt.getPriority()));
                    lastFreeDetailEnt.setProdPrcidName(freeEnt.getProdPrcName() + "上月结转流量");
                    lastFreeDetailEnt.setProdPrcId(freeEnt.getProdPrcId());
                    lastFreeDetailEnt.setEffDate(freeEnt.getEffDate());
                    lastFreeDetailEnt.setUnit(freeEnt.getUnitCode());
                    lastFreeDetailEnt.setUnitName(freeEnt.getUnitName());
                    lastFreeDetailEnt.setGprsLimitType(freeEnt.getLimitType());
                    lastFreeDetailEnt.setGprsRegionType(freeEnt.getRegionType());
                    if (busiCode.equals("3")) {
                        lastFreeDetailEnt.setCarryFlag("Y");
                        lastFreeDetailEnt.setShareFlag(shareFlag);
                    }
                    lastFreeDetailEnt.setExpDate(lastDate);

                    freeList.add(lastFreeDetailEnt);
                }

            }
        }

        SFreeAllQueryOutDTO outDTO = new SFreeAllQueryOutDTO();
        outDTO.setFreeList(freeList);
        outDTO.setOutTotal(String.format("%d", outTotal));

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    @Override
    public OutDTO averageGprsQuery(InDTO inParam) {

        //入参：PHONE_NO
        //出参：用户流量平均使用值，需要转换成GB/MB/KB
        SFreeAverageGprsQueryInDTO inDTO = (SFreeAverageGprsQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        String phoneNo = inDTO.getPhoneNo();
        int curYM = DateUtils.getCurYm();

        long totalGprs = 0;

        List<FreeMinBill> outList = new ArrayList<FreeMinBill>();
        for (int i = 0; i < 5; i++) {
            int queryYM = DateUtils.addMonth(curYM, -i);
            List<FreeMinBill> inFreeList = freeDisplayer.getFreeDetailList(phoneNo, queryYM, "3");

            outList.addAll(inFreeList);
        }
        Map<String, Long> gprsMap = freeDisplayer.getGprsFreeTotalMap(outList);

        totalGprs = gprsMap.get("GPRS_USED");
        long averageKb = Math.round(totalGprs / 5.0);

        String averageGprs = UnitUtils.trans(averageKb, UnitUtils.GPRS_UNIT_GB);

        SFreeAverageGprsQueryOutDTO outDTO = new SFreeAverageGprsQueryOutDTO();
        outDTO.setAverageGprs(averageGprs);

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    @Override
    public OutDTO classQuery(InDTO inParam) {
        //按分类查询用户优惠
        SFreeClassQueryInDTO inDTO = (SFreeClassQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        String phoneNo = inDTO.getPhoneNo();
        int queryYm = inDTO.getYearMonth();

        List<FreeMinBill> freeDetailList = freeDisplayer.getFreeDetailList(phoneNo, queryYm, "3");
        if (freeDetailList == null || freeDetailList.isEmpty()) {
            throw new BusiException(AcctMgrError.getErrorCode("8123", "20001"), "用户无优惠信息！");
        }

        List<FreeClassEntity> freeClassList = this.getClassFreeList(freeDetailList, GPRS_UNIT_GB);

        Map<String, Long> outMap = freeDisplayer.getFreeClassMap(freeDetailList);

        SFreeClassQueryOutDTO outDTO = new SFreeClassQueryOutDTO();
        outDTO.setTotal(UnitUtils.trans(outMap.get("GPRS_TOTAL"), GPRS_UNIT_GB));
        outDTO.setUsed(UnitUtils.trans(outMap.get("GPRS_USED"), GPRS_UNIT_GB));
        outDTO.setRemain(UnitUtils.trans(outMap.get("GPRS_REMAIN"), GPRS_UNIT_GB));
        outDTO.setOut(UnitUtils.trans(outMap.get("OUT_GPRS"), GPRS_UNIT_GB));
        outDTO.setFreeInfo(freeClassList);

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    private List<FreeClassEntity> getClassFreeList(List<FreeMinBill> inFreeList, String gprsUnit) {
        List<FreeClassEntity> outList = new ArrayList<>();

        Map<String, FreeClassEntity> indexMap = new HashMap<>();
        for (FreeMinBill freeEnt : inFreeList) {
            long longUsedTmp = (freeEnt.getLongTotal() < freeEnt.getLongUsed()) ? freeEnt.getLongTotal() : freeEnt.getLongUsed();
            String key = freeEnt.getFavClass() + "^N";//非结转
            if (indexMap.containsKey(key)) {
                FreeClassEntity oldEnt = indexMap.get(key);
                long newTotal = oldEnt.getLongTotal() + freeEnt.getLongTotal();
                long newUsed = oldEnt.getLongUsed() + freeEnt.getLongUsed();
                long newRemain = oldEnt.getLongRemain() + freeEnt.getLongRemain();
                oldEnt.setLongTotal(newTotal);
                oldEnt.setLongUsed(newUsed);
                oldEnt.setLongRemain(newRemain);
            } else {
                FreeClassEntity freeClassEnt = new FreeClassEntity();
                freeClassEnt.setLongTotal(freeEnt.getLongTotal());
                freeClassEnt.setLongUsed(freeEnt.getLongUsed());
                freeClassEnt.setLongRemain(freeEnt.getLongRemain());
                freeClassEnt.setFavClass(freeEnt.getFavClass());
                freeClassEnt.setFavClassName(freeEnt.getFavClassName());
                indexMap.put(key, freeClassEnt);
            }
            /*结转优惠信息处理*/
            if (freeEnt.getLongLastTotal() > 0) {
                String keyJz = freeEnt.getFavClass() + "^Y";//结转
                if (indexMap.containsKey(keyJz)) {
                    FreeClassEntity oldEnt = indexMap.get(keyJz);
                    long newTotal = oldEnt.getLongTotal() + freeEnt.getLongLastTotal();
                    long newUsed = oldEnt.getLongUsed() + freeEnt.getLongLastUsed();
                    long newRemain = oldEnt.getLongRemain() + freeEnt.getLongLastRemain();
                    oldEnt.setLongTotal(newTotal);
                    oldEnt.setLongUsed(newUsed);
                    oldEnt.setLongRemain(newRemain);
                } else {
                    FreeClassEntity freeClassEnt = new FreeClassEntity();
                    freeClassEnt.setLongTotal(freeEnt.getLongLastTotal());
                    freeClassEnt.setLongUsed(freeEnt.getLongLastUsed());
                    freeClassEnt.setLongRemain(freeEnt.getLongLastRemain());
                    freeClassEnt.setFavClass(freeEnt.getFavClassJz());
                    freeClassEnt.setFavClassName(freeEnt.getFavClassJzName() + "上月结转流量");
                    indexMap.put(keyJz, freeClassEnt);
                }
            }
        }

        for (String key : indexMap.keySet()) {
            FreeClassEntity freeClassEnt = indexMap.get(key);
            freeClassEnt.setTotal(UnitUtils.trans(freeClassEnt.getLongTotal(), gprsUnit));
            freeClassEnt.setUsed(UnitUtils.trans(freeClassEnt.getLongUsed(), gprsUnit));
            freeClassEnt.setRemain(UnitUtils.trans(freeClassEnt.getLongRemain(), gprsUnit));
            outList.add(freeClassEnt);
        }

        return outList;
    }

    @Override
    public OutDTO dayQuery(InDTO inParam) {
        SFreeDayQueryInDTO inDTO = (SFreeDayQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        String phoneNo = inDTO.getPhoneNo();
        int queryYm = inDTO.getYearMonth();

        List<FreeMinBill> freeDetailList = freeDisplayer.getFreeDetailList(phoneNo, queryYm, "O");
        if (freeDetailList == null || freeDetailList.isEmpty()) {
            throw new BusiException(AcctMgrError.getErrorCode("8123", "20001"), "用户无优惠信息！");
        }

        long total = 0;
        long used = 0;
        long remain = 0;
        List<FreeDayInfoEntity> freeDayInfoList = new ArrayList<FreeDayInfoEntity>();
        String prcId = null;
        String prcName = null;
        String effDate = null;

        for (FreeMinBill freeMinBillEnt : freeDetailList) {
            FreeDayInfoEntity freeDayInfoEnt = new FreeDayInfoEntity();

            total = freeMinBillEnt.getLongTotal();
            used = freeMinBillEnt.getLongUsed();
            remain = freeMinBillEnt.getLongRemain();
            prcId = freeMinBillEnt.getProdPrcId();
            prcName = freeMinBillEnt.getProdPrcName();
            effDate = freeMinBillEnt.getEffDate();

            String favDate = effDate.substring(4, 6) + "月" + effDate.substring(6, 8) + "日";

            freeDayInfoEnt.setFavDate(favDate);
            freeDayInfoEnt.setPrcId(prcId);
            freeDayInfoEnt.setPrcName(prcName);
            freeDayInfoEnt.setTotal(UnitUtils.trans(total, GPRS_UNIT_GB));
            freeDayInfoEnt.setUsed(UnitUtils.trans(used, GPRS_UNIT_GB));
            freeDayInfoEnt.setRemain(UnitUtils.trans(remain, GPRS_UNIT_GB));

            freeDayInfoList.add(freeDayInfoEnt);
        }

        SFreeDayQueryOutDTO outDTO = new SFreeDayQueryOutDTO();
        outDTO.setFreeDayList(freeDayInfoList);
        return outDTO;
    }

    @Override
    public OutDTO smsQuery(InDTO inParam) {
        SFreeSmsQueryInDTO inDTO = (SFreeSmsQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        String phoneNo = inDTO.getPhoneNo();
        int queryYm = inDTO.getYearMonth();

        List<FreeMinBill> freeDetailList = freeDisplayer.getFreeDetailList(phoneNo, queryYm, "0");

        Collections.sort(freeDetailList, new DateComparator());

        String sysdate = DateUtils.getCurDate(DateUtils.DATE_FORMAT_YYYYMMDDHHMISS1);
        StringBuffer message = new StringBuffer();
        message.append("您好，截至" + sysdate + "您已开通");

        int i = 0;
        for (FreeMinBill freeEnt : freeDetailList) {
            String busiCode = freeEnt.getBusiCode();
            String favName = freeEnt.getProdPrcName();
            String prcType = freeEnt.getPrcType();

            if (!busiCode.equals("1") && !busiCode.equals("2") && !busiCode.equals("3")) {
                continue;
            }

            if (i == 0) {   //第一部分短信以主资费为主
                if ("1".equals(busiCode)) {
                    message.append(favName + "，使用情况为：含剩余语音分钟数" + freeEnt.getLongRemain() + "分钟");
                } else if ("2".equals(busiCode)) {
                    message.append(favName + "，使用情况为：含剩余短信条数" + freeEnt.getLongRemain() + "条");
                } else if ("3".equals(busiCode)) {
                    message.append(favName + "，使用情况为：含剩余GPRS流量" + freeEnt.getLongRemain() + "K");
                }
            } else {
                if ("2".equals(busiCode)) {
                    message.append("、剩余短信条数" + freeEnt.getLongRemain() + "条");
                } else if ("3".equals(busiCode)) {
                    message.append("、剩余GPRS流量" + freeEnt.getLongRemain() + "K");
                }
            }
            i++;
        }
        message.append("。以上信息仅供参考。中国移动");

        System.out.println(message);

        Map<String, String> msgMap = new HashMap<String, String>();
        msgMap.put("msg", message.toString());

        MBean msgBean = new MBean();
        msgBean.addBody("PHONE_NO", phoneNo);
        msgBean.addBody("LOGIN_NO", inDTO.getLoginNo());
        msgBean.addBody("OP_CODE", inDTO.getOpCode());
        msgBean.addBody("CHECK_FLAG", true);
        msgBean.addBody("DATA", msgMap);
        msgBean.addBody("TEMPLATE_ID", "311200000001");  //模板ID
        String sendFlag = control.getPubCodeValue(2011, "DXFS", null);     // 0:直接发送 1:插入短信接口临时表 2：外系统有问题，直接不发送短信
        if (sendFlag.equals("0")) {
            msgBean.addBody("SEND_FLAG", 0);
        } else if (sendFlag.equals("1")) {
            msgBean.addBody("SEND_FLAG", 1);
        } else if (sendFlag.equals("2")) {

        }

        if (sendFlag.charAt(0) != '2') {
            shortMessage.sendSmsMsg(msgBean, 1);
        }

        SFreeSmsQueryOutDTO outDTO = new SFreeSmsQueryOutDTO();
        return outDTO;
    }

    public IFreeDisplayer getFreeDisplayer() {
        return freeDisplayer;
    }

    public void setFreeDisplayer(IFreeDisplayer freeDisplayer) {
        this.freeDisplayer = freeDisplayer;
    }

    public IUser getUser() {
        return user;
    }

    public void setUser(IUser user) {
        this.user = user;
    }

    public ICust getCust() {
        return cust;
    }

    public void setCust(ICust cust) {
        this.cust = cust;
    }

    public ILogin getLogin() {
        return login;
    }

    public void setLogin(ILogin login) {
        this.login = login;
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

    public IRecord getRecord() {
        return record;
    }

    public void setRecord(IRecord record) {
        this.record = record;
    }

    public IPreOrder getPreOrder() {
        return preOrder;
    }

    public void setPreOrder(IPreOrder preOrder) {
        this.preOrder = preOrder;
    }

    public IControl getControl() {
        return control;
    }

    public void setControl(IControl control) {
        this.control = control;
    }

    public IGroup getGroup() {
        return group;
    }

    public void setGroup(IGroup group) {
        this.group = group;
    }

    public IShortMessage getShortMessage() {
        return shortMessage;
    }

    public void setShortMessage(IShortMessage shortMessage) {
        this.shortMessage = shortMessage;
    }

    public IGoods getGoods() {
        return goods;
    }

    public void setGoods(IGoods goods) {
        this.goods = goods;
    }


}