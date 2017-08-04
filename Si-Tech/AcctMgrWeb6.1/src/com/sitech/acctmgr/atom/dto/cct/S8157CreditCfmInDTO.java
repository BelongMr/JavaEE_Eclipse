package com.sitech.acctmgr.atom.dto.cct;

import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

public class S8157CreditCfmInDTO extends CommonInDTO{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@ParamDesc(path = "BUSI_INFO.PHONE_NO", cons = ConsType.CT001, desc = "用户号码", len = "15", type = "String", memo = "略")
	private String phoneNo;
	@ParamDesc(path = "BUSI_INFO.OLD_CREDIT", cons = ConsType.CT001, desc = "旧信用额度", len = "15", type = "long", memo = "略")
	private long oldCredit;
	@ParamDesc(path = "BUSI_INFO.NEW_CREDIT", cons = ConsType.CT001, desc = "新信用额度", len = "15", type = "long", memo = "略")
	private long newCredit;
	@ParamDesc(path = "BUSI_INFO.EXP_DATE", cons = ConsType.CT001, desc = "失效时间", len = "8", type = "String", memo = "略")
	private String expDate;
	@ParamDesc(path = "BUSI_INFO.OP_NOTE", cons = ConsType.CT001, desc = "备注", len = "100", type = "string", memo = "略")
	private String opNote;
	
	@Override
	public void decode(MBean arg0) {
		super.decode(arg0);
		phoneNo = arg0.getStr(getPathByProperName("phoneNo"));
		oldCredit = Long.parseLong(arg0.getStr(getPathByProperName("oldCredit")));
		newCredit = Long.parseLong(arg0.getStr(getPathByProperName("newCredit")));
		expDate = arg0.getStr(getPathByProperName("expDate"));
		if (arg0.getStr(getPathByProperName("opNote")) != null
				&& !arg0.getStr(getPathByProperName("opNote")).equals("")) {
			opNote = arg0.getStr(getPathByProperName("opNote"));
		}
		if(newCredit<0) {
			throw new BusiException(AcctMgrError.getErrorCode("8157", "00007"),"信誉度小于0，不允许办理!");
		}
		if(newCredit>99999999){
			throw new BusiException(AcctMgrError.getErrorCode("8157", "00008"),"信誉度输入值太大!");
		}

	}

	/**
	 * @return the oldCredit
	 */
	public long getOldCredit() {
		return oldCredit;
	}

	/**
	 * @param oldCredit the oldCredit to set
	 */
	public void setOldCredit(long oldCredit) {
		this.oldCredit = oldCredit;
	}

	/**
	 * @return the newCredit
	 */
	public long getNewCredit() {
		return newCredit;
	}

	/**
	 * @param newCredit the newCredit to set
	 */
	public void setNewCredit(long newCredit) {
		this.newCredit = newCredit;
	}

	/**
	 * @return the opNote
	 */
	public String getOpNote() {
		return opNote;
	}

	/**
	 * @param opNote the opNote to set
	 */
	public void setOpNote(String opNote) {
		this.opNote = opNote;
	}

	/**
	 * @return the phoneNo
	 */
	public String getPhoneNo() {
		return phoneNo;
	}

	/**
	 * @param phoneNo the phoneNo to set
	 */
	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}

	/**
	 * @return the expDate
	 */
	public String getExpDate() {
		return expDate;
	}

	/**
	 * @param expDate the expDate to set
	 */
	public void setExpDate(String expDate) {
		this.expDate = expDate;
	}
}
