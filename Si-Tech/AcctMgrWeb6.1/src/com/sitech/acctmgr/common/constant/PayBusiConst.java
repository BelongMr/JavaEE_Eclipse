package com.sitech.acctmgr.common.constant;


/**
 *
 * <p>Title: 缴费业务公共变量  </p>
 * <p>Description: 缴费业务公共变量   </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author zhangjp
 * @version 1.0
 */
public class PayBusiConst {
	
	/**结束时间*/
	public static final String END_TIME = "20500101 00:00:00";
	public static final String END_TIME2 = "20500101000000";
	public static final String YYYYMMDDHHMMSS = "yyyyMMdd HH:mm:ss";
	public static final String YYYYMMDDHHMMSS2 = "yyyyMMddHHmmss";
	
	/**
	 * 单账户（没有默认用户）缴费入表记录号码
	 * */
	public static final String DEFAULT_PHONE = "99999999999";
	
	/**
	 *缴费渠道 PAY_PATH
	 */
	public static final String PAY_PATH_DEFAULT = "11";
	public static final String OWNPATH = "11";      //营业前台
	public static final String CARDPATH = "28";     //三卡
	public static final String SELFHELPPATH = "05"; //自助终端
	public static final String IVRPATH = "06";		//IVR
	public static final String BAKN_PATH = "19";	//银行
	public static final String LDYS_PATH = "91";	//联动优势
	public static final String WWWPATH = "02";		//网站
	public static final String ZNZDPATH = "21";      //智能终端CRM
	
	
	/**
	 * 帐户关系类型	9：定额；0：全额
	 */
	public static final String ACCT_REL_TYPE_FIX = "9";
	public static final String ACCT_REL_TYPE_ALL = "0";

	/**
	 * 一点支付账户属性类型A
	 * */
	public static final String YDZF_CONTRACTTYPE_STRING = "A";
	
	/**
	 * 一点支付账户属性类型,数组形式:A
	 * */
	public static final String[] YDZF_CONTRACTTYPE = new String[]{"A"};
	
	/**
	 * 一点支付账户属性类型和集团账户: A,1
	 * */
	public static final String[] YDZFORJTZH_CONTRACTTYPE = new String[]{"A","1"};
	
	/**
	 * 品牌
	 * 2230yk 	4G宽带数据卡
	 * 2230cb 	长白行
	 * 2230z0     神州行 
	 */
	public static final String BRAND_ID_YK = "2230yk";
	public static final String BRAND_ID_CB = "2230cb";
	public static final String BRAND_ID_Z0 = "2230z0";
	public static final String BRAND_ID_SZX = "2330zn";

	/**
	 * 缴费方式
	 * 0 现金 ,9 支票
	 */
	public static final String PAY_METHOD_DEFAULT = "0";
	public static final String PAY_METHOD_POS = "W";
	public static final String PAY_METHOD_CHECK = "9";

	
	/***
	 * 缴费账本
	 * 0 现金         支票 - 9
	 */
	public static final String PAY_TYPE_CHECK = "9";
	public static final String POS_TYPE = "W";
	
	/**
	 * 账户属性类型
	 * 空中充值代理商账户
	 * */
	public static final String AIR_RECHARGE_CONTYPE = "a";
	
	/***
	 * 退费类型
	 */
	public static final String ADJ_TYPE_SINGLE_PRE = "00";  //单倍退预存
	public static final String ADJ_TYPE_DOUBLE_PRE = "01";  //双倍退预存
	public static final String ADJ_TYPE_DOUBLE_PRE_CASH = "02";  //双倍退预存退现金
	
	/**
	 * 第三方缴费签约关系业务类型：1001:手机支付自动缴话费签约关系.  1002:银行卡自动缴话费签约关系(联动优势).1003:支付宝签约关系
	 */
	public static final String SIGN_BUSI_TYPE_SJZF = "1001";
	/**
	 * 第三方缴费签约关系业务类型：1001:手机支付自动缴话费签约关系.  1002:银行卡自动缴话费签约关系(联动优势).1003:支付宝签约关系
	 */
	public static final String SIGN_BUSI_TYPE_YHK = "1002";
	/**
	 * 第三方缴费签约关系业务类型：1001:手机支付自动缴话费签约关系.  1002:银行卡自动缴话费签约关系(联动优势).1003:支付宝签约关系
	 */
	public static final String SIGN_BUSI_TYPE_ZFB = "1003";
	
	/**
	 * 资金冲正可以冲正的OP_CODE:{"8000", "8002", "8030"}  OP_TYPE：JFCZ缴费冲正JFCZ
	 * */
	public static final String[] JFCZ_OPCODES = new String[]{"8000", "8002", "8030", "8074", "8068"};
	/**
	 * 资金冲正可以冲正的OP_CODE:{"8016"}  OP_TYPE：KZCZCZ空中充值冲正 
	 * */
	public static final String[] KZCZCZ_OPCODES = new String[]{"8016"};
	
	/**
	 * 资金冲正可以冲正的OP_CODE:{"8055"}  OP_TYPE：TFCZ退费冲正
	 * */
	public static final String[] TFCZ_OPCODES = new String[]{"8055"};
	
	/**
	 * 资金冲正可以冲正的OP_CODE:{"8014"}  OP_TYPE：JTCPZZCZ集团产品转账冲正
	 * */
	public static final String[] JTCPZZCZ_OPCODES = new String[]{"8014"};
	
	/**
	 * 一点支付冲正的可以冲正的OP_CODE:{"8020"}  OP_TYPE：YDZFCZ 一点支付冲正
	 * */
	public static final String[] YDZFCZ_OPCODES = new String[]{"8020"};
	
	/**
	 * 属于神州行的资费，用于判断神州行用户
	 */
	public static final String[] SZX_PRCID = new String[]{"M015290", "M017916", "M019557", "M019683", "M022467", "M022606", "M023186", "M026240", "M026857", "M027936", "M029035", "M021513", "M015046"};
	
	/**
	 * 家庭宽带成员
	 * 21097：JTFX-和家飞享宽带成员
	 * 21101：JTHX-和家惠享 宽带成员
	 * 21106：JTDX-家庭保底消费 宽带成员
	 * 21109：JTRH-和家庭悦享套餐 宽带成员
	 * 21112：JTHA-家庭A计划 宽带成员
	 * 21116：JTHB-家庭B计划 宽带成员
	 */
	public static final Long[] JTKDCY_MEMRD = new Long[]{21097L,21101L,21106L,21109L,21112L,21116L};
}