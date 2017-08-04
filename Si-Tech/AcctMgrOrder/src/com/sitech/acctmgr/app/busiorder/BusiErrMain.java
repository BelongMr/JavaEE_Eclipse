package com.sitech.acctmgr.app.busiorder;

import com.sitech.jcf.context.LocalContextFactory;
import com.sitech.jcf.core.SessionContext;
import com.sitech.jcf.core.util.XMLFileContext;

public class BusiErrMain {

	/**
	 * 名称:业务异常工单处理
	 * 使用:./BusiErrMain 0 create_accept 对指定流水的工单重发 
	 *     ./BusiErrMain 1 0  提所有err_code=0000的工单，重发
	 * 日期:2015/09/05
	 */
	public static void main(String[] args) {

		System.err.println("args.length="+args.length+"  "+args[0]+"  "+args[1]);
		if (args.length < 3) {
			System.err.println("|------------------------------------------|");
			System.err.println("|使用:./BusiErrMain A1[B1] 0 create_accept 对指定流水的工单重发");
			System.err.println("|使用:./BusiErrMain A1[B1] 1 0  提所有err_code=0000的工单，重发");
			System.err.println("|------------------------------------------|");
			return ;
		}

		String sDbId      = args[0];
		String sFlag      = args[1];
		String sAccept    = args[2];

		// 添加spring的配置文件
		XMLFileContext.addXMLFile("applicationContext.xml");
		// 加载spring容器
		XMLFileContext.loadXMLFile();	

		IBusiOrderSyn iBusiOrderSyn = LocalContextFactory.getInstance().getBean("BusiOrderSynSvc", IBusiOrderSyn.class);

		try {
			//切换数据库标签
			SessionContext.setDbLabel(sDbId);

			iBusiOrderSyn.dealBusiOrderErr(sFlag,sAccept);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
