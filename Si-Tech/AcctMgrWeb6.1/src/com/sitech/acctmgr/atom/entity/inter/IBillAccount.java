package com.sitech.acctmgr.atom.entity.inter;

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

/**
 * <p>
 * Title: 涉及计费帐务模型实体类
 * </p>
 * <p>
 * Description:
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
public interface IBillAccount {

    /**
     * 名称：操作短信提醒表remind_ctrl_info @
     */
    void saveRemindCtrlInfo(String phoneNo, long idNo);

    /**
     * 名称：操作短信提醒表remind_ctrl_info @
     */
    void delRemindCtrlInfo(String phoneNo, long idNo);

    /**
     * 名称：查询5M短信升级用户权限 @
     */
    int getCntRemindCtrlFav(String phoneNo);


    /**
     * 名称：用户是否多上多奖目标用户
     */
    boolean isGprsCmd(String phoneNo);

    void saveGprsShortMsgOffOn(Map<String, Object> inParam);

    void delGprsShortMsgOffOn(Map<String, Object> inParam);

    void saveGprsShortMsgOffOnNew(Map<String, Object> inParam);

    void delGprsShortMsgOffOnNew(Map<String, Object> inParam);

    void saveGprsInterMsgOffOn(Map<String, Object> inParam);

    void delGprsInterMsgOffOn(Map<String, Object> inParam);

    void delShortMsgOffOn(Map<String, Object> inParam);

    String getOffOnType(String phoneNo, String opFlag);

    void saveShortMsgOffOn(Map<String, Object> inParam);

    void updateShortMsgOffOn(Map<String, Object> inParam);

    String getTimeOffOnType(String phoneNo, String opFlag);

    void delShortMsgTimeOffOn(Map<String, Object> inParam);

    void saveShortMsgTimeOffOn(Map<String, Object> inParam);

    /**
     * 名称：获取手机号段 @
     */
    String getPhoneHead(String phoneNoSeven, String phoneNoEight);

    /**
     * 名称：获取手机号段归属省市 @
     */
    ProvCityListEntity getProvCityInfo(String phoneNo);

    /**
     * 名称：判断非本省的号码是否是移动号码 @
     */
    List<ChatTypeEntity> getChatTypeInfo();

    /**
     * 名称：查询sp名称
     *
     * @param spId
     * @return
     */
    String getSpName(String spId);

    /**
     * 名称：查询企业代码名称
     *
     * @param spId
     * @param operCode
     * @return
     */
    String getOperName(String spId, String operCode);

    /**
     * 名称：查询计费类型
     *
     * @param billType
     * @return
     */
    String getbillTypeName(String billType);

    /**
     * 名称：查询二批代码
     *
     * @param prcId
     * @param detailType
     * @param regionCode
     * @return
     */
    List<String> getRateCode(String prcId, String detailType, String regionCode);

    /**
     * 功能：获取SP游戏名称
     *
     * @param contextId
     * @param spCode
     * @return
     */
    String getDailyGameName(String contextId, String spCode);

    /**
     * 获取SP mmapp名称
     *
     * @param contextId
     * @param totalDate
     * @return
     */
    String getMmappName(String contextId, String totalDate);

    /**
     * 获取SP 音乐名称
     *
     * @param operCode
     * @param copyRightCode
     * @return
     */
    String getMusicName(String operCode, String copyRightCode);

    /**
     * 获取小区计费数据
     *
     * @param lacCode  计费代码
     * @param cellId   基站代码
     * @param flagCode 二批代码
     * @return
     */
    List<LocationCodeEntity> getLocationInfo(String lacCode, String cellId, String flagCode);

    /**
     * 名称：查询GPRS是否开通短信提醒
     *
     * @param phoneNo
     * @return
     */
    Map<String, Object> getGPRSStatus(String phoneNo);

    /**
     * 名称：查询亲情网是否开通短信提醒
     *
     * @param phoneNo
     * @return
     */
    int getShipStatus(String phoneNo);

    /**
     * 名称：查询GPRS开通关闭的记录
     *
     * @param inMap
     * @return
     */
    List<GprsChangeRecdEntity> getGprsStatusChange(Map<String, Object> inMap);

    /**
     * 名称：更改亲情网提醒状态
     *
     * @param inMap
     */
    void changeShipStatus(Map<String, Object> inMap);

    /**
     * 名称：查询月租分摊相关信息
     *
     * @param regionCode
     * @param monthCode
     * @return
     * @author liuhl
     */
    Map<String, Object> getMonthCodeInfo(String regionCode, String monthCode);

    /**
     * 名称：查询月租分摊配置
     *
     * @param inMap
     * @return
     * @author liuhl
     */
    int getMonthCfg(Map<String, Object> inMap);

    /**
     * 名称：获取小区代码
     *
     * @param inMap
     * @return
     * @author liuhl
     */
    Map<String, Object> getFlag(Map<String, Object> inMap);

    /* 无国漫封顶数据入表 */
    void saveDataGuMan(Map<String, Object> inMap);

    /* 查看国漫封顶有无数据 */
    int getCntGuMan(String phoneNo);

    /* 删除国漫封顶数据 */
    void delDataGuMan(long idNo);

    /* 查看有无扣费数据 */
    int getCntTellShort(String phoneNo);

    /* 查看开通关闭标志 */
    String getTypeTellShort(String phoneNo);

    /* 开通关闭标志 */
    Map<String, Object> saveTellShortMsgOffOn(String opType, String phoneNo, long idNo, String loginNo, long loginAccept);

    /* 边界漫游 */
    List<ProvCriticalEntity> getProvCriticalInfo(Map<String, Object> inMap);

    /**
     * 功能：获取流量类型名称
     *
     * @param favClass
     * @return
     */
    String getGprsFavClassName(String favClass);

    Map<String, Object> getTellCodeA(String loginAccept, String phoneNo);

    int getCntTellCodeInc(String phoneNo, String loginAccept);

    Map<String, Object> getTellCodeB(String loginAccept, String phoneNo);

    // wlan开通入小表
    void saveWlanOpenChg(String phoneNo);

    // 判断用户是否已经达到50G封顶
    void getCntWlanOpenW(String phoneNo);

    /**
     * 功能：根据price_code查询出price_fee,price_name
     *
     * @param priceCode
     * @return
     */
    PriceCodeEntity getPriceInfo(String priceCode);

    /**
     * 功能：根据产品ID获取资费信息详细列表
     *
     * @param prcId
     * @param bargainparaFlag
     * @param regionCode
     * @return
     */
    List<PrcIdTransEntity> getPrcDetailList(String prcId, String bargainparaFlag, String regionCode);

    /**
     * 获取二批代码信息
     *
     * @param priceCode
     * @param serviceType
     * @param chargeFlags
     * @return
     */
    PriceCodeEntity getPriceInfo(String priceCode, String serviceType, String serviceCode, String chargeFlags);

    /**
     * 获取满足业务代码的数据条数
     *
     * @param prcId
     * @param detailCode
     * @param detailType
     * @param regionCode
     * @return
     */
    int getCountFlag(String prcId, String detailCode, String detailType, String regionCode);

    /**
     * 功能：获取付费人底线/融合标识
     *
     * @param idNo
     * @return 1：底线；0：融合
     */
    String getGroupDxFlag(long idNo);

    /**
     * 功能：获取用户生效的资费对应的sbilltotcode信息(包年优惠信息总费用)
     *
     * @param idNo
     * @param regionCode
     * @return
     */
    Map<String, Object> getYearFeeInfo(long idNo, String regionCode);

    /**
     * 功能：获取包年优惠信息已使用费用
     *
     * @param idNo
     * @param regionCode
     * @return
     */
    long getYearUsedFee(long idNo, String regionCode);

    /**
     * 功能：查询订购资费中流量最低优先级
     *
     * @param prcId
     * @param regionCode
     * @return
     */
    Integer getGprsMinOrder(String prcId, String regionCode);

    /**
     * 功能：查询订购资费中语音类展示优先级, 如果取不到语音类 则取既非流量又非语音类资费的优先级
     *
     * @param prcId
     * @param regionCode
     * @param isVoice
     * @return
     */
    Integer getVoiceDisOrder(String prcId, String regionCode, boolean isVoice);

    /**
     * 功能：获取流量状态
     *
     * @param prcId
     * @param regionCode
     * @return
     */
    int getGprsState(String prcId, String regionCode);

    /**
     * 功能：获取包年优惠费用
     *
     * @param regionCode
     * @param detailCode
     * @return
     */
    Map<String, Object> getYearFavourFee(String regionCode, String detailCode);

    /**
     * 功能：获取二批代码列表
     *
     * @param prcId
     * @param regionCode
     * @param detailTypes
     * @return
     */
    List<PrcIdTransEntity> getDetailCodeList(String prcId, String regionCode, String detailTypes);
    
    /**
     * 功能：获取宽带每月费用
     *
     * @param prcId
     * @param regionCode
     * @return
     */
    long getKdMonthFee(String prcId, String regionCode);
    
    /**
     * 功能：获取用户每月月租费用
     *
     * @param idNo
     * @param regionCode
     * @return
     */
    long getUserMonthFee(long idNo, String regionCode);

    /**
     * 功能：查询集团红名单信息
     *
     * @param
     * @return
     */
    List<GrpRedEntity> getGrpCreditInfo(String unitId);

    /**
     * 功能：查询集团用户免停信息
     *
     * @param
     * @return
     */
    List<NonStopEntity> getNonStopInfo(String unitId);

    /**
     * 功能：获取地市下指定项目的计费信息
     *
     * @param regionCode
     * @param totalCode
     * @return
     */
    List<BillTotCodeEntity> getBillTotCodeInfo(String regionCode, String totalCode);

    /**
     * 功能：获取资费对应的半月优惠比例
     *
     * @param regionCode
     * @param prcId
     * @return
     */
    Double getHalfRate(String regionCode, String prcId);

    /**
     * 功能：查询wlan套餐优先级
     *
     * @param prcId
     * @param regionCode
     * @return
     */
    Integer getWlanOrder(String prcId, String regionCode);

    /**
     * 功能：查询扣费主动提醒短信处理明细
     *
     * @param beginTime endTime
     * @return
     */
    List<TellCodeEntity> getTellCodeDelList(String beginTime, String endTime);

    /**
     * 查询用户的账期类型是否为滚动月
     *
     * @param idNo
     * @return
     * @author liuhl_bj
     */
    int judgeRollMonthBill(long idNo);

    /**
     * 查询该用户是否收取固定费
     *
     * @param idNo
     * @param detailType
     * @param detailCode
     * @return
     * @author liuhl_bj
     */
    int haveFix(long idNo, String[] detailType, String detailCode);

    /**
     * 查询账期
     *
     * @param idNo
     * @return
     */
    int qryAccDay(long idNo);

    /**
     * 营销活动入账务最低消费表
     */
    void inSbillcodeUser(Map<String, Object> inMap);

    /**
     * 查询优惠信息
     *
     * @param regionCode
     * @param modeCode   产品资费ID
     * @return
     * @author liuhl_bj
     */
    Fav1860CfgEntity getFavInfo(long regionCode, String modeCode, String favType);

    /**
     * 查询宽带月租
     *
     * @param regionCode
     * @param prcId      产品资费ID
     * @return
     */
    long getBroadBandFee(String regionCode, String prcId);

    /**
     * 获取二批代码信息
     *
     * @param prcId
     * @param detailType
     * @return
     * @author liuhl_bj
     */
    List<PrcIdTransEntity> getRateInfo(String prcId, String detailType, String regionCode);

    /**
     * 查询月租配置
     *
     * @param prcId
     * @param regionCode
     * @return
     */
    int monthCfg(String prcId, String regionCode);

    /**
     * @param detailCode
     * @return
     */
    int isFamilyMonthCode(String detailCode);

    void delRemindQinQing(Map<String, Object> inParam);

    void saveRemindQinQing(Map<String, Object> inParam);
    
    /**
     * 功能：获取国漫用户产品使用情况
     * @param phoneNo
     * @return
     */
    List<InterRoamProdInfoEntity> getInterRoamUsage(String phoneNo);

    /**
     * 功能：插入国漫用户产品使用情况
     * @param Map
     * @return
     */
    void insertRoamUsage(Map inMap);
    
    /**
     * 功能：更新国漫用户产品使用情况
     * @param Map
     * @return
     */
    void updateRoamUsage(Map inMap);

    /**
     * 功能：判断资费是否是4G多终端共享资费
     * @param prcId
     * @param regionCode
     * @return
     */
    boolean isSharePrcId(String prcId, String regionCode);

    /**
     * 功能：判断资费是否可转赠
     * @param prcId
     * @param favType
     * @return
     */
    boolean isSendPrcId(String prcId, String favType);

    /**
     * 功能：判断是否为灵活账期计费的资费
     * @param detailCode
     * @return
     */
    boolean isFlexPrc(String detailCode);

    /**
     * 功能：判断是否为包天计费的资费
     * @param detailCode
     * @return
     */
    boolean isDayPrc(String detailCode);
    
    /**
     * 功能：入UR_USERGOODS_ZFYQCHG表
     * @param inMap
     */
    void saveUserGoodsZFYQ(Map<String, Object> inMap);
    
    /**
     * 功能：获取sp业务计费类型实体
     * @param bizType
     * @return
     */
    List<SPBillAcctRuleEntity> getSPBillRule(String bizType);

}
