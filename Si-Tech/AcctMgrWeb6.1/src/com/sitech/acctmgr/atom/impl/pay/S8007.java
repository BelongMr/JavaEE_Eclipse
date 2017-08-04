package com.sitech.acctmgr.atom.impl.pay;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.pay.ChequeEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayMentEntity;
import com.sitech.acctmgr.atom.domains.pay.PaysnBaseEntity;
import com.sitech.acctmgr.atom.domains.user.UserDeadEntity;
import com.sitech.acctmgr.atom.dto.pay.*;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.ICheque;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.domains.LoginPdomEntity;
import com.sitech.acctmgr.comp.busi.LoginCheck;
import com.sitech.acctmgr.inter.pay.I8007;
import com.sitech.acctmgrint.atom.busi.intface.IBusiMsgSnd;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

/**
*
* <p>Title: 陈死账回收回退业务流程基类  </p>
* <p>Description: 陈死账回收回退业务查询、确认  </p>
* <p>Copyright: Copyright (c) 2016</p>
* <p>Company: SI-TECH </p>
* @author guowy
* @version 1.0
*/
@ParamTypes({ @ParamType(m = "init", c = S8007InitInDTO.class, oc = S8007InitOutDTO.class),
	          @ParamType(m = "cfm", c = S8007CfmInDTO.class, oc = S8007CfmOutDTO.class),
			  @ParamType(m = "getPaySnInfo", c = S8007GetPaySnInDTO.class, oc = S8007GetPaySnOutDTO.class)})
public class S8007 extends AcctMgrBaseService implements I8007 {
	
	protected ICust cust;
	protected IRecord record;
	protected LoginCheck loginCheck;
	protected IBalance balance;
	protected IControl control;
	protected IUser user;
	protected IPayManage payManage;
	protected IRemainFee remainFee;
	protected IPreOrder preOrder;
	protected ICheque cheque;
	private IBusiMsgSnd	busiMsgsnd;

	/* (non-Javadoc)
	 * @see com.sitech.acctmgr.inter.pay.I8007#init(com.sitech.jcfx.dt.in.InDTO)
	 */
	@Override
	public OutDTO init(InDTO inParam) {

		S8007InitInDTO inDto = (S8007InitInDTO)inParam;
		
		log.info("8007 init inParam:"+inDto.getMbean());
				
		/*获取入参信息*/
		String loginNo = inDto.getLoginNo();
		String payTime = inDto.getPayTime();
		String backType = inDto.getBackType();
		long paySn = inDto.getPaySn();
		long contractNo = inDto.getContractNo();
		long idNo = inDto.getIdNo();
		long custId = inDto.getCustId();
		
		/*取当前年月和当前时间*/
		String curTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String curYM = curTime.substring(0, 6);
		String payYm = payTime.substring(0, 6);
		
		/*陈死账类型判断，1：陈账  4：死账*/
		String backOpCode = null;
		if ("1".equals(backType)) {
			backOpCode = "8006";
		} else {
			backOpCode = "8023";
		}
		
		/*获取缴费信息*/	
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("ID_NO", idNo);
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("STATUS", "0");
		inMapTmp.put("SUFFIX", Long.parseLong(payYm));
		inMapTmp.put("OP_CODE", backOpCode);
		List<PayMentEntity> outPayList = record.getPayMentList(inMapTmp);
		if (0 == outPayList.size()) {
			log.info("交费记录不存在pay_sn : " + paySn);
			throw new BusiException(AcctMgrError.getErrorCode(
					"8007", "00001"), "交费记录不存在或者已进行冲正");
		}
		PayMentEntity paymentInfo = outPayList.get(0);
		String payLoginNo = paymentInfo.getLoginNo();
		String payYearMonth = paymentInfo.getTotalDate().toString().substring(0, 6);
		String opTime = paymentInfo.getOpTime();
		
		/*获取工号权限*/
		Map<String, Object> inMap = new HashMap<String, Object>();
		List<Map<String, Object>> privsList = new ArrayList<Map<String, Object>>();
		Map<String, Object> privMap1 = new HashMap<String, Object>();
		//privMap1.put("BUSI_CODE", "a001"); //不能退其他工号的陈死账回收
		privMap1.put("BUSI_CODE", "BBMA0001"); //不能退其他工号的陈死账回收
		privsList.add(privMap1);	
		Map<String, Object> privMap2 = new HashMap<String, Object>();
		//privMap2.put("BUSI_CODE", "a002"); //隔月回退
		privMap2.put("BUSI_CODE", "BBMA0002"); //隔月回退
		privsList.add(privMap2);	
		Map<String, Object> privMap3 = new HashMap<String, Object>();
		//privMap3.put("BUSI_CODE", "a003"); //隔笔回退
		privMap3.put("BUSI_CODE", "BBMA0003"); //隔笔回退
		privsList.add(privMap3);	
		inMap.put("LOGIN_NO", loginNo);
		inMap.put("BUSIPRIVS_LIST", privsList);
		List<LoginPdomEntity> checkList = loginCheck.pchkFuncPowerList(inDto.getHeader(), inMap);
		String checkLoginPri = "N";  //其他工号退费权限
		String checkDealPri = "N";   //隔笔权限
		String checkMonthPri = "N";  //隔月权限
		for(LoginPdomEntity checkEntity : checkList){		
			//其他工号退费权限
			if(checkEntity.getBusiCode().equals("BBMA0001")){
				checkLoginPri = checkEntity.getCheckFlag(); 
			}
			//隔月权限
			if(checkEntity.getBusiCode().equals("BBMA0002")){
				checkMonthPri = checkEntity.getCheckFlag();
			}
			//隔笔权限
			if(checkEntity.getBusiCode().equals("BBMA0003")){
				checkDealPri = checkEntity.getCheckFlag();
			}
			
		}
		
		/*权限验证,工号无BBMA0001（老系统a001）权限不能退其他工号的陈死账回收*/
		if(!payLoginNo.equals(loginNo) && checkLoginPri.equals("N")){
			throw new BusiException(AcctMgrError.getErrorCode("8007", "00001"),"该工号无权退其他工号的陈死账！");
		}
		
		/*权限验证,工号无BBMA0001（老系统a002）权限不能隔月回退*/
		if(!curYM.equals(payYearMonth) && checkMonthPri.equals("N")){
			throw new BusiException(AcctMgrError.getErrorCode("8007", "00003"),"该工号无权隔月退费！");
		}
		
		
		/*取除当前缴费流水外的交费信息*/
		inMapTmp = new HashMap<String , Object>();
		inMapTmp.put("NOT_PAY_SN", paySn);
		inMapTmp.put("ID_NO", idNo);
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("STATUS", "0");
		inMapTmp.put("OP_TIME", paymentInfo.getOpTime());
		inMapTmp.put("SUFFIX", Long.parseLong(payYearMonth));
		inMapTmp.put("OP_CODE", backOpCode);
		List<PayMentEntity> outPayMentList = record.getPayMentList(inMapTmp);
		
		int payDeal = outPayMentList.size();
		
		/*权限验证,工号无a003权限不能隔笔回退*/
		if(payDeal > 0 && checkDealPri.equals("N")){
			throw new BusiException(AcctMgrError.getErrorCode("8007", "00002"),"该工号无权隔笔退费！");
		}
		
		/*获取客户名称*/
		String custName = cust.getCustInfo(custId, null).getBlurCustName();
				
		// 根据缴费流水缴费总支出金额、缴费用户数等信息
		Map<String, Object> outFeemsg = payManage.getDeadPayOutMsg(paySn, Integer.parseInt(payYm), idNo);
		long allPay = Long.parseLong(outFeemsg.get("ALL_PAY").toString());
		String phoneNo = outFeemsg.get("PHONE_NO").toString();
		long payMoney = Long.parseLong(outFeemsg.get("PAY_MONEY").toString());
		long prepayFee = Long.parseLong(outFeemsg.get("PREPAY_FEE").toString());
		long payedOwe = Long.parseLong(outFeemsg.get("PAYED_OWE").toString());
		long delayFee = Long.parseLong(outFeemsg.get("DELAY_FEE").toString());
		
		S8007InitOutDTO s8007InitOutDTO = new S8007InitOutDTO();
		
		s8007InitOutDTO.setAllPay(allPay);
		s8007InitOutDTO.setCustName(custName);
		s8007InitOutDTO.setIdNo(idNo);
		s8007InitOutDTO.setIdNumber(1);
		s8007InitOutDTO.setOpTime(opTime);
		s8007InitOutDTO.setPaySn(paySn);
		s8007InitOutDTO.setContractNo(contractNo);
		s8007InitOutDTO.setPhoneNo(phoneNo);
		s8007InitOutDTO.setDelayFee(delayFee);
		s8007InitOutDTO.setPayedOwe(payedOwe);
		s8007InitOutDTO.setPayMoney(payMoney);
		s8007InitOutDTO.setPrepayFee(prepayFee);
		s8007InitOutDTO.setLoginNo(payLoginNo);
		
		log.info("8007init outParam:"+s8007InitOutDTO.toJson());
		
		return s8007InitOutDTO;
	}

	/* (non-Javadoc)
	 * @see com.sitech.acctmgr.inter.pay.I8007#cfm(com.sitech.jcfx.dt.in.InDTO)
	 */
	@SuppressWarnings({ "unchecked", "unused" })
	@Override
	public OutDTO cfm(InDTO inParam) {

		S8007CfmInDTO s8007CfmInDTO = (S8007CfmInDTO) inParam;
		
		log.info("8007Cfm begin :"+s8007CfmInDTO.getMbean());
		
		/*获取入参信息*/
		long paySn = s8007CfmInDTO.getPaySn();
		int payTotalDate = Integer.valueOf(s8007CfmInDTO.getPayTime().substring(0, 8));
		int payYearMonth = payTotalDate/100;
		String loginNo = s8007CfmInDTO.getLoginNo();
		String groupId = s8007CfmInDTO.getGroupId();
		String opNotes = s8007CfmInDTO.getPayNotes();
		long idNo = s8007CfmInDTO.getIdNo();
		String opCode = "1".equals(s8007CfmInDTO.getBackType())?"8007":"8032";
		
		/*查询缴费信息*/
		Map<String, Object> inParamMap = new HashMap<String, Object>();
		inParamMap.put("PAY_SN", paySn);
		inParamMap.put("STATUS", "0");
		inParamMap.put("SUFFIX", payYearMonth);
		inParamMap.put("ID_NO", idNo);
		
		List<PayMentEntity> outPaymentInfo = record.getPayMentList(inParamMap);
		if (outPaymentInfo==null || outPaymentInfo.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8007", "00004"),"您无缴费记录，或缴费已进行过退费！");
		}
		String phoneNo = (String) outPaymentInfo.get(0).getPhoneNo();
		String payType = outPaymentInfo.get(0).getPayType();
		long totalPayFee = 0;
		
		for(PayMentEntity payFeeEnt : outPaymentInfo){
			totalPayFee += payFeeEnt.getPayFee();
		}
		
		/*获取回退流水*/
		long payBackSn = control.getSequence("SEQ_PAY_SN");
		
		/*为防止缴费后立即冲销时间不一致，缴费类业务取时间都取数据库时间*/
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String curYm = curTime.substring(0, 6);
		String totalDate = curTime.substring(0, 8);
		
		/*获取用户信息*/
		List<UserDeadEntity> userDeadInfo = user.getUserdeadEntity(phoneNo, idNo, null);
		
		/*获取客户信息*/
		long custId = userDeadInfo.get(0).getCustId();
		
		/*备注信息为空时，默认备注信息*/
		if (StringUtils.isEmptyOrNull(opNotes)) {
			opNotes = loginNo+ "[" + opCode + "][退费]";
		}
		
		//回退支票
		Map<String,Object> checkMap = new HashMap<String,Object>();
		checkMap.put("SUFFIX", payYearMonth);
		checkMap.put("PAY_SN", paySn);
		checkMap.put("ID_NO", idNo);
		List<PayMentEntity> listPayMent=record.getPayMentList(checkMap);
		if(listPayMent.get(0).getPayMethod().equals("9")){
			
			//查询支票记录
            ChequeEntity chequeEnt = new ChequeEntity();
            Map<String,Object> checkOprMap= new HashMap<String,Object>();
            checkOprMap=cheque.getCheckOpr(paySn);
            String bankCode=checkOprMap.get("BANK_CODE").toString();
            String checkNo = checkOprMap.get("CHECK_NO").toString();
            String prePayStr=checkOprMap.get("CHECK_PAY").toString();
            long prePay = Long.parseLong(prePayStr);
            
            chequeEnt.setBankCode(bankCode);
            chequeEnt.setCheckNo(checkNo);
            
            //更新支票余额表
            PayBookEntity inBook = new PayBookEntity();
            inBook.setBankCode(bankCode);
            inBook.setGroupId(groupId);
            inBook.setLoginNo(loginNo);
            inBook.setOpCode(opCode);
            inBook.setOpNote("陈死账支票回退");
            inBook.setOriginalSn(paySn);
            inBook.setPayFee(-1*prePay);
            inBook.setPaySn(payBackSn);
            inBook.setStatus("0");
            inBook.setTotalDate(Integer.parseInt(totalDate));
            cheque.doAddCheck(chequeEnt, inBook);
		}
		
		/*回退缴费信息*/
		Map<String, Object> rollBackMap = new HashMap<String, Object>();
		rollBackMap.put("PHONE_NO", phoneNo);
		rollBackMap.put("CUST_ID", custId);
		rollBackMap.put("PAY_BACK_SN", payBackSn);
		rollBackMap.put("PAY_SN", paySn);
		rollBackMap.put("PAY_DATE", payTotalDate);
		rollBackMap.put("PAY_YM", payYearMonth);
		rollBackMap.put("CUR_YM", curYm);
		rollBackMap.put("CUR_DATE", totalDate);
		rollBackMap.put("CUR_TIME", curTime);
		rollBackMap.put("LOGIN_NO", loginNo);
		rollBackMap.put("LOGIN_GROUP", groupId);
		rollBackMap.put("OP_CODE", opCode);
		rollBackMap.put("OP_NOTE", opNotes);
		rollBackMap.put("ID_NO", idNo);
		log.info("doDeadRollback:"+rollBackMap.toString());
		Map<String, Object> lBackFee = payManage.doDeadRollback(rollBackMap);
		List<Map<String, Object>>  keysList = (List<Map<String, Object>>) lBackFee.get("KEYS_LIST");
		
		/*回退黑名单
		Map<String, Object> inBlackMap = new HashMap<String, Object>();
		inBlackMap.put("OP_ACCEPT", paySn);
		cct.saveBossBlackInfo(inBlackMap);*/
		
		/*发送回退黑名单工单*/
		CustInfoEntity custInfo = cust.getCustInfo(custId, null);
		String idType = custInfo.getIdType();
		String idICCID = custInfo.getIdIccid();
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("HEADER", s8007CfmInDTO.getHeader());
		inMap.put("OWNER_FLAG", "1");
		inMap.put("ORDER_ID", "10006");//取配置
		inMap.put("BUSI_CODE", "3707");
		inMap.put("LOGIN_NO", loginNo);
		inMap.put("OP_CODE", opCode);
		inMap.put("LOGIN_ACCEPT", payBackSn);
		inMap.put("CREATE_TIME", curTime);
		inMap.put("BUSIID_TYPE", "2");
		inMap.put("BUSIID_NO", idNo);
		inMap.put("ORDER_LEVEL", "5");
		inMap.put("DATA_TYPE", "1");
		inMap.put("REMARK", "局拆黑名单");
		inMap.put("ID_NO", idNo);
		inMap.put("CUST_ID", custId);
		inMap.put("BLACKTYPE", "11");
		inMap.put("OPTYPE", "A");
		inMap.put("OP_TYPE", "BTOC");
		inMap.put("ID_TYPE", idType);
		inMap.put("ID_ICCID", idICCID);
		log.info("黑名单入参:"+inMap);
		busiMsgsnd.opPubOdrSndInter(inMap);
		
		/* 向其他系统同步数据（目前：CRM营业日报、BOSS报表、统一接触）*/
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_SN", payBackSn);
		inMapTmp.put("LOGIN_NO", loginNo);
		inMapTmp.put("GROUP_ID", groupId);
		inMapTmp.put("OP_CODE", opCode);
		inMapTmp.put("BACK_FLAG", "1");
		inMapTmp.put("OLD_ACCEPT", paySn);
		inMapTmp.put("OP_TIME", curTime);
		inMapTmp.put("OP_NOTE", opNotes);
		inMapTmp.put("ACTION_ID", "1001");
		inMapTmp.put("KEYS_LIST", keysList);
		inMapTmp.put("CUST_ID_TYPE", "1"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
		inMapTmp.put("CUST_ID_VALUE", phoneNo);
		inMapTmp.put("TOTAL_FEE", String.valueOf(-1*totalPayFee));

		inMapTmp.put("Header", s8007CfmInDTO.getHeader());

		preOrder.sendData2(inMapTmp);

		S8007CfmOutDTO s8007CfmOutDTO = new S8007CfmOutDTO();
		s8007CfmOutDTO.setBackSn(payBackSn);

		log.debug("---->8007Cfm_out"+s8007CfmOutDTO.toJson());

		return s8007CfmOutDTO;
	}


	@SuppressWarnings("unchecked")
	@Override
	public OutDTO getPaySnInfo(InDTO inParam) {
		Map<String, Object> inMapTmp = null;

		log.info( "根据用户信息去查询缴费流水信息getPaySnInfo begin" + inParam.getMbean() );

		S8007GetPaySnInDTO inDto = (S8007GetPaySnInDTO)inParam;

		long inContractNo = inDto.getContractNo();
		long payMonth = inDto.getPayMonth();
		String sBackType = inDto.getBackType();
		String remark = "";

		String[] sBackOpCode = null;
		if ("1".equals(sBackType)) {
			sBackOpCode = new String[] {"8006"};
			remark = "陈帐";
		} else {
			sBackOpCode = new String[] {"8023"};
			remark = "死帐";
		}

		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", inContractNo);
		inMapTmp.put("SUFFIX", payMonth);
		inMapTmp.put("OP_TYPE", "");
		inMapTmp.put("OP_CODES", sBackOpCode);
		List<PaysnBaseEntity> resultList = remainFee.getPayMentForBack(inMapTmp);;

		if (resultList == null || resultList.isEmpty()) {
			throw new BusiException(AcctMgrError.getErrorCode("8007", "00006"),"该用户无["+remark+"]缴费记录！");
		}

		S8007GetPaySnOutDTO outDto = new S8007GetPaySnOutDTO();
		outDto.setPaysnInfo(resultList);

		log.info( "根据帐户信息去查询流水信息getPaySnInfo end!" + outDto.toJson() );

		return outDto;
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

	/**
	 * @return the loginCheck
	 */
	public LoginCheck getLoginCheck() {
		return loginCheck;
	}

	/**
	 * @param loginCheck the loginCheck to set
	 */
	public void setLoginCheck(LoginCheck loginCheck) {
		this.loginCheck = loginCheck;
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
	 * @return the payManage
	 */
	public IPayManage getPayManage() {
		return payManage;
	}

	/**
	 * @param payManage the payManage to set
	 */
	public void setPayManage(IPayManage payManage) {
		this.payManage = payManage;
	}

	public IRemainFee getRemainFee() {
		return remainFee;
	}

	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}

	public IPreOrder getPreOrder() {
		return preOrder;
	}

	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}

	public IBusiMsgSnd getBusiMsgsnd() {
		return busiMsgsnd;
	}

	public void setBusiMsgsnd(IBusiMsgSnd busiMsgsnd) {
		this.busiMsgsnd = busiMsgsnd;
	}

	public ICheque getCheque() {
		return cheque;
	}

	public void setCheque(ICheque cheque) {
		this.cheque = cheque;
	}
}
