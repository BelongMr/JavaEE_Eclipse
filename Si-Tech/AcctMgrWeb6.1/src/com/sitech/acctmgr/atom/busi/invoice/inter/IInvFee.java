package com.sitech.acctmgr.atom.busi.invoice.inter;

import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.balance.TransFeeEntity;
import com.sitech.acctmgr.atom.domains.invoice.PreInvoiceDispEntity;
import com.sitech.acctmgr.atom.domains.invoice.TaxInvoiceFeeEntity;

/**
 *
 * <p>
 * Title:
 * </p>
 * <p>
 * Description:
 * </p>
 * <p>
 * Copyright: Copyright (c) 2014
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 * 
 * @author
 * @version 1.0
 */
public interface IInvFee {
	/**
	 * 预存发票上展示的金额
	 * 
	 * @author liuhl_bj
	 * @param inParam
	 * @return
	 */
	PreInvoiceDispEntity getPreInvoiceFee(Map<String, Object> inParam);


	/**
	 * 查询月结发票上展示的费用信息
	 * 
	 * @author liuhl_bj
	 * @param inParam
	 * @return
	 */
	Map<String, Object> getMonthInvoiceFee(Map<String, Object> inParam);


	/**
	 * 查询多账户在多账期内的增值税发票总金额（按税率和pay_type分开，主要是为了入bal_invtaxprint_info）
	 * 
	 * @author liuhl_bj
	 * @param invoiceFeeDetailList
	 * 
	 * @return
	 */
	List<TaxInvoiceFeeEntity> getTaxInvoFeeTotalForTaxPrint(List<TaxInvoiceFeeEntity> invoiceFeeDetailList);

	/**
	 * 查询账户在账期内的使用的增值税发票冲销信息（按账户，账期，税率分开）
	 * 
	 * @author liuhl_bj
	 * @param contractStr
	 * @param beginYm
	 * @param endYm
	 * @return
	 */
	List<TaxInvoiceFeeEntity> getTaxInvoFeeDetail(String contractStr, int beginYm, int endYm);

	/**
	 * 查询某一账户在账期内的发票金额（按账户和账期分开，主要是为了入bal_invprint_info表）
	 * 
	 * @author liuhl_bj
	 * @param contractStr
	 * @param beginYm
	 * @param endYm
	 * @return
	 */
	List<TaxInvoiceFeeEntity> getTaxInvoFeeTotalForInvPrint(List<TaxInvoiceFeeEntity> invoiceFeeDetailList);

	/**
	 * 查询一点支付账户子账户的的冲销记录
	 * 
	 * @author liuhl_bj
	 * @param transFeeList
	 * @param beginYm
	 * @param endYm
	 * @return
	 */
	List<TaxInvoiceFeeEntity> getTaxInvoFeeDetail(List<TransFeeEntity> transFeeList, int beginYm, int endYm);

	/**
	 * 查询统付账户子账户的冲销记录
	 * 
	 * @author liuhl_bj
	 * @param contractStr
	 * @return
	 */
	List<TaxInvoiceFeeEntity> getSubTaxInvoFeeDetail(List<TransFeeEntity> transFeeList);

	/**
	 * 查询预开增值税发票的账单pay_type默认为0
	 * 
	 * @param contractNo
	 * @param beginYm
	 * @param endYm
	 * @return
	 */
	List<TaxInvoiceFeeEntity> getUnPayInvoFee(String contractNo, int beginYm, int endYm);

}
