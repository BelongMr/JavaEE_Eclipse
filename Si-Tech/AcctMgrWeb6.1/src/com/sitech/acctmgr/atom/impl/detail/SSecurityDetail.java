package com.sitech.acctmgr.atom.impl.detail;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.bill.DetailEnterEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.detail.ChannelDetail;
import com.sitech.acctmgr.atom.domains.detail.DynamicTable;
import com.sitech.acctmgr.atom.domains.detail.ElementAttribute;
import com.sitech.acctmgr.atom.domains.detail.QueryTypeEntity;
import com.sitech.acctmgr.atom.domains.record.ActQueryOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.detail.SSecurityDetailQueryInDTO;
import com.sitech.acctmgr.atom.dto.detail.SSecurityDetailQueryOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.atom.entity.inter.IDetailDisplayer;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.inter.detail.ISecurityDetail;
import com.sitech.acctmgr.net.ServerInfo;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
 * Created by wangyla on 2016/11/10.
 */
@ParamTypes({@ParamType(c = SSecurityDetailQueryInDTO.class, m = "query", oc = SSecurityDetailQueryOutDTO.class)})
public class SSecurityDetail extends AcctMgrBaseService implements ISecurityDetail {

    private IUser user;
    private ICust cust;
    private IControl control;
    private IDetailDisplayer detailDisplayer;
    private ILogin login;
    private IRecord record;

    @Override
    public OutDTO query(InDTO inParam) {

        SSecurityDetailQueryInDTO inDTO = (SSecurityDetailQueryInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        String phoneNo = inDTO.getPhoneNo();
        String queryFlag = inDTO.getQueryFlag();
        int queryYm = inDTO.getYearMonth();
        String beginDate = inDTO.getBegintime();
        String endDate = inDTO.getEndtime();


        UserInfoEntity userInfo = user.getUserEntityByPhoneNo(phoneNo, true);
        long custId = userInfo.getCustId();
        long idNo = userInfo.getIdNo();

        DetailEnterEntity dee = record.getDetailEnterInfo(idNo);
        if (dee == null) {
            throw new BusiException(AcctMgrError.getErrorCode("8121","20001"), "还没有对该用户进行信息录入,请先录入");
        }

        if (dee.getLoginNo().equals(inDTO.getLoginNo())) {
            throw new BusiException(AcctMgrError.getErrorCode("8121","20002"), "录入和查询不能为同一工号");
        }


        Map<String, String> timeMap = this.getQueryTimes(userInfo.getIdNo(), queryFlag, queryYm, beginDate, endDate);
        String dealBeginTime = timeMap.get("DEAL_BEGIN_TIME"); //话单处理开始时间
        String dealEndTime = timeMap.get("DEAL_END_TIME"); //话单处理结束时间
        String callBeginTime = timeMap.get("CALL_BEGIN_TIME"); //通话开始时间
        String callEndTime = timeMap.get("CALL_END_TIME"); //通话结束时间

        log.debug("queryTimes:[" +  dealBeginTime + "/" + dealEndTime + "," + callBeginTime + "," + callEndTime);

        long loginAccept = control.getSequence("SEQ_SYSTEM_SN");
        /*获取表头基础信息*/
        List<String> baseInfoList = this.getDetailHeadInfo(phoneNo, custId, dealBeginTime, dealEndTime, queryFlag, inDTO.getLoginNo(), loginAccept);

        List<QueryTypeEntity> etcList = detailDisplayer.getDetailTypeList(inDTO.getQueryType());
        List<ChannelDetail> detailList = new ArrayList<>();

        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");
        for (QueryTypeEntity etc : etcList) {
            String detailCode = etc.getQueryType();

            ChannelDetail detailInfo = new ChannelDetail();
            detailInfo.setQueryType(inDTO.getQueryType());
            detailInfo.setTitleInfo(this.getDetailTitleInfo(detailCode));

            List<String> detailLines = null;

            detailLines = detailDisplayer.securityDetail(phoneNo, detailCode, serverInfo, dealBeginTime, dealEndTime,
                    callBeginTime, callEndTime);


            detailInfo.setDetailLines(detailLines);
            detailList.add(detailInfo);

        }

        List<DynamicTable> tables = new ArrayList<>();
        DynamicTable detailTable = this.getDetailInfo(detailList, baseInfoList, inDTO.getQueryType());
        tables.add(detailTable);

        /*更新查询的安保用户的信息*/
        record.updateDetailEnterInfo(userInfo.getIdNo());

        /*记录详单的查询日志*/
        this.saveQueryOprLog(phoneNo, userInfo.getIdNo(), inDTO.getLoginNo(), inDTO.getGroupId(),
                inDTO.getOpCode(), inDTO.getQueryType(), inDTO.getProvinceId());

        SSecurityDetailQueryOutDTO outDTO = new SSecurityDetailQueryOutDTO();
        outDTO.setTables(tables);

        log.debug("outDto = " + outDTO.toJson());
        return outDTO;
    }

    private List<String> getDetailHeadInfo(String phoneNo, long custId, String dealBegTime, String dealEndTime, String queryFlag,
                                           String loginNo, long loginAccept) {
        List<String> headList = new ArrayList<>();

        CustInfoEntity custInfo = cust.getCustInfo(custId, null);
        headList.add(String.format("手机号码:[%s]", phoneNo));
        headList.add(String.format("用户姓名:[%s]", custInfo.getBlurCustName()));
        headList.add(String.format("%s:[%s]", custInfo.getIdTypeName(), custInfo.getIdIccid()));
        headList.add(String.format("用户地址:[%s]", custInfo.getCustAddress().trim()));
        headList.add(String.format("联系电话:[%s]", custInfo.getEmTel()));


        String headInfo = "";
        String titleName = "";
        String yearBeg = dealBegTime.substring(0, 4);
        String monthBeg = dealBegTime.substring(4, 6);
        String dayBeg = dealBegTime.substring(6, 8);
        String yearEnd = dealEndTime.substring(0, 4);
        String monthEnd = dealEndTime.substring(4, 6);
        String dayEnd = dealEndTime.substring(6, 8);
        String queryYm = dealBegTime.substring(0, 6);
        if (queryFlag.equals("0")) { //按时间段查询
            headInfo = String.format("%20s黑龙江省%-15s%s%10s通话时间%4s年%2s月%2s日--%4s年%2s月%2s日",
                    " ", phoneNo, titleName, " ", yearBeg, monthBeg, dayBeg, yearEnd, monthEnd, dayEnd);

        } else if (queryFlag.equals("1")) { //按帐务月查询
            headInfo = String.format("%20s黑龙江省%-15s%s%10s结帐月份%2s",
                    " ", phoneNo, titleName, " ", queryYm);
        }

        if (!headInfo.isEmpty()) {
            headList.add(headInfo);
        }

        String printDate = String.format("%06d", DateUtils.getCurDay());
        headInfo = String.format("工号:%s       流水号:%s     打印时间：%s", loginNo, loginAccept, printDate);
        headList.add(headInfo);

        return headList;
    }

    /**
     * 获取详单查询时请求的处理时间及通话时间
     *
     * @param queryFlag
     * @param yearMonth
     * @param beginTime
     * @param endTime
     * @return
     */
    private Map<String, String> getQueryTimes(Long idNo, String queryFlag, Integer yearMonth, String beginTime, String endTime) {
        Map<String, String> timeMap = new HashMap<>();
        String dealBeginTime = ""; //话单处理开始时间
        String dealEndTime = ""; //话单处理结束时间
        String callBeginTime = ""; //通话开始时间
        String callEndTime = ""; //通话结束时间

        /**
         * 按帐期查询时，通话开始时间提前25天（可能会变）
         * 按时间段查询时，处理结束时间推迟25天（可能会变）, 由CommonConst.DETAIL_QUERY_ADD_DAYS 变量表示
         *
         */
        if (queryFlag.equals("0")) { //按时间段查询

            int endYmd = Integer.parseInt(endTime.substring(0, 8));

            if (beginTime.length() == 8 && endTime.length() == 8) { //yyyyMMdd

                dealBeginTime = String.format("%s000000", beginTime.substring(0, 8));
                dealEndTime = String.format("%s235959", DateUtils.addDays(endYmd, CommonConst.DETAIL_QUERY_ADD_DAYS));

                callBeginTime = String.format("%s000000", beginTime);
                callEndTime = String.format("%s235959", endTime);
            } else if (beginTime.length() > 8 && endTime.length() > 8) { //yyyyMmddHHMiss

                dealBeginTime = String.format("%s", beginTime);
                dealEndTime = String.format("%s%s", DateUtils.addDays(endYmd, CommonConst.DETAIL_QUERY_ADD_DAYS),
                        endTime.substring(8, 14));

                callBeginTime = String.format("%s", beginTime);
                callEndTime = String.format("%s", endTime);
            }

            int endYm = Integer.parseInt(endTime.substring(0, 6));
            if (endTime.substring(0, 6).equals(dealEndTime.substring(0, 6))) {
                dealEndTime = String.format("%s%2d235959", endTime.substring(0, 6), DateUtils.getLastDayOfMonth(endYm));
            }

        } else if (queryFlag.equals("1")) { //按帐期查询
            int beginDate = yearMonth * 100 + 1;
            int endDate = yearMonth * 100 + DateUtils.getLastDayOfMonth(yearMonth);

            dealBeginTime = String.format("%d000000", beginDate);
            dealEndTime = String.format("%d235959", endDate);

            callBeginTime = String.format("%d000000", DateUtils.addDays(beginDate, -1 * CommonConst.DETAIL_QUERY_ADD_DAYS));
            callEndTime = String.format("%d235959", endDate);
        }


        safeAddToMap(timeMap, "DEAL_BEGIN_TIME", dealBeginTime);
        safeAddToMap(timeMap, "DEAL_END_TIME", dealEndTime);
        safeAddToMap(timeMap, "CALL_BEGIN_TIME", callBeginTime);
        safeAddToMap(timeMap, "CALL_END_TIME", callEndTime);

        return timeMap;
    }

    private String getDetailTitleInfo(String detailCode) {
        String titleInfo = "";
        if (detailCode.equals("1501")) {

            titleInfo = String.format("%-15s%-15s%-20s%-20s%-10s%-15s%-10s%-10s%-15s%-15s%-15s",
                    "主叫号", "被叫号", "IMEI码", "通话时间", "通话时长", "交换机号",
                    "小区号码(LAC码)", "基站号", "类型", "通话地点", "网络");

        } else if (detailCode.equals("1507")) {
            titleInfo = String.format("%-15s%-15s%-15s%-20s%-20s%-10s%-15s%-10s%-10s%-15s%-15s%-15s",
                    "主叫号", "被叫号", "被叫呼转号", "IMEI码", "通话时间", "通话时长", "交换机号",
                    "小区号码(LAC码)", "基站号", "类型", "通话地点", "网络");
        } else { //1503, 1504, 1505, 1506 短信

            titleInfo = String.format("%-15s %-15s %-22s", "发送", "接收", "发送时间");

        }

        return titleInfo;
    }

    private DynamicTable getDetailInfo(List<ChannelDetail> detailList, List<String> baseInfoList, String queryType) {
        DynamicTable detailTable = new DynamicTable();
        detailTable.setElementCol("2");
        detailTable.setElementLabelType("2");
        detailTable.setElementPaging(true);
        List<ElementAttribute> body = new ArrayList<>();
        List<ElementAttribute> baseBody = new ArrayList<>();

        ElementAttribute head = new ElementAttribute();
        head.setDefaultValue("中国移动通信客户" + this.getDetailTypeName(queryType) + "详单");
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

        int rows = 1;
        for (String line : baseInfoList) {
            ElementAttribute cell = new ElementAttribute();
            cell.setDefaultValue(line.replace(" ", "&nbsp;"));
            cell.setElementId("raw_base_line_" + rows);
            cell.setElementName("raw_base_line_" + rows);
            cell.setElementType("24"); //文本显示
            cell.setElementTdType("TD");
            cell.setElementTdAttr("style=\"text-align:left!important;\"");
            baseBody.add(cell);

            spaceCell = new ElementAttribute();
            spaceCell.setDefaultValue("");
            spaceCell.setElementId("base_space_cell");
            spaceCell.setElementName("base_space_cell_name");
            spaceCell.setElementType("24"); //文本显示
            spaceCell.setElementTdType("TD");
            baseBody.add(spaceCell);

            rows++;
        }
        body.addAll(baseBody);

        List<ElementAttribute> detailBody = new ArrayList<>();
        for (ChannelDetail channelDetail : detailList) {
            List<String> detailLines = channelDetail.getDetailLines();
            String titleInfo = channelDetail.getTitleInfo();

            ElementAttribute title = new ElementAttribute();
            title.setDefaultValue(titleInfo.replace(" ", "&nbsp;"));
            title.setElementId("raw_title_id");
            title.setElementName("raw_title_name");
            title.setElementType("24"); //文本显示
            title.setElementTdType("TH");
            title.setElementTdAttr("style=\"text-align:left !important; white-space:nowrap;\"");
            detailBody.add(title);

            spaceCell = new ElementAttribute();
            spaceCell.setDefaultValue("");
            spaceCell.setElementId("detail_space_cell");
            spaceCell.setElementName("detail_space_cell_name");
            spaceCell.setElementType("24"); //文本显示
            spaceCell.setElementTdType("TH");
            detailBody.add(spaceCell);

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
        }

        body.addAll(detailBody);
        detailTable.setElementAttrList(body);

        return detailTable;
    }

    /**
     * @param queryType 详单查询类型名称
     * @return
     */
    private String getDetailTypeName(String queryType) {
        Map<String, String> typeMap = new HashMap<>();
        safeAddToMap(typeMap, "25", "全部");
        safeAddToMap(typeMap, "1501", "普通语音话单");
        safeAddToMap(typeMap, "1503", "普通点对点短信话单");
        safeAddToMap(typeMap, "1504", "互通短信话单");
        safeAddToMap(typeMap, "1505", "国际点对点短信");
        safeAddToMap(typeMap, "1506", "梦网短信");
        safeAddToMap(typeMap, "1507", "呼转语音话单");
        return typeMap.get(queryType);
    }

    private void saveQueryOprLog(String phoneNo, long idNo, String loginNo, String loginGroupId, String opCode, String queryType, String provinceId) {
        ActQueryOprEntity oprEntity = new ActQueryOprEntity();
        if (StringUtils.isNotEmpty(loginNo) && StringUtils.isEmptyOrNull(loginGroupId)) {
            LoginEntity loginInfo = login.getLoginInfo(loginNo, provinceId);
            loginGroupId = loginInfo.getGroupId();
        }
        oprEntity.setQueryType("0");
        oprEntity.setOpCode(opCode);
        oprEntity.setContactId("");
        oprEntity.setIdNo(idNo);
        oprEntity.setPhoneNo(phoneNo);
        oprEntity.setBrandId("");
        oprEntity.setLoginNo(loginNo);
        oprEntity.setLoginGroup(loginGroupId);
        oprEntity.setProvinceId(provinceId);

        StringBuilder stringbuf = new StringBuilder();
        stringbuf.append("安保部详单查询，工号:");
        stringbuf.append(loginNo);
        stringbuf.append(", 用户[");
        stringbuf.append(phoneNo);
        stringbuf.append("]，类型[" + this.getDetailTypeName(queryType) + "]");
        oprEntity.setRemark(stringbuf.toString());

        record.saveQueryOpr(oprEntity, false);
    }
    
    public IUser getUser() {
        return user;
    }

    public void setUser(IUser user) {
        this.user = user;
    }

    public ICust getCust() {
        return cust;
    }

    public void setCust(ICust cust) {
        this.cust = cust;
    }

    public IControl getControl() {
        return control;
    }

    public void setControl(IControl control) {
        this.control = control;
    }

    public IDetailDisplayer getDetailDisplayer() {
        return detailDisplayer;
    }

    public void setDetailDisplayer(IDetailDisplayer detailDisplayer) {
        this.detailDisplayer = detailDisplayer;
    }

    public ILogin getLogin() {
        return login;
    }

    public void setLogin(ILogin login) {
        this.login = login;
    }

    public IRecord getRecord() {
        return record;
    }

    public void setRecord(IRecord record) {
        this.record = record;
    }

}