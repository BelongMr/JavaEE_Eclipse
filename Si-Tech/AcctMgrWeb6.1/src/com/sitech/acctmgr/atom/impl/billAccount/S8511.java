package com.sitech.acctmgr.atom.impl.billAccount;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.acctmng.S8511InDTO;
import com.sitech.acctmgr.atom.dto.acctmng.S8511OutDTO;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGoods;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.inter.billAccount.I8511;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.service.client.ServiceUtil;
import com.sitech.jcfx.util.DateUtil;

@ParamTypes({ 
	@ParamType(m = "cfm", c = S8511InDTO.class, oc = S8511OutDTO.class)
})
public class S8511 extends AcctMgrBaseService implements I8511{
	private IControl control;
	private IUser user;
	private IRecord record;
	private IGoods goods;
	private IPreOrder preOrder;
	
	@Override
	public OutDTO cfm(InDTO inParam) {
		S8511InDTO inDto = (S8511InDTO)inParam;
		String phoneNo = inDto.getPhoneNo();
		String shouldPay = inDto.getShouldPay();
		String opCode = inDto.getOpCode();
		String openResult = "";
		
		//取系统时间和流水
		String sCurDate = DateUtil.format(new Date(), "yyyyMMdd");
		long loginAccept=control.getSequence("SEQ_SYSTEM_SN");
		
		UserInfoEntity uie = user.getUserInfo(phoneNo);
		String runCode = uie.getRunCode();
		long idNo = uie.getIdNo();
		if (!runCode.equals("A")) {
			throw new BusiException(AcctMgrError.getErrorCode("8511", "00001"), "该号码不是正常状态手机号！");
		}
		
		openResult = "0";
		if (opCode.equals("e224") && Integer.parseInt(shouldPay) > 0) {
			// 入账单
			String outStr = "";
			/* 依次查询大区 */
			String interfaceName = "com_sitech_acctmgr_inter_adj_IMicroPaySvc_cfm";
			/* 入参报文 */
			MBean inPubInfo = new MBean();
			inPubInfo.setHeader(inDto.getHeader());
			inPubInfo.addBody("BUSI_INFO.PHONE_NO", phoneNo);
			inPubInfo.addBody("BUSI_INFO.IN_PREPAY_FEE", Long.parseLong(shouldPay));
			inPubInfo.addBody("BUSI_INFO.SERVICE_TYPE", "1");
			inPubInfo.addBody("OPR_INFO.LOGIN_NO", inDto.getLoginNo());
			inPubInfo.addBody("OPR_INFO.GROUP_ID", inDto.getGroupId());
			inPubInfo.addBody("OPR_INFO.OP_CODE", inDto.getOpCode());
			inPubInfo.addBody("OPR_INFO.PROVINCE_ID", inDto.getProvinceId());
			outStr = ServiceUtil.callService(interfaceName, inPubInfo);
			
		}
		
		// 校验是否已订购
		boolean order = false;
		order = goods.isOrderGoods(idNo, "M001038");
		if (order) {
			throw new BusiException(AcctMgrError.getErrorCode("8511", "00002"), "已订购该业务！");
		} else {
			// 调用CRM订购服务
			Map<String, Object> inMap = new HashMap<String, Object>();
			inMap.put("OPERATE_TYPE", "A");
			inMap.put("PRC_ID", "M001038");
			List<Map<String, Object>> goodsList = new ArrayList<Map<String, Object>>();
			goodsList.add(inMap);
			MBean inMbeanTmp = new MBean();
			inMbeanTmp.setHeader(inDto.getHeader());
			inMbeanTmp.setBody("OPR_INFO.LOGIN_NO", inDto.getLoginNo());
			inMbeanTmp.setBody("OPR_INFO.OP_CODE", inDto.getOpCode());
			inMbeanTmp.setBody("OPR_INFO.CONTACT_ID", "-1");
			inMbeanTmp.setBody("BUSI_INFO.PHONE_NO", phoneNo);
			inMbeanTmp.setBody("BUSI_INFO.CHN_FLAG", "3");
			inMbeanTmp.setBody("BUSI_INFO.GOODS_LIST", goodsList);
			
			// 接口名
			String interfaceName = "com_sitech_ordersvc_person_comp_inter_s1090_ISubmitGoodsCoSvc_goodsDataSubmit";
			log.info("------> 调用CRM订购服务开始:" + inMbeanTmp.toString());
			// 调用方法			
			String outStringQry = ServiceUtil.callService(interfaceName, inMbeanTmp);
			
			log.info("------> 调用CRM订购完成:" + outStringQry);
			
			MBean outBean = new MBean(outStringQry);
			String retCode = outBean.getBodyStr("RETURN_CODE").trim();
			String retMsg = outBean.getBodyStr("RETURN_MSG").trim();
			if (!"0".equals(retCode)) {
				log.info("------> 调用订购接口失败, retCode=" + retCode + ",retMsg=" + retMsg);
				throw new BusiException(retCode, retMsg);
			}
			
		}
		
		//取系统时间
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		//同步CRM统一接触
		Map<String, Object> oprCnttMap = new HashMap<String, Object>();
		oprCnttMap.put("Header", inDto.getHeader());
		oprCnttMap.put("PAY_SN", loginAccept);
		oprCnttMap.put("LOGIN_NO", inDto.getLoginNo());
		oprCnttMap.put("GROUP_ID", inDto.getGroupId());
		oprCnttMap.put("OP_CODE", inDto.getOpCode());
		oprCnttMap.put("OP_NOTE", "流量包天优惠申请");
		oprCnttMap.put("TOTAL_FEE", 0);
		oprCnttMap.put("CUST_ID_TYPE", "1");
		oprCnttMap.put("CUST_ID_VALUE", phoneNo);
		oprCnttMap.put("OP_TIME", sCurTime);
		preOrder.sendOprCntt(oprCnttMap);
		
		// 记录营业员操作记录表
		LoginOprEntity loe = new LoginOprEntity();
		loe.setIdNo(idNo);
		loe.setPhoneNo(phoneNo);
		loe.setLoginGroup(inDto.getGroupId());
		loe.setLoginNo(inDto.getLoginNo());
		loe.setLoginSn(loginAccept);
		loe.setOpCode(inDto.getOpCode());
		loe.setTotalDate(Long.parseLong(sCurDate));
		loe.setRemark("流量包天优惠申请入表");
		record.saveLoginOpr(loe);

		S8511OutDTO outDto = new S8511OutDTO();
		outDto.setLoginAccept(String.valueOf(loginAccept));
		outDto.setOpenResult(openResult);
		return outDto;
		
	}

	/**
	 * @return the control
	 */
	public IControl getControl() {
		return control;
	}

	/**
	 * @param control the control to set
	 */
	public void setControl(IControl control) {
		this.control = control;
	}

	/**
	 * @return the user
	 */
	public IUser getUser() {
		return user;
	}

	/**
	 * @param user the user to set
	 */
	public void setUser(IUser user) {
		this.user = user;
	}

	/**
	 * @return the record
	 */
	public IRecord getRecord() {
		return record;
	}

	/**
	 * @param record the record to set
	 */
	public void setRecord(IRecord record) {
		this.record = record;
	}

	/**
	 * @return the goods
	 */
	public IGoods getGoods() {
		return goods;
	}

	/**
	 * @param goods the goods to set
	 */
	public void setGoods(IGoods goods) {
		this.goods = goods;
	}

	/**
	 * @return the preOrder
	 */
	public IPreOrder getPreOrder() {
		return preOrder;
	}

	/**
	 * @param preOrder the preOrder to set
	 */
	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}
	
}