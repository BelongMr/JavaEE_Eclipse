package com.sitech.acctmgr.atom.busi.pay.hlj;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.ITransType;
import com.sitech.acctmgr.atom.busi.pay.trans.TransFactory;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.bill.BillEntity;
import com.sitech.acctmgr.atom.domains.fee.OweFeeEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.GroupchgInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.util.DateUtil;

/**
 *
 * <p>Title: 全额付费自动转账类  </p>
 * <p>Description: 为自动转账AutoPay.java提供转账能力  </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author qiaolin
 * @version 1.0
 */
public class AutopayTrans extends BaseBusi {

	private TransFactory 	transFactory;
	private IAccount		account;
	private IUser			user;
	private IPayManage		payManage;
	private IControl		control;
	private ILogin			login;
	private IGroup			group;
	private IBill			bill;
	private IRecord			record;
	
	public long trans(long conPay, long conNo, long payFee, String opNote, String autoFlag){
		
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String curYm = curTime.substring(0, 6);
		int totalDate = Integer.parseInt(curTime.substring(0, 8));
		
		String loginNo = "system";
		LoginEntity  loginEntity = login.getLoginInfo(loginNo, CommonConst.DEFAULT_PROVINCE_ID);
		
		PayUserBaseEntity inTransBaseInfo = getCfmBaseInfo(conNo, CommonConst.DEFAULT_PROVINCE_ID);
		PayUserBaseEntity outTransBaseInfo = getCfmBaseInfo(conPay, CommonConst.DEFAULT_PROVINCE_ID);
		
		/*入账实体设值*/
		PayBookEntity bookIn = new PayBookEntity();
		bookIn.setBeginTime(curTime);
		bookIn.setGroupId(loginEntity.getGroupId());
		bookIn.setLoginNo(loginNo);
		bookIn.setOpCode("8014");
		bookIn.setOpNote(opNote);
		bookIn.setPayFee(payFee);
		bookIn.setPayMethod("A");
		bookIn.setPayPath("98");
		bookIn.setTotalDate(totalDate);
		bookIn.setFactorOne(autoFlag);//1是全额付费 0是定额付费
		bookIn.setYearMonth(Long.parseLong(curYm));
		
		MBean mbeanTmp = new MBean();
		Map<String, Object> header = mbeanTmp.getHeader();

		Map<String, Object> inTransCfmMap = new HashMap<String, Object>();
		ITransType transType = transFactory.createTransFactory("TransAccountRel",true);
		safeAddToMap(inTransCfmMap, "Header", header);
		safeAddToMap(inTransCfmMap, "TRANS_TYPE_OBJ", transType); //转账类型实例化对象
		safeAddToMap(inTransCfmMap, "TRANS_IN", inTransBaseInfo);  //转入账户基本信息
		safeAddToMap(inTransCfmMap, "TRANS_OUT", outTransBaseInfo); //转出账户基本信息
		safeAddToMap(inTransCfmMap, "BOOK_IN", bookIn); //入账实体
		safeAddToMap(inTransCfmMap, "OP_TYPE", "TFAccount"); //转账类型
		safeAddToMap(inTransCfmMap, "TRANS_TYPE_OBJ", transType);
		/*转账*/
		long paySn = payManage.transBalance(inTransCfmMap);
		
		//转入账户做冲销、开机动作
		
		
	    LoginOprEntity outTransOpr = new LoginOprEntity();
	    outTransOpr.setBrandId(outTransBaseInfo.getBrandId());
	    outTransOpr.setIdNo(outTransBaseInfo.getIdNo());
	    outTransOpr.setLoginGroup(loginEntity.getGroupId());
	    outTransOpr.setLoginNo(loginNo);
	    outTransOpr.setLoginSn(paySn);
	    outTransOpr.setOpCode("8020");
	    outTransOpr.setOpTime(curTime);
	    outTransOpr.setPayFee(-1L * payFee);
	    outTransOpr.setPhoneNo(outTransBaseInfo.getPhoneNo());
	    outTransOpr.setRemark(opNote);
	    outTransOpr.setPayType("0");
	    outTransOpr.setTotalDate(totalDate);
	    record.saveLoginOpr(outTransOpr);
		
		return 0;
	}
	
	
	private PayUserBaseEntity getCfmBaseInfo(long contractNo, String provinceId){
		
		String phoneNo = account.getPayPhoneByCon(contractNo);
		if (phoneNo.equals("")) {
			phoneNo = "99999999999";
		}
		
		UserInfoEntity userInfo = null;
		String brandId = "XX";
		long   idNo = 0;
		if(!phoneNo.equals("99999999999")){
			
			userInfo = user.getUserInfo(phoneNo);
			idNo = userInfo.getIdNo();
			brandId = userInfo.getBrandId();
		}
		
		//取账户归属
		GroupchgInfoEntity groupChgEntity = group.getChgGroup(null, null, contractNo);
		
		// 缴费用户归属地市
		ChngroupRelEntity groupEntity = group.getRegionDistinct(groupChgEntity.getGroupId(), "2", provinceId);
		String regionId = groupEntity.getRegionCode();
		
		PayUserBaseEntity payUserBase = new PayUserBaseEntity();
		payUserBase.setIdNo(idNo);
		payUserBase.setPhoneNo(phoneNo);
		payUserBase.setContractNo(contractNo);
		payUserBase.setUserGroupId(groupChgEntity.getGroupId());
		payUserBase.setRegionId(regionId);
		payUserBase.setBrandId(brandId);
		payUserBase.setNetFlag(true);
		
		return payUserBase;
	}

	/**
	* 名称：判断支付账户可转预存款能否进行转账（支付账户可转0账本预存款 大于 被所有被支付账户总欠费）
	*/
	public boolean checkPrepay (long contractNo){
		
		return true;
	}
	
	/**
	* 名称：判断定额转账支付账户可转预存款能否进行转账（支付账户可转0账本预存款 大于 被所有被支付账户总欠费）
	*/
	public boolean checkDePrepay (long contractNo){
		
		ITransType transType = transFactory.createTransFactory("TransAccountRel",true);
		long transFee = transType.getTranFee(contractNo);
		
		Map<String, Object> inMapTmp = null;
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("ACCT_REL_TYPE", "9");			//全额
		Map<String, Object> result = (Map<String, Object>)baseDao.queryForList("cs_account_rel.qDeSumPayValue", inMapTmp);
		long sumPayValue = Long.parseLong(result.get("SUM_PAY_VALUE").toString());
		
		if(transFee < sumPayValue){
			log.equals("支付账户可转金额小于要转账总额:" + contractNo);
			return false;
		}else{
			return true;
		}
	}
	
	/**
	* 名称：校验 支付账户类型为一点支付账户 一点支付账户在该功能不做转账
	* 账户销户返回false 否则返回true 
	*/
	public boolean check(long contPay, long conNo){
		
		ContractInfoEntity conPayEntity = account.getConInfo(contPay,false);
		if(conPayEntity == null){
			
			log.error("支付账户已经销户:" + contPay);
			return false;
		}
		
		if(conPayEntity.getContractattType().equals("A")){
			
			log.error("支付账户为一点支付账户:" + contPay);
			return false;
		}
		
		ContractInfoEntity conEntity = account.getConInfo(conNo,false);
		if(conEntity == null){
			
			log.error("转入账户不存在:" + conNo);
			return false;
		}
		
		return true;
	}
	
	/**
	* 名称：获取全额转账金额
	*/
	public long getTransFee(long conNo){
		
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String curYm = curTime.substring(0, 6);
		String transBillCycle = DateUtil.toStringPlusMonths(curYm, -1,"yyyyMM"); 
		
		OweFeeEntity oweFee = bill.getBillInfo(conNo, Integer.valueOf(transBillCycle));
		log.debug("账户上个月：" + transBillCycle + "账单消费情况：" + oweFee);
		
		return oweFee.getShouldPay()-oweFee.getFavourFee();
	}


	public TransFactory getTransFactory() {
		return transFactory;
	}


	public void setTransFactory(TransFactory transFactory) {
		this.transFactory = transFactory;
	}


	public IAccount getAccount() {
		return account;
	}


	public void setAccount(IAccount account) {
		this.account = account;
	}


	public IUser getUser() {
		return user;
	}


	public void setUser(IUser user) {
		this.user = user;
	}


	public IPayManage getPayManage() {
		return payManage;
	}


	public void setPayManage(IPayManage payManage) {
		this.payManage = payManage;
	}


	public IControl getControl() {
		return control;
	}


	public void setControl(IControl control) {
		this.control = control;
	}


	public ILogin getLogin() {
		return login;
	}


	public void setLogin(ILogin login) {
		this.login = login;
	}


	public IGroup getGroup() {
		return group;
	}


	public void setGroup(IGroup group) {
		this.group = group;
	}


	public IBill getBill() {
		return bill;
	}


	public void setBill(IBill bill) {
		this.bill = bill;
	}


	public IRecord getRecord() {
		return record;
	}


	public void setRecord(IRecord record) {
		this.record = record;
	}
	

}