package com.sitech.acctmgr.atom.impl.pay;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSON;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayOpener;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.busi.pay.inter.IWriteOffer;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayInfoEntity;
import com.sitech.acctmgr.atom.domains.pay.PayOutEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.user.GroupchgInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserGroupMbrEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.pay.S8000CfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8000CfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S8000InitInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8000InitOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IAgent;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.ICheque;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICredit;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IProd;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgr.comp.busi.LoginCheck;
import com.sitech.acctmgr.comp.dto.pay.S8000CompInitOutDTO;
import com.sitech.acctmgr.comp.impl.pay.S8000Comp;
import com.sitech.acctmgr.inter.pay.I8074;
import com.sitech.acctmgrint.atom.busi.intface.IShortMessage;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.service.client.ServiceUtil;


@ParamTypes({@ParamType(m = "TDinit", c = S8000InitInDTO.class, oc = S8000CompInitOutDTO.class),
    		 @ParamType(m = "TDcfm", c = S8000CfmInDTO.class, oc = S8000CfmOutDTO.class)})
public class S8074 extends S8000 implements I8074{
	
	protected LoginCheck loginCheck;
	protected IShortMessage shortMessage;
	
	@Override
	public OutDTO TDinit(InDTO inParam) {
		
		IUser user = super.getUser();
		IGroup group = super.getGroup();
		ILogin login = super.getLogin();
		IRemainFee remainFee = super.getRemainFee();
		
		S8000InitInDTO inDto = (S8000InitInDTO)inParam;
		
		String phoneNo = super.getPayPhone(inDto.getPhoneNo(), inDto.getContractNo());
		long contractNo = getPayContractNo(inDto.getPhoneNo(), inDto.getContractNo());
		
		log.info("phone ------>"+phoneNo);
		long idNo = user.getUserInfo(phoneNo).getIdNo();
		log.info("idNo ---->" + idNo);
		//判断用户是否归属TD集团
		UserGroupMbrEntity numCon = user.getGroupInfo(phoneNo, "375");
		if(numCon == null){
			throw new BusiException(AcctMgrError.getErrorCode("8074","00001"), "非TD商务固话集团统付业务号码，不允许在该模块缴费");
		}
		
		/*获取工号滞纳金优惠权限*/
        boolean delayAble = false;
        String A040Pdom = "";
        //TODO a042 true 工号有滞纳金优惠权限 false 工号没有滞纳金优惠权限
        Map<String, Object> inTmp = new HashMap<String, Object>();
        inTmp.put("LOGIN_NO", inDto.getLoginNo());
        inTmp.put("BUSI_CODE", "BBMA0040");
        delayAble = loginCheck.pchkFuncPower(inDto.getHeader(), inTmp);
        if(delayAble){
        	A040Pdom = "Y";
        }else{
        	A040Pdom = "N";
        }
		
        MBean initIn = new MBean(inDto.getMbean().toString());
		String interfaceName = "com_sitech_acctmgr_inter_pay_I8000Svc_init";
		String outString = ServiceUtil.callService(interfaceName, initIn.toString());
		
		MBean mb = new MBean(outString);
		String jsonStr = JSON.toJSONString(mb.getBodyObject("OUT_DATA"));
		S8000CompInitOutDTO outDto = JSON.parseObject(jsonStr,S8000CompInitOutDTO.class);
		outDto.setA040Pdom(A040Pdom);
		
		return outDto;
	}
	@Override
	public OutDTO TDcfm(InDTO inParam) {
		
		IControl control = super.getControl();
		IUser user = super.getUser();
		IGroup group = super.getGroup();
		IRecord record = super.getRecord();
		ILogin login = super.getLogin();
		IPayManage payManage = super.getPayManage();
		IPayOpener payOpener = super.getPayOpener();
		IBalance balance = super.getBalance();
		IAccount account = super.getAccount();
		ICredit credit = super.getCredit();
		
		String sCurTime = control.getSysDate().get("CUR_TIME").toString();
		String sCurYm = sCurTime.substring(0, 6);
		int totalDate = Integer.parseInt(sCurTime.substring(0, 8));
		long paySn = 0;
		String opType = "TD";
		
		
		S8000CfmInDTO inDto = (S8000CfmInDTO)inParam;
		
		/*校验工号有无a040权限*/
		double delayRate = inDto.getDelayRate();
		Map<String,Object> inMapTmp = new HashMap<String, Object>();
		inMapTmp.put("LOGIN_NO", inDto.getLoginNo());
		inMapTmp.put("BUSI_CODE", "BBMA0040");
		LoginCheck logincheck = new LoginCheck();
		inDto.setCtrlFlag("0");
		boolean powerFlag = logincheck.pchkFuncPower(inDto.getHeader(), inMapTmp);
		if(delayRate > 0){
			log.info("delayRate-------->"+delayRate);
			log.info("powerFlag-------->"+powerFlag);
			if(!powerFlag){
				throw new BusiException(AcctMgrError.getErrorCode("8074",
						"00003"), "该工号没有滞纳金优惠权限！");
			}
		}
		
		S8000CfmOutDTO outDto = (S8000CfmOutDTO)super.cfm(inDto);
		long cfmPaySn = outDto.getPaySnList().get(0).getPaySn();
		
		/*取TD统付账户信息*/
		String phoneNo = inDto.getPhoneNo();
		long idNo = user.getUserInfo(phoneNo).getIdNo();
		long TDcon = account.getTDCon(idNo);
		String TDphoneNo = getPayPhone("", TDcon);
		PayUserBaseEntity TDpayUserBase = getCfmBaseInfo(TDphoneNo,TDcon, inDto.getProvinceId());
		/*获取TD账户名称*/
		ContractInfoEntity TDcontractInfo = super.getAccount().getConInfo(TDcon, true);
		String TDcontractName = TDcontractInfo.getContractName();
		
		/*获取缴费账户信息*/
		long contractNo = inDto.getContractNo();
		PayUserBaseEntity payUserBase = getCfmBaseInfo(phoneNo,contractNo,inDto.getProvinceId());
		/*获取TD账户名称*/
		ContractInfoEntity TDcontractInfo1 = super.getAccount().getConInfo(contractNo, true);
		String contractName = TDcontractInfo1.getContractName();
		
		List<PayInfoEntity> payList = inDto.getPayList();
		
		PayBookEntity bookIn = new PayBookEntity();
		bookIn.setTotalDate(totalDate);
		bookIn.setPayPath(inDto.getPayPath());
		bookIn.setPayMethod(inDto.getPayMethod());
		bookIn.setStatus("0");
		bookIn.setBeginTime(sCurTime);
		bookIn.setPrintFlag(getPrintFlag(inDto.getPayPath(), inDto.getForeignSn()));
		bookIn.setForeignSn(inDto.getForeignSn());
		bookIn.setForeignTime(inDto.getForeignTime());
		bookIn.setYearMonth(Long.parseLong(sCurYm));
		bookIn.setLoginNo(inDto.getLoginNo());
		bookIn.setGroupId(inDto.getGroupId());
		bookIn.setOpCode(inDto.getOpCode());
		bookIn.setOpNote(inDto.getPayNote());
		bookIn.setFactorOne(TDcontractName);
		bookIn.setFactorTwo(contractName);
		for(PayInfoEntity payTmp : payList){
			//入payment表（负记录）
			long   lPayMoney = Long.parseLong(payTmp.getPayMoney());
			lPayMoney = 0 - lPayMoney;
			
			bookIn.setPayType(payTmp.getPayType());
			bookIn.setPayFee(lPayMoney);
			String cfmPaySnStr = String.valueOf(cfmPaySn);
			bookIn.setForeignSn(cfmPaySnStr);
			
			paySn = control.getSequence("SEQ_PAY_SN");
			bookIn.setPaySn(paySn);
			record.savePayMent(TDpayUserBase, bookIn);
			
			//入payment表（正记录）
			lPayMoney = Long.parseLong(payTmp.getPayMoney());
			bookIn.setPayFee(lPayMoney);
			paySn = control.getSequence("SEQ_PAY_SN");
			bookIn.setPaySn(paySn);
			record.savePayMent(TDpayUserBase, bookIn);

			//入转账记录表
			bookIn.setPaySn(cfmPaySn);
			Map<String,Object> inTransCfmMap = new HashMap<String, Object>();
			bookIn.setForeignSn(null);
			inTransCfmMap.put("OP_TYPE", opType);
			balance.saveTrasfeeInfo(TDpayUserBase, payUserBase, bookIn, inTransCfmMap);
			
		}
		
		
		
		return outDto;
	}
	
	/**
	* 名称：获取是否打印过发票标识
	* @param 
	* @return 0：未打印  2：预存已打印
	*/
	private String getPrintFlag(String payPath, String foreignSn){
		
		IBalance balance = super.getBalance();
		
		String printFlag = "0";
		if(payPath.equals(PayBusiConst.CARDPATH)){       //充值卡缴费判断CRM是否打印过发票 
			
			if(balance.isCrmCardInvPrint(foreignSn)){
				printFlag = "2";
			}
		}
		
		return printFlag;
	}
	
	private PayUserBaseEntity getCfmBaseInfo(String phoneNo, long contractNo, String provinceId){
		
		IUser user = super.getUser();
		IGroup group = super.getGroup();
		
		Map<String, Object> inMapTmp = null;
		Map<String, Object> outMapTmp = null;
		
		//Map<String, Object> userMap = null;
		UserInfoEntity userInfo = null;
		String brandId = "XX";
		long   idNo = 0;
		if(!phoneNo.equals("99999999999")){
			
			userInfo = user.getUserInfo(phoneNo);
			idNo = userInfo.getIdNo();
			brandId = userInfo.getBrandId();
		}
		
		//取账户归属
		GroupchgInfoEntity groupChgEntity = group.getChgGroup(null, null, contractNo);
		
		// 缴费用户归属地市
		ChngroupRelEntity groupEntity = group.getRegionDistinct(groupChgEntity.getGroupIdPay(), "2", provinceId);
		String regionId = groupEntity.getRegionCode();
		
		PayUserBaseEntity payUserBase = new PayUserBaseEntity();
		payUserBase.setIdNo(idNo);
		payUserBase.setPhoneNo(phoneNo);
		payUserBase.setContractNo(contractNo);
		payUserBase.setUserGroupId(groupChgEntity.getGroupId());
		payUserBase.setRegionId(regionId);
		payUserBase.setBrandId(brandId);
		
		return payUserBase;
	}
	
	/**
	* 名称：TD缴费发送短信
	 *@param brand_name
	 *@param payMoney
	 *@param sms_release
	*/
	protected void sendPayMsg (PayUserBaseEntity userBase, PayBookEntity bookIn){
		
		IUser user = super.getUser();
		IControl control = super.getControl();
		
		UserInfoEntity userInfo = user.getUserInfo(userBase.getPhoneNo());
		String brandName = userInfo.getBrandName();
		
		Map<String, Object> mapTmp = new HashMap<String, Object>();
		MBean inMessage = new MBean();
		
		/*
		 * 尊敬的${sm_name}品牌客户，交费成功，本次交费金额为${pay_money}元。友情提示:如果您订购了GPRS业务，
		 * 停机后缴费复机时需重启手机来恢复GPRS的使用。您可为亲友间的通话慷慨买单了，业务详情及办理请发送“亲情网”至10086。【中国移动】${sms_release}
		 */
		
		mapTmp.put("brand_name", brandName);
		mapTmp.put("pay_money",ValueUtils.transFenToYuan(bookIn.getPayFee()));
		mapTmp.put("sms_release", "");
		
		inMessage.addBody("PHONE_NO", userInfo.getPhoneNo());
		inMessage.addBody("LOGIN_NO", bookIn.getLoginNo());;
		inMessage.addBody("OP_CODE", bookIn.getOpCode());
		inMessage.addBody("CHECK_FLAG", true);
		inMessage.addBody("TEMPLATE_ID", "311200807401");
		inMessage.addBody("DATA", mapTmp);
		log.info("发送短信内容：" + inMessage.toString());
		
		String flag = control.getPubCodeValue(2011, "DXFS", null);  // 0:直接发送 1:插入短信接口临时表 2：外系统有问题，直接不发送短信
		if(flag.equals("0")){
			inMessage.addBody("SEND_FLAG", 0);
		}else if(flag.equals("1")){
			inMessage.addBody("SEND_FLAG", 1);
		}else if(flag.equals("2")){
			return;
		}
		
		shortMessage.sendSmsMsg(inMessage, 1);
		
	}
	
	private long getPayContractNo(String phoneNo, Long contractNo){
		
		IUser user = super.getUser();
		
		if(contractNo != null && contractNo != 0){
			return contractNo;
		}else{
				UserInfoEntity uie = user.getUserEntity(null, phoneNo, null, true);
				return  uie.getContractNo();
			}
		
	}
	/**
	 * @return the loginCheck
	 */
	public LoginCheck getLoginCheck() {
		return loginCheck;
	}
	/**
	 * @param loginCheck the loginCheck to set
	 */
	public void setLoginCheck(LoginCheck loginCheck) {
		this.loginCheck = loginCheck;
	}
	/**
	 * @return the shortMessage
	 */
	public IShortMessage getShortMessage() {
		return shortMessage;
	}
	/**
	 * @param shortMessage the shortMessage to set
	 */
	public void setShortMessage(IShortMessage shortMessage) {
		this.shortMessage = shortMessage;
	}
	
}
