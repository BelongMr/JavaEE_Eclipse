package com.sitech.acctmgr.inter.query;

import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
*
* <p>Title:  银行卡签约客户操作查询接口 </p>
* <p>Description:  银行卡签约客户操作查询接口 </p>
* <p>Copyright: Copyright (c) 2016</p>
* <p>Company: SI-TECH </p>
* @author xiongjy
* @version 1.0
*/
public interface I8421 {
	OutDTO query(final InDTO inParam);
}
