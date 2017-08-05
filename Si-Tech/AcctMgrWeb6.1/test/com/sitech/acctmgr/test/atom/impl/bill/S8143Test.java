package com.sitech.acctmgr.test.atom.impl.bill;

import com.sitech.acctmgr.atom.dto.bill.*;
import com.sitech.acctmgr.inter.bill.I8143;
import com.sitech.acctmgr.test.junit.ArgumentBuilder;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import org.junit.Before;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by wangyla on 2016/5/15.
 */
public class S8143Test extends BaseTestCase {
    private I8143 bean;

    @Before
    public void setUp() throws Exception {
        bean = (I8143) getBean("8143Svc");
    }

    private String getArgStringForBillHome() {
        ArgumentBuilder builder = new ArgumentBuilder();
        Map<String, Object> busiMap = new HashMap<>();
        busiMap.put("PHONE_NO", "13514587518");
        busiMap.put("YEAR_MONTH", "201702");
        builder.setBusiargs(busiMap);

        Map<String, Object> oprMap = new HashMap<>();
//        oprMap.put("LOGIN_NO", "caDS00");
        oprMap.put("LOGIN_NO", "aan70W");
        oprMap.put("OP_CODE", "8143");
        builder.setOperargs(oprMap);

        return builder.toString();
    }

    @Test
    public void testQryBillHome() throws Exception {
        String indtoStr = this.getArgStringForBillHome();
        InDTO inDTO = parseInDTO(indtoStr, QryBillHomeInDTO.class);

        OutDTO outDTO = bean.qryBillHome(inDTO);
        System.out.println(outDTO.toJson());
    }


    private String getArgStringForSixBill() {
        ArgumentBuilder builder = new ArgumentBuilder();
        Map<String, Object> busiMap = new HashMap<>();
        busiMap.put("PHONE_NO", "13514587518");
        busiMap.put("YEAR_MONTH", "201702");
        builder.setBusiargs(busiMap);

        Map<String, Object> oprMap = new HashMap<>();
        oprMap.put("LOGIN_NO", "caDS00");
//        oprMap.put("LOGIN_NO", "aan70W");
        oprMap.put("OP_CODE", "8143");
        builder.setOperargs(oprMap);

        return builder.toString();
    }
    
    @Test
    public void testQrySixBill() throws Exception {

        String indtoStr = this.getArgStringForSixBill();
        InDTO inDTO = parseInDTO(indtoStr, QrySixBillInDTO.class);

        OutDTO outDTO = bean.qrySixBill(inDTO);
        System.out.println(outDTO.toJson());
    }

    private String getArgStringForSchemaInfo() {
        ArgumentBuilder builder = new ArgumentBuilder();
        Map<String, Object> busiMap = new HashMap<>();
        busiMap.put("PHONE_NO", "13634877056");
        busiMap.put("YEAR_MONTH", "201606");
        busiMap.put("QUERY_TYPE", "");
        builder.setBusiargs(busiMap);

        Map<String, Object> oprMap = new HashMap<>();
        oprMap.put("LOGIN_NO", "aan70W");
        oprMap.put("OP_CODE", "8143");
        builder.setOperargs(oprMap);

        return builder.toString();
    }

    @Test
    public void testQryBillScheme() {
        String indtoStr = this.getArgStringForSchemaInfo();
        InDTO inDTO = parseInDTO(indtoStr, QryBillSchemeInDTO.class);

        OutDTO outDTO = bean.qryBillScheme(inDTO);
        System.out.println(outDTO.toJson());
    }

    private String getArgStringForBillApx() {
        ArgumentBuilder builder = new ArgumentBuilder();
        Map<String, Object> busiMap = new HashMap<>();
        busiMap.put("PHONE_NO", "13624630398");
        busiMap.put("YEAR_MONTH", "201702");
        builder.setBusiargs(busiMap);

        Map<String, Object> oprMap = new HashMap<>();
//        oprMap.put("LOGIN_NO", "caDS00");
        oprMap.put("LOGIN_NO", "aan70W");
        oprMap.put("OP_CODE", "8143");
        builder.setOperargs(oprMap);

        return builder.toString();
    }

    @Test
    public void testQryBillApx() {
        String indtoStr = this.getArgStringForBillApx();
        InDTO inDTO = parseInDTO(indtoStr, QryBillApxInDTO.class);

        OutDTO outDTO = bean.qryBillApx(inDTO);
        System.out.println(outDTO.toJson());
    }

    private String getArgStringForSmsBill() {
        ArgumentBuilder builder = new ArgumentBuilder();
        Map<String, Object> busiMap = new HashMap<>();
        busiMap.put("PHONE_NO", "13624630398");
        busiMap.put("YEAR_MONTH", "201702");
        builder.setBusiargs(busiMap);

        Map<String, Object> oprMap = new HashMap<>();
//        oprMap.put("LOGIN_NO", "caDS00");
        oprMap.put("LOGIN_NO", "aan70W");
        oprMap.put("GROUP_ID", "10789");
        oprMap.put("OP_CODE", "8143");
        builder.setOperargs(oprMap);

        return builder.toString();
    }
    @Test
    public void testSmsBillQuery() throws Exception {
        String inStr = getArgStringForSmsBill();
        InDTO inDto = parseInDTO(inStr, SmsBillQueryInDTO.class);

        OutDTO outDto = bean.smsBillQuery(inDto);
        System.out.println(outDto.toJson());

    }
}