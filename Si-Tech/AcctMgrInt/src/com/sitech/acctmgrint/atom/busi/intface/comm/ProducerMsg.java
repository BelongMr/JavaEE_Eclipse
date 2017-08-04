package com.sitech.acctmgrint.atom.busi.intface.comm;

public class ProducerMsg {
	private String groupId;
	private int    level;
	private String topic;
	private String addr;
	private String client;
	private boolean compress;
	private int processTime;
	private int timeout;
	private int priori;
	//private String user;
	//private String pass;
	private Object msg;
	private String grpType;
	
	

	public int getProcessTime() {
		return processTime;
	}
	public void setProcessTime(int processTime) {
		this.processTime = processTime;
	}
	public int getPriori() {
		return priori;
	}
	public void setPriori(int priori) {
		this.priori = priori;
	}
	public int getTimeout() {
		return timeout;
	}
	public void setTimeout(int timeout) {
		this.timeout = timeout;
	}
	public String getClient() {
		return client;
	}
	public void setClient(String client) {
		this.client = client;
	}
	public String getTopic() {
		return topic;
	}
	public void setTopic(String topic) {
		this.topic = topic;
	}
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public Object getMsg() {
		return msg;
	}
	public void setMsg(Object msg) {
		this.msg = msg;
	}
	public boolean isCompress() {
		return compress;
	}
	public void setCompress(boolean compress) {
		this.compress = compress;
	}
	public String getGrpType() {
		return grpType;
	}
	public void setGrpType(String grpType) {
		this.grpType = grpType;
	}
	
}
