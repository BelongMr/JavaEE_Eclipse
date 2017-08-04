package com.sitech.acctmgr.atom.impl.pay;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayOpener;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.busi.pay.inter.IWriteOffer;
import com.sitech.acctmgr.atom.busi.query.inter.IOweBill;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.fee.OweFeeEntity;
import com.sitech.acctmgr.atom.domains.pay.ChequeEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.GroupchgInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.pay.S8000GrpCfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8000GrpCfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S8000GrpInitInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8000GrpInitOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.ICheque;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IInvoice;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IProd;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.inter.pay.I8000Grp;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;


/**
 *
 * <p>
 * Title: 集团缴费业务
 * </p>
 * <p>
 * Description: 处理集团缴费业务，根据集团账户做缴费
 * </p>
 * <p>
 * Copyright: Copyright (c) 2014
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 * 
 * @version 1.0
 */
@ParamTypes({ @ParamType(c = S8000GrpInitInDTO.class, oc = S8000GrpInitOutDTO.class, m = "initGrp"),// 定义
		@ParamType(c = S8000GrpCfmInDTO.class, oc = S8000GrpCfmOutDTO.class, m = "cfmGrp") })
public class S8000Grp extends AcctMgrBaseService implements I8000Grp {

	private IAccount account;
	private IRemainFee reFee;
	private IOweBill oweBill;
	private IUser user;
	private IProd prod;
	private IGroup group;
	private IPayManage payManage;
	private IWriteOffer writeOffer;
	private IPayOpener payOpener;
	private IPreOrder preOrder;
	private IRecord record;
	private ILogin login;
	private IControl control;
	private IBalance balance;
	private ICheque cheque;
	private IInvoice invoice;
	private IBill	 bill;

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.inter.pay.I8000Crp#initGrp(com.sitech.jcfx.dt.in.InDTO) */
	@Override
	public OutDTO initGrp(InDTO inParam) {

		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;

		// 1.入参处理
		S8000GrpInitInDTO inDto = (S8000GrpInitInDTO) inParam;
		log.info("S8000Grp initGrp begin" + inDto.getMbean());

		/* 取当前年月和当前时间 */
		String sCurTime = control.getSysDate().get("CUR_TIME").toString();

		// 1、获取缴费账户
		long contractNo = inDto.getContractNo();
		//获取用
		String phoneNo = getPayPhone(inDto.getPhoneNo(), contractNo);
		
		String brandId = "";
		if(!phoneNo.equals("99999999999")){
			
			UserInfoEntity userInfo = user.getUserInfo(phoneNo);
			brandId = userInfo.getBrandId();
		}
		

		initCheck(inDto.getOpCode(), contractNo);

		// 查询账户信息
		ContractInfoEntity conEntity = account.getConInfo(contractNo);
		long idNums = account.cntConUserRel(contractNo, null, null);

		// 查询账户余额、预存款信息
		OutFeeData outFee = reFee.getConRemainFee(contractNo, 0);
		long sumShouldPay = 0;
		if (outFee.getRemainFee() < 0) {
			sumShouldPay = -1 * outFee.getRemainFee() + outFee.getDelayFee();
		}
		outFee.setSumShouldPay(sumShouldPay);
		
		// 获取欠费列表
		outMapTmp = getUnpayBill(contractNo);
		List<OweFeeEntity> oweFeeList = (List<OweFeeEntity>) outMapTmp.get("OWEFEE_LIST");

		// 构建出参DTO
		S8000GrpInitOutDTO outDto = new S8000GrpInitOutDTO();
		outDto.setContractNo(contractNo);
		outDto.setContractName(conEntity.getBlurContractName());
		outDto.setIdNums(idNums);
		outDto.setPayCodeName(conEntity.getPayCodeName());
		outDto.setOweFeeList(oweFeeList);
		outDto.setFeeData(outFee);
		outDto.setBrandId("".equals(brandId) ? "XX":brandId);
		
		log.info("S8000Grp initGrp end" + outDto.toJson());

		return outDto;
	}

	private Map<String, Object> getUnpayBill(long contractNo) {

		String sCurTime = control.getSysDate().get("CUR_TIME").toString();
		String sCurYm = sCurTime.substring(0, 6);

		Map<String, Object> outParam = new HashMap<String, Object>();

		List<OweFeeEntity> oweFeeList = new ArrayList<OweFeeEntity>();
		Map<String, Object> outMapTmp = new HashMap<String, Object>();

		// 查询账户往月欠费信息
		outMapTmp = oweBill.getOweFeeInfo(contractNo);
		log.debug("oweBill.getOweFeeInfo end: " + outMapTmp.toString());

		for (Map<String, Object> oweFeeMap : (List<Map<String, Object>>) outMapTmp.get("OWEFEE_LIST")) {

			OweFeeEntity outFee = new OweFeeEntity();

			outFee.setContractNo(contractNo);
			outFee.setBillCycle(Long.parseLong(oweFeeMap.get("BILL_CYCLE").toString()));
			outFee.setOweFee(Long.parseLong(oweFeeMap.get("OWE_FEE").toString()));
			outFee.setDelayFee(Long.parseLong(oweFeeMap.get("DELAY_FEE").toString()));
			outFee.setShouldPay(Long.parseLong(oweFeeMap.get("SHOULD_PAY").toString()));
			outFee.setFavourFee(MapUtils.getLongValue(oweFeeMap, "FAVOUR_FEE"));
			outFee.setPayedFee(MapUtils.getLongValue(oweFeeMap, "PAYED_LATER") + MapUtils.getLongValue(oweFeeMap, "PAYED_PREPAY"));

			oweFeeList.add(outFee);

		}

		outParam.put("OWEFEE_LIST", oweFeeList);

		return outParam;
	}

	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.inter.pay.I8000Crp#cfmGrp(com.sitech.jcfx.dt.in.InDTO) */
	@Override
	public OutDTO cfmGrp(InDTO inParam) {

		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;

		// 1.入参处理
		S8000GrpCfmInDTO inDto = (S8000GrpCfmInDTO) inParam;
		long lPayMoney = Long.parseLong(inDto.getPayMoney());

		log.info("S8000Grp cfmGrp begin" + inDto.getMbean());

		if (StringUtils.isEmptyOrNull(inDto.getGroupId())) {
			LoginEntity loginEntity = login.getLoginInfo(inDto.getLoginNo(), inDto.getProvinceId());
			inDto.setGroupId(loginEntity.getGroupId());
		}

		/* 取当前年月和当前时间 */
		String sCurTime = control.getSysDate().get("CUR_TIME").toString();
		String sCurYm = sCurTime.substring(0, 6);
		String sTotaldate = sCurTime.substring(0, 8);

		String phoneNo = getPayPhone(inDto.getPhoneNo(), inDto.getContractNo());
		long contractNo = inDto.getContractNo();

		/* 缴费确认必要校验 */
		cfmCheck(inDto.getOpCode(), Long.parseLong(inDto.getPayMoney()), contractNo,inDto.getIsDoweInv());
		
		// 3、获取缴费确认需要基本资料
		PayUserBaseEntity payUserBase = getCfmBaseInfo(phoneNo, contractNo, inDto.getProvinceId());
		if(inDto.getPhoneNo()!=null && !inDto.getPhoneNo().equals("99999999999"))
			payUserBase.setPhoneFlag(true);
		else
			payUserBase.setPhoneFlag(false);

		long paySn = control.getSequence("SEQ_PAY_SN");
		PayBookEntity bookIn = new PayBookEntity();
		bookIn.setPaySn(paySn);
		bookIn.setTotalDate(Integer.parseInt(sTotaldate));
		bookIn.setPayPath(inDto.getPayPath());
		bookIn.setPayMethod(inDto.getPayMethod());
		bookIn.setPayType(inDto.getPayType());
		bookIn.setPayFee(lPayMoney);
		bookIn.setStatus("0");
		bookIn.setBeginTime(sCurTime);
		bookIn.setPrintFlag("0");
		bookIn.setYearMonth(Long.parseLong(sCurYm));
		bookIn.setLoginNo(inDto.getLoginNo());
		bookIn.setGroupId(inDto.getGroupId());
		bookIn.setOpCode(inDto.getOpCode());
		bookIn.setOpNote(inDto.getPayNote());

		// 实时入账
		payManage.saveInBook(inDto.getHeader(), payUserBase, bookIn);

		// 4.入payment表
		record.savePayMent(payUserBase, bookIn);

		if (PayBusiConst.PAY_TYPE_CHECK.equals(inDto.getPayType())) {
			// 扣除支票金额，记录支票记录表
			ChequeEntity cheque1 = new ChequeEntity(inDto.getBankCode(), inDto.getCheckNo());
			cheque.doReduceCheck(cheque1, bookIn);
		}

		List<Map<String, Object>> payList = new ArrayList<Map<String, Object>>(); // 在PAY_TYPE、PAY_MONEY基础上添加对应的PAY_SN
		Map<String, Object> payMapTmp = new HashMap<String, Object>();
		payMapTmp.put("PAY_TYPE", inDto.getPayType());
		payMapTmp.put("PAY_MONEY", lPayMoney);
		payMapTmp.put("PAY_SN", paySn);
		payList.add(payMapTmp);

		// 冲销
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("Header", inDto.getHeader());
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("LOGIN_NO", inDto.getLoginNo());
		inMapTmp.put("GROUP_ID", inDto.getGroupId());
		inMapTmp.put("OP_CODE", inDto.getOpCode());
		inMapTmp.put("PAY_PATH", inDto.getPayPath());
		inMapTmp.put("DELAY_FAVOUR_RATE", inDto.getDelayRate());
		inMapTmp.put("ANSY_FLAG", "1"); // 异步冲销标志，默认为0(自动判断是否异步冲销),1为异步
		writeOffer.doWriteOff(inMapTmp);

		// 账户开机
		payOpener.doConUserOpen(inDto.getHeader(), payUserBase, bookIn, inDto.getProvinceId());

		// 记录营业员操作日志
		LoginOprEntity loginOprEn = new LoginOprEntity();
		loginOprEn.setLoginNo(inDto.getLoginNo());
		loginOprEn.setLoginGroup(inDto.getGroupId());
		loginOprEn.setLoginSn(paySn);
		loginOprEn.setIdNo(payUserBase.getIdNo());
		loginOprEn.setPhoneNo(phoneNo);
		loginOprEn.setBrandId(payUserBase.getBrandId());
		loginOprEn.setTotalDate(Long.parseLong(sTotaldate));
		loginOprEn.setPayType(inDto.getPayType());
		loginOprEn.setPayFee(lPayMoney);
		loginOprEn.setOpCode(inDto.getOpCode());
		loginOprEn.setRemark(inDto.getPayNote());
		record.saveLoginOpr(loginOprEn);

		List<Map<String, Object>> keysList = new ArrayList<Map<String, Object>>(); // 同步报表库数据List
		Map<String, Object> paymentKey = null;

		/***
		 * 预开发票回收
		 */
		if (inDto.getIsDoweInv() != null && inDto.getIsDoweInv().equals("R")) {

			String flag = invoice.isPreInv(contractNo);
			if(flag == null){
				log.info("账户号码："+contractNo + "没有预开发票不需要回收");
				throw new BusiException(AcctMgrError.getErrorCode("8000", "00024"), "没有预开发票记录!");
			}

			Map<String, Object> inMap = new HashMap<String, Object>();

			inMap.put("LOGIN_NO", inDto.getLoginNo());
			inMap.put("LOGIN_ACCEPT", inDto.getPreloginAccept());
			inMap.put("CONTRACT_NO", inDto.getContractNo());
			inMap.put("OP_CODE", inDto.getOpCode());
			
			inMap.put("PAY_SN_UPDATE", paySn);
			inMap.put("PAY_TIME", sCurTime);
			
			inMap.put("PRINT_SN", inDto.getPreloginAccept());
			inMap.put("PAY_SN", paySn);
			inMap.put("BILL_CYCLE", sCurYm);
			
			//flag各个取值   a:预开普通发票 b:预开增值税发票 null：没有预开发票
			invoice.preInvCollection(inDto.getHeader(), inMap,flag );
			
		}

		// 向其他系统同步数据（目前：CRM营业日报、BOSS报表、统一接触）
		paymentKey = new HashMap<String, Object>();
		paymentKey.put("YEAR_MONTH", sCurYm);
		paymentKey.put("CONTRACT_NO", contractNo);
		paymentKey.put("PAY_SN", paySn);
		paymentKey.put("ID_NO", payUserBase.getIdNo());
		paymentKey.put("PAY_TYPE", inDto.getPayType());
		paymentKey.put("TABLE_NAME", "BAL_PAYMENT_INFO");
		paymentKey.put("UPDATE_TYPE", "I");
		keysList.add(paymentKey);

		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("LOGIN_NO", inDto.getLoginNo());
		inMapTmp.put("GROUP_ID", inDto.getGroupId());
		inMapTmp.put("OP_CODE", inDto.getOpCode());
		inMapTmp.put("PHONE_NO", phoneNo);
		inMapTmp.put("BRAND_ID", payUserBase.getBrandId());
		inMapTmp.put("BACK_FLAG", "0");
		inMapTmp.put("OLD_ACCEPT", paySn);
		inMapTmp.put("OP_TIME", sCurTime);
		inMapTmp.put("OP_NOTE", inDto.getPayNote());
		inMapTmp.put("ACTION_ID", "1001");
		// inMapTmp.put("KEY_DATA", paymentKey);
		inMapTmp.put("KEYS_LIST", keysList);
		inMapTmp.put("REGION_ID", payUserBase.getRegionId());
		if (payUserBase.isPhoneFlag()) {

			inMapTmp.put("CUST_ID_TYPE", "1"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
			inMapTmp.put("CUST_ID_VALUE", phoneNo);
		} else {

			inMapTmp.put("CUST_ID_TYPE", "3"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
			inMapTmp.put("CUST_ID_VALUE", String.valueOf(contractNo));
		}
		inMapTmp.put("Header", inDto.getHeader());
		inMapTmp.put("TOTAL_FEE", lPayMoney);
		preOrder.sendData2(inMapTmp);

		/* 11.重复缴费限制 功能：前台缴费限制非零缴费不允许几秒内重复缴费，通过配置实现时间校验 */
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_LIST", payList);
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("PAY_PATH", inDto.getPayPath());
		inMapTmp.put("LOGIN_NO", inDto.getLoginNo());
		inMapTmp.put("TOTAL_DATE", sTotaldate);
		repeatPayCtrl(inMapTmp);

		S8000GrpCfmOutDTO outDto = new S8000GrpCfmOutDTO();
		outDto.setPayAccept(paySn);
		outDto.setTotalDate(sTotaldate);

		log.info("S8000Grp cfmGrp end" + outDto.toJson());

		return outDto;
	}

	/**
	 * 名称：重复缴费限制
	 * 
	 * @param PAY_LIST
	 *            : List<Map<String, Object>> 每个Map中存放 PAY_SN、PAY_TYPE 、 PAY_MONEY </br>
	 * @param CONTRACT_NO
	 * @param CARD_SN
	 *            可空，外部缴费时使用，确定外部流水唯一.记录外部流水
	 * @param PAY_PATH
	 * @param LOGIN_NO
	 * @param TOTAL_DATE
	 * @return
	 * @author qiaolin
	 */
	private void repeatPayCtrl(Map<String, Object> inParam) {

		// 通过payment表控制一段时间内不允许重复缴费
		String sPayPath = control.getPubCodeValue(2001, "CFJF", null);
		if (sPayPath.indexOf(inParam.get("PAY_PATH").toString()) != -1) {

			// 各省个性化实现
			paymentRepeatCtrl(inParam);

		}
	}

	/**
	 * 名称：
	 * 
	 * @param PAY_LIST
	 *            : List<Map<String, Object>> 每个Map中存放 PAY_SN、PAY_TYPE 、 PAY_MONEY </br>
	 * @param CONTRACT_NO
	 * @param LOGIN_NO
	 * @param PAY_PATH
	 * @return
	 */
	protected void paymentRepeatCtrl(Map<String, Object> inParam) {

		List<PubCodeDictEntity> tmpList = control.getPubCodeList(2010L, "CFJFSJ", "0", null);
		int status = Integer.parseInt(tmpList.get(0).getStatus());
		long times = Long.parseLong(tmpList.get(0).getCodeValue());

		if (0 == status) { // 如果开关打开
			Map<String, Object> inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("PAY_LIST", inParam.get("PAY_LIST"));
			inMapTmp.put("CONTRACT_NO", inParam.get("CONTRACT_NO"));
			inMapTmp.put("LOGIN_NO", inParam.get("LOGIN_NO"));
			inMapTmp.put("INTERVAL", times);
			if (balance.getPayCnt(inMapTmp) > 0) {
				log.info("此号码正在交费，请稍后再交");
				throw new BusiException(AcctMgrError.getErrorCode("8000", "00002"), "3分钟内重复缴费!");
			}
		}
	}

	/**
	 * 功能：获取缴费号码，如果传入缴费号码，则按照入参中返回，否则根据账户获取，通用规则，获取账户下优先级最高的号码
	 */
	protected String getPayPhone(String phoneNo, Long contractNo) {

		if (phoneNo != null && !phoneNo.equals("")) {

			return phoneNo;
		} else {

			String defPhone = account.getPayPhoneByCon(contractNo);
			if (defPhone.equals("")) {
				defPhone = "99999999999";
			}

			return defPhone;
		}
	}

	protected void initCheck(String opCode, long contractNo) {

		if (!account.isGrpCon(contractNo)) {
			log.info("该账户不是集团账户,CONTRACT_NO: " + contractNo);
			throw new BusiException(AcctMgrError.getErrorCode(opCode, "00006"), "该账户不是集团账户,CONTRACT_NO: " + contractNo);
		}
	}

	private PayUserBaseEntity getCfmBaseInfo(String phoneNo, long contractNo, String provinceId) {

		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;

		// Map<String, Object> userMap = null;
		UserInfoEntity userInfo = null;
		String brandId = "XX";
		long idNo = 0;
		if (!phoneNo.equals("99999999999")) {

			userInfo = user.getUserInfo(phoneNo);
			idNo = userInfo.getIdNo();
			brandId = userInfo.getBrandId();
		}

		// 取账户归属
		GroupchgInfoEntity groupChgEntity = group.getChgGroup(null, null, contractNo);

		// 缴费用户归属地市
		ChngroupRelEntity groupEntity = group.getRegionDistinct(groupChgEntity.getGroupId(), "2", provinceId);
		String regionId = groupEntity.getRegionCode();

		PayUserBaseEntity payUserBase = new PayUserBaseEntity();
		payUserBase.setIdNo(idNo);
		payUserBase.setPhoneNo(phoneNo);
		payUserBase.setContractNo(contractNo);
		payUserBase.setUserGroupId(groupChgEntity.getGroupId());
		payUserBase.setRegionId(regionId);
		payUserBase.setBrandId(brandId);

		return payUserBase;
	}

	/**
	 * 名称：缴费确认必有校验
	 * 
	 * @param opCode
	 * @param payMoney
	 */
	protected void cfmCheck(String opCode, long payMoney, long contractNo,String isDoweInv) {

		ContractInfoEntity conEntity = account.getConInfo(contractNo);
		String payCode = conEntity.getPayCode();
		
		/* 缴费限额 */
		if (payCode.equals("3")) { // 托收
			
			boolean isOwe = bill.isUnPayOwe(contractNo);
			if (!isOwe) {
				log.info("托收账户不欠费，不允许缴费" + contractNo);
				throw new BusiException(AcctMgrError.getErrorCode(opCode, "00025"), "托收账户不欠费，不允许缴费");
			}
			
			long payLimitFee = control.getLimitFee(opCode, 0L, "TSZHJF");
			if (payMoney > payLimitFee) {
				log.info("托收账户缴费[ " + payMoney / 100 + " ]元，超过限额 [ " + payLimitFee / 100 + " ]元！");
				throw new BusiException(AcctMgrError.getErrorCode(opCode, "00026"), "托收账户缴费[ " + payMoney / 100 + " ]元，超过限额 [ " + payLimitFee / 100
						+ " ]元！");
			}
		}else{
			long payLimitFee = control.getLimitFee(opCode, 0L, "JTJF");
			if (payMoney > payLimitFee) {
				log.info("集团缴费[ " + payMoney / 100 + " ]元，超过限额 [ " + payLimitFee / 100 + " ]元！");
				throw new BusiException(AcctMgrError.getErrorCode(opCode, "00010"), "集团缴费[ " + payMoney / 100 + " ]元，超过限额 [ " + payLimitFee / 100
						+ " ]元！");
			}
		}
		
		String flag = invoice.isPreInv(contractNo);
		if(("a".equals(flag)|| "b".equals(flag))&&isDoweInv ==null){
			log.info("账户号码："+contractNo + "该账户有预开发票且没有回收，请先做预开发票回收");
			throw new BusiException(AcctMgrError.getErrorCode(opCode, "00030"), "该账户有预开发票且没有回收，请在2300模块做预开发票回收");
		}

	}

	public IAccount getAccount() {
		return account;
	}

	public void setAccount(IAccount account) {
		this.account = account;
	}

	public IRemainFee getReFee() {
		return reFee;
	}

	public void setReFee(IRemainFee reFee) {
		this.reFee = reFee;
	}

	public IOweBill getOweBill() {
		return oweBill;
	}

	public void setOweBill(IOweBill oweBill) {
		this.oweBill = oweBill;
	}

	public IUser getUser() {
		return user;
	}

	public void setUser(IUser user) {
		this.user = user;
	}

	public IProd getProd() {
		return prod;
	}

	public void setProd(IProd prod) {
		this.prod = prod;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

	public IPayManage getPayManage() {
		return payManage;
	}

	public void setPayManage(IPayManage payManage) {
		this.payManage = payManage;
	}

	public IWriteOffer getWriteOffer() {
		return writeOffer;
	}

	public void setWriteOffer(IWriteOffer writeOffer) {
		this.writeOffer = writeOffer;
	}

	public IPayOpener getPayOpener() {
		return payOpener;
	}

	public void setPayOpener(IPayOpener payOpener) {
		this.payOpener = payOpener;
	}

	public IPreOrder getPreOrder() {
		return preOrder;
	}

	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}

	public ILogin getLogin() {
		return login;
	}

	public void setLogin(ILogin login) {
		this.login = login;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public IBalance getBalance() {
		return balance;
	}

	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	public ICheque getCheque() {
		return cheque;
	}

	public void setCheque(ICheque cheque) {
		this.cheque = cheque;
	}

	public IInvoice getInvoice() {
		return invoice;
	}

	public void setInvoice(IInvoice invoice) {
		this.invoice = invoice;
	}

	public IBill getBill() {
		return bill;
	}

	public void setBill(IBill bill) {
		this.bill = bill;
	}
}
