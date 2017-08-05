package com.sitech.acctmgr.atom.entity.inter;

import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.invoice.ActCollbillprintRecd;
import com.sitech.acctmgr.atom.domains.invoice.BalGrppreinvInfo;
import com.sitech.acctmgr.atom.domains.invoice.BalInvauditInfo;
import com.sitech.acctmgr.atom.domains.invoice.BalInvprintInfoEntity;
import com.sitech.acctmgr.atom.domains.invoice.BalInvprintdetInfo;
import com.sitech.acctmgr.atom.domains.invoice.BalTaxinvoicePre;
import com.sitech.acctmgr.atom.domains.invoice.InvBillCycleEntity;
import com.sitech.acctmgr.atom.domains.invoice.InvoInfoEntity;
import com.sitech.acctmgr.atom.domains.invoice.LoginNoInfo;
import com.sitech.acctmgr.atom.domains.invoice.PreInvoiceRecycleEntity;
import com.sitech.acctmgr.atom.domains.invoice.TaxInvoiceFeeEntity;
import com.sitech.acctmgr.atom.domains.invoice.TtWcityinvoice;
import com.sitech.acctmgr.atom.domains.invoice.TtWdisinvoice;
import com.sitech.acctmgr.atom.domains.invoice.TtWgroupinvoice;
import com.sitech.acctmgr.atom.domains.invoice.elecInvoice.EInvPdfEntity;
import com.sitech.acctmgr.atom.domains.invoice.elecInvoice.InvoiceXhfInfo;

/**
 * 发票相关的函数
 * 
 * @author liuhl_bj
 *
 */
public interface IInvoice {


	/**
	 * 名称：根据inv_no查询发票信息
	 * 
	 * @author liuhl_bj
	 * 
	 * @param inMap
	 * @return
	 */
	Map<String, Object> getInvoInfo(Map<String, Object> inMap, int pageNum, int pageSize);

	/**
	 * 名称：根据inv_no查询发票信息
	 * 
	 * @author liuhl
	 * @param inMap
	 * @return
	 */
	List<BalInvprintInfoEntity> getInvoInfoByInvNo(Map<String, Object> inMap);

	/**
	 * 名称：更新发票记录总表中的状态
	 * 
	 * @param inMap
	 */
	void updateStateByInvNo(Map<String, Object> inMap);

	/**
	 * 名称：判断该笔缴费是否已经打印过月结发票 0：未打印 1：打印过
	 * 
	 * @author liuhl
	 * @param inMap
	 * @return
	 */
	int isPrintMonthInvoice(Map<String, Object> inMap);

	/**
	 * 名称：判断该月是否打印过月结发票（用于月结发票时）
	 * 
	 * @param billCycle
	 * @param contractNo
	 * @return
	 */
	boolean isPrintMonthInvoice(int billCycle, long contractNo, int suffix);

	/**
	 * 查询实时销帐待处理数据，0标识已经处理完成 名称：
	 * 
	 * @param
	 * @return
	 * @throws Exception
	 * @author LIJXD
	 */
	public int getWritoffCnt(long contractNo);

	public long getPrintSn();

	/**
	 * 修改账本的print_flag
	 * 
	 * @param lPaySn
	 * @param lContractNo
	 * @param lIdNo
	 * @param printSn
	 */
	public void upPrintFlagByPrestore(long lPaySn, long lContractNo, long lIdNo, long printSn);

	/**
	 * 修改账本的print_flag和冲销记录表中的打印标志
	 * 
	 * @param paySn
	 * @param contractNo
	 * @param idNo
	 * @param printSn
	 * @param userFlag
	 */
	public void upPrintFlagByPrestore(long paySn, long contractNo, long idNo, long printSn, String userFlag);

	public List<Map<String, Object>> qryPayOutWithBalanceByPayFee(int iNaturalMon, long balanceId, long payFee);

	public void updataInvprint(final Map<String, Object> inParam);


	/**
	 * 保存xml文件
	 * 
	 * @param printSn
	 * @param yearMonth
	 * @param printXmlStr
	 */
	public void insDetXml(long printSn, int yearMonth, String printXmlStr);


	/**
	 * 名称：查询所有发票模版ID<br/>
	 * 
	 * @return LIST.MAP.PRINT_MODEL_ID : 发票模板号
	 * @return LIST.MAP.PRINT_TYPE : 发票模板类型号
	 * @return LIST.MAP.OP_CODE : 操作代码号
	 * @throws
	 * @author fanck
	 */
	public List<Map<String, Object>> getAllPrintModelId();


	/**
	 * 名称：查询发票模版ID<br/>
	 * 
	 * @param OP_CODE
	 *            : 模块号
	 * @param PRINT_TYPE
	 *            : 打印类型
	 * @return PRINT_MODEL_ID : 发票模板号
	 * @throws
	 * @author fanck
	 */
	public String getPrintModelId(String sOpCode, String sPrintType);

	public Map<String, Object> getPrintModel(String sModelID);

	public void oprVirtualBloc(long printSn, int qryMon, String loginNo);

	public void dealWriteoffForZf(List<InvoInfoEntity> invList, int payYm);

	/** 查询根据缴费流水查询发票打印记录 **/
	public List<InvoInfoEntity> getInvOfRelatePaySn(long paySn, int yearMon, long contractNo);


	/**
	 * 名称：查询缴费发票的打印标志
	 * 
	 * @param paySn
	 * @param yearMonth
	 * @return
	 */
	int getPrintFlag(long paySn, int yearMonth, long contractNo);

	/**
	 * 名称：入发票记录总表
	 * 
	 * @author liuhl
	 * @param balInvprintInfoList
	 */
	void iBalInvprintInfo(List<BalInvprintInfoEntity> balInvprintInfoList);

	/**
	 * 名称：入发票记录明细表
	 * 
	 * @author liuhl
	 * @param balInvprintdetInfoList
	 */
	void iBalInvprintdetInfo(List<BalInvprintdetInfo> balInvprintdetInfoList);

	/**
	 * 名称：更新发票状态
	 * 
	 * @author liuhl
	 */
	void updatePrintFlagByPre(long paySn, long printSn, String payType, int billCycle, long contractNo);

	/**
	 * 名称：查询发票记录总表中的发票信息
	 * 
	 * @author liuhl
	 * @param inParam
	 * @return
	 */
	BalInvprintInfoEntity qryInvoiceInfo(Map<String, Object> inParam);

	/**
	 * 名称：更新发票打印张数
	 * 
	 * @author liuhl
	 * @param SUFFIX
	 *            :打印时间
	 * @param PAY_SN
	 *            ：缴费流水
	 */
	void upPrintSeq(Map<String, Object> inParam);

	/**
	 * 名称：获取发票上的备注信息
	 * 
	 * @author liuhl
	 * @param inParam
	 * @return
	 */
	String getInvRemark(Map<String, Object> inParam);

	/**
	 * 名称：查询是否打印过预存发票
	 * 
	 * @author liuhl
	 * @param inMap
	 * @return
	 */
	int isPrintPreInvoice(Map<String, Object> inMap);

	/**
	 * 名称：插入集团发票记录表
	 * 
	 * @author liuhl
	 * @param balGrpPreinvInfo
	 */
	void iBalGrppreInvInfo(BalGrppreinvInfo balGrpPreinvInfo);

	/**
	 * 名称：集团发票打印取消修改集团发票打印记录表中的状态
	 * 
	 * @author liuhl
	 * @param inMap
	 */
	void updateGrpPrintState(Map<String, Object> inMap);

	/**
	 * 名称：从集团打印发票记录表中查询是否有记录
	 * 
	 * @author liuhl
	 * @param inMap
	 * @return
	 */
	int qryCntGrp(Map<String, Object> inMap);

	/**
	 * 名称：集团发票记录表中的记录，记录到历史表
	 * 
	 * @author liuhl
	 * 
	 * @param inMap
	 */
	void bakGrpPreInv(Map<String, Object> inMap);

	/**
	 * 名称：月结发票更新冲销表中的状态
	 * 
	 * @author liuhl
	 * @param billCycle
	 */
	void updatePrintFlagByMonth(int billCycle, long contractNo, long printSn);

	/**
	 * 名称：获取合并打印时的账期区间
	 * 
	 * @author liuhl
	 * @param billCycleList
	 * @return
	 */
	Map<String, Object> getPrintBillCycle(List<InvBillCycleEntity> billCycleList);

	/**
	 * 功能：查询预开发票打印记录
	 * 
	 * @author liuhl
	 * @param unitId
	 * @param billCycle
	 * @return
	 */
	List<PreInvoiceRecycleEntity> getPreInvoiceRecycleTotal(long unitId, int billCycle);

	/**
	 * 功能：查询预开发票打印记录明细
	 * 
	 * @author liuhl
	 * 
	 * @param unitId
	 * @param printSn
	 * @return
	 */
	List<PreInvoiceRecycleEntity> getPreInvoiceRecycleDetail(long unitId, long printSn);


		/**
	 * 功能：查询地址信息
	 * 
	 * @param regionId
	 * @param groupId
	 * @param busiGroupId
	 * @return
	 */
	Map<String, String> getAddressInfo(String regionId, String groupId, String busiGroupId);



	/**
	 * 查询审批工号
	 * 
	 * @param loginType
	 * @param groupId
	 * @param loginNo
	 * @return
	 */
	List<LoginNoInfo> getInvLoginByGroup(String loginType, String groupId, String loginNo);


	/**
	 * 查询开票员工号
	 * 
	 * @param inParam
	 * @return
	 */
	Map<String, Object> getReportMap(Map<String, Object> inParam);


	/**
	 * 更新增值税发票状态
	 * 
	 * @param orderSn
	 * @param yearMon
	 * @param state
	 */
	void upAuditInvoState(long orderSn, int yearMon, String state);



	/**
	 * 更新bal_invaddtaxprint_info表中的state，inv_code和inv_no
	 * 
	 * @author liuhl_bj
	 * @param state
	 * @param invCode
	 * @param invNo
	 * @param printSn
	 */
	void updateAddPrintInfo(String state, String invCode, String invNo, long printSn, String invType);

	/**
	 * 判断能否进行红票申请或者作废申请
	 * 
	 * @author liuhl_bj
	 * @param auditSn
	 * @return
	 */
	int isApplyRed(long auditSn);

	/**
	 * 红票申请或者作废申请记录发票审批表
	 * 
	 * @author liuhl_bj
	 * @param orderSn
	 * @param loginNo
	 * @param reportNo
	 * @param auditSnNew
	 */
	void insertAuditInfo(long orderSn, String loginNo, String reportNo, long auditSnNew);

	/**
	 * 红票申请入发票记录表bal_invaddtaxprint_info
	 * 
	 * @author liuhl_bj
	 * @param inMap
	 */
	void insertAddinvPrint(Map<String, Object> inMap);

	/**
	 * 获取上笔缴费的流水和时间
	 * 
	 * @author liuhl_bj
	 * @param opCode
	 * @param contractNo
	 * @param yearMonth
	 * @return
	 */
	Map<String, Object> getLastPay(String opCode, long contractNo, int yearMonth);

	/**
	 * 更新账本表记录
	 * 
	 * @param paySn
	 * @param printSn
	 * @param payType
	 * @param billCycle
	 * @param contractNo
	 * @param printFlag
	 */
	void updatePrintFlagByPre(long paySn, long printSn, String payType, int billCycle, long contractNo, String printFlag);

	/**
	 * 入发票审核记录表
	 * 
	 * @author liuhl_bj
	 * @param balInvAudit
	 */
	void insertInvAudit(BalInvauditInfo balInvAudit);

	/**
	 * 入增值税发票明细表
	 * 
	 * @author liuhl_bj
	 * @param taxInvoiceFee
	 */
	void insertTaxPrint(TaxInvoiceFeeEntity taxInvoiceFee);

	/**
	 * 查询增值税发票审核信息
	 * 
	 * @author liuhl_bj
	 * @param inMap
	 * @return
	 */
	List<BalInvauditInfo> getAuditInfoList(Map<String, Object> inMap);

	/**
	 * 查询增值税发票上的费用信息
	 * 
	 * @author liuhl_bj
	 * @param printSn
	 * @return
	 */
	List<TaxInvoiceFeeEntity> getInvoiceFeeList(long printSn, String requestSn);

	/**
	 * 红字发票申请入申请表
	 * 
	 * @param auditInfo
	 */
	void insertAuditForRed(BalInvauditInfo auditInfo);

	/**
	 * 增值税发票更新冲销表中的记录<br>
	 * 根据发票打印记录表中记录的contract_no和bill_cycle 更新
	 * 
	 * @param printSn
	 * @param opTime
	 */
	void updateWriteFlag(long printSn, String opTime);

	/**
	 * 更新发票记录表中的state
	 * 
	 * @param inMap
	 */
	void updateState(Map<String, Object> inMap);

	/**
	 * 更新审核表中的state
	 * 
	 * @param inMap
	 */
	void updateAuditState(Map<String, Object> inMap);

	/**
	 * 获取位置名称
	 * 
	 * @param state
	 * @return
	 */
	String getPositionName(String state);

	/**
	 * 红字发票打印需要的金额
	 * 
	 * @param printSn
	 * @return
	 */
	List<TaxInvoiceFeeEntity> getInvoiceFeeForRedList(long printSn);

	/**
	 * 托收单打印入表ACT_COLLBILLPRINT_RECD
	 * 
	 * @param accCollBillEnt
	 */
	void insCollBillPrintRecd(ActCollbillprintRecd accCollBillEnt);

	/**
	 * 判断是否为手机支付缴话费，如果是不允许打印发票
	 * 
	 * @param suffix
	 * @param fieldValue
	 * @param fieldCode
	 * @return
	 */
	boolean isPhonePay(String suffix, String fieldValue, String fieldCode, long paySn);

	/**
	 * 判断是否为微信支付，如果为微信支付，发票展示微信支付，需要等qiaolin确定取值方式之后完善
	 * 
	 * @author liuhl_bj
	 * @param inMap
	 * @return
	 */
	boolean isWechatPay(Map<String, Object> inMap);
	
	/**
	 * 预开发票回收 更新发票打印记录表中PAY_SN字段
	 * 
	 * @author qiaolin
	 * @param inMap
	 * @return
	 */
	void upPaysn(Map<String, Object> inMap);

	/**
	 * 查询地市铁通宽带发票录入信息
	 * 
	 * @author liuhl_bj
	 * @param invCode
	 * @param groupId
	 *            地市的group_id
	 * @return
	 */
	List<TtWcityinvoice> getCityInovice(String invCode, String groupId);

	/**
	 * 铁通宽带入发票录入记录表
	 * 
	 * @author liuhl_bj
	 * @param cityInv
	 */
	void insCityInvoice(TtWcityinvoice cityInv);
	
	/**
	 * 铁通宽带区县发票录入信息
	 * 
	 * @author liuhl_bj
	 * @param invCode
	 * @param groupId
	 * @return
	 */
	List<TtWdisinvoice> getDistinctInvoice(String invCode, String groupId, String disGroupId);

	/**
	 * 记录区县发票录入表
	 * 
	 * @author liuhl_bj
	 * @param disInv
	 */
	void insDisInvoice(TtWdisinvoice disInv);
	
	/**
	 * 查询该区县下已经预占的发票
	 * 
	 * @author liuhl_bj
	 * @param invCode
	 * @param regionGroup
	 * @param disGroupId
	 * @param groupId
	 * @return
	 */
	List<TtWgroupinvoice> getGroupInvoice(String invCode, String regionGroup, String disGroupId, String groupId);

	/**
	 * 记录营业厅发票录入表
	 * 
	 * @author liuhl_bj
	 * @param groupInv
	 */
	void insGroupInvoice(TtWgroupinvoice groupInv);

	/**
	 * 查询预开发票的发票记录
	 * 
	 * @param contractNo
	 * @param loginAccept
	 * @return
	 */
	Map<String, Object> getGrpPreInfo(long contractNo, long loginAccept, long paySn);

	/**
	 * 查询开具预存发票的发票代码和发票号码
	 * 
	 * @param paySn
	 * @param yearMonth
	 * @param contractNo
	 * @return
	 */
	Map<String, Object> getPrintInfo(long paySn, int yearMonth, long contractNo);

	/**
	 * 一笔缴费流水打印的月结发票或者增值税发票信息
	 * 
	 * @param paySn
	 * @param yearMonth
	 * @return
	 */
	Map<String, Object> getMonthInvoice(long paySn, int yearMonth, long contractNo);
	
	/**
	 * 退预存款增加打印增值税发票用户不可退限制
	 * 
	 * @param contractNo
	 * @return true:不做限制；false：做限制
	 * @author suzj
	 */
	boolean checkIncrementBack(long contractNo,String phoneNo);

	/**
	 * 增值税发票预开发票记录表
	 * 
	 * @param taxPre
	 */
	void insertTaxPre(BalTaxinvoicePre taxPre);

	/**
	 * 修改状态
	 * 
	 * @param printSn
	 * @param chnFlag
	 */
	void updateTaxPreStatus(long printSn, String chnFlag);

	/**
	 * 查询增值税预开发票信息
	 * 
	 * @param inMap
	 * @return
	 */
	List<BalTaxinvoicePre> taxInvoicePre(Map<String, Object> inMap);
	
	/**
	 * 查询是否预开发票
	 * 
	 * @author hanfl
	 * @param contractNo
	 * @return a:预开普通发票 b:预开增值税发票 null：没有预开发票
	 */
	String isPreInv(long contractNo);
	
	/**
	 * 预开普通发票回收
	 * 
	 * @author hanfl
	 * @param contractNo
	 * @return
	 */
	void grpPreInvCollection(Map<String ,Object> headerMap,Map<String ,Object> inMap);
	
	/**
	 * 预开增值税发票回收
	 * 
	 * @author hanfl
	 * @param contractNo
	 * @return
	 */
	void preTaxInvCollection(Map<String ,Object> inMap);
	
	/**
	 * 预开发票回收（包括增值税发票和普通发票）
	 * 
	 * @author hanfl
	 * @param headerMap
	 *            inMap
	 * @param flag
	 *            为a时，回收普通发票，flag为b时，回收增值税发票
	 * @return
	 */
	void preInvCollection(Map<String ,Object> headerMap,Map<String ,Object> inMap,String flag);
	
	/**
	 * 名称：增值税发票预开更新
	 * 
	 * @author hanfl
	 * @param inMap
	 * @return
	 */
	void uPreTaxInv(Map<String, Object> inMap);
	
	/**
	 * 查询发票打印记录
	 * 
	 * @author liuhl_bj
	 * @param inParam
	 * @return
	 */
	List<BalInvprintInfoEntity> qryInvoiceInfoList(Map<String, Object> inParam);

	// 以下是电子发票所用到的函数接口，关于普通发票的函数请往上边添，后续被删了不负责

	/**
	 * 获取发票销货方信息
	 * 
	 * @author liuhl_bj
	 * @param regionCode
	 * @return
	 */
	InvoiceXhfInfo getInvoicexhfInfo(String regionCode);
	
	
	
	/**
	 * 记录pdf的信息
	 * 
	 * @param requestSn
	 * @param pdfFile
	 * @param invCode
	 * @param invNo
	 * @param loginNo
	 */
	void insertPDFInfo(EInvPdfEntity pdfEnt);

}