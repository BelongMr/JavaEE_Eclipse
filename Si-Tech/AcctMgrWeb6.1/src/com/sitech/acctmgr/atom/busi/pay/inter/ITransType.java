package com.sitech.acctmgr.atom.busi.pay.inter;

import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.pay.TransFeeEntity;

/**
*
* <p>Title:  转账类型接口 </p>
* <p>Description: 不同转账类型，余额查询、特殊业务处理接口  </p>
* <p>Copyright: Copyright (c) 2014</p>
* <p>Company: SI-TECH </p>
* @author guwoy
* @version 1.0
*/
public interface ITransType {
	
	/**
	 * 名称：获取账本类型
	 * @return
	 */
	String getTransTypes();
	
	/*获取可转金额*/
	public long getTranFee(long inContractNo);
	
	/**
	 * 名称：获取按账本合并后的转账列表,做前台展示用
	 * @param inContractNo
	 * @return
	 */
	public List<TransFeeEntity> getComTranFeeList(long inContractNo);
	
	/**
	 * 名称：个性化业务信息查询
	 * @param inMap
	 * @return
	 */
	public Map<String, Object> getSpecialBusiness(Map<String, Object> inMap);

	/**
	 * 名称：获取转账列表,不同类型账本冲销不同账单
	 * @param inContractNo
	 * @return
	 */
	public List<Map<String, Object>> getTranFeeList(long inContractNo);
		
	/**
	 * 名称：转账备注信息
	 * @param opNote
	 * @return
	 */
	public String getOpNote(String opNote) ;
	
	/**
	 * 名称：个性化业务处理
	 * @param inMap
	 */
	public void doSpecialBusi(Map<String, Object> inMap);
	
	/**
	 * 名称：发送短信
	 * @param inMap
	 */
	public void transFeeSendMsg(Map<String, Object> inMap);
	
	/**
	 * 名称：确认服务个性化验证
	 * @param checkMap
	 */
	void checkCfm(Map<String, Object> checkMap);
	
	/**
	 * 名称：限额验证
	 * @param limitCycle
	 * @param regionGroup
	 * @param limitType
	 * @param transFee
	 */
	public void checkRegionLimit(String regionGroup,String limitType,long transFee);
	
}
