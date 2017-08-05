package com.sitech.acctmgr.atom.dto.feeqry;

import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

public class SBalanceOpenOutDTO extends CommonOutDTO{
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@ParamDesc(path = "BizCode", cons = ConsType.CT001, type = "String", len = "10", desc = "返回码", memo = "略")
    private String retCode;
    @ParamDesc(path = "BizDesc", cons = ConsType.QUES, type = "String", len = "256", desc = "错误信息描述", memo = "略")
    private String retMsg;
    /*
    @ParamDesc(path = "OprTime", cons = ConsType.QUES, type = "String", len = "14", desc = "结果对应时间戳", memo = "YYYYMMDDHH24MISS")
    private String queryTime;
    */
    @ParamDesc(path = "CurFeeTotal", cons = ConsType.QUES, type = "String", len = "12", desc = "账户总余额", memo = "单位：元")
    private String curFeeTotal;
    @ParamDesc(path = "Balance", cons = ConsType.CT001, type = "String", len = "9", desc = "帐户可用余额", memo = "单位：元")
    private String balance;
    /*
    @ParamDesc(path = "ValidDate", cons = ConsType.QUES, type = "String", len = "8", desc = "有效期", memo = "YYYYMMDD")
    private String validDate;
    */
    
    @Override
    public MBean encode() {
        MBean result = super.encode();
        
        result.setRoot(getPathByProperName("retCode"), retCode);
        result.setRoot(getPathByProperName("retMsg"), retMsg);
        //result.setRoot(getPathByProperName("queryTime"), queryTime);
        result.setRoot(getPathByProperName("curFeeTotal"), curFeeTotal);
        result.setRoot(getPathByProperName("balance"), balance);
        //result.setRoot(getPathByProperName("validDate"), validDate);

        return result;
    }

	/**
	 * @return the balance
	 */
	public String getBalance() {
		return balance;
	}

	/**
	 * @param balance the balance to set
	 */
	public void setBalance(String balance) {
		this.balance = balance;
	}

	/**
	 * @return the curFeeTotal
	 */
	public String getCurFeeTotal() {
		return curFeeTotal;
	}

	/**
	 * @param curFeeTotal the curFeeTotal to set
	 */
	public void setCurFeeTotal(String curFeeTotal) {
		this.curFeeTotal = curFeeTotal;
	}

	/**
	 * @return the retCode
	 */
	public String getRetCode() {
		return retCode;
	}

	/**
	 * @param retCode the retCode to set
	 */
	public void setRetCode(String retCode) {
		this.retCode = retCode;
	}

	/**
	 * @return the retMsg
	 */
	public String getRetMsg() {
		return retMsg;
	}

	/**
	 * @param retMsg the retMsg to set
	 */
	public void setRetMsg(String retMsg) {
		this.retMsg = retMsg;
	}

}