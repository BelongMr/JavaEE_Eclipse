package com.sitech.acctmgr.atom.busi.invoice.inter;

import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.invoice.BaseInvoiceDispEntity;
import com.sitech.acctmgr.atom.domains.user.VirtualGrpEntity;

/**
 * 获取发票打印的头信息，包括发票的打印日期，发票号码，客户名称，客户品牌，业务类别
 * 
 * @author liuhl_bj
 *
 */
public interface IPreInvHeader {

	/**
	 * 名称：获取发票上展示的基本发票信息
	 * 
	 * @author liuhl_bj
	 * 
	 * @return
	 */
	BaseInvoiceDispEntity queryBaseInvInfo(Map<String, Object> inParam);

	/**
	 * 查询集团发票的基本信息
	 * 
	 * @param inMap
	 * @return
	 */
	BaseInvoiceDispEntity queryBaseInvInfoOfGrp(Map<String, Object> inMap);


	public List<VirtualGrpEntity> getUserInfoByVtrBloc(long unitId, String phoneNo);

	/**
	 * 名称：取虚拟集团名称
	 */
	String getVirtualName(long unitId);



}
