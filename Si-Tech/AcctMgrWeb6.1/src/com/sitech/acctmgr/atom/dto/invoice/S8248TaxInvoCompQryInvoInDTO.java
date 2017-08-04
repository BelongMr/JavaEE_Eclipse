package com.sitech.acctmgr.atom.dto.invoice;

import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

/**
 * 
 * <p>
 * Title:
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
 * @author
 * @version 1.0
 */
public class S8248TaxInvoCompQryInvoInDTO extends CommonInDTO {

	private static final long serialVersionUID = 4385882994682089507L;

	@ParamDesc(path = "BUSI_INFO.CONTRACT_NO", cons = ConsType.CT001, type = "long", len = "20", desc = "账户号", memo = "略")
	private String contractNo;

	@ParamDesc(path = "BUSI_INFO.BEGIN_MON", cons = ConsType.CT001, type = "int", len = "10", desc = "开始年月", memo = "略")
	private int beginMon;

	@ParamDesc(path = "BUSI_INFO.END_MON", cons = ConsType.CT001, type = "int", len = "10", desc = "结束年月", memo = "略")
	private int endMon;

	@ParamDesc(path = "BUSI_INFO.DOMAIN", cons = ConsType.CT001, type = "int", len = "1", desc = "属于哪个域", memo = "略")
	private int domain;

	@ParamDesc(path = "BUSI_INFO.PHONE_NO", cons = ConsType.CT001, type = "string", len = "20", desc = "手机号", memo = "略")
	private String phoneNo;

	@ParamDesc(path = "BUSI_INFO.QRY_TYPE", cons = ConsType.CT001, type = "string", len = "20", desc = "查询类型", memo = "0：手机号   1：纳税人识别号   2：一点支付账户")
	private int qryType;

	@ParamDesc(path = "BUSI_INFO.FLAG", cons = ConsType.CT001, type = "int", len = "10", desc = "预开标志", memo = "0：开具正常发票    1：预开发票开具")
	private int flag = 0;


	@Override
	public void decode(MBean arg0) {
		super.decode(arg0);

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("contractNo")))) {
			this.setContractNo(arg0.getStr(getPathByProperName("contractNo")));
		}

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("beginMon")))) {
			this.setBeginMon(Integer.parseInt(arg0.getStr(getPathByProperName("beginMon"))));
		} else {
			throw new BusiException(AcctMgrError.getErrorCode("8248", "11001"), "输入开始时间参数不能为空！");
		}

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("endMon")))) {
			this.setEndMon(Integer.parseInt(arg0.getStr(getPathByProperName("endMon"))));
		} else {
			throw new BusiException(AcctMgrError.getErrorCode("8248", "11002"), "输入结束时间参数不能为空！");
		}

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("domain")))) {
			this.setDomain(Integer.parseInt(arg0.getStr(getPathByProperName("domain"))));
		}

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("phoneNo")))) {
			this.setPhoneNo(arg0.getStr(getPathByProperName("phoneNo")));
		}
		qryType = ValueUtils.intValue(arg0.getStr(getPathByProperName("qryType")));

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("flag")))) {
			flag = Integer.parseInt(arg0.getStr(getPathByProperName("flag")));
		}

	}

	public int getFlag() {
		return flag;
	}

	public void setFlag(int flag) {
		this.flag = flag;
	}

	public int getQryType() {
		return qryType;
	}

	public void setQryType(int qryType) {
		this.qryType = qryType;
	}

	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

	public int getBeginMon() {
		return beginMon;
	}

	public void setBeginMon(int beginMon) {
		this.beginMon = beginMon;
	}

	public int getEndMon() {
		return endMon;
	}

	public void setEndMon(int endMon) {
		this.endMon = endMon;
	}

	public int getDomain() {
		return domain;
	}

	public void setDomain(int domain) {
		this.domain = domain;
	}

	public String getPhoneNo() {
		return phoneNo;
	}

	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}

}
