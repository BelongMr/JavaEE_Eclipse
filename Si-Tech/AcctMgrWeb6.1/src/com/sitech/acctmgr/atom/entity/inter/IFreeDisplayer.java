package com.sitech.acctmgr.atom.entity.inter;

import com.sitech.acctmgr.atom.domains.free.FamilyFreeFeeUserEntity;
import com.sitech.acctmgr.atom.domains.free.FreeUseInfoEntity;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.domains.query.FreeMinBill;

import java.util.List;
import java.util.Map;

/**
 * Created by wangyla on 2016/6/16.
 */
public interface IFreeDisplayer {

    /**
     * 功能：从计费端获取用户优惠信息明细，内容未经过任何处理，所有不同的业务处理，均处理此接口返回的数据
     *
     * @param phoneNo    服务号码
     * @param queryYM    查询月份
     * @param busiCode   业务类别，取值 0：全部业务；1：语音；2：短信；3：GPRS；7：彩信；8：WAP流量
     * @return
     */
    List<FreeMinBill> getFreeDetailList(String phoneNo, int queryYM, String busiCode);

    /**
     * 功能：从计费端获取用户优惠信息明细，内容未经过任何处理，所有不同的业务处理，均处理此接口返回的数据
     *
     * @param phoneNo
     * @param queryYM
     * @param busiCode
     * @param queryType  查询新模式标识；
     * @return
     */
    List<FreeMinBill> getFreeDetailList(String phoneNo, int queryYM, String busiCode, String queryType);

    /**
     * 功能：获取用户免费分钟数的汇总信息<br>
     * 针对普通模式查询
     *
     * @param phoneNo
     * @param queryYM
     * @param busiCode
     * @return
     */
    Map<String, FreeUseInfoEntity> getFreeTotalInfo(String phoneNo, int queryYM, String busiCode);

    /**
     * 功能：获取用户免费分钟数的汇总信息
     *
     * @param phoneNo
     * @param queryYM
     * @param busiCode
     * @param queryType
     * @return Map.key: busiCode^unit_code<br> Map.value:FreeUseInfoEntity
     */
    Map<String, FreeUseInfoEntity> getFreeTotalInfo(String phoneNo, int queryYM, String busiCode, String queryType);

    /**
     * 功能：获取用户免费分钟数的汇总信息
     *
     * @param inFreeList
     * @return
     */
    Map<String, FreeUseInfoEntity> getFreeTotalInfo(List<FreeMinBill> inFreeList);

    /**
     * 功能：获取用户分类信息的总和
     *
     * @param phoneNo
     * @param queyYm
     * @param busiCode
     * @return
     */
    Map<String, Long> getFreeTotalMap(String phoneNo, int queyYm, String busiCode);

    /**
     * 功能：对优惠信息明细做汇总操作
     *
     * @param inFreeList
     * @return
     */
    Map<String, Long> getFreeTotalMap(List<FreeMinBill> inFreeList);

    /**
     * 功能：对优惠信息列表，做汇总，支持特殊的二批代码（GPRS使用）
     *
     * @param inFreeList
     * @param detailCodeList
     * @return
     */
    Map<String, Long> getFreeTotalMap(List<FreeMinBill> inFreeList, List<String> detailCodeList);

    /**
     * 功能：获取家庭优惠汇总信息
     *
     * @param inFreeList 优惠信息列表
     * @param chatFlag   畅聊标识 1：畅聊； 0：非畅聊
     * @return
     */
    Map<String, Long> getFamlilyFreeTotalMap(List<FreeMinBill> inFreeList, String chatFlag);

    /**
     * 功能：返回用户流量使用情况（集团共享，个人使用，成员使用等）
     *
     * @param inFreeList
     * @return
     */
    Map<String, Long> getGprsFreeTotalMap(List<FreeMinBill> inFreeList);

    /**
     * 功能：判断资费是否是4G资费
     *
     * @param prcId
     * @return
     */
    boolean is4GPrcId(String prcId);

    /**
     * 功能：判断资费是否是流量叠加包
     *
     * @param prcId
     * @return
     */
    boolean isAddedGprs(String prcId);

    /**
     * 功能：获取指定资费的家庭资费配置信息
     *
     * @param prcId
     * @return
     */
    PubCodeDictEntity getFamPrcIdInfo(String prcId);

    /**
     * 功能：查询用户往月亲情网优惠信息
     *
     * @param phoneNo
     * @param queryYm
     * @return
     */
    List<FamilyFreeFeeUserEntity> getFamilyFreeFeeList(String phoneNo, int queryYm);

    /**
     * 功能：汇总分类优惠信息
     *
     * @param inFreeList
     * @return
     */
    Map<String, Long> getFreeClassMap(List<FreeMinBill> inFreeList);

}
