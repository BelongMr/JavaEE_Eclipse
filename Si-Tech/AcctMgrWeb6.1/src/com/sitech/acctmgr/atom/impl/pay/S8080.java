package com.sitech.acctmgr.atom.impl.pay;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserDeadEntity;
import com.sitech.acctmgr.atom.domains.user.UserOweEntity;
import com.sitech.acctmgr.atom.dto.pay.S8080BackCfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8080BackCfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S8080QueryPayInfoInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8080QueryPayInfoOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IDelay;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.inter.pay.I8080;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

@ParamTypes({ 
	@ParamType(m = "backCfm", c = S8080BackCfmInDTO.class, oc = S8080BackCfmOutDTO.class),
	@ParamType(m = "queryPayInfo", c = S8080QueryPayInfoInDTO.class, oc = S8080QueryPayInfoOutDTO.class)})
public class S8080 extends AcctMgrBaseService 
					implements I8080{
	
	private IUser user;
	private IBill bill;
	private IRecord record;
	private IBalance balance;
	private IControl control;
	private IDelay delay;
	private IPreOrder preOrder;
	
	@Override
	public OutDTO queryPayInfo(InDTO inParam) {
		// TODO Auto-generated method stub
		S8080QueryPayInfoInDTO inDto = (S8080QueryPayInfoInDTO)inParam;
		log.info("---->8080queryPayInfo_in"+inDto.getMbean());
		String payLogin = inDto.getPayLogin();
		String loginAccept = inDto.getLoginAccept();
		String provinceId = inDto.getProvinceId();
		String phoneNo = inDto.getPhoneNo();
		Long idNo = inDto.getIdNo();
		
		Map<String,Object> inMap = new HashMap<String,Object>();
		inMap.put("LOGIN_NO", payLogin);
		inMap.put("LOGIN_ACCEPT", loginAccept);
		inMap.put("PHONE_NO", phoneNo);
		inMap.put("ID_NO", idNo);
		Map<String,Object> outMap=record.queryPressPayMent(inMap);
		
		Long payFee = Long.parseLong((String)outMap.get("PAYED_OWE")) ;
		Long delayFee = Long.parseLong((String) outMap.get("DELAY_FEE"));
		Long allFee = Long.parseLong((String) outMap.get("CASH_PAY"));
		String billYear = outMap.get("BILL_YEAR").toString();
		String billMonth = outMap.get("BILL_MONTH").toString();
		
		//出参
		S8080QueryPayInfoOutDTO outDto = new S8080QueryPayInfoOutDTO();
		outDto.setBillMonth(billMonth);
		outDto.setBillYear(billYear);
		outDto.setPayFee(payFee);
		outDto.setDelayFee(delayFee);
		outDto.setAllFee(allFee);
		
		log.info("---->8080queryPayInfo_out->"+outDto.toJson());
		return outDto;
	}
	
	
	@Override
	public OutDTO backCfm(InDTO inParam) {
		
		S8080BackCfmInDTO inDto = (S8080BackCfmInDTO)inParam;
		log.info("---->S8080backCfm_in"+inDto.getMbean());
		String phoneNo = inDto.getPhoneNo();
		long idNo =inDto.getIdNo();
		String loginNo = inDto.getLoginNo();
		String opCode = inDto.getOpCode();
		String groupId = inDto.getGroupId();
		String loginAccept = inDto.getLoginAccept();
		String remark = inDto.getRemark();
		long allFee = inDto.getAllFee();
		
		//获取流水
		long paySn = control.getSequence("SEQ_PAY_SN");
		log.info("--------paySn->"+paySn);
		
		//获取离网用户信息
		List<UserDeadEntity> userDeadEntList = user.getUserdeadEntity(phoneNo, idNo, null);
		long contractNo  = userDeadEntList.get(0).getContractNo();
		
		//更新欠费记录
		bill.updateOweUserInfo(phoneNo, idNo, null, null,loginNo,paySn,"0","2",loginAccept);
		
		UserOweEntity oweInfo = new UserOweEntity();
		oweInfo.setPhoneNo(phoneNo);
		oweInfo.setLoginNo(loginNo);
		oweInfo.setLoginAccept(Long.valueOf(paySn).toString());
		oweInfo.setIdNo(idNo);
		
		//获取日期
		String opTime = control.getSysDate().get("CUR_TIME").toString();
		int curYM = Integer.parseInt(opTime.substring(0, 6));
		int totalDate = Integer.parseInt(opTime.substring(0, 8));
		
		
		//更新陈死账缴费记录表
		Map inMap = new HashMap();
		inMap.put("LOGIN_ACCEPT", loginAccept);
		inMap.put("ID_NO", idNo);
		inMap.put("STATUS", "1");
		record.updatePressPayMent(inMap);
		
		
		 //报表发送
        Map<String, Object> pressKey = new HashMap<String, Object>();
        pressKey.put("LOGIN_ACCEPT", loginAccept);
        pressKey.put("CONTRACT_NO", contractNo);
		
		Map inMapTmp = new HashMap<String, Object>();
	    inMapTmp.put("ACTION_ID", "1015");
	    inMapTmp.put("KEY_DATA", pressKey);
		inMapTmp.put("LOGIN_NO", loginNo);
		inMapTmp.put("PHONE_NO", phoneNo);
		inMapTmp.put("LOGIN_SN", loginAccept);
		inMapTmp.put("OP_CODE", opCode);
			
		preOrder.sendReportData( inDto.getHeader(), inMapTmp);
		
		
		//记录营业员操作记录表
		LoginOprEntity loginOprEnt = new LoginOprEntity();
		//loginOprEnt.setBrandId(userDeadEntList.get(0).getBrandId());
		loginOprEnt.setIdNo(idNo);
		loginOprEnt.setLoginGroup(groupId);
		loginOprEnt.setLoginNo(loginNo);
		loginOprEnt.setLoginSn(paySn);
		loginOprEnt.setOpCode(opCode);
		loginOprEnt.setOpTime(opTime);
		loginOprEnt.setPhoneNo(phoneNo);
		loginOprEnt.setRemark(remark);
		loginOprEnt.setPayType("0");
		loginOprEnt.setTotalDate(totalDate);
		loginOprEnt.setPayFee(-1*allFee);
		record.saveLoginOpr(loginOprEnt);
		
		S8080BackCfmOutDTO outDto = new S8080BackCfmOutDTO();
		log.info("---->S8080backCfm_out->"+outDto.toJson());
		
		return outDto;
	}

	public IUser getUser() {
		return user;
	}

	public void setUser(IUser user) {
		this.user = user;
	}

	public IBill getBill() {
		return bill;
	}

	public void setBill(IBill bill) {
		this.bill = bill;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}

	public IBalance getBalance() {
		return balance;
	}

	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	public IControl getControl() {
		return control;
	}

	public void setControl(IControl control) {
		this.control = control;
	}

	public IDelay getDelay() {
		return delay;
	}

	public void setDelay(IDelay delay) {
		this.delay = delay;
	}


	public IPreOrder getPreOrder() {
		return preOrder;
	}


	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}
	
	

}
