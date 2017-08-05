package com.sitech.acctmgr.atom.domains.detail;

import java.io.Serializable;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;

@SuppressWarnings("serial")
public class QueryTypeEntity implements Serializable {
	@JSONField(name = "QUERY_CLASS")
	@ParamDesc(path="QUERY_CLASS",cons=ConsType.CT001,len="64",desc="详单类型",type="string",memo="略")
	private String queryClass;
	@JSONField(name = "QUERY_NAME")
	@ParamDesc(path="QUERY_NAME",cons=ConsType.CT001,len="64",desc="详单配置名称",type="string",memo="略")
	private String queryName;
	@JSONField(name = "QUERY_TYPE")
	@ParamDesc(path="QUERY_TYPE",cons=ConsType.CT001,len="5",desc="详单ETC配置号",type="string",memo="略")
	private String queryType;
	@JSONField(name = "DETAIL_TYPE")
	@ParamDesc(path="DETAIL_TYPE",cons=ConsType.CT001,len="2",desc="大类归属",type="string",memo="略")
	private String detailType;
	@JSONField(name = "QUERY_FLAG")
	@ParamDesc(path="QUERY_FLAG",cons=ConsType.CT001,len="1",desc="查询方式",type="string",memo="略")
	private String queryFlag;

	public String getQueryClass() {
		return queryClass;
	}

	public void setQueryClass(String queryClass) {
		this.queryClass = queryClass;
	}

	public String getQueryName() {
		return queryName;
	}
	
	public void setQueryName(String queryName) {
		this.queryName = queryName;
	}
	
	public String getQueryType() {
		return queryType;
	}
		
	public void setQueryType(String queryType) {
		this.queryType = queryType;
	}
	
	public String getDetailType() {
		return detailType;
	}
	
	public void setDetailType(String detailType) {
		this.detailType = detailType;
	}
	
	public String getQueryFlag() {
		return queryFlag;
	}
	
	public void setQueryFlag(String queryFlag) {
		this.queryFlag = queryFlag;
	}

	@Override
	public String toString() {
		return "QueryTypeEntity [QUERY_NAME = " + queryName + ", QUERY_TYPE = "
				+ queryType + ", DETAIL_TYPE = " + detailType + ", QUERY_FLAG = "
				+ queryFlag + "]";
	}
	
}