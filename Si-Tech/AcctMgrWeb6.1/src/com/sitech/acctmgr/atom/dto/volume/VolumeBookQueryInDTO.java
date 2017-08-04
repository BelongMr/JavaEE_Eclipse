package com.sitech.acctmgr.atom.dto.volume;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;
@SuppressWarnings("serial")
public class VolumeBookQueryInDTO extends CommonInDTO {
	@ParamDesc(path = "BUSI_INFO.SERVICE_MSG_TYPE", cons = ConsType.CT001, desc = "业务操作类型", len = "2", memo = "消息类型。具体值参见消息类型定义表。01充入")
	private String serviceMsgType;
	@ParamDesc(path = "BUSI_INFO.CHANGE_REASON", cons = ConsType.CT001, desc = "变动原因", len = "2", memo = "消息类型。具体值参见消息类型定义表。后台程序不做判断,仅用于查询；01 充值 04 转售 07 兑换 08 交易 09 红包")
	private String changeReason;
	@ParamDesc(path = "BUSI_INFO.TRADE_SEQ", cons = ConsType.CT001, desc = "交易流水", len = "40", memo = "流水id")
	private String reqSeq;
	@ParamDesc(path = "BUSI_INFO.MSISDN", cons = ConsType.CT001, desc = "用户号码", len = "15", memo = "")
	private String msisdn;
	@ParamDesc(path = "BUSI_INFO.USER_ID", cons = ConsType.CT001, desc = "用户标识", len = "18", memo = "")
	private String userId;
	@ParamDesc(path = "BUSI_INFO.REGION_ID", cons = ConsType.CT001, desc = "地市编码", len = "2", memo = "可填写默认值“00” 安徽移动填值，如滁州地市填写为22 ")
	private String regionId = "00";
	@ParamDesc(path = "BUSI_INFO.PART_ID", cons = ConsType.CT001, desc = "分区编码", len = "2", memo = "可填写默认值“00”")
	private String partId = "00";
	@ParamDesc(path = "BUSI_INFO.OPER_SOURCE", cons = ConsType.CT001, desc = "来源区分：商户类型 ", len = "5", memo = "")
	private String operSource;
	@ParamDesc(path = "BUSI_INFO.OPER_CHANNEL", cons = ConsType.CT001, desc = "来源区分：渠道类型 ", len = "5", memo = "")
	private String operChannel;
	@ParamDesc(path = "BUSI_INFO.OPER_ID", cons = ConsType.CT001, desc = "来源区分：营业员编号", len = "18", memo = "")
	private String operId;

	@ParamDesc(path = "BUSI_INFO.ACCT_TYPE", cons = ConsType.CT001, type = "string", len = "2", desc = "账户类型", memo = "Balance_id为空时，与acct_id 不能同时为空；")
	private String acctType;
	@ParamDesc(path = "BUSI_INFO.BALANCE_TYPE", cons = ConsType.CT001, desc = "流量帐本类型", len = "10", memo = "Balance_id为空时该字段不可为空，参看账本类型表。")
	private String balanceType;
	@ParamDesc(path = "BUSI_INFO.BALANCE_ATTR", cons = ConsType.CT001, desc = "流量帐本交易属性", len = "10", memo = "Balance_id为空时该字段不可为空，参看账本属性表，编码各省自己定义")
	private String balanceAttr;
	@ParamDesc(path = "BUSI_INFO.BALANCE_STATE", cons = ConsType.CT001, desc = "账本状态", len = "1", memo = "为空时，查询所有 0 正常 1 冻结 2 订购取消  a 所有 b 正常+冻结 c正常+订购取消 d 冻结+订购取消")
	private String balanceState;
	@ParamDesc(path = "BUSI_INFO.QUERY_TIME", cons = ConsType.CT001, type = "string", len = "6", desc = "查询时间", memo = "用于查询账本的账期时间")
	private String queryTime;
	@ParamDesc(path = "BUSI_INFO.TIME_TYPE", cons = ConsType.CT001, type = "string", len = "6", desc = "查询时间类型", memo = "0：按时间点查询；1：按照帐期查询")
	private String timeType;
	@ParamDesc(path = "BUSI_INFO.QUERY_TYPE", cons = ConsType.CT001, type = "string", len = "1", desc = "查询类型", memo = "0：查询合并1：查询明细")
	private String queryType;
	@ParamDesc(path = "BUSI_INFO.PRODUCT_ID", cons = ConsType.CT001, desc = "产品id", len = "18", memo = "可空，查询产品id")
	private String productId;
	@ParamDesc(path = "BUSI_INFO.QUERY_SHARE", cons = ConsType.CT001, desc = "查询共享账本标识", len = "1", memo = "0:查询所有账本 1:查询共享账本")
	private String queryShare;

	@Override
	public void decode(MBean arg0) {
		/*请求头信息*/
		setServiceMsgType(arg0.getStr(getPathByProperName("serviceMsgType")));
		setChangeReason(arg0.getStr(getPathByProperName("changeReason")));
		setReqSeq(arg0.getStr(getPathByProperName("reqSeq")));
		setMsisdn(arg0.getStr(getPathByProperName("msisdn")));
		setUserId(arg0.getStr(getPathByProperName("userId")));
		setRegionId(arg0.getStr(getPathByProperName("regionId")));
		setPartId(arg0.getStr(getPathByProperName("partId")));
		setOperSource(arg0.getStr(getPathByProperName("operSource")));
		setOperChannel(arg0.getStr(getPathByProperName("operChannel")));
		setOperId(arg0.getStr(getPathByProperName("operId")));

		/*请求业务信息*/
		setAcctType(arg0.getStr(getPathByProperName("acctType")));
		setBalanceType(arg0.getStr(getPathByProperName("balanceType")));
		setBalanceAttr(arg0.getStr(getPathByProperName("balanceAttr")));
		setBalanceState(arg0.getStr(getPathByProperName("balanceState")));
		setProductId(arg0.getStr(getPathByProperName("productId")));
		setQueryTime(arg0.getStr(getPathByProperName("queryTime")));
		setTimeType(arg0.getStr(getPathByProperName("timeType")));
		setQueryType(arg0.getStr(getPathByProperName("queryType")));
		setProductId(arg0.getStr(getPathByProperName("productId")));
		setQueryShare(arg0.getStr(getPathByProperName("queryShare")));
	}

	public String getServiceMsgType() {
		return serviceMsgType;
	}

	public void setServiceMsgType(String serviceMsgType) {
		this.serviceMsgType = serviceMsgType;
	}

	public String getChangeReason() {
		return changeReason;
	}

	public void setChangeReason(String changeReason) {
		this.changeReason = changeReason;
	}

	public String getReqSeq() {
		return reqSeq;
	}

	public void setReqSeq(String reqSeq) {
		this.reqSeq = reqSeq;
	}

	public String getMsisdn() {
		return msisdn;
	}

	public void setMsisdn(String msisdn) {
		this.msisdn = msisdn;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRegionId() {
		return regionId;
	}

	public void setRegionId(String regionId) {
		this.regionId = regionId;
	}

	public String getPartId() {
		return partId;
	}

	public void setPartId(String partId) {
		this.partId = partId;
	}

	public String getOperSource() {
		return operSource;
	}

	public void setOperSource(String operSource) {
		this.operSource = operSource;
	}

	public String getOperChannel() {
		return operChannel;
	}

	public void setOperChannel(String operChannel) {
		this.operChannel = operChannel;
	}

	public String getOperId() {
		return operId;
	}

	public void setOperId(String operId) {
		this.operId = operId;
	}

	public String getAcctType() {
		return acctType;
	}

	public void setAcctType(String acctType) {
		this.acctType = acctType;
	}

	public String getBalanceType() {
		return balanceType;
	}

	public void setBalanceType(String balanceType) {
		this.balanceType = balanceType;
	}

	public String getBalanceAttr() {
		return balanceAttr;
	}

	public void setBalanceAttr(String balanceAttr) {
		this.balanceAttr = balanceAttr;
	}

	public String getBalanceState() {
		return balanceState;
	}

	public void setBalanceState(String balanceState) {
		this.balanceState = balanceState;
	}

	public String getQueryTime() {
		return queryTime;
	}

	public void setQueryTime(String queryTime) {
		this.queryTime = queryTime;
	}

	public String getTimeType() {
		return timeType;
	}

	public void setTimeType(String timeType) {
		this.timeType = timeType;
	}

	public String getQueryType() {
		return queryType;
	}

	public void setQueryType(String queryType) {
		this.queryType = queryType;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getQueryShare() {
		return queryShare;
	}

	public void setQueryShare(String queryShare) {
		this.queryShare = queryShare;
	}
	
}
