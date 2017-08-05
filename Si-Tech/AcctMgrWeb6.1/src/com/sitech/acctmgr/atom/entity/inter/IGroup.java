package com.sitech.acctmgr.atom.entity.inter;

import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.base.ChngroupDictEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.GroupEntity;
import com.sitech.acctmgr.atom.domains.base.GroupListEntity;
import com.sitech.acctmgr.atom.domains.query.GroupInfoEntity;
import com.sitech.acctmgr.atom.domains.user.GroupchgInfoEntity;

/**
 * <p>
 * Title:
 * </p>
 * <p>
 * Description:
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
public interface IGroup {
	/**
	 * 名称：根据组织代码取地市名称等相关信息
	 *
	 * @param groupId
	 *            组织代码（必选）
	 * @param parentLevel
	 *            父节点级别，默认为2地市级别（可选）
	 * @param provinceId
	 * @return GROUP_ID: 组织代码<br/>
	 *         PRE_GROUP_ID: 上级组织代码<br/>
	 *         REGION_CODE: 地市代码<br/>
	 *         REGION_NAME: 地市名称<br/>
	 */
	ChngroupRelEntity getRegionDistinct(String groupId, String parentLevel, String provinceId);

	ChngroupRelEntity getRegionDistinct(String groupId, String parentLevel, String provinceId, boolean boo);

	/**
	 * 名称：取用户归属
	 *
	 * @param phoneNo
	 * @param idNo
	 * @param contractNo
	 * @return
	 */
	GroupchgInfoEntity getChgGroup(String phoneNo, Long idNo, Long contractNo);

	/**
	 * 功能：根据GROUP_ID取工号和用户的地市信息，判断是否跨区
	 *
	 * @param loginGroupId
	 *            工号组织代码
	 * @param userGroupId
	 *            用户组织代码
	 * @param provinceId
	 *            省份代码
	 * @return LOGIN_REGION 工号归属地市 <br>
	 *         LOGIN_REGION_NAME 工号归属地市名称<br>
	 *         USER_REGION 工号归属地市<br>
	 *         USER_REGION_NAME 工号归属地市名称<br>
	 *         REGION_FLAG Y 同地市，N 跨地市<br>
	 */
	GroupEntity getGroupInfo(String loginGroupId, String userGroupId, String provinceId);

	/**
	 * 功能：根据地市groupId获取其下的区县列表信息
	 *
	 * @param regionGroupId
	 * @param provinceId
	 * @return
	 */
	List<ChngroupDictEntity> getDistrictList(String regionGroupId, String provinceId);

	/**
	 * 名称：查询某省的地市列表
	 * 
	 * @param provinceId
	 * @param regionCode
	 * @return
	 */
	List<GroupInfoEntity> getRegionList(String provinceId, String regionCode);

	int getCurrentLevel(String groupId, String provinceId);

	/**
	 * 功能：根据groupId获取其名称和当前级别
	 * 
	 * @author liuhl
	 * @param groupId
	 * @param proviceId
	 * @return
	 */
	Map<String, Object> getCurrentGroupInfo(String groupId, String proviceId);

	/**
	 * 查询营业厅列表
	 * 
	 * @author liuhl_bj
	 * @param distinctGroup
	 * @param provinceId
	 * @return
	 */
	List<GroupListEntity> getGroupList(String distinctGroup, String provinceId);

	/**
	 * 获取归属
	 * 
	 * @author liuhl_bj
	 * @param groupId
	 * @param provinceId
	 * @return
	 */
	ChngroupRelEntity getGroupInfo(String groupId, String provinceId);

}