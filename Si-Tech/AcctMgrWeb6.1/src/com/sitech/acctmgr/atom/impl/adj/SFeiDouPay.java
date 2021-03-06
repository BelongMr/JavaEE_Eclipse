package com.sitech.acctmgr.atom.impl.adj;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.adj.inter.IAdjCommon;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.ITransType;
import com.sitech.acctmgr.atom.busi.pay.trans.TransFactory;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.account.ContractDeadInfoEntity;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.adj.AdjBIllEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserDeadEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserPrcEntity;
import com.sitech.acctmgr.atom.dto.pay.SFeiDouPayCfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.SFeiDouPayCfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.SFeiDouPayCheckInDTO;
import com.sitech.acctmgr.atom.dto.pay.SFeiDouPayCheckOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IAdj;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IProd;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgr.inter.adj.IFeiDouPay;
import com.sitech.acctmgrint.atom.busi.intface.IShortMessage;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

/**
*
* <p>Title:   </p>
* <p>Description:   </p>
* <p>Copyright: Copyright (c) 2016</p>
* <p>Company: SI-TECH </p>
* @author liuyc_billing
* @version 1.0
*/
@ParamTypes({ @ParamType(m = "check", c = SFeiDouPayCheckInDTO.class, oc = SFeiDouPayCheckOutDTO.class),
    		  @ParamType(m = "cfm", c = SFeiDouPayCfmInDTO.class, oc = SFeiDouPayCfmOutDTO.class)})
public class SFeiDouPay extends AcctMgrBaseService implements IFeiDouPay {

	private IUser user;
	private IControl control;
	private IRemainFee remainFee;
	private IAdj adj;
	private IAdjCommon adjCommon;
	private IBill bill;
	private IRecord record;
	private IBalance balance;
	private IProd prod;
	private TransFactory transFactory;
	private IPayManage payManage;
	private IAccount account;
	private IGroup group;
	private IShortMessage shortMessage;

	
	/* (non-Javadoc)
	 * @see com.sitech.acctmgr.inter.pay.IFeiDouPay#check(com.sitech.jcfx.dt.in.InDTO)
	 */
	@Override
	public OutDTO check(InDTO inParam) {
		// TODO Auto-generated method stub
		/* 入参 */
		
		ITransType transType;// 转账类型
		SFeiDouPayCheckInDTO inDTO = (SFeiDouPayCheckInDTO) inParam;
		log.info("SFeiDouPay check入参--> " + inDTO.getMbean());

		String optSeq = inDTO.getOptSeq(); // 操作流水
		String bussType = inDTO.getBussType(); // 交易类型
		String phoneNo = inDTO.getPhoneNo(); // 手机号码
		String sysplatId = inDTO.getSysplatId(); // 平台标识号 平台标识号 1-飞信 2-139邮箱 3-MM
		String province = inDTO.getProvince(); // 用户归属机构
		String sessionId = inDTO.getSessionId(); // 集团报文头业务流水号
		String reqDate = inDTO.getReqDate(); // 请求时间
		String loginNo = inDTO.getLoginNo(); // 工号
		long servId = inDTO.getServId(); // 用户标识
		long payAccid = inDTO.getPayAccid(); // 支付帐户标识
		long chargeSum = inDTO.getChargeSum(); // 充值金额
		int unit = inDTO.getUnit(); // 货币单位单位 0:人民币
		String provinceId = inDTO.getProvinceId();
		String groupId = inDTO.getGroupId();
		
		if (StringUtils.isEmptyOrNull(loginNo)) {
            loginNo = "system";
        }
		
		/* 校验飞豆平台账号和手机号码绑定关系 */
		/*outCheckMap = feiDou.getFlyUserInfo(phoneNo);
		log.info("飞豆用户信息:" + outCheckMap.toString());*/

		/* 取用户默认账户 */
		UserInfoEntity userEnt = user.getUserInfo(phoneNo);
		long contractNo = userEnt.getContractNo();
		
		log.info("用户默认账户 :" + contractNo);
		
		/*判断用户状态，不正常，不允许办理*/
		if(!userEnt.getRunCode().equals("A")){
			throw new BusiException(AcctMgrError.getErrorCode("8073","00001"), "用户状态不正常!");
		}
			
		//GH转账所需参数
		String opType = "TransAccountEnt";
		String opNote = "GH专款";
		
		/* 创建转账类型 */
		transType = transFactory.createTransFactory(opType,true);
		
		/* 取账户可转预存 */
		long transFeeTmp = transType.getTranFee(contractNo);
		log.info("可转预存:" + transFeeTmp);

		/*计算用户的账户余额*/
		long remainFeeTmp =  remainFee.getConRemainFee(contractNo).getRemainFee();

		if (remainFeeTmp < chargeSum ) {
			log.error("用户可用余额不足:[" + contractNo + "][" + remainFeeTmp + "]");
			throw new BusiException(AcctMgrError.getErrorCode("8073", "00002"),
					"用户可用余额不足!");
		}
		
		log.info("用户余额:[" + contractNo + "][" + remainFeeTmp + "]");
		
		/*可转余额判断*/
		long transFee = remainFeeTmp < transFeeTmp ? remainFeeTmp : transFeeTmp ;
	
		/* 获取当前日期 */
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String totalDate = curTime.substring(0, 8);
		String curYM = curTime.substring(0, 6);
		
		/* 转账账户基本信息查询 */
		PayUserBaseEntity inTransBaseInfo= getUserBaseInfo(phoneNo, contractNo, true, provinceId);
		inTransBaseInfo.setNetFlag(true);

		
		/*可转余额校验 */
		long changeFee = transType.getTranFee(contractNo);
		
		log.info("----> lChangeFee -" + changeFee + ", lTransFee -" + transFee);
		
		if (transFee > changeFee) {
			log.error("------>可转金额小于转账金额, lChangeFee -" + changeFee + ", lTransFee -" + transFee);
			throw new BaseException(AcctMgrError.getErrorCode("8073", "00003"), "可转金额小于转账金额!");
		}
		
		/*个性化业务信息验证*/
		Map<String, Object> checkMap = new HashMap<String, Object>();
		checkMap.put("IN_TRANS_BASEINFO", inTransBaseInfo);
		checkMap.put("OUT_TRANS_BASEINFO", inTransBaseInfo);
		checkMap.put("CONTRACTNO_OUT", contractNo);
		checkMap.put("TRANS_FEE", transFee);
		transType.checkCfm(checkMap);
				
		/*各种转账类型备注信息*/
		opNote = transType.getOpNote(opNote);
	
		/*入账实体设值*/
		PayBookEntity bookIn = new PayBookEntity();
		bookIn.setBeginTime(curTime);
		bookIn.setForeignSn(optSeq);
		bookIn.setGroupId(groupId);
		bookIn.setLoginNo(loginNo);
		bookIn.setOpCode("8073");
		bookIn.setOpNote(opNote);
		bookIn.setPayFee(chargeSum);
		bookIn.setPayMethod("0");
		bookIn.setPayPath("98");
		bookIn.setTotalDate(Integer.parseInt(totalDate));
		bookIn.setYearMonth(Long.parseLong(curYM));

		Map<String, Object> inTransCfmMap = new HashMap<String, Object>();
		safeAddToMap(inTransCfmMap, "Header", inDTO.getHeader());
		safeAddToMap(inTransCfmMap, "TRANS_TYPE_OBJ", transType); //转账类型实例化对象
		safeAddToMap(inTransCfmMap, "TRANS_IN", inTransBaseInfo);  //转入账户基本信息
		safeAddToMap(inTransCfmMap, "TRANS_OUT", inTransBaseInfo); //转出账户基本信息
		safeAddToMap(inTransCfmMap, "BOOK_IN", bookIn); //入账实体
		safeAddToMap(inTransCfmMap, "OP_TYPE", opType); //转账类型
		safeAddToMap(inTransCfmMap, "IN_PAY_TYPE", "GH"); //转账类型
		
		/*转账*/
		long paySn = payManage.transBalance(inTransCfmMap);
		
		/* 取操作流水 */
		long busiSn = control.getSequence("SEQ_SYSTEM_SN");

		/* 记录bal_grpfdbusi_recd表 */
		Map<String, Object> inCheckMap = new HashMap<String, Object>();
		inCheckMap.put("BUSI_SN", busiSn);
		inCheckMap.put("OPT_SEQ", optSeq);
		inCheckMap.put("PAY_TYPE", "GH"); //GH:飞豆支付专款账本
		inCheckMap.put("PHONE_NO", phoneNo);
		inCheckMap.put("SYSPLAT_ID", sysplatId);
		inCheckMap.put("PROVINCE", province);
		inCheckMap.put("SESSION_ID", sessionId);
		inCheckMap.put("REQ_DATE", reqDate);
		inCheckMap.put("SERV_ID", servId);
		inCheckMap.put("PAY_ACCID", payAccid);
		inCheckMap.put("CHARGE_SUM", chargeSum);
		inCheckMap.put("UNIT", unit);
		inCheckMap.put("STATUS", "0"); // 二次确认短信下发时是status为0; 当扣费成功时, 更新status为1
		inCheckMap.put("BAK_2", bussType);
		adj.insertFDBusiRecd(inCheckMap);

		/* 下发二次确认短信 */
		/* 短信内容：您好！您将购买中国移动的飞豆，资费%.2f元，请在24小时内回复“是”确认订购，回复其他内容和不回复则不订购。中国移动 */
		Map<String, Object> mapTmp  = new HashMap<String, Object>();
		mapTmp.put("FEE", ValueUtils.transFenToYuan(chargeSum));

		MBean inMessage = new MBean();
		inMessage.addBody("TEMPLATE_ID", "31320042");
		inMessage.addBody("PHONE_NO", phoneNo);
		inMessage.addBody("LOGIN_NO", loginNo);
		inMessage.addBody("OP_CODE", "8073");
		inMessage.addBody("CHECK_FLAG", true);
		inMessage.addBody("SEND_FLAG", 0);
		inMessage.addBody("SEND_SEQ", optSeq);  // 飞豆二次短信需要填这个字段，供miso取
		inMessage.addBody("DATA", mapTmp);

		log.info("发送短信内容：" + inMessage.toString());
		

		//TODO
//		boolean flag = shortMessage.sendSmsMsg(inMessage);
//		log.info("短信发送是否成功: [" + flag + "]");

		SFeiDouPayCheckOutDTO outDto = new SFeiDouPayCheckOutDTO();
		outDto.setOptSeq(optSeq);
		outDto.setSysplatId(sysplatId);
		outDto.setPayAccid(payAccid);
		outDto.setServId(servId);
		outDto.setReqDate(reqDate);

		log.info("SFeiDouPay check出参--> " + outDto.toJson());
		
		return outDto;
	}
	
	
	// 获取用户基本信息 ,参考8041服务的方法
	private PayUserBaseEntity getUserBaseInfo(String inPhoneNo, 
			long inContractNo, boolean isTransInFlag, String provinceId) {
		String phoneNo = inPhoneNo;
		long contractNo = inContractNo;
		String conGroup="";
		
		log.info("getUserBaseInfo-->phoneNo:"+phoneNo+",contractNo"+ contractNo);
		
		long idNo = 0;
		String brandId = "";

		if (isTransInFlag) {
			/* 获取用户信息 */
			UserInfoEntity  userEntity = user.getUserInfo(phoneNo);
			idNo = userEntity.getIdNo();
			if (contractNo == 0) {
				contractNo = userEntity.getContractNo();
			}
			brandId = userEntity.getBrandId();

			/*获取账户信息*/
			ContractInfoEntity conEntity = account.getConInfo(inContractNo);
			conGroup=conEntity.getGroupId();
		} else {
			/** 离网用户信息查询 */
			List<UserDeadEntity> userDeadList = user.getUserdeadEntity(phoneNo, null, contractNo);
			idNo = userDeadList.get(0).getIdNo();
			
			/*获取离网用户品牌信息*/
			brandId = "XX";
			
			/* 获取账户信息 */
			ContractDeadInfoEntity conEntity = account.getConDeadInfo(contractNo);
			conGroup=conEntity.getGroupId();
		}

		//查询账户地市归属信息
		ChngroupRelEntity groupEntity = group.getRegionDistinct(conGroup, "2", provinceId);
		String regionId = groupEntity.getRegionCode();
		
		// 出参信息
		PayUserBaseEntity userBaseInfo = new PayUserBaseEntity();
		userBaseInfo.setBrandId(brandId);
		userBaseInfo.setContractNo(contractNo);
		userBaseInfo.setIdNo(idNo);
		userBaseInfo.setPhoneNo(phoneNo);
		userBaseInfo.setRegionId(regionId);
		userBaseInfo.setUserGroupId(conGroup);
		return userBaseInfo;
	}
	
	
	

	/* (non-Javadoc)
	 * @see com.sitech.acctmgr.inter.pay.IFeiDouPay#cfm(com.sitech.jcfx.dt.in.InDTO)
	 */
	@Override
	public OutDTO cfm(InDTO inParam) {
		// TODO Auto-generated method stub
		/* 入参 */
		SFeiDouPayCfmInDTO inDTO = (SFeiDouPayCfmInDTO) inParam;
		log.debug("SFeiDouPay cfm入参--> " + inDTO.getMbean());

		String phoneNo = inDTO.getPhoneNo();
		String optSeq = inDTO.getOptSeq();
		String loginNo = inDTO.getLoginNo();
		String smsContent = inDTO.getSmsContent();
		String provinceId = inDTO.getProvinceId();
		String groupId = inDTO.getGroupId();
		String opCode = "8073";
		
		Map<String,Object> header = new HashMap<String,Object>();
		header = ((SFeiDouPayCfmInDTO) inParam).getHeader();
		
		
	/*	//记录营业员操作记录表
        LoginOprEntity loginOprEnt = new LoginOprEntity();
        loginOprEnt.setBrandId(userBase.getBrandId());
        loginOprEnt.setIdNo(userBase.getIdNo());
        loginOprEnt.setLoginGroup(groupId);
        loginOprEnt.setLoginNo(loginNo);
        loginOprEnt.setLoginSn(payAccept);
        loginOprEnt.setOpCode(opCode);
        loginOprEnt.setOpTime(curTime);
        loginOprEnt.setPayFee(chargeSum);
        loginOprEnt.setPhoneNo(phoneNo);
        loginOprEnt.setRemark("飞豆充值");
        loginOprEnt.setPayType("0");
        loginOprEnt.setTotalDate(Long.parseLong(totalDate));
        record.saveLoginOpr(loginOprEnt);*/
		
		long payAccept = 0L;
		long servId = 0L;
		long payAccid = 0L;
		long payMoney = 0L;
		String sysplatId = "";
		
		Map<String,Object> outMap = new HashMap<String,Object>();
		
		try{
			outMap = doRealFDPay(phoneNo,optSeq,loginNo,smsContent,provinceId,groupId,header);
			
			payAccept = Long.parseLong(outMap.get("PAY_ACCEPT").toString());
			servId = Long.parseLong(outMap.get("SERV_ID").toString());
			payAccid = Long.parseLong(outMap.get("PAY_ACCID").toString());
			payMoney = Long.parseLong(outMap.get("PAY_MONEY").toString());
			sysplatId = outMap.get("SYSPLAT_ID").toString();
			
		}catch(BaseException e){
			e.printStackTrace();
			//发送失败短信,并继续抛出异常供JCF处理
			payManage.rollback();
			sendpayMsg(phoneNo,payMoney,loginNo,opCode,false);
			//将前面出发送短信的的事务全部回滚
			payManage.commit();
			throw new BaseException(e);
		}
		
		
		//发送成功短信
		sendpayMsg(phoneNo,payMoney,loginNo,opCode,true);
		
		SFeiDouPayCfmOutDTO outDto = new SFeiDouPayCfmOutDTO();
		outDto.setPayAccept(payAccept);
		outDto.setServId(servId);
		outDto.setPayAccid(payAccid);
		outDto.setSysplatId(sysplatId);
		
		log.info("SFeiDouPay cfm出参--> " + outDto.toJson());

		return outDto;
	}
	
	
	//真正的飞豆进行充值并扣费
	private Map doRealFDPay(String phoneNo,String optSeq,String loginNo,
			String smsContent,String provinceId,String groupId,Map header){
		
		/* 判断用户短信内容 */
		if (!smsContent.equals("是")) {
			log.error("短信内容不匹配" + smsContent);
			throw new BusiException(AcctMgrError.getErrorCode("8073", "00006"),
					"用户短信内容不匹配");
		}

		/* 查询用户是否存在 */
		UserInfoEntity userEnt = user.getUserInfo(phoneNo);
		long contractNo = userEnt.getContractNo();
		
		log.info("用户账户 : [" + contractNo + "]");
		
		/* 取用户办理飞豆业务信息 */
		Map<String, Object>inCfmMap = new HashMap<String, Object>();
		Map<String, Object> outCfmMap = new HashMap<String, Object>();
		inCfmMap.put("OPT_SEQ", optSeq);
		inCfmMap.put("PHONE_NO", phoneNo);
		//1为飞豆记录历史表，0为飞豆记录表
		inCfmMap.put("STATUS", "0");
		outCfmMap = adj.getFDBusiRecd(inCfmMap);
		// String optSeq = outCfmMap.get("OPT_SEQ").toString();
		String payType = outCfmMap.get("PAY_TYPE").toString();
		String sysplatId = outCfmMap.get("SYSPLAT_ID").toString();
		String reqDate = outCfmMap.get("REQ_DATE").toString();
		long servId = Long.valueOf(outCfmMap.get("SERV_ID").toString());
		long payAccid = Long.valueOf(outCfmMap.get("PAY_ACCID").toString());
		long chargeSum = Long.valueOf(outCfmMap.get("CHARGE_SUM").toString());
		int unit = Integer.valueOf(outCfmMap.get("UNIT").toString());
		
		
		/* 取系统时间 */
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String totalDate = curTime.substring(0, 8);
		String yearMonth=String.format("%6s", curTime.substring(0, 6));//当前年月

		
		//取账户 GH 专款预存
		Map inBalanceMap = new HashMap();
		inBalanceMap.put("CONTRACT_NO", contractNo);
		inBalanceMap.put("PAY_TYPE", "GH");
		long ghBookFee = balance.getAcctBookSumByMap(inBalanceMap);
		
		if (ghBookFee - chargeSum < 0) {
			log.info("账户["+contractNo+"]GH余额不足");
			throw new BusiException(AcctMgrError.getErrorCode("8073", "00007"),
					"账户["+contractNo+"]GH余额不足，请充值后办理！");
		}
		
		/*取用户主资费*/
        //取用户主产品
        UserPrcEntity userPrcEnt = prod.getUserPrcidInfo(userEnt.getIdNo());
        String prodPrcid = userPrcEnt.getProdPrcid();
		
		//飞豆账目项
		String acctItemCode = "0B20000002";
		
		String remark = "飞豆充值";
		String opCode = "8073";

		/* 更新记录表 */
		inCfmMap = new HashMap<String, Object>();
		inCfmMap.put("PHONE_NO", phoneNo);
		inCfmMap.put("SERV_ID", servId);
		inCfmMap.put("PAY_ACCID", payAccid);
		inCfmMap.put("SYSPLAT_ID", sysplatId);
		inCfmMap.put("REQ_DATE", reqDate);
		inCfmMap.put("STATUS", "1"); // 将记录更新成 1
		adj.updateFDBusiRecd(inCfmMap);
		
		/* 取操作流水 */
		long payAccept = control.getSequence("SEQ_SYSTEM_SN");

		log.info("## 调用小额支付接口 begin");
		/*TODO 调用小额支付接口 */
		inCfmMap = new HashMap<String, Object>();
		inCfmMap.put("PHONE_NO", phoneNo);
		inCfmMap.put("OP_CODE", opCode);
		inCfmMap.put("COST_TYPE", "0000");
		inCfmMap.put("COST_TIME", totalDate);
		inCfmMap.put("COST_FEE", chargeSum);
		inCfmMap.put("LOGIN_ACCEPT", payAccept);
		
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
        billEnt.setShouldPay(chargeSum);
        billEnt.setBillDay(billDay);

        //入账实体设值
        PayBookEntity inBook =  new PayBookEntity();
        inBook.setGroupId(groupId);
        inBook.setLoginNo(loginNo);
        inBook.setOpCode(opCode);
        inBook.setOpNote(remark);
        inBook.setPaySn(payAccept);
        
        //补收核心函数
        inAdjMap = new HashMap<String, Object>();
        inAdjMap.put("Header", header);
        inAdjMap.put("PAY_BOOK_ENTITY", inBook);
        inAdjMap.put("ADJ_BILL_ENTITY", billEnt);
        inAdjMap.put("PAY_USER_BASE_ENTITY", userBase);
        inAdjMap.put("PROVINCE_ID", provinceId);
        inAdjMap.put("BILL_ID", 0L);

        Map<String, Object> outParamMap = adjCommon.MicroAdj(inAdjMap);
		log.info("## 调用小额支付接口 end");
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("PAY_ACCEPT", payAccept);
		resultMap.put("SERV_ID", servId);
		resultMap.put("PAY_ACCID", payAccid);
		resultMap.put("SYSPLAT_ID", sysplatId);
		resultMap.put("PAY_MONEY", chargeSum);
		
		return resultMap;
	}
	
	
	//发送提示短信
	private void sendpayMsg(String phoneNo, long payMoney, String loginNo, String opCode,boolean success){
		
		Map<String, Object> mapTmp = new HashMap<String, Object>();
		MBean inMessage = new MBean();
		
		if(success){
			//BOSS_9210: 您好！您已成功购买【中国移动】的飞豆，资费${mach_fee}元。【中国移动】${sms_release}
			mapTmp.put("mach_fee", ValueUtils.transFenToYuan(payMoney));
			mapTmp.put("sms_release","");
			inMessage.addBody("TEMPLATE_ID", "311200807302");
			
		}else{
			//BOSS_9211: 您好！您未成功购买【中国移动】的飞豆。【中国移动】${sms_release}
			mapTmp.put("msg", "您好！您未成功购买【中国移动】的飞豆。【中国移动】");
			inMessage.addBody("TEMPLATE_ID", "311200000001");
		}
		
		inMessage.addBody("PHONE_NO", phoneNo);
		inMessage.addBody("LOGIN_NO", loginNo);;
		inMessage.addBody("OP_CODE", opCode);
		inMessage.addBody("CHECK_FLAG", true);
		inMessage.addBody("DATA", mapTmp);
		
		String flag = control.getPubCodeValue(2011, "DXFS", null);  // 0:直接发送 1:插入短信接口临时表 2：外系统有问题，直接不发送短信
		if(flag.equals("0")){
			inMessage.addBody("SEND_FLAG", 0);
		}else if(flag.equals("1")){
			inMessage.addBody("SEND_FLAG", 1);
		}else if(flag.equals("2")){
			return;
		}
		log.info("发送短信内容：" + inMessage.toString());
		shortMessage.sendSmsMsg(inMessage, 1);
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
	 * @return the remainFee
	 */
	public IRemainFee getRemainFee() {
		return remainFee;
	}

	/**
	 * @param remainFee the remainFee to set
	 */
	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}

	/**
	 * @return the adj
	 */
	public IAdj getAdj() {
		return adj;
	}

	/**
	 * @param adj the adj to set
	 */
	public void setAdj(IAdj adj) {
		this.adj = adj;
	}
	
	/**
	 * 
	 * @return
	 */
	public IAdjCommon getAdjCommon() {
		return adjCommon;
	}

	/**
	 * 
	 * @param adjCommon
	 */
	public void setAdjCommon(IAdjCommon adjCommon) {
		this.adjCommon = adjCommon;
	}
	

	/**
	 * 
	 * @return
	 */
	public IBill getBill() {
		return bill;
	}

	/**
	 * 
	 * @param bill
	 */
	public void setBill(IBill bill) {
		this.bill = bill;
	}
	
	/**
	 * 
	 * @return
	 */
	public IRecord getRecord() {
		return record;
	}

	/**
	 * 
	 * @param record
	 */
	public void setRecord(IRecord record) {
		this.record = record;
	}
	

	/**
	 * 
	 * @return
	 */
	public IBalance getBalance() {
		return balance;
	}

	/**
	 * 
	 * @param balance
	 */
	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	/**
	 * 
	 * @return
	 */
	public IProd getProd() {
		return prod;
	}

	/**
	 * 
	 * @param prod
	 */
	public void setProd(IProd prod) {
		this.prod = prod;
	}
	public TransFactory getTransFactory() {
		return transFactory;
	}

	public void setTransFactory(TransFactory transFactory) {
		this.transFactory = transFactory;
	}

	public IPayManage getPayManage() {
		return payManage;
	}

	public void setPayManage(IPayManage payManage) {
		this.payManage = payManage;
	}

	public IAccount getAccount() {
		return account;
	}

	public void setAccount(IAccount account) {
		this.account = account;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

	public IShortMessage getShortMessage() {
		return shortMessage;
	}

	public void setShortMessage(IShortMessage shortMessage) {
		this.shortMessage = shortMessage;
	}
	


}
