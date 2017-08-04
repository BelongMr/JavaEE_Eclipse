package com.sitech.acctmgr.atom.entity;

import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupDictEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.GroupEntity;
import com.sitech.acctmgr.atom.domains.base.GroupListEntity;
import com.sitech.acctmgr.atom.domains.query.GroupInfoEntity;
import com.sitech.acctmgr.atom.domains.user.GroupchgInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.util.DateUtil;
import org.apache.commons.lang.StringUtils;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

/**
 * <p>
 * Title: 公共业务-归属类
 * </p>
 * <p>
 * Description: 公共业务-归属类
 * </p>
 * <p>
 * Copyright: Copyright (c) 2014
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 *
 * @author
 * @version 1.0
 */
@SuppressWarnings("unchecked")
public class Group extends BaseBusi implements IGroup {

    private IUser user;
    private IAccount account;

    /* (non-Javadoc)
     *
     * @see com.sitech.acctmgr.atom.entity.inter.IGroup#getChgGroup(java.util.Map) */
    @Override
    public GroupchgInfoEntity getChgGroup(String phoneNo, Long idNo, Long contractNo) {

        String sGroupIdPhone = "";
        String sGroupIdPay = "";
        String sGroupId = "";
        String sEffDate = "";
        String sCurDate = DateUtil.format(new Date(), "yyyyMMdd");

        Map<String, Object> mInParamTmp = new HashMap<String, Object>();

		/* 根据账户或用户查询用户归属 */
        if (contractNo != null && contractNo > 0) {
            // mOutParamTmp.clear();
            ContractInfoEntity cie = account.getConInfo(contractNo);
            sGroupIdPhone = cie.getGroupId();
        } else {
            UserInfoEntity uieResult = user.getUserEntity(idNo, phoneNo, null, true);
            sGroupIdPhone = uieResult.getGroupId();
        }

		/* 确认用户当前归属 */
        if (idNo != null && idNo > 0) {
            safeAddToMap(mInParamTmp, "ID_NO", idNo);
        }
        if (contractNo != null && contractNo > 0) {
            safeAddToMap(mInParamTmp, "CONTRACT_NO", contractNo);
        }
        if (StringUtils.isNotEmpty(phoneNo)) {
            safeAddToMap(mInParamTmp, "PHONE_NO", phoneNo);
        }

        GroupchgInfoEntity gcie = (GroupchgInfoEntity) baseDao.queryForObject("ur_groupchg_info.qGroupChgInfo", mInParamTmp);
        if (gcie == null) {
            sGroupId = sGroupIdPhone;
            sGroupIdPay = sGroupIdPhone;
        } else {
            sGroupId = gcie.getInGroup();
            sEffDate = gcie.getEffDate();
            String eff_dateTmp = sEffDate.substring(0, 6).toString();
            String cur_dateTmp = sCurDate.substring(0, 6).toString();
            String cur_dateMonTmp = sEffDate.substring(6, 8);

            if (eff_dateTmp.equals(cur_dateTmp) && !"01".equals(cur_dateMonTmp)) {
                sGroupIdPay = sGroupIdPhone;
            } else {
                sGroupIdPay = sGroupId;
            }
        }

        GroupchgInfoEntity result = new GroupchgInfoEntity();
        result.setGroupIdPhone(sGroupIdPhone);
        result.setGroupIdPay(sGroupIdPay);
        result.setGroupId(sGroupId);
        return result;
    }

    @Override
    public ChngroupRelEntity getRegionDistinct(String groupId, String parentLevel, String provinceId) {
        return this.getRegionDistinct(groupId, parentLevel, provinceId, true);
    }

    /* (non-Javadoc)
     *
     * @see com.sitech.acctmgr.atom.entity.inter.IGroup#getRegionDistinct(java.util .Map) */
    @Override
    public ChngroupRelEntity getRegionDistinct(String groupId, String parentLevel, String provinceId, boolean boo) {

        long inParentLevel = 2;

        if (StringUtils.isEmpty(groupId)) {
            throw new BusiException(AcctMgrError.getErrorCode("0000", "00042"), "归属查询group_id不能为空");
        }

        Map<String, Object> inParamMap = new HashMap<String, Object>();

        if (StringUtils.isNotEmpty(groupId)) {
            safeAddToMap(inParamMap, "GROUP_ID", groupId);
        }
        if (StringUtils.isNotEmpty(parentLevel)) {
            safeAddToMap(inParamMap, "PARENT_LEVEL", Integer.parseInt(parentLevel));
        } else {
            safeAddToMap(inParamMap, "PARENT_LEVEL", inParentLevel);
        }
        safeAddToMap(inParamMap, "PROVINCE_ID", provinceId);

        ChngroupRelEntity result = (ChngroupRelEntity) baseDao.queryForObject("bs_chngroup_rel.qRegionByGroupId", inParamMap);
        if (boo && result == null) {
            throw new BusiException(AcctMgrError.getErrorCode("0000", "20006"), "根据GROUP_ID取地市信息出错!");
        }

        return result;
    }

    /* (non-Javadoc)
     *
     * @see com.sitech.acctmgr.atom.entity.inter.IGroup#getRegionId(java.util.Map) */
    @Override
    public GroupEntity getGroupInfo(String loginGroupId, String userGroupId, String provinceId) {

        String sLoginRegionId = "";
        String sLoginRegionName = "";
        String sUserRegionId = "";
        String sUserRegionName = "";
        String sRegionFlag = "N";

        Map<String, Object> mOutParam = new HashMap<String, Object>();

        // 工号归属
        ChngroupRelEntity cgreLogin = this.getRegionDistinct(loginGroupId, null, provinceId);
        if (cgreLogin == null) {
            throw new BaseException(AcctMgrError.getErrorCode("8011", "10001"), "取工号归属地市出错");
        }
        sLoginRegionId = cgreLogin.getRegionCode();
        sLoginRegionName = cgreLogin.getRegionName();

        // 用户归属
        ChngroupRelEntity cgreUser = this.getRegionDistinct(userGroupId, null, provinceId);
        if (cgreUser == null) {
            throw new BusiException(AcctMgrError.getErrorCode("8010", "10002"), "取用户归属地市出错");
        }
        sUserRegionId = cgreUser.getRegionCode();
        sUserRegionName = cgreUser.getRegionName();

        if (sLoginRegionId.equals(sUserRegionId)) {
            sRegionFlag = "Y";
        }

        GroupEntity ge = new GroupEntity();
        ge.setLoginRegion(sLoginRegionId);
        ge.setLoginRegionName(sLoginRegionName);
        ge.setUserRegion(sUserRegionId);
        ge.setUserRegionName(sUserRegionName);
        ge.setRegionFlag(sRegionFlag);

        log.info("--------------->sRegionFlag: " + sRegionFlag + " ,LOGIN[" + loginGroupId + "," + sLoginRegionId + "]-USER[" + userGroupId + ","
                + sUserRegionId + "]");
        return ge;
    }

    @Override
    public List<ChngroupDictEntity> getDistrictList(String regionGroupId, String provinceId) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "PARENT_GROUP_ID", regionGroupId);
        safeAddToMap(inMap, "PROVINCE_ID", provinceId);
        safeAddToMap(inMap, "DENORM_LEVEL", 1);
        return (List<ChngroupDictEntity>) baseDao.queryForList("bs_chngroup_dict.qDisGroupByCityGroup", inMap);
    }

    @Override
    public List<GroupInfoEntity> getRegionList(String provinceId, String regionCode) {
        Map<String, Object> inMap = new HashMap<>();
        if (StringUtils.isNotEmpty(regionCode)) {
            safeAddToMap(inMap, "REGION_ID", Integer.parseInt(regionCode));
        }
        safeAddToMap(inMap, "PROVINCE_ID", provinceId);
        List<GroupInfoEntity> list = baseDao.queryForList("bs_chngroup_dict.qDisGroupCity", inMap);
        return list;
    }

    @Override
    public int getCurrentLevel(String groupId, String provinceId) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("GROUP_ID", groupId);
        inMap.put("PROVINCE_ID", provinceId);
        int level = 0;
        ChngroupDictEntity chnInfo = (ChngroupDictEntity) baseDao.queryForObject("bs_chngroup_dict.qChngInfoByGroupId", inMap);
        if (chnInfo != null) {
            level = chnInfo.getRootDistance();
        }
        return level;
    }

    @Override
    public Map<String, Object> getCurrentGroupInfo(String groupId, String proviceId) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();

        inMap.put("GROUP_ID", groupId);
        inMap.put("PROVINCE_ID", proviceId);
        ChngroupDictEntity chnInfo = (ChngroupDictEntity) baseDao.queryForObject("bs_chngroup_dict.qChngInfoByGroupId", inMap);

        outMap.put("GROUP_NAME", chnInfo.getGroupName());
        outMap.put("GROUP_ID", groupId);
        outMap.put("CURRENT_LEVEL", chnInfo.getRootDistance());
        return outMap;
    }

    @Override
    public List<GroupListEntity> getGroupList(String distinctGroup, String provinceId) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("CURRENT_LEVEL", "4");
        inMap.put("PARENT_LEVEL", "3");
        inMap.put("PARENT_GROUP_ID", distinctGroup);
        inMap.put("PROVINCE_ID", provinceId);
        List<GroupListEntity> groupList = baseDao.queryForList("bs_chngroup_rel.qGroupInfo", inMap);
        return groupList;
    }

    @Override
    public ChngroupRelEntity getGroupInfo(String groupId, String provinceId) {
        // 工号归属
        ChngroupRelEntity groupInfo = this.getRegionDistinct(groupId, null, provinceId);
        if (groupInfo == null) {
            throw new BaseException(AcctMgrError.getErrorCode("8011", "10001"), "取工号归属地市出错");
        }
        return groupInfo;
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
     * @return the account
     */
    public IAccount getAccount() {
        return account;
    }

    /**
     * @param account the account to set
     */
    public void setAccount(IAccount account) {
        this.account = account;
    }
}
