package com.sitech.acctmgr.atom.dto.pay;

import static com.sitech.acctmgr.common.AcctMgrError.getErrorCode;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

public class SpecialTransBnCheckInDTO extends CommonInDTO{

	private static final long serialVersionUID = -5228903212051791144L;

	@ParamDesc(path="BUSI_INFO.OUT_PHONE_NO",cons=ConsType.QUES,type="String",len="40",desc="转出号码",memo="略")
	private String outPhoneNo;
	
	@ParamDesc(path="BUSI_INFO.OUT_CONTRACT_NO",cons=ConsType.QUES,type="long",len="18",desc="转出账号",memo="略")
	private long outContractNo;
	
	@ParamDesc(path="BUSI_INFO.OP_TYPE",cons=ConsType.CT001,type="String",len="14",desc="操作类型",
			memo="1、老系统调用s1255Cfm_limit这个接口，且op_code不等于1201时  新系统传：BN")
	private String opType;
	
	
	@Override
	public void decode(MBean arg0) {
		super.decode(arg0);
		setOutPhoneNo(arg0.getStr(getPathByProperName("outPhoneNo")));
		setOutContractNo(Long.parseLong(arg0.getObject(getPathByProperName("outContractNo")).toString()));
		
		setOpType(arg0.getStr(getPathByProperName("opType")));
		if (!"BN".equals(opType)){
			throw new BusiException(getErrorCode("0000", "00001"), "操作类型错误，请修改操作类型");
		}
	}


	public String getOutPhoneNo() {
		return outPhoneNo;
	}

	public void setOutPhoneNo(String outPhoneNo) {
		this.outPhoneNo = outPhoneNo;
	}

	public long getOutContractNo() {
		return outContractNo;
	}

	public void setOutContractNo(long outContractNo) {
		this.outContractNo = outContractNo;
	}

	public String getOpType() {
		return opType;
	}

	public void setOpType(String opType) {
		this.opType = opType;
	}

}
