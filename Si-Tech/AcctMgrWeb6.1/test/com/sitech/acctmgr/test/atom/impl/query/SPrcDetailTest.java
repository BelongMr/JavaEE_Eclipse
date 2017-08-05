package com.sitech.acctmgr.test.atom.impl.query;

import java.util.HashMap;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.sitech.acctmgr.atom.dto.query.SPrcDetailQueryInDTO;
import com.sitech.acctmgr.inter.query.IPrcDetail;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

public class SPrcDetailTest extends BaseTestCase{
    private IPrcDetail bean;

    @Before
    public void setUp() throws Exception {
        bean = (IPrcDetail) getBean("prcDetailSvc");
    }

    @After
    public void tearDown() throws Exception {
        bean = null;
    }

    private String getArgStringForQuery() {
        ArgumentBuilder builder = new ArgumentBuilder();
        Map<String, Object> busiMap = new HashMap<>();
        busiMap.put("PRC_ID", "M045053");
        busiMap.put("PRC_GROUP_ID", "10031");
        builder.setBusiargs(busiMap);

        Map<String, Object> oprMap = new HashMap<>();
        oprMap.put("LOGIN_NO", "newweb");
        oprMap.put("GROUP_ID", "10031");
        builder.setOperargs(oprMap);

        return builder.toString();
    }

    @Test
    public void testQuery() throws Exception {
        String inStr = this.getArgStringForQuery();
        InDTO inDTO = parseInDTO(inStr, SPrcDetailQueryInDTO.class);

        OutDTO outDTO = bean.query(inDTO);

        System.out.println(outDTO.toJson());
    }
}