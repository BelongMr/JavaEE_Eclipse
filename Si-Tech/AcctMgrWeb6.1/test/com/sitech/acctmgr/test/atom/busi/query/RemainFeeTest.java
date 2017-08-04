package com.sitech.acctmgr.test.atom.busi.query;

import static org.junit.Assert.*;

import java.util.HashMap;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.test.junit.BaseTestCase;

/**
 *
 * <p>Title:   </p>
 * <p>Description:   </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author 
 * @version 1.0
 */
public class RemainFeeTest extends BaseTestCase{

	/**
	 * 名称：
	 * @param 
	 * @return 
	 * @throws 
	 */
	@Before
	public void setUp() throws Exception {
	}

	/**
	 * 名称：
	 * @param 
	 * @return 
	 * @throws 
	 */
	@After
	public void tearDown() throws Exception {
	}

	/**
	 * Test method for {@link com.sitech.acctmgr.atom.busi.query.RemainFee#getPayInitInfo(long)}.
	 */
	@Test
	public void testGetPayInitInfo() {
		
		IRemainFee remainFee = (IRemainFee) getBean("remainFeeEnt");
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		long contractNo = 220470200034905702L;
		Map<String, Object> outMap = null;
		try {
			outMap = remainFee.getPayInitInfo(contractNo);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("result = " + outMap);
		
	}

	/**
	 * Test method for {@link com.sitech.acctmgr.atom.busi.query.RemainFee#getConRemainFee(long)}.
	 */
	@Test
	public void testGetConRemainFee() throws Exception{
		
		IRemainFee remainFee = (IRemainFee) getBean("remainFeeEnt");
		
		OutFeeData outFee = null;
//		long contractNo = 220470200034905702L;
		long contractNo = 230360003000698601L;
		outFee = remainFee.getConRemainFee(contractNo);

		
		System.out.println("result = " + outFee);
	}
	
	    @Test
    public void testGetConPrepay() throws Exception {
        IRemainFee remainFee = (IRemainFee) getBean("remainFeeEnt");

        //Map<String, Object> inMap = new HashMap<String, Object>();
        OutFeeData outFee = null;
        long contractNo = 220470200034905702L;
        Map<String, Object> outMap = null;
        try {
            outFee = remainFee.getConRemainFee(contractNo);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        System.out.println("result = " + outFee);
    }


}
