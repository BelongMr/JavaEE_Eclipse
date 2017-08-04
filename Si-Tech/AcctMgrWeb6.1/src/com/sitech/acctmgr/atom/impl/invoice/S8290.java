package com.sitech.acctmgr.atom.impl.invoice;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.invoice.inter.IInvPrint;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.invoice.InvNoOccupyEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.VirtualGrpEntity;
import com.sitech.acctmgr.atom.dto.invoice.S8290PrintInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8290PrintOutDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8290QryInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8290QryOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IInvoice;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgr.inter.invoice.I8290;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

@ParamTypes({ @ParamType(c = S8290QryInDTO.class, oc = S8290QryOutDTO.class, m = "query"),
		@ParamType(c = S8290PrintInDTO.class, oc = S8290PrintOutDTO.class, m = "print") })
public class S8290 extends AcctMgrBaseService implements I8290 {
	private IUser user;
	private IAccount account;
	private IInvPrint invPrint;

	private IInvoice invoice;
	private IRecord record;
	private IPreOrder preOrder;
	private IGroup group;

	@Override
	public OutDTO query(InDTO inParam) {
		S8290QryInDTO inDto = (S8290QryInDTO) inParam;
		long unitId = inDto.getUnitId();
		// 根据unitId查询集团成员账户号码和服务号码
		List<VirtualGrpEntity> virtualList = user.getVirtualGrpList(unitId, "");
		if (virtualList == null || virtualList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8241", "00001"), "查询虚拟集团信息失败");
		}

		List<VirtualGrpEntity> outList = new ArrayList<VirtualGrpEntity>();
		String unitName = virtualList.get(0).getUnitName();
		for (VirtualGrpEntity virtualGrp : virtualList) {
			// 查询账户的账户名称
			long contractNo = ValueUtils.longValue(virtualGrp.getGrpContractNo());
			ContractInfoEntity conInfo = account.getConInfo(contractNo);
			String contractName = conInfo.getContractName();
			virtualGrp.setContractName(contractName);
			outList.add(virtualGrp);
		}
		S8290QryOutDTO outDto = new S8290QryOutDTO();
		outDto.setVirtualList(outList);
		outDto.setUnitId(unitId + "");
		outDto.setUnitName(unitName);
		log.debug("出参：" + outDto.toJson());
		return outDto;
	}

	@Override
	public OutDTO print(InDTO inParam) {
		S8290PrintInDTO inDto = (S8290PrintInDTO) inParam;
		log.debug("inDto=" + inDto.getMbean());
		String invCode = inDto.getInvCode();
		String invNo = inDto.getInvNo();
		String opCode = inDto.getOpCode();
		String groupId = inDto.getGroupId();
		String loginNo = inDto.getLoginNo();
		String unitName = inDto.getUnitName();
		long unitId = inDto.getUnitId();
		String printItem = inDto.getPrintItem();
		String custManager = inDto.getCustManager();
		String accountDate = inDto.getAccountDate();

		List<VirtualGrpEntity> virtualGrpList = inDto.getVirtualGrpList();
		// 获取打印流水
		long printSn = invoice.getPrintSn();
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("PRINT_SN", printSn);
		inMap.put("INV_CODE", invCode);
		inMap.put("INV_NO", invNo);
		inMap.put("OP_CODE", opCode);
		inMap.put("LOGIN_NO", loginNo);
		inMap.put("GROUP_ID", groupId);
		inMap.put("VIRTUALGRP_LIST", virtualGrpList);
		inMap.put("UNIT_ID", unitId);
		inMap.put("UNIT_NAME", unitName);
		inMap.put("PROVICE_ID", inDto.getProvinceId());
		inMap.put("PRINT_FEE", inDto.getPrintFee());
		inMap.put("PRINT_ITEM", inDto.getPrintItem());
		inMap.put("UNIT_NAME", inDto.getUnitName());
		inMap.put("PRINT_ITEM", inDto.getPrintItem());
		inMap.put("OP_CODE", inDto.getOpCode());
		inMap.put("PRINT_SEQ", 1);
		inMap.put("PRINT_ITEM", printItem);
		inMap.put("MANAGER_NAME", custManager);
		inMap.put("RETURN_DATE", accountDate);
		inMap.put("Header", inDto.getHeader());
		InvNoOccupyEntity invNoOccupy = invPrint.printPreGrpInvoice(inMap);
		// 记录营业员操作日志表
		LoginOprEntity in = new LoginOprEntity();
		in.setLoginSn(ValueUtils.longValue(printSn));
		in.setLoginNo(inDto.getLoginNo());
		in.setLoginGroup(inDto.getGroupId());
		in.setOpCode(inDto.getOpCode());
		in.setTotalDate(DateUtils.getCurDay());
		in.setRemark(inDto.getLoginNo() + "给集团编号为" + unitId + "打印预开发票");
		record.saveLoginOpr(in);

		// 同步CRM统一接触
		ChngroupRelEntity cgre = group.getRegionDistinct(groupId, "2", inDto.getProvinceId());
		Map<String, Object> oprCnttMap = new HashMap<String, Object>();
		oprCnttMap.put("Header", inDto.getHeader());
		oprCnttMap.put("PAY_SN", printSn);
		oprCnttMap.put("LOGIN_NO", inDto.getLoginNo());
		oprCnttMap.put("GROUP_ID", inDto.getGroupId());
		oprCnttMap.put("OP_CODE", inDto.getOpCode());
		oprCnttMap.put("REGION_ID", cgre.getRegionCode());
		oprCnttMap.put("OP_NOTE", inDto.getLoginNo() + "给集团编号为" + unitId + "打印预开发票");
		oprCnttMap.put("TOTAL_FEE", 0);
		oprCnttMap.put("CUST_ID_TYPE", "1");
		oprCnttMap.put("CUST_ID_VALUE", "99999999999");
		// 取系统时间
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		oprCnttMap.put("OP_TIME", sCurTime);
		preOrder.sendOprCntt(oprCnttMap);
		S8290PrintOutDTO outDto = new S8290PrintOutDTO();
		outDto.setInvNoOccupy(invNoOccupy);
		return outDto;
	}

	public IUser getUser() {
		return user;
	}

	public void setUser(IUser user) {
		this.user = user;
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

	public IAccount getAccount() {
		return account;
	}

	public void setAccount(IAccount account) {
		this.account = account;
	}


	public IInvPrint getInvPrint() {
		return invPrint;
	}

	public void setInvPrint(IInvPrint invPrint) {
		this.invPrint = invPrint;
	}

	public IInvoice getInvoice() {
		return invoice;
	}

	public void setInvoice(IInvoice invoice) {
		this.invoice = invoice;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}

}
