package com.sitech.acctmgr.atom.domains.bill;

import java.io.Serializable;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;

/**
 * 功能：对套餐推荐信息进行封装
 */
public class SchemeInfoEntity implements Serializable {

	private static final long serialVersionUID = 1L;

	@JSONField(name = "TIPS")
	@ParamDesc(path="TIPS", cons=ConsType.CT001, type="string", len="256", desc="温馨提示", memo="")
    private String tips;
    
	@JSONField(name = "ADDED_TIPS")
    @ParamDesc(path="ADDED_TIPS", cons=ConsType.CT001, type="string", len="256", desc="附加提醒", memo="")
    private String addedTips;
    
	@JSONField(name = "PRC_SCHEMA_INFO")
    @ParamDesc(path="PRC_SCHEMA_INFO", cons=ConsType.CT001, type="string", len="256", desc="资费推荐信息", memo="")
    private String prcSchemeInfo;
    
	@JSONField(name = "GOODS_PRC_DESC")
    @ParamDesc(path = "GOODS_PRC_DESC", cons = ConsType.CT001, type = "String", len = "20", desc = "资费描述", memo = "略")
    private String goodsPrcDesc;
    
    @JSONField(name = "OUT_SET_FLOW")
    @ParamDesc(path = "OUT_SET_FLOW", cons = ConsType.CT001, type = "String", len = "20", desc = "超出流量", memo = "略")
    private String outSetFlow;
    
    @JSONField(name = "PRC_ID")
    @ParamDesc(path = "PRC_ID", cons = ConsType.CT001, type = "String", len = "20", desc = "资费代码", memo = "略")
    private String prcId;
    
    @JSONField(name = "PRC_TYPE")
    @ParamDesc(path = "PRC_TYPE", cons = ConsType.CT001, type = "String", len = "20", desc = "资费类型", memo = "略")
    private String prcType;
    
    @JSONField(name = "PRC_NAME")
    @ParamDesc(path = "PRC_NAME", cons = ConsType.CT001, type = "String", len = "20", desc = "资费名称", memo = "略")
    private String prcName;

	public String getGoodsPrcDesc() {
		return goodsPrcDesc;
	}

	public void setGoodsPrcDesc(String goodsPrcDesc) {
		this.goodsPrcDesc = goodsPrcDesc;
	}

	public String getOutSetFlow() {
		return outSetFlow;
	}

	public void setOutSetFlow(String outSetFlow) {
		this.outSetFlow = outSetFlow;
	}

	public String getPrcId() {
		return prcId;
	}

	public void setPrcId(String prcId) {
		this.prcId = prcId;
	}

	public String getPrcType() {
		return prcType;
	}

	public void setPrcType(String prcType) {
		this.prcType = prcType;
	}

	public String getPrcName() {
		return prcName;
	}

	public void setPrcName(String prcName) {
		this.prcName = prcName;
	}
    
	public String getTips() {
		return tips;
	}

	public void setTips(String tips) {
		this.tips = tips;
	}

	public String getAddedTips() {
		return addedTips;
	}

	public void setAddedTips(String addedTips) {
		this.addedTips = addedTips;
	}

	public String getPrcSchemeInfo() {
		return prcSchemeInfo;
	}

	public void setPrcSchemeInfo(String prcSchemeInfo) {
		this.prcSchemeInfo = prcSchemeInfo;
	}

	@Override
    public String toString() {
        return "SchemeInfoEntity{" +
                "tips=" + tips +
                ", addedTips=" + addedTips +
                ", prcId=" + prcId +
                ", prcSchemeInfo=" + prcSchemeInfo +
                ", goodsPrcDesc=" + goodsPrcDesc +
                ", outSetFlow=" + outSetFlow +
                ", prcId=" + prcId +
                ", prcType=" + prcType +
                ", prcName=" + prcName +
                '}';
    }
}