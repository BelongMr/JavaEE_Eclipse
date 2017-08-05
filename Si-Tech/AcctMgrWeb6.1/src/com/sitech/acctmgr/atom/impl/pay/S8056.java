package com.sitech.acctmgr.atom.impl.pay;

import com.alibaba.fastjson.JSON;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.base.LoginBaseEntity;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.balance.TransFeeEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBackOutEntity;
import com.sitech.acctmgr.atom.domains.pay.PayMentEntity;
import com.sitech.acctmgr.atom.domains.pay.PayOutEntity;
import com.sitech.acctmgr.atom.domains.pay.PaysnBaseEntity;
import com.sitech.acctmgr.atom.domains.user.UserBrandEntity;
import com.sitech.acctmgr.atom.dto.pay.*;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.inter.pay.I8056;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

import java.util.*;

/**
 *
 * <p>Title: 缴费统一冲正业务基类</p>
 * <p>Description: 缴费统一冲正业务基类，定义缴费统一冲正业务流程模板</p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH</p>
 *
 * @author qiaolin
 * @version 1.0
 */

@ParamTypes({ 
	@ParamType(c = SgetPaySnInDTO.class, oc = S8056GetSnInfoOutDTO.class, m = "getSnInfo"),//定义
	@ParamType(c = S8056InitInDTO.class, oc =S8056InitOutDTO.class, m = "init"),//定义
	@ParamType(c = S8056CfmInDTO.class, oc = S8056CfmOutDTO.class, m = "cfm"),
	@ParamType(c = S8056ForeignInDTO.class, oc = S8056ForeignOutDTO.class, m = "foreign"),
	@ParamType(c = S8056GrpTrnsBankInDTO.class, oc = S8056GrpTrnsBankOutDTO.class, m = "grpTrnsBank"),
	@ParamType(c = S8056checkInDTO.class, oc = S8056checkOutDTO.class, m = "check")
	})
public class S8056 extends AcctMgrBaseService implements I8056 {

	private IBalance 	balance;
	private ILogin 		login;
	private IAccount 	account;
	private ICust 		cust;
	private IRecord 	record;
	private IPayManage 	payManage;
	private IControl 	control;
	private IGroup 		group;
	private IRemainFee	remainFee;
	private IUser		user;

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.sitech.acctmgr.inter.pay.I8056#getSnInfo(com.sitech.jcfx.dt.in.InDTO)
	 */
	public final OutDTO getSnInfo(InDTO inParam) {

		Map<String, Object> inMapTmp = null;

		log.info("根据帐户信息去查询缴费流水信息getSnInfo begin" + inParam.getMbean());

		SgetPaySnInDTO inDto = (SgetPaySnInDTO) inParam;

		long inContractNo = inDto.getContractNo();

		//缴费冲正JFCZ，空中充值冲正 KZCZCZ, 退费冲正TFCZ
		String opType = "JFCZ";
		String[] opCodes = PayBusiConst.JFCZ_OPCODES;
		if (inDto.getOpType() != null && !inDto.getOpType().equals("")) {

			opType = inDto.getOpType();
			if (opType.equals("KZCZCZ")) {
				opCodes = PayBusiConst.KZCZCZ_OPCODES;
			}else if(opType.equals("JTCPZZCZ")){
				opCodes = PayBusiConst.JTCPZZCZ_OPCODES;
			}else if(opType.equals("YDZFCZ")){
				opCodes = PayBusiConst.YDZFCZ_OPCODES;
			}else{

				throw new BusiException(AcctMgrError.getErrorCode(inDto.getOpCode(), "00005"), "输入的业务类型不存在opType");
			}
		}

		/* 取当前年月和当前时间 */
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String beginYM = "";
		String endYM = "";

		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("CONTRACT_NO", inContractNo);
		inMapTmp.put("SUFFIX", inDto.getPayMonth());
		if (inDto.getBeginTime() != null) {
			inMapTmp.put("BEGIN_TIME", inDto.getBeginTime());
			beginYM = inDto.getBeginTime().substring(0, 6);

		}
		if (inDto.getEndTime() != null) {
			inMapTmp.put("END_TIME", inDto.getEndTime());
			endYM = inDto.getEndTime().substring(0, 6);
		}
		inMapTmp.put("OP_TYPE", opType);
		inMapTmp.put("OP_CODES", opCodes);
		if(opType.equals("JFCZ")){
			String owePath = PayBusiConst.OWNPATH;		//营业前台
			String znzdPath = PayBusiConst.ZNZDPATH;	//只能终端CRM
			String[] payPaths = new String[]{owePath,znzdPath};
			inMapTmp.put("PAY_PATH", payPaths);
		}

		List<PaysnBaseEntity> resultList = new ArrayList<PaysnBaseEntity>();
		if (((beginYM != null) && (!beginYM.equals("")))
				&& ((endYM != null) && (!endYM.equals("")))) {

			List<PaysnBaseEntity> payList = new ArrayList<PaysnBaseEntity>();

			for (long suffix = Long.parseLong(endYM); suffix >= Long
					.parseLong(beginYM); suffix = DateUtils.addMonth(
					Integer.parseInt(suffix + ""), -1)) {

				inMapTmp.put("SUFFIX", suffix + "");
				payList = remainFee.getPayMentForBack(inMapTmp);
				resultList.addAll(payList);
			}

		} else {
			resultList = remainFee.getPayMentForBack(inMapTmp);
		}
		
		if(resultList == null || resultList.size() == 0 ){
			log.info("该用户在当前时间段没有缴费记录或已经被回退！");
			throw new BusiException(AcctMgrError.getErrorCode(inDto.getOpCode(), "00007"),
					"该用户在当前时间段没有缴费记录或已经被回退！");
		}
		
		S8056GetSnInfoOutDTO outDto = new S8056GetSnInfoOutDTO();
		outDto.setPaysnInfo(resultList);

		log.info("根据帐户信息去查询流水信息getSnInfo end!" + outDto.toJson());

		return outDto;

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.inter.pay.I8056#init(com.sitech.jcfx.dt.in.InDTO)
	 */
	public final OutDTO init(InDTO inParam) {

		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;

		log.info("缴费冲正查询init begin: " + inParam.getMbean());

		S8056InitInDTO inDto = (S8056InitInDTO) inParam;
		if( StringUtils.isEmptyOrNull(inDto.getGroupId()) ){
			LoginEntity  loginEntity = login.getLoginInfo(inDto.getLoginNo(), inDto.getProvinceId());
			inDto.setGroupId(loginEntity.getGroupId());
		}
		String payDate = inDto.getPayDate();
		int payYm = Integer.parseInt(payDate.substring(0, 6));

		/* 缴费冲正校验 */
		payManage.doRollbackCheck(inDto.getPaySn(), inDto.getLoginNo(), payYm, inDto.getContractNo(), inDto.getHeader());

		/* 取交费信息 */
		inMapTmp = new HashMap<String, Object>();
		if (inDto.getContractNo() != 0) {
			inMapTmp.put("CONTRACT_NO", inDto.getContractNo());
		}
		inMapTmp.put("PAY_SN", inDto.getPaySn());
		inMapTmp.put("STATUS", "0");
		inMapTmp.put("SUFFIX", payYm);
		List<PayMentEntity> outPayList = record.getPayMentList(inMapTmp);
		if (0 == outPayList.size()) {
			log.info("交费记录不存在pay_sn : " + inDto.getPaySn());
			throw new BusiException(AcctMgrError.getErrorCode(
					inDto.getOpCode(), "00001"), "交费记录不存在pay_sn :  " + inDto.getPaySn());
		}
		PayMentEntity payEntity = outPayList.get(0);
		
		//查询账户信息
		ContractInfoEntity conEntity = account.getConInfo(payEntity.getContractNo());
		
		//查询客户信息
		CustInfoEntity custEntity = cust.getCustInfo(conEntity.getCustId(), null);

		// 根据缴费流水缴费总支出金额、缴费用户数等信息
		Map<String, Object> outFeemsg = payManage.getPayOutMsg(inDto.getPaySn(), payYm);

		S8056InitOutDTO outDto = new S8056InitOutDTO();
		outDto.setCustName(custEntity.getBlurCustName());
		outDto.setAllPay(Long.valueOf(outFeemsg.get("ALL_PAY").toString()));
		outDto.setIdNumbers(Long.valueOf(outFeemsg.get("ID_NUMBER").toString()));
		outDto.setPayOptime(payEntity.getOpTime());
		outDto.setPayLogin(payEntity.getLoginNo());
		outDto.setPaySn(inDto.getPaySn());
		outDto.setPayOpcode(payEntity.getOpCode());
		outDto.setContractNo(payEntity.getContractNo());
		outDto.setPhoneNo(payEntity.getPhoneNo());
		outDto.setBrandId(payEntity.getBrandId());
		
		List<PayBackOutEntity> outFeeMsg = new ArrayList<PayBackOutEntity>();
		for (Map<String, Object> mapTmp : (List<Map<String, Object>>) outFeemsg.get("OUT_FEEMSG")) {
			String jsonStr = JSON.toJSONString(mapTmp);
			outFeeMsg.add(JSON.parseObject(jsonStr, PayBackOutEntity.class));
		}
		outDto.setOutFeemsg(outFeeMsg);

		log.info("缴费冲正查询init end" + outDto.toJson());

		return outDto;
	}

	
	
	public final OutDTO cfm(InDTO inParam) {

		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;

		log.info("缴费冲正确认 cfm begin" + inParam.getMbean());

		S8056CfmInDTO inDto = (S8056CfmInDTO) inParam;
		if( StringUtils.isEmptyOrNull(inDto.getGroupId()) ){
			LoginEntity  loginEntity = login.getLoginInfo(inDto.getLoginNo(), inDto.getProvinceId());
			inDto.setGroupId(loginEntity.getGroupId());
		}
		String payDate = inDto.getPayDate();
		String yearMonth = payDate.substring(0, 6);

		/* 取当前年月和当前时间 */
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String sCurYm = sCurTime.substring(0, 6);
		String sTotalDate = sCurTime.substring(0, 8);

		//OP_CODE转换为冲正入表的OP_CODE (根据受理缴费OP_CODE不同，冲正对应的OP_CODE也不同)
		String curOpCode = inDto.getOpCode();
		if (inDto.getPayOpCode() != null && !inDto.getPayOpCode().equals("")
				&& curOpCode.equals("8056")) {
			curOpCode = control.getPubCodeValue(2100, inDto.getPayOpCode(),null);
		}

		/*
		 * 1、冲正限制
		 */
		
		
		
		LoginBaseEntity loginEntity = new LoginBaseEntity();
		loginEntity.setLoginNo(inDto.getLoginNo());
		loginEntity.setGroupId(inDto.getGroupId());
		loginEntity.setOpCode(curOpCode);
		loginEntity.setOpNote(inDto.getPayNote());

		/**
		 * 2、缴费冲正退现金费用pPayBackCashFee
		 */
		long backPaysn = payManage.doRollbackCashFee(inDto.getPaySn(), null, payDate, loginEntity);

		/*
		 * 3、 回退缴费资金受理(缴费、空充、退费)日志记录
		 */
		Map<String, Object> inRollbackMap = new HashMap<String, Object>();
		inRollbackMap.put("PAY_SN", inDto.getPaySn());
		inRollbackMap.put("PAY_YM", Long.parseLong(yearMonth));
		inRollbackMap.put("PAY_DATA", payDate);
		inRollbackMap.put("BACK_PAYSN", backPaysn);
		inRollbackMap.put("PAY_PATH", inDto.getPayPath());
		inRollbackMap.put("PAY_METHOD", inDto.getPayMethod());
		inRollbackMap.put("Header", inDto.getHeader());
		inRollbackMap.put("PHONE_NO", inDto.getPhoneNo());
		inRollbackMap.put("LOGIN_ENTITY", loginEntity);
		inRollbackMap.put("PAY_OPCODE", inDto.getPayOpCode());
		outMapTmp =  payManage.doRollbackRecord(inRollbackMap);
		long sumBackFee = Long.parseLong(outMapTmp.get("SUM_BACKFEE").toString());

		/*
		 * 4、 冲正短信发送
		 */
		if (!inDto.getSmsFlag().equals("0")) {
			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("PAY_PATH", inDto.getPayPath());
			inMapTmp.put("PHONE_NO", inDto.getPhoneNo());
			inMapTmp.put("PAY_CODE", inDto.getPayOpCode());
			inMapTmp.put("LOGIN_NO", inDto.getLoginNo());
			inMapTmp.put("GROUP_ID", inDto.getGroupId());
			inMapTmp.put("OP_CODE", inDto.getOpCode());
			inMapTmp.put("SUM_BACKFEE", sumBackFee);
			sendPayMsg(inMapTmp);
		}

		S8056CfmOutDTO outDto = new S8056CfmOutDTO();
		outDto.setPaybackPaysn(backPaysn);
		outDto.setTotalDate(sTotalDate);

		log.info("缴费冲正确认 cfm end" + outDto.toJson());

		return outDto;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.sitech.acctmgr.inter.pay.I8056#foreign(com.sitech.jcfx.dt.in.InDTO)
	 */
	public final OutDTO foreign(InDTO inParam) {

		log.info("外部流水缴费冲正确认 foreign begin: " + inParam.getMbean());

		S8056ForeignInDTO inDto = (S8056ForeignInDTO) inParam;

		String payDate = inDto.getPayDate();
		String yearMonth = payDate.substring(0, 6);
		String foreignSn = inDto.getForeignSn();

		List<Map<String, Object>> paySnList = payManage.getPaySnByForeign(foreignSn, yearMonth);
		if (0 == paySnList.size()) {
			log.info("外部流水交费记录不存在foreign_sn : " + foreignSn);
			throw new BusiException(AcctMgrError.getErrorCode(
					inDto.getOpCode(), "00002"), "外部流水交费记录不存在foreign_sn :  "
					+ foreignSn);
		}
		List<PayOutEntity> payBackSnList = new ArrayList<PayOutEntity>();
		String totalDate = "";
		for (Map<String, Object> paySnMap : paySnList) {

			String status = paySnMap.get("STATUS").toString();
			if (status.equals("1") || status.equals("3")) {
				log.info("该条缴费记录已经冲正 foreignSn : " + foreignSn);
				throw new BusiException(AcctMgrError.getErrorCode(
						inDto.getOpCode(), "00004"), "该条缴费记录已经冲正 ");
			}

			long paySn = Long.parseLong(paySnMap.get("PAY_SN").toString());
			String payOpCode = (String) paySnMap.get("OP_CODE");

			S8056CfmInDTO cfmInDto = new S8056CfmInDTO();

			MBean cfmIn = inDto.getMbean();
			// MBean cfmIn = DataBus.getMBean();
			cfmIn.setBody("BUSI_INFO.PAY_SN", paySn);
			cfmIn.setBody("BUSI_INFO.PAY_OPCODE", payOpCode);
			log.debug("添加上内部流水和缴费OP_CODE的MBean: " + cfmIn.toString());

			cfmInDto.decode(cfmIn);

			S8056CfmOutDTO cfmOutDto = (S8056CfmOutDTO) cfm(cfmInDto);
			totalDate = cfmOutDto.getTotalDate();

			PayOutEntity payBackSnEnt = new PayOutEntity();
			payBackSnEnt.setPaySn(cfmOutDto.getPaybackPaysn());
			payBackSnList.add(payBackSnEnt);
		}

		S8056ForeignOutDTO outDto = new S8056ForeignOutDTO();
		outDto.setPaybackSnList(payBackSnList);
		outDto.setTotalDate(totalDate);

		return outDto;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.sitech.acctmgr.inter.pay.I8056#check(com.sitech.jcfx.dt.in.InDTO)
	 */
	public final OutDTO check(InDTO inParam) {

		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;

		log.info("外部流水缴费冲正校验 check begin: " + inParam.getMbean());

		S8056checkInDTO inDto = (S8056checkInDTO) inParam;
		String payDate = inDto.getPayDate();
		String yearMonth = payDate.substring(0, 6);

		// 校验此笔流水的正向业务是否处理成功
		List<Map<String, Object>> paySnList = payManage.getPaySnByForeign(inDto.getForeignSn(), yearMonth);
		if (0 == paySnList.size()) {
			log.info("外部流水交费记录不存在foreign_sn : " + inDto.getForeignSn());
			throw new BusiException(AcctMgrError.getErrorCode(
					inDto.getOpCode(), "00002"), "外部流水交费记录不存在foreign_sn :  "
					+ inDto.getForeignSn());
		}

		int num = 0;
		for(Map<String, Object> mapTmp : paySnList){
			
			String status = mapTmp.get("STATUS").toString();
			if (status.equals("1") || status.equals("3")) {
				log.info("该条缴费记录已经冲正 foreignSn : " + inDto.getForeignSn());
				throw new BusiException(AcctMgrError.getErrorCode(
						inDto.getOpCode(), "00004"), "该条缴费记录已经冲正 ");
			}
			
			long paySn = Long.parseLong(mapTmp.get("PAY_SN").toString());
			
			/* 取交费信息 */
			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("PAY_SN", paySn);
			inMapTmp.put("STATUS", "0");
			inMapTmp.put("SUFFIX", yearMonth);
			List<PayMentEntity> outPayList = record.getPayMentList(inMapTmp);
			if (0 == outPayList.size()) {
				log.info("交费记录不存在pay_sn : " + paySn);
				throw new BusiException(AcctMgrError.getErrorCode(
						inDto.getOpCode(), "00001"), "交费记录不存在pay_sn :  " + paySn);
			}
			
			if(num == 0){
				PayMentEntity payEntity = outPayList.get(0);
				payManage.doRollbackCheck(payEntity.getPaySn(), inDto.getLoginNo(), payEntity.getYearMonth(), payEntity.getContractNo(), inDto.getHeader());
			}
			num ++;
			
			// 校验此外部流水缴费记录金额是否能够回退（缴费金额 - 所有账单冲销金额 = 目前账本该预存款）
			for(PayMentEntity payTmp : outPayList){
				
				long payFee = payTmp.getPayFee();
				
				long outFee = balance.getSumPayoutFee(payTmp.getPaySn(), payTmp.getContractNo(), payTmp.getYearMonth());
				
				long curBalance = balance.getSumCurbookFee(payTmp.getPaySn(), payTmp.getContractNo(), payTmp.getYearMonth());
				
				if(payFee - outFee != curBalance){
					throw new BusiException(AcctMgrError.getErrorCode(
							"8056", "00006"), "该笔缴费金额不足，不能冲正 " + paySn);
				}
			}
			
		}


		S8056checkOutDTO outDto = new S8056checkOutDTO();
		return outDto;
	}
	
	@Override
	public OutDTO grpTrnsBank(InDTO inParam) {

		log.info("紅包冲正grpTrnsBank  begin" + inParam.getMbean());

		S8056GrpTrnsBankInDTO inDto = (S8056GrpTrnsBankInDTO) inParam;

		if (StringUtils.isEmptyOrNull(inDto.getGroupId())) {
			LoginEntity loginEntity = login.getLoginInfo(inDto.getLoginNo(), inDto.getProvinceId());
			inDto.setGroupId(loginEntity.getGroupId());
		}

		String payDate = inDto.getPayDate();// 红包充值日期
		String yearMonth = payDate.substring(0, 6);
		int payYm = Integer.parseInt(yearMonth);

		/* 取当前年月和当前时间 */
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String sCurYm = sCurTime.substring(0, 6);
		String sTotalDate = sCurTime.substring(0, 8);

		// 验证集团账户和转入用户信息
		TransFeeEntity trans = record.getTransInfo(inDto.getPaySn(), payYm);
		String groupPhoneNo = inDto.getGroupPhoneNo();// 集团号码（虚拟20号码）
		String phoneNo = inDto.getPhoneNo();

		if (trans == null) {
			log.info("转账记录不存在pay_sn : " + inDto.getPaySn());
			throw new BusiException(AcctMgrError.getErrorCode(inDto.getOpCode(), "00007"),
					"转账记录不存在pay_sn :  " + inDto.getPaySn());
		} else {
			if (!groupPhoneNo.equals(trans.getPhonenoOut()) || !phoneNo.equals(trans.getPhonenoIn())) {
				log.info("缴费流水与集团帐号、服务号码不匹配  pay_sn : " + inDto.getPaySn() + "服务号码：" + inDto.getPhoneNo() + "集团帐号："
						+ inDto.getGroupPhoneNo());
				throw new BusiException(AcctMgrError.getErrorCode(inDto.getOpCode(), "00008"), "转账记录不存在pay_sn :  "
						+ inDto.getPaySn() + "服务号码：" + inDto.getPhoneNo() + "集团帐号：" + inDto.getGroupPhoneNo());
			}
		}

/*		// 校验此笔流水的正向业务是否处理成功
		List<Map<String, Object>> paySnList = payManage.getPaySnByForeign(inDto.getForeignSn(), yearMonth);
		if (0 == paySnList.size()) {
			log.info("外部流水交费记录不存在foreign_sn : " + inDto.getForeignSn());
			throw new BusiException(AcctMgrError.getErrorCode(inDto.getOpCode(), "00002"),
					"外部流水交费记录不存在foreign_sn :  " + inDto.getForeignSn());
		}
		外部流水未校验完毕*/
		
		/* 红包充值冲正校验 */
		payManage.doRollbackCheck(inDto.getPaySn(), inDto.getLoginNo(), payYm, inDto.getContractNo(),
				inDto.getHeader());

		/*
		 * 1、冲正限制
		 */

		LoginBaseEntity loginEntity = new LoginBaseEntity();
		loginEntity.setLoginNo(inDto.getLoginNo());
		loginEntity.setGroupId(inDto.getGroupId());
		loginEntity.setOpCode(inDto.getOpCode());
		loginEntity.setOpNote("红包冲正");

		/**
		 * 2、缴费冲正退现金费用 pPayBackCashFee
		 */
		long backPaysn = payManage.doRollbackCashFee(inDto.getPaySn(), null, payDate, loginEntity);

		/*
		 * 3、 回退缴费资金受理(缴费、空充、退费)日志记录
		 */

		Map<String, Object> inRollbackMap = new HashMap<String, Object>();
		inRollbackMap.put("PAY_YM", Long.parseLong(yearMonth));
		inRollbackMap.put("PAY_DATA", payDate);
		inRollbackMap.put("PAY_PATH", inDto.getPayPath());
		inRollbackMap.put("PAY_METHOD", inDto.getPayMethod());
		inRollbackMap.put("Header", inDto.getHeader());
		inRollbackMap.put("PHONE_NO", inDto.getPhoneNo());
		inRollbackMap.put("LOGIN_ENTITY", loginEntity);
		inRollbackMap.put("PAY_OPCODE", inDto.getOpCode());
		inRollbackMap.put("PAY_SN", inDto.getPaySn());
		inRollbackMap.put("BACK_PAYSN", backPaysn);
		payManage.doRollbackRecord(inRollbackMap);

		S8056CfmOutDTO outDto = new S8056CfmOutDTO();
		outDto.setPaybackPaysn(backPaysn);
		outDto.setTotalDate(sTotalDate);
		log.info("紅包冲正grpTrnsBank cfm end" + outDto.toJson());

		return outDto;
	}

	/**
	 * 名称：缴费冲正发送短信(各省实现)
	 *
	 * @param PAY_PATH
	 * @param PHONE_NO
	 * @param PAY_CODE		: 正向业务OP_CODE
	 * @param LOGIN_NO
	 * @param GROUP_ID		: 工号group_id
	 * @param OP_CODE
	 */
	protected  void sendPayMsg(Map<String, Object> inParam){
		
	}

	public IBalance getBalance() {
		return balance;
	}

	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	public ILogin getLogin() {
		return login;
	}

	public void setLogin(ILogin login) {
		this.login = login;
	}

	public IAccount getAccount() {
		return account;
	}

	public void setAccount(IAccount account) {
		this.account = account;
	}

	public ICust getCust() {
		return cust;
	}

	public void setCust(ICust cust) {
		this.cust = cust;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}

	public IPayManage getPayManage() {
		return payManage;
	}

	public void setPayManage(IPayManage payManage) {
		this.payManage = payManage;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

	public IRemainFee getRemainFee() {
		return remainFee;
	}

	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}

	public IUser getUser() {
		return user;
	}

	public void setUser(IUser user) {
		this.user = user;
	}
}