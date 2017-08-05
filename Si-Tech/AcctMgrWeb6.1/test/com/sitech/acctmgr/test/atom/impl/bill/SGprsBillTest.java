package com.sitech.acctmgr.test.atom.impl.bill;

import com.sitech.acctmgr.atom.dto.bill.SGPRSBillQueryInDTO;
import com.sitech.acctmgr.inter.bill.IGprsBill;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.*;

/**
 * Created by wangyla on 2016/7/27.
 */
public class SGprsBillTest extends BaseTestCase{
    private IGprsBill bean;

    @Before
    public void setUp() throws Exception {
        bean = (IGprsBill) getBean("gprsBillSvc");
    }

    @After
    public void tearDown() throws Exception {
        bean = null;
    }

    private String getArgStringForQuery() {
        ArgumentBuilder builder = new ArgumentBuilder();
        Map<String, Object> busiMap = new HashMap<>();
        busiMap.put("PHONE_NO", "13904841348");
        busiMap.put("YEAR_MONTH","201705");
        builder.setBusiargs(busiMap);

        Map<String, Object> oprMap = new HashMap<>();
        oprMap.put("LOGIN_NO", "aan70W");
        oprMap.put("OP_CODE", "8183");
        oprMap.put("GROUP_ID", "724");
        builder.setOperargs(oprMap);

        return builder.toString();
    }

    @Test
    public void testQuery() throws Exception {

        String inStr = getArgStringForQuery();
        InDTO inDto = parseInDTO(inStr , SGPRSBillQueryInDTO.class);

        OutDTO outDto = bean.query(inDto);
        System.out.println(outDto.toJson());

    }
}