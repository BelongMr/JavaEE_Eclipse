package com.sitech.acctmgr.atom.dto.adj;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

/**
 *
 * <p>Title:   投诉退费查询入参DTO</p>
 * <p>Description:   对入参进行解析成MBean，并检验入参的正确性</p>
 * <p>Copyright: Copyright (c) 2016</p>
 * <p>Company: SI-TECH </p>
 * @author guowy
 * @version 1.0
 */
public class S8041QryInDTO extends CommonInDTO{
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5089777433388514662L;
	
	@ParamDesc(path="BUSI_INFO.PHONE_NO",cons=ConsType.QUES,type="String",len="40",desc="服务号码",memo="略")
	protected String phoneNo;
	@ParamDesc(path="BUSI_INFO.LOGIN_IN",cons=ConsType.QUES,type="String",len="20",desc="查询工号",memo="略")
	protected String loginIn;
	@ParamDesc(path="BUSI_INFO.BEGIN_TIME",cons=ConsType.CT001,type="String",len="18",desc="开始时间",memo="略")
	protected String beginTime;
	@ParamDesc(path="BUSI_INFO.END_TIME",cons=ConsType.CT001,type="String",len="18",desc="开始时间",memo="略")
	protected String endTime;
	@ParamDesc(path="BUSI_INFO.YEAR_MONTH",cons=ConsType.CT001,type="String",len="18",desc="退费年月",memo="略")
	protected String yearMonth;
	
	@Override
	public void decode(MBean arg0) {
		super.decode(arg0);
		setPhoneNo(arg0.getStr(getPathByProperName("phoneNo")));
		setLoginIn(arg0.getStr(getPathByProperName("loginIn")));
		setBeginTime(arg0.getStr(getPathByProperName("beginTime")));
		setEndTime(arg0.getStr(getPathByProperName("endTime")));
		setYearMonth(arg0.getStr(getPathByProperName("yearMonth")));
		if(StringUtils.isEmptyOrNull(arg0.getStr(getPathByProperName("opCode")))){
			opCode="8041";
		}
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

	/**
	 * @return the loginIn
	 */
	public String getLoginIn() {
		return loginIn;
	}

	/**
	 * @param loginIn the loginIn to set
	 */
	public void setLoginIn(String loginIn) {
		this.loginIn = loginIn;
	}

	/**
	 * @return the beginTime
	 */
	public String getBeginTime() {
		return beginTime;
	}

	/**
	 * @param beginTime the beginTime to set
	 */
	public void setBeginTime(String beginTime) {
		this.beginTime = beginTime;
	}

	/**
	 * @return the endTime
	 */
	public String getEndTime() {
		return endTime;
	}

	/**
	 * @param endTime the endTime to set
	 */
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getYearMonth() {
		return yearMonth;
	}

	public void setYearMonth(String yearMonth) {
		this.yearMonth = yearMonth;
	}

}
