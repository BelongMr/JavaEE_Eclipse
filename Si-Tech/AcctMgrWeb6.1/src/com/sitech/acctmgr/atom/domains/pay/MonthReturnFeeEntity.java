package com.sitech.acctmgr.atom.domains.pay;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;

import java.io.Serializable;

@SuppressWarnings("serial")

/**
 *
* @Title:   []
* @Description: 手工导入按月返还详细实体类
* @Date : 2017年06月23日
* @Company: SI-TECH
* @author : hanfl
* @version : 1.0
* @modify history
*  <p>修改日期    修改人   修改目的<p>
 */
public class MonthReturnFeeEntity implements Serializable {

	@JSONField(name="DOCUMENT_NAME")
	@ParamDesc(path="DOCUMENT_NAME",cons=ConsType.CT001,type="String",len="40",desc="公文名",memo="略")
	private String documentName;
	
	@JSONField(name="DOCUMENT_NO")
	@ParamDesc(path="DOCUMENT_NO",cons=ConsType.CT001,type="String",len="32",desc="公文文号",memo="略")
	private String documentNo;
	
	@JSONField(name="OP_TIME")
	@ParamDesc(path="OP_TIME",cons=ConsType.QUES,type="String",len="18",desc="操作时间",memo="略")
	private String opTime;

	@JSONField(name="ACT_NAME")
	@ParamDesc(path="ACT_NAME",cons=ConsType.QUES,type="String",len="200",desc="操作名称",memo="略")
	private String actName;

	@JSONField(name="TOTAL_SUM")
	@ParamDesc(path="TOTAL_SUM",cons=ConsType.QUES,type="String",len="8",desc="用户数",memo="略")
	private String totalSum;
	
	@JSONField(name="MAX_FEE_NUM")
	@ParamDesc(path="MAX_FEE_NUM",cons=ConsType.QUES,type="Long",len="8",desc="金额最高用户数",memo="略")
	private long maxFeeNum;

	@JSONField(name="TOTAL_FEE")
	@ParamDesc(path="TOTAL_FEE",cons=ConsType.QUES,type="String",len="18",desc="总费用",memo="略")
	private String totalFee;
	
	@JSONField(name="MAX_FEE")
	@ParamDesc(path="MAX_FEE",cons=ConsType.QUES,type="Long",len="14",desc="最高赠费金额",memo="略")
	private long maxFee;

	@JSONField(name="MIN_EFF_DATE")
	@ParamDesc(path="MIN_EFF_DATE",cons=ConsType.QUES,type="String",len="8",desc="最短月份",memo="略")
	private String minEffDate;

	@JSONField(name="MAX_EXP_DATE")
	@ParamDesc(path="MAX_EXP_DATE",cons=ConsType.QUES,type="String",len="8",desc="最长月份",memo="略")
	private String maxExpDate;
	
	@JSONField(name="MAX_RETURN_COUNT")
	@ParamDesc(path="MAX_RETURN_COUNT",cons=ConsType.QUES,type="Long",len="14",desc="最大周期",memo="略")
	private long maxReturnCount;

	@JSONField(name="MIN_RETURN_COUNT")
	@ParamDesc(path="MIN_RETURN_COUNT",cons=ConsType.QUES,type="Long",len="14",desc="最小周期",memo="略")
	private long minReturnCount;

	@JSONField(name="LOGIN_NO")
	@ParamDesc(path="LOGIN_NO",cons=ConsType.QUES,type="String",len="10",desc="操作工号",memo="略")
	private String loginNo;

	@JSONField(name="LOGIN_NAME")
	@ParamDesc(path="LOGIN_NAME",cons=ConsType.QUES,type="String",len="18",desc="操作员工姓名",memo="略")
	private String loginName;

	@JSONField(name="AUDIT_LOGIN")
	@ParamDesc(path="AUDIT_LOGIN",cons=ConsType.QUES,type="String",len="10",desc="审核工号",memo="略")
	private String auditLogin;

	@JSONField(name="AUDIT_LOGIN_NAME")
	@ParamDesc(path="AUDIT_LOGIN_NAME",cons=ConsType.QUES,type="String",len="18",desc="审核姓名",memo="略")
	private String auditLoginName;

	@JSONField(name="SHORT_MSG1")
	@ParamDesc(path="SHORT_MSG1",cons=ConsType.QUES,type="String",len="18",desc="审核姓名",memo="略")
	private String shortMsg1;
	
	@JSONField(name="SHORT_MSG2")
	@ParamDesc(path="SHORT_MSG2",cons=ConsType.QUES,type="String",len="18",desc="审核姓名",memo="略")
	private String shortMsg2;
	
	@JSONField(name="ACT_ID")
	@ParamDesc(path="ACT_ID",cons=ConsType.QUES,type="String",len="18",desc="营销代码",memo="略")
	private String actId;
	
	@Override
	public String toString() {
		return "MonthReturnFeeEntity [documentName=" + documentName + ", documentNo=" + documentNo + ", opTime="
				+ opTime + ", actName=" + actName + ", totalSum=" + totalSum + ", maxFeeNum=" + maxFeeNum
				+ ", totalFee=" + totalFee + ", maxFee=" + maxFee + ", minEffDate=" + minEffDate + ", maxExpDate="
				+ maxExpDate + ", maxReturnCount=" + maxReturnCount + ", minReturnCount=" + minReturnCount
				+ ", loginNo=" + loginNo + ", loginName=" + loginName + ", auditLogin=" + auditLogin
				+ ", auditLoginName=" + auditLoginName + ", shortMsg1=" + shortMsg1 + ", shortMsg2=" + shortMsg2
				+ ", actId=" + actId + "]";
	}


	public String getDocumentName() {
		return documentName;
	}


	public String getDocumentNo() {
		return documentNo;
	}


	public String getOpTime() {
		return opTime;
	}


	public String getActName() {
		return actName;
	}


	public String getTotalSum() {
		return totalSum;
	}


	public long getMaxFeeNum() {
		return maxFeeNum;
	}


	public String getTotalFee() {
		return totalFee;
	}


	public long getMaxFee() {
		return maxFee;
	}


	public String getMinEffDate() {
		return minEffDate;
	}


	public String getMaxExpDate() {
		return maxExpDate;
	}


	public long getMaxReturnCount() {
		return maxReturnCount;
	}


	public long getMinReturnCount() {
		return minReturnCount;
	}


	public String getLoginNo() {
		return loginNo;
	}


	public String getLoginName() {
		return loginName;
	}


	public String getAuditLogin() {
		return auditLogin;
	}


	public String getAuditLoginName() {
		return auditLoginName;
	}


	public void setDocumentName(String documentName) {
		this.documentName = documentName;
	}


	public void setDocumentNo(String documentNo) {
		this.documentNo = documentNo;
	}


	public void setOpTime(String opTime) {
		this.opTime = opTime;
	}


	public void setActName(String actName) {
		this.actName = actName;
	}


	public void setTotalSum(String totalSum) {
		this.totalSum = totalSum;
	}


	public void setMaxFeeNum(long maxFeeNum) {
		this.maxFeeNum = maxFeeNum;
	}


	public void setTotalFee(String totalFee) {
		this.totalFee = totalFee;
	}


	public void setMaxFee(long maxFee) {
		this.maxFee = maxFee;
	}


	public void setMinEffDate(String minEffDate) {
		this.minEffDate = minEffDate;
	}


	public void setMaxExpDate(String maxExpDate) {
		this.maxExpDate = maxExpDate;
	}


	public void setMaxReturnCount(long maxReturnCount) {
		this.maxReturnCount = maxReturnCount;
	}


	public void setMinReturnCount(long minReturnCount) {
		this.minReturnCount = minReturnCount;
	}


	public void setLoginNo(String loginNo) {
		this.loginNo = loginNo;
	}


	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}


	public void setAuditLogin(String auditLogin) {
		this.auditLogin = auditLogin;
	}


	public void setAuditLoginName(String auditLoginName) {
		this.auditLoginName = auditLoginName;
	}


	public String getShortMsg1() {
		return shortMsg1;
	}


	public String getShortMsg2() {
		return shortMsg2;
	}


	public void setShortMsg1(String shortMsg1) {
		this.shortMsg1 = shortMsg1;
	}


	public void setShortMsg2(String shortMsg2) {
		this.shortMsg2 = shortMsg2;
	}


	public String getActId() {
		return actId;
	}


	public void setActId(String actId) {
		this.actId = actId;
	}
	
}