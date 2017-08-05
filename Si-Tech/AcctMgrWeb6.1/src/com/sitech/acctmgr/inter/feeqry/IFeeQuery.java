package com.sitech.acctmgr.inter.feeqry;

import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
 * Created by wangyla on 2016/7/21.
 */
public interface IFeeQuery {
	/**
	 * 功能：用户余额费用及有效期等查询 <br>
	 * 对应旧接口：sPhoneDefMsg 余额、有效期、帐户信息查询、
	 * 
	 * @param inParam
	 * @return
	 */
	OutDTO balanceQuery(InDTO inParam);
	
}