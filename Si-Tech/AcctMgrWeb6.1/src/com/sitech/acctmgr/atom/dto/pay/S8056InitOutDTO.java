package com.sitech.acctmgr.atom.dto.pay;

import com.sitech.acctmgr.atom.domains.pay.PayBackOutEntity;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * <p>Title: 缴费冲正查询出参DTO  </p>
 * <p>Description:   </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author qiaolin
 * @version 1.0
 */
public class S8056InitOutDTO extends CommonOutDTO{

	private static final long serialVersionUID = -1918207756565055736L;

	@ParamDesc(path="CUST_NAME",cons=ConsType.CT001,type="String",len="100",desc="客户名称",memo="略")
	protected	String  custName;
	
	@ParamDesc(path="ALL_PAY",cons=ConsType.CT001,type="long",len="14",desc="冲正退费总金额",memo="略")
	protected	long	allPay;
	
	@ParamDesc(path="ID_NUMBER",cons=ConsType.CT001,type="long",len="10",desc="缴费记录数",memo="略")
	protected	long	idNumbers;
	
	@ParamDesc(path="OP_TIME",cons=ConsType.CT001,type="String",len="30",desc="缴费操作时间",memo="略")
	protected	String	payOptime;
	
	@ParamDesc(path="LOGIN_NO",cons=ConsType.CT001,type="String",len="20",desc="缴费工号",memo="略")
	protected	String	payLogin;
	
	@ParamDesc(path="PAY_SN",cons=ConsType.CT001,type="long",len="14",desc="缴费流水",memo="略")
	protected	long	paySn;
	
	@ParamDesc(path="OP_CODE",cons=ConsType.CT001,type="String",len="4",desc="缴费操作代码",memo="略")
	protected	String	payOpcode;
	
	@ParamDesc(path="CONTRACT_NO",cons=ConsType.CT001,type="long",len="18",desc="账户ID",memo="略")
	protected	long	contractNo;
	
	@ParamDesc(path="PHONE_NO",cons=ConsType.CT001,type="String",len="40",desc="缴费号码",memo="略")
	private String phoneNo;
	
	@ParamDesc(path="OUT_FEEMSG",cons=ConsType.PLUS,type="compx",len="1",desc="入账和支出信息",memo="略")
	protected	List<PayBackOutEntity> outFeemsg = new ArrayList<PayBackOutEntity>();

	@ParamDesc(path="BRAND_ID",cons=ConsType.CT001,type="String",len="40",desc="用户品牌",memo="略")
	private String brandId;


	public MBean encode() {
		
		MBean result = super.encode();

		result.addBody("CUST_NAME", custName);
		result.addBody("ALL_PAY", allPay);
		result.addBody("ID_NUMBER", idNumbers);
		result.addBody("OP_TIME", payOptime);
		result.addBody("LOGIN_NO", payLogin);
		result.addBody("PAY_SN", paySn);
		result.addBody("OP_CODE", payOpcode);
		result.addBody("CONTRACT_NO", contractNo);
		result.addBody("PHONE_NO", phoneNo);;
		result.addBody("OUT_FEEMSG", outFeemsg);
		result.addBody("BRAND_ID", brandId);
		
		return result;
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
	 * @return the custName
	 */
	public String getCustName() {
		return custName;
	}

	/**
	 * @param custName the custName to set
	 */
	public void setCustName(String custName) {
		this.custName = custName;
	}

	/**
	 * @return the allPay
	 */
	public long getAllPay() {
		return allPay;
	}

	/**
	 * @param allPay the allPay to set
	 */
	public void setAllPay(long allPay) {
		this.allPay = allPay;
	}

	/**
	 * @return the idNumbers
	 */
	public long getIdNumbers() {
		return idNumbers;
	}

	/**
	 * @param idNumbers the idNumbers to set
	 */
	public void setIdNumbers(long idNumbers) {
		this.idNumbers = idNumbers;
	}

	/**
	 * @return the payOptime
	 */
	public String getPayOptime() {
		return payOptime;
	}

	/**
	 * @param payOptime the payOptime to set
	 */
	public void setPayOptime(String payOptime) {
		this.payOptime = payOptime;
	}

	/**
	 * @return the payLogin
	 */
	public String getPayLogin() {
		return payLogin;
	}

	/**
	 * @param payLogin the payLogin to set
	 */
	public void setPayLogin(String payLogin) {
		this.payLogin = payLogin;
	}

	/**
	 * @return the paySn
	 */
	public long getPaySn() {
		return paySn;
	}

	/**
	 * @param paySn the paySn to set
	 */
	public void setPaySn(long paySn) {
		this.paySn = paySn;
	}

	/**
	 * @return the payOpcode
	 */
	public String getPayOpcode() {
		return payOpcode;
	}

	/**
	 * @param payOpcode the payOpcode to set
	 */
	public void setPayOpcode(String payOpcode) {
		this.payOpcode = payOpcode;
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
	 * @return the outFeemsg
	 */
	public List<PayBackOutEntity> getOutFeemsg() {
		return outFeemsg;
	}

	/**
	 * @param outFeemsg the outFeemsg to set
	 */
	public void setOutFeemsg(List<PayBackOutEntity> outFeemsg) {
		this.outFeemsg = outFeemsg;
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