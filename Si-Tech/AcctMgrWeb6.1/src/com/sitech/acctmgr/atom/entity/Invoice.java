package com.sitech.acctmgr.atom.entity;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.MapUtils;

import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.invoice.ActCollbillprintRecd;
import com.sitech.acctmgr.atom.domains.invoice.BalGrppreinvInfo;
import com.sitech.acctmgr.atom.domains.invoice.BalInvauditInfo;
import com.sitech.acctmgr.atom.domains.invoice.BalInvprintInfoEntity;
import com.sitech.acctmgr.atom.domains.invoice.BalInvprintdetInfo;
import com.sitech.acctmgr.atom.domains.invoice.BalTaxinvoicePre;
import com.sitech.acctmgr.atom.domains.invoice.InvBillCycleEntity;
import com.sitech.acctmgr.atom.domains.invoice.InvoInfoEntity;
import com.sitech.acctmgr.atom.domains.invoice.LoginNoInfo;
import com.sitech.acctmgr.atom.domains.invoice.PreInvoiceRecycleEntity;
import com.sitech.acctmgr.atom.domains.invoice.PrintDataBlob;
import com.sitech.acctmgr.atom.domains.invoice.TaxInvoiceFeeEntity;
import com.sitech.acctmgr.atom.domains.invoice.TtWcityinvoice;
import com.sitech.acctmgr.atom.domains.invoice.TtWdisinvoice;
import com.sitech.acctmgr.atom.domains.invoice.TtWgroupinvoice;
import com.sitech.acctmgr.atom.domains.invoice.elecInvoice.EInvPdfEntity;
import com.sitech.acctmgr.atom.domains.invoice.elecInvoice.InvoiceXhfInfo;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.ICollection;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IInvoice;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.util.DateUtil;

/**
 * 
 * @Title: [公共发票类 ]
 * @Description: 存放发票数据生成等方法
 * @Date : 2016年3月9日上午9:29:45
 * @Company: SI-TECH
 * @author : LIJXD
 * @version : 1.0
 * @modify history
 *         <p>
 *         修改日期 修改人 修改目的
 *         <p>
 */
@SuppressWarnings("unchecked")
public class Invoice extends BaseBusi implements IInvoice {
	private static final int MIXQRY_INVMONTH = 201308;
	private IBalance balance;
	private IRecord record;
	private IControl control;
	private IUser user;
	private ICollection collection;
	private IGroup group;
	private ILogin login;
	private IPreOrder preOrder;

	@Override
	public void updatePrintFlagByMonth(int billCycle, long contractNo, long printSn) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("BILL_CYCLE", billCycle);
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("PRINT_SN", printSn);
		inMap.put("PRINT_FLAG", "1");
		inMap.put("PRINT_FLAG_OLD", "0");
		inMap.put("ACCPERT_PAYTYPE", "Y");
		for (int yearMonth = billCycle; yearMonth <= DateUtils.getCurYm(); yearMonth = DateUtils.addMonth(yearMonth, 1)) {
			inMap.put("SUFFIX", yearMonth);
			baseDao.update("bal_writeoff_yyyymm.uPrintFlag", inMap);
		}
	}

	@Override
	public void updatePrintFlagByPre(long paySn, long printSn, String payType, int billCycle, long contractNo, String printFlag) {
		// 根据缴费流水获取来源记录表中的账本ID，更新账本表中的print_flag和printSn
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("PAY_SN", paySn);
		inMap.put("SUFFIX", billCycle);
		inMap.put("CONTRACT_NO", contractNo);
		if (StringUtils.isNotEmpty(payType)) {
			inMap.put("PAY_TYPE", payType);
		}
		List<Map<String, Object>> bookSourceList = baseDao.queryForList("bal_booksource_info.qBookSourceByPaySn", inMap);

		for (Map<String, Object> bookSource : bookSourceList) {
			// 根据账本id更新账本记录
			inMap = new HashMap<String, Object>();
			String balanceId = bookSource.get("BALANCE_ID").toString();
			inMap.put("BALANCE_ID", balanceId);
			inMap.put("PRINT_SN", printSn);
			inMap.put("PRINT_FLAG", printFlag);
			baseDao.update("bal_acctbook_info.upPrintFlag", inMap);
			// 如果是已经冲销完了的，就需要更新bal_acctbook_his表中的状态
			inMap = new HashMap<String, Object>();
			for (int yearMonth = billCycle; yearMonth <= DateUtils.getCurYm(); yearMonth = DateUtils.addMonth(yearMonth, 1)) {
				inMap.put("SUFFIX", yearMonth);
				inMap.put("BALANCE_ID", balanceId);
				inMap.put("PAY_SN", paySn);
				inMap.put("PRINT_FLAG", printFlag);
				int cnt = baseDao.update("bal_acctbook_his.upPrintFlag", inMap);
				if (cnt > 0) {
					break;
				}
			}
			// 如果是离网用户的话，需要更新bal_acctbook_dead表中的状态
			baseDao.update("bal_acctbook_dead.upPrintFlag", inMap);

			// 更新冲销表中的记录
			// 根据balance_id和year_month查询账本支出表，获取冲销流水
			inMap.put("BALANCE_ID", balanceId);
			inMap.put("PRINT_FLAG", printFlag);
			inMap.put("PRINT_SN", printSn);
			for (int yearmonth = billCycle; yearmonth <= DateUtils.getCurYm(); yearmonth = DateUtils.addMonth(yearmonth, 1)) {
				inMap.put("SUFFIX", yearmonth);
				baseDao.update("bal_writeoff_yyyymm.uPrintFlag", inMap);
			}
		}

	}

	@Override
	public void updatePrintFlagByPre(long paySn, long printSn, String payType, int billCycle, long contractNo) {
		updatePrintFlagByPre(paySn, printSn, payType, billCycle, contractNo, "2");
	}

	@Override
	public void iBalInvprintInfo(List<BalInvprintInfoEntity> balInvprintInfoList) {
		for (BalInvprintInfoEntity balInvprintInfo : balInvprintInfoList) {
			baseDao.insert("bal_invprint_info.insInvPrintEntry", balInvprintInfo);
		}

	}

	@Override
	public void iBalGrppreInvInfo(BalGrppreinvInfo balGrpPreinvInfo) {
		baseDao.insert("bal_grppreinv_info.insertBalGrppreinvInfo", balGrpPreinvInfo);
		// 同步报表库
		List<Map<String, Object>> datatList = new ArrayList<Map<String, Object>>();
		Map<String, Object> invoiceMap = new HashMap<String, Object>();
		invoiceMap.put("GRP_CONTRACT_NO", balGrpPreinvInfo.getGrpContractNo());
		invoiceMap.put("LOGIN_ACCEPT", balGrpPreinvInfo.getLoginAccpet());
		invoiceMap.put("UNIT_ID", balGrpPreinvInfo.getUnitId());
		invoiceMap.put("UPDATE_TYPE", "I");
		invoiceMap.put("TABLE_NAME", "BAL_GRPPREINV_INFO");
		datatList.add(invoiceMap);
		Map<String, Object> reportMap = new HashMap<String, Object>();
		reportMap.put("ACTION_ID", "1016");
		reportMap.put("KEYS_LIST", datatList);
		reportMap.put("LOGIN_SN", balGrpPreinvInfo.getLoginAccpet());
		reportMap.put("OP_CODE", balGrpPreinvInfo.getOpCode());
		reportMap.put("LOGIN_NO", balGrpPreinvInfo.getLoginNo());
		preOrder.sendReportDataList(balGrpPreinvInfo.getHeader(), reportMap);
	}

	@Override
	public void iBalInvprintdetInfo(List<BalInvprintdetInfo> balInvprintdetInfoList) {
		for (BalInvprintdetInfo balInvprintdetInfo : balInvprintdetInfoList) {
			baseDao.insert("bal_invprintdet_info.iInvprintdetEntity", balInvprintdetInfo);
		}
	}

	@Override
	public int getPrintFlag(long paySn, int yearMonth, long contractNo) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		int printFlag = 0;
		for (int yearMonthTmp = yearMonth; yearMonthTmp <= DateUtils.getCurYm(); yearMonthTmp = DateUtils.addMonth(yearMonthTmp, 1)) {
			inMap.put("PAY_SN", paySn);
			inMap.put("SUFFIX", yearMonthTmp + "");
			inMap.put("CONTRACT_NO", contractNo);
			log.debug("查询是否打印的参数为：" + inMap);
			Map<String, Object> outMap = (Map<String, Object>) baseDao.queryForObject("bal_invprint_info.qPrintFlag", inMap);
			if (outMap != null) {
				printFlag = ValueUtils.intValue(outMap.get("CNT"));
			}
			if (printFlag > 0) {
				printFlag = 1;
				break;
			}
		}
		return printFlag;
	}

	@Override
	public Map<String, Object> getPrintInfo(long paySn, int yearMonth, long contractNo) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		Map<String, Object> outMap = new HashMap<String, Object>();
		for (int yearMonthTmp = yearMonth; yearMonthTmp <= DateUtils.getCurYm(); yearMonthTmp = DateUtils.addMonth(yearMonthTmp, 1)) {
			inMap.put("PAY_SN", paySn);
			inMap.put("SUFFIX", yearMonthTmp + "");
			inMap.put("CONTRACT_NO", contractNo);
			log.debug("查询是否打印的参数为：" + inMap);
			outMap = (Map<String, Object>) baseDao.queryForObject("bal_invprint_info.qPrintFlag", inMap);
			if (outMap != null) {
				log.debug("已找到，退出");
				outMap.put("YEAR_MONTH", yearMonthTmp);
				break;
			}
		}

		return outMap;
	}

	@Override
	public Map<String, Object> getInvoInfo(Map<String, Object> inMap, int pageNum, int pageSize) {
		// Map<String, Object> inParam = new HashMap<String, Object>();

		Map<String, Object> outMap = baseDao.queryForPagingList("bal_invprint_info.qInvInfo", inMap, pageNum, pageSize);
		return outMap;
	}

	@Override
	public List<BalInvprintInfoEntity> getInvoInfoByInvNo(Map<String, Object> inMap) {
		List<BalInvprintInfoEntity> balInvprintInfoList = baseDao.queryForList("bal_invprint_info.qInvInfoByinvNo", inMap);
		return balInvprintInfoList;
	}

	@Override
	public void updateStateByInvNo(Map<String, Object> inMap) {
		baseDao.update("bal_invprint_info.upInvStateByInvNo", inMap);
	}

	@Override
	public void updateGrpPrintState(Map<String, Object> inMap) {
		baseDao.update("bal_grppreinv_info.updateState", inMap);
		// 同步报表库
		List<Map<String, Object>> datatList = new ArrayList<Map<String, Object>>();
		Map<String, Object> snKey = new HashMap<String, Object>();
		snKey.put("LOGIN_ACCEPT", inMap.get("PRINT_SN"));

		if (StringUtils.isNotEmptyOrNull(inMap.get("CONTRACT_NO"))) {
			snKey.put("GRP_CONTRACT_NO", inMap.get("CONTRACT_NO"));
		}
		snKey.put("TABLE_NAME", "BAL_GRPPREINV_INFO");
		snKey.put("UPDATE_TYPE", "U");
		datatList.add(snKey);

		Map<String, Object> reportMap = new HashMap<String, Object>();
		reportMap.put("ACTION_ID", "1016");
		reportMap.put("KEYS_LIST", datatList);
		reportMap.put("LOGIN_SN", inMap.get("PRINT_SN"));
		reportMap.put("OP_CODE", inMap.get("OP_CODE"));
		reportMap.put("LOGIN_NO", inMap.get("LOGIN_NO"));
		preOrder.sendReportDataList((Map<String, Object>) inMap.get("HEADER"), reportMap);

	}

	@Override
	public int qryCntGrp(Map<String, Object> inMap) {
		int cnt = 0;
		Map<String, Object> cntMap = (Map<String, Object>) baseDao.queryForObject("bal_grppreinv_info.qryCntGrpInv", inMap);
		cnt = ValueUtils.intValue(cntMap.get("CNT"));
		return cnt;
	}

	@Override
	public boolean isPrintMonthInvoice(int billCycle, long contractNo, int suffix) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("BILL_CYCLE", billCycle);
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("SUFFIX", suffix + "");
		Map<String, Object> outMap = new HashMap<String, Object>();
		outMap = (Map<String, Object>) baseDao.queryForObject("bal_invprint_info.qMonthinvCnt", inMap);
		if (StringUtils.isNotEmptyOrNull(outMap)) {
			if (ValueUtils.intValue(outMap.get("CNT")) == 0) {
				return false;
			}
		}
		return true;
	}

	@Override
	public void bakGrpPreInv(Map<String, Object> inMap) {
		if (StringUtils.isEmptyOrNull(inMap.get("STATE_HIS"))) {
			inMap.put("STATE_HIS", "p");
		}
		baseDao.insert("bal_grppreinv_his.insertHis", inMap);
		// 同步报表库
		int curYm = DateUtils.getCurYm();
		Map<String, Object> invoiceMap = new HashMap<String, Object>();
		if (StringUtils.isNotEmptyOrNull(inMap.get("INV_NO"))) {
			invoiceMap.put("INV_NO", inMap.get("INV_NO"));
		}
		if (StringUtils.isNotEmptyOrNull(inMap.get("CONTRACT_NO"))) {
			invoiceMap.put("GRP_CONTRACT_NO", inMap.get("CONTRACT_NO"));
		}
		if (StringUtils.isNotEmptyOrNull(inMap.get("PRINT_SN"))) {
			invoiceMap.put("LOGIN_ACCPET", inMap.get("PRINT_SN"));
		}
		invoiceMap.put("TO_CHAR(UPDATE_TIME,'YYYYMM')", curYm + "");

		Map<String, Object> reportMap = new HashMap<String, Object>();
		reportMap.put("ACTION_ID", "1017");
		reportMap.put("KEY_DATA", invoiceMap);
		reportMap.put("LOGIN_SN", inMap.get("PRINT_SN"));
		reportMap.put("OP_CODE", inMap.get("OP_CODE"));
		reportMap.put("LOGIN_NO", inMap.get("LOGIN_NO"));
		preOrder.sendReportData((Map<String, Object>) inMap.get("HEADER"), reportMap);

	}

	@Override
	public List<PreInvoiceRecycleEntity> getPreInvoiceRecycleTotal(long unitId, int billCycle) {

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("UNIT_ID", unitId);
		inMap.put("SUFFIX", billCycle);
		inMap.put("STATE", CommonConst.YKFP_FLAG);

		List<PreInvoiceRecycleEntity> preInvociceList = baseDao.queryForList("bal_grppreinv_info.qryGrpInvTotal", inMap);
		return preInvociceList;
	}

	@Override
	public List<PreInvoiceRecycleEntity> getPreInvoiceRecycleDetail(long unitId, long printSn) {

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("UNIT_ID", unitId);
		inMap.put("LOGIN_ACCEPT", printSn);
		inMap.put("STATE", CommonConst.YKFP_FLAG);

		List<PreInvoiceRecycleEntity> preInvociceList = baseDao.queryForList("bal_grppreinv_info.qryGrpInvDetail", inMap);
		return preInvociceList;
	}

	@Override
	public int isPrintPreInvoice(Map<String, Object> inMap) {
		int printedPre = 0;
		// 根据缴费流水来源表中的balance_id
		int yearMonth = ValueUtils.intValue(inMap.get("SUFFIX"));
		List<Map<String, Object>> bookSourceList = baseDao.queryForList("bal_booksource_info.qBookSourceByPaySn", inMap);
		if (bookSourceList.size() == 0) {
			return 0;
		}
		k: for (Map<String, Object> bookSource : bookSourceList) {
			long balanceId = ValueUtils.longValue(bookSource.get("BALANCE_ID").toString());
			Map<String, Object> inParam = new HashMap<String, Object>();
			inParam.put("SUFFIX", inMap.get("SUFFIX"));
			inParam.put("BALANCE_ID", balanceId);
			// 查询账本表中的printFlag，如果print_flag不为0，表示已经打印过，不能在打印
			Map<String, Object> outMap = new HashMap<String, Object>();
			outMap = (Map<String, Object>) baseDao.queryForObject("bal_acctbook_info.qryPrintFlag", inParam);
			if (outMap != null) {
				printedPre = ValueUtils.intValue(outMap.get("PRINT_FLAG").toString());
			}

			if (printedPre == 0) {
				outMap = (Map<String, Object>) baseDao.queryForObject("bal_acctbook_dead.qryPrintFlag", inParam);
				if (outMap != null) {
					printedPre = ValueUtils.intValue(outMap.get("PRINT_FLAG").toString());
				}
			}
			if (printedPre == 0) {
				for (int ym = yearMonth; ym <= DateUtils.getCurYm(); ym = DateUtils.addMonth(ym, 1)) {
					inParam.put("SUFFIX", ym);
					inParam.put("BALANCE_ID", balanceId);
					outMap = (Map<String, Object>) baseDao.queryForObject("bal_acctbook_his.qryPrintFlag", inParam);
					if (outMap != null) {
						printedPre = ValueUtils.intValue(outMap.get("PRINT_FLAG").toString());
						break k;
					}
				}
			}
		}

		return printedPre;
	}

	@Override
	public int isPrintMonthInvoice(Map<String, Object> inMap) {
		// 根据缴费流水来源表中的balance_id
		int yearMonth = ValueUtils.intValue(inMap.get("SUFFIX"));
		inMap.put("ACCPERT_PAYTYPE", "true");
		List<Map<String, Object>> bookSourceList = baseDao.queryForList("bal_booksource_info.qBookSourceByPaySn", inMap);
		if (bookSourceList.size() == 0) {
			return 0;
		}
		int cnt = 0;
		String[] printFlag = { "1" };
		k: for (Map<String, Object> bookSource : bookSourceList) {
			long balanceId = ValueUtils.longValue(bookSource.get("BALANCE_ID").toString());

			Map<String, Object> inParam = new HashMap<String, Object>();
			// 根据balanceId查询支出表记录
			inParam.put("BALANCE_ID", balanceId);

			for (int ym = yearMonth; ym <= DateUtils.getCurYm(); ym = DateUtils.addMonth(ym, 1)) {
				inParam.put("SUFFIX", ym);
				List<Map<String, Object>> payoutList = baseDao.queryForList("bal_bookpayout_info.qBookPayoutByPaySn", inParam);
				// 查询冲销记录表，判断是否已经打印过
				for (Map<String, Object> payoutMap : payoutList) {
					long wrtSn = ValueUtils.longValue(payoutMap.get("WRTOFF_SN"));
					Map<String, Object> wrtInMap = new HashMap<String, Object>();
					wrtInMap.put("SUFFIX", ym);
					wrtInMap.put("WRTOFF_SN", wrtSn);
					// 查询打印记录，判断是不是打印了月结发票
					wrtInMap.put("PRINT_FLAG", printFlag);
					cnt = (int) baseDao.queryForObject("bal_writeoff_yyyymm.qryPrintFlag", wrtInMap);
					if (cnt > 0) {
						cnt = 1;
						break k;
					}
				}
			}
		}

		return cnt;
	}

	@Override
	public int getWritoffCnt(long contractNo) {

		Map<String, Object> inParam = new HashMap<String, Object>();
		MapUtils.safeAddToMap(inParam, "CONTRACT_NO", contractNo);

		Map<String, Object> outParam = (Map<String, Object>) baseDao.queryForObject("int_rtwrtoff_chg.qCntOfRtwroffByCon", inParam);

		return MapUtils.getInteger(outParam, "CNT");
	}

	@Override
	public long getPrintSn() {
		Map<String, Object> inTemp = new HashMap<String, Object>();
		inTemp.put("SEQ_NAME", "SEQ_SYSTEM_SN");
		Map<String, Object> outParam = (Map<String, Object>) baseDao.queryForObject("dual.qSequence", inTemp);
		long printSn = Long.valueOf(outParam.get("NEXTVAL").toString());

		return printSn;
	}

	public void upPrintFlagByPrestore(long paySn, long contractNo, long idNo, long printSn, String userFlag) {

		// TODO Auto-generated method stub
		Map<String, Object> inParam = new HashMap<String, Object>();
		Map<String, Object> mOutTemp = new HashMap<String, Object>();
		List<Map<String, Object>> payOutList = new ArrayList<Map<String, Object>>();
		long lWrtoffSn = 0;
		long lBalanceId = 0;

		String sCurMon = DateUtil.format(new Date(), "yyyyMM");
		// int cnt=0;
		inParam.put("PAY_SN", paySn);
		inParam.put("CONTRACT_NO", contractNo);
		inParam.put("PRINT_FLAG", "2");
		inParam.put("SUFFIX", sCurMon);
		inParam.put("USER_FLAG", userFlag);
		balance.upAcctBookPrintFlag(inParam);
		if (idNo > 0) {
			inParam.put("ID_NO", idNo);
		}

		Set<Long> balanceIdSet = new HashSet<Long>();
		/** 1.检查是否传入缴费年月 **/
		inParam = new HashMap<String, Object>();
		inParam.put("CODE_CLASS", 108);
		PubCodeDictEntity PubCode = (PubCodeDictEntity) baseDao.queryForObject("pub_codedef_dict.qVision", inParam);
		int billYM = ValueUtils.intValue(PubCode.getCodeValue());

		/** 2.如果没有缴费年月，查询缴费年月 **/
		int payYm = ValueUtils.intValue(sCurMon);
		inParam = new HashMap<String, Object>();
		MapUtils.safeAddToMap(inParam, "PAY_SN", paySn);
		MapUtils.safeAddToMap(inParam, "CONTRACT_NO", contractNo);

		do {
			MapUtils.safeAddToMap(inParam, "SUFFIX", payYm);
			/** 对一点支付账户和普通账户区分 **/

			List<Map<String, Object>> resultList2 = (List<Map<String, Object>>) baseDao
					.queryForList("bal_booksource_info.qBalanceidByPaySn", inParam);
			if (resultList2.size() > 0) {

				for (Map<String, Object> resulmap2 : resultList2) {
					if (!balanceIdSet.contains(ValueUtils.longValue(resulmap2.get("BALANCE_ID")))) {
						balanceIdSet.add(ValueUtils.longValue(resulmap2.get("BALANCE_ID")));
					}
				}
				break;
			}

			/**
			 * 如果顶级账户给二级账户转账，如何查询二级账户的费用。 一点支付顶级账户作废预存发票。 回退二级账户的冲销记录的print_flag。
			 * **/
			payYm = Integer.parseInt(DateUtil.toStringPlusMonths("" + payYm, -1, "yyyyMM"));// 往前倒退月，退到最小年月
		} while (payYm >= billYM);

		if (payYm < billYM) {
			throw new BusiException(AcctMgrError.getErrorCode("8060", "00001"), "缴费记录不存在！");
		}
		/** 循环每个balance_id **/
		Iterator<Long> itr = balanceIdSet.iterator();
		while (itr.hasNext()) {
			/** 3.查出账本支出的月份和支出流水 **/

			lBalanceId = itr.next();

			List<Map<String, Object>> wrtList = qryPayOutWithBalanceByPayFee(payYm, lBalanceId, 0);
			for (Map<String, Object> writMap : wrtList) {

				long wrtoffSn = ValueUtils.longValue(writMap.get("WRTOFF_SN"));
				long balanceIdTmp = ValueUtils.longValue(writMap.get("BALANCE_ID"));
				String yearMonth = writMap.get("BILL_CYCLE").toString();

				inParam = new HashMap<String, Object>();
				MapUtils.safeAddToMap(inParam, "PRINT_FLAG", "2");
				MapUtils.safeAddToMap(inParam, "SUFFIX", yearMonth);
				MapUtils.safeAddToMap(inParam, "PRINT_SN", printSn);
				MapUtils.safeAddToMap(inParam, "CONTRACT_NO", contractNo);
				MapUtils.safeAddToMap(inParam, "WRTOFF_SN", wrtoffSn);
				MapUtils.safeAddToMap(inParam, "BALANCE_ID", balanceIdTmp);
				MapUtils.safeAddToMap(inParam, "PRINT_FLAG_OLD", "0");
				baseDao.update("bal_writeoff_yyyymm.uPrintFlag", inParam);
			}
		}
	}

	@Override
	public void upPrintFlagByPrestore(long lPaySn, long lContractNo, long lIdNo, long printSn) {
		upPrintFlagByPrestore(lPaySn, lContractNo, lIdNo, lPaySn, "0");
	}

	@Override
	public List<Map<String, Object>> qryPayOutWithBalanceByPayFee(int iNaturalMon, long balanceId, long payFee) {
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		Map<String, Object> inParam = new HashMap<String, Object>();
		Map<String, Object> mOutTemp = null;
		Map<String, Object> payOutMap = null;
		List<Map<String, Object>> payOutList = null;
		String suffix = "";
		int iBillCycleTemp = 0;
		int iCurYm = 0;
		long lWrtoffSn = 0;
		long lBalanceId = 0;
		long contractNo = 0;
		long outBalance = 0;
		long delayFee = 0;
		iCurYm = DateUtils.getCurYm();
		iBillCycleTemp = iNaturalMon;

		while (iBillCycleTemp <= iCurYm) {

			inParam.clear();
			suffix = "" + iBillCycleTemp;
			inParam.put("SUFFIX", iBillCycleTemp);
			inParam.put("BALANCE_ID", balanceId);

			/* 查询账本支出表 */
			mOutTemp = balance.getPayOutList(inParam);

			if (mOutTemp != null) {
				payOutList = (List<Map<String, Object>>) mOutTemp.get("BOOKPAYOUT_LIST");

				for (Map<String, Object> payOut : payOutList) {
					lWrtoffSn = 0;
					lBalanceId = 0;
					contractNo = 0;
					outBalance = 0;
					delayFee = 0;
					payOutMap = new HashMap<String, Object>();

					lWrtoffSn = Long.parseLong(payOut.get("WRTOFF_SN").toString());
					lBalanceId = Long.parseLong(payOut.get("BALANCE_ID").toString());
					contractNo = ValueUtils.longValue(payOut.get("CONTRACT_NO").toString());
					outBalance = ValueUtils.longValue(payOut.get("OUT_BALANCE"));
					delayFee = ValueUtils.longValue(payOut.get("DELAY_FEE"));

					payOutMap.put("WRTOFF_SN", lWrtoffSn);
					payOutMap.put("BALANCE_ID", lBalanceId);
					payOutMap.put("BILL_CYCLE", iBillCycleTemp);
					payOutMap.put("CONTRACT_NO", contractNo);

					result.add(payOutMap);
					/* if(payFee>0){ payFee = payFee-outBalance-delayFee; if(payFee<=0){//支出金额与缴费金额相等，停止循环 break; } } */
				}
			}
			/* if(payFee<=0){//支出金额与缴费金额相等，停止循环 break; } */
			iBillCycleTemp = Integer.parseInt(DateUtil.toStringPlusMonths("" + iBillCycleTemp, 1, "yyyyMM"));
		}

		return result;
	}

	/* 此方法根据pay_sn查询账本支出表 */
	private List<Map<String, Object>> qryPayOut(int iNaturalMon, long lPaySn) {

		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		Map<String, Object> inParam = new HashMap<String, Object>();
		Map<String, Object> payOutMap = null;
		int iBillCycleTemp = 0;
		int iCurYm = 0;
		long lBalanceId = 0;
		long contractNo = 0;
		iCurYm = Integer.parseInt(DateUtil.format(new Date(), "yyyyMM"));
		iBillCycleTemp = iNaturalMon;
		Set<Long> balanceIdSet = new HashSet<Long>();
		inParam.put("CODE_CLASS", 108);
		PubCodeDictEntity mOutTemp = (PubCodeDictEntity) baseDao.queryForObject("pub_codedef_dict.qVision", inParam);
		int billYM = ValueUtils.intValue(mOutTemp.getCodeValue());

		while (iBillCycleTemp >= billYM) {

			inParam = new HashMap<String, Object>();

			inParam.put("SUFFIX", iBillCycleTemp);
			inParam.put("PAY_SN", lPaySn);

			List<Map<String, Object>> resultList2 = (List<Map<String, Object>>) baseDao
					.queryForList("bal_booksource_info.qBalanceidByPaySn", inParam);

			if (resultList2.size() > 0) {
				for (Map<String, Object> sourceMap : resultList2) {
					long balanceId = ValueUtils.longValue(sourceMap.get("BALANCE_ID"));
					if (!balanceIdSet.contains(balanceId)) {
						balanceIdSet.add(balanceId);
					}
				}
				break;
			}

			/* 查询账本支出表 */
			/* mOutTemp = balance.getPayOutList(inParam);
			 * 
			 * if(mOutTemp!=null){ payOutList = (List<Map<String,Object>>)mOutTemp.get("BOOKPAYOUT_LIST");
			 * 
			 * for(Map<String,Object> payOut:payOutList){ lWrtoffSn=0; lBalanceId=0; contractNo=0; payOutMap = new HashMap<String,Object>();
			 * 
			 * lWrtoffSn = Long.parseLong(payOut.get("WRTOFF_SN").toString()); lBalanceId = Long.parseLong(payOut.get("BALANCE_ID").toString()); contractNo = ValueUtils.longValue(payOut.get("CONTRACT_NO").toString());
			 * 
			 * payOutMap.put("WRTOFF_SN", lWrtoffSn); payOutMap.put("BALANCE_ID",lBalanceId); payOutMap.put("BILL_CYCLE", iBillCycleTemp); payOutMap.put("CONTRACT_NO", contractNo);
			 * 
			 * result.add(payOutMap);
			 * 
			 * } } */
			iBillCycleTemp = Integer.parseInt(DateUtil.toStringPlusMonths("" + iBillCycleTemp, -1, "yyyyMM"));
		}

		/** 循环每个balance_id **/
		Iterator<Long> itr = balanceIdSet.iterator();
		while (itr.hasNext()) {
			/** 3.查出账本支出的月份和支出流水 **/
			lBalanceId = itr.next();

			List<Map<String, Object>> wrtList = qryPayOutWithBalanceByPayFee(iBillCycleTemp, lBalanceId, 0);

			for (Map<String, Object> writMap : wrtList) {
				long wrtoffSn = ValueUtils.longValue(writMap.get("WRTOFF_SN"));
				long balanceIdTmp = ValueUtils.longValue(writMap.get("BALANCE_ID"));
				long billCycle = ValueUtils.intValue(writMap.get("BILL_CYCLE"));
				contractNo = ValueUtils.longValue(writMap.get("CONTRACT_NO").toString());
				payOutMap = new HashMap<String, Object>();

				payOutMap.put("WRTOFF_SN", wrtoffSn);
				payOutMap.put("BALANCE_ID", balanceIdTmp);
				payOutMap.put("BILL_CYCLE", billCycle);
				payOutMap.put("CONTRACT_NO", contractNo);

				result.add(payOutMap);

			}
		}

		return result;
	}

	public void updataInvprint(final Map<String, Object> inParam) {
		Map<String, Object> inTemp = new HashMap<String, Object>();
		inTemp.putAll(inParam);
		inTemp.put("PRINT_NUM", 1);
		inTemp.put("REMARK", "月结发票.合打");
		String suffix = DateUtil.format(new Date(), "yyyyMM");
		inTemp.put("SUFFIX", "" + suffix);
		// System.out.println("inTemp="+inTemp);
		baseDao.update("bal_invprint_info.uInvPrint", inTemp);
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IInvoice#insDetXml(long, long, int, java.lang.String) */
	@Override
	public void insDetXml(long printSn, int yearMonth, String printXmlStr) {

		PrintDataBlob updateObj = new PrintDataBlob();
		updateObj.setPrintSn(printSn);
		try {
			updateObj.setPrintContent(printXmlStr.getBytes("GBK"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		updateObj.setYearMonth(yearMonth);
		log.debug("updateObj.getPrintContent" + new String(updateObj.getPrintContent()));
		baseDao.update("bal_invprintdet_info.upXMLByPrintSn", updateObj);
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IInvoice#getAllPrintModelId() */
	@Override
	public List<Map<String, Object>> getAllPrintModelId() {
		Map<String, Object> inParam = new HashMap<String, Object>();

		List<Map<String, Object>> result = (List<Map<String, Object>>) baseDao.queryForList("bal_orderprintmodel_conf.qModelIdByPntType", inParam);

		return result;
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IInvoice#getPrintModelId(java.lang.String, java.lang.String) */
	@Override
	public String getPrintModelId(String sOpCode, String sPrintType) {
		Map<String, Object> inParam = new HashMap<String, Object>();
		Map<String, Object> outParam = new HashMap<String, Object>();
		inParam.put("OP_CODE", sOpCode);
		inParam.put("PRINT_TYPE", sPrintType);
		outParam = (Map<String, Object>) baseDao.queryForObject("bal_orderprintmodel_conf.qModelIdByPntType", inParam);
		if (outParam != null) {
			String sPrintModelId = outParam.get("PRINT_MODEL_ID").toString();
			return sPrintModelId;
		} else {
			return null;
		}
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IInvoice#getPrintModel(java.lang.String, java.lang.String) */
	@Override
	public Map<String, Object> getPrintModel(String sModelID) {

		Map<String, Object> outParam = null;
		Map<String, Object> inParam = new HashMap<String, Object>();
		inParam.put("PRINT_MODEL_ID", sModelID);
		outParam = (Map<String, Object>) baseDao.queryForObject("BAL_PRINTMODELCFG_DICT.qModelByModelId", inParam);
		return outParam;
	}

	@Override
	public void oprVirtualBloc(long printSn, int qryMon, String loginNo) {

		Map<String, Object> inTmp = new HashMap<String, Object>();
		System.out.println("printSn=" + printSn + "qryMon=" + qryMon);
		// 修改状态
		inTmp.put("LOGIN_ACCPET", printSn);
		inTmp.put("QRY_MON", qryMon);
		inTmp.put("STATE", "r");
		inTmp.put("UPDATE_LOGIN_NO", loginNo);
		baseDao.update("bal_grppreinv_info.upState", inTmp);

		// 插入历史表
		baseDao.insert("bal_grppreinv_his.insert", inTmp);
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IInvoice#dealWriteoffForZf(java.util.List) */
	@Override
	public void dealWriteoffForZf(List<InvoInfoEntity> invList, int payYm) {
		Map<String, Object> inParam = new HashMap<String, Object>();
		List<InvoInfoEntity> invListTmp;
		/** 判断是否是小于最小冲销表年月 **/
		inParam.put("CODE_CLASS", 108);
		// Map<String,Object> mOutTemp = (Map<String,Object>)baseDao.queryForObject("pub_codedef_dict.",inParam);
		PubCodeDictEntity pubCodent = (PubCodeDictEntity) baseDao.queryForObject("pub_codedef_dict.qVision", inParam);
		int billYM = ValueUtils.intValue(pubCodent.getCodeValue());

		for (InvoInfoEntity invEnt : invList) {

			int onlineFlag = invEnt.getOnlineFlag();
			long printSn = invEnt.getPrintSn();
			String printSnStr = invEnt.getPrintSnStr();
			String yearMon = invEnt.getBillCycleStr();
			int printArray = 0;
			if (invEnt.getPrintArray() > 0) {
				printArray = invEnt.getPrintArray();
			}

			int billCycle = ValueUtils.intValue(yearMon);
			if (onlineFlag == 0) {
				inParam.put("PRINT_SN", printSn);
			} else {
				inParam.put("PRINT_SN", printSnStr);
			}
			inParam.put("YEAR_MONTH", "" + yearMon);
			if (printArray > 0) {
				inParam.put("PRINT_ARRAY", printArray);
			}
			if (onlineFlag == 0) {
				invListTmp = (List<InvoInfoEntity>) baseDao.queryForList("bal_invprint_info.qPrintedByPaySn", inParam);
			} else {
				invListTmp = (List<InvoInfoEntity>) baseDao.queryForList("bal_invprint_info.qPrintedByPaySnoffline", inParam);
			}
			log.debug("invListTmp=" + invListTmp);
			if (invListTmp.size() > 0) {
				inParam.put("SUFFIX", "" + yearMon);
				inParam.put("STATE", "2");
				baseDao.update("bal_invprint_info.upTaxInvSTATEByPrintSn", inParam);
			}

			/**
			 * 预存发票跳过 if(invEnt.getInvType().startsWith("P")){ //continue; }
			 **/

			/** 修改冲销表print_flag **/
			for (InvoInfoEntity invEntTmp : invListTmp) {
				long contractNo = invEntTmp.getContractNo();
				int billCycleTmp = invEntTmp.getBillCyle();
				long paySn = invEntTmp.getPaySn();

				inParam = new HashMap<String, Object>();
				inParam.put("CONTRACT_NO", contractNo);
				Map<String, Object> relconMap = (Map<String, Object>) baseDao.queryForObject("cs_account_rel.qCntAccountRelByCon", inParam);
				int relCnt = ValueUtils.intValue(relconMap.get("NUM"));

				if (invEnt.getInvType().startsWith("P")) {
					inParam = new HashMap<String, Object>();
					inParam.put("CONTRACT_NO", contractNo);
					inParam.put("PAY_SN", invEntTmp.getPaySn());
					inParam.put("PRINT_FLAG", "0");
					baseDao.update("bal_acctbook_info.upPrintFlag", inParam);
				}

				/** 判断是否是割接前 **/
				if (billCycleTmp == 0 || onlineFlag == -1) {

					int beginYm = invEntTmp.getBeginYMD() / 100;
					int endYm = invEntTmp.getEndYMD() / 100;

					while (beginYm <= endYm) {

						billCycleTmp = beginYm;

						int naturalMon = billCycleTmp;

						if (billYM > billCycleTmp) {
							billCycleTmp = billYM;
						}

						while (billCycleTmp <= billCycle) {

							inParam = new HashMap<String, Object>();
							inParam.put("YEAR_MONTH", "" + billCycleTmp);
							if (relCnt > 0) {
								inParam.put("TOP_CONTRACT_NO", contractNo);
							} else {
								inParam.put("CONTRACT_NO", contractNo);
							}
							// inParam.put("PRINT_SN",printSnStr);
							if (printArray > 0 && !invEnt.getInvType().startsWith("P") && naturalMon > 0) {
								inParam.put("BILL_CYCLE", naturalMon);
							}
							Map<String, Object> outParam = (Map<String, Object>) baseDao.queryForObject("bal_writeoff_yyyymm.qCntByPrintSn", inParam);
							if (ValueUtils.intValue(outParam.get("CNT")) > 0) {
								inParam.put("PRINT_FLAG", "0");
								inParam.put("SUFFIX", "" + billCycleTmp);
								inParam.put("PRINT_SN", ValueUtils.longValue(0));
								baseDao.update("bal_writeoff_yyyymm.uPrintFlag", inParam);
							}

							billCycleTmp = Integer.parseInt(DateUtil.toStringPlusMonths("" + billCycleTmp, 1, "yyyyMM"));

						}
						beginYm = Integer.parseInt(DateUtil.toStringPlusMonths("" + beginYm, 1, "yyyyMM"));
					}

				} else {
					/** 割接后数据 **/
					int naturalMon = billCycleTmp;

					if (billYM > billCycleTmp) {
						billCycleTmp = billYM;
					}

					if (!invEnt.getInvType().startsWith("P")) {
						/** 消费发票回退 **/
						while (billCycleTmp <= billCycle) {

							inParam = new HashMap<String, Object>();
							inParam.put("YEAR_MONTH", "" + billCycleTmp);
							if (relCnt > 0) {
								inParam.put("TOP_CONTRACT_NO", contractNo);
							} else {
								inParam.put("CONTRACT_NO", contractNo);
							}
							inParam.put("PRINT_SN", printSn);
							if (printArray > 0 && naturalMon > 0) {
								inParam.put("BILL_CYCLE", naturalMon);//
							}
							Map<String, Object> outParam = (Map<String, Object>) baseDao.queryForObject("bal_writeoff_yyyymm.qCntByPrintSn", inParam);
							if (ValueUtils.intValue(outParam.get("CNT")) > 0) {
								inParam.put("PRINT_FLAG", "0");
								inParam.put("SUFFIX", "" + billCycleTmp);
								inParam.put("PRINT_SN", ValueUtils.longValue(0));
								inParam.put("PRINT_SN_OLD", printSn);
								baseDao.update("bal_writeoff_yyyymm.uPrintFlag", inParam);

								/** 若回退预存发票，这里是回退到打印时已经冲销的费用，不包括之后冲销的费用 **/
							}

							billCycleTmp = Integer.parseInt(DateUtil.toStringPlusMonths("" + billCycleTmp, 1, "yyyyMM"));

						}
					} else if (invEntTmp.getPrintFee() > 0) {
						/** 预存发票回退 **/
						/** 0.如果是一点支付则取最新的pay_sn **/
						/* int iCurYm = Integer.parseInt(DateUtil.format(new Date(),"yyyyMM")); if(payYm==0){ payYm = billCycleTmp; } if(relCnt>0){
						 * 
						 * inParam = new HashMap<String,Object>(); MapUtils.safeAddToMap(inParam, "PAY_SN", paySn); MapUtils.safeAddToMap(inParam, "CONTRACT_NO", contractNo); do{ MapUtils.safeAddToMap(inParam, "SUFFIX", payYm); Map<String,Object> outTemp = balance.getSumPayFeeByPaySn(inParam); payYm = Integer.parseInt(DateUtil.toStringPlusMonths(""+payYm,-1,"yyyyMM"));//往前倒退月，退到最小年月 }while(payYm>billYM);
						 * 
						 * inParam = new HashMap<String,Object>(); MapUtils.safeAddToMap(inParam, "FOREIGN_SN", ""+paySn);
						 * 
						 * if(payYm==0){ do{ MapUtils.safeAddToMap(inParam, "YEAR_MONTH", payYm); List<Map<String,Object>> tansList = (List<Map<String,Object>>)baseDao.queryForObject("bal_payment_info.qRelPaySnByForeignSn", inParam); if(tansList.size()>0){ break; } payYm = Integer.parseInt(DateUtil.toStringPlusMonths(""+payYm,-1,"yyyyMM"));//往前倒退月，退到最小年月 }while(payYm>=billYM); }else{
						 * 
						 * }
						 * 
						 * }else{
						 * 
						 * } */

						Set<Long> balanceIdSet = new HashSet<Long>();
						/** 1.检查是否传入缴费年月 **/
						long balanceId = 0;

						/** 2.如果没有缴费年月，查询缴费年月 **/
						payYm = billCycleTmp;
						inParam = new HashMap<String, Object>();
						MapUtils.safeAddToMap(inParam, "PAY_SN", paySn);
						MapUtils.safeAddToMap(inParam, "CONTRACT_NO", contractNo);

						do {
							MapUtils.safeAddToMap(inParam, "SUFFIX", payYm);
							/** 对一点支付账户和普通账户区分 **/

							List<Map<String, Object>> resultList2 = (List<Map<String, Object>>) baseDao.queryForList(
									"bal_booksource_info.qBalanceidByPaySn", inParam);
							if (resultList2.size() > 0) {

								for (Map<String, Object> resulmap2 : resultList2) {
									if (!balanceIdSet.contains(ValueUtils.longValue(resulmap2.get("BALANCE_ID")))) {
										balanceIdSet.add(ValueUtils.longValue(resulmap2.get("BALANCE_ID")));
									}
								}
								break;
							}

							/**
							 * 如果顶级账户给二级账户转账，如何查询二级账户的费用。 一点支付顶级账户作废预存发票。 回退二级账户的冲销记录的print_flag。
							 * **/
							payYm = Integer.parseInt(DateUtil.toStringPlusMonths("" + payYm, -1, "yyyyMM"));// 往前倒退月，退到最小年月
						} while (payYm >= billYM);

						if (payYm < billYM) {
							throw new BusiException(AcctMgrError.getErrorCode("8060", "00001"), "缴费记录不存在！");
						}
						/** 循环每个balance_id **/
						Iterator<Long> itr = balanceIdSet.iterator();
						while (itr.hasNext()) {
							/** 3.查出账本支出的月份和支出流水 **/

							balanceId = itr.next();

							List<Map<String, Object>> wrtList = qryPayOutWithBalanceByPayFee(payYm, balanceId, invEntTmp.getPrintFee());
							for (Map<String, Object> writMap : wrtList) {

								long wrtoffSn = ValueUtils.longValue(writMap.get("WRTOFF_SN"));
								long balanceIdTmp = ValueUtils.longValue(writMap.get("BALANCE_ID"));
								String yearMonth = writMap.get("BILL_CYCLE").toString();

								inParam = new HashMap<String, Object>();
								MapUtils.safeAddToMap(inParam, "PRINT_FLAG", "0");
								MapUtils.safeAddToMap(inParam, "SUFFIX", yearMonth);
								MapUtils.safeAddToMap(inParam, "PRINT_SN", ValueUtils.longValue(0));
								MapUtils.safeAddToMap(inParam, "CONTRACT_NO", contractNo);
								MapUtils.safeAddToMap(inParam, "WRTOFF_SN", wrtoffSn);
								MapUtils.safeAddToMap(inParam, "BALANCE_ID", balanceIdTmp);
								baseDao.update("bal_writeoff_yyyymm.uPrintFlag", inParam);
							}
						}

					}

					log.debug("printArray=" + printArray + "   " + invEnt.getInvType());
					/** 修改自定义发票状态 **/
					/* if(!invEnt.getInvType().startsWith("P")){
					 * 
					 * int cnt = getAssignFeeCnt(contractNo,0,naturalMon,printSn); if(cnt>0){ Map<String,Object> outParam = getAssignFeeOfMon(contractNo,0,naturalMon,printSn); *//** 修改状态为a **/
					/* inParam = new HashMap<String,Object>(); inParam.put("WRTOFF_SN", outParam.get("WRTOFF_SN")); inParam.put("BILL_ID", outParam.get("BILL_ID")); inParam.put("BALANCE_ID", outParam.get("BALANCE_ID")); inParam.put("PRINT_SN", printSn); inParam.put("PRINT_FLAG", "a"); upInvUserDefine(inParam);
					 * 
					 * if(ValueUtils.longValue(outParam.get("LAST_PRINT_SN"))>0){ inParam = new HashMap<String,Object>(); inParam.put("CONTRACT_NO", contractNo); if(naturalMon>0){ inParam.put("LAST_YEARMONTH", naturalMon); } inParam.put("PRINT_SN", outParam.get("LAST_PRINT_SN")); inParam.put("PRINT_FLAG", "0"); upInvUserDefine(inParam); } } } */
				}
			}

		}

	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.IInvoice#getInvOfRelatePaySn(long, int, long) */
	@Override
	public List<InvoInfoEntity> getInvOfRelatePaySn(long paySn, int yearMon, long contractNo) {
		List<InvoInfoEntity> invList = new ArrayList<InvoInfoEntity>();
		Map<String, Object> inParam = new HashMap<String, Object>();
		Set<Long> printSnSet = new HashSet<Long>();

		int iCurMon = Integer.parseInt(DateUtil.format(new Date(), "yyyyMM"));
		int yearMonTmp = yearMon;
		long printSn = 0;

		inParam.put("CONTRACT_NO", contractNo);
		inParam.put("PAY_SN", paySn);
		/** 循环查找发票记录总表 **/
		while (yearMonTmp <= iCurMon) {
			inParam.put("YEAR_MONTH", "" + yearMonTmp);
			List<InvoInfoEntity> invListTmp = (List<InvoInfoEntity>) baseDao.queryForList("bal_invprint_info.qPrintedByPaySnMuti03", inParam);

			if (invListTmp.size() > 0) {
				printSn = invListTmp.get(0).getPrintSn();
				invList.addAll(invListTmp);
				break;
			} else {
				String sqlIdStr = "bal_invprint_info.qPrintedByPaySnMuti05";
				invListTmp = (List<InvoInfoEntity>) baseDao.queryForList(sqlIdStr, inParam);
				if (invListTmp.size() > 0) {
					invList.addAll(invListTmp);
					break;
				}
			}
			yearMonTmp = Integer.parseInt(DateUtil.toStringPlusMonths("" + yearMonTmp, 1, "yyyyMM"));
		}

		/** 判断是否是小于最小冲销表年月 **/
		inParam.put("CODE_CLASS", 108);
		PubCodeDictEntity mOutTemp = (PubCodeDictEntity) baseDao.queryForObject("pub_codedef_dict.qVision", inParam);
		int billYM = ValueUtils.intValue(mOutTemp.getCodeValue());

		/** 查询完发票总表，查询冲销记录表，查询未关联缴费的发票记录 **/
		List<Map<String, Object>> writSnTmp = qryPayOut(yearMon, paySn);
		inParam = new HashMap<String, Object>();
		for (Map<String, Object> writSnEnt : writSnTmp) {
			long lWrtoffSn = ValueUtils.longValue(writSnEnt.get("WRTOFF_SN"));
			long lBalanceId = ValueUtils.longValue(writSnEnt.get("BALANCE_ID"));
			int billCycleTmp = ValueUtils.intValue(writSnEnt.get("BILL_CYCLE"));
			long contractNoTmp = ValueUtils.longValue(writSnEnt.get("CONTRACT_NO"));

			inParam.put("WRTOFF_SN", lWrtoffSn);
			inParam.put("BALANCE_ID", lBalanceId);
			inParam.put("SUFFIX", "" + billCycleTmp);
			if (printSn > 0) {
				inParam.put("PRINT_SN_CHU", printSn);
			} else {
				inParam.put("NOT_NULL", "");
			}

			List<Map<String, Object>> outParamList = (List<Map<String, Object>>) baseDao.queryForList("bal_writeoff_yyyymm.qWrtoffByWrtoSn", inParam);

			if (outParamList.size() == 0) {
				continue;
			}
			for (Map<String, Object> outParam : outParamList) {
				long printSnTmp = ValueUtils.longValue(outParam.get("PRINT_SN"));
				if (printSnSet.contains(printSnTmp)) {
					continue;
				} else {
					printSnSet.add(printSnTmp);
				}

				int billCycleXTmp = ValueUtils.intValue(outParam.get("BILL_CYCLE"));
				if (billYM > billCycleXTmp) {
					billCycleXTmp = billYM;
				}

				while (billCycleXTmp <= iCurMon) {
					inParam = new HashMap<String, Object>();

					inParam.put("YEAR_MONTH", "" + billCycleXTmp);
					inParam.put("PRINT_SN", printSnTmp);
					inParam.put("CONTRACT_NO", contractNoTmp);

					List<InvoInfoEntity> invListTmp = (List<InvoInfoEntity>) baseDao.queryForList("bal_invprint_info.qPrintedByPaySnMuti03", inParam);

					if (invListTmp.size() > 0) {
						invList.addAll(invListTmp);
					}
					billCycleXTmp = Integer.parseInt(DateUtil.toStringPlusMonths("" + billCycleXTmp, 1, "yyyyMM"));
				}
			}
		}

		return invList;
	}

	@Override
	public BalInvprintInfoEntity qryInvoiceInfo(Map<String, Object> inParam) {
		BalInvprintInfoEntity balInvprintinfo = (BalInvprintInfoEntity) baseDao.queryForObject("bal_invprint_info.qryPrintInfo", inParam);
		return balInvprintinfo;
	}

	@Override
	public List<BalInvprintInfoEntity> qryInvoiceInfoList(Map<String, Object> inParam) {
		List<BalInvprintInfoEntity> balInvprintinfo = baseDao.queryForList("bal_invprint_info.qryPrintInfo", inParam);
		return balInvprintinfo;
	}

	@Override
	public void upPrintSeq(Map<String, Object> inParam) {
		baseDao.update("bal_invprint_info.upPrintSeq", inParam);
	}

	@Override
	public String getInvRemark(Map<String, Object> inParam) {
		List<String> remarkList = baseDao.queryForList("bal_payprintinv_conf.qRemark", inParam);
		StringBuffer remark = new StringBuffer();
		remark.append("");
		for (String remarkTmp : remarkList) {
			remark.append(remarkTmp);
		}

		return remark.toString();
	}

	@Override
	public Map<String, Object> getPrintBillCycle(List<InvBillCycleEntity> billCycleList) {
		int beginBillCycle = billCycleList.get(0).getBillCycle();
		int endBillCycle = billCycleList.get(0).getBillCycle();
		for (InvBillCycleEntity invBillCycle : billCycleList) {
			if (invBillCycle.getBillCycle() > endBillCycle) {
				endBillCycle = invBillCycle.getBillCycle();
			}
			if (invBillCycle.getBillCycle() < beginBillCycle) {
				beginBillCycle = invBillCycle.getBillCycle();
			}
		}
		Map<String, Object> outMap = new HashMap<String, Object>();

		outMap.put("BEGIN_BILL_CYCLE", beginBillCycle);
		outMap.put("END_BILL_CYCLE", endBillCycle);

		return outMap;
	}

	@Override
	public Map<String, String> getAddressInfo(String regionId, String groupId, String busiGroupId) {
		Map<String, String> outMap = new HashMap<String, String>();
		Map<String, Object> inParam = new HashMap<String, Object>();
		inParam.put("PARENT_LEVEL", "2");
		inParam.put("GROUP_ID", groupId);
		// update wangxind
		ChngroupRelEntity chngroupRel = group.getRegionDistinct(groupId, "2", "230000");
		if (chngroupRel != null) {
			groupId = chngroupRel.getParentGroupId();
			if ("220001".equals(groupId))
				regionId = "aa";
			else if ("220002".equals(groupId))
				regionId = "bb";
		}

		// 获取航信服务器地址
		inParam.put("GROUP_ID", regionId);
		inParam.put("CODE_CLASS", 104);

		List<PubCodeDictEntity> pubCodeList = control.getPubCodeList(104l, "", regionId, "");

		if (pubCodeList.size() > 0) {
			outMap.put("ACCEPT", pubCodeList.get(0).getCodeName());// 航信服务器地址
			outMap.put("OPEN", pubCodeList.get(0).getCodeDesc());// 地址
			outMap.put("TAXPYAER", pubCodeList.get(0).getCodeValue() == null ? "无" : pubCodeList.get(0).getCodeValue());// 售方纳税人识别号
		} else {
			outMap.put("ACCEPT", "");
			outMap.put("OPEN", "");
			outMap.put("TAXPYAER", "");
		}

		inParam.put("CODE_CLASS", 109);
		pubCodeList = control.getPubCodeList(109l, "", regionId, "");

		if (pubCodeList.size() > 0) {
			outMap.put("ADDRESS_INFO", pubCodeList.get(0).getCodeName());// 售方地址
			outMap.put("ACCOUNT_INFO", pubCodeList.get(0).getCodeDesc());// 售方银行地址
			outMap.put("COMPANY_Name", pubCodeList.get(0).getCodeValue() == null ? "" : pubCodeList.get(0).getCodeValue());// 公司名
		} else {
			outMap.put("ADDRESS_INFO", "");
			outMap.put("ACCOUNT_INFO", "");
			outMap.put("COMPANY_Name", "");
		}

		return outMap;
	}

	@Override
	public List<LoginNoInfo> getInvLoginByGroup(String loginType, String groupId, String loginNo) {

		Map<String, Object> inParam = new HashMap<String, Object>();
		inParam.put("LOGIN_TYPE", loginType);
		inParam.put("GROUP_ID", groupId);
		inParam.put("PARENT_LEVEL", "2");
		// update wangxind
		ChngroupRelEntity chngroupRel = group.getRegionDistinct(groupId, "2", "230000");
		if (chngroupRel != null) {
			inParam.put("GROUP_ID", chngroupRel.getParentGroupId());
		}
		List<LoginNoInfo> loginList = baseDao.queryForList("BAL_INVLOGIN_DICT.qTaxLoginNo", inParam);

		// 没有数据取默认的工号
		if (loginList == null || loginList.size() == 0) {
			LoginNoInfo qryCond = new LoginNoInfo();
			LoginEntity loginEntity = login.getLoginInfo(loginNo, "230000");
			String loginName = loginEntity.getLoginName();
			qryCond.setLoginName(loginNo + "->" + loginName);
			qryCond.setLoginNo(loginNo);
			loginList.add(qryCond);
		}

		return loginList;
	}

	@Override
	public Map<String, Object> getReportMap(Map<String, Object> inParam) {
		Map<String, Object> reportMap = (Map) baseDao.queryForObject("bal_invaudit_info.qReportNo", inParam);
		return reportMap;
	}

	@Override
	public void upAuditInvoState(long orderSn, int yearMon, String state) {
		Map<String, Object> inParam = new HashMap<String, Object>();

		inParam.put("ORDER_SN", orderSn);
		inParam.put("YEAR_MONTH", yearMon);
		inParam.put("STATE", state);
		baseDao.update("bal_invaudit_info.uAuditByOrder", inParam);

	}

	@Override
	public void updateAddPrintInfo(String state, String invCode, String invNo, long printSn, String invType) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("STATE", state);
		if (StringUtils.isNotEmptyOrNull(invCode)) {
			inMap.put("INV_CODE", invCode);
		}
		if (StringUtils.isNotEmptyOrNull(invNo)) {
			inMap.put("INV_NO", invNo);
		}
		if (state == CommonConst.CANCLE_STATE && invType.equals("1")) {
			inMap.put("INV_TYPE", "2");
		}
		inMap.put("PRINT_SN", printSn);
		baseDao.update("bal_invaddtaxprint_info.updateInv", inMap);
	}

	@Override
	public int isApplyRed(long auditSn) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("AUDIT_SN_REL", auditSn);
		int cnt = (int) baseDao.queryForObject("bal_invaudit_info.qCnt", inMap);
		return cnt;
	}

	@Override
	public void insertAuditInfo(long orderSn, String loginNo, String reportNo, long auditSnNew) {
		long printSn = control.getSequence("SEQ_SYSTEM_SN");

		BalInvauditInfo balInvauditInfo = new BalInvauditInfo();
		balInvauditInfo.setAuditSn(auditSnNew);
		balInvauditInfo.setOrderSnRel(orderSn);
		balInvauditInfo.setLoginNo(loginNo);
		balInvauditInfo.setPrintSn(printSn + "");
		balInvauditInfo.setState(CommonConst.APPLY_STATE);
		// 申请时，先暂时插入1（1：表示红票 2：作废）
		balInvauditInfo.setInvType("1");
		balInvauditInfo.setReportTo(reportNo);
		balInvauditInfo.setDealNo(loginNo);
		baseDao.insert("bal_invaudit_info.insAuditInfoForRed", balInvauditInfo);

	}

	@Override
	public void insertAddinvPrint(Map<String, Object> inMap) {
		baseDao.insert("bal_invaddtaxprint_info.redinvSyntTaxInvInfo", inMap);
	}

	@Override
	public Map<String, Object> getLastPay(String opCode, long contractNo, int yearMonth) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("OP_CODE", opCode);
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("YEAR_MONTH", yearMonth);
		List<Map<String, Object>> outList = baseDao.queryForList("bal_payment_info.qLastPay", inMap);
		if (outList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8268", "00006"), "当月没有做业务！");
		}
		Map<String, Object> outMap = outList.get(0);
		// Map<String, Object> outMap = new HashMap<String, Object>();
		return outMap;
	}

	@Override
	public void insertInvAudit(BalInvauditInfo balInvAudit) {
		baseDao.insert("bal_invaudit_info.insInvAudit", balInvAudit);
	}

	@Override
	public void insertTaxPrint(TaxInvoiceFeeEntity taxInvoiceFee) {
		baseDao.insert("bal_invtaxprint_info.insTaxPrint", taxInvoiceFee);

	}

	@Override
	public List<BalInvauditInfo> getAuditInfoList(Map<String, Object> inMap) {
		List<BalInvauditInfo> auditInfoList = baseDao.queryForList("bal_invaudit_info.qryAuditInfo", inMap);
		return auditInfoList;
	}

	@Override
	public List<TaxInvoiceFeeEntity> getInvoiceFeeList(long printSn, String requestSn) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		if (printSn > 0) {
			inMap.put("PRINT_SN", printSn);
		}
		if (StringUtils.isNotEmptyOrNull(requestSn)) {
			inMap.put("REQUEST_SN", requestSn);
		}
		List<TaxInvoiceFeeEntity> taxInvoiceFee = baseDao.queryForList("bal_invtaxprint_info.qryTaxFee", inMap);
		return taxInvoiceFee;
	}

	@Override
	public List<TaxInvoiceFeeEntity> getInvoiceFeeForRedList(long printSn) {
		// Map<String, Object> inMap = new HashMap<String, Object>();
		// inMap.put("PRINT_SN", printSn);
		List<TaxInvoiceFeeEntity> taxInvoiceFee = baseDao.queryForList("bal_invtaxprint_info.qryTaxFeeForRed", printSn);
		return taxInvoiceFee;
	}

	@Override
	public void insertAuditForRed(BalInvauditInfo auditInfo) {
		baseDao.insert("bal_invaudit_info.insAuditForRed", auditInfo);
	}

	@Override
	public void updateWriteFlag(long printSn, String opTime) {

		Map<String, Object> inMap = new HashMap<String, Object>();
		// 查询账户和账期
		inMap.put("PRINT_SN", printSn);
		inMap.put("OP_TIME", opTime);
		inMap.put("PRINT_ARRAY", 1);
		List<Map<String, Object>> taxPrintList = baseDao.queryForList("bal_invprint_info.qTaxInvoiceInfo", inMap);
		log.debug("增值税发票包含的账户和账期有：" + taxPrintList);

		int curYm = DateUtils.getCurYm();
		for (Map<String, Object> taxPrintInfo : taxPrintList) {
			long contractNo = ValueUtils.longValue(taxPrintInfo.get("CONTRACT_NO"));
			int billCycle = ValueUtils.intValue(taxPrintInfo.get("BILL_CYCLE"));
			inMap = new HashMap<String, Object>();
			inMap.put("PRINT_FLAG", "0");
			inMap.put("PRINT_SN", 0);
			inMap.put("CONTRACT_NO", contractNo);
			// inMap.put("BILL_CYCLE", billCycle);
			inMap.put("PRINT_FLAG_OLD", "3");
			inMap.put("PRINT_SN_OLD", printSn);
			for (int suffix = billCycle; suffix <= curYm; suffix = DateUtils.addMonth(suffix, 1)) {
				inMap.put("SUFFIX", suffix);
				balance.upWriteOffPrintFlag(inMap);
			}
		}
	}

	@Override
	public void updateState(Map<String, Object> inMap) {
		baseDao.update("bal_invprint_info.updateState", inMap);
	}

	@Override
	public void updateAuditState(Map<String, Object> inMap) {
		baseDao.update("bal_invaudit_info.updateInvAudit", inMap);
	}

	@Override
	public String getPositionName(String state) {
		String flowPosition = "";
		if (state.equals(CommonConst.APPLY_STATE)) {
			flowPosition = "申请";
		} else if (state.equals(CommonConst.OPEN_STATE)) {
			flowPosition = "开具";
		} else if (state.equals(CommonConst.BACK_STATE)) {
			flowPosition = "打回";
		} else if (state.equals(CommonConst.AUDIT_STATE)) {
			flowPosition = "提交审核";
		} else if (state.equals(CommonConst.PASS_STATE)) {
			flowPosition = "审核通过";
		} else if (state.equals(CommonConst.NO_PASS_STATE)) {
			flowPosition = "审核不通过";
		} else if (state.equals(CommonConst.TRANS_STATE)) {
			flowPosition = "传递";
		} else if (state.equals(CommonConst.FILE_STATE)) {
			flowPosition = "归档";
		} else if (state.equals(CommonConst.WRONG_STATE)) {
			flowPosition = "数据重置";
		} else if (state.equals(CommonConst.CANCLE_STATE)) {
			flowPosition = "作废";
		}
		return flowPosition;
	}

	@Override
	public void insCollBillPrintRecd(ActCollbillprintRecd accCollBillEnt) {
		baseDao.insert("act_collbillprint_recd.insPrintRecd", accCollBillEnt);
	}

	@Override
	public boolean isPhonePay(String suffix, String fieldValue, String fieldCode, long paySn) {
		boolean isPhonePay = false;
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("SUFFIX", suffix);
		inMap.put("FIELD_VALUE", fieldValue);
		inMap.put("TRANS_CODE", fieldCode);
		inMap.put("PAY_SN", paySn);
		int cnt = (int) baseDao.queryForObject("bal_payextend_info.qCnt", inMap);
		if (cnt > 0) {
			isPhonePay = true;
		}
		return isPhonePay;
	}

	@Override
	public void upPaysn(Map<String, Object> inMap) {

		long contractNo = Long.parseLong(inMap.get("CONTRACT_NO").toString());
		long printSn = Long.parseLong(inMap.get("PRINT_SN").toString());

		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;

		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("LOGIN_ACCEPT", printSn);
		inMapTmp.put("CONTRACT_NO", contractNo);
		outMapTmp = (Map<String, Object>) baseDao.queryForObject("bal_grppreinv_info.qryGrpInv", inMapTmp);
		String ym = outMapTmp.get("OP_TIME").toString().substring(0, 6);

		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("SUFFIX", ym);
		inMapTmp.put("PRINT_SN", printSn);
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("PAY_SN", inMap.get("PAY_SN"));
		inMapTmp.put("BILL_CYCLE", inMap.get("BILL_CYCLE"));
		baseDao.update("bal_invprint_info.upPaySn", inMapTmp);
	}

	@Override
	public boolean isWechatPay(Map<String, Object> inMap) {
		return true;
	}

	@Override
	public List<TtWcityinvoice> getCityInovice(String invCode, String groupId) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		if (StringUtils.isNotEmptyOrNull(invCode)) {
			inMap.put("INVOICE_CODE", invCode);
		}
		if (StringUtils.isNotEmptyOrNull(groupId)) {
			inMap.put("REGION_CODE", groupId);
		}

		List<TtWcityinvoice> cityInvoiceList = baseDao.queryForList("tt_wcityinvoice.qCityInvoice", inMap);
		return cityInvoiceList;
	}

	@Override
	public void insCityInvoice(TtWcityinvoice cityInv) {
		baseDao.insert("tt_wcityinvoice.insCityInvoice", cityInv);
	}

	@Override
	public List<TtWdisinvoice> getDistinctInvoice(String invCode, String groupId, String disGroupId) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		if (StringUtils.isNotEmpty(invCode)) {
			inMap.put("INVOICE_CODE", invCode);
		}
		if (StringUtils.isNotEmptyOrNull(groupId)) {
			inMap.put("REGION_CODE", groupId);
		}
		if (StringUtils.isNotEmptyOrNull(disGroupId)) {
			inMap.put("DISTRICT_CODE", disGroupId);
		}
		List<TtWdisinvoice> distinctInvoiceList = baseDao.queryForList("tt_wdistinvoice.qDisInvoice", inMap);
		return distinctInvoiceList;
	}

	@Override
	public void insDisInvoice(TtWdisinvoice disInv) {
		baseDao.insert("tt_wdistinvoice.insDisInvoice", disInv);
	}

	@Override
	public List<TtWgroupinvoice> getGroupInvoice(String invCode, String regionGroup, String disGroupId, String groupId) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		if (StringUtils.isNotEmpty(invCode)) {
			inMap.put("INVOICE_CODE", invCode);
		}

		if (StringUtils.isNotEmpty(regionGroup)) {
			inMap.put("REGION_CODE", regionGroup);
		}

		if (StringUtils.isNotEmpty(disGroupId)) {
			inMap.put("DISTRICT_CODE", disGroupId);
		}

		if (StringUtils.isNotEmpty(groupId)) {
			inMap.put("GROUP_ID", groupId);
		}

		List<TtWgroupinvoice> groupInvList = baseDao.queryForList("tt_wgroupinvoice.qGroupInvoice", inMap);
		return groupInvList;
	}

	@Override
	public void insGroupInvoice(TtWgroupinvoice groupInv) {
		baseDao.insert("tt_wgroupinvoice.insGroupInvoice", groupInv);

	}

	@Override
	public Map<String, Object> getGrpPreInfo(long contractNo, long loginAccept, long paySn) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		if (contractNo > 0) {
			inMap.put("CONTRACT_NO", contractNo);
		}
		if (loginAccept > 0) {
			inMap.put("LOGIN_ACCEPT", loginAccept);
		}
		if (paySn > 0) {
			inMap.put("PAY_SN", paySn);
		}
		Map<String, Object> outMap = (Map<String, Object>) baseDao.queryForObject("bal_grppreinv_info.qryGrpInv", inMap);

		return outMap;
	}

	@Override
	public Map<String, Object> getMonthInvoice(long paySn, int yearMonth, long contractNo) {
		String invNo = "";
		String invCode = "";
		List<Map<String, Object>> invList = new ArrayList<Map<String, Object>>();
		Map<String, Object> invMap = new HashMap<String, Object>();
		// int flag = 0;// 0:未打印月结发票 1：打印月结发票 2：打印增值税发票
		int printYm = 0;
		int printTaxFlag = 0;// 如果打印过增值税发票，为1
		int printMonthFlag = 0;// 如果打印过月结发票，为1
		// 根据流水查询账本记录
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("PAY_SN", paySn);
		inMap.put("SUFFIX", yearMonth);
		inMap.put("CONTRACT_NO", contractNo);
		List<Map<String, Object>> bookSourceList = baseDao.queryForList("bal_booksource_info.qBookSourceByPaySn", inMap);
		if (bookSourceList.size() == 0) {
			return null;
		}

		// 查询冲销了那几个月的账单
		String[] printFlag = { "1", "3" };
		List<Integer> billCycleList = new ArrayList<Integer>();
		for (Map<String, Object> bookSource : bookSourceList) {
			long balanceId = ValueUtils.longValue(bookSource.get("BALANCE_ID").toString());

			Map<String, Object> inParam = new HashMap<String, Object>();
			// 根据balanceId查询支出表记录
			inParam.put("BALANCE_ID", balanceId);

			for (int ym = yearMonth; ym <= DateUtils.getCurYm(); ym = DateUtils.addMonth(ym, 1)) {
				inParam.put("SUFFIX", ym);
				List<Map<String, Object>> payoutList = baseDao.queryForList("bal_bookpayout_info.qBookPayoutByPaySn", inParam);
				for (Map<String, Object> payoutMap : payoutList) {
					long wrtSn = ValueUtils.longValue(payoutMap.get("WRTOFF_SN"));
					Map<String, Object> wrtInMap = new HashMap<String, Object>();
					wrtInMap.put("SUFFIX", ym);
					wrtInMap.put("WRTOFF_SN", wrtSn);
					// 查询打印记录，判断是不是打印了月结发票
					wrtInMap.put("PRINT_FLAG", printFlag);
					Map<String, Object> outMap = balance.getWrtoffList(wrtInMap);
					log.debug("outmap:" + outMap);
					if (ValueUtils.intValue(outMap.get("CNT")) > 0) {
						List<Map<String, Object>> wrtList = (List<Map<String, Object>>) outMap.get("WRITEOFF_LIST");
						for (Map<String, Object> wrtMap : wrtList) {
							int billCycle = ValueUtils.intValue(wrtMap.get("BILL_CYCLE"));
							if (StringUtils.isNotEmptyOrNull(wrtMap.get("PRINT_FLAG"))) {
								if (wrtMap.get("PRINT_FLAG").equals("3")) {
									log.debug("用户在" + billCycle + "开具了增值税发票");
									printTaxFlag = 1;
								} else {
									log.debug("用户在" + billCycle + "开具了月结发票");
									printMonthFlag = 1;
								}
								if (billCycleList.contains(billCycle)) {
									continue;
								} else {
									billCycleList.add(billCycle);
								}
							}

						}
					}
				}
			}
		}
		int curYm = DateUtils.getCurYm();
		// 根据账期，账户查询发票代码和发票号码
		inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("MONTH_INVOICE", "M");
		for (int billCycle : billCycleList) {
			for (int bc = billCycle; bc <= curYm; bc = DateUtils.addMonth(bc, 1)) {
				inMap.put("YEAR_MONTH", bc + "");
				inMap.put("BILL_CYCLE", billCycle);
				List<BalInvprintInfoEntity> printInfoList = getInvoInfoByInvNo(inMap);
				if (printInfoList.size() > 0) {
					if (StringUtils.isNotEmptyOrNull(printInfoList.get(0).getInvNo())) {
						invNo = printInfoList.get(0).getInvNo();
					}
					if (StringUtils.isNotEmptyOrNull(printInfoList.get(0).getInvCode())) {
						invCode = printInfoList.get(0).getInvCode();
						log.debug("invCode" + invCode);
					}
					Map<String, Object> printMap = new HashMap<String, Object>();
					printMap.put("INV_NO", invNo);
					printMap.put("INV_CODE", invCode);
					printMap.put("PRINT_FLAG", printFlag);
					printMap.put("PRINT_TIME", printInfoList.get(0).getTotalDate() / 100);
					printMap.put("INV_TYPE", printInfoList.get(0).getInvType());
					invList.add(printMap);
					break;
				}
			}
		}
		invMap.put("INV_LIST", invList);
		invMap.put("PRINT_TAX", printTaxFlag);
		invMap.put("PRINT_MONTH", printMonthFlag);
		return invMap;
	}
	
	public boolean checkIncrementBack(long contractNo,String phoneNo){
		
		// 判断账户是否打印过增值税发票
		List<Map<String,Object>> invoiceInfoList = baseDao.queryForList("dinvreturns.queryIncrementInvoice", contractNo);
		log.info("打印增值税发票时间");
		if(invoiceInfoList.size() == 0){
			log.info("没有发票");
			return true;
		}else{
			log.info("判断冲红");
			for(Map<String,Object> invoiceInfo:invoiceInfoList){
				int invoice_ym = Integer.parseInt((String)invoiceInfo.get("INVOICE_YM"));
//				String login_accept = (String)invoiceInfo.get("LOGIN_ACCEPT");
				String user_no = phoneNo;
				
				Map<String,Object> inMap = new HashMap<String,Object>();
				inMap.put("PHONE_NO", user_no);
				inMap.put("INVOICE_YM", invoice_ym);
				long num = 0;
				for(int yearMonth = invoice_ym;yearMonth<=DateUtils.getCurYm();yearMonth = DateUtils.addMonth(yearMonth, 1)){
					// 判断已打印发票是否冲红或作废
					log.info("现在日期：" + DateUtils.getCurYm() + "---账期:" + yearMonth);
					inMap.put("YEAR_MONTH", yearMonth);
					long result = (long)baseDao.queryForObject("bal_invprint_info.queryDeadInvoice", inMap);
					num = num+result;
				}
				if(num == 0){
					return false;
				}
				
			}
		}
		
		return true;
	}

	@Override
	public InvoiceXhfInfo getInvoicexhfInfo(String regionCode) {
		Map<String, Object> inMap = new HashMap<>();
		inMap.put("REGION_ID", regionCode);
		InvoiceXhfInfo xhfInfo = (InvoiceXhfInfo) baseDao.queryForObject("bal_einvoicetax_dict.qsellerInfo", inMap);
		return xhfInfo;
	}


	@Override
	public void insertTaxPre(BalTaxinvoicePre taxPre) {
		baseDao.insert("balTaxinvoicePre.insertInvoicePre", taxPre);
	}

	@Override
	public void updateTaxPreStatus(long printSn, String chnFlag) {
		Map<String, Object> inMap=new HashMap<String,Object>();
		inMap.put("PRINT_SN", printSn);
		inMap.put("CHG_FLAG", chnFlag);
		baseDao.update("balTaxinvoicePre.updateStatus", inMap);
	}

	@Override
	public List<BalTaxinvoicePre> taxInvoicePre(Map<String, Object> inMap) {
		return baseDao.queryForList("balTaxinvoicePre.qTaxInvoiceTax", inMap);
	}

	@Override
	public String isPreInv(long contractNo) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("STATUS", "p");
		inMap.put("CHG_FlAG", "1");
		List<BalTaxinvoicePre> taxInvoicePrcList = taxInvoicePre(inMap);

		if (taxInvoicePrcList.size() == 0) {
			log.debug("没有预开发票");
		}else {
			return "b";
			}

		if (record.isPreInv(contractNo, null, null)) {
			return  "a";
		}

		return null;
	}

	@Override
	public void grpPreInvCollection(Map<String ,Object> headerMap,Map<String ,Object> inMap) {
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("LOGIN_NO", inMap.get("LOGIN_NO") );
		inMapTmp.put("LOGIN_ACCEPT", inMap.get("LOGIN_ACCEPT"));
		inMapTmp.put("CONTRACT_NO", inMap.get("CONTRACT_NO"));
		inMapTmp.put("PRINT_SN", inMap.get("LOGIN_ACCEPT"));
		inMapTmp.put("OP_CODE", inMap.get("OP_CODE"));
		inMapTmp.put("HEADER", headerMap);
		bakGrpPreInv(inMapTmp);

		inMapTmp.put("STATE", "r");
		inMapTmp.put("PAY_SN_UPDATE",inMap.get("PAY_SN"));
		updateGrpPrintState(inMapTmp);

		// 更新bal_invprint_info表中的pay_sn字段
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", inMap.get("CONTRACT_NO"));
		inMapTmp.put("PRINT_SN", inMap.get("LOGIN_ACCEPT"));
		inMapTmp.put("PAY_SN", inMap.get("PAY_SN"));
		inMapTmp.put("BILL_CYCLE", inMap.get("BILL_CYCLE"));
		upPaysn(inMapTmp);
		
	}

	@Override
	public void preTaxInvCollection(Map<String ,Object> inMap) {
		
		Map<String, Object> inMapTmp=new HashMap<String,Object>();
		inMapTmp.put("STATUS", "r");
		inMapTmp.put("PAY_SN_UPDATE",inMap.get("PAY_SN"));
		inMapTmp.put("PAY_TIME", inMap.get("PAY_TIME"));
		inMapTmp.put("CONTRACT_NO", inMap.get("CONTRACT_NO"));
		inMapTmp.put("LOGIN_ACCEPT", inMap.get("LOGIN_ACCEPT"));
		uPreTaxInv(inMapTmp);
	}

	@Override
	public void preInvCollection(Map<String, Object> headerMap, Map<String, Object> inMap,String flag) {
		if("b".equals(flag)){
			preTaxInvCollection(inMap);
		}
		if("a".equals(flag)){
			grpPreInvCollection(headerMap, inMap);
		}
	}
	
	@Override
	public void uPreTaxInv(Map<String, Object> inMap) {
		baseDao.update("balTaxinvoicePre.updatePaysn", inMap);
	}
	
	@Override
	public void insertPDFInfo(EInvPdfEntity pdfEnt) {
		// Map<String, Object> inMap = new HashMap<String, Object>();
		// inMap.put("REQUEST_SN", requestSn);
		// inMap.put("PDFFILEBYTE", pdfFile.getBytes());
		// inMap.put("INVOICE_CODE", invCode);
		// inMap.put("INVOICE_NUMBER",invNo);
		// inMap.put("LOGIN_NO", loginNo);
		// inMap.put("SPLIT_ORDER", 1);
		baseDao.insert("bal_einvpdf_info.insPdfInfo", pdfEnt);
	}

	public IBalance getBalance() {
		return balance;
	}

	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public IUser getUser() {
		return user;
	}

	public void setUser(IUser user) {
		this.user = user;
	}

	public ICollection getCollection() {
		return collection;
	}

	public void setCollection(ICollection collection) {
		this.collection = collection;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

	public ILogin getLogin() {
		return login;
	}

	public void setLogin(ILogin login) {
		this.login = login;
	}

	public IPreOrder getPreOrder() {
		return preOrder;
	}

	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}



}