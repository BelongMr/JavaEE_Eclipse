package com.sitech.acctmgr.test.atom.busi.inter;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.junit.Test;

import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.acctmgrint.atom.busi.intface.IShortMessage;
import com.sitech.jcfx.context.JCFContext;
import com.sitech.jcfx.dt.MBean;

public class SendMidMsgTest extends BaseTestCase {

	@Test
	public void testSendMidMsg() {
		
		//模板
		String content = "{\"ROOT\":{\"HEADER\":{\"TRACE_ID\":\"*20150319125800***000002\",\"PARENT_CALL_ID\":\"19FE34517EE4B62C6F4234D702314C49\"},\"BODY\":{\"SYSID\":\"2\",\"SEQ\":\"1301201503191258000002\",\"TEMPLATEID\":\"00000575\",\"PARAMS\":{\"msg\":\"短信测试内容乱码\",\"title\":\"12345\"},\"SERVICENO\":\"\",\"PHONENO\":\"13311307026\",\"LOGINNO\":\"crm\",\"SERVNO\":\"\",\"SERVNAME\":\"\",\"SUBPHONESEQ\":\"\",\"SENDTIME\":\"20150319125800\",\"HOLD1\":\"0\",\"HOLD2\":\"\",\"HOLD3\":\"\",\"HOLD4\":\"\",\"HOLD5\":\"\"}}}";
		
		log.info("----------get bean shotmsg---stt----");
		IShortMessage shortMessage = (IShortMessage)
				JCFContext.getBean("ShortMessageEnt");
		log.info("-----------konglj test 消息中间件 stt---------");
		/*
	 	* @param	TEMPLATE_ID 短信模板
		* @param	PHONE_NO    服务号码
		* @param	OP_CODE     操作代码
		* @param	CHECK_FLAG  是否检查参数(BOOLEAN:true or false)
		* @param    SEND_FLAG   是否发送标示((默认)0:发送 1:插入短信接口临时表，测试用)
		* @param	DATA.XXX    模板中需要替换的参数列(DATA组中)
		 */
		MBean mMsg = new MBean();
		Map<String, Object> header = new HashMap<String, Object>();
		header.put("TRACE_ID", "20150319125800***000005");
		header.put("PARENT_CALL_ID", "19FE34517EE4B62C6F4234D702314C49");
		mMsg.setHeader(header);
		mMsg.addBody("TEMPLATE_ID", "00000575");//20000236
		mMsg.addBody("PHONE_NO", "13512348888");
		mMsg.addBody("LOGIN_NO", "fwkt");
		mMsg.addBody("CHECK_FLAG", false);
		mMsg.addBody("SEND_FLAG", 0);
		mMsg.addBody("DATA.msg", "I am param A.");
		System.out.println("msg.data="+mMsg.getBodyObject("DATA"));
		//log.info("---------msgSeq="+shortMessage.getMsgSeq("109"));
		shortMessage.sendSmsMsg(mMsg, 1);
		
//		String ss = "AAAAA#{a}BBBBBB#{a}CCCCCC#{a}DDDDDDD#{b}EEEEE";
//		String re = "\\#\\{a\\}";
//		String tmp = ss.replaceAll(re, "klj");
//		log.info("re=["+re+"]tmp="+tmp);
		log.info("-----------konglj test 消息中间件 end---------");

	}

}
