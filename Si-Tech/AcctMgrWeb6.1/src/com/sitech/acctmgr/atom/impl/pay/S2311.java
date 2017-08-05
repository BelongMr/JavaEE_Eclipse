package com.sitech.acctmgr.atom.impl.pay;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSON;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.pay.BatchPayRecdEntity;
import com.sitech.acctmgr.atom.domains.pay.GiveInfoEntity;
import com.sitech.acctmgr.atom.domains.pay.MonthReturnFeeEntity;
import com.sitech.acctmgr.atom.dto.pay.S2311CfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.S2311CfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S2311DetailInDTO;
import com.sitech.acctmgr.atom.dto.pay.S2311DetailOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.inter.pay.I2311;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
 *
 * <p>
 * Title: 手工系统充值查询
 * </p>
 * <p>
 * Description:
 * </p>
 * <p>
 * Copyright: Copyright (c) 2014
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 * 
 * @author hanfl
 * @version 1.0
 */
@ParamTypes({ @ParamType(c = S2311CfmInDTO.class, oc = S2311CfmOutDTO.class, m = "cfm"),
		@ParamType(c = S2311DetailInDTO.class, oc = S2311DetailOutDTO.class, m = "detail") })
public class S2311 extends AcctMgrBaseService implements I2311 {

	protected IBalance balance;
	private ILogin login;

	@Override
	public OutDTO cfm(InDTO inParam) {

		S2311CfmInDTO inDto = (S2311CfmInDTO) inParam;
		log.info("-------> 2311cfm_in " + inDto.getMbean());

		Map<String, Object> inAuditMap = new HashMap<String, Object>();

		String[] qryFlagS = null;
		String opCode = inDto.getOpCode();
		if("2310".equals(opCode)){
			qryFlagS = new String[] { "N"};
		}else if("2311".equals(opCode)){
			qryFlagS = new String[] { "N", "Y", "X", "S", "C", "F", "B" };
		}
		
		log.error("------> qryFlagS = " + qryFlagS);

		// 查询所有未审批带入记录(默认查询所有未审核记录)
		inAuditMap = new HashMap<String, Object>();
		safeAddToMap(inAuditMap, "AUDIT_FLAG", qryFlagS);

		safeAddToMap(inAuditMap, "BEGIN_DATE", inDto.getBeginDate());
		safeAddToMap(inAuditMap, "END_DATE", inDto.getEndDate());
		safeAddToMap(inAuditMap, "LOGIN_NO", inDto.getOpLoginNo());
		safeAddToMap(inAuditMap, "REGION_CODE", inDto.getRegionCode());
		safeAddToMap(inAuditMap, "ACT_TYPE", "A");

		List<BatchPayRecdEntity> batchpayList = balance.getBatchpayRecd(inAuditMap, "A");

		S2311CfmOutDTO outDto = new S2311CfmOutDTO();
		outDto.setSendList(batchpayList);
		log.error("------> 2311cfm_out" + outDto.toJson());
		return outDto;
	}

	@Override
	public OutDTO detail(InDTO inParam) {
		// TODO Auto-generated method stub
		S2311DetailInDTO inDto = (S2311DetailInDTO) inParam;
		log.info("-------> 2311detail_in " + inDto.getMbean());

		String qryDate = inDto.getInputTime();
		long batchSn = inDto.getBatchSn();

		Map<String, Object> inDetailMap = new HashMap<String, Object>();
		safeAddToMap(inDetailMap, "BATCH_SN", batchSn);
		safeAddToMap(inDetailMap, "OP_DATE", qryDate.substring(0, 8));
		MonthReturnFeeEntity monthReturnFee = balance.getMonthReturnFeeDeail(inDetailMap);
		
		LoginEntity  loginEntity =login.getLoginInfo(monthReturnFee.getLoginNo(), "230000");
		monthReturnFee.setLoginName(loginEntity.getLoginName());
		
		
		if(!"未审核".equals(monthReturnFee.getActName())){
			loginEntity =login.getLoginInfo(monthReturnFee.getAuditLogin(), "230000");
			monthReturnFee.setAuditLoginName(loginEntity.getLoginName());
		}
		
		S2311DetailOutDTO outDto = new S2311DetailOutDTO();
		outDto.setMonthReturnFee(monthReturnFee);
		log.error("------> detail_out" + outDto.toJson());
		return outDto;
	}

	public IBalance getBalance() {
		return balance;
	}

	public ILogin getLogin() {
		return login;
	}

	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	public void setLogin(ILogin login) {
		this.login = login;
	}
	
	
}