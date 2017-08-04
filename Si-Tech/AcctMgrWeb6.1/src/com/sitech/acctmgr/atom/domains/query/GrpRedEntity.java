package com.sitech.acctmgr.atom.domains.query;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;

public class GrpRedEntity {
	@JSONField(name="JT_CONTRACT_NO")
	@ParamDesc(path="JT_CONTRACT_NO",cons=ConsType.CT001,type="long",len="18",desc="集团账户",memo="略")
	private long jtContractNo;
	@JSONField(name="PHONE_NO")
	@ParamDesc(path="PHONE_NO",cons=ConsType.CT001,type="String",len="18",desc="转入号码",memo="略")
	private long phoneNo;
	@JSONField(name="TOTAL_DATE")
	@ParamDesc(path="TOTAL_DATE",cons=ConsType.CT001,type="String",len="8",desc="操作日期",memo="略")
	private String totalDate;
	@JSONField(name="TRANS_MONEY")
	@ParamDesc(path="TRANS_MONEY",cons=ConsType.CT001,type="long",len="10",desc="转账金额",memo="略")
	private long transMoney;
	@JSONField(name="TRANS_COUNT")
	@ParamDesc(path="TRANS_COUNT",cons=ConsType.CT001,type="long",len="10",desc="红包个数",memo="略")
	private long transCount;
	@JSONField(name="CONTACT_PHONE")
	@ParamDesc(path="CONTACT_PHONE",cons=ConsType.CT001,type="String",len="14",desc="操作员电话",memo="略")
	private String contactPhone;
	@JSONField(name="OP_TIME")
	@ParamDesc(path="OP_TIME",cons=ConsType.CT001,type="String",len="20",desc="操作时间",memo="略")
	private String opTime;
	@JSONField(name="TRANS_RESULT")
	@ParamDesc(path="TRANS_RESULT",cons=ConsType.CT001,type="String",len="20",desc="操作结果",memo="略")
	private String transResult;
	/**
	 * @return the jtContractNo
	 */
	public long getJtContractNo() {
		return jtContractNo;
	}
	/**
	 * @param jtContractNo the jtContractNo to set
	 */
	public void setJtContractNo(long jtContractNo) {
		this.jtContractNo = jtContractNo;
	}
	/**
	 * @return the phoneNo
	 */
	public long getPhoneNo() {
		return phoneNo;
	}
	/**
	 * @param phoneNo the phoneNo to set
	 */
	public void setPhoneNo(long phoneNo) {
		this.phoneNo = phoneNo;
	}
	/**
	 * @return the totalDate
	 */
	public String getTotalDate() {
		return totalDate;
	}
	/**
	 * @param totalDate the totalDate to set
	 */
	public void setTotalDate(String totalDate) {
		this.totalDate = totalDate;
	}
	/**
	 * @return the transMoney
	 */
	public long getTransMoney() {
		return transMoney;
	}
	/**
	 * @param transMoney the transMoney to set
	 */
	public void setTransMoney(long transMoney) {
		this.transMoney = transMoney;
	}
	/**
	 * @return the transCount
	 */
	public long getTransCount() {
		return transCount;
	}
	/**
	 * @param transCount the transCount to set
	 */
	public void setTransCount(long transCount) {
		this.transCount = transCount;
	}
	/**
	 * @return the contactPhone
	 */
	public String getContactPhone() {
		return contactPhone;
	}
	/**
	 * @param contactPhone the contactPhone to set
	 */
	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}
	/**
	 * @return the opTime
	 */
	public String getOpTime() {
		return opTime;
	}
	/**
	 * @param opTime the opTime to set
	 */
	public void setOpTime(String opTime) {
		this.opTime = opTime;
	}
	/**
	 * @return the transResult
	 */
	public String getTransResult() {
		return transResult;
	}
	/**
	 * @param transResult the transResult to set
	 */
	public void setTransResult(String transResult) {
		this.transResult = transResult;
	}
	
}
