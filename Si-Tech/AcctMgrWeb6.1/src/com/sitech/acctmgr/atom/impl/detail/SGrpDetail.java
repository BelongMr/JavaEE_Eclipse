package com.sitech.acctmgr.atom.impl.detail;

import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.detail.DynamicTable;
import com.sitech.acctmgr.atom.domains.detail.ElementAttribute;
import com.sitech.acctmgr.atom.domains.detail.GrpDetailEntity;
import com.sitech.acctmgr.atom.domains.record.ActQueryOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UsersvcAttrEntity;
import com.sitech.acctmgr.atom.dto.detail.SGrpDetailQueryInDTO;
import com.sitech.acctmgr.atom.dto.detail.SGrpDetailQueryOutDTO;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.CacheOpr;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.inter.detail.IGrpDetail;
import com.sitech.acctmgr.net.ServerInfo;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

import java.io.IOException;
import java.io.InputStream;
import java.util.*;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

/**
 * Created by wangyla on 2016/12/20.
 */
@ParamTypes({
        @ParamType(c = SGrpDetailQueryInDTO.class, m = "query", oc = SGrpDetailQueryOutDTO.class)
})
public class SGrpDetail extends AcctMgrBaseService implements IGrpDetail {

    private IDetailDisplayer detailDisplayer;
    private IUser user;
    private IProd prod;
    private ICust cust;
    private IRecord record;
    private ILogin login;
    private IControl control;

    private static volatile String cacheSwitch;
    private CacheOpr cacheOpr;

    static {
        Properties prop = new Properties();
        InputStream is = SDetail.class.getClassLoader().getResourceAsStream("busi.properties");
        try {
            prop.load(is);
        } catch (IOException e) {
            e.printStackTrace();
        }

        cacheSwitch = prop.getProperty("cache_switch");
    }

    @Override
    public OutDTO query(InDTO inParam) {
        SGrpDetailQueryInDTO inDTO = (SGrpDetailQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        long grpCustId = inDTO.getGrpCustId();
        String queryFlag = inDTO.getQueryFlag();
        int queryYm = inDTO.getYearMonth();
        String beginDate = inDTO.getBegintime();
        String endDate = inDTO.getEndtime();
        String callNum = inDTO.getCallingNumber();
        String confId = inDTO.getConferenceId();

        Map<String, String> timeMap = this.getQueryTimes(queryFlag, queryYm, beginDate, endDate);
        String dealBeginTime = timeMap.get("DEAL_BEGIN_TIME"); //话单处理开始时间
        String dealEndTime = timeMap.get("DEAL_END_TIME"); //话单处理结束时间
        String callBeginTime = timeMap.get("CALL_BEGIN_TIME"); //通话开始时间
        String callEndTime = timeMap.get("CALL_END_TIME"); //通话结束时间

        log.debug(dealBeginTime + "-" + dealEndTime + "," + callBeginTime + "-" + callEndTime);

        List<DynamicTable> tables = new ArrayList<>();
        /*获取详表详单body部分*/
        List<String> queryTypeList = this.getQueryType(inDTO.getQueryType());

        List<String> detailDispLines = new ArrayList<>();

        for (String queryType : queryTypeList) {
            int detailType = Integer.parseInt(queryType);

            List<String> detailLines = new ArrayList<>();
            switch (detailType) {
                case 1:
                    detailLines = this.detail01(grpCustId, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 2:
                    detailLines = this.detail02(grpCustId, dealBeginTime, dealEndTime, callBeginTime, callEndTime, callNum, confId);
                    break;
                case 3:
                    detailLines = this.detail03(grpCustId, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 4:
                    detailLines = this.detail04(grpCustId, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 5:
                    detailLines = this.detail05(grpCustId, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 6:
                    detailLines = this.detail06(grpCustId, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 7:
                    detailLines = this.detail07(grpCustId, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 8:
                    detailLines = this.detail08(grpCustId, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
                case 9:
                    detailLines = this.detail09(grpCustId, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
                    break;
            }

            detailDispLines.addAll(detailLines);

        }

        DynamicTable detailTable = this.getDetailInfo(detailDispLines);
        tables.add(detailTable);

        this.saveQueryOprLog(grpCustId, inDTO.getLoginNo(), inDTO.getGroupId(), inDTO.getOpCode(), inDTO.getQueryType(), inDTO.getProvinceId());

        SGrpDetailQueryOutDTO outDTO = new SGrpDetailQueryOutDTO();
        outDTO.setTables(tables);

        log.debug("outDto=" + outDTO.toJson());
        return outDTO;
    }

    /**
     * 功能：集团客户查询时间段确认
     *
     * @param queryFlag
     * @param yearMonth
     * @param beginTime
     * @param endTime
     * @return
     */
    private Map<String, String> getQueryTimes(String queryFlag, Integer yearMonth, String beginTime, String endTime) {

        Map<String, String> timeMap = new HashMap<>();
        String dealBeginTime = ""; //话单处理开始时间
        String dealEndTime = ""; //话单处理结束时间
        String callBeginTime = ""; //通话开始时间
        String callEndTime = ""; //通话结束时间

        if (queryFlag.equals("0")) { //按时间段查询
            if (beginTime.length() == 8 && endTime.length() == 8) { //yyyyMMdd

                dealBeginTime = String.format("%s000000", beginTime.substring(0, 8));
                dealEndTime = String.format("%s235959", endTime.substring(0, 8));

                callBeginTime = String.format("%s000000", beginTime);
                callEndTime = String.format("%s235959", endTime);
            } else if (beginTime.length() > 8 && endTime.length() > 8) { //yyyyMmddHHMiss

                dealBeginTime = String.format("%s", beginTime);
                dealEndTime = String.format("%s", endTime);

                callBeginTime = String.format("%s", beginTime);
                callEndTime = String.format("%s", endTime);
            }

        } else if (queryFlag.equals("1")) { //按帐期查询
            int beginDate = yearMonth * 100 + 1;
            int endDate = yearMonth * 100 + DateUtils.getLastDayOfMonth(yearMonth);

            dealBeginTime = String.format("%d000000", beginDate);
            dealEndTime = String.format("%d235959", endDate);

            callBeginTime = String.format("%d000000", beginDate);
            callEndTime = String.format("%d235959", endDate);
        }

        safeAddToMap(timeMap, "DEAL_BEGIN_TIME", dealBeginTime);
        safeAddToMap(timeMap, "DEAL_END_TIME", dealEndTime);
        safeAddToMap(timeMap, "CALL_BEGIN_TIME", callBeginTime);
        safeAddToMap(timeMap, "CALL_END_TIME", callEndTime);

        return timeMap;
    }

    /**
     * 功能：
     *
     * @param queryType
     * @return
     */
    private List<String> getQueryType(String queryType) {
        List<String> outList = new ArrayList<>();

        /**
         * 集团详单按下列类型进行查询：
         * 01：行业网关
         * 02：移动会议
         * 03：集团客户IDC公众服务云
         * 04：呼叫中心直连
         * 05：企业阅读
         * 06：企业彩漫
         * 07：云视频会议
         * 08：企业智运会
         * 09：企业互联网电视
         */

        if (queryType.equals("00")) {

            outList = Arrays.asList(new String[]{"01", "02", "03", "04", "05", "06", "07", "08", "09"});
        } else {
            outList.add(queryType);
        }
        return outList;
    }

    /**
     * 功能：将详单列表转换成动态表格，以使能在页面中展示
     *
     * @param detailLines
     * @return
     */
    private DynamicTable getDetailInfo(List<String> detailLines) {
        DynamicTable detailTable = new DynamicTable();
        detailTable.setElementCol("2");
        detailTable.setElementLabelType("2");
        detailTable.setElementPaging(true);
        List<ElementAttribute> body = new ArrayList<>();
        List<ElementAttribute> baseBody = new ArrayList<>();

        ElementAttribute head = new ElementAttribute();
        head.setDefaultValue("中国移动通信客户集团详单");
        head.setElementId("base_title_id");
        head.setElementName("base_title_name");
        head.setElementType("24"); //文本显示
        head.setElementTdType("TH");
        head.setElementTdAttr("style=\"text-align:left !important; font-weight:bold!important;\"");
        baseBody.add(head);

        ElementAttribute spaceCell = new ElementAttribute();
        spaceCell.setDefaultValue("");
        spaceCell.setElementId("base_space_cell");
        spaceCell.setElementName("base_space_cell_name");
        spaceCell.setElementType("24"); //文本显示
        spaceCell.setElementTdType("TH");
        baseBody.add(spaceCell);

        int rows;

        List<ElementAttribute> detailBody = new ArrayList<>();
        rows = 1;
        for (String line : detailLines) {
            ElementAttribute cell = new ElementAttribute();
            cell.setDefaultValue(line.replace(" ", "&nbsp;"));
            cell.setElementId("raw_detail_line_id_" + rows);
            cell.setElementName("raw_detail_line_name_" + rows);
            cell.setElementType("24"); //文本显示
            cell.setElementTdType("TD");
            cell.setElementTdAttr("style=\"text-align:left !important;\"");
            detailBody.add(cell);

            spaceCell = new ElementAttribute();
            spaceCell.setDefaultValue("");
            spaceCell.setElementId("detail_space_cell");
            spaceCell.setElementName("detail_space_cell_name");
            spaceCell.setElementType("24"); //文本显示
            spaceCell.setElementTdType("TD");
            detailBody.add(spaceCell);

            rows++;
        }


        body.addAll(baseBody);
        body.addAll(detailBody);
        detailTable.setElementAttrList(body);

        return detailTable;
    }


    private List<String> detail01(long custId, String dealBeginTime, String dealEndTime,
                                  String callBeginTime, String callEndTime) {

        double totalShould = 0.00;
        double totalFavour = 0.00;
        int totalCount = 0;
        List<String> outList = new ArrayList<>();
        /*集团行业网关短信部分*/
        String smsHeadString = "行业网关详单内容";


        String title = "计费号码|业务代码|服务代码|发送时间|对方号码|短信类型|费用|优惠后费用";
        String[] titleFields = title.split("\\|");
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (String titleCell : titleFields) {
            if (i < titleFields.length) {
                sb.append(titleCell).append(String.format("%-8s", " "));
            } else {
                sb.append(titleCell);
            }
            i++;
        }

        String titleString = sb.toString();

        outList.add(smsHeadString);
        outList.add(titleString);

        List<UserInfoEntity> grpSmsUserList = user.getGrpUserInfoByCustId(custId);
        for (UserInfoEntity grpUserEnt : grpSmsUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();
            long grpIdNo = grpUserEnt.getIdNo();

            UsersvcAttrEntity svcAttrInfo = user.getUsersvcAttr(grpIdNo, "23B195"); //获取网关号码
            if (svcAttrInfo == null) { //只获取服务属性为 23B195 的集团用户
                continue;
            }
            String svrCode = svcAttrInfo.getAttrValue(); //行业网关对端号码
            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailSms = detailDisplayer.grpDetail01Sms(grpPhoneNo, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, svrCode);

            totalShould += grpDetailSms.getTotalShould();
            totalFavour += grpDetailSms.getTotalFavour();
            totalCount += grpDetailSms.getLineCount();

            outList.addAll(grpDetailSms.getDetailLines());

        }

        /*集团行业网关彩信部分*/
        String mmsHeadString = "行业网关彩信A模块内容";
        outList.add(mmsHeadString);
        outList.add(titleString);

        String brandIds = "2310ML,2310AD"; //对应老的ML，AD品牌
        List<UserInfoEntity> grpMmsUserList = user.getGrpUserInfoByBrand(custId, brandIds);
        for (UserInfoEntity grpUserEnt : grpMmsUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();
            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailMms = detailDisplayer.grpDetail01Mms(grpPhoneNo, serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime);

            totalShould += grpDetailMms.getTotalShould();
            totalFavour += grpDetailMms.getTotalFavour();
            totalCount += grpDetailMms.getLineCount();

            outList.addAll(grpDetailMms.getDetailLines());
        }

        String footString = new StringBuilder().append("共计[").append(totalCount).append("]条").append(" ")
                .append("费用合计[").append(totalShould).append("]元").append(" ")
                .append("优惠后费用[").append(totalFavour).append("]元").toString();

        outList.add(footString);

        return outList;
    }

    private List<String> detail02(long custId, String dealBeginTime, String dealEndTime,
                                  String callBeginTime, String callEndTime, String callNum, String confId) {

        double totalShould = 0.00;
        long totalTime = 0;
        int totalCount = 0;
        List<String> outList = new ArrayList<>();
        /*集团行业网关短信部分*/
        String headString = "移动会议详单内容";


        String title = "会议发起人|会议ID|起始时间|通信方式|会议参与人电话号码|通信时长|套餐优惠|优惠或减免|实收通信费";
        String[] titleFields = title.split("\\|");
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (String titleCell : titleFields) {
            if (i < titleFields.length) {
                sb.append(titleCell).append(String.format("%-8s", " "));
            } else {
                sb.append(titleCell);
            }
            i++;
        }

        String titleString = sb.toString();

        outList.add(headString);
        outList.add(titleString);

        String brandIds = "2310YD"; //对应老的YD
        List<UserInfoEntity> grpMmsUserList = user.getGrpUserInfoByBrand(custId, brandIds);
        for (UserInfoEntity grpUserEnt : grpMmsUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();
            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailMms = detailDisplayer.grpDetail02(grpPhoneNo, serverInfo, dealBeginTime, dealEndTime,
                    callBeginTime, callEndTime, callNum, confId);

            totalShould += grpDetailMms.getTotalShould();
            totalTime += grpDetailMms.getTotalTime();
            totalCount += grpDetailMms.getLineCount();

            outList.addAll(grpDetailMms.getDetailLines());
        }

        String footString = new StringBuilder().append("共计 会议数：[").append(totalCount).append("]条").append(" ")
                .append("会议时长[").append(totalTime).append("]秒").append(" ")
                .append("费用[").append(totalShould).append("]元").toString();

        outList.add(footString);

        return outList;
    }

    private List<String> detail03(long custId, String dealBeginTime, String dealEndTime,
                                  String callBeginTime, String callEndTime) {
        int totalCount = 0;
        List<String> outList = new ArrayList<>();
        String smsHeadString = "集团客户IDC公众服务云详单内容";

        List<String> list01 = this.detail03Dur(custId, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
        List<String> list02 = this.detail03Traffic(custId, dealBeginTime, dealEndTime, callBeginTime, callEndTime);
        List<String> list03 = this.detail03Times(custId, dealBeginTime, dealEndTime, callBeginTime, callEndTime);

        outList.add(smsHeadString);
        outList.addAll(list01);
        outList.addAll(list02);
        outList.addAll(list03);

        totalCount = list01.size() + list02.size() + list03.size() - 6;

        String footString = new StringBuilder().append("共计：[").append(totalCount).append("]条").toString();

        outList.add(footString);

        return outList;
    }

    /*按时长计费*/
    private List<String> detail03Dur(long custId, String dealBeginTime, String dealEndTime,
                                     String callBeginTime, String callEndTime) {

        List<String> outList = new ArrayList<>();
        String smsHeadString = "按时长计费产品：";


        String title = "集团客户编号|订购关系编号|产品编号|产品功能名称|开始时间|结束时间";
        String[] titleFields = title.split("\\|");
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (String titleCell : titleFields) {
            if (i < titleFields.length) {
                sb.append(titleCell).append(String.format("%-8s", " "));
            } else {
                sb.append(titleCell);
            }
            i++;
        }

        String titleString = sb.toString();

        outList.add(smsHeadString);
        outList.add(titleString);

        List<UserInfoEntity> grpSmsUserList = user.getGrpUserInfoByCustId(custId);
        for (UserInfoEntity grpUserEnt : grpSmsUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();
            long grpIdNo = grpUserEnt.getIdNo();

            UsersvcAttrEntity svcAttrInfo = user.getUsersvcAttr(grpIdNo, "23B195"); //获取网关号码
            if (svcAttrInfo == null) { //只获取服务属性为 23B195 的集团用户
                continue;
            }
            String svrCode = svcAttrInfo.getAttrValue(); //行业网关对端号码
            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailSms = detailDisplayer.grpDetail03(grpPhoneNo, "7309", serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, svrCode);

            outList.addAll(grpDetailSms.getDetailLines());

        }

        return outList;
    }

    /*按流量计费*/
    private List<String> detail03Traffic(long custId, String dealBeginTime, String dealEndTime,
                                         String callBeginTime, String callEndTime) {
        List<String> outList = new ArrayList<>();
        String smsHeadString = "按流量计费产品：";


        String title = "集团客户编号|订购关系编号|产品编号|产品功能名称|输入流量|输出流量|费用";
        String[] titleFields = title.split("\\|");
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (String titleCell : titleFields) {
            if (i < titleFields.length) {
                sb.append(titleCell).append(String.format("%-8s", " "));
            } else {
                sb.append(titleCell);
            }
            i++;
        }

        String titleString = sb.toString();

        outList.add(smsHeadString);
        outList.add(titleString);

        List<UserInfoEntity> grpSmsUserList = user.getGrpUserInfoByCustId(custId);
        for (UserInfoEntity grpUserEnt : grpSmsUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();
            long grpIdNo = grpUserEnt.getIdNo();

            UsersvcAttrEntity svcAttrInfo = user.getUsersvcAttr(grpIdNo, "23B195"); //获取网关号码
            if (svcAttrInfo == null) { //只获取服务属性为 23B195 的集团用户
                continue;
            }
            String svrCode = svcAttrInfo.getAttrValue(); //行业网关对端号码
            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailSms = detailDisplayer.grpDetail03(grpPhoneNo, "7310", serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, svrCode);
            outList.addAll(grpDetailSms.getDetailLines());

        }

        return outList;
    }

    /*按次数计费*/
    private List<String> detail03Times(long custId, String dealBeginTime, String dealEndTime,
                                       String callBeginTime, String callEndTime) {
        List<String> outList = new ArrayList<>();
        /*集团行业网关短信部分*/
        String smsHeadString = "按次数计费产品：";


        String title = "集团客户编号|订购关系编号|产品编号|产品功能名称|会话次数";
        String[] titleFields = title.split("\\|");
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (String titleCell : titleFields) {
            if (i < titleFields.length) {
                sb.append(titleCell).append(String.format("%-8s", " "));
            } else {
                sb.append(titleCell);
            }
            i++;
        }

        String titleString = sb.toString();

        outList.add(smsHeadString);
        outList.add(titleString);

        List<UserInfoEntity> grpSmsUserList = user.getGrpUserInfoByCustId(custId);
        for (UserInfoEntity grpUserEnt : grpSmsUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();
            long grpIdNo = grpUserEnt.getIdNo();

            UsersvcAttrEntity svcAttrInfo = user.getUsersvcAttr(grpIdNo, "23B195"); //获取网关号码
            if (svcAttrInfo == null) { //只获取服务属性为 23B195 的集团用户
                continue;
            }
            String svrCode = svcAttrInfo.getAttrValue(); //行业网关对端号码
            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailSms = detailDisplayer.grpDetail03(grpPhoneNo, "7311", serverInfo, dealBeginTime, dealEndTime, callBeginTime, callEndTime, svrCode);

            outList.addAll(grpDetailSms.getDetailLines());

        }

        return outList;
    }

    private List<String> detail04(long custId, String dealBeginTime, String dealEndTime,
                                  String callBeginTime, String callEndTime) {

        double totalShould = 0.00;
        long totalTime = 0;
        int totalCount = 0;
        List<String> outList = new ArrayList<>();
        /*集团行业网关短信部分*/
        String headString = "集团呼叫中心直连详单内容";


        String title = "原始号码|呼叫时间|对端呼叫地|对端归属地|呼叫方式|对端号码|时长(秒)|金额(元)";
        String[] titleFields = title.split("\\|");
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (String titleCell : titleFields) {
            if (i < titleFields.length) {
                sb.append(titleCell).append(String.format("%-8s", " "));
            } else {
                sb.append(titleCell);
            }
            i++;
        }

        String titleString = sb.toString();

        outList.add(headString);
        outList.add(titleString);

        String brandIds = "2310hj"; //对应老的hj
        List<UserInfoEntity> grpMmsUserList = user.getGrpUserInfoByBrand(custId, brandIds);
        for (UserInfoEntity grpUserEnt : grpMmsUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();
            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailMms = detailDisplayer.grpDetail04(grpPhoneNo, serverInfo, dealBeginTime, dealEndTime,
                    callBeginTime, callEndTime);

            totalShould += grpDetailMms.getTotalShould();
            totalCount += grpDetailMms.getLineCount();

            outList.addAll(grpDetailMms.getDetailLines());
        }

        String footString = new StringBuilder().append("共计[").append(totalCount).append("]条").append(" ")
                .append("合计金额：[").append(totalShould).append("]元").toString();

        outList.add(footString);

        return outList;
    }

    private List<String> detail05(long custId, String dealBeginTime, String dealEndTime,
                                  String callBeginTime, String callEndTime) {

        double totalShould = 0.00;
        int totalCount = 0;
        List<String> outList = new ArrayList<>();

        String headString = "集团企业阅读详单内容";
        String title = "计费号码|开始时间|业务名称|金额(元)                                                                 ";
        String[] titleFields = title.split("\\|");
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (String titleCell : titleFields) {
            if (i < titleFields.length) {
                sb.append(titleCell).append(String.format("%-8s", " "));
            } else {
                sb.append(titleCell);
            }
            i++;
        }

        String titleString = sb.toString();

        outList.add(headString);
        outList.add(titleString);

        String brandIds = "2310ER"; //对应老的ER
        List<UserInfoEntity> grpErUserList = user.getGrpUserInfoByBrand(custId, brandIds);
        for (UserInfoEntity grpUserEnt : grpErUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();
            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailMms = detailDisplayer.grpDetail05ER(grpPhoneNo, serverInfo, dealBeginTime, dealEndTime,
                    callBeginTime, callEndTime);

            totalShould += grpDetailMms.getTotalShould();
            totalCount += grpDetailMms.getLineCount();

            outList.addAll(grpDetailMms.getDetailLines());
        }

        headString = "集团企业手机报详单内容";
        outList.add(headString);
        outList.add(titleString);

        brandIds = "2310QY,2310SJ"; //对应老的QY,SJ
        List<UserInfoEntity> grpQyUserList = user.getGrpUserInfoByBrand(custId, brandIds);
        for (UserInfoEntity grpUserEnt : grpQyUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();
            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailMms = detailDisplayer.grpDetail05Sj(grpPhoneNo, serverInfo, dealBeginTime, dealEndTime,
                    callBeginTime, callEndTime);

            totalShould += grpDetailMms.getTotalShould();
            totalCount += grpDetailMms.getLineCount();

            outList.addAll(grpDetailMms.getDetailLines());
        }

        String footString = new StringBuilder().append("共计[").append(totalCount).append("]条").append(" ")
                .append("合计金额：[").append(totalShould).append("]元").toString();

        outList.add(footString);

        return outList;
    }

    private List<String> detail06(long custId, String dealBeginTime, String dealEndTime,
                                  String callBeginTime, String callEndTime) {

        double totalShould = 0.00;
        int totalCount = 0;
        List<String> outList = new ArrayList<>();
        /*集团行业网关短信部分*/
        String headString = "集团企业彩漫详单内容";


        String title = "计费号码|开始时间|业务名称|金额(元)";
        String[] titleFields = title.split("\\|");
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (String titleCell : titleFields) {
            if (i < titleFields.length) {
                sb.append(titleCell).append(String.format("%-8s", " "));
            } else {
                sb.append(titleCell);
            }
            i++;
        }

        String titleString = sb.toString();

        outList.add(headString);
        outList.add(titleString);

        String brandIds = "2310QC"; //对应老的QC
        List<UserInfoEntity> grpMmsUserList = user.getGrpUserInfoByBrand(custId, brandIds);
        for (UserInfoEntity grpUserEnt : grpMmsUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();
            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailMms = detailDisplayer.grpDetail06(grpPhoneNo, serverInfo, dealBeginTime, dealEndTime,
                    callBeginTime, callEndTime);

            totalShould += grpDetailMms.getTotalShould();
            totalCount += grpDetailMms.getLineCount();

            outList.addAll(grpDetailMms.getDetailLines());
        }

        String footString = new StringBuilder().append("共计[").append(totalCount).append("]条").append(" ")
                .append("合计金额：[").append(totalShould).append("]元").toString();

        outList.add(footString);

        return outList;
    }

    private List<String> detail07(long custId, String dealBeginTime, String dealEndTime,
                                  String callBeginTime, String callEndTime) {

        double totalShould = 0.00;
        int totalCount = 0;
        List<String> outList = new ArrayList<>();
        /*集团行业网关短信部分*/
        String headString = "集团云视频会议详单内容";


        String title = "计费号码|开始时间|结束时间|通话时长|并发人数|业务名称|金额(元)";
        String[] titleFields = title.split("\\|");
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (String titleCell : titleFields) {
            if (i < titleFields.length) {
                sb.append(titleCell).append(String.format("%-8s", " "));
            } else {
                sb.append(titleCell);
            }
            i++;
        }

        String titleString = sb.toString();

        outList.add(headString);
        outList.add(titleString);

        String brandIds = "2310SH"; //对应老的SH
        List<UserInfoEntity> grpMmsUserList = user.getGrpUserInfoByBrand(custId, brandIds);
        for (UserInfoEntity grpUserEnt : grpMmsUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();
            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailMms = detailDisplayer.grpDetail07(grpPhoneNo, serverInfo, dealBeginTime, dealEndTime,
                    callBeginTime, callEndTime);

            totalShould += grpDetailMms.getTotalShould();
            totalCount += grpDetailMms.getLineCount();

            outList.addAll(grpDetailMms.getDetailLines());
        }

        String footString = new StringBuilder().append("共计[").append(totalCount).append("]条").append(" ")
                .append("合计金额：[").append(totalShould).append("]元").toString();

        outList.add(footString);

        return outList;
    }

    private List<String> detail08(long custId, String dealBeginTime, String dealEndTime,
                                  String callBeginTime, String callEndTime) {

        double totalShould = 0.00;
        int totalCount = 0;
        List<String> outList = new ArrayList<>();
        /*集团行业网关短信部分*/
        String headString = "集团企业智运会详单内容";


        String title = "计费号码|开始时间|业务名称|金额(元)";
        String[] titleFields = title.split("\\|");
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (String titleCell : titleFields) {
            if (i < titleFields.length) {
                sb.append(titleCell).append(String.format("%-8s", " "));
            } else {
                sb.append(titleCell);
            }
            i++;
        }

        String titleString = sb.toString();

        outList.add(headString);
        outList.add(titleString);

        String brandIds = "2310QZ"; //对应老的QZ
        List<UserInfoEntity> grpMmsUserList = user.getGrpUserInfoByBrand(custId, brandIds);
        for (UserInfoEntity grpUserEnt : grpMmsUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();
            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailMms = detailDisplayer.grpDetail08(grpPhoneNo, serverInfo, dealBeginTime, dealEndTime,
                    callBeginTime, callEndTime);

            totalShould += grpDetailMms.getTotalShould();
            totalCount += grpDetailMms.getLineCount();

            outList.addAll(grpDetailMms.getDetailLines());
        }

        String footString = new StringBuilder().append("共计[").append(totalCount).append("]条").append(" ")
                .append("合计金额：[").append(totalShould).append("]元").toString();

        outList.add(footString);

        return outList;
    }

    private List<String> detail09(long custId, String dealBeginTime, String dealEndTime,
                                  String callBeginTime, String callEndTime) {

        double totalShould = 0.00;
        int totalCount = 0;
        List<String> outList = new ArrayList<>();
        /*集团行业网关短信部分*/
        String headString = "集团企业互联网电视详单内容";


        String title = "计费号码|开始时间|业务名称|金额(元)";
        String[] titleFields = title.split("\\|");
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (String titleCell : titleFields) {
            if (i < titleFields.length) {
                sb.append(titleCell).append(String.format("%-8s", " "));
            } else {
                sb.append(titleCell);
            }
            i++;
        }

        String titleString = sb.toString();

        outList.add(headString);
        outList.add(titleString);

        String brandIds = "2310DS"; //对应老的DS
        List<UserInfoEntity> grpMmsUserList = user.getGrpUserInfoByBrand(custId, brandIds);
        for (UserInfoEntity grpUserEnt : grpMmsUserList) {
            String grpPhoneNo = grpUserEnt.getPhoneNo();

            ServerInfo serverInfo = control.getPhoneRouteConf(grpPhoneNo.substring(0, 7), "DETAILQRY");
            GrpDetailEntity grpDetailMms = detailDisplayer.grpDetail09(grpPhoneNo, serverInfo, dealBeginTime, dealEndTime,
                    callBeginTime, callEndTime);

            totalShould += grpDetailMms.getTotalShould();
            totalCount += grpDetailMms.getLineCount();

            outList.addAll(grpDetailMms.getDetailLines());
        }

        String footString = new StringBuilder().append("共计[").append(totalCount).append("]条").append(" ")
                .append("合计金额：[").append(totalShould).append("]元").toString();

        outList.add(footString);

        return outList;
    }

    private void saveQueryOprLog(long custId, String loginNo, String loginGroupId, String opCode, String queryType, String provinceId) {
        ActQueryOprEntity oprEntity = new ActQueryOprEntity();
        if (StringUtils.isNotEmpty(loginNo) && StringUtils.isEmptyOrNull(loginGroupId)) {
            LoginEntity loginInfo = login.getLoginInfo(loginNo, provinceId);
            loginGroupId = loginInfo.getGroupId();
        }
        oprEntity.setQueryType(queryType);
        oprEntity.setOpCode(opCode);
        oprEntity.setContactId("");
        oprEntity.setIdNo(custId);
        oprEntity.setPhoneNo("");
        oprEntity.setBrandId("");
        oprEntity.setLoginNo(loginNo);
        oprEntity.setLoginGroup(loginGroupId);
        oprEntity.setProvinceId(provinceId);

        oprEntity.setRemark("集团客户详单查询");
        record.saveQueryOpr(oprEntity, false);
    }

    public IDetailDisplayer getDetailDisplayer() {
        return detailDisplayer;
    }

    public void setDetailDisplayer(IDetailDisplayer detailDisplayer) {
        this.detailDisplayer = detailDisplayer;
    }

    public IUser getUser() {
        return user;
    }

    public void setUser(IUser user) {
        this.user = user;
    }

    public IProd getProd() {
        return prod;
    }

    public void setProd(IProd prod) {
        this.prod = prod;
    }

    public ICust getCust() {
        return cust;
    }

    public void setCust(ICust cust) {
        this.cust = cust;
    }

    public CacheOpr getCacheOpr() {
        return cacheOpr;
    }

    public void setCacheOpr(CacheOpr cacheOpr) {
        this.cacheOpr = cacheOpr;
    }

    public IRecord getRecord() {
        return record;
    }

    public void setRecord(IRecord record) {
        this.record = record;
    }

    public ILogin getLogin() {
        return login;
    }

    public void setLogin(ILogin login) {
        this.login = login;
    }

    public IControl getControl() {
        return control;
    }

    public void setControl(IControl control) {
        this.control = control;
    }
}
