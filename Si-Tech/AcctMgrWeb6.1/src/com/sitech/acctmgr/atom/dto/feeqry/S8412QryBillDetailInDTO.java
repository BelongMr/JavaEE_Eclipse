package com.sitech.acctmgr.atom.dto.feeqry;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.common.utils.StringUtils;
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
 * @author liuhl_bj
 * @version 1.0
 */
public class S8412QryBillDetailInDTO extends CommonInDTO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4076032478943349501L;

	@ParamDesc(path = "BUSI_INFO.CONTRACT_NO", cons = ConsType.CT001, type = "long", len = "18", desc = "账号号码", memo = "略")
	private long contractNo = 0;

	@ParamDesc(path = "BUSI_INFO.BILL_CYCLE", cons = ConsType.QUES, type = "long", len = "18", desc = "账期", memo = "可空")
	private int billCycle = 0;

	@ParamDesc(path = "BUSI_INFO.STATUS", cons = ConsType.QUES, type = "long", len = "18", desc = "账期", memo = "可空")
	private String status = "";

	@Override
	public void decode(MBean arg0) {
		super.decode(arg0);
		contractNo = Long.valueOf(arg0.getStr(getPathByProperName("contractNo")));

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("billCycle")))) {
			billCycle = Integer.valueOf(arg0.getStr(getPathByProperName("billCycle")));
		}

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("status")))) {
			status = arg0.getStr(getPathByProperName("status"));
		}

	}

	public long getContractNo() {
		return contractNo;
	}

	public void setContractNo(long contractNo) {
		this.contractNo = contractNo;
	}

	public int getBillCycle() {
		return billCycle;
	}

	public void setBillCycle(int billCycle) {
		this.billCycle = billCycle;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}