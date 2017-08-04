package com.sitech.acctmgr.atom.domains.invoice;

import java.io.Serializable;
import java.util.Map;

/**
 * @author ：si-tech TRTD@liuhl
 * @genCode：xBatisTool
 * @CreatedAt：2016-11-10 16:17:59
 */
public class BalGrppreinvInfo implements Serializable {

	private static final long serialVersionUID = 1L;

	private Long unitId;

	private String unitName;

	private String grpPhoneNo;

	private Long grpContractNo;

	private Long loginAccpet;

	private String opTime;

	private String loginNo;

	private Long invFee;

	private String state;

	private String item;

	private String invNo;

	private String managerName;

	private String returnDate;

	private long paySn;

	private String opCode;

	private Map<String, Object> header;

	private String userGroupId;

	public String getUserGroupId() {
		return userGroupId;
	}

	public void setUserGroupId(String userGroupId) {
		this.userGroupId = userGroupId;
	}

	public Map<String, Object> getHeader() {
		return header;
	}

	public void setHeader(Map<String, Object> header) {
		this.header = header;
	}

	public String getOpCode() {
		return opCode;
	}

	public void setOpCode(String opCode) {
		this.opCode = opCode;
	}

	public long getPaySn() {
		return paySn;
	}

	public void setPaySn(long paySn) {
		this.paySn = paySn;
	}

	public Long getUnitId() {
		return this.unitId;
	}

	public void setUnitId(Long unitId) {
		this.unitId = unitId;
	}

	public String getUnitName() {
		return this.unitName;
	}

	public void setUnitName(String unitName) {
		this.unitName = unitName;
	}

	public String getGrpPhoneNo() {
		return this.grpPhoneNo;
	}

	public void setGrpPhoneNo(String grpPhoneNo) {
		this.grpPhoneNo = grpPhoneNo;
	}

	public Long getGrpContractNo() {
		return this.grpContractNo;
	}

	public void setGrpContractNo(Long grpContractNo) {
		this.grpContractNo = grpContractNo;
	}

	public Long getLoginAccpet() {
		return this.loginAccpet;
	}

	public void setLoginAccpet(Long loginAccpet) {
		this.loginAccpet = loginAccpet;
	}

	public String getOpTime() {
		return opTime;
	}

	public void setOpTime(String opTime) {
		this.opTime = opTime;
	}

	public String getLoginNo() {
		return this.loginNo;
	}

	public void setLoginNo(String loginNo) {
		this.loginNo = loginNo;
	}

	public Long getInvFee() {
		return this.invFee;
	}

	public void setInvFee(Long invFee) {
		this.invFee = invFee;
	}

	public String getState() {
		return this.state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getItem() {
		return this.item;
	}

	public void setItem(String item) {
		this.item = item;
	}

	public String getInvNo() {
		return this.invNo;
	}

	public void setInvNo(String invNo) {
		this.invNo = invNo;
	}

	public String getManagerName() {
		return this.managerName;
	}

	public void setManagerName(String managerName) {
		this.managerName = managerName;
	}

	public String getReturnDate() {
		return this.returnDate;
	}

	public void setReturnDate(String returnDate) {
		this.returnDate = returnDate;
	}

	@Override
	public String toString() {
		return "BalGrppreinvInfo [unitId=" + unitId + ", unitName=" + unitName + ", grpPhoneNo=" + grpPhoneNo + ", grpContractNo=" + grpContractNo
				+ ", loginAccpet=" + loginAccpet + ", opTime=" + opTime + ", loginNo=" + loginNo + ", invFee=" + invFee + ", state=" + state
				+ ", item=" + item + ", invNo=" + invNo + ", managerName=" + managerName + ", returnDate=" + returnDate + "]";
	}

}