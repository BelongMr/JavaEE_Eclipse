package com.sitech.acctmgrint.atom.busi.intface.comm;

public class DataSynCondition {
	private String key;//条件 
	private Object value;//值     
	private String compareValue;//连接符
	private boolean isVariable;//值是否是变量
	private String type;//列类型 LONG 和NOLONG型
	
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public Object getValue() {
		return value;
	}
	public void setValue(Object value) {
		this.value = value;
	}
	public String getCompareValue() {
		return compareValue;
	}
	public void setCompareValue(String compareValue) {
		this.compareValue = compareValue;
	}
	public boolean isVariable() {
		return isVariable;
	}
	public void setVariable(boolean isVariable) {
		this.isVariable = isVariable;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	
}

