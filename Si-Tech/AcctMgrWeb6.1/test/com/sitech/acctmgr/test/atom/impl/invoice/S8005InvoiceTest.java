package com.sitech.acctmgr.test.atom.impl.invoice;

import java.util.HashMap;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.dto.invoice.S8005PrintInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8005QryPayInfoInDTO;
import com.sitech.acctmgr.inter.invoice.I8005;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

public class S8005InvoiceTest extends BaseTestCase {

	private I8005 bean;

	@Before
	public void setUp() throws Exception {
		bean = (I8005) getBean("8005Svc");
	}

	@After
	public void tearDown() throws Exception {
		bean = null;
	}

	private String getArgStringForqry() {
		ArgumentBuilder builder = new ArgumentBuilder();
		Map<String, Object> busiMap = new HashMap<>();
		busiMap.put("USER_FLAG", "0");
		busiMap.put("PHONE_NO", "15946314494");
		busiMap.put("BEGIN_DATE", "201612");
		busiMap.put("END_DATE", "201703");
		// busiMap.put("ID_NO", "230800002001600031");
		busiMap.put("CONTRACT_NO", "230370003002116701");
		busiMap.put("QRY_WAY", "1");
		busiMap.put("ELEC_TYPE", "1");


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
	public void testQryPayInfo() throws Exception {
		String inStr = getArgStringForqry();
		System.err.println("inStr:" + inStr);
		InDTO inDTO = parseInDTO(inStr, S8005QryPayInfoInDTO.class);
		OutDTO outDto = bean.qryPayInfo(inDTO);
		System.err.println("outdto:" + outDto.toJson());
	}

	private String getArgStringForPrint() {
		ArgumentBuilder builder = new ArgumentBuilder();
		Map<String, Object> busiMap = new HashMap<>();
		busiMap.put("USER_FLAG", "0");
		busiMap.put("PAY_SN", "30000001130019");
		busiMap.put("PRINT_FLAG", "0");
		busiMap.put("AUTH_FLAG", "");
//		busiMap.put("PHONE_NO", "20230022250");
		// busiMap.put("CONTRACT_NO", "230370003002116701");
		busiMap.put("PAY_LOGIN_NO", "gaaa09");
		busiMap.put("TOTAL_DATE", "20170511");
		busiMap.put("INV_NO", "07612676");
		busiMap.put("INV_CODE", "123001670712");
		busiMap.put("IS_PRINT", "");
		busiMap.put("INV_TYPE", "PM3001");

		builder.setBusiargs(busiMap);

		Map<String, Object> oprMap = new HashMap<>();
		oprMap.put("LOGIN_NO", "ceaaa3");
		oprMap.put("OP_CODE", "8005");
		oprMap.put("GROUP_ID", "10033");
		oprMap.put("PROVINCE_ID", "230000");
		builder.setOperargs(oprMap);

		return builder.toString();
	}

	@Test
	public void testPrint() throws Exception {
		String inStr = getArgStringForPrint();
		System.err.println("***************" + inStr);
		InDTO inDTO = parseInDTO(inStr, S8005PrintInDTO.class);
		OutDTO outDto = bean.print(inDTO);
		System.err.println("outdto:" + outDto.toJson());
	}

}
