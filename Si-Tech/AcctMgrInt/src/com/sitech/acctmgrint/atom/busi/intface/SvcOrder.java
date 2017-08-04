package com.sitech.acctmgrint.atom.busi.intface;

import com.sitech.acctmgrint.common.AcctMgrError;
import com.sitech.acctmgrint.common.constant.InterBusiConst;
import com.sitech.jcf.core.exception.BusiException;

import java.util.HashMap;
import java.util.Map;

/**
 * 
 * <p>Title: BOSS服务开通接口实现类</p>
 * <p>Description: BOSS服务开通统一接口实现部分</p>
 * <p>Copyright: Copyright (c) 2006</p>
 * <p>Company: SI-TECH </p>
 * @author konglj
 * @version 1.0
 *
 */
public class SvcOrder extends PubInterComm implements ISvcOrder {
		
	/**
	 * 
	 * Title: 前台缴费等-用户状态变更及指令发送接口</br>
	 * Description: BOSS侧实时停机、缴费开机等调用该接口进行状态变更，及发送指令处理
	 * @param inParamMap:参数（暂定）：
	 * @param HEADER:服务调用时的Header内容。Map类型，必传(不传则按照ID_NO第四位判断A1/B1)
	 * @param ID_NO:用户标识，必传
	 * @param PHONE_NO:号码，必传
	 * @param RUN_CODE:新状态，必传
	 * @param OP_TIME:操作时间,格式:yyyymmddhh24miss，必传
	 * @param LOGIN_ACCEPT:统一流水 ，必传
	 * @param LOGIN_NO:操作工号 ，必传
	 * @param OP_CODE:操作标识，必传
	 * @param OWNER_FLAG:有主无主标示，必传
	 * 					'1'为后台有主，'2'为后台无主,'3'为前台有主,'4'为前台无主
	 * @param OPEN_FLAG:服务开通标识，必传
	 *                  0--只服务开通 1--只更改用户状态 2--即开通又更改用户状态
	 * @param IN_SVC_ACTION:附件服务动作 R K T M N,只在RUN_CODE=Z时有效
	 * @param IN_SVC_ID:附件服务ID,只在RUN_CODE=Z时有效
	 * @param CONTRACT_NO:账号ID
	 * @return 返回true/false
	 * @throws Exception
	 */
	@Override
	public boolean opUserStatuInter(Map<String, Object> inParamMap) {
		System.out.println("SvcOrder ++++++ ");
		
		String sAccceptHead = "";
		String sBsAccept = "";
		String sNewStatus = "";
		String sOpenFlag = "";
		String sOwnerFlag = "";
		String sRealRunCode = "";
		String sCurRunCode = "";
		boolean bRetMsg = false;
		log.info("----operUserStatus interface STT----");
		log.error("svcbegin"+inParamMap.get("PHONE_NO").toString());
		
		/*服务开通中BOSS->CRM流水*/
		String sBcLogAccept = this.getInterLoginAccept("BC");
		if (sBcLogAccept == null) {
			throw new BusiException(AcctMgrError.getErrorCode(
					inParamMap.get("OP_CODE").toString(), "12031"), "Boss->crm同步失败，fwtk流水获取失败！");
		}
		inParamMap.put("BC_LOGIN_ACCEPT", sBcLogAccept);
		
		if(inParamMap.get("RUN_CODE").toString().equals("J")){
			/*发送统一接触的流水*/
			String sCoLogAccept = this.getInterLoginAccept("CO");
			if (sCoLogAccept == null) {
				throw new BusiException(AcctMgrError.getErrorCode(
						inParamMap.get("OP_CODE").toString(), "12031"), "Boss->crm同步失败，fwtk流水获取失败！");
			}
			inParamMap.put("CO_LOGIN_ACCEPT", sCoLogAccept);
		}
		
		/*1.解析入参，转化成Map*/
		inParamMap.put("BC_LOGIN_ACCEPT", sBcLogAccept);
		Map<String, Object> gParamMap = svcOdrParaTrans.transUserStatuPara(inParamMap);
		if (0 == gParamMap.size()) {
			throw new BusiException(AcctMgrError.getErrorCode("0000","11102"),
					"服务开通获取流水错误！请检查。");
		}

		/*2.调用名种原子服务完成业务实现*/
		/*取服务开通流水*/
		sNewStatus = gParamMap.get("RUN_CODE").toString();
		sBsAccept = this.getInterLoginAccept(sNewStatus);
		if (null == sBsAccept) {
			throw new BusiException("10001", "get accept login failed,please check,acHead=", sAccceptHead);
		}
		
		/*对无主停机直接发服开*/
		sOwnerFlag = gParamMap.get("OWNER_FLAG").toString();
		if(sOwnerFlag.equals("2") || sOwnerFlag.equals("4")){
			gParamMap.put("BS_LOGIN_ACCEPT", sBsAccept);
			gParamMap.put("VOLTE_FLAG", "N");
			gParamMap.put("OLD_NEW_RUN", "AB");
			bRetMsg = iSpliceOrder.sendCommandJson(gParamMap);
			if (bRetMsg == false) {
				throw new BusiException(AcctMgrError.getErrorCode(
						gParamMap.get("OP_CODE").toString(), "11105"),
						"FWKT|Send CmdCont Order Failed,please check!!");
			}
			return true;
		}
		
		/*查询、更新用户当前状态*/
		Map<String, String> resultMap = (Map<String, String>)
				baseDao.queryForObject("cs_userdetail_info_INT.qRunCodePhoneNoByIdNo",inParamMap);
		gParamMap.putAll(resultMap);
		
		/*取得合成后状态*/
		Map<String, Object> inMap = new HashMap<String, Object>();	
		inMap.put("BOSS_NEW_RUN", gParamMap.get("RUN_CODE").toString());
		inMap.put("ID_NO", Long.parseLong(gParamMap.get("ID_NO").toString()));
		Map<String, String> resultMap1 = new HashMap<String, String>();
		resultMap1 = (Map<String, String>)baseDao.queryForObject("ur_bosstocrmstate_INT.qRunCodeByBossNewRun",inMap);
		log.debug("-------updateUserStatus 3---resultMap="+resultMap1.toString());
		gParamMap.putAll(resultMap1);
		
		/*报停用户预拆，缴费后直接变成A状态*/
		if (gParamMap.get("REAL_RUN_CODE") != null)
			sRealRunCode = gParamMap.get("REAL_RUN_CODE").toString();
		else 
			sRealRunCode = gParamMap.get("RUN_CODE").toString();
		
		sCurRunCode = gParamMap.get("CUR_RUN_CODE").toString();
		
		if(sRealRunCode.equals("G") &&  sCurRunCode.equals("J")){
			gParamMap.put("REAL_RUN_CODE", "A");
			gParamMap.put("CRM_RUN_CODE", "9");
			 //给CRM发送业务工单的状态为特殊的9，这样9和G合成为A
			((Map<String, Object>)gParamMap.get("BTOC")).put("NEW_STATUS", "9");
		}

		sOpenFlag = gParamMap.get("OPEN_FLAG").toString();
		sOwnerFlag = gParamMap.get("OWNER_FLAG").toString();
		log.info("----operUserStatus interface --sOwnerFlag="+sOwnerFlag + "sOpenFlag="+sOpenFlag);
		if (sOwnerFlag.equals("1") && 
				(sOpenFlag.equals("1") || sOpenFlag.equals("2"))) {
			/*变更状态，同步CRM*/
			if (updateUserStatus(gParamMap) == false) {
				throw new BusiException(AcctMgrError.getErrorCode(
						gParamMap.get("OP_CODE").toString(), "11103"),
						"FWKT|Changing The User's STATUS failed,Please Check!");
			} 
			
			if (sendBcUserStatOdr(gParamMap) == false) {
				throw new BusiException(AcctMgrError.getErrorCode(
						gParamMap.get("OP_CODE").toString(), "11104"),
						"FWKT|Syn CRM msg error,please check!!");
			}
			
			/*预拆发送统一接触*/
			if(gParamMap.get("RUN_CODE").toString().equals("J")){
				if (sendContactOdr(gParamMap) == false) {
					throw new BusiException(AcctMgrError.getErrorCode(
							gParamMap.get("OP_CODE").toString(), "11104"),
							"FWKT|Syn CRM msg error,please check!!");
				}
			}
		}
		
		if ( sOpenFlag.equals("0") || sOpenFlag.equals("2") ) {
			/*调服务开通发指令*/

			if (gParamMap.get("REAL_RUN_CODE") != null)
				sRealRunCode = gParamMap.get("REAL_RUN_CODE").toString();
			else 
				sRealRunCode = gParamMap.get("RUN_CODE").toString();
			
			sCurRunCode = gParamMap.get("CUR_RUN_CODE").toString();
			//DEMO:JA
			gParamMap.put("OLD_NEW_RUN", sCurRunCode + sRealRunCode);
			
			/*若合成的状态不是boss侧状态，给CRM发业务工单，由CRM发送服开指令*/
			inMap = new HashMap<String, Object>();	
			inMap.put("REAL_RUN_CODE", sRealRunCode);
			Map<String, Object> outMap  = (Map<String, Object>) baseDao.queryForObject("in_bsstatustoaction_rel_INT.qBossRunCode", inMap);
			if (outMap.get("CNT").toString().equals("0")) {
				log.info("合成后的状态=["+sRealRunCode+"]不是boss侧状态!!!");
				
				//目前只发这两种情况
				if((sRealRunCode.equals("V") && (sCurRunCode.equals("B") || sCurRunCode.equals("J")))
				|| (sRealRunCode.equals("G") && (sCurRunCode.equals("G") || sCurRunCode.equals("J"))))
				{
					gParamMap.put("BC_LOGIN_ACCEPT", sBsAccept);
					
					((Map<String, Object>)gParamMap.get("BTOC")).put("ORDER_ID", "10011");
					((Map<String, Object>)gParamMap.get("BTOC")).put("CREATE_ACCEPT", sBsAccept);
					
					((Map<String, Object>)gParamMap.get("BTOC")).put("CUR_RUN_CODE", gParamMap.get("CUR_RUN_CODE").toString());
					((Map<String, Object>)gParamMap.get("BTOC")).put("REAL_RUN_CODE", gParamMap.get("REAL_RUN_CODE").toString());
					if (sendBcUserStatOdr(gParamMap) == false) {
						throw new BusiException(AcctMgrError.getErrorCode(
								gParamMap.get("OP_CODE").toString(), "11104"),
								"FWKT|Syn CRM msg error,please check!!");
					}
				}
			}
			else{
				gParamMap.put("BS_LOGIN_ACCEPT", sBsAccept);
				
				bRetMsg = iSpliceOrder.sendCommandJson(gParamMap);
				if (bRetMsg == false) {
					throw new BusiException(AcctMgrError.getErrorCode(
							gParamMap.get("OP_CODE").toString(), "11105"),
							"FWKT|Send CmdCont Order Failed,please check!!");
				}
			}
		}
		
		return true;
	}
	
	/**
	 * Title 局拆接口
	 * Description 
	 */
	@Override
	public boolean opArearStatuInter(Map<String, Object> inParaMap) {
		
		
		
		return false;
	}

}
