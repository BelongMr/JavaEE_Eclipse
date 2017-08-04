package com.sitech.acctmgr.atom.busi.pay.trans;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.ITransType;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.pay.TransFeeEntity;
import com.sitech.acctmgr.atom.domains.pay.TransOutEntity;
import com.sitech.acctmgr.atom.domains.user.*;
import com.sitech.acctmgr.atom.dto.pay.S8014InitInDTO;
import com.sitech.acctmgr.atom.entity.inter.IAgent;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.atom.impl.pay.S8008;
import com.sitech.acctmgr.atom.impl.pay.S8014;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.util.DateUtil;



/**
*
* <p>Title:  集团转账类型可转金额基类 </p>
* <p>Description: 集团转账余额查询、特殊业务信息查询及处理 </p>
* <p>Copyright: Copyright (c) 2016</p>
* <p>Company: SI-TECH </p>
* @author suzj
* @version 1.0
*/
public class TransAccountGrp extends BaseBusi implements ITransType{
	
	protected IRemainFee remainFee;
	protected IBalance balance;
	protected IAgent agent;
	protected IUser user;
	protected IRecord record;
	
	public String getTransTypes(){
		
		return null;
	}

	/* 获取可转金额 */
	@Override
	public long getTranFee(long inContractNo) {
		
		long transFeeTmp = 0;
		long remainMoney = 0;
		long transFee = 0;
		long contractNo = inContractNo;
		
		log.info("TransJTCPZZ getTranFee inParam contractNo["+inContractNo+"]");
		
		//集团转账，转账本为('0')的预存
		transFeeTmp = balance.getSumBalacneByPayTypes(contractNo,"0");
		
		/* 获取账户余额*/
		OutFeeData feeDate = remainFee.getConRemainFee(contractNo);
		if (feeDate != null) {
			remainMoney = feeDate.getRemainFee();
		}
		
		/*可转余额判断*/
		transFee = remainMoney < transFeeTmp ? remainMoney : transFeeTmp ;
		if (transFee < 0) {
			transFee = 0;
		}
		
		return transFee;
	}
	
	/* 获取按账本合并后的转账列表 */
	@Override
	public List<TransFeeEntity> getComTranFeeList(long inContractNo){
		List<TransFeeEntity> outList = new ArrayList<TransFeeEntity>();
		Map<String, Object> inMap = new HashMap<String, Object>();
		
		//集团转账，转账本为('0')的预存
		inMap.put("CONTRACT_NO", inContractNo);
		inMap.put("PAY_TYPE_STR", "0");
		
		outList = remainFee.getBookList(inMap);
		
		return outList;
	}
	
	/* 个性化业务查询 */
	@Override
	public Map<String, Object> getSpecialBusiness(Map<String, Object> inMap){
		TransOutEntity baseInfo = (TransOutEntity)inMap.get("BASE_INFO");
		
		long outContractNo = baseInfo.getContractNo();
		String phoneNo = baseInfo.getPhoneNo();
		UserInfoEntity userInfo = user.getUserInfo(phoneNo);
		long idNo = userInfo.getIdNo();
		String accountType = baseInfo.getAccountType();
		String runCode = this.getUserdetail(idNo);

		/* 不是集团账户不允许转账 */
		if (!(accountType.equals("1"))) {
			throw new BaseException(AcctMgrError.getErrorCode("8014", "00021"), "不是集团帐户，不允许转帐!");
		}
		
		/*校验用户状态*/
		if(!(runCode.equals("A"))){
			throw new BaseException(AcctMgrError.getErrorCode("8014", "00022"), "账户不在正常状态，不允许转帐!");
		}
		
		return null;
	}
	
	/*查询用户状态*/
	public String getUserdetail(long idNo){
		Map<String,Object> inParam = new HashMap<String,Object>();
		inParam.put("ID_NO",idNo);
		UserDetailEntity userDetail = (UserDetailEntity)baseDao.queryForObject("cs_userdetail_info.qUserdetailInfo",inParam );
		String gidNo = userDetail.getRunCode();
		return gidNo;
	}
		
	/*转账备注信息*/
	@Override
	public String getOpNote(String opNote) {
		opNote = opNote + "[集团]";
		return opNote;	
	}
	
	/*确认服务个性化验证*/
	@Override
	public void checkCfm(Map<String, Object> checkMap){
		long outContractNo = (long)checkMap.get("CONTRACTNO_OUT");
		System.out.println(outContractNo);
		long transFee = (long)checkMap.get("TRANS_FEE");
		String grpMark = "0";
		
		/*校验集团转账限额*/
		if((grpMark.equals("0"))){
			long grpTransFee = record.getMonthTransFee(outContractNo);
			long monthTransFee = transFee  + grpTransFee;
			
			if(monthTransFee > 9999999){
				throw new BaseException(AcctMgrError.getErrorCode("8014", "00023"),"月转账超出转账限额，不允许转账！");
			}
		}
		
	}
	
	/* 个性化业务处理 */
	@Override
	public void doSpecialBusi(Map<String, Object> inMap){
			
	}
	
//	/*查询月转账累计金额*/
//	public long getMonthTranFee(long contractNo){
//		return contractNo;
//	}
	
	/* 发送短信 */
	@Override
	public void transFeeSendMsg(Map<String, Object> inMap){
		log.info("------>transFeeSendMsg inParm:" + inMap.entrySet());

		String opType = inMap.get("OP_TYPE").toString();

		log.info("-----> 发送短信 [op_type]=" + opType);

		//账户转账发送短信，转出账户只给集团账户发送 
		long transFee = Long.parseLong(inMap.get("TRANS_FEE").toString());

		String transFeeStr = String.format("%.2f", (double) transFee / 100);
		String grpName = "si-tech";
		String mPhoneNo = "15333084306";
		String acName = "中秋福利";
		
		
			
		// 给转出号码发送短信:
		// 预存款转移成功，转入手机号为$IN_PHONE_NO
		// 转出帐号为$OUT_CONTRACT_NO，转出手机号为$OUT_PHONE_NO，转移金额为$MONEY元！转账次数为$TRANS_COUNT,单次转账金额为$ONE_TRANS_FEE
		Map<String, Object> data = new HashMap<String, Object>();
		data.put("IN_PHONE_NO", inMap.get("IN_PHONE_NO"));
		data.put("OUT_CONTRACT_NO", inMap.get("OUT_CONTRACT_NO"));
		data.put("OUT_PHONE_NO", inMap.get("OUT_PHONE_NO"));
		data.put("TRANS_COUNT", inMap.get("TRANS_COUNT"));
		data.put("ONE_TRANS_FEE", inMap.get("ONE_TRANS_FEE"));
		data.put("TRANS_MONEY", transFeeStr);

		MBean inMessage = new MBean();
		inMessage.addBody("TEMPLATE_ID", "31320049");
		inMessage.addBody("OP_CODE", inMap.get("OP_CODE"));
		inMessage.addBody("CHECK_FLAG", true);
		inMessage.addBody("DATA", data);// 这里的Data是个Map类型
		inMessage.addBody("SEND_FLAG", 0);
		inMessage.addBody("PHONE_NO", inMap.get("OUT_PHONE_NO"));
		// shortMessage.sendSmsMsg(inMessage);
				
		// 给转入号码发送短信
		// 预存款转移成功，转出手机号为$OUT_PHONE_NO
		// 转入手机号为$IN_PHONE_NO，转移金额为$MONEY元，转入帐号为$IN_CONTRACT_NO，转账次数为$TRANS_COUNT,单次转账金额为$ONE_TRANS_FEE
		Map<String, Object> dataIn = new HashMap<String, Object>();
		dataIn.put("OUT_PHONE_NO", inMap.get("OUT_PHONE_NO"));
		dataIn.put("IN_PHONE_NO", inMap.get("IN_PHONE_NO"));
		dataIn.put("TRANS_MONEY", transFeeStr);
		dataIn.put("IN_CONTRACT_NO", inMap.get("IN_CONTRACT_NO"));
		dataIn.put("TRANS_COUNT", inMap.get("TRANS_COUNT"));
		dataIn.put("ONE_TRANS_FEE", inMap.get("ONE_TRANS_FEE"));
		dataIn.put("GRP_NAME", grpName);
		dataIn.put("MPHONE_NO", mPhoneNo);
		dataIn.put("AC_NAME", acName);

		MBean inMessageIn = new MBean();
		inMessageIn.addBody("TEMPLATE_ID", "31320056");
		inMessageIn.addBody("OP_CODE", inMap.get("OP_CODE"));
		inMessageIn.addBody("CHECK_FLAG", true);
		inMessageIn.addBody("DATA", dataIn);// 这里的DataIn是个Map类型
		inMessageIn.addBody("SEND_FLAG", 0);
		inMessageIn.addBody("PHONE_NO", inMap.get("IN_PHONE_NO"));
		// shortMessage.sendSmsMsg(inMessageIn);
	}

	/* 获取转账列表 */
	@Override
	public List<Map<String, Object>> getTranFeeList(long inContractNo){
		List<Map<String, Object>> outList = new ArrayList<Map<String, Object>>();
		Map<String, Object> inMap = new HashMap<String, Object>();
		
		inMap.put("CONTRACT_NO", inContractNo);		
		inMap.put("TRANS_FLAG", "0");  //账本可转属性  0：表示可转  1：表示不可转
		inMap.put("PAY_TYPE", "0");  //可转账本为0账本
		
		outList = balance.getAcctBookList(inMap);

		return outList;
	}
	
	/**
	 * @return the remainFee
	 */
	public IRemainFee getRemainFee() {
		return remainFee;
	}
	
	/**
	 * @param remainFee the remainFee to set
	 */
	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
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
	 * @return the agent
	 */
	public IAgent getAgent() {
		return agent;
	}

	/**
	 * @param agent the agent to set
	 */
	public void setAgent(IAgent agent) {
		this.agent = agent;
	}

	@Override
	public void checkRegionLimit(String regionGroup,String limitType,long transFee) {
		// TODO Auto-generated method stub
		
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}
	
}
