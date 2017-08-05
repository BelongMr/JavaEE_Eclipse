package com.sitech.acctmgr.atom.dto.pay;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

/**
 *
 * <p>Title:   </p>
 * <p>Description:   </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author 
 * @version 1.0
 */
public class SFeeOrderPayBackForMrInDTO extends CommonInDTO{

	private static final long serialVersionUID = -3682083701969326333L;

	@ParamDesc(path="OPR_INFO.ORIGIN_ORDER_LINE_ID",cons=ConsType.CT001,type="String",len="40",desc="原始订单行号",memo="略")
	private String originForeignSn;
	
	@ParamDesc(path="OPR_INFO.CREATE_TIME",cons=ConsType.QUES,type="String",len="14",desc="原始操作时间",memo="格式：YYYYMMDDHH24MISS")
	private String originForeignTime;
	
	@ParamDesc(path="OPR_INFO.ORDER_LINE_ID",cons=ConsType.CT001,type="String",len="40",desc="订单行号",memo="略")
	private String foreignSn;
	
	@ParamDesc(path="BUSI_INFO.PAY_PATH",cons=ConsType.CT001,type="String",len="5",desc="缴费渠道",memo="略")
	private String payPath;
	
	@ParamDesc(path="BUSI_INFO.PAY_METHOD",cons=ConsType.CT001,type="String",len="5",desc="缴费方式",memo="略")
	private String payMethod;
	
	@ParamDesc(path="BUSI_INFO.PAY_TYPE",cons=ConsType.CT001,type="String",len="5",desc="账本类型",memo="略")
	private String payType;
	
	
	public void decode(MBean arg0){
		
		super.decode(arg0);
		
		originForeignSn = arg0.getStr(getPathByProperName("originForeignSn"));
		originForeignTime = arg0.getStr(getPathByProperName("originForeignTime"));
		foreignSn = arg0.getStr(getPathByProperName("foreignSn"));
		payPath = arg0.getStr(getPathByProperName("payPath"));
		payMethod = arg0.getStr(getPathByProperName("payMethod"));
		payType = arg0.getStr(getPathByProperName("payType"));
	}




	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "SFeeOrderPayBackForMrInDTO [originForeignSn=" + originForeignSn + ", originForeignTime=" + originForeignTime
				+ ", foreignSn=" + foreignSn + ", payPath=" + payPath + ", payMethod=" + payMethod + "]";
	}

	public String getOriginForeignSn() {
		return originForeignSn;
	}

	public void setOriginForeignSn(String originForeignSn) {
		this.originForeignSn = originForeignSn;
	}

	public String getOriginForeignTime() {
		return originForeignTime;
	}

	public void setOriginForeignTime(String originForeignTime) {
		this.originForeignTime = originForeignTime;
	}

	public String getForeignSn() {
		return foreignSn;
	}

	public void setForeignSn(String foreignSn) {
		this.foreignSn = foreignSn;
	}

	public String getPayPath() {
		return payPath;
	}

	public void setPayPath(String payPath) {
		this.payPath = payPath;
	}

	public String getPayMethod() {
		return payMethod;
	}

	public void setPayMethod(String payMethod) {
		this.payMethod = payMethod;
	}

	public String getPayType() {
		return payType;
	}

	public void setPayType(String payType) {
		this.payType = payType;
	}

}