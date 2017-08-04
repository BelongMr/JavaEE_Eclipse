package com.sitech.acctmgr.atom.entity;

import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.account.ContractEntity;
import com.sitech.acctmgr.atom.domains.balance.BalanceFlagEnum;
import com.sitech.acctmgr.atom.domains.balance.BookSourceEntity;
import com.sitech.acctmgr.atom.domains.balance.BookTypeEnum;
import com.sitech.acctmgr.atom.domains.bill.*;
import com.sitech.acctmgr.atom.domains.prod.PdPrcInfoEntity;
import com.sitech.acctmgr.atom.domains.pub.PubWrtoffCtrlEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.CommonConst;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.jcfx.util.DateUtil;
import org.apache.commons.lang.StringUtils;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.util.*;

import static com.sitech.acctmgr.common.constant.CommonConst.*;
import static com.sitech.acctmgr.common.utils.ValueUtils.newHashMap;
import static org.apache.commons.collections.MapUtils.*;

//@SuppressWarnings({"unchecked", "rawtypes", "unused"})

public class BillDisplayer extends BaseBusi implements IBillDisplayer {
    private IAccount account;
    private IControl control;
    private IBill bill;
    private IUser user;
    private IBalance balance;
    private IProd prod;
    private IRemainFee remainFee;
    private IBillAccount billAccount;

    @Transactional(propagation = Propagation.REQUIRED)
    @Override
    public BillFeeInfo getBillFee(long id, int queryYM) {

        try {
            baseDao.getConnection().setAutoCommit(false);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        List<Long> famIds = user.getFamlilyIds(id);
        List<Long> idsList = new ArrayList<>();
        idsList.add(id);
        idsList.addAll(famIds);

        List<ContractEntity> contracts = account.getConList(id, queryYM);
        long defCon = 0;
        for (ContractEntity contract : contracts) {
            if (contract.getBillOrder() == 99999999) {
                defCon = contract.getCon();
                continue;
            }
            bill.saveMidAllBillFee(contract.getCon(), id, queryYM);
        }
        //自己账户下的帐单（含代他人付费）
        bill.saveMidAllBillFee(defCon, 0, queryYM);

        BillFeeInfo feeInfo = this.getBillFeeInfoFromMidByIdNo(idsList, defCon, queryYM);

        try {
            baseDao.getConnection().commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feeInfo;
    }

    private BillFeeInfo getBillFeeInfoFromMidByIdNo(List<Long> ids, long defCon, int queryYM) {
        BillFeeInfo feeInfo = new BillFeeInfo();
        Map<String, Object> param;
        Map<String, Object> tmpParam = new HashMap<String, Object>();
        safeAddToMap(tmpParam, "ID_NOS", ids);
        safeAddToMap(tmpParam, "YEAR_MONTH", queryYM);
        /*非固定套餐内帐单*/
        List<Map<String, Object>> billList = baseDao.queryForList("act_bill_mid.selectBillFeeInfo", tmpParam);

        /*获取代他人付费帐单*/
        BillFeeEntity otherBill = this.getBillFeeForOtherFromMid(ids, defCon, queryYM);

        long totalFee = 0;
        long favourFee = 0;
        for (int i = 1; i <= 10; i++) {

            Map<String, Object> feeMap = null;

            inner:
            for (Map<String, Object> map : billList) {
                String pid = getString(map, "PARENT_ITEM_ID");
                int parentId = Integer.parseInt(pid);

                if (parentId == i) {
                    feeMap = map;
                    break inner;
                }
            }

            long should = getLongValue(feeMap, "SHOULD_PAY");
            long favour = getLongValue(feeMap, "FAVOUR_FEE");
            long payed = getLongValue(feeMap, "PAYED_PREPAY");
            long later = getLongValue(feeMap, "PAYED_LATER");
            long fee = should - favour;

            switch (i) {
                case 1:
                    feeInfo.setFixedExp(fee);
                    break;
                case 2:
                    feeInfo.setCall(fee);
                    break;
                case 3:
                    feeInfo.setVideoFee(fee);
                    break;
                case 4:
                    feeInfo.setNetPlay(fee);
                    break;
                case 5:
                    feeInfo.setMessage(fee);
                    break;
                case 6:
                    feeInfo.setValueAdded(fee);
                    break;
                case 8:
                    feeInfo.setGroupFee(fee);
                    break;
                case 9:
                    feeInfo.setGeneration(fee);
                    break;
                case 10:
                    fee += otherBill.getRealFee();
                    favour += otherBill.getFavourFee();
                    feeInfo.setOtherExp(fee);
                    break;
                default:
                    break;
            }

            totalFee += fee;
            favourFee += favour;
        }

        feeInfo.setTotalFee(totalFee);
        feeInfo.setFavourFee(favourFee);

        return feeInfo;
    }

    @Transactional(propagation = Propagation.REQUIRED)
    @Override
    public BillFeeInfo2 getBillFee2(long id, int queryYM) {
        try {
            baseDao.getConnection().setAutoCommit(false);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        List<Long> famIds = user.getFamlilyIds(id);
        List<Long> idsList = new ArrayList<>();
        idsList.add(id);
        idsList.addAll(famIds);

        List<ContractEntity> contracts = account.getConList(id, queryYM);
        long defCon = 0;
        for (ContractEntity contract : contracts) {
            if (contract.getBillOrder() == 99999999) {
                defCon = contract.getCon();
                continue;
            }
            bill.saveMidAllBillFee(contract.getCon(), id, queryYM); //他人代付帐单
        }
        //自己账户下的帐单（含代他人付费）
        bill.saveMidAllBillFee(defCon, 0, queryYM);

        BillFeeInfo2 feeInfo = this.getBillFeeInfoFromMidByIdNo2(idsList, defCon, queryYM);

        try {
            baseDao.getConnection().commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feeInfo;
    }

    private BillFeeInfo2 getBillFeeInfoFromMidByIdNo2(List<Long> ids, long defCon, int queryYM) {
        BillFeeInfo2 feeInfo = new BillFeeInfo2();

        Map<String, Object> tmpParam = new HashMap<String, Object>();
        safeAddToMap(tmpParam, "ID_NOS", ids);
        safeAddToMap(tmpParam, "YEAR_MONTH", queryYM);
        List<Map<String, Object>> billList = baseDao.queryForList("act_bill_mid.selectBillFeeInfo", tmpParam);

        /*获取代他人付费帐单*/
        BillFeeEntity otherBill = this.getBillFeeForOtherFromMid(ids, defCon, queryYM);

        BillFeeEntity totalFee = new BillFeeEntity();

        for (int i = 1; i <= 10; i++) {

            Map<String, Object> feeMap = null;

            inner:
            for (Map<String, Object> map : billList) {
                String pid = getString(map, "PARENT_ITEM_ID");
                int parentId = Integer.parseInt(pid);

                if (parentId == i) {
                    feeMap = map;
                    break inner;
                }
            }

            long should = getLongValue(feeMap, "SHOULD_PAY");
            long favour = getLongValue(feeMap, "FAVOUR_FEE");
            long realFee = should - favour;
            long mobilePay = getLongValue(feeMap, "MOBILE_PAY");
            long custPay = getLongValue(feeMap, "CUST_PAY");

            BillFeeEntity fee = new BillFeeEntity(should, favour, realFee, mobilePay, custPay);

            switch (i) {
                case 1:
                    feeInfo.setFixedFee(fee);
                    break;
                case 2:
                    feeInfo.setCallFee(fee);
                    break;
                case 3:
                    feeInfo.setVideoFee(fee);
                    break;
                case 4:
                    feeInfo.setNetFee(fee);
                    break;
                case 5:
                    feeInfo.setMsgFee(fee);
                    break;
                case 6:
                    feeInfo.setSpFee(fee);
                    break;
                case 8:
                    feeInfo.setGroupFee(fee);
                    break;
                case 9:
                    feeInfo.setProxyFee(fee);
                    break;
                case 10:
                    feeInfo.setOtherFee(fee.add(otherBill)); //代他人付费，累加到其他费中
                    totalFee.add(otherBill);
                    break;
                default:
                    break;
            }

            totalFee = totalFee.add(fee);
        }

        /* XXXXXXXXXX 套餐及固定费 //黑龙江没有10个X的资费帐单，所以不再需要按10个X做合并展示帐单了 */
        /*Map<String, Object> param = new HashMap<String, Object>();
        safeAddToMap(param, "ID_NO", id);
        safeAddToMap(param, "YEAR_MONTH", queryYM);
        Map<String, Object> result = (Map<String, Object>) baseDao.queryForObject("act_bill_mid.selectPrcBillFee", param);
        long should = getLongValue(result, "SHOULD_PAY");
        long favour = getLongValue(result, "FAVOUR_FEE");
        long real = should - favour;
        long mobilePay = getLongValue(result, "MOBILE_PAY");
        long custPay = getLongValue(result, "CUST_PAY");
        BillFeeEntity fixFeeAdd = new BillFeeEntity(should, favour, real, mobilePay, custPay);
        feeInfo.setFixedFee(feeInfo.getFixedFee().add(fixFeeAdd));
        feeInfo.setTotalFee(totalFee.add(fixFeeAdd));*/

        feeInfo.setTotalFee(totalFee);
        //优惠出参特殊处理，只记favour字段
        BillFeeEntity favourFee = new BillFeeEntity(0, feeInfo.getTotalFee().getFavourFee(), 0, 0, 0);
        feeInfo.setFavourFee(favourFee);
        return feeInfo;
    }

    /**
     * 功能：获取帐户代他人付费
     *
     * @param ids
     * @param contractNo
     * @param queryYM
     * @return
     */
    private BillFeeEntity getBillFeeForOtherFromMid(List<Long> ids, long contractNo, int queryYM) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "BILL_CYCLE", queryYM);
        safeAddToMap(inMap, "EX_ID_NOS", ids);
        BillFeeEntity otherBill = (BillFeeEntity) baseDao.queryForObject("act_bill_mid.selectBillForOther", inMap);

        return otherBill;
    }

    @Override
    public Map<String, BillFeeEntity> getAgentFeeInfo(long idNo, int yearMonth) {
        UserInfoEntity userEnt = user.getUserEntity(idNo, null, null, true);
        long defCon = userEnt.getContractNo();

        BillFeeEntity grpBillFee = new BillFeeEntity(); // 集团代付
        BillFeeEntity perBillFee = new BillFeeEntity(); // 个人代付
        List<ContractEntity> conList = account.getConList(idNo, yearMonth);
        for (ContractEntity con : conList) {
            long agentContractNo = con.getCon();
            if (defCon == agentContractNo) {
                continue;
            }

            BillFeeEntity agentRealFee = bill.getBillFee(idNo, agentContractNo, yearMonth);

            boolean isGrpCon = account.isGrpCon(agentContractNo);
            if (isGrpCon) {
                grpBillFee = grpBillFee.add(agentRealFee);
            } else {
                perBillFee = perBillFee.add(agentRealFee);
            }
        }
        Map<String, BillFeeEntity> result = new HashMap<>();
        safeAddToMap(result, "PERSON_AGENT", perBillFee);
        safeAddToMap(result, "GROUP_AGENT", grpBillFee);
        return result;
    }

    @Override
    public String getSchemeInfo(String phoneNo, String brandId, String regionCode, Long fee) {

        Map<String, Object> arg0 = new HashMap<>();
        safeAddToMap(arg0, "PHONE_NO", phoneNo);
        safeAddToMap(arg0, "BRAND_ID", brandId);
        safeAddToMap(arg0, "REGION_CODE", regionCode);
        safeAddToMap(arg0, "TOTAL_FEE", fee);
        Map<String, Object> resultMap = (Map<String, Object>) baseDao.queryForObject("act_billscheme_conf.qSchemeInfo", arg0);
        String desc = null;
        String prodPrcid = getString(resultMap, "PROD_PRCID");
        String prodPrcDesc = getString(resultMap, "PROD_PRC_DESC");

        if (StringUtils.isEmpty(prodPrcDesc) && StringUtils.isEmpty(prodPrcid)) {
            desc = "";
        } else if (StringUtils.isNotEmpty(prodPrcDesc)) {
            desc = prodPrcDesc;
        } else if (StringUtils.isNotEmpty(prodPrcid)) {
            desc = prod.getPdPrcInfo(prodPrcid).getProdPrcDesc();
        }
        return desc;
    }

    @Override
    public SchemeInfoEntity getGprsSchemeInfo(String phoneNo, int yearMonth) {
        Map<String, Object> arg0 = new HashMap<>();
        safeAddToMap(arg0, "PHONE_NO", phoneNo);
        safeAddToMap(arg0, "STATIS_MONTH", yearMonth);

        SchemeInfoEntity schemeInfoEnt = (SchemeInfoEntity) baseDao.queryForObject("act_billscheme_info.qSchemeInfo", arg0);

        String tips = "";
        String addedTips = "";//附加套餐
        String prcSchemeInfo = "";//资费推荐信息
        String prcId = "";//资费代码

        if (schemeInfoEnt != null) {
            String goodsPrcDesc = schemeInfoEnt.getGoodsPrcDesc();
            String outSetFlow = schemeInfoEnt.getOutSetFlow();
            prcId = schemeInfoEnt.getPrcId();
            String prcName = schemeInfoEnt.getPrcName();
            String prcType = schemeInfoEnt.getPrcType();

            StringBuffer sb = new StringBuffer();
            sb.append("您上月使用流量已超出套餐赠送部分，流量超出").append(outSetFlow).append("MB,建议您选择更适合的流量资费套餐。");
            tips = sb.toString();

            if ("1".equals(prcType)) {
                addedTips = "如您需要取消原流量可选包，可拨打10086取消，原可选包本月剩余流量将不结转。 更多资费套餐介绍您可登录中国移动公司网站或到当地营业厅咨询。";
            }

            prcSchemeInfo = prcName + "," + goodsPrcDesc;

        } else {
            schemeInfoEnt = new SchemeInfoEntity();
        }

        schemeInfoEnt.setAddedTips(addedTips);
        schemeInfoEnt.setPrcId(prcId);
        schemeInfoEnt.setPrcSchemeInfo(prcSchemeInfo);
        schemeInfoEnt.setTips(tips);

        return schemeInfoEnt;
    }

    @Override
    public ConDetailDispEntity getContractDetail(long idNo, Integer yearMonth) {
        UserInfoEntity userMap = user.getUserEntityByIdNo(idNo, true);
        long defCon = userMap.getContractNo();

        List<ContractDetail> conDetailList = new ArrayList<>();
        List<ContractEntity> conList = account.getConList(idNo, yearMonth);
        for (ContractEntity conEnt : conList) {
            long conTmp = conEnt.getCon();
            if (account.isGrpCon(conTmp)) { //集团付费帐户不处理
                continue;
            }
            /*剔除合账分享、集团客户、家庭代付的账户、空中充值帐户*/
            if (conTmp != defCon && (conEnt.getAttType().equals("0") || conEnt.getAttType().equals("a"))) {
                continue;
            }
            //默认帐户或托收帐户获取普通预存款信息
            String payCode = conEnt.getPayCode();
            if (conTmp == defCon || payCode.equals("4")) {
                List<ContractDetail> conNormalFeeList = this.getNormalFeeInfo(conTmp, defCon, idNo, yearMonth, payCode);
                conDetailList.addAll(conNormalFeeList);
            }

            //所有的代付帐户均需按帐本类型展示专款的信息
            List<ContractDetail> conSpecialFeeList = this.getSpecialFeeInfo(conTmp, defCon, idNo, yearMonth);
            conDetailList.addAll(conSpecialFeeList);

        }

        List<ContractDetail> totalList = this.getTotalFeeList(conDetailList);
        conDetailList.addAll(totalList);

        long custBalance = 0;
        long mobBalance = 0;
        long totalBalance = 0;
        for (ContractDetail conDetail : totalList) {
            if (conDetail.getPresentFlag().equals("0")) {
                custBalance += conDetail.getCurrentBalance();
            } else {
                mobBalance += conDetail.getCurrentBalance();
            }
        }

        totalBalance = custBalance + mobBalance;

        ConDetailDispEntity conDispEnt = new ConDetailDispEntity();
        conDispEnt.setDetailList(conDetailList);
        conDispEnt.setCustBalance(custBalance);
        conDispEnt.setMobBalance(mobBalance);
        conDispEnt.setTotalBalance(totalBalance);

        return conDispEnt;
    }

    private List<ContractDetail> getTotalFeeList(List<ContractDetail> conDetailList) {
        ContractDetail custTotalDetail = new ContractDetail();
        ContractDetail mobTotalDetail = new ContractDetail();
        long custLastPrepalyTotal = 0;
        long mobLastPrepalyTotal = 0;
        long custIncomeTotal = 0;
        long mobIncomeTotal = 0;
        long custReturnFeeTotal = 0;
        long mobReturnFeeTotal = 0;
        long custBackFeeTotal = 0;
        long mobBackFeeTotal = 0;
        long custUsableFeeTotal = 0;
        long mobUsableFeeTotal = 0;
        long custOutGoTotal = 0;
        long mobOutGoTotal = 0;
        long custOtherOutGoTotal = 0;
        long mobOtherOutGoTotal = 0;
        long custCurBalanceTotal = 0;
        long mobCurBalanceTotal = 0;
        for (ContractDetail conDetail : conDetailList) {
            String presentFlag = conDetail.getPresentFlag();
            if (presentFlag.equals("0")) {
                custLastPrepalyTotal += conDetail.getLastBalance();
                custIncomeTotal += conDetail.getIncome();
                custReturnFeeTotal += conDetail.getReturnFee();
                custBackFeeTotal += conDetail.getBackFee();
                custUsableFeeTotal += conDetail.getUseableFee();
                custOutGoTotal += conDetail.getOutgo();
                custOtherOutGoTotal += conDetail.getOtherOutgo();
                custCurBalanceTotal += conDetail.getCurrentBalance();
            } else {
                mobLastPrepalyTotal += conDetail.getLastBalance();
                mobIncomeTotal += conDetail.getIncome();
                mobReturnFeeTotal += conDetail.getReturnFee();
                mobBackFeeTotal += conDetail.getBackFee();
                mobUsableFeeTotal += conDetail.getUseableFee();
                mobOutGoTotal += conDetail.getOutgo();
                mobOtherOutGoTotal += conDetail.getOtherOutgo();
                mobCurBalanceTotal += conDetail.getCurrentBalance();

            }
        }

        custTotalDetail.setPresentFlag("0");
        custTotalDetail.setConName("客户交费类-预存款合计金额(元)");
        custTotalDetail.setLastBalance(custLastPrepalyTotal);
        custTotalDetail.setIncome(custIncomeTotal);
        custTotalDetail.setReturnFee(custReturnFeeTotal);
        custTotalDetail.setBackFee(custBackFeeTotal);
        custTotalDetail.setUseableFee(custUsableFeeTotal);
        custTotalDetail.setOutgo(custOutGoTotal);
        custTotalDetail.setOtherOutgo(custOtherOutGoTotal);
        custTotalDetail.setCurrentBalance(custCurBalanceTotal);

        mobTotalDetail.setPresentFlag("1");
        mobTotalDetail.setConName("移动赠送类-预存款合计金额(元)");
        mobTotalDetail.setLastBalance(mobLastPrepalyTotal);
        mobTotalDetail.setIncome(mobIncomeTotal);
        mobTotalDetail.setReturnFee(mobReturnFeeTotal);
        mobTotalDetail.setBackFee(mobBackFeeTotal);
        mobTotalDetail.setUseableFee(mobUsableFeeTotal);
        mobTotalDetail.setOutgo(mobOutGoTotal);
        mobTotalDetail.setOtherOutgo(mobOtherOutGoTotal);
        mobTotalDetail.setCurrentBalance(mobCurBalanceTotal);


        List<ContractDetail> outList = new ArrayList<>();
        /*合计*/
        outList.add(custTotalDetail);
        outList.add(mobTotalDetail);

        return outList;
    }

    private List<ContractDetail> getNormalFeeInfo(long contractNo, long defContract, long idNo, int yearMonth, String payCode) {
        ContractDetail custPayFeeEnt = new ContractDetail();
        ContractDetail mobPayFeeEnt = new ContractDetail();
        custPayFeeEnt.setPresentFlag("0"); //客户付费类
        mobPayFeeEnt.setPresentFlag("1"); //移动赠送类

        //期初余额获取
        int queryYm = DateUtils.addMonth(yearMonth, -1);
        List<FeeEntity> lastPrepayList = balance.getInitialBalance(contractNo, queryYm, BalanceFlagEnum.CURRENT_VALID, BookTypeEnum.NORAML);
        if (lastPrepayList != null && lastPrepayList.size() > 0) {
            for (FeeEntity feeEnt : lastPrepayList) {
                String presentFlag = feeEnt.getPresentFlag();
                if (presentFlag.equals("0")) { //客户付费
                    custPayFeeEnt.setLastBalance(feeEnt.getMoney());
                } else { //移动赠费
                    mobPayFeeEnt.setLastBalance(feeEnt.getMoney());
                }
            }
        }

        //本期收入
        List<FeeEntity> inComeList = this.getInCome(contractNo, idNo, yearMonth, BookTypeEnum.NORAML);
        if (inComeList != null && inComeList.size() > 0) {
            for (FeeEntity feeEnt : inComeList) {
                String presentFlag = feeEnt.getPresentFlag();
                if (presentFlag.equals("0")) { //客户付费
                    custPayFeeEnt.setIncome(feeEnt.getMoney());
                } else { //移动赠费
                    mobPayFeeEnt.setIncome(feeEnt.getMoney());
                }
            }
        }

        //本期返回
        List<FeeEntity> returnFeeList = this.getReturnFee(contractNo, idNo, yearMonth, BookTypeEnum.NORAML);
        if (returnFeeList != null && returnFeeList.size() > 0) {
            for (FeeEntity feeEnt : returnFeeList) {
                String presentFlag = feeEnt.getPresentFlag();
                if (presentFlag.equals("0")) { //客户付费
                    custPayFeeEnt.setReturnFee(feeEnt.getMoney());
                } else { //移动赠费
                    mobPayFeeEnt.setReturnFee(feeEnt.getMoney());
                }
            }
        }

        //本期退费
        List<FeeEntity> backFeeList = this.getBackFee(contractNo, idNo, yearMonth, BookTypeEnum.NORAML);
        if (backFeeList != null && backFeeList.size() > 0) {
            for (FeeEntity feeEnt : backFeeList) {
                String presentFlag = feeEnt.getPresentFlag();
                if (presentFlag.equals("0")) { //客户付费
                    custPayFeeEnt.setBackFee(feeEnt.getMoney());
                } else { //移动赠费
                    mobPayFeeEnt.setBackFee(feeEnt.getMoney());
                }
            }
        }

        //消费支出、其他支出
        long idNoTmp = 0;
        if (defContract == contractNo) {
            idNoTmp = 0;
        } else {
            idNoTmp = idNo;
        }
        List<FeeEntity> outFeeList = this.getOutFee(contractNo, idNoTmp, yearMonth, BookTypeEnum.NORAML);
        if (outFeeList != null && outFeeList.size() > 0) {
            for (FeeEntity feeEnt : outFeeList) {
                String presentFlag = feeEnt.getPresentFlag();
                if (presentFlag.equals("0")) { //客户付费
                    custPayFeeEnt.setOutgo(feeEnt.getMoney());
                    custPayFeeEnt.setOtherOutgo(feeEnt.getOtherMoney());
                } else { //移动赠费
                    mobPayFeeEnt.setOutgo(feeEnt.getMoney());
                    mobPayFeeEnt.setOtherOutgo(feeEnt.getOtherMoney());
                }
            }
        }

        /*计算本期可用，本期可用＝上期结余＋本期收入＋本期返还＋本期退费*/
        custPayFeeEnt.setUseableFee(custPayFeeEnt.getLastBalance() + custPayFeeEnt.getIncome()
                + custPayFeeEnt.getReturnFee() + custPayFeeEnt.getBackFee());
        mobPayFeeEnt.setUseableFee(mobPayFeeEnt.getLastBalance() + mobPayFeeEnt.getIncome()
                + mobPayFeeEnt.getReturnFee() + mobPayFeeEnt.getBackFee());

        /*计算余额，余额＝上期结余＋本期收入＋本期返还＋本期退费－消费支出－其它支出*/
        custPayFeeEnt.setCurrentBalance(custPayFeeEnt.getUseableFee() - custPayFeeEnt.getOutgo()
                - custPayFeeEnt.getOtherOutgo());
        mobPayFeeEnt.setCurrentBalance(mobPayFeeEnt.getUseableFee() - mobPayFeeEnt.getOutgo()
                - mobPayFeeEnt.getOtherOutgo());

        String custPayName = "客户交费类-";
        String mobPayName = "移动赠送类-";
        String defAddName = "默认账户普通预存款";
        String collAddName = "托收账本";
        if (contractNo == defContract) {
            custPayFeeEnt.setConName(new StringBuilder().append(custPayName).append(defAddName).toString());
            mobPayFeeEnt.setConName(new StringBuilder().append(mobPayName).append(defAddName).toString());
        } else if (payCode.equals("4")) {
            custPayFeeEnt.setConName(new StringBuilder().append(custPayName).append(collAddName).toString());
            mobPayFeeEnt.setConName(new StringBuilder().append(mobPayName).append(collAddName).toString());
        }

        List<ContractDetail> normalFeeList = new ArrayList<>();
        normalFeeList.add(custPayFeeEnt);
        normalFeeList.add(mobPayFeeEnt);

        return normalFeeList;
    }

    private List<ContractDetail> getSpecialFeeInfo(long contractNo, long defContract, Long idNo, int yearMonth) {
        List<ContractDetail> outList = new ArrayList<>();

        final String custPayName = "客户交费类-";
        final String mobPayName = "移动赠送类-";
        final String defAddName = "默认账户";
        final String specialAddName = "专用预存款";

        Map<String, ContractDetail> payTypeFeeMap = new HashMap<>();
        //期初余额获取
        int queryYm = DateUtils.addMonth(yearMonth, -1);
        List<FeeEntity> lastPrepayList = balance.getInitialBalanceGroupByPayType(contractNo, queryYm, BalanceFlagEnum.CURRENT_VALID, BookTypeEnum.SPECIAL);
        if (lastPrepayList != null && lastPrepayList.size() > 0) {
            for (FeeEntity feeEnt : lastPrepayList) {
                String presentFlag = feeEnt.getPresentFlag();
                String payType = feeEnt.getType(); //一个payType只能归属客户付费或移动赠送中的一种

                StringBuilder custSB = new StringBuilder();
                if (presentFlag.equals("0")) { //客户付费
                    custSB.append(custPayName);
                } else { //移动赠费
                    custSB.append(mobPayName);
                }

                if (contractNo == defContract) {
                    custSB.append(defAddName).append(feeEnt.getTypeName()).append(specialAddName);
                } else {
                    custSB.append(feeEnt.getTypeName());
                }

                ContractDetail conDetail = new ContractDetail();
                conDetail.setPresentFlag(presentFlag);
                conDetail.setLastBalance(feeEnt.getMoney());
                conDetail.setConName(custSB.toString());

                payTypeFeeMap.put(payType, conDetail);

            }
        }

        //本期收入
        List<FeeEntity> inComeList = this.getInComeGroupByPayType(contractNo, idNo, yearMonth, BookTypeEnum.SPECIAL);
        if (inComeList != null && inComeList.size() > 0) {
            for (FeeEntity feeEnt : inComeList) {
                String payType = feeEnt.getType();
                if (payTypeFeeMap.containsKey(payType)) {
                    ContractDetail conDetail = payTypeFeeMap.get(payType);
                    conDetail.setIncome(feeEnt.getMoney());
                } else {
                    //期初余额表中不存在的帐本不处理
                    continue;
                }
            }
        }

        //本期返回
        List<FeeEntity> returnFeeList = this.getReturnFeeGroupByPayType(contractNo, idNo, yearMonth, BookTypeEnum.SPECIAL);
        if (returnFeeList != null && returnFeeList.size() > 0) {
            for (FeeEntity feeEnt : returnFeeList) {
                String payType = feeEnt.getType();
                if (payTypeFeeMap.containsKey(payType)) {
                    ContractDetail conDetail = payTypeFeeMap.get(payType);
                    conDetail.setReturnFee(feeEnt.getMoney());
                } else {
                    //期初余额表中不存在的帐本不处理
                    continue;
                }
            }
        }

        //本期退费
        List<FeeEntity> backFeeList = this.getBackFeeGroupByPayType(contractNo, idNo, yearMonth, BookTypeEnum.SPECIAL);
        if (backFeeList != null && backFeeList.size() > 0) {
            for (FeeEntity feeEnt : backFeeList) {
                String payType = feeEnt.getType();
                if (payTypeFeeMap.containsKey(payType)) {
                    ContractDetail conDetail = payTypeFeeMap.get(payType);
                    conDetail.setBackFee(feeEnt.getMoney());
                } else {
                    //期初余额表中不存在的帐本不处理
                    continue;
                }
            }
        }

        //消费支出、其他支出
        long idNoTmp = 0;
        if (defContract == contractNo) {
            idNoTmp = 0;
        } else {
            idNoTmp = idNo;
        }
        List<FeeEntity> outFeeList = this.getOutFeeGroupByPayType(contractNo, idNoTmp, yearMonth, BookTypeEnum.SPECIAL);
        if (outFeeList != null && outFeeList.size() > 0) {
            for (FeeEntity feeEnt : outFeeList) {
                String payType = feeEnt.getType();
                if (payTypeFeeMap.containsKey(payType)) {
                    ContractDetail conDetail = payTypeFeeMap.get(payType);
                    conDetail.setOutgo(feeEnt.getMoney());
                    conDetail.setOtherOutgo(feeEnt.getOtherMoney());
                } else {
                    //期初余额表中不存在的帐本不处理
                    continue;
                }
            }
        }

        Set<String> keySet = payTypeFeeMap.keySet();
        for (String key : keySet) {
            ContractDetail conDetail = payTypeFeeMap.get(key);

            /*计算本期可用，本期可用＝上期结余＋本期收入＋本期返还＋本期退费*/
            conDetail.setUseableFee(conDetail.getLastBalance() + conDetail.getIncome()
                    + conDetail.getReturnFee() + conDetail.getBackFee());

            /*计算余额，余额＝上期结余＋本期收入＋本期返还＋本期退费－消费支出－其它支出*/
            conDetail.setCurrentBalance(conDetail.getUseableFee() - conDetail.getOutgo()
                    - conDetail.getOtherOutgo());
            outList.add(conDetail);
        }

        return outList;
    }


    /**
     * 获取帐户本期收入
     *
     * @param contractNo
     * @param yearMonth
     * @param balanceType
     * @return
     */
    private List<FeeEntity> getInCome(Long contractNo, Long idNo, Integer yearMonth, BookTypeEnum balanceType) {
        balanceType = balanceType == null ? BookTypeEnum.ALL : balanceType;

        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
        if (balanceType.equals(BookTypeEnum.SPECIAL)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_SPECIAL);
        } else if (balanceType.equals(BookTypeEnum.NORAML)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_NORMAL);
        }

        return (List<FeeEntity>) baseDao.queryForList("bal_booksource_info.qIncome", inMap);
    }

    private List<FeeEntity> getInComeGroupByPayType(Long contractNo, Long idNo, Integer yearMonth, BookTypeEnum balanceType) {
        balanceType = balanceType == null ? BookTypeEnum.ALL : balanceType;

        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
        if (balanceType.equals(BookTypeEnum.SPECIAL)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_SPECIAL);
        } else if (balanceType.equals(BookTypeEnum.NORAML)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_NORMAL);
        }

        return (List<FeeEntity>) baseDao.queryForList("bal_booksource_info.qIncomeGroupByPayType", inMap);
    }

    /**
     * 获取本期返还金额
     *
     * @param contractNo
     * @param yearMonth
     * @param balanceType
     * @return
     */
    private List<FeeEntity> getReturnFee(Long contractNo, Long idNo, Integer yearMonth, BookTypeEnum balanceType) {
        balanceType = balanceType == null ? BookTypeEnum.ALL : balanceType;

        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
        if (balanceType.equals(BookTypeEnum.SPECIAL)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_SPECIAL);
        } else if (balanceType.equals(BookTypeEnum.NORAML)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_NORMAL);
        }
        return (List<FeeEntity>) baseDao.queryForList("bal_booksource_info.qReturnFee", inMap);
    }

    private List<FeeEntity> getReturnFeeGroupByPayType(Long contractNo, Long idNo, Integer yearMonth, BookTypeEnum balanceType) {
        balanceType = balanceType == null ? BookTypeEnum.ALL : balanceType;

        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
        if (balanceType.equals(BookTypeEnum.SPECIAL)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_SPECIAL);
        } else if (balanceType.equals(BookTypeEnum.NORAML)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_NORMAL);
        }
        return (List<FeeEntity>) baseDao.queryForList("bal_booksource_info.qReturnFeeGroupByPayType", inMap);
    }

    /**
     * 获取本期退费
     *
     * @param contractNo
     * @param yearMonth
     * @param balanceType
     * @return
     */
    private List<FeeEntity> getBackFee(Long contractNo, Long idNo, Integer yearMonth, BookTypeEnum balanceType) {
        balanceType = balanceType == null ? BookTypeEnum.ALL : balanceType;

        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
        if (balanceType.equals(BookTypeEnum.SPECIAL)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_SPECIAL);
        } else if (balanceType.equals(BookTypeEnum.NORAML)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_NORMAL);
        }
        safeAddToMap(inMap, "STATUS", new String[]{"4","6"}); // 退费类型
        return (List<FeeEntity>) baseDao.queryForList("bal_booksource_info.qOutFee", inMap);
    }

    private List<FeeEntity> getBackFeeGroupByPayType(Long contractNo, Long idNo, Integer yearMonth, BookTypeEnum balanceType) {
        balanceType = balanceType == null ? BookTypeEnum.ALL : balanceType;

        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
        if (balanceType.equals(BookTypeEnum.SPECIAL)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_SPECIAL);
        } else if (balanceType.equals(BookTypeEnum.NORAML)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_NORMAL);
        }
        safeAddToMap(inMap, "STATUS", new String[]{"4","6"}); // 退费类型
        return (List<FeeEntity>) baseDao.queryForList("bal_booksource_info.qOutFeeGroupByPayType", inMap);
    }

    @Override
    public List<FeeEntity> getOutFee(Long contractNo, Long idNo, Integer yearMonth, BookTypeEnum balanceType) {
        balanceType = balanceType == null ? BookTypeEnum.ALL : balanceType;

        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        if (idNo != null && idNo > 0) {
            safeAddToMap(inMap, "ID_NO", idNo);
        }
        if (balanceType.equals(BookTypeEnum.SPECIAL)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_SPECIAL);
        } else if (balanceType.equals(BookTypeEnum.NORAML)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_NORMAL);
        }
        safeAddToMap(inMap, "SUFFIX", String.format("%06d", yearMonth));
        return (List<FeeEntity>) baseDao.queryForList("bal_writeoff_yyyymm.qOutFees", inMap);
    }

    private List<FeeEntity> getOutFeeGroupByPayType(Long contractNo, Long idNo, Integer yearMonth, BookTypeEnum balanceType) {
        balanceType = balanceType == null ? BookTypeEnum.ALL : balanceType;

        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        if (idNo != null && idNo > 0) {
            safeAddToMap(inMap, "ID_NO", idNo);
        }
        if (balanceType.equals(BookTypeEnum.SPECIAL)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_SPECIAL);
        } else if (balanceType.equals(BookTypeEnum.NORAML)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_NORMAL);
        }
        safeAddToMap(inMap, "SUFFIX", String.format("%06d", yearMonth));
        return (List<FeeEntity>) baseDao.queryForList("bal_writeoff_yyyymm.qOutFeesGroupByPayType", inMap);
    }

    @Override
    public long getOutFee(Long contractNo, Integer yearMonth, BookTypeEnum balanceType) {
        balanceType = balanceType == null ? BookTypeEnum.ALL : balanceType;
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);

        if (balanceType.equals(BookTypeEnum.SPECIAL)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_SPECIAL);
        } else if (balanceType.equals(BookTypeEnum.NORAML)) {
            safeAddToMap(inMap, "SPECIAL_FLAG", CommonConst.BOOK_TYPE_NORMAL);
        }

        long outFee = 0;
        List<FeeEntity> feeList = this.getOutFee(contractNo, null, yearMonth, BookTypeEnum.ALL);
        for (FeeEntity feeEnt : feeList) {
            outFee += feeEnt.getMoney() + feeEnt.getOtherMoney();
        }

        return outFee;
    }

    /**
     * 获取帐户转出金额
     *
     * @param contractNo
     * @param yearMonth
     * @param balanceType
     * @return
     */
    private Long getTransOutFee(Long contractNo, Integer yearMonth, String balanceType) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
        safeAddToMap(inMap, "SPEC_FLAG", balanceType);
        safeAddToMap(inMap, "STATUS", new String[]{"5"}); // 转帐类型
        return (Long) baseDao.queryForObject("bal_booksource_info.qOutFee", inMap);
    }

    @Transactional(propagation = Propagation.REQUIRED)
    @Override
    public List<AppendixBill> getDetailBillInfo(long id, int queryYM) {

        try {
            baseDao.getConnection().setAutoCommit(false);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        List<Long> idsList = new ArrayList<>();
        List<Long> famIds = new ArrayList<>();
        famIds = user.getFamlilyIds(id);
        idsList.add(id);
        idsList.addAll(famIds);

        List<ContractEntity> conList = account.getConList(id, queryYM);
        log.debug("contracts : " + conList);

        long defCon = 0;
        for (ContractEntity contract : conList) {
            if (contract.getBillOrder() == 99999999) {
                defCon = contract.getCon();
                continue;
            }
            bill.saveMidAllBillFee(contract.getCon(), id, queryYM);
        }
        bill.saveMidAllBillFee(defCon, 0, queryYM);

        List<BillEntity> billList = this.getUserDetailBill0(idsList, null, queryYM, CommonConst.PARENT_ITEMREL_LEVEL_1); /*0:一级帐目（大类）展示*/

        List<BillEntity> otherBillList = this.getOtherUserDetailBill(idsList, defCon, queryYM);

        billList.addAll(otherBillList);

        List<AppendixBill> appdixList = this.getAppendixBill(billList);
        log.info("detailList.size():" + appdixList.size());

        try {
            baseDao.getConnection().commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appdixList;
    }

    /**
     * 代他人付费帐单明细
     * @param idNoList
     * @param contractNo
     * @param queryYm
     * @return
     */
    private List<BillEntity> getOtherUserDetailBill(List<Long> idNoList, Long contractNo, int queryYm) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        safeAddToMap(inMap, "EX_ID_NOS", idNoList);
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "YEAR_MONTH", queryYm);

        List<BillEntity> billList = baseDao.queryForList("act_bill_mid.qOtherUserDetailBill", inMap);
        return billList;
    }

    /**
     * 功能：指定父类等级，返回帐单明细，需要配合saveMidAllBillFee函数使用
     *
     * @param idNoList
     * @param queryYm
     * @param parentLevel
     * @return
     */
    private List<BillEntity> getUserDetailBill0(List<Long> idNoList, Long contractNo, int queryYm, String parentLevel) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        if (idNoList != null && idNoList.size() > 0) {
            safeAddToMap(inMap, "ID_NOS", idNoList);
        }
        if (contractNo != null && contractNo > 0) {
            safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        }
        safeAddToMap(inMap, "YEAR_MONTH", queryYm);
        safeAddToMap(inMap, "PARENT_LEVEL", parentLevel);

        List<BillEntity> billList = baseDao.queryForList("act_bill_mid.qUserDetailBill", inMap);
        return billList;
    }

    private List<BillDisp3LevelEntity> getUserDetailBill(List<Long> idNoList, Long contractNo, int queryYm, String parentLevel) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        if (idNoList != null && idNoList.size() > 0) {
            safeAddToMap(inMap, "ID_NOS", idNoList);
        }
        if (contractNo != null && contractNo > 0) {
            safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        }
        safeAddToMap(inMap, "YEAR_MONTH", queryYm);
        safeAddToMap(inMap, "PARENT_LEVEL", parentLevel);

        List<BillDisp3LevelEntity> billList = baseDao.queryForList("act_bill_mid.qUserBillGroupByItemCode", inMap);
        return billList;
    }

    /**
     * 功能：将用户明细帐单转化成附录页帐单格式实体列表
     *
     * @param billList
     * @return
     */
    private List<AppendixBill> getAppendixBill(List<BillEntity> billList) {

        log.info("size :=> " + billList.size());
        Map<String, List<BillEntity>> rmap = new HashMap<>();
        List<AppendixBill> appendix = new ArrayList<AppendixBill>();
        List<BillEntity> list = null;

        for (BillEntity bill : billList) {
            String prodPrcId = bill.getProdPrcId();
            String itemCode = bill.getAcctItemCode();
            log.debug("itemCode=[" + itemCode + "] prodPrcId=[" + prodPrcId + "]"); // wangyla

            boolean isProdPrcFlag = false; //true：按资费名称合并展示帐单；false：按帐目项名称合并展示帐单

			/*
             * 优先看是否存在有不是10个大写X的账单，先按prod_prcid group by 展示成资费名称
			 * 然后再将剩下的prod_prcid 是10个X的账单，按账目项 group by 展示成账目项名称 modified by
			 * wangyla 20150327
			 */
            String key = null;
            /*
            //吉林按10个X展示
            if (!prodPrcId.equals("XXXXXXXXXX")) {
                isProdPrcFlag = true;
                key = prodPrcId + "." + "0000000001" + "." + String.valueOf(isProdPrcFlag);
            } else {
                isProdPrcFlag = false;
                key = itemCode + "." + bill.getParentItemId() + "." + String.valueOf(isProdPrcFlag);
            }*/
            //黑龙江帐单中没有“XXXXXXXXXX”的帐单，全部按帐目项合并展示
            {
                isProdPrcFlag = false;
                key = itemCode + "." + bill.getParentItemId() + "." + String.valueOf(isProdPrcFlag);
            }

            list = rmap.get(key); /* 先从Map中取列表 */
            if (null == list) {/* 不存在 */
                list = new ArrayList<BillEntity>();
            }
            list.add(bill);
            safeAddToMap(rmap, key, list);
        }

        Set<String> keySet = rmap.keySet();
        Iterator<String> iter = keySet.iterator();

        while (iter.hasNext()) {
            AppendixBill ab = new AppendixBill();
            String k = iter.next();
            List<BillEntity> blist = rmap.get(k);
            long realFee = 0; //按帐目项分组后总实收金额
            long should = 0; //按帐目项分组后总消费金额
            long favour = 0;//按帐目项分组后总减免金额
            long custPay = 0;//按帐目项分组后总客户付费支付金额
            long mobPay = 0;//按帐目项分组后总移动赠费支付金额
            for (BillEntity be : blist) {
                realFee += be.getShouldPay() - be.getFavourFee();
                should += be.getShouldPay();
                favour += be.getFavourFee();
                custPay += be.getCustPay();
                mobPay += be.getMobilePay();
            }
            if (realFee == 0) {
                continue;
            }
            String[] arr = k.split("\\.");
            log.debug("arr[2]=" + arr[2]);
            ab.setShouldPay(should);
            ab.setFavourFee(favour);
            ab.setRealFee(realFee);
            ab.setCustPay(custPay);
            ab.setMobilePay(mobPay);
            ab.setItemId(arr[0]); // 这里指明资费ID或者账目项ID
            String itemName = null;
            if (Boolean.valueOf(arr[2])) {
                PdPrcInfoEntity pdPrcInfo = prod.getPdPrcInfo(arr[0]);
                itemName = (pdPrcInfo == null) ? "--" : pdPrcInfo.getProdPrcName();// 取资费名称
            } else {
                itemName = bill.getItemConf(arr[0]).getItemName();
            }
            ab.setParentItemId(arr[1]);
            ab.setItemName(itemName);
            log.debug("item_id=" + arr[0] + "parent_item_id=" + arr[1]);
            appendix.add(ab);
        }
        return appendix;
    }

    @Override
    public SpDispEntity getSpDetailinfo(String phoneNo, Long idNo, int yearMonth) {

        if ((idNo == null || idNo == 0) && !phoneNo.isEmpty()) {
            UserInfoEntity uie = user.getUserEntityByPhoneNo(phoneNo, true);
            idNo = uie.getIdNo();
        }

        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "NATURAL_MONTH", yearMonth);
        safeAddToMap(inMap, "ID_NO", idNo);
        if (!phoneNo.isEmpty()) {
            safeAddToMap(inMap, "PHONE_NO", phoneNo);
        }
        List<SpDetailBill> spList = (List<SpDetailBill>) baseDao.queryForList("act_spinfo_info.qDetailSpInfo", inMap);

        long totalSpFee = 0;
        for (SpDetailBill spEnt : spList) {
            if (!spEnt.getServCode().startsWith("106")) {
                spEnt.setServCode("-");
            }
            spEnt.setSpName(billAccount.getSpName(spEnt.getSpCode()));
            spEnt.setOperName(billAccount.getOperName(spEnt.getSpCode(), spEnt.getOperCode()));
            totalSpFee += spEnt.getOperFee();
        }

        SpDispEntity spInfo = new SpDispEntity();
        spInfo.setTotalFee(totalSpFee);
        spInfo.setSpList(spList);

        return spInfo;
    }

    @Override
    public List<IncomeBill> getDetailIncome(long con, Integer yearMonth) {
        Map<String, Object> param = new HashMap<String, Object>();
        safeAddToMap(param, "CONTRACT_NO", con);
        safeAddToMap(param, "YEAR_MONTH", yearMonth);
        List<BookSourceEntity> bookList = balance.getBookSourceList(param);
        List<IncomeBill> billList = new ArrayList<IncomeBill>();

        for (BookSourceEntity bse : bookList) {

            IncomeBill ib = new IncomeBill();

            String status = bse.getStatus();
            String statusName = null;
            long payFee = bse.getPayFee();
            String opTime = bse.getOpTime();
            String note = bse.getRemark();
            String typeName = bse.getPayName();
            String attr = bse.getPayAttr();

            if (status.equals("0")) {
                statusName = "充值及交费";
            } else if (status.equals("2")) {
                statusName = "分月返还";
            } else if (status.equals("4")) {
                statusName = "退费";
            } else if (status.equals("5")) {
                statusName = "转账";
            } else {
                statusName = "充值";
            }

            ib.setOpTime(opTime);
            ib.setPayFee(payFee);
            ib.setStatusName(statusName);
            ib.setRemark(note);
            ib.setPayName(typeName);
            ib.setAttr(attr);
            ib.setCon(bse.getContractNo());

            billList.add(ib);
        }
        return billList;
    }

    /*获取帐单附录页入帐明细信息*/
    @Override
    public ConDetailAppendixDispEntity getAppendixConDetailInfo(long idNo, Integer yearMonth) {
        ConDetailAppendixDispEntity conDetailInfo = new ConDetailAppendixDispEntity();

        UserInfoEntity userMap = user.getUserEntityByIdNo(idNo, true);
        long defCon = userMap.getContractNo();

        int lastYm = DateUtils.addMonth(yearMonth, -1);

        long totalLastPrepay = 0;
        long totalOutFee = 0;
        long totalIncome = 0;
        Map<String, Object> inMap = null;
        List<IncomeBill> billList = new ArrayList<IncomeBill>();
        List<BookSourceEntity> allIncomeList = new ArrayList<>();
        List<ContractEntity> conList = account.getConList(idNo, yearMonth);
        for (ContractEntity conEnt : conList) {
            long conTmp = conEnt.getCon();
            if (account.isGrpCon(conTmp)) { //集团付费帐户不处理
                continue;
            }
            /*剔除合账分享、集团客户、家庭代付的账户、空中充值帐户*/
            if (conTmp != defCon && (conEnt.getAttType().equals("0") || conEnt.getAttType().equals("a"))) {
                continue;
            }

            inMap = new HashMap<String, Object>();
            safeAddToMap(inMap, "CONTRACT_NO", conTmp);
            safeAddToMap(inMap, "YEAR_MONTH", yearMonth);
            List<BookSourceEntity> incomeList = balance.getBookSourceList(inMap);
            allIncomeList.addAll(incomeList);

            long lastPrepay = balance.getInitialBalance(conTmp, lastYm, BalanceFlagEnum.CURRENT_VALID);
            totalLastPrepay += lastPrepay;

            long outFee = this.getOutFee(conTmp, yearMonth, BookTypeEnum.ALL);
            totalOutFee += outFee;
        }

        for (BookSourceEntity incomeEnt : allIncomeList) {
            IncomeBill ib = new IncomeBill();
            long payFee = incomeEnt.getPayFee();
            String status = incomeEnt.getStatus();
            String opTime = incomeEnt.getOpTime();
            String note = incomeEnt.getRemark();
            String typeName = incomeEnt.getPayName();
            String attr = incomeEnt.getPayAttr();

            String statusName = null;
            if (status.equals("0")) {
                statusName = "充值及交费";
            } else if (status.equals("2")) {
                statusName = "分月返还";
            } else if (status.equals("4")) {
                statusName = "退费";
            } else if (status.equals("5")) {
                statusName = "转账";
            } else {
                statusName = "充值";
            }

            ib.setOpTime(opTime);
            ib.setPayFee(payFee);
            ib.setStatusName(statusName);
            ib.setRemark(note);
            ib.setPayName(typeName);
            ib.setAttr(attr);
            ib.setCon(incomeEnt.getContractNo());
            billList.add(ib);

            totalIncome += payFee;
        }

        long totalBalance = totalLastPrepay + totalIncome - totalOutFee;
        conDetailInfo.setLastPrepay(totalLastPrepay);
        conDetailInfo.setIncome(totalIncome);
        conDetailInfo.setOutFee(totalOutFee);
        conDetailInfo.setCurBalance(totalBalance);
        conDetailInfo.setIncomeList(billList);

        return conDetailInfo;
    }

    @Override
    public List<BillDispEntity> getBillDetail(Long idNo, Long contractNo, int yearMonth, String parentItemId) {

        String parentShowName = bill.getBillItemConf(parentItemId).getItemName();

        HashMap<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "CONTRACT_NO", contractNo);
        safeAddToMap(inMap, "BILL_CYCLE", yearMonth);
        safeAddToMap(inMap, "PARENT_ITEM_ID", parentItemId);
        List<BillDispEntity> outList = baseDao.queryForList("act_bill_mid.selectBillDetail", inMap);
        for (BillDispEntity billEnt : outList) {
            String parentItemIdTmp = billEnt.getParentItemId();
            billEnt.setParentShowName(parentShowName);
            long oweFee = 0;
            oweFee = billEnt.getShouldPay() - billEnt.getFavourFee() - billEnt.getPayedPrepay() - billEnt.getPayedLater();
            billEnt.setOweFee(oweFee);
            billEnt.setRealFee(billEnt.getShouldPay() - billEnt.getFavourFee());
            if (oweFee > 0) {
                billEnt.setPayedStatusName("未缴");
            } else {
                billEnt.setPayedStatusName("已缴");
            }
        }
        return outList;
    }

    @Override
    public List<SevenBillDispEntity> getSevenBill(Long idNo, Long contractNo, int yearMonth, String feeCode) {
        return this.getSevenBill(idNo, contractNo, yearMonth, feeCode, CommonConst.IN_NET);
    }

    @Override
    public List<SevenBillDispEntity> getSevenBillDead(Long idNo, Long contractNo, int yearMonth, String feeCode) {
        return this.getSevenBill(idNo, contractNo, yearMonth, feeCode, CommonConst.NO_NET);
    }

    private List<SevenBillDispEntity> getSevenBill(Long idNo, Long contractNo, int yearMonth, String feeCode, int onLineFlag) {
        if (onLineFlag == CommonConst.IN_NET) {
            bill.saveMidAllBillFee(contractNo, idNo, yearMonth);
        } else if (onLineFlag == CommonConst.NO_NET) {
            bill.saveMidAllBillFeeDead(contractNo, idNo, yearMonth);
        }

        long shouldPay;
        long favourFee;
        long payedPrepay;
        long payedLater;
        long oweFee;
        boolean exitsFeeCodeBillFlag; // 是否有对应的一级帐帐目项帐单
        List<SevenBillDispEntity> outBillList = new ArrayList<SevenBillDispEntity>();
        for (int loop = 1; loop <= 10; loop++) {
            String parentItemId = String.format("%010d", loop);
            if (loop == 7) { //增值业务B类归于增值业务
                continue;
            }
            List<BillDispEntity> sevenBillList = this.getBillDetail(idNo, contractNo, yearMonth, parentItemId);
            if (sevenBillList == null || sevenBillList.size() == 0) {
                continue;
            }

            shouldPay = 0;
            favourFee = 0;
            payedPrepay = 0;
            payedLater = 0;
            oweFee = 0;
            exitsFeeCodeBillFlag = false;
            List<BillDispEntity> outLv1BillList = new ArrayList<>(); //返回展示内容的每一大类明细
            for (BillDispEntity billEnt : sevenBillList) {
                /* 一级帐目项帐单查询，对非指定帐目项做过滤 */
                if (StringUtils.isNotEmpty(feeCode) && !feeCode.equalsIgnoreCase("all")) {
                    if (!billEnt.getShowCode().startsWith(feeCode)) {
                        continue;
                    }
                }
                shouldPay += billEnt.getShouldPay();
                favourFee += billEnt.getFavourFee();
                payedPrepay += billEnt.getPayedPrepay();
                payedLater += billEnt.getPayedLater();
                oweFee += billEnt.getOweFee();

                outLv1BillList.add(billEnt);

                exitsFeeCodeBillFlag = true;
            }

            SevenBillDispEntity sevenBillEnt = new SevenBillDispEntity();

            if (exitsFeeCodeBillFlag) {
                sevenBillEnt.setDetailList(outLv1BillList); //明细内容
                sevenBillEnt.setItemId(parentItemId);
                sevenBillEnt.setItemName(sevenBillList.get(0).getParentShowName());
                sevenBillEnt.setShouldPay(shouldPay);
                sevenBillEnt.setFavourFee(favourFee);
                sevenBillEnt.setRealFee(shouldPay - favourFee);
                sevenBillEnt.setPayedPrepay(payedPrepay);
                sevenBillEnt.setPayedLater(payedLater);
                sevenBillEnt.setOweFee(oweFee);
                if (oweFee > 0) {
                    sevenBillEnt.setPayedStatusName("未缴");
                } else {
                    sevenBillEnt.setPayedStatusName("已缴");
                }
                outBillList.add(sevenBillEnt);
            }

        }

        return outBillList;
    }

    @Override
    public List<BillDisp1LevelEntity> getBill3sLevelList(Long id, Long contractNo, int queryYM) {
        try {
            baseDao.getConnection().setAutoCommit(false);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        List<Long> idList = new ArrayList<>();
        List<Long> famIdList = new ArrayList<>();

        if (id != null && id > 0) {
            idList.add(id);
            famIdList = user.getFamlilyIds(id); //家庭飞享非付费人的成员列表
            idList.addAll(famIdList);
        }

        // 对用户的帐单录入中间表
        List<ContractEntity> conList = account.getConUserList(id, contractNo);
        log.debug("conUserList : " + conList);

        /*按用户查询帐单时，需要考虑家庭飞享，按帐户查询时直接查询*/
        long defCon = 0;
        for (ContractEntity contract : conList) {
            if (id > 0 && contract.getBillOrder() == 99999999) {
                defCon = contract.getCon();
                continue;
            }
            bill.saveMidAllBillFee(contract.getCon(), contract.getId(), queryYM); /*按帐户获取中间表帐单*/
        }
        //自己账户下的帐单（含代他人付费）
        if (id > 0) {
            bill.saveMidAllBillFee(defCon, 0, queryYM);
        }

        List<BillDisp3LevelEntity> bill2List = this.getUserDetailBill(idList, contractNo, queryYM, CommonConst.PARENT_ITEMREL_LEVEL_2);

        /*将账目项按2级帐目项合并*/
        List<BillDisp2LevelEntity> BillDisp2List = this.getBillDisp2LevelList(bill2List);

        /*将账目项按1级账目项合并*/
        List<BillDisp1LevelEntity> BillDisp1List = this.getBillDisp1LevelList(BillDisp2List);

        try {
            baseDao.getConnection().commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BillDisp1List;
    }

    /**
     * 功能：将三级帐单按二级帐目项合并，并返回二级帐目项附带三级的列表
     *
     * @param billList
     * @return
     */
    private List<BillDisp2LevelEntity> getBillDisp2LevelList(List<BillDisp3LevelEntity> billList) {
        // 二级展示索引Map
        Map<String, List<BillDisp3LevelEntity>> index2Map = new HashMap<>(); /*二级与三级列表对应关系*/
        Map<String, Long[]/*应收，优惠，实收*/> value1Map = new HashMap<>(); /*二级帐目项汇总Map*/
        for (BillDisp3LevelEntity billEnt : billList) {
            String parentItemId = billEnt.getParentItemId();

            if (index2Map.containsKey(parentItemId)) {
                index2Map.get(parentItemId).add(billEnt);
            } else {
                List<BillDisp3LevelEntity> billDisp2List = new ArrayList<>();
                billDisp2List.add(billEnt);
                index2Map.put(parentItemId, billDisp2List);
            }

            if (value1Map.containsKey(parentItemId)) {
                value1Map.get(parentItemId)[0] += billEnt.getShouldPay();
                value1Map.get(parentItemId)[1] += billEnt.getFavourFee();
                value1Map.get(parentItemId)[2] += billEnt.getShouldPay() - billEnt.getFavourFee();
            } else {
                Long[] fees = new Long[3];
                fees[0] = billEnt.getShouldPay();
                fees[1] = billEnt.getFavourFee();
                fees[2] = billEnt.getShouldPay() - billEnt.getFavourFee();
                value1Map.put(parentItemId, fees);
            }
        }

        List<BillDisp2LevelEntity> BillDisp2List = new ArrayList<>();
        for (String key : index2Map.keySet()) {
            String parentItemId = key; /*二级帐目项*/
            BillDisp2LevelEntity billDisp2Ent = new BillDisp2LevelEntity();
            billDisp2Ent.setItemId(parentItemId);
            billDisp2Ent.setItemName(bill.getBillItemConf(parentItemId).getItemName());
            billDisp2Ent.setDetailList(index2Map.get(key));
            billDisp2Ent.setParentItemId(bill.getItemRelInfo(parentItemId, "0").getParentItemId()); /*二级节点中设置父级节点ID*/

            billDisp2Ent.setShouldPay(value1Map.get(parentItemId)[0]);
            billDisp2Ent.setFavourFee(value1Map.get(parentItemId)[1]);
            billDisp2Ent.setRealFee(value1Map.get(parentItemId)[2]);

            BillDisp2List.add(billDisp2Ent);
        }

        return BillDisp2List;
    }

    private List<BillDisp1LevelEntity> getBillDisp1LevelList(List<BillDisp2LevelEntity> billList) {
        // 一级展示索引Map
        Map<String, List<BillDisp2LevelEntity>> index1Map = new HashMap<>();
        Map<String, Long[]> value1Map = new HashMap<>();

		/* 二级帐目项按一级帐目项合并分组 */
        for (BillDisp2LevelEntity billDis2Ent : billList) {
            String parentItemId = billDis2Ent.getParentItemId(); /* 一级帐目项 */

            if (index1Map.containsKey(parentItemId)) {
                index1Map.get(parentItemId).add(billDis2Ent);
            } else {
                List<BillDisp2LevelEntity> billDisp1List = new ArrayList<>();
                billDisp1List.add(billDis2Ent);
                index1Map.put(parentItemId, billDisp1List);
            }

            if (value1Map.containsKey(parentItemId)) {
                value1Map.get(parentItemId)[0] += billDis2Ent.getShouldPay();
                value1Map.get(parentItemId)[1] += billDis2Ent.getFavourFee();
                value1Map.get(parentItemId)[2] += billDis2Ent.getRealFee();
            } else {
                Long[] fees = new Long[3];
                fees[0] = billDis2Ent.getShouldPay();
                fees[1] = billDis2Ent.getFavourFee();
                fees[2] = billDis2Ent.getRealFee();
                value1Map.put(parentItemId, fees);
            }
        }

        List<BillDisp1LevelEntity> BillDisp1List = new ArrayList<>();
        for (String key : index1Map.keySet()) {
            BillDisp1LevelEntity billDisp1Ent = new BillDisp1LevelEntity();
            billDisp1Ent.setItemId(key);
            billDisp1Ent.setItemName(bill.getBillItemConf(key).getItemName());
            billDisp1Ent.setDetailList(index1Map.get(key));

            billDisp1Ent.setShouldPay(value1Map.get(key)[0]);
            billDisp1Ent.setFavourFee(value1Map.get(key)[1]);
            billDisp1Ent.setRealFee(value1Map.get(key)[2]);

            BillDisp1List.add(billDisp1Ent);
        }

        return BillDisp1List;
    }

    @Override
    public List<BillDisp13LevelEntity> getBill13sLevelList(long id, long contractNo, int queryYm) {
        bill.saveMidAllBillFee(contractNo, id, queryYm);

        List<Long> idList = new ArrayList<>();
        idList.add(id);

        List<BillDisp3LevelEntity> bill3List = this.getUserDetailBill(idList, contractNo, queryYm, CommonConst.PARENT_ITEMREL_LEVEL_1);

        return this.getBillDisp13LevelList(bill3List); //获取 13级关联列表
    }

    /**
     * 将三级帐单列表，按1级帐目合并
     * @param billList
     * @return
     */
    private List<BillDisp13LevelEntity> getBillDisp13LevelList(List<BillDisp3LevelEntity> billList) {

        // 一级展示索引Map
        Map<String, List<BillDisp3LevelEntity>> index13Map = new LinkedHashMap<>();
        Map<String, Long[]/*应收，优惠，实收*/> value1Map = new HashMap<>(); /*一级帐目项汇总Map*/

        for (BillDisp3LevelEntity billEnt : billList) {
            String parentItemId = billEnt.getParentItemId();

            if (index13Map.containsKey(parentItemId)) {
                index13Map.get(parentItemId).add(billEnt);
            } else {
                List<BillDisp3LevelEntity> billDisp3List = new ArrayList<>();
                billDisp3List.add(billEnt);
                index13Map.put(parentItemId, billDisp3List);
            }

            if (value1Map.containsKey(parentItemId)) {
                value1Map.get(parentItemId)[0] += billEnt.getShouldPay();
                value1Map.get(parentItemId)[1] += billEnt.getFavourFee();
                value1Map.get(parentItemId)[2] += billEnt.getShouldPay() - billEnt.getFavourFee();
            } else {
                Long[] fees = new Long[3];
                fees[0] = billEnt.getShouldPay();
                fees[1] = billEnt.getFavourFee();
                fees[2] = billEnt.getShouldPay() - billEnt.getFavourFee();
                value1Map.put(parentItemId, fees);
            }
        } //:: end for

        List<BillDisp13LevelEntity> BillDisp13List = new ArrayList<>();
        for (String key : index13Map.keySet()) {
            String parentItemId = key; /*一级帐目项*/
            BillDisp13LevelEntity billDisp13Ent = new BillDisp13LevelEntity();
            billDisp13Ent.setItemId(parentItemId);
            billDisp13Ent.setItemName(bill.getBillItemConf(parentItemId).getItemName());
            billDisp13Ent.setDetailList(index13Map.get(key));

            billDisp13Ent.setShouldPay(value1Map.get(parentItemId)[0]);
            billDisp13Ent.setFavourFee(value1Map.get(parentItemId)[1]);
            billDisp13Ent.setRealFee(value1Map.get(parentItemId)[2]);

            BillDisp13List.add(billDisp13Ent);
        }

        return BillDisp13List;

    }

    @Override
    public void saveMidBillFee(Map<String, Object> inParam) {
        Map<String, Object> inMap = null;
        Map<String, Object> outMap = null;

        int iYearMonth = 0;
        long lContractNo = 0;
        long lIdNo = 0;
        int iCurYM = 0;
        String statusFlag; /* 0：未缴，含内存帐单 2：已缴 */
        boolean isOnline = false;

        iYearMonth = (Integer) inParam.get("YEAR_MONTH");
        lContractNo = (Long) inParam.get("CONTRACT_NO");
        statusFlag = inParam.get("STATUS_FLAG").toString();
        if (inParam.get("ID_NO") != null) {
            lIdNo = (Long) inParam.get("ID_NO");
        }
        iCurYM = (Integer) inParam.get("CUR_YM");
        if (inParam.get("IS_ONLINE") != null) {
            isOnline = Boolean.valueOf(inParam.get("IS_ONLINE").toString());
        }

		/* 取出账标志和出账年月 */
        int iWrtoffFlag = 0;
        int iBatchWrtoffMonth = 0;
        PubWrtoffCtrlEntity pwce = control.getWriteOffFlagAndMonth();
        iWrtoffFlag = Integer.parseInt(pwce.getWrtoffFlag());
        iBatchWrtoffMonth = pwce.getWrtoffMonth();

        log.info("WriteOff Flag => " + iWrtoffFlag);
        // List<Map<String, Object>> conUserList = null;

        if (lIdNo > 0) {

            // inMap = new HashMap<String, Object>();
            // inMap.put("ID_NO", lIdNo);
            // inMap.put("CONTRACT_NO", lContractNo);
            // conUserList = account.getConUserRelListByFlag(inMap);

            // if (conUserList.size() > 0) {

            // for (Map<String, Object> conUserMap : conUserList) {
            if (statusFlag.equals(STATUS_ONLINE_PAYED)) {
                /* 取已冲销帐单表中的帐单费用插入中间表 */
                inMap = new HashMap<String, Object>();
                // inMap.put("ID_NO", conUserMap.get("ID_NO"));
                // inMap.put("CONTRACT_NO", conUserMap.get("CONTRACT_NO"));
                inMap.put("ID_NO", lIdNo);
                inMap.put("CONTRACT_NO", lContractNo);
                inMap.put("BILL_CYCLE", iYearMonth);
                if (iWrtoffFlag > 0) {
                    inMap.put("BILL_DAY", BATCHWRTOFF_BILL_DAY);
                    inMap.put("NATURAL_MONTH", iBatchWrtoffMonth);
                }
                inMap.put("SUFFIX", iYearMonth);

                baseDao.insert("act_bill_mid.iActBillMidFromPayedowe", inMap);

            } else if (statusFlag.equals(STATUS_ONLINE_UNPAY)) {
                /* 取未冲销帐单表中的帐单费用插入中间表 */
                inMap = new HashMap<String, Object>();
                // inMap.put( "SUFFIX",
                // String.valueOf(conUserMap.get("CONTRACT_NO"))
                // .substring( String.valueOf( conUserMap
                // .get("CONTRACT_NO")) .length() - 2));
                // inMap.put("ID_NO", conUserMap.get("ID_NO"));
                // inMap.put("CONTRACT_NO", conUserMap.get("CONTRACT_NO"));
                inMap.put("ID_NO", lIdNo);
                inMap.put("CONTRACT_NO", lContractNo);
                inMap.put("MIN_BILL_CYCLE", iYearMonth);
                inMap.put("MAX_BILL_CYCLE", iYearMonth);
                if (iWrtoffFlag > 0) {
                    inMap.put("BILL_DAY", BATCHWRTOFF_BILL_DAY);
                    inMap.put("NATURAL_MONTH", iBatchWrtoffMonth);
                }
                baseDao.insert("act_bill_mid.iActBillMidFromUnPayOwe", inMap);

            }

            if (iCurYM == iYearMonth || iCurYM == DateUtils.addMonth(iYearMonth, 1) && iWrtoffFlag == 1) {
                /* 取内存账单费用插入中间表 待定 */
                // UnbillEntity unbillEntity =
                // bill.getUnbillFee(Long.parseLong(conUserMap.get("CONTRACT_NO").toString()),
                // Long.parseLong(conUserMap.get("ID_NO").toString()), "02",
                // isOnline);
                UnbillEntity unbillEntity = bill.getUnbillFee(lContractNo, lIdNo, CommonConst.UNBILL_TYPE_BILL_DET, isOnline);
                List<BillEntity> billList = null;
                if (statusFlag.equals(STATUS_ONLINE_PAYED)) { // 取已冲销
                    billList = unbillEntity.getPayedOweList();
                } else {
                    billList = unbillEntity.getUnBillList();
                }

                for (BillEntity bill : billList) {
                    long lShouldPay = bill.getShouldPay();
                    long lFavourFee = bill.getFavourFee();
                    long lTaxFee = bill.getTaxFee();

                    Map<String, Object> billMap = new HashMap<String, Object>();
                    billMap.put("CONTRACT_NO", bill.getContractNo());
                    billMap.put("ID_NO", bill.getIdNo());
                    billMap.put("PROD_PRCID", bill.getProdPrcId());
                    billMap.put("NATURAL_MONTH", bill.getNaturalMonth());
                    billMap.put("CYCLE_TYPE", "0");
                    billMap.put("BILL_CYCLE", bill.getBillCycle());
                    billMap.put("BILL_BEGIN", bill.getBillBegin());
                    billMap.put("BILL_TYPE", "0");
                    billMap.put("BILL_DAY", bill.getBillDay());
                    billMap.put("ACCT_ITEM_CODE", bill.getAcctItemCode());
                    billMap.put("SHOULD_PAY", bill.getShouldPay());
                    billMap.put("FAVOUR_FEE", bill.getFavourFee());
                    billMap.put("PAYED_PREPAY", bill.getPayedPrepay());
                    billMap.put("PAYED_LATER", bill.getPayedLater());
                    billMap.put("BILL_END", bill.getBillEnd());
                    billMap.put("TAX_RATE", bill.getTaxRate());
                    billMap.put("TAX_FEE", bill.getTaxFee());
                    billMap.put("VAT_EXCLUDED", lShouldPay - lFavourFee - lTaxFee);
                    baseDao.insert("act_bill_mid.iActBillMidFromUnbill", billMap);
                }
            }
            // }

            // }
        } else {
            if (statusFlag.equals(STATUS_ONLINE_PAYED)) {
				/* 取已冲销帐单表中的帐单费用插入中间表 */
                inMap = new HashMap<String, Object>();
                inMap.put("CONTRACT_NO", lContractNo);
                inMap.put("BILL_CYCLE", iYearMonth);
                if (iWrtoffFlag > 0) {
                    inMap.put("BILL_DAY", BATCHWRTOFF_BILL_DAY);
                    inMap.put("NATURAL_MONTH", iBatchWrtoffMonth);
                }
                inMap.put("SUFFIX", iYearMonth);
                baseDao.insert("act_bill_mid.iActBillMidFromPayedowe", inMap);
            } else if (statusFlag.equals(STATUS_ONLINE_UNPAY)) {
				/* 取未冲销帐单表中的帐单费用插入中间表 */
                inMap = new HashMap<String, Object>();
                inMap.put("CONTRACT_NO", lContractNo);
                inMap.put("MIN_BILL_CYCLE", iYearMonth);
                inMap.put("MAX_BILL_CYCLE", iYearMonth);
                if (iWrtoffFlag > 0) {
                    inMap.put("BILL_DAY", BATCHWRTOFF_BILL_DAY);
                    inMap.put("NATURAL_MONTH", iBatchWrtoffMonth);
                }
                baseDao.insert("act_bill_mid.iActBillMidFromUnPayOwe", inMap);
            }

            if (iCurYM == iYearMonth || iCurYM == Integer.valueOf(DateUtil.toStringPlusMonths(String.valueOf(iYearMonth), 1, "yyyyMM"))
                    && iWrtoffFlag == 1) {
				/* 取内存账单费用插入中间表 待定 */
                List<ContractEntity> userList = account.getUserList(lContractNo);
                for (ContractEntity userEntity : userList) {
                    long lIdNoTmp = userEntity.getId();

                    UnbillEntity unbillEntity = bill.getUnbillFee(lContractNo, lIdNoTmp, CommonConst.UNBILL_TYPE_BILL_DET, isOnline);
                    List<BillEntity> billList = null;
                    if (statusFlag.equals(STATUS_ONLINE_PAYED)) { // 取已冲销
                        billList = unbillEntity.getPayedOweList();
                    } else {
                        billList = unbillEntity.getUnBillList();
                    }
                    for (BillEntity bill : billList) {
                        long lShouldPay = bill.getShouldPay();
                        long lFavourFee = bill.getFavourFee();
                        long lTaxFee = bill.getTaxFee();

                        Map<String, Object> billMap = new HashMap<String, Object>();
                        billMap.put("CONTRACT_NO", bill.getContractNo());
                        billMap.put("ID_NO", bill.getIdNo());
                        billMap.put("PROD_PRCID", bill.getProdPrcId());
                        billMap.put("NATURAL_MONTH", bill.getNaturalMonth());
                        billMap.put("CYCLE_TYPE", "0");
                        billMap.put("BILL_CYCLE", bill.getBillCycle());
                        billMap.put("BILL_BEGIN", bill.getBillBegin());
                        billMap.put("BILL_TYPE", "0");
                        billMap.put("BILL_DAY", bill.getBillDay());
                        billMap.put("ACCT_ITEM_CODE", bill.getAcctItemCode());
                        billMap.put("SHOULD_PAY", bill.getShouldPay());
                        billMap.put("FAVOUR_FEE", bill.getFavourFee());
                        billMap.put("PAYED_PREPAY", bill.getPayedPrepay());
                        billMap.put("PAYED_LATER", bill.getPayedLater());
                        billMap.put("BILL_END", bill.getBillEnd());
                        billMap.put("TAX_RATE", bill.getTaxRate());
                        billMap.put("TAX_FEE", bill.getTaxFee());
                        billMap.put("VAT_EXCLUDED", lShouldPay - lFavourFee - lTaxFee);
                        baseDao.insert("act_bill_mid.iActBillMidFromUnbill", billMap);
                    }
                }
            }
            // System.out.println("=>" + obj );
            Integer count = (Integer) baseDao.queryForObject("act_bill_mid.testSql0");
            log.info("Act_Bill_Mid table count => " + count);
        }

		/* 将费用信息按三级放到费用信息临时表中 */
        //baseDao.insert("act_billitem_mid.iActBillItemMid");
    }

    /**
     * 按已缴和未缴对用户消费作统计,返回七大类信息
     */
    @Override
    public List<StatusBillInfoEntity> getStatusBillInfo(Map<String, Object> inParam) {
        String status = "";
        String statusName = "";
        long idNo = 0;
        long conNo = 0;
        int billCycle = 0;
        Map<String, Object> inMap = null;

        status = inParam.get("STATUS").toString();
        idNo = Long.parseLong(inParam.get("ID_NO").toString());
        billCycle = Integer.parseInt(inParam.get("BILL_CYCLE").toString());

        if (status.equals(STATUS_ONLINE_UNPAY)) {
            statusName = "未缴";
        } else if (status.equals(STATUS_ONLINE_PAYED)) {
            statusName = "已缴";
        } else {
            log.error("帐单状态传值错误");
        }

        inMap = new HashMap<String, Object>();
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "BILL_CYCLE", billCycle);
        safeAddToMap(inMap, "PARENT_LEVEL", 0);
        List<StatusBillInfoEntity> result = baseDao.queryForList("act_bill_mid.qStatusBillGroup", inMap);
        for (StatusBillInfoEntity statusBillInfoEntity : result) {
            statusBillInfoEntity.setStatusName(statusName);
        }

        return result;
    }

    /**
     * 取已缴和未缴七大类对应的明细
     */
    @Override
    public List<StatusDispBill> getStatusBillDetail(Map<String, Object> inParam) {
        long idNo = 0;
        long conNo = 0;
        int billCycle = 0;
        String status = "";
        String statusName = "";
        Map<String, Object> inMap = null;
        List<StatusDispBill> detailList = new ArrayList<StatusDispBill>();
        List<BillEntity> billList = new ArrayList<BillEntity>();

        idNo = getLongValue(inParam, "ID_NO");
        billCycle = getIntValue(inParam, "BILL_CYCLE");
        status = inParam.get("STATUS").toString();

        if (status.equals(STATUS_ONLINE_UNPAY)) {
            statusName = "未缴";
        } else if (status.equals(STATUS_ONLINE_PAYED)) {
            statusName = "已缴";
        } else {
            log.error("帐单状态传值错误");
        }

        inMap = new HashMap<String, Object>();
        safeAddToMap(inMap, "YEAR_MONTH", billCycle);
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "PARENT_LEVEL", CommonConst.PARENT_ITEMREL_LEVEL_1);
        billList = baseDao.queryForList("act_bill_mid.qUserDetailBill", inMap);
        log.debug("\n" + billList + " \n");
        detailList.addAll(getStatusDispBill(billList));

        for (StatusDispBill map : detailList) {
            map.setStatusName(statusName);
        }

        return detailList;
    }

    public List<StatusDispBill> getStatusDispBill(List<BillEntity> billList) {

        log.info("size :=> " + billList.size());
        Map<String, List<BillEntity>> rmap = newHashMap();
        Set<String> keySet = null;
        List<StatusDispBill> appendix = new ArrayList<StatusDispBill>();
        List<BillEntity> list = null;

        for (BillEntity bill : billList) {
            String prodPrcId = bill.getProdPrcId();
            String itemCode = bill.getAcctItemCode();
            log.debug("itemCode=[" + itemCode + "] prodPrcId=[" + prodPrcId + "]"); // wangyla
            // 帐单acct_item_code
            String key = null;
            boolean isProdPrcFlag = false;
            
            /*
            if (!prodPrcId.equals("XXXXXXXXXX")) {
                isProdPrcFlag = true;
                key = prodPrcId + "." + "0000000001" + "." + String.valueOf(isProdPrcFlag);
            } else {
                isProdPrcFlag = false;
                key = itemCode + "." + bill.getParentItemId() + "." + String.valueOf(isProdPrcFlag);
            }
            */
            key = itemCode + "." + bill.getParentItemId();
			/*
			 * 优先看是否存在有不是10个大写X的账单，先按prod_prcid group by 展示成资费名称
			 * 然后再将剩下的prod_prcid 是10个X的账单，按账目项 group by 展示成账目项名称 modified by
			 * wangyla 20150327
			 * 
			 * if (!prodPrcId.equals("XXXXXXXXXX")) { isProdPrcFlag = true; key
			 * = prodPrcId + "." + bill.getParentItemId() + "." +
			 * String.valueOf(isProdPrcFlag); } else { isProdPrcFlag = false;
			 * key = itemCode + "." + bill.getParentItemId() + "." +
			 * String.valueOf(isProdPrcFlag); }
			 */

            list = rmap.get(key); /* 先从Map中取列表 */
            if (null == list) {/* 不存在 */
                list = new ArrayList<BillEntity>();
            }
            list.add(bill);
            safeAddToMap(rmap, key, list);
        }

        keySet = rmap.keySet();
        Iterator<String> iter = keySet.iterator();
        Map<String, Object> arg0 = newHashMap();
        Map<String, Object> resultMap = null;

        while (iter.hasNext()) {
            long totalFee = 0;
            long shouldPay = 0;
            long favourFee = 0;
            long payedPrepay = 0;
            long payedLater = 0;
            long oweFee = 0;
            StatusDispBill ab = new StatusDispBill();
            String k = iter.next();
            List<BillEntity> blist = rmap.get(k);
            for (BillEntity be : blist) {
                long fee = be.getShouldPay() - be.getFavourFee();
                shouldPay += be.getShouldPay();
                favourFee += be.getFavourFee();
                payedPrepay += be.getPayedPrepay();
                payedLater += be.getPayedLater();
                totalFee += fee;
            }
            oweFee = shouldPay - favourFee - payedPrepay - payedLater;
            if (shouldPay == 0 && favourFee == 0 && payedPrepay == 0 && payedLater == 0) {
                continue;
            }
            String[] arr = k.split("\\.");
            //log.debug("arr[2]=" + arr[2]);
            String itemName = null;
            ab.setFee(totalFee);
            ab.setShouldPay(shouldPay);
            ab.setFavourFee(favourFee);
            ab.setPayedLater(payedLater);
            ab.setPayedPrepay(payedPrepay);
            ab.setOweFee(oweFee);
            ab.setItemId(arr[0]); // 这里指明资费ID或者账目项ID
            /*
            if (Boolean.valueOf(arr[2])) {
                PdPrcInfoEntity pie = prod.getPdPrcInfo(arr[0]);
                itemName = pie.getProdPrcName(); // 取资费名称
            } else {
                itemName = null; // 取账目项名称
                safeAddToMap(arg0, "ACCT_ITEM_CODE", arr[0]);
                resultMap = (Map) baseDao.queryForObject("act_item_detail.qItemNameByItemCode", arg0);
                itemName = getString(resultMap, "ITEM_NAME");
            }*/
            itemName = null; // 取账目项名称
            BillItemEntity bie = bill.getItemConf(arr[0]);
            itemName = bie.getItemName();

            ab.setParentItemId(arr[1]);
            ab.setItemName(itemName);
            log.debug("item_id=" + arr[0] + "parent_item_id=" + arr[1]);
            appendix.add(ab);
        }
        return appendix;
    }

    @Override
    public List<BadSevenBillEntity> getStatusBadSevenBill(Long idNo, Long contractNo, int billCycle) {

        Map<String, Object> inMap = new HashMap<>();
        inMap.put("ID_NO", idNo);
        inMap.put("CONTRACT_NO", contractNo);
        inMap.put("BILL_CYCLE", billCycle);

        System.err.println(billCycle + ">>>>.");

        List<BadSevenBillEntity> badSevenBill = baseDao.queryForList("act_deadowe_info.qryBadBillBySeven", inMap);

        return badSevenBill;
    }

    @Override
    public Map<String, List<GrpBillDispByStatusEntity>> getStatusGrpBill(long contractNo, int billCycle) {
        return getStatusGrpBill(contractNo, billCycle, 3, 1);
    }

    @Override
    public Map<String, List<GrpBillDispByStatusEntity>> getStatusGrpBill(long contractNo, int billCycle, int status, int flag) {
        int curYm = DateUtils.getCurYm();

        List<GrpBillDispByStatusEntity> grpUnpayBillList = new ArrayList<GrpBillDispByStatusEntity>();
        List<GrpBillDispByStatusEntity> grpPayedBillList = new ArrayList<GrpBillDispByStatusEntity>();

        List<GrpBillDispByStatusEntity> grpBillTotalList = new ArrayList<GrpBillDispByStatusEntity>();
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> itemMap = new HashMap<String, Object>();

        inMap.put("CONTRACT_NO", contractNo);
        inMap.put("BILL_CYCLE", billCycle);
        if (billCycle == curYm) {
            log.debug("**************************");
            // TODO:1. 查询内存库账单明细
            UnbillEntity unBill = bill.getUnbillFee(contractNo, 0, CommonConst.UNBILL_TYPE_BILL_DET);
            List<BillEntity> billList = unBill.getUnBillList();
            for (BillEntity billEntity : billList) {
                GrpBillDispByStatusEntity grpBillEntity = new GrpBillDispByStatusEntity();
                grpBillEntity.setAcctItemCode(billEntity.getAcctItemCode());
                grpBillEntity.setBillCycle(billCycle);
                grpBillEntity.setFavourFee(billEntity.getFavourFee());
                grpBillEntity.setIdNo(billEntity.getIdNo());
                grpBillEntity.setOweFee(billEntity.getShouldPay() - billEntity.getFavourFee() - billEntity.getPayedLater()
                        - billEntity.getPayedLater());
                grpBillEntity.setShouldPay(billEntity.getShouldPay());
                grpBillEntity.setPayedLater(billEntity.getPayedLater());
                grpBillEntity.setPayedPrepay(billEntity.getPayedPrepay());
                // 获取item_name

                safeAddToMap(inMap, "ACCT_ITEM_CODE", billEntity.getAcctItemCode());
                BillItemEntity billItem = (BillItemEntity) baseDao.queryForObject("act_item_conf.qItemNameByItemCode", itemMap);
                grpBillEntity.setItemName(billItem.getItemName());

                if (grpBillEntity.getOweFee() > 0) {
                    grpBillEntity.setStatus("未缴");
                    grpUnpayBillList.add(grpBillEntity);
                } else {
                    grpBillEntity.setStatus("已缴");
                    grpPayedBillList.add(grpBillEntity);
                }
            }
        }
        if (status != 2) {
            // 2.查询物理库已缴账单明细
            List<GrpBillDispByStatusEntity> grpPayedBillListTmp = baseDao.queryForList("act_payedowe_info.qryGrpBillByContractNo", inMap);
            grpPayedBillList.addAll(grpPayedBillListTmp);
        }

        if (status != 1) {
            // 3.查询物理库未缴账单明细
            List<GrpBillDispByStatusEntity> grpUnpayBillListTmp = baseDao.queryForList("act_unpayowe_info.qryGrpBillByContractNo", inMap);
            grpUnpayBillList.addAll(grpUnpayBillListTmp);
        }

        // 4.获取未缴账单的滞纳金
        for (GrpBillDispByStatusEntity grpBill : grpUnpayBillList) {
            // TODO：取滞纳金
        }

        Map<String, List<GrpBillDispByStatusEntity>> outMap = new HashMap<String, List<GrpBillDispByStatusEntity>>();
        if (flag == 1) {
            // 5.循环已缴账单明细累计
            GrpBillDispByStatusEntity grpBillEntityTotal = new GrpBillDispByStatusEntity();
            if (grpPayedBillList.size() > 0 && grpPayedBillList != null) {
                for (GrpBillDispByStatusEntity grpBillEntity : grpPayedBillList) {
                    grpBillEntityTotal.setOweFee(grpBillEntityTotal.getOweFee() + grpBillEntity.getOweFee());
                    grpBillEntity.setDelayFee(0);
                    grpBillEntityTotal.setDelayFee(grpBillEntityTotal.getDelayFee() + grpBillEntity.getDelayFee());
                    grpBillEntityTotal.setShouldPay(grpBillEntityTotal.getShouldPay() + grpBillEntity.getShouldPay());
                    grpBillEntityTotal.setFavourFee(grpBillEntityTotal.getFavourFee() + grpBillEntity.getFavourFee());
                    grpBillEntityTotal.setPayedLater(grpBillEntityTotal.getPayedLater() + grpBillEntity.getPayedLater());
                    grpBillEntityTotal.setPayedPrepay(grpBillEntityTotal.getPayedLater() + grpBillEntity.getPayedPrepay());
                    grpBillEntityTotal.setBillCycle(billCycle);
                    grpBillEntityTotal.setStatus("已缴");
                }
                grpBillTotalList.add(grpBillEntityTotal);
            }

            // 6.循环未缴账单明细累计
            grpBillEntityTotal = new GrpBillDispByStatusEntity();
            if (grpUnpayBillList.size() > 0 && grpUnpayBillList != null) {
                for (GrpBillDispByStatusEntity grpBillEntity : grpUnpayBillList) {
                    grpBillEntityTotal.setOweFee(grpBillEntityTotal.getOweFee() + grpBillEntity.getOweFee());
                    grpBillEntityTotal.setDelayFee(grpBillEntityTotal.getDelayFee() + grpBillEntity.getDelayFee());
                    grpBillEntityTotal.setShouldPay(grpBillEntityTotal.getShouldPay() + grpBillEntity.getShouldPay());
                    grpBillEntityTotal.setFavourFee(grpBillEntityTotal.getFavourFee() + grpBillEntity.getFavourFee());
                    grpBillEntityTotal.setPayedLater(grpBillEntityTotal.getPayedLater() + grpBillEntity.getPayedLater());
                    grpBillEntityTotal.setPayedPrepay(grpBillEntityTotal.getPayedLater() + grpBillEntity.getPayedPrepay());
                    grpBillEntityTotal.setBillCycle(billCycle);
                    grpBillEntityTotal.setStatus("未缴");
                }
                grpBillTotalList.add(grpBillEntityTotal);
            }
            outMap.put("GRP_BILL_TOTAL", grpBillTotalList);
        }

        outMap.put("GRP_PAYEDBILL_LIST", grpPayedBillList);
        outMap.put("GRP_UNPAYBILL_LIST", grpUnpayBillList);

        return outMap;
    }

    @Override
    public Map<String, Object> getSevenDetailBill(long lIdNo, long lContractNo, int iBillCycle, String sStatus, boolean isOnline) {
        Map<String, Object> inMapTmp = new HashMap<String, Object>();

        Map<String, Object> outMapTmp = new HashMap<String, Object>();
        List<OutBillEntity> outList = new ArrayList<OutBillEntity>();

        long totalFee = 0;
        long favourFee = 0;

		/* 取当前年月 */
        int curYm = Integer.parseInt(DateUtil.format(new Date(), "yyyyMM"));

        if (lContractNo > 0) {
            // 获取帐单数据源
            inMapTmp = new HashMap<String, Object>();
            inMapTmp.put("CONTRACT_NO", lContractNo);
            inMapTmp.put("ID_NO", lIdNo);
            inMapTmp.put("YEAR_MONTH", iBillCycle);
            inMapTmp.put("CUR_YM", curYm);
            inMapTmp.put("STATUS_FLAG", sStatus);
            inMapTmp.put("IS_ONLINE", isOnline);
            this.saveMidBillFee(inMapTmp);
        } else {
            List<ContractEntity> contractList = account.getConList(lIdNo);

            for (ContractEntity contractEntity : contractList) {
                long conNoTmp = contractEntity.getCon();

                // 获取帐单数据源
                inMapTmp = new HashMap<String, Object>();
                inMapTmp.put("CONTRACT_NO", conNoTmp);
                inMapTmp.put("ID_NO", lIdNo);
                inMapTmp.put("YEAR_MONTH", iBillCycle);
                inMapTmp.put("CUR_YM", curYm);
                inMapTmp.put("STATUS_FLAG", sStatus);
                inMapTmp.put("IS_ONLINE", isOnline);
                this.saveMidBillFee(inMapTmp);
            }
        }

        // 获取用户七大类的结果
        inMapTmp = new HashMap<String, Object>();
        safeAddToMap(inMapTmp, "STATUS", sStatus);
        safeAddToMap(inMapTmp, "ID_NO", lIdNo);
        safeAddToMap(inMapTmp, "BILL_CYCLE", iBillCycle);
        List<StatusBillInfoEntity> billList = this.getStatusBillInfo(inMapTmp);

        OutBillEntity PCAS_01_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_02_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_03_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_04_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_05_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_06_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_07_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_08_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_09_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_10_BILL_ENT = new OutBillEntity();
        for (StatusBillInfoEntity statusBillInfoEntity : billList) {
            int showId = Integer.parseInt(statusBillInfoEntity.getItemId());
            totalFee += statusBillInfoEntity.getRealFee();
            favourFee += statusBillInfoEntity.getFavourFee();
            switch (showId) {
                case 1:
                    PCAS_01_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 2:
                    PCAS_02_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 3:
                    PCAS_03_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 4:
                    PCAS_04_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 5:
                    PCAS_05_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 6:
                    PCAS_06_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 7:
                    PCAS_07_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 8:
                    PCAS_08_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 9:
                    PCAS_09_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 10:
                    PCAS_10_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                default:
                    break;
            }
        }
        // 多帐户需要将费用做合并

        // 获取七大类明细结果
        inMapTmp = new HashMap<String, Object>();
        safeAddToMap(inMapTmp, "ID_NO", lIdNo);
        safeAddToMap(inMapTmp, "BILL_CYCLE", iBillCycle);
        safeAddToMap(inMapTmp, "STATUS", sStatus);
        List<StatusDispBill> detailList = this.getStatusBillDetail(inMapTmp);
        // 整合出参，拼凑结果

        List<StatusBillInfoEntity> PCAS_01_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_02_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_03_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_04_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_05_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_06_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_07_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_08_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_09_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_10_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();

        for (StatusDispBill statusDispBill : detailList) {
            int showId = Integer.parseInt(statusDispBill.getParentItemId());
            StatusBillInfoEntity billDetailEnt = new StatusBillInfoEntity();
            billDetailEnt.setItemId(statusDispBill.getItemId());
            billDetailEnt.setItemName(statusDispBill.getItemName());
            billDetailEnt.setShouldPay(statusDispBill.getShouldPay());
            billDetailEnt.setFavourFee(statusDispBill.getFavourFee());
            billDetailEnt.setPayedPrepay(statusDispBill.getPayedPrepay());
            billDetailEnt.setPayedLater(statusDispBill.getPayedLater());
            billDetailEnt.setOweFee(statusDispBill.getOweFee());
            billDetailEnt.setRealFee(statusDispBill.getFee());
            billDetailEnt.setStatusName(statusDispBill.getStatusName());
            switch (showId) {
                case 1:
                    PCAS_01_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 2:
                    PCAS_02_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 3:
                    PCAS_03_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 4:
                    PCAS_04_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 5:
                    PCAS_05_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 6:
                    PCAS_06_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 7:
                    PCAS_07_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 8:
                    PCAS_08_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 9:
                    PCAS_09_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 10:
                    PCAS_10_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                default:
                    break;
            }
        }

        if (PCAS_01_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_01_BILL_ENT, PCAS_01_STATUS_DETAIL_LIST);
            PCAS_01_BILL_ENT.setDetailList(PCAS_01_STATUS_DETAIL_LIST);
            outList.add(PCAS_01_BILL_ENT);
        }
        if (PCAS_02_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_02_BILL_ENT, PCAS_02_STATUS_DETAIL_LIST);
            PCAS_02_BILL_ENT.setDetailList(PCAS_02_STATUS_DETAIL_LIST);
            outList.add(PCAS_02_BILL_ENT);
        }
        if (PCAS_03_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_03_BILL_ENT, PCAS_03_STATUS_DETAIL_LIST);
            PCAS_03_BILL_ENT.setDetailList(PCAS_03_STATUS_DETAIL_LIST);
            outList.add(PCAS_03_BILL_ENT);
        }
        if (PCAS_04_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_04_BILL_ENT, PCAS_04_STATUS_DETAIL_LIST);
            PCAS_04_BILL_ENT.setDetailList(PCAS_04_STATUS_DETAIL_LIST);
            outList.add(PCAS_04_BILL_ENT);
        }
        if (PCAS_05_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_05_BILL_ENT, PCAS_05_STATUS_DETAIL_LIST);
            PCAS_05_BILL_ENT.setDetailList(PCAS_05_STATUS_DETAIL_LIST);
            outList.add(PCAS_05_BILL_ENT);
        }
        if (PCAS_06_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_06_BILL_ENT, PCAS_06_STATUS_DETAIL_LIST);
            PCAS_06_BILL_ENT.setDetailList(PCAS_06_STATUS_DETAIL_LIST);
            outList.add(PCAS_06_BILL_ENT);
        }
        if (PCAS_07_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_07_BILL_ENT, PCAS_07_STATUS_DETAIL_LIST);
            PCAS_07_BILL_ENT.setDetailList(PCAS_07_STATUS_DETAIL_LIST);
            outList.add(PCAS_07_BILL_ENT);
        }
        if (PCAS_08_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_08_BILL_ENT, PCAS_08_STATUS_DETAIL_LIST);
            PCAS_08_BILL_ENT.setDetailList(PCAS_08_STATUS_DETAIL_LIST);
            outList.add(PCAS_08_BILL_ENT);
        }
        if (PCAS_09_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_09_BILL_ENT, PCAS_09_STATUS_DETAIL_LIST);
            PCAS_09_BILL_ENT.setDetailList(PCAS_09_STATUS_DETAIL_LIST);
            outList.add(PCAS_09_BILL_ENT);
        }
        if (PCAS_10_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_10_BILL_ENT, PCAS_10_STATUS_DETAIL_LIST);
            PCAS_10_BILL_ENT.setDetailList(PCAS_10_STATUS_DETAIL_LIST);
            outList.add(PCAS_10_BILL_ENT);
        }

        Map<String, Object> outParam = new HashMap<String, Object>();
        outParam.put("TOTAL_FEE", totalFee);
        outParam.put("FAVOUR_FEE", favourFee);
        outParam.put("BILL_LIST", outList);

        return outParam;
    }

    private void replaceBillInfoEntityList(OutBillEntity PCAS_00_BILL_ENT, List<StatusBillInfoEntity> PCAS_00_STATUS_DETAIL_LIST) {
        long tmpfavourFee = 0;
        long tmpoweFee = 0;
        long tmppayedLater = 0;
        long tmppayedPrepay = 0;
        long tmprealFee = 0;
        long tmpshouldPay = 0;
        for (StatusBillInfoEntity statusDispBill : PCAS_00_STATUS_DETAIL_LIST) {
            tmpshouldPay += statusDispBill.getShouldPay();
            tmpfavourFee += statusDispBill.getFavourFee();
            tmpoweFee += statusDispBill.getOweFee();
            tmppayedLater += statusDispBill.getPayedLater();
            tmppayedPrepay += statusDispBill.getPayedPrepay();
            tmprealFee += statusDispBill.getRealFee();
        }
        PCAS_00_BILL_ENT.getBillInfo().setShouldPay(tmpshouldPay);
        PCAS_00_BILL_ENT.getBillInfo().setFavourFee(tmpfavourFee);
        PCAS_00_BILL_ENT.getBillInfo().setOweFee(tmpoweFee);
        PCAS_00_BILL_ENT.getBillInfo().setPayedLater(tmppayedLater);
        PCAS_00_BILL_ENT.getBillInfo().setPayedPrepay(tmppayedPrepay);
        PCAS_00_BILL_ENT.getBillInfo().setRealFee(tmprealFee);
    }

    public Map<String, Object> getSevenDeadDetailBill(long lIdNo, long lContractNo, int iBillCycle) {

        Map<String, Object> inMapTmp = new HashMap<String, Object>();

        Map<String, Object> outMapTmp = new HashMap<String, Object>();
        List<OutBillEntity> outList = new ArrayList<OutBillEntity>();

        long totalFee = 0;
        long favourFee = 0;

		/* 取当前年月 */
        int curYm = Integer.parseInt(DateUtil.format(new Date(), "yyyyMM"));

        // 获取帐单数据源
        inMapTmp.put("ID_NO", lIdNo);
        inMapTmp.put("CONTRACT_NO", lContractNo);
        inMapTmp.put("BILL_CYCLE", iBillCycle);
        baseDao.insert("act_bill_mid.iActBillMidFromDeadOwe", inMapTmp);

        // 获取用户七大类的结果
        inMapTmp = new HashMap<String, Object>();
        safeAddToMap(inMapTmp, "STATUS", CommonConst.STATUS_ONLINE_UNPAY);
        safeAddToMap(inMapTmp, "ID_NO", lIdNo);
        safeAddToMap(inMapTmp, "BILL_CYCLE", iBillCycle);
        List<StatusBillInfoEntity> billList = this.getStatusBillInfo(inMapTmp);

        OutBillEntity PCAS_01_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_02_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_03_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_04_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_05_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_06_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_07_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_08_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_09_BILL_ENT = new OutBillEntity();
        OutBillEntity PCAS_10_BILL_ENT = new OutBillEntity();
        for (StatusBillInfoEntity statusBillInfoEntity : billList) {
            int showId = Integer.parseInt(statusBillInfoEntity.getItemId());
            totalFee += statusBillInfoEntity.getRealFee();
            favourFee += statusBillInfoEntity.getFavourFee();
            switch (showId) {
                case 1:
                    PCAS_01_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 2:
                    PCAS_02_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 3:
                    PCAS_03_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 4:
                    PCAS_04_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 5:
                    PCAS_05_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 6:
                    PCAS_06_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 7:
                    PCAS_07_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 8:
                    PCAS_08_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 9:
                    PCAS_09_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                case 10:
                    PCAS_10_BILL_ENT.setBillInfo(statusBillInfoEntity);
                    break;
                default:
                    break;
            }
        }
        // 多帐户需要将费用做合并

        // 获取七大类明细结果
        inMapTmp = new HashMap<String, Object>();
        safeAddToMap(inMapTmp, "ID_NO", lIdNo);
        safeAddToMap(inMapTmp, "BILL_CYCLE", iBillCycle);
        safeAddToMap(inMapTmp, "STATUS", CommonConst.STATUS_ONLINE_UNPAY);
        List<StatusDispBill> detailList = this.getStatusBillDetail(inMapTmp);
        // 整合出参，拼凑结果

        List<StatusBillInfoEntity> PCAS_01_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_02_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_03_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_04_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_05_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_06_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_07_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_08_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_09_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();
        List<StatusBillInfoEntity> PCAS_10_STATUS_DETAIL_LIST = new ArrayList<StatusBillInfoEntity>();

        for (StatusDispBill statusDispBill : detailList) {
            int showId = Integer.parseInt(statusDispBill.getParentItemId());
            StatusBillInfoEntity billDetailEnt = new StatusBillInfoEntity();
            billDetailEnt.setItemId(statusDispBill.getItemId());
            billDetailEnt.setItemName(statusDispBill.getItemName());
            billDetailEnt.setShouldPay(statusDispBill.getShouldPay());
            billDetailEnt.setFavourFee(statusDispBill.getFavourFee());
            billDetailEnt.setPayedPrepay(statusDispBill.getPayedPrepay());
            billDetailEnt.setPayedLater(statusDispBill.getPayedLater());
            billDetailEnt.setOweFee(statusDispBill.getOweFee());
            billDetailEnt.setRealFee(statusDispBill.getFee());
            billDetailEnt.setStatusName(statusDispBill.getStatusName());
            switch (showId) {
                case 1:
                    PCAS_01_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 2:
                    PCAS_02_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 3:
                    PCAS_03_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 4:
                    PCAS_04_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 5:
                    PCAS_05_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 6:
                    PCAS_06_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 7:
                    PCAS_07_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 8:
                    PCAS_08_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 9:
                    PCAS_09_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                case 10:
                    PCAS_10_STATUS_DETAIL_LIST.add(billDetailEnt);
                    break;
                default:
                    break;
            }
        }

        if (PCAS_01_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_01_BILL_ENT, PCAS_01_STATUS_DETAIL_LIST);
            PCAS_01_BILL_ENT.setDetailList(PCAS_01_STATUS_DETAIL_LIST);
            outList.add(PCAS_01_BILL_ENT);
        }
        if (PCAS_02_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_02_BILL_ENT, PCAS_02_STATUS_DETAIL_LIST);
            PCAS_02_BILL_ENT.setDetailList(PCAS_02_STATUS_DETAIL_LIST);
            outList.add(PCAS_02_BILL_ENT);
        }
        if (PCAS_03_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_03_BILL_ENT, PCAS_03_STATUS_DETAIL_LIST);
            PCAS_03_BILL_ENT.setDetailList(PCAS_03_STATUS_DETAIL_LIST);
            outList.add(PCAS_03_BILL_ENT);
        }
        if (PCAS_04_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_04_BILL_ENT, PCAS_04_STATUS_DETAIL_LIST);
            PCAS_04_BILL_ENT.setDetailList(PCAS_04_STATUS_DETAIL_LIST);
            outList.add(PCAS_04_BILL_ENT);
        }
        if (PCAS_05_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_05_BILL_ENT, PCAS_05_STATUS_DETAIL_LIST);
            PCAS_05_BILL_ENT.setDetailList(PCAS_05_STATUS_DETAIL_LIST);
            outList.add(PCAS_05_BILL_ENT);
        }
        if (PCAS_06_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_06_BILL_ENT, PCAS_06_STATUS_DETAIL_LIST);
            PCAS_06_BILL_ENT.setDetailList(PCAS_06_STATUS_DETAIL_LIST);
            outList.add(PCAS_06_BILL_ENT);
        }
        if (PCAS_07_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_07_BILL_ENT, PCAS_07_STATUS_DETAIL_LIST);
            PCAS_07_BILL_ENT.setDetailList(PCAS_07_STATUS_DETAIL_LIST);
            outList.add(PCAS_07_BILL_ENT);
        }
        if (PCAS_08_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_08_BILL_ENT, PCAS_08_STATUS_DETAIL_LIST);
            PCAS_08_BILL_ENT.setDetailList(PCAS_08_STATUS_DETAIL_LIST);
            outList.add(PCAS_08_BILL_ENT);
        }
        if (PCAS_09_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_09_BILL_ENT, PCAS_09_STATUS_DETAIL_LIST);
            PCAS_09_BILL_ENT.setDetailList(PCAS_09_STATUS_DETAIL_LIST);
            outList.add(PCAS_09_BILL_ENT);
        }
        if (PCAS_10_STATUS_DETAIL_LIST.size() > 0) {
            replaceBillInfoEntityList(PCAS_10_BILL_ENT, PCAS_10_STATUS_DETAIL_LIST);
            PCAS_10_BILL_ENT.setDetailList(PCAS_10_STATUS_DETAIL_LIST);
            outList.add(PCAS_10_BILL_ENT);
        }

        Map<String, Object> outParam = new HashMap<String, Object>();
        outParam.put("TOTAL_FEE", totalFee);
        outParam.put("FAVOUR_FEE", favourFee);
        outParam.put("BILL_LIST", outList);

        return outParam;
    }

    @Override
    public void saveMidDeadBillFee(Map<String, Object> inParam) {
        baseDao.insert("act_bill_mid.iActBillMidFromDeadOwe", inParam);
    }

    @Override
    public List<StatusDispBill> getStatusBillDetailForTwoLevel(Map<String, Object> inParam) {
        long idNo = 0;
        long conNo = 0;
        int billCycle = 0;
        String status = "";
        String statusName = "";
        Map<String, Object> inMap = null;
        List<StatusDispBill> detailList = new ArrayList<StatusDispBill>();
        List<BillEntity> billList = new ArrayList<BillEntity>();

        idNo = getLongValue(inParam, "ID_NO");
        billCycle = getIntValue(inParam, "BILL_CYCLE");
        status = inParam.get("STATUS").toString();

        if (status.equals(STATUS_ONLINE_UNPAY)) {
            statusName = "未回收";
        } else if (status.equals(STATUS_ONLINE_PAYED)) {
            statusName = "已回收";
        } else {
            log.error("帐单状态传值错误");
        }

        inMap = new HashMap<String, Object>();
        safeAddToMap(inMap, "YEAR_MONTH", billCycle);
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "PARENT_LEVEL", CommonConst.PARENT_ITEMREL_LEVEL_2);
        billList = baseDao.queryForList("act_bill_mid.qUserDetailBill", inMap);
        log.debug("\n" + billList + " \n");

        List<BillEntity> list = null;
        Map<String, List<BillEntity>> rmap = newHashMap();
        for (BillEntity bill : billList) {
            String key = null;

            key = bill.getParentItemId();

            list = rmap.get(key); /* 先从Map中取列表 */
            if (null == list) {/* 不存在 */
                list = new ArrayList<BillEntity>();
            }
            list.add(bill);
            safeAddToMap(rmap, key, list);
        }

        Set<String> keySet = null;
        keySet = rmap.keySet();
        Iterator<String> iter = keySet.iterator();
        Map<String, Object> arg0 = newHashMap();
        Map<String, Object> resultMap = null;

        while (iter.hasNext()) {
            long totalFee = 0;
            long shouldPay = 0;
            long favourFee = 0;
            long payedPrepay = 0;
            long payedLater = 0;
            long oweFee = 0;
            StatusDispBill ab = new StatusDispBill();
            String k = iter.next();
            List<BillEntity> blist = rmap.get(k);
            for (BillEntity be : blist) {
                long fee = be.getShouldPay() - be.getFavourFee();
                shouldPay += be.getShouldPay();
                favourFee += be.getFavourFee();
                payedPrepay += be.getPayedPrepay();
                payedLater += be.getPayedLater();
                totalFee += fee;
            }
            oweFee = shouldPay - favourFee - payedPrepay - payedLater;
            if (shouldPay == 0 && favourFee == 0 && payedPrepay == 0 && payedLater == 0) {
                continue;
            }
            String itemName = null;
            ab.setFee(totalFee);
            ab.setShouldPay(shouldPay);
            ab.setFavourFee(favourFee);
            ab.setPayedLater(payedLater);
            ab.setPayedPrepay(payedPrepay);
            ab.setOweFee(oweFee);
            ab.setItemId(k); // 这里是二级parentItemId
            //取名称
            inMap = new HashMap<String, Object>();
            inMap.put("ITEM_ID", k);
            BillItemEntity itemEntity = (BillItemEntity) baseDao.queryForObject("act_billitem_conf.qItemNameByItemId", inMap);
            itemName = itemEntity.getItemName();

            //父级parentItemId
            String parentId = "";
            inMap = new HashMap<String, Object>();
            inMap.put("ITEM_ID", k);
            inMap.put("CURRENT_LEVEL", "2");
            BillItemEntity bie = (BillItemEntity) baseDao.queryForObject("act_billitem_rel.qItemRelByItemId", inMap);
            parentId = bie.getParentItemId();

            ab.setParentItemId(parentId);
            ab.setItemName(itemName);
            detailList.add(ab);
        }

        return detailList;
    }


    public IAccount getAccount() {
        return account;
    }

    public void setAccount(IAccount account) {
        this.account = account;
    }

    public IControl getControl() {
        return control;
    }

    public void setControl(IControl control) {
        this.control = control;
    }

    public IBill getBill() {
        return bill;
    }

    public void setBill(IBill bill) {
        this.bill = bill;
    }

    public IUser getUser() {
        return user;
    }

    public void setUser(IUser user) {
        this.user = user;
    }

    public IBalance getBalance() {
        return balance;
    }

    public void setBalance(IBalance balance) {
        this.balance = balance;
    }

    public IProd getProd() {
        return prod;
    }

    public void setProd(IProd prod) {
        this.prod = prod;
    }

    public IRemainFee getRemainFee() {
        return remainFee;
    }

    public void setRemainFee(IRemainFee remainFee) {
        this.remainFee = remainFee;
    }

    public IBillAccount getBillAccount() {
        return billAccount;
    }

    public void setBillAccount(IBillAccount billAccount) {
        this.billAccount = billAccount;
    }


}
