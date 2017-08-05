package com.sitech.acctmgr.atom.impl.query;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.domains.base.GroupEntity;
import com.sitech.acctmgr.atom.domains.bill.DetailEnterEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.query.S8291CfmInDTO;
import com.sitech.acctmgr.atom.dto.query.S8291CfmOutDTO;
import com.sitech.acctmgr.atom.dto.query.S8291QueryInDTO;
import com.sitech.acctmgr.atom.dto.query.S8291QueryOutDTO;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.inter.query.I8291;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

@ParamTypes({
		@ParamType(c = S8291CfmInDTO.class, oc = S8291CfmOutDTO.class, m = "cfm"),
		@ParamType(c = S8291QueryInDTO.class, oc = S8291QueryOutDTO.class, m = "query")
})
public class S8291 extends AcctMgrBaseService implements I8291 {

	private IUser user;
	private IGroup group;
	private ILogin login;
	private IControl control;
	private IRecord record;
	protected IPreOrder preOrder;

	@Override
	public OutDTO cfm(InDTO inParam) {
		S8291CfmInDTO inDto = (S8291CfmInDTO) inParam;

		log.debug("inDto=" + inDto.getMbean());

		String phoneNo = inDto.getPhoneNo();
		String beginTime = inDto.getBeginTime();
		String endTime = inDto.getEndTime();
		String queryType = inDto.getDetailType();

		//查询用户信息
		UserInfoEntity uie = user.getUserInfo(phoneNo);
		long idNo = uie.getIdNo();
		String brandId = uie.getBrandId();
		String runCode = uie.getRunCode();
		String userGroupId = uie.getGroupId();
		if (runCode.compareTo("a") >= 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8291", "20001"), "号码运行状态异常，不能操作");
		}

		//检查是否跨地区操作
		GroupEntity ge = group.getGroupInfo(inDto.getGroupId(), userGroupId, inDto.getProvinceId());
		if (ge.getRegionFlag().equals("N")) {
			throw new BusiException(AcctMgrError.getErrorCode("8291", "20002"), "不允许跨地市录入信息!");
		}

		//记录结果表
		DetailEnterEntity dee = new DetailEnterEntity();
		dee.setIdNo(idNo);
		dee.setPhoneNo(phoneNo);
		dee.setEndDate(endTime);
		dee.setLoginNo(inDto.getLoginNo());
		dee.setQueryType(queryType);
		dee.setStartDate(beginTime);
		dee.setValidFlag("Y");
		record.saveDetailEnter(dee);

		//生成操作流水
		long loginAccept = control.getSequence("SEQ_SYSTEM_SN");
		
		//取系统时间
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		
		//同步CRM统一接触
		Map<String, Object> oprCnttMap = new HashMap<String, Object>();
		oprCnttMap.put("Header", inDto.getHeader());
		oprCnttMap.put("PAY_SN", loginAccept);
		oprCnttMap.put("LOGIN_NO", inDto.getLoginNo());
		oprCnttMap.put("GROUP_ID", inDto.getGroupId());
		oprCnttMap.put("OP_CODE", inDto.getOpCode());
		oprCnttMap.put("OP_NOTE", "安保部详单查询录入");
		oprCnttMap.put("TOTAL_FEE", 0);
		oprCnttMap.put("CUST_ID_TYPE", "1");
		oprCnttMap.put("CUST_ID_VALUE", phoneNo);
		oprCnttMap.put("OP_TIME", sCurTime);
		preOrder.sendOprCntt(oprCnttMap);

		//记录操作日志
		LoginOprEntity loe = new LoginOprEntity();
		loe.setIdNo(idNo);
		loe.setBrandId(brandId);
		loe.setLoginGroup(inDto.getGroupId());
		loe.setLoginNo(inDto.getLoginNo());
		loe.setLoginSn(loginAccept);
		loe.setOpCode(inDto.getOpCode());
		loe.setPhoneNo(phoneNo);
		loe.setTotalDate(DateUtils.getCurDay());
		loe.setRemark("安保部详单查询录入");
		record.saveLoginOpr(loe);

		S8291CfmOutDTO outDto = new S8291CfmOutDTO();
		return outDto;
	}

	@Override
	public OutDTO query(InDTO inParam) {
		S8291QueryInDTO inDto = (S8291QueryInDTO) inParam;
		log.debug("inDto=" + inDto.getMbean());

		String phoneNo = inDto.getPhoneNo();

		UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);

		DetailEnterEntity dee = record.getDetailEnterInfo(userInfo.getIdNo());
		if (dee == null) {
			throw new BusiException(AcctMgrError.getErrorCode("8291", "00004"), "用户在“安保部详单查询录入功能”未录入过，不可以查询！");
		}

		S8291QueryOutDTO outDto = new S8291QueryOutDTO();
		outDto.setPhoneNo(dee.getPhoneNo());
		outDto.setLoginNoOpr(dee.getLoginNo());
		outDto.setQueryType(dee.getQueryType());
		outDto.setBegintime(dee.getStartDate());
		outDto.setEndtime(dee.getEndDate());

		log.debug("outDto=" + outDto.toJson());

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
	 * @return the preOrder
	 */
	public IPreOrder getPreOrder() {
		return preOrder;
	}

	/**
	 * @param preOrder the preOrder to set
	 */
	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}

}