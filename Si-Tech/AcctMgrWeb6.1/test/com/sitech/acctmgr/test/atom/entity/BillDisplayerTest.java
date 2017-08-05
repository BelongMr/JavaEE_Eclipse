package com.sitech.acctmgr.test.atom.entity;

import com.sitech.acctmgr.atom.domains.balance.BookTypeEnum;
import org.junit.Before;
import org.junit.Test;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sitech.acctmgr.atom.entity.inter.IBillDisplayer;
import com.sitech.acctmgr.test.junit.BaseTestCase;

/**
 * Created by wangyla on 2016/5/15.
 */
@TransactionConfiguration(transactionManager ="transactionManager",defaultRollback = true)
public class BillDisplayerTest extends BaseTestCase {
    private IBillDisplayer billDisplayer;
    @Before
    public void before() {
        billDisplayer = (IBillDisplayer) getBean("billDisplayerEnt");
    }

    @Test
    public void testFindUnbillFee() throws Exception {

    }

    @Test
    @Transactional(propagation = Propagation.REQUIRED)
    public void testGetBillFee() throws Exception {
        long idNo = 220101000000008024L;
        int yearMonth = 201602;
        System.out.println(billDisplayer.getBillFee(idNo, yearMonth));

    }

    @Test
    public void testSaveMidAllBillFee() throws Exception {

    }

    @Test
    public void testGetAgentFeeInfo() throws Exception {
        long idNo = 220111000000009101L;
        int yearMonth = 201604;
        System.out.println(billDisplayer.getAgentFeeInfo(idNo, yearMonth));
    }

    @Test
    public void testGetSevenBill() throws Exception {
        long idNo = 220101000000008024L;
        long contractNo = 220101100000030018L;
        int yearMonth = 201602;

        System.out.println(billDisplayer.getSevenBill(idNo,contractNo,yearMonth,""));

    }

    @Test
    public void testGetContractDetail() throws Exception {
        long idNo = 230870003001565760L;
        int yearMonth = 201608;
        System.out.println(billDisplayer.getContractDetail(idNo, yearMonth));
    }

    @Test
    public void testGetOutFee() throws Exception {
        long conNo = 230300003007557000L;
        int yearMonth = 201608;
        System.out.println(this.billDisplayer.getOutFee(conNo, 0L, 201702, null));
    }

}