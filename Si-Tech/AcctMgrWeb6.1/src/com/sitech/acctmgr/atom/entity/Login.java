package com.sitech.acctmgr.atom.entity;

import java.util.HashMap;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.jcf.core.exception.BusiException;

/**
 *
 * <p>
 * Title: 公共工号类
 * </p>
 * <p>
 * Description: 存取工号相关查询等方法
 * </p>
 * <p>
 * Copyright: Copyright (c) 2014
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 * 
 * @author yankma
 * @version 1.0
 */

@SuppressWarnings("unchecked")
public class Login extends BaseBusi implements ILogin {
	private IGroup group;
	/* (non-Javadoc)
	 * 
	 * @see com.sitech.acctmgr.atom.entity.inter.ILogin#getLoginInfo(java.lang.String) */
	@Override
	public LoginEntity getLoginInfo(String sLoginNo, String provinceId, boolean flag) {

		Map<String, Object> inParamMap; // 临时变量入参转为map

		// 根据工号取group_id
		inParamMap = new HashMap<String, Object>();
		inParamMap.put("LOGIN_NO", sLoginNo);
		inParamMap.put("PROVINCE_ID", provinceId);
		LoginEntity result = (LoginEntity) baseDao.queryForObject("bs_loginmsg_dict.qByLoginNo", inParamMap);
		if (flag) {
			if (result == null) {
				log.debug("取工号信息错误!LOGIN_NO: " + sLoginNo);
				throw new BusiException(AcctMgrError.getErrorCode("0000", "00025"), "取工号信息错误!LOGIN_NO: " + sLoginNo);
			}
		}

		return result;
	}

	@Override
	public LoginEntity getLoginInfo(String sLoginNo, String provinceId) {
		return getLoginInfo(sLoginNo, provinceId, true);

	}

	@Override
	public String getRegionCode(String loginNo, String provinceId) {
		// 查询工号所在地市
		LoginEntity loginInfo = getLoginInfo(loginNo, "230000", true);
		ChngroupRelEntity groupInfo = group.getGroupInfo(loginInfo.getGroupId(), "230000");
		String regionCode = groupInfo.getRegionCode();
		return regionCode;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

}