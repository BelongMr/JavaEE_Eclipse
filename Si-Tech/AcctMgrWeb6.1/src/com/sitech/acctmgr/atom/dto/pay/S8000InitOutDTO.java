package com.sitech.acctmgr.atom.dto.pay;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.fee.OweFeeEntity;
import com.sitech.acctmgr.atom.domains.pay.ChequeEntity;
import com.sitech.acctmgr.atom.domains.pay.PayOutUserData;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * <p>Title: 缴费查询出参DTO  </p>
 * <p>Description: 缴费查询出参DTO，封装出参情况  </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author zhangjp
 * @version 1.0
 */
@SuppressWarnings("serial")
public class S8000InitOutDTO extends CommonOutDTO implements Serializable  {
	
	@JSONField(name="USER_DATA")
	@ParamDesc(path="USER_DATA",cons=ConsType.CT001,type="complex",len="1",desc="用户相关资料信息",memo="略")
	private PayOutUserData userData;
	
	@JSONField(name="FEE_DATA")
	@ParamDesc(path="FEE_DATA",cons=ConsType.CT001,type="complex",len="1",desc="费用基本信息",memo="略")
	private OutFeeData feeData;
	
	@JSONField(name="OWEFEEINFO_SIZE")
	@ParamDesc(path="OWEFEEINFO_SIZE",cons=ConsType.CT001,type="int",len="8",desc="账单数",memo="略")
	private int owefeeInfoSize;
	
	@JSONField(name="OWEFEEINFO")
	@ParamDesc(path="OWEFEEINFO",cons=ConsType.STAR,type="complex",len="1",desc="欠费列表",memo="略")
	private List<OweFeeEntity> owefeeInfo = new ArrayList<OweFeeEntity>();

	@JSONField(name="THINGS_FLAG")
	@ParamDesc(path="THINGS_FLAG",cons=ConsType.CT001,type="String",len="1",desc="是否物联网号码",memo="0:否 1：是")
	private String thingsFlag;
	
	
	/* (non-Javadoc)
	 * @see com.sitech.jcfx.dt.out.OutDTO#encode()
	 */
	@Override
	public MBean encode() {
		MBean result = super.encode();
		
		result.setRoot(getPathByProperName("userData"), userData);
		result.setRoot(getPathByProperName("feeData"), feeData);

		result.setRoot(getPathByProperName("owefeeInfoSize"), owefeeInfoSize);
		result.setRoot(getPathByProperName("owefeeInfo"), owefeeInfo);
		result.setRoot(getPathByProperName("thingsFlag"), thingsFlag);
		return result;
	}


	public PayOutUserData getUserData() {
		return userData;
	}


	public void setUserData(PayOutUserData userData) {
		this.userData = userData;
	}


	public OutFeeData getFeeData() {
		return feeData;
	}


	public void setFeeData(OutFeeData feeData) {
		this.feeData = feeData;
	}


	public int getOwefeeInfoSize() {
		return owefeeInfoSize;
	}


	public void setOwefeeInfoSize(int owefeeInfoSize) {
		this.owefeeInfoSize = owefeeInfoSize;
	}


	public List<OweFeeEntity> getOwefeeInfo() {
		return owefeeInfo;
	}


	public void setOwefeeInfo(List<OweFeeEntity> owefeeInfo) {
		this.owefeeInfo = owefeeInfo;
	}


	public String getThingsFlag() {
		return thingsFlag;
	}


	public void setThingsFlag(String thingsFlag) {
		this.thingsFlag = thingsFlag;
	}

}
