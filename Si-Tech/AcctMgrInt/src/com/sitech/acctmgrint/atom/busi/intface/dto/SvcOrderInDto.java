package com.sitech.acctmgrint.atom.busi.intface.dto;

import com.sitech.acctmgrint.common.constant.InterBusiConst;
import com.sitech.jcfx.dt.MBean;
import org.eclipse.jetty.util.log.Log;

import java.util.HashMap;
import java.util.Map;

public class SvcOrderInDto {
	
	/**
	 * Title: BOSS-》CRM参数校验
	 * @param sInJson:（暂定）同步CRM工单中参数拼成的JSON报文 ，格式：[工单代码,OwnerFlag:1(2/3/4),工单参数按顺序写入(PHONE_NO:xxx)]
	 * @param sLoginAccept:统一流水 
	 * @param sLoginNo:操作工号 
	 * @param sOpCode:操作标识
	 * @return Exception
	 */
	public MBean BcOrderInSynDto(String inParam) {
		
		if (null == inParam)
			return null;
		
		MBean mInParam = new MBean(inParam);

		String sStringData = mInParam.getBodyStr("STIRNG_DATA");
		String sLoginAccept = mInParam.getBodyStr("LOGIN_ACCEPT");
		String sLoginNo = mInParam.getBodyStr("LOGIN_NO");
		String sOpCode = mInParam.getBodyStr("OP_CODE");
		
		if (null == sStringData || null == sLoginAccept || null == sLoginNo || null == sOpCode) {
			System.out.println("Some required Params are missing,please check!");
			return null;
		}

		//1.校验传入参数和需要的参数是否一致；
		//2.校验是否传入了OP_CODE,记录数据源；
		//3.补充其他信息，如服务开通流水等；
		//  建议格式：【工单模板号,OP_CODE=xxxx,顺序写入模板参数值】
		//4.录入MBean参数。
		
		return mInParam;
	}
	
	/**
	 * Title:状态变更及指令发送接口参数校验
	 * @param inParam: Map参数：
	 * @param LOGIN_ACCEPT:统一流水 ，必传
	 * @param LOGIN_NO:操作工号 ，必传
	 * @param OP_CODE:操作标识，必传
	 * @param OPEN_FLAG:服务开通标识，必传
	 *                  0--只服务开通  1--只更改用户状态  2--即开通又更改用户状态
	 * @param FYW_FLAG:分业务停开机标识：
	 *                 0:暂停SVC 1:恢复SVC 2:单停GPRS 3:单停WLAN 4:单停WIFI 5:4G
	 * @param SVC_STR:需要停开的服务串，格式（待定）[B01001|B01002]
	 * @param CONTRACT_NO:账号ID，分业务停开机必传
	 * @return inParamMap 整理STIRNG_DATA参数值:状态变更中参数拼成的map，必传
	 *                    {ORDER_ID:工单代码,OWNER_FLAG:1(2/3/4),工单参数按顺序写入(PHONE_NO:xxx)} 
	 */
	public Map<String, Object> getUserChgDto(Map<String, Object> inParamMap) {
		
		if (null == inParamMap)
			return null;
		Log.info("------konglj test--getUserChgDto stt--inparamMap="+inParamMap.toString());
		
		String sPhoneNo = inParamMap.get("PHONE_NO").toString();
		String sLoginNo = inParamMap.get("LOGIN_NO").toString();
		String sOpCode = inParamMap.get("OP_CODE").toString();
		String sOpenFlag = inParamMap.get("OPEN_FLAG").toString();
		long lIdNo = Long.valueOf(inParamMap.get("ID_NO").toString());

		/*String sSvcStr = inParamMap.put("SVC_STR").toString();
		String sFywFlag = inParamMap.put("FYW_FLAG").toString();
		String sContractNo = inParamMap.put("CONTRACT_NO").toString();*/
		Log.info("------konglj test--getUserChgDto 2--sLoginNo="+sLoginNo);

		if (null == sPhoneNo || null == sLoginNo || null == sOpCode || null == sOpenFlag) {
			System.out.println("Some required Params are missing,please check!");
			return null;
		}
		if (!(sOpenFlag.equals("0") || sOpenFlag.equals("1") || sOpenFlag.equals("2"))) {
			System.out.println("The Value of OPEN_FLAG is Error,its value only could be 0 or 1 or 2.");
			return null;
		}
		Log.info("------konglj test--getUserChgDto 3--sOpenFlag="+sOpenFlag);
		
		if (inParamMap.get("FYW_FLAG") == null)
			inParamMap.put("FYW_FLAG", "-1");
		
		Map<String, Object> strDataTmp = new HashMap<String, Object>();
		
		if (InterBusiConst.WZ_ID_NO == lIdNo) {
			inParamMap.put("ORDER_ID", "10023");
			inParamMap.put("OWNER_FLAG", "2");
			strDataTmp.put("CHG_REASON", "No Owner User's FWKT .");
		} else {
			inParamMap.put("ORDER_ID", "10000");
			inParamMap.put("OWNER_FLAG", "1");
			strDataTmp.put("CHG_REASON", "Normal User's FWKT .");
		}
		strDataTmp.put("ID_NO", inParamMap.get("ID_NO"));
		strDataTmp.put("PHONE_NO", inParamMap.get("PHONE_NO"));
		strDataTmp.put("NEW_STATUS", inParamMap.get("RUN_CODE"));
		strDataTmp.put("CHG_TIME", inParamMap.get("OP_TIME"));
		strDataTmp.put("EFF_DATE", inParamMap.get("OP_TIME"));
		inParamMap.put("STRING_DATA", strDataTmp);

		Log.info("------konglj test--getUserChgDto strDataTmp="+strDataTmp.toString());
		
		return inParamMap;
	}

}
