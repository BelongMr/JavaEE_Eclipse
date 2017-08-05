package com.sitech.acctmgr.test.atom.impl.query;

import java.util.HashMap;
import java.util.Map;

import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.dto.acctmng.SCollectionBillQueryInDTO;
import com.sitech.acctmgr.inter.acctmng.ICollectionBill;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

public class SCollectionBillTest extends BaseTestCase {
	
	private ICollectionBill bean;
		
		@Before
		public void setUp(){
			bean = (ICollectionBill)getBean("collectionBillSvc");
		}


	 private String getArgStringForQuery() {
	        ArgumentBuilder builder = new ArgumentBuilder();
	        Map<String, Object> busiMap = new HashMap<>();
	        busiMap.put("CONTRACT_NO", "230350002000000598");
	        busiMap.put("QUERY_YM", "201701");
	        builder.setBusiargs(busiMap);

	        Map<String, Object> oprMap = new HashMap<>();
	        oprMap.put("LOGIN_NO", "aan70W");
	        oprMap.put("GROUP_ID", "13436");
	        builder.setOperargs(oprMap);
	        return builder.toString();
	    }

	    @Test
	    public void testQuery() throws Exception {
	        String inStr = this.getArgStringForQuery();

	        InDTO inDTO = parseInDTO(inStr, SCollectionBillQueryInDTO.class);
	        OutDTO outDTO = bean.query(inDTO);
	        System.out.println(outDTO.toJson());

	    }
	
}