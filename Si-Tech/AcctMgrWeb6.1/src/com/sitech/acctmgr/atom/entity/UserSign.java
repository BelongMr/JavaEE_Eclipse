package com.sitech.acctmgr.atom.entity;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.balance.SignAutoPayEntity;
import com.sitech.acctmgr.atom.domains.base.LoginBaseEntity;
import com.sitech.acctmgr.atom.domains.pay.AutoPayFieldEntity;
import com.sitech.acctmgr.atom.domains.pay.FieldEntity;
import com.sitech.acctmgr.atom.domains.pay.UserSignInfoEntity;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.entity.inter.IGoods;
import com.sitech.acctmgr.atom.entity.inter.IUserSign;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.jcf.core.dao.BaseDao;
import com.sitech.jcf.core.exception.BusiException;

/**
 *
 * <p>Title:   </p>
 * <p>Description:   </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author 
 * @version 1.0
 */
public class UserSign extends BaseBusi implements IUserSign {
	
	private IGoods	goods;


	public boolean isSign(long idNo, String busiType) {
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", idNo);
		inMap.put("BUSI_TYPE", busiType);
		Integer result = (Integer)baseDao.queryForObject("bal_usersign_info.qCnt", inMap);
		if(result != null && result > 0){
			return true;
		}else{
			return false;
		}
	}
	
	public int isZdzSign(long idNo){
		
		int flag = 0;
		
		//判断是否总队总主号签约
		boolean zhFlag = goods.isOrderGoods(idNo, CommonConst.ZDZ_PRC_ID);
		if(zhFlag){
			flag = 1;
		}
		
		//判断是否总队总副号签约
		
		
		return flag;
	}
	
	public boolean saveSignInfo(UserSignInfoEntity userSign, LoginBaseEntity loginBase){
		
		List<FieldEntity> fieldList = userSign.getSignFieldList();
		
		userSign.setLoginNo(loginBase.getLoginNo());
		userSign.setOpCode(loginBase.getOpCode());
		userSign.setRemark(loginBase.getOpNote());
		baseDao.insert("bal_usersign_info.iSignInfo", userSign);
		
		for(FieldEntity fieldTmp : fieldList){
			
			Map<String, Object> inMap = new HashMap<String, Object>();
			inMap.put("ID_NO", userSign.getIdNo());
			inMap.put("BUSI_TYPE", userSign.getBusiType());
			inMap.put("FIELD_CODE", fieldTmp.getFieldCode());
			inMap.put("FIELD_VALUE", fieldTmp.getFieldValue());
			inMap.put("OTHER_VALUE", fieldTmp.getOtherValue());
			inMap.put("FINISH_FLAG", userSign.getSignFlag());
			inMap.put("LOGIN_NO", loginBase.getLoginNo());
			inMap.put("LOGIN_ACCEPT", userSign.getLoginAccept());
			inMap.put("OP_CODE", loginBase.getOpCode());
			baseDao.insert("bal_usersignadd_info.iSignaddInfo", inMap);
		}
		
		return true;
	}
	
	
	public  boolean deleteSignInfo(long idNo, String busiType, Map<String, Object> updateInfo){
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("UPDATE_ACCEPT", updateInfo.get("UPDATE_ACCEPT"));
		inMap.put("UPDATE_TYPE", "D");
		inMap.put("UPDATE_DATE", updateInfo.get("UPDATE_DATE"));
		inMap.put("UPDATE_LOGIN", updateInfo.get("UPDATE_LOGIN"));
		inMap.put("UPDATE_CODE", updateInfo.get("UPDATE_CODE"));
		inMap.put("ID_NO", idNo);
		inMap.put("BUSI_TYPE", busiType);
		baseDao.insert("bal_usersign_info_his.iSignInfoHis", inMap);
		
		Map<String, Object> delMap = new HashMap<String, Object>();
		delMap.put("ID_NO", idNo);
		delMap.put("BUSI_TYPE", busiType);
		baseDao.delete("bal_usersign_info.delSignInfo", delMap);
		
		//属性表
		baseDao.insert("bal_usersignadd_info_his.iSignaddInfoHis", inMap);
		baseDao.delete("bal_usersignadd_info.delSignaddInfo", delMap);
		
		return true;
	}
	

	public UserSignInfoEntity getUserSignInfo(long idNo){
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", idNo);
		inMap.put("SIGN_FLAG", "0");
		UserSignInfoEntity result = (UserSignInfoEntity)baseDao.queryForObject("bal_usersign_info.qUserSignInfo", inMap);
		
		return result;
	}
	
	public String getSignAddInfo(long idNo, String busiType, String fieldCode){
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", idNo);
		inMap.put("BUSI_TYPE", busiType);
		inMap.put("FIELD_CODE", fieldCode);
		String filedValue = baseDao.queryForObject("bal_usersignadd_info.qry", inMap).toString();
		
		return filedValue;
	}
	
	public List<Map<String, Object>> getUserSignAddInfo(long idNo, String busiType, Long loginAccept){
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", idNo);
		inMap.put("BUSI_TYPE", busiType);
		if(loginAccept != null){
			inMap.put("LOGIN_ACCEPT", loginAccept);
		}
		return (List<Map<String, Object>>)baseDao.queryForList("bal_usersignadd_info.qSignaddInfo", inMap);
	}

	public boolean isAutoPay(long idNo){
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", idNo);
		Integer result = (Integer)baseDao.queryForObject("bal_signautopay_info.qCnt", inMap);
		if(result != null && result > 0){
			return true;
		}else{
			return false;
		}
	}
	
	public boolean isAlipay(long idNo){
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", idNo);
		inMap.put("BUSI_TYPE", "1003");
		Integer result = (Integer)baseDao.queryForObject("bal_signautopay_info.qCnt", inMap);
		if(result != null && result > 0){
			return true;
		}else{
			return false;
		}
	}
	
	public int uAutoPay(long idNo, Long payMoney, Long balanceLimit, String autoFlag, Map<String, Object> inParam){
		
		Map<String, Object> inMap1 = new HashMap<String, Object>();
		inMap1.put("ID_NO", idNo);
		inMap1.putAll(inParam);
		baseDao.insert("bal_signautopay_his.iAutoPayHis", inMap1);
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", idNo);
		inMap.put("LOGIN_NO", inParam.get("UPDATE_LOGIN"));
		if(payMoney != null){
			inMap.put("PAY_MONEY", payMoney);
		}
		if(balanceLimit != null){
			inMap.put("BALANCE_LIMIT", balanceLimit);
		}
		if(autoFlag != null){
			inMap.put("AUTO_FLAG", autoFlag);
		}
		int cnt = baseDao.update("bal_signautopay_info.uByIdno", inMap);
/*		if(cnt != 1){
			
			throw new BusiException(AcctMgrError.getErrorCode("0000","00074"), "修改自动缴费属性出错!id: " + idNo);
		}*/
		
		return cnt;
	}
	
	public void inAutoPay(UserSignInfoEntity userSignInfo, AutoPayFieldEntity autoPayField){
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", userSignInfo.getIdNo());
		inMap.put("PHONE_NO", userSignInfo.getPhoneNo());
		inMap.put("BUSI_TYPE", userSignInfo.getBusiType());
		inMap.put("PAY_MONEY", autoPayField.getPayMoney());
		inMap.put("BALANCE_LIMIT", autoPayField.getBalanceLimit());
		inMap.put("AUTO_FLAG", autoPayField.getAutoFlag());
		inMap.put("PAY_DAY", autoPayField.getPayDay());
		inMap.put("LOGIN_NO", userSignInfo.getLoginNo());
		inMap.put("OP_TIME", userSignInfo.getOpTime());
		baseDao.insert("bal_signautopay_info.iAutoPay", inMap);
		
	}
	
	public SignAutoPayEntity getAutoPay(long idNo){
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", idNo);
		SignAutoPayEntity result = (SignAutoPayEntity)baseDao.queryForObject("bal_signautopay_info.qry", inMap);

		return result;
	}
	
	public boolean deleteAutoPayInfo(long idNo, String busiType, Map<String, Object> inParam) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", idNo);
		inMap.putAll(inParam);
		baseDao.insert("bal_signautopay_his.iAutoPayHis", inMap);
		
		Map<String, Object> delMap = new HashMap<String, Object>();
		delMap.put("ID_NO", idNo);
		delMap.put("BUSI_TYPE", busiType);
		baseDao.delete("bal_signautopay_info.delSignaddInfo", delMap);
		
		return true;
	}
	
	public String getAlipayLoginNo(String groupId){
		
		Map<String,Object> inMap = new HashMap<String,Object>();
		inMap.put("GROUP_ID", groupId);
		inMap.put("CODE_CLASS", "2510");
		PubCodeDictEntity alipayEnt= (PubCodeDictEntity)baseDao.queryForObject("pub_codedef_dict.qVision", inMap);
		String loginNo = alipayEnt.getCodeValue();
		
		return loginNo;
	}
	
	public Map<String,Object> getAlipaySign(String groupId,String loginNo){
		
		Map<String,Object> inMap = new HashMap<String,Object>();
		inMap.put("GROUP_ID", groupId);
		inMap.put("CODE_ID", loginNo);
		inMap.put("CODE_CLASS", "2510");
		
		PubCodeDictEntity alipayEnt= (PubCodeDictEntity)baseDao.queryForObject("pub_codedef_dict.qVision", inMap);
		Map<String,Object> outMap = new HashMap<String,Object>();
		outMap.put("PARTNER", alipayEnt.getCodeName());
		outMap.put("SECRET", alipayEnt.getCodeValue());
		
		return outMap;
	}
	
	
	public IGoods getGoods() {
		return goods;
	}

	public void setGoods(IGoods goods) {
		this.goods = goods;
	}
	
}
