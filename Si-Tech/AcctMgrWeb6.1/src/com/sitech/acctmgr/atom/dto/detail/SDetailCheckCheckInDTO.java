package com.sitech.acctmgr.atom.dto.detail;

import com.sitech.acctmgr.atom.domains.detail.TargetPhoneEntity;
import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

import java.util.List;

public class SDetailCheckCheckInDTO extends CommonInDTO {

    private static final long serialVersionUID = 7717703483313095516L;

    @ParamDesc(path = "BUSI_INFO.PHONE_NO", cons = ConsType.CT001, desc = "服务号码", len = "40", type = "string", memo = "略")
    private String phoneno;

    @ParamDesc(path = "BUSI_INFO.BEGIN_TIME", cons = ConsType.CT001, desc = "开始时间", len = "14", type = "string", memo = "YYYYMMDDHHMISS")
    private String begintime;

    @ParamDesc(path = "BUSI_INFO.END_TIME", cons = ConsType.CT001, desc = "结束时间", len = "14", type = "string", memo = "YYYYMMDDHHMISS")
    private String endtime;

    @ParamDesc(path = "BUSI_INFO.PHONE_LIST", cons = ConsType.PLUS, desc = "对端号码列表", len = "14", type = "complex", memo = "略")
    private List<TargetPhoneEntity> phoneList = null;

    @Override
    public void decode(MBean arg0) {
        super.decode(arg0);
        phoneno = arg0.getStr(getPathByProperName("phoneno"));
        phoneList = arg0.getList(getPathByProperName("phoneList"), TargetPhoneEntity.class);
        begintime = arg0.getStr(getPathByProperName("begintime"));
        endtime = arg0.getStr(getPathByProperName("endtime"));
        if (begintime.length() == 6) {
            begintime = begintime + "01000000";
        }
        if (endtime.length() == 6) {
            int lastDay = DateUtils.getLastDayOfMonth(Integer.parseInt(endtime));
            endtime = endtime + String.format("%2d235959", lastDay);
        }

        if (begintime.length() == 8) {
            begintime = begintime + "000000";
        }
        if (endtime.length() == 8) {
            endtime = endtime + "235959";
        }

        log.debug("beginTime:" + begintime + ",endtime:" + endtime);
    }


    public String getPhoneno() {
        return phoneno;
    }

    public void setPhoneno(String phoneno) {
        this.phoneno = phoneno;
    }

    public String getBegintime() {
        return begintime;
    }

    public void setBegintime(String begintime) {
        this.begintime = begintime;
    }

    public String getEndtime() {
        return endtime;
    }

    public void setEndtime(String endtime) {
        this.endtime = endtime;
    }

    public List<TargetPhoneEntity> getPhoneList() {
        return phoneList;
    }

    public void setPhoneList(List<TargetPhoneEntity> phoneList) {
        this.phoneList = phoneList;
    }

}