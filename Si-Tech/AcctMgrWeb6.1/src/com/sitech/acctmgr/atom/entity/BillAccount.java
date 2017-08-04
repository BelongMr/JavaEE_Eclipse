package com.sitech.acctmgr.atom.entity;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.bill.Fav1860CfgEntity;
import com.sitech.acctmgr.atom.domains.bill.InterRoamProdInfoEntity;
import com.sitech.acctmgr.atom.domains.bill.SPBillAcctRuleEntity;
import com.sitech.acctmgr.atom.domains.cct.GrpRedEntity;
import com.sitech.acctmgr.atom.domains.cct.NonStopEntity;
import com.sitech.acctmgr.atom.domains.query.BillTotCodeEntity;
import com.sitech.acctmgr.atom.domains.query.ChatTypeEntity;
import com.sitech.acctmgr.atom.domains.query.GprsChangeRecdEntity;
import com.sitech.acctmgr.atom.domains.query.LocationCodeEntity;
import com.sitech.acctmgr.atom.domains.query.PrcIdTransEntity;
import com.sitech.acctmgr.atom.domains.query.PriceCodeEntity;
import com.sitech.acctmgr.atom.domains.query.ProvCityListEntity;
import com.sitech.acctmgr.atom.domains.query.ProvCriticalEntity;
import com.sitech.acctmgr.atom.domains.query.TellCodeEntity;
import com.sitech.acctmgr.atom.domains.user.UserPrcEntity;
import com.sitech.acctmgr.atom.entity.inter.IBillAccount;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IProd;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.util.DateUtil;

public class BillAccount extends BaseBusi implements IBillAccount {
    private IControl control;
    private IProd prod;

    @Override
    public void saveRemindCtrlInfo(String phoneNo, long idNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);
        inMap.put("ID_NO", idNo);
        int count = (Integer) baseDao.queryForObject("remind_ctrl_info.qCnt", inMap);
        if (count == 0) {
            baseDao.insert("remind_ctrl_info.ins", inMap);
        } else {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90001"), "你已经取消了短信提醒，不需要再次取消!");
        }

    }

    @Override
    public void delRemindCtrlInfo(String phoneNo, long idNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);
        inMap.put("ID_NO", idNo);
        int count = (Integer) baseDao.queryForObject("remind_ctrl_info.qCnt", inMap);
        if (count > 0) {
            baseDao.delete("remind_ctrl_info.del", inMap);
        } else {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90002"), "你已经开通了短信提醒，不需要再次开通!");
        }

    }

    @Override
    public int getCntRemindCtrlFav(String phoneNo) {

        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);
        int count = (Integer) baseDao.queryForObject("remind_ctrl_fav.qCnt", inMap);

        return count;
    }

    public boolean isGprsCmd(String phoneNo) {

        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);
        int count = (Integer) baseDao.queryForObject("remind_ctrl_fav.qCprsCnt", inMap);
        if (count > 0) {
            return true;
        } else {

            return false;
        }
    }

    @Override
    public void delGprsShortMsgOffOn(Map<String, Object> inParam) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        String phoneNo = inParam.get("PHONE_NO").toString();
        inMap.put("PHONE_NO", phoneNo);
        String offOnType = "";
        outMap = (Map<String, Object>) baseDao.queryForObject("dGprsShortMsgOffOn.qry", inMap);
        if (outMap == null) {
            offOnType = "A";
        } else {
            offOnType = outMap.get("OFFON_TYPE").toString();
        }
        if (offOnType.equals(inParam.get("OFFON_TYPE").toString())) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90003"), "该用户已经开通gprs流量提醒功能，不能重复开通!");
        }

        baseDao.insert("dGprsShortMsgOffOnHis.insert", inParam);

        inMap.put("OP_CODE", inParam.get("OP_CODE"));
        baseDao.delete("dGprsShortMsgOffOn.delete", inMap);
    }

    @Override
    public void saveGprsShortMsgOffOn(Map<String, Object> inParam) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        String phoneNo = inParam.get("PHONE_NO").toString();
        inMap.put("PHONE_NO", phoneNo);
        String offOnType = "";
        outMap = (Map<String, Object>) baseDao.queryForObject("dGprsShortMsgOffOn.qry", inMap);
        if (outMap == null) {
            offOnType = "A";
        } else {
            offOnType = outMap.get("OFFON_TYPE").toString();
        }
        if (offOnType.equals(inParam.get("OFFON_TYPE").toString())) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90004"), "该用户已经关闭gprs流量提醒功能，不能重复关闭!");
        }

        baseDao.insert("dGprsShortMsgOffOn.insert", inParam);

    }

    @Override
    public void saveGprsShortMsgOffOnNew(Map<String, Object> inParam) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        String phoneNo = inParam.get("PHONE_NO").toString();
        inMap.put("PHONE_NO", phoneNo);
        String offOnType = "";
        outMap = (Map<String, Object>) baseDao.queryForObject("dGprsShortMsgOffOnNew.qry", inMap);
        if (outMap == null) {
            offOnType = "D";
        } else {
            offOnType = outMap.get("OFFON_TYPE").toString();
        }
        if (offOnType.equals(inParam.get("OFFON_TYPE").toString())) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90003"), "该用户已经开通gprs流量提醒功能，不能重复开通!");
        }

        baseDao.insert("dGprsShortMsgOffOnNew.insert", inParam);
        baseDao.insert("dGprsShortMsgOffOnHisNew.inserta", inParam);
    }

    @Override
    public void delGprsShortMsgOffOnNew(Map<String, Object> inParam) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        String phoneNo = inParam.get("PHONE_NO").toString();
        inMap.put("PHONE_NO", phoneNo);
        String offOnType = "";
        outMap = (Map<String, Object>) baseDao.queryForObject("dGprsShortMsgOffOnNew.qry", inMap);
        if (outMap == null) {
            offOnType = "D";
        } else {
            offOnType = outMap.get("OFFON_TYPE").toString();
        }
        if (offOnType.equals(inParam.get("OFFON_TYPE").toString())) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90004"), "该用户已经关闭gprs流量提醒功能，不能重复关闭!");
        }

        baseDao.insert("dGprsShortMsgOffOnHisNew.insertd", inParam);
        inMap.put("OP_CODE", inParam.get("OP_CODE"));
        inMap.put("LOGIN_NO", inParam.get("LOGIN_NO"));
        baseDao.delete("dGprsShortMsgOffOnNew.delete", inMap);
    }

    @Override
    public void delGprsInterMsgOffOn(Map<String, Object> inParam) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        String phoneNo = inParam.get("PHONE_NO").toString();
        inMap.put("PHONE_NO", phoneNo);
        String offOnType = "";
        outMap = (Map<String, Object>) baseDao.queryForObject("dGprsInterMsgOffOn.qry", inMap);
        if (outMap == null) {
            offOnType = "A";
        } else {
            offOnType = outMap.get("OFFON_TYPE").toString();
        }
        if (offOnType.equals(inParam.get("OFFON_TYPE").toString())) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90003"), "该用户已经开通gprs流量提醒功能，不能重复开通!");
        }

        baseDao.insert("dGprsInterMsgOffOnHis.insert", inParam);

        inMap.put("OP_CODE", inParam.get("OP_CODE"));
        inMap.put("LOGIN_NO", inParam.get("LOGIN_NO"));
        baseDao.delete("dGprsInterMsgOffOn.delete", inMap);

    }

    @Override
    public void saveGprsInterMsgOffOn(Map<String, Object> inParam) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        String phoneNo = inParam.get("PHONE_NO").toString();
        inMap.put("PHONE_NO", phoneNo);
        String offOnType = "";
        outMap = (Map<String, Object>) baseDao.queryForObject("dGprsInterMsgOffOn.qry", inMap);
        if (outMap == null) {
            offOnType = "A";
        } else {
            offOnType = outMap.get("OFFON_TYPE").toString();
        }
        if (offOnType.equals(inParam.get("OFFON_TYPE").toString())) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90004"), "该用户已经关闭gprs流量提醒功能，不能重复关闭!");
        }

        baseDao.insert("dGprsInterMsgOffOn.insert", inParam);

    }

    @Override
    public String getOffOnType(String phoneNo, String opFlag) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);
        inMap.put("OP_FLAG", opFlag);
        String offOnType = "";
        outMap = (Map<String, Object>) baseDao.queryForObject("dShortMsgOffOn.qryByFlag", inMap);
        if (outMap == null) {
            if (opFlag.equals("9")) {
                outMap = (Map<String, Object>) baseDao.queryForObject("dShortMsgOffOn.qryByType", inMap);
                if (outMap == null) {
                    offOnType = "A";
                }
            } else {
                offOnType = "A";
            }
        } else {
            offOnType = outMap.get("OFFON_TYPE").toString();
        }

        return offOnType;

    }

    @Override
    public void delShortMsgOffOn(Map<String, Object> inParam) {
        baseDao.insert("dShortMsgOffOnHis.insertA", inParam);

        baseDao.delete("dShortMsgOffOn.delete", inParam);

    }

    @Override
    public void saveShortMsgOffOn(Map<String, Object> inParam) {
        baseDao.delete("dShortMsgOffOn.delete", inParam);
        baseDao.insert("dShortMsgOffOn.insert", inParam);

    }

    @Override
    public void updateShortMsgOffOn(Map<String, Object> inParam) {
        baseDao.delete("dShortMsgOffOnHis.insertE", inParam);
        baseDao.insert("dShortMsgOffOn.update", inParam);

    }

    @Override
    public String getTimeOffOnType(String phoneNo, String opFlag) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);
        inMap.put("OP_FLAG", opFlag);
        String offOnType = "";
        outMap = (Map<String, Object>) baseDao.queryForObject("dShortMsgTimeOffOn.qry", inMap);
        int count = Integer.parseInt(outMap.get("COUNT").toString());
        if (count == 0) {
            offOnType = "D";
        } else if (count == 1) {
            offOnType = "A";
        }
        return offOnType;

    }

    @Override
    public void delShortMsgTimeOffOn(Map<String, Object> inParam) {
        baseDao.insert("DShortMsgTimeOffOnHis.insert", inParam);
        baseDao.delete("dShortMsgTimeOffOn.delete", inParam);

    }

    @Override
    public void saveShortMsgTimeOffOn(Map<String, Object> inParam) {
        baseDao.insert("dShortMsgTimeOffOn.insert", inParam);

    }

    @Override
    public String getPhoneHead(String phoneNoSeven, String phoneNoEight) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        String phoneHead = "";
        int count = 0;
        inMap.put("PHONE_NO", phoneNoSeven);
        count = (Integer) baseDao.queryForObject("h1h2h3_code_allocate.qCnt", inMap);
        if (count > 0) {
            phoneHead = phoneNoSeven;
        } else {
            inMap.put("PHONE_NO", phoneNoEight);
            count = (Integer) baseDao.queryForObject("h1h2h3_code_allocate.qCnt", inMap);
            if (count > 0) {
                phoneHead = phoneNoEight;
            } else {
				throw new BusiException(AcctMgrError.getErrorCode("0000", "90005"), "不存在该号段!");
            }
        }
        return phoneHead;

    }

    @Override
    public ProvCityListEntity getProvCityInfo(String phoneNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        String phoneHead = "";
        inMap.put("PHONE_NO", phoneNo);
        ProvCityListEntity pcle = (ProvCityListEntity) baseDao.queryForObject("prov_city_list.qry", inMap);

        return pcle;

    }

    @Override
    public List<ChatTypeEntity> getChatTypeInfo() {
        Map<String, Object> inMap = new HashMap<String, Object>();
        List<ChatTypeEntity> list = (List<ChatTypeEntity>) baseDao.queryForList("chat_type_info.qry", inMap);

        return list;

    }

    public String getSpName(String spId) {
        String spName = (String) baseDao.queryForObject("ddsmpspinfo.getSpName", spId);
        if (StringUtils.isEmpty(spName)) {
            spName = spId;
        }
        return spName;
    }

    public String getOperName(String spId, String operCode) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("SP_ID", spId);
        inMap.put("BIZ_CODE", operCode);

        String servName = (String) baseDao.queryForObject("ddsmpspbizinfo.getBizName", inMap);
        if (StringUtils.isEmpty(servName)) {
            servName = operCode;
        }
        return servName;

    }

    public String getbillTypeName(String billType) {
		// TODO:查询计费名称
        // return "3";
        return null;

    }

    @Override
    public List<String> getRateCode(String prcId, String detailType, String regionCode) {
        List<PrcIdTransEntity> prcInfoList = this.getRateInfo(prcId, detailType, regionCode);

        List<String> rateList = new ArrayList<>();
        for (PrcIdTransEntity prcInfo : prcInfoList) {
            rateList.add(prcInfo.getDetailCode());
        }
        return rateList;
    }

    @Override
    public List<PrcIdTransEntity> getRateInfo(String prcId, String detailType, String regionCode) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PRC_ID", prcId);
        if (StringUtils.isNotEmptyOrNull(detailType)) {
            inMap.put("DETAIL_TYPE", detailType);
        }
        inMap.put("REGION_CODE", regionCode.substring(2, 4));
        List<PrcIdTransEntity> prcInfo = baseDao.queryForList("pricing_combine.getModeList", inMap);
        return prcInfo;
    }

    @Override
    public String getDailyGameName(String contextId, String spCode) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTEXT_CODE", contextId);
        safeAddToMap(inMap, "SP_CODE", spCode);

        return (String) baseDao.queryForObject("daily_game.qryGameName", inMap);
    }

    @Override
    public String getMmappName(String contextId, String totalDate) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "CONTEXT_CODE", contextId);
        safeAddToMap(inMap, "TOTAL_DATE", totalDate);
        return (String) baseDao.queryForObject("mmapp_info.qryMmappName", inMap);
    }

    @Override
    public String getMusicName(String operCode, String copyRightCode) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "OPER_CODE", operCode);
        safeAddToMap(inMap, "COPYRIGHT_CODE", copyRightCode);
        return (String) baseDao.queryForObject("music_info.qryMusicName", inMap);
    }

    @Override
    public List<LocationCodeEntity> getLocationInfo(String lacCode, String cellId, String flagCode) {
        Map<String, Object> inMap = new HashMap<>();
        if (StringUtils.isNotEmpty(lacCode)) {
            safeAddToMap(inMap, "LAC_CODE", lacCode);
        }
        if (StringUtils.isNotEmpty(cellId)) {
            safeAddToMap(inMap, "CELL_ID", cellId);
        }
        if (StringUtils.isNotEmpty(flagCode)) {
            safeAddToMap(inMap, "FLAG_CODE", flagCode);
        }

        List<LocationCodeEntity> resultList = baseDao.queryForList("location_code_info.qry", inMap);
        if (resultList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90006"), "小区计费数据不存在!");
        }
        return resultList;
    }

    @Override
    public Map<String, Object> getGPRSStatus(String phoneNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();

        inMap.put("PHONE_NO", phoneNo);
        Map<String, Object> outMap = (Map<String, Object>) baseDao.queryForObject("dGprsShortMsgOffOn.qry", inMap);
        return outMap;
    }

    @Override
    public int getShipStatus(String phoneNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);
        // String[] ruleId = { "100030", "100031" };

        List<String> ruleId = new ArrayList<>();

        ruleId.add("100030");
        ruleId.add("100031");

        inMap.put("RULE_ID", ruleId);

        int cnt = (int) baseDao.queryForObject("remind_warn_user_info.qCnt", inMap);

        return cnt;
    }

    @Override
    public int getCntGuMan(String phoneNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);

        List<String> ruleId = new ArrayList<>();

        ruleId.add("100033");

        inMap.put("RULE_ID", ruleId);

        int cnt = (int) baseDao.queryForObject("remind_warn_user_info.qCnt", inMap);

        return cnt;
    }

    @Override
    public void saveDataGuMan(Map<String, Object> inMap) {
        baseDao.insert("remind_warn_user_info.ins", inMap);
    }

    @Override
    public void delDataGuMan(long idNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("ID_NO", idNo);
        List<String> ruleId = new ArrayList<>();

        ruleId.add("100033");

        inMap.put("WARN_RULE_ID", ruleId);
        baseDao.delete("remind_warn_user_info.del", inMap);
        baseDao.insert("DGprsOffOnChg.insert", inMap);
    }

    @Override
    public List<GprsChangeRecdEntity> getGprsStatusChange(Map<String, Object> inMap) {
        List<GprsChangeRecdEntity> changeList = new ArrayList<GprsChangeRecdEntity>();
        List<GprsChangeRecdEntity> openList = baseDao.queryForList("dGprsShortMsgOffOnHis.qChangeRecd", inMap);
        List<GprsChangeRecdEntity> closeList = baseDao.queryForList("dGprsShortMsgOffOn.qChangeRecd", inMap);

        changeList.addAll(closeList);
        changeList.addAll(openList);

        return changeList;
    }

    @Override
    public void changeShipStatus(Map<String, Object> inMap) {
		if (inMap.get("FLAG").toString().equals("关闭")) {// 关闭
            inMap.put("WARN_RULE_ID", "100030");
            inMap.put("LOGIN_ACCEPT", control.getSequence("SEQ_SYSTEM_SN"));
			log.debug("参数：" + inMap);
            baseDao.insert("remind_warn_user_info.ins", inMap);

            inMap.put("WARN_RULE_ID", "100031");
            inMap.put("LOGIN_ACCEPT", control.getSequence("SEQ_SYSTEM_SN"));
            baseDao.insert("remind_warn_user_info.ins", inMap);
        } else {
            List<String> ruleList = new ArrayList<String>();
            ruleList.add("100030");
            ruleList.add("100031");
            inMap.put("WARN_RULE_ID", ruleList);
            baseDao.delete("remind_warn_user_info.del", inMap);
        }

    }

    @Override
    public Map<String, Object> getMonthCodeInfo(String regionCode, String monthCode) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("REGION_CODE", regionCode.substring(2, 4));
        inMap.put("MONTH_CODE", monthCode);
        Map<String, Object> monthShareMap = (Map<String, Object>) baseDao.queryForObject("sBillMonthCode.qMonthShare", inMap);
        return monthShareMap;
    }

    @Override
    public int getMonthCfg(Map<String, Object> inMap) {
        int cnt = (int) baseDao.queryForObject("cBillstatCfg.qCnt", inMap);
        return cnt;
    }

    @Override
    public Map<String, Object> getFlag(Map<String, Object> inMap) {

		Map<String, Object> flagMap = new HashMap<String, Object>();
		List<Map<String, Object>> prcIdList = baseDao.queryForList("ur_usergoodsprcattr_info.qPrcId", inMap);
		if (prcIdList.size() > 0) {
			List<String> rateCodeList = getRateCode(prcIdList.get(0).get("PRC_ID").toString(), "", "23" + inMap.get("REGION_CODE").toString());
			if(StringUtils.isEmptyOrNull(prcIdList.get(0).get("ATTR_VALUE"))){
				return flagMap;
			}
			String flagCode=prcIdList.get(0).get("ATTR_VALUE").toString();
			for (String rate : rateCodeList) {
				Map<String, Object> flagInMap = new HashMap<String, Object>();
				flagInMap.put("REGION_CODE", inMap.get("REGION_CODE"));
				flagInMap.put("RATE_CODE", rate);
				flagInMap.put("FLAG_CODE", flagCode);
				flagMap = (Map<String, Object>) baseDao.queryForObject("srateflagcode.qFlag", flagInMap);
				if (flagMap != null) {
					break;
				}
			}
		}
    	
		// flagMap = (Map<String, Object>) baseDao.queryForObject("sofferflagcode.qFlagInfo", inMap);
		// 根据id_no和ATTR_ID查询
        return flagMap;
    }

    @Override
    public int getCntTellShort(String phoneNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);
        int cnt = (int) baseDao.queryForObject("dTellShortMsgOffOn.qryCnt", inMap);
        return cnt;

    }

    @Override
    public String getTypeTellShort(String phoneNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);
        String type = (String) baseDao.queryForObject("dTellShortMsgOffOn.qryType", inMap);
        return type;
    }

    public Map<String, Object> saveTellShortMsgOffOn(String opType, String phoneNo, long idNo, String loginNo, long loginAccept) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        String returnCode = "";
        String returnMsg = "";

        String sCurDate = DateUtil.format(new Date(), "yyyyMMdd");

		// 入wTellCode表
        inMap.put("PHONE_NO", phoneNo);
        inMap.put("ID_NO", idNo);
        inMap.put("LOGIN_NO", loginNo);
        inMap.put("OFFON_TYPE", opType);
        inMap.put("LOGIN_ACCEPT", loginAccept);
        baseDao.insert("wTellCode.insert", inMap);

        int cnt = 0;
        cnt = getCntTellShort(phoneNo);
        if (cnt == 1) {
            String offOnType = "";
            offOnType = getTypeTellShort(phoneNo);
            if (offOnType.equals(opType)) {
                if (opType.equals("1")) {
                    returnCode = "10111109000090007";
					returnMsg = "尊敬的客户，您已经开通扣费提醒短信接收功能，无需重复开通。";
					// throw new BusiException(AcctMgrError.getErrorCode("0000", "90007"), "尊敬的客户，您已经开通扣费提醒短信接收功能，无需重复开通。");
                }
                if (opType.equals("0")) {
                    returnCode = "10111109000090008";
					returnMsg = "尊敬的客户，您已经取消扣费提醒短信接收功能，无需重复取消。";
					// throw new BusiException(AcctMgrError.getErrorCode("0000", "90008"), "尊敬的客户，您已经取消扣费提醒短信接收功能，无需重复取消。");
                }
            } else {
				// 先入历史表
                inMap.put("PHONE_NO", phoneNo);
                inMap.put("ID_NO", idNo);
                inMap.put("LOGIN_NO", loginNo);
                inMap.put("OP_TYPE", opType);
                inMap.put("TOTAL_DATE", sCurDate);
                inMap.put("LOGIN_ACCEPT", loginAccept);
                baseDao.insert("dTellShortMsgOffOn.insertHis", inMap);
				// 修改正表状态
                baseDao.update("dTellShortMsgOffOn.update", inMap);
                if (opType.equals("1")) {
                    returnCode = "10111109000090040";
					returnMsg = "尊敬的客户，您已经开通扣费提醒短信接收功能，如需取消请发送QXKFTX到10086。中国移动";
                }
                if (opType.equals("0")) {
                    returnCode = "10111109000090041";
					returnMsg = "尊敬的客户，您已经取消扣费提醒短信接收功能，如需开通请发送KTKFTX到10086。中国移动";
                }
            }
        } else {
            if (opType.equals("1")) {
                returnCode = "10111109000090007";
				returnMsg = "尊敬的客户，您已经开通扣费提醒短信接收功能，无需重复开通。";
				// throw new BusiException(AcctMgrError.getErrorCode("0000", "90007"), "尊敬的客户，您已经开通扣费提醒短信接收功能，无需重复开通。");
            }
            if (opType.equals("0")) {
				// 入正表
                baseDao.insert("dTellShortMsgOffOn.insert", inMap);
                returnCode = "10111109000090041";
				returnMsg = "尊敬的客户，您已经取消扣费提醒短信接收功能，如需开通请发送KTKFTX到10086。中国移动";
            }
        }

        Map<String, Object> outMap = new HashMap<String, Object>();
        outMap.put("RETURN_CODE", returnCode);
        outMap.put("RETURN_MSG", returnMsg);
        return outMap;
    }

    @Override
    public List<ProvCriticalEntity> getProvCriticalInfo(Map<String, Object> inMap) {
        List<ProvCriticalEntity> resultList = (List<ProvCriticalEntity>) baseDao.queryForList("sProvCritical.qry", inMap);
        return resultList;
    }

    @Override
    public Map<String, Object> getTellCodeA(String loginAccept, String phoneNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        inMap.put("LOGIN_ACCEPT", loginAccept);
        inMap.put("PHONE_NO", phoneNo);
        int cnt = (int) baseDao.queryForObject("tellcode_inc_bak.qCnt", inMap);
        if(cnt==0) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90010"), "用户回复超时!");
        }
        outMap = (Map<String, Object>) baseDao.queryForObject("TellCode.qry", inMap);
        String zyFlag = "";
        String spName = "";
        String servName = "";
        if (outMap != null) {
        	 zyFlag = outMap.get("ZY_FLAG").toString();
             spName = outMap.get("SP_NAME").toString();
             servName = outMap.get("SERV_NAME").toString();
        }
       

        baseDao.update("tellcode_inc_bak.updateN", inMap);

        outMap = (Map<String, Object>) baseDao.queryForObject("tellcode_inc_bak.qry", inMap);
        String prodPrcInsId = outMap.get("PRODPRCINS_ID").toString();
        /*
        String spCode = outMap.get("SP_CODE").toString();
        String operCode = outMap.get("OPER_CODE").toString();

        
        inMap.put("SP_CODE", spCode);
        inMap.put("OPER_CODE", operCode);
        String servCode = (String) baseDao.queryForObject("order_info.qry", inMap);
        */

        outMap = new HashMap<String, Object>();
        outMap.put("PRODPRCINS_ID", prodPrcInsId);
        outMap.put("SP_NAME", spName);
        outMap.put("SERV_NAME", servName);
        /*
        outMap.put("SP_CODE", spCode);
        outMap.put("OPER_CODE", operCode);
        outMap.put("SERV_CODE", servCode);
        */
        return outMap;
    }

    @Override
    public Map<String, Object> getTellCodeB(String loginAccept, String phoneNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();

		// 查询系统时间
        String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
        String sysMonth = sCurTime.substring(0, 6);

        int ret = 0;
        inMap.put("PHONE_NO", phoneNo);
        ret = (int) baseDao.queryForObject("TellCode.qCnt", inMap);
        if (ret == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90010"), "用户回复超时!");
        }

        inMap.put("PHONE_NO", phoneNo);
        inMap.put("LOGIN_ACCEPT", loginAccept);
        ret = 0;
        ret = (int) baseDao.queryForObject("TellCode.qCnt", inMap);
        if (ret == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90011"), "输入随机码出错!");
        }

        outMap = (Map<String, Object>) baseDao.queryForObject("tellcode_inc_bak.qry", inMap);
        if (outMap == null) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90012"), "查询反馈标识出错!");
        }
        if (!outMap.get("FLAG1").toString().equals("0")) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90013"), "已经确认过该业务!");
        }
        String orderId = outMap.get("ORDER_ID").toString();
        String orderFlag = outMap.get("ORDER_FLAG").toString();
        String spCode = outMap.get("SP_CODE").toString().trim();
        String operCode = outMap.get("OPER_CODE").toString().trim();

        outMap = (Map<String, Object>) baseDao.queryForObject("TellCode.qry", inMap);
        if (outMap == null) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90014"), "查询业务类型出错!");
        }
		String spName = "";// 查询公司名称
        if (outMap.get("ZY_FLAG").toString().equals("1")) {
            spName = outMap.get("SP_NAME").toString();
        }
        String servName = outMap.get("SERV_NAME").toString();
        String fee = outMap.get("FEE").toString();

        if (orderId.equals("B")) {
            ret = 0;
            inMap = new HashMap<String, Object>();
            inMap.put("PHONE_NO", phoneNo);
            inMap.put("YEAR_MONTH", sysMonth);
            ret = (int) baseDao.queryForObject("tellcode_inc_bak.qCntDel", inMap);
            if (ret < 2) {
                inMap.put("PHONE_NO", phoneNo);
                inMap.put("LOGIN_ACCEPT", loginAccept);
                baseDao.update("tellcode_inc_bak.updateZ", inMap);
                if (orderFlag.equals("0")) {
					// 拼短信
					// 您好：关于您%s短信回复的%s业务的问题，本次已为您做免费处理，请您留意账单。我公司会对该业务进行后续核查，感谢您的反馈。",BackTime,ServName
                } else {
					/* inMap = new HashMap<String, Object>(); inMap.put("PHONE_NO", phoneNo); inMap.put("SP_CODE", spCode); inMap.put("OPER_CODE", operCode); outMap = (Map<String, Object>) baseDao.queryForObject("order_info.qry", inMap); if (outMap == null) { throw new BusiException(AcctMgrError.getErrorCode("0000", "90015"), "查询业务类型代码错误!"); } String servCode = outMap.get("SERV_CODE").toString(); */
                    if (spCode.equals("gggggg")) {
						// 调用CRM服务sJTUnifyCfm
                    } else {
						// 调用CRM退订服务
                    }

					// 拼短信
					// "您好：关于您%s短信回复的%s业务的问题，本次已为您做免费处理并退订业务，请您留意账单。我公司会对该业务进行后续核查，感谢您的反馈。",BackTime,ServName
                }
				// 发送短信
            } else {
                inMap.put("PHONE_NO", phoneNo);
                inMap.put("LOGIN_ACCEPT", loginAccept);
                baseDao.update("tellcode_inc_bak.updateReply", inMap);
				// 拼短信
				// "您好：关于您%s短信回复的%s业务的问题，本次未做免费处理，如有疑义有请致电10086，感谢您的配合。",BackTime,ServName
				// 发送短信
            }
        } else {
            inMap = new HashMap<String, Object>();
            inMap.put("PHONE_NO", phoneNo);
            inMap.put("LOGIN_ACCEPT", loginAccept);
            baseDao.update("tellcode_inc_bak.updateY", inMap);
        }

        outMap = new HashMap<String, Object>();
        outMap.put("SERV_NAME", servName);
        outMap.put("SP_NAME", spName);
        return outMap;
    }

    @Override
    public int getCntTellCodeInc(String phoneNo, String loginAccept) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);
        inMap.put("LOGIN_ACCEPT", loginAccept);
        int cnt = (int) baseDao.queryForObject("tellcode_inc_bak.qCnt", inMap);
        return cnt;

    }

    @Override
    public void saveWlanOpenChg(String phoneNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);

        String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
        String sysMonth = sCurTime.substring(0, 6);

        int cnt = (int) baseDao.queryForObject("wctrlmodecfghis.qCntX", inMap);
        if (cnt > 0) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90016"), "用户不能再次开通wlan！");
        } else {
            inMap.put("YEAR_MONTH", sysMonth);
            baseDao.insert("wlan_open_chg.insert", inMap);
        }

    }

    @Override
    public void getCntWlanOpenW(String phoneNo) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PHONE_NO", phoneNo);

        int cnt = (int) baseDao.queryForObject("wctrlmodecfghis.qCntW", inMap);
        if (cnt == 2) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90017"), "用户已经达到50G封顶,不能再次开通！");
        } else if (cnt != 1) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90018"), "开通失败！");
        }
    }

    @Override
    public String getGprsFavClassName(String favClass) {
        String favClassName = "";
		// 获取计费侧流量限制分类及流量地域分类的内容
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "FAV_CLASS", favClass);
        favClassName = (String) baseDao.queryForObject("fav_class_info.qFavClassName", inMap);
        return favClassName;
    }

    @Override
    public PriceCodeEntity getPriceInfo(String priceCode) {
        return this.getPriceInfo(priceCode, null, null, null);
    }

    @Override
    public PriceCodeEntity getPriceInfo(String priceCode, String serviceType, String serviceCode, String chargeFlags) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PRICE_CODE", priceCode);
        if (StringUtils.isNotEmpty(serviceType)) {
            inMap.put("SERVICE_TYPE", serviceType);
        }
        if (StringUtils.isNotEmpty(serviceCode)) {
            inMap.put("SERVICE_CODE", serviceCode);
        }
        if (StringUtils.isNotEmpty(chargeFlags)) {
            inMap.put("CHARGE_FLAGS", chargeFlags.split("\\,"));
        }
        PriceCodeEntity priceCodeInfo = (PriceCodeEntity) baseDao.queryForObject("spricecode.qPriceCodeInfo", inMap);
        return priceCodeInfo;
    }

    @Override
    public List<PrcIdTransEntity> getPrcDetailList(String prcId, String bargainparaFlag, String regionCode) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PRC_ID", prcId);
        if (StringUtils.isNotEmpty(bargainparaFlag)) {
            inMap.put("BARGAINPARA_FLAG", bargainparaFlag);
        }
        inMap.put("REGION_CODE", regionCode.substring(2, 4));

        List<PrcIdTransEntity> list = (List<PrcIdTransEntity>) baseDao.queryForList("pricing_combine.getModeList", inMap);

        return list;
    }

    @Override
    public int getCountFlag(String prcId, String detailCode, String detailType, String regionCode) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PRC_ID", prcId);
        inMap.put("DETAIL_TYPE", detailType);
        inMap.put("DETAIL_CODE", detailCode);
        inMap.put("REGION_CODE", regionCode.substring(2, 4));
        int countFlag = (Integer) baseDao.queryForObject("pricing_combine.qryCount", inMap);
        return countFlag;
    }

    @Override
    public String getGroupDxFlag(long idNo) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "ID_NO", idNo);
        int count = (Integer) baseDao.queryForObject("dgrouplowestcloud.qCnt", inMap);
        return count > 0 ? "1" : "0";
    }

    @Override
    public Map<String, Object> getYearFeeInfo(long idNo, String regionCode) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "REGION_CODE", regionCode.substring(2, 4));
        Map<String, Object> result = (Map<String, Object>) baseDao.queryForObject("sbilltotcode.getYearFeeInfo", inMap);

        return result;
    }

    @Override
    public long getYearUsedFee(long idNo, String regionCode) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "ID_NO", idNo);
        safeAddToMap(inMap, "REGION_CODE", regionCode.substring(2, 4));
        long yearShould = (Long) baseDao.queryForObject("sbilltotcode.getYearUsedFee", inMap);

        return yearShould;
    }

    @Override
    public Integer getGprsMinOrder(String prcId, String regionCode) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "PRC_ID", prcId);
        safeAddToMap(inMap, "REGION_CODE", regionCode.substring(2, 4));
        Integer gprsMinOrder = (Integer) baseDao.queryForObject("pricing_combine.qryGprsMinOrder", inMap);
        return gprsMinOrder;
    }

    @Override
    public Integer getVoiceDisOrder(String prcId, String regionCode, boolean isVoice) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PRC_ID", prcId);
        if (isVoice == true) {
            inMap.put("EXPECT", isVoice);
        }
        inMap.put("REGION_CODE", regionCode.substring(2, 4));
        Integer voiceDisOrder = (Integer) baseDao.queryForObject("pricing_combine.qryVoiceDisOrder", inMap);
        return voiceDisOrder;
    }

    @Override
    public Map<String, Object> getYearFavourFee(String regionCode, String detailCode) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "DETAIL_CODE", detailCode);
        safeAddToMap(inMap, "REGION_CODE", regionCode.substring(2, 4));
        Map<String, Object> result = (Map<String, Object>) baseDao.queryForObject("sbilltotcode.getYearFavourFee", inMap);

        return result;
    }

    @Override
    public List<PrcIdTransEntity> getDetailCodeList(String prcId, String regionCode, String detailTypes) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("PRC_ID", prcId);
        if (StringUtils.isNotEmpty(detailTypes)) {
            inMap.put("DETAIL_TYPES", detailTypes.split("\\,"));
        }
        inMap.put("REGION_CODE", regionCode.substring(2, 4));
        List<PrcIdTransEntity> list = (List<PrcIdTransEntity>) baseDao.queryForList("pricing_combine.getModeList", inMap);

        return list;
    }
    
    @Override
    public long getKdMonthFee(String prcId, String regionCode){
    	
		log.info("获取宽带每月费用开始，PRC_ID： " + prcId + "REGION_CODE: " + regionCode);
    	
		// 取当月应收费用
        long totalMonthFee = 0;
        List<PrcIdTransEntity> prcDetailList = new ArrayList<PrcIdTransEntity>();
        prcDetailList = this.getDetailCodeList(prcId, regionCode, "1,9,c,d");
        if (prcDetailList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "20013"), "资费类型不允许办理!");
        }
        for (PrcIdTransEntity pite : prcDetailList) {
            long monthFee = 0;
            String detailType = pite.getDetailType();
            String detailCode = pite.getDetailCode();
            Map<String, Object> outMap = this.getMonthCodeInfo(regionCode, detailCode);
            if (outMap != null) {
                Double dmonthFee = Double.parseDouble(outMap.get("MONTH_FEE").toString()) * 100;
                monthFee = dmonthFee.longValue();
                log.info("monthFee===" + monthFee);
            }
            totalMonthFee = totalMonthFee + monthFee;
        }
        
        return totalMonthFee;
    }
    
    @Override
	public long getUserMonthFee(long idNo, String regionCode){
    	
    	
    	  Map<String, Object> inMap = new HashMap<String, Object>();
    	  long monthFee = 0L;
          inMap.put("BELONG_CODE", regionCode.substring(2, 4));
          
          List<UserPrcEntity> pdList = new ArrayList<UserPrcEntity>();
          pdList = prod.getPdPrcId(idNo, true);
          
          for(UserPrcEntity userPrc:pdList){
        	  
        	 inMap.put("PRC_ID", userPrc.getProdPrcid());  
        	 monthFee += (long) baseDao.queryForObject("fav_remind_info.qFavRemindFee", inMap);
          }
          
          return monthFee;
    }

    @Override
    public int getGprsState(String prcId, String regionCode) {
        Map<String, Object> inMap = new HashMap<>();
        safeAddToMap(inMap, "PRC_ID", prcId);
        safeAddToMap(inMap, "REGION_CODE", regionCode.substring(2, 4));
        int gprsState = (int) baseDao.queryForObject("pricing_combine.qryCarryGprsInfo", inMap);
        return gprsState;
    }

    @Override
    public List<GrpRedEntity> getGrpCreditInfo(String unitId) {
        Map<String, Object> inMap = new HashMap<String, Object>();

        safeAddToMap(inMap, "UNIT_ID", unitId);
        List<GrpRedEntity> userList = null;
        userList = (List<GrpRedEntity>) baseDao.queryForList("dgrpredlist_inter.qryGrpCreditInfoN", inMap);
        if(userList.size()==0) {
        	userList = (List<GrpRedEntity>) baseDao.queryForList("dgrpredlist_inter.qryGrpCreditInfoY", inMap);
        }
        return userList;
    }

    @Override
    public List<NonStopEntity> getNonStopInfo(String unitId) {
        Map<String, Object> inMap = new HashMap<String, Object>();

        safeAddToMap(inMap, "UNIT_ID", unitId);

        List<NonStopEntity> userList = (List<NonStopEntity>) baseDao.queryForList("dgrpredlist_inter.qryNonStopInfo", inMap);

        return userList;
    }

    @Override
    public List<BillTotCodeEntity> getBillTotCodeInfo(String regionCode, String totalCode) {
        Map<String, Object> inMap = new HashMap<String, Object>();

        safeAddToMap(inMap, "REGION_CODE", regionCode.substring(2, 4));
        safeAddToMap(inMap, "TOTAL_CODE", totalCode);
        return (List<BillTotCodeEntity>) baseDao.queryForList("sbilltotcode.getBillTotCodeInfo", inMap);
    }

    @Override
    public Double getHalfRate(String regionCode, String prcId) {
        Map<String, Object> inMap = new HashMap<String, Object>();

        safeAddToMap(inMap, "REGION_CODE", regionCode.substring(2, 4));
        safeAddToMap(inMap, "MODE_CODE", prcId);
        return (Double) baseDao.queryForObject("sbillhalffav.getHalfRate", inMap);
    }

    @Override
    public Integer getWlanOrder(String prcId, String regionCode) {
        Map<String, Object> inMap = new HashMap<String, Object>();

        safeAddToMap(inMap, "REGION_CODE", regionCode.substring(2, 4));
        safeAddToMap(inMap, "PRC_ID", prcId);
        Integer wlanOrder = (Integer) baseDao.queryForObject("pricing_combine.qryWlanOrder", inMap);
        return wlanOrder;
    }

    @Override
    public List<TellCodeEntity> getTellCodeDelList(String beginTime, String endTime) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("BEGIN_TIME", beginTime);
        inMap.put("END_TIME", endTime);
        List<TellCodeEntity> list = (List<TellCodeEntity>) baseDao.queryForList("tellcode_inc_bak.qryDel", inMap);

        return list;
    }

    @Override
    public int judgeRollMonthBill(long idNo) {
        int cnt = (int) baseDao.queryForObject("ur_dynaccount_info.qCnt", idNo);
        return cnt;
    }

    @Override
    public int haveFix(long idNo, String[] detailType, String detailCode) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("ID_NO", idNo);
        inMap.put("FAVOUR_TYPE", detailType);
        inMap.put("FAVOUR_CODE", detailCode);
        inMap.put("SUFFIX", idNo % (idNo / 10));
        int cnt = (int) baseDao.queryForObject("dcustfavmsg.qCnt", inMap);
        return cnt;
    }

    @Override
    public int qryAccDay(long idNo) {
        Map<String, Object> outMap = (Map<String, Object>) baseDao.queryForObject("ur_dynaccount_info.qAccDay", idNo);
        int acctDay = 0;
        if (outMap != null) {
            acctDay = ValueUtils.intValue(outMap.get("ACCT_DAY"));
        }
        return acctDay;
    }

    @Override
    public void inSbillcodeUser(Map<String, Object> inMap) {

        Map<String, Object> inMapTmp = null;
        Map<String, Object> outMapTmp = null;

        inMapTmp = new HashMap<>();
        inMapTmp.put("REGION_CODE", inMap.get("REGION_ID").toString().substring(2, 4));
        inMapTmp.put("PRC_ID", inMap.get("PRC_ID"));
        outMapTmp = (Map<String, Object>) baseDao.queryForObject("sbilltotcode_user.qDetailCode", inMapTmp);
        String totalCode = outMapTmp.get("DETAIL_CODE").toString();

        inMapTmp = new HashMap<>();
        inMapTmp.put("REGION", inMap.get("REGION_ID").toString().substring(2, 4));
        inMapTmp.put("CONTRACT_NO", inMap.get("CONTRACT_NO"));
        inMapTmp.put("ID_NO", inMap.get("ID_NO"));
        inMapTmp.put("PHONE_NO", inMap.get("PHONE_NO"));
        inMapTmp.put("BASE_FEE", inMap.get("BASE_FEE"));
        inMapTmp.put("END_TIME", inMap.get("END_TIME"));
        baseDao.insert("sbilltotcode_user.isbilltotcodeUser", inMapTmp);
    }

    @Override
    public Fav1860CfgEntity getFavInfo(long regionCode, String modeCode, String favType) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("REGION_CODE", regionCode);
        inMap.put("MODE_CODE", modeCode);
        if (!StringUtils.isEmpty(favType)) {
            inMap.put("FAV_TYPE", favType);
        }
        Fav1860CfgEntity favInfoEnt = (Fav1860CfgEntity) baseDao.queryForObject("sFav1860Cfg.qFavInfo", inMap);
        if (null == favInfoEnt) {
            favInfoEnt = new Fav1860CfgEntity();
        }
        return favInfoEnt;
    }

    @Override
    public long getBroadBandFee(String regionCode, String prcId) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("REGION_CODE", regionCode.substring(2, 4));
        inMap.put("PRC_ID", prcId);

        long monthFee = (long) baseDao.queryForObject("sBillMonthCode.qMonthFee", inMap);

        return monthFee;
    }

    @Override
    public int monthCfg(String prcId, String regionCode) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("REGION_CODE", regionCode.substring(2, 4));
        inMap.put("MODE_CODE", prcId);
        return ((int) baseDao.queryForObject("cBillStatCfg.qMonthCfg", inMap));
    }

    @Override
    public int isFamilyMonthCode(String detailCode) {
        return ((int) baseDao.queryForObject("sbillfamilymonthcode.qCnt", detailCode));
    }
    
    @Override
    public void delRemindQinQing(Map<String, Object> inParam) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        String phoneNo = inParam.get("PHONE_NO").toString();
        inMap.put("PHONE_NO", phoneNo);
        String offOnType = "";
        long cnt = (long) baseDao.queryForObject("remind_qinqing_control.qry", inMap);
        if (cnt == 0) {
            offOnType = "A";
        } else {
            offOnType = "D";
        }
        if (offOnType.equals(inParam.get("OFFON_TYPE").toString())) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90027"), "该用户已经开通该提醒功能，不能重复开通!");
        }

        baseDao.insert("remind_qinqing_control.insertHis", inParam);

        inMap.put("OP_CODE", inParam.get("OP_CODE"));
        baseDao.delete("remind_qinqing_control.delete", inMap);
    }

    @Override
    public void saveRemindQinQing(Map<String, Object> inParam) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        Map<String, Object> outMap = new HashMap<String, Object>();
        String phoneNo = inParam.get("PHONE_NO").toString();
        inMap.put("PHONE_NO", phoneNo);
        String offOnType = "";
        long cnt = (long) baseDao.queryForObject("remind_qinqing_control.qry", inMap);
        if (cnt == 0) {
            offOnType = "A";
        } else {
        	offOnType = "D";
        }
        if (offOnType.equals(inParam.get("OFFON_TYPE").toString())) {
			throw new BusiException(AcctMgrError.getErrorCode("0000", "90028"), "该用户已经关闭该提醒功能，不能重复关闭!");
        }

        baseDao.insert("remind_qinqing_control.insert", inParam);

    }

    @Override
	public List<InterRoamProdInfoEntity> getInterRoamUsage(String phoneNo) {
		
    	List<InterRoamProdInfoEntity> irpList = (List<InterRoamProdInfoEntity>) baseDao.queryForList("dProductInfoFun.qryByPhoneNo", phoneNo);
    	
		return irpList;
	}
    
    @Override
    public void insertRoamUsage(Map inMap){
    	baseDao.insert("dProductInfoFun.iDproductInfoFun", inMap);    
    }
    
    @Override
    public void updateRoamUsage(Map inMap){
    	baseDao.insert("dProductInfoFun.uDproductInfoFun", inMap);    
    }

    @Override
    public boolean isSharePrcId(String prcId, String regionCode) {
        Map<String, Object> inMap = new HashMap<String, Object>();
        inMap.put("REGION_CODE", regionCode.substring(2, 4));
        inMap.put("PRC_ID", prcId);
        Integer cnt = (Integer) baseDao.queryForObject("pricing_combine.qryShareCount", inMap);
        return cnt > 0 ? true : false;
    }

    @Override
    public boolean isSendPrcId(String prcId, String favType) {
        Map<String, Object> inMap = new HashMap<>();
        inMap.put("OFFER_ID", prcId);
        inMap.put("FAV_TYPE", favType);
        Integer cnt = (Integer) baseDao.queryForObject("pricing_combine.qrySendCount", inMap);
        return cnt > 0 ? true : false;
    }

    @Override
    public boolean isFlexPrc(String detailCode) {
        Map<String, Object> inMap = new HashMap<>();
        inMap.put("DETAIL_CODE", detailCode);
        Integer cnt = (Integer) baseDao.queryForObject("pricing_combine.qryCntLivePrc", inMap);
        return cnt > 0 ? true : false;
    }

    @Override
    public boolean isDayPrc(String detailCode) {
        Map<String, Object> inMap = new HashMap<>();
        inMap.put("DETAIL_CODE", detailCode);
        Integer cnt = (Integer) baseDao.queryForObject("pricing_combine.qryCntDayPrc", inMap);
        return cnt > 0 ? true : false;
    }
    
    @Override
	public void saveUserGoodsZFYQ(Map<String, Object> inMap) {
		baseDao.insert("ur_usergoods_zfyqchg.insert", inMap);
	}

	@Override
	public List<SPBillAcctRuleEntity> getSPBillRule(String bizType) {
		List<SPBillAcctRuleEntity> spBillRuleList = (List<SPBillAcctRuleEntity>) baseDao.queryForList("spbill_acct_rule.qryByBizType",bizType);
		
		if(spBillRuleList == null || spBillRuleList.size() == 0){
			throw new BusiException(AcctMgrError.getErrorCode("0000", "20016"), "该业务类型代码下无相关信息！");
        }
		
		return spBillRuleList;
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
