package com.sitech.acctmgr.atom.dto.acctmng;

import com.sitech.acctmgr.common.dto.CommonInDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

/**
 * Created by wangyla on 2016/7/5.
 */
public class SCollectionOrderQueryInDTO extends CommonInDTO{
    private static final long serialVersionUID = -1L;

    @ParamDesc(path = "BUSI_INFO.DIS_GROUP_ID", cons = ConsType.CT001, desc = "区县归属", len = "10", type = "string", memo = "略")
    private String disGroupId = "";
    @ParamDesc(path = "BUSI_INFO.BILL_CYCLE", cons = ConsType.CT001, desc = "托收帐期", len = "6", type = "string", memo = "略")
    private int billCycle = 0;
    @ParamDesc(path = "BUSI_INFO.BEGIN_PRINT_NO", cons = ConsType.CT001, desc = "打印起始单号", len = "5", type = "string", memo = "略")
    private int beginPrintNo = 0;
    @ParamDesc(path = "BUSI_INFO.END_PRINT_NO", cons = ConsType.CT001, desc = "打印结束单号", len = "5", type = "string", memo = "略")
    private int endPrintNo = 0;
    @ParamDesc(path = "BUSI_INFO.BEGIN_BANK_CODE", cons = ConsType.CT001, desc = "开始银行代码", len = "12", type = "string", memo = "略")
    private String beginBankCode = "";
    @ParamDesc(path = "BUSI_INFO.END_BANK_CODE", cons = ConsType.CT001, desc = "结束银行代码", len = "12", type = "string", memo = "略")
    private String endBankCode = "";

    @ParamDesc(path = "BUSI_INFO.PRINT_DATE", cons = ConsType.CT001, desc = "打印日期", len = "8", type = "string", memo = "略")
    private String printDate = "";

    @Override
    public void decode(MBean arg0) {
        super.decode(arg0);
        groupId = arg0.getStr(getPathByProperName("groupId"));
        disGroupId = arg0.getStr(getPathByProperName("disGroupId"));
        billCycle = Integer.parseInt(arg0.getStr(getPathByProperName("billCycle")));
        beginBankCode = arg0.getStr(getPathByProperName("beginBankCode"));
        endBankCode = arg0.getStr(getPathByProperName("endBankCode"));
        beginPrintNo = Integer.parseInt(arg0.getStr(getPathByProperName("beginPrintNo")));
        endPrintNo = Integer.parseInt(arg0.getStr(getPathByProperName("endPrintNo")));
        printDate = arg0.getStr(getPathByProperName("printDate"));
        
        if(beginBankCode.equals("")){
            beginBankCode = "0";
        }

        if(endBankCode.equals("")){
            endBankCode = "99999";
        }
    }

    public String getDisGroupId() {
        return disGroupId;
    }

    public void setDisGroupId(String disGroupId) {
        this.disGroupId = disGroupId;
    }

    public int getBillCycle() {
        return billCycle;
    }

    public void setBillCycle(int billCycle) {
        this.billCycle = billCycle;
    }

    public int getBeginPrintNo() {
        return beginPrintNo;
    }

    public void setBeginPrintNo(int beginPrintNo) {
        this.beginPrintNo = beginPrintNo;
    }

    public int getEndPrintNo() {
        return endPrintNo;
    }

    public void setEndPrintNo(int endPrintNo) {
        this.endPrintNo = endPrintNo;
    }

    public String getBeginBankCode() {
        return beginBankCode;
    }

    public void setBeginBankCode(String beginBankCode) {
        this.beginBankCode = beginBankCode;
    }

    public String getEndBankCode() {
        return endBankCode;
    }

    public void setEndBankCode(String endBankCode) {
        this.endBankCode = endBankCode;
    }

    public String getPrintDate() {
        return printDate;
    }

    public void setPrintDate(String printDate) {
        this.printDate = printDate;
    }
}
