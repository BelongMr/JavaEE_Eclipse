package com.sitech.acctmgr.test.atom.busi.inter;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import com.sitech.ac.rdc.re.api.common.util.MBean;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.acctmgrint.atom.busi.intface.IBusiMsgSnd;
import com.sitech.jcfx.context.JCFContext;

public class B2CBusiSynTest extends BaseTestCase {

	@Test
	public void testBossToCrmBusiSyn() {
		
		log.info("-----------konglj test ordersvc b2c stt---------");
		IBusiMsgSnd busiOdrBc = (IBusiMsgSnd) JCFContext.getBean("BusiOdrBcEnt");
		
		HashMap<String, Object> header = new HashMap<String, Object>();
		//理论上，从前台获取的Header的Map信息
		header.put("DB_ID", "A1");

		Map<String, Object> inMap = new HashMap<String, Object>();
		String string = "{\"CHANNEL_ID\":\"11\",\"DB_ID\":\"\",\"ENV_ID\":\"\",\"KEEP_LIVE\":\"10.161.146.166\",\"PARENT_CALL_ID\":\"04E7201A0C257130C7945531316AF956\",\"POOL_ID\":\"2\",\"ROUTING\":{\"ROUTE_KEY\":\"\",\"ROUTE_VALUE\":\"\"},\"TRACE_ID\":\"02*20150611154303*null*null*204701\"}";

		MBean mbean = new MBean("{\"ROOT\":{\"HEADER\":{\"CHANNEL_ID\":\"11\",\"DB_ID\":\"\",\"ENV_ID\":\"\",\"KEEP_LIVE\":\"10.161.146.166\",\"PARENT_CALL_ID\":\"04E7201A0C257130C7945531316AF956\",\"POOL_ID\":\"2\",\"ROUTING\":{\"ROUTE_KEY\":\"\",\"ROUTE_VALUE\":\"\"},\"TRACE_ID\":\"02*20150611154303*null*null*204701\"},\"BODY\":{\"COMMON\":{\"BACK_FLAG\":\"0\",\"BUSI_DAY\":\"20150519\",\"CONTACT_ID\":\"\",\"GROUP_ID\":\"38189\",\"LOGIN_ACCEPT\":\"10000000008894\",\"LOGIN_NO\":\"daM300\",\"OLD_LOGIN_ACCEPT\":\"10000000008894\",\"OP_CODE\":\"8008\",\"OP_NOTE\":\"13694340623退预存款0.60元\",\"OP_TIME\":\"20150519141008\",\"SUB_ORDER_ID\":\"10000000008894\"},\"FEE_INFO_LIST\":[{\"CASH_FEE\":0,\"DERATE_FEE\":\"0\",\"FEE_CODE\":\"0\",\"FEE_TYPE\":\"9\",\"OBJECT_ID\":220420200001270202,\"OBJECT_TYPE\":\"3\",\"OTHER_FEE\":-60,\"PAY_TYPE\":\"9\"}],\"OBJ_INFO_LIST\":[{\"BASE_PRODPRC_ID\":\"0\",\"BRAND_ID\":\"2230xx\",\"OBJECT_ID\":220420200001270202,\"OBJECT_NAME\":\"账户\",\"OBJECT_NO\":220420200001270202,\"OBJECT_TYPE\":\"3\",\"PHONE_NO\":\"13694340623\"}]}}}");
		log.debug("-----mbean===="+mbean.toString());
		//黑名单
		inMap.put("ORDER_ID", "10006");//取配置
		inMap.put("HEADER", mbean.getHeader());
		inMap.put("OWNER_FLAG", "1");
		inMap.put("LOGIN_ACCEPT", "10000000009896");
		inMap.put("CREATE_TIME", "20150611154526");
		inMap.put("LOGIN_NO", "dd1124");
		inMap.put("OP_CODE", "8007");
		inMap.put("BUSIID_NO", "220220200016614283");
		inMap.put("ID_NO", "220220200016614283");
		inMap.put("CUST_ID", "220210000028298129");
		inMap.put("BLACKTYPE", "11");
		inMap.put("OPTYPE", "A");
		inMap.put("ID_TYPE", "3");
		inMap.put("ID_ICCID", "++MDAwMDAwMDAwMDAwMDAwMDAw");
		

		//用户状态变化工单 使用模板
//		inMap.put("HEADER", header);
//		inMap.put("OWNER_FLAG", "1");
//		inMap.put("ORDER_ID", "10000");//取配置
//		inMap.put("LOGIN_ACCEPT", "2015051900001");
//		inMap.put("NEW_STATUS", "A");
//		inMap.put("LOGIN_NO", "fwktCS");
//		inMap.put("OP_CODE", "8000");
//		inMap.put("BUSIID_NO", "220505200018706699");
//		inMap.put("ID_NO", "220505200018706699");
//		inMap.put("CREATE_TIME", "20150519111959");
		
		//营业日报 不使用模板
//		inMap.put("ORDER_ID", "10001");//取配置
//		inMap.put("LOGIN_ACCEPT", "10000000008894");
//		inMap.put("LOGIN_NO", "daM300");
//		inMap.put("OP_CODE", "8008");
//		inMap.put("BUSIID_NO", "220420200001270202");
//		inMap.put("CREATE_TIME", "20150519111959");
//		inMap.put("ODR_CONT", "{\"ROOT\":{\"HEADER\":{\"ROUTING\":{\"ROUTE_KEY\":\"\",\"ROUTE_VALUE\":\"\"}},\"BODY\":{\"COMMON\":{\"BACK_FLAG\":\"0\",\"BUSI_DAY\":\"20150519\",\"CONTACT_ID\":\"\",\"GROUP_ID\":\"38189\",\"LOGIN_ACCEPT\":\"10000000008894\",\"LOGIN_NO\":\"daM300\",\"OLD_LOGIN_ACCEPT\":\"10000000008894\",\"OP_CODE\":\"8008\",\"OP_NOTE\":\"13694340623退预存款0.60元\",\"OP_TIME\":\"20150519141008\",\"SUB_ORDER_ID\":\"10000000008894\"},\"FEE_INFO_LIST\":[{\"CASH_FEE\":0,\"DERATE_FEE\":\"0\",\"FEE_CODE\":\"0\",\"FEE_TYPE\":\"9\",\"OBJECT_ID\":220420200001270202,\"OBJECT_TYPE\":\"3\",\"OTHER_FEE\":-60,\"PAY_TYPE\":\"9\"}],\"OBJ_INFO_LIST\":[{\"BASE_PRODPRC_ID\":\"0\",\"BRAND_ID\":\"2230xx\",\"OBJECT_ID\":220420200001270202,\"OBJECT_NAME\":\"账户\",\"OBJECT_NO\":220420200001270202,\"OBJECT_TYPE\":\"3\",\"PHONE_NO\":\"13694340623\"}]}}}");

		busiOdrBc.opPubOdrSndInter(inMap);

		log.info("-----------konglj test ordersvc b2c end--------");
	}
	
	/**
	 * {"A":"A1","B":"{"1":"b1","2":"b2"}","C":"C1"}
	 * @param string
	 * @return
	 */
	Map<String, Object> stringToMap(String string) {
		
		Map<String, Object> outMap = new HashMap<String, Object>();
		Map<String, Object> tmpMap = null;
		
		String[] strArr = string.split(",");
		if (0 == strArr.length)
			return null;
		
		for (String key_val:strArr) {
			
		}
		
		return outMap;
	}
	

}
