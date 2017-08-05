package com.sitech.acctmgr.atom.impl.query;

import com.sitech.acctmgr.atom.domains.base.ChngroupDictEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.GroupListEntity;
import com.sitech.acctmgr.atom.domains.query.GroupInfoEntity;
import com.sitech.acctmgr.atom.dto.query.*;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.inter.query.IDistrictRegion;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * Title: 区县代码
 * </p>
 * <p>
 * Description: 查询工号归属地市下的区县代码
 * </p>
 * <p>
 * Copyright: Copyright (c) 2015
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 *
 * @author wangyla
 * @version 1.0
 */
@ParamTypes({@ParamType(m = "getDistrictList", c = SDistrictRegionGetDistrictListInDTO.class, oc = SDistrictRegionGetDistrictListOutDTO.class),
        @ParamType(m = "getRegionList", c = SDistrictRegionGetRegionListInDTO.class, oc = SDistrictRegionGetRegionListOutDTO.class),
        @ParamType(c = SDistrictRegionQueryInDTO.class, m = "query", oc = SDistrictRegionQueryOutDTO.class),
        @ParamType(c = SGetGroupListInDTO.class, m = "getGroupList", oc = SGetGroupListOutDTO.class)})
public class SDistrictRegion extends AcctMgrBaseService implements IDistrictRegion {
    private IGroup group;

    @Override
    public OutDTO query(InDTO inParam) {

        long t1 = System.currentTimeMillis();
        SDistrictRegionQueryInDTO inDTO = (SDistrictRegionQueryInDTO) inParam;

        String loginGroupId = inDTO.getGroupId();

        // 取归属地市
        ChngroupRelEntity loginGroupInfo = group.getRegionDistinct(loginGroupId, "2", inDTO.getProvinceId());

        String regionCode = loginGroupInfo.getRegionCode();
        String regionName = loginGroupInfo.getRegionName();
        String regionGroupId = loginGroupInfo.getParentGroupId();

        // 获取区县组织机构代码
        //
        List<ChngroupDictEntity> disCodeList = group.getDistrictList(regionGroupId, inDTO.getProvinceId());

        SDistrictRegionQueryOutDTO outDTO = new SDistrictRegionQueryOutDTO();
        outDTO.setDisGroupList(disCodeList);
        outDTO.setRegionName(regionName);
        outDTO.setRegionCode(regionCode);

        long t2 = System.currentTimeMillis();
        log.debug("takes:" + (t2 - t1) + " ms");
        log.debug("outDto=" + outDTO.toJson());

        return outDTO;
    }

    @Override
    public OutDTO getRegionList(InDTO inParam) {
        long t1 = System.currentTimeMillis();
        SDistrictRegionGetRegionListInDTO inDto = (SDistrictRegionGetRegionListInDTO) inParam;
        log.debug("inDto:" + inDto.getMbean());
        String provinceId = inDto.getProvinceId();

        List<GroupInfoEntity> listCity = group.getRegionList(provinceId, null);
        SDistrictRegionGetRegionListOutDTO outDto = new SDistrictRegionGetRegionListOutDTO();
        outDto.setListCities(listCity);

        long t2 = System.currentTimeMillis();
        log.debug("takes:" + (t2 - t1) + " ms");
        log.debug("outDto:" + outDto.toJson());
        return outDto;
    }

    @Override
    public OutDTO getDistrictList(InDTO inParam) {

        SDistrictRegionGetDistrictListInDTO inDto = (SDistrictRegionGetDistrictListInDTO) inParam;
        String regionGroup = inDto.getRegionGroup();
        String provinceId = inDto.getProvinceId();

        List<ChngroupDictEntity> listDistricts = new ArrayList<ChngroupDictEntity>();

        listDistricts = group.getDistrictList(regionGroup, provinceId);
        listDistricts.toString();

        SDistrictRegionGetDistrictListOutDTO outDto = new SDistrictRegionGetDistrictListOutDTO();
        outDto.setListDistricts(listDistricts);

        return outDto;
    }

    @Override
    public OutDTO getGroupList(InDTO inParam) {
        SGetGroupListInDTO inDto = (SGetGroupListInDTO) inParam;
        String distinctGroup = inDto.getDisGroup();
        String provinceId = inDto.getProvinceId();
        List<GroupListEntity> groupList = group.getGroupList(distinctGroup, provinceId);
        SGetGroupListOutDTO outDto = new SGetGroupListOutDTO();
        outDto.setGroupList(groupList);
        log.debug("大小为：" + groupList.size());
        return outDto;
    }

    public IGroup getGroup() {
        return group;
    }

    public void setGroup(IGroup group) {
        this.group = group;
    }

}