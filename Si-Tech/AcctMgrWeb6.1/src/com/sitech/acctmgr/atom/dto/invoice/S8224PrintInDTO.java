package com.sitech.acctmgr.atom.dto.invoice;

import java.util.List;

import com.sitech.acctmgr.atom.domains.invoice.InvBillCycleEntity;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

public class S8224PrintInDTO extends CommonInDTO {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1755321684908389787L;

	@ParamDesc(path = "BUSI_INFO.PHONE_NO", cons = ConsType.CT001, type = "String", len = "20", desc = "服务号", memo = "略")
	private String phoneNo;

	@ParamDesc(path = "BUSI_INFO.CONTRACT_NO", cons = ConsType.CT001, type = "long", len = "20", desc = "账户号", memo = "略")
	private long contractNo;

	@ParamDesc(path = "BUSI_INFO.INV_BILLCYCLE_LIST", cons = ConsType.CT001, type = "long", len = "20", desc = "账期，发票号码，发票代码的列表", memo = "略")
	private List<InvBillCycleEntity> invBillCycleList;

	@ParamDesc(path = "BUSI_INFO.PRINT_TYPE", cons = ConsType.CT001, type = "boolean", len = "20", desc = "是否合打", memo = "true：合打  false：分打")
	private boolean isCombine;

	@ParamDesc(path = "BUSI_INFO.IS_PRINT", cons = ConsType.CT001, type = "boolean", len = "20", desc = "是否打印", memo = "0：打印，1：预览")
	private int isPrint;

	@ParamDesc(path = "BUSI_INFO.INV_TYPE", cons = ConsType.CT001, type = "boolean", len = "20", desc = "打印类型", memo = "0:纸质   1：电子发票")
	private int invType = 0;

	@ParamDesc(path = "BUSI_INFO.CHN_SOURCE", cons = ConsType.CT001, type = "string", len = "3", desc = "渠道", memo = "chn_source老系统是多少，发我给对应新的")
	private String chnSource = "11";
	@Override
	public void decode(MBean arg0) {
		super.decode(arg0);

		log.debug("arg0=" + arg0.toString());

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("phoneNo")))) {
			phoneNo = arg0.getStr(getPathByProperName("phoneNo"));
		}
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("contractNo")))) {
			contractNo = ValueUtils.longValue(arg0.getStr(getPathByProperName("contractNo")));
		}
		if (contractNo == 0 && StringUtils.isEmptyOrNull(phoneNo)) {
			throw new BusiException(AcctMgrError.getErrorCode("8000", "01002"), "入参帐户和用户不能同时为空！");
		}
		invBillCycleList = arg0.getList(getPathByProperName("invBillCycleList"), InvBillCycleEntity.class);
		isCombine = Boolean.valueOf(arg0.getStr(getPathByProperName("isCombine")));
		isPrint = Integer.parseInt(arg0.getStr(getPathByProperName("isPrint")));
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("invType")))) {
			invType = Integer.parseInt(arg0.getStr(getPathByProperName("invType")));
		}
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("chnSource")))) {
			chnSource = arg0.getStr(getPathByProperName("chnSource"));
		}
	}

	public int getInvType() {
		return invType;
	}

	public void setInvType(int invType) {
		this.invType = invType;
	}

	public int getIsPrint() {
		return isPrint;
	}

	public void setIsPrint(int isPrint) {
		this.isPrint = isPrint;
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

	public List<InvBillCycleEntity> getInvBillCycleList() {
		return invBillCycleList;
	}

	public void setInvBillCycleList(List<InvBillCycleEntity> invBillCycleList) {
		this.invBillCycleList = invBillCycleList;
	}

	public boolean isCombine() {
		return isCombine;
	}

	public void setCombine(boolean isCombine) {
		this.isCombine = isCombine;
	}

	public String getChnSource() {
		return chnSource;
	}

	public void setChnSource(String chnSource) {
		this.chnSource = chnSource;
	}

}
