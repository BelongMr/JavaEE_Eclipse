package com.sitech.acctmgr.inter.pay;

import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
*
* <p>Title:  普通转账接口 </p>
* <p>Description:  普通转账接口 </p>
* <p>Copyright: Copyright (c) 2014</p>
* <p>Company: SI-TECH </p>
* @author 
* @version 1.0
*/
public interface I8014 {
	
	
	/**
	 * 名称：集团产品转账信息查询
	 * @param inParam BUSI_INFO.CUST_ID	集团客户编码
	 * @param inParam BUSI_INFO.ID_ICCID 证件号码
	 * @param inParam BUSI_INFO.UNIT_ID	集团编码
	 * @return 	OUT_DATA.UNIT_ID 集团编码	
	 * 			OUT_DATA.GROUP_NAME 集团名称
	 * 			OUT_DATA.CUST_ID 集团客户编码
	 * 			OUT_DATA.ICC_ID 证件号码
	 * 			OUT_DATA.GROUP_CONTRACT_LIST 集团产品信息列表
	 */
	OutDTO initGrp(InDTO inParam);
	
	/**
	* 名称： 转账查询：查找转出账户可转金额和账本明细
	* @param OPR_INFO.LOGIN_NO 工号
	* @param OPR_INFO.OP_CODE	 操作代码
	* 
	* @param BUSI_INFO.CONTRACT_NO
	* @param BUSI_INFO.PHONE_NO
	* @param BUSI_INFO.CONTRACT_PASS 账户密码
	* @param BUSI_INFO.IF_ONNET 用户标识 --> 1:在网 ; 2:离网
	* @param BUSI_INFO.OP_TYPE 转账类型--> ZHZZ: 账户转账；JTZZ:家庭转账；FFGXJCZZ: 付费关系解除转账；XFEJSMZZ: 幸福E家成员短信转帐；XFJTHKZZ:幸福家庭回馈转赠；YKHJHZZ: 预开户激活转账
	* @return
	* @return OUT_DATA.CHANGE_FEE  可转金额
	* @return OUT_DATA.OWE_FEE  欠费
	* @return OUT_DATA.CUST_NAME 客户名称 
	* @return OUT_DATA.OWEFEE_LIST 账单明细
	* 				OWEFEE_LIST.PAY_TYPE_NAME<br> 账本名称
	* 				OWEFEE_LIST.BACK_FLAG<br> 可退标识
	* 				OWEFEE_LIST.CHANGE_FLAG<br> 可转标识
	* 				OWEFEE_LIST.PRIORITY<br> 优先级
	* 				OWEFEE_LIST.CUR_BALANCE<br> 余额
	* @throws Exception
	* @author guowy
	*/
	OutDTO init(final InDTO inParam);
	
	/**
	* 名称： 转账确认
	* @param OPR_INFO. 
	* @param OPR_INFO.	
	* 
	* @param BUSI_INFO
	* 
	* @return
	* @return OUT_DATA
	*
	* @throws Exception
	* @author guowy
	*/
	OutDTO cfm(InDTO inParam);
	
	/**
	 * 名称：集团红包转账
	 */
	OutDTO grpcfm(InDTO inParam);

}
