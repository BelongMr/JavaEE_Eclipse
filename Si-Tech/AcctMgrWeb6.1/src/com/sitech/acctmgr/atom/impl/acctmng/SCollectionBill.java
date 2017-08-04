package com.sitech.acctmgr.atom.impl.acctmng;

import com.sitech.acctmgr.atom.domains.account.ContractEntity;
import com.sitech.acctmgr.atom.domains.collection.CollBillDetInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.acctmng.SCollectionBillQueryInDTO;
import com.sitech.acctmgr.atom.dto.acctmng.SCollectionBillQueryOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.inter.acctmng.ICollectionBill;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wangyla on 2017/2/27.
 */

@ParamTypes({ 
	@ParamType(c = SCollectionBillQueryInDTO.class, oc=SCollectionBillQueryOutDTO.class, m = "query")
	})
public class SCollectionBill extends AcctMgrBaseService implements ICollectionBill {
	
	private IBill bill;
	private IAccount account;
	private IUser user;
	
	@Override
	public OutDTO query(InDTO inParam) {
		
		SCollectionBillQueryInDTO inDTO = (SCollectionBillQueryInDTO) inParam;

        log.debug("inDTO=" + inDTO.getMbean());
		
        int queryYm = inDTO.getQueryYm();
        long contractNo = inDTO.getContractNo();
         
        List<CollBillDetInfoEntity> collBillDetInfoList = new ArrayList<CollBillDetInfoEntity>();
        
        List<ContractEntity> conList = account.getUserList(contractNo);
        int count = 0;
        long totalFee = 0;
        
        for (ContractEntity contractEntity : conList) {
        	UserInfoEntity uie = user.getUserEntityByIdNo(contractEntity.getId(), false);
        	if(uie == null){
        		continue;
        	}
        	long realFee = bill.getRealFee(uie.getIdNo(), contractNo, queryYm);
        	
        	CollBillDetInfoEntity collBillDetInfoEnt = new CollBillDetInfoEntity();
        	collBillDetInfoEnt.setContractNo(contractNo);
        	collBillDetInfoEnt.setFee(realFee);
        	collBillDetInfoEnt.setQueryYm(queryYm);
        	collBillDetInfoEnt.setPhoneNo(uie.getPhoneNo());
        	
        	collBillDetInfoList.add(collBillDetInfoEnt);
        	
        	count++;
        	totalFee += realFee;
		}
        
        SCollectionBillQueryOutDTO outDTO = new SCollectionBillQueryOutDTO();
        outDTO.setBillList(collBillDetInfoList);
        outDTO.setCount(count);
        outDTO.setTotalFee(totalFee);

        log.debug("outDTO=" + outDTO.toJson());

        return outDTO;
	}

	public IBill getBill() {
		return bill;
	}

	public void setBill(IBill bill) {
		this.bill = bill;
	}

	public IAccount getAccount() {
		return account;
	}

	public void setAccount(IAccount account) {
		this.account = account;
	}

	public IUser getUser() {
		return user;
	}

	public void setUser(IUser user) {
		this.user = user;
	}
	
}
