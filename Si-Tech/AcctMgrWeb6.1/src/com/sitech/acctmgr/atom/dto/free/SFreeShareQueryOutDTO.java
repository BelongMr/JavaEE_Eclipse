package com.sitech.acctmgr.atom.dto.free;

import com.sitech.acctmgr.atom.domains.free.Shared4GInfoEntity;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

import java.util.List;

/**
 * Created by wangyla on 2016/7/26.
 */
public class SFreeShareQueryOutDTO extends CommonOutDTO {
    @ParamDesc(path = "GPRS_TOTAL", desc = "用户所有应优惠流量", len = "14", cons = ConsType.CT001, type = "String", memo = "")
    private String gprsTotal;

    @ParamDesc(path = "GPRS_NATIVE_TOTAL", desc = "用户所有本地应优惠流量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsNativeTotal;
    @ParamDesc(path = "GPRS_NATIONAL_TOTAL", desc = "用户所有全国应优惠流量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsNationalTotal;

    @ParamDesc(path = "GPRS_NATIVE_USED", desc = "用户所有本地已优惠流量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsNativeUsed;
    @ParamDesc(path = "GPRS_NATIONAL_USED", desc = "用户所有全国已优惠流量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsNationalUsed;

    @ParamDesc(path = "GPRS_NATIVE_REMAIN", desc = "用户所有本地剩余优惠流量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsNativeRemain;
    @ParamDesc(path = "GPRS_NATIONAL_REMAIN", desc = "用户所有全国剩余优惠流量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsNationalRemain;

    @ParamDesc(path = "GPRS_MEMBER_SHARE_TOTAL", desc = "成员共享总流量", len = "14", cons = ConsType.CT001, type = "String", memo = "type_flag为1时，启用；单位：KB")
    private String gprsMemberShareTotal;
    @ParamDesc(path = "GPRS_MEMBER_SHARE_USED", desc = "成员共享已使用流量", len = "14", cons = ConsType.CT001, type = "String", memo = "type_flag为1时，启用；单位：KB")
    private String gprsMemberShareUsed;
    @ParamDesc(path = "GPRS_MEMBER_SHARE_REMAIN", desc = "成员共享剩余流量", len = "14", cons = ConsType.CT001, type = "String", memo = "type_flag为1时，启用；单位：KB")
    private String gprsMemberShareRemain;

    @ParamDesc(path = "GPRS_MEMBER_NATIVE_TOTAL", desc = "副卡用户非共享的本地已使用流量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsMemberNativeTotal;
    @ParamDesc(path = "GPRS_MEMBER_NATIONAL_TOTAL", desc = "副卡用户非共享的全国已使用流量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsMemberNationalTotal;

    @ParamDesc(path = "GPRS_SHARED_TOTAL", desc = "主卡总的应优惠共享流量", len = "14", cons = ConsType.CT001, type = "String", memo = "type_flag为0时，启用；单位：KB")
    private String gprsSharedTotal;
    @ParamDesc(path = "GPRS_SHARED_USED", desc = "已使用的共享流量", len = "14", cons = ConsType.CT001, type = "String", memo = "type_flag为0时，启用；单位：KB")
    private String gprsSharedUsed;
    @ParamDesc(path = "GPRS_SHARED_REMAIN", desc = "剩余的共享流量", len = "14", cons = ConsType.CT001, type = "String", memo = "type_flag为0时，启用；单位：KB")
    private String gprsSharedRemain;

    @ParamDesc(path = "GPRS_MEMBER_NATIVE_SHARED_TOTAL", desc = "成员本地共享总流量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsMemberNativeSharedTotal;
    @ParamDesc(path = "GPRS_MEMBER_NATIVE_SHARED_USED", desc = "成员本地共享总使用量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsMemberNativeSharedUsed;
    @ParamDesc(path = "GPRS_MEMBER_NATIVE_SHARED_REMAIN", desc = "成员本地共享剩余量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsMemberNativeSharedRemain;

    @ParamDesc(path = "GPRS_MEMBER_NATIONAL_SHARED_TOTAL", desc = "成员全国共享总流量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsMemberNationalSharedTotal;
    @ParamDesc(path = "GPRS_MEMBER_NATIONAL_SHARED_USED", desc = "成员全国共享总使用量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsMemberNationalSharedUsed;
    @ParamDesc(path = "GPRS_MEMBER_NATIONAL_SHARED_REMAIN", desc = "成员全国共享剩余量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsMemberNationalSharedRemain;

    @ParamDesc(path = "GPRS_MEMBER_REALFREE_TOTAL", desc = "副卡总的优惠量", len = "14", cons = ConsType.CT001, type = "String", memo = "单位：KB")
    private String gprsMemberRealFreeTotal;

    @ParamDesc(path = "TYPE_FLAG", desc = "流量共享开通状态", len = "2", cons = ConsType.CT001, type = "String", memo = "0：主卡；1：副卡；2：未开通(默认)")
    private String typeFlag;

    @ParamDesc(path = "MEMBER_USE_LIST", desc = "家庭成员共享流量使用明细", len = "", cons = ConsType.CT001, type = "complex", memo = "列表List;节点流量单位KB")
    private List<Shared4GInfoEntity> memUseList;

    @Override
    public MBean encode() {
        MBean result = super.encode();
        result.setRoot(getPathByProperName("gprsTotal"), gprsTotal);
        result.setRoot(getPathByProperName("gprsNativeTotal"), gprsNativeTotal);
        result.setRoot(getPathByProperName("gprsNativeUsed"), gprsNativeUsed);
        result.setRoot(getPathByProperName("gprsNativeRemain"), gprsNativeRemain);
        result.setRoot(getPathByProperName("gprsNationalTotal"), gprsNationalTotal);
        result.setRoot(getPathByProperName("gprsNationalUsed"), gprsNationalUsed);
        result.setRoot(getPathByProperName("gprsNationalRemain"), gprsNationalRemain);
        result.setRoot(getPathByProperName("gprsSharedTotal"), gprsSharedTotal);
        result.setRoot(getPathByProperName("gprsSharedUsed"), gprsSharedUsed);
        result.setRoot(getPathByProperName("gprsSharedRemain"), gprsSharedRemain);
        result.setRoot(getPathByProperName("gprsMemberNationalTotal"), gprsMemberNationalTotal);
        result.setRoot(getPathByProperName("gprsMemberNativeTotal"), gprsMemberNativeTotal);
        result.setRoot(getPathByProperName("gprsMemberShareTotal"), gprsMemberShareTotal);
        result.setRoot(getPathByProperName("gprsMemberShareUsed"), gprsMemberShareUsed);
        result.setRoot(getPathByProperName("gprsMemberShareRemain"), gprsMemberShareRemain);
        result.setRoot(getPathByProperName("gprsMemberNativeSharedTotal"), gprsMemberNativeSharedTotal);
        result.setRoot(getPathByProperName("gprsMemberNativeSharedUsed"), gprsMemberNativeSharedUsed);
        result.setRoot(getPathByProperName("gprsMemberNativeSharedRemain"), gprsMemberNativeSharedRemain);
        result.setRoot(getPathByProperName("gprsMemberNationalSharedTotal"), gprsMemberNationalSharedTotal);
        result.setRoot(getPathByProperName("gprsMemberNationalSharedUsed"), gprsMemberNationalSharedUsed);
        result.setRoot(getPathByProperName("gprsMemberNationalSharedRemain"), gprsMemberNationalSharedRemain);
        result.setRoot(getPathByProperName("gprsMemberRealFreeTotal"), gprsMemberRealFreeTotal);
        result.setRoot(getPathByProperName("typeFlag"), typeFlag);
        result.setRoot(getPathByProperName("memUseList"), memUseList);
        return result;
    }

    public String getGprsTotal() {
        return gprsTotal;
    }

    public void setGprsTotal(String gprsTotal) {
        this.gprsTotal = gprsTotal;
    }

    public String getGprsNativeTotal() {
        return gprsNativeTotal;
    }

    public void setGprsNativeTotal(String gprsNativeTotal) {
        this.gprsNativeTotal = gprsNativeTotal;
    }

    public String getGprsNationalTotal() {
        return gprsNationalTotal;
    }

    public void setGprsNationalTotal(String gprsNationalTotal) {
        this.gprsNationalTotal = gprsNationalTotal;
    }

    public String getGprsNativeUsed() {
        return gprsNativeUsed;
    }

    public void setGprsNativeUsed(String gprsNativeUsed) {
        this.gprsNativeUsed = gprsNativeUsed;
    }

    public String getGprsNationalUsed() {
        return gprsNationalUsed;
    }

    public void setGprsNationalUsed(String gprsNationalUsed) {
        this.gprsNationalUsed = gprsNationalUsed;
    }

    public String getGprsNativeRemain() {
        return gprsNativeRemain;
    }

    public void setGprsNativeRemain(String gprsNativeRemain) {
        this.gprsNativeRemain = gprsNativeRemain;
    }

    public String getGprsNationalRemain() {
        return gprsNationalRemain;
    }

    public void setGprsNationalRemain(String gprsNationalRemain) {
        this.gprsNationalRemain = gprsNationalRemain;
    }

    public String getGprsMemberShareTotal() {
        return gprsMemberShareTotal;
    }

    public void setGprsMemberShareTotal(String gprsMemberShareTotal) {
        this.gprsMemberShareTotal = gprsMemberShareTotal;
    }

    public String getGprsMemberShareUsed() {
        return gprsMemberShareUsed;
    }

    public void setGprsMemberShareUsed(String gprsMemberShareUsed) {
        this.gprsMemberShareUsed = gprsMemberShareUsed;
    }

    public String getGprsMemberShareRemain() {
        return gprsMemberShareRemain;
    }

    public void setGprsMemberShareRemain(String gprsMemberShareRemain) {
        this.gprsMemberShareRemain = gprsMemberShareRemain;
    }

    public String getGprsMemberNativeTotal() {
        return gprsMemberNativeTotal;
    }

    public void setGprsMemberNativeTotal(String gprsMemberNativeTotal) {
        this.gprsMemberNativeTotal = gprsMemberNativeTotal;
    }

    public String getGprsMemberNationalTotal() {
        return gprsMemberNationalTotal;
    }

    public void setGprsMemberNationalTotal(String gprsMemberNationalTotal) {
        this.gprsMemberNationalTotal = gprsMemberNationalTotal;
    }

    public String getGprsSharedTotal() {
        return gprsSharedTotal;
    }

    public void setGprsSharedTotal(String gprsSharedTotal) {
        this.gprsSharedTotal = gprsSharedTotal;
    }

    public String getGprsSharedUsed() {
        return gprsSharedUsed;
    }

    public void setGprsSharedUsed(String gprsSharedUsed) {
        this.gprsSharedUsed = gprsSharedUsed;
    }

    public String getGprsSharedRemain() {
        return gprsSharedRemain;
    }

    public void setGprsSharedRemain(String gprsSharedRemain) {
        this.gprsSharedRemain = gprsSharedRemain;
    }

    public String getGprsMemberNativeSharedTotal() {
        return gprsMemberNativeSharedTotal;
    }

    public void setGprsMemberNativeSharedTotal(String gprsMemberNativeSharedTotal) {
        this.gprsMemberNativeSharedTotal = gprsMemberNativeSharedTotal;
    }

    public String getGprsMemberNativeSharedUsed() {
        return gprsMemberNativeSharedUsed;
    }

    public void setGprsMemberNativeSharedUsed(String gprsMemberNativeSharedUsed) {
        this.gprsMemberNativeSharedUsed = gprsMemberNativeSharedUsed;
    }

    public String getGprsMemberNativeSharedRemain() {
        return gprsMemberNativeSharedRemain;
    }

    public void setGprsMemberNativeSharedRemain(String gprsMemberNativeSharedRemain) {
        this.gprsMemberNativeSharedRemain = gprsMemberNativeSharedRemain;
    }

    public String getGprsMemberNationalSharedTotal() {
        return gprsMemberNationalSharedTotal;
    }

    public void setGprsMemberNationalSharedTotal(String gprsMemberNationalSharedTotal) {
        this.gprsMemberNationalSharedTotal = gprsMemberNationalSharedTotal;
    }

    public String getGprsMemberNationalSharedUsed() {
        return gprsMemberNationalSharedUsed;
    }

    public void setGprsMemberNationalSharedUsed(String gprsMemberNationalSharedUsed) {
        this.gprsMemberNationalSharedUsed = gprsMemberNationalSharedUsed;
    }

    public String getGprsMemberNationalSharedRemain() {
        return gprsMemberNationalSharedRemain;
    }

    public void setGprsMemberNationalSharedRemain(String gprsMemberNationalSharedRemain) {
        this.gprsMemberNationalSharedRemain = gprsMemberNationalSharedRemain;
    }

    public String getGprsMemberRealFreeTotal() {
        return gprsMemberRealFreeTotal;
    }

    public void setGprsMemberRealFreeTotal(String gprsMemberRealFreeTotal) {
        this.gprsMemberRealFreeTotal = gprsMemberRealFreeTotal;
    }

    public String getTypeFlag() {
        return typeFlag;
    }

    public void setTypeFlag(String typeFlag) {
        this.typeFlag = typeFlag;
    }

    public List<Shared4GInfoEntity> getMemUseList() {
        return memUseList;
    }

    public void setMemUseList(List<Shared4GInfoEntity> memUseList) {
        this.memUseList = memUseList;
    }
}
