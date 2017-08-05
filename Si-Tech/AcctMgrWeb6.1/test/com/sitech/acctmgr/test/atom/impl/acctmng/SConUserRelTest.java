package com.sitech.acctmgr.test.atom.impl.acctmng;

import java.util.HashMap;
import java.util.Map;

import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.dto.acctmng.SConUserRelInDTO;
import com.sitech.acctmgr.inter.acctmng.IConUserRel;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
 * Created by wangyla on 2016/6/23.
 */
public class SConUserRelTest extends BaseTestCase {
	private IConUserRel bean;

	@Before
	public void setUp() {
		bean = (IConUserRel) getBean("conUserRelSvc");
	}

	private String getArgString() {
		ArgumentBuilder builder = new ArgumentBuilder();
		Map<String, Object> busiMap = new HashMap<>();
		busiMap.put("PHONE_NO", "13704838818");

		builder.setBusiargs(busiMap);

		Map<String, Object> oprMap = new HashMap<>();
		oprMap.put("LOGIN_NO", "caDS00");
		oprMap.put("OP_CODE", "0000");
		builder.setOperargs(oprMap);

		return builder.toString();
	}

	@Test
	public void testQueryOnLine() throws Exception {

		String inStr = getArgString();
		InDTO inDTO = parseInDTO(inStr, SConUserRelInDTO.class);
		OutDTO outDTO = bean.queryOnLine(inDTO);
		System.out.println(outDTO.toJson());
	}

	@Test
	public void testQueryOnLineIncBalance() throws Exception {
		String inStr = getArgString();
		InDTO inDTO = parseInDTO(inStr, SConUserRelInDTO.class);
		OutDTO outDTO = bean.queryOnLineIncBalance(inDTO);
		System.out.println(outDTO.toJson());
	}

	private String getArgStringForOffLine() {
		ArgumentBuilder builder = new ArgumentBuilder();
		Map<String, Object> busiMap = new HashMap<>();
		busiMap.put("PHONE_NO", "13804310983");

		builder.setBusiargs(busiMap);

		Map<String, Object> oprMap = new HashMap<>();
		oprMap.put("LOGIN_NO", "caDS00");
		oprMap.put("OP_CODE", "0000");
		builder.setOperargs(oprMap);

		return builder.toString();
	}

	@Test
	public void testQueryOffLine() throws Exception {
		String inStr = getArgStringForOffLine();
		InDTO inDTO = parseInDTO(inStr, SConUserRelInDTO.class);
		OutDTO outDTO = bean.queryOffLine(inDTO);
		System.err.println(outDTO.toJson());
	}
}