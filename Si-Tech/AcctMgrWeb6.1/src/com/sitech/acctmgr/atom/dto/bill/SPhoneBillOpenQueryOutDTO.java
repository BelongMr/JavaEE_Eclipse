package com.sitech.acctmgr.atom.dto.bill;

import com.sitech.acctmgr.atom.domains.bill.PhoneBillOpenEntity;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

import java.util.List;

/**
 * Created by wangyla on 2017/6/5.
 */
public class SPhoneBillOpenQueryOutDTO extends CommonOutDTO {
    @ParamDesc(path = "BizCode", cons = ConsType.QUES, type = "String", len = "4", desc = "返回码", memo = "略")
    private String retCode;
    @ParamDesc(path = "BizDesc", cons = ConsType.QUES, type = "String", len = "256", desc = "错误信息描述", memo = "略")
    private String retMsg;
    @ParamDesc(path = "OprTime", cons = ConsType.QUES, type = "String", len = "14", desc = "结果对应时间戳", memo = "YYYYMMDDHH24MISS")
    private String queryTime;

    @ParamDesc(path = "BillRecs", cons = ConsType.PLUS, type = "complex", len = "256", desc = "帐单信息", memo = "列表")
    private List<PhoneBillOpenEntity> billList;

    @Override
    public MBean encode() {
        MBean result = super.encode();
        result.setRoot(getPathByProperName("retCode"), retCode);
        result.setRoot(getPathByProperName("retMsg"), retMsg);
        result.setRoot(getPathByProperName("queryTime"), queryTime);
        result.setRoot(getPathByProperName("billList"), billList);

        return result;
    }

    public String getRetCode() {
        return retCode;
    }

    public void setRetCode(String retCode) {
        this.retCode = retCode;
    }

    public String getRetMsg() {
        return retMsg;
    }

    public void setRetMsg(String retMsg) {
        this.retMsg = retMsg;
    }

    public String getQueryTime() {
        return queryTime;
    }

    public void setQueryTime(String queryTime) {
        this.queryTime = queryTime;
    }

    public List<PhoneBillOpenEntity> getBillList() {
        return billList;
    }

    public void setBillList(List<PhoneBillOpenEntity> billList) {
        this.billList = billList;
    }
}
