package com.sitech.acctmgrint.atom.busi.intface.odrsplice;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgrint.atom.busi.intface.cfgcache.DataBaseCache;
import com.sitech.acctmgrint.atom.busi.intface.odrblob.OdrLineContDAO;
import com.sitech.acctmgrint.atom.busi.intface.odrblob.OdrLineContVO;
import com.sitech.acctmgrint.atom.busi.intface.sqldeal.ISqlDeal;
import com.sitech.acctmgrint.common.BaseBusi;
import com.sitech.acctmgrint.common.IntControl;
import com.sitech.acctmgrint.common.constant.InterBusiConst;
import com.sitech.jcf.ijdbc.SqlFind;
import com.sitech.jcf.json.JSONObject;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.util.DateUtil;

public class SpliceOrder extends BaseBusi implements ISpliceOrder {
	
	/*记录待发送工单的信息，信息完整后，转为JSON报文发送*/
	
	protected ISqlDeal       iSqlDeal;
	protected OdrLineContDAO odrLineContDAO;
	protected DataBaseCache  dataBaseCache;
	

	/**
	 * Title: 服务开通指令报文接口
	 * @param inParamMap
	 * @return 
	 */
	@SuppressWarnings("unchecked")
	@Override
	public boolean sendCommandJson(Map<String, Object> inPubDataMap) {
		
		String sRealRunCode = "";
		String sCheckStatus = "";
		String sOwnerFlag = "";
		long lIdNo = 0;
		String sIdNo = "";
		//String sSuffix = "";
		String sMainSvcId = "";
		String sSpmsFlag = "";
		String sSvcString = "";
		int sMainActionId = 0;
		String sPhoneNo = "";
		String sPhoneHead = "";
		String sFywFlag = "-1";
		
		List<Map<String, Object>> mainActionList = null;
		Map<String, Object> inMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		sIdNo = inPubDataMap.get("ID_NO").toString();
		lIdNo = Long.parseLong(sIdNo);
		//sSuffix = sIdNo.substring(sIdNo.length()-2, sIdNo.length());
		
		SqlFind inSqlFind = new SqlFind();
		Connection inConn = this.baseDao.getConnection();
		Map<String, Object> sqlMap = new HashMap<String, Object>();
		sqlMap.put("SQL_FIND", inSqlFind);
		sqlMap.put("SQL_CONNECT", inConn);
		
		/*向综合接口发送状态指令*/
		if (inPubDataMap.get("REAL_RUN_CODE") != null)
			sRealRunCode = inPubDataMap.get("REAL_RUN_CODE").toString();
		else 
			sRealRunCode = inPubDataMap.get("RUN_CODE").toString();

		sOwnerFlag = inPubDataMap.get("OWNER_FLAG").toString();

		/*有主*/
		if (sOwnerFlag.equals("1") || sOwnerFlag.equals("3")) {
			
			/*取用户主服务*/
			inMap.put("ID_NO", sIdNo);
			resultMap = (Map<String, Object>) baseDao.queryForObject("ur_usersvctrace_info_INT.qMainSvcIdByIdNo", inMap);
			if((resultMap == null) || (resultMap.size() == 0)){
				log.error("The MAINSVCID Doesn't exists,ID_NO = " + sIdNo);
				return false;
			}
			sMainSvcId = resultMap.get("MAIN_SVC_ID").toString();
			inPubDataMap.put("MAIN_SVC_ID", sMainSvcId);
			log.debug("sMainSvcId"+sMainSvcId);
			
			/*检查主服务是否发送服务开通*/
			resultMap = dataBaseCache.getDestTabCfgMap("IN_BSSVC_DICT", sMainSvcId);
			if (resultMap == null) {
				inMap.put("MAIN_SVC_ID", sMainSvcId);
				resultMap = new HashMap<String, Object>();
				resultMap = (Map<String, Object>) baseDao.queryForObject("in_bssvc_dict_INT.qSpmsFlagByMainSvcId", inMap);
			}
			sSpmsFlag = resultMap.get("SPMS_FLAG").toString();
			inPubDataMap.put("SPMS_FLAG",sSpmsFlag);
			if (!sSpmsFlag.equals("Y")) {
				log.error("The MAINSVCID Doesn't need to send COMMAND,the MainSvcId is " + sMainSvcId);
				return false;
			}
				
			/*根据新状态转换对应的服务动作list*/						
			mainActionList = dataBaseCache.getDestTabCfgList("IN_BSSTATUSTOACTION_REL", sRealRunCode+"#"+sMainSvcId);
			if (mainActionList == null) {
				inMap.put("MAIN_SVC_ID", sMainSvcId);
				inMap.put("CHECK_STATUS", sRealRunCode);
				
				if(inPubDataMap.get("IN_SVC_ACTION") != null){
					inMap.put("IN_SVC_ACTION", inPubDataMap.get("IN_SVC_ACTION").toString());
				}
				mainActionList = (List<Map<String, Object>>) baseDao.queryForList("in_bsstatustoaction_rel_INT.qMainSubActionBySvcIdStatus", inMap);
			}
			
			/*取用户、地市信息*/
			resultMap = new HashMap<String, Object>();
			resultMap = (Map<String, Object>)baseDao.queryForObject("ur_user_info_INT.qCustIdInfoByIdNo", inMap);
			inPubDataMap.putAll(resultMap);
			
			inMap.put("GROUP_ID", resultMap.get("GROUP_ID"));
			resultMap = new HashMap<String, Object>();
			resultMap = (Map<String, Object>)baseDao.queryForObject("bs_chngroup_rel_INT.qRegionCodeByGroupId", inMap);
			inPubDataMap.putAll(resultMap);
			
			
			
		} else { /*无主*/
			lIdNo = InterBusiConst.WZ_ID_NO;
			sMainSvcId = InterBusiConst.WZ_MAIN_SVC_ID;/*BSM0000000*/
			sMainActionId = InterBusiConst.WZ_MAIN_ACTION_ID;/*8905*/
		
			//sPhoneNo = inPubDataMap.get("PHONE_NO").toString();
			//sPhoneHead = sPhoneNo.substring(0, 7);
			//inMap.put("PHONE_HEAD", sPhoneHead);

			inPubDataMap.put("ID_NO", lIdNo);
			inPubDataMap.put("CONTRACT_NO", 0);
			inPubDataMap.put("MAIN_SVC_ID", sMainSvcId);
			inPubDataMap.put("MAIN_ACTION_ID", sMainActionId);
			inPubDataMap.put("SVC_OFFER_ID", sMainActionId);
			inPubDataMap.put("ROUTE_HOME_CITY", 0);
			inPubDataMap.put("REGION_ID", "");
			inPubDataMap.put("LOGIN_NO", "system");
			inPubDataMap.put("ORDER_PRIORITY", "9");
			inPubDataMap.put("USER_GROUP_ID", "12345");
			
			Map<String, Object> tempMap = new HashMap<String, Object>();
			tempMap.put("SVC_OFFER_ID", sMainActionId);
			tempMap.put("MAIN_ACTION_ID", sMainActionId);
			tempMap.put("SUB_ACTION_ID", "");
			tempMap.put("ORDER_PRIORITY", "9");
			mainActionList = new ArrayList<Map<String, Object>>();
			mainActionList.add(tempMap);

		}/*无主END*/
		
		//循环所有的主动作
		for (Map<String, Object> mainActionMap : mainActionList) {
			
			inPubDataMap.putAll(mainActionMap);
			
			//重新获取流水，不然多主服务下会索引冲突
			inPubDataMap.put("BS_LOGIN_ACCEPT", getInterLoginAccept("BS"));
			
			//判断一些特殊的主服务动作是否需要发送
			String sMainSvcIdTemp = inPubDataMap.get("MAIN_SVC_ID").toString();
			String sMainActionIdTemp = inPubDataMap.get("MAIN_ACTION_ID").toString();
			if((sMainSvcIdTemp.equals("BSM0000623")) && (sMainActionIdTemp.equals("11071"))){
				resultMap = (Map<String, Object>)baseDao.queryForObject("in_bsstatustoaction_rel_INT.qMainActionSendFlag", inMap);
				long cnt = Long.parseLong(resultMap.get("CNT").toString());
				if(cnt == 0){
					continue;
				}
			}
			
			/*根据配置表取得其他CUST信息*/
			sqlMap.put("PARAM_TYPE", "MULTI_MAP");
			getPrimParmInfo(inPubDataMap, sqlMap);
			
			
			//根据主服务主动作取得服开报文模板
			resultMap = new HashMap<String, Object>();
			resultMap = dataBaseCache.getDestTabCfgMap("IN_BSMODTABLE_REL",inPubDataMap.get("MAIN_ACTION_ID").toString()+"#"+sMainSvcId);
			if (resultMap == null || resultMap.size() == 0) {
				inMap.put("MAIN_SVC_ID", inPubDataMap.get("MAIN_SVC_ID"));
				inMap.put("MAIN_ACTION_ID", inPubDataMap.get("MAIN_ACTION_ID"));
				resultMap = (Map<String, Object>)baseDao.queryForObject("in_bsmodtable_rel_INT.qTableNameContentByMainSvcAction", inMap);
			}
			inPubDataMap.putAll(resultMap);
	
			/*根据配置模板生成服务开通报文*/
			sqlMap.put("PARAM_TYPE", "");
			MBean mbean = builtOrderContent(inPubDataMap, sqlMap);
			
			/*插入服务开通消息中间件*/
			operBsOrderInter(inPubDataMap, mbean);
		}
		
		return true;
	}
	
	private String getInterLoginAccept(String inHeadStr) {
		
		String sOutParamAccept = "";
		String sBcAcceptDate = "";
		String sBcSequenValue = "";
		String sAccceptHead = "";
		
		sAccceptHead = inHeadStr;

		sBcAcceptDate = DateUtil.format(new Date(),"yyyyMMddHHmmss");
/*		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("SEQ_NAME", "SEQ_INTERFACE_SN");
		Map<String, Object> result = new HashMap<String, Object>();
		result = (Map<String, Object>) baseDao.queryForObject("dual.qSequenceInter", inMap);*/
/*		sBcSequenValue = result.get("NEXTVAL").toString();*/
		sBcSequenValue = String.valueOf(IntControl.getSequence("SEQ_INTERFACE_SN"));
		if (sAccceptHead.equals("") || sBcAcceptDate.equals("") || sBcSequenValue.equals(""))
			return null;
		else 
			sOutParamAccept = sAccceptHead + sBcAcceptDate + sBcSequenValue;

		log.debug("------- getInterLoginAccept stt--sOutParamAccept="+sOutParamAccept);
		return sOutParamAccept;
	}
	
	private String getPrimParmInfo(Map<String, Object> inDataMap, Map<String, Object> inSqlMap) {
		
		String sRetCode = "";
		String sDbValue = "";
		String sPramName = "";
		String sPramExp = "";
		int iRetNum = 0;
		int iSrcType = 0;
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		Map<String, Object> inParaExpMap = null;
		Map<String, Object> outDBMap = null;
		
		log.debug("---------konglj test--getPrimParmInfo stt ---inMap="+inMap.toString());
		List<Map<String, Object>> resultList = dataBaseCache.getDestTabCfgList("IN_BSPRIPARM_DICT",
				inDataMap.get("MAIN_ACTION_ID")+"#"+inDataMap.get("MAIN_SVC_ID"));
		if (resultList == null) {
			inMap.put("MAIN_ACTION_ID", inDataMap.get("MAIN_ACTION_ID"));
			inMap.put("MAIN_SVC_ID", inDataMap.get("MAIN_SVC_ID"));
			resultList = (List<Map<String, Object>>)baseDao.queryForList("in_bspriparm_dict_INT.qPramInfoByMainSvcAction", inMap);
		}
		log.debug("---------konglj test--getPrimParmInfo 1 ---restmaip="+resultList.toString());
		for (Map<String, Object> resultMap : resultList) {
			
			sDbValue = "";
			inParaExpMap = new HashMap<String, Object>();
			outDBMap = new HashMap<String, Object>();

			sPramName = resultMap.get("PRAM_NAME").toString();
			sPramExp = resultMap.get("PRAM_EXP").toString();
			iRetNum = Integer.valueOf(resultMap.get("RET_NUM").toString());
			iSrcType = Integer.valueOf(resultMap.get("EXP_TYPE").toString());
			log.debug("------konglj test----sPramName=["+sPramName+"] itype="+iSrcType+" sexp="+sPramExp);
			switch(iSrcType) {
			case 0:
				//inDataMap.put(sPramName, sPramExp);
				break;
			case 2:
				inParaExpMap.put("DATA_EXP", sPramExp);
				inParaExpMap.put("RET_NUM", iRetNum);
				log.debug("getPripramdata stt-"+outDBMap.toString());
				outDBMap = iSqlDeal.getDBdataValue(inParaExpMap, inSqlMap, inDataMap);
				if (null == outDBMap) {
					log.debug("getPripramdata failed,please check!");
					return null;
				}
				log.debug("------konglj test----outDBMap="+outDBMap.toString());
				inDataMap.putAll(outDBMap);
				break;
			default:
				log.error("getPriPramdata failed. iSrcType=" + iSrcType);
			}
		
		}
		
		return sRetCode;
	}
	
	/**
	 * Title: 向服务开通消息中间件发送指令报文
	 * @param inParamMap
	 * @return
	 */
	private boolean operBsOrderInter(Map<String, Object> inDataMap, MBean mbean) {
		
		log.debug("------konglj test --operbsMsginput OrderInter----STT--inDataMap="+inDataMap.toString());
		int iLen = 0;
		int iSpiLen = 0;
		long lCreateAccept = 0L;
		String sLoginAccept = "";
		String sCrtActTmp = "";

		if (inDataMap.get("LOGIN_ACCEPT") != null) {
			sLoginAccept = inDataMap.get("LOGIN_ACCEPT").toString();
		} else {
			sLoginAccept = inDataMap.get("BS_LOGIN_ACCEPT").toString();
		}
			
		if (inDataMap.get("BS_LOGIN_ACCEPT") != null) {
			sCrtActTmp = inDataMap.get("BS_LOGIN_ACCEPT").toString();
		}
		
		String sOrderPriority = inDataMap.get("ORDER_PRIORITY").toString();
		String sTimeDalay = "";
		if(sOrderPriority.equals("9")){//默认值，无延迟
			sTimeDalay = "0";
		} else {
			if(sOrderPriority.charAt(0) == 'D'){ //天
				sTimeDalay = sOrderPriority.substring(1, sOrderPriority.length());
			}
			else if(sOrderPriority.charAt(0) == 'H'){//小时
				sTimeDalay = sOrderPriority.substring(1, sOrderPriority.length())+"/24";
			}
			else if(sOrderPriority.charAt(0) == 'M'){//分钟
				sTimeDalay = sOrderPriority.substring(1, sOrderPriority.length())+"/(24*60)";
			}
			else if(sOrderPriority.charAt(0) == 'S'){//秒
				sTimeDalay = sOrderPriority.substring(1, sOrderPriority.length())+"/(24*60*60)";
			}
			else{
				sTimeDalay = "0";
			}
		}
		
		iLen = sCrtActTmp.length();
		if (iLen >= 18)
			iSpiLen = 18;
		else
			iSpiLen = iLen;
		lCreateAccept = Long.parseLong(sCrtActTmp.substring(iLen - iSpiLen, iLen));
		String sIdNo = inDataMap.get("ID_NO").toString();
		//String sTabSuffix = inDataMap.get("ODR_SAVE_CODE").toString();
		
		String sTopicId  = "";
		if(inDataMap.get("MAIN_SVC_ID").toString().equals("BSM0000002") &&
			inDataMap.get("MAIN_ACTION_ID").toString().equals("8904"))
		{
			sTopicId = InterBusiConst.FWKT_TOPIC_ID+"GW";
		}
		else{
			sTopicId = InterBusiConst.FWKT_TOPIC_ID;
		}

		log.debug("----beanlength--mbean.toString().len="+mbean.toString().length());
		if (mbean.toString().length() > InterBusiConst.LEN_MIDMSG) {
			List<MBean> list_mb = disasOrder(mbean, InterBusiConst.FWKT_ODR_SUBKEY, InterBusiConst.LEN_MIDMSG);
			if (list_mb == null) {
				log.error("根据指定的Key值无法拆解,key="+mbean.toString().length());
			} else {
				for (int i = 0; i < list_mb.size(); i ++) {
					MBean tmp_mb = list_mb.get(i);
					long tmp_ca = lCreateAccept + i - 100000;
					
					//替换流水值
					MBean final_mb = new MBean(tmp_mb.toString().replace(String.valueOf(lCreateAccept), String.valueOf(tmp_ca)));
					
					byte[] byte_cont = null;
					try {
						byte_cont = final_mb.toString().getBytes("GBK");
					} catch (UnsupportedEncodingException e) {
						e.printStackTrace();
					}
					
					OdrLineContVO odrLineContVO = new OdrLineContVO();
					//odrLineContVO.setGsTableSuffix(sTabSuffix);
					odrLineContVO.setGsTopicId(sTopicId);
					odrLineContVO.setGbContent(byte_cont);
					odrLineContVO.setGsBusiidType(InterBusiConst.BUSIID_TYPE_IDNO);
					odrLineContVO.setGsBusiidNo(sIdNo);
					odrLineContVO.setGsDataSrc(InterBusiConst.FWKT_DATA_SRC);
					odrLineContVO.setGsOpCode(inDataMap.get("OP_CODE").toString());
					odrLineContVO.setGsLoginNo(inDataMap.get("LOGIN_NO").toString());
					odrLineContVO.setGlCreatAct(tmp_ca);
					odrLineContVO.setGsLoginAct(sLoginAccept);
					odrLineContVO.setGsTimeDelay(sTimeDalay); 
					odrLineContDAO.insertOdrLineCont(odrLineContVO);
				}
			}
			
		} else {
		
			byte[] byte_cont = null;
			try {
				byte_cont = mbean.toString().getBytes("GBK");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			
			OdrLineContVO odrLineContVO = new OdrLineContVO();
			//odrLineContVO.setGsTableSuffix(sTabSuffix);
			odrLineContVO.setGsTopicId(sTopicId);
			odrLineContVO.setGbContent(byte_cont);
			odrLineContVO.setGsBusiidType(InterBusiConst.BUSIID_TYPE_IDNO);
			odrLineContVO.setGsBusiidNo(sIdNo);
			odrLineContVO.setGsDataSrc(InterBusiConst.FWKT_DATA_SRC);
			odrLineContVO.setGsOpCode(inDataMap.get("OP_CODE").toString());
			odrLineContVO.setGsLoginNo(inDataMap.get("LOGIN_NO").toString());
			odrLineContVO.setGlCreatAct(lCreateAccept);
			odrLineContVO.setGsLoginAct(sLoginAccept);
			odrLineContVO.setGsTimeDelay(sTimeDalay); 
			odrLineContDAO.insertOdrLineCont(odrLineContVO);
		}

		log.debug("------konglj test --operbsMsginput OrderInter----over");
		return true;

	}
	
	/**
	 * 拆解超过指定长度的报文
	 * @Note 根据报文中指定的List_key拆解
	 * @param in_bean
	 * @param list_key
	 * @param max_length
	 * @return
	 */
	public List<MBean> disasOrder(MBean in_bean, String in_list_key, int max_length) {
		
		//返回List大小为1，则说明不需要拆解
		List<MBean> list_mb = new ArrayList<MBean>();
		if (in_bean != null && in_bean.toString().length() <= max_length) {
			list_mb.add(in_bean);
			return list_mb;
		}
		
		List<Map> list_keys = (List<Map>) in_bean.getBodyList(in_list_key);
		if (list_keys == null || list_keys.size() <= 1) {
			//根据指定的Key值无法拆解
			log.error("根据指定的Key值无法拆解,key="+in_list_key);
			return null;
		}
		
		List list_tmp = new ArrayList();;
		MBean tmp_mb = null;
		JSONObject tmp_js = null;
		
		MBean copy_mb = new MBean(in_bean.toString());
		copy_mb.setBody(in_list_key, list_tmp);
		log.debug("max_length="+max_length+"copy_mb.length="+copy_mb.toString().length()+copy_mb.toString());

		int copy_len = copy_mb.toString().length() + in_list_key.length() + 6;
		if (max_length > copy_len) {
			int remain_len = max_length - copy_len;
			int tmp_rm_len = remain_len;
			for (int i = 0; i < list_keys.size(); i++) {
				
				tmp_js = new JSONObject();
				tmp_js.putAll(list_keys.get(i));
				String[] str_arr = tmp_js.toString().split(InterBusiConst.FWKT_CLS_NAME);
				int js_len = tmp_js.toString().length() - (str_arr.length-1)*InterBusiConst.FWKT_CLS_NAME.length();
				log.debug("----forsize---"+remain_len+" "+list_keys.size()+" "+tmp_rm_len+" "+js_len);
				
				if (tmp_rm_len > js_len) {
					tmp_rm_len -= js_len;
					list_tmp.add(list_keys.get(i));
					if (list_keys.size() == i + 1) {
						tmp_mb = new MBean(copy_mb.toString());
						tmp_mb.setBody(in_list_key, list_tmp);
						list_mb.add(tmp_mb);						
					}
				} else {
					tmp_mb = new MBean(copy_mb.toString());
					tmp_mb.setBody(in_list_key, list_tmp);
					list_mb.add(tmp_mb);
					
					list_tmp = new ArrayList();
					list_tmp.clear();
					tmp_rm_len = remain_len;
				}
			}
		} else {
			log.error("根据指定的Key值长度，无法拆解,key="+in_list_key);
			return null;
		}
		
		return list_mb;
	}
	
	private MBean builtOrderContent(Map<String, Object> inDataMap, Map<String, Object> inSqlMap) {
		
		String sOrderCont = "";
		Map<String, Object> mapTmpPart = new HashMap<String, Object>();
		Map<String, Object> mapOrderPart = new HashMap<String, Object>();
		log.debug("----------konglj test--buildordercontent stt---");
		log.debug("----------konglj test--inDataMap="+inDataMap);
		log.debug("----------konglj test--inSqlMap="+inSqlMap);
		
		sOrderCont = inDataMap.get("TEMPLATE_CONTENT").toString();

		MBean gmOrderData = new MBean(sOrderCont);
		
		
		/*1.生成HEADER*/
		if (inDataMap.get("HEADER") != null) {
			mapTmpPart = (Map<String, Object>) inDataMap.get("HEADER");
		} else {
			mapTmpPart = gmOrderData.getHeader();
			buildOrderHeaderPart(inDataMap, mapTmpPart, inSqlMap);
		}
		gmOrderData.setHeader(mapTmpPart);
		log.debug("----------konglj test--buildordercontent 22-getHeader()="+gmOrderData.getHeader().toString());
		
		/*2.生成BODY.OssOrder*/
		mapOrderPart = (Map<String, Object>) gmOrderData.getBody().get("OssOrder");
		
		
		mapTmpPart = new HashMap<String, Object>();
		mapTmpPart = (Map<String, Object>) mapOrderPart.get("OssOrderInfo");
		buildOrderBasePart(inDataMap, mapTmpPart, inSqlMap);
		mapOrderPart.put("OssOrderInfo", mapTmpPart);
		log.debug("----------konglj test--buildordercontent 32-mapTmpPart="+mapTmpPart.toString());
		
		/*3.生成工单主服务部分--OssOrder.mainSvc*/
		mapTmpPart = new HashMap<String, Object>();
		mapTmpPart = (Map<String, Object>) mapOrderPart.get("mainSvc");
		buildJsonOrderSvcPart(mapTmpPart, "M", inSqlMap, inDataMap);
		mapOrderPart.put("mainSvc", mapTmpPart);
		log.debug("----------konglj test--buildordercontent 42-mapTmpPart="+mapTmpPart.toString());

		
		/*4.生成工单附加服务部分--OssOrder.Svc*/
		List<Map<String, Object>> lstMaps = new ArrayList<Map<String,Object>>();
		mapTmpPart = (Map<String, Object>) mapOrderPart.get("Svc");
		lstMaps = buildJsonOrderSvcPart(mapTmpPart, "O", inSqlMap, inDataMap);
		mapOrderPart.put("Svc", lstMaps);
		log.debug("----------konglj test--buildordercontent 52-mapTmpPart="+lstMaps.toString());
		
		/*5.生成其他节点，如果模板里配置了*/
		//OssOrder.AddrInfo
		mapTmpPart = (Map<String, Object>) mapOrderPart.get("AddrInfo");
		if(mapTmpPart != null){
			buildJsonOrderSvcPart(mapTmpPart, "A", inSqlMap, inDataMap);
			mapOrderPart.put("AddrInfo", mapTmpPart);
		}
		
		//OssOrder.CustInfo
		mapTmpPart = (Map<String, Object>) mapOrderPart.get("CustInfo");
		if(mapTmpPart != null){
			buildJsonOrderSvcPart(mapTmpPart, "C", inSqlMap, inDataMap);
			mapOrderPart.put("CustInfo", mapTmpPart);
		}

		gmOrderData.setBody("OssOrder", mapOrderPart);
		log.debug("----------konglj test--buildordercontent END-gmOrderData="+gmOrderData.toString());

		return gmOrderData;
	}
	
	/**
	 * Title 替换模板中Header部分参数值
	 * @param mapOrderPart
	 * @param inSqlMap
	 * @return mapOrderPart
	 */
	private MBean buildOrderHeaderPart(Map<String, Object> inPubDataMap, Map<String, Object> mapOrderPart, Map<String, Object> inSqlMap) {
		
		int iDollarIndex1 = 0;
		int iDollarIndex2 = 0;
		String sHeadOrder = "";
		String sDataSrcId = "";
		String sKey = ""; 
		String sValue = "";
		String sDataValue = "";
		Map<String, Object> tmpOdrPrt = new HashMap<String, Object>();
		
		sHeadOrder = mapOrderPart.toString();
		log.debug("---------buildorderHeaderpart stt----sHeader="+sHeadOrder);
		/*JSON root部分赋值*/
		for (Map.Entry<String, Object> entry : mapOrderPart.entrySet()) {

			sKey = entry.getKey().toString();
			sValue = entry.getValue().toString();
			if (sKey.equals("ROUTING")) {
				Map<String, Object> tmpMap = new HashMap<String, Object>();
				tmpMap = (Map<String, Object>) entry.getValue();
				//回归调用
				buildOrderHeaderPart(inPubDataMap, tmpMap, inSqlMap);
				
				//替换inMapBasePart值
				tmpOdrPrt.put(sKey, tmpMap);
				continue;
			}
			
			/*处理模板sValue值，获取真实值*/
			if (sValue.charAt(0) == '$') {
				sDataSrcId = subStrDollar(sValue);
				
				/*取得datasourceid值*/
				int cClasify = sDataSrcId.charAt(0);
				/*处理处理'${POOL_ID}$'类变量*/
				if ((cClasify >= 'A' && cClasify <= 'Z') 
						|| (cClasify >= 'a' && cClasify <= 'z')) {
					
					if (inPubDataMap.get(sDataSrcId.toUpperCase()) != null)
						sDataValue = inPubDataMap.get(sDataSrcId).toString();
					else
						sDataValue = "";//NULL
				} else if (cClasify >= '0' && cClasify <= '9') {
					sDataValue = "";
					sDataValue = iSqlDeal.getDataValueBySourceId(inPubDataMap, sDataSrcId, inSqlMap);
				}
			} else if (sValue.charAt(0) != '$') {
				sDataValue = sValue;
			}
			tmpOdrPrt.put(sKey, sDataValue);
			log.debug("-----------while buildorderHeaderpartskey=="+sKey+" vale="+tmpOdrPrt.get(sKey).toString());
		}/*while entry END*/
		mapOrderPart.clear();
		mapOrderPart.putAll(tmpOdrPrt);
		log.debug("-----------while buildorderHeaderpartskmapOrderPart END="+mapOrderPart.toString());
		
		return null;
	}
	
	private MBean buildOrderBasePart(Map<String, Object> inPubData, Map<String, Object> mapBasePart, Map<String, Object> inSqlMap) {
		
		int iSharpIndex = 0;
		int iDollarIndex1 = 0;
		int iDollarIndex2 = 0;
		String sXmlOrder = "";
		String sHeadOrder = "";
		String sTailOrder = "";
		String sDataSrcId = "";
		String sKey = ""; 
		String sValue = "";
		String sDataValue = "";
		Map<String, Object> outMapTmp = new HashMap<String, Object>();
		
		sHeadOrder = mapBasePart.toString();
		log.debug("---------buildOrderBasePart stt----sHeader="+sHeadOrder);
		/*JSON root部分赋值*/
		for (Map.Entry<String, Object> entry : mapBasePart.entrySet()) {  

			sKey = entry.getKey().toString();
			sValue = entry.getValue().toString();
			log.debug("------------konglj test -- while sKey="+sKey+" sValue="+sValue);
			
			/*处理模板sValue值，获取真实值*/
			sDataSrcId = getParaNameByMod(sValue, "$", 2, 2);
			if (null == sDataSrcId)
				continue;
			
			/*取得datasourceid值*/
			int cClasify = sDataSrcId.charAt(0);
			/*处理处理'${POOL_ID}$'类变量*/
			if (cClasify >= 'A' && cClasify <= 'Z') {
				
				if (inPubData.get(sDataSrcId) != null)
					sDataValue = inPubData.get(sDataSrcId).toString();
				else
					sDataValue = "NULL";
				log.debug("------------koglj test---issDataValue=["+sDataValue+"]");

			} else if (cClasify >= '0' && cClasify <= '9') {
				sDataValue = "";
				sDataValue = iSqlDeal.getDataValueBySourceId(inPubData, sDataSrcId, inSqlMap);
				log.debug("----------konglj test--getDataValueBySourceId --sdavalue="+sDataValue);

			}/*数字型处理 END*/
			log.debug("-----------while skey111=="+sKey+" vale="+sDataValue );
			outMapTmp.put(sKey, sDataValue);
		}/*while entry END*/
		mapBasePart.clear();
		mapBasePart.putAll(outMapTmp);
		
		return null;
	}
	
	private static String subStrDollar(String inParaString) {
		String outString = "";
		int iDollarIndex1 = inParaString.indexOf('$');
		if(-1 == iDollarIndex1) {
			return inParaString;
		}
		int iDollarIndex2 = inParaString.indexOf('$', iDollarIndex1 + 1);
		if (0 < iDollarIndex2 - iDollarIndex1) {
			/*例如：${MAIN_SVC_ID}$，去除${和}$，即前两位后两位*/
			outString = inParaString.substring(iDollarIndex1 + 2, iDollarIndex2 - 1);
		} else {
			return inParaString;
		}
		
		return outString.trim();
	}
	
	public String getParaNameByMod(String inModPara, String inJudge, int indexHead, int indexTail) {
		int iDollarIndex1 = 0;
		int iDollarIndex2 = 0;
		String outParaName = "";
		
		/*处理模板sValue值，获取真实值*/
		iDollarIndex1 = inModPara.indexOf(inJudge);
		if(-1 == iDollarIndex1) {
			log.debug("getParaNameByMod,This VALUE is the real value,doesnot need to get its val!");
			return null;
		}
		iDollarIndex2 = inModPara.indexOf(inJudge, iDollarIndex1 + 1);
		if (0 < iDollarIndex2 - iDollarIndex1) {
			outParaName = inModPara.substring(iDollarIndex1 + indexHead, iDollarIndex2 - indexTail + 1);
		}
		
		return outParaName;
	}
	
	private List<Map<String, Object>> buildJsonOrderSvcPart(Map<String, Object> inSvcMap, String inSvcType,
			Map<String, Object> inSqlMap, Map<String, Object> inPubData) {
			
		if (inSvcType.equals("M")) {//处理主服务部分	
			
			//获取主服务的所有参数值
			Map<String, Object> inSvcPrptyMap = new HashMap<String, Object>();
			inSvcPrptyMap.put("SVC_ID", inPubData.get("MAIN_SVC_ID"));
			inSvcPrptyMap.put("SVC_TYPE", "M");			
			inSvcPrptyMap.put("MAIN_ACTION_ID", inPubData.get("MAIN_ACTION_ID"));

			List<Map<String, Object>> lstMainNodes = new ArrayList<Map<String,Object>>();
			log.debug("-------fwkt--inSvcPrptyMap"+inSvcPrptyMap.toString());
			lstMainNodes = iSqlDeal.getSvcAttrBySvcIdAndActionId(inSvcPrptyMap, inSqlMap, inPubData);
			if (lstMainNodes.size() == 0) {
				log.debug("Montage the MainSvcId prpty data failed,please check!");
			}
			
			/*设置主服务参数报文*/
			Map<String, Object> outSvcMapTmp = new HashMap<String, Object>();
			outSvcMapTmp.put(InterBusiConst.FWKT_ODR_MSVCID, inPubData.get("MAIN_SVC_ID").toString());
			outSvcMapTmp.put(InterBusiConst.FWKT_ODR_MSVCACT, "A");//写死传A
			outSvcMapTmp.put(InterBusiConst.FWKT_ODR_MSVCPTY, lstMainNodes);
			inSvcMap.clear();
			inSvcMap.putAll(outSvcMapTmp);
			log.debug("-----------konglj test-mainsvcodr-outsvcMap="+outSvcMapTmp.toString());
		} 
		else if (inSvcType.equals("O")) {//处理附加服务部分		
			List<Map<String, Object>>  lstSubMaps = new ArrayList<Map<String,Object>>();
			
			/*取得所有附加服务list*/
			List<Map<String, String>> resultList = null;
			Map<String, Object> inMap = new HashMap<String, Object>();
			
			long lIdNo = Long.parseLong(inPubData.get("ID_NO").toString());
			inMap.put("ID_NO", lIdNo);
			if (inPubData.get("MAIN_ACTION_ID").toString().equals("8907")){ //对某个附加服务单独发服开
				
				String subActionId = inPubData.get("SUB_ACTION_ID").toString();
				if(subActionId.equals("K")) inPubData.put("MAIN_ACTION_ID", "8901");
				else if(subActionId.equals("R")) inPubData.put("MAIN_ACTION_ID", "8904");
				else inPubData.put("MAIN_ACTION_ID", "8903");
				
				inMap.put("SUB_ACTION_ID", inPubData.get("SUB_ACTION_ID").toString());
				inMap.put("SVC_STR",inPubData.get("IN_SVC_ID").toString());				
				resultList = baseDao.queryForList("ur_usersvctrace_info_INT.qFywSvcIdByIdNo", inMap);

			} else {
				inMap.put("SUB_ACTION_ID", inPubData.get("SUB_ACTION_ID").toString());
				inMap.put("OLD_NEW_RUN", inPubData.get("OLD_NEW_RUN").toString());	
				inMap.put("MAIN_SVC_ID", inPubData.get("MAIN_SVC_ID").toString());
				resultList = baseDao.queryForList("ur_usersvctrace_info_INT.qSvcIdByIdNo", inMap);
			}
			inMap.put("SUB_SVC_TYPE", inPubData.get("SUB_ACTION_ID").toString());
			
			/**** add by zhangleij 20170315 增加查询结果为空判断及错误日志输出 begin ****/
//			if (resultList == null || resultList.size() == 0) {
//				log.debug("Deal other data is null,please check ur_usersvctrace_info_INT.qSvcIdByIdNo! inMap=" + inMap.toString());
//				return null;
//			}
			/**** add by zhangleij 20170315 增加查询结果为空判断及错误日志输出 end ****/
			
			//循环每个附加服务
			for (Map<String, String> rstMapSvc : resultList) {
				log.debug("---------buildsubsvc --for --rstMapSvc="+rstMapSvc.toString());
				String sSvcId = rstMapSvc.get("SVC_ID");
				inPubData.put("SUB_SVC_ID", sSvcId);
				
				Map<String, Object> inSvcPrptyMap = new HashMap<String, Object>();
				inSvcPrptyMap.put("MAIN_ACTION_ID", inPubData.get("MAIN_ACTION_ID"));
				inSvcPrptyMap.put("SVC_TYPE", "O");
				inSvcPrptyMap.put("SVC_ID", sSvcId);
				
				//获取附件服务的所有参数值
				List<Map<String, Object>> lSubNode  = new ArrayList<Map<String,Object>>();
				lSubNode = iSqlDeal.getSvcAttrBySvcIdAndActionId(inSvcPrptyMap, inSqlMap, inPubData);
				if (null == lSubNode) {
					log.debug("Montage the SubSvcId prpty data failed,please check!");
					return null;
				}
				
				//拼接输出节点
				String subActionId = inPubData.get("SUB_ACTION_ID").toString();
				if((subActionId.equals("M")) || (subActionId.equals("N"))){//服务开通等部门未配置M N动作
					subActionId = "T";
				}
				Map<String, Object> svcPrptyNodeMap = new HashMap<String, Object>();
				svcPrptyNodeMap.put(InterBusiConst.FWKT_ODR_OSVCID,  sSvcId);
				svcPrptyNodeMap.put(InterBusiConst.FWKT_ODR_OSVCACT, subActionId);
				svcPrptyNodeMap.put(InterBusiConst.FWKT_ODR_OSVCPTY, lSubNode);
				log.debug("-----------subsvcodr-----svcPrptyNodeMap="+svcPrptyNodeMap.toString());
				lstSubMaps.add(svcPrptyNodeMap);
				
			}
			return lstSubMaps;
			
		} else  { //处理其他类型节点
			//根据类型值，取出所有参数和参数值
			Map<String, Object> inSvcPrptyMap = new HashMap<String, Object>();
			inSvcPrptyMap.put("SVC_ID", inPubData.get("MAIN_SVC_ID"));
			inSvcPrptyMap.put("SVC_TYPE", inSvcType);			
			inSvcPrptyMap.put("MAIN_ACTION_ID", inPubData.get("MAIN_ACTION_ID"));

			Map<String, Object> otherNodes = iSqlDeal.getOtherNodeParam(inSvcPrptyMap, inSqlMap, inPubData);
			
			/*设置节点参数报文*/
			inSvcMap.clear();
			inSvcMap.putAll(otherNodes);
		}
		
//		/*无主停机用户处理*/
//		if (InterBusiConst.WZ_ID_NO == lIdNo) {
//			lstSubMaps = new ArrayList<Map<String,Object>>();
//			
//			inSvcPrptyMap.put("SVC_ID", InterBusiConst.WZ_MAIN_SVC_ID);
//			inSvcPrptyMap.put("MAIN_ACTION_ID", inPubData.get("MAIN_ACTION_ID"));			
//			inSvcPrptyMap.put("SVC_PRPTY_NODE", (Map<String, Object>)outSvcMapTmp.get("SvcPrptys"));
//			List<Map<String, Object>> lSubNode = iSqlDeal.getSvcAttrBySvcIdAndActionId(inSvcPrptyMap, inSqlMap, inPubData);
//			if (null == lSubNode) {
//				log.debug("Montage the WZSubSvcId prpty data failed,please check!");
//				return null;
//			}
////			outSvcMapTmp.put(InterBusiConst.FWKT_ODR_OSVCPTY, lSubNode);
////			outSvcMapTmp.put(InterBusiConst.FWKT_ODR_OSVCID,  InterBusiConst.WZ_SUB_SVC_ID);
////			outSvcMapTmp.put(InterBusiConst.FWKT_ODR_OSVCACT, inPubData.get("SUB_ACTION_ID"));
//			lstSubMaps.add(outSvcMapTmp);
//		}
		
		return null;
	}

	public ISqlDeal getiSqlDeal() {
		return iSqlDeal;
	}

	public void setiSqlDeal(ISqlDeal iSqlDeal) {
		this.iSqlDeal = iSqlDeal;
	}

	public OdrLineContDAO getOdrLineContDAO() {
		return odrLineContDAO;
	}

	public void setOdrLineContDAO(OdrLineContDAO odrLineContDAO) {
		this.odrLineContDAO = odrLineContDAO;
	}

	public DataBaseCache getDataBaseCache() {
		return dataBaseCache;
	}

	public void setDataBaseCache(DataBaseCache dataBaseCache) {
		this.dataBaseCache = dataBaseCache;
	}
	
}