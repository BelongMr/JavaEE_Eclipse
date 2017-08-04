package com.sitech.acctmgr.atom.dto.invoice;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

/**
 * 名称：8005打印收据入参
 * 
 * @author liuhl_bj
 *
 */
public class S8005PrintInDTO extends CommonInDTO {

	private static final long serialVersionUID = 2437286863730547360L;

	@ParamDesc(path = "BUSI_INFO.PAY_SN", cons = ConsType.CT001, type = "string", len = "20", desc = "缴费", memo = "略")
	private long paySn;

	@ParamDesc(path = "BUSI_INFO.PRINT_FLAG", cons = ConsType.CT001, type = "string", len = "3", desc = "打印标志", memo = "0：未打印   1：已打印")
	private int printFlag;

	@ParamDesc(path = "BUSI_INFO.AUTH_FALG", cons = ConsType.CT001, type = "string", len = "3", desc = "用户类型", memo = "0：权限小   1：权限大")
	private int authFlag;

	@ParamDesc(path = "BUSI_INFO.PHONE_NO", cons = ConsType.CT001, type = "string", len = "3", desc = "服务号码", memo = "")
	private String phoneNo;

	@ParamDesc(path = "BUSI_INFO.CONTRACT_NO", cons = ConsType.CT001, type = "string", len = "3", desc = "账户号码", memo = "")
	private long contractNo;

	@ParamDesc(path = "BUSI_INFO.ID_NO", cons = ConsType.CT001, type = "string", len = "3", desc = "用户id", memo = "")
	private long idNo;

	@ParamDesc(path = "BUSI_INFO.PAY_LOGIN_NO", cons = ConsType.CT001, type = "string", len = "3", desc = "缴费工号", memo = "")
	private String payLoginNo;

	@ParamDesc(path = "BUSI_INFO.TOTAL_DATE", cons = ConsType.CT001, type = "string", len = "3", desc = "缴费日期", memo = "")
	private int totalDate;

	@ParamDesc(path = "BUSI_INFO.INV_NO", cons = ConsType.CT001, type = "string", len = "3", desc = "发票号码", memo = "")
	private String invNo;

	@ParamDesc(path = "BUSI_INFO.INV_CODE", cons = ConsType.CT001, type = "string", len = "3", desc = "发票代码", memo = "")
	private String invCode;

	@ParamDesc(path = "BUSI_INFO.USER_FLAG", cons = ConsType.CT001, type = "string", len = "3", desc = "用户类型", memo = "")
	private int userFlag;

	@ParamDesc(path = "BUSI_INFO.IS_PRINT", cons = ConsType.CT001, type = "string", len = "3", desc = "打印收据或打印发票", memo = "true:打印发票     false:打印收据   默认打印发票")
	private boolean isPrint = true;

	@ParamDesc(path = "BUSI_INFO.INV_TYPE", cons = ConsType.CT001, type = "string", len = "3", desc = "发票类型", memo = "EPM3001电子发票  PM3001:平推式通用机打发票   PM3002：卷式通用机打发票")
	private String invType;

	@ParamDesc(path = "BUSI_INFO.CHN_SOURCE", cons = ConsType.CT001, type = "string", len = "3", desc = "渠道", memo = "")
	private String chnSource = "01";

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
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("invType")))) {
			invType = arg0.getStr(getPathByProperName("invType"));
		}
		paySn = ValueUtils.longValue(arg0.getStr(getPathByProperName("paySn")));
		printFlag = ValueUtils.intValue(arg0.getStr(getPathByProperName("printFlag")));
		authFlag = ValueUtils.intValue(arg0.getStr(getPathByProperName("authFlag")));
		payLoginNo = arg0.getStr(getPathByProperName("payLoginNo"));
		invCode = arg0.getStr(getPathByProperName("invCode"));
		invNo = arg0.getStr(getPathByProperName("invNo"));
		userFlag = ValueUtils.intValue(arg0.getStr(getPathByProperName("userFlag")));
		totalDate = ValueUtils.intValue(arg0.getStr(getPathByProperName("totalDate")));
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("isPrint")))) {
			isPrint = Boolean.parseBoolean(arg0.getStr(getPathByProperName("isPrint")));
		}

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("chnSource")))) {
			chnSource = arg0.getStr(getPathByProperName("chnSource"));
		}
	}

	public String getChnSource() {
		return chnSource;
	}

	public void setChnSource(String chnSource) {
		this.chnSource = chnSource;
	}

	public String getInvType() {
		return invType;
	}

	public void setInvType(String invType) {
		this.invType = invType;
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

	public int getUserFlag() {
		return userFlag;
	}

	public void setUserFlag(int userFlag) {
		this.userFlag = userFlag;
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

	public long getPaySn() {
		return paySn;
	}

	public void setPaySn(long paySn) {
		this.paySn = paySn;
	}

	public int getPrintFlag() {
		return printFlag;
	}

	public void setPrintFlag(int printFlag) {
		this.printFlag = printFlag;
	}

	public int getAuthFlag() {
		return authFlag;
	}

	public void setAuthFlag(int authFlag) {
		this.authFlag = authFlag;
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

	public String getPayLoginNo() {
		return payLoginNo;
	}

	public void setPayLoginNo(String payLoginNo) {
		this.payLoginNo = payLoginNo;
	}

	public int getTotalDate() {
		return totalDate;
	}

	public void setTotalDate(int totalDate) {
		this.totalDate = totalDate;
	}

}
