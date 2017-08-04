package com.sitech.acctmgr.test.atom.impl.query;

import java.util.HashMap;
import java.util.Map;

import com.sitech.acctmgr.atom.dto.query.SGroupConQueryInDTO;
import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.dto.query.SGrpUserByUnitIdInDTO;
import com.sitech.acctmgr.inter.query.IGroupCon;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

public class SGroupConTest extends BaseTestCase {
	IGroupCon bean = null;

	@Before
	public void setUp() throws Exception {
		bean = (IGroupCon) getBean("groupConSvc");
	}

	private String getInArgsString() {
		ArgumentBuilder builder = new ArgumentBuilder();
		Map<String, Object> busiMap = new HashMap<>();
		busiMap.put("UNIT_ID", "4510966022"); //4510002854
		busiMap.put("CUST_ID", ""); //230740002900000463
		busiMap.put("ID_ICCID", ""); //4510002854

		builder.setBusiargs(busiMap);

		Map<String, Object> oprMap = new HashMap<>();
		oprMap.put("LOGIN_NO", "csgj13");
		oprMap.put("GROUP_ID", "13968");
		oprMap.put("OP_CODE", "8119");
		builder.setOperargs(oprMap);

		return builder.toString();
	}


	@Test
	public void testOnLineQuery() throws Exception {
		String inStr = this.getInArgsString();
		MBean mbean = new MBean(inStr);
		System.err.println(inStr);
		InDTO inDto = parseInDTO(mbean, SGrpUserByUnitIdInDTO.class);

		OutDTO outDto = bean.queryOnLineCon(inDto);
		System.err.println("出参" + outDto.toJson());

	}

	@Test
	public void testQuery() throws Exception {
		String inStr = this.getInArgsString();
		MBean mbean = new MBean(inStr);
		System.err.println(inStr);
		InDTO inDto = parseInDTO(mbean, SGroupConQueryInDTO.class);

		OutDTO outDto = bean.query(inDto);
		System.err.println("出参" + outDto.toJson());

	}

}