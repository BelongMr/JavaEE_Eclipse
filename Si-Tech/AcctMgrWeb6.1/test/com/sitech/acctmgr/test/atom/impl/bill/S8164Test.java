package com.sitech.acctmgr.test.atom.impl.bill;

import com.sitech.acctmgr.atom.dto.bill.S8164QryBillInDTO;
import com.sitech.acctmgr.inter.bill.I8164;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import org.junit.Before;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.*;

/**
 * Created by wangyla on 2016/6/29.
 */
public class S8164Test extends BaseTestCase{
    private I8164 bean;

    @Before
    public void setUp() throws Exception {
        bean = (I8164) getBean("8164Svc");
    }

    private String getArgStringForQueryBill() {
        ArgumentBuilder builder = new ArgumentBuilder();
        Map<String, Object> busiMap = new HashMap<>();
//        busiMap.put("PHONE_NO", "ttkd18746771597");
        busiMap.put("PHONE_NO", "13514572459");
//        busiMap.put("CONTRACT_NO", "230300003021026083");
        busiMap.put("YEAR_MONTH", "201704");
//        busiMap.put("QUERY_TYPE", "kd");
//        busiMap.put("QUERY_TYPE", "");
        builder.setBusiargs(busiMap);

        Map<String, Object> oprMap = new HashMap<>();
        oprMap.put("LOGIN_NO", "aan70W");
        oprMap.put("OP_CODE", "8164");
        builder.setOperargs(oprMap);

        return builder.toString();
    }

    @Test
    public void testQueryBill() throws Exception {
        String instr = getArgStringForQueryBill();
        InDTO inDTO = parseInDTO(instr, S8164QryBillInDTO.class);
        OutDTO outDTO = bean.queryBill(inDTO);
        System.out.println(outDTO.toJson());
    }
}