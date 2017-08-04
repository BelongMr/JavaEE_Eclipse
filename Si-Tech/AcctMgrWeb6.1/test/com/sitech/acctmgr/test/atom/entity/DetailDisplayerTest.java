package com.sitech.acctmgr.test.atom.entity;

import com.sitech.acctmgr.atom.domains.detail.ChannelDetail;
import com.sitech.acctmgr.atom.entity.inter.IDetailDisplayer;
import com.sitech.acctmgr.net.ServerInfo;
import com.sitech.acctmgr.net.impl.SimpleServerInfoImpl;
import com.sitech.acctmgr.test.junit.BaseTestCase;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

/**
 * Created by wangyla on 2016/9/23.
 */
public class DetailDisplayerTest extends BaseTestCase {

    private IDetailDisplayer bean;

    @Before
    public void setUp() throws Exception {
        bean = (IDetailDisplayer) getBean("detailDisplayerEnt");
    }

    @After
    public void tearDown() throws Exception {
        bean = null;

    }

    @Test
    public void testQueryDetail() throws Exception {

        String phoneNo = "13936001234";
//        String phoneNo = "13845185669";
        String dealBegin = "20170901000000";
        String dealEnd = "20160930235959";
        String detailCode = "5015";
        String[] options = new String[]{"X", "20160807000000", "20160930235959"};

        String ip = "10.149.85.78";
        int port = 9102;
        ServerInfo serverInfo = new SimpleServerInfoImpl(ip, port);

        List<String> result = bean.queryDetail(phoneNo, detailCode, serverInfo, dealBegin, dealEnd, options);

        System.out.println("result = " + result.toString());
    }

    @Test
    public void testComboDetail() throws Exception {
        //[20161001000000/20161031235959,20160906000000/20161031235959]
        //[20160901000000/20160930235959,20160807000000/20160930235959]
        String phoneNo = "13836122730";
        String queryType = "71";
        String dealBegin = "20160901000000";
        String dealEnd = "20160930235959";
        String callBegin = "20160807000000";
        String callEnd = "20160930235959";
        String ip = "10.149.85.78";
        int port = 9102;
        ServerInfo serverInfo = new SimpleServerInfoImpl(ip, port);
        ChannelDetail result = bean.comboDetail(phoneNo, queryType, serverInfo, dealBegin, dealEnd, callBegin, callEnd);
        System.out.println("result = " + result.toString());

    }

    @Test
    public void testVoiceDetail() throws Exception {
        String phoneNo = "13904841348";
        String queryType = "72";
        String dealBegin = "20170301000000";
        String dealEnd = "20170331235959";
        String callBegin = "20170301000000";
        String callEnd = "20170331235959";
        String serviceType = "8142";
        String ip = "10.149.85.78";
        int port = 9102;
        ServerInfo serverInfo = new SimpleServerInfoImpl(ip, port);
        ChannelDetail result = bean.voiceDetail(phoneNo, queryType, serverInfo, dealBegin, dealEnd, callBegin, callEnd, serviceType);
        System.out.println("result = " + result.toString());
    }

    @Test
    public void testNetDetail() throws Exception {
        String phoneNo = "13703612000";
        String queryType = "75";
        String dealBegin = "20160901000000";
        String dealEnd = "20160930235959";
        String callBegin = "20160807000000";
        String callEnd = "20160930235959";
        String ip = "10.149.85.78";
        int port = 9102;
        ServerInfo serverInfo = new SimpleServerInfoImpl(ip, port);
        ChannelDetail result = bean.netDetail(phoneNo, queryType, serverInfo, dealBegin, dealEnd, callBegin, callEnd);
        System.out.println("result = " + result.toString());
    }

    @Test
    public void testGroupDetail() throws Exception {
        String phoneNo = "13836122730";
        String queryType = "77";
        String dealBegin = "20160901000000";
        String dealEnd = "20160930235959";
        String callBegin = "20160807000000";
        String callEnd = "20160930235959";
        String ip = "10.149.85.78";
        int port = 9102;
        ServerInfo serverInfo = new SimpleServerInfoImpl(ip, port);
        ChannelDetail result = bean.groupDetail(phoneNo, queryType, serverInfo, dealBegin, dealEnd, callBegin, callEnd);
        System.out.println("result = " + result.toString());
    }

    @Test
    public void testRawDetail() throws Exception {
        String phoneNo = "13703612000";
        String queryType = "104";
        String dealBegin = "20160901000000";
        String dealEnd = "20160930235959";
        String callBegin = "20160807000000";
        String callEnd = "20160930235959";
        String ip = "10.149.85.78";
        int port = 9102;
        ServerInfo serverInfo = new SimpleServerInfoImpl(ip, port);
        List<String> result = bean.rawDetail(phoneNo, queryType, serverInfo, dealBegin, dealEnd, callBegin, callEnd);
        System.out.println("result = " + result.toString());
    }

    @Test
    public void testFavourDetail() throws Exception {
        String phoneNo = "15945841953";
        String queryType = "80";
        String dealBegin = "20160901000000";
        String dealEnd = "20161001235959";
        String callBegin = "20160807000000";
        String callEnd = "20160930235959";
        String ip = "10.149.85.78";
        int port = 9102;
        ServerInfo serverInfo = new SimpleServerInfoImpl(ip, port);
        ChannelDetail result = bean.favourDetail(phoneNo, queryType, serverInfo, dealBegin, dealEnd, callBegin, callEnd);
        System.out.println("result = " + result.toString());
    }

    @Test
    public void testSpDetail() throws Exception {
        String phoneNo = "15945841953";
        String queryType = "96";
        String dealBegin = "20160901000000";
        String dealEnd = "20161001235959";
        String callBegin = "20160807000000";
        String callEnd = "20160930235959";
        String ip = "10.149.85.78";
        int port = 9102;
        ServerInfo serverInfo = new SimpleServerInfoImpl(ip, port);
        ChannelDetail result = bean.spDetail(phoneNo, queryType, serverInfo, dealBegin, dealEnd, callBegin, callEnd);
        System.out.println("result = " + result.toString());
    }
}