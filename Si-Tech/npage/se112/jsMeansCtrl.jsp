<%
	//��ͬӪ����ʽ֮�����л�����
	//�Լ���ҵ���߼���ص�У���ҳ����Ƶ����js����
 %>

<script type="text/javascript">
/*
*ѡ��ĳ���ֶ�
*/
var obj = "";
var meansId = "";

function chooseRule(){
	obj = $(this);
	meansId = obj.val();
	
	if(meansId == means){
		return ;
	}else{
		//�ָ�ȫ�ֱ���Ĭ��ֵ
		reSetGlobalVar();
	}

	//���Ӳ���16С�಻�ܺ�4977һͬ�ŵ����ﳵ�а���  add quyl 20160711
	getMemberInfo();
	if(newNetCode == ""){
		
	}else{
		if("<%=act_type%>"!="16" ){
			showDialog("������16С��������������һ��ŵ����ﳵ��������",0);
			return false;
		}
	}
	
	var sPacket = null;
	sPacket = new AJAXPacket("marketLimit.jsp","���Ժ�......");
	
	sPacket.data.add("workNo","");
	sPacket.data.add("svcNum","<%=idNo%>");
	sPacket.data.add("actId","<%=actId%>");
	sPacket.data.add("opCode","mean");
	sPacket.data.add("meanId",meansId);
	sPacket.data.add("actClass","-1");
	sPacket.data.add("regCode","");
	//==================================================
	core.ajax.sendPacketHtml(sPacket,doCheckMean,true);
	sPacket = null;
}

function doCheckMean(data){
	var sdata = data.split("~");
	var retCode = sdata[0];
	var retMsg = sdata[1];
	if(retCode != 0){
		showDialog(retMsg,0);
		return false;
	}
	var sPacket = null;
	sPacket = new AJAXPacket("gAssiFeeCheckFee.jsp","���Ժ�......");
	
	sPacket.data.add("loginNo","");
	sPacket.data.add("iPhoneNo","<%=svcNum%>");
	sPacket.data.add("fee_code","");
	sPacket.data.add("fee_name","");
	sPacket.data.add("meansId",meansId);
	sPacket.data.add("act_id","");
	//==================================================
	core.ajax.sendPacketHtml(sPacket,doResCat,true);
	sPacket = null;
	
}

function doResCat(data){
	var sdata = data.split("~");
	var retCode = sdata[0];
	var retMsg = sdata[1];
	if(retCode != 0){
		showDialog(retMsg,0);
		return false;
	}
	
	var sPacket = new AJAXPacket("getMeansDetail.jsp","���Ժ�......");
	sPacket.data.add("ID_NO","<%=idNo%>");
	sPacket.data.add("PHONE_NO","<%=svcNum%>");
	sPacket.data.add("REGION_CODE","<%=region_id%>");
	sPacket.data.add("ACT_ID","<%=actId%>");
	sPacket.data.add("MEANS_ID",meansId);
	sPacket.data.add("CUST_GROUP_ID","<%=custGrpId%>");
	sPacket.data.add("BRAND_ID","<%=brandId%>");
	sPacket.data.add("GROUP_ID","<%=group_id%>");
	sPacket.data.add("MODE_CODE","<%=mode_code%>");
	core.ajax.sendPacket(sPacket,doserviceGetMeans);
	sPacket = null;
}

function doserviceGetMeans(packet){
	
	var RETURN_CODE = packet.data.findValueByName("RETURN_CODE");
	var RETURN_MSG = packet.data.findValueByName("RETURN_MSG");
	var DETAIL_MSG = packet.data.findValueByName("DETAIL_MSG");

	if(RETURN_CODE!="0"){
		showDialog("���:"+RETURN_MSG+"|ԭ��:"+DETAIL_MSG,0,'retT=window.location.reload(true);retF=cancelAction();closeFunc=window.location.reload(true)');
		return false;
	}	
	var meansJsonStr=packet.data.findValueByName("meansJsonStr");
	var flag=packet.data.findValueByName("flag");
	var cashInfo=packet.data.findValueByName("cashInfo");
	var specialfunds=packet.data.findValueByName("specialfunds");
	var assispecialfunds=packet.data.findValueByName("assispecialfunds");
	var systemPay =packet.data.findValueByName("systemPay");
	var agreementFEE =packet.data.findValueByName("agreementFEE");
	var bankPayFee=packet.data.findValueByName("bankPayFee");
	var giftInfo=packet.data.findValueByName("giftInfo");
	var isPhone =packet.data.findValueByName("isPhone");
	var clientInfo=packet.data.findValueByName("clientInfo");
	var priceCard=packet.data.findValueByName("priceCard");
	var ssfeeInfo =packet.data.findValueByName("ssfeeInfo");
	var assiFeeInfo =packet.data.findValueByName("assiFeeInfo");
	var spInfo=packet.data.findValueByName("spInfo");
	var subScore=packet.data.findValueByName("subScore");
	var reScore =packet.data.findValueByName("reScore");
	var netcode =packet.data.findValueByName("netcode");
	var orderTypeInfo =packet.data.findValueByName("orderTypeInfo");
	var specialallfunds =packet.data.findValueByName("specialallfunds");
	var allFee=packet.data.findValueByName("allFee");
	var gAddFee =packet.data.findValueByName("gAddFee");
	var gWlan =packet.data.findValueByName("gWlan");
	var gData =packet.data.findValueByName("gData");
	var gRes=packet.data.findValueByName("gRes");
	var bindingFeeInfo=packet.data.findValueByName("bindingFeeInfo");
	var memNo =packet.data.findValueByName("memNo");
	var memFee =packet.data.findValueByName("memFee");
	var memAddFee =packet.data.findValueByName("memAddFee");
	var memFund =packet.data.findValueByName("memFund");
	var memSysFee =packet.data.findValueByName("memSysFee");
	//modify 2014��3��10��9:15:55
	var familyLowType =packet.data.findValueByName("familyLowType");
	var broadDiscountPay =packet.data.findValueByName("broadDiscountPay");
	var html =packet.data.findValueByName("html");
	var contracttime =packet.data.findValueByName("contracttime");
	var templet =packet.data.findValueByName("templet");
	var giftMoney =packet.data.findValueByName("giftmoney");
	$("#global_json").val(meansJsonStr);
	$("#global_flag").val(flag);
	$("#global_cashInfo").val(cashInfo);
	$("#global_specialfunds").val(specialfunds);
	$("#global_assispecialfunds").val(assispecialfunds);
	$("#global_systemPay_h").val(systemPay);
	$("#global_agreementfee").val(agreementFEE);
	$("#global_bankPayFee").val(bankPayFee);
	$("#global_giftInfo").val(giftInfo);
	$("#global_phoneCredence").val(isPhone);
	$("#global_clientInfo").val(clientInfo);
	$("#global_priceCard").val(priceCard);
	$("#global_ssfeeInfo").val(ssfeeInfo);
	$("#global_assiFeeInfo").val(assiFeeInfo);
	$("#global_spInfo").val(spInfo);
	$("#global_subScore").val(subScore);
	$("#global_reScore_h").val(reScore);
	$("#global_netcode").val(netcode);
	$("#global_orderType").val(orderTypeInfo);
	$("#global_specialallfunds").val(specialallfunds);
	$("#global_allFee").val(allFee);
	$("#global_gAddFee").val(gAddFee);
	$("#global_gWlan").val(gWlan);
	$("#global_gData").val(gData);
	$("#global_gRes").val(gRes);
	$("#global_bindingFeeInfo").val(bindingFeeInfo);
	$("#global_memNo").val(memNo);
	$("#global_memFee").val(memFee);
	$("#global_memAddFee").val(memAddFee);
	$("#global_memFund").val(memFund);
	$("#global_memSysFee").val(memSysFee);
	//modify 2014-3-10 17:09:48
	$("#global_familyLowType").val(familyLowType);
	$("#global_broadDiscountPay").val(broadDiscountPay);
	$("#meansDetail"+meansId).html(html);//��Ӫ����ʽ�±�����Ԫ��
	$("#global_contracttime").val(contracttime);
	$("#global_templet").val(templet); 	
	$("#global_GiftMoney").val(giftMoney); 
	changeMeansDetail();
		
}

function changeMeansDetail(){

	//set meansFalg
	meansFalg = $("#global_flag").val(); 
	if('undefined'==meansFalg){
		meansFalg = "";
	}
	
	//չ��ҳ��
	var disValue= $("#ruleDetail"+meansId).css("display");

	if(disValue=="none"){
		 $("#pic"+meansId).click();
	}
	//����ȫ�ֱ���
	means = meansId;
	prods = new Array();
	var meansJson = $("#global_json").val();
	var json = eval('(' + HtmlDecode(meansJson) + ')');
	if(""!=meansJson)
	meansSelectedJson = sitechJson(json);
	var moneyInfo = instanceTemplate["MONEY_INFO"]();
	//�����ֶζ�Ӧ��tab��
	enableTable(obj,meansId);
	//��������ֶ�
	clearChooseRule(meansId);
	//�������
	clearJsonXml();
	//���ť
	enableButton(meansId);
	//����ǰ��
	var pay_moneycould = calcMoney(meansFalg);
	
	newBusiInfos(means);
	document.getElementById("pay_moneycould").value=parseFloat(pay_moneycould);
	document.getElementById("pay_moneycouldhid").value=parseFloat(pay_moneycould);
}

function calcMoney(meansFalg){
	//Ӧ�����
	var pay_moneycould=0;
	if("1"==meansFalg.charAt(0)){
		var pay_moneycoulds=meansSelectedJson.find("H01.PAY_MONEY").value();
		pay_moneycould=parseFloat(pay_moneycoulds);
		//alert("��"+pay_moneycould);
	}
	if("1"==meansFalg.charAt(1)){
		var elenum = meansSelectedJson.find("H02.SPECIAL_FUNDS_LIST").returnChildSum ();
		for(var i=0;i<elenum;i++){  
		var pay_moneycoulds=meansSelectedJson.find("H02.SPECIAL_FUNDS_LIST.SPECIAL_FUNDS_INFO["+i+"].PAY_MONEY").value();
		var payment_type=meansSelectedJson.find("H02.SPECIAL_FUNDS_LIST.SPECIAL_FUNDS_INFO["+i+"].PAYMENT_TYPE").value();
		//add zhangxy20170417 payment_type != "6" && for ����ħ�ٺ���ǩ
		alert("zhagnxy 1 payment_type��"+payment_type+" pay_moneycoulds:"+pay_moneycoulds);
		if(payment_type != "6" && payment_type != "2" && payment_type != "5" && "<%=act_type%>"!="15" && "<%=act_type%>"!="25" && "<%=act_type%>"!="77"  && "<%=act_type%>"!="78"){
			alert("zhagnxy 1 payment_type��"+payment_type+" pay_moneycoulds:"+pay_moneycoulds);

			if(payment_type != "4"|| "<%=act_type%>"!="121")
			{
				alert("zhagnxy 1 payment_type��"+payment_type+" pay_moneycoulds:"+pay_moneycoulds);

				pay_moneycould+=parseFloat(pay_moneycoulds);
			}
		}
		alert("ר�"+pay_moneycould);
		}
	}
	if("1"==meansFalg.charAt(2)){
		var elenum = meansSelectedJson.find("H03.SPECIAL_FUNDS_LIST").returnChildSum ();
		for(var i=0;i<elenum;i++){  
		var pay_moneycoulds=meansSelectedJson.find("H03.SPECIAL_FUNDS_LIST.SPECIAL_FUNDS_INFO["+i+"].PAY_MONEY").value();
		pay_moneycould+=parseFloat(pay_moneycoulds);
		//alert("����ר�"+pay_moneycould);
		}
	}
	if("1"==meansFalg.charAt(8)){
		var pay_moneycoulds = "0";
		var temp_flag="";
		if("1"==meansFalg.charAt(53)){
			 temp_flag=meansSelectedJson.find("H54.TEMPLET_TYPE").value()
		}
		
		if(("<%=act_type%>"=="140"&&temp_flag=="0")||("<%=act_type%>"=="141"&&temp_flag=="0")){
			pay_moneycoulds=meansSelectedJson.find("H09.RESOURCE_MONEY").value();
		}else if("<%=act_type%>"=="140"&&temp_flag=="1"){
			pay_moneycoulds=meansSelectedJson.find("H09.RESOURCE_FEE").value();
		}else{
			pay_moneycoulds=meansSelectedJson.find("H09.RESOURCE_FEE").value();
		}
		var busiType = meansSelectedJson.find("H09.RESOURCE_BUYTYPE").value();
		if("4" == busiType ){
			pay_moneycoulds = 0;
		}
		pay_moneycould+=parseFloat(pay_moneycoulds);
		//alert("�����"+pay_moneycould);
	}
	//ȫ��ר��
	if("1"==meansFalg.charAt(33)){
		var elenum = meansSelectedJson.find("H34.ALL_SPECIAL_FUNDS_LIST").returnChildSum();
		for(var i=0;i<elenum;i++){
			var pay_moneycoulds=meansSelectedJson.find("H34.ALL_SPECIAL_FUNDS_LIST.ALL_SPECIAL_FUNDS_INFO["+i+"].PAY_MONEY").value();
			var payment_type=meansSelectedJson.find("H34.ALL_SPECIAL_FUNDS_LIST.ALL_SPECIAL_FUNDS_INFO["+i+"].PAYMENT_TYPE").value();
			if(payment_type != "2"){
				pay_moneycould+=parseFloat(pay_moneycoulds);
			}
		}
	}
	
	if("<%=act_type%>"=="77"|| "<%=act_type%>"=="78"){
		pay_moneycould ="0";
	}
	
	return pay_moneycould;
}

function enableTable(obj,meansId){

//������ֲ�����
	var buttonName = "button"+meansId;
	var textName ="text"+meansId;
	if(obj.attr("checked")){
		var btns = document.getElementsByName(buttonName);
		var txts = document.getElementsByName(textName);
		if('undefined'!=btns){
			for(var i=0;i<btns.length;i++){//���ť
				btns[i].disabled="";//��Ϊȫ������ѡ��ť
				if(btns[i].v_permissions=="Y"){
					btns[i].disabled="";
				}else if(btns[i].v_isReadonly=="0"){
					btns[i].disabled="";
				}
			}
		}
		if('undefined'!=txts){
			for(var i=0;i<txts.length;i++){//�����ı���
				if(txts[i].v_permissions=="Y")//�����Ӫ���޸�Ȩ��
					txts[i].disabled="";
				else if(txts[i].v_isReadonly=="0")//�����CRM�޸�Ȩ��
					txts[i].disabled="";
			}
		}
	}
}

function clearChooseRule(selected){
	var rules = document.getElementsByName("rule");//���л����
	for(var i=0;i<rules.length;i++){
		var unChooseMeansID = rules[i].value;
		if(unChooseMeansID!=selected){
			var txtname  = "text"+unChooseMeansID;
			var giftText = document.getElementsByName(txtname);//�ı������
			if('undefined' != giftText){
				for(var j=0;j<giftText.length;j++){
					if(giftText[j].type!="hidden"){//�����������
							giftText[j].disabled="disabled";
							//���css��ʽ
							giftText[j].value="0000";
							validateElement(giftText[j]);
							giftText[j].value="";
							var idName = giftText[j].id+"hidden";
							if(document.getElementById(idName)){
								var oldVal = document.getElementById(idName).value;
								giftText[j].value=oldVal;
							}
							giftText[j].removeAttribute("class");
					}
				}
			}
			var bntname  = "button"+unChooseMeansID;
			var buttons = document.getElementsByName(bntname);//�ı������
			if('undefined' != buttons){
				for(var j=0;j<buttons.length;j++){
					buttons[j].disabled="disabled";
				}
			}
		}
	}
}

//�����ύ��ť�ļ����ʧЧ
function enableButton(meansID){
	$("#btnSave").removeAttr("disabled"); 
}

var isScoreCheck = false;
//У���û������Ƿ񹻲μӵ�ǰӪ���ֶΡ�
//���򷵻�true����֮��false
function checkUserScore(){
	var userScore = $("#userAllScore").val();
	var saleJsonObj =meansSelectedJson;
	var A09 = saleJsonObj.find("A09").toJson();
	if(A09!='null'){
		 ajaxGetUserScore();
		 //isScoreCheck= true;//����ע����
		return isScoreCheck;
	}
	return true;
}

 //����У��
 function ajaxGetUserScore(){
 	 var packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s1147/f1147_ajax_getUserScore.jsp","���Ե�......");
		  packet.data.add("idNo" ,"<%=idNo==null?"":idNo%>");//�û�ID
		  packet.data.add("userScore" ,$("#scoreValue"+means).val());//���ѻ���
		  packet.data.add("brandId" ,"<%=brandId==null?"":brandId%>");//
		  packet.data.add("svcNum" ,"<%=svcNum==null?"":svcNum%>");//�û�ID
		  packet.data.add("routerKey" ,"<%=routerKey==null?"":routerKey%>");//�û�ID
		  packet.data.add("routerValue" ,"<%=routerValue==null?"":routerValue%>");//�û�ID
		  core.ajax.sendPacket(packet,doSubmitUserScore);
		  packet =null;
 }
 
  function doSubmitUserScore(packet){
 	var retCode = packet.data.findValueByName("retCode"); 
	var retMsg = packet.data.findValueByName("retMsg"); 
	var detailMsg  = packet.data.findValueByName("detailMsg"); 
  	if(retCode == "0"){
  		isScoreCheck = true; 
  	}else{	
   			showDialog("�����ֲ�����ʾ��"+retMsg,0,'detail='+detailMsg);
   		}
 }
 
 /********У�鷽������******/
//�Դ�Ԥ���У��,��֤�Ƿ�Ƿ��
function checkPureMoney(){
	var saleJsonObj = meansSelectedJson;
	var A00 = saleJsonObj.find("A00").toJson();
	if(A00!='null'){
		var pureFlag = saleJsonObj.find("A00.IS_PURE").value();
		if("Y"==pureFlag){//����Ǵ�Ԥ��
			ajaxGetUserAllOweFee();
		}
	}
	
	var oweFee = $("#allOweFee").val();
	if(""==oweFee)oweFee= 0;
	if(oweFee>0){
		 return true;
	} 
	return false;
}

 //У���û��ܻ�����Ϣ
 function ajaxGetUserAllOweFee(){
 	 var packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s1147/f1147_ajax_getUserOweFee.jsp","���Ե�......");
		  packet.data.add("idNo" ,"<%=idNo==null?"":idNo%>");//�û�ID
		  packet.data.add("routerKey" ,"<%=routerKey==null?"":routerKey%>");//�û�ID
		  packet.data.add("routerValue" ,"<%=routerValue==null?"":routerValue%>");//�û�ID
		  core.ajax.sendPacket(packet,doAjaxGetUserAllOweFee);
		  packet =null;
 }
 
  
  function doAjaxGetUserAllOweFee(packet){
  	var retCode = packet.data.findValueByName("retCode"); 
  	var retMsg = packet.data.findValueByName("retMsg"); 
	var detailMsg  = packet.data.findValueByName("detailMsg"); 
  	if(retCode == "000000"||retCode=="0"){
  		var allOweFee = packet.data.findValueByName("allOweFee"); 
  		$("#allOweFee").val(allOweFee);
  	}else{	
   			showDialog(retMsg,0,'detail='+detailMsg);
   		}
  }
  
   //�Ƚ��������ڵĴ�С�����_date1>_date2
 function comparedDate(_date1,_date2){
 
 		_date1 = _date1.replace(new RegExp("-","gm"),"");
		_date2 = _date2.replace(new RegExp("-","gm"),"");
		
 		var _date1 = _date1.substring(0,8);
		var _date2 = _date2.substring(0,8);
		return parseInt(_date1)>parseInt(_date2);
 
 }
 
 //У���û����ɷѽ���Ƿ񹻲μӵ�ǰӪ���ֶΡ�
//���򷵻�true����֮��false
function checkPure(){
	var oweFee = $("#allOweFee").val();
	if(""==oweFee)oweFee = 0;
	if(oweFee>0){//�����Ƿ�Ѳ�У��
		var saleJsonObj = meansSelectedJson;
		var A00 = saleJsonObj.find("A00").toJson();
		if(A00!='null'){
			var pureFlag = saleJsonObj.find("A00.IS_PURE").value();
			var _preMoney = saleJsonObj.find("A00.PAY_MONEY").value();//Ĭ��Ԥ����
			var _inMoney = $("A00Fee"+means).val();//_inMoney :�ѽɷ���
			if("Y"==pureFlag){//����Ǵ�Ԥ��
				return _inMoney >=(_preMoney+getPrueMoney());
			}
		}
	}
	return true;
}

//Ԥ���ʱ�������˻��ɷѻ�ȡ�����˻���Ϣ
function checkPayForOther(){
	var saleJsonObj = meansSelectedJson;
	var A00 = saleJsonObj.find("A00").toJson();
	if('null'!= A00){
		var payType = saleJsonObj.find("A00.ACCOUNT_TYPE").value();
		var acctNo = saleJsonObj.find("A00.ACCOUNT_NO").toJson();
		if((payType =="2")&&('null'==acctNo)){
			openDivWin("<%=request.getContextPath()%>/npage/s1147/f1147_getOtherAcct.jsp?element=A00&phoneNo=<%=svcNum%>&idNo=<%=idNo%>&routerKey=<%=routerKey%>&routerValue=<%=routerValue%>", "��ѯ�����˻���Ϣ", "600","300");
			return false;
		}
		return true;
	}
	return true;
}

//����Ʒ����ҳ�淽�����Ƕ����ݿ⶯̬����js�����ľ���ʵ��
 //args :���ݿ����õĲ���ֵ,�˴�û��ʹ�ã�������Ʒ�ܴ�giftInfo
 function popGoodsSelect(args){
 	if(giftMsg!="-1"){
 		showDialog('����ѡ�����Ʒ?',3,'retT=chooseA04();retF=null;closeFunc=null');
 	}else{
 		chooseA04();
 	}
 }
 
  
 //У���û�ϲ��ֵ
function checkHappyNode(){
	var saleJsonObj = meansSelectedJson;
	var A08 = saleJsonObj.find("A08").toJson();
	if('null'!= A08){
			ajaxGetUserHappyNode();
			var hapVal = $("#happayNode"+means).text();
		return (happyNodeValue != "0");
	}
	return true;
}

 //��ȡ�û�ϲ��ֵ
 function ajaxGetUserHappyNode(){
 	 var packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s1147/f1147_ajax_getUserHappyNode.jsp","���Ե�......");
		  packet.data.add("idNo" ,"<%=idNo==null?"":idNo%>");//�û�ID
		  packet.data.add("custId" ,"<%=custId==null?"":custId%>");//�û�ID
		  packet.data.add("svcNum" ,"<%=svcNum==null?"":svcNum%>");//�û�ID
		  packet.data.add("routerKey" ,"<%=routerKey==null?"":routerKey%>");//�û�ID
		  packet.data.add("routerValue" ,"<%=routerValue==null?"":routerValue%>");//�û�ID
		  core.ajax.sendPacket(packet,doSubmitHappyNode);
		  packet =null;
 }
 
 function doSubmitHappyNode(packet){
 	var retCode = packet.data.findValueByName("retCode"); 
	var retMsg = packet.data.findValueByName("retMsg"); 
	var detailMsg  = packet.data.findValueByName("detailMsg"); 
  	if(retCode == "0"){
  		happyNodeValue = packet.data.findValueByName("happyNode"); 
  		var name = "happayNode"+means;
		document.getElementById(name).innerHTML = happyNodeValue;
  	}else{
   			showDialog("��ϲ�������ʾ��"+retMsg,0,'detail='+detailMsg);
   		}
 }
 
  //�ͷſ���Դ,��Ӫ����ʽ֮���л�������;�˳�ʱ����
   //�ɹ����������øú���
  function releasCardResource(){
 
    if((feeCardArr == undefined)||(feeCardArr.length < 1)){
	 		return ;
	 	}
  	var F1Arr = new Array();
  	var F2Arr = new Array();
  	
  	if(feeCardArr.length>0){
  		for(var i=0;i<feeCardArr.length;i++){
  			if("F1"==feeCardArr[i][2].substring(0,2)){
  				F1Arr.push(feeCardArr[i][0]);
  			}else if("F2"==feeCardArr[i][2].substring(0,2)){
  				F2Arr.push(feeCardArr[i][0]);
  			}
  		}
  	}
  	ajaxReleasCardResource(F1Arr,"F1");
  	ajaxReleasCardResource(F2Arr,"F2");
  }
  
  //�ͷſ���Դ
 function ajaxReleasCardResource(cards,resCode){
	 if((cards == undefined)||(cards.length < 1)){
	 		return ;
	 	}
	 	
 	var packet = new AJAXPacket("f1147_ajax_do_impropriate_release.jsp");
        packet.data.add("res_opr", "1");//0Ԥռ 1�ͷ�
        packet.data.add("cards",cards);
        packet.data.add("resCode",resCode);
		core.ajax.sendPacket(packet,function(packet){
			
		});
		packet =null;
 }
 
  //��json�����������
/**��ȡ��http://lab.msdn.microsoft.com/annotations/htmldecode.js */
function HtmlDecode(s) 
{ 
   var out = ""; 
   if (s==null || s.indexOf('&')== -1) return s; 
   var l = s.length; 
   for (var i=0; i<l; i++) 
   { 
         var ch = s.charAt(i); 
         if (ch == '&') 
         { 
               var semicolonIndex = s.indexOf(';', i+1); 
         if (semicolonIndex > 0) 
         { 
                     var entity = s.substring(i + 1, semicolonIndex); 
                     if (entity.length > 1 && entity.charAt(0) == '#') 
                     { 
                       if (entity.charAt(1) == 'x' || entity.charAt(1) == 'X') 
                              ch = String.fromCharCode(eval('0'+entity.substring(1))); 
                        else 
                              ch = String.fromCharCode(eval(entity.substring(1))); 
                     } 
                 else 
                   { 
                     switch (entity) 
                       { 
                          case 'quot': ch = String.fromCharCode(0x0022); break; 
                          case 'amp': ch = String.fromCharCode(0x0026); break; 
                          case 'lt': ch = String.fromCharCode(0x003c); break; 
                          case 'gt': ch = String.fromCharCode(0x003e); break; 
                          case 'nbsp': ch = String.fromCharCode(0x00a0); break; 
                          default: ch = ''; break; 
                       } 
                     } 
                     i = semicolonIndex; 
               } 
         } 
         out += ch; 
   } 
   return out; 
} 
 
//Ԫת�ִ���
function transMoney2Fen(s){
	try{
		return parseFloat(s)*100;
	}catch(e){
		return parseFloat("0");
	}
}
 
//����У��
 function checkUserLuck(){
 		 var packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s1147/f1147_ajax_getUserLuckInfo.jsp","���Ե�......");
		  packet.data.add("idNo" ,"<%=idNo==null?"":idNo%>");//�û�ID
		  packet.data.add("routerKey" ,"<%=routerKey==null?"":routerKey%>");//
		  packet.data.add("routerValue" ,"<%=routerValue==null?"":routerValue%>");//
		  core.ajax.sendPacket(packet,function(packet){
		  	var retCode = packet.data.findValueByName("retCode"); 
			var retMsg = packet.data.findValueByName("retMsg"); 
			var detailMsg  = packet.data.findValueByName("detailMsg"); 
		  	if(retCode == "0"){
		  		var luckValue  = packet.data.findValueByName("luckValue"); 
		  		if(parseInt(luckValue)<=0){
		  			showDialog("�����ֲ�����ʾ���û�����ֵ����",0,'detail=�û�����ֵ����,���ɰ�����Ӫ���');
		  		}else{
		  			$("#luckValue"+means).val(luckValue);
		  			isCheckLuck = true;
		  		}
		  	}else{	
		   			showDialog("�����ֲ�����ʾ��"+retMsg,0,'detail='+detailMsg);
		   		}
		  });
		  packet =null;
 }
 
 //У���û�Ƿ����Ϣ
 function ajaxGetUserAllScore(){
 	 var packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s1147/f1147_ajax_getUserOriginalScore.jsp","���Ե�......");
		  packet.data.add("idNo" ,"<%=idNo==null?"":idNo%>");//�û�ID
		  packet.data.add("routerKey" ,"<%=routerKey==null?"":routerKey%>");//�û�ID
		  packet.data.add("routerValue" ,"<%=routerValue==null?"":routerValue%>");//�û�ID
		  core.ajax.sendPacket(packet,doAjaxGetUserAllScore);
		  packet =null;
 }
 
 
  function doAjaxGetUserAllScore(packet){
  	var retMsg = packet.data.findValueByName("retMsg"); 
  	var retCode = packet.data.findValueByName("retCode"); 
	var detailMsg  = packet.data.findValueByName("detailMsg"); 
  	if(retCode == "000000"||retCode=="0"){
  		var userAllScore = packet.data.findValueByName("userAllScore"); 
  		$("#userAllScore").val(userAllScore);
  	}else{	
   			showDialog(retMsg,0,'detail='+detailMsg);
   		}
  }
 
 
 /*****************************/
/*
*��ȿ�¡��ҳ����ֵ��Ʒ����
*������ݶ�ʧ����
*/
function myClone(myObj) {
        if (typeof(myObj) != 'object') return myObj;
        if (myObj == null) return myObj;
        var myNewObj = [];
        for (var i in myObj) {
            if (myObj.hasOwnProperty(i)) {
                myNewObj[i] = myClone(myObj[i]);
            } else continue
        }
       // myNewObj.toJson();
        return myNewObj;
    }
 
</script>