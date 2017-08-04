package com.sitech.acctmgr.atom.busi.pay.backfee;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.account.ContractDeadInfoEntity;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.pay.BalanceNBEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.user.UserBrandEntity;
import com.sitech.acctmgr.atom.domains.user.UserDeadEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.impl.pay.S8008;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.jcf.core.exception.BusiException;

/**
 * @Title: []
 * @Description:
 * @Date : 2016年3月15日上午9:00:34
 * @Company: SI-TECH
 * @author : LIJXD
 * @version : 1.0
 * @modify history
 *         <p>
 *         修改日期 修改人 修改目的
 *         <p>
 */
public class BackFeeXH extends BackFeeType{

	/**
	 * @paramer back8008
	 */
	public BackFeeXH(S8008 inBack8008) {
		super(inBack8008);
	}

 

	// 销户退预存：getBaseInfo重写
	public Map<String, Object> getBaseInfo(String phoneNo, long contractNo, String provinceId) {
		Map<String, Object> inTmpMap = null;
		
		String contractName = "";
		String brandId = "";
		long idNo = 0;
		long custId = 0;
		String userGroup = "";

		Map<String, Object> outMap = new HashMap<String, Object>();

		/** (销户退预存）查询 */
		log.info("----------> 8008base_xh");

		// 用户验证
		try {
			UserInfoEntity userInfo = back8008.getUser().getUserInfo(phoneNo);
			idNo = userInfo.getIdNo();
			custId = userInfo.getCustId();
			brandId = userInfo.getBrandId();
			userGroup = userInfo.getGroupId();

			if (contractNo == 0) {
				contractNo = userInfo.getContractNo();
			}
		} catch (Exception e) {
			log.info("------>3户已经离网：" + phoneNo);
			inTmpMap = new HashMap<String, Object>();
			inTmpMap.put("PHONE_NO", phoneNo);
			inTmpMap.put("CONTRACT_NO", contractNo);
			List<UserDeadEntity> userDeadList = back8008.getUser().getUserdeadEntity(phoneNo, null, contractNo);

			idNo = userDeadList.get(0).getIdNo();
			custId = userDeadList.get(0).getCustId();
			userGroup = userDeadList.get(0).getGroupId();
		}
	 
		try{
			UserBrandEntity  brandEnt = back8008.getUser().getUserBrandRel(idNo);
			brandId = brandEnt.getBrandId();
		}catch(Exception e){
			log.error("------>id_no无品牌：" + idNo);
			brandId = "2200xx";
		}
	
		
		// 账户验证
		try {
			// 取账户对应默认用户
			ContractInfoEntity conEnt = back8008.getAccount().getConInfo(contractNo);
			contractName = conEnt.getBlurContractName();

		} catch (BusiException e) {
			log.info("------>3已经离网：" + contractNo);

			inTmpMap = new HashMap<String, Object>();
			inTmpMap.put("CONTRACT_NO", contractNo);
			ContractDeadInfoEntity conEnt = back8008.getAccount().getConDeadInfo(contractNo);
			contractName = conEnt.getBlurContractName();
		}


		userGroup = ("".equals(userGroup) ? "0" : userGroup);

		// 取用户地市归属
		ChngroupRelEntity groupEnt = back8008.getGroup().getRegionDistinct(userGroup, "2", provinceId);
		String regionId = groupEnt.getRegionCode();
		
		// 出参
		PayUserBaseEntity userInfo = new PayUserBaseEntity();
		userInfo.setBrandId(brandId);
		userInfo.setContractNo(contractNo);
		userInfo.setIdNo(idNo);
		userInfo.setCustId(custId);
		userInfo.setPhoneNo(phoneNo);
		userInfo.setRegionId(regionId);
		userInfo.setUserGroupId(userGroup);	
		outMap.put("USER_BASE_INFO", userInfo);
		outMap.put("CONTRACT_NAME", contractName);
		outMap.put("CONTRACTATT_TYPE", "");
		log.info("----->getBaseInfo_end = "+outMap.toString());

		return outMap;
	}
	
	/**
	 * 名称：
	 * 
	 * @param payType
	 * @return payType
	 */
	public String getPayType(String opType, String payType) {
		return "";
	}
	
	/**
	 * 名称：销户退预存：金额*-1
	 * 
	 * @param
	 * @return
	 * @throws Exception
	 * @author LIJXD
	 */
	public long getPayMoney(long payMoney) {
		long backMoney =  -1 * payMoney;
		log.info("------> 销户退预存款,ifOnNet=3, 传入金额为负,需要转换 : payMoney=" + payMoney);

		if (backMoney < 0) {
			log.error("----->退还金额不能小于(必须大于等于)0！");
			throw new BusiException(AcctMgrError.getErrorCode("8008", "00005"), "退还金额不能小于0！");
		}

		return backMoney;
	}
	
	/**
	 * 名称：离网不可退预存列表
	 * 
	 * @param contractNo
	 *            账户
	 * @return List<BalanceNBEntity>
	 * @author LIJXD
	 */
	public List<BalanceNBEntity> getNoBackList(long contractNo) {
		return null;
	}
	
	/* 个性化业务验证 */
	public void checkSpecialBusiness(Map<String, Object> inMap){
		
	}
	
	/* 地市日限额验证 */
	public void checkRegionDistrict(String regionGroup,String limitType,long backMoney,String districtGroup){

	}
	
}
