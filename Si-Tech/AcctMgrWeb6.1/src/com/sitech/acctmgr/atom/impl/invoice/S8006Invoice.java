package com.sitech.acctmgr.atom.impl.invoice;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.invoice.inter.IInvPrint;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.invoice.InvNoOccupyEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.dto.invoice.S8006InvoicePrintInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8006InvoicePrintOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IInvoice;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.inter.invoice.I8006Invoice;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

/**
 * 名称：陈死账回收打印发票
 * 
 * @author liuhl_bj
 *
 */
@ParamTypes({ @ParamType(c = S8006InvoicePrintInDTO.class, oc = S8006InvoicePrintOutDTO.class, m = "print") })
public class S8006Invoice extends AcctMgrBaseService implements I8006Invoice {

	private IInvoice invoice;
	// add by liuhl_bj begin
	private IGroup group;
	private IInvPrint invPrint;
	private IRecord record;
	private IPreOrder preOrder;

	// add by liuhl_bj end

	@Override
	public OutDTO print(InDTO inParam) {
		S8006InvoicePrintInDTO inDto = (S8006InvoicePrintInDTO) inParam;
		long contractNo = inDto.getContractNo();
		String phoneNo = inDto.getPhoneNo();
		int userFlag = CommonConst.NO_NET;
		String opCode = inDto.getOpCode();
		String loginNo = inDto.getLoginNo();
		String groupId = inDto.getGroupId();
		String proviceId = inDto.getProvinceId();
		String invNo = inDto.getInvNo();
		String invCode = inDto.getInvCode();
		int billCycle = DateUtils.getCurYm();
		long paySn = inDto.getPaySn();
		int printSeq = 1;

		String chnSource = "";

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("CONTRACT_NO", contractNo);
		inMap.put("USER_FLAG", userFlag);
		inMap.put("OP_CODE", opCode);
		inMap.put("LOGIN_NO", loginNo);
		inMap.put("GROUP_ID", groupId);
		inMap.put("PROVICE_ID", proviceId);
		inMap.put("INV_NO", invNo);
		inMap.put("INV_CODE", invCode);
		inMap.put("BILL_CYCLE", billCycle);
		inMap.put("PAY_SN", paySn);
		inMap.put("PRINT_SEQ", printSeq);
		inMap.put("PHONE_NO", phoneNo);
		inMap.put("IS_PRINT", true);
		inMap.put("CHN_SOURCE", chnSource);
		// 获取发票上的流水
		long printSn = invoice.getPrintSn();
		inMap.put("PRINT_SN", printSn);

		Map<String, Object> outMap = new HashMap<String, Object>();
		outMap = invPrint.printPreInvoice(inMap);

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
		loe.setRemark(inDto.getLoginNo() + "给离网用户打印预存发票");
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
		oprCnttMap.put("OP_NOTE", inDto.getLoginNo() + "给离网用户打印预存发票");
		oprCnttMap.put("TOTAL_FEE", 0);
		oprCnttMap.put("CUST_ID_TYPE", "1");
		oprCnttMap.put("CUST_ID_VALUE", phoneNo);
		// 取系统时间
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		oprCnttMap.put("OP_TIME", sCurTime);
		preOrder.sendOprCntt(oprCnttMap);

		InvNoOccupyEntity occupy = (InvNoOccupyEntity) outMap.get("INV_NO_OCCUPY");
		S8006InvoicePrintOutDTO outDto = new S8006InvoicePrintOutDTO();
		outDto.setInvNoOccupy(occupy);
		log.debug(outDto.toJson());
		return outDto;
	}

	public IInvoice getInvoice() {
		return invoice;
	}

	public void setInvoice(IInvoice invoice) {
		this.invoice = invoice;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

	public IInvPrint getInvPrint() {
		return invPrint;
	}

	public void setInvPrint(IInvPrint invPrint) {
		this.invPrint = invPrint;
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

}
