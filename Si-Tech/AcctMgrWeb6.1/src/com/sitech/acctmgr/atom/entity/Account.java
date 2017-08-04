package com.sitech.acctmgr.atom.entity;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSON;
import com.sitech.acctmgr.atom.domains.account.AccountListEntity;
import com.sitech.acctmgr.atom.domains.account.ConTrustEntity;
import com.sitech.acctmgr.atom.domains.account.ConUserRelEntity;
import com.sitech.acctmgr.atom.domains.account.ContractDeadInfoEntity;
import com.sitech.acctmgr.atom.domains.account.ContractEntity;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.account.CsAccountRelEntity;
import com.sitech.acctmgr.atom.domains.account.GrpConEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.jcf.core.exception.BusiException;

/**
 * <p>
 * Title: 账户类
 * </p>
 * <p>
 * Description: 取账户信息的相关方法
 * </p>
 * <p>
 * Copyright: Copyright (c) 2016
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 *
 * @author zhangbine
 * @version 1.0
 */
@SuppressWarnings({ "unchecked" })
public class Account extends BaseBusi implements IAccount {

	private IUser user;
	private IControl control;
	private IGroup group;

	@Override
	public ContractInfoEntity getConInfo(long inContractNo) {
		return this.getConInfo(inContractNo, null);
	}
	
	@Override
	public ContractInfoEntity getConInfo(long inContractNo, boolean throwFlag){
		
		return this.getConInfo(inContractNo, null, throwFlag);
	}

	@Override
	public ContractInfoEntity getConInfo(long inContractNo, String accountType) {

		return this.getConInfo(inContractNo, accountType, true);
	}
	
	private ContractInfoEntity getConInfo(long inContractNo, String accountType, boolean throwFlag) {

		long lContractNo = inContractNo; /* 入参账户标识 */

		Map<String, Object> inMap = new HashMap<String, Object>();

		inMap.put("CONTRACT_NO", lContractNo);
		if (accountType != null && !accountType.equals("")) {
			inMap.put("ACCOUNT_TYPE", accountType);
		}
		ContractInfoEntity cie = (ContractInfoEntity) baseDao.queryForObject("ac_contract_info.qAcContractInfo", inMap);
		if (cie == null && throwFlag) {
			log.debug("CONINFO NON-EXISTENT! inParam:[ " + inMap.toString() + " ]");
			throw new BusiException(AcctMgrError.getErrorCode("0000", "00003"), "查询账户信息错误！inParam:[ " + inMap.toString() + " ]");
		}else if(cie == null && !throwFlag){
			return cie;
		}

		cie.setPayCodeName(control.getParaTypeName(cie.getPayCode(), CommonConst.PAY_PARA_TYPE_ID));
		cie.setContractattTypeName(control.getParaTypeName(cie.getContractattType(), CommonConst.CONTRACT_PARA_TYPE_ID));
		cie.setBlurContractName(control.pubEncryptData(cie.getContractName(), 2));
		cie.setContractName(control.pubEncryptData(cie.getContractName(), 1));

		return cie;
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IAccount#getConDeadInfo(long) */
	@Override
	public ContractDeadInfoEntity getConDeadInfo(long inContractNo) {

		long lContractNo = inContractNo;

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", lContractNo);
		ContractDeadInfoEntity result = (ContractDeadInfoEntity) baseDao.queryForObject("ac_contractdead_info.qConDeadInfoByConNo", inMap);

		if (result == null) {
			log.debug("query ac_contractdead_info is ERROR!");
			throw new BusiException("666667", "查询离网账户信息出错");
		}

		result.setPayCodeName(control.getParaTypeName(result.getPayCode(), CommonConst.PAY_PARA_TYPE_ID));
		result.setBlurContractName(control.pubEncryptData(result.getContractName(), 2));
		result.setContractattTypeName(control.getParaTypeName(result.getContractattType(), CommonConst.CONTRACT_PARA_TYPE_ID));
		result.setContractName(control.pubEncryptData(result.getContractName(), 1));
		return result;
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.IAccount#pGetCntConUserRel(java.util.Map) */
	@Override
	public int cntConUserRel(Long contractNo, Long idNo, Integer yearMonth) {
		Map<String, Object> inMap = new HashMap<String, Object>();

		if (contractNo != null && contractNo > 0) {
			inMap.put("CONTRACT_NO", contractNo);
		}

		if (idNo != null && idNo > 0) {
			inMap.put("ID_NO", idNo);
		}
		/* if (inParam.get("BILL_ORDER") != null && !inParam.get("BILL_ORDER").equals("")) { inMap.put("BILL_ORDER", (String) inParam.get("BILL_ORDER")); } */

		if (yearMonth != null && yearMonth > 0) {
			inMap.put("YEAR_MONTH", yearMonth);
		}

		return (Integer) baseDao.queryForObject("cs_conuserrel_info.qCntOfConsrlInfoByFlag", inMap);

	}

	public boolean isDeflaultUser(long contractNo) {

		Map<String, Object> inMap = new HashMap<String, Object>();

		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("BILL_ORDER", "99999999");

		int count = (Integer) baseDao.queryForObject("cs_conuserrel_info.qCntOfConsrlInfoByFlag", inMap);

		if (count > 0) {
			return true;
		} else {
			return false;
		}
	}

	public String getDefaultPhone(long contractNo) {

		String defaultPhone = null;

		List<ContractEntity> userList = getUserList(contractNo);
		if (userList == null) {

			return null;
		}

		for (ContractEntity tmp : userList) {

			if (tmp.getBillOrder() == 99999999) {

				UserInfoEntity userEntity = user.getUserEntity(tmp.getId(), null, null, false);
				defaultPhone = userEntity.getPhoneNo();
			}
		}

		return defaultPhone;
	}

	@Override
	public String getPayPhoneByCon(long contractNo) {

		String phoneNo = "";

/*		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		Long idNo = (Long) this.baseDao.queryForObject("cs_conuserrel_info.qDefId", inMapTmp);
		if (idNo != null) {
			UserInfoEntity result = user.getUserEntity(idNo, null, null, true);
			phoneNo = result.getPhoneNo();
		}*/
		
		UserInfoEntity result = user.getUserEntityByConNo(contractNo, false);
		if(result != null){
			phoneNo = result.getPhoneNo();
		}

		return phoneNo;
	}

	@Override
	public List<ContractEntity> getConList(Long idNo, Integer yearMonth) {

		Map<String, Object> inMap = new HashMap<String, Object>();
		if (idNo <= 0) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "0000"), "无效的用户ID值");
		}
		if (idNo != null && idNo > 0) {
			safeAddToMap(inMap, "ID_NO", idNo);
		}

		List<ContractEntity> outConList = new ArrayList<ContractEntity>();
		List<ContractEntity> conList = baseDao.queryForList("cs_conuserrel_info.selectConUserList", inMap);
		if (conList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "0000"), "用户无生效付费帐户");
		}

		for (ContractEntity con : conList) {
			if (yearMonth != null && yearMonth > 0) {
				if (DateUtils.compare(Integer.toString(yearMonth), con.getEffDate(), DateUtils.DATE_FORMAT_YYYYMM) < 0
						|| DateUtils.compare(Integer.toString(yearMonth), con.getExpDate(), DateUtils.DATE_FORMAT_YYYYMM) > 0) {
					continue;
				}
			}
			con.setPayCodeName(control.getParaTypeName(con.getPayCode(), CommonConst.PAY_PARA_TYPE_ID));
			con.setAttTypeName(control.getParaTypeName(con.getAttType(), CommonConst.CONTRACT_PARA_TYPE_ID));
			con.setAccountName(control.pubEncryptData(con.getAccountName(), 2));

			if (!outConList.contains(con)) {
				outConList.add(con);
			}
		}

		return outConList;
	}

	public List<ContractEntity> getConList(Long idNo) {

		if (idNo == null || idNo <= 0) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "0000"), "无效的用户ID值");
		}

		return this.getConUserList(idNo, null);
	}

	public List<ContractEntity> getCollectionConList(Long idNo) {

		List<ContractEntity> outParamList = new ArrayList<ContractEntity>();

		List<ContractEntity> tmpList = getConList(idNo);
		for (ContractEntity conTmp : tmpList) {

			if (conTmp.getPayCode().equals(CommonConst.PAYCODE_COLLECTION)) {
				outParamList.add(conTmp);
			}
		}

		return outParamList;
	}

	public List<ContractEntity> getUserList(Long contractNo) {
		if (contractNo == null || contractNo <= 0) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "0000"), "无效的账户ID值");
		}

		return this.getConUserList(null, contractNo);
	}

	@Override
	public List<ContractEntity> getConUserList(Long idNo, Long contractNo) {
		if ((contractNo == null || contractNo <= 0) && (idNo == null || idNo <= 0) ) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "0000"), "无效的账户/用户ID值");
		}
		Map<String, Object> inMap = new HashMap<String, Object>();
		if (contractNo != null && contractNo > 0) {
			safeAddToMap(inMap, "CONTRACT_NO", contractNo);
		}
		if (idNo != null && idNo > 0) {
			safeAddToMap(inMap, "ID_NO", idNo);
		}
		safeAddToMap(inMap, "VALID", "Y");
		List<ContractEntity> outConList = new ArrayList<ContractEntity>();
		List<ContractEntity> conList = baseDao.queryForList("cs_conuserrel_info.selectConUserList", inMap);
		if (conList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "00201"), "暂未办理付费关系");
		}

		for (ContractEntity con : conList) {
			con.setPayCodeName(control.getParaTypeName(con.getPayCode(), CommonConst.PAY_PARA_TYPE_ID));
			con.setAttTypeName(control.getParaTypeName(con.getAttType(), CommonConst.CONTRACT_PARA_TYPE_ID));
			con.setAccountName(control.pubEncryptData(con.getAccountName(), 2));

			if (!outConList.contains(con)) {
				outConList.add(con);
			}
		}

		return outConList;
	}

	@Override
	public boolean isGrpCon(long contractNo) {
		Map<String, Object> inParam = new HashMap<String, Object>();
		inParam.put("CONTRACT_NO", contractNo);
		int cnt = (Integer) baseDao.queryForObject("ac_contract_info.qCntGrpAcct", inParam);
		if (cnt > 0) {
			return true;
		} else {
			return false;
		}
	}

	public List<CsAccountRelEntity> getAccountRelList(long contractNo, String acctRelType, String flag) {

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		if (acctRelType != null) {
			inMap.put("ACCT_REL_TYPE", acctRelType);
		}
		if (flag.equals("1")) {
			inMap.put("CONTRACTATT_TYPES", PayBusiConst.YDZF_CONTRACTTYPE);
		} else if (flag.equals("2")) {
			inMap.put("CONTRACTATT_TYPES", PayBusiConst.YDZFORJTZH_CONTRACTTYPE);
		}
		List<CsAccountRelEntity> result = baseDao.queryForList("cs_account_rel.qrRelConBy8020", inMap);

		return result;
	}

	@Override
	public ConTrustEntity getContrustInfo(long contractNo) {

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		ConTrustEntity collConEnt = (ConTrustEntity) baseDao.queryForObject("ac_contrust_info.qByCon", inMap);

		return collConEnt;
	}

	@Override
	public List<ContractInfoEntity> getGrpConInfo(Long unitId, Long custId, Long contractNo) {

		List<ContractInfoEntity> outParamList = new ArrayList<ContractInfoEntity>();

		Map<String, Object> inMapTmp = null;
		// Map<String, Object> outMapTmp = null;

		inMapTmp = new HashMap<String, Object>();
		if (contractNo != null && contractNo > 0) {
			safeAddToMap(inMapTmp, "CONTRACT_NO", contractNo);
		}
		if (unitId != null && unitId > 0) {
			safeAddToMap(inMapTmp, "UNIT_ID", unitId);
		}
		if (custId != null && custId > 0) {
			safeAddToMap(inMapTmp, "CUST_ID", custId);
		}
		log.debug("参数：" + inMapTmp);
		List<ContractInfoEntity> conList = (List<ContractInfoEntity>) baseDao.queryForList("ac_contract_info.qryGrpAcctInfo", inMapTmp);
		for (ContractInfoEntity conEntity : conList) {

			conEntity.setBlurContractName(control.pubEncryptData(conEntity.getContractName(), 2));

			// 获取支付类型名称
			conEntity.setPayCodeName(control.getParaTypeName(conEntity.getPayCode(), CommonConst.PAY_PARA_TYPE_ID));

			// 获取账户属性类型名称CONTRACTATT_NAME
			conEntity.setContractattTypeName(control.getParaTypeName(conEntity.getContractattType(), CommonConst.CONTRACT_PARA_TYPE_ID));

			outParamList.add(conEntity);
		}

		return outParamList;
	}

	public ContractInfoEntity getAgtInfo(String phoneNo) {
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		safeAddToMap(inMapTmp, "AGT_PHONE_NO", phoneNo);

		ContractInfoEntity cie = (ContractInfoEntity) baseDao.queryForObject("ac_contract_info.qryAgtCon", inMapTmp);
		if (cie == null) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "10074"), "代理商不存在！");
		}

		return cie;
	}

	@Override
	public GrpConEntity getGrpConInfo(long contractNo) {
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		Map<String, Object> outMapTmp = new HashMap<String, Object>();
		GrpConEntity gce = new GrpConEntity();
		safeAddToMap(inMapTmp, "CONTRACT_NO", contractNo);
		ContractInfoEntity cie = (ContractInfoEntity) baseDao.queryForObject("ac_contract_info.qryGrpAcctInfo", inMapTmp);
		if(cie!=null) {
			long custId = cie.getCustId();
			long unitId = cie.getUnitId();

			safeAddToMap(inMapTmp, "CUST_ID", custId);
			CustInfoEntity custEntity = (CustInfoEntity) baseDao.queryForObject("ct_cust_info.qCustInfo", inMapTmp);
			String unitName = control.pubEncryptData(custEntity.getCustName(), 2);
			String custLevel = custEntity.getCustLevel();

			String staffLogin = (String) baseDao.queryForObject("ct_custmanager_rel.qContactLogin", inMapTmp);

			safeAddToMap(inMapTmp, "LOGIN_NO", staffLogin);
			LoginEntity le = (LoginEntity) baseDao.queryForObject("bs_loginmsg_dict.qByLoginNo", inMapTmp);
			String staffName = le.getLoginName();

			gce.setCustId(custId);
			gce.setStaffLogin(staffLogin);
			gce.setStaffLoginName(staffName);
			gce.setUnitId(unitId);
			gce.setUnitName(unitName);
			gce.setCustLevel(custLevel);
		}

		return gce;
	}

	@Override
	public List<ContractInfoEntity> getContractInfo(long custId) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CUST_ID", custId);
		List<ContractInfoEntity> conList = baseDao.queryForList("ac_contract_info.qAcContractInfo", inMap);
		return conList;
	}

	@Override
	public List<AccountListEntity> getAccountByIDICCID(String sIdIccid) {
		Map<String, Object> inParam = new HashMap<String, Object>();
		inParam.put("ID_ICCID", sIdIccid);
		List<AccountListEntity> resultList = new ArrayList<AccountListEntity>();
		List<Map<String, Object>> conList = baseDao.queryAllDbList("ac_contract_info.qConByIccid", inParam);

		for (Map<String, Object> conEnt : conList) {
			long contractNo = ValueUtils.longValue(conEnt.get("CONTRACT_NO"));
			String sConName = conEnt.get("CONTRACT_NAME").toString();
			String sConEncryName = control.pubEncryptData(sConName, 2);
			String unCodeName = control.pubEncryptData(sConName, 1);

			Map<String, Object> outMap = new HashMap<String, Object>();
			outMap.put("CONTRACT_NO", contractNo);
			outMap.put("CONTRACT_NAME", sConEncryName);
			outMap.put("UNCODE_NAME", unCodeName);
			outMap.put("CONTRACTATT_TYPE", conEnt.get("CONTRACTATT_TYPE"));
			String jsonStr = JSON.toJSONString(outMap);

			resultList.add(JSON.parseObject(jsonStr, AccountListEntity.class));
		}
		return resultList;
	}
	
	@Override
	public long getTDNum(long idNo) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", idNo);
		long TDNum = (long) baseDao.queryForObject("bs_chngroup_dict.qTDNum", inMap);

		return TDNum;
	}

	@Override
	public long getTDCon(long idNo) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", idNo);
		long TDCon = (long) baseDao.queryForObject("ur_usergroupmbr_info.qTDCon", inMap);

		return TDCon;
	}
	
	@Override
	public ConUserRelEntity getConUserRelInfo(long inContractNo,long idNo) {

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", inContractNo);
		inMap.put("ID_NO", idNo);
		ConUserRelEntity result = (ConUserRelEntity) baseDao.queryForObject("cs_conuserrel_info.qConuserrelInfo", inMap);

		return result;
	}

	@Override
	public ContractInfoEntity getConInfo(Map<String, Object> inMap) {
		ContractInfoEntity conInfo = (ContractInfoEntity) baseDao.queryForObject("ac_contract_info.qAcContractInfo", inMap);
		return conInfo;
	}

	public IUser getUser() {
		return user;
	}

	public void setUser(IUser user) {
		this.user = user;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}
}
