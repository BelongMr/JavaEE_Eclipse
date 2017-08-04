package com.sitech.acctmgr.atom.domains.query;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;

public class SpFeeRecycleEntity {

	@JSONField(name = "SP_NAME")
	@ParamDesc(path = "SP_NAME", cons = ConsType.CT001, len = "40", type = "String", desc = "回收专款名称", memo = "")
	private String spName;

	@JSONField(name = "SP_TYPE")
	@ParamDesc(path = "SP_TYPE", cons = ConsType.CT001, len = "40", type = "String", desc = "回收专款类型", memo = "")
	private String spType;

	@JSONField(name = "RECYCLE_MONEY")
	@ParamDesc(path = "RECYCLE_MONEY", cons = ConsType.CT001, len = "40", type = "long", desc = "回收专款金额", memo = "")
	private long recycleMoney;

	@JSONField(name = "OP_TIME")
	@ParamDesc(path = "OP_TIME", cons = ConsType.CT001, len = "40", type = "String", desc = "专款办理时间", memo = "")
	private String opTime;

	@JSONField(name = "LOGIN_NO")
	@ParamDesc(path = "LOGIN_NO", cons = ConsType.CT001, len = "40", type = "String", desc = "专款办理工号", memo = "")
	private String loginNo;

	@JSONField(name = "OP_CODE")
	@ParamDesc(path = "OP_CODE", cons = ConsType.CT001, len = "40", type = "String", desc = "操作代码", memo = "")
	private String opCode;

	@JSONField(name = "BEGIN_TIME")
	@ParamDesc(path = "BEGIN_TIME", cons = ConsType.CT001, len = "40", type = "String", desc = "生效时间", memo = "")
	private String beginTime;

	@JSONField(name = "END_TIME")
	@ParamDesc(path = "END_TIME", cons = ConsType.CT001, len = "40", type = "String", desc = "失效时间", memo = "")
	private String endTime;

	@JSONField(name = "ACTIVE_NAME")
	@ParamDesc(path = "ACTIVE_NAME", cons = ConsType.CT001, len = "40", type = "String", desc = "营销活动名称", memo = "")
	private String activeName;

	@JSONField(name = "GEARS_NAME")
	@ParamDesc(path = "GEARS_NAME", cons = ConsType.CT001, len = "40", type = "String", desc = "营销档位名称", memo = "")
	private String gearsName;

	@JSONField(name = "ACTIVE_INFO")
	@ParamDesc(path = "ACTIVE_INFO", cons = ConsType.CT001, len = "40", type = "String", desc = "营销活动信息", memo = "")
	private String activeInfo;

	@JSONField(name = "PAY_SN")
	@ParamDesc(path = "PAY_SN", cons = ConsType.CT001, len = "40", type = "String", desc = "流水", memo = "")
	private long paySn;

	public String getActiveInfo() {
		return activeInfo;
	}

	public void setActiveInfo(String activeInfo) {
		this.activeInfo = activeInfo;
	}

	public long getPaySn() {
		return paySn;
	}

	public void setPaySn(long paySn) {
		this.paySn = paySn;
	}

	public String getSpName() {
		return spName;
	}

	public void setSpName(String spName) {
		this.spName = spName;
	}

	public String getSpType() {
		return spType;
	}

	public void setSpType(String spType) {
		this.spType = spType;
	}

	public long getRecycleMoney() {
		return recycleMoney;
	}

	public void setRecycleMoney(long recycleMoney) {
		this.recycleMoney = recycleMoney;
	}

	public String getOpTime() {
		return opTime;
	}

	public void setOpTime(String opTime) {
		this.opTime = opTime;
	}

	public String getLoginNo() {
		return loginNo;
	}

	public void setLoginNo(String loginNo) {
		this.loginNo = loginNo;
	}

	public String getOpCode() {
		return opCode;
	}

	public void setOpCode(String opCode) {
		this.opCode = opCode;
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

	public String getActiveName() {
		return activeName;
	}

	public void setActiveName(String activeName) {
		this.activeName = activeName;
	}

	public String getGearsName() {
		return gearsName;
	}

	public void setGearsName(String gearsName) {
		this.gearsName = gearsName;
	}

}
