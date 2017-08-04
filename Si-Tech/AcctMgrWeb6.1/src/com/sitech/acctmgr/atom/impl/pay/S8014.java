package com.sitech.acctmgr.atom.impl.pay;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayOpener;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.busi.pay.inter.ITransType;
import com.sitech.acctmgr.atom.busi.pay.inter.IWriteOffer;
import com.sitech.acctmgr.atom.busi.pay.trans.TransAccount;
import com.sitech.acctmgr.atom.busi.pay.trans.TransFactory;
import com.sitech.acctmgr.atom.busi.query.inter.IOweBill;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.account.ContractDeadInfoEntity;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.adj.ComplainAdjReasonEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.cust.GrpCustInfoEntity;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.pay.FieldEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.pay.RegionLimitEntity;
import com.sitech.acctmgr.atom.domains.pay.TransFeeEntity;
import com.sitech.acctmgr.atom.domains.pay.TransOutEntity;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.domains.query.TransLimitEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.GroupUserInfo;
import com.sitech.acctmgr.atom.domains.user.UserBrandEntity;
import com.sitech.acctmgr.atom.domains.user.UserDeadEntity;
import com.sitech.acctmgr.atom.domains.user.UserDetailEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserPrcEntity;
import com.sitech.acctmgr.atom.domains.user.UsersvcAttrEntity;
import com.sitech.acctmgr.atom.dto.pay.S8014CfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8014CfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S8014GrpCfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8014GrpCfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S8014InitGrpInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8014InitGrpOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S8014InitInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8014InitOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IAgent;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IProd;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgr.inter.pay.I8014;
import com.sitech.acctmgrint.atom.busi.intface.IShortMessage;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
 *
 * <p>
 * Title: 转账服务实现类
 * </p>
 * <p>
 * Description: 转账服务超类，定义转账流程模版
 * </p>
 * <p>
 * Copyright: Copyright (c) 2014
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 * 
 * @author
 * @version 1.0
 */

@ParamTypes({ @ParamType(m = "initGrp", c = S8014InitGrpInDTO.class, oc = S8014InitGrpOutDTO.class),
			  @ParamType(m = "init", c = S8014InitInDTO.class, oc = S8014InitOutDTO.class),
	          @ParamType(m = "cfm", c = S8014CfmInDTO.class, oc = S8014CfmOutDTO.class),
			  @ParamType(m = "grpcfm", c = S8014GrpCfmInDTO.class, oc = S8014GrpCfmOutDTO.class)})
public class S8014 extends AcctMgrBaseService implements I8014 {
	
	private IBill bill;
	protected IAccount account;
	protected IProd prod;
	protected ILogin login;
	protected IGroup group;
	protected IControl control;
	protected IPayManage payManage;
	protected IPreOrder preOrder;
	protected IUser user;
	protected ICust cust;
	protected IOweBill oweBill;
	protected IRemainFee remainFee;
	protected IWriteOffer writeOffer;
	protected IRecord record;
	protected IBalance balance;
	protected TransFactory transFactory;
	protected IAgent agent;
	protected IPayOpener payOpener;
	protected IShortMessage shortMessage;

	private String onNetFlag = "";
	
	public OutDTO initGrp(InDTO inParam){
		
		S8014InitGrpInDTO inDto = (S8014InitGrpInDTO)inParam;
		
		/*获取入参信息*/
		long iccId = inDto.getIdIccid();
		long custId = inDto.getCustId();
		long unitId = inDto.getUnitId();
		long grpConNo = inDto.getGrpContractNo();
		String unitIdStr = String.valueOf(unitId);
		String custIdStr = String.valueOf(custId);
		String iccIdStr = String.valueOf(iccId);
		String grpConNoStr = String.valueOf(grpConNo);
		if(unitIdStr.equals("0")){
			unitIdStr = null;
		}
		if(custIdStr.equals("0")){
			custIdStr = null;
		}
		if(iccIdStr.equals("0")){
			iccIdStr = null;
		}
		if(grpConNoStr.equals("0")){
			grpConNoStr = null;
		}
		
		/*根据unitId、custId或groupNo查询集团信息*/
		List<GroupUserInfo> userInfoListTmp = user.getGrpInfo(iccIdStr,custIdStr,unitIdStr,grpConNoStr);
		if(userInfoListTmp.isEmpty()){
			throw new BusiException(AcctMgrError.getErrorCode("8014", "00024"), "不存在集团信息");
		}
		
		String groupName = "";
		String groupId = "";
		Iterator it = userInfoListTmp.iterator();
		while(it.hasNext()){
			GroupUserInfo grp = (GroupUserInfo) it.next();
			unitId = grp.getUnitID();
			iccIdStr = grp.getIccId();
			custId = grp.getCustId();
			long idNo = grp.getIdNo();
		
			//取集团信息
			Map<String,Object> userInfoListTmp2 = new HashMap<String,Object>();
		
			userInfoListTmp2 = (Map<String, Object>) user.getUrGrpInfo(idNo);
			groupName = (String)userInfoListTmp2.get("GROUP_NAME");
			groupName = control.pubEncryptData(groupName, 1);
		}
		
		custIdStr = String.valueOf(custId);
		long brandContractNo = 0;
		long idNo = 0;
		String brandName = "";
		long grpPrePay = 0;
		long grpOweFee = 0;
		String phoneNo = "";
		List<GroupUserInfo> userInfoList = new ArrayList<GroupUserInfo>();
		for(GroupUserInfo groupUserInfo:userInfoListTmp){
			
			String choice = "";
			brandContractNo = groupUserInfo.getContractNo();
			idNo = groupUserInfo.getIdNo();
			phoneNo = groupUserInfo.getPhoneNo();
			
			/*查询产品名称*/
			brandName = user.getUserBrandRel(idNo).getBrandName();
			
			choice = brandContractNo + "-->" + brandName;
			
			/*查询集团产品账户预存和欠费*/
			grpPrePay = balance.getSumBalacneByPayTypes(brandContractNo,"0");
			log.info("grpPrePay -->" + grpPrePay);
			Map<String, Long> oweMap = bill.getSumUnpayInfo(brandContractNo, idNo, 0);
			grpOweFee = oweMap.get("OWE_FEE");
			
			log.info("查询集团产品账户预存和欠费");
			
			GroupUserInfo userInfoTmp=new GroupUserInfo();
			userInfoTmp.setContractNo(brandContractNo);
			userInfoTmp.setBrandName(brandName);
			userInfoTmp.setGroupPrePay(grpPrePay);
			userInfoTmp.setGroupOweFee(grpOweFee);
			userInfoTmp.setPhoneNo(phoneNo);
			userInfoTmp.setIdNo(idNo);
			userInfoTmp.setChoiceBrand(choice);
			userInfoList.add(userInfoTmp);
			log.info("费用出入参："+userInfoList.toString());
		}
		S8014InitGrpOutDTO outDto = new S8014InitGrpOutDTO();
		outDto.setUnitId(unitId);
		outDto.setGroupName(groupName);
		outDto.setCustId(custIdStr);
		outDto.setIccId(iccIdStr);
		outDto.setGroupContractList(userInfoList);
		log.info("集团出参："+ outDto.toString());
		
		return outDto;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.inter.pay.I8014#init(com.sitech.jcfx.dt.in.InDTO)
	 */
	@Override
	public OutDTO init(InDTO inParam) {

		ITransType transType;// 转账类型
		List<PubCodeDictEntity>  reasonEnt = null;
		S8014InitInDTO inDto = (S8014InitInDTO) inParam;

		log.info("S8014Init in :" + inDto.getMbean());

		/* 获取入参信息 */
		long contractNo = inDto.getContractNo();
		String phoneNo = inDto.getPhoneNo();
		long idNo = inDto.getIdNo();
		String ifOnNet = inDto.getInIfOnNet();  // 用户在离网标识 1:在网 ; 2:离网
		String opType = inDto.getOpType();
		String loginNo = inDto.getLoginNo();
		String codeName = null;

		/* 设置在网、离网标识 */
		setOnNetFlag(ifOnNet);

		/* 创建转账类型 */
		transType = transFactory.createTransFactory(opType,isOnNet());

		/* 获取用户基本信息 */
		TransOutEntity  baseInfo = getBaseInfo(phoneNo, contractNo);
		
		/*在网用户获取资费信息*/
		String prcId = "";
		if(ifOnNet.equals("1")){
			UserPrcEntity userPrcEnt = prod.getUserPrcidInfo(idNo,true);
			prcId = userPrcEnt.getProdPrcid();
		}
		
		/* 个性化业务查询  */
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("BASE_INFO", baseInfo);
		inMap.put("IN_DTO", inDto);
		inMap.put("ID_NO", idNo);
		inMap.put("PRC_ID", prcId);
		Map<String, Object> specialMap = transType.getSpecialBusiness(inMap);
		
		/* 取账户可转余额 */
		long transFee = transType.getTranFee(contractNo);
		log.info("8014可转余额---->"+transFee);
		baseInfo.setTransFee(transFee);
		
		/*取账户余额*/
		long remainFee = getRemainFeeInfo(idNo,contractNo);
		baseInfo.setRemainFee(remainFee);
		
		/* 获取可转账本列表 */
		List<TransFeeEntity> transFeeList = transType.getComTranFeeList(contractNo);
		
		//获取转账原因列表
		long codeClass = 2205;
		reasonEnt = control.getPubCodeList(codeClass,null,null,null);
		List<ComplainAdjReasonEntity> reasonList =  new ArrayList<ComplainAdjReasonEntity>();
		for(PubCodeDictEntity codeDictEnt : reasonEnt){
				codeName = codeDictEnt.getCodeName();
				String codeId = codeDictEnt.getCodeId();
				ComplainAdjReasonEntity reasonEnt2 = new ComplainAdjReasonEntity(); 
					
				reasonEnt2.setReasonName(codeName);
				reasonEnt2.setReasonCode(codeId);
						
				reasonList.add(reasonEnt2);
		}
		
		/* 出参 */
		S8014InitOutDTO outDto = new S8014InitOutDTO();
		outDto.setTransOutInfo(baseInfo);
		outDto.setTransFeeList(transFeeList);
		outDto.setListReasonInfo(reasonList);

		return outDto;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.inter.pay.I8014#cfm(com.sitech.jcfx.dt.in.InDTO)
	 */
	@Override
	public OutDTO cfm(InDTO inParam) {
		Map<String, Object> inTransCfmMap = new HashMap<String, Object>();

		ITransType transType;// 转账类型

		long outIdNo = 0; // 转出用户ID
		long inIdNo = 0; // 转入用户ID
		long paySn = 0; // 转账流水
		String totalDate = ""; // 转账日期
		String curYM = "";
		String inBrandId = ""; // 转入用于品牌
		String outBrandId = ""; // 转出用户品牌
		long changeFee = 0;  //可转金额
		String limitType = "zz";

		S8014CfmInDTO inDTO = (S8014CfmInDTO) inParam;

		log.info("-----------------> s8014Cfm_in = " + inDTO.getMbean());
		/* 获取入参信息 */
		long outContractNo = inDTO.getOutContractNo();
		String outPhoneNo = inDTO.getOutPhoneNo();
		long inContractNo = inDTO.getInContractNo();
		String inPhoneNo = inDTO.getInPhoneNo();
		String opType = inDTO.getOpType(); // 转账类型 --> ZHZZ: 账户转账 ; SZXYEZZ:神州行余额转账; 
		String ifOnNet = inDTO.getIfOnNet(); // 用户在离网标识 --> 1:在网 ; 2:离网
		String opNote = inDTO.getOpNote();
		String opCode = inDTO.getOpCode();
		String loginNo = inDTO.getLoginNo();
		String groupId = inDTO.getGroupId();
		String payPath = inDTO.getPayPath();
		String payMethod = inDTO.getPayMethod();
		String foreignSn = inDTO.getForeignSn(); 
		String reason = inDTO.getReason();
		String fieldCode = "reason";
		long transFee = inDTO.getTransFee();
		String provinceId = inDTO.getProvinceId();
		System.out.println(outContractNo);
		if (groupId == null || "".equals(groupId)) {
			LoginEntity loginEntity = login.getLoginInfo(loginNo, provinceId);
			groupId = loginEntity.getGroupId();
		}

		/* 设置在网、离网标识 */
		setOnNetFlag(ifOnNet);
		
		//查询账户地市归属信息
		ChngroupRelEntity groupEntity = group.getRegionDistinct(groupId, "2", provinceId);
		String regionGroup = groupEntity.getParentGroupId();

		/* 创建转账类型 */
		transType = transFactory.createTransFactory(opType,isOnNet());
		
		/*限制转账金额>0  已放到规则殷勤中 s8014.groovy*/
		/*转入账户和转出账户是否相同验证   已放到规则殷勤中 s8014.groovy*/
		/*检查出帐标志 已放到规则殷勤中 sWriteOff.groovy*/
		
		/* 获取当前日期 */
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		totalDate = curTime.substring(0, 8);
		curYM = curTime.substring(0, 6);
		

		/* 转入账户基本信息查询 */
		PayUserBaseEntity inTransBaseInfo= getUserBaseInfo(inPhoneNo, inContractNo, true, provinceId);
		inContractNo = inTransBaseInfo.getContractNo();
		inIdNo = inTransBaseInfo.getIdNo();
		inBrandId = inTransBaseInfo.getBrandId();
		
		/*转出账户基本信息查询*/
		PayUserBaseEntity  outTransBaseInfo = getUserBaseInfo(outPhoneNo, outContractNo, false, provinceId);
		outIdNo = outTransBaseInfo.getIdNo();
		outBrandId = outTransBaseInfo.getBrandId();
		long outCustId = outTransBaseInfo.getCustId();
		if (outContractNo == 0) {
			outContractNo = outTransBaseInfo.getContractNo();
		}
		outTransBaseInfo.setNetFlag(isOnNet());
		
		/*可转余额校验 */
		changeFee = transType.getTranFee(outContractNo);
		
		if(opType.equals("TransAccountXH")){//CRM批量销户转存转全部可退预存
			transFee = changeFee;
			outTransBaseInfo.setNetFlag(true);
		}
		
		log.info("----> lChangeFee -" + changeFee + ", lTransFee -" + transFee);
		
		if (transFee > changeFee) {
			log.error("------>可转金额小于转账金额, lChangeFee -" + changeFee + ", lTransFee -" + transFee);
			throw new BaseException(AcctMgrError.getErrorCode("8014", "00018"), "可转金额小于转账金额");
		}
		
		/*个性化业务信息验证*/
		Map<String, Object> checkMap = new HashMap<String, Object>();
		checkMap.put("IN_TRANS_BASEINFO", inTransBaseInfo);
		checkMap.put("OUT_TRANS_BASEINFO", outTransBaseInfo);
		checkMap.put("CONTRACTNO_OUT", outContractNo);
		checkMap.put("TRANS_FEE", transFee);
		transType.checkCfm(checkMap);
				
		/*各种转账类型备注信息*/
		opNote = transType.getOpNote(opNote);
	
		/*入账实体设值*/
		PayBookEntity bookIn = new PayBookEntity();
		bookIn.setBeginTime(curTime);
		bookIn.setForeignSn(foreignSn);
		bookIn.setGroupId(groupId);
		bookIn.setLoginNo(loginNo);
		bookIn.setOpCode(opCode);
		bookIn.setOpNote(opNote);
		bookIn.setPayFee(transFee);
		bookIn.setPayMethod(payMethod);
		bookIn.setPayPath(payPath);
		bookIn.setTotalDate(Integer.parseInt(totalDate));
		bookIn.setYearMonth(Long.parseLong(curYM));
		if(opType.equals("GrpProduct")){ //集团产品转账在扩展字段录入集团信息，方便集团产品转账报表查询信息
			long custId = outTransBaseInfo.getCustId();
			/*根据unitId、custId或groupNo查询集团信息*/
			String custIdStr = String.valueOf(custId);
			List<GroupUserInfo> userInfoListTmp = user.getGrpInfo(null,custIdStr,null,null);
			if(userInfoListTmp.isEmpty()){
				throw new BusiException(AcctMgrError.getErrorCode("8014", "00024"), "不存在集团信息");
			}
			long unitId = 0;
			String groupName = "";
			String groupName1 = "";
			Iterator it = userInfoListTmp.iterator();
			while(it.hasNext()){
				GroupUserInfo grp = (GroupUserInfo) it.next();
				unitId = grp.getUnitID();
				custId = grp.getCustId();
				long idNo = grp.getIdNo();
			
				//取集团信息
				Map<String,Object> userInfoListTmp2 = new HashMap<String,Object>();
			
				userInfoListTmp2 = (Map<String, Object>) user.getUrGrpInfo(idNo);
				groupName = (String)userInfoListTmp2.get("GROUP_NAME");
				groupName1 = control.pubEncryptData(groupName,1);
			}
			UserBrandEntity outBrand = user.getUserBrandRel(outIdNo);
			UserBrandEntity inBrand = user.getUserBrandRel(inIdNo);
			String outBrandName = outBrand.getBrandName();
			String inBrandName = inBrand.getBrandName();
			bookIn.setFactorOne(String.valueOf(unitId));//集团编码
			bookIn.setFactorTwo(groupName1);//集团名称
			bookIn.setFactorThree(outBrandName);//转出产品名称
			bookIn.setFactorFour(inBrandName);//转入产品名称
		}

		inTransCfmMap = new HashMap<String, Object>();
		safeAddToMap(inTransCfmMap, "Header", inDTO.getHeader());
		safeAddToMap(inTransCfmMap, "TRANS_TYPE_OBJ", transType); //转账类型实例化对象
		safeAddToMap(inTransCfmMap, "TRANS_IN", inTransBaseInfo);  //转入账户基本信息
		safeAddToMap(inTransCfmMap, "TRANS_OUT", outTransBaseInfo); //转出账户基本信息
		safeAddToMap(inTransCfmMap, "BOOK_IN", bookIn); //入账实体
		safeAddToMap(inTransCfmMap, "OP_TYPE", opType); //转账类型
		
		/*转账*/
		paySn = payManage.transBalance(inTransCfmMap);
		
		/*缴费扩展表录入政企客户信息*/
		if(outBrandId.equals("2310ZQ")){
			Map<String,Object> zqMap = new HashMap<String,Object>();
			zqMap.put("PAY_SN", paySn);
			zqMap.put("CUST_ID", outCustId);
			zqMap.put("OUT_CONTRACT_NO", outContractNo);
			zqMap.put("IN_CONTRACT_NO", inContractNo);
			zqMap.put("ID_NO", outIdNo);
			zqMap.put("OP_CODE", opCode);
			zqMap.put("LOGIN_NO", loginNo);
			zqMap.put("FOREIGN_SN", foreignSn);
			zqMap.put("HEADER", inDTO.getHeader());
			payManage.insertZQInfo(zqMap);
		}
		
		/*转账原因入缴费扩展记录表*/
		FieldEntity field = new FieldEntity();
		field.setFieldCode(fieldCode);
		field.setFieldValue(reason);
		bookIn.setForeignSn(foreignSn);
		record.savePayextend(outTransBaseInfo, bookIn, field,inDTO.getHeader());
		

		/* 缴费用户冲销欠费 */
		inTransCfmMap = new HashMap<String, Object>();
		safeAddToMap(inTransCfmMap, "Header", inDTO.getHeader());
		safeAddToMap(inTransCfmMap, "CONTRACT_NO", inContractNo);
		safeAddToMap(inTransCfmMap, "PAY_SN", paySn);
		safeAddToMap(inTransCfmMap, "PHONE_NO", inPhoneNo);
		safeAddToMap(inTransCfmMap, "LOGIN_NO", loginNo);
		safeAddToMap(inTransCfmMap, "OP_CODE", opCode);
		safeAddToMap(inTransCfmMap, "GROUP_ID", groupId);
		safeAddToMap(inTransCfmMap, "PAY_PATH", payPath);
		safeAddToMap(inTransCfmMap, "DELAY_FAVOUR_RATE", "1");
		writeOffer.doWriteOff(inTransCfmMap);
		
		/*缴费用户做开机*/
		payOpener.doConUserOpen(inDTO.getHeader(), inTransBaseInfo, bookIn, inDTO.getProvinceId());

		/* 转出号码：记录营业员操作日志 */
		LoginOprEntity outTransOpr = new LoginOprEntity();
		outTransOpr.setBrandId(outBrandId);
		outTransOpr.setIdNo(outIdNo);
		outTransOpr.setLoginGroup(groupId);
		outTransOpr.setLoginNo(loginNo);
		outTransOpr.setLoginSn(paySn);
		outTransOpr.setOpCode(opCode);
		outTransOpr.setOpTime(curTime);
		outTransOpr.setPayFee((-1) * transFee);
		outTransOpr.setPhoneNo(outPhoneNo);
		outTransOpr.setRemark(opNote);
		outTransOpr.setPayType("");
		outTransOpr.setTotalDate(Long.parseLong(totalDate));
		record.saveLoginOpr(outTransOpr);

		/* 转入号码：记录营业员操作日志 */
		LoginOprEntity inTransOpr = new LoginOprEntity();
		inTransOpr.setBrandId(inBrandId);
		inTransOpr.setIdNo(inIdNo);
		inTransOpr.setLoginGroup(groupId);
		inTransOpr.setLoginNo(loginNo);
		inTransOpr.setLoginSn(paySn);
		inTransOpr.setOpCode(opCode);
		inTransOpr.setOpTime(curTime);
		inTransOpr.setPayFee(transFee);
		inTransOpr.setPhoneNo(inPhoneNo);
		inTransOpr.setRemark(opNote);
		inTransOpr.setPayType("");
		inTransOpr.setTotalDate(Long.parseLong(totalDate));
		record.saveLoginOpr(inTransOpr);

		/* 发送短信  */
		inTransCfmMap = new HashMap<String, Object>();
		safeAddToMap(inTransCfmMap, "OP_TYPE", opType);
		safeAddToMap(inTransCfmMap, "OUT_PHONE_NO", outPhoneNo);
		safeAddToMap(inTransCfmMap, "IN_PHONE_NO", inPhoneNo);
		safeAddToMap(inTransCfmMap, "TRANS_FEE", transFee);
		safeAddToMap(inTransCfmMap, "OP_CODE", opCode);
		safeAddToMap(inTransCfmMap, "LOGIN_NO", loginNo);
		safeAddToMap(inTransCfmMap, "OUT_CONTRACT_NO", outContractNo);
		safeAddToMap(inTransCfmMap, "IN_CONTRACT_NO", inContractNo);
		transType.transFeeSendMsg(inTransCfmMap);
		
		/* 个性化业务实现 */
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("IN_TRANS_BASE_INFO", inTransBaseInfo);
		inMap.put("OUT_TRANS_BASE_INFO", outTransBaseInfo);
		log.info("inTransBaseInfo---->" + inTransBaseInfo.getContractNo());
		inMap.put("PAY_PATH", payPath);
		transType.doSpecialBusi(inMap);
		
		/*地市限额校验*/
		transType.checkRegionLimit(regionGroup,limitType,transFee);
	
		//转出数据同步营业日报、统一接触、报表库
		List<Map<String, Object>> keysList = new ArrayList<Map<String, Object>>(); // 同步报表库数据List
		Map<String, Object> paymentKey = new HashMap<String, Object>();
		paymentKey.put("YEAR_MONTH", curTime.substring(0, 6));
		paymentKey.put("CONTRACT_NO", outContractNo);
		paymentKey.put("PAY_SN", paySn);
		paymentKey.put("ID_NO", outIdNo);
		paymentKey.put("PAY_TYPE", transType.getTransTypes());
		paymentKey.put("TABLE_NAME", "BAL_PAYMENT_INFO");
		paymentKey.put("UPDATE_TYPE", "I");
		keysList.add(paymentKey);
		
		inMap =  new HashMap<String, Object>();
		inMap.put("PAY_SN", paySn);
		inMap.put("LOGIN_NO", loginNo);
		inMap.put("GROUP_ID", groupId);
		inMap.put("OP_CODE", opCode);
		inMap.put("PHONE_NO", outPhoneNo);
		inMap.put("BRAND_ID", outTransBaseInfo.getBrandId());
		inMap.put("BACK_FLAG", "0");
		inMap.put("OP_TIME", curTime);
		inMap.put("OP_NOTE", opNote);
		inMap.put("ACTION_ID", "1001");
		inMap.put("OLD_ACCEPT", paySn);
		inMap.put("KEYS_LIST", keysList);
		inMap.put("REGION_ID", outTransBaseInfo.getRegionId());
		inMap.put("CUST_ID_TYPE", "1"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
		inMap.put("CUST_ID_VALUE", outPhoneNo);
		inMap.put("Header", inDTO.getHeader());
		inMap.put("TOTAL_FEE", transFee);
		log.info("输出报文：------>"+inMap.toString());
		preOrder.sendData2(inMap);
		
		//转入账户同步营业日报、统一接触、报表库
		List<Map<String, Object>> keysList1 = new ArrayList<Map<String, Object>>(); // 同步报表库数据List
		Map<String, Object> paymentKey1 = new HashMap<String, Object>();
		paymentKey1.put("YEAR_MONTH", curTime.substring(0, 6));
		paymentKey1.put("CONTRACT_NO", inContractNo);
		paymentKey1.put("PAY_SN", paySn);
		paymentKey1.put("ID_NO", inIdNo);
		paymentKey1.put("PAY_TYPE", transType.getTransTypes());
		paymentKey1.put("TABLE_NAME", "BAL_PAYMENT_INFO");
		paymentKey1.put("UPDATE_TYPE", "I");
		keysList1.add(paymentKey1);
		
		inMap =  new HashMap<String, Object>();
		inMap.put("PAY_SN", paySn);
		inMap.put("LOGIN_NO", loginNo);
		inMap.put("GROUP_ID", groupId);
		inMap.put("OP_CODE", opCode);
		inMap.put("PHONE_NO", inPhoneNo);
		inMap.put("BRAND_ID", inTransBaseInfo.getBrandId());
		inMap.put("BACK_FLAG", "0");
		inMap.put("OP_TIME", curTime);
		inMap.put("OP_NOTE", opNote);
		inMap.put("ACTION_ID", "1001");
		inMap.put("OLD_ACCEPT", paySn);
		inMap.put("KEYS_LIST", keysList1);
		inMap.put("REGION_ID", inTransBaseInfo.getRegionId());
		inMap.put("CUST_ID_TYPE", "1"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
		inMap.put("CUST_ID_VALUE", outPhoneNo);
		inMap.put("Header", inDTO.getHeader());
		inMap.put("TOTAL_FEE", transFee);
		log.info("输出报文：------>"+inMap.toString());
		preOrder.sendData2(inMap);		

		S8014CfmOutDTO outDTO = new S8014CfmOutDTO();
		outDTO.setPsySn(paySn);
		outDTO.setTotalDate(totalDate);

		log.info("-----------------> s8014Cfm_out = " + outDTO.toJson());

		return outDTO;
	}
	
	public OutDTO grpcfm(InDTO inParam){
		S8014GrpCfmInDTO inDto = (S8014GrpCfmInDTO)inParam;
		
		/* 获取当前日期 */
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String totalDate = curTime.substring(0, 8);
		String curYM = curTime.substring(0, 6);
		long jtContractNo = inDto.getJtContractNo();
		String phoneNo = inDto.getPhoneNo();
		long transFee = inDto.getTransFee();
		long transCount = inDto.getTransCount();
		long oneTransFee = inDto.getOneTransFee();
		String foreignSnStr = inDto.getForeignSn();
		long unitId = inDto.getUnitId();
		String transCountStr = String.valueOf(transCount);
		String oneTransFeeStr = String.valueOf(oneTransFee);
		String loginPhoneNo = inDto.getLoginPhoneNo();
		String payPath = inDto.getPayPath();
		String payMethod = inDto.getPayMethod();
		String loginNo = inDto.getLoginNo();
		String opCode = inDto.getOpCode();
		String groupId = inDto.getGroupId();
		String grpConNoStr = String.valueOf(jtContractNo);
		String opType = inDto.getOpType();
		String opNote  = inDto.getOpNote();
		ITransType transType = transFactory.createTransFactory("TransAccountGrp",true);
		
		//总金额如果为0，总金额=红包个数*单个红包金额
		if(transFee == 0){
			transFee = transCount * oneTransFee;
		}else if(transFee != transCount * oneTransFee){
			throw new BusiException(AcctMgrError.getErrorCode("8014", "00046"), "传入金额有误！");
		}
		
		//集团信息
		long grpUnitId = 0;
		long grpIdNo = 0;
		String grpPhoneNo = "";
		long grpCustId = 0;
		String unitName = "";
		String grpBrandId = "";
		String grpGroupId = "";
		String grpMark = "0";//集团产品转账限额标志：0：不能超过10万，1：可以超过10万
		
		/*转出账户信息*/
		UserInfoEntity grpInfo = user.getUserEntityByConNo(jtContractNo, true);
		ContractInfoEntity grpConInfo = account.getConInfo(jtContractNo);
		String contractattType = grpConInfo.getContractattType();
		grpIdNo = grpInfo.getIdNo();
		grpCustId = grpInfo.getCustId();
		grpPhoneNo = grpInfo.getPhoneNo();
		/*获取集团名称*/
		CustInfoEntity custInfoEnt = cust.getCustInfo(grpCustId, null);
		String grpCustName = custInfoEnt.getCustName();
		/*转入用户信息*/
		UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo,true); 
		long inContractNo  = userInfo.getContractNo();
		long inIdNo = userInfo.getIdNo();
		String inBrandId = userInfo.getBrandId();
		UserDetailEntity userDetailEnt = user.getUserdetailEntity(inIdNo);
		String runCode = userDetailEnt.getRunCode();
		
		/*转账金额大于0*/
		/*出账期间不允许转账*/
		/*获取集团信息*/
		GrpCustInfoEntity grpCustInfoEnt = cust.getGrpCustInfo(grpCustId, null);
		grpUnitId = grpCustInfoEnt.getUnitId();
		String grpUnitIdStr = String.valueOf(grpUnitId);
		
		//校验用户状态是否异常
		if(!(runCode.equals("A")||runCode.equals("B")||runCode.equals("C")||runCode.equals("O"))){
			throw new BusiException(AcctMgrError.getErrorCode("8014", "00039"), "用户状态异常！");
		}
		
		/*校验集团账号*/
		if(!contractattType.equals("1")||unitId != grpUnitId){
			throw new BusiException(AcctMgrError.getErrorCode("8014", "00040"), "非集团账户！");
		}
		//查询集团账户现金预存款
		long grpPrePay = balance.getSumBalacneByPayTypes(jtContractNo,"0");
		log.info("grpPrePay -->" + grpPrePay);
		if(grpPrePay < transFee){
			throw new BusiException(AcctMgrError.getErrorCode("8014", "00041"), "转账金额大于集团账户预存款！");
		}
		
		/*校验集团转账限额*/
		if((grpMark.equals("0"))){
			long grpTransFee = record.getMonthTransFee(jtContractNo);
			long monthTransFee = transFee  + grpTransFee;
			
			if(monthTransFee > 9999999){
				throw new BaseException(AcctMgrError.getErrorCode("8014", "00023"),"月转账超出转账限额，不允许转账！");
			}
		}
		
		/* 转入账户基本信息查询 */
		PayUserBaseEntity inTransBaseInfo= getUserBaseInfo(phoneNo,0, true, inDto.getProvinceId());
		/*转出账户基本信息查询*/
		PayUserBaseEntity  outTransBaseInfo = getUserBaseInfo(grpPhoneNo, jtContractNo, true, inDto.getProvinceId());
		outTransBaseInfo.setNetFlag(true);
		
		/*入账实体设值*/
		PayBookEntity bookIn = new PayBookEntity();
		bookIn.setBeginTime(curTime);
		bookIn.setForeignSn(foreignSnStr);
		bookIn.setGroupId(groupId);
		bookIn.setLoginNo(loginNo);
		bookIn.setOpCode(opCode);
		bookIn.setOpNote(opNote);
		bookIn.setPayFee(transFee);
		bookIn.setPayMethod("A");
		bookIn.setPayPath(payPath);
		bookIn.setForeignTime(curTime);
		bookIn.setFactorOne(transCountStr);
		bookIn.setFactorTwo(loginPhoneNo);
		bookIn.setFactorThree(oneTransFeeStr);
		bookIn.setFactorFour(grpUnitIdStr);
		bookIn.setTotalDate(Integer.parseInt(totalDate));
		bookIn.setYearMonth(Long.parseLong(curYM));
		
		Map<String,Object> inTransCfmMap = new HashMap<String, Object>();
		safeAddToMap(inTransCfmMap, "Header", inDto.getHeader());
		safeAddToMap(inTransCfmMap, "TRANS_IN", inTransBaseInfo);  //转入账户基本信息
		safeAddToMap(inTransCfmMap, "TRANS_OUT", outTransBaseInfo); //转出账户基本信息
		safeAddToMap(inTransCfmMap, "BOOK_IN", bookIn); //入账实体
		safeAddToMap(inTransCfmMap, "OP_TYPE", opType); //转账类型
		safeAddToMap(inTransCfmMap, "TRANS_TYPE_OBJ", transType); //转账类型实例化对象
		
		//管理员配置金额限额
		if(opType.equals("HFHBTrans")){
			String monitor = inDto.getMonitor();
			if(monitor.equals("1")){
				Map<String,Object> ruleNumMap = new HashMap<String,Object>();
				ruleNumMap.put("UNIT_ID", unitId);
				ruleNumMap.put("JT_CONTRACT_NO", jtContractNo);
				ruleNumMap.put("OPER_PHONE", loginPhoneNo);
				long ruleNum = balance.getTransFeeLimitNum(ruleNumMap);
				if(ruleNum > 0 && opCode.equals("8014")){
					ruleNumMap.put("YMD", totalDate);
					ruleNumMap.put("YMD", totalDate);
					long realRuleNum = balance.getTransFeeLimitNum(ruleNumMap);
					if(realRuleNum == 0){
						throw new BaseException(AcctMgrError.getErrorCode("8014", "00042"),"您所在的集团设置的话费包分配规则已到期,您无法进行赠送操作,请联系您所在的集团话费包管理员设置新的规则！");
					}else{
						Map<String,Object> limitListMap = new HashMap<String,Object>();
						limitListMap.put("UNIT_ID", unitId);
						limitListMap.put("JT_CONTRACT_NO", jtContractNo);
						limitListMap.put("OPER_PHONE", loginPhoneNo);
						limitListMap.put("YMD", totalDate);
						List<TransLimitEntity> transLimitList = balance.getTransLimit(limitListMap);
						TransLimitEntity transLimitEnt = transLimitList.get(0);
						long totalPayed = transLimitEnt.getTotalPayed();
						long limitPay = transLimitEnt.getLimitPay();
						long nowLimitPay = totalPayed + transFee;
						if(nowLimitPay > limitPay){
							throw new BaseException(AcctMgrError.getErrorCode("8014", "00043"),loginPhoneNo+"操作人员配置额度已到限额");
						}else{
							limitListMap.put("LIMIT_PAY", nowLimitPay);
							balance.upTransFeeLimit(limitListMap);
						}
					}
				}
			}
		}
		try {
			/*转账*/
			long paySn = payManage.transBalance(inTransCfmMap);
			
			/* 缴费用户冲销欠费 */
			inTransCfmMap = new HashMap<String, Object>();
			safeAddToMap(inTransCfmMap, "Header", inDto.getHeader());
			safeAddToMap(inTransCfmMap, "CONTRACT_NO", inContractNo);
			safeAddToMap(inTransCfmMap, "PAY_SN", paySn);
			safeAddToMap(inTransCfmMap, "PHONE_NO", phoneNo);
			safeAddToMap(inTransCfmMap, "LOGIN_NO", loginNo);
			safeAddToMap(inTransCfmMap, "OP_CODE", opCode);
			safeAddToMap(inTransCfmMap, "GROUP_ID", groupId);
			safeAddToMap(inTransCfmMap, "PAY_PATH", payPath);
			safeAddToMap(inTransCfmMap, "DELAY_FAVOUR_RATE", "1");
			writeOffer.doWriteOff(inTransCfmMap);
			
			/*缴费用户做开机*/
			payOpener.doConUserOpen(inDto.getHeader(), inTransBaseInfo, bookIn, inDto.getProvinceId());
			
			/* 转出号码：记录营业员操作日志 */
			LoginOprEntity outTransOpr = new LoginOprEntity();
			outTransOpr.setBrandId(grpBrandId);
			outTransOpr.setIdNo(grpIdNo);
			outTransOpr.setLoginGroup(groupId);
			outTransOpr.setLoginNo(loginNo);
			outTransOpr.setLoginSn(paySn);
			outTransOpr.setOpCode(opCode);
			outTransOpr.setOpTime(curTime);
			outTransOpr.setPayFee((-1) * transFee);
			outTransOpr.setPhoneNo(grpPhoneNo);
			outTransOpr.setRemark(opNote);
			outTransOpr.setPayType("");
			outTransOpr.setTotalDate(Long.parseLong(totalDate));
			record.saveLoginOpr(outTransOpr);

			/* 转入号码：记录营业员操作日志 */
			LoginOprEntity inTransOpr = new LoginOprEntity();
			inTransOpr.setBrandId(inBrandId);
			inTransOpr.setIdNo(inIdNo);
			inTransOpr.setLoginGroup(groupId);
			inTransOpr.setLoginNo(loginNo);
			inTransOpr.setLoginSn(paySn);
			inTransOpr.setOpCode(opCode);
			inTransOpr.setOpTime(curTime);
			inTransOpr.setPayFee(transFee);
			inTransOpr.setPhoneNo(phoneNo);
			inTransOpr.setRemark(opNote);
			inTransOpr.setPayType("");
			inTransOpr.setTotalDate(Long.parseLong(totalDate));
			record.saveLoginOpr(inTransOpr);
			
			/* 发送短信  */
			Map<String, Object> mapTmp = new HashMap<String, Object>();
			MBean inMessage = new MBean();
			inMessage.addBody("PHONE_NO", phoneNo);
			inMessage.addBody("LOGIN_NO", bookIn.getLoginNo());;
			inMessage.addBody("OP_CODE", bookIn.getOpCode());
			inMessage.addBody("CHECK_FLAG", true);
			if(opType.equals("HFHBTrans")){ 			//话费红包转账
				//判断是否发送短信
				boolean sendMessage = user.isTrafficFlux(grpIdNo, "23B253", "1");
				if(sendMessage){
					UsersvcAttrEntity userSvcAttrEnt1 = user.getUsersvcAttr(grpIdNo,"23B250");
					String custPhone = userSvcAttrEnt1.getAttrValue();
					UsersvcAttrEntity userSvcAttrEnt2 = user.getUsersvcAttr(grpIdNo,"23B251");
					String activeName = userSvcAttrEnt2.getAttrValue();
					mapTmp.put("phone_no", phoneNo);
					mapTmp.put("unit_name", grpCustName);
					mapTmp.put("buffer_name",activeName);
					mapTmp.put("trans_count", transCount);
					mapTmp.put("trans_money", oneTransFee);
					mapTmp.put("contact_phone", custPhone);
					inMessage.addBody("TEMPLATE_ID", "BOSS_3424");
					inMessage.addBody("DATA", mapTmp);
					
					log.info("发送短信内容：" + inMessage.toString());
					//shortMessage.sendSmsMsg(inMessage, 1);
				}else{
					UsersvcAttrEntity userSvcAttrEnt1 = user.getUsersvcAttr(grpIdNo,"23B250");
					String custPhone = userSvcAttrEnt1.getAttrValue();
					mapTmp.put("phone_no", phoneNo);
					mapTmp.put("pay_money", transFee);
					mapTmp.put("contact_phone", custPhone);
					inMessage.addBody("TEMPLATE_ID", "BOSS_3536");
					inMessage.addBody("DATA", mapTmp);
					
					log.info("发送短信内容：" + inMessage.toString());
					//shortMessage.sendSmsMsg(inMessage, 1);
				}
			}else if(opType.equals("HBCZTrans")){ 			//红包充值转账
				String attrValue = "";
				UsersvcAttrEntity userSvcAttrEnt3 = user.getUsersvcAttr(grpIdNo,"23B582");
				if(userSvcAttrEnt3 != null){
					attrValue = userSvcAttrEnt3.getAttrValue();
				}else{
					attrValue = "1";
				}
				if(attrValue.equals("1")){
					UsersvcAttrEntity userSvcAttrEnt1 = user.getUsersvcAttr(grpIdNo,"23B579");
					String custPhone = userSvcAttrEnt1.getAttrValue();
					UsersvcAttrEntity userSvcAttrEnt2 = user.getUsersvcAttr(grpIdNo,"23B580");
					String activeName = userSvcAttrEnt2.getAttrValue();
					mapTmp.put("phone_no", phoneNo);
					mapTmp.put("pay_money", ValueUtils.transFenToYuan(transFee));
					mapTmp.put("active_note", activeName);
					mapTmp.put("cust_phone", custPhone);
					inMessage.addBody("TEMPLATE_ID", "311200801412");
					inMessage.addBody("DATA", mapTmp);
					
					String flag1 = control.getPubCodeValue(2011, "DXFS", null);  // 0:直接发送 1:插入短信接口临时表 2：外系统有问题，直接不发送短信
					if(flag1.equals("0")){
						inMessage.addBody("SEND_FLAG", 0);
						log.info("发送短信内容：" + inMessage.toString());
						shortMessage.sendSmsMsg(inMessage, 1);
					}else if(flag1.equals("1")){
						inMessage.addBody("SEND_FLAG", 1);
						log.info("发送短信内容：" + inMessage.toString());
						shortMessage.sendSmsMsg(inMessage, 1);
					}
				}else{
					log.info("未发送短信，短信标识---->"+attrValue);
				}
			}
			
		} catch (BusiException e) {

			e.getErrMsg();
			e.printStackTrace();
			payManage.rollback();
			/*获取失败转账流水*/
			long tansSn = control.getSequence("SEQ_PAY_SN");
			bookIn.setPaySn(tansSn);
			
			Map<String,Object> inMap = new HashMap<String,Object>();
			inMap.put("OP_TYPE", "TransAccountGrp");
			balance.saveTransFeeErrInfo(outTransBaseInfo, inTransBaseInfo, bookIn, inMap);
			payManage.commit();
			
			/*抛出转账失败信息信息*/
			String errorNo = e.getErrCode();
			String errorMsg = e.getErrMsg();
			throw new BusiException(errorNo,errorMsg);
		}
		
		
		
		S8014GrpCfmOutDTO outDto =  new S8014GrpCfmOutDTO();
		return outDto;
	}

	/* 在网、离网判断 */
	public boolean isOnNet() {
		if ("1".equals(getOnNetFlag())) { // 在网
			return true;
		} else { // 离网
			return false;
		}
	}

	/* 设置在网离网标识 */
	private void setOnNetFlag(String _onNetFlag) {
		onNetFlag = _onNetFlag;
	}

	/* 获取在网离网标识 */
	protected String getOnNetFlag() {
		return onNetFlag;
	}
	
	/* 获取用户、客户基本信息 */
	private TransOutEntity getBaseInfo(String inPhoneNo, long inContractNo) {
		String phoneNo = inPhoneNo;
		long contractNo = inContractNo;
		
		log.info("getBaseInfo-->phoneNo:"+phoneNo+",contractNo"+ contractNo);
		
		long custId = 0;
		String openTime = "";
		String runTime = "";
		String accountType = "";
		String contractattType = "";
		String brandId = "";
		if (isOnNet()) {
			/* 获取用户信息 */
			UserInfoEntity  userEntity = user.getUserInfo(phoneNo);
			custId = userEntity.getCustId();
			if (contractNo == 0) {
				contractNo = userEntity.getContractNo();
			}
			openTime = userEntity.getOpenTime();
			runTime = userEntity.getRunTime();
			brandId = userEntity.getBrandId();
			
			/*获取账户信息*/
			ContractInfoEntity accountEnt = account.getConInfo(inContractNo);
			accountType = accountEnt.getAccountType();
			contractattType = accountEnt.getContractattType();
		} else {
			/** 离网用户信息查询 */
			List<UserDeadEntity> userDeadList = user.getUserdeadEntity(phoneNo, null, contractNo);
			custId = userDeadList.get(0).getCustId();
			openTime = userDeadList.get(0).getOpenTime();
					
			/* 获取账户信息 */
			ContractDeadInfoEntity accountDeadEnt = account.getConDeadInfo(contractNo);
			accountType = accountDeadEnt.getAccountType();
			contractattType = accountDeadEnt.getContractattType();
		}
		
		/* 取客户名称 */
		CustInfoEntity custEnt = cust.getCustInfo(custId, null);
		String conEncrypName = custEnt.getBlurCustName();
		
		// 出参信息
		TransOutEntity baseInfo = new TransOutEntity();
		baseInfo.setContractNo(contractNo);
		baseInfo.setCustName(conEncrypName);
		baseInfo.setExpireTime(runTime);
		baseInfo.setOpenTime(openTime);
		baseInfo.setPhoneNo(phoneNo);
		baseInfo.setAccountType(accountType);
		baseInfo.setContractattType(contractattType);
		baseInfo.setBrandId(brandId);
		
		return baseInfo;
	}
	
	/* 获取用户基本信息 */
	private PayUserBaseEntity getUserBaseInfo(String inPhoneNo, long inContractNo, boolean isTransInFlag, String provinceId) {
		String phoneNo = inPhoneNo;
		long contractNo = inContractNo;
		String conGroup="";
		
		log.info("getUserBaseInfo-->phoneNo:"+phoneNo+",contractNo"+ contractNo);
		
		long idNo = 0;
		String brandId = "";
		long custId = 0;

		if (isOnNet() || isTransInFlag) {
			/* 获取用户信息 */
			UserInfoEntity  userEntity = user.getUserInfo(phoneNo);
			idNo = userEntity.getIdNo();
			if (contractNo == 0) {
				contractNo = userEntity.getContractNo();
			}
			brandId = userEntity.getBrandId();
			custId = userEntity.getCustId();
			
			/*获取账户信息*/
			ContractInfoEntity conEntity = account.getConInfo(contractNo);
			conGroup=conEntity.getGroupId();
		} else {
			/** 离网用户信息查询 */
			List<UserDeadEntity> userDeadList = user.getUserdeadEntity(phoneNo, null, contractNo);
			idNo = userDeadList.get(0).getIdNo();
			custId = userDeadList.get(0).getCustId();
			
			/*获取离网用户品牌信息*/
			brandId = "XX";
			
			/* 获取账户信息 */
			ContractDeadInfoEntity conEntity = account.getConDeadInfo(contractNo);
			conGroup=conEntity.getGroupId();
		}

		//查询账户地市归属信息
		ChngroupRelEntity groupEntity = group.getRegionDistinct(conGroup, "2", provinceId);
		String regionId = groupEntity.getRegionCode();
		
		// 出参信息
		PayUserBaseEntity userBaseInfo = new PayUserBaseEntity();
		userBaseInfo.setBrandId(brandId);
		userBaseInfo.setCustId(custId);
		userBaseInfo.setContractNo(contractNo);
		userBaseInfo.setIdNo(idNo);
		userBaseInfo.setPhoneNo(phoneNo);
		userBaseInfo.setRegionId(regionId);
		userBaseInfo.setUserGroupId(conGroup);
		
		return userBaseInfo;
	}

	/* 获取在网、离网余额信息*/
	protected long getRemainFeeInfo(long idNo, long inContractNo) {
		/* 取余额-->预存-（库内+内存欠费+滞纳金）*/
		long contractNo = inContractNo;
		OutFeeData feeDate = null;
		long remianFee = 0;
		if (isOnNet()) {
			feeDate = remainFee.getConRemainFee(contractNo);
		} else {
			feeDate = remainFee.getDeadConRemainFee(idNo, contractNo, 1.00);
		}
		
		if (feeDate != null) {
			remianFee = feeDate.getRemainFee();
		}

		return remianFee;
	}

	/**
	 * @param account
	 *            the account to set
	 */
	public void setAccount(IAccount account) {
		this.account = account;
	}

	/**
	 * @param login
	 *            the login to set
	 */
	public void setLogin(ILogin login) {
		this.login = login;
	}

	/**
	 * @param group
	 *            the group to set
	 */
	public void setGroup(IGroup group) {
		this.group = group;
	}

	/**
	 * @param control
	 *            the control to set
	 */
	public void setControl(IControl control) {
		this.control = control;
	}

	/**
	 * @param payManage
	 *            the acctBook to set
	 */
	public void setAcctBook(IPayManage payManage) {
		this.payManage = payManage;
	}

	/**
	 * @param user
	 *            the user to set
	 */
	public void setUser(IUser user) {
		this.user = user;
	}

	/**
	 * @param cust
	 *            the cust to set
	 */
	public void setCust(ICust cust) {
		this.cust = cust;
	}

	/**
	 * @param oweBill
	 *            the oweBill to set
	 */
	public void setOweBill(IOweBill oweBill) {
		this.oweBill = oweBill;
	}

	/**
	 * @return the account
	 */
	public IAccount getAccount() {
		return account;
	}

	/**
	 * @return the login
	 */
	public ILogin getLogin() {
		return login;
	}

	/**
	 * @return the group
	 */
	public IGroup getGroup() {
		return group;
	}

	/**
	 * @return the control
	 */
	public IControl getControl() {
		return control;
	}

	/**
	 * @return the acctBook
	 */
	public IPayManage getAcctBook() {
		return payManage;
	}

	/**
	 * @return the remainFee
	 */
	public IRemainFee getRemainFee() {
		return remainFee;
	}

	/**
	 * @param remainFee
	 *            the remainFee to set
	 */
	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}

	/**
	 * @return the user
	 */
	public IUser getUser() {
		return user;
	}

	/**
	 * @return the cust
	 */
	public ICust getCust() {
		return cust;
	}

	/**
	 * @return the oweBill
	 */
	public IOweBill getOweBill() {
		return oweBill;
	}

	/**
	 * @return the record
	 */
	public IRecord getRecord() {
		return record;
	}

	/**
	 * @param record
	 *            the record to set
	 */
	public void setRecord(IRecord record) {
		this.record = record;
	}

	/**
	 * @return the writeOffer
	 */
	public IWriteOffer getWriteOffer() {
		return writeOffer;
	}

	/**
	 * @param writeOffer
	 *            the writeOffer to set
	 */
	public void setWriteOffer(IWriteOffer writeOffer) {
		this.writeOffer = writeOffer;
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

	/**
	 * @return the transFactory
	 */
	public TransFactory getTransFactory() {
		return transFactory;
	}

	/**
	 * @param transFactory the transFactory to set
	 */
	public void setTransFactory(TransFactory transFactory) {
		this.transFactory = transFactory;
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
	 * @return the payOpener
	 */
	public IPayOpener getPayOpener() {
		return payOpener;
	}

	/**
	 * @param payOpener the payOpener to set
	 */
	public void setPayOpener(IPayOpener payOpener) {
		this.payOpener = payOpener;
	}

	/**
	 * @return the shortMessage
	 */
	public IShortMessage getShortMessage() {
		return shortMessage;
	}

	/**
	 * @param shortMessage the shortMessage to set
	 */
	public void setShortMessage(IShortMessage shortMessage) {
		this.shortMessage = shortMessage;
	}

}
