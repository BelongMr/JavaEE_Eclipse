<div id="oper_title">营销活动规则详细信息</div>
		
		<%
			/* 营销活动规则详细信息*/
		 Map MeanMap = null;
		 MapBean m = new MapBean();
		 if (null != meansList) {
			int totalsize = meansList.size();
			for(int i=0; i<totalsize; i++){
			  	MeanMap = m.isMap(meansList.get(i));
			  	if(MeanMap==null) continue;
			  	
			  	String meansId = (String) MeanMap.get("MEANS_ID")==null?"":(String) MeanMap.get("MEANS_ID");
				String meansName = (String) MeanMap.get("MEANS_NAME")==null?"":(String) MeanMap.get("MEANS_NAME");
			%>
		
		<div class="title" id="title_<%=meansId%>">
			<div class="text">
				<!--营销方式按钮: onclick:f4938_jsGlobal.jsp ready初始化 hlj songjia-->
				<input name="rule" type="radio" value="<%=meansId%>" disabled="disabled"/>
				<%=meansName%>
				<!--通过关键字模糊查询营销方式显隐div框信息存储，quyl添加-->
				<input type="hidden" name="meaIdSearch" value="<%=meansName%>&<%=meansId%>">
			</div>
			<div class="title_tu" id="title<%=meansId%>">
			<input type="button" class="butOpen" id="pic<%=meansId%>" value=""/>
			</div>
		</div>
		
		<!--hlj 当选择某一营销方式时细则展现div quyl更改方式-->
		<div id="ruleDetail<%=meansId%>" style="display:none">
			<div class="input">
				<table id="meansDetail<%=meansId%>">

				</table>
			</div>
		</div>
<%
  }
}
%>
				<!--意义同全局变量meansFalg,供提交校验用-->
				<input name="global_flag" type="hidden" id="global_flag" value="" />
			 	<!--end-->
				<!-- 存储IMEI_CODE供打印 -->
				<input name = "global_inputImeiCode" id="global_inputImeiCode" type="hidden" />
				<!--hlj songjia -->
				<%--某个手段的json串--%>	
				<input name ="global_json" id="global_json" type="hidden" value=""/>
				<!--现金-->
				<input name ="global_cashInfo" id="global_cashInfo" type="hidden" value=""/>
				<!--专款-->
				<input name ="global_specialfunds" id="global_specialfunds" type="hidden" value=""/>
				<!--副卡专款-->
				<input name ="global_assispecialfunds" id="global_assispecialfunds" type="hidden" value=""/>
				<!--系统充值-->
				<input name ="global_systemPay_h" id="global_systemPay_h" type="hidden" value=""/>
				<!--家庭资费-->
				<input name ="global_familyFee" id="global_familyFee" type="hidden" value=""/>
				<!--合约资费-->
				<input name ="global_agreementfee" id="global_agreementfee" type="hidden" value=""/>
				<!--银行卡分期付款-->
				<input name ="global_bankPayFee" id="global_bankPayFee" type="hidden" value=""/>
				<!--促销品-->
				<input name ="global_giftInfo" id="global_giftInfo" type="hidden" value=""/>
				<!--手机凭证-->
				<input name ="global_phoneCredence" id="global_phoneCredence" type="hidden" value=""/>
				<!--终端-->
				<input name ="global_clientInfo" id="global_clientInfo" type="hidden" value=""/>
				<!--主资费-->
				<input name ="global_ssfeeInfo" id="global_ssfeeInfo" type="hidden" value=""/>
				<!--有价电子卡-->
				<input name ="global_priceCard" id="global_priceCard" type="hidden" value=""/>
				<!--附加资费信息-->
				<input name ="global_assiFeeInfo" id="global_assiFeeInfo" type="hidden" value=""/>
				<!--sp业务-->
				<input name ="global_spInfo" id="global_spInfo" type="hidden" value=""/>
				<!--积分扣减-->
				<input name ="global_subScore" id="global_subScore" type="hidden" value=""/>
				<!--抵消积分-->
				<input name ="global_reScore_h" id="global_reScore_h" type="hidden" value=""/>
				<!--宽带号码-->
				<input name ="global_netcode" id="global_netcode" type="hidden" value=""/>
				<!--订购方式-->
				<input name ="global_orderType" id="global_orderType" type="hidden" value=""/>				
				<!--全网专款-->
				<input name ="global_specialallfunds" id="global_specialallfunds" type="hidden" value=""/>
				<!--全网主资费-->
				<input name ="global_allFee" id="global_allFee" type="hidden" value=""/>								
				<!--全网附加资费-->
				<input name ="global_gAddFee" id="global_gAddFee" type="hidden" value=""/>
				<!--全网WLAN-->
				<input name ="global_gWlan" id="global_gWlan" type="hidden" value=""/>					
				<!--全网数据业务-->
				<input name ="global_gData" id="global_gData" type="hidden" value=""/>		
				<!--全网终端-->
				<input name ="global_gRes" id="global_gRes" type="hidden" value=""/>
				<!--全网必绑附加资费-->
				<input name ="global_bindingFeeInfo" id="global_bindingFeeInfo" type="hidden" value=""/>
				<!-- 成员资费 -->
				<input name = "global_memberFee" id="global_memberFee" type="hidden" value="" />
				<!-- TD资费 -->
				<input name = "global_tdFee" id="global_tdFee" type="hidden" value="" />
				<!-- 成员号码 主资费 附加资费 专款 系统充值 宽带系统充值/宽带折扣 -->
				<input name = "global_memNo" id="global_memNo" type="hidden" value="" />
				<input name = "global_memFee" id="global_memFee" type="hidden" value="" />
				<input name = "global_memAddFee" id="global_memAddFee" type="hidden" value="" />
				<input name = "global_memFund" id="global_memFund" type="hidden" value="" />
				<input name = "global_memSysFee" id="global_memSysFee" type="hidden" value="" />
				<input name = "global_broadDiscountPay" id="global_broadDiscountPay" type="hidden" value="" />
				<!--end -->
				<!-- 家庭 低消类型  -->
				<input name = "global_familyLowType" id="global_familyLowType" type="hidden" value="" />
				<!--end -->
				<input type="hidden" name="global_scoreValue" id="global_scoreValue" value="">
				<input type="hidden" name="global_scoreMoney" id="global_scoreMoney" value="">	
				<input type="hidden" id="isAward" value="">
				<!--异网号码-->
				<input name ="global_custInfo" id="global_custInfo" type="hidden" value=""/>
				<!-- add by zhouwy date:2015-04-17 begin -->
				<!--宽带号码-->
				<input name ="global_netCode_temp" id="global_netCode_temp" type="hidden" value=""/>
				<!--宽带标识-->
				<input name ="global_netFlag" id="global_netFlag" type="hidden" value=""/>
				<!--宽带品牌-->
				<input name ="global_netSmCode" id="global_netSmCode" type="hidden" value=""/>
				<!--积分抵消包年款-->
				<input name ="global_netScoreMoney" id="global_netScoreMoney" type="hidden" value=""/>
				<!-- add by zhouwy date:2015-04-17 end -->
				<input name ="global_contracttime" id="global_contracttime" type="hidden" value=""/>
				<!--魔百和业务标识 add by zhouwy date:2015-08-03-->
				<input name ="global_spNetFlag" id="global_spNetFlag" type="hidden" value=""/>
				<!--模板 add by quyl date:2015-12-22-->
				<input name ="global_templet" id="global_templet" type="hidden" value=""/>
				<!--资费分离、主资费、附加资费免填单信息 add by zhouwy date:2016-03-28-->
				<input name ="global_agreeFeeDesc" id="global_agreeFeeDesc" type="hidden" value=""/>
				<input name ="global_agreeFeeNote" id="global_agreeFeeNote" type="hidden" value=""/>
				<input name ="global_feeDesc" id="global_feeDesc" type="hidden" value=""/>
				<input name ="global_feeNote" id="global_feeNote" type="hidden" value=""/>
				<input name ="global_AssiFeeDesc" id="global_AssiFeeDesc" type="hidden" value=""/>
				<input name ="global_AssiFeeNote" id="global_AssiFeeNote" type="hidden" value=""/>
				<!--和包电子券金额-->
				<input name ="global_GiftMoney" id="global_GiftMoney" type="hidden" value=""/>
				<input name ="global_Notice" id="global_Notice" type="hidden" value=""/>
				