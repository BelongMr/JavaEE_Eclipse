package com.sitech.acctmgr.atom.dto.pay;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.annotation.JSONField;
import com.sitech.acctmgr.atom.domains.pay.PayOutEntity;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 * <p>Title: DTO  </p>
 * <p>Description:   </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 * @author qiaolin
 * @version 1.0
 */
public class S8025CardCfmBy10086OutDTO extends CommonOutDTO {
	
	@JSONField(name="CARD_FEE")
	@ParamDesc(path="CARD_FEE",cons=ConsType.CT001,type="String",len="8",desc="有价卡金额",memo="单位：分")
	protected String cardFee;
	
	@ParamDesc(path="CARD_NO",cons=ConsType.CT001,type="String",len="40",desc="充值卡号",memo="略")
	protected String cardNo;
	
	@ParamDesc(path="RETN",cons=ConsType.CT001,type="String",len="40",desc="充值结果代码",memo="略")
	protected String retn;
	
	/* (non-Javadoc)
	 * @see com.sitech.jcfx.dt.out.OutDTO#encode()
	 */
	@Override
	public MBean encode() {
		MBean result = new MBean();
		result.setRoot(getPathByProperName("cardFee"), cardFee);
		result.setRoot(getPathByProperName("cardNo"), cardNo);
		result.setRoot(getPathByProperName("RETN"), retn);
		return result;
	}

	public String getRetn() {
		return retn;
	}

	public void setRetn(String retn) {
		this.retn = retn;
	}

	public String getCardFee() {
		return cardFee;
	}

	public void setCardFee(String cardFee) {
		this.cardFee = cardFee;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

}