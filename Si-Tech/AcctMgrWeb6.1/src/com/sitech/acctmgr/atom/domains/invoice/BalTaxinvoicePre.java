package com.sitech.acctmgr.atom.domains.invoice;

import java.io.Serializable;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;

public class BalTaxinvoicePre implements Serializable { 

  private static final long serialVersionUID = 1L;

	@JSONField(name = "ID_NO")
	@ParamDesc(path = "ID_NO", cons = ConsType.QUES, type = "String", len = "100", desc = "开票时间", memo = "略")
	private Long idNo;

	@JSONField(name = "CONTRACT_NO")
	@ParamDesc(path = "CONTRACT_NO", cons = ConsType.QUES, type = "String", len = "100", desc = "账户号码", memo = "略")
	private Long contractNo;

	@JSONField(name = "PHONE_NO")
	@ParamDesc(path = "PHONE_NO", cons = ConsType.QUES, type = "String", len = "100", desc = "服务号码", memo = "略")
	private String phoneNo;

	@JSONField(name = "INVOICE_ACCEPT")
	@ParamDesc(path = "INVOICE_ACCEPT", cons = ConsType.QUES, type = "String", len = "100", desc = "发票流水", memo = "略")
	private Long invoiceAccept;

	@JSONField(name = "INVOICE_TIME")
	@ParamDesc(path = "INVOICE_TIME", cons = ConsType.QUES, type = "String", len = "100", desc = "开票时间", memo = "略")
	private String invoiceTime;

	@JSONField(name = "INVOICE_LOGIN")
	@ParamDesc(path = "INVOICE_LOGIN", cons = ConsType.QUES, type = "String", len = "100", desc = "开票工号", memo = "略")
	private String invoiceLogin;

	@JSONField(name = "OP_CODE")
	@ParamDesc(path = "OP_CODE", cons = ConsType.QUES, type = "String", len = "100", desc = "操作代码", memo = "略")
	private String opCode;

	@JSONField(name = "REL_INVOICE_MONEY")
	@ParamDesc(path = "REL_INVOICE_MONEY", cons = ConsType.QUES, type = "String", len = "100", desc = "实际开票金额", memo = "略")
	private Long realInvMoney;

	@JSONField(name = "CURRENT_INV_LEFT")
	@ParamDesc(path = "CURRENT_INV_LEFT", cons = ConsType.QUES, type = "String", len = "100", desc = "已冲销后开具的金额", memo = "略")
	private Long currentInvleft;

	@JSONField(name = "PRE_INV_MONEY")
	@ParamDesc(path = "PRE_INV_MONEY", cons = ConsType.QUES, type = "String", len = "100", desc = "预开发票金额", memo = "略")
	private Long preInvMoney;

	@JSONField(name = "STATUS")
	@ParamDesc(path = "STATUS", cons = ConsType.QUES, type = "String", len = "100", desc = "状态", memo = "p:预开    r:回收")
	private String status;

	@JSONField(name = "PAY_SN")
	@ParamDesc(path = "PAY_SN", cons = ConsType.QUES, type = "String", len = "100", desc = "缴费流水", memo = "")
	private Long paySn;

	@JSONField(name = "PAY_LOGIN")
	@ParamDesc(path = "PAY_LOGIN", cons = ConsType.QUES, type = "String", len = "100", desc = "缴费工号", memo = "略")
	private String payLogin;

	@JSONField(name = "PAY_TIME")
	@ParamDesc(path = "PAY_TIME", cons = ConsType.QUES, type = "String", len = "100", desc = "缴费时间", memo = "略")
	private String payTime;

	@JSONField(name = "CHG_FLAG")
	@ParamDesc(path = "CHG_FLAG", cons = ConsType.QUES, type = "String", len = "100", desc = "状态", memo = "1正常  3作废")
	private String chgFlag;

	@JSONField(name = "USER_FLAG")
	@ParamDesc(path = "USER_FLAG", cons = ConsType.QUES, type = "String", len = "100", desc = "用户类别", memo = "0：普通用户  1：集团账户   2：一点支付账户")
	private int userFlag;

	public int getUserFlag() {
		return userFlag;
	}

	public void setUserFlag(int userFlag) {
		this.userFlag = userFlag;
	}

	public Long getIdNo() {
		return this.idNo;
	}

	public void setIdNo(Long idNo) {
		this.idNo = idNo;
	}

	public Long getContractNo() {
		return this.contractNo;
	}

	public void setContractNo(Long contractNo) {
		this.contractNo = contractNo;
	}

	public String getPhoneNo() {
		return this.phoneNo;
	}

	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}

	public Long getInvoiceAccept() {
		return this.invoiceAccept;
	}

	public void setInvoiceAccept(Long invoiceAccept) {
		this.invoiceAccept = invoiceAccept;
	}

	public String getInvoiceTime() {
		return invoiceTime;
	}

	public void setInvoiceTime(String invoiceTime) {
		this.invoiceTime = invoiceTime;
	}

	public String getInvoiceLogin() {
		return this.invoiceLogin;
	}

	public void setInvoiceLogin(String invoiceLogin) {
		this.invoiceLogin = invoiceLogin;
	}

	public String getOpCode() {
		return this.opCode;
	}

	public void setOpCode(String opCode) {
		this.opCode = opCode;
	}

	public Long getRealInvMoney() {
		return this.realInvMoney;
	}

	public void setRealInvMoney(Long realInvMoney) {
		this.realInvMoney = realInvMoney;
	}

	public Long getCurrentInvleft() {
		return this.currentInvleft;
	}

	public void setCurrentInvleft(Long currentInvleft) {
		this.currentInvleft = currentInvleft;
	}

	public Long getPreInvMoney() {
		return this.preInvMoney;
	}

	public void setPreInvMoney(Long preInvMoney) {
		this.preInvMoney = preInvMoney;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Long getPaySn() {
		return this.paySn;
	}

	public void setPaySn(Long paySn) {
		this.paySn = paySn;
	}

	public String getPayLogin() {
		return this.payLogin;
	}

	public void setPayLogin(String payLogin) {
		this.payLogin = payLogin;
	}

	public String getPayTime() {
		return payTime;
	}

	public void setPayTime(String payTime) {
		this.payTime = payTime;
	}

	public String getChgFlag() {
		return this.chgFlag;
	}

	public void setChgFlag(String chgFlag) {
		this.chgFlag = chgFlag;
	}

}