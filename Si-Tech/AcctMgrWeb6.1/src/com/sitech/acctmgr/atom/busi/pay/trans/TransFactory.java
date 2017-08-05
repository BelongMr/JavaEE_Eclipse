package com.sitech.acctmgr.atom.busi.pay.trans;

import com.sitech.acctmgr.atom.busi.pay.inter.ITransType;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcfx.context.JCFContext;

/**
*
* <p>Title:  转账类型实例获取 </p>
* <p>Description:  获取转账类型实例 </p>
* <p>Copyright: Copyright (c) 2014</p>
* <p>Company: SI-TECH </p>
* @author guowy
* @version 1.0
*/
public class TransFactory extends AcctMgrBaseService {

	public ITransType createTransFactory(String opType, boolean isOnNet) {
		String beanName = "";
		
		if(StringUtils.isEmptyOrNull(opType)){
			throw new BaseException(AcctMgrError.getErrorCode("8014", "00035"), "转账类型传入错误！");
		} 
		
		if(isOnNet){
			beanName = opType;
		}else{
			beanName =  opType + "Dead";
		}
		
		return (ITransType)JCFContext.getBean(beanName);
		
	}

}