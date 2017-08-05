package com.sitech.acctmgr.atom.impl.invoice;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.invoice.inter.IPrintDataXML;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.account.ContractDeadInfoEntity;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.balance.TransFeeEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.cust.CustInfoEntity;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserDeadEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.invoice.S8014PrintInDTO;
import com.sitech.acctmgr.atom.dto.invoice.S8014PrintOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IBase;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IInvoice;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgr.inter.invoice.I8014AcceptList;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

/**
 * 名称：8014转账免填单打印
 * 
 * @author liuhl_bj
 *
 */
@ParamTypes({ @ParamType(c = S8014PrintInDTO.class, oc = S8014PrintOutDTO.class, m = "print") })
public class S8014AcceptList extends AcctMgrBaseService implements I8014AcceptList {
	private IUser user;
	private ICust cust;
	private IControl control;
	private IBase base;
	private IAccount account;
	private IRecord record;
	private ILogin login;
	private IRemainFee remainFee;
	private IPrintDataXML printDataXml;
	private IInvoice invoice;

	private IGroup group;
	private IPreOrder preOrder;
	@Override
	public OutDTO print(InDTO inParam) {
		S8014PrintInDTO inDto = (S8014PrintInDTO) inParam;

		long transSn = inDto.getTranSn();
		int userFlag = inDto.getUserFlag();
		// 根据转账流水查询转出号码，转入号码，转出账号，转入账号
		TransFeeEntity trans = record.getTransInfo(transSn, DateUtils.getCurYm());
		String phoneNoOut = trans.getPhonenoOut();

		// 根据服务号码查询用户信息
		UserInfoEntity userInfo = new UserInfoEntity();
		String brandName = "";
		// 根据账户号码查询账户名称
		long contractNo = trans.getContractnoOut();
		String contractName = "";
		long custId = 0;
		if (userFlag == 1) {
			userInfo = user.getUserInfo(trans.getPhonenoOut());
			brandName = userInfo.getBrandName();
			ContractInfoEntity contractInfo = account.getConInfo(contractNo);
			contractName = contractInfo.getContractName();
			custId = contractInfo.getCustId();
		} else {
			List<UserDeadEntity> userDead = user.getUserdeadEntity(phoneNoOut, trans.getIdnoOut(), trans.getContractnoOut());
			custId = userDead.get(0).getCustId();
			ContractDeadInfoEntity contractDeadInfo = account.getConDeadInfo(trans.getContractnoOut());
			contractName = contractDeadInfo.getContractName();
		}
		// 根据cust_id查询客户信息
		CustInfoEntity custInfo = cust.getCustInfo(custId, "");
		String custName = custInfo.getCustName();
		String custAddress = custInfo.getCustAddress();
		String idIccid = custInfo.getIdIccid();

		// 查询转账金额
		long transFee = trans.getTransFee();
		// 获取转存号码，转存账号，转存余额
		String phonenoIn = trans.getPhonenoIn();
		long contractNoIn = trans.getContractnoIn();

		// 根据op_code查询业务名称
		String opCode = inDto.getOpCode();
		String opName = base.getFunctionName(opCode);

		// 根据工号查询工号名称
		String loginNo = inDto.getLoginNo();
		LoginEntity loginInfo = login.getLoginInfo(loginNo, inDto.getProvinceId().toString());
		String loginName = loginInfo.getLoginName();

		String opTime = trans.getOpTime();
		// TODO：查询转出账户的余额
		OutFeeData outFee = remainFee.getConRemainFee(contractNo);
		long remainFee = outFee.getRemainFee();

		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("OP_TIME", opTime);
		inMap.put("LOGIN_NO", loginNo);
		inMap.put("LOGIN_NAME", loginName);
		inMap.put("PHONENO_OUT", phoneNoOut);
		inMap.put("CUST_NAME", custName);
		inMap.put("CUST_ADDRESS", custAddress);
		inMap.put("ID_ICCID", idIccid);
		inMap.put("BRAND_NAME", brandName);
		inMap.put("OP_NAME", opName);
		inMap.put("TRANS_SN", transSn);
		inMap.put("CONTRACT_NAME", contractName);
		inMap.put("CONTRACTNO_IN", contractNoIn);
		inMap.put("TRANS_FEE", transFee);
		inMap.put("PHONENO_IN", phonenoIn);
		inMap.put("CONTRACTNO_OUT", contractNo);
		inMap.put("REMAIN_FEE", remainFee);
		Map<String, Object> argMap = getArgMap(inMap);
		argMap.put("PRINT_TYPE", "0nn");
		argMap.put("OP_CODE", opCode);
		String xmlStr = printDataXml.getPrintXml(argMap);

		// 获取发票上的流水
		long printSn = invoice.getPrintSn();
		inMap.put("PRINT_SN", printSn);
		// 记录工号操作记录表
		LoginOprEntity loe = new LoginOprEntity();
		loe.setLoginGroup(inDto.getGroupId());
		loe.setLoginNo(inDto.getLoginNo());
		loe.setLoginSn(printSn);
		loe.setTotalDate(DateUtils.getCurDay());
		loe.setIdNo(0);
		loe.setBrandId("xx");
		loe.setPayType("00");
		loe.setPayFee(0);
		loe.setOpCode(inDto.getOpCode());
		loe.setRemark(inDto.getLoginNo() + "操作转账打印免填单");
		record.saveLoginOpr(loe);

		// 同步CRM统一接触
		ChngroupRelEntity cgre = group.getRegionDistinct(inDto.getGroupId(), "2", inDto.getProvinceId());
		Map<String, Object> oprCnttMap = new HashMap<String, Object>();
		oprCnttMap.put("Header", inDto.getHeader());
		oprCnttMap.put("PAY_SN", printSn);
		oprCnttMap.put("LOGIN_NO", inDto.getLoginNo());
		oprCnttMap.put("GROUP_ID", inDto.getGroupId());
		oprCnttMap.put("OP_CODE", inDto.getOpCode());
		oprCnttMap.put("REGION_ID", cgre.getRegionCode());
		oprCnttMap.put("OP_NOTE", inDto.getLoginNo() + "操作转账打印免填单");
		oprCnttMap.put("TOTAL_FEE", 0);
		oprCnttMap.put("CUST_ID_TYPE", "1");
		oprCnttMap.put("CUST_ID_VALUE", phoneNoOut);
		// 取系统时间
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		oprCnttMap.put("OP_TIME", sCurTime);
		preOrder.sendOprCntt(oprCnttMap);

		S8014PrintOutDTO outDto = new S8014PrintOutDTO();
		outDto.setXmlStr(xmlStr);
		return outDto;

	}

	private Map<String, Object> getArgMap(Map<String, Object> inMap) {

		Map<String, Object> outMap = new HashMap<String, Object>();
		outMap.put("HEAD_LINE1", inMap.get("OP_TIME").toString());
		outMap.put("HEAD_LINE2", inMap.get("LOGIN_NO").toString() + " " + inMap.get("LOGIN_NAME").toString());
		outMap.put("FIRST_LINE", "手机号码：" + inMap.get("PHONENO_OUT"));
		outMap.put("SECOND_LINE", "客户名称：" + inMap.get("CUST_NAME"));
		outMap.put("THIRD_LINE", "客户地址：" + inMap.get("CUST_ADDRESS"));
		outMap.put("FOURTH_LINE", "证件号码：" + inMap.get("ID_ICCID"));
		outMap.put("FIVTH_LINE", "用户品牌：" + inMap.get("BRAND_NAME") + "   办理业务：" + inMap.get("OP_NAME") + "  操作流水：" + inMap.get("TRANS_SN"));
		outMap.put(
				"SIX_LINE",
				"账户名称：" + inMap.get("CONTRACT_NAME") + "  账户号码：" + inMap.get("CONTRACTNO_OUT") + "  转账金额："
						+ ValueUtils.transFenToYuan(inMap.get("TRANS_FEE")));
		outMap.put(
				"SEVEN_LINE",
				"转存号码：" + inMap.get("PHONENO_IN") + "  转存账号：" + inMap.get("CONTRACTNO_IN") + "  转存余额："
						+ ValueUtils.transFenToYuan(inMap.get("REMAIN_FEE")));
		outMap.put("BUTTOM_LINE1", inMap.get("LOGIN_NO") + "  " + inMap.get("LOGIN_NAME").toString());
		outMap.put("BUTTOM_LINE2", inMap.get("OP_TIME").toString());
		return outMap;
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

	public IBase getBase() {
		return base;
	}

	public void setBase(IBase base) {
		this.base = base;
	}

	public IAccount getAccount() {
		return account;
	}

	public void setAccount(IAccount account) {
		this.account = account;
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

	public IRemainFee getRemainFee() {
		return remainFee;
	}

	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}

	public IPrintDataXML getPrintDataXml() {
		return printDataXml;
	}

	public void setPrintDataXml(IPrintDataXML printDataXml) {
		this.printDataXml = printDataXml;
	}

	public IInvoice getInvoice() {
		return invoice;
	}

	public void setInvoice(IInvoice invoice) {
		this.invoice = invoice;
	}

	public IGroup getGroup() {
		return group;
	}

	public void setGroup(IGroup group) {
		this.group = group;
	}

	public IPreOrder getPreOrder() {
		return preOrder;
	}

	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}

}