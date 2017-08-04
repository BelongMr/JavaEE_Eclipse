package com.sitech.acctmgr.atom.dto.cct;

import com.sitech.acctmgr.atom.domains.cct.CreditChgHisEntity;
import com.sitech.acctmgr.atom.domains.cct.CreditDetailEntity;
import com.sitech.acctmgr.atom.domains.cct.CreditListEntity;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

import java.util.List;
import java.util.Map;


public class S8157InitOutDTO extends CommonOutDTO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@ParamDesc(path = "CUST_NAME", cons = ConsType.CT001, type = "String", len = "100", desc = "客户名称", memo = "略")
	protected String custName;
	@ParamDesc(path = "PREPAY_FEE", cons = ConsType.CT001, type = "long", len = "18", desc = "预存款", memo = "略")
	protected long prepayFee;
	@ParamDesc(path = "TOTAL_OWE", cons = ConsType.CT001, type = "long", len = "18", desc = "欠费", memo = "略")
	protected long totalOwe;
	@ParamDesc(path = "CREDIT_DETAIL", cons = ConsType.CT001, type = "String", len = "40", desc = "信用度等级明细列表", memo = "略")
	protected List<CreditDetailEntity> creditDetailMsg;
	// 新增
	@ParamDesc(path = "PHONE_NO", cons = ConsType.CT001, type = "String", len = "40", desc = "服务号码", memo = "略")
	protected String phoneNo;
	@ParamDesc(path = "OVER_FEE", cons = ConsType.CT001, type = "long", len = "", desc = "信誉度阀值", memo = "略")
	protected long overFee;
	@ParamDesc(path = "ONLINE_TIME", cons = ConsType.CT001, type = "String", len = "40", desc = "入网时间", memo = "格式：yyyymmdd")
	protected String online_time;
	@ParamDesc(path = "RUN_NAME", cons = ConsType.CT001, type = "String", len = "40", desc = "运行状态", memo = "")
	protected String runName;
	@ParamDesc(path = "BRAND_NAME", cons = ConsType.CT001, type = "String", len = "10", desc = "用户品牌", memo = "略")
	protected String brandName;
	@ParamDesc(path = "CREDIT_NAME", cons = ConsType.CT001, type = "String", len = "100", desc = "信用等级名称", memo = "略")
	protected String creditName;
	@ParamDesc(path = "ID_NO", cons = ConsType.CT001, type = "String", len = "40", desc = "用户ID", memo = "略")
	protected long idNo;
	@ParamDesc(path = "CURYM", cons = ConsType.CT001, type = "String", len = "40", desc = "信用度年月", memo = "略")
	protected String curYM;
	@ParamDesc(path = "SCONSUME", cons = ConsType.CT001, type = "long", len = "10", desc = "月均消费", memo = "略")
	protected long consume;
	@ParamDesc(path = "REGION_NAME", cons = ConsType.CT001, type = "String", len = "40", desc = "归属地市", memo = "略")
	protected String regionName;
	@ParamDesc(path = "CREDIT_LIST", cons = ConsType.CT001, type = "String", len = "40", desc = "信用度等级列表", memo = "略")
	protected List<CreditListEntity> creditList;
	@ParamDesc(path = "REGION_ID", cons = ConsType.CT001, type = "String", len = "40", desc = "归属id", memo = "略")
	protected String regionId;
	//信誉度变更记录LIST
	@ParamDesc(path = "CREDIT_HIS", cons = ConsType.CT001, type = "String", len = "40", desc = "信誉度变更记录列表", memo = "略")
    protected List<CreditChgHisEntity> creditHisList;
	
	// 新增星级信誉
	@ParamDesc(path = "STAR_CREDIT", cons = ConsType.CT001, type = "String", len = "40", desc = "星级信誉度", memo = "略")
	protected String starCredit;

	@Override
	public MBean encode() {
		MBean result = super.encode();
		
		result.setRoot(getPathByProperName("prepayFee"), prepayFee);
		result.setRoot(getPathByProperName("custName"), custName);
		result.setRoot(getPathByProperName("totalOwe"), totalOwe);
		result.setRoot(getPathByProperName("phoneNo"), phoneNo);
		result.setRoot(getPathByProperName("overFee"), overFee);
		result.setRoot(getPathByProperName("runName"), runName);
	/*	if(online_time==null){
			online_time="0";
		}
		result.setRoot(getPathByProperName("online_time"), "在网时间" + online_time
				+ "月");*/
		result.setRoot(getPathByProperName("online_time"),online_time);
		result.setRoot(getPathByProperName("brandName"), brandName);
		result.setRoot(getPathByProperName("creditName"), creditName);
		result.setRoot(getPathByProperName("idNo"), idNo);
		result.setRoot(getPathByProperName("consume"), consume);
		result.setRoot(getPathByProperName("curYM"), curYM);
		result.setRoot(getPathByProperName("regionName"), regionName);
		result.setRoot(getPathByProperName("creditList"), creditList);
		result.setRoot(getPathByProperName("regionId"), regionId);
		result.setRoot(getPathByProperName("creditList"), creditList);
		result.setRoot(getPathByProperName("creditDetailMsg"), this.creditDetailMsg);
	    result.setRoot(getPathByProperName("creditHisList"), this.creditHisList);
	    result.setRoot(getPathByProperName("starCredit"), starCredit);
	    
		log.info(result.toString());
		return result;
	}


	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public double getPrepayFee() {
		return prepayFee;
	}


	public String getPhoneNo() {
		return phoneNo;
	}

	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}

	public String getOnline_time() {
		return online_time;
	}

	public void setOnline_time(String online_time) {
		this.online_time = online_time;
	}

	public String getBrandName() {
		return brandName;
	}

	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}

	public long getIdNo() {
		return idNo;
	}

	public void setIdNo(long idNo) {
		this.idNo = idNo;
	}

	public String getCurYM() {
		return curYM;
	}

	public void setCurYM(String curYM) {
		this.curYM = curYM;
	}

	public String getRegionName() {
		return regionName;
	}

	public void setRegionName(String regionName) {
		this.regionName = regionName;
	}

	public List<CreditListEntity> getCreditList() {
		return creditList;
	}

	public void setCreditList(List<CreditListEntity> creditList) {
		this.creditList = creditList;
	}

	/**
	 * @return the totalOwe
	 */
	public long getTotalOwe() {
		return totalOwe;
	}

	/**
	 * @param totalOwe the totalOwe to set
	 */
	public void setTotalOwe(long totalOwe) {
		this.totalOwe = totalOwe;
	}

	/**
	 * @return the overFee
	 */
	public long getOverFee() {
		return overFee;
	}

	/**
	 * @param overFee the overFee to set
	 */
	public void setOverFee(long overFee) {
		this.overFee = overFee;
	}

	/**
	 * @param prepayFee the prepayFee to set
	 */
	public void setPrepayFee(long prepayFee) {
		this.prepayFee = prepayFee;
	}

	/**
	 * @return the creditName
	 */
	public String getCreditName() {
		return creditName;
	}

	/**
	 * @param creditName the creditName to set
	 */
	public void setCreditName(String creditName) {
		this.creditName = creditName;
	}

	/**
	 * @return the regionId
	 */
	public String getRegionId() {
		return regionId;
	}

	/**
	 * @param regionId the regionId to set
	 */
	public void setRegionId(String regionId) {
		this.regionId = regionId;
	}


	/**
	 * @return the creditHisList
	 */
	public List<CreditChgHisEntity> getCreditHisList() {
		return creditHisList;
	}


	/**
	 * @param creditHisList the creditHisList to set
	 */
	public void setCreditHisList(List<CreditChgHisEntity> creditHisList) {
		this.creditHisList = creditHisList;
	}


	/**
	 * @return the consume
	 */
	public long getConsume() {
		return consume;
	}


	/**
	 * @param consume the consume to set
	 */
	public void setConsume(long consume) {
		this.consume = consume;
	}


	/**
	 * @return the creditDetailMsg
	 */
	public List<CreditDetailEntity> getCreditDetailMsg() {
		return creditDetailMsg;
	}


	/**
	 * @param creditDetailMsg the creditDetailMsg to set
	 */
	public void setCreditDetailMsg(List<CreditDetailEntity> creditDetailMsg) {
		this.creditDetailMsg = creditDetailMsg;
	}


	/**
	 * @return the runName
	 */
	public String getRunName() {
		return runName;
	}


	/**
	 * @param runName the runName to set
	 */
	public void setRunName(String runName) {
		this.runName = runName;
	}


	/**
	 * @return the starCredit
	 */
	public String getStarCredit() {
		return starCredit;
	}


	/**
	 * @param starCredit the starCredit to set
	 */
	public void setStarCredit(String starCredit) {
		this.starCredit = starCredit;
	}
	
	

}
