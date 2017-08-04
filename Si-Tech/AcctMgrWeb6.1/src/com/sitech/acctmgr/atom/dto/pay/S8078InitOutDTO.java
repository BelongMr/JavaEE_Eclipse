package com.sitech.acctmgr.atom.dto.pay;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.acctmgr.atom.domains.pay.GroupRelConInfo;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

public class S8078InitOutDTO extends CommonOutDTO {
	
	@JSONField(name="ACCOUNT_TYPE")
	@ParamDesc(path="ACCOUNT_TYPE",cons=ConsType.CT001,type="String",len="20",desc="账户类型",memo="略")
	private String accountType;
	
	@JSONField(name="CUST_ID")
	@ParamDesc(path="CUST_ID",cons=ConsType.CT001,type="long",len="11",desc="账户客户编号",memo="略")
	private long custId;
	
	@JSONField(name="GROUP_NAME")
	@ParamDesc(path="GROUP_NAME",cons=ConsType.CT001,type="String",len="50",desc="集团名称",memo="略")
	private String groupName;
	
	@JSONField(name="PHONE_NO")
	@ParamDesc(path="PHONE_NO",cons=ConsType.CT001,type="String",len="12",desc="集团号码",memo="略")
	private String phoneNo;
	
	@JSONField(name="CUR_BALANCE")
	@ParamDesc(path="CUR_BALANCE",cons=ConsType.CT001,type="long",len="11",desc="账户预存",memo="略")
	private long curBalance;
	
	@JSONField(name="REL_CON_LIST")
	@ParamDesc(path="REL_CON_LIST",cons=ConsType.CT001,type="compx",len="1",desc="手工划拨账户信息",memo="略")
	private List<GroupRelConInfo> relConList;
	
	@Override
    public MBean encode() {
        MBean result = new MBean();
        result.setRoot(getPathByProperName("accountType"), accountType);
        result.setRoot(getPathByProperName("groupName"), groupName);
        result.setRoot(getPathByProperName("phoneNo"), phoneNo);
        result.setRoot(getPathByProperName("custId"), custId);
        result.setRoot(getPathByProperName("curBalance"), curBalance);
        result.setBody(getPathByProperName("relConList"), relConList);
        return result;
    }

	/**
	 * @return the accountType
	 */
	public String getAccountType() {
		return accountType;
	}

	/**
	 * @param accountType the accountType to set
	 */
	public void setAccountType(String accountType) {
		this.accountType = accountType;
	}

	/**
	 * @return the custId
	 */
	public long getCustId() {
		return custId;
	}

	/**
	 * @param custId the custId to set
	 */
	public void setCustId(long custId) {
		this.custId = custId;
	}

	/**
	 * @return the groupName
	 */
	public String getGroupName() {
		return groupName;
	}

	/**
	 * @param groupName the groupName to set
	 */
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	/**
	 * @return the curBalance
	 */
	public long getCurBalance() {
		return curBalance;
	}

	/**
	 * @param curBalance the curBalance to set
	 */
	public void setCurBalance(long curBalance) {
		this.curBalance = curBalance;
	}

	/**
	 * @return the relConList
	 */
	public List<GroupRelConInfo> getRelConList() {
		return relConList;
	}

	/**
	 * @param relConList the relConList to set
	 */
	public void setRelConList(List<GroupRelConInfo> relConList) {
		this.relConList = relConList;
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
	
	
	
}
