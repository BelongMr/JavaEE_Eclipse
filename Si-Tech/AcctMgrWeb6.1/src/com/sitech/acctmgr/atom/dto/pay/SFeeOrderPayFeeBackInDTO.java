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
public class SFeeOrderPayFeeBackInDTO extends CommonInDTO{

	private static final long serialVersionUID = -3682083701969326333L;

	@ParamDesc(path="OPR_INFO.ORIGIN_ORDER_LINE_ID",cons=ConsType.CT001,type="String",len="40",desc="原始订单行号",memo="略")
	private String originForeignSn;
	
	@ParamDesc(path="OPR_INFO.CREATE_TIME",cons=ConsType.QUES,type="String",len="14",desc="原始操作时间",memo="格式：YYYYMMDDHH24MISS")
	private String originForeignTime;
	
	@ParamDesc(path="BUSI_INFO.PHONE_NO",cons=ConsType.QUES,type="String",len="40",desc="服务号码",memo="略")
	private String phoneNo;
	
	@ParamDesc(path="BUSI_INFO.PAY_PATH",cons=ConsType.CT001,type="String",len="5",desc="缴费渠道",memo="略")
	private String payPath;
	
	@ParamDesc(path="BUSI_INFO.PAY_METHOD",cons=ConsType.CT001,type="String",len="5",desc="缴费方式",memo="略")
	private String payMethod;
	
	@ParamDesc(path="BUSI_INFO.PAY_FEE",cons=ConsType.CT001,type="String",len="14",desc="金额",memo="单位：分，正向费用的相反数")
	private long payFee;
	
	
	public void decode(MBean arg0){
		
		super.decode(arg0);
		
		originForeignSn = arg0.getStr(getPathByProperName("originForeignSn"));
		originForeignTime = arg0.getStr(getPathByProperName("originForeignTime"));
		phoneNo = arg0.getStr(getPathByProperName("phoneNo"));
		
		payPath = arg0.getStr(getPathByProperName("payPath"));
		payMethod = arg0.getStr(getPathByProperName("payMethod"));
		
		payFee = Long.parseLong(arg0.getStr(getPathByProperName("payFee")));
		
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


	public String getPhoneNo() {
		return phoneNo;
	}


	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
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


	public long getPayFee() {
		return payFee;
	}


	public void setPayFee(long payFee) {
		this.payFee = payFee;
	}

}
