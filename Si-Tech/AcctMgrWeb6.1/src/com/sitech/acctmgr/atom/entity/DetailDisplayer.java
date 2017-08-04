package com.sitech.acctmgr.atom.entity;

import com.sitech.acctmgr.atom.domains.adj.MicroPayEntity;
import com.sitech.acctmgr.atom.domains.detail.ChannelDetail;
import com.sitech.acctmgr.atom.domains.detail.DetailLimitEntity;
import com.sitech.acctmgr.atom.domains.detail.GrpDetailEntity;
import com.sitech.acctmgr.atom.domains.detail.QueryTypeEntity;
import com.sitech.acctmgr.atom.domains.prod.PdPrcInfoEntity;
import com.sitech.acctmgr.atom.domains.query.ProvCriticalEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrProperties;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.net.Client;
import com.sitech.acctmgr.net.ClientFactory;
import com.sitech.acctmgr.net.ResponseData;
import com.sitech.acctmgr.net.ServerInfo;
import com.sitech.acctmgr.net.impl.NDetailResponseData;
import com.sitech.billing.qdetail.client.DetailClient;
import com.sitech.billing.qdetail.protocol.NDetailRequestData;
import org.apache.commons.lang.StringUtils;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

/**
 * Created by wangyla on 2016/7/27.
 */
public class DetailDisplayer extends BaseBusi implements IDetailDisplayer {
    private IUser user;
    private IBillAccount billAccount;
    private IControl control;
    private IProd prod;

    private static final String reqEncode = AcctMgrProperties.getConfigByMap("detailEncoding");
    private static final String detailQueryWay = AcctMgrProperties.getConfigByMap("detailQueryWay");

    @Override
    public List<QueryTypeEntity> getDetailTypeList(String queryClass) {
        return this.getDetailTypeList(queryClass, null);
    }

    @Override
    public List<QueryTypeEntity> getDetailTypeList(String queryClass, String detailType) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        if (StringUtils.isNotEmpty(queryClass)) {
            inMap.put("QUERY_CLASS", queryClass);
        }
        if (StringUtils.isNotEmpty(detailType)) {
            inMap.put("DETAIL_TYPE", detailType);
        }
        List<QueryTypeEntity> resultList = (List<QueryTypeEntity>) baseDao.queryForList("act_detailquery_dict.qDetailConfiguration", inMap);
        return resultList;

    }

    @Override
    public boolean transRegionLimit(Long idNo, int limitDay) {
        return this.transRegionLimit(null, idNo, limitDay);
    }

    @Override
    public boolean transRegionLimit(String phoneNo, int limitDay) {
        return this.transRegionLimit(phoneNo, null, limitDay);
    }

    private boolean transRegionLimit(String phoneNo, Long idNo, int limitDay) {
        if (phoneNo != null && (idNo == null || idNo <= 0)) {
            UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
            idNo = userInfo.getIdNo();
        }
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "LIMIT_DAY", limitDay);
        safeAddToMap(inMap, "BUSI_TYPE", "1"); //2表示跨地市，原为跨区
        int cnt = (Integer) baseDao.queryForObject("cs_busichg_rd.qCntBusiChgRd", inMap);

        return cnt > 0 ? false : true;
    }

    /**
     * 功能：查询单种etc配置详单
     *
     * @param phoneNo
     * @return
     */
    @Override
    public List<String> queryDetail(String phoneNo, String detailCode, ServerInfo si, String dealBeginTime, String dealEndTime,
                                    String... options) {

        String response = "";
        if (detailQueryWay.equalsIgnoreCase("F5")) {
            response = this.queryDetailF5(phoneNo, detailCode, si, dealBeginTime, dealEndTime, options);
        } else if (detailQueryWay.equalsIgnoreCase("ZK")) {
            response = this.queryDetailZk(phoneNo, detailCode, dealBeginTime, dealEndTime, options);
        }

        List<String> lines = null;
//        lines = Arrays.asList(response.split(System.lineSeparator()));
        lines = Arrays.asList(response.split("\\n"));

        return lines;
    }

    /*通过ZK软负载进行详单查询*/
    private String queryDetailZk(String phoneNo, String detailCode, String dealBeginTime, String dealEndTime,
                                 String... options) {
        int timeout = 6000;
        NDetailRequestData reqData = new NDetailRequestData(phoneNo, dealBeginTime, dealEndTime, detailCode, reqEncode, timeout, options);
        log.debug("request = " + reqData.getRequestString());

        String result = DetailClient.getInstance().queryDetail(reqData);
        log.debug("response=" + result);

        return result;
    }

    /*通过F5硬负载进行详单查询*/
    private String queryDetailF5(String phoneNo, String detailCode, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                 String... options) {

        String timeout = "6000";
        StringBuilder opBuff = new StringBuilder();
        int flag = 1;
        for (String s : options) {
            opBuff.append(s);
            if (flag < options.length) {
                opBuff.append(",");
            }
            flag++;
        }
        String optionsString = opBuff.toString();

        //根据用户获取路由的请求地址
        if (serverInfo == null) {
            serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");
        }

        ClientFactory f = ClientFactory.getInstance();
        Client c = f.getClient("detail");
//        c.getServerProxy().setServerInfo(serverInfo.getIp(), serverInfo.getPort());
        c.getServerProxy().setServerInfo(serverInfo);
        c.setRequestArgs(phoneNo, detailCode, reqEncode, dealBeginTime, dealEndTime, timeout, optionsString);

        ResponseData rd = c.getResponseData();
        NDetailResponseData drd = null;

        if (rd instanceof NDetailResponseData) {
            drd = (NDetailResponseData) rd;
        }

        String resp = "";
        if (drd != null) {
            resp = drd.getResponseString();
        }

        return resp;
    }

    /**
     * 功能：1.套餐及固定费详单
     *
     * @param phoneNo
     * @param queryType
     * @param dealBeginTime
     * @param dealEndTime
     * @param callBeginTime
     * @param callEndTime
     * @return
     */
    @Override
    public ChannelDetail comboDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                     String callBeginTime, String callEndTime) {

        int dealBegDay = Integer.parseInt(dealBeginTime.substring(0, 8));
        dealBeginTime = String.format("%8d%s", DateUtils.addDays(dealBegDay, 1), dealBeginTime.substring(8, 14));
        int dealEndDay = Integer.parseInt(dealEndTime.substring(0, 8));
        dealEndTime = String.format("%8d%s", DateUtils.addDays(dealEndDay, 1), dealEndTime.substring(8, 14));

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        double totalFee1 = 0.00;
        int curYm = DateUtils.getCurYm();
        int curYmd = DateUtils.getCurDay();
        List<String> outDetailLines = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();
            log.debug("comboDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);
            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            double fee = 0.00;

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                sb = new StringBuilder();

                if (detailCode.equals("8050") || detailCode.equals("8055")) {

                    int startTime = Integer.parseInt(fields[6].substring(0, 6));
                    String timeScope = "";
                    if (curYm == startTime) {
                        timeScope = new StringBuilder().append(curYm).append("01").append(" - ").append(curYmd).toString();
                    } else {
                        timeScope = new StringBuilder().append(startTime).append("01").append(" - ")
                                .append(fields[6].substring(0, 8)).toString();
                    }
                    String offerName = fields[2];
                    if (offerName.isEmpty() || offerName.equals("无") || offerName.equals("NULL")) {
                        offerName = this.getOfferName(fields[3]);
                    }
                    fee = Double.valueOf(fields[4]);


                    sb.append(startTime).append("|")
                            .append(timeScope).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee));

                    totalFee1 += fee;
                }


                outDetailLines.add(sb.toString());
            }

        }
        List<String> globalList = new ArrayList<>();
        globalList.add("1.套餐及固定费详单");
        ChannelDetail outDetail = new ChannelDetail();
        outDetail.setQueryType("71");
        outDetail.setGlobalList(globalList);
        outDetail.setTitleInfo("扣费时间|使用周期|套餐及固定费名称|费用");
        outDetail.setFootInfo("合计：|" + String.format("%.2f", totalFee1) + "元");
        outDetail.setDetailLines(outDetailLines);
        outDetail.setCount(outDetailLines.size());

        return outDetail;
    }

    /**
     * 功能：2.语音详单
     *
     * @param phoneNo
     * @param queryType
     * @param dealBeginTime
     * @param dealEndTime
     * @param callBeginTime
     * @param callEndTime
     * @return
     */
    @Override
    public ChannelDetail voiceDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                     String callBeginTime, String callEndTime, String serviceType) {
        int dealBegDay = Integer.parseInt(dealBeginTime.substring(0, 8));
        String gfDealBeginTime = String.format("%8d%s", DateUtils.addDays(dealBegDay, 1), dealBeginTime.substring(8, 14));
        int dealEndDay = Integer.parseInt(dealEndTime.substring(0, 8));
        String gfDealEndTime = String.format("%8d%s", DateUtils.addDays(dealEndDay, 1), dealEndTime.substring(8, 14));

        String otherDealBeginTime = dealBeginTime;
        String otherDealEndTime = dealEndTime;

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        double totalFee1 = 0;
        double totalFee2 = 0;
        double totalFee3 = 0;
        double totalFee4 = 0;
        double totalFee5 = 0;
        double totalFee6 = 0;
        double totalFee7 = 0;
        double totalFee8 = 0;
        double totalFee9 = 0;
        List<String> outDetailLines = new ArrayList<>();
        List<String> bodyDetailLines = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();
            if (detailCode.equals("8081") || detailCode.equals("8082")) {
                dealBeginTime = gfDealBeginTime;
                dealEndTime = gfDealEndTime;
            } else {
                dealBeginTime = otherDealBeginTime;
                dealEndTime = otherDealEndTime;
            }

            log.debug("voiceDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);
            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            double fee = 0;
            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                sb = new StringBuilder();

                if (detailCode.equals("8001")) {

                    String visitAreaCode = fields[1]; //到访地区
                    String callTypeName = fields[2]; //通话类型名称
                    if (fields[17].equals("Y")) {
                        if (callTypeName.equals("主叫")) {
                            callTypeName = "主叫携号用户";
                        }
                    }
                    String portPhone = this.getPortPhone(fields[3], serviceType);
                    String duration = this.dealUseTime(Long.parseLong(fields[4]));
                    String roamName = this.getRoamName(fields[15], fields[5]); //通信类型名称(漫游类型)
                    /*《关于国际漫游业务流程优化业务支撑系统改造的通知》 20170323*/
                    if (fields[20] != null && (fields[15].equals("6") || fields[15].equals("7") || fields[15].equals("8"))) {
                        roamName = fields[20];
                    }

                    String offerId = "";
                    if (fields[15].equals("0") && fields[5].compareTo("0") > 0) {
                        offerId = fields[7];
                    } else {
                        offerId = fields[6];
                    }
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[8]) + Double.valueOf(fields[9]) + Double.valueOf(fields[10])
                            + Double.valueOf(fields[11]) + Double.valueOf(fields[12]);
                    String mnsName = this.getMnsName(fields[16], fields[18]);
                    String refundName = "";

                    sb.append(fields[0]).append("|")
                            .append(visitAreaCode).append("|")
                            .append(callTypeName).append("|")
                            .append(portPhone).append("|")
                            .append(duration).append("|")
                            .append(roamName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(mnsName).append("|")
                            .append(refundName);

                    if (fields[15].equals("0") && fields[5].equals("0")) {
                        totalFee1 += Double.valueOf(fields[8]) + Double.valueOf(fields[9]); /*本地通话，市话费*/
                    } else if (fields[15].equals("0") && (fields[5].equals("2") || fields[5].equals("3"))) {
                        totalFee2 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国内长途话费*/
                    } else if (fields[5].equals("4")) {
                        totalFee3 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*港澳台长途话费*/
                    } else if (fields[15].compareTo("5") < 0 && fields[5].compareTo("4") > 0) {
                        totalFee4 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国际长途话费*/
                    } else if ((fields[15].equals("2") || fields[15].equals("4")) && fields[5].compareTo("4") < 0) {
                        totalFee5 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国内漫游通话费*/
                    } else if (fields[15].equals("8") && fields[5].compareTo("4") < 0) {
                        totalFee6 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*港澳台漫游通话费*/
                    } else if (fields[15].equals("6") || fields[15].equals("7")) {
                        totalFee7 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国际漫游通话费*/
                    }

                    totalFee8 += Double.valueOf(fields[12]);
                } else if (detailCode.equals("8002")) {

                    String visitAreaCode = fields[1]; //到访地区
                    String callTypeName = fields[2]; //通话类型名称
                    if (fields[17].equals("Y")) {
                        if (callTypeName.equals("主叫")) {
                            callTypeName = "主叫携号用户";
                        }
                    }
                    String portPhone = this.getPortPhone(fields[3], serviceType);
                    StringBuilder videoPhoneBuf = new StringBuilder();
                    videoPhoneBuf.append(fields[19]).append("->")
                            .append(fields[18]).append("->")
                            .append(portPhone);
                    portPhone = videoPhoneBuf.toString();
                    String duration = this.dealUseTime(Long.parseLong(fields[4]));
                    String roamName = this.getRoamName(fields[15], fields[5]); //通信类型名称(漫游类型)
                    String offerId = "";
                    if (fields[15].equals("0") && fields[5].compareTo("0") > 0) {
                        offerId = fields[7];
                    } else {
                        offerId = fields[6];
                    }
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[8]) + Double.valueOf(fields[9]) + Double.valueOf(fields[10])
                            + Double.valueOf(fields[11]) + Double.valueOf(fields[12]) + Double.valueOf(fields[13]);
                    String mnsName = this.getMnsName(fields[16], fields[18]);
                    String refundName = ""; //退费标识名称

                    sb.append(fields[0]).append("|")
                            .append(visitAreaCode).append("|")
                            .append(callTypeName).append("|")
                            .append(portPhone).append("|")
                            .append(duration).append("|")
                            .append(roamName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(mnsName).append("|")
                            .append(refundName);

                    if (fields[15].equals("0") && fields[5].equals("0")) {
                        totalFee1 += Double.valueOf(fields[8]) + Double.valueOf(fields[9]); /*本地通话，市话费*/
                    } else if (fields[15].equals("0") && (fields[5].equals("2") || fields[5].equals("3"))) {
                        totalFee2 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11])
                                + Double.valueOf(fields[12]); /*国内长途话费*/
                    } else if (fields[5].equals("4")) {
                        totalFee3 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11])
                                + Double.valueOf(fields[12]); /*港澳台长途话费*/
                    } else if (fields[15].compareTo("5") < 0 && fields[5].compareTo("4") > 0) {
                        totalFee4 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11])
                                + Double.valueOf(fields[12]); /*国际长途话费*/
                    } else if ((fields[15].equals("2") || fields[15].equals("4")) && fields[5].compareTo("4") < 0) {
                        totalFee5 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国内漫游通话费*/
                    } else if (fields[15].equals("8") && fields[5].compareTo("4") < 0) {
                        totalFee6 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*港澳台漫游通话费*/
                    } else if (fields[15].equals("6") || fields[15].equals("7")) {
                        totalFee7 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国际漫游通话费*/
                    }

                    totalFee8 += Double.valueOf(fields[13]);
                } else if (detailCode.equals("8003")) {

                    String visitAreaCode = fields[1]; //到访地区
                    String callTypeName = "语音杂志"; //通话类型名称
                    String portPhone = this.getPortPhone(fields[3], serviceType);
                    String duration = this.dealUseTime(Long.parseLong(fields[4]));
                    String roamName = "本地通话"; //通信类型名称(漫游类型)
                    String offerId = fields[4];
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[6]);
                    String mnsName = "2G网络";
                    String refundName = this.getRefundName(fields[7]);

                    sb.append(fields[0]).append("|")
                            .append(visitAreaCode).append("|")
                            .append(callTypeName).append("|")
                            .append(portPhone).append("|")
                            .append(duration).append("|")
                            .append(roamName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(mnsName).append("|")
                            .append(refundName);


                    totalFee8 += Double.valueOf(fields[6]);
                } else if (detailCode.equals("8025")) {

                    String visitAreaCode = fields[1]; //到访地区
                    String callTypeName = fields[2]; //通话类型名称
                    if (fields[17].equals("Y")) {
                        if (callTypeName.equals("主叫")) {
                            callTypeName = "V网主叫携号用户";
                        } else {
                            callTypeName = "V网被叫";
                        }
                    } else {
                        if (callTypeName.equals("主叫")) {
                            callTypeName = "V网主叫";
                        } else {
                            callTypeName = "V网被叫";
                        }
                    }
                    String portPhone = this.getPortPhone(fields[3], serviceType);
                    String duration = this.dealUseTime(Long.parseLong(fields[4]));
                    String roamName = this.getRoamName(fields[15], fields[5]); //通信类型名称(漫游类型)
                    roamName = new StringBuilder().append("VPMN").append(roamName).toString();
                    String offerId = "";
                    if (fields[15].equals("0") && fields[5].compareTo("0") > 0) {
                        offerId = fields[7];
                    } else {
                        offerId = fields[6];
                    }
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[8]) + Double.valueOf(fields[9]) + Double.valueOf(fields[10])
                            + Double.valueOf(fields[11]) + Double.valueOf(fields[12]);
                    String mnsName = this.getMnsName(fields[16], fields[18]);
                    String refundName = "";

                    sb.append(fields[0]).append("|")
                            .append(visitAreaCode).append("|")
                            .append(callTypeName).append("|")
                            .append(portPhone).append("|")
                            .append(duration).append("|")
                            .append(roamName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(mnsName).append("|")
                            .append(refundName);

                    if (fields[15].equals("0") && fields[5].equals("0")) {
                        totalFee1 += Double.valueOf(fields[8]) + Double.valueOf(fields[9]); /*本地通话，市话费*/
                    } else if (fields[15].equals("0") && (fields[5].equals("2") || fields[5].equals("3"))) {
                        totalFee2 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国内长途话费*/
                    } else if (fields[5].equals("4")) {
                        totalFee3 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*港澳台长途话费*/
                    } else if (fields[15].compareTo("5") < 0 && fields[5].compareTo("4") > 0) {
                        totalFee4 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国际长途话费*/
                    } else if ((fields[15].equals("2") || fields[15].equals("4")) && fields[5].compareTo("4") < 0) {
                        totalFee5 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国内漫游通话费*/
                    } else if (fields[15].equals("8") && fields[5].compareTo("4") < 0) {
                        totalFee6 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*港澳台漫游通话费*/
                    } else if (fields[15].equals("6") || fields[15].equals("7")) {
                        totalFee7 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国际漫游通话费*/
                    }

                    totalFee8 += Double.valueOf(fields[12]);
                } else if (detailCode.equals("8026")) {

                    String visitAreaCode = fields[1]; //到访地区
                    String callTypeName = "集团总机"; //通话类型名称
                    String portPhone = this.getPortPhone(fields[2], serviceType);
                    String duration = this.dealUseTime(Long.parseLong(fields[3]));
                    String roamName = ""; //通信类型名称(漫游类型)
                    String offerId = fields[5];
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[7]);
                    String mnsName = "2G网络";
                    String refundName = this.getRefundName(fields[7]);

                    sb.append(fields[0]).append("|")
                            .append(visitAreaCode).append("|")
                            .append(callTypeName).append("|")
                            .append(portPhone).append("|")
                            .append(duration).append("|")
                            .append(roamName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(mnsName).append("|")
                            .append(refundName);


                    totalFee8 += Double.valueOf(fields[7]);
                } else if (detailCode.equals("8027")) {

                    String visitAreaCode = fields[1]; //到访地区
                    String callTypeName = fields[2]; //通话类型名称
                    if (callTypeName.equals("主叫")) {
                        callTypeName = "点击拨号主叫";
                    } else {
                        callTypeName = "点击拨号被叫";
                    }
                    String portPhone = this.getPortPhone(fields[3], serviceType);
                    String duration = this.dealUseTime(Long.parseLong(fields[4]));
                    String roamName = this.getRoamName(fields[15], fields[5]); //通信类型名称(漫游类型)
                    String offerId = "";
                    if (fields[15].equals("0") && fields[5].compareTo("0") > 0) {
                        offerId = fields[7];
                    } else {
                        offerId = fields[6];
                    }
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[8]) + Double.valueOf(fields[9]) + Double.valueOf(fields[10])
                            + Double.valueOf(fields[11]) + Double.valueOf(fields[12]);
                    String mnsName = this.getMnsName(fields[16], null);
                    String refundName = "";

                    sb.append(fields[0]).append("|")
                            .append(visitAreaCode).append("|")
                            .append(callTypeName).append("|")
                            .append(portPhone).append("|")
                            .append(duration).append("|")
                            .append(roamName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(mnsName).append("|")
                            .append(refundName);

                    if (fields[15].equals("0") && fields[5].equals("0")) {
                        totalFee1 += Double.valueOf(fields[8]) + Double.valueOf(fields[9]); /*本地通话，市话费*/
                    } else if (fields[15].equals("0") && (fields[5].equals("2") || fields[5].equals("3"))) {
                        totalFee2 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国内长途话费*/
                    } else if (fields[5].equals("4")) {
                        totalFee3 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*港澳台长途话费*/
                    } else if (fields[15].compareTo("5") < 0 && fields[5].compareTo("4") > 0) {
                        totalFee4 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国际长途话费*/
                    } else if ((fields[15].equals("2") || fields[15].equals("4")) && fields[5].compareTo("4") < 0) {
                        totalFee5 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国内漫游通话费*/
                    } else if (fields[15].equals("8") && fields[5].compareTo("4") < 0) {
                        totalFee6 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*港澳台漫游通话费*/
                    } else if (fields[15].equals("6") || fields[15].equals("7")) {
                        totalFee7 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国际漫游通话费*/
                    }
                    totalFee8 += Double.valueOf(fields[12]);

                } else if (detailCode.equals("8081") || detailCode.equals("8082")) {

                    String visitAreaCode = "--"; //到访地区
                    String callTypeName = "--"; //通话类型名称
                    String portPhone = "--";
                    String duration = "--";
                    String roamName = "--"; //通信类型名称(漫游类型)
                    String offerId = "";
                    String offerName = fields[1];
                    fee = Double.valueOf(fields[2]);
                    String mnsName = "--";
                    String refundName = "";

                    sb.append(fields[0]).append("|")
                            .append(visitAreaCode).append("|")
                            .append(callTypeName).append("|")
                            .append(portPhone).append("|")
                            .append(duration).append("|")
                            .append(roamName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(mnsName).append("|")
                            .append(refundName);


                    totalFee9 += Double.valueOf(fields[2]);
                } else if (detailCode.equals("8089")) {

                    String visitAreaCode = fields[1]; //到访地区
                    String callTypeName = fields[2]; //通话类型名称

                    if (callTypeName.equals("01")) {
                        callTypeName = "centrex主叫";
                    } else if (callTypeName.equals("02")) {
                        callTypeName = "centrex被叫";
                    } else if (callTypeName.equals("00")) {
                        callTypeName = new StringBuilder("centrex").append(callTypeName).toString();
                    } else {
                        callTypeName = "centrex呼转";
                    }
                    String portPhone = this.getPortPhone(fields[3], serviceType);
                    String duration = this.dealUseTime(Long.parseLong(fields[4]));
                    String roamName = "centrex业务"; //通信类型名称(漫游类型)
                    String offerId = "";
                    if (fields[16].equals("0") && fields[5].compareTo("0") > 0) {
                        offerId = fields[7];
                    } else {
                        offerId = fields[6];
                    }
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[8]) + Double.valueOf(fields[9]) + Double.valueOf(fields[10])
                            + Double.valueOf(fields[11]) + Double.valueOf(fields[12]) + Double.valueOf(fields[13]);
                    String mnsName = this.getMnsName(fields[17], null);
                    String refundName = ""; //退费标识名称

                    sb.append(fields[0]).append("|")
                            .append(visitAreaCode).append("|")
                            .append(callTypeName).append("|")
                            .append(portPhone).append("|")
                            .append(duration).append("|")
                            .append(roamName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(mnsName).append("|")
                            .append(refundName);

                    if (fields[15].equals("0") && fields[5].equals("0")) {
                        totalFee1 += Double.valueOf(fields[8]) + Double.valueOf(fields[9]); /*本地通话，市话费*/
                    } else if (fields[15].equals("0") && (fields[5].equals("2") || fields[5].equals("3"))) {
                        totalFee2 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11])
                                + Double.valueOf(fields[12]); /*国内长途话费*/
                    } else if (fields[5].equals("4")) {
                        totalFee3 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11])
                                + Double.valueOf(fields[12]); /*港澳台长途话费*/
                    } else if (fields[15].compareTo("5") < 0 && fields[5].compareTo("4") > 0) {
                        totalFee4 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11])
                                + Double.valueOf(fields[12]); /*国际长途话费*/
                    } else if ((fields[15].equals("2") || fields[15].equals("4")) && fields[5].compareTo("4") < 0) {
                        totalFee5 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国内漫游通话费*/
                    } else if (fields[15].equals("8") && fields[5].compareTo("4") < 0) {
                        totalFee6 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*港澳台漫游通话费*/
                    } else if (fields[15].equals("6") || fields[15].equals("7")) {
                        totalFee7 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国际漫游通话费*/
                    }

                    totalFee8 += Double.valueOf(fields[13]);
                } else if (detailCode.equals("8090")) {

                    String visitAreaCode = fields[1]; //到访地区
                    String callTypeName = fields[2]; //通话类型名称
                    String portPhone = this.getPortPhone(fields[3], serviceType);
                    String duration = this.dealUseTime(Long.parseLong(fields[4]));
                    String roamName = this.getRoamName(null, fields[5]); //通信类型名称(漫游类型)
                    String offerId = "";
                    if (fields[5].compareTo("0") > 0) {
                        offerId = fields[7];
                    } else {
                        offerId = fields[6];
                    }
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[8]) + Double.valueOf(fields[9]);
                    String mnsName = this.getMnsName(fields[10], null);
                    String refundName = "";

                    sb.append(fields[0]).append("|")
                            .append(visitAreaCode).append("|")
                            .append(callTypeName).append("|")
                            .append(portPhone).append("|")
                            .append(duration).append("|")
                            .append(roamName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(mnsName).append("|")
                            .append(refundName);

                    if (fields[5].equals("0")) {
                        totalFee1 += Double.valueOf(fields[8]); /*本地通话，市话费*/
                    } else {
                        totalFee2 += Double.valueOf(fields[9]); /*国内长途话费*/
                    }

                }

                bodyDetailLines.add(sb.toString());
            }
        }

        Collections.sort(bodyDetailLines, new DetailOrder(0, "\\|"));
        outDetailLines = this.getDetailListByDay(bodyDetailLines, 0 /*处理时间index*/);

        List<String> headList = new ArrayList<>();
        StringBuilder headBuff = new StringBuilder();
        headBuff.append("H|本地通话费:|").append(String.format("%.2f", totalFee1 + totalFee8)).append("元|")
                .append("市话费:|").append(String.format("%.2f", totalFee1)).append("元|")
                .append("其他业务费:|").append(String.format("%.2f", totalFee8)).append("元");
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        headBuff.append("H|长途通话费:|").append(String.format("%.2f", totalFee2 + totalFee3 + totalFee4)).append("元|")
                .append("国内长途:|").append(String.format("%.2f", totalFee2)).append("元|")
                .append("港澳台长途:|").append(String.format("%.2f", totalFee3)).append("元|")
                .append("国际长途:|").append(String.format("%.2f", totalFee4)).append("元");
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        headBuff.append("H|漫游通话费:|").append(String.format("%.2f", totalFee5 + totalFee6 + totalFee7)).append("元|")
                .append("国内漫游:|").append(String.format("%.2f", totalFee5)).append("元|")
                .append("港澳台漫游:|").append(String.format("%.2f", totalFee6)).append("元|")
                .append("国际漫游:|").append(String.format("%.2f", totalFee7)).append("元");
        headList.add(headBuff.toString());

        int headColNum = 8; //取表格中最长的行的列作为表格的列

        double totalFee = totalFee1 + totalFee2 + totalFee3 + totalFee4 + totalFee5 + totalFee6
                + totalFee7 + totalFee8 + totalFee9;

        List<String> globalList = new ArrayList<>();
        globalList.add("2.语音详单");
        ChannelDetail outDetail = new ChannelDetail();
        outDetail.setQueryType("72");
        outDetail.setGlobalList(globalList);
        outDetail.setHeadList(headList);
        outDetail.setHeadColNum(headColNum);
        outDetail.setTitleInfo("起始时间|通信地点|通信方式|对方号码|通信时长|通信类型|执行套餐|实收通信费|网络类型|");
        outDetail.setFootInfo("合计：|" + String.format("%.2f", totalFee) + "元");
        outDetail.setDetailLines(outDetailLines);
        outDetail.setCount(outDetailLines.size());

        return outDetail;
    }

    /**
     * 功能：3.可视电话详单
     *
     * @param phoneNo
     * @param queryType
     * @param dealBeginTime
     * @param dealEndTime
     * @param callBeginTime
     * @param callEndTime
     * @return
     */
    @Override
    public ChannelDetail videoDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                     String callBeginTime, String callEndTime, String serviceType) {
        int dealBegDay = Integer.parseInt(dealBeginTime.substring(0, 8));
        String gfDealBeginTime = String.format("%8d%s", DateUtils.addDays(dealBegDay, 1), dealBeginTime.substring(8, 14));
        int dealEndDay = Integer.parseInt(dealEndTime.substring(0, 8));
        String gfDealEndTime = String.format("%8d%s", DateUtils.addDays(dealEndDay, 1), dealEndTime.substring(8, 14));

        String otherDealBeginTime = dealBeginTime;
        String otherDealEndTime = dealEndTime;

        String[] options = new String[]{"X", callBeginTime, callEndTime};


        double totalFee = 0;
        double totalFee1 = 0;
        double totalFee2 = 0;
        double totalFee3 = 0;
        double totalFee4 = 0;
        double totalFee5 = 0;
        double totalFee6 = 0;
        double totalFee7 = 0;
        double totalFee8 = 0;
        double totalFee9 = 0;

        List<String> bodyDetailLines = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();
            if (detailCode.equals("8083") || detailCode.equals("8084")) {
                dealBeginTime = gfDealBeginTime;
                dealEndTime = gfDealEndTime;
            } else {
                dealBeginTime = otherDealBeginTime;
                dealEndTime = otherDealEndTime;
            }
            log.debug("videoDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);
            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            double fee = 0;
            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                sb = new StringBuilder();

                if (detailCode.equals("8004")) {
                    String callTypeName = fields[2]; //通话类型
                    if (fields[17].equals("Y")) {
                        if (callTypeName.equals("主叫")) {
                            callTypeName = "主叫携号用户";
                        }
                    }

                    String portPhone = this.getPortPhone(fields[3], serviceType);

                    String duration = this.dealUseTime(Long.parseLong(fields[4]));
                    String roamName = this.getRoamName(fields[15], fields[5]); //通信类型名称(漫游类型)
                    String offerId = "";
                    if (fields[15].equals("0") && fields[5].compareTo("0") > 0) {
                        offerId = fields[7];
                    } else {
                        offerId = fields[6];
                    }
                    String offerName = this.getOfferName(offerId);

                    fee = Double.valueOf(fields[8]) + Double.valueOf(fields[9]) + Double.valueOf(fields[10])
                            + Double.valueOf(fields[11]) + Double.valueOf(fields[12]);

                    sb.append(fields[0]).append("|")
                            .append(fields[1]).append("|")
                            .append(callTypeName).append("|")
                            .append(portPhone).append("|")
                            .append(duration).append("|")
                            .append(roamName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee));


                    if (fields[15].equals("0") && fields[5].equals("0")) {
                        totalFee1 += Double.valueOf(fields[8]) + Double.valueOf(fields[9]); /*本地通话，市话费*/
                    } else if (fields[15].equals("0") && (fields[5].equals("2") || fields[5].equals("3"))) {
                        totalFee2 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国内长途话费*/
                    } else if (fields[5].equals("4")) {
                        totalFee3 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*港澳台长途话费*/
                    } else if (fields[15].compareTo("5") < 0 && fields[5].compareTo("4") > 0) {
                        totalFee4 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国际长途话费*/
                    } else if ((fields[15].equals("2") || fields[15].equals("4")) && fields[5].compareTo("4") < 0) {
                        totalFee5 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国内漫游通话费*/
                    } else if (fields[15].equals("8") && fields[5].compareTo("4") < 0) {
                        totalFee6 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*港澳台漫游通话费*/
                    } else if (fields[15].equals("6") || fields[15].equals("7")) {
                        totalFee7 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国际漫游通话费*/
                    }

                    totalFee8 += Double.valueOf(fields[12]);

                } else if (detailCode.equals("8005")) {
                    String callTypeName = fields[2]; //通话类型
                    if (fields[17].equals("Y")) {
                        if (callTypeName.equals("主叫")) {
                            callTypeName = "主叫携号用户";
                        }
                    }

                    String portPhone = this.getPortPhone(fields[3], serviceType);
                    StringBuilder videoPhoneBuf = new StringBuilder();
                    videoPhoneBuf.append(fields[19]).append("->").append(fields[18]).append("->").append(portPhone);
                    portPhone = videoPhoneBuf.toString();

                    String duration = this.dealUseTime(Long.parseLong(fields[4]));
                    String roamName = this.getRoamName(fields[15], fields[5]); //通信类型名称(漫游类型)
                    String offerId = "";
                    if (fields[15].equals("0") && fields[5].compareTo("0") > 0) {
                        offerId = fields[7];
                    } else {
                        offerId = fields[6];
                    }
                    String offerName = this.getOfferName(offerId);

                    fee = Double.valueOf(fields[8]) + Double.valueOf(fields[9]) + Double.valueOf(fields[10])
                            + Double.valueOf(fields[11]) + Double.valueOf(fields[12]);

                    sb.append(fields[0]).append("|")
                            .append(fields[1]).append("|")
                            .append(callTypeName).append("|")
                            .append(portPhone).append("|")
                            .append(duration).append("|")
                            .append(roamName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee));


                    if (fields[15].equals("0") && fields[5].equals("0")) {
                        totalFee1 += Double.valueOf(fields[8]) + Double.valueOf(fields[9]); /*本地通话，市话费*/
                    } else if (fields[15].equals("0") && (fields[5].equals("2") || fields[5].equals("3"))) {
                        totalFee2 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11])
                                + Double.valueOf(fields[12]); /*国内长途话费*/
                    } else if (fields[5].equals("4")) {
                        totalFee3 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11])
                                + Double.valueOf(fields[12]); /*港澳台长途话费*/
                    } else if (fields[15].compareTo("5") < 0 && fields[5].compareTo("4") > 0) {
                        totalFee4 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11])
                                + Double.valueOf(fields[12]); /*国际长途话费*/
                    } else if ((fields[15].equals("2") || fields[15].equals("4")) && fields[5].compareTo("4") < 0) {
                        totalFee5 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国内漫游通话费*/
                    } else if (fields[15].equals("8") && fields[5].compareTo("4") < 0) {
                        totalFee6 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*港澳台漫游通话费*/
                    } else if (fields[15].equals("6") || fields[15].equals("7")) {
                        totalFee7 += Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                                + Double.valueOf(fields[10]) + Double.valueOf(fields[11]); /*国际漫游通话费*/
                    }

                    totalFee8 += Double.valueOf(fields[13]);

                } else if (detailCode.equals("8083") || detailCode.equals("8084")) {
                    String callWayName = "--"; //通信方式
                    String portPhone = "--";
                    String duration = "--";
                    String roamName = "--"; //通信类型名称(漫游类型)
                    String offerName = fields[1];

                    fee = Double.valueOf(fields[2]);

                    sb.append(fields[0]).append("|")
                            .append("--").append("|")
                            .append(callWayName).append("|")
                            .append(portPhone).append("|")
                            .append(duration).append("|")
                            .append(roamName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee));

                    totalFee9 += Double.valueOf(fields[7]);
                }

                bodyDetailLines.add(sb.toString());
            }
        }

        Collections.sort(bodyDetailLines, new DetailOrder(0, "\\|"));
        List<String> outDetailLines = this.getDetailListByDay(bodyDetailLines, 0 /*处理时间index*/);

        List<String> headList = new ArrayList<>();
        StringBuilder headBuff = new StringBuilder();
        headBuff.append("本地通话费:|").append(String.format("%.2f", totalFee1 + totalFee8)).append("元|")
                .append("市话费:|").append(String.format("%.2f", totalFee1)).append("元|")
                .append("其他业务费:|").append(String.format("%.2f", totalFee8)).append("元");
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        headBuff.append("长途通话费:|").append(String.format("%.2f", totalFee2 + totalFee3 + totalFee4)).append("元|")
                .append("国内长途:|").append(String.format("%.2f", totalFee2)).append("元|")
                .append("港澳台长途:|").append(String.format("%.2f", totalFee3)).append("元|")
                .append("国际长途:|").append(String.format("%.2f", totalFee4)).append("元");
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        headBuff.append("漫游通话费:|").append(String.format("%.2f", totalFee5 + totalFee6 + totalFee7)).append("元|")
                .append("国内漫游:|").append(String.format("%.2f", totalFee5)).append("元|")
                .append("港澳台漫游:|").append(String.format("%.2f", totalFee6)).append("元|")
                .append("国际漫游:|").append(String.format("%.2f", totalFee7)).append("元");
        headList.add(headBuff.toString());

        int headColNum = 8; //取表格中最长的行的列作为表格的列

        totalFee = totalFee1 + totalFee2 + totalFee3 + totalFee4 + totalFee5 + totalFee6
                + totalFee7 + totalFee8 + totalFee9;

        List<String> globalList = new ArrayList<>();
        globalList.add("3.可视电话详单");
        ChannelDetail outDetail = new ChannelDetail();
        outDetail.setQueryType("73");
        outDetail.setGlobalList(globalList);
        outDetail.setHeadList(headList);
        outDetail.setHeadColNum(headColNum);
        outDetail.setTitleInfo("起始时间|通信地点|通信方式|对方号码|通信时长|通信类型|执行套餐|实收通信费|网络类型|");
        outDetail.setFootInfo("合计：|" + String.format("%.2f", totalFee) + "元");
        outDetail.setDetailLines(outDetailLines);
        outDetail.setCount(outDetailLines.size());

        return outDetail;
    }

    /**
     * 功能：将详单按天分段展示
     *
     * @param bodyDetailLines
     * @param dealTimeIndex
     * @return
     */
    private List<String> getDetailListByDay(List<String> bodyDetailLines, int dealTimeIndex) {
        List<String> outDetailLines = new ArrayList<>();
        StringBuilder sb = null;
        String titleDate = "19000000";
        for (String line : bodyDetailLines) {
            String dealTime = this.getFieldsString(line, "\\|", dealTimeIndex);
            dealTime = dealTime.replace("/", "").substring(0, 8);
            if (!dealTime.equals(titleDate)) {
                titleDate = dealTime;
                sb = new StringBuilder();

                sb.append("s|详单计入账单的日期:").append(titleDate);
                outDetailLines.add(sb.toString());
            }

            outDetailLines.add(line);
        }

        return outDetailLines;
    }

    /**
     * 功能：4.短信/彩信息详单
     *
     * @param phoneNo
     * @param queryType
     * @param dealBeginTime
     * @param dealEndTime
     * @param callBeginTime
     * @param callEndTime
     * @return
     */
    @Override
    public ChannelDetail smsDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                   String callBeginTime, String callEndTime, String serviceType) {

        int dealBegDay = Integer.parseInt(dealBeginTime.substring(0, 8));
        String gfDealBeginTime = String.format("%8d%s", DateUtils.addDays(dealBegDay, 1), dealBeginTime.substring(8, 14));
        int dealEndDay = Integer.parseInt(dealEndTime.substring(0, 8));
        String gfDealEndTime = String.format("%8d%s", DateUtils.addDays(dealEndDay, 1), dealEndTime.substring(8, 14));

        String otherDealBeginTime = dealBeginTime;
        String otherDealEndTime = dealEndTime;

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        double totalFee1 = 0; /*短信总费用*/
        double totalFee2 = 0; /*彩信总费用*/

        List<String> bodyDetailList = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        int smsCount = 0; //短信总条数
        int mmsCount = 0; //彩信总条数
        int ssCount = 0; //普通短信条数
        int cdCount = 0; //移动彩信条数
        int siCount = 0; //国际短信条数
        int ciCount = 0; //国际彩信条数
        int sgCount = 0; //互联网短信条数
        int cgCount = 0; //互联网彩信条数
        int scCount = 0; //短号短信条数
        int mcCount = 0; //行业网关短信条数
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();
            if (detailCode.equals("8085") || detailCode.equals("8086")) {
                dealBeginTime = gfDealBeginTime;
                dealEndTime = gfDealEndTime;
            } else {
                dealBeginTime = otherDealBeginTime;
                dealEndTime = otherDealEndTime;
            }
            log.debug("smsDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);
            double fee = 0;
            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                sb = new StringBuilder();
                fee = 0;

                if (detailCode.equals("8012") || detailCode.equals("8022")) {
                    String portPhone = this.getPortPhone(fields[1], serviceType); //对端号码

                    String netName = "发送";
                    String smsName = "";// 通信方式
                    if (detailCode.equals("8012")) {
                        smsName = "短信";
                    } else if (detailCode.equals("8022")) {
                        smsName = "短号短信";
                        scCount++;
                    }

                    String offerId = fields[3];
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[5]);
                    totalFee1 += fee;

                    String refundName = ""; //退费标识
                    sb.append(fields[0]).append("|")
                            .append(portPhone).append("|")
                            .append(netName).append("|")
                            .append(smsName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee))
                            .append(refundName);

                    smsCount++;
                    ssCount++;
                } else if (detailCode.equals("8013")) {
                    String portPhone = this.getPortPhone(fields[1], serviceType); //对端号码

                    String netName = "";
                    if (fields[2].equals("21")) {
                        netName = "发送";
                    } else {
                        netName = "接收";
                    }
                    String smsName = "国际短信"; // 通信方式

                    String offerId = fields[3];
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[5]);
                    totalFee1 += fee;

                    String refundName = ""; //退费标识
                    sb.append(fields[0]).append("|")
                            .append(portPhone).append("|")
                            .append(netName).append("|")
                            .append(smsName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee))
                            .append(refundName);
                    smsCount++;
                    siCount++;
                } else if (detailCode.equals("8014")) {
                    String portPhone = this.getPortPhone(fields[1], serviceType); //对端号码

                    String netName = "";
                    if (fields[2].equals("00") || fields[2].equals("10")) {
                        netName = "发送";
                    } else {
                        netName = "接收";
                    }
                    String smsName = "互联短信"; // 通信方式

                    String offerId = fields[3];
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[5]);
                    totalFee1 += fee;

                    String refundName = ""; //退费标识
                    sb.append(fields[0]).append("|")
                            .append(portPhone).append("|")
                            .append(netName).append("|")
                            .append(smsName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee))
                            .append(refundName);
                    smsCount++;
                    sgCount++;
                } else if (detailCode.equals("8015")) {
                    String portPhone = this.getPortPhone(fields[1], serviceType); //对端号码

                    String netName = "";
                    if (fields[2].equals("00")) {
                        netName = "接收";
                    } else {
                        netName = "发送";
                    }
                    String smsName = "网信短信"; // 通信方式

                    String offerId = fields[3];
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[5]);
                    totalFee1 += fee;

                    String refundName = ""; //退费标识
                    sb.append(fields[0]).append("|")
                            .append(portPhone).append("|")
                            .append(netName).append("|")
                            .append(smsName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee))
                            .append(refundName);
                    smsCount++;
                    ssCount++;
                } else if (detailCode.equals("8018") || detailCode.equals("8024")) {
                    String portPhone = this.getPortPhone(fields[1], serviceType); //对端号码

                    String netName = "发送";
                    String smsName = "";// 通信方式
                    if (detailCode.equals("8018")) {
                        smsName = "梦网短信";
                    } else if (detailCode.equals("8024")) {
                        smsName = "物联网短信";
                    }

                    String offerId = fields[3];
                    String offerName = this.getOfferName(offerId);
                    fee = Double.valueOf(fields[5]);
                    totalFee1 += fee;

                    String refundName = ""; //退费标识
                    sb.append(fields[0]).append("|")
                            .append(portPhone).append("|")
                            .append(netName).append("|")
                            .append(smsName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee))
                            .append(refundName);
                    smsCount++;
                    ssCount++;
                } else if (detailCode.equals("8019")) {
                    String portPhone = "";
                    String netName = "";
                    if (fields[2].equals("00")) {
                        netName = "发送";
                        portPhone = fields[1];
                    } else {
                        netName = "接收";
                        portPhone = fields[8];
                    }
                    portPhone = this.getPortPhone(portPhone, serviceType); //对端号码

                    String smsName = "国际彩信"; // 通信方式

                    double fee1 = Double.valueOf(fields[5]);
                    String offerId = "";
                    if (fee1 == 0.00) {
                        offerId = fields[4];
                        fee = Double.valueOf(fields[6]);
                    } else {
                        offerId = fields[3];
                        fee = Double.valueOf(fields[5]);
                    }
                    String offerName = this.getOfferName(offerId);

                    String refundName = ""; //退费标识
                    sb.append(fields[0]).append("|")
                            .append(portPhone).append("|")
                            .append(netName).append("|")
                            .append(smsName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee))
                            .append(refundName);
                    totalFee2 += fee;
                    mmsCount++;
                    ciCount++;
                } else if (detailCode.equals("8020")) {
                    String portPhone = "";
                    String netName = "";
                    if (fields[2].equals("00") || fields[2].equals("01")) {
                        netName = "发送";
                        portPhone = fields[1];
                    } else {
                        netName = "接收";
                        portPhone = fields[8];
                    }
                    portPhone = this.getPortPhone(portPhone, serviceType); //对端号码

                    String smsName = "移动彩信"; // 通信方式

                    double fee1 = Double.valueOf(fields[5]);
                    String offerId = "";
                    if (fee1 == 0.00) {
                        offerId = fields[4];
                        fee = Double.valueOf(fields[6]);
                    } else {
                        offerId = fields[3];
                        fee = Double.valueOf(fields[5]);
                    }
                    String offerName = this.getOfferName(offerId);
                    String refundName = this.getRefundName(fields[11]); //退费标识

                    sb.append(fields[0]).append("|")
                            .append(portPhone).append("|")
                            .append(netName).append("|")
                            .append(smsName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee))
                            .append(refundName);
                    totalFee2 += fee;
                    mmsCount++;
                    cdCount++;
                } else if (detailCode.equals("8021")) {
                    String portPhone = "";
                    String netName = "";
                    if (fields[2].equals("00")) {
                        netName = "发送";
                        portPhone = fields[1];
                    } else {
                        netName = "接收";
                        portPhone = fields[8];
                    }
                    portPhone = this.getPortPhone(portPhone, serviceType); //对端号码

                    String smsName = "互联彩信"; // 通信方式

                    double fee1 = Double.valueOf(fields[5]);
                    String offerId = "";
                    if (fee1 == 0) {
                        offerId = fields[4];
                        fee = Double.valueOf(fields[6]);
                    } else {
                        offerId = fields[3];
                        fee = Double.valueOf(fields[5]);
                    }

                    String offerName = this.getOfferName(offerId);

                    String refundName = ""; //退费标识
                    sb.append(fields[0]).append("|")
                            .append(portPhone).append("|")
                            .append(netName).append("|")
                            .append(smsName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee))
                            .append(refundName);
                    totalFee2 += fee;
                    mmsCount++;
                    cgCount++;
                } else if (detailCode.equals("8023")) {
                    String portPhone = this.getPortPhone(fields[1], serviceType); //对端号码
                    String netName = "";
                    if (fields[2].equals("00") || fields[2].equals("10")) {
                        netName = "发送";
                    } else {
                        netName = "接收";
                    }

                    String smsName = "行业网关短信"; // 通信方式

                    double fee1 = Double.valueOf(fields[5]);
                    String offerId = "";
                    if (fee1 == 0) {
                        offerId = fields[4];
                        fee = Double.valueOf(fields[6]);
                    } else {
                        offerId = fields[3];
                        fee = Double.valueOf(fields[5]);
                    }
                    totalFee1 += fee;

                    String offerName = this.getOfferName(offerId);

                    String refundName = ""; //退费标识
                    sb.append(fields[0]).append("|")
                            .append(portPhone).append("|")
                            .append(netName).append("|")
                            .append(smsName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee))
                            .append(refundName);
                    smsCount++;
                    mcCount++;
                } else if (detailCode.equals("8085") || detailCode.equals("8086")) {
                    String portPhone = "--"; //对端号码

                    String netName = "--";
                    String smsName = "--";// 通信方式

                    String offerName = "短信套餐费";
                    fee = Double.valueOf(fields[2]);
                    totalFee1 += fee;

                    String refundName = ""; //退费标识
                    sb.append(fields[0]).append("|")
                            .append(portPhone).append("|")
                            .append(netName).append("|")
                            .append(smsName).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                } else if (detailCode.equals("8099")) { //和飞信
                    String[] RF2 = new String[6];
                    RF2[0] = fields[0]; //起始时间
                    RF2[1] = this.getPortPhone(fields[1], serviceType); //对端号码

                    if (fields[2].equals("01")) {
                        RF2[2] = "发送";
                    } else {
                        RF2[2] = "接受";
                    }
                    RF2[3] = this.getOfferName(fields[3]);
                    RF2[4] = this.getOfferName(fields[4]);
                    RF2[5] = String.format("%.2f", fields[5]);

                    totalFee1 += Double.valueOf(fields[5]);
                    sb.append(RF2[0]).append("|")
                            .append(RF2[1]).append("|")
                            .append(RF2[2]).append("|")
                            .append("和飞信").append("|")
                            .append(String.format("%s,%s", RF2[3], RF2[4])).append("|")
                            .append(RF2[5]).append("|")
                            .append("|");

                    smsCount++;
                    ssCount++;
                }

                bodyDetailList.add(sb.toString());
            }
        }

        Collections.sort(bodyDetailList, new DetailOrder(0, "\\|"));
        List<String> outDetailLines = this.getDetailListByDay(bodyDetailList, 0 /*处理时间index*/);

        List<String> headList = new ArrayList<>();
        StringBuilder headBuff = new StringBuilder();
        headBuff.append("H|短信总条数:|").append(smsCount).append("条|") /*H 表示粗体展示*/
                .append("彩信总条数:|").append(mmsCount).append("条");
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        headBuff.append("h|其中:普通短信:|").append(ssCount).append("条|")
                .append("其中:移动彩信:|").append(cdCount).append("条");
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        headBuff.append("h|国际短信:|").append(siCount).append("条|")
                .append("国际彩信:|").append(ciCount).append("条");
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        headBuff.append("h|互联短信:|").append(sgCount).append("条|")
                .append("互联彩信:|").append(cgCount).append("条");
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        headBuff.append("h|短号短信:|").append(scCount).append("条|");
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        headBuff.append("h|行业网关短信:|").append(mcCount).append("条|");
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        headBuff.append("h|合计费用:|").append(String.format("%.2f", totalFee1)).append("元|") /*短信总费用*/
                .append("合计费用:|").append(String.format("%.2f", totalFee2)).append("元"); /*彩信总费用*/
        headList.add(headBuff.toString());

        int headColNum = 4; //取表格中最长的行的列作为表格的列

        List<String> globalList = new ArrayList<>();
        globalList.add("4.短信/彩信详单");
        ChannelDetail outDetail = new ChannelDetail();
        outDetail.setQueryType("74");
        outDetail.setGlobalList(globalList);
        outDetail.setHeadList(headList);
        outDetail.setHeadColNum(headColNum);
        outDetail.setTitleInfo("起始时间|对方号码|通信方式|业务类型|执行套餐|通信费|");
        outDetail.setFootInfo("合计：|" + String.format("%.2f", (totalFee1 + totalFee2)) + "元");
        outDetail.setDetailLines(outDetailLines);
        outDetail.setCount(bodyDetailList.size());

        return outDetail;
    }

    /**
     * 功能：5.上网详单（包含GPRS和WLAN）
     *
     * @param phoneNo
     * @param queryType
     * @param dealBeginTime
     * @param dealEndTime
     * @param callBeginTime
     * @param callEndTime
     * @return
     */
    @Override
    public ChannelDetail netDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                   String callBeginTime, String callEndTime) {

        int dealBegDay = Integer.parseInt(dealBeginTime.substring(0, 8));
        String gfDealBeginTime = String.format("%8d%s", DateUtils.addDays(dealBegDay, 1), dealBeginTime.substring(8, 14));
        int dealEndDay = Integer.parseInt(dealEndTime.substring(0, 8));
        String gfDealEndTime = String.format("%8d%s", DateUtils.addDays(dealEndDay, 1), dealEndTime.substring(8, 14));

        String otherDealBeginTime = dealBeginTime;
        String otherDealEndTime = dealEndTime;

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        double totalFee = 0;
        double totalFee1 = 0.0;
        double wlanGFee = 0.0;
        double wlanXFee = 0.00;

        int wlanGCount = 0;
        int wlanXCount = 0;
        int wapCount = 0;
        int netCount = 0;

        double wlanGK = 0; //wlan 上网流量KB
        long wlanGT = 0; //wlan 上网时长
        double wapK = 0; //wap 上网流量KB
        double netK = 0; //
        double wlanXK = 0; //校讯通流量
        long wlanXT = 0;

        long feeFlow = 0; //免费流量

        List<String> bodyDetailList = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        StringBuilder netBuff = new StringBuilder();
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();
            if (detailCode.equals("8087") || detailCode.equals("8088")) {
                dealBeginTime = gfDealBeginTime;
                dealEndTime = gfDealEndTime;
            } else {
                dealBeginTime = otherDealBeginTime;
                dealEndTime = otherDealEndTime;
            }
            log.debug("netDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            double fee = 0;
            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                sb = new StringBuilder();
                fee = 0;

                if (detailCode.equals("8006")) {

                    String refundName = ""; /*退费类型名称*/
                    if (fields[9].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String offerName = this.getOfferName(fields[4]);

                    fee = Double.valueOf(fields[6]) + Double.valueOf(fields[7]);

                    String netName = "2G网络";
                    //通话开始时间和结束时间确定通话时长
                    String duration = this.dealUseTime(this.getCallDuration(fields[1], fields[2]));

                    sb.append(fields[0]).append("|")
                            .append("无").append("|")
                            .append("移动梦网WAP").append("|")
                            .append(duration).append("|")
                            .append("").append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(netName).append("|")
                            .append(refundName);

                    wapCount++;
                    wapK += Long.parseLong(fields[3]);
                    feeFlow += Long.parseLong(fields[8]);
                    totalFee1 += fee;

                } else if (detailCode.equals("8007") || detailCode.equals("8008")
                        || detailCode.equals("8009") || detailCode.equals("8028")) {

                    String areaName = fields[1]; //到访地区名称

                    String apnName = fields[2]; //APN的网络标识
                    if (fields[20].equals("1040000019")) {
                        apnName = String.format("%s(和飞信)", apnName);
                    }

                    long netKTmp = Long.parseLong(fields[4]) + Long.parseLong(fields[5]) + Long.parseLong(fields[6])
                            + Long.parseLong(fields[7]) + Long.parseLong(fields[8]) + Long.parseLong(fields[9])
                            + Long.parseLong(fields[10]) + Long.parseLong(fields[11]) + Long.parseLong(fields[12])
                            + Long.parseLong(fields[13]) + Long.parseLong(fields[14]) + Long.parseLong(fields[15]); /*流量总量，KB*/

                    fee = Double.valueOf(fields[18]) + Double.valueOf(fields[19]);

                    String recordType = fields[26];
                    String netName = this.getNetTypeName2(recordType);
                    if (netBuff.length() == 0 || !netBuff.toString().contains(netName)) {
                        netBuff.append(netName).append(" ");
                    }


                    String offerId = "";
                    //if (Long.parseLong(fields[21]) == 0) {
                    offerId = fields[16];
                    //} else {
                    //    offerId = fields[17];
                    //}
                    String offerName = this.getOfferName(offerId);
                    if (fields.length > 27 || detailCode.equals("8008") || detailCode.equals("8028")) {
                        //gg业务，资费id是拼成长串的，需要对每一个offerId都做对应
                        String allOfferName = this.getAllOfferName(fields[27], fields[16]);

                        if (!allOfferName.isEmpty()) {
                            offerName = allOfferName;
                        }
                    }
                    /*《关于国际漫游业务流程优化业务支撑系统改造的通知》 20170323*/
                    if (fields[26].startsWith("40")) {
                        /*40开头为国际漫游，新增的product_code不为空时直接取值*/
                        if (fields.length > 31) {
                            if (fields[31] != null) {
                                offerName = fields[31];
                            }
                        }
                    }


                    String duration = this.dealUseTime(Long.parseLong(fields[3]));
                    String tmpDisp = "";

                    /*如果话单中的最小时间和最大时间是一个，视为没有合并的话单*/
                    if (fields[28].equals(fields[29]) || detailCode.equals("8008")) {
                        StringBuilder sbTmp = new StringBuilder();
                        sbTmp.append("@")
                                .append(fields[30]).append(",")
                                .append(fields[24]).append(",")
                                .append(fields[20]).append(",")
                                .append(fields[28]).append(",")
                                .append(fields[29]);
                        tmpDisp = sbTmp.toString();
                    }

                    sb.append(fields[0]).append("|")
                            .append(areaName).append("|")
                            .append(apnName).append("|")
                            .append(duration).append("|")
                            .append(this.dealNetK(netKTmp)).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(netBuff.toString().trim()).append("|")
                            .append(tmpDisp);

                    if (fields[2].equals("CMWAP")) {
                        wapCount++;
                        wapK += netKTmp;
                    } else {
                        netCount++;
                        netK += netKTmp;
                    }

                    feeFlow += Long.parseLong(fields[23]);
                    totalFee1 += fee;


                } else if (detailCode.equals("8011")) {
                    String roamName = fields[1]; //漫游类型名称
                    String duration = fields[3];

                    long netKTmp = Long.parseLong(fields[4]) + Long.parseLong(fields[5]) + Long.parseLong(fields[6])
                            + Long.parseLong(fields[7]) + Long.parseLong(fields[8]) + Long.parseLong(fields[9])
                            + Long.parseLong(fields[10]) + Long.parseLong(fields[11]) + Long.parseLong(fields[12])
                            + Long.parseLong(fields[13]) + Long.parseLong(fields[14]) + Long.parseLong(fields[15]); /*流量总量，KB*/

                    String offerId = "";
                    if (Long.parseLong(fields[21]) == 0) {
                        offerId = fields[16];
                    } else {
                        offerId = fields[17];
                    }
                    String offerName = this.getOfferName(offerId);

                    fee = Double.valueOf(fields[18]) + Double.valueOf(fields[19]);

                    /*改用 record_type 区分2G/3G 原来的msnc 做为缺省值*/
                    String msncType = fields[26];
                    String recordType = fields[22];
                    String netName = this.getNetTypeName(msncType, recordType);

                    String tmpDisp = "";

                    sb.append(fields[0]).append("|")
                            .append(roamName).append("|")
                            .append(fields[2]).append("|")
                            .append(duration).append("|")
                            .append(this.dealNetK(netKTmp)).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(netName).append("|")
                            .append(tmpDisp);

                    if (fields[2].equals("CMWAP")) {
                        wapCount++;
                        wapK += netKTmp;
                    } else {
                        netCount++;
                        netK += netKTmp;
                    }

                    feeFlow += Long.parseLong(fields[23]);
                    totalFee1 += fee;

                } else if (detailCode.equals("8010")) {
                    String roamName = fields[1]; //漫游类型名称
                    String duration = this.dealUseTime(Long.parseLong(fields[3]));
                    long netKTmp = Long.parseLong(fields[3]) + Long.parseLong(fields[4]);

                    String offerId = "";
                    if (Long.parseLong(fields[10]) == 0) {
                        offerId = fields[5];
                    } else {
                        offerId = fields[6];
                    }
                    String offerName = this.getOfferName(offerId);

                    fee = Double.valueOf(fields[7]) + Double.valueOf(fields[8]);

                    String operCode = fields[9];
                    String operName = this.getOperName(operCode);

                    String tmpDisp = "";

                    sb.append(fields[0]).append("|")
                            .append(roamName).append("|")
                            .append("WLAN").append("|")
                            .append(duration).append("|")
                            .append(this.dealNetK(netKTmp)).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(operName).append("|")
                            .append(tmpDisp);

                    totalFee1 += fee;

                    if (operCode.equals("03") || operCode.equals("81")) {
                        wlanXCount += 1;
                        wlanXK += netKTmp;
                        wlanXT += Long.parseLong(fields[2]);
                        wlanXFee += fee;

                    } else {
                        wlanGCount += 1;
                        wlanGK += netKTmp;
                        wlanGT += Long.parseLong(fields[2]);
                        wlanGFee += Double.valueOf(fields[6]);

                    }
                } else if (detailCode.equals("8087") || detailCode.equals("8088")) {
                    String roamName = "--"; //漫游类型名称
                    String duration = "--";
                    //long netk = 0;
                    String netk = "--";

                    String offerId = "";
                    String offerName = fields[1];

                    fee = Double.valueOf(fields[2]);

                    String netType = "";
                    String netName = "--";

                    String tmpDisp = "";

                    sb.append(fields[0]).append("|")
                            .append(roamName).append("|")
                            .append("--").append("|")
                            .append(duration).append("|")
                            .append(netk).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(netName).append("|")
                            .append(tmpDisp);


                } else if (detailCode.equals("8029")) {

                    String areaName = fields[1]; //到访地区名称

                    String apnName = fields[2]; //APN的网络标识
                    if (fields[20].equals("1040000019")) {
                        apnName = String.format("%s(和飞信)", apnName);
                    }

                    long netKTmp = Long.parseLong(fields[4]) + Long.parseLong(fields[5]) + Long.parseLong(fields[6])
                            + Long.parseLong(fields[7]) + Long.parseLong(fields[8]) + Long.parseLong(fields[9])
                            + Long.parseLong(fields[10]) + Long.parseLong(fields[11]) + Long.parseLong(fields[12])
                            + Long.parseLong(fields[13]) + Long.parseLong(fields[14]) + Long.parseLong(fields[15]); /*流量总量，KB*/

                    fee = Double.valueOf(fields[18]) + Double.valueOf(fields[19]);

                    String recordType = fields[26];
                    String netName = this.getNetTypeName2(recordType);
                    if (netBuff.length() == 0 || !netBuff.toString().contains(netName)) {
                        netBuff.append(netName).append(" ");
                    }

                    String offerName = fields[20];
                    if (offerName.equals("1020000001")) {
                        offerName = String.format("%s(终端管理)", offerName);
                    } else if (offerName.equals("4000000002")) {
                        offerName = String.format("%s(异常流量)", offerName);
                    } else if (offerName.equals("4000000006")) {
                        offerName = String.format("%s(异常信令流量)", offerName);
                    } else if (offerName.equals("2000000009")) {
                        offerName = String.format("%s(异常流量及异常信令流量)", offerName);
                    } else if (offerName.equals("1050000003")) {
                        offerName = String.format("%s(VOLTE通话产生流量)", offerName);
                    } else if (offerName.equals("1050000004")) {
                        offerName = String.format("%s(VOLTE)", offerName);
                    }

                    String duration = this.dealUseTime(Long.parseLong(fields[3]));
                    String tmpDisp = "";

                    /*如果话单中的最小时间和最大时间是一个，视为没有合并的话单*/
                    if (!fields[28].equals(fields[29])) {
                        StringBuilder sbTmp = new StringBuilder();
                        sbTmp.append("@")
                                .append(fields[30]).append(",")
                                .append(fields[24]).append(",")
                                .append(fields[20]).append(",")
                                .append(fields[28]).append(",")
                                .append(fields[29]);
                        tmpDisp = sbTmp.toString();
                    }

                    sb.append(fields[0]).append("|")
                            .append(areaName).append("|")
                            .append(apnName).append("|")
                            .append(duration).append("|")
                            .append(this.dealNetK(netKTmp)).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(netBuff.toString().trim()).append("|")
                            .append(tmpDisp);

                    if (fields[2].equals("CMWAP")) {
                        wapCount++;
                        wapK += netKTmp;
                    } else {
                        netCount++;
                        netK += netKTmp;
                    }

                    feeFlow += Long.parseLong(fields[23]);
                    totalFee1 += fee;


                }

                totalFee += fee;

                bodyDetailList.add(sb.toString());
            }
        }

        Collections.sort(bodyDetailList, new DetailOrder(0, "\\|"));
        List<String> outDetailLines = this.getDetailListByDay(bodyDetailList, 0);

        List<String> headList = new ArrayList<>();
        StringBuilder headBuff = new StringBuilder();

        feeFlow = feeFlow * 1024; /*换算免费流量，因为求免费流量的present_info字段单为为K，要统一换算成B再参与统计*/
        double allNetFlow = wapK + netK;
        double chargeFlow = (allNetFlow - feeFlow > 0) ? (allNetFlow - feeFlow) : 0;
        headBuff.append("H|GPRS话单条数:|").append(wapCount + netCount).append("条|")
                .append("收费流量:|").append(this.dealNetK(chargeFlow)).append("|")
                .append("免费流量:|").append(this.dealNetK(feeFlow)).append("|")
                .append("总流量:|").append(this.dealNetK(allNetFlow));
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        double wlanAllK = wlanGK + wlanXK;
        long wlanAllT = wlanGT + wlanXT;
        headBuff.append("H|WLAN话单条数:|").append(wlanGCount + wlanXCount).append("条|")
                .append("WLAN总流量:|").append(this.dealNetK(wlanAllK)).append("|")
                .append("WLAN总时长:|").append(this.dealUseTime(wlanAllT)).append("|")
                .append("WLAN总费用:|").append(String.format("%.2f", wlanGFee + wlanXFee));
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        headBuff.append("h|其中:公众WLAN条数:|").append(wlanGCount).append("条|")
                .append("其中:公众WLAN流量:|").append(this.dealNetK(wlanGK)).append("|")
                .append("其中:公众WLAN时长:|").append(this.dealUseTime(wlanGT)).append("|")
                .append("其中:公众WLAN费用:|").append(String.format("%.2f", wlanGFee)).append("元");
        headList.add(headBuff.toString());

        headBuff = new StringBuilder();
        headBuff.append("h|其中:校园WLAN条数:|").append(wlanXCount).append("条|")
                .append("其中:校园WLAN流量:|").append(this.dealNetK(wlanXK)).append("|")
                .append("其中:校园WLAN时长:|").append(this.dealUseTime(wlanXT)).append("|")
                .append("其中:校园WLAN费用:|").append(String.format("%.2f", wlanXFee)).append("元");
        headList.add(headBuff.toString());

        int headColNum = 8; //取表格中最长的行的列作为表格的列

        List<String> globalList = new ArrayList<>();
        globalList.add("5.上网详单(包括GPRS和WLAN)");
        ChannelDetail outDetail = new ChannelDetail();
        outDetail.setQueryType("75");
        outDetail.setGlobalList(globalList);
        outDetail.setHeadList(headList);
        outDetail.setHeadColNum(headColNum);
        outDetail.setTitleInfo("起始时间|通信地点|上网方式|时长|流量|执行套餐|通信费|网络类型");
        outDetail.setFootInfo("合计：|" + String.format("%.2f", totalFee) + "元");
        outDetail.setDetailLines(outDetailLines);
        outDetail.setCount(outDetailLines.size());

        return outDetail;
    }

    /**
     * 功能：6.自有增值业务（包含A类和B类）
     *
     * @param phoneNo
     * @param queryType
     * @param dealBeginTime
     * @param dealEndTime
     * @param callBeginTime
     * @param callEndTime
     * @return
     */
    @Override
    public ChannelDetail addedDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                     String callBeginTime, String callEndTime) {

        int dealBegDay = Integer.parseInt(dealBeginTime.substring(0, 8));
        String gfDealBeginTime = String.format("%8d%s", DateUtils.addDays(dealBegDay, 1), dealBeginTime.substring(8, 14));
        int dealEndDay = Integer.parseInt(dealEndTime.substring(0, 8));
        String gfDealEndTime = String.format("%8d%s", DateUtils.addDays(dealEndDay, 1), dealEndTime.substring(8, 14));

        String otherDealBeginTime = dealBeginTime;
        String otherDealEndTime = dealEndTime;
        String[] options = new String[]{"X", callBeginTime, callEndTime};

        double totalFee = 0;
        List<String> outDetailLines = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();
            if (detailCode.equals("8053") || detailCode.equals("8058")) {
                dealBeginTime = gfDealBeginTime;
                dealEndTime = gfDealEndTime;
            } else {
                dealBeginTime = otherDealBeginTime;
                dealEndTime = otherDealEndTime;
            }
            log.debug("addedDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);


            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            double fee = 0;
            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                fee = 0;
                sb = new StringBuilder();
                if (detailCode.equals("8030")) {

                    String refundName = ""; /*退费类型名称*/
                    if (fields[5].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String sysType = "";
                    if (fields.length > 8) {
                        sysType = fields[8]; //子系统类型
                    }
                    String feeTypeName = "";
                    if (sysType.equals("tg")) {
                        if (fields[7].equals("04")) {//费用类型
                            feeTypeName = "包月信息费";
                        } else {
                            feeTypeName = "点播信息费";
                        }
                    } else {
                        if (fields[6].equals("03")) { //费用类型
                            feeTypeName = "包月信息费";
                        } else {
                            feeTypeName = "点播信息费";
                        }
                    }

                    String spCode = fields[1];
                    String bizCode = fields[2];
                    String spName = billAccount.getOperName(spCode, bizCode);

                    fee = Double.valueOf(fields[3]) + Double.valueOf(fields[4]);

                    String pathTypeName = "";
                    if (spCode.equals("698028")) {
                        pathTypeName = "短信";
                    }

                    String contextId = fields[6];
                    String contextName = billAccount.getDailyGameName(contextId, spCode);
                    contextName = (contextName == null) ? "" : contextName;

                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("|")
                            .append(pathTypeName) /*使用方式名称*/
                            .append("|")
                            .append(spName).append(" ").append(contextName).append("|")
                            .append("无").append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);

                } else if (detailCode.equals("8031")) {
                    String refundName = ""; /*退费类型名称*/
                    if (fields[4].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String sysType = fields[4]; //子系统类型
                    String feeTypeName = "";
                    if (sysType.equals("bn")) {
                        //费用类型
                        feeTypeName = "--";

                    } else {
                        if (fields[5].equals("03")) { //费用类型
                            feeTypeName = "包月信息费";
                        } else {
                            feeTypeName = "点播信息费";
                        }
                    }

                    String spCode = fields[1];
                    String bizCode = fields[2];
                    String spName = billAccount.getOperName(spCode, bizCode);

                    fee = Double.valueOf(fields[3]);

                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("||")
                            .append(spName).append("|无").append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                } else if (detailCode.equals("8032")) {
                    String refundName = ""; /*退费类型名称*/
                    if (fields[3].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String feeTypeName = "";
                    if (fields[4].equals("3")) { //费用类型
                        feeTypeName = "包月信息费";
                    } else {
                        feeTypeName = "点播信息费";
                    }

                    fee = Double.valueOf(fields[1]) + Double.valueOf(fields[2]);

                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("||彩话话单|无").append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                } else if (detailCode.equals("8033")) {
                    String refundName = ""; /*退费类型名称*/
                    if (fields[2].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    //费用类型
                    String feeTypeName = "--";
                    fee = Double.valueOf(fields[1]);

                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("||彩铃话单|无").append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                } else if (detailCode.equals("8034")) {
                    String refundName = ""; /*退费类型名称*/
                    if (fields[4].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String feeTypeName = "";
                    if (fields[5].equals("03")) { //费用类型
                        feeTypeName = "包月信息费";
                    } else {
                        feeTypeName = "点播信息费";
                    }

                    String spCode = fields[1];
                    String bizCode = fields[2];
                    String spName = billAccount.getOperName(spCode, bizCode);

                    fee = Double.valueOf(fields[3]);

                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("||")
                            .append(spName)
                            .append("无").append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                } else if (detailCode.equals("8035")) {
                    String refundName = ""; /*退费类型名称*/
                    if (fields[6].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String sysType = fields[6];
                    String feeTypeName = "";
                    if (sysType.equals("ms") || sysType.equals("sk") || sysType.equals("bm")) {
                        feeTypeName = "--";
                    } else {
                        if (fields[7].equals("03")) { //费用类型
                            feeTypeName = "包月信息费";
                        } else {
                            feeTypeName = "点播信息费";
                        }
                    }

                    String wayName = "--";
                    if (fields[7].equals("my")) {
                        wayName = "短信";
                        if (fields[8].equals("03")) { //费用类型
                            feeTypeName = "包月信息费";
                        } else {
                            feeTypeName = "点播信息费";
                        }
                    }

                    String spCode = fields[1];
                    String bizCode = fields[2];
                    String spName = billAccount.getOperName(spCode, bizCode);

                    fee = Double.valueOf(fields[3]) + Double.valueOf(fields[4]);

                    sb.append(fields[0].substring(10)) /*起始时间*/.append("|")
                            .append(wayName).append("|")
                            .append(spName).append("|")
                            .append(fields[5]).append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                } else if (detailCode.equals("8036")) {
                    String refundName = ""; /*退费类型名称*/
                    if (fields[5].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String sysType = fields[5];
                    String feeTypeName = "";
                    if (sysType.equals("bs") || sysType.equals("bf")) {
                        feeTypeName = "--";
                    } else {
                        if (fields[6].equals("03")) { //费用类型
                            feeTypeName = "包月信息费";
                        } else {
                            feeTypeName = "点播信息费";
                        }
                    }
                    String wayName = "";
                    String spCode = fields[1];
                    String bizCode = fields[2];
                    String spName = billAccount.getOperName(spCode, bizCode);

                    String contextId = fields[7];
                    String totalDate = fields[0].substring(0, 10);
                    String contextName = billAccount.getMmappName(contextId, totalDate);
                    contextName = (contextName == null) ? "" : contextName;

                    fee = Double.valueOf(fields[3]);

                    sb.append(fields[0].substring(10)) /*起始时间*/.append("|")
                            .append(wayName).append("|")
                            .append(spName).append("-").append(contextName).append("|")
                            .append(fields[4]).append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                } else if (detailCode.equals("8037")) {
                    fee = Double.valueOf(fields[1]) + Double.valueOf(fields[2]);
                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("||代收话单小额支付|")
                            .append(fields[3]).append("|--|")
                            .append(String.format("%.2f", fee))
                            .append("||");
                } else if (detailCode.equals("8038")) {
                    fee = Double.valueOf(fields[1]);
                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("||智能名片夹随意呼|")
                            .append(fields[1]).append("|--|")
                            .append(String.format("%.2f", fee))
                            .append("||");
                } else if (detailCode.equals("8039")) {
                    fee = Double.valueOf(fields[1]);
                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("||多媒体彩铃|")
                            .append("无").append("|--|")
                            .append(String.format("%.2f", fee))
                            .append("||");
                } else if (detailCode.equals("8040")) {
                    fee = Double.valueOf(fields[1]);
                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("||会议电话|")
                            .append("无").append("|--|")
                            .append(String.format("%.2f", fee))
                            .append("||");
                } else if (detailCode.equals("8101") /*fb 爱流量，话费支付*/) {
                    fee = Double.valueOf(fields[1]) + Double.valueOf(fields[2]);
                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("||爱流量业务|")
                            .append("无").append("|话费支付|")
                            .append(String.format("%.2f", fee))
                            .append("||");
                } else if (detailCode.equals("8041")) {
                    String refundName = ""; /*退费类型名称*/
                    if (fields[6].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String feeTypeName = "";

                    if (fields[8].equals("03")) { //费用类型
                        feeTypeName = "包月信息费";
                    } else {
                        feeTypeName = "点播信息费";
                    }
                    String wayName = "";
                    String spCode = fields[1];
                    String bizCode = fields[2];
                    String spName = billAccount.getOperName(spCode, bizCode);

                    String copyRightCode = fields[7];
                    String musicName = billAccount.getMusicName(bizCode, copyRightCode);
                    musicName = (musicName == null) ? "" : musicName;

                    fee = Double.valueOf(fields[3]);

                    sb.append(fields[0].substring(10)) /*起始时间*/.append("|")
                            .append(wayName).append("|")
                            .append(spName).append("-").append(musicName).append("|")
                            .append(fields[4]).append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                } else if (detailCode.equals("8053") || detailCode.equals("8058")) {
                    fee = Double.valueOf(fields[4]);
                    String offerName = fields[2];
                    if (offerName.isEmpty()) {
                        offerName = this.getOfferName(fields[3]); //field[3] <==> offerId
                    }

                    sb = new StringBuilder();
                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("||")
                            .append(offerName) /*offerName*/
                            .append("|无|--|")
                            .append(String.format("%.2f", fee))
                            .append("||");
                } else if (detailCode.equals("8059")) {
                    String refundName = ""; /*退费类型名称*/
                    if (fields[5].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String sysType = fields[6];
                    String feeTypeName = "";
                    if (sysType.equals("cd")) {
                        feeTypeName = "--";
                    } else {
                        if (fields[7].equals("03")) { //费用类型
                            feeTypeName = "包月信息费";
                        } else {
                            feeTypeName = "点播信息费";
                        }
                    }
                    String wayName = "";
                    String spCode = fields[1];
                    String bizCode = fields[2];
                    String spName = billAccount.getOperName(spCode, bizCode);

                    fee = Double.valueOf(fields[3]);

                    sb.append(fields[0].substring(10)) /*起始时间*/.append("|")
                            .append(wayName).append("|")
                            .append(spName).append("|")
                            .append(fields[4]).append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                } else if (detailCode.equals("8062")) {
                    String refundName = ""; /*退费类型名称*/
                    if (fields[5].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String feeTypeName = "";

                    if (fields[6].equals("03")) { //费用类型
                        feeTypeName = "包月信息费";
                    } else {
                        feeTypeName = "点播信息费";
                    }

                    String wayName = "";
                    String spCode = fields[1];
                    String bizCode = fields[2];
                    String spName = billAccount.getOperName(spCode, bizCode);

                    fee = Double.valueOf(fields[3]) + Double.valueOf(fields[4]);

                    sb.append(fields[0].substring(10)) /*起始时间*/.append("|")
                            .append(wayName).append("|")
                            .append(spName).append("|")
                            .append("无").append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                } else if (detailCode.equals("8093") || detailCode.equals("8094") /*和家庭业务*/
                        || detailCode.equals("8095") /*飞信、和留言业务*/ || detailCode.equals("8097") /*mg 咪咕业务*/
                        || detailCode.equals("8098") /*mu 一卡多号 增值业务详单查询*/
                        || detailCode.equals("8100") /*jy 和教育*/) {
                    String refundName = ""; /*退费类型名称*/
                    if (fields[6].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String feeTypeName = "";

                    if (fields[1].equals("03")) { //费用类型
                        feeTypeName = "包月信息费";
                    } else {
                        feeTypeName = "点播信息费";
                    }

                    String wayName = "";
                    String spCode = fields[2];
                    String bizCode = fields[3];
                    String spName = billAccount.getOperName(spCode, bizCode);

                    fee = Double.valueOf(fields[4]) + Double.valueOf(fields[5]);

                    sb.append(fields[0].substring(10)) /*起始时间*/.append("|")
                            .append(wayName).append("|")
                            .append(spName).append("|")
                            .append("无").append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                }

                outDetailLines.add(sb.toString());

                totalFee += fee;
            }
        }

        List<String> globalList = new ArrayList<>();
        globalList.add("6.自有增值业务详单(包含A类和B类)");
        ChannelDetail outDetail = new ChannelDetail();
        outDetail.setQueryType("76");
        outDetail.setGlobalList(globalList);
        outDetail.setTitleInfo("时间|使用方式|业务名称|业务端口|费用类型|费用");
        outDetail.setFootInfo("合计：|" + String.format("%.2f", totalFee) + "元");
        outDetail.setDetailLines(outDetailLines);
        outDetail.setCount(outDetailLines.size());

        return outDetail;
    }

    /**
     * 功能：7.集团业务扣费记录
     *
     * @param phoneNo
     * @param queryType
     * @param dealBeginTime
     * @param dealEndTime
     * @param callBeginTime
     * @param callEndTime
     * @return
     */
    @Override
    public ChannelDetail groupDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                     String callBeginTime, String callEndTime) {

        int dealBegDay = Integer.parseInt(dealBeginTime.substring(0, 8));
        String gfDealBeginTime = String.format("%8d%s", DateUtils.addDays(dealBegDay, 1), dealBeginTime.substring(8, 14));
        int dealEndDay = Integer.parseInt(dealEndTime.substring(0, 8));
        String gfDealEndTime = String.format("%8d%s", DateUtils.addDays(dealEndDay, 1), dealEndTime.substring(8, 14));

        String otherDealBeginTime = dealBeginTime;
        String otherDealEndTime = dealEndTime;
        String[] options = new String[]{"X", callBeginTime, callEndTime};

        double totalFee = 0;
        List<String> outDetailLines = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();
            if (detailCode.equals("8051") || detailCode.equals("8056")) {
                dealBeginTime = gfDealBeginTime;
                dealEndTime = gfDealEndTime;
            } else {
                dealBeginTime = otherDealBeginTime;
                dealEndTime = otherDealEndTime;
            }
            log.debug("addedDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            if (!detailCode.equals("8051") && !detailCode.equals("8056")) {
                continue;
            }

            double fee = 0;
            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                fee = 0;

                fee = Double.valueOf(fields[4]);
                String offerName = fields[2];
                if (offerName.isEmpty()) {
                    offerName = this.getOfferName(fields[3]); //field[3] <==> offerId
                }

                sb = new StringBuilder();
                sb.append(fields[0].substring(10)) /*起始时间*/
                        .append("||")
                        .append(offerName) /*offerName*/
                        .append("||")
                        .append(String.format("%.2f", fee));

                outDetailLines.add(sb.toString());

                totalFee += fee;
            }

        }

        List<String> globalList = new ArrayList<>();
        globalList.add("7.集团业务扣费记录");
        ChannelDetail outDetail = new ChannelDetail();
        outDetail.setQueryType("77");
        outDetail.setGlobalList(globalList);
        outDetail.setTitleInfo("扣费时间|使用方式|业务名称|业务端口|费用");
        outDetail.setFootInfo("合计：|" + String.format("%.2f", totalFee) + "元");
        outDetail.setDetailLines(outDetailLines);
        outDetail.setCount(outDetailLines.size());

        return outDetail;
    }

    /**
     * 功能：8.SP代收费详单
     *
     * @param phoneNo
     * @param queryType
     * @param dealBeginTime
     * @param dealEndTime
     * @param callBeginTime
     * @param callEndTime
     * @return
     */
    @Override
    public ChannelDetail agencyDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                      String callBeginTime, String callEndTime) {

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        double totalFee = 0;
        List<String> outDetailLines = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();
            log.debug("agencyDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);
            if (detailCode.equals("8096")) { //校迅通增量需求，将部分数据合并
                detailLines = schoolPaperGroup(detailLines);
            }
            double fee = 0;
            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                fee = 0;
                sb = new StringBuilder();
                if (detailCode.equals("8070")) {
                    fee = Double.valueOf(fields[2]);
                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("|短信|彩票投注话单|彩票投注话单|无|无|")
                            .append(fields[1]) /*企业代码*/
                            .append("|无|")
                            .append(String.format("%.2f", fee))/*费用*/;

                } else if (detailCode.equals("8071")) {
                    String refundName = ""; /*退费类型名称*/
                    if (fields[7].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String spCode = fields[1];
                    String spCompanyName = billAccount.getSpName(spCode); //SP 公司名
                    if (spCompanyName.trim().isEmpty()) {
                        spCompanyName = fields[1];
                    }

                    String operCode = fields[2];
                    String spName = billAccount.getOperName(spCode, operCode); //sp下实例名称
                    if (spName.trim().isEmpty()) {
                        spName = fields[2];
                    }

                    fee = Double.valueOf(fields[3]) + Double.valueOf(fields[6]);

                    String feeType = fields[4]; //费用类型
                    String feeTypeName = "";
                    if (feeType.equals("03")) {
                        feeTypeName = "包月信息费";
                    } else {
                        feeTypeName = "点播信息费";
                    }

                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("|短信|")
                            .append(spName).append("|") /*spcode + bizCode 对应的serv_name*/
                            .append(fields[5]).append("|") /*服务代码/业务端口*/
                            .append(spCompanyName).append("|") /*spcode 对应的sp_name*/
                            .append(fields[1]).append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                } else if (detailCode.equals("8096")) {
                    String refundName = ""; /*退费类型名称*/
                    if (fields[7].equals("1")) { //退费类型
                        refundName = "（增值业务退费）";
                    }

                    String spCode = fields[1];
                    String spCompanyName = billAccount.getSpName(spCode); //SP 公司名
                    if (spCompanyName.isEmpty()) {
                        spCompanyName = fields[1];
                    }

                    String bizCode = fields[2]; //fields[2]
                    String spName = billAccount.getOperName(spCode, bizCode); //sp下实例名称
                    if (spName.isEmpty()) {
                        spName = fields[2];
                    }

                    if (bizCode.equals("-ASJX4") || bizCode.equals("-ASJXB4") || bizCode.equals("-ASJXC4")
                            || bizCode.equals("-SHJX4") || bizCode.equals("-SHJXB4") || bizCode.equals("-SHJXC4")) {
                        spName = "校讯通";
                        spCompanyName = "黑龙江移动(代收)";
                    }

                    fee = Double.valueOf(fields[3]) + Double.valueOf(fields[6]);

                    String feeType = fields[4]; //费用类型
                    String feeTypeName = "";
                    if (feeType.equals("03")) {
                        feeTypeName = "包月信息费";
                    } else {
                        feeTypeName = "点播信息费";
                    }

                    sb.append(fields[0].substring(10)) /*起始时间*/
                            .append("|短信|")
                            .append(spName).append("|") /*spcode + bizCode 对应的serv_name*/
                            .append(fields[5]).append("|") /*服务代码/业务端口*/
                            .append(spCompanyName).append("|") /*spcode 对应的sp_name*/
                            .append(fields[1]).append("|") /*spcode 服务商代码*/
                            .append(feeTypeName).append("|") /*费用类型名称*/
                            .append(String.format("%.2f", fee)).append("|")
                            .append(refundName);
                }

                totalFee += fee;

                outDetailLines.add(sb.toString());
            }
        }
        List<String> globalList = new ArrayList<>();
        globalList.add("8.SP代收费详单");
        ChannelDetail outDetail = new ChannelDetail();
        outDetail.setQueryType("78");
        outDetail.setGlobalList(globalList);
        outDetail.setTitleInfo("时间|使用方式|业务名称|业务端口|服务提供商|企业代码|费用类型|费用");
        outDetail.setFootInfo("合计：|" + String.format("%.2f", totalFee) + "元");
        outDetail.setDetailLines(outDetailLines);
        outDetail.setCount(outDetailLines.size());

        return outDetail;
    }

    /**
     * 功能：9.其他扣费详单
     *
     * @param phoneNo
     * @param queryType
     * @param dealBeginTime
     * @param dealEndTime
     * @param callBeginTime
     * @param callEndTime
     * @return
     */
    @Override
    public ChannelDetail otherDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                     String callBeginTime, String callEndTime) {

        int dealBegDay = Integer.parseInt(dealBeginTime.substring(0, 8));
        String gfDealBeginTime = String.format("%8d%s", DateUtils.addDays(dealBegDay, 1), dealBeginTime.substring(8, 14));
        int dealEndDay = Integer.parseInt(dealEndTime.substring(0, 8));
        String gfDealEndTime = String.format("%8d%s", DateUtils.addDays(dealEndDay, 1), dealEndTime.substring(8, 14));

        String otherDealBeginTime = dealBeginTime;
        String otherDealEndTime = dealEndTime;
        String[] options = new String[]{"X", callBeginTime, callEndTime};

        double totalFee = 0;
        List<String> outDetailLines = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();
            if (detailCode.equals("8052") || detailCode.equals("8057") || detailCode.equals("8060") || detailCode.equals("8061")) {
                dealBeginTime = gfDealBeginTime;
                dealEndTime = gfDealEndTime;
            } else {
                dealBeginTime = otherDealBeginTime;
                dealEndTime = otherDealEndTime;
            }
            log.debug("otherDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                if (fields[0].startsWith("0")) {
                    continue;
                }

                sb = new StringBuilder();
                sb.append(fields[0].substring(0, 8));

                double fee = 0;
                if (detailCode.equals("8052") || detailCode.equals("8057") || detailCode.equals("8060") || detailCode.equals("8061")) {
                    if (fields[2].equals("")) {
                        String offerName = fields[2];
                        if (offerName.isEmpty()) {
                            offerName = this.getOfferName(fields[3]); //field[3] <==> offerId
                        }
                        fee = Double.valueOf(fields[4]);

                        sb.append("|").append(offerName).append("|").append(String.format("%.2f", fee));
                    }

                } else if (detailCode.equals("8063")) {

                    fee = Double.valueOf(fields[1]) + Double.valueOf(fields[2]);
                    sb.append("|").append("物联网包月").append("|").append(String.format("%.2f", fee));

                }

                totalFee += fee;
                outDetailLines.add(sb.toString());

            }
        }

        List<String> globalList = new ArrayList<>();
        globalList.add("9.其他扣费详单");
        ChannelDetail outDetail = new ChannelDetail();
        outDetail.setQueryType("79");
        outDetail.setGlobalList(globalList);
        outDetail.setTitleInfo("时间|费用类型|金额");
        outDetail.setFootInfo("合计：|" + String.format("%.2f", totalFee) + "元");
        outDetail.setDetailLines(outDetailLines);
        outDetail.setCount(outDetailLines.size());

        return outDetail;
    }

    /**
     * 功能：10.减免费用
     *
     * @param phoneNo
     * @param queryType
     * @param dealBeginTime
     * @param dealEndTime
     * @param callBeginTime
     * @param callEndTime
     * @return
     */
    @Override
    public ChannelDetail favourDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                      String callBeginTime, String callEndTime) {

        int dealBegDay = Integer.parseInt(dealBeginTime.substring(0, 8));
        String gfDealBeginTime = String.format("%8d%s", DateUtils.addDays(dealBegDay, 1), dealBeginTime.substring(8, 14));
        int dealEndDay = Integer.parseInt(dealEndTime.substring(0, 8));
        String gfDealEndTime = String.format("%8d%s", DateUtils.addDays(dealEndDay, 1), dealEndTime.substring(8, 14));

        String otherDealBeginTime = dealBeginTime;
        String otherDealEndTime = dealEndTime;
        String[] options = new String[]{"X", callBeginTime, callEndTime};

        double totalFee = 0;
        List<String> outDetailLines = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();
            if (detailCode.equals("8080")) {
                dealBeginTime = gfDealBeginTime;
                dealEndTime = gfDealEndTime;
            } else {
                dealBeginTime = otherDealBeginTime;
                dealEndTime = otherDealEndTime;
            }
            log.debug("favourDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                sb = new StringBuilder();

                if (detailCode.equals("8080")) {
                    double fee = Double.valueOf(fields[2]);
                    sb.append(fields[0].substring(0, 7)).append("|")
                            .append(fields[1]).append("|")
                            .append(String.format("%.2f", fee));

                    totalFee += fee;
                    outDetailLines.add(sb.toString());

                }
            }
        }

        List<String> globalList = new ArrayList<>();
        globalList.add("10.减免费用");
        ChannelDetail outDetail = new ChannelDetail();
        outDetail.setQueryType("80");
        outDetail.setGlobalList(globalList);
        outDetail.setTitleInfo("时间|减免类型|金额");
        outDetail.setFootInfo("合计：|" + String.format("%.2f", totalFee) + "元");
        outDetail.setDetailLines(outDetailLines);
        outDetail.setCount(outDetailLines.size());

        return outDetail;
    }

    @Override
    public ChannelDetail netDetailDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                         String callBeginTime, String callEndTime, String chargingId, String resv) {

        String[] options = new String[]{"X", callBeginTime, callEndTime, chargingId, resv};

        double totalFee = 0.00;
        List<String> outDetailLines = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();

            log.debug("netDetailDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                sb = new StringBuilder();

                if (detailCode.equals("8091") || detailCode.equals("8092")) {

                    //TODO 到访地区名称校证（测试阶段需要时补充）
                    String areaName = fields[1]; //到访地区名称

                    String apnName = fields[2]; //APN的网络标识
                    if (fields[20].equals("1040000019")) {
                        apnName = String.format("%s(和飞信)", apnName);
                    }

                    String duration = this.dealUseTime(Long.parseLong(fields[3]));

                    double netKTmp = Double.valueOf(fields[4]) + Double.valueOf(fields[5]) + Double.valueOf(fields[6])
                            + Double.valueOf(fields[7]) + Double.valueOf(fields[8]) + Double.valueOf(fields[9])
                            + Double.valueOf(fields[10]) + Double.valueOf(fields[11]) + Double.valueOf(fields[12])
                            + Double.valueOf(fields[13]) + Double.valueOf(fields[14]) + Double.valueOf(fields[15]); /*流量总量，KB*/

                    String offerId = "";
                    //if (Long.parseLong(fields[21]) == 0) {
                    offerId = fields[16];
                    //} else {
                    //    offerId = fields[17];
                    //}
                    String offerName = this.getOfferName(offerId);
                    if (fields.length > 27) {
                        //gg业务，资费id是拼成长串的，需要对每一个offerId都做对应
                        String allOfferName = this.getAllOfferName(fields[27], fields[16]);

                        if (!allOfferName.isEmpty()) {
                            offerName = allOfferName;
                        }
                    }

                    double fee = Double.valueOf(fields[18]) + Double.valueOf(fields[19]);
                    totalFee += fee;

                    String recordType = fields[26];
                    String mnscType = fields[22];
                    String netName = this.getNetTypeName(mnscType, recordType);

                    sb.append(fields[0]).append("|")
                            .append(areaName).append("|")
                            .append(apnName).append("|")
                            .append(duration).append("|")
                            .append(this.dealNetK(netKTmp)).append("|")
                            .append(offerName).append("|")
                            .append(String.format("%.2f", fee)).append("|")
                            .append(netName);

                    outDetailLines.add(sb.toString());
                }
            }

        }

        Collections.sort(outDetailLines, new DetailOrder(0, "\\|"));

        ChannelDetail outDetail = new ChannelDetail();
        outDetail.setQueryType("95");
        outDetail.setFootInfo("合计：|" + String.format("%.2f", totalFee) + "元");
        outDetail.setDetailLines(outDetailLines);
        outDetail.setCount(outDetailLines.size());

        return outDetail;
    }

    /**
     * 移动校讯通话单合并
     *
     * @param inDetailLines
     * @return
     */
    private List<String> schoolPaperGroup(List<String> inDetailLines) {
        /**
         * 针对校讯通转型资费 九个业务代码分别对应一条话单 详单需要合并展示 特别处理
         * 按oper_code 进行分组
         * -SHJX4  -SHLL5 -SHDX5 为一组  合并一条详单展示
         * -SHJXB4 -SHLLB5 -SHDXB5 为一组  合并一条详单展示
         * -SHJXC4 -SHLLC5	-SHDXC5 为一组  合并一条详单展示
         * -ASJX4  -ASHLL5 -ASHDX5 为一组  合并一条详单展示
         * -ASJXB4 -ASHLLB5 -ASHDXB5 为一组  合并一条详单展示
         * -ASJXC4 -ASHLLC5	-ASHDXC5 为一组  合并一条详单展示
         * 经讨论  用户只会按组订购 不会跳组订购 且一个用户 一组 只会订购一次
         */
        List<String> outDetailLines /*最后整合后的详单记录行*/ = new ArrayList<>();
        List<List<String>> groupLines = new ArrayList<>();
        Map<String, Integer> indexMap = new HashMap<>();

        int outLastIndex = 0; /*标记合并后的List中的位置*/
        for (String line : inDetailLines) {
            if (line.isEmpty()) continue;
            String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

            String operCode = fields[2];
            if (operCode.startsWith("-SH") || operCode.startsWith("-AS") || operCode.startsWith("-NSH")) {
                boolean schoolFlag = false;

                String lineKey = null;
                if (operCode.equals("-SHJX4") || operCode.equals("-SHLL5") || operCode.equals("-SHDX5")) {
                    operCode = "-SHJX4";
                    schoolFlag = true;
                } else if (operCode.equals("-SHJXB4") || operCode.equals("-SHLLB5") || operCode.equals("-SHDXB5")) {
                    operCode = "-SHJXB4";
                    schoolFlag = true;
                } else if (operCode.equals("-SHJXC4") || operCode.equals("-SHLLC5") || operCode.equals("-SHDXC5")) {
                    operCode = "-SHJXC4";
                    schoolFlag = true;
                } else if (operCode.equals("-ASJX4") || operCode.equals("-ASHLL5") || operCode.equals("-ASHDX5")) {
                    operCode = "-ASJX4";
                    schoolFlag = true;
                } else if (operCode.equals("-ASJXB4") || operCode.equals("-ASHLLB5") || operCode.equals("-ASHDXB5")) {
                    operCode = "-ASJXB4";
                    schoolFlag = true;
                } else if (operCode.equals("-ASJXC4") || operCode.equals("-ASHLLC5") || operCode.equals("-ASHDXC5")) {
                    operCode = "-ASJXC4";
                    schoolFlag = true;
                } else if (operCode.equals("-NSHJX4") || operCode.equals("-NSHLL5") || operCode.equals("-NSHDX5")) {
                    operCode = "-NSHJX4";
                    schoolFlag = true;
                } else if (operCode.equals("-NSHJXB4") || operCode.equals("-NSHLLB5") || operCode.equals("-NSHDXB5")) {
                    operCode = "-NSHJXB4";
                    schoolFlag = true;
                } else if (operCode.equals("-NSHJXC4") || operCode.equals("-NSHLLC5") || operCode.equals("-NSHDXC5")) {
                    operCode = "-NSHJXC4";
                    schoolFlag = true;
                }
                if (schoolFlag) {
                    lineKey = new StringBuilder().append(fields[0].substring(0, 6)).append(operCode).toString(); //按月及校迅通opercode分组，合并
                    fields[2] = operCode; //把最新的opercode赋给原始行

                    if (indexMap.containsKey(lineKey)) { //合并话单
                        List<String> oldLine = groupLines.get(indexMap.get(lineKey));
                        double otherFee = Double.parseDouble(oldLine.get(3)) + Double.parseDouble(fields[3]);
                        double cFee = Double.parseDouble(oldLine.get(6)) + Double.parseDouble(fields[6]);
                        oldLine.set(3, String.format("%.2f", otherFee));
                        oldLine.set(6, String.format("%.2f", cFee));

                    } else {
                        indexMap.put(lineKey, outLastIndex);
                        groupLines.add(Arrays.asList(fields));
                    }
                    outLastIndex++;
                }

            } else {
                outDetailLines.add(line);
            }
        }

        StringBuilder sb = null;
        for (List<String> line : groupLines) {
            sb = new StringBuilder();
            for (String field : line) {
                sb.append(field).append("|");
            }

            outDetailLines.add(sb.toString());
        }

        Collections.sort(outDetailLines, new DetailOrder());

        return outDetailLines;
    }

    private String getOfferName(String offerId) {
        String offerName = "";
        if (offerId.isEmpty() || offerId.matches("[0]*") || offerId.equals("无")) {
//            offerName = "--";
            offerName = "标准资费";
        } else {
            PdPrcInfoEntity pdPrcInfo = prod.getPdPrcInfo(String.format("M0%s", offerId)); //TODO 需要重新处理
            offerName = (pdPrcInfo == null) ? offerId : pdPrcInfo.getProdPrcName();
        }
        return offerName;
    }

    /*改用 record_type 区分2G/3G 原来的msnc 做为缺省值*/
    private String getNetTypeName(String msncType, String recordType) {
        String netName = "2G";
        if (msncType.equals("0")) {
            netName = "2G网络";
        } else {
            netName = "3G网络";
        }
        if (recordType.contains("20")) {
            netName = "3G网络";
        } else if (recordType.contains("19")) {
            netName = "2G网络";
        } else if (recordType.contains("21")) {
            netName = "4G网络";
        }
        return netName;
    }

    private String getNetTypeName2(String recordType) {
        String netName = "2G";

        if (recordType.contains("20")) {
            netName = "3G";
        } else if (recordType.contains("19")) {
            netName = "2G";
        } else if (recordType.contains("21")) {
            netName = "4G";
        }

        return netName;
    }

    private String getWlanNetName(String netType) {
        String netName = "2G网络";
        if (netType.equals("01")) {
            netName = "普通大众";
        } else if (netType.equals("02")) {
            netName = "实体卡";
        } else if (netType.equals("03")) {
            netName = "高校";
        } else if (netType.equals("04")) {
            netName = "电子卡";
        } else if (netType.equals("05")) {
            netName = "自动认证";
        } else if (netType.equals("80")) {
            netName = "本地大众";
        } else if (netType.equals("81")) {
            netName = "本地高校";
        }

        return netName;
    }

    private String getPortPhone(String phone, String serviceType) {

        String dispPhone = "";
        /*8440 地市安保详单（老）；8142：营业前台*/

        if (!serviceType.isEmpty() && (serviceType.equals("8142") || serviceType.equals("8440"))) { //前台展示原样，其他展示加密
            dispPhone = phone;

        } else {
            if (phone.length() > 4) {
                dispPhone = new StringBuilder()
                        .append(phone.substring(0, phone.length() - 4))
                        .append("****").toString();
            } else {
                dispPhone = phone;
            }
        }

        return dispPhone;

    }

    private String getRoamName(String roamType, String feeType) {
        String roamName = "";

        if (roamType.isEmpty()) {
            if (feeType.equals("0")) {
                roamName = "本地";
            } else {
                roamName = "长途";
            }
        } else {

            if (roamType.equals("0") && feeType.equals("0")) {
                roamName = "本地";
            } else if (roamType.equals("0") && (feeType.equals("2") || feeType.equals("3"))) {
                roamName = "国内长途";
            } else if (feeType.equals("4")) {
                roamName = "港澳台长途";
            } else if (roamType.compareTo("5") < 0 && feeType.compareTo("4") > 0) {
                roamName = "国际长途";
            } else if ((roamType.equals("2") || roamType.equals("4")) && feeType.compareTo("4") < 0) {
                roamName = "国内漫游";
            } else if (roamType.equals("8") && feeType.compareTo("4") < 0) {
                roamName = "港澳台漫游";
            } else if (roamType.equals("6") || roamType.equals("7")) {
                roamName = "国际漫游";
            }
        }

        return roamName;
    }

    private String getMnsName(String mnsType, String recordType) {
        String mnsName = "";
        recordType = recordType.trim();
        if (mnsType.equals("0")) {
            mnsName = "2G网络";
        } else if (mnsType.equals("1")) {
            mnsName = "3G网络";
        }

        if (!recordType.isEmpty()) {
            if (recordType.equals("0")) {
                mnsName = "2G网络";
            } else {
                mnsName = "3G网络";
            }
        }

        if (mnsType.equals("A")) {
            if (recordType.equals("0")) {
                mnsName = "高清语音";
            } else {
                mnsName = "高清视频";
            }
        }

        return mnsName;
    }

    private String getRefundName(String refundFlag) {
        String refundName = "";
        if (refundFlag.equals("1")) {
            refundName = "（增值业务退费）";
        }

        return refundName;
    }

    private String dealUseTime(Long time) {
        long minute = 0;
        long seconds = 0;
        long hour = 0;

        StringBuilder sb = new StringBuilder();

        if (time > 60) {
            minute = time / 60;
            seconds = time % 60;

            if (minute >= 60) {
                hour = minute / 60;
                minute = minute % 60;
                sb.append(hour).append("小时").append(minute).append("分").append(seconds).append("秒");
            } else {
                sb.append(minute).append("分").append(seconds).append("秒");
            }
        } else if (time == 60) {
            sb.append("1分");
        } else {
            sb.append(time).append("秒");
        }

        return sb.toString();
    }

    private String getOperName(String operCode) {
        String operName = "";

        if (operCode.equals("01")) {
            operName = "普通大众";
        } else if (operCode.equals("02")) {
            operName = "实体卡";
        } else if (operCode.equals("04")) {
            operName = "电子卡";
        } else if (operCode.equals("05")) {
            operName = "自动认证";
        } else if (operCode.equals("80")) {
            operName = "本地大众";
        } else {
            operName = "2G网络";
        }
        return operName;
    }

    private String dealNetK(double netB) {
        String outNet = "0.00(KB)";

        String netK = "0";

        if (netB == 0) {
            outNet = "0.00(KB)";
        } else if (netB > 1024) {
            netK = String.format("%.2f", netB / 1024.0);
        } else {
            outNet = String.format("%.2f(KB)", netB / 1024.0);
        }

        if (Double.valueOf(netK) > 1024) {
            String netM = String.format("%d", new BigDecimal(netK).divide(new BigDecimal(1024)).longValue());
            netK = String.format("%.2f", Double.valueOf(netK) / 1024.0);
            outNet = String.format("%s(MB)%s(KB)", netM, netK);
        }
        return outNet;
    }

    class DetailOrder implements Comparator<String> {
        int index = 0; /*排序的字段下标*/
        String sepStr = "\\|";

        public DetailOrder() {
        }

        public DetailOrder(int index, String sepStr) {
            this.index = index;
            this.sepStr = sepStr;
        }

        @Override
        public int compare(String o1, String o2) {
            int ret = 0;
            String indexString1 = getFieldsString(o1, sepStr, index);
            String indexString2 = getFieldsString(o2, sepStr, index);
            ret = indexString1.compareTo(indexString2);
            ret = ret > 0 ? 1 : (ret == 0 ? 0 : -1);
            return ret;
        }

    }

    /**
     * 对字符串o，按indexStr进行分割，获取index位置处的字符串
     *
     * @param o
     * @param indexStr
     * @param index
     * @return
     */
    private String getFieldsString(String o, String indexStr, int index) {
        String[] fields = o.split(indexStr);
        String fieldName = "";
        if (fields.length > index) {
            fieldName = fields[index];
        }

        return fieldName;
    }

    private long getCallDuration(String beginTime, String endTime) {
        long duration = 0;
        DateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
        try {
            Date begDate = df.parse(beginTime);
            Date endDate = df.parse(endTime);

            duration = (endDate.getTime() - begDate.getTime()) / 1000;

        } catch (ParseException e) {
            e.printStackTrace();
        }

        return duration;
    }

    private String getAllOfferName(String offerIds, String roamCarrier) {
        String allOfferName = "";
        StringBuilder offerBuff = null;
        if (!offerIds.isEmpty() && !offerIds.matches("[0]*") && !offerIds.equals("无")) {
            String[] arr = offerIds.split(",");
            offerBuff = new StringBuilder();
            StringBuilder sb = null;
            for (int i = 0; i < arr.length; i++) {
                String offerid = arr[i];
                sb = new StringBuilder();

                //TODO 产品ID和资费ID怎么区分
                if (offerid.length() > 6) { //可能是产品ID或服务ID
                    //TODO /*通用流量统付业务获取集团客户简称*/
                    //补充获取产品名称的处理，并追加 ‘通用流量统付’

                    /*定向流量统付业务获取客户产品简称 */
                    //补充定向流量业务名称，并追加 ‘业务专属流量统付’


                } else if (offerid.length() >= 5) {
                    /*TODO 如截取出来的offer_id的第六位是0，说明是主卡多终端共享*/
                    /*合并函数中offer_id为空时填值00 所以要滤掉*/
                    String offerNameTmp = this.getOfferName(offerid.substring(0, 5));
                    sb.append(offerNameTmp);
                    if (roamCarrier.equals("ZZXQ")) {
                        sb.append("(剩余流量转赠)");
                    }
                    if (offerid.length() == 6) {
                        if (offerid.charAt(5) == '0' && !offerid.equals("00")) {
                            sb.append("(主卡共享)");
                        } else if (offerid.charAt(5) == '1' && !offerid.equals("00")) {
                            sb.append("(上月结转流量)");
                        } else if (offerid.charAt(5) == '2' && !offerid.equals("00")) {
                            sb.append("(主卡共享)上月结转流量");
                        }
                    }
                }

                offerBuff.append(sb.toString());

                if (offerBuff.length() > 80) {
                    break;
                }

                offerBuff.append(",");
            }
            offerBuff.append("...");
            allOfferName = offerBuff.toString();
        }

        return allOfferName;
    }

    @Override
    public List<String> rawDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                  String callBeginTime, String callEndTime) {

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        List<String> outDetailLines = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();

            log.debug("rawDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                for (int i = 0; i < fields.length; i++) {
                    fields[i] = StringUtils.isEmpty(fields[i]) ? "--" : fields[i];
                }

                if (detailCode.equals("5011")) {
                    String formatLine = String.format(
                            "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s",
                            fields[0], fields[1], fields[2], fields[3], fields[4], fields[5], fields[6], fields[7], fields[8], fields[9],
                            fields[10], fields[11], fields[12], fields[13], fields[14], fields[15], fields[16], fields[17], fields[18],
                            fields[19], fields[20], fields[21], fields[22], fields[23], fields[24], fields[25], fields[26], fields[27],
                            fields[28], fields[29], fields[30], fields[31], fields[32], fields[33], fields[34], fields[35], fields[36],
                            fields[37], fields[38], fields[39], fields[40], fields[41], fields[42], fields[43], fields[44]);

                    outDetailLines.add(formatLine);
                } else if (detailCode.equals("5012")) {
                    String formatLine = String.format(
                            "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s",
                            fields[0], fields[1], fields[2], fields[3], fields[4], fields[5], fields[6], fields[7], fields[8], fields[9],
                            fields[10], fields[11], fields[12], fields[13], fields[14], fields[15], fields[16], fields[17], fields[18],
                            fields[19], fields[20], fields[21], fields[22], fields[23], fields[24], fields[25], fields[26], fields[27],
                            fields[28], fields[29], fields[30], fields[31], fields[32], fields[33], fields[34], fields[35], fields[36],
                            fields[37], fields[38], fields[39], fields[40], fields[41], fields[42], fields[43], fields[44], fields[45],
                            fields[46], fields[47], fields[48]);

                    outDetailLines.add(formatLine);
                } else if (detailCode.equals("5013")) {
                    String formatLine = String.format(
                            "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s",
                            fields[0], fields[1], fields[2], fields[3], fields[4], fields[5], fields[6], fields[7], fields[8], fields[9],
                            fields[10], fields[11], fields[12], fields[13], fields[14], fields[15], fields[16], fields[17], fields[18],
                            fields[19], fields[20], fields[21], fields[22]);
                    outDetailLines.add(formatLine);
                } else if (detailCode.equals("5014") || detailCode.equals("5015")) {
                    String formatLine = String.format(
                            "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s",
                            fields[0], fields[1], fields[2], fields[3], fields[4], fields[5], fields[6], fields[7], fields[8], fields[9],
                            fields[10], fields[11], fields[12], fields[13], fields[14], fields[15], fields[16], fields[17], fields[18],
                            fields[19], fields[20], fields[21], fields[22], fields[23], fields[24], fields[25], fields[26],
                            fields[27], fields[28], fields[29], fields[30], fields[31], fields[32]);

                    outDetailLines.add(formatLine);
                } else if (detailCode.equals("5016")) {
                    String areaString = new StringBuilder().append(fields[3]).append(fields[4]).toString();
                    String formatLine = String.format("%s|%s|%s|%s", fields[0], fields[1], fields[2], areaString);
                    outDetailLines.add(formatLine);
                }

            }

        }

        return outDetailLines;

    }

    @Override
    public DetailLimitEntity getDetailLimitConf(String loginNo, String opCode, String powerType) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "LOGIN_NO", loginNo);
        safeAddToMap(inMap, "OP_CODE", opCode);
        safeAddToMap(inMap, "POWER_TYPE", powerType);

        DetailLimitEntity result = (DetailLimitEntity)
                baseDao.queryForObject("act_detaillimit_conf.qryDetailLimitConf", inMap);
        return result;
    }

    @Override
    public void insertDetailLimitConf(String loginNo, String opCode, String powerType) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "LOGIN_NO", loginNo);
        safeAddToMap(inMap, "OP_CODE", opCode);
        safeAddToMap(inMap, "POWER_TYPE", powerType);
        safeAddToMap(inMap, "MAX_QUERY_SUM", CommonConst.DETAIL_MAX_QURRY_SUM);
        safeAddToMap(inMap, "USED_SUM", 1);
        safeAddToMap(inMap, "OP_NOTE", loginNo);

        baseDao.insert("act_detaillimit_conf.instDetailLimitConf", inMap);
    }

    @Override
    public void updateDetailLimitUsedSum(String loginNo, String opCode, String powerType, boolean isFirst) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "LOGIN_NO", loginNo);
        safeAddToMap(inMap, "OP_CODE", opCode);
        safeAddToMap(inMap, "POWER_TYPE", powerType);
        if (isFirst) { //当月第一次查询时
            safeAddToMap(inMap, "IS_FIRST", isFirst);
        }

        baseDao.update("act_detaillimit_conf.updDetailLimit", inMap);

    }

    @Override
    public List<String> securityDetail(String phoneNo, String detailCode, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                       String callBeginTime, String callEndTime) {
        String[] options = new String[]{"X", callBeginTime, callEndTime};

        List<String> outDetailLines = new ArrayList<>();

        log.debug("securityDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);

        List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

        for (String line : detailLines) {
            if (line.isEmpty()) continue;
            String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

            if (detailCode.equals("1501")) {

                String phoneCall = ""; //发起用户
                String phoneAns = ""; //接收用户
                if (fields[0].equals("主叫")) {
                    phoneCall = fields[1];
                    phoneAns = fields[2];
                } else {
                    phoneCall = fields[2];
                    phoneAns = fields[1];
                }


                String mnsType = fields[11];
                String mnsTypeName = mnsType.equals("1") ? "G3" : "G网";


                String formatLine = String.format("%-15s%-15s%-20s%-20s%-10s%-15s%-10s%-10s%-15s%-15s%-15s",
                        phoneCall, phoneAns, fields[3], fields[4], fields[5], fields[6], fields[7], fields[8], fields[9], fields[10], mnsTypeName);

                outDetailLines.add(formatLine);
            } else if (detailCode.equals("1507")) {

                String mnsType = fields[11];
                String mnsTypeName = mnsType.equals("1") ? "G3" : "G网";

                String formatLine = String.format(
                        "%-15s%-15s%-15s%-20s%-20s%-10s%-15s%-10s%-10s%-15s%-15s%-15s",
                        fields[1], fields[2], "-", fields[3], fields[4], fields[5], fields[6], fields[7], fields[8], fields[9],
                        fields[10], mnsTypeName);

                outDetailLines.add(formatLine);
            } else if (detailCode.equals("1503") || detailCode.equals("1504") || detailCode.equals("1505")
                    || detailCode.equals("1506")) {

                String phoneCall = ""; //发起用户
                String phoneAns = ""; //接收用户
                if (fields[0].equals("0")) {
                    phoneCall = fields[1];
                    phoneAns = fields[2];
                } else {
                    phoneCall = fields[2];
                    phoneAns = fields[1];
                }

                String formatLine = String.format("%-15s %-15s %-22s", phoneCall, phoneAns, fields[3]);
                outDetailLines.add(formatLine);
            }

        }

        return outDetailLines;

    }

    @Override
    public String getDetailBillQryFlag(Long idNo) {

        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "ID_NO", idNo);
        String qryFlag = (String) baseDao.queryForObject("cs_custbillqry_info.qryBillQryFlag", inMap);

        if (StringUtils.isEmpty(qryFlag)) {
            qryFlag = "Y";
        }

        return qryFlag;
    }


    @Override
    public ChannelDetail spDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                  String callBeginTime, String callEndTime) {
        String[] options = new String[]{"X", callBeginTime, callEndTime};

        double totalFee = 0;
        List<String> outDetailLines = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();
            log.debug("spDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);
            double fee = 0; /*单条展示的费用*/
            double fee1 = 0; /*累和的每一个费用*/
            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                fee = 0;

                if (detailCode.equals("9518")) {
                    if (!fields[3].startsWith("12590")) {
                        continue;
                    }
                }
                sb = new StringBuilder();
                //时间|使用方式|业务名称|业务代码|服务提供商|企业代码|费用类型|费用
                if (detailCode.equals("9501") || detailCode.equals("9502") || detailCode.equals("9504")
                        || detailCode.equals("9505") || detailCode.equals("9506") || detailCode.equals("9507")
                        || detailCode.equals("9508") || detailCode.equals("9510") || detailCode.equals("9520")
                        || detailCode.equals("9521") || detailCode.equals("9527")
                        || detailCode.equals("9528") || detailCode.equals("9516") || detailCode.equals("9517")
                        || detailCode.equals("9519")) {
                    String time = fields[0]/*.substring(10)*/;
                    String useType = "--"; /*使用方式*/
                    String operName = ""; /*业务名称*/
                    String operCode = ""; /*业务代码*/
                    String spName = ""; /*服务提供商, 企业名称*/
                    String spCode = ""; /*企业代码*/
                    String feeType = ""; /*费用类型*/

                    if (detailCode.equals("9501") || detailCode.equals("9520") || detailCode.equals("9521")
                            || detailCode.equals("9528") || detailCode.equals("9519")) {
                        useType = "短信";
                    } else if (detailCode.equals("9502")) {
                        useType = "移动梦网WAP";
                    }

                    if (detailCode.equals("9516") || detailCode.equals("9517")) {
                        spCode = fields[2];
                        operCode = fields[3];
                        feeType = fields[1]; //费用类型
                    } else {
                        spCode = fields[1];
                        operCode = fields[2];
                        feeType = fields[5]; //费用类型
                    }
                    spName = billAccount.getSpName(spCode); //SP 公司名
                    if (spName.trim().isEmpty()) {
                        spName = spCode;
                    }

                    operName = billAccount.getOperName(spCode, operCode); //sp下实例名称
                    if (operName.trim().isEmpty()) {
                        operName = fields[2];
                    }

                    if (detailCode.equals("9516") || detailCode.equals("9517")) {
                        fee = Double.valueOf(fields[4]) + Double.valueOf(fields[5]);
                    } else {
                        fee = Double.valueOf(fields[3]) + Double.valueOf(fields[4]);
                    }
                    fee1 = fee;

                    String feeTypeName = "";
                    if (detailCode.equals("9504")) {
                        if (feeType.equals("04")) {
                            feeTypeName = "包月信息费";
                        } else {
                            feeTypeName = "点播信息费";
                        }
                    } else {
                        if (feeType.equals("03")) {
                            feeTypeName = "包月信息费";
                        } else {
                            feeTypeName = "点播信息费";
                        }
                    }

                    sb.append(time).append("|")
                            .append(useType).append("|")
                            .append(operName).append("|")
                            .append(operCode).append("|")
                            .append(spName).append("|")
                            .append(spCode).append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee));

                } else if (detailCode.equals("9503") || detailCode.equals("9509") || detailCode.equals("9513")
                        || detailCode.equals("9514") || detailCode.equals("9522") || detailCode.equals("9523")
                        || detailCode.equals("9524") || detailCode.equals("9525") || detailCode.equals("9526")) {
                    String time = fields[0]/*.substring(10)*/;
                    String useType = "--"; /*使用方式*/
                    String operName = ""; /*业务名称*/
                    String operCode = ""; /*业务代码*/
                    String spName = ""; /*服务提供商, 企业名称*/
                    String spCode = ""; /*企业代码*/
                    String feeType = "--"; /*费用类型*/

                    if (detailCode.equals("9503") || detailCode.equals("9522")) {
                        useType = "移动梦网WAP";
                    } else if (detailCode.equals("9514")) {
                        useType = "国际彩信";
                    } else if (detailCode.equals("9523") || detailCode.equals("9524")) {
                        useType = "短信";
                    }

                    spCode = fields[1];
                    spName = billAccount.getSpName(spCode); //SP 公司名
                    if (spName.trim().isEmpty()) {
                        spName = spCode;
                    }

                    operCode = fields[2];
                    operName = billAccount.getOperName(spCode, operCode); //sp下实例名称
                    if (operName.trim().isEmpty()) {
                        operName = fields[2];
                    }

                    if (detailCode.equals("9523") || detailCode.equals("9524") || detailCode.equals("9525")) {
                        fee1 = Double.valueOf(fields[4]);
                    } else {
                        fee1 = Double.valueOf(fields[3]);
                    }
                    fee = fee1;

                    if (detailCode.equals("9514")) {
                        fee = (fee1 == 0.00) ? Double.valueOf(fields[6]) : Double.valueOf(fields[5]);
                    }

                    String feeTypeName = "--";
                    if (detailCode.equals("9509") || detailCode.equals("9526")) {
                        feeType = fields[4];
                    } else if (detailCode.equals("9523")) {
                        feeType = fields[3];
                    }

                    if (feeType.equals("03")) {
                        feeTypeName = "包月信息费";
                    } else {
                        feeTypeName = "点播信息费";
                    }

                    sb.append(time).append("|")
                            .append(useType).append("|")
                            .append(operName).append("|")
                            .append(operCode).append("|")
                            .append(spName).append("|")
                            .append(spCode).append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee));

                } else if (detailCode.equals("9511")) {
                    String time = fields[0]/*.substring(10)*/;
                    String useType = "--"; /*使用方式*/
                    String operName = ""; /*业务名称*/
                    String operCode = ""; /*业务代码*/
                    String spName = ""; /*服务提供商, 企业名称*/
                    String spCode = ""; /*企业代码*/
                    String feeType = "--"; /*费用类型*/

                    operCode = fields[1];

                    if (detailCode.equals("9511")) {
                        useType = "语音";
                        operName = "语音杂志";
                        spName = "--";
                        spCode = "--";
                    }

                    fee = Double.valueOf(fields[2]);
                    fee1 = fee;

                    String feeTypeName = "--";

                    sb.append(time).append("|")
                            .append(useType).append("|")
                            .append(operName).append("|")
                            .append(operCode).append("|")
                            .append(spName).append("|")
                            .append(spCode).append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee));

                } else if (detailCode.equals("9515")) {
                    String time = fields[0]/*.substring(10)*/;
                    String useType = "--"; /*使用方式*/
                    String operName = ""; /*业务名称*/
                    String operCode = ""; /*业务代码*/
                    String spName = ""; /*服务提供商, 企业名称*/
                    String spCode = ""; /*企业代码*/
                    String feeType = "--"; /*费用类型*/

                    fee = Double.valueOf(fields[1]) + Double.valueOf(fields[2]);
                    fee1 = fee;

                    long paySn = Long.parseLong(fields[4]);

                    MicroPayEntity mpe = this.getPhonePaySpInfo(paySn);

                    if (mpe != null) {
                        spCode = mpe.getUnitCode();
                        spName = mpe.getFactorFour();
                        operCode = mpe.getBusiCode(); //GOODS_ID
                        operName = mpe.getFactorFive(); //GOOD_NAME
                    }

                    if (operName.isEmpty()) {
                        operName = "代收话单小额支付";
                    }

                    if (operCode.isEmpty()) {
                        operCode = "10658008";
                    }

                    if (spName.isEmpty()) {
                        spName = "联动优势科技有限公司";
                    }

                    if (spCode.isEmpty()) {
                        spCode = "901525";
                    }

                    feeType = fields[3];
                    String feeTypeName = "--";
                    if (feeType.equals("03")) {
                        feeTypeName = "包月信息费";
                    } else {
                        feeTypeName = "点播信息费";
                    }

                    sb.append(time).append("|")
                            .append(useType).append("|")
                            .append(operName).append("|")
                            .append(operCode).append("|")
                            .append(spName).append("|")
                            .append(spCode).append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee));


                } else if (detailCode.equals("9512")) {
                    String time = fields[0]/*.substring(10)*/;
                    String useType = "--"; /*使用方式*/
                    String operName = ""; /*业务名称*/
                    String operCode = ""; /*业务代码*/
                    String spName = ""; /*服务提供商, 企业名称*/
                    String spCode = ""; /*企业代码*/
                    String feeType = "--"; /*费用类型*/

                    spCode = fields[1];
                    spName = billAccount.getSpName(spCode); //SP 公司名
                    if (spName.trim().isEmpty()) {
                        spName = spCode;
                    }

                    operCode = fields[5];
                    operName = billAccount.getOperName(spCode, operCode); //sp下实例名称
                    if (operName.trim().isEmpty()) {
                        operName = fields[2];
                    }

                    String musicName = billAccount.getMusicName(operCode, fields[7]);
                    musicName = (musicName == null) ? "" : musicName;
                    operName = new StringBuilder().append(operName).append("-").append(musicName).toString();

                    operCode = fields[9]; //展示的代码用新的位置代替

                    fee = Double.valueOf(fields[3]);
                    fee1 = fee;

                    feeType = fields[8];
                    String feeTypeName = "--";
                    if (feeType.equals("03")) {
                        feeTypeName = "包月信息费";
                    } else {
                        feeTypeName = "点播信息费";
                    }

                    sb.append(time).append("|")
                            .append(useType).append("|")
                            .append(operName).append("|")
                            .append(operCode).append("|")
                            .append(spName).append("|")
                            .append(spCode).append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee));
                } else if (detailCode.equals("9518")) { //12590
                    String time = fields[0]/*.substring(10)*/;
                    String useType = "--"; /*使用方式*/
                    String operName = ""; /*业务名称*/
                    String operCode = ""; /*业务代码*/
                    String spName = ""; /*服务提供商, 企业名称*/
                    String spCode = ""; /*企业代码*/
                    String feeType = "--"; /*费用类型*/

                    useType = fields[1];

                    operCode = fields[2].substring(0, 9); //被叫号码取9位做为oper_code
                    operName = billAccount.getOperName(spCode, operCode); //sp下实例名称
                    if (operName.trim().isEmpty()) {
                        operName = fields[2];
                    }

                    spCode = this.get12590SpCode(operCode);
                    spName = billAccount.getSpName(spCode); //SP 公司名
                    if (spName.trim().isEmpty()) {
                        spName = spCode;
                    }

                    fee = Double.valueOf(fields[3]) + Double.valueOf(fields[4]) + Double.valueOf(fields[5])
                            + Double.valueOf(fields[6]) + Double.valueOf(fields[7]);
                    fee1 = fee;

                    feeType = fields[9];
                    String roamType = fields[8];
                    String feeTypeName = "--";
                    feeTypeName = this.getRoamName(roamType, feeType); //8:roam_type, 9:fee_type

                    sb.append(time).append("|")
                            .append(useType).append("|")
                            .append(operName).append("|")
                            .append(operCode).append("|")
                            .append(spName).append("|")
                            .append(spCode).append("|")
                            .append(feeTypeName).append("|")
                            .append(String.format("%.2f", fee));
                }

                totalFee += fee1;

                outDetailLines.add(sb.toString());
            }
        }
        List<String> globalList = new ArrayList<>();
        globalList.add("8.SP代收费详单");
        ChannelDetail outDetail = new ChannelDetail();
        outDetail.setQueryType(queryType); //SP退费详单查询, 96
        outDetail.setGlobalList(globalList);
        outDetail.setTitleInfo("时间|使用方式|业务名称|业务代码|服务提供商|企业代码|费用类型|费用");
        outDetail.setFootInfo("合计：|" + String.format("%.2f", totalFee) + "元");
        outDetail.setDetailLines(outDetailLines);
        outDetail.setCount(outDetailLines.size());

        return outDetail;
    }

    private String get12590SpCode(String operCode) {

        String spCode = "";
        //TODO 增加从dbspadm.sp_info_ivr@bossquery表中获取信息的sql
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "OPER_CODE", operCode);
        //String result = (String) baseDao.queryForObject("", inMap);

        return spCode;
    }

    private MicroPayEntity getPhonePaySpInfo(long paySn) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "PAY_SN", paySn);
        MicroPayEntity mpe = (MicroPayEntity) baseDao.queryForObject("bal_micropay_info.qMicroPayRecd", inMap);
        return mpe;
    }

    @Override
    public Map<String, Integer> smsStats(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                         String callBeginTime, String callEndTime) {

        int dealBegDay = Integer.parseInt(dealBeginTime.substring(0, 8));
        String gfDealBeginTime = String.format("%8d%s", DateUtils.addDays(dealBegDay, 1), dealBeginTime.substring(8, 14));
        int dealEndDay = Integer.parseInt(dealEndTime.substring(0, 8));
        String gfDealEndTime = String.format("%8d%s", DateUtils.addDays(dealEndDay, 1), dealEndTime.substring(8, 14));

        String otherDealBeginTime = dealBeginTime;
        String otherDealEndTime = dealEndTime;

        String[] options = new String[]{"X", callBeginTime, callEndTime};


        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);

        int smsCount = 0; //短信总条数
        int mmsCount = 0; //彩信总条数
        int ssCount = 0; //普通短信条数
        int cdCount = 0; //移动彩信条数
        int siCount = 0; //国际短信条数
        int ciCount = 0; //国际彩信条数
        int sgCount = 0; //互联网短信条数
        int cgCount = 0; //互联网彩信条数
        int scCount = 0; //短号短信条数
        int mcCount = 0; //行业网关短信条数

        int smsSendCount = 0; //短信总发送条数
        int smsRecvCount = 0; //短信总接收条数
        int mmsSendCount = 0; //彩信总发送条数
        int mmsRecvCount = 0; //彩信总接收条数
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();
            if (detailCode.equals("8085") || detailCode.equals("8086")) {
                dealBeginTime = gfDealBeginTime;
                dealEndTime = gfDealEndTime;
            } else {
                dealBeginTime = otherDealBeginTime;
                dealEndTime = otherDealEndTime;
            }
            log.debug("smsStats 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);
            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                if (detailCode.equals("8012") || detailCode.equals("8022")) {
                    if (detailCode.equals("8022")) {
                        scCount++;
                    }
                    smsSendCount++;
                    smsCount++;
                } else if (detailCode.equals("8013")) { //国际短信
                    if (fields[2].equals("21")) { //发送
                        smsSendCount++;
                    } else { //接收
                        smsRecvCount++;
                    }

                    smsCount++;
                    siCount++;
                } else if (detailCode.equals("8014")) { //互联短信
                    if (fields[2].equals("00") || fields[2].equals("10")) {
                        smsSendCount++;
                    } else {
                        smsRecvCount++;
                    }
                    smsCount++;
                    sgCount++;
                } else if (detailCode.equals("8015")) { //网信短信
                    if (fields[2].equals("00")) {
                        smsRecvCount++;
                    } else {
                        smsSendCount++;
                    }

                    smsCount++;
                } else if (detailCode.equals("8018") || detailCode.equals("8024")) { //8018 梦网短信、8024 物联网短信
                    smsSendCount++;
                    smsCount++;
                } else if (detailCode.equals("8019")) { //国际彩信
                    if (fields[2].equals("00")) {
                        mmsSendCount++;
                    } else {
                        mmsRecvCount++;
                    }

                    mmsCount++;
                    ciCount++;
                } else if (detailCode.equals("8020")) { //移动彩信

                    if (fields[2].equals("00") || fields[2].equals("01")) {
                        mmsSendCount++;
                    } else {
                        mmsRecvCount++;
                    }

                    mmsCount++;
                } else if (detailCode.equals("8021")) { //互联彩信
                    if (fields[2].equals("00")) {
                        mmsSendCount++;
                    } else {
                        mmsRecvCount++;
                    }

                    mmsCount++;
                    cgCount++;
                } else if (detailCode.equals("8023")) { //行业网关短信
                    if (fields[2].equals("00") || fields[2].equals("10")) {
                        smsSendCount++;
                    } else {
                        smsRecvCount++;
                    }
                    smsCount++;
                    mcCount++;
                } else if (detailCode.equals("8085") || detailCode.equals("8086")) {
                    smsSendCount++;
                    smsCount++;
                }

            }
        }

        Map<String, Integer> smsMap = new HashMap<>();
        safeAddToMap(smsMap, "SMS_COUNT", smsCount); //短信总条数
        safeAddToMap(smsMap, "MMS_COUNT", mmsCount); //彩信总条数
        safeAddToMap(smsMap, "SS_COUNT", ssCount); //普通短信条数
        safeAddToMap(smsMap, "CD_COUNT", cdCount); //移动彩信条数
        safeAddToMap(smsMap, "SI_COUNT", siCount); //国际短信条数
        safeAddToMap(smsMap, "CI_COUNT", ciCount); //国际彩信条数
        safeAddToMap(smsMap, "SG_COUNT", sgCount); //互联网短信条数
        safeAddToMap(smsMap, "CG_COUNT", cgCount); //互联网彩信条数
        safeAddToMap(smsMap, "SC_COUNT", scCount); //短号短信条数
        safeAddToMap(smsMap, "MC_COUNT", mcCount); //行业网关短信条数
        safeAddToMap(smsMap, "SMS_SEND_COUNT", smsSendCount); //短信总发送条数
        safeAddToMap(smsMap, "SMS_RECV_COUNT", smsRecvCount); //短信总接收条数
        safeAddToMap(smsMap, "MMS_SEND_COUNT", mmsSendCount); //彩信总发送条数
        safeAddToMap(smsMap, "MMS_RECV_COUNT", mmsRecvCount); //彩信总接收条数

        return smsMap;
    }


    @Override
    public GrpDetailEntity grpDetail01Sms(String phoneNo, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                          String callBeginTime, String callEndTime, String svrCode) {

        String svrCodeBeg = svrCode + "00";
        String svrCodeEnd = svrCode + "99";
        String[] options = new String[]{"X", callBeginTime, callEndTime, svrCode, svrCodeBeg, svrCodeEnd, phoneNo};

        List<String> outDetailLines = new ArrayList<>();
        String[] detailCodeList = new String[]{"7301", "7308", "7307"}; //7301 查询mc行业网关类型的详单;7308 查询md行业手机报类型的详单;7307 查询mv行业手机报类型的详单;

        double totalShould = 0.00;
        double totalFavour = 0.00;
        int lineCount = 0;
        for (String detailCode : detailCodeList) {

            if (log.isDebugEnabled()) {
                log.debug("grpDetail01Sms 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime +
                        "," + svrCode + ", " + svrCodeBeg + "," + svrCodeEnd + ", " + phoneNo);
            }

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                for (int i = 0; i < fields.length; i++) {
                    if (fields[i].length() == 0) {
                        fields[i] = "--";
                    }
                }

                if (detailCode.equals("7307")) {
                    fields[5] = "接收";

                }

                String formatLine = String.format(
                        "%s %s %s %s %s %s %s %s %s",
                        fields[0], fields[1], fields[2], fields[3], fields[4], fields[5], fields[6], fields[7], fields[8]);

                totalShould += Double.parseDouble(fields[7]);
                totalFavour += Double.parseDouble(fields[8]);
                outDetailLines.add(formatLine);

                lineCount++;
            }

        }

        GrpDetailEntity grpDetailInfo = new GrpDetailEntity();
        grpDetailInfo.setTotalShould(totalShould);
        grpDetailInfo.setTotalFavour(totalFavour);
        grpDetailInfo.setDetailLines(outDetailLines);
        grpDetailInfo.setLineCount(lineCount);

        return grpDetailInfo;

    }

    @Override
    public GrpDetailEntity grpDetail01Mms(String phoneNo, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                          String callBeginTime, String callEndTime) {

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        List<String> outDetailLines = new ArrayList<>();
        String[] detailCodeList = new String[]{"7317"}; //7317 行业网关彩信A模块

        double totalShould = 0.00;
        double totalFavour = 0.00;
        int lineCount = 0;
        for (String detailCode : detailCodeList) {

            if (log.isDebugEnabled()) {
                log.debug("grpDetail01Mms 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);
            }

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                for (int i = 0; i < fields.length; i++) {
                    if (fields[i].length() == 0) {
                        fields[i] = "--";
                    }
                }

                String formatLine = String.format(
                        "%-20s%-15s%-20s%-20s%-15s%-10s%-8s%-8s%s",
                        fields[0], fields[1], fields[2], fields[3], fields[4], fields[5], fields[6], fields[7], fields[8]);

                totalShould += Double.parseDouble(fields[7]);
                totalFavour += Double.parseDouble(fields[8]);
                outDetailLines.add(formatLine);
                lineCount++;

            }

        }

        GrpDetailEntity grpDetailInfo = new GrpDetailEntity();
        grpDetailInfo.setTotalShould(totalShould);
        grpDetailInfo.setTotalFavour(totalFavour);
        grpDetailInfo.setDetailLines(outDetailLines);
        grpDetailInfo.setLineCount(lineCount);

        return grpDetailInfo;

    }

    @Override
    public GrpDetailEntity grpDetail02(String phoneNo, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                       String callBeginTime, String callEndTime, String callNum, String confId) {

        String[] options = new String[]{"X", callBeginTime, callEndTime, phoneNo, callNum, confId}; //第四个参数没用

        String detailCodeTmp = null;
        if (StringUtils.isEmpty(callNum) && StringUtils.isEmpty(confId)) {
            detailCodeTmp = "7306";
        } else if (StringUtils.isEmpty(callNum)) {
            detailCodeTmp = "7304";
        } else if (StringUtils.isEmpty(confId)) {
            detailCodeTmp = "7305";
        }

        List<String> outDetailLines = new ArrayList<>();
        String[] detailCodeList = new String[]{detailCodeTmp};

        double totalShould = 0.00;
        long totalTime = 0;
        int lineCount = 0;
        for (String detailCode : detailCodeList) {

            if (log.isDebugEnabled()) {
                log.debug("grpDetail02 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime
                        + ", " + callNum + ", " + confId);
            }

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                for (int i = 0; i < fields.length; i++) {
                    if (fields[i].length() == 0) {
                        fields[i] = "--";
                    }
                }

                String formatLine = String.format(
                        "%-13s%-21s%-23s%-10s%-20s%-10s%-10s%-11s%-9s",
                        fields[0], fields[1], fields[2], fields[3], fields[4], fields[5], fields[6], fields[7], fields[8]);

                totalShould += Double.parseDouble(fields[8]);
                totalTime += Double.parseDouble(fields[5]);
                outDetailLines.add(formatLine);
                lineCount++;

            }

        }

        GrpDetailEntity grpDetailInfo = new GrpDetailEntity();
        grpDetailInfo.setTotalShould(totalShould);
        grpDetailInfo.setTotalTime(totalTime);
        grpDetailInfo.setDetailLines(outDetailLines);
        grpDetailInfo.setLineCount(lineCount);

        return grpDetailInfo;

    }

    @Override
    public GrpDetailEntity grpDetail03(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                       String callBeginTime, String callEndTime, String svrCode) {

        String svrCodeBeg = svrCode + "00";
        String svrCodeEnd = svrCode + "99";
        String[] options = new String[]{"X", callBeginTime, callEndTime, svrCode, svrCodeBeg, svrCodeEnd, phoneNo};

        List<String> outDetailLines = new ArrayList<>();
        String[] detailCodeList = new String[]{queryType}; //7309 按时长计费;7310 按流量计费;7311 按次数计费;

        double totalShould = 0.00;
        int lineCount = 0;
        for (String detailCode : detailCodeList) {

            if (log.isDebugEnabled()) {
                log.debug("grpDetail01Sms 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime +
                        "," + svrCode + ", " + svrCodeBeg + "," + svrCodeEnd + ", " + phoneNo);
            }

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                for (int i = 0; i < fields.length; i++) {
                    if (fields[i].length() == 0) {
                        fields[i] = "--";
                    }
                }

                if (detailCode.equals("7311")) {
                    String formatLine = String.format(
                            "%-20s%-20s%-15s%-30s%-30s%-30s",
                            fields[0], fields[1], fields[2], fields[6], fields[3], fields[4]);

                    outDetailLines.add(formatLine);
                    totalShould += Double.parseDouble(fields[4]);
                } else {
                    String formatLine = String.format(
                            "%-20s%-20s%-15s%-30s%-30s%-30s",
                            fields[0], fields[1], fields[2], fields[6], fields[3], fields[4]);
                    outDetailLines.add(formatLine);
                    totalShould += Double.parseDouble(fields[6]);
                }

                lineCount++;
            }

        }

        GrpDetailEntity grpDetailInfo = new GrpDetailEntity();
        grpDetailInfo.setTotalShould(totalShould);
        grpDetailInfo.setDetailLines(outDetailLines);
        grpDetailInfo.setLineCount(lineCount);

        return grpDetailInfo;

    }

    @Override
    public GrpDetailEntity grpDetail04(String phoneNo, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                       String callBeginTime, String callEndTime) {

        String[] options = new String[]{"X", callBeginTime, callEndTime, phoneNo}; //第四个参数没用

        List<String> outDetailLines = new ArrayList<>();
        String[] detailCodeList = new String[]{"7312"};

        double totalShould = 0.00;
        long totalTime = 0;
        int lineCount = 0;
        for (String detailCode : detailCodeList) {

            if (log.isDebugEnabled()) {
                log.debug("grpDetail04 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);
            }

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                for (int i = 0; i < fields.length; i++) {
                    if (fields[i].length() == 0) {
                        fields[i] = "--";
                    }
                }

                double should = Double.parseDouble(fields[6]) + Double.parseDouble(fields[7]) + Double.parseDouble(fields[8]);

                String formatLine = String.format(
                        "%s %s %s %s %s %s %s %.3f",
                        fields[9], fields[0], fields[1], fields[2], fields[3], fields[4], fields[5], should);

                totalShould += should;
                outDetailLines.add(formatLine);
                lineCount++;

            }

        }

        GrpDetailEntity grpDetailInfo = new GrpDetailEntity();
        grpDetailInfo.setTotalShould(totalShould);
        grpDetailInfo.setDetailLines(outDetailLines);
        grpDetailInfo.setLineCount(lineCount);

        return grpDetailInfo;

    }

    @Override
    public GrpDetailEntity grpDetail05ER(String phoneNo, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                         String callBeginTime, String callEndTime) {

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        List<String> outDetailLines = new ArrayList<>();
        String[] detailCodeList = new String[]{"7313"};

        double totalShould = 0.00;
        int lineCount = 0;
        for (String detailCode : detailCodeList) {

            if (log.isDebugEnabled()) {
                log.debug("grpDetail05 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);
            }

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                for (int i = 0; i < fields.length; i++) {
                    if (fields[i].length() == 0) {
                        fields[i] = "--";
                    }
                }

                double should = Double.parseDouble(fields[3]);

                String formatLine = String.format(
                        "%-15s%-30s%-15s%-15s",
                        fields[0], fields[1], fields[2], fields[3]); //field2可能需要替换成”企业阅读“

                totalShould += should;
                outDetailLines.add(formatLine);
                lineCount++;

            }

        }

        GrpDetailEntity grpDetailInfo = new GrpDetailEntity();
        grpDetailInfo.setTotalShould(totalShould);
        grpDetailInfo.setDetailLines(outDetailLines);
        grpDetailInfo.setLineCount(lineCount);

        return grpDetailInfo;

    }

    @Override
    public GrpDetailEntity grpDetail05Sj(String phoneNo, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                         String callBeginTime, String callEndTime) {

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        List<String> outDetailLines = new ArrayList<>();
        String[] detailCodeList = new String[]{"7318"};

        double totalShould = 0.00;
        int lineCount = 0;
        for (String detailCode : detailCodeList) {

            if (log.isDebugEnabled()) {
                log.debug("grpDetail05 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);
            }

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                for (int i = 0; i < fields.length; i++) {
                    if (fields[i].length() == 0) {
                        fields[i] = "--";
                    }
                }

                double should = Double.parseDouble(fields[3]);

                String formatLine = String.format(
                        "%-15s%-30s%-15s%-15s",
                        fields[0], fields[1], fields[2], fields[3]); //field2可能需要替换成”企业手机报“

                totalShould += should;
                outDetailLines.add(formatLine);
                lineCount++;

            }

        }

        GrpDetailEntity grpDetailInfo = new GrpDetailEntity();
        grpDetailInfo.setTotalShould(totalShould);
        grpDetailInfo.setDetailLines(outDetailLines);
        grpDetailInfo.setLineCount(lineCount);

        return grpDetailInfo;

    }

    @Override
    public GrpDetailEntity grpDetail06(String phoneNo, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                       String callBeginTime, String callEndTime) {

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        List<String> outDetailLines = new ArrayList<>();
        String[] detailCodeList = new String[]{"7314"};

        double totalShould = 0.00;
        int lineCount = 0;
        for (String detailCode : detailCodeList) {

            if (log.isDebugEnabled()) {
                log.debug("grpDetail06 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);
            }

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                for (int i = 0; i < fields.length; i++) {
                    if (fields[i].length() == 0) {
                        fields[i] = "--";
                    }
                }

                double should = Double.parseDouble(fields[3]);

                String formatLine = String.format(
                        "%-15s%-30s%-15s%-15s",
                        fields[0], fields[1], fields[2], fields[3]); //field2可能需要替换成”企业彩漫“

                totalShould += should;
                outDetailLines.add(formatLine);
                lineCount++;

            }

        }

        GrpDetailEntity grpDetailInfo = new GrpDetailEntity();
        grpDetailInfo.setTotalShould(totalShould);
        grpDetailInfo.setDetailLines(outDetailLines);
        grpDetailInfo.setLineCount(lineCount);

        return grpDetailInfo;

    }

    @Override
    public GrpDetailEntity grpDetail07(String phoneNo, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                       String callBeginTime, String callEndTime) {

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        List<String> outDetailLines = new ArrayList<>();
        String[] detailCodeList = new String[]{"7315"};

        double totalShould = 0.00;
        int lineCount = 0;
        for (String detailCode : detailCodeList) {

            if (log.isDebugEnabled()) {
                log.debug("grpDetail06 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);
            }

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                for (int i = 0; i < fields.length; i++) {
                    if (fields[i].length() == 0) {
                        fields[i] = "--";
                    }
                }

                double should = Double.parseDouble(fields[6]);

                String formatLine = String.format(
                        "%-15s%-30s%-30s%-15s%-15s%-15s%-15s",
                        fields[0], fields[1], fields[2], fields[3], fields[4], fields[5], fields[6]); //field5可能需要替换成”云视频会议“

                totalShould += should;
                outDetailLines.add(formatLine);
                lineCount++;

            }

        }

        GrpDetailEntity grpDetailInfo = new GrpDetailEntity();
        grpDetailInfo.setTotalShould(totalShould);
        grpDetailInfo.setDetailLines(outDetailLines);
        grpDetailInfo.setLineCount(lineCount);

        return grpDetailInfo;

    }

    @Override
    public GrpDetailEntity grpDetail08(String phoneNo, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                       String callBeginTime, String callEndTime) {

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        List<String> outDetailLines = new ArrayList<>();
        String[] detailCodeList = new String[]{"7316"};

        double totalShould = 0.00;
        int lineCount = 0;
        for (String detailCode : detailCodeList) {

            if (log.isDebugEnabled()) {
                log.debug("grpDetail06 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);
            }

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                for (int i = 0; i < fields.length; i++) {
                    if (fields[i].length() == 0) {
                        fields[i] = "--";
                    }
                }

                double should = Double.parseDouble(fields[3]);

                String formatLine = String.format(
                        "%-15s%-30s%-15s%-15s",
                        fields[0], fields[1], fields[2], fields[3]); //field2可能需要替换成”企业智运会“

                totalShould += should;
                outDetailLines.add(formatLine);
                lineCount++;

            }

        }

        GrpDetailEntity grpDetailInfo = new GrpDetailEntity();
        grpDetailInfo.setTotalShould(totalShould);
        grpDetailInfo.setDetailLines(outDetailLines);
        grpDetailInfo.setLineCount(lineCount);

        return grpDetailInfo;

    }

    @Override
    public GrpDetailEntity grpDetail09(String phoneNo, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                       String callBeginTime, String callEndTime) {

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        List<String> outDetailLines = new ArrayList<>();
        String[] detailCodeList = new String[]{"7319"};

        double totalShould = 0.00;
        int lineCount = 0;
        for (String detailCode : detailCodeList) {

            if (log.isDebugEnabled()) {
                log.debug("grpDetail06 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);
            }

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;
                String[] fields = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                for (int i = 0; i < fields.length; i++) {
                    if (fields[i].length() == 0) {
                        fields[i] = "--";
                    }
                }

                double should = Double.parseDouble(fields[3]);

                String formatLine = String.format(
                        "%-15s%-30s%-15s%-15s",
                        fields[0], fields[1], fields[2], fields[3]); //field2可能需要替换成”企业互联网电视“

                totalShould += should;
                outDetailLines.add(formatLine);
                lineCount++;

            }

        }

        GrpDetailEntity grpDetailInfo = new GrpDetailEntity();
        grpDetailInfo.setTotalShould(totalShould);
        grpDetailInfo.setDetailLines(outDetailLines);
        grpDetailInfo.setLineCount(lineCount);

        return grpDetailInfo;

    }


    @Override
    public List<String> cityOldDetail(String phoneNo, String queryType, ServerInfo serverInfo, String dealBeginTime, String dealEndTime,
                                      String callBeginTime, String callEndTime, String serviceType, boolean highPower) {

        String[] options = new String[]{"X", callBeginTime, callEndTime};

        List<String> outDetailLines = new ArrayList<>();
        List<QueryTypeEntity> detailCodeList = this.getDetailTypeList(queryType);
        StringBuilder sb = null;
        double sf1 = 0.00;
        double sf2 = 0.00;
        double sf3 = 0.00;
        double sf4 = 0.00;
        for (QueryTypeEntity queryEnt : detailCodeList) {
            String detailCode = queryEnt.getQueryType();

            log.debug("rawDetail 请求时间串：" + dealBeginTime + "/" + dealEndTime + "/" + detailCode + "," + callBeginTime + ", " + callEndTime);

            List<String> detailLines = this.queryDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime, options);

            double tf1 = 0.00;
            double tf2 = 0.00;
            double tf3 = 0.00;
            double tf4 = 0.00;
            double tf5 = 0.00;
            double tf6 = 0.00;
            double tf7 = 0.00;
            double tf8 = 0.00;

            for (String line : detailLines) {
                if (line.isEmpty()) {
                    continue;
                }

                String[] RF1 = StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");
                for (int i = 0; i < RF1.length; i++) {
                    RF1[i] = StringUtils.isEmpty(RF1[i]) ? "--" : RF1[i];
                }

                sb = new StringBuilder();
                if (detailCode.equals("1001") || detailCode.equals("1002")
                        || detailCode.equals("1003") || detailCode.equals("1004")) { //语音话单-普通语音话单

                    String[] RF2 = new String[17];

                    if (RF1[2].equals("主叫")) {//通话类型
                        RF2[0] = RF1[0];
                        RF2[1] = this.getPortPhone(RF1[1], serviceType);
                    } else {
                        RF2[0] = RF1[1];
                        RF2[1] = this.getPortPhone(RF1[0], serviceType);
                    }

                    RF2[2] = RF1[4]; //通话时间
                    RF2[3] = String.format("%d", Long.parseLong(RF1[5]));
                    RF2[4] = RF1[6]; //拜访地区号局
                    RF2[8] = RF1[7]; //拜访地区号
                    RF2[9] = RF1[8]; //费用类型
                    RF2[13] = RF1[18]; //交换机号
                    RF2[14] = RF1[19]; //小区代码
                    RF2[15] = RF1[20]; //基站号
                    if (Integer.parseInt(RF1[21]) == 1) {
                        RF2[16] = "G3";
                    } else {
                        RF2[16] = "G网";
                    }


                    RF2[5] = String.format("%.2f", Double.valueOf(RF1[9]) + Double.valueOf(RF1[10]) + Double.valueOf(RF1[16]));
                    RF2[6] = String.format("%.2f", Double.valueOf(RF1[11]) + Double.valueOf(RF1[12]));
                    RF2[7] = String.format("%.2f", Double.valueOf(RF2[5]) + Double.valueOf(RF2[6]));

                    RF2[10] = String.format("%.2f", Double.valueOf(RF1[10]) + Double.valueOf(RF1[13]) + Double.valueOf(RF1[17]));
                    RF2[11] = String.format("%.2f", Double.valueOf(RF1[14]) + Double.valueOf(RF1[15]));
                    RF2[12] = String.format("%.2f", Double.valueOf(RF2[10]) + Double.valueOf(RF2[11]));

                    tf1 = tf1 + Double.valueOf(RF2[5]);
                    tf2 = tf2 + Double.valueOf(RF2[6]);
                    tf4 = tf4 + Double.valueOf(RF2[7]);
                    tf5 = tf5 + Double.valueOf(RF2[10]);
                    tf6 = tf6 + Double.valueOf(RF2[11]);
                    tf8 = tf8 + Double.valueOf(RF2[12]);

                    if (RF1[3]/*对端号码类型*/.equals("7") || RF1[3].equals("28") || RF1[3].equals("29")) {
                        tf3 += Double.valueOf(RF2[5]) + Double.valueOf(RF2[6]);
                        tf7 += Double.valueOf(RF2[10]) + Double.valueOf(RF2[11]);
                    }

                    sf1 = sf1 + Double.valueOf(RF2[10]);
                    sf2 = sf2 + Double.valueOf(RF2[11]);
                    sf4 = sf4 + Double.valueOf(RF2[12]);

                    sb.append(RF2[0]).append("|")
                            .append(RF2[1]).append("|")
                            .append(RF2[2]).append("|")
                            .append(RF2[3]).append("|")
                            .append(RF2[4]).append("|")
                            .append(RF2[5]).append("|")
                            .append(RF2[6]).append("|")
                            .append(RF2[7]).append("|")
                            .append(RF2[8]).append("|")
                            .append(RF2[9]).append("|")
                            .append(RF2[10]).append("|")
                            .append(RF2[11]).append("|")
                            .append(RF2[12]).append("|")
                            .append(RF2[16]);

                    if (highPower == true) { //具有高级详单查询权限

                        sb.append("|").append(RF2[13])
                                .append("|").append(RF2[14])
                                .append("|").append(RF2[15]);
                    }
                } else if (detailCode.equals("4001")) { //可视电话话单
                    String[] RF2 = new String[13];

                    if (RF1[2].equals("主叫")) {//通话类型
                        RF2[0] = RF1[0];
                        RF2[1] = RF1[1];
                    } else {
                        RF2[0] = RF1[1];
                        RF2[1] = RF1[0];
                    }

                    RF2[2] = RF1[4]; //通话时间
                    RF2[3] = String.format("%d", Long.parseLong(RF1[5]));
                    RF2[4] = RF1[6]; //拜访地区号局
                    RF2[8] = RF1[7]; //拜访地区号
                    RF2[9] = RF1[8]; //费用类型

                    RF2[5] = String.format("%.2f", Double.valueOf(RF1[9]) + Double.valueOf(RF1[10]) + Double.valueOf(RF1[16]));
                    RF2[6] = String.format("%.2f", Double.valueOf(RF1[11]) + Double.valueOf(RF1[12]));
                    RF2[7] = String.format("%.2f", Double.valueOf(RF2[5]) + Double.valueOf(RF2[6]));

                    RF2[10] = String.format("%.2f", Double.valueOf(RF1[10]) + Double.valueOf(RF1[13]) + Double.valueOf(RF1[17]));
                    RF2[11] = String.format("%.2f", Double.valueOf(RF1[14]) + Double.valueOf(RF1[15]));
                    RF2[12] = String.format("%.2f", Double.valueOf(RF2[10]) + Double.valueOf(RF2[11]));


                    tf1 = tf1 + Double.valueOf(RF2[5]);
                    tf2 = tf2 + Double.valueOf(RF2[6]);
                    tf4 = tf4 + Double.valueOf(RF2[7]);
                    tf5 = tf5 + Double.valueOf(RF2[10]);
                    tf6 = tf6 + Double.valueOf(RF2[11]);
                    tf8 = tf8 + Double.valueOf(RF2[12]);

                    sf1 = sf1 + Double.valueOf(RF2[10]);
                    sf2 = sf2 + Double.valueOf(RF2[11]);
                    sf4 = sf4 + Double.valueOf(RF2[12]);


                    if (RF1[3]/*对端号码类型*/.equals("7") || RF1[3].equals("28") || RF1[3].equals("29")) {
                        tf3 = tf3 + Double.valueOf(RF2[5]) + Double.valueOf(RF2[6]);
                        tf7 = tf7 + Double.valueOf(RF2[10]) + Double.valueOf(RF2[11]);
                    }

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("1011")) { //[语音话单-呼转语音话单]
                    String[] RF2 = new String[12];
                    RF2[0] = RF1[0];
                    RF2[1] = this.getPortPhone(RF1[1], serviceType);
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = String.format("%d", Long.parseLong(RF1[4]));
                    RF2[5] = RF1[5];
                    RF2[6] = RF1[6];
                    RF2[7] = RF1[7];
                    RF2[8] = RF1[8];
                    RF2[9] = RF1[9];
                    RF2[10] = RF1[10];

                    tf1 = tf1 + Double.valueOf(RF1[7]);
                    tf2 = tf2 + Double.valueOf(RF1[8]);
                    tf3 = tf3 + Double.valueOf(RF1[9]);

                    sf1 = sf1 + Double.valueOf(RF1[7]);
                    sf2 = sf2 + Double.valueOf(RF1[8]) + Double.valueOf(RF1[9]);
                    sf4 = sf4 + Double.valueOf(RF1[7]) + Double.valueOf(RF1[8]) + Double.valueOf(RF1[9]);

                    if (RF1[11].equals("1")) {
                        RF2[11] = "G3";
                    } else {
                        RF2[11] = "G网";
                    }

                    /*A打B，B转叫C时，此值为A*/
                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("4011")) { //[可视电话呼转话单]

                    String[] RF2 = new String[11];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = String.format("%d", Long.parseLong(RF1[4]));
                    RF2[5] = RF1[5];
                    RF2[6] = RF1[6];
                    RF2[7] = RF1[7];
                    RF2[8] = RF1[8];
                    RF2[9] = RF1[9];
                    RF2[10] = RF1[10];

                    tf1 = tf1 + Double.valueOf(RF1[7]);
                    tf2 = tf2 + Double.valueOf(RF1[8]);
                    tf3 = tf3 + Double.valueOf(RF1[9]);

                    sf1 = sf1 + Double.valueOf(RF1[7]);
                    sf2 = sf2 + Double.valueOf(RF1[8]) + Double.valueOf(RF1[9]);
                    sf4 = sf4 + Double.valueOf(RF1[7]) + Double.valueOf(RF1[8]) + Double.valueOf(RF1[9]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("1021")) { //[语音话单-VPMN语音话单]
                    String[] RF2 = new String[19];

                    if (RF1[2].equals("主叫")) {
                        RF2[0] = RF1[0];
                        RF2[1] = this.getPortPhone(RF1[1], serviceType);
                    } else {
                        RF2[0] = RF1[1];
                        RF2[1] = this.getPortPhone(RF1[0], serviceType);
                    }

                    RF2[2] = RF1[3];
                    RF2[3] = String.format("%d", Long.parseLong(RF1[4]));
                    RF2[4] = RF1[5];
                    RF2[5] = RF1[7];
                    RF2[6] = RF1[8];
                    double feeTmp1 = Double.valueOf(RF1[7]) + Double.valueOf(RF1[8]);
                    double feeTmp2 = Double.valueOf(RF1[10]) + Double.valueOf(RF1[11]);

                    RF2[7] = String.format("%.2f", feeTmp1);
                    RF2[8] = RF2[4];
                    RF2[9] = RF1[9];
                    RF2[10] = RF1[10];
                    RF2[11] = RF1[11];
                    RF2[12] = String.format("%.2f", feeTmp2);

                    tf1 += Double.valueOf(RF2[10]);
                    tf2 += Double.valueOf(RF2[11]);
                    tf3 += Double.valueOf(RF2[12]);

                    sf1 += Double.valueOf(RF2[10]);
                    sf2 += Double.valueOf(RF2[11]);
                    sf4 += Double.valueOf(RF2[12]);

                    if (RF1[12].equals("1")) {
                        RF2[13] = "G3";
                    } else {
                        RF2[13] = "G网";
                    }

                    if (RF1[13].equals("1")) {
                        RF2[14] = "视频";
                    } else {
                        RF2[14] = "非视频";
                    }

                    if (RF1[14].equals("0")) {
                        RF2[15] = "非漫游";
                    } else if (RF1[14].equals("2")) {
                        RF2[15] = "漫游";
                    } else {
                        RF2[15] = RF1[14];
                    }

                    RF2[16] = RF1[15];
                    RF2[17] = RF1[16];
                    RF2[18] = RF1[17];

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("1031")) { //[语音话单-语音杂志话单]
                    String[] RF2 = new String[6];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = String.format("%d", Long.parseLong(RF1[3]));
                    RF2[4] = RF1[4];
                    RF2[5] = RF1[5];

                    tf1 += Double.valueOf(RF1[5]);
                    sf1 += Double.valueOf(RF1[5]);
                    sf4 += Double.valueOf(RF1[5]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("1041")) { /*[语音话单-新全球呼]*/
                    String[] RF2 = new String[5];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = String.format("%d", Long.parseLong(RF1[3]));
                    RF2[4] = RF1[5];

                    tf1 = tf1 + Double.valueOf(RF1[5]);
                    sf1 = sf1 + Double.valueOf(RF1[5]);
                    sf4 = sf4 + Double.valueOf(RF1[5]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("2001")) {/* [短信话单-普通短信话单] */
                    String[] RF2 = new String[8];
                    RF2[0] = RF1[0];
                    RF2[1] = this.getPortPhone(RF1[1], serviceType);
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = RF1[4];
                    RF2[5] = RF1[5];
                    if (RF1[5].equals("0")) {
                        RF2[6] = "手机";
                    } else {
                        RF2[6] = "其他";
                    }
                    RF2[7] = "已发送";

                    tf1 = tf1 + Double.valueOf(RF1[3]);
                    sf1 = sf1 + Double.valueOf(RF1[3]);
                    sf4 = sf4 + Double.valueOf(RF1[3]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("2002")) {/* [短信话单-互通短信话单] */
                    String[] RF2 = new String[8];
                    if (RF1[4].equals("01") || RF1[4].equals("11")) {
                        RF2[0] = RF1[1];
                        RF2[1] = this.getPortPhone(RF1[0], serviceType);
                    } else {
                        RF2[0] = RF1[0];
                        RF2[1] = this.getPortPhone(RF1[1], serviceType);
                    }
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = "0";
                    RF2[5] = RF1[4];
                    RF2[6] = "手机";

                    RF2[7] = "已发送";

                    tf1 = tf1 + Double.valueOf(RF1[3]);
                    sf1 = sf1 + Double.valueOf(RF1[3]);
                    sf4 = sf4 + Double.valueOf(RF1[3]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("2003")) {/* [短信话单-移动梦网短信话单] */

                    if (!RF1[1].startsWith("10654040")) {
                        continue;
                    }

                    String[] RF2 = new String[8];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = RF1[4];
                    RF2[5] = RF1[5];
                    if (RF1[5].equals("0")) {
                        RF2[6] = "手机";
                    } else {
                        RF2[6] = "其他";
                    }
                    RF2[7] = "已发送";

                    tf1 = tf1 + Double.valueOf(RF1[3]);
                    sf1 = sf1 + Double.valueOf(RF1[3]);
                    sf4 = sf4 + Double.valueOf(RF1[3]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3001")) { /* [代收话单] */
                    String[] RF2 = new String[10];

                    if (RF1[10].equals("xe")) {
                        RF2[0] = RF1[0];
                        RF2[1] = "10658008";
                        RF2[2] = RF1[2];
                        RF2[3] = RF1[3];
                        if (RF1[4].equals("0")) {
                            RF2[4] = "按条收费";
                            tf1 += Double.valueOf(RF1[5]);
                        } else if (RF1[4].equals("1")) {
                            RF2[4] = "包月";
                            tf2 += Double.valueOf(RF1[5]);
                        } else {
                            RF2[4] = "未定义";
                        }
                        RF2[5] = RF1[5];
                        RF2[6] = "代收话费小额支付";
                        RF2[7] = "NULL";
                        RF2[8] = "NULL";
                        RF2[9] = "代收费";
                        sf1 += Double.valueOf(RF1[5]);
                        sf4 += Double.valueOf(RF1[5]);

                    } else {
                        RF2[0] = RF1[0];
                        RF2[1] = RF1[1];
                        RF2[2] = RF1[2];
                        RF2[3] = RF1[3];
                        RF2[5] = String.format("%.2f", Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]));
                        RF2[4] = RF1[4];
                        RF2[6] = RF1[7];
                        RF2[7] = RF1[9];
                        RF2[8] = RF1[8];
                        RF2[9] = "代收费";
                        RF2[10] = RF1[10];

                        if (RF2[10].equals("mj")) {
                            if (RF1[4].equals("0") || RF1[4].equals("3") || RF1[4].equals("5") || RF1[4].equals("7")) {
                                RF2[4] = "免费";
                            } else if (RF1[4].equals("1")) {
                                RF2[4] = "按条";
                                tf1 = tf1 + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]);
                            } else if (RF1[4].equals("2") || RF1[4].equals("4") || RF1[4].equals("6")) {
                                RF2[4] = "包月";
                                tf2 = tf2 + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]);
                            }
                        } else {
                            if (RF1[4].equals("1")) {
                                RF2[4] = "免费";
                            } else if (RF1[4].equals("2")) {
                                RF2[4] = "按条";
                                tf1 = tf1 + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]);
                            } else if (RF1[4].equals("3")) {
                                RF2[4] = "包月";
                                tf2 = tf2 + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]);
                            }
                        }

                        sf1 = sf1 + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]);
                        sf4 = sf4 + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]);

                    }

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3034")) { /* [手机游戏话单] */
                    String[] RF2 = new String[7];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = billAccount.getOperName(RF1[3], RF1[4]);
                    switch (Integer.parseInt(RF1[5])) {
                        case 0:
                            RF2[4] = "免费";
                            break;
                        case 1:
                            RF2[4] = "按次计费";
                            break;
                        case 2:
                            RF2[4] = "包天计费";
                            break;
                        case 3:
                            RF2[4] = "包天查询";
                            break;
                        case 4:
                            RF2[4] = "包月计费";
                            break;
                        case 5:
                            RF2[4] = "包月查询";
                            break;
                        case 6:
                            RF2[4] = "包次计费";
                            break;
                        case 7:
                            RF2[4] = "包次查询";
                            break;
                        case 8:
                            RF2[4] = "按栏目包月计费";
                            break;
                        case 9:
                            RF2[4] = "按栏目包月查询";
                            break;
                        default:
                            RF2[4] = "未定义";
                            break;
                    }
                    RF2[5] = String.format("%.2f", Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]));

                    if (!RF1[5].equals("0")) {
                        tf1 += Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]);
                    }

                    RF2[6] = RF1[8].equals("1") ? "CSD" : "GPRS";

                    String gameName = "NULL"; //TODO 补充手游名称 dobdailygamemsg content_code = RF1[9]

                    sf1 = sf1 + Double.valueOf(RF1[6]) + Double.valueOf(RF1[7]);
                    sf4 = sf4 + Double.valueOf(RF1[6]) + Double.valueOf(RF1[7]);

                    sb.append(RF2[0]).append("|")
                            .append(RF2[1]).append("|")
                            .append(RF2[2]).append("|")
                            .append(RF2[3]).append("|") /*opername*/
                            .append(RF1[3]).append("|") /*spcode*/
                            .append(RF1[4]).append("|") /*opercode*/
                            .append(RF2[4]).append("|")
                            .append(RF2[5]).append("|")
                            .append(RF2[6]).append("|")
                            .append(gameName.trim())
                    ;

                } else if (detailCode.equals("3035")) { /* 手机对讲业务(PoC) */
                    String[] RF2 = new String[7];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[3].substring(0, 6);
                    RF2[2] = RF1[2];
                    RF2[3] = "手机对讲";
                    RF2[4] = RF1[3];
                    switch (Integer.parseInt(RF1[4])) {
                        case 3:
                            RF2[5] = "包月";
                            break;
                        case 4:
                            RF2[5] = "查询话单";
                            break;
                        default:
                            RF2[5] = "未定义";
                            break;
                    }
                    RF2[6] = String.format("%.2f", Double.valueOf(RF1[5]));

                    tf1 = tf1 + Double.valueOf(RF1[5]);
                    sf1 = sf1 + Double.valueOf(RF1[5]);
                    sf4 = sf4 + Double.valueOf(RF1[5]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3036")) { /*手机动漫话单*/
                    String[] RF2 = new String[9];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    switch (Integer.parseInt(RF1[3])) {
                        case 1:
                            RF2[3] = "SMS";
                            break;
                        case 2:
                            RF2[3] = "WAP";
                            break;
                        case 3:
                            RF2[3] = "客户端";
                            break;
                        case 4:
                            RF2[3] = "WEB";
                            break;
                        case 5:
                            RF2[3] = "实体卡订购";
                            break;
                        case 99:
                            RF2[3] = "其他";
                            break;
                        default:
                            RF2[3] = "未定义";
                            break;
                    } //:: switch end
                    RF2[4] = RF1[4];
                    RF2[5] = billAccount.getSpName(RF1[5].trim()); //TODO 老代码从 sp_code_dreamnet 表数据
                    RF2[6] = RF1[6]; //TODO TOBDMDTAILMSG 从老表中出数据，条件 RF1[6], 取不到值时为 NULL
                    switch (Integer.parseInt(RF1[7])) {
                        case 1:
                            RF2[7] = "免费";
                            break;
                        case 2:
                            RF2[7] = "按次计费";
                            break;
                        case 3:
                            RF2[7] = "包天计费";
                            break;
                        case 4:
                            RF2[7] = "包月查询";
                            break;
                        default:
                            RF2[7] = "未定义";
                            break;
                    }
                    RF2[8] = String.format("%.2f", Double.valueOf(RF1[8]) + Double.valueOf(RF1[9]));
                    tf1 += Double.valueOf(RF2[8]);
                    sf1 += Double.valueOf(RF2[8]);
                    sf4 += Double.valueOf(RF2[8]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3037")) {/* [12582农信通百事易] */
                    String[] RF2 = new String[6];
                    RF2[0] = RF1[0];
                    RF2[1] = String.format("%s%s", RF1[1], RF1[2]);
                    RF2[2] = billAccount.getOperName(RF1[3], RF1[4]);
                    if (RF1[6].equals("3")) {
                        RF2[4] = "包月";
                    } else {
                        RF2[4] = "未定义";
                    }
                    RF2[5] = RF1[7];

                    tf1 = tf1 + Double.valueOf(RF1[7]);
                    sf1 = sf1 + Double.valueOf(RF1[7]);
                    sf4 = sf4 + Double.valueOf(RF1[7]);
                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3038")) { /* [短信回执] */
                    String[] RF2 = new String[4];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    switch (Integer.parseInt(RF1[2])) {
                        case 3:
                            RF2[2] = "包月";
                            break;
                        default:
                            RF2[2] = "未定义";
                            break;
                    }
                    RF2[3] = RF1[3];
                    tf1 = tf1 + Double.valueOf(RF1[3]);
                    sf1 = sf1 + Double.valueOf(RF1[3]);
                    sf4 = sf4 + Double.valueOf(RF1[3]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3039")) { /* [亲情通] */
                    String[] RF2 = new String[6];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    switch (Integer.parseInt(RF1[4])) {
                        case 0:
                            RF2[4] = "免费";
                            break;
                        case 1:
                            RF2[4] = "按次计费";
                            break;
                        case 2:
                            RF2[4] = "包月计费";
                            break;
                        case 3:
                            RF2[4] = "包月查询";
                            break;
                        default:
                            RF2[4] = "未定义";
                            break;
                    }
                    RF2[5] = RF1[5];
                    tf1 = tf1 + Double.valueOf(RF1[5]);
                    sf1 = sf1 + Double.valueOf(RF1[5]);
                    sf4 = sf4 + Double.valueOf(RF1[5]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3041")) {/* [宜居通] */
                    String[] RF2 = new String[6];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    switch (Integer.parseInt(RF1[2])) {
                        case 3:
                            RF2[2] = "包月";
                            break;
                        default:
                            RF2[2] = "未定义";
                            break;
                    }
                    RF2[3] = RF1[3];
                    RF2[4] = RF1[4];
                    RF2[5] = RF1[5];
                    tf1 = tf1 + Double.valueOf(RF1[3]);
                    sf1 = sf1 + Double.valueOf(RF1[3]);
                    sf4 = sf4 + Double.valueOf(RF1[3]);
                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3002")) { /* [GPRS话单] */

                    if (!RF1[22].startsWith("4000000004") || !RF1[22].startsWith("2000000000")) {
                        continue;
                    }
                    String[] RF2 = new String[12];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = String.format("%.3f", (Double.valueOf(RF1[4]) + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]) + Double.valueOf(RF1[7]) + Double.valueOf(RF1[8]) + Double.valueOf(RF1[9]) + Double.valueOf(RF1[10]) + Double.valueOf(RF1[11]) + Double.valueOf(RF1[12]) + Double.valueOf(RF1[13]) + Double.valueOf(RF1[14]) + Double.valueOf(RF1[15])) / 1.024);
                    RF2[5] = RF1[16];
                    RF2[6] = RF1[17];
                    RF2[7] = RF1[18];
                    RF2[8] = RF1[19];
                    RF2[9] = RF1[22];
                    switch (Integer.parseInt(RF2[0])) {
                        case 19:
                            RF2[10] = "G网";
                            break;
                        case 20:
                            RF2[10] = "G3";
                            break;
                        case 40:
                            RF2[10] = "国际出游";
                        default:
                            break;
                    }
                    if (Double.valueOf(RF2[4]) >= 0) {
                        RF2[4] = String.format("%.3f", Math.ceil(Double.valueOf(RF2[4])));
                    } else {
                        RF2[4] = String.format("%.3f", Math.floor(Double.valueOf(RF2[4])));
                    }

                    sf1 = sf1 + Double.valueOf(RF1[21]);
                    sf4 = sf4 + Double.valueOf(RF1[21]);

                    tf1 = tf1 + Math.floor(Double.valueOf(RF2[4]));
                    tf2 = tf2 + Double.valueOf(RF1[20]);
                    tf3 = tf3 + Double.valueOf(RF1[21]);

                    sb.append(RF2[1]).append("|")
                            .append(RF2[2]).append("|")
                            .append(RF2[9]).append("|")
                            .append(RF2[3]).append("|")
                            .append(RF2[4]).append("|")
                            .append(RF2[5]).append("|")
                            .append(RF2[6]).append("|")
                            .append(RF2[7]).append("|")
                            .append(RF2[8]).append("|")
                            .append(RF1[20]).append("|")
                            .append(RF1[21]).append("|")
                            .append(RF2[10])
                    ;

                } else if (detailCode.equals("3040")) { /* [GPRS国际漫游话单] */
                    if (!RF1[22].startsWith("4000000004") || !RF1[22].startsWith("2000000000")) {
                        continue;
                    }
                    String[] RF2 = new String[12];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = String.format("%.3f", (Double.valueOf(RF1[4]) + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]) + Double.valueOf(RF1[7]) + Double.valueOf(RF1[8]) + Double.valueOf(RF1[9]) + Double.valueOf(RF1[10]) + Double.valueOf(RF1[11]) + Double.valueOf(RF1[12]) + Double.valueOf(RF1[13]) + Double.valueOf(RF1[14]) + Double.valueOf(RF1[15])) / 1.024);
                    RF2[5] = RF1[16];
                    RF2[6] = RF1[17];
                    RF2[7] = RF1[18];
                    RF2[8] = RF1[19];
                    RF2[9] = RF1[22];

                    switch (Integer.parseInt(RF2[7])) {
                        case 82:
                            RF2[7] = "韩国";
                            break;
                        case 852:
                            RF2[7] = "香港";
                            break;
                        case 853:
                            RF2[7] = "澳门";
                            break;
                        case 886:
                            RF2[7] = "台湾";
                            break;
                        case 60:
                            RF2[7] = "马来西亚";
                            break;
                        case 66:
                            RF2[7] = "泰国";
                            break;
                        case 65:
                            RF2[7] = "新加坡";
                            break;
                    }
                    switch (Integer.parseInt(RF2[0])) {
                        case 19:
                            RF2[10] = "G网";
                            break;
                        case 20:
                            RF2[10] = "G3";
                            break;
                        case 40:
                            RF2[10] = "国际漫游GPRS日套餐";
                        default:
                            break;
                    }
                    if (Double.valueOf(RF2[4]) >= 0) {
                        RF2[4] = String.format("%.3f", Math.ceil(Double.valueOf(RF2[4])));
                    } else {
                        RF2[4] = String.format("%.3f", Math.floor(Double.valueOf(RF2[4])));
                    }

                    sf1 = sf1 + Double.valueOf(RF1[21]);
                    sf4 = sf4 + Double.valueOf(RF1[21]);

                    tf1 = tf1 + Math.floor(Double.valueOf(RF2[4]));
                    tf2 = tf2 + Double.valueOf(RF1[20]);
                    tf3 = tf3 + Double.valueOf(RF1[21]);

                    sb.append(RF2[1]).append("|")
                            .append(RF2[2]).append("|")
                            .append(RF2[9]).append("|")
                            .append(RF2[3]).append("|")
                            .append(RF2[4]).append("|")
                            .append(RF2[5]).append("|")
                            .append(RF2[6]).append("|")
                            .append(RF2[7]).append("|")
                            .append(RF2[8]).append("|")
                            .append(RF1[20]).append("|")
                            .append(RF1[21]).append("|")
                            .append(RF2[10])
                    ;

                } else if (detailCode.equals("3028")) { /* [随E行G3上网笔记本话单] */
                    if (!RF1[22].startsWith("4000000004") && !RF1[22].startsWith("2000000000")) {
                        continue;
                    }
                    String[] RF2 = new String[12];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = String.format("%.3f", (Double.valueOf(RF1[4]) + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]) + Double.valueOf(RF1[7]) + Double.valueOf(RF1[8]) + Double.valueOf(RF1[9]) + Double.valueOf(RF1[10]) + Double.valueOf(RF1[11]) + Double.valueOf(RF1[12]) + Double.valueOf(RF1[13]) + Double.valueOf(RF1[14]) + Double.valueOf(RF1[15])) / 1.024);
                    RF2[5] = RF1[16];
                    RF2[6] = RF1[17];
                    RF2[7] = RF1[18];

                    RF2[8] = RF1[19];
                    RF2[9] = RF1[22];

                    if (Integer.parseInt(RF1[23]) == 1) {
                        RF2[10] = "G3";
                    } else {
                        RF2[10] = "G网";
                    }
                    if (Double.valueOf(RF2[4]) >= 0) {
                        RF2[4] = String.format("%.3f", Math.ceil(Double.valueOf(RF2[4])));
                    } else {
                        RF2[4] = String.format("%.3f", Math.floor(Double.valueOf(RF2[4])));
                    }

                    sf1 = sf1 + Double.valueOf(RF1[21]);
                    sf4 = sf4 + Double.valueOf(RF1[21]);

                    tf1 = tf1 + Math.floor(Double.valueOf(RF2[4]));
                    tf2 = tf2 + Double.valueOf(RF1[20]);
                    tf3 = tf3 + Double.valueOf(RF1[21]);

                    sb.append(RF2[0]).append("|")
                            .append(RF2[1]).append("|")
                            .append(RF2[2]).append("|")
                            .append(RF2[9]).append("|")
                            .append(RF2[3]).append("|")
                            .append(RF2[4]).append("|")
                            .append(RF2[5]).append("|")
                            .append(RF2[6]).append("|")
                            .append(RF2[7]).append("|")
                            .append(RF2[8]).append("|")
                            .append(RF2[10])
                    ;
                } else if (detailCode.equals("3029")) {/*视频留言*/
                    String[] RF2 = new String[12];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = RF1[4];
                    RF2[5] = RF1[5];
                    RF2[6] = RF1[6];
                    RF2[7] = RF1[7];
                    RF2[8] = RF1[8];
                    RF2[9] = RF1[9];
                    RF2[10] = RF1[10];
                    RF2[11] = RF1[11];

							/*留言类型*/
                    if (RF2[8].equals("0")) {
                        RF2[8] = "语音";
                    } else if (RF2[8].equals("1")) {
                        RF2[8] = "视频";
                    }
                            /*留言访问类型*/
                    if (RF2[9].equals("0")) {
                        RF2[9] = "视频电话";
                    } else if (RF2[9].equals("1")) {
                        RF2[9] = "Web";
                    } else if (RF2[9].equals("2")) {
                        RF2[9] = "语音呼叫";
                    } else if (RF2[9].equals("3")) {
                        RF2[9] = "WAP";
                    } else if (RF2[9].equals("4")) {
                        RF2[9] = "Email";
                    }

							/*话单类型*/
                    if (RF2[11].equals("00")) {
                        RF2[11] = "留言录制";
                    } else if (RF2[11].equals("01")) {
                        RF2[11] = "留言提取";
                    }
                            /*服务等级*/
                    if (RF2[10].equals("01")) {
                        RF2[10] = "时尚版";
                    } else if (RF2[10].equals("02")) {
                        RF2[10] = "商务版";
                    } else if (RF2[10].equals("03")) {
                        RF2[10] = "尊贵版";
                    }
                            /*留言访问类型*/
                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3031")) {/*视频会议*/
                    String[] RF2 = new String[14];
                    for (int i = 0; i < RF2.length; i++) {
                        RF2[i] = RF1[i];
                    }

                    if (RF2[7].equals("00")) {
                        RF2[7] = "免费";
                    } else if (RF2[7].equals("01")) {
                        RF2[7] = "按次";
                    }

                    if (RF2[8].equals("0")) {
                        RF2[8] = "预约";
                    } else if (RF2[8].equals("1")) {
                        RF2[8] = "即时";
                    }

                    if (RF2[9].equals("00")) {
                        RF2[9] = "语音";
                    } else if (RF2[9].equals("01")) {
                        RF2[9] = "视频";
                    } else if (RF2[9].equals("02")) {
                        RF2[9] = "WEB";
                    } else if (RF2[9].equals("03")) {
                        RF2[9] = "WAP";
                    }

                    if (RF2[10].equals("0")) {
                        RF2[10] = "音频";
                    } else if (RF2[10].equals("1")) {
                        RF2[10] = "视频";
                    }

                    if (RF2[11].equals("01")) {
                        RF2[11] = "平台呼出";
                    } else if (RF2[11].equals("02")) {
                        RF2[11] = "用户呼入";
                    }

                    tf1 = tf1 + Double.valueOf(RF2[13]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3030")) {/*视频共享*/
                    String[] RF2 = new String[13];
                    for (int i = 0; i < RF2.length; i++) {
                        RF2[i] = RF1[i];
                    }

                    if (RF2[1].equals("0"))/*呼叫类型*/ {
                        RF2[1] = "发起话单";
                    } else if (RF2[1].equals("1")) {
                        RF2[1] = "接收话单";
                    }
                            /*发起用户终端类型*/
                    if (RF2[4].equals("00")) {
                        RF2[4] = "移动终端";
                    } else if (RF2[4].equals("01")) {
                        RF2[4] = "PC客户端";
                    } else if (RF2[4].equals("02")) {
                        RF2[4] = "AS";
                    } else if (RF2[4].equals("03")) {
                        RF2[4] = "其他方式";
                    }

								/*接收用户终端类型*/
                    if (RF2[5].equals("00")) {
                        RF2[5] = "移动终端";
                    } else if (RF2[5].equals("01")) {
                        RF2[5] = "PC客户端";
                    } else if (RF2[5].equals("02")) {
                        RF2[5] = "AS";
                    } else if (RF2[5].equals("03")) {
                        RF2[5] = "其他方式";
                    }

                    tf1 = tf1 + Double.valueOf(RF2[12]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3003")) { /* [移动彩信话单] */
                    String[] RF2 = new String[9];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];

                    if (RF1[3].equals("00")) {
                        RF2[3] = "免费";
                    } else if (RF1[3].equals("01")) {
                        RF2[3] = "按条计费";
                    } else if (RF1[3].equals("02")) {
                        RF2[3] = "包月计费";
                    } else if (RF1[3].equals("03")) {
                        RF2[3] = "包月查询";
                    } else {
                        RF2[3] = "其他";
                    }

                    if (RF1[2].equals("00")) {
                        RF2[2] = "发送彩信";
                        RF2[3] = "按条计费";
                    } else if (RF1[2].equals("01")) {
                        RF2[2] = "邮箱发出";
                    } else if (RF1[2].equals("02")) {
                        RF2[2] = "梦网彩信";
                    } else if (RF1[2].equals("03")) {
                        RF2[2] = "接收彩信";
                        RF2[3] = "免费";
                    } else {
                        RF2[2] = "其他";
                    }

                    RF2[4] = RF1[4];
                    RF2[5] = String.format("%.2f", Double.valueOf(RF1[5]));
                    RF2[6] = RF1[6];
                    RF2[7] = RF1[7];
                    RF2[8] = RF1[8];
                    tf1 = tf1 + Double.valueOf(RF2[7]) + Double.valueOf(RF2[6]);
                    sf1 = sf1 + Double.valueOf(RF2[7]) + Double.valueOf(RF2[6]);
                    sf4 = sf4 + Double.valueOf(RF2[7]) + Double.valueOf(RF2[6]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3004")) { /* [移动电话购物话单] */
                    String[] RF2 = new String[7];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[4];
                    RF2[4] = RF1[5];
                    RF2[5] = "1";
                    RF2[6] = RF1[6];
                    tf1 = tf1 + Double.valueOf(RF1[6]);
                    sf3 = sf3 + Double.valueOf(RF1[6]);
                    sf4 = sf4 + Double.valueOf(RF1[6]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3005")) { /* [WLAN话单] */
                    String[] RF2 = new String[11];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = RF1[4];
                    RF2[5] = RF1[5];
                    RF2[6] = RF1[6];
                    RF2[7] = String.format("%d", Long.parseLong(RF1[7]));
                    RF2[8] = String.format("%d", Long.parseLong(RF1[8]));
                    RF2[9] = RF1[9].trim();
                    RF2[10] = RF1[10].trim();

                    tf1 = tf1 + Double.valueOf(RF1[9]);
                    tf2 = tf2 + Double.valueOf(RF1[10]);
                    sf1 = sf1 + Double.valueOf(RF1[9]) + Double.valueOf(RF1[10]);
                    sf4 = sf4 + Double.valueOf(RF1[9]) + Double.valueOf(RF1[10]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3006")) { /* [彩铃话单] */
                    String[] RF2 = new String[8];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[3] = RF1[3];
                    RF2[4] = RF1[4];
                    RF2[7] = RF1[6].substring(1, 6);
                    if (RF1[8].equals("0001") || RF1[8].equals("0011") || RF1[8].equals("0003")) {
                        RF2[2] = "铃声下载";
                        RF2[6] = RF1[5];
                        RF2[5] = "0.00";
                    } else if (RF1[8].equals("0000")) {
                        if (Integer.parseInt(RF1[2]) == 1) {
                            RF2[2] = "包月";
                        } else if (Integer.parseInt(RF1[2]) == 7) {
                            RF2[2] = "铃音大礼包";
                        } else {
                            RF2[2] = "包年";
                        }
                        RF2[5] = RF1[5];
                        RF2[6] = "0.00";
                    } else if (RF1[8].equals("0002")) {
                        RF2[2] = "铃音制作";
                        RF2[6] = RF1[5];
                        RF2[5] = "0.00";
                    }


                    tf1 = tf1 + Double.valueOf(RF2[5]);
                    tf2 = tf2 + Double.valueOf(RF2[6]);
                    sf1 = sf1 + Double.valueOf(RF2[5]) + Double.valueOf(RF2[6]);
                    sf4 = sf4 + Double.valueOf(RF2[5]) + Double.valueOf(RF2[6]);


                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3007")) { /* [彩话话单] */
                    String[] RF2 = new String[6];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = String.format("%d", Long.parseLong(RF1[4]) % 10000000);
                    RF2[5] = RF1[5];
                    tf1 = tf1 + Double.valueOf(RF1[4]);
                    sf1 = sf1 + Double.valueOf(RF1[4]);
                    sf4 = sf4 + Double.valueOf(RF1[4]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3008")) { /* [彩话话单-包月] */

                    String[] RF2 = new String[8];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = "000000";
                    RF2[4] = "1000";
                    RF2[5] = RF1[3];
                    RF2[6] = "0.00";
                    RF2[7] = RF1[4];

                    tf1 = tf1 + Double.valueOf(RF1[3]);
                    sf1 = sf1 + Double.valueOf(RF1[3]);
                    sf4 = sf4 + Double.valueOf(RF1[3]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3009")) { /* [号簿管家话单] */

                    String[] RF2 = new String[8];
                    for (int i = 0; i < RF2.length; i++) {
                        RF2[i] = RF1[i];
                    }

                    tf1 = tf1 + Double.valueOf(RF1[7]);
                    sf1 = sf1 + Double.valueOf(RF1[7]);
                    sf4 = sf4 + Double.valueOf(RF1[7]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3010")) { /* [边界漫游] */
                    String[] RF2 = new String[10];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = RF1[8];
                    RF2[5] = RF1[4];
                    RF2[6] = RF1[5];
                    RF2[7] = RF1[6];
                    RF2[8] = RF1[7];

                    if (StringUtils.isNotEmpty(RF2[6]) || StringUtils.isNotEmpty(RF2[7]) || StringUtils.isNotEmpty(RF2[8])) {

                        String roamFlag = "";
                        Map<String, Object> inMap = new HashMap<>();
                        if (StringUtils.isNotEmpty(RF2[6])) {
                            safeAddToMap(inMap, "MSC_ID", RF2[6]);
                        }
                        if (StringUtils.isNotEmpty(RF2[7])) {
                            safeAddToMap(inMap, "LAC_ID", RF2[7]);
                        }
                        if (StringUtils.isNotEmpty(RF2[8])) {
                            safeAddToMap(inMap, "CELL_ID", RF2[7]);
                        }
                        List<ProvCriticalEntity> roamList = null;
                        //roamList = billAccount.getProvCriticalInfo(inMap); //TODO 补充实现
                        if (roamList != null && roamList.size() > 0) {
                            roamFlag = roamList.get(0).getFlag();
                        }

                        if (StringUtils.isEmpty(roamFlag)) {
                            RF2[9] = "否";
                        } else if (roamFlag.equals("2")) {
                            RF2[9] = "小区";
                        } else {
                            RF2[9] = "边界";
                        }

                    } else {
                        RF2[9] = "否";
                    }

                    tf1 = tf1 + 1;

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3011")) { /* [智能名片夹] */
                    String[] RF2 = new String[6];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = String.format("%d", Integer.parseInt(RF1[3]));
                    RF2[4] = RF1[4];
                    RF2[5] = RF1[5];

                    tf1 = tf1 + Double.valueOf(RF1[5]);
                    sf1 = sf1 + Double.valueOf(RF1[5]);
                    sf4 = sf4 + Double.valueOf(RF1[5]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3012")) { /* [VPMN包月] */
                    String[] RF2 = new String[3];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[2];
                    RF2[2] = String.format("%.2f", Double.valueOf(RF1[3]));
                    tf1 = tf1 + Double.valueOf(RF1[3]);
                    sf1 = sf1 + Double.valueOf(RF1[3]);
                    sf4 = sf4 + Double.valueOf(RF1[3]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3013")) { /* [手机动画] */
                    String[] RF2 = new String[9];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[3];
                    RF2[2] = RF1[4];
                    RF2[3] = String.format("%.2f", Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]));
                    RF2[4] = RF1[7];
                    RF2[5] = RF1[9];
                    RF2[6] = RF1[8];
                    RF2[7] = "代收费";
                    RF2[8] = RF1[10];

                    if (Integer.parseInt(RF1[4]) == 1) {
                        RF2[2] = "免费";
                    } else if (Integer.parseInt(RF1[4]) == 2) {
                        RF2[2] = "按条";
                        tf1 = tf1 + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]);
                    } else if (Integer.parseInt(RF1[4]) == 3) {
                        RF2[2] = "包月";
                        tf2 = tf2 + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]);
                    }

                    sf1 = sf1 + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]);
                    sf4 = sf4 + Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]);
                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3014") /* [集团总机] */
                        || detailCode.equals("3015") /* [小区短信] */
                        || detailCode.equals("3016") /*企业信息机*/
                        || detailCode.equals("3019")/* [会议电话] */) { //TODO 3019只对应0，无其他对应关系
                    String[] RF2 = new String[6];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[4];
                    RF2[4] = String.format("%d", Integer.parseInt(RF1[3]));
                    RF2[5] = RF1[5];

                    tf1 = tf1 + Double.valueOf(RF1[5]);
                    sf1 = sf1 + Double.valueOf(RF1[5]);
                    sf4 = sf4 + Double.valueOf(RF1[5]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3017")) { /* [手机视频] */
                    String[] RF2 = new String[11];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[4];
                    RF2[4] = RF1[3];
                    RF2[5] = RF1[5];
                    RF2[6] = RF1[6];
                    RF2[7] = RF1[7];
                    RF2[8] = RF1[8];
                    RF2[9] = RF1[9];
                    RF2[10] = RF1[10];
                    RF2[11] = RF1[11];

                    tf1 = tf1 + Double.valueOf(RF1[6]);
                    sf1 = sf1 + Double.valueOf(RF1[6]);
                    sf4 = sf4 + Double.valueOf(RF1[6]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3020")) { /*无线音乐俱乐部*/
                    String[] RF2 = new String[10];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = RF1[4];
                    RF2[5] = RF1[5];
                    RF2[6] = RF1[6];
                    RF2[7] = RF1[7];

                    /*增加图片下载需求*/
                    if (RF1[8].charAt(7) == '0' && RF1[8].charAt(8) == '0') {
                        RF2[8] = "振铃下载";
                    } else if (RF1[8].charAt(7) == '0' && RF1[8].charAt(8) == '1') {
                        RF2[8] = "彩振合一";
                    } else if (RF1[8].charAt(7) == '0' && RF1[8].charAt(8) == '2') {
                        RF2[8] = "全曲下载";
                    } else if (RF1[8].charAt(7) == '0' && RF1[8].charAt(8) == '3') {
                        RF2[8] = "音乐随身听";
                    } else if (RF1[8].charAt(7) == '0' && RF1[8].charAt(8) == '4') {
                        RF2[8] = "音乐随身听与全曲下载捆绑";
                    } else if (RF1[8].charAt(7) == '0' && RF1[8].charAt(8) == '5') {
                        RF2[8] = "MV下载";
                    } else if (RF1[8].charAt(7) == '0' && RF1[8].charAt(8) == '6') {
                        RF2[8] = "图片下载";
                    } else if (RF1[8].charAt(7) == '1' && RF1[8].charAt(8) == '5') {
                        RF2[8] = "无线音乐专辑汇";
                    } else {
                        RF2[8] = "其他业务";
                    }

                    RF2[9] = RF1[9]; //TODO 补充oneboss.dobmusicspbizinfo表中获取名称的方式

                    tf1 = tf1 + Double.valueOf(RF1[6]);
                    sf1 = sf1 + Double.valueOf(RF1[6]);
                    sf4 = sf4 + Double.valueOf(RF1[6]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3033")) { /* [联通彩信话单] */
                    String[] RF2 = new String[10];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];

                    if (RF1[4].equals("00")) {
                        RF2[4] = "免费";
                    } else if (RF1[4].equals("01")) {
                        RF2[4] = "按条计费";
                    } else if (RF1[3].equals("02")) {
                        RF2[4] = "包月计费";
                    } else if (RF1[3].equals("03")) {
                        RF2[4] = "包月查询";
                    } else {
                        RF2[4] = "其他";
                    }

                    if (RF1[3].equals("00")) {
                        RF2[3] = "发送彩信";
                        RF2[4] = "按条计费";
                    } else if (RF1[3].equals("01")) {
                        RF2[3] = "邮箱发出";
                    } else if (RF1[3].equals("02")) {
                        RF2[3] = "梦网彩信";
                    } else if (RF1[4].equals("03")) {
                        RF2[3] = "接收彩信";
                        RF2[4] = "免费";
                    } else {
                        RF2[3] = "其他";
                    }

                    RF2[5] = RF1[5];
                    RF2[6] = String.format("%.2f", Double.valueOf(RF1[6]));
                    RF2[7] = RF1[7];
                    RF2[8] = RF1[8];
                    RF2[9] = RF1[9];
                    RF2[9] = "";
                    tf1 = tf1 + Double.valueOf(RF2[8]) + Double.valueOf(RF2[7]);
                    sf1 = sf1 + Double.valueOf(RF2[8]) + Double.valueOf(RF2[7]);
                    sf4 = sf4 + Double.valueOf(RF2[8]) + Double.valueOf(RF2[7]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3021")) { /*彩票投注详单*/
                    String[] RF2 = new String[4];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[2];
                    RF2[2] = RF1[3];
                    RF2[3] = RF1[4];

                    tf1 = tf1 + Double.valueOf(RF2[3]);
                    sf1 = sf1 + Double.valueOf(RF2[3]);
                    sf4 = sf4 + Double.valueOf(RF2[3]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3022") || detailCode.equals("3023")) {/*行业网关应用短信话单/（新）*/
                    if (!RF1[0].equals("00") && !RF1[0].equals("10")) {
                        continue;
                    }
                    String[] RF2 = new String[8];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = RF1[4];
                    RF2[5] = RF1[5];
                    RF2[6] = String.format("%.2f", Double.valueOf(RF1[6]) / 1000);

                    RF2[7] = String.format("20%s/%s/%s %s:%s:%s",
                            RF1[7].substring(0, 2), RF1[7].substring(2, 4), RF1[7].substring(4, 6),
                            RF1[7].substring(6, 8), RF1[7].substring(8, 10), RF1[7].substring(10, 12));

                    if (RF1[5].equals("01")) {
                        RF2[5] = "免费";
                    } else if (RF1[5].equals("02")) {
                        RF2[5] = "按条计费";
                    } else if (RF1[5].equals("03")) {
                        RF2[5] = "包月方式";
                    } else if (RF1[5].equals("99")) {
                        RF2[5] = "个人按条计费";
                    } else {
                        RF2[5] = "系统未定义";
                    }

                    tf1 = tf1 + Double.valueOf(RF2[6]);
                    sf1 = sf1 + Double.valueOf(RF2[6]);
                    sf4 = sf4 + Double.valueOf(RF2[6]);

                    for (int i = 1; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("3024")) {/*手机地图*/
                    String[] RF2 = new String[10];
                    if (RF1[0].equals("00")) {
                        RF2[0] = "WAP";
                    } else if (RF1[0].equals("01")) {
                        RF2[0] = "客户端";
                    } else if (RF1[0].equals("03")) {
                        RF2[0] = "短信方式";
                    } else if (RF1[0].equals("04")) {
                        RF2[0] = "www方式";
                    } else {
                        RF2[0] = "未定义";
                    }

                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = RF1[4];
                    RF2[5] = RF1[5];

                    if (RF1[6].equals("01")) {
                        RF2[6] = "免费";
                    } else if (RF1[6].equals("02")) {
                        RF2[6] = "按条计费";
                    } else if (RF1[6].equals("03")) {
                        RF2[6] = "包月计费";
                    } else if (RF1[6].equals("04")) {
                        RF2[6] = "包月查询";
                    } else {
                        RF2[6] = "系统未定义";
                    }
                    RF2[7] = RF1[7];
                    RF2[8] = RF1[8];
                    RF2[9] = RF1[9];


                    tf1 = tf1 + Double.valueOf(RF2[7]);
                    sf1 = sf1 + Double.valueOf(RF2[7]);
                    sf4 = sf4 + Double.valueOf(RF2[7]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3025")) { /*全网农信通*/
                    String[] RF2 = new String[10];
                    for (int i = 0; i < RF2.length; i++) {
                        RF2[i] = RF1[i];
                    }

                    if (RF1[7].equals("01")) {
                        RF2[7] = "免费";
                    } else if (RF1[7].equals("02")) {
                        RF2[7] = "按条计费";
                    } else if (RF1[7].equals("03")) {
                        RF2[7] = "包月方式";
                    } else {
                        RF2[7] = "系统未定义";
                    }

                    tf1 = tf1 + Double.valueOf(RF2[8]);
                    sf1 = sf1 + Double.valueOf(RF2[8]);
                    sf4 = sf4 + Double.valueOf(RF2[8]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("3026")) {/*多媒体彩铃*/

                    String[] RF2 = new String[15];
                    for (int i = 0; i < RF2.length; i++) {
                        RF2[i] = RF1[i];
                    }

							/*计费类型*/
                    if (RF1[6].equals("01")) {
                        RF2[6] = "免费";
                    } else if (RF1[6].equals("02")) {
                        RF2[6] = "按条计费";
                    }
                            /*业务类型*/
                    if (RF1[7].equals("01")) {
                        RF2[7] = "单首铃音订制";
                    } else if (RF1[7].equals("02")) {
                        RF2[7] = "单首铃音赠送";
                    } else if (RF1[7].equals("03")) {
                        RF2[7] = "单首铃音复制";
                    } else if (RF1[7].equals("04")) {
                        RF2[7] = "铃音盒订制";
                    } else if (RF1[7].equals("05")) {
                        RF2[7] = "铃音盒赠送";
                    } else if (RF1[7].equals("06")) {
                        RF2[7] = "铃音盒复制";
                    }

					/*订购途径*/
                    if (RF1[9].equals("000")) {
                        RF2[9] = "其他途径";
                    } else if (RF1[9].equals("001")) {
                        RF2[9] = "WWW";
                    } else if (RF1[9].equals("002")) {
                        RF2[9] = "WAP";
                    } else if (RF1[9].equals("003")) {
                        RF2[9] = "IVR";
                    } else if (RF1[9].equals("004")) {
                        RF2[9] = "SMS";
                    } else if (RF1[9].equals("005")) {
                        RF2[9] = "USSD";
                    } else if (RF1[9].equals("006")) {
                        RF2[9] = "IMR";
                    }

							/*业务标识码*/
                    if (RF1[10].equals("1")) {
                        RF2[10] = "非DIY非集团个人彩铃";
                    } else if (RF1[10].equals("2")) {
                        RF2[10] = "集团彩铃";
                    } else if (RF1[10].equals("3")) {
                        RF2[10] = "集团个人彩铃";
                    }

                    tf1 = tf1 + Double.valueOf(RF2[14]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("4022")) { /* Mobile Markets业务话单*/
                    String[] RF2 = new String[11];
                    for (int i = 0; i < RF2.length; i++) {
                        RF2[i] = RF1[i];
                    }

                    RF2[4] = billAccount.getOperName(RF1[3], RF2[4]);
                                /*承载类型*/
                    if (RF1[0].equals("0")) {
                        RF2[0] = "保留";
                    } else if (RF1[0].equals("1")) {
                        RF2[0] = "CSD";
                    } else if (RF1[0].equals("2")) {
                        RF2[0] = "GPRS";
                    } else if (RF1[0].equals("3")) {
                        RF2[0] = "TD-SCDMA";
                    }
                                /*应用类型*/
                    if (RF1[5].equals("01")) {
                        RF2[5] = "在线";
                    } else if (RF1[5].equals("02")) {
                        RF2[5] = "离线";
                    }
                                /*计费类别*/
                    if (RF1[8].equals("01")) {
                        RF2[8] = "免费";
                    } else if (RF1[8].equals("02")) {
                        RF2[8] = "按次计费";
                    } else if (RF1[8].equals("03")) {
                        RF2[8] = "包月计费";
                    } else if (RF1[8].equals("04")) {
                        RF2[8] = "包月查询";
                    }
                                /*计费类别*/
                    if (RF1[10].equals("00")) {
                        RF2[10] = "M-MARKETS";
                    } else if (RF1[10].equals("01")) {
                        RF2[10] = "WWW";
                    } else if (RF1[10].equals("02")) {
                        RF2[10] = "WAP";
                    } else if (RF1[10].equals("03")) {
                        RF2[10] = "手机终端";
                    }


                    tf1 = tf1 + Double.valueOf(RF2[9]);
                    sf1 = sf1 + Double.valueOf(RF2[9]);
                    sf4 = sf4 + Double.valueOf(RF2[9]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                } else if (detailCode.equals("4053")) { /*widget话单*/ //TODO待确认是不是53
                    String[] RF2 = new String[9];
                    if (RF1[0].equals("01")) {
                        RF2[0] = "应用下载";
                    } else if (RF1[0].equals("02")) {
                        RF2[0] = "内容下载";
                    } else {
                        RF2[0] = RF1[0];
                    }

                    if (RF1[1].equals("1")) {
                        RF2[1] = "CSD";
                    } else if (RF1[1].equals("2")) {
                        RF2[1] = "GPRS";
                    } else if (RF1[1].equals("3")) {
                        RF2[1] = "TD-SCDMA";
                    } else {
                        RF2[1] = RF1[1];
                    }

                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = RF1[4];
                    if (RF1[5].equals("01")) {
                        RF2[5] = "在线";
                    } else if (RF1[5].equals("02")) {
                        RF2[5] = "非在线";
                    } else if (RF1[5].equals("99")) {
                        RF2[5] = "其他";
                    } else {
                        RF2[5] = RF1[5];
                    }

                    RF2[6] = RF1[6];

                    if (RF1[7].equals("01")) {
                        RF2[7] = "免费";
                    } else if (RF1[7].equals("02")) {
                        RF2[7] = "按次计费";
                    } else if (RF1[7].equals("03")) {
                        RF2[7] = "包月计费";
                    } else if (RF1[7].equals("04")) {
                        RF2[7] = "包月查询";
                    } else {
                        RF2[7] = RF1[7];
                    }

                    RF2[8] = RF1[8];


                    tf1 = tf1 + Double.valueOf(RF2[8]);
                    sf1 = sf1 + Double.valueOf(RF2[8]);
                    sf4 = sf4 + Double.valueOf(RF2[8]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("4023")) { /*手机电视收视费(广电合作)*/
                    String[] RF2 = new String[5];
                    RF2[0] = RF1[0];
                    RF2[1] = "手机电视收视费";
                    if (RF1[1].equals("0000")) {
                        RF2[2] = "基本功能费";
                    } else if (RF1[1].equals("0001")) {
                        RF2[2] = "全网收视费1";
                    } else {
                        RF2[2] = RF1[1];
                    }
                    RF2[3] = RF1[2];
                    RF2[4] = RF1[3];
                    tf1 = tf1 + Double.valueOf(RF2[4]);
                    sf1 = sf1 + Double.valueOf(RF2[4]);
                    sf4 = sf4 + Double.valueOf(RF2[4]);
                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("4032")) {/*手机阅读*/
                    String[] RF2 = new String[6];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3].trim();

                    if (RF1[4].equals("01")) {
                        RF2[4] = "免费";
                    } else if (RF1[4].equals("02")) {
                        RF2[4] = "按次计费";
                    } else if (RF1[4].equals("03")) {
                        RF2[4] = "包月计费";
                    } else if (RF1[4].equals("04")) {
                        RF2[4] = "包月查询";
                    } else {
                        RF2[4] = "NULL";
                    }

                    RF2[5] = String.format("%.2f", Double.valueOf(RF1[5]) + Double.valueOf(RF1[6]));
                    tf1 = tf1 + Double.valueOf(RF2[5]);
                    sf1 = sf1 + Double.valueOf(RF2[5]);
                    sf4 = sf4 + Double.valueOf(RF2[5]);

                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }
                } else if (detailCode.equals("4033")) { /* [短号短信话单] */
                    String[] RF2 = new String[8];
                    RF2[0] = RF1[0];
                    RF2[1] = RF1[1];
                    RF2[2] = RF1[2];
                    RF2[3] = RF1[3];
                    RF2[4] = RF1[4];
                    RF2[5] = RF1[5];
                    RF2[7] = "已发送";
                    tf1 = tf1 + Double.valueOf(RF1[3]);
                    sf1 = sf1 + Double.valueOf(RF1[3]);
                    sf4 = sf4 + Double.valueOf(RF1[3]);

                    if (Integer.parseInt(RF1[5]) == 0) {
                        RF2[6] = "手机";
                    } else {
                        RF2[6] = "其他";
                    }
                    for (int i = 0; i < RF2.length; i++) {
                        if (i == RF2.length - 1) {
                            sb.append(RF2[i]); //最后一个元素不追加竖线
                        } else {
                            sb.append(RF2[i]).append("|");
                        }
                    }

                }

                if (sb != null && sb.length() > 0) {
                    outDetailLines.add(sb.toString());
                }
            } //::END处理每一ETC文件对应的详单记录

            /*处理每一种ETC对应的小计*/
            sb = new StringBuilder();
            if (detailCode.equals("1001") || detailCode.equals("1002")
                    || detailCode.equals("1003") || detailCode.equals("1004")
                    || detailCode.equals("4001")) { /* [语音话单-普通语音话单] *//* [可视电话话单] */
                sb.append("基本费合计=").append(String.format("%.2f", tf1)).append("，")
                        .append("长途费合计=").append(String.format("%.2f", tf2)).append("，")
                        .append("WAP通话费合计=").append(String.format("%.2f", tf3)).append("，")
                        .append("总费用合计=").append(String.format("%.2f", tf4));

                System.out.println(sb.toString());
                System.out.println("==========wangla 6606 [ " + outDetailLines.size());
                outDetailLines.add(sb.toString());

                sb = new StringBuilder();
                sb.append("实收基本费合计=").append(String.format("%.2f", tf5)).append("，")
                        .append("实收长途费合计=").append(String.format("%.2f", tf6)).append("，")
                        .append("实收WAP通话费合计=").append(String.format("%.2f", tf7)).append("，")
                        .append("实收总费用合计=").append(String.format("%.2f", tf8));
            } else if (detailCode.equals("1011") || detailCode.equals("4011")) {/* [语音话单-呼转语音话单] *//* [可视电话呼转话单] */
                sb.append("呼转基本资费合计=").append(String.format("%.2f", tf1)).append("，")
                        .append("呼转长途费1合计=").append(String.format("%.2f", tf2)).append("，")
                        .append("呼转长途费2合计=").append(String.format("%.2f", tf3));
            } else if (detailCode.equals("1021")) { /* [语音话单-VPMN语音话单] */
                sb.append("VPMN基本话费=").append(String.format("%.2f", tf1)).append("，")
                        .append("VPMN长途话费=").append(String.format("%.2f", tf2)).append("，")
                        .append("VPMN话费合计=").append(String.format("%.2f", tf3));
            } else if (detailCode.equals("1031")) { /* [语音话单-语音杂志话单] */
                sb.append("语音杂志信息费合计=").append(String.format("%.2f", tf1));
            } else if (detailCode.equals("1041")) { /* [语音话单-新全球呼话单] */
                sb.append("新全球呼信息费合计=").append(String.format("%.2f", tf1));
            } else if (detailCode.equals("2001")) { /* [短信话单-普通短信话单] */
                sb.append("普通短信费合计=").append(String.format("%.2f", tf1));
            } else if (detailCode.equals("2002")) { /* [短信话单-互通短信话单] */
                sb.append("互通短信费用合计=").append(String.format("%.2f", tf1));
            } else if (detailCode.equals("2003")) { /* [短信话单-移动梦网短信话单] */
                sb.append("移动梦网短信费合计").append(String.format("%.2f", tf1));
            } else if (detailCode.equals("3001")) { /* [代收话单] */
                sb.append("按条信息费合计=").append(String.format("%.2f", tf1)).append("，")
                        .append("包月合计=").append(String.format("%.2f", tf2));
            } else if (detailCode.equals("3034")) { /* [手机游戏话单] */
                sb.append("信息费合计=").append(String.format("%.2f", tf1));
            } else if (detailCode.equals("3035")) { /* 手机对讲业务(PoC) */
                sb.append("通信费合计=").append(String.format("%.2f", tf1));
            } else if (detailCode.equals("3036")) { /* [手机动漫话单] */
                sb.append("信息费合计=").append(String.format("%.2f", tf1));
            } else if (detailCode.equals("3037")) { /* [12582农信通百事易] */
                sb.append("12582农信通百事易费用合计=").append(String.format("%.2f", tf1));
            } else if (detailCode.equals("3038")) { /* [短信回执] */
                sb.append("短信回执费用合计=").append(String.format("%.2f", tf1));
            } else if (detailCode.equals("3039")) { /* [亲情通] */
                sb.append("亲情通费用合计=").append(String.format("%.2f", tf1));
            } else if (detailCode.equals("3041")) { /* [宜居通] */
                sb.append("宜居通费用合计=").append(String.format("%.2f", tf1));
            } else if (detailCode.equals("3002")) { /* [GPRS话单] */
                sb.append(String.format("GPRS流量合计=%.3f k，GPRS应收合计=%.2f，GPRS实收合计=%.2f", tf1, Math.round(tf2 * 100) / 100.0, Math.round(tf3 * 100) / 100.0));
            } else if (detailCode.equals("3040")) { /* [GPRS国际漫游话单] */
                sb.append(String.format("GPRS流量合计=%.3f k，GPRS应收合计=%.2f，GPRS实收合计=%.2f ", tf1, Math.round(tf2 * 100) / 100.0, Math.round(tf3 * 100) / 100.0));
            } else if (detailCode.equals("3028")) { /* [随E行G3上网笔记本话单] */
                sb.append(String.format("随E行G3上网笔记本流量合计=%.3f k，随E行G3上网笔记本应收合计=%.2f，随E行G3上网笔记本实收合计=%.2f", tf1, Math.round(tf2 * 100) / 100.0, Math.round(tf3 * 100) / 100.0));
            } else if (detailCode.equals("3003")) { /* [移动彩信话单] */
                sb.append(String.format("彩信费用合计=%.2f", tf1));
            } else if (detailCode.equals("3004")) { /* [移动电话购物话单] */
                sb.append(String.format("购物话费合计=%10.2f", tf1));
            } else if (detailCode.equals("3005")) { /* [WLAN话单] */
                sb.append(String.format("通信费合计=%.2f  信息费合计=%.2f", tf1, tf2));
            } else if (detailCode.equals("3006")) { /* [彩铃话单] */
                sb.append(String.format("月租费合计=%.2f  信息费合计=%.2f", tf1, tf2));
            } else if (detailCode.equals("3007")) { /* [彩话话单] */
                sb.append(String.format("彩话信息费合计=%.2f", tf1));
            } else if (detailCode.equals("3008")) { /* [彩话话单-包月] */
                sb.append(String.format("月租费合计=%.2f  信息费合计=%.2f", tf1, tf2));
            } else if (detailCode.equals("3009")) { /* [号簿管家话单] */
                sb.append(String.format("号簿管家信息费合计=%.2f", tf1));
            } else if (detailCode.equals("3010")) { /* [话簿管家话单] */
                sb.append(String.format("共查询到[%.f]条用户边界漫游数据信息", tf1));
            } else if (detailCode.equals("3011")) { /* [智能名片夹] */
                sb.append(String.format("智能名片夹信息费合计=%.2f", tf1));
            } else if (detailCode.equals("3012")) { /* [VPMN包月] */
                sb.append(String.format("VPNM包月费用合计=%.2f ", tf1));
            } else if (detailCode.equals("3013")) { /* [手机动画] */
                sb.append(String.format("按条信息费合计=%.2f  包月合计=%.2f", tf1, tf2));
            } else if (detailCode.equals("3014")) { /* [集团总机] 页尾*/
                sb.append(String.format("集团总机信息费合计=%.2f", tf1));
            } else if (detailCode.equals("3015")) {/* [小区短信] 页尾*/
                sb.append(String.format("小区短信信息费合计=%.2f", tf1));
            } else if (detailCode.equals("3016")) { /* [企业信息机] 页尾*/
                sb.append(String.format("企业信息机信息费合计=%.2f", tf1));
            } else if (detailCode.equals("3017")) {  /* [手机电视] 页尾*/
                sb.append(String.format("手机视频信息费合计=%.2f", tf1));
            } else if (detailCode.equals("3019")) { /* [会议电话] */
                sb.append(String.format("会议电话信息费合计=%.2f", tf1));
            } else if (detailCode.equals("3020")) {/*无线音乐俱乐部*/
                sb.append(String.format("无线音乐俱乐部信息费合计=%.2f", tf1));
            } else if (detailCode.equals("3033")) { /* [联通彩信话单] */
                sb.append(String.format("彩信费用合计=%.2f", tf1));
            } else if (detailCode.equals("3021")) { /*无线音乐俱乐部*/
                sb.append(String.format("彩票投注费用合计=%.2f", tf1));
            } else if ((queryType.equals("0") && detailCode.equals("3023"))
                    || (!queryType.equals("0") && detailCode.equals("3022"))) { /*行业网关应用短信话单(新)*/
                sb.append(String.format("行业应用短信话单费用合计=%.2f", tf1));
            } else if (detailCode.equals("3024")) { /*手机地图*/
                sb.append(String.format("手机地图费用合计=%.2f", tf1));
            } else if (detailCode.equals("3025")) { /*全网农信通*/
                sb.append(String.format("全网农信通费用合计=%.2f", tf1));
            } else if (detailCode.equals("3026")) { /*多媒体彩铃*/
                sb.append(String.format("多媒体彩铃费用合计=%.2f", tf1));
            } else if (detailCode.equals("3031")) { /*视频会议*/
                sb.append(String.format("视频会议费用合计=%.2f ", tf1));
            } else if (detailCode.equals("3030")) {/*视频共享*/
                sb.append(String.format("视频共享费用合计=%.2f", tf1));
            } else if (detailCode.equals("3029")) {/*视频留言*/
                sb.append(String.format("视频留言费用合计=0.00"));
            } else if (detailCode.equals("4022")) {/* Mobile Markets业务话单*/
                sb.append(String.format("Mobile Markets业务话单优惠后信息费合计=%.2f", tf1));
            } else if (detailCode.equals("4053")) {/*widget*/
                sb.append(String.format("widget费用合计=%.2f", tf1));
            } else if (detailCode.equals("4023")) {/*手机电视收视费(广电合作)*/
                sb.append(String.format("手机电视收视费(广电合作)费用合计=%.2f", tf1));
            } else if (detailCode.equals("4032")) { /*手机阅读*/
                sb.append(String.format("手机阅读费用合计=%.2f", tf1));
            } else if (detailCode.equals("4033")) { /* [短信话单-普通短信话单] */
                sb.append(String.format("短号短信费合计=%.2f", tf1));
            }

            if (sb != null && sb.length() > 0) {
                outDetailLines.add(sb.toString());
            }

        }

        /*处理每一种queryType对应的合计*/
        String totalStr = String.format("实收基本费合计：%.2f，实收长途费合计：%.2f，购物费用合计：%.2f，实收费用总合计：%.2f", Math.round(sf1 * 100) / 100.0, Math.round(sf2 * 100) / 100.0, Math.round(sf3 * 100) / 100.0, Math.round(sf4 * 100) / 100.0);

        outDetailLines.add(totalStr);

        return outDetailLines;
    }


    public IUser getUser() {
        return user;
    }

    public void setUser(IUser user) {
        this.user = user;
    }

    public IBillAccount getBillAccount() {
        return billAccount;
    }

    public void setBillAccount(IBillAccount billAccount) {
        this.billAccount = billAccount;
    }

    public IControl getControl() {
        return control;
    }

    public void setControl(IControl control) {
        this.control = control;
    }

    public IProd getProd() {
        return prod;
    }

    public void setProd(IProd prod) {
        this.prod = prod;
    }
}
