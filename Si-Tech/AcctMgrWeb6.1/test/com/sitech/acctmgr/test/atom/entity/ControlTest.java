package com.sitech.acctmgr.test.atom.entity;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.test.junit.BaseTestCase;

public class ControlTest extends BaseTestCase {

	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void testGetPaypathName() {
		
		IControl control = (IControl) getBean("controlEnt");
		
		String sPaypath = "11";
		String sPaypathName = "";
		
		try {
			sPaypathName = control.getPaypathName(sPaypath);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("result = " + sPaypathName);
	}
	
	@Test
	public void testGetPubEncryptData() {
		
		IControl control = (IControl) getBean("controlEnt");
		
		String inName = "e8c76a2210a8a1d89e9189d325433944gqT";
		String outName = "";
		
		try {
			outName = control.pubEncryptData(inName, 1);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("result = " + outName);// 231023195501070025
	}

	@Test
	public void testpubDesForChannel() {

		IControl control = (IControl) getBean("controlEnt");
		
		String inData = "111111";
		
		try{
		String outString = control.pubDesForChannel(inData, "0", "11");
		
		log.info("qiaolin: outString: " + outString);
		} catch (Exception e) {

			e.printStackTrace();
		}
		
		String inData2 = "98d8ea58e603843a";
		
		try{
		String outString = control.pubDesForChannel(inData2, "1", "11");
		
		log.info("qiaolin: outString2: " + outString);
		} catch (Exception e) {

			e.printStackTrace();
		}
		
		
		
	}
}
