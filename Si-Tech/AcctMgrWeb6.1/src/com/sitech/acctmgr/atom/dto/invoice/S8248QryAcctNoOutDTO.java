package com.sitech.acctmgr.atom.dto.invoice;

import java.util.ArrayList;
import java.util.List;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.acctmgr.atom.domains.invoice.TaxAcctInfo;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
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

public class S8248QryAcctNoOutDTO extends CommonOutDTO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2514500040146944382L;

	@JSONField(name = "ACCT_INFO")
	@ParamDesc(path = "ACCT_INFO", cons = ConsType.CT001, type = "compx", len = "1", desc = "有资质账户列表", memo = "略")
	private List<TaxAcctInfo> acctInfo = new ArrayList<TaxAcctInfo>();

	public List<TaxAcctInfo> getAcctInfo() {
		return acctInfo;
	}

	public void setAcctInfo(List<TaxAcctInfo> acctInfo) {
		this.acctInfo = acctInfo;
	}

	public S8248QryAcctNoOutDTO() {
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.jcfx.dt.out.OutDTO#encode() */
	@Override
	public MBean encode() {
		MBean result = new MBean();

		result.setRoot(getPathByProperName("acctInfo"), acctInfo);
		return result;
	}
}
