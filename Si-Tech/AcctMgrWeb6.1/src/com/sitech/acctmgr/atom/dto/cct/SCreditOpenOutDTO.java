package com.sitech.acctmgr.atom.dto.cct;

import java.util.List;

import com.sitech.acctmgr.atom.domains.cct.CreditOpenEntity;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

public class SCreditOpenOutDTO extends CommonOutDTO{
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@ParamDesc(path = "BizCode", cons = ConsType.CT001, type = "String", len = "4", desc = "返回码", memo = "略")
    private String retCode;
    @ParamDesc(path = "BizDesc", cons = ConsType.QUES, type = "String", len = "256", desc = "错误信息描述", memo = "略")
    private String retMsg;
    @ParamDesc(path = "OprTime", cons = ConsType.CT001, type = "String", len = "14", desc = "结果对应时间戳", memo = "YYYYMMDDHH24MISS")
    private String queryTime;
    @ParamDesc(path = "StarLevel", cons = ConsType.CT001, type = "String", len = "2", desc = "用户星级", memo = "略")
    private String starLevel;
    /*
    @ParamDesc(path = "starScoreInfo", cons = ConsType.PLUS, type = "complex", len = "256", desc = "客户星级评分详情", memo = "列表")
    private List<CreditOpenEntity> creditList;
    */
    
    @Override
    public MBean encode() {
        MBean result = super.encode();
        
        result.setRoot(getPathByProperName("retCode"), retCode);
        result.setRoot(getPathByProperName("retMsg"), retMsg);
        result.setRoot(getPathByProperName("queryTime"), queryTime);
        result.setRoot(getPathByProperName("starLevel"), starLevel);
        //result.setRoot(getPathByProperName("creditList"), creditList);

        return result;
    }


	/**
	 * @return the queryTime
	 */
	public String getQueryTime() {
		return queryTime;
	}


	/**
	 * @param queryTime the queryTime to set
	 */
	public void setQueryTime(String queryTime) {
		this.queryTime = queryTime;
	}


	/**
	 * @return the starLevel
	 */
	public String getStarLevel() {
		return starLevel;
	}


	/**
	 * @param starLevel the starLevel to set
	 */
	public void setStarLevel(String starLevel) {
		this.starLevel = starLevel;
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