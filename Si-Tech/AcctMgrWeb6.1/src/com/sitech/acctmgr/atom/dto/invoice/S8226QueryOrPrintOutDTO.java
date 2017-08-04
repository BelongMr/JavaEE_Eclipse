package com.sitech.acctmgr.atom.dto.invoice;

import java.util.List;

import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.acctmgr.atom.domains.collection.CollectionDispEntity;
import com.sitech.acctmgr.atom.domains.invoice.InvNoOccupyEntity;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

public class S8226QueryOrPrintOutDTO extends CommonOutDTO {

	private static final long serialVersionUID = 1809694410776959864L;
	@JSONField(name = "INVICE_DISP")
	@ParamDesc(path = "INVICE_DISP", cons = ConsType.CT001, type = "compx", len = "10", desc = "发票展示内容", memo = "略")
	private List<CollectionDispEntity> collectionList;

	@JSONField(name = "OCCUPY_LIST")
	@ParamDesc(path = "OCCUPY_LIST", cons = ConsType.CT001, type = "compx", len = "10", desc = "发票xml列表", memo = "略")
	private List<InvNoOccupyEntity> occupyList;
	
	@JSONField(name = "COLLIST_SIZE")
	@ParamDesc(path = "COLLIST_SIZE", cons = ConsType.CT001, type = "compx", len = "10", desc = "托收列表的大小", memo = "略")
	private Integer colListSize;	

	@Override
	public MBean encode() {
		MBean result = new MBean();
		result.setRoot(getPathByProperName("collectionList"), collectionList);
		result.setRoot(getPathByProperName("occupyList"), occupyList);
		result.setRoot(getPathByProperName("colListSize"), colListSize);
		return result;
	}

	public List<CollectionDispEntity> getCollectionList() {
		return collectionList;
	}

	public void setCollectionList(List<CollectionDispEntity> collectionList) {
		this.collectionList = collectionList;
	}

	public List<InvNoOccupyEntity> getOccupyList() {
		return occupyList;
	}

	public void setOccupyList(List<InvNoOccupyEntity> occupyList) {
		this.occupyList = occupyList;
	}

	public Integer getColListSize() {
		return colListSize;
	}

	public void setColListSize(Integer colListSize) {
		this.colListSize = colListSize;
	}

}
