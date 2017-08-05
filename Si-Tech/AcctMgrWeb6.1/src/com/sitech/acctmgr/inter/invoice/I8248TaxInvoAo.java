package com.sitech.acctmgr.inter.invoice;

import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

public interface I8248TaxInvoAo {
	/**
	 *
	 * <p>
	 * Title: 查询具有增值税资质的账户
	 * </p>
	 * <p>
	 * Description: 根据cust_id查询底下的所有账户信息
	 * </p>
	 * <p>
	 * Copyright: Copyright (c) 2014
	 * </p>
	 * <p>
	 * Company: SI-TECH
	 * </p>
	 * 
	 * @param LOGIN_NO
	 *            :工号
	 * @param PHONE_NO
	 *            :查询号码
	 * @param GROUP_ID
	 *            :组织编码
	 * @return LIST.MAP.CONTRACT_NO :账户号
	 * @return LIST.MAP.TAXPAYER_ID :纳税人资质
	 * @return LIST.MAP.TAXPAYER_ID :纳税人资质
	 * @author liuhl_bj
	 * @version 1.0
	 */
	public OutDTO qryAcctNo(InDTO inParam);

	/**
	 * 查询发票信息，按照税率分开，可以为多个账户
	 * 
	 * @param inParam
	 * @return
	 */
	public OutDTO qryInvo(InDTO inParam);

	/**
	 * 入发票记录表bal_invprint_info，bal_taxinvoice_info和审核表bal_invaudit_info
	 * 
	 * @param inParam
	 * @return
	 */
	public OutDTO cfmBOSS(InDTO inParam);

	/**
	 * 查询增值税发票的审批工号
	 * 
	 * @param inParam
	 * @return
	 */
	public OutDTO qryLoginNo(InDTO inParam);


	/**
	 * 查询红字发票作废原因
	 * 
	 * @author liuhl_bj
	 * @param inParam
	 * @return
	 */
	OutDTO queryRedReason(InDTO inParam);

	/**
	 * 红字专票申请,由于在开具时判断是作废还是开具红字发票，所以统一做红票申请
	 *
	 * @author liuhl_bj
	 * 
	 * @param inParam
	 * @return
	 */
	OutDTO redInvoiceReq(InDTO inParam);

	/**
	 * 名称：查询此工号下的流转信息 <br>
	 * 待处理：查询未处理完的，已处理：查询已处理完成的（state=9或者a）
	 * 
	 * @author liuhl_bj
	 * @param inParam
	 * @return
	 */
	OutDTO invoiceFlowInfo(InDTO inParam);

	/**
	 * 名称：根据流水查询发票上的发票费用
	 * 
	 * @param inParam
	 * @return
	 */
	OutDTO invoiceFeeInfo(InDTO inParam);

	/**
	 * 名称：数据重置
	 * 
	 * @param inParam
	 * @return
	 */
	OutDTO dataReset(InDTO inParam);

	/**
	 * 名称：确认流程结束
	 * 
	 * @param inParam
	 * @return
	 */
	OutDTO flowOverCfm(InDTO inParam);

	/**
	 * 一点支付账户查询增值税发票记录
	 * 
	 * @param inParam
	 * @return
	 */
	OutDTO qryInvNoForOnePay(InDTO inParam);
	
	/**
	 * 名称：增值税专票查询
	 * 
	 * @author yucl
	 * @param inParam
	 * @return
	 */
	OutDTO invoiceTaxQryInfo(InDTO inParam);


}