package com.sitech.acctmgr.atom.busi.pay.backfee;

import com.alibaba.fastjson.JSON;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupDictEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.pay.BalanceNBEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.user.GroupchgInfoEntity;
import com.sitech.acctmgr.atom.domains.user.ServAddNumEntity;
import com.sitech.acctmgr.atom.domains.user.UserBrandEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.pay.S8008InitInDTO;
import com.sitech.acctmgr.atom.impl.pay.S8008;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcf.core.exception.BusiException;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.apache.commons.collections.MapUtils.getLongValue;
import static org.apache.commons.collections.MapUtils.getString;


/**
*
* <p>Title:  退预存款 </p>
* <p>Description:   </p>
* <p>Copyright: Copyright (c) 2014</p>
* <p>Company: SI-TECH </p>
* @author 
* @version 1.0
*/
public class BackFeeType extends BaseBusi{

	protected S8008 back8008; 
	
	/**
	 * @paramer back8008
	 */
	public BackFeeType(S8008  inBack8008) {
		back8008 = inBack8008;
	}
	
	//获取虚拟号信息 
	public void getPhoneNo(String phoneNo,String addServiceNo){
		ServAddNumEntity service = new ServAddNumEntity();
		service.setPhoneNo(phoneNo);
	}

	//获取用户基本信息
	public  Map<String, Object> getBaseInfo(String phoneNo, long contractNo, String provinceId){
		String brandId = "";
		long idNo = 0;
		long custId = 0;
		String userGroup = "";

		Map<String, Object> outMap = new HashMap<String, Object>();

		// 查询用户信息
		if (!"".equals(phoneNo)) { // 号码不为空
			// 用户验证		
			log.info("-------------"+phoneNo);
			
			UserInfoEntity userInfo = back8008.getUser().getUserInfo(phoneNo);
			idNo = userInfo.getIdNo();
			custId = userInfo.getCustId();
			brandId = userInfo.getBrandId();
			userGroup = userInfo.getGroupId();
			if (contractNo == 0) {
				contractNo = userInfo.getContractNo();
			}
		} else { // 号码为空

			try {
				// 取账户对应默认用户
				UserInfoEntity userInfo = back8008.getUser().getUserEntity(null, null, contractNo, true);
				idNo = userInfo.getIdNo();
				custId = userInfo.getCustId();
				phoneNo = userInfo.getPhoneNo();

				// 根据用户取品牌
				UserBrandEntity brandEnt = back8008.getUser().getUserBrandRel(idNo);
				brandId = brandEnt.getBrandId();

			} catch (BusiException e) {
				idNo = 0;
				phoneNo = "99999999999";
				brandId = "2230xx";
			}
			
			GroupchgInfoEntity groupEnt = back8008.getGroup().getChgGroup(null, null, contractNo);
			userGroup = groupEnt.getGroupIdPay();
		}

		// 取账户信息
		ContractInfoEntity conInfo = back8008.getAccount().getConInfo(contractNo);
		String conEncrypName = conInfo.getBlurContractName();
		String contractattType = conInfo.getContractattType();

		userGroup = ("".equals(userGroup) ? "0" : userGroup);

		// 取用户地市归属
		ChngroupRelEntity regionEnt = back8008.getGroup().getRegionDistinct(userGroup, "2", provinceId);
		String regionId = regionEnt.getRegionCode();

		PayUserBaseEntity userInfo = new PayUserBaseEntity();
		userInfo.setBrandId(brandId);
		userInfo.setContractNo(contractNo);
		userInfo.setIdNo(idNo);
		userInfo.setCustId(custId);
		userInfo.setPhoneNo(phoneNo);
		userInfo.setRegionId(regionId);
		userInfo.setUserGroupId(userGroup);	
		outMap.put("USER_BASE_INFO", userInfo);
		outMap.put("CONTRACT_NAME", conEncrypName);
		outMap.put("CONTRACTATT_TYPE", contractattType);
		log.info("----->getBaseInfo_end = "+outMap.toString());
		return outMap;
	}


	// 获取预存、欠费、可退预
	public Map<String, Object> getBackFeeFinal(long idNo, long contractNo) {
		Map<String, Object> inTmpMap = null;
		List<Map<String, Object>> backfeeList = null;

		log.info("getBackFeeFinal inParam:idNo="+ idNo + "-->contractNo="+contractNo);
		
		// 1.获取账户预存和欠费
		OutFeeData  feeDate =  back8008.getRemainFee().getConRemainFee(contractNo);
		long oweFee = feeDate.getOweFee() + feeDate.getDelayFee() + feeDate.getUnbillFee();
		long prepayFee = feeDate.getPrepayFee();
		// 3.可退账本余额
		long backBalance = 0;

		inTmpMap = new HashMap<String, Object>();
		inTmpMap.put("CONTRACT_NO", contractNo);
		inTmpMap.put("BACK_FLAG", "0");// pay_attr 第2位- 0可退1不可退
		backfeeList = back8008.getBalance().getAcctBookList(inTmpMap);
		for (Map<String, Object> specMap : backfeeList) {
			backBalance += Long.parseLong(specMap.get("CUR_BALANCE").toString());
		}

		// 4.计算最终可退预存
		long returnMoney = 0;
		if (backBalance > prepayFee - oweFee) {
			if (prepayFee - oweFee > 0) {
				returnMoney = prepayFee - oweFee;
			}
		} else {
			returnMoney = backBalance;
		}

		// 5. 返回值
		Map<String, Object> outMap = new HashMap<>();
		outMap.put("PREPAY_FEE", prepayFee);
		outMap.put("OWE_FEE", oweFee);
		outMap.put("RETURN_MONEY", returnMoney);
		return outMap;
	}
	
	
	public long getPayMoney(long payMoney) {
		if (payMoney < 0) {
			log.error("----->退还金额不能小于(必须大于等于)0！");
			throw new BusiException(AcctMgrError.getErrorCode("8008", "00005"), "退还金额不能小于0！");
		}
		return payMoney;
	}

	/**
	* 名称：金额校验：退费金额不能大于可退金额
	* @param backMoney 退费金额
	* @param returnMoney 可退金额
	*/
	public void feeCheck(long backMoney, long returnMoney) {
		if (returnMoney - backMoney < 0) {
			String pay_money_tmp = String.format("%.2f", (double) backMoney / 100);
			String return_money_tmp = String.format("%.2f", (double) returnMoney / 100);
			String errmsgT = "退费金额[" + pay_money_tmp + "]大于可退金额[" + return_money_tmp + "]!";
			log.error(errmsgT);
			throw new BusiException(AcctMgrError.getErrorCode("8008", "00002"), errmsgT);
		}		
	}


	/**
	* 名称：
	* @param payType
	* @return payType
	*/
	public String getPayType(String opType, String payType) {
		return payType;
	}
 
	
	/**
	* 名称：退费核心函数
	* @param 
	* @return pay_accept 退费流水
	*/
	public Map<String, Object> doBackMoney(PayUserBaseEntity userBaseInfo,PayBookEntity bookIn) {
		return back8008.getPayManage().doBackMoney(userBaseInfo,bookIn);
	}


	/**
	* 名称：联动空充退款：返回退款后余额
	* @param contractNo 账户
	* @return  remainFee 余额
	*/
	public long getConPrePay(long contractNo,long idNo) {
		return 0;
	}

	/**
	* 名称：不可退预存列表
	* @param contractNo 账户
	* @return List<BalanceNBEntity>
	*/
	public List<BalanceNBEntity> getNoBackList(long contractNo) {
		
		// 1.获取账本列表
		List<Map<String, Object>> infoList=new ArrayList<Map<String,Object>>();

		Map<String, Object>  inTmpMap=new HashMap<String, Object>();
		inTmpMap.put("CONTRACT_NO", contractNo);
		inTmpMap.put("BACK_FLAG", "1");
		List<Map<String, Object>>preBackList= back8008.getBalance().getAcctBookList(inTmpMap);
		for ( Map<String, Object> resultMap : preBackList ) {
			Map<String, Object> outForMap = null;

			long noBackPrepay=Long.valueOf( resultMap.get("CUR_BALANCE").toString());
			System.out.println(noBackPrepay);
			String payType=  resultMap.get("PAY_TYPE").toString().trim();
			System.out.println(payType);

			if("0".equals(payType)){
				log.info("----> 过滤掉0账本");
				continue;
			}
			
			int cycleFlag = 0;
			for(Map<String, Object> map: infoList){
				if(getString(map, "PAY_TYPE").equals(payType)){
					map.put("PREPAY_FEE", getLongValue(map, "PREPAY_FEE")+noBackPrepay) ;
					cycleFlag =1;
				}else{
					continue;
				}
			}
			
			if(cycleFlag==0){
				inTmpMap=new HashMap<String, Object>();
				inTmpMap.put("PAY_TYPE", payType);
				outForMap=back8008.getBalance().getBookTypeDict(inTmpMap);
				String payTypeName=outForMap.get("PAY_TYPE_NAME").toString().trim();
				System.out.println(payTypeName);
				
				Map<String, Object> infoMap = new HashMap<String, Object>();
				infoMap.put("PAY_TYPE", payType);
				infoMap.put("PAY_TYPE_NAME", payTypeName);
				infoMap.put("PREPAY_FEE", noBackPrepay);
				infoList.add(infoMap);
			}
		}
		
		// 2.转换为 List<BalanceNBEntity>
		List<BalanceNBEntity> noBackList = new ArrayList<BalanceNBEntity>();
		for (Map<String, Object>map : infoList) {
			String jsonMap =JSON.toJSONString(map);
			System.out.println(jsonMap);
			noBackList.add(JSON.parseObject(jsonMap, BalanceNBEntity.class));
		}
		
		if(noBackList.size()==0){
			log.error("------> 该账户无不可退账本"+contractNo);
 			throw new BusiException(AcctMgrError.getErrorCode("8008", "00004"),"该账户无不可退账本["+contractNo+"]");
		}
		
		return noBackList;
	}
	
	/*个性化业务验证*/
	public void checkSpecialBusiness(Map<String, Object> inMap){
		String provinceId = (String)inMap.get("PROVINCE_ID");
		String groupId = (String)inMap.get("GROUP_ID");
		String brandId = (String)inMap.get("BRAND_ID");
		String prcId = (String)inMap.get("PRC_ID");
		log.info("brandId--------------->"+brandId);
		List<String> list= Arrays.asList(PayBusiConst.SZX_PRCID);
		//标准神州行用户,不允许做此业务
		if (list.contains(prcId)) {
			throw new BaseException(AcctMgrError.getErrorCode("8008", "00007"), "标准神州行用户,不允许做此业务!");
		}

		//TODO 如果一级退款原因为国际漫游退款，判断国际漫游功能是否关闭，用户为国际漫游用户则不允许办理（count(*)!=0）
//		if (smCode.equals("LL")) {
//			throw new BaseException(AcctMgrError.getErrorCode("8008", "00032"), "用户为国际漫游用户,不允许办理!");
//		}
		//账户品牌为行业应用流量包（sm_code=’LL’）不允许退预存款
		if (brandId.equals("2310LL")) {
			throw new BaseException(AcctMgrError.getErrorCode("8008", "00009"), "集团行业流量包产品不允许退预存款!");
		}
		
		//退预存款限额验证，只有区县级工号以及县级以下工号才能退预存款，地市级工号以及地市级以上工号不能退预存款
		this.checkLimtFeeDistrict(groupId,provinceId);
		
		
	}
	
	public void sendMsg(Map<String, Object> inMap){
		//对帐号为$CONTRACT_NO的帐户退费成功，退费金额为$MONEY元！
		
	}
	
	/*区县限额验证*/
	public void checkLimtFeeDistrict(String groupId,String provinceId){

		//TODO 这里请使用 IBase.getBankInfo 函数，请注意
		
		//获取工号信息
		int rootDistance = back8008.getGroup().getCurrentLevel(groupId, provinceId);
		if(rootDistance >= 3){ //区县及区县以下工号
			ChngroupRelEntity groupEnt = back8008.getGroup().getRegionDistinct(groupId, "3",provinceId);
			groupId = groupEnt.getParentGroupId();  //获取工号对应区县的groupId
		}
		if(rootDistance < 3){
			throw new BaseException(AcctMgrError.getErrorCode("8008", "00010"), "该工号为地市级别工号,不能定位到区县,无法操作!");
		}	
	}
	
	/**
	 * 名称：地市和区县限额的验证 
	 */
	public void checkRegionDistrict(String regionGroup,String limitType,long backMoney,String districtGroup){
		log.info("没尽到工厂类");
	}

	/**
	 * 名称：在网用户账单落地：落地只有预存或只有账单
	 */
	protected void billToGround(S8008InitInDTO inDto, Map<String, Object> baseInfo) {
		log.info("---->billToGround 账单内存库落地：省个性业务，S8008JL实现");

		// returnType.billToGround( inDto, baseInfo);
		String userOnNet = inDto.getInIfOnNet();
		String loginNo = inDto.getLoginNo();
		long idNo = getLongValue(baseInfo, "ID_NO");
		long contractNo = inDto.getContractNo();

		// 在网用户账单落地后，只有预存或账单
		if ("1".equals(userOnNet)) {
			String billFlag = back8008.getControl().getPubBillCtrl().getBillFlag();
			log.error("------> billFlag=" + billFlag);

			if (billFlag != null && !billFlag.equals("") && billFlag.equals("0")) {
				/** 查询在线还是离线 **/
				Boolean realFlag = back8008.getControl().isOnLineBill(inDto.getContractNo(), "BILLDOWN");
				log.error("------> realFlag=" + realFlag);

				if (realFlag) {
					log.error("------> realFlag_true");

					// 在线模式，先判断是否已经冲销完成
					int writCnt = back8008.getInvoice().getWritoffCnt(contractNo);
					log.error("------> writCnt=" + writCnt);

					if (writCnt == 0) {
						//back8008.getBill().findUnbillFee(idNo, contractNo, "05", loginNo);
					}
				} else {
					log.error("------> realFlag_false");

					//back8008.getBill().findUnbillFee(idNo, contractNo, "04", loginNo);

					/** 实时冲销 **/
					long paySn = back8008.getControl().getSequence("SEQ_PAY_SN");
					Map<String, Object> inTmp = new HashMap<String, Object>();
					inTmp.put("PAY_SN", paySn);
					inTmp.put("CONTRACT_NO", contractNo);
					inTmp.put("PHONE_NO", inDto.getPhoneNo());
					inTmp.put("LOGIN_NO", loginNo);
					inTmp.put("GROUP_ID", inDto.getGroupId());
					inTmp.put("OP_CODE", inDto.getOpCode());
					inTmp.put("PAY_PATH", "11");
					inTmp.put("DELAY_FAVOUR_RATE", 0);
					inTmp.put("Header", inDto.getHeader());
					back8008.getWriteOffer().doWriteOff(inTmp);
				}
			}
		}
	}
	
}
