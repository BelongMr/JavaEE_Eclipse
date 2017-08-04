package com.sitech.acctmgrint.atom.busi.intface;

import com.sitech.acctmgrint.atom.busi.intface.odrblob.OdrLineContDAO;
import com.sitech.acctmgrint.atom.busi.intface.odrblob.OdrLineContVO;
import com.sitech.acctmgrint.atom.busi.intface.odrsplice.ISpliceOrder;
import com.sitech.acctmgrint.atom.busi.intface.sqldeal.ISqlDeal;
import com.sitech.acctmgrint.common.AcctMgrError;
import com.sitech.acctmgrint.common.BaseBusi;
import com.sitech.acctmgrint.common.IntControl;
import com.sitech.acctmgrint.common.constant.InterBusiConst;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.util.DateUtil;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * <p>Title: 服务开通公共函数</p>
 * <p>Description: 服务开通公共函数，提供统一流水创建、BC入表操作等</p>
 * <p>Copyright: Copyright (c) 2006</p>
 * <p>Company: SI-TECH </p>
 * @author KONGLJ
 * @version 1.0
 */
public class PubInterComm extends BaseBusi {
	
	protected ISqlDeal       iSqlDeal;
	protected ISpliceOrder   iSpliceOrder;
	protected OdrLineContDAO odrLineContDAO;
	protected SvcOdrParaTrans svcOdrParaTrans;

	public ISpliceOrder getiSpliceOrder() {
		return iSpliceOrder;
	}

	public void setiSpliceOrder(ISpliceOrder iSpliceOrder) {
		this.iSpliceOrder = iSpliceOrder;
	}

	public ISqlDeal getiSqlDeal() {
		return iSqlDeal;
	}

	public void setiSqlDeal(ISqlDeal iSqlDeal) {
		this.iSqlDeal = iSqlDeal;
	}

	public SvcOdrParaTrans getSvcOdrParaTrans() {
		return svcOdrParaTrans;
	}

	public void setSvcOdrParaTrans(SvcOdrParaTrans svcOdrParaTrans) {
		this.svcOdrParaTrans = svcOdrParaTrans;
	}

	public OdrLineContDAO getOdrLineContDAO() {
		return odrLineContDAO;
	}

	public void setOdrLineContDAO(OdrLineContDAO odrLineContDAO) {
		this.odrLineContDAO = odrLineContDAO;
	}
	
	//////////////////////////服务开通方法/////////////////////////

	
	/**
	 * Title: 获取流水接口
	 * @param inParamMbean
	 * @return 返回创建的服务开通统一流水
	 * @throws Exception
	 */
	protected String getInterLoginAccept(String inHeadStr) {
		
		String sOutParamAccept = "";
		String sBcAcceptDate = "";
		String sBcSequenValue = "";
		String sAccceptHead = "";
		
		sAccceptHead = switchLogHeadByRun(inHeadStr);

		sBcAcceptDate = DateUtil.format(new Date(),"yyyyMMddHHmmss");
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("SEQ_NAME", "SEQ_INTERFACE_SN");
		Map<String, Object> result = new HashMap<String, Object>();
/*		result = (Map<String, Object>) baseDao.queryForObject("dual.qSequenceInter", inMap);
		sBcSequenValue = result.get("NEXTVAL").toString();*/
		sBcSequenValue = String.valueOf(IntControl.getSequence("SEQ_INTERFACE_SN"));
		if(sBcSequenValue.length() == 5){
		    sBcSequenValue="0" + sBcSequenValue;
		}else if(sBcSequenValue.length() == 4)
	          sBcSequenValue="00" + sBcSequenValue;
		else if(sBcSequenValue.length() == 3)
            sBcSequenValue="000" + sBcSequenValue;
		else if(sBcSequenValue.length() == 2)
            sBcSequenValue="0000" + sBcSequenValue;
		else if(sBcSequenValue.length() == 1)
            sBcSequenValue="00000" + sBcSequenValue;
		log.error("---wangxind----=" + sBcSequenValue);

		if (sAccceptHead.equals("") || sBcAcceptDate.equals("") || sBcSequenValue.equals(""))
			return null;
		else 
			sOutParamAccept = sAccceptHead + sBcAcceptDate + sBcSequenValue;

		log.debug("------- getInterLoginAccept stt--sOutParamAccept="+sOutParamAccept);
		return sOutParamAccept;
	}
	
	/**
	 * Title: 变更用户状态服务开通内部方法
	 * @param inParamMap
	 * @return RET_CODE
	 */
	protected boolean updateUserStatus(Map<String, Object> gParamMap) {
		
		log.debug("-------updateUserStatus stt---");
		long lIdNo = Long.parseLong(gParamMap.get("ID_NO").toString());
		String sBossNewRun = gParamMap.get("RUN_CODE").toString();
		String sRealRunCode = "";
		String sCrmRunCode = "";
		String sLoginAccept = "";
		String sCurRunCode = "";

		Map<String, Object> inMap = new HashMap<String, Object>();
		/*取得合成后状态*/
		inMap.put("BOSS_NEW_RUN", sBossNewRun);
		inMap.put("ID_NO", lIdNo);
		
		sRealRunCode = ((String) gParamMap.get("REAL_RUN_CODE")).trim();
		sCrmRunCode = ((String) gParamMap.get("CRM_RUN_CODE")).trim();

		log.debug("-------updateUserStatus 3---la"+gParamMap.toString());

		/*将合成前的用户状态移入历史表ur_bosstocrmstate_his*/
		sLoginAccept = gParamMap.get("BC_LOGIN_ACCEPT").toString();
		inMap.put("OPT_SN",   sLoginAccept);
		inMap.put("LOGIN_NO", gParamMap.get("LOGIN_NO"));
		inMap.put("REMARK",   "用户状态业务工单");
		//inMap.put("MM",     DateUtil.format(new Date(), "MM"));
		baseDao.insert("ur_bosstocrmstate_his_INT.iBossToCrmMmByIdNo", inMap);
				
		/*更新UR_BOSSTOCRMSTATE_INFO表*/
		inMap.put("OPT_CODE", 		gParamMap.get("OP_CODE"));
		inMap.put("REAL_RUN_CODE", 	sRealRunCode);
		inMap.put("RUN_CODE", 		gParamMap.get("RUN_CODE"));
		inMap.put("BOSS_NEW_TIME", 	gParamMap.get("OP_TIME"));
		
		/*crm_run_code为'9'时, 需要同时更新crm_run_code和boss_run_code为'A' @20150517*/
		if (sCrmRunCode.equals("9"))
			baseDao.update("ur_bosstocrmstate_INT.uTwoRunCodeByCrmRunCode", inMap);
		else
			baseDao.update("ur_bosstocrmstate_INT.uBossToCrmStateByIdNo", inMap);

		/*销户或局拆，将合成后的状态入历史*/
		if (sRealRunCode.equals("a") || sRealRunCode.equals("b")) {
			inMap.put("REMARK", "欠费销户业务工单");
			baseDao.insert("ur_bosstocrmstate_his_INT.iBossToCrmMmByIdNo", inMap);
		}
		
		sCurRunCode = gParamMap.get("CUR_RUN_CODE").toString();

		if (sCurRunCode.equals(sRealRunCode)) {
			inMap.put("OLD_RUN_TIME", gParamMap.get("CUR_RUN_TIME"));
			int i = baseDao.update("cs_userdetail_info_INT.uRunCodeByIdNo", inMap);
		} else {
			baseDao.update("cs_userdetail_info_INT.uRunCodeByIdNo", inMap);
		}
		
		/*记录CS_USERDETAIL_INFO_AI/BICHG两个小表  @20150806*/
		opIntUserChg(lIdNo);
		
		/*记录UR_USERCHG_INFO状态变更记录表    @20150806*/
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("TOTAL_DATE", gParamMap.get("OP_TIME").toString().substring(0, 8));
		inMapTmp.put("PAY_SN", gParamMap.get("LOGIN_ACCEPT"));
		inMapTmp.put("ID_NO", lIdNo);
		inMapTmp.put("CONTRACT_NO", (gParamMap.get("CONTRACT_NO")==null)?0:(Long.parseLong(gParamMap.get("CONTRACT_NO").toString())));
		inMapTmp.put("GROUP_ID", (gParamMap.get("GROUP_ID")==null)?0:gParamMap.get("GROUP_ID"));
		inMapTmp.put("BRAND_ID", (gParamMap.get("BRAND_ID")==null)?0:gParamMap.get("BRAND_ID"));
		inMapTmp.put("PHONE_NO", gParamMap.get("PHONE_NO"));
		inMapTmp.put("OLD_RUN", sCurRunCode);
		inMapTmp.put("RUN_CODE", sRealRunCode);
		inMapTmp.put("OP_CODE", gParamMap.get("OP_CODE"));
		inMapTmp.put("LOGIN_NO", gParamMap.get("LOGIN_NO"));
		inMapTmp.put("LOGIN_GROUP", gParamMap.get("LOGIN_GROUP")!=null?gParamMap.get("LOGIN_GROUP").toString():"");
		inMapTmp.put("REMARK", gParamMap.get("USERCHG_REMARK")!=null?gParamMap.get("USERCHG_REMARK").toString():"");
		baseDao.insert("bal_userchg_recd_INT.iUserchgYm",inMapTmp);
		
		log.debug("-------updateUserStatus END---sCurRunCode="+sCurRunCode);
		
		return true;
	}
	
	public void opIntUserChg(long id_no) {
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		String mmdd = DateUtil.format(new Date(), "MMdd").toString();

		//取得流水
		Map<String, Object> tmpMap = new HashMap<String, Object>();		
		tmpMap.put("SEQ_NAME", "SEQ_INT_DEAL_FLAG");
		Map<String, Object> result = null;
/*		result = (Map<String, Object>) baseDao.queryForObject("dual_INT.qSequenceInter", tmpMap);
		String sIntSequenValue1 = result.get("NEXTVAL").toString()+mmdd;*/
		String sIntSequenValue1 = String.valueOf(IntControl.getSequence("SEQ_INT_DEAL_FLAG")) + mmdd;
/*		result = (Map<String, Object>) baseDao.queryForObject("dual_INT.qSequenceInter", tmpMap);
		String sIntSequenValue2 = result.get("NEXTVAL").toString()+mmdd;*/
		String sIntSequenValue2 = String.valueOf(IntControl.getSequence("SEQ_INT_DEAL_FLAG")) + mmdd;
		
		/*将变更信息写入CS_USERDETAIL_INFO_BICHG#CS_USERDETAIL_INFO_ACCHG小表*/
		/**** update by zhangleij 20170306 修改状态变更后同步账务和计费的小表模型 begin ****/
		inMap.put("ID_NO", id_no);
		//inMap.put("OP_FLAG", 2);//更新
		inMap.put("TAB_TAIL", "ACCHG");
		//inMap.put("SEQ_NO", sIntSequenValue1);
		inMap.put("GET_TYPE", 2);				// 操作类型 1 新增 2 变更 3 删除
		inMap.put("GET_NO", sIntSequenValue1);	// BOSS接收数据流水
		baseDao.insert("cs_userdetail_info_chg_INT.insert", inMap);
		inMap.put("TAB_TAIL", "BICHG");
		//inMap.put("SEQ_NO", sIntSequenValue2);
		inMap.put("GET_NO", sIntSequenValue2);	// BOSS接收数据流水
		baseDao.insert("cs_userdetail_info_chg_INT.insert", inMap);
		/**** update by zhangleij 20170306 修改状态变更后同步账务和计费的小表模型 end ****/
		
	}
	
	/**
	 * Title: 向CRM发送同步状态消息
	 * Description: 插入消息发送接口表
	 * @param inParamMap
	 * @return 
	 */
	protected boolean sendBcOrderMsg(Map<String, Object> inParam) {
				
		/*向CRM发送同步业务消息*/
		log.debug("------ OrderInter----STT--inParam="+inParam.toString());
		long lCreateAccept = 0L;
		String sLoginAccept = "";
		
		//自定义流水，如缴费流水等，若没有则使用自动生成的BC流水
		if (inParam.get("LOGIN_ACCEPT") != null) {
			sLoginAccept = inParam.get("LOGIN_ACCEPT").toString();
		} else {
			sLoginAccept = inParam.get("BC_LOGIN_ACCEPT").toString();
		}
		
		//统一流水
		lCreateAccept = getCreateAccept(inParam, sLoginAccept);
		log.debug("----sLoginAccept="+sLoginAccept);
		log.debug("----lCreateAct="+lCreateAccept);
		
		byte[] byte_cont = null;
		try {
			byte_cont = inParam.get("CONTENT").toString().getBytes("GBK");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		OdrLineContVO odrLineContVO = new OdrLineContVO();
		//odrLineContVO.setGsTableSuffix(inParam.get("SUFFIX").toString());
		odrLineContVO.setGsTopicId(    inParam.get("TOPIC_ID").toString());
		odrLineContVO.setGbContent(    byte_cont);
		odrLineContVO.setGsBusiidType( inParam.get("BUSIID_TYPE").toString());
		odrLineContVO.setGsBusiidNo(   inParam.get("BUSIID_NO").toString());
		odrLineContVO.setGsDataSrc(    inParam.get("DATA_SRC").toString());
		odrLineContVO.setGsOpCode(     inParam.get("OP_CODE").toString());
		odrLineContVO.setGsLoginNo(    inParam.get("LOGIN_NO").toString());
		odrLineContVO.setGlCreatAct(   lCreateAccept);
		odrLineContVO.setGsLoginAct(   sLoginAccept);
		odrLineContDAO.insertOdrLineCont(odrLineContVO);
		
		log.debug("----operbsMsginput OrderInter----over");
		return true;
		
	}
	
	private long getCreateAccept(Map<String, Object> inParam, String login_accept) {

		log.debug("-----getCreateAccept stt--login_accept="+login_accept+"inParam="+inParam.toString());
		long lCreateAccept = 0L;
		String tmpString = "";
		if (inParam.get("BC_LOGIN_ACCEPT") != null && !inParam.get("BC_LOGIN_ACCEPT").equals("")) {
			tmpString = inParam.get("BC_LOGIN_ACCEPT").toString();
		} else if (inParam.get("CREATE_ACCEPT") != null && !inParam.get("CREATE_ACCEPT").equals("")) {
			tmpString = inParam.get("CREATE_ACCEPT").toString();
		} else {
			tmpString = login_accept;
		}
		if (!tmpString.equals("")){
			int iLen = 0;
			//使用自动生成的流水
			int iStrLen = tmpString.length();
			if (iStrLen < 18)
				iLen = iStrLen;
			else 
				iLen = 18;
			//截取长度最大为18位
			lCreateAccept = Long.parseLong(
					tmpString.substring(iStrLen - iLen, iStrLen));
		}
		return lCreateAccept;
	}
	
	
	private String switchLogHeadByRun(String inStr) {

		if (inStr.length() == 2)
			return inStr; //BC BS
		
		if (inStr.equals("A"))
			return "KJ";
		if (inStr.equals("C"))
			return "DT";
		if (inStr.equals("B") || inStr.equals("D"))
			return "QT";
		if (inStr.equals("b") || inStr.equals("J"))
			return "CJ";
		
		return "BS";
	}
	
	
	protected Map<String, Object> getBcParamExchg(Map<String, Object> inMap) {
		
		String sOrderId = "";
		String sContactId = "";
		String sCheckStatus = "";
		String sBusiidNo = "";
		String sLoginAcceptTemp = "";
		MBean TempBean = null;
		Map<String, Object> bcTmpMap = new HashMap<String, Object>();
		Map<String, Object> outBcMap = new HashMap<String, Object>();
		log.debug("----getparmExchgstt--inMap="+inMap.toString());
		
		//暂时保存业务流水
		sLoginAcceptTemp = inMap.get("LOGIN_ACCEPT").toString();
		inMap.put("LOGIN_ACCEPT", inMap.get("CREATE_ACCEPT").toString().substring(4, 22));
		
		outBcMap.putAll(inMap);
		
		//取得参数
		if (inMap.get("ORDER_ID") == null) {
			log.debug("----some para is null, please check.");
			return null;
		}
		sOrderId = inMap.get("ORDER_ID").toString();

		//取得CONTACT_ID
		/*if (inOdrBean.getHeaderStr("CONTACT_ID") != null) {
			sContactId = inOdrBean.getHeaderStr("CONTACT_ID");
		} else if (inOdrBean.getBodyStr("CONTACT_ID") != null) {
			sContactId = inOdrBean.getBodyStr("CONTACT_ID");
		} else {
			sContactId = "";
		}
		outBcMap.put("CREATE_ACCEPT", sContactId);*/
				
		/*取得BUSIID_TYPE*/
		if (inMap.get("BUSIID_NO") != null)
			sBusiidNo = inMap.get("BUSIID_NO").toString();
		else {
			sBusiidNo = inMap.get("ID_NO").toString();
			//得到BUSIID_NO
			outBcMap.put("BUSIID_NO", sBusiidNo);
		}
		if (sBusiidNo.length() == InterBusiConst.LENGTH_IDNO) {
			outBcMap.put("BUSIID_TYPE", InterBusiConst.BUSIID_TYPE_IDNO);
		} else if (sBusiidNo.length() == InterBusiConst.LENGTH_PHONENO) {
			outBcMap.put("BUSIID_TYPE", InterBusiConst.BUSIID_TYPE_PHONENO);
		} else
			outBcMap.put("BUSIID_TYPE", InterBusiConst.BUSIID_TYPE_OTHER);
		log.debug("---getparamExchg 3-sOrderId=["+sOrderId+"]");

		//bcTmpMap = addUnderLineToParaName(bcTmpMap);
		
		/*取模板及是否检查标识*/
		bcTmpMap = new HashMap<String, Object>();
		bcTmpMap = getBcBusiTemp(sOrderId);
		sCheckStatus = bcTmpMap.get("CHECK_STATUS").toString();
		
		MBean inOdrBean = null;
		
		//查看是否检查参数
		if (sCheckStatus.equalsIgnoreCase("Y")) {
			TempBean = new MBean(bcTmpMap.get("BUSI_TEMPLATE").toString());
			bcTmpMap.remove("BUSI_TEMPLATE");
			outBcMap.putAll(bcTmpMap);

			/*检查模板参数,并替换参数*/
			inOdrBean = replaceBcBeanPara(TempBean, inMap);
			if (inOdrBean == null) {
				log.error("---------check param error------");
				return null;
			}
		} else {
			inOdrBean = new MBean(inMap.get("ODR_CONT").toString());
			inMap.remove("ODR_CONT");
			if (inMap.size() != 0)
				outBcMap.putAll(inMap);
			
			//判断Header,至少需要DB_ID
			if (null == inOdrBean.getHeader()) {
				log.debug("-------nOdrBean.getHeader()is null. inOdrBean=" +inOdrBean.toString() );
				return null;
			}
		}

		outBcMap.put("TOPIC_ID", bcTmpMap.get("TOPIC_ID"));
		outBcMap.put("DATA_SRC", bcTmpMap.get("ORDER_TYPE"));
			
		outBcMap.put("CONTENT", inOdrBean);
		
		//恢复业务流水
		inMap.put("LOGIN_ACCEPT", sLoginAcceptTemp);
		outBcMap.put("LOGIN_ACCEPT", sLoginAcceptTemp);
		
		
		log.debug("--------exchgparam---outBcmap="+outBcMap.toString());
		return outBcMap;
	}
	
	/*private Map<String, Object> addUnderLineToParaName(Map<String, Object> inMap) {
		Map<String, Object> outMap = new HashMap<String, Object>();
		if (inMap.get("PHONE_NO") != null) 
			outMap.put("PHONE_NO", inMap.get("PHONE_NO"));
		else if (inMap.get("PHONENO") != null) 
			outMap.put("PHONE_NO", inMap.get("PHONENO"));
		
		if (inMap.get("ID_NO") != null) {
			outMap.put("ID_NO", inMap.get("ID_NO"));
		} else if (inMap.get("IDNO") != null) {
			outMap.put("ID_NO", inMap.get("IDNO"));
		}
		if (inMap.get("CONTRACTNO") != null) {
			inMap.put("CONTRACT_NO", inMap.get("CONTRACTNO"));
			inMap.remove("CONTRACTNO");
		}
		
		if (outMap.size() != 0)
			return outMap;
		
		return null;
	}*/

	private Map<String, Object> getBcBusiTemp(String inOrderId) {
		
		Map<String, Object> rstOrderTemMap = new HashMap<String, Object>();
		rstOrderTemMap.put("ORDER_ID", inOrderId);
		return (Map<String, Object>)baseDao.queryForObject("in_bcbusiorder_dict_INT.qOrderInfo", rstOrderTemMap);
	}
	
	/**
	 * 
	 * @param inModBean
	 * @param outBcMap
	 * @return 报文Json格式
	 */
	public MBean replaceBcBeanPara(MBean inModBean, Map<String, Object> inBcDataMap) {
		
		if (inModBean.getBody() == null)
			return null;
		MBean inOdrBean = new MBean();
		Map<String, Object> tmpMap = null;
		log.debug("----replacebcbeanpara---stt---indatamap="+inBcDataMap.toString());
		/*Check Header*/
		if (inBcDataMap.get("HEADER") != null) {
			inOdrBean.setHeader((Map<String, Object>) inBcDataMap.get("HEADER"));
			log.debug("debug-----header:"+inOdrBean.getHeader());
		} else {
			/*Check Header*/
			tmpMap = transModToData(inModBean.getHeader(), inBcDataMap);
			if (tmpMap != null && tmpMap.size() != 0)
				inOdrBean.setHeader(tmpMap);
			else
				return null;
		}
			
		/*Check Body*/
		tmpMap = transModToData(inModBean.getBody(), inBcDataMap);
		if (tmpMap != null && tmpMap.size() != 0)
			inOdrBean.setBody(tmpMap);
		else
			return null;
		
		return inOdrBean;
	}
	
	public Map<String, Object> transModToData(Map<String, Object> inMod, Map<String, Object> inValMap) {
		
		String sKey = "";
		Object oValue;
		String sParaName = "";
		Map<String, Object> keyMap = null;
		Map<String, Object> tmpMap = null;
		Map<String, Object> outMap = new HashMap<String, Object>();
		log.debug("--------transcheckdata stt----inValMap="+inValMap.toString());
		
		if (inMod == null || inMod.size() == 0) {
			return null;
		}
		outMap.putAll(inMod);
		
		for (Map.Entry<String, Object> entry : inMod.entrySet()) {

			sKey = entry.getKey().toString();
			oValue = entry.getValue();
			
			String[] strArr = oValue.toString().split(":");
			if (strArr.length > 1) {
				keyMap = (Map<String, Object>)oValue;
				//递归调用检查
				tmpMap = transModToData(keyMap, inValMap);
				if (tmpMap == null) {
					log.error("---keyMap=["+keyMap+"]\n,inValMap="+inValMap);
					return null;
				}
				outMap.put(sKey, tmpMap);
			} else {
				log.debug("----forentry----sKey=["+sKey+"],sValue="+oValue);
				sParaName = iSpliceOrder.getParaNameByMod(oValue.toString(), "$", 2, 2);
				if (sParaName == null) {
					continue;
				} else {
					if (inValMap.get(sParaName) == null) {
						log.error("---invalmap.["+sParaName+"]=null,please check!");
						return null;
					} else {
						outMap.put(sKey, inValMap.get(sParaName));
					}
				}
			}
		}
		log.debug("----transcheckdata end----outMap="+outMap.toString());		
		return outMap;
	}
	
	protected boolean sendBcUserStatOdr(Map<String, Object> inGParamMap) {
		
		Map<String, Object> bcStatMap = new HashMap<String, Object>();
		log.debug("--------sendUserStatOdr stt--");
		
		bcStatMap = getBcParamExchg((Map<String, Object>) inGParamMap.get("BTOC"));
		if (bcStatMap == null || bcStatMap.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode(
					inGParamMap.get("OP_CODE").toString(), "12034"), "param ex failed!");
		}
		log.debug("--------sendUserStatOdr s22--bcStatMap="+bcStatMap.toString());
		
		////3.插入消息中间件
		bcStatMap.put("DATA_SRC", "BUSI");
		bcStatMap.put("OP_CODE", inGParamMap.get("OP_CODE"));
		if (this.sendBcOrderMsg(bcStatMap) == false)
			throw new BusiException(AcctMgrError.getErrorCode(
					bcStatMap.get("OP_CODE").toString(), "12033"), "Boss->crm同步失败，fwkt插入接口表失败！");
		
		log.debug("--------sendUserStatOdr send---");
		return true;
	}
	
	protected boolean sendContactOdr(Map<String, Object> inGParamMap) {
		
		Map<String, Object> bcStatMap = new HashMap<String, Object>();
		log.debug("--------sendContactOdr stt--");
		
		bcStatMap = getBcParamExchg((Map<String, Object>) inGParamMap.get("BTOCONTACT"));
		if (bcStatMap == null || bcStatMap.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode(
					inGParamMap.get("OP_CODE").toString(), "12034"), "param ex failed!");
		}
		log.debug("--------sendContactOdr s22--bcStatMap="+bcStatMap.toString());
		
		////3.插入消息中间件
		bcStatMap.put("DATA_SRC", "BUSI");
		bcStatMap.put("OP_CODE", inGParamMap.get("OP_CODE"));
		if (this.sendBcOrderMsg(bcStatMap) == false)
			throw new BusiException(AcctMgrError.getErrorCode(
					bcStatMap.get("OP_CODE").toString(), "12033"), "Boss->crm同步失败，fwkt插入接口表失败！");
		
		log.debug("--------sendContactOdr send---");
		return true;
	}
	
}
