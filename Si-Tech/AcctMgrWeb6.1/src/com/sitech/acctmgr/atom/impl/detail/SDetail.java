package com.sitech.acctmgr.atom.impl.detail;

import com.alibaba.fastjson.JSON;
import com.sitech.acctmgr.atom.domains.base.GroupEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.detail.ChannelDetail;
import com.sitech.acctmgr.atom.domains.detail.DetailLimitEntity;
import com.sitech.acctmgr.atom.domains.detail.DynamicTable;
import com.sitech.acctmgr.atom.domains.detail.ElementAttribute;
import com.sitech.acctmgr.atom.domains.free.Shared4GInfoEntity;
import com.sitech.acctmgr.atom.domains.record.ActQueryOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserGroupMbrEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.detail.*;
import com.sitech.acctmgr.atom.dto.free.SFreeShareQueryOutDTO;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.CacheOpr;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.inter.detail.IDetail;
import com.sitech.acctmgr.net.ServerInfo;
import com.sitech.acctmgrint.atom.busi.intface.IShortMessage;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.service.client.ServiceUtil;
import org.apache.commons.codec.digest.DigestUtils;

import java.io.IOException;
import java.io.InputStream;
import java.util.*;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

/**
 * Created by wangyla on 2016/7/12.
 */
@ParamTypes({@ParamType(c = SDetailChannelQueryInDTO.class, m = "channelQuery", oc = SDetailChannelQueryOutDTO.class),
        @ParamType(c = SDetailDetailQueryInDTO.class, m = "detailQuery", oc = SDetailDetailQueryOutDTO.class),
        @ParamType(c = SDetailRawQueryInDTO.class, m = "rawQuery", oc = SDetailRawQueryOutDTO.class),
        @ParamType(c = SDetailQueryInDTO.class, m = "query", oc = SDetailQueryOutDTO.class),
        @ParamType(c = SDetailDynamicRawQueryInDTO.class, m = "dynamicRawQuery", oc = SDetailDynamicRawQueryOutDTO.class),
        @ParamType(c = SDetailCityQueryInDTO.class, m = "cityQuery", oc = SDetailCityQueryOutDTO.class),
        @ParamType(c = SDetailSpQueryInDTO.class, m = "spQuery", oc = SDetailSpQueryOutDTO.class),
        @ParamType(c = SDetailDynamicSpQueryInDTO.class, m = "dynamicSpQuery", oc = SDetailDynamicSpQueryOutDTO.class),
        @ParamType(c = SDetailSmsStatsInDTO.class, m = "smsStats", oc = SDetailSmsStatsOutDTO.class),
        @ParamType(c = SDetailCityQueryOldInDTO.class, m = "cityQueryOld", oc = SDetailCityQueryOldOutDTO.class)
})
public class SDetail extends AcctMgrBaseService implements IDetail {
    private IUser user;
    private ILogin login;
    private IRecord record;
    private ICust cust;
    private IDetailDisplayer detailDisplayer;
    private IGroup group;
    private IControl control;
    private IShortMessage shortMessage;

    private static volatile String cacheSwitch;
    private CacheOpr cacheOpr;

    static {
        Properties prop = new Properties();
        InputStream is = SDetail.class.getClassLoader().getResourceAsStream("busi.properties");
        try {
            prop.load(is);
        } catch (IOException e) {
            e.printStackTrace();
        }

        cacheSwitch = prop.getProperty("cache_switch");
    }

    @Override
    public OutDTO channelQuery(InDTO inParam) {

        SDetailChannelQueryInDTO inDTO = (SDetailChannelQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        /**
         * 规则限制：
         * 1、只可查询近六月详单 sCheckQueryRange.groovy
         * 2、跨区补卡用户三日内不允许查询详单 sTransRegionLimit.groovy
         * 3、神州行未续约用户不允许查询详单 (sEasyOwn.groovy)未实现groovy
         * 4、用户过户前数据是否可以查询限制 （服务直接实现过户查询限制）
         * 5、未开户用户不允许查询开户前的详单数据 （服务直接实现过户查询限制）
         * 6、详单屏蔽业务限制 （sDetailQueryLimited.groovy）
         * 7、跨区不允许查询用户详单（dealTransRegionQueryBusi函数内部实现）
         */
        //TODO 需要增加密码校验功能

        String phoneNo = inDTO.getPhoneNo();
        String queryFlag = inDTO.getQueryFlag();
        int queryYm = inDTO.getYearMonth();
        String beginDate = inDTO.getBegintime();
        String endDate = inDTO.getEndtime();
        int queryTypeIn = Integer.parseInt(inDTO.getQueryType());
        if (queryTypeIn != 0 && ((queryTypeIn > 80 && queryTypeIn != 90) || queryTypeIn < 71)) {
            log.error("请输入正确的详单查询类型 [71~80] | 0 ");
            throw new BusiException(AcctMgrError.getErrorCode("8142", "20004"), "请输入正确的详单查询类型 [71~80] | 0");
        }

        if (user.isInternetOfThingsPhone(phoneNo)) {
            phoneNo = user.getPhoneNoByAsn(phoneNo, CommonConst.NBR_TYPE_WLW);
        }

        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        long custId = userInfo.getCustId();
        String openTime = userInfo.getOpenTime(); //开户时间
        String phoneGroupId = userInfo.getGroupId();
        CustInfoEntity custInfo = cust.getCustInfo(custId, null);
        String custName = custInfo.getBlurCustName();

        this.dealTransRegionQueryBusi(inDTO.getLoginNo(), inDTO.getGroupId(), phoneGroupId, inDTO.getProvinceId());

        Map<String, String> timeMap = this.getQueryTimes(userInfo.getIdNo(), queryFlag, queryYm, beginDate, endDate, openTime);
        String dealBeginTime = timeMap.get("DEAL_BEGIN_TIME"); //话单处理开始时间
        String dealEndTime = timeMap.get("DEAL_END_TIME"); //话单处理结束时间
        String callBeginTime = timeMap.get("CALL_BEGIN_TIME"); //通话开始时间
        String callEndTime = timeMap.get("CALL_END_TIME"); //通话结束时间
        String billBeginTime = timeMap.get("BILL_BEGIN_TIME"); //计费周期开始时间
        String billEndTime = timeMap.get("BILL_END_TIME"); //计费周期结束时间
        log.debug("request times = [" + dealBeginTime + "/" + dealEndTime + "," + callBeginTime + "/" + callEndTime + "]");

        List<String> baseInfo = this.getBaseInfo(phoneNo, custName, billBeginTime, billEndTime);

        List<ChannelDetail> channelDetailList = new ArrayList<>();
        List<String> queryTypeList = this.getQueryType(inDTO.getQueryType());

        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");


        String serviceType = inDTO.getOpCode();
        for (String queryType : queryTypeList) {
            int detailType = Integer.parseInt(queryType);
            ChannelDetail channelDetail = null;
            switch (detailType) {
                case 71:
                    channelDetail = detailDisplayer.comboDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 72:
                    channelDetail = detailDisplayer.voiceDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, serviceType);
                    break;
                case 73:
                    channelDetail = detailDisplayer.videoDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, serviceType);
                    break;
                case 74:
                    channelDetail = detailDisplayer.smsDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, serviceType);
                    break;
                case 75:
                    channelDetail = detailDisplayer.netDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    String mainFlag = this.getFamilyMbrFlag(phoneNo);
                    /*按帐期查询时，4G家庭需要查询共享流量*/
                    if ((queryFlag.equals("1")
                            || (queryFlag.equals("0") && beginDate.substring(0, 6).equals(endDate.substring(0, 6))))
                            && !mainFlag.isEmpty()) {

                        String queryYm4G = queryFlag.equals("1") ? String.valueOf(queryYm) : endDate.substring(0, 6);
                        String shareString = this.getFamilyShareInfo(phoneNo, queryYm4G, mainFlag);
//                      shareString = this.getFamilyShareInfo(phoneNo, "201606", "0");
                        if (!shareString.isEmpty()) {
                            List<String> globalList = channelDetail.getGlobalList();
                            globalList.add(shareString);
                            channelDetail.setGlobalList(globalList);
                        }
                    }

                    break;
                case 76:
                    channelDetail = detailDisplayer.addedDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 77:
                    channelDetail = detailDisplayer.groupDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 78:
                    channelDetail = detailDisplayer.agencyDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 79:
                    channelDetail = detailDisplayer.otherDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 80:
                    channelDetail = detailDisplayer.favourDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 90:
                    channelDetail = detailDisplayer.netDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                default:
                    break;
            }

            channelDetailList.add(channelDetail);

        }
        /*记录详单的查询日志*/
        String remark = null;
        if (queryTypeIn == 90) {
            remark = "免计费流量查询";
        }
        this.saveQueryOprLog(phoneNo, userInfo.getIdNo(), inDTO.getLoginNo(), inDTO.getGroupId(),
                inDTO.getOpCode(), inDTO.getQueryType(), inDTO.getProvinceId(), null, null, null, remark);

        String departName = this.getLoginLocation(inDTO.getLoginNo(), inDTO.getProvinceId());
        if (!departName.isEmpty()) {
            /*尊敬的客户您好，您于${month}月${day}日${hour}时${minute}分通过黑龙江移动公司的${loginlocation}查询了通信详单，请您关注信息安全。中国移动*/

            String curDate = DateUtils.getCurDate(DateUtils.DATE_FORMAT_YYYYMMDDHHMISS);
            Map<String, Object> msgData = new HashMap<>();
            safeAddToMap(msgData, "month", curDate.substring(4, 6));
            safeAddToMap(msgData, "day", curDate.substring(6, 8));
            safeAddToMap(msgData, "hour", curDate.substring(8, 10));
            safeAddToMap(msgData, "minute", curDate.substring(10, 12));
            safeAddToMap(msgData, "loginlocation", departName);

            MBean msgBean = new MBean();
            msgBean.addBody("PHONE_NO", phoneNo);
            msgBean.addBody("LOGIN_NO", inDTO.getLoginNo());
            ;
            msgBean.addBody("OP_CODE", inDTO.getOpCode());
            msgBean.addBody("CHECK_FLAG", true);
            msgBean.addBody("DATA", msgData);
            msgBean.addBody("TEMPLATE_ID", "311100814200");
            String sendFlag = control.getPubCodeValue(2011, "DXFS", null);         // 0:直接发送 1:插入短信接口临时表 2：外系统有问题，直接不发送短信
            if (sendFlag.equals("0")) {
                msgBean.addBody("SEND_FLAG", 0);
            } else if (sendFlag.equals("1")) {
                msgBean.addBody("SEND_FLAG", 1);
            } else if (sendFlag.equals("2")) {

            }

            if (sendFlag.charAt(0) != '2') {
                shortMessage.sendSmsMsg(msgBean);
            }

        }

        SDetailChannelQueryOutDTO outDTO = new SDetailChannelQueryOutDTO();
        outDTO.setBaseInfo(baseInfo);
        outDTO.setChannelDetails(channelDetailList);

        log.debug("outDto = " + outDTO.toJson());
        return outDTO;

    }

    /**
     * 获取详单展示基础展示部分信息
     *
     * @param phoneNo
     * @param custName
     * @param beginTime
     * @param endTime
     * @return
     */
    private List<String> getBaseInfo(String phoneNo, String custName, String beginTime, String endTime) {
        String curYmd = String.format("%d", DateUtils.getCurDay());
        List<String> baseList = new ArrayList<>();
        String phoneHead = phoneNo.substring(0, 3);
        String phoneTail = phoneNo.substring(7, 11);
        StringBuilder sb = null;
        sb = new StringBuilder();
        sb.append("客户名称:").append("|")
                .append(custName).append("|")
                .append("手机号码:").append("|")
                .append(phoneHead).append("****").append(phoneTail);
        baseList.add(sb.toString());

        sb = new StringBuilder();
        sb.append("详单查询周期:").append("|")
                .append(beginTime.substring(0, 4)).append("年").append(beginTime.substring(4, 6)).append("月").append(beginTime.substring(6, 8)).append("日")
                .append("至")
                .append(endTime.substring(0, 4)).append("年").append(endTime.substring(4, 6)).append("月").append(endTime.substring(6, 8)).append("日")
                .append("|")
                .append("查询日期:").append("|")
                .append(curYmd.substring(0, 4)).append("年").append(curYmd.substring(4, 6)).append("月").append(curYmd.substring(6, 8)).append("日");
        baseList.add(sb.toString());
        return baseList;
    }

    /**
     * 获取详单查询时请求的处理时间及通话时间
     *
     * @param queryFlag
     * @param yearMonth
     * @param beginTime
     * @param endTime
     * @return
     */
    private Map<String, String> getQueryTimes(Long idNo, String queryFlag, Integer yearMonth, String beginTime, String endTime, String openTime) {
        Map<String, String> timeMap = new HashMap<>();
        String dealBeginTime = ""; //话单处理开始时间
        String dealEndTime = ""; //话单处理结束时间
        String callBeginTime = ""; //通话开始时间
        String callEndTime = ""; //通话结束时间
        String billBeginDate = ""; //计费周期开始日
        String billEndDate = ""; //计费周期结束日

        String passTime = "";
        Date passDate = user.getUserPassDate(idNo, null);
        if (passDate != null) {
            passTime = DateUtils.format(passDate, "yyyyMMddHHmmss");
        }


        /**
         * 按帐期查询时，通话开始时间提前25天（可能会变）
         * 按时间段查询时，处理结束时间推迟25天（可能会变）, 由CommonConst.DETAIL_QUERY_ADD_DAYS 变量表示
         *
         */
        if (queryFlag.equals("0")) { //按时间段查询

            int endYmd = Integer.parseInt(endTime.substring(0, 8));

            billBeginDate = beginTime.substring(0, 8);
            billEndDate = endTime.substring(0, 8);


            if (passTime.compareTo(endTime) > 0) {
                throw new BusiException(AcctMgrError.getErrorCode("8142", "20001"), "不允许查询过户前的详单");
            }

            if (openTime.compareTo(endTime) > 0) {
                throw new BusiException(AcctMgrError.getErrorCode("8142", "20003"), "不允许查询开户前的详单");
            }

            /*计费周期时间段修复*/
            if (openTime.compareTo(beginTime) > 0) {
                billBeginDate = openTime.substring(0, 8);
            }

            if (passTime.compareTo(beginTime) > 0) {
                billBeginDate = passTime.substring(0, 8);
            }

            if (beginTime.length() == 8 && endTime.length() == 8) { //yyyyMMdd

                if (passTime.compareTo(beginTime) > 0) {
                    beginTime = passTime.substring(0, 8);
                }

                if (openTime.compareTo(beginTime) > 0) {
                    beginTime = openTime.substring(0, 8);
                }

                dealBeginTime = String.format("%s000000", beginTime.substring(0, 8));
                dealEndTime = String.format("%s235959", DateUtils.addDays(endYmd, CommonConst.DETAIL_QUERY_ADD_DAYS));

                callBeginTime = String.format("%s000000", beginTime);
                callEndTime = String.format("%s235959", endTime);
            } else if (beginTime.length() > 8 && endTime.length() > 8) { //yyyyMmddHHMiss
                if (passTime.compareTo(beginTime) > 0) {
                    beginTime = passTime;
                }

                if (openTime.compareTo(beginTime) > 0) {
                    beginTime = openTime;
                }

                dealBeginTime = String.format("%s", beginTime);
                dealEndTime = String.format("%s%s", DateUtils.addDays(endYmd, CommonConst.DETAIL_QUERY_ADD_DAYS),
                        endTime.substring(8, 14));

                callBeginTime = String.format("%s", beginTime);
                callEndTime = String.format("%s", endTime);
            }

            int endYm = Integer.parseInt(endTime.substring(0, 6));
            if (endTime.substring(0, 6).equals(dealEndTime.substring(0, 6))) {
                dealEndTime = String.format("%s%2d235959", endTime.substring(0, 6), DateUtils.getLastDayOfMonth(endYm));
            }

        } else if (queryFlag.equals("1")) { //按帐期查询
            int beginDate = yearMonth * 100 + 1;
            int endDate = yearMonth * 100 + DateUtils.getLastDayOfMonth(yearMonth);

            billBeginDate = String.format("%8d", beginDate);
            billEndDate = String.format("%8d", endDate);

            if (StringUtils.isNotBlank(passTime)) {
                int passYm = Integer.parseInt(passTime.substring(0, 6));


                if (passYm == yearMonth) {
                    beginDate = Integer.parseInt(passTime.substring(0, 8));
                    billBeginDate = String.format("%8d", beginDate);
                } else if (passYm > yearMonth) {
                    throw new BusiException(AcctMgrError.getErrorCode("8142", "20001"), "不允许查询过户前的详单");
                }
            }

            if (StringUtils.isNotBlank(openTime)) {
                int openYm = Integer.parseInt(openTime.substring(0, 6));
                if (openYm == yearMonth) {
                    beginDate = Integer.parseInt(openTime.substring(0, 8));
                    billBeginDate = String.format("%8d", beginDate);
                } else if (openYm > yearMonth) {
                    throw new BusiException(AcctMgrError.getErrorCode("8142", "20003"), "不允许查询开户前的详单");
                }
            }

            dealBeginTime = String.format("%d000000", beginDate);
            dealEndTime = String.format("%d235959", endDate);

            callBeginTime = String.format("%d000000", DateUtils.addDays(beginDate, -1 * CommonConst.DETAIL_QUERY_ADD_DAYS));
            callEndTime = String.format("%d235959", endDate);
        }


        safeAddToMap(timeMap, "DEAL_BEGIN_TIME", dealBeginTime);
        safeAddToMap(timeMap, "DEAL_END_TIME", dealEndTime);
        safeAddToMap(timeMap, "CALL_BEGIN_TIME", callBeginTime);
        safeAddToMap(timeMap, "CALL_END_TIME", callEndTime);

        safeAddToMap(timeMap, "BILL_BEGIN_TIME", billBeginDate);
        safeAddToMap(timeMap, "BILL_END_TIME", billEndDate);

        return timeMap;
    }

    private void saveQueryOprLog(String phoneNo, long idNo, String loginNo, String loginGroupId, String opCode, String queryType, String provinceId,
                                 String optionType, String rightCode, String orderNo, String remark) {
        ActQueryOprEntity oprEntity = new ActQueryOprEntity();
        if (StringUtils.isNotEmpty(loginNo) && StringUtils.isEmptyOrNull(loginGroupId)) {
            LoginEntity loginInfo = login.getLoginInfo(loginNo, provinceId);
            loginGroupId = loginInfo.getGroupId();
        }
        oprEntity.setQueryType("0");
        oprEntity.setOpCode(opCode);
        oprEntity.setContactId("");
        oprEntity.setIdNo(idNo);
        oprEntity.setPhoneNo(phoneNo);
        oprEntity.setBrandId("");
        oprEntity.setLoginNo(loginNo);
        oprEntity.setLoginGroup(loginGroupId);
        oprEntity.setProvinceId(provinceId);

        if (StringUtils.isNotEmpty(optionType)) {
            oprEntity.setOptionType(optionType);
        }

        if (StringUtils.isNotEmpty(rightCode)) {
            oprEntity.setRightCode(rightCode);

        }

        if (StringUtils.isNotEmpty(orderNo)) {
            oprEntity.setContactId(orderNo);

        }

        if (StringUtils.isNotEmpty(remark)) {
            oprEntity.setRemark(remark);
        } else {
            StringBuilder stringbuf = new StringBuilder();
            stringbuf.append("工号:");
            stringbuf.append(loginNo);
            stringbuf.append(this.getLoginLocation(loginNo, provinceId));
            stringbuf.append(",查询[");
            stringbuf.append(phoneNo);
            stringbuf.append("]" + this.getDetailTypeName(queryType));
            oprEntity.setRemark(stringbuf.toString());
        }
        record.saveQueryOpr(oprEntity, false);
    }

    /**
     * 功能:查询工号归属类型名称 <br>
     * 如：自助、营业
     *
     * @param loginNo
     * @param provinceId
     * @return
     */
    private String getLoginLocation(String loginNo, String provinceId) {

        String departName = "";
        if (loginNo.equals("newweb")) {
            departName = "网站";
        } else if (loginNo.equals("newapp")) {
            departName = "移动旗舰店app";
        } else {
            LoginEntity loginInfo = login.getLoginInfo(loginNo, provinceId);
            String loginType = loginInfo.getLoginType();
            if (loginType.equals("3")) {
                departName = "自助查询设备";
            } else {
                if (loginType.equals("4") && group.getCurrentLevel(loginInfo.getGroupId(), provinceId) == 4) {
                    departName = "营业厅";
                }
            }
        }

        return departName;
    }

    /**
     * 根据请求的查询类型，获取详单归属类组的id列表
     * TIPS：后续通过此信息获取ETC模版配置
     *
     * @param queryType
     * @return
     */
    private List<String> getQueryType(String queryType) {
        List<String> outList = new ArrayList<>();
        if (queryType.equals("0")) {
            /*
            * 新版本详单按10大类查询：
            * 71：套餐及固定费详单
            * 72：语音详单
            * 73：可视电话详单
            * 74：短信/彩信息详单
            * 75：上网详单（包含GPRS和WLAN）
            * 76：自有增值业务（包含A类和B类）
            * 77：集团业务扣费记录
            * 78：SP代收费详单
            * 79：其他扣费详单
            * 80：优惠减免
            */
            outList = Arrays.asList(new String[]{"71", "72", "73", "74", "75", "76", "77", "78", "79", "80"});
        } else if (queryType.equals("100")) {
            /*
            * 原始详单查询类型：
            * 101：原始话单-语音话单
            * 102：原始话单-VPMN话单
            * 103：原始话单-短信话单
            * 104：原始话单-GPRS话单
            */
            outList = Arrays.asList(new String[]{"101", "102", "103", "104"});
        } else {
            outList.add(queryType);
        }

        return outList;
    }

    private List<String> getSpQueryType(String queryType) {

        List<String> outList = new ArrayList<>();

        if (queryType.equals("0")) {
            outList = Arrays.asList(new String[]{"811", "812", "813", "814", "815", "816", "817", "818", "819", "820", "821", "822", "823", "824", "825", "826", "827", "828", "829", "830", "831", "832", "833", "834", "835"});
        } else {
            outList.add(queryType);
        }

        return outList;
    }

    /**
     * @param queryType 详单查询类型名称
     * @return
     */
    private String getDetailTypeName(String queryType) {
        Map<String, String> typeMap = new HashMap<>();
        safeAddToMap(typeMap, "71", "套餐及固定费详单");
        safeAddToMap(typeMap, "72", "语音详单");
        safeAddToMap(typeMap, "73", "可视电话详单");
        safeAddToMap(typeMap, "74", "短/彩信详单");
        safeAddToMap(typeMap, "75", "上网详单（包括GPRS和WLAN）");
        safeAddToMap(typeMap, "76", "自有增值业务详单");
        safeAddToMap(typeMap, "77", "集团业务扣费详单");
        safeAddToMap(typeMap, "78", "SP代收费详单");
        safeAddToMap(typeMap, "79", "其他扣费详单");
        safeAddToMap(typeMap, "80", "减免费用");
        safeAddToMap(typeMap, "0", "全部");
        safeAddToMap(typeMap, "100", "全部");
        safeAddToMap(typeMap, "101", "语音话单");
        safeAddToMap(typeMap, "102", "VPMN话单");
        safeAddToMap(typeMap, "103", "短信话单");
        safeAddToMap(typeMap, "104", "GPRS话单");
        safeAddToMap(typeMap, "96", "SP退费业务查询");

        return typeMap.get(queryType);

    }

    /**
     * 功能：获取用户归属家庭中，角色标识
     *
     * @param phoneNo
     * @return 0-家庭主号；1-家庭成员
     */
    private String getFamilyMbrFlag(String phoneNo) {
        String mbrFlag = "";
        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        long idNo = userInfo.getIdNo();

        long codeClass = 1048;
        List<Long> memberRoleIds = user.getFamilyRoleIds(codeClass, "0");
        UserGroupMbrEntity mbrInfo = user.getFamilyMemberInfo(idNo, memberRoleIds);
        if (mbrInfo != null) {
            mbrFlag = "0"; //家庭主号
        } else {
            memberRoleIds = user.getFamilyRoleIds(codeClass, "1");
            mbrInfo = user.getFamilyMemberInfo(idNo, memberRoleIds);
            if (mbrInfo != null) {
                mbrFlag = "1"; //成员
            }
        }

        return mbrFlag;
    }

    /**
     * 查询家庭4G共享流量，附加到流量信息
     *
     * @param phoneNo
     * @param queryYm
     * @param mainFlag
     * @return
     */
    private String getFamilyShareInfo(String phoneNo, String queryYm, String mainFlag) {

        StringBuilder sb = new StringBuilder();

        if (!mainFlag.isEmpty()) {

            String interfaceName = "com_sitech_acctmgr_inter_free_IFreeSvc_shareQuery";
            MBean in = new MBean();
            in.setBody("BUSI_INFO.PHONE_NO", phoneNo);
            in.setBody("BUSI_INFO.YEAR_MONTH", queryYm);
            log.debug("inMbean=" + in.toString());
//        String result = ServiceUtil.callService(interfaceName, in, "10", phoneNo);
            String result = ServiceUtil.callService(interfaceName, in);
            SFreeShareQueryOutDTO outDto = JSON.parseObject(result, SFreeShareQueryOutDTO.class);
            log.debug("====4G outDto=" + outDto.toJson());

            List<Shared4GInfoEntity> memUseList = outDto.getMemUseList();
            if (memUseList != null && memUseList.size() > 0) {
                if (mainFlag.equals("0")) {
                    boolean hasMem = false;
                    sb.append("您套餐内免费资源中，");

                    for (Shared4GInfoEntity memUseEnt : memUseList) {
                        sb.append(memUseEnt.getMemPhone()).append("用户使用").append(memUseEnt.getSharedUsed()).append("MB");
                        hasMem = true;
                    }
                    sb.append("此处仅展示您本人的上网话单。");

                    if (!hasMem) {
                        sb = new StringBuilder();
                    }

                } else if (mainFlag.equals("1")) {
                    Shared4GInfoEntity memUseEnt = memUseList.get(0);
                    sb.append("您使用的流量中，使用").append(memUseEnt.getMemPhone())
                            .append("用户群组共享流量").append(memUseEnt.getSharedUsed()).append("MB");

                }
            }

        }

        log.debug("4G 家庭共享流量[" + sb.toString() + "]");

        return sb.toString();

    }

    /*未合并明细详单查询*/
    @Override
    public OutDTO detailQuery(InDTO inParam) {

        SDetailDetailQueryInDTO inDTO = (SDetailDetailQueryInDTO) inParam;

        log.debug("inDto=" + inDTO.getMbean());
        String phoneNo = inDTO.getPhoneNo();
        String queryFlag = inDTO.getQueryFlag();

        int queryYm = inDTO.getYearMonth();
        String beginTime = inDTO.getBegintime();
        String endTime = inDTO.getEndtime();
        String chargingId = inDTO.getChargingId();
        String resv = inDTO.getResv();

        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        String openTime = userInfo.getOpenTime(); //开户时间

        Map<String, String> timeMap = this.getQueryTimes(userInfo.getIdNo(), queryFlag, queryYm, beginTime, endTime, openTime);
        String dealBeginTime = timeMap.get("DEAL_BEGIN_TIME"); //话单处理开始时间
        String dealEndTime = timeMap.get("DEAL_END_TIME"); //话单处理结束时间
        String callBeginTime = timeMap.get("CALL_BEGIN_TIME"); //通话开始时间
        String callEndTime = timeMap.get("CALL_END_TIME"); //通话结束时间

        List<String> baseInfo = this.getBaseInfoForDetailQuery(phoneNo);

        String queryType = inDTO.getQueryType();
        ChannelDetail channelDetail = null;

        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");
        if (queryType.equals("95")) {
            channelDetail = detailDisplayer.netDetailDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, chargingId, resv);
        }


        SDetailDetailQueryOutDTO outDTO = new SDetailDetailQueryOutDTO();
        outDTO.setBaseInfo(baseInfo.get(0));
        outDTO.setDetail(channelDetail);

        log.debug("outDto = " + outDTO.toJson());
        return outDTO;

    }

    private List<String> getBaseInfoForDetailQuery(String phoneNo) {
        String phoneHead = phoneNo.substring(0, 3);
        String phoneTail = phoneNo.substring(7, 11);
        StringBuilder sb = new StringBuilder();
        sb.append("业务名称:")
                .append("未合并话单查询")
                .append("|手机号码:")
                .append(phoneHead).append("****").append(phoneTail);

        List<String> baseInfo = new ArrayList<>();
        baseInfo.add(sb.toString());

        return baseInfo;
    }

    @Override
    public OutDTO rawQuery(InDTO inParam) {

        SDetailRawQueryInDTO inDTO = (SDetailRawQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        /**
         * 原始详单查询决定使用动态表格来实现详单内容的展示
         * 1、页面点击查询时，服务实现功能
         *  1.1 按etc将详单的内容进行缓冲
         *  1.2 查询时展示所有涉及到的etc详单的第一页
         * 2、在指定的etc展示分块上点击下一页时，实现功能
         *  2.1 直接从查询服务缓冲下来redis中，获取此次查询的详单分页信息
         *      问题：需要考虑多终端访问时，redis键值的设定；不能让别的工号查询到另一工号正在操作的内容
         */

        /**
         * 规则限制：
         * 1、只可查询近六月详单 sCheckQueryRange.groovy
         * 2、跨区补卡用户三日内不允许查询详单 sTransRegionLimit.groovy
         * 3、用户过户前数据是否可以查询限制 （服务直接实现过户查询限制）,合并到公共的时间查询中（完成）
         */

        String phoneNo = inDTO.getPhoneNo();
        String queryFlag = inDTO.getQueryFlag();
        int queryYm = inDTO.getYearMonth();
        String beginDate = inDTO.getBegintime();
        String endDate = inDTO.getEndtime();

        boolean isPage = "Y".equalsIgnoreCase(inDTO.getIsPage()) ? true : false;

        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        long custId = userInfo.getCustId();
        String openTime = userInfo.getOpenTime(); //开户时间
        CustInfoEntity custInfo = cust.getCustInfo(custId, null);
        String custName = custInfo.getBlurCustName();

        Map<String, String> timeMap = this.getQueryTimes(userInfo.getIdNo(), queryFlag, queryYm, beginDate, endDate, openTime);
        String dealBeginTime = timeMap.get("DEAL_BEGIN_TIME"); //话单处理开始时间
        String dealEndTime = timeMap.get("DEAL_END_TIME"); //话单处理结束时间
        String callBeginTime = timeMap.get("CALL_BEGIN_TIME"); //通话开始时间
        String callEndTime = timeMap.get("CALL_END_TIME"); //通话结束时间

        String billBeginTime = timeMap.get("BILL_BEGIN_TIME"); //计费周期开始时间
        String billEndTime = timeMap.get("BILL_END_TIME"); //计费周期结束时间

        List<ChannelDetail> channelDetailList = new ArrayList<>();

        int pageNo = inDTO.getPageNo();
        int pageSize = inDTO.getPageSize();
        int lineBegIndex = (pageNo - 1) * pageSize;
        int lineEndIndex = pageNo * pageSize;

        long loginAccept = control.getSequence("SEQ_SYSTEM_SN");
        List<String> queryTypeList = this.getQueryType(inDTO.getQueryType());

        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");

        String cacheKey = null;
        int totalLines = 0;
        for (String queryType : queryTypeList) {
            ChannelDetail detailInfo = new ChannelDetail();
            detailInfo.setQueryType(queryType);
            detailInfo.setTitleInfo(this.getRawDetailTitleInfo(queryType));

            List<String> detailLines = null;
            cacheKey = new StringBuilder().append(phoneNo).append(queryType)
                    .append(dealBeginTime).append(dealEndTime)
                    .append(callBeginTime).append(callEndTime).toString(); //缓存KEY
            cacheKey = DigestUtils.shaHex(cacheKey); //sha1运算
            if (cacheSwitch.equalsIgnoreCase("ON") && cacheOpr.exists(cacheKey)) {
                detailLines = cacheOpr.getDetail(cacheKey); //TODO
            } else {
                detailLines = detailDisplayer.rawDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime,
                        callBeginTime, callEndTime);

                if ("ON".equals(cacheSwitch)) {
                    cacheOpr.setValueToCache(cacheKey, detailLines);
                }
            }

            totalLines = detailLines.size(); //分页时，只按一种类型的进行查询，所以这里可以不用做累加
            if (isPage && totalLines > 0) {
                lineEndIndex = lineEndIndex <= totalLines ? lineEndIndex : (totalLines); //控制结束下标，防止越界
                List<String> subLines = detailLines.subList(lineBegIndex, lineEndIndex);
                detailInfo.setDetailLines(subLines);
            } else {
                detailInfo.setDetailLines(detailLines);
            }

            detailInfo.setCount(totalLines);

            channelDetailList.add(detailInfo);
        }

        /*记录详单的查询日志*/
        this.saveQueryOprLog(phoneNo, userInfo.getIdNo(), inDTO.getLoginNo(), inDTO.getGroupId(),
                inDTO.getOpCode(), inDTO.getQueryType(), inDTO.getProvinceId(), null, null, null, null);

        /*获取表头基础信息*/
        List<String> baseInfoList = this.getRawDetailHeadInfo(phoneNo, billBeginTime, billEndTime, queryFlag, inDTO.getLoginNo(), loginAccept);

        SDetailRawQueryOutDTO outDTO = new SDetailRawQueryOutDTO();
        outDTO.setBaseInfo(baseInfoList);
        outDTO.setChannelDetails(channelDetailList);

        log.debug("outDto = " + outDTO.toJson());
        return outDTO;
    }

    private String getRawDetailTitleInfo(String queryType) {
        String titleInfo = "";
        if (queryType.equals("101")) { //对应detail_code 5011
            titleInfo = String.format(
                    "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s",
                    "通话类型", "imsi码", "设备号", "收费用户号码", "对端号码", "开始时间", "通话时长", "动态漫游号码", "交换机号", "小区代码", "基站号", "对方位置", "对方基站号", "出中继",
                    "入中继", "服务类别", "服务代码", "优先计费标志", "通话终止原因", "通话时长注释", "信息台编号", "归属地区号", "到访地区号", "对端归属地", "对端漫游地", "被叫号码漫游地", "用户类型",
                    "漫游类型", "费用类型", "拨打类型", "对端号码类型", "基本通话费", "本地附加费", "长途费", "长话附加费", "信息费", "原始话单文件名", "处理时间", "每条话单的优惠类型", "本地优惠套餐类型",
                    "单条赠送信息", "累计赠送信息", "本地优惠套餐类型", "单条赠送信息", "累计赠送信息");
        } else if (queryType.equals("102")) { //对应detail_code 5012
            titleInfo = String.format(
                    "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s",
                    "通话类型", "imsi码", "设备号", "计费号码", "对端号码", "通话日期", "通话时长", "动态漫游号码", "交换机号", "小区代码", "基站号", "对方位置", "对方基站号", "出中继", "入中继",
                    "服务类别", "服务代码", "优先计费标志", "通话终止原因", "通话时长注释", "信息台编号", "归属地区号", "到访地区号", "对端归属地", "对端漫游地", "被叫号码漫游地", "用户类型", "漫游类型",
                    "费用类型", "拨打类型", "对端号码类型", "基本通话费", "本地附加费", "通信费", "长话附加费", "信息费", "原始基本通话费", "原始通信费", "原始附加费金额", "原始信息费", "原始话单文件名",
                    "处理时间", "每条话单的优惠类型", "本地优惠套餐类型", "单条赠送信息", "累计赠送信息", "本地优惠套餐类型", "单条赠送信息", "累计赠送信息");
        } else if (queryType.equals("103")) { //对应detail_code 5013
            titleInfo = String.format(
                    "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s",
                    "短消息类型", "消息序列号", "收费用户号码", "对端号码", "开始时间", "结束时间", "发送状态代码", "信息长度", "状态标志", "终止原因", "用户类型", "基本通话费", "归属地区号",
                    "原始话单文件名", "处理时间", "优惠套餐类型", "单条赠送信息", "累计赠送信息", "错单的文件名", "错误代码", "sp代码", "服务代码", "业务代码");
        } else if (queryType.equals("104")) { //对应detail_code 5014 5015
            titleInfo = String.format(
                    "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s",
                    "记录类型", "PDP标志", "imsi码", "设备号", "计费号码", "通话日期", "通话时长", "SGSN地址", "网络能力", "小区代码", "路由区域", "基站号", "PDP计费标识", "GGSN地址",
                    "APN网络标识", "APN运营商标识", "PDP类型", "PDP地址", "SGSN改变标志", "终止原因", "记录完整", "服务类别", "归属地区", "到访地区", "用户类型", "漫游类型", "费用类型",
                    "基本/漫游通话费", "原始基本通话费", "原始话单文件名", "单条赠送信息", "累计赠送信息");
        } else if (queryType.equals("106")) { //对应detail_code 5016
            titleInfo = String.format("%s|%s|%s|%s", "手机号码", "通话开始时间", "通话时长", "通话小区");
        }

        return titleInfo;
    }

    private List<String> getRawDetailHeadInfo(String phoneNo, String dealBegTime, String dealEndTime, String queryFlag,
                                              String loginNo, long loginAccept) {
        List<String> headList = new ArrayList<>();
        String headInfo = "";
        String titleName = "";
        String yearBeg = dealBegTime.substring(0, 4);
        String monthBeg = dealBegTime.substring(4, 6);
        String dayBeg = dealBegTime.substring(6, 8);
        String yearEnd = dealEndTime.substring(0, 4);
        String monthEnd = dealEndTime.substring(4, 6);
        String dayEnd = dealEndTime.substring(6, 8);
        String queryYm = dealBegTime.substring(0, 6);
        if (queryFlag.equals("0")) { //按时间段查询
            headInfo = String.format("%20s黑龙江省%-15s%s%10s通话时间%4s年%2s月%2s日--%4s年%2s月%2s日",
                    " ", phoneNo, titleName, " ", yearBeg, monthBeg, dayBeg, yearEnd, monthEnd, dayEnd);

        } else if (queryFlag.equals("1")) { //按帐务月查询
            headInfo = String.format("%20s黑龙江省%-15s%s%10s结帐月份%2s",
                    " ", phoneNo, titleName, " ", queryYm);
        }

        if (!headInfo.isEmpty()) {
            headList.add(headInfo);
        }

        String printDate = String.format("%06d", DateUtils.getCurDay());
        headInfo = String.format("工号:%s       流水号:%s     打印时间：%s", loginNo, loginAccept, printDate);
        headList.add(headInfo);

        return headList;
    }

    @Override
    public OutDTO query(InDTO inParam) {

        SDetailQueryInDTO inDTO = (SDetailQueryInDTO) inParam;
        log.debug("inDTO=" + inDTO.getMbean());

        String phoneNo = inDTO.getPhoneNo();
        String queryFlag = inDTO.getQueryFlag();
        int queryYm = inDTO.getYearMonth();
        String beginDate = inDTO.getBegintime();
        String endDate = inDTO.getEndtime();

        /**
         * 规则限制：
         * 1、只可查询近六月详单 sCheckQueryRange.groovy
         * 2、跨区补卡用户三日内不允许查询详单 sTransRegionLimit.groovy
         * 3、神州行未续约用户不允许查询详单 (sEasyOwn.groovy)未实现groovy
         * 4、用户过户前数据是否可以查询限制 （服务直接实现过户查询限制）
         * 5、未开户用户不允许查询开户前的详单数据 （服务直接实现过户查询限制）
         * 6、详单屏蔽业务限制 （sDetailQueryLimited.groovy）
         * 7、跨区不允许查询用户详单（dealTransRegionQueryBusi）
         */

        if (user.isInternetOfThingsPhone(phoneNo)) {
            phoneNo = user.getPhoneNoByAsn(phoneNo, CommonConst.NBR_TYPE_WLW);
        }

        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        long custId = userInfo.getCustId();
        String openTime = userInfo.getOpenTime(); //开户时间
        String phoneGroupId = userInfo.getGroupId();
        CustInfoEntity custInfo = cust.getCustInfo(custId, null);
        String custName = custInfo.getBlurCustName();

        /*跨区查询用户详单权限校验*/
        this.dealTransRegionQueryBusi(inDTO.getLoginNo(), inDTO.getGroupId(), phoneGroupId, inDTO.getProvinceId());


        Map<String, String> timeMap = this.getQueryTimes(userInfo.getIdNo(), queryFlag, queryYm, beginDate, endDate, openTime);
        String dealBeginTime = timeMap.get("DEAL_BEGIN_TIME"); //话单处理开始时间
        String dealEndTime = timeMap.get("DEAL_END_TIME"); //话单处理结束时间
        String callBeginTime = timeMap.get("CALL_BEGIN_TIME"); //通话开始时间
        String callEndTime = timeMap.get("CALL_END_TIME"); //通话结束时间

        String billBeginTime = timeMap.get("BILL_BEGIN_TIME"); //计费周期开始时间
        String billEndTime = timeMap.get("BILL_END_TIME"); //计费周期结束时间
        log.debug("request times = [" + dealBeginTime + "/" + dealEndTime + "," + callBeginTime + "/" + callEndTime + "]");

        List<String> baseInfo = this.getBaseInfo(phoneNo, custName, billBeginTime, billEndTime);

        List<DynamicTable> tables = new ArrayList<>(); /*10大类详单返回值*/

        DynamicTable baseTable = getBaseDynamicTable(baseInfo, inDTO.getQueryType());
        tables.add(baseTable);

        List<String> queryTypeList = this.getQueryType(inDTO.getQueryType());

        String serviceType = inDTO.getOpCode();

        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");

        for (String queryType : queryTypeList) {
            int detailType = Integer.parseInt(queryType);
            ChannelDetail channelDetail = null;
            List<DynamicTable> dynamicTables = null;
            switch (detailType) {
                case 71:
                    channelDetail = detailDisplayer.comboDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 72:
                    channelDetail = detailDisplayer.voiceDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, serviceType);
                    break;
                case 73:
                    channelDetail = detailDisplayer.videoDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, serviceType);
                    break;
                case 74:
                    channelDetail = detailDisplayer.smsDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, serviceType);
                    break;
                case 75:
                    channelDetail = detailDisplayer.netDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    String mainFlag = this.getFamilyMbrFlag(phoneNo);
                    /*按帐期查询时，4G家庭需要查询共享流量*/
                    if ((queryFlag.equals("1")
                            || (queryFlag.equals("0") && beginDate.substring(0, 6).equals(endDate.substring(0, 6))))
                            && !mainFlag.isEmpty()) {

                        String queryYm4G = queryFlag.equals("1") ? String.valueOf(queryYm) : endDate.substring(0, 6);
                        String shareString = this.getFamilyShareInfo(phoneNo, queryYm4G, mainFlag);
//                      shareString = this.getFamilyShareInfo(phoneNo, "201606", "0");
                        if (!shareString.isEmpty()) {
                            List<String> globalList = channelDetail.getGlobalList();
                            globalList.add(shareString);
                            channelDetail.setGlobalList(globalList);
                        }
                    }

                    break;
                case 76:
                    channelDetail = detailDisplayer.addedDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 77:
                    channelDetail = detailDisplayer.groupDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 78:
                    channelDetail = detailDisplayer.agencyDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 79:
                    channelDetail = detailDisplayer.otherDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 80:
                    channelDetail = detailDisplayer.favourDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
            }
            dynamicTables = this.getDetailDynamicTables(channelDetail);
            tables.addAll(dynamicTables);
        }
        /*记录详单的查询日志*/
        this.saveQueryOprLog(phoneNo, userInfo.getIdNo(), inDTO.getLoginNo(), inDTO.getGroupId(),
                inDTO.getOpCode(), inDTO.getQueryType(), inDTO.getProvinceId(), null, null, null, null);

        //TODO 需要增加短信下发，需要先获取是否下发短信标识
        String departName = this.getLoginLocation(inDTO.getLoginNo(), inDTO.getProvinceId());
        if (!departName.isEmpty()) {
            /*尊敬的客户您好，您于${month}月${day}日${hour}时${minute}分通过黑龙江移动公司的${loginlocation}查询了通信详单，请您关注信息安全。中国移动*/

            String curDate = DateUtils.getCurDate(DateUtils.DATE_FORMAT_YYYYMMDDHHMISS);
            Map<String, Object> msgData = new HashMap<>();
            safeAddToMap(msgData, "month", curDate.substring(4, 6));
            safeAddToMap(msgData, "day", curDate.substring(6, 8));
            safeAddToMap(msgData, "hour", curDate.substring(8, 10));
            safeAddToMap(msgData, "minute", curDate.substring(10, 12));
            safeAddToMap(msgData, "loginlocation", departName);

            MBean msgBean = new MBean();
            msgBean.addBody("PHONE_NO", phoneNo);
            msgBean.addBody("LOGIN_NO", inDTO.getLoginNo());
            ;
            msgBean.addBody("OP_CODE", inDTO.getOpCode());
            msgBean.addBody("CHECK_FLAG", true);
            msgBean.addBody("DATA", msgData);
            msgBean.addBody("TEMPLATE_ID", "311100814200");
            String sendFlag = control.getPubCodeValue(2011, "DXFS", null);         // 0:直接发送 1:插入短信接口临时表 2：外系统有问题，直接不发送短信
            if (sendFlag.equals("0")) {
                msgBean.addBody("SEND_FLAG", 0);
            } else if (sendFlag.equals("1")) {
                msgBean.addBody("SEND_FLAG", 1);
            } else if (sendFlag.equals("2")) {

            }

            if (sendFlag.charAt(0) != '2') {
                shortMessage.sendSmsMsg(msgBean);
            }

        }

        SDetailQueryOutDTO outDTO = new SDetailQueryOutDTO();
        outDTO.setTables(tables);

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    private DynamicTable getBaseDynamicTable(List<String> baseInfo, String queryType) {
        DynamicTable baseTable = new DynamicTable();
        baseTable.setElementLabelType("2");
        baseTable.setElementName("baseTableName");
        baseTable.setElementCol("5");
        List<ElementAttribute> baseBody = new ArrayList<>();

        ElementAttribute head = new ElementAttribute();
        head.setDefaultValue("中国移动通信" + this.getDetailTypeName(queryType) + "客户详单");
        head.setElementId("base_head_id");
        head.setElementName("base_head_name");
        head.setElementType("24");
        head.setElementTdType("TH");
        head.setControlCols("4");
        head.setElementTdAttr("class=\"fwb ctd\" style=\"font-size:24px;\"");
        baseBody.add(head);

        ElementAttribute spaceCell = new ElementAttribute();
        spaceCell.setDefaultValue("");
        spaceCell.setElementId("base_space_cell");
        spaceCell.setElementName("base_space_cell_name");
        spaceCell.setElementType("24"); //文本显示
        spaceCell.setElementTdType("TH");
        baseBody.add(spaceCell);

        for (int x = 0; x < baseInfo.size(); x++) {
            String[] lineArr = baseInfo.get(x).split("\\|");
            for (int y = 0; y < lineArr.length; y++) {
                ElementAttribute cell = new ElementAttribute();
                cell.setDefaultValue(lineArr[y]);
                cell.setElementId("base_line_" + x + "_" + y);
                cell.setElementName("base_name_" + x + "_" + y);
                cell.setElementType("24");
                cell.setElementTdType("TD");
                cell.setElementTdAttr("style=\"text-align:left !important;\"");
                baseBody.add(cell);

            }

            spaceCell = new ElementAttribute();
            spaceCell.setDefaultValue("");
            spaceCell.setElementId("base_space_cell");
            spaceCell.setElementName("base_space_cell_name");
            spaceCell.setElementType("24"); //文本显示
            spaceCell.setElementTdType("TD");
            baseBody.add(spaceCell);
        }

        baseTable.setElementAttrList(baseBody);

        return baseTable;
    }

    @Override
    public OutDTO dynamicRawQuery(InDTO inParam) {

        SDetailDynamicRawQueryInDTO inDTO = (SDetailDynamicRawQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        /**
         * 原始详单查询决定使用动态表格来实现详单内容的展示
         * 1、页面点击查询时，服务实现功能
         *  1.1 按etc将详单的内容进行缓冲
         *  1.2 查询时展示所有涉及到的etc详单的第一页
         * 2、在指定的etc展示分块上点击下一页时，实现功能
         *  2.1 直接从查询服务缓冲下来redis中，获取此次查询的详单分页信息
         *      问题：需要考虑多终端访问时，redis键值的设定；不能让别的工号查询到另一工号正在操作的内容
         */

        /**
         * 规则限制：
         * 1、只可查询近六月详单 sCheckQueryRange.groovy
         * 2、跨区补卡用户三日内不允许查询详单 sTransRegionLimit.groovy
         * 3、用户过户前数据是否可以查询限制 （服务直接实现过户查询限制）,合并到公共的时间查询中（完成）
         */

        String phoneNo = inDTO.getPhoneNo();
        String queryFlag = inDTO.getQueryFlag();
        int queryYm = inDTO.getYearMonth();
        String beginDate = inDTO.getBegintime();
        String endDate = inDTO.getEndtime();

        boolean isPage = "Y".equalsIgnoreCase(inDTO.getIsPage()) ? true : false;

        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        long custId = userInfo.getCustId();
        String openTime = userInfo.getOpenTime(); //开户时间
        CustInfoEntity custInfo = cust.getCustInfo(custId, null);
        String custName = custInfo.getBlurCustName();

        Map<String, String> timeMap = this.getQueryTimes(userInfo.getIdNo(), queryFlag, queryYm, beginDate, endDate, openTime);
        String dealBeginTime = timeMap.get("DEAL_BEGIN_TIME"); //话单处理开始时间
        String dealEndTime = timeMap.get("DEAL_END_TIME"); //话单处理结束时间
        String callBeginTime = timeMap.get("CALL_BEGIN_TIME"); //通话开始时间
        String callEndTime = timeMap.get("CALL_END_TIME"); //通话结束时间
        String billBeginTime = timeMap.get("BILL_BEGIN_TIME"); //计费周期开始时间
        String billEndTime = timeMap.get("BILL_END_TIME"); //计费周期结束时间

        int pageNo = inDTO.getPageNo();
        int pageSize = inDTO.getPageSize();
        int lineBegIndex = (pageNo - 1) * pageSize;
        int lineEndIndex = pageNo * pageSize;

        long loginAccept = control.getSequence("SEQ_SYSTEM_SN");
        List<DynamicTable> tables = new ArrayList<>();
        /*获取表头基础信息*/
        List<String> baseInfoList = this.getRawDetailHeadInfo(phoneNo, billBeginTime, billEndTime, queryFlag, inDTO.getLoginNo(), loginAccept);

        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");
        /*获取详表详单body部分*/
        List<String> queryTypeList = this.getQueryType(inDTO.getQueryType());
        List<ChannelDetail> detailList = new ArrayList<>();
        String cacheKey = null;
        int totalLines = 0;
        for (String queryType : queryTypeList) {
            ChannelDetail detailInfo = new ChannelDetail();
            detailInfo.setQueryType(queryType);
            detailInfo.setTitleInfo(this.getRawDetailTitleInfo(queryType));

            List<String> detailLines = null;
            cacheKey = new StringBuilder().append(phoneNo).append(queryType)
                    .append(dealBeginTime).append(dealEndTime)
                    .append(callBeginTime).append(callEndTime).toString(); //缓存KEY
            cacheKey = DigestUtils.shaHex(cacheKey); //sha1运算
            if (cacheSwitch.equalsIgnoreCase("ON") && cacheOpr.exists(cacheKey)) {
                detailLines = cacheOpr.getDetail(cacheKey); //TODO
            } else {
                detailLines = detailDisplayer.rawDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime,
                        callBeginTime, callEndTime);

                if ("ON".equals(cacheSwitch)) {
                    cacheOpr.setValueToCache(cacheKey, detailLines);
                }
            }

            totalLines = detailLines.size(); //分页时，只按一种类型的进行查询，所以这里可以不用做累加
            if (isPage && totalLines > 0) {
                lineEndIndex = lineEndIndex <= totalLines ? lineEndIndex : (totalLines); //控制结束下标，防止越界
                List<String> subLines = detailLines.subList(lineBegIndex, lineEndIndex);
                detailInfo.setDetailLines(subLines);
            } else {
                detailInfo.setDetailLines(detailLines);
            }

            detailInfo.setCount(totalLines); //详单总条数
            detailList.add(detailInfo);
        }

        DynamicTable detailTable = this.getRawDetailInfo(detailList, baseInfoList, inDTO.getQueryType());
        if (isPage) { //不分页时，不返回总记录数
            detailTable.setElementDataTotal(String.format("%d", totalLines));
        }
        tables.add(detailTable);

        /*记录详单的查询日志*/
        this.saveQueryOprLog(phoneNo, userInfo.getIdNo(), inDTO.getLoginNo(), inDTO.getGroupId(),
                inDTO.getOpCode(), inDTO.getQueryType(), inDTO.getProvinceId(), null, null, null, null);

        SDetailDynamicRawQueryOutDTO outDTO = new SDetailDynamicRawQueryOutDTO();
        outDTO.setTables(tables);

        log.debug("outDto = " + outDTO.toJson());
        return outDTO;
    }

    private DynamicTable getRawDetailInfo(List<ChannelDetail> detailList, List<String> baseInfoList, String queryType) {
        DynamicTable detailTable = new DynamicTable();
        detailTable.setElementCol("2");
        detailTable.setElementLabelType("2");
        detailTable.setElementPaging(true);
        List<ElementAttribute> body = new ArrayList<>();
        List<ElementAttribute> baseBody = new ArrayList<>();

        ElementAttribute head = new ElementAttribute();
        head.setDefaultValue("中国移动通信客户" + this.getDetailTypeName(queryType) + "详单");
        head.setElementId("base_title_id");
        head.setElementName("base_title_name");
        head.setElementType("24"); //文本显示
        head.setElementTdType("TH");
        head.setElementTdAttr("style=\"text-align:left !important; font-weight:bold!important;\"");
        baseBody.add(head);

        ElementAttribute spaceCell = new ElementAttribute();
        spaceCell.setDefaultValue("");
        spaceCell.setElementId("base_space_cell");
        spaceCell.setElementName("base_space_cell_name");
        spaceCell.setElementType("24"); //文本显示
        spaceCell.setElementTdType("TH");
        baseBody.add(spaceCell);

        int rows = 1;
        for (String line : baseInfoList) {
            ElementAttribute cell = new ElementAttribute();
            cell.setDefaultValue(line.replace(" ", "&nbsp;"));
            cell.setElementId("raw_base_line_" + rows);
            cell.setElementName("raw_base_line_" + rows);
            cell.setElementType("24"); //文本显示
            cell.setElementTdType("TD");
            cell.setElementTdAttr("style=\"text-align:left!important;\"");
            baseBody.add(cell);

            spaceCell = new ElementAttribute();
            spaceCell.setDefaultValue("");
            spaceCell.setElementId("base_space_cell");
            spaceCell.setElementName("base_space_cell_name");
            spaceCell.setElementType("24"); //文本显示
            spaceCell.setElementTdType("TD");
            baseBody.add(spaceCell);

            rows++;
        }
        body.addAll(baseBody);

        List<ElementAttribute> detailBody = new ArrayList<>();
        for (ChannelDetail channelDetail : detailList) {
            List<String> detailLines = channelDetail.getDetailLines();
            String titleInfo = channelDetail.getTitleInfo();

            ElementAttribute title = new ElementAttribute();
            title.setDefaultValue(titleInfo.replace("|", "&nbsp;"));
            title.setElementId("raw_title_id");
            title.setElementName("raw_title_name");
            title.setElementType("24"); //文本显示
            title.setElementTdType("TH");
            title.setElementTdAttr("style=\"text-align:left !important; white-space:nowrap;\"");
            detailBody.add(title);

            spaceCell = new ElementAttribute();
            spaceCell.setDefaultValue("");
            spaceCell.setElementId("detail_space_cell");
            spaceCell.setElementName("detail_space_cell_name");
            spaceCell.setElementType("24"); //文本显示
            spaceCell.setElementTdType("TH");
            detailBody.add(spaceCell);

            rows = 1;
            for (String line : detailLines) {
                ElementAttribute cell = new ElementAttribute();
                cell.setDefaultValue(line.replace("|", "&nbsp;"));
                cell.setElementId("raw_detail_line_id_" + rows);
                cell.setElementName("raw_detail_line_name_" + rows);
                cell.setElementType("24"); //文本显示
                cell.setElementTdType("TD");
                cell.setElementTdAttr("style=\"text-align:left !important;\"");
                detailBody.add(cell);

                spaceCell = new ElementAttribute();
                spaceCell.setDefaultValue("");
                spaceCell.setElementId("detail_space_cell");
                spaceCell.setElementName("detail_space_cell_name");
                spaceCell.setElementType("24"); //文本显示
                spaceCell.setElementTdType("TD");
                detailBody.add(spaceCell);

                rows++;
            }
        }

        body.addAll(detailBody);
        detailTable.setElementAttrList(body);

        return detailTable;
    }

    @Override
    public OutDTO cityQuery(InDTO inParam) {
        SDetailCityQueryInDTO inDTO = (SDetailCityQueryInDTO) inParam;
        log.debug("inDTO=" + inDTO.getMbean());

        /**
         * 业务规则限制有
         * 1、工号查询详单权限校验  sCheckCityDetailPower.groovy
         * 2、工号查询次数的限制
         * 3、动态密码校验
         * 4、详单屏蔽限制
         * 5、神州行未签约用户不允许查询
         * 6、过户限制
         * 7、开户限制
         */

        String phoneNo = inDTO.getPhoneNo();
        String queryFlag = inDTO.getQueryFlag();
        int queryYm = inDTO.getYearMonth();
        String beginDate = inDTO.getBegintime();
        String endDate = inDTO.getEndtime();

        if (user.isInternetOfThingsPhone(phoneNo)) {
            phoneNo = user.getPhoneNoByAsn(phoneNo, CommonConst.NBR_TYPE_WLW);
        }

        //TODO 工号查询详单的权限校验
        // loginCheck.pchkFuncPowerList

        /*工号查询地市详单次数限制*/
        this.dealCityQueryTimesLimitBusi(inDTO.getLoginNo(), inDTO.getOpCode(), inDTO.getPowerLevel());


        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        long custId = userInfo.getCustId();
        String openTime = userInfo.getOpenTime(); //开户时间
        CustInfoEntity custInfo = cust.getCustInfo(custId, null);
        String custName = custInfo.getBlurCustName();

        Map<String, String> timeMap = this.getQueryTimes(userInfo.getIdNo(), queryFlag, queryYm, beginDate, endDate, openTime);
        String dealBeginTime = timeMap.get("DEAL_BEGIN_TIME"); //话单处理开始时间
        String dealEndTime = timeMap.get("DEAL_END_TIME"); //话单处理结束时间
        String callBeginTime = timeMap.get("CALL_BEGIN_TIME"); //通话开始时间
        String callEndTime = timeMap.get("CALL_END_TIME"); //通话结束时间

        String billBeginTime = timeMap.get("BILL_BEGIN_TIME"); //计费周期开始时间
        String billEndTime = timeMap.get("BILL_END_TIME"); //计费周期结束时间
        log.debug("request times = [" + dealBeginTime + "/" + dealEndTime + "," + callBeginTime + "/" + callEndTime + "]");

        List<String> baseInfo = this.getBaseInfo(phoneNo, custName, billBeginTime, billEndTime);

        List<DynamicTable> tables = new ArrayList<>(); /*10大类详单返回值*/
        DynamicTable baseTable = getBaseDynamicTable(baseInfo, inDTO.getQueryType());
        tables.add(baseTable);

        List<String> queryTypeList = this.getQueryType(inDTO.getQueryType());

        String serviceType = inDTO.getOpCode();

        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");

        for (String queryType : queryTypeList) {
            int detailType = Integer.parseInt(queryType);
            ChannelDetail channelDetail = new ChannelDetail();
            List<DynamicTable> dynamicTables = null;
            switch (detailType) {
                case 71:
                    channelDetail = detailDisplayer.comboDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 72:
                    channelDetail = detailDisplayer.voiceDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, serviceType);
                    break;
                case 73:
                    channelDetail = detailDisplayer.videoDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, serviceType);
                    break;
                case 74:
                    channelDetail = detailDisplayer.smsDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, serviceType);
                    break;
                case 75:
                    channelDetail = detailDisplayer.netDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    String mainFlag = this.getFamilyMbrFlag(phoneNo);
                    /*按帐期查询时，4G家庭需要查询共享流量*/
                    if ((queryFlag.equals("1")
                            || (queryFlag.equals("0") && beginDate.substring(0, 6).equals(endDate.substring(0, 6))))
                            && !mainFlag.isEmpty()) {

                        String queryYm4G = queryFlag.equals("1") ? String.valueOf(queryYm) : endDate.substring(0, 6);
                        String shareString = this.getFamilyShareInfo(phoneNo, queryYm4G, mainFlag);
//                      shareString = this.getFamilyShareInfo(phoneNo, "201606", "0");
                        if (!shareString.isEmpty()) {
                            List<String> globalList = channelDetail.getGlobalList();
                            globalList.add(shareString);
                            channelDetail.setGlobalList(globalList);
                        }
                    }

                    break;
                case 76:
                    channelDetail = detailDisplayer.addedDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 77:
                    channelDetail = detailDisplayer.groupDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 78:
                    channelDetail = detailDisplayer.agencyDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 79:
                    channelDetail = detailDisplayer.otherDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 80:
                    channelDetail = detailDisplayer.favourDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
            }
            dynamicTables = this.getDetailDynamicTables(channelDetail);
            tables.addAll(dynamicTables);
        }
        /*记录详单的查询日志*/
        this.saveQueryOprLog(phoneNo, userInfo.getIdNo(), inDTO.getLoginNo(), inDTO.getGroupId(),
                inDTO.getOpCode(), inDTO.getQueryType(), inDTO.getProvinceId(), inDTO.getOprType(),
                inDTO.getPowerLevel(), inDTO.getOrderNo(), inDTO.getReason());
        /*记录地市详单扩充表*/

        SDetailCityQueryOutDTO outDTO = new SDetailCityQueryOutDTO();
        outDTO.setTables(tables);

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    private List<DynamicTable> getDetailDynamicTables(ChannelDetail channelDetail) {

        String queryType = channelDetail.getQueryType();
        List<DynamicTable> tables = new ArrayList<>();

        int headTableColsNum = channelDetail.getHeadList() == null ? 2 : channelDetail.getHeadColNum() + 1;
        DynamicTable headTable = new DynamicTable(); //10类的名称列表，例 1.套餐及固定费详单,以及headList
        headTable.setElementLabelType("2");
        headTable.setElementCol(String.format("%d", headTableColsNum));

        List<ElementAttribute> headBody = new ArrayList<>();
        List<String> globalList = channelDetail.getGlobalList();
        int gx = 0;
        for (String globalTitel : globalList) {
            ElementAttribute globalCell = new ElementAttribute();
            globalCell.setDefaultValue(globalTitel);
            globalCell.setElementId(queryType + "_global_field_" + gx);
            globalCell.setElementName(queryType + "_global_name_" + gx);
            globalCell.setElementType("24"); //文本显示
            globalCell.setElementTdType("TH");
            globalCell.setElementTdAttr("style=\"text-align:left !important; font-weight:bold!important;\"");
            globalCell.setControlCols(String.format("%d", headTableColsNum - 1));
            headBody.add(globalCell);

            ElementAttribute spaceCell = new ElementAttribute();
            spaceCell.setDefaultValue("");
            spaceCell.setElementId("base_space_cell");
            spaceCell.setElementName("base_space_cell_name");
            spaceCell.setElementType("24"); //文本显示
            spaceCell.setElementTdType("TH");
            headBody.add(spaceCell);
            gx++;
        }

        List<String> headList = channelDetail.getHeadList(); //headList 合计部分，如，短信总条数|彩信息总条数
        if (headList != null && headList.size() > 0) {
            int hx = 0;
            int hy = 0;
            int colNum = 0;
            for (String headLine : headList) {
                String[] headFields = headLine.split("\\|");
                colNum = 0;
                for (hy = 0; hy < headFields.length; hy++) {
                    String headField = headFields[hy];
                    if (headField.equalsIgnoreCase("H")) {
                        continue;
                    }
                    ElementAttribute headCell = new ElementAttribute();
                    headCell.setDefaultValue(headField);
                    headCell.setElementId(queryType + "_head_field_" + hy);
                    headCell.setElementName(queryType + "_head_name_" + hy);
                    headCell.setElementType("24"); //文本显示
                    if (headLine.startsWith("h|")) {
                        headCell.setElementTdType("TD");
                    } else if (headLine.startsWith("H|")) {
                        headCell.setElementTdType("TH");
                    }
                    headCell.setElementTdAttr("style=\"text-align:left !important;\"");
                    colNum++;

                    headBody.add(headCell);
                }

                if (colNum < headTableColsNum) {
                    ElementAttribute headCell = new ElementAttribute();
                    headCell.setDefaultValue("");
                    headCell.setElementId(queryType + "_head_field_" + (hy + 1));
                    headCell.setElementName(queryType + "_head_name_" + (hy + 1));
                    headCell.setElementType("24"); //文本显示
                    if (headLine.startsWith("h|")) {
                        headCell.setElementTdType("TD");
                    } else if (headLine.startsWith("H|")) {
                        headCell.setElementTdType("TH");
                    }
                    headCell.setElementTdAttr("style=\"text-align:left !important;\"");
                    headCell.setControlCols(String.format("%d", headTableColsNum - colNum));
                    headBody.add(headCell);
                }
            }
        }
        headTable.setElementAttrList(headBody);
        tables.add(headTable);

        DynamicTable detailTable = new DynamicTable();
        List<ElementAttribute> body = new ArrayList<>();
        /*组装大类详单表头TH部分信息*/
        String titleInfo = channelDetail.getTitleInfo();
        String[] titleFields = titleInfo.split("\\|");
        int detailTableColNum = titleFields.length + 1;
        int i = 0;
        for (String titleField : titleFields) {
            ElementAttribute title = new ElementAttribute();
            title.setDefaultValue(titleField);
            title.setElementId(queryType + "_title_field_" + i);
            title.setElementName(queryType + "_title_name_" + i);
            title.setElementType("24"); //文本显示
            title.setElementTdType("TH");
            title.setElementTdAttr("style=\"text-align:left !important;\"");
            body.add(title);

            i++;
        }
        ElementAttribute spaceCell = new ElementAttribute();
        spaceCell.setDefaultValue("");
        spaceCell.setElementId("title_space_cell");
        spaceCell.setElementName("title_space_cell_name");
        spaceCell.setElementType("24"); //文本显示
        spaceCell.setElementTdType("TH");
        body.add(spaceCell);

        /*设置表格属性，列数*/
        detailTable.setElementCol(String.format("%d", detailTableColNum));
        detailTable.setElementLabelType("2"); //不显示属性列
        detailTable.setElementId(String.format("table_%s", queryType)); //table id

        /*详单实体返回部分*/
        List<String> detailLines = channelDetail.getDetailLines();
        int x = 0; //单元格所在行数
        for (String line : detailLines) {
            int y = 0; //单元格所在列数
            String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

            //详单计入帐时间，需要单独做特殊处理
            if (line.startsWith("s|")) {
                ElementAttribute cell = new ElementAttribute();
                cell.setElementId(String.format("%s_%d_colday_%d", queryType, x, y));
                cell.setDefaultValue(fields[1]);
                cell.setElementName(String.format("%s_%d_colday_%d_name", queryType, x, y));
                cell.setElementType("24");
                cell.setElementTdAttr("style=\"text-align:left !important; font-weight:bold !important;\"");
                cell.setControlCols(String.format("%d", detailTableColNum - 1));
                body.add(cell);

                spaceCell = new ElementAttribute();
                spaceCell.setElementId(String.format("%s_%d_colday_%d", queryType, x, y));
                spaceCell.setDefaultValue("");
                spaceCell.setElementName(String.format("%s_%d_colday_%d_name", queryType, x, y));
                spaceCell.setElementType("24");
                body.add(spaceCell);

                x++;
                continue;
            }

            for (String field : fields) { //详单行展示部分
                if (y >= titleFields.length) { //过滤部分前台不展示，但接口返回的回退标识字段
                    continue;
                }
                ElementAttribute cell = new ElementAttribute();
                cell.setElementId(String.format("%s_%d_col_%d", queryType, x, y));
                cell.setDefaultValue(StringUtils.isBlank(field) ? "-" : field);
                cell.setElementName(String.format("%s_%d_col_%d_name", queryType, x, y));
                cell.setElementType("24");
                cell.setElementTdAttr("style=\"text-align:left !important;\"");
                body.add(cell);
                y++;
            }
            spaceCell = new ElementAttribute(); //详单行最后一列占位，为了最后一列也能正确显示style样式
            spaceCell.setElementId(String.format("%s_%d_colday_%d", queryType, x, y));
            spaceCell.setDefaultValue("");
            spaceCell.setElementName(String.format("%s_%d_colday_%d_name", queryType, x, y));
            spaceCell.setElementType("24");
            body.add(spaceCell);

            x++;
        }

        /*汇总合并展示*/
        String footInfo = channelDetail.getFootInfo();
        String[] footFields = footInfo.split("\\|");
        ElementAttribute footLabel = new ElementAttribute();
        footLabel.setDefaultValue(footFields[0]);
        footLabel.setElementId(String.format("%s_foot_lable", queryType));
        footLabel.setElementName(String.format("%s_foot_lable", queryType));
        footLabel.setElementType("24");
        footLabel.setElementTdAttr("class=\"fwb\" style=\"text-align:left !important\"");
        body.add(footLabel);

        ElementAttribute footValue = new ElementAttribute();
        footValue.setDefaultValue(footFields[1]);
        footValue.setElementId(String.format("%s_footvalue_id", queryType));
        footValue.setElementName(String.format("%s_footvalue_name", queryType));
        footValue.setElementType("24");
        footValue.setControlCols(String.format("%d", titleFields.length - 1));
        footValue.setElementTdAttr("style=\"text-align:left !important\"");
        body.add(footValue);

        spaceCell = new ElementAttribute();
        spaceCell.setElementId(String.format("%s_footvalue_id_hid", queryType));
        spaceCell.setDefaultValue("");
        spaceCell.setElementName(String.format("%s_footvalue_name_hid", queryType));
        spaceCell.setElementType("24");
        body.add(spaceCell);

        detailTable.setElementAttrList(body);

        tables.add(detailTable);
        return tables;
    }

    /**
     * 功能：地市详单查询中工号查询次数限制规则
     *
     * @param loginNo
     * @param opCode
     * @param powerType
     */
    private void dealCityQueryTimesLimitBusi(String loginNo, String opCode, String powerType) {

        DetailLimitEntity limitEnt = detailDisplayer.getDetailLimitConf(loginNo, opCode, powerType);
        if (limitEnt == null) {
            //该工号没有查询过地市详单，则记录一次
            detailDisplayer.insertDetailLimitConf(loginNo, opCode, powerType);
        } else {
            if (limitEnt.getOpTime().equals(limitEnt.getLastTime())) { //时间格式为：YYYYMM

                if (CommonConst.DETAIL_MAX_QURRY_SUM > limitEnt.getUsedSum()) {
                    detailDisplayer.updateDetailLimitUsedSum(loginNo, opCode, powerType, false);
                } else {
                    throw new BusiException(AcctMgrError.getErrorCode("8422", "20001"), "您的工号本月已经不可以再进行查询操作，请联系管理员!");
                }
            } else {
                detailDisplayer.updateDetailLimitUsedSum(loginNo, opCode, powerType, true);
            }
        }
    }

    /**
     * 功能：跨区详单查询业务限制，除个别高级工号，普通工号不允许跨区查询用户详单
     *
     * @param loginNo
     * @param loginGroupId
     * @param phoneGroupId
     * @param provinceId
     */
    private void dealTransRegionQueryBusi(String loginNo, String loginGroupId, String phoneGroupId, String provinceId) {

        /*跨区工号配置获取*/
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CODE_CLASS", 1049);
        safeAddToMap(inMap, "CODE_ID", loginNo);
        int cnt = control.getCntPubCodeDict(inMap);

        //186100, newweb, newapp, aaa8dy, h18618, aaa831, yjboss 这些工号可进行跨区查询

        if (cnt == 0) {

            if (StringUtils.isNotEmpty(loginNo) && StringUtils.isEmptyOrNull(loginGroupId)) {
                LoginEntity loginInfo = login.getLoginInfo(loginNo, provinceId);
                loginGroupId = loginInfo.getGroupId();
            }
            GroupEntity userLoginInfo = group.getGroupInfo(loginGroupId, phoneGroupId, provinceId);
            String isSameRegion = userLoginInfo.getRegionFlag(); //Y：相同地市；N：跨区，不同地市

            if (isSameRegion.equals("N")) {
                throw new BusiException(AcctMgrError.getErrorCode("8142", "20001"), "不允许跨区查询用户详单");
            }
        }
    }

    @Override
    public OutDTO spQuery(InDTO inParam) {
        SDetailSpQueryInDTO inDTO = (SDetailSpQueryInDTO) inParam;
        log.debug("inDTO=" + inDTO.getMbean());

        String phoneNo = inDTO.getPhoneNo();
        String queryFlag = inDTO.getQueryFlag(); //只按时间段查询
        int queryYm = inDTO.getYearMonth();
        String beginDate = inDTO.getBegintime();
        String endDate = inDTO.getEndtime();
        String queryTypeIn = inDTO.getQueryType(); //全部为 0

        /**
         * 规则限制：
         * 1、只可查询近六月详单 sCheckQueryRange.groovy
         * 2、跨区补卡用户三日内不允许查询详单 sTransRegionLimit.groovy
         * 3、神州行未续约用户不允许查询详单 (sEasyOwn.groovy)未实现groovy
         * 4、用户过户前数据是否可以查询限制 （服务直接实现过户查询限制）
         * 5、未开户用户不允许查询开户前的详单数据 （服务直接实现过户查询限制）
         * 6、详单屏蔽业务限制 （sDetailQueryLimited.groovy）
         * 7、跨区不允许查询用户详单（dealTransRegionQueryBusi）
         */

        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        long custId = userInfo.getCustId();
        String openTime = userInfo.getOpenTime(); //开户时间
        CustInfoEntity custInfo = cust.getCustInfo(custId, null);
        String custName = custInfo.getBlurCustName();

        Map<String, String> timeMap = this.getQueryTimes(userInfo.getIdNo(), queryFlag, queryYm, beginDate, endDate, openTime);
        String dealBeginTime = timeMap.get("DEAL_BEGIN_TIME"); //话单处理开始时间
        String dealEndTime = timeMap.get("DEAL_END_TIME"); //话单处理结束时间
        String callBeginTime = timeMap.get("CALL_BEGIN_TIME"); //通话开始时间
        String callEndTime = timeMap.get("CALL_END_TIME"); //通话结束时间

        String billBeginTime = timeMap.get("BILL_BEGIN_TIME"); //计费周期开始时间
        String billEndTime = timeMap.get("BILL_END_TIME"); //计费周期结束时间
        log.debug("request times = [" + dealBeginTime + "/" + dealEndTime + "," + callBeginTime + "/" + callEndTime + "]");
        List<String> baseInfo = this.getBaseInfo(phoneNo, custName, billBeginTime, billEndTime);

        List<ChannelDetail> channelDetailList = new ArrayList<>();

        List<String> queryTypeList = this.getSpQueryType(queryTypeIn);
        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");

        ChannelDetail channelDetail = null;
        for (String queryType : queryTypeList) {
            channelDetail = detailDisplayer.spDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
            channelDetailList.add(channelDetail);
        }

        /*记录详单的查询日志*/
        String remark = "sp详单查询";
        this.saveQueryOprLog(phoneNo, userInfo.getIdNo(), inDTO.getLoginNo(), inDTO.getGroupId(),
                inDTO.getOpCode(), inDTO.getQueryType(), inDTO.getProvinceId(), null, null, null, remark);

        SDetailSpQueryOutDTO outDTO = new SDetailSpQueryOutDTO();
        outDTO.setBaseInfo(baseInfo);
        outDTO.setChannelDetails(channelDetailList);

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    @Override
    public OutDTO dynamicSpQuery(InDTO inParam) {
        SDetailDynamicSpQueryInDTO inDTO = (SDetailDynamicSpQueryInDTO) inParam;
        log.debug("inDTO=" + inDTO.getMbean());

        String phoneNo = inDTO.getPhoneNo();
        String queryFlag = inDTO.getQueryFlag(); //只按时间段查询
        int queryYm = inDTO.getYearMonth();
        String beginDate = inDTO.getBegintime();
        String endDate = inDTO.getEndtime();
        String queryType = inDTO.getQueryType();

        /**
         * 规则限制：
         * 1、只可查询近六月详单 sCheckQueryRange.groovy
         * 2、跨区补卡用户三日内不允许查询详单 sTransRegionLimit.groovy
         * 3、神州行未续约用户不允许查询详单 (sEasyOwn.groovy)未实现groovy
         * 4、用户过户前数据是否可以查询限制 （服务直接实现过户查询限制）
         * 5、未开户用户不允许查询开户前的详单数据 （服务直接实现过户查询限制）
         * 6、详单屏蔽业务限制 （sDetailQueryLimited.groovy）
         * 7、跨区不允许查询用户详单（dealTransRegionQueryBusi）
         */

        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        long custId = userInfo.getCustId();
        String openTime = userInfo.getOpenTime(); //开户时间
        CustInfoEntity custInfo = cust.getCustInfo(custId, null);
        String custName = custInfo.getBlurCustName();

        Map<String, String> timeMap = this.getQueryTimes(userInfo.getIdNo(), queryFlag, queryYm, beginDate, endDate, openTime);
        String dealBeginTime = timeMap.get("DEAL_BEGIN_TIME"); //话单处理开始时间
        String dealEndTime = timeMap.get("DEAL_END_TIME"); //话单处理结束时间
        String callBeginTime = timeMap.get("CALL_BEGIN_TIME"); //通话开始时间
        String callEndTime = timeMap.get("CALL_END_TIME"); //通话结束时间

        String billBeginTime = timeMap.get("BILL_BEGIN_TIME"); //计费周期开始时间
        String billEndTime = timeMap.get("BILL_END_TIME"); //计费周期结束时间
        log.debug("request times = [" + dealBeginTime + "/" + dealEndTime + "," + callBeginTime + "/" + callEndTime + "]");
        List<String> baseInfo = this.getBaseInfo(phoneNo, custName, billBeginTime, billEndTime);

        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");

        List<DynamicTable> tables = new ArrayList<>(); /*10大类详单返回值*/
        DynamicTable baseTable = this.getBaseDynamicTable(baseInfo, inDTO.getQueryType());
        tables.add(baseTable);

        ChannelDetail channelDetail = null;
        List<DynamicTable> dynamicTables = null;


        channelDetail = detailDisplayer.spDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);

        dynamicTables = this.getDetailDynamicTables(channelDetail);
        tables.addAll(dynamicTables);
        /*记录详单的查询日志*/
        String remark = "sp详单查询";
        this.saveQueryOprLog(phoneNo, userInfo.getIdNo(), inDTO.getLoginNo(), inDTO.getGroupId(),
                inDTO.getOpCode(), inDTO.getQueryType(), inDTO.getProvinceId(), null, null, null, remark);

        SDetailDynamicSpQueryOutDTO outDTO = new SDetailDynamicSpQueryOutDTO();
        outDTO.setTables(tables);

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    @Override
    public OutDTO smsStats(InDTO inParam) {
        SDetailSmsStatsInDTO inDTO = (SDetailSmsStatsInDTO) inParam;
        log.debug("inDTO=" + inDTO.getMbean());

        String phoneNo = inDTO.getPhoneNo();
        int queryYm = DateUtils.getCurYm();
        String beginDate = String.format("%6d01", DateUtils.getCurYm());
        String endDate = String.format("%8d", DateUtils.getCurDay());

        /**
         * 规则限制：
         * 1、用户过户前数据是否可以查询限制 （服务直接实现过户查询限制）
         * 2、未开户用户不允许查询开户前的详单数据 （服务直接实现过户查询限制）
         * 3、跨区不允许查询用户详单（dealTransRegionQueryBusi）
         */

        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        String openTime = userInfo.getOpenTime(); //开户时间

        String queryFlag = "0"; //按时间段查询
        Map<String, String> timeMap = this.getQueryTimes(userInfo.getIdNo(), queryFlag, queryYm, beginDate, endDate, openTime);
        String dealBeginTime = timeMap.get("DEAL_BEGIN_TIME"); //话单处理开始时间
        String dealEndTime = timeMap.get("DEAL_END_TIME"); //话单处理结束时间
        String callBeginTime = timeMap.get("CALL_BEGIN_TIME"); //通话开始时间
        String callEndTime = timeMap.get("CALL_END_TIME"); //通话结束时间

        String queryType = "74";

        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");
        Map<String, Integer> smsMap = detailDisplayer.smsStats(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);

        SDetailSmsStatsOutDTO outDTO = new SDetailSmsStatsOutDTO();
        outDTO.setSmsCount(smsMap.get("SMS_COUNT")); //短信总条数
        outDTO.setMmsCount(smsMap.get("MMS_COUNT")); //彩信总条数
        outDTO.setSsCount(smsMap.get("SS_COUNT")); //普通短信条数
        outDTO.setCdCount(smsMap.get("CD_COUNT")); //移动彩信条数
        outDTO.setSiCount(smsMap.get("SI_COUNT")); //国际短信条数
        outDTO.setCiCount(smsMap.get("CI_COUNT")); //国际彩信条数
        outDTO.setSgCount(smsMap.get("SG_COUNT")); //互联网短信条数
        outDTO.setCgCount(smsMap.get("CG_COUNT")); //互联网彩信条数
        outDTO.setScCount(smsMap.get("SC_COUNT")); //短号短信条数
        outDTO.setMcCount(smsMap.get("MC_COUNT")); //行业网关短信条数
        outDTO.setSmsSendCount(smsMap.get("SMS_SEND_COUNT")); //短信总发送条数
        outDTO.setSmsRecvCount(smsMap.get("SMS_RECV_COUNT")); //短信总接收条数
        outDTO.setMmsSendCount(smsMap.get("MMS_SEND_COUNT")); //彩信总发送条数
        outDTO.setMmsRecvCount(smsMap.get("MMS_RECV_COUNT")); //彩信总接收条数


        return outDTO;
    }

    @Override
    public OutDTO cityQueryOld(InDTO inParam) {
        SDetailCityQueryOldInDTO inDTO = (SDetailCityQueryOldInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        /**
         * 业务规则限制有
         * 1、工号查询详单权限校验  sCheckCityDetailPower.groovy
         * 2、工号查询次数的限制
         * 3、动态密码校验
         * 4、详单屏蔽限制
         * 5、神州行未签约用户不允许查询
         * 6、过户限制
         * 7、开户限制
         */

        String phoneNo = inDTO.getPhoneNo();
        String queryFlag = inDTO.getQueryFlag();
        int queryYm = inDTO.getYearMonth();
        String beginDate = inDTO.getBegintime();
        String endDate = inDTO.getEndtime();
        String powerLevel = inDTO.getPowerLevel();

        boolean isPage = "Y".equalsIgnoreCase(inDTO.getIsPage()) ? true : false;

        /*工号查询地市详单次数限制*/
        this.dealCityQueryTimesLimitBusi(inDTO.getLoginNo(), inDTO.getOpCode(), inDTO.getPowerLevel());


        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        long custId = userInfo.getCustId();
        String openTime = userInfo.getOpenTime(); //开户时间
        CustInfoEntity custInfo = cust.getCustInfo(custId, null);
        String custName = custInfo.getBlurCustName();

        Map<String, String> timeMap = this.getQueryTimes(userInfo.getIdNo(), queryFlag, queryYm, beginDate, endDate, openTime);
        String dealBeginTime = timeMap.get("DEAL_BEGIN_TIME"); //话单处理开始时间
        String dealEndTime = timeMap.get("DEAL_END_TIME"); //话单处理结束时间
        String callBeginTime = timeMap.get("CALL_BEGIN_TIME"); //通话开始时间
        String callEndTime = timeMap.get("CALL_END_TIME"); //通话结束时间

        String billBeginTime = timeMap.get("BILL_BEGIN_TIME"); //计费周期开始时间
        String billEndTime = timeMap.get("BILL_END_TIME"); //计费周期结束时间
        log.debug("request times = [" + dealBeginTime + "/" + dealEndTime + "," + callBeginTime + "/" + callEndTime + "]");

        int pageNo = inDTO.getPageNo();
        int pageSize = inDTO.getPageSize();
        int lineBegIndex = (pageNo - 1) * pageSize;
        int lineEndIndex = pageNo * pageSize;

        long loginAccept = control.getSequence("SEQ_SYSTEM_SN");
        List<String> baseInfo = this.getRawDetailHeadInfo(phoneNo, billBeginTime, billEndTime, queryFlag, inDTO.getLoginNo(), loginAccept);

        boolean highPower = powerLevel.equals("1") ? true : false;

        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");

        List<ChannelDetail> channelDetailList = new ArrayList<>();

        List<String> queryTypeList = this.getCityOldQueryTypes(inDTO.getQueryType());
        for (String queryType : queryTypeList) {
            ChannelDetail detailInfo = new ChannelDetail();
            detailInfo.setQueryType(queryType);
            detailInfo.setTitleInfo(this.getCityOldTitleInfo(queryType, highPower)); //TODO

            List<String> detailLines = null;
            String cacheKey = null;
            int totalLines = 0;
            StringBuilder sb = new StringBuilder().append(phoneNo).append(queryType)
                    .append(dealBeginTime).append(dealEndTime)
                    .append(callBeginTime).append(callEndTime); //缓存KEY
            if (queryType.equals("1") || queryType.equals("2") || queryType.equals("3")) {
                sb.append(powerLevel);
            }
            cacheKey = DigestUtils.shaHex(sb.toString()); //sha1运算
            if (cacheSwitch.equalsIgnoreCase("ON") && cacheOpr.exists(cacheKey)) {
                detailLines = cacheOpr.getDetail(cacheKey); //TODO
            } else {
                detailLines = detailDisplayer.cityOldDetail(phoneNo, queryType, serverInfo, dealBeginTime, dealEndTime,
                        callBeginTime, callEndTime, inDTO.getOpCode(), true);

                if ("ON".equals(cacheSwitch)) {
                    cacheOpr.setValueToCache(cacheKey, detailLines);
                }
            }

            totalLines = detailLines.size(); //分页时，只按一种类型的进行查询，所以这里可以不用做累加
            if (isPage && totalLines > 0) {
                lineBegIndex = (lineBegIndex >= totalLines && totalLines <= pageSize) ? 0 : lineBegIndex;
                lineEndIndex = lineEndIndex <= totalLines ? lineEndIndex : (totalLines); //控制结束下标，防止越界
                List<String> subLines = detailLines.subList(lineBegIndex, lineEndIndex);
                detailInfo.setDetailLines(subLines);
            } else {
                detailInfo.setDetailLines(detailLines);
            }

            detailInfo.setCount(totalLines);

            channelDetailList.add(detailInfo);

        }

        /*记录详单的查询日志*/
        this.saveQueryOprLog(phoneNo, userInfo.getIdNo(), inDTO.getLoginNo(), inDTO.getGroupId(),
                inDTO.getOpCode(), inDTO.getQueryType(), inDTO.getProvinceId(), inDTO.getOprType(),
                inDTO.getPowerLevel(), inDTO.getOrderNo(), inDTO.getReason());

        SDetailCityQueryOldOutDTO outDto = new SDetailCityQueryOldOutDTO();

        outDto.setBaseInfo(baseInfo);
        outDto.setChannelDetails(channelDetailList);

        log.debug("outDto=" + outDto.toJson());

        return outDto;
    }

    private String getCityOldTitleInfo(String queryType, boolean highPower) {
        String titleInfo = "";

        if (queryType.equals("1") || queryType.equals("2") || queryType.equals("3")) {
            titleInfo = "主叫号|被叫号|通话时间|呼叫时长|被访局|基本费|长途费|费用合计|通话地点|通话类型|实收基本费|实收长途费|实收合计|网络";
            if (highPower) {
                titleInfo += "|交换机号|LAC码|小区号码";
            }
        } else if (queryType.equals("46")) { /*可视电话*/
            titleInfo = "主叫号|被叫号|通话时间|时长|被访局|基本费|长途费|费用合计|通话地点|通话类型|实收基本费|实收长途费|实收合计";
        } else if (queryType.equals("4")) { /*呼转*/
            titleInfo = "主叫号|被叫号|被叫呼转号|通话时间|时长|到访地区|归属地区|基本费|长途费1|长途费2|通话类型|网络";
        } else if (queryType.equals("51")) { /*可视电话呼转*/
            titleInfo = "主叫号|被叫号|被叫呼转号|通话时间|时长|到访地区|归属地区|基本费|长途费1|长途费2|通话类型";
        } else if (queryType.equals("9")) { /*VPMN*/
            titleInfo = "主叫号|被叫号|通话时间|时长|局|基本费|长途费|合计|通话地点|类型|基本费|长途费|合计|网络|标识|漫游类型|MSC_ID|LAC_ID|CELL_ID";
        } else if (queryType.equals("15")) { /*语音杂志*/
            titleInfo = "主叫号码|被叫号码|开始时间|通话时长|计费类型|信息费";
        } else if (queryType.equals("17")) { /*全球呼*/
            titleInfo = "主叫号码|被叫号码|开始时间|通话时长|基本通信费";
        } else if (queryType.equals("5") /*短信*/ || queryType.equals("8") /*短信互通*/ || queryType.equals("56") /*短号短信话单*/) {
            titleInfo = "主叫号|被叫号|通话时间|基本费|源信息|信息类型|来源|发送状态";
        } else if (queryType.equals("6")) { /*移动梦网(or 代收话单)*/
            titleInfo = "计费号码|服务代码|第三方号码|消息接收时间|类型|费用|SP名称|业务代码|业务名称|费用类型";
        } else if (queryType.equals("57")) { /*手机游戏*/
            titleInfo = "计费号码|第三方号码|消息接收时间|产品名称|企业代码|业务代码|计费类别|费用|承载方式|游戏内容名称";
        } else if (queryType.equals("58")) { /*手机对讲业务(PoC)*/
            titleInfo = "计费号码|费用产生月份|通话时长|产品名称|订购时间|计费类别|费用";
        } else if (queryType.equals("59")) { /*手机动漫话单*/
            titleInfo = "用户手机号|开始时间|结束时间|订购途径|归属地|SP名称|业务名称|计费类别|费用";
        } else if (queryType.equals("60")) { /*12582农信通百事易*/
            titleInfo = "付费用户号码|费用产生月份|产品名称|计费时间|计费类型|费用";
        } else if (queryType.equals("61")) { /*12582农信通百事易*/
            titleInfo = "用户号码|计费时间|计费类型|费用";
        } else if (queryType.equals("62")) { /*亲情通话单*/
            titleInfo = "用户号码|SP企业代码|SP业务代码|计费时间|计费类型|费用";
        } else if (queryType.equals("64")) { /*宜居通话单*/
            titleInfo = "计费号码|计费时间|类型|费用|SP名称|业务代码";
        } else if (queryType.equals("7") || queryType.equals("63")) { /*GPRS话单*//*GPRS国际漫游话单*/
            titleInfo = "主叫号码|APN代码|业务名称|通信日期|流量(K)|时长|漫游类型|漫游地|归属地|费用合计|实收合计|网络";
        } else if (queryType.equals("45")) {/* [多媒体彩铃] */
            titleInfo = "计费手机号|赠予号码|接入号码|开始时间|结束时间|sp代码|计费类型|业务类型|会员属性|订购途径|业务标识码|音源ID|彩铃ID|铃音费用|优惠后铃音费用";
        } else if (queryType.equals("47")) {/* [随E行G3上网笔记本话单] */
            titleInfo = "呼叫类型|主叫号码|APN代码|业务名称|通信日期|流量(K)|时长|漫游类型|漫游地|归属地|网络";
        } else if (queryType.equals("48")) {/* [视频留言] */
            titleInfo = "计费手机号|留言用户号码|开始时间|持续时间|留言平台ID|SP代码|服务代码|业务代码|留言类型|留言访问类型|服务等级|话单类型";
        } else if (queryType.equals("50")) {/* [视频会议] */
            titleInfo = "创建用户号码|参与用户号码|开始时间|持续时间|SP代码|服务代码|业务代码|计费类型|会议发起方式|会议创建方式|会议媒体类型|呼叫方式|原始通信费|通信费";
        } else if (queryType.equals("49")) {/* [视频共享] */
            titleInfo = "计费用户号码|呼叫类型|共享发起用户号码|共享接收用户号码|发起共享用户终端类型|接收共享用户终端类型|共享开始时间|共享持续时长|SP代码|服务代码|业务代码|通信费|优惠后通信费";
        } else if (queryType.equals("10")) {/* [移动彩信话单] */
            titleInfo = "计费号码|接收方地址|话单类型|计费类型|发送时间|MM长度|通信费|信息费|SP代码";
        } else if (queryType.equals("11")) {/* [移动电话购物话单] */
            titleInfo = "主叫号|被叫号|购物地点|购物时间|物品名称|数量|费用";
        } else if (queryType.equals("12")) {/* [WLAN话单] */
            titleInfo = "计费号码|归属省|漫游省|认证类型|起始时间|结束时间|时长|上行流量|下行流量|通信费|信息费";
        } else if (queryType.equals("13")) {/* [彩铃话单] */
            titleInfo = "计费号码|时间|计费类型|服务供应商|服务代码|月租费|信息费|归属地";
        } else if (queryType.equals("14")) {/* [彩话话单] */
            titleInfo = "主叫号码|被叫号|开始时间|结束时间|通话时长|费用";
        } else if (queryType.equals("14")) {/* [彩话话单-包月] */ //TODO 相同类型，怎么处理，展示字段一到，
            titleInfo = "计费号码|时间|计费类型|服务供应商|服务代码|月租费|信息费|归属地";
        } else if (queryType.equals("16")) {/* [号簿管家话单] */
            titleInfo = "主叫号码|被叫号码|开始时间|结束时间|时长|上行流量|下行流量|费用";
        } else if (queryType.equals("18")) {/* [边界漫游详单] */
            titleInfo = "类型|计费号码|对端号码|通话时间|漫游类型|基本通话费|MSC_ID|LAC_ID|CELL_ID|边界/小区";
        } else if (queryType.equals("20")) {/* [智能名片夹] */
            titleInfo = "主叫号码|被叫号码|开始时间|计费类型|通话时长|基本通信费";
        } else if (queryType.equals("19")) {/* [VPMN包月] */
            titleInfo = "主叫号码|通话时间|包月费";
        } else if (queryType.equals("21")) {/* [手机动画] */
            titleInfo = "计费号码|URL请求时间|类型|信息费|SP名称|业务代码|业务名称|费用类型";
        } else if (queryType.equals("22")/* [集团总机] */
                || queryType.equals("23") /* [小区短信] */
                || queryType.equals("24") /*企业信息机*/) {
            titleInfo = "主叫号码|被叫号码|开始时间|计费类型|通话时长|基本通信费";
        } else if (queryType.equals("35")) {/* [手机视频] */
            titleInfo = "主叫号码|计费类型|包代码|服务类型|操作代码|系统类型|信息费|信息费1|时长|处理日期|开始时间";
        } else if (queryType.equals("39")) {/* [无线音乐俱乐部话单] */
            titleInfo = "主叫号码|开始时间|结束时间|sp代码|服务代码|会员级别|信息费|原信息费|音乐业务|业务名称";
        } else if (queryType.equals("33")) {/* [互联彩信话单] */
            titleInfo = "计费号码|发送方地址|接收方地址|话单类型|计费类型|发送时间|MM长度|通信费|信息费|SP代码";
        } else if (queryType.equals("40")) {/* [彩票投注话单] */
            titleInfo = "主叫号码|投注日期|投注金额|公司代码";
        } else if (queryType.equals("41")) {/* [行业应用短信话单] */
            titleInfo = "计费号码|SI代码|服务代码|业务代码|计费类型|通信费|发送时间";
        } else if (queryType.equals("43")) {/* [手机地图] */
            titleInfo = "使用方式|用户号码|定位发起号码|被定位号码|SP代码|业务代码|计费类别|信息费|起始时间|流量";
        } else if (queryType.equals("44")) {/* [全网农信通] */
            titleInfo = "计费号码|对端号码|发送日期|服务商代码|sp类型|接入代码|业务代码|计费类型|通信费|信息费";
        } else if (queryType.equals("52")) {/* [Mobile Markets业务话单] */
            titleInfo = "承载类型|用户手机号|目标用户号码|企业代码|业务代码|应用类型|开始时间|结束时间|计费类别|优惠后信息费|业务访问方式";
        } else if (queryType.equals("53")) {/* [widget话单] */
            titleInfo = "信息源类型|承载类型|计费号码|企业代码|业务代码|业务属性|URL请求时间|计费类别|信息费";
        } else if (queryType.equals("54")) {/* [手机电视(广电合作)] */
            titleInfo = "计费号码|业务类型|套餐名称|时间|费用";
        } else if (queryType.equals("55")) {/* [手机阅读话单] */
            titleInfo = "付费用户号码|处理时间|业务名称|订购时间|计费类型|资费";
        }


        return titleInfo;
    }

    private List<String> getCityOldQueryTypes(String queryType) {
        List<String> typeList = new ArrayList<>();
        if (queryType.equals("0")) {
            String[] arr = new String[]{"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "12", "13", "14", "15", "16",
                    "19", "20", "21", "22", "23", "33", "35", "39", "40", "41", "43", "44", "45", "46", "47", "48", "49",
                    "50", "51", "52", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "66"};
            typeList = Arrays.asList(arr);
        } else {
            typeList.add(queryType);
        }

        return typeList;
    }

    public IUser getUser() {
        return user;
    }

    public void setUser(IUser user) {
        this.user = user;
    }

    public ILogin getLogin() {
        return login;
    }

    public void setLogin(ILogin login) {
        this.login = login;
    }

    public IRecord getRecord() {
        return record;
    }

    public void setRecord(IRecord record) {
        this.record = record;
    }

    public ICust getCust() {
        return cust;
    }

    public void setCust(ICust cust) {
        this.cust = cust;
    }

    public IDetailDisplayer getDetailDisplayer() {
        return detailDisplayer;
    }

    public void setDetailDisplayer(IDetailDisplayer detailDisplayer) {
        this.detailDisplayer = detailDisplayer;
    }

    public IGroup getGroup() {
        return group;
    }

    public void setGroup(IGroup group) {
        this.group = group;
    }

    public IControl getControl() {
        return control;
    }

    public void setControl(IControl control) {
        this.control = control;
    }

    public CacheOpr getCacheOpr() {
        return cacheOpr;
    }

    public void setCacheOpr(CacheOpr cacheOpr) {
        this.cacheOpr = cacheOpr;
    }

    public IShortMessage getShortMessage() {
        return shortMessage;
    }

    public void setShortMessage(IShortMessage shortMessage) {
        this.shortMessage = shortMessage;
    }
}
