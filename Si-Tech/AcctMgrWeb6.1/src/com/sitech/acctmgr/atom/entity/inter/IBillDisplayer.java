package com.sitech.acctmgr.atom.entity.inter;

import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.balance.BookTypeEnum;
import com.sitech.acctmgr.atom.domains.bill.*;

/**
 * @Description: 帐单展示功能类
 * @author: wangyla
 * @version:
 * @createTime: 2015-5-11 下午5:55:18
 */

public interface IBillDisplayer {

	/**
	 * 功能：获取用户帐单展示中七大类费用
	 * 
	 * @param id
	 *            用户ID
	 * @param queryYM
	 *            查询月份
	 * @return BillFeeInfo
	 */
	BillFeeInfo getBillFee(long id, int queryYM);

	/**
	 * 功能：获取用户帐单七大类费用，每类费用均由应收，优惠及实收组成
	 * 
	 * @param id
	 *            用户ID
	 * @param queryYM
	 *            查询月份
	 * @return BillFeeInfo2
	 */
	BillFeeInfo2 getBillFee2(long id, int queryYM);

	/**
	 * 功能：获取用户指定月份被代付费用
	 * 
	 * @param idNo
	 * @param yearMonth
	 * @return PERSON_AGENT -普通帐户为此用户代付金额<br>
	 *         GROUP_AGENT -集团帐户为此用户代付金额
	 *         <p>
	 *         代付费用为实际帐单需支付费用，即（应收 - 优惠）
	 *         </p>
	 */
	Map<String, BillFeeEntity> getAgentFeeInfo(long idNo, int yearMonth);

	/**
	 * 功能：获取用户的资费推荐信息
	 * 
	 * @param phoneNo
	 * @param brandId
	 * @param regionCode
	 * @param fee
	 * @return
	 */
	String getSchemeInfo(String phoneNo, String brandId, String regionCode, Long fee);

	/**
	 * 功能：获取用户GPRS资费推荐信息
	 * 
	 * @param phoneNo
	 * @param yearMonth 统计月份
	 * @return
	 */
	SchemeInfoEntity getGprsSchemeInfo(String phoneNo, int yearMonth);

	/**
	 * 功能：帐单打印中帐户收支明细信息
	 * @param idNo
	 * @param yearMonth
     * @return
     */
	ConDetailDispEntity getContractDetail(long idNo, Integer yearMonth);

	/**
	 * 获取帐户支出（冲销）金额
	 *
	 * @param contractNo
	 * @param idNo
	 * @param yearMonth
	 * @param balanceType
	 * @return
	 */
	List<FeeEntity> getOutFee(Long contractNo, Long idNo, Integer yearMonth, BookTypeEnum balanceType);

	long getOutFee(Long contractNo, Integer yearMonth, BookTypeEnum balanceType);

	/**
	 * 功能：获取用户指定帐期的帐单附录页信息
	 * 
	 * @param id
	 * @param queryYM
	 * @return
	 */
	List<AppendixBill> getDetailBillInfo(long id, int queryYM);


	/**
	 * 功能：代收业务费用
	 * 
	 * @param phoneNo
	 * @param idNo
	 * @param yearMonth
	 * @return
	 */
	SpDispEntity getSpDetailinfo(String phoneNo, Long idNo, int yearMonth);

	/**
	 * 功能：帐户入帐明细
	 * 
	 * @param con
	 * @param yearMonth
	 * @return
	 */
	List<IncomeBill> getDetailIncome(long con, Integer yearMonth);

	/**
	 * 获取帐单附录页入帐明细信息
	 * @param idNo
	 * @param yearMonth
     * @return
     */
	ConDetailAppendixDispEntity getAppendixConDetailInfo(long idNo, Integer yearMonth);

	/**
	 * 功能：从帐单中单表获取用户指定帐期指定七大类的帐单列表
	 * <p>
	 * 注意：不能单独使用此函数；使用此函数前必须先调用saveMidAllBillFee
	 * </p>
	 * 
	 * @param idNo
	 * @param contractNo
	 * @param yearMonth
	 * @param parentItemId
	 * @return
	 */
	List<BillDispEntity> getBillDetail(Long idNo, Long contractNo, int yearMonth, String parentItemId);

	/**
	 * 功能：获得七大类帐单及各大类的二级帐单明细信息
	 * <p>
	 * 注意：只返回有记录的七大类数据
	 * </p>
	 * 
	 * @param idNo
	 * @param contractNo
	 * @param yearMonth
	 * @param feeCode
	 *            一级帐目项，可空，适用于按特殊帐目项单类查询
	 * @return
	 */
	List<SevenBillDispEntity> getSevenBill(Long idNo, Long contractNo, int yearMonth, String feeCode);

	/**
	 * 功能：获得离网用户七大类帐单及各大类的二级帐单明细信息
	 * <p>
	 * 注意：只返回有记录的七大类数据
	 * </p>
	 * 
	 * @param idNo
	 * @param contractNo
	 * @param yearMonth
	 * @param feeCode
	 *            一级帐目项，可空，适用于按特殊帐目项单类查询
	 * @return
	 */
	List<SevenBillDispEntity> getSevenBillDead(Long idNo, Long contractNo, int yearMonth, String feeCode);

	/**
	 * 功能：获取用户指定月份全等级（共3级）展示帐单列表信息
	 * 
	 * @param id
	 * @param contractNo
	 * @param queryYM
	 * @return
	 */
	List<BillDisp1LevelEntity> getBill3sLevelList(Long id, Long contractNo, int queryYM);

	/**
	 * 功能：获取用户指定月份一三级展示帐单列表信息
	 * @param id
	 * @param contractNo
	 * @param queryYm
     * @return
     */
	List<BillDisp13LevelEntity> getBill13sLevelList(long id, long contractNo, int queryYm);

	/**
	 * 将帐户下的账单插入到中间表
	 * 
	 * @param inParam
	 *            <ul>
	 *            <li>YEAR_MONTH <i>STRING</i> 帐务年月，格式YYYYMM。例如：201409</li>
	 *            <li>CONTRACT_NO <i>LONG</i> 帐务标识</li>
	 *            <li>ID_NO <i>LONG</i> 用户标识</li>
	 *            <li>CUR_YM <i>INTEGER</i> 当前年月</li>
	 *            <li>STATUS_FLAG <i>INTEGER </i>已缴/未缴帐单</li>
	 *            </ul>
	 * @return void
	 */
	void saveMidBillFee(Map<String, Object> inParam);

	/**
	 * 按帐单状态取七大类帐单
	 * 
	 * @param inParam
	 *            <ul>
	 *            <li>ID_NO <i>LONG</i> 用户标识</li>
	 *            <li>STATUS<i>INTEGER </i>2 已缴/ 1未缴帐单</li>
	 *            <li>BILL_CYCLE <i>INTEGER</i> 帐务年月，格式YYYYMM。例如：201409</li>
	 *            </ul>
	 */
	List<StatusBillInfoEntity> getStatusBillInfo(Map<String, Object> inParam);

	/**
	 * 按帐单状态取七大类帐单明细
	 * 
	 * @param inParam
	 *            <ul>
	 *            <li>ID_NO <i>LONG</i> 用户标识</li>
	 *            <li>BILL_CYCLE <i>INTEGER</i> 帐务年月，格式YYYYMM。例如：201409</li>
	 *            <li>CONTRACT_NO <i>LONG</i> 帐务标识 可空</li>
	 *            </ul>
	 */
	List<StatusDispBill> getStatusBillDetail(Map<String, Object> inParam);

	/**
	 * 按照账单状态取陈死账七大类账单
	 * 
	 * @param idNo
	 * @param contractNo
	 * @param billCycle
	 * @return
	 */
	List<BadSevenBillEntity> getStatusBadSevenBill(Long idNo, Long contractNo, int billCycle);

	/**
	 * 名称：按照集团账户和年月查询集团账单
	 * 
	 * @param contractNo
	 * @param billCycle
	 * @return
	 */
	Map<String, List<GrpBillDispByStatusEntity>> getStatusGrpBill(long contractNo, int billCycle);

	/**
	 * 名称：按照集团账户和年月查询集团账单，可以指定获取明细或汇总
	 * 
	 * @param contractNo
	 * @param billCycle
	 * @param status
	 *            0：全部 1：已缴 2：未缴
	 * @param flag
	 *            0：全部 1：明细
	 * @return
	 */
	Map<String, List<GrpBillDispByStatusEntity>> getStatusGrpBill(long contractNo, int billCycle, int status, int flag);

	/**
	 * 名称： 按照七大类，查询七大类明细信息
	 *
	 * @param lIdNo
	 *            :用户号码 lContractNo: 账户号码（可空） iBillCycle: 账期 sStatus: 2：已缴、0：未缴
	 * @return
	 * @throws Exception
	 * @author liuhl
	 */
	Map<String, Object> getSevenDetailBill(long lIdNo, long lContractNo, int iBillCycle, String sStatus, boolean isOnline);

	/**
	 * 名称： 按照七大类，查询七大类呆坏账明细信息
	 *
	 * @param lIdNo
	 *            :用户号码 lContractNo: 账户号码 iBillCycle: 账期
	 * @return
	 * @throws Exception
	 * @author liuhl
	 */
	Map<String, Object> getSevenDeadDetailBill(long lIdNo, long lContractNo, int iBillCycle);
	
	/**
	 * 将帐户下的账单插入到中间表
	 * 
	 * @param inParam
	 *            <ul>
	 *            <li>YEAR_MONTH <i>STRING</i> 帐务年月，格式YYYYMM。例如：201409</li>
	 *            <li>CONTRACT_NO <i>LONG</i> 帐务标识</li>
	 *            <li>ID_NO <i>LONG</i> 用户标识</li>
	 *            <li>STATUS_FLAG <i>INTEGER </i>已缴/未缴帐单</li>
	 *            </ul>
	 * @return void
	 */
	void saveMidDeadBillFee(Map<String, Object> inParam) ;
	
	/**
	 * 按帐单状态取七大类帐单明细
	 * @param inParam
	 * <ul>
	 * <li>ID_NO <i>LONG</i> 用户标识</li>
	 * <li>BILL_CYCLE <i>INTEGER</i> 帐务年月，格式YYYYMM。例如：201409</li>
	 * <li>CONTRACT_NO <i>LONG</i> 帐务标识 可空</li>
	 * </ul>
	 */
	List<StatusDispBill> getStatusBillDetailForTwoLevel(Map<String, Object> inParam);
	
	
}