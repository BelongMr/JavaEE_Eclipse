package com.sitech.acctmgr.atom.dto.pay;


import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

/**
 *
 * <p>Title:   </p>
 * <p>Description:   </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author LIJXD
 * @version 1.0
 */
public class S8208CfmInDTO extends CommonInDTO{

	@ParamDesc(path = "BUSI_INFO.RELPATH", cons = ConsType.CT001, desc = "相对路径加文件名称", len = "100", type = "string", memo = "略")
	private String relPath;
	
	@ParamDesc(path = "BUSI_INFO.SEND_TYPE", cons = ConsType.CT001, desc = "赠费类型,A:表示一次性赠送,不需要审核", len = "100", type = "string", memo = "略")
	protected String sendType;
	
	@ParamDesc(path = "BUSI_INFO.PAY_TYPE", cons = ConsType.CT001, desc = "账本类型", len = "100", type = "string", memo = "略")
	protected String payType;
	
	@ParamDesc(path = "BUSI_INFO.ACT_NAME", cons = ConsType.QUES, desc = "赠费名称", len = "300", type = "string", memo = "")
	protected String actName;
	
	@ParamDesc(path = "BUSI_INFO.SEND_DATE", cons = ConsType.CT001, desc = "赠费日期", len = "14", type = "string", memo = "略")
	protected String sendDate;
	
	@ParamDesc(path = "BUSI_INFO.SMS_FLAG", cons = ConsType.QUES, desc = "短信标识", len = "2", type = "string", memo = "0发送；1不发送，默认不发送")
	protected String smsFlag;
	
	@ParamDesc(path = "BUSI_INFO.SEND_MONTH", cons = ConsType.QUES, desc = "赠送月数", len = "2", type = "string", memo = "")
	protected String sendMonth;
	
	@ParamDesc(path = "BUSI_INFO.USER_PHONE", cons = ConsType.QUES, desc = "联系人电话", len = "300", type = "string", memo = "")
	protected String userPhone;

	@ParamDesc(path = "BUSI_INFO.REMARK", cons = ConsType.CT001, desc = "备注", len = "100", type = "string", memo = "略")
	protected String remark;
	
	/* (non-Javadoc)
	 * @see com.sitech.acctmgr.common.dto.CommonInDTO#decode(com.sitech.jcfx.dt.MBean)
	 */
	@Override
	public void decode(MBean arg0) {

		super.decode(arg0);
		if(StringUtils.isEmptyOrNull(arg0.getStr(getPathByProperName("opCode")))){
			setOpCode("8208");
		}
		
		setRelPath(arg0.getStr(getPathByProperName("relPath")));
		setSendType(arg0.getStr(getPathByProperName("sendType")));
		setPayType(arg0.getStr(getPathByProperName("payType")));
		if(StringUtils.isEmptyOrNull(arg0.getStr(getPathByProperName("actName")))){
			setActName("批量赠费");
		}else{
			setActName(arg0.getStr(getPathByProperName("actName")));
		}
		setSendDate(arg0.getStr(getPathByProperName("sendDate")));
		
		if(StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("smsFlag")))){
			setSmsFlag(arg0.getStr(getPathByProperName("smsFlag")));
		}else{
			smsFlag = "1";		//默认不发送短信
		}
		
		if(StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("sendMonth")))){
			setSendMonth(arg0.getStr(getPathByProperName("sendMonth")));
		}else{
			sendMonth = "1";		//默认赠送1个月
		}
		
		if(StringUtils.isNotEmptyOrNull(arg0.getStr(getPathByProperName("userPhone")))){
			setUserPhone(arg0.getStr(getPathByProperName("userPhone")));
		}else{
			userPhone = "";
		}
			
		setRemark(arg0.getStr(getPathByProperName("remark")));
	}

	public String getSendType() {
		return sendType;
	}

	public void setSendType(String sendType) {
		this.sendType = sendType;
	}

	public String getRelPath() {
		return relPath;
	}

	public void setRelPath(String relPath) {
		this.relPath = relPath;
	}

	public String getPayType() {
		return payType;
	}

	public void setPayType(String payType) {
		this.payType = payType;
	}

	public String getActName() {
		return actName;
	}

	public void setActName(String actName) {
		this.actName = actName;
	}

	public String getSendDate() {
		return sendDate;
	}

	public void setSendDate(String sendDate) {
		this.sendDate = sendDate;
	}

	public String getSmsFlag() {
		return smsFlag;
	}

	public void setSmsFlag(String smsFlag) {
		this.smsFlag = smsFlag;
	}

	public String getSendMonth() {
		return sendMonth;
	}

	public void setSendMonth(String sendMonth) {
		this.sendMonth = sendMonth;
	}

	public String getUserPhone() {
		return userPhone;
	}

	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}
