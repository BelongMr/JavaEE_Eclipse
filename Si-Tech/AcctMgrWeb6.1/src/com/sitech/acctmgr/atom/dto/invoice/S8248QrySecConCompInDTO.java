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
public class S8248QrySecConCompInDTO extends CommonInDTO {

	private static final long serialVersionUID = 4410354682184604427L;

	@ParamDesc(path = "BUSI_INFO.CONTRACT_NO", cons = ConsType.CT001, type = "long", len = "20", desc = "账户号", memo = "略")
	private long contractNo;

	@ParamDesc(path = "BUSI_INFO.ACROSS_FLAG", cons = ConsType.CT001, type = "long", len = "1", desc = "跨库标志", memo = "略")
	private long acrossFlag;

	@ParamDesc(path = "BUSI_INFO.OP_FLAG", cons = ConsType.CT001, type = "int", len = "1", desc = "操作标志", memo = "略")
	private int opFlag;

	public int getOpFlag() {
		return opFlag;
	}

	public void setOpFlag(int opFlag) {
		this.opFlag = opFlag;
	}

	public long getAcrossFlag() {
		return acrossFlag;
	}

	public void setAcrossFlag(long acrossFlag) {
		this.acrossFlag = acrossFlag;
	}

	/**
	 * @return the contractNo
	 */
	public long getContractNo() {
		return contractNo;
	}

	/**
	 * @param contractNo
	 *            the contractNo to set
	 */
	public void setContractNo(long contractNo) {
		this.contractNo = contractNo;
	}

	@Override
	public void decode(MBean arg0) {

		// TODO Auto-generated method stub
		super.decode(arg0);

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("contractNo")))) {
			contractNo = ValueUtils.longValue(arg0.getStr(getPathByProperName("contractNo")));
		} else {
			throw new BusiException(AcctMgrError.getErrorCode("8248", "11001"), "一级账户号码不能为空！");
		}

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("acrossFlag")))) {
			acrossFlag = ValueUtils.longValue(arg0.getStr(getPathByProperName("acrossFlag")));
		} else {
			throw new BusiException(AcctMgrError.getErrorCode("8248", "11003"), "跨库标志不能为空");
		}

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("opFlag")))) {
			opFlag = ValueUtils.intValue(arg0.getStr(getPathByProperName("opFlag")));
		} else {
			throw new BusiException(AcctMgrError.getErrorCode("8248", "11002"), "操作标志不能为空");
		}
	}
}