package com.sitech.acctmgr.atom.impl.invoice;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import com.alibaba.fastjson.JSON;
import com.sitech.acctmgr.atom.busi.invoice.inter.IInvFee;
import com.sitech.acctmgr.atom.busi.invoice.inter.IPreInvHeader;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.balance.TransFeeEntity;
import com.sitech.acctmgr.atom.domains.cust.TaxPayerInfo;
import com.sitech.acctmgr.atom.domains.invoice.BalInvauditInfo;
import com.sitech.acctmgr.atom.domains.invoice.BalInvprintInfoEntity;
import com.sitech.acctmgr.atom.domains.invoice.BalTaxinvoicePre;
import com.sitech.acctmgr.atom.domains.invoice.LoginNoInfo;
import com.sitech.acctmgr.atom.domains.invoice.TaxAcctInfo;
import com.sitech.acctmgr.atom.domains.invoice.TaxInvoiceFeeEntity;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserBrandEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.invoice.S8248BOSSCfmInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248BOSSCfmOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248DataResetInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248DataResetOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248FlowOverCfmInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248FlowOverCfmOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QryAcctNoInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QryAcctNoOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QryInvoInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QryInvoOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QryInvoiceFeeInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QryInvoiceFeeOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QryInvoiceFlowInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QryInvoiceFlowOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QryLoginNoInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QryLoginNoOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QryOnePayInvoInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QryOnePayInvoOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QueryRedReasonInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248QueryRedReasonOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248RedInvoiceReqInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8248RedInvoiceReqOutDTO;
import com.sitech.acctmgr.atom.entity.Invoice;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IInvoice;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgr.inter.invoice.I8248TaxInvoAo;
import com.sitech.acctmgrint.atom.busi.intface.IBusiMsgSnd;
import com.sitech.acctmgrint.atom.busi.intface.IShortMessage;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.service.client.ServiceUtil;

@ParamTypes({ @ParamType(c = S8248QryAcctNoInDTO.class, m = "qryAcctNo", oc = S8248QryAcctNoOutDTO.class),
		@ParamType(c = S8248QueryRedReasonInDTO.class, m = "queryRedReason", oc = S8248QueryRedReasonOutDTO.class),
		@ParamType(c = S8248RedInvoiceReqInDTO.class, m = "redInvoiceReq", oc = S8248RedInvoiceReqOutDTO.class),
		@ParamType(c = S8248QryInvoInDTO.class, m = "qryInvo", oc = S8248QryInvoOutDTO.class),
		@ParamType(c = S8248QryOnePayInvoInDTO.class, m = "qryInvNoForOnePay", oc = S8248QryOnePayInvoOutDTO.class),
		@ParamType(c = S8248QryLoginNoInDTO.class, m = "qryLoginNo", oc = S8248QryLoginNoOutDTO.class),
		@ParamType(c = S8248BOSSCfmInDTO.class, m = "cfmBOSS", oc = S8248BOSSCfmOutDTO.class),
		@ParamType(c = S8248FlowOverCfmInDTO.class, m = "flowOverCfm", oc = S8248FlowOverCfmOutDTO.class),
		@ParamType(c = S8248QryInvoiceFlowInDTO.class, m = "invoiceFlowInfo", oc = S8248QryInvoiceFeeOutDTO.class),
		@ParamType(c = S8248QryInvoiceFeeInDTO.class, m = "invoiceFeeInfo", oc = S8248QryInvoiceFeeOutDTO.class),
		@ParamType(c = S8248DataResetInDTO.class, m = "dataReset", oc = S8248DataResetOutDTO.class),

})
public class S8248TaxInvo extends AcctMgrBaseService implements I8248TaxInvoAo {

	private IPreInvHeader preInvHeader;
	private IInvFee invFee;
	private IInvoice invoice;
	private IControl control;
	private IAccount account;
	private IUser user;
	private IGroup group;
	private ICust cust;
	private IBalance balance;
	private IRecord record;
	private IShortMessage shortMessage;

	private IBusiMsgSnd busiMsgSend;

	@Override
	public OutDTO qryAcctNo(InDTO inParam) {
		S8248QryAcctNoInDTO inDto = (S8248QryAcctNoInDTO) inParam;

		List<TaxAcctInfo> acctInfo = new ArrayList<TaxAcctInfo>();
		String phoneNo = "";
		String taxPayerId = "";
		int qryType = inDto.getQryType();
		long custId = 0;

		if (qryType == 0) {
			phoneNo = inDto.getPhoneNo();
			// 查询用户信息
			UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
			custId = userInfo.getCustId();

		}
		if (qryType == 1) {
			taxPayerId = inDto.getTaxPayerId();
		}
		TaxPayerInfo taxPayerInfo = cust.getTaxPayerInfo(custId, taxPayerId);
		if (taxPayerInfo == null) {
			throw new BusiException(AcctMgrError.getErrorCode("8248", "00019"), "不具有纳税人资质");
		}
		List<ContractInfoEntity> conList = account.getContractInfo(taxPayerInfo.getCustId());
		for (ContractInfoEntity con : conList) {
			TaxAcctInfo taxAcctInfo = new TaxAcctInfo();
			UserInfoEntity userInfoTmp = user.getUserEntityByConNo(con.getContractNo(), false);
			taxAcctInfo.setAddress(taxPayerInfo.getAddress());
			taxAcctInfo.setBankAccount(taxPayerInfo.getBankAccount());
			taxAcctInfo.setBankName(taxPayerInfo.getBankName());
			taxAcctInfo.setContractName(control.pubEncryptData(con.getContractName(), 1));
			taxAcctInfo.setContractNo(con.getContractNo());
			taxAcctInfo.setTaxPayerId(taxPayerInfo.getTaxpayerId());
			taxAcctInfo.setUnitName(taxPayerInfo.getUnitName());
			taxAcctInfo.setUnitId(0);
			taxAcctInfo.setPhoneNo(taxPayerInfo.getPhoneNo());
			taxAcctInfo.setCustId(taxPayerInfo.getCustId());
			if (StringUtils.isNotEmptyOrNull(userInfoTmp)) {
				taxAcctInfo.setConPhoneNo(userInfoTmp.getPhoneNo());
			}
			acctInfo.add(taxAcctInfo);
		}

		S8248QryAcctNoOutDTO outDto = new S8248QryAcctNoOutDTO();
		outDto.setAcctInfo(acctInfo);
		return outDto;
	}

	@Override
	public OutDTO qryInvo(InDTO inParam) {
		S8248QryInvoInDTO inDto = (S8248QryInvoInDTO) inParam;
		int flag = inDto.getFlag();
		int beginYm = inDto.getBeginMon();
		int endYm = inDto.getEndMon();
		// 为多账户，以“,”分割
		String contractNo = inDto.getContractNo();
		String[] contractArray = contractNo.split(",");
		List<TransFeeEntity> transFeeList = new ArrayList<>();
		// 查询是否打印过发票
		int curYM = DateUtils.getCurYm();
		for (String contract : contractArray) {
			for (int billCycle = beginYm; billCycle <= endYm; billCycle = DateUtils.addMonth(billCycle, 1)) {
				for (int suffix = billCycle; suffix <= curYM; suffix = DateUtils.addMonth(suffix, 1)) {
					boolean printFlag = invoice.isPrintMonthInvoice(billCycle, ValueUtils.longValue(contract), suffix);
					if (printFlag) {
						throw new BusiException(AcctMgrError.getErrorCode("8248", "10000"), contract + "在" + billCycle + "已经打印过发票，不能重复打印");
					}
				}

			}
			log.debug("开始查询是否做过统付划拨或者话费红包转账");
			// 查询是否统付划拨或者话费红包转账
			List<TransFeeEntity> transFeeListTmp = getTfRecord(ValueUtils.longValue(contract), beginYm, endYm);
			if (transFeeListTmp.size() > 0) {
				// 判断品牌是否为 LL-行业应用流量包和HK-行业应用流量卡不允许办理预存类划拨开具专票
				UserInfoEntity userInfo = user.getUserEntity(0l, "", ValueUtils.longValue(contract), false);
				if (userInfo != null) {
					// 查询品牌
					UserBrandEntity userBrand = user.getUserBrandRel(userInfo.getIdNo());
					if (!userBrand.getBrandId().equals("2310LL") && !userBrand.getBrandId().equals("2310HK")) {
						transFeeList.addAll(transFeeListTmp);
						log.debug("查询结束  账户：" + contract + "统付记录：" + transFeeListTmp.size());
					}
				}
			}
		}
		List<TaxInvoiceFeeEntity> invFeeDetail = new ArrayList<TaxInvoiceFeeEntity>();
		// 查询主账户的发票金额
		List<TaxInvoiceFeeEntity> invFeeDetailMain = invFee.getTaxInvoFeeDetail(contractNo, beginYm, endYm);
		invFeeDetail.addAll(invFeeDetailMain);
		log.debug("主账户的冲销账单：" + invFeeDetailMain.size());
		if (flag == 1) {
			// 获取欠费账单
			log.debug("开始查询未冲销账单");
			List<TaxInvoiceFeeEntity> invFeeUnpayMain = invFee.getUnPayInvoFee(contractNo, beginYm, endYm);
			if (invFeeUnpayMain.size() == 0) {
				throw new BusiException(AcctMgrError.getErrorCode("8248", "01015"), "该账户没有欠费，请到8248申请！");
			}
			invFeeDetail.addAll(invFeeUnpayMain);
		}
		if (transFeeList.size() > 0) {
			// 查询子账户的发票金额
			List<TaxInvoiceFeeEntity> invfeedetailSub = invFee.getSubTaxInvoFeeDetail(transFeeList);
			log.debug("子账户的冲销账单：" + invfeedetailSub.size());
			invFeeDetail.addAll(invfeedetailSub);
		}

		List<TaxInvoiceFeeEntity> invoiceFeeList = invFee.getTaxInvoFeeTotalForTaxPrint(invFeeDetail);
		log.debug("发票费用：" + invoiceFeeList);


		S8248QryInvoOutDTO outDto = new S8248QryInvoOutDTO();
		outDto.setTaxInvoiceList(invoiceFeeList);
		log.info("outDto=" + outDto.toJson());
		return outDto;
	}

	@Override
	public OutDTO qryInvNoForOnePay(InDTO inParam) {
		S8248QryOnePayInvoInDTO inDto = (S8248QryOnePayInvoInDTO) inParam;
		long contractNo = inDto.getContractNo();
		int beginYm = inDto.getBeginMon();
		int endYm = inDto.getEndMon();
		// 判断账户是否为一点支付账户
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("CONTRACTATT_TYPE", "A");
		ContractInfoEntity conInfo = account.getConInfo(inMap);
		if (conInfo == null) {
			throw new BusiException(AcctMgrError.getErrorCode("8248", "00018"), "该账户并非一点支付账户！");
		}
		// 判断cust_id是否有纳税人资质
		long custId = conInfo.getCustId();
		TaxPayerInfo taxPayInfo = cust.getTaxPayerInfo(custId, "");
		if (taxPayInfo == null) {
			throw new BusiException(AcctMgrError.getErrorCode("8248", "00002"), "该客户无增值税纳税人资质！");
		}
		int payBeginMonth = DateUtils.addMonth(beginYm, 1);
		int payEndMonth = DateUtils.addMonth(endYm, 1);
		List<TransFeeEntity> transFeeList = getTransRecd(contractNo, payBeginMonth, payEndMonth);
		log.debug("转账记录为：" + transFeeList);

		List<TaxInvoiceFeeEntity> invoiceFeeList = new ArrayList<TaxInvoiceFeeEntity>();
		// 获取子账户的账单信息
		List<TaxInvoiceFeeEntity> invoiceFeeListTmp1 = invFee.getTaxInvoFeeDetail(transFeeList, beginYm, endYm);
		// 获取主账户的账单信息
		List<TaxInvoiceFeeEntity> invoiceFeeListTmp2 = invFee.getTaxInvoFeeDetail(contractNo + "", beginYm, endYm);
		invoiceFeeList.addAll(invoiceFeeListTmp2);
		invoiceFeeList.addAll(invoiceFeeListTmp1);
		// 合并冲销账单信息
		List<TaxInvoiceFeeEntity> taxInvFeeList = invFee.getTaxInvoFeeTotalForTaxPrint(invoiceFeeList);

		// 查询纳税人信息
		TaxPayerInfo taxPayerInfo = cust.getTaxPayerInfo(custId, "");
		S8248QryOnePayInvoOutDTO outDto = new S8248QryOnePayInvoOutDTO();
		outDto.setAddressPhone(taxPayerInfo.getAddress() + "-" + taxPayerInfo.getPhoneNo());
		outDto.setBankNameAndAccount(taxPayerInfo.getBankName() + "-" + taxPayerInfo.getBankAccount());
		outDto.setUnitName(taxPayerInfo.getUnitName());
		outDto.setTaxPayerId(taxPayerInfo.getTaxpayerId());
		outDto.setTaxInvoiceList(taxInvFeeList);
		log.info("outDto=" + outDto.toJson());
		return outDto;
	}

	@Override
	public OutDTO cfmBOSS(InDTO inParam) {
		S8248BOSSCfmInDTO inDTO = (S8248BOSSCfmInDTO) inParam;
		log.info("inArg============" + inDTO);

		Map<String, Object> inMap = new HashMap<String, Object>();

		String contractNoStr = inDTO.getContractNo();
		int beginYm = inDTO.getBeginYm();
		int endYm = inDTO.getEndYm();
		int invType = inDTO.getInvType();
		String loginNo = inDTO.getLoginNo();
		String groupId = inDTO.getGroupId();
		String opCode = inDTO.getOpCode();
		int totalDate = DateUtils.getCurDay();
		String reportTo = inDTO.getReportTo();
		int qryType = inDTO.getQryType();
		int flag = inDTO.getFlag();

		long printFee = 0;
		long yuPrintFee = 0;
		long writePrintFee = 0;
		List<TransFeeEntity> transFeeList = new ArrayList<TransFeeEntity>();
		// 1.根据账户信息获取客户信息，phone_no待定，不知道取那个
		ContractInfoEntity contractInfo = account.getConInfo(ValueUtils.longValue(inDTO.getContractNo().split(",")[0]));

		String[] contractArray = inDTO.getContractNo().split(",");

		long custId = contractInfo.getCustId();

		long auditSn = control.getSequence("SEQ_SYSTEM_SN");
		long printSn = control.getSequence("SEQ_SYSTEM_SN");

		long orderSn = 0;
		if (StringUtils.isNotEmptyOrNull(inDTO.getOrderSn())) {
			orderSn = ValueUtils.longValue(inDTO.getOrderSn());
		} else {
			orderSn = auditSn;
		}

		// 根据custId查询纳税人信息
		TaxPayerInfo taxpayerInfo = cust.getTaxPayerInfo(custId, "");
		String unitName = taxpayerInfo.getUnitName();
		String taxpayerId = taxpayerInfo.getTaxpayerId();
		String phoneNo = "";
		// 如果有服务号码，则记录服务号码，如果没有服务号码，则不记录服务号码
		if (StringUtils.isNotEmptyOrNull(inDTO.getPhoneNo())) {
			phoneNo = inDTO.getPhoneNo();
		}

		String domainName = "";
		if ("1".equals(inDTO.getDataSource())) {
			domainName = "BOSS";
			// 如果为BOSS侧是数据，记录发票打印记录表

		} else if ("2".equals(inDTO.getDataSource())) {
			domainName = "CRM";
		}

		// 记录审核记录表
		BalInvauditInfo balAuditInfo = new BalInvauditInfo();
		balAuditInfo.setAuditSn(auditSn);
		balAuditInfo.setOrderSn(orderSn);
		balAuditInfo.setPrintSn(printSn + "");
		balAuditInfo.setPrintNum(1);
		balAuditInfo.setDataSource(domainName);
		balAuditInfo.setPhoneNo(phoneNo);
		balAuditInfo.setCustId(custId);
		balAuditInfo.setState("0");
		balAuditInfo.setPrintType("0");
		balAuditInfo.setInvType(invType + "");
		balAuditInfo.setLoginNo(loginNo);
		balAuditInfo.setUnitName(unitName);
		balAuditInfo.setTaxpayerId(taxpayerId);
		balAuditInfo.setBeginYm(beginYm);
		balAuditInfo.setEndYm(endYm);
		balAuditInfo.setReportTo(reportTo);
		if (StringUtils.isNotEmpty(inDTO.getRemark())) {
			balAuditInfo.setRemark(inDTO.getRemark());
		}
		invoice.insertInvAudit(balAuditInfo);

		List<TaxInvoiceFeeEntity> taxInvoiceFeeList = inDTO.getTaxInvoiceFeeList();

		int printArray = 1;
		for (TaxInvoiceFeeEntity taxInvoice : taxInvoiceFeeList) {
			taxInvoice.setPrintSn(printSn);
			taxInvoice.setPrintArray(printArray);
			taxInvoice.setTaxFee(Long.parseLong(taxInvoice.getTaxFee()) * 100 + "");
			taxInvoice.setFeeAccept(taxInvoice.getFeeAccept());
			taxInvoice.setFeeCode(taxInvoice.getFeeCode());
			taxInvoice.setFeeCodeSeq(taxInvoice.getFeeCodeSeq());
			taxInvoice.setFeeType(taxInvoice.getFeeType());
			taxInvoice.setOrderId(taxInvoice.getOrderId());
			printArray = printArray + 1;
			// 记录增值税发票明细表 bal_invtaxprint_info
			invoice.insertTaxPrint(taxInvoice);
		}

		// TODO:给审批人发送短信
		MBean inMessage = new MBean();
		String sendFlag = control.getPubCodeValue(2011, "DXFS", "0");
		inMessage.addBody("TEMPLATE_ID", "311100824801");
		inMessage.addBody("PHONE_NO", inDTO.getAuditPhoneNo());
		inMessage.addBody("LOGIN_NO", inDTO.getLoginNo());
		inMessage.addBody("OP_CODE", inDTO.getOpCode());
		inMessage.addBody("CHECK_FLAG", true);

		Map<String, Object> mapTmp = new HashMap<String, Object>();
		mapTmp.put("msg_content2", auditSn);
		inMessage.addBody("DATA", mapTmp);

		if (sendFlag.equals("0")) {
			inMessage.addBody("SEND_FLAG", 0);
		} else if (sendFlag.equals("1")) {
			inMessage.addBody("SEND_FLAG", 1);
		}

		log.info("发送短信内容：" + inMessage.toString());
		shortMessage.sendSmsMsg(inMessage, 1);

		List<TaxInvoiceFeeEntity> invoiceFeeDetailList = new ArrayList<TaxInvoiceFeeEntity>();
		if (inDTO.getDataSource().equals("1")) {
			// 查询是否打印过发票
			int curYM = DateUtils.getCurYm();
			for (String contract : contractArray) {
				for (int billCycle = beginYm; billCycle <= endYm; billCycle = DateUtils.addMonth(billCycle, 1)) {

					for (int suffix = billCycle; suffix <= curYM; suffix = DateUtils.addMonth(suffix, 1)) {
						boolean printFlag = invoice.isPrintMonthInvoice(billCycle, ValueUtils.longValue(contract), suffix);
						if (printFlag) {
							throw new BusiException(AcctMgrError.getErrorCode("8248", "10000"), contract + "在" + billCycle + "已经打印过发票，不能重复打印");
						}
					}

				}
				log.debug("开始查询是否做过统付划拨或者话费红包转账");
				// 查询是否统付划拨或者话费红包转账
				List<TransFeeEntity> transFeeListTmp = getTfRecord(ValueUtils.longValue(contract), beginYm, endYm);
				if (transFeeListTmp.size() > 0) {
					// 判断品牌是否为 LL-行业应用流量包和HK-行业应用流量卡不允许办理预存类划拨开具专票
					UserInfoEntity userInfo = user.getUserEntity(0l, "", ValueUtils.longValue(contract), false);
					if (userInfo != null) {
						// 查询品牌
						UserBrandEntity userBrand = user.getUserBrandRel(userInfo.getIdNo());
						if (!userBrand.getBrandId().equals("2310LL") && !userBrand.getBrandId().equals("2310HK")) {
							transFeeList.addAll(transFeeListTmp);
							log.debug("查询结束  账户：" + contract + "统付记录：" + transFeeListTmp.size());
						}
					}
				}
			}
			// 是否是预开
			if (flag == 1) {
				List<TaxInvoiceFeeEntity> invoiceFeeDetailUnpay = invFee.getUnPayInvoFee(contractNoStr, beginYm, endYm);
				log.debug("未冲销账单列表：" + invoiceFeeDetailUnpay);
				// 计算预开金额
				for (TaxInvoiceFeeEntity taxInvoiceEnt : invoiceFeeDetailUnpay) {
					yuPrintFee += taxInvoiceEnt.getWriteFee();
				}
				invoiceFeeDetailList.addAll(invoiceFeeDetailUnpay);
			}
			if (qryType == 2) {
				int payBeginMonth = DateUtils.addMonth(beginYm, 1);
				int payEndMonth = DateUtils.addMonth(endYm, 1);
				transFeeList = getTransRecd(ValueUtils.longValue(contractNoStr), payBeginMonth, payEndMonth);
				List<TaxInvoiceFeeEntity> invoiceFeeDetailListTmp1 = invFee.getTaxInvoFeeDetail(transFeeList, beginYm, endYm);
				invoiceFeeDetailList.addAll(invoiceFeeDetailListTmp1);
			} else {
				List<TaxInvoiceFeeEntity> invoiceFeeDetailListSub = invFee.getSubTaxInvoFeeDetail(transFeeList);
				invoiceFeeDetailList.addAll(invoiceFeeDetailListSub);
			}
			List<TaxInvoiceFeeEntity> invoiceFeeDetailListTmp2 = invFee.getTaxInvoFeeDetail(contractNoStr, beginYm, endYm);
			invoiceFeeDetailList.addAll(invoiceFeeDetailListTmp2);
			// BOSS 侧数据需要记录发票打印记录表
			log.debug("需要处理的冲销记录有：" + invoiceFeeDetailList.size());
			List<TaxInvoiceFeeEntity> taxInvFeeList = invFee.getTaxInvoFeeTotalForInvPrint(invoiceFeeDetailList);
			log.debug("taxInvFeeList:" + taxInvFeeList);
			log.debug("taxInvFeeList的大小：" + taxInvFeeList.size());
			if (flag == 1) {
				// 计算总金额，预开金额，冲销开具金额
				long contractTmp = 0;
				for (TaxInvoiceFeeEntity taxInvFeeEnt : taxInvFeeList) {
					printFee += taxInvFeeEnt.getWriteFee();
					contractTmp = taxInvFeeEnt.getContractNo();
				}
				writePrintFee = printFee - yuPrintFee;
				// 记录预开票记录表
				BalTaxinvoicePre taxInvoicePre = new BalTaxinvoicePre();
				// 查询contract_no 对应的id_no
				UserInfoEntity userInfo = user.getUserEntityByConNo(contractTmp, false);
				long idNoTmp = 0;
				String phoneNoTmp = "";
				if (userInfo != null) {
					idNoTmp = userInfo.getIdNo();
					phoneNoTmp = userInfo.getPhoneNo();
				}
				taxInvoicePre.setIdNo(idNoTmp);
				taxInvoicePre.setContractNo(contractTmp);
				taxInvoicePre.setPhoneNo(phoneNoTmp);
				taxInvoicePre.setInvoiceAccept(printSn);
				taxInvoicePre.setInvoiceLogin(loginNo);
				taxInvoicePre.setOpCode("2317");
				taxInvoicePre.setRealInvMoney(printFee);
				taxInvoicePre.setCurrentInvleft(writePrintFee);
				taxInvoicePre.setPreInvMoney(yuPrintFee);
				taxInvoicePre.setStatus("p");
				taxInvoicePre.setChgFlag("1");
				invoice.insertTaxPre(taxInvoicePre);
			}
			List<BalInvprintInfoEntity> invprintInfoList = new ArrayList<BalInvprintInfoEntity>();
			for (TaxInvoiceFeeEntity taxInvFee : taxInvFeeList) {
				printArray = 1;
				BalInvprintInfoEntity invprintInfo = new BalInvprintInfoEntity();
				invprintInfo.setPrintSn(printSn);
				invprintInfo.setPrintArray(printArray);
				invprintInfo.setCustId(custId);
				invprintInfo.setIdNo(0l);
				if (qryType == 2) {
					invprintInfo.setContractNo(ValueUtils.longValue(contractNoStr));
					invprintInfo.setRelContractNo(taxInvFee.getContractNo());
				} else {
					if (StringUtils.isNotEmptyOrNull(taxInvFee.getMainContractNo()) && taxInvFee.getMainContractNo() > 0) {
						invprintInfo.setContractNo(taxInvFee.getMainContractNo());
						invprintInfo.setRelContractNo(taxInvFee.getContractNo());
					} else {
						invprintInfo.setContractNo(taxInvFee.getContractNo());
					}

				}

				invprintInfo.setBillCycle(taxInvFee.getBillCycle());
				invprintInfo.setInvNo("0000");
				invprintInfo.setInvCode("00000");
				invprintInfo.setState("0");
				invprintInfo.setInvType("MM5002");
				invprintInfo.setTotalFee(taxInvFee.getWriteFee());
				invprintInfo.setPrintFee(taxInvFee.getWriteFee());
				invprintInfo.setPrintNum(1);
				invprintInfo.setLoginNo(loginNo);
				invprintInfo.setGroupId(groupId);
				invprintInfo.setOpCode(opCode);
				invprintInfo.setTotalDate(totalDate);
				invprintInfo.setPrintSeq(1);
				invprintInfoList.add(invprintInfo);
			}
			invoice.iBalInvprintInfo(invprintInfoList);
			// 更新print_flag标志
			if (qryType == 2) {
				// 更新主账户的冲销表中的记录
				List<Integer> billcycleList = new ArrayList<Integer>();
				for (int billCycle = beginYm; billCycle <= endYm; billCycle = DateUtils.addMonth(billCycle, 1)) {
					billcycleList.add(billCycle);
				}
				int curYm = DateUtils.getCurYm();
				inMap = new HashMap<String, Object>();
				inMap.put("PRINT_FLAG", "3");
				inMap.put("PRINT_SN", printSn);
				inMap.put("ACCPERT_PAYTYPE", "Y");
				inMap.put("PRINT_FLAG_OLD", "0");
				inMap.put("BILL_CYCLE_LIST", billcycleList);
				inMap.put("CONTRACT_NO", contractNoStr);
				for (int suffix = beginYm; suffix <= curYm; suffix = DateUtils.addMonth(suffix, 1)) {
					inMap.put("SUFFIX", suffix);
					log.debug("冲销表中更新打印标志的入参：" + inMap);
					balance.upWriteOffPrintFlag(inMap);
				}
				// 更新子账户的冲销标志
				// 更新冲销表的记录
				for (TransFeeEntity transFee : transFeeList) {
					balance.updateFlagForOnePay(transFee.getTransSn(), printSn, transFee.getContractnoIn(), transFee.getTotalDate() / 100, beginYm,
							endYm);
				}

			} else {
				// 更新主账户的记录
				String[] contractNoArray = contractNoStr.split(",");
				List<Long> contractNoList = new ArrayList<Long>();
				for (String contractNo : contractNoArray) {
					contractNoList.add(ValueUtils.longValue(contractNo));
				}

				List<Integer> billcycleList = new ArrayList<Integer>();
				for (int billCycle = beginYm; billCycle <= endYm; billCycle = DateUtils.addMonth(billCycle, 1)) {
					billcycleList.add(billCycle);
				}

				int curYm = DateUtils.getCurYm();
				inMap = new HashMap<String, Object>();
				inMap.put("PRINT_FLAG", "3");
				inMap.put("PRINT_SN", printSn);
				inMap.put("ACCPERT_PAYTYPE", "Y");
				inMap.put("PRINT_FLAG_OLD", "0");
				inMap.put("BILL_CYCLE_LIST", billcycleList);
				inMap.put("CONTRACT_NO_LIST", contractNoList);
				for (int suffix = beginYm; suffix <= curYm; suffix = DateUtils.addMonth(suffix, 1)) {
					inMap.put("SUFFIX", suffix);
					balance.upWriteOffPrintFlag(inMap);
				}

				// 更新子账户的记录
				List<Long> transContractList = new ArrayList<Long>();
				// 转账的账户，如果是集团统付或者话费红包的，不按照账期更新冲销表，要根据balance_id去更新冲销表
				List<Long> balanceIdList = new ArrayList<Long>();
				if (transFeeList.size() > 0) {
					for (TransFeeEntity transFeeEnt : transFeeList) {
						transContractList.add(transFeeEnt.getContractnoIn());
					}
					for (TaxInvoiceFeeEntity taxinvoiceEnt : invoiceFeeDetailList) {
						if (transContractList.contains(taxinvoiceEnt.getContractNo())) {
							if (balanceIdList.contains(taxinvoiceEnt.getBalanceId())) {
								continue;
							}
							balanceIdList.add(taxinvoiceEnt.getBalanceId());
						}
					}
					log.debug("子账户列表个数：" + transContractList.size() + "   balanceIdList的个数:" + balanceIdList.size());
					inMap = new HashMap<String, Object>();
					inMap.put("PRINT_FLAG", "3");
					inMap.put("PRINT_SN", printSn);
					inMap.put("ACCPERT_PAYTYPE", "Y");
					inMap.put("PRINT_FLAG_OLD", "0");
					inMap.put("BALANCE_ID_LIST", balanceIdList);
					inMap.put("CONTRACT_NO_LIST", transContractList);
					for (int suffix = beginYm; suffix <= curYm; suffix = DateUtils.addMonth(suffix, 1)) {
						inMap.put("SUFFIX", suffix);
						balance.upWriteOffPrintFlag(inMap);
					}
				}
			}

		} else {
			// CRM 侧数据需要发送工单
			Map<String, Object> header = new HashMap<String, Object>();
			MapUtils.safeAddToMap(header, "DB_ID", inDTO.getHeader().get("DB_ID"));

			Map<String, Object> orderMap = new HashMap<>();
			orderMap.put("HEADER", header);
			orderMap.put("BUSI_CODE", "0000");
			orderMap.put("LOGIN_NO", inDTO.getLoginNo());
			orderMap.put("OP_CODE", opCode);
			orderMap.put("LOGIN_ACCEPT", auditSn);
			orderMap.put("CREATE_TIME", DateUtils.getCurDate(DateUtils.DATE_FORMAT_YYYYMMDDHHMISS));
			orderMap.put("BUSIID_NO", phoneNo);
			orderMap.put("REMARK", "增值税发票生成接口");
			orderMap.put("ORDER_ID", "10010");

			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("SERVICE_NO", phoneNo);
			dataMap.put("DJH", "" + auditSn);
			dataMap.put("BUSI_TYPE", "01");
			dataMap.put("STATE", "Y");
			List<Map<String, Object>> feeList = new ArrayList<Map<String, Object>>();
			for (TaxInvoiceFeeEntity taxFee : taxInvoiceFeeList) {
				Map<String, Object> feeMap = new HashMap<String, Object>();
				feeMap.put("ORDER_ID", taxFee.getOrderId());
				feeMap.put("FEE_ACCEPT", taxFee.getFeeAccept());
				feeMap.put("FEE_CODE_SEQ", taxFee.getFeeCodeSeq());
				feeList.add(feeMap);
			}
			dataMap.put("FEE_LIST", feeList);

			String jsonStr = JSON.toJSONString(dataMap);
			log.debug("报文：" + jsonStr);

			orderMap.put("DATA_CONT", JSON.parseObject(jsonStr, Map.class));

			// 发送工单给CRM
			busiMsgSend.opPubOdrSndInter(orderMap);
		}
		// 记录营业员操作日志表
		LoginOprEntity loe = new LoginOprEntity();
		loe.setLoginGroup(inDTO.getGroupId());
		loe.setLoginNo(inDTO.getLoginNo());
		loe.setLoginSn(printSn);
		loe.setTotalDate(DateUtils.getCurDay());
		loe.setIdNo(0);
		loe.setBrandId("xx");
		loe.setPayType("00");
		loe.setPayFee(0);
		loe.setOpCode(inDTO.getOpCode());
		loe.setRemark(inDTO.getLoginNo() + "申请打印增值税专票");
		record.saveLoginOpr(loe);

		S8248BOSSCfmOutDTO outDto = new S8248BOSSCfmOutDTO();
		return outDto;
	}

	@Override
	public OutDTO invoiceFlowInfo(InDTO inParam) {

		S8248QryInvoiceFlowInDTO inDTO = (S8248QryInvoiceFlowInDTO) inParam;

		Map<String, Object> inMap = new HashMap<>();

		int qryType = inDTO.getQryType();

		String[] state = { "9", "a" };
		if (qryType == 1) {
			inMap.put("EXP_STATE", state);
			// 添加申请工号
			inMap.put("LOGIN_NO", inDTO.getLoginNo());
		} else {
			inMap.put("STATE", state);
		}

		int beginYm = inDTO.getBeginYm();
		int endYm = inDTO.getEndYm();

		inMap.put("BEGIN_YM", beginYm);
		inMap.put("END_YM", endYm);

		String phoneNo = "";
		if (StringUtils.isNotEmptyOrNull(inDTO.getPhoneNo())) {
			phoneNo = inDTO.getPhoneNo();
			inMap.put("PHONE_NO", phoneNo);
		}

		if (StringUtils.isNotEmptyOrNull(inDTO.getTaxPayerId())) {
			String taxPayerId = inDTO.getTaxPayerId();
			// 根据taxpayerid查询cust_id
			TaxPayerInfo taxPayerInfo = cust.getTaxPayerInfo(0, taxPayerId);
			if (taxPayerInfo == null) {
				throw new BusiException(AcctMgrError.getErrorCode("8248", "00002"), "该客户无增值税纳税人资质！");
			}
			long custId = taxPayerInfo.getCustId();
			inMap.put("CUST_ID", custId);
		}

		// 查询流程信息
		List<BalInvauditInfo> auditInfoList = invoice.getAuditInfoList(inMap);
		log.debug("auditInfoList:" + auditInfoList);
		// 获取纳税人信息
		for (BalInvauditInfo auditInfo : auditInfoList) {
			long custId = auditInfo.getCustId();
			// 根据custID查询纳税人信息
			TaxPayerInfo taxPayerInfo = cust.getTaxPayerInfo(custId, "");
			auditInfo.setAddressPhone(taxPayerInfo.getAddress() + "-" + taxPayerInfo.getPhoneNo());
			auditInfo.setBankNameAndAccount(taxPayerInfo.getBankName() + "-" + taxPayerInfo.getBankAccount());
			auditInfo.setPositionName(invoice.getPositionName(auditInfo.getState()));
		}
		S8248QryInvoiceFlowOutDTO outDto = new S8248QryInvoiceFlowOutDTO();
		outDto.setAuditInfoList(auditInfoList);
		return outDto;

	}

	@Override
	public OutDTO invoiceFeeInfo(InDTO inParam) {
		S8248QryInvoiceFeeInDTO inDTO = (S8248QryInvoiceFeeInDTO) inParam;
		long printSn = inDTO.getPrintSn();
		String taxpayerId = inDTO.getTaxPayerId();
		List<TaxInvoiceFeeEntity> taxInvoiceFeeList = invoice.getInvoiceFeeList(printSn, "");
		// 查询购方信息
		TaxPayerInfo taxPayerInfo = cust.getTaxPayerInfo(0, taxpayerId);
		String unitName = taxPayerInfo.getUnitName();
		String taxPayerId = taxPayerInfo.getTaxpayerId();
		String address = taxPayerInfo.getAddress();
		String phoneNo = taxPayerInfo.getPhoneNo();
		String bankName = taxPayerInfo.getBankName();
		String bankAccount = taxPayerInfo.getBankAccount();

		long invoiceFeeTotal = 0;
		long taxFeeTotal = 0;
		long printFee = 0;
		for (TaxInvoiceFeeEntity taxInvoiceFee : taxInvoiceFeeList) {
			taxInvoiceFee.setTaxFee(ValueUtils.transFenToYuan(ValueUtils.longValue(taxInvoiceFee.getTaxFee())) + "");
			invoiceFeeTotal += Long.parseLong(taxInvoiceFee.getInvoiceFee());
			taxFeeTotal += (long) (Double.parseDouble(taxInvoiceFee.getTaxFee()));
		}
		printFee = new BigDecimal(invoiceFeeTotal + taxFeeTotal).setScale(0, BigDecimal.ROUND_HALF_UP).longValue();
		String bigFee = ValueUtils.transYuanToChnaBig(ValueUtils.transFenToYuan(printFee));
		S8248QryInvoiceFeeOutDTO outDTO = new S8248QryInvoiceFeeOutDTO();
		outDTO.setTaxInvFeeList(taxInvoiceFeeList);
		outDTO.setAddress(address);
		outDTO.setPhoneNo(phoneNo);
		outDTO.setUnitName(unitName);
		outDTO.setTaxPayerId(taxPayerId);
		outDTO.setBankAccount(bankAccount);
		outDTO.setBankName(bankName);
		outDTO.setInvoiceFeeTotal(invoiceFeeTotal + "");
		outDTO.setTaxFeeTotal(taxFeeTotal + "");
		outDTO.setPrintFee(printFee + "");
		outDTO.setBigFee(bigFee);
		return outDTO;
	}

	@Override
	public OutDTO redInvoiceReq(InDTO inParam) {
		S8248RedInvoiceReqInDTO inDto = (S8248RedInvoiceReqInDTO) inParam;
		// 根据auditSn查询是否已经申请过，如果已经申请过，则不允许再次申请
		long auditSn = inDto.getAuditSn();
		String loginNo = inDto.getLoginNo();
		String reportNo = inDto.getReportTo();

		int cnt = invoice.isApplyRed(auditSn);
		if (cnt > 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8248", "00008"), "已申请，不能重复申请！");
		}

		long auditSnNew = control.getSequence("SEQ_SYSTEM_SN");
		long printSn = control.getSequence("SEQ_SYSTEM_SN");
		// 入审核表
		BalInvauditInfo auditInfo = new BalInvauditInfo();
		auditInfo.setAuditSn(auditSnNew);
		auditInfo.setAuditSnRel(auditSn);
		auditInfo.setPrintSn(printSn + "");
		auditInfo.setState("0");
		auditInfo.setInvType("1");// 红字发票
		auditInfo.setLoginNo(loginNo);
		auditInfo.setRemark(inDto.getRemark());
		auditInfo.setRedinvCause(inDto.getRedinvCause());
		auditInfo.setRedinvRemark(inDto.getRedinvRemark());
		auditInfo.setReportTo(reportNo);
		invoice.insertAuditForRed(auditInfo);

		// 根据audit_sn查询发票明细表
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("AUDIT_SN", auditSn);
		inMap.put("BEGIN_YM", inDto.getBeginYm());
		inMap.put("END_YM", inDto.getEndYm());
		List<BalInvauditInfo> invAudit = invoice.getAuditInfoList(inMap);
		if (invAudit.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8248", "00017"), "找不到相关记录！");
		}
		long printSnOld = ValueUtils.longValue(invAudit.get(0).getPrintSn());
		// 根据流水查询发票费用信息
		List<TaxInvoiceFeeEntity> taxInvoiceFeeList = invoice.getInvoiceFeeForRedList(printSnOld);

		int printArray = 0;
		for (TaxInvoiceFeeEntity taxInvoiceFee : taxInvoiceFeeList) {
			double taxRate = Double.parseDouble(taxInvoiceFee.getTaxRate());
			long codeClass = 105;
			String codeId = taxRate + "";
			String groupId = "0";
			String goodsName = control.getPubCodeValue(codeClass, codeId, groupId);
			taxInvoiceFee.setGoodsName(goodsName);
			taxInvoiceFee.setPrintSn(printSn);
			taxInvoiceFee.setGoodsNum("-1");
			taxInvoiceFee.setGoodsPrice((ValueUtils.longValue(taxInvoiceFee.getGoodsPrice())) + "");
			taxInvoiceFee.setInvoiceFee((0 - ValueUtils.longValue(taxInvoiceFee.getInvoiceFee())) + "");
			taxInvoiceFee.setTaxFee((0 - ValueUtils.longValue(taxInvoiceFee.getTaxFee())) + "");
			taxInvoiceFee.setPrintArray(printArray);
			invoice.insertTaxPrint(taxInvoiceFee);
			printArray++;
		}

		// TODO:给审批人发送短信
		MBean inMessage = new MBean();
		String flag = control.getPubCodeValue(2011, "DXFS", "0");
		inMessage.addBody("TEMPLATE_ID", "311100824801");
		inMessage.addBody("PHONE_NO", inDto.getAuditPhoneNo());
		inMessage.addBody("LOGIN_NO", inDto.getLoginNo());
		inMessage.addBody("OP_CODE", inDto.getOpCode());
		inMessage.addBody("CHECK_FLAG", true);

		Map<String, Object> mapTmp = new HashMap<String, Object>();
		mapTmp.put("msg_content2", auditSn);
		inMessage.addBody("DATA", mapTmp);

		if (flag.equals("0")) {
			inMessage.addBody("SEND_FLAG", 0);
		} else if (flag.equals("1")) {
			inMessage.addBody("SEND_FLAG", 1);
		}

		log.info("发送短信内容：" + inMessage.toString());
		shortMessage.sendSmsMsg(inMessage, 1);

		S8248RedInvoiceReqOutDTO outDto = new S8248RedInvoiceReqOutDTO();
		return outDto;
	}

	@Override
	public OutDTO dataReset(InDTO inParam) {
		S8248DataResetInDTO inDto = (S8248DataResetInDTO) inParam;
		long auditSn = inDto.getAuditSn();

		int invType = inDto.getInvType();
		String state = "2";

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("AUDIT_SN", auditSn);

		// 根据审批流水查询申请记录
		List<BalInvauditInfo> auditInfoList = invoice.getAuditInfoList(inMap);
		if (auditInfoList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8248", "00017"), "没有找到对应的审批记录");
		}

		BalInvauditInfo auditInfo = auditInfoList.get(0);

		long printSn = 0;
		String insertTime = "";
		if (invType == 0) {
			// 作废发票，更新审核表中的state为‘a’
			inMap = new HashMap<String, Object>();
			state = "2";
			printSn = ValueUtils.longValue(auditInfo.getPrintSn());
			insertTime = auditInfo.getInsertTime();

			inMap.put("STATE", CommonConst.WRONG_STATE);
			inMap.put("PRINT_SN", printSn);
			invoice.updateAuditState(inMap);
		} else {
			if (invType == 2) {
				state = "2";
			}
			if (invType == 1) {
				state = "6";
			}
			// 红字发票，查询对应蓝字发票的printSn
			long auditSnRel = auditInfo.getAuditSnRel();
			inMap = new HashMap<String, Object>();
			inMap.put("AUDIT_SN", auditSnRel);
			List<BalInvauditInfo> blueAuditList = invoice.getAuditInfoList(inMap);
			BalInvauditInfo blueAudit = blueAuditList.get(0);
			printSn = ValueUtils.longValue(blueAudit.getPrintSn());
			insertTime = blueAudit.getInsertTime();
		}
		if (auditInfo.getDataSource().equals("BOSS")) {
			// 更新冲销表中的记录（print_flag=0，print_sn=0）
			invoice.updateWriteFlag(printSn, insertTime);

			// 更新发票记录表中的记录 state（作废更新成2 冲红更新为6）
			inMap = new HashMap<String, Object>();
			inMap.put("STATE", state);
			inMap.put("PRINT_SN", printSn);
			inMap.put("SUFFIX", insertTime);
			invoice.updateState(inMap);
			// 判断是否开具的预开发票
			invoice.updateTaxPreStatus(printSn, "3");
		} else {
			// CRM发送工单作废
			Map<String, Object> header = new HashMap<String, Object>();
			MapUtils.safeAddToMap(header, "DB_ID", inDto.getHeader().get("DB_ID"));

			Map<String, Object> orderMap = new HashMap<>();
			orderMap.put("HEADER", header);
			orderMap.put("BUSI_CODE", "0000");
			orderMap.put("LOGIN_NO", inDto.getLoginNo());
			orderMap.put("OP_CODE", "8248");
			orderMap.put("LOGIN_ACCEPT", auditSn);
			orderMap.put("ORDER_ID", "10010");
			orderMap.put("CREATE_TIME", DateUtils.getCurDate(DateUtils.DATE_FORMAT_YYYYMMDDHHMISS));
			orderMap.put("BUSIID_NO", auditInfo.getPhoneNo());
			orderMap.put("REMARK", "增值税发票作废接口");

			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("SERVICE_NO", auditInfo.getPhoneNo());
			dataMap.put("DJH", "" + auditSn);
			dataMap.put("BUSI_TYPE", "01");
			dataMap.put("STATE", "N");
			List<Map<String, Object>> feeList = new ArrayList<Map<String, Object>>();
			// 根据审批流水，查询入表的记录
			List<TaxInvoiceFeeEntity> taxInvoiceFeeList = invoice.getInvoiceFeeList(printSn, "");
			for (TaxInvoiceFeeEntity taxFee : taxInvoiceFeeList) {
				Map<String, Object> feeMap = new HashMap<String, Object>();
				feeMap.put("ORDER_ID", taxFee.getOrderId());
				feeMap.put("FEE_ACCEPT", taxFee.getFeeAccept());
				feeMap.put("FEE_CODE_SEQ", taxFee.getFeeCodeSeq());
				feeList.add(feeMap);
			}
			dataMap.put("FEE_LIST", feeList);

			String jsonStr = JSON.toJSONString(dataMap);
			log.debug("报文：" + jsonStr);

			orderMap.put("DATA_CONT", dataMap);

			// 发送工单给CRM
			busiMsgSend.opPubOdrSndInter(orderMap);
		}

		S8248DataResetOutDTO outDto = new S8248DataResetOutDTO();
		return outDto;
	}

	@Override
	public OutDTO flowOverCfm(InDTO inparam) {
		// 更新bal_invaudit_info 表中的状态，更新为9
		S8248FlowOverCfmInDTO inDto = (S8248FlowOverCfmInDTO) inparam;
		long auditSn = inDto.getAuditSn();
		// int opTime = inDto.getOpTime();

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("STATE", CommonConst.FILE_STATE);
		inMap.put("AUDIT_SN", auditSn);
		invoice.updateAuditState(inMap);
		S8248FlowOverCfmOutDTO outDto = new S8248FlowOverCfmOutDTO();
		return outDto;
	}

	/* 查询审批工号 */

	public OutDTO qryLoginNo(InDTO inParam) {

		S8248QryLoginNoInDTO inArg = (S8248QryLoginNoInDTO) inParam;
		S8248QryLoginNoOutDTO outArg = new S8248QryLoginNoOutDTO();
		log.debug("loginTYpe=" + inArg.getLoginType());
		List<LoginNoInfo> loginInfo = invoice.getInvLoginByGroup(inArg.getLoginType(), inArg.getGroupId(), inArg.getLoginNo());
		log.debug(loginInfo + "?????????");
		if (loginInfo == null || loginInfo.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8248", "00000"), "未找到对应的审批人");
		}
		outArg.setLoginInfo(loginInfo);

		return outArg;
	}

	@Override
	public OutDTO queryRedReason(InDTO inParam) {
		long codeClass = 1202;
		List<PubCodeDictEntity> pubCodeList = control.getPubCodeList(codeClass, "", "", "");
		S8248QueryRedReasonOutDTO outDTO = new S8248QueryRedReasonOutDTO();
		outDTO.setReasonList(pubCodeList);
		return outDTO;
	}

	// TODO:调用接口判断是否有总分关系
	private boolean isRealation(long contractNoPay, long contractNo) {
		// 查询账户的cust_id
		ContractInfoEntity conInfo = account.getConInfo(contractNoPay);
		long custIdPay = conInfo.getCustId();
		conInfo = account.getConInfo(contractNo);
		long custId = conInfo.getCustId();
		String interfaceName = "com_sitech_custmng_atom_inter_ITaxpayerInfoSvc_getTaxPayerRel";
		MBean mbean = new MBean();
		mbean.setBody("BUSI_INFO.PAR_CUST_ID", custIdPay + "");
		mbean.setBody("BUSI_INFO.LOW_CUST_ID", custId + "");
		mbean.setBody("BUSI_INFO.QRY_TYPE", "1");
		mbean.setBody("DATA_TYPE", "1");
		mbean.setRouteKey("13");
		mbean.setRouteValue(custIdPay + "");
		log.debug("调用查询总分关系接口开始");
		String outString = ServiceUtil.callService(interfaceName, mbean.toString());
		log.debug("调用查询总分关系接口开始" + outString);
		MBean outBean = new MBean(outString);
		int count = ValueUtils.intValue(outBean.getBodyObject("OUT_DATA.TOTAL_COUNT").toString());
		if (count > 0) {
			return true;
		} else {
			return false;
		}
	}

	// 查询一点支付账户给子账户的转账记录
	private List<TransFeeEntity> getTransRecd(long contractNoPay, int beginYm, int endYm) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		// 获取一点支付账户统付划拨记录
		inMap = new HashMap<String, Object>();
		String[] opCodeList = { "8020", "8078" };
		inMap.put("CONTRACTNO_OUT", contractNoPay);
		inMap.put("OP_TYPE", "YDZF");
		inMap.put("FACTOR_ONE", "1");// 全额支付
		inMap.put("OP_CODE_LIST", opCodeList);
		int payBeginMonth = DateUtils.addMonth(beginYm, 1);
		int payEndMonth = DateUtils.addMonth(endYm, 1);
		List<TransFeeEntity> transFeeList = new ArrayList<TransFeeEntity>();
		for (int suffix = payBeginMonth; suffix <= payEndMonth; suffix = DateUtils.addMonth(suffix, 1)) {
			inMap.put("SUFFIX", suffix);
			List<TransFeeEntity> transFeeTmp = record.getTransInfo(inMap);

			// TODO: 判断主账户和子账户是否有总分关系
			for (TransFeeEntity transFee : transFeeTmp) {
				if (isRealation(contractNoPay, transFee.getContractnoIn())) {
					transFeeList.add(transFee);
				}
			}
		}
		return transFeeList;
	}

	private List<TransFeeEntity> getTfRecord(long contractNoPay, int beginYm, int endYm) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		// 获取一点支付账户统付划拨记录
		inMap = new HashMap<String, Object>();
		String[] opType = { "TFAccount", "" };
		String[] opCodeList = { "8014", "8078" };
		inMap.put("CONTRACTNO_OUT", contractNoPay);
		inMap.put("OP_TYPE_LIST", opType);
		inMap.put("FACTOR_ONE", "1");// 全额支付
		inMap.put("OP_CODE_LIST", opCodeList);
		List<TransFeeEntity> transFeeList = new ArrayList<TransFeeEntity>();
		for (int suffix = beginYm; suffix <= endYm; suffix = DateUtils.addMonth(suffix, 1)) {
			inMap.put("SUFFIX", suffix + "");
			List<TransFeeEntity> transFeeTmp = record.getTransInfo(inMap);
			transFeeList.addAll(transFeeTmp);
		}
		inMap = new HashMap<String, Object>();
		String[] opType1 = { "HFHBTrans" };
		String[] opCodeList1 = { "8014" };
		inMap.put("CONTRACTNO_OUT", contractNoPay);
		inMap.put("OP_TYPE_LIST", opType1);
		inMap.put("OP_CODE_LIST", opCodeList1);
		for (int suffix = beginYm; suffix <= endYm; suffix = DateUtils.addMonth(suffix, 1)) {
			inMap.put("SUFFIX", suffix + "");
			List<TransFeeEntity> transFeeTmp = record.getTransInfo(inMap);
			transFeeList.addAll(transFeeTmp);
		}
		
		return transFeeList;
	}

	public IPreInvHeader getPreInvHeader() {
		return preInvHeader;
	}

	public void setPreInvHeader(IPreInvHeader preInvHeader) {
		this.preInvHeader = preInvHeader;
	}

	public IInvFee getInvFee() {
		return invFee;
	}

	public void setInvFee(IInvFee invFee) {
		this.invFee = invFee;
	}

	public IInvoice getInvoice() {
		return invoice;
	}

	public void setInvoice(IInvoice invoice) {
		this.invoice = invoice;
	}

	public void setInvoice(Invoice invoice) {
		this.invoice = invoice;
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

	public IUser getUser() {
		return user;
	}

	public void setUser(IUser user) {
		this.user = user;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

	public ICust getCust() {
		return cust;
	}

	public void setCust(ICust cust) {
		this.cust = cust;
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

	public IShortMessage getShortMessage() {
		return shortMessage;
	}

	public void setShortMessage(IShortMessage shortMessage) {
		this.shortMessage = shortMessage;
	}

	@Override
	public OutDTO invoiceTaxQryInfo(InDTO inParam) {
		// TODO 增值税专票查询
		S8248QryInvoiceFlowInDTO inDTO = (S8248QryInvoiceFlowInDTO) inParam;
		
		Map<String, Object> inMap = new HashMap<>();
		
		int qryType = inDTO.getQryType();
		
		// 设置入参
		// 设置状态参数
		String[] state = { "9", "a" };
		if (qryType == 1) {
			inMap.put("EXP_STATE", state);
			// 添加申请工号
			inMap.put("LOGIN_NO", inDTO.getLoginNo());
		} else {
			inMap.put("STATE", state);
		}

		int beginYm = inDTO.getBeginYm();
		int endYm = inDTO.getEndYm();
		// 设置查询的开始和结束时间		
		inMap.put("BEGIN_YM", beginYm);
		inMap.put("END_YM", endYm);

		String phoneNo = "";
		if (StringUtils.isNotEmptyOrNull(inDTO.getPhoneNo())) {
			phoneNo = inDTO.getPhoneNo();
			// 增值税专票发票号码
			inMap.put("PHONE_NO", phoneNo);
		}
		
		// 设置发票代码和号码
		inMap.put("INV_CODE",inDTO.getInvCode());
		inMap.put("INV_NO", inDTO.getInvNo());

		if (StringUtils.isNotEmptyOrNull(inDTO.getTaxPayerId())) {
			String taxPayerId = inDTO.getTaxPayerId();
			// 根据taxpayerid查询cust_id
			TaxPayerInfo taxPayerInfo = cust.getTaxPayerInfo(0, taxPayerId);
			if (taxPayerInfo == null) {
				throw new BusiException(AcctMgrError.getErrorCode("8248", "00002"), "该客户无增值税纳税人资质！");
			}
			long custId = taxPayerInfo.getCustId();
			inMap.put("CUST_ID", custId);
		}

		// 查询流程信息（出参）
		List<BalInvauditInfo> auditInfoList = invoice.getAuditInfoList(inMap);
		log.debug("auditInfoList:" + auditInfoList);
		// 获取纳税人信息
		for (BalInvauditInfo auditInfo : auditInfoList) {
			long custId = auditInfo.getCustId();
			// 根据custID查询纳税人信息
			TaxPayerInfo taxPayerInfo = cust.getTaxPayerInfo(custId, "");
			auditInfo.setAddressPhone(taxPayerInfo.getAddress() + "-" + taxPayerInfo.getPhoneNo());
			auditInfo.setBankNameAndAccount(taxPayerInfo.getBankName() + "-" + taxPayerInfo.getBankAccount());
			auditInfo.setPositionName(invoice.getPositionName(auditInfo.getState()));
		}
		S8248QryInvoiceFlowOutDTO outDto = new S8248QryInvoiceFlowOutDTO();
		outDto.setAuditInfoList(auditInfoList);
		return outDto;
	}

	public IBusiMsgSnd getBusiMsgSend() {
		return busiMsgSend;
	}

	public void setBusiMsgSend(IBusiMsgSnd busiMsgSend) {
		this.busiMsgSend = busiMsgSend;
	}

}