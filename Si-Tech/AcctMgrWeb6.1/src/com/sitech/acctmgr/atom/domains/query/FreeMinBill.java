package com.sitech.acctmgr.atom.domains.query;


import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;

import java.io.Serializable;

public class FreeMinBill implements Serializable {
    @JSONField(name = "BUSI_CODE")
    @ParamDesc(path = "BUSI_CODE", cons = ConsType.CT001, len = "1", type = "string", desc = "业务类型标识", memo = "")
    private String busiCode;

    @JSONField(name = "BUSI_NAME")
    @ParamDesc(path = "BUSI_NAME", cons = ConsType.CT001, len = "24", type = "string", desc = "业务类型名称", memo = "如：GPRS业务、语音业务等")
    private String busiName;

    @JSONField(serialize = false)
    private String favCode;

    /*优惠类型，指优惠二批代码*/
    @JSONField(serialize = false)
    private String favType;

    @JSONField(name = "FAV_TYPE_NAME")
    @ParamDesc(path = "FAV_TYPE_NAME", cons = ConsType.CT001, len = "48", type = "string", desc = "优惠类型名称", memo = "二批代码名称")
    private String favTypeName;

    @JSONField(serialize = false)
    private String unitCode;

    @JSONField(name = "UNIT_NAME")
    @ParamDesc(path = "UNIT_NAME", cons = ConsType.CT001, len = "10", type = "string", desc = "单位", memo = "如：KB、分钟、等等")
    private String unitName;

    @JSONField(name = "TOTAL")
    @ParamDesc(path = "TOTAL", cons = ConsType.CT001, len = "8", type = "string", desc = "总赠送量", memo = "")
    private String total;

    /*赠送总量，以Long型存放*/
    @JSONField(serialize = false)
    private long longTotal;

    @JSONField(name = "USED")
    @ParamDesc(path = "USED", cons = ConsType.CT001, len = "", type = "string", desc = "已使用", memo = "")
    private String used;

    @JSONField(serialize = false)
    private long longUsed;

    @JSONField(name = "REMAIN")
    @ParamDesc(path = "REMAIN", cons = ConsType.CT001, len = "", type = "string", desc = "剩余量", memo = "")
    private String remain;

    @JSONField(serialize = false)
    private long longRemain;

    /*资费ID*/
    @JSONField(serialize = false)
    private String prodPrcId;

    @JSONField(name = "PROD_PRC_NAME")
    @ParamDesc(path = "PROD_PRC_NAME", cons = ConsType.CT001, len = "120", type = "string", desc = "套餐名称", memo = "")
    private String prodPrcName;

    @JSONField(name = "YEAR_MONTH")
    @ParamDesc(path = "YEAR_MONTH", cons = ConsType.CT001, len = "6", type = "string", desc = "年月", memo = "")
    private String yearMonth;

    @JSONField(name = "RESERVE")
    @ParamDesc(path = "RESERVE", cons = ConsType.CT001, len = "5", type = "string", desc = "流量计费费率", memo = "第一位：1按兆计费; 2按K计费; 3按照分钟时长计费;0无套餐外费率;第二位到第五位：  具体费率值，单位厘")
    private String reserve;

    @JSONField(name = "FREE_LAST_TOTAL")
    @ParamDesc(path = "FREE_LAST_TOTAL", cons = ConsType.QUES, len = "40", type = "string", desc = "结转流量总量", memo = "")
    private String lastTotal;

    @JSONField(serialize = false)
    private long longLastTotal;

    @JSONField(name = "FREE_LAST_USED")
    @ParamDesc(path = "FREE_LAST_USED", cons = ConsType.QUES, len = "40", type = "string", desc = "结转流量使用量", memo = "")
    private String lastUsed;

    @JSONField(serialize = false)
    private long longLastUsed;

    @JSONField(name = "FREE_LAST_REMAIN")
    @ParamDesc(path = "FREE_LAST_REMAIN", cons = ConsType.QUES, len = "40", type = "string", desc = "结转流量剩余", memo = "")
    private String lastRemain;

    @JSONField(serialize = false)
    private long longLastRemain;

    @JSONField(serialize = false)
    private long longRealFree;

    @JSONField(name = "REAL_FREE")
    @ParamDesc(path = "REAL_FREE", cons = ConsType.QUES, len = "40", type = "string", desc = "真实消费", memo = "成员查询时，使用此值；表示每个成员个人使用情况")
    private String realFree;

    @ParamDesc(path = "EFF_DATE", cons = ConsType.QUES, len = "14", type = "string", desc = "资费索引时间", memo = "即资费生效时间")
    private String effDate;

    @ParamDesc(path = "REFERENCE_NO", cons = ConsType.QUES, len = "40", type = "string", desc = "关联号码", memo = "家长查询时：成员号码;成员查询时：家长号码")
    private String referenceNo;

    @JSONField(serialize = false)
    private String productId;

    @JSONField(serialize = false)
    private String instanceId;

    @JSONField(name = "PRIORITY")
    @ParamDesc(path = "PRIORITY", cons = ConsType.QUES, len = "40", type = "string", desc = "资费优先级", memo = "")
    private int priority;

    @JSONField(name = "LIMIT_TYPE")
    @ParamDesc(path = "LIMIT_TYPE", cons = ConsType.QUES, len = "2", type = "string", desc = "流量类型分类", memo = "01:通用；02：定向")
    private String limitType; /*流量类型分类*/

    @JSONField(name = "REGION_TYPE")
    @ParamDesc(path = "REGION_TYPE", cons = ConsType.QUES, len = "2", type = "string", desc = "流量地域分类", memo = "01:国内；02：区域")
    private String regionType; /*流量地域分类*/

    @JSONField(serialize = false)
    private String favClass;

    @JSONField(serialize = false)
    private String favClassName;

    @JSONField(serialize = false)
    private String favClassJz;

    @JSONField(serialize = false)
    private String favClassJzName;

    @JSONField(serialize = false)
    private String prcType;

    @JSONField(serialize = false)
    private String expDate;

    public String getBusiCode() {
        return busiCode;
    }

    public void setBusiCode(String busiCode) {
        this.busiCode = busiCode;
    }

    public String getBusiName() {
        return busiName;
    }

    public void setBusiName(String busiName) {
        this.busiName = busiName;
    }

    public String getFavCode() {
        return favCode;
    }

    public void setFavCode(String favCode) {
        this.favCode = favCode;
    }

    public String getFavType() {
        return favType;
    }

    public void setFavType(String favType) {
        this.favType = favType;
    }

    public String getFavTypeName() {
        return favTypeName;
    }

    public void setFavTypeName(String favTypeName) {
        this.favTypeName = favTypeName;
    }

    public String getUnitCode() {
        return unitCode;
    }

    public void setUnitCode(String unitCode) {
        this.unitCode = unitCode;
    }

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }

    public long getLongTotal() {
        return longTotal;
    }

    public void setLongTotal(long longTotal) {
        this.longTotal = longTotal;
    }

    public String getUsed() {
        return used;
    }

    public void setUsed(String used) {
        this.used = used;
    }

    public long getLongUsed() {
        return longUsed;
    }

    public void setLongUsed(long longUsed) {
        this.longUsed = longUsed;
    }

    public String getRemain() {
        return remain;
    }

    public void setRemain(String remain) {
        this.remain = remain;
    }

    public long getLongRemain() {
        return longRemain;
    }

    public void setLongRemain(long longRemain) {
        this.longRemain = longRemain;
    }

    public String getProdPrcId() {
        return prodPrcId;
    }

    public void setProdPrcId(String prodPrcId) {
        this.prodPrcId = prodPrcId;
    }

    public String getProdPrcName() {
        return prodPrcName;
    }

    public void setProdPrcName(String prodPrcName) {
        this.prodPrcName = prodPrcName;
    }

    public String getYearMonth() {
        return yearMonth;
    }

    public void setYearMonth(String yearMonth) {
        this.yearMonth = yearMonth;
    }

    public String getReserve() {
        return reserve;
    }

    public void setReserve(String reserve) {
        this.reserve = reserve;
    }

    public String getLastTotal() {
        return lastTotal;
    }

    public void setLastTotal(String lastTotal) {
        this.lastTotal = lastTotal;
    }

    public long getLongLastTotal() {
        return longLastTotal;
    }

    public void setLongLastTotal(long longLastTotal) {
        this.longLastTotal = longLastTotal;
    }

    public String getLastUsed() {
        return lastUsed;
    }

    public void setLastUsed(String lastUsed) {
        this.lastUsed = lastUsed;
    }

    public long getLongLastUsed() {
        return longLastUsed;
    }

    public void setLongLastUsed(long longLastUsed) {
        this.longLastUsed = longLastUsed;
    }

    public String getLastRemain() {
        return lastRemain;
    }

    public void setLastRemain(String lastRemain) {
        this.lastRemain = lastRemain;
    }

    public long getLongLastRemain() {
        return longLastRemain;
    }

    public void setLongLastRemain(long longLastRemain) {
        this.longLastRemain = longLastRemain;
    }

    public long getLongRealFree() {
        return longRealFree;
    }

    public void setLongRealFree(long longRealFree) {
        this.longRealFree = longRealFree;
    }

    public String getRealFree() {
        return realFree;
    }

    public void setRealFree(String realFree) {
        this.realFree = realFree;
    }

    public String getReferenceNo() {
        return referenceNo;
    }

    public void setReferenceNo(String referenceNo) {
        this.referenceNo = referenceNo;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getInstanceId() {
        return instanceId;
    }

    public void setInstanceId(String instanceId) {
        this.instanceId = instanceId;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public String getEffDate() {
        return effDate;
    }

    public void setEffDate(String effDate) {
        this.effDate = effDate;
    }

    public String getLimitType() {
        return limitType;
    }

    public void setLimitType(String limitType) {
        this.limitType = limitType;
    }

    public String getRegionType() {
        return regionType;
    }

    public void setRegionType(String regionType) {
        this.regionType = regionType;
    }
    
    public String getFavClass() {
		return favClass;
	}

	public void setFavClass(String favClass) {
		this.favClass = favClass;
	}

	public String getFavClassName() {
		return favClassName;
	}

	public void setFavClassName(String favClassName) {
		this.favClassName = favClassName;
	}

	public String getFavClassJz() {
		return favClassJz;
	}

	public void setFavClassJz(String favClassJz) {
		this.favClassJz = favClassJz;
	}

	public String getFavClassJzName() {
		return favClassJzName;
	}

	public void setFavClassJzName(String favClassJzName) {
		this.favClassJzName = favClassJzName;
	}

	public String getPrcType() {
		return prcType;
	}

	public void setPrcType(String prcType) {
		this.prcType = prcType;
	}

    public String getExpDate() {
        return expDate;
    }

    public void setExpDate(String expDate) {
        this.expDate = expDate;
    }

    @Override
    public String toString() {
        return "FreeMinBill{" +
                "busiCode='" + busiCode + '\'' +
                ", busiName='" + busiName + '\'' +
                ", favCode='" + favCode + '\'' +
                ", favType='" + favType + '\'' +
                ", favTypeName='" + favTypeName + '\'' +
                ", unitCode='" + unitCode + '\'' +
                ", unitName='" + unitName + '\'' +
                ", total='" + total + '\'' +
                ", longTotal=" + longTotal +
                ", used='" + used + '\'' +
                ", longUsed=" + longUsed +
                ", remain='" + remain + '\'' +
                ", longRemain=" + longRemain +
                ", prodPrcId=" + prodPrcId +
                ", prodPrcName='" + prodPrcName + '\'' +
                ", yearMonth='" + yearMonth + '\'' +
                ", reserve='" + reserve + '\'' +
                ", lastTotal='" + lastTotal + '\'' +
                ", longLastTotal=" + longLastTotal +
                ", lastUsed='" + lastUsed + '\'' +
                ", longLastUsed=" + longLastUsed +
                ", lastRemain='" + lastRemain + '\'' +
                ", longLastRemain=" + longLastRemain +
                ", longRealFree=" + longRealFree +
                ", realFree='" + realFree + '\'' +
                ", effDate='" + effDate + '\'' +
                ", referenceNo='" + referenceNo + '\'' +
                ", productId='" + productId + '\'' +
                ", priority=" + priority +
                ", limitType='" + limitType + '\'' +
                ", regionType='" + regionType + '\'' +
                ", prcType='" + prcType + '\'' +
                '}';
    }


}
