package com.sitech.acctmgrint.atom.busi.intface.cfgcache;

import com.sitech.acctmgrint.atom.busi.intface.SvcOrder;
import com.sitech.acctmgrint.common.BaseBusi;
import com.sitech.jcf.context.LocalContextFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DataBaseRefresh extends BaseBusi implements Runnable {

	private DataBaseCache dataBaseCache = LocalContextFactory.getInstance().getBean("dataBaseCacheEnt", DataBaseCache.class);
	
	private static Logger log = LoggerFactory.getLogger(SvcOrder.class);
	
	public void run() {
		try {

			this.refreshConfig();
			
		} catch (Exception e) {
			log.info("---catch CTB Exception e="+e.getMessage());
		}
		
	}
	
	/**
	 * Title 手动刷新配置
	 */
	private void refreshConfig() {
		
		/* 使用set重载方法刷新*/
		log.info("-----刷新 数据同步配置缓存 STT----");
		dataBaseCache.init();
		log.info("-----设置 数据同步配置缓存为空 SCSS----");
		
	}
	
}