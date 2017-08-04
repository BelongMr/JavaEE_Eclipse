package com.sitech.acctmgr.atom.busi.pay.backfee;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.user.UserPrcEntity;
import com.sitech.acctmgr.atom.impl.pay.S8008;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.jcf.core.exception.BaseException;
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
public class BackFeeON extends BackFeeType {

	/**
	 * @paramer back8008
	 */
	public BackFeeON(S8008 inBack8008) {
		super(inBack8008);
	}
	
	/*个性化业务验证*/
	public void checkSpecialBusiness(Map<String, Object> inMap){	
		String phoneNo = (String)inMap.get("PHONE_NO");
		boolean isBroad = back8008.getUser().isBroadbandPhone(phoneNo);
		long idNo = (long)inMap.get("ID_NO");
		String userOnNet = (String)inMap.get("USER_ON_NET");
		String provinceId = (String)inMap.get("PROVINCE_ID");
		String groupId = (String)inMap.get("GROUP_ID");
		String brandId = (String)inMap.get("BRAND_ID");
		String prcId = (String)inMap.get("PRC_ID");
		log.info("prcId--------------->"+prcId);
		List<String> list= Arrays.asList(PayBusiConst.SZX_PRCID);
		//标准神州行用户,不允许做此业务
		if (list.contains(prcId)) {
			throw new BaseException(AcctMgrError.getErrorCode("8008", "00007"), "标准神州行用户,不允许做此业务!");
		}

		//账户品牌为行业应用流量包（brandId=’2310LL’）不允许退预存款
		if (brandId.equals("2310LL")) {
			throw new BaseException(AcctMgrError.getErrorCode("8008", "00009"), "集团行业流量包产品不允许退预存款!");
		}
		
		//退预存款限额验证，只有区县级工号以及县级以下工号才能退预存款，地市级工号以及地市级以上工号不能退预存款
		this.checkLimtFeeDistrict(groupId,provinceId);
		//宽带号验证
		if(!userOnNet.equals("4")){//宽带退预存不做校验
			if(isBroad){
				throw new BusiException(AcctMgrError.getErrorCode("8008","00017"), "号码为宽带号码，无法退费!");
			}
		}
	}
	
	/*地市日限额验证和区县日限额验证*/
	public void checkRegionDistrict(String regionGroup,String limitType,long backMoney,String districtGroup){
		Map<String,Object> rMsgForm = new HashMap<String,Object>();
		Map<String,Object> cMsgForm = new HashMap<String,Object>();
		
		rMsgForm.put("REGION_GROUP", regionGroup);
		rMsgForm.put("LIMIT_TYPE", limitType);
		rMsgForm.put("TRANS_FEE", backMoney);
		
		cMsgForm.put("REGION_GROUP", regionGroup);
		cMsgForm.put("LIMIT_TYPE", limitType);
		cMsgForm.put("TRANS_FEE", backMoney);
		cMsgForm.put("DISTRICT_GROUP", districtGroup);
		
		//地市日限额验证
		back8008.getLimitFee().regionDayLimit(rMsgForm);
		
		//更新地市限额信息
		back8008.getLimitFee().updateMonthRegionLimit(backMoney,regionGroup,limitType);
		back8008.getLimitFee().updateDayRegionLimit(backMoney,regionGroup,limitType);
		
		//区县日限额验证
		back8008.getLimitFee().districtDayLimit(cMsgForm);
		
		//更新区县日限额信息
		back8008.getLimitFee().updateMonthDistrictLimit(backMoney,regionGroup,limitType,districtGroup);
		back8008.getLimitFee().updateDayDistrictLimit(backMoney,regionGroup,limitType,districtGroup);
	
	}
	
	//判断数组是否存在某值
	public static boolean useList(String[] arr,String targetValue){
		return Arrays.asList(arr).contains(targetValue);
	}
 
	
	//在网退预存：getBaseInfo 复用backFeeType
	
	//在网退预存：getBackFeeFinal 复用backFeeType

}
