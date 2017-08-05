package com.sitech.acctmgr.atom.entity.inter;

import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.account.AccountListEntity;
import com.sitech.acctmgr.atom.domains.account.ConTrustEntity;
import com.sitech.acctmgr.atom.domains.account.ConUserRelEntity;
import com.sitech.acctmgr.atom.domains.account.ContractDeadInfoEntity;
import com.sitech.acctmgr.atom.domains.account.ContractEntity;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.account.CsAccountRelEntity;
import com.sitech.acctmgr.atom.domains.account.GrpConEntity;

/**
 * <p>
 * Title: 账户类
 * </p>
 * <p>
 * Description: 查询账户相关信息
 * </p>
 * <p>
 * Copyright: Copyright (c) 2016
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 *
 * @author zhangbine
 * @version 1.0
 */
public interface IAccount {

	/**
	 * 功能：查询在网账户基本信息
	 *
	 * @param inContractNo
	 *            账户标识
	 * @return
	 * @author zhangbine
	 */
	ContractInfoEntity getConInfo(long inContractNo);
	
	/**
	 * 功能：查询在网账户基本信息
	 *
	 * @param inContractNo 账户标识
	 * @param throwFlag    账户不存在是否throw异常
	 * @return
	 * @author zhangbine
	 */
	ContractInfoEntity getConInfo(long inContractNo, boolean throwFlag);
	
	/**
	 * 查询账户信息
	 * 
	 * @param inContractNo
	 * @param accountType
	 * @return
	 */
	ContractInfoEntity getConInfo(long inContractNo, String accountType);
	
	

	/**
	 * 功能：查询离网账户信息
	 *
	 * @param inContractNo
	 * @return
	 */
	ContractDeadInfoEntity getConDeadInfo(long inContractNo);

	/**
	 * 功能：验证用户和账户是否存在账务关系，或查询用户下代付账户的个数，或账户下费付用户的个数
	 *
	 * @param contractNo
	 * @param idNo
	 * @param yearMonth
	 * @return
	 */
	int cntConUserRel(Long contractNo, Long idNo, Integer yearMonth);

	/**
	 * 功能：验证账户是否有付费的默认用户
	 *
	 * @param contractNo
	 * @return
	 */
	boolean isDeflaultUser(long contractNo);

	/**
	 * 功能：取账户的默认用户 说明：没有默认用户返回null
	 * 
	 * @param contractNo
	 */
	String getDefaultPhone(long contractNo);

	/**
	 * 名称：获取账户缴费对应的用户 功能:按账户受理的缴费类业务，获取号码按照此规则获取
	 *
	 * @param lContractNo
	 * @return phoneNo 如果取不到则返回空字符串""
	 * @author qiaolin
	 */
	String getPayPhoneByCon(long lContractNo);

	/**
	 * 功能：获取用户ID指定生效月份的代付帐户列表
	 *
	 * @param idNo
	 *            用户标识
	 * @param yearMonth
	 *            查询账务关系的月份，传null时，返回所有代付帐户
	 * @return
	 */
	List<ContractEntity> getConList(Long idNo, Integer yearMonth);

	/**
	 * 功能：获取用户当前生效的付费账户列表
	 *
	 * @param idNo
	 * @return
	 */
	List<ContractEntity> getConList(Long idNo);

	/**
	 * 功能：获取指定指定账户的所有当前生效的代付用户
	 *
	 * @param contractNo
	 * @return
	 */
	List<ContractEntity> getUserList(Long contractNo);

	/**
	 * 功能：获取用户的托收账户列表
	 *
	 * @param idNo
	 * @return
	 */
	List<ContractEntity> getCollectionConList(Long idNo);

	/**
	 * 功能：获取生效的付费关系列表
	 * 
	 * @param idNo
	 * @param contractNo
	 * @return
	 */
	List<ContractEntity> getConUserList(Long idNo, Long contractNo);

	/**
	 * 功能：判断帐户是否为集团帐户
	 *
	 * @param contractNo
	 * @return boolean 取值：
	 *         <p>
	 *         true ==> 是集团帐户<br>
	 *         false ==> 非集团帐户
	 *         </p>
	 */
	boolean isGrpCon(long contractNo);

	/**
	 * 功能：获取省内一点支付账户代付二级账户列表或者集团统付账户关系列表
	 *
	 * @param contractNo
	 * @param acctRelType
	 *            : 可空，不传则不限制类型 账户账户关系类型："0：帐务周期全额转帐 1：帐务周期限额转帐 2：帐务周期比例转帐 9：帐务周期定额转帐 A：帐户直接转帐；"
	 * @param flag
	 *            ： 1：查询一点支付二级账户列表 2：查询一点支付和集团统付二级账户列表
	 * @return
	 */
	List<CsAccountRelEntity> getAccountRelList(long contractNo, String acctRelType, String flag);

	/**
	 * 功能：获取托收账户托收银行信息
	 *
	 * @param contractNo
	 * @return ConTrustEntity
	 */
	ConTrustEntity getContrustInfo(long contractNo);

	/**
	 * 功能：获取集团账户列表
	 *
	 * @param lCustId
	 *            ,unitId
	 * @return ContractInfoEntity
	 */
	List<ContractInfoEntity> getGrpConInfo(Long unitId, Long lCustId, Long contractNo);

	/**
	 * 功能：根据代理商号码获取代理商账户
	 *
	 * @param phoneNo
	 * @return
	 */
	ContractInfoEntity getAgtInfo(String phoneNo);

	/**
	 * 功能：根据集团账户获取集团账户信息
	 *
	 * @param contractNo
	 * @return
	 */
	public GrpConEntity getGrpConInfo(long contractNo);

	/**
	 * 功能：根据cust_id查询账户信息
	 * 
	 * @param custId
	 * @return
	 */
	List<ContractInfoEntity> getContractInfo(long custId);


	/**
	 * 根据id_iccid关联账户 证件号码
	 * 
	 * @param sIdIccid
	 * @return
	 */
	List<AccountListEntity> getAccountByIDICCID(String sIdIccid);
	
	/**
	 * 功能：根据idNo获取用户归属的集团统付数目
	 * 
	 * @author suzj
	 * @param idNo
	 * @return
	 */
	public long getTDNum(long idNo);

	/**
	 * 功能：根据idNo获取TD统付账户
	 * 
	 * @author suzj
	 * @param idNo
	 * @return
	 */
	public long getTDCon(long idNo);
	
	public ConUserRelEntity getConUserRelInfo(long inContractNo,long idNo);

	/**
	 * 功能：获取账户信息（现在主要是为了判断账户是否为一点支付账户）
	 * 
	 * @author liuhl_bj
	 * @param inMap
	 * @return
	 */
	ContractInfoEntity getConInfo(Map<String, Object> inMap);

}