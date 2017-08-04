package com.sitech.acctmgrint.atom.busi.intface.cfgcache;

import com.sitech.acctmgrint.atom.busi.intface.comm.JdbcConn;
import com.sitech.acctmgrint.common.AcctMgrError;
import com.sitech.crmpd.idmm2.client.MessageContext;
import com.sitech.crmpd.idmm2.client.api.PropertyOption;
import com.sitech.crmpd.idmm2.client.pool.PooledMessageContextFactory;
import com.sitech.jcf.core.datasource.DataSourceHelper;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcf.ijdbc.SqlFind;
import com.sitech.jcf.ijdbc.sql.SqlTypes;
import com.sitech.jcf.ijdbc.util.DataSourceUtils;
import com.sitech.jcfx.context.JCFContext;

import org.apache.commons.pool2.KeyedObjectPool;
import org.apache.commons.pool2.impl.GenericKeyedObjectPool;
import org.apache.commons.pool2.impl.GenericKeyedObjectPoolConfig;

import javax.sql.DataSource;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class DataBaseCache {
	
	/*缓存服开配置，短信模板，短信Pool同步配置信息*/
	@SuppressWarnings("rawtypes")
	private static ConcurrentHashMap tabsConfigMap = null;

	private int    load_data;
	private int    maxperkey;
	private int process_time;
	private String addr;
	private String data_source;

	public void init() {
		//Ent实例化时，分配好Map空间
		tabsConfigMap = new ConcurrentHashMap();
		//短信POOL
		initSmsPool();
		if (1 == load_data)
			if (null == tabsConfigMap || tabsConfigMap.size() == 2 || tabsConfigMap.size() == 0) {
				//替换getAllTabConfig(tabsConfigMap);
				getAllCfg_2(tabsConfigMap);//动态绑定变量
			}
	}
	
	/**
	 * 若初始时，不取配置（load_data=0）；则第一次取配置时，调此方法取缓存；
	 */
	public void initGetData() {
		//短信POOL
		initSmsPool();
		if (0 == load_data)
			if (2 == tabsConfigMap.size() || 0 == tabsConfigMap.size()) {
				setLoad_data(1);//只初始化一次
				getAllCfg_2(tabsConfigMap);//动态绑定变量
			}
	}
	
	/**
	 * 短信连接中间件池缓存
	 */
	@SuppressWarnings("unchecked")
	public void initSmsPool(){
		//短信发送消息中间件POOL
		final KeyedObjectPool<String, MessageContext> pool;
		final PropertyOption<String> MESSAGE_PART;

		if (null != tabsConfigMap.get("SMS_POOL") && null != tabsConfigMap.get("SMS_MSGPART")) {
			return ;
		}
		
		MESSAGE_PART = PropertyOption.valueOf("msg_part");
		GenericKeyedObjectPoolConfig CONFIG = new GenericKeyedObjectPoolConfig();
	
		CONFIG.setMaxTotalPerKey(getMaxperkey());
		CONFIG.setTestOnBorrow(true);
		//1.定义生产者对象池
		try {
			pool = new GenericKeyedObjectPool<String, MessageContext>(
					new PooledMessageContextFactory(getAddr(), getProcess_time()), CONFIG);
			//放入Map缓存
			tabsConfigMap.put("SMS_POOL", pool);
			tabsConfigMap.put("SMS_MSGPART", MESSAGE_PART);
		} catch (Exception e) {e.printStackTrace();}
	}
	
	@SuppressWarnings("unchecked")
	public KeyedObjectPool<String, MessageContext> getSmsPool() {
		return (KeyedObjectPool<String, MessageContext>) tabsConfigMap.get("SMS_POOL");
	}
	@SuppressWarnings("unchecked")
	public PropertyOption<String> getSmsPart() {
		return (PropertyOption<String>) tabsConfigMap.get("SMS_MSGPART");
	}
	
	/**
	 * Title 取得对应同步表的配置数据(LIST)
	 * Description 下面参数为配置缓存中的两级缓存目录
	 * @param inTableName
	 * @param inDestKey
	 * @return
	 */
	public List<Map<String, Object>> getDestTabCfgList(String inTableName, String inDestKey) {
		String sUpperTabName = inTableName.toUpperCase();
		Map<String, Object> destTabMap = (Map<String, Object>) tabsConfigMap.get(sUpperTabName);
		if ( null != destTabMap)
			return (List<Map<String, Object>>) destTabMap.get(inDestKey);
		else if (getLoad_data() == 0) {
			initGetData();
			destTabMap = (Map<String, Object>) tabsConfigMap.get(sUpperTabName);
			if (null != destTabMap.get(inDestKey))
				return (List<Map<String, Object>>) destTabMap.get(inDestKey);
		}
		return null;
	}
	
	/**
	 * Title 取得对应同步表的配置数据(Map)
	 * Description 下面参数为配置缓存中的两级缓存目录
	 * @param inTabName 一级; 由表名为KEY
	 * @param inDestKey 二级; 由原参数顺序以"#"隔开拼串为KEY
	 * @return
	 */
	public Map<String, Object> getDestTabCfgMap(String inTabName, String inDestKey) {
		
		//List<Map<String, Object>> destMaps = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> destMaps = getDestTabCfgList(inTabName, inDestKey);
		if (null == destMaps)
//			if (getLoad_data() == 0) {
//				init();
//				destMaps = getDestTabCfgList(inTabName, inDestKey);
//			} else if (getLoad_data() == 1)
				return null;
		for (Map<String, Object> destMap : destMaps) {
			if (destMap.size() != 0)
				return destMap;
		}
		return null;
	}
	
	/**
	 * Title 私有接口：获取所有表的配置放入静态Map变量
	 * Description 使用IBATIS缓存模式
	 * @param outCfgMap
	 */
	private void getAllTabConfig(ConcurrentHashMap outTabsConfigMap) {
		//使用db.xml默认配置"dataSourceA"
		DataSource dataSrc = (DataSource) JCFContext.getBean(getData_source());
		Connection conn =DataSourceUtils.getConnection(dataSrc);
		
		String sDisKeySql = "";
		String sDesDataSql = "";

		Map<String, Object> destTabMap = null;
		
		//NOTE: DEST_KEY中各字段值以“#”隔开。
		
		/*1.---取in_bssvc_dict配置---*/
		//用例：getDestTabCfgMap("IN_BSSVC_DICT", "B01001");

		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct SVC_ID     DEST_KEY "
				+ "from in_bssvc_dict where SVC_TYPE = 'M'";
		sDesDataSql = "select SVC_ID, SVC_TYPE, SPMS_FLAG from in_bssvc_dict "
				+ "where SVC_ID='#PARAM#' and SVC_TYPE='M'";
		getTabConfig(destTabMap, sDisKeySql, sDesDataSql, conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("IN_BSSVC_DICT", destTabMap);
		
		/*2.---取IN_BSSTATUSTOACTION_REL配置---只取状态为：'A','C','B','D','b'*/
		//用例：getDestTabCfgMap("IN_BSSTATUSTOACTION_REL", "A#B01001");

		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct STATUS||'#'||SVC_ID     DEST_KEY "
				+ "from IN_BSSTATUSTOACTION_REL where SVC_TYPE = 'M' and STATUS IN('A','C','B','F','J')";
		sDesDataSql = "SELECT SVC_OFFER_ID,MAINSVC_ACTION MAIN_ACTION_ID,SUBSVC_ACTION SUB_ACTION_ID,ORDER_PRIORITY "
				+ "FROM IN_BSSTATUSTOACTION_REL where STATUS='#PARAM#' and SVC_ID='#PARAM#' and SVC_TYPE='M'";
		getTabConfig(destTabMap, sDisKeySql, sDesDataSql, conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("IN_BSSTATUSTOACTION_REL", destTabMap);
		
		/*3.---取IN_BSMODTABLE_REL配置---*/
		//用例：getDestTabCfgMap("IN_BSMODTABLE_REL", "8901#B01001");

		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct ACTION_ID||'#'||MAIN_SVC     DEST_KEY "
				+ "from IN_BSMODTABLE_REL ";
		sDesDataSql = "SELECT TABLE_NAME,ODR_SAVE_CODE,ORDER_SOURCE,TEMPLATE_CONTENT,ORDER_TYPE "
				+ "FROM IN_BSMODTABLE_REL where ACTION_ID=#PARAM# and MAIN_SVC='#PARAM#'";
		getTabConfig(destTabMap, sDisKeySql, sDesDataSql, conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("IN_BSMODTABLE_REL", destTabMap);
		
		/*4.---取IN_BSPRIPARM_DICT配置---*/
		//用例：getDestTabCfgMap("IN_BSPRIPARM_DICT", "8901#B01001");

		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct ACTION_ID||'#'||MAIN_SVC     DEST_KEY "
				+ "from IN_BSPRIPARM_DICT ";
		sDesDataSql = "SELECT PRAM_TYPE,PRAM_VALUE,PRAM_NAME,EXP_TYPE,PRAM_EXP,RET_NUM "
				+ "FROM IN_BSPRIPARM_DICT where ACTION_ID=#PARAM# and MAIN_SVC='#PARAM#'";
		getTabConfig(destTabMap, sDisKeySql, sDesDataSql, conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("IN_BSPRIPARM_DICT", destTabMap);
		
		/*5.---取IN_BSDATASOURCE_DICT配置--- and rownum < 1000*/
		//此处需注意 IN_BSDATASOURCE_DICT 太多时进行过滤只取全部或部分主服务
		//用例：getDestTabCfgMap("IN_BSDATASOURCE_DICT", "103");

		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct DATASOURCE_ID     DEST_KEY "
				+ "FROM IN_BSDATASOURCE_DICT where rownum < 1000";
		sDesDataSql = "SELECT SRC_TYPE,RET_NUM,DATA_EXP "
				+ "from IN_BSDATASOURCE_DICT where DATASOURCE_ID=#PARAM# order by ret_num ";
		getTabConfig(destTabMap, sDisKeySql, sDesDataSql, conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("IN_BSDATASOURCE_DICT", destTabMap);
		
		/*6.---取IN_BSSVC_ATTRGROUP_REL配置--- and rownum < 1000*/
		//用例：getDestTabCfgList("IN_BSSVC_ATTRGROUP_REL", "B01001#8901#M");

		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct A.SVC_ID||'#'||A.ACTION_ID||'#'||A.SVC_TYPE     DEST_KEY "
				+ "from IN_BSSVC_ATTRGROUP_REL A, IN_BSGROUPATTR_REL B "
				+ "where A.ATTR_GRP_ID=B.ATTR_GRP_ID AND B.VALUE_NULL_FLAG='N' and rownum < 1000";
		sDesDataSql = "SELECT GRP_TYPE, ATTR_VALUE, ATTR_NAME, ATTR_NEW_VALUE, VALUE_NULL_FLAG, NODE_NULL_FLAG "
				+ "FROM IN_BSSVC_ATTRGROUP_REL A, IN_BSGROUPATTR_REL B "
				+ "WHERE A.SVC_ID='#PARAM#' and A.ACTION_ID=#PARAM# and A.SVC_TYPE='#PARAM#' "
				+ "AND A.ATTR_GRP_ID=B.ATTR_GRP_ID AND B.VALUE_NULL_FLAG='N' ORDER BY ATTR_SEQ";
		getTabConfig(destTabMap, sDisKeySql, sDesDataSql,conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("IN_BSSVC_ATTRGROUP_REL", destTabMap);
		
		/*7.---取PUSH_TEMPLATE配置，全量---*/
		//用例：getDestTabCfgMap("PUSH_TEMPLATE", "31320001");
		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct TEMPLATE_ID     DEST_KEY "
				   + "from PUSH_TEMPLATE " ;
		sDesDataSql = "SELECT CONTENT, SERV_NAME, PRIORITY_LEVEL, SEND_TYPE, BASESRC, SRC_NO, SMS_TYPE, END_MINUTE_OFFSET "
				   + "FROM PUSH_TEMPLATE WHERE TEMPLATE_ID=#PARAM#" ;
		getTabConfig(destTabMap, sDisKeySql, sDesDataSql, conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("PUSH_TEMPLATE", destTabMap);
		
		DataSourceHelper.closeConnection(conn);
		
		return ;
		
	}
	
	/**
	 * Title 一个配置表的配置信息
	 * @param outTabsConfigMap
	 * @param inDistSql
	 * @param inDataSql
	 */
	private void getTabConfig(Map<String, Object> outTabCfgMap, 
			String inDistSql, String inDataSql, Connection conn) {
		
		//String sSqlString = "";
		String sDestKey = "";
		List<Map> listTabRst = null;
		String[] strsKey = null;
		String sExecSql = "";
		
		//取得全部的配置表名
		List<Map> listTabs = new ArrayList<Map>();
		listTabs = operJdbcSql(inDistSql, conn);
		if (listTabs == null)
			throw new BusiException(AcctMgrError.getErrorCode("0000","10031"), "数据同步查询缓存配置错误！");

		for (Map<String, Object> tmpMap : listTabs) {
			
			/*取list中同步表对应的配置信息*/
			sDestKey = tmpMap.get("DEST_KEY").toString();
			strsKey = sDestKey.split("#");
			sExecSql = inDataSql;
			for (String strTmp : strsKey) {
				sExecSql = sExecSql.replaceFirst("#PARAM#", strTmp);
			}

			listTabRst = operJdbcSql(sExecSql, conn);
			if (listTabRst == null)
				throw new BusiException(AcctMgrError.getErrorCode("0000","10032"),
						"cbSYNC查询缓存配置错误！sDestKey="+sDestKey); 
			//以sDestKey 为KEY ,将取得的配置信息放入静态Map缓存中
			outTabCfgMap.put(sDestKey, listTabRst);
		}
		
		return ;
		
	}

	/**
	 * Title  执行Sql语句
	 * Description 执行拼装好的Sql语句，同步数据
	 * @param inSqlBuf
	 * @param inSqlChg
	 * @return
	 */
	private List<Map> operJdbcSql(String inQrySql, Connection conn) {
		List<Map> list = new ArrayList<Map>();
		
		try {
			SqlFind sqlFind = new SqlFind();
			sqlFind.setListElementAsMap(true);
			list = sqlFind.findList(conn, inQrySql);
		} catch(Exception e){
			DataSourceHelper.rollback(conn);
			
			e.printStackTrace();
		}
		
		return list;
	}

	/******************************动态绑定方式*********************************/
	
	/**
	 * 名称：动态绑定取值
	 * @param key_name_type 例：SVC_ID|CHAR#ACTION|LONG
	 * @param outTabCfgMap
	 * @param inDistSql
	 * @param inDataSql
	 * @param conn
	 */
	private void getTabConfig_2(String key_name_type, Map<String, Object> outTabCfgMap, 
			String inDistSql, String inDataSql, Connection conn) {
		
		String sDestKey = "";
		List<Map<String, Object>> listTabRst = null;
		List<Map<String, Object>> listTabs = null;
		String[] arrKeyValue = null;
		String[] arrKeyName = null;
		String sExecSql = "";
		
		JdbcConn jdbcConn = new JdbcConn(conn);

		//取得全部的配置表名
		jdbcConn.setSqlBuffer(inDistSql);
		listTabs = jdbcConn.select();
		if (listTabs == null)
			throw new BusiException(AcctMgrError.getErrorCode("0000","10031"), "数据同步查询缓存配置错误！");

		for (Map<String, Object> tmpMap : listTabs) {
			
			/*取list中同步表对应的配置信息*/
			sDestKey = tmpMap.get("DEST_KEY").toString();
			//key值
			arrKeyValue = sDestKey.split("#");
			//key名称
			arrKeyName = key_name_type.split("#");
			
			sExecSql = inDataSql;
			for (String key_name : arrKeyName) {
				sExecSql = sExecSql.replaceFirst("#PARAM#", "?");
			}
			//System.out.println("CACHE:执行的SQL:"+sExecSql);
			
			//设置动态语句
			jdbcConn.setSqlBuffer(sExecSql);
			//设置动态绑定值
			for (int i = 0; i < arrKeyName.length; i++) {
				String[] name_type = arrKeyName[i].split("\\|");
				if (name_type[1].equals("LONG")) {
					jdbcConn.addParam(name_type[0], arrKeyValue[i], SqlTypes.JLONG);
				} else {
					jdbcConn.addParam(name_type[0], arrKeyValue[i], SqlTypes.JSTRING);
				}
			}
			//取值
			listTabRst = jdbcConn.select();
			if (listTabRst == null)
				throw new BusiException(AcctMgrError.getErrorCode("0000","10032"),
						"cbSYNC查询缓存配置错误！sDestKey="+sDestKey); 
			//以sDestKey 为KEY ,将取得的配置信息放入静态Map缓存中
			outTabCfgMap.put(sDestKey, listTabRst);
		}
		
		return ;
		
	}
	
	/**
	 * Title 私有接口：获取所有表的配置放入静态Map变量
	 * Description 使用JdbcConn动态绑定方式取配置
	 * @param outCfgMap
	 */
	private void getAllCfg_2(ConcurrentHashMap outTabsConfigMap) {
		//使用ijdbc.properties中配置DATASOURCE
		DataSource dataSrc = (DataSource) JCFContext.getBean(getData_source());
		Connection conn =DataSourceUtils.getConnection(dataSrc);
		
		String sDisKeySql = "";
		String sDesDataSql = "";

		Map<String, Object> destTabMap = null;
		
		//NOTE: DEST_KEY中各字段值以“#”隔开。
		
		/*1.---取in_bssvc_dict配置---*/
		//用例：getDestTabCfgMap("IN_BSSVC_DICT", "B01001");

		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct SVC_ID     DEST_KEY "
				+ "from in_bssvc_dict where SVC_TYPE = 'M'";
		sDesDataSql = "select SVC_ID, SVC_TYPE, SPMS_FLAG from in_bssvc_dict "
				+ "where SVC_ID=#PARAM# and SVC_TYPE='M'";
		getTabConfig_2("SVC_ID|CHAR", destTabMap, sDisKeySql, sDesDataSql, conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("IN_BSSVC_DICT", destTabMap);
		
		/*2.---取IN_BSSTATUSTOACTION_REL配置---只取状态为：'A','C','B','D','b'*/
		//用例：getDestTabCfgMap("IN_BSSTATUSTOACTION_REL", "A#B01001");

		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct STATUS||'#'||SVC_ID     DEST_KEY "
				+ "from IN_BSSTATUSTOACTION_REL where SVC_TYPE = 'M' and STATUS IN('A','C','B','F','J')";
		sDesDataSql = "SELECT SVC_OFFER_ID,MAINSVC_ACTION MAIN_ACTION_ID,SUBSVC_ACTION SUB_ACTION_ID,ORDER_PRIORITY "
				+ "FROM IN_BSSTATUSTOACTION_REL where STATUS=#PARAM# and SVC_ID=#PARAM# and SVC_TYPE='M'";
		getTabConfig_2("STATUS|CHAR#SVC_ID|CHAR", destTabMap, sDisKeySql, sDesDataSql, conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("IN_BSSTATUSTOACTION_REL", destTabMap);
		
		/*3.---取IN_BSMODTABLE_REL配置---*/
		//用例：getDestTabCfgMap("IN_BSMODTABLE_REL", "8901#B01001");

		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct ACTION_ID||'#'||MAIN_SVC     DEST_KEY "
				+ "from IN_BSMODTABLE_REL ";
		sDesDataSql = "SELECT TABLE_NAME,ODR_SAVE_CODE,ORDER_SOURCE,TEMPLATE_CONTENT,ORDER_TYPE "
				+ "FROM IN_BSMODTABLE_REL where ACTION_ID=#PARAM# and MAIN_SVC=#PARAM#";
		getTabConfig_2("ACTION_ID|LONG#MAIN_SVC|CHAR", destTabMap, sDisKeySql, sDesDataSql, conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("IN_BSMODTABLE_REL", destTabMap);
		
		/*4.---取IN_BSPRIPARM_DICT配置---*/
		//用例：getDestTabCfgMap("IN_BSPRIPARM_DICT", "8901#B01001");

		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct ACTION_ID||'#'||MAIN_SVC     DEST_KEY "
				+ "from IN_BSPRIPARM_DICT ";
		sDesDataSql = "SELECT PRAM_TYPE,PRAM_VALUE,PRAM_NAME,EXP_TYPE,PRAM_EXP,RET_NUM "
				+ "FROM IN_BSPRIPARM_DICT where ACTION_ID=#PARAM# and MAIN_SVC=#PARAM#";
		getTabConfig_2("ACTION_ID|LONG#MAIN_SVC|CHAR", destTabMap, sDisKeySql, sDesDataSql, conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("IN_BSPRIPARM_DICT", destTabMap);
		
		/*5.---取IN_BSDATASOURCE_DICT配置--- and rownum < 1000*/
		//此处需注意 IN_BSDATASOURCE_DICT 太多时进行过滤只取全部或部分主服务
		//用例：getDestTabCfgMap("IN_BSDATASOURCE_DICT", "103");

		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct DATASOURCE_ID     DEST_KEY "
				+ "FROM IN_BSDATASOURCE_DICT where rownum < 1000";
		sDesDataSql = "SELECT SRC_TYPE,RET_NUM,DATA_EXP "
				+ "from IN_BSDATASOURCE_DICT where DATASOURCE_ID=#PARAM# order by ret_num ";
		getTabConfig_2("DATASOURCE_ID|LONG", destTabMap, sDisKeySql, sDesDataSql, conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("IN_BSDATASOURCE_DICT", destTabMap);
		
		/*6.---取IN_BSSVC_ATTRGROUP_REL配置--- and rownum < 1000*/
		//用例：getDestTabCfgList("IN_BSSVC_ATTRGROUP_REL", "B01001#8901#M");

		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct A.SVC_ID||'#'||A.ACTION_ID||'#'||A.SVC_TYPE     DEST_KEY "
				+ "from IN_BSSVC_ATTRGROUP_REL A, IN_BSGROUPATTR_REL B "
				+ "where A.ATTR_GRP_ID=B.ATTR_GRP_ID AND B.VALUE_NULL_FLAG='N' and rownum < 1000";
		sDesDataSql = "SELECT GRP_TYPE, ATTR_VALUE, ATTR_NAME, ATTR_NEW_VALUE, VALUE_NULL_FLAG, NODE_NULL_FLAG, DEFAULE_VALUE "
				+ "FROM IN_BSSVC_ATTRGROUP_REL A, IN_BSGROUPATTR_REL B "
				+ "WHERE A.SVC_ID=#PARAM# and A.ACTION_ID=#PARAM# and A.SVC_TYPE=#PARAM# "
				+ "AND A.ATTR_GRP_ID=B.ATTR_GRP_ID AND B.VALUE_NULL_FLAG='N' ORDER BY ATTR_SEQ";
		getTabConfig_2("SVC_ID|CHAR#ACTION_ID|LONG#SVC_TYPE|CHAR", destTabMap, sDisKeySql, sDesDataSql,conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("IN_BSSVC_ATTRGROUP_REL", destTabMap);
		
		/*7.---取PUSH_TEMPLATE配置，全量---*/
		//用例：getDestTabCfgMap("PUSH_TEMPLATE", "31320001");
		destTabMap = new HashMap<String, Object>();
		sDisKeySql = "select distinct TEMPLATE_ID     DEST_KEY "
				   + "from PUSH_TEMPLATE " ;
		sDesDataSql = "SELECT CONTENT, SERV_NAME, PRIORITY_LEVEL, SEND_TYPE, BASESRC, SRC_NO, SMS_TYPE, END_MINUTE_OFFSET "
				   + "FROM PUSH_TEMPLATE WHERE TEMPLATE_ID=#PARAM#" ;
		getTabConfig_2("TEMPLATE_ID|CHAR", destTabMap, sDisKeySql, sDesDataSql, conn);
		//以表名为KEY放入该表的配置信息
		outTabsConfigMap.put("PUSH_TEMPLATE", destTabMap);
		
		DataSourceHelper.closeConnection(conn);
		
		return ;
		
	}
	
	/***********************Getter / Setter Function*********************/

	private static ConcurrentHashMap getTabsconfigmap() {
		return tabsConfigMap;
	}

	private int getLoad_data() {
		return load_data;
	}

	private int getMaxperkey() {
		return maxperkey;
	}

	private int getProcess_time() {
		return process_time;
	}

	private String getAddr() {
		return addr;
	}
	private String getData_source() {
		return data_source;
	}
	

	public void setLoad_data(int load_data) {
		this.load_data = load_data;
	}

	public void setMaxperkey(int maxperkey) {
		this.maxperkey = maxperkey;
	}

	public void setProcess_time(int process_time) {
		this.process_time = process_time;
	}


	public void setAddr(String addr) {
		this.addr = addr;
	}
	public void setData_source(String data_source) {
		this.data_source = data_source;
	}
	
	
	
}
