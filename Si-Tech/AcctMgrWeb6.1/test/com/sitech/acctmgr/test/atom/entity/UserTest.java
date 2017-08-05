package com.sitech.acctmgr.test.atom.entity;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.domains.user.UserDeadEntity;
import com.sitech.acctmgr.atom.domains.user.UserDetailEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.entity.inter.IUser;
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
public class UserTest extends BaseTestCase {

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

	@Test
	public void testGetUserMap() {
		
		IUser user = (IUser) getBean("userEnt");
		
		UserInfoEntity out = null;
		try {
			user.getUserEntity(null, "15004458208", null, true);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("result = " + out.toString());
	}

	@Test
	public void testGetUserDeadMap() {
		
		IUser user = (IUser) getBean("userEnt");
		List<UserDeadEntity> result = null;
		
		try {
			user.getUserdeadEntity("15886095842", null, null);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("result = " + result.toString());
	}
	
	@Test
	public void testGetUserdetailMap() {
		
		IUser user = (IUser) getBean("userEnt");
		
		UserDetailEntity  outMap = null;
		
		long inIdNo = 220470200034905701L;
		try {
			user.getUserdetailEntity(220470200034905701L);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("result = " + outMap.toString());
	}
	
	
	@Test
	public void testGetUserInfo() {
		
		IUser user = (IUser) getBean("userEnt");
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		UserInfoEntity outMap = null;
		inMap.put("PHONE_NO", "13694391045");
		try {
			user.getUserInfo("13694391045");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("result = " + outMap.toString());
	}
	

	@Test
	public void testGetFamilyInfo(){
		IUser bean = (IUser) getBean("userEnt");

		long idNo = 220151000000008505L;
		System.out.println("test=" + bean.getFamilyInfo(idNo));
	}

	@Test
	public void testGetFamilyInfoByVirtualId() {
		IUser bean = (IUser) getBean("userEnt");
		long idNo = 230870010000263772L;
		System.out.println(bean.getFamilyInfoByVirtualId(idNo));
	}

	@Test
	public void testGetUserGroupList() {
		IUser bean = (IUser) getBean("userEnt");
		long idNo = 230860003001765613L;
		System.out.println(bean.getUserGroupList(idNo));
	}


	@Test
	public void testGetGrpUserInfoByBrand() {
		IUser bean = (IUser) getBean("userEnt");
		long custId = 230750002901007562L;
		String brandIds = "2310AD,2310ML";
		System.out.println(bean.getGrpUserInfoByBrand(custId, brandIds));
	}

	@Test
	public void testGetUsersvcAttr() {
		IUser bean = (IUser) getBean("userEnt");
		long idNo = 230780003014673817L;
		String attrids = "23B102";
		System.out.println(bean.getUsersvcAttr(idNo, attrids));
	}

	@Test
	public void testGetFamIds() {
		IUser bean = (IUser) getBean("userEnt");
		long idNo = 230370003020824709L;
		System.out.println(bean.getFamlilyIds(idNo));
	}
}