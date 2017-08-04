package com.sitech.acctmgr.atom.dto.pay;

import static com.sitech.acctmgr.common.AcctMgrError.getErrorCode;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

public class SpecialTransCancelCfmInDTO extends CommonInDTO{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4333175924337137052L;

	
	@ParamDesc(path="OPR_INFO.ORIGIN_ORDER_LINE_ID",cons=ConsType.CT001,type="String",len="40",desc="原始订单行号",memo="略")
	private String orgForeignSn;
	
	@ParamDesc(path="BUSI_INFO.IN_PHONE_NO",cons=ConsType.QUES,type="String",len="40",desc="转入号码",memo="略")
	private String inPhoneNo;
	
	@ParamDesc(path="BUSI_INFO.IN_CONTRACT_NO",cons=ConsType.QUES,type="long",len="18",desc="转入账号",memo="略")
	private long inContractNo;
	
	@ParamDesc(path="BUSI_INFO.OUT_PHONE_NO",cons=ConsType.QUES,type="String",len="40",desc="转出号码",memo="略")
	private String outPhoneNo;
	
	@ParamDesc(path="BUSI_INFO.OUT_CONTRACT_NO",cons=ConsType.QUES,type="long",len="18",desc="转出账号",memo="略")
	private long outContractNo;
	
	@ParamDesc(path="BUSI_INFO.PAY_TYPE",cons=ConsType.CT001,type="String",len="5",desc="专款类型",memo="略")
	private String payType;
	
	@ParamDesc(path="BUSI_INFO.OP_NOTE",cons=ConsType.CT001,type="String",len="40",desc="备注信息",memo="略")
	private String opNote;
	
	@ParamDesc(path="BUSI_INFO.OP_TYPE",cons=ConsType.CT001,type="String",len="14",desc="操作类型",memo="跟正向业务传入同样的标识")
	private String opType;
	
	@ParamDesc(path="BUSI_INFO.FOREIGN_SN",cons=ConsType.CT001,type="String",len="20",desc="外部流水",memo="略")
	private String foreignSn;
	
	
	@Override
	public void decode(MBean arg0) {
		super.decode(arg0);
		
		setInPhoneNo(arg0.getStr(getPathByProperName("inPhoneNo")));
		setInContractNo(Long.parseLong(arg0.getObject(getPathByProperName("inContractNo")).toString()));
		setOutPhoneNo(arg0.getStr(getPathByProperName("outPhoneNo")));
		setOutContractNo(Long.parseLong(arg0.getObject(getPathByProperName("outContractNo")).toString()));
		setPayType(arg0.getStr(getPathByProperName("payType")));
		setOpNote(arg0.getStr(getPathByProperName("opNote")));
		setOpType(arg0.getStr(getPathByProperName("opType")));
		if (!"JT".equals(opType)){
			throw new BusiException(getErrorCode("0000", "00001"), "操作类型错误，请修改操作类型");
		}
		setForeignSn(arg0.getStr(getPathByProperName("foreignSn")));
		
	}


	public String getInPhoneNo() {
		return inPhoneNo;
	}


	public void setInPhoneNo(String inPhoneNo) {
		this.inPhoneNo = inPhoneNo;
	}


	public long getInContractNo() {
		return inContractNo;
	}


	public void setInContractNo(long inContractNo) {
		this.inContractNo = inContractNo;
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


	public String getPayType() {
		return payType;
	}


	public void setPayType(String payType) {
		this.payType = payType;
	}


	public String getOpNote() {
		return opNote;
	}


	public void setOpNote(String opNote) {
		this.opNote = opNote;
	}


	public String getOpType() {
		return opType;
	}


	public void setOpType(String opType) {
		this.opType = opType;
	}


	public String getForeignSn() {
		return foreignSn;
	}


	public void setForeignSn(String foreignSn) {
		this.foreignSn = foreignSn;
	}


	public String getOrgForeignSn() {
		return orgForeignSn;
	}


	public void setOrgForeignSn(String orgForeignSn) {
		this.orgForeignSn = orgForeignSn;
	}
	
}
