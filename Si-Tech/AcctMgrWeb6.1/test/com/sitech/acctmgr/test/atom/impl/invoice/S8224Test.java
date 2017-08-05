package com.sitech.acctmgr.test.atom.impl.invoice;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.domains.invoice.InvBillCycleEntity;
import com.sitech.acctmgr.atom.domains.invoice.MealEntity;
import com.sitech.acctmgr.atom.dto.invoice.S8224PrintInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8224QryInvoInDTO;
import com.sitech.acctmgr.inter.invoice.I8224;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

public class S8224Test extends BaseTestCase {

	private I8224 bean;

	@Before
	public void setUp() throws Exception {
		bean = (I8224) getBean("8224Svc");
	}

	@After
	public void tearDown() throws Exception {
		bean = null;
	}

	private String getArgStringForqry() {
		ArgumentBuilder builder = new ArgumentBuilder();
		Map<String, Object> busiMap = new HashMap<>();

		busiMap.put("CONTRACT_NO", "230770003013697708");
		busiMap.put("BEGIN_YM", "201611");
		busiMap.put("END_YM", "201611");
		busiMap.put("PHONE_NO", "18246753863");
		MealEntity mealEntity = new MealEntity();
		// mealEntity.setHyAccept(1111111 + "");
		// mealEntity.setHyDate("20161212");
		// List<MealEntity> list = new ArrayList<>();
		// list.add(mealEntity);
		// busiMap.put("MEAL_LIST", list);
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
		String inStr = getArgStringForqry();
		System.err.println("inStr:" + inStr);
		InDTO inDTO = parseInDTO(inStr, S8224QryInvoInDTO.class);
		OutDTO outDto = bean.qryInvo(inDTO);
		System.err.println("outdto:" + outDto.toJson());
	}

	private String getArgStringForPrint() {
		ArgumentBuilder builder = new ArgumentBuilder();
		Map<String, Object> busiMap = new HashMap<>();

		busiMap.put("CONTRACT_NO", "230360003021376661");
		// busiMap.put("BILL_CYCLE", "201608");
		busiMap.put("PHONE_NO", "15145320838");
		busiMap.put("PRINT_TYPE", "true");
		busiMap.put("IS_PRINT", "1");
		// busiMap.put("INV_NO", "34323");
		// busiMap.put("INV_CODE", "789546");

		InvBillCycleEntity invBillCycle = new InvBillCycleEntity();
		invBillCycle.setBillCycle(201608);
		// invBillCycle.setInvCode("879456123");
		// invBillCycle.setInvNo("9531");

		InvBillCycleEntity invBillCycle2 = new InvBillCycleEntity();
		invBillCycle2.setBillCycle(201607);
		// invBillCycle2.setInvCode("879456123");
		// invBillCycle2.setInvNo("9531");
		List<InvBillCycleEntity> invBillCycleList = new ArrayList<InvBillCycleEntity>();
		invBillCycleList.add(invBillCycle);
		invBillCycleList.add(invBillCycle2);
		busiMap.put("INV_BILLCYCLE_LIST", invBillCycleList);

		builder.setBusiargs(busiMap);

		Map<String, Object> oprMap = new HashMap<>();
		oprMap.put("LOGIN_NO", "aan70W");
		oprMap.put("OP_CODE", "8224");
		oprMap.put("GROUP_ID", "13436");
		oprMap.put("PROVINCE_ID", "230000");
		builder.setOperargs(oprMap);

		return builder.toString();
	}

	@Test
	public void testPrint() throws Exception {
		String inStr = getArgStringForPrint();
		System.err.println("***************" + inStr);
		InDTO inDTO = parseInDTO(inStr, S8224PrintInDTO.class);
		OutDTO outDto = bean.print(inDTO);
		System.err.println("outdto:" + outDto.toJson());
	}

}