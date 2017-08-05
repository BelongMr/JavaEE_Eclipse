package com.sitech.acctmgr.atom.impl.adj;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.adj.inter.IAdjCommon;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayOpener;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.busi.pay.inter.IWriteOffer;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.adj.AdjBIllEntity;
import com.sitech.acctmgr.atom.domains.adj.AdjBackMoneyInitEntity;
import com.sitech.acctmgr.atom.domains.adj.AdjExtendEntity;
import com.sitech.acctmgr.atom.domains.adj.ComplainAdjQryBatchEntity;
import com.sitech.acctmgr.atom.domains.adj.ComplainAdjQryEntity;
import com.sitech.acctmgr.atom.domains.adj.SpInfoEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.GroupEntity;
import com.sitech.acctmgr.atom.domains.base.LoginBaseEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.domains.query.GroupInfoEntity;
import com.sitech.acctmgr.atom.domains.query.RefundEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserDeadEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserPrcEntity;
import com.sitech.acctmgr.atom.dto.adj.S8041BackCfmInDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041BackCfmOutDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041BackInitInDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041BackInitOutDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041CfmInDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041CfmOutDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041GetSPFlagInDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041GetSPFlagOutDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041InitInDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041InitOutDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041QryBatchInDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041QryBatchOutDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041QryInDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041QryOutDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041SpInDTO;
import com.sitech.acctmgr.atom.dto.adj.S8041SpOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAdj;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IProd;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgr.inter.adj.I8041;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
*
* <p>Title:   </p>
* <p>Description:   </p>
* <p>Copyright: Copyright (c) 2014</p>
* <p>Company: SI-TECH </p>
* @author liuyc_billing
* @version 1.0
*/

@ParamTypes({ @ParamType(m = "init", c = S8041InitInDTO.class, oc = S8041InitOutDTO.class),
    		  @ParamType(m = "cfm", c = S8041CfmInDTO.class, oc = S8041CfmOutDTO.class),
              @ParamType(m = "getSpList", c = S8041SpInDTO.class, oc = S8041SpOutDTO.class),
              @ParamType(m = "backInit", c = S8041BackInitInDTO.class, oc = S8041BackInitOutDTO.class),
              @ParamType(m = "backCfm", c = S8041BackCfmInDTO.class, oc = S8041BackCfmOutDTO.class),
              @ParamType(m = "qryInfo", c = S8041QryInDTO.class, oc = S8041QryOutDTO.class),
              @ParamType(m = "getSPFlag", c = S8041GetSPFlagInDTO.class, oc = S8041GetSPFlagOutDTO.class),
              @ParamType(m = "qryBatchInfo", c = S8041QryBatchInDTO.class, oc = S8041QryBatchOutDTO.class)})
public class S8041 extends AcctMgrBaseService implements I8041 {
	
	private IControl control;
	private IUser user;
	private ILogin login;
	private IRecord record;
	private IAdjCommon adjCommon;
	private IWriteOffer writeOffer;
	private IPayOpener payOpener;
	private IAdj adj;
	private IProd prod;
	private IPayManage payManage;
	private IGroup group;
	private IRemainFee remainFee;
	protected IPreOrder preOrder;

	public IRemainFee getRemainFee() {
		return remainFee;
	}

	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}

	/* (non-Javadoc)
	 * @see com.sitech.acctmgr.inter.adj.I8041#init(com.sitech.jcfx.dt.in.InDTO)
	 */
	@Override
	public OutDTO init(InDTO inParam) {
		
		S8041InitInDTO inDto=(S8041InitInDTO)inParam;
		log.info("---->8041init_in : "+inDto.getMbean());
		
		String loginNo=inDto.getLoginNo();
		String groupId=inDto.getGroupId();
		String opCode=inDto.getOpCode();
		String provinceId=inDto.getProvinceId();
		//String phoneNo=inDto.getPhoneNo();
		
		//工号归属信息验证
		if(StringUtils.isEmptyOrNull(groupId)){
				groupId = login.getLoginInfo(loginNo, provinceId).getGroupId();
			}
		
		//获取计费原因
		List<PubCodeDictEntity> adjCalculateFeeList=null;
		adjCalculateFeeList=control.getPubCodeList(2413L, null, null, "1");
		List<AdjBackMoneyInitEntity> adjBillTypeList=new ArrayList<AdjBackMoneyInitEntity>();
		for(PubCodeDictEntity adjPubBillList:adjCalculateFeeList){
			AdjBackMoneyInitEntity adjBackMoneyInit =new AdjBackMoneyInitEntity();
			adjBackMoneyInit.setBillTypeName(adjPubBillList.getCodeValue());
			adjBackMoneyInit.setBillTypeId(adjPubBillList.getCodeId());
			adjBillTypeList.add(adjBackMoneyInit);
		}
		
		//获取核减类型
		List<PubCodeDictEntity> adjSubList=null;
		adjSubList=control.getPubCodeList(2401L, null, null, "1");
		List<AdjBackMoneyInitEntity> adjSubTypeList=new ArrayList<AdjBackMoneyInitEntity>();
		for(PubCodeDictEntity adjPubSubList:adjSubList){
			AdjBackMoneyInitEntity adjBackMoneyInit =new AdjBackMoneyInitEntity();
			adjBackMoneyInit.setSubTypeName(adjPubSubList.getCodeValue());
			adjBackMoneyInit.setSubTypeId(adjPubSubList.getCodeId());
			adjSubTypeList.add(adjBackMoneyInit);
		}
		 
		//组装出参
		S8041InitOutDTO outDto=new S8041InitOutDTO();
		
		outDto.setAdjBillTypeList(adjBillTypeList);
		outDto.setAdjSubTypeList(adjSubTypeList);
		
		log.info("---->804init_out : "+outDto.toJson());
		return outDto;
	}
	
	/* (non-Javadoc)
	 * @see com.sitech.acctmgr.inter.adj.I8041#getSPFlag(com.sitech.jcfx.dt.in.InDTO)
	 */
	@Override
	public OutDTO getSPFlag(InDTO inParam) {
		S8041GetSPFlagInDTO inDto=(S8041GetSPFlagInDTO)inParam;
		String codeId=inDto.getReasonId();
		String reasonFlag=inDto.getReasonFlag();
		String opCode=inDto.getOpCode();
		String loginNo = inDto.getLoginNo();
		String groupId = inDto.getGroupId();
		String provinceId = inDto.getProvinceId();
		log.info("---->8041getSPFlag_in : "+inDto.getMbean());

		//工号归属信息验证
		if(StringUtils.isEmptyOrNull(groupId)){
			groupId = login.getLoginInfo(loginNo, provinceId).getGroupId();
		}
		
		//获取营业厅上级组织代码groupId
		String parentGroupId = group.getRegionDistinct(groupId, "2", provinceId).getParentGroupId();
		
		//获取status
		List<PubCodeDictEntity> adjReasonList = new ArrayList<PubCodeDictEntity>();
		if(StringUtils.isNotEmptyOrNull(codeId)){
			if(reasonFlag.equals("1")){
				adjReasonList=adj.getReaosnCodeList(2410L, null, parentGroupId, null, codeId,null);
			}
			if(reasonFlag.equals("2")){
				adjReasonList=adj.getReaosnCodeList(2411L, null, parentGroupId, null, codeId,null);
			}
			if(reasonFlag.equals("3")){
				adjReasonList=adj.getReaosnCodeList(2412L, null, parentGroupId, null, codeId,null);
			}
		}
		String spFlag="1";
		
		if(adjReasonList.size()>0){
			spFlag=adjReasonList.get(0).getStatus();
		}
		
		
		//组织出参
		S8041GetSPFlagOutDTO outDto=new S8041GetSPFlagOutDTO();
		outDto.setSpFlag(spFlag);
		log.info("---->8041getSPFlag_out : "+outDto.toJson());
		return outDto;
	}

	/* (non-Javadoc)
	 * @see com.sitech.acctmgr.inter.adj.I8041#cfm(com.sitech.jcfx.dt.in.InDTO)
	 */
	@Override
	public OutDTO cfm(InDTO inParam) {
		
		S8041CfmInDTO  inDto=  (S8041CfmInDTO) inParam;
		log.info("---->8041cfm_in : "+inDto.getMbean());
				
		//获取入参信息
		String loginNo = inDto.getLoginNo();
		String provinceId = inDto.getProvinceId();
		String groupId = inDto.getGroupId();
		long backMoney = inDto.getBackMoney();  //退费金额
		long compMoney = inDto.getCompMoney();  //赔偿金额
		String backType = inDto.getBackType();   //补偿类型  1：单倍  2: 双倍
		String phoneNo = inDto.getPhoneNo();
		String opCode = inDto.getOpCode();
		String remark = inDto.getRemark();
		if(StringUtils.isEmptyOrNull(remark)){
			remark="无";
		}
		String errSerial = inDto.getErrSerial();
		String adjReason = inDto.getAdjReason();
		String spDetailBusiness =inDto.getSpDetailBusiness();
		String spDetailEmp=inDto.getSpDetailEmp();
		String spFlag=inDto.getSpFlag();
		String adjSubType=inDto.getAdjSubType();
		String adjBillType=inDto.getAdjBillType();
		String checkTime=inDto.getCheckTime();
		String lastTime=inDto.getLastTime();
		String unitPrice=inDto.getUnitPrice();
		String quantity=inDto.getQuantity();
		String returnTypeFlag=inDto.getReturnTypeFlag();
		String ivrFlag=inDto.getIvrFlag();
		String spName=inDto.getSpDetailEmpName();
		String operName=inDto.getSpDetailBusinessName();
		String beginTime = inDto.getBeginTime();
		String endTime = inDto.getEndTime();
		String backBusyCode = inDto.getBackBusyCode();
		String backBusyName = inDto.getBackBusyName();
		String returnType="未知";
		String pageFlag = inDto.getPageFlag();
		if(returnTypeFlag.equals("1")){
			returnType="退预存";
		}else{
			returnType="退现金";
		}
	
		//判断退费金额是否超过10万元，超过10万元不允许退费
		if(backMoney > 10000000 || compMoney > 10000000)
		{
			throw new BaseException(AcctMgrError.getErrorCode("8041", "00001"),"退费金额超过10万，不允许退费！");
		}
		
		
		//判断工号限制,8041退费分别进行判断限制
		List<PubCodeDictEntity> pubList = null;
		List loginNoList = new ArrayList();
		if(loginNo.startsWith("80") && pageFlag.equals("0")){
			pubList = control.getPubCodeList(2419L, null, null, null);
			for(PubCodeDictEntity pubCodeDictEntity:pubList){
				loginNoList.add(pubCodeDictEntity.getCodeValue());
			}
			if(loginNoList.contains(StringUtils.trim(loginNo)) && (backMoney>30000 || compMoney>30000)){
				//该表中有记录，退费限额300元
				throw new BaseException(AcctMgrError.getErrorCode("8041", "00002"),"退费金额超过300元，不允许退费！");
			}else if(!loginNoList.contains(StringUtils.trim(loginNo)) && (backMoney>15000 || compMoney>15000)){
				//该表中无记录，退费限额150元
				throw new BaseException(AcctMgrError.getErrorCode("8041", "00003"),"退费金额超过150元，不允许退费！");
			}
		}
		

		//GPRS退费或梦网退费
		List loginNoGPRSList = new ArrayList();
		if((loginNo.startsWith("80") && pageFlag.equals("1")) || (loginNo.startsWith("80") && pageFlag.equals("2"))){
			pubList = control.getPubCodeList(2420L, null, null, null);
			for(PubCodeDictEntity pubCodeDictEntity:pubList){
				loginNoGPRSList.add(StringUtils.trim(pubCodeDictEntity.getCodeValue()));
			}
			if(loginNoGPRSList.contains(StringUtils.trim(loginNo)) && (backMoney>30000 || compMoney>30000)){
				//该表中有记录，退费限额300元
				throw new BaseException(AcctMgrError.getErrorCode("8041", "00002"),"退费金额超过300元，不允许退费！");
			}else if(!loginNoGPRSList.contains(StringUtils.trim(loginNo)) && (backMoney>15000 || compMoney>15000)){
				//该表中无记录，退费限额150元
				throw new BaseException(AcctMgrError.getErrorCode("8041", "00003"),"退费金额超过150元，不允许退费！");
			}
		}
		
		//获取当前时间
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		int curYM = Integer.parseInt(curTime.substring(0, 6));
		int totalDate = Integer.parseInt(curTime.substring(0, 8));
		
		//查询在网用户信息
		long contractNo=0L;	
		UserInfoEntity userEnt = user.getUserInfo(phoneNo);
		contractNo=userEnt.getContractNo();
		String brandId =userEnt.getBrandId();
		
		
		//8041退费和梦网退费需要做物联网号码限制
		if(pageFlag.equals("0") || pageFlag.equals("2")){
			if(brandId.equals("2330PB")){
				//物联网号码不允许退费
				throw new BaseException(AcctMgrError.getErrorCode("8041", "00004"),"物联网号码不允许进行退费操作！");
			}
		}
		
		
		//如果是梦网退费，进行验证SP业务是否正确
		if(pageFlag.equals("2")){
			List<SpInfoEntity> userSPInfoList = new ArrayList<SpInfoEntity>();
			Map inMap = new HashMap();
			inMap.put("PHONE_NO", phoneNo);
			inMap.put("SP_ID", spDetailEmp);
			userSPInfoList=prod.qUserSPPdPrcInfo(inMap);
			if(userSPInfoList.size()==0){
				throw new BaseException(AcctMgrError.getErrorCode("8041", "00011"),"该用户没有该SP业务，请输入正确的SP信息！");
			}
		}
	
				
		//用户基本信息实体设值
		PayUserBaseEntity userBase = new PayUserBaseEntity();
		userBase.setBrandId(userEnt.getBrandId());
		userBase.setContractNo(contractNo);
		userBase.setIdNo(userEnt.getIdNo());
		userBase.setPhoneNo(phoneNo);
		userBase.setUserGroupId(userEnt.getGroupId());
		
		/*缴费用户归属地市*/
        ChngroupRelEntity groupEntity = group.getRegionDistinct(userBase.getUserGroupId(), "2", provinceId);
        String regionId = groupEntity.getRegionCode();
		
		
		//查询工号信息
		LoginEntity loginEnt = login.getLoginInfo(loginNo, provinceId);
		groupId = loginEnt.getGroupId();
		int powerRight = loginEnt.getPowerRight();
		String loginType = loginEnt.getLoginType();
		
		//查询工号是否为省级工号,省级工号需分省退费
		List<PubCodeDictEntity> pubProvinceList = new ArrayList<PubCodeDictEntity>();

		pubProvinceList=control.getPubCodeList(2415L, null, null,null,loginNo);
		//判断省级工号，并进行转换
		if(pubProvinceList.size()>0){
			List<PubCodeDictEntity> pubRegionList = new ArrayList<PubCodeDictEntity>();
			
			//获取用户营业厅上级组织代码（即地市代码）
			String groupRegion = group.getRegionDistinct(userEnt.getGroupId(), "2", provinceId).getParentGroupId();
			pubProvinceList=control.getPubCodeList(2414L, null, groupRegion,null);
			
			//转换工号失败
			if(pubRegionList.size()==0){
				throw new BaseException(AcctMgrError.getErrorCode("8041", "00005"),"查询转换工号出错！");
			}else{
				loginNo=pubRegionList.get(0).getCodeValue();
			}
		}
		
		// 获取退费流水
		long paySn = control.getSequence("SEQ_PAY_SN");
		log.info("--------paySn->"+paySn);
		
		//TODO 退费账目项字符串组装
		String payDetail = "";
		long tempBackFee = 0;
		String adjType = "";
		if(backType.equals("1")){  //单倍补偿
			tempBackFee = 0 - compMoney;
			adjType = "00";  //单倍退预存
		}else if(backType.equals("2")){  //双倍补偿
			//tempBackFee = (0 - tempBackFee)/2;
			tempBackFee = (0 - compMoney)/2;
			//adjType = "01";  //双倍退预存
			adjType = "02";  //双倍退预存退现金
		}
		
		//一键退费时候账目项只有0B200000zk一种
		if(brandId.equals("kf") && !pageFlag.equals("3"))
		{
			//老系统账目项 payDetail = "0Y|gi|%s|#";
			payDetail = "0Y200000gi|" +tempBackFee+ "#";
		}	
		else if(brandId.equals("kg") && !pageFlag.equals("3"))
		{
			//老系统账目项payDetail = "0Y|gk|%s|#";
			payDetail = "0Y200000gk|" +tempBackFee+ "#";
		}
		else if(brandId.equals("kd") && !pageFlag.equals("3"))
		{
			//老系统账目项 payDetail = "0Y|gl|%s|#";
			payDetail = "0Y200000gl|" +tempBackFee+ "#";
		}	
		else
		{
			//老系统账目项 payDetail = "0B|zk|%s|#";
			payDetail = "0B200000zk|" +tempBackFee+ "#";
		}
		
		//状态字段初始化
		String payedStatus="2";  //退费时负补收，payedStatus="2"
		log.info("-------->sPayDetail-"+payDetail);
		
		//补收账单实体设值
		AdjBIllEntity billEnt = new AdjBIllEntity();
		billEnt.setBillCycle(curYM);
		billEnt.setContractNo(contractNo);
		billEnt.setCustId(userEnt.getCustId());
		billEnt.setCycleType("0");
		billEnt.setGroupId(groupId);
		billEnt.setIdNo(userEnt.getIdNo());
		billEnt.setNaturalMonth(curYM);
		billEnt.setStatus(payedStatus);
		billEnt.setPhoneNo(Long.parseLong(phoneNo));
		
		//补收账单实体信息以外补收信息实体设置
		AdjExtendEntity adjExtendEnt = new AdjExtendEntity();
		adjExtendEnt.setAdjFlag("0");
		adjExtendEnt.setLoginNo(loginNo);
		adjExtendEnt.setOffFlag("");
		adjExtendEnt.setOpCode(opCode);
		adjExtendEnt.setOpSn(paySn);
		adjExtendEnt.setRemark(remark);
		adjExtendEnt.setAdjReason(adjReason);
		adjExtendEnt.setAdjType(adjType);
		adjExtendEnt.setErrSerial(errSerial);
		adjExtendEnt.setBeginTime(beginTime);
		adjExtendEnt.setEndTime(endTime);
		adjExtendEnt.setOperCode(backBusyCode);
		adjExtendEnt.setOperName(backBusyName);		
		
		//入账实体设值
		PayBookEntity inBook =  new PayBookEntity();
		inBook.setGroupId(groupId);
		inBook.setLoginNo(loginNo);
		inBook.setOpCode(opCode);
		inBook.setOpNote(remark);
		inBook.setPayFee(tempBackFee);
		inBook.setPayType("0");
		inBook.setBeginTime(curTime);
		inBook.setTotalDate(totalDate);
		inBook.setYearMonth(curYM);
		inBook.setPaySn(paySn);
		inBook.setOriginalSn(paySn);
		inBook.setStatus("0");
		//判断是否是SP退费
		if(spFlag.equals("2")){
					adjExtendEnt.setSpFlag(true);
		}else{
					adjExtendEnt.setSpFlag(false);
		}
		//解析账目项字符串,补收核心函数
		Map<String, Object> inAdjMap = new HashMap<String, Object>();
		inAdjMap.put("Header", inDto.getHeader());
		inAdjMap.put("PAY_DETAIL", payDetail);
		inAdjMap.put("PAY_BOOK_ENTITY", inBook);
		inAdjMap.put("ADJ_BILL_ENTITY", billEnt);
		inAdjMap.put("PAY_USER_BASE_ENTITY", userBase);
		inAdjMap.put("ADJ_EXTEND_ENTITY", adjExtendEnt);
		inAdjMap.put("PROVINCE_ID", provinceId);
		
		
		//若入SP退费信息表时需要
		inAdjMap.put("SP_CODE", spDetailEmp);
		inAdjMap.put("OPER_CODE", spDetailBusiness);
		inAdjMap.put("CHECK_TYPE", adjSubType);
		inAdjMap.put("BILL_TYPE", adjBillType);
		inAdjMap.put("LAST_TIME", lastTime);
		inAdjMap.put("CHECK_TIME", checkTime);
		inAdjMap.put("UNIT_PRICE", unitPrice);
		inAdjMap.put("QUANTITY", quantity);
		inAdjMap.put("FILE_TYPE", "03");
		inAdjMap.put("SERVICE_TYPE", "a");
		inAdjMap.put("MSISDN",phoneNo);	//数据库非空
		inAdjMap.put("PHONE_NO",phoneNo);
		//退费status记为0
		inAdjMap.put("STATUS","0");
		inAdjMap.put("BACK_TYPE",adjType);
		inAdjMap.put("FOREIGN_ACCEPT",errSerial);
		inAdjMap.put("REMARK",remark);
		inAdjMap.put("RETURN_TYPE",returnTypeFlag);
		inAdjMap.put("OP_CODE",opCode);
		inAdjMap.put("FLAG",ivrFlag);
		inAdjMap.put("SP_NAME",spName);
		inAdjMap.put("OPER_NAME",operName);
		
		log.info("-------> inAdjMap : "+inAdjMap.entrySet());
		
		Map<String, Object> outParamMap=adjCommon.doAdjOweFinal(inAdjMap);
		
		paySn = Long.parseLong(outParamMap.get("PAY_SN").toString());
		log.info("---single--adj---->paySn-"+paySn);
		
		
		if(backType.equals("2")){  //双倍补收，一半金额为0账本，一半金额为T账本赠费
			inBook.setPayType("T");
			
			//获取营业厅上级地市组织代码groupId
			String parentGroupId = group.getRegionDistinct(groupId, "2", provinceId).getParentGroupId();
			String tLoginNo = "yijiboss";
			if(control.getPubCodeList(2422L, "0", parentGroupId, null).size()>0){
				tLoginNo =  control.getPubCodeList(2422L, "0", parentGroupId, null).get(0).getCodeValue();
			}
			
			inBook.setLoginNo(tLoginNo);
			
			//17为10086客服
			inBook.setPayPath("17");
			
			//赠费
			inBook.setPayMethod("8");
			
			inAdjMap.put("PAY_BOOK_ENTITY", inBook);
			
			//实时入账，经过补收函数后，补收函数做了入账本表，所以inBook.getPayFee()值已经变为正值，此处可直接入账本表
			payManage.saveInBook(inDto.getHeader(), userBase, inBook);
						
			//3、获取缴费确认需要基本资料
			PayUserBaseEntity payUserBase = new PayUserBaseEntity();
			payUserBase.setIdNo(userEnt.getIdNo());
			payUserBase.setPhoneNo(phoneNo);
			payUserBase.setContractNo(contractNo);
			payUserBase.setUserGroupId(userEnt.getGroupId());
			payUserBase.setBrandId(brandId);
		
			//4.入payment表
			record.savePayMent(payUserBase, inBook);
			
		}
		inBook.setLoginNo(loginNo);
		
		// 冲销
		Map<String, Object> inParamMap = new HashMap<String, Object>();
		inParamMap.put("Header", inDto.getHeader());
		inParamMap.put("PAY_SN", paySn);
		inParamMap.put("CONTRACT_NO", contractNo);
		inParamMap.put("PHONE_NO", userBase.getPhoneNo());
		inParamMap.put("LOGIN_NO", inBook.getLoginNo());
		inParamMap.put("GROUP_ID", inBook.getGroupId());
		inParamMap.put("OP_CODE", inBook.getOpCode());
		inParamMap.put("DELAY_FAVOUR_RATE", "0");
		inParamMap.put("PAY_PATH", "11");
		writeOffer.doWriteOff(inParamMap);

		// 开机
		inParamMap = new HashMap<String, Object>();
		inParamMap.put("CONTRACT_NO", contractNo);
		inParamMap.put("PAY_SN", paySn);
		inParamMap.put("OP_CODE", inBook.getOpCode());
		inParamMap.put("LOGIN_NO", inBook.getLoginNo());
		inParamMap.put("LOGIN_GROUP", inBook.getGroupId());
		payOpener.doConUserOpen(inDto.getHeader(), userBase, inBook, provinceId);
		
		
		//向其他系统同步数据（统一接触）
        Map inMapTmp = new HashMap<String, Object>();
        inMapTmp.put("PAY_SN", paySn);
        inMapTmp.put("LOGIN_NO", loginNo);
        inMapTmp.put("GROUP_ID", groupId);
        inMapTmp.put("OP_CODE", opCode);
        inMapTmp.put("OP_TIME", curTime);
        inMapTmp.put("REGION_ID", regionId);
        inMapTmp.put("CUST_ID_TYPE", "1"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
        inMapTmp.put("CUST_ID_VALUE", phoneNo);
        inMapTmp.put("TOTAL_FEE", String.valueOf(tempBackFee));
        inMapTmp.put("OP_NOTE", phoneNo+"退费"+ValueUtils.transFenToYuan(tempBackFee)+"元");
        log.info("OP_NOTE", phoneNo+"退费"+tempBackFee+"元");
        inMapTmp.put("Header", inDto.getHeader());
        //inMapTmp.put("CONTACT_ID", "");

        preOrder.sendOprCntt(inMapTmp);
        
        
		//记录营业员操作记录表
		LoginOprEntity loginOprEnt = new LoginOprEntity();
		loginOprEnt.setBrandId(userBase.getBrandId());
		loginOprEnt.setIdNo(userBase.getIdNo());
		loginOprEnt.setLoginGroup(groupId);
		loginOprEnt.setLoginNo(loginNo);
		loginOprEnt.setLoginSn(paySn);
		loginOprEnt.setOpCode(opCode);
		loginOprEnt.setOpTime(curTime);
		loginOprEnt.setPayFee(0);
		loginOprEnt.setPhoneNo(phoneNo);
		loginOprEnt.setRemark(remark);
		loginOprEnt.setPayType("0");
		loginOprEnt.setTotalDate(totalDate);
		//退费记为负值
		loginOprEnt.setPayFee(-1*compMoney);
		record.saveLoginOpr(loginOprEnt);
		
		//出参信息
		S8041CfmOutDTO outDto = new S8041CfmOutDTO();
		outDto.setPaySn(paySn);
		outDto.setTotalDate(totalDate);
		
		log.info("---->8041Cfm_out"+outDto.toJson());
		return outDto;
	}
	
	
	@Override
	public OutDTO getSpList(InDTO inParam) {
		// TODO Auto-generated method stub
		S8041SpInDTO inDto = (S8041SpInDTO) inParam;
		log.info("----------> 8041 sp in" + inDto.getMbean());

		String spId = inDto.getSpid();
		String servName = inDto.getServName();

		List<SpInfoEntity> listSp = adj.getSpList(spId, servName);

		S8041SpOutDTO outDto = new S8041SpOutDTO();
		outDto.setListSpInfol(listSp);
		outDto.setLenSpinfo(listSp.size());
		log.info("----------> 8041 sp out" + outDto.toJson());
		return outDto;
	}
	
	@Override
	public OutDTO backInit(InDTO inParam){
		S8041BackInitInDTO inDto = (S8041BackInitInDTO)inParam;
		log.info("8041 backInit inDTO:"+inDto.getMbean());
		//出参信息
		S8041BackInitOutDTO outDto = new S8041BackInitOutDTO();
		
		
		//获取入参信息
		String phoneNo = inDto.getPhoneNo();
		long backSn = inDto.getBackSn();
		String loginNo = inDto.getLoginNo();
		String groupId = inDto.getGroupId();
		String provinceId = inDto.getProvinceId();
		
		
		//工号归属信息验证
		if(StringUtils.isEmptyOrNull(groupId)){
			groupId = login.getLoginInfo(loginNo, provinceId).getGroupId();
		}
		
		//获取营业厅上级组织代码groupId
		String parentGroupId = group.getRegionDistinct(groupId, "2", provinceId).getParentGroupId();
		
		//获取用户信息
		UserInfoEntity userEnt = user.getUserEntity(null, phoneNo, null, true);
		long idNo = userEnt.getIdNo();
		//获取用户退费信息
		List<AdjExtendEntity> adjEntList = adj.getBackAdjOweInfo(backSn, idNo, "0");
		if(adjEntList.size() == 0 || adjEntList.get(0).getStatus().equals("1")){
			throw new BaseException(AcctMgrError.getErrorCode("8041", "00006"),"该号码没有办理过投诉退费或者已退费冲正！");
		}
		
		long backFee = adjEntList.get(0).getBackFee();
		String remark = adjEntList.get(0).getRemark();
		String errSerial = adjEntList.get(0).getErrSerial();
		
		//计算补偿金额
		long comFee = 0;
		for(AdjExtendEntity adjEnt : adjEntList){
			if ( backSn == adjEnt.getOpSn()) {
				comFee = comFee + adjEnt.getBackFee();
			}	
		}
		
		//判断是否为sp退费冲正
		String spFlag="1";
		int spCnt = adj.getCntSpByOpSn(backSn, phoneNo);
		if(spCnt==0){
			spFlag="1";
			
			//非SP退费在出参中拼写
			outDto.setOperCode("无");
			outDto.setOperName("无");
			outDto.setSpCode("无");
			outDto.setSpName("无");
			
		}else{
			spFlag="2";
			
			//查询SP退费信息表
			List<RefundEntity> refundList = new ArrayList<RefundEntity>();
			Map<String, Object> inAdjMap = new HashMap<String, Object>();
			Map<String, Object> inMap = new HashMap<String, Object>();
			
			inMap.put("LOGIN_ACCEPT", backSn);
			inMap.put("MSISDN", phoneNo);
			inMap.put("FOREIGN_ACCEPT", errSerial);
			refundList = adj.getSPBack(inMap);
			if(refundList.size() > 0){
				String spCode = refundList.get(0).getSpCode();
				String operCode = refundList.get(0).getOperCode();
				String operName = refundList.get(0).getOperName();
				String spName = refundList.get(0).getSpName();
				String lastTime = refundList.get(0).getLastTime();
				
				//在出惨中加入SP相关内容
				outDto.setOperCode(operCode);
				outDto.setOperName(operName);
				outDto.setSpCode(spCode);
				outDto.setSpName(spName);
				outDto.setLastTime(lastTime);
			}	
		}
		
		
		String adjReasonOne = ""; // 退费一级原因
		String adjReasonTwo = ""; // 退费二级原因
		String adjReasonThree = ""; // 退费三级原因
		
		// 获取退费原因
		String adjReason = adjEntList.get(0).getAdjReason();
		if(adjReason.contains("|")){
			String[] adjReasons=adjReason.split("\\|");
			adjReasonOne = adjReason.split("\\|")[0].trim(); // 退费一级原因
			if(adjReasons.length>1){
				adjReasonTwo = adjReason.split("\\|")[1].trim(); // 退费二级原因
			}
			if(adjReasons.length>2){
				adjReasonThree = adjReason.split("\\|")[2].trim(); // 退费三级原因
			}
		}
		log.info("原因："+adjReason+"一级原因"+adjReasonOne+"二级原因"+adjReasonTwo+"三级原因"+adjReasonThree);
		
		//各级退费原因名称
		String adjReasonOneName="";
		String adjReasonTwoName="";
		String adjReasonThreeName="";

		if(adj.getReaosnCodeList(2410L, null, parentGroupId, new String[]{"0","1","2"},adjReasonOne,null).size()==0){
			//如果该原因在数据库原因表中被删除
			adjReasonOneName = "未知";
		}else{
			adjReasonOneName=adj.getReaosnCodeList(2410L, null, parentGroupId, new String[]{"0","1","2"},adjReasonOne,null).get(0).getCodeName();
		}
		if(adj.getReaosnCodeList(2411L, null, parentGroupId, new String[]{"0","1","2"},adjReasonTwo,null).size()==0){
			//如果该原因在数据库原因表中被删除
			adjReasonTwoName = "未知";
			
		}else{
			adjReasonTwoName=adj.getReaosnCodeList(2411L, null, parentGroupId, new String[]{"0","1","2"},adjReasonTwo,null).get(0).getCodeName();
			
		}
		if(adj.getReaosnCodeList(2412L,null , parentGroupId, new String[]{"0","1","2"},adjReasonThree,null).size()==0){
			//如果该原因在数据库原因表中被删除
			adjReasonThreeName = "未知";
		}else{
			adjReasonThreeName=adj.getReaosnCodeList(2412L,null , parentGroupId, new String[]{"0","1","2"},adjReasonThree,null).get(0).getCodeName();
		}
		
		
		
		
		//获取退费类型名称
		String adjType = adjEntList.get(0).getAdjType();
		String adjTypeName = "";
		String backTypeName = "";
		if(adjType.equals(PayBusiConst.ADJ_TYPE_SINGLE_PRE)){
			adjTypeName = "单倍";
			backTypeName = "退预存";
		}else if(adjType.equals(PayBusiConst.ADJ_TYPE_DOUBLE_PRE)){
			adjTypeName = "双倍";
			backTypeName = "退预存";
		}else if(adjType.equals(PayBusiConst.ADJ_TYPE_DOUBLE_PRE_CASH)){
			adjTypeName = "双倍";
			backTypeName = "退预存退现金";
		}
		
		
		
		outDto.setOpSn(String.valueOf(backSn));
		outDto.setAdjReasonOne(adjReasonOne);
		outDto.setAdjReasonThree(adjReasonThree);
		outDto.setAdjReasonTwo(adjReasonTwo);
		outDto.setAdjReasonOneName(adjReasonOneName);
		outDto.setAdjReasonTwoName(adjReasonTwoName);
		outDto.setAdjReasonThreeName(adjReasonThreeName);
		outDto.setAdjTypeName(adjTypeName);
		outDto.setBackFee(-1*backFee);
		outDto.setBackTypeName(backTypeName);
		outDto.setComFee(-1*comFee);
		outDto.setPhoneNo(phoneNo);
		outDto.setRemark(remark);
		outDto.setAdjType(adjType);
		outDto.setErrSerial(errSerial);
		
		log.debug("S8041BackInitOutDTO->"+outDto.toJson());

		return outDto;
	}
	
	@Override
	public OutDTO backCfm(InDTO inParam){
		S8041BackCfmInDTO  inDto=  (S8041BackCfmInDTO) inParam;
		log.info("---->8041 backCfm_in : "+inDto.getMbean());
				
		//获取入参信息
		String loginNo = inDto.getLoginNo();
		String provinceId = inDto.getProvinceId();
		String groupId = inDto.getGroupId();
		
		long compMoney = inDto.getCompMoney();  //赔偿金额
		String backType = inDto.getBackType();   //补偿类型  1：单倍  2: 双倍
		String phoneNo = inDto.getPhoneNo();
		String opCode = inDto.getOpCode();
		String remark = inDto.getRemark();
		String spFlag = inDto.getSpFlag();
		long backSn = inDto.getBackSn();

		long contractNo = 0L;
		//获取当前时间
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		int curYM = Integer.parseInt(curTime.substring(0, 6));
		int totalDate = Integer.parseInt(curTime.substring(0, 8));
		
		//查询工号信息
		LoginEntity loginEnt = login.getLoginInfo(loginNo, provinceId);
		groupId = loginEnt.getGroupId();
		int powerRight = loginEnt.getPowerRight();
		String loginType = loginEnt.getLoginType();
		
		//查询用户信息
		UserInfoEntity userEnt = user.getUserInfo(phoneNo);
		
		contractNo=userEnt.getContractNo();
		//用户基本信息实体设值
		PayUserBaseEntity userBase = new PayUserBaseEntity();
		userBase.setBrandId(userEnt.getBrandId());
		userBase.setContractNo(contractNo);
		userBase.setIdNo(userEnt.getIdNo());
		userBase.setPhoneNo(phoneNo);
		userBase.setUserGroupId(userEnt.getGroupId());
		
		/*缴费用户归属地市*/
        ChngroupRelEntity groupEntity = group.getRegionDistinct(userBase.getUserGroupId(), "2", provinceId);
        String regionId = groupEntity.getRegionCode();
				
		// 获取用户退费信息
		List<AdjExtendEntity> adjEntList = adj.getBackAdjOweInfo(backSn, userBase.getIdNo(), "0");

		if (adjEntList.size() == 0 || adjEntList.get(0).getStatus().equals("1")) {
			throw new BaseException(AcctMgrError.getErrorCode("8041", "00006"), "该号码没有办理过投诉退费或者已退费冲正!");
		}
		String adjReason=adjEntList.get(0).getAdjReason();
		String errSerial=adjEntList.get(0).getErrSerial();
		String payDate=adjEntList.get(0).getOpTime();
		// 获取退费冲正流水
		long paySn = control.getSequence("SEQ_PAY_SN");
		log.info("--------paySn->"+paySn);

		
		//查询工号是否为指定工号
		List<PubCodeDictEntity> pubBackLoginList = new ArrayList<PubCodeDictEntity>();
		Map<String, Object> inPubMap = new HashMap<String, Object>();
		inPubMap.put("CODE_CLASS", 2419L);
		inPubMap.put("LOGIN_NO", loginNo);
		pubBackLoginList = control.getPubCodeList(2419L, null, null, null,loginNo);
		if(pubBackLoginList.size() > 0){
			throw new BaseException(AcctMgrError.getErrorCode("8041", "00007"), "该工号不能办理投诉退费冲正服务！");
		}
		
		//查询工号是否为省级工号,省级工号需分省退费
		List<PubCodeDictEntity> pubProvinceList = new ArrayList<PubCodeDictEntity>();
		Map<String, Object> inProvinceMap = new HashMap<String, Object>();
		inProvinceMap.put("CODE_CLASS", 2415L);
		inProvinceMap.put("LOGIN_NO", loginNo);
		//pubProvinceList=control.queryPubCodeList(inProvinceMap);
		pubProvinceList=control.getPubCodeList(2415L, null, null, null,loginNo);
		//判断省级工号，并进行转换
		if(pubProvinceList.size()>0){
			List<PubCodeDictEntity> pubRegionList = new ArrayList<PubCodeDictEntity>();
			Map<String, Object> inRegionMap = new HashMap<String, Object>();
			inRegionMap.put("CODE_CLASS", 2414L);
			//获取用户营业厅上级组织代码（即地市代码）
			String groupRegion = group.getRegionDistinct(userEnt.getGroupId(), "2", provinceId).getParentGroupId();
			inRegionMap.put("GROUP_ID", groupRegion);
			//pubRegionList=control.queryPubCodeList(inRegionMap);
			pubRegionList=control.getPubCodeList(2414L, null, groupRegion, null,null);
			//转换工号失败
			if(pubRegionList.size()==0){
				throw new BaseException(AcctMgrError.getErrorCode("8041", "00005"),"查询转换工号出错！");
			}else{
				loginNo=pubRegionList.get(0).getCodeValue();
			}
		}

		//查询账户余额
		long remainFeeTmp =  remainFee.getConRemainFee(contractNo).getRemainFee();
		
		//TODO 退费账目项字符串组装
		String brandId = userEnt.getBrandId();
		String payDetail = "";
		long tempBackFee = 0;
		String adjType = "";
		if(backType.equals("单倍")){  //单倍补偿
			tempBackFee = compMoney;
			if(remainFeeTmp<compMoney){
				throw new BaseException(AcctMgrError.getErrorCode("8041", "00008"),"用户余额不足，无法办理冲正！");
			}
			adjType = "00";  //单倍退预存
		}else if(backType.equals("双倍")){  //双倍补偿,一半做补收，一半做负的缴费
			//tempBackFee = tempBackFee/2;
			if(remainFeeTmp<compMoney*2){
				throw new BaseException(AcctMgrError.getErrorCode("8041", "00008"),"用户余额不足，无法办理冲正！");
			}
			tempBackFee = compMoney;
			//adjType = "01";  //双倍退预存
			adjType = "02";  //双倍退预存退现金
		}
		
		if(brandId.equals("kf"))
		{
			//老系统账目项 payDetail = "0Y|gi|%s|#";
			payDetail = "0Y200000gi|" +tempBackFee+ "#";
		}	
		else if(brandId.equals("kg"))
		{
			//老系统账目项payDetail = "0Y|gk|%s|#";
			payDetail = "0Y200000gk|" +tempBackFee+ "#";
		}
		else if(brandId.equals("kd"))
		{
			//老系统账目项 payDetail = "0Y|gl|%s|#";
			payDetail = "0Y200000gl|" +tempBackFee+ "#";
		}	
		else
		{
			//老系统账目项 payDetail = "0B|zk|%s|#";
			payDetail = "0B200000zk|" +tempBackFee+ "#";
		}
		
		//状态字段初始化
		String payedStatus="0";  //退费冲正是正补收，payedStatus="0"
		
		log.info("-------->sPayDetail-"+payDetail);
		
		//补收账单实体设值
		AdjBIllEntity billEnt = new AdjBIllEntity();
		billEnt.setBillCycle(curYM);
		billEnt.setContractNo(contractNo);
		billEnt.setCustId(userEnt.getCustId());
		billEnt.setCycleType("0");
		billEnt.setGroupId(groupId);
		billEnt.setIdNo(userEnt.getIdNo());
		billEnt.setNaturalMonth(curYM);
		billEnt.setStatus(payedStatus);
		billEnt.setPhoneNo(Long.parseLong(phoneNo));
		
		//补收账单实体信息以外补收信息实体设置
		AdjExtendEntity adjExtendEnt = new AdjExtendEntity();
		//STATUS和ADJ_FLAG共用
		adjExtendEnt.setAdjFlag("1");
		adjExtendEnt.setLoginNo(loginNo);
		adjExtendEnt.setOffFlag("");
		adjExtendEnt.setOpCode(opCode);
		adjExtendEnt.setOpSn(paySn);
		adjExtendEnt.setRemark(remark);
		adjExtendEnt.setAdjType(adjType);
		adjExtendEnt.setAdjReason(adjReason);
		adjExtendEnt.setErrSerial(errSerial);
		if(spFlag.equals("2")){
			adjExtendEnt.setSpFlag(true);
		}else{
			adjExtendEnt.setSpFlag(false);
		}
		
		//入账实体设值
		PayBookEntity inBook =  new PayBookEntity();
		inBook.setGroupId(groupId);
		inBook.setLoginNo(loginNo);
		inBook.setOpCode(opCode);
		inBook.setOpNote(remark);
		inBook.setPayFee(tempBackFee);
		inBook.setPayType("0");
		inBook.setBeginTime(curTime);
		inBook.setTotalDate(totalDate);
		inBook.setYearMonth(curYM);
		inBook.setPaySn(paySn);
		inBook.setOriginalSn(backSn);
		
		//解析账目项字符串,补收核心函数
		Map<String, Object> inAdjMap = new HashMap<String, Object>();
		inAdjMap.put("Header", inDto.getHeader());
		inAdjMap.put("PAY_DETAIL", payDetail);
		inAdjMap.put("PAY_BOOK_ENTITY", inBook);
		inAdjMap.put("ADJ_BILL_ENTITY", billEnt);
		inAdjMap.put("PAY_USER_BASE_ENTITY", userBase);
		inAdjMap.put("ADJ_EXTEND_ENTITY", adjExtendEnt);
		inAdjMap.put("PROVINCE_ID", provinceId);
		
		//若入SP退费信息表时需要
		List<RefundEntity> refundList = new ArrayList<RefundEntity>();
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("LOGIN_ACCEPT", backSn);
		refundList = adj.getSPBack(inMap);
		if(refundList.size() > 0){
			adjExtendEnt.setSpFlag(true);
			inAdjMap.put("SP_CODE", refundList.get(0).getSpCode());
			inAdjMap.put("OPER_CODE", refundList.get(0).getOperCode());
			inAdjMap.put("CHECK_TYPE", refundList.get(0).getCheckType());
			inAdjMap.put("BILL_TYPE", refundList.get(0).getBillType());
			inAdjMap.put("LAST_TIME", refundList.get(0).getLastTime());
			inAdjMap.put("CHECK_TIME", refundList.get(0).getCheckTime());
			inAdjMap.put("UNIT_PRICE", refundList.get(0).getUnitPrice());
			inAdjMap.put("QUANTITY", refundList.get(0).getQuantity());
			inAdjMap.put("FILE_TYPE", "03");
			inAdjMap.put("SERVICE_TYPE", "a");
			inAdjMap.put("MSISDN",phoneNo);	//数据库非空
			inAdjMap.put("PHONE_NO",phoneNo);
			//冲正status记为1
			inAdjMap.put("STATUS","1");
			inAdjMap.put("BACK_TYPE",adjType);
			inAdjMap.put("FOREIGN_ACCEPT",errSerial);
			inAdjMap.put("REMARK",remark);
			inAdjMap.put("RETURN_TYPE",refundList.get(0).getReturnType());
			inAdjMap.put("OP_CODE","8041");
			inAdjMap.put("FLAG", refundList.get(0).getIvrFlag());
			inAdjMap.put("SP_NAME",refundList.get(0).getSpName());
			inAdjMap.put("OPER_NAME",refundList.get(0).getOperName());
		}
		//退费之后又一条数据adj_flag=0,status=0
		//冲正之后，有两条补收记录，分别是adj_flag=0,status=1以及adj_flag=1,status=1
		Map<String, Object> outParamMap=adjCommon.doAdjOweFinal(inAdjMap);
		adj.updateAcctAdjOweInfo(billEnt,adjExtendEnt,backSn);
		
		
		//退费冲正需要，报表发送,发送update更新
        Map<String, Object> adjoweKey = new HashMap<String, Object>();
        List<Map<String, Object>> keysList = new ArrayList<Map<String, Object>>(); // 同步报表库数据List
        
        adjoweKey.put("BILL_ID", adjEntList.get(0).getBillId());
        adjoweKey.put("CONTRACT_NO", contractNo);
        adjoweKey.put("TABLE_NAME", "ACT_ADJOWE_INFO");
        adjoweKey.put("UPDATE_TYPE", "U");
		keysList.add(adjoweKey);
        
        Map inOrderMap = new HashMap<String, Object>();
        inOrderMap.put("ACTION_ID", "1014");
        inOrderMap.put("KEY_DATA", adjoweKey);
        inOrderMap.put("LOGIN_NO", inBook.getLoginNo());
        inOrderMap.put("PHONE_NO", userBase.getPhoneNo());
        inOrderMap.put("LOGIN_SN", backSn);
        //inOrderMap.put("OP_CODE", "8066");
        
        inOrderMap.put("KEYS_LIST", keysList);
		
		preOrder.sendReportDataList(inDto.getHeader(), inOrderMap);
		
		
		
		paySn = Long.parseLong(outParamMap.get("PAY_SN").toString());
		log.info("---single--adj---->paySn-"+paySn);
		
		if(backType.equals("双倍")){  //双倍补收，一半金额为0账本，一半金额为T账本,工号要进行转换
			
			LoginBaseEntity loginEntity = new LoginBaseEntity();
			loginEntity.setLoginNo(inDto.getLoginNo());
			loginEntity.setGroupId(inDto.getGroupId());
			loginEntity.setOpCode(inDto.getOpCode());
			loginEntity.setOpNote(inDto.getRemark());
			
			/**
			 * 2、缴费冲正退现金费用pPayBackCashFee
			 */
			long backPaysn = payManage.doRollbackCashFee(backSn, paySn, payDate, loginEntity);

			/*
			 * 3、 回退缴费资金受理(缴费、空充、退费)日志记录
			 */
			Map<String, Object> inRollbackMap = new HashMap<String, Object>();
			inRollbackMap.put("PAY_SN", backSn);
			inRollbackMap.put("PAY_YM", payDate.substring(0, 6));
			inRollbackMap.put("PAY_DATA", payDate);
			inRollbackMap.put("BACK_PAYSN", backPaysn);
			//17为10086客服
			inRollbackMap.put("PAY_PATH", "17");
			//赠费
			inRollbackMap.put("PAY_METHOD", "8");
			inRollbackMap.put("Header", inDto.getHeader());
			inRollbackMap.put("PHONE_NO", inDto.getPhoneNo());
			inRollbackMap.put("LOGIN_ENTITY", loginEntity);
			inRollbackMap.put("PAY_OPCODE", opCode);
			Map outMapTmp = new HashMap();
			outMapTmp =  payManage.doRollbackRecord(inRollbackMap);
			long sumBackFee = Long.parseLong(outMapTmp.get("SUM_BACKFEE").toString());
			
		}
		
		inBook.setLoginNo(loginNo);
		
		// 正补收：冲销
		Map<String, Object> inParamMap = new HashMap<String, Object>();
		inParamMap.put("Header", inDto.getHeader());
		inParamMap.put("PAY_SN", paySn);
		inParamMap.put("CONTRACT_NO", contractNo);
		inParamMap.put("PHONE_NO", userBase.getPhoneNo());
		inParamMap.put("LOGIN_NO", inBook.getLoginNo());
		inParamMap.put("GROUP_ID", inBook.getGroupId());
		inParamMap.put("OP_CODE", inBook.getOpCode());
		inParamMap.put("DELAY_FAVOUR_RATE", "0");
		inParamMap.put("PAY_PATH", "11");
		writeOffer.doWriteOff(inParamMap);

		// 负补收：开机
		inParamMap = new HashMap<String, Object>();
		inParamMap.put("CONTRACT_NO", contractNo);
		inParamMap.put("PAY_SN", paySn);
		inParamMap.put("OP_CODE", inBook.getOpCode());
		inParamMap.put("LOGIN_NO", inBook.getLoginNo());
		inParamMap.put("LOGIN_GROUP", inBook.getGroupId());
		payOpener.doConUserOpen(inDto.getHeader(), userBase, inBook, provinceId);
		
		
		//向其他系统同步数据（目前：统一接触）报表未定
        Map inMapTmp = new HashMap<String, Object>();
        inMapTmp.put("PAY_SN", paySn);
        inMapTmp.put("LOGIN_NO", loginNo);
        inMapTmp.put("GROUP_ID", groupId);
        inMapTmp.put("OP_CODE", opCode);
        inMapTmp.put("OP_TIME", curTime);
        inMapTmp.put("REGION_ID", regionId);
        inMapTmp.put("CUST_ID_TYPE", "1"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
        inMapTmp.put("CUST_ID_VALUE", phoneNo);
        //冲正金额
      	if(backType.equals("单倍")){  //单倍补偿
      		 inMapTmp.put("TOTAL_FEE", String.valueOf(compMoney));
      	}else if(backType.equals("双倍")){  //双倍补偿,一半做补收，一半做负的缴费
      		 inMapTmp.put("TOTAL_FEE", String.valueOf(compMoney*2));
      	}
      	
      	if(backType.equals("单倍")){  //单倍补偿
      		inMapTmp.put("OP_NOTE", phoneNo+"退费冲正:"+ValueUtils.transFenToYuan(compMoney)+"元");
      		log.info("OP_NOTE"+phoneNo+"退费冲正:"+ValueUtils.transFenToYuan(compMoney)+"元");
     	}else if(backType.equals("双倍")){  //双倍补偿,一半做补收，一半做负的缴费
     		inMapTmp.put("OP_NOTE", phoneNo+"退费冲正:"+ValueUtils.transFenToYuan(compMoney*2)+"元");
     		log.info("OP_NOTE"+phoneNo+"退费冲正:"+ValueUtils.transFenToYuan(compMoney*2)+"元");
     	}
        
        inMapTmp.put("Header", inDto.getHeader());
        //inMapTmp.put("CONTACT_ID", "");

        preOrder.sendOprCntt(inMapTmp);
        //报表是否发送未定/////////////////////////////////////////
		
        //双倍冲正时候一般补收，一半做补缴冲正，补缴冲正中对日志进行了冲正，所以此处只针对单倍进行记录日志
        if(backType.equals("单倍")){
        	//记录营业员操作记录表
    		LoginOprEntity loginOprEnt = new LoginOprEntity();
    		loginOprEnt.setBrandId(userBase.getBrandId());
    		loginOprEnt.setIdNo(userBase.getIdNo());
    		loginOprEnt.setLoginGroup(groupId);
    		loginOprEnt.setLoginNo(loginNo);
    		loginOprEnt.setLoginSn(paySn);
    		loginOprEnt.setOpCode(opCode);
    		loginOprEnt.setOpTime(curTime);
    		loginOprEnt.setPayFee(0);
    		loginOprEnt.setPhoneNo(phoneNo);
    		loginOprEnt.setPayType("0");
    		loginOprEnt.setTotalDate(totalDate);
    		//冲正金额
    		loginOprEnt.setPayFee(compMoney);
    		loginOprEnt.setRemark(remark);
    		record.saveLoginOpr(loginOprEnt);
        }
		
		
		//出参信息
		S8041BackCfmOutDTO outDto = new S8041BackCfmOutDTO();
		outDto.setBackSn(paySn);
		outDto.setTotalDate(totalDate);
		
		log.info("---->8041 backCfm_out"+outDto.toJson());
	
		return outDto;
	}
	
	@Override
	public OutDTO qryInfo(InDTO inParam){
		Map<String, Object> inMap = new HashMap<String, Object>();
		
		log.info("8041 qryInfo inDto: "+ inParam.getMbean());
		
		String phoneNo = "";  //服务号码
		String loginIn = "";  //查询工号
		long idNo = 0;
		int doubleFlag = 1;
		//获取入参信息
		S8041QryInDTO inDto = (S8041QryInDTO)inParam;
		String beginTime = inDto.getBeginTime();
		String endTime = inDto.getEndTime();
		String loginNo=inDto.getLoginNo();
		String provinceId=inDto.getProvinceId();
		String groupId=inDto.getGroupId();
		String yearMonth = inDto.getYearMonth();
		
		
		if(StringUtils.isNotEmptyOrNull(inDto.getPhoneNo())){
			phoneNo = inDto.getPhoneNo();
			
			//获取用户信息
			UserInfoEntity userEnt = user.getUserEntity(null, phoneNo, null, true);
			idNo = userEnt.getIdNo();
		}
		
		if(StringUtils.isEmptyOrNull(groupId)){
						groupId = login.getLoginInfo(loginNo, provinceId).getGroupId();
					}
		//获取营业厅上级组织代码groupId
		String parentGroupId = group.getRegionDistinct(groupId, "2", provinceId).getParentGroupId();
		
		if(StringUtils.isEmptyOrNull(inDto.getPhoneNo()) && StringUtils.isEmptyOrNull(inDto.getLoginIn())){
			throw new BaseException(AcctMgrError.getErrorCode("8041", "00009"), "参数输入不正确，请确认!");
		}
		
		
		if(StringUtils.isNotEmptyOrNull(inDto.getLoginIn())){
			loginIn = inDto.getLoginIn();
		}
		
		//查询退费信息
		if (idNo != 0) {
			safeAddToMap(inMap, "ID_NO", idNo);
		}
		if (!loginIn.equals("")) {
			safeAddToMap(inMap, "LOGIN_NO", loginIn);
		}
		String[] adjTypes = new String[]{"00","01","02"}; //00: 单倍退预存   01: 双倍退预存
		safeAddToMap(inMap, "ADJ_TYPE", adjTypes); //00: 单倍退预存   01: 双倍退预存
		safeAddToMap(inMap, "BEGIN_TIME", beginTime);
		safeAddToMap(inMap, "END_TIME", endTime);
		safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
		safeAddToMap(inMap, "STATUS", "0");
		List<AdjExtendEntity> adjList = adj.getAdjOweInfo(inMap);
		
		if(adjList.size() == 0 || adjList.get(0).getStatus().equals("1")){
			throw new BaseException(AcctMgrError.getErrorCode("8041", "00006"),"该号码没有办理过投诉退费或者已退费冲正！");
		}
		
		//相同流水记录合并列表
		List<AdjExtendEntity> complainList = new ArrayList<AdjExtendEntity>(); 
		
		for (AdjExtendEntity adjEnt : adjList) {
				complainList.add(adjEnt);
		}
		
		//出参信息列表
		List<ComplainAdjQryEntity> complainAdjList = new ArrayList<ComplainAdjQryEntity>();
		for(AdjExtendEntity compAdjEnt : complainList){
	        //获取退费原因
			String adjReason = "";
			String adjReasonOne = "未知"; // 退费一级原因
			String adjReasonTwo = "未知"; // 退费二级原因
			String adjReasonThree = "未知"; // 退费三级原因
			
			if(StringUtils.isNotEmptyOrNull(compAdjEnt.getAdjReason())){
				
				adjReason = compAdjEnt.getAdjReason();
				
				if(adjReason.contains("|")){
					String[] adjReasons=adjReason.split("\\|");
					adjReasonOne = adjReason.split("\\|")[0].trim(); // 退费一级原因
					if(adjReasons.length>1){
						adjReasonTwo = adjReason.split("\\|")[1].trim(); // 退费二级原因
					}
					if(adjReasons.length>2){
						adjReasonThree = adjReason.split("\\|")[2].trim(); // 退费三级原因
					}
				}else{
					adjReasonOne = "未知";
					adjReasonTwo = "未知";
					adjReasonThree = "未知";
				}
				
				if(adj.getReaosnCodeList(2410L, null, parentGroupId, new String[]{"0","1","2"},adjReasonOne,null).size()==0)
						{//如果该原因在数据库原因表中被删除
						adjReasonOne = "未知";
				}else{
					adjReasonOne=adj.getReaosnCodeList(2410L, null, parentGroupId, new String[]{"0","1","2"},adjReasonOne,null).get(0).getCodeName();
				}
				if(adj.getReaosnCodeList(2411L, null, parentGroupId, new String[]{"0","1","2"},adjReasonTwo,null).size()==0){
					//如果该原因在数据库原因表中被删除
					adjReasonTwo = "未知";
					
				}else{
					adjReasonTwo=adj.getReaosnCodeList(2411L, null, parentGroupId, new String[]{"0","1","2"},adjReasonTwo,null).get(0).getCodeName();
					
				}
				if(adj.getReaosnCodeList(2412L,null , parentGroupId, new String[]{"0","1","2"},adjReasonThree,null).size()==0){
					//如果该原因在数据库原因表中被删除
					adjReasonThree = "未知";
				}else{
					adjReasonThree=adj.getReaosnCodeList(2412L,null , parentGroupId, new String[]{"0","1","2"},adjReasonThree,null).get(0).getCodeName();
				}
			}
			
			
			//获取退费类型名称
			String adjType = compAdjEnt.getAdjType();
			String adjTypeName = "";
			String backTypeName = "";
			if(StringUtils.isEmptyOrNull(compAdjEnt.getAdjType())){
				adjTypeName = "未知";
				backTypeName = "未知";
			}else{
				if(adjType.equals(PayBusiConst.ADJ_TYPE_SINGLE_PRE)){
					adjTypeName = "单倍";
					backTypeName = "退预存";
				}else if(adjType.equals(PayBusiConst.ADJ_TYPE_DOUBLE_PRE)){
					adjTypeName = "双倍";
					backTypeName = "退预存";
					doubleFlag = 2;
				}else if(adjType.equals(PayBusiConst.ADJ_TYPE_DOUBLE_PRE_CASH)){
					adjTypeName = "双倍";
					backTypeName = "退预存退现金";
					doubleFlag = 2;
				}
			}
			
			ComplainAdjQryEntity complainEnt = new ComplainAdjQryEntity();
			
			//获取用户号码
			if(phoneNo.equals("") || StringUtils.isEmptyOrNull(phoneNo)){
				String userPhoneNo =  user.getUserEntity(compAdjEnt.getUserIdNo(), null, null, true).getPhoneNo();		
				complainEnt.setPhoneNo(userPhoneNo);
			}else{
				complainEnt.setPhoneNo(phoneNo);
			}
			
			complainEnt.setAdjReasonOne(adjReasonOne);
			complainEnt.setAdjReasonThree(adjReasonThree);
			complainEnt.setAdjReasonTwo(adjReasonTwo);
			complainEnt.setAdjTypeName(adjTypeName);
			complainEnt.setBackTypeName(backTypeName);
			complainEnt.setLoginNo(compAdjEnt.getLoginNo());
			complainEnt.setComFee(Math.abs(compAdjEnt.getBackFee()*doubleFlag));
			complainEnt.setOprLoginNo(compAdjEnt.getLoginNo());
			complainEnt.setOpSn(compAdjEnt.getOpSn());
			complainEnt.setOpTime(compAdjEnt.getOpTime());
			
			complainAdjList.add(complainEnt);
		}
		
		
		S8041QryOutDTO  outDto = new S8041QryOutDTO();
		outDto.setLenComplainList(complainAdjList.size());
		outDto.setComplainList(complainAdjList);
		
		log.info("8041 qryInfo outDto: "+ outDto.toJson());
		
		return outDto;
	}
	
	
	@Override
	public OutDTO qryBatchInfo(InDTO inParam){

		Map<String, Object> inMap = new HashMap<String,Object>();
		S8041QryBatchInDTO inDto = (S8041QryBatchInDTO)inParam;
		
		log.info("8041 qryBatchInfo inDto:"+inDto.getMbean());
		
		//获取入参信息
		String regionCode = inDto.getRegionCode();
		String beginTime = inDto.getBeginTime();
		String endTime = inDto.getEndTime();
		String qryFlag = inDto.getQryFlag();
		String provinceId = inDto.getProvinceId();
		String groupId=inDto.getGroupId();
		String opCode=inDto.getOpCode();
		String loginNo = inDto.getLoginNo();
		String phoneNo = "";
		int doubleFlag = 1;//单双倍标识

		if(StringUtils.isNotEmptyOrNull(inDto.getPhoneNo())){
			phoneNo = inDto.getPhoneNo();
			
			UserInfoEntity userEnt = user.getUserEntity(null, phoneNo, null, true);
			safeAddToMap(inMap, "ID_NO", userEnt.getIdNo());
		}
		if (qryFlag.equals("1")) {
			safeAddToMap(inMap, "ADJ_FLAG", "0");  //退费标识
			safeAddToMap(inMap, "STATUS", "0");  //退费标识
			safeAddToMap(inMap, "OP_CODE", opCode);
		}else{
			safeAddToMap(inMap, "ADJ_FLAG", "1");  //退费冲正标识
			safeAddToMap(inMap, "STATUS", "1");  //退费冲正标识
			safeAddToMap(inMap, "OP_CODE", "8066");
		}
		
		//查询工号是否为指定工号
		List<PubCodeDictEntity> pubBackLoginList = new ArrayList<PubCodeDictEntity>();
		Map<String, Object> inPubMap = new HashMap<String, Object>();
		inPubMap.put("CODE_CLASS", 2419L);
		inPubMap.put("LOGIN_NO", loginNo);
		pubBackLoginList = control.getPubCodeList(2419L, null, null, null,loginNo);
		if(pubBackLoginList.size() > 0){
				throw new BaseException(AcctMgrError.getErrorCode("8041", "00010"), "该工号不能进行批量查询服务!");
		}
		
		//获取营业厅上级组织代码groupId
		String parentGroupId = group.getRegionDistinct(groupId, "2", provinceId).getParentGroupId();
		safeAddToMap(inMap, "REGION_ID", regionCode);
		safeAddToMap(inMap, "PROVINCE_ID", provinceId);
		safeAddToMap(inMap, "BEGIN_TIME", beginTime);
		safeAddToMap(inMap, "END_TIME", endTime);
		List<Map<String, Object>> batchAdjList = adj.getBatchAdjOweInfo(inMap);
		
		
		if(batchAdjList.size() == 0){
			throw new BaseException(AcctMgrError.getErrorCode("8041", "00012"),"该条件下没有退费或者冲正记录！");
		}
		
		
		// 相同流水记录合并
		List<Map<String, Object>> batchAdjComList = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> batchAdj : batchAdjList) {
			int flag = 0;
			for (Map<String, Object> tempMap : batchAdjComList) { // 相同流水记录合并
				if (Long.parseLong(tempMap.get("OP_SN").toString()) == Long.parseLong(batchAdj.get("OP_SN").toString())) {
					long backFee = Long.parseLong(tempMap.get("SHOULD_PAY").toString());
					long backFeeTemp = Long.parseLong(batchAdj.get("SHOULD_PAY").toString());
					tempMap.put("SHOULD_PAY", backFee + backFeeTemp);
					flag = 1;
				
					break;
				}

			}
			if (0 == flag) {
				batchAdjComList.add(batchAdj);
			}
		}
		
		//出参信息列表
		List<ComplainAdjQryBatchEntity> complainBatchList = new ArrayList<ComplainAdjQryBatchEntity>();
		
		for(Map<String, Object> comBatchAdj : batchAdjComList){
	        //获取退费原因
			String adjReason = "";
			String adjReasonThree = "";
			String adjReasonThreeName="未知";
			if(StringUtils.isNotEmptyOrNull(comBatchAdj.get("ADJ_REASON"))){
				adjReason = comBatchAdj.get("ADJ_REASON").toString();
				if(adjReason.contains("|")){
					String[] adjReasons=adjReason.split("\\|");
					if(adjReasons.length>2){
						adjReasonThree = adjReason.split("\\|")[2].trim(); // 退费三级原因
						if(adj.getReaosnCodeList(2412L,null , parentGroupId,new String[]{"0","1","2"},adjReasonThree,null).size()==0){
							adjReasonThreeName="未知";
						}else{
							adjReasonThreeName=adj.getReaosnCodeList(2412L,null , parentGroupId,new String[]{"0","1","2"},adjReasonThree,null).get(0).getCodeName();
						}
					}
					
				}else{
					adjReasonThree="未知";
				}
				
			}
			
			
			//获取退费类型名称
			String adjType="";
			if(StringUtils.isNotEmptyOrNull(comBatchAdj.get("ADJ_TYPE")))
				adjType= comBatchAdj.get("ADJ_TYPE").toString();
			String adjTypeName = "未知";
			String backTypeName = "未知";
			if(adjType.equals(PayBusiConst.ADJ_TYPE_SINGLE_PRE)){
				adjTypeName = "单倍";
				backTypeName = "退预存";
			}else if(adjType.equals(PayBusiConst.ADJ_TYPE_DOUBLE_PRE)){
				adjTypeName = "双倍";
				backTypeName = "退预存";
				doubleFlag = 2;
			}else if(adjType.equals(PayBusiConst.ADJ_TYPE_DOUBLE_PRE_CASH)){
				adjTypeName = "双倍";
				backTypeName = "退预存退现金";
				doubleFlag = 2;
			}
			
			
			//出参实体设值
			ComplainAdjQryBatchEntity complainBatch = new ComplainAdjQryBatchEntity();
			
			//获取用户号码
			if(phoneNo.equals("") || StringUtils.isEmptyOrNull(phoneNo)){
				String userPhoneNo =  user.getUserEntity(Long.parseLong(comBatchAdj.get("ID_NO").toString()), null, null, true).getPhoneNo();
				complainBatch.setPhoneNo(userPhoneNo);
			}else{
				complainBatch.setPhoneNo(phoneNo);
			}
			
			complainBatch.setAdjReasonThree(adjReasonThreeName);
			complainBatch.setAdjTypeName(adjTypeName);
			 
			if(StringUtils.isNotEmptyOrNull(comBatchAdj.get("BILL_TYPE")) && !comBatchAdj.get("BILL_TYPE").toString().equals("0")){
				//获取计费类型
				List<PubCodeDictEntity> adjCalculateFeeList=null;
				adjCalculateFeeList=control.getPubCodeList(2413L, comBatchAdj.get("BILL_TYPE").toString(), null, "1");
				String billType=adjCalculateFeeList.get(0).getCodeValue();
				complainBatch.setBillType(billType);
			}else{
				complainBatch.setBillType("未知");
			}
				
			if(StringUtils.isNotEmptyOrNull(comBatchAdj.get("USER_TIME"))){
				complainBatch.setUserTime(comBatchAdj.get("USER_TIME").toString());
			}else{
				complainBatch.setUserTime("未知");
			}
			
			if(StringUtils.isNotEmptyOrNull(regionCode)){
				List<GroupInfoEntity> listCity = group.getRegionList(provinceId, regionCode);
				complainBatch.setRegionName(listCity.get(0).getGroupName());
			}else{
				complainBatch.setRegionName("未知");
			}
				
			if (qryFlag.equals("1")) {
				complainBatch.setComFee(-1L*doubleFlag*Long.parseLong(comBatchAdj.get("SHOULD_PAY").toString()));
			}else{
				complainBatch.setComFee(doubleFlag*Long.parseLong(comBatchAdj.get("SHOULD_PAY").toString()));
			}
			
			complainBatch.setCount("0");
			
			if(StringUtils.isNotEmptyOrNull(comBatchAdj.get("ERR_SERIAL"))){
				complainBatch.setErrSerial(comBatchAdj.get("ERR_SERIAL").toString());
			}else{
				complainBatch.setErrSerial("未知");
			}
			
			
			if(StringUtils.isNotEmptyOrNull(comBatchAdj.get("OPER_CODE"))){
				complainBatch.setOperCode(comBatchAdj.get("OPER_CODE").toString());
			}else{
				complainBatch.setOperCode("未知");
			}
				
			complainBatch.setOprLoginNo(comBatchAdj.get("LOGIN_NO").toString());
			complainBatch.setOpTime(comBatchAdj.get("OP_TIME").toString());
			
			complainBatch.setPrice("未知");
			if(StringUtils.isNotEmptyOrNull(comBatchAdj.get("PRICE"))){
				complainBatch.setPrice(comBatchAdj.get("PRICE").toString());
			}else{
				complainBatch.setPrice("未知");
			}
			if(StringUtils.isNotEmptyOrNull(comBatchAdj.get("COUNT"))){
				complainBatch.setCount(comBatchAdj.get("COUNT").toString());
			}else{
				complainBatch.setCount("未知");
			}
			if(StringUtils.isNotEmptyOrNull(comBatchAdj.get("SP_CODE"))){
				complainBatch.setSpCode(comBatchAdj.get("SP_CODE").toString());
			}else{
				complainBatch.setSpCode("未知");
			}
			if(StringUtils.isNotEmptyOrNull(comBatchAdj.get("SP_NAME"))){
				complainBatch.setSpName(comBatchAdj.get("SP_NAME").toString());
			}else{
				complainBatch.setSpName("未知");
			}
			if(StringUtils.isNotEmptyOrNull(comBatchAdj.get("OPER_NAME"))){
				complainBatch.setOperName(comBatchAdj.get("OPER_NAME").toString());
			}else{
				complainBatch.setOperName("未知");
			}
			
			complainBatchList.add(complainBatch);
		}
		
		S8041QryBatchOutDTO outDto = new S8041QryBatchOutDTO();
		outDto.setComplainBatchList(complainBatchList);
		outDto.setLenComplainBatchList(complainBatchList.size());
		log.info("8041 qryBatchInfo outDto:"+outDto.toJson());
		return outDto;
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
	 * @return the adjCommon
	 */
	public IAdjCommon getAdjCommon() {
		return adjCommon;
	}

	/**
	 * @param adjCommon the adjCommon to set
	 */
	public void setAdjCommon(IAdjCommon adjCommon) {
		this.adjCommon = adjCommon;
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
	 * @return the adj
	 */
	public IAdj getAdj() {
		return adj;
	}

	/**
	 * @param adj the adj to set
	 */
	public void setAdj(IAdj adj) {
		this.adj = adj;
	}
	/**
	 * 
	 * @return
	 */
	public IGroup getGroup() {
		return group;
	}
	/**
	 * 
	 * @param group
	 */
	public void setGroup(IGroup group) {
		this.group = group;
	}

	/**
	 * 
	 * @return
	 */
	public IPayManage getPayManage() {
		return payManage;
	}

	/**
	 * 
	 * @param payManage
	 */
	public void setPayManage(IPayManage payManage) {
		this.payManage = payManage;
	}
	public IProd getProd() {
		return prod;
	}

	public void setProd(IProd prod) {
		this.prod = prod;
	}

	public IPreOrder getPreOrder() {
		return preOrder;
	}

	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}


	
}