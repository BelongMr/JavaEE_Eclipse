package com.sitech.acctmgr.atom.dto.feeqry;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

public class SGiveReturnQryInDTO extends CommonInDTO{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@JSONField(name="BUSI_INFO.PHONE_NO")
	@ParamDesc(path="BUSI_INFO.PHONE_NO",cons=ConsType.CT001,type="int",len="20",desc="服务号码",memo="")
	private String phoneNo = "";
	
	@Override
	public void decode(MBean arg0) {
		setPhoneNo(arg0.getStr(getPathByProperName("phoneNo")));
	}

	/**
	 * @return the phoneNo
	 */
	public String getPhoneNo() {
		return phoneNo;
	}

	/**
	 * @param phoneNo the phoneNo to set
	 */
	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}
}