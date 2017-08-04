/**
 * 服务开通包置单独路径实现
 */
package com.sitech.acctmgrint.atom.busi.intface;

import java.util.Map;

/**
 * 
 * <p>Title: BOSS服务开通接口</p>
 * <p>Description: BOSS服务开通统一接口，JAVA版本供前端服务调用，另有C版本供后台调用</p>
 * <p>Copyright: Copyright (c) 2006</p>
 * <p>Company: SI-TECH </p>
 * @version 1.0
 * @author KONGLJ
 * @date 2014/09
 */
public interface ISvcOrder {
	
	//后台实时停机状态变化接口 -> 后台模块调用时使用SvcOrderCpp接口中方法
//	public boolean opUserStatuInter(long inIdNo, String inPhoneNo, String inLoginNo, 
//				long inContactId, String inOpTime, String inOpCode, 
//				String inOwnerFlag, String inNewRun, String inOpenFlag, String inFywFlag);
	/**
	 * 
	 * Title: 前台缴费等-用户状态变更及指令发送接口</br>
	 * Description: BOSS侧实时停机、缴费开机等调用该接口进行状态变更，及发送指令处理
	 * @param inParamMap:参数（暂定）：
	 * @param ID_NO:用户标识，必传
	 * @param PHONE_NO:号码，必传
	 * @param RUN_CODE:新状态，必传
	 * @param OP_TIME:操作时间,格式:yyyymmddhh24miss，必传
	 * @param CONTACT_ID:统一流水 ，必传
	 * @param LOGIN_NO:操作工号 ，必传
	 * @param OP_CODE:操作标识，必传
	 * @param OWNER_FLAG:有主无主标示，必传
	 * 					'1'为后台有主，'2'为后台无主,'3'为前台有主,'4'为前台无主
	 * @param OPEN_FLAG:服务开通标识，必传
	 *                  0--只服务开通 1--只更改用户状态 2--即开通又更改用户状态
	 * @param FYW_FLAG:分业务停开机标识，和inSvcStr配合使用，不用则传-1或不传
	 *                0:暂停SVC 1:恢复SVC
	 * @param SVC_STR:和 FYW_FLAG 配合使用，如传：B01001|B01002
	 * @param CONTRACT_NO:账号ID，分业务停开机时必传
	 * @return 返回Map,包含FWKT_RET_CODE,FWKT_RET_MSG,变更是否成功信息
	 * @throws Exception
	 */
	public boolean opUserStatuInter(Map<String, Object> inParamMap);
	//后台局拆状态变化接口
	public boolean opArearStatuInter(Map<String, Object> inParaMap);
	
	//public boolean refreshConfigCache();
}
