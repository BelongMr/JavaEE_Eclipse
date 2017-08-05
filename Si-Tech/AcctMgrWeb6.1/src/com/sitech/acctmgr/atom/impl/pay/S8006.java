package com.sitech.acctmgr.atom.impl.pay;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.busi.pay.inter.IWriteOffer;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.GroupEntity;
import com.sitech.acctmgr.atom.domains.bill.BillEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.fee.OweFeeEntity;
import com.sitech.acctmgr.atom.domains.pay.ChequeEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserDeadEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.pay.S8006CfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8006CfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S8006InitInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8006InitOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.ICheque;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.atom.entity.inter.IDelay;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.comp.busi.LoginCheck;
import com.sitech.acctmgr.inter.pay.I8006;
import com.sitech.acctmgrint.atom.busi.intface.IBusiMsgSnd;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

/**
 * <p>Title:   </p>
 * <p>Description:   </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 *
 * @author
 * @version 1.0
 */
@ParamTypes({ @ParamType(m = "init", c = S8006InitInDTO.class, oc = S8006InitOutDTO.class),
    		  @ParamType(m = "cfm", c = S8006CfmInDTO.class, oc = S8006CfmOutDTO.class)})
public class S8006 extends AcctMgrBaseService implements I8006 {

    protected IUser user;
    protected IBalance balance;
    protected IGroup group;
    protected IDelay delay;
    protected IBill bill;
    protected ICust cust;
    protected IControl control;
    protected IWriteOffer writeOffer;
    protected ICheque cheque;
    protected IRecord record;
    protected IPreOrder preOrder;
    protected IBusiMsgSnd busiOrderBc;
    protected LoginCheck loginCheck;

    /* (non-Javadoc)
     * @see com.sitech.acctmgr.inter.pay.I8006#init(com.sitech.jcfx.dt.in.InDTO)
     */
    @Override
    public OutDTO init(InDTO inParam) {

        S8006InitInDTO inDto = (S8006InitInDTO) inParam;

        log.info("陈死账回收查询init begin: " + inDto.getMbean());

		/*获取入参信息*/
        String phoneNo = inDto.getPhoneNo();
        long idNo = inDto.getIdNo();
        String groupId = inDto.getGroupId();
        String oweStatus = "1".equals(inDto.getBackType()) ? "1" : "4";//1:陈账  4:死账
		
		/*初始化变量信息*/
        String flag = null;
        long sumOweFee = 0;
        long sumDelayFee = 0;
        String oweStr = "";

        List<OweFeeEntity> oweFeeInfoList = new ArrayList<OweFeeEntity>();
        Map<String, Object> inParamMap = null;
		
		/*取当前年月和当前时间*/
        String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
        String sTotalDate = sCurTime.substring(0, 8);
        String provinceId = inDto.getProvinceId();

        if (oweStatus.equals("1")) {
            oweStr = "陈账";
        } else {
            oweStr = "死账";
        }
		
		/*查询在网信息，如果存在提示到普通缴费页面缴费*/
        UserInfoEntity userInfoMap = user.getUserEntity(idNo, phoneNo, null, false);

        if (userInfoMap != null) {
            throw new BusiException(AcctMgrError.getErrorCode("8006", "00001"), "该用户状态正常,请到普通缴费页面缴费！");
        }
		/*获取用户离网信息*/
        List<UserDeadEntity> userDeadInfoMap = user.getUserdeadEntity(phoneNo, idNo, null);

        if (userDeadInfoMap.size() == 0 || userDeadInfoMap.isEmpty()) {
            throw new BusiException(AcctMgrError.getErrorCode("8006", "00001"), "该用户信息不存在！");
        }

        int owerType = userDeadInfoMap.get(0).getOwnerType();
        long contractNo = userDeadInfoMap.get(0).getContractNo();
        String userGroupId = userDeadInfoMap.get(0).getGroupId();
        long custId = userDeadInfoMap.get(0).getCustId();
		
		/*跨地市缴费验证，不允许跨地市缴费*/
        GroupEntity groupEntity = group.getGroupInfo(groupId, userGroupId, provinceId);

        if (groupEntity.getRegionFlag().equals("N")) {
            throw new BusiException(AcctMgrError.getErrorCode("8006", "00002"), "不允许跨地市缴费！");
        }

        String regionName = groupEntity.getUserRegionName();
        
        long lbalance = 0;  //账户预存
        long lUnbillFee = 0; //账户未出帐话费
		
		/*获取用户预存信息  查询指定账本预存pay_type in(0,’BC’)*/
        inParamMap = new HashMap<String, Object>();
        inParamMap.put("CONTRACT_NO", contractNo);
        //inParamMap.put("PAY_TYPE_STR", "'0','BC'");
        String[] payTypes = new String[]{"0","BC"};
        inParamMap.put("PAY_TYPE_STR", payTypes);
        lbalance = balance.getAcctBookDeadSum(inParamMap);
		
		/*用户滞纳金信息获取*/
		inParamMap.put("NET_FLAG", "1");
		inParamMap.put("PROVINCE_ID", provinceId);
        Map<String, Object> delayRate = delay.getDelayRate(inParamMap);
        Map<String, Object> getDelayInMap = new HashMap<String, Object>();
        getDelayInMap.put("DELAY_RATE", delayRate.get("DELAY_RATE"));
        getDelayInMap.put("DELAY_BEGIN", delayRate.get("DELAY_BEGIN"));
        getDelayInMap.put("TOTAL_DATE", sTotalDate);
		
		//获取用户所有账户下的账单信息,此处账户入参应该为空
        List<BillEntity> oweFeeList = bill.getNotCycleDeadOwe(idNo, -1, oweStatus);

        if (oweFeeList.size() == 0) {
            log.info("该用户" + idNo + "无呆坏账记录！");
            throw new BusiException(AcctMgrError.getErrorCode("8006", "00003"), "该用户无" + oweStr + "记录！");
        } else {
            Map<String, Object> oweTotal = new HashMap<String, Object>();
            List<String> oweBillCycle = new ArrayList<String>();
            for (BillEntity billEntity : oweFeeList) {
                long delayFee = 0;
                long oweFee = 0;
                long shouldFee = 0;
                long favourFee = 0;
                long payedPrePay = 0;
                long payedLater = 0;
                String billCycle = null;

                shouldFee = billEntity.getShouldPay();
                favourFee = billEntity.getFavourFee();
                payedPrePay = billEntity.getPayedPrepay();
                payedLater = billEntity.getPayedLater();
                billCycle = String.valueOf(billEntity.getBillCycle());
                oweFee = billEntity.getOweFee();

                getDelayInMap.put("BILL_BEGIN", billEntity.getBillBegin());
                getDelayInMap.put("OWE_FEE", billEntity.getOweFee());
                getDelayInMap.put("BILL_CYCLE", billEntity.getBillCycle());
                delayFee = delay.getDelayFee(getDelayInMap);

                sumOweFee += oweFee;
                sumDelayFee += delayFee;

                //账单按账期合并
                if (oweTotal.containsKey(billCycle)) {
                    long oweFeeTmp = Long.parseLong(oweTotal.get(billCycle + ".oweFee").toString());
                    long shouldFeeTmp = Long.parseLong(oweTotal.get(billCycle + ".shouldFee").toString());
                    long favourFeeTmp = Long.parseLong(oweTotal.get(billCycle + ".favourFee").toString());
                    long payedPrePayTmp = Long.parseLong(oweTotal.get(billCycle + ".payedPrePay").toString());
                    long payedLaterTmp = Long.parseLong(oweTotal.get(billCycle + ".payedLater").toString());
                    long delayFeeTmp = Long.parseLong(oweTotal.get(billCycle + ".delayFee").toString());
                    log.info(billCycle + ".oweFeeTmp:" + oweFeeTmp);
                    oweFeeTmp = oweFeeTmp + oweFee;
                    shouldFeeTmp = shouldFeeTmp + shouldFee;
                    favourFeeTmp = favourFeeTmp + favourFee;
                    payedPrePayTmp = payedPrePayTmp + payedPrePay;
                    payedLaterTmp = payedLaterTmp + payedLater;
                    delayFeeTmp = delayFeeTmp + delayFee;
                    log.info(billCycle + ".oweFeeTmp-----:" + oweFeeTmp);
                    oweTotal.put(billCycle + ".oweFee", oweFeeTmp);
                    oweTotal.put(billCycle + ".shouldFee", shouldFeeTmp);
                    oweTotal.put(billCycle + ".favourFee", favourFeeTmp);
                    oweTotal.put(billCycle + ".payedPrePay", payedPrePayTmp);
                    oweTotal.put(billCycle + ".payedLater", payedLaterTmp);
                    oweTotal.put(billCycle + ".delayFee", delayFeeTmp);
                } else {
                    if (!oweBillCycle.contains(billCycle)) {
                        oweBillCycle.add(billCycle);
                    }
                    oweTotal.put(billCycle, billCycle);
                    oweTotal.put(billCycle + ".oweFee", oweFee);
                    oweTotal.put(billCycle + ".shouldFee", shouldFee);
                    oweTotal.put(billCycle + ".favourFee", favourFee);
                    oweTotal.put(billCycle + ".payedPrePay", payedPrePay);
                    oweTotal.put(billCycle + ".payedLater", payedLater);
                    oweTotal.put(billCycle + ".delayFee", delayFee);
                    log.info(billCycle + ".oweFee:" + oweFee);
                }
            }

            //循环账期取账期欠费入实体
            for (String cycle : oweBillCycle) {
                OweFeeEntity deadOweFeeEntity = new OweFeeEntity();
                String oweFee = cycle + ".oweFee";
                String shouldFee = cycle + ".shouldFee";
                String favourFee = cycle + ".favourFee";
                String payedPrePay = cycle + ".payedPrePay";
                String payedLater = cycle + ".payedLater";
                String delayFee = cycle + ".delayFee";
                log.info(cycle + ".oweFee:" + MapUtils.getLongValue(oweTotal, oweFee));
                deadOweFeeEntity.setBillCycle(Integer.parseInt(cycle));
                deadOweFeeEntity.setOweFee(MapUtils.getLongValue(oweTotal, oweFee));
                deadOweFeeEntity.setShouldPay(MapUtils.getLongValue(oweTotal, shouldFee));
                deadOweFeeEntity.setFavourFee(MapUtils.getLongValue(oweTotal, favourFee));
                long payedFee = MapUtils.getLongValue(oweTotal, payedPrePay) + MapUtils.getLongValue(oweTotal, payedLater);
                deadOweFeeEntity.setPayedFee(payedFee);
                deadOweFeeEntity.setDelayFee(MapUtils.getLongValue(oweTotal, delayFee));
                oweFeeInfoList.add(deadOweFeeEntity);
            }

        }
		
		/*获取模糊化后的客户名称*/
        CustInfoEntity custEnty = cust.getCustInfo(custId, null);
        String custBlurName = custEnty.getBlurCustName();
        String custName = custEnty.getCustName();
        String idIccid = custEnty.getIdIccid();
				
		/*获取工号滞纳金优惠权限*/
        boolean delayAble = false;
        //TODO a042 true 工号有滞纳金优惠权限 false 工号没有滞纳金优惠权限
        Map<String, Object> inTmp = new HashMap<String, Object>();
        inTmp.put("LOGIN_NO", inDto.getLoginNo());
        inTmp.put("BUSI_CODE", "BBMA0040");
        delayAble = loginCheck.pchkFuncPower(inDto.getHeader(), inTmp);
        //
        log.info("工号滞纳金优惠权限delayFavourable:"+delayAble);
				
		/*账单按账期排序*/
        //Collections.sort(oweFeeInfoList);

        S8006InitOutDTO s8006InitOutDTO = new S8006InitOutDTO();

        s8006InitOutDTO.setCustName(custName);
        s8006InitOutDTO.setUserGroupID(userGroupId);
        s8006InitOutDTO.setContractNo(contractNo);
        s8006InitOutDTO.setBalance(lbalance);
        s8006InitOutDTO.setUnbillFee(lUnbillFee);
        s8006InitOutDTO.setDelayAble(delayAble);
        s8006InitOutDTO.setRegionName(regionName);
        s8006InitOutDTO.setRunTime("");
        s8006InitOutDTO.setFlag(flag);
        s8006InitOutDTO.setSumOweFee(sumOweFee);
        s8006InitOutDTO.setSumDelayFee(sumDelayFee);
        s8006InitOutDTO.setCodeName(owerType == 3 ? "是" : "否");
        s8006InitOutDTO.setNumFlag(oweFeeInfoList.size() == 0 ? "0" : "1");
        s8006InitOutDTO.setIdNo(idNo);
        s8006InitOutDTO.setPhoneNo(phoneNo);
        s8006InitOutDTO.setFeeInfoList(oweFeeInfoList);
        s8006InitOutDTO.setIdIccid(idIccid);

        return s8006InitOutDTO;
    }

    /* (non-Javadoc)
     * @see com.sitech.acctmgr.inter.pay.I8006#cfm(com.sitech.jcfx.dt.in.InDTO)
     */
    @Override
    public OutDTO cfm(InDTO inParam) {

        S8006CfmInDTO inDto = (S8006CfmInDTO) inParam;

        log.info("8006 cfm begin :" + inDto.getMbean());
		
		/*获取入参信息*/
        String loginNo = inDto.getLoginNo();
        String phoneNo = inDto.getPhoneNo();
        long idNo = inDto.getIdNo();
        long payMoney = inDto.getPayMoney();
        String groupId = inDto.getGroupId();
        String opNote = inDto.getPayNote();
        String payType = inDto.getPayType();
        String bankCode = inDto.getBankCode();
        String opCode = "1".equals(inDto.getBackType()) ? "8006" : "8023";
        long shouldPay = Long.valueOf(inDto.getShouldPay());
        double delayRate = inDto.getDelayRate();
        String checkNo = inDto.getCheckNo();
        String billYMStr = inDto.getBillYMStr();

        String payPath = "";
        String payMethod = "";
        long contractNo = 0;
        long paySn = 0;
        long wrtoffSn = 0;
        long balanceId = 0;
        String brandId = "XX";
        long custId = 0;
        String userGroupId = "";

        //为防止缴费后立即冲销时间不一致，缴费类业务取时间都取数据库时间
        String curTime = control.getSysDate().get("CUR_TIME").toString();
        long yearMonth = Long.parseLong(curTime.substring(0, 6).toString());
        int totalDate = Integer.parseInt(curTime.substring(0, 8).toString());
        String provinceId = inDto.getProvinceId();
        String OweStatus = null;
        String PayStatus = null;
        String OperType = null;
		
		/*缴费渠道和缴费方式判断*/
        if (payType.equals("0")) {//现金缴费
            payMethod = "0";
            payPath = "11";
        } else if (PayBusiConst.PAY_TYPE_CHECK.equals(payType)) {//支票缴费
            payMethod = "9";
            payPath = "11";
        }
		
		/*陈死账类型判断*/
        if ("1".equals(inDto.getBackType())) {
            OweStatus = "1";
            PayStatus = "3";
            OperType = "1";
        } else {
            OweStatus = "4";
            PayStatus = "6";
            OperType = "2";
        }

        if (StringUtils.isEmptyOrNull(opNote)) {
            opNote = "回收陈死帐[" + loginNo + "][" + phoneNo + "]";
        }
        
        List<Map<String, Object>> billYMList = new ArrayList<Map<String, Object>>();
        if(billYMStr != null){  //入参指定月份回收陈死账字符串拆分
        	if (billYMStr.contains("|")) {
    			String[] yearMonthArr = billYMStr.split("\\|");
    			for(int i = 0; i < yearMonthArr.length; i++){
    				Map<String, Object> yearMonthMap = new HashMap<String, Object>();
    				yearMonthMap.put("BILL_CYCLE", yearMonthArr[i]);
    				billYMList.add(yearMonthMap);
    			}
    		}else{
    			Map<String, Object> yearMonthMap = new HashMap<String, Object>();
				yearMonthMap.put("BILL_CYCLE", billYMStr);
				billYMList.add(yearMonthMap);
    		}
        }
        log.info("入参指定月份拆分billYMList:"+billYMList.size());
		
		/*获取离网用户信息*/
        List<UserDeadEntity> userDeadEnt = user.getUserdeadEntity(phoneNo, idNo, contractNo);
        contractNo = userDeadEnt.get(0).getContractNo();
        custId = userDeadEnt.get(0).getCustId();
        userGroupId = userDeadEnt.get(0).getGroupId();
		
		/*缴费用户归属地市*/
        ChngroupRelEntity groupEntity = group.getRegionDistinct(userGroupId, "2", provinceId);
        String regionId = groupEntity.getRegionCode();
		
		/*获取缴费流水等流水信息*/
        paySn = control.getSequence("SEQ_PAY_SN");
        wrtoffSn = control.getSequence("SEQ_WRTOFF_SN");
        balanceId = control.getSequence("SEQ_BALANCE_ID");
		
		/*基本信息和入账实体设值*/
        PayUserBaseEntity payUserBase = new PayUserBaseEntity();
        payUserBase.setBrandId(brandId);
        payUserBase.setContractNo(contractNo);
        payUserBase.setIdNo(idNo);
        payUserBase.setPhoneFlag(true);
        payUserBase.setPhoneNo(phoneNo);
        payUserBase.setRegionId(regionId);
        payUserBase.setUserGroupId(userGroupId);

        PayBookEntity inBook = new PayBookEntity();
        inBook.setBalanceId(balanceId);
        inBook.setBankCode(bankCode);
        inBook.setBeginTime(curTime);
        inBook.setGroupId(groupId);
        inBook.setLoginNo(loginNo);
        inBook.setOpCode(opCode);
        inBook.setOpNote(opNote);
        inBook.setOriginalSn(paySn);
        inBook.setPayFee(payMoney);
        inBook.setPayMethod(payMethod);
        inBook.setPayPath(payPath);
        inBook.setPaySn(paySn);
        inBook.setPayType(payType);
        inBook.setPrintFlag("0");
        inBook.setStatus("0");
        inBook.setTotalDate(totalDate);
        inBook.setYearMonth(yearMonth);
		
		/*离网入账*/
        balance.saveAcctBookDead(payUserBase, inBook);
        
      /*  记录来源表
        balance.saveSource(payUserBase, inBook);*/
        
        /*记录缴费记录表*/
        record.savePayMent(payUserBase, inBook);
        
    	/*支票缴费*/
        if (PayBusiConst.PAY_TYPE_CHECK.equals(payType)) {
            //扣除支票金额，记录支票记录表
            ChequeEntity chequeEnt = new ChequeEntity();
            chequeEnt.setBankCode(bankCode);
            chequeEnt.setCheckNo(checkNo);
            cheque.doReduceCheck(chequeEnt, inBook);
        }

        Map<String, Object> inMapTmp = new HashMap<String, Object>();
        inMapTmp.put("PAY_SN", paySn);
        inMapTmp.put("PHONE_NO", phoneNo);
        inMapTmp.put("WRTOFF_SN", wrtoffSn);
        inMapTmp.put("CONTRACT_NO", contractNo);
        inMapTmp.put("ID_NO", idNo);
        inMapTmp.put("PAY_MONTH", yearMonth);
        inMapTmp.put("BALANCE_ID", balanceId);
        inMapTmp.put("LOGIN_NO", loginNo);
        inMapTmp.put("GROUP_ID", groupId);
        inMapTmp.put("DELAY_RATE", delayRate);
        inMapTmp.put("OWE_STATUS", OweStatus);
        inMapTmp.put("PAY_STATUS", PayStatus);
        inMapTmp.put("OPER_TYPE", OperType);
        inMapTmp.put("BILL_YEAR_MONTH", billYMList);
        
        writeOffer.doRealDeadWriteOff(inMapTmp);
		
        if (payMoney >= shouldPay) {

            int cnt = 0; //用户对应证件号码下黑名单数量

            //获取用户证件信息
            CustInfoEntity custInfo = cust.getCustInfo(custId, null);
            String idType = custInfo.getIdType();
            String idICCID = custInfo.getIdIccid();

          /*  //判断是否发送黑名单
            inMapTmp = new HashMap<String, Object>();
            inMapTmp.put("OP_ACCEPT", paySn);
            inMapTmp.put("LOGIN_NO", loginNo);
            inMapTmp.put("OP_CODE", opCode);
            inMapTmp.put("ID_ICCID", idICCID);
            inMapTmp.put("ID_NO", idNo);
            inMapTmp.put("ID_TYPE", idType);
            cnt = getCntBalackInfo(inMapTmp);*/
            
            log.info("客户CUST_ID[" + custId + "]对应证件号码[" + idICCID + "]下还剩黑名单用户数[" + cnt + "]");
            if (cnt == 0) {
                // TODO 黑名单记录工单发送
                Map<String, Object> inMap = new HashMap<String, Object>();
                inMap.put("HEADER", inDto.getHeader());
                inMap.put("OWNER_FLAG", "1");
                inMap.put("ORDER_ID", "10006");// 取配置
                inMap.put("LOGIN_NO", loginNo);
                inMap.put("OP_CODE", opCode);
                inMap.put("LOGIN_ACCEPT", paySn);
                inMap.put("CREATE_TIME", curTime);
                inMap.put("BUSIID_NO", idNo);
                inMap.put("ID_NO", idNo);
                inMap.put("CUST_ID", custId);
                inMap.put("BLACKTYPE", "11");
                inMap.put("OPTYPE", "D");
                inMap.put("OP_TYPE", "BTOC");
                inMap.put("ID_TYPE", idType);
                inMap.put("ID_ICCID", idICCID);
                log.info("黑名单入参:" + inMap);
                busiOrderBc.opPubOdrSndInter(inMap);
            }
        }

        //向其他系统同步数据（目前：CRM营业日报、BOSS报表、统一接触）
        Map<String, Object> paymentKey = new HashMap<String, Object>();
        paymentKey.put("YEAR_MONTH", yearMonth);
        paymentKey.put("CONTRACT_NO", contractNo);
        paymentKey.put("PAY_SN", paySn);
        paymentKey.put("ID_NO", idNo);
        paymentKey.put("PAY_TYPE", payType);

        inMapTmp = new HashMap<String, Object>();
        inMapTmp.put("PAY_SN", paySn);
        inMapTmp.put("LOGIN_NO", loginNo);
        inMapTmp.put("GROUP_ID", groupId);
        inMapTmp.put("OP_CODE", opCode);
        inMapTmp.put("PHONE_NO", phoneNo);
        inMapTmp.put("BRAND_ID", brandId);
        inMapTmp.put("BACK_FLAG", "0");
        inMapTmp.put("OLD_ACCEPT", paySn);
        inMapTmp.put("OP_TIME", curTime);
        inMapTmp.put("OP_NOTE", opNote);
        inMapTmp.put("ACTION_ID", "1001");
        inMapTmp.put("KEY_DATA", paymentKey);
        inMapTmp.put("REGION_ID", regionId);
        inMapTmp.put("CUST_ID_TYPE", "1"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
        inMapTmp.put("CUST_ID_VALUE", phoneNo);
        inMapTmp.put("TOTAL_FEE", String.valueOf(payMoney));

        inMapTmp.put("Header", inDto.getHeader());

        preOrder.sendData(inMapTmp);
        
        
    	/*记录日志记录表*/
        LoginOprEntity oprEntity = new LoginOprEntity();
        oprEntity.setBrandId(brandId);
        oprEntity.setIdNo(idNo);
        oprEntity.setLoginGroup(groupId);
        oprEntity.setLoginNo(loginNo);
        oprEntity.setLoginSn(paySn);
        oprEntity.setOpCode(opCode);
        oprEntity.setOpTime(curTime);
        oprEntity.setPayFee(payMoney);
        oprEntity.setPayType(payType);
        oprEntity.setPhoneNo(phoneNo);
        oprEntity.setRemark(opNote);
        oprEntity.setTotalDate(totalDate);
        record.saveLoginOpr(oprEntity);
        
    	/*重复缴费限制*/
        List<Map<String, Object>> payList2 = new ArrayList<Map<String, Object>>(); //在PAY_TYPE、PAY_MONEY基础上添加对应的PAY_SN
        Map<String, Object> payMapTmp = new HashMap<String, Object>();
        payMapTmp.put("PAY_SN", paySn);
        payMapTmp.put("PAY_TYPE", payType);
        payMapTmp.put("PAY_MONEY", payMoney);
        payList2.add(payMapTmp);
        inMapTmp = new HashMap<String, Object>();
        inMapTmp.put("PAY_LIST", payList2);
        inMapTmp.put("CONTRACT_NO", contractNo);
        inMapTmp.put("CARD_SN", paySn);
        inMapTmp.put("PAY_PATH", payPath);
        inMapTmp.put("LOGIN_NO", loginNo);
        inMapTmp.put("TOTAL_DATE", totalDate);
        repeatPayCtrl( inMapTmp );

        S8006CfmOutDTO outDTO = new S8006CfmOutDTO();

        outDTO.setPaySn(paySn);

        return outDTO;
    }
    
    
    /**
	* 名称：重复缴费限制
	* @param	PAY_LIST		: List<Map<String, Object>>	每个Map中存放 PAY_SN、PAY_TYPE 、 PAY_MONEY	</br>
	* @param	CONTRACT_NO
	* @param	CARD_SN			可空，外部缴费时使用，确定外部流水唯一.记录外部流水
	* @param	PAY_PATH
	* @param	LOGIN_NO
	* @param	TOTAL_DATE
	* @author 	liuyc_billing
	*/
	private void repeatPayCtrl(Map<String, Object> inParam)  {
		
		//通过payment表控制一段时间内不允许重复缴费 
		String sPayPath = control.getPubCodeValue(2001, "CFJF", null);
		if( sPayPath.indexOf(inParam.get("PAY_PATH").toString()) != -1){
			
			paymentRepeatCtrl(inParam);
		
		}

		//通过外部缴费控制表bal_paycard_recd来控制重复缴费，配置渠道为不进行这段控制的渠道
		String sPayPath2 = control.getPubCodeValue(2002, "WWJF", null);
		if( -1 == sPayPath2.indexOf(inParam.get("PAY_PATH").toString()) ) {
			try{
				record.savePayCard(inParam);
			}catch( Exception e ){
				log.info("重复缴费PAY_PATH" + inParam.get("PAY_PATH").toString() + "LOGIN_NO" 
			+ inParam.get("LOGIN_NO").toString() + "FOREIGN_SN" + inParam.get("CARD_SN").toString() );
				throw new BusiException(AcctMgrError.getErrorCode("8000","00003"), "重复缴费");
			}
		}
		
	}
	
	protected void paymentRepeatCtrl(Map<String, Object> inParam){
		
		Map<String, Object>	inMapTmp = new HashMap<String, Object>();
		Map<String, Object>	outMapTmp = new HashMap<String, Object>();
		
		List<PubCodeDictEntity> tmpList = control.getPubCodeList(2010L, "CFJFSJ", "0", null);
		String status = tmpList.get(0).getStatus();
		long times = Long.parseLong(tmpList.get(0).getCodeValue());
		
		if(status.equals("0")){				//如果开关打开
			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put( "PAY_LIST" , inParam.get("PAY_LIST") );
			inMapTmp.put( "CONTRACT_NO" , inParam.get("CONTRACT_NO") );
			inMapTmp.put("LOGIN_NO", inParam.get("LOGIN_NO"));
			inMapTmp.put("INTERVAL", times);
			if( balance.getPayCnt(inMapTmp) > 0 ){
				log.info("此号码正在交费，请稍后再交");
				throw new BusiException(AcctMgrError.getErrorCode("8000","00002"), times + "秒内重复缴费!");
			}
		}
	}

    /**
     * @return the user
     */
    public IUser getUser() {
        return user;
    }

    /**
     * @param user the user to set
     */
    public void setUser(IUser user) {
        this.user = user;
    }

    /**
     * @return the balance
     */
    public IBalance getBalance() {
        return balance;
    }

    /**
     * @param balance the balance to set
     */
    public void setBalance(IBalance balance) {
        this.balance = balance;
    }

    /**
     * @return the group
     */
    public IGroup getGroup() {
        return group;
    }

    /**
     * @param group the group to set
     */
    public void setGroup(IGroup group) {
        this.group = group;
    }

    /**
     * @return the delay
     */
    public IDelay getDelay() {
        return delay;
    }

    /**
     * @param delay the delay to set
     */
    public void setDelay(IDelay delay) {
        this.delay = delay;
    }

    /**
     * @return the bill
     */
    public IBill getBill() {
        return bill;
    }

    /**
     * @param bill the bill to set
     */
    public void setBill(IBill bill) {
        this.bill = bill;
    }

    /**
     * @return the cust
     */
    public ICust getCust() {
        return cust;
    }

    /**
     * @param cust the cust to set
     */
    public void setCust(ICust cust) {
        this.cust = cust;
    }

    /**
     * @return the control
     */
    public IControl getControl() {
        return control;
    }

    /**
     * @param control the control to set
     */
    public void setControl(IControl control) {
        this.control = control;
    }

    /**
     * @return the writeOffer
     */
    public IWriteOffer getWriteOffer() {
        return writeOffer;
    }

    /**
     * @param writeOffer the writeOffer to set
     */
    public void setWriteOffer(IWriteOffer writeOffer) {
        this.writeOffer = writeOffer;
    }

    /**
     * @return the cheque
     */
    public ICheque getCheque() {
        return cheque;
    }

    /**
     * @param cheque the cheque to set
     */
    public void setCheque(ICheque cheque) {
        this.cheque = cheque;
    }

    /**
     * @return the record
     */
    public IRecord getRecord() {
        return record;
    }

    /**
     * @param record the record to set
     */
    public void setRecord(IRecord record) {
        this.record = record;
    }

	public IBusiMsgSnd getBusiOrderBc() {
		return busiOrderBc;
	}

	public void setBusiOrderBc(IBusiMsgSnd busiOrderBc) {
		this.busiOrderBc = busiOrderBc;
	}

	public IPreOrder getPreOrder() {
		return preOrder;
	}

	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}

	public LoginCheck getLoginCheck() {
		return loginCheck;
	}

	public void setLoginCheck(LoginCheck loginCheck) {
		this.loginCheck = loginCheck;
	}

}