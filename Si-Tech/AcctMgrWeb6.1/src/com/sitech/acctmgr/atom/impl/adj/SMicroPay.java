package com.sitech.acctmgr.atom.impl.adj;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.adj.inter.IAdjCommon;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayOpener;
import com.sitech.acctmgr.atom.busi.pay.inter.ITransType;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.adj.AdjBIllEntity;
import com.sitech.acctmgr.atom.domains.adj.MicroPayEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserPrcEntity;
import com.sitech.acctmgr.atom.dto.adj.SMicroPayBackCfmInDTO;
import com.sitech.acctmgr.atom.dto.adj.SMicroPayBackCfmOutDTO;
import com.sitech.acctmgr.atom.dto.adj.SMicroPayCfmInDTO;
import com.sitech.acctmgr.atom.dto.adj.SMicroPayCfmOutDTO;
import com.sitech.acctmgr.atom.dto.adj.SMicroPayInitInDTO;
import com.sitech.acctmgr.atom.dto.adj.SMicroPayInitOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAdj;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IProd;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgr.inter.adj.IMicroPay;
import com.sitech.billing.qdetail.common.util.DateUtils;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

/**
* <p>Title:小额支付   </p>
* <p>Description:   </p>
* <p>Copyright: Copyright (c) 2016</p>
* <p>Company: SI-TECH </p>
* @author 
* @version 1.0
*/
@ParamTypes({ @ParamType(m = "init", c = SMicroPayInitInDTO.class,oc = SMicroPayInitOutDTO.class),
			  @ParamType(m = "cfm", c = SMicroPayCfmInDTO.class,oc = SMicroPayCfmOutDTO.class),
			  @ParamType(m = "backCfm", c = SMicroPayBackCfmInDTO.class,oc = SMicroPayBackCfmOutDTO.class)
			}
		   )
public class SMicroPay extends AcctMgrBaseService 
					   implements IMicroPay{

	private IUser user;
	private IControl control;
	private IRemainFee remainFee;
	private IAdj adj;
	private IAdjCommon adjCommon;
	private ITransType trans;
	private IBill bill;
	private IRecord record;
	private IProd prod;
	private IBalance balance;
	private IPayOpener payOpener;

	@Override
	public OutDTO init(InDTO inParam){
		// TODO Auto-generated method stub
		/* 入参 */
		SMicroPayInitInDTO inDto = (SMicroPayInitInDTO) inParam;
		log.info("SMicroPay init 入参--> " + inDto.getMbean());
		String phoneNo = inDto.getInPhoneNo();
		
		/* 取用户默认账户和开户时间 */
		UserInfoEntity userEnt = user.getUserInfo(phoneNo);
		long contractNo = userEnt.getContractNo();
		String vOpenTime=userEnt.getOpenTime();
		
		/*计算用户的账户余额*/
		long remainFeeTmp =  remainFee.getConRemainFee(contractNo).getRemainFee();
		log.info("用户余额:[" + contractNo + "][" + remainFeeTmp + "]");
		
		//计算用户可转金额
		long transFee = trans.getTranFee(contractNo);
		
		//手机钱包查询可用余额和欠费标识
		long leftPrepayFee = 0L;
		long oweFlag = 0L;
		if(remainFeeTmp > 0){
			oweFlag = 0L;                            //不欠费
			
			if(transFee - remainFeeTmp > 0){
				leftPrepayFee = remainFeeTmp;
			}else{
				leftPrepayFee = transFee;
			}
		}else{
			oweFlag = 1L;                             //欠费
		}
		
		//获取上月的月份
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		//preYM = Integer.parseInt(curTime.substring(0, 6))-1;
		int preYM = DateUtils.AddMonth(Integer.parseInt(curTime.substring(0, 6)), -1) ;
		
		//获取用户所有的付费账户上个月的点对点语音消费账单
		Map<String,Object> inMap =  new HashMap<String,Object>();
		inMap.put("CONTRACT_NO",contractNo);
		inMap.put("BILL_CYCLE", preYM);
		
		//未冲销语音账单
		Map<String,Long> billUnPayeMap = new HashMap<String,Long>();
		billUnPayeMap = bill.getSumUnpayInfoByItems(contractNo, null, new Integer(preYM),"0000000002","3");                                     //未冲销账单
		long unOweFee = billUnPayeMap.get("SHOULD_PAY");
		ValueUtils.transFenToYuan(unOweFee);
		//已冲销语音账单
		Map<String,Long> billPayedMap = new HashMap<String,Long>();		  
		billPayedMap = bill.getSumPayedInfoByItems(contractNo, null, new Integer(preYM),"0000000002","3");   
		long oweFee = billPayedMap.get("SHOULD_PAY");
		ValueUtils.transFenToYuan(oweFee);
				
		long payFee = 0L;
		payFee= unOweFee + oweFee;
		//出参信息拼装
		SMicroPayInitOutDTO outDto=new SMicroPayInitOutDTO();
		outDto.setLeftPrepayFee(leftPrepayFee);
		outDto.setvOpenTime(vOpenTime);
		outDto.setOweFlag(oweFlag);
		outDto.setvPayFee(payFee);
		log.info("SMicroPay init 出参-->  " + outDto.toJson());
		return outDto;
	}
	
	@Override
	public OutDTO cfm(InDTO inParam){
		
		SMicroPayCfmInDTO inDto=(SMicroPayCfmInDTO)inParam;
		log.info("SMicroPay cfm 入参-->  " + inDto.getMbean());
		
		String phoneNo = inDto.getInPhoneNo();
		String loginNo = inDto.getLoginNo();
		String password = inDto.getvPassWord();
		String tradeCode = inDto.getvTradCode();
		String transId = inDto.getInTransId();
		String transDate = inDto.getInTransDate();
		String companyName = inDto.getInCompanyName();
		String goodsName = inDto.getInGoodsName();
		String goodsId = inDto.getInGoodsId();
		String companyId = inDto.getInCompanyId();
		String serviceType = inDto.getServiceType();
		long payFee = inDto.getInPrePayFee();
		
		String opCode = inDto.getOpCode();
		String provinceId = inDto.getProvinceId();
		String groupId  = inDto.getGroupId();
		
        //获取当前时间
        String curTime = DateUtil.format(new Date(), PayBusiConst.YYYYMMDDHHMMSS2);
        String yearMonth=String.format("%6s", curTime.substring(0, 6));//当前年月
        int totalDate= Integer.parseInt(String.format("%6s", curTime.substring(0, 8)));

        /*取用户的默认账户,作为小额支付账户*/
        UserInfoEntity userEnt = user.getUserInfo(phoneNo);
        Long contractNo=userEnt.getContractNo();
        String vOpenTime=userEnt.getOpenTime();

        /*取用户主资费*/
        //取用户主产品
        UserPrcEntity userPrcEnt = prod.getUserPrcidInfo(userEnt.getIdNo());
        String prodPrcid = userPrcEnt.getProdPrcid();

        /*校验账户预存,预存不足,不允许办理*/
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("CONTRACT_NO",contractNo);
        inMap.put("PAY_ATTR4","0");
        inMap.put("SPECIAL_FLAG","1");
        Long curBalance=balance.getAcctBookSumByMap(inMap);
        if(curBalance < payFee){
            throw new BaseException(AcctMgrError.getErrorCode("C240", "00001"),"用户可用余额不足！");
        }

        /*取补收流水*/
        long paySn=control.getSequence("SEQ_PAY_SN");

        String acctItemCode="";
        /*取配置账目项*/
        if(serviceType.equals("0")){
        	acctItemCode="0B2000000f";
        }else{
        	acctItemCode="0V2000000w";
        }
        

        /*取账单bill_day*/
        Map<String, Object> inAdjMap = new HashMap<String, Object>();
        inAdjMap.put("CONTRACT_NO",contractNo);
        inAdjMap.put("BILL_CYCLE",yearMonth);
        inAdjMap.put("BILL_DAY_BEGIN","8000");
        inAdjMap.put("BILL_DAY_END","8500");
        inAdjMap.put("SUFFIX",yearMonth);
        int billDay=bill.getMaxBillDay(inAdjMap);

        //用户基本信息实体设值
        PayUserBaseEntity userBase = new PayUserBaseEntity();
        userBase.setContractNo(contractNo);
        userBase.setCustId(userEnt.getCustId());
        userBase.setIdNo(userEnt.getIdNo());
        userBase.setPhoneNo(phoneNo);
        userBase.setBrandId(userEnt.getBrandId());
        userBase.setUserGroupId(userEnt.getGroupId());
        userBase.setProdPrcid(prodPrcid);

        //补收账单实体设值
        AdjBIllEntity billEnt = new AdjBIllEntity();
        billEnt.setBillCycle(Integer.parseInt(yearMonth));
        billEnt.setNaturalMonth(Integer.parseInt(yearMonth));
        billEnt.setAcctItemCode(acctItemCode);
        billEnt.setShouldPay(payFee);
        billEnt.setBillDay(billDay);

        //入账实体设值
        PayBookEntity inBook =  new PayBookEntity();
        inBook.setGroupId(groupId);
        inBook.setLoginNo(loginNo);
        inBook.setOpCode(opCode);
        //inBook.setOpNote(remark);
        inBook.setPaySn(paySn);

        //补收核心函数
        inAdjMap = new HashMap<String, Object>();
        inAdjMap.put("Header", inDto.getHeader());
        inAdjMap.put("PAY_BOOK_ENTITY", inBook);
        inAdjMap.put("ADJ_BILL_ENTITY", billEnt);
        inAdjMap.put("PAY_USER_BASE_ENTITY", userBase);
        inAdjMap.put("PROVINCE_ID", provinceId);
        inAdjMap.put("BILL_ID", 0L);

        Map<String, Object> outParamMap = adjCommon.MicroAdj(inAdjMap);

        //记录小额支付记录表bal_micropay_info
        inAdjMap = new HashMap<String, Object>();
        inAdjMap.put("PHONE_NO",phoneNo);
        inAdjMap.put("ID_NO",userEnt.getIdNo());
        inAdjMap.put("CONTRACT_NO",contractNo);
        inAdjMap.put("UNIT_CODE",companyId);
        inAdjMap.put("BUSI_CODE",goodsId);
        inAdjMap.put("INNET_CODE",tradeCode);
        inAdjMap.put("OP_TYPE","microPay");
        inAdjMap.put("AMOUNT", "");
        inAdjMap.put("UNIT_PRICE","");
        inAdjMap.put("PAY_TYPE","0");
        inAdjMap.put("PAY_FEE",payFee);
        inAdjMap.put("FOREIGN_SN",transId);
        inAdjMap.put("PAY_SN",paySn);
        inAdjMap.put("ORI_PAY_SN","");
        inAdjMap.put("ORI_FOREIGN_SN","");
        inAdjMap.put("USE_FLAG","0");
        inAdjMap.put("REMARK","小额支付");
        inAdjMap.put("FACTOR_ONE","");
        inAdjMap.put("FACTOR_TWO","");
        inAdjMap.put("FACTOR_THREE","");
        inAdjMap.put("FACTOR_FOUR",companyName);
        inAdjMap.put("FACTOR_FIVE",goodsName);
        inAdjMap.put("FOREIGN_TIME",transDate);
        inAdjMap.put("LOGIN_NO",loginNo);
        adj.saveMicroPayInfo(inAdjMap);

        //记录营业员操作记录表
        LoginOprEntity loginOprEnt = new LoginOprEntity();
        loginOprEnt.setBrandId(userBase.getBrandId());
        loginOprEnt.setIdNo(userBase.getIdNo());
        loginOprEnt.setLoginGroup(groupId);
        loginOprEnt.setLoginNo(loginNo);
        loginOprEnt.setLoginSn(paySn);
        loginOprEnt.setOpCode(opCode);
        loginOprEnt.setOpTime(curTime);
        loginOprEnt.setPayFee(payFee);
        loginOprEnt.setPhoneNo(phoneNo);
        loginOprEnt.setRemark("小额支付");
        loginOprEnt.setPayType("0");
        loginOprEnt.setTotalDate(totalDate);
        record.saveLoginOpr(loginOprEnt);

    	/*计算用户的账户余额*/
		long remainFeeTmp =  remainFee.getConRemainFee(contractNo).getRemainFee();
		log.info("用户余额:[" + contractNo + "][" + remainFeeTmp + "]");
		
		//计算用户可转金额
		long transFee = trans.getTranFee(contractNo);
		
		//手机钱包查询可用余额和欠费标识
		long leftPrepayFee = 0L;
		long oweFlag = 0L;
		if(remainFeeTmp > 0){
			oweFlag = 0L;                            //不欠费
			
			if(transFee - remainFeeTmp > 0){
				leftPrepayFee = remainFeeTmp;
			}else{
				leftPrepayFee = transFee;
			}
		}else{
			oweFlag = 1L;                             //欠费
		}
        
        //获取上月的月份
      	int preYM = DateUtils.AddMonth(Integer.parseInt(curTime.substring(0, 6)), -1) ;
      	
        //获取用户所有的付费账户上个月的点对点语音消费账单
        Map<String,Object> inPreMap =  new HashMap<String,Object>();
        inPreMap.put("CONTRACT_NO",contractNo);
      	inPreMap.put("BILL_CYCLE", preYM);
      	
      	//未冲销的语音账单
      	Map<String,Long> billUnPayeMap = new HashMap<String,Long>();
      	billUnPayeMap = bill.getSumUnpayInfoByItems(contractNo, null, new Integer(preYM),"0000000002","3");                                     //未冲销账单
      	long unOweFee = billUnPayeMap.get("SHOULD_PAY");
      	//已冲销的语音账单
      	Map<String,Long> billPayedMap = new HashMap<String,Long>();		  
      	billPayedMap = bill.getSumPayedInfoByItems(contractNo, null, new Integer(preYM),"0000000002","3");   
      	long oweFee = billPayedMap.get("SHOULD_PAY");
      				
      	long paedFee = 0L;
      	paedFee= unOweFee + oweFee;
      		
        //拼接出参
		SMicroPayCfmOutDTO outDto = new SMicroPayCfmOutDTO();
		
		outDto.setTransId(transId);
		outDto.setPhoneNo(phoneNo);
		log.info("SMicroPay cfm 出参-->  " + outDto.toJson());
		return outDto;
	}
	
	@Override
	public OutDTO backCfm(InDTO inParam) {
		SMicroPayBackCfmInDTO inDto=(SMicroPayBackCfmInDTO)inParam;
		log.info("SMicroPay backCfm 入参-->  " + inDto.getMbean());
		
		String phoneNo = inDto.getInPhoneNo();
		String loginNo = inDto.getLoginNo();
		String password = inDto.getvPassWord();
		String tradeCode = inDto.getvTradCode();
		String transId = inDto.getInTransId();
		String transDate = inDto.getInTransDate();
		String backTransId = inDto.getInBackTransId();
		
		
		String opCode = inDto.getOpCode();
		String provinceId = inDto.getProvinceId();
		String groupId  = inDto.getGroupId();
		
        //获取当前时间
        String curTime = DateUtil.format(new Date(), PayBusiConst.YYYYMMDDHHMMSS2);
        String yearMonth=String.format("%6s", curTime.substring(0, 6));//当前年月
        int totalDate= Integer.parseInt(String.format("%6s", curTime.substring(0, 8)));

        /*取用户的默认账户*/
        UserInfoEntity userEnt = user.getUserInfo(phoneNo);
        Long contractNo=userEnt.getContractNo();
        String vOpenTime=userEnt.getOpenTime();

        /*取用户主资费*/
        //取用户主产品
        UserPrcEntity userPrcEnt = prod.getUserPrcidInfo(userEnt.getIdNo());
        String prodPrcid = userPrcEnt.getProdPrcid();

        //获取小额支付记录
        Map inQueryPayMap = new HashMap();
        inQueryPayMap.put("PHONE_NO", phoneNo);
        inQueryPayMap.put("CONTRACT_NO", contractNo);
        inQueryPayMap.put("FOREIGN_SN", transId);
        inQueryPayMap.put("USE_FLAG", "0");
        List<MicroPayEntity> mPayList = new ArrayList<MicroPayEntity>();
        mPayList = adj.queryMicroPayInfo(inQueryPayMap);
        
        if(mPayList.size()==0){
        	throw new BaseException(AcctMgrError.getErrorCode("C240", "00002"),"未查找到用户的支付信息！");
        }
        
        String companyName = mPayList.get(0).getFactorFour();
		String goodsName = mPayList.get(0).getFactorFive();
		String goodsId = mPayList.get(0).getBusiCode();
		String companyId = mPayList.get(0).getUnitCode();
		//冲正使用负数，负补收函数中未做正负处理，所以此处需要变为负数金额
		long payFee = -1*(mPayList.get(0).getPayFee());
		String oldPaySn = mPayList.get(0).getPaySn();

		int iDiffMonth=0;
		int curMonth = Integer.parseInt(curTime.substring(0, 6));
		int foreignMonth = Integer.parseInt(mPayList.get(0).getForeignTime().substring(0, 6));
		iDiffMonth = curMonth - foreignMonth;
		
		System.out.println("curMonth:"+curMonth+"foreignMonth:"+foreignMonth+"iDiffMonth:"+iDiffMonth+"+++++++++++");
		if( iDiffMonth > 0){
        	throw new BaseException(AcctMgrError.getErrorCode("C240", "00003"),"隔月不能冲正！");
        }
		
        /*取补收流水*/
        long paySn=control.getSequence("SEQ_PAY_SN");

        /*取配置账目项*/
        String acctItemCode="0B2000000f";

        /*取账单bill_day*/
        Map<String, Object> inAdjMap = new HashMap<String, Object>();
        inAdjMap.put("CONTRACT_NO",contractNo);
        inAdjMap.put("BILL_CYCLE",yearMonth);
        inAdjMap.put("BILL_DAY_BEGIN","8000");
        inAdjMap.put("BILL_DAY_END","8500");
        inAdjMap.put("SUFFIX",yearMonth);
        int billDay=bill.getMaxBillDay(inAdjMap);

        //用户基本信息实体设值
        PayUserBaseEntity userBase = new PayUserBaseEntity();
        userBase.setContractNo(contractNo);
        userBase.setCustId(userEnt.getCustId());
        userBase.setIdNo(userEnt.getIdNo());
        userBase.setPhoneNo(phoneNo);
        userBase.setBrandId(userEnt.getBrandId());
        userBase.setUserGroupId(userEnt.getGroupId());
        userBase.setProdPrcid(prodPrcid);

        //补收账单实体设值
        AdjBIllEntity billEnt = new AdjBIllEntity();
        billEnt.setBillCycle(Integer.parseInt(yearMonth));
        billEnt.setNaturalMonth(Integer.parseInt(yearMonth));
        billEnt.setAcctItemCode(acctItemCode);
        billEnt.setShouldPay(payFee);
        billEnt.setBillDay(billDay);

        //入账实体设值
        PayBookEntity inBook =  new PayBookEntity();
        inBook.setGroupId(groupId);
        inBook.setLoginNo(loginNo);
        inBook.setOpCode(opCode);
        inBook.setPayType("0");
        inBook.setBeginTime(curTime);
		inBook.setTotalDate(totalDate);
		inBook.setYearMonth(Long.parseLong(yearMonth));
        //inBook.setOpNote(remark);
        inBook.setPaySn(paySn);

        //补收核心函数
        inAdjMap = new HashMap<String, Object>();
        inAdjMap.put("Header", inDto.getHeader());
        inAdjMap.put("PAY_BOOK_ENTITY", inBook);
        inAdjMap.put("ADJ_BILL_ENTITY", billEnt);
        inAdjMap.put("PAY_USER_BASE_ENTITY", userBase);
        inAdjMap.put("PROVINCE_ID", provinceId);

        Map<String, Object> outParamMap = adjCommon.MinusAdj(inAdjMap);

        //记录小额支付记录表bal_micropay_info
        inAdjMap = new HashMap<String, Object>();
        inAdjMap.put("PHONE_NO",phoneNo);
        inAdjMap.put("ID_NO",userEnt.getIdNo());
        inAdjMap.put("CONTRACT_NO",contractNo);
        inAdjMap.put("UNIT_CODE",companyId);
        inAdjMap.put("BUSI_CODE",goodsId);
        inAdjMap.put("INNET_CODE",tradeCode);
        inAdjMap.put("OP_TYPE","microPay");
        inAdjMap.put("AMOUNT", "");
        inAdjMap.put("UNIT_PRICE","");
        inAdjMap.put("PAY_TYPE","0");
        inAdjMap.put("PAY_FEE",payFee);
        inAdjMap.put("FOREIGN_SN",transId);
        inAdjMap.put("PAY_SN",paySn);
        inAdjMap.put("ORI_PAY_SN","");
        inAdjMap.put("ORI_FOREIGN_SN","");
        inAdjMap.put("USE_FLAG","1");
        inAdjMap.put("REMARK","小额支付");
        inAdjMap.put("FACTOR_ONE","");
        inAdjMap.put("FACTOR_TWO","");
        inAdjMap.put("FACTOR_THREE","");
        inAdjMap.put("FACTOR_FOUR",companyName);
        inAdjMap.put("FACTOR_FIVE",goodsName);
        inAdjMap.put("FOREIGN_TIME",transDate);
        inAdjMap.put("LOGIN_NO",loginNo);
        adj.saveMicroPayInfo(inAdjMap);
        
        //更新小额支付记录
        inAdjMap.put("PAY_SN",oldPaySn);
        adj.updateMicroPayInfo(inAdjMap);

        //记录营业员操作记录表
        LoginOprEntity loginOprEnt = new LoginOprEntity();
        loginOprEnt.setBrandId(userBase.getBrandId());
        loginOprEnt.setIdNo(userBase.getIdNo());
        loginOprEnt.setLoginGroup(groupId);
        loginOprEnt.setLoginNo(loginNo);
        loginOprEnt.setLoginSn(paySn);
        loginOprEnt.setOpCode(opCode);
        loginOprEnt.setOpTime(curTime);
        loginOprEnt.setPayFee(payFee);
        loginOprEnt.setPhoneNo(phoneNo);
        loginOprEnt.setRemark("小额支付");
        loginOprEnt.setPayType("0");
        loginOprEnt.setTotalDate(totalDate);
        record.saveLoginOpr(loginOprEnt);
      		
      	// 负补收，开机
     	Map<String, Object> inOpenMap = new HashMap<String, Object>();
     	inOpenMap = new HashMap<String, Object>();
     	inOpenMap.put("CONTRACT_NO", userBase.getContractNo());
     	inOpenMap.put("PAY_SN", inBook.getPaySn());
     	inOpenMap.put("OP_CODE", inBook.getOpCode());
     	inOpenMap.put("LOGIN_NO", inBook.getLoginNo());
     	inOpenMap.put("LOGIN_GROUP", inBook.getGroupId());
     	payOpener.doConUserOpen(inDto.getHeader(), userBase, inBook, provinceId);
     	
        //拼接出参
		SMicroPayBackCfmOutDTO outDto = new SMicroPayBackCfmOutDTO();
		
		outDto.setOutTransId(backTransId);
		outDto.setPhoneNo(phoneNo);
		log.info("SMicroPay backCfm 出参-->  " + outDto.toJson());
		return outDto;
	}
	
	
	public IUser getUser() {
		return user;
	}
	public void setUser(IUser user) {
		this.user = user;
	}
	public IControl getControl() {
		return control;
	}
	public void setControl(IControl control) {
		this.control = control;
	}
	public IRemainFee getRemainFee() {
		return remainFee;
	}
	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}
	public IAdj getAdj() {
		return adj;
	}
	public void setAdj(IAdj adj) {
		this.adj = adj;
	}
	public ITransType getTrans() {
		return trans;
	}
	public void setTrans(ITransType trans) {
		this.trans = trans;
	}
	public IBill getBill() {
		return bill;
	}
	public void setBill(IBill bill) {
		this.bill = bill;
	}
	public IAdjCommon getAdjCommon() {
		return adjCommon;
	}

	public void setAdjCommon(IAdjCommon adjCommon) {
		this.adjCommon = adjCommon;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}
	
	public IProd getProd() {
		return prod;
	}

	public void setProd(IProd prod) {
		this.prod = prod;
	}

	public IBalance getBalance() {
		return balance;
	}

	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	
	public IPayOpener getPayOpener() {
		return payOpener;
	}

	public void setPayOpener(IPayOpener payOpener) {
		this.payOpener = payOpener;
	}

	
}