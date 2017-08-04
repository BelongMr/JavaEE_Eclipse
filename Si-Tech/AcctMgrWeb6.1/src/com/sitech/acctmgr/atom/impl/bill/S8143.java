package com.sitech.acctmgr.atom.impl.bill;

import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.bill.*;
import com.sitech.acctmgr.atom.domains.cct.CreditInfoEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.free.Free2DispEntity;
import com.sitech.acctmgr.atom.domains.query.FreeMinBill;
import com.sitech.acctmgr.atom.domains.record.ActQueryOprEntity;
import com.sitech.acctmgr.atom.domains.user.BilldayInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.bill.*;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.inter.bill.I8143;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.service.client.ServiceUtil;

import org.apache.commons.lang.StringUtils;

import java.util.*;

import static org.apache.commons.collections.MapUtils.*;

/**
 * Created by wangyla on 2016/5/10.
 */
@ParamTypes({
        @ParamType(c = QryBillHomeInDTO.class, m = "qryBillHome", oc = QryBillHomeOutDTO.class),
        @ParamType(c = QryBillSchemeInDTO.class, m = "qryBillScheme", oc = QryBillSchemeOutDTO.class),
        @ParamType(c = QrySixBillInDTO.class, m = "qrySixBill", oc = QrySixBillOutDTO.class),
        @ParamType(c = QryBillApxInDTO.class, m = "qryBillApx", oc = QryBillApxOutDTO.class),
        @ParamType(c = SmsBillQueryInDTO.class, m = "smsBillQuery", oc = SmsBillQueryOutDTO.class)
})
public class S8143 extends AcctMgrBaseService implements I8143 {
    private IUser user;
    private IBill bill;
    private ICredit credit;
    private IControl control;
    private ICust cust;
    private IBalance balance;
    private IAccount account;
    private IBillDisplayer billDisplayer;
    private ILogin login;
    private IRecord record;
    private IGroup group;
    private IFreeDisplayer freeDisplayer;

    @Override
    public OutDTO qryBillHome(InDTO inParam) {

        QryBillHomeInDTO param = (QryBillHomeInDTO) inParam;
        log.debug("inDTO=" + param.getMbean());
        //六个月查询限制，过户限制 ，可走Groovy规则校验

        //获取用户信息
        String phoneNO = param.getPhoneNo();
        UserInfoEntity userMap = user.getUserInfo(phoneNO);
        long id = userMap.getIdNo();
        String brandID = userMap.getBrandId(); // 品牌标识
        String regionCode = group.getRegionDistinct(userMap.getGroupId(), null, param.getProvinceId()).getRegionCode();
        long custId = userMap.getCustId(); // 客户标识

        //获取帐单客户信息区块
        int queryYm = param.getYearMonth();
        Map<String, Object> BaseInfoMap = this.getDispBaseInfo(id, custId, regionCode, queryYm);

        //获取帐户余额部分信息
        //Map<String, Long> balanceMap = this.getInitialBalances(id, queryYm);

        //获取费用部分
        BillFeeInfo2 billFee = billDisplayer.getBillFee2(id, queryYm);

        //获取代付费用信息
        Map<String, BillFeeEntity> agentFeeMap = billDisplayer.getAgentFeeInfo(id, queryYm);

        //获取帐户余额展示部分
        ConDetailDispEntity conDetailInfo = billDisplayer.getContractDetail(id, queryYm);

        //获取积分信息
        Map<String, Long> markMap = this.getMarkInfo(phoneNO, queryYm, param.getLoginNo(), "8143", param.getHeader());

        //记录日志到act_queryopr_YYYYMM 表中
        this.saveQueryOprLog(phoneNO, id, param.getLoginNo(), queryYm, brandID, param.getHeader(), param.getProvinceId());

        //拼接出参
        QryBillHomeOutDTO outParam = new QryBillHomeOutDTO();
        outParam.setCustName(getString(BaseInfoMap, "CUST_NAME"));
        outParam.setPhoneNo(phoneNO);
        outParam.setStarLevel(getString(BaseInfoMap, "STAR_LEVEL"));
        outParam.setBillCycle(getString(BaseInfoMap, "BILL_CYCLE"));
        outParam.setCurrentPoint(getLongValue(markMap, "REMAIN_POINT"));
        outParam.setTotalOwe(conDetailInfo.getTotalBalance() > 0 ? 0 : -1 * conDetailInfo.getTotalBalance());

        outParam.setCustBalance(conDetailInfo.getCustBalance());
        outParam.setMobBalance(conDetailInfo.getMobBalance());
        outParam.setTotalBalance(conDetailInfo.getTotalBalance());

        outParam.setConsume(billFee.getTotalFee().getRealFee()); //本期消费金额realfee
        outParam.setCustConsumeFee(billFee.getTotalFee().getCustPay());
        outParam.setMobConsumeFee(billFee.getTotalFee().getMobilePay());

        //余额费用部分
        outParam.setConDetailList(conDetailInfo.getDetailList());

        outParam.setFixedFee(billFee.getFixedFee());
        outParam.setVoiceFee(billFee.getCallFee());
        outParam.setVideoFee(billFee.getVideoFee());
        outParam.setNetFee(billFee.getNetFee());
        outParam.setMessageFee(billFee.getMsgFee());
        outParam.setSpFee(billFee.getSpFee());
        outParam.setProxyFee(billFee.getProxyFee());
        outParam.setGroupFee(billFee.getGroupFee());
        outParam.setOtherFee(billFee.getOtherFee());
        outParam.setTotalFee(billFee.getTotalFee());
        outParam.setFavourFee(billFee.getFavourFee()); //只使用favourfee 字段

        outParam.setOtherAgentFee(agentFeeMap.get("PERSON_AGENT"));
        outParam.setGroupAgentFee(agentFeeMap.get("GROUP_AGENT"));

        outParam.setLastPoint(getLongValue(markMap, "LAST_POINT"));
        outParam.setNewPoint(getLongValue(markMap, "NEW_POINT") + getLongValue(markMap, "BOUNS_POINT"));
        //outParam.setBonusPoint(getLongValue(markMap, "BOUNS_POINT")); //奖励积分在黑龙江累加到新增积分中，不再展示奖励积分
        outParam.setRemainPoint(getLongValue(markMap, "REMAIN_POINT"));
        outParam.setPresentPoint(getLongValue(markMap, "PRESENT_POINT"));
        outParam.setUsedPoint(getLongValue(markMap, "USED_POINT"));

        log.debug("outDto=" + outParam.toJson());

        return outParam;
    }

    private void saveQueryOprLog(String phoneNo, long idNo, String loginNo, int yearMonth, String brandID, Map<String, Object> headMap, String proviceId) {
        LoginEntity result = login.getLoginInfo(loginNo, proviceId);

        StringBuilder buffer = new StringBuilder();
        buffer.append(loginNo);
        buffer.append("查询服务号码");
        buffer.append(phoneNo + "[");
        buffer.append(yearMonth);
        buffer.append("]帐单");

        ActQueryOprEntity oprEntity = new ActQueryOprEntity();
        oprEntity.setLoginGroup(result.getGroupId());
        oprEntity.setQueryType("0");
        oprEntity.setOpCode("8143");
        oprEntity.setContactId("");
        oprEntity.setIdNo(idNo);
        oprEntity.setPhoneNo(phoneNo);
        oprEntity.setBrandId(brandID);
        oprEntity.setLoginNo(loginNo);
        oprEntity.setProvinceId(proviceId);
        oprEntity.setRemark(buffer.toString());
        record.saveQueryOpr(oprEntity, false);
    }

    /*
    * 获取帐单打印客户信息部分
    * 包括客户名称、星级、计费周期
    */
    private Map<String, Object> getDispBaseInfo(long idNo, long custId, String regionCode, int queryYm) {

        BilldayInfoEntity result = bill.getBillCycle(idNo, 0, queryYm);
        int beginTime = result.getBeginDate();// 帐期开始
        int endTime = result.getEndDate();// 帐期结束
        StringBuilder sb = new StringBuilder();
        sb.append(beginTime).append("-").append(endTime);

        CustInfoEntity custInfo = cust.getCustInfo(custId, null);
        String custName = custInfo.getBlurCustName();

        String creditName = "未评级";
        Map<String, Object> creditMap = credit.getCreditInfo(idNo);
		// 信用度名称
		if (creditMap.get("CREDIT_NAME") != null
				&& !creditMap.get("CREDIT_NAME").equals("")) {
			creditName = creditMap.get("CREDIT_NAME").toString().trim();
		}

        Map<String, Object> outMap = new HashMap<String, Object>();
        safeAddToMap(outMap, "BILL_CYCLE", sb.toString()); //计费周期
        safeAddToMap(outMap, "CUST_NAME", custName);
        safeAddToMap(outMap, "STAR_LEVEL", creditName);
        return outMap;
    }

    private Map<String, Long> getMarkInfo(String phoneNo, int yearMonth, String loginNo, String opCode, Map<String, Object> headMap) {
        MBean mbean = new MBean();
        mbean.setHeader(headMap);
        mbean.addBody("BUSI_INFO.PHONE_NO", phoneNo);
        mbean.addBody("BUSI_INFO.BILL_CYCLE", String.format("%d", yearMonth));
        mbean.addBody("OPR_INFO.OP_CODE", opCode);
        mbean.addBody("OPR_INFO.LOGIN_NO", loginNo);
        log.debug("mbean=" + mbean);
        long t1 = System.currentTimeMillis();
        String markJson = ServiceUtil.callService("com_sitech_score_comp_inter_external_IQryBillMarkInfoCoSvc_qryBillMarkInfo", mbean);
        long t2 = System.currentTimeMillis();
        log.debug("调用积分服务时长：" + (t2 - t1) + " ms , markJson=" + markJson);

        MBean resultBean = new MBean(markJson);

        Map<String, Long> result = new HashMap<String, Long>();
        safeAddToMap(result, "LAST_POINT", Long.parseLong(resultBean.getBodyStr("OUT_DATA.LAST_POINT")));
        safeAddToMap(result, "NEW_POINT", Long.parseLong(resultBean.getBodyStr("OUT_DATA.NEW_POINT")));
        safeAddToMap(result, "USED_POINT", Long.parseLong(resultBean.getBodyStr("OUT_DATA.USED_POINT")));
        safeAddToMap(result, "BOUNS_POINT", Long.parseLong(resultBean.getBodyStr("OUT_DATA.BOUNS_POINT")));
        safeAddToMap(result, "PRESENT_POINT", Long.parseLong(resultBean.getBodyStr("OUT_DATA.PRESENT_POINT")));
        safeAddToMap(result, "REMAIN_POINT", Long.parseLong(resultBean.getBodyStr("OUT_DATA.REMAIN_POINT")));

        //下面仅作测试使用
//        Map<String, Long> result = new HashMap<String, Long>();
//        long defValue = 0L;
//        safeAddToMap(result, "LAST_POINT", defValue);
//        safeAddToMap(result, "NEW_POINT", defValue);
//        safeAddToMap(result, "USED_POINT", defValue);
//        safeAddToMap(result, "BOUNS_POINT", defValue);
//        safeAddToMap(result, "PRESENT_POINT", defValue);
//        safeAddToMap(result, "REMAIN_POINT", defValue);

        return result;
    }

    @Override
    public OutDTO qrySixBill(InDTO inParam) {

        QrySixBillInDTO args = (QrySixBillInDTO) inParam;
        log.debug("inDTO=" + args.getMbean());
        QrySixBillOutDTO outDto = new QrySixBillOutDTO();

        UserInfoEntity userMap = user.getUserInfo(args.getPhoneNo());
        long id = userMap.getIdNo();

        //黑龙江以当前月为准往前推6个月
        int yearMonth = args.getYearMonth();

        long totalFee = 0;
        for (int i = 0; i < 6; i++) {
            int queryMonth = DateUtils.addMonth(yearMonth, -i);
            log.debug(String.format("query_year_month : [%s]", queryMonth));

            BillFeeInfo billFee = billDisplayer.getBillFee(id, queryMonth);

            MonthsBill monthsBill = new MonthsBill();
            monthsBill.setYearMonth(queryMonth);
            monthsBill.setFee(billFee.getTotalFee());
            switch (i) {
                case 0:
                    outDto.setMonthsBill1(monthsBill);
                    break;
                case 1:
                    outDto.setMonthsBill2(monthsBill);
                    break;
                case 2:
                    outDto.setMonthsBill3(monthsBill);
                    break;
                case 3:
                    outDto.setMonthsBill4(monthsBill);
                    break;
                case 4:
                    outDto.setMonthsBill5(monthsBill);
                    break;
                case 5:
                    outDto.setMonthsBill6(monthsBill);
                    break;
                default:
                    break;
            }

            totalFee += billFee.getTotalFee();
        }

        log.debug(outDto.toJson());

        outDto.setTotalFee(totalFee);
        return outDto;
    }


    @Override
    public OutDTO qryBillScheme(InDTO inParam) {
        final String defaultContent = "我们根据您近6个月消费情况进行了测算，您目前使用的资费非常适合您的消费习惯，近期无须变更资费方案。";
        final String defGprsContent = "我们根据您近6个月消费情况进行了测算，您目前使用的流量套餐非常适合您的消费习惯，近期无须变更流量套餐。";
        String content = "";
        String gprsContent = "";
        QryBillSchemeInDTO inDto = (QryBillSchemeInDTO) inParam;
        log.debug("inDTO=" + inDto.getMbean());

       /* if("8170".equals(opCode)){
            result = billDisplayer.getFamilyInfo(phoneNO, queryType);
            phoneNO = getString(result, "PHONE_NO");

            if(null == phoneNO){
                throw new BusiException(AcctMgrError.getErrorCode("8170", "00005"), "请输入正确的家庭主账户号码或者家庭编码!");
            }
        }*/
        //TODO 需要确认用户推荐资费的获取方式，是否由经分统一给出
        String phoneNo = inDto.getPhoneNo();
        UserInfoEntity userMap = user.getUserInfo(phoneNo);
        long id = userMap.getIdNo();
        String brandID = userMap.getBrandId(); // 品牌标识
        String regionCode = group.getRegionDistinct(userMap.getGroupId(), null, inDto.getProvinceId()).getRegionCode();
        BillFeeInfo billFee = billDisplayer.getBillFee(id, inDto.getYearMonth());
        long totalFee = billFee.getTotalFee();

        content = billDisplayer.getSchemeInfo(phoneNo, brandID, regionCode, totalFee);
        if (StringUtils.isBlank(content)) {
            content = defaultContent;
        }
        //取流量套餐资费推荐
        SchemeInfoEntity schemeInfoEnt = billDisplayer.getGprsSchemeInfo(phoneNo, inDto.getYearMonth());
        String tip = null;
        if(schemeInfoEnt != null){
        	tip = schemeInfoEnt.getTips();
        }
        
        if (StringUtils.isBlank(gprsContent)) {
            gprsContent = tip;
        }

        StringBuffer sb = new StringBuffer();
        sb.append(content);
        sb.append("    ");
        sb.append(gprsContent);

        QryBillSchemeOutDTO outParameter = new QryBillSchemeOutDTO();
        outParameter.setProdPrcDesc(sb.toString());
        return outParameter;
    }

    @Override
    public OutDTO qryBillApx(InDTO inParam) {
        QryBillApxOutDTO outParam = new QryBillApxOutDTO(); // 输出参数
        QryBillApxInDTO inDto = (QryBillApxInDTO) inParam; // 输入参数
        log.debug("inDTO=" + inDto.getMbean());

        String phoneNo = inDto.getPhoneNo();
        int yearMonth = inDto.getYearMonth();
        UserInfoEntity userMap = user.getUserEntityByPhoneNo(phoneNo, true);
        long idNo = userMap.getIdNo();

        long totalShouldPay = 0;
        long totalFavourFee = 0;
        long totalRealFee = 0;
        long totalCustPay = 0;
        long totalMobilePay = 0;

        List<AppendixBill> billList = billDisplayer.getDetailBillInfo(idNo, yearMonth);
        Map<String, Appendix1LevelBill> lv1BillMap = new HashMap<>(); //存放大类帐单附录页信息
        for (AppendixBill appendixBill : billList) {

            log.info("billMap:" + appendixBill);// wangyla

            String parentItemId = appendixBill.getParentItemId();

            /*0000000007:自有增值业务费(B类）（生产未使用），11和12为返还和退费类型，不处理*/
            if (parentItemId.equals("0000000007") || parentItemId.equals("0000000011") || parentItemId.equals("0000000012")) {
                continue;
            }
            totalShouldPay += appendixBill.getShouldPay();
            totalFavourFee += appendixBill.getFavourFee();
            totalRealFee += appendixBill.getRealFee();
            totalCustPay += appendixBill.getCustPay();
            totalMobilePay += appendixBill.getMobilePay();

            if (lv1BillMap.containsKey(parentItemId)) {
                Appendix1LevelBill lv1BillInfo = lv1BillMap.get(parentItemId);
                List<AppendixBill> lv3BillList = lv1BillInfo.getDetailList();
                lv3BillList.add(appendixBill);
                lv1BillInfo.setDetailList(lv3BillList);
                long shouldNew = lv1BillInfo.getShouldPay() + appendixBill.getShouldPay();
                long favourNew = lv1BillInfo.getFavourFee() + appendixBill.getFavourFee();
                long realNew = lv1BillInfo.getRealFee() + appendixBill.getRealFee();
                long custPayNew = lv1BillInfo.getCustPay() + appendixBill.getCustPay();
                long mobileNew = lv1BillInfo.getMobilePay() + appendixBill.getMobilePay();

                lv1BillInfo.setShouldPay(shouldNew);
                lv1BillInfo.setFavourFee(favourNew);
                lv1BillInfo.setRealFee(realNew);
                lv1BillInfo.setCustPay(custPayNew);
                lv1BillInfo.setMobilePay(mobileNew);

            } else {
                Appendix1LevelBill lv1BillInfo = new Appendix1LevelBill();
                List<AppendixBill> lv3BillList = new ArrayList<>();
                lv3BillList.add(appendixBill);
                lv1BillInfo.setDetailList(lv3BillList);
                lv1BillInfo.setItemId(parentItemId);
                lv1BillInfo.setItemName(bill.getBillItemConf(parentItemId).getItemName());
                lv1BillInfo.setShouldPay(appendixBill.getShouldPay());
                lv1BillInfo.setFavourFee(appendixBill.getFavourFee());
                lv1BillInfo.setRealFee(appendixBill.getRealFee());
                lv1BillInfo.setCustPay(appendixBill.getCustPay());
                lv1BillInfo.setMobilePay(appendixBill.getMobilePay());

                lv1BillMap.put(parentItemId, lv1BillInfo);
            }
        }

        outParam.setTotalShouldPay(totalShouldPay);
        outParam.setTotalFavourFee(totalFavourFee);
        outParam.setTotalRealFee(totalRealFee);
        outParam.setTotalCustPay(totalCustPay);
        outParam.setTotalMobilePay(totalMobilePay);

        Set<String> keySet = lv1BillMap.keySet();
        Iterator<String> iter = keySet.iterator();

        while (iter.hasNext()) {
            String key = iter.next();
            int pId = Integer.parseInt(key);

            switch (pId) {
                case 1:
                    outParam.setBillInfo1(lv1BillMap.get(key));
                    break;
                case 2:
                    outParam.setBillInfo2(lv1BillMap.get(key));
                    break;
                case 3:
                    outParam.setBillInfo3(lv1BillMap.get(key));
                    break;
                case 4:
                    outParam.setBillInfo4(lv1BillMap.get(key));
                    break;
                case 5:
                    outParam.setBillInfo5(lv1BillMap.get(key));
                    break;
                case 6:
                    outParam.setBillInfo6(lv1BillMap.get(key));
                    break;
                case 8:
                    outParam.setBillInfo8(lv1BillMap.get(key));
                    break;
                case 9:
                    outParam.setBillInfo9(lv1BillMap.get(key));
                    break;
                case 10:
                    outParam.setBillInfo10(lv1BillMap.get(key));
                    break;
                default:
                    break;
            }
        }

        SpDispEntity spInfo = billDisplayer.getSpDetailinfo(phoneNo, idNo, yearMonth);
        outParam.setSpInfo(spInfo);

        // 入账明细
        ConDetailAppendixDispEntity conIncomeInfo = billDisplayer.getAppendixConDetailInfo(idNo, yearMonth);
        outParam.setIncomeInfo(conIncomeInfo);

        //通信量使用明细
        List<Free2DispEntity> freeList = this.getAppendixFreeDetailList(phoneNo, yearMonth);
        outParam.setFreeList(freeList);

        log.debug("outDto=" + outParam.toJson());
        return outParam;
    }

    private List<Free2DispEntity> getAppendixFreeDetailList(String phoneNo, int yearMonth) {
        List<Free2DispEntity> freeDispList = new ArrayList<>();
        List<FreeMinBill> freeList = freeDisplayer.getFreeDetailList(phoneNo, yearMonth, "0");

        for (FreeMinBill fmb : freeList) {
            String busiCode = fmb.getBusiCode();
            if (!busiCode.equals("1") && !busiCode.equals("2") && !busiCode.equals("3")) {
                continue;
            }

            Free2DispEntity fde = new Free2DispEntity();
            fde.setProdPrcName(fmb.getProdPrcName());
            fde.setBusiName(fmb.getBusiName());
            fde.setYearMonth(fmb.getYearMonth());
            fde.setTotal(fmb.getTotal());
            fde.setUsed(fmb.getUsed());
            fde.setRemain(fmb.getRemain());
            fde.setLastTotal(fmb.getLastTotal());
            fde.setLastUsed(fmb.getLastUsed());
            fde.setLastRemain(fmb.getLastRemain());
            fde.setUnitName(fmb.getUnitName());

            freeDispList.add(fde);
        }

        return freeDispList;

    }

    @Override
    public OutDTO smsBillQuery(InDTO inParam) {
        SmsBillQueryInDTO inDTO = (SmsBillQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        UserInfoEntity userInfo = user.getUserInfo(inDTO.getPhoneNo());

        BillFeeInfo2 billFeeInfo = billDisplayer.getBillFee2(userInfo.getIdNo(), inDTO.getYearMonth());
        BillFeeEntity fixedFee = billFeeInfo.getFixedFee();
        BillFeeEntity callFee = billFeeInfo.getCallFee();
        BillFeeEntity videoFee = billFeeInfo.getVideoFee();
        BillFeeEntity msgFee = billFeeInfo.getMsgFee();
        BillFeeEntity netFee = billFeeInfo.getNetFee();
        BillFeeEntity spFee = billFeeInfo.getSpFee();
        BillFeeEntity groupFee = billFeeInfo.getGroupFee();
        BillFeeEntity proxyFee = billFeeInfo.getProxyFee();
        BillFeeEntity otherFee = billFeeInfo.getOtherFee();

        long totalShouldFee = fixedFee.getShouldPay() + callFee.getShouldPay() + videoFee.getShouldPay()
                + msgFee.getShouldPay() + netFee.getShouldPay() + spFee.getShouldPay() + groupFee.getShouldPay()
                + proxyFee.getShouldPay() + otherFee.getShouldPay();

        long totalRealFee = fixedFee.getRealFee() + callFee.getRealFee() + + videoFee.getRealFee()
                + msgFee.getRealFee() + netFee.getRealFee() + spFee.getRealFee() + groupFee.getRealFee()
                + proxyFee.getRealFee() + otherFee.getRealFee();

        long totalFavourFee = fixedFee.getFavourFee() + callFee.getFavourFee() + videoFee.getFavourFee()
                + msgFee.getFavourFee() + netFee.getFavourFee() + spFee.getFavourFee() + groupFee.getFavourFee()
                + proxyFee.getFavourFee() + otherFee.getFavourFee();

        long totalMobileFee = fixedFee.getMobilePay() + callFee.getMobilePay() + videoFee.getMobilePay()
                + msgFee.getMobilePay() + netFee.getMobilePay() + spFee.getMobilePay() + groupFee.getMobilePay()
                + proxyFee.getMobilePay() + otherFee.getMobilePay();

        long totalCustFee = fixedFee.getCustPay() + callFee.getCustPay() + videoFee.getCustPay()
                + msgFee.getCustPay() + netFee.getCustPay() + spFee.getCustPay() + groupFee.getCustPay()
                + proxyFee.getCustPay() + otherFee.getCustPay();

        //获取最底消费
        long lowestFee = bill.getUnbillDxInfo(userInfo.getContractNo(), userInfo.getIdNo()).get("DX_PAY_MONEY");

        int curYm = DateUtils.getCurYm();
        List<SmsBillFeeEntity> smsBillList = new ArrayList<>();
        SmsBillFeeEntity smsBillEnt = new SmsBillFeeEntity();
        smsBillEnt.setFeeType("0");
        smsBillEnt.setFee1(fixedFee.getRealFee()); //套餐及固定费
        smsBillEnt.setFee2(callFee.getRealFee()); //语音通信费
        smsBillEnt.setFee3(videoFee.getRealFee()); //可视电话通信费
        smsBillEnt.setFee4(netFee.getRealFee()); //上网费
        smsBillEnt.setFee5(msgFee.getRealFee()); //短信及彩信费
        smsBillEnt.setFee6(spFee.getRealFee()); //增值业务费
        smsBillEnt.setFee8(groupFee.getRealFee()); //集团业务费
        smsBillEnt.setFee9(proxyFee.getRealFee()); //代收业务费用
        smsBillEnt.setFee10(otherFee.getRealFee()); //其他费用
        smsBillList.add(smsBillEnt);

        if (inDTO.getYearMonth() != curYm) {

            SmsBillFeeEntity smsBillEnt1 = new SmsBillFeeEntity();
            smsBillEnt1.setFeeType("1");
            smsBillEnt1.setFee1(fixedFee.getCustPay()); //套餐及固定费-客户付费
            smsBillEnt1.setFee2(callFee.getCustPay()); //语音通信费-客户付费
            smsBillEnt1.setFee3(videoFee.getCustPay()); //可视电话通信费-客户付费
            smsBillEnt1.setFee4(netFee.getCustPay()); //上网费-客户付费
            smsBillEnt1.setFee5(msgFee.getCustPay()); //短信及彩信费-客户付费
            smsBillEnt1.setFee6(spFee.getCustPay()); //增值业务费-客户付费
            smsBillEnt1.setFee8(groupFee.getCustPay()); //集团业务费-客户付费
            smsBillEnt1.setFee9(proxyFee.getCustPay()); //代收费-客户付费
            smsBillEnt1.setFee10(otherFee.getCustPay()); //其他费用-客户付费
            smsBillList.add(smsBillEnt1);

            SmsBillFeeEntity smsBillEnt2 = new SmsBillFeeEntity();
            smsBillEnt2.setFeeType("2");
            smsBillEnt2.setFee1(fixedFee.getMobilePay()); //套餐及固定费-移动付费
            smsBillEnt2.setFee2(callFee.getMobilePay()); //语音通信费-移动付费
            smsBillEnt2.setFee3(videoFee.getMobilePay()); //可视电话通信费-移动付费
            smsBillEnt2.setFee4(netFee.getMobilePay()); //上网费-移动付费
            smsBillEnt2.setFee5(msgFee.getMobilePay()); //短信及彩信费-移动付费
            smsBillEnt2.setFee6(spFee.getMobilePay()); //增值业务费-移动付费
            smsBillEnt2.setFee8(groupFee.getMobilePay()); //集团业务费-移动付费
            smsBillEnt2.setFee9(proxyFee.getMobilePay()); //代收费-移动付费
            smsBillEnt2.setFee10(otherFee.getMobilePay()); //其他费用-移动付费
            smsBillList.add(smsBillEnt2);
        }


        //TODO 获取 全球通话费随心计划营销活动提示语
        //String tipNotes = this.getTipNotes(userInfo.getIdNo(), inDTO.getYearMonth(), totalShouldFee, totalFavourFee);

        String tipNotes = "";

        ActQueryOprEntity actQryOprEntity = new ActQueryOprEntity();
        actQryOprEntity.setBrandId(userInfo.getBrandId());
        actQryOprEntity.setIdNo(userInfo.getIdNo());
        actQryOprEntity.setLoginGroup(inDTO.getGroupId());
        actQryOprEntity.setLoginNo(inDTO.getLoginNo());
        actQryOprEntity.setOpCode("8143");
        actQryOprEntity.setPhoneNo(inDTO.getPhoneNo());
        actQryOprEntity.setQueryType("sms");
        actQryOprEntity.setRemark(new StringBuilder()
                .append("用户查询短信实时帐单").toString());

        record.saveQueryOpr(actQryOprEntity, false);

        SmsBillQueryOutDTO outDTO = new SmsBillQueryOutDTO();
        outDTO.setBrandName(userInfo.getBrandName());
        outDTO.setYearMonth(inDTO.getYearMonth());
        outDTO.setShouldPay(totalShouldFee);
        outDTO.setTotalFee(totalRealFee);
        outDTO.setFavourFee(totalFavourFee);
        outDTO.setMobilePay(totalMobileFee);
        outDTO.setCustPay(totalCustFee);
        outDTO.setLowestFee(lowestFee);
        outDTO.setTipNotes(tipNotes);
        outDTO.setFeeList(smsBillList);

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    private String getTipNotes(long idNo, int yearMonth, long totalShould, long totalFavour) {

        //TODO 暂定将此参数废弃，代码中的营销活动已过期
        String tipNotes = "";
        ExFavOweFeeEntity exFeeInfo = bill.getExFeeTotalInfo(idNo, null, yearMonth);

        if (exFeeInfo.getRealFee() > 0 && exFeeInfo.getExFavourFee() > 0) {

        }

        return tipNotes;
    }

    public IUser getUser() {
        return user;
    }

    public void setUser(IUser user) {
        this.user = user;
    }

    public IBill getBill() {
        return bill;
    }

    public void setBill(IBill bill) {
        this.bill = bill;
    }

    public ICredit getCredit() {
        return credit;
    }

    public void setCredit(ICredit credit) {
        this.credit = credit;
    }

    public IControl getControl() {
        return control;
    }

    public void setControl(IControl control) {
        this.control = control;
    }

    public ICust getCust() {
        return cust;
    }

    public void setCust(ICust cust) {
        this.cust = cust;
    }

    public IBalance getBalance() {
        return balance;
    }

    public void setBalance(IBalance balance) {
        this.balance = balance;
    }

    public IAccount getAccount() {
        return account;
    }

    public void setAccount(IAccount account) {
        this.account = account;
    }

    public IBillDisplayer getBillDisplayer() {
        return billDisplayer;
    }

    public void setBillDisplayer(IBillDisplayer billDisplayer) {
        this.billDisplayer = billDisplayer;
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

    public IGroup getGroup() {
        return group;
    }

    public void setGroup(IGroup group) {
        this.group = group;
    }

    public IFreeDisplayer getFreeDisplayer() {
        return freeDisplayer;
    }

    public void setFreeDisplayer(IFreeDisplayer freeDisplayer) {
        this.freeDisplayer = freeDisplayer;
    }
}
