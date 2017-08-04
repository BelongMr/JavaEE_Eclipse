package com.sitech.acctmgrint.atom.busi.intface;

import com.alibaba.fastjson.JSON;
import com.sitech.jcf.context.LocalContextFactory;
import com.sitech.jcf.core.SessionContext;
import com.sitech.jcf.core.dao.BaseDao;
import com.sitech.jcf.core.datasource.JCFConnection;
import com.sitech.jcf.core.util.XMLFileContext;
import com.sitech.jcfx.context.JCFContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

/**
 * 
 * <p>Title: BOSS服务开通接口实现类</p>
 * <p>Description: BOSS服务开通统一接口实现部分</p>
 * <p>Copyright: Copyright (c) 2006</p>
 * <p>Company: SI-TECH </p>
 * @author konglj
 * @version 1.0
 *
 */
public class PubInterCpp {
	
	static{
		XMLFileContext.addXMLFile("applicationContext-svcodr.xml");
		// 加载spring容器
		XMLFileContext.loadXMLFile();
	}
	
	private static Logger log = LoggerFactory.getLogger(PubInterCpp.class);
	//后台定义：springcfgsvcodr目录下，重新定义一个事务提交的Bean SvcOrderSvc
	private static ISvcOrder svcOrder = LocalContextFactory.getInstance().getBean("SvcOrderSvc", ISvcOrder.class);
	//private static IShortMessage sendmsg = LocalContextFactory.getInstance().getBean("ShortMessageSvc", IShortMessage.class);
	private static IBusiMsgSnd busiodr = LocalContextFactory.getInstance().getBean("BusiOdrSndSvc", IBusiMsgSnd.class);
	
	/**
	 * Title: 实时停机-用户状态变更及指令发送接口</br>
	 * Description 参数取值详细见opUserStatuInter(Map)接口</br>
	 * @param inIdNo 用户标识，无主传0，必传
	 * @param inPhoneNo 号码，必传
	 * @param inOwnerFlag 有主无主标示，必传
	 * 					'1'为后台有主，'2'为后台无主,'3'为前台有主,'4'为前台无主
	 * @param inNewRun boss侧新状态,必传
	 * @param inOpenFlag:一般传2,0--只服务开通 1--只更改用户状态 2--即开通又更改用户状态,必传
	 * @param inFywFlag:分业务停开机标识，和inSvcStr配合使用，不用则传-1或不传
	 *                0:暂停SVC 1:恢复SVC
	 * @param inSvcStr:和inFywFlag配合使用，如传：B01001|B01002
	 * @param sOtherData参数串:GROUP_ID=xxxxx,BRAND_ID=xxxx,
	 *        LOGIN_NO=xxxxx,LOGIN_ACCEPT=10001234,OP_TIME=20140101125959,OP_CODE=0000
	 * @param inDBLable=数据库标识，A1/A2/B1/B2 or HEADERJson串 ,必传
	 * @param service_no 与PHone_NO作用相同
	 * @return true/false	
	 * @throws Exception
	 */
	public boolean CPP_opUserStatuInter(long inIdNo, String inPhoneNo, 
			 String inOwnerFlag, String inNewRun, String inOpenFlag, 
			 String inFywFlag, String inSvcStr, 
			 String sOtherData, String inDBLabel) {//String jsonHeader
		
		log.debug("---CPP_opUserStatuInter--stt--id_no="+inIdNo);
		String[] sDataStrs = null;
		String[] saTmpStrs = null;
		//判空，如果没有传必要的值直接结束
		if (inDBLabel.equals("")||inPhoneNo.equals("")||inNewRun.equals("")) {
			System.out.println("inDBLable is "+inDBLabel+",or inPhoneNo is "+inPhoneNo+",or inNewRun is "+inNewRun+",someone is null, please check!");
			return false;
		}
		
		//用于存放其他用户信息
		Map<String, Object> userStatuMap = new HashMap<String, Object>();
		
		//处理参数其他信息（进行分离存储）
		sDataStrs = sOtherData.split(",");
		for (String sTmpStr : sDataStrs) {
			//处理键值对儿拆分
			saTmpStrs = sTmpStr.split("=");
			if (saTmpStrs[0] == null || saTmpStrs[0].equals(""))
				continue;
			userStatuMap.put(saTmpStrs[0], saTmpStrs[1]);
		}
		
		//数据连接那个库？（根据标识选择数据源eg：A1：DataSourceA1）
		Map<String, Object> headerMap = null;
		if (inDBLabel.trim().length() == 2) {
			//数据连接那个库？
			headerMap = new HashMap<String, Object>();
			if (!inDBLabel.trim().equals("{}"))
				headerMap.put("DB_ID", inDBLabel);//A1
			else {
				headerMap.put("DB_ID", getDbIdByIdNo(inIdNo));//A1
			}
			//路由
			Map<String, Object> route = new HashMap<String, Object>();
			route.put("ROUTE_KEY", "10");//ROUTE_KEY=10,ROUTE_VALUE=PHONE_NO
			route.put("ROUTE_VALUE", inPhoneNo);
			headerMap.put("ROUTING", route);
			
			userStatuMap.put("HEADER", headerMap);
		} else {
			try {
				headerMap = (Map<String,Object>)JSON.parse(inDBLabel);
				if (null == headerMap.get("DB_ID"))
					//如果没有穿用户的数据库标识就用ID_NO来获取
					headerMap.put("DB_ID", getDbIdByIdNo(inIdNo));
				userStatuMap.put("HEADER", headerMap);
			} catch (Exception e) {
				log.error("转换Json失败，inDBLabel="+inDBLabel);
				e.printStackTrace();
			}
		}
		userStatuMap.put("ID_NO",    inIdNo);
		userStatuMap.put("PHONE_NO", inPhoneNo);
		userStatuMap.put("OWNER_FLAG", inOwnerFlag);
		userStatuMap.put("RUN_CODE", inNewRun);
		userStatuMap.put("OPEN_FLAG",inOpenFlag);
		userStatuMap.put("FYW_FLAG", inFywFlag);
		userStatuMap.put("SVC_STR", inSvcStr);/*20150123 add*/	
		userStatuMap.put("SERVICE_NO", inPhoneNo);
		
		//设置A/B库连接 注：在服务调用外设置才有效 
        SessionContext.setDbLabel(headerMap.get("DB_ID").toString());
		
		log.debug("----后台C/CPP:开始调用服务开通统一接口--入参Map=["+userStatuMap.toString()+"]");
		//调用 Map参数接口*****/
		if (svcOrder.opUserStatuInter(userStatuMap) == false) {
			log.error("----invoke opUserStatuInter err,msg="+userStatuMap.toString());
			return false;
		}
	
		log.debug("----后台C/CPP:开始调用服务开通统一接口 结束--");
		return true;
	}
	
	/**
	 * Title: 局拆方法 </p>
	 * Description: 实时停机局拆程序接口 </p>
	 * @param sBlackFlag 黑名单标识
	 * @param sOtherData参数串解释:GROUP_ID=xxxxx,BRAND_ID=xxxx,
	 *        LOGIN_NO=xxxxx,CONTACT_ID=10001234,OP_TIME=20140101125959,OP_CODE=0000
	 * @param inDBLable=数据库标识，A1/A2/B1/B2 or HEADERJson串 ,必传
	 */
	public boolean CPP_opArearStatuInter(long lIdNo, String sPhoneNo, String sRunCode, 
			 String sBlackFlag, String sOtherData
			, String inDBLabel) {
		log.debug("---cpp_areaStatuInter--stt--sOtherData="+sOtherData);
		String[] sDataStrs = null;
		String[] saTmpStrs = null;
		if (inDBLabel.equals("")||sPhoneNo.equals("")||sRunCode.equals("")) {
			System.out.println("inDBLable is "+inDBLabel+",or sPhoneNo is "+sPhoneNo+",or sRunCode is "+sRunCode+",someone is null, please check!");
			return false;
		}
		Map<String, Object> userStatuMap = new HashMap<String, Object>();
		//处理参数部分
		userStatuMap.put("ID_NO",      lIdNo);
		userStatuMap.put("PHONE_NO",   sPhoneNo);
		userStatuMap.put("BLACK_FLAG", sBlackFlag);
		userStatuMap.put("RUN_CODE",   sRunCode);
		userStatuMap.put("OWNER_FLAG", "1");
		userStatuMap.put("OPEN_FLAG",  "2");
		userStatuMap.put("FYW_FLAG",   "-1");
		
		sDataStrs = sOtherData.split(",");
		for (String sTmpStr : sDataStrs) {
			saTmpStrs = sTmpStr.split("=");
			if (saTmpStrs[0] == null || saTmpStrs[0].equals(""))
				continue;
			userStatuMap.put(saTmpStrs[0], saTmpStrs[1]);
		}
		
		//数据连接那个库？
		if (inDBLabel.trim().length() == 2) {
			//数据连接那个库？
			Map<String, Object> headerMap = new HashMap<String, Object>();
			if (!inDBLabel.trim().equals("{}"))
				headerMap.put("DB_ID", inDBLabel);//A1
			else {
				headerMap.put("DB_ID", getDbIdByIdNo(lIdNo));//A1
			}
			userStatuMap.put("HEADER", headerMap);
		} else {
			try {
				Map<String,Object> header = (Map<String,Object>)JSON.parse(inDBLabel);
				userStatuMap.put("HEADER", header);
			} catch (Exception e) {
				log.error("转换Json失败，inDBLabel="+inDBLabel);
				e.printStackTrace();
			}
		}
		
		//调用 Map参数接口
		return svcOrder.opUserStatuInter(userStatuMap);
	}
	
	/**
	 * Title: 向其他系统同步工单接口 </p>
	 * Description: 常用于BOSS库向CRM库同步状态变更、资金管理、呆坏账回收等数据工单同步功能
	 * @param  CONTACT_ID:统一流水 
	 * @param  LOGIN_NO:操作工号 
	 * @param  OP_CODE:操作标识
	 * @param  ORDER_ID:工单模板代码 
	 * @param  OWNER_FLAG:1(2/3/4):
	 * 			'1'为非批量有主，'2'为非批量无主,'3'为批量有主,'4'为批量无主
	 * @param  STRING_DATA 层级：包含报文参数{工单参数按顺序写入,以‘,’隔开PHONE_NO=13500001111,NEW_RUN=A,...}
	 * @param  inDBLable 数据库标签,如A1
	 * @return 返回工单同步是否成功等信息
	 * @throws Exception
	 */
	public boolean CPP_opPubOdrSndInter(String CONTACT_ID, String LOGIN_NO, String OP_CODE, 
			String ORDER_ID, String OWNER_FLAG, String sOdrParaData
			, String inDBLabel) {
		
		if (inDBLabel.equals("")) {
			System.out.println("inDBLable is "+inDBLabel+", please check!");
			return false;
		}
		String[] pArrayStrs = null;
		String[] pArrKeyVal = null;
		Map<String, Object> mParaMap = new HashMap<String, Object>();
		
		mParaMap.put("CONTACT_ID", CONTACT_ID);
		mParaMap.put("LOGIN_NO",   LOGIN_NO);
		mParaMap.put("OP_CODE",    OP_CODE);
		mParaMap.put("ORDER_ID",   ORDER_ID);
		mParaMap.put("OWNER_FLAG", OWNER_FLAG);
		//数据连接那个库？
		Map<String, Object> headerMap = null;
		if (inDBLabel.trim().length() == 2) {
			//数据连接那个库？
			headerMap = new HashMap<String, Object>();
			headerMap.put("DB_ID", inDBLabel);//A1
			mParaMap.put("HEADER", headerMap);
		} else {
			try {
				headerMap = (Map<String,Object>)JSON.parse(inDBLabel);
				mParaMap.put("HEADER", headerMap);
			} catch (Exception e) {
				log.error("转换Json失败，inDBLabel="+inDBLabel);
				e.printStackTrace();
			}
		}
		
		//设置A/B库连接 注：在服务调用外设置才有效
		/*if (null != headerMap.get("DB_ID")) {
			String db_id = headerMap.get("DB_ID").toString();
			if (!db_id.equals(""))
				SessionContext.setDbLabel(db_id);
		}*/
		
		//拆解StringData参数串
		pArrayStrs = sOdrParaData.split(",");
		for (String strTmp : pArrayStrs) {
			pArrKeyVal = strTmp.split("=");
			if (pArrKeyVal[0].equals("ID_NO") || pArrKeyVal[0].equals("IDNO"))
				mParaMap.put("ID_NO", pArrKeyVal[1]);
			if (pArrKeyVal[0].equals("PHONE_NO") || pArrKeyVal[0].equals("PHONENO"))
				mParaMap.put("PHONE_NO", pArrKeyVal[1]);
			
			//放入Map
			mParaMap.put(pArrKeyVal[0], pArrKeyVal[1]);
		}
		
		//调用MBean参数方法
		return busiodr.opPubOdrSndInter(mParaMap);
	}
	
	/**
	 * 获取数据库标识
	 * @param in_id_no 用户的ID_NO
	 * @return ：返回对应的数据库标识
	 */
	private String getDbIdByIdNo(long in_id_no) {
		char city_code = String.valueOf(in_id_no).charAt(3);
		switch (city_code) {
		case '1':
		case '8':
		case '7':
			return "A1";
		default:
			return "B1";
		}
	}
	
	public static void main(String[] args) {
		PubInterCpp pubinter = new PubInterCpp();
		
		//停机测试
		pubinter.CPP_opUserStatuInter(
				230300003002979006L, 
				"13845361747", 
				"1", 
				"A", 
				"0",
				"-1", 
				"",
				"GROUP_ID=1013,BRAND_ID=2230hn,CONTRACT_NO=220400200023349058,LOGIN_NO=belong"+ 
				",LOGIN_ACCEPT=10000015546112,OP_TIME=20151513155930,OP_CODE=c201",
				"A1");
		
		String other = "USERCHG_REMARK=1234klj孔令杰12,LOGIN_NO=system,GROUP_ID=472,BRAND_ID=2230dn,LOGIN_ACCEPT=10000015546112,OP_TIME=20150919135801,OP_CODE=c201";
		byte[] param_b = null;
		String other_gbk = null;
		try {
			param_b = other.getBytes("GBK");
			other_gbk = new String(param_b, "GBK");
		} catch (Exception e) {
			e.printStackTrace();
		}
		log.debug("other="+other);
		log.debug("other_gbk="+other_gbk);
		
//		pubinter.CPP_opUserStatuInter(220410200017314175L, 
//				"13844495617", "1", "A", "0", "", "",
//				other_gbk,
//				"B1");
		
		//状态工单测试
//		pubinter.CPP_opPubOdrSndInter("10000000046620", "system", "C205", "10002", 
//				"1", "LOGIN_NO=system,OP_CODE=C205,LOGIN_ACCEPT=10000000076097,CREATE_TIME=20150717183826,BUSIID_NO=220200200001791005,REMARK=gotoa,ID_NO=220200200001791005,STOP_TIME=20150717183826"
//				, "A1");
		
		/*测试时注意：修改CONTACT_ID（是主键）值*/
//		pubinter.CPP_opArearStatuInter(220440200035020481L, 
//				"15981587016", "b", "1", 
//				"CONTRACT_NO=220440200035020482,LOGIN_NO=bossA,LOGIN_ACCEPT=1201507200003,BLACK_FLAG=1,OP_TIME=20150716095301,OP_CODE=FWKT",
//				"A1");
		/**
		Junits测试用例：
		Map<String, Object> inParamMap = new HashMap<String, Object>();
		inParamMap.put("PHONE_NO",   "13844468247");
		inParamMap.put("ID_NO",      "220400200001997000");
		inParamMap.put("CONTRACT_NO", "220400200001997001");
		inParamMap.put("GROUP_ID",   "1010");
		inParamMap.put("BRAND_ID",   "2230d0");
		inParamMap.put("RUN_CODE",   "A");
		inParamMap.put("OP_TIME",    "20150922103020");
		inParamMap.put("LOGIN_ACCEPT", "1000009220004");
		//inParamMap.put("CONTACT_ID", "1000008120021");//废弃
		inParamMap.put("LOGIN_NO",   "system");
		inParamMap.put("OP_CODE",    "c200");//信控：c200 
		inParamMap.put("OWNER_FLAG", "1");
		inParamMap.put("OPEN_FLAG",  "0");
		inParamMap.put("BLACK_FLAG",  "1");
		inParamMap.put("FYW_FLAG",  "");
		//Header设置
			Map<String, Object> headMap = new HashMap<String, Object>();
			headMap.put("DB_ID", "B1");
		inParamMap.put("HEADER", headMap);
		*/
	}
	
}
