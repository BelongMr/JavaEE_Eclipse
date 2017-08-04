package com.sitech.acctmgrint.atom.busi.intface.comm;

import com.sitech.acctmgrint.atom.busi.intface.odrblob.OdrLineContDAO;
import com.sitech.acctmgrint.atom.busi.intface.odrblob.OdrLineContVO;
import com.sitech.acctmgrint.common.AcctMgrError;
import com.sitech.acctmgrint.common.BaseBusi;
import com.sitech.acctmgrint.common.IntControl;
import com.sitech.acctmgrint.common.constant.InterBusiConst;
import com.sitech.crmpd.idmm2.client.MessageContext;
import com.sitech.crmpd.idmm2.client.api.Message;
import com.sitech.crmpd.idmm2.client.api.PropertyOption;
import com.sitech.crmpd.idmm2.client.pool.PooledMessageContextFactory;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.util.DateUtil;
import org.apache.commons.pool2.KeyedObjectPool;
import org.apache.commons.pool2.impl.GenericKeyedObjectPool;
import java.io.UnsupportedEncodingException;
import java.util.Date;

public class MsgMiddle extends BaseBusi {
	
	OdrLineContDAO odrDAO;

	/**
	 * 插入消息发送接口表
	 * @description 后由后台程序扫描发送
	 * @param prod
	 */
	public void inputMsgSend(ProducerMsg prod, MBean beanPara) {
		
		/*同步业务消息*/
		log.debug("--inputMsgSend----STT--");
		long lCreateAccept = 0L;
		String sLoginAccept = "";
		
		//自定义流水，如缴费流水等，若没有则使用自动生成的BC流水
		if (!beanPara.getBodyStr("LOGIN_SN").equals(""))
			sLoginAccept = beanPara.getBodyStr("LOGIN_SN");
		else
			sLoginAccept = getInterLoginAccept("RP");
		
		//统一流水
		int ilen = 0;
		if (sLoginAccept.startsWith("RP")) {
			ilen = sLoginAccept.length();
			lCreateAccept = Long.valueOf(sLoginAccept.substring((ilen-18>0)?ilen-18:0, ilen));
		} else {
			String sCreatAcptTmp = getInterLoginAccept("");
			ilen = sCreatAcptTmp.length();
			lCreateAccept = Long.valueOf(sCreatAcptTmp.substring((ilen-18>0)?ilen-18:0, ilen));
		}
		log.debug("----lCreateAct="+lCreateAccept);
		
		byte[] byte_cont = null;
		try {
			byte_cont = prod.getMsg().toString().getBytes("GBK");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		OdrLineContVO odrLineContVO = new OdrLineContVO();
		odrLineContVO.setGsTopicId(    prod.getTopic());
		odrLineContVO.setGbContent(    byte_cont);
		odrLineContVO.setGsBusiidType( prod.getGrpType());
		odrLineContVO.setGsBusiidNo(   prod.getGroupId());
		odrLineContVO.setGsDataSrc(    "DTSN");
		odrLineContVO.setGsOpCode(     beanPara.getBodyStr("OP_CODE"));
		odrLineContVO.setGsLoginNo(    beanPara.getBodyStr("LOGIN_NO"));
		odrLineContVO.setGlCreatAct(   lCreateAccept);
		odrLineContVO.setGsLoginAct(   sLoginAccept);
		odrDAO.insertOdrLineCont(odrLineContVO);
		
		log.debug("--inputMsgSend OrderInter----over");
	}

	/**
	 * @description 向消息中间件发送消息
	 * @param inmbjson
	 */
	public void sendMiddleInter(ProducerMsg prod) {
		
		//向消息中间件发送消息
		//1、相关设置
		final KeyedObjectPool<String, MessageContext> pool = new GenericKeyedObjectPool<String, MessageContext>(
				new PooledMessageContextFactory(prod.getAddr(), prod.getProcessTime()));
		try {
			final MessageContext context = pool.borrowObject(prod.getClient());
			final Message message = Message.create(prod.getMsg().toString());// 如果是对象，需要先序列化，在消费者侧反序列化
			//message.setProperty(PropertyOption.COMPRESS, prod.isCompress());// 是否压缩
			message.setProperty(PropertyOption.GROUP, prod.getGroupId());// id_no或者

			message.setProperty(PropertyOption.PRIORITY, prod.getPriori());// 1-1000
			final String id = context.send(prod.getClient(), message);
			System.out.println(id);
			context.commit(id);

			pool.returnObject("Pub208", context);
		} catch (final Exception e) {
			e.printStackTrace();
			log.error("发送消息异常，插入err表。错误信息："+e.toString());
			// 插入异常表
			//insertMsgErrCont();
			
			throw new BusiException(AcctMgrError.getErrorCode(
					InterBusiConst.ErrInfo.OP_CODE,
					InterBusiConst.ErrInfo.MSGSEND+"010"), "发送消息异常，"+e.toString());
		}
		
	}
	
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
		
		sBcAcceptDate = DateUtil.format(new Date(),"yyyyMMddHHmmss");

		sBcSequenValue = String.valueOf(IntControl.getSequence("SEQ_INTERFACE_SN"));
		if (sBcAcceptDate.equals("") || sBcSequenValue.equals(""))
			return null;
		else 
			sOutParamAccept = inHeadStr + sBcAcceptDate + sBcSequenValue;

		log.debug("------- getInterLoginAccept stt--sOutParamAccept="+sOutParamAccept);
		return sOutParamAccept;
	}

	public OdrLineContDAO getOdrDAO() {
		return odrDAO;
	}

	public void setOdrDAO(OdrLineContDAO odrDAO) {
		this.odrDAO = odrDAO;
	}
}
