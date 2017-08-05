package com.sitech.acctmgr.atom.impl.acctmng;

import java.util.Map;

import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.acctmng.SHolidayOprInDTO;
import com.sitech.acctmgr.atom.dto.acctmng.SHolidayOprOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICredit;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.inter.acctmng.IHolidayOpr;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

@ParamTypes(@ParamType(c = SHolidayOprInDTO.class, m = "cfm", oc = SHolidayOprOutDTO.class))
public class SHolidayOpr extends AcctMgrBaseService implements IHolidayOpr{
	
	protected IUser user;
	protected IRecord record;
	protected IControl control;
	protected IGroup group;
	protected ICredit credit;

	@Override
	public OutDTO cfm(InDTO inParam) {
		
		SHolidayOprInDTO inDto = (SHolidayOprInDTO)inParam;
		String phoneNo = inDto.getPhoneNo();
		
		//查询用户信息
		UserInfoEntity uie = user.getUserInfo(phoneNo);
		long idNo = uie.getIdNo();
		String groupId = uie.getGroupId();

		//取系统流水
		long loginAccept=control.getSequence("SEQ_SYSTEM_SN");
		
		//取用户等级
		ChngroupRelEntity cgre = group.getRegionDistinct(groupId, "2", inDto.getProvinceId());
		String regionCode = cgre.getRegionCode();
		String regionGroup = cgre.getGroupId();
		
		int creditClass=0;
		Map<String, Object> creditMap = credit.getCreditInfo(idNo);
		if (creditMap.get("CREDIT_CODE") != null
				&& !creditMap.get("CREDIT_CODE").equals("")) {
			creditClass = Integer.parseInt(creditMap.get("CREDIT_CODE").toString());
		}
		if(creditClass<3){
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90033"), "用户信用等级不足,非目标客户群![等级="+creditClass+"]");
		}
		
		//记录节假日表
		record.saveHolidayUnStop(phoneNo, idNo, regionGroup,regionCode, String.valueOf(creditClass));
		
		//记录操作表
		LoginOprEntity loe = new LoginOprEntity();
		loe.setIdNo(idNo);
		loe.setLoginGroup(inDto.getGroupId());
		loe.setLoginNo(inDto.getLoginNo());
		loe.setLoginSn(loginAccept);
		loe.setOpCode(inDto.getOpCode());
		loe.setTotalDate(DateUtils.getCurDay());
		loe.setRemark("节假日免停办理");
		loe.setOpCode("0000");
		record.saveLoginOpr(loe);
		
		//TODO 发短信	
		
		
		SHolidayOprOutDTO outDto = new SHolidayOprOutDTO();
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
	 * @return the credit
	 */
	public ICredit getCredit() {
		return credit;
	}

	/**
	 * @param credit the credit to set
	 */
	public void setCredit(ICredit credit) {
		this.credit = credit;
	}

	
}