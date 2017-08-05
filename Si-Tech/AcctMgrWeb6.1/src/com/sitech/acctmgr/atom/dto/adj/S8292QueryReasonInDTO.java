package com.sitech.acctmgr.atom.dto.adj;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

/**
 *
 * <p>Title: 投诉退费原因查询入参信息  </p>
 * <p>Description:   </p>
 * <p>Copyright: Copyright (c) 2016</p>
 * <p>Company: SI-TECH </p>
 * @author guowy
 * @version 1.0
 */
public class S8292QueryReasonInDTO extends CommonInDTO{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -7532002637188018636L;
	
	@ParamDesc(path = "BUSI_INFO.REASON_CODE", cons = ConsType.QUES, desc = "退费原因代码", len = "20", type = "string", memo = "略")
	protected String reasonCode;
	@ParamDesc(path = "BUSI_INFO.REASON_FLAG", cons = ConsType.CT001, desc = "退费原因标志", len = "1", type = "string", memo = "1:一级原因 2：二级原因 3：三级原因")
	protected String reasonFlag;
	@ParamDesc(path="BUSI_INFO.PAGE_FLAG",cons=ConsType.QUES,type="String",len="2",desc="退费页面标志",memo="0:8041退费;1:GPRS退费;2:梦网退费")
	protected String pageFlag;
	
	 
	@Override
	public void decode(MBean arg0) {
		super.decode(arg0);
		setReasonCode(arg0.getStr(getPathByProperName("reasonCode")));
		setReasonFlag(arg0.getStr(getPathByProperName("reasonFlag")));
		setPageFlag(arg0.getStr(getPathByProperName("pageFlag")));
	}


	/**
	 * @return the reasonCode
	 */
	public String getReasonCode() {
		return reasonCode;
	}


	/**
	 * @param reasonCode the reasonCode to set
	 */
	public void setReasonCode(String reasonCode) {
		this.reasonCode = reasonCode;
	}


	/**
	 * @return the reasonFlag
	 */
	public String getReasonFlag() {
		return reasonFlag;
	}


	/**
	 * @param reasonFlag the reasonFlag to set
	 */
	public void setReasonFlag(String reasonFlag) {
		this.reasonFlag = reasonFlag;
	}


	public String getPageFlag() {
		return pageFlag;
	}


	public void setPageFlag(String pageFlag) {
		this.pageFlag = pageFlag;
	}


}