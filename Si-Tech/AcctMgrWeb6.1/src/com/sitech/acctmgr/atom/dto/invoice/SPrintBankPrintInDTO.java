package com.sitech.acctmgr.atom.dto.invoice;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

/**
 * 名称：银行联网打印凭证
 * 
 * @author liuhl_bj
 *
 */
public class SPrintBankPrintInDTO extends CommonInDTO {

	private static final long serialVersionUID = 2437286863730547360L;

	@ParamDesc(path = "BUSI_INFO.PAY_SN", cons = ConsType.CT001, type = "string", len = "20", desc = "缴费流水", memo = "略")
	private long paySn;

	@ParamDesc(path = "BUSI_INFO.FOREIGN_SN", cons = ConsType.CT001, type = "string", len = "20", desc = "外部流水", memo = "略")
	private String foreignSn;

	@ParamDesc(path = "BUSI_INFO.USER_FLAG", cons = ConsType.CT001, type = "string", len = "20", desc = "用户标识", memo = "0：在网   1：离网")
	private int userFlag;

	@ParamDesc(path = "BUSI_INFO.PHONE_NO", cons = ConsType.CT001, type = "string", len = "3", desc = "服务号码", memo = "")
	private String phoneNo;

	@ParamDesc(path = "BUSI_INFO.CONTRACT_NO", cons = ConsType.CT001, type = "string", len = "3", desc = "账户号码", memo = "")
	private long contractNo;

	@ParamDesc(path = "BUSI_INFO.ID_NO", cons = ConsType.CT001, type = "string", len = "3", desc = "用户id", memo = "")
	private long idNo;

	@ParamDesc(path = "BUSI_INFO.TOTAL_DATE", cons = ConsType.CT001, type = "string", len = "3", desc = "缴费日期", memo = "")
	private int totalDate;

	@ParamDesc(path = "BUSI_INFO.INV_NO", cons = ConsType.CT001, type = "string", len = "3", desc = "发票号码", memo = "")
	private String invNo;

	@ParamDesc(path = "BUSI_INFO.INV_CODE", cons = ConsType.CT001, type = "string", len = "3", desc = "发票代码", memo = "")
	private String invCode;

	@ParamDesc(path = "BUSI_INFO.IS_PRINT", cons = ConsType.CT001, type = "string", len = "3", desc = "打印收据或打印发票", memo = "true：打印发票   false：打印收据")
	private boolean isPrint = true;

	@ParamDesc(path = "BUSI_INFO.BANK_CODE", cons = ConsType.CT001, type = "string", len = "3", desc = "银行代码", memo = "")
	private String bankCode;

	@Override
	public void decode(MBean arg0) {
		super.decode(arg0);

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("phoneNo")))) {
			phoneNo = arg0.getStr(getPathByProperName("phoneNo"));
		}
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("contractNo")))) {
			contractNo = ValueUtils.longValue(arg0.getStr(getPathByProperName("contractNo")));
		}
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("idNo")))) {
			idNo = ValueUtils.longValue(arg0.getStr(getPathByProperName("idNo")));
		}
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("paySn")))) {
			paySn = ValueUtils.longValue(arg0.getStr(getPathByProperName("paySn")));
		}
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("foreignSn")))) {
			foreignSn = arg0.getStr(getPathByProperName("foreignSn"));
		}

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("invCode")))) {
			invCode = arg0.getStr(getPathByProperName("invCode"));
		}
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("invNo")))) {
			invNo = arg0.getStr(getPathByProperName("invNo"));
		}
		totalDate = ValueUtils.intValue(arg0.getStr(getPathByProperName("totalDate")));
		bankCode = arg0.getStr(getPathByProperName("bankCode"));
		userFlag = ValueUtils.intValue(arg0.getStr(getPathByProperName("userFlag")));
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("isPrint")))) {
			isPrint = Boolean.parseBoolean(arg0.getStr(getPathByProperName("isPrint")));
		}
	}

	public boolean isPrint() {
		return isPrint;
	}

	public void setPrint(boolean isPrint) {
		this.isPrint = isPrint;
	}

	public long getIdNo() {
		return idNo;
	}

	public void setIdNo(long idNo) {
		this.idNo = idNo;
	}

	public long getPaySn() {
		return paySn;
	}

	public void setPaySn(long paySn) {
		this.paySn = paySn;
	}

	public String getPhoneNo() {
		return phoneNo;
	}

	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}

	public long getContractNo() {
		return contractNo;
	}

	public void setContractNo(long contractNo) {
		this.contractNo = contractNo;
	}

	public int getTotalDate() {
		return totalDate;
	}

	public void setTotalDate(int totalDate) {
		this.totalDate = totalDate;
	}

	public String getForeignSn() {
		return foreignSn;
	}

	public void setForeignSn(String foreignSn) {
		this.foreignSn = foreignSn;
	}

	public String getInvNo() {
		return invNo;
	}

	public void setInvNo(String invNo) {
		this.invNo = invNo;
	}

	public String getInvCode() {
		return invCode;
	}

	public void setInvCode(String invCode) {
		this.invCode = invCode;
	}

	public String getBankCode() {
		return bankCode;
	}

	public void setBankCode(String bankCode) {
		this.bankCode = bankCode;
	}

	public int getUserFlag() {
		return userFlag;
	}

	public void setUserFlag(int userFlag) {
		this.userFlag = userFlag;
	}

}