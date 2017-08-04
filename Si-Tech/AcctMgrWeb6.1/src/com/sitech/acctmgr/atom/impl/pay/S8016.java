package com.sitech.acctmgr.atom.impl.pay;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.HashMap;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayOpener;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.busi.pay.inter.ITransType;
import com.sitech.acctmgr.atom.busi.pay.inter.IWriteOffer;
import com.sitech.acctmgr.atom.busi.pay.trans.TransFactory;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.GroupchgInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.pay.S8016CfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8016CfmOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAgent;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IProd;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.inter.pay.I8016;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
 *
 * <p>Title: 空中充值业务基类  </p>
 * <p>Description: 定义空中充值业务流程模板  </p>
 * <p>Copyright: Copyright (c) 2016</p>
 * <p>Company: SI-TECH </p>
 * @author qiaolin
 * @version 1.0
 */

public class S8016 extends AcctMgrBaseService implements I8016 {
	
	private TransFactory transFactory;
	private	ILogin		login;
	private IControl	control;
	private IRemainFee	remainFee;
	private IUser		user;
	private IGroup		group;
	private IWriteOffer	writeOffer;
	private IRecord		record;
	private IAgent		agent;
	private IProd		prod;
	private IPayManage	payManage;
	private IPayOpener	payOpener;
	private IPreOrder	preOrder;
	
	
	/**
	* 名称：空中充值确认	</br>
	* 流程：	</br>
	* 1.Dto参数校验	</br>
	* 2.校验代理商密码
	* 3.取代理商用户基本信息	</br>
	* 4.业务限制校验
	* 5.取缴费用户基本信息	</br>
	* 6.取代理可转金额,判断是否足额完成本次缴费	</br>
	* 7.缴费到账（代理商转出、缴费用户转入）	</br>
	* 8.缴费用户开机	</br>
	* 9.缴费用户冲销欠费	</br>
	* 10.发送短信	</br>
	* 11.记录营业员操作日志	</br>
	* 
	* @param LOGIN_NO         : 操作工号
	* @param GROUP_ID		  : 工号归属
	* @param OP_CODE          : 操作代码
	* @param AGENT_PHONE      : 代理商手机号码
	* @param AGENT_PASSWORD   : 代理商账号密码
	* @param PHONE_NO		  : 充值号码
	* @param PAY_MONEY        : 缴费金额，单位：分
	* @param PAY_TYPE
	* @param PAY_PATH
	* @param PAY_METHOD
	* @param PAY_NOTE			: 可空
	* @param FOREIGN_SN			： 终端充值缴费流水
	* @param FOREIGN_TIME		： 可空,外部缴费时间，可空，格式为YYYYMMDDHHMISS
	* @author qiaolin
	*/
	public OutDTO cfm(InDTO inParam) {
		
		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;
		
		//1.调用S8016CfmtInDto (string->MBean + 校验)
		S8016CfmInDTO	inDto = (S8016CfmInDTO)inParam; 
		
		log.info("空中充值确认cfm begin" + inDto.getMbean());
		
		String  errType = null;       //标识错误类型，后续专项为代理商下发错误短信
		/* 创建转账类型 */
		ITransType transType =  transFactory.createTransFactory("KcAgentTrans", true);
		String phoneNo = inDto.getPhoneNo();
		
		if( StringUtils.isEmptyOrNull(inDto.getGroupId()) ){
			LoginEntity loginEnt = login.getLoginInfo(inDto.getLoginNo(), inDto.getProvinceId());
			inDto.setGroupId(loginEnt.getGroupId());
		}
		
		//取当前年月和当前时间
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String curYm = curTime.substring(0, 6);
		String totalDate = curTime.substring(0, 8);
		
		Map<String, Object> errMsgMap = new HashMap<String, Object>();
		errMsgMap.put("AGENT_PHONE", inDto.getAgentPhone());
		errMsgMap.put("LOGIN_NO", inDto.getLoginNo());
		errMsgMap.put("GROUP_ID", inDto.getGroupId());
		errMsgMap.put("OP_CODE", inDto.getOpCode());
		
		//2.校验代理商密码
		if(!checkPassword(inDto.getAgentPhone(), inDto.getAgentPassword())){
			
			errType = "2";
			sendPayErrMsg(errType, errMsgMap);
			throw new BusiException(AcctMgrError.getErrorCode(inDto.getOpCode(), "00004"),
					"代理商密码不正确 + inPassword: " + inDto.getAgentPassword());
		}
		

		long agentCon = agent.getAgentCon(inDto.getAgentPhone());
		PayUserBaseEntity agentUserBase = getCfmBaseInfo(inDto.getAgentPhone(), agentCon, inDto.getProvinceId());
		
		//1、是否空充代理商
		if(!agent.isKcAgentPhone(inDto.getAgentPhone(), String.valueOf(agentCon))){
			
			errType = "1";
			sendPayErrMsg(errType, errMsgMap);
			throw new BusiException(AcctMgrError.getErrorCode(inDto.getOpCode(), "00008"),
					"该用户不是空中充值代理商,或已关闭" + inDto.getAgentPhone());
		}
		
		/*
		 * 5.取充值用户基本信息
		 */
		PayUserBaseEntity  payUserBase = getCfmBaseInfo(phoneNo, null, inDto.getProvinceId());
		
		/*
		 * 4.个性化限制
		 * 吉林：(号码是否联动优势代理商号码、判断充值是否超过限额 等等)
		 * 
		*/
		//kcCheck.checkAgent(defAgentId, defAgentCon, inDto.getAgentPassword());
		
		if(inDto.getAgentPhone().equals(inDto.getPhoneNo())){
			
			throw new BusiException(AcctMgrError.getErrorCode(inDto.getOpCode(), "00003"),
					"不允许为自己转帐");
		}
		
		//判断是否可以跨区转账
		if (!agentUserBase.getRegionId().equals(payUserBase.getRegionId())) {

			throw new BaseException(AcctMgrError.getErrorCode(inDto.getOpCode(), "00005"), "不允许异地转帐,AGENT_PHONE: " + inDto.getAgentPhone());
		}

		/*
		 * 6.取代理可转金额,判断是否足额完成本次缴费
		 * */
		long changeFee = transType.getTranFee(agentCon);
		if (changeFee < inDto.getPayMoney()) {

			log.info("代理商可转金额小于充值金额，可转金额：" + changeFee);
			throw new BusiException(AcctMgrError.getErrorCode("8016", "00001"), "代理商可转金额小于充值金额");
		}
		
		/*
		 * 7.缴费到账（代理商转出、缴费用户转入)
		 **/
		/*入账实体设值*/
		PayBookEntity bookIn = new PayBookEntity();
		bookIn.setBeginTime(curTime);
		bookIn.setGroupId(inDto.getGroupId());
		bookIn.setLoginNo(inDto.getLoginNo());
		bookIn.setOpCode(inDto.getOpCode());
		bookIn.setOpNote(transType.getOpNote(inDto.getPayNote()));
		bookIn.setPayFee(inDto.getPayMoney());
		bookIn.setPayMethod(inDto.getPayMethod());
		bookIn.setPayPath(inDto.getPayPath());
		bookIn.setTotalDate(Integer.parseInt(totalDate));
		bookIn.setYearMonth(Long.parseLong(curYm));
		bookIn.setForeignSn(inDto.getForeignSn());
		bookIn.setForeignTime(inDto.getForeignTime());

		Map<String, Object> inTransCfmMap = new HashMap<String, Object>();
		safeAddToMap(inTransCfmMap, "Header", inDto.getHeader());
		safeAddToMap(inTransCfmMap, "TRANS_TYPE_OBJ", transType); //转账类型实例化对象
		safeAddToMap(inTransCfmMap, "TRANS_IN", payUserBase);  //转入账户基本信息
		safeAddToMap(inTransCfmMap, "TRANS_OUT", agentUserBase); //转出账户基本信息
		safeAddToMap(inTransCfmMap, "BOOK_IN", bookIn); //入账实体
		safeAddToMap(inTransCfmMap, "OP_TYPE", "KcAgentTrans"); //转账类型
		long paySn = 0;
		try {
			paySn = payManage.transBalance(inTransCfmMap, "Y");	//空中充值转入账本为Y
		} catch (BusiException e) {

			if (e.getErrCode().equals("10111109801400018")) {

				log.info("kcTransBalance代理商可转金额小于充值金额，可转金额：" + changeFee);
				throw new BusiException(AcctMgrError.getErrorCode("8016", "00001"), "代理商可用户空中充值金额小于充值金额");
			} else {

				log.info("kcTransBalance 空中充值账户转账发生系统错误：" + changeFee);
				throw new BusiException(AcctMgrError.getErrorCode("8016", "00008"), "kcTransBalance 空中充值账户转账发生系统错误");
			}

		}
		
		//6.冲销
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("Header", inDto.getHeader());
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("CONTRACT_NO", payUserBase.getContractNo());
		inMapTmp.put("PHONE_NO", phoneNo);
		inMapTmp.put("LOGIN_NO", inDto.getLoginNo());
		inMapTmp.put("GROUP_ID", inDto.getGroupId());
		inMapTmp.put("OP_CODE", inDto.getOpCode());
		inMapTmp.put("PAY_PATH", inDto.getPayPath());
		writeOffer.doWriteOff(inMapTmp);

		// 8、标准神州行用户缴费更新有效期
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("ID_NO", payUserBase.getIdNo());
		inMapTmp.put("PHONE_NO", phoneNo);
		inMapTmp.put("BRAND_ID", payUserBase.getBrandId());
		inMapTmp.put("REGION_CODE", payUserBase.getRegionId());
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("PAY_MONEY", inDto.getPayMoney());
		inMapTmp.put("LOGIN_NO", inDto.getLoginNo());
		inMapTmp.put("OP_CODE", inDto.getOpCode());
		inMapTmp.put("CUR_TIME", curTime);
		inMapTmp.put("TOTAL_DATE", totalDate);
		payOpener.updateExpireTime(inMapTmp);

		// 9.实时开机
		payOpener.doConUserOpen(inDto.getHeader(), payUserBase, bookIn, inDto.getProvinceId());
		
		//记录营业员操作日志
		LoginOprEntity in = new LoginOprEntity();
		in.setIdNo(payUserBase.getIdNo());
		in.setBrandId(payUserBase.getBrandId());
		in.setPhoneNo(phoneNo);
		in.setPayType("");
		in.setPayFee(inDto.getPayMoney());
		in.setLoginSn(paySn);
		in.setLoginNo(inDto.getLoginNo());
		in.setLoginGroup(inDto.getGroupId());
		in.setOpCode(inDto.getOpCode());
		in.setTotalDate(Long.parseLong(totalDate));
		in.setRemark(inDto.getOpCode());
		record.saveLoginOpr(in);
		
		//发送统一接触消息 ， 缴费用户  为了发送统一接触区分 流水前加字母 P
		String jfPaySn = "P" + paySn;
		Map<String, Object> oprCnttMap = new HashMap<String, Object>(); 
		oprCnttMap.put("Header", inDto.getHeader()); 
		oprCnttMap.put("PAY_SN", jfPaySn); 
		oprCnttMap.put("LOGIN_NO", inDto.getLoginNo()); 
		oprCnttMap.put("GROUP_ID", inDto.getGroupId()); 
		oprCnttMap.put("OP_CODE", inDto.getOpCode()); 
		oprCnttMap.put("REGION_ID", payUserBase.getRegionId()); 
		oprCnttMap.put("OP_NOTE", inDto.getPayNote()); 
		oprCnttMap.put("CUST_ID_TYPE", "1"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
		oprCnttMap.put("CUST_ID_VALUE", payUserBase.getPhoneNo());
		oprCnttMap.put("OP_TIME", curTime);
		oprCnttMap.put("TOTAL_FEE", inDto.getPayMoney());
		preOrder.sendOprCntt(oprCnttMap);
		
		//发送统一接触消息 ， 代理商  为了发送统一接触区分 流水前加字母 A
		String dlsPaySn = "A" + paySn;
		Map<String, Object> oprCnttMap2 = new HashMap<String, Object>(); 
		oprCnttMap2.put("Header", inDto.getHeader()); 
		oprCnttMap2.put("PAY_SN", dlsPaySn); 
		oprCnttMap2.put("LOGIN_NO", inDto.getLoginNo()); 
		oprCnttMap2.put("GROUP_ID", inDto.getGroupId()); 
		oprCnttMap2.put("OP_CODE", inDto.getOpCode()); 
		oprCnttMap2.put("REGION_ID", agentUserBase.getRegionId()); 
		oprCnttMap2.put("OP_NOTE", inDto.getPayNote()); 
		oprCnttMap2.put("CUST_ID_TYPE", "1"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
		oprCnttMap2.put("CUST_ID_VALUE", agentUserBase.getPhoneNo());
		oprCnttMap2.put("OP_TIME", curTime);
		oprCnttMap2.put("TOTAL_FEE", (-1)*inDto.getPayMoney());
		preOrder.sendOprCntt(oprCnttMap2);
		
		//IVR调用需要返回代理商余额
		OutFeeData agentFee = remainFee.getConRemainFee(agentUserBase.getContractNo());
		OutFeeData payUserFee = remainFee.getConRemainFee(payUserBase.getContractNo());
		
		/*
		 * 10.发送短信
		 */
		inMapTmp = new HashMap<String, Object>();
		sendPayMsg(inMapTmp);
		
		S8016CfmOutDTO outDto = new S8016CfmOutDTO();
		outDto.setPaySn(paySn);
		outDto.setTotalDate(totalDate);
		outDto.setAgentRemainFee(agentFee.getRemainFee());
		outDto.setRemainFee(payUserFee.getRemainFee());
		
		log.info("空中充值确认cfm end" + outDto.toJson());

		return outDto;
	}
	
	/**
	* 名称：空中充值发送短信(各省实现)
	*/
	protected  void sendPayMsg (Map<String, Object> inParam){
		
	};
	
	/**
	* 名称：业务错误发送短信
	* errType:  1 号码不具备空中充值代理商资格
	* 			2 代理商密码不正确
	* 			3 此空中充值代理商已关闭或无效
	*/
	protected  void sendPayErrMsg (String errType, Map<String, Object> inParam){
		
	};


	/**
	* 名称：校验用户密码	</br>
	* @param phoneNo
	* @param passWord
	* @return boolean 如果校验通过返回true , 否则返回false
	* @author qiaolin
	*/
	private boolean checkPassword(String phoneNo, String passWord){
		
		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;
		
		return true;
	}
	
	
	private PayUserBaseEntity getCfmBaseInfo(String phoneNo, Long inConNo, String provinceId){
		
		UserInfoEntity userInfo = null;
		String brandId = "XX";
		long   idNo = 0;
		if(!phoneNo.equals("99999999999")){
			
			userInfo = user.getUserInfo(phoneNo);
			idNo = userInfo.getIdNo();
			brandId = userInfo.getBrandId();
		}
		
		long contractNo = 0;
		if(inConNo == null){
			contractNo = userInfo.getContractNo();
		}else{
			contractNo = inConNo;
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
	

	public IPreOrder getPreOrder() {
		return preOrder;
	}

	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}

	public TransFactory getTransFactory() {
		return transFactory;
	}

	public void setTransFactory(TransFactory transFactory) {
		this.transFactory = transFactory;
	}

	public ILogin getLogin() {
		return login;
	}

	public void setLogin(ILogin login) {
		this.login = login;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public IRemainFee getRemainFee() {
		return remainFee;
	}

	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}

	public IUser getUser() {
		return user;
	}

	public void setUser(IUser user) {
		this.user = user;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

	public IWriteOffer getWriteOffer() {
		return writeOffer;
	}

	public void setWriteOffer(IWriteOffer writeOffer) {
		this.writeOffer = writeOffer;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}

	public IAgent getAgent() {
		return agent;
	}

	public void setAgent(IAgent agent) {
		this.agent = agent;
	}

	public IProd getProd() {
		return prod;
	}

	public void setProd(IProd prod) {
		this.prod = prod;
	}

	public IPayManage getPayManage() {
		return payManage;
	}

	public void setPayManage(IPayManage payManage) {
		this.payManage = payManage;
	}

	public IPayOpener getPayOpener() {
		return payOpener;
	}

	public void setPayOpener(IPayOpener payOpener) {
		this.payOpener = payOpener;
	}
}
