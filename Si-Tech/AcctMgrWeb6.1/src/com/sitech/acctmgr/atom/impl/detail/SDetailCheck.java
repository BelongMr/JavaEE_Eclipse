package com.sitech.acctmgr.atom.impl.detail;

import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.detail.PTOPEntity;
import com.sitech.acctmgr.atom.domains.detail.TargetPhoneEntity;
import com.sitech.acctmgr.atom.domains.record.ActQueryOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.detail.SDetailCheckCheckInDTO;
import com.sitech.acctmgr.atom.dto.detail.SDetailCheckCheckOutDTO;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.inter.detail.IDetailCheck;
import com.sitech.acctmgr.net.ServerInfo;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

import java.util.*;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

@ParamTypes(@ParamType(c = SDetailCheckCheckInDTO.class, m = "check", oc = SDetailCheckCheckOutDTO.class))
public class SDetailCheck extends AcctMgrBaseService implements IDetailCheck {

    private IDetailDisplayer detailDisplayer;
    private IUser user;
    private IRecord record;
    private ILogin login;
    private IControl control;

    private static final String CHECK_TYPE_VC = "VC"; /*通话校验*/
    private static final String CHECK_TYPE_SS = "SS"; /*短信校验*/
    private static final String CHECK_VC_ETC = "7005"; /*通话校验的ETC配置文件*/
    private static final String CHECK_SS_ETC = ""; /*短信校验的ETC配置文件*/

    @Override
    public OutDTO check(InDTO inParam) {

        SDetailCheckCheckInDTO inDto = (SDetailCheckCheckInDTO) inParam;
        log.debug("入参 inDto=" + inDto.getMbean());

        String phoneNo = inDto.getPhoneno(); // 主叫号码
        String begintime = inDto.getBegintime();
        String endtime = inDto.getEndtime();
        String opCode = inDto.getOpCode();
        String loginNo = inDto.getLoginNo();
        String groupId = inDto.getGroupId();
        List<TargetPhoneEntity> phoneList = inDto.getPhoneList(); // 对端号码列表

        /*
        List<String> phone_list = new ArrayList<String>();
        for (TargetPhoneEntity tpe : phoneList) {
            String pn = tpe.getTargetPhone();
            if (phone_list.contains(pn)) {
                //TODO 这个规则需要重新确认
                throw new BusiException(AcctMgrError.getErrorCode("8192", "00001"), "不能输入重复的号码进行验证！");
            }
            phone_list.add(pn);
        }

        if (phone_list.contains(phoneNo)) {
            throw new BusiException(AcctMgrError.getErrorCode("8192", "00002"), "对端号码不能为服务号码本身！");
        }
        phone_list = null;
        */

        Map<String, String> typeMap /*存放检验类型的集合*/ = new HashMap<>(); /*key为etc文件代码*/
        Map<String, String> tPhoneSignMap /*目标校验用户通信标识map*/ = new HashMap<>(); //key为targetPhone.typeFlag, value为phoneSign
        for (TargetPhoneEntity tpEnt : phoneList) {
            String qtype = tpEnt.getQueryType();
            if (!typeMap.containsKey(qtype)) {
                if (qtype.equals(CHECK_VC_ETC)) {
                    safeAddToMap(typeMap, CHECK_VC_ETC, CHECK_TYPE_VC);
                }
            }

            if (typeMap.containsKey(qtype)) {
                String typeFlag = typeMap.get(qtype);
                String key = "";
                key = tpEnt.getTargetPhone() + "." + typeFlag;
                if (CHECK_TYPE_VC.equals(typeFlag)) {
                    safeAddToMap(tPhoneSignMap, key, "00"); //语音默认标识
                } else if (CHECK_TYPE_SS.equals(typeFlag)) {
                    safeAddToMap(tPhoneSignMap, key, "10"); //知信默认标识
                }
            }

        }

        String dealBegTime = begintime;
        String dealEndTime = endtime;
        String callBegTime = begintime;
        String callEndTime = endtime;

        String[] options = new String[]{"X", callBegTime, callEndTime};
        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "DETAILQRY");
        Set<String> keySet = typeMap.keySet();
        for (String queryType : keySet) {
            List<String> detailLines = detailDisplayer.queryDetail(phoneNo, queryType, serverInfo, dealBegTime, dealEndTime, options);

            for (String line : detailLines) {
                if (line.isEmpty()) continue;

                String[] fields = org.apache.commons.lang.StringUtils.splitByWholeSeparatorPreserveAllTokens(line, "|");

                String targetPhone = null;
                String checkType = typeMap.get(queryType);
                if (checkType.equals(CHECK_TYPE_VC)) {
                    targetPhone = fields[1]; //vc中5，是对端号码
                } else if (checkType.equals(CHECK_TYPE_SS)){
                    //黑龙江暂无短信校验详单的业务
                }

                String key = targetPhone + "." + checkType;
                if (!tPhoneSignMap.containsKey(key)) {
                    //非指定列表中的用户详单记录，不做判断，直接处理下一条
                    continue;
                }

                String phoneSign = tPhoneSignMap.get(key);
                if (phoneSign.equals("03") || phoneSign.equals("12")) {
                    //最终可展示的通信标识，不需要再继续处理，直接处理下一条
                    continue;
                }

                String newPhoneSign = this.getSignFlag(fields, checkType);
                if (!newPhoneSign.isEmpty()) {
                    safeAddToMap(tPhoneSignMap, key, newPhoneSign); //将新获取的通信标识覆盖原来的标识
                }

            }

        }

        List<PTOPEntity> outList = new ArrayList<PTOPEntity>();
        Set<Map.Entry<String, String>> entSet = tPhoneSignMap.entrySet();
        for (Map.Entry<String, String> ent : entSet) {
            String key = ent.getKey();
            String[] arr = key.split("\\.");
            String targetPhone = arr[0];
            String phoneSign = ent.getValue();
            PTOPEntity pTopEnt = new PTOPEntity();
            pTopEnt.setTargetPhone(targetPhone);
            pTopEnt.setPhoneSign(phoneSign);
            outList.add(pTopEnt);
        }

        //记录校验日志
        UserInfoEntity userInfo = user.getUserInfo(phoneNo);
        long idNo = userInfo.getIdNo();
        String brandId = userInfo.getBrandId();
        this.saveQueryOprLog(phoneNo, idNo, loginNo, groupId, opCode, brandId, inDto.getProvinceId());

        SDetailCheckCheckOutDTO OutDto = new SDetailCheckCheckOutDTO();
        OutDto.setOutList(outList);

        log.debug("outDto=" + OutDto.toJson());
        return OutDto;
    }

    /**
     * @param fields    详单行数组
     * @param queryType 详单检验的类型 CHECK_TYPE_VC ， CHECK_TYPE_SS
     * @return String
     */
    private String getSignFlag(String[] fields, String queryType /*查询类型，语音/短信 */) {
        /*
         * 00表示通话验证不成功、
         * 01:表示被叫、
         * 02:表示主叫不超过30秒、
         * 03:表示主叫并超过30秒;
         * 10表示短信验证不成功；
         * 11表示收短信；
         * 12表示发短信
         */
        String phoneSign = "";
        if (CHECK_TYPE_VC.equals(queryType)) {
            int callDuring = Integer.parseInt(fields[5]); // 通话时长
            String callType = fields[2]; // 通话类型 主叫、被叫

            if (callType.equals("被叫")) {
                phoneSign = "01";
            } else if (callDuring >= 30) {
                phoneSign = "03";
            } else if (callDuring < 30) {
                phoneSign = "02";
            }
            log.debug("对端号:" + fields[1] + ",通话类型:" + callType + ",通话时长：" + callDuring + ",返回标识:" + phoneSign);
        } else if (CHECK_TYPE_SS.equals(queryType)) {
            //TODO 短信验证的ETC配置文件待定
            // 短信类型
            String type = fields[2]; // 短信收发类型
            if (type.equals("收")) {
                phoneSign = "11";
            } else if (type.equals("发")) {
                phoneSign = "12";
            }

            log.debug("收发类型：" + type);
        }

        return phoneSign;
    }

    private void saveQueryOprLog(String phoneNo, long idNo, String loginNo, String loginGroupId,
                                 String opCode, String brandId, String provinceId) {
        ActQueryOprEntity oprEntity = new ActQueryOprEntity();
        if (StringUtils.isNotEmpty(loginNo) && StringUtils.isEmptyOrNull(loginGroupId)) {
            LoginEntity loginInfo = login.getLoginInfo(loginNo, provinceId);
            loginGroupId = loginInfo.getGroupId();
        }
        oprEntity.setQueryType("TYRZ"); // 详单校验使用特殊标识,统一认证详单校验
        oprEntity.setOpCode(opCode);
        oprEntity.setContactId("");
        oprEntity.setIdNo(idNo);
        oprEntity.setPhoneNo(phoneNo);
        oprEntity.setBrandId(brandId);
        oprEntity.setLoginNo(loginNo);
        oprEntity.setLoginGroup(loginGroupId);
        oprEntity.setProvinceId(provinceId);
        StringBuilder stringbuf = new StringBuilder();
        stringbuf.append("工号:");
        stringbuf.append(loginNo);
        stringbuf.append("对用户").append(phoneNo).append("进行通信记录验证");
        oprEntity.setRemark(stringbuf.toString());
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