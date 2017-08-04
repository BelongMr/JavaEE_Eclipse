package com.sitech.acctmgr.atom.entity;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.cust.CtCustContactEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.cust.GrpCustEntity;
import com.sitech.acctmgr.atom.domains.cust.GrpCustInfoEntity;
import com.sitech.acctmgr.atom.domains.cust.PersonalCustEntity;
import com.sitech.acctmgr.atom.domains.cust.TaxPayerInfo;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;

/**
 * <p>
 * Title: 客户类
 * </p>
 * <p>
 * Description: 取客户信息的相关方法
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
public class Cust extends BaseBusi implements ICust {

	private IControl control;

	@Override
	public CustInfoEntity getCustInfo(Long custId, String idIccid) {
		Map<String, Object> inMap = new HashMap<>();

		if (custId != null && custId > 0) {
			safeAddToMap(inMap, "CUST_ID", custId);
		}
		if (StringUtils.isNotEmpty(idIccid)) {
			safeAddToMap(inMap, "ID_ICCID", idIccid);
		}

		CustInfoEntity result = (CustInfoEntity) baseDao.queryForObject("ct_cust_info.qCustInfo", inMap);

		if (result == null) {
			log.debug("CUSTINFO NON-EXISTENT! inParam:[ " + inMap.toString() + " ]");
			throw new BusiException(AcctMgrError.getErrorCode("0000", "00003"), "查询客户信息错误！inParam:[ " + inMap.toString() + " ]");
		}

		custId = result.getCustId();
		String sCustName = result.getCustName();
		result.setBlurCustName(control.pubEncryptData(sCustName, 2));
		result.setCustName(control.pubEncryptData(sCustName, 1));
		result.setIdIccid(control.pubEncryptData(result.getIdIccid(), 1));
		result.setIdAddress(control.pubEncryptData(result.getIdAddress(), 1));
		result.setCustAddress(control.pubEncryptData(result.getCustAddress(), 1));
		result.setIdTypeName(control.getParaTypeName(result.getIdType(), CommonConst.IDTYPE_PARA_TYPE_ID));
		result.setCustTypeName(control.getParaTypeName(result.getTypeCode() + "", CommonConst.TYPE_CODE_PARA_TYPE_ID));
		result.setCustLevelName(control.getParaTypeName(result.getCustLevel(), CommonConst.CUST_LEVEL_PARA_TYPE_ID));

		result.setEmTel(this.getCustEmTel(custId)); // 紧急联系人电话

		return result;
	}

	private String getCustEmTel(Long custId) {

		Map<String, Object> inMap = new HashMap<>();

		safeAddToMap(inMap, "CUST_ID", custId);

		String emTel = (String) baseDao.queryForObject("ct_adcgrpcust_info.qCustContactPhone", inMap);

		return StringUtils.isEmpty(emTel) ? "NULL" : emTel;
	}

	@Override
	public GrpCustInfoEntity getGrpCustInfo(Long custId, Long unitId) {

		Map<String, Object> inMap = new HashMap<>();

		if (custId != null && custId > 0) {
			safeAddToMap(inMap, "CUST_ID", custId);
		}
		if (unitId != null && unitId > 0) {
			safeAddToMap(inMap, "UNIT_ID", unitId);
		}

		GrpCustInfoEntity result = (GrpCustInfoEntity) baseDao.queryForObject("ct_grpcust_info.qGrpcustInfo", inMap);

		if (result == null) {
			log.debug("GRPCUSTINFO NON-EXISTENT! inParam:[ " + inMap.toString() + " ]");
			throw new BusiException(AcctMgrError.getErrorCode("0000", "00003"), "查询集团客户信息错误！inParam:[ " + inMap.toString() + " ]");
		}

		// 模糊化客户名称
		// outMap.put("BLUR_CUSTNAME", control.pubEncryptData((String)outMap.get("CUST_NAME"),2));

		return result;
	}

	@Override
	public List<GrpCustEntity> getGrpCustList(Long custId, Long unitId, String idIccid) {
		if (custId == null && unitId == null && org.apache.commons.lang.StringUtils.isEmpty(idIccid)) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "00081"), "集团客户，集团编码，证件号码不能全为空");
		}

		Map<String, Object> inMap = new HashMap<>();

		if (custId != null && custId > 0) {
			safeAddToMap(inMap, "CUST_ID", custId);
		}
		if (unitId != null && unitId > 0) {
			safeAddToMap(inMap, "UNIT_ID", unitId);
		}

		if (StringUtils.isNotEmpty(idIccid)) {
			safeAddToMap(inMap, "ID_ICCID", idIccid);
		}

		List<GrpCustEntity> result = (List<GrpCustEntity>) baseDao.queryForList("ct_grpcust_info.qGrpCustList", inMap);

		if (result == null || result.size() == 0) {
			log.debug("GRPCUSTINFO NON-EXISTENT! inParam:[ " + inMap.toString() + " ]");
			throw new BusiException(AcctMgrError.getErrorCode("0000", "00082"), "集团客户信息不存在");
		}

		for (GrpCustEntity grpCustEnt : result) {
			String sCustName = grpCustEnt.getCustName();
			grpCustEnt.setCustName(control.pubEncryptData(sCustName, 1));
			grpCustEnt.setIdIccid(control.pubEncryptData(grpCustEnt.getIdIccid(), 1));
			grpCustEnt.setIdTypeName(control.getParaTypeName(grpCustEnt.getIdType(), CommonConst.IDTYPE_PARA_TYPE_ID));
		}

		return result;

	}

	@Override
	public String getGrpContactStaff(Long custId) {
		Map<String, Object> inMap = new HashMap<>();
		safeAddToMap(inMap, "CUST_ID", custId);
		String staffLogin = (String) baseDao.queryForObject("ct_custmanager_rel.qContactLogin", inMap);

		return staffLogin;
	}

	@Override
	public TaxPayerInfo getTaxPayerInfo(long custId, String taxPayerId) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		if (custId > 0) {
			inMap.put("CUST_ID", custId);
		}
		if (StringUtils.isNotEmpty(taxPayerId)) {
			inMap.put("TAX_PAYER_ID", taxPayerId);
		}

		TaxPayerInfo taxPayerInfo = (TaxPayerInfo) baseDao.queryForObject("ct_taxpayer_info.qTaxPayerInfo", inMap);
		return taxPayerInfo;
	}
	
	public CtCustContactEntity getContactEnt(long custId){
		Map<String,Object> inMap = new HashMap<String,Object>();
		inMap.put("CUST_ID", custId);
		CtCustContactEntity custEnt = (CtCustContactEntity) baseDao.queryForObject("ct_custcontact_info.CtCustInfo", inMap);
		return custEnt;
	}
	
	@Override
	public PersonalCustEntity getPersonalCust(long custId){
		Map<String,Object> inMap = new HashMap<String,Object>();
		inMap.put("CUST_ID", custId);
		PersonalCustEntity custEnt = (PersonalCustEntity) baseDao.queryForObject("ct_personalcust_info.qry", inMap);
		if(custEnt!=null) {
			custEnt.setSexCode(control.getParaTypeName(custEnt.getSexCode(), 7));
			custEnt.setProfessionId(control.getParaTypeName(custEnt.getProfessionId(), 4000));
			custEnt.setWorkCode(control.getParaTypeName(custEnt.getWorkCode(), 35));
		}
		return custEnt;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

}
