package com.sitech.acctmgr.test.atom.impl.bill;

import com.sitech.acctmgr.atom.dto.bill.SGrpBillQueryInDTO;
import com.sitech.acctmgr.atom.dto.bill.SPhoneBillQuery2InDTO;
import com.sitech.acctmgr.atom.dto.bill.SPhoneBillQueryInDTO;
import com.sitech.acctmgr.inter.bill.IGrpBill;
import com.sitech.acctmgr.inter.bill.IPhoneBill;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import org.junit.Before;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by wangyla on 2016/6/23.
 */
public class SPhoneBillTest extends BaseTestCase{
    private IPhoneBill bean;

    @Before
    public void setUp() {
        bean = (IPhoneBill) getBean("phoneBillSvc");
    }

    private String getArgStringForQuery() {
        ArgumentBuilder builder = new ArgumentBuilder();
        Map<String, Object> busiMap = new HashMap<>();
        busiMap.put("PHONE_NO", "13704838818");
        busiMap.put("BEGIN_MONTH", "201702");
        busiMap.put("END_MONTH", "201706");
        builder.setBusiargs(busiMap);

        Map<String, Object> oprMap = new HashMap<>();
        oprMap.put("LOGIN_NO", "aan70W");
        oprMap.put("OP_CODE", "0000");
        builder.setOperargs(oprMap);

        return builder.toString();
    }

    @Test
    public void testQuery() throws Exception {
        String inStr = this.getArgStringForQuery();
        InDTO inDto = parseInDTO(inStr, SPhoneBillQueryInDTO.class);
        OutDTO outDTO = bean.query(inDto);
        System.out.println(outDTO.toJson());
    }

    private String getArgStringForQuery2() {
        ArgumentBuilder builder = new ArgumentBuilder();
        Map<String, Object> busiMap = new HashMap<>();
        busiMap.put("PHONE_NO", "18346349875");
        busiMap.put("YEAR_MONTH", "201612");
        builder.setBusiargs(busiMap);

        Map<String, Object> oprMap = new HashMap<>();
        oprMap.put("LOGIN_NO", "aan70W");
        oprMap.put("GROUP_ID", "13978");
        oprMap.put("OP_CODE", "0000");
        builder.setOperargs(oprMap);

        return builder.toString();
    }

    @Test
    public void testQuery2() throws Exception {
        String inStr = this.getArgStringForQuery2();
        InDTO inDto = parseInDTO(inStr, SPhoneBillQuery2InDTO.class);
        OutDTO outDTO = bean.query2(inDto);
        System.out.println(outDTO.toJson());
    }
}