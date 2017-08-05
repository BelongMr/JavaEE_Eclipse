package com.sitech.acctmgr.atom.busi.pay.hlj;

import com.sitech.acctmgr.atom.busi.pay.inter.IPaybakLimit;
import com.sitech.acctmgr.atom.domains.pay.PayMentEntity;
import com.sitech.acctmgr.atom.domains.user.UserDetailEntity;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.comp.busi.LoginCheck;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.util.DateUtil;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.apache.commons.collections.MapUtils.getString;
import static org.apache.commons.collections.MapUtils.safeAddToMap;

/**
 *
 * <p>Title:  缴费冲正业务限制和个性化权限校验吉林实现  </p>
 * <p>Description: 缴费冲正业务限制和个性化校验吉林业务实现  </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author 
 * @version 1.0
 */
public class PaybackLimitHLJ extends BaseBusi implements IPaybakLimit {
	
	private ILogin 		login;
	private IGroup 		group;
	private IControl	control;
	private IRecord		record;
	private LoginCheck logincheck;
	private IUser		user;
	private IAccount	account;

	/**
	* 名称：吉林缴费冲正业务规则和权限限制
	* @param Header			: Map
	* @param LOGIN_NO		：冲正工号
	* @param TOTAL_DATE		: 当前日期
	* @param PAYMENT_ENTITY	: 缴费记录实体，PayMentEntity
	* @param A035                                 ：小权限代码，键表示小权限编码，值     0 ：无权限    1：有权限         (隔日冲正权限)
	* 
	* @throws BusiException
	* @author qiaolin
	*/
	public Map<String, Object> check(Map<String, Object> inParam) {
		
		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;
		
		log.debug("------> check ="+inParam.entrySet());
		
		PayMentEntity paymentEntity = (PayMentEntity)inParam.get("PAYMENT_ENTITY");
		
		//缴费类业务OP_CODE '8017', '8000', '8002', '8030', '8016'
		/**
		 * 缴费冲正限制  （不允许跨月、跨日、隔笔冲正 ）
		 */
		String payOpCodes = "('8000', '8002', '8030', '8074')";
		if(payOpCodes.indexOf(paymentEntity.getOpCode()) != -1){
			
			inMapTmp = new HashMap<String, Object>();
			
			inMapTmp.put("Header", inParam.get("Header"));
			inMapTmp.put("PAY_SN", paymentEntity.getPaySn());
			inMapTmp.put("LOGIN_NO", inParam.get("LOGIN_NO"));
			inMapTmp.put("PAYMENT_ENTITY", paymentEntity);
			check8056(inMapTmp);
		}
		
		return null;
		
	}

	
	
	/**
	 * 名称：交费冲正校验
	 * @param	Header			: Map
	 * @param	LOGIN_NO
	 * @param   PAYMENT_ENTITY	: 缴费记录实体，PayMentEntity
	 * @author qiaolin
	 */
	public void check8056(Map<String, Object> inParam) {
		
		log.debug("------> check8056 = " + inParam.toString());
		
		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;
		
		PayMentEntity paymentEntity = (PayMentEntity)inParam.get("PAYMENT_ENTITY");
		
		/*取当前年月和当前时间*/
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String sCurYm = sCurTime.substring(0, 6);
		String totalDate = sCurTime.substring(0, 8);
		
		if(account.isGrpCon(paymentEntity.getContractNo())){
			
			UserDetailEntity userDetail = null;
			if(paymentEntity.getIdNo() != 99999999999L){
				userDetail = user.getUserdetailEntity(paymentEntity.getIdNo());
			}
			if(userDetail != null){
				if(userDetail.getRunCode().equals("F") || userDetail.getRunCode().equals("I")){
					
					log.error("用户状态为预销、到期单通不允许冲正");
					throw new BusiException(AcctMgrError.getErrorCode("0000","10045"), "用户状态为预销、到期单通不允许冲正" );
				}
			}
		}
		
		// 209开头的号码  如果PAY_PATH为网厅 02  则不允许冲正
		if(paymentEntity.getPayPath().equals(PayBusiConst.WWWPATH)&& 
				"209".equals(paymentEntity.getPhoneNo().substring(0,3))){
			
			log.error("网站交费不允许冲正！");
			throw new BusiException(AcctMgrError.getErrorCode("0000",
					"10046"), "网站交费不允许冲正！" );
		}
		
		/***
		 *  1、 缴费卡缴费不允许冲正
		 *	1，  冲正工号和缴费工号不是一个，校验冲正工号权限，无权限不可以冲正，权限代码：BBMA0031
		 *	2，  隔月冲正，校验冲正工号权限，无权限不可以冲正，权限代码：BBMA0032
		 *	3，  隔日冲正，校验冲正工号权限，无权限不可以冲正，权限代码：BBMA0034
		 *	4，  隔笔冲正，校验冲正工号权限，无权限不可以冲正，权限代码：BBMA0033
		 */
		String payDate = String.valueOf(paymentEntity.getTotalDate());
		Map<String, Object> header = (Map<String, Object>) inParam.get("Header");
		String loginNo = getString(inParam, "LOGIN_NO");
		// 1、 缴费卡缴费不允许冲正,且工号是营业前台
		if(paymentEntity.getPayPath().equals(PayBusiConst.CARDPATH)){
			
			log.error("缴费卡缴费不允许冲正");
			throw new BusiException(AcctMgrError.getErrorCode("0000",
					"10044"), "缴费卡缴费不允许冲正" );
		}
		
		if (!loginNo.equals(paymentEntity.getLoginNo())) {

			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("LOGIN_NO", loginNo);
			inMapTmp.put("BUSI_CODE", "BBMA0031");
			boolean powerFlag = logincheck.pchkFuncPower(header, inMapTmp);
			if (!powerFlag) {

				log.error("该工号不允许冲正其它工号缴费");
				throw new BusiException(AcctMgrError.getErrorCode("0000",
						"10043"), "该工号不允许冲正其它工号缴费, 小权限--> BBMA0031" );
			}
		}
		
		if (!payDate.substring(0, 6).equals(totalDate.substring(0, 6))) {

			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("LOGIN_NO", loginNo);
			inMapTmp.put("BUSI_CODE", "BBMA0032");
			boolean powerFlag = logincheck.pchkFuncPower(header, inMapTmp);
			if (!powerFlag) {

				log.error("该工号不允许隔月冲正，payDate： " + payDate + ",totalDate:"
						+ totalDate);
				throw new BusiException(AcctMgrError.getErrorCode("0000",
						"10040"), "该工号不允许隔月冲正，payDate：  " + payDate + ",totalDate:"
						+ totalDate + "隔月冲正小权限--> BBMA0032");
			}
		}
		
		if(!payDate.equals(totalDate) && payDate.substring(0, 6).equals(totalDate.substring(0, 6))){
			
			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("LOGIN_NO", loginNo);
			inMapTmp.put("BUSI_CODE", "BBMA0034");
			boolean powerFlag = logincheck.pchkFuncPower(header, inMapTmp);
			if (!powerFlag) {
				log.error("该工号不允许隔日冲正，payDate： " + payDate + ",totalDate:"
						+ totalDate);
				throw new BusiException(AcctMgrError.getErrorCode("0000",
						"10041"), "该工号不允许隔日冲正，payDate： " + payDate
						+ ",totalDate:" + totalDate + "隔日冲正小权限--> BBMA0034");
			}
		}
		
		/*取除当前缴费流水外的交费信息*/
		inMapTmp = new HashMap<String , Object>();
		inMapTmp.put("NOT_PAY_SN", inParam.get("PAY_SN"));
		inMapTmp.put("CONTRACT_NO", paymentEntity.getContractNo());
		inMapTmp.put("NOT_FOREIGN_SN", paymentEntity.getForeignSn());
		inMapTmp.put("STATUS", "0");
		inMapTmp.put("OP_TIME", paymentEntity.getOpTime());
		inMapTmp.put("SUFFIX", Long.parseLong(payDate.substring(0, 6)));
		List<PayMentEntity> outPayList = record.getPayMentList(inMapTmp);
		if (outPayList.size() > 0 ) {
			
			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("LOGIN_NO", loginNo);
			inMapTmp.put("BUSI_CODE", "BBMA0033");
			boolean powerFlag = logincheck.pchkFuncPower(header, inMapTmp);
			if(!powerFlag){
				
				throw new BusiException(AcctMgrError.getErrorCode("0000","10042"), "该工号不允许隔笔冲正 , 隔笔冲正小权限--> BBMA0033" );
				
			}
		}

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



	public IControl getControl() {
		return control;
	}



	public void setControl(IControl control) {
		this.control = control;
	}



	public IRecord getRecord() {
		return record;
	}



	public void setRecord(IRecord record) {
		this.record = record;
	}



	public LoginCheck getLogincheck() {
		return logincheck;
	}



	public void setLogincheck(LoginCheck logincheck) {
		this.logincheck = logincheck;
	}



	public IUser getUser() {
		return user;
	}



	public void setUser(IUser user) {
		this.user = user;
	}



	public IAccount getAccount() {
		return account;
	}



	public void setAccount(IAccount account) {
		this.account = account;
	}

}