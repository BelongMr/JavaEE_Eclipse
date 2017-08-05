package com.sitech.acctmgrint.atom.busi.intface;

import com.sitech.acctmgrint.common.AcctMgrError;
import com.sitech.jcf.core.exception.BusiException;

import java.util.HashMap;
import java.util.Map;

public class BusiMsgSnd extends PubInterComm implements IBusiMsgSnd {

	public boolean opPubOdrSndInter(Map<String, Object> inParaMap) {

		/*String sChgTime;状态变更时间,格式"YYYYMMDDHH24MISS"*/
		String sBcLogAccept = "";
		String sBcAcceptHead = "";
		Map<String, Object> inBcParaMap = new HashMap<String, Object>();
		log.debug("-------konglj test--getBcOrderSyn stt---=");
		
		//2.调用名种原子服务完成业务实现
		sBcAcceptHead = "BC"; /*服务开通中BOSS->CRM流水头部*/
		sBcLogAccept = this.getInterLoginAccept(sBcAcceptHead);
		if (sBcLogAccept.equals("")) {
			throw new BusiException(AcctMgrError.getErrorCode(
					inParaMap.get("OP_CODE").toString(), "10001"), "Boss->crm同步失败，流水获取失败！");
		}
		inParaMap.put("CREATE_ACCEPT", sBcLogAccept);

		//Bc参数传递,模板参数替换
		inBcParaMap = this.getBcParamExchg(inParaMap);
		if (inBcParaMap == null || inBcParaMap.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode(
					inParaMap.get("OP_CODE").toString(), "10011"), "param exchange failed!");
		}
		
		
		inBcParaMap.put("BC_LOGIN_ACCEPT", sBcLogAccept);
		log.debug("---konglj test--getBcOrderSyn s222-sBcLogAccept=" +sBcLogAccept );
		
		//3.插入消息中间件
		//inBcParaMap.put("SUFFIX", InterBusiConst.BTC_SUFFIXBASE);//普通工单入接口表00
		if (this.sendBcOrderMsg(inBcParaMap) == false)
			throw new BusiException(AcctMgrError.getErrorCode(
					inBcParaMap.get("OP_CODE").toString(), "10002"), "Boss->crm同步失败，插入接口表失败！");
	
		return true;
	}
	
}