package com.sitech.acctmgr.atom.impl.feeqry;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import org.json.JSONObject;

import com.sitech.acctmgr.atom.domains.balance.BatchpayInfoEntity;
import com.sitech.acctmgr.atom.domains.balance.BookPayoutEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.pay.Pay1500QryEntity;
import com.sitech.acctmgr.atom.domains.pay.PayIntEntity;
import com.sitech.acctmgr.atom.domains.pay.PayMentEntity;
import com.sitech.acctmgr.atom.domains.pay.PhonePayNewEntity;
import com.sitech.acctmgr.atom.domains.query.PayCardEntity;
import com.sitech.acctmgr.atom.domains.query.PayCardQryEntity;
import com.sitech.acctmgr.atom.domains.query.WxPayEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.feeqry.SBackPayQryInDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SBackPayQryOutDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SMallPayQryInDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SMallPayQryOutDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SPay1500QryInDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SPay1500QryOutDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SPayFlagQryInDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SPayFlagQryOutDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SPayQueryInDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SPayQueryOutDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SPhonePayNewInDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SPhonePayNewOutDTO;
import com.sitech.acctmgr.atom.dto.query.SPayCardQryInDTO;
import com.sitech.acctmgr.atom.dto.query.SPayCardQryOutDTO;
import com.sitech.acctmgr.atom.dto.query.SWxPayQryInDTO;
import com.sitech.acctmgr.atom.dto.query.SWxPayQryOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IBase;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.inter.feeqry.IPayQuery;
import com.sitech.billing.qdetail.common.util.DateUtils;
import com.sitech.common.CrossEntity;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

@ParamTypes({ 
	@ParamType(m = "qryPayInfo", c = SPayQueryInDTO.class, oc = SPayQueryOutDTO.class),
	@ParamType(m = "phonePayNew", c = SPhonePayNewInDTO.class, oc = SPhonePayNewOutDTO.class),
	@ParamType(m = "payFlagQry", c = SPayFlagQryInDTO.class, oc = SPayFlagQryOutDTO.class),
	@ParamType(m = "pay1500Qry", c = SPay1500QryInDTO.class, oc = SPay1500QryOutDTO.class),
	@ParamType(m = "mallPayQry", c = SMallPayQryInDTO.class, oc = SMallPayQryOutDTO.class),
	@ParamType(m = "backPayQry", c = SBackPayQryInDTO.class, oc = SBackPayQryOutDTO.class),
	@ParamType(m = "payCardQry", c = SPayCardQryInDTO.class, oc = SPayCardQryOutDTO.class),
	@ParamType(m = "wxPayQry", c = SWxPayQryInDTO.class, oc = SWxPayQryOutDTO.class)
})
public class SPayQuery extends AcctMgrBaseService implements IPayQuery{

	protected IUser user;
	protected IRecord record;
	protected IGroup group;
	protected IControl control;
	protected ILogin login;
	protected IBalance balance;
	protected IBase base;
	
	@Override
	public OutDTO qryPayInfo(InDTO inParam) {
		Map<String, Object> inMap = new HashMap<String, Object>();
		
		List<PayIntEntity> resultList = new ArrayList<PayIntEntity>();
		
		String phoneNo = "";
		int beginDate = 0;
		int endDate = 0;
		String opCode = "0000";
		
		SPayQueryInDTO inDto = (SPayQueryInDTO) inParam;
		
		phoneNo = inDto.getPhoneNo();
		beginDate = inDto.getBeginDate();
		endDate = inDto.getEndDate();
		opCode = inDto.getOpCode();
		
		//取当前时间，6个月以前的时间
		String sCurDate = DateUtil.format(new Date(), "yyyyMMdd");
		String sBeforeDate = DateUtil.toStringMinusMonths(sCurDate, 6, "yyyyMMdd");
		
		if(endDate < Integer.parseInt(sBeforeDate)) {
			throw new BusiException(AcctMgrError.getErrorCode("0000","00035"), "结束时间不能小于6个月以前的时间");
		} else if(endDate > Integer.parseInt(sCurDate)) {
			endDate = Integer.parseInt(sCurDate);
		}
		
		if(beginDate > Integer.parseInt(sCurDate)) {
			throw new BusiException(AcctMgrError.getErrorCode("0000","00036"), "开始时间不能大于当前时间");
		} else if(beginDate < Integer.parseInt(sBeforeDate)) {
			beginDate = Integer.parseInt(sBeforeDate);
		}
		
		//取用户信息
		long lIdNo = 0;
		UserInfoEntity uie = user.getUserInfo(phoneNo);
		lIdNo = uie.getIdNo();
		
		int monthNum = 0;
		int count = 0;
		//取缴费记录，最多取最近6个月的缴费记录
		for(int iOneYm=endDate/100; iOneYm>=beginDate/100; 
				iOneYm = Integer.valueOf(DateUtil.toStringMinusMonths(String.valueOf(iOneYm), 1, "yyyyMM"))) {
			
			inMap.clear();
			inMap.put("SUFFIX", String.valueOf(iOneYm));
			inMap.put("ID_NO", lIdNo);
			inMap.put("STATUS", "0");
			inMap.put("BEGIN_TIME", String.valueOf(beginDate)+" 00:00:00");
			inMap.put("END_TIME", String.valueOf(endDate)+" 23:59:59");
			inMap.put("DESC", "DESC");
			List<PayMentEntity> payMentList = record.getPayMentList(inMap);
			
			if(0 < payMentList.size()) {
				for(PayMentEntity pmeTemp :payMentList) {
					
					long payFee = pmeTemp.getPayFee();
					String opTime = pmeTemp.getOpTime();
					String loginNo = pmeTemp.getLoginNo();
					String groupId = pmeTemp.getGroupId();
					String payPath = pmeTemp.getPayPath();
					String payType = pmeTemp.getPayType();
					
					//update by zhanghp 20160623 
					String sPaySn = String.valueOf(pmeTemp.getPaySn());
					String sForeignSn = pmeTemp.getForeignSn();
					
					
					//取地市归属名称
					ChngroupRelEntity cgre = group.getRegionDistinct(groupId, "2", inDto.getProvinceId());
					String groupName =cgre.getRegionName();
					
					//取渠道名称
					String payPathName = control.getPaypathName(payPath);
					
					
					PayIntEntity payInt = new PayIntEntity();
					payInt.setPhoneNo(phoneNo);
					payInt.setOpTime(opTime);
					payInt.setPayMoney(String.valueOf(payFee));
					payInt.setLoginNo(loginNo);
					payInt.setGroupName(groupName);
					payInt.setPaypathName(payPathName);
					payInt.setPayType(payType);
					payInt.setPayTypeName(pmeTemp.getPayTypeName().trim());
					payInt.setPaySn(sPaySn);
					
					resultList.add(payInt);
					
					count++;
					
					if(count > 32) {
						break;
					}	
				}
			}
			
			monthNum++;
			
			if(count > 32 || monthNum >= 6) {
				break;
			}
		}
		
		if(resultList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8060","00001"), "缴费记录不存在！");
		}
		
		SPayQueryOutDTO outDto = new SPayQueryOutDTO();
		outDto.setPaymentList(resultList);
		
		return outDto;
	}
	
	@Override
	public OutDTO phonePayNew(InDTO inParam) {
		Map<String,Object> inMap = new HashMap<String,Object>();
		Map<String,Object> outMap = new HashMap<String,Object>();
		List<PayMentEntity> payMentList = new ArrayList<PayMentEntity>();
		
		SPhonePayNewInDTO inDto = (SPhonePayNewInDTO)inParam;
		String phoneNo = inDto.getPhoneNo();
		String beginDate = inDto.getBeginDate();
		String endDate = inDto.getEndDate();
		String broadBandPhone = inDto.getBroadBandPhone();
		
		if(StringUtils.isNotEmpty(broadBandPhone)&&StringUtils.isEmpty(phoneNo)){
			phoneNo=user.getPhoneNoByAsn(broadBandPhone, CommonConst.NBR_TYPE_KD);
		}
		
		UserInfoEntity uie = user.getUserInfo(phoneNo);
		long idNo = uie.getIdNo();
		long contractNo = uie.getContractNo();
		
		/**校验合帐分享主卡用户 **/
		int sharePay =0;
		sharePay=user.cntUserRel(idNo);
		
		List<PhonePayNewEntity> payList = new ArrayList<PhonePayNewEntity>();
		long payTimes=0;
		long payAll =0;
		long payedAll =0;
		long delayAll =0;
		
		int beginYm = Integer.parseInt(beginDate)/100;
		int endYm = Integer.parseInt(endDate)/100;
		while(beginYm<=endYm){
			if(sharePay>0){
				inMap.put("SUFFIX", String.valueOf(beginYm));
				inMap.put("CONTRACT_NO", contractNo);
				inMap.put("STATUS", "0");
				inMap.put("BEGIN_TIME", String.valueOf(beginDate)+" 00:00:00");
				inMap.put("END_TIME", String.valueOf(endDate)+" 23:59:59");
				inMap.put("DESC", "DESC");
				payMentList = record.getPayMentList(inMap);
			}
			else{
				inMap.put("SUFFIX", String.valueOf(beginYm));
				inMap.put("CONTRACT_NO", contractNo);
				inMap.put("ID_NO", idNo);
				inMap.put("STATUS", "0");
				inMap.put("BEGIN_TIME", String.valueOf(beginDate)+" 00:00:00");
				inMap.put("END_TIME", String.valueOf(endDate)+" 23:59:59");
				inMap.put("DESC", "DESC");
			    payMentList = record.getPayMentList(inMap);
			}
			
			if(0 < payMentList.size()) {
				for(PayMentEntity pmeTemp :payMentList) {
					String loginNo = pmeTemp.getLoginNo();
					String opCode = pmeTemp.getOpCode();
					long payMoney= pmeTemp.getPayFee();
					String payType =pmeTemp.getPayType();
					String townName = "";
					String payName = "";
					
					//取缴费地点
					if(loginNo.substring(0, 4).equals("ssss")||loginNo.substring(0, 5).equals("~~~~~")){
						LoginEntity le =login.getLoginInfo(loginNo, inDto.getProvinceId());
						townName = le.getLoginName();
					}else {
						outMap=group.getCurrentGroupInfo(pmeTemp.getGroupId(), inDto.getProvinceId());
						townName=outMap.get("GROUP_NAME").toString();
					}
					
					//取账本名称
					inMap.put("PAY_TYPE", payType);
					outMap=balance.getBookTypeDict(inMap);
					payName=outMap.get("PAY_TYPE_NAME").toString();
					
					/*TODO xl 根据客服需求 进行修改T专款的显示情况       待定*/
					String functionName="";
					if(payType.equals("T")){
						//TODO 模型待定
						
					}else if(opCode.equals("7004")){
						functionName="手机钱包";
					}else {
						functionName=base.getFunctionName(opCode);
					}
					
					//积分兑换话费支付展示
					if(pmeTemp.getPayMethod().equals("j")){
						payName = "10086积分兑换话费";
						functionName = "10086积分兑换话费";						
					}
					
					//取工号名称
					LoginEntity le= login.getLoginInfo(loginNo, inDto.getProvinceId());
					String loginName = le.getLoginName()+"||"+loginNo;
					
					//取支出金额
					long payedOwe = 0;
					long payedDelay = 0;
					//取该表缴费冲销费用
					inMap.put("SUFFIX", String.valueOf(beginYm));
					inMap.put("PAY_SN",	pmeTemp.getPaySn());
					inMap.put("CONTRACT_NO", pmeTemp.getContractNo());
					inMap.put("ID_NO", pmeTemp.getIdNo());
					inMap.put("PAY_TYPE", pmeTemp.getPayType());
					BookPayoutEntity bpe = balance.getPayOutFee(inMap);
					if(bpe==null){
						// 本次缴费无冲销欠费记录
						payedOwe = 0;
						payedDelay = 0;
					}else {
						payedOwe = bpe.getOutBalance();
						payedDelay = bpe.getDelayFee();
					}
					
					if((payMoney==0&&payedOwe==0&&payedDelay==0)||opCode.equals("7004")){
						continue;
					}
					
					//获取总和
					payTimes++;
					payAll=payAll+payMoney;
					payedAll=payedAll+payedOwe;
					delayAll = delayAll + payedDelay;
					
					PhonePayNewEntity ppne = new PhonePayNewEntity();
					ppne.setDelayOut(payedDelay);
					ppne.setFunctionName(functionName);
					ppne.setLoginAccept(pmeTemp.getPaySn());
					ppne.setLoginName(loginName);
					ppne.setOpTime(pmeTemp.getOpTime());
					ppne.setPayMoney(payMoney);
					ppne.setPayName(payName);
					ppne.setPayOut(payedOwe);
					ppne.setTownName(townName);					
					payList.add(ppne);
					
					if(payTimes==2000){
						break;
					}
					
					
				}
			}
			beginYm=DateUtils.AddMonth(beginYm, 1);
			log.info("beginYm===="+beginYm);
		}
		
		SPhonePayNewOutDTO outDto = new SPhonePayNewOutDTO();
		outDto.setDelayAll(delayAll);
		outDto.setPayAll(payAll);
		outDto.setPayedAll(payedAll);
		outDto.setPayList(payList);
		outDto.setPayTimes(payTimes);
		return outDto;
	}
	
	@Override
	public OutDTO payFlagQry(InDTO inParam) {
		Map<String,Object> inMap = new HashMap<String,Object>();

		SPayFlagQryInDTO inDto = (SPayFlagQryInDTO)inParam;
		String phoneNo = inDto.getPhoneNo();
		String sysDate = inDto.getSysDate();
		
		/*取当前年月*/
		int curYm = Integer.parseInt(DateUtil.format(new Date(), "yyyyMM"));
		
		//取默认账户
		UserInfoEntity uie = user.getUserInfo(phoneNo);
		long idNo = uie.getContractNo();
		long contractNo = uie.getContractNo();
		String groupId = uie.getGroupId();
		
		ChngroupRelEntity cgre = group.getRegionDistinct(groupId, "2", inDto.getProvinceId());
		String regionCode = cgre.getRegionCode().substring(2, 4);
		
		String loginNo = regionCode+"mpay";
		
		int minYm1 = Integer.parseInt(sysDate.substring(0, 6));
		String flagThirty="0";
		String flagFifty="0";
		String flagEighty="0";
		while(minYm1<=curYm) {
			int count=0;
			inMap.put("ID_NO", idNo);
			inMap.put("CONTRACT_NO", contractNo);
			inMap.put("SUFFIX", minYm1);
			inMap.put("LOGIN_NO", loginNo);
			inMap.put("FLAG", "30");
			count = record.getCntPayFlag(inMap);
			if(count>0){
				flagThirty="1";
				break;
			}
			minYm1 = DateUtils.AddMonth(minYm1, 1);
		}
		
		int minYm2 = Integer.parseInt(sysDate.substring(0, 6));
		while(minYm2<=curYm) {
			int count=0;
			inMap.put("ID_NO", idNo);
			inMap.put("CONTRACT_NO", contractNo);
			inMap.put("SUFFIX", minYm2);
			inMap.put("LOGIN_NO", loginNo);
			inMap.put("FLAG", "50");
			count = record.getCntPayFlag(inMap);
			if(count>0){
				flagFifty="1";
				break;
			}
			minYm2 = DateUtils.AddMonth(minYm2, 1);
		}
		
		int minYm3 = Integer.parseInt(sysDate.substring(0, 6));
		while(minYm3<=curYm) {
			int count=0;
			inMap.put("ID_NO", idNo);
			inMap.put("CONTRACT_NO", contractNo);
			inMap.put("SUFFIX", minYm3);
			inMap.put("LOGIN_NO", loginNo);
			inMap.put("FLAG", "80");
			count = record.getCntPayFlag(inMap);
			if(count>0){
				flagEighty="1";
				break;
			}
			minYm3 = DateUtils.AddMonth(minYm3, 1);
		}
		
		SPayFlagQryOutDTO outDto = new SPayFlagQryOutDTO();
		outDto.setFlagEighty(flagEighty);
		outDto.setFlagFifty(flagFifty);
		outDto.setFlagThirty(flagThirty);
		return outDto;
	}
	
	@Override
	public OutDTO pay1500Qry(InDTO inParam) {
		Map<String,Object> inMap = new HashMap<String,Object>();
		Map<String,Object> outMap = new HashMap<String,Object>();
		List<PayMentEntity> payMentList = new ArrayList<PayMentEntity>();
		
		SPay1500QryInDTO inDto = (SPay1500QryInDTO)inParam;
		String phoneNo = inDto.getPhoneNo();
		String beginDate = inDto.getBeginDate();
		String endDate = inDto.getEndDate();
		
		UserInfoEntity uie = user.getUserInfo(phoneNo);
		long idNo = uie.getIdNo();
		long contractNo = uie.getContractNo();
		
		/**校验合帐分享主卡用户 **/
		int sharePay =0;
		sharePay=user.cntUserRel(idNo);
		
		List<Pay1500QryEntity> payList = new ArrayList<Pay1500QryEntity>();
		long payTimes=0;
		
		int beginYm = Integer.parseInt(beginDate)/100;
		int endYm = Integer.parseInt(endDate)/100;
		while(beginYm<=endYm){
			if(sharePay>0){
				inMap.put("SUFFIX", String.valueOf(beginYm));
				inMap.put("CONTRACT_NO", contractNo);
				inMap.put("BEGIN_TIME", String.valueOf(beginDate)+" 00:00:00");
				inMap.put("END_TIME", String.valueOf(endDate)+" 23:59:59");
				inMap.put("DESC", "DESC");
				payMentList = record.getPayMentList(inMap);
			}
			else{
				inMap.put("SUFFIX", String.valueOf(beginYm));
				inMap.put("ID_NO", idNo);
				inMap.put("BEGIN_TIME", String.valueOf(beginDate)+" 00:00:00");
				inMap.put("END_TIME", String.valueOf(endDate)+" 23:59:59");
				inMap.put("DESC", "DESC");
			    payMentList = record.getPayMentList(inMap);
			}
			
			if(0 < payMentList.size()) {
				for(PayMentEntity pmeTemp :payMentList) {
					String loginNo = pmeTemp.getLoginNo();
					String opCode = pmeTemp.getOpCode();
					long payMoney= pmeTemp.getPayFee();
					String payType =pmeTemp.getPayType();
					String businessName = "";
					String townName = "";
					String payName = "";
					
					//取营业厅
					ChngroupRelEntity cgreb=group.getRegionDistinct(pmeTemp.getGroupId(), "4", inDto.getProvinceId());
					businessName=cgreb.getRegionName();
					
					//取区县
					ChngroupRelEntity cgret=group.getRegionDistinct(pmeTemp.getGroupId(), "3", inDto.getProvinceId());
					townName=cgret.getRegionName();
					
					//取账本名称
					inMap.put("PAY_TYPE", payType);
					outMap=balance.getBookTypeDict(inMap);
					payName=outMap.get("PAY_TYPE_NAME").toString();
					
					/*TODO xl 根据客服需求 进行修改T专款的显示情况       待定*/
					String functionName="";
					functionName=base.getFunctionName(opCode);
					
					//积分兑换话费支付展示
					if(pmeTemp.getPayMethod().equals("j")){
						payName = "积分兑换";
						functionName = "积分兑换";						
					}
					
					//取工号名称
					LoginEntity le= login.getLoginInfo(loginNo, inDto.getProvinceId());
					String loginName = le.getLoginName()+"||"+loginNo;
					
					//退费标志
					String backFlag="";
					if(pmeTemp.getStatus().equals("4") || pmeTemp.getStatus().equals("5")) {
						backFlag= "已退";
					} else {
						backFlag = "未退";
					}
					
					//取支出金额
					long payedOwe = 0;
					long payedDelay = 0;
					//取该表缴费冲销费用
					inMap.put("SUFFIX", String.valueOf(beginYm));
					inMap.put("PAY_SN",	pmeTemp.getPaySn());
					inMap.put("CONTRACT_NO", pmeTemp.getContractNo());
					inMap.put("ID_NO", pmeTemp.getIdNo());
					inMap.put("PAY_TYPE", pmeTemp.getPayType());
					BookPayoutEntity bpe = balance.getPayOutFee(inMap);
					if(bpe==null){
						// 本次缴费无冲销欠费记录
						payedOwe = 0;
						payedDelay = 0;
					}else {
						payedOwe = bpe.getOutBalance();
						payedDelay = bpe.getDelayFee();
					}
					
					if((payMoney==0&&payedOwe==0&&payedDelay==0)||opCode.equals("7004")){
						continue;
					}

					
					Pay1500QryEntity ppne = new Pay1500QryEntity();
					ppne.setDelayOut(payedDelay);
					ppne.setFunctionName(functionName);
					ppne.setLoginAccept(pmeTemp.getPaySn());
					ppne.setLoginName(loginName);
					ppne.setOpTime(pmeTemp.getOpTime());
					ppne.setPayMoney(payMoney);
					ppne.setPayName(payName);
					ppne.setPayOut(payedOwe);
					ppne.setTownName(townName);	
					ppne.setBackFlag(backFlag);
					ppne.setBusinessName(businessName);
					payList.add(ppne);
					
					if(payTimes==2000){
						break;
					}
					
					
				}
			}
			beginYm=DateUtils.AddMonth(beginYm, 1);
			log.info("beginYm===="+beginYm);
		}
		
		SPay1500QryOutDTO outDto = new SPay1500QryOutDTO();
		outDto.setPayList(payList);
		return outDto;
	}
	
	@Override
	public OutDTO mallPayQry(InDTO inParam) {
		Map<String,Object> inMap = new HashMap<String,Object>();
		Map<String,Object> outMap = new HashMap<String,Object>();
		List<PayMentEntity> payMentList = new ArrayList<PayMentEntity>();
		List<PayIntEntity> resultList = new ArrayList<PayIntEntity>();
		
		SMallPayQryInDTO inDto = (SMallPayQryInDTO)inParam;
		String phoneNo = inDto.getPhoneNo();
		String beginDate = inDto.getBeginDate();
		String endDate = inDto.getEndDate();
		String otherFlag = inDto.getOtherFlag();
		
		long contractNo=0;
		if(StringUtils.isNotEmptyOrNull(inDto.getContractNo())) {
			contractNo= Long.parseLong(inDto.getContractNo());
		}
		
		long idNo =0;
		if(otherFlag.equals("0")){
			UserInfoEntity uie = user.getUserInfo(phoneNo);
			idNo = uie.getIdNo();
			contractNo = uie.getContractNo();
			
			//判断分享主卡
			int cnt = user.cntUserRel(idNo);
			if(cnt>0){
				otherFlag="1";
			}
		}
		
		int beginYm = Integer.parseInt(beginDate)/100;
		int endYm = Integer.parseInt(endDate)/100;
		int payTimes=0;
		while(beginYm<=endYm){
			if(otherFlag.equals("1")){
				inMap.put("SUFFIX", String.valueOf(beginYm));
				inMap.put("CONTRACT_NO", contractNo);
				inMap.put("BEGIN_TIME", String.valueOf(beginDate)+" 00:00:00");
				inMap.put("END_TIME", String.valueOf(endDate)+" 23:59:59");
				inMap.put("DESC", "DESC");
				payMentList = record.getPayMentList(inMap);
			}else if(otherFlag.equals("0")){
				inMap.put("SUFFIX", String.valueOf(beginYm));
				inMap.put("ID_NO", idNo);
				inMap.put("CONTRACT_NO", contractNo);
				inMap.put("BEGIN_TIME", String.valueOf(beginDate)+" 00:00:00");
				inMap.put("END_TIME", String.valueOf(endDate)+" 23:59:59");
				inMap.put("DESC", "DESC");
			    payMentList = record.getPayMentList(inMap);
			}
			
			if(0 < payMentList.size()) {
				for(PayMentEntity pmeTemp :payMentList) {
					String loginNo = pmeTemp.getLoginNo();
					String opCode = pmeTemp.getOpCode();
					long payMoney= pmeTemp.getPayFee();
					String payType =pmeTemp.getPayType();
					String foreignSn = pmeTemp.getForeignSn();
					String payPath = pmeTemp.getPayPath();
					String payMethod = pmeTemp.getPayMethod();
					String payName = "";
					
					//取支出金额
					long payedOwe = 0;
					long payedDelay = 0;
					//取该表缴费冲销费用
					inMap.put("SUFFIX", String.valueOf(beginYm));
					inMap.put("PAY_SN",	pmeTemp.getPaySn());
					inMap.put("CONTRACT_NO", pmeTemp.getContractNo());
					inMap.put("ID_NO", pmeTemp.getIdNo());
					inMap.put("PAY_TYPE", pmeTemp.getPayType());
					BookPayoutEntity bpe = balance.getPayOutFee(inMap);
					if(bpe==null){
						// 本次缴费无冲销欠费记录
						payedOwe = 0;
						payedDelay = 0;
					}else {
						payedOwe = bpe.getOutBalance();
						payedDelay = bpe.getDelayFee();
					}
					
					if((payMoney==0&&payedOwe==0&&payedDelay==0)||opCode.equals("7004")){
						continue;
					}
					
					
					inMap.put("PAY_TYPE", payType);
					outMap = balance.getBookTypeDict(inMap);
					String sPayAttr = outMap.get("PAY_ATTR").toString();
					String transFlag = sPayAttr.substring(3, 4);
					
					/*参照集团网状网规范,匹配交费渠道*/
					String chnName = "";					
					if(payPath.equals("11")){
						chnName = "01"; /*01营业厅*/
					}else if(payPath.equals("05")) {
						chnName = "06"; /*06自助终端*/
					}else if(payPath.equals("19")) {
						chnName = "07"; /*07银行*/
					}else if(loginNo.equals("02")) {
						chnName = "02"; /*02网上营业厅*/
					}else if(loginNo.equals("04")) {
						chnName = "04"; /*04短信营业厅*/
					}else {
						chnName = "99";/*99其他*/
					}
					
					if(payMethod.equals("B")) {
						chnName = "08"; /*08空中充值*/
					}
					
					if(StringUtils.isNotEmptyOrNull(foreignSn)&&!foreignSn.equals("0")) {
						String totalPath = "";
						totalPath = balance.getTotalPayPath(beginYm, foreignSn);
						if(StringUtils.isNotEmptyOrNull(totalPath)) {
							if(totalPath.equals("07")) {
								chnName = "09";/*09移动商城*/
							}else if(totalPath.equals("69")) {
								chnName = "05";/*05手机营业厅*/
							}else if(totalPath.equals("09")) {
								chnName = "03";/*03掌上营业厅*/
							}
						}
					}
					
					/*参照集团网状网规范,匹配交费方式、交费方式名称*/
					if(payType.equals("0")){
						payType="01";
						payName = "现金交费";
					}else if(payType.equals("d")){
						payType="12";
						payName = "二卡合一";
					}else if(payType.equals("4")){
						payType="03";
						payName = "银行托收";
					}else if(payType.equals("1")){
						payType="06";
						payName = "第三方支付（手机支付、联动优势等）";
					}else if(payType.equals("AR")){
						payType="07";
						payName = "手机钱包";
					}else if(payType.equals("Y")){
						payType="08";
						payName = "空中充值";
					}else {
						if(transFlag.equals("0")){
							payType="04";
							payName = "营销活动预存受理";
						}else {
							payType="12";
							payName = "其它";
						}						
					}
					
					if(pmeTemp.getPayMethod().equals("j")){
						payName = "积分换话费业务受理";
						payType="05";					
					}
					
					payTimes++;
					if(payTimes==2000){
						break;
					}
					
					PayIntEntity pie = new PayIntEntity();
					pie.setLoginNo(loginNo);
					pie.setOpTime(pmeTemp.getOpTime());
					pie.setPayMoney(String.valueOf(payMoney));
					pie.setPaypathName(chnName);
					pie.setPaySn(String.valueOf(pmeTemp.getPaySn()));
					pie.setPayType(payType);
					pie.setPayTypeName(payName);
					pie.setPhoneNo(phoneNo);
					resultList.add(pie);
				}
			}
			beginYm=DateUtils.AddMonth(beginYm, 1);
		}
		
		SMallPayQryOutDTO outDto = new SMallPayQryOutDTO();
		outDto.setPaymentList(resultList);
		return outDto;
		
	}
	
	@Override
	public OutDTO backPayQry(InDTO inParam) {
		List<BatchpayInfoEntity> resultList = new ArrayList<BatchpayInfoEntity>();
		SBackPayQryInDTO inDto = (SBackPayQryInDTO)inParam;
		String phoneNo = inDto.getPhoneNo();
		String beginDate = inDto.getBeginDate();
		String endDate = inDto.getEndDate();
		
		UserInfoEntity uie = user.getUserInfo(phoneNo);
		long idNo = uie.getIdNo();
		long contractNo = uie.getContractNo();
		
		int beginYm = Integer.parseInt(beginDate.substring(0, 6));
		int endYm = Integer.parseInt(endDate.substring(0, 6));
		long payAll = 0;
		while(beginYm<=endYm){
			List<BatchpayInfoEntity> tempList = record.getBatchPayInfo(contractNo, idNo, beginYm);
			ListIterator li = tempList.listIterator();
			while(li.hasNext()){
				BatchpayInfoEntity bpie = (BatchpayInfoEntity)li.next();
				payAll = payAll+bpie.getPayFee();
				resultList.add(bpie);
			}
			beginYm = DateUtils.AddMonth(beginYm, 1);
		}
		
		SBackPayQryOutDTO outDto = new SBackPayQryOutDTO();
		outDto.setResultList(resultList);
		outDto.setPayAll(payAll);
		return outDto;
	}
	
	@Override
	public OutDTO payCardQry(InDTO inParam) {
		List<PayCardQryEntity> resultList = new ArrayList<PayCardQryEntity>();
		SPayCardQryInDTO inDto = (SPayCardQryInDTO)inParam;
		String phoneNo = inDto.getPhoneNo();
		String beginTime = inDto.getBeginTime();
		String endTime = inDto.getEndTime();
		
		UserInfoEntity uie = user.getUserInfo(phoneNo);
		long idNo = uie.getIdNo();
		String groupId = uie.getGroupId();
		
		//取地市
		ChngroupRelEntity crre = group.getRegionDistinct(groupId, "2", inDto.getProvinceId());
		String regionName = "黑龙江"+crre.getRegionName();
		
		String payChannel = "充值卡";
		
		int beginYm = Integer.parseInt(beginTime.substring(0, 6));
		int endYm = Integer.parseInt(endTime.substring(0, 6));
		while(beginYm<=endYm) {
			Map<String,Object> inMap = new HashMap<String,Object>();
			inMap.put("DEAL_MONTH", String.valueOf(beginYm).substring(4, 6));
			inMap.put("ID_NO", idNo);
			inMap.put("BEGIN_DAY", beginTime.substring(0, 8));
			inMap.put("END_DAY", endTime.substring(0, 8));
			List<PayCardEntity> tempList= record.getPayCardList(inMap);
			for(PayCardEntity pce :tempList) {
				PayCardQryEntity pcqe = new PayCardQryEntity();
				
				String cardNumber = "";
				long paySn = pce.getPaySn();
				if(paySn>=Long.parseLong("30000000000000")) {
					Map<String,Object> inMap1 = new HashMap<String,Object>();
					inMap.put("PAY_SN", paySn);
					List<PayMentEntity>  paymentList = record.getPayMentList(inMap1);
					if(paymentList.size()>0) {
						PayMentEntity pme = paymentList.get(0);
						String foreignSn = pme.getForeignSn();
						cardNumber = foreignSn.substring(15);
					}
				}else {
					cardNumber = pce.getCardSn();
				}
				
				pcqe.setCardNumber(cardNumber);
				pcqe.setOpTime(String.valueOf(pce.getTotalDate()));
				pcqe.setPayChannel(payChannel);
				pcqe.setPhoneNo(phoneNo);
				pcqe.setRegionName(regionName);
				resultList.add(pcqe);
			}
			
			beginYm = DateUtils.AddMonth(beginYm, 1);
		}
		
		SPayCardQryOutDTO outDto = new SPayCardQryOutDTO();
		outDto.setPayCardList(resultList);
		return outDto;
	}
	
	@Override
	public OutDTO wxPayQry(InDTO inParam) {
		List<WxPayEntity> paymentList = new ArrayList<WxPayEntity>();
		SWxPayQryInDTO inDto = (SWxPayQryInDTO)inParam;
		String phoneNo = inDto.getPhoneNo();
		
		String curDate = DateUtil.format(new Date(), "yyyy-MM-dd");
		
		UserInfoEntity uie = user.getUserInfo(phoneNo);
		String groupId = uie.getGroupId();
		
		ChngroupRelEntity cgre = group.getRegionDistinct(groupId, "2", inDto.getProvinceId());
		String regionName = cgre.getRegionName();
		
		MBean inBean = new MBean();
		inBean.setBody("phoneNo=", phoneNo);    
		Map<String, String> result = CrossEntity.callService("EAI_WX_PAY", inBean);
		log.info("调用PD充值接口返回： " + result);
		String retn = result.get("resCode").toString();  //充值结果代码
		
		int retCode = Integer.parseInt(retn);
		if (retCode != 0) {
			log.error("接口返回失败!");
			throw new BusiException(AcctMgrError.getErrorCode("0000", "12004"),
					"接口返回失败!");
		}
		
		String status = result.get("status").toString();
		String charge = result.get("charge").toString();
		String payTime = result.get("payTime").toString();
		String instancePrice = result.get("instancePrice").toString();
		String chargeStatus = result.get("chargestatus").toString();
		String chargeSeq = result.get("chargeseq").toString();

		String[] statusArray=status.split("\\|");
		String[] payTimeArray=payTime.split("\\|");
		String[] SeqArray=chargeSeq.split("\\|");
		String[] chargeArray=charge.split("\\|");
		String[] instanceArray=instancePrice.split("\\|");
		String[] chargeStatusArray=chargeStatus.split("\\|");
		String statusDesc = "";
		for(int i=0;i<statusArray.length;i++) {
			if(payTimeArray[i].substring(0, 10).equals(curDate)&&!SeqArray[i].isEmpty()) {
				long paySn = Long.parseLong(SeqArray[i]);
				List<PayCardEntity> list = new ArrayList<PayCardEntity>();
				list = record.getPayCardList(null, paySn, null);
				if(list.size()>0) {
					statusArray[i]="3";
					chargeStatusArray[i]="11";
				}
			}else {
				if(statusArray[i].equals("3")&&chargeStatusArray[i].equals("11")) {
					continue;
				}
			}
			
			status = statusArray[i];
			chargeStatus = chargeStatusArray[i];
			switch(Integer.parseInt(status)) {
				case 3:
					if(chargeStatus.equals("11")) {
						statusDesc = "充值成功";
					}else if(chargeStatus.equals("10")) {
						statusDesc = "付款成功，话费充值失败，系统正在重试";
					}else if(chargeStatus.equals("12")) {
						statusDesc = "客户付款成功，话费充值中";
					}
				break;
				case 2:
					statusDesc = "客户付款中";
				break;
				case 4:
					statusDesc = "客户付款失败";
				break;
				default:
					statusDesc = "未知状态";
			}

			WxPayEntity wxpe = new WxPayEntity();
			wxpe.setOrderMoney(instanceArray[i]);
			wxpe.setPayMoney(chargeArray[i]);
			wxpe.setPayTime(payTimeArray[i].substring(0, 16));
			wxpe.setStatus(statusDesc);
			paymentList.add(wxpe);
			
		}
		
		SWxPayQryOutDTO outDto = new SWxPayQryOutDTO();
		outDto.setPaymentList(paymentList);
		return outDto;
		
	}

	/**
	 * @return the user
	 */
	public IUser getUser() {
		return user;
	}

	/**
	 * @param user the user to set
	 */
	public void setUser(IUser user) {
		this.user = user;
	}

	/**
	 * @return the record
	 */
	public IRecord getRecord() {
		return record;
	}

	/**
	 * @param record the record to set
	 */
	public void setRecord(IRecord record) {
		this.record = record;
	}

	/**
	 * @return the group
	 */
	public IGroup getGroup() {
		return group;
	}

	/**
	 * @param group the group to set
	 */
	public void setGroup(IGroup group) {
		this.group = group;
	}

	/**
	 * @return the control
	 */
	public IControl getControl() {
		return control;
	}

	/**
	 * @param control the control to set
	 */
	public void setControl(IControl control) {
		this.control = control;
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
	 * @return the balance
	 */
	public IBalance getBalance() {
		return balance;
	}

	/**
	 * @param balance the balance to set
	 */
	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	/**
	 * @return the base
	 */
	public IBase getBase() {
		return base;
	}

	/**
	 * @param base the base to set
	 */
	public void setBase(IBase base) {
		this.base = base;
	}
	
}