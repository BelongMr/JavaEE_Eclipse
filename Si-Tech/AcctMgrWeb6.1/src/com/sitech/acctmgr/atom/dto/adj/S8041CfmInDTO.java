package com.sitech.acctmgr.atom.dto.adj;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

/**
 *
 * <p>Title:   投诉退费确认入参DTO</p>
 * <p>Description:   对入参进行解析成MBean，并检验入参的正确性</p>
 * <p>Copyright: Copyright (c) 2016</p>
 * <p>Company: SI-TECH </p>
 * @author liuyc_billing
 * @version 1.0
 */
public class S8041CfmInDTO extends CommonInDTO{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3126459383379854449L;
	
	@ParamDesc(path="BUSI_INFO.PHONE_NO",cons=ConsType.CT001,type="String",len="40",desc="服务号码",memo="略")
	protected String phoneNo;
	@ParamDesc(path="BUSI_INFO.RETURN_TYPE",cons=ConsType.QUES,type="String",len="1",desc="退费种类",memo="略")
	protected String returnTypeFlag;
	@ParamDesc(path="BUSI_INFO.IVR_FLAG",cons=ConsType.QUES,type="String",len="1",desc="IVR",memo="略")
	protected String ivrFlag;
	@ParamDesc(path="BUSI_INFO.REMARK",cons=ConsType.QUES,type="String",len="1024",desc="备注",memo="略")
	protected String remark ;
	@ParamDesc(path="BUSI_INFO.BACK_MONEY",cons=ConsType.CT001,type="long",len="14",desc="退费金额",memo="略")
	protected long backMoney;
	@ParamDesc(path="BUSI_INFO.COMP_MONEY",cons=ConsType.CT001,type="long",len="14",desc="补偿金额",memo="略")
	protected long compMoney;
	@ParamDesc(path="BUSI_INFO.BACK_TYPE",cons=ConsType.CT001,type="String",len="1",desc="补偿类型",memo="补偿类型  1：单倍  2: 双倍")
	protected String backType;
	@ParamDesc(path="BUSI_INFO.ERR_SERIAL",cons=ConsType.CT001,type="String",len="1024",desc="投诉工单号",memo="略")
	protected String errSerial;
	@ParamDesc(path="BUSI_INFO.SP_DETAIL_EMP",cons=ConsType.QUES,type="String",len="300",desc="sp企业代码",memo="企业代码")
	protected String spDetailEmp;
	@ParamDesc(path="BUSI_INFO.SP_DETAIL_BUS",cons=ConsType.QUES,type="String",len="300",desc="sp业务代码",memo="业务代码")
	protected String spDetailBusiness;
	@ParamDesc(path="BUSI_INFO.SP_DETAIL_EMP_NAME",cons=ConsType.QUES,type="String",len="300",desc="sp业务代码",memo="业务代码")
	protected String spDetailEmpName;
	@ParamDesc(path="BUSI_INFO.SP_DETAIL_BUS_NAME",cons=ConsType.QUES,type="String",len="300",desc="sp业务代码",memo="业务代码")
	protected String spDetailBusinessName;
	@ParamDesc(path="BUSI_INFO.ADJ_REASON",cons=ConsType.QUES,type="String",len="200",desc="退费原因",memo="一级原因|二级原因|三级原因")
	protected String adjReason;
	@ParamDesc(path="BUSI_INFO.SUB_TYPE",cons=ConsType.CT001,type="String",len="40",desc="核减类型",memo="略")
	protected String adjSubType;
	@ParamDesc(path="BUSI_INFO.BILL_TYPE",cons=ConsType.CT001,type="String",len="40",desc="计费类型",memo="略")
	protected String adjBillType;
	@ParamDesc(path="BUSI_INFO.SP_FLAG",cons=ConsType.CT001,type="String",len="1",desc="sp类型",memo=" 1：非SP 2: SP")
	protected String spFlag;
	@ParamDesc(path="BUSI_INFO.CHECK_TIME",cons=ConsType.QUES,type="String",len="200",desc="核减时间",memo="")
	protected String checkTime;
	@ParamDesc(path="BUSI_INFO.LAST_TIME",cons=ConsType.QUES,type="String",len="200",desc="业务使用时间",memo="")
	protected String lastTime;
	@ParamDesc(path="BUSI_INFO.UNIT_PRICE",cons=ConsType.QUES,type="String",len="200",desc="单价",memo="")
	protected String unitPrice;
	@ParamDesc(path="BUSI_INFO.QUANTITY",cons=ConsType.QUES,type="String",len="200",desc="数量",memo="")
	protected String quantity;
	@ParamDesc(path="BUSI_INFO.BEGIN_TIME",cons=ConsType.QUES,type="String",len="200",desc="开始时间",memo="针对8054")
	protected String beginTime;
	@ParamDesc(path="BUSI_INFO.END_TIME",cons=ConsType.QUES,type="String",len="200",desc="结束时间",memo="针对8054")
	protected String endTime;
	@ParamDesc(path="BUSI_INFO.BACK_BUSY_CODE",cons=ConsType.QUES,type="String",len="200",desc="退费业务代码",memo="针对8054")
	protected String backBusyCode;
	@ParamDesc(path="BUSI_INFO.BACK_BUSY_NAME",cons=ConsType.QUES,type="String",len="200",desc="退费业务名称",memo="针对8054")
	protected String backBusyName;
	@ParamDesc(path="BUSI_INFO.PAGE_FLAG",cons=ConsType.QUES,type="String",len="2",desc="退费页面标志",memo="0:8041退费;1:GPRS退费;2:梦网退费,3:一键退费")
	protected String pageFlag;

	@Override
	public void decode(MBean arg0) {
		super.decode(arg0);
		setPhoneNo(arg0.getStr(getPathByProperName("phoneNo")));
		setReturnTypeFlag(arg0.getStr(getPathByProperName("returnTypeFlag")));
		setIvrFlag(arg0.getStr(getPathByProperName("ivrFlag")));
		setRemark(arg0.getStr(getPathByProperName("remark")));
		setBackMoney(Long.parseLong(arg0.getObject(getPathByProperName("backMoney")).toString()));
		setCompMoney(Long.parseLong(arg0.getObject(getPathByProperName("compMoney")).toString()));
		setBackType(arg0.getStr(getPathByProperName("backType")));
		setErrSerial(arg0.getStr(getPathByProperName("errSerial")));
		setLastTime(arg0.getStr(getPathByProperName("lastTime")));
		setSpDetailEmp(arg0.getStr(getPathByProperName("spDetailEmp")));
		setSpDetailEmpName(arg0.getStr(getPathByProperName("spDetailEmpName")));
		setSpDetailBusiness(arg0.getStr(getPathByProperName("spDetailBusiness")));
		setSpDetailBusinessName(arg0.getStr(getPathByProperName("spDetailBusinessName")));
		setQuantity(arg0.getStr(getPathByProperName("quantity")));
		setSpFlag(arg0.getStr(getPathByProperName("spFlag")));
		setUnitPrice(arg0.getStr(getPathByProperName("unitPrice")));
		setCheckTime(arg0.getStr(getPathByProperName("checkTime")));
		setBeginTime(arg0.getStr(getPathByProperName("beginTime")));
		setEndTime(arg0.getStr(getPathByProperName("endTime")));
		setBackBusyCode(arg0.getStr(getPathByProperName("backBusyCode")));
		setBackBusyName(arg0.getStr(getPathByProperName("backBusyName")));
		setAdjSubType(arg0.getStr(getPathByProperName("adjSubType")));
		setAdjBillType(arg0.getStr(getPathByProperName("adjBillType")));
		setAdjReason(arg0.getStr(getPathByProperName("adjReason")));
		setPageFlag(arg0.getStr(getPathByProperName("pageFlag")));
		if(StringUtils.isEmptyOrNull(arg0.getStr(getPathByProperName("opCode")))){
			opCode="8041";
		}
	}

	
	public String getReturnTypeFlag() {
		return returnTypeFlag;
	}

	public void setReturnTypeFlag(String returnTypeFlag) {
		this.returnTypeFlag = returnTypeFlag;
	}


	public String getCheckTime() {
		return checkTime;
	}

	public void setCheckTime(String checkTime) {
		this.checkTime = checkTime;
	}

	public String getIvrFlag() {
		return ivrFlag;
	}


	public void setIvrFlag(String ivrFlag) {
		this.ivrFlag = ivrFlag;
	}

	public String getLastTime() {
		return lastTime;
	}

	public void setLastTime(String lastTime) {
		this.lastTime = lastTime;
	}

	public String getUnitPrice() {
		return unitPrice;
	}

	
	public void setUnitPrice(String unitPrice) {
		this.unitPrice = unitPrice;
	}

	public String getQuantity() {
		return quantity;
	}

	public void setQuantity(String quantity) {
		this.quantity = quantity;
	}


	public String getAdjSubType() {
		return adjSubType;
	}



	public void setAdjSubType(String adjSubType) {
		this.adjSubType = adjSubType;
	}



	public String getAdjBillType() {
		return adjBillType;
	}



	public void setAdjBillType(String adjBillType) {
		this.adjBillType = adjBillType;
	}


	
	public String getSpFlag() {
		return spFlag;
	}


	public void setSpFlag(String spFlag) {
		this.spFlag = spFlag;
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
	 * @return the remark
	 */

	public String getRemark() {
		return remark;
	}


	/**
	 * @param remark the remark to set
	 */
	public void setRemark(String remark) {
		this.remark = remark;
	}


	/**
	 * @return the backMoney
	 */
	public long getBackMoney() {
		return backMoney;
	}


	/**
	 * @param backMoney the backMoney to set
	 */
	public void setBackMoney(long backMoney) {
		this.backMoney = backMoney;
	}


	/**
	 * @return the compMoney
	 */
	public long getCompMoney() {
		return compMoney;
	}


	/**
	 * @param compMoney the compMoney to set
	 */
	public void setCompMoney(long compMoney) {
		this.compMoney = compMoney;
	}


	/**
	 * @return the backType
	 */
	public String getBackType() {
		return backType;
	}


	/**
	 * @param backType the backType to set
	 */
	public void setBackType(String backType) {
		this.backType = backType;
	}


	/**
	 * @return the errSerial
	 */
	public String getErrSerial() {
		return errSerial;
	}


	/**
	 * @param errSerial the errSerial to set
	 */
	public void setErrSerial(String errSerial) {
		this.errSerial = errSerial;
	}


	/**
	 * @return the adjReason
	 */
	public String getAdjReason() {
		return adjReason;
	}


	/**
	 * @param adjReason the adjReason to set
	 */
	public void setAdjReason(String adjReason) {
		this.adjReason = adjReason;
	}

	public String getSpDetailEmp() {
		return spDetailEmp;
	}


	public void setSpDetailEmp(String spDetailEmp) {
		this.spDetailEmp = spDetailEmp;
	}

	public String getSpDetailBusiness() {
		return spDetailBusiness;
	}


	public void setSpDetailBusiness(String spDetailBusiness) {
		this.spDetailBusiness = spDetailBusiness;
	}
	/**
	 * 
	 * @return
	 */
	public String getSpDetailEmpName() {
		return spDetailEmpName;
	}

	/**
	 * 
	 * @param spDetailEmpName
	 */
	public void setSpDetailEmpName(String spDetailEmpName) {
		this.spDetailEmpName = spDetailEmpName;
	}

	/**
	 * 
	 * @return
	 */
	public String getSpDetailBusinessName() {
		return spDetailBusinessName;
	}

	/**
	 * 
	 * @param spDetailBusinessName
	 */
	public void setSpDetailBusinessName(String spDetailBusinessName) {
		this.spDetailBusinessName = spDetailBusinessName;
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


	public String getBackBusyCode() {
		return backBusyCode;
	}


	public void setBackBusyCode(String backBusyCode) {
		this.backBusyCode = backBusyCode;
	}


	public String getBackBusyName() {
		return backBusyName;
	}


	public void setBackBusyName(String backBusyName) {
		this.backBusyName = backBusyName;
	}


	public String getPageFlag() {
		return pageFlag;
	}


	public void setPageFlag(String pageFlag) {
		this.pageFlag = pageFlag;
	}



}
