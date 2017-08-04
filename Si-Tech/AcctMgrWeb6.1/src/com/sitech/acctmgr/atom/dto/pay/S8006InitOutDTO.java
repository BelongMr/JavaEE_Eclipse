package com.sitech.acctmgr.atom.dto.pay;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.acctmgr.atom.domains.fee.OweFeeEntity;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

import java.util.List;

/**
 * <p>Title: 陈死账回收查询出参DTO  </p>
 * <p>Description:   </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author linzc
 * @version 1.0
 */
public class S8006InitOutDTO extends CommonOutDTO{

	/**
	 * 
	 */
	private static final long serialVersionUID = -557699502100856055L;
	
	@JSONField(name="CUST_NAME")
	@ParamDesc(path="CUST_NAME",cons=ConsType.CT001,type="String",len="40",desc="客户名称",memo="略")
	protected	String custName;
	@JSONField(name="PHONE_NO")
	@ParamDesc(path="PHONE_NO",cons=ConsType.CT001,type="String",len="40",desc="服务号码",memo="略")
	protected	String phoneNo;
	@JSONField(name="USER_GRADE_CODE")
	@ParamDesc(path="USER_GRADE_CODE",cons=ConsType.CT001,type="String",len="40",desc="用户组ID",memo="略")
	protected	String	userGroupID;
	@JSONField(name="BRAND_NAME")
	@ParamDesc(path="BRAND_NAME",cons=ConsType.CT001,type="String",len="40",desc="品牌名称",memo="略")
	protected	String	brandName;
	@JSONField(name="BALANCE")
	@ParamDesc(path="BALANCE",cons=ConsType.CT001,type="long",len="40",desc="当前账本余额",memo="略")
	protected	long	balance;
	@JSONField(name="CONTRACT_NO")
	@ParamDesc(path="CONTRACT_NO",cons=ConsType.CT001,type="long",len="40",desc="账户号码",memo="略")
	protected	long	contractNo;
	@JSONField(name="UNBILL_FEE")
	@ParamDesc(path="UNBILL_FEE",cons=ConsType.CT001,type="long",len="40",desc="未付账单金额",memo="略")
	protected	long	unbillFee;
	@JSONField(name="LIMIT_OWE")
	@ParamDesc(path="LIMIT_OWE",cons=ConsType.CT001,type="long",len="40",desc="信誉度",memo="略")
	protected	long	limitOwe;
	@JSONField(name="REGION_NAME")
	@ParamDesc(path="REGION_NAME",cons=ConsType.CT001,type="String",len="40",desc="归属地名称",memo="略")
	protected	String	regionName;
	@JSONField(name="RUN_TIME")
	@ParamDesc(path="RUN_TIME",cons=ConsType.CT001,type="String",len="40",desc="运行时间",memo="略")
	protected	String	runTime;
	@JSONField(name="FLAG")
	@ParamDesc(path="FLAG",cons=ConsType.CT001,type="String",len="40",desc="异地标识",memo="略")
	protected	String	flag;
	@JSONField(name="SUM_OWE_FEE")
	@ParamDesc(path="SUM_OWE_FEE",cons=ConsType.CT001,type="long",len="40",desc="总欠费",memo="略")
	protected	long	sumOweFee;
	@JSONField(name="SUM_DELAY_FEE")
	@ParamDesc(path="SUM_DELAY_FEE",cons=ConsType.CT001,type="long",len="40",desc="总滞纳金",memo="略")
	protected	long	sumDelayFee;
	@JSONField(name="CODE_NAME")
	@ParamDesc(path="CODE_NAME",cons=ConsType.CT001,type="String",len="40",desc="大客户级别",memo="略")
	protected	String	codeName;
	@JSONField(name="NUM_FLAG")
	@ParamDesc(path="NUM_FLAG",cons=ConsType.CT001,type="String",len="40",desc="欠费列表数量",memo="略")
	protected	String	numFlag;
	@JSONField(name="ID_NO")
	@ParamDesc(path="ID_NO",cons=ConsType.CT001,type="long",len="40",desc="用户ID",memo="略")
	protected	long	idNo;
	@JSONField(name="DELAY_ABLE")
	@ParamDesc(path="DELAY_ABLE",cons=ConsType.CT001,type="boolean",len="10",desc="滞纳金优惠率权限",memo="true:有权限,false:无权限")
	protected	boolean	delayAble;
	@JSONField(name="FEE_INFO")
	@ParamDesc(path="FEE_INFO",cons=ConsType.STAR,type="compx",len="1",desc="欠费列表",memo="略")
	protected	List<OweFeeEntity> feeInfoList;
	@JSONField(name="ID_ICCID")
	@ParamDesc(path="ID_ICCID",cons=ConsType.CT001,type="String",len="40",desc="身份证号",memo="略")
	protected	String	idIccid;
	
	

	public MBean encode() {
		MBean result = new MBean();
		
		result.setRoot(getPathByProperName("custName"), custName);
		result.setRoot(getPathByProperName("userGroupID"), userGroupID);
		result.setRoot(getPathByProperName("brandName"), brandName);
		result.setRoot(getPathByProperName("balance"), balance);
		result.setRoot(getPathByProperName("contractNo"), contractNo);
		result.setRoot(getPathByProperName("unbillFee"), unbillFee);
		result.setRoot(getPathByProperName("limitOwe"), limitOwe);
		result.setRoot(getPathByProperName("regionName"), regionName);
		result.setRoot(getPathByProperName("runTime"), runTime);
		result.setRoot(getPathByProperName("flag"), flag);
		result.setRoot(getPathByProperName("sumOweFee"), sumOweFee);
		result.setRoot(getPathByProperName("sumDelayFee"), sumDelayFee);
		result.setRoot(getPathByProperName("codeName"), codeName);
		result.setRoot(getPathByProperName("numFlag"), numFlag);
		result.setRoot(getPathByProperName("idNo"), idNo);
		result.setRoot(getPathByProperName("phoneNo"), phoneNo);
		result.setRoot(getPathByProperName("delayAble"), delayAble);
		result.setRoot(getPathByProperName("feeInfoList"), feeInfoList);
		result.setRoot(getPathByProperName("idIccid"), idIccid);
		return result;
	}



	public String getPhoneNo() {
		return phoneNo;
	}



	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}



	public String getCustName() {
		return custName;
	}



	public void setCustName(String custName) {
		this.custName = custName;
	}



	public String getUserGroupID() {
		return userGroupID;
	}



	public void setUserGroupID(String userGroupID) {
		this.userGroupID = userGroupID;
	}



	public String getBrandName() {
		return brandName;
	}



	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}

	public long getBalance() {
		return balance;
	}



	public void setBalance(long balance) {
		this.balance = balance;
	}



	public long getContractNo() {
		return contractNo;
	}



	public void setContractNo(long contractNo) {
		this.contractNo = contractNo;
	}



	public long getUnbillFee() {
		return unbillFee;
	}



	public void setUnbillFee(long unbillFee) {
		this.unbillFee = unbillFee;
	}



	public long getLimitOwe() {
		return limitOwe;
	}



	public void setLimitOwe(long limitOwe) {
		this.limitOwe = limitOwe;
	}



	public String getRegionName() {
		return regionName;
	}



	public void setRegionName(String regionName) {
		this.regionName = regionName;
	}



	public String getRunTime() {
		return runTime;
	}



	public void setRunTime(String runTime) {
		this.runTime = runTime;
	}



	public String getFlag() {
		return flag;
	}



	public void setFlag(String flag) {
		this.flag = flag;
	}



	public long getSumOweFee() {
		return sumOweFee;
	}



	public void setSumOweFee(long sumOweFee) {
		this.sumOweFee = sumOweFee;
	}



	public long getSumDelayFee() {
		return sumDelayFee;
	}



	/**
	 * @return the delayAble
	 */
	public boolean isDelayAble() {
		return delayAble;
	}



	/**
	 * @param delayAble the delayAble to set
	 */
	public void setDelayAble(boolean delayAble) {
		this.delayAble = delayAble;
	}



	public void setSumDelayFee(long sumDelayFee) {
		this.sumDelayFee = sumDelayFee;
	}



	public String getCodeName() {
		return codeName;
	}



	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}



	public String getNumFlag() {
		return numFlag;
	}



	public void setNumFlag(String numFlag) {
		this.numFlag = numFlag;
	}



	public long getIdNo() {
		return idNo;
	}



	public void setIdNo(long idNo) {
		this.idNo = idNo;
	}



	public List<OweFeeEntity> getFeeInfoList() {
		return feeInfoList;
	}



	public void setFeeInfoList(List<OweFeeEntity> feeInfoList) {
		this.feeInfoList = feeInfoList;
	}



	public String getIdIccid() {
		return idIccid;
	}



	public void setIdIccid(String idIccid) {
		this.idIccid = idIccid;
	}

	

	
}
