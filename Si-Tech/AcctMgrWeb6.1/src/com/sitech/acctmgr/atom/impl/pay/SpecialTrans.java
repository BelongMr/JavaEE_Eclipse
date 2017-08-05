package com.sitech.acctmgr.atom.impl.pay;

import static com.sitech.acctmgr.common.AcctMgrError.getErrorCode;
import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.ITransType;
import com.sitech.acctmgr.atom.busi.pay.trans.TransFactory;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.account.ContractEntity;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.LoginBaseEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayOutEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.pub.PubWrtoffCtrlEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransBnCfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransBnCfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransBnCheckInDTO;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransBnCheckOutDTO;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransCancelCfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransCancelCfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransCfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransCfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransKdTsCfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransRollBackInDTO;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransRollBackOutDTO;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransYearCancelInDTO;
import com.sitech.acctmgr.atom.dto.pay.SpecialTransYearCancelOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IBillAccount;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IProd;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.inter.pay.ISpecialTrans;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;



@ParamTypes({ 
	@ParamType(c = SpecialTransCfmInDTO.class, m = "cfm", oc = SpecialTransCfmOutDTO.class),
	@ParamType(c = SpecialTransBnCfmInDTO.class, m = "bnCfm", oc = SpecialTransBnCfmOutDTO.class),
	@ParamType(c = SpecialTransKdTsCfmInDTO.class, m = "kdTsCfm", oc = SpecialTransBnCfmOutDTO.class),
	@ParamType(c = SpecialTransCancelCfmInDTO.class, m = "cancelCfm", oc = SpecialTransCancelCfmOutDTO.class),
	@ParamType(c = SpecialTransRollBackInDTO.class, m = "rollBack", oc = SpecialTransRollBackOutDTO.class),
	@ParamType(c = SpecialTransCancelCfmInDTO.class, m = "cfm", oc = SpecialTransCancelCfmOutDTO.class),
	@ParamType(c = SpecialTransBnCheckInDTO.class, m = "bnCheck", oc = SpecialTransBnCheckOutDTO.class),
	@ParamType(c = SpecialTransYearCancelInDTO.class, m = "yearCancel", oc = SpecialTransYearCancelOutDTO.class)
	})
public class SpecialTrans extends AcctMgrBaseService implements ISpecialTrans{
	
	private IPayManage	 payManage;
	private IBalance 	 balance;
	private TransFactory transFactory;
	private IUser 		 user;
	private IRemainFee 	 remainFee;
	private IAccount 	 account;
	private IControl 	 control;
	private IRecord 	 record;
	private ILogin		 login;
	private IBillAccount billAccount;
	private IGroup		 group;
	private IProd        prod;
	

	@Override
	public OutDTO cfm(InDTO inParam) {
		// TODO Auto-generated method stub
		SpecialTransCfmInDTO inDto = (SpecialTransCfmInDTO) inParam;
		
		log.info("cfm 入参："+inDto);
		
		if( StringUtils.isEmptyOrNull(inDto.getGroupId()) ){
			LoginEntity  loginEntity = login.getLoginInfo(inDto.getLoginNo(), inDto.getProvinceId());
			inDto.setGroupId(loginEntity.getGroupId());
		}
		
		//计算需要转账金额
		long monthFee = Long.parseLong(inDto.getMonthFee());
		int effectMonth  = inDto.getEffectMonth();
		long transFee = monthFee*effectMonth;
		
		/* 获取当前日期 */
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String totalDate = curTime.substring(0, 8);
		String curYM = curTime.substring(0, 6);
		
		//查询在网用户信息
		UserInfoEntity userEnt = user.getUserInfo(inDto.getOutPhoneNo());
		long idNo =userEnt.getIdNo();
	
		
		/* 创建转账类型 */
		ITransType transType;
		transType = transFactory.createTransFactory("TransSpecial",true);
		
		/* 取账户可转余额 */
		long remainTransFee = transType.getTranFee(inDto.getOutContractNo());
		log.info("可转余额---->"+remainTransFee);
		
		/*计算用户的账户余额*/
		long remainFeeTmp =  remainFee.getConRemainFee(inDto.getOutContractNo()).getRemainFee();
		
		if(remainTransFee<transFee || remainFeeTmp<transFee){
			throw new BusiException(getErrorCode("0000", "00002"), "可转预存不足，办理业务失败！");
		}
		
		PayUserBaseEntity transInBaseInfo = new PayUserBaseEntity();  //转入账户基本信息
		PayUserBaseEntity transOutBaseInfo = new PayUserBaseEntity();
		
		/* 转账账户基本信息查询 */
		transOutBaseInfo= getUserBaseInfo(inDto.getOutPhoneNo(), inDto.getOutContractNo());
		transOutBaseInfo.setNetFlag(true);
		transInBaseInfo= getUserBaseInfo(inDto.getInPhoneNo(), inDto.getInContractNo());
		transInBaseInfo.setNetFlag(true);
		
		/*入账实体设值*/
		PayBookEntity bookIn = new PayBookEntity();
		bookIn.setBeginTime(curTime);
		bookIn.setForeignSn(inDto.getForeignSn());
		bookIn.setGroupId(inDto.getGroupId());
		bookIn.setLoginNo(inDto.getLoginNo());
		bookIn.setOpCode(inDto.getOpCode());
		bookIn.setOpNote(inDto.getOpNote());
		bookIn.setPayFee(transFee);
		bookIn.setPayMethod("0");
		bookIn.setPayPath("11");
		bookIn.setPayType(inDto.getPayType());
		bookIn.setTotalDate(Integer.parseInt(totalDate));
		bookIn.setYearMonth(Long.parseLong(curYM));
		
		Map<String, Object> inTransCfmMap = new HashMap<String, Object>();
		safeAddToMap(inTransCfmMap, "Header", inDto.getHeader());
		safeAddToMap(inTransCfmMap, "TRANS_TYPE_OBJ", transType); //转账类型实例化对象
		safeAddToMap(inTransCfmMap, "TRANS_IN", transInBaseInfo);  //转入账户基本信息
		safeAddToMap(inTransCfmMap, "TRANS_OUT", transOutBaseInfo); //转出账户基本信息
		safeAddToMap(inTransCfmMap, "BOOK_IN", bookIn); //入账实体
		safeAddToMap(inTransCfmMap, "OP_TYPE", inDto.getOpType()); //转账业务类型
		safeAddToMap(inTransCfmMap, "IN_PAY_TYPE", inDto.getPayType()); //转入账本类型
		safeAddToMap(inTransCfmMap, "EFFECT_MONTH", inDto.getEffectMonth());
		safeAddToMap(inTransCfmMap, "BEGIN_DATE", inDto.getBeginDate());
		
		//进行专款分月转账
		long cfmSn = payManage.specialTrans(inTransCfmMap);
		
		//记录营业员操作记录表
		LoginOprEntity loginOprEnt = new LoginOprEntity();
		loginOprEnt.setBrandId(userEnt.getBrandId());
		loginOprEnt.setIdNo(idNo);
		loginOprEnt.setLoginGroup(inDto.getGroupId());
		loginOprEnt.setLoginNo(inDto.getLoginNo());
		loginOprEnt.setLoginSn(cfmSn);
		loginOprEnt.setOpCode(inDto.getOpCode());
		loginOprEnt.setOpTime(curTime);
		loginOprEnt.setPayFee(0);
		loginOprEnt.setPhoneNo(inDto.getOutPhoneNo());
		loginOprEnt.setRemark(inDto.getOpNote());
		loginOprEnt.setPayType("0");
		loginOprEnt.setTotalDate(Long.parseLong(totalDate));
		loginOprEnt.setPayFee(transFee);
		record.saveLoginOpr(loginOprEnt);
		
		SpecialTransCfmOutDTO outDto = new SpecialTransCfmOutDTO();
		log.info("cfm 出参："+outDto);
		return outDto;
	}
	
	public OutDTO bnCfm(InDTO inParam) {
		
		SpecialTransBnCfmInDTO inDto = (SpecialTransBnCfmInDTO) inParam;
		log.info("bnCfm 入参："+inDto);
		LoginEntity  loginEntity = login.getLoginInfo(inDto.getLoginNo(), inDto.getProvinceId());
		if( StringUtils.isEmptyOrNull(inDto.getGroupId()) ){
			inDto.setGroupId(loginEntity.getGroupId());
		}
		
		/* 获取当前日期 */
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String totalDate = curTime.substring(0, 8);
		String curYM = curTime.substring(0, 6);
		
		/* 创建转账类型 */
		ITransType transType = transFactory.createTransFactory("TransAccountEnt",true);
		
		/* 取账户可转余额 */
		long remainTransFee = transType.getTranFee(inDto.getOutContractNo());
		log.info("可转余额---->"+remainTransFee);
		
		if(remainTransFee < inDto.getYearFee()){
			throw new BusiException(getErrorCode("8014", "00046"), "用户可转余额不足，请缴费后再办理业务！");
		}
		
		/* 转账账户基本信息查询 */
		PayUserBaseEntity transOutBaseInfo= getUserBaseInfo(inDto.getOutPhoneNo(), inDto.getOutContractNo());
		transOutBaseInfo.setNetFlag(true);
		PayUserBaseEntity transInBaseInfo= getUserBaseInfo(inDto.getInPhoneNo(), inDto.getInContractNo());
		transInBaseInfo.setNetFlag(true);
		
		//账本结束日期等于 专款生效时间+生效月份 01号
		String endTime = DateUtil.toStringPlusMonths(inDto.getBeginDate().substring(0, 6), inDto.getEffectMonth(),"yyyyMM")
				+"01000000"; 
		
		/*入账实体设值*/
		PayBookEntity bookIn = new PayBookEntity();
		bookIn.setBeginTime(inDto.getBeginDate());
		bookIn.setEndTime(endTime);
		bookIn.setForeignSn(inDto.getForeignSn());
		bookIn.setForeignTime(inDto.getForeignTime());
		bookIn.setGroupId(inDto.getGroupId());
		bookIn.setLoginNo(inDto.getLoginNo());
		bookIn.setOpCode(inDto.getOpCode());
		bookIn.setOpNote(inDto.getOpNote());
		bookIn.setPayFee(inDto.getYearFee());
		bookIn.setPayMethod("A");
		bookIn.setPayPath("11");
		bookIn.setPayType(inDto.getPayType());
		bookIn.setTotalDate(Integer.parseInt(totalDate));
		bookIn.setYearMonth(Long.parseLong(curYM));
		
		Map<String, Object> inTransCfmMap = new HashMap<String, Object>();
		safeAddToMap(inTransCfmMap, "Header", inDto.getHeader());
		safeAddToMap(inTransCfmMap, "TRANS_TYPE_OBJ", transType); //转账类型实例化对象
		safeAddToMap(inTransCfmMap, "TRANS_IN", transInBaseInfo);  //转入账户基本信息
		safeAddToMap(inTransCfmMap, "TRANS_OUT", transOutBaseInfo); //转出账户基本信息
		safeAddToMap(inTransCfmMap, "BOOK_IN", bookIn); //入账实体
		safeAddToMap(inTransCfmMap, "OP_TYPE", inDto.getOpType()); //转账类型
		
		//是否控制专款每月最多消费金额  1控制，0不控制
		if(inDto.getMonthFlag().equals("0")){
			payManage.transBalance(inTransCfmMap, inDto.getPayType());
		}else if(inDto.getMonthFlag().equals("1")){
			
			safeAddToMap(inTransCfmMap, "IN_PAY_TYPE", inDto.getPayType()); //转入账本类型
			safeAddToMap(inTransCfmMap, "EFFECT_MONTH", inDto.getEffectMonth());
			safeAddToMap(inTransCfmMap, "BEGIN_DATE", inDto.getBeginDate());
			
			//进行专款分月转账
			log.debug("包年账户转账，进行专款分月转账开始: " + inTransCfmMap.toString());
			payManage.specialTrans(inTransCfmMap);
		}
		
		SpecialTransBnCfmOutDTO outDto = new SpecialTransBnCfmOutDTO();
		return outDto;
	}
	
	@Override
	public OutDTO kdTsCfm(InDTO inParam){
		
		SpecialTransKdTsCfmInDTO inDto = (SpecialTransKdTsCfmInDTO) inParam;
		LoginEntity  loginEntity = login.getLoginInfo(inDto.getLoginNo(), inDto.getProvinceId());
		if( StringUtils.isEmptyOrNull(inDto.getGroupId()) ){
			inDto.setGroupId(loginEntity.getGroupId());
		}
		log.info("kdTsCfm 入参："+inDto);
		
		/* 获取当前日期 */
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String totalDate = curTime.substring(0, 8);
		String curYM = curTime.substring(0, 6);
		
		/* 创建转账类型 */
		ITransType transType = transFactory.createTransFactory("TransAccountEnt",true);
		
		/* 转账账户基本信息查询 */
		PayUserBaseEntity transOutBaseInfo= getUserBaseInfo(inDto.getPhoneNo(), 0);
		transOutBaseInfo.setNetFlag(true);
		
		PayUserBaseEntity transInBaseInfo = transOutBaseInfo; //包年提速自己给自己转账
		
		ChngroupRelEntity groupEntity = group.getRegionDistinct(transOutBaseInfo.getUserGroupId(), "2", inDto.getProvinceId());
		
		//取宽带用户原来专款
        long oldPayTypeFee = balance.getAcctBookSum(transOutBaseInfo.getContractNo(), inDto.getInPayType());
        if (oldPayTypeFee == 0) {
            throw new BusiException(AcctMgrError.getErrorCode("0000", "20014"), "用户专款未生效!");
        }
        
        //取当月应收费用
        long totalMonthFee = billAccount.getKdMonthFee(inDto.getPrcId(), groupEntity.getRegionCode());
		log.debug("用户原来专款金额为: " + oldPayTypeFee + "宽带当月费用： " + totalMonthFee);
        
		/*入账实体设值*/
		PayBookEntity bookIn = new PayBookEntity();
		bookIn.setForeignSn(inDto.getForeignSn());
		bookIn.setForeignTime(inDto.getForeignTime());
		bookIn.setGroupId(inDto.getGroupId());
		bookIn.setLoginNo(inDto.getLoginNo());
		bookIn.setOpCode(inDto.getOpCode());
		bookIn.setOpNote(inDto.getOpNote());
		bookIn.setPayMethod("A");
		bookIn.setPayPath("11");
		bookIn.setTotalDate(Integer.parseInt(totalDate));
		bookIn.setYearMonth(Long.parseLong(curYM));
		
		Map<String, Object> inTransCfmMap = new HashMap<String, Object>();
		safeAddToMap(inTransCfmMap, "Header", inDto.getHeader());
		//safeAddToMap(inTransCfmMap, "TRANS_TYPE_OBJ", transType); //转账类型实例化对象
		safeAddToMap(inTransCfmMap, "TRANS_IN", transInBaseInfo);  //转入账户基本信息
		safeAddToMap(inTransCfmMap, "TRANS_OUT", transOutBaseInfo); //转出账户基本信息
		safeAddToMap(inTransCfmMap, "BOOK_IN", bookIn); //入账实体
		safeAddToMap(inTransCfmMap, "OP_TYPE", "KDTS"); //转账类型 KDTS：宽带提速
		
		//将宽带当前专款剩余费用转到0账本
		bookIn.setPayFee(oldPayTypeFee - totalMonthFee);
		bookIn.setBeginTime(curTime);
		//bookIn.setEndTime(endTime);
		payManage.transBalance(inTransCfmMap, "0", inDto.getInPayType());
		
		//将可使用预存款转移到新的账本类型
		//账本结束日期等于 专款生效时间+生效月份 01号
		String endTime = DateUtil.toStringPlusMonths(inDto.getBeginDate().substring(0, 6), inDto.getEffectMonth(),"yyyyMM")
				+"01"; 
		bookIn.setBeginTime(inDto.getBeginDate());
		bookIn.setEndTime(endTime);
		bookIn.setPayFee(inDto.getYearFee());
		safeAddToMap(inTransCfmMap, "TRANS_TYPE_OBJ", transType);
		payManage.transBalance(inTransCfmMap, inDto.getInPayTypeNew());
        
		SpecialTransBnCfmOutDTO outDto = new SpecialTransBnCfmOutDTO();
		return outDto;
	}
	
	@Override
	public OutDTO bnCheck(InDTO inParam) {
		
		SpecialTransBnCheckInDTO inDto = (SpecialTransBnCheckInDTO) inParam;
		log.info("bnCfm 入参："+inDto);
		LoginEntity  loginEntity = login.getLoginInfo(inDto.getLoginNo(), inDto.getProvinceId());
		if( StringUtils.isEmptyOrNull(inDto.getGroupId()) ){
			inDto.setGroupId(loginEntity.getGroupId());
		}
		
		/* 获取当前日期 */
		String curTime = control.getSysDate().get("CUR_TIME").toString();

		PubWrtoffCtrlEntity wrtoffCtrlEntity = control.getWriteOffFlagAndMonth();
		if (wrtoffCtrlEntity.getWrtoffFlag().equals("1")) { // 出账期间

			log.info("出账期间，不允许办理包年类业务");
			throw new BusiException(getErrorCode("0000", "00019"), "出账期间不允许办理包年业务！");
		}
		
		/* 创建转账类型 */
		ITransType transType = transFactory.createTransFactory("TransAccountEnt",true);
		
		PayUserBaseEntity transOutBaseInfo= getUserBaseInfo(inDto.getOutPhoneNo(), inDto.getOutContractNo());
		transOutBaseInfo.setNetFlag(true);
		
		/* 取账户可转余额 */
		long remainTransFee = transType.getTranFee(inDto.getOutContractNo());
		log.info("可转余额---->"+remainTransFee);
		
/*		if(remainTransFee < inDto.getYearFee()){
			throw new BusiException(getErrorCode("0000", "00002"), "可转预存不足，办理业务失败！");
		}*/
		
		SpecialTransBnCheckOutDTO outDto = new SpecialTransBnCheckOutDTO();
		outDto.setTransFee(remainTransFee);
		return outDto;
	}

	@Override
	public OutDTO rollBack(InDTO inParam) {
		// TODO Auto-generated method stub
		SpecialTransRollBackInDTO inDto = (SpecialTransRollBackInDTO) inParam;
		if( StringUtils.isEmptyOrNull(inDto.getGroupId()) ){
			LoginEntity  loginEntity = login.getLoginInfo(inDto.getLoginNo(), inDto.getProvinceId());
			inDto.setGroupId(loginEntity.getGroupId());
		}
		log.info("rollBack 入参："+inDto.getMbean());
		
		//查询在网用户信息
		UserInfoEntity userEnt = user.getUserInfo(inDto.getOutPhoneNo());
		long idNo =userEnt.getIdNo();
		
		/* 获取当前日期 */
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String totalDate = curTime.substring(0, 8);
		String curYM = curTime.substring(0, 6);
		
		LoginBaseEntity loginEntity = new LoginBaseEntity();
		loginEntity.setLoginNo(inDto.getLoginNo());
		loginEntity.setGroupId(inDto.getGroupId());
		loginEntity.setOpCode(inDto.getOpCode());
		loginEntity.setOpNote(inDto.getOpNote());
		
		String yearMonth = inDto.getOrgForeignTime().substring(0,6);
		
		String originForeignSn= inDto.getOrgForeignSn();
		
		List<Map<String, Object>> paySnList = payManage.getPaySnByForeign(originForeignSn, yearMonth);
		if (0 == paySnList.size()) {
			log.info("外部流水交费记录不存在foreign_sn : " + originForeignSn);
			throw new BusiException(AcctMgrError.getErrorCode("8056", "00002"),
					"外部流水交费记录不存在foreign_sn :  " + originForeignSn);
		}
		List<PayOutEntity>	payBackSnList = new ArrayList<PayOutEntity>();
		
		for(Map<String, Object> paySnMap : paySnList){
			
			String status = paySnMap.get("STATUS").toString();
			if( status.equals("1") || status.equals("3") ){
				log.info("该条缴费记录已经冲正 foreignSn : " + originForeignSn );
				throw new BusiException(AcctMgrError.getErrorCode("8056","00004"), "该条缴费记录已经冲正 " );
			}
			
			long paySn = Long.parseLong(paySnMap.get("PAY_SN").toString());
			String payOpCode = (String)paySnMap.get("OP_CODE");
			
			//进行回退
			Map<String, Object> inTransRollBackMap = new HashMap<String, Object>();
			safeAddToMap(inTransRollBackMap, "Header", inDto.getHeader());
			safeAddToMap(inTransRollBackMap, "PAY_SN", paySn);
			safeAddToMap(inTransRollBackMap, "CUR_TIEM", curTime);
			safeAddToMap(inTransRollBackMap, "PAYED_TIME", inDto.getOrgForeignTime());
			safeAddToMap(inTransRollBackMap, "TOTAL_DATE", totalDate);
			safeAddToMap(inTransRollBackMap, "CUR_YM", curYM);
			safeAddToMap(inTransRollBackMap, "FOREIGN_SN", inDto.getForeignSn());
			safeAddToMap(inTransRollBackMap, "LOGIN_ENTITY",loginEntity);
			safeAddToMap(inTransRollBackMap, "PAY_METHOD","A");
			safeAddToMap(inTransRollBackMap, "PAY_PATH","11");
			//验证是否进行了消费需要使用in_contract_no
			safeAddToMap(inTransRollBackMap, "OUT_CONTRACT_NO", inDto.getOutContractNo());
			safeAddToMap(inTransRollBackMap, "IN_CONTRACT_NO", inDto.getInContractNo());
			
			//预存款校验
			long transFee = payManage.specialTransRollCheck(inTransRollBackMap);
					
			//回退操作，包括回退payment记录
			long rollSn = payManage.specialTransRollBack(inTransRollBackMap);
			
			
			//记录营业员操作记录表
			LoginOprEntity loginOprEnt = new LoginOprEntity();
			loginOprEnt.setBrandId(userEnt.getBrandId());
			loginOprEnt.setIdNo(idNo);
			loginOprEnt.setLoginGroup(inDto.getGroupId());
			loginOprEnt.setLoginNo(inDto.getLoginNo());
			loginOprEnt.setLoginSn(rollSn);
			loginOprEnt.setOpCode(inDto.getOpCode());
			loginOprEnt.setOpTime(curTime);
			loginOprEnt.setPayFee(0);
			loginOprEnt.setPhoneNo(inDto.getOutPhoneNo());
			loginOprEnt.setRemark(inDto.getOpNote());
			loginOprEnt.setPayType("0");
			loginOprEnt.setTotalDate(Long.parseLong(totalDate));
			loginOprEnt.setPayFee(transFee);
			record.saveLoginOpr(loginOprEnt);
		
		}
		
		SpecialTransRollBackOutDTO outDto = new SpecialTransRollBackOutDTO();
		log.info("rollBack 出参："+outDto);
		return outDto;
	}
	
	
	@Override
	public OutDTO cancelCfm(InDTO inParam) {
		// TODO Auto-generated method stub
		SpecialTransCancelCfmInDTO inDto = (SpecialTransCancelCfmInDTO) inParam;
		log.info("cancelCfm 入参："+inDto.getMbean());
		String opCode = inDto.getOpCode();
		String payType = inDto.getPayType();
		String foreignSn = inDto.getOrgForeignSn();
				
		long cfmSn = 0L;
		
		/* 获取当前日期 */
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String totalDate = curTime.substring(0, 8);
		String curYM = curTime.substring(0, 6);
		
		 UserInfoEntity uie = user.getUserEntityByConNo(inDto.getOutContractNo(),true);
		
		//获取该账户所有的有效付费用户列表,并且获取资费月租
		long monthFee = 0L;
		List<ContractEntity>  listUser = account.getUserList(inDto.getOutContractNo());
		for(ContractEntity payUser:listUser){
			
			 UserInfoEntity uiePay = user.getUserEntityByIdNo(payUser.getId(),true);
		     String groupId = uiePay.getGroupId();

		     //取用户地市
		     ChngroupRelEntity crge = group.getRegionDistinct(groupId, "2", inDto.getProvinceId());
		     String regionCode = crge.getRegionCode();
		     
		     monthFee += billAccount.getUserMonthFee(payUser.getId(), regionCode);
		}
		
				
		//取转出账本列表
		List<Map<String, Object>> transOutBookList = new ArrayList<Map<String, Object>>();
		transOutBookList = this.getTranFeeList(inDto.getInContractNo(), "JT", foreignSn.trim(),totalDate);
		
		//取家庭套餐月租
		long JTFee = 0L;
		for(Map<String, Object> bookOut:transOutBookList){
			JTFee += Long.parseLong(bookOut.get("CUR_BALANCE").toString());
		}
		
		long transFee = JTFee - monthFee;
		
		/*家庭生效但家庭宽带未竣工*/
		int ifWeiYue = 0;
		
		if(opCode.equals("0000")){
			opCode="m360";
			ifWeiYue = 1;
		}
		
		
		/* 家庭生效但宽带未竣工 */
		if(ifWeiYue==1){
			
			//入账实体
			PayBookEntity bookInEnt = new PayBookEntity();
			bookInEnt.setBeginTime(curTime);
			bookInEnt.setEndTime("");
			bookInEnt.setPayFee(transFee);
			
			
			/* 创建转账类型 */
			//ITransType transType = transFactory.createTransFactory("TransAccountEnt",true);
			
			/* 转账账户基本信息查询 */
			PayUserBaseEntity transOutBaseInfo= getUserBaseInfo(inDto.getOutPhoneNo(), 0);
			transOutBaseInfo.setNetFlag(true);
			
			PayUserBaseEntity transInBaseInfo = transOutBaseInfo; //自己给自己转账
			
			
			Map<String, Object> inTransMap = new HashMap<String, Object>();
			inTransMap.put("Header",inDto.getHeader());
			inTransMap.put("TRANS_IN",transInBaseInfo);
			inTransMap.put("TRANS_OUT",transOutBaseInfo);
			inTransMap.put("OUT_PAY_TYPE","JT");
			inTransMap.put("IN_PAY_TYPE","0");
			
			inTransMap.put("BOOK_IN", bookInEnt);
			cfmSn = payManage.transBalanceSpecial(inTransMap,transOutBookList);
			
			//更新账本结束时间为下月一号时间，当月可冲销
			
		}else if(ifWeiYue==0){
			//入表BAL_YEARCANCEL_INFO
			
			//入表bal_payment_info
			
			//记录营业员操作记录表
			LoginOprEntity loginOprEnt = new LoginOprEntity();
			loginOprEnt.setBrandId(uie.getBrandId());
			loginOprEnt.setIdNo(uie.getIdNo());
			loginOprEnt.setLoginGroup(inDto.getGroupId());
			loginOprEnt.setLoginNo(inDto.getLoginNo());
			loginOprEnt.setLoginSn(cfmSn);
			loginOprEnt.setOpCode(inDto.getOpCode());
			loginOprEnt.setOpTime(curTime);
			loginOprEnt.setPayFee(0);
			loginOprEnt.setPhoneNo(inDto.getOutPhoneNo());
			loginOprEnt.setRemark(inDto.getOpNote());
			loginOprEnt.setPayType("0");
			loginOprEnt.setTotalDate(Long.parseLong(totalDate));
			loginOprEnt.setPayFee(transFee);
			record.saveLoginOpr(loginOprEnt);
		}
		
		
		
		//m360是要做 每月使用不完累积下个月的
		
		
		
		SpecialTransCancelCfmOutDTO outDto = new SpecialTransCancelCfmOutDTO();
		log.info("cancelCfm 出参："+outDto.toJson());
		return outDto;
	}
	
	public OutDTO yearCancel(InDTO inParam){
		
		SpecialTransYearCancelInDTO inDto = (SpecialTransYearCancelInDTO) inParam;
		if( StringUtils.isEmptyOrNull(inDto.getGroupId()) ){
			LoginEntity  loginEntity = login.getLoginInfo(inDto.getLoginNo(), inDto.getProvinceId());
			inDto.setGroupId(loginEntity.getGroupId());
		}
		log.info("包年取消yearCancel 入参："+inDto.getMbean());
		
		/* 获取当前日期 */
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String totalDate = curTime.substring(0, 8);
		String curYM = curTime.substring(0, 6);
		
		Map<String, Object> inMapTmp = null;
		
		PayUserBaseEntity transInBaseInfo= getUserBaseInfo(inDto.getInPhoneNo(), inDto.getInContractNo());
		transInBaseInfo.setNetFlag(true);
		
		LoginBaseEntity loginBase = new LoginBaseEntity();
		loginBase.setLoginNo(inDto.getLoginNo());
		loginBase.setGroupId(inDto.getGroupId());
		loginBase.setOpCode(inDto.getOpCode());
		loginBase.setOpNote(inDto.getOpNote());
		
		long loginaccept = control.getSequence("SEQ_PAY_SN");
		
		/**
		 *更新预存款结束时间为包年取消业务办理时间 
		 **/
		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("LOGIN_NO", inDto.getLoginNo());
		inMapTmp.put("OP_CODE", inDto.getOpCode());
		inMapTmp.put("LOGIN_ACCEPT", loginaccept);
		payManage.upAcctbookEndTime(transInBaseInfo.getContractNo(), inDto.getOrgForeignSn(), 
				inDto.getPayType(), inDto.getOrgForeignTime(), inDto.getOpTime(), inMapTmp);
		
		/**
		 *入包年取消记录表bal_yearcancel_info 
		 **/
		String backYm = DateUtil.toStringPlusMonths(curYM, 1,"yyyyMM");

		inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("ID_NO", transInBaseInfo.getIdNo());
		inMapTmp.put("PHONE_NO", transInBaseInfo.getPhoneNo());
		inMapTmp.put("CONTRACT_NO", transInBaseInfo.getContractNo());
		inMapTmp.put("PAY_TYPE", inDto.getPayType());
		inMapTmp.put("PENAL_SUM_FLAG", inDto.getBillFlag());			// 收取违约金标识 N：不收取 Y：收取
		inMapTmp.put("TOTAL_DATE", totalDate);
		inMapTmp.put("LOGIN_ACCEPT", loginaccept);
		inMapTmp.put("ORI_FOREIGN_SN", inDto.getOrgForeignSn());
		inMapTmp.put("FOREIGN_SN", inDto.getForeignSn());
		inMapTmp.put("REMARK", inDto.getOpNote());
		inMapTmp.put("BACK_YM", backYm);
		balance.inYearCalcle(inMapTmp, loginBase);
		
		//记录营业员操作记录表
		LoginOprEntity loginOprEnt = new LoginOprEntity();
		loginOprEnt.setBrandId(transInBaseInfo.getBrandId());
		loginOprEnt.setIdNo(transInBaseInfo.getIdNo());
		loginOprEnt.setLoginGroup(inDto.getGroupId());
		loginOprEnt.setLoginNo(inDto.getLoginNo());
		loginOprEnt.setLoginSn(loginaccept);
		loginOprEnt.setOpCode(inDto.getOpCode());
		loginOprEnt.setOpTime(curTime);
		loginOprEnt.setPayFee(0);
		loginOprEnt.setPhoneNo(inDto.getOutPhoneNo());
		loginOprEnt.setRemark(inDto.getOpNote());
		loginOprEnt.setPayType("0");
		loginOprEnt.setTotalDate(Long.parseLong(totalDate));
		loginOprEnt.setPayFee(0);
		record.saveLoginOpr(loginOprEnt);
		
		SpecialTransCancelCfmOutDTO outDto = new SpecialTransCancelCfmOutDTO();
		return outDto;
	}
	
	
	private PayUserBaseEntity getUserBaseInfo(String inPhoneNo, long inContractNo) {
			String phoneNo = inPhoneNo;
			long contractNo = inContractNo;
			String conGroup="";
			
			log.info("getUserBaseInfo-->phoneNo:"+phoneNo+",contractNo"+ contractNo);
			
			long idNo = 0;
			String brandId = "";
			
			/* 获取用户信息 */
			UserInfoEntity  userEntity = user.getUserInfo(phoneNo);
			idNo = userEntity.getIdNo();
			if (contractNo == 0) {
				contractNo = userEntity.getContractNo();
			}
			brandId = userEntity.getBrandId();

			/*获取账户信息*/
			ContractInfoEntity conEntity = account.getConInfo(contractNo);
			conGroup=conEntity.getGroupId();
			
			// 出参信息
			PayUserBaseEntity userBaseInfo = new PayUserBaseEntity();
			userBaseInfo.setBrandId(brandId);
			userBaseInfo.setContractNo(contractNo);
			userBaseInfo.setIdNo(idNo);
			userBaseInfo.setPhoneNo(phoneNo);
			userBaseInfo.setUserGroupId(conGroup);
			return userBaseInfo;
	}
	
	//获取账本列表,当月账本不进行转账
	private List<Map<String, Object>> getTranFeeList(long inContractNo, String outPayType,String foreignSn,String endTime){
		List<Map<String, Object>> outList = new ArrayList<Map<String, Object>>();
		Map<String, Object> inMap = new HashMap<String, Object>();
		
		inMap.put("CONTRACT_NO", inContractNo);	
		inMap.put("PAY_TYPE", outPayType);  //账本类型 
		inMap.put("FOREIGN_SN", foreignSn);
		inMap.put("ORDER_DESC", "ORDER_DESC");
		inMap.put("QUERY_TIME", endTime);
		
		outList = balance.getAcctBookList(inMap);

		return outList;
	}

	
	public IBillAccount getBillAccount() {
		return billAccount;
	}

	public void setBillAccount(IBillAccount billAccount) {
		this.billAccount = billAccount;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

	public ILogin getLogin() {
		return login;
	}

	public void setLogin(ILogin login) {
		this.login = login;
	}

	public IPayManage getPayManage() {
		return payManage;
	}

	public void setPayManage(IPayManage payManage) {
		this.payManage = payManage;
	}

	public IBalance getBalance() {
		return balance;
	}

	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	public TransFactory getTransFactory() {
		return transFactory;
	}

	public void setTransFactory(TransFactory transFactory) {
		this.transFactory = transFactory;
	}

	public IUser getUser() {
		return user;
	}

	public void setUser(IUser user) {
		this.user = user;
	}

	public IRemainFee getRemainFee() {
		return remainFee;
	}

	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}

	public IAccount getAccount() {
		return account;
	}

	public void setAccount(IAccount account) {
		this.account = account;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}

}