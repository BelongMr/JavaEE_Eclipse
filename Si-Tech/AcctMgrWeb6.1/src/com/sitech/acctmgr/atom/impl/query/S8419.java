package com.sitech.acctmgr.atom.impl.query;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.balance.TransFeeEntity;
import com.sitech.acctmgr.atom.domains.query.AgentOprEntity;
import com.sitech.acctmgr.atom.domains.record.ActQueryOprEntity;
import com.sitech.acctmgr.atom.dto.query.S8419InitInDTO;
import com.sitech.acctmgr.atom.dto.query.S8419InitOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.inter.query.I8419;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

@ParamTypes({ 
	@ParamType(c = S8419InitInDTO.class,oc=S8419InitOutDTO.class, m = "query")
	})
public class S8419 extends AcctMgrBaseService implements I8419{

	protected IAccount account;
	protected IControl control;
	protected IBalance balance;
	protected IRecord record;
	
	@Override
	public OutDTO query(InDTO inParam) {
		Map<String,Object> inMap = new HashMap<String,Object>();
		S8419InitOutDTO outDto = new S8419InitOutDTO();
		List<AgentOprEntity> transList = new ArrayList<AgentOprEntity>();
		ArrayList shortMsgList = new ArrayList();
		
		S8419InitInDTO inDto = (S8419InitInDTO)inParam;
		String agePhone = inDto.getAgtPhoneNo();
		String beginDate = inDto.getBeginDate();
		String endDate = inDto.getEndDate();
		String loginNo = inDto.getLoginNo();
		
		ContractInfoEntity cie = account.getAgtInfo(agePhone);
		long contractNo = cie.getContractNo();
		
		if(StringUtils.isEmptyOrNull(beginDate)){			
			outDto.setContractNo(contractNo);
			return outDto;
		}
		
		//取当前时间
		String sCurDate = DateUtil.format(new Date(), "yyyyMMdd");
		String curYm = sCurDate.substring(0, 6);
		
		//取系统流水
		long loginAccept=control.getSequence("SEQ_SYSTEM_SN");
		
		//取明细信息
		int recordNum=0;
		long payMoney=0;
		long payNum=0;
		long backMoney=0;
		long backNum=0;
		if(StringUtils.isNotEmpty(beginDate)&&StringUtils.isNotEmpty(endDate)) {
			int iBeginYm = Integer.parseInt(beginDate)/100;
			int iEndYm = Integer.parseInt(endDate)/100;
			for(int iOneYm = iEndYm; iOneYm >= iBeginYm; iOneYm = Integer.valueOf(DateUtil.toStringMinusMonths(String.valueOf(iOneYm), 1, "yyyyMM"))){
				inMap.put("AGT_PHONE_NO", agePhone);
				inMap.put("YEAR_MONTH", iOneYm);
				inMap.put("BEGIN_DATE", beginDate);
				inMap.put("END_DATE", endDate);
				List<TransFeeEntity> tempList = balance.getAgentTrasfeeInfo(inMap);
				if(tempList.size()>0){
					for(TransFeeEntity tfe:tempList) {
						AgentOprEntity aoe = new AgentOprEntity();
						String opTime = tfe.getOpTime1();
						String phoneNoIn = tfe.getPhonenoIn();
						long transFee = tfe.getTransFee();
						long transSn = tfe.getTransSn();
						if(tfe.getStatus().equals("1")){
							aoe.setStatus("已冲正");
							backMoney = backMoney+transFee;
							backNum++;
						}else if(tfe.getStatus().equals("0")) {
							aoe.setStatus("未冲正");
							payMoney = payMoney+transFee;
							payNum++;
						}
						aoe.setOpTime(opTime);
						aoe.setPhoneNo(phoneNoIn);
						aoe.setTransFee(transFee);
						aoe.setTransSn(transSn);
						transList.add(aoe);
						shortMsgList.add(opTime+" " + phoneNoIn + "#" + transFee);
						recordNum++;
						if(recordNum==200){
							break;
						}
					}
				}
				if(recordNum==200){
					break;
				}
			}
			
			if(loginNo.equals("rrrrrr")) {
				int recNo=0;
				if (recordNum%5 == 0)
				{
					recNo = recordNum / 5;
				}else{
					recNo = recordNum / 5 +1;
				}
				
				for(int i=0;i<recNo;i++)
				{
					int iRow = i;
					String sendShortMsg = "短信"+String.valueOf(iRow+1)+shortMsgList.get(iRow*5+0).toString()+shortMsgList.get(iRow*5+1).toString()+shortMsgList.get(iRow*5+2).toString()+shortMsgList.get(iRow*5+3).toString()+shortMsgList.get(iRow*5+4).toString();
					log.info("xxxxxxxx="+sendShortMsg);
				}
			}
		}
		

		ActQueryOprEntity oprEntity = new ActQueryOprEntity();
		oprEntity.setQueryType("0");
		oprEntity.setOpCode("8419");
		oprEntity.setContactId("");
		oprEntity.setPhoneNo(agePhone);
		oprEntity.setBrandId("");
		oprEntity.setLoginNo(inDto.getLoginNo());
		oprEntity.setLoginGroup(inDto.getGroupId());
		oprEntity.setRemark("代理商交易明细查询");
		oprEntity.setProvinceId(inDto.getProvinceId());
		record.saveQueryOpr(oprEntity, false);
		
		outDto.setContractNo(contractNo);
		outDto.setResultList(transList);
		outDto.setAllMoney(backMoney+payMoney);
		outDto.setBackMoney(backMoney);
		outDto.setPayMoney(payMoney);
		outDto.setPayNum(payNum);
		outDto.setBackNum(backNum);
		return outDto;
	}

	/**
	 * @return the account
	 */
	public IAccount getAccount() {
		return account;
	}

	/**
	 * @param account the account to set
	 */
	public void setAccount(IAccount account) {
		this.account = account;
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
	
}