<div id="oper_title">Ӫ���������ϸ��Ϣ</div>
		
		<%
			/* Ӫ���������ϸ��Ϣ*/
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
				<!--Ӫ����ʽ��ť: onclick:f4938_jsGlobal.jsp ready��ʼ�� hlj songjia-->
				<input name="rule" type="radio" value="<%=meansId%>" disabled="disabled"/>
				<%=meansName%>
				<!--ͨ���ؼ���ģ����ѯӪ����ʽ����div����Ϣ�洢��quyl����-->
				<input type="hidden" name="meaIdSearch" value="<%=meansName%>&<%=meansId%>">
			</div>
			<div class="title_tu" id="title<%=meansId%>">
			<input type="button" class="butOpen" id="pic<%=meansId%>" value=""/>
			</div>
		</div>
		
		<!--hlj ��ѡ��ĳһӪ����ʽʱϸ��չ��div quyl���ķ�ʽ-->
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
				<!--����ͬȫ�ֱ���meansFalg,���ύУ����-->
				<input name="global_flag" type="hidden" id="global_flag" value="" />
			 	<!--end-->
				<!-- �洢IMEI_CODE����ӡ -->
				<input name = "global_inputImeiCode" id="global_inputImeiCode" type="hidden" />
				<!--hlj songjia -->
				<%--ĳ���ֶε�json��--%>	
				<input name ="global_json" id="global_json" type="hidden" value=""/>
				<!--�ֽ�-->
				<input name ="global_cashInfo" id="global_cashInfo" type="hidden" value=""/>
				<!--ר��-->
				<input name ="global_specialfunds" id="global_specialfunds" type="hidden" value=""/>
				<!--����ר��-->
				<input name ="global_assispecialfunds" id="global_assispecialfunds" type="hidden" value=""/>
				<!--ϵͳ��ֵ-->
				<input name ="global_systemPay_h" id="global_systemPay_h" type="hidden" value=""/>
				<!--��ͥ�ʷ�-->
				<input name ="global_familyFee" id="global_familyFee" type="hidden" value=""/>
				<!--��Լ�ʷ�-->
				<input name ="global_agreementfee" id="global_agreementfee" type="hidden" value=""/>
				<!--���п����ڸ���-->
				<input name ="global_bankPayFee" id="global_bankPayFee" type="hidden" value=""/>
				<!--����Ʒ-->
				<input name ="global_giftInfo" id="global_giftInfo" type="hidden" value=""/>
				<!--�ֻ�ƾ֤-->
				<input name ="global_phoneCredence" id="global_phoneCredence" type="hidden" value=""/>
				<!--�ն�-->
				<input name ="global_clientInfo" id="global_clientInfo" type="hidden" value=""/>
				<!--���ʷ�-->
				<input name ="global_ssfeeInfo" id="global_ssfeeInfo" type="hidden" value=""/>
				<!--�м۵��ӿ�-->
				<input name ="global_priceCard" id="global_priceCard" type="hidden" value=""/>
				<!--�����ʷ���Ϣ-->
				<input name ="global_assiFeeInfo" id="global_assiFeeInfo" type="hidden" value=""/>
				<!--spҵ��-->
				<input name ="global_spInfo" id="global_spInfo" type="hidden" value=""/>
				<!--���ֿۼ�-->
				<input name ="global_subScore" id="global_subScore" type="hidden" value=""/>
				<!--��������-->
				<input name ="global_reScore_h" id="global_reScore_h" type="hidden" value=""/>
				<!--��������-->
				<input name ="global_netcode" id="global_netcode" type="hidden" value=""/>
				<!--������ʽ-->
				<input name ="global_orderType" id="global_orderType" type="hidden" value=""/>				
				<!--ȫ��ר��-->
				<input name ="global_specialallfunds" id="global_specialallfunds" type="hidden" value=""/>
				<!--ȫ�����ʷ�-->
				<input name ="global_allFee" id="global_allFee" type="hidden" value=""/>								
				<!--ȫ�������ʷ�-->
				<input name ="global_gAddFee" id="global_gAddFee" type="hidden" value=""/>
				<!--ȫ��WLAN-->
				<input name ="global_gWlan" id="global_gWlan" type="hidden" value=""/>					
				<!--ȫ������ҵ��-->
				<input name ="global_gData" id="global_gData" type="hidden" value=""/>		
				<!--ȫ���ն�-->
				<input name ="global_gRes" id="global_gRes" type="hidden" value=""/>
				<!--ȫ���ذ󸽼��ʷ�-->
				<input name ="global_bindingFeeInfo" id="global_bindingFeeInfo" type="hidden" value=""/>
				<!-- ��Ա�ʷ� -->
				<input name = "global_memberFee" id="global_memberFee" type="hidden" value="" />
				<!-- TD�ʷ� -->
				<input name = "global_tdFee" id="global_tdFee" type="hidden" value="" />
				<!-- ��Ա���� ���ʷ� �����ʷ� ר�� ϵͳ��ֵ ����ϵͳ��ֵ/�����ۿ� -->
				<input name = "global_memNo" id="global_memNo" type="hidden" value="" />
				<input name = "global_memFee" id="global_memFee" type="hidden" value="" />
				<input name = "global_memAddFee" id="global_memAddFee" type="hidden" value="" />
				<input name = "global_memFund" id="global_memFund" type="hidden" value="" />
				<input name = "global_memSysFee" id="global_memSysFee" type="hidden" value="" />
				<input name = "global_broadDiscountPay" id="global_broadDiscountPay" type="hidden" value="" />
				<!--end -->
				<!-- ��ͥ ��������  -->
				<input name = "global_familyLowType" id="global_familyLowType" type="hidden" value="" />
				<!--end -->
				<input type="hidden" name="global_scoreValue" id="global_scoreValue" value="">
				<input type="hidden" name="global_scoreMoney" id="global_scoreMoney" value="">	
				<input type="hidden" id="isAward" value="">
				<!--��������-->
				<input name ="global_custInfo" id="global_custInfo" type="hidden" value=""/>
				<!-- add by zhouwy date:2015-04-17 begin -->
				<!--��������-->
				<input name ="global_netCode_temp" id="global_netCode_temp" type="hidden" value=""/>
				<!--������ʶ-->
				<input name ="global_netFlag" id="global_netFlag" type="hidden" value=""/>
				<!--����Ʒ��-->
				<input name ="global_netSmCode" id="global_netSmCode" type="hidden" value=""/>
				<!--���ֵ��������-->
				<input name ="global_netScoreMoney" id="global_netScoreMoney" type="hidden" value=""/>
				<!-- add by zhouwy date:2015-04-17 end -->
				<input name ="global_contracttime" id="global_contracttime" type="hidden" value=""/>
				<!--ħ�ٺ�ҵ���ʶ add by zhouwy date:2015-08-03-->
				<input name ="global_spNetFlag" id="global_spNetFlag" type="hidden" value=""/>
				<!--ģ�� add by quyl date:2015-12-22-->
				<input name ="global_templet" id="global_templet" type="hidden" value=""/>
				<!--�ʷѷ��롢���ʷѡ������ʷ������Ϣ add by zhouwy date:2016-03-28-->
				<input name ="global_agreeFeeDesc" id="global_agreeFeeDesc" type="hidden" value=""/>
				<input name ="global_agreeFeeNote" id="global_agreeFeeNote" type="hidden" value=""/>
				<input name ="global_feeDesc" id="global_feeDesc" type="hidden" value=""/>
				<input name ="global_feeNote" id="global_feeNote" type="hidden" value=""/>
				<input name ="global_AssiFeeDesc" id="global_AssiFeeDesc" type="hidden" value=""/>
				<input name ="global_AssiFeeNote" id="global_AssiFeeNote" type="hidden" value=""/>
				<!--�Ͱ�����ȯ���-->
				<input name ="global_GiftMoney" id="global_GiftMoney" type="hidden" value=""/>
				<input name ="global_Notice" id="global_Notice" type="hidden" value=""/>
				