package com.sitech.acctmgr.atom.dto.pay;


import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

import static com.sitech.acctmgr.common.AcctMgrError.getErrorCode;

/**
 *
 * <p>Title: 转账确认入参DTO  </p>
 * <p>Description: 转账入参DTO  </p>
 * <p>Copyright: Copyright (c) 2015/1/5</p>
 * <p>Company: SI-TECH </p>
 * @author LIJXD
 * @version 1.0
 */
public class S8014CfmInDTO extends CommonInDTO {
 
	private static final long serialVersionUID = -2585936961658008861L;
	
	@ParamDesc(path="BUSI_INFO.OUT_CONTRACT_NO",cons=ConsType.QUES,type="long",len="18",desc="转出账号",memo="略")
	protected long outContractNo;
	@ParamDesc(path="BUSI_INFO.OUT_PHONE_NO",cons=ConsType.QUES,type="String",len="40",desc="转出号码",memo="略")
	protected String outPhoneNo;
	@ParamDesc(path="BUSI_INFO.IN_CONTRACT_NO",cons=ConsType.QUES,type="long",len="18",desc="转入账号",memo="略")
	protected long inContractNo;
	@ParamDesc(path="BUSI_INFO.IN_PHONE_NO",cons=ConsType.CT001,type="String",len="40",desc="转入号码",memo="略")
	protected String inPhoneNo;
	@ParamDesc(path="BUSI_INFO.OP_TYPE",cons=ConsType.CT001,type="String",len="10",desc="转账类型"
			,memo="TransAccount: 账户转账；TransAccountGrp:集团红包转账;TransAccountXH:批量销户转预存")
	protected String opType;
	@ParamDesc(path="BUSI_INFO.TRANS_FEE",cons=ConsType.QUES,type="long",len="14",desc="转账金额",memo="分")
	protected long transFee ;
	@ParamDesc(path="BUSI_INFO.OP_NOTE",cons=ConsType.QUES,type="String",len="1024",desc="备注",memo="略")
	protected String opNote;
	@ParamDesc(path="BUSI_INFO.IF_ONNET",cons=ConsType.CT001,type="String",len="1",desc="在网标识",memo="1:在网；2:离网")
	protected String ifOnNet ="1";
//	@ParamDesc(path="BUSI_INFO.CHECK_FLAG",cons=ConsType.QUES,type="String",len="1",desc="权限标识",memo="略")
//	protected String checkFlag;
	
	@ParamDesc(path="BUSI_INFO.PAY_PATH",cons=ConsType.CT001,type="String",len="5",desc="缴费渠道",memo="网厅:02；短厅:04；营业前台:11；后台：98")
	private String payPath;
	@ParamDesc(path="BUSI_INFO.PAY_METHOD",cons=ConsType.CT001,type="String",len="5",desc="缴费方式",memo="现金:0")
	private String payMethod;
	
	@ParamDesc(path="BUSI_INFO.OUT_PAY_TYPE",cons=ConsType.QUES,type="String",len="5",desc="转出账本",memo="略")
	private String outPayType;
	@ParamDesc(path="BUSI_INFO.IN_PAY_TYPE",cons=ConsType.QUES,type="String",len="5",desc="转入账本",memo="略")
	private String inPayType;
	@ParamDesc(path="BUSI_INFO.FOREIGN_SN",cons=ConsType.QUES,type="String",len="64",desc="外部流水"
			,memo="略")
	private String foreignSn;
	
	@ParamDesc(path="BUSI_INFO.SM_FLAG",cons=ConsType.QUES,type="String",len="5",desc="短信标识",memo="1：发送；其他：不发送")
	private String smFlag;
	
	@ParamDesc(path="BUSI_INFO.REASON",cons=ConsType.QUES,type="String",len="20",desc="转账原因",memo="略")
	private String reason;
	
	@Override
	public void decode(MBean arg0) {
		super.decode(arg0);

		//预开户激活转账转出账户可能是公共账户，没有对于号码，取默认号码
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("outPhoneNo")))){
			setOutPhoneNo(arg0.getStr(getPathByProperName("outPhoneNo")));
		}
		
		setInPhoneNo(arg0.getStr(getPathByProperName("inPhoneNo")));
		
		setOpType(arg0.getStr(getPathByProperName("opType")));
		setIfOnNet(arg0.getStr(getPathByProperName("ifOnNet")));
		
		//解除付费关系转账:转账金额取余额 
		if (StringUtils.isNotEmptyOrNull(arg0.getObject(getPathByProperName("transFee")))){
			setTransFee(Long.parseLong(arg0.getObject(getPathByProperName("transFee")).toString()));
		}else {
			transFee=0;
		}
		
		//幸福E家成员短信转帐确认:转入转出账户为默认账户
		if (StringUtils.isNotEmptyOrNull(arg0.getObject(getPathByProperName("outContractNo")))){
			setOutContractNo(Long.parseLong(arg0.getObject(getPathByProperName("outContractNo")).toString()));
		}else {
			outContractNo=0;
		}
		if (StringUtils.isNotEmptyOrNull(arg0.getObject(getPathByProperName("inContractNo")))){
			setInContractNo(Long.parseLong(arg0.getObject(getPathByProperName("inContractNo")).toString()));
		}else {
			inContractNo=0;
		}
//		//幸福家庭回馈转赠: 8159小权限校验
//		if (StringUtils.isNotEmptyOrNull(arg0.getObject(getPathByProperName("checkFlag")))){
//			setCheckFlag(arg0.getStr(getPathByProperName("checkFlag")).toString());
//		}else {
//			checkFlag="Y";
//		}

		if (StringUtils.isEmptyOrNull(outPhoneNo) && outContractNo==0){
			throw new BusiException(getErrorCode(opCode, "01002"), "转出号码和账户不能同时为空");
		}

		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("opNote")))){
			setOpNote(arg0.getStr(getPathByProperName("opNote")));
		}
		
		if (StringUtils.isEmptyOrNull(opCode)){
			opCode = "8014";
		}
		
		setPayPath(arg0.getStr(getPathByProperName("payPath")));
		setPayMethod(arg0.getStr(getPathByProperName("payMethod")));
		
		//转出转入账本、外部流水：YKHJHZZ: 预开户激活转账传入
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("outPayType")))){
			setOutPayType(arg0.getStr(getPathByProperName("outPayType")));
		}
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("inPayType")))){
			setInPayType(arg0.getStr(getPathByProperName("inPayType")));
		}
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("foreignSn")))){
			setForeignSn(arg0.getStr(getPathByProperName("foreignSn")));
		}
		
		if (StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("smFlag")))){
			setSmFlag(arg0.getStr(getPathByProperName("smFlag")));
		}
		
		setReason(arg0.getStr(getPathByProperName("reason")));
	}

	/**
	 * @return the outContractNo
	 */
	public long getOutContractNo() {
		return outContractNo;
	}

	/**
	 * @param outContractNo the outContractNo to set
	 */
	public void setOutContractNo(long outContractNo) {
		this.outContractNo = outContractNo;
	}

	/**
	 * @return the outPhoneNo
	 */
	public String getOutPhoneNo() {
		return outPhoneNo;
	}

	/**
	 * @param outPhoneNo the outPhoneNo to set
	 */
	public void setOutPhoneNo(String outPhoneNo) {
		this.outPhoneNo = outPhoneNo;
	}

	/**
	 * @return the inContractNo
	 */
	public long getInContractNo() {
		return inContractNo;
	}

	/**
	 * @param inContractNo the inContractNo to set
	 */
	public void setInContractNo(long inContractNo) {
		this.inContractNo = inContractNo;
	}

	/**
	 * @return the inPhoneNo
	 */
	public String getInPhoneNo() {
		return inPhoneNo;
	}

	/**
	 * @param inPhoneNo the inPhoneNo to set
	 */
	public void setInPhoneNo(String inPhoneNo) {
		this.inPhoneNo = inPhoneNo;
	}

	/**
	 * @return the opType
	 */
	public String getOpType() {
		return opType;
	}

	/**
	 * @param opType the opType to set
	 */
	public void setOpType(String opType) {
		this.opType = opType;
	}

	/**
	 * @return the transFee
	 */
	public long getTransFee() {
		return transFee;
	}

	/**
	 * @param transFee the transFee to set
	 */
	public void setTransFee(long transFee) {
		this.transFee = transFee;
	}

	/**
	 * @return the opNote
	 */
	public String getOpNote() {
		return opNote;
	}

	/**
	 * @param opNote the opNote to set
	 */
	public void setOpNote(String opNote) {
		this.opNote = opNote;
	}

	/**
	 * @return the ifOnNet
	 */
	public String getIfOnNet() {
		return ifOnNet;
	}

	/**
	 * @param ifOnNet the ifOnNet to set
	 */
	public void setIfOnNet(String ifOnNet) {
		this.ifOnNet = ifOnNet;
	}

//	/**
//	 * @return the checkFlag
//	 */
//	public String getCheckFlag() {
//		return checkFlag;
//	}
//
//	/**
//	 * @param checkFlag the checkFlag to set
//	 */
//	public void setCheckFlag(String checkFlag) {
//		this.checkFlag = checkFlag;
//	}

	/**
	 * @return the payPath
	 */
	public String getPayPath() {
		return payPath;
	}

	/**
	 * @param payPath the payPath to set
	 */
	public void setPayPath(String payPath) {
		this.payPath = payPath;
	}

	/**
	 * @return the payMethod
	 */
	public String getPayMethod() {
		return payMethod;
	}

	/**
	 * @param payMethod the payMethod to set
	 */
	public void setPayMethod(String payMethod) {
		this.payMethod = payMethod;
	}

	/**
	 * @return the outPayType
	 */
	public String getOutPayType() {
		return outPayType;
	}

	/**
	 * @param outPayType the outPayType to set
	 */
	public void setOutPayType(String outPayType) {
		this.outPayType = outPayType;
	}

	/**
	 * @return the inPayType
	 */
	public String getInPayType() {
		return inPayType;
	}

	/**
	 * @param inPayType the inPayType to set
	 */
	public void setInPayType(String inPayType) {
		this.inPayType = inPayType;
	}

	/**
	 * @return the foreignSn
	 */
	public String getForeignSn() {
		return foreignSn;
	}

	/**
	 * @param foreignSn the foreignSn to set
	 */
	public void setForeignSn(String foreignSn) {
		this.foreignSn = foreignSn;
	}

	/**
	 * @return the smFlag
	 */
	public String getSmFlag() {
		return smFlag;
	}

	/**
	 * @param smFlag the smFlag to set
	 */
	public void setSmFlag(String smFlag) {
		this.smFlag = smFlag;
	}

	/**
	 * @return the fieldValue
	 */
	public String getReason() {
		return reason;
	}

	/**
	 * @param fieldValue the fieldValue to set
	 */
	public void setReason(String reason) {
		this.reason = reason;
	}
	

}
