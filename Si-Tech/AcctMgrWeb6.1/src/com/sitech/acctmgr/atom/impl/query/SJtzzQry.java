package com.sitech.acctmgr.atom.impl.query;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.query.GrpRedEntity;
import com.sitech.acctmgr.atom.dto.query.SJtzzQryInDTO;
import com.sitech.acctmgr.atom.dto.query.SJtzzQryOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.inter.query.IJtzzQry;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

@ParamTypes({ 
	@ParamType(c = SJtzzQryInDTO.class,oc=SJtzzQryOutDTO.class, m = "query")
	})
public class SJtzzQry extends AcctMgrBaseService implements IJtzzQry{

	protected IRecord record;
	
	@Override
	public OutDTO query(InDTO inParam) {
		
		SJtzzQryInDTO inDto = (SJtzzQryInDTO)inParam;
		String unitId = inDto.getUnitId();
		String opPhone = inDto.getOpPhone();  
		String phoneNo = inDto.getPhoneNo();  
		String beginTime = inDto.getBeginTime();
		String endTime = inDto.getEndTime();  
		String pageNum = inDto.getPageNum();  
		String pageCount = inDto.getPageCount();
		String queryType = inDto.getQueryType();
		
		int posBegin=0;
		int posEnd =0;//查询全部不分页
		if(!StringUtils.isEmptyOrNull(pageNum)&&!StringUtils.isEmptyOrNull(pageCount)) {
			posBegin=Integer.parseInt(pageCount) * (Integer.parseInt(pageNum)-1);
			posEnd = posBegin + Integer.parseInt(pageCount);	
		}
		
		Map<String,Object> inMap = new HashMap<String,Object>();
		inMap.put("UNIT_ID", unitId);
		inMap.put("CONTACT_PHONE", opPhone);
		inMap.put("PHONE_NO", phoneNo);
		inMap.put("BEGIN_TIME", beginTime);
		inMap.put("END_TIME", endTime);
		inMap.put("POS_BEGIN", posBegin);
		inMap.put("POS_END", posEnd);
		inMap.put("OP_TYPE", queryType);
		
		List<GrpRedEntity> resultList = new ArrayList<GrpRedEntity>();
		resultList = record.getJtRedInfo(inMap);
		
		int cnt=record.getJtRedInfoCount(inMap);
		
		SJtzzQryOutDTO outDto = new SJtzzQryOutDTO();
		outDto.setNum(String.valueOf(cnt));
		outDto.setResultList(resultList);
		return outDto;
	}

	/**
	 * @return the record
	 */
	public IRecord getRecord() {
		return record;
	}

	/**
	 * @param record the record to set
	 */
	public void setRecord(IRecord record) {
		this.record = record;
	}
	
}