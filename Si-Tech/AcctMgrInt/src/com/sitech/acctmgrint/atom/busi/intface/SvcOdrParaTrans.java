package com.sitech.acctmgrint.atom.busi.intface;

import com.sitech.acctmgrint.common.AcctMgrError;
import com.sitech.acctmgrint.common.constant.InterBusiConst;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.dt.MBean;

import java.util.HashMap;
import java.util.Map;

public class SvcOdrParaTrans {
	
	/**
	 * Title 用户状态变化接口参数转换方法
	 * @param inParaStr
	 * @return
	 */
	public Map<String, Object> transUserStatuPara(Map<String, Object> inParamMap) {
		
		if (null == inParamMap)
			throw new BusiException(AcctMgrError.getErrorCode("0000","11101"), "服务开通入参错误！请检查。");

		String sLoginNo = inParamMap.get("LOGIN_NO").toString();
		String sOpCode = inParamMap.get("OP_CODE").toString();
		String sOpenFlag = inParamMap.get("OPEN_FLAG").toString();
		String sOwnerFlag = inParamMap.get("OWNER_FLAG").toString();
		String sRunCode = inParamMap.get("RUN_CODE").toString();

		/*long lIdNo = Long.valueOf(inParamMap.get("ID_NO").toString());
		String sSvcStr = inParamMap.put("SVC_STR").toString();
		String sFywFlag = inParamMap.put("FYW_FLAG").toString();
		String sContractNo = inParamMap.put("CONTRACT_NO").toString();*/

		if (null == sLoginNo || null == sOpCode || null == sOpenFlag) {
			System.out.println("FWKT,Some required Params maybe null,please check!");
			return null;
		}
		if (!(sOpenFlag.equals("0") || sOpenFlag.equals("1") || sOpenFlag.equals("2"))) {
			System.out.println("The Value of OPEN_FLAG is Error,its value only could be 0 or 1 or 2.");
			return null;
		}
		
		if (inParamMap.get("FYW_FLAG") == null)
			inParamMap.put("FYW_FLAG", "-1");
		
		Map<String, Object> strDataTmp = new HashMap<String, Object>();
		//body
		if (sOwnerFlag.equals("2") || sOwnerFlag.equals("4")) {//无主标识
			strDataTmp.put("ORDER_ID", "10023");
			strDataTmp.put("ID_NO", InterBusiConst.WZ_ID_NO);
			strDataTmp.put("BUSIID_NO", InterBusiConst.WZ_ID_NO);
			strDataTmp.put("BUSIID_TYPE", "0");
			
			//同步工单信息
			strDataTmp.put("PHONE_NO", inParamMap.get("PHONE_NO"));
			strDataTmp.put("OPEN_TIME", inParamMap.get("OPEN_TIME"));
			strDataTmp.put("GROUP_ID", inParamMap.get("GROUP_ID"));
			strDataTmp.put("CHG_REASON", "NoOwner User's FWKT .");
						
		} else if (sOwnerFlag.equals("1") || sOwnerFlag.equals("3")) {//有主标识
			if (sRunCode.equals("b")) {
				strDataTmp.put("ORDER_ID", "10004");
				strDataTmp.put("BUSIID_NO", inParamMap.get("ID_NO"));
				strDataTmp.put("BUSIID_TYPE", "0");
				//同步 拆机工单信息
				strDataTmp.put("ID_NO",    inParamMap.get("ID_NO"));
				strDataTmp.put("CONTRACT_NO", inParamMap.get("CONTRACT_NO"));
				strDataTmp.put("STATUS",   inParamMap.get("RUN_CODE"));
				strDataTmp.put("CHG_TIME", inParamMap.get("OP_TIME"));
				strDataTmp.put("BLACK_FLAG", inParamMap.get("BLACK_FLAG"));
				strDataTmp.put("CHG_REASON", "Normal User's FWKT .");
				strDataTmp.put("OP_CODE", inParamMap.get("OP_CODE"));
				strDataTmp.put("LOGIN_ACCEPT",  inParamMap.get("LOGIN_ACCEPT"));
				strDataTmp.put("LOGIN_NO",  inParamMap.get("LOGIN_NO"));
				strDataTmp.put("CREATE_TIME",  inParamMap.get("OP_TIME"));
				strDataTmp.put("RUN_TIME",  inParamMap.get("OP_TIME"));
				strDataTmp.put("REMARK",  "拆机");
				strDataTmp.put("CREATE_ACCEPT", inParamMap.get("BC_LOGIN_ACCEPT"));
				
			} else {
				//同步 普通停开机工单信息
				strDataTmp.put("ORDER_ID", "10000");
				strDataTmp.put("LOGIN_NO", inParamMap.get("LOGIN_NO"));
				strDataTmp.put("OP_CODE", inParamMap.get("OP_CODE"));
				
				strDataTmp.put("BUSIID_NO", inParamMap.get("ID_NO"));
				strDataTmp.put("ID_NO", inParamMap.get("ID_NO"));
				strDataTmp.put("PHONE_NO", inParamMap.get("PHONE_NO"));
				strDataTmp.put("NEW_STATUS", inParamMap.get("RUN_CODE"));
				strDataTmp.put("CREATE_TIME", inParamMap.get("OP_TIME"));
				strDataTmp.put("RUN_TIME",  inParamMap.get("OP_TIME"));
				if (inParamMap.get("LOGIN_ACCEPT") != null)
					strDataTmp.put("LOGIN_ACCEPT", inParamMap.get("LOGIN_ACCEPT"));
				else 
					strDataTmp.put("LOGIN_ACCEPT", inParamMap.get("BC_LOGIN_ACCEPT"));
				strDataTmp.put("CREATE_ACCEPT", inParamMap.get("BC_LOGIN_ACCEPT"));
				strDataTmp.put("GROUP_ID", inParamMap.get("GROUP_ID"));
				
			}
			
		}
		//Header
		Map<String, Object> head = null;
		if (inParamMap.get("HEADER") != null)
			head = (Map<String, Object>) inParamMap.get("HEADER");
		else {
			head = new HashMap<String, Object>();
			String sub_id = strDataTmp.get("ID_NO").toString().substring(3, 4);
			if (sub_id.equals("1")||sub_id.equals("7")||sub_id.equals("8"))
				head.put("DB_ID", "A1");
			else 
				head.put("DB_ID", "B1");
			
		}
		strDataTmp.put("HEADER", head);
		inParamMap.put("HEADER", head);
		
		if(head.get("TRACE_ID") != null)
			inParamMap.put("TRACE_ID", head.get("TRACE_ID"));
		else
			inParamMap.put("TRACE_ID", "");	
		
		inParamMap.put("BTOC", strDataTmp);
		//inParamMap.put("STRING_DATA", strDataTmp);
		
		if(inParamMap.get("RUN_CODE").toString().equals("J")){
			MBean sendBusi = new MBean();	//拼装的发送消息中间件报文
			sendBusi.setHeader(head);		
			Map<String, Object> oprInfoMap = new HashMap<String, Object>();
			oprInfoMap.put("CONTACT_ID", "-1");
			oprInfoMap.put("REGION_ID", inParamMap.get("ID_NO").toString().substring(0, 4));
			oprInfoMap.put("LOGIN_NO", inParamMap.get("LOGIN_NO"));
			oprInfoMap.put("GROUP_ID", inParamMap.get("GROUP_ID"));
			oprInfoMap.put("OP_CODE", inParamMap.get("OP_CODE"));
			oprInfoMap.put("OP_NOTE", "预拆");
			oprInfoMap.put("CUST_ID_TYPE", "1");   //0客户ID;1-服务号码;2-用户ID;3-账户ID;
			oprInfoMap.put("CUST_ID_VALUE", inParamMap.get("PHONE_NO"));	
			oprInfoMap.put("SERVICE_NO",inParamMap.get("PHONE_NO"));
			if (inParamMap.get("LOGIN_ACCEPT") != null)
				oprInfoMap.put("CNTT_LOGIN_ACCEPT", inParamMap.get("LOGIN_ACCEPT"));
			else 
				oprInfoMap.put("CNTT_LOGIN_ACCEPT", inParamMap.get("CO_LOGIN_ACCEPT"));
			oprInfoMap.put("CNTT_OP_TIME", inParamMap.get("OP_TIME"));
			
			sendBusi.addBody("OPR_INFO", oprInfoMap);
			
			Map<String, Object> bcMap = new HashMap<String, Object>();
			bcMap.put("CREATE_ACCEPT", inParamMap.get("CO_LOGIN_ACCEPT"));
			if (inParamMap.get("LOGIN_ACCEPT") != null)
				bcMap.put("LOGIN_ACCEPT", inParamMap.get("LOGIN_ACCEPT"));
			else 
				bcMap.put("LOGIN_ACCEPT", inParamMap.get("CO_LOGIN_ACCEPT"));
			bcMap.put("CONTACT_ID", "-1"); //统一流水
			bcMap.put("BUSIID_TYPE", "0");
			bcMap.put("BUSIID_NO", inParamMap.get("ID_NO"));
			bcMap.put("LOGIN_NO", inParamMap.get("LOGIN_NO")); 
			bcMap.put("OP_CODE", inParamMap.get("OP_CODE"));
			bcMap.put("OWNER_FLAG", "1"); 
			bcMap.put("ORDER_ID", "10008");//工单模板号 
			bcMap.put("ODR_CONT", sendBusi);
			inParamMap.put("BTOCONTACT", bcMap);
		}

		return inParamMap;
	}
	
}