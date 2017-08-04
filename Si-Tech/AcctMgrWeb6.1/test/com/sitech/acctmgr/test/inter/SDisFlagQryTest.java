package com.sitech.acctmgr.test.inter;

import org.junit.Test;

import com.sitech.acctmgr.atom.dto.query.SDisFlagQryInDTO;
import com.sitech.acctmgr.atom.dto.query.SDisFlagQryOutDTO;
import com.sitech.acctmgr.inter.query.IDisFlagQry;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;

public class SDisFlagQryTest extends BaseTestCase{
	@Test
	public void testQuery() {
		try {
			IDisFlagQry iDisFlagQry = (IDisFlagQry) getBean("disFlagQrySvc");

			MBean inMBean = new MBean("{\"ROOT\":{\"HEADER\":{\"POOL_ID\":\"11\",\"DB_ID\":\"\",\"ENV_ID\":\"\",\"ROUTING\":{\"ROUTE_KEY\":\"\",\"ROUTE_VALUE\":\"\"}}" +
				"    ,\"BODY\":{\"OPR_INFO\":{\"LOGIN_NO\":\"qea602\",\"GROUP_ID\":\"12345\"}"
				+ ",\"BUSI_INFO\":{\"PHONE_NO\":\"13944161239\",\"QUERY_MONTH\":\"201608\",\"END_TIME\":\"20190801\",\"REFUND_FLAG\":\"1\"}}}}");
			//InDTO in = parseInDTO(inMBean, S8000InitInDTO.class);
			InDTO in = parseInDTO(inMBean, SDisFlagQryInDTO.class);
			SDisFlagQryOutDTO out = (SDisFlagQryOutDTO)iDisFlagQry.query(in);
			String result = out.toJson();
			System.out.println("result = " + result);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
