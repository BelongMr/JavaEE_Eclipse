package com.sitech.acctmgr.inter.feeqry;

import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
*
* <p>Title:17951IP充值卡余额余额接口  </p>
* <p>Description: 17951IP充值卡余额余额接口</p>
* <p>Copyright: Copyright (c) 2014</p>
* <p>Company: SI-TECH </p>
* @author xiongjy
* @version 1.0
*/
public interface I17951IpFeeQry {
	OutDTO query(InDTO inParam);
}