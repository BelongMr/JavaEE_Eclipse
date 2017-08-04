package com.sitech.acctmgr.atom.entity;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.collection.CollBillAddEntity;
import com.sitech.acctmgr.atom.domains.collection.CollConDealEntity;
import com.sitech.acctmgr.atom.domains.collection.CollConDealRecdEntity;
import com.sitech.acctmgr.atom.domains.collection.CollFileDetailEntity;
import com.sitech.acctmgr.atom.domains.collection.CollectionConf;
import com.sitech.acctmgr.atom.domains.collection.CollectionDispEntity;
import com.sitech.acctmgr.atom.domains.collection.PayeeBankEntity;
import com.sitech.acctmgr.atom.domains.cust.PostBankEntity;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.ICollection;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.jcf.core.exception.BusiException;

/**
 * 托收业务实体，对托收相关功能做封装 Created by wangyla on 2016/7/5.
 */
public class Collection extends BaseBusi implements ICollection {
	private IAccount account;
	private IGroup group;

	@Override
	public List<CollectionDispEntity> getCollectionOrderList(String disGroupId, int yearMonth, String begBank, String endBank, int begPrintNo,
			int endPrintNo, String provinceId,boolean noPrinted) {

		String beginYmd = String.format("%6d", yearMonth) + "01";
		int lastDay = DateUtils.getLastDayOfMonth(yearMonth);
		String endYmd = String.format("%6d", yearMonth) + String.format("%02d", lastDay);

		// 收款方托收银行信息
		Map<String, PayeeBankEntity> payeeInfoMap = this.getPayeeBankInfo(null);

		// 托收单明细帐单,展示列表使用
		List<CollectionDispEntity> billDetList = this.getBillDetListByRange(disGroupId, yearMonth, begBank, endBank, begPrintNo, endPrintNo);
		log.debug(" billDetList = " + billDetList);
		int conLimitNum = 0; // 记录托收单打印帐户个数
		long lContractNoTmp = 0;
		List<CollectionDispEntity> outList = new ArrayList<CollectionDispEntity>();

		for (CollectionDispEntity billDetEnt : billDetList) {
			lContractNoTmp = billDetEnt.getContractNo();

			/* 无代表号码的托收帐户不展示托收单 */
			String presPhone = account.getPayPhoneByCon(lContractNoTmp);
			if (StringUtils.isEmpty(presPhone)) {
				continue;
			}

			/* 收款方银行信息不存在的帐户不做打印 */
			ContractInfoEntity conInfo = account.getConInfo(lContractNoTmp);
			String conGroupId = conInfo.getGroupId();
			ChngroupRelEntity conGroupInfo = group.getRegionDistinct(conGroupId, null, provinceId);
			String regionCode = conGroupInfo.getRegionCode();

			PayeeBankEntity payeeInfo = null;
			/* if (payeeInfoMap.containsKey(regionCode)) { payeeInfo = payeeInfoMap.get(regionCode); } else { log.info("收款方银行信息不存在"); continue; } */

			//billDetEnt.setPayeeAccountNo(payeeInfo.getAccountNo());
			//billDetEnt.setPayeeBankName(payeeInfo.getBankName());
			

			billDetEnt.setBeginYmd(beginYmd);
			billDetEnt.setEndYmd(endYmd);
			billDetEnt.setBillCycle(yearMonth);

			if(isCollConHasPrinted(lContractNoTmp,yearMonth)){
				if(noPrinted){
					//billDetList.remove(billDetEnt);   //delete this piece of data for printed data
					
				}else{
					billDetEnt.setPrintFlag(1);       //inform people to notice this piece of printed data
					outList.add(billDetEnt);

					conLimitNum++;
				}
			}else{
				outList.add(billDetEnt);

				conLimitNum++;
			}
			
		}

		log.debug("共有" + conLimitNum + "个托收帐户");

		return outList;
	}

	/**
	 * 功能：获取托收银行信息
	 *
	 * @param groupId
	 * @return
	 */
	private Map<String, PayeeBankEntity> getPayeeBankInfo(String groupId) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		if (!StringUtils.isEmpty(groupId)) {
			inMap.put("GROUP_ID", groupId);
		}
		List<PayeeBankEntity> result = baseDao.queryForList("bal_invcollcon_conf.qInvCollConInfo", inMap);
		Map<String, PayeeBankEntity> outMap = new HashMap<String, PayeeBankEntity>();
		for (PayeeBankEntity payeeEnt : result) {
			String key = payeeEnt.getRegionCode();
			if (outMap.containsKey(key)) {
				continue;
			} else {
				outMap.put(key, payeeEnt);
			}
		}
		return outMap;
	}

	/**
	 * 功能：获取托收单明细列表
	 *
	 * @param contractNo
	 *            可空
	 * @param disGroupId
	 *            可空
	 * @param billCycle
	 *            非空
	 * @param begBank
	 *            可空
	 * @param endBank
	 *            可空
	 * @param begPrintNo
	 *            可空
	 * @param endPrintNo
	 *            可空
	 * @return
	 */
	private List<CollectionDispEntity> getCollBillDetInfo(Long contractNo, String disGroupId, int billCycle, String begBank, String endBank,
			Integer begPrintNo, Integer endPrintNo) {

		Map<String, Object> inMap = new HashMap<>();
		if (contractNo != null && contractNo > 0) {
			safeAddToMap(inMap, "CONTRACT_NO", contractNo);
		}
		if (StringUtils.isNotEmpty(disGroupId)) {
			safeAddToMap(inMap, "PARENT_GROUP_ID", disGroupId);
			safeAddToMap(inMap, "PARENT_LEVEL", "3");

		}
		safeAddToMap(inMap, "BILL_CYCLE", billCycle);
		if (StringUtils.isNotEmpty(begBank)) {
			safeAddToMap(inMap, "BEGIN_BANK_CODE", begBank);
		}
		if (StringUtils.isNotEmpty(endBank)) {
			safeAddToMap(inMap, "END_BANK_CODE", endBank);
		}
		if (begPrintNo != null) {
			safeAddToMap(inMap, "BEGIN_PRINT_NO", begPrintNo);
		}
		if (endPrintNo != null) {
			safeAddToMap(inMap, "END_PRINT_NO", endPrintNo);
		}

		List<CollectionDispEntity> result = baseDao.queryForList("act_collbilldet_info.qBillDetInfo", inMap);

		if (result.isEmpty()) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "20007"), "没有[" + billCycle + "]月托收帐单明细");
		}

		return result;
	}

	/**
	 * 功能：范围查询托收明细帐单
	 *
	 * @return
	 */
	private List<CollectionDispEntity> getBillDetListByRange(String disGroupId, int billCycle, String begBank, String endBank, Integer begPrintNo,
			Integer endPrintNo) {
		return this.getCollBillDetInfo(null, disGroupId, billCycle, begBank, endBank, begPrintNo, endPrintNo);
	}

	@Override
	public CollectionDispEntity getBillDetByContract(Long contractNo, int billCycle) {
		return this.getCollBillDetInfo(contractNo, null, billCycle, null, null, null, null).get(0);
	}

	@Override
	public List<CollectionConf> getCollConfInfo(String disGroupId, String enterCode, String feeCode) {
		Map<String, Object> inMap = new HashMap<>();
		if (StringUtils.isNotEmpty(disGroupId)) {
			safeAddToMap(inMap, "GROUP_ID", disGroupId);
		}
		if (StringUtils.isNotEmpty(enterCode)) {
			safeAddToMap(inMap, "ENTER_CODE", enterCode);
		}
		if (StringUtils.isNotEmpty(feeCode)) {
			safeAddToMap(inMap, "OPER_TYPE", feeCode);
		}

		List<CollectionConf> result = (List<CollectionConf>)baseDao.queryForList("act_coll_conf.qCollConfInfo", inMap);
		if (result.isEmpty()) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "0000"), "归属区县未配置托收配置信息");
		}

		return result;
	}

	@Override
	public void saveCollectionFileRecd(String fileName, int yearMonth, String loginNo) {
		Map<String, Object> inMap = new HashMap<>();
		safeAddToMap(inMap, "FILE_NAME", fileName);
		safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
		safeAddToMap(inMap, "LOGIN_NO", loginNo);
		safeAddToMap(inMap, "REMARK", "系统自动生成托收单文件");
		baseDao.insert("act_collfile_info.instCollFileInfo", inMap);

	}

	@Override
	public void saveCollectionDealInfo(Long loginAccept, Long contractNo, int yearMonth, String loginNo) {
		Map<String, Object> inMap = new HashMap<>();
		safeAddToMap(inMap, "LOGIN_ACCEPT", loginAccept);
		safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
		safeAddToMap(inMap, "LOGIN_NO", loginNo);
		safeAddToMap(inMap, "CONTRACT_NO", contractNo);
		safeAddToMap(inMap, "DEAL_FLAG", "0");
		baseDao.insert("act_colldeal_info.instCollDealInfo", inMap);
	}

	@Override
	public Boolean isCollConHasPrinted(long contractNo, int yearMonth) {
		Boolean hasFlag = false;
		Map<String, Object> inMap = null;
		// 从托收月次月开始到系统月查找是否打印过发票
		int printYm = DateUtils.addMonth(yearMonth, 1);
		int curYm = DateUtils.getCurYm();
		for (int ym = printYm; ym <= curYm; ym = DateUtils.addMonth(ym, 1)) {
			inMap = new HashMap<String, Object>();
			inMap.put("CONTRACT_NO",contractNo);
			inMap.put("BILL_CYCLE",yearMonth);
			inMap.put("INV_TYPE","MM4001%");
			inMap.put("SUFFIX",String.format("%6d", ym));
			/* 查询月结发票 */
			Map<String, Object> result = (Map<String,Object>)baseDao.queryForObject("bal_invprint_info.qryCntByCon",inMap);

			int cnt = Integer.parseInt(result.get("CNT").toString());
			if (cnt > 0){
				hasFlag = true;
				break;
			}
		}

		return hasFlag;
	}

	@Override
	public PostBankEntity getPostBankInfo(long regionCode, String bankCode) {
		Map<String,Object> inTemp = new HashMap<String,Object>();
		inTemp.put("REGION_CODE", regionCode);
		if(StringUtils.isNotEmpty(bankCode)){
			inTemp.put("POST_BANK_CODE",bankCode);
		}

		PostBankEntity postBankEnt = (PostBankEntity)baseDao.queryForObject("ct_postbank_dict.qPostBankInfo", inTemp);
		return postBankEnt;
	}

	@Override
	public List<PostBankEntity> getBankInfoList(long regionCode, int pageNum, int pageSize) {
		Map<String,Object> inTemp = new HashMap<String,Object>();
		inTemp.put("REGION_CODE", regionCode);

		if(pageNum>0){
			int startLine = (pageNum-1)*pageSize+1;
			int endLine = pageNum*pageSize;
			inTemp.put("START_LINE", startLine);
			inTemp.put("END_LINE", endLine);
		}

		List<PostBankEntity> bankList = (List<PostBankEntity>)baseDao.queryForList("ct_postBank_dict.qPostBankList",inTemp);


		return bankList;
	}

	@Override
	public int getCollBillAddCount(long contractNo, int yearMonth, long payFee) {
		Map<String, Object> inMap = new HashMap<>();
		safeAddToMap(inMap, "CONTRACT_NO", contractNo);
		safeAddToMap(inMap, "BILL_CYCLE", yearMonth);
		safeAddToMap(inMap, "PAY_FEE", payFee);
		Integer count = (Integer) baseDao.queryForObject("act_collbilladd_recd.count", inMap);
		return count.intValue();
	}

	@Override
	public void saveCollBillAdd(CollBillAddEntity collBillAddEnt) {
		baseDao.insert("act_collbilladd_recd.insert", collBillAddEnt);

	}

	@Override
	public boolean hasCollDealed(long contractNo, int yearMonth) {
		Map<String, Object> inMap = new HashMap<>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("YEAR_MONTH", yearMonth);
		inMap.put("DEAL_FLAG", "1");
		int count = (int) baseDao.queryForObject("act_collcondeal_recd.qryCount", inMap);
		return count > 0 ? true : false;
	}
	
	@Override
	public void saveConTotalFileDetailInfo(CollFileDetailEntity collFileDetEnt) {
		baseDao.insert("act_collfiledet_info.insert",collFileDetEnt);
	}
	
	@Override
	public void updateDealFlag(long contractNo, int yearMonth) {
		Map<String, Object> inMap = new HashMap<>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("YEAR_MONTH", yearMonth);
		baseDao.update("act_collcondeal_recd.updDealFlag", inMap);
	}
	
	@Override
	public void saveCollConDeal(CollConDealEntity collDealEnt) {
		baseDao.insert("act_collcondeal_mid.insertTable", collDealEnt);
		
	}
	
	@Override
	public List<Map<String, Object>> getUnDealConInfo(Map<String, Object> inMap) {
		List<Map<String, Object>> unDealConInfoList = baseDao.queryForList("act_collbill_info.qNoDealContractInfo", inMap);
		return unDealConInfoList;
	}

	@Override
	public boolean isRePrint(long contractNo, int yearMonth, int printFlag) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("YEAR_MONTH", yearMonth);
		inMap.put("PRINT_FLAG", printFlag);
		int cnt = (int) baseDao.queryForObject("act_collbillprint_recd.qCnt", inMap);
		if (cnt > 0) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public CollectionDispEntity getCollBill(long contractNo, int yearMonth) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("BILL_CYCLE", yearMonth);
		CollectionDispEntity collBill = (CollectionDispEntity) baseDao.queryForObject("act_collbilldet_info.qBillDetInfo", inMap);
		return collBill;
	}
	
	@Override
	public void saveCollRecord(CollConDealRecdEntity CollConDealRecdEnt) {
		baseDao.insert("act_collcondeal_recd.insertRecd", CollConDealRecdEnt);
	}
	
	public IAccount getAccount() {
		return account;
	}

	public void setAccount(IAccount account) {
		this.account = account;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

	


}
