package com.sitech.acctmgr.atom.entity.inter;

import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.balance.SignAutoPayEntity;
import com.sitech.acctmgr.atom.domains.base.LoginBaseEntity;
import com.sitech.acctmgr.atom.domains.pay.AutoPayFieldEntity;
import com.sitech.acctmgr.atom.domains.pay.UserSignInfoEntity;

/**
 *
 * <p>Title: 第三方缴费签约关系原子实体  </p>
 * <p>Description:   </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author qiaolin
 * @version 1.0
 */
public interface IUserSign {

	/**
	* 名称：判断是否签约某一种业务
	* @param busiType 业务类型：
    *                1001 --手机支付自动缴话费签约关系
    *				 1002 -- 银行卡自动缴话费签约关系（联动优势）
    *				 1003 -- 支付宝签约关系
	* @return 
	*/
	public boolean isSign(long idNo, String busiType);
	
	/**
	* 名称：判断用户是办理总对总主号签约、总队总副号签约
	* @param idNo
	* @return 0 没有办理      1 主号签约  2副号签约
	*/
	public int isZdzSign(long idNo);
	
	
	/**
	 * 名称：第三方缴费签约关系入库
	 * 
	 * @author qiaolin
	 */
	public abstract boolean saveSignInfo(UserSignInfoEntity userSign, LoginBaseEntity loginBase);
	
	
	/**
	 * 名称：第三方缴费签约关系解除
	 * @param Map updateInfo中存放 UPDATE_ACCEPT UPDATE_DATE UPDATE_LOGIN UPDATE_CODE
	 * @author qiaolin
	 */
	public abstract boolean deleteSignInfo(long idNo, String busiType, Map<String, Object> updateInfo);
	
	UserSignInfoEntity getUserSignInfo(long idNo);
	
	/**
	 * 名称：第三方缴费签约关系解除, boss自动充值数据作废
	 * @param Map inParam中存放 UPDATE_ACCEPT UPDATE_LOGIN UPDATE_FLAG
	 * @author qiaolin
	 */
	public abstract boolean deleteAutoPayInfo(long idNo,String busiType,Map<String,Object> inParam);
	
	
	/**
	 * 名称：查询支付商编号，协议号
	 */
	public String getSignAddInfo(long idNo, String busiType, String fieldCode);
	
	List<Map<String, Object>> getUserSignAddInfo(long idNo, String busiType, Long loginAccept);
	
	
	/**
	* 名称：判断是否开通自动缴费
	*/
	public boolean isAutoPay(long idNo);
	
	
	/**
	* 名称：修改自动缴费属性（金额、阀值、标识）
	* @param inParam Map传入 UPDATE_ACCEPT、UPDATE_LOGIN、UPDATE_FLAG
	* @return 返回修改自动缴费表条数
	*/
	public int uAutoPay(long idNo, Long payMoney, Long balanceLimit, String autoFlag, Map<String, Object> inParam);
	
	public void inAutoPay(UserSignInfoEntity userSignInfo, AutoPayFieldEntity autoPayField);
	
	/**
	 * 名称：查询自动缴费记录
	 */
	public SignAutoPayEntity getAutoPay(long idNo);
	
	/**
	 * 名称：根据地市GROUP_ID查询支付宝工号
	 * @param groupId
	 * @return loginNo
	 * 
	 */
	public String getAlipayLoginNo(String groupId);
	
	/**
	 * 名称：获取支付宝签约spartner和secret
	 * @param 地市groupId 支付宝工号loginNo
	 * @return spartner secret
	 */
	public Map<String,Object> getAlipaySign(String groupId,String loginNo);
	
	/**
	 * 名称：判断是否是支付宝签约用户
	 * @param 
	 */
	public boolean isAlipay(long idNo);
	
}