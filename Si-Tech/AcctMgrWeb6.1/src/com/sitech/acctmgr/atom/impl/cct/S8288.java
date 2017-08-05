package com.sitech.acctmgr.atom.impl.cct;

import java.util.Date;

import com.sitech.acctmgr.atom.domains.cct.GrpCreditEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.cust.GrpCustInfoEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.dto.cct.S8288GrpCfmInDTO;
import com.sitech.acctmgr.atom.dto.cct.S8288GrpCfmOutDTO;
import com.sitech.acctmgr.atom.dto.cct.S8288GrpInitInDTO;
import com.sitech.acctmgr.atom.dto.cct.S8288GrpInitOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICredit;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.inter.cct.I8288;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

@ParamTypes({ 
	@ParamType(c = S8288GrpInitInDTO.class,oc=S8288GrpInitOutDTO.class, m = "grpInit"),
	@ParamType(c = S8288GrpCfmInDTO.class,oc=S8288GrpCfmOutDTO.class, m = "grpCfm")
	})
public class S8288 extends AcctMgrBaseService implements I8288{

	private ICredit credit;
	private ICust cust;
	private IRecord record;
	private IControl control;
	@Override
	public OutDTO grpInit(InDTO inParam) {
		// TODO Auto-generated method stub
		S8288GrpInitInDTO inDto = (S8288GrpInitInDTO)inParam;
		S8288GrpInitOutDTO outDto = new S8288GrpInitOutDTO();
		long unitId = Long.valueOf(inDto.getUnitId());
		
		//取当前时间
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String curYm = String.valueOf(DateUtils.getCurYm());
		
		GrpCustInfoEntity gcie = cust.getGrpCustInfo(null, unitId);
		if(gcie==null){
			throw new BusiException(AcctMgrError.getErrorCode("8288", "00005"), "集团信息不存在！");
		}
		
		GrpCreditEntity gce = credit.getGrpCredit(unitId);

		if(gce!=null){
			outDto.setBeginTime(curYm);
			outDto.setCreditCode(gce.getCreditCode());
			outDto.setEndTime(gce.getEndTime());
			outDto.setLoginNo(gce.getLoginNo());
			outDto.setOpCode(gce.getOpCode());
			outDto.setOpTime(gce.getOpTime());
			outDto.setUnitId(String.valueOf(unitId));
		}else {
			outDto.setUnitId(String.valueOf(unitId));
			outDto.setBeginTime(curYm);
			outDto.setLoginNo(inDto.getLoginNo());
			outDto.setOpCode(inDto.getOpCode());
			outDto.setOpTime(sCurTime);
		}
		
		return outDto;
	}

	@Override
	public OutDTO grpCfm(InDTO inParam) {
		// TODO Auto-generated method stub
		S8288GrpCfmInDTO inDto = (S8288GrpCfmInDTO)inParam;	
		String creditCode = inDto.getCreditCode();
		String beginTime = inDto.getBeginTime();
		String endTime = inDto.getEndTime();
		long unitId = Long.valueOf(inDto.getUnitId());
		
		GrpCreditEntity gce = new GrpCreditEntity();
		gce.setBeginTime(beginTime);
		gce.setCreditCode(creditCode);
		gce.setEndTime(endTime);
		gce.setLoginNo(inDto.getLoginNo());
		gce.setUnitId(unitId);
		gce.setOpCode(inDto.getOpCode());
		
		if(inDto.getCreditCode().equals("0")){
			throw new BusiException(AcctMgrError.getErrorCode("8288", "00001"), "请选择信用等级！");
		}
		
		if(StringUtils.isEmptyOrNull(endTime)){
			throw new BusiException(AcctMgrError.getErrorCode("8288", "00002"), "结束时间不能为空！");
		}
		
		if(DateUtils.addMonth(Integer.parseInt(beginTime), 3)<=Integer.parseInt(endTime)){
			throw new BusiException(AcctMgrError.getErrorCode("8288", "00003"), "结束时间不可以超过三个月!");
		}
		
		if(Integer.parseInt(beginTime)>Integer.parseInt(endTime)){
			throw new BusiException(AcctMgrError.getErrorCode("8288", "00006"), "结束时间比开始时间早!");
		}
		
		GrpCustInfoEntity gcie = cust.getGrpCustInfo(null, Long.valueOf(inDto.getUnitId()));
		long custId = gcie.getCustId();
		
		CustInfoEntity cie = cust.getCustInfo(custId, null);
		String custLevel = cie.getCustLevel();
		if(!custLevel.equals("A1")&&!custLevel.equals("B1")&&!custLevel.equals("A2")&&!custLevel.equals("B2")&&!custLevel.equals("C1")){
			throw new BusiException(AcctMgrError.getErrorCode("8288", "00004"), "只有属性为A1、A2、B1、B2、C1才可以进行调整！");
		}
		
		//判断是否有记录
		int count = credit.getCntGrpCredit(unitId);
		if(count<1){
			credit.saveGrpCredit(gce);
		}else{
			credit.updateGrpCredit(gce);
		}
		
		//取系统时间
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String sCurDate = sCurTime.substring(0, 8);
		long loginAccept=control.getSequence("SEQ_SYSTEM_SN");
		
		LoginOprEntity loe = new LoginOprEntity();
		loe.setLoginGroup(inDto.getGroupId());
		loe.setLoginNo(inDto.getLoginNo());
		loe.setLoginSn(loginAccept);
		loe.setTotalDate(Long.parseLong(sCurDate));
		loe.setBrandId("xx");
		loe.setPayType("00");
		loe.setPayFee(0);
		loe.setOpCode("8288");
		loe.setRemark("对集团编码["+unitId+"]进行信用等级调整");
		record.saveLoginOpr(loe);
		
		S8288GrpCfmOutDTO outDto = new S8288GrpCfmOutDTO();
		return outDto;
	}

	/**
	 * @return the credit
	 */
	public ICredit getCredit() {
		return credit;
	}

	/**
	 * @param credit the credit to set
	 */
	public void setCredit(ICredit credit) {
		this.credit = credit;
	}

	/**
	 * @return the cust
	 */
	public ICust getCust() {
		return cust;
	}

	/**
	 * @param cust the cust to set
	 */
	public void setCust(ICust cust) {
		this.cust = cust;
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

}