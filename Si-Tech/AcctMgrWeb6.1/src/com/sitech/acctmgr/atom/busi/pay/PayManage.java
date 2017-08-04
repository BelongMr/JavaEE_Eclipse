package com.sitech.acctmgr.atom.busi.pay;

import static com.sitech.acctmgr.common.AcctMgrError.getErrorCode;
import static org.apache.commons.collections.MapUtils.*; 

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.query.PayCardEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;

import org.apache.commons.collections.MapUtils;

import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.IPaybakLimit;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.busi.pay.inter.ITransType;
import com.sitech.acctmgr.atom.busi.pay.inter.IWriteOffer;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.balance.TransFeeEntity;
import com.sitech.acctmgr.atom.domains.base.LoginBaseEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.cust.GrpCustInfoEntity;
import com.sitech.acctmgr.atom.domains.pay.ChequeEntity;
import com.sitech.acctmgr.atom.domains.pay.DistrictLimitEntity;
import com.sitech.acctmgr.atom.domains.pay.FieldEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayMentEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.pay.RegionLimitEntity;
import com.sitech.acctmgr.atom.domains.user.GroupchgInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserBrandEntity;
import com.sitech.acctmgr.atom.domains.user.UserDeadEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IAgent;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.ICheque;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IInvoice;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IProd;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgrint.atom.busi.intface.IShortMessage;
import com.sitech.acctmgrint.atom.busi.intface.ISvcOrder;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.context.JCFContext;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.util.DateUtil;

/**
 *
 * <p>Title: 账本类  </p>
 * <p>Description: 包括入账、退费、转账等业务  </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author 
 * @version 1.0
 */
public class PayManage extends BaseBusi implements IPayManage {
	
	private	IGroup 			group;
	private ICust           cust;
	private ILogin			login;
	private IInvoice		invoice;
	private IBalance		balance;
	private	IRecord			record;
	private IUser			user;
	private IProd			prod;
	private	IControl		control;
	private IWriteOffer     writeOffer;
	private IBill 			bill;
	private IAgent 			agent;
	private IAccount		account;
	private IRemainFee      remainFee;
	private IPaybakLimit	payBackLimit;
	private IPreOrder		preOrder;
	private ISvcOrder 		svcOrder;
	private ICheque			cheque;
	private IShortMessage   shortMessage;
 
	public void saveInBook(Map<String, Object> header, PayUserBaseEntity payUserBase, PayBookEntity inBook) {
		
		/*取当前年月*/
		String sCurYm = DateUtil.format(new Date(), "yyyyMM");
		inBook.setYearMonth(Long.parseLong(sCurYm));
		
	    /*获取缴费流水pay_sn*/
		if (inBook.getPaySn() == 0) {
			
			throw new BusiException(AcctMgrError.getErrorCode("0000", "00010"), "缴费流水必传");
		}
		
	    /*获取账本标识balance_id*/
		long balanceId = control.getSequence("SEQ_BALANCE_ID");
		inBook.setBalanceId(balanceId);

		/*入账本表*/
		balance.saveAcctBook(payUserBase, inBook);

		/*入来源表booksource*/
		balance.saveSource(payUserBase, inBook);

		/*同步实时销账*/
		Map<String, Object> rtWrtoffMap = new HashMap<String, Object>();
		rtWrtoffMap.put("Header", header);
		rtWrtoffMap.put("PAY_SN", inBook.getPaySn());
		rtWrtoffMap.put("CONTRACT_NO", payUserBase.getContractNo());
		rtWrtoffMap.put("BALANCE_ID", balanceId);
		rtWrtoffMap.put("WRTOFF_FLAG", "1");
		rtWrtoffMap.put("REMARK", inBook.getOpNote());
		balance.saveRtwroffChg(rtWrtoffMap);
		
		/*
		 *0账本移入历史
		 */
		balance.removeAcctBook(payUserBase.getContractNo(), inBook.getLoginNo(), inBook.getPaySn(), inBook.getOpCode());
	}
	
	@Override
	public Map<String, Object> doBackMoneyDead(PayUserBaseEntity userBaseInfo,PayBookEntity bookIn) {
		log.info("----> doBackMoney dead userBaseInfo in: "+userBaseInfo.toString());
		log.info("----> doBackMoney dead bookIn in: "+bookIn.toString());
		Map<String, Object> inPerMap = null;

		long remainMoney=bookIn.getPayFee();
		
		// 获取退费流水
		long payAccept =  control.getSequence("SEQ_PAY_SN");
		bookIn.setPaySn(payAccept);
		bookIn.setOriginalSn(payAccept);
		
		//payment 列表
		List<Map<String, Object>> paymentList = new ArrayList<Map<String,Object>>();
		//预存列表
		List<Map<String, Object>> preList = null;
		
		inPerMap=new HashMap<String, Object>();
		inPerMap.put("CONTRACT_NO", userBaseInfo.getContractNo());
		inPerMap.put("BACK_FLAG", "0");
		preList= balance.getDeadBookList(inPerMap);

		log.info("----------->preList size: "+preList.size());
		
		// 循环扣减余额表，来源表记录负记录
		for (Map<String, Object> resultMap : preList ) {
	        long curPay=0; //本账本退费金额
			long prepayFee=Long.parseLong(resultMap.get("CUR_BALANCE").toString());  //本账本可退预存
			long balanceId=Long.parseLong( resultMap.get("BALANCE_ID").toString()); 
			String payType=resultMap.get("PAY_TYPE").toString();
			
			log.info("帐本pay_type=["+payType+"],可退金额["+prepayFee+"]");
			
			if(prepayFee==0){
				continue;
			}
			if(remainMoney<=0){
				continue;
			}
			
			if(remainMoney > prepayFee){
				curPay = prepayFee ;
			}else{
				curPay = remainMoney;
			}
	        log.info("-----------> 本次账本退费金额："+curPay);

			// 1.根据账本类型更新账本信息
			int balCnt = balance.updateAcctBookDead(balanceId, curPay);
			if (balCnt == 0) {
				throw new BusiException(AcctMgrError.getErrorCode("8008", "00006"), "更新余额表出错! BALANCE_ID="+balanceId);
			}

			// 2.记录负来源
			Map<String, Object> inParamMap = new HashMap<String, Object>();
			bookIn.setBalanceId(balanceId);
			bookIn.setPayType(payType);
			bookIn.setPayFee((-1) * curPay);
			bookIn.setStatus("5");
			balance.saveSource(userBaseInfo, bookIn);

			remainMoney = remainMoney - curPay;

			// 3.构建payment表的paymoney List，防止入payment表主键冲突( 按照pay_type 合并金额 )
			int pFlag = 0;
			for (Map<String, Object> mp : paymentList) {
				String mType = getString(mp, "PAY_TYPE");
				long mMoney = getLongValue(mp, "PAY_MONEY");
				if (mType.equals(payType)) {
					mp.put("PAY_MONEY", mMoney + curPay);
					pFlag = 1;
				} else {
					continue;
				}
			}
			
			if(0==pFlag){
				inParamMap = new HashMap<String, Object>();
				inParamMap.put("PAY_TYPE", payType);
				inParamMap.put("PAY_MONEY", curPay);
				paymentList.add(inParamMap);
			}

		}//扣减账本end
		
		// 根据payment列表记录payment表
		for(Map<String, Object> payment : paymentList){
			long payFee_m=Long.valueOf( payment.get("PAY_MONEY").toString()); 
			String payType_m=payment.get("PAY_TYPE").toString();	
            //按账本插缴费记录表
			bookIn.setPayType(payType_m);
			bookIn.setPayFee((-1)*payFee_m);
			bookIn.setStatus("5");
			record.savePayMent(userBaseInfo, bookIn);
		}

		// 校验是否退费完毕
		if (remainMoney !=0 )		  {
			log.error("退费金额和实际退费不同");
			throw new BusiException(AcctMgrError.getErrorCode("8008", "00003"),"退费金额和实际退费不同");
		}
		
		// 将账本余额为0的记录则移到bookhis表中,并删除账本为0的记录
		balance.removeAcctBookDead(userBaseInfo.getContractNo(), bookIn.getLoginNo(),payAccept,bookIn.getOpCode());

		// 构建出参
		Map<String, Object> outParam = new HashMap<String, Object>();
		outParam.put("PAY_ACCEPT", payAccept);
		outParam.put("PAYMENT_LIST", paymentList);
		
		// 同步实时销账
		Map<String, Object> rtWrtoffMap = new HashMap<String, Object>();
		rtWrtoffMap.put("PAY_SN", payAccept);
		rtWrtoffMap.put("CONTRACT_NO", userBaseInfo.getContractNo());
		rtWrtoffMap.put("WRTOFF_FLAG", "2");
		rtWrtoffMap.put("REMARK", bookIn.getOpNote());
		balance.saveRtwroffChg(rtWrtoffMap);
		
		log.info("----> doBackMoney_end: "+outParam.toString());	
		
		return outParam;
	}
	
	/* (non-Javadoc)
	 * @see com.sitech.acctmgr.atom.busi.pay.inter.IAcctBook#doBackMoney(java.util.Map)
	 */
	@Override
	public Map<String, Object> doBackMoney(PayUserBaseEntity userBaseInfo,PayBookEntity bookIn) {
		log.info("----> doBackMoney userInfoin: "+userBaseInfo.toString());
		log.info("----> doBackMoney bookIn in: "+bookIn.toString());
		String opNote = bookIn.getOpNote();
		long contractNo = userBaseInfo.getContractNo();
		String phoneNo = userBaseInfo.getPhoneNo();
		Map<String, Object> inPerMap = null;
		
		//打印过增值税发票的不许退预存
		boolean check = invoice.checkIncrementBack(contractNo,phoneNo);
		if(!check){
			throw new BusiException(AcctMgrError.getErrorCode("8008", "00024"),"该账号开具过专票，请将开具的专票冲红或作废再退预存！");
		}

		long remainMoney=bookIn.getPayFee();
		
		// 获取退费流水
		long payAccept = control.getSequence("SEQ_PAY_SN"); 
		bookIn.setPaySn(payAccept);
		bookIn.setOriginalSn(payAccept);
		
		//payment 列表
		List<Map<String, Object>> paymentList = new ArrayList<Map<String,Object>>();
		//预存列表
		List<Map<String, Object>> preList = null;
		
		inPerMap=new HashMap<String, Object>();                                                                                
		inPerMap.put("CONTRACT_NO", userBaseInfo.getContractNo());
		inPerMap.put("BACK_FLAG", "0");
		if (bookIn.getPayType() !=null && !bookIn.getPayType().equals("")) {
			inPerMap.put("PAY_TYPE", bookIn.getPayType());
		}
		preList= balance.getAcctBookList(inPerMap);

		log.debug("----------->preList size: "+preList.size());
		// 循环扣减余额表，来源表记录负记录
		for (Map<String, Object> resultMap : preList ) {
	        long curPay=0; //本账本退费金额
			long prepayFee=Long.parseLong(resultMap.get("CUR_BALANCE").toString());  //本账本可退预存
			long balanceId=Long.parseLong( resultMap.get("BALANCE_ID").toString()); 
			String payType=resultMap.get("PAY_TYPE").toString();
			
			log.info("帐本pay_type=["+payType+"],可退金额["+prepayFee+"]\n");
			
			if(prepayFee==0){
				continue;
			}
			if(remainMoney<=0){
				continue;
			}
			
			if(remainMoney > prepayFee){
				curPay = prepayFee ;
			}else{
				curPay = remainMoney;
			}
	        log.info("-----------> 本次账本退费金额："+curPay);

			// 1.根据账本类型更新账本信息
			Map<String, Object> inParamMap = new HashMap<String, Object>();
			inParamMap.put("BALANCE_ID", balanceId);
			inParamMap.put("PAYED_OWE", curPay);
			int balCnt = balance.updateAcctBook(inParamMap);
			if (balCnt == 0) {
				throw new BusiException(AcctMgrError.getErrorCode("8008", "00006"), "余额表更新出错! BALANCE_ID="+balanceId);
			}

			// 2.记录负来源
			inParamMap = new HashMap<String, Object>();
			bookIn.setBalanceId(balanceId);
			bookIn.setPayType(payType);
			bookIn.setPayFee((-1) * curPay);
			bookIn.setStatus("4");
			balance.saveSource(userBaseInfo, bookIn); 

			remainMoney = remainMoney - curPay;

			// 3.构建payment表的paymoney List，防止入payment表主键冲突( 按照pay_type 合并金额 )
			int pFlag = 0;
			for (Map<String, Object> mp : paymentList) {
				String mType = getString(mp, "PAY_TYPE");
				long mMoney = getLongValue(mp, "PAY_MONEY");
				if (mType.equals(payType)) {
					mp.put("PAY_MONEY", mMoney + curPay);
					pFlag = 1;
				} else {
					continue;
				}
			}
			
			if(0==pFlag){
				inParamMap = new HashMap<String, Object>();
				inParamMap.put("PAY_TYPE", payType);
				inParamMap.put("PAY_MONEY", curPay);
				paymentList.add(inParamMap);
			}

		}//扣减账本end
		
		// B. 根据payment列表记录payment表
		for(Map<String, Object> payment : paymentList){
			long payFee_m=Long.valueOf( payment.get("PAY_MONEY").toString()); 
			String payType_m=payment.get("PAY_TYPE").toString();	
            //按账本插缴费记录表
			bookIn.setPayType(payType_m);
			bookIn.setPayFee((-1)*payFee_m);
			bookIn.setStatus("4");
			record.savePayMent(userBaseInfo, bookIn);
		}

		// 校验是否退费完毕
		if (remainMoney !=0 )		  {
			log.error("退费金额和实际退费不同");
			throw new BusiException(AcctMgrError.getErrorCode("8008", "00003"),"退费金额和实际退费不同");
		}
		
		// 构建出参
		Map<String, Object> outParam = new HashMap<String, Object>();
		outParam.put("PAY_ACCEPT", payAccept);
		outParam.put("PAYMENT_LIST", paymentList);
		
		// 同步实时销账
		Map<String, Object> rtWrtoffMap = new HashMap<String, Object>();
		rtWrtoffMap.put("PAY_SN", payAccept);
		rtWrtoffMap.put("CONTRACT_NO", contractNo);
		rtWrtoffMap.put("WRTOFF_FLAG", "2");
		rtWrtoffMap.put("REMARK", opNote);
		balance.saveRtwroffChg(rtWrtoffMap);
		
		log.info("----> doBackMoney_end: "+outParam.toString());
		
		return outParam;
	}
	
	@Override
	public long transBalanceSpecial(Map<String, Object> inParam,List<Map<String, Object>> transOutBookList){
		
		log.info("transBalance begin: " + inParam.toString());
		
		Map<String, Object> inMapTmp = null;
		ITransType transType = null;
		/*获取入参信息*/
		Map<String, Object> header = (Map<String, Object>)inParam.get("Header"); 
		PayBookEntity bookIn = (PayBookEntity)inParam.get("BOOK_IN");  //入账实体
		PayUserBaseEntity transInBaseInfo = (PayUserBaseEntity)inParam.get("TRANS_IN");  //转入账户基本信息
		PayUserBaseEntity transOutBaseInfo = (PayUserBaseEntity)inParam.get("TRANS_OUT");  //转出账户基本信息
		String outPayType = (String)inParam.get("OUT_PAY_TYPE");
		String inPaytype = (String)inParam.get("IN_PAY_TYPE");
		
		if(StringUtils.isEmptyOrNull(inParam.get("TRANS_TYPE_OBJ"))){  //传空，默认为在网账户转账
			//transType = (ITransType)JCFContext.getBean("TransAccountEnt");	   //在网账户转账实例化对象
			transType = null;
		}else{
			transType = (ITransType)inParam.get("TRANS_TYPE_OBJ");   //转账类型实例化对象
		}
		
		String opType = inParam.get("OP_TYPE").toString();
			
		long transFee = bookIn.getPayFee();
		
		/*获取转账流水*/
		long transSn = control.getSequence("SEQ_PAY_SN");
		bookIn.setPaySn(transSn);
		bookIn.setOriginalSn(transSn);

		/*转出账户金额转出*/
		inMapTmp = new HashMap<String, Object>();
		List<Map<String, Object>> outBookList = new ArrayList<Map<String,Object>>();
		
		/*转出账户金额转出*/
		outBookList = this.transOut(header, transOutBaseInfo, bookIn, transOutBookList);

		log.info("transOut end: " + outBookList.toString());	

		// 构建转入账本,默认转入账户为转出账户转出后返回的账本List
		List<Map<String, Object>> inBookList = new ArrayList<Map<String, Object>>();

		if(inPaytype == null || inPaytype.equals("")){
			for (Map<String, Object> outbookMap : outBookList) {
				Map<String, Object> inBookMap = new HashMap<String, Object>();
				inBookMap.put("PAY_TYPE", outbookMap.get("PAY_TYPE"));
				inBookMap.put("CHANGEIN_FEE", outbookMap.get("PAY_FEE"));
				inBookMap.put("BEGIN_TIME", inParam.get("BEGIN_TIME"));
				inBookMap.put("PRINT_FLAG", outbookMap.get("PRINT_FLAG"));
				inBookList.add(inBookMap);
				
				//transFee =+ (long) outbookMap.get("PAY_FEE");
			}
		}else{
			
			for (Map<String, Object> outbookMap : outBookList) {
				Map<String, Object> inBookMap = new HashMap<String, Object>();
				inBookMap.put("PAY_TYPE", inPaytype);
				inBookMap.put("CHANGEIN_FEE", outbookMap.get("PAY_FEE"));
				inBookMap.put("BEGIN_TIME",  bookIn.getBeginTime());
				inBookMap.put("END_TIME", bookIn.getEndTime());
				inBookMap.put("PRINT_FLAG", outbookMap.get("PRINT_FLAG"));
				inBookList.add(inBookMap);
				
				//transFee =+ (long) outbookMap.get("PAY_FEE");
			}
		}
		
		/*转入账户金额转入*/
		bookIn.setPayFee(transFee);
		transIn(header, transInBaseInfo, bookIn, inBookList);
		
		log.info("transBalance end tranSn:"+transSn);
		
		// 记录转账记录表
		inMapTmp = new HashMap<String, Object>();		
		inMapTmp.put("OP_TYPE", opType);	
		inMapTmp.put("HEADER", header);
		balance.saveTrasfeeInfo(transOutBaseInfo, transInBaseInfo, bookIn, inMapTmp);
		
		return transSn;
	}
	
	
	/* (non-Javadoc)
	 * @see com.sitech.acctmgr.atom.busi.pay.inter.IAcctBook#transBalance(java.util.Map)
	 */
	@Override
	public long transBalance(Map<String, Object> inParam) {
		
		log.info("transBalance begin: " + inParam.toString());
		
		return this.transBalance(inParam, null);
	}
	
	@Override
	public long transBalance(Map<String, Object> inParam, String inPayType) {
		
		return transBalance(inParam, inPayType, null);
	}
	
	public long transBalance(Map<String, Object> inParam, String inPaytype, String outPayType){
		
		log.info("transBalance begin: " + inParam.toString());
		
		Map<String, Object> inMapTmp = null;
		ITransType transType = null;
		/*获取入参信息*/
		Map<String, Object> header = (Map<String, Object>)inParam.get("Header"); 
		PayBookEntity bookIn = (PayBookEntity)inParam.get("BOOK_IN");  //入账实体
		PayUserBaseEntity transInBaseInfo = (PayUserBaseEntity)inParam.get("TRANS_IN");  //转入账户基本信息
		PayUserBaseEntity transOutBaseInfo = (PayUserBaseEntity)inParam.get("TRANS_OUT");  //转出账户基本信息
		
		if(StringUtils.isEmptyOrNull(inParam.get("TRANS_TYPE_OBJ"))){  //传空，默认为在网账户转账
			//transType = (ITransType)JCFContext.getBean("TransAccountEnt");	   //在网账户转账实例化对象
			transType = null;
		}else{
			transType = (ITransType)inParam.get("TRANS_TYPE_OBJ");   //转账类型实例化对象
		}
		
		String opType = inParam.get("OP_TYPE").toString();
			
		long transFee = bookIn.getPayFee();
		
		/*获取转账流水*/
		long tansSn = control.getSequence("SEQ_PAY_SN");
		bookIn.setPaySn(tansSn);
		bookIn.setOriginalSn(tansSn);

		/*转出账户金额转出*/
		inMapTmp = new HashMap<String, Object>();
		List<Map<String, Object>> outBookList = new ArrayList<Map<String,Object>>();
		
		/*转出账户金额转出*/
		if(transType == null && outPayType != null){
			
			outBookList = this.transOut(header, transOutBaseInfo, bookIn, outPayType);
		}else{
			
			outBookList = this.transOut(header, transOutBaseInfo, bookIn, transType, inPaytype);
		}

		// 构建转入账本,默认转入账户为转出账户转出后返回的账本List
		List<Map<String, Object>> inBookList = new ArrayList<Map<String, Object>>();

		if(inPaytype == null || inPaytype.equals("")){
			for (Map<String, Object> outbookMap : outBookList) {
				Map<String, Object> inBookMap = new HashMap<String, Object>();
				inBookMap.put("PAY_TYPE", outbookMap.get("PAY_TYPE"));
				inBookMap.put("CHANGEIN_FEE", outbookMap.get("PAY_FEE"));
				inBookMap.put("BEGIN_TIME", inParam.get("BEGIN_TIME"));
				inBookMap.put("PRINT_FLAG", outbookMap.get("PRINT_FLAG"));
				inBookList.add(inBookMap);
			}
		}else{
			
			for (Map<String, Object> outbookMap : outBookList) {
				Map<String, Object> inBookMap = new HashMap<String, Object>();
				inBookMap.put("PAY_TYPE", inPaytype);
				inBookMap.put("CHANGEIN_FEE", outbookMap.get("PAY_FEE"));
				inBookMap.put("BEGIN_TIME",  bookIn.getBeginTime());
				inBookMap.put("END_TIME", bookIn.getEndTime());
				inBookMap.put("PRINT_FLAG", outbookMap.get("PRINT_FLAG"));
				inBookList.add(inBookMap);
			}
		}
		
		/*转入账户金额转入*/
		bookIn.setPayFee(transFee);
		transIn(header, transInBaseInfo, bookIn, inBookList);
		
		log.info("transBalance end tranSn:"+tansSn);
		
		// 记录转账记录表
		inMapTmp = new HashMap<String, Object>();		
		inMapTmp.put("OP_TYPE", opType);	
		inMapTmp.put("HEADER", header);
		balance.saveTrasfeeInfo(transOutBaseInfo, transInBaseInfo, bookIn, inMapTmp);
		
		return tansSn;
	}
	
	@Override
	public long specialTrans(Map<String, Object> inParam) {

		
		log.info("specialTrans begin: " + inParam.toString());
		
		Map<String, Object> inMapTmp = null;
		ITransType transType = null;
		/*获取入参信息*/
		Map<String, Object> header = (Map<String, Object>)inParam.get("Header"); 
		PayBookEntity bookIn = (PayBookEntity)inParam.get("BOOK_IN");  //入账实体
		PayUserBaseEntity transInBaseInfo = (PayUserBaseEntity)inParam.get("TRANS_IN");  //转入账户基本信息
		PayUserBaseEntity transOutBaseInfo = (PayUserBaseEntity)inParam.get("TRANS_OUT");  //转出账户基本信息
		
		if(StringUtils.isEmptyOrNull(inParam.get("TRANS_TYPE_OBJ"))){  
			throw new BusiException(getErrorCode("0000", "00099"), "账本类型不可为空！");
		}else{
			transType = (ITransType)inParam.get("TRANS_TYPE_OBJ");   //转账类型实例化对象
		}
		
		String opType = inParam.get("OP_TYPE").toString();
			
		long transFee = bookIn.getPayFee();
		
		/*获取转账流水*/
		long tansSn = control.getSequence("SEQ_PAY_SN");
		bookIn.setPaySn(tansSn);
		bookIn.setOriginalSn(tansSn);
		
		
		/*转出账户金额转出*/
		inMapTmp = new HashMap<String, Object>();
		List<Map<String, Object>> outBookList = new ArrayList<Map<String,Object>>();		
		/*转出账户金额转出*/
		outBookList = transOut(header, transOutBaseInfo, bookIn, transType, null);
		
		
		//构建转入账本
		bookIn.setPayType(inParam.get("IN_PAY_TYPE").toString());
		int monthNum = Integer.parseInt(inParam.get("EFFECT_MONTH").toString());    //月数
		
		long lPayFee = transFee/monthNum;
		
		
		String beginTime = inParam.get("BEGIN_DATE").toString().substring(0, 8);
		String endYM = "";
		String endTime="";
		
		if("JT".equals(opType)){
			//endYM = DateUtils.AddMonth(Integer.parseInt(beginTime.substring(0, 6)), monthNum);
			endYM = DateUtil.toStringPlusMonths(beginTime.substring(0, 6), monthNum,"yyyyMM").substring(0, 6);
			endTime = String.valueOf(endYM)+"01000000";
		}else{
			//扩展使用
			endTime = DateUtil.toStringPlusMonths(beginTime.substring(0, 6), monthNum,"yyyyMM")
					+"01000000"; 
		}
		
		
		//进行for循环，分月转账
		for(int i=0;i<monthNum;i++){
			
			if(i==0){
				beginTime = inParam.get("BEGIN_DATE").toString();
			}else{
				//int beginYM = DateUtils.AddMonth(Integer.parseInt(beginTime.substring(0, 6)), 1);
				String beginYM = DateUtil.toStringPlusMonths(beginTime.substring(0, 6), 1,"yyyyMM").substring(0, 6);
				beginTime = beginYM +"01000000";
			}
			
			bookIn.setPayFee(lPayFee);
			bookIn.setBeginTime(beginTime);
			bookIn.setEndTime(endTime);
			
			//3.入账
			saveInBook(header, transInBaseInfo, bookIn);
		}
	
		//入payment表
		bookIn.setPayFee(transFee);
		record.savePayMent(transInBaseInfo, bookIn);
		
		log.info("transBalance end tranSn:"+tansSn);
		
		// 记录转账记录表
		inMapTmp = new HashMap<String, Object>();		
		inMapTmp.put("OP_TYPE", opType);	
		balance.saveTrasfeeInfo(transOutBaseInfo, transInBaseInfo, bookIn, inMapTmp);
		
		return tansSn;
	
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public long specialTransRollCheck(Map<String, Object> inParam){
		
		long outContractNo = Long.parseLong(inParam.get("OUT_CONTRACT_NO").toString());
		long inContractNo = Long.parseLong(inParam.get("IN_CONTRACT_NO").toString());
		long payedSn = Long.parseLong(inParam.get("PAY_SN").toString());
		LoginBaseEntity loginEntity = new LoginBaseEntity();
		loginEntity = (LoginBaseEntity) inParam.get("LOGIN_ENTITY");
		
		/* 取当前年月和当前时间 */
		String sCurTime = inParam.get("CUR_TIEM").toString();
		String sCurYm = inParam.get("CUR_YM").toString();
		String sTotalDate = inParam.get("TOTAL_DATE").toString();
		
		//01验证转账记录表，取转账记录表金额
		//账本表该笔转账金额
		long bookFee = 0l;
		//转账记录表该笔金额
		long transFee = 0l;
		
		List<TransFeeEntity> listTrans = new ArrayList<TransFeeEntity>();
		Map qTransMap =new HashMap();
		qTransMap.put("CONTRACTNO_OUT",outContractNo);
		qTransMap.put("TRANS_SN", payedSn);
		
		listTrans = balance.getTransInfo(qTransMap);
		if(listTrans.size()<1){
			throw new BusiException(getErrorCode("0000", "00003"), "无转账记录，不可以冲正！");
		}
		String opTime = listTrans.get(0).getOpTime();
		transFee = listTrans.get(0).getTransFee();
		
		
		
		//02查询来源表，查询账本表该笔转账金额
		int yearMonth = ValueUtils.intValue(opTime.substring(0,6));
		inParam.put("POSITIVE", "POSITIVE");
		inParam.put("SUFFIX", yearMonth);
		List<Map<String, Object>> bookSourceList = baseDao.queryForList("bal_booksource_info.qBookSourceByPaySn", inParam);
		if (bookSourceList.size() == 0) {
			throw new BusiException(getErrorCode("0000", "00004"), "专款已消费或不存在,不能进行冲正!！");
		}
		
		List balanceIds = new ArrayList();
		
		for (Map<String, Object> bookSource : bookSourceList) {
			
			long balanceId = ValueUtils.longValue(bookSource.get("BALANCE_ID").toString());
			String balanceStr = String.valueOf(balanceId);
			balanceIds.add(balanceStr);
		}
		
		Map inMap = new HashMap();
		inMap.put("BALANCE_ID_STR", balanceIds);
		inMap.put("CONTRACT_NO", inContractNo);
		inMap.put("ALL", "ALL");
		bookFee = balance.getAcctSumCurBalance(inMap);
		
		
		//根据转账记录和账本表判断是否消费
		if(bookFee -  transFee < 0){
			throw new BusiException(getErrorCode("0000", "00004"), "专款已消费或不存在,不能进行冲正!！");
		}
		
		
		//03验证交费信息
		Map inMapTmp = new HashMap<String , Object>();
		inMapTmp.put("PAY_SN", payedSn);
		inMapTmp.put("SUFFIX", Long.parseLong(opTime.substring(0, 6)));
		List<PayMentEntity> outPayList = record.getPayMentList(inMapTmp);
		if ( 0 == outPayList.size() ){
				log.info("交费记录不存在pay_sn : " +String.valueOf(payedSn));
				throw new BusiException(AcctMgrError.getErrorCode("8056","00001"), "交费记录不存在pay_sn: " + String.valueOf(payedSn));
		}
		PayMentEntity payEntity = outPayList.get(0);
		long idNo = payEntity.getIdNo();
		String payPhone = payEntity.getPhoneNo();
		if( payEntity.getStatus().equals("1") || payEntity.getStatus().equals("3") ){
				log.info("该条缴费记录已经冲正 pay_sn : " + String.valueOf(payedSn) + "contract_no:"+ outContractNo);
				throw new BusiException(AcctMgrError.getErrorCode("0000","10008"), "该条缴费记录已经冲正 " );
		}
		
		return transFee;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public long specialTransRollBack(Map<String, Object> inParam) {
		
		long payedSn = Long.parseLong(inParam.get("PAY_SN").toString());
		LoginBaseEntity loginEntity = new LoginBaseEntity();
		loginEntity = (LoginBaseEntity) inParam.get("LOGIN_ENTITY");
		
		/* 取当前年月和当前时间 */
		String sCurTime = inParam.get("CUR_TIEM").toString();
		String sCurYm = inParam.get("CUR_YM").toString();
		String sTotalDate = inParam.get("TOTAL_DATE").toString();
		
		//获取回退流水
		long backPaysn = control.getSequence("SEQ_PAY_SN");
		
		long transContractNo = 0L;
		
		String payedTime = inParam.get("PAYED_TIME").toString();
		String payedYm = payedTime.substring(0,6);
		
		//查询来源表
		Map qBookMap = new HashMap(); 
		qBookMap.put("SUFFIX", payedYm);
		qBookMap.put("PAY_SN", payedSn);
		List<Map<String, Object>> bookSourceList = baseDao.queryForList("bal_booksource_info.qBookSourceByPaySn", qBookMap);
		
		
		//遍历来源表进行回退历史表，回退来源表
		for( Map<String, Object> balanceidMapTmp : bookSourceList ){
			
			long prepayFee=0;			//该账本实际入账金额
			 
			long balanceId = Long.valueOf( balanceidMapTmp.get("BALANCE_ID").toString() );
			long payFee = Long.parseLong(balanceidMapTmp.get("PAY_FEE").toString());
			String sourceStatus = balanceidMapTmp.get("STATUS").toString();
			transContractNo = Long.valueOf(balanceidMapTmp.get("CONTRACT_NO").toString());
			
			
			/*（1）.回退来源表  : 更新表状态、表记录负记录*/
			Map<String, Object> inRobackMap = new HashMap<String, Object>();
			inRobackMap.put("PAY_SN", inParam.get("PAY_SN"));
			inRobackMap.put("BALANCE_ID", balanceId);
			inRobackMap.put("STATUS", sourceStatus);
			inRobackMap.put("PAY_BACK_SN", backPaysn);
			inRobackMap.put("TOTAL_DATE", sTotalDate);
			inRobackMap.put("LOGIN_NO", loginEntity.getLoginNo());
			inRobackMap.put("GROUP_ID", loginEntity.getGroupId());
			inRobackMap.put("YM", payedYm);
			inRobackMap.put("YEAR_MONTH", sCurYm);
			doRollbackBookSource(inRobackMap);
			
			/*（2）.回退账本余额*/
			Map inMapTmp = new HashMap<String , Object>();
			Map outMapTmp = new HashMap();
			inMapTmp.put( "BALANCE_ID" , balanceId );
			outMapTmp = (Map<String , Object>)baseDao.queryForObject( "bal_acctbook_info.qByBalanceId" , inMapTmp );
			long curBalance = 0;
			if( outMapTmp == null ){
				
				//账本历史表移到正式表
				inMapTmp = new HashMap<String, Object>();
				inMapTmp.put("CONTRACT_NO", transContractNo);
				inMapTmp.put("BALANCE_ID", balanceId);
				baseDao.insert("bal_acctbook_info.iAcctbookByHis", inMapTmp);
				//删除历史表记录
				baseDao.delete("bal_acctbook_his.delAcctbookHis", inMapTmp);
				
				curBalance = 0;
			}else {
				curBalance = Long.valueOf(outMapTmp.get("CUR_BALANCE").toString());
			}
			log.info("------>  curBalance="+curBalance+","+payFee);
			
			//没有进行销账，所以回退金额等于来源表金额
			prepayFee = payFee;
			
			if( curBalance >= payFee ){	
				
				inMapTmp.put("PAYED_OWE", prepayFee );
				int num = balance.updateAcctBook(inMapTmp);
				if(num <= 0){
					
					log.info("更新账本出错 balance_id : " + balanceId );
					throw new BusiException(AcctMgrError.getErrorCode("0000","10044"), "更新账本出错 balance_id : " + balanceId);
					
				}
				
			}else{
				log.info("else------>  curBalance="+curBalance+","+payFee);
				log.info("账本余额不足，不够回退 balance_id : " + balanceId + "cur_balance :"
						+ curBalance + "应该入账金额: " + prepayFee );
				throw new BusiException(AcctMgrError.getErrorCode("0000","10009"), "账本余额不足，不够回退 balance_id : " + balanceId + "，cur_balance :"
						+ ValueUtils.transFenToYuan(curBalance) + " 元，应该入账金额: " + ValueUtils.transFenToYuan(prepayFee) + " 元");
			}
		}
		
		/* 给实时销账同步账本余额*/
		/*同步实时销账*/
		Map<String, Object> rtWrtoffMap = new HashMap<String, Object>();
		rtWrtoffMap.put("PAY_SN", backPaysn);
		rtWrtoffMap.put("CONTRACT_NO", transContractNo);
		rtWrtoffMap.put("WRTOFF_FLAG", "2");
		rtWrtoffMap.put("REMARK", "冲正同步");
		balance.saveRtwroffChg(rtWrtoffMap);
		
		/*循环取缴费账户*/
		Map inMapTmp = new HashMap<String , Object>();
		inMapTmp.put("PAY_SN", payedSn);
		inMapTmp.put("SUFFIX", payedYm);
		long idNo = 0;
		long sumBackFee = 0;
		long contractNo = 0;
		List<Map<String, Object>> keysList = new ArrayList<Map<String,Object>>();	//同步报表库数据List
		//空中充值冲正统一接触需要发送两条
		//List<Map<String, Object>> phonesList = (List<Map<String, Object>>)baseDao.queryForList( "bal_payment_info.qBalConByPaysnKc" , inMapTmp);	
		List<Map<String, Object>> resultList = (List<Map<String, Object>>)baseDao.queryForList( "bal_payment_info.qBalConByPaysn" , inMapTmp);
		for( Map<String, Object> resultMap : resultList ){
			
			long contractNoP = Long.valueOf( resultMap.get("CONTRACT_NO").toString() );
			String payType = resultMap.get("PAY_TYPE").toString();
			idNo = Long.valueOf( resultMap.get("ID_NO").toString() );
			sumBackFee = sumBackFee + (-1)*Long.parseLong(resultMap.get("PAY_FEE").toString()); //发送统一接触，所以传负值
			
			contractNo = contractNoP;
			
			//1.更新payment表
			Map<String, Object> inBackpayMap = new HashMap<String, Object>();
			inBackpayMap.put("PAY_SN", payedSn);
			inBackpayMap.put("SUFFIX", payedYm);
			inBackpayMap.put("PAY_TYPE", payType);
			baseDao.update("bal_payment_info.uStatus", inBackpayMap);
			
			Map<String, Object> paymentKey = null;
			paymentKey = new HashMap<String, Object>();
			paymentKey.put("YEAR_MONTH", sCurYm);
			paymentKey.put("CONTRACT_NO", contractNoP);
			paymentKey.put("PAY_SN", resultMap.get("PAY_SN"));
			paymentKey.put("ID_NO", idNo);
			paymentKey.put("PAY_TYPE", resultMap.get("PAY_TYPE"));
			paymentKey.put("TABLE_NAME", "BAL_PAYMENT_INFO");
			paymentKey.put("UPDATE_TYPE", "U");
			keysList.add(paymentKey);
			
			//2.payment表记录负记录
			inBackpayMap.put("PAY_BACK_SN", backPaysn);
			inBackpayMap.put("CONTRACT_NO", contractNo);
			inBackpayMap.put("OP_CODE", loginEntity.getOpCode());
			inBackpayMap.put("REMARK", loginEntity.getOpNote());
			inBackpayMap.put("LOGIN_NO", loginEntity.getLoginNo());
			inBackpayMap.put("GROUP_ID", loginEntity.getGroupId());
			inBackpayMap.put("TOTAL_DATE", sTotalDate);
			inBackpayMap.put("PAY_PATH", inParam.get("PAY_PATH"));
			inBackpayMap.put("PAY_METHOD", inParam.get("PAY_METHOD"));
			inBackpayMap.put("ORIGINAL_SN", payedSn);			
			inBackpayMap.put("SUFFIX1", sCurYm);
			inBackpayMap.put("PAY_TYPE", payType);
			inBackpayMap.put("FOREIGN_SN", inParam.get("FOREIGN_SN"));
			baseDao.insert("bal_payment_info.iForRoback", inBackpayMap);
			
		}
		
		
		
		//回退转账记录表,冲正流水和payment流水一致
		Map inTransMap = new HashMap<String, Object>();
		inTransMap.put("PAY_YM", payedYm);
		inTransMap.put("PAY_SN", payedSn);
		inTransMap.put("BACK_SN", backPaysn);
		inTransMap.put("OP_CODE", loginEntity.getOpCode());
		inTransMap.put("LOGIN_NO", loginEntity.getLoginNo());
		doRollbackTransfee(inTransMap);
		
		return backPaysn;
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public long trans(Map<String, Object> inParam) {
		ITransType transType = null;

		//获取入参
		Map<String, Object> header = (Map<String, Object>)inParam.get("Header");
		PayBookEntity bookIn = (PayBookEntity)inParam.get("BOOK_IN");  //入账实体
		PayUserBaseEntity transInBaseInfo = (PayUserBaseEntity)inParam.get("TRANS_IN");  //转入账户基本信息
		PayUserBaseEntity transOutBaseInfo = (PayUserBaseEntity)inParam.get("TRANS_OUT");  //转出账户基本信息
		String opType = inParam.get("OP_TYPE").toString();
		String writeoff_flag= inParam.get("WRITEOFF_FLAG").toString(); //冲销标志,Y:冲销,N:不冲销
		String loginopr_flag=inParam.get("LOGINOPR_FLAG").toString();  //记录营业日志标志,Y:记录,N:不记录
		if(StringUtils.isEmptyOrNull(inParam.get("TRANS_TYPE_OBJ"))){  //传空，默认为在网账户转账
			transType = (ITransType)JCFContext.getBean("Account");	   //在网账户转账实例化对象
		}else{
			transType = (ITransType)inParam.get("TRANS_TYPE_OBJ");   //转账类型实例化对象
		}

		/*转账*/
		Map<String, Object> inTransCfmMap = inParam;
		safeAddToMap(inTransCfmMap, "Header", header);
		safeAddToMap(inTransCfmMap, "TRANS_TYPE_OBJ", transType); //转账类型实例化对象
		safeAddToMap(inTransCfmMap, "TRANS_IN", transInBaseInfo);  //转入账户基本信息
		safeAddToMap(inTransCfmMap, "TRANS_OUT", transOutBaseInfo); //转出账户基本信息
		safeAddToMap(inTransCfmMap, "BOOK_IN", bookIn); //入账实体
		safeAddToMap(inTransCfmMap, "OP_TYPE", opType); //操作类型
		long paySn = transBalance(inTransCfmMap);

		if(writeoff_flag.equals("Y")){
			/* 缴费用户冲销欠费 */
			inTransCfmMap = new HashMap<String, Object>();
			safeAddToMap(inTransCfmMap, "Header", header);
			safeAddToMap(inTransCfmMap, "CONTRACT_NO",transInBaseInfo.getContractNo() );
			safeAddToMap(inTransCfmMap, "PAY_SN", paySn);
			safeAddToMap(inTransCfmMap, "PHONE_NO", transInBaseInfo.getPhoneNo());
			safeAddToMap(inTransCfmMap, "LOGIN_NO", bookIn.getLoginNo());
			safeAddToMap(inTransCfmMap, "OP_CODE", bookIn.getOpCode());
			safeAddToMap(inTransCfmMap, "GROUP_ID", bookIn.getGroupId());
			safeAddToMap(inTransCfmMap, "PAY_PATH", bookIn.getPayPath());
			safeAddToMap(inTransCfmMap, "DELAY_FAVOUR_RATE", "0");
			writeOffer.doWriteOff(inTransCfmMap);
		}

		if(loginopr_flag.equals("Y")){
			/* 转出号码：记录营业员操作日志 */
			LoginOprEntity outTransOpr = new LoginOprEntity();
			outTransOpr.setBrandId(transOutBaseInfo.getBrandId());
			outTransOpr.setIdNo(transOutBaseInfo.getIdNo());
			outTransOpr.setLoginGroup(bookIn.getGroupId());
			outTransOpr.setLoginNo(bookIn.getLoginNo());
			outTransOpr.setLoginSn(paySn);
			outTransOpr.setOpCode(bookIn.getOpCode());
			outTransOpr.setOpTime(bookIn.getOpTime());
			outTransOpr.setPayFee((-1) * bookIn.getPayFee());
			outTransOpr.setPhoneNo(transOutBaseInfo.getPhoneNo());
			outTransOpr.setRemark(bookIn.getOpNote());
			outTransOpr.setPayType("");
			outTransOpr.setTotalDate(bookIn.getTotalDate());
			record.saveLoginOpr(outTransOpr);

			/* 转入号码：记录营业员操作日志 */
			LoginOprEntity inTransOpr = new LoginOprEntity();
			inTransOpr.setBrandId(transInBaseInfo.getBrandId());
			inTransOpr.setIdNo(transInBaseInfo.getIdNo());
			inTransOpr.setLoginGroup(bookIn.getGroupId());
			inTransOpr.setLoginNo(bookIn.getLoginNo());
			inTransOpr.setLoginSn(paySn);
			inTransOpr.setOpCode(bookIn.getOpCode());
			inTransOpr.setOpTime(bookIn.getBeginTime());
			inTransOpr.setPayFee(bookIn.getPayFee());
			inTransOpr.setPhoneNo(transInBaseInfo.getPhoneNo());
			inTransOpr.setRemark(bookIn.getOpNote());
			inTransOpr.setPayType("");
			inTransOpr.setTotalDate(bookIn.getTotalDate());
			record.saveLoginOpr(inTransOpr);
		}

		return paySn;
	}
	
	/*在网、离网账户金额转出*/
	public List<Map<String, Object>> transOut(Map<String, Object> header, PayUserBaseEntity transOutBaseInfo,
			PayBookEntity bookIn, ITransType transType, String inPayType) {		
		
		List<Map<String, Object>> outParamList = new ArrayList<Map<String,Object>>(); //构建出参List
		
		//获取可转账本列表
		List<Map<String, Object>>  transOutBookList = transType.getTranFeeList(transOutBaseInfo.getContractNo());
		log.info("---->transOutBookList : "+ transOutBookList.toString());
		if(inPayType != null){
			for (Iterator bC = transOutBookList.iterator(); bC.hasNext();) {

				Map<String, Object> bookTmp = (Map<String, Object>) bC.next();
				if(inPayType.equals(bookTmp.get("PAY_TYPE").toString())){
					bC.remove();
				}
			}
		}
		log.info("---->transOutBookList2 "+ transOutBookList);

		outParamList = this.transOut(header, transOutBaseInfo, bookIn, transOutBookList);

		log.info("transOut end: " + outParamList.toString());	
		
		return outParamList;
	}
	
	private List<Map<String, Object>> transOut(Map<String, Object> header, PayUserBaseEntity transOutBaseInfo,
			PayBookEntity bookIn, String outPayType) {		
		
		List<Map<String, Object>> outParamList = new ArrayList<Map<String,Object>>(); //构建出参List
		
		//获取可转账本列表
		List<Map<String, Object>>  transOutBookList = this.getTranFeeList(transOutBaseInfo.getContractNo(), outPayType);
		log.info("---->transOutBookList size: "+transOutBookList.size());

		outParamList = this.transOut(header, transOutBaseInfo, bookIn, transOutBookList);

		log.info("transOut end: " + outParamList.toString());	
		
		return outParamList;
	}
	
	
	/**
	* 名称：转出核心逻辑
	* @param transOutBookList 为转出账户待转出账本列表,循环该列表做转账
	* @return 
	* @throws 
	*/
	private List<Map<String, Object>> transOut(Map<String, Object> header, PayUserBaseEntity transOutBaseInfo,
			PayBookEntity bookIn, List<Map<String, Object>> transOutBookList){
		
		List<Map<String, Object>> outParamList = new ArrayList<Map<String,Object>>(); //构建出参List
		List<Map<String, Object>> outbookList = new ArrayList<Map<String,Object>>();  //转出后，转出账本列表
		Map<String, Object> inMapTmp = null;
		long outFee = 0;  //计算转出总费用
		
		long transoutFee = bookIn.getPayFee();
		boolean isOnNet = transOutBaseInfo.isNetFlag();
		
		//循环账户可转账本
		for( Map<String, Object>book : transOutBookList ){
			long oneBalance = Long.parseLong(book.get("CUR_BALANCE").toString());
			long changeFeeTmp = 0;
			
	        if(oneBalance <= 0){
	        	continue;
	        }
	        
			if (transoutFee > oneBalance) {
				changeFeeTmp = oneBalance;
			} else {
				changeFeeTmp = transoutFee;
			} 
			
	        log.info("------>oneBalance="+oneBalance+",changeFeeTmp="+changeFeeTmp);
	        
	        transoutFee = transoutFee-changeFeeTmp; 
	        if(0 == changeFeeTmp){
	        	log.info("账本转出完成");
	        	break;
	        }
	        outFee = outFee + changeFeeTmp;		//转出预存总和
	        
	        //账本转出：更新账本表
	        int num = 0 ;
			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("BALANCE_ID", book.get("BALANCE_ID"));
			inMapTmp.put("PAYED_OWE", changeFeeTmp);
			if(isOnNet){
				num = balance.updateAcctBook(inMapTmp);	
				
				// 增加转出后账本预存款校验 转出后预存款不能为负
				this.checkTransOutFee(Long.parseLong(book.get("BALANCE_ID").toString()));
			}else{
				num = balance.updateAcctBookDead(Long.parseLong(book.get("BALANCE_ID").toString()), changeFeeTmp);
			}
			
			//判断账本是否更新成功
			if (num != 1) {
				log.error("更新账本出错 balance_id : " + book.get("BALANCE_ID").toString());
				throw new BusiException(AcctMgrError.getErrorCode("8014", "10020"),
						"更新账本出错 balance_id : " + book.get("BALANCE_ID").toString());
			}
			//记录来源表
			bookIn.setBalanceId(Long.parseLong(book.get("BALANCE_ID").toString()));
			bookIn.setPayType(book.get("PAY_TYPE").toString());
			bookIn.setPayFee((-1) * changeFeeTmp);
			bookIn.setStatus("5");
			balance.saveSource(transOutBaseInfo, bookIn);
			
			//构建入payment表的paytype和paymoney List，防止入payment表主键冲突
			int flag = 0;
			for(Map<String, Object> oneOutbook : outbookList){
				if( oneOutbook.get("PAY_TYPE").toString().equals(book.get("PAY_TYPE").toString()) ){
					long oneOutbookFee = Long.parseLong(oneOutbook.get("PAY_MONEY").toString());
					oneOutbook.put("PAY_MONEY", oneOutbookFee + changeFeeTmp );
					flag = 1;
				}else{
					continue;
				}
			}
			if( 0 == flag ){
				Map<String, Object> paymentMap = new HashMap<String, Object>();
				paymentMap.put("PAY_TYPE", book.get("PAY_TYPE"));
				paymentMap.put("PAY_MONEY", changeFeeTmp);
				outbookList.add(paymentMap);
			}
			
	        //构建出参List
			Map<String, Object> outBookMap = new HashMap<String, Object>();
			outBookMap.put("BALANCE_ID", book.get("BALANCE_ID"));
			outBookMap.put("PAY_TYPE", book.get("PAY_TYPE"));
			outBookMap.put("PRINT_FLAG", book.get("PRINT_FLAG"));
			outBookMap.put("PAY_FEE", changeFeeTmp);
			outParamList.add(outBookMap);
		}
		// 判断实际转出金额和要转出金额是否一样
		if(transoutFee != 0){
			String sTranF = String.format("%.2f", (double)transoutFee/100);

			log.info("实际转出帐号转出金额和要转出金额不符合,相差：" + sTranF + " 元!");
			throw new BusiException(AcctMgrError.getErrorCode("8014","00036"), 
					"实际转出帐号转出金额和要转出金额不符合,相差：" + sTranF + " 元!");
		}

		//记录payment表
		for(Map<String, Object> payment : outbookList){
			bookIn.setPayType(payment.get("PAY_TYPE").toString());
			bookIn.setPayFee((-1) * (Long) payment.get("PAY_MONEY"));
			bookIn.setStatus("0");
			record.savePayMent(transOutBaseInfo, bookIn);
		}

		/*转账同步 同步实时销账、同步报表*/
		transSyn(transOutBaseInfo, bookIn, outbookList,header);

		log.info("transOut end: " + outParamList.toString());	
		
		return outParamList;
	}
	
	private List<Map<String, Object>> getTranFeeList(long inContractNo, String outPayType){
		List<Map<String, Object>> outList = new ArrayList<Map<String, Object>>();
		Map<String, Object> inMap = new HashMap<String, Object>();
		
		inMap.put("CONTRACT_NO", inContractNo);	
		inMap.put("PAY_TYPE", outPayType);  //账本可转属性  0：表示可转  1：表示不可转
		
		outList = balance.getAcctBookList(inMap);

		return outList;
	}
	
	
	/**
	 * 名称：账户金额转入
	 * @param header
	 * @param transInBaseInfo
	 * @param bookIn
	 * @param inBookList：CHANGEIN_FEE 转账金额,BEGIN_TIME 开始时间,PAY_TYPE 账本类型,PRINT_FLAG 打印标识
	 */
	public void transIn(Map<String, Object> header, PayUserBaseEntity transInBaseInfo, PayBookEntity bookIn,
			List<Map<String, Object>> inBookList) {

		long transinFee = bookIn.getPayFee();
		long sumInfee = 0;
		List<Map<String, Object>> inbookList = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> bookInList = new ArrayList<Map<String,Object>>();
		for(Map<String, Object> book : inBookList){
			sumInfee = sumInfee + Long.parseLong(book.get("CHANGEIN_FEE").toString());
			
			String beginTime = bookIn.getBeginTime();
			if(book.get("BEGIN_TIME") != null && !book.get("BEGIN_TIME").equals("")){			
				beginTime = book.get("BEGIN_TIME").toString();
			}
			
			//获取balanceId
			long balanceId = control.getSequence("SEQ_BALANCE_ID");
			
			//记录账本表
			bookIn.setBalanceId(balanceId);
			bookIn.setPayType(book.get("PAY_TYPE").toString());
			bookIn.setPayFee(Long.parseLong(book.get("CHANGEIN_FEE").toString()));
			bookIn.setPrintFlag(book.get("PRINT_FLAG").toString());
			bookIn.setBeginTime(beginTime);
			balance.saveAcctBook(transInBaseInfo, bookIn);
			
			//入来源表
			bookIn.setStatus("5");
			balance.saveSource(transInBaseInfo, bookIn);
			
			//构建入payment表的paytype和paymoney List，防止入payment表主键冲突
			int flag = 0;
			for(Map<String, Object> oneInbook : inbookList){
				if( oneInbook.get("PAY_TYPE").toString().equals(book.get("PAY_TYPE").toString()) ){
					long oneInbookFee = Long.parseLong(oneInbook.get("PAY_MONEY").toString());
					oneInbook.put("PAY_MONEY", oneInbookFee + Long.parseLong(book.get("CHANGEIN_FEE").toString()) );
					flag = 1;
				}else{
					continue;
				}
			}
			if( 0 == flag ){
				Map<String, Object> paymentMap = new HashMap<String, Object>();
				paymentMap.put("PAY_TYPE", book.get("PAY_TYPE"));
				paymentMap.put("PAY_MONEY", Long.parseLong(book.get("CHANGEIN_FEE").toString()));
				inbookList.add(paymentMap);
			}
		}
		
		if(transinFee != sumInfee){
			log.info("转入账本List和转入总金额不符：" + "List: " + bookInList.toString()
					+ "总转入金额: " + transinFee );
			throw new BusiException(AcctMgrError.getErrorCode("8014","00037"), 
					"转入账本列表金额总和和转入总金额不符");
		}

		//记录payment表
		for(Map<String, Object> payment : inbookList){
			bookIn.setPayType(payment.get("PAY_TYPE").toString());
			bookIn.setPayFee((Long) payment.get("PAY_MONEY"));
			bookIn.setStatus("0");
			record.savePayMent(transInBaseInfo, bookIn);
		}
		
		//转账同步 同步实时销账、同步报表
		//bookIn.setOpNote("转账转入同步");
		transSyn(transInBaseInfo, bookIn, inbookList,header);
		
		log.info("transIn end");
	}

	/*转账同步实时销账、同步报表*/
	private void transSyn(PayUserBaseEntity transOutBaseInfo, PayBookEntity bookIn,
			List<Map<String, Object>> outbookList,Map<String,Object> header) {
		
		/* 给实时销账同步账本变化 */
		Map<String, Object> rtWrtoffMap = new HashMap<String, Object>();
		rtWrtoffMap.put("PAY_SN", bookIn.getPaySn());
		rtWrtoffMap.put("CONTRACT_NO", transOutBaseInfo.getContractNo());
		rtWrtoffMap.put("WRTOFF_FLAG", "2");
		rtWrtoffMap.put("REMARK", bookIn.getOpNote());
		balance.saveRtwroffChg(rtWrtoffMap);
		
		/* 同步报表keyData */
		List<Map<String, Object>> keysList = new ArrayList<Map<String, Object>>();

		for (Map<String, Object> payment : outbookList) {
			/* 同步报表keyData */
			Map<String, Object> paymentKey = new HashMap<String, Object>();
			paymentKey.put("YEAR_MONTH", bookIn.getYearMonth());
			paymentKey.put("CONTRACT_NO", transOutBaseInfo.getContractNo());
			paymentKey.put("PAY_SN", bookIn.getPaySn());
			paymentKey.put("ID_NO", transOutBaseInfo.getIdNo());
			paymentKey.put("PAY_TYPE", payment.get("PAY_TYPE"));
			paymentKey.put("TABLE_NAME", "BAL_PAYMENT_INFO");
			paymentKey.put("UPDATE_TYPE", "I");
			keysList.add(paymentKey);
		}
		
		/* TODO　同步报表 */
		Map<String, Object> reportMap = new HashMap<String, Object>();
		reportMap.put("ACTION_ID", "1001");
		reportMap.put("KEYS_LIST", keysList);
		reportMap.put("LOGIN_SN", bookIn.getPaySn());
		reportMap.put("OP_CODE", bookIn.getOpCode());
		reportMap.put("LOGIN_NO", bookIn.getLoginNo());
		log.info("------> reportMap_tot=" + reportMap.entrySet());
		preOrder.sendReportDataList(header,reportMap);
	}
	
	public void doRollbackCheck(long paySn, String loginNo, int yearMonth, Long contractNo, Map<String, Object> header) {
		
		Map<String, Object> inMapTmp = null;
		
		log.info( "缴费冲正查询doRollbackCheck begin" );
		
		/*取交费信息*/
		inMapTmp = new HashMap<String , Object>();
		if(contractNo != null && contractNo != 0){
			inMapTmp.put("CONTRACT_NO", contractNo);
		}
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("STATUS", "0");
		inMapTmp.put("SUFFIX", yearMonth);
		List<PayMentEntity> outPayList = record.getPayMentList(inMapTmp);
		if ( 0 == outPayList.size() ){
			log.info("交费记录不存在pay_sn : " + paySn );
			throw new BusiException(AcctMgrError.getErrorCode("8056","00001"), "交费记录不存在pay_sn :  " + paySn );
		}
		PayMentEntity payEntity = outPayList.get(0);
		
		/*
		 * 调用内部接口实现分省缴费冲正业务、个性化权限限制
		 */
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("LOGIN_NO", loginNo);
		inMapTmp.put("PAYMENT_ENTITY", payEntity);
		inMapTmp.put("Header", header);
		payBackLimit.check(inMapTmp);
		
	}
	
	
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> doDeadRollback(Map<String, Object> inParam){
		
		log.info("doDeadRollback inParam->"+inParam.toString());
		long backPaysn = (Long) inParam.get("PAY_BACK_SN");
		long paySn = (Long) inParam.get("PAY_SN");
		int payTotalDate = (Integer) inParam.get("PAY_DATE");
		int payYearMonth = (Integer) inParam.get("PAY_YM");
		String curYm = (String) inParam.get("CUR_YM");
		String totalDate = (String) inParam.get("CUR_DATE");
		String curTime = (String) inParam.get("CUR_TIME");
		String loginNo = (String) inParam.get("LOGIN_NO");
		String loginGroup = (String) inParam.get("LOGIN_GROUP");
		String opCode = (String) inParam.get("OP_CODE");
		String opNotes = (String) inParam.get("OP_NOTE");
		long idNo = (Long) inParam.get("ID_NO");
		String phoneNo = (String) inParam.get("PHONE_NO");
		long custId = (Long) inParam.get("CUST_ID");
		int userFlag = 1;
		
		Map<String , Object> outParam = new HashMap<String , Object>();
		List<Map<String, Object>> keysList = new ArrayList<Map<String, Object>>();  //同步报表库列表构造
		Map<String , Object> inMapTmp = null;
		Map<String , Object> outMapTmp = null;
		
		/*循环取缴费账户*/
		inMapTmp = new HashMap<String , Object>();
		inMapTmp.put( "PAY_SN" , paySn);
		inMapTmp.put( "SUFFIX" , payYearMonth);
		List<Map<String, Object>> resultList = (List<Map<String, Object>>)baseDao.queryForList( "bal_payment_info.qBalConByPaysn" , inMapTmp);		
		for( Map<String, Object> resultMap : resultList ){		
			long contractNo = Long.parseLong(resultMap.get("CONTRACT_NO").toString());
			String payType = resultMap.get("PAY_TYPE").toString();
			
			/*遍历来源表*/
			inMapTmp = new HashMap<String , Object>();
			inMapTmp.put( "PAY_SN" ,paySn);
			inMapTmp.put( "CONTRACT_NO" , contractNo );
			inMapTmp.put( "SUFFIX" , payYearMonth);
			List<Map<String, Object>> resultList2 = (List<Map<String, Object>>)baseDao.queryForList( "bal_booksource_info.qBalanceidByPaySn" , inMapTmp);
			
			for( Map<String, Object> balanceidMapTmp : resultList2 ){
				
				long sumPayoutfee = 0;
				long prepayFee=0;			//该账本实际入账金额
				long conBackFee = 0;
				 
				long balanceId = Long.parseLong(balanceidMapTmp.get("BALANCE_ID").toString());
				String status = balanceidMapTmp.get("STATUS").toString();
				
				inMapTmp.put( "BALANCE_ID" , balanceId);
				long payFee = (Long)baseDao.queryForObject("bal_booksource_info.qSumPayfee", inMapTmp);
				
				conBackFee = conBackFee + payFee;
				prepayFee = payFee + sumPayoutfee;
				
				/*取销账流水*/
				inMapTmp = new HashMap<String, Object>();
				inMapTmp.put( "SEQ_NAME", "SEQ_PAY_SN" );
				
				/*
				 * 根据支出表，依次回退 冲销账单、冲销记录、支出记录
				 * */
				inMapTmp = new HashMap<String, Object>();
				inMapTmp.put("BACK_PAYSN", backPaysn);
				inMapTmp.put( "BALANCE_ID" , balanceId );
				inMapTmp.put("YEAR_MONTH", payYearMonth);
				inMapTmp.put( "LOGIN_NO" , loginNo );
				inMapTmp.put( "GROUP_ID" , loginGroup );
				inMapTmp.put( "CONTRACT_NO" , contractNo );
				inMapTmp.put("ID_NO", idNo);
				long payoutFee = doRobackDeadPayoutInfo(inMapTmp);
				sumPayoutfee = sumPayoutfee + payoutFee;
				prepayFee -= sumPayoutfee;
				
				/*3.回退来源表  : 更新表状态、表记录负记录*/
				Map<String , Object> inRobackMap = new HashMap<String , Object>();
				inRobackMap.put("PAY_SN", paySn);
				inRobackMap.put("STATUS", status);
				inRobackMap.put( "BALANCE_ID" , balanceId );
				inRobackMap.put( "PAY_BACK_SN" , backPaysn );
				inRobackMap.put( "TOTAL_DATE" , totalDate );
				inRobackMap.put( "LOGIN_NO" , loginNo );
				inRobackMap.put( "GROUP_ID" , loginGroup );
				inRobackMap.put( "OP_CODE" , opCode );
				inRobackMap.put( "OP_NOTE" , opNotes );
				inRobackMap.put("YM", payYearMonth );
				inRobackMap.put("YEAR_MONTH", curYm);
				doRollbackBookSource(inRobackMap);
				
				/*5.回退账本余额*/
				if (userFlag == 1) {
					inMapTmp = new HashMap<String , Object>();
					inMapTmp.put( "BALANCE_ID" , balanceId );
					inMapTmp.put( "CONTRACT_NO" , contractNo );
					
					outMapTmp = (Map<String , Object>)baseDao.queryForObject( "bal_acctbook_dead.qByBalanceId" , inMapTmp );
					if(outMapTmp!=null){
						long curBalance = (Long)baseDao.queryForObject( "bal_acctbook_dead.qAcctBookDeadByCon" , inMapTmp );
						
						log.info("curBalance=" + curBalance + ",prepayFee=" + prepayFee );
						
						if( curBalance >= prepayFee ){		//当前账本预存款等于实际该账本入账金额，则回退账本
							inMapTmp.put("PAYED_OWE", prepayFee );
							baseDao.update("bal_acctbook_dead.uAcctbookDeadByBalance",inMapTmp);
						}else{
							log.error("账本余额不足，不够回退 balance_id : " + balanceId + "cur_balance :"
									+ curBalance + "应该入账金额: " + prepayFee );
							throw new BusiException(AcctMgrError.getErrorCode("8007","00005"), "账本余额不足，不够回退");
						}
					}else{
						/*历史表移入正式表*/
						inMapTmp = new HashMap<String , Object>();
						inMapTmp.put( "CONTRACT_NO" , contractNo );
						inMapTmp.put( "BALANCE_ID" , balanceId );
						inMapTmp.put( "LOGIN_NO" , loginNo );
						if (userFlag == 1) {
							inMapTmp.put( "SUFFIX1" , curYm );
							baseDao.insert("bal_acctbook_dead.iAcctbookDeadByHis",inMapTmp);
							baseDao.delete("bal_acctbook_his.delAcctbookHis",inMapTmp);
						} else {
							balance.removeAcctBook(contractNo, loginNo);
						}
					}
					
				} 
				
				/*else {
					inMapTmp = new HashMap<String , Object>();
					inMapTmp.put( "BALANCE_ID" , balanceId );
					outMapTmp = (Map<String , Object>)baseDao.queryForObject( "bal_acctbook_info.qByBalanceId" , inMapTmp );
					long curBalance = 0;
					if( outMapTmp == null ){
							curBalance = 0;
					}else {
						curBalance = Long.valueOf(outMapTmp.get("CUR_BALANCE").toString());
					}
					log.info("curBalance=" + curBalance + ",prepayFee=" + prepayFee);
					if( curBalance >= prepayFee ){		//当前账本预存款等于实际该账本入账金额，则回退账本
						inMapTmp.put("PAYED_OWE", prepayFee );
						balance.updateAcctBook(inMapTmp);
					}else{
						log.error("账本余额不足，不够回退 balance_id : " + balanceId + "cur_balance :"
								+ curBalance + "应该入账金额: " + prepayFee );
						throw new BusiException(AcctMgrError.getErrorCode("8003","00001"), "账本余额不足，不够回退");
					}
				}	*/			
			}
			
			// 回退交费记录，更新交费记录表原状态为冲正状态
			Map<String, Object> inBackpayMap = new HashMap<String, Object>();
			inBackpayMap.put("PAY_SN", paySn);
			inBackpayMap.put("SUFFIX", payYearMonth);
			inBackpayMap.put("PAY_TYPE", payType);
			inBackpayMap.put("CONTRACT_NO", contractNo);
			baseDao.update("bal_payment_info.uStatus", inBackpayMap);

			Map<String, Object> paymentKey = null;
			paymentKey = new HashMap<String, Object>();
			paymentKey.put("YEAR_MONTH", payYearMonth);
			paymentKey.put("CONTRACT_NO", contractNo);
			paymentKey.put("PAY_SN", paySn);
			paymentKey.put("ID_NO", idNo);
			paymentKey.put("PAY_TYPE", payType);
			paymentKey.put("TABLE_NAME", "BAL_PAYMENT_INFO");
			paymentKey.put("UPDATE_TYPE", "U");
			keysList.add(paymentKey);

			// 交费记录表中插入负记录
			inBackpayMap.put("PAY_BACK_SN", backPaysn);
			inBackpayMap.put("OP_CODE", opCode);
			inBackpayMap.put("REMARK", opNotes);
			inBackpayMap.put("LOGIN_NO", loginNo);
			inBackpayMap.put("GROUP_ID", loginGroup);
			inBackpayMap.put("TOTAL_DATE", totalDate);
			inBackpayMap.put("ORIGINAL_SN", paySn);
			baseDao.insert("bal_payment_info.iForRoback", inBackpayMap);

			paymentKey = new HashMap<String, Object>();
			paymentKey.put("YEAR_MONTH", curYm);
			paymentKey.put("CONTRACT_NO", contractNo);
			paymentKey.put("PAY_SN", backPaysn);
			paymentKey.put("ID_NO", idNo);
			paymentKey.put("PAY_TYPE", payType);
			paymentKey.put("TABLE_NAME", "BAL_PAYMENT_INFO");
			paymentKey.put("UPDATE_TYPE", "I");
			keysList.add(paymentKey);

			// 回退支票
			if (PayBusiConst.PAY_TYPE_CHECK.equals(payType)) {
				
			}
		}
		
		//回退营业员操作日志
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("LOGIN_SN", paySn);
		inMapTmp.put("PAY_BACK_SN", backPaysn);
		inMapTmp.put("TOTAL_DATE", totalDate);
		inMapTmp.put("LOGIN_NO", loginNo);
		inMapTmp.put("GROUP_ID", loginGroup);
		inMapTmp.put("OP_CODE", opCode);
		inMapTmp.put("OP_NOTE", opNotes);
		inMapTmp.put("SUFFIX", String.valueOf(payYearMonth));
		baseDao.insert("bal_loginopr_info.iForRoback", inMapTmp);
		
		outParam.put("KEYS_LIST", keysList);
			
		return outParam;
	}
	
	/**
	 * 名称：回退来源表<br/>
	 * @param	YM				：缴费年月
	 * @param	PAY_SN			:回退缴费流水
	 * @param	BALANCE_ID
	 * @param	STATUS			:回退来源表状态
	 * @param	PAY_BACK_SN
	 * @param	LOGIN_NO
	 * @param	GROUP_ID
	 * @param   YEAR_MONTH
	 * 
	 * @author qiallin
	 */
	private void doRollbackBookSource(Map<String , Object> inParam){
		
		Map<String, Object> inMapTmp = null;
		
		String oldStatus = inParam.get("STATUS").toString();
		
		inMapTmp = new HashMap<String, Object>();
		if (oldStatus.equals("0")) {
			inMapTmp.put("STATUS", "1");
		} else if (oldStatus.equals("2")) {
			inMapTmp.put("STATUS", "3");
		} else if (oldStatus.equals("4")) {
			inMapTmp.put("STATUS", "6");
		} else if (oldStatus.equals("5")) {
			inMapTmp.put("STATUS", "7");
		}
		inMapTmp.put("PAY_SN", inParam.get("PAY_SN"));
		inMapTmp.put("BALANCE_ID", inParam.get("BALANCE_ID"));
		inMapTmp.put("SUFFIX", inParam.get("YM"));
		baseDao.update("bal_booksource_info.uStatus", inMapTmp);
		
		//inParam.put( "SUFFIX1" , sCurYm );
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_BACK_SN", inParam.get("PAY_BACK_SN"));
		if (oldStatus.equals("0")) {
			inMapTmp.put("STATUS", "1");
		} else if (oldStatus.equals("2")) {
			inMapTmp.put("STATUS", "3");
		} else if (oldStatus.equals("4")) {
			inMapTmp.put("STATUS", "6");
		} else if (oldStatus.equals("5")) {
			inMapTmp.put("STATUS", "7");
		}
		inMapTmp.put("GROUP_ID", inParam.get("GROUP_ID"));
		inMapTmp.put("LOGIN_NO", inParam.get("LOGIN_NO"));
		inMapTmp.put("YEAR_MONTH", inParam.get("YEAR_MONTH"));
		inMapTmp.put("PAY_SN", inParam.get("PAY_SN"));
		inMapTmp.put("BALANCE_ID", inParam.get("BALANCE_ID"));
		inMapTmp.put("SUFFIX", inParam.get("YM"));
		baseDao.insert("bal_booksource_info.iForRoback", inMapTmp);
		
	}


	/**
	 *功能：依据支出记录回退账单表、冲销表、支出表 
	 *@param	BACK_PAYSN		: 冲正流水
	 *@param	BALANCE_ID
	 *@param	YEAR_MONTH		: 支出年月
	 *@param	LOGIN_NO
	 *@param	GROUP_ID
	 *@return	这个balanceId的总支出(冲销欠费+滞纳金)
	 *@author guowy
	 */
	@SuppressWarnings("unchecked")
	private long doRobackDeadPayoutInfo(Map<String, Object> inParam){
		
		Map<String , Object> inMapTmp = null;
		Map<String , Object> outMapTmp = null;
		long lidNo = Long.parseLong(inParam.get("ID_NO").toString());
		long contractNo = Long.parseLong(inParam.get("CONTRACT_NO").toString());
		long balanceId = Long.parseLong(inParam.get("BALANCE_ID").toString());
		
		long sumPayowe = 0 ;           // 冲销总欠费
		long sumPayedDelay = 0;		 // 冲销总滞纳金
		long sumPayout = 0;			 // 总支出
		
		
		/*遍历支出，根据冲销流水回退费用*/
		inMapTmp = new HashMap<String , Object>();
		inMapTmp.put( "BALANCE_ID" , balanceId );
		inMapTmp.put( "SUFFIX" , inParam.get("YEAR_MONTH") );
		List<Map<String, Object>> bookoutList = (List<Map<String, Object>>)baseDao.queryForList( "bal_bookpayout_info.qWrtoffsn" , inMapTmp );
		String payoutFlag = "";
		if( bookoutList == null){
			payoutFlag = "1";
		}
		for( Map<String, Object> bookoutMapTmp : bookoutList ){
		
			
			long wrtoffSn = Long.valueOf( bookoutMapTmp.get("WRTOFF_SN").toString() );
			long payedOwe = Long.valueOf( bookoutMapTmp.get("PAYED_OWE").toString() );
			long payedDelay = Long.valueOf( bookoutMapTmp.get("PAYED_DELAY").toString() );
			
			log.debug("get qWrtoffsn from bal_bookpayout_info:  " + bookoutMapTmp);
			
			sumPayowe = sumPayowe + payedOwe;
			sumPayedDelay = sumPayedDelay + payedDelay;
			
		    /*获取冲正冲销流水*/
			long backWrtoffSn = control.getSequence("SEQ_WRTOFF_SN");
			
			/*
			 * 1.回退冲销账单记录
			 * */
			if ( payedOwe != 0 ){
				
				inMapTmp = new HashMap<String , Object>();
				inMapTmp.put( "WRTOFF_SN" , wrtoffSn );
				inMapTmp.put( "BALANCE_ID" , balanceId );
				inMapTmp.put( "SUFFIX" , inParam.get("YEAR_MONTH"));
				List<Map<String, Object>> writeoffList = baseDao.queryForList("bal_writeoff_yyyymm.qWrtoffByWrtoSn", inMapTmp);
				for( Map<String, Object> writeoffMapTmp : writeoffList ){
					log.debug("&&&&&&&&&&&&&      get qWrtoffsn from bal_writeoff_info:  " + writeoffMapTmp);
					inMapTmp = new HashMap<String , Object>();
					Map<String, Object> outMapTmpBill = new HashMap<String, Object>();
					inMapTmp.put( "BILL_ID" , writeoffMapTmp.get("BILL_ID") );
					inMapTmp.put( "SUFFIX" , lidNo%10);
					outMapTmpBill = (Map<String, Object>)baseDao.queryForObject( "act_deadowe_info.queryActDeadOwe" , inMapTmp );
					if( outMapTmpBill == null || outMapTmpBill.isEmpty()){
						
						/*
						*有冲销记录，未冲销账单没记录，需要将已冲销账单回退
						*/
						inMapTmp = new HashMap<String , Object>();
						inMapTmp.put( "YM" , inParam.get("YEAR_MONTH") );
						inMapTmp.put( "CONTRACT_NO" , contractNo );
						inMapTmp.put( "WRITEOFF" , writeoffMapTmp );
						inMapTmp.put( "ID_NO" , lidNo);
						doRollDeadbackBill(inMapTmp);
						log.debug("@@@@@@  insert into act_deadowe  @@@@@@@@");
					}else {
						
						inMapTmp = new HashMap<String , Object>();
						long payed_owe = Long.valueOf(writeoffMapTmp.get("PAYED_LATER").toString());
						long payed_prepay = Long.valueOf(writeoffMapTmp.get("PAYED_PREPAY").toString());
						long payed_tax = Long.valueOf( writeoffMapTmp.get("PAYED_TAX").toString());
						long payed_delay = Long.valueOf( writeoffMapTmp.get("PAYED_DELAY").toString());
						

						inMapTmp.put( "PAYED_OWE" , (-1) * (payed_owe) );
						inMapTmp.put( "PAYED_LATER" ,(-1) * (payed_owe));
						if(payed_prepay != 0){
							inMapTmp.put( "PAYED_PREPAY" , (-1) * payed_prepay );
						}
						if(payed_tax != 0){
							inMapTmp.put( "PAYED_TAX" , (-1) * payed_tax );
						}
						inMapTmp.put( "BILL_ID" , writeoffMapTmp.get("BILL_ID") );
						inMapTmp.put( "SUFFIX" , String.valueOf(contractNo).substring(String.valueOf(contractNo).length() - 2) );
						baseDao.update( "act_deadowe_info.uDeadpayowe", inMapTmp);
					}
					
					/*
					 * 回退冲销记录  : 更新冲销表、冲销表插入负记录
					 * */
					inMapTmp = new HashMap<String , Object>();
					inMapTmp.put( "YM" , inParam.get("YEAR_MONTH") );
					inMapTmp.put( "LOGIN_NO" , inParam.get("LOGIN_NO") );
					inMapTmp.put( "WRTOFF_SN" , wrtoffSn );
					inMapTmp.put( "CONTRACT_NO" , contractNo );
					inMapTmp.put( "BILL_ID" , writeoffMapTmp.get("BILL_ID") );
					inMapTmp.put( "BALANCE_ID" , balanceId);
					inMapTmp.put( "BACK_WRITEOFF_SN" , backWrtoffSn );
					log.debug("@@@@@@  更新冲销表、冲销表插入负记录  @@@@@@@@");
					doRollbackWriteoff(inMapTmp);
					
				}
			}
			
			/*
			 * 2.回退支出表	 : 更新支出表状态、支出表记录负记录
			 * */
			if( payoutFlag.equals("") ){
				
				inMapTmp = new HashMap<String , Object>();
				inMapTmp.put( "YM" , inParam.get("YEAR_MONTH") );
				inMapTmp.put( "BALANCE_ID" , balanceId );
				inMapTmp.put( "WRTOFF_SN" , wrtoffSn );
				inMapTmp.put( "PAY_BACK_SN" , inParam.get("BACK_PAYSN") );
				inMapTmp.put( "BACK_WRTOFF_SN" , backWrtoffSn );
				inMapTmp.put( "LOGIN_NO" , inParam.get("LOGIN_NO") );
				inMapTmp.put( "GROUP_ID" , inParam.get("GROUP_ID") );
				inMapTmp.put( "DEAD" , "DEAD" );
				log.debug("inparam of insert into bookpayout   @@@@@@   " + inParam);
				doRollbackBookPayout(inMapTmp);
			}
		}
		
		
		sumPayout = sumPayowe + sumPayedDelay;
		
		return sumPayout;
	}
	
	/**
	 * 名称：账单移入陈死账表、删除已冲销账单<br/>
	 * @param	YM				：冲销年月
	 * @param	CONTRACT_NO
	 * @param	WRITEOFF.BILL_ID
	 * @param	WRITEOFF.NATURAL_MONTH
	 * @param	WRITEOFF.PAYED_LATER
	 * @param	WRITEOFF.PAYED_PREPAY
	 * @param	WRITEOFF.PRINT_FLAG
	 * @param	WRITEOFF.ID_NO
	 * @param	WRITEOFF.TAX_RATE
	 * @param	WRITEOFF.TAX_FEE
	 * @param	WRITEOFF.NATURAL_MONTH
	 * 
	 * 
	 * @author guowy
	 */
	@SuppressWarnings("unchecked")
	private void doRollDeadbackBill(Map<String , Object> inParam) {
		log.info("@@@@@@@  doRollDeadbackBill  @@@@@@@"+inParam);
		Map<String , Object> inMapTmp = null;
		Map<String , Object> outMapTmp = null;
		long lIdNo = (Long)inParam.get("ID_NO");
		int	iym = (Integer)inParam.get("YM");
		long contractNo = (Long)inParam.get("CONTRACT_NO");
		Map<String , Object> writeoffMap = (Map<String , Object>)inParam.get("WRITEOFF");
		long lBillId = Long.parseLong(String.valueOf(writeoffMap.get("BILL_ID")));
		int  billCycle = Integer.parseInt(writeoffMap.get("BILL_CYCLE").toString());
	
		/* 查询配置最小账单表年月 */
		String selDate = control.getPubCodeValue(108, "HISBILLYM", null);

		/* 查询当前使用的是动态月还是自然月 */
		int billRules = Integer.parseInt(control.getPubCodeValue(101, "PAYEDOWE", null));
		
		String tablePayedowe = "ACT_PAYEDOWE_INFO";
		
		if( 0 == billRules ){		//0: 按动态月账期存放
			
			if( billCycle >= Integer.valueOf(selDate) ){
				tablePayedowe = "ACT_PAYEDOWE_" + writeoffMap.get("BILL_CYCLE").toString();
			}else{
				tablePayedowe = "ACT_PAYEDOWE_HIS";
			}
			
		}else{
			if( billCycle >= Integer.valueOf(selDate) ){
				tablePayedowe = "ACT_PAYEDOWE_" + writeoffMap.get("NATURAL_MONTH").toString();
			}else{
				tablePayedowe = "ACT_PAYEDOWE_HIS";
			}
		}
		
		inMapTmp = new HashMap<String , Object>();
		inMapTmp.put("TABLE_PAYEDOWE" , tablePayedowe );
		inMapTmp.put("BILL_ID" , writeoffMap.get("BILL_ID") );
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("BILL_CYCLE", billCycle);
		outMapTmp = (Map<String ,Object>)baseDao.queryForObject( "act_payedowe_info.qPayedFeeByBillId" , inMapTmp);
		log.debug("get payedowe_info:" +outMapTmp);
		if( outMapTmp == null ){
			log.info("已冲销账单不存在bill_id : " + writeoffMap.get("BILL_ID") );
			throw new BusiException(AcctMgrError.getErrorCode("8003","00001"), "已冲销账单不存在bill_id :  " + writeoffMap.get("BILL_ID") );
		}
		
		String statusTmp = outMapTmp.get("STATUS").toString();	
		String status = "";
		if(statusTmp.equals("3")){
			status = "1";
		}else if(statusTmp.equals("6")){
			status = "4";
		}else{
			status = "0";
		}
		
		/*账单移入未冲销账单、删除已冲销账单*/
		Map<String, Object> inparaMap = new HashMap<String , Object>();
		inparaMap.put( "TABLE_PAYEDOWE" , tablePayedowe );
		inparaMap.put( "PAYED_LATER" , writeoffMap.get("PAYED_LATER") );
		inparaMap.put( "PAYED_PREPAY" , writeoffMap.get("PAYED_PREPAY") );
		inparaMap.put( "PAYED_TAX" , writeoffMap.get("PAYED_TAX")==null?0:writeoffMap.get("PAYED_TAX") );
		inparaMap.put( "BILL_ID" , lBillId );
		inparaMap.put( "STATUS" , status);
		inparaMap.put("CONTRACT_NO", contractNo);
		inparaMap.put("BILL_CYCLE", billCycle);
		baseDao.insert( "act_deadowe_info.iByPayedoweDead", inparaMap );
		
		/*删除已冲销账单记录*/
		baseDao.delete( "act_payedowe_info.delByBillid" , inparaMap );
		
	}
	
	/**
	 * 名称：回退冲销表<br/>
	 * @param	YM				：冲销年月
	 * @param	LOGIN_NO
	 * @param	WRTOFF_SN
	 * @param	CONTRACT_NO
	 * @param	BILL_ID
	 * @param	BALANCE_ID
	 * @param	BACK_WRITEOFF_SN
	 * @param   YEAR_MONTH    : 当前年月
	 * 
	 * @author qiallin
	 */
	private void doRollbackWriteoff(Map<String , Object> inParam){
		
		String sCurYm = DateUtil.format(new Date(), "yyyyMM");
		long contractNo = Long.valueOf( inParam.get("CONTRACT_NO").toString() );
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		
		/*更新冲销表*/
		inMap.put( "STATUS" , "1");
		inMap.put( "PRINT_FLAG" , "0" );
		inMap.put( "SUFFIX" , inParam.get("YM") );
		inMap.put("WRTOFF_SN", inParam.get("WRTOFF_SN"));
		inMap.put("BILL_ID", inParam.get("BILL_ID"));
		inMap.put("BALANCE_ID", inParam.get("BALANCE_ID"));
		inMap.put("CONTRACT_NO", contractNo);
		baseDao.update( "bal_writeoff_yyyymm.uWrtoffByWrSnBalId" , inMap );
		
		/*冲销表记录负记录*/	
		inMap.put("BACK_WRTOFF_SN", inParam.get("BACK_WRITEOFF_SN"));
		inMap.put("LOGIN_NO", inParam.get("LOGIN_NO"));
		inMap.put("WRTOFF_SN", inParam.get("WRTOFF_SN"));
		inMap.put("PRINT_FLAG", "0");
		inMap.put("YEAR_MONTH", sCurYm);
		inMap.put("BILL_ID", inParam.get("BILL_ID"));
		inMap.put("BALANCE_ID", inParam.get("BALANCE_ID"));
		baseDao.insert("bal_writeoff_yyyymm.iForRoback", inMap);
		
	}
	
	
	/**
	 * 名称：回退支出表<br/>
	 * @param	YM				：冲销年月
	 * @param	BALANCE_ID
	 * @param	WRTOFF_SN
	 * @param	PAY_BACK_SN
	 * @param	BACK_WRTOFF_SN
	 * @param	LOGIN_NO
	 * @param	GROUP_ID
	 * @param   YEAR_MONTH		: 当前年月
	 * @author qiallin
	 */
	private void doRollbackBookPayout(Map<String , Object> inParam){
		String sCurYm = DateUtil.format(new Date(), "yyyyMM");

		inParam.put( "STATUS" , "1" );
		inParam.put( "SUFFIX" , inParam.get("YM") );
		baseDao.update( "bal_bookpayout_info.uByBalIdPaySn" , inParam );
		
		if (StringUtils.isNotEmptyOrNull(inParam.get("ONEBACK"))  && (inParam.get("ONEBACK").toString()).equals("ONEBACK")) {
			inParam.put("OPER_TYPE", "9");
		} else if (StringUtils.isEmptyOrNull(inParam.get("DEAD"))) {
			inParam.put("OPER_TYPE", "5");
		} else {
			inParam.put("OPER_TYPE", "a");
		}
		inParam.put( "NOT_OP_TYPE" , "5" );
		inParam.put("YEAR_MONTH", sCurYm); 
		//inParam.put( "SUFFIX1" , sCurYm );
		baseDao.insert( "bal_bookpayout_info.iForRoback", inParam );
		
	}
	
	
	
	public Map<String , Object> getPayOutMsg(long paySn, int yearMonth) {
		
		Map<String , Object> outParam = new HashMap<String , Object>();
		Map<String , Object> inMapTmp = null;
		Map<String , Object> outMapTmp = null;
		
		long allPay = 0;
		long idNumber = 0;    //本次缴费到账或者发生支出的用户总数
		List<Map<String, Object>> idFeeList = new ArrayList<Map<String,Object>>();  //该笔缴费到账用户费用情况
		
		/*循环取缴费账户*/
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("SUFFIX", yearMonth);
		List<Map<String, Object>> resultList = (List<Map<String, Object>>) baseDao
				.queryForList("bal_payment_info.qBalConByPaysn", inMapTmp);
		for( Map<String, Object> resultMap : resultList ){
			
			long contractNo = Long.valueOf( resultMap.get("CONTRACT_NO").toString() );
			String payType = MapUtils.getString(resultMap, "PAY_TYPE");
			String payNote = MapUtils.getString(resultMap, "REMARK");
			
			if(account.isGrpCon(contractNo)){
				
				inMapTmp = new HashMap<String, Object>();
				inMapTmp.put("PAY_SN", paySn);
				inMapTmp.put("CONTRACT_NO", contractNo);
				inMapTmp.put("SUFFIX", yearMonth);
				Long payMoneyTmp = (Long) baseDao.queryForObject("bal_booksource_info.qSumPayfee", inMapTmp);
				long payMoney = 0;
				if (payMoneyTmp == null) {
					log.info("账户户无来源费用  pay_sn : " + paySn + "contract_no : " + contractNo);
				} else {
					payMoney = payMoneyTmp;
				}

				/* 取缴费时账户支出总费用 */
				inMapTmp = new HashMap<String, Object>();
				inMapTmp.put("PAY_SN", paySn);
				inMapTmp.put("CONTRACT_NO", contractNo);
				inMapTmp.put("SUFFIX", yearMonth);
				outMapTmp = (Map<String, Object>) baseDao.queryForObject(
						"bal_bookpayout_info.qPayoutByThisPay", inMapTmp);
				long totalOwe = 0;
				long totalDelay = 0;
				if (outMapTmp == null) {
					log.info("账户户无支出费用  pay_sn : " + paySn + "contract_no : " + contractNo);
				} else {
					totalOwe = Long.valueOf(outMapTmp.get("PAY_OWE").toString());
					totalDelay = Long.valueOf(outMapTmp.get("DELAY_FEE").toString());
				}

				long prepayFee = 0;

				if (payMoney <= 0) {
					prepayFee = 0;
				} else
					prepayFee = payMoney - totalOwe - totalDelay;

				allPay = allPay + payMoney;

				Map<String, Object> idFeeMap = new HashMap<String, Object>();
				idFeeMap.put("PHONE_NO", contractNo);
				idFeeMap.put("PAY_MONEY", payMoney);
				idFeeMap.put("PREPAY_FEE", prepayFee);
				idFeeMap.put("PAYED_OWE", totalOwe);
				idFeeMap.put("DELAY_FEE", totalDelay);
				idFeeMap.put("PAY_NOTE", payNote);

				idFeeList.add(idFeeMap);

				idNumber++;
				
			} else {

				/* 遍历账户下付费用户，按条获取缴费支出 */
				inMapTmp = new HashMap<String, Object>();
				inMapTmp.put("CONTRACT_NO", contractNo);
				List<Map<String, Object>> resultList2 = new ArrayList<Map<String, Object>>();
				resultList2 = baseDao.queryForList(
						"cs_conuserrel_info.qConUserRelByConNo", inMapTmp);
				if (resultList2 == null || resultList2.size() == 0){
					inMapTmp = new HashMap<String, Object>();
					inMapTmp.put("PAY_SN", paySn);
					inMapTmp.put("SUFFIX", yearMonth);
					//resultList2 = baseDao.queryForList("bal_payment_info.qBalPayMent", inMapTmp);
					List<PayMentEntity> listtmp = record.getPayMentList(inMapTmp);
					for(PayMentEntity tmp: listtmp){
						
						Map<String, Object> tmpMap = new HashMap<String, Object>();
						tmpMap.put("ID_NO", tmp.getIdNo());
						resultList2.add(tmpMap);
					}
					
				}
				for (Map<String, Object> idMap : resultList2) {

					long idNo = Long.valueOf(idMap.get("ID_NO").toString());

					/*
					 * 判断该用户在这笔缴费流水下有无来源支出信息，如无则进行下条id判断
					 */
					inMapTmp = new HashMap<String, Object>();
					inMapTmp.put("PAY_SN", paySn);
					inMapTmp.put("ID_NO", idNo);
					inMapTmp.put("SUFFIX", yearMonth);
					inMapTmp.put("PAY_TYPE", payType);
					Long payMoneyTmp = (Long) baseDao.queryForObject(
							"bal_booksource_info.qSumPayfee", inMapTmp);
					long payMoney = 0;
					if (payMoneyTmp == null) {
						log.info("用户无来源费用  pay_sn : " + paySn + "id_no : " + idNo);
					} else {
						payMoney = payMoneyTmp;
					}

					inMapTmp = new HashMap<String, Object>();
					inMapTmp.put("PAY_SN", paySn);
					inMapTmp.put("ID_NO", idNo);
					inMapTmp.put("SUFFIX", yearMonth);
					inMapTmp.put("PAY_TYPE", payType);
					outMapTmp = (Map<String, Object>) baseDao.queryForObject(
							"bal_bookpayout_info.qPayoutByThisPay", inMapTmp);
					long payedOwe = 0;
					long delayFee = 0;
					if (outMapTmp == null) {
						log.info("用户无支出费用  pay_sn : " + paySn + "id_no : " + idNo);
					} else {
						payedOwe = Long.valueOf(outMapTmp.get("PAY_OWE").toString());
						delayFee = Long.valueOf(outMapTmp.get("DELAY_FEE").toString());
					}

					if (payMoney == 0 && payedOwe == 0) {
						log.info("用户既无来源也无支出信息  pay_sn : " + paySn + "id_no : " + idNo);
						continue;
					}

					String phoneNo = "";
					if(idNo == 0 ){
						 phoneNo = "99999999999";
					}else {
						UserInfoEntity userEntity = user.getUserEntity(idNo, null, null, true);
						phoneNo = userEntity.getPhoneNo();
					}
					
					/* 取缴费时账户支出总费用 */
					inMapTmp = new HashMap<String, Object>();
					inMapTmp.put("PAY_SN", paySn);
					inMapTmp.put("CONTRACT_NO", contractNo);
					inMapTmp.put("SUFFIX", yearMonth);
					outMapTmp = (Map<String, Object>) baseDao.queryForObject(
							"bal_bookpayout_info.qPayoutByThisPay", inMapTmp);
					long totalOwe = 0;
					long totalDelay = 0;
					if (outMapTmp == null) {
						log.info("账户户无支出费用  pay_sn : " + paySn + "contract_no : " + contractNo);
					} else {
						totalOwe = Long.valueOf(outMapTmp.get("PAY_OWE").toString());
						totalDelay = Long.valueOf(outMapTmp.get("DELAY_FEE").toString());
					}

					long prepayFee = 0;

					if (payMoney <= 0) {
						prepayFee = 0;
					} else{
						prepayFee = payMoney - payedOwe - delayFee;
					}

					allPay = allPay + payMoney;

					Map<String, Object> idFeeMap = new HashMap<String, Object>();
					idFeeMap.put("PHONE_NO", phoneNo);
					idFeeMap.put("PAY_MONEY", payMoney);
					idFeeMap.put("PREPAY_FEE", prepayFee);
					idFeeMap.put("PAYED_OWE", payedOwe);
					idFeeMap.put("DELAY_FEE", delayFee);
					idFeeMap.put("PAY_NOTE", payNote);

					idFeeList.add(idFeeMap);

					idNumber++;
				}
			}
		}
		
		//如果有酬金，需要退款金额中需要减去酬金 （酬金 减去 税金）
/*		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("YEAR_MONTH", yearMonth);
		outMapTmp = (Map<String, Object>)baseDao.queryForObject("bal_transnetamout_info.qByPaySn", inMapTmp);
		if(outMapTmp != null){
			
			long rwdFee = Long.parseLong(outMapTmp.get("RWD_FEE").toString());
			long taxFee = Long.parseLong(outMapTmp.get("TAX_FEE").toString());
			
			allPay = allPay - (rwdFee - taxFee);
		}*/
		
		outParam.put( "OUT_FEEMSG" , idFeeList );
		outParam.put( "ALL_PAY" , allPay );
		outParam.put( "ID_NUMBER" , idNumber );
		
		return outParam;
	}
	
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getDeadPayOutMsg(long paySn, int yearMonth, long inIdNo) {

		Map<String, Object> outParam = new HashMap<String, Object>();
		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;

		long allPay = 0;
		long idNo = inIdNo;
		/*
		 * 判断该用户在这笔缴费流水下有无来源支出信息，如无则进行下条id判断
		 */
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("ID_NO", idNo);
		inMapTmp.put("SUFFIX", yearMonth);
		Long payMoneyTmp = (Long) baseDao.queryForObject("bal_booksource_info.qSumPayfee", inMapTmp);
		long payMoney = 0;
		if (payMoneyTmp == null) {
			log.info("用户无来源费用  pay_sn : " + paySn + "id_no : " + idNo);
		} else {
			payMoney = payMoneyTmp;
		}

		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("ID_NO", idNo);
		inMapTmp.put("SUFFIX", yearMonth);
		outMapTmp = (Map<String, Object>) baseDao.queryForObject("bal_bookpayout_info.qPayoutByThisPay", inMapTmp);
		long payedOwe = 0;
		long delayFee = 0;
		if (outMapTmp == null) {
			log.info("用户无支出费用  pay_sn : " + paySn + "id_no : " + idNo);
		} else {
			payedOwe = Long.valueOf(outMapTmp.get("PAY_OWE").toString());
			delayFee = Long.valueOf(outMapTmp.get("DELAY_FEE").toString());
		}

		if (payMoney == 0 && payedOwe == 0) {
			log.info("用户既无来源也无支出信息  pay_sn : " + paySn + "id_no : " + idNo);
			throw new BusiException(AcctMgrError.getErrorCode("8007","10003"), "用户既无来源也无支出信息  pay_sn : " + paySn + " id_no : " + idNo );
		}

		List<UserDeadEntity> userEntity = user.getUserdeadEntity(null, idNo, null);
		String phoneNo = userEntity.get(0).getPhoneNo();

		long prepayFee = 0;

		if (payMoney <= 0) {
			prepayFee = 0;
		} else {
			prepayFee = payMoney - payedOwe - delayFee;
		}

		allPay = allPay + payMoney;

		outParam.put("PHONE_NO", phoneNo);
		outParam.put("PAY_MONEY", payMoney);
		outParam.put("PREPAY_FEE", prepayFee);
		outParam.put("PAYED_OWE", payedOwe);
		outParam.put("DELAY_FEE", delayFee);
		outParam.put("ALL_PAY", allPay);
		
		return outParam;
	}	
	
	public long doRollbackCashFee(long paySn, Long backPaySn, String payDate, LoginBaseEntity loginEntity) {
		
		Map<String , Object> inMapTmp = null;
		Map<String , Object> outMapTmp = null;
		
		/*取当前年月和当前时间*/
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String sCurYm = sCurTime.substring(0, 6);
		String	sTotalDate = sCurTime.substring(0, 8);
		
	    /*获取冲正支出流水*/
		long backPaysn = 0;
		if(backPaySn!=null ){
			backPaysn = backPaySn;
		}else{
			backPaysn = control.getSequence("SEQ_PAY_SN");
		}
		
		/*循环取缴费账户*/
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("SUFFIX", Long.parseLong(payDate.substring(0, 6)));
		List<Map<String, Object>> resultList = (List<Map<String, Object>>)baseDao.queryForList( "bal_payment_info.qBalConByPaysn" , inMapTmp);
		for( Map<String, Object> resultMap : resultList ){
			
			long contractNo = Long.valueOf( resultMap.get("CONTRACT_NO").toString() );
			String payOpCode = resultMap.get("OP_CODE").toString();
			
			/*取交费信息*/
			inMapTmp = new HashMap<String , Object>();
			inMapTmp.put("PAY_SN", paySn);
			inMapTmp.put("CONTRACT_NO", contractNo);
			inMapTmp.put("SUFFIX", Long.parseLong(payDate.substring(0, 6)));
			List<PayMentEntity> outPayList = record.getPayMentList(inMapTmp);
			if ( 0 == outPayList.size() ){
				log.info("交费记录不存在pay_sn : " + paySn);
				throw new BusiException(AcctMgrError.getErrorCode("8056","00001"), "交费记录不存在pay_sn: " + paySn);
			}
			PayMentEntity payEntity = outPayList.get(0);
			long idNo = payEntity.getIdNo();
			String payPhone = payEntity.getPhoneNo();
			if( payEntity.getStatus().equals("1") || payEntity.getStatus().equals("3") ){
				log.info("该条缴费记录已经冲正 pay_sn : " + paySn + "contract_no:"+ contractNo );
				throw new BusiException(AcctMgrError.getErrorCode("0000","10008"), "该条缴费记录已经冲正 " );
			}
		
			/*遍历来源表*/
			inMapTmp = new HashMap<String , Object>();
			inMapTmp.put("PAY_SN", paySn);
			inMapTmp.put("CONTRACT_NO", contractNo);
			inMapTmp.put("CUR_STATUS", "'0','2', '4','5'");
			inMapTmp.put("SUFFIX", Long.parseLong(payDate.substring(0, 6)));
			List<Map<String, Object>> resultList2 = (List<Map<String, Object>>)baseDao.queryForList( "bal_booksource_info.qBookSourceByPaySn" , inMapTmp);
			for( Map<String, Object> balanceidMapTmp : resultList2 ){
				
				long sumPayoutfee = 0;
				long prepayFee=0;			//该账本实际入账金额
				 
				long balanceId = Long.valueOf( balanceidMapTmp.get("BALANCE_ID").toString() );
				long payFee = Long.parseLong(balanceidMapTmp.get("PAY_FEE").toString());
				String sourceStatus = balanceidMapTmp.get("STATUS").toString();
				
				/*
				 * 根据支出表，依次回退 冲销账单、冲销记录、支出记录
				 * */
				for( int iym = Integer.valueOf(payDate.substring(0, 6)); iym <= Integer.valueOf(sCurYm);
						iym = Integer.valueOf(DateUtil.toStringPlusMonths( String.valueOf(iym) , 1, "yyyyMM") ) ){
					
					inMapTmp = new HashMap<String, Object>();
					inMapTmp.put("BACK_PAYSN", backPaysn);
					inMapTmp.put("BALANCE_ID", balanceId);
					inMapTmp.put("OUT_MONTH", iym);
					inMapTmp.put("LOGIN_NO", loginEntity.getLoginNo());
					inMapTmp.put("GROUP_ID", loginEntity.getGroupId());
					inMapTmp.put("YEAR_MONTH", sCurYm);
					inMapTmp.put("PAY_OPCODE", payOpCode);
					long payoutFee = doRobackPayoutInfo(inMapTmp);
					sumPayoutfee = sumPayoutfee + payoutFee;
				}
				prepayFee = payFee - sumPayoutfee;
				log.debug("---> payFee : "+payFee +", sumPayoutfee:"+sumPayoutfee);
				
				/*3.回退来源表  : 更新表状态、表记录负记录*/
				Map<String, Object> inRobackMap = new HashMap<String, Object>();
				inRobackMap.put("PAY_SN", paySn);
				inRobackMap.put("BALANCE_ID", balanceId);
				inRobackMap.put("STATUS", sourceStatus);
				inRobackMap.put("PAY_BACK_SN", backPaysn);
				inRobackMap.put("TOTAL_DATE", sTotalDate);
				inRobackMap.put("LOGIN_NO", loginEntity.getLoginNo());
				inRobackMap.put("GROUP_ID", loginEntity.getGroupId());
				inRobackMap.put("YM", payDate.substring(0, 6));
				inRobackMap.put("YEAR_MONTH", sCurYm);
				doRollbackBookSource(inRobackMap);
				
				/*5.回退账本余额*/
				inMapTmp = new HashMap<String , Object>();
				inMapTmp.put( "BALANCE_ID" , balanceId );
				outMapTmp = (Map<String , Object>)baseDao.queryForObject( "bal_acctbook_info.qByBalanceId" , inMapTmp );
				long curBalance = 0;
				if( outMapTmp == null ){
					
					//账本历史表移到正式表
					inMapTmp = new HashMap<String, Object>();
					inMapTmp.put("CONTRACT_NO", contractNo);
					inMapTmp.put("BALANCE_ID", balanceId);
					baseDao.insert("bal_acctbook_info.iAcctbookByHis", inMapTmp);
					//删除历史表记录
					baseDao.delete("bal_acctbook_his.delAcctbookHis", inMapTmp);
					
					curBalance = 0;
				}else {
					curBalance = Long.valueOf(outMapTmp.get("CUR_BALANCE").toString());
				}
				log.info("------>  curBalance_b="+curBalance+","+payFee+","+sumPayoutfee);

				//if( curBalance == prepayFee ){		//当前账本预存款等于实际该账本入账金额，则回退账本
				if( curBalance >= prepayFee || loginEntity.getLoginNo().equals("system")){		//当前账本预存款等于实际该账本入账金额，则回退账本
					
					inMapTmp.put("PAYED_OWE", prepayFee );
					int num = balance.updateAcctBook(inMapTmp);
					if(num <= 0){
						
						log.info("更新账本出错 balance_id : " + balanceId );
						throw new BusiException(AcctMgrError.getErrorCode("0000","10044"), "更新账本出错 balance_id : " + balanceId);
						
					}
					
				}else{
					log.info("账本余额不足，不够回退 balance_id : " + balanceId + "cur_balance :"
							+ curBalance + "应该入账金额: " + prepayFee );
					throw new BusiException(AcctMgrError.getErrorCode("0000","10009"), "账本余额不足，不够回退 balance_id : " + balanceId + "，cur_balance :"
							+ ValueUtils.transFenToYuan(curBalance) + " 元，应该入账金额: " + ValueUtils.transFenToYuan(prepayFee) + " 元");
				}
			}
			
			/*6. 给实时销账同步账本余额*/
			/*同步实时销账*/
			Map<String, Object> rtWrtoffMap = new HashMap<String, Object>();
			rtWrtoffMap.put("PAY_SN", backPaysn);
			rtWrtoffMap.put("CONTRACT_NO", contractNo);
			rtWrtoffMap.put("WRTOFF_FLAG", "2");
			rtWrtoffMap.put("REMARK", "冲正同步");
			balance.saveRtwroffChg(rtWrtoffMap);
			
			/*9.回退开关机状态*/
			if (!loginEntity.getOpCode().equals("B001") && 
				!loginEntity.getOpCode().equals("B002") && 
				!loginEntity.getOpCode().equals("B003")) {
				
				doRollbackRunCode(contractNo, paySn, payDate.substring(0, 6), backPaysn,loginEntity);
			}
		}
		
		
		return backPaysn;
	}
	
	public long dRollbackForMr(long paySn, Long backPaysn, String foreignSn, String payDate, LoginBaseEntity loginEntity){
		
		Map<String , Object> inMapTmp = null;
		Map<String , Object> outMapTmp = null;
		
		/*取当前年月和当前时间*/
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String sCurYm = sCurTime.substring(0, 6);
		String	sTotalDate = sCurTime.substring(0, 8);
		
	    /*获取冲正支出流水*/
		long backsn = 0;
		if(backPaysn != null && backPaysn !=0 ){
			backsn = backPaysn;
		}else{
			backsn = control.getSequence("SEQ_PAY_SN");
		}
		
		/*循环取缴费账户*/
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_SN", paySn);
		inMapTmp.put("SUFFIX", Long.parseLong(payDate.substring(0, 6)));
		List<Map<String, Object>> resultList = (List<Map<String, Object>>)baseDao.queryForList( "bal_payment_info.qBalConByPaysn" , inMapTmp);
		for( Map<String, Object> resultMap : resultList ){
			
			long contractNo = Long.valueOf( resultMap.get("CONTRACT_NO").toString() );
			String payType = resultMap.get("PAY_TYPE").toString();
			//String payOpCode = resultMap.get("OP_CODE").toString();
			
			/*取交费信息*/
			inMapTmp = new HashMap<String , Object>();
			inMapTmp.put("PAY_SN", paySn);
			inMapTmp.put("CONTRACT_NO", contractNo);
			inMapTmp.put("SUFFIX", Long.parseLong(payDate.substring(0, 6)));
			List<PayMentEntity> outPayList = record.getPayMentList(inMapTmp);
			if ( 0 == outPayList.size() ){
				log.info("交费记录不存在pay_sn : " + paySn);
				throw new BusiException(AcctMgrError.getErrorCode("8056","00001"), "交费记录不存在pay_sn: " + paySn);
			}
			PayMentEntity payEntity = outPayList.get(0);
			long idNo = payEntity.getIdNo();
			String payPhone = payEntity.getPhoneNo();
/*			if( payEntity.getStatus().equals("1") || payEntity.getStatus().equals("3") ){
				log.info("该条缴费记录已经冲正 pay_sn : " + paySn + "contract_no:"+ contractNo );
				throw new BusiException(AcctMgrError.getErrorCode("0000","10008"), "该条缴费记录已经冲正 " );
			}*/
		
			/*遍历来源表*/
			inMapTmp = new HashMap<String , Object>();
			inMapTmp.put("PAY_SN", paySn);
			inMapTmp.put("CONTRACT_NO", contractNo);
			inMapTmp.put("CUR_STATUS", "'0','2', '4','5'");
			inMapTmp.put("SUFFIX", Long.parseLong(payDate.substring(0, 6)));
			List<Map<String, Object>> resultList2 = (List<Map<String, Object>>)baseDao.queryForList( "bal_booksource_info.qBookSourceByPaySn" , inMapTmp);
			for( Map<String, Object> balanceidMapTmp : resultList2 ){
				
				int findFlag=0;
				
				long balanceId = Long.valueOf( balanceidMapTmp.get("BALANCE_ID").toString() );
				long payFee = Long.parseLong(balanceidMapTmp.get("PAY_FEE").toString());
				String sourceStatus = balanceidMapTmp.get("STATUS").toString();

				log.debug("---> payFee : "+payFee );
				
				/*3.回退来源表  : 更新表状态、表记录负记录*/
				Map<String, Object> inRobackMap = new HashMap<String, Object>();
				inRobackMap.put("PAY_SN", paySn);
				inRobackMap.put("BALANCE_ID", balanceId);
				inRobackMap.put("STATUS", sourceStatus);
				inRobackMap.put("PAY_BACK_SN", backsn);
				inRobackMap.put("TOTAL_DATE", sTotalDate);
				inRobackMap.put("LOGIN_NO", loginEntity.getLoginNo());
				inRobackMap.put("GROUP_ID", loginEntity.getGroupId());
				inRobackMap.put("YM", payDate.substring(0, 6));
				inRobackMap.put("YEAR_MONTH", sCurYm);
				doRollbackBookSource(inRobackMap);
				
				//回退账本预存
				inMapTmp = new HashMap<String , Object>();
				inMapTmp.put( "BALANCE_ID" , balanceId );
				outMapTmp = (Map<String , Object>)baseDao.queryForObject( "bal_acctbook_info.qByBalanceId" , inMapTmp );
				if(outMapTmp != null){		//当前账本预存款等于实际该账本入账金额，则回退账本
					
					findFlag = 1;
					
					inMapTmp.put("PAYED_OWE", payFee );
					int num = balance.updateAcctBook(inMapTmp);
					if(num <= 0){
						
						log.info("更新账本出错 balance_id : " + balanceId );
						throw new BusiException(AcctMgrError.getErrorCode("0000","10044"), "更新账本出错 balance_id : " + balanceId);
					}
				}
				
				//回退分月返还数据
				inMapTmp = new HashMap<String , Object>();
				inMapTmp.put( "BALANCE_ID" , balanceId );
				outMapTmp = (Map<String , Object>)baseDao.queryForObject( "bal_returnacctbook_info.qByBalanceId" , inMapTmp );
				if(outMapTmp != null){
					
					findFlag = 1;
					
					inMapTmp.put("CONTRACT_NO" , contractNo);
					inMapTmp.put("STATUS", "3");
					int num = balance.updateAcctBook(inMapTmp);
					if(num <= 0){
						
						log.info("更新账本出错 balance_id : " + balanceId );
						throw new BusiException(AcctMgrError.getErrorCode("0000","10044"), "更新账本出错 balance_id : " + balanceId);
					}
				}
				
				if(findFlag == 0 &&  payFee != 0){
					
					throw new BusiException(AcctMgrError.getErrorCode("0000","10044"), "冲正分月返还失败!");
				}
			}
			
			//1.更新payment表
			Map<String, Object> inBackpayMap = new HashMap<String, Object>();
			inBackpayMap.put("PAY_SN", paySn);
			inBackpayMap.put("SUFFIX",  Long.parseLong(payDate.substring(0, 6)));
			inBackpayMap.put("PAY_TYPE", payType);
			baseDao.update("bal_payment_info.uStatus", inBackpayMap);
			
			//2.payment表记录负记录
			inBackpayMap.put("PAY_BACK_SN", backsn);
			inBackpayMap.put("CONTRACT_NO", contractNo);
			inBackpayMap.put("OP_CODE", loginEntity.getOpCode());
			inBackpayMap.put("REMARK", loginEntity.getOpNote());
			inBackpayMap.put("LOGIN_NO", loginEntity.getLoginNo());
			inBackpayMap.put("GROUP_ID", loginEntity.getGroupId());
			inBackpayMap.put("TOTAL_DATE", sTotalDate);
/*			inBackpayMap.put("PAY_PATH", inParam.get("PAY_PATH"));
			inBackpayMap.put("PAY_METHOD", inParam.get("PAY_METHOD"));*/
			inBackpayMap.put("ORIGINAL_SN", paySn);
			inBackpayMap.put("SUFFIX1", sCurYm);
			inBackpayMap.put("PAY_TYPE", payType);
			inBackpayMap.put("FOREIGN_SN", foreignSn);
			baseDao.insert("bal_payment_info.iForRoback", inBackpayMap);
			
			/*6. 给实时销账同步账本余额*/
			/*同步实时销账*/
			Map<String, Object> rtWrtoffMap = new HashMap<String, Object>();
			rtWrtoffMap.put("PAY_SN", backsn);
			rtWrtoffMap.put("CONTRACT_NO", contractNo);
			rtWrtoffMap.put("WRTOFF_FLAG", "2");
			rtWrtoffMap.put("REMARK", "冲正同步");
			balance.saveRtwroffChg(rtWrtoffMap);
			
		}
		
		return backsn;
	}
	
	/**
	 *名称：根据balance_id回退用户支出记录
	 *功能：回退冲销账单、冲销表、支出表 
	 *@param	BACK_PAYSN		: 冲正流水
	 *@param	BALANCE_ID
	 *@param	OUT_MONTH		: 支出年月
	 *@param	LOGIN_NO
	 *@param	GROUP_ID
	 *@param    YEAR_MONTH      : 当前年月
	 *@param	PAY_OPCODE
	 *@return	这个balance的总支出(冲销欠费+滞纳金)
	 *@author qiaolin
	 */
	private long doRobackPayoutInfo(Map<String, Object> inParam){
		
		Map<String , Object> inMapTmp = null;
		Map<String , Object> outMapTmp = null;
		
		long sumPayowe = 0 ;           // 冲销总欠费
		long sumPayedDelay = 0;		 // 冲销总滞纳金
		long sumPayout = 0;			 // 总支出
		
		long balanceId = Long.parseLong(inParam.get("BALANCE_ID").toString());
		
		/*遍历支出，根据冲销流水回退费用*/
		inMapTmp = new HashMap<String , Object>();
		inMapTmp.put( "BALANCE_ID" , balanceId );
		inMapTmp.put( "SUFFIX" , inParam.get("OUT_MONTH") );
		List<Map<String, Object>> bookoutList = (List<Map<String, Object>>)baseDao.queryForList( "bal_bookpayout_info.qWrtoffsn" , inMapTmp );
		String payoutFlag = "";
		if(0 == bookoutList.size()){
			payoutFlag = "1";
		}
		for( Map<String, Object> bookoutMapTmp : bookoutList ){
		
			long outCon = Long.parseLong(bookoutMapTmp.get("CONTRACT_NO").toString());
			long wrtoffSn = Long.valueOf( bookoutMapTmp.get("WRTOFF_SN").toString() );
			long payedOwe = Long.valueOf( bookoutMapTmp.get("PAYED_OWE").toString() );
			long payedDelay = Long.valueOf( bookoutMapTmp.get("PAYED_DELAY").toString() );
			
			sumPayowe = sumPayowe + payedOwe;
			sumPayedDelay = sumPayedDelay + payedDelay;
			
		    /*获取冲正冲销流水*/
			long backWrtoffSn = control.getSequence("SEQ_WRTOFF_SN");
			
			/*
			 * 1.回退冲销账单记录
			 * */
			if ( payedOwe != 0 ){
				
				inMapTmp = new HashMap<String , Object>();
				inMapTmp.put("WRTOFF_SN", wrtoffSn);
				inMapTmp.put("BALANCE_ID", balanceId);
				/*inMapTmp.put( "SUFFIX" , inParam.get("PAY_YM") + 
						String.valueOf(contractNo).substring(String.valueOf(contractNo).length() - 2) );
				*/
				inMapTmp.put("SUFFIX", inParam.get("OUT_MONTH"));
				inMapTmp.put("CONTRACT_NO", outCon);
				List<Map<String, Object>> writeoffList = baseDao.queryForList("bal_writeoff_yyyymm.qWrtoffByWrtoSn", inMapTmp);
				for( Map<String, Object> writeoffMapTmp : writeoffList ){
					
					long contractNo = Long.parseLong(writeoffMapTmp.get("CONTRACT_NO").toString());
					
					inMapTmp = new HashMap<String , Object>();
					inMapTmp.put( "BILL_ID" , writeoffMapTmp.get("BILL_ID") );
					//inMapTmp.put( "SUFFIX" , String.valueOf(contractNo).substring(String.valueOf(contractNo).length() - 2) );
					outMapTmp = (Map<String, Object>)baseDao.queryForObject( "act_unpayowe_info.qByBillId" , inMapTmp );
					if( outMapTmp == null ){
						
						/*
						*有冲销记录，未冲销账单没记录，需要将已冲销账单回退
						*/
						inMapTmp = new HashMap<String , Object>();
						inMapTmp.put("YM", inParam.get("OUT_MONTH"));
						inMapTmp.put("CONTRACT_NO", contractNo);
						inMapTmp.put("WRITEOFF", writeoffMapTmp);
						inMapTmp.put("PAY_OPCODE", inParam.get("PAY_OPCODE"));
						doRollbackBill(inMapTmp);
					}else {
						
						inMapTmp = new HashMap<String , Object>();
						inMapTmp.put( "BILL_ID" , writeoffMapTmp.get("BILL_ID") );
						inMapTmp.put( "PAYED_LATER" , (-1) * Long.valueOf(writeoffMapTmp.get("PAYED_LATER").toString()) );
						inMapTmp.put( "PAYED_PREPAY" , (-1) * Long.valueOf(writeoffMapTmp.get("PAYED_PREPAY").toString()) );
						inMapTmp.put( "PAYED_TAX" , (-1) * Long.valueOf( writeoffMapTmp.get("PAYED_TAX").toString()));
						//inMapTmp.put( "SUFFIX" , String.valueOf(contractNo).substring(String.valueOf(contractNo).length() - 2) );
						baseDao.update( "act_unpayowe_info.uByBillid", inMapTmp);
					}
					
					/*
					 * 回退冲销记录  : 更新冲销表、冲销表插入负记录
					 * */
					inMapTmp = new HashMap<String, Object>();
					inMapTmp.put("YM", inParam.get("OUT_MONTH"));
					inMapTmp.put("LOGIN_NO", inParam.get("LOGIN_NO"));
					inMapTmp.put("WRTOFF_SN", wrtoffSn);
					inMapTmp.put("CONTRACT_NO", contractNo);
					inMapTmp.put("BILL_ID", writeoffMapTmp.get("BILL_ID"));
					inMapTmp.put("BALANCE_ID", balanceId);
					inMapTmp.put("BACK_WRITEOFF_SN", backWrtoffSn);
					inMapTmp.put("YEAR_MONTH", inParam.get("YEAR_MONTH"));
					doRollbackWriteoff(inMapTmp);
					
				}
			}
			
			/*
			 * 2.回退支出表	 : 更新支出表状态、支出表记录负记录
			 * */
			if( payoutFlag.equals("") ){
				
				inMapTmp = new HashMap<String, Object>();
				inMapTmp.put("YM", inParam.get("OUT_MONTH"));
				inMapTmp.put("BALANCE_ID", balanceId);
				inMapTmp.put("WRTOFF_SN", wrtoffSn);
				inMapTmp.put("PAY_BACK_SN", inParam.get("BACK_PAYSN"));
				inMapTmp.put("BACK_WRTOFF_SN", backWrtoffSn);
				inMapTmp.put("LOGIN_NO", inParam.get("LOGIN_NO"));
				inMapTmp.put("GROUP_ID", inParam.get("GROUP_ID"));
				inMapTmp.put("YEAR_MONTH", inParam.get("YEAR_MONTH"));
				doRollbackBookPayout(inMapTmp);
			}
		}
		
		sumPayout = sumPayowe + sumPayedDelay;
		
		return sumPayout;
	}
	
	
	
	/**
	 * 名称：回退用户状态<br/>
	 * @param	contractNo
	 * @param	paySn		: 要回退的缴费流水
	 * @param	payYM		： 要回退的缴费年月
	 * @param	backPaysn	: 缴费冲正流水
	 * @param	opCode
	 * @param	loginNo
	 * @param	groupId
	 * 
	 * @author qiallin
	 */
	private void doRollbackRunCode(long contractNo, long paySn, String payYm, 
			long backPaysn, LoginBaseEntity loginEntity){
		
		log.debug("回退用户状态 begin, CON_NO: " + contractNo + "paySn: "+ paySn + "YAY_YM: " + payYm
				+ "backPaySN: " + backPaysn + "LOGINBASE_ENTITY: "+ loginEntity.toString());
		
		Map<String , Object> inMapTmp = null;
		Map<String , Object> outMapTmp = null;
		
		/*取当前年月和当前时间*/
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String sCurYm = sCurTime.substring(0, 6);
		String	sTotalDate = sCurTime.substring(0, 8);
		
		inMapTmp = new HashMap<String , Object>();
		inMapTmp.put( "CONTRACT_NO" , contractNo );
		List<Map<String, Object>> resultList = baseDao.queryForList("cs_conuserrel_info.qConUserRelByConNo",inMapTmp);
		for( Map<String, Object>phone : resultList ){
			
			long idNo = Long.valueOf( phone.get("ID_NO").toString() );
			
			/**
			 * 判断应急开关是否打开，如果打开则前台回退状态，否则通信控去回退状态
			 */
			String yjkjFlag = control.getPubCodeValue(2016, "YJKJ", null);
			if(yjkjFlag.equals("1")){
				
				log.error("非应急状态，走信控回退状态！");
				
				//获取主机标识HOST_ID
				String sRegionId = "0" + String.valueOf(contractNo).substring(3, 4);
				
				inMapTmp = new HashMap<String, Object>();
				safeAddToMap(inMapTmp, "GROUP_TYPE", "G2");
				safeAddToMap(inMapTmp, "REGION_CODE", sRegionId);
				outMapTmp = (Map<String, Object>) baseDao.queryForObject("sphonegroupcfg.qHostId", inMapTmp);
				String hostId = outMapTmp.get("HOST_ID").toString();
				
				//取用户基本信息
				UserInfoEntity userEntity = user.getUserEntity(idNo, null, null, false);
				
				String dataInfo = idNo + "|" + userEntity.getPhoneNo() + "|0|0|" 
						+ userEntity.getContractNo() + "|" + paySn;
				
				Map<String, Object> inXkMap = new HashMap<String, Object>();
				inXkMap.put("ID_NO", idNo);
				inXkMap.put("DATA_INFO", dataInfo);
				inXkMap.put("OP_CODE", "8003");
				inXkMap.put("MACH_CODE", hostId);
				baseDao.insert("cct_dealdata_info.iDealData", inXkMap);
				
				return ;
			}
			
			inMapTmp = new HashMap<String , Object>();
			inMapTmp.put("PAY_SN", paySn);
			inMapTmp.put("ID_NO", idNo);
			inMapTmp.put("SUFFIX", payYm);
			outMapTmp = (Map<String , Object>)baseDao.queryForObject("bal_userchg_recd.qByPaysnId", inMapTmp );
			if( outMapTmp == null ){
				log.info("交费之后，状态未变化");
				continue;
			}
			String oldRun = (String)outMapTmp.get("OLD_RUN");
			String runCode = (String)outMapTmp.get("RUN_CODE");
			if(oldRun.equals("K")){
				log.error("用户原状态是强开K，不需要回退为K");
				continue;
			}
			
			/*
			 * 回退用户状态，记录用户状态变更记录表、向CRM发送消息
			 **/
			//取用户基本信息
			UserInfoEntity userEntity = user.getUserEntity(idNo, null, null, false);
			
			//取用户归属
			GroupchgInfoEntity groupEntity = group.getChgGroup(userEntity.getPhoneNo(), null, null);
			String userGroupId = groupEntity.getGroupId();
			
			//取用户品牌标识
			UserBrandEntity userBrandEntity = user.getUserBrandRel(idNo);
			String brandId = userBrandEntity.getBrandId();
			
			/*2向CRM发送消息，状态回退*/
			Map<String, Object> userChgMap = new HashMap<String, Object>();
			userChgMap.put("LOGIN_ACCEPT", String.valueOf(backPaysn));
			userChgMap.put("ID_NO", idNo);
			userChgMap.put("PHONE_NO", userEntity.getPhoneNo());
			userChgMap.put("RUN_CODE", oldRun);
			userChgMap.put("OP_TIME", sCurTime);
			//userChgMap.put("CONTACT_ID", 0);    //统一流水
			userChgMap.put("LOGIN_NO", loginEntity.getLoginNo());
			userChgMap.put("OP_CODE", loginEntity.getOpCode());
			userChgMap.put("OWNER_FLAG", "1");
			userChgMap.put("OPEN_FLAG", "2");
			//userChgMap.put("OPEN_FLAG", "1");        //暂时只改状态
			//userChgMap.put("FYW_FLAG", "");
			//userChgMap.put("SVC_STR", "");
			//userChgMap.put("CONTRACT_NO", "");
			log.info("调用接口opUserStatuInter前： " + userChgMap.toString());
			userChgMap.put("GROUP_ID", userGroupId);
			userChgMap.put("BRAND_ID", brandId);
			svcOrder.opUserStatuInter(userChgMap);
			log.info("调用接口opUserStatuInter完成！");
			
		}
	}
	
	
	
	/**
	 * 名称：账单移入未冲销账单、删除已冲销账单<br/>
	 * @param	YM				：冲销年月
	 * @param	CONTRACT_NO
	 * @param	PAY_OPCODE
	 * @param	WRITEOFF.BILL_ID
	 * @param	WRITEOFF.NATURAL_MONTH
	 * @param	WRITEOFF.PAYED_LATER
	 * @param	WRITEOFF.PAYED_PREPAY
	 * @param	WRITEOFF.PRINT_FLAG
	 * @param	WRITEOFF.ID_NO
	 * @param	WRITEOFF.TAX_RATE
	 * @param	WRITEOFF.TAX_FEE

	 * @author qiallin
	 */
	private void doRollbackBill(Map<String , Object> inParam) {
		
		Map<String , Object> inMapTmp = null;
		Map<String , Object> outMapTmp = null;
		
		int	iym = (Integer)inParam.get("YM");
		long contractNo = (Long)inParam.get("CONTRACT_NO");
		Map<String , Object> writeoffMap = (Map<String , Object>)inParam.get("WRITEOFF");
		
        /*取配置最小已冲销账单表日期*/
		String selDate = control.getPubCodeValue(108, "HISBILLYM", null);	//取配置的最小已冲销账单日期
		int billRules = Integer.parseInt(control.getPubCodeValue(101, "PAYEDOWE", null)); //取是否动态月或者自然月配置

		String tablePayedowe = "ACT_PAYEDOWE_INFO";
		
		if( 0 == billRules ){		//0: 按动态月账期存放
			if( Integer.parseInt(writeoffMap.get("BILL_CYCLE").toString()) >= Integer.valueOf(selDate) ){
				tablePayedowe = "ACT_PAYEDOWE_" + writeoffMap.get("BILL_CYCLE").toString();
			}else{
				tablePayedowe = "ACT_PAYEDOWE_HIS";
			}
		}else{
			if( Integer.parseInt(writeoffMap.get("NATURAL_MONTH").toString()) >= Integer.valueOf(selDate) ){
				tablePayedowe = "ACT_PAYEDOWE_" + writeoffMap.get("NATURAL_MONTH").toString();;
			}else{
				tablePayedowe = "ACT_PAYEDOWE_HIS";
			}
		}
		
		inMapTmp = new HashMap<String , Object>();
		inMapTmp.put( "BILL_ID" , writeoffMap.get("BILL_ID") );
		inMapTmp.put( "TABLE_PAYEDOWE" , tablePayedowe );
		inMapTmp.put("BILL_CYCLE", writeoffMap.get("BILL_CYCLE"));
		inMapTmp.put("CONTRACT_NO", contractNo);
		outMapTmp = (Map<String ,Object>)baseDao.queryForObject( "act_payedowe_info.qPayedFeeByBillId" , inMapTmp);
		if( outMapTmp == null ){
			log.info("已冲销账单不存在bill_id : " + writeoffMap.get("BILL_ID") );
			throw new BusiException(AcctMgrError.getErrorCode("8003","00001"), "已冲销账单不存在bill_id :  " + writeoffMap.get("BILL_ID") );
		}
		
		/*账单移入未冲销账单、删除已冲销账单*/
		//inMapTmp.put( "SUFFIX" , String.valueOf(contractNo).substring(String.valueOf(contractNo).length() - 2) );
		inMapTmp.put("PAYED_LATER", writeoffMap.get("PAYED_LATER"));
		inMapTmp.put("PAYED_PREPAY", writeoffMap.get("PAYED_PREPAY"));
		inMapTmp.put("PAYED_TAX", writeoffMap.get("PAYED_TAX"));
		inMapTmp.put("NATURAL_MONTH", writeoffMap.get("NATURAL_MONTH"));
		inMapTmp.put("BILL_CYCLE", writeoffMap.get("BILL_CYCLE"));
		inMapTmp.put("CONTRACT_NO", contractNo);
		if(inParam.get("PAY_OPCODE").toString().equals("8030")){
			
			inMapTmp.put("STATUS", "9");
		}else{
			inMapTmp.put("STATUS", "0");
		}
		baseDao.insert("act_unpayowe_info.iByPayedowe", inMapTmp);
		
		/*删除已冲销账单记录*/
		baseDao.delete( "act_payedowe_info.delByBillid" , inMapTmp );
		
	}
	
	
	
	public Map<String, Object> doRollbackRecord(Map<String, Object> inParam){
		
		Map<String , Object> inMapTmp = null;
		Map<String , Object> outMapTmp = null;
		
		long contractNo = 0;       //托收缴费账户
		long contractNo2 = 0;	   //集团先开票后缴费 集团账户
		
		LoginBaseEntity loginEntity = (LoginBaseEntity)inParam.get("LOGIN_ENTITY");
		
		/*取当前年月和当前时间*/
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String sCurYm = sCurTime.substring(0, 6);
		String	sTotalDate = sCurTime.substring(0, 8);
		
		/*循环取缴费账户*/
		inMapTmp = new HashMap<String , Object>();
		inMapTmp.put("PAY_SN", inParam.get("PAY_SN"));
		inMapTmp.put("SUFFIX", inParam.get("PAY_YM"));
		long idNo = 0;
		long sumBackFee = 0;
		List<Map<String, Object>> keysList = new ArrayList<Map<String,Object>>();	//同步报表库数据List
		//空中充值冲正统一接触需要发送两条
		List<Map<String, Object>> phonesList = (List<Map<String, Object>>)baseDao.queryForList( "bal_payment_info.qBalConByPaysnKc" , inMapTmp);	
		List<Map<String, Object>> resultList = (List<Map<String, Object>>)baseDao.queryForList( "bal_payment_info.qBalConByPaysn" , inMapTmp);
		for( Map<String, Object> resultMap : resultList ){
			
			long contractNoP = Long.valueOf( resultMap.get("CONTRACT_NO").toString() );
			String payType = resultMap.get("PAY_TYPE").toString();
			idNo = Long.valueOf( resultMap.get("ID_NO").toString() );
			sumBackFee = sumBackFee + (-1)*Long.parseLong(resultMap.get("PAY_FEE").toString()); //发送统一接触，所以传负值
			
			contractNo = contractNoP;
			
			if(Long.parseLong(resultMap.get("PAY_FEE").toString()) > 0){
				
				contractNo2 = contractNoP;
			}
			
			//1.更新payment表
			Map<String, Object> inBackpayMap = new HashMap<String, Object>();
			inBackpayMap.put("PAY_SN", inParam.get("PAY_SN"));
			inBackpayMap.put("SUFFIX", inParam.get("PAY_YM"));
			inBackpayMap.put("PAY_TYPE", payType);
			baseDao.update("bal_payment_info.uStatus", inBackpayMap);
			
			Map<String, Object> paymentKey = null;
			paymentKey = new HashMap<String, Object>();
			paymentKey.put("YEAR_MONTH", sCurYm);
			paymentKey.put("CONTRACT_NO", contractNoP);
			paymentKey.put("PAY_SN", resultMap.get("PAY_SN"));
			paymentKey.put("ID_NO", idNo);
			paymentKey.put("PAY_TYPE", resultMap.get("PAY_TYPE"));
			paymentKey.put("TABLE_NAME", "BAL_PAYMENT_INFO");
			paymentKey.put("UPDATE_TYPE", "U");
			keysList.add(paymentKey);
			
			//2.payment表记录负记录
			inBackpayMap.put("PAY_BACK_SN", inParam.get("BACK_PAYSN"));
			inBackpayMap.put("CONTRACT_NO", contractNo);
			inBackpayMap.put("OP_CODE", loginEntity.getOpCode());
			inBackpayMap.put("REMARK", loginEntity.getOpNote());
			inBackpayMap.put("LOGIN_NO", loginEntity.getLoginNo());
			inBackpayMap.put("GROUP_ID", loginEntity.getGroupId());
			inBackpayMap.put("TOTAL_DATE", sTotalDate);
			inBackpayMap.put("PAY_PATH", inParam.get("PAY_PATH"));
			inBackpayMap.put("PAY_METHOD", inParam.get("PAY_METHOD"));
			inBackpayMap.put("ORIGINAL_SN", inParam.get("PAY_SN"));
			inBackpayMap.put("SUFFIX1", sCurYm);
			inBackpayMap.put("PAY_TYPE", payType);
			inBackpayMap.put("FOREIGN_SN", inParam.get("FOREIGN_SN"));
			baseDao.insert("bal_payment_info.iForRoback", inBackpayMap);
			
			paymentKey = new HashMap<String, Object>();
			paymentKey.put("YEAR_MONTH", sCurYm);
			paymentKey.put("CONTRACT_NO", contractNoP);
			paymentKey.put("PAY_SN", inParam.get("BACK_PAYSN"));
			paymentKey.put("ID_NO", idNo);
			paymentKey.put("PAY_TYPE", resultMap.get("PAY_TYPE"));
			paymentKey.put("TABLE_NAME", "BAL_PAYMENT_INFO");
			paymentKey.put("UPDATE_TYPE", "I");
			keysList.add(paymentKey);
			
			//3.回退营业员操作日志
			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("LOGIN_SN", inParam.get("PAY_SN"));
			inMapTmp.put("PAY_BACK_SN", inParam.get("BACK_PAYSN"));
			inMapTmp.put("TOTAL_DATE", sTotalDate);
			inMapTmp.put("LOGIN_NO", loginEntity.getLoginNo());
			inMapTmp.put("GROUP_ID", loginEntity.getGroupId());
			inMapTmp.put("OP_CODE", loginEntity.getOpCode());
			inMapTmp.put("OP_NOTE", loginEntity.getOpNote());
			inMapTmp.put("SUFFIX", inParam.get("PAY_YM").toString());
			inMapTmp.put("SUFFIX1", sCurYm);
			baseDao.insert("bal_loginopr_info.iForRoback", inMapTmp);
		}
		
		//回退外部缴费控制表（如果有记录，则删除）

		//outMapTmp = (Map<String, Object>)baseDao.queryForObject("bal_paycard_recd.qPaycard", inMapTmp);
		List<PayCardEntity> payCardlist = record.getPayCardList(null, Long.parseLong(inParam.get("PAY_SN").toString()), null);
		if( payCardlist.size() != 0 ){
			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("PAY_SN", inParam.get("PAY_SN"));
			baseDao.delete("bal_paycard_recd.del",inMapTmp);
		}
		
		// 4、向其他系统同步数据（目前：CRM营业日报、BOSS报表、统一接触）
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_SN", inParam.get("BACK_PAYSN"));
		inMapTmp.put("LOGIN_NO", loginEntity.getLoginNo());
		inMapTmp.put("GROUP_ID", loginEntity.getGroupId());
		inMapTmp.put("OP_CODE", loginEntity.getOpCode());
		inMapTmp.put("BACK_FLAG", "0");
		inMapTmp.put("OLD_ACCEPT", inParam.get("PAY_SN"));
		inMapTmp.put("OP_TIME", sCurTime);
		inMapTmp.put("OP_NOTE", loginEntity.getOpNote());
		inMapTmp.put("ACTION_ID", "1001");
		inMapTmp.put("KEYS_LIST", keysList);
		inMapTmp.put("PHONES_LIST", phonesList);
		inMapTmp.put("REGION_ID", Long.toString(contractNo).substring(0, 4));
		if (inParam.get("PHONE_NO")!=null && !inParam.get("PHONE_NO").toString().equals("")) {

			inMapTmp.put("CUST_ID_TYPE", "1"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
			inMapTmp.put("CUST_ID_VALUE", inParam.get("PHONE_NO"));
		} else {

			inMapTmp.put("CUST_ID_TYPE", "3"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
			inMapTmp.put("CUST_ID_VALUE", contractNo);
		}
		
		inMapTmp.put("Header", inParam.get("Header"));
		inMapTmp.put("TOTAL_FEE", sumBackFee);
		preOrder.sendData2(inMapTmp);
		
		/*
		 * 如果是托收缴费冲正业务，则回退托收记录、托收单状态
		 * */
		if(inParam.get("PAY_OPCODE").toString().equals("8030")){
			
			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("CONTRACT_NO", contractNo);
			inMapTmp.put("LOGIN_ACCEPT" , inParam.get("PAY_SN"));
			outMapTmp = (Map<String, Object>)baseDao.queryForObject( "act_collbill_recd.qByConAndLogSn" , inMapTmp );
			int billCycle = Integer.parseInt(outMapTmp.get("BILL_CYCLE").toString());

			record.updCollbillRecd(contractNo, billCycle, Long.parseLong(inParam.get("PAY_SN").toString()));
			
			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("TOTAL_DATE", sTotalDate);
			inMapTmp.put("PAY_BACK_SN", inParam.get("BACK_PAYSN"));
			inMapTmp.put("GROUP_ID", loginEntity.getGroupId());
			inMapTmp.put("OP_CODE", loginEntity.getOpCode());
			inMapTmp.put("LOGIN_NO", loginEntity.getLoginNo());
			inMapTmp.put("REMARK", loginEntity.getOpNote());
			inMapTmp.put("CONTRACT_NO", contractNo);
			inMapTmp.put("LOGIN_ACCEPT" , inParam.get("PAY_SN"));
			baseDao.insert("act_collbill_recd.iForRoback", inMapTmp);
			
			bill.updateCollbill(contractNo, billCycle, null, "0");
		}
		
		if(inParam.get("PAY_OPCODE").toString().equals("8074")||
				inParam.get("PAY_OPCODE").toString().equals("8077")||
				inParam.get("PAY_OPCODE").toString().equals("8016")){
			inMapTmp = new HashMap<String, Object>();
			inMapTmp.put("PAY_YM", inParam.get("PAY_YM").toString());
			inMapTmp.put("PAY_SN", inParam.get("PAY_SN"));
			inMapTmp.put("BACK_SN", inParam.get("BACK_PAYSN"));
			inMapTmp.put("OP_CODE", loginEntity.getOpCode());
			inMapTmp.put("LOGIN_NO", loginEntity.getLoginNo());
			doRollbackTransfee(inMapTmp);
		}
		
		/**
		 * 回退有效期 
		 */
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("PAY_SN" , inParam.get("PAY_SN"));
		inMapTmp.put("ID_NO", idNo);
		inMapTmp.put("TOTAL_DATE", sTotalDate);
		inMapTmp.put("PAY_BACK_SN", inParam.get("BACK_PAYSN"));
		inMapTmp.put("LOGIN_NO" , loginEntity.getLoginNo());
		inMapTmp.put("OP_CODE", loginEntity.getOpCode());
		//doRollbackExpire(inMapTmp);
		
		/*先开票后缴费的处理
		 * 1、已经缴费回款的 提示先冲正回款记录
		 * 2、冲正先开票后缴费记录
		 * */
		//doBackDowePay(contractNo2, Long.parseLong(inParam.get("PAY_SN").toString()));
		
		//如果是支票缴费，则回退支票记录
		inMapTmp = new HashMap<>();
		inMapTmp.put("PAY_SN", inParam.get("PAY_SN"));
		inMapTmp.put("SUFFIX", inParam.get("PAY_YM"));
		List<PayMentEntity> listPayMent=record.getPayMentList(inMapTmp);
		if(listPayMent.get(0).getPayMethod().equals("9")){
			
			//查询支票记录
            ChequeEntity chequeEnt = new ChequeEntity();
            Map<String,Object> checkOprMap= new HashMap<String,Object>();
            checkOprMap=cheque.getCheckOpr(Long.parseLong(inParam.get("PAY_SN").toString()));
            String bankCode=checkOprMap.get("BANK_CODE").toString();
            String checkNo = checkOprMap.get("CHECK_NO").toString();
            String prePayStr=checkOprMap.get("CHECK_PAY").toString();
            long prePay = Long.parseLong(prePayStr);
            
            chequeEnt.setBankCode(bankCode);
            chequeEnt.setCheckNo(checkNo);
            
            //更新支票余额表
            PayBookEntity inBook = new PayBookEntity();
            inBook.setBankCode(bankCode);
            inBook.setGroupId(loginEntity.getGroupId());
            inBook.setLoginNo(loginEntity.getLoginNo());
            inBook.setOpCode(loginEntity.getOpCode());
            inBook.setOpNote(loginEntity.getOpNote());
            inBook.setPayFee((-1)*prePay);
            inBook.setPaySn(Long.parseLong(inParam.get("BACK_PAYSN").toString()));
            inBook.setStatus("0");
            inBook.setTotalDate(Integer.parseInt(sTotalDate));
            cheque.doAddCheck(chequeEnt, inBook);
		}
		
		Map<String, Object> outParam = new HashMap<String, Object>();
		outParam.put("SUM_BACKFEE", sumBackFee);
		return outParam;
	}
	
	
	public List<Map<String, Object>> getPaySnByForeign(String foreignSn,String payYm) {
		
		return getPaySnByForeign(foreignSn, payYm, null);
	}
	
	public List<Map<String, Object>> getPaySnByForeign(String foreignSn, String payYm, String payType){
		
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("YEAR_MONTH", payYm);
		inMapTmp.put("FOREIGN_SN", foreignSn);
		if(payType != null){
			inMapTmp.put("PAY_TYPE", payType);
		}
		List<Map<String, Object>> result = (List<Map<String, Object>>) baseDao.queryForList("bal_payment_info.qPaysnByForeign",inMapTmp);
		return result;
	}
	
	/*缴费冲正转账记录表*/
	public void doRollbackTransfee(Map<String,Object> inParam){
		
		String payYm = (String)inParam.get("YEAR_MONTH");
		long paySn = (long)inParam.get("PAY_SN");
		//判断是否存在转账记录
		if(!balance.isTransInfoByTransSn(paySn, payYm)){
			throw new BusiException(AcctMgrError.getErrorCode("0000", "00076"), "没有转账记录");
		}
		//更新转账记录状态
		balance.updateStatusByTransSn(paySn,payYm);
		//插入冲正记录
		balance.insertRollBackTransInfo(inParam);
		
		log.info("执行完毕");
	}
	
	@Override
	public void commit() {
		try {
			baseDao.getConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	} 

	/* (non-Javadoc)
	 * @see com.sitech.acctmgr.atom.busi.pay.inter.IPayDoInter#rollback()
	 */
	@Override
	public void rollback() {
		try {
			baseDao.getConnection().rollback();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	/*转出账户预存验证*/
	@SuppressWarnings("unchecked")
	public void checkTransOutFee(long balanceId){
		
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("BALANCE_ID", balanceId);
		Map<String, Object> outMapTmp = (Map<String, Object>) baseDao.queryForObject("bal_acctbook_info.qryBalacneByBalanceId", inMapTmp);
		long curBalance = -1;
		if (outMapTmp == null) {
			curBalance = -1;
		} else {
			curBalance = Long.parseLong(outMapTmp.get("CUR_BALANCE").toString());
		}
		if (curBalance < 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8014", "00033"),
					"转账后账本当前预存款为负,不能进行转账，请核实！ BALANCE_ID: " + balanceId);
		}
	}
	
	public void insertZQInfo(Map<String,Object> inMap){
		long paySn = (long)inMap.get("PAY_SN");
		long custId = (long)inMap.get("CUST_ID");
		long outContractNo = (long)inMap.get("OUT_CONTRACT_NO");
		long inContractNo = (long)inMap.get("IN_CONTRACT_NO");
		long idNo = (long)inMap.get("ID_NO");
		String opCode = (String)inMap.get("OP_CODE");
		String loginNo = (String)inMap.get("LOGIN_NO");
		String foreignSn = (String)inMap.get("FOREIGN_SN");
		Map<String,Object> header = (Map<String,Object>)inMap.get("HEADER");
		
		PayUserBaseEntity payUserBase = null;
		PayBookEntity inBook = null;
		FieldEntity field = null;
		payUserBase.setContractNo(outContractNo);
		payUserBase.setIdNo(idNo);
		inBook.setLoginNo(loginNo);
		inBook.setForeignSn(foreignSn);
		inBook.setPaySn(paySn);
		inBook.setOpCode(opCode);
		
		
		/*根据unitId、custId或groupNo查询集团信息*/
		CustInfoEntity custInfo = cust.getCustInfo(Long.valueOf(custId), null);
		String groupName = custInfo.getCustName();
		String groupId = custInfo.getGroupId();
		GrpCustInfoEntity grpCustInfo = cust.getGrpCustInfo(Long.valueOf(custId), null);
		long unitId = grpCustInfo.getUnitId();
		
		//入集团编码
		field.setFieldCode("unitId");
		field.setFieldValue(String.valueOf(unitId));
		record.savePayextend(payUserBase, inBook, field,header);
		
		//入集团名称
		field.setFieldCode("unitName");
		field.setFieldValue(groupName);
		record.savePayextend(payUserBase, inBook, field,header);
		
		//获取账户名称
		ContractInfoEntity outContractEnt = account.getConInfo(outContractNo,false);
		ContractInfoEntity inContractEnt = account.getConInfo(inContractNo,false);
		String outContractName = outContractEnt.getContractattTypeName();
		String inContractName = inContractEnt.getContractattTypeName();
		
		//入转出账户名称
		field.setFieldCode("OutConName");
		field.setFieldValue(outContractName);
		record.savePayextend(payUserBase, inBook, field,header);
		
		//入转入账户名称
		field.setFieldCode("InConName");
		field.setFieldValue(inContractName);
		record.savePayextend(payUserBase, inBook, field,header);
		
		//获取客户经理工号和姓名
		Map<String,Object> inMapTmp = new HashMap<String,Object>();
		inMapTmp.put("CUST_ID", custId);
		String staffLogin = (String) baseDao.queryForObject("ct_custmanager_rel.qContactLogin", inMapTmp);
		String loginName = login.getLoginInfo(staffLogin, "230000").getLoginName();
		
		//入客户经理工号
		field.setFieldCode("ManaLogin");
		field.setFieldValue(staffLogin);
		record.savePayextend(payUserBase, inBook, field,header);
		
		//入客户经理姓名
		field.setFieldCode("ManaName");
		field.setFieldValue(loginName);
		record.savePayextend(payUserBase, inBook, field,header);
		
		//入集团groupId
		field.setFieldCode("GrpGroupId");
		field.setFieldValue(groupId);
		record.savePayextend(payUserBase, inBook, field,header);
		
	}

	@Override
	public void upAcctbookEndTime(long contractNo, String foreignSn, String payType, String beginDate, String endTime,
			Map<String, Object> inParam){
		
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		
		Map<String, Object> inMapTmp = null;
		
		inMapTmp = new HashMap<String,Object>();
		inMapTmp.put("CONTRACT_NO", contractNo);
		inMapTmp.put("PAY_TYPE", payType);
		inMapTmp.put("FOREIGN_SN", foreignSn);
		inMapTmp.put("QUERY_TIME", sCurTime.substring(0, 8));
		List<Map<String, Object>> bookList = balance.getAcctBookList(inMapTmp);
		log.debug("upAcctbookEndTime 要更新结束时间账本列表： " + bookList.toString());
		for(Map<String, Object> bookTmp : bookList){
			
			long balanceId = Long.parseLong(bookTmp.get("BALANCE_ID").toString());
			
			balance.saveAcctbookHis(contractNo, balanceId, inParam.get("LOGIN_NO").toString(), 
					Long.parseLong(inParam.get("LOGIN_ACCEPT").toString()), "U", inParam.get("OP_CODE").toString());
			
			balance.upAcctboookEndTime(contractNo, balanceId, endTime);
		}
	}

	public ICheque getCheque() {
		return cheque;
	}

	public void setCheque(ICheque cheque) {
		this.cheque = cheque;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}



	public IBalance getBalance() {
		return balance;
	}



	public void setBalance(IBalance balance) {
		this.balance = balance;
	}



	public IRecord getRecord() {
		return record;
	}



	public void setRecord(IRecord record) {
		this.record = record;
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



	public IControl getControl() {
		return control;
	}



	public void setControl(IControl control) {
		this.control = control;
	}



	public IWriteOffer getWriteOffer() {
		return writeOffer;
	}



	public void setWriteOffer(IWriteOffer writeOffer) {
		this.writeOffer = writeOffer;
	}



	public IBill getBill() {
		return bill;
	}



	public void setBill(IBill bill) {
		this.bill = bill;
	}



	public IAgent getAgent() {
		return agent;
	}



	public void setAgent(IAgent agent) {
		this.agent = agent;
	}



	public IAccount getAccount() {
		return account;
	}



	public void setAccount(IAccount account) {
		this.account = account;
	}



	public IRemainFee getRemainFee() {
		return remainFee;
	}



	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}



	public IPaybakLimit getPayBackLimit() {
		return payBackLimit;
	}



	public void setPayBackLimit(IPaybakLimit payBackLimit) {
		this.payBackLimit = payBackLimit;
	}



	public IPreOrder getPreOrder() {
		return preOrder;
	}



	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}



	public ISvcOrder getSvcOrder() {
		return svcOrder;
	}



	public void setSvcOrder(ISvcOrder svcOrder) {
		this.svcOrder = svcOrder;
	}

	/**
	 * @return the invoice
	 */
	public IInvoice getInvoice() {
		return invoice;
	}

	/**
	 * @param invoice the invoice to set
	 */
	public void setInvoice(IInvoice invoice) {
		this.invoice = invoice;
	}

	/**
	 * @return the login
	 */
	public ILogin getLogin() {
		return login;
	}

	/**
	 * @param login the login to set
	 */
	public void setLogin(ILogin login) {
		this.login = login;
	}

	/**
	 * @return the cust
	 */
	public ICust getCust() {
		return cust;
	}

	/**
	 * @param cust the cust to set
	 */
	public void setCust(ICust cust) {
		this.cust = cust;
	}

	/**
	 * @return the shortMessage
	 */
	public IShortMessage getShortMessage() {
		return shortMessage;
	}

	/**
	 * @param shortMessage the shortMessage to set
	 */
	public void setShortMessage(IShortMessage shortMessage) {
		this.shortMessage = shortMessage;
	}
	

}
