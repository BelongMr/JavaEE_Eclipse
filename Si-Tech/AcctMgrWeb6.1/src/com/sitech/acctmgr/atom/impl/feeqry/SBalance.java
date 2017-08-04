package com.sitech.acctmgr.atom.impl.feeqry;

import static org.apache.commons.collections.MapUtils.getLongValue;
import static org.apache.commons.collections.MapUtils.getString;
import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSON;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.balance.BatchPayEntity;
import com.sitech.acctmgr.atom.domains.balance.PrepayEntity;
import com.sitech.acctmgr.atom.domains.balance.RestPayEntity;
import com.sitech.acctmgr.atom.domains.balance.RestUnPayEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.bill.UnbillEntity;
import com.sitech.acctmgr.atom.domains.deposit.DepositInfoEntity;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.domains.query.ModeBackEntity;
import com.sitech.acctmgr.atom.domains.record.ActQueryOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserBrandEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserPrcEntity;
import com.sitech.acctmgr.atom.domains.user.UserRelEntity;
import com.sitech.acctmgr.atom.dto.feeqry.SBalanceQryBackFeeInDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SBalanceQryBackFeeJLInDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SBalanceQryBackFeeJLOutDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SBalanceQryBackFeeOutDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SBalanceQryRestPayInDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SBalanceQryRestPayOutDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SBalanceQueryInDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SBalanceQueryOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.IBillAccount;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICredit;
import com.sitech.acctmgr.atom.entity.inter.IDeposit;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IProd;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgr.inter.feeqry.IBalance;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
 * Created by wangyla on 2016/6/2.
 */

@ParamTypes({
		@ParamType(m = "query", c = SBalanceQueryInDTO.class, oc = SBalanceQueryOutDTO.class, routeKey = "10", routeValue = "phone_no", busiComId = "构件id", srvCat = "查询", srvCnName = "余额查询接口", srvVer = "V10.8.126.0", srvDesc = "余额查询统一接口", srcAttr = "核心", srvLocal = "否", srvGroup = "否"),
		@ParamType(m = "queryBackFee", c = SBalanceQryBackFeeInDTO.class, oc = SBalanceQryBackFeeOutDTO.class),
		@ParamType(m = "qryBackFee", c = SBalanceQryBackFeeJLInDTO.class, oc = SBalanceQryBackFeeJLOutDTO.class),
		@ParamType(m = "qryRestPay", c = SBalanceQryRestPayInDTO.class, oc = SBalanceQryRestPayOutDTO.class) })
public class SBalance extends AcctMgrBaseService implements IBalance {

	private IUser user;
	private IAccount account;
	private IBill bill;
	private IGroup group;
	private ICredit credit;
	private IRecord record;
	private ILogin login;
	private IRemainFee remainFee;
	private IDeposit deposit;
	private com.sitech.acctmgr.atom.entity.inter.IBalance balance;

	private IBillAccount billAccount;
	private IControl control;
	private IProd prod;

	@Override
	public OutDTO query(final InDTO inDTO) {
		SBalanceQueryInDTO inparam = (SBalanceQueryInDTO) inDTO;
		log.debug("inDto=" + inparam.getMbean());
		SBalanceQueryOutDTO outDto = new SBalanceQueryOutDTO();
		String phoneNo = inparam.getPhoneNo();
		long idNo = inparam.getIdNo();
		long contractNo = inparam.getContractNo();
		int qryType = inparam.getQryType();

		Map<String, Object> baseInfoMap = this.getBaseInfo(phoneNo, idNo, contractNo, inparam.getProvinceId());
		log.debug("查询的基本信息为：" + baseInfoMap + (baseInfoMap.size() == 0));
		if (baseInfoMap.size() > 0) {
			phoneNo = getString(baseInfoMap, "PHONE_NO");
			idNo = Long.parseLong(baseInfoMap.get("ID_NO").toString());
			if (contractNo == 0) {
				contractNo = getLongValue(baseInfoMap, "CONTRACT_NO");
			}

			outDto.setBrandName(getString(baseInfoMap, "BRAND_NAME"));
			outDto.setOpenTime(getString(baseInfoMap, "OPEN_TIME"));
			outDto.setRegionCode(getString(baseInfoMap, "REGION_CODE"));
			outDto.setRunCode(getString(baseInfoMap, "RUN_CODE"));
			outDto.setRunName(getString(baseInfoMap, "RUN_NAME"));
			outDto.setRunTime(getString(baseInfoMap, "RUN_TIME"));

		}

		/* balance info */
		// TODO 后续补充根据qryType来判断余额类型的用户余额的取法
		OutFeeData outFee = remainFee.getConRemainFee(contractNo);

		/* deposit info */
		Map<String, Long> depositMap = null;
		if (qryType == 0 || qryType == 2) {
			depositMap = this.getDepositFees(phoneNo, null);
		} else {
			depositMap = this.getDepositFees(null, contractNo);
		}

		/* save the query record log */
		if (StringUtils.isNotEmpty(inparam.getLoginNo()) && StringUtils.isNotEmpty(inparam.getOpCode())) {
			long idValue = idNo > 0 ? idNo : contractNo;
			this.saveQueryOprLog(phoneNo, idValue, qryType, inparam.getLoginNo(), inparam.getGroupId(), inparam.getOpCode(), outFee.getRemainFee(),
					inparam.getProvinceId());
		}

		// 取预存信息 (失效预存,将要生效预存,生效预存,总预存)
		PrepayEntity peAll = balance.getAllPrepay(contractNo);

		// 取生效预存
		PrepayEntity peValid = balance.getValidSum(contractNo);

		outDto.setContractNo(contractNo);
		outDto.setPrepayFee(outFee.getPrepayFee());/* 账户预存 */
		outDto.setCurBalance(outFee.getRemainFee());/* 预存余额 */
		outDto.setUnBillFeeAll(outFee.getUnbillFee());/* 未出帐话费 */
		outDto.setDelayFee(outFee.getDelayFee());// 滞纳金
		outDto.setCommonRemainFee(outFee.getCommonRemainFee());
		outDto.setSpecialRemainFee(outFee.getSpecialRemainFee());
		outDto.setOweFeeAll(outFee.getOweFee());
		outDto.setBackDeposit(depositMap.get("DEPOSIT_BACKABLE"));

		outDto.setAvailableAll(peValid.getAvailableAll());
		outDto.setAvailableCommon(peValid.getAvailableCommon());
		outDto.setAvailableSpecial(peValid.getAvailableSpecial());
		outDto.setEffPrepayAll(peAll.getEffPrepayAll());
		outDto.setExpPrepayAll(peAll.getExpPrepayAll());
		outDto.setPrepayAll(peAll.getPrepayAll());
		outDto.setWillPrepayAll(peAll.getWillPrepayAll());

		log.debug("outDto=" + outDto.toJson());
		return outDto;
	}

	private Map<String, Object> getBaseInfo(String phoneNo, Long idNo, Long contractNo, String provinceId) {
		if (StringUtils.isEmpty(phoneNo) && (idNo == null || idNo <= 0) && (contractNo == null || contractNo <= 0)) {
			log.error("查询在网用户基础信息，服务号码、用户ID以及帐户号码不能同时为空");
			// TODO 错误编码需要重新获取
			throw new BusiException(AcctMgrError.getErrorCode("0000", "00000"), "查询在网用户基础信息，服务号码、用户ID以及帐户号码不能同时为空");
		}
		UserInfoEntity userEntity = new UserInfoEntity();
		if (contractNo > 0) {
			userEntity = user.getUserEntity(idNo, phoneNo, contractNo, false);
		} else {
			userEntity = user.getUserEntity(idNo, phoneNo, contractNo, true);
		}
		Map<String, Object> outMap = new HashMap<String, Object>();
		if (userEntity != null) {
			log.debug("查询到用户信息");
			phoneNo = userEntity.getPhoneNo();

			UserInfoEntity userInfo = user.getUserInfo(phoneNo);

			/* 获取用户地市归属信息 */
			ChngroupRelEntity userGroupInfo = group.getRegionDistinct(userInfo.getGroupId(), "2", provinceId);

			safeAddToMap(outMap, "BRAND_NAME", userInfo.getBrandName());
			safeAddToMap(outMap, "OPEN_TIME", userInfo.getOpenTime());
			safeAddToMap(outMap, "RUN_TIME", userInfo.getRunTime());
			safeAddToMap(outMap, "DEFAULT_CONTRACT", userInfo.getContractNo());
			safeAddToMap(outMap, "RUN_CODE", userInfo.getRunCode());
			safeAddToMap(outMap, "RUN_NAME", userInfo.getRunName());
			safeAddToMap(outMap, "REGION_CODE", userGroupInfo.getRegionCode());
			safeAddToMap(outMap, "ID_NO", userInfo.getIdNo());
			safeAddToMap(outMap, "CONTRACT_NO", userInfo.getContractNo());
			safeAddToMap(outMap, "PHONE_NO", phoneNo);

		}

		return outMap;
	}

	private void saveQueryOprLog(String phoneNo, long idNo, int queryType, String loginNo, String loginGroupId, String opCode, long curBalance,
			String proviceId) {
		ActQueryOprEntity oprEntity = new ActQueryOprEntity();
		if (StringUtils.isNotEmpty(loginNo) && StringUtils.isEmpty(loginGroupId)) {
			LoginEntity loginInfo = login.getLoginInfo(loginNo, proviceId);
			loginGroupId = loginInfo.getGroupId();
		}
		oprEntity.setQueryType(String.format("%d", queryType));
		oprEntity.setOpCode(opCode);
		oprEntity.setContactId("");
		oprEntity.setIdNo(idNo);
		oprEntity.setPhoneNo(phoneNo);
		oprEntity.setBrandId("");
		oprEntity.setLoginNo(loginNo);
		oprEntity.setLoginGroup(loginGroupId);
		oprEntity.setProvinceId(proviceId);
		StringBuilder buffer = new StringBuilder();
		buffer.append("余额查询, 余额[ ").append(curBalance).append(" ] 分");
		oprEntity.setRemark(buffer.toString());
		record.saveQueryOpr(oprEntity, false);
	}

	private Map<String, Long> getDepositFees(String phoneNo, Long contractNo) {

		List<DepositInfoEntity> depositList = deposit.getDepositInfo(phoneNo, contractNo, null);
		long depositBackable = 0L;
		long depositInBackable = 0L;
		for (DepositInfoEntity depositInfo : depositList) {
			if (depositInfo.getBackType().equals("0")) {
				depositBackable += depositInfo.getCurDeposit();
			} else {
				depositInBackable += depositInfo.getCurDeposit();
			}
		}

		Map<String, Long> outMap = new HashMap<>();
		safeAddToMap(outMap, "DEPOSIT_BACKABLE", depositBackable);
		safeAddToMap(outMap, "DEPOSIT_INBACKABLE", depositInBackable);

		return outMap;
	}

	@Override
	public OutDTO queryBackFee(InDTO inDto) {
		SBalanceQryBackFeeInDTO inParam = (SBalanceQryBackFeeInDTO) inDto;
		String phoneNo = "";
		long contractNo = 0;
		long idNo = 0;
		if (StringUtils.isNotEmpty(inParam.getPhoneNo())) {
			phoneNo = inParam.getPhoneNo();
		}

		if (inParam.getContractNo() > 0) {
			contractNo = inParam.getContractNo();
		}
		// 获取用户信息
		UserInfoEntity userInfo = user.getUserEntity(idNo, phoneNo, contractNo, true);
		idNo = userInfo.getIdNo();
		contractNo = userInfo.getContractNo();
		phoneNo = userInfo.getPhoneNo();
		
		// 流量伴侣卡 增加副卡未出帐查询，如果有未出帐话费则不允许办理
		UserRelEntity ure = user.getMateId(0, idNo);
		if(ure!=null) {
			long mainId = ure.getMasterId();
			UserInfoEntity uieMain = user.getUserEntityByIdNo(mainId, true);
			String mainPhoneNo =uieMain.getPhoneNo();
			long contractMain = uieMain.getContractNo();
			UnbillEntity ube = bill.getUnbillFee(contractMain, idNo, CommonConst.UNBILL_TYPE_BILL_TOT_PRE);
			long secUnibill = ube.getUnBillFee();
			if(secUnibill>0) {
				throw new BusiException(AcctMgrError.getErrorCode("8436", "00002"), "存在未出帐话费不允许办理！");
			}
		}

		int queryTime = inParam.getQueryTime();
		OutFeeData feeData = remainFee.getConRemainFee(contractNo);
		// long oweFee = feeDate.getOweFee() + feeDate.getDelayFee() + feeDate.getUnbillFee();
		// long prepayFee = feeDate.getPrepayFee();
		long unbillFee = feeData.getUnbillFee();
		long backBalance = 0;
		long backFee = 0;
		//
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("BACK_FLAG", "0");// pay_attr 第2位- 0可退1不可退
		inMap.put("QUERY_TIME", queryTime);
		List<Map<String, Object>> backfeeList = balance.getAcctBookList(inMap);
		for (Map<String, Object> specMap : backfeeList) {
			backBalance += Long.parseLong(specMap.get("CUR_BALANCE").toString());
		}

		if (backBalance > feeData.getCommonRemainFee()) {
			if (feeData.getCommonRemainFee() > 0) {
				backFee = feeData.getRemainFee();
			}
		} else {
			backFee = backBalance;
		}
		long noBackFee = 0;
		if (feeData.getRemainFee() > 0) {
			noBackFee = feeData.getRemainFee() - backFee;
		}

		// 判断用户的品牌,品牌为宽带的，可退预存款和不可退预存款的取值不同
		// int kdFlag = 0;
		// int yearFlag = 0;// 是否为包年账户
		// int effYm = 0;
		UserBrandEntity brandInfo = user.getUserBrandRel(userInfo.getIdNo());
		String brandId = brandInfo.getBrandId();
		if (brandId.equals("2330kh") || brandId.equals("2330ke") || brandId.equals("2330kf") || brandId.equals("2330kd") || brandId.equals("2330ki")
				|| brandId.equals("2330kg")) {
			if (brandId.equals("2330kh")||billAccount.judgeRollMonthBill(idNo) > 0) {
				backFee = backFee + noBackFee;
				noBackFee = 0;
			}
			Map<String, Long> outFee = broadFee(contractNo, idNo, brandId, unbillFee, queryTime);
			backFee += unbillFee + outFee.get("PREPAY");
			noBackFee -= outFee.get("PREPAY") + unbillFee;
		}
		SBalanceQryBackFeeOutDTO outDto = new SBalanceQryBackFeeOutDTO();

		outDto.setRefundMoney(backFee);
		outDto.setNoRefundMoney(noBackFee);
		return outDto;
	}

	private Map<String, Long> broadFee(long contractNo, long idNo, String brandId, long unbillFee, int queryTime) {
		long curMonthFee = 0;
		long dedit = 0;// 违约金
		int offerType = 0;// 0:包月 1：包年
		long prepay = 0;
		UserPrcEntity userPrc = prod.getUserPrcidInfo(idNo);
		if (!userPrc.getPrcType().equals("0")) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "01001"), "取用户主资费错误！");
		}
		if (userPrc.getPrcClass().equals("YnKD10") || userPrc.getPrcClass().equals("YnKI10")) {
			// 包月用户，查询月租费
			curMonthFee = ValueUtils.longValue(prod.getPrcAttrValue(userPrc.getProdPrcid(), "23M018"));
		} else {
			if (!userPrc.getPrcClass().equals("YnKB10")) {
				throw new BusiException(AcctMgrError.getErrorCode("0000", "01000"), "取用户当前月租费用失败");
			}

			int month = ValueUtils.intValue(prod.getPrcAttrValue(userPrc.getProdPrcid(), "23M007"));
			long totalFee = ValueUtils.longValue(prod.getPrcAttrValue(userPrc.getProdPrcid(), "23M006"));
			int monthTmp = 0;
			if (month == 13) {
				monthTmp = 12;
			} else {
				monthTmp = month;
			}
			curMonthFee = new BigDecimal(totalFee / monthTmp).setScale(0, BigDecimal.ROUND_HALF_UP).longValue();
			int effDate = ValueUtils.intValue(userPrc.getEffDate().substring(0, 8));
			if (effDate > 0) {
				// 如果为13个月的并且当前日期正好属于第十三个月，那么这个月补收月租费
				if (month == 13 && DateUtils.addMonth(effDate, 12) == DateUtils.getCurYm()) {
					curMonthFee = 0;
				}
			}

			offerType = 1;

		}

		// 判断用户是否收取固定费
		String[] detailType = { "1", "9", "c", "d", "h" };
		String detailCode = "M00G";
		int cnt = billAccount.haveFix(idNo, detailType, detailCode);
		if (cnt == 0) {
			log.debug("用户" + idNo + "在固定费收取之外");
			curMonthFee = 0;
		}
		// 获取账户的未出账话费
		// long unbillFee = feeData.getUnbillFee();
		// 获取当月天数
		int days = DateUtils.getLastDayOfMonth(DateUtils.getCurYm());
		// 判断是否为kh品牌和滚动月
		if (brandId.equals("2330kh") || billAccount.judgeRollMonthBill(idNo) > 0) {
			int accDay = billAccount.qryAccDay(idNo);
			// 不足半月，按半月收
			int curDay = DateUtils.getCurDay() % 10000;
			if ((accDay > curDay && accDay - curDay > 15) || (accDay < curDay && accDay - curDay < 15)) {
				curMonthFee = curMonthFee / 2;
				if (unbillFee > curMonthFee) {
					curMonthFee = unbillFee;
				}
			}
		}
		if (offerType == 0) {
			// 包月用户按日分摊
			log.debug("当月收取的月租费：" + curMonthFee);
			long dayFee = new BigDecimal(curMonthFee / days).setScale(0, BigDecimal.ROUND_HALF_UP).longValue();
			// 由于在内存库中的账单已经包含了今天以前的费用，所以当月的月租费就是内存欠费+一天的费用
			curMonthFee = dayFee + unbillFee;
		}

		log.debug("月租为：" + curMonthFee);
		// 包年预存的要收取30%的违约金begin
		// 查询包年预约的账本
		long codeClass = 1109;
		List<PubCodeDictEntity> pubCodeList = control.getPubCodeList(codeClass, "", "", "");
		List<String> payTypeList = new ArrayList<String>();
		for (PubCodeDictEntity pubCode : pubCodeList) {
			payTypeList.add(pubCode.getCodeId());
		}
		List<Map<String, Object>> bookInfoList = balance.getBookPrePayByPayType(contractNo);
		if (bookInfoList.size() > 0) {
			for (int i = 0; i < bookInfoList.size(); i++) {
				log.debug((!payTypeList.contains(bookInfoList.get(i).get("ACCTBOOK_ITEM").toString())) + "是否");
				if (!payTypeList.contains(bookInfoList.get(i).get("ACCTBOOK_ITEM").toString())) {
					continue;
				}
				int beginTime = ValueUtils.intValue(bookInfoList.get(i).get("BEGIN_DATE"));
				long prepayFee = ValueUtils.longValue(bookInfoList.get(i).get("BALANCE"));
				if (offerType == 1 && beginTime != queryTime) {
					if (curMonthFee > 0) {
						prepayFee = prepayFee - curMonthFee;
						if (curMonthFee > prepayFee) {
							curMonthFee = curMonthFee - prepayFee;
						}
						// if (brandId.equals("2330kh")) {
						// noBackFee = curMonthFee;
						// } else {
						// noBackFee += curMonthFee;
						// }
					}
				}
				log.debug("prepayFee:" + prepayFee);
				// 查询是否收取违约金
				int penaltyFlag = 0;
				penaltyFlag = balance.hasDedit(idNo, contractNo, bookInfoList.get(i).get("ACCTBOOK_ITEM").toString());
				if (penaltyFlag > 0 && prepayFee > 0) {
					// 收取30%违约金
					dedit += new BigDecimal(prepayFee * .3).setScale(0, BigDecimal.ROUND_HALF_UP).longValue();
					prepay += new BigDecimal(prepayFee * .7).setScale(0, BigDecimal.ROUND_HALF_UP).longValue();
				} else {
					prepay = prepay + prepayFee;
				}

			}
		}
		log.debug("可退的包年账本类型的金额为：" + prepay);
		Map<String, Long> outMap = new HashMap<String, Long>();
		outMap.put("PREPAY", prepay);
		return outMap;
	}

	// 该部分上线的时候请勿上线
	// add by liuhl_bj
	@Override
	public OutDTO qryBackFee(InDTO inParam) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		Map<String, Object> outMap = null;

		int iQueryType = 0;
		String sPhoneNo = "";
		long lContractNo = 0;
		int iFlag = 0;

		// 入参DTO
		SBalanceQryBackFeeJLInDTO in = (SBalanceQryBackFeeJLInDTO) inParam;
		iQueryType = in.getQueryType();
		sPhoneNo = in.getPhoneNo();
		lContractNo = in.getContractNo();
		iFlag = in.getFlag();

		log.info("qryBackFee 开始 入参报文:[" + in.getMbean() + "]");

		// 取可退及不可退预存
		if (iQueryType == 0) {
			// 取用户默认账户信息
			inMap.put("PHONE_NO", sPhoneNo);
			// outMap = user.getUserMap(inMap);
			UserInfoEntity userInfo = user.getUserEntityByPhoneNo(sPhoneNo, true);
			lContractNo = userInfo.getContractNo();
		}

		// 取可退预存和不可退预存
		long lBackPrepay = 0;
		long lNoBackPrepay = 0;
		List<Map<String, Object>> balanceList = new ArrayList<Map<String, Object>>();
		OutFeeData feeDate = remainFee.getConRemainFee(lContractNo);
		long oweFee = feeDate.getOweFee() + feeDate.getDelayFee() + feeDate.getUnbillFee();
		long prepayFee = feeDate.getPrepayFee();
		long backBalance = 0;

		inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", lContractNo);
		inMap.put("BACK_FLAG", "0");// pay_attr 第2位- 0可退1不可退
		// inMap.put("QUERY_TIME", queryTime);
		List<Map<String, Object>> backfeeList = balance.getAcctBookList(inMap);
		for (Map<String, Object> specMap : backfeeList) {
			backBalance += Long.parseLong(specMap.get("CUR_BALANCE").toString());
		}

		// 计算最终可退预存
		long returnMoney = 0;
		if (backBalance > prepayFee - oweFee) {
			if (prepayFee - oweFee > 0) {
				returnMoney = prepayFee - oweFee;
			}
		} else {
			returnMoney = backBalance;
		}
		long noReturnMoney = 0;
		/* 以下是吉林的版本的，为了调通程序，暂时由上边的来实现<br> outMap = writeOffer.getConPre1(lContractNo, 0); lBackPrepay = Long.parseLong(outMap.get("BACK_PERPAY").toString()); lNoBackPrepay = Long.parseLong(outMap.get("NO_BACK_PERPAY").toString()); balanceList = (List<Map<String, Object>>) outMap.get("BALANCE_INFO_LIST");
		 * 
		 * // 从账本列表里获取不可退预存，按照PAY_TYPE分组 List<NotBackBalanceEntity> noBackBalList = new ArrayList<NotBackBalanceEntity>(); int cnt = 0; for (Map<String, Object> balMap : balanceList) { String sBackFlag = balMap.get("BACK_FLAG").toString();
		 * 
		 * if (sBackFlag.equals("0")) { continue; }
		 * 
		 * String sPayType = balMap.get("PAY_TYPE").toString(); long lCurBal = Long.parseLong(balMap.get("CUR_BALANCE").toString());
		 * 
		 * if (cnt == 0) { // 取账本类型名称 String sPayName = ""; inMap = new HashMap<String, Object>(); inMap.put("PAY_TYPE", sPayType); outMap = balance.getBookTypeDict(inMap); sPayName = (String) outMap.get("PAY_TYPE_NAME");
		 * 
		 * NotBackBalanceEntity backBal = new NotBackBalanceEntity(); backBal.setPayType(sPayType); backBal.setPayTypeName(sPayName); backBal.setBalance(lCurBal); noBackBalList.add(backBal);
		 * 
		 * cnt++;
		 * 
		 * continue; }
		 * 
		 * int flag = 0; for (NotBackBalanceEntity noBackBal : noBackBalList) { if (noBackBal.getPayType().equals(sPayType)) { long lbalTmp = noBackBal.getBalance() + lCurBal;
		 * 
		 * noBackBal.setBalance(lbalTmp);
		 * 
		 * flag++;
		 * 
		 * break; } }
		 * 
		 * if (flag == 0) { // 取账本类型名称 String sPayName = ""; inMap = new HashMap<String, Object>(); inMap.put("PAY_TYPE", sPayType); outMap = balance.getBookTypeDict(inMap); sPayName = (String) outMap.get("PAY_TYPE_NAME");
		 * 
		 * NotBackBalanceEntity backBal = new NotBackBalanceEntity(); backBal.setPayType(sPayType); backBal.setPayTypeName(sPayName); backBal.setBalance(lCurBal); noBackBalList.add(backBal); }
		 * 
		 * } */

		// 取可退押金和不可退押金
		long lBackDeposit = 0;
		long lNoBackDeposit = 0;
		inMap = new HashMap<String, Object>();
		if (iQueryType == 0) {
			inMap.put("PHONE_NO", sPhoneNo);
		} else {
			inMap.put("CONTRACT_NO", lContractNo);
		}
		Map<String, Long> outMap1 = new HashMap<String, Long>();
		outMap1 = getDepositFees(sPhoneNo, lContractNo);
		lBackDeposit = Long.parseLong(outMap1.get("DEPOSIT_BACKABLE").toString());
		lNoBackDeposit = Long.parseLong(outMap1.get("DEPOSIT_INBACKABLE").toString());

		long lModeBackTotalFee = 0;
		List<ModeBackEntity> modeList = new ArrayList<ModeBackEntity>();
		if (iFlag == 1 && iQueryType == 0) {
			// //吉林查询可退套餐费,可退套餐按照时间计算这里不准确，舍弃by zhanggzz
			// modeList = getModeBackFee(sPhoneNo);
			// for(ModeBackEntity modeBack : modeList) {
			// lModeBackTotalFee += modeBack.getModeBackFee();
			// }
			lModeBackTotalFee = 0;
		}

		long lBackFee = 0;
		lBackFee = lBackPrepay + lBackDeposit + lModeBackTotalFee;

		SBalanceQryBackFeeJLOutDTO out = new SBalanceQryBackFeeJLOutDTO();
		out.setBackFee(lBackFee);
		out.setBackPrepay(returnMoney);
		out.setNoBackPrepay(noReturnMoney);
		out.setBackDeposit(lBackDeposit);
		out.setNoBackDeposit(lNoBackDeposit);
		// out.setNoBackBalList(noBackBalList);
		out.setModeBackTotalFee(lModeBackTotalFee);
		out.setModeBackFeeList(modeList);

		return out;
	}

	@Override
	public OutDTO qryRestPay(InDTO inParam) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		Map<String, Object> outMap = null;

		String sPhoneNo = "";
		long lContractNo = 0;
		String sForeignSn = "";
		String sForeignTime = "";

		SBalanceQryRestPayInDTO in = (SBalanceQryRestPayInDTO) inParam;

		sPhoneNo = in.getPhoneNo();
		lContractNo = in.getContractNo();
		sForeignSn = in.getForeignSn();
		sForeignTime = in.getForeignTime();

		if (lContractNo == 0) {
			UserInfoEntity uie = user.getUserInfo(sPhoneNo);
			lContractNo = uie.getContractNo();
		}

		List<Map<String, Object>> restPayList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> batchPayList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> restUnPayList = new ArrayList<Map<String, Object>>();
		long lPrepayFee = 0;
		long lOrdPrepay = 0;
		long lPrePrepay = 0;
		long lPreUnpayFee = 0;
		long lOrdUnPrepay = 0;
		long lPreUnPrepay = 0;
		long lValidedPay = 0;
		long lOrdValided = 0;
		long lPreValided = 0;
		// 查询未返费金额
		outMap = balance.getUnRestPay(lContractNo, sForeignSn);
		restPayList = (List<Map<String, Object>>) outMap.get("RESTPAY_LIST");
		lPrepayFee = Long.parseLong(outMap.get("PREPAY_FEE").toString());
		lOrdPrepay = Long.parseLong(outMap.get("ORD_PREPAY").toString());
		lPrePrepay = Long.parseLong(outMap.get("PRE_PREPAY").toString());

		// 查询已返费金额
		outMap = balance.getBatchPayInfo(lContractNo, sForeignSn, sForeignTime);
		batchPayList = (List<Map<String, Object>>) outMap.get("BATCHPAY_LIST");
		lValidedPay = Long.parseLong(outMap.get("VALIDED_PAY").toString());
		lOrdValided = Long.parseLong(outMap.get("ORD_VALIDED").toString());
		lPreValided = Long.parseLong(outMap.get("PRE_VALIDED").toString());

		// 查询不满足条件未返还金额RestUnPayEntity
		outMap = balance.getNoUnRestPay(lContractNo, sForeignSn);
		restUnPayList = (List<Map<String, Object>>) outMap.get("RESTUNPAY_LIST");
		lPreUnpayFee = Long.parseLong(outMap.get("PREUNPAY_FEE").toString());
		lOrdUnPrepay = Long.parseLong(outMap.get("ORD_PRUNEPAY").toString());
		lPreUnPrepay = Long.parseLong(outMap.get("PRE_PRUNEPAY").toString());

		List<RestPayEntity> restPayInfo = new ArrayList<RestPayEntity>();
		for (Map<String, Object> restPayMap : restPayList) {
			String jsonStr = JSON.toJSONString(restPayMap);
			restPayInfo.add(JSON.parseObject(jsonStr, RestPayEntity.class));
		}

		List<BatchPayEntity> batchPayInfo = new ArrayList<BatchPayEntity>();
		for (Map<String, Object> batchPayMap : batchPayList) {
			String jsonStr = JSON.toJSONString(batchPayMap);
			batchPayInfo.add(JSON.parseObject(jsonStr, BatchPayEntity.class));
		}

		List<RestUnPayEntity> restUnPayInfo = new ArrayList<RestUnPayEntity>();
		for (Map<String, Object> restUnPayMap : restUnPayList) {
			String jsonStr = JSON.toJSONString(restUnPayMap);
			restUnPayInfo.add(JSON.parseObject(jsonStr, RestUnPayEntity.class));
		}

		SBalanceQryRestPayOutDTO out = new SBalanceQryRestPayOutDTO();
		out.setRestPayList(restPayInfo);
		out.setPrepayFee(lPrepayFee);
		out.setOrdPrepay(lOrdPrepay);
		out.setPrePrepay(lPrePrepay);
		out.setBatchPayList(batchPayInfo);
		out.setValidedPay(lValidedPay);
		out.setOrdValided(lOrdValided);
		out.setPreValided(lPreValided);
		out.setRestUnPayList(restUnPayInfo);
		out.setPreUnpayFee(lPreUnpayFee);
		out.setOrdUnPrepay(lOrdUnPrepay);
		out.setPreUnPrepay(lPreUnPrepay);

		return out;
	}

	public IUser getUser() {
		return user;
	}

	public void setUser(IUser user) {
		this.user = user;
	}

	public IAccount getAccount() {
		return account;
	}

	public void setAccount(IAccount account) {
		this.account = account;
	}

	public IBill getBill() {
		return bill;
	}

	public void setBill(IBill bill) {
		this.bill = bill;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

	public ICredit getCredit() {
		return credit;
	}

	public void setCredit(ICredit credit) {
		this.credit = credit;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}

	public ILogin getLogin() {
		return login;
	}

	public void setLogin(ILogin login) {
		this.login = login;
	}

	public IRemainFee getRemainFee() {
		return remainFee;
	}

	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}

	public IDeposit getDeposit() {
		return deposit;
	}

	public void setDeposit(IDeposit deposit) {
		this.deposit = deposit;
	}

	public com.sitech.acctmgr.atom.entity.inter.IBalance getBalance() {
		return balance;
	}

	public void setBalance(com.sitech.acctmgr.atom.entity.inter.IBalance balance) {
		this.balance = balance;
	}

	public IBillAccount getBillAccount() {
		return billAccount;
	}

	public void setBillAccount(IBillAccount billAccount) {
		this.billAccount = billAccount;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public IProd getProd() {
		return prod;
	}

	public void setProd(IProd prod) {
		this.prod = prod;
	}

}
