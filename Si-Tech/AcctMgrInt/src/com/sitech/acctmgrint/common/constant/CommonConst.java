package com.sitech.acctmgrint.common.constant;

/**
 * <p>
 * Title: 公共业务常量
 * </p>
 * <p>
 * Description: 业务常量
 * </p>
 * <p>
 * Copyright: Copyright (c) 2014
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 *
 * @author yankma
 * @version 1.0
 */
public final class CommonConst {

	public static final String EXFFP_TYPE = "EMM3001";
	public static final String EYCFP_TYPE = "EPM3001";

	public static final long INVO_FEE_LIMIT = 100000000;

	/* 出账批次 */
	public static final String BATCHWRTOFF_BILL_DAY = "3600";

	/* 默认账户BILL_ORDER */
	public static final int DEF_BILL_ORDER = 99999999;

	/* 在网常量标识 */
	public static final int IN_NET = 0;

	/* 离网常量标识 */
	public static final int NO_NET = 1;

	/* 查询在线余额标识 */
	public static final int ONLINE_REMAIN = 0;

	/* 查询离线余额标识 */
	public static final int OFFLINE_REMAIN = 1;

	/* 在线离线查询余额开关CTRL_NO配置 */
	public static final String REAL_CTRL_NO = "13100";

	// add by liuhl_bj begin
	public static final String USERTYPE_WLW = "1";// 物联网号码
	public static final String USERTYPE_BROADBAND = "2";// 宽带号码
	public static final String USERTYPE_GRP = "3";// 集团号码
	// 发票打印状态常量
	public static final String NORMAL_STATUS = "1";// 正常发票
	public static final String CANCEL_STATUS = "2";// 作废
	public static final String RECLE_STATUS = "3";// 回收
	public static final String ALL_RED_STATUS = "4";// 全部冲红
	public static final String PART_RED_STATUS = "5";// 部分冲红
	public static final String RED_STATUS = "6";// 打印红字发票
	public static final String WHAM_STATUS = "7";// 重打
	// add by liuhl_bj end
	/**
	 * 发票类型常量*
	 */
	public static final String YCFP_TYPE = "PM3001";
	public static final String XFFP_TYPE = "MM3001";
	public static final String JXFFP_TYPE = "MM3002";
	public static final String JYCFP_TYPE = "PM3002";
	public static final String ZZZP_TYPE = "MM5002";
	public static final String TSFP_TYPE = "MM4001";

	/**
	 * 预开发票类型选择
	 */
	public static final String YKFP_FLAG = "p";// 集团预开发票
	public static final String JTFPDY_FLAG = "n";// 集团打印发票状态
	public static final String YKFPHS_FLAG = "r";// 集团预开发票回收
	public static final String JTFPQX_FLAG = "c";// 集团发票取消

	/**
	 * 增值税发票的流转状态
	 */
	public static final String APPLY_STATE = "0";// 申请
	public static final String OPEN_STATE = "1";// 开具
	public static final String BACK_STATE = "2";// 打回
	public static final String AUDIT_STATE = "3";// 提交审核
	public static final String CANCLE_STATE = "4";// 作废
	public static final String PASS_STATE = "5";// 审核通过
	public static final String NO_PASS_STATE = "6";// 审核不通过
	public static final String TRANS_STATE = "8";// 传递
	public static final String FILE_STATE = "9";// 归档
	public static final String WRONG_STATE = "a";// 打回之后重置数据
	/* 综合费用信息查询，内存超时时间 */
	public static final int OVERTIME_IDNO = 1800;

	public static final String STATUS_ONLINE_PAYED = "2"; // 在网帐单已缴状态
	public static final String STATUS_ONLINE_UNPAY = "0"; // 在网帐单未缴状态

	public static final String STATUS_OFFLINE_BADUNPAY = "1";// 陈账未缴状态
	public static final String STATUS_OFFLINE_BADPAYED = "3";// 陈账已缴状态

	public static final String STATUS_OFFLINE_DEADUNPAY = "4";// 死账未缴状态
	public static final String STATUS_OFFLINE_DEADPAYED = "6";// 死账已缴状态

	/* 上网费用区分wlan流量费和手机上网费 */
	public static int ITEM_ATTR_GPRS_OFFSET = 3;

	public static final String YES = "Y";

	public static final String NO = "N";

	public static final String CREDIT_VALID = "1"; // 信誉生效用户
	public static final String CREDIT_INVALID = "0";// 信誉失效用户
	public static final String BOOK_TYPE_SPECIAL = "0"; // 余额类型为”专款“
	public static final String BOOK_TYPE_NORMAL = "1"; // 余额类型为“普通”
	public static final String BOOK_TYPE_CUSTPAY = "1"; // 客户付费类型
	public static final String BOOK_TYPE_MOBPAY = "'1','2'"; // 移动赠送类型
	public static final String CYCLEBEG_BOOKTYPE_CURVALID = "0";
	public static final String CYCLEBEG_BOOKTYPE_RETVALID = "1";
	public static final String UNBILLQRY_TYPE_SUMMARY = "01"; // 内存帐单汇总查询类型
	public static final String UNBILLQRY_TYPE_DETAIL = "02"; // 内存帐单明细查询类型
	public static final String UNBILLQRY_TYPE_DETAIL03 = "03"; // 内存帐单明细查询类型

	public static final int PAY_PARA_TYPE_ID = 251;
	public static final int CONTRACT_PARA_TYPE_ID = 3969;
	public static final int IDTYPE_PARA_TYPE_ID = 32;
	public static final int TYPE_CODE_PARA_TYPE_ID = 9;
	public static final int CUST_LEVEL_PARA_TYPE_ID = 1;

	/* 余额查询接口查询类型配置 */
	public static final String BALANCE_QUERY_TYPE_PHONE = "0";
	public static final String BALANCE_QUERY_TYPE_CON = "1";
	public static final String BALANCE_QUERY_TYPE_ID = "2";

	/**
	 * 账户支付类型
	 **/
	public static final String PAYCODE_COLLECTION = "3";

	public static final String FAM_PHONE = "99999999999";

	public static long TAXFEE_LIMIT = 10000000;

	public static final boolean INVER_SQUE = false; // 倒叙
	public static final boolean POSI_SEQUE = true; // 正序

	/* 包年帐户的判断依据 */
	public static final String PAYATTRTYPE_PACKYEAR = "p";

	public static final String FAMILY_CHAT_FLAG_YES = "1"; // 家庭畅聊
	public static final String FAMILY_CHAT_FLAG_NO = "0"; // 非家庭畅聊

	public static final String GROUP_TYPE_VPMN = "335"; // 群组代码，VPMN类型 //TODO
														// 需要纠正群组类型代码

	public static final String FAMILY_GROUP_TYPES = "QWJT,JTGX"; // 家庭群组类型

	public static final int DETAIL_QUERY_ADD_DAYS = 25; // 详单查询时延迟或提前天数

	public static final String BASE_PRC_FLAG = "0";// 基本产品资费标志

	public static final String ATTACH_PRC_FLAG = "1";// 附加产品资费标志

	/* 默认省份代码 HLJ */
	public static final String DEFAULT_PROVINCE_ID = "230000";

	/** 帐单展示帐目项级别定义 */
	public static final String BILLTTEM_DISP_LEVEL_1 = "1";
	public static final String BILLITEM_DISP_LEVEL_2 = "3";

	/** 帐单帐目项级联关系中级别定义 */
	public static final String PARENT_ITEMREL_LEVEL_1 = "0"; // 父节点等级为一级帐目项
	public static final String PARENT_ITEMREL_LEVEL_2 = "2"; // 父节点等级为二级帐目项

	public static final int DETAIL_MAX_QURRY_SUM = 2500; // 地市详单查询，工号单月最多查询次数
	public static final String NBR_TYPE_KD = "02";
	public static final String NBR_TYPE_WLW = "16";

	/** 总对总主号签约商品ID */
	public static final String ZDZ_PRC_ID = "M000911";

	/* 托收错单查询代码 */
	public static final String COLL_ERROR_YES = "YES";
}