package com.sitech.acctmgr.atom.impl.pay;

import java.util.HashMap;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.IPayOpener;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.pay.SEasyOwnCancelCfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.SEasyOwnCancelCfmOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.inter.pay.IEasyOwnCancelExpire;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

@ParamTypes({ @ParamType(m = "cfm", c =SEasyOwnCancelCfmInDTO.class,oc =SEasyOwnCancelCfmOutDTO.class )})
public class SEasyOwnCancelExpire extends AcctMgrBaseService implements IEasyOwnCancelExpire{
	private IUser user;
	private IPayOpener payOpener;
	private IControl control;
	private IRecord record;
	

	@Override
	public OutDTO cfm(InDTO inParam){
		
		SEasyOwnCancelCfmInDTO inDto = (SEasyOwnCancelCfmInDTO)inParam;
		log.info("---->SEasyOwnExpire cfm inDto: "+inDto.getMbean());
		String phoneNo = inDto.getPhoneNo();
		String userPwd = inDto.getUserPwd();
		String loginPwd = inDto.getLoginPwd();
		String loginAccept = inDto.getLoginAccept();
		String loginNo = inDto.getLoginNo();
		String privinceId = inDto.getProvinceId();
		String chnSource = inDto.getChnSource();
		String remark = inDto.getRemark();
		String opCode = inDto.getOpCode();
		String groupId = inDto.getGroupId();
		
		UserInfoEntity userEnt = user.getUserInfo(phoneNo);
		long contractNo=userEnt.getContractNo();
		long idNo = userEnt.getIdNo();
		if(!user.isUserExpire(idNo, 0)){
			throw new BaseException(AcctMgrError.getErrorCode("8243", "00001"),"用户不是标准神州行用户或者有效期已取消，不可受理该业务！"); 
		}
		
		//获取当前时间
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		//int curYM = Integer.parseInt(curTime.substring(0, 6));
		int totalDate = Integer.parseInt(curTime.substring(0, 8));
		
	    // 获取流水
	    long paySn = control.getSequence("SEQ_PAY_SN");
	    log.info("--------paySn->"+paySn);
		
		Map<String,Object> inCancelMap = new HashMap<String,Object>();
		inCancelMap.put("ID_NO", idNo);
		inCancelMap.put("OP_CODE", opCode);
		inCancelMap.put("LOGIN_NO", loginNo);
		inCancelMap.put("REMARK", remark);
		inCancelMap.put("TOTAL_DATE", totalDate);
		inCancelMap.put("PAY_SN", paySn);
		payOpener.cancelExpireTime(inCancelMap);
		
		
		//记录营业员操作记录表
		LoginOprEntity loginOprEnt = new LoginOprEntity();
		loginOprEnt.setBrandId(userEnt.getBrandId());
		loginOprEnt.setIdNo(idNo);
		loginOprEnt.setLoginGroup(groupId);
		loginOprEnt.setLoginNo(loginNo);
		loginOprEnt.setLoginSn(paySn);
		loginOprEnt.setOpCode(opCode);
		loginOprEnt.setOpTime(curTime);
		loginOprEnt.setPayFee(0);
		loginOprEnt.setPhoneNo(phoneNo);
		loginOprEnt.setRemark(remark);
		loginOprEnt.setPayType("0");
		loginOprEnt.setTotalDate(totalDate);
		record.saveLoginOpr(loginOprEnt);
		
		SEasyOwnCancelCfmOutDTO outDto = new SEasyOwnCancelCfmOutDTO();
		return outDto;
	}
	
	public IUser getUser() {
		return user;
	}


	public void setUser(IUser user) {
		this.user = user;
	}


	public IPayOpener getPayOpener() {
		return payOpener;
	}


	public void setPayOpener(IPayOpener payOpener) {
		this.payOpener = payOpener;
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