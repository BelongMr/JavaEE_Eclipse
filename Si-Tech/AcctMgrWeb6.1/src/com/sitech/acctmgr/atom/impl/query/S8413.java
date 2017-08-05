package com.sitech.acctmgr.atom.impl.query;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.balance.BookTypeEnum;
import com.sitech.acctmgr.atom.domains.pay.PayMentEntity;
import com.sitech.acctmgr.atom.domains.query.SpFeeRecycleEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.query.S8413InDTO;
import com.sitech.acctmgr.atom.dto.query.S8413OutDTO;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IBase;
import com.sitech.acctmgr.atom.entity.inter.IBillDisplayer;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.inter.query.I8413;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.service.client.ServiceUtil;

@ParamTypes({ @ParamType(c = S8413InDTO.class, oc = S8413OutDTO.class, m = "query") })
public class S8413 extends AcctMgrBaseService implements I8413 {

	private IUser user;
	private IBalance balance;
	private IBillDisplayer billDisplayer;
	private IRecord record;
	private IBase base;

	@Override
	public OutDTO query(InDTO inParam) {
		S8413InDTO inDto = (S8413InDTO) inParam;
		String phoneNo = inDto.getPhoneNo();

		Map<String, Object> inMap = new HashMap<String, Object>();
		// 根据服务号码查询用户信息
		UserInfoEntity userInfo = user.getUserEntity(0l, phoneNo, 0l, true);
		long contractNo = userInfo.getContractNo();
		List<SpFeeRecycleEntity> spFeeRecycleList = new ArrayList<SpFeeRecycleEntity>();

		// 根据账户查询账本信息
		inMap.put("CONTRACT_NO", contractNo);
		List<SpFeeRecycleEntity> spFeeRecyList = balance.getSpBookHis(inMap);

		// 根据contract_no，id_no从冲销表中查询回收金额
		for (SpFeeRecycleEntity spFeeRecy : spFeeRecyList) {

			String endTimeTmp = spFeeRecy.getEndTime();
			int endTime = Integer.parseInt(endTimeTmp.substring(0, 8));
			int beginTime = Integer.parseInt(spFeeRecy.getBeginTime().substring(0, 8));
			log.debug("endtime:" + endTime + "endday:" + endTime % 100 + "   beginTime:" + beginTime + " beginday:" + beginTime % 100);
			int endYm = Integer.parseInt(endTimeTmp.substring(0, 6));
			// int beginYm =
			// Integer.parseInt(spFeeRecy.getBeginTime().substring(0, 6));
			// 如果非立即生效或者如果生失效时间不为1号，不展示
			if (beginTime % 100 != 1
					&& Integer.parseInt(spFeeRecy.getBeginTime().substring(0, 8)) != Integer.parseInt(spFeeRecy.getOpTime().substring(0, 8))) {
				continue;
			}

			// 从冲销表中获取回收金额
			long outFee = billDisplayer.getOutFee(contractNo, endYm, BookTypeEnum.NORAML);
			spFeeRecy.setRecycleMoney(outFee);

			// 根据paySn查询操作代码,直接从办理日期从缴费记录表中查询
			inMap = new HashMap<String, Object>();
			inMap.put("SUFFIX", Integer.parseInt(spFeeRecy.getOpTime().substring(0, 6)));
			inMap.put("PAY_SN", spFeeRecy.getPaySn());
			inMap.put("CONTRACT_NO", contractNo);
			List<PayMentEntity> paymentList = record.getPayMentList(inMap);
			if (paymentList == null || paymentList.size() == 0) {
				continue;
			}
			String opCode = paymentList.get(0).getOpCode();
			// TODO:如果op_code是营销回收 e179,不展示
			if (opCode.equals("e179")) {
				continue;
			}
			spFeeRecy.setOpCode(opCode);
			spFeeRecy.setLoginNo(paymentList.get(0).getLoginNo());
			// 根据缴费流水获取外部流水
			String foreignSn = paymentList.get(0).getForeignSn();
			// 调用营销接口获取营销活动信息
			String activeInfo = getActiveInfo(foreignSn);
			String activeName = "";
			String gearsName = "";

			// 如果op_code=g794
			if (opCode.equals("g794")) {
				// 调用营销获取活动名称和档位名称

			} else {
				// 活动名称=function_name
				String opName = base.getFunctionName(opCode);
				activeName = opName;
			}
			spFeeRecy.setActiveName(activeName);
			spFeeRecy.setActiveInfo(activeInfo);
			spFeeRecy.setGearsName(gearsName);
			spFeeRecycleList.add(spFeeRecy);
		}

		if (spFeeRecycleList == null || spFeeRecycleList.size() == 0) {
			throw new BusiException(AcctMgrError.getErrorCode("8413", "00001"), "该用户没有专款回收记录");
		}
		S8413OutDTO outDto = new S8413OutDTO();
		outDto.setSpFeeRecyList(spFeeRecycleList);
		return outDto;
	}
	
	// 查询营销活动信息
	private String getActiveInfo(String foreignSn){

		String interfaceName = "com_sitech_market_comp_inter_common_IQryActInfoByLoginAcceptSvc_getActInfo";
		MBean mbean = new MBean();
		mbean.setBody("BUSI_INFO.LOGIN_ACCEPT", foreignSn);
		log.debug("调用营销接口开始");
		String outString = ServiceUtil.callService(interfaceName, mbean.toString());
		log.debug("调用营销接口结束" + outString);
		MBean outBean = new MBean(outString);
		String activeInfo ="";
		List<Map<String, Map<String, Object>>> actInfoList = (List<Map<String, Map<String, Object>>>) outBean.getBodyList("OUT_DATA.ACT_LIST");
		if(actInfoList!=null&&actInfoList.size()>0){
			activeInfo = actInfoList.get(0).get("ACT_ID").toString();
		}
		return activeInfo;
	}

	// 查询营销活动名称和营销活动档位名称
	private Map<String, Object> getActive(String phoneNo) {

		String interfaceName = "com_sitech_market_comp_inter_s4641_IQryActRecordsCoSvc_qryActRecords";
		MBean mbean = new MBean();
		mbean.setBody("BUSI_INFO.PHONE_NO", phoneNo);

		log.debug("调用营销接口开始");
		String outString = ServiceUtil.callService(interfaceName, mbean.toString());
		log.debug("调用营销接口结束" + outString);
		MBean outBean = new MBean(outString);
		String activeInfo = "";
		List<Map<String, Map<String, Object>>> actInfoList = (List<Map<String, Map<String, Object>>>) outBean.getBodyList("OUT_DATA.ACT_LIST");
		if (actInfoList != null && actInfoList.size() > 0) {
			activeInfo = actInfoList.get(0).get("ACT_ID").toString();
		}
		return null;
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

	public IBillDisplayer getBillDisplayer() {
		return billDisplayer;
	}

	public void setBillDisplayer(IBillDisplayer billDisplayer) {
		this.billDisplayer = billDisplayer;
	}

	public IRecord getRecord() {
		return record;
	}

	public void setRecord(IRecord record) {
		this.record = record;
	}

}