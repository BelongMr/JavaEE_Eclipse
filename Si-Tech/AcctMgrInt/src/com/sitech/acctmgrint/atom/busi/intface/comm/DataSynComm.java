package com.sitech.acctmgrint.atom.busi.intface.comm;

import com.sitech.acctmgrint.common.AcctMgrError;
import com.sitech.acctmgrint.common.BaseBusi;
import com.sitech.acctmgrint.common.constant.InterBusiConst;
import com.sitech.acctmgrint.common.utils.ValueUtils;
import com.sitech.jcf.core.exception.BusiException;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Description:BOSS数据同步接口公共方法
 * @author KONGLJ
 *
 */
public class DataSynComm  extends BaseBusi {
	
	public boolean checkInParams(Map<String, Object> inParam, List<Map<String, String>> inListTabIdxs, 
			Map<String, Object> outTabSynFlag) {
		
		log.debug("Boss数据同步查看入参："+inParam.toString());
		
		/*if (inParam.get("ID_NO") == null || inParam.get("ID_NO").equals("")) {
			log.error("Boss数据同步查看入参：ID_NO必传，入参未传入。");
			return false;
		}
		if (inParam.get("PHONE_NO") == null || inParam.get("PHONE_NO").equals("")) {
			log.error("Boss数据同步查看入参：PHONE_NO必传，入参未传入。");
			return false;
		}
		if (inParam.get("CONTRACT_NO") == null || inParam.get("CONTRACT_NO").equals("")) {
			log.error("Boss数据同步查看入参：CONTRACT_NO必传，入参未传入。");
			return false;
		}*/

		boolean allTabCheck = true;
		for (Map<String, String> tmpTabMap:inListTabIdxs) {
			
			boolean bCheck = true;
			String tableName = tmpTabMap.get("TABLE_NAME");
			String sIndexes = tmpTabMap.get("UNIQUE_INDEX");
			String[] arrIdx = sIndexes.split(",");
			for (String idx:arrIdx) {
				if ( inParam.get(idx) == null || inParam.get(idx).equals("") ) {
					allTabCheck = false;
					bCheck = false;
					break;
				}
			}
			outTabSynFlag.put(tableName, bCheck);
		}
		
		return allTabCheck;
	}

	/**
	 * @Description: 根据表配置、列配置获取待查询的列字符串
	 * @param tableMap
	 * @param mapCols
	 * @author: konglj
	 * @createTime: 2015年03月23日
	 * @version:
	 * @return String column,column,column
	 */
	public List<String> getColumns(Map<String, String> tableMap, Map<String, String> mapCols, List<String> keys){
		
		List<String> rstListQryCols = new ArrayList<String>();//需要同步表所有的列名

		String synType = tableMap.get("SYN_ALL_FLAG");//同步方式：全表/字段
		String tableName = tableMap.get("TABLE_NAME");
		//源表查询的列
		if("Y".equals(synType)){//全表同步
			rstListQryCols.add("*");
		}  else if (!"Y".equals(synType)){//字段级同步，则从列配置中取列
			rstListQryCols.add(mapCols.get("COLS_NAME"));
		} else {
			
			if(rstListQryCols.isEmpty()){//字段级同步方式，必须配置列
				throw new BusiException(AcctMgrError.getErrorCode(
				InterBusiConst.ErrInfo.OP_CODE,
				InterBusiConst.ErrInfo.DATASYN+"004"), 
						"表【"+tableName+"】在IN_ACTTABREL_DICT中配置的是字段级同步，必须对此进行配置!");
			}
			
			for(String key : keys){//主键必须作为查询条件，包含分区索引
				if(rstListQryCols.indexOf(key) == -1){
					rstListQryCols.add(key);//主键未配置同步字段的，默认添加查询字段
				}
			}
			
//			// 如果未配置UPDATE_TYPE字段，则默认加上
//			if(rstListQryCols.indexOf("UPDATE_TYPE")==-1){
//				rstListQryCols.add("UPDATE_TYPE");//该字段为后续处理数据依据
//			}
		}
		
		return rstListQryCols;
	}
	
	/**
	 * @Description 根据表配置、入参返回查询条件
	 * @author konglj
	 * @version 
	 * @createTime 2015年03月26日 
	 * @param inKeyVals
	 * @param tableMap
	 * @return
	 */
	public List<DataSynCondition> getConditions(Map<String, String> tableCfg, 
			Map<String, Object> dataMap, List<String> listKeys) {
		
		List<DataSynCondition> outList = new ArrayList<DataSynCondition>();//返回参数
		DataSynCondition dataSynCondition ;
		log.debug("---getcondition---dataMap="+dataMap.toString());
		//加上二维分区条件
		String sOpType = tableCfg.get("UPDATE_TYPE");
		String  twoPartition = "";
		if (sOpType.equals("D")) {
			twoPartition = tableCfg.get("HIS_PARTITION_COL");//历史表二维分区   
		} else {
			twoPartition = tableCfg.get("PARTITION_COL");//正表
		}
		if(ValueUtils.isNotEmpty(twoPartition) && !twoPartition.trim().equals("NULL")){
			dataSynCondition = new DataSynCondition();
			dataSynCondition.setKey(twoPartition);
			Object object = dataMap.get(twoPartition);
			if(object == null){
				throw new BusiException(AcctMgrError.getErrorCode(
						InterBusiConst.ErrInfo.OP_CODE,
						InterBusiConst.ErrInfo.DATASYN+"005"), 
						 "入参："+twoPartition+"不能为空!");
			}
			dataSynCondition.setValue(object);
			
			dataSynCondition.setCompareValue("=");
			dataSynCondition.setType("NOLONG");
			outList.add(dataSynCondition);//历史表二维分区字段
			log.debug("outList.size="+outList.size()
					+"datascon="+dataSynCondition.getKey()
					+"val="+dataSynCondition.getValue()
					+"type="+dataSynCondition.getType()
					+"compare=" +dataSynCondition.getCompareValue()
					);
		}
		
		for (String key:listKeys) {
			
			if (key.equalsIgnoreCase(twoPartition))
				continue;
		
			Object val = dataMap.get(key);
			if (val == null || val.toString().equals(""))
				continue;
			
			//加上其他索引字段
			dataSynCondition = new DataSynCondition();
			dataSynCondition.setKey(key);
			dataSynCondition.setValue(val);
			dataSynCondition.setCompareValue("=");
			dataSynCondition.setType("NOLONG");
			outList.add(dataSynCondition);
			
			log.debug("outList.size="+outList.size()
					+"datasconKey="+dataSynCondition.getKey()
					+"val="+dataSynCondition.getValue()
					+"type="+dataSynCondition.getType()
					+"compare=" +dataSynCondition.getCompareValue()
					);
		}//for END
		
		return outList;
	}

	/**
	 * @Description 根据表配置、入参返回查询条件
	 * @author konglj
	 * @version 
	 * @createTime 2015年03月26日 
	 * @param inKeyVals
	 * @param tableMap
	 * @return
	 */
	public List<DataSynCondition> getIndexConditions(Map<String, String> tableCfg, 
			List<Map<String, Object>> recordIndxes, List<String> listKeys) {
		
		List<DataSynCondition> outList = new ArrayList<DataSynCondition>();//返回参数
		DataSynCondition dataSynCondition ;
		StringBuffer stringBuffer = null;
		
		boolean bFirst = true;
		for (Map<String, Object> idxDataMap:recordIndxes) {
			stringBuffer = new StringBuffer();
			
			bFirst = true;
			Set<String> keySet = idxDataMap.keySet();
			for (String key:keySet) {
				
				if (bFirst == false)
					stringBuffer.append(" AND ");
				else //bFirst == true
					bFirst = false;
				
				stringBuffer.append(key).append("=").append(idxDataMap.get(key));
			}
			
			//加上其他索引字段
			dataSynCondition = new DataSynCondition();
			dataSynCondition.setCompareValue(stringBuffer.toString());
			dataSynCondition.setKey("");
			dataSynCondition.setValue("");
			dataSynCondition.setType("ORTYPE");
			outList.add(dataSynCondition);
		}//for END
		
		return outList;
	}
	

	public List<Map<String, Object>> getDataIndexes(String sqlCont,
			Map<String, Object> inKeyVals, JdbcConn jdbcConn) {
		
		String tmpKey = "";
		String tmpVal = "";
		StringBuffer sqlBuffer = new StringBuffer();
		
		//处理SqlCont语句为ijdbc需要的语句
		////SqlCont=select BALANCE_ID from bal_XXXX_REL where pay_sn = #PAY_SN# and id_no = #ID_NO#
		////Index  =0													1	   2			 3
		String[] strSqls = sqlCont.split("#");
		int halfLen = strSqls.length / 2;
		for (int i = 0; i < halfLen; i++) {
			//2*i+1 为待替换字段
			tmpKey = strSqls[2*i + 1].toUpperCase();
			tmpVal = inKeyVals.get(tmpKey).toString();
			if (tmpVal == null && tmpVal.equals("")) {
				log.debug("Sql配置中，对应tmpKey="+tmpKey+"值未传入，返回null,不处理。");
				return null;
			}
			//2*i 为Sql语句
			sqlBuffer.append(strSqls[2*i]).append("'"+tmpVal+"'");
		}
		
		//查询数据
		jdbcConn.setSqlBuffer(sqlBuffer.toString());
		List<Map<String, Object>> rstList = jdbcConn.select();
		
		return rstList;
	}
	
}