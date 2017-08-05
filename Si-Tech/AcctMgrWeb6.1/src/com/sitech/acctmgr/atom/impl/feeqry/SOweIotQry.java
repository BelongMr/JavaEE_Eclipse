package com.sitech.acctmgr.atom.impl.feeqry;

import java.util.Date;








import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.base.LoginEntity;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.record.ActQueryOprEntity;
import com.sitech.acctmgr.atom.domains.user.ServAddNumEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.feeqry.SOweIotQryInDTO;
import com.sitech.acctmgr.atom.dto.feeqry.SOweIotQryOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.ILogin;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.inter.feeqry.IOweIotQry;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

@ParamTypes({ @ParamType(m = "query", c = SOweIotQryInDTO.class, oc = SOweIotQryOutDTO.class)
})
public class SOweIotQry extends AcctMgrBaseService implements IOweIotQry{

	private IUser user;
	private IBalance balance;
	private IRemainFee remainFee;
	private IRecord record;
	private ILogin login;
	
	@Override
	public OutDTO query(InDTO inParam) {
		// TODO Auto-generated method stub
		SOweIotQryInDTO inDto = (SOweIotQryInDTO)inParam;
		String phoneNo = inDto.getPhoneNo();
		String logCode = inDto.getLogCode();
		String orderNo = inDto.getOrderNo();
		
		//如果是物联网号码，做转换
		ServAddNumEntity sane = user.getAddNumInfo("", phoneNo, "16");
		if(sane!=null) {
			phoneNo = sane.getPhoneNo();
		}
		
		String sCurTime = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		
		LoginEntity le = login.getLoginInfo(inDto.getLoginNo(), inDto.getProvinceId());
		String loginGroupId = le.getGroupId();
		
		UserInfoEntity uie = user.getUserInfo(phoneNo);
		long contractNo = uie.getContractNo();
		long idNo = uie.getIdNo();
		
		OutFeeData ofd = remainFee.getConRemainFee(contractNo);
		long remainFee = ofd.getRemainFee();
		long delayFee = ofd.getDelayFee();
			
		ActQueryOprEntity oprEntity = new ActQueryOprEntity();
		oprEntity.setQueryType("0");
		oprEntity.setOpCode("IOTYE");
		oprEntity.setContactId(orderNo);
		oprEntity.setIdNo(idNo);
		oprEntity.setPhoneNo(phoneNo);
		oprEntity.setBrandId("");
		oprEntity.setLoginNo(inDto.getLoginNo());
		oprEntity.setLoginGroup(loginGroupId);
		oprEntity.setRemark(logCode);
		oprEntity.setProvinceId(inDto.getProvinceId());
		record.saveQueryOpr(oprEntity, false);
		
		SOweIotQryOutDTO outDto = new SOweIotQryOutDTO();
		outDto.setRemainFee(remainFee-delayFee);
		outDto.setQueryTime(sCurTime);
		
		return outDto;
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
	 * @return the balance
	 */
	public IBalance getBalance() {
		return balance;
	}

	/**
	 * @param balance the balance to set
	 */
	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	/**
	 * @return the remainFee
	 */
	public IRemainFee getRemainFee() {
		return remainFee;
	}

	/**
	 * @param remainFee the remainFee to set
	 */
	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
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
	 * @return the login
	 */
	public ILogin getLogin() {
		return login;
	}

	/**
	 * @param login the login to set
	 */
	public void setLogin(ILogin login) {
		this.login = login;
	}
	
}