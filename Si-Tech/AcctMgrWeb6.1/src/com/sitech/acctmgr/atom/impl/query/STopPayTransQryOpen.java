package com.sitech.acctmgr.atom.impl.query;

import java.util.HashMap;
import java.util.Map;

import com.sitech.acctmgr.atom.dto.query.STopPayTransQryOpenInDTO;
import com.sitech.acctmgr.atom.dto.query.STopPayTransQryOpenOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.inter.query.ITopPayTransQryOpen;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

@ParamTypes({ @ParamType(c = STopPayTransQryOpenInDTO.class, m = "query", oc = STopPayTransQryOpenOutDTO.class)

})
public class STopPayTransQryOpen extends AcctMgrBaseService implements ITopPayTransQryOpen{
	
	private IBalance balance;
	
	@Override
	public OutDTO query(InDTO inParam) {
		// TODO Auto-generated method stub
		Map<String, Object> inMapTmp = new HashMap<String, Object>();
		Map<String, Object> outMapTmp = new HashMap<String, Object>();
		
		String actionDate="";
		String transActionId="";
		
		String op_flag="";
		String back_flag="";
		
		String rspCode="0000";
		String rspMsg="成功";
		
		STopPayTransQryOpenInDTO inParamDto=(STopPayTransQryOpenInDTO)inParam;
		actionDate=inParamDto.getActionDate();
		transActionId=inParamDto.getTransActionId();
		
		inMapTmp.put("TRANSACTIONID", transActionId);
		inMapTmp.put("ACTIONDATE", actionDate);
		outMapTmp = balance.qTotalPayByTranId(inMapTmp);
		//log.error("------>outMapTmp="+(outMapTmp==null));
		if(outMapTmp == null){
			rspCode="4A05";
			rspMsg="该笔交易不存在";
		}else{
			op_flag=outMapTmp.get("OP_FLAG").toString();

			if(op_flag.equals("0")) {
				back_flag=outMapTmp.get("BACK_FLAG").toString();

				if(back_flag.equals("0")) {
					rspCode="0000";
					rspMsg="交易成功";
				}else if(back_flag.equals("1")) {
					rspCode="3A14";
					rspMsg="该笔交易已被冲正";
				}else if(back_flag.equals("2")) {
					rspCode="3A15";
					rspMsg="该笔交易已完成退费";
				}else {
					rspCode="5A06";
					rspMsg="系统未知错误";
				}
			}else {
				rspCode="5A02";
				rspMsg="省公司充值失败";
			}
		}

		STopPayTransQryOpenOutDTO outDto= new STopPayTransQryOpenOutDTO();
		outDto.setActionDate(actionDate);
		outDto.setTransActionId(transActionId);
		outDto.setQueryTime(DateUtils.getCurDate(DateUtils.DATE_FORMAT_YYYYMMDDHHMISS));
		outDto.setRspCode(rspCode);
		outDto.setRspMsg(rspMsg);
		return outDto;
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

}