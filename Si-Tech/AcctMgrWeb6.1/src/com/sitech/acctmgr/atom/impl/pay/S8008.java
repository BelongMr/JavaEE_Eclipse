package com.sitech.acctmgr.atom.impl.pay;

import com.alibaba.fastjson.JSON;
import com.sitech.acctmgr.atom.busi.pay.backfee.BackFeeDEAD;
import com.sitech.acctmgr.atom.busi.pay.backfee.BackFeeON;
import com.sitech.acctmgr.atom.busi.pay.backfee.BackFeeType;
import com.sitech.acctmgr.atom.busi.pay.hlj.BackFeeFactory;
import com.sitech.acctmgr.atom.busi.pay.inter.ILimitFee;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.busi.pay.inter.IWriteOffer;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.adj.ComplainAdjReasonEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.pay.BalanceNBEntity;
import com.sitech.acctmgr.atom.domains.pay.DistrictLimitEntity;
import com.sitech.acctmgr.atom.domains.pay.FieldEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.pay.RegionLimitEntity;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserBrandEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserPrcEntity;
import com.sitech.acctmgr.atom.dto.pay.*;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.comp.busi.LoginCheck;
import com.sitech.acctmgr.inter.pay.I8008;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.apache.commons.collections.MapUtils.getLongValue;
import static org.apache.commons.collections.MapUtils.getString;
import static org.apache.commons.collections.MapUtils.safeAddToMap;

/**
* @Title:   []
* @Description: 
* @Date : 2016年3月8日下午2:04:45
* @Company: SI-TECH
* @author : LIJXD
* @version : 1.0
* @modify history
*  <p>修改日期    修改人   修改目的<p> 	
*/

@ParamTypes({
	@ParamType(m="init",c= S8008InitInDTO.class,oc=S8008InitOutDTO.class,
		routeKey ="10",routeValue = "phone_no",busiComId = "构件id",
		srvCat = "退预存款",srvCnName = "退预存款",srvVer = "V10.8.126.0",
		srvDesc = "退预存款查询",srcAttr = "核心",srvLocal = "否",srvGroup = "否"),
	@ParamType(m="cfm",c= S8008CfmInDTO.class,oc=S8008CfmInDTO.class,
		routeKey ="10",routeValue = "phone_no",busiComId = "构件id",
		srvCat = "退预存款",srvCnName = "退预存款",srvVer = "V10.8.126.0",
		srvDesc = "退预存款确认",srcAttr = "核心",srvLocal = "否",srvGroup = "否"),
	@ParamType(m="noBackMoney",c= S8008NoBackInDTO.class,oc=S8008NoBackOutDTO.class,
		routeKey ="10",routeValue = "phone_no",busiComId = "构件id",
		srvCat = "退预存款",srvCnName = "退预存款",srvVer = "V10.8.126.0",
		srvDesc = "退预存款不可退预存列表",srcAttr = "核心",srvLocal = "否",srvGroup = "否"),
	@ParamType(m="broadband",c= S8008BbdInDTO.class,oc=S8008BbdOutDTO.class,
		routeKey = "10",routeValue = "",busiComId = "构件id",
		srvCat = "退预存款",srvCnName = "退预存款",srvVer = "V10.8.126.0", 
		srvDesc = "宽带退款",srcAttr = "核心",srvLocal = "否",srvGroup = "否")

})
public class S8008 extends AcctMgrBaseService implements I8008 {

	protected IUser user;
	protected IProd prod;
	protected ICust cust;
	protected IAccount account;                  
	protected IBalance balance;
	protected IControl control;
	protected IInvoice invoice;
	protected IWriteOffer writeOffer;
	protected IPreOrder preOrder;
	protected IBill bill;
	protected ILogin login;
	protected IGroup group;
	protected IRecord record;
	protected ILimitFee limitFee;
	protected IPayManage payManage;
	protected IRemainFee remainFee;
	

	//宽带号码转换
	@Override
	public OutDTO broadband(InDTO inParam) {
		
		S8008BbdInDTO inDto = (S8008BbdInDTO) inParam;
		
		log.info("S8008broadband in :" + inDto.getMbean());
		
		/*获取入参信息*/
		String addServiceNo = inDto.getServiceNo();
		String inIfOnNet = inDto.getInIfOnNet();
		String addBbrType = "02";
		String authoriseFlag = "0";
		String bbdType = inDto.getBbdType();
		
		
		/* 获取服务号码 */
		
	    String phoneNo = user.getPhoneNoByAsn(addServiceNo, addBbrType);
	    
		
	    /*获取账户信息*/
		
		UserInfoEntity baseInfo = user.getUserInfo(phoneNo) ;
		Long contractNo = baseInfo.getContractNo();
		String brandId = baseInfo.getBrandId();
		
		//
		if(bbdType.equals("1")){
			if(!(brandId.contains("kh"))){
			throw new BaseException(AcctMgrError.getErrorCode("8008", "00018"),"非kh品牌，无法退费!");
			}
			/*铁通宽带校验工号权限*/
			Map<String,Object> inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("LOGIN_NO", inDto.getLoginNo());
			inMapTmp.put("BUSI_CODE", "BBMA0272");
			LoginCheck logincheck = new LoginCheck();
			boolean powerFlag = logincheck.pchkFuncPower(inDto.getHeader(), inMapTmp);
			log.info("powerFlag-------------->"+powerFlag);
			if(powerFlag){
				authoriseFlag = "1";
			}
		}else if(brandId.contains("kh") && bbdType.equals("2")){
			throw new BaseException(AcctMgrError.getErrorCode("8008", "00019"),"kh品牌不能在此模块补收！");
		}
		/*获取出参信息 */
		S8008BbdOutDTO outDTO = new S8008BbdOutDTO();
		outDTO.setPHONE_NO(phoneNo);
		outDTO.setCONTRACT_NO(contractNo);
		outDTO.setAuthoriseFlag(authoriseFlag);
		return outDTO;
	};
	/**
	 * 查询
	 */
	@Override
	public OutDTO init(InDTO inParam) {
		Map<String, Object> outInitMap = null;
		List<PubCodeDictEntity>  reasonEnt = null;
		S8008InitInDTO inDTO = (S8008InitInDTO) inParam;
		
		log.error("s8008init inParam:" + inDTO.getMbean());
		
		// 获取入参信息
		String phoneNo = inDTO.getPhoneNo();
		long contractNo = inDTO.getContractNo();
		//String userOnNet = inDTO.getInIfOnNet();
		String opType = inDTO.getOpType();
		String provinceId = inDTO.getProvinceId();
		String codeName = null;
		
		
		//检查出账标识，出账期间不允许退费  已放规则引擎中
		
		//获取退费类型实例
		BackFeeType backType = BackFeeFactory.createBackFeeFactory(opType,this);

		//获取用户(账户)基本资料
		Map<String, Object> baseInfo = backType.getBaseInfo(phoneNo, contractNo, provinceId);
		PayUserBaseEntity userBaseInfo = (PayUserBaseEntity)baseInfo.get("USER_BASE_INFO");
		String contractattType = getString(baseInfo,"CONTRACTATT_TYPE");
		
		long idNo = userBaseInfo.getIdNo();
		contractNo = userBaseInfo.getContractNo();
				
		//空中充值账户不允许退预存款
		if(contractattType.equals(PayBusiConst.AIR_RECHARGE_CONTYPE)){
			log.info("空中充值账户不允许退预存款! CONTRACT_NO: " + contractNo);
			throw new BusiException(AcctMgrError.getErrorCode("8008","00016"), "空中充值账户不允许退预存款!");
		}
		//在线账务：账单落地，做冲销 特殊业务
//		backType.billToGround(inDTO, baseInfo);
				
		//获取用户 当前预存、欠费、可退预存
		outInitMap = backType.getBackFeeFinal(idNo, contractNo);
		long prepayFeeAll = getLongValue(outInitMap, "PREPAY_FEE");
		long oweFeeAll = getLongValue(outInitMap, "OWE_FEE");
		long returnMoney = getLongValue(outInitMap, "RETURN_MONEY");
		
		//获取账户其余信息
		String beginDate = "";
		String endDate = "";
		long days = 0;
		long zifei = 0;
		String ifGetMonth = ""; //是否取整月
		if(opType.equals("BbdBackFeeON")){
			 beginDate = (String)outInitMap.get("BEGIN_DATE");
			 endDate = (String)outInitMap.get("END_DATE");
			 days = (long)outInitMap.get("DATE_SUB");
			 zifei = (long)outInitMap.get("ZI_FEI");
			 ifGetMonth = (String)outInitMap.get("IF_GET_MONTH");
		}
		
		//获取退费原因类型
		long codeClass = 2301;
		reasonEnt =  control.getPubCodeList(codeClass,null,null,null);
		List<ComplainAdjReasonEntity> reasonList =  new ArrayList<ComplainAdjReasonEntity>();
		for(PubCodeDictEntity codeDictEnt : reasonEnt){
			codeName = codeDictEnt.getCodeName();
			String codeId = codeDictEnt.getCodeId();
			ComplainAdjReasonEntity reasonEnt2 = new ComplainAdjReasonEntity(); 
			
				reasonEnt2.setReasonName(codeName);
				reasonEnt2.setReasonCode(codeId);
				
			reasonList.add(reasonEnt2);
		}
				
		S8008InitOutDTO outDTO = new S8008InitOutDTO();
		
		log.info("----------> s8008init outParam" + outDTO.toJson());
		
		outDTO.setOutPrepayFee(prepayFeeAll);
		System.out.println(prepayFeeAll);
		outDTO.setBeginDate(beginDate);
		outDTO.setEndDate(endDate);
		outDTO.setZiFei(zifei);
		outDTO.setDateSub(days);
		outDTO.setIfGetMonth(ifGetMonth);
		outDTO.setUnbillTotal(oweFeeAll);
		outDTO.setReturnMoney(returnMoney);
		outDTO.setConEncrypName(baseInfo.get("CONTRACT_NAME").toString());
		outDTO.setContractNo(contractNo);
		outDTO.setPhoneNo(phoneNo);
		outDTO.setListReasonInfo(reasonList);
		System.out.println(phoneNo);
		log.info("----------> s8008init outParam" + outDTO.toJson());
		return outDTO;	
	}


	/**
	 * 不可退预存列表
	 */
	@Override
	public OutDTO noBackMoney(InDTO inParam)  {
		// TODO Auto-generated method stub
		S8008NoBackInDTO inDTO = (S8008NoBackInDTO) inParam;
		String opType = inDTO.getOpType();
		String inIfOnNet= inDTO.getInIfOnNet();
		long contractNo=inDTO.getContractNo();

		BackFeeType backType = BackFeeFactory.createBackFeeFactory(opType,this);

		//pay_type合并金额列表
		List<BalanceNBEntity> noBackList = backType.getNoBackList(contractNo);
		
		String jsonMap =JSON.toJSONString(noBackList);
		System.out.println(jsonMap);
		long nbksize = noBackList.size();
		System.out.println(nbksize);
		S8008NoBackOutDTO outDTO=new S8008NoBackOutDTO();
		outDTO.setOutList(noBackList);
		outDTO.setNbksize(nbksize);
		return outDTO;
	}
 
	/**
	 * 确认服务
	 */
	@Override
	public OutDTO cfm(InDTO inParam)  {
		Map<String, Object> outCfmMap = null;

		S8008CfmInDTO inDTO = (S8008CfmInDTO) inParam;
		
		log.info("s8008cfm_in" + inDTO.getMbean());
		
		String limitType = "tf";
		
		//获取入参信息
		String phoneNo = inDTO.getPhoneNo();
		long contractNo = inDTO.getContractNo();
		long payMoney = inDTO.getPayMoney();
		String userOnNet = inDTO.getInIfOnNet();
		String payPath = inDTO.getPayPath();
		String payMethod = inDTO.getPayMethod();
		String opType = inDTO.getOpType();
		String payType = inDTO.getPayType();
		String groupId = inDTO.getGroupId();
		String loginNo = inDTO.getLoginNo();
		String provinceId = inDTO.getProvinceId();
		String ForeignSn = inDTO.getForeignSn();
		String foreignTime = inDTO.getForeignTime();
		
		//获取工号groupId
		LoginEntity loginEnt = login.getLoginInfo(loginNo, provinceId, true);
		if(groupId == "" || groupId == null){
			groupId = loginEnt.getGroupId();
		}
		
		//在网退预存只允许区县及区县级别以下工号，离网无限制
		String regionId = null;
		String regionGroup = null;
		String districtGroup = null;
		if((userOnNet.equals("1")&&opType.equals("BackFeeON"))||userOnNet.equals("4")){//只有普通在网和宽带做限制
			try {
				//查询账户地市归属信息
				ChngroupRelEntity groupEntity = group.getRegionDistinct(groupId, "2", provinceId);
				regionId = groupEntity.getParentGroupId();
				regionGroup = regionId;
				System.out.println(regionGroup);
					
				//查询账户区县归属信息
				ChngroupRelEntity groupEntity2 = group.getRegionDistinct(groupId, "3", provinceId);
				String districtId = groupEntity2.getParentGroupId();
				districtGroup = districtId;
				System.out.println(districtGroup);
			} catch (Exception e) {
				throw new BusiException(AcctMgrError.getErrorCode("8008","00020"), "在网不支持区县级以上工号退预存款！");
			}
		}else{
			try {
				//查询账户地市归属信息
				ChngroupRelEntity groupEntity = group.getRegionDistinct(groupId, "2", provinceId);
				regionId = groupEntity.getParentGroupId();
				regionGroup = regionId;
				System.out.println(regionGroup);
			} catch (Exception e) {
				regionGroup = null;
			}
		}
				
		// 校验工号
		if( StringUtils.isEmptyOrNull(inDTO.getGroupId()) ){
			LoginEntity  loginEntity = login.getLoginInfo(inDTO.getLoginNo(), inDTO.getProvinceId());
			groupId = loginEntity.getGroupId();
		}

		// 获取时间
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		int totalDate = Integer.parseInt(curTime.substring(0, 8));
		int yearMonth = Integer.parseInt(curTime.substring(0, 6));

		// 获取退费类型实例
		BackFeeType backType = BackFeeFactory.createBackFeeFactory(opType,this);
		
		// 获取退预存款金额
		long backMoney = backType.getPayMoney(payMoney);
		log.info("退预存款[" + inDTO.getForeignSn() + "]转换后的金额: payMoney=" + backMoney);

		// 获取用户(账户)基本资料
		Map<String, Object> baseInfo = backType.getBaseInfo(phoneNo, contractNo,provinceId);
		PayUserBaseEntity userBaseInfo = (PayUserBaseEntity)baseInfo.get("USER_BASE_INFO");
		long idNo = userBaseInfo.getIdNo();
		contractNo = userBaseInfo.getContractNo();
		phoneNo = userBaseInfo.getPhoneNo();
		String brandId = userBaseInfo.getBrandId();
		String prcId = "";
		if(userOnNet.equals("1")){
			UserPrcEntity userPrcEnt = prod.getUserPrcidInfo(idNo,true);
			prcId = userPrcEnt.getProdPrcid();
		}
		
		//信息验证
		Map<String, Object> checkMap = new HashMap<String, Object>();
		checkMap.put("PROVINCE_ID", provinceId);
		checkMap.put("GROUP_ID", groupId);
		checkMap.put("PHONE_NO", phoneNo);
		checkMap.put("ID_NO", idNo);
		checkMap.put("BASE_INFO", baseInfo);
		checkMap.put("BRAND_ID", brandId);
		checkMap.put("PRC_ID", prcId);
		checkMap.put("OP_CODE", inDTO.getOpCode());
		checkMap.put("USER_ON_NET", userOnNet);
		backType.checkSpecialBusiness(checkMap);
		
		// 取8008可退预存
		outCfmMap = backType.getBackFeeFinal(idNo, contractNo);
		long returnMoney = getLongValue(outCfmMap, "RETURN_MONEY");
		
		
		// 退费金额校验
		backType.feeCheck(backMoney, returnMoney);
		
		// 获取payType
		payType = backType.getPayType(opType,payType);
		
		// 给用户退费
		PayBookEntity bookIn = new PayBookEntity();
		bookIn.setBeginTime(curTime);
		bookIn.setGroupId(groupId);
		bookIn.setLoginNo(loginNo);
		bookIn.setOpCode(inDTO.getOpCode());
		bookIn.setOpNote(inDTO.getNote());
		bookIn.setPayFee(backMoney);
		bookIn.setPayMethod(payMethod);
		bookIn.setPayPath(payPath);
		bookIn.setPayType(payType);
		bookIn.setTotalDate(totalDate);
		bookIn.setYearMonth(yearMonth);
		bookIn.setForeignSn(ForeignSn);
		bookIn.setForeignTime(foreignTime);
		outCfmMap = backType.doBackMoney(userBaseInfo,bookIn);
		long payAccept = getLongValue(outCfmMap, "PAY_ACCEPT");
		
		// 获取划拨后余额
//		long afterPrepay = backType.getConPrePay(contractNo,idNo);
		
		//原因记录日志
		outCfmMap = new  HashMap<String, Object>();
		long fieldOrder = Long.parseLong(userOnNet);
		String opCode = inDTO.getOpCode();
		String reason = inDTO.getReason();
		if(!(reason == null || reason.equals(""))){
			if(reason.equals("国际漫游退款")){
				boolean isGjmy = prod.hasPrcid(idNo, "M001027");
				if(isGjmy){
					throw new BusiException(AcctMgrError.getErrorCode("8008","00008"), "国际漫游用户不允许退预存款!");
				}
			}
		}
		String fieldCode = "";
		if(opCode.equals("8081")){
			fieldCode= "notReal";
		}else{
			fieldCode= "reason";
		}
		
		/*退费原因入缴费扩展记录表*/
		FieldEntity field = new FieldEntity();
		field.setFieldCode(fieldCode);
		field.setFieldValue(reason);
		bookIn.setForeignSn(null);
		bookIn.setPaySn(payAccept);
		record.savePayextend(userBaseInfo, bookIn, field,inDTO.getHeader());
		
		// 记录日志
		LoginOprEntity oprEnt = new LoginOprEntity();
		oprEnt.setBrandId(userBaseInfo.getBrandId());
		oprEnt.setIdNo(idNo);
		oprEnt.setLoginGroup(groupId);
		oprEnt.setLoginNo(loginNo);
		oprEnt.setLoginSn(payAccept);
		oprEnt.setOpCode(inDTO.getOpCode());
		oprEnt.setOpTime(curTime);
		oprEnt.setPayFee((-1) * payMoney);
		oprEnt.setPayType("w");
		oprEnt.setPhoneNo(phoneNo);
		oprEnt.setRemark(inDTO.getNote());
		oprEnt.setTotalDate(totalDate);
		record.saveLoginOpr(oprEnt);
		
		//发送短信
		Map<String, Object> sendMsg = new HashMap<String, Object>();
		backType.sendMsg(sendMsg);
		
		//TODO 报表同步
		
		//发送营业日报
		List<Map<String, Object>> keysList = new ArrayList<Map<String, Object>>(); // 同步报表库数据List
		Map<String, Object> paymentKey = new HashMap<String, Object>();
		paymentKey.put("YEAR_MONTH", curTime.substring(0, 6));
		paymentKey.put("CONTRACT_NO", contractNo);
		paymentKey.put("PAY_SN", payAccept);
		paymentKey.put("ID_NO", idNo);
		paymentKey.put("PAY_TYPE", payType);
		paymentKey.put("TABLE_NAME", "BAL_PAYMENT_INFO");
		paymentKey.put("UPDATE_TYPE", "I");
		keysList.add(paymentKey);
		
		Map<String,Object> inMap =  new HashMap<String, Object>();
		inMap.put("PAY_SN", payAccept);
		inMap.put("LOGIN_NO", loginNo);
		inMap.put("GROUP_ID", groupId);
		inMap.put("OP_CODE", opCode);
		inMap.put("PHONE_NO", phoneNo);
		inMap.put("BRAND_ID", brandId);
		inMap.put("BACK_FLAG", "0");
		inMap.put("OLD_ACCEPT", payAccept);
		inMap.put("OP_TIME", curTime);
		inMap.put("OP_NOTE", inDTO.getNote());
		inMap.put("ACTION_ID", "1001");
		
		inMap.put("KEYS_LIST", keysList);
		inMap.put("REGION_ID", regionId);
		inMap.put("CUST_ID_TYPE", "1"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
		inMap.put("CUST_ID_VALUE", phoneNo);
		inMap.put("Header", inDTO.getHeader());
		inMap.put("TOTAL_FEE", payMoney);
		log.info("输出报文：------>"+inMap.toString());
		preOrder.sendData2(inMap);
		
		/*
		 * regionGroup:地市groupId
		 * districtGroup:区县groupId
		 * limitType:限制类型
		 * backMoney:退费金额
		 * cLimitCycle:区县限额周期
		 * rLimitCycle：地市限额周期
		 * */
		backType.checkRegionDistrict(regionGroup,limitType,backMoney,districtGroup);
		

		S8008CfmOutDTO outDTO = new S8008CfmOutDTO();
		outDTO.setPayAccept(payAccept);
		outDTO.setTotalDate(String.valueOf(totalDate));
//		outDTO.setRemainFee(afterPrepay);
		return outDTO;
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
	 * @return the account
	 */
	public IAccount getAccount() {
		return account;
	}


	/**
	 * @param account the account to set
	 */
	public void setAccount(IAccount account) {
		this.account = account;
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
	 * @return the invoice
	 */
	public IInvoice getInvoice() {
		return invoice;
	}


	/**
	 * @param invoice the invoice to set
	 */
	public void setInvoice(IInvoice invoice) {
		this.invoice = invoice;
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
	 * @return the login
	 */
	public ILogin getLogin() {
		return login;
	}


	/**
	 * @param login the login to set
	 */
	public void setLogin(ILogin login) {
		this.login = login;
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
	 * @return the prod
	 */
	public IProd getProd() {
		return prod;
	}
	/**
	 * @param prod the prod to set
	 */
	public void setProd(IProd prod) {
		this.prod = prod;
	}
	/**
	 * @return the preOrder
	 */
	public IPreOrder getPreOrder() {
		return preOrder;
	}
	/**
	 * @param preOrder the preOrder to set
	 */
	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
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
	 * @return the limitFee
	 */
	public ILimitFee getLimitFee() {
		return limitFee;
	}
	/**
	 * @param limitFee the limitFee to set
	 */
	public void setLimitFee(ILimitFee limitFee) {
		this.limitFee = limitFee;
	}
	
}