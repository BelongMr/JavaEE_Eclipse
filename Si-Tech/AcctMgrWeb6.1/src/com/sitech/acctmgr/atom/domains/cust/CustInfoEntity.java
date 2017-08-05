package com.sitech.acctmgr.atom.domains.cust;

import com.alibaba.fastjson.annotation.JSONField;

public class CustInfoEntity {

	/**
     */
	@JSONField(name = "CUST_ID")
	private Long custId;

	/**
     */
	@JSONField(name = "CUST_NAME")
	private String custName;

	/**
     */
	@JSONField(name = "BLUR_CUSTNAME")
	private String blurCustName;

	/**
     */
	@JSONField(name = "CUST_LAST_NAME")
	private String custLastName;

	/**
     */
	@JSONField(name = "CUST_LEVEL")
	private String custLevel;

	/**
     */
	@JSONField(name = "CUST_LEVEL_NAME")
	private String custLevelName;

	/**
     */
	@JSONField(name = "ADDRESS_ID")
	private Integer addressId;

	/**
     */
	@JSONField(name = "ADMIN_LEVEL")
	private Integer adminLevel;

	/**
     */
	@JSONField(name = "CARD_TYPE")
	private Integer cardType;

	/**
     */
	@JSONField(name = "CUST_ADDRESS")
	private String custAddress;

	/**
     */
	@JSONField(name = "CUST_CD")
	private String custCd;

	/**
     */
	@JSONField(name = "CUST_POST")
	private String custPost;

	/**
     */
	@JSONField(name = "DEFAULT_LANG")
	private String defaultLang;

	/**
     */
	@JSONField(name = "GROUP_ID")
	private String groupId;

	/**
     */
	@JSONField(name = "ID_ADDRESS")
	private String idAddress;

	/**
     */
	@JSONField(name = "ID_ICCID")
	private String idIccid;

	/**
     */
	@JSONField(name = "ID_TYPE")
	private String idType;

	/**
     */
	@JSONField(name = "ID_TYPE_NAME")
	private String idTypeName;

	/**
     */
	@JSONField(name = "ID_VALIDDATE")
	private String idValiddate;

	/**
     */
	@JSONField(name = "SIGN_FLAG")
	private String signFlag;

	/**
     */
	@JSONField(name = "TRUE_FLAG")
	private String trueFlag;

	/**
     */
	@JSONField(name = "TYPE_CODE")
	private Integer typeCode;

	/**
     */
	@JSONField(name = "CUST_TYPE_NAME")
	private String custTypeName;

	/**
     */
	@JSONField(name = "VIP_CARD_NO")
	private String vipCardNo;

	/**
     */
	@JSONField(name = "VIP_CREATE_TYPE")
	private Integer vipCreateType;

	/**
     */
	@JSONField(name = "VIP_FLAG")
	private String vipFlag;

	/*紧急联系人*/
	@JSONField(name = "EM_TEL")
	private String emTel;

	public Long getCustId() {
		return this.custId;
	}

	public void setCustId(Long custId) {
		this.custId = custId;
	}

	public String getCustName() {
		return this.custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getCustLevel() {
		return this.custLevel;
	}

	public void setCustLevel(String custLevel) {
		this.custLevel = custLevel;
	}

	public Integer getAddressId() {
		return this.addressId;
	}

	public void setAddressId(Integer addressId) {
		this.addressId = addressId;
	}

	public Integer getAdminLevel() {
		return this.adminLevel;
	}

	public void setAdminLevel(Integer adminLevel) {
		this.adminLevel = adminLevel;
	}

	public Integer getCardType() {
		return this.cardType;
	}

	public void setCardType(Integer cardType) {
		this.cardType = cardType;
	}

	public String getCustAddress() {
		return this.custAddress;
	}

	public void setCustAddress(String custAddress) {
		this.custAddress = custAddress;
	}

	public String getCustCd() {
		return this.custCd;
	}

	public void setCustCd(String custCd) {
		this.custCd = custCd;
	}

	public String getCustPost() {
		return this.custPost;
	}

	public void setCustPost(String custPost) {
		this.custPost = custPost;
	}

	public String getDefaultLang() {
		return this.defaultLang;
	}

	public void setDefaultLang(String defaultLang) {
		this.defaultLang = defaultLang;
	}

	public String getGroupId() {
		return this.groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	public String getIdAddress() {
		return this.idAddress;
	}

	public void setIdAddress(String idAddress) {
		this.idAddress = idAddress;
	}

	public String getIdIccid() {
		return this.idIccid;
	}

	public void setIdIccid(String idIccid) {
		this.idIccid = idIccid;
	}

	public String getIdType() {
		return this.idType;
	}

	public void setIdType(String idType) {
		this.idType = idType;
	}

	public String getSignFlag() {
		return this.signFlag;
	}

	public void setSignFlag(String signFlag) {
		this.signFlag = signFlag;
	}

	public String getTrueFlag() {
		return this.trueFlag;
	}

	public void setTrueFlag(String trueFlag) {
		this.trueFlag = trueFlag;
	}

	public Integer getTypeCode() {
		return this.typeCode;
	}

	public void setTypeCode(Integer typeCode) {
		this.typeCode = typeCode;
	}

	public String getVipCardNo() {
		return this.vipCardNo;
	}

	public void setVipCardNo(String vipCardNo) {
		this.vipCardNo = vipCardNo;
	}

	public Integer getVipCreateType() {
		return this.vipCreateType;
	}

	public void setVipCreateType(Integer vipCreateType) {
		this.vipCreateType = vipCreateType;
	}

	public String getVipFlag() {
		return this.vipFlag;
	}

	public void setVipFlag(String vipFlag) {
		this.vipFlag = vipFlag;
	}

	/**
	 * @return the custLastName
	 */
	public String getCustLastName() {
		return custLastName;
	}

	/**
	 * @param custLastName
	 *            the custLastName to set
	 */
	public void setCustLastName(String custLastName) {
		this.custLastName = custLastName;
	}

	/**
	 * @return the custLevelName
	 */
	public String getCustLevelName() {
		return custLevelName;
	}

	/**
	 * @param custLevelName
	 *            the custLevelName to set
	 */
	public void setCustLevelName(String custLevelName) {
		this.custLevelName = custLevelName;
	}

	/**
	 * @return the idTypeName
	 */
	public String getIdTypeName() {
		return idTypeName;
	}

	/**
	 * @param idTypeName
	 *            the idTypeName to set
	 */
	public void setIdTypeName(String idTypeName) {
		this.idTypeName = idTypeName;
	}

	/**
	 * @return the blurCustName
	 */
	public String getBlurCustName() {
		return blurCustName;
	}

	/**
	 * @param blurCustName
	 *            the blurCustName to set
	 */
	public void setBlurCustName(String blurCustName) {
		this.blurCustName = blurCustName;
	}

	/**
	 * @return the custTypeName
	 */
	public String getCustTypeName() {
		return custTypeName;
	}

	/**
	 * @param custTypeName
	 *            the custTypeName to set
	 */
	public void setCustTypeName(String custTypeName) {
		this.custTypeName = custTypeName;
	}

	public String getEmTel() {
		return emTel;
	}

	public void setEmTel(String emTel) {
		this.emTel = emTel;
	}

	@Override
	public String toString() {
		return "CustInfoEntity [custId=" + custId + ", custName=" + custName + ", blurCustName=" + blurCustName + ", custLastName=" + custLastName
				+ ", custLevel=" + custLevel + ", custLevelName=" + custLevelName + ", addressId=" + addressId + ", adminLevel=" + adminLevel
				+ ", cardType=" + cardType + ", custAddress=" + custAddress + ", custCd=" + custCd + ", custPost=" + custPost + ", defaultLang="
				+ defaultLang + ", groupId=" + groupId + ", idAddress=" + idAddress + ", idIccid=" + idIccid + ", idType=" + idType + ", idTypeName="
				+ idTypeName + ", idValiddate=" + idValiddate + ", signFlag=" + signFlag + ", trueFlag=" + trueFlag + ", typeCode=" + typeCode
				+ ", custTypeName=" + custTypeName + ", vipCardNo=" + vipCardNo + ", vipCreateType=" + vipCreateType + ", vipFlag=" + vipFlag + "]";
	}

	/**
	 * @return the idValiddate
	 */
	public String getIdValiddate() {
		return idValiddate;
	}

	/**
	 * @param idValiddate the idValiddate to set
	 */
	public void setIdValiddate(String idValiddate) {
		this.idValiddate = idValiddate;
	}

}