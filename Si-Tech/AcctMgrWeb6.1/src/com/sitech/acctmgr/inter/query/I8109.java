package com.sitech.acctmgr.inter.query;

import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
 *
 * <p>Title:  呆坏账查询 </p>
 * <p>Description: 查询用户离网账单费用  </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author xiongjy
 * @version 1.0
 */
public interface I8109 {
	OutDTO query(final InDTO inParam);
	OutDTO qryUserDeadInfo(InDTO inParam);
}