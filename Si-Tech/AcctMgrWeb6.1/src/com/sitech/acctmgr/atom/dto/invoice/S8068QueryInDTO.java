package com.sitech.acctmgr.atom.dto.invoice;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

/**
 * 
 * @author liuhl_bj
 *
 */
public class S8068QueryInDTO extends CommonInDTO {

	private static final long serialVersionUID = 2437286863730547360L;

	@ParamDesc(path = "BUSI_INFO.CONTRACT_NO", cons = ConsType.CT001, type = "long", len = "20", desc = "账号", memo = "略")
	private long contractNo;


	@Override
	public void decode(MBean arg0) {
		super.decode(arg0);
		contractNo = ValueUtils.longValue(arg0.getStr(getPathByProperName("contractNo")));
	}

	public long getContractNo() {
		return contractNo;
	}


	public void setContractNo(long contractNo) {
		this.contractNo = contractNo;
	}



}
