package com.sitech.acctmgr.atom.domains.prod;

import java.io.Serializable;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;

public class UserPdPrcDetailInfoEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@JSONField(name = "PROD_PRCID")
	@ParamDesc(path = "PROD_PRCID", type = "string", cons = ConsType.CT001, desc = "资费代码", len = "10", memo = "略")
	private String prodPrcid;

	@JSONField(name = "PRC_NAME")
	@ParamDesc(path = "PRC_NAME", type = "string", cons = ConsType.CT001, desc = "资费名称", len = "10", memo = "略")
	private String prcName;

	@JSONField(name = "DETAIL_CODE")
	@ParamDesc(path = "DETAIL_CODE", type = "string", cons = ConsType.CT001, desc = "优惠代码", len = "10", memo = "略")
	private String detailCode;

	@JSONField(name = "DETAIL_NOTE")
	@ParamDesc(path = "DETAIL_NOTE", type = "string", cons = ConsType.CT001, desc = "优惠名称", len = "10", memo = "略")
	private String detailNote;

	@JSONField(name = "DETAIL_TYPE")
	@ParamDesc(path = "DETAIL_TYPE", type = "string", cons = ConsType.CT001, desc = "优惠类型", len = "10", memo = "略")
	private String detailType;

	@JSONField(name = "DETAIL_TYPE_NAME")
	@ParamDesc(path = "DETAIL_TYPE_NAME", type = "string", cons = ConsType.CT001, desc = "优惠类型名称", len = "10", memo = "略")
	private String detailTypeName;

	@JSONField(name = "BEGIN_TIME")
	@ParamDesc(path = "BEGIN_TIME", type = "string", cons = ConsType.CT001, desc = "生效时间", len = "10", memo = "略")
	private String beginTime;

	@JSONField(name = "END_TIME")
	@ParamDesc(path = "END_TIME", type = "string", cons = ConsType.CT001, desc = "失效时间", len = "10", memo = "略")
	private String endTime;

	@JSONField(name = "LOGIN_ACCEPT")
	@ParamDesc(path = "LOGIN_ACCEPT", type = "string", cons = ConsType.CT001, desc = "流水", len = "10", memo = "略")
	private String loginAccept;

	@JSONField(name = "LOGIN_NO")
	@ParamDesc(path = "LOGIN_NO", type = "string", cons = ConsType.CT001, desc = "操作工号", len = "10", memo = "略")
	private String loginNo;

	@JSONField(name = "MON_FEE")
	@ParamDesc(path = "MON_FEE", type = "string", cons = ConsType.CT001, desc = "月租费", len = "10", memo = "略")
	private String monFee;

	@JSONField(name = "DAY_FEE")
	@ParamDesc(path = "DAY_FEE", type = "string", cons = ConsType.CT001, desc = "日租费", len = "10", memo = "略")
	private String dayFee;

	@JSONField(name = "STATIC_TYPE")
	@ParamDesc(path = "STATIC_TYPE", type = "string", cons = ConsType.CT001, desc = "月租类型", len = "10", memo = "0：月租类 不按日分摊  1：月租类，按日分摊 2：非月租类")
	private String detailStaticType;

	@JSONField(name = "FLAG_CODE")
	@ParamDesc(path = "FLAG_CODE", type = "string", cons = ConsType.CT001, desc = "二批代码", len = "10", memo = "略")
	private String flagCode;

	@JSONField(name = "FLAG_NAME")
	@ParamDesc(path = "FLAG_NAME", type = "string", cons = ConsType.CT001, desc = "二批代码名称", len = "10", memo = "略")
	private String flagName;

	@JSONField(name = "SHARE_FLAG")
	@ParamDesc(path = "SHARE_FLAG", type = "string", cons = ConsType.CT001, desc = "是否分摊", len = "10", memo = "略")
	private String shareFlag;

	private String dayFlag;

	private String monthFlag;

	private String prcClass;

	public String getPrcClass() {
		return prcClass;
	}

	public void setPrcClass(String prcClass) {
		this.prcClass = prcClass;
	}

	public String getDayFlag() {
		return dayFlag;
	}

	public void setDayFlag(String dayFlag) {
		this.dayFlag = dayFlag;
	}

	public String getMonthFlag() {
		return monthFlag;
	}

	public void setMonthFlag(String monthFlag) {
		this.monthFlag = monthFlag;
	}

	public String getShareFlag() {
		return shareFlag;
	}

	public void setShareFlag(String shareFlag) {
		this.shareFlag = shareFlag;
	}

	public String getProdPrcid() {
		return prodPrcid;
	}

	public void setProdPrcid(String prodPrcid) {
		this.prodPrcid = prodPrcid;
	}

	public String getPrcName() {
		return prcName;
	}

	public void setPrcName(String prcName) {
		this.prcName = prcName;
	}

	public String getDetailCode() {
		return detailCode;
	}

	public void setDetailCode(String detailCode) {
		this.detailCode = detailCode;
	}

	public String getDetailNote() {
		return detailNote;
	}

	public void setDetailNote(String detailNote) {
		this.detailNote = detailNote;
	}

	public String getDetailType() {
		return detailType;
	}

	public void setDetailType(String detailType) {
		this.detailType = detailType;
	}

	public String getDetailTypeName() {
		return detailTypeName;
	}

	public void setDetailTypeName(String detailTypeName) {
		this.detailTypeName = detailTypeName;
	}

	public String getDetailStaticType() {
		return detailStaticType;
	}

	public void setDetailStaticType(String detailStaticType) {
		this.detailStaticType = detailStaticType;
	}

	public String getBeginTime() {
		return beginTime;
	}

	public void setBeginTime(String beginTime) {
		this.beginTime = beginTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getLoginAccept() {
		return loginAccept;
	}

	public void setLoginAccept(String loginAccept) {
		this.loginAccept = loginAccept;
	}

	public String getLoginNo() {
		return loginNo;
	}

	public void setLoginNo(String loginNo) {
		this.loginNo = loginNo;
	}

	public String getMonFee() {
		return monFee;
	}

	public void setMonFee(String monFee) {
		this.monFee = monFee;
	}

	public String getDayFee() {
		return dayFee;
	}

	public void setDayFee(String dayFee) {
		this.dayFee = dayFee;
	}

	public String getFlagCode() {
		return flagCode;
	}

	public void setFlagCode(String flagCode) {
		this.flagCode = flagCode;
	}

	public String getFlagName() {
		return flagName;
	}

	public void setFlagName(String flagName) {
		this.flagName = flagName;
	}

	@Override
	public String toString() {
		return "UserPdPrcDetailInfoEntity [prodPrcid=" + prodPrcid + ", prcName=" + prcName + ", detailCode=" + detailCode + ", detailNote="
				+ detailNote + ", detailType=" + detailType + ", detailTypeName=" + detailTypeName + ", beginTime=" + beginTime + ", endTime="
				+ endTime + ", loginAccept=" + loginAccept + ", loginNo=" + loginNo + ", monFee=" + monFee + ", dayFee=" + dayFee
				+ ", detailStaticType=" + detailStaticType + ", flagCode=" + flagCode + ", flagName=" + flagName + ", shareFlag=" + shareFlag
				+ ", dayFlag=" + dayFlag + ", monthFlag=" + monthFlag + ", prcClass=" + prcClass + "]";
	}

}