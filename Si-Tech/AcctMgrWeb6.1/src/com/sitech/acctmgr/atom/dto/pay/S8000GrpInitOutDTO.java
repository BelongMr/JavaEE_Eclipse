package com.sitech.acctmgr.atom.dto.pay;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.fee.OweFeeEntity;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * <p>Title:   </p>
 * <p>Description:   </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author 
 * @version 1.0
 */
public class S8000GrpInitOutDTO extends CommonOutDTO{

	private static final long serialVersionUID = -351207351259610681L;
	
	@ParamDesc(path="CONTRACT_NO",cons=ConsType.CT001,type="long",len="18",desc="账号",memo="略")
	private long 	contractNo;
	
	@ParamDesc(path="CONTRACT_NAME",cons=ConsType.CT001,type="String",len="100",desc="账户名称",memo="略")
	private String	contractName;
	
	@ParamDesc(path="PAYCODE_NAME",cons=ConsType.CT001,type="String",len="200",desc="付款方式",memo="略")
	private String	payCodeName;		//付款方式
	
	@ParamDesc(path="ID_NUMS",cons=ConsType.CT001,type="long",len="10",desc="用户数量",memo="略")
	private long	idNums;			//用户数量

	@JSONField(name="FEE_DATA")
	@ParamDesc(path="FEE_DATA",cons=ConsType.CT001,type="compx",len="1",desc="费用基本信息",memo="略")
	private OutFeeData feeData;
	
	/*欠费列表
	* <ul>
	* 	<li>BILL_CYCLE  		</li>
	*   <li>OWE_FEE				</li>
	*   <li>DELAY_FEE			</li>
	*   <li>SHOULD_PAY			</li>
	*   <li>FAVOUR_FEE			</li>
	*   <li>PAYED_FEE:已缴欠费		</li>
	* </ul>
	 **/
	@ParamDesc(path="OWEFEE_LIST",cons=ConsType.STAR,type="compx",len="1",desc="欠费列表",memo="略")
	private List<OweFeeEntity> oweFeeList = new ArrayList<OweFeeEntity>();
	
	@ParamDesc(path="BRAND_ID",cons=ConsType.CT001,type="String",len="6",desc="用户品牌ID",memo="略")
	private String	brandId;

	public MBean encode(){
		MBean result = super.encode();
		result.setRoot(getPathByProperName("contractNo"), contractNo);
		result.setRoot(getPathByProperName("contractName"), contractName);
		result.setRoot(getPathByProperName("idNums"), idNums);
		result.setRoot(getPathByProperName("payCodeName"), payCodeName);
		result.setRoot(getPathByProperName("feeData"), feeData);
		result.setRoot(getPathByProperName("oweFeeList"), oweFeeList);
		result.setRoot(getPathByProperName("brandId"), brandId);
		
		return result;
	}

	
	

	/**
	 * @return the contractNo
	 */
	public long getContractNo() {
		return contractNo;
	}

	/**
	 * @param contractNo the contractNo to set
	 */
	public void setContractNo(long contractNo) {
		this.contractNo = contractNo;
	}

	/**
	 * @return the contractName
	 */
	public String getContractName() {
		return contractName;
	}

	/**
	 * @param contractName the contractName to set
	 */
	public void setContractName(String contractName) {
		this.contractName = contractName;
	}

	/**
	 * @return the idNums
	 */
	public long getIdNums() {
		return idNums;
	}

	/**
	 * @param idNums the idNums to set
	 */
	public void setIdNums(long idNums) {
		this.idNums = idNums;
	}

	/**
	 * @return the payCodeName
	 */
	public String getPayCodeName() {
		return payCodeName;
	}

	/**
	 * @param payCodeName the payCodeName to set
	 */
	public void setPayCodeName(String payCodeName) {
		this.payCodeName = payCodeName;
	}

	/**
	 * @return the feeData
	 */
	public OutFeeData getFeeData() {
		return feeData;
	}

	/**
	 * @param feeData the feeData to set
	 */
	public void setFeeData(OutFeeData feeData) {
		this.feeData = feeData;
	}

	/**
	 * @return the oweFeeList
	 */
	public List<OweFeeEntity> getOweFeeList() {
		return oweFeeList;
	}

	/**
	 * @param oweFeeList the oweFeeList to set
	 */
	public void setOweFeeList(List<OweFeeEntity> oweFeeList) {
		this.oweFeeList = oweFeeList;
	}

	/**
	 * @return the brandId
	 */
	public String getBrandId() {
		return brandId;
	}

	/**
	 * @param brandId the brandId to set
	 */
	public void setBrandId(String brandId) {
		this.brandId = brandId;
	}

}