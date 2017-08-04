package com.sitech.acctmgr.atom.impl.invoice;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.invoice.BalInvauditInfo;
import com.sitech.acctmgr.atom.domains.invoice.BalTaxinvoicePre;
import com.sitech.acctmgr.atom.dto.invoice.S2318QueryInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S2318QueryOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IInvoice;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.inter.invoice.I2318;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

@ParamTypes({ @ParamType(c = S2318QueryInDTO.class, m = "query", oc = S2318QueryOutDTO.class) })
public class S2318 extends AcctMgrBaseService implements I2318 {
	private IAccount account;
	private IInvoice invoice;
	private IUser user;
	@Override
	public OutDTO query(InDTO inParam) {
		S2318QueryInDTO inDto = (S2318QueryInDTO) inParam;

		String invCode = inDto.getInvCode();
		String invNo = inDto.getInvNo();

		// 设置输入参数
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("INV_NO", invNo);
		inMap.put("INV_CODE", invCode);
		
		// 获取待审计的账号信息
		List<BalInvauditInfo> auditList = invoice.getAuditInfoList(inMap);
		// 增值税预打印信息
		List<BalTaxinvoicePre> taxInvoicePreList = new ArrayList<BalTaxinvoicePre>();		

		for (BalInvauditInfo auditInfo : auditList) {			
			// 获取流水号
			String printSn = auditInfo.getPrintSn();
			inMap.put("INVOICE_ACCEPT", printSn);
			inMap.put("STATUS", "p");
			inMap.put("CHG_FLAG", "1");
			// 发票预打印
			List<BalTaxinvoicePre> taxInvoicePreListTmp = invoice.taxInvoicePre(inMap);
			
			for(BalTaxinvoicePre taxInvoicePreItem:taxInvoicePreListTmp){		
				int flag = 0;
				long contractNo = taxInvoicePreItem.getContractNo();
				// 判断是否是集团账户
				boolean flagTmp = account.isGrpCon(contractNo);
				if (flagTmp) { 
					flag = 1; 
				}
				// 一点支付账户
				inMap.put("CONTRACT_NO", contractNo); 
				inMap.put("CONTRACTATT_TYPE", "A"); 
				ContractInfoEntity onePayInfo = account.getConInfo(inMap); 		
				if (onePayInfo != null) { 
					flag = 2; 
				}
				taxInvoicePreItem.setUserFlag(flag);

			}
			taxInvoicePreList.addAll(taxInvoicePreListTmp);
		}
		S2318QueryOutDTO outDto = new S2318QueryOutDTO();
		outDto.setTaxInvoicePreList(taxInvoicePreList);
		return outDto;
	}

	public IInvoice getInvoice() {
		return invoice;
	}

	public void setInvoice(IInvoice invoice) {
		this.invoice = invoice;
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
	

}
