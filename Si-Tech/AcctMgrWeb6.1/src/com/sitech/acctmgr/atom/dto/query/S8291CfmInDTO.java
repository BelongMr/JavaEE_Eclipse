package com.sitech.acctmgr.atom.dto.query;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

public class S8291CfmInDTO extends CommonInDTO{
	@ParamDesc(path="BUSI_INFO.PHONE_NO",cons=ConsType.QUES,type="String",len="40",desc="服务号码",memo="略")
	private String phoneNo;
	@ParamDesc(path="BUSI_INFO.BEGIN_TIME",cons=ConsType.QUES,type="String",len="14",desc="开始时间",memo="略")
	private String beginTime;
	@ParamDesc(path="BUSI_INFO.END_TIME",cons=ConsType.QUES,type="String",len="14",desc="结束时间",memo="略")
	private String endTime;
	@ParamDesc(path="BUSI_INFO.DETAIL_TYPE",cons=ConsType.QUES,type="String",len="1",desc="退费备注查询标志",memo="略")
	private String detailType;
	
	public void decode(MBean arg0){
		super.decode(arg0);
		
		setPhoneNo(arg0.getObject(getPathByProperName("phoneNo")).toString());
		setBeginTime(arg0.getObject(getPathByProperName("beginTime")).toString());
		setEndTime(arg0.getObject(getPathByProperName("endTime")).toString());
		setDetailType(arg0.getObject(getPathByProperName("detailType")).toString());
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

	/**
	 * @return the detailType
	 */
	public String getDetailType() {
		return detailType;
	}

	/**
	 * @param detailType the detailType to set
	 */
	public void setDetailType(String detailType) {
		this.detailType = detailType;
	}
}
