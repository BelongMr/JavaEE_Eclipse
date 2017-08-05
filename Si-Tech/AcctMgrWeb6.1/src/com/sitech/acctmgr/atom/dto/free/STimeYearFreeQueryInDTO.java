package com.sitech.acctmgr.atom.dto.free;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

public class STimeYearFreeQueryInDTO extends CommonInDTO{
    @ParamDesc(path = "BUSI_INFO.PHONE_NO", cons = ConsType.CT001, desc = "服务号码", len = "15", type = "string", memo = "略")
    private String phoneNo;
    
    @ParamDesc(path = "BUSI_INFO.PRC_ID", cons = ConsType.CT001, desc = "资费ID", len = "", type = "string", memo = "略")
    private String prcId;
    
    @ParamDesc(path = "BUSI_INFO.FAV_CALL", cons = ConsType.CT001, desc = "优惠费用", len = "", type = "string", memo = "单位：分")
    private String favCall;
    
    @ParamDesc(path = "BUSI_INFO.FAV_RATE", cons = ConsType.CT001, desc = "优惠费率", len = "", type = "string", memo = "单位：元 保留两位小数")
    private double favRate;

    @Override
    public void decode(MBean arg0) {
        super.decode(arg0);
        phoneNo = arg0.getStr(getPathByProperName("phoneNo"));
        prcId = arg0.getStr(getPathByProperName("prcId"));
        favCall = arg0.getStr(getPathByProperName("favCall"));
        favRate = Double.parseDouble(arg0.getStr(getPathByProperName("favRate")));
    }

    public String getPhoneNo() {
        return phoneNo;
    }

    public void setPhoneNo(String phoneNo) {
        this.phoneNo = phoneNo;
    }

	public String getPrcId() {
		return prcId;
	}

	public void setPrcId(String prcId) {
		this.prcId = prcId;
	}

	public String getFavCall() {
		return favCall;
	}

	public void setFavCall(String favCall) {
		this.favCall = favCall;
	}

	public double getFavRate() {
		return favRate;
	}

	public void setFavRate(double favRate) {
		this.favRate = favRate;
	}

}