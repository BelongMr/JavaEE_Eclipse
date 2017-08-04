package com.sitech.acctmgr.test.atom.busi.inter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;

import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.acctmgrint.atom.busi.intface.IDataSyn;
import com.sitech.jcf.json.JSONObject;
import com.sitech.jcfx.context.JCFContext;
import com.sitech.jcfx.dt.MBean;

public class DataOdrSendTest extends BaseTestCase {

	@Test
	public void testBossDataSyn() {
		
		log.info("-----------konglj test dataSyn stt---------");
		//Get BEAN
		IDataSyn iDataSyn = (IDataSyn) JCFContext.getBean("DataSynEnt");

		
		/**
		 * @Title BOSS库数据同步接口
		 * @Description 1.Boss库向其他库同步数据 业务接口(入接口表发送，可回退)，以一次业务操作为单位调用接口。
		 * 				2.注意，此接口 不检查 待同步表的索引参数列，请知晓。
		 * @param inBusiBean.Header         必传，调用侧透传(记录大区信息、路由、鹰眼流水等)
		 * @param inBusiBean.Body.ACTION_ID 必传，业务标识(String类型，如缴费业务：1001)
		 * @param inBusiBean.Body.LOGIN_SN  必传，统一流水或业务流水(String)
		 * @param inBusiBean.Body.OP_CODE   必传，操作标识(String)
		 * @param inBusiBean.Body.LOGIN_NO  必传，操作编号(String)
		 * @param inBusiBean.Body.KEYS_LIST 必传，按照action_id对应的表操作顺序，依次记录待同步表的主键信息，顺序需相同，请注意。
		 * 						  			(List型，存储Map参数 (Map中，TABLE_NAME(大写)/UPDATE_TYPE(大写,D:delete I:insert U:update),
		 * 										key:大写，同步表唯一、联合索引字段名称   value：对应索引字段值))
		 * @author KONGLJ
		 * @date   2015/04/24
		 * @return
		 */
		//测试另一个接口
//		List<Map<String, Object>> listDataKeys = new ArrayList<Map<String, Object>>();
//		Map<String, Object> tmpdata = null;
//		//Delete
//		tmpdata = new HashMap<String, Object>();
//		tmpdata.put("TABLE_NAME", "UR_USER_INFO");
//		tmpdata.put("UPDATE_TYPE", "D");
//		tmpdata.put("ID_NO", "220420200019276202");
//		listDataKeys.add(tmpdata);
//		//Insert
//		tmpdata = new HashMap<String, Object>();
//		tmpdata.put("TABLE_NAME", "UR_USER_INFO");
//		tmpdata.put("UPDATE_TYPE", "I");
//		tmpdata.put("ID_NO", "220420200019276202");
//		listDataKeys.add(tmpdata);
//
//		MBean inBusiBean = new MBean();
//		inBusiBean.addBody("ACTION_ID", "9999");//测试action_id
//		inBusiBean.addBody("LOGIN_SN", "999900001");
//		inBusiBean.addBody("OP_CODE", "cesh");
//		inBusiBean.addBody("LOGIN_NO", "ceshi");
//		inBusiBean.addBody("KEYS_LIST", listDataKeys);
		
		String in = "{\"ROOT\":{\"BODY\":{\"ACTION_ID\":\"1001\",\"CHECK_KEY\":true,\"LOGIN_SN\":\"10000006407653\",\"OP_CODE\":\"0\",\"LOGIN_NO\":\"daCV00\",\"KEYS_LIST\":[{\"TABLE_NAME\":\"BAL_PAYMENT_INFO\",\"ID_NO\":0,\"PAY_TYPE\":\"0\",\"PAY_SN\":10000006406867,\"UPDATE_TYPE\":\"U\",\"CONTRACT_NO\":220400200029453037,\"YEAR_MONTH\":\"201509\"},{\"TABLE_NAME\":\"BAL_PAYMENT_INFO\",\"ID_NO\":0,\"PAY_TYPE\":\"0\",\"PAY_SN\":10000006407653,\"UPDATE_TYPE\":\"I\",\"CONTRACT_NO\":220400200029453037,\"YEAR_MONTH\":\"201509\"},{\"TABLE_NAME\":\"BAL_PAYMENT_INFO\",\"ID_NO\":220490200028576914,\"PAY_TYPE\":\"0\",\"PAY_SN\":10000006406867,\"UPDATE_TYPE\":\"U\",\"CONTRACT_NO\":220490200028576915,\"YEAR_MONTH\":\"201509\"},{\"TABLE_NAME\":\"BAL_PAYMENT_INFO\",\"ID_NO\":220490200028576914,\"PAY_TYPE\":\"0\",\"PAY_SN\":10000006407653,\"UPDATE_TYPE\":\"I\",\"CONTRACT_NO\":220490200028576915,\"YEAR_MONTH\":\"201509\"}]}}}";
		MBean inin = new MBean(in);
		//for (int i = 0; i < 100; i++)
			iDataSyn.sendBusiDataInter(inin);
		
//		/**
//		 * @param inBean.Body.ACTION_ID 必传，业务标识(String类型，如缴费业务：1001)
//		 * @param inBean.Body.CHECK_KEY 必传，是否校验是否包含全部索引值(boolean)
//		 * @param inBean.Body.KEY_DATA  必传，记录所有待同步表的所有主键信息(Map型，key:大写，同步表唯一、联合索引字段名称   value：对应索引字段值)
//		 * @param inBean.Body.LOGIN_SN  必传，统一流水或业务流水(String)
//		 * @param inBean.Body.OP_CODE   必传，操作标识(String)
//		 * @param inBean.Body.LOGIN_NO  必传，操作编号(String)
//		 */
//		//Header透传，修改鹰眼流水
//		MBean inBean = new MBean();
//		Map<String, Object> header = new HashMap<String, Object>();
//		Map<String, Object> inParamMap = new HashMap<String, Object>();
//		inParamMap.put("ID_NO",      "220110200052999181");
//		inBean.setHeader(header );
//		inBean.addBody("ACTION_ID", "1000");//测试action_id
//		inBean.addBody("CHECK_KEY", true);
//		inBean.addBody("LOGIN_SN", "1000000");
//		inBean.addBody("OP_CODE", "cesh");
//		inBean.addBody("LOGIN_NO", "ceshi");
//		inBean.addBody("KEY_DATA", inParamMap);
//		try {
//			//iDataSyn.sendSynInter(inBean);
//			//测试DataSynEnt, 无法提交，故查询不到数据。
//
//		} catch (Exception e) {
//			log.info("-catchexception-e="+e.getMessage()+e.toString());
//		}
		
		
		/**************************List 遍历****************************/
//		List<String> list = new ArrayList<String>();
//	    // 插入元素
//	    list.add("list1");
//	    list.add("list2");
//	    list.add("list3");
//	 
//	    System.out.println("第一种遍历方法 - >");
//	    for (String str : list) {
//	        System.out.println(str);
//	    }
//	 
//	    System.out.println("第二种遍历方法 - >");
//	    for (int i = 0; i < list.size(); i++) {
//	        System.out.println(list.get(i));
//	    }
//	 
//	    System.out.println("第三种遍历方法 - >");
//	    Iterator<String> iter = list.iterator();
//	    while (iter.hasNext()) {
//	        System.out.println(iter.next());
//	    }
		
		log.info("-----------konglj test datasyn end---------");

	}

}
