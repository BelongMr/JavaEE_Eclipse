package com.sitech.acctmgr.atom.impl.feeqry;

import com.alibaba.fastjson.JSON;
import com.sitech.acctmgr.atom.busi.query.inter.IOweBill;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.account.ContractDeadInfoEntity;
import com.sitech.acctmgr.atom.domains.account.ContractEntity;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.account.GrpConEntity;
import com.sitech.acctmgr.atom.domains.balance.BookPayoutEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.bill.*;
import com.sitech.acctmgr.atom.domains.cct.CreditInfoEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.pay.PayMentEntity;
import com.sitech.acctmgr.atom.domains.query.Pay8107Entity;
import com.sitech.acctmgr.atom.domains.record.ActQueryOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserDeadEntity;
import com.sitech.acctmgr.atom.domains.user.UserExpireEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserPrcEntity;
import com.sitech.acctmgr.atom.domains.user.UserdetaildeadEntity;
import com.sitech.acctmgr.atom.dto.feeqry.*;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.BillComp;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.inter.feeqry.I8107;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

import java.util.*;

/**
 *
 * <p>Title: 费用综合信息查询实现类  </p>
 * <p>Description: 实现费用综合信息查询：缴费查询、账单查询、销账查询等  </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author zhangjp
 * @version 1.0
 */
@ParamTypes({ 
	@ParamType(m = "query", c = S8107QueryInDTO.class, oc = S8107QueryOutDTO.class),
	@ParamType(m = "qryBill", c = S8107QryBillInDTO.class, oc = S8107QryBillOutDTO.class),
	@ParamType(m = "qryPay", c = S8107QryPayInDTO.class , oc = S8107QryPayOutDTO.class),
	@ParamType(m = "qryBillDetail", c = S8107QryBillDetailInDTO.class , oc = S8107QryBillDetailOutDTO.class)
})
public class S8107 extends AcctMgrBaseService implements I8107 {
	
	protected IAccount account;
	protected IBalance balance;
	protected ILogin login;
	protected IGroup group;
	protected IUser user;
	protected ICust cust;
	protected IBill bill;
	private IBillDisplayer billDisplayer;
	protected ICredit credit;
	protected IRemainFee remainFee;
	protected IRecord record;
	protected IControl control;
	protected IOweBill oweBill;
	protected IProd prod;
	protected IBase base;


	/**
	 * 
	* 名称：费用综合信息查询服务
	* @param PHONE_NO（可空）
	* @param CONTRACT_NO（可空）
	* @param LOGIN_NO
	* @param USER_FLAG（可空）
	* @param GROUP_ID（可空）
	* @param OP_CODE
	* @return BASE_INFO.REMAIN_FEE<br/>
	* 		  BASE_INFO.PREPAY_FEE<br/>
	* 		  BASE_INFO.LIMIT_OWE<br/>
	* 		  BASE_INFO.CREDIT_CLASS<br/>
	* 		  BASE_INFO.OWE_FEE<br/>
	* 		  BASE_INFO.PROD_PRC_NAME<br/>
	* 		  BASE_INFO.REGION_NAME<br/>
	* 		  BASE_INFO.EXPIRE_TIME<br/>
	* 		  BASE_INFO.CUST_NAME<br/>
	* 		  BASE_INFO.CONTRACT_NAME<br/>
	* 		  BASE_INFO.PAY_NAME<br/>
	* 		  BASE_INFO.RUN_NAME<br/>
	* 		  BASE_INFO.USER_GRADE_NAME<br/>
	* 		  BASE_INFO.UNBILL_FEE<br/>
	* 		  BASE_INFO.MONTH_UNBILL<br/>
	* 		  BASE_INFO.CONTRACT_NO<br/>
	* 		  BASE_INFO.DEAD_OWE<br/>
	* 		  BASE_INFO.ID_NO<br/>
	* 		  BASE_INFO.OPEN_FLAG<br/>
	* 		  BASE_INFO.OPEN_MONTH<br/>
	* 		  BASE_INFO.OPEN_TIME<br/>
	* 		  BASE_INFO.OPEN_TIME_FOR<br/>
	* 		  BASE_INFO.DEAD_INNET_TIME:入网时间<br/>
	* 		  BASE_INFO.DEAD_RUN_TIME:状态变更时间<br/>
	* @throws Exception
	 */
	public final OutDTO query(InDTO inParam) throws Exception {
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		Map<String, Object> outMapTmp = new HashMap<String, Object>(); 

		String sPhoneNo = "";
		long lContractNo = 0;
		long lIdNo = 0;
		int iUserFlag = 0;
		String sOpCode = "";
		
		long lUnBillOwe = 0;	//未出帐话费 
		long lTotalOweFee = 0;	//账户欠费金额（包含滞纳金）
		long lMonthUnbill = 0;	//帐户本月消费金额
		
		long lCurPrepay = 0;
		long lRemainFee = 0;
		long lPrepayUn = 0;	//未生效预存
		int iDefFlag = 0;  //是否查询用户模认账户
		
		String contactName ="";
		String payName="";
		String regionName="";
		String runName = "";
		String openTime = "";
		String prodPrcName = "";
		String expireTime = "";
		String formatExpireTime="";
		String creditName = "";
		String deadInnetTime = "";
		String deadRunTime = "";
		String blurCustName = "";
		
		//集团账户信息
		long unitId = 0;
		long unitCustId = 0;
		String unitName ="";
		String custLevel = "";
		String staffLoginName = "";
		String staffLogin = "";
		String productName = "";
		
		S8107QueryInDTO inDto = (S8107QueryInDTO)inParam;
		
		sPhoneNo = inDto.getPhoneNo();
		lContractNo = inDto.getContractNo();
		iUserFlag = inDto.getUserFlag();
		sOpCode = inDto.getOpCode();
		
		
		if(!sPhoneNo.equals("")) {
			long lDefContractNo = 0;
			if(iUserFlag == 0) {	//在网用户
				UserInfoEntity uie = user.getUserInfo(sPhoneNo);
				lIdNo = uie.getIdNo();
				lDefContractNo = uie.getContractNo();
				String runCode = uie.getRunCode();
				runName = uie.getRunName();
				openTime = uie.getOpenTime().substring(0, 4) + "/" + uie.getOpenTime().substring(4, 6) + "/" + uie.getOpenTime().substring(6, 8);

				//取用户代付账户个数
				List<ContractEntity> conUserRelList = account.getConList(lIdNo);
				if(conUserRelList.size() == 1) {
					if(lContractNo == 0) {
						lContractNo = lDefContractNo;
					}
				} else if(conUserRelList.size() > 1) {
					if(lContractNo == 0) {
						throw new BusiException(AcctMgrError.getErrorCode(sOpCode,"00002"), "多帐户用户，帐户不能为空！");
					} else if(lContractNo != lDefContractNo) {
						iDefFlag = 1;
					}
				}
				
				//默认账户取星级及有效期
				if(iDefFlag == 0) {	
					
					//取用户星级
					Map<String,Object> outMap = new HashMap<String,Object>();
					outMap = credit.getCreditInfo(lIdNo);
					if(outMap.get("CREDIT_NAME") != null
							&& !outMap.get("CREDIT_NAME").equals("")) {
						creditName = outMap.get("CREDIT_NAME").toString();
					}else {
						creditName = "未评级";
					}
			
					//取用户的有效期					
					UserExpireEntity uee = user.getUserExpireInfo(lIdNo);
					if(outMapTmp.isEmpty()) {
						expireTime = "20991231";
					}else {
						expireTime = uee.getExpireTime1();
					}
					formatExpireTime = expireTime.substring(0, 4) + "/" + expireTime.substring(4, 6) + "/" + expireTime.substring(6, 8);
					
				}
				
				//取账户信息
				ContractInfoEntity cie = account.getConInfo(lContractNo);
				contactName = cie.getBlurContractName();
				payName = cie.getPayCodeName();
				
				//取账户归属地
				ChngroupRelEntity cgre = group.getRegionDistinct(cie.getGroupId(), "2", inDto.getProvinceId());
				regionName = cgre.getRegionName();
				
				//取套餐资费名称
				UserPrcEntity upe = prod.getUserPrcidInfo(lIdNo);
				prodPrcName = upe.getProdPrcName();
				
			} else if(iUserFlag > 0) {	//离网用户
				
				List<UserDeadEntity> udeList = user.getUserdeadEntity(sPhoneNo, null, lContractNo);
				deadInnetTime = udeList.get(0).getOpenTime().substring(0, 8);
				long idNo = udeList.get(0).getIdNo();
				long custId = udeList.get(0).getCustId();
				
				UserdetaildeadEntity udde = user.getUserdetailDeadEntity(idNo);
				deadRunTime = udde.getRunTime().substring(0, 8);
				runName = udde.getRunName();
				
				CustInfoEntity custEnt = cust.getCustInfo(custId, null);
				blurCustName = custEnt.getBlurCustName();
				
				//取账户信息
				ContractDeadInfoEntity cdie = account.getConDeadInfo(lContractNo);
				contactName = cdie.getBlurContractName();
				payName = cdie.getPayCodeName();
				
				//取账户归属地
				ChngroupRelEntity cgre = group.getRegionDistinct(cdie.getGroupId(), "2", inDto.getProvinceId());
				regionName = cgre.getRegionName();
			}
			
		} else if(lContractNo > 0) {
			//取帐户信息
			String accountType = "";
			if(iUserFlag == 0) {
				ContractInfoEntity cie = account.getConInfo(lContractNo);
				contactName = cie.getBlurContractName();
				payName = cie.getPayCodeName();
				accountType = cie.getAccountType();
				
				//取账户归属地
				ChngroupRelEntity cgre = group.getRegionDistinct(cie.getGroupId(), "2", inDto.getProvinceId());
				regionName = cgre.getRegionName();
				
			} else {
				ContractDeadInfoEntity cdie = account.getConDeadInfo(lContractNo);
				contactName = cdie.getBlurContractName();
				payName = cdie.getPayCodeName();
				accountType = cdie.getAccountType();
				
				//取账户归属地
				ChngroupRelEntity cgre = group.getRegionDistinct(cdie.getGroupId(), "2", inDto.getProvinceId());
				regionName = cgre.getRegionName();
			}
			
			//取集团账户信息
			if(accountType.equals("1")){
				UserInfoEntity uie = user.getUserEntity(null, null, lContractNo, false);					
				if(uie!=null) {
					long idNo = uie.getIdNo();
					UserPrcEntity upe = prod.getUserPrcidInfo(idNo);
					prodPrcName = upe.getProdPrcName();
				}else {
					prodPrcName="";
				}
				
				GrpConEntity gce = account.getGrpConInfo(lContractNo);
				if(gce!=null){
					unitId = gce.getUnitId();
					unitCustId = gce.getCustId();
					unitName = gce.getUnitName();
					custLevel = gce.getCustLevel();
					staffLogin = gce.getStaffLogin();
					staffLoginName = gce.getStaffLoginName();
					productName = gce.getProductName();
				}

			}
			
			//取付费优先级最高用户，入操作记录表
			sPhoneNo = account.getPayPhoneByCon(lContractNo);
		}
				
		if(iUserFlag == 0) {
			//取在网用户预存、余额、内存欠费、账户总欠费
			OutFeeData outFee = remainFee.getConRemainFee(lContractNo);
			lCurPrepay = outFee.getPrepayFee();
			lUnBillOwe = outFee.getUnbillFee();
			lTotalOweFee = outFee.getOweFee();
			lRemainFee = outFee.getRemainFee();
			
			//吉林取当月消费是取当月库内欠费、内存欠费的和
			/*
			lMonthUnbill = oweBill.getCurRealPay(lContractNo);	//当月消费
			*/
			
			//取未生效账本
			lPrepayUn = balance.getIneffectiveBalance(lContractNo);
		} else {
			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("CONTRACT_NO", lContractNo);
			lCurPrepay = balance.getAcctBookDeadSum(inMapTmp);
						
			BillEntity be = bill.getSumDeadFee(0, lContractNo, null);			
			lTotalOweFee =be.getOweFee();
			
			lRemainFee = lCurPrepay - lTotalOweFee;
		}
				
		log.info("############lRemainFee = " + lRemainFee + "lCurPrepay = " + lCurPrepay +
				"lTotalOweFee = " + lTotalOweFee + "##################");	
	
		ActQueryOprEntity oprEntity = new ActQueryOprEntity();
		oprEntity.setQueryType("0");
		oprEntity.setOpCode("8107");
		oprEntity.setContactId("");
		oprEntity.setIdNo(lIdNo);
		oprEntity.setPhoneNo(sPhoneNo);
		oprEntity.setBrandId("");
		oprEntity.setLoginNo(inDto.getLoginNo());
		oprEntity.setLoginGroup(inDto.getGroupId());
		oprEntity.setRemark("缴费信息查询");
		oprEntity.setProvinceId(inDto.getProvinceId());
		oprEntity.setHeader(inDto.getHeader());
		record.saveQueryOpr(oprEntity, true);
		
		//出参
		S8107QueryOutDTO outDto = new S8107QueryOutDTO();
		outDto.setContractNo(lContractNo);
		outDto.setRemainFee(lRemainFee);
		outDto.setUnBillFee(lUnBillOwe);
		outDto.setUnPrepay(lPrepayUn);
		outDto.setMonthUnbill(lMonthUnbill);
		outDto.setCurPrepay(lCurPrepay);
		outDto.setCreditClass(creditName);
		outDto.setProdPrcName(prodPrcName);		
		outDto.setRegionName(regionName);
		outDto.setExpireTime(formatExpireTime);
		outDto.setContractName(contactName);
		outDto.setPayName(payName);
		outDto.setRunName(runName);
		outDto.setOpenTime(openTime);
		outDto.setDeadRunTime(deadRunTime);
		outDto.setDeadInnetTime(deadInnetTime);
		outDto.setPhoneNo(sPhoneNo);
		outDto.setCustName(blurCustName);
		
		outDto.setUnitId(unitId);
		outDto.setUnitName(unitName);
		outDto.setCustId(unitCustId);
		outDto.setCustLevel(custLevel);
		outDto.setStaffLogin(staffLogin);
		outDto.setStaffLoginName(staffLoginName);
		outDto.setProductName(productName);
		
		log.info("S8107QueryOutDTO:" + outDto.toJson().toString());

		return outDto;
	}
	
	
	/**
	 * 
	* 名称：费用综合信息缴费查询服务
	* @param CONTRACT_NO
	* @param BEGIN_TIME
	* @param END_TIME
	* @return CNT: 返回条数<br/>
	* 		  PAY_LIST.OP_TIME：操作时间<br/>
	* 		  PAY_LIST.PAY_NAME<br/>
	* 		  PAY_LIST.OP_NAME<br/>
	* 		  PAY_LIST.LOGIN_NAME<br/>
	* 		  PAY_LIST.PAY_MONEY<br/>
	* 		  PAY_LIST.LOGIN_ACCEPT<br/>
	* 		  PAY_LIST.DELAY_FEE<br/>
	* 		  PAY_LIST.PREPAY_FEE<br/>
	* 		  PAY_LIST.PAYED_OWE<br/>
	* 		  PAY_LIST.LOGIN_NO<br/>
	* 		  PAY_LIST.LOGIN_GROUP_NAME<br/>
	* 		  PAY_LIST.PHONE_NO<br/>
	* 		  PAY_LIST.REMARK<br/>
	* 		  PAY_LIST.BAKC_FLAG<br/>
	* 		  PAY_LIST.EFF_TIME<br/>
	* @throws Exception
	 */
	public OutDTO qryPay(InDTO inParam) throws Exception {
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		Map<String, Object> outMapTmp = new HashMap<String, Object>();
		List<Pay8107Entity> outParamList = new ArrayList<Pay8107Entity>();
		
		String sCurDate = "";
		
		long lContractNo = 0;
		int iBeginTime = 0;
		int iEndTime = 0;
		
		/*取当前年月和当前时间*/
		sCurDate = DateUtil.format(new Date(), "yyyyMMdd");
		
		S8107QryPayInDTO inDto = (S8107QryPayInDTO)inParam;
		
		lContractNo = inDto.getContractNo();
		iBeginTime = inDto.getBeginTime();
		iEndTime = inDto.getEndTime();
		
		int iBeginYm = iBeginTime/100;
		int iEndYm = iEndTime/100;
		
		//3、取缴费信息
		int recordNum=0;
		for(int iOneYm = iEndYm; iOneYm >= iBeginYm; iOneYm = Integer.valueOf(DateUtil.toStringMinusMonths(String.valueOf(iOneYm), 1, "yyyyMM"))){
			Map<String, Object> inMap = new HashMap<String, Object>();
			Map<String, Object> outMap = new HashMap<String, Object>();
			inMap.put("SUFFIX", String.valueOf(iOneYm));
			inMap.put("CONTRACT_NO", lContractNo);
			inMap.put("BEGIN_DATE", iBeginTime);
			inMap.put("END_DATE", iEndTime);
			inMap.put("NOT_OP_CODES", new String[]{"8010"});
			inMap.put("DESC", "DESC");
			
			List<PayMentEntity> payMentList = record.getPayMentList(inMap);
			for(PayMentEntity pmeTemp :payMentList){
				String loginGroup = pmeTemp.getGroupId();
				long lPayedOwe = 0;
				long lPayedDelay = 0;
				long lPrePayFee = 0;
				//取该表缴费冲销费用
				inMap.put("SUFFIX", String.valueOf(iOneYm));
				inMap.put("PAY_SN",	pmeTemp.getPaySn());
				inMap.put("CONTRACT_NO", pmeTemp.getContractNo());
				inMap.put("ID_NO", pmeTemp.getIdNo());
				inMap.put("PAY_TYPE", pmeTemp.getPayType());
				BookPayoutEntity bpe = balance.getPayOutFee(inMap);
				if(bpe==null){
					// 本次缴费无冲销欠费记录
					lPayedOwe = 0;
					lPayedDelay = 0;
				}else {
					lPayedOwe = bpe.getOutBalance();
					lPayedDelay = bpe.getDelayFee();
				}
				
				//预存变化
				lPrePayFee =pmeTemp.getPayFee()- lPayedOwe - lPayedDelay;
				
				//判断退款标志
				String backFlag="";
				if(pmeTemp.getStatus().equals("0") || pmeTemp.getStatus().equals("2")) {
					backFlag= "未退";
				} else {
					backFlag = "已退";
				}
				
				String districtName = "";
				String hallName = "";
				int groupLevel = group.getCurrentLevel(loginGroup, inDto.getProvinceId());
				if(groupLevel!=0) {
					int districtLevel = groupLevel-1;
					//取区县
					ChngroupRelEntity cgre1 = group.getRegionDistinct(pmeTemp.getGroupId(), String.valueOf(districtLevel), inDto.getProvinceId());
					districtName =cgre1.getRegionName();
					
					//取营业厅
					ChngroupRelEntity cgre2 = group.getRegionDistinct(pmeTemp.getGroupId(), String.valueOf(groupLevel), inDto.getProvinceId());
					hallName =cgre2.getRegionName();
				}else {
					districtName = "未知";
					hallName = "未知";
				}
				
				
				recordNum++;				
				if(recordNum==2000) {
					break;
				}
				
				Pay8107Entity outEntity = new Pay8107Entity();
				outEntity.setContractNo(lContractNo);
				outEntity.setOpTime(pmeTemp.getOpTime());
				outEntity.setPayName(pmeTemp.getPayTypeName());
				outEntity.setOpName(pmeTemp.getFunctionName());
				outEntity.setPayMoney(pmeTemp.getPayFee());
				outEntity.setLoginAccept(pmeTemp.getPaySn());
				outEntity.setPayedDelay(lPayedDelay);
				outEntity.setPayedOwe(lPayedOwe);
				outEntity.setLoginNo(pmeTemp.getLoginNo());
				outEntity.setPhoneNo(pmeTemp.getPhoneNo());
				outEntity.setBackFlag(backFlag);
				outEntity.setDistrictName(districtName);
				outEntity.setHallName(hallName);
				outParamList.add(outEntity);
			}
		}
		
		S8107QryPayOutDTO outDto = new S8107QryPayOutDTO();	
		outDto.setCnt(outParamList.size());
		outDto.setOutParamList(outParamList);
		
		return outDto;
	}
	
	public final OutDTO qryBill(InDTO inParam) throws Exception {
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		Map<String, Object> outMapTmp = null;
		
		List<Map<String, Object>> oweInfoList = new ArrayList<Map<String, Object>>();	//未冲销欠费信息列表
		List<Map<String, Object>> paydownInfoList = new ArrayList<Map<String, Object>>();	//已冲销费用信息列表
//		List<Map<String, Object>> unBillInfoList = new ArrayList<Map<String, Object>>();	//内存欠费信息列表(在公共方法里已经获得)
		
		long lContractNo = 0;
		long lIdNo = 0;
		int iUserFlag = 0;
		int iBeginTime = 0;
		int iEndTime = 0;
		String sOpCode = "";
		int iPageNum = 0;
		String sInUuid = "";
		
		S8107QryBillInDTO inDto = (S8107QryBillInDTO)inParam;
		
		lContractNo = inDto.getContractNo();
		lIdNo = inDto.getIdNo();
		iUserFlag = inDto.getUserFlag();
		iBeginTime = inDto.getBeginTime();
		iEndTime = inDto.getEndTime();
		sOpCode = inDto.getOpCode();
		sInUuid = inDto.getInUuid();
		iPageNum = inDto.getPageNum();
		
		int iUserNum = 0;
		int iUserTotal = 0;
		String sUuid = sInUuid;
		if(iUserFlag == 0) {	//取在网用户费用信息		
			//判断账户是否过户，取过户时间
			int iPassDate = 0;
			inMapTmp.put("CONTRACT_NO", lContractNo);
			Date passDate = user.getUserPassDate(null,lContractNo);
			if(passDate != null) {
				iPassDate = Integer.parseInt(DateUtil.format(passDate, "yyyyMMdd"));
				if(iBeginTime < iPassDate) {
					iBeginTime = iPassDate;
				}
			}
			
		    boolean isOnline = bill.isOnlineForQry(lContractNo);
			
			if(iPageNum == 0) {	//初始取账单信息
				//判断账户下代付用户个数
				iUserNum = account.cntConUserRel(lContractNo, null, null);
				
				if(iUserNum < 10) {
					iUserTotal = 1;
					
					inMapTmp.clear();
					inMapTmp.put("CONTRACT_NO", lContractNo);
					inMapTmp.put("BEGIN_TIME", iBeginTime);
					inMapTmp.put("END_TIME", iEndTime);
					inMapTmp.put("QRY_FLAG", 1);
					inMapTmp.put("IS_ONLINE", isOnline);
					outMapTmp = bill.getConFeeList(inMapTmp);
						
					oweInfoList.addAll((List<Map<String, Object>>)outMapTmp.get("OWE_INFO_LIST"));
					paydownInfoList.addAll((List<Map<String, Object>>)outMapTmp.get("PAYDOWN_INFO_LIST"));
				} else {
					//取账户所有代付用户
					List<ContractEntity> conUserList = account.getUserList(lContractNo);
					
					List<String> userIdList = new ArrayList<String>();
					for(ContractEntity conUserEntity : conUserList) {
						userIdList.add(String.valueOf(conUserEntity.getId()));
					}
					
					iUserTotal = userIdList.size();
					//将代付用户列表存放到内存中
//					MemcachedTools.getInstance().set(sUuid, userIdList, CommonConst.OVERTIME_IDNO);
//					cacheOpr.setCacheUtils("jedis");
//					cacheOpr.setValueToCache(sUuid, userIdList);
					
					//取用户列表前10条数据
					List<String> qryUserList = userIdList.subList(0, 10);
					
					log.info("qryBill is qryUserList = " + qryUserList.toString());
					
					//循环用户ID，取账单信息
					for(String sIdNoOne : qryUserList) {
						inMapTmp = new HashMap<String, Object>();
						inMapTmp.put("CONTRACT_NO", lContractNo);
						inMapTmp.put("ID_NO", Long.parseLong(sIdNoOne));
						inMapTmp.put("BEGIN_TIME", iBeginTime);
						inMapTmp.put("END_TIME", iEndTime);
						inMapTmp.put("QRY_FLAG", 1);
						inMapTmp.put("IS_ONLINE", isOnline);
						outMapTmp = bill.getConFeeList(inMapTmp);
							
						oweInfoList.addAll((List<Map<String, Object>>)outMapTmp.get("OWE_INFO_LIST"));
						paydownInfoList.addAll((List<Map<String, Object>>)outMapTmp.get("PAYDOWN_INFO_LIST"));
					}
					
				}	
			} else {	//选择分页取账单信息
				
				//取内存中用户列表的相应ID
//				List<Long> userIdList = MemcachedTools.getInstance().get(sUuid);
//				cacheOpr.setCacheUtils("jedis");
//				List<String> userIdList = cacheOpr.getCachedValue(sUuid, List.class);
				
				List<String> userIdList = new ArrayList<String>();
				
				iUserTotal = userIdList.size();
								
				//取对应页数所ID_NO
				int iEndNum = 0;
				int iBeginNum = 0;
				iEndNum = iPageNum * 10;
				iBeginNum = iEndNum - 10;
				
				if(iEndNum > iUserTotal) {
					iEndNum = iUserTotal;
				}
				
				List<String> qryUserList = userIdList.subList(iBeginNum, iEndNum);
				
				//循环用户ID，取账单信息
				for(String sIdNoOne : qryUserList) {
					inMapTmp = new HashMap<String, Object>();
					inMapTmp.put("CONTRACT_NO", lContractNo);
					inMapTmp.put("ID_NO", Long.parseLong(sIdNoOne));
					inMapTmp.put("BEGIN_TIME", iBeginTime);
					inMapTmp.put("END_TIME", iEndTime);
					inMapTmp.put("QRY_FLAG", 1);
					inMapTmp.put("IS_ONLINE", isOnline);
					outMapTmp = bill.getConFeeList(inMapTmp);
						
					oweInfoList.addAll((List<Map<String, Object>>)outMapTmp.get("OWE_INFO_LIST"));
					paydownInfoList.addAll((List<Map<String, Object>>)outMapTmp.get("PAYDOWN_INFO_LIST"));
				}
			}
		} else if(iUserFlag > 0) {	//取离网用户费用信息
			inMapTmp.clear();
			inMapTmp.put("CONTRACT_NO", lContractNo);
			inMapTmp.put("ID_NO", lIdNo);
			inMapTmp.put("INNET_FLAG", 1);
			inMapTmp.put("BEGIN_TIME", iBeginTime);
			inMapTmp.put("END_TIME", iEndTime);
			if(sOpCode.equals("8166")) {
				inMapTmp.put("QRY_FLAG", 1);
			}
			outMapTmp = bill.getConFeeList(inMapTmp);
			oweInfoList.addAll((List<Map<String, Object>>)outMapTmp.get("OWE_INFO_LIST"));
			paydownInfoList.addAll((List<Map<String, Object>>)outMapTmp.get("PAYDOWN_INFO_LIST"));
		}
		
		List<Map<String, Object>> billListTmp = new ArrayList<Map<String, Object>>();
		
		for(Map<String, Object> oweInfoMap : oweInfoList) {
			if(iUserFlag == 0) {
				oweInfoMap.put("STATUS_FLAG", "0");
			} else {
				oweInfoMap.put("STATUS_FLAG", "3");
			}
			billListTmp.add(oweInfoMap);
		}
		for(Map<String, Object> paydownInfoMap : paydownInfoList) {
			paydownInfoMap.put("STATUS_FLAG", "2");
			billListTmp.add(paydownInfoMap);
		}
//		billListTmp.addAll(oweInfoList);
//		billListTmp.addAll(paydownInfoList);
//		billListTmp.addAll(unBillInfoList);
		
		Collections.sort(billListTmp, new BillComp());
		
		List<BillDisplayEntity> billList = new ArrayList<BillDisplayEntity>();
		
		for(Map<String, Object> billMap : billListTmp) {
			String jsonStr = JSON.toJSONString(billMap);
			billList.add(JSON.parseObject(jsonStr,BillDisplayEntity.class));
		}
		
		S8107QryBillOutDTO outDto = new S8107QryBillOutDTO();
		
		outDto.setBillList(billList);
		outDto.setUserTotal(iUserTotal);
		
		log.info("S8107QryBillOutDTO = " + outDto.toJson().toString());
		
//		outParam.setBody("OWE_INFO_LIST", oweInfoList);
//		outParam.setBody("PAYDOWN_INFO_LIST", paydownInfoList);
//		outParam.setBody("UNBILL_INFO_LIST", unBillInfoList);
		
		return outDto;
	}
	
	public OutDTO qryBillDetail(InDTO inParam) throws Exception {
		Map<String, Object> outMap = new HashMap<String, Object>();
		List<OutBillEntity> outList = new ArrayList<OutBillEntity>();
		
		long lIdNo = 0;
		long lContractNo = 0;
		int iBillCycle = 0;
		String sStatus = "";
		
		//入参DTO
		S8107QryBillDetailInDTO in = (S8107QryBillDetailInDTO) inParam;
		lIdNo = in.getIdNo();
		lContractNo = in.getContractNo();
		iBillCycle = in.getBillCycle();
		sStatus = in.getStatus();
				
		if(sStatus.equals("0") || sStatus.equals("2")) {
			boolean isOnline = bill.isOnlineForQry(lContractNo);
			
			outMap = billDisplayer.getSevenDetailBill(lIdNo, lContractNo, iBillCycle, sStatus, isOnline);
		} else {
			outMap = billDisplayer.getSevenDeadDetailBill(lIdNo, lContractNo, iBillCycle);
		}
		
		
		outList = (List<OutBillEntity>) outMap.get("BILL_LIST");
		
		List<BillDetailEntity> PCAS_01_LIST = new ArrayList<BillDetailEntity>();
		List<BillDetailEntity> PCAS_02_LIST = new ArrayList<BillDetailEntity>();
		List<BillDetailEntity> PCAS_03_LIST = new ArrayList<BillDetailEntity>();
		List<BillDetailEntity> PCAS_04_LIST = new ArrayList<BillDetailEntity>();
		List<BillDetailEntity> PCAS_05_LIST = new ArrayList<BillDetailEntity>();
		List<BillDetailEntity> PCAS_06_LIST = new ArrayList<BillDetailEntity>();
		List<BillDetailEntity> PCAS_07_LIST = new ArrayList<BillDetailEntity>();
		List<BillDetailEntity> PCAS_08_LIST = new ArrayList<BillDetailEntity>();
		List<BillDetailEntity> PCAS_09_LIST = new ArrayList<BillDetailEntity>();
		List<BillDetailEntity> PCAS_10_LIST = new ArrayList<BillDetailEntity>();
		
		for(OutBillEntity bill : outList) {
			int showId = Integer.parseInt(bill.getBillInfo().getItemId());
			switch(showId){
			case 1:
				BillDetailEntity bill_01 = new BillDetailEntity(bill.getBillInfo(), "0");
				PCAS_01_LIST.add(bill_01);
				for(StatusBillInfoEntity statBill : bill.getDetailList()) {
					BillDetailEntity billDetial = new BillDetailEntity(statBill, "1");
					PCAS_01_LIST.add(billDetial);
				}
				break;
			case 2:
				BillDetailEntity bill_02 = new BillDetailEntity(bill.getBillInfo(), "0");
				PCAS_02_LIST.add(bill_02);
				for(StatusBillInfoEntity statBill : bill.getDetailList()) {
					BillDetailEntity billDetial = new BillDetailEntity(statBill, "1");
					PCAS_02_LIST.add(billDetial);
				}
				break;
			case 3:
				BillDetailEntity bill_03 = new BillDetailEntity(bill.getBillInfo(), "0");
				PCAS_03_LIST.add(bill_03);
				for(StatusBillInfoEntity statBill : bill.getDetailList()) {
					BillDetailEntity billDetial = new BillDetailEntity(statBill, "1");
					PCAS_03_LIST.add(billDetial);
				}
				break;
			case 4:
				BillDetailEntity bill_04 = new BillDetailEntity(bill.getBillInfo(), "0");
				PCAS_04_LIST.add(bill_04);
				for(StatusBillInfoEntity statBill : bill.getDetailList()) {
					BillDetailEntity billDetial = new BillDetailEntity(statBill, "1");
					PCAS_04_LIST.add(billDetial);
				}
				break;
			case 5:
				BillDetailEntity bill_05 = new BillDetailEntity(bill.getBillInfo(), "0");
				PCAS_05_LIST.add(bill_05);
				for(StatusBillInfoEntity statBill : bill.getDetailList()) {
					BillDetailEntity billDetial = new BillDetailEntity(statBill, "1");
					PCAS_05_LIST.add(billDetial);
				}
				break;
			case 6:
				BillDetailEntity bill_06 = new BillDetailEntity(bill.getBillInfo(), "0");
				PCAS_06_LIST.add(bill_06);
				for(StatusBillInfoEntity statBill : bill.getDetailList()) {
					BillDetailEntity billDetial = new BillDetailEntity(statBill, "1");
					PCAS_06_LIST.add(billDetial);
				}
				break;
			case 7:
				BillDetailEntity bill_07 = new BillDetailEntity(bill.getBillInfo(), "0");
				PCAS_07_LIST.add(bill_07);
				for(StatusBillInfoEntity statBill : bill.getDetailList()) {
					BillDetailEntity billDetial = new BillDetailEntity(statBill, "1");
					PCAS_07_LIST.add(billDetial);
				}
				break;
			case 8:
				BillDetailEntity bill_08 = new BillDetailEntity(bill.getBillInfo(), "0");
				PCAS_08_LIST.add(bill_08);
				for(StatusBillInfoEntity statBill : bill.getDetailList()) {
					BillDetailEntity billDetial = new BillDetailEntity(statBill, "1");
					PCAS_08_LIST.add(billDetial);
				}
				break;
			case 9:
				BillDetailEntity bill_09 = new BillDetailEntity(bill.getBillInfo(), "0");
				PCAS_09_LIST.add(bill_09);
				for(StatusBillInfoEntity statBill : bill.getDetailList()) {
					BillDetailEntity billDetial = new BillDetailEntity(statBill, "1");
					PCAS_09_LIST.add(billDetial);
				}
				break;
			case 10:
				BillDetailEntity bill_10 = new BillDetailEntity(bill.getBillInfo(), "0");
				PCAS_10_LIST.add(bill_10);
				for(StatusBillInfoEntity statBill : bill.getDetailList()) {
					BillDetailEntity billDetial = new BillDetailEntity(statBill, "1");
					PCAS_10_LIST.add(billDetial);
				}
				break;
			default:
				break;
			}
		}
		
		
		List<BillDetailEntity> outParamList = new ArrayList<BillDetailEntity>();
		outParamList.addAll(PCAS_01_LIST);
		outParamList.addAll(PCAS_02_LIST);
		outParamList.addAll(PCAS_03_LIST);
		outParamList.addAll(PCAS_04_LIST);
		outParamList.addAll(PCAS_05_LIST);
		outParamList.addAll(PCAS_06_LIST);
		outParamList.addAll(PCAS_07_LIST);
		outParamList.addAll(PCAS_08_LIST);
		outParamList.addAll(PCAS_09_LIST);
		outParamList.addAll(PCAS_10_LIST);
		
		String sBeginTime = "";
		String sEndTime = "";
//		if(sStatus.equals("0") || sStatus.equals("2")) {   吉林只是自然月，动态月暂时不用考虑，家庭账户这种方法取不出开始时间和结束时间
//			Map<String, Object> inMap = new HashMap<String, Object>();
//			inMap.put("CONTRACT_NO", lContractNo);
//			inMap.put("IN_MONTH", String.valueOf(iBillCycle));
//			outMap = control.getMonthInfo(inMap);
//			sBeginTime = outMap.get("OUT_BEGIN_TIME").toString();
//			sEndTime = outMap.get("OUT_END_TIME").toString();
			
//			if(sEndTime.substring(12).equals("00")) {
//				sEndTime = DateUtil.toStringMinusSeconds(sEndTime, 1, "yyyyMMddHHmmss");
//			}
//		} else {
			sBeginTime = String.valueOf(iBillCycle) + "01000000";
			sEndTime = DateUtil.toStringPlusMonths(sBeginTime, 1, "yyyyMMddHHmmss");
			
			sEndTime = DateUtil.toStringMinusSeconds(sEndTime, 1, "yyyyMMddHHmmss");
			
//		}
		String sBegTime = sBeginTime.substring(0, 4) + "-" + sBeginTime.substring(4, 6) + "-" 
				+ sBeginTime.substring(6, 8) + " " + sBeginTime.substring(8, 10) + ":" + sBeginTime.substring(10, 12) + ":" + sBeginTime.substring(12);
		
		String sEtime = sEndTime.substring(0, 4) + "-" + sEndTime.substring(4, 6) + "-" 
				+ sEndTime.substring(6, 8) + " " + sEndTime.substring(8, 10) + ":" + sEndTime.substring(10, 12) + ":" + sEndTime.substring(12);
		//出参DTO
		S8107QryBillDetailOutDTO out = new S8107QryBillDetailOutDTO();
		out.setOutList(outParamList);
		out.setContractNo(lContractNo);
		out.setIdNo(lIdNo);
		out.setBeginTime(sBegTime);
		out.setEndTime(sEtime);
		
		return out;
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


	public ICust getCust() {
		return cust;
	}

	public void setCust(ICust cust) {
		this.cust = cust;
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


	public IRemainFee getRemainFee() {
		return remainFee;
	}


	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public IOweBill getOweBill() {
		return oweBill;
	}

	public void setOweBill(IOweBill oweBill) {
		this.oweBill = oweBill;
	}

	public IProd getProd() {
		return prod;
	}

	public void setProd(IProd prod) {
		this.prod = prod;
	}

	public IBase getBase() {
		return base;
	}

	public void setBase(IBase base) {
		this.base = base;
	}

	public IBillDisplayer getBillDisplayer() {
		return billDisplayer;
	}

	public void setBillDisplayer(IBillDisplayer billDisplayer) {
		this.billDisplayer = billDisplayer;
	}
}