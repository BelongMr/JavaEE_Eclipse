package com.sitech.acctmgr.test.atom.impl.invoice;

import java.util.HashMap;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.dto.invoice.S8226QueryOrPrintInDTO;
import com.sitech.acctmgr.inter.invoice.I8226;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

public class S8226PrintTest extends BaseTestCase {

	private I8226 bean;

	@Before
	public void setUp() throws Exception {
		bean = (I8226) getBean("8226Svc");
	}

	@After
	public void tearDown() throws Exception {
		bean = null;
	}

	private String getArgStringForPrint() {
		ArgumentBuilder builder = new ArgumentBuilder();
		Map<String, Object> busiMap = new HashMap<>();
		busiMap.put("YEAR_MONTH", "201701");
		busiMap.put("GROUP_ID", "10081");
		busiMap.put("BEGIN_BANK", "0");
		busiMap.put("END_BANK", "99999");
		busiMap.put("BEGIN_PRINT_NO", "0");
		busiMap.put("END_PRINT_NO", "55555");
		busiMap.put("PRINT_TYPE", "1");
		busiMap.put("PRINT_FLAG", "1");

		builder.setBusiargs(busiMap);

		Map<String, Object> oprMap = new HashMap<>();
		oprMap.put("LOGIN_NO", "aan70W");
		oprMap.put("OP_CODE", "8014");
		oprMap.put("GROUP_ID", "13436");
		oprMap.put("PROVINCE_ID", "230000");
		builder.setOperargs(oprMap);

		return builder.toString();
	}

	@Test
	public void testPrint() throws Exception {
		String inStr = getArgStringForPrint();
		System.err.println(inStr + ">>>>>");
		InDTO inDTO = parseInDTO(inStr, S8226QueryOrPrintInDTO.class);
		OutDTO outDTO = bean.queryOrPrint(inDTO);
		System.err.println(outDTO.toJson());

	}

}
