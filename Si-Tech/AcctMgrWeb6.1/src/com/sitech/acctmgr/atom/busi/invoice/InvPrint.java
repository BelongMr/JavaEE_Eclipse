package com.sitech.acctmgr.atom.busi.invoice;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.invoice.inter.IElecInvoice;
import com.sitech.acctmgr.atom.busi.invoice.inter.IInvFee;
import com.sitech.acctmgr.atom.busi.invoice.inter.IInvPrint;
import com.sitech.acctmgr.atom.busi.invoice.inter.IPreInvHeader;
import com.sitech.acctmgr.atom.busi.invoice.inter.IPrintDataXML;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.invoice.BalGrppreinvInfo;
import com.sitech.acctmgr.atom.domains.invoice.BalInvprintInfoEntity;
import com.sitech.acctmgr.atom.domains.invoice.BalInvprintdetInfo;
import com.sitech.acctmgr.atom.domains.invoice.BaseInvoiceDispEntity;
import com.sitech.acctmgr.atom.domains.invoice.InvBillCycleEntity;
import com.sitech.acctmgr.atom.domains.invoice.InvNoOccupyEntity;
import com.sitech.acctmgr.atom.domains.invoice.InvoiceDispEntity;
import com.sitech.acctmgr.atom.domains.invoice.MonthInvoiceDispEntity;
import com.sitech.acctmgr.atom.domains.invoice.PreInvoiceDispEntity;
import com.sitech.acctmgr.atom.domains.invoice.TaxInvoiceFeeEntity;
import com.sitech.acctmgr.atom.domains.invoice.elecInvoice.InvoiceDdInfo;
import com.sitech.acctmgr.atom.domains.invoice.elecInvoice.InvoiceDetailInfo;
import com.sitech.acctmgr.atom.domains.invoice.elecInvoice.InvoiceHeaderInfo;
import com.sitech.acctmgr.atom.domains.invoice.elecInvoice.InvoiceInfo;
import com.sitech.acctmgr.atom.domains.invoice.elecInvoice.InvoiceXhfInfo;
import com.sitech.acctmgr.atom.domains.pay.PayMentEntity;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.domains.user.VirtualGrpEntity;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IInvoice;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.BeanToMapUtils;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;

/**
 * 
 * @author liuhl_bj
 *
 */
public class InvPrint extends BaseBusi implements IInvPrint {

	private IPreInvHeader preInvHeader;
	private IInvoice invoice;
	private IInvFee invFee;
	private IControl control;
	private IPrintDataXML printDataXML;
	private IRecord record;
	private IUser user;
	private IAccount account;
	private IElecInvoice eleInvoice;
	private ILogin login;

	@Override
	public Map<String, Object> printPreInvoice(Map<String, Object> inParam) {
		long contractNo = ValueUtils.longValue(inParam.get("CONTRACT_NO"));
		String phoneNo = inParam.get("PHONE_NO").toString();
		int userFlag = ValueUtils.intValue(inParam.get("USER_FLAG"));
		String invNo = "";
		String invCode = "";
		// String chnSource = "01";
		if (StringUtils.isNotEmptyOrNull(inParam.get("INV_NO"))) {
			invNo = inParam.get("INV_NO").toString();
		}
		if (StringUtils.isNotEmptyOrNull(inParam.get("INV_CODE"))) {
			invCode = inParam.get("INV_CODE").toString();
		}
		boolean needXmlstr = true;
		String invType = CommonConst.YCFP_TYPE;
		String payType = "";
		if (StringUtils.isNotEmptyOrNull(inParam.get("PAY_TYPE"))) {
			payType = inParam.get("PAY_TYPE").toString();
		}

		if (StringUtils.isNotEmptyOrNull(inParam.get("NEED_XMLSTR"))) {
			needXmlstr = Boolean.parseBoolean(inParam.get("NEED_XMLSTR").toString());
		}
		log.debug("入参：" + inParam.get("INV_TYPE"));
		if (StringUtils.isNotEmptyOrNull(inParam.get("INV_TYPE"))) {
			invType = inParam.get("INV_TYPE").toString();
		}
		log.debug("invType:" + invType);
		Map<String, Object> inMap = new HashMap<String, Object>();
		// 判断该笔缴费有无打印月结发票，如果打印了月结发票之后，不允许打印预存发票
		inMap.put("SUFFIX", inParam.get("BILL_CYCLE"));
		inMap.put("PAY_SN", inParam.get("PAY_SN"));
		inMap.put("CONTRACT_NO", contractNo);
		if (Boolean.valueOf(inParam.get("IS_PRINT").toString())) {
			int cnt = invoice.isPrintMonthInvoice(inMap);
			if (cnt > 0) {
				throw new BusiException(AcctMgrError.getErrorCode("0000", "00200"), "该笔缴费已经打印过月结发票，不能在打印预存发票");
			}
		}

		log.debug("进入打印方法：userFlag=" + userFlag);
		// 获取发票上的基本信息
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("PHONE_NO", phoneNo);
		inMap.put("USER_FLAG", userFlag);
		if (StringUtils.isNotEmptyOrNull(inParam.get("OP_CODE"))) {
			inMap.put("OP_CODE", inParam.get("OP_CODE"));
		}
		inMap.put("LOGIN_NO", inParam.get("LOGIN_NO"));
		inMap.put("GROUP_ID", inParam.get("GROUP_ID"));
		inMap.put("PROVICE_ID", inParam.get("PROVICE_ID"));
		inMap.put("PRINT_TYPE", "2");
		BaseInvoiceDispEntity baseInvoiceDisp = preInvHeader.queryBaseInvInfo(inMap);

		// 获取发票上的流水
		long printSn = ValueUtils.longValue(inParam.get("PRINT_SN"));
		baseInvoiceDisp.setLoginAccept(printSn);
		if (StringUtils.isNotEmptyOrNull(inParam.get("INV_NO"))) {
			baseInvoiceDisp.setInvNo(inParam.get("INV_NO").toString());
		}
		if (Boolean.valueOf(inParam.get("IS_PRINT").toString())) {
			baseInvoiceDisp.setInvNoName("本次发票号码：");

		}

		// 获取发票上预存展示的内容
		PreInvoiceDispEntity preInvoiceDisp = new PreInvoiceDispEntity();
		inMap = new HashMap<String, Object>();
		inMap.put("BILL_CYCLE", inParam.get("BILL_CYCLE"));
		inMap.put("PAY_SN", inParam.get("PAY_SN"));
		// inMap.put("OP_CODE", inParam.get("OP_CODE"));
		inMap.put("USER_FLAG", userFlag);
		inMap.put("CONTRACT_NO", contractNo);
		preInvoiceDisp = invFee.getPreInvoiceFee(inMap);
		log.debug("发票上展示的预存费用：" + preInvoiceDisp);

		// 封装打印发票时的报文
		InvoiceDispEntity invoiceDisp = new InvoiceDispEntity();
		baseInvoiceDisp.setOpName(preInvoiceDisp.getOpName());
		baseInvoiceDisp.setOpCode(preInvoiceDisp.getOpCode());
		String remark = "";
		if (StringUtils.isNotEmptyOrNull(preInvoiceDisp.getRemark())) {
			remark = preInvoiceDisp.getRemark();
		}
		if (StringUtils.isNotEmptyOrNull(baseInvoiceDisp.getRemark())) {
			remark = remark + "  " + baseInvoiceDisp.getRemark();
		}
		baseInvoiceDisp.setRemark(remark);
		invoiceDisp.setBaseInvoice(baseInvoiceDisp);
		invoiceDisp.setPreInvoice(preInvoiceDisp);

		if (invoiceDisp.getBaseInvoice().getOpCode().equals("8008")) {
			invoiceDisp.getPreInvoice().setPrintFee(0 - invoiceDisp.getPreInvoice().getPrintFee());
			invoiceDisp.getPreInvoice().setCashMoney(0 - invoiceDisp.getPreInvoice().getCashMoney());
			invoiceDisp.getPreInvoice().setCheckMoney(0 - invoiceDisp.getPreInvoice().getCheckMoney());
			invoiceDisp.getPreInvoice().setPosMoney(0 - invoiceDisp.getPreInvoice().getPosMoney());
		}

		String printXml = "";
		if (needXmlstr || !invType.equals(CommonConst.ELE_YC_TYPE)) {
			if (StringUtils.isNotEmptyOrNull(inParam.get("PRINT_FLAG"))) {
				printXml = getXmlStr(invoiceDisp, userFlag, inParam.get("PRINT_FLAG").toString());
			} else {
				printXml = getXmlStr(invoiceDisp, userFlag, "");
			}

		}

		Map<String, Object> eleMap = new HashMap<String, Object>();
		InvoiceInfo eleInvoiceInfo = new InvoiceInfo();
		// InvoiceXhfInfo xhfInfo = new InvoiceXhfInfo();
		// 打印电子发票，拼装电子发票需要的参数
		if (invType.equals(CommonConst.ELE_YC_TYPE)) {
			String loginNo = invoiceDisp.getBaseInvoice().getLoginNo();
			// 查询工号所在地市
			String regionCode = login.getRegionCode(loginNo, "230000");
			// 获取销货方信息
			InvoiceXhfInfo xhfInfo = invoice.getInvoicexhfInfo(regionCode);
			// 获取发票头信息
			InvoiceHeaderInfo headerInfo = eleInvoice
					.getEleInvHeader(xhfInfo, baseInvoiceDisp.getOpCode(), baseInvoiceDisp.getCustName(), baseInvoiceDisp.getPhoneNo(),
							baseInvoiceDisp.getLoginName(), baseInvoiceDisp.getLoginAccept() + "", preInvoiceDisp.getPrintFee());
			// 获取费用行信息
			List<InvoiceDetailInfo> xmInfoList = new ArrayList<InvoiceDetailInfo>();
			InvoiceDetailInfo xmInfo = eleInvoice.getInvoiceItem(preInvoiceDisp.getPrintFee(), "号码缴费", "0");
			xmInfoList.add(xmInfo);
			// 获取订单行信息
			InvoiceDdInfo orderInfo = eleInvoice.getOrderInfo(baseInvoiceDisp.getLoginAccept() + "");
			eleInvoiceInfo.setInvoiceDd(orderInfo);
			eleInvoiceInfo.setInvoiceDetail(xmInfoList);
			eleInvoiceInfo.setInvoiceHeader(headerInfo);
			Map<String, String> retMap = eleInvoice.EInvPrintSub(eleInvoiceInfo, xhfInfo, loginNo, 0, inParam.get("CHN_SOURCE").toString());
			String returnCode = retMap.get("RETURN_CODE");
			String returnMsg = retMap.get("RETURN_MSG");
			invNo = retMap.get("INV_NO");
			invCode = retMap.get("INV_CODE");
			if (StringUtils.isEmptyOrNull(returnCode) || (StringUtils.isNotEmptyOrNull(returnCode) && !returnCode.equals("0000"))) {
				throw new BusiException(AcctMgrError.getErrorCode("8005", "00000"), StringUtils.isEmptyOrNull(returnMsg) ? "参数返回错误" : returnMsg);
			}
			// 记录电子发票的明细表
			TaxInvoiceFeeEntity taxInvoiceFee = new TaxInvoiceFeeEntity();
			taxInvoiceFee.setGoodsName("号码缴费");
			taxInvoiceFee.setPrintSn(printSn);
			taxInvoiceFee.setGoodsNum("1");
			taxInvoiceFee.setGoodsPrice(preInvoiceDisp.getPrintFee() + "");
			taxInvoiceFee.setInvoiceFee(preInvoiceDisp.getPrintFee() + "");
			taxInvoiceFee.setTaxFee("0");
			taxInvoiceFee.setTaxRate("0");
			taxInvoiceFee.setPrintArray(0);
			taxInvoiceFee.setRequestSn(headerInfo.getFpqqlsh());
			invoice.insertTaxPrint(taxInvoiceFee);
			// 把pdf文件入表bal_einvpdf_info

		}
		if (Boolean.valueOf(inParam.get("IS_PRINT").toString())) {
			if (StringUtils.isNotEmptyOrNull(inParam.get("PRINT_FLAG")) && inParam.get("PRINT_FLAG").toString().equals("1")) {
				// 更新发票记录总表中的打印张数
				log.debug("并非第一次打印，只更新发票记录总表中的打印张数");
				inMap = new HashMap<String, Object>();
				inMap.put("PAY_SN", inParam.get("PAY_SN"));
				inMap.put("PRINT_SEQ", inParam.get("PRINT_SEQ").toString());
				inMap.put("SUFFIX", inParam.get("SUFFIX").toString());
				invoice.upPrintSeq(inMap);

			} else {
				log.debug("第一次打印，更新账本表和冲销表中的发票状态");
				// 更新打印状态
				invoice.updatePrintFlagByPre(ValueUtils.longValue(inParam.get("PAY_SN").toString()), printSn, payType,
						ValueUtils.intValue(inParam.get("BILL_CYCLE").toString()), contractNo);

				// 入发票总表和发票明细表
				BalInvprintInfoEntity balInvprintInfo = new BalInvprintInfoEntity();
				balInvprintInfo.setPrintSn(printSn);
				balInvprintInfo.setPrintArray(1);
				balInvprintInfo.setPhoneNo(baseInvoiceDisp.getPhoneNo());
				balInvprintInfo.setCustId(baseInvoiceDisp.getCustId());
				balInvprintInfo.setIdNo(baseInvoiceDisp.getIdNo());
				balInvprintInfo.setContractNo(baseInvoiceDisp.getContractNo());
				// balInvprintInfo.setRelContractNo(baseInvoiceDisp.getContractNo());
				balInvprintInfo.setInvType(invType);
				balInvprintInfo.setState(CommonConst.NORMAL_STATUS);// 1:打印正常发票
				balInvprintInfo.setLoginNo(baseInvoiceDisp.getLoginNo());
				balInvprintInfo.setGroupId(inParam.get("GROUP_ID").toString());
				balInvprintInfo.setOpCode(baseInvoiceDisp.getOpCode());
				balInvprintInfo.setTotalDate(DateUtils.getCurDay());
				balInvprintInfo.setInvCode(invCode);
				balInvprintInfo.setInvNo(invNo);
				balInvprintInfo.setPaySn(ValueUtils.longValue(inParam.get("PAY_SN").toString()));
				balInvprintInfo.setTotalFee(preInvoiceDisp.getPrintFee());
				balInvprintInfo.setPrintFee(preInvoiceDisp.getPrintFee());
				balInvprintInfo.setTaxFee(0l);
				balInvprintInfo.setTaxRate(0d);
				balInvprintInfo.setPrintNum(1);
				balInvprintInfo.setRemark("预存发票打印");
				balInvprintInfo.setBeginYmd(preInvoiceDisp.getPayDate() + "");
				balInvprintInfo.setEndYmd(preInvoiceDisp.getPayDate() + "");
				balInvprintInfo.setBillCycle(preInvoiceDisp.getBillCycle());
				balInvprintInfo.setPrintSeq(ValueUtils.intValue(inParam.get("PRINT_SEQ").toString()));

				log.debug(">>>>>>>>>>>>" + eleInvoiceInfo + ">>>>>>>" + eleInvoiceInfo.getInvoiceHeader());
				if (eleInvoiceInfo != null && StringUtils.isNotEmptyOrNull(eleInvoiceInfo.getInvoiceHeader())) {
					balInvprintInfo.setRequestSn(eleInvoiceInfo.getInvoiceHeader().getFpqqlsh());
					if (StringUtils.isNotEmptyOrNull(inParam.get("CHN_SOURCE"))) {
						balInvprintInfo.setChnSource(inParam.get("CHN_SOURCE").toString());
					}
				}

				List<BalInvprintInfoEntity> balInvprintInfoList = new ArrayList<BalInvprintInfoEntity>();
				balInvprintInfoList.add(balInvprintInfo);
				invoice.iBalInvprintInfo(balInvprintInfoList);

				// 入发票明细记录表
				// 获取预存发票展示项
				List<BalInvprintdetInfo> balInvprintDetInfoList = new ArrayList<BalInvprintdetInfo>();
				long codeClass = 1100;
				List<PubCodeDictEntity> pubcodeList = control.getPubCodeList(codeClass, "", "", "");
				for (int i = 0; i < pubcodeList.size(); i++) {
					BalInvprintdetInfo balInvprintdetInfo = new BalInvprintdetInfo();
					balInvprintdetInfo.setPrintSn(printSn);
					balInvprintdetInfo.setPhoneNo(baseInvoiceDisp.getPhoneNo());
					balInvprintdetInfo.setIdNo(baseInvoiceDisp.getIdNo());
					balInvprintdetInfo.setContractNo(baseInvoiceDisp.getContractNo());
					long orderSn = control.getSequence("SEQ_ORDER_ID");
					balInvprintdetInfo.setOrderSn(orderSn);
					balInvprintdetInfo.setInvCode(invCode);
					balInvprintdetInfo.setInvNo(invNo);
					balInvprintdetInfo.setShowOrder(Integer.parseInt(pubcodeList.get(i).getCodeId()));
					balInvprintdetInfo.setShowName(pubcodeList.get(i).getCodeName());
					balInvprintdetInfo.setYearMonth(preInvoiceDisp.getBillCycle() + "");
					balInvprintdetInfo.setAmount(1);
					balInvprintdetInfo.setPrintData(printXml.getBytes());
					balInvprintdetInfo.setPrintArray(1);
					if (balInvprintdetInfo.getShowOrder() >= 7 && userFlag == CommonConst.NO_NET
							|| ((balInvprintdetInfo.getShowOrder() == 5 || balInvprintdetInfo.getShowOrder() == 1) && userFlag == CommonConst.IN_NET)) {
						continue;
					}
					log.debug("test show show_order:" + balInvprintdetInfo.getShowOrder());
					switch (balInvprintdetInfo.getShowOrder()) {
					case 6:
						balInvprintdetInfo.setUnitePrice(preInvoiceDisp.getPrintFee());
						balInvprintdetInfo.setTotalFee(preInvoiceDisp.getPrintFee());
						balInvprintdetInfo.setPrintData(printXml.getBytes());
						break;
					case 2:
						balInvprintdetInfo.setUnitePrice(preInvoiceDisp.getCashMoney());
						balInvprintdetInfo.setTotalFee(preInvoiceDisp.getCashMoney());
						break;
					case 3:
						balInvprintdetInfo.setUnitePrice(preInvoiceDisp.getCheckMoney());
						balInvprintdetInfo.setTotalFee(preInvoiceDisp.getCheckMoney());
						break;
					case 4:
						balInvprintdetInfo.setUnitePrice(preInvoiceDisp.getPosMoney());
						balInvprintdetInfo.setTotalFee(preInvoiceDisp.getPosMoney());
						break;
					case 5:
						if (preInvoiceDisp.getOpCode().equals("8006")) {
							balInvprintdetInfo.setUnitePrice(preInvoiceDisp.getBillFee());
							balInvprintdetInfo.setTotalFee(preInvoiceDisp.getBillFee());
						}
						break;
					case 1:
						if (preInvoiceDisp.getOpCode().toString().equals("8006")) {
							balInvprintdetInfo.setUnitePrice(preInvoiceDisp.getDelayFee());
							balInvprintdetInfo.setTotalFee(preInvoiceDisp.getDelayFee());
						}
						break;
					case 7:
						balInvprintdetInfo.setUnitePrice(preInvoiceDisp.getBalanceFee());
						balInvprintdetInfo.setTotalFee(preInvoiceDisp.getBalanceFee());
						break;
					case 8:
						balInvprintdetInfo.setUnitePrice(preInvoiceDisp.getUnbillFee());
						balInvprintdetInfo.setTotalFee(preInvoiceDisp.getUnbillFee());
						break;
					case 9:
						balInvprintdetInfo.setUnitePrice(preInvoiceDisp.getRemainFee());
						balInvprintdetInfo.setTotalFee(preInvoiceDisp.getRemainFee());
						break;
					}

					balInvprintDetInfoList.add(balInvprintdetInfo);
				}

				invoice.iBalInvprintdetInfo(balInvprintDetInfoList);
				// 将xml保存起来
				invoice.insDetXml(printSn, preInvoiceDisp.getBillCycle(), printXml);
			}
		}

		InvNoOccupyEntity invNoOccupy = new InvNoOccupyEntity();
		invNoOccupy.setFee(preInvoiceDisp.getPrintFee());
		if (StringUtils.isNotEmptyOrNull(inParam.get("INV_NO"))) {
			invNoOccupy.setInvNo(inParam.get("INV_NO").toString());
		}
		if (StringUtils.isNotEmptyOrNull(inParam.get("INV_CODE"))) {
			invNoOccupy.setInvCode(inParam.get("INV_CODE").toString());
		}

		invNoOccupy.setXmlStr(printXml);
		Map<String, Object> outMap = new HashMap<String, Object>();
		outMap.put("INV_NO_OCCUPY", invNoOccupy);
		outMap.put("BASE_INV_DISP", baseInvoiceDisp);
		outMap.put("PRE_INV_DISP", preInvoiceDisp);
		return outMap;
	}

	/**
	 * 获取发票报文，由于黑龙江由于某种限制各自的发票报文不同
	 * 
	 * @param invoiceDisp
	 * @return
	 */
	private String getXmlStr(InvoiceDispEntity invoiceDisp, int userFlag, String printFlag) {
		// 获取发票的报文
		String userType = "0";
		// 判断是否为物联网号码
		boolean iswlw = false;
		if (StringUtils.isNotEmptyOrNull(invoiceDisp.getBaseInvoice().getPhoneNo())) {
			iswlw = user.isInternetOfThingsPhone(invoiceDisp.getBaseInvoice().getPhoneNo());
		}
		// 判断是否为集团账号
		boolean isGrpCon = account.isGrpCon(invoiceDisp.getBaseInvoice().getContractNo());

		// 物联网发票print_type=20n
		if (iswlw) {
			userType = CommonConst.USERTYPE_WLW;
		}

		String brandId = invoiceDisp.getBaseInvoice().getBrandId();
		// 判断是否为宽带用户，kf,kg,ki发票模板号为print_type=200
		if (brandId.equals("2330kf") || brandId.equals("2330ki") || brandId.equals("2330kg") || brandId.equals("2330kh")) {
			userType = CommonConst.USERTYPE_BROADBAND;
		}

		// 除了kf,kg,ki类的为另一类发票，发票模板不同print_type=201
		if (brandId.equals("2330ke") || brandId.equals("2330kd")) {
			userType = CommonConst.USERTYPE_TTBROAD;
		}

		// 集团发票 print_type=21n
		if (isGrpCon && userType != CommonConst.USERTYPE_TTBROAD) {
			userType = CommonConst.USERTYPE_GRP;
		}
		log.debug("发票上展示的基本信息：" + invoiceDisp.getBaseInvoice());
		// 物联网缴费跟普通缴费的发票展示内容不同，分开，设置print_type=20n
		if (userType.equals(CommonConst.USERTYPE_WLW)) {
			if (StringUtils.isNotEmptyOrNull(printFlag) && printFlag.equals("1")) {
				invoiceDisp.getBaseInvoice().setOpName("补打物联网缴费");
			} else {
				invoiceDisp.getBaseInvoice().setOpName("物联网缴费");
			}
		}
		if (userType.equals(CommonConst.USERTYPE_BROADBAND) || userType.equals(CommonConst.USERTYPE_TTBROAD)) {
			if (StringUtils.isNotEmptyOrNull(printFlag) && printFlag.equals("1")) {
				invoiceDisp.getBaseInvoice().setOpName("补打宽带缴费");
			} else {
				invoiceDisp.getBaseInvoice().setOpName("宽带缴费");
			}
		}
		if (userType.equals(CommonConst.USERTYPE_GRP) && !invoiceDisp.getBaseInvoice().getOpCode().equals("8074")) {
			invoiceDisp.getBaseInvoice().setOpName("集团缴费");
		}
		String printXml = printDataXML.getPrintXml(invoiceDisp, userFlag, userType);
		return printXml;
	}

	@Override
	public List<InvNoOccupyEntity> printMonthInvoice(Map<String, Object> inParam) {
		// 获取发票基本信息
		List<InvBillCycleEntity> billCycleList = (List<InvBillCycleEntity>) inParam.get("INV_BILLCYCLE_LIST");
		String chnSource = "";
		String requestSn = "";
		if (StringUtils.isNotEmptyOrNull(inParam.get("CHN_SOURCE"))) {
			chnSource = inParam.get("CHN_SOURCE").toString();
		}
		boolean isPrintXml = true;
		if (StringUtils.isNotEmptyOrNull(inParam.get("IS_PRINT_XML"))) {
			isPrintXml = Boolean.valueOf(inParam.get("IS_PRINT_XML").toString());
		}
		String invType = CommonConst.XFFP_TYPE;
		if (StringUtils.isNotEmptyOrNull(inParam.get("INV_TYPE"))) {
			invType = (String) inParam.get("INV_TYPE");
		}
		int printFlag = ValueUtils.intValue(inParam.get("IS_PRINT"));
		int userFlag = CommonConst.IN_NET;
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("LOGIN_NO", inParam.get("LOGIN_NO"));
		inMap.put("PHONE_NO", inParam.get("PHONE_NO"));
		inMap.put("CONTRACT_NO", inParam.get("CONTRACT_NO"));
		inMap.put("USER_FLAG", userFlag);
		inMap.put("OP_CODE", inParam.get("OP_CODE"));
		inMap.put("LOGIN_NO", inParam.get("LOGIN_NO"));
		inMap.put("GROUP_ID", inParam.get("GROUP_ID"));
		inMap.put("PROVICE_ID", inParam.get("PROVICE_ID"));
		// inMap.put("BILL_CYCLE", inParam.get("BILL_CYCLE"));
		inMap.put("PRINT_TYPE", "1");
		inMap.put("INV_BILLCYCLE_LIST", inParam.get("INV_BILLCYCLE_LIST"));
		if (inParam.get("MEAL_LIST") != null) {
			inMap.put("MEAL_LIST", inParam.get("MEAL_LIST"));
		}

		// inMap.put("INV_NO", inParam.get("INV_NO"));
		// inMap.put("INV_CODE", inParam.get("INV_CODE"));
		boolean isCombine = Boolean.parseBoolean(inParam.get("IS_COMBINE").toString());

		BaseInvoiceDispEntity baseInvDisp = preInvHeader.queryBaseInvInfo(inMap);

		List<Map<String, Object>> monthInvDispList = new ArrayList<Map<String, Object>>();
		List<InvNoOccupyEntity> invNoOccupyList = new ArrayList<InvNoOccupyEntity>();

		long codeClass = 1101;
		List<PubCodeDictEntity> pubcodeList = control.getPubCodeList(codeClass, "", "", "");
		long printSn = ValueUtils.longValue(inParam.get("PRINT_SN"));
		Map<String, Object> combineMap = new HashMap<String, Object>();
		List<BalInvprintInfoEntity> balInvprintInfoList = new ArrayList<BalInvprintInfoEntity>();
		List<BalInvprintdetInfo> balInvprintDetInfoList = new ArrayList<BalInvprintdetInfo>();
		int printArray = 0;
		// 获取计费周期
		Map<String, Object> billCycleMap = invoice.getPrintBillCycle(billCycleList);
		int beginBillCycle = ValueUtils.intValue(billCycleMap.get("BEGIN_BILL_CYCLE"));
		int endBillCycle = ValueUtils.intValue(billCycleMap.get("END_BILL_CYCLE"));
		/** 黑龙江无合打，所以暂时注释 */
		// long communiteFee = 0;
		// long cardPrintedFee = 0;
		// long otherPrintedFee = 0;
		// long mealFee = 0;
		// long prePrintedFee = 0;
		// long discountFee = 0;
		// long totalFee = 0;
		// long printedFee = 0;
		// long printFee = 0;
		// long syspayPrintedFee = 0;
		for (InvBillCycleEntity invCycle : billCycleList) {
			String invNo = invCycle.getInvNo();
			String invCode = "";
			if (StringUtils.isNotEmpty(invCycle.getInvCode())) {
				invCode = invCycle.getInvCode();
			}

			int billCycle = invCycle.getBillCycle();
			inMap.put("INV_NO", invNo);
			inMap.put("INV_CODE", invCode);
			inMap.put("BILL_CYCLE", billCycle);
			baseInvDisp.setInvNo(invNo);
			Map<String, Object> feeMap = invFee.getMonthInvoiceFee(inMap);
			MonthInvoiceDispEntity monthInvDisp = (MonthInvoiceDispEntity) feeMap.get("MONTH_INVOICE_DISP");
			monthInvDispList.add(feeMap);
			InvoiceInfo eleInvoiceInfo = new InvoiceInfo();
			if (invType.equals(CommonConst.ELE_MONTH_TYPE)) {
				// 打印电子发票
				String loginNo = baseInvDisp.getLoginNo();
				// 查询工号所在地市
				String regionCode = login.getRegionCode(loginNo, "230000");
				// 获取销货方信息
				InvoiceXhfInfo xhfInfo = invoice.getInvoicexhfInfo(regionCode);
				// 获取发票头信息
				InvoiceHeaderInfo headerInfo = eleInvoice.getEleInvHeader(xhfInfo, baseInvDisp.getOpCode(), baseInvDisp.getCustName(),
						baseInvDisp.getPhoneNo(), baseInvDisp.getLoginName(), baseInvDisp.getLoginAccept() + "", monthInvDisp.getPrintFee());
				requestSn = headerInfo.getFpqqlsh();
				// 获取费用行信息
				List<InvoiceDetailInfo> xmInfoList = new ArrayList<InvoiceDetailInfo>();

				xmInfoList = getMonthXmList(monthInvDisp);
				// 获取订单行信息
				InvoiceDdInfo orderInfo = eleInvoice.getOrderInfo(baseInvDisp.getLoginAccept() + "");
				eleInvoiceInfo.setInvoiceDd(orderInfo);
				eleInvoiceInfo.setInvoiceDetail(xmInfoList);
				eleInvoiceInfo.setInvoiceHeader(headerInfo);
				Map<String, String> retMap = eleInvoice.EInvPrintSub(eleInvoiceInfo, xhfInfo, loginNo, 0, chnSource);
				String returnCode = retMap.get("RETURN_CODE");
				String returnMsg = retMap.get("RETURN_MSG");
				invNo = retMap.get("INV_NO");
				invCode = retMap.get("INV_CODE");
				if (StringUtils.isEmptyOrNull(returnCode) || (StringUtils.isNotEmptyOrNull(returnCode) && !returnCode.equals("0000"))) {
					throw new BusiException(AcctMgrError.getErrorCode("8005", "00000"), StringUtils.isEmptyOrNull(returnMsg) ? "参数返回错误" : returnMsg);
				}
				// 记录电子发票的明细表
				int printArrayDetail = 0;
				for (InvoiceDetailInfo xmInfo : xmInfoList) {
					TaxInvoiceFeeEntity taxInvoiceFee = new TaxInvoiceFeeEntity();
					taxInvoiceFee.setGoodsName(xmInfo.getXmmc());
					taxInvoiceFee.setPrintSn(printSn);
					taxInvoiceFee.setGoodsNum("1");
					taxInvoiceFee.setGoodsPrice(ValueUtils.transYuanToFen(xmInfo.getXmje()) + "");
					taxInvoiceFee.setInvoiceFee(ValueUtils.transYuanToFen(xmInfo.getXmje()) + "");
					taxInvoiceFee.setTaxFee("0");
					taxInvoiceFee.setTaxRate("0");
					taxInvoiceFee.setPrintArray(printArrayDetail);
					taxInvoiceFee.setRequestSn(headerInfo.getFpqqlsh());
					invoice.insertTaxPrint(taxInvoiceFee);
				}
			}


			baseInvDisp.setLoginAccept(printSn);
			// 类转换成map，拼发票的xmlstr
			inMap = new HashMap<String, Object>();
			Map<String, Object> baseMap = BeanToMapUtils.beanToMap(baseInvDisp);
			Map<String, Object> monthMap = BeanToMapUtils.beanToMap(monthInvDisp);
			inMap.putAll(baseMap);
			inMap.putAll(monthMap);
			log.debug(">>>>>>>>>>>" + inMap);

			for (PubCodeDictEntity pubCode : pubcodeList) {
				inMap.put(pubCode.getCodeValue(), pubCode.getCodeName());
			}

			/** 黑龙江无合打，所以暂时注释 */
			// if (isCombine) {
			// printArray = 1;
			// log.debug("合打的inMap：" + inMap);
			// combineMap.putAll(inMap);
			// communiteFee += ValueUtils.longValue(inMap.get("COMMUNITE_FEE"));
			// cardPrintedFee += ValueUtils.longValue(inMap.get("CARD_PRINTED_FEE"));
			// otherPrintedFee += ValueUtils.longValue(inMap.get("OTHER_PRINT_FEE"));
			// mealFee += ValueUtils.longValue(inMap.get("MEAL_FEE"));
			// prePrintedFee += ValueUtils.longValue(inMap.get("PRE_PRINTED_FEE"));
			// discountFee += ValueUtils.longValue(inMap.get("DISCOUNT_FEE"));
			// totalFee += ValueUtils.longValue(inMap.get("TOTAL_FEE"));
			// printFee += ValueUtils.longValue(inMap.get("PRINT_FEE"));
			// printedFee += ValueUtils.longValue(inMap.get("PRINTED_FEE"));
			// syspayPrintedFee += ValueUtils.longValue(inMap.get("SYS__PAY__PRINTED_FEE"));
			// combineMap.put("COMMUNITE_FEE", communiteFee);
			// combineMap.put("CARD_PRINTED_FEE", cardPrintedFee);
			// combineMap.put("OTHER_PRINT_FEE", otherPrintedFee);
			// combineMap.put("PRE_PRINTED_FEE", prePrintedFee);
			// combineMap.put("DISCOUNT_FEE", discountFee);
			// combineMap.put("TOTAL_FEE", totalFee);
			// combineMap.put("PRINT_FEE", printFee);
			// combineMap.put("PRINTED_FEE", printedFee);
			// combineMap.put("SYS__PAY__PRINTED_FEE", syspayPrintedFee);
			// combineMap.put("MEAL_FEE", mealFee);
			// combineMap.put("INV_NO", invNo);
			// combineMap.put("INV_CODE", invCode);
			//
			// } else {
			printArray++;
			inMap.put("COMMUNITE_FEE", ValueUtils.transFenToYuan(inMap.get("COMMUNITE_FEE")));
			inMap.put("CARD_PRINTED_FEE", ValueUtils.transFenToYuan(inMap.get("CARD_PRINTED_FEE")));
			inMap.put("OTHER_PRINT_FEE", ValueUtils.transFenToYuan(inMap.get("OTHER_PRINT_FEE")));
			inMap.put("MEAL_FEE", ValueUtils.transFenToYuan(inMap.get("MEAL_FEE")));
			inMap.put("PRE_PRINTED_FEE", ValueUtils.transFenToYuan(inMap.get("PRE_PRINTED_FEE")));
			inMap.put("DISCOUNT_FEE", ValueUtils.transFenToYuan(inMap.get("DISCOUNT_FEE")));
			inMap.put("TOTAL_FEE", ValueUtils.transFenToYuan(inMap.get("TOTAL_FEE")));
			inMap.put("PRINT_FEE", ValueUtils.transFenToYuan(inMap.get("PRINT_FEE")));
			inMap.put("PRINTED_FEE", ValueUtils.transFenToYuan(inMap.get("PRINTED_FEE")));
			inMap.put("SYS__PAY__PRINTED_FEE", ValueUtils.transFenToYuan(inMap.get("SYS__PAY__PRINTED_FEE")));
			inMap.put("INV_NO", invNo);
			inMap.put("BIG_MONEY", ValueUtils.transYuanToChnaBig(inMap.get("PRINT_FEE")));
			// 生成xmlstr
			log.debug("生成报文的参数：" + inMap);
			inMap.put("PRINT_TYPE", "1nn");
			// inMap.put("OP_CODE", inParam.get("OP_CODE"));
			String xmlStr = "";
			if (isPrintXml || !invType.equals(CommonConst.ELE_MONTH_TYPE)) {
				xmlStr = printDataXML.getPrintXml(inMap);
				InvNoOccupyEntity invNoOccupy = new InvNoOccupyEntity();
				invNoOccupy.setXmlStr(xmlStr);
				invNoOccupy.setInvCode(invCode);
				invNoOccupy.setInvNo(invNo);
				invNoOccupy.setFee(ValueUtils.transYuanToFen(inMap.get("PRINT_FEE")));
				invNoOccupyList.add(invNoOccupy);
			}

			// 记录发票记录明细表
			for (PubCodeDictEntity pubcode : pubcodeList) {
				BalInvprintdetInfo balInvprintdetInfo = new BalInvprintdetInfo();
				balInvprintdetInfo.setPrintSn(printSn);
				balInvprintdetInfo.setPhoneNo(baseInvDisp.getPhoneNo());
				balInvprintdetInfo.setIdNo(baseInvDisp.getIdNo());
				balInvprintdetInfo.setContractNo(baseInvDisp.getContractNo());
				long orderSn = control.getSequence("SEQ_ORDER_ID");
				balInvprintdetInfo.setOrderSn(orderSn);
				balInvprintdetInfo.setInvCode(invCode);
				balInvprintdetInfo.setInvNo(invNo);
				balInvprintdetInfo.setShowOrder(Integer.parseInt(pubcode.getCodeId()));
				balInvprintdetInfo.setShowName(pubcode.getCodeName());
				balInvprintdetInfo.setYearMonth(monthInvDisp.getBillCycle() + "");
				balInvprintdetInfo.setAmount(1);
				if (Integer.parseInt(pubcode.getCodeId()) == 17) {
					balInvprintdetInfo.setPrintData(xmlStr.getBytes());
				}
				balInvprintdetInfo.setPrintArray(printArray);
				if (Integer.parseInt(pubcode.getCodeId()) == 6) {

				}

				log.debug("test show show_order:" + balInvprintdetInfo.getShowOrder());
				switch (balInvprintdetInfo.getShowOrder()) {
				case 10:
					balInvprintdetInfo.setUnitePrice(monthInvDisp.getCommuniteFee());
					balInvprintdetInfo.setTotalFee(monthInvDisp.getCommuniteFee());
					break;
				case 11:
					balInvprintdetInfo.setUnitePrice(monthInvDisp.getDiscountFee());
					balInvprintdetInfo.setTotalFee(monthInvDisp.getDiscountFee());
					break;
				case 12:
					balInvprintdetInfo.setUnitePrice(monthInvDisp.getTotalFee());
					balInvprintdetInfo.setTotalFee(monthInvDisp.getTotalFee());
					break;
				case 13:
					balInvprintdetInfo.setUnitePrice(monthInvDisp.getPrintedFee());
					balInvprintdetInfo.setTotalFee(monthInvDisp.getPrintedFee());
					break;
				case 14:
					balInvprintdetInfo.setUnitePrice(monthInvDisp.getPrePrintedFee());
					balInvprintdetInfo.setTotalFee(monthInvDisp.getPrePrintedFee());
					break;
				case 15:
					balInvprintdetInfo.setUnitePrice(monthInvDisp.getCardPrintedFee());
					balInvprintdetInfo.setTotalFee(monthInvDisp.getCardPrintedFee());
					break;
				case 16:
					balInvprintdetInfo.setUnitePrice(monthInvDisp.getSysPayPrintedFee());
					balInvprintdetInfo.setTotalFee(monthInvDisp.getSysPayPrintedFee());
					break;
				case 6:
					balInvprintdetInfo.setUnitePrice(monthInvDisp.getPrintFee());
					balInvprintdetInfo.setTotalFee(monthInvDisp.getPrintFee());
					break;
				case 19:
					balInvprintdetInfo.setUnitePrice(monthInvDisp.getMealFee());
					balInvprintdetInfo.setTotalFee(monthInvDisp.getMealFee());
					break;
				case 20:
					balInvprintdetInfo.setUnitePrice(monthInvDisp.getOtherPrintFee());
					balInvprintdetInfo.setTotalFee(monthInvDisp.getOtherPrintFee());
					break;
				}

				balInvprintDetInfoList.add(balInvprintdetInfo);
			}
			// }
			if (printFlag == 0) {
				// 更新冲销表中的记录
				invoice.updatePrintFlagByMonth(invCycle.getBillCycle(), ValueUtils.longValue(inParam.get("CONTRACT_NO")), printSn);
				// 记录发票记录总表
				BalInvprintInfoEntity balInvprintInfo = new BalInvprintInfoEntity();
				balInvprintInfo.setPrintSn(printSn);
				balInvprintInfo.setPrintArray(printArray);
				balInvprintInfo.setPhoneNo(baseInvDisp.getPhoneNo());
				balInvprintInfo.setCustId(baseInvDisp.getCustId());
				balInvprintInfo.setIdNo(baseInvDisp.getIdNo());
				balInvprintInfo.setContractNo(baseInvDisp.getContractNo());
				// balInvprintInfo.setRelContractNo(baseInvDisp.getContractNo());
				balInvprintInfo.setInvType(invType);
				balInvprintInfo.setState(CommonConst.NORMAL_STATUS);// 1:打印正常发票
				balInvprintInfo.setLoginNo(baseInvDisp.getLoginNo());
				balInvprintInfo.setGroupId(inParam.get("GROUP_ID").toString());
				if (StringUtils.isNotEmptyOrNull(inParam.get("OP_CODE"))) {
					balInvprintInfo.setOpCode(inParam.get("OP_CODE").toString());
				}

				balInvprintInfo.setTotalDate(DateUtils.getCurDay());
				balInvprintInfo.setInvCode(invCode);
				balInvprintInfo.setInvNo(invNo);
				balInvprintInfo.setTotalFee(monthInvDisp.getPrintFee());
				balInvprintInfo.setPrintFee(monthInvDisp.getPrintFee());
				balInvprintInfo.setTaxFee(0l);
				balInvprintInfo.setTaxRate(0d);
				balInvprintInfo.setPrintNum(1);
				balInvprintInfo.setRemark("月结发票打印");
				balInvprintInfo.setBeginYmd(beginBillCycle + "01");
				balInvprintInfo.setEndYmd("" + DateUtils.getLastDayOfMonth(endBillCycle));
				balInvprintInfo.setBillCycle(monthInvDisp.getBillCycle());
				balInvprintInfo.setPrintSeq(ValueUtils.intValue(inParam.get("PRINT_SEQ").toString()));
				balInvprintInfo.setRequestSn(requestSn);
				balInvprintInfo.setChnSource(chnSource);
				balInvprintInfoList.add(balInvprintInfo);
				
			}
			invoice.iBalInvprintInfo(balInvprintInfoList);
		}

		/** 黑龙江无合打，所以暂时注释 */
		// if (isCombine) {
		// combineMap.put("COMMUNITE_FEE", ValueUtils.transFenToYuan(combineMap.get("COMMUNITE_FEE")));
		// combineMap.put("CARD_PRINTED_FEE", ValueUtils.transFenToYuan(combineMap.get("CARD_PRINTED_FEE")));
		// combineMap.put("OTHER_PRINT_FEE", ValueUtils.transFenToYuan(combineMap.get("OTHER_PRINT_FEE")));
		// combineMap.put("MEAL_FEE", ValueUtils.transFenToYuan(combineMap.get("MEAL_FEE")));
		// combineMap.put("PRE_PRINTED_FEE", ValueUtils.transFenToYuan(combineMap.get("PRE_PRINTED_FEE")));
		// combineMap.put("DISCOUNT_FEE", ValueUtils.transFenToYuan(combineMap.get("DISCOUNT_FEE")));
		// combineMap.put("TOTAL_FEE", ValueUtils.transFenToYuan(combineMap.get("TOTAL_FEE")));
		// combineMap.put("PRINT_FEE", ValueUtils.transFenToYuan(combineMap.get("PRINT_FEE")));
		// combineMap.put("PRINTED_FEE", ValueUtils.transFenToYuan(combineMap.get("PRINTED_FEE")));
		// combineMap.put("SYS__PAY__PRINTED_FEE", ValueUtils.transFenToYuan(combineMap.get("SYS__PAY__PRINTED_FEE")));
		// combineMap.put("INV_NO", billCycleList.get(0).getInvNo());
		// combineMap.put("BIG_MONEY", ValueUtils.transYuanToChnaBig(combineMap.get("PRINT_FEE")));
		// combineMap.put("PRINT_TYPE", "1nn");
		// log.debug("合打发票打印的入参报文：" + combineMap);
		// String xmlStr = "";
		// if (isPrintXml) {
		// xmlStr = printDataXML.getPrintXml(combineMap);
		// InvNoOccupyEntity invNoOccupy = new InvNoOccupyEntity();
		// invNoOccupy.setXmlStr(xmlStr);
		// if (StringUtils.isNotEmptyOrNull(combineMap.get("INV_CODE"))) {
		// invNoOccupy.setInvCode(combineMap.get("INV_CODE").toString());
		// }
		// if (StringUtils.isNotEmptyOrNull(combineMap.get("INV_NO"))) {
		// invNoOccupy.setInvNo(combineMap.get("INV_NO").toString());
		// }
		// invNoOccupy.setFee(ValueUtils.transYuanToFen(combineMap.get("PRINT_FEE")));
		// invNoOccupyList.add(invNoOccupy);
		// }
		// if (printFlag == 0) {
		// // 记录发票记录明细表
		// for (PubCodeDictEntity pubcode : pubcodeList) {
		// BalInvprintdetInfo balInvprintdetInfo = new BalInvprintdetInfo();
		// balInvprintdetInfo.setPrintSn(printSn);
		// balInvprintdetInfo.setPhoneNo(baseInvDisp.getPhoneNo());
		// balInvprintdetInfo.setIdNo(baseInvDisp.getIdNo());
		// balInvprintdetInfo.setContractNo(baseInvDisp.getContractNo());
		// long orderSn = control.getSequence("SEQ_ORDER_ID");
		// balInvprintdetInfo.setOrderSn(orderSn);
		// balInvprintdetInfo.setInvCode(combineMap.get("INV_CODE").toString());
		// balInvprintdetInfo.setInvNo(combineMap.get("INV_NO").toString());
		// balInvprintdetInfo.setShowOrder(Integer.parseInt(pubcode.getCodeId()));
		// balInvprintdetInfo.setShowName(pubcode.getCodeName());
		// balInvprintdetInfo.setYearMonth(DateUtils.getCurYm() + "");
		// balInvprintdetInfo.setAmount(1);
		// if (Integer.parseInt(pubcode.getCodeId()) == 17) {
		// balInvprintdetInfo.setPrintData(xmlStr.getBytes());
		// }
		//
		// balInvprintdetInfo.setPrintArray(printArray);
		// log.debug("test show show_order:" + balInvprintdetInfo.getShowOrder());
		// switch (balInvprintdetInfo.getShowOrder()) {
		// case 10:
		// balInvprintdetInfo.setUnitePrice(communiteFee);
		// balInvprintdetInfo.setTotalFee(communiteFee);
		// break;
		// case 11:
		// balInvprintdetInfo.setUnitePrice(discountFee);
		// balInvprintdetInfo.setTotalFee(discountFee);
		// break;
		// case 12:
		// balInvprintdetInfo.setUnitePrice(totalFee);
		// balInvprintdetInfo.setTotalFee(totalFee);
		// break;
		// case 13:
		// balInvprintdetInfo.setUnitePrice(printedFee);
		// balInvprintdetInfo.setTotalFee(printedFee);
		// break;
		// case 14:
		// balInvprintdetInfo.setUnitePrice(prePrintedFee);
		// balInvprintdetInfo.setTotalFee(prePrintedFee);
		// break;
		// case 15:
		// balInvprintdetInfo.setUnitePrice(cardPrintedFee);
		// balInvprintdetInfo.setTotalFee(cardPrintedFee);
		// break;
		// case 16:
		// balInvprintdetInfo.setUnitePrice(syspayPrintedFee);
		// balInvprintdetInfo.setTotalFee(syspayPrintedFee);
		// break;
		// case 17:
		// balInvprintdetInfo.setUnitePrice(printFee);
		// balInvprintdetInfo.setTotalFee(printFee);
		// break;
		// case 19:
		// balInvprintdetInfo.setUnitePrice(mealFee);
		// balInvprintdetInfo.setTotalFee(mealFee);
		// break;
		// case 20:
		// balInvprintdetInfo.setUnitePrice(otherPrintedFee);
		// balInvprintdetInfo.setTotalFee(otherPrintedFee);
		// break;
		// }
		//
		// balInvprintDetInfoList.add(balInvprintdetInfo);
		// }
		// inMap = new HashMap<String, Object>();
		// inMap.put("PRINT_FEE", printFee);
		// inMap.put("PRINT_SN", printSn);
		// // 更新发票记录总表中的print_fee
		// log.debug("更新发票记录总表中的记录" + inMap);
		// invoice.updataInvprint(inMap);
		//
		// }
		//
		// // 更新冲销表中的print_flag，更新成1
		// // List<Long> billIdList = (List<Long>) feeMap.get("BILL_ID_LIST");
		//
		// // 记录发票记录明细表
		// log.debug("balinvprintdeinfoList:" + balInvprintDetInfoList);
		// invoice.iBalInvprintdetInfo(balInvprintDetInfoList);
		// invoice.insDetXml(printSn, Integer.parseInt(balInvprintDetInfoList.get(0).getYearMonth()), invNoOccupyList.get(0).getXmlStr());
		// }

		return invNoOccupyList;
	}

	private List<InvoiceDetailInfo> getMonthXmList(MonthInvoiceDispEntity monthDisp) {
		List<InvoiceDetailInfo> xmList = new ArrayList<InvoiceDetailInfo>();
		long communiteFee = monthDisp.getCommuniteFee();
		long cardPrintedFee = monthDisp.getCardPrintedFee();
		long discountFee = monthDisp.getDiscountFee();
		long mealFee = monthDisp.getMealFee();
		long otherPrintFee = monthDisp.getOtherPrintFee();
		long prePrintedFee = monthDisp.getPrePrintedFee();
		long sysPrintedFee = monthDisp.getSysPayPrintedFee();
		long printFee = monthDisp.getPrintFee();
		if (communiteFee == printFee && mealFee == 0) {
			InvoiceDetailInfo xmInfo = new InvoiceDetailInfo();
			xmInfo = eleInvoice.getInvoiceItem(printFee, "月结发票打印", "0");
			xmList.add(xmInfo);
		}
		if (communiteFee == printFee && mealFee > 0) {
			InvoiceDetailInfo xmInfo1 = eleInvoice.getInvoiceItem(communiteFee, "通信服务费", "0");
			InvoiceDetailInfo xmInfo2 = eleInvoice.getInvoiceItem(mealFee, "合约套餐费", "0");
			xmList.add(xmInfo1);
			xmList.add(xmInfo2);
		}
		if(communiteFee!=printFee){
			InvoiceDetailInfo xmInfo1 = eleInvoice.getInvoiceItem(communiteFee, "服务通信费", "0");
			xmList.add(xmInfo1);
			if (cardPrintedFee > 0) {
				InvoiceDetailInfo xmInfo2 = eleInvoice.getInvoiceItem((-1) * cardPrintedFee, "充值卡已出具发票金额", "1");
				xmList.add(xmInfo2);
			}
			if (discountFee > 0) {
				InvoiceDetailInfo xmInfo3 = eleInvoice.getInvoiceItem((-1) * discountFee, "销售折扣", "1");
				xmList.add(xmInfo3);
			}
			if (mealFee > 0) {
				InvoiceDetailInfo xmInfo4 = eleInvoice.getInvoiceItem(mealFee, "合约套餐费", "0");
				xmList.add(xmInfo4);
			}
			if (otherPrintFee > 0) {
				InvoiceDetailInfo xmInfo5 = eleInvoice.getInvoiceItem((-1) * otherPrintFee, "已出具其他", "1");
				xmList.add(xmInfo5);
			}
			if (prePrintedFee > 0) {
				InvoiceDetailInfo xmInfo6 = eleInvoice.getInvoiceItem((-1) * prePrintedFee, "预存款已出具发票金额", "1");
				xmList.add(xmInfo6);
			}
			if (sysPrintedFee > 0) {
				InvoiceDetailInfo xmInfo7 = eleInvoice.getInvoiceItem((-1) * sysPrintedFee, "系统赠送", "1");
				xmList.add(xmInfo7);
			}
		}
		return xmList;
	}

	@Override
	public InvNoOccupyEntity printGrpInvoice(Map<String, Object> inParam) {
		Map<String, Object> inMap = new HashMap<String, Object>();

		// 获取打印流水
		long printSn = ValueUtils.longValue(inParam.get("PRINT_SN"));

		// 获取当前时间
		SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");// 设置日期格式
		String printDate = df.format(new Date());

		// 获取发票打印的基本信息
		inMap.put("INV_NO", inParam.get("INV_NO"));
		inMap.put("CUST_NAME", inParam.get("UNIT_NAME"));
		inMap.put("PRINT_ITEM", inParam.get("PRINT_ITEM"));
		inMap.put("LOGIN_NO", inParam.get("LOGIN_NO"));
		inMap.put("LOGIN_NAME", inParam.get("LOGIN_NAME"));
		inMap.put("GROUP_ID", inParam.get("GROUP_ID"));
		inMap.put("PROVICE_ID", inParam.get("PROVICE_ID"));
		inMap.put("UNIT_ID", inParam.get("UNIT_ID"));
		inMap.put("UNIT_NAME", inParam.get("UNIT_NAME"));
		inMap.put("PRINT_SN", printSn);
		inMap.put("PRINT_ITEM", inParam.get("PRINT_ITEM"));
		BaseInvoiceDispEntity baseInvoice = preInvHeader.queryBaseInvInfoOfGrp(inMap);

		// 发票打印金额
		PreInvoiceDispEntity preInvoiceDisp = new PreInvoiceDispEntity();
		preInvoiceDisp.setPrintFee(ValueUtils.longValue(inParam.get("PRINT_FEE")));
		preInvoiceDisp.setBillCycle(DateUtils.getCurYm());

		InvoiceDispEntity invoiceDisp = new InvoiceDispEntity();
		invoiceDisp.setBaseInvoice(baseInvoice);
		invoiceDisp.setPreInvoice(preInvoiceDisp);

		int beginYm = ValueUtils.intValue(inParam.get("BEGIN_YM"));
		int endYm = ValueUtils.intValue(inParam.get("END_YM"));
		int beginDate = ValueUtils.intValue(inParam.get("BEGIN_DATE"));
		int endDate = ValueUtils.intValue(inParam.get("END_DATE"));

		// 拼装报文
		inMap = new HashMap<String, Object>();

		log.debug("baseInvoice:" + baseInvoice);
		inMap = BeanToMapUtils.beanToMap(baseInvoice);
		inMap.put("PRINT_FEE", ValueUtils.transFenToYuan(ValueUtils.longValue(inParam.get("PRINT_FEE"))));
		inMap.put("BIG_MONEY", ValueUtils.transYuanToChnaBig(inMap.get("PRINT_FEE")));
		// inMap.put("BILL_CYCLE", DateUtils.getCurYm());
		inMap.put("PRINT_TYPE", "2nn");
		inMap.put("OP_CODE", inParam.get("OP_CODE"));
		log.debug("拼装报文入参：" + inMap);
		String xmlStr = printDataXML.getPrintXml(inMap);

		log.debug(xmlStr + ">>>>>>");

		inMap = new HashMap<String, Object>();
		inMap.put("BEGIN_DATE", beginDate);
		inMap.put("END_DATE", endDate);
		List<VirtualGrpEntity> virtualGrpList = (List<VirtualGrpEntity>) inParam.get("VIRTUALGRP_LIST");
		List<Long> paySnList = new ArrayList<Long>();
		for (VirtualGrpEntity virtualGrp : virtualGrpList) {
			paySnList.add(ValueUtils.longValue(virtualGrp.getPaySn()));
		}

		List<PayMentEntity> paymentList = new ArrayList<PayMentEntity>();
		for (int ym = beginYm; ym <= endYm; ym = DateUtils.addMonth(ym, 1)) {
			inMap.put("SUFFIX", ym);
			// 根据contract_no查询缴费记录
			inMap.put("PAY_SN_LIST", paySnList);
			inMap.put("SUFFIX", ym);
			log.debug("查询缴费记录的入参：" + inMap);
			List<PayMentEntity> paymentListTmp = record.getPayMentList(inMap);
			// 更新状态
			for (PayMentEntity payment : paymentListTmp) {
				// 判断是否打印过月结发票，如果打印过，报错
				Map<String, Object> printedMap = new HashMap<String, Object>();
				printedMap.put("SUFFIX", payment.getYearMonth());
				printedMap.put("PAY_SN", payment.getPaySn());
				int printed = invoice.isPrintMonthInvoice(printedMap);
				if (printed > 0) {
					throw new BusiException(AcctMgrError.getErrorCode("8241", "00003"), payment.getPaySn() + "缴费打印过月结发票，不能打印预存发票");
				}
				invoice.updatePrintFlagByPre(payment.getPaySn(), printSn, payment.getPayType(), payment.getYearMonth(), payment.getContractNo());
				// 入发票记录总表
				BalInvprintInfoEntity balInvprintInfo = new BalInvprintInfoEntity();
				balInvprintInfo.setPrintSn(printSn);
				balInvprintInfo.setPrintArray(1);
				balInvprintInfo.setPhoneNo(payment.getPhoneNo());
				balInvprintInfo.setCustId(0l);
				balInvprintInfo.setIdNo(payment.getIdNo());
				balInvprintInfo.setContractNo(payment.getContractNo());
				balInvprintInfo.setBillCycle(payment.getYearMonth());
				// balInvprintInfo.setRelContractNo(payment.getContractNo());
				balInvprintInfo.setInvType(CommonConst.YCFP_TYPE);
				balInvprintInfo.setState(CommonConst.NORMAL_STATUS);// 1:打印正常发票
				balInvprintInfo.setLoginNo(inParam.get("LOGIN_NO").toString());
				balInvprintInfo.setGroupId(inParam.get("GROUP_ID").toString());
				balInvprintInfo.setOpCode(inParam.get("OP_CODE").toString());
				balInvprintInfo.setTotalDate(DateUtils.getCurDay());
				balInvprintInfo.setInvCode(inParam.get("INV_CODE").toString());
				balInvprintInfo.setInvNo(inParam.get("INV_NO").toString());
				balInvprintInfo.setPaySn(payment.getPaySn());
				balInvprintInfo.setTotalFee(payment.getPayFee());
				balInvprintInfo.setPrintFee(ValueUtils.longValue(inParam.get("PRINT_FEE")));
				balInvprintInfo.setTaxFee(0l);
				balInvprintInfo.setTaxRate(0d);
				balInvprintInfo.setPrintNum(1);
				balInvprintInfo.setRemark("集团发票打印");
				balInvprintInfo.setPrintSeq(ValueUtils.intValue(inParam.get("PRINT_SEQ").toString()));

				List<BalInvprintInfoEntity> balInvprintInfoList = new ArrayList<BalInvprintInfoEntity>();
				balInvprintInfoList.add(balInvprintInfo);
				invoice.iBalInvprintInfo(balInvprintInfoList);

				// 报表需要查询账户的归属
				ContractInfoEntity contractInfo = account.getConInfo(ValueUtils.longValue(payment.getContractNo()));
				String userGroup = contractInfo.getGroupId();
				// 入集团发票打印接口表
				BalGrppreinvInfo balGrppreinvInfo = new BalGrppreinvInfo();
				balGrppreinvInfo.setGrpContractNo(payment.getContractNo());
				balGrppreinvInfo.setGrpPhoneNo(payment.getPhoneNo());
				balGrppreinvInfo.setInvFee(payment.getPayFee());
				balGrppreinvInfo.setInvNo(inParam.get("INV_NO").toString());
				balGrppreinvInfo.setItem(inParam.get("PRINT_ITEM").toString());
				balGrppreinvInfo.setLoginAccpet(printSn);
				balGrppreinvInfo.setLoginNo(inParam.get("LOGIN_NO").toString());
				balGrppreinvInfo.setState(CommonConst.JTFPDY_FLAG);
				balGrppreinvInfo.setUnitId(ValueUtils.longValue(inParam.get("UNIT_ID").toString()));
				balGrppreinvInfo.setUnitName(inParam.get("UNIT_NAME").toString());
				balGrppreinvInfo.setPaySn(payment.getPaySn());
				balGrppreinvInfo.setOpTime(printDate);
				balGrppreinvInfo.setOpCode(inParam.get("OP_CODE").toString());
				balGrppreinvInfo.setHeader((Map<String, Object>) inParam.get("Header"));
				balGrppreinvInfo.setUserGroupId(userGroup);
				balGrppreinvInfo.setPaySn(payment.getPaySn());
				invoice.iBalGrppreInvInfo(balGrppreinvInfo);

			}
			paymentList.addAll(paymentListTmp);
		}
		if (paymentList == null || paymentList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8241", "00002"), "缴费记录不存在");
		}
		// PayMentEntity payment = paymentList.get(0);
		// 记录发票明细表
		List<BalInvprintdetInfo> balInvprintDetInfoList = new ArrayList<BalInvprintdetInfo>();
		BalInvprintdetInfo balInvprintdetInfo = new BalInvprintdetInfo();
		balInvprintdetInfo.setPrintSn(printSn);
		balInvprintdetInfo.setPhoneNo(baseInvoice.getPhoneNo());
		balInvprintdetInfo.setIdNo(0l);
		balInvprintdetInfo.setContractNo(baseInvoice.getContractNo());
		long orderSn = control.getSequence("SEQ_ORDER_ID");
		balInvprintdetInfo.setOrderSn(orderSn);
		balInvprintdetInfo.setInvCode(inParam.get("INV_CODE").toString());
		balInvprintdetInfo.setInvNo(inParam.get("INV_NO").toString());
		balInvprintdetInfo.setShowOrder(6);
		balInvprintdetInfo.setShowName("本次发票金额：");
		balInvprintdetInfo.setYearMonth(preInvoiceDisp.getBillCycle() + "");
		balInvprintdetInfo.setAmount(1);
		balInvprintdetInfo.setPrintArray(1);
		balInvprintdetInfo.setUnitePrice(preInvoiceDisp.getPrintFee());
		balInvprintdetInfo.setTotalFee(preInvoiceDisp.getPrintFee());
		balInvprintdetInfo.setPrintData(xmlStr.getBytes());

		balInvprintDetInfoList.add(balInvprintdetInfo);
		invoice.iBalInvprintdetInfo(balInvprintDetInfoList);

		InvNoOccupyEntity invNo = new InvNoOccupyEntity();
		invNo.setInvNo(inParam.get("INV_NO") + "");
		invNo.setInvCode(inParam.get("INV_CODE") + "");
		invNo.setFee(ValueUtils.longValue(inParam.get("PRINT_FEE")));
		invNo.setXmlStr(xmlStr);
		return invNo;
	}

	@Override
	public InvNoOccupyEntity printPreGrpInvoice(Map<String, Object> inParam) {
		Map<String, Object> inMap = new HashMap<String, Object>();

		// 获取打印流水
		long printSn = ValueUtils.longValue(inParam.get("PRINT_SN"));
		// 获取当前时间
		SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");// 设置日期格式
		String printDate = df.format(new Date());

		// 获取发票打印的基本信息
		inMap.put("INV_NO", inParam.get("INV_NO"));
		inMap.put("CUST_NAME", inParam.get("UNIT_NAME"));
		inMap.put("PRINT_ITEM", inParam.get("PRINT_ITEM"));
		inMap.put("LOGIN_NO", inParam.get("LOGIN_NO"));
		inMap.put("LOGIN_NAME", inParam.get("LOGIN_NAME"));
		inMap.put("GROUP_ID", inParam.get("GROUP_ID"));
		inMap.put("PROVICE_ID", inParam.get("PROVICE_ID"));
		inMap.put("UNIT_ID", inParam.get("UNIT_ID"));
		inMap.put("UNIT_NAME", inParam.get("UNIT_NAME"));
		inMap.put("PRINT_SN", printSn);
		inMap.put("PRINT_ITEM", inParam.get("PRINT_ITEM"));
		BaseInvoiceDispEntity baseInvoice = preInvHeader.queryBaseInvInfoOfGrp(inMap);
		inMap = BeanToMapUtils.beanToMap(baseInvoice);
		inMap.put("PRINT_FEE", ValueUtils.transFenToYuan(ValueUtils.longValue(inParam.get("PRINT_FEE"))));
		inMap.put("BIG_MONEY", ValueUtils.transYuanToChnaBig(inMap.get("PRINT_FEE")));
		inMap.put("PRINT_TYPE", "2nn");
		inMap.put("OP_CODE", inParam.get("OP_CODE"));
		log.debug("拼装报文入参：" + inMap);
		String xmlStr = printDataXML.getPrintXml(inMap);

		log.debug(xmlStr + ">>>>>>");

		// 入发票记录总表和发票记录明细表
		List<VirtualGrpEntity> virtualGrpList = (List<VirtualGrpEntity>) inParam.get("VIRTUALGRP_LIST");
		for (VirtualGrpEntity virtualGrp : virtualGrpList) {
			BalInvprintInfoEntity balInvprintInfo = new BalInvprintInfoEntity();
			balInvprintInfo.setPrintSn(printSn);
			balInvprintInfo.setPrintArray(1);
			balInvprintInfo.setPhoneNo(virtualGrp.getGrpPhoneNo());
			balInvprintInfo.setCustId(0l);
			balInvprintInfo.setIdNo(0l);
			balInvprintInfo.setContractNo(ValueUtils.longValue(virtualGrp.getGrpContractNo()));
			// balInvprintInfo.setRelContractNo(ValueUtils.longValue(virtualGrp.getGrpContractNo()));
			balInvprintInfo.setInvType(CommonConst.YCFP_TYPE);
			balInvprintInfo.setState(CommonConst.NORMAL_STATUS);// 1:打印正常发票
			balInvprintInfo.setLoginNo(inParam.get("LOGIN_NO").toString());
			balInvprintInfo.setGroupId(inParam.get("GROUP_ID").toString());
			balInvprintInfo.setOpCode(inParam.get("OP_CODE").toString());
			balInvprintInfo.setTotalDate(DateUtils.getCurDay());
			balInvprintInfo.setInvCode(inParam.get("INV_CODE").toString());
			balInvprintInfo.setInvNo(inParam.get("INV_NO").toString());
			balInvprintInfo.setTotalFee(virtualGrp.getPayFee());
			balInvprintInfo.setPrintFee(ValueUtils.longValue(inParam.get("PRINT_FEE")));
			balInvprintInfo.setTaxFee(0l);
			balInvprintInfo.setTaxRate(0d);
			balInvprintInfo.setPrintNum(1);
			balInvprintInfo.setRemark("集团预开发票打印");
			balInvprintInfo.setPrintSeq(ValueUtils.intValue(inParam.get("PRINT_SEQ").toString()));

			List<BalInvprintInfoEntity> balInvprintInfoList = new ArrayList<BalInvprintInfoEntity>();
			balInvprintInfoList.add(balInvprintInfo);
			invoice.iBalInvprintInfo(balInvprintInfoList);

			// 报表需要查询账户的归属
			ContractInfoEntity contractInfo = account.getConInfo(ValueUtils.longValue(virtualGrp.getGrpContractNo()));
			String userGroup = contractInfo.getGroupId();

			// 入集团发票打印接口表
			BalGrppreinvInfo balGrppreinvInfo = new BalGrppreinvInfo();
			balGrppreinvInfo.setGrpContractNo(ValueUtils.longValue(virtualGrp.getGrpContractNo()));
			balGrppreinvInfo.setGrpPhoneNo(virtualGrp.getGrpPhoneNo());
			balGrppreinvInfo.setInvFee(virtualGrp.getPayFee());
			balGrppreinvInfo.setInvNo(inParam.get("INV_NO").toString());
			balGrppreinvInfo.setItem(inParam.get("PRINT_ITEM").toString());
			balGrppreinvInfo.setLoginAccpet(printSn);
			balGrppreinvInfo.setLoginNo(inParam.get("LOGIN_NO").toString());
			balGrppreinvInfo.setState(CommonConst.YKFP_FLAG);
			balGrppreinvInfo.setUnitId(ValueUtils.longValue(inParam.get("UNIT_ID").toString()));
			balGrppreinvInfo.setUnitName(inParam.get("UNIT_NAME").toString());
			// balGrppreinvInfo.setLoginAccpet(printSn);
			if (StringUtils.isNotEmptyOrNull(inParam.get("MANAGER_NAME"))) {
				balGrppreinvInfo.setManagerName(inParam.get("MANAGER_NAME").toString());
			}
			if (StringUtils.isNotEmptyOrNull(inParam.get("RETURN_DATE"))) {
				balGrppreinvInfo.setReturnDate(inParam.get("RETURN_DATE").toString());
			}

			balGrppreinvInfo.setOpTime(printDate);
			balGrppreinvInfo.setOpCode(inParam.get("OP_CODE").toString());
			balGrppreinvInfo.setHeader((Map<String, Object>) inParam.get("Header"));
			balGrppreinvInfo.setUserGroupId(userGroup);
			invoice.iBalGrppreInvInfo(balGrppreinvInfo);

		}

		// 记录发票明细表
		List<BalInvprintdetInfo> balInvprintDetInfoList = new ArrayList<BalInvprintdetInfo>();
		BalInvprintdetInfo balInvprintdetInfo = new BalInvprintdetInfo();
		balInvprintdetInfo.setPrintSn(printSn);
		balInvprintdetInfo.setIdNo(0l);
		balInvprintdetInfo.setPhoneNo(inParam.get("UNIT_ID").toString());
		long orderSn = control.getSequence("SEQ_ORDER_ID");
		balInvprintdetInfo.setOrderSn(orderSn);
		balInvprintdetInfo.setInvCode(inParam.get("INV_CODE").toString());
		balInvprintdetInfo.setInvNo(inParam.get("INV_NO").toString());
		balInvprintdetInfo.setShowOrder(6);
		balInvprintdetInfo.setShowName("本次发票金额：");
		balInvprintdetInfo.setYearMonth(DateUtils.getCurYm() + "");
		balInvprintdetInfo.setAmount(1);
		balInvprintdetInfo.setPrintArray(1);
		balInvprintdetInfo.setUnitePrice(ValueUtils.longValue(inParam.get("PRINT_FEE").toString()));
		balInvprintdetInfo.setTotalFee(ValueUtils.longValue(inParam.get("PRINT_FEE").toString()));
		balInvprintdetInfo.setPrintData(xmlStr.getBytes());
		balInvprintDetInfoList.add(balInvprintdetInfo);
		invoice.iBalInvprintdetInfo(balInvprintDetInfoList);

		InvNoOccupyEntity invNoOccupy = new InvNoOccupyEntity();
		invNoOccupy.setInvCode(inParam.get("INV_CODE").toString());
		invNoOccupy.setInvNo(inParam.get("INV_NO").toString());
		invNoOccupy.setFee(ValueUtils.longValue(inParam.get("PRINT_FEE").toString()));
		invNoOccupy.setXmlStr(xmlStr);
		return invNoOccupy;
	}

	@Override
	public Map<String, Object> print8068Accept(Map<String, Object> inParam) {
		// 根据流水查询缴费记录，查询出缴费号码，缴费账号等信息
		long paySn = ValueUtils.longValue(inParam.get("PAY_SN"));
		int yearMonth = ValueUtils.intValue(inParam.get("YEAR_MONTH"));
		// String opCode = inParam.get("OP_CODE").toString();
		String loginNo = inParam.get("LOGIN_NO").toString();
		String groupId = inParam.get("GROUP_ID").toString();
		String proviceId = inParam.get("PROVICE_ID").toString();
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("SUFFIX", yearMonth);
		inMap.put("PAY_SN", paySn);
		List<PayMentEntity> paymentList = record.getPayMentList(inMap);
		if (paymentList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8068", "00000"), "未找到对应的缴费流水");
		}
		PayMentEntity payment = paymentList.get(0);

		String phoneNo = payment.getPhoneNo();
		long contractNo = payment.getContractNo();
		long idNo = payment.getIdNo();
		// 查询发票上的基本信息
		inMap = new HashMap<String, Object>();
		inMap.put("USER_FLAG", CommonConst.IN_NET);
		inMap.put("PRINT_TYPE", "2");
		inMap.put("ID_NO", idNo);
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("PHONE_NO", phoneNo);
		inMap.put("OP_CODE", payment.getOpCode());
		inMap.put("LOGIN_NO", loginNo);
		inMap.put("PROVICE_ID", proviceId);
		inMap.put("GROUP_ID", groupId);
		BaseInvoiceDispEntity baseInvDisp = preInvHeader.queryBaseInvInfo(inMap);
		// 获取发票上的流水
		long printSn = ValueUtils.longValue(inMap.get("PRINT_SN"));
		baseInvDisp.setLoginAccept(printSn);
		// 查询发票上的金额信息
		inMap.put("PAY_SN", paySn);
		inMap.put("BILL_CYCLE", yearMonth);
		PreInvoiceDispEntity preInvDisp = invFee.getPreInvoiceFee(inMap);
		// 拼装map
		Map<String, Object> baseMap = BeanToMapUtils.beanToMap(preInvDisp);
		Map<String, Object> preMap = BeanToMapUtils.beanToMap(baseInvDisp);
		Map<String, Object> outMap = new HashMap<String, Object>();

		outMap.putAll(baseMap);
		outMap.putAll(preMap);

		long lastFee = ValueUtils.longValue(outMap.get("REMAIN_FEE")) - ValueUtils.longValue(outMap.get("PRINT_FEE"));
		outMap.put("PRINT_FEE", ValueUtils.transFenToYuan(outMap.get("PRINT_FEE")));
		outMap.put("BIG_MONEY", ValueUtils.transYuanToChnaBig(outMap.get("PRINT_FEE")));
		outMap.put("CASH_MONEY", ValueUtils.transFenToYuan(outMap.get("CASH_MONEY")));
		outMap.put("CHECK_MONEY", ValueUtils.transFenToYuan(outMap.get("CHECK_MONEY")));
		outMap.put("POS_MONEY", ValueUtils.transFenToYuan(outMap.get("POS_MONEY")));
		outMap.put("REMAIN_FEE", ValueUtils.transFenToYuan(outMap.get("REMAIN_FEE")));
		outMap.put("LAST_FEE", ValueUtils.transFenToYuan(lastFee));

		log.debug(">>>>>>>>>outMap:" + outMap);
		outMap.put("PRINT_TYPE", "2nn");
		String xmlStr = printDataXML.getPrintXml(outMap);
		InvNoOccupyEntity invNoOccupy = new InvNoOccupyEntity();
		invNoOccupy.setXmlStr(xmlStr);
		Map<String, Object> outPutMap = new HashMap<String, Object>();
		outPutMap.put("INV_NO_OCCUPY", invNoOccupy);
		outPutMap.put("PHONE_NO", phoneNo);
		return outPutMap;
	}

	/**
	 * 缴费发票的项目名称拼装
	 * 
	 * @param preInvDisp
	 * @return
	 */
	private Map<String, Object> getPreFeeMap(PreInvoiceDispEntity preInvDisp) {
		Map<String, Object> feeMap = new HashMap<String, Object>();
		feeMap.put("号码缴费", preInvDisp.getPrintFee());
		return feeMap;
	}

	public IPreInvHeader getPreInvHeader() {
		return preInvHeader;
	}

	public void setPreInvHeader(IPreInvHeader preInvHeader) {
		this.preInvHeader = preInvHeader;
	}

	public IInvoice getInvoice() {
		return invoice;
	}

	public void setInvoice(IInvoice invoice) {
		this.invoice = invoice;
	}

	public IInvFee getInvFee() {
		return invFee;
	}

	public void setInvFee(IInvFee invFee) {
		this.invFee = invFee;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public IPrintDataXML getPrintDataXML() {
		return printDataXML;
	}

	public void setPrintDataXML(IPrintDataXML printDataXML) {
		this.printDataXML = printDataXML;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
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

	public IElecInvoice getEleInvoice() {
		return eleInvoice;
	}

	public void setEleInvoice(IElecInvoice eleInvoice) {
		this.eleInvoice = eleInvoice;
	}

	public ILogin getLogin() {
		return login;
	}

	public void setLogin(ILogin login) {
		this.login = login;
	}

}
