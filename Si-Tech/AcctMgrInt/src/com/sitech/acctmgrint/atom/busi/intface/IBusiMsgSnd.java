package com.sitech.acctmgrint.atom.busi.intface;

import java.util.Map;

public interface IBusiMsgSnd {

	/**
	 * Title: BOSS同步业务工单消息接口 </p>
	 * Description: 主要是BOSS库向CRM库同步状态变更、资金管理、呆坏账回收等数据工单同步功能，
	 * 				也支持向其他系统同步消息，如BOSS内部异步消息发送。
	 * @param Map:（暂定）同步CRM工单中参数拼成的报文  
	 * @param  OWNER_FLAG:1(2/3/4):
	 * 			'1'为非批量有主，'2'为非批量无主,'3'为批量有主,'4'为批量无主
	 * @param  ORDER_ID:工单代码 
	 * @Note 相关参数：
	 * @param  BUSIID_NO:ID_NO 或 PHONE_NO 或 0（BUSIID_TYPE:0客户ID;1-服务号码;2-用户ID;3-账户ID）
	 * @param  LOGIN_NO:操作工号
	 * @param  OP_CODE:操作标识
	 * @param  LOGIN_ACCEPT:自定义流水，如缴费流水等。若没有，则自动生成
	 * @param  CONTACT_ID:统一流水，备用。若没有则不传
	 * @Note 工单是否需要检查或替换参数(配置中存储): 若检查,HEADER必传；不检查，则ODR_CONT必传
	 * @param  HEADER:前端透传.若检查参数,HEADER必传,及报文中需要的参数一并传入
	 * @param  ODR_CONT:待发送报文的MBean字符串.不检查参数，则ODR_CONT必传
	 * @return 返回工单同步是否成功等信息
	 * @throws Exception
	 */
	public boolean opPubOdrSndInter(Map<String, Object> inParaMap);
	
}