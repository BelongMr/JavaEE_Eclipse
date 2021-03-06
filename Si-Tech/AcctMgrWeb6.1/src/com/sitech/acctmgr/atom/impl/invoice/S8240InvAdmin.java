package com.sitech.acctmgr.atom.impl.invoice;

//import com.sitech.acctmgr.atom.busi.invoice.inter.IElecInvoTools;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.invoice.BalInvprintInfoEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.dto.invoice.S8240DisabledInvoInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8240DisabledInvoOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8240qryInvoByInvNoInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8240qryInvoByInvNoOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IInvoice;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgr.inter.invoice.I8240InvAdmin;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
//import com.sitech.acctmgr.atom.domains.EInvoiceForCrm;
import com.sitech.jcfx.util.DateUtil;

/**
 *
 * <p>
 * Title: 8240发票管理类
 * </p>
 * <p>
 * Description: 发票查询，作废，冲红
 * </p>
 * <p>
 * Copyright: Copyright (c) 2014
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 * 
 * @author fanck
 * @version 1.0
 */

@ParamTypes({ @ParamType(c = S8240qryInvoByInvNoInDTO.class, m = "queryInvo", oc = S8240qryInvoByInvNoOutDTO.class),
		@ParamType(c = S8240DisabledInvoInDTO.class, m = "disabledInvoice", oc = S8240DisabledInvoOutDTO.class) })
public class S8240InvAdmin extends AcctMgrBaseService implements I8240InvAdmin {

	private IInvoice invoice;
	private IBalance balance;
	private IControl control;
	private IRecord record;
	private IPreOrder preOrder;
	private IGroup group;
	private IUser user;

	@Override
	public OutDTO queryInvo(InDTO inParam) {
		S8240qryInvoByInvNoInDTO inDto = (S8240qryInvoByInvNoInDTO) inParam;
		String invNo = "";
		String invCode = "";
		String phoneNo = "";
		long contractNo = 0;
		int pageNum = inDto.getPageNum();
		log.debug("当前页面为：" + pageNum);
		Map<String, Object> inMap = new HashMap<String, Object>();
		if (StringUtils.isNotEmpty(inDto.getInvCode())) {
			invCode = inDto.getInvCode();
			inMap.put("INV_CODE", invCode);
		}
		if (StringUtils.isNotEmpty(inDto.getInvNo())) {
			invNo = inDto.getInvNo();
			inMap.put("INV_NO", invNo);

		}
		if (StringUtils.isNotEmpty(inDto.getPhoneNo())) {
			phoneNo = inDto.getPhoneNo();
			inMap.put("PHONE_NO", phoneNo);
			// UserInfoEntity userInfo = user.getUserInfo(phoneNo);
			// contractNo = userInfo.getContractNo();
			// inMap.put("CONTRACT_NO", contractNo);
		}
		if (StringUtils.isNotEmpty(inDto.getState()) && !inDto.getState().equals("0")) {
			inMap.put("STATE", inDto.getState());
		}
		if (StringUtils.isNotEmptyOrNull(inDto.getLoginNo())) {
			inMap.put("LOGIN_NO", inDto.getLoginNo());
		}
		int beginTime = inDto.getBeginTime();
		int endTime = inDto.getEndTime();

		List<BalInvprintInfoEntity> invoList = new ArrayList<BalInvprintInfoEntity>();
		inMap.put("BEGIN_TIME", beginTime + "");
		inMap.put("END_TIME", endTime + "");

		Map<String, Object> outMap = invoice.getInvoInfo(inMap, pageNum, 10);
		invoList = (List<BalInvprintInfoEntity>) outMap.get("result");
		int totalNum = (int) outMap.get("sum");

		if (invoList == null || invoList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8240", "00000"), "没有找到对应的发票记录");
		}
		// List<BalInvprintInfoEntity> invList = new ArrayList<BalInvprintInfoEntity>();
		// for (BalInvprintInfoEntity balInvprint : invoList) {
		// if (balInvprint.getCnt() == 1) {
		// inMap = new HashMap<>();
		// inMap.put("INV_NO", balInvprint.getInvNo());
		// inMap.put("INV_CODE", balInvprint.getInvCode());
		// inMap.put("YEAR_MONTH", balInvprint.getTotalDate() / 100 + "");
		// List<BalInvprintInfoEntity> printTmpList = invoice.getInvoInfoByInvNo(inMap);
		// UserInfoEntity userInfo = user.getUserEntityByConNo(printTmpList.get(0).getContractNo(), false);
		// if (userInfo != null) {
		// balInvprint.setPhoneNo(userInfo.getPhoneNo());
		// balInvprint.setIdNo(userInfo.getIdNo());
		// // 获取用户品牌
		// UserBrandEntity userBrand = user.getUserBrandRel(userInfo.getIdNo());
		// if (userBrand != null) {
		// balInvprint.setBrandId(userBrand.getBrandId());
		// }
		// }
		// balInvprint.setContractNo(printTmpList.get(0).getContractNo());
		//
		// }
		// if (balInvprint.getCnt() > 1 && StringUtils.isNotEmptyOrNull(inDto.getPhoneNo())) {
		// continue;
		// }
		// invList.add(balInvprint);
		// }
		S8240qryInvoByInvNoOutDTO outDto = new S8240qryInvoByInvNoOutDTO();
		outDto.setInvInfoList(invoList);
		outDto.setTotalNum(totalNum);
		return outDto;
	}

	@Override
	public OutDTO disabledInvoice(InDTO inParam) {
		S8240DisabledInvoInDTO inDto = (S8240DisabledInvoInDTO) inParam;
		log.debug(inDto.toString());
		Map<String, Object> inMap = new HashMap<String, Object>();
		// 根据inv_no和inv_code查询打印记录
		String invNo = "";
		String invCode = "";
		invCode = inDto.getInvCode();
		invNo = inDto.getInvNo();

		int yearMonth = inDto.getYearMonth();

		String state = CommonConst.NORMAL_STATUS;
		// 1.根据发票号查询需要作废的发票
		inMap.put("INV_CODE", invCode);
		inMap.put("INV_NO", invNo);
		inMap.put("STATE", state);
		List<BalInvprintInfoEntity> invoList = new ArrayList<BalInvprintInfoEntity>();
		inMap.put("YEAR_MONTH", yearMonth + "");
		invoList = invoice.getInvoInfoByInvNo(inMap);

		if (invoList == null || invoList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8240", "00000"), "没有找到可作废的发票");
		}
		// 2.更新发票记录表中的状态
		inMap = new HashMap<String, Object>();
		inMap.put("INV_CODE_OLD", invCode);
		inMap.put("INV_NO_OLD", invNo);
		inMap.put("SUFFIX", yearMonth + "");
		inMap.put("STATE_OLD", CommonConst.NORMAL_STATUS);
		inMap.put("STATE", CommonConst.CANCEL_STATUS);
		inMap.put("PAY_SN", 0);
		invoice.updateStateByInvNo(inMap);

		for (BalInvprintInfoEntity balInvprintInfo : invoList) {

			// 2.判断是否为预存发票
			aa: if (balInvprintInfo.getInvType().startsWith("P")) {

				// 2.1 预存发票，根据pay_sn修改账本表中的print_flag
				inMap.put("SUFFIX", balInvprintInfo.getBillCycle());
				inMap.put("PRINT_FLAG", CommonConst.CANCEL_STATUS);
				inMap.put("PAY_SN", balInvprintInfo.getPaySn());
				// 如果pay_sn为空，说明集团为集团预开发票，不在修改状态
				if (StringUtils.isEmptyOrNull(balInvprintInfo.getPaySn())) {
					break aa;
				}
				inMap.put("CONTRACT_NO", balInvprintInfo.getContractNo());
				inMap.put("USER_FLAG", "2");
				invoice.updatePrintFlagByPre(balInvprintInfo.getPaySn(), 0, "", balInvprintInfo.getBillCycle(), balInvprintInfo.getContractNo(), "0");
				// 2.2 查询账本支出表，查询该账本冲销记录，更新账本冲销记录表中的记录
				inMap = new HashMap<String, Object>();
				inMap.put("PAY_SN", balInvprintInfo.getPaySn());
				inMap.put("SUFFIX", balInvprintInfo.getBillCycle());
				Map<String, Object> payoutMap = balance.getPayOutList(inMap);
				List<Long> wrtoffList = new ArrayList<Long>();
				if (ValueUtils.intValue(payoutMap.get("CNT")) > 0) {
					List<Map<String, Object>> payoutList = (List<Map<String, Object>>) payoutMap.get("BOOKPAYOUT_LIST");
					for (Map<String, Object> payout : payoutList) {
						long wrtoffSn = ValueUtils.longValue(payout.get("WRTOFF_SN"));
						wrtoffList.add(wrtoffSn);
					}
					// 2.3循环月份更新冲销记录表中的记录
					for (int yearMonthTmp = balInvprintInfo.getBillCycle(); yearMonthTmp <= DateUtils.getCurYm(); yearMonthTmp = DateUtils.addMonth(
							yearMonthTmp, 1)) {
						inMap.put("WRTOFF_LIST", wrtoffList);
						inMap.put("SUFFIX", yearMonthTmp);
						inMap.put("PRINT_FLAG", "0");
						balance.upWriteOffPrintFlag(inMap);
					}
				}

			} else {
				// 3.月结发票
				// 3.1 循环月份，根据print_sn更新冲销记录表中的记录
				for (int yearMonthTmp = balInvprintInfo.getBillCycle(); yearMonthTmp <= DateUtils.getCurYm(); yearMonthTmp = DateUtils.addMonth(
						yearMonthTmp, 1)) {
					inMap = new HashMap<String, Object>();
					inMap.put("PRINT_SN", balInvprintInfo.getPrintSn());
					inMap.put("SUFFIX", yearMonthTmp);
					inMap.put("CONTRACT_NO", balInvprintInfo.getContractNo());
					inMap.put("PRINT_FLAG", "0");
					balance.upWriteOffPrintFlag(inMap);
				}
			}

		}

		// 判断在集团发票记录表中有没有记录，如果记录了，就修改状态
		String stateHis = "";
		int cnt = 0;
		List<String> stateList = new ArrayList<String>();
		stateList.add(CommonConst.YKFP_FLAG);
		stateList.add(CommonConst.YKFPHS_FLAG);
		// stateList.add(CommonConst.JTFPDY_FLAG);
		inMap.put("STATE", CommonConst.JTFPQX_FLAG);
		inMap.put("INV_NO", invNo);
		inMap.put("STATE_LIST", stateList);
		cnt = invoice.qryCntGrp(inMap);

		if (cnt > 0) {
			log.debug("开具预开发票");
			// 开具预开发票
			stateHis = CommonConst.JTFPQX_FLAG;
		} else {
			stateList = new ArrayList<>();
			stateList.add(CommonConst.JTFPDY_FLAG);
			log.debug("stateList" + stateList);
			inMap.put("STATE_LIST", stateList);
			stateHis = CommonConst.JTFPDY_FLAG;
			cnt = invoice.qryCntGrp(inMap);
		}

		if (cnt > 0) {
			log.debug("开具集团打印发票");
			// 记录历史表，并更改状态
			inMap.put("LOGIN_NO", inDto.getLoginNo());
			inMap.put("STATE_HIS", stateHis);
			inMap.put("PRINT_SN", invoList.get(0).getPrintSn());
			inMap.put("OP_CODE", inDto.getOpCode());
			inMap.put("HEADER", inDto.getHeader());
			invoice.bakGrpPreInv(inMap);

			invoice.updateGrpPrintState(inMap);


		}

		// 入营业员操作日志表
		// 生成操作流水
		long loginAccept = control.getSequence("SEQ_SYSTEM_SN");

		// 记录操作日志
		LoginOprEntity loe = new LoginOprEntity();
		loe.setIdNo(invoList.get(0).getIdNo());
		loe.setBrandId("");
		loe.setLoginGroup(inDto.getGroupId());
		loe.setLoginNo(inDto.getLoginNo());
		loe.setLoginSn(loginAccept);
		loe.setOpCode(inDto.getOpCode());
		loe.setPhoneNo(invoList.get(0).getPhoneNo());
		loe.setTotalDate(DateUtils.getCurDay());
		loe.setRemark("通用机打发票作废");
		record.saveLoginOpr(loe);

		// 同步CRM统一接触
		ChngroupRelEntity cgre = group.getRegionDistinct(inDto.getGroupId(), "2", inDto.getProvinceId());
		Map<String, Object> oprCnttMap = new HashMap<String, Object>();
		oprCnttMap.put("Header", inDto.getHeader());
		oprCnttMap.put("PAY_SN", loginAccept);
		oprCnttMap.put("LOGIN_NO", inDto.getLoginNo());
		oprCnttMap.put("GROUP_ID", inDto.getGroupId());
		oprCnttMap.put("OP_CODE", inDto.getOpCode());
		oprCnttMap.put("REGION_ID", cgre.getRegionCode());
		oprCnttMap.put("OP_NOTE", "通用机打发票作废");
		oprCnttMap.put("TOTAL_FEE", 0);
		oprCnttMap.put("CUST_ID_TYPE", "1");
		if (StringUtils.isNotEmptyOrNull(invoList.get(0).getPhoneNo())) {
			oprCnttMap.put("CUST_ID_VALUE", invoList.get(0).getPhoneNo());
		} else {
			oprCnttMap.put("CUST_ID_VALUE", "99999999999");
		}

		// 取系统时间
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		oprCnttMap.put("OP_TIME", sCurTime);
		preOrder.sendOprCntt(oprCnttMap);

		S8240DisabledInvoOutDTO outDto = new S8240DisabledInvoOutDTO();
		outDto.setLoginAccept(loginAccept);
		return outDto;
	}

	public IInvoice getInvoice() {
		return invoice;
	}

	public void setInvoice(IInvoice invoice) {
		this.invoice = invoice;
	}

	public IBalance getBalance() {
		return balance;
	}

	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}

	public IPreOrder getPreOrder() {
		return preOrder;
	}

	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

	public IUser getUser() {
		return user;
	}

	public void setUser(IUser user) {
		this.user = user;
	}

}
