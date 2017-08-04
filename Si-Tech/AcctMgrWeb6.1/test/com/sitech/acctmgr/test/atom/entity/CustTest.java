package com.sitech.acctmgr.test.atom.entity;

import java.util.HashMap;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.test.junit.BaseTestCase;

public class CustTest extends BaseTestCase {

	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void testGetCustInfo() {
		
		ICust cust = (ICust) getBean("custEnt");
		
		CustInfoEntity outMap = null;
		
		long inCustId = 230120003086210253L;
		try {
			outMap = cust.getCustInfo(inCustId, null);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		System.out.println("result = " + outMap.toString());
	}

}
