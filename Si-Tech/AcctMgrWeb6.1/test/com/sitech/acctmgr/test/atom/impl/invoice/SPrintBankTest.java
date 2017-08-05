package com.sitech.acctmgr.test.atom.impl.invoice;

import java.util.HashMap;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.dto.invoice.SPrintBankPrintInDTO;
import com.sitech.acctmgr.inter.invoice.IPrintBank;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

public class SPrintBankTest extends BaseTestCase {

	private IPrintBank bean;

	@Before
	public void setUp() throws Exception {
		bean = (IPrintBank) getBean("printBankSvc");
	}

	@After
	public void tearDown() throws Exception {
		bean = null;
	}

	private String getArgStringForqry() {
		ArgumentBuilder builder = new ArgumentBuilder();
		Map<String, Object> busiMap = new HashMap<>();
		busiMap.put("USER_FLAG", "0");
		// busiMap.put("PAY_SN", "20004312534253");
		busiMap.put("FOREIGN_SN", "0034BIP1C00820170313112030000010");
		busiMap.put("PHONE_NO", "15145320838");
		// busiMap.put("CONTRACT_NO", "230880003002905840");
		// busiMap.put("ID_NO", "230880003002905839");
		busiMap.put("TOTAL_DATE", "20170312");
		// busiMap.put("INV_NO", "895623");
		// busiMap.put("INV_CODE", "89456123");
		// busiMap.put("BANK_CODE", "");
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
	public void testPrint() throws Exception {
		String inStr = getArgStringForqry();
		System.err.println("inStr:" + inStr);
		InDTO inDTO = parseInDTO(inStr, SPrintBankPrintInDTO.class);
		OutDTO outDto = bean.print(inDTO);
		System.err.println("outdto:" + outDto.toJson());
	}

}