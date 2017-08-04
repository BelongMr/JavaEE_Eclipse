package com.sitech.acctmgr.atom.entity;

import static com.sitech.acctmgr.common.utils.ValueUtils.longValue;
import static org.apache.commons.collections.MapUtils.getLongValue;
import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import com.alibaba.fastjson.JSON;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.domains.balance.BalanceEntity;
import com.sitech.acctmgr.atom.domains.balance.BalanceFlagEnum;
import com.sitech.acctmgr.atom.domains.balance.BookPayoutEntity;
import com.sitech.acctmgr.atom.domains.balance.BookSourceEntity;
import com.sitech.acctmgr.atom.domains.balance.BookTypeEntity;
import com.sitech.acctmgr.atom.domains.balance.BookTypeEnum;
import com.sitech.acctmgr.atom.domains.balance.PrepayEntity;
import com.sitech.acctmgr.atom.domains.balance.ReturnFeeEntity;
import com.sitech.acctmgr.atom.domains.balance.SpecBalaceEntity;
import com.sitech.acctmgr.atom.domains.balance.TransFeeEntity;
import com.sitech.acctmgr.atom.domains.base.LoginBaseEntity;
import com.sitech.acctmgr.atom.domains.bill.FeeEntity;
import com.sitech.acctmgr.atom.domains.bill.UnbillEntity;
import com.sitech.acctmgr.atom.domains.invoice.InvoMutiMonEntity;
import com.sitech.acctmgr.atom.domains.pay.BatchPayRecdEntity;
import com.sitech.acctmgr.atom.domains.pay.CRMIntellPrtEntity;
import com.sitech.acctmgr.atom.domains.pay.MonthReturnFeeEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayTypeEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.pub.PubWrtoffCtrlEntity;
import com.sitech.acctmgr.atom.domains.query.SpFeeRecycleEntity;
import com.sitech.acctmgr.atom.domains.query.TdUnifyPayEntity;
import com.sitech.acctmgr.atom.domains.query.TransLimitEntity;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.util.DateUtil;

/**
 * <p>
 * Title: 公共预存款类
 * </p>
 * <p>
 * Description:
 * </p>
 * <p>
 * Copyright: Copyright (c) 2014
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 *
 * @author qiaolin
 * @version 1.0
 */
@SuppressWarnings("unchecked")
public class Balance extends BaseBusi implements IBalance {

	private IBill bill;
	private IControl control;
	private IAccount account;
	private IPreOrder preOrder;

	@Override
	public Map<String, Object> getConMsgFee(long lContractNo) {
		boolean realFlag = bill.isOnlineForQry(lContractNo);
		return this.getConMsgFee(lContractNo, realFlag);
	}

	public Map<String, Object> getConMsgFee(long lContractNo, boolean isOnline) {

		Map<String, Object> inMap = null;

		long lTotalBalance = 0;
		int iSpecialFlag = 0;
		long lPrepayFee = 0;
		long lGPrepayFee = 0;
		List<Map<String, Object>> specialList = new ArrayList<Map<String, Object>>();

		Map<String, Object> outMap = new HashMap<String, Object>();
		if (isOnline) {
			UnbillEntity unbillEntity = bill.getUnbillFee(lContractNo, CommonConst.UNBILL_TYPE_PRE, isOnline); /* 取未出帐余额列表 */
			List<BalanceEntity> acctbookList = unbillEntity.getAcctBookList();

			// 取专款账本类型
			inMap = new HashMap<String, Object>();
			inMap.put("PAY_ATTR", "0");
			List<Map<String, Object>> payTypeList = baseDao.queryForList("bal_booktype_dict.qrySpecialType", inMap);

			List<SpecBalaceEntity> specList = new ArrayList<SpecBalaceEntity>();

			int iSpecCnt = 0;
			for (BalanceEntity balent : acctbookList) {
				String sPayType = balent.getPayType();
				long lCurBal = balent.getCurBalance();
				long lInitBal = balent.getInitBalance();

				int sSpecialFlag = 0;
				for (Map<String, Object> payTypeMap : payTypeList) {
					if (payTypeMap.get("PAY_TYPE").toString().equals(sPayType)) {
						// 该账本是专款账本
						lGPrepayFee += lCurBal;
						sSpecialFlag = 1;

						if (iSpecCnt == 0) {
							SpecBalaceEntity specBal = new SpecBalaceEntity();
							specBal.setCurBalance(lCurBal);
							specBal.setInitBalance(lInitBal);
							specBal.setPayType(sPayType);
							specBal.setSpecialFlag("0");

							specList.add(specBal);

							iSpecCnt++;

							break;
						}

						int iAddFlag = 0;
						for (SpecBalaceEntity spec : specList) {
							if (spec.getPayType().equals(sPayType)) {
								long lBal = spec.getCurBalance();
								long lint = spec.getInitBalance();
								spec.setCurBalance(lBal + lCurBal);
								spec.setInitBalance(lint + lInitBal);
								iAddFlag++;

								break;
							}
						}

						if (iAddFlag == 0) {
							SpecBalaceEntity specBal = new SpecBalaceEntity();
							specBal.setCurBalance(lCurBal);
							specBal.setInitBalance(lInitBal);
							specBal.setPayType(sPayType);
							specBal.setSpecialFlag("0");

							specList.add(specBal);

							iSpecCnt++;
						}

						break;
					}
				}

				if (sSpecialFlag == 1) {
					continue;
				}

				lPrepayFee += lCurBal;
			}

			lTotalBalance = lPrepayFee + lGPrepayFee;

			for (SpecBalaceEntity spec : specList) {
				Map<String, Object> specMap = new HashMap<String, Object>();
				specMap.put("CUR_BALANCE", spec.getCurBalance());
				specMap.put("INIT_BALANCE", spec.getInitBalance());
				specMap.put("PAY_TYPE", spec.getPayType());
				specMap.put("SPECIAL_FLAG", spec.getSpecialFlag());
				specialList.add(specMap);
			}

			iSpecialFlag = lGPrepayFee > 0 ? 1 : 0;

		} else {
			outMap = this.getOffConMsgFee(lContractNo);
			lTotalBalance = Long.parseLong(outMap.get("TOTAL_PREPAY").toString());
			iSpecialFlag = Integer.parseInt(outMap.get("FLAG").toString());
			lPrepayFee = Long.parseLong(outMap.get("PREPAY_FEE").toString());
			lGPrepayFee = Long.parseLong(outMap.get("GPREPAY_FEE").toString());
			specialList = (List<Map<String, Object>>) outMap.get("GPREPAY_LIST");
		}

		Map<String, Object> outParam = new HashMap<String, Object>();
		outParam.put("TOTAL_PREPAY", lTotalBalance);
		outParam.put("FLAG", iSpecialFlag);
		outParam.put("PREPAY_FEE", lPrepayFee); // 当前预存
		outParam.put("GPREPAY_FEE", lGPrepayFee); // 专款预存
		outParam.put("GPREPAY_LIST", specialList); // 专款账本列表

		return outParam;
	}

	/**
	 * 离网帐户账本信息
	 *
	 * @param lContractNo
	 * @return
	 */
	private Map<String, Object> getOffConMsgFee(long lContractNo) {
		Map<String, Object> outParam = null; /* 变量:出参 */

		Map<String, Object> inMap = new HashMap<String, Object>();
		Map<String, Object> result = null;

		int iWrtoffFlag = 0; /* 出帐标志 */
		int iWrtoffMonth = 0; /* 出帐年月 */
		long lPrepayFeeTotal = 0; /* 帐户总金额 */
		long lGPrepayFee = 0; /* 帐本金额 */
		long lPrepayFee = 0; /* 普通预存 */
		int iSpecialFlag = 0; /* 特殊专款标志 */

		/* 取出账标志与出账年月 */
		PubWrtoffCtrlEntity wrtoffCtrlEntity = control.getWriteOffFlagAndMonth();
		iWrtoffFlag = Integer.parseInt(wrtoffCtrlEntity.getWrtoffFlag());
		iWrtoffMonth = wrtoffCtrlEntity.getWrtoffMonth();

		/* 取专款帐本预存 */
		inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", lContractNo);
		inMap.put("SPECIAL_FLAG", "0");
		inMap.put("WRTOFF_FLAG", iWrtoffFlag);
		inMap.put("WRTOFF_MONTH", iWrtoffMonth);
		result = this.getAcctBookGroup(inMap);
		List<Map<String, Object>> specialList = (List<Map<String, Object>>) result.get("ACCTBOOK_LIST");
		for (Map<String, Object> specialMap : specialList) {
			lGPrepayFee += Long.parseLong(specialMap.get("CUR_BALANCE").toString());
		}

		if (lGPrepayFee > 0) {
			iSpecialFlag = 1;
		}

		/* 取普通帐本费用 */
		lPrepayFeeTotal = this.getAcctBookSum(lContractNo, null);

		lPrepayFee = lPrepayFeeTotal - lGPrepayFee;

		outParam = new HashMap<String, Object>();
		outParam.put("TOTAL_PREPAY", lPrepayFeeTotal);
		outParam.put("FLAG", iSpecialFlag);
		outParam.put("PREPAY_FEE", lPrepayFee); // 当前预存
		outParam.put("GPREPAY_FEE", lGPrepayFee); // 专款预存
		outParam.put("GPREPAY_LIST", specialList); // 专款账本列表

		return outParam;
	}

	@Override
	public Map<String, Object> getAcctBookGroup(Map<String, Object> inParam) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = null;
		Map<String, Object> outParam = new HashMap<String, Object>();
		List<Map<String, Object>> outList = new ArrayList<Map<String, Object>>();

		long lContractNo = 0;
		lContractNo = Long.parseLong(inParam.get("CONTRACT_NO").toString());

		inMap.put("CONTRACT_NO", lContractNo);

		String sSpecFlag = "";

		if (inParam.get("SPECIAL_FLAG") != null && !inParam.get("SPECIAL_FLAG").equals("")) {
			sSpecFlag = inParam.get("SPECIAL_FLAG").toString();
			inMap.put("SPECIAL_FLAG", (String) inParam.get("SPECIAL_FLAG"));
		}

		if (inParam.get("PAY_ATTR") != null && !inParam.get("PAY_ATTR").equals("")) {
			inMap.put("PAY_ATTR", inParam.get("PAY_ATTR"));
		}

		if (inParam.get("PAY_TYPE") != null && !inParam.get("PAY_TYPE").equals("")) {
			inMap.put("PAY_TYPE", inParam.get("PAY_TYPE"));
		}

		int iWrtoffFlag = 0;
		int iWrtoffMonth = 0;

		PubWrtoffCtrlEntity wrtoffCtrlEntity = control.getWriteOffFlagAndMonth();
		iWrtoffFlag = Integer.parseInt(wrtoffCtrlEntity.getWrtoffFlag());
		iWrtoffMonth = wrtoffCtrlEntity.getWrtoffMonth();

		if (iWrtoffFlag > 0 && iWrtoffMonth != 0) {
			inMap.put("WRTOFF_MONTH", iWrtoffMonth);
			resultList = baseDao.queryForList("bal_acctbook_info.qGetAcctbookTypeByColWrtoffTime", inMap);
		} else {
			resultList = baseDao.queryForList("bal_acctbook_info.qGetAcctbookTypeByCol", inMap);
		}

		if (resultList.size() == 0) {
			if (!sSpecFlag.equals("0")) {
				Map<String, Object> tempMap = new HashMap<String, Object>();
				tempMap.put("PAY_TYPE", "0");
				tempMap.put("SPECIAL_FLAG", "1");
				tempMap.put("BACK_FLAG", "0");
				tempMap.put("CUR_BALANCE", 0);
				tempMap.put("INIT_BALANCE", 0);
				outList.add(tempMap);
			}
		} else {
			outList.addAll(resultList);
		}

		outParam.put("ACCTBOOK_LIST", outList);

		return outParam;
	}

	public long getAcctBookSum(long contractNo, String payType) {

		// 出帐不停业务
		PubWrtoffCtrlEntity outMapTmp = control.getWriteOffFlagAndMonth();
		int iWrtoffFlag = Integer.parseInt(outMapTmp.getWrtoffFlag());
		int iWrtoffMonth = outMapTmp.getWrtoffMonth();

		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		long balance = 0;
		inMapTmp.put("CONTRACT_NO", contractNo);
		if (payType != null && !payType.equals("")) {
			inMapTmp.put("PAY_TYPE", payType);
		}
		if (iWrtoffFlag > 0 && iWrtoffMonth != 0) {
			inMapTmp.put("WRTOFF_MONTH", iWrtoffMonth);
			balance = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByWrtoffTime", inMapTmp);
		} else {
			balance = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByCol", inMapTmp);
		}

		return balance;
	}

	public long getIneffectiveBalance(long contractNo) {

		// 出帐不停业务
		PubWrtoffCtrlEntity outMapTmp = control.getWriteOffFlagAndMonth();
		int iWrtoffFlag = Integer.parseInt(outMapTmp.getWrtoffFlag());
		int iWrtoffMonth = outMapTmp.getWrtoffMonth();

		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		long balance = 0;
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("EXP", "EXP");
		if (iWrtoffFlag > 0 && iWrtoffMonth != 0) {
			inMapTmp.put("WRTOFF_MONTH", iWrtoffMonth);
			balance = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByWrtoffTime", inMapTmp);
		} else {
			balance = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByCol", inMapTmp);
		}

		return balance;
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IBalance#getAcctBookDeadList(java .util.Map) */
	@Override
	public long getAcctBookDeadSum(Map<String, Object> inParam) {

		Map<String, Object> inMap = new HashMap<String, Object>(); // 临时变量入参转为map

		long contractNo = Long.parseLong(inParam.get("CONTRACT_NO").toString());

		if (inParam.get("TRANS_FLAG") != null && !inParam.get("TRANS_FLAG").equals("")) {
			inMap.put("TRANS_FLAG", inParam.get("TRANS_FLAG").toString());
		}
		if (inParam.get("BALANCE_ID") != null && !inParam.get("BALANCE_ID").equals("")) {
			inMap.put("BALANCE_ID", inParam.get("BALANCE_ID").toString());
		}
		if (inParam.get("PAY_TYPE_STR") != null && !inParam.get("PAY_TYPE_STR").equals("")) {
			inMap.put("PAY_TYPE_STR", inParam.get("PAY_TYPE_STR"));
		}

		inMap.put("CONTRACT_NO", contractNo);
		// 获取账户预存
		return (long) baseDao.queryForObject("bal_acctbook_dead.qAcctBookDeadByCon", inMap);
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IBalance#getAcctBookList(java.util .Map) */
	public List<Map<String, Object>> getAcctBookList(Map<String, Object> inParam) {

		HashMap<String, Object> inParamMap = new HashMap<String, Object>(); // 临时变量入参转为map

		long lContractNo = Long.parseLong(inParam.get("CONTRACT_NO").toString());

		if (inParam.get("PAY_TYPE") != null && !inParam.get("PAY_TYPE").equals("")) {
			inParamMap.put("PAY_TYPE", inParam.get("PAY_TYPE").toString());
		}
		if (inParam.get("SPECIAL_FLAG") != null && !inParam.get("SPECIAL_FLAG").equals("")) {
			inParamMap.put("SPECIAL_FLAG", inParam.get("SPECIAL_FLAG").toString());
		}
		if (inParam.get("BACK_FLAG") != null && !inParam.get("BACK_FLAG").equals("")) {
			inParamMap.put("BACK_FLAG", inParam.get("BACK_FLAG").toString());
		}
		if (inParam.get("TRANS_FLAG") != null && !inParam.get("TRANS_FLAG").equals("")) {
			inParamMap.put("TRANS_FLAG", inParam.get("TRANS_FLAG").toString());
		}
		if (inParam.get("FOREIGN_SN") != null && !inParam.get("FOREIGN_SN").equals("")) {
			inParamMap.put("FOREIGN_SN", inParam.get("FOREIGN_SN").toString());
		}
		if (inParam.get("ORDER_DESC") != null && !inParam.get("ORDER_DESC").equals("")) {
			inParamMap.put("ORDER_DESC", inParam.get("ORDER_DESC").toString());
		}

		if (inParam.get("PAY_TYPE_STR") != null && !inParam.get("PAY_TYPE_STR").equals("")) {
			// inParamMap.put("PAY_TYPE_STR", inParam.get("PAY_TYPE_STR").toString()); // payTypeStr为逗号‘,’隔开的字符串，例如:'3','d','0'
			inParamMap.put("PAY_TYPE_STR", inParam.get("PAY_TYPE_STR").toString().split("\\,")); // payTypeStr为逗号‘,’隔开的字符串，例如:'3','d','0'
		}
		if (StringUtils.isNotEmptyOrNull(inParam.get("QUERY_TIME"))) {
			inParamMap.put("QUERY_TIME", inParam.get("QUERY_TIME").toString());
		}
		if (StringUtils.isNotEmptyOrNull(inParam.get("BEGIN_DATE"))) {
			inParamMap.put("BEGIN_DATE", inParam.get("BEGIN_DATE"));
		}

		inParamMap.put("CONTRACT_NO", lContractNo);
		List<Map<String, Object>> resultList = baseDao.queryForList("bal_acctbook_info.qGetAcctbookByCon", inParamMap);
		return resultList;
	}


	@Override
	public List<Map<String, Object>> getDeadBookList(Map<String, Object> inParam) {
		return baseDao.queryForList("bal_acctbook_dead.qGetAcctbookDeadByCon", inParam);
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IBalance#getSumTransFee(long, java.lang.String) */
	@Override
	public long getSumTransFee(long contractNo, String payAttr) {
		// 出帐不停业务
		PubWrtoffCtrlEntity outMapTmp = control.getWriteOffFlagAndMonth();
		int iWrtoffFlag = Integer.parseInt(outMapTmp.getWrtoffFlag());
		int iWrtoffMonth = outMapTmp.getWrtoffMonth();

		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		long balance = 0;
		inMapTmp.put("CONTRACT_NO", contractNo);
		if (payAttr != null && !payAttr.equals("")) {
			inMapTmp.put("PAY_ATTR4", payAttr);
		}
		if (iWrtoffFlag > 0 && iWrtoffMonth != 0) {
			inMapTmp.put("WRTOFF_MONTH", iWrtoffMonth);
			balance = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByWrtoffTime", inMapTmp);
		} else {
			balance = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByCol", inMapTmp);
		}

		return balance;
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IBalance#getSumTransDeadFee(long, java.lang.String) */
	@Override
	public long getSumTransDeadFee(long contractNo, String payAttr) {
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		Long balacne = null; // 可转预存

		inMapTmp.put("CONTRACT_NO", contractNo);
		if (payAttr != null && !payAttr.equals("")) {
			inMapTmp.put("TRANS_FLAG", payAttr);
		}

		balacne = (Long) baseDao.queryForObject("bal_acctbook_dead.qAcctBookDeadByCon", inMapTmp);

		return balacne.longValue();
	}

	@Override
	public long getSumBalacneByPayTypes(long contractNo, String payTypeStr) {

		Map<String, Object> inMapTmp = null;

		// 出帐不停业务
		PubWrtoffCtrlEntity outMapTmp = control.getWriteOffFlagAndMonth();
		int iWrtoffFlag = Integer.parseInt(outMapTmp.getWrtoffFlag());
		int iWrtoffMonth = outMapTmp.getWrtoffMonth();

		inMapTmp = new HashMap<String, Object>();
		long balance = 0L;
		inMapTmp.put("CONTRACT_NO", contractNo);
		if (payTypeStr != null && !payTypeStr.equals("")) {
			// inMapTmp.put("PAY_TYPE_STR", payTypeStr); // payTypeStr为逗号‘,’隔开的字符串，例如:'3','d','0'
			inMapTmp.put("PAY_TYPE_STR", payTypeStr.split("\\,"));
		}
		if (iWrtoffFlag > 0 && iWrtoffMonth != 0) {
			inMapTmp.put("WRTOFF_MONTH", iWrtoffMonth);
			balance = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByWrtoffTime", inMapTmp);
		} else {
			balance = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByCol", inMapTmp);
		}

		return balance;
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getBookTypeDict(Map<String, Object> inParam) {

		Map<String, Object> result = (Map<String, Object>) baseDao.queryForObject("bal_booktype_dict.qBookTypeDictByType", inParam);

		if (result == null) {
			log.info("query bal_booktype_dict.qBookTypeDictByType is null! PAY_TYPE = " + (String) inParam.get("PAY_TYPE"));
			throw new BusiException(AcctMgrError.getErrorCode("0000", "00047"), "查询bal_booktype_dict出错！");
		}

		return result;
	}

	@Override
	public int updateAcctBook(Map<String, Object> inParam) {
		return baseDao.update("bal_acctbook_info.uAcctbookByBalance", inParam);
	}

	@Override
	public int updateAcctBookDead(long balanceId, long payedOwe) {
		Map<String, Object> inParam = new HashMap<String, Object>();
		inParam.put("BALANCE_ID", balanceId);
		inParam.put("PAYED_OWE", payedOwe);
		return baseDao.update("bal_acctbook_dead.uAcctbookDeadByBalance", inParam);
	}

	@Override
	public void removeAcctBook(long contractNo, String loginNo) {
		removeAcctBook(contractNo, loginNo, null, null);
	}
	
	@Override
	public void removeAcctBook(long contractNo, String loginNo, Long updateAccept, String opCode){
		
		Map<String, Object> inTmpMap = null; // 临时变量入参转为map

		String sCurDate = DateUtil.format(new Date(), "yyyyMMdd");
		long sCurYm = Long.parseLong(sCurDate.substring(0, 6));
		
		inTmpMap = new HashMap<String, Object>();
		inTmpMap.put("CONTRACT_NO", contractNo);
		int cnt = (Integer)baseDao.queryForObject("bal_acctbook_info.qCnt0Curbalance", inTmpMap);
		if(cnt == 0){
			log.debug("没有预存款为0的账本！contract_no:" + contractNo);
			return;
		}
		
		// 入账本表历史表
		this.saveAcctbookHis(contractNo, null, loginNo, updateAccept, "D", opCode);

		// 删除cur_balance=0 的记录
		inTmpMap = new HashMap<String, Object>();
		inTmpMap.put("CONTRACT_NO", contractNo);
		baseDao.delete("bal_acctbook_info.delAcctbook", inTmpMap);
		log.debug("------------>delAcctbook end");
	}
	
	public void saveAcctbookHis(long contractNo, Long balanceId, String loginNo, Long updateAccept, String updateType, String opCode){
		
		log.debug("saveAcctbookHis begin: ");
		
		String sCurDate = DateUtil.format(new Date(), "yyyyMMdd");
		long sCurYm = Long.parseLong(sCurDate.substring(0, 6));
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		if(balanceId != 0){
			inMap.put("BALANCE_ID", balanceId);
		}else{
			inMap.put("CUR_BALANCE", 0);
		}
		inMap.put("LOGIN_NO", loginNo);
		if(updateAccept != null){
			inMap.put("UPDATE_ACCEPT", updateAccept);
		}
		if(updateType != null){
			inMap.put("UPDATE_TYPE", updateType);
		}else{
			inMap.put("UPDATE_TYPE", "D");
		}
		if(opCode!=null){
			inMap.put("UPDATE_CODE", opCode);
		}
		inMap.put("YEAR_MONTH", sCurYm);
		baseDao.insert("bal_acctbook_his.iAcctbookHis", inMap);
	}

	@Override
	public void removeAcctBookDead(long contractNo, String loginNo,Long updateAccept, String opCode) {
		Map<String, Object> inTmpMap = null; // 临时变量入参转为map

		// 入账本表bal_acctbook_x
		inTmpMap = new HashMap<String, Object>();
		inTmpMap.put("CONTRACT_NO", contractNo);
		inTmpMap.put("LOGIN_NO", loginNo);
		inTmpMap.put("PAY_SN", updateAccept);
		inTmpMap.put("UPDATE_CODE", opCode);
		baseDao.insert("bal_acctbook_his.iAcctbookHisFromDead", inTmpMap);
		log.debug("------------>iAcctbookHis  end");

		// 删除cur_balance=0 的记录
		inTmpMap = new HashMap<String, Object>();
		inTmpMap.put("CONTRACT_NO", contractNo);
		baseDao.delete("bal_acctbook_dead.delAcctBookDead", inTmpMap);
		log.debug("------------>delAcctbook end");
	}

	@Override
	public void saveSource(Map<String, Object> inParam) {
		HashMap<String, Object> inTmpMap = null; // 临时变量入参转为map
		String endTime = PayBusiConst.END_TIME2;

		long payFee = Long.parseLong(inParam.get("PAY_FEE").toString());
		String beginTime = inParam.get("BEGIN_TIME").toString();
		if (inParam.get("END_TIME") != null && !inParam.get("END_TIME").equals("")) {
			endTime = inParam.get("END_TIME").toString();
		}

		/* 取当前年月和当前时间 */
		String curTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String curYm = curTime.substring(0, 6);

		/* 入缴费来源表bal_booksource_yyyymm */
		inTmpMap = new HashMap<String, Object>();
		inTmpMap.put("PAY_SN", getLongValue(inParam, "PAY_SN"));
		inTmpMap.put("CONTRACT_NO", getLongValue(inParam, "CONTRACT_NO"));
		inTmpMap.put("ID_NO", getLongValue(inParam, "ID_NO"));
		inTmpMap.put("BALANCE_ID", getLongValue(inParam, "BALANCE_ID"));
		inTmpMap.put("PAY_TYPE", inParam.get("PAY_TYPE").toString());
		inTmpMap.put("PAY_FEE", payFee);
		inTmpMap.put("STATUS", inParam.get("STATUS").toString());
		inTmpMap.put("GROUP_ID", inParam.get("GROUP_ID").toString());
		inTmpMap.put("LOGIN_NO", inParam.get("LOGIN_NO").toString());
		inTmpMap.put("BEGIN_TIME", beginTime);
		inTmpMap.put("END_TIME", endTime);
		inTmpMap.put("YEAR_MONTH", curYm);
		baseDao.insert("bal_booksource_info.iBooksource", inTmpMap);
	}

	public void saveSource(PayUserBaseEntity payUserBase, PayBookEntity inBook) {

		/* 入缴费来源表bal_booksource_yyyymm */
		Map<String, Object> inTmpMap = new HashMap<String, Object>();
		inTmpMap.putAll(payUserBase.toMap());
		inTmpMap.putAll(inBook.toMap());
		baseDao.insert("bal_booksource_info.iBooksource", inTmpMap);

	}

	public void saveAcctBook(Map<String, Object> inParam) {

		String endTime = PayBusiConst.END_TIME2;
		String foreignSn = "";
		String printFlag = "0";

		long payFee = Long.parseLong(inParam.get("PAY_FEE").toString());
		if (inParam.get("END_TIME") != null && !inParam.get("END_TIME").equals("")) {
			endTime = (String) inParam.get("END_TIME");
		}
		if (inParam.get("PRINT_FLAG") != null && !inParam.get("PRINT_FLAG").equals("")) {
			printFlag = (String) inParam.get("PRINT_FLAG");
		}
		if (inParam.get("FOREIGN_SN") != null && !inParam.get("FOREIGN_SN").equals("")) {
			foreignSn = (String) inParam.get("FOREIGN_SN");
		}

		/* 取出账标志出账期间balance_type ：1非出账期间balance_type : 0 */
		String balanceType = "";
		PubWrtoffCtrlEntity outMapTmp = control.getWriteOffFlagAndMonth();
		int iWrtoffFlag = Integer.parseInt(outMapTmp.getWrtoffFlag());
		if (1 == iWrtoffFlag) {
			balanceType = "1"; // 出账期间
		} else {
			balanceType = "0"; // 非出账期间
		}

		/* 入账本表bal_acctbook_info */
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("BALANCE_ID", inParam.get("BALANCE_ID"));
		inMapTmp.put("CONTRACT_NO", inParam.get("CONTRACT_NO"));
		inMapTmp.put("PAY_TYPE", inParam.get("PAY_TYPE"));
		inMapTmp.put("INIT_BALANCE", payFee);
		inMapTmp.put("CUR_BALANCE", payFee);
		inMapTmp.put("BALANCE_TYPE", balanceType);
		inMapTmp.put("BEGIN_TIME", inParam.get("BEGIN_TIME"));
		inMapTmp.put("END_TIME", endTime);
		inMapTmp.put("PAY_SN", inParam.get("PAY_SN"));
		inMapTmp.put("PRINT_FLAG", printFlag);
		inMapTmp.put("FOREIGN_SN", foreignSn);
		baseDao.insert("bal_acctbook_info.iAcctbook", inMapTmp);

	}

	public void saveAcctBook(PayUserBaseEntity payUserBase, PayBookEntity inBook) {
		
		log.debug("saveAcctBook begin: " + inBook.toString());
		
		// 校验账本类型是否存在
		if(!isPayTypeExist(inBook.getPayType())){
			
			throw new BusiException(AcctMgrError.getErrorCode("0000", "00077"), "该账本类型不存在!" + inBook.getPayType());
		}

		/* 取出账标志出账期间balance_type ：1非出账期间balance_type : 0 */
		String balanceType = "";
		PubWrtoffCtrlEntity outMapTmp = control.getWriteOffFlagAndMonth();
		int iWrtoffFlag = Integer.parseInt(outMapTmp.getWrtoffFlag());
		if (1 == iWrtoffFlag) {
			balanceType = "1"; // 出账期间
		} else {
			balanceType = "0"; // 非出账期间
		}
		inBook.setBalanceType(balanceType);
		
		String	printFlag = "0";
		if(inBook.getPrintFlag() == null || inBook.getPrintFlag().equals("")){
			inBook.setPrintFlag(printFlag);
		}

		Map<String, Object> inMap = new HashMap<>();
		Map<String, Object> payUserMap = JSON.parseObject(JSON.toJSONString(payUserBase), Map.class);
		Map<String, Object> inBookMap = JSON.parseObject(JSON.toJSONString(inBook), Map.class);
		inMap.putAll(payUserMap);
		inMap.putAll(inBookMap);
				inMap.put("INIT_BALANCE",inBookMap.get("PAY_FEE"));
		inMap.put("CUR_BALANCE", inBookMap.get("PAY_FEE"));
		baseDao.insert("bal_acctbook_info.iAcctbook", inMap);
	}

	@SuppressWarnings("unchecked")
	public void saveAcctBookDead(PayUserBaseEntity payUserBase, PayBookEntity inBook) {
		/* 取出账标志出账期间balance_type ：1非出账期间balance_type : 0 */
		String balanceType = "";
		PubWrtoffCtrlEntity outMapTmp = control.getWriteOffFlagAndMonth();
		int iWrtoffFlag = Integer.parseInt(outMapTmp.getWrtoffFlag());
		if (1 == iWrtoffFlag) {
			balanceType = "1"; // 出账期间
		} else {
			balanceType = "0"; // 非出账期间
		}
		inBook.setBalanceType(balanceType);

		Map<String, Object> inMap = new HashMap<>();
		Map<String, Object> payUserMap = JSON.parseObject(JSON.toJSONString(payUserBase), Map.class);
		Map<String, Object> inBookMap = JSON.parseObject(JSON.toJSONString(inBook), Map.class);
		inMap.putAll(payUserMap);
		inMap.putAll(inBookMap);
		inMap.put("INIT_BALANCE", inBookMap.get("PAY_FEE"));
		inMap.put("CUR_BALANCE", inBookMap.get("PAY_FEE"));
		baseDao.insert("bal_acctbook_dead.iAcctbookDead", inMap);
		saveSource(payUserBase, inBook);
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IBalance#saveRtwroffChg(java.util .Map) */
	public void saveRtwroffChg(Map<String, Object> inParam) {

		log.debug("saveRtwroffChg begin: " + inParam.toString());

		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;

		long contractNo = (Long) inParam.get("CONTRACT_NO");
		String wrtoffFlag = inParam.get("WRTOFF_FLAG").toString(); // 同步标识 1:缴费同步 2:冲销同步

		String jFlag = "1"; // 预拆状态是否恢复 0 不恢复 1 恢复 (其它状态也入1，默认要做开机)
		if (inParam.get("J_FLAG") != null && !inParam.get("J_FLAG").toString().equals("")) {
			jFlag = inParam.get("J_FLAG").toString();
		}

		Map<String, Object> header = new HashMap<String, Object>();
		if (inParam.get("Header") != null && !inParam.get("Header").toString().equals("")) {
			header = (Map<String, Object>) inParam.get("Header");
		}
		String sHeader = JSON.toJSONString(header);
		log.debug("Header： " + sHeader);

		PubWrtoffCtrlEntity wrtoffCtrlEntity = control.getWriteOffFlagAndMonth();
		String iWrtoffFlag = wrtoffCtrlEntity.getWrtoffFlag();
		String billFlag = "0"; // 0：未出账 1：出账期间
		if (iWrtoffFlag.equals("1")) { // 出账期间
			billFlag = "1";
		}

		long hisOweFee = bill.getSumUnpayInfo(contractNo, null, null).get("OWE_FEE");

		// 判断在线、离线，决定入表是触发实时销账在走开机还是 直接触发开机
		String taskFlag = ""; // A：实时销账 ,B：开机

		String status = ""; // 正常入0 离线入1 实销处理后不同步开机 传4(销户退预存款传该值)
		if (inParam.get("STATUS") != null && !inParam.get("STATUS").toString().equals("")) {

			status = inParam.get("STATUS").toString();
		}

		if (control.isOnLineBill(contractNo)) {

			// 在线情况，如果集团账户 TASK_FLAG ='G' 其它 为A
			if (account.isGrpCon(contractNo)) {

				taskFlag = "G";
			} else {
				taskFlag = "A";
			}

			if (status.equals("")) {
				status = "0";
			}

		} else {

			taskFlag = "B";
			status = "1";

		}

		// 获取工单流水
		//long wsSn = control.getSequence("SEQ_SYSTEM_SN");
		long wsSn = 99999999999999L;
		
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("WS_SN", wsSn);
		inMapTmp.put("CONTRACT_NO", contractNo);

		if (wrtoffFlag.equals("1")) {

			inMapTmp.put("BALANCE_ID", inParam.get("BALANCE_ID"));
			inMapTmp.put("WRTOFF_FLAG", "1");

		} else if (wrtoffFlag.equals("2")) {

			// 按账户同步时，先把之前未处理的账户 同步实时销账数据移入历史表
			Map<String, Object> dMap = new HashMap<String, Object>();
			dMap.put("CONTRACT_NO", contractNo);
			baseDao.insert("int_rtwrtoff_chg.irtWrtoffChgHis", dMap);

			baseDao.delete("int_rtwrtoff_chg.dRtwrtoffChg", dMap);

			inMapTmp.put("BALANCE_ID", 0);
			inMapTmp.put("WRTOFF_FLAG", "2");

		} else {

			throw new BusiException(AcctMgrError.getErrorCode("0000", "00069"), "WRTOFF_FLAG同步标识传错误！");
		}

		inMapTmp.put("BILL_FLAG", billFlag);
		inMapTmp.put("TASK_FLAG", taskFlag);
		inMapTmp.put("HOST_ID", "");
		inMapTmp.put("HIS_FEE", hisOweFee);
		inMapTmp.put("STATUS", status);
		inMapTmp.put("PAY_SN", inParam.get("PAY_SN"));
		inMapTmp.put("REMARK", inParam.get("REMARK"));
		inMapTmp.put("J_FLAG", jFlag);
		inMapTmp.put("HEADER_STR", sHeader);
		baseDao.insert("int_rtwrtoff_chg.iRtwrtoffChg", inMapTmp);

	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IBalance#isCrmCardInvPrint(java. lang.String) */
	public boolean isCrmCardInvPrint(String cardId) {

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CARD_ID", cardId);
		Integer cnt = (Integer) baseDao.queryForObject("bal_cardinvprint_info.qryCnt", inMap);

		if (cnt.intValue() > 0) {
			return true;
		} else {
			return false;
		}

	}

	@Override
	public int getPayCnt(Map<String, Object> inParam) {

		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		Map<String, Object> outPram = new HashMap<String, Object>();

		/* 取当前年月 */
		String sCurYm = DateUtil.format(new Date(), "yyyyMM");

		List<Map<String, Object>> paySnList = (List<Map<String, Object>>) inParam.get("PAY_LIST");
		List<String> paySnStr = new ArrayList<String>();
		int num = 0;
		for (Map<String, Object> paySnMap : paySnList) {
			paySnStr.add(paySnMap.get("PAY_SN").toString());
		}
		log.debug("现在缴费流水串：  " + paySnStr);
		inMapTmp.put("PAYSN_STR", paySnStr);
		inMapTmp.put("CONTRACT_NO", (Long) inParam.get("CONTRACT_NO"));
		inMapTmp.put("INTERVAL", inParam.get("INTERVAL"));
		if (StringUtils.isNotEmptyOrNull(inParam.get("LOGIN_NO"))) {
			inMapTmp.put("LOGIN_NO", inParam.get("LOGIN_NO"));
		}
		inMapTmp.put("NO_OP_CODE", "8021");
		inMapTmp.put("SUFFIX", Long.parseLong(sCurYm));
		Integer cnt = (Integer) baseDao.queryForObject("bal_payment_info.qCntOfPaymentByColPS", inMapTmp);

		return cnt.intValue();
	}

	@Override
	public long getInitialBalance(long contractNo, int yearMonth, BalanceFlagEnum balanceTypeFlag) {
		balanceTypeFlag = balanceTypeFlag == null ? BalanceFlagEnum.ALL : balanceTypeFlag;

		Map<String, Object> param = new HashMap<String, Object>();
		safeAddToMap(param, "CONTRACT_NO", contractNo);
		safeAddToMap(param, "YEAR_MONTH", String.valueOf(yearMonth));
		if (balanceTypeFlag.equals(BalanceFlagEnum.CURRENT_VALID)) {
			safeAddToMap(param, "BALANCE_FLAG", CommonConst.CYCLEBEG_BOOKTYPE_CURVALID);
		} else if (balanceTypeFlag.equals(BalanceFlagEnum.RET_VALID)) {
			safeAddToMap(param, "BALANCE_FLAG", CommonConst.CYCLEBEG_BOOKTYPE_RETVALID);
		}
		Map<String, Object> resultMap = (Map<String, Object>) baseDao.queryForObject("bal_cyclebegfee_info.qTotalCycleFee", param);
		return longValue(resultMap.get("CUR_BALANCE"));
	}

	/* 期初余额 */
	@Override
	public List<FeeEntity> getInitialBalance(long contractNo, int yearMonth, BalanceFlagEnum balanceTypeFlag, BookTypeEnum balanceType) {
		balanceTypeFlag = balanceTypeFlag == null ? BalanceFlagEnum.ALL : balanceTypeFlag;
		balanceType = balanceType == null ? BookTypeEnum.ALL : balanceType;

		Map<String, Object> param = new HashMap<String, Object>();
		safeAddToMap(param, "CONTRACT_NO", contractNo);
		safeAddToMap(param, "YEAR_MONTH", String.valueOf(yearMonth));
		if (balanceTypeFlag.equals(BalanceFlagEnum.CURRENT_VALID)) {
			safeAddToMap(param, "BALANCE_FLAG", CommonConst.CYCLEBEG_BOOKTYPE_CURVALID);
		} else if (balanceTypeFlag.equals(BalanceFlagEnum.RET_VALID)) {
			safeAddToMap(param, "BALANCE_FLAG", CommonConst.CYCLEBEG_BOOKTYPE_RETVALID);
		}

		if (balanceType.equals(BookTypeEnum.SPECIAL)) {
			safeAddToMap(param, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_SPECIAL);
		} else if (balanceType.equals(BookTypeEnum.NORAML)) {
			safeAddToMap(param, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_NORMAL);
		}

		List<FeeEntity> result = (List<FeeEntity>) baseDao.queryForList("bal_cyclebegfee_info.qBalCycleFeeInfo", param);
		return result;
	}

	@Override
	public List<FeeEntity> getInitialBalanceGroupByPayType(long contractNo, int yearMonth, BalanceFlagEnum balanceTypeFlag, BookTypeEnum balanceType) {
		balanceTypeFlag = balanceTypeFlag == null ? BalanceFlagEnum.ALL : balanceTypeFlag;
		balanceType = balanceType == null ? BookTypeEnum.ALL : balanceType;

		Map<String, Object> param = new HashMap<String, Object>();
		safeAddToMap(param, "CONTRACT_NO", contractNo);
		safeAddToMap(param, "YEAR_MONTH", String.valueOf(yearMonth));
		if (balanceTypeFlag.equals(BalanceFlagEnum.CURRENT_VALID)) {
			safeAddToMap(param, "BALANCE_FLAG", CommonConst.CYCLEBEG_BOOKTYPE_CURVALID);
		} else if (balanceTypeFlag.equals(BalanceFlagEnum.RET_VALID)) {
			safeAddToMap(param, "BALANCE_FLAG", CommonConst.CYCLEBEG_BOOKTYPE_RETVALID);
		}

		if (balanceType.equals(BookTypeEnum.SPECIAL)) {
			safeAddToMap(param, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_SPECIAL);
		} else if (balanceType.equals(BookTypeEnum.NORAML)) {
			safeAddToMap(param, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_NORMAL);
		}

		List<FeeEntity> result = (List<FeeEntity>) baseDao.queryForList("bal_cyclebegfee_info.qBalCycleFeeInfoGroupByPayType", param);
		return result;
	}

	@Override
	public List<TransFeeEntity> getJtTrasfeeInfo(String phoneNo,String queryMonth) {
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PHONE_NO", phoneNo);
		inMapTmp.put("QUERY_MONTH", queryMonth);
		List<TransFeeEntity> result = (List<TransFeeEntity>) baseDao.queryForList("bal_transfee_info.qJtTrans", inMapTmp);
		if (result.size() == 0) {
			log.debug("TransFeeInfo NON-EXISTENT! inParam:[ " + inMapTmp.toString() + " ]");
			throw new BusiException(AcctMgrError.getErrorCode("0000", "10010"), "无红包赠送记录！");
		}
		return result;
	}

	@Override
	public void saveTrasfeeInfo(PayUserBaseEntity transOutBaseInfo, PayUserBaseEntity transInBaseInfo, PayBookEntity bookIn, Map<String, Object> inMap) {
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		Map<String, Object> inBookMap = JSON.parseObject(JSON.toJSONString(bookIn), Map.class);
		inMapTmp.putAll(inBookMap);
		inMapTmp.put("TRANS_SN", bookIn.getPaySn());
		inMapTmp.put("PHONENO_OUT", transOutBaseInfo.getPhoneNo());
		inMapTmp.put("CONTRACTNO_OUT", transOutBaseInfo.getContractNo());
		inMapTmp.put("IDNO_OUT", transOutBaseInfo.getIdNo());
		inMapTmp.put("PHONENO_IN", transInBaseInfo.getPhoneNo());
		inMapTmp.put("CONTRACTNO_IN", transInBaseInfo.getContractNo());
		inMapTmp.put("IDNO_IN", transInBaseInfo.getIdNo());
		inMapTmp.put("TRANS_FEE", bookIn.getPayFee());
		inMapTmp.put("OP_TYPE", inMap.get("OP_TYPE"));
		inMapTmp.put("STATUS", "0");
		baseDao.insert("bal_transfee_info.iTransfee", inMapTmp);
		
		// 同步报表库,按照trans_sn同步
		List<Map<String, Object>> keysList = new ArrayList<Map<String, Object>>(); // 同步报表库数据List
        Map<String, Object> paymentKey = new HashMap<String, Object>();
        paymentKey.put("TRANS_SN", bookIn.getPaySn());
        paymentKey.put("CONTRACTNO_OUT", transOutBaseInfo.getContractNo());
        paymentKey.put("TO_CHAR(OP_TIME,'YYYYMM')", String.valueOf(bookIn.getYearMonth()));
        paymentKey.put("TABLE_NAME", "BAL_TRANSFEE_INFO");
        paymentKey.put("UPDATE_TYPE", "I");
        keysList.add(paymentKey);
        
        Map<String,Object> header = (Map<String, Object>) inMap.get("HEADER");
        
        Map<String, Object> reportMap = new HashMap<String, Object>();
		reportMap.put("ACTION_ID", "1007");
        reportMap.put("LOGIN_SN", bookIn.getPaySn());
        reportMap.put("OP_CODE", bookIn.getOpCode());
        reportMap.put("LOGIN_NO", bookIn.getLoginNo());
        reportMap.put("KEYS_LIST", keysList);
        
        if (keysList != null && keysList.size() != 0) {
            preOrder.sendReportDataList(header, reportMap);
        }
	}
	
	@Override
	public void saveTransFeeErrInfo(PayUserBaseEntity transOutBaseInfo, PayUserBaseEntity transInBaseInfo, PayBookEntity bookIn, Map<String, Object> inMap){
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		Map<String, Object> inBookMap = JSON.parseObject(JSON.toJSONString(bookIn), Map.class);
		inMapTmp.putAll(inBookMap);
		inMapTmp.put("TRANS_SN", bookIn.getPaySn());
		inMapTmp.put("PHONENO_OUT", transOutBaseInfo.getPhoneNo());
		inMapTmp.put("CONTRACTNO_OUT", transOutBaseInfo.getContractNo());
		inMapTmp.put("IDNO_OUT", transOutBaseInfo.getIdNo());
		inMapTmp.put("PHONENO_IN", transInBaseInfo.getPhoneNo());
		inMapTmp.put("CONTRACTNO_IN", transInBaseInfo.getContractNo());
		inMapTmp.put("IDNO_IN", transInBaseInfo.getIdNo());
		inMapTmp.put("TRANS_FEE", bookIn.getPayFee());
		inMapTmp.put("OP_TYPE", inMap.get("OP_TYPE"));
		inMapTmp.put("STATUS", "0");
		baseDao.insert("bal_transfee_err.iTransErr", inMapTmp);
		
	}

	@Override
	public long qryTransNum(Map<String, Object> inParam) {

		long transNum = (Long) baseDao.queryForObject("bal_transfee_info.qTransNum", inParam);
		return transNum;
	}

	@Override
	public void saveBatchPayMid(Map<String, Object> inParam) {
		baseDao.insert("bal_batchpay_mid.iBatchpayMid", inParam);
	}

	@Override
	public void saveBatchPayRecd(Map<String, Object> inParam) {
		baseDao.insert("bal_batchpay_recd.inBatchRecd", inParam);
	}

	public List<BatchPayRecdEntity> getBatchpayRecd(Map<String, Object> inParam, String inFlag) {

		List<BatchPayRecdEntity> recdList = null;

		log.info("------>  audit_inParam" + inParam.toString());
		if ("N".equals(inFlag)) {
			recdList = baseDao.queryAllDbList("bal_batchpay_recd.qBatchRecd", inParam);
		} else if ("A".equals(inFlag)) {
			recdList = baseDao.queryForList("bal_batchpay_recd.qBatchRecd", inParam);
		}

		for (BatchPayRecdEntity batchPay : recdList) {

			String auditName = "";
			String auditFlag = batchPay.getAuditFlag();
			if ("N".equals(auditFlag)) {
				auditName = "未审核";
			} else if ("Y".equals(auditFlag)) {
				auditName = "审核通过";
			} else if ("X".equals(auditFlag)) {
				auditName = "审核不通过";
			} else if ("S".equals(auditFlag)) {
				auditName = "赠送";
			} else if ("C".equals(auditFlag)) {
				auditName = "取消赠送";
			} else if ("F".equals(auditFlag)) {
				auditName = "赠送成功";
			}
			batchPay.setAuditName(auditName);
		}

		return recdList;
	}

	public void updateBatchPayMid(Map<String, Object> inParam) {
		int cnt = baseDao.update("bal_batchpay_mid.uAuditByActsn", inParam);
		if (0 == cnt) {
			throw new BusiException(AcctMgrError.getErrorCode("8208", "00001"), "批量赠费审核失败");
		}
	}

	public void updateBatchPayRecd(Map<String, Object> inParam) {
		int cnt = baseDao.update("bal_batchpay_recd.uAuditByActsn", inParam);
		if (0 == cnt) {
			throw new BusiException(AcctMgrError.getErrorCode("8208", "00001"), "批量赠费审核失败");
		}
	}

	@Override
	public void upAcctBookPrintFlag(Map<String, Object> inParam) {
		/* 修改bal_acctbook_x,print_flag */
		// add by liuhl_bj reason:8006打印预存发票使用
		String userFlag = "0";
		if (StringUtils.isNotEmpty(inParam.get("USER_FLAG").toString())) {
			userFlag = inParam.get("USER_FLAG").toString();
		}

		int result = 0;
		if (userFlag.equals("0")) {
			result = baseDao.update("bal_acctbook_info.upPrintFlag", inParam);

		} else if (userFlag.equals("1")) {
			result = baseDao.update("bal_acctbook_dead.upPrintFlag", inParam);
		} else {
			result = baseDao.update("bal_acctbook_info.upPrintFlag", inParam);
			result = baseDao.update("bal_acctbook_dead.upPrintFlag", inParam);
		}
		result = baseDao.update("bal_acctbook_his.upPrintFlag", inParam);
	}

	@Override
	public Map<String, Object> getPayOutList(Map<String, Object> inParam) {
		// TODO Auto-generated method stub
		Map<String, Object> moutParam = new HashMap<String, Object>();
		// Map<String,Object> result = new HashMap<String,Object>();

		List<Map<String, Object>> resultList = baseDao.queryForList("bal_bookpayout_info.qBookPayoutByPaySn", inParam);

		moutParam.put("CNT", resultList.size());
		moutParam.put("BOOKPAYOUT_LIST", resultList);

		return moutParam;
	}

	@Override
	public Map<String, Object> getSumPayFeeByPaySn(long paySn, int yearMon, long contractNo, long idNo, String payTypeStr) {
		Map<String, Object> inParam = new HashMap<String, Object>();
		inParam.put("PAY_SN", paySn);
		inParam.put("SUFFIX", yearMon);
		if (contractNo > 0) {
			inParam.put("CONTRACT_NO", contractNo);
		}
		if (idNo > 0) {
			inParam.put("ID_NO", idNo);
		}

		inParam.put("ACCPERT_PAYTYPE", payTypeStr);
		Map<String, Object> outParam = (Map<String, Object>) baseDao.queryForObject("bal_payment_info.qrySumPayFeeByPaySnInvc", inParam);
		return outParam;
	}

	@Override
	public List<Map<String, Object>> getMinersFee(long lContractNo, long lIdNo, int iNaturalMon, int yearMon) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> wrtList = null;
		Map<String, Object> inParam = new HashMap<String, Object>();
		inParam.put("YEAR_MONTH", yearMon);
		if (lIdNo > 0) {
			inParam.put("ID_NO", lIdNo);
		}
		inParam.put("NATURAL_MONTH", iNaturalMon);
		inParam.put("CONTRACT_NO", lContractNo);
		wrtList = (List<Map<String, Object>>) baseDao.queryForList("bal_writeoff_yyyymm.qryPayedFeeForWriteOff", inParam);

		return wrtList;
	}

	@Override
	public List<Map<String, Object>> getMinersFee(long lContractNo, int iNaturalMon, int yearMon) {
		return getMinersFee(lContractNo, 0, iNaturalMon, yearMon);

	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.IBalance#upWriteOffPrintFlag(java.util .Map) */

	@Override
	public void upWriteOffPrintFlag(Map<String, Object> inParam) {

		baseDao.update("bal_writeoff_yyyymm.uPrintFlag", inParam);
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IBalance#upWriteOffPrintSn(java. util.Map) */
	@Override
	public void upWriteOffPrintSn(Map<String, Object> inParam) {
		// TODO Auto-generated method stub
		baseDao.update("bal_writeoff_yyyymm.uPrintSn", inParam);
	}

	/* 名称：查询冲销记录表
	 * 
	 * @param WRTOFF_SN :冲销流水
	 * 
	 * @param BALANCE_ID :账单流水
	 * 
	 * @param ID_NO :用户ID（可空）
	 * 
	 * @return PRINT_FLAG :打印标示
	 * 
	 * @return NATURAL_MONTH :冲销账期
	 * 
	 * @
	 * 
	 * @author fanck */
	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.busi.pay.IWriteOffer#getWrtoffList(java.util.Map) */
	@Override
	public Map<String, Object> getWrtoffList(Map<String, Object> inParam) {

		Map<String, Object> moutParam = new HashMap<String, Object>();
		// Map<String,Object> result = new HashMap<String,Object>();
		log.debug("inParam=" + inParam);
		List<Map<String, Object>> resultList = baseDao.queryForList("bal_writeoff_yyyymm.qWrtoffByWrtoSn", inParam);
		// log.info("resultList="+resultList);

		moutParam.put("CNT", resultList.size());
		moutParam.put("WRITEOFF_LIST", resultList);

		return moutParam;
	}

	@Override
	public String getPFlagAcctbook(Map<String, Object> inParam) {
		String sBreakFlag = "0";
		int iUserFlag = (Integer) inParam.get("USER_FLAG");
		Map<String, Object> outParam = null;
		if (iUserFlag == 0) {
			/* 在网 */
			outParam = (Map<String, Object>) baseDao.queryForObject("bal_acctbook_info.qryPrintFlag", inParam);
		} else {
			/* 离网 */
			outParam = (Map<String, Object>) baseDao.queryForObject("bal_acctbook_dead.qryPrintFlag", inParam);
		}

		if (outParam != null) {
			sBreakFlag = outParam.get("PRINT_FLAG").toString();
		}

		return sBreakFlag;
	}

	@Override
	public void upWriteOffPrintTaxFlag(Map<String, Object> inParam) {
		baseDao.update("bal_writeoff_yyyymm.uPrintFlagTax", inParam);
	}

	@Override
	public void uPrintOnePonitInvFlag(Map<String, Object> inParam) {
		baseDao.update("bal_writeoff_yyyymm.uPrintOnePonitInvFlagTax", inParam);
	}

	@Override
	public InvoMutiMonEntity getInvFeePrimOfWriteOff(long contractNo, long idNo, int billCycle, int yearMon) {
		// TODO Auto-generated method stub
		Map<String, Object> inParam = new HashMap<String, Object>();
		Map<String, Object> inTmp;
		MapUtils.safeAddToMap(inParam, "CONTRACT_NO", contractNo);
		MapUtils.safeAddToMap(inParam, "BILL_CYCLE", billCycle);
		MapUtils.safeAddToMap(inParam, "SUFFIX", "" + yearMon);
		if (idNo > 0) {
			MapUtils.safeAddToMap(inParam, "ID_NO", idNo);
		}
		InvoMutiMonEntity invMuEnt = new InvoMutiMonEntity();

		// 1.取总费用
		Map<String, Object> outParam = (Map<String, Object>) baseDao.queryForObject("bal_writeoff_yyyymm.qSumFeeByCon", inParam);
		invMuEnt.setTotalFee(ValueUtils.longValue(outParam.get("FEE")));

		// 2.取滞纳金
		inTmp = new HashMap<String, Object>();
		inTmp.putAll(inParam);
		MapUtils.safeAddToMap(inTmp, "DELAY_FEE", "0");
		outParam = (Map<String, Object>) baseDao.queryForObject("bal_writeoff_yyyymm.qDelFeefromWrioff", inTmp);
		invMuEnt.setDelayFee(ValueUtils.longValue(outParam.get("DELAY_FEE")));// 取总滞纳金

		// 取打印过预存发票的滞纳金
		inTmp = new HashMap<String, Object>();
		inTmp.putAll(inParam);
		MapUtils.safeAddToMap(inTmp, "AL_FEE_TYPE", "0");
		outParam = (Map<String, Object>) baseDao.queryForObject("bal_writeoff_yyyymm.qDelFeefromWrioff", inTmp);
		long alreadFee = ValueUtils.longValue(outParam.get("DELAY_FEE"));

		// 取打印过消费发票的滞纳金
		inTmp = new HashMap<String, Object>();
		inTmp.putAll(inParam);
		MapUtils.safeAddToMap(inTmp, "ALMON_FEE_TYPE", "0");
		outParam = (Map<String, Object>) baseDao.queryForObject("bal_writeoff_yyyymm.qDelFeefromWrioff", inTmp);
		long alMonFee = ValueUtils.longValue(outParam.get("DELAY_FEE"));

		// 取存费送费冲销的滞纳金
		inTmp = new HashMap<String, Object>();
		inTmp.putAll(inParam);
		MapUtils.safeAddToMap(inTmp, "GI_FEE_TYPE", "0");
		outParam = (Map<String, Object>) baseDao.queryForObject("bal_writeoff_yyyymm.qDelFeefromWrioff", inTmp);
		long giDelFee = ValueUtils.longValue(outParam.get("DELAY_FEE"));

		// 3.取已打预存发票金额
		inTmp = new HashMap<String, Object>();
		inTmp.putAll(inParam);
		MapUtils.safeAddToMap(inTmp, "AL_READ", "0");
		outParam = (Map<String, Object>) baseDao.queryForObject("bal_writeoff_yyyymm.qSumFeeByCon", inTmp);
		invMuEnt.setAlreadFee(ValueUtils.longValue(outParam.get("FEE")) + alreadFee);

		// 4.取已打消费发票金额
		inTmp = new HashMap<String, Object>();
		inTmp.putAll(inParam);
		MapUtils.safeAddToMap(inTmp, "AL_MON", "0");
		outParam = (Map<String, Object>) baseDao.queryForObject("bal_writeoff_yyyymm.qSumFeeByCon", inTmp);
		invMuEnt.setAlmonFee(ValueUtils.longValue(outParam.get("FEE")) + alMonFee);

		// 5.取存废送费金额
		inTmp = new HashMap<String, Object>();
		inTmp.putAll(inParam);
		MapUtils.safeAddToMap(inTmp, "GIFT_FEE", "0");
		outParam = (Map<String, Object>) baseDao.queryForObject("bal_writeoff_yyyymm.qSumFeeByCon", inTmp);
		invMuEnt.setGiftFee(ValueUtils.longValue(outParam.get("FEE")) + giDelFee);

		// 6.发票金额
		inTmp = new HashMap<String, Object>();
		inTmp.putAll(inParam);
		MapUtils.safeAddToMap(inTmp, "PRINT_FEE", "0");
		outParam = (Map<String, Object>) baseDao.queryForObject("bal_writeoff_yyyymm.qSumFeeByCon", inTmp);
		invMuEnt.setPrintFee(ValueUtils.longValue(outParam.get("FEE")));
		// invMuEnt.setBillBegin(outParam.get("BILL_BEGIN").toString());
		// invMuEnt.setBillBegin(outParam.get("BILL_END").toString());
		invMuEnt.setBillBegin("201606");
		invMuEnt.setBillEnd("201606");
		invMuEnt.setBillCycle(billCycle);
		System.out.println("invMuEnt=" + invMuEnt);
		return invMuEnt;
	}

	@Override
	public Map<String, Object> getPayParameter(String servName, String busiCode, String organId) {
		Map<String, Object> inParam = new HashMap<String, Object>();
		inParam.put("SERV_NAME", servName);
		if (StringUtils.isNotEmptyOrNull(busiCode)) {
			inParam.put("BUSI_CODE", busiCode);
		}
		if (StringUtils.isNotEmptyOrNull(organId)) {
			inParam.put("ORGAN_ID", organId);
		}
		return (Map<String, Object>) baseDao.queryForObject("bal_payparameter_conf.qPayInfo", inParam);
	}

	@Override
	public void saveTotalPayRecd(Map<String, Object> inParam) {
		baseDao.insert("bal_totalpay_recd.inRecd", inParam);
	}

	@Override
	public BookPayoutEntity getPayOutFee(Map<String, Object> inParam) {
		Map<String, Object> inMap = new HashMap<String, Object>();

		inMap.put("SUFFIX", (String) inParam.get("SUFFIX"));
		inMap.put("PAY_SN", (Long) inParam.get("PAY_SN"));

		if (inParam.get("ID_NO") != null && !inParam.get("ID_NO").equals("")) {
			inMap.put("ID_NO", (Long) inParam.get("ID_NO"));
		}

		if (inParam.get("BALANCE_ID") != null && !inParam.get("BALANCE_ID").equals("")) {
			inMap.put("BALANCE_ID", (Long) inParam.get("BALANCE_ID"));
		}

		if (inParam.get("CONTRACT_NO") != null && !inParam.get("CONTRACT_NO").equals("")) {
			inMap.put("CONTRACT_NO", (Long) inParam.get("CONTRACT_NO"));
		}

		if (inParam.get("PAY_TYPE") != null && !inParam.get("PAY_TYPE").equals("")) {
			inMap.put("PAY_TYPE", (String) inParam.get("PAY_TYPE"));
		}

		BookPayoutEntity result = (BookPayoutEntity) baseDao.queryForObject("bal_bookpayout_info.qBookPayOutFeeByPaySn", inMap);

		if (result == null) {
			log.info("bal_bookpayout_info.qBookPayOutFeeByPaySn is null!");
			throw new BusiException(AcctMgrError.getErrorCode("8000", "00001"), "查询bal_bookpayout_info出错！");
		}

		return result;
	}

	public List<PayTypeEntity> getPayTypeForCrm(String queryFlag) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("FLAG", queryFlag);
		log.info("xxxxxxxxxxxx=" + inMap.toString());
		List<PayTypeEntity> result = (List<PayTypeEntity>) baseDao.queryForList("bal_booktype_dict.qryTypeForCrm", inMap);

		return result;

	}

	public List<TransFeeEntity> getAgentTrasfeeInfo(Map<String, Object> inParam) {

		List<TransFeeEntity> result = (List<TransFeeEntity>) baseDao.queryForList("bal_transfee_info.qAgtTransInfo", inParam);

		return result;

	}

	public TransFeeEntity getSumAgentTrasfee(Map<String, Object> inParam) {
		TransFeeEntity result = (TransFeeEntity) baseDao.queryForObject("bal_transfee_info.qSumAgtTrans", inParam);

		return result;
	}

	@Override
	public List<BookTypeEntity> getSpPayType(Map<String, Object> inMap) {
		List<Map<String, Object>> bookTypeListTmp = baseDao.queryForList("bal_booktype_dict.qBookTypeDictByType", inMap);

		List<BookTypeEntity> bookTypeList = new ArrayList<BookTypeEntity>();
		for (Map<String, Object> bookType : bookTypeListTmp) {
			BookTypeEntity bookEnt = new BookTypeEntity();
			bookEnt.setPayAttr(bookType.get("PAY_ATTR").toString());
			bookEnt.setPayType(bookType.get("PAY_TYPE").toString());
			bookEnt.setPayTypeName(bookType.get("PAY_TYPE_NAME").toString());
			bookEnt.setPriority(bookType.get("PRIORITY").toString());

			bookTypeList.add(bookEnt);
		}
		return bookTypeList;
	}

	@Override
	public List<ReturnFeeEntity> getReturnfeeInfo(Long contractNo, Long idNo) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("PAY_PATH", 98);
		if (idNo != null && idNo > 0) {
			inMap.put("ID_NO", idNo);
		}
		List<ReturnFeeEntity> result = (List<ReturnFeeEntity>) baseDao.queryForList("bal_returnfee_recd.qry", inMap);

		return result;

	}

	@Override
	public List<ReturnFeeEntity> getReturnFeeInfo(long contractNo, String foreignSn, String valid) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("FOREIGN_SN", foreignSn);
		if (StringUtils.isNotEmptyOrNull(valid)) {
			inMap.put("VALID", valid);
		}
		List<ReturnFeeEntity> result = baseDao.queryForList("bal_returnfee_recd.qry", inMap);
		return result;
	}

	@Override
	public List<TdUnifyPayEntity> getTdTrasfeeInfo(Long contractNo, String yearMonth) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("YEAR_MONTH", yearMonth);
		List<TdUnifyPayEntity> result = (List<TdUnifyPayEntity>) baseDao.queryForList("bal_transfee_info.qTdTrans", inMap);

		return result;

	}

	public long getAcctBookSumByMap(Map<String, Object> inMap) {

		// 出帐不停业务
		PubWrtoffCtrlEntity outMapTmp = control.getWriteOffFlagAndMonth();
		int iWrtoffFlag = Integer.parseInt(outMapTmp.getWrtoffFlag());
		int iWrtoffMonth = outMapTmp.getWrtoffMonth();

		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp = inMap;
		long balance = 0;

		if (iWrtoffFlag > 0 && iWrtoffMonth != 0) {
			inMapTmp.put("WRTOFF_MONTH", iWrtoffMonth);
			balance = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByWrtoffTime", inMapTmp);
		} else {
			balance = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByCol", inMapTmp);
		}

		return balance;
	}
	
	
	@Override
	public long getAcctSumCurBalance(Map<String, Object> inMap) {

		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp = inMap;
		long balance = 0;
		
		balance = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByCol", inMapTmp);
		return balance;
	}

	@Override
	public Map<String, Object> getWriteFeeByPaySn(Map<String, Object> inMap) {
		long outFee = 0;
		long delayFee = 0;
		Map<String, Object> inParam = new HashMap<String, Object>();
		Map<String, Object> outMap = new HashMap<String, Object>();
		long paySn = ValueUtils.longValue(inMap.get("PAY_SN"));
		int yearMonth = ValueUtils.intValue(inMap.get("YEAR_MONTH"));
		// 根据缴费流水获取账本id
		inParam.put("PAY_SN", paySn);
		inParam.put("SUFFIX", yearMonth);
		List<Map<String, Object>> paySourceList = baseDao.queryForList("bal_booksource_info.qBookSourceByPaySn", inParam);
		List<Long> balanceList = new ArrayList<Long>();
		if (paySourceList != null && paySourceList.size() != 0) {
			for (Map<String, Object> paySource : paySourceList) {
				balanceList.add(ValueUtils.longValue(paySource.get("BALANCE_ID")));
			}
		}

		for (int yearMonthTmp = yearMonth; yearMonthTmp <= DateUtils.getCurYm(); yearMonthTmp = DateUtils.addMonth(yearMonthTmp, 1)) {
			// 根据账本id查询账本支出话费金额和支出缴费金额
			inMap.put("BALANCE_ID_LIST", balanceList);
			inMap.put("YEAR_MONTH", yearMonthTmp);
			Map<String, Object> feeMap = (Map<String, Object>) baseDao.queryForObject("bal_bookpayout_info.qSumPayOutByBalanceId", inMap);
			if (feeMap != null) {
				log.debug("feeMap:" + feeMap);
				outFee += ValueUtils.longValue(feeMap.get("OUT_BALANCE"));
				delayFee += ValueUtils.longValue(feeMap.get("DELAY_FEE"));

			}

		}
		outMap.put("OUT_FEE", outFee);
		outMap.put("DELAY_FEE", delayFee);
		return outMap;
	}

	@Override
	public List<Map<String, Object>> getGiftPayType() {
		List<Map<String, Object>> result = baseDao.queryForList("bal_booktype_dict.qryPresentType");
		return result;
	}

	@Override
	public void saveExtfeeRecd(Map<String, Object> inParam) {
		baseDao.insert("bal_extfee_recd.insertRecd", inParam);
	}

	@Override
	public List<SpFeeRecycleEntity> getSpBookHis(Map<String, Object> inParam) {
		return baseDao.queryForList("bal_acctbook_his.qAcctBookHis", inParam);
	}

	@Override
	public String getDisassembleFlag(Long idNo, Integer yearMonth) {
		String flag = "";
		Map<String, Object> inParam = new HashMap<String, Object>();
		inParam.put("ID_NO", idNo);
		inParam.put("YEAR_MONTH", yearMonth);
		flag = (String) baseDao.queryForObject("bal_userimeiuse_info.qryFlag", inParam);
		return flag;
	}

	public boolean isZdzRepetitionPay(String yearMonth, String transactionId) {

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("YEAR_MONTH", yearMonth);
		inMap.put("TRANSACTIONID", transactionId);
		inMap.put("OP_FLAG", "0");
		Integer result = (Integer) baseDao.queryForObject("bal_totalpay_recd.qCntByTranId", inMap);
		if (result > 0) {
			return true;
		} else {
			return false;
		}
	}

	// 总对总查询交易标识、冲正标识
	@Override
	public Map<String, Object> qTotalPayByTranId(Map<String, Object> inParam) {
		String transactionId = inParam.get("TRANSACTIONID").toString();
		String actionDate = inParam.get("ACTIONDATE").toString();
		String payYm = actionDate.substring(0, 6);

		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> outListMap = new ArrayList<Map<String, Object>>();
		Map<String, Object> result = null;
		int cnt = 0;

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("TRANSACTIONID", transactionId);
		inMap.put("SETTLEDATE", actionDate);
		inMap.put("YEAR_MONTH", payYm);
		cnt = (Integer) baseDao.queryForObject("bal_totalpay_recd.qCntByTranId", inMap);
		/* resultList = baseDao.queryAllDbList("bal_totalpay_recd.qCntByTranId", inMap); for(Map<String, Object> resultMap : resultList){ int count = Integer.parseInt(resultMap.get("CNT").toString()); cnt = cnt + count; } */

		if (cnt == 1) {
			// result = (Map<String, Object>)baseDao.queryForObject("bal_totalpay_recd.qTotalpayByTranId", inMap);
			outListMap = baseDao.queryAllDbList("bal_totalpay_recd.qTotalpayByTranId", inMap);
			for (Map<String, Object> outMap : outListMap) {
				result = outMap;
			}
			return result;
		} else if (cnt > 1) {
			// 多条记录，查看是否有成功记录
			inMap.put("OP_FLAG", "0");
			// result = (Map<String, Object>)baseDao.queryForObject("bal_totalpay_recd.qTotalpayByTranId", inMap);
			outListMap = baseDao.queryAllDbList("bal_totalpay_recd.qTotalpayByTranId", inMap);

			if (outListMap.isEmpty() || outListMap == null) {
				// 只有失败记录，返回失败记录
				result = new HashMap<String, Object>();
				result.put("OP_FLAG", "1");
				return result;
			} else {
				// 有成功、失败记录，返回成功记录
				return result = outListMap.get(0);
			}
		} else {
			return null;
		}
	}

	public void doRollBackTotalPayRecd(Map<String, Object> inParam) {
		String rspCode = inParam.get("RSP_CODE").toString();
		if ("0000".equals(rspCode)) {
			// 更新原纪录标识
			int cnt = baseDao.update("bal_totalpay_recd.updateRecd", inParam);
			if (cnt == 0) {
				throw new BusiException(AcctMgrError.getErrorCode("0000", "00075"), "更新总队总缴费记录表出错");
			}
		}

		// 插入负记录
		baseDao.update("bal_totalpay_recd.iForRoback", inParam);
	}

	@Override
	public List<Map<String, Object>> getAcctBookInfo(Map<String, Object> inParam) {
		List<Map<String, Object>> outParam = new ArrayList();
		Map<String, Object> inMapTmp = null;
		String sValidFlag = "";

		long lContractNo = Long.parseLong(inParam.get("CONTRACT_NO").toString());

		if (StringUtils.isNotEmptyOrNull(inParam.get("VALID_FLAG"))) {
			sValidFlag = inParam.get("VALID_FLAG").toString();
		}

		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", lContractNo);
		if (sValidFlag.equals("1")) {
			inMapTmp.put("PAY_TYPE", "x");
		}
		List<Map<String, Object>> resultList = baseDao.queryForList("bal_acctbook_info.qAcctbookType", inMapTmp);
		if (resultList == null) {
			log.info("该账户无账本记录:" + inParam.get("CONTRACT_NO"));
		}
		for (Map<String, Object> MapTmp : resultList) {

			Map<String, Object> outParamTmp = new HashMap<String, Object>();
			outParamTmp.put("ACCTBOOK_ITEM", MapTmp.get("ACCTBOOK_ITEM"));
			outParamTmp.put("ACCTBOOK_ITEM_NAME", MapTmp.get("ACCTBOOK_ITEM_NAME"));
			outParamTmp.put("BALANCE", Long.valueOf(MapTmp.get("BALANCE").toString()));
			outParamTmp.put("BACK_FLAG", MapTmp.get("BACK_FLAG")); // 0 可退 1 不可退
			outParamTmp.put("BACK_FLAG_NAME", MapTmp.get("BACK_FLAG_NAME"));
			outParamTmp.put("PAY_FLAG", MapTmp.get("PAY_FLAG")); // 0:普通账本
																	// 1:赠费账本
			outParamTmp.put("PAY_FLAG_NAME", MapTmp.get("PAY_FLAG_NAME"));
			outParamTmp.put("ACCTBOOK_ITEM_TYPE", MapTmp.get("ACCTBOOK_ITEM_TYPE")); // 0
																						// 专款
																						// 1非专款
			outParamTmp.put("ACCTBOOK_ITEM_TYPE_NAME", MapTmp.get("ACCTBOOK_ITEM_TYPE_NAME"));
			outParamTmp.put("ACCTBOOK_EFF_DATE", MapTmp.get("ACCTBOOK_EFF_DATE"));
			outParamTmp.put("ACCTBOOK_EXP_DATE", MapTmp.get("ACCTBOOK_EXP_DATE"));
			outParamTmp.put("BALANCE_ID", MapTmp.get("BALANCE_ID"));
			outParamTmp.put("INIT_BALANCE", MapTmp.get("INIT_BALANCE"));
			outParamTmp.put("PAY_SN", MapTmp.get("PAY_SN"));
			outParamTmp.put("PRIORITY", MapTmp.get("PRIORITY")); // 账本冲销顺序，从小到大依次冲销

			outParam.add(outParamTmp);
		}

		return outParam;
	}

	public List<Map<String, Object>> getRetAcctBookForRestPay(Map<String, Object> inParam) {
		return baseDao.queryForList("bal_returnacctbook_info.qReturnAcctBookInfo", inParam);
	}

	public List<Map<String, Object>> getAcctBookForRestPay(Map<String, Object> inParam) {
		return baseDao.queryForList("bal_acctbook_info.qAcctBookForRestPay", inParam);
	}

	public void updateStatusByTransSn(long transSn,String payYm) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("PAY_SN", transSn);
		inMap.put("YEAR_MONTH", payYm);
		baseDao.update("bal_transfee_info.updateRBTransInfo", inMap);
	}

	public void insertRollBackTransInfo(Map<String, Object> inParam) {

		baseDao.insert("bal_transfee_info.insertRBTransInfo", inParam);

	}

	public boolean isTransInfoByTransSn(long transSn, String payYm) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("PAY_SN", transSn);
		inMap.put("YEAR_MONTH", payYm);
		long cnt = (long) baseDao.queryForObject("bal_transfee_info.qTransByPaySn", inMap);

		if (cnt > 0) {
			return true;
		} else {
			return false;
		}
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.busi.query.inter.IRemainFee#getUnRestPay(long, java.lang.String) */
	@Override
	public Map<String, Object> getUnRestPay(long lContractNo, String sForeignSn) {

		Map<String, Object> inMap = new HashMap<String, Object>();

		long lPrepayFee = 0; /* 预存 */
		long lOrdPrepay = 0; /* 普通预存 */
		long lPrePrepay = 0; /* 赠费预存 */

		List<Map<String, Object>> restPayList = new ArrayList<Map<String, Object>>();

		List<Map<String, Object>> outList = new ArrayList<Map<String, Object>>();

		inMap.put("CONTRACT_NO", lContractNo);
		inMap.put("FOREIGN_SN", sForeignSn);
		List<Map<String, Object>> acRestPayList = getAcctBookForRestPay(inMap);

		inMap.put("STATUS", "1");
		List<Map<String, Object>> rtRestPayList = getRetAcctBookForRestPay(inMap);

		restPayList.addAll(acRestPayList);
		restPayList.addAll(rtRestPayList);

		for (Map<String, Object> restMap : restPayList) {
			String sPreFlag = "";
			sPreFlag = restMap.get("PAY_ATTR").toString().substring(5, 6);

			if (sPreFlag.equals("0")) {
				lOrdPrepay += Long.parseLong(restMap.get("CUR_BALANCE").toString());
			} else {
				lPrePrepay += Long.parseLong(restMap.get("CUR_BALANCE").toString());
			}

			lPrepayFee += Long.parseLong(restMap.get("CUR_BALANCE").toString());

			Map<String, Object> tempMap = new HashMap<String, Object>();
			tempMap.putAll(restMap);
			tempMap.put("FEE_TYPE", sPreFlag);
			outList.add(tempMap);
		}

		Map<String, Object> outParam = new HashMap<String, Object>();
		outParam.put("RESTPAY_LIST", outList);
		outParam.put("PREPAY_FEE", lPrepayFee);
		outParam.put("ORD_PREPAY", lOrdPrepay);
		outParam.put("PRE_PREPAY", lPrePrepay);

		return outParam;
	}

	@Override
	public Map<String, Object> getBatchPayInfo(long lContractNo, String sForeignSn, String sForeignTime) {
		// 取当前时间
		String sCurYm = DateUtil.format(new Date(), "yyyyMM");
		int iCurYm = Integer.parseInt(sCurYm);

		// 取活动开始年月
		String sForeignYm = sForeignTime.substring(0, 6);
		int iForeignYm = Integer.parseInt(sForeignYm);

		List<Map<String, Object>> outList = new ArrayList<Map<String, Object>>();
		long lValidedPay = 0;
		long lOrdValided = 0;
		long lPreValided = 0;

		for (int iOneYm = iForeignYm; iOneYm <= iCurYm; iOneYm = Integer.parseInt(DateUtil.toStringPlusMonths(String.valueOf(iOneYm), 1, "yyyyMM"))) {
			log.info("getBatchPayInfo log : " + iOneYm);
			Map<String, Object> inMap = new HashMap<String, Object>();
			inMap.put("CONTRACT_NO", lContractNo);
			inMap.put("OP_YM", String.valueOf(iOneYm));
			inMap.put("FOREIGN_SN", sForeignSn);
			List<Map<String, Object>> batchList = baseDao.queryForList("bal_batchpay_info.qBatchPay", inMap);
			for (Map<String, Object> batchMap : batchList) {
				String sPreFlag = "";
				sPreFlag = batchMap.get("PAY_ATTR").toString().substring(5, 6);

				if (sPreFlag.equals("0")) {
					lOrdValided += Long.parseLong(batchMap.get("PAY_FEE").toString());
				} else {
					lPreValided += Long.parseLong(batchMap.get("PAY_FEE").toString());
				}

				lValidedPay += Long.parseLong(batchMap.get("PAY_FEE").toString());

				Map<String, Object> tempMap = new HashMap<String, Object>();
				tempMap.putAll(batchMap);
				tempMap.put("FEE_TYPE", sPreFlag);
				outList.add(tempMap);
			}
		}

		Map<String, Object> outParam = new HashMap<String, Object>();
		outParam.put("BATCHPAY_LIST", outList);
		outParam.put("VALIDED_PAY", lValidedPay);
		outParam.put("ORD_VALIDED", lOrdValided);
		outParam.put("PRE_VALIDED", lPreValided);

		return outParam;
	}

	@Override
	public Map<String, Object> getNoUnRestPay(long lContractNo, String sForeignSn) {

		Map<String, Object> inMap = new HashMap<String, Object>();

		long lPrepayFee = 0; /* 预存 */
		long lOrdPrepay = 0; /* 普通预存 */
		long lPrePrepay = 0; /* 赠费预存 */

		List<Map<String, Object>> restPayList = new ArrayList<Map<String, Object>>();

		List<Map<String, Object>> outList = new ArrayList<Map<String, Object>>();

		inMap.put("CONTRACT_NO", lContractNo);
		inMap.put("FOREIGN_SN", sForeignSn);
		/* List<Map<String, Object>> acRestPayList = balance.getAcctBookForRestPay(inMap); */

		inMap.put("STATUS", "1");
		List<Map<String, Object>> rtRestPayList = baseDao.queryForList("bal_returnacctbook_info.qUnReturnAcctBookInfo", inMap);

		// restPayList.addAll(acRestPayList);
		restPayList.addAll(rtRestPayList);

		for (Map<String, Object> restMap : restPayList) {
			String sPreFlag = "";
			sPreFlag = restMap.get("PAY_ATTR").toString().substring(5, 6);

			if (sPreFlag.equals("0")) {
				lOrdPrepay += Long.parseLong(restMap.get("CUR_BALANCE").toString());
			} else {
				lPrePrepay += Long.parseLong(restMap.get("CUR_BALANCE").toString());
			}

			lPrepayFee += Long.parseLong(restMap.get("CUR_BALANCE").toString());

			Map<String, Object> tempMap = new HashMap<String, Object>();
			tempMap.putAll(restMap);
			tempMap.put("FEE_TYPE", sPreFlag);
			outList.add(tempMap);
		}

		Map<String, Object> outParam = new HashMap<String, Object>();
		outParam.put("RESTUNPAY_LIST", outList);
		outParam.put("PREUNPAY_FEE", lPrepayFee);
		outParam.put("ORD_PRUNEPAY", lOrdPrepay);
		outParam.put("PRE_PRUNEPAY", lPrePrepay);

		return outParam;
	}

	@Override
	public boolean deleteHavePayCon(long contractOut, long contractIn) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACTNO_OUT", contractOut);
		inMap.put("CONTRACTNO_IN", contractIn);
		boolean isPayOrNot;

		long payTimes = (long) baseDao.queryForObject("bal_transfee_info.getPayedCon", inMap);
		if (payTimes == 0) {
			isPayOrNot = false;
		} else {
			isPayOrNot = true;
		}

		return isPayOrNot;
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IBalance#saveAgentCheck(java.util.Map) */
	@Override
	public void saveAgentCheck(Map<String, Object> inParam) {

		baseDao.insert("bal_agentcheck_info.iagentcheckInfo", inParam);
	}

	public boolean isAgentCheck(String phoneNo, long contractNo) {

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("PHONE_NO", phoneNo);
		inMap.put("CONTRACT_NO", contractNo);
		int cnt = (Integer) baseDao.queryForObject("bal_agentcheck_info.qCnt", inMap);
		if (cnt > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	public boolean isPayTypeExist(String payType){
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("PAY_TYPE", payType);
		int cnt = (Integer) baseDao.queryForObject("bal_booktype_dict.qCntByPayType", inMap);
		if (cnt == 1) {
			return true;
		} else {
			return false;
		}
	}
	
	public void iCardPayrequestInfo(Map<String, Object> inParam){
		
		baseDao.insert("bal_cardpayrequest_info.iCardpayrequest", inParam);
	}
	
	public List<Map<String, Object>> getBatchPayMid(Map<String, Object> inParam) {
		return baseDao.queryForList("bal_batchpay_mid.qBatchPayMid", inParam);
	}
	
	public void iMonthReturnFeeInfo(Map<String, Object> inParam){
		
		Map<String, Object> inMap = new HashMap<>();
		inMap.put("BATCH_SN", inParam.get("BATCH_SN"));
		inMap.put("ID_NO", inParam.get("ID_NO"));
		inMap.put("CONTRACT_NO", inParam.get("CONTRACT_NO"));
		inMap.put("PHONE_NO", inParam.get("PHONE_NO"));
		inMap.put("RETURNFEE_SUM", inParam.get("RETURNFEE_SUM"));
		inMap.put("RETURN_COUNT", inParam.get("RETURN_COUNT"));
		inMap.put("PAY_TYPE", inParam.get("PAY_TYPE"));
		inMap.put("EFF_DATE", inParam.get("EFF_DATE"));
		inMap.put("EXP_DATE", inParam.get("EXP_DATE"));
		inMap.put("PAYED_COUNT", inParam.get("PAYED_COUNT"));
		inMap.put("PAYED_MONEY", inParam.get("PAYED_MONEY"));
		inMap.put("RETURN_RULE", inParam.get("RETURN_RULE"));
		inMap.put("DEAL_FLAG", inParam.get("DEAL_FLAG"));
		inMap.put("OP_CODE", inParam.get("OP_CODE"));
		inMap.put("REMARK", inParam.get("REMARK"));
		inMap.put("LOGIN_NO", inParam.get("LOGIN_NO"));
		inMap.put("LOGIN_ACCEPT", inParam.get("BATCH_SN"));
		baseDao.insert("bal_monthreturnfee_info.iMonthReturnFee", inMap);
	}
	
	@Override
	public boolean saveBatchpay(Map<String, Object> inParam) {

		baseDao.insert("bal_batchpay_info.iBatchpay", inParam);

		return true;
	}
	
	@Override
	public boolean saveReturnAcctbook(Map<String, Object> inParam) {

		baseDao.insert("bal_returnacctbook_info.iReturnacctbook", inParam);
		return true;
	}
	
	@Override
	public boolean isPayTypeExist(long contractNo) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		int cnt = (Integer) baseDao.queryForObject("bal_acctbook_info.qAcctBookForPayType", inMap);
		if (cnt == 1) {
			return true;
		} else {
			return false;
		}
	}
	
	@Override
	public int updateAcctBookEndTime(long contractNo) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		return baseDao.update("bal_acctbook_info.uAcctbookByPayType", inMap);
	}
	
	
	@Override
	public int upAcctboookEndTime(long contractNo, long balanceId, String endTime){
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("BALANCE_ID", balanceId);
		inMap.put("END_TIME", endTime);
		return baseDao.update("bal_acctbook_info.uEndTime", inMap);
	}
	
	@Override
	public void updateFlagForOnePay(long paySn, long printSn, long contractNo, int yearMonth, int beginYm, int endYm) {
		// 根据paySn contractNo 查询来源表中的记录
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("SUFFIX", yearMonth);
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("PAY_SN", paySn);
		Map<String, Object> sourceMap = (Map<String, Object>) baseDao.queryForObject("bal_booksource_info.qBookSourceByPaySn", inMap);
		// 根据来源表中的记录，更新冲销表中的记录
		inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("SUFFIX", yearMonth);
		inMap.put("BALANCE_ID", sourceMap.get("BALANCE_ID"));
		inMap.put("ACCPERT_PAYTYPE", "y");
		inMap.put("PRINT_SN", printSn);
		List<Integer> billCycleList=new ArrayList<Integer>();
		for (int billCycle = beginYm; billCycle < endYm; billCycle = DateUtils.addMonth(billCycle, 1)) {
			billCycleList.add(billCycle);
		}
		inMap.put("BILL_CYCLE_LIST", billCycleList);
		inMap.put("PRINT_FLAG", "3");
		upWriteOffPrintFlag(inMap);
	}

    @Override
    public long getTransFeeByUnitId(String unitId,String contactPhone) {
        // TODO Auto-generated method stub
        Map<String, Object> inMapTmp = new HashMap<String, Object>();
        inMapTmp.put("UNIT_ID", unitId);
        inMapTmp.put("CONTRACT_PHONE", contactPhone);
        long transFee = (long) baseDao.queryForObject("bal_transfee_info.qSumTransFeeByUnitId", inMapTmp);
        return transFee;
    }
    
    @Override
	public List<TransLimitEntity> getTransLimit(Map<String, Object> inParam) {
    	
    	List<TransLimitEntity>  resultList = (List<TransLimitEntity>)baseDao.queryForList("bal_transfee_limit.qry", inParam);
		return resultList;
	}
    
    @Override
	public void oprTransLimit(Map<String, Object> inParam) {
    	String opType = inParam.get("OP_TYPE").toString();
    	long limitPay = Long.parseLong(inParam.get("LIMIT_PAY").toString());
    	String operPhone = inParam.get("OPER_PHONE").toString();
    	if(opType.equals("0")) {
    		long cnt = (long) baseDao.queryForObject("bal_transfee_limit.qryCnt", inParam);
    		long totalPayed = 0;
    		if(cnt>0) {
    			TransLimitEntity tle = (TransLimitEntity) baseDao.queryForObject("bal_transfee_limit.qry", inParam);
    			if(tle!=null) {
    				totalPayed = tle.getTotalPayed();
    				if(totalPayed>=limitPay) {
						throw new BusiException(AcctMgrError.getErrorCode("8155", "00005"), "操作员" + operPhone + "累计赠送金额" + totalPayed
								+ "大于限制金额 不允许办理！");
    				}
    			}
    			inParam.put("TOTAL_PAYED", totalPayed);
    			inParam.put("OP_TYPE", "U");
    			baseDao.insert("bal_translimit_his.insert", inParam);
    			baseDao.update("bal_transfee_limit.update", inParam);
    		}else {
    			inParam.put("TOTAL_PAYED", 0);
    			baseDao.insert("bal_transfee_limit.insert", inParam);
    		}
    	}else if(opType.equals("1")) {
    		inParam.put("OP_TYPE", "D");
    		baseDao.insert("bal_translimit_his.insert", inParam);
    		baseDao.delete("bal_transfee_limit.delete", inParam);
    	}

	}

	@Override
	public List<BookSourceEntity> getBookSourceList(Map<String, Object> args) {
		List<BookSourceEntity> sourceList = null;
		String sqlStmt = "bal_booksource_info.qBookSourceList";
		sourceList = (List<BookSourceEntity>) baseDao.queryForList(sqlStmt, args);
		return sourceList;
	}
	
	@Override
	public List<TransFeeEntity> getTransInfo(Map<String, Object> inParam){
		Map inMap =new HashMap();
		if(StringUtils.isNotEmptyOrNull(inParam.get("TRANS_SN").toString())){
			inMap.put("TRANS_SN", inParam.get("TRANS_SN").toString());
		}
		if(StringUtils.isNotEmptyOrNull(inParam.get("CONTRACTNO_OUT").toString())){
			inMap.put("CONTRACTNO_OUT", inParam.get("CONTRACTNO_OUT").toString());
		}
		List<TransFeeEntity> result = new ArrayList<TransFeeEntity>();
		result = (List<TransFeeEntity>) baseDao.queryForList("bal_transfee_info.qTransInfoBySn", inParam);
		
		return result;
	}
	
	public long getTransFeeLimitNum(Map<String, Object> inParam){
		return (long) baseDao.queryForObject("bal_transfee_limit.qryCnt", inParam);
	}
	
	public void upTransFeeLimit(Map<String,Object> inParam){
		baseDao.update("bal_transfee_limit.updateLimitFee", inParam);
	}
	
	@Override
	public List<Map<String, Object>> getBookPrePayByPayType(long contractNo) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		// inMap.put("PAY_TYPE_LIST", payTypeList);
		return baseDao.queryForList("bal_acctbook_info.qAcctbookType", inMap);
	}
	
	public long getSumPayoutFee(long paySn, long contractNo, long yearMonth){
		
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("SUFFIX", yearMonth);
		Map<String, Object> outMapTmp = (Map<String, Object>) baseDao.queryForObject(
				"bal_bookpayout_info.qPayoutByThisPay", inMapTmp);
		long totalOwe = 0;
		long totalDelay = 0;
		if (outMapTmp == null) {
			log.info("账户户无支出费用  pay_sn : " + paySn + "contract_no : " + contractNo);
			return 0;
		} else {
			totalOwe = Long.valueOf(outMapTmp.get("PAY_OWE").toString());
			totalDelay = Long.valueOf(outMapTmp.get("DELAY_FEE").toString());
			return totalOwe + totalDelay;
		}
	}
	
	public long getSumCurbookFee(long paySn, long contractNo, long yearMonth){
		
		long sumCurbalance = 0;
		Map<String, Object> inParam = new HashMap<String, Object>();
		Map<String, Object> outMap = new HashMap<String, Object>();
		// 根据缴费流水获取账本id
		inParam.put("PAY_SN", paySn);
		inParam.put("SUFFIX", yearMonth);
		List<Map<String, Object>> paySourceList = baseDao.queryForList("bal_booksource_info.qBookSourceByPaySn", inParam);
		if (paySourceList != null && paySourceList.size() != 0) {
			for (Map<String, Object> paySource : paySourceList) {
				long balanceId = ValueUtils.longValue(paySource.get("BALANCE_ID"));
				
				Map<String, Object> inMapTmp = new HashMap<>();
				inMapTmp.put( "BALANCE_ID" , balanceId );
				Map<String, Object> outMapTmp = (Map<String , Object>)baseDao.queryForObject( "bal_acctbook_info.qByBalanceId" , inMapTmp );
				if(outMapTmp!=null){
					sumCurbalance = sumCurbalance + Long.valueOf(outMapTmp.get("CUR_BALANCE").toString());
				}
			}
		}
		
		return sumCurbalance;
	}
	
	@Override
	public PrepayEntity getValidSum(long contractNo) {
		
		long availableAll=0;
		long availableCommon=0;
		long availableSpecial=0;
		// 出帐不停业务
		PubWrtoffCtrlEntity outMapTmp = control.getWriteOffFlagAndMonth();
		int iWrtoffFlag = Integer.parseInt(outMapTmp.getWrtoffFlag());
		int iWrtoffMonth = outMapTmp.getWrtoffMonth();
		
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		if (iWrtoffFlag > 0 && iWrtoffMonth != 0) {
			inMapTmp.put("WRTOFF_MONTH", iWrtoffMonth);
			availableAll = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByWrtoffTime", inMapTmp);
		} else {
			availableAll = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByCol", inMapTmp);
		}
		
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("SPECIAL_FLAG", "1");
		if (iWrtoffFlag > 0 && iWrtoffMonth != 0) {
			inMapTmp.put("WRTOFF_MONTH", iWrtoffMonth);
			availableCommon = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByWrtoffTime", inMapTmp);
		} else {
			availableCommon = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByCol", inMapTmp);
		}
		
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("SPECIAL_FLAG", "0");
		if (iWrtoffFlag > 0 && iWrtoffMonth != 0) {
			inMapTmp.put("WRTOFF_MONTH", iWrtoffMonth);
			availableSpecial = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByWrtoffTime", inMapTmp);
		} else {
			availableSpecial = (Long) baseDao.queryForObject("bal_acctbook_info.qSumBalanceByCol", inMapTmp);
		}
		
		PrepayEntity pe = new PrepayEntity();
		pe.setAvailableAll(availableAll);
		pe.setAvailableCommon(availableCommon);
		pe.setAvailableSpecial(availableSpecial);
		return pe;
	}
	
	@Override
	public PrepayEntity getAllPrepay(long contractNo) {
		
		long prepayAll1=0;
		long effPrepayAll1=0;
		long willPrepayAll1=0;
		long expPrepayAll1=0;
		long prepayAll2=0;
		long effPrepayAll2=0;
		long willPrepayAll2=0;
		long expPrepayAll2=0;
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		// 无条件失效
		inMapTmp.put("EXP", "0");
		expPrepayAll1 = (Long) baseDao.queryForObject("bal_acctbook_info.qSumByTime", inMapTmp);
		// 无条件将要生效
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("WILL", "0");
		willPrepayAll1 = (Long) baseDao.queryForObject("bal_acctbook_info.qSumByTime", inMapTmp);
		// 生效
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("EFF", "0");
		effPrepayAll1 = (Long) baseDao.queryForObject("bal_acctbook_info.qSumByTime", inMapTmp);
		// 总预存
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		prepayAll1 = (Long) baseDao.queryForObject("bal_acctbook_info.qSumByTime", inMapTmp);
		
		// 有条件失效
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("EXP", "0");
		expPrepayAll2=(Long) baseDao.queryForObject("bal_returnacctbook_info.qryAllFee", inMapTmp);
		// 有条件将要生效
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("WILL", "0");
		willPrepayAll2=(Long) baseDao.queryForObject("bal_returnacctbook_info.qryAllFee", inMapTmp);
		// 生效
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("EFF", "0");
		effPrepayAll2 =	(Long) baseDao.queryForObject("bal_returnacctbook_info.qryAllFee", inMapTmp);
		// 总预存
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		prepayAll2 = (Long) baseDao.queryForObject("bal_returnacctbook_info.qryAllFee", inMapTmp);
		
		PrepayEntity pe = new PrepayEntity();
		pe.setPrepayAll(prepayAll1+prepayAll2);
		pe.setEffPrepayAll(effPrepayAll1+effPrepayAll2);
		pe.setExpPrepayAll(expPrepayAll1+expPrepayAll2);
		pe.setWillPrepayAll(willPrepayAll1+willPrepayAll2);
		return pe;
	}
	
	public List<Map<String,Object>> getIntellInfo(String payTypes,String notOpCode,String loginNo,int changeYM,int changeDate,long paySn){
		
		Map<String,Object> inMap = new HashMap<String,Object>();
		inMap.put("PAY_TYPE_STR", payTypes.split("\\,"));
		inMap.put("NOT_OP_CODE", notOpCode.split("\\,"));
		inMap.put("LOGIN_NO", loginNo);
		inMap.put("CHANGE_YM", changeYM);
		inMap.put("CHANGE_DATE", changeDate);
		inMap.put("LOGIN_ACCEPT", paySn);
		
		List<Map<String,Object>> list = baseDao.queryAllDbList("bal_payment_info.qCRMIntellInfo", inMap);
		
		return list;
	}
	
	public void insertIntellInfo(List<Map<String,Object>> list){
		log.info("list2内容" + list);
		baseDao.batchInsert("bal_payment_info.insertIntellInfo", list);
		
	}
	
	public void insertTotalIntellInfo(long loginAccept){
		Map<String,Object> inMap = new HashMap<String,Object>();
		inMap.put("LOGIN_ACCEPT", loginAccept);
		baseDao.insert("bal_payment_info.insertTotalIntellInfo",inMap);
	}
	
	public List<CRMIntellPrtEntity> queryIntellInfo(long loginAccept){
		Map<String,Object> inMap = new HashMap<String,Object>();
		inMap.put("LOGIN_ACCEPT", loginAccept);
		List<CRMIntellPrtEntity> list = baseDao.queryForList("bal_payment_info.qTotalIntellInfo",inMap);
		
		return list;
	}
	
	public void insertCollectIntellInfo(Map<String,Object> inMap){
		
		baseDao.insert("bal_payment_info.inCRMCollectInfo",inMap);
		
	}
	
    @Override
    public String getTotalPayPath(long yearMonth,String transId) {
        // TODO Auto-generated method stub
        Map<String, Object> inMapTmp = new HashMap<String, Object>();
        inMapTmp.put("YEAR_MONTH", yearMonth);
        inMapTmp.put("TRANSACTIONID", transId);
        String path = (String) baseDao.queryForObject("bal_totalpay_recd.qPayPathByTranId", inMapTmp);
        return path;
    }

	@Override
	public Map<String, Object> getAccountInfo(long balanceId) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("BALANCE_ID", balanceId);
		Map<String, Object> outMap = (Map<String, Object>) baseDao.queryForObject("bal_acctbook_info.qByBalanceId", inMap);
		return outMap;
	}
	
	@Override
	public int getCntByPayType(long contractNo,String payType) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("PAY_TYPE", payType);
		int cnt1 = (int) baseDao.queryForObject("bal_acctbook_info.qCntByPayType", inMap);
		int cnt2 = (int) baseDao.queryForObject("bal_returnacctbook_info.qCntByPayType", inMap);
		
		return cnt1+cnt2;
	}
	
	@Override
	public MonthReturnFeeEntity getMonthReturnFeeDeail(Map<String, Object> inParam) {
		
		Map<String, Object> outMap = (Map<String, Object>) baseDao.queryForObject("bal_monthreturnfee_info.qMonthReturnFee",inParam);
		MonthReturnFeeEntity  monthReturnFee = new MonthReturnFeeEntity();
		
		long maxFee = Long.parseLong(outMap.get("MAX_FEE").toString());
		monthReturnFee.setMaxFee(maxFee);

		safeAddToMap(inParam, "MAX_FEE", maxFee);
		
		long maxFeeNum = (long)baseDao.queryForObject("bal_monthreturnfee_info.qCnt", inParam);

		monthReturnFee.setMaxFeeNum(maxFeeNum);
		
		monthReturnFee.setMaxExpDate(outMap.get("MAX_EXP_DATE").toString());
		monthReturnFee.setMaxReturnCount(Long.parseLong(outMap.get("MAX_RETURN_COUNT").toString()));
		monthReturnFee.setMinEffDate(outMap.get("MIN_EFF_DATE").toString());
		monthReturnFee.setMinReturnCount(Long.parseLong(outMap.get("MIN_RETURN_COUNT").toString()));
		
		String[] qryFlagS = null;
		qryFlagS = new String[]{"N","Y","X","S","C","F","B"};
		log.error("------> qryFlagS = " + qryFlagS);

		// 查询所有未审批带入记录(默认查询所有未审核记录)
		safeAddToMap(inParam, "AUDIT_FLAG", qryFlagS);
		safeAddToMap(inParam, "ACT_TYPE", "A");
		BatchPayRecdEntity batchPayRecd = (BatchPayRecdEntity)baseDao.queryForObject("bal_batchpay_recd.qBatchRecd",inParam);
		String auditName = "";
		String auditFlag = batchPayRecd.getAuditFlag();
		if ("N".equals(auditFlag)) {
			auditName = "未审核";
		} else if ("Y".equals(auditFlag)) {
			auditName = "审核通过";
		} else if ("X".equals(auditFlag)) {
			auditName = "审核不通过";
		} else if ("S".equals(auditFlag)) {
			auditName = "赠送";
		} else if ("C".equals(auditFlag)) {
			auditName = "取消赠送";
		} else if ("F".equals(auditFlag)) {
			auditName = "赠送成功";
		}
		monthReturnFee.setActName(auditName);
		monthReturnFee.setAuditLogin(batchPayRecd.getAuditLogin());
		monthReturnFee.setDocumentName(batchPayRecd.getDocumentName());
		monthReturnFee.setDocumentNo(batchPayRecd.getDocumentNo());
		monthReturnFee.setLoginNo(batchPayRecd.getLoginNo());
		monthReturnFee.setOpTime(batchPayRecd.getOpTime());
		monthReturnFee.setTotalFee(batchPayRecd.getTotalFee());
		monthReturnFee.setTotalFee(batchPayRecd.getInvalidFee());
		monthReturnFee.setTotalSum(batchPayRecd.getTotalNum());
		monthReturnFee.setShortMsg1(batchPayRecd.getFactorOne());
		monthReturnFee.setShortMsg2(batchPayRecd.getFactorTwo());
		monthReturnFee.setActId(batchPayRecd.getActId());
	
		return monthReturnFee;
	}
	
	public void inYearCalcle(Map<String, Object> inParam, LoginBaseEntity loginBase){
		
		String billFlag="";
		if(inParam.get("PENAL_SUM_FLAG").toString().equals("N")){
			billFlag = "A";
		}else if(inParam.get("PENAL_SUM_FLAG").toString().equals("Y")){
			billFlag = "N";
		}
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("ID_NO", inParam.get("ID_NO"));
		inMap.put("PHONE_NO", inParam.get("PHONE_NO"));
		inMap.put("CONTRACT_NO", inParam.get("CONTRACT_NO"));
		inMap.put("PAY_TYPE", inParam.get("PAY_TYPE"));
		inMap.put("BILL_FLAG", billFlag);
		inMap.put("TOTAL_DATE", inParam.get("TOTAL_DATE"));
		inMap.put("LOGIN_ACCEPT", inParam.get("LOGIN_ACCEPT"));
		inMap.put("ORI_FOREIGN_SN", inParam.get("ORI_FOREIGN_SN"));
		inMap.put("FOREIGN_SN", inParam.get("FOREIGN_SN"));
		inMap.put("LOGIN_NO", loginBase.getLoginNo());
		inMap.put("GROUP_ID", loginBase.getGroupId());
		inMap.put("OP_CODE", loginBase.getOpCode());
		inMap.put("REMARK", loginBase.getOpNote());
		inMap.put("BACK_YM", inParam.get("BACK_YM"));
		inMap.put("ACCT_FLAG", "N");
		baseDao.insert("bal_yearcancel_info.iYearCalcel", inMap);
	}

	@Override
	public int hasDedit(long idNo, long contractNo, String payType) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("ID_NO", idNo);
		inMap.put("PAY_TYPE", payType);
		Map<String, Object> outMap = (Map<String, Object>) baseDao.queryForObject("bal_yearcancel_info.qHasDedit", inMap);
		return ValueUtils.intValue(outMap.get("CNT"));
	}
	public IBill getBill() {
		return bill;
	}

	public void setBill(IBill bill) {
		this.bill = bill;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public IAccount getAccount() {
		return account;
	}

	public void setAccount(IAccount account) {
		this.account = account;
	}

	public IPreOrder getPreOrder() {
		return preOrder;
	}

	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}
}
