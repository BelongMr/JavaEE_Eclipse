package com.sitech.acctmgr.test.atom.impl.invoice;

import java.util.HashMap;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.dto.invoice.S8240DisabledInvoInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8240qryInvoByInvNoInDTO;
import com.sitech.acctmgr.inter.invoice.I8240InvAdmin;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

public class S8240InvoiceTest extends BaseTestCase {

	private I8240InvAdmin bean;

	@Before
	public void setUp() throws Exception {
		bean = (I8240InvAdmin) getBean("8240InvAdminSvc");
	}

	@After
	public void tearDown() throws Exception {
		bean = null;
	}

	private String getArgStringForQuery() {
		ArgumentBuilder builder = new ArgumentBuilder();
		Map<String, Object> busiMap = new HashMap<>();

		// busiMap.put("PHONE_NO", "13766710711");

		busiMap.put("INV_NO", "55102599");
		busiMap.put("INV_CODE", "123001570712");

		busiMap.put("YEAR_MONTH", "201603");

		builder.setBusiargs(busiMap);

		Map<String, Object> oprMap = new HashMap<>();
		oprMap.put("LOGIN_NO", "aan70W");
		oprMap.put("OP_CODE", "8006");
		oprMap.put("GROUP_ID", "13436");
		oprMap.put("PROVINCE_ID", "230000");
		builder.setOperargs(oprMap);

		return builder.toString();
	}

	@Test
	public void testQry() throws Exception {
		String inStr = getArgStringForQuery();
		log.debug("入参：" + inStr);
		InDTO inDTO = parseInDTO(inStr, S8240qryInvoByInvNoInDTO.class);
		OutDTO outDTO = bean.queryInvo(inDTO);
		System.err.println(outDTO.toJson());

	}

	private String getArgStringForDisabled() {
		ArgumentBuilder builder = new ArgumentBuilder();
		Map<String, Object> busiMap = new HashMap<>();

		// busiMap.put("INV_CODE", "123001570712");
		//
		busiMap.put("INV_NO", "26951013");
		// busiMap.put("PHONE_NO", "13504532851");
		busiMap.put("YEAR_MONTH", "201704");

		builder.setBusiargs(busiMap);

		Map<String, Object> oprMap = new HashMap<>();
		oprMap.put("LOGIN_NO", "aan70W");
		oprMap.put("OP_CODE", "8006");
		oprMap.put("GROUP_ID", "13436");
		oprMap.put("PROVINCE_ID", "230000");
		builder.setOperargs(oprMap);

		return builder.toString();
	}

	@Test
	public void testDisabledInvoByInvNo() throws Exception {
		String inStr = getArgStringForDisabled();
		InDTO inDTO = parseInDTO(inStr, S8240DisabledInvoInDTO.class);
		OutDTO outDTO = bean.disabledInvoice(inDTO);
		System.err.println(outDTO.toJson());

	}
}
