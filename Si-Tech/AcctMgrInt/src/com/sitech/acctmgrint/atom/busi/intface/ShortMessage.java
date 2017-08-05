package com.sitech.acctmgrint.atom.busi.intface;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import com.sitech.acctmgrint.atom.busi.intface.cfgcache.DataBaseCache;
import com.sitech.acctmgrint.atom.busi.intface.cfgcache.DataBaseConst;
import com.sitech.acctmgrint.atom.busi.intface.comm.Comm;
import com.sitech.acctmgrint.common.AcctMgrError;
import com.sitech.acctmgrint.common.BaseBusi;
import com.sitech.acctmgrint.common.IntControl;
import com.sitech.acctmgrint.common.constant.InterBusiConst;
import com.sitech.acctmgrint.common.utils.ValueUtils;
import com.sitech.crmpd.idmm2.client.MessageContext;
import com.sitech.crmpd.idmm2.client.api.Message;
import com.sitech.crmpd.idmm2.client.api.PropertyOption;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcf.json.JSONObject;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.util.DateUtil;

import org.apache.commons.pool2.KeyedObjectPool;

import java.util.*;

public class ShortMessage extends BaseBusi implements IShortMessage {
	
	protected DataBaseCache dataBaseCache;
	private	  IntControl		control;
	
	/**
	 * 名称：发送短信接口，短信等级,默认中级
	* @param inParam MBean
	* @param  Header:
	* @param	TRACE_ID	必传，端到端流水
	* @param	PARENT_CALL_ID	非必传，端到端流水
	* @param  Body:
	* @param	TEMPLATE_ID 短信模板,必传
	* @param	PHONE_NO    服务号码,必传
	* @param	SEND_TIME	发送时间(YYYYMMDDHH24MISS)，非必传，默认当前时间
	* @param	LOGIN_NO	登陆工号，必传
	* @param	OP_CODE     操作代码，非必传
	* @param    SEND_FLAG   是否发送标示，非必传，默认0 (0:发送 1:插入短信接口临时表)
	* @param	DATA.XXX    模板中需要替换的参数列Map,必传
	* @return true/false
	* @throws Exception
	 */
	public Boolean sendSmsMsg(MBean inParam) {
		//默认中级，默认为0
		return this.sendSmsMsg(inParam, 0);
	}
	
	/**
	 * 名称：发送短信接口
	* @param inLevel 短信等级,默认0，中级
	* 				 (1=高，2=中，3=低，4=群发，5=测试，非必传，默认中级，默认为0)
	* @param inParam MBean类型,包含下列参数：
	* @param	Header:端到端流水，鹰眼系统
	* @param	TRACE_ID		需要新生成
	* @param	PARENT_CALL_ID	上端的TRACE_ID
	* @param	Body:
	* @param	TEMPLATE_ID 短信模板,必传
	* @param	PHONE_NO    服务号码,必传
	* @param	CHECK_FLAG  是否检查替换参数,必传(BOOLEAN:true or false)
	* @param	SEND_TIME	发送时间(YYYYMMDDHH24MISS)，非必传，默认当前时间
	* @param    SEND_SEQ    发送流水，非必传
	* @param	LOGIN_NO	登陆工号，非必传
	* @param	OP_CODE     操作代码，非必传
	* @param    SEND_FLAG   是否发送标示，非必传，默认0 (0:发送 1:插入短信接口错误表)
	* @param	DATA.XXX    模板中需要替换的参数列Map,必传
	* @return true/false
	* @不抛异常 0001:模板异常 0002:参数异常 0003:其他 0004:发送异常 1111:send_flag=1
	 */
	public Boolean sendSmsMsg(MBean inParam, int inLevel) {
		
		String err_code = "0000";
		String err_msg = "";
		
		int iSendFlag = 0;//默认
		String sContent = "";
		String sRealCont = "";
		log.debug("--开始发送短信--inParam="+inParam.toString());
		
		long template_id = Long.parseLong(inParam.getBodyStr("TEMPLATE_ID"));
		String phone_no = inParam.getBodyObject("PHONE_NO").toString();
		
		log.debug("--开始发送短信--inParam phone_no ="+inParam.getBodyObject("PHONE_NO").toString());
		
		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;
		
		String sysType = "BACKGROUND";
		if(inParam.getBodyObject("SYS_TYPE") == null)
		{
			sysType = "BEFOREGROUND";
		}
		else
		{
			sysType = inParam.getBodyObject("SYS_TYPE").toString();
		}
		String isBackFlg = "N";
		// 从pub_codedef_dict表中获取前台短信转后台下发短信的标志IS_BACK_FLAG的值，code_class=3013
		inMapTmp = new HashMap<String, Object>();
		safeAddToMap(inMapTmp, "CODE_CLASS", "3013");
		outMapTmp = (Map<String, Object>) baseDao.queryForObject("pub_codedef_dict_INT.qVision",inMapTmp);
		if (outMapTmp == null) {
			log.error("pub_codedef_dict表中缺少前台短信转后台下发标识配置");
			isBackFlg = "N";
		}
		else
		{
			isBackFlg = outMapTmp.get("CODE_VALUE").toString(); 
		}
		log.info("isBackFlg:"+isBackFlg);
		
		
		if(sysType.equals("BEFOREGROUND") && isBackFlg.equals("Y") )
		{
				
			log.debug("--HAHA来自前台，不发短信信--inParam="+inParam.toString());
			
			Map<String, Object> result = this.getTemMap(template_id);
			sContent = result.get("CONTENT").toString();
			Map<String, Object> inDataMap = new HashMap<String, Object>();
			inDataMap = (Map<String,Object>) inParam.getBodyObject("DATA");
			result.put("CONTENT", inDataMap);
			MBean mbean = getJsonMsgByTemplate(inParam, result);
			if (0 == inLevel && result.get("PRIORITY_LEVEL") != null)
				inLevel = Integer.valueOf(result.get("PRIORITY_LEVEL").toString());
			Map<String, Object> topMap = getTopic(inLevel);
			String topic = topMap.get("TOPIC").toString();
			
			String seq_no = result.get("SYSTIME").toString()+result.get("NEXTVAL").toString();
			Map<String, Object> tmp_map = new HashMap<String, Object>();
			tmp_map.put("SEQ_NO", seq_no);
			tmp_map.put("PHONE_NO", phone_no);
			tmp_map.put("TEMPLATE_ID", template_id);
			tmp_map.put("SMS_NAME", result.get("SERV_NAME"));
			tmp_map.put("LOGIN_NO", result.get("LOGIN_NO"));
			tmp_map.put("CONTENT", mbean.toString()); //Comm.utfToGbk() IBATIS自动转换 20151110
			tmp_map.put("TOPIC_ID", topic);
			tmp_map.put("SEND_RESULT", "N");
			tmp_map.put("RESEND", "N");
			tmp_map.put("REMARK", "前台业务来的短信");
			baseDao.insert("in_btoamsgsend_info_INT.insert", tmp_map);
		}
		else if(!isBackFlg.equals("Y")||sysType.equals("BACKGROUND"))
		{	
			//1.根据id查询短信模板是否正确	
			Map<String, Object> result = this.getTemMap(template_id);
			sContent = result.get("CONTENT").toString();
			
			//校验内容是否正确，替换短信参数,直接拼成短信内容
			String outErrMsg = "";
			Map<String, Object> inDataMap = new HashMap<String, Object>();
			inDataMap = (Map<String,Object>) inParam.getBodyObject("DATA");
			if (inParam.getBodyBool("CHECK_FLAG")) {
				//inDataMap去除多余的参数
				sRealCont = raplaceMsgPara(inDataMap, sContent, outErrMsg);
				if (sRealCont == null) {
					log.error("短信发送过程中参数校验失败，请调用人员检查！");
					err_code = "0001";
					err_msg = "参数校验失败，开发人员检查";
				}
				
			} else {
				if (inDataMap != null) {
					Set<String> set = inDataMap.keySet();
					if (set.size() > 1) {
						log.error("目前所传信息中有多个参数，请设置入参中CHECK_FLAG=true，请修改！\n短信若不校验参数，建议使用公共模板，如${msg}。");
						err_code = "0002";
						err_msg = "请设置接口入参中CHECK_FLAG=true";
					}
				}
			}
			//设置短信内容
			result.put("CONTENT", inDataMap);
			
			//JSONObject jsonMsg = getJsonMsg(inParam, result);
			MBean mbean = getJsonMsgByTemplate(inParam, result);
	
			//2.根据优先级获取短信消息通道名 T109BSMessage
			if (0 == inLevel && result.get("PRIORITY_LEVEL") != null)
				inLevel = Integer.valueOf(result.get("PRIORITY_LEVEL").toString());
			Map<String, Object> topMap = getTopic(inLevel);
			String topic = topMap.get("TOPIC").toString();
			int priori = Integer.parseInt(topMap.get("PRIORI").toString());
			
			//3.发送短信内容到消息中间件
			iSendFlag = ValueUtils.intValue(inParam.getBodyObject("SEND_FLAG"));
			if ("0000".equals(err_code) && 0 == iSendFlag) {
	
				KeyedObjectPool<String, MessageContext> pool = dataBaseCache.getSmsPool();
				PropertyOption<String> MESSAGE_PART = dataBaseCache.getSmsPart();
				log.debug("pool="+pool+"msp="+MESSAGE_PART);
				String pub_client = DataBaseConst.pub_client;
				MessageContext context = null;
				//2、发送消息
				try {
					context = pool.borrowObject(pub_client);// 超时则么办？？？？？？
					Message message = Message.create(mbean.toString());//如果是对象，需要先序列化，在消费者侧反序列化
					//message.setProperty(PropertyOption.COMPRESS, true);// 是否压缩
					message.setProperty(PropertyOption.GROUP, phone_no);
					message.setProperty(MESSAGE_PART,  phone_no.substring(9, 11));
					message.setProperty(PropertyOption.PRIORITY, priori);// 1-60
					
					log.debug("短信组装后的报文：" + mbean.toString());
					log.debug("发送消息中间内容: " + message);
					try {
						final String id = context.send(topic, message);
						log.debug("发送完成返回ID="+id);
						context.commit(id);
					} catch (Exception e) {
						log.debug("发送异常，重新发送!!!errmsg="+e.getMessage());
						final String id = context.send(topic, message);
						log.debug("发送完成返回ID="+id);
						context.commit(id);
					}
					//本地事物。。。
					
				} catch(Exception e) {
					
					err_code = "0004";
					err_msg = "消息中间件发送异常，等待重发";
					//刷新短信Pool
					//dataBaseCache.initSmsPool();
					
					log.error("发送短信异常，错误信息："+e.toString());
					e.printStackTrace();
				} finally { 
					try {
						pool.returnObject(pub_client, context);
					} catch (Exception e1) {
						log.error("发送消息中间件异常中，returnObject异常~~~~");
						e1.printStackTrace();
					}
				}
			} else if (1 == iSendFlag) {
				err_code = "1111";
				//插入短信进入ERR表,注意临时表是否创建
			}
			
			//入表数据
			String seq_no = result.get("SYSTIME").toString()+result.get("NEXTVAL").toString();
			Map<String, Object> tmp_map = new HashMap<String, Object>();
			tmp_map.put("SEQ_NO", seq_no);
			tmp_map.put("PHONE_NO", phone_no);
			tmp_map.put("TEMPLATE_ID", template_id);
			tmp_map.put("SMS_NAME", result.get("SERV_NAME"));
			tmp_map.put("CONTENT", mbean.toString());//Comm.utfToGbk() IBATIS自动转换 20151110
			tmp_map.put("TOPIC_ID", topic);
			
			//入历史
			if ("0000".equals(err_code) && InterBusiConst.ShtMsg.INHIS_FLAG) {
				
				tmp_map.put("SEND_RESULT", "Y");
				tmp_map.put("RESEND", "N");
				tmp_map.put("REMARK", "success");
				baseDao.insert("in_smssend_his_INT.insert", tmp_map);
			} else if (!"0000".equals(err_code)) {
				//入IN_SMSSEND_ERR表
				//消息中间件异常，根据配置设置重发时间f
				if ("0004".equals(err_code))
					tmp_map.put("RESEND", result.get("END_MINUTE_OFFSET"));
				else 
					tmp_map.put("RESEND", "N");//其他异常不重发，等待手工处理
				tmp_map.put("SEND_RESULT", "N");
				tmp_map.put("ERR_CODE", err_code);
				tmp_map.put("REMARK", err_msg);
				
				baseDao.insert("in_smssend_err_INT.insert", tmp_map);
				return false;
			}
		}
		
		return true;
	}
	
	private Map<String, Object> getTemMap(long template_id) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> cacheMap = dataBaseCache.getDestTabCfgMap("PUSH_TEMPLATE", String.valueOf(template_id));
		if (null != cacheMap)
			resultMap.putAll(cacheMap);
		if (0 == resultMap.size()) {
			Map<String, Object> inMap = new HashMap<String, Object>();
			/**** update by zhangleij 20170418 增加数据类型转换，数据库存的是char类型  begin ****/
			//inMap.put("TEMPLATE_ID", template_id);
			inMap.put("TEMPLATE_ID", String.valueOf(template_id));
			/**** update by zhangleij 20170418 增加数据类型转换，数据库存的是char类型  end ****/
			resultMap = new HashMap<String, Object>();
			resultMap = (Map<String, Object>) baseDao.queryForObject("push_template_INT.qTemplateSmsById", inMap);
		} else {
			System.out.println("---templateid--map="+resultMap.toString());
			Map<String, Object> inMap = new HashMap<String, Object>();
			inMap.put("SEQ_NAME", "SEQ_SMS_PUSH");
			Map<String, Object> seqMap = (Map<String, Object>) baseDao.queryForObject("dual_INT.qSeqAndSystime", inMap);
			resultMap.putAll(seqMap);
			
		}
		return resultMap;
	}
	
	private String raplaceMsgPara(Map<String, Object> inDataMap, String inCont, String outErrMsg) {
		
		String sParamTmp = "";
		int iDollarIndex = 0; //${位置
		int iCloseBrace = 0;//右大括号位置
		
		String sValue = "";
		String sTrimVal = "";
		String sDolarParaTmp = "";//${PARA}
		Set<String> keySet = inDataMap.keySet();
		for (String strKey:keySet) {
			sValue = inDataMap.get(strKey).toString();
			
			sDolarParaTmp = "\\$\\{" + strKey + "\\}";
			if (-1 == inCont.indexOf(strKey)) {
				//去掉多余的参数
				inDataMap.remove(strKey);
			} else {
				//去掉空格
				sTrimVal = sValue.trim();
				if (sValue.length() > sTrimVal.length())
					inDataMap.put(strKey, sTrimVal);
				sTrimVal = sTrimVal.replaceAll("\\$", "\\\\\\$");//把$替换成\$
				String msgTmp = inCont.replaceAll(sDolarParaTmp, sTrimVal);
				inCont = msgTmp;
			}
		}
		log.debug("短信内容：【"+inCont+"】");

		//检查是否有未替换参数
		iDollarIndex = inCont.indexOf("${");
		if (-1 != iDollarIndex) {
			iCloseBrace  = inCont.indexOf("}", iDollarIndex + 2);
			sParamTmp = inCont.substring(iDollarIndex + 2, iCloseBrace);
			log.error("模板中参数[" + sParamTmp + "]未赋值，请调用短信接口人员检查！");;
			return null;
		}
		
		/*校验参数
		sContTailTmp = inCont;
		List<String> lstStr = new ArrayList<String>();
		while (true) {
			iDollarIndex = sContTailTmp.indexOf("${");
			if (-1 == iDollarIndex)
				break;
			iCloseBrace  = sContTailTmp.indexOf("}", iDollarIndex + 2);
			sParamTmp = sContTailTmp.substring(iDollarIndex + 2, iCloseBrace);			
			lstStr.add(sParamTmp);			
			sContTailTmp = sContTailTmp.substring(iCloseBrace + 1);
		}
		for (String strTmp : lstStr) {
			if (inDataMap.get(strTmp) == null) {
				log.error("模板中参数[" + strTmp + "]未赋值，请调用短信接口人员检查！");
				return false;
			}
		}*/
		
		return inCont;
	}
	
	private JSONObject getJsonMsg(MBean inParam, Map<String, Object> inMapCont) {
		
		//MBean mbMsg = new MBean(InterBusiConst.ShtMsg.TEMPLATE);
		JSONObject jsonMsg = new JSONObject();

		//Header
		JSONObject jsonHeadMsg = new JSONObject();
		jsonHeadMsg.put("TRACE_ID", ""); //生成新的TRACE_ID
		if (null != inParam.getHeaderStr("TRACE_ID"))
			jsonHeadMsg.put("PARENT_CALL_ID", inParam.getHeaderStr("TRACE_ID"));
		
		//put Header
		jsonMsg.put("HEADER", jsonHeadMsg);
		
		//Body
		////必传部分
		JSONObject jsonBodyMsg = new JSONObject();
		jsonBodyMsg.put("TEMPLATEID", inMapCont.get("TEMPLATE_ID"));
		jsonBodyMsg.put("PHONENO", inParam.getBodyStr("PHONE_NO"));
			JSONObject jsonCont = new JSONObject();
			jsonCont.put("msg", inMapCont.get("CONTENT"));
			jsonCont.put("title", inMapCont.get("SERV_NAME"));
		jsonBodyMsg.put("PARAMS", jsonCont);
		
		////非必传部分
		jsonBodyMsg.put("SYSID", ""); //系统ID，注意修改
		jsonBodyMsg.put("SEQ", "");   //什么流水？？
		
		Object sendTimeObj = inParam.getBodyObject("SEND_TIME");
		if (null != sendTimeObj) {
			jsonBodyMsg.put("SENDTIME", sendTimeObj);
		} else {
			jsonBodyMsg.put("SENDTIME", DateUtil.format(new Date(), "yyyyMMddHHmmss"));
		}
		if (null != inParam.getBodyObject("LOGIN_NO"))
			jsonBodyMsg.put("LOGINNO", inParam.getBodyStr("LOGIN_NO"));
		
		//put BODY
		jsonMsg.put("BODY", jsonBodyMsg);
		return jsonMsg;
	}
	
	private MBean getJsonMsgByTemplate(MBean inParam, Map<String, Object> inMapCont) {
		
		//取得模板
		MBean mbMsg = new MBean(InterBusiConst.ShtMsg.TEMPLATE);
		
		//Header
		JSONObject jsonHeadMsg = new JSONObject();
		jsonHeadMsg.put("TRACE_ID", ""); //生成新的TRACE_ID
		if (null != inParam.getHeaderStr("TRACE_ID"))
			jsonHeadMsg.put("PARENT_CALL_ID", inParam.getHeaderStr("TRACE_ID"));
		else
			jsonHeadMsg.put("PARENT_CALL_ID", "");
		//put Header
		mbMsg.setHeader(jsonHeadMsg);
		
		//Body
		////必传部分
		JSONObject jsonBodyMsg = new JSONObject();
		jsonBodyMsg.put("TEMPLATEID", inParam.getBodyStr("TEMPLATE_ID"));
		jsonBodyMsg.put("PHONENO", inParam.getBodyStr("PHONE_NO"));
			JSONObject jsonCont = new JSONObject();
			jsonCont.putAll((Map) inMapCont.get("CONTENT"));
			jsonCont.put("title", inMapCont.get("SERV_NAME"));
		jsonBodyMsg.put("PARAMS", jsonCont);
		
		////非必传部分
		Object sendTimeObj = inParam.getBodyObject("SEND_TIME");
		if (null != sendTimeObj) {
			jsonBodyMsg.put("SENDTIME", sendTimeObj);
		} else {
			jsonBodyMsg.put("SENDTIME", DateUtil.format(new Date(), "yyyyMMddHHmmss"));
		}
		
		Object send_seq = inParam.getBodyObject("SEND_SEQ");
		if (null != send_seq) {
			jsonBodyMsg.put("SERVICENO", send_seq);
		}
		
		if (null != inParam.getBodyObject("LOGIN_NO"))
			jsonBodyMsg.put("LOGINNO", inParam.getBodyStr("LOGIN_NO"));
		
		//其他字段
		jsonBodyMsg.put("SYSID", "3"); //系统ID，注意修改
		String seq = inMapCont.get("SYSTIME").toString()+inMapCont.get("NEXTVAL").toString();
		jsonBodyMsg.put("SEQ", seq);//boss侧为109
		jsonBodyMsg.put("SERVNO", "109"+seq);
		jsonBodyMsg.put("SERVNAME", "");
		
		//0:普通短信 1:二次确认短信 2:邮件短信 3:WAPPUSH短信
		String sms_type = inMapCont.get("SMS_TYPE").toString();
		if ("1".equals(sms_type))
			jsonBodyMsg.put("SUBPHONESEQ", "0"+inMapCont.get("NEXTVAL")); 
		else
			jsonBodyMsg.put("SUBPHONESEQ", "");
		
		if ("2".equals(sms_type))
			jsonBodyMsg.put("HOLD3", inParam.get("PHONE_NO").toString()+"@139.com");
		else 
			jsonBodyMsg.put("HOLD3", "");
		if ("3".equals(sms_type))
			jsonBodyMsg.put("HOLD4", inParam.get("PHONE_NO").toString());
		else 
			jsonBodyMsg.put("HOLD4", "");
		jsonBodyMsg.put("HOLD1", "0");
		jsonBodyMsg.put("HOLD2", "");
		jsonBodyMsg.put("HOLD5", "");
		
		//put BODY
		mbMsg.setBody(jsonBodyMsg);
		return mbMsg;
	}
	
	private boolean checkMsgJson(Map<String, Object> inDataMap, String inCont, String outErrMsg) {
		
		String sContTailTmp = "";
		String sParamTmp = "";
		int iDollarIndex = 0; //${位置
		int iCloseBrace = 0;//右大括号位置
		
		sContTailTmp = inCont;
		List<String> lstStr = new ArrayList<String>();
		while (true) {
			iDollarIndex = sContTailTmp.indexOf("${");
			if (-1 == iDollarIndex)
				break;
			iCloseBrace  = sContTailTmp.indexOf("}", iDollarIndex + 2);
			sParamTmp = sContTailTmp.substring(iDollarIndex + 2, iCloseBrace);
			log.debug("-----------sendmidmsg wile--sparma="+sParamTmp);
			
			lstStr.add(sParamTmp);			
			sContTailTmp = sContTailTmp.substring(iCloseBrace + 1);
		}

		for (String strTmp : lstStr) {
			log.debug("---------konglj test--for strTmp="+strTmp+" indatampa="+inDataMap.toString());
			if (inDataMap.get(strTmp) == null) {
				outErrMsg = "模板中参数[" + strTmp + "]未赋值，请调用短信接口人员检查！";
				return false;
			}
		}
		log.debug("------------konglj test--checkMsgJson end-");
		
		return true;
	}
	
	private Map<String, Object> getTopic(int inLevel) {

		int priori = 0;
		String sMsgTpc = "";
		Map<String, Object> out_map = new HashMap<String, Object>();
		switch (inLevel) {
		case 0:
		case 2:
			sMsgTpc = InterBusiConst.ShtMsg.DEFUT_TOPIC;
			priori = InterBusiConst.ShtMsg.DEFUT_PRIORI;
			break;
		case 1:
			sMsgTpc = InterBusiConst.ShtMsg.HIGH_TOPIC;
			priori = InterBusiConst.ShtMsg.HIGH_PRIORI;
			break;
		case 3:
			sMsgTpc = InterBusiConst.ShtMsg.LOW_TOPIC;
			priori = InterBusiConst.ShtMsg.LOW_PRIORI;
			break;
		case 4:
			sMsgTpc = InterBusiConst.ShtMsg.GROUP_TOPIC;
			priori = InterBusiConst.ShtMsg.GROUP_PRIORI;
			break;
		case 5:
			sMsgTpc = InterBusiConst.ShtMsg.BAK_TOPIC;
			priori = InterBusiConst.ShtMsg.BAK_PRIORI;
			break;
		default:
			sMsgTpc = InterBusiConst.ShtMsg.DEFUT_TOPIC;
			priori = InterBusiConst.ShtMsg.DEFUT_PRIORI;
			break;
		};
		out_map.put("TOPIC", sMsgTpc);
		out_map.put("PRIORI", priori);
		
		return out_map;
	}
	
	/**
	 * Title: 获取流水接口
	 * @param inParamMbean
	 * @return 返回创建的短信接口统一流水
	 * @throws Exception
	 */
	
	public String getMsgSeq(String inHeadStr) {
		
		String sOutParamAccept = "";
		String sBcAcceptDate = "";
		String sBcSequenValue = "";
		
		sBcAcceptDate = DateUtil.format(new Date(),"yyyyMMddHHmmss");
		
/*		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("SEQ_NAME", "SEQ_SMS_PUSH");
		Map<String, Object> result = new HashMap<String, Object>();
		result = (Map<String, Object>)baseDao.queryForObject("dual_INT.qSequenceInter", inMap);
		sBcSequenValue = result.get("NEXTVAL").toString();*/
		sBcSequenValue = String.valueOf(control.getSequence("SEQ_SMS_PUSH"));
		if (inHeadStr.equals("") || sBcAcceptDate.equals("") || sBcSequenValue.equals(""))
			return null;
		else 
			sOutParamAccept = inHeadStr + sBcAcceptDate + sBcSequenValue;

		log.debug("-------test getSeq stt--sOutParamAccept="+sOutParamAccept);
		return sOutParamAccept;
	}

	
	public IntControl getControl() {
		return control;
	}

	public void setControl(IntControl control) {
		this.control = control;
	}

	public DataBaseCache getDataBaseCache() {
		return dataBaseCache;
	}

	public void setDataBaseCache(DataBaseCache dataBaseCache) {
		this.dataBaseCache = dataBaseCache;
	}
	
}