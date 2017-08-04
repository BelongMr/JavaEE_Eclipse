package com.sitech.acctmgr.atom.impl.invoice;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.invoice.inter.IInvFee;
import com.sitech.acctmgr.atom.busi.invoice.inter.IInvPrint;
import com.sitech.acctmgr.atom.busi.invoice.inter.IPreInvHeader;
import com.sitech.acctmgr.atom.busi.invoice.inter.IPrintDataXML;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.balance.BalanceEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.invoice.InvBillCycleEntity;
import com.sitech.acctmgr.atom.domains.invoice.InvNoOccupyEntity;
import com.sitech.acctmgr.atom.domains.invoice.MealEntity;
import com.sitech.acctmgr.atom.domains.invoice.MonthInvoiceDispEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.dto.invoice.S8224PrintInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8224PrintOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8224QryInvoInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8224QryInvoOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IInvoice;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.comp.busi.LoginCheck;
import com.sitech.acctmgr.inter.invoice.I8224;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.service.client.ServiceUtil;
import com.sitech.jcfx.util.DateUtil;

//import com.sitech.acctmgr.atom.domains.bill.UnBillData;

@ParamTypes({ @ParamType(c = S8224QryInvoInDTO.class, m = "qryInvo", oc = S8224QryInvoOutDTO.class),
		@ParamType(c = S8224PrintInDTO.class, m = "print", oc = S8224PrintOutDTO.class) })
public class S8224 extends AcctMgrBaseService implements I8224 {

	private IInvPrint invPrint;
	private IInvFee invFee;
	private IPreInvHeader preInvHeader;
	private IPrintDataXML printDataXML;
	private IInvoice invoice;
	private IRemainFee remainFee;
	private IAccount account;
	private ICust cust;
	private IControl control;
	private LoginCheck logincheck;
	private IRecord record;
	private IPreOrder preOrder;
	private IGroup group;

	@Override
	public OutDTO qryInvo(InDTO inParam) {
		S8224QryInvoInDTO inDto = (S8224QryInvoInDTO) inParam;
		long contractNo = inDto.getContractNo();
		int beginYm = inDto.getBeginYm();
		int endYm = inDto.getEndYm();
		String phoneNo = inDto.getPhoneNo();
		String loginNo = inDto.getLoginNo();
		String groupId = inDto.getGroupId();
		String opCode = inDto.getOpCode();

		List<MealEntity> mealList = getMealList(phoneNo);
		// 直接在服务里面判断打印账期须小于当前月
		if (endYm >= DateUtils.getCurYm()) {
			throw new BusiException(AcctMgrError.getErrorCode("8224", "00001"), "打印账期必须小于当前账期！");
		}
		// 判断是否有往月欠费，如果有欠费不予许打印月结发票，提示：用户当前欠费%.2f元,不允许打印月结发票
		long conRemainFee = remainFee.getConRemainFee(contractNo).getOweFee();
		// if (oweFee > 0) {
		// throw new BusiException(AcctMgrError.getErrorCode("8224", "00002"), "用户当月欠费" + oweFee / 100.0 + "元，不允许打印月结发票");
		// }

		// 根据服务号码查询ID_NO
		// UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
		// long idNo = userInfo.getIdNo();
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("PHONE_NO", phoneNo);
		inMap.put("LOGIN_NO", loginNo);
		inMap.put("GROUP_ID", groupId);
		inMap.put("OP_CODE", opCode);
		inMap.put("PRINT_TYPE", "1");
		inMap.put("PROVICE_ID", inDto.getProvinceId());
		if (mealList != null) {
			inMap.put("MEAL_LIST", mealList);
		}

		// 查询用户的基本信息
		// BaseInvoiceDispEntity baseInvDisp = preInvHeader.queryBaseInvInfo(inMap);
		// 根据custId查询客户名称
		ContractInfoEntity contractInfo = account.getConInfo(contractNo);
		long custId = contractInfo.getCustId();

		CustInfoEntity custInfo = cust.getCustInfo(custId, "");
		String custName = custInfo.getCustName();

		List<MonthInvoiceDispEntity> monthInvDispList = new ArrayList<MonthInvoiceDispEntity>();
		List<BalanceEntity> paySnList = new ArrayList<BalanceEntity>();
		for (int billCycle = beginYm; billCycle <= endYm; billCycle = DateUtils.addMonth(billCycle, 1)) {
			inMap.put("BILL_CYCLE", billCycle);
			Map<String, Object> feeMap = invFee.getMonthInvoiceFee(inMap);
			if (feeMap != null) {
				MonthInvoiceDispEntity monthInvDisp = (MonthInvoiceDispEntity) feeMap.get("MONTH_INVOICE_DISP");
				List<Long> paySnListTmp = (List<Long>) feeMap.get("PAY_SN_LIST");
				for (long paySn : paySnListTmp) {
					BalanceEntity balanceEntity = new BalanceEntity();
					balanceEntity.setPaySn(paySn);
					paySnList.add(balanceEntity);
				}
				monthInvDispList.add(monthInvDisp);
			}

		}

		S8224QryInvoOutDTO outDto = new S8224QryInvoOutDTO();
		outDto.setInvDisp(monthInvDispList);
		outDto.setPhoneNo(phoneNo);
		outDto.setContractNo(contractNo);
		outDto.setCustName(custName);
		outDto.setPaySnList(paySnList);
		outDto.setRemainFee(conRemainFee);
		return outDto;

	}

	@Override
	public OutDTO print(InDTO inParam) {
		S8224PrintInDTO inDto = (S8224PrintInDTO) inParam;

		long contractNo = inDto.getContractNo();
		// int billCycle = inDto.getBillCycle();
		String phoneNo = inDto.getPhoneNo();
		boolean isCombine = inDto.isCombine();
		int isPrint = inDto.getIsPrint();
		// String invNo = inDto.getInvNo();
		// String invCode = inDto.getInvCode();
		int invTypeFlag = inDto.getInvType();
		String chnSource = "";
		if (StringUtils.isNotEmptyOrNull(inDto.getChnSource())) {
			chnSource = inDto.getChnSource();
		}
		List<InvBillCycleEntity> billcycleList = inDto.getInvBillCycleList();
		List<MealEntity> mealList = new ArrayList<>();
		mealList = getMealList(phoneNo);

		String loginNo = inDto.getLoginNo();
		String groupId = inDto.getGroupId();
		String opCode = inDto.getOpCode();

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("PHONE_NO", phoneNo);
		inMap.put("LOGIN_NO", loginNo);
		inMap.put("GROUP_ID", groupId);
		inMap.put("OP_CODE", opCode);
		inMap.put("PRINT_TYPE", "1");
		inMap.put("PROVICE_ID", inDto.getProvinceId());
		inMap.put("PRINT_SEQ", "1");
		inMap.put("IS_COMBINE", isCombine);
		inMap.put("INV_BILLCYCLE_LIST", billcycleList);
		inMap.put("MEAL_LIST", mealList);
		inMap.put("IS_PRINT", isPrint);
		inMap.put("CHN_SOURCE", chnSource);
		if (invTypeFlag == 1) {
			inMap.put("INV_TYPE", CommonConst.ELE_MONTH_TYPE);
		}

		// 直接在服务里面判断打印账期须小于当前月
		for (InvBillCycleEntity invBillCycle : billcycleList) {
			if (invBillCycle.getBillCycle() >= DateUtils.getCurYm()) {
				throw new BusiException(AcctMgrError.getErrorCode("8224", "00001"), "打印账期必须小于当前账期！");
			}
		}

		// 判断是否有欠费，如果有欠费不予许打印月结发票，提示：用户当前欠费%.2f元,不允许打印月结发票
		long oweFee = remainFee.getConRemainFee(contractNo).getOweFee();
		// 判断工号时候有小权限，先设置小权限为a000,如果有权限，则可以打印
		Map<String, Object> powMap = new HashMap<String, Object>();
		powMap.put("BUSI_CODE", "BBM8224a");
		powMap.put("LOGIN_NO", inDto.getLoginNo());
		boolean powFlag = logincheck.pchkFuncPower(inDto.getHeader(), powMap);
		if (oweFee > 0 && !powFlag) {
			throw new BusiException(AcctMgrError.getErrorCode("8224", "00002"), "用户当月欠费" + oweFee / 100.0 + "元，不允许打印月结发票");
		}
		long printSn = invoice.getPrintSn();
		inMap.put("PRINT_SN", printSn);
		log.debug("8224调用打印的参数：" + inMap);

		List<InvNoOccupyEntity> invNoOccupy = invPrint.printMonthInvoice(inMap);

		if (isPrint == 0) {
			// 记录工号操作记录表
			LoginOprEntity loe = new LoginOprEntity();
			loe.setLoginGroup(inDto.getGroupId());
			loe.setLoginNo(inDto.getLoginNo());
			loe.setLoginSn(printSn);
			loe.setTotalDate(DateUtils.getCurDay());
			loe.setIdNo(0);
			loe.setPhoneNo(phoneNo);
			loe.setBrandId("xx");
			loe.setPayType("00");
			loe.setPayFee(0);
			loe.setOpCode(inDto.getOpCode());
			loe.setRemark(inDto.getLoginNo() + "给用户打印月结发票");
			record.saveLoginOpr(loe);

			// 同步CRM统一接触
			ChngroupRelEntity cgre = group.getRegionDistinct(groupId, "2", inDto.getProvinceId());
			Map<String, Object> oprCnttMap = new HashMap<String, Object>();
			oprCnttMap.put("Header", inDto.getHeader());
			oprCnttMap.put("PAY_SN", printSn);
			oprCnttMap.put("LOGIN_NO", inDto.getLoginNo());
			oprCnttMap.put("GROUP_ID", inDto.getGroupId());
			oprCnttMap.put("OP_CODE", inDto.getOpCode());
			oprCnttMap.put("REGION_ID", cgre.getRegionCode());
			oprCnttMap.put("OP_NOTE", inDto.getLoginNo() + "给用户打印月结发票");
			oprCnttMap.put("TOTAL_FEE", 0);
			oprCnttMap.put("CUST_ID_TYPE", "1");
			oprCnttMap.put("CUST_ID_VALUE", phoneNo);
			// 取系统时间
			String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
			oprCnttMap.put("OP_TIME", sCurTime);
			preOrder.sendOprCntt(oprCnttMap);
		}

		S8224PrintOutDTO outDto = new S8224PrintOutDTO();
		outDto.setInvNoOccupy(invNoOccupy);

		return outDto;

	}

	/**
	 * 调用营销接口，查询meal_list
	 * 
	 * @param phoneNo
	 * @return
	 */
	private List<MealEntity> getMealList(String phoneNo) {
		// 调用营销的接口，查询meal_list
		String interfaceName = "com_sitech_market_comp_inter_IChnMktActOrderSvc_mktOrderQry";
		MBean mbean = new MBean();
		mbean.setBody("BUSI_INFO.PHONE_NO", phoneNo);
		mbean.setBody("BUSI_INFO.OP_TYPE", "5");
		mbean.setRouteKey("10");
		mbean.setRouteValue(phoneNo);
		log.debug("调用营销接口开始");
		String outString = ServiceUtil.callService(interfaceName, mbean.toString());
		log.debug("调用营销接口结束" + outString);
		MBean outBean = new MBean(outString);
		List<Map<String, Map<String, Object>>> mapList = (List<Map<String, Map<String, Object>>>) outBean.getBodyList("OUT_DATA.ACT_LIST");
		List<MealEntity> mealList = new ArrayList<MealEntity>();
		if(mapList==null){
			return mealList;
		}
		for (Map<String, Map<String, Object>> map : mapList) {
			Map<String, Object> actInfoMap = map.get("ACT_INFO");
			String loginAccept = actInfoMap.get("LOGIN_ACCEPT").toString();
			String hyDate = actInfoMap.get("OP_TIME").toString();
			MealEntity mealEntity = new MealEntity();
			mealEntity.setHyAccept(loginAccept);
			mealEntity.setHyDate(hyDate);
			mealList.add(mealEntity);

		}
		return mealList;
	}

	@Override
	public OutDTO instanceForConsumOfMon(InDTO inParam) {
		// TODO Auto-generated method stub
		return null;
	}

	public IInvPrint getInvPrint() {
		return invPrint;
	}

	public void setInvPrint(IInvPrint invPrint) {
		this.invPrint = invPrint;
	}

	public IInvFee getInvFee() {
		return invFee;
	}

	public void setInvFee(IInvFee invFee) {
		this.invFee = invFee;
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

	public IPreInvHeader getPreInvHeader() {
		return preInvHeader;
	}

	public void setPreInvHeader(IPreInvHeader preInvHeader) {
		this.preInvHeader = preInvHeader;
	}

	public IPrintDataXML getPrintDataXML() {
		return printDataXML;
	}

	public void setPrintDataXML(IPrintDataXML printDataXML) {
		this.printDataXML = printDataXML;
	}

	public IInvoice getInvoice() {
		return invoice;
	}

	public void setInvoice(IInvoice invoice) {
		this.invoice = invoice;
	}

	public IRemainFee getRemainFee() {
		return remainFee;
	}

	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}

	public IAccount getAccount() {
		return account;
	}

	public void setAccount(IAccount account) {
		this.account = account;
	}

	public ICust getCust() {
		return cust;
	}

	public void setCust(ICust cust) {
		this.cust = cust;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public LoginCheck getLogincheck() {
		return logincheck;
	}

	public void setLogincheck(LoginCheck logincheck) {
		this.logincheck = logincheck;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}

}
