package com.sitech.acctmgr.atom.dto.detail;

import com.sitech.acctmgr.atom.domains.detail.PTOPEntity;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

import java.util.List;

public class SDetailCheckCheckOutDTO extends CommonOutDTO {

    private static final long serialVersionUID = -2355174758777880264L;
    @ParamDesc(path = "TARGET_LIST", cons = ConsType.CT001, type = "String", len = "", desc = "验证对端号结果列表", memo = "略")
    private List<PTOPEntity> outList;


    @Override
    public MBean encode() {
        MBean result = super.encode();
        result.setRoot(getPathByProperName("outList"), outList);

        return result;
    }

    public List<PTOPEntity> getOutList() {
        return outList;
    }

    public void setOutList(List<PTOPEntity> outList) {
        this.outList = outList;
    }
}