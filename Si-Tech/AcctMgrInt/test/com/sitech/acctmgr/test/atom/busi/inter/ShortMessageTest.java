package com.sitech.acctmgr.test.atom.busi.inter;

import static org.junit.Assert.*;

import java.util.Date;

import org.junit.Test;

import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.acctmgrint.atom.busi.intface.IShortMessage;
import com.sitech.jcfx.context.JCFContext;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.util.DateUtil;

/**
 *
 * <p>Title:   </p>
 * <p>Description:   </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author 
 * @version 1.0
 */
public class ShortMessageTest extends BaseTestCase {

	/**
	 * Test method for {@link com.sitech.acctmgrint.atom.busi.intface.ShortMessage#sendSmsMsg(com.sitech.jcfx.dt.MBean)}.
	 */
	@Test
	public void testSendSmsMsgMBean() {
		
		//for (int i = 0; i < 10; i++) {
			IShortMessage message = (IShortMessage) JCFContext.getBean("ShortMessageTestSvc");
			//IShortMessage message = (IShortMessage) JCFContext.getBean("ShortMessageEnt");
	
			log.info("------ShortMsg test ----------------------");
			/* 缴费模板（参数尽量大写）：
			 *尊敬的${sm}客户，您的手机号码${phone}在${year}年${month}月${day}日${hours}时${minute}分成功缴费${money}元，您当前话费余额为${balance}元。网上缴费便捷，更可得话费，请电脑登录www.jl.10086.cn。
			 */
			MBean inMessage = new MBean();
			inMessage.addBody("TEMPLATE_ID", "31320002");
			inMessage.addBody("PHONE_NO", "13756956000");
			inMessage.addBody("OP_CODE", "8000");
			inMessage.addBody("SEND_FLAG", 0);
			inMessage.addBody("CHECK_FLAG", true);//是否校验参数
			inMessage.addBody("SEND_TIME", "20150703145959");//发送时间
			//inMessage.addBody("SEND_TIME", DateUtil.format(new Date(),"yyyyMMddHHmmss"));
			inMessage.addBody("LOGIN_NO", "billing");
			//短信参数
			inMessage.addBody("DATA.sm",     "神州行     ");
			inMessage.addBody("DATA.phone",  "15044489141");
			inMessage.addBody("DATA.year",   "12");
			inMessage.addBody("DATA.month",  "12");
			inMessage.addBody("DATA.day",    "12");
			inMessage.addBody("DATA.hours",  "12");
			inMessage.addBody("DATA.minute", "12");
			inMessage.addBody("DATA.money",  "12");
			inMessage.addBody("DATA.balance", "12.12");
			
			boolean result = message.sendSmsMsg(inMessage);
			log.info("------ShortMsg test -------实际结果："+result);
		
			assertEquals(true, result);
		//}//for END
	}

}
