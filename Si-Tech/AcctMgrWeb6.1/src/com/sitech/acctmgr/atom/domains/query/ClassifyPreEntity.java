package com.sitech.acctmgr.atom.domains.query;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;

public class ClassifyPreEntity {
	
    @JSONField(name = "PAY_NAME")
    @ParamDesc(path = "PAY_NAME", cons = ConsType.CT001, len = "40", type = "String", desc = "支付名称", memo = "")
    private String payName;
    
    @JSONField(name = "PREPAY_FEE")
    @ParamDesc(path = "PREPAY_FEE", cons = ConsType.CT001, len = "18", type = "long", desc = "预存金额", memo = "")
    private long prepayFee;
    
    @JSONField(name = "TRANS_FEE")
    @ParamDesc(path = "TRANS_FEE", cons = ConsType.CT001, len = "18", type = "long", desc = "当前可划拨金额", memo = "")
    private long transFee;
    
    @JSONField(name = "BEGIN_DATE")
	@ParamDesc(path="BEGIN_DATE",cons=ConsType.CT001,type="String",len="8",desc="开始日期",memo="略")
	protected String beginDate = "";
    
    @JSONField(name = "END_DATE")
	@ParamDesc(path="END_DATE",cons=ConsType.CT001,type="String",len="8",desc="结束日期",memo="略")
	protected String endDate = "";
    
    @JSONField(name = "PAY_TYPE")
	@ParamDesc(path="PAY_TYPE",cons=ConsType.CT001,type="String",len="5",desc="支付类型",memo="略")
	protected String payType = "";
    
    @JSONField(name = "TRANS_FLAG")
	@ParamDesc(path="TRANS_FLAG",cons=ConsType.CT001,type="String",len="1",desc="可转标识",memo="略")
	protected String transFlag = "";
    
    @JSONField(name = "ORDER_CODE")
	@ParamDesc(path="ORDER_CODE",cons=ConsType.CT001,type="long",len="10",desc="预存优先级",memo="略")
	protected long orderCode = 0;
    
    @JSONField(name = "LEFT_MONTHS")
	@ParamDesc(path="LEFT_MONTHS",cons=ConsType.CT001,type="long",len="10",desc="剩余可返还月数",memo="略")
	protected String leftMonths = "";
    
    @JSONField(name = "RETURN_DAY")
	@ParamDesc(path="RETURN_DAY",cons=ConsType.CT001,type="String",len="6",desc="每月返还日",memo="略")
	protected String returnDay = "";
    
    @JSONField(name = "SALE_FLAG")
	@ParamDesc(path="SALE_FLAG",cons=ConsType.CT001,type="String",len="6",desc="上月是否拆包",memo="略")
	protected String saleFlag = "";

	/**
	 * @return the payName
	 */
	public String getPayName() {
		return payName;
	}

	/**
	 * @param payName the payName to set
	 */
	public void setPayName(String payName) {
		this.payName = payName;
	}

	/**
	 * @return the prepayFee
	 */
	public long getPrepayFee() {
		return prepayFee;
	}

	/**
	 * @param prepayFee the prepayFee to set
	 */
	public void setPrepayFee(long prepayFee) {
		this.prepayFee = prepayFee;
	}

	/**
	 * @return the transFee
	 */
	public long getTransFee() {
		return transFee;
	}

	/**
	 * @param transFee the transFee to set
	 */
	public void setTransFee(long transFee) {
		this.transFee = transFee;
	}

	/**
	 * @return the beginDate
	 */
	public String getBeginDate() {
		return beginDate;
	}

	/**
	 * @param beginDate the beginDate to set
	 */
	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}

	/**
	 * @return the endDate
	 */
	public String getEndDate() {
		return endDate;
	}

	/**
	 * @param endDate the endDate to set
	 */
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	/**
	 * @return the payType
	 */
	public String getPayType() {
		return payType;
	}

	/**
	 * @param payType the payType to set
	 */
	public void setPayType(String payType) {
		this.payType = payType;
	}

	/**
	 * @return the transFlag
	 */
	public String getTransFlag() {
		return transFlag;
	}

	/**
	 * @param transFlag the transFlag to set
	 */
	public void setTransFlag(String transFlag) {
		this.transFlag = transFlag;
	}

	/**
	 * @return the orderCode
	 */
	public long getOrderCode() {
		return orderCode;
	}

	/**
	 * @param orderCode the orderCode to set
	 */
	public void setOrderCode(long orderCode) {
		this.orderCode = orderCode;
	}


	/**
	 * @return the returnDay
	 */
	public String getReturnDay() {
		return returnDay;
	}

	/**
	 * @param returnDay the returnDay to set
	 */
	public void setReturnDay(String returnDay) {
		this.returnDay = returnDay;
	}

	/**
	 * @return the saleFlag
	 */
	public String getSaleFlag() {
		return saleFlag;
	}

	/**
	 * @param saleFlag the saleFlag to set
	 */
	public void setSaleFlag(String saleFlag) {
		this.saleFlag = saleFlag;
	}

	/**
	 * @return the leftMonths
	 */
	public String getLeftMonths() {
		return leftMonths;
	}

	/**
	 * @param leftMonths the leftMonths to set
	 */
	public void setLeftMonths(String leftMonths) {
		this.leftMonths = leftMonths;
	}
    
}
