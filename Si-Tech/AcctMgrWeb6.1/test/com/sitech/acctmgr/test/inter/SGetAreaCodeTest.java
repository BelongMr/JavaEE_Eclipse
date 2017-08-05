package com.sitech.acctmgr.test.inter;

import org.junit.Test;

import com.sitech.acctmgr.atom.dto.query.SGetAreaCodeInDTO;
import com.sitech.acctmgr.atom.dto.query.SGetAreaCodeOutDTO;
import com.sitech.acctmgr.atom.dto.query.SGetDetailTypeInDTO;
import com.sitech.acctmgr.atom.dto.query.SGetDetailTypeOutDTO;
import com.sitech.acctmgr.inter.billAccount.IGetAreaCode;
import com.sitech.acctmgr.inter.query.IGetDetailType;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;

public class SGetAreaCodeTest extends BaseTestCase{
	
	@Test
	public void testQuery() {
		try {
			IGetAreaCode iGetAreaCode = (IGetAreaCode) getBean("getAreaCodeSvc");

			MBean inMBean = new MBean("{\"ROOT\":{\"HEADER\":{\"POOL_ID\":\"11\",\"DB_ID\":\"\",\"ENV_ID\":\"\",\"ROUTING\":{\"ROUTE_KEY\":\"\",\"ROUTE_VALUE\":\"\"}}" +
				"    ,\"BODY\":{\"OPR_INFO\":{\"LOGIN_NO\":\"qea602\",\"GROUP_ID\":\"12345\"}"
				+ ",\"BUSI_INFO\":{\"PHONE_NO\":\"13944161239\",\"BEGIN_TIME\":\"20150801\",\"END_TIME\":\"20190801\",\"REFUND_FLAG\":\"1\"}}}}");
			//InDTO in = parseInDTO(inMBean, S8000InitInDTO.class);
			InDTO in = parseInDTO(inMBean, SGetAreaCodeInDTO.class);
			SGetAreaCodeOutDTO out = (SGetAreaCodeOutDTO)iGetAreaCode.query(in);
			String result = out.toJson();
			System.out.println("result = " + result);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}