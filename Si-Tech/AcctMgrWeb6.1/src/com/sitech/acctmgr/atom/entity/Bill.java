package com.sitech.acctmgr.atom.entity;

import com.sitech.acctmgr.atom.domains.account.ContractEntity;
import com.sitech.acctmgr.atom.domains.balance.BalanceEntity;
import com.sitech.acctmgr.atom.domains.balance.UnbillPreEntity;
import com.sitech.acctmgr.atom.domains.balance.UnbillVmEntity;
import com.sitech.acctmgr.atom.domains.bill.*;
import com.sitech.acctmgr.atom.domains.collection.CollOweStatusGroupEntity;
import com.sitech.acctmgr.atom.domains.collection.CollectionBillEntity;
import com.sitech.acctmgr.atom.domains.fee.OweFeeEntity;
import com.sitech.acctmgr.atom.domains.pub.PubWrtoffCtrlEntity;
import com.sitech.acctmgr.atom.domains.query.BillTotCodeEntity;
import com.sitech.acctmgr.atom.domains.query.PrcIdTransEntity;
import com.sitech.acctmgr.atom.domains.record.ActQueryOprEntity;
import com.sitech.acctmgr.atom.domains.user.*;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.BigDecimalUtils;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgr.net.*;
import com.sitech.acctmgr.net.bill.UnBillResponseHeader;
import com.sitech.acctmgr.net.impl.UnBillResponseData;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.util.DateUtil;

import java.util.*;

import static com.sitech.acctmgr.common.constant.CommonConst.BATCHWRTOFF_BILL_DAY;
import static org.apache.commons.collections.MapUtils.*;

/**
 * <p>
 * Title: 账单类原子实体
 * </p>
 * <p>
 * Description: 有关账单类核心原子业务
 * </p>
 * <p>
 * Copyright: Copyright (c) 2014
 * </p>
 * <p>
 * Company: SI-TECH
 * </p>
 *
 * @version 1.0
 */
public class Bill extends BaseBusi implements IBill {

    private IControl control;
    private IBalance balance;
    private IAccount account;
    private IUser user;
    private IGroup group;
    private IRecord record;
    private IDelay delay;
    private IProd prod;
    private IBillAccount billAccount;

    /**
	 * 功能：获取未出帐明细信息（与帐处交互的最原始接口）
	 *
	 * @param conNo
	 * @param idNo
	 * @param qryType
	 *            0：虚拟销帐结果查询；<br>
	 *            1：余额帐本列表查询；<br>
	 *            20：综合帐单查询；21:按明细返回；<br>
	 *            30：明细帐单查询;31：按账目项合并
	 * @return
	 */
    private List<String> getUnbillDetailList(Long conNo, Long idNo, String qryType, String ip, int port) {

		// S1: 获取路由信息，得到 ServerInfo

        List<String> respBody = new ArrayList<>();
        if (true) {
            String idNoTmp = String.format("%d", (idNo == null) ? 0 : idNo);
            String conNoTmp = String.format("%d", (conNo == null) ? 0 : conNo);

            ClientFactory factory = ClientFactory.getInstance();
            Client client = factory.getClient("unbill");
            client.getServerProxy().setServerInfo(ip, port);
            client.setRequestArgs(idNoTmp, conNoTmp, qryType);
            ResponseData respData = client.getResponseData();

            if (respData != null) {
                try {
                    respData.parse();
                } catch (ParseDataException pe) {
                    log.error(pe.getMessage());
					throw new BusiException(AcctMgrError.getErrorCode("0000", "50002"), "服务端返回数据错误，请检查!");
                }
            }

            UnBillResponseData unbillRespData = null;

            if (respData instanceof UnBillResponseData) {
                unbillRespData = (UnBillResponseData) respData;
            }

            if (unbillRespData != null) {
                UnBillResponseHeader respHeader = unbillRespData.getRespHeader();
                if (respHeader.getStatus().equals("0")) {
                    respBody = unbillRespData.getRespBody();
                }
            } else {
				log.error("获取未出帐信息失败，为了不影响营业，按空list返回...");
            }
        }

        if (false) {
            respBody = this.testUnbill(conNo, idNo, qryType);
        }

        return respBody;
    }

    private List<String> testUnbill(Long conNo, Long idNo, String qryType) {
        List<String> outList = new ArrayList<>();

        if (qryType.equals(CommonConst.UNBILL_TYPE_BILL_TOT)) {
            StringBuilder sb = new StringBuilder();
            sb.append(conNo).append("|")
                    .append(idNo).append("|")
                    .append("13804510735").append("|")
                    .append("201703").append("|")
                    .append("20170301").append("|")
                    .append("20170331").append("|")
                    .append("3000").append("|")
                    .append("0").append("|")
                    .append("0").append("|");
            //outList.add(sb.toString());
        }

        if (qryType.equals(CommonConst.UNBILL_TYPE_BILL_DET)) {
            StringBuilder sb = new StringBuilder();

            sb.append(idNo).append("|")
                    .append(conNo).append("|")
                    .append("XX30000x19").append("|")
                    .append("0").append("|")
                    .append("201703").append("|")
                    .append("0").append("|")
                    .append("20170301").append("|")
                    .append("20170331").append("|")
                    .append("M026133").append("|")
                    .append("300").append("|")
                    .append("0").append("|")
                    .append("0").append("|")
                    .append("3").append("|")
                    .append("0").append("|")
                    .append("0.0").append("|")
                    .append("0").append("|");
            //outList.add(sb.toString());
        }

        if (qryType.equals(CommonConst.UNBILL_TYPE_VM)) {
            StringBuilder sb = new StringBuilder();

            sb.append(conNo).append("|")
                    .append(idNo).append("|")
                    .append("13888888888").append("|")
                    .append("1111111").append("|")
                    .append("0").append("|")
                    .append("1").append("|")
                    .append("0").append("|")
                    .append("0").append("|")
                    .append("XX30000x19").append("|")
                    .append("0").append("|")
                    .append("0").append("|");
            outList.add(sb.toString());
        }

        if (qryType.equals(CommonConst.UNBILL_TYPE_PRE)) {

        }

        return outList;
    }

    @Override
    public List<UnbillTotEntity> getUnbillBillTotList(Long conNo, Long idNo) {
        ServerInfo si = control.getIdRouteConf(CommonConst.UNBILL_TYPE_BILL_TOT, conNo, "BILLQRY");
        String ip = si.getIp();
        int port = si.getPort();

        List<String> totBillList = this.getUnbillDetailList(conNo, idNo, CommonConst.UNBILL_TYPE_BILL_TOT, ip, port);
        List<UnbillTotEntity> outList = new ArrayList<>();

        for (String unbillLine : totBillList) {

            String[] fields = StringUtils.split(unbillLine, "\\|");
            UnbillTotEntity totEnt = new UnbillTotEntity();
            totEnt.setConNo(Long.parseLong(fields[0]));
            totEnt.setIdNo(Long.parseLong(fields[1]));
            totEnt.setPhoneNo(fields[2]);
            totEnt.setBillCycle(Integer.parseInt(fields[3]));
            totEnt.setBillBegin(Integer.parseInt(fields[4].substring(0, 8)));
            totEnt.setBillEnd(Integer.parseInt(fields[5].substring(0, 8)));
            totEnt.setShouldPay(Double.valueOf(fields[6]).longValue());
            totEnt.setFavourFee(Double.valueOf(fields[7]).longValue());
            totEnt.setPayedPrepay(Double.valueOf(fields[8]).longValue());

            outList.add(totEnt);
        }

        return outList;
    }

    @Override
    public List<UnbillDetEntity> getUnbillBillDetList(Long conNo, Long idNo) {
        ServerInfo si = control.getIdRouteConf(CommonConst.UNBILL_TYPE_BILL_DET, conNo, "BILLQRY");
        String ip = si.getIp();
        int port = si.getPort();
        List<String> detBillList = this.getUnbillDetailList(conNo, idNo, CommonConst.UNBILL_TYPE_BILL_DET, ip, port);
        List<UnbillDetEntity> outList = new ArrayList<>();

        Map<String, Double> rateMap = new HashMap<>();
        for (String unbillLine : detBillList) {

            String[] fields = StringUtils.split(unbillLine, "\\|");
            String acctItemCode = fields[2].trim();
            long shouldPay = Double.valueOf(fields[9]).longValue();
            long favourFee = Double.valueOf(fields[10]).longValue();

            UnbillDetEntity detEnt = new UnbillDetEntity();
            detEnt.setIdNo(Long.parseLong(fields[0]));
            detEnt.setConNo(Long.parseLong(fields[1]));
            detEnt.setAcctItemCode(fields[2]);
            detEnt.setBillType(fields[3]);
            detEnt.setBillCycle(Integer.parseInt(fields[4]));
            detEnt.setCycleType(fields[5]);
            detEnt.setBillBegin(Integer.parseInt(fields[6].substring(0, 8)));
            detEnt.setBillEnd(Integer.parseInt(fields[7].substring(0, 8)));
            detEnt.setProdPrcId(fields[8]);
            detEnt.setShouldPay(shouldPay);
            detEnt.setFavourFee(favourFee);
            detEnt.setPayedPrepay(Double.valueOf(fields[11]).longValue());
            detEnt.setCallTimes(Integer.parseInt(fields[12]));
            detEnt.setDuration(Long.parseLong(fields[13]));
            double taxRate = 0.00;
            if (rateMap.containsKey(acctItemCode)) {
                taxRate = rateMap.get(acctItemCode);
            } else {
                BillItemEntity itemEnt = this.getItemConf(acctItemCode);
                taxRate = (itemEnt != null) ? itemEnt.getNewTaxRate() : 0.00;
                rateMap.put(acctItemCode, taxRate);
            }
            detEnt.setTaxRate(taxRate);
            long exTax = Math.round((shouldPay - favourFee) * 100 / (1 + taxRate));
            long taxFee = (shouldPay - favourFee) * 100 - exTax;
            detEnt.setTaxFee(taxFee); //分后两位

            outList.add(detEnt);
        }
        return outList;
    }


    @Override
    public List<UnbillVmEntity> getUnbillVMList(Long conNo, Long idNo) {

        ServerInfo si = control.getIdRouteConf(CommonConst.UNBILL_TYPE_VM, conNo, "BILLQRY");
        String ip = si.getIp();
        int port = si.getPort();

        List<String> vmList = this.getUnbillDetailList(conNo, idNo, CommonConst.UNBILL_TYPE_VM, ip, port);
        List<UnbillVmEntity> outList = new ArrayList<>();

        for (String unbillLine : vmList) {

            String[] fields = StringUtils.split(unbillLine, "\\|");
            UnbillVmEntity vmEntity = new UnbillVmEntity();
            vmEntity.setConNo(Long.parseLong(fields[0]));
            vmEntity.setIdNo(Long.parseLong(fields[1]));
            vmEntity.setPhoneNo(fields[2]);
            vmEntity.setBalanceId(Long.parseLong(fields[3]));
            vmEntity.setPayType(fields[4]);
            vmEntity.setSpecialFlag(fields[5]);
            vmEntity.setCurBalance(Long.parseLong(fields[6]));
            vmEntity.setWrtoffFee(Double.valueOf(fields[7]).longValue());
            vmEntity.setAcctItemCode(fields[8]);
            vmEntity.setShouldPay(Double.valueOf(fields[9]).longValue());
            vmEntity.setFavourFee(Double.valueOf(fields[10]).longValue());

            outList.add(vmEntity);
        }

        return outList;
    }

    @Override
    public List<UnbillPreEntity> getUnbillPreList(Long conNo, Long idNo) {
        ServerInfo si = control.getIdRouteConf(CommonConst.UNBILL_TYPE_PRE, conNo, "BILLQRY");
        String ip = si.getIp();
        int port = si.getPort();

        List<String> vmList = this.getUnbillDetailList(conNo, idNo, CommonConst.UNBILL_TYPE_PRE, ip, port);
        List<UnbillPreEntity> outList = new ArrayList<>();

        for (String unbillLine : vmList) {

            String[] fields = StringUtils.split(unbillLine, "\\|");
            UnbillPreEntity preEntity = new UnbillPreEntity();
            preEntity.setConNo(Long.parseLong(fields[0]));
            preEntity.setBalanceId(Long.parseLong(fields[1]));
            preEntity.setPayType(fields[2]);
            preEntity.setInitBalance(Double.valueOf(fields[3]).longValue());
            preEntity.setCurBalance(Double.valueOf(fields[4]).longValue());
            preEntity.setWrtoffBalance(Double.valueOf(fields[5]).longValue());
            preEntity.setBeginTime(fields[6]);
            preEntity.setEndTime(fields[7]);

            outList.add(preEntity);
        }

        return outList;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<BillEntity> getCycleDeadOwe(long idNo, long contractNo, String status) {
        Map<String, Object> inMap = new HashMap<String, Object>();

        inMap.put("ID_NO", idNo);
        if (contractNo > 0) {
            inMap.put("CONTRACT_NO", contractNo);
        }

        if (StringUtils.isEmptyOrNull(status)) {
            // inMap.put("SUFFIX", "'1','4'");
            inMap.put("SUFFIX", new String[]{"1", "4"});
        } else {
            // inMap.put("SUFFIX", status);
            inMap.put("SUFFIX", new String[]{status});
        }

        List<BillEntity> resultList = (List<BillEntity>) baseDao.queryForList("act_deadowe_info.qDeadOweInfo", inMap);

        return resultList;
    }


    @SuppressWarnings("unchecked")
    @Override
    public List<BillEntity> getNotCycleDeadOwe(long idNo, long contractNo, String status) {
        Map<String, Object> inMap = new HashMap<String, Object>();

        inMap.put("ID_NO", idNo);
        if (contractNo > 0) {
            inMap.put("CONTRACT_NO", contractNo);
        }

        if (StringUtils.isEmptyOrNull(status)) {
            // inMap.put("SUFFIX", "'1','4'");
            inMap.put("SUFFIX", new String[]{"1", "4"});
        } else {
            // inMap.put("SUFFIX", status);
            inMap.put("SUFFIX", new String[]{status});
        }

        List<BillEntity> resultList = (List<BillEntity>) baseDao.queryForList("act_deadowe_info.qDeadOweInfoNotCycle", inMap);

        return resultList;
    }

    public List<BillEntity> getUnPayOwe(Map<String, Object> inParam) {

        Map<String, Object> inMap = new HashMap<String, Object>();

		long contract_no = ValueUtils.longValue(inParam.get("CONTRACT_NO"));

        if (inParam.get("ID_NO") != null && !inParam.get("ID_NO").equals("")) {
            inMap.put("ID_NO", Long.parseLong(inParam.get("ID_NO").toString()));
        }

        if (inParam.get("BILL_CYCLE") != null && !inParam.get("BILL_CYCLE").equals("")) {
            inMap.put("BILL_CYCLE", Integer.parseInt(inParam.get("BILL_CYCLE").toString()));
        }

        if (inParam.get("MIN_BILL_CYCLE") != null && !inParam.get("MIN_BILL_CYCLE").equals("")) {
            inMap.put("MIN_BILL_CYCLE", Integer.parseInt(inParam.get("MIN_BILL_CYCLE").toString()));
        }

        if (inParam.get("MAX_BILL_CYCLE") != null && !inParam.get("MAX_BILL_CYCLE").equals("")) {
            inMap.put("MAX_BILL_CYCLE", Integer.parseInt(inParam.get("MAX_BILL_CYCLE").toString()));
        }

        if (inParam.get("MIN_NATURAL_MONTH") != null && !inParam.get("MIN_NATURAL_MONTH").equals("")) {
            inMap.put("MIN_NATURAL_MONTH", Integer.parseInt(inParam.get("MIN_NATURAL_MONTH").toString()));
        }

        if (inParam.get("MAX_NATURAL_MONTH") != null && !inParam.get("MAX_NATURAL_MONTH").equals("")) {
            inMap.put("MAX_NATURAL_MONTH", Integer.parseInt(inParam.get("MAX_NATURAL_MONTH").toString()));
        }

        if (inParam.get("BILL_DAY") != null && !inParam.get("BILL_DAY").equals("")) {
            inMap.put("BILL_DAY", Integer.parseInt(inParam.get("BILL_DAY").toString()));
        }

        if (inParam.get("NATURAL_MONTH") != null && !inParam.get("NATURAL_MONTH").equals("")) {
            inMap.put("NATURAL_MONTH", Integer.parseInt(inParam.get("NATURAL_MONTH").toString()));
        }

        inMap.put("CONTRACT_NO", contract_no);
        List<BillEntity> resultList = baseDao.queryForList("act_unpayowe_info.qBycontractNo", inMap);

        return resultList;
    }

    @Override
    public List<BillEntity> getUnpayOweOnBillCycle(long contractNo, Long idNo) {

        Map<String, Object> inMapTmp = null;

		// 出帐不停业务
        PubWrtoffCtrlEntity pwce = control.getWriteOffFlagAndMonth();
        int iWrtoffFlag = Integer.parseInt(pwce.getWrtoffFlag());
        int iWrtoffMonth = pwce.getWrtoffMonth();

		// 取未冲销费用信息
        inMapTmp = new HashMap<String, Object>();
        inMapTmp.put("CONTRACT_NO", contractNo);
        if (idNo != null && idNo > 0) {
            inMapTmp.put("ID_NO", idNo);
        }
        if (iWrtoffFlag == 1) {
            inMapTmp.put("BILL_DAY", CommonConst.BATCHWRTOFF_BILL_DAY);
            inMapTmp.put("NATURAL_MONTH", iWrtoffMonth);
        }

        List<BillEntity> unPayOweList = baseDao.queryForList("act_unpayowe_info.qByConNo", inMapTmp);

        return unPayOweList;
    }

    @Override
    public Map<String, Long> getSumUnpayInfo(Long contractNo, Long idNo, Integer billCycle) {
        PubWrtoffCtrlEntity wrtoffCtrlEntity = control.getWriteOffFlagAndMonth();
        String wrtoffFlag = wrtoffCtrlEntity.getWrtoffFlag();
        int wrtoffMonth = wrtoffCtrlEntity.getWrtoffMonth();

        Map<String, Object> inMap = new HashMap<String, Object>();
        if (contractNo != null && contractNo > 0) {
            inMap.put("CONTRACT_NO", contractNo);
        }
        if (idNo != null && idNo > 0) {
            inMap.put("ID_NO", idNo);
        }
        if (billCycle != null && billCycle > 0) {
            inMap.put("BILL_CYCLE", billCycle);
        }
        if (!wrtoffFlag.equals("0")) {
            inMap.put("BILL_DAY", CommonConst.BATCHWRTOFF_BILL_DAY);
            inMap.put("NATURAL_MONTH", wrtoffMonth);
        }
        Map<String, Object> outMap = (Map<String, Object>) this.baseDao.queryForObject("act_unpayowe_info.qActUnpaySum", inMap);
        Map<String, Long> result = new HashMap<>();
        safeAddToMap(result, "OWE_FEE", getLong(outMap, "OWE_FEE"));
        safeAddToMap(result, "PAYED_PREPAY", getLong(outMap, "PAYED_PREPAY"));
        safeAddToMap(result, "PAYED_LATER", getLong(outMap, "PAYED_LATER"));
        safeAddToMap(result, "SHOULD_PAY", getLong(outMap, "SHOULD_PAY"));
        safeAddToMap(result, "FAVOUR_FEE", getLong(outMap, "FAVOUR_FEE"));

        return result;

    }

    @Override
    public Map<String, Long> getSumPayedInfo(Map<String, Object> inParam) {
        Map<String, Object> inMap = new HashMap<String, Object>();

        PubWrtoffCtrlEntity wrtoffCtrlEntity = control.getWriteOffFlagAndMonth();
        String wrtoffFlag = wrtoffCtrlEntity.getWrtoffFlag();
        int wrtoffMonth = wrtoffCtrlEntity.getWrtoffMonth();
        if (!wrtoffFlag.equals("0")) {
            inMap.put("BILL_DAY", CommonConst.BATCHWRTOFF_BILL_DAY);
            inMap.put("NATURAL_MONTH", wrtoffMonth);
        }
        inMap.put("SUFFIX", inParam.get("BILL_CYCLE"));
        if (StringUtils.isNotEmptyOrNull(inParam.get("BILL_DAY"))) {
            inMap.put("BILL_DAY", inParam.get("BILL_DAY"));

        }
        if (StringUtils.isNotEmptyOrNull(inParam.get("ID_NO"))) {
            inMap.put("ID_NO", inParam.get("ID_NO"));
        }

        if (StringUtils.isNotEmptyOrNull(inParam.get("CONTRACT_NO"))) {
            inMap.put("CONTRACT_NO", inParam.get("CONTRACT_NO"));
        }

        if (StringUtils.isNotEmptyOrNull(inParam.get("ACCT_ITEM_CODE"))) {
            inMap.put("ACCT_ITEM_CODE", inParam.get("ACCT_ITEM_CODE"));
        }

        if (StringUtils.isNotEmptyOrNull(inParam.get("BILL_ID_LIST"))) {
            inMap.put("BILL_ID_LIST", inParam.get("BILL_ID_LIST"));
        }
        if (StringUtils.isNotEmptyOrNull(inParam.get("PAY_TYPE"))) {
            inMap.put("PAY_TYPE", inParam.get("PAY_TYPE"));
        }
        if (StringUtils.isNotEmptyOrNull(inParam.get("BUSHOU"))) {
            inMap.put("BUSHOU", "y");
        }
        Map<String, Long> outMap = (Map<String, Long>) baseDao.queryForObject("act_payedowe_info.qActPayedSum", inMap);

        return outMap;
    }

    @Override
    public Map<String, Long> getSumPayedInfo(Long contractNo, Long idNo, Integer billCycle) {
        PubWrtoffCtrlEntity wrtoffCtrlEntity = control.getWriteOffFlagAndMonth();
        String wrtoffFlag = wrtoffCtrlEntity.getWrtoffFlag();
        int wrtoffMonth = wrtoffCtrlEntity.getWrtoffMonth();

        Map<String, Object> inMap = new HashMap<String, Object>();
        if (contractNo != null && contractNo > 0) {
            inMap.put("CONTRACT_NO", contractNo);
        }
        if (idNo != null && idNo > 0) {
            inMap.put("ID_NO", idNo);
        }
        if (billCycle != null && billCycle > 0) {
            inMap.put("BILL_CYCLE", billCycle);
        }
        if (!wrtoffFlag.equals("0")) {
            inMap.put("BILL_DAY", CommonConst.BATCHWRTOFF_BILL_DAY);
            inMap.put("NATURAL_MONTH", wrtoffMonth);
        }
        inMap.put("SUFFIX", billCycle);
        Map<String, Object> outMap = (Map<String, Object>) this.baseDao.queryForObject("act_payedowe_info.qActPayedSum", inMap);
        Map<String, Long> result = new HashMap<>();
        safeAddToMap(result, "OWE_FEE", getLong(outMap, "OWE_FEE"));
        safeAddToMap(result, "PAYED_PREPAY", getLong(outMap, "PAYED_PREPAY"));
        safeAddToMap(result, "PAYED_LATER", getLong(outMap, "PAYED_LATER"));
        safeAddToMap(result, "SHOULD_PAY", getLong(outMap, "SHOULD_PAY"));
        safeAddToMap(result, "FAVOUR_FEE", getLong(outMap, "FAVOUR_FEE"));

        return result;

    }

    @Override
    public Map<String, Long> getSumUnpayInfoByItems(Long contractNo, Long idNo, Integer billCycle, String parentItemId, String currentLevel) {
        PubWrtoffCtrlEntity wrtoffCtrlEntity = control.getWriteOffFlagAndMonth();
        String wrtoffFlag = wrtoffCtrlEntity.getWrtoffFlag();
        int wrtoffMonth = wrtoffCtrlEntity.getWrtoffMonth();

        Map<String, Object> inMap = new HashMap<String, Object>();
        if (contractNo != null && contractNo > 0) {
            inMap.put("CONTRACT_NO", contractNo);
        }
        if (StringUtils.isNotEmptyOrNull(parentItemId)) {
            inMap.put("PARENT_ITEM_ID", parentItemId);
        }
        if (StringUtils.isNotEmptyOrNull(currentLevel)) {
            inMap.put("CURRENT_LEVEL", currentLevel);
        }
        if (idNo != null && idNo > 0) {
            inMap.put("ID_NO", idNo);
        }
        if (billCycle != null && billCycle > 0) {
            inMap.put("BILL_CYCLE", billCycle);
        }
        if (!wrtoffFlag.equals("0")) {
            inMap.put("BILL_DAY", CommonConst.BATCHWRTOFF_BILL_DAY);
            inMap.put("NATURAL_MONTH", wrtoffMonth);
        }
        Map<String, Object> outMap = (Map<String, Object>) this.baseDao.queryForObject("act_unpayowe_info.qItemsActUnpaySum", inMap);
        Map<String, Long> result = new HashMap<>();
        safeAddToMap(result, "OWE_FEE", getLong(outMap, "OWE_FEE"));
        safeAddToMap(result, "PAYED_PREPAY", getLong(outMap, "PAYED_PREPAY"));
        safeAddToMap(result, "PAYED_LATER", getLong(outMap, "PAYED_LATER"));
        safeAddToMap(result, "SHOULD_PAY", getLong(outMap, "SHOULD_PAY"));
        safeAddToMap(result, "FAVOUR_FEE", getLong(outMap, "FAVOUR_FEE"));

        return result;
    }

    @Override
    public Map<String, Long> getSumPayedInfoByItems(Long contractNo, Long idNo, Integer billCycle, String parentItemId, String currentLevel) {
        PubWrtoffCtrlEntity wrtoffCtrlEntity = control.getWriteOffFlagAndMonth();
        String wrtoffFlag = wrtoffCtrlEntity.getWrtoffFlag();
        int wrtoffMonth = wrtoffCtrlEntity.getWrtoffMonth();

        Map<String, Object> inMap = new HashMap<String, Object>();
        if (contractNo != null && contractNo > 0) {
            inMap.put("CONTRACT_NO", contractNo);
        }
        if (idNo != null && idNo > 0) {
            inMap.put("ID_NO", idNo);
        }
        if (StringUtils.isNotEmptyOrNull(parentItemId)) {
            inMap.put("PARENT_ITEM_ID", parentItemId);
        }
        if (StringUtils.isNotEmptyOrNull(currentLevel)) {
            inMap.put("CURRENT_LEVEL", currentLevel);
        }
        if (billCycle != null && billCycle > 0) {
            inMap.put("BILL_CYCLE", billCycle);
        }
        if (!wrtoffFlag.equals("0")) {
            inMap.put("BILL_DAY", CommonConst.BATCHWRTOFF_BILL_DAY);
            inMap.put("NATURAL_MONTH", wrtoffMonth);
        }
        inMap.put("SUFFIX", billCycle);
        Map<String, Object> outMap = (Map<String, Object>) this.baseDao.queryForObject("act_payedowe_info.qItemsActPayedSum", inMap);
        Map<String, Long> result = new HashMap<>();
        safeAddToMap(result, "OWE_FEE", getLong(outMap, "OWE_FEE"));
        safeAddToMap(result, "PAYED_PREPAY", getLong(outMap, "PAYED_PREPAY"));
        safeAddToMap(result, "PAYED_LATER", getLong(outMap, "PAYED_LATER"));
        safeAddToMap(result, "SHOULD_PAY", getLong(outMap, "SHOULD_PAY"));
        safeAddToMap(result, "FAVOUR_FEE", getLong(outMap, "FAVOUR_FEE"));

        return result;
    }

    @Override
    public OweFeeEntity getBillInfo(Long contractNo, Integer billCycle) {
        return this.getBillInfo(contractNo, 0L, billCycle);
    }

    @Override
    public OweFeeEntity getBillInfo(Long contractNo, Long idNo, Integer billCycle) {
        Map<String, Long> unpayMap = this.getSumUnpayInfo(contractNo, idNo, billCycle);
        Map<String, Long> payedMap = this.getSumPayedInfo(contractNo, idNo, billCycle);

        OweFeeEntity oweFeeEnt = new OweFeeEntity();
        oweFeeEnt.setBillCycle(billCycle);
        oweFeeEnt.setContractNo(contractNo);
        oweFeeEnt.setIdNo(idNo);
        oweFeeEnt.setShouldPay(unpayMap.get("SHOULD_PAY") + payedMap.get("SHOULD_PAY"));
        oweFeeEnt.setFavourFee(unpayMap.get("FAVOUR_FEE") + payedMap.get("FAVOUR_FEE"));
        oweFeeEnt
                .setPayedFee(unpayMap.get("PAYED_PREPAY") + payedMap.get("PAYED_PREPAY") + unpayMap.get("PAYED_LATER") + payedMap.get("PAYED_LATER"));
        oweFeeEnt.setOweFee(unpayMap.get("OWE_FEE"));

        return oweFeeEnt;
    }

    @Override
    public UnbillEntity getUnbillFee(long lContractNo) {

        return this.getUnbillFee(lContractNo, 0, CommonConst.UNBILL_TYPE_BILL_TOT);
    }

    @Override
    public UnbillEntity getUnbillFee(long lContractNo, boolean isOnline) {

        return getUnbillFee(lContractNo, 0, CommonConst.UNBILL_TYPE_BILL_TOT, isOnline);
    }

    @Override
    public UnbillEntity getUnbillFee(long lContractNo, String sQryType, boolean isOnline) {
        return getUnbillFee(lContractNo, 0, sQryType, isOnline);
    }

    @Override
    public UnbillEntity getUnbillFee(long lContractNo, long lIdNo, String sQryType) {

        boolean isOnline = control.isOnLineBill(lContractNo);

        return getUnbillFee(lContractNo, lIdNo, sQryType, isOnline);
    }

    @Override
    public UnbillEntity getUnbillFee(long lContractNo, long lIdNo, String sQryType, boolean isOnline) {

		String sBillFlag = control.getPubBillCtrl().getBillFlag(); /* 0 正常 2 不取内存欠费 */
        if (!"0".equals(sBillFlag)) {
			return new UnbillEntity(); // 未出帐帐单标识未开启后，不查询未出帐信息
        }

        int curYm = DateUtils.getCurYm();
        String curDate = DateUtils.getCurDate(DateUtils.DATE_FORMAT_YYYYMMDDHHMISS);

		List<BillEntity> billPayedList = new ArrayList<>(); /* 帐单明细已缴列表 */
		List<BillEntity> billUnPayList = new ArrayList<>(); /* 帐单明细未缴列表 */
		List<BillEntity> billAllList = new ArrayList<>(); /* 帐单全部（已缴/未缴）列表 */
        long unbillOweTotal = 0;
        long unbillShouldTotal = 0;
        long unbillFavourTotal = 0;
        long unbillPayedTotal = 0;
		if (sQryType.equals(CommonConst.UNBILL_TYPE_BILL_DET) || sQryType.equals(CommonConst.UNBILL_TYPE_BILL_DET_PRE)/* 明细帐单 + 预存 */) {
            List<UnbillDetEntity> billDetList = this.getUnbillBillDetList(lContractNo, lIdNo);
            for (UnbillDetEntity billDetEnt : billDetList) {
                BillEntity billEntity = new BillEntity();
                billEntity.setContractNo(billDetEnt.getConNo());
                billEntity.setIdNo(billDetEnt.getIdNo());
                billEntity.setProdPrcId(billDetEnt.getProdPrcId());
                billEntity.setNaturalMonth(curYm);
                billEntity.setBillCycle(billDetEnt.getBillCycle());
                billEntity.setBillBegin(billDetEnt.getBillBegin());
                billEntity.setBillDay(3600);
                billEntity.setAcctItemCode(billDetEnt.getAcctItemCode());
                billEntity.setShouldPay(billDetEnt.getShouldPay());
                billEntity.setFavourFee(billDetEnt.getFavourFee());
				billEntity.setPayedPrepay(isOnline ? billDetEnt.getPayedPrepay() : 0); /* 在线计算时，以帐处的结果为准 */
				billEntity.setPayedLater(0); //帐处无法获取此次费金额，返回0
                billEntity.setBillEnd(billDetEnt.getBillEnd());
                billEntity.setTaxRate(billDetEnt.getTaxRate());
                billEntity.setTaxFee(billDetEnt.getTaxFee());
                billEntity.setPayedTax(0);


                long billOwe = isOnline ? (billDetEnt.getShouldPay() - billDetEnt.getFavourFee() - billDetEnt.getPayedPrepay())
                        : (billDetEnt.getShouldPay() - billDetEnt.getFavourFee());

				unbillOweTotal/* 内存总欠费 */+= billOwe;
                unbillShouldTotal += billDetEnt.getShouldPay();
                unbillFavourTotal += billDetEnt.getFavourFee();
                unbillPayedTotal += isOnline ? billDetEnt.getPayedPrepay() : 0;


                if (billOwe > 0) {
                    billUnPayList.add(billEntity);
                } else {
                    billPayedList.add(billEntity);
                }
				billAllList.add(billEntity); /* 明细列表（所有） */

            }

        } //?? CommonConst.UNBILL_TYPE_BILL_DET

		if (sQryType.equals(CommonConst.UNBILL_TYPE_BILL_TOT) || sQryType.equals(CommonConst.UNBILL_TYPE_BILL_TOT_PRE) /* 综合帐单 + 预存 */) {
			/* 家庭付费用户查询综合帐单为多条 */
            List<UnbillTotEntity> billTotList = this.getUnbillBillTotList(lContractNo, lIdNo);
            for (UnbillTotEntity billTotEnt : billTotList) {
                BillEntity billEntity = new BillEntity();
                billEntity.setIdNo(billTotEnt.getIdNo());
                billEntity.setContractNo(billTotEnt.getConNo());
                billEntity.setBillCycle(billTotEnt.getBillCycle());
                billEntity.setBillBegin(billTotEnt.getBillBegin());
                billEntity.setBillEnd(billTotEnt.getBillEnd());
                billEntity.setShouldPay(billTotEnt.getShouldPay());
                billEntity.setFavourFee(billTotEnt.getFavourFee());
                billEntity.setPayedPrepay(isOnline ? billTotEnt.getPayedPrepay() : 0);
                billEntity.setPayedLater(0);

                long billOwe = isOnline ? (billTotEnt.getShouldPay() - billTotEnt.getFavourFee() - billTotEnt.getPayedPrepay())
                        : (billTotEnt.getShouldPay() - billTotEnt.getFavourFee());

				unbillOweTotal/* 内存总欠费 */+= billOwe;
                unbillShouldTotal += billTotEnt.getShouldPay();
                unbillFavourTotal += billTotEnt.getFavourFee();
                unbillPayedTotal += isOnline ? billTotEnt.getPayedPrepay() : 0;

                if (billOwe > 0) {
                    billUnPayList.add(billEntity);
                } else {
                    billPayedList.add(billEntity);
                }
				billAllList.add(billEntity); /* 明细列表（所有） */
            }
        } //?? CommonConst.UNBILL_TYPE_BILL_TOT

        List<BalanceEntity> validBookList = new ArrayList<>();
        List<BalanceEntity> beforeValidBookList = new ArrayList<>();
        List<BalanceEntity> afterValidBookList = new ArrayList<>();
        List<BalanceEntity> allBookList = new ArrayList<>();
        List<BalanceEntity> specialBookList = new ArrayList<>();
        long validBalanceTotal = 0;
        long prepayFeeTotal = 0;
        long specialBalanceTotal = 0;

        if (sQryType.equals(CommonConst.UNBILL_TYPE_PRE)
 || sQryType.equals(CommonConst.UNBILL_TYPE_BILL_TOT_PRE) /* 综合帐单 + 预存 */
				|| sQryType.equals(CommonConst.UNBILL_TYPE_BILL_DET_PRE)/* 明细帐单 + 预存 */
                ) {

            List<UnbillPreEntity> preList = getUnbillPreList(lContractNo, lIdNo);
            for (UnbillPreEntity preEnt : preList) {
                BalanceEntity bal = new BalanceEntity();
                bal.setBalanceId(preEnt.getBalanceId());
                bal.setContractNo(preEnt.getConNo());
                bal.setPayType(preEnt.getPayType());
                bal.setInitBalance(preEnt.getInitBalance());
                bal.setCurBalance(preEnt.getCurBalance() - preEnt.getWrtoffBalance());
                bal.setBeginTime(preEnt.getBeginTime());
                bal.setEndTime(preEnt.getEndTime());

				// 专款处理部分
                Map<String, Object> inMap = new HashMap<>();
                safeAddToMap(inMap, "PAY_TYPE", preEnt.getPayType());
                Map<String, Object> bookTypeMap = balance.getBookTypeDict(inMap);
                String payAttr = getString(bookTypeMap, "PAY_ATTR");
                String payTypeName = getString(bookTypeMap, "PAY_TYPE_NAME");
                String specialFlag = payAttr.substring(0, 1);

                bal.setSpecialFlag(specialFlag);
				bal.setSpecialFlagName(specialFlag.equals("0") ? "专款" : "普通预存");
                bal.setPayTypeName(payTypeName);

				if ("0".equals(specialFlag)) { // 专款
                    specialBalanceTotal += preEnt.getCurBalance() - preEnt.getWrtoffBalance();
                    specialBookList.add(bal);
                } else {
                    //do nothing

                }

                if (DateUtils.compare(curDate, preEnt.getBeginTime(), DateUtils.DATE_FORMAT_YYYYMMDDHHMISS) >= 0
                        && DateUtils.compare(curDate, preEnt.getEndTime(), DateUtils.DATE_FORMAT_YYYYMMDDHHMISS) <= 0) {
                    validBalanceTotal += preEnt.getCurBalance();
					prepayFeeTotal += preEnt.getCurBalance() - preEnt.getWrtoffBalance();
                    validBookList.add(bal);
                } else if (DateUtils.compare(curDate, preEnt.getBeginTime(), DateUtils.DATE_FORMAT_YYYYMMDDHHMISS) < 0) {
                    beforeValidBookList.add(bal);
                } else {
                    afterValidBookList.add(bal);
                }

                allBookList.add(bal);
            }

        } //?? CommonConst.UNBILL_TYPE_PRE

        UnbillEntity out = new UnbillEntity();
		/* 帐单部分 */
		out.setUnBillFee(unbillOweTotal); /* 未出帐总欠费 */
		out.setShouldPay(unbillShouldTotal); /* 未出帐总应收金额 */
		out.setFavourFee(unbillFavourTotal); /* 未出帐总优惠金额 */
		out.setPayedPrepay(unbillPayedTotal); /* 未出帐已划拨总金额 */
		out.setUnBillList(billAllList); /* 未出帐帐单所有列表 */
		out.setPayedOweList(billPayedList); /* 已缴未出帐帐单列表 */

		/* 帐本预存部分 */
		out.setPrepayFee(prepayFeeTotal); /* 生效帐本总和 */
		out.setGprepayFee(specialBalanceTotal); /* 专款总预存 */
		out.setBalanceTotal(validBalanceTotal); /* 生效帐本总和 */
		out.setAcctBookList(validBookList); /* 未出帐生效帐本列表 */
		out.setAcctBookEffList(beforeValidBookList); /* 未出帐未生效帐本列表 */
		out.setAcctBookExpList(afterValidBookList); /* 未出帐过期帐本列表 */
		out.setAcctBookAllList(allBookList); /* 未出帐余额帐本列表 */
		out.setSpecialActBookList(specialBookList); /* 未出帐专款帐本列表 */


        log.info("getUnbillFee out:" + out.toString());
        return out;
    }

    public boolean isUnPayOwe(long lIdNo, long lContractNo, int iBillCycle) {

        long lOweFee = 0;

        Map<String, Object> inParam = new HashMap<String, Object>();
        Map<String, Object> outParam = null;

        inParam.put("CONTRACT_NO", lContractNo);
        if (iBillCycle > 0) {
            inParam.put("NATURAL_MONTH", iBillCycle);
        }
        if (lIdNo > 0) {
            inParam.put("ID_NO", lIdNo);
        }
        Integer cnt = (Integer) baseDao.queryForObject("act_unpayowe_info.qryCntByAcct", inParam);
        if (cnt.intValue() > 0) {
            return true;
        } else {
            return false;
        }
    }

    public boolean isUnPayOwe(long lContractNo, int iBillCycle) {

        return isUnPayOwe(0, lContractNo, iBillCycle);
    }

    public boolean isUnPayOwe(long lContractNo) {

        return isUnPayOwe(0, lContractNo, 0);
    }

    @Override
    public BilldayInfoEntity getBillCycle(long idNo, long contractNo, int billMonth) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        if (idNo <= 0 && contractNo <= 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8010", "10002"), "查询帐期用户ID_NO和帐户号码CONTRACT_NO必须有一个值大于0");
        }

        if (idNo > 0) {
            safeAddToMap(inMap, "ID_NO", idNo);
        }
        if (contractNo > 0) {
            safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        }
        safeAddToMap(inMap, "YEAR_MONTH", billMonth);

        BilldayInfoEntity result = (BilldayInfoEntity) baseDao.queryForObject("ur_billday_info.qBillDayInfo", inMap);
        if (result == null) {
            log.debug("query ur_billday_info is ERROR!");
			throw new BusiException(AcctMgrError.getErrorCode("8010", "10003"), "查询用户账期出错lIdNo[" + idNo + "]lContractNo[" + contractNo
                    + "]iBillMonth[" + billMonth + "]");
        }

        return result;
    }

    @Override
    public BillFeeEntity getBillFee(long idNo, long contractNo, int yearMonth) {
        BillFeeEntity unpayfee = this.getUnPayOweFee(idNo, contractNo, yearMonth);
        BillFeeEntity payedfee = this.getPayedOweFee(idNo, contractNo, yearMonth);
        int iCurrYm = DateUtils.getCurYm();
        BillFeeEntity unbillfee = new BillFeeEntity();
        if (yearMonth == iCurrYm) {
            unbillfee = this.getUnBillOweFee(idNo, contractNo);
        }

        return unpayfee.add(payedfee).add(unbillfee);
    }

    private BillFeeEntity getUnPayOweFee(long idNo, long contractNo, int yearMonth) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
        BillFeeEntity unpayFee = (BillFeeEntity) baseDao.queryForObject("act_unpayowe_info.qUnpayOweRealFee", inMap);
        return unpayFee;
    }

    @Override
    public BillFeeEntity getUnBillOweFee(long idNo, long contractNo) {
        BillFeeEntity unbillFee = new BillFeeEntity();
        UnbillEntity unBillInfo = this.getUnbillFee(contractNo, idNo, CommonConst.UNBILL_TYPE_BILL_TOT);

        unbillFee.setShouldPay(unBillInfo.getShouldPay());
        unbillFee.setFavourFee(unBillInfo.getFavourFee());
        unbillFee.setRealFee(unBillInfo.getShouldPay() - unBillInfo.getFavourFee());
        return unbillFee;
    }

    private BillFeeEntity getPayedOweFee(Long idNo, Long contractNo, int yearMonth) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        if (idNo != null && idNo > 0) {
            safeAddToMap(inMap, "ID_NO", idNo);
        }
        safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
        safeAddToMap(inMap, "SUFFIX", yearMonth);
        BillFeeEntity payedFee = (BillFeeEntity) baseDao.queryForObject("act_payedowe_info.qPayedOweFee", inMap);
        return payedFee;
    }

    @Override
    public long getRealFee(long idNo, long contractNo, int yearMonth) {
        return this.getBillFee(idNo, contractNo, yearMonth).getRealFee();
    }

    private long getUnpayOweRealFee(long idNo, long contractNo, int yearMonth) {
        return this.getUnPayOweFee(idNo, contractNo, yearMonth).getRealFee();
    }

    @Override
    public long getPayedOweRealFee(Long idNo, long contractNo, int yearMonth) {
        return this.getPayedOweFee(idNo, contractNo, yearMonth).getRealFee();
    }

    private long getUnBillOweRealFee(long idNo, long contractNo) {
        return this.getUnBillOweFee(idNo, contractNo).getRealFee();
    }

    @Override
    public List<AdjOweEntity> getAdjOweInfo(long idNo, String beginTime, String endTime, String refundFlag) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "BEGIN_TIME", beginTime);
        safeAddToMap(inMap, "END_TIME", endTime);
        List<AdjOweEntity> result = new ArrayList<AdjOweEntity>();
        if (refundFlag.equals("0")) {
            result = (List<AdjOweEntity>) baseDao.queryForList("act_adjowe_info.qry", inMap);
        } else if (refundFlag.equals("1")) {
            result = (List<AdjOweEntity>) baseDao.queryForList("act_adjowe_info.qryRufund", inMap);
        }

        return result;
    }

    @Override
    public BillEntity getSumDeadFee(long idNo, long contractNo, String status) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        if (idNo > 0) {
            safeAddToMap(inMap, "ID_NO", idNo);
        }
        if (contractNo > 0) {
            safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        }
        if (StringUtils.isNotEmpty(status)) {
            // safeAddToMap(inMap, "STATUS", status);
            safeAddToMap(inMap, "STATUS", status.split("\\,"));
        }

        BillEntity result = (BillEntity) baseDao.queryForObject("act_deadowe_info.qActDeadOweSum", inMap);

        return result;
    }

    @Override
    public CollectionBillEntity getCollectionBill(long contractNo, int billCycle) {
        return this.getCollectionBill(contractNo, billCycle, "0", null, null);
    }

    @Override
    public CollectionBillEntity getCollectionBill(long contractNo, int billCycle, String dealFlag, String returnCode, String errorFlag) {

        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("CONTRACT_NO", contractNo);
        inMap.put("BILL_CYCLE", billCycle);
        if (dealFlag != null && !dealFlag.isEmpty()) {
            inMap.put("DEAL_FLAG", dealFlag);
        }
        if (StringUtils.isNotEmpty(returnCode)) {
            inMap.put("RETURN_CODE", returnCode);
        }
		if (StringUtils.isNotEmpty(errorFlag) && errorFlag.equals(CommonConst.COLL_ERROR_YES)) { // 托收处理失败或未处理
            inMap.put("ERR_CODE", "ERROR");
        }
        CollectionBillEntity result = (CollectionBillEntity) baseDao.queryForObject("act_collbill_info.qCollBillInfo", inMap);

        return result;
    }

    public void updateCollbill(long contractNo, int billCycle, String returnCode, String dealFlag) {

        Map<String, Object> inMapTmp = new HashMap<String, Object>();
        inMapTmp.put("CONTRACT_NO", contractNo);
        inMapTmp.put("BILL_CYCLE", billCycle);
        inMapTmp.put("DEAL_FLAG", dealFlag);
        if (returnCode != null) {
            inMapTmp.put("RETURN_CODE", returnCode);
        }

        baseDao.update("act_collbill_info.uByConBillcycle", inMapTmp);
    }

    @Override
    public boolean isDeadUnPayOwe(long lContractNo, int iBillCycle, long lIdNo) {
		/* 离网用户查询 */
        Map<String, Object> inParam = new HashMap<String, Object>();
        Map<String, Object> outParam = null;
        long lOweFee = 0;
        if (lIdNo > 0) {
            inParam.put("ID_NO", lIdNo);
        }
        inParam.put("CONTRACT_NO", lContractNo);
        inParam.put("NATURAL_MONTH", iBillCycle);
        outParam = (Map<String, Object>) baseDao.queryForObject("act_deadowe_info.qrySumFeeByCon", inParam);
        lOweFee = Long.parseLong(outParam.get("FEE").toString());
        if (lOweFee > 0) {
            return true;
        } else {
            return false;
        }
    }

    @Override
    public List<CollectionBillEntity> getCollBillList(Long begContract, Long endContract, Integer yearMonth, String disGroupId, String provinceId) {

        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "BEGIN_CONTRACT_NO", begContract);
        safeAddToMap(inMap, "END_CONTRACT_NO", endContract);
        safeAddToMap(inMap, "BILL_CYCLE", yearMonth);
        safeAddToMap(inMap, "DEAL_FLAG", "0");
        safeAddToMap(inMap, "DIS_GROUP_ID", disGroupId);
        safeAddToMap(inMap, "PROVINCE_ID", provinceId);

        List<CollectionBillEntity> outList = baseDao.queryForList("act_collbill_info.qCollBillInfo", inMap);
        if (outList.isEmpty()) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "00000"), "没有要生成的的[" + yearMonth + "]月托收单");
        }

        return outList;
    }

    @Override
    public Map<String, Object> getSevenFee(long lContractNo, int iBillCycle, long lIdNo, boolean his) {

        Map<String, Object> mInTemp = new HashMap<String, Object>();
        Map<String, Object> mSevFee = new HashMap<String, Object>();
        int iItemOrder = 0;
        long lBillFee = 0;
        long lFavFee = 0;
        long lSetMealFee = 0;
        long lVoiceFee = 0;
        long lNetFee = 0;
        long lMmsFee = 0;
        long lIncreFee = 0;
        long lCollecFee = 0;
        long lOtherFee = 0;
        int iNaturalMon = iBillCycle;

		/* 查询7大类已冲销费用 */
        if (lIdNo > 0) {
            mInTemp.put("ID_NO", lIdNo);
        }
        if (his) {
            mInTemp.put("NATURAL_MONTH", "HIS");
            mInTemp.put("BILL_CYCLE", iNaturalMon);
        } else {
            mInTemp.put("NATURAL_MONTH", "" + iNaturalMon);
        }

        mInTemp.put("CONTRACT_NO", lContractNo);

        List<Map<String, Object>> mSevFeeList = (List<Map<String, Object>>) baseDao.queryForList("act_payedowe_info.qryPayTypeFeeByCon", mInTemp);

        for (Map<String, Object> mSevFeeMap : mSevFeeList) {
            iItemOrder = Integer.parseInt(mSevFeeMap.get("ITEM_ORDER").toString());
            lBillFee = Long.parseLong(mSevFeeMap.get("BILL_FEE").toString());
            lFavFee = Long.parseLong(mSevFeeMap.get("FAV_FEE").toString());

            switch (iItemOrder) {
                case 1:
                    lSetMealFee = lBillFee - lFavFee;
                    break;
                case 2:
                    lVoiceFee = lBillFee - lFavFee;
                    break;
                case 3:
                    lNetFee = lBillFee - lFavFee;
                    break;
                case 4:
                    lMmsFee = lBillFee - lFavFee;
                    break;
                case 5:
                    lIncreFee = lBillFee - lFavFee;
                    break;
                case 6:
                    lCollecFee = lBillFee - lFavFee;
                    break;
                case 7:
                    lOtherFee = lBillFee - lFavFee;
                    break;
                default:
                    break;
            }

        }
        mSevFee.put("SET_MEAL_FEE", lSetMealFee);
        mSevFee.put("VOICE_FEE", lVoiceFee);
        mSevFee.put("NET_FEE", lNetFee);
        mSevFee.put("MMS_FEE", lMmsFee);
        mSevFee.put("INCRE_FEE", lIncreFee);
        mSevFee.put("COLLECTION_FEE", lCollecFee);
        mSevFee.put("OTHER_FEE", lOtherFee);

        return mSevFee;
    }

    @Override
    public Map<String, Object> getSevenFee(long lContractNo, int iBillCycle) {
        return getSevenFee(lContractNo, iBillCycle, 0, false);
    }

    @Override
    public Map<String, Object> getDeadSevenFee(long lContractNo, int iBillCycle, long lIdNo, int billYM) {
        Map<String, Object> mInTemp = new HashMap<String, Object>();

		/** 查询HIS表 **/
        Map<String, Object> outMap = getSevenFee(lContractNo, iBillCycle, lIdNo, billYM > iBillCycle);

        // outMap = getSevenFee(lContractNo,iBillCycle,lIdNo);

        mInTemp = new HashMap<String, Object>();
        Map<String, Object> mSevFee = new HashMap<String, Object>();
        int iItemOrder = 0;
        long lBillFee = 0;
        long lFavFee = 0;
        long lSetMealFee = 0;
        long lVoiceFee = 0;
        long lNetFee = 0;
        long lMmsFee = 0;
        long lIncreFee = 0;
        long lCollecFee = 0;
        long lOtherFee = 0;
        int iNaturalMon = iBillCycle;

        mInTemp.clear();
        if (lIdNo > 0) {
            mInTemp.put("ID_NO", lIdNo);
        }
        mInTemp.put("CONTRACT_NO", lContractNo);
        mInTemp.put("NATURAL_MONTH", iNaturalMon);

        List<Map<String, Object>> mSevFeeList = (List<Map<String, Object>>) baseDao.queryForList("act_deadowe_info.qryDeadoweByCon", mInTemp);
        // log.info("-----124mSevFeeList="+mSevFeeList);
        for (Map<String, Object> mSevFeeMap : mSevFeeList) {
            iItemOrder = Integer.parseInt(mSevFeeMap.get("ITEM_ORDER").toString());
            lBillFee = Long.parseLong(mSevFeeMap.get("BILL_FEE").toString());
            lFavFee = Long.parseLong(mSevFeeMap.get("FAV_FEE").toString());

            switch (iItemOrder) {
                case 1:
                    lSetMealFee = lBillFee - lFavFee;
                    break;
                case 2:
                    lVoiceFee = lBillFee - lFavFee;
                    break;
                case 3:
                    lNetFee = lBillFee - lFavFee;
                    break;
                case 4:
                    lMmsFee = lBillFee - lFavFee;
                    break;
                case 5:
                    lIncreFee = lBillFee - lFavFee;
                    break;
                case 6:
                    lCollecFee = lBillFee - lFavFee;
                    break;
                case 7:
                    lOtherFee = lBillFee - lFavFee;
                    break;
                default:
                    break;
            }
        }

        outMap.put("SET_MEAL_FEE", (Long) outMap.get("SET_MEAL_FEE") + lSetMealFee);
        outMap.put("VOICE_FEE", (Long) outMap.get("VOICE_FEE") + lVoiceFee);
        outMap.put("NET_FEE", (Long) outMap.get("NET_FEE") + lNetFee);
        outMap.put("MMS_FEE", (Long) outMap.get("MMS_FEE") + lMmsFee);
        outMap.put("INCRE_FEE", (Long) outMap.get("INCRE_FEE") + lIncreFee);
        outMap.put("COLLECTION_FEE", (Long) outMap.get("COLLECTION_FEE") + lCollecFee);
        outMap.put("OTHER_FEE", (Long) outMap.get("OTHER_FEE") + lOtherFee);

        return outMap;
    }

    @Override
    public boolean isOnlineForQry(long lContractNo) {
		UnbillEntity unbillEntity = this.getUnbillFee(lContractNo, CommonConst.UNBILL_TYPE_PRE, true); /* 只需要获取在线的预存总金额 */
        long lCurBal = 0;
		// 取物理库账本
        lCurBal = balance.getAcctBookSum(lContractNo, null);

        long lBalanceTotal = unbillEntity.getBalanceTotal();

        boolean realFlag = false;
		if (lCurBal != lBalanceTotal) { // 物理库冲销积压，查询离线余额
            if (control.isOnLineBill(lContractNo)) {
                ActQueryOprEntity aqoe = new ActQueryOprEntity();
                aqoe.setQueryType("ONTOF");
                aqoe.setLoginNo("system");
                aqoe.setLoginGroup("245");
                aqoe.setPhoneNo(String.valueOf(lContractNo));
                aqoe.setBrandId("");
                aqoe.setOpCode("0000");
				aqoe.setRemark("在线查离线记录,PHONE_NO和ID_NO记录账户号码");
                aqoe.setIdNo(lContractNo);
                record.saveQueryOpr(aqoe, false);
                log.error("Because the acctbooks synchronization backlog, offine balance. contract_no = " + lContractNo);
            }
            realFlag = false;
        } else {
            realFlag = control.isOnLineBill(lContractNo);
        }
        return realFlag;
    }

    @Override
    public Map<String, Object> getDeadSevenFee(long lContractNo, int iBillCycle, int billYM) {
        return getDeadSevenFee(lContractNo, iBillCycle, 0, billYM);
    }

    @Override
    public Map<String, Object> getConFeeList(Map<String, Object> inParam) {
        Map<String, Object> outParam = new HashMap<String, Object>();
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = null;
        List<Map<String, Object>> oweInfoList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> payDownInfoList = new ArrayList<Map<String, Object>>();

        long lContractNo = 0;
        long lIdNo = 0;
        String sPhoneNo = "";
        int iBeginTime = 0;
        int iEndTime = 0;
        int iInNetFlag = 0;
        int iQryFlag = 0;
        boolean isOnline = false;

        lContractNo = (Long) inParam.get("CONTRACT_NO");

        if (inParam.get("ID_NO") != null && !inParam.get("ID_NO").equals("")) {
            lIdNo = (Long) inParam.get("ID_NO");
        }

        if (inParam.get("PHONE_NO") != null && !inParam.get("PHONE_NO").equals("")) {
            sPhoneNo = (String) inParam.get("PHONE_NO");
        }

        if (inParam.get("BEGIN_TIME") != null && !inParam.get("BEGIN_TIME").equals("")) {
            iBeginTime = (Integer) inParam.get("BEGIN_TIME");
        }

        if (inParam.get("END_TIME") != null && !inParam.get("END_TIME").equals("")) {
            iEndTime = (Integer) inParam.get("END_TIME");
        }

        if (inParam.get("INNET_FLAG") != null && !inParam.get("INNET_FLAG").equals("")) {
            iInNetFlag = (Integer) inParam.get("INNET_FLAG");
        }

        if (inParam.get("QRY_FLAG") != null && !inParam.get("QRY_FLAG").equals("")) {
            iQryFlag = (Integer) inParam.get("QRY_FLAG");
        }

        if (inParam.get("IS_ONLINE") != null && !inParam.get("IS_ONLINE").equals("")) {
            isOnline = Boolean.valueOf(inParam.get("IS_ONLINE").toString());
        }

		// 取当前时间
        String sCurDate = "";
        String sCurYm = "";
        sCurDate = DateUtil.format(new Date(), "yyyyMMdd");
        sCurYm = sCurDate.substring(0, 6);
        int iBillMonth = Integer.valueOf(sCurYm);

		// 取滞纳金比率
        int iDelayBegin = 0;
        double dDelayRate = 0.00;
        inMap.put("CONTRACT_NO", lContractNo);
        if (iInNetFlag > 0) {
            inMap.put("NET_FLAG", iInNetFlag);
        }
        outMap = delay.getDelayRate(inMap);
        iDelayBegin = (Integer) outMap.get("DELAY_BEGIN");
        dDelayRate = (Double) outMap.get("DELAY_RATE");

		// 出帐不停业务
        int iWrtoffFlag = 0;
        int iWrtoffMonth = 0;
        PubWrtoffCtrlEntity pwce = control.getWriteOffFlagAndMonth();
        iWrtoffFlag = Integer.parseInt(pwce.getWrtoffFlag());
        iWrtoffMonth = pwce.getWrtoffMonth();

		// 取内存库欠费和已冲销费用
        if (iInNetFlag == CommonConst.IN_NET) {
            if ((iBeginTime == 0 && iEndTime == 0) || (iBeginTime / 100 <= Integer.parseInt(sCurYm) && iEndTime / 100 >= Integer.parseInt(sCurYm))) {
                if (lIdNo > 0) {
					UnbillEntity unbillEntity = this.getUnbillFee(lContractNo, lIdNo, CommonConst.UNBILL_TYPE_BILL_DET, isOnline); /* 取内存明细账单 */
                    List<BillEntity> unbillList = unbillEntity.getUnBillList();
                    for (BillEntity unbill : unbillList) {
                        if (unbill.getShouldPay() == 0 && unbill.getFavourFee() == 0) {
                            continue;
                        }
                        if (oweInfoList.size() == 0) {
                            Map<String, Object> tempMap = new HashMap<String, Object>();
                            tempMap.put("BILL_CYCLE", unbill.getBillCycle());
                            tempMap.put("REAL_PAY", unbill.getShouldPay() - unbill.getFavourFee());
                            tempMap.put("SHOULD_PAY", unbill.getShouldPay());
                            tempMap.put("FAVOUR_FEE", unbill.getFavourFee());
                            tempMap.put("PAYED_PREPAY", unbill.getPayedPrepay());
                            tempMap.put("PAYED_LATER", unbill.getPayedLater());
                            tempMap.put("OWE_FEE", unbill.getShouldPay() - unbill.getFavourFee() - unbill.getPayedPrepay() - unbill.getPayedLater());
                            tempMap.put("DELAY_FEE", 0L);
                            tempMap.put("BILL_BEGIN", unbill.getBillBegin());
                            tempMap.put("BILL_END", unbill.getBillEnd());
                            tempMap.put("CONTRACT_NO", lContractNo);
                            tempMap.put("ID_NO", unbill.getIdNo());

							// 取服务号码
                            String addNo = "";
                            addNo = user.getAddServiceNo(unbill.getIdNo(), "02");
                            if (StringUtils.isEmptyOrNull(addNo)) {
                                addNo = user.getAddServiceNo(unbill.getIdNo(), "16");
                            }
                            if (StringUtils.isEmptyOrNull(addNo)) {
								// 取服务号码
                                try {
                                    UserInfoEntity uie = user.getUserEntity(unbill.getIdNo(), null, null, true);
                                    safeAddToMap(tempMap, "PHONE_NO", uie.getPhoneNo());
                                } catch (BusiException e) {
                                    safeAddToMap(tempMap, "PHONE_NO", "99999999999");
                                }
                            } else {
                                safeAddToMap(tempMap, "PHONE_NO", addNo);
                            }

							tempMap.put("STATUS", "未缴");

                            oweInfoList.add(tempMap);
                        } else {
                            for (Map<String, Object> oweInfo : oweInfoList) {
                                safeAddToMap(oweInfo, "REAL_PAY", getLongValue(oweInfo, "REAL_PAY") + unbill.getShouldPay() - unbill.getFavourFee());
                                safeAddToMap(oweInfo, "SHOULD_PAY", getLongValue(oweInfo, "SHOULD_PAY") + unbill.getShouldPay());
                                safeAddToMap(oweInfo, "FAVOUR_FEE", getLongValue(oweInfo, "FAVOUR_FEE") + unbill.getFavourFee());
                                safeAddToMap(oweInfo, "PAYED_PREPAY", getLongValue(oweInfo, "PAYED_PREPAY") + unbill.getPayedPrepay());
                                safeAddToMap(oweInfo, "PAYED_LATER", getLongValue(oweInfo, "PAYED_LATER") + unbill.getPayedLater());
                                safeAddToMap(oweInfo, "OWE_FEE", getLongValue(oweInfo, "OWE_FEE") + unbill.getShouldPay() - unbill.getFavourFee()
                                        - unbill.getPayedPrepay() - unbill.getPayedLater());
                                safeAddToMap(
                                        oweInfo,
                                        "BILL_BEGIN",
                                        getIntValue(oweInfo, "BILL_BEGIN") < unbill.getBillBegin() ? getIntValue(oweInfo, "BILL_BEGIN") : unbill
                                                .getBillBegin());
                                safeAddToMap(
                                        oweInfo,
                                        "BILL_END",
                                        getIntValue(oweInfo, "BILL_END") > unbill.getBillBegin() ? getIntValue(oweInfo, "BILL_END") : unbill
                                                .getBillEnd());
                            }
                        }
                    }
					// 查询内存库已冲销帐单
                    if (iQryFlag != 0 && (iBeginTime / 100 <= Integer.parseInt(sCurYm) && iEndTime / 100 >= Integer.parseInt(sCurYm))) {
                        List<BillEntity> payeoweList = unbillEntity.getPayedOweList();
                        for (BillEntity payowe : payeoweList) {
                            if (payowe.getShouldPay() == 0 && payowe.getFavourFee() == 0) {
                                continue;
                            }

                            if (payDownInfoList.size() == 0) {
                                Map<String, Object> payDownTmp = new HashMap<String, Object>();

                                payDownTmp.put("BILL_CYCLE", payowe.getBillCycle());
                                payDownTmp.put("REAL_PAY", payowe.getShouldPay() - payowe.getFavourFee());
                                payDownTmp.put("SHOULD_PAY", payowe.getShouldPay());
                                payDownTmp.put("FAVOUR_FEE", payowe.getFavourFee());
                                payDownTmp.put("PAYED_PREPAY", payowe.getPayedPrepay());
                                payDownTmp.put("PAYED_LATER", payowe.getPayedLater());
                                payDownTmp.put("OWE_FEE",
                                        payowe.getShouldPay() - payowe.getFavourFee() - payowe.getPayedPrepay() - payowe.getPayedLater());
                                payDownTmp.put("DELAY_FEE", 0);
                                payDownTmp.put("BILL_BEGIN", payowe.getBillBegin());
                                payDownTmp.put("BILL_END", payowe.getBillEnd());
                                payDownTmp.put("CONTRACT_NO", lContractNo);
                                payDownTmp.put("ID_NO", payowe.getIdNo());

								// 取服务号码
                                String addNo = "";
                                addNo = user.getAddServiceNo(payowe.getIdNo(), "02");
                                if (StringUtils.isEmptyOrNull(addNo)) {
                                    addNo = user.getAddServiceNo(payowe.getIdNo(), "16");
                                }
                                if (StringUtils.isEmptyOrNull(addNo)) {
									// 取服务号码
                                    try {
                                        UserInfoEntity uie = user.getUserEntity(payowe.getIdNo(), null, null, true);
                                        safeAddToMap(payDownTmp, "PHONE_NO", uie.getPhoneNo());
                                    } catch (BusiException e) {
                                        safeAddToMap(payDownTmp, "PHONE_NO", "99999999999");
                                    }
                                } else {
                                    safeAddToMap(payDownTmp, "PHONE_NO", addNo);
                                }
								payDownTmp.put("STATUS", "已缴");
                                payDownInfoList.add(payDownTmp);
                            } else {
                                for (Map<String, Object> payInfo : payDownInfoList) {
                                    safeAddToMap(payInfo, "REAL_PAY",
                                            getLongValue(payInfo, "REAL_PAY") + payowe.getShouldPay() - payowe.getFavourFee());
                                    safeAddToMap(payInfo, "SHOULD_PAY", getLongValue(payInfo, "SHOULD_PAY") + payowe.getShouldPay());
                                    safeAddToMap(payInfo, "FAVOUR_FEE", getLongValue(payInfo, "FAVOUR_FEE") + payowe.getFavourFee());
                                    safeAddToMap(payInfo, "PAYED_PREPAY", getLongValue(payInfo, "PAYED_PREPAY") + payowe.getPayedPrepay());
                                    safeAddToMap(payInfo, "PAYED_LATER", getLongValue(payInfo, "PAYED_LATER") + payowe.getPayedLater());
                                    safeAddToMap(payInfo, "OWE_FEE", getLongValue(payInfo, "OWE_FEE") + payowe.getShouldPay() - payowe.getFavourFee()
                                            - payowe.getPayedPrepay() - payowe.getPayedLater());
                                    safeAddToMap(
                                            payInfo,
                                            "BILL_BEGIN",
                                            getIntValue(payInfo, "BILL_BEGIN") < payowe.getBillBegin() ? getIntValue(payInfo, "BILL_BEGIN") : payowe
                                                    .getBillBegin());
                                    safeAddToMap(
                                            payInfo,
                                            "BILL_END",
                                            getIntValue(payInfo, "BILL_END") > payowe.getBillBegin() ? getIntValue(payInfo, "BILL_END") : payowe
                                                    .getBillEnd());
                                }
                            }
                        }
                    }

                } else {
                    List<ContractEntity> userList = account.getUserList(lContractNo);
                    for (ContractEntity userEntity : userList) {
                        long lIdNoTmp = userEntity.getId();

                        int iOweFlag = 0;
						UnbillEntity unbillEntity = this.getUnbillFee(lContractNo, lIdNoTmp, CommonConst.UNBILL_TYPE_BILL_DET, isOnline); /* 取内存明细账单 */
                        List<BillEntity> unbillList = unbillEntity.getUnBillList();
                        for (BillEntity unbill : unbillList) {
                            if (unbill.getShouldPay() == 0 && unbill.getFavourFee() == 0) {
                                continue;
                            }
                            if (iOweFlag == 0) {
                                Map<String, Object> tempMap = new HashMap<String, Object>();
                                tempMap.put("BILL_CYCLE", unbill.getBillCycle());
                                tempMap.put("REAL_PAY", unbill.getShouldPay() - unbill.getFavourFee());
                                tempMap.put("SHOULD_PAY", unbill.getShouldPay());
                                tempMap.put("FAVOUR_FEE", unbill.getFavourFee());
                                tempMap.put("PAYED_PREPAY", unbill.getPayedPrepay());
                                tempMap.put("PAYED_LATER", unbill.getPayedLater());
                                tempMap.put("OWE_FEE",
                                        unbill.getShouldPay() - unbill.getFavourFee() - unbill.getPayedPrepay() - unbill.getPayedLater());
                                tempMap.put("DELAY_FEE", 0L);
                                tempMap.put("BILL_BEGIN", unbill.getBillBegin());
                                tempMap.put("BILL_END", unbill.getBillEnd());
                                tempMap.put("CONTRACT_NO", lContractNo);
                                tempMap.put("ID_NO", unbill.getIdNo());

								// 取服务号码
                                String addNo = "";
                                addNo = user.getAddServiceNo(unbill.getIdNo(), "02");
                                if (StringUtils.isEmptyOrNull(addNo)) {
                                    addNo = user.getAddServiceNo(unbill.getIdNo(), "16");
                                }
                                if (StringUtils.isEmptyOrNull(addNo)) {
									// 取服务号码
                                    try {
                                        UserInfoEntity uie = user.getUserEntity(unbill.getIdNo(), null, null, true);
                                        safeAddToMap(tempMap, "PHONE_NO", uie.getPhoneNo());
                                    } catch (BusiException e) {
                                        safeAddToMap(tempMap, "PHONE_NO", "99999999999");
                                    }
                                } else {
                                    safeAddToMap(tempMap, "PHONE_NO", addNo);
                                }

								tempMap.put("STATUS", "未缴");

                                oweInfoList.add(tempMap);
                            } else {
                                for (Map<String, Object> oweInfo : oweInfoList) {
                                    if (getIntValue(oweInfo, "BILL_CYCLE") == unbill.getBillCycle()
                                            && getLongValue(oweInfo, "ID_NO") == unbill.getIdNo()) {
                                        safeAddToMap(oweInfo, "REAL_PAY",
                                                getLongValue(oweInfo, "REAL_PAY") + unbill.getShouldPay() - unbill.getFavourFee());
                                        safeAddToMap(oweInfo, "SHOULD_PAY", getLongValue(oweInfo, "SHOULD_PAY") + unbill.getShouldPay());
                                        safeAddToMap(oweInfo, "FAVOUR_FEE", getLongValue(oweInfo, "FAVOUR_FEE") + unbill.getFavourFee());
                                        safeAddToMap(oweInfo, "PAYED_PREPAY", getLongValue(oweInfo, "PAYED_PREPAY") + unbill.getPayedPrepay());
                                        safeAddToMap(oweInfo, "PAYED_LATER", getLongValue(oweInfo, "PAYED_LATER") + unbill.getPayedLater());
                                        safeAddToMap(
                                                oweInfo,
                                                "OWE_FEE",
                                                getLongValue(oweInfo, "OWE_FEE") + unbill.getShouldPay() - unbill.getFavourFee()
                                                        - unbill.getPayedPrepay() - unbill.getPayedLater());
                                        safeAddToMap(oweInfo, "BILL_BEGIN",
                                                getIntValue(oweInfo, "BILL_BEGIN") < unbill.getBillBegin() ? getIntValue(oweInfo, "BILL_BEGIN")
                                                        : unbill.getBillBegin());
                                        safeAddToMap(
                                                oweInfo,
                                                "BILL_END",
                                                getIntValue(oweInfo, "BILL_END") > unbill.getBillBegin() ? getIntValue(oweInfo, "BILL_END") : unbill
                                                        .getBillEnd());
                                    }
                                }
                            }

                            iOweFlag++;
                        }

						// 查询内存库已冲销帐单
                        if (iQryFlag != 0 && (iBeginTime / 100 <= Integer.parseInt(sCurYm) && iEndTime / 100 >= Integer.parseInt(sCurYm))) {
                            int iPayFlag = 0;
                            List<BillEntity> payeoweList = unbillEntity.getPayedOweList();
                            for (BillEntity payowe : payeoweList) {
                                if (payowe.getShouldPay() == 0 && payowe.getFavourFee() == 0) {
                                    continue;
                                }

                                if (iPayFlag == 0) {
                                    Map<String, Object> payDownTmp = new HashMap<String, Object>();

                                    payDownTmp.put("BILL_CYCLE", payowe.getBillCycle());
                                    payDownTmp.put("REAL_PAY", payowe.getShouldPay() - payowe.getFavourFee());
                                    payDownTmp.put("SHOULD_PAY", payowe.getShouldPay());
                                    payDownTmp.put("FAVOUR_FEE", payowe.getFavourFee());
                                    payDownTmp.put("PAYED_PREPAY", payowe.getPayedPrepay());
                                    payDownTmp.put("PAYED_LATER", payowe.getPayedLater());
                                    payDownTmp.put("OWE_FEE",
                                            payowe.getShouldPay() - payowe.getFavourFee() - payowe.getPayedPrepay() - payowe.getPayedLater());
                                    payDownTmp.put("DELAY_FEE", 0);
                                    payDownTmp.put("BILL_BEGIN", payowe.getBillBegin());
                                    payDownTmp.put("BILL_END", payowe.getBillEnd());
                                    payDownTmp.put("CONTRACT_NO", lContractNo);
                                    payDownTmp.put("ID_NO", payowe.getIdNo());

									// 取服务号码
                                    String addNo = "";
                                    addNo = user.getAddServiceNo(payowe.getIdNo(), "02");
                                    if (StringUtils.isEmptyOrNull(addNo)) {
                                        addNo = user.getAddServiceNo(payowe.getIdNo(), "16");
                                    }
                                    if (StringUtils.isEmptyOrNull(addNo)) {
										// 取服务号码
                                        try {
                                            UserInfoEntity uie = user.getUserEntity(payowe.getIdNo(), null, null, true);
                                            safeAddToMap(payDownTmp, "PHONE_NO", uie.getPhoneNo());
                                        } catch (BusiException e) {
                                            safeAddToMap(payDownTmp, "PHONE_NO", "99999999999");
                                        }
                                    } else {
                                        safeAddToMap(payDownTmp, "PHONE_NO", addNo);
                                    }

									payDownTmp.put("STATUS", "已缴");
                                    payDownInfoList.add(payDownTmp);
                                } else {
                                    for (Map<String, Object> payInfo : payDownInfoList) {
                                        if (getIntValue(payInfo, "BILL_CYCLE") == payowe.getBillCycle()
                                                && getLongValue(payInfo, "ID_NO") == payowe.getIdNo()) {
                                            safeAddToMap(payInfo, "REAL_PAY",
                                                    getLongValue(payInfo, "REAL_PAY") + payowe.getShouldPay() - payowe.getFavourFee());
                                            safeAddToMap(payInfo, "SHOULD_PAY", getLongValue(payInfo, "SHOULD_PAY") + payowe.getShouldPay());
                                            safeAddToMap(payInfo, "FAVOUR_FEE", getLongValue(payInfo, "FAVOUR_FEE") + payowe.getFavourFee());
                                            safeAddToMap(payInfo, "PAYED_PREPAY", getLongValue(payInfo, "PAYED_PREPAY") + payowe.getPayedPrepay());
                                            safeAddToMap(payInfo, "PAYED_LATER", getLongValue(payInfo, "PAYED_LATER") + payowe.getPayedLater());
                                            safeAddToMap(
                                                    payInfo,
                                                    "OWE_FEE",
                                                    getLongValue(payInfo, "OWE_FEE") + payowe.getShouldPay() - payowe.getFavourFee()
                                                            - payowe.getPayedPrepay() - payowe.getPayedLater());
                                            safeAddToMap(payInfo, "BILL_BEGIN",
                                                    getIntValue(payInfo, "BILL_BEGIN") < payowe.getBillBegin() ? getIntValue(payInfo, "BILL_BEGIN")
                                                            : payowe.getBillBegin());
                                            safeAddToMap(payInfo, "BILL_END",
                                                    getIntValue(payInfo, "BILL_END") > payowe.getBillBegin() ? getIntValue(payInfo, "BILL_END")
                                                            : payowe.getBillEnd());
                                        }
                                    }
                                }

                                iPayFlag++;
                            }
                        }
                    }
                }
            }
        }

		if (iInNetFlag == CommonConst.IN_NET) { // 默认取在网账户未冲销欠费
			// 取未冲销费用信息
            inMap.clear();
            inMap.put("CONTRACT_NO", lContractNo);
            if (lIdNo > 0) {
                inMap.put("ID_NO", lIdNo);
            }
            if (iWrtoffFlag > 0) {
                inMap.put("BILL_DAY", CommonConst.BATCHWRTOFF_BILL_DAY);
                inMap.put("NATURAL_MONTH", iWrtoffMonth);
            }
			if (iBeginTime != 0 && iEndTime != 0) { // 查询某段时间内的库内欠费信息
                inMap.put("BEGIN_CYCLE", iBeginTime / 100);
                inMap.put("END_CYCLE", iEndTime / 100);
            }
            List<Map<String, Object>> resultList = baseDao.queryForList("act_unpayowe_info.cQUnpayoweGroupBillCycle", inMap);

            long lIdNoTmp = 0;
            String sOnePhoneNo = "";

            for (Map<String, Object> unPayOweMap : resultList) {
                long lRealPay = 0;
                long lShouldPay = 0;
                long lFavourFee = 0;
                long lPayedLater = 0;
                long lPayedPrepay = 0;
                long lOweFee = 0;
                long lDelayFee = 0;
                int iYearMonth = 0;
                int iBillBegin = 0;
                int iBillEnd = 0;

                lRealPay = Long.valueOf(unPayOweMap.get("SHOULD_PAY").toString()) - Long.valueOf(unPayOweMap.get("FAVOUR_FEE").toString());
                lShouldPay = Long.valueOf(unPayOweMap.get("SHOULD_PAY").toString());
                lFavourFee = Long.valueOf(unPayOweMap.get("FAVOUR_FEE").toString());
                lPayedLater = Long.valueOf(unPayOweMap.get("PAYED_LATER").toString());
                lPayedPrepay = Long.valueOf(unPayOweMap.get("PAYED_PREPAY").toString());
                lOweFee = Long.valueOf(unPayOweMap.get("OWE_FEE").toString());
                iYearMonth = Integer.valueOf(unPayOweMap.get("BILL_CYCLE").toString());
                iBillBegin = Integer.valueOf(unPayOweMap.get("BILL_BEGIN").toString());
                iBillEnd = Integer.valueOf(unPayOweMap.get("BILL_END").toString());

                if (lShouldPay == 0 && lFavourFee == 0) {
                    continue;
                }

                if (lOweFee > 0) {
					// 取用户滞纳金
                    inMap.clear();
                    inMap.put("BILL_BEGIN", iBillBegin);
                    inMap.put("OWE_FEE", lOweFee);
                    inMap.put("DELAY_BEGIN", iDelayBegin);
                    inMap.put("DELAY_RATE", dDelayRate);
                    inMap.put("BILL_CYCLE", iYearMonth);
                    inMap.put("TOTAL_DATE", Integer.valueOf(sCurDate));
                    lDelayFee = delay.getDelayFee(inMap);
                }

                if (lIdNoTmp != Long.valueOf(unPayOweMap.get("ID_NO").toString())) {
					// 取代付用户号码
                    sOnePhoneNo = "";
                    String addNo = "";
                    addNo = user.getAddServiceNo(getLongValue(unPayOweMap, "ID_NO"), "02");
                    if (StringUtils.isEmptyOrNull(addNo)) {
                        addNo = user.getAddServiceNo(getLongValue(unPayOweMap, "ID_NO"), "16");
                    }
                    if (StringUtils.isEmptyOrNull(addNo)) {
						// 取服务号码
                        inMap = new HashMap<String, Object>();
                        safeAddToMap(inMap, "ID_NO", getLongValue(unPayOweMap, "ID_NO"));
                        try {
                            UserInfoEntity uie = user.getUserEntity(getLongValue(unPayOweMap, "ID_NO"), null, null, true);
                            sOnePhoneNo = uie.getPhoneNo();
                        } catch (BusiException e) {
                            try {
                                List<UserDeadEntity> udeList = user.getUserdeadEntity(null, getLongValue(unPayOweMap, "ID_NO"), null);
                                sOnePhoneNo = udeList.get(0).getPhoneNo();
                            } catch (BusiException e1) {
                                sOnePhoneNo = "99999999999";
                            }
                        }
                    } else {
                        sOnePhoneNo = addNo;
                    }

                    lIdNoTmp = Long.valueOf(unPayOweMap.get("ID_NO").toString());
                }

                Map<String, Object> oweMap = new HashMap<String, Object>();
                oweMap.put("BILL_CYCLE", iYearMonth);
                oweMap.put("REAL_PAY", lRealPay);
                oweMap.put("SHOULD_PAY", lShouldPay);
                oweMap.put("FAVOUR_FEE", lFavourFee);
                oweMap.put("PAYED_PREPAY", lPayedPrepay);
                oweMap.put("PAYED_LATER", lPayedLater);
                oweMap.put("OWE_FEE", lOweFee);
                oweMap.put("DELAY_FEE", lDelayFee);
                oweMap.put("BILL_BEGIN", iBillBegin);
                oweMap.put("BILL_END", iBillEnd);
                oweMap.put("CONTRACT_NO", lContractNo);
                oweMap.put("ID_NO", Long.valueOf(unPayOweMap.get("ID_NO").toString()));
                oweMap.put("PHONE_NO", sOnePhoneNo);
				oweMap.put("STATUS", "未缴");

                oweInfoList.add(oweMap);
            }

		} else { // 离网用户取呆坏账列表
            String sOnePhoneNo = "";
            inMap.clear();
            inMap.put("ID_NO", lIdNo);
            try {
                List<UserDeadEntity> udeList = user.getUserdeadEntity(null, lIdNo, null);
                sOnePhoneNo = udeList.get(0).getPhoneNo();
            } catch (BusiException e) {
                sOnePhoneNo = "99999999999";
            }

            inMap.put("CONTRACT_NO", lContractNo);
            List<Map<String, Object>> deadOweList = baseDao.queryForList("act_deadowe_info.qDeadOweByIdNoGroupCon", inMap);
            if (deadOweList.size() > 0) {
                for (Map<String, Object> deadOweMap : deadOweList) {
                    long lRealPay = 0;
                    long lShouldPay = 0;
                    long lFavourFee = 0;
                    long lPayedLater = 0;
                    long lPayedPrepay = 0;
                    long lOweFee = 0;
                    long lDelayFee = 0;
                    int iYearMonth = 0;
                    int iBillBegin = 0;
                    int iBillEnd = 0;
                    String sStatus = "";

                    lRealPay = Long.valueOf(deadOweMap.get("SHOULD_PAY").toString()) - Long.valueOf(deadOweMap.get("FAVOUR_FEE").toString());
                    lShouldPay = Long.valueOf(deadOweMap.get("SHOULD_PAY").toString());
                    lFavourFee = Long.valueOf(deadOweMap.get("FAVOUR_FEE").toString());

                    lPayedLater = Long.valueOf(deadOweMap.get("PAYED_LATER").toString());
                    lPayedPrepay = Long.valueOf(deadOweMap.get("PAYED_PREPAY").toString());

                    if (lShouldPay == 0 && lFavourFee == 0) {
                        continue;
                    }

                    lOweFee = Long.valueOf(deadOweMap.get("OWE_FEE").toString());
                    iYearMonth = Integer.valueOf(deadOweMap.get("BILL_CYCLE").toString());
                    iBillBegin = Integer.valueOf(deadOweMap.get("BILL_BEGIN").toString());
                    iBillEnd = Integer.parseInt(deadOweMap.get("BILL_END").toString());
                    sStatus = deadOweMap.get("STATUS").toString();

                    if (lOweFee > 0) {
						// 取用户滞纳金
                        inMap.clear();
                        inMap.put("BILL_BEGIN", iBillBegin);
                        inMap.put("OWE_FEE", lOweFee);
                        inMap.put("DELAY_BEGIN", iDelayBegin);
                        inMap.put("DELAY_RATE", dDelayRate);
                        inMap.put("BILL_CYCLE", iYearMonth);
                        inMap.put("TOTAL_DATE", Integer.valueOf(sCurDate));
                        lDelayFee = delay.getDelayFee(inMap);
                    }

                    Map<String, Object> oweMap = new HashMap<String, Object>();
                    oweMap.put("BILL_CYCLE", iYearMonth);
                    oweMap.put("REAL_PAY", lRealPay);
                    oweMap.put("SHOULD_PAY", lShouldPay);
                    oweMap.put("FAVOUR_FEE", lFavourFee);
                    oweMap.put("PAYED_PREPAY", lPayedPrepay);
                    oweMap.put("PAYED_LATER", lPayedLater);
                    oweMap.put("OWE_FEE", lOweFee);
                    oweMap.put("DELAY_FEE", lDelayFee);
                    oweMap.put("BILL_BEGIN", iBillBegin);
                    oweMap.put("BILL_END", iBillEnd);
                    oweMap.put("CONTRACT_NO", Long.valueOf(deadOweMap.get("CONTRACT_NO").toString()));
                    oweMap.put("ID_NO", lIdNo);
                    oweMap.put("PHONE_NO", sOnePhoneNo);
                    // if (sStatus.equals("1") || sStatus.equals("4")) {
					oweMap.put("STATUS", "未缴");
                    // } else if (sStatus.equals("3") || sStatus.equals("6")) {
					// oweMap.put("STATUS", "已缴");
                    // }

                    oweInfoList.add(oweMap);

                }
            }
        }

		if (iQryFlag != 0) { // 查询冲销帐单
			// 取库内已冲销帐单
            int iBeginYm = iBeginTime / 100;
            int iEndYm = iEndTime / 100;

            for (int iOneYm = iEndYm; iOneYm >= iBeginYm; iOneYm = Integer.valueOf(DateUtil.toStringMinusMonths(String.valueOf(iOneYm), 1, "yyyyMM"))) {

				// 按照用户ID分组取账户已冲销的费用
                long lIdNoTemp = 0;
                String sOnePhoneNo = "";
                inMap.clear();
                inMap.put("CONTRACT_NO", lContractNo);
                inMap.put("SUFFIX", String.valueOf(iOneYm));
				if (lIdNo > 0 && iInNetFlag == 0) { // 在网用户才取账户下用户冲销信息
                    inMap.put("ID_NO", lIdNo);
                }
                if (iWrtoffFlag > 0 && iInNetFlag == 0) {
                    inMap.put("BILL_DAY", CommonConst.BATCHWRTOFF_BILL_DAY);
                    inMap.put("NATURAL_MONTH", iWrtoffMonth);
                }

                List<BillEntity> resultList = baseDao.queryForList("act_payedowe_info.qPayedOweGroupIdNo", inMap);
                if (resultList.size() > 0) {
                    for (BillEntity resultMap : resultList) {
                        Map<String, Object> payDownTmp = new HashMap<String, Object>();

                        long lShouldPay = resultMap.getShouldPay();

                        long lFavourFee = resultMap.getFavourFee();

                        if (lShouldPay == 0 && lFavourFee == 0) {
                            continue;
                        }

                        payDownTmp.put("BILL_CYCLE", resultMap.getBillCycle());
                        payDownTmp.put("REAL_PAY", resultMap.getShouldPay() - resultMap.getFavourFee());
                        payDownTmp.put("SHOULD_PAY", resultMap.getShouldPay());
                        payDownTmp.put("FAVOUR_FEE", resultMap.getFavourFee());
                        payDownTmp.put("PAYED_PREPAY", resultMap.getPayedPrepay());
                        payDownTmp.put("PAYED_LATER", resultMap.getPayedLater());
                        payDownTmp.put("OWE_FEE", resultMap.getOweFee());
                        payDownTmp.put("DELAY_FEE", 0);
                        payDownTmp.put("BILL_BEGIN", resultMap.getBillBegin());
                        payDownTmp.put("BILL_END", resultMap.getBillEnd());
                        payDownTmp.put("CONTRACT_NO", lContractNo);
                        payDownTmp.put("ID_NO", resultMap.getIdNo());

                        if (lIdNoTemp != Long.valueOf(payDownTmp.get("ID_NO").toString())) {
							// 取代付用户号码
                            sOnePhoneNo = "";
                            String addNo = "";

                            addNo = user.getAddServiceNo(getLongValue(payDownTmp, "ID_NO"), "02");
                            if (StringUtils.isEmptyOrNull(addNo)) {
                                addNo = user.getAddServiceNo(getLongValue(payDownTmp, "ID_NO"), "16");
                            }
                            if (StringUtils.isEmptyOrNull(addNo)) {
								// 取服务号码
                                try {
                                    UserInfoEntity uie = user.getUserEntity(getLongValue(payDownTmp, "ID_NO"), null, null, false);
                                    sOnePhoneNo = uie.getPhoneNo();
                                } catch (BusiException e) {
                                    try {
                                        List<UserDeadEntity> udeList = user.getUserdeadEntity(null, getLongValue(payDownTmp, "ID_NO"), null);
                                        sOnePhoneNo = udeList.get(0).getPhoneNo();
                                    } catch (BusiException e1) {
                                        sOnePhoneNo = "99999999999";
                                    }
                                }
                            } else {
                                sOnePhoneNo = addNo;
                            }

                            lIdNoTemp = Long.valueOf(payDownTmp.get("ID_NO").toString());
                        }
                        payDownTmp.put("PHONE_NO", sOnePhoneNo);
						payDownTmp.put("STATUS", "已缴");

                        payDownInfoList.add(payDownTmp);
                    }
                }
            }
        }

        List<Map<String, Object>> oweList = new ArrayList<Map<String, Object>>();

        log.info("oweInfoList = " + oweInfoList.toString());

        for (Map<String, Object> oweInfoMap : oweInfoList) {
            int iBillCycle = getIntValue(oweInfoMap, "BILL_CYCLE");
            long lUserNo = getLongValue(oweInfoMap, "ID_NO");

            if (oweList.size() == 0) {
                oweList.add(oweInfoMap);
                continue;
            } else {
                int flag = 0;

                for (Map<String, Object> oweMap : oweList) {
                    int bill = getIntValue(oweMap, "BILL_CYCLE");
                    long idNo = getLongValue(oweMap, "ID_NO");

                    if (iBillCycle == bill && lUserNo == idNo) {
                        safeAddToMap(oweMap, "BILL_CYCLE", iBillCycle);
                        safeAddToMap(oweMap, "REAL_PAY", getLongValue(oweMap, "REAL_PAY") + getLongValue(oweInfoMap, "REAL_PAY"));
                        safeAddToMap(oweMap, "SHOULD_PAY", getLongValue(oweMap, "SHOULD_PAY") + getLongValue(oweInfoMap, "SHOULD_PAY"));
                        safeAddToMap(oweMap, "FAVOUR_FEE", getLongValue(oweMap, "FAVOUR_FEE") + getLongValue(oweInfoMap, "FAVOUR_FEE"));
                        safeAddToMap(oweMap, "PAYED_PREPAY", getLongValue(oweMap, "PAYED_PREPAY") + getLongValue(oweInfoMap, "PAYED_PREPAY"));
                        safeAddToMap(oweMap, "PAYED_LATER", getLongValue(oweMap, "PAYED_LATER") + getLongValue(oweInfoMap, "PAYED_LATER"));
                        safeAddToMap(oweMap, "OWE_FEE", getLongValue(oweMap, "OWE_FEE") + getLongValue(oweInfoMap, "OWE_FEE"));
                        safeAddToMap(oweMap, "DELAY_FEE", getLongValue(oweMap, "DELAY_FEE") + getLongValue(oweInfoMap, "DELAY_FEE"));
                        safeAddToMap(oweMap, "BILL_BEGIN",
                                getLongValue(oweMap, "BILL_BEGIN") < getLongValue(oweInfoMap, "BILL_BEGIN") ? getLongValue(oweMap, "BILL_BEGIN")
                                        : getLongValue(oweInfoMap, "BILL_BEGIN"));
                        safeAddToMap(oweMap, "BILL_END",
                                getLongValue(oweMap, "BILL_END") > getLongValue(oweInfoMap, "BILL_END") ? getLongValue(oweMap, "BILL_END")
                                        : getLongValue(oweInfoMap, "BILL_END"));
                        safeAddToMap(oweMap, "CONTRACT_NO", getLongValue(oweMap, "CONTRACT_NO"));
                        safeAddToMap(oweMap, "ID_NO", idNo);
                        safeAddToMap(oweMap, "PHONE_NO", getString(oweMap, "PHONE_NO"));
                        safeAddToMap(oweMap, "STATUS", getString(oweMap, "STATUS"));

                        flag++;

                        break;
                    }
                }

                if (flag > 0) {
                    continue;
                }

                oweList.add(oweInfoMap);
            }

        }

        List<Map<String, Object>> payDownList = new ArrayList<Map<String, Object>>();

        log.info("payDownInfoList = " + payDownInfoList.toString());

        for (Map<String, Object> payDownMap : payDownInfoList) {
            int iBillCycle = getIntValue(payDownMap, "BILL_CYCLE");
            long lUserNo = getLongValue(payDownMap, "ID_NO");

            if (payDownList.size() == 0) {
                payDownList.add(payDownMap);
                continue;
            } else {
                int flag = 0;

                for (Map<String, Object> payMap : payDownList) {
                    int bill = getIntValue(payMap, "BILL_CYCLE");
                    long idNo = getLongValue(payMap, "ID_NO");

                    log.info("iBillCycle = " + iBillCycle + " lUserNo = " + lUserNo + " bill = " + bill + " idNo = " + idNo);

                    if (iBillCycle == bill && lUserNo == idNo) {
                        safeAddToMap(payMap, "BILL_CYCLE", iBillCycle);
                        safeAddToMap(payMap, "REAL_PAY", getLongValue(payMap, "REAL_PAY") + getLongValue(payDownMap, "REAL_PAY"));
                        safeAddToMap(payMap, "SHOULD_PAY", getLongValue(payMap, "SHOULD_PAY") + getLongValue(payDownMap, "SHOULD_PAY"));
                        safeAddToMap(payMap, "FAVOUR_FEE", getLongValue(payMap, "FAVOUR_FEE") + getLongValue(payDownMap, "FAVOUR_FEE"));
                        safeAddToMap(payMap, "PAYED_PREPAY", getLongValue(payMap, "PAYED_PREPAY") + getLongValue(payDownMap, "PAYED_PREPAY"));
                        safeAddToMap(payMap, "PAYED_LATER", getLongValue(payMap, "PAYED_LATER") + getLongValue(payDownMap, "PAYED_LATER"));
                        safeAddToMap(payMap, "OWE_FEE", getLongValue(payMap, "OWE_FEE") + getLongValue(payDownMap, "OWE_FEE"));
                        safeAddToMap(payMap, "DELAY_FEE", getLongValue(payMap, "DELAY_FEE") + getLongValue(payDownMap, "DELAY_FEE"));
                        safeAddToMap(payMap, "BILL_BEGIN",
                                getLongValue(payMap, "BILL_BEGIN") < getLongValue(payDownMap, "BILL_BEGIN") ? getLongValue(payMap, "BILL_BEGIN")
                                        : getLongValue(payDownMap, "BILL_BEGIN"));
                        safeAddToMap(payMap, "BILL_END",
                                getLongValue(payMap, "BILL_END") > getLongValue(payDownMap, "BILL_END") ? getLongValue(payMap, "BILL_END")
                                        : getLongValue(payDownMap, "BILL_END"));
                        safeAddToMap(payMap, "CONTRACT_NO", getLongValue(payMap, "CONTRACT_NO"));
                        safeAddToMap(payMap, "ID_NO", idNo);
                        safeAddToMap(payMap, "PHONE_NO", getString(payMap, "PHONE_NO"));
                        safeAddToMap(payMap, "STATUS", getString(payMap, "STATUS"));

                        flag++;

                        break;
                    }
                }

                if (flag > 0) {
                    continue;
                }

                payDownList.add(payDownMap);
            }

        }

        log.info("payDownList = " + payDownList.toString());

        outParam.put("OWE_INFO_LIST", oweList);
        outParam.put("PAYDOWN_INFO_LIST", payDownList);

        return outParam;
    }

    @Override
    public TDDataEntity getTdData(String phoneNo, Long idNo) {
        Map<String, Object> inMap = new HashMap<>();
        if (idNo != null && idNo > 0) {
            safeAddToMap(inMap, "ID_NO", idNo);
        }

        if (org.apache.commons.lang.StringUtils.isNotEmpty(phoneNo)) {
            safeAddToMap(inMap, "PHONE_NO", phoneNo);
        }

        TDDataEntity result = (TDDataEntity) baseDao.queryForObject("act_tdgprsdata_info.queryTdDataInfo", inMap);

        return result;
    }

    @Override
    public ExFavOweFeeEntity getExFeeTotalInfo(Long idNo, Long contractNo, int yearMonth) {

        Map<String, Object> inMap = new HashMap<>();
        if (idNo != null && idNo > 0) {
            safeAddToMap(inMap, "ID_NO", idNo);
        }
        if (contractNo != null && contractNo > 0) {
            safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        }
        safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
        ExFavOweFeeEntity result = (ExFavOweFeeEntity) baseDao.queryForObject("act_exfavowe_info.getSumFeeInfo", inMap);
        return result;
    }

    @Override
    public Map<String, Object> getWriteOff(String payType, int pageNum) {

        Map<String, Object> inMap = new HashMap<String, Object>();
        List<WriteOffItemEntity> writeOffList = new ArrayList<WriteOffItemEntity>();
        inMap.put("PAY_TYPE", payType);

		// 查询冲销的账目项（三级）

        Map<String, Object> outMap = baseDao.queryForPagingList("bal_writeplan_conf.qWriteplan", inMap, pageNum, 10);
        List<ItemEntity> writeOffItemTmp = (List<ItemEntity>) outMap.get("result");
        int sum = ValueUtils.intValue(outMap.get("sum"));
        for (ItemEntity itemEnt : writeOffItemTmp) {
            BillItemEntity firstItem = this.getItemRelInfo(itemEnt.getItemCode(), CommonConst.PARENT_ITEMREL_LEVEL_1);
            BillItemEntity secondItem = this.getItemRelInfo(itemEnt.getItemCode(), CommonConst.PARENT_ITEMREL_LEVEL_2);
            if (firstItem == null || secondItem == null) {
                continue;
            }
            WriteOffItemEntity writeOffItem = new WriteOffItemEntity();
			// 根据三级账目项代码查询一级账目项和二级账目项
            writeOffItem.setFirstItemCode(firstItem.getParentItemId());
            writeOffItem.setFirstItemName(this.getBillItemConf(firstItem.getParentItemId()).getItemName());
            writeOffItem.setSecondItemCode(secondItem.getParentItemId());
            writeOffItem.setSecondItemName(this.getBillItemConf(secondItem.getParentItemId()).getItemName());

            writeOffItem.setThirdItemCode(itemEnt.getItemCode());
            writeOffItem.setThirdItemName(itemEnt.getItemName());

            writeOffList.add(writeOffItem);
        }

        log.debug("writeOffList=" + writeOffList.toString());
        outMap = new HashMap<String, Object>();
        outMap.put("WRITEOFF_LIST", writeOffList);
        outMap.put("SUM", sum);
        return outMap;
    }

    @Override
    public ItemRelEntity getItemList(Map<String, Object> inParam) {
        String itemLevel = getString(inParam, "ITEM_LEVEL");
        ItemRelEntity writeOff = new ItemRelEntity();
        if (itemLevel.equals(CommonConst.BILLTTEM_DISP_LEVEL_1)) {

            List<BillItemEntity> billItemList = this.getBillItemList(CommonConst.BILLTTEM_DISP_LEVEL_1);
            List<ItemEntity> itemList = new ArrayList<ItemEntity>();
            for (BillItemEntity billItem : billItemList) {
                ItemEntity item = new ItemEntity();
                item.setItemCode(billItem.getAcctItemCode());
                item.setItemName(billItem.getItemName());
                itemList.add(item);
            }
            writeOff.setFirstItemList(itemList);

        } else if (itemLevel.equals(CommonConst.BILLITEM_DISP_LEVEL_2)) {

			// 查询二级账目项
            List<BillItemEntity> billitemList = this.getBillItemList(CommonConst.BILLITEM_DISP_LEVEL_2);
            List<ItemEntity> itemList = new ArrayList<>();
            for (BillItemEntity billItem : billitemList) {
                ItemEntity item = new ItemEntity();
                item.setItemCode(billItem.getAcctItemCode());
                item.setItemName(billItem.getItemName());
                itemList.add(item);
            }
            writeOff.setSecondItemList(itemList);

        } else {
			// 查询三级列表
            List<BillItemEntity> billItemListTmp = this.getAcctItemList();
            List<ItemEntity> billItemList = new ArrayList<>();

            for (BillItemEntity billItem : billItemListTmp) {
                ItemEntity itemEnt = new ItemEntity();
                itemEnt.setItemCode(billItem.getAcctItemCode());
                itemEnt.setItemName(billItem.getItemName());
                billItemList.add(itemEnt);
            }
            writeOff.setThirdItemList(billItemList);
        }

        return writeOff;
    }

    @Override
    public Map<String, Object> getItemRel(String level, String itemCode, int pageNum) {

        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("CURRENT_LEVEL", level);
        inMap.put("ITEM_CODE", itemCode);

        Map<String, Object> outMap = baseDao.queryForPagingList("act_billitem_rel.qChildIdByItemId", inMap, pageNum, 10);
        if (outMap == null) {
			throw new BusiException(AcctMgrError.getErrorCode("8414", "00004"), "没有对应的子账目项");
        }
        return outMap;
    }

    @Override
    public Map<String, Object> getItemRelByChild(String itemCode, String parentLevel) {
        Map<String, Object> inMap = new HashMap<>();
        inMap.put("PARENT_LEVEL", parentLevel);
        inMap.put("ACCT_ITEM_CODE", itemCode);
        Map<String, Object> outMap = baseDao.queryForPagingList("act_billitem_rel.qParentIdByItemId", inMap, 1, 10);
        if (outMap == null) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "50005"), "未配置对应的父级账目项");
        }
        return outMap;
    }

    @Override
    public List<WriteOffItemEntity> getDownItem(String payType) {

        List<WriteOffItemEntity> downItemList = new ArrayList<WriteOffItemEntity>();
        // WriteOffItemEntity writeOffItem
        Map<String, Object> inMap = new HashMap<String, Object>();

        inMap.put("PAY_TYPE", payType);
        List<Map<String, Object>> downItemListTmp = baseDao.queryForList("bal_recoveryplan_conf.qRecoverPlan", inMap);
        if (downItemListTmp == null) {
			throw new BusiException(AcctMgrError.getErrorCode("8414", "00006"), "没有对应的落地账目项");
        }
        for (Map<String, Object> downItemMap : downItemListTmp) {
            String thirdItemCode = downItemMap.get("ACCT_ITEM_CODE").toString();
			// 查询对应的三级账目项名称
            BillItemEntity billItem = this.getItemConf(thirdItemCode);
            String thirdItemName = billItem.getItemName();

			// 查询对应的一级账目项和二级账目项
            Map<String, Object> outMap = getItemRelByChild(thirdItemCode, "0");
            System.err.println(outMap);
            List<Map<String, Object>> outList = (List<Map<String, Object>>) outMap.get("result");
            String firstItemCode = outList.get(0).get("ITEM_ID").toString();
            String firstItemName = outList.get(0).get("ITEM_NAME").toString();

            outMap = getItemRelByChild(thirdItemCode, "2");
            outList = (List<Map<String, Object>>) outMap.get("result");
            String secondItemCode = outList.get(0).get("ITEM_ID").toString();
            String secondItemName = outList.get(0).get("ITEM_NAME").toString();
            WriteOffItemEntity writeOff = new WriteOffItemEntity();
            writeOff.setFirstItemCode(firstItemCode);
            writeOff.setFirstItemName(firstItemName);
            writeOff.setSecondItemCode(secondItemCode);
            writeOff.setSecondItemName(secondItemName);
            writeOff.setThirdItemCode(thirdItemCode);
            writeOff.setThirdItemName(thirdItemName);
            downItemList.add(writeOff);
        }
        return downItemList;
    }

    @Override
    public BillItemEntity getItemConf(String acctItemCode) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "ACCT_ITEM_CODE", acctItemCode);
        BillItemEntity billItem = (BillItemEntity) baseDao.queryForObject("act_item_conf.qItemNameByItemCode", inMap);
        return billItem;
    }

    @Override
    public BillItemEntity getBillItemConf(String itemId) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "ITEM_ID", itemId);
        BillItemEntity billItem = (BillItemEntity) baseDao.queryForObject("act_billitem_conf.qItemNameByItemId", inMap);
        return billItem;
    }

    @Override
    public BillItemEntity getItemRelInfo(String itemId, String parentLevel) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "ITEM_ID", itemId);
        safeAddToMap(inMap, "PARENT_LEVEL", parentLevel);
        BillItemEntity billItem = (BillItemEntity) baseDao.queryForObject("act_billitem_rel.qItemRelByItemId", inMap);

        // if (billItem == null) {
		// throw new BusiException(AcctMgrError.getErrorCode("0000", "70001"), itemId + "没有对应的一级账目项和二级账目项");
        // }
        return billItem;

    }

    @Override
    public List<ItemEntity> getPayTypeItem(String payType) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        List<ItemEntity> writeOffList = new ArrayList<ItemEntity>();
        inMap.put("PAY_TYPE", payType);

		// 查询冲销的账目项（三级）
        writeOffList = baseDao.queryForList("bal_writeplan_conf.qWriteplan", inMap);

        return writeOffList;
    }

    @Override
    public List<BillItemEntity> getBillItemList(String itemLevel) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "ITEM_LEVEL", itemLevel);
        List<BillItemEntity> result = baseDao.queryForList("act_billitem_conf.qItemNameByItemId", inMap);

        if (result.isEmpty()) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "50004"), "指定级别的帐目项未配置（一级/二级）");
        }
        return result;
    }

    @Override
    public List<BillItemEntity> getAcctItemList() {

        List<BillItemEntity> result = baseDao.queryForList("act_item_conf.qItemNameByItemCode");
        if (result == null) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "50003"), "三级帐单帐目项未配置");
        }

        return result;
    }

    @Override
    public Map<String, Object> getTaxFee(long fee, String acctItem) {

        BillItemEntity itemEntity = getItemConf(acctItem);
        double taxRate = itemEntity.getNewTaxRate();
        long taxFee = Math.round(taxRate * (fee * 100 / (1 + taxRate)));

        Map outParam = new HashMap<String, Object>();
        outParam.put("TAX_RATE", taxRate);
        outParam.put("TAX_FEE", taxFee);
        return outParam;
    }

    @Override
    public int getMaxBillDay(Map<String, Object> inParam) {

        int billDay = (Integer) baseDao.queryForObject("act_payedowe_info.qMaxBillDay", inParam);

        return billDay;
    }

    @Override
    public List<Map<String, Object>> getWriteInfo(Map<String, Object> inParam) {
        List<Map<String, Object>> writeoffList = baseDao.queryForList("bal_writeoff_yyyymm.qWriteOffFee", inParam);
        return writeoffList;
    }

    @Override
    public List<BillDispDetailEntity> getGrpAllBillList(Long contractNo, int queryYm) {
		/* 集团帐单展示时，不需要查询未出帐账单 */
        return this.getAllBillList(null, contractNo, queryYm, false);
    }

    @Override
    public List<BillDispDetailEntity> getAllBillList(Long idNo, Long contractNo, int queryYm) {
        return this.getAllBillList(idNo, contractNo, queryYm, true);
    }

    private List<BillDispDetailEntity> getAllBillList(Long idNo, Long contractNo, int queryYm, boolean unbillFlag) {

        List<BillDispDetailEntity> outList = new ArrayList<>();
        List<BillDispDetailEntity> billList = new ArrayList<>();
        List<BillDispDetailEntity> unPayList = this.getUnPayBillList(idNo, contractNo, queryYm);
        List<BillDispDetailEntity> payedList = this.getPayedBillList(idNo, contractNo, queryYm);
        int curYm = DateUtils.getCurYm();
        if (unbillFlag && curYm == queryYm) {
            List<BillDispDetailEntity> unbillList = this.getUnBillList(idNo, contractNo);
            billList.addAll(unbillList);
        }
        billList.addAll(unPayList);
        billList.addAll(payedList);

        Map<String, BillDispDetailEntity> indexMap = new HashMap<>();

        for (BillDispDetailEntity detailEnt : billList) {
            String key = detailEnt.getAcctItemCode();

            if (!indexMap.containsKey(key)) {
                safeAddToMap(indexMap, key, detailEnt);
            } else {
                BillDispDetailEntity oldEnt = indexMap.get(key);
                BillDispDetailEntity newEnt = new BillDispDetailEntity();
                newEnt.setAcctItemCode(oldEnt.getAcctItemCode());
                newEnt.setItemName(oldEnt.getItemName());
                newEnt.setShouldPay(oldEnt.getShouldPay() + detailEnt.getShouldPay());
                newEnt.setFavourFee(oldEnt.getFavourFee() + detailEnt.getFavourFee());
                newEnt.setRealFee(oldEnt.getRealFee() + detailEnt.getRealFee());
            }
        }

        Set<String> keySet = indexMap.keySet();
        for (String key : keySet) {
            outList.add(indexMap.get(key));
        }

        return outList;
    }

    /**
	 * 功能：按帐目项分组，查询帐户下已冲销消费信息
	 *
	 * @param contractNo
	 * @param queryYm
	 * @return
	 */
    private List<BillDispDetailEntity> getPayedBillList(Long idNo, Long contractNo, int queryYm) {
        Map<String, Object> inMap = new HashMap<>();
        if (idNo != null && idNo > 0) {
            safeAddToMap(inMap, "ID_NO", idNo);
        }
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "BILL_CYCLE", queryYm);
        safeAddToMap(inMap, "SUFFIX", queryYm);

        List<BillDispDetailEntity> result = baseDao.queryForList("act_payedowe_info.qBillGroupByItem", inMap);

        return result;
    }

    /**
	 * 功能：按帐目项分组，查询帐户下未缴消费信息
	 *
	 * @param contractNo
	 * @param queryYm
	 * @return
	 */
    private List<BillDispDetailEntity> getUnPayBillList(Long idNo, Long contractNo, int queryYm) {
        Map<String, Object> inMap = new HashMap<>();
        if (idNo != null && idNo > 0) {
            safeAddToMap(inMap, "ID_NO", idNo);
        }
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "BILL_CYCLE", queryYm);

        List<BillDispDetailEntity> result = baseDao.queryForList("act_unpayowe_info.qBillGroupByItem", inMap);

        return result;
    }

    /**
	 * 功能：按帐目项分组，查询帐户下未出帐消费信息
	 *
	 * @param idNo
	 * @param contractNo
	 * @return
	 */
    private List<BillDispDetailEntity> getUnBillList(Long idNo, Long contractNo) {
        List<BillDispDetailEntity> result = new ArrayList<>();

        Map<String, String> indexMap = new HashMap<>();
        UnbillEntity unbillEnt = this.getUnbillFee(contractNo, idNo, CommonConst.UNBILL_TYPE_BILL_DET);
        List<BillEntity> unBillList = unbillEnt.getUnBillList();
        for (BillEntity billEnt : unBillList) {
            String acctItemCode = billEnt.getAcctItemCode();
            BillDispDetailEntity detEnt = new BillDispDetailEntity();
            detEnt.setAcctItemCode(acctItemCode);
            if (indexMap.containsKey(acctItemCode)) {
                detEnt.setItemName(indexMap.get(acctItemCode));
            } else {
                String itemName = this.getItemConf(acctItemCode).getItemName();
                detEnt.setItemName(itemName);

                indexMap.put(acctItemCode, itemName);
            }
            detEnt.setShouldPay(billEnt.getShouldPay());
            detEnt.setFavourFee(billEnt.getFavourFee());
            detEnt.setPayedPrepay(billEnt.getPayedPrepay());
            detEnt.setPayedLater(billEnt.getPayedLater());
            detEnt.setRealFee(billEnt.getRealFee());
            detEnt.setOweFee(billEnt.getOweFee());

            result.add(detEnt);
        }

        return result;
    }

    @Override
    public List<UserOweEntity> qOweUser(String phoneNo, String payStatus) {

        Map<String, Object> inMap = new HashMap<String, Object>();
        if (StringUtils.isNotEmptyOrNull(phoneNo)) {
            inMap.put("PHONE_NO", phoneNo);
        }
        if (StringUtils.isNotEmptyOrNull(payStatus)) {
            inMap.put("PAYED_STATUS", payStatus);
        }

        List<UserOweEntity> userList = baseDao.queryForList("act_presspayowe_info.qContractList", inMap);
        return userList;
    }

    @Override
    public List<UserOweEntity> qOweUserInfo(String phoneNo, long idNo) {

        Map<String, Object> inOweMap = new HashMap<String, Object>();
        inOweMap.put("PHONE_NO", phoneNo);
        if (StringUtils.isNotEmptyOrNull(idNo)) {
            inOweMap.put("ID_NO", idNo);
        }

        List<UserOweEntity> userList = baseDao.queryForList("act_presspayowe_info.qOweUserInfo", inOweMap);
        return userList;
    }

    @Override
    public List<UserOweEntity> qOweFeeInfo(String phoneNo, long idNo) {

        Map<String, Object> inOweMap = new HashMap<String, Object>();
        inOweMap.put("PHONE_NO", phoneNo);
        if (StringUtils.isNotEmptyOrNull(idNo)) {
            inOweMap.put("ID_NO", idNo);
        }

        List<UserOweEntity> userList = baseDao.queryForList("act_presspayowe_info.qOweInfo", inOweMap);
        return userList;
    }

    @Override
    public void updateOweUserInfo(String phoneNo, long idNo, String billYear, String billMonth, String loginNo, long paySn, String payedStatus,
                                  String oldStatus, String payAccept) {

        Map<String, Object> inMapTmp = new HashMap<String, Object>();
        inMapTmp.put("ID_NO", idNo);
        inMapTmp.put("PAY_SN", paySn);
        if (StringUtils.isNotEmptyOrNull(billYear)) {
            inMapTmp.put("BILL_YEAR", billYear);
        }
        inMapTmp.put("PHONE_NO", phoneNo);
        if (StringUtils.isNotEmptyOrNull(billMonth)) {
            inMapTmp.put("BILL_MONTH", billMonth);
        }
        if (StringUtils.isNotEmptyOrNull(loginNo)) {
            inMapTmp.put("LOGIN_NO", loginNo);
        }
        if (StringUtils.isNotEmptyOrNull(payedStatus)) {
            inMapTmp.put("PAYED_STATUS", payedStatus);
        }
        if (StringUtils.isNotEmptyOrNull(oldStatus)) {
            inMapTmp.put("OLD_STATUS", oldStatus);
        }
        if (StringUtils.isNotEmptyOrNull(payAccept)) {
            inMapTmp.put("PAY_ACCEPT", payAccept);
        }
        baseDao.update("act_presspayowe_info.uPressPayOwe", inMapTmp);
    }

    @Override
    public int getCollBillCnt(long contractNo, int yearMonth) {

        long codeClass = 108;
        String codeId = "HISBILLYM";
        String selDate = control.getPubCodeValue(codeClass, codeId, null);

        String suffix = "";
        if (yearMonth >= Integer.valueOf(selDate)) {
            suffix = String.valueOf(yearMonth);
        } else {
            suffix = "HIS";
        }

        Map<String, Object> paramMap = new HashMap<>();
        safeAddToMap(paramMap, "BILL_CYCLE", yearMonth);
        safeAddToMap(paramMap, "CONTRACT_NO", contractNo);
        safeAddToMap(paramMap, "SUFFIX", suffix);

        int cnt = (Integer) baseDao.queryForObject("act_payedowe_info.qConBillCnt", paramMap);

        return cnt;
    }

    @Override
    public List<CollOweStatusGroupEntity> getConBillInfo(long contractNo, int yearMonth, int pageSize, int pageNum) {

        long codeClass = 108;
        String codeId = "HISBILLYM";
        String selDate = control.getPubCodeValue(codeClass, codeId, null);

        String suffix = "";
        if (yearMonth >= Integer.valueOf(selDate)) {
            suffix = String.valueOf(yearMonth);
        } else {
            suffix = "HIS";
        }

        int endNum = pageSize * pageNum;
        int beginNum = pageSize * (pageNum - 1) + 1;

        List<CollOweStatusGroupEntity> outList = new ArrayList<>();

        Map<String, Object> paramMap = new HashMap<>();
        safeAddToMap(paramMap, "BILL_CYCLE", yearMonth);
        safeAddToMap(paramMap, "CONTRACT_NO", contractNo);
        safeAddToMap(paramMap, "BEGIN_NUM", beginNum);
        safeAddToMap(paramMap, "END_NUM", endNum);
        safeAddToMap(paramMap, "SUFFIX", suffix);
        List<CollOweStatusGroupEntity> conBillList = baseDao.queryForList("act_payedowe_info.qConBillGroupIdNoStatus", paramMap);
        for (CollOweStatusGroupEntity billMapEnt : conBillList) {
            UserInfoEntity uie = user.getUserEntityByIdNo(billMapEnt.getIdNo(), false);
            if (uie == null) {
                continue;
            }
            billMapEnt.setPhoneNo(uie.getPhoneNo());
            outList.add(billMapEnt);
        }

        return outList;

    }

    @Override
    public List<CollOweStatusGroupEntity> getConBillInfo(long contractNo, int yearMonth) {

        long codeClass = 108;
        String codeId = "HISBILLYM";
        String selDate = control.getPubCodeValue(codeClass, codeId, null);

        String suffix = "";
        if (yearMonth >= Integer.valueOf(selDate)) {
            suffix = String.valueOf(yearMonth);
        } else {
            suffix = "HIS";
        }

        List<CollOweStatusGroupEntity> outList = new ArrayList<>();

        Map<String, Object> paramMap = new HashMap<>();
        safeAddToMap(paramMap, "BILL_CYCLE", yearMonth);
        safeAddToMap(paramMap, "CONTRACT_NO", contractNo);
        safeAddToMap(paramMap, "SUFFIX", suffix);
        List<CollOweStatusGroupEntity> conBillList = baseDao.queryForList("act_payedowe_info.qConBillInfoByCon", paramMap);
        for (CollOweStatusGroupEntity billMapEnt : conBillList) {
            UserInfoEntity uie = user.getUserEntityByIdNo(billMapEnt.getIdNo(), false);
            if (uie == null) {
                continue;
            }
            billMapEnt.setPhoneNo(uie.getPhoneNo());
            outList.add(billMapEnt);
        }

        return outList;

    }

    @Override
    public int getMinBillCycle(long lContractNo) {

        Map<String, Object> inMapTmp = new HashMap<String, Object>();
        inMapTmp.put("CONTRACT_NO", lContractNo);
        Integer result = (Integer) baseDao.queryForObject("act_unpayowe_info.qMinCycleBycon", inMapTmp);
        if (result == null) {
            result = DateUtils.getCurYm();
        }

        return result;
    }

    @Override
    public List<ItemGroupBillEntity> getBillListByItemGroup(Long contractNo, int yearMonth, String itemGroupType) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "BILL_CYCLE", yearMonth);
        safeAddToMap(inMap, "ITEM_GROUP_TYPE", itemGroupType);

        List<ItemGroupBillEntity> unpayList = (List<ItemGroupBillEntity>) baseDao.queryForList("act_unpayowe_info.qItemGroupBill", inMap);

        safeAddToMap(inMap, "SUFFIX", yearMonth);
        List<ItemGroupBillEntity> payedList = (List<ItemGroupBillEntity>) baseDao.queryForList("act_payedowe_info.qItemGroupBill", inMap);

        List<ItemGroupBillEntity> result = new ArrayList<>();
        result.addAll(unpayList);
        result.addAll(payedList);
        return result;
    }


    public Map<String, Object> getBillDetailInfo(Map<String, Object> inMap, int pageNum) {

        log.error("IN_MAP: " + inMap.toString());
        if (pageNum == 1) {

            Map<String, Object> tmp = new HashMap<>();
            tmp.put("BILL_CYCLE", inMap.get("COUNT_YM"));
            tmp.put("REGION_ID", inMap.get("REGION_ID"));
            tmp.put("DISTRICT_GROUP", inMap.get("DISTRICT_GROUP"));
            tmp.put("QUERY_SN", inMap.get("QUERY_SN"));
            baseDao.insert("act_unpayowe_info.iForFeeDetail", tmp);
        }


        Map<String, Object> result = (Map<String, Object>) baseDao.queryForPagingList("act_unpayowe_info.qOweFeeDetail", inMap, pageNum, 25);

        return result;
    }

    @Override
    public Map<String, Object> getStopCheckOwe(long contractNo, int yearMonth) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "YEAR_MONTH", yearMonth);

        Map<String, Object> outMap = (Map<String, Object>) baseDao.queryForObject("dstop_check.qryOwe", inMap);
        return outMap;
    }

    @Override
    public Map<String, Long> getUnbillDxInfo(long contractNo, long idNo) {

        String userGroupId = user.getUserEntityByIdNo(idNo, true).getGroupId();
        String userRegionCode = group.getRegionDistinct(userGroupId, "2", control.getProvinceId(idNo)).getRegionCode();

        UserPrcEntity userMainPrcInfo = prod.getUserPrcidInfo(idNo);
        String halfFlag = userMainPrcInfo.getHalfFlag();
        String mainPrcId = userMainPrcInfo.getProdPrcid();

		// 获取0月租与底线二批代码列表
		List<PrcIdTransEntity> rateCodeList /* 存放用户订购资费的所有底线的二批代码 */= new ArrayList<>();
		Map<String /* 二批代码 */, String> indexMap = new HashMap<>(); /* 索引Map, 用来存放处理过的二批代码 */

        List<UserPrcEntity> userPrcList = prod.getPdPrcId(idNo, true);
        for (UserPrcEntity prcEnt : userPrcList) {
			List<PrcIdTransEntity> prcDetailList = billAccount.getDetailCodeList(prcEnt.getProdPrcid(), userRegionCode, "2,5"); /* detail_type in (2,5) 表示0月租及底线消费 */
            rateCodeList.addAll(prcDetailList);
        }

		String noFavCodeStr = control.getPubCodeValue(1051, null, null, true); // 1051配置 不参与优惠的二批代码字符串

        List<UnbillDetEntity> billDetList = this.getUnbillBillDetList(contractNo, idNo);

		long dxLeft = 0; // 此值为底线消费金额与用户套餐内最低消费相比，取的最小值；如底线50，用户实际消费30，则dxleft=30;若消费80，则dx_left = 50
        long dxPayMoney = 0;
        long dxFinalConsume = 0;
        long favourSum = 0;
        for (PrcIdTransEntity rateEnt : rateCodeList) {
            String detailCode = rateEnt.getDetailCode();
            String regionCode = rateEnt.getRegionCode();
            String prcId = rateEnt.getPrcId();

            String key = regionCode + "^" + detailCode;
			if (indexMap.containsKey(key)) { // 以防同一二批代码，多次处理
                continue;
            } else {
                safeAddToMap(indexMap, key, prcId);
            }

            long dxConsume = 0;
            long secFavourSum = 0;
            double halfRate = 0.00;

			if ("1".equals(halfFlag)) { // 半月收用户
                Double rateTmp = billAccount.getHalfRate(regionCode, prcId);
                halfRate = rateTmp == null ? 0 : rateTmp.doubleValue();
            }

            List<BillTotCodeEntity> billCodeList = billAccount.getBillTotCodeInfo(regionCode, detailCode);
            for (BillTotCodeEntity billCodeEnt : billCodeList) {
                String favourObject = billCodeEnt.getFavourObject();
                long favour1 = billCodeEnt.getFavour1();
                long favour2 = billCodeEnt.getFavour2();
                long favour3 = billCodeEnt.getFavour3();

                long dx_left = 0;
				if (favourObject.charAt(0) != '!') { // 包含的帐目项特殊处理
                    for (UnbillDetEntity detBillEnt : billDetList) {
                        String acctItemCode = detBillEnt.getAcctItemCode();
                        String feeCode = acctItemCode.substring(0, 2);
                        String detCode = acctItemCode.substring(acctItemCode.length() - (acctItemCode.charAt(2) - '0'));

                        if (favourObject.charAt(0) != '*') {
                            if (!feeCode.equals("XX")) {

                                if (favourObject.contains(feeCode)) {
                                    if (detBillEnt.getShouldPay() - detBillEnt.getFavourFee() >= favour1 + favour2 + favour3) {
                                        dx_left = favour1 + favour2 + favour3;
                                    } else {
                                        dx_left += detBillEnt.getShouldPay() - detBillEnt.getFavourFee();
                                    }

                                    if (noFavCodeStr.contains(detailCode)) {
                                        dx_left -= detBillEnt.getShouldPay() - detBillEnt.getFavourFee();
                                    }
                                }
                            }

                            if (favourObject.contains(detCode)) {
                                if (!noFavCodeStr.contains(detailCode)) {
                                    if (detBillEnt.getShouldPay() - detBillEnt.getFavourFee() >= favour1 + favour2 + favour3) {
                                        dx_left = favour1 + favour2 + favour3;
                                    } else {
                                        dx_left += detBillEnt.getShouldPay() - detBillEnt.getFavourFee();
                                    }
                                }
                            }


                        } else {
                            if (!feeCode.equals("XX")) {
                                if (!noFavCodeStr.contains(detailCode)) {
                                    dx_left += detBillEnt.getShouldPay() - detBillEnt.getFavourFee();
                                }
                            }

                        }

                    }


				} else { // 不包含的单独处理
                    favourObject = favourObject.substring(1);
                    for (UnbillDetEntity detBillEnt : billDetList) {
                        String acctItemCode = detBillEnt.getAcctItemCode();
                        String feeCode = acctItemCode.substring(0, 2);
                        String detCode = acctItemCode.substring(acctItemCode.length() - (acctItemCode.charAt(2) - '0'));
                        boolean firstFlag = false;
                        boolean secondFlag = false;
                        long firstSum = 0;
                        long secondSum = 0;
						if (favourObject.charAt(0) != '*') { // 全部帐目项
							if (!feeCode.equals("XX")) { // 过滤底线补足的帐单
                                if (!favourObject.contains(feeCode)) {
                                    firstFlag = true;
                                    if (detBillEnt.getShouldPay() - detBillEnt.getFavourFee() >= favour1 + favour2 + favour3) {
                                        firstSum = favour1 + favour2 + favour3;
                                    } else {
                                        firstSum = detBillEnt.getShouldPay() - detBillEnt.getFavourFee();
                                    }
                                }
                            }

                            if (!favourObject.contains(detCode)) {
                                if (!noFavCodeStr.contains(detCode)) {
                                    secondFlag = true;
                                    if (detBillEnt.getShouldPay() - detBillEnt.getFavourFee() >= favour1 + favour2 + favour3) {
                                        secondSum = favour1 + favour2 + favour3;
                                    } else {
                                        secondSum = detBillEnt.getShouldPay() - detBillEnt.getFavourFee();
                                    }
                                }
                            }

                            if (firstFlag && secondFlag) {
                                dx_left += (firstSum + secondSum) / 2;
                            }


                        } else {
                            if (!feeCode.equals("XX")) {
                                if (!noFavCodeStr.contains(detCode)) {
                                    dx_left += detBillEnt.getShouldPay() - detBillEnt.getFavourFee();

                                }
                            }
                        }

                    }

                }

                //
                secFavourSum += favour1 + favour2 + favour3;
                dxConsume += dx_left;
            }

            if (secFavourSum > favourSum) {
                dxPayMoney = secFavourSum;
                if (halfRate > 0) {
                    dxPayMoney = Math.round(BigDecimalUtils.mul(secFavourSum, 1 - halfRate));
                    secFavourSum = Math.round(BigDecimalUtils.mul(secFavourSum, 1 - halfRate));
                }

                favourSum = secFavourSum;
                dxFinalConsume = dxConsume;
            }

        }

        if (dxFinalConsume > favourSum) {
            dxLeft = 0;
        } else {
            dxLeft = Math.round(BigDecimalUtils.sub(favourSum, dxFinalConsume));
        }

        Map<String, Long> dxMap = new HashMap<>();
        safeAddToMap(dxMap, "DX_LEFT", dxLeft);
        safeAddToMap(dxMap, "DX_PAY_MONEY", dxPayMoney);

        return dxMap;

    }

    @Override
    public List<BillInfoDispEntity> getPayedBillList(long contractNo, int billCycle) {

        Map<String, Object> inMap = new HashMap<String, Object>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "SUFFIX", billCycle);
        List<BillInfoDispEntity> broadPayedBillList = (List<BillInfoDispEntity>) baseDao.queryForList("act_payedowe_info.qBillDetail", inMap);

        return broadPayedBillList;
    }

    @Override
    public long getPayedDelayFee(long contractNo, int billCycle) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "SUFFIX", billCycle);
        Map<String, Object> outParam = (Map<String, Object>) baseDao.queryForObject("bal_writeoff_yyyymm.qDelFeefromWrioff", inMap);

        long delayFee = ValueUtils.longValue(outParam.get("DELAY_FEE"));
        return delayFee;
    }

    @Override
    public List<BillInfoDispEntity> getUnpayBillList(long contractNo, int billCycle) {

        Map<String, Object> inMap = new HashMap<String, Object>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "BILL_CYCLE", billCycle);
        List<BillInfoDispEntity> broadUnpayBillList = (List<BillInfoDispEntity>) baseDao.queryForList("act_unpayowe_info.qBillDetail", inMap);

        return broadUnpayBillList;
    }

    @Override
    public List<BillEntity> getPayedOweGroupById(long contractNo, int yearMonth) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "SUFFIX", yearMonth);

        PubWrtoffCtrlEntity pwce = control.getWriteOffFlagAndMonth();
        int iWrtoffFlag = Integer.parseInt(pwce.getWrtoffFlag());
        int iWrtoffMonth = pwce.getWrtoffMonth();
        if (iWrtoffFlag == 1) {
            safeAddToMap(inMap, "BILL_DAY", CommonConst.BATCHWRTOFF_BILL_DAY);
            safeAddToMap(inMap, "NATURAL_MONTH", iWrtoffMonth);
        }

        List<BillEntity> outList = (List<BillEntity>) baseDao.queryForList("act_payedowe_info.qPayedOweGroupIdNo", inMap);

        return outList;
    }

    @Override
    public List<BillEntity> getUnPayOweGroupById(long contractNo, int yearMonth) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "BILL_CYCLE", yearMonth);

        PubWrtoffCtrlEntity pwce = control.getWriteOffFlagAndMonth();
        int iWrtoffFlag = Integer.parseInt(pwce.getWrtoffFlag());
        int iWrtoffMonth = pwce.getWrtoffMonth();
        if (iWrtoffFlag == 1) {
            safeAddToMap(inMap, "BILL_DAY", CommonConst.BATCHWRTOFF_BILL_DAY);
            safeAddToMap(inMap, "NATURAL_MONTH", iWrtoffMonth);
        }

        List<BillEntity> outList = (List<BillEntity>) baseDao.queryForList("act_unpayowe_info.qUnpayOweGroupIdNo", inMap);

        return outList;
    }


    /**
	 * 功能：将指定帐期下帐户下的所有消费录入帐单中间表<br>
	 * <p>
	 * idNo为0或小于0时，按帐户查询消费帐单
	 * </p>
	 * <p>
	 * idNo大于0时，查询此用户在此帐户下的消费帐单
	 * </p>
	 *
	 * @param contractNo
	 *            帐户号码，不能为空或0
	 * @param idNo
	 * @param yearMonth
	 */
    @Override
    public void saveMidAllBillFee(long contractNo, long idNo, int yearMonth) {

        if (idNo > 0) {
            this.saveMidAllBillFeeByIdNoAndContractNo(contractNo, idNo, yearMonth);
        } else {
            this.saveMidAllBillFeeByContractNo(contractNo, yearMonth);
        }

        // System.out.println("=>" + obj );
        // Integer count = (Integer)
        // baseDao.queryForObject("act_bill_mid.testSql0");
        // log.info("Act_Bill_Mid table count => " + count);
        // }

		/* 将费用信息按三级放到费用信息临时表中 */
        // baseDao.insert("act_billitem_mid.iActBillItemMid");

    }

    /**
	 * 功能：将用户idNo在此帐户contractNo指定帐期yearMonth消费录入帐单中间表
	 *
	 * @param contractNo
	 * @param idNo
	 * @param yearMonth
	 */
    private void saveMidAllBillFeeByIdNoAndContractNo(long contractNo, long idNo, int yearMonth) {

		/* 取出账标志和出账年月 */
        PubWrtoffCtrlEntity wrtoffCtrlEntity = control.getWriteOffFlagAndMonth();
        int iWrtoffFlag = Integer.parseInt(wrtoffCtrlEntity.getWrtoffFlag());
        int iBatchWrtoffMonth = wrtoffCtrlEntity.getWrtoffMonth();

        int iCurYM = DateUtils.getCurYm();
        this.insertBillMidFromPayedowe(idNo, contractNo, yearMonth, iWrtoffFlag, iBatchWrtoffMonth);

		/* 取未冲销帐单表中的帐单费用插入中间表 */
        this.insertBillMidFromUnpayowe(idNo, contractNo, yearMonth, iWrtoffFlag, iBatchWrtoffMonth);

        if (iCurYM == yearMonth || iCurYM == DateUtils.addMonth(yearMonth, -1)) {
            this.insertBillMidFromUnbillFee(idNo, contractNo);
        }
    }

    private void saveMidAllBillFeeByContractNo(long contractNo, int yearMonth) {
        int iCurYM = DateUtils.getCurYm();
		/* 取出账标志和出账年月 */
        PubWrtoffCtrlEntity wrtoffCtrlEntity = control.getWriteOffFlagAndMonth();
        int iWrtoffFlag = Integer.valueOf(wrtoffCtrlEntity.getWrtoffFlag());
        int iBatchWrtoffMonth = wrtoffCtrlEntity.getWrtoffMonth();

        this.insertBillMidFromPayedowe(0, contractNo, yearMonth, iWrtoffFlag, iBatchWrtoffMonth);

        this.insertBillMidFromUnpayowe(0, contractNo, yearMonth, iWrtoffFlag, iBatchWrtoffMonth);

        if (iCurYM == yearMonth || iCurYM == DateUtils.addMonth(yearMonth, -1)) {
			/* 取内存账单费用插入中间表 待定 */
			// 取内存账单不用循环取付费关系了。只用contract_no取就ok了
            this.insertBillMidFromUnbillFee(0, contractNo);
        }
    }

    private void insertBillMidFromPayedowe(long idNo, long contractNo, int yearMonth, int wrtoffFlag, int batchWrtoffMonth) {
        Map<String, Object> inMap = new HashMap<>();
        if (idNo > 0) {
            inMap.put("ID_NO", idNo);
        }
        inMap.put("CONTRACT_NO", contractNo);
        inMap.put("BILL_CYCLE", yearMonth);
        inMap.put("SUFFIX", String.valueOf(yearMonth));
        if (wrtoffFlag > 0) {
            inMap.put("BILL_DAY", BATCHWRTOFF_BILL_DAY);
            inMap.put("NATURAL_MONTH", batchWrtoffMonth);
        }
        inMap.put("EXCLUDE_ADJ", "TRUE");

        baseDao.insert("act_bill_mid.iActBillMidFromPayedowe", inMap);
    }

    private void insertBillMidFromUnpayowe(long idNo, long contractNo, int yearMonth, int iWrtoffFlag, int iBatchWrtoffMonth) {
        Map<String, Object> inMap = new HashMap<>();
        if (idNo > 0) {
            inMap.put("ID_NO", idNo);
        }
        inMap.put("CONTRACT_NO", contractNo);
        inMap.put("MIN_BILL_CYCLE", yearMonth);
        inMap.put("MAX_BILL_CYCLE", yearMonth);
        if (iWrtoffFlag > 0) {
            inMap.put("BILL_DAY", BATCHWRTOFF_BILL_DAY);
            inMap.put("NATURAL_MONTH", iBatchWrtoffMonth);
        }
        inMap.put("EXCLUDE_ADJ", "TRUE");
        baseDao.insert("act_bill_mid.iActBillMidFromUnPayOwe", inMap);
    }

    private void insertBillMidFromUnbillFee(long idNo, long contractNo) {
		/* 取内存欠费账单费用插入中间表 待定 */
        List<UnbillDetEntity> unbillList = this.getUnbillBillDetList(contractNo, idNo);
        for (UnbillDetEntity unbill : unbillList) {
            long lShouldPay = unbill.getShouldPay();
            long lFavourFee = unbill.getFavourFee();
            long lTaxFee = unbill.getTaxFee();

            Map<String, Object> unbillMap = new HashMap<String, Object>();
            unbillMap.put("CONTRACT_NO", unbill.getConNo());
            unbillMap.put("ID_NO", unbill.getIdNo());
            // unbillMap.put("PROD_PRCID", unbill.getProdPrcId());
            unbillMap.put("NATURAL_MONTH", unbill.getBillCycle());
            unbillMap.put("CYCLE_TYPE", unbill.getCycleType());
            unbillMap.put("BILL_CYCLE", unbill.getBillCycle());
            unbillMap.put("BILL_BEGIN", unbill.getBillBegin());
            unbillMap.put("BILL_TYPE", unbill.getBillType());
			unbillMap.put("BILL_DAY", 3600); // TODO 计费未返回billday
            unbillMap.put("ACCT_ITEM_CODE", unbill.getAcctItemCode());
            unbillMap.put("SHOULD_PAY", unbill.getShouldPay());
            unbillMap.put("FAVOUR_FEE", unbill.getFavourFee());
            unbillMap.put("PAYED_PREPAY", unbill.getPayedPrepay());
            unbillMap.put("PAYED_LATER", 0);
            unbillMap.put("BILL_END", unbill.getBillEnd());
            unbillMap.put("TAX_RATE", unbill.getTaxRate());
            unbillMap.put("TAX_FEE", unbill.getTaxFee());
            unbillMap.put("VAT_EXCLUDED", lShouldPay - lFavourFee - lTaxFee);
            baseDao.insert("act_bill_mid.iActBillMidFromUnbill", unbillMap);
        }
    }

    /**
	 * 功能：将指定帐期下离网帐户下的所有消费录入帐单中间表<br>
	 * <p>
	 * idNo为0或小于0时，按帐户查询消费帐单
	 * </p>
	 * <p>
	 * idNo大于0时，查询此用户在此帐户下的消费帐单
	 * </p>
	 *
	 * @param contractNo
	 *            帐户号码，不能为空或0
	 * @param idNo
	 * @param yearMonth
	 */
    @Override
    public void saveMidAllBillFeeDead(long contractNo, long idNo, int yearMonth) {

        if (idNo > 0) {
            this.saveMidAllBillFeeDeadByIdNoAndContractNo(contractNo, idNo, yearMonth);
        } else {
            this.saveMidAllBillFeeDeadByContractNo(contractNo, yearMonth);
        }

        // System.out.println("=>" + obj );
        // Integer count = (Integer)
        // baseDao.queryForObject("act_bill_mid.testSql0");
        // log.info("Act_Bill_Mid table count => " + count);
        // }

		/* 将费用信息按三级放到费用信息临时表中 */
        // baseDao.insert("act_billitem_mid.iActBillItemMid");

    }

    private void saveMidAllBillFeeDeadByContractNo(long contractNo, int yearMonth) {
        this.insertBillMidFromDeadowe(0, contractNo, yearMonth);
    }

    private void saveMidAllBillFeeDeadByIdNoAndContractNo(long contractNo, long idNo, int yearMonth) {
        this.insertBillMidFromDeadowe(idNo, contractNo, yearMonth);
    }

    private void insertBillMidFromDeadowe(long idNo, long contractNo, int yearMonth) {
        Map<String, Object> inMap = new HashMap<>();
        if (idNo > 0) {
            inMap.put("ID_NO", idNo);
        }
        inMap.put("CONTRACT_NO", contractNo);
        inMap.put("MIN_BILL_CYCLE", yearMonth);
        inMap.put("MAX_BILL_CYCLE", yearMonth);
        baseDao.insert("act_bill_mid.iActBillMidFromDeadOwe", inMap);
    }

    @Override
    public List<ItemGroupBillEntity> getAllBillListDetByItemGroup(Long contractNo, Long idNo, int yearMonth, String itemGroupType) {
        Map<String, Object> inMap = new HashMap<>();
        if (contractNo > 0) {
            inMap.put("CONTRACT_NO", contractNo);
        }
        if (idNo > 0) {
            inMap.put("ID_NO", idNo);
        }
        inMap.put("BILL_CYCLE", yearMonth);
        safeAddToMap(inMap, "ITEM_GROUP_TYPE", itemGroupType);
        List<ItemGroupBillEntity> result = baseDao.queryForList("act_bill_mid.qItemGroupBill", inMap);

        return result;
    }

    public IControl getControl() {
        return control;
    }

    public void setControl(IControl control) {
        this.control = control;
    }

    public IBalance getBalance() {
        return balance;
    }

    public void setBalance(IBalance balance) {
        this.balance = balance;
    }

    public IAccount getAccount() {
        return account;
    }

    public void setAccount(IAccount account) {
        this.account = account;
    }

    public IUser getUser() {
        return user;
    }

    public void setUser(IUser user) {
        this.user = user;
    }

    public IGroup getGroup() {
        return group;
    }

    public void setGroup(IGroup group) {
        this.group = group;
    }

    public IRecord getRecord() {
        return record;
    }

    public void setRecord(IRecord record) {
        this.record = record;
    }

    public IDelay getDelay() {
        return delay;
    }

    public void setDelay(IDelay delay) {
        this.delay = delay;
    }

    public IProd getProd() {
        return prod;
    }

    public void setProd(IProd prod) {
        this.prod = prod;
    }

    public IBillAccount getBillAccount() {
        return billAccount;
    }

    public void setBillAccount(IBillAccount billAccount) {
        this.billAccount = billAccount;
    }


}
