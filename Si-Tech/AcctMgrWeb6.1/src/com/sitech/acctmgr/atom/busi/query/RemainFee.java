package com.sitech.acctmgr.atom.busi.query;

import com.sitech.acctmgr.atom.busi.pay.inter.IWriteOffer;
import com.sitech.acctmgr.atom.busi.query.inter.IOweBill;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.balance.BalanceEntity;
import com.sitech.acctmgr.atom.domains.bill.BillEntity;
import com.sitech.acctmgr.atom.domains.bill.UnbillEntity;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.fee.OweFeeEntity;
import com.sitech.acctmgr.atom.domains.pay.PaysnBaseEntity;
import com.sitech.acctmgr.atom.domains.pay.TransFeeEntity;
import com.sitech.acctmgr.atom.domains.pub.PubWrtoffCtrlEntity;
import com.sitech.acctmgr.atom.domains.query.ClassifyPreEntity;
import com.sitech.acctmgr.atom.domains.record.ActQueryOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserDeadEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.common.utils.StringUtils;
import org.apache.commons.collections.MapUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.apache.commons.collections.MapUtils.*;

/**
 * <p>
 * Title: 余额类业务实体
 * </p>
 * <p>
 * Description: 有关余额查询类业务
 * </p>
 * <p>
 * Copyright: Copyright (c) 2014
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 *
 * @author yankma
 * @version 1.0
 */
public class RemainFee extends BaseBusi implements IRemainFee {

	private IRecord record;
	private IUser user;
	private IControl control;
	private IBalance balance;
	private IBill bill;
	private IWriteOffer writeOffer;
	private IAccount account;
	private IDelay delay;
	private IOweBill oweBill;

	@Override
	public Map<String, Object> getPayInitInfo(long contractNo) {

		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;

		// 获取我内存欠费信息，以及在线离线开关
		outMapTmp = getRealFlagAndUnbillFee(contractNo, "02");
		boolean realFlag = (boolean) outMapTmp.get("REAL_FLAG");
		UnbillEntity unbill = (UnbillEntity) outMapTmp.get("UNBILL_ENTITY");

		OutFeeData outFeeData = getConRemainFee(contractNo);
		long lSepcialFee = 0; // 划拨后专款余额
		// long lRemainFee = Long.parseLong(outMapTmp.get("REMAIN_FEE").toString());
		// long lPrepayFee = Long.parseLong(outMapTmp.get("PREPAY_FEE").toString());
		long lRemainFee = outFeeData.getRemainFee();
		long lPrepayFee = outFeeData.getPrepayFee();

		// 取当前账户上的所有未出账未冲销账单
		List<Map<String, Object>> billList = new ArrayList<Map<String, Object>>();
		List<BillEntity> unBillList = unbill.getUnBillList();
		List<BillEntity> payOweList = unbill.getPayedOweList();
		List<Long> userOweList = new ArrayList<Long>();
		for (BillEntity unbillEnt : unBillList) {
			Map<String, Object> tempMap = new HashMap<String, Object>();
			tempMap.put("ACCT_ITEM_CODE", unbillEnt.getAcctItemCode());
			tempMap.put("OWE_FEE",
					realFlag ? unbillEnt.getShouldPay() - unbillEnt.getFavourFee() - unbillEnt.getPayedPrepay() - unbillEnt.getPayedLater()
							: unbillEnt.getShouldPay() - unbillEnt.getFavourFee());
			tempMap.put("SHOULD_PAY", unbillEnt.getShouldPay());
			tempMap.put("FAVOUR_FEE", unbillEnt.getFavourFee());
			tempMap.put("PAYED_PREPAY", realFlag ? unbillEnt.getPayedPrepay() : 0);
			tempMap.put("PAYED_LATER", realFlag ? unbillEnt.getPayedLater() : 0);
			tempMap.put("DELAY_FEE", 0L);
			tempMap.put("ID_NO", unbillEnt.getIdNo());
			tempMap.put("CONTRACT_NO", contractNo);
			tempMap.put("BILL_CYCLE", unbillEnt.getBillCycle());
			billList.add(tempMap);
			if (!userOweList.contains(unbillEnt.getIdNo())) {
				userOweList.add(unbillEnt.getIdNo());
			}
		}

		log.info("userOweList = " + userOweList.toString());

		if (realFlag) {
			for (BillEntity payOweEnt : payOweList) {
				if (userOweList.contains(payOweEnt.getIdNo())) {
					Map<String, Object> tempMap = new HashMap<String, Object>();
					tempMap.put("ACCT_ITEM_CODE", payOweEnt.getAcctItemCode());
					tempMap.put("OWE_FEE",
							payOweEnt.getShouldPay() - payOweEnt.getFavourFee() - payOweEnt.getPayedPrepay() - payOweEnt.getPayedLater());
					tempMap.put("SHOULD_PAY", payOweEnt.getShouldPay());
					tempMap.put("FAVOUR_FEE", payOweEnt.getFavourFee());
					tempMap.put("PAYED_PREPAY", payOweEnt.getPayedPrepay());
					tempMap.put("PAYED_LATER", payOweEnt.getPayedLater());
					tempMap.put("DELAY_FEE", 0L);
					tempMap.put("ID_NO", payOweEnt.getIdNo());
					tempMap.put("CONTRACT_NO", contractNo);
					tempMap.put("BILL_CYCLE", payOweEnt.getBillCycle());
					billList.add(tempMap);
				}
			}
		} else {
			for (BillEntity payOweEnt : payOweList) {
				Map<String, Object> tempMap = new HashMap<String, Object>();
				tempMap.put("ACCT_ITEM_CODE", payOweEnt.getAcctItemCode());
				tempMap.put("OWE_FEE", payOweEnt.getShouldPay() - payOweEnt.getFavourFee());
				tempMap.put("SHOULD_PAY", payOweEnt.getShouldPay());
				tempMap.put("FAVOUR_FEE", payOweEnt.getFavourFee());
				tempMap.put("PAYED_PREPAY", 0);
				tempMap.put("PAYED_LATER", 0);
				tempMap.put("DELAY_FEE", 0L);
				tempMap.put("ID_NO", payOweEnt.getIdNo());
				tempMap.put("CONTRACT_NO", contractNo);
				tempMap.put("BILL_CYCLE", payOweEnt.getBillCycle());
				billList.add(tempMap);
			}
		}

		// 添加库内账单
		billList.addAll(oweBill.getOweDetailList(contractNo));

		List<OweFeeEntity> oweFeeList = new ArrayList<OweFeeEntity>();
		long delayFee = 0; // 滞纳金
		for (Map<String, Object> owefeeMap : billList) {

			String phoneNo = "";
			UserInfoEntity userEntity = user.getUserEntity(MapUtils.getLongValue(owefeeMap, "ID_NO"), null, null, false);
			if (userEntity == null) {

				List<UserDeadEntity> userDeadList = user.getUserdeadEntity(null, MapUtils.getLongValue(owefeeMap, "ID_NO"), null);
				phoneNo = userDeadList.get(0).getPhoneNo();
			} else {

				phoneNo = userEntity.getPhoneNo();
			}

			delayFee = delayFee + MapUtils.getLongValue(owefeeMap, "DELAY_FEE");

			int flag = 0;
			for (OweFeeEntity owefeeTmp : oweFeeList) {

				if (owefeeTmp.getBillCycle() == MapUtils.getLongValue(owefeeMap, "BILL_CYCLE") && phoneNo.equals(owefeeTmp.getPhoneNo())) {

					owefeeTmp.setOweFee(owefeeTmp.getOweFee() + MapUtils.getLongValue(owefeeMap, "OWE_FEE"));
					owefeeTmp.setDelayFee(owefeeTmp.getDelayFee() + MapUtils.getLongValue(owefeeMap, "DELAY_FEE"));
					owefeeTmp.setShouldPay(owefeeTmp.getShouldPay() + MapUtils.getLongValue(owefeeMap, "SHOULD_PAY"));
					owefeeTmp.setFavourFee(owefeeTmp.getFavourFee() + MapUtils.getLongValue(owefeeMap, "FAVOUR_FEE"));
					owefeeTmp.setPayedFee(owefeeTmp.getPayedFee() + MapUtils.getLongValue(owefeeMap, "PAYED_LATER")
							+ MapUtils.getLongValue(owefeeMap, "PAYED_PREPAY"));

					flag = 1;
				} else {
					continue;
				}
			}
			if (0 == flag) {

				OweFeeEntity outFee = new OweFeeEntity();
				outFee.setPhoneNo(phoneNo);
				outFee.setContractNo(MapUtils.getLongValue(owefeeMap, "CONTRACT_NO"));
				outFee.setBillCycle(MapUtils.getLongValue(owefeeMap, "BILL_CYCLE"));
				outFee.setOweFee(MapUtils.getLongValue(owefeeMap, "OWE_FEE"));
				outFee.setDelayFee(MapUtils.getLongValue(owefeeMap, "DELAY_FEE"));
				outFee.setShouldPay(MapUtils.getLongValue(owefeeMap, "SHOULD_PAY"));
				outFee.setFavourFee(MapUtils.getLongValue(owefeeMap, "FAVOUR_FEE"));
				outFee.setPayedFee(MapUtils.getLongValue(owefeeMap, "PAYED_LATER") + MapUtils.getLongValue(owefeeMap, "PAYED_PREPAY"));
				oweFeeList.add(outFee);
			}

		}

		long oweFee = 0;
		long sumShouldPay = 0;
		if (lRemainFee < 0) {
			oweFee = -1 * lRemainFee;
			sumShouldPay = -1 * lRemainFee + delayFee;
		}

		Map<String, Object> outParam = new HashMap<String, Object>();
		OutFeeData feeData = new OutFeeData();
		feeData.setDelayFee(delayFee);
		feeData.setOweFee(oweFee);
		feeData.setPrepayFee(lPrepayFee);
		feeData.setRemainFee(lRemainFee);
		feeData.setSepcialFee(lSepcialFee);
		feeData.setSumShouldPay(sumShouldPay);

		outParam.put("FEE_DATA", feeData);
		outParam.put("BILL_INFO_LIST", oweFeeList);

		return outParam;
	}

	@Override
	public OutFeeData getConRemainFee(long lContractNo) {
		return getConRemainFee(lContractNo, 1.00);
	}

	@Override
	public OutFeeData getConRemainFee(long lContractNo, double dDelayFavourRate) {

		// 默认查询的是离网的余额
		boolean isOnline = false;

		Map<String, Object> tmpMap = getRealFlagAndUnbillFee(lContractNo, "01");
		isOnline = getBooleanValue(tmpMap, "REAL_FLAG");
		UnbillEntity unbill = (UnbillEntity) tmpMap.get("UNBILL_ENTITY");

		OutFeeData outFeeData = null;
		if (isOnline) {
			outFeeData = getOnLinePrepay(lContractNo, dDelayFavourRate, unbill);
		} else {
			outFeeData = getOffLinePrepay(lContractNo, dDelayFavourRate, unbill);
		}

		return outFeeData;
	}

	/**
	 * 名称：取离线查询账户余额或账户划拨默认用户后的余额
	 *
	 * @param
	 * @return
	 * @throws
	 */
	private OutFeeData getOffLinePrepay(long lContractNo, double dDelayFavourRate, UnbillEntity unbill) {
		Map<String, Object> outMap = null;

		long remainFee = 0;
		long commonRemainFee = 0;
		long specialRemainFee = 0;
		// long lCurSpecPre = 0;
		// List<Map<String, Object>> specPreList = null;
		// List<Map<String, Object>> specRemainList = null;

		long lOweFeeAll = 0;
		long lUnbillFeeAll = 0;

		// 判断账户是否有专款账本
		// 取账户账本金额
		outMap = balance.getConMsgFee(lContractNo, false); // 取离线预存
		long specialPrepayFee = (Long) outMap.get("GPREPAY_FEE"); /* 专款 */
		long commonPrepayFee = (Long) outMap.get("PREPAY_FEE"); /* 普通预存 */
		long prepayTotal = ValueUtils.longValue(outMap.get("TOTAL_PREPAY"));
		// specPreList = (List<Map<String, Object>>) outMap.get("GPREPAY_LIST");

		// 查询欠费信息
		long unbillOwe = 0;
		long unpayOwe = 0;
		long delayFee = 0;

		// 取账户所有代付用户总内存欠费
		List<BillEntity> unbillList = unbill.getUnBillList();
		// List<BillEntity> payoweList = unbill.getPayedOweList();

		// 离线只考虑应收-优惠
		for (BillEntity billEnt : unbillList) {
			unbillOwe += (billEnt.getShouldPay() - billEnt.getFavourFee());
		}

		// 取账户所有代付用户未冲销欠费
		if (dDelayFavourRate == 1) {
			Map<String, Long> unpaySumMap = bill.getSumUnpayInfo(lContractNo, null, null);
			unpayOwe += unpaySumMap.get("OWE_FEE");

		} else {
			long delayFavour = 0;

			outMap = oweBill.getHisOweFeeInfo(lContractNo);
			unpayOwe = Long.parseLong(outMap.get("OWE_FEE").toString());
			delayFee = Long.parseLong(outMap.get("DELAY_FEE").toString());

			BigDecimal bDelayFee = new BigDecimal(delayFee);
			BigDecimal bDelayFavourRate = new BigDecimal(dDelayFavourRate);

			BigDecimal bDelayFavour = bDelayFee.multiply(bDelayFavourRate);

			delayFavour = bDelayFavour.setScale(0, BigDecimal.ROUND_HALF_UP).longValue();

			delayFee = delayFee - delayFavour;
		}

		// long lDelayFee = 0;
		if (specialPrepayFee > 0) {
			// 如果有专款走虚拟划拨（调用writeOffer.getOffLineConPre）
			// outMap = writeOffer.getOffLineConPre(lContractNo, dDelayFavourRate);
			log.debug("有专款，走虚拟划拨");
			OutFeeData outFee = writeOffer.getOffLineConPre(lContractNo, dDelayFavourRate, unbill);

			remainFee = outFee.getRemainFee();
			commonRemainFee = outFee.getCommonRemainFee();
			specialRemainFee = outFee.getSpecialRemainFee();

		} else {
			log.debug("无专款，不走虚拟划拨，直接计算");
			// 余额 = 账本金额 - 内存欠费 - 未交冲销欠费
			remainFee = prepayTotal - unbillOwe - unpayOwe;
			commonRemainFee = commonPrepayFee - unbillOwe - unpayOwe;

		}

		lOweFeeAll = unbillOwe + unpayOwe;
		lUnbillFeeAll = unbillOwe;

		OutFeeData outFee = new OutFeeData();
		outFee.setPrepayFee(prepayTotal);
		outFee.setCommonPrepayFee(commonPrepayFee);
		outFee.setSepcialFee(specialPrepayFee);
		outFee.setRemainFee(remainFee);
		outFee.setCommonRemainFee(commonRemainFee);
		outFee.setSpecialRemainFee(specialRemainFee);
		outFee.setOweFee(lOweFeeAll);
		outFee.setUnbillFee(lUnbillFeeAll);
		outFee.setDelayFee(delayFee);

		log.info("getOffLinePrepay out:" + outFee.toString());

		return outFee;
	}

	/**
	 * 名称：实时余额查询
	 *
	 * @param
	 * @return
	 * @throws
	 */
	private OutFeeData getOnLinePrepay(long lContractNo, double dDelayFavourRate, UnbillEntity unbill) {
		Map<String, Object> outMap = null;

		// 调用计费接口，取账户余额（普通余额和专款余额）及欠费信息
		long prepayFeeTotal = 0;
		long lGPrepayFee = 0;
		long lPrepayFee = 0;
		long lUnbillOwe = 0;
		List<Map<String, Object>> specPreList = new ArrayList<Map<String, Object>>();

		lGPrepayFee = unbill.getGprepayFee();// 专款预存
		lPrepayFee = unbill.getPrepayFee();// 普通预存
		prepayFeeTotal = lGPrepayFee + lPrepayFee;// 总预存

		lUnbillOwe = unbill.getUnBillFee();// 库内欠费
//		List<SpecBalaceEntity> specList = unbill.getSpecialActBookList();// 查询专款类型列表
		List<BalanceEntity> specList = unbill.getSpecialActBookList();// 查询专款类型列表

		// 取账户未冲销欠费
		long lUnPayOwe = 0;
		long lDelayFee = 0;
		if (dDelayFavourRate == 1.00) {
			// 查询账户往月的欠费信息
			Map<String, Long> unpaySumMap = bill.getSumUnpayInfo(lContractNo, null, null);
			lUnPayOwe = getLong(unpaySumMap, "OWE_FEE");
		} else {
			long lDelayFavour = 0;

			// 查询账户的往月欠费信息，包含欠费金额和滞纳金金额
			outMap = oweBill.getHisOweFeeInfo(lContractNo);

			lUnPayOwe = Long.parseLong(outMap.get("OWE_FEE").toString());
			lDelayFee = Long.parseLong(outMap.get("DELAY_FEE").toString());

			BigDecimal bDelayFee = new BigDecimal(lDelayFee);
			BigDecimal bDelayFavourRate = new BigDecimal(dDelayFavourRate);

			BigDecimal bDelayFavour = bDelayFee.multiply(bDelayFavourRate);

			lDelayFavour = bDelayFavour.setScale(0, BigDecimal.ROUND_HALF_UP).longValue();

			lDelayFee = lDelayFee - lDelayFavour;
		}

		long lOweFeeTotal = 0;
		// 总的欠费=库内欠费+往月欠费+滞纳金
		lOweFeeTotal = lUnbillOwe + lUnPayOwe + lDelayFee;

		long lPerpayFeeTotal = 0;
		long lGPrepayFeeTotal = 0;

		lPerpayFeeTotal = lPrepayFee;
		lGPrepayFeeTotal = lGPrepayFee;

		long lRemainFee = 0; /* 余额 */
		long lCurSpecPre = 0; /* 划拨后专款余额 */
		List<Map<String, Object>> specRemainList = new ArrayList<Map<String, Object>>(); /* 划拨后专款列表 */
		long lOweFeeAll = 0; /* 帐户下的往月欠费和内存欠费 */
		long lUnbillFeeAll = 0; /* 帐户下的未出帐话费总和 */
		if (lPerpayFeeTotal > 0 && lOweFeeTotal > 0) {
			if (lGPrepayFeeTotal > 0) { // 如果有专款做在线账务虚拟划拨(在线暂时不考虑专款，这块暂时没用)

				// 有专款金额做虚拟划拨
				outMap = writeOffer.getOnLineConPre(lContractNo, dDelayFavourRate, unbill.getAcctBookList(), unbill.getUnBillList()); // 现在这样传入的UnBillList有问题，这里需要传入账单明细，但是外面传进来的有可能只是综合账单，因为在线暂时不考虑专款，这块待解决

				lRemainFee = (Long) outMap.get("CUR_PERPAY");
				if (lRemainFee == 0) {
					lRemainFee = (-1) * (Long) outMap.get("OWE_FEE");
				}
				lCurSpecPre = (Long) outMap.get("CUR_SEPC_PERPAY");
				specRemainList = (List<Map<String, Object>>) outMap.get("SPECIAL_LIST");

				lOweFeeAll = (Long) outMap.get("OWE_FEE_ALL");
				lUnbillFeeAll = (Long) outMap.get("UNBILL_FEE_ALL");
			} else { // 如果没有, 余额 = 预存 - 欠费
				lRemainFee = lPerpayFeeTotal - lOweFeeTotal;
				lOweFeeAll = lOweFeeTotal;
				lUnbillFeeAll = lUnbillOwe;
			}
		} else {
			lRemainFee = prepayFeeTotal - lOweFeeTotal;
			lCurSpecPre = lGPrepayFeeTotal;
			lOweFeeAll = lOweFeeTotal;
			lUnbillFeeAll = lUnbillOwe;
		}

//		for (SpecBalaceEntity spec : specList) {
		for (BalanceEntity spec : specList) {
			Map<String, Object> temp = new HashMap<String, Object>();
			temp.put("CUR_BALANCE", spec.getCurBalance());
			temp.put("INIT_BALANCE", spec.getInitBalance());
			temp.put("PAY_TYPE", spec.getPayType());
			temp.put("SPECIAL_FLAG", spec.getSpecialFlag());
			specPreList.add(temp);
		}

		// 返回账户余额和欠费信息
		OutFeeData outFee = new OutFeeData();
		outFee.setPrepayFee(prepayFeeTotal);
		outFee.setSepcialFee(lCurSpecPre);
		outFee.setRemainFee(lRemainFee);
		outFee.setCommonRemainFee(lPrepayFee);
		outFee.setSpecialRemainFee(lGPrepayFee);
		outFee.setOweFee(lOweFeeAll);
		outFee.setUnbillFee(lUnbillFeeAll);
		outFee.setDelayFee(lDelayFee);
		// TODO 专款列表

		/* Map<String, Object> outParam = new HashMap<String, Object>(); outParam.put("PREPAY_FEE", lPerpayFeeTotal); //预存 outParam.put("SPEC_PRE_LIST", specPreList); //专款预存列表 outParam.put("REMAIN_FEE", lRemainFee);// 划拨后的余额 outParam.put("SPEC_REMAIN_LIST", specRemainList); //划拨后专款列表
		 * 
		 * outParam.put("OWE_FEE", lOweFeeAll);// 帐户下的往月欠费和内存欠费 outParam.put("UNBILL_FEE", lUnbillFeeAll);// 帐户下的未出帐话费总和 */

		return outFee;
	}

	/***
	 * 获取在线、离线开关，且返回帐处未出帐话费结果 (除取配置外，还需比较内存库账本跟物理库是否一致，如果不一致则走离线)
	 *
	 * @param contractNo
	 * @param sQryType
	 *            : 01:综合账单 02：明细账单
	 * @return REAL_FLAG : boolean true: 在线 false：离线 <br/>
	 *         UNBILL_ENTITY : UnbillEntity 内存话费实体
	 */
	private Map<String, Object> getRealFlagAndUnbillFee(long contractNo, String sQryType) {

		// 调用接口获取未出帐话费
		UnbillEntity unbill = null;
		if (sQryType.equals("01")) { /*综合帐单 + 预存列表*/
			unbill = bill.getUnbillFee(contractNo, 0, CommonConst.UNBILL_TYPE_BILL_TOT_PRE);
		} else if (sQryType.equals("02")) { /*明细帐单 + 预存列表*/
			unbill = bill.getUnbillFee(contractNo, 0, CommonConst.UNBILL_TYPE_BILL_DET_PRE);
		}

		long lBalanceTotal = unbill.getBalanceTotal(); //同步给内存库的预存总金额

		// 取物理库账本
		long sumBookbalance = balance.getAcctBookSum(contractNo, null);

		boolean realFlag = false;
		if (sumBookbalance != lBalanceTotal) { // 物理库冲销积压，查询离线余额
			if (control.isOnLineBill(contractNo)) {
				ActQueryOprEntity actQryOprEntity = new ActQueryOprEntity();
				actQryOprEntity.setBrandId("");
				actQryOprEntity.setIdNo(contractNo);
				actQryOprEntity.setLoginGroup("341011");
				actQryOprEntity.setLoginNo("system");
				actQryOprEntity.setOpCode("0000");
				actQryOprEntity.setPhoneNo(String.valueOf(contractNo));
				actQryOprEntity.setQueryType("ONTOF");
				actQryOprEntity.setRemark("在线查离线记录,PHONE_NO和ID_NO记录账户号码");

				record.saveQueryOpr(actQryOprEntity, false);

				log.error("Because the acctbooks synchronization backlog, offine balance. contract_no = " + contractNo);
			}
			realFlag = false;
		} else {
			realFlag = control.isOnLineBill(contractNo);
		}

		Map<String, Object> outParam = new HashMap<String, Object>();
		outParam.put("REAL_FLAG", realFlag);
		outParam.put("UNBILL_ENTITY", unbill == null ? new UnbillEntity() : unbill);

		return outParam;
	}

	@Override
	public List<TransFeeEntity> getBookList(Map<String, Object> inParam) {
		List<TransFeeEntity> outBookList = new ArrayList<TransFeeEntity>();
		Map<String, Object> inMap = new HashMap<String, Object>();

		long contractNo = Long.parseLong(inParam.get("CONTRACT_NO").toString());

		// pay_type合并金额列表
		List<Map<String, Object>> transList = new ArrayList<Map<String, Object>>();
		// 可转账本列表
		List<Map<String, Object>> infoList = new ArrayList<Map<String, Object>>();

		// 获取可转账本明细列表
		inMap.put("CONTRACT_NO", contractNo);
		if (inParam.get("PAY_TYPE") != null && !inParam.get("PAY_TYPE").equals("")) {
			inMap.put("PAY_TYPE", inParam.get("PAY_TYPE").toString());
		}
		if (inParam.get("BACK_FLAG") != null && !inParam.get("BACK_FLAG").equals("")) {
			inMap.put("BACK_FLAG", inParam.get("BACK_FLAG").toString());
		}
		if (inParam.get("TRANS_FLAG") != null && !inParam.get("TRANS_FLAG").equals("")) {
			inMap.put("TRANS_FLAG", inParam.get("TRANS_FLAG").toString());
		}
		if (inParam.get("PAY_TYPE_STR") != null && !inParam.get("PAY_TYPE_STR").equals("")) {
			inMap.put("PAY_TYPE_STR", inParam.get("PAY_TYPE_STR").toString()); // payTypeStr为逗号‘,’隔开的字符串，例如:'3','d','0'
		}
		infoList = balance.getAcctBookList(inMap);
		for (Map<String, Object> trans : infoList) {
			String payType = getString(trans, "PAY_TYPE");
			long curBalance = getLongValue(trans, "CUR_BALANCE");
			long preBalance = getLongValue(trans, "PRE_BALANCE");

			// 同一pay_type累加金额
			int cycleFlag = 0;
			for (Map<String, Object> cycleMap : transList) {
				long curHas = getLongValue(cycleMap, "CUR_BALANCE");
				long preHas = getLongValue(cycleMap, "PRE_BALANCE");

				if (getString(cycleMap, "PAY_TYPE").equals(payType)) {
					cycleMap.put("CUR_BALANCE", curHas + curBalance);
					cycleMap.put("PRE_BALANCE", preHas + preBalance);
					cycleFlag = 1;
				} else {
					continue;
				}
			}

			Map<String, Object> sumMap = new HashMap<String, Object>();
			safeAddToMap(sumMap, "PAY_TYPE", payType);
			safeAddToMap(sumMap, "CUR_BALANCE", curBalance);
			safeAddToMap(sumMap, "PRE_BALANCE", preBalance);
			log.info("-------> mapPre=" + sumMap.entrySet());
			if (cycleFlag == 0) {
				transList.add(sumMap);
			}
		}

		for (Map<String, Object> trans : transList) {
			String payType = getString(trans, "PAY_TYPE");
			long curBalance = getLongValue(trans, "CUR_BALANCE");

			Map<String, Object> inType = new HashMap<String, Object>();
			safeAddToMap(inType, "PAY_TYPE", payType);
			Map<String, Object> outType = balance.getBookTypeDict(inType);
			String payTypeName = outType.get("PAY_TYPE_NAME").toString().trim();
			String priority = outType.get("PRIORITY").toString();
			String payAttr = outType.get("PAY_ATTR").toString();
			String backFlag = (payAttr.substring(1, 2).equals("0") ? "可退" : "不可退");
			String transFlag = (payAttr.substring(3, 4).equals("0") ? "可转" : "不可转");

			TransFeeEntity transFeeEntity = new TransFeeEntity();
			transFeeEntity.setPayAttr(payAttr);
			transFeeEntity.setPayType(payType);
			transFeeEntity.setPayTypeName(payTypeName);
			transFeeEntity.setPriority(priority);
			transFeeEntity.setCurBalance(curBalance);
			transFeeEntity.setTransFlag(transFlag);
			transFeeEntity.setBackFlag(backFlag);
			outBookList.add(transFeeEntity);
		}
		log.info("------> outBookList=" + outBookList.toString());
		return outBookList;
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.busi.pay.inter.IAcctBook#doTransFeeOffList(java.util.Map) */
	@SuppressWarnings("unchecked")
	@Override
	public List<TransFeeEntity> getBookListDead(Map<String, Object> inParam) {
		Map<String, Object> inMapTmp = null;
		List<TransFeeEntity> outBookList = new ArrayList<TransFeeEntity>();
		long contractNo = Long.parseLong(inParam.get("CONTRACT_NO").toString());

		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		if (inParam.get("PAY_TYPE") != null && !inParam.get("PAY_TYPE").equals("")) {
			inMapTmp.put("PAY_TYPE", inParam.get("PAY_TYPE").toString());
		}
		if (inParam.get("BACK_FLAG") != null && !inParam.get("BACK_FLAG").equals("")) {
			inMapTmp.put("BACK_FLAG", inParam.get("BACK_FLAG").toString());
		}
		if (inParam.get("TRANS_FLAG") != null && !inParam.get("TRANS_FLAG").equals("")) {
			inMapTmp.put("TRANS_FLAG", inParam.get("TRANS_FLAG").toString());
		}
		List<Map<String, Object>> outMapList = balance.getDeadBookList(inMapTmp);

		// 离网账本列表按照pay_type合并
		List<Map<String, Object>> transTypeList = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> outMap : outMapList) {
			String payType = getString(outMap, "PAY_TYPE");
			long curBalance = getLongValue(outMap, "CUR_BALANCE");
			long preBalance = getLongValue(outMap, "PRE_BALANCE");

			int cycleFlag = 0;
			for (Map<String, Object> cycleMap : transTypeList) {
				long cycleCur = getLongValue(cycleMap, "CUR_BALANCE");
				if (getString(cycleMap, "PAY_TYPE").equals(payType)) {
					cycleMap.put("CUR_BALANCE", cycleCur + curBalance);
					cycleFlag = 1;
				} else {
					continue;
				}
			}

			Map<String, Object> sumOffNetMap = new HashMap<String, Object>();
			safeAddToMap(sumOffNetMap, "PAY_TYPE", payType);
			safeAddToMap(sumOffNetMap, "CUR_BALANCE", curBalance);
			safeAddToMap(sumOffNetMap, "PRE_BALANCE", preBalance);
			log.info("-------> mapPre=" + sumOffNetMap.entrySet());

			if (0 == cycleFlag) {
				transTypeList.add(sumOffNetMap);
			}
		}

		for (Map<String, Object> bookMap : transTypeList) {
			String payType = getString(bookMap, "PAY_TYPE");
			long curBalance = getLongValue(bookMap, "CUR_BALANCE");

			Map<String, Object> inType = new HashMap<String, Object>();
			safeAddToMap(inType, "PAY_TYPE", payType);
			Map<String, Object> outType = balance.getBookTypeDict(inType);
			String payTypeName = outType.get("PAY_TYPE_NAME").toString().trim();
			String priority = outType.get("PRIORITY").toString();
			String payAttr = outType.get("PAY_ATTR").toString();
			String backFlag = (payAttr.substring(1, 2).equals("0") ? "可退" : "不可退");
			String transFlag = (payAttr.substring(3, 4).equals("0") ? "可转" : "不可转");

			TransFeeEntity transFeeEntity = new TransFeeEntity();
			transFeeEntity.setPayAttr(payAttr);
			transFeeEntity.setPayType(payType);
			transFeeEntity.setPayTypeName(payTypeName);
			transFeeEntity.setPriority(priority);
			transFeeEntity.setCurBalance(curBalance);
			transFeeEntity.setTransFlag(transFlag);
			transFeeEntity.setBackFlag(backFlag);

			outBookList.add(transFeeEntity);
		}

		return outBookList;
	}

	public List<PaysnBaseEntity> getPayMentForBack(Map<String, Object> inParam) {

		Map<String, Object> inMapTmp = null;/* 临时变量:入参 */
		List<PaysnBaseEntity> outParam = new ArrayList<PaysnBaseEntity>();
		String opType = (String) inParam.get("OP_TYPE");
		String[] opCodes = (String[]) inParam.get("OP_CODES");

		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", inParam.get("CONTRACT_NO"));
		inMapTmp.put("SUFFIX", inParam.get("SUFFIX"));
		inMapTmp.put("OP_CODES", opCodes);
		// inMapTmp.put("OP_CODES", "8000");
		if (StringUtils.isNotEmptyOrNull(inParam.get("BEGIN_TIME"))) {
			inMapTmp.put("BEGIN_TIME", inParam.get("BEGIN_TIME"));
		}
		if (StringUtils.isNotEmptyOrNull(inParam.get("END_TIME"))) {
			inMapTmp.put("END_TIME", inParam.get("END_TIME"));
		}
		if (opType.equals("JFCZ")) {
			inMapTmp.put("PAY_PATH", inParam.get("PAY_PATH"));
		}
		List<PaysnBaseEntity> resultList = (List<PaysnBaseEntity>) baseDao.queryForList("bal_payment_info.qPaysnInfo", inMapTmp);

		if (opType.equals("KZCZCZ") || opType.equals("JTCPZZCZ")) { // 如果空中充值冲正或者转账冲正，则将payment表中转出、转入数据合并为一条,列出代理商号码和充值号码
			for (PaysnBaseEntity payTmp : resultList) {

				// 查找另一条记录
				inMapTmp = new HashMap<String, Object>();
				inMapTmp.put("SUFFIX", inParam.get("SUFFIX"));
				inMapTmp.put("OP_CODES", opCodes);
				inMapTmp.put("PAY_SN", payTmp.getPaySn());
				inMapTmp.put("NOT_CON", inParam.get("CONTRACT_NO"));
				PaysnBaseEntity payTmp2 = (PaysnBaseEntity) baseDao.queryForObject("bal_payment_info.qPaysnInfo", inMapTmp);

				if (payTmp.getPayFee() < 0) { // 为负，则为转出用户--代理商
					payTmp.setAgentPhone(payTmp.getPhone());
					payTmp.setPhoneNo(payTmp2.getPhone());
				} else {
					payTmp.setAgentPhone(payTmp2.getPhone());
					payTmp.setPhoneNo(payTmp.getPhone());
				}

				outParam.add(payTmp);
			}
		} else {
			outParam = resultList;
		}

		return outParam;
	}

	public OutFeeData getDeadConRemainFee(long idNo, long contractNo, double delayFavourRate) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		Map<String, Object> outMap = null;

		long remainFee = 0;
		long oweFee = 0;

		// 取账户账本金额
		inMap.put("CONTRACT_NO", contractNo);
		long prepayFee = balance.getAcctBookDeadSum(inMap); // 获取账户预存

		long delayFee = 0;
		long unBillOwe = 0;
		long unPayOweDead = 0;
		// 获取用户欠费信息
		if (delayFavourRate == 1.00) {
			BillEntity billEnt = bill.getSumDeadFee(idNo, 0, "1,4");
			unPayOweDead = billEnt.getOweFee();
		} else {
			long delayFavour = 0;

			outMap = oweBill.getDeadOweFeeInfo(idNo, contractNo);
			unPayOweDead = Long.parseLong(outMap.get("OWE_FEE").toString());
			delayFee = Long.parseLong(outMap.get("DELAY_FEE").toString());

			// 优惠滞纳金计算
			BigDecimal bDelayFee = new BigDecimal(delayFee);
			BigDecimal bDelayFavourRate = new BigDecimal(delayFavourRate);

			BigDecimal bDelayFavour = bDelayFee.multiply(bDelayFavourRate);

			delayFavour = bDelayFavour.setScale(0, BigDecimal.ROUND_HALF_UP).longValue();

			delayFee = delayFee - delayFavour;
		}

		// 余额 = 账本金额 - 内存欠费 - 未交冲销欠费 -滞纳金
		remainFee = prepayFee - unBillOwe - unPayOweDead - delayFee;
		oweFee = unBillOwe + unPayOweDead + delayFee;

		OutFeeData outFee = new OutFeeData();
		outFee.setPrepayFee(prepayFee);
		outFee.setSepcialFee(0);
		outFee.setRemainFee(remainFee);
		outFee.setOweFee(oweFee);
		outFee.setUnbillFee(unBillOwe);
		outFee.setDelayFee(delayFee);

		log.info("getDeadConRemainFee out:" + outFee.toString());

		return outFee;
	}

	@Override
	public List<ClassifyPreEntity> getClassifyPreInfo(Long contractNo) {
		List<ClassifyPreEntity> resultList = new ArrayList<ClassifyPreEntity>();
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		
		List<Map<String,Object>> payTypeList = baseDao.queryForList("bal_acctbook_info.qryPayType", inMap);
		if(payTypeList.size()>0) {
			for(Map<String,Object> tempMap:payTypeList) {				
				String payType = "";
				long curBalance = 0;
				long prepayFee = 0;
				String beginDate = "";
				String endDate = "";
				String payName = "";
				String transFlag = "";
				long orderCode = 0;
				String leftMonth = "null";
				String returnDay  = "null";
				String saleFlag = "无限制";
				
				payType = tempMap.get("PAY_TYPE").toString();
				//取可划拨预存				
				curBalance = balance.getAcctBookSum( contractNo, payType);
				
				//判断是否是普通账本
				inMap = new HashMap<String,Object>();
				inMap.put("PAY_TYPE", payType);
				Map<String, Object> result = (Map<String, Object>) baseDao.queryForObject("bal_booktype_dict.qBookTypeDictByType", inMap);
				String payAttr = result.get("PAY_ATTR").toString().substring(5,6);
				
				if(payAttr.equals("0")){	//普通账本				
					prepayFee = curBalance;
					
					inMap = new HashMap<String,Object>();
					inMap.put("CONTRACT_NO", contractNo);
					inMap.put("PAY_TYPE", payType);
					ClassifyPreEntity cpe = (ClassifyPreEntity)baseDao.queryForObject("bal_acctbook_info.qryCommonTypeInfo", inMap);				
					beginDate = cpe.getBeginDate();
					endDate = cpe.getEndDate();
					payName = cpe.getPayName();
					transFlag = cpe.getTransFlag();
					orderCode = cpe.getOrderCode();
					leftMonth = "null";
					returnDay  = "null";
					saleFlag = "null";
				}else {	
					prepayFee = 0;
					inMap.put("CONTRACT_NO", contractNo);
					inMap.put("PAY_TYPE", payType);
					List<ClassifyPreEntity> willValidList = (List<ClassifyPreEntity>) baseDao.queryForList("bal_acctbook_info.qClassifyPre", inMap);
					if(willValidList.size()>0) {
						leftMonth = String.valueOf(willValidList.size());
						beginDate = willValidList.get(0).getBeginDate();
						saleFlag = willValidList.get(0).getSaleFlag();
						for (ClassifyPreEntity cpeWill : willValidList) {
								prepayFee = prepayFee + cpeWill.getPrepayFee();
								endDate = cpeWill.getBeginDate();
								payName = cpeWill.getPayName();
								transFlag = cpeWill.getTransFlag();
								orderCode = cpeWill.getOrderCode();
						}
						if(saleFlag.equals("6")){
							saleFlag = "无限制";
						}else {
							saleFlag = "未拆包";
						}
					}
					
					prepayFee = prepayFee+curBalance;
					returnDay = "1";				
					
				}
				
				ClassifyPreEntity resultEntity = new ClassifyPreEntity();
				resultEntity.setBeginDate(beginDate);
				resultEntity.setEndDate(endDate);
				resultEntity.setLeftMonths(leftMonth);
				resultEntity.setOrderCode(orderCode);
				resultEntity.setPayName(payName);
				resultEntity.setPayType(payType);
				resultEntity.setPrepayFee(prepayFee);
				resultEntity.setReturnDay(returnDay);
				resultEntity.setSaleFlag(saleFlag);
				resultEntity.setTransFee(curBalance);
				resultEntity.setTransFlag(transFlag);
				resultList.add(resultEntity);
			}
			 
		}
		return resultList;
	}
	
	@Override
	public List<BalanceEntity> getEffList(long contractNo){
		Map<String,Object> inMap = new HashMap<String, Object>();
		List<BalanceEntity> balanceEntList = new ArrayList<>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("STATUS", "1");
		List<Map<String, Object>> retBalList = balance.getRetAcctBookForRestPay(inMap);
		if(retBalList.size()>0){
			for(Map<String, Object> retBal : retBalList) {
				String sBeginTime = retBal.get("BEGIN_TIME").toString();
				String sEndTime = retBal.get("END_TIME").toString();
				BalanceEntity effBalance = new BalanceEntity();
				effBalance.setBeginTime(sBeginTime.substring(0, 4) + "-" + sBeginTime.substring(4, 6) + "-" + sBeginTime.substring(6));
				effBalance.setEndTime(sEndTime.substring(0, 4) + "-" + sEndTime.substring(4, 6) + "-" + sEndTime.substring(6));
				effBalance.setPayType(retBal.get("PAY_TYPE").toString());
				effBalance.setPayTypeName(retBal.get("PAY_TYPE_NAME").toString());
				effBalance.setSpecialFlag(retBal.get("PAY_ATTR").toString().substring(0, 1));
				effBalance.setSpecialFlagName(retBal.get("PAY_ATTR").toString().substring(0, 1).equals("0") ? "专项预存款" : "普通预存款");
//				effBalance.setBackFlag(retBal.get("PAY_ATTR").toString().substring(1, 2));
//				effBalance.setBackFlagName(retBal.get("PAY_ATTR").toString().substring(1, 2).equals("0") ? "可退" : "不可退");
				effBalance.setCurBalance(Long.parseLong(retBal.get("CUR_BALANCE").toString()));
				effBalance.setContractNo(contractNo);
				effBalance.setRemark("有条件返费");
				balanceEntList.add(effBalance);
			}	
		}

		return balanceEntList;
	}

	/**
	 * @return the oweBill
	 */
	public IOweBill getOweBill() {
		return oweBill;
	}

	/**
	 * @param oweBill
	 *            the oweBill to set
	 */
	public void setOweBill(IOweBill oweBill) {
		this.oweBill = oweBill;
	}

	/**
	 * @return the record
	 */
	public IRecord getRecord() {
		return record;
	}

	/**
	 * @param record
	 *            the record to set
	 */
	public void setRecord(IRecord record) {
		this.record = record;
	}

	/**
	 * @return the user
	 */
	public IUser getUser() {
		return user;
	}

	/**
	 * @param user
	 *            the user to set
	 */
	public void setUser(IUser user) {
		this.user = user;
	}

	/**
	 * @return the control
	 */
	public IControl getControl() {
		return control;
	}

	/**
	 * @param control
	 *            the control to set
	 */
	public void setControl(IControl control) {
		this.control = control;
	}

	/**
	 * @return the balance
	 */
	public IBalance getBalance() {
		return balance;
	}

	/**
	 * @param balance
	 *            the balance to set
	 */
	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	/**
	 * @return the bill
	 */
	public IBill getBill() {
		return bill;
	}

	/**
	 * @param bill
	 *            the bill to set
	 */
	public void setBill(IBill bill) {
		this.bill = bill;
	}

	/**
	 * @return the writeOffer
	 */
	public IWriteOffer getWriteOffer() {
		return writeOffer;
	}

	/**
	 * @param writeOffer
	 *            the writeOffer to set
	 */
	public void setWriteOffer(IWriteOffer writeOffer) {
		this.writeOffer = writeOffer;
	}

	/**
	 * @return the account
	 */
	public IAccount getAccount() {
		return account;
	}

	/**
	 * @param account
	 *            the account to set
	 */
	public void setAccount(IAccount account) {
		this.account = account;
	}

	/**
	 * @return the delay
	 */
	public IDelay getDelay() {
		return delay;
	}

	/**
	 * @param delay
	 *            the delay to set
	 */
	public void setDelay(IDelay delay) {
		this.delay = delay;
	}

}
