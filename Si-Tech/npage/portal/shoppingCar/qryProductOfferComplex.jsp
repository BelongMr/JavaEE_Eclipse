 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GB2312"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ taglib uri="/WEB-INF/wtc.tld" prefix="wtc" %>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UType"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UtypeUtil"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UElement"%>
 
<%
	System.out.println("----����Ʒѡ��-------qryProductOfferComplex.jsp--------------");
	String orgCode = (String)session.getAttribute("orgCode");
	String regionCode = orgCode.substring(0,2);
	String band_id = WtcUtil.repNull(request.getParameter("band_id"));//Ʒ��ID
	String phoneNo = WtcUtil.repNull(request.getParameter("phoneNo"));//
	String workNo = (String) session.getAttribute("workNo");
	String groupId=(String)session.getAttribute("groupId");//Ա�������ڵ�
	
	String [][] goodTypeInfo=new String[1][8];
	String fuCardSql = " select count(1)  from dchngroupmsg   where group_id='"+groupId+"'   and class_code in (select msg.class_code  from schnclassmsg msg, schnclassinfo info where msg.class_code = info.class_code and info.parent_class_code = 'fail')";
	System.out.println("fuCardSql--"+fuCardSql);
	String opName = "����Ʒѡ��";
	String opCode = WtcUtil.repNull(request.getParameter("opCode"));// opcode ������ 
	String startOpCode = WtcUtil.repNull(request.getParameter("startOpCode"));// opcode ������ 
	String chooseRadio = WtcUtil.repNull(request.getParameter("chooseRadio"));
	
	if(startOpCode == null || "".equals(startOpCode)){
		startOpCode = opCode;
	}
	
	System.out.println("-------------------opCode-------------------"+opCode);
	String arrProdFunc[] = {"g784","g785","m028","m094"};
	String prodFuncArr[] = {"N","N","N","N"};
	ArrayList arrSession = (ArrayList)session.getAttribute("allArr");
	String[][] temfavStr=(String[][])arrSession.get(1);
	String[] favStr=new String[temfavStr.length];
	for(int i=0;i<favStr.length;i++){
		favStr[i]=temfavStr[i][1].trim();
		for(int j = 0; j < arrProdFunc.length; j++){
		
			if(arrProdFunc[j].equals(favStr[i])){
				prodFuncArr[j] = "Y";
			}
		}
	}
	for(int j=0;j<prodFuncArr.length;j++){
		System.out.println("------- ningtn prodFuncArr[j]" + prodFuncArr[j]);
	}
%>

 		<wtc:pubselect name="sPubSelect" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=fuCardSql%></wtc:sql>
 	  </wtc:pubselect>
	 <wtc:array id="result_Card" scope="end"/>
	 	
<%
String cardLimit = "0";
if(result_Card.length>0&&result_Card[0][0]!=null){
	cardLimit = result_Card[0][0];
}

%>	 	
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>����Ʒѡ��</title>
<style>
	html,
	body
	{
		overflow-x:hidden
	}
</style>
<link href="<%=request.getContextPath()%>/nresources/default/css/spCar.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/nresources/default/css/products.css" rel="stylesheet"type="text/css">
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/njs/extend/mztree/stTree.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/si/validate_class.js"></script>
<script language="javascript" type="text/javascript">
var flag;
var goodKind = ""; //�����������
var mf_flag = "0"; // ����ղؼ�tr ��־
var mf_flag1 = "1"; // ����ղؼ�У��ɹ� ��־

$(document).ready(function () {
	addSmCode();
	if("<%=loginNoClassCode%>"!="200"){
		$("#smCode").val("24");
	}
	setOfferType();
	if("<%=loginNoClassCode%>"!="200"){
		$("#offer_att_type").val("Yn70");
	}
		addRegCode();
		queryByNomal();
		var band_id = "<%=band_id%>";
		if(band_id!="")
		{
			flag=true;//��ʾ���ص�����¼
			$("#smCode").val("<%=band_id%>");
			$("#smCode").attr("disabled",true);
			myFavorite();
		  hotOffer();
		}else{ //��ʾ�ӹ��ﳵҳ�����
			flag=false;//��ʾ���ض�����¼
		  //myFavorite();
		  //hotOffer();
		}
		if("1"==$("#isse276",window.opener.parent.parent.document).val()){
			//document.frmMain.offerCode.value=$("#se276ziFei",window.opener.parent.parent.document).val();
			//productOfferQryByAttr();
			//������ѡ���������Ϣ��ѯ
			var offerCode = document.frmMain.offerCode.value;//����Ʒ����
			var offerName ="";
			var offerType ="";
			var offerAttrSeq = "";//����Ʒ���Ա�ʶ 
			var custGroupId = "";//�ͻ�Ⱥ��ʶ
			var channelSegment="";//�������ͱ�ʶ
			var group_id="";
			var band_id= "";
			var offer_att_type="";
			var retQ08_flag=retQ08Flag();
			if(retQ08_flag)
			{
				retQ08_flag="1";
			}else
			{
				retQ08_flag="0";
			}
			var packet = new AJAXPacket("ajax_productOfferQryByAttr.jsp","���Ժ�...");
			packet.data.add("offerCode" ,$("#se276ziFei",window.opener.parent.parent.document).val());
			packet.data.add("offerName" ,offerName);
			packet.data.add("offerType" ,offerType);
			packet.data.add("offerAttrSeq" ,offerAttrSeq);
			packet.data.add("custGroupId" ,custGroupId);
			packet.data.add("channelSegment" ,channelSegment);
			packet.data.add("group_id" ,group_id);
			packet.data.add("band_id" ,band_id);
			packet.data.add("offer_att_type" ,offer_att_type);
			packet.data.add("goodFlag" ,"1");
			packet.data.add("retQ08_flag" ,retQ08_flag);
			packet.data.add("opCode" ,"<%=opCode%>");
			core.ajax.sendPacket(packet,doProductOfferQryByAttr);
			packet =null;
			clickTr2();
			cfm();
			
		}
		 
});

function retQ08Flag(){
		 var query08Flag = false;
			<%
			System.out.println("======================" + cardLimit);
			if(Integer.parseInt(cardLimit)  > 0 && !opCode.equals("4977") && !opCode.equals("e887")){%>//��ʾ��ʱ����丳ֵ
				query08Flag = document.all.query08.checked;
			<%}%>
			return query08Flag;
}
//��ѡ�������Ʒ��Ϣ���ص����ﳵ
function cfm()
{	
	var productOfferTab = g("productOfferList");
	var rowNum = productOfferTab.rows.length;
	if(rowNum<=1)
	{
		rdShowMessageDialog("����ѡ������Ʒ!");
	}
	else
	{
		/*
		var resultList = new Array();
		
		for(var n=1;n<rowNum;n++)
		{
			var tempArray = new Array();
			for(var m=0;m<=3;m++)
			{
				tempArray[m] = productOfferTab.rows[n].cells[m].innerHTML;
			}
			resultList.push(tempArray);
		}
		*/
		var resultList
		var tabID="productOfferList";
		var lineV="5";
		var lineHid ="4";
		
		resultList = getTableData(tabID,lineV,lineHid);
		//alert(resultList);
		//window.returnValue = resultList;
		opener.resultProcess(resultList,'<%=opCode%>');
		if("1"==$("#isse276",window.opener.parent.parent.document).val()){
			opener.custOrderC();
		}
		window.close();
	}
}

//ȡ�÷�������ID(servBusID)
function getServBusId(offer_id){
			var packet = new AJAXPacket("getServBusId.jsp","���Ժ�...");
			packet.data.add("offer_id" ,offer_id);
			core.ajax.sendPacket(packet,getMebAttr);
	}
function getMebAttr(packet){
	var backArrMsg =packet.data.findValueByName("backArrMsg");
	var retMsg=retMsg =packet.data.findValueByName("retMsg");
	if(backArrMsg==null || backArrMsg==""){
			backArrMsg="";
		}
	document.frmMain.servBusId.value=backArrMsg;
	document.frmMain.retMsg.value=retMsg;
	}
//��ѯ��������Ʒ��Ϣ(������)
function productOfferQryByAttr()
{
	
		if(document.all.offerCode.value!=""){
		 	if(!forInt(document.all.offerCode)) return false;
		}
		
		if (productOfferQueryList.style.display = "none")
		{
			productOfferQueryList.style.display = "block";
		//������ѡ���������Ϣ��ѯ
		var offerCode = document.frmMain.offerCode.value;//����Ʒ����
		var offerName =document.frmMain.offerName.value;//����Ʒ���� 
		var offerType =document.frmMain.offerType.value;//����Ʒ����
		var offerAttrSeq = "";//����Ʒ���Ա�ʶ 
		var custGroupId = "";//�ͻ�Ⱥ��ʶ
		var channelSegment="";//�������ͱ�ʶ
		var group_id=document.frmMain.receiveRegion.value;//������
		var band_id= document.frmMain.smCode.value;//Ʒ�Ʊ�ʶ
		var offer_att_type=document.all.offer_att_type.value;//����Ʒ�����ʶ
		var retQ08_flag=retQ08Flag();
		if(retQ08_flag)
		{
			retQ08_flag="1";
		}else
		{
			retQ08_flag="0";
		}
		var packet = new AJAXPacket("ajax_productOfferQryByAttr.jsp","���Ժ�...");
		packet.data.add("offerCode" ,offerCode);
		packet.data.add("offerName" ,offerName);
		packet.data.add("offerType" ,offerType);
		packet.data.add("offerAttrSeq" ,offerAttrSeq);
		packet.data.add("custGroupId" ,custGroupId);
		packet.data.add("channelSegment" ,channelSegment);
		packet.data.add("group_id" ,group_id);
		packet.data.add("band_id" ,band_id);
		packet.data.add("offer_att_type" ,offer_att_type);
		packet.data.add("goodFlag" ,"1");
		packet.data.add("retQ08_flag" ,retQ08_flag);
		packet.data.add("opCode" ,"<%=opCode%>");
		core.ajax.sendPacket(packet,doProductOfferQryByAttr);
		packet =null;
		}
}

//�ص�����
function doProductOfferQryByAttr(packet)
{
	var goodNo = document.frmMain.goodNo.value.trim();
	var goodType= document.frmMain.goodNoBlind.value;
					
  var selectValue = document.frmMain.selectValue.value;//��ѯ��ʽ��value
	var qryRetCode = packet.data.findValueByName("retCode"); 
	var qryRetMsg = packet.data.findValueByName("retMsg"); 
	var retResult = packet.data.findValueByName("retResult");
	document.getElementById("productOfferQueryList").style.display="";
	document.getElementById("queryOfferList").style.display="";
	var serv_bus_id =document.frmMain.servBusId.value;//ȡ�÷�������ID��servBusId
	//alert("serv_bus_id|"+serv_bus_id);
	var tableId=g("queryOfferList");
	var rowNum = tableId.rows.length;
	if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
	if(retResult==null||retResult==""){
		rdShowMessageDialog("û�в�ѯ�������������3��"+qryRetMsg);
		}else{
				if(qryRetCode==0){
				for(var i=0;i<retResult.length;i++){
					var arrTdCon=new Array(retResult[i][0],retResult[i][1],retResult[i][6],"<div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004|"+selectValue+"</span>");
					//var arrTdCon=new Array(retResult[i][0],"<span id='td_"+retResult[i][0]+"'>"+retResult[i][1]+"</span>",retResult[i][6],"<div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|20018|20004|"+selectValue+"</span>");
					//addTrOver("queryOfferList","1",arrTdCon,1,"f5f5f5");
					$("#queryOfferList").append("<tr id='queryOfferList"+"_tr_td"+i+"' onclick='clickTr()' style='cursor:pointer;'><td>"+retResult[i][0]+"</td><td id='"+codeChg("queryOfferList"+"td_"+retResult[i][0])+"'>"+retResult[i][1]+"</td><td>"+retResult[i][6]+"</td><td><div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004|"+selectValue+"</span></td>");
					getMidPrompt("10442",retResult[i][0],codeChg("queryOfferList"+"td_"+retResult[i][0]));	
    			}
				}
			}
						//��ԭ���Ĳ�ѯ������Ϊ����
			document.frmMain.offerName.value="";
			document.frmMain.offerCode.value="";
			
			
}
//�Ӳ�ѯ�б��е�����¼��󣬰�ѡ�е���Ϣ���ӵ���һ���б�
var reCodeAdd = "";
var reMsgAdd = "";
function clickTr()
{
	var e = arguments[0] || window.event;
	var trCur = e.srcElement.parentNode || e.target.parentNode;
	//if(trCur.getElementsByTagName("td").length==0) return;
	var offerid = trCur.getElementsByTagName("td")[0].innerHTML;
	//���÷���ȡ��servBusId
	getServBusId(offerid);
	    //�Ӳ�ѯ�б���ȡ�������е�����
		 var xiaoxpCode=trCur.getElementsByTagName("td")[0].innerHTML;//����Ʒ����
	    var xiaoxpName=trCur.getElementsByTagName("td")[1].innerHTML;//x����Ʒ����
	    var bandName=trCur.getElementsByTagName("td")[2].innerHTML;	    //Ʒ������
	   // var offer_comments=trCur.getElementsByTagName("td")[3].innerHTML.split("|")[1];//����Ʒ����
	    
	    //�и����һ�У�ȡ����Ҫ������Ʒ��������
	    //var index = offerComments.indexOf('<');
	    //var offer_comments = offerComments.substring(0,index);
	    var band_id = document.frmMain.smCode.value;//Ʒ�Ʊ�ʶ
	    //ȡ�����һ���У���������span�е����ݣ����и�
	    var tdObj =trCur.getElementsByTagName("td")[3];
	    var offer_comments=tdObj.getElementsByTagName("div")[0].innerHTML
	    var spanH=tdObj.getElementsByTagName("span")[0].innerHTML;
		var spanHVs=spanH.split('|'); 
		//var exp_date_offset=spanHVs[0];//ʧЧʱ��ƫ����
		//var exp_date_offset_unit = spanHVs[1];//ʧЧʱ��ƫ�뵥λ
		//var offer_type = spanHVs[2];//����Ʒ����
		//var retKey = spanHVs[3];//��ѯ��ʽ~�ֻ�����/�������~/���ģ��/�����������ƴ�ӳɵĴ�
		//var retValue = spanHVs[4];//��ѯ��ʽ~�ֻ�����/�������~/���ģ��/����������͵�ֵ��ƴ�ӳɵĴ�
		
		var exp_date_offset=spanHVs[3];//ʧЧʱ��ƫ����
		var exp_date_offset_unit = spanHVs[4];
		var offer_type = spanHVs[5];          
		var retKey = spanHVs[6];              
		var retValue = spanHVs[7];  	
			
		var serv_bus_id =document.frmMain.servBusId.value;//ȡ�÷�������ID��servBusId

//		var retArr=chkLimit(xiaoxpCode,"1").split("@")
//		retCo=retArr[0].trim();
//		retMg=retArr[1];
//		
//		if(retCo!="0" )
//		{		
//			if(retCo=="110001"){
//		     	 if(rdShowConfirmDialog(retMg)!=1) return false;
//		  }else{
//		  		 rdShowConfirmDialog(retMg);
//		  		 return false;
//		  	}
//		}		
		if(mf_flag == "1"){
			pOfferQryByAttrLimit(xiaoxpCode);
		}
		if(mf_flag1 == "0"){
		return false;	
	  }
	
		ajaxGetLimitAdd(offerid);//  �������� hejwa add 2010��2��8��14:05:20
		if(reCodeAdd!="0"){
				rdShowMessageDialog(reCodeAdd+":"+reMsgAdd);
				return false;
		} 
		
		if(serv_bus_id==""){
					var msg =document.frmMain.retMsg.value;
					rdShowMessageDialog(msg);
					return false;
			}
			var delBut="";
			
			if(typeof(retKey) == "undefined" || typeof(retValue) == "undefined"){
				 delBut="<INPUT class=b_text id=but_add onclick='delTr();' type=button value=ɾ��><span style='display:none'>"+band_id+"|"+offer_comments+"|"+exp_date_offset+"|"+exp_date_offset_unit+"|"+offer_type+"|"+serv_bus_id+"</span>";
				}else{
					 delBut="<INPUT class=b_text id=but_add onclick='delTr();' type=button value=ɾ��><span style='display:none'>"+band_id+"|"+offer_comments+"|"+exp_date_offset+"|"+exp_date_offset_unit+"|"+offer_type+"|"+serv_bus_id+"|"+retKey+"|"+retValue+"</span>";
					}
		
 
		if(document.all.query01.checked==true||retQ08Flag()==true){
				delBut += "<INPUT class='b_text' id=but_add onclick='saveOffer("+offerid+");' type=button value=�ղ�>";
			}
				
							
			var arrTdCon=new Array(xiaoxpCode,xiaoxpName,bandName,"<div nowrap title="+offer_comments+">"+offer_comments.substring(0,20)+"..."+"</div>","<input type='hidden' id='"+offerid+"'/>"+delBut);
			if(flag){
				var tableId=g("productOfferList");
				var rowNum = tableId.rows.length;
				if(rowNum>1){
					for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
					}
				}
			}
			
			if(checkProductOfferList(offerid,"productOfferList"))
		    {
				if($("#productOfferList tr").length >1){
		    	if(rdShowConfirmDialog("���Ѿ�ѡ����һ������Ʒ��Ҫ�滻���е�����Ʒô��") == 1){
		    		$("#productOfferList tr").eq(1).remove();
		    		addTrOver("productOfferList","1",arrTdCon);
		    		getMidPrompt("10442",xiaoxpCode,codeChg("productOfferList"+"td_"+xiaoxpCode));	
		    	} 
		    }else{
		    	addTrOver("productOfferList","1",arrTdCon);	
		    	getMidPrompt("10442",xiaoxpCode,codeChg("productOfferList"+"td_"+xiaoxpCode));	
		    }
			}
}

function clickTr2()
{
//	var e = arguments[0] || window.event;
	var trCur=$("#queryOfferList").find("tr")[1];
	//if(trCur.getElementsByTagName("td").length==0) return;
	var offerid = trCur.getElementsByTagName("td")[0].innerHTML;
	//���÷���ȡ��servBusId
	getServBusId(offerid);
	    //�Ӳ�ѯ�б���ȡ�������е�����
		 var xiaoxpCode=trCur.getElementsByTagName("td")[0].innerHTML;//����Ʒ����
	    var xiaoxpName=trCur.getElementsByTagName("td")[1].innerHTML;//x����Ʒ����
	    var bandName=trCur.getElementsByTagName("td")[2].innerHTML;	    //Ʒ������
	   // var offer_comments=trCur.getElementsByTagName("td")[3].innerHTML.split("|")[1];//����Ʒ����
	    
	    //�и����һ�У�ȡ����Ҫ������Ʒ��������
	    //var index = offerComments.indexOf('<');
	    //var offer_comments = offerComments.substring(0,index);
	    var band_id = document.frmMain.smCode.value;//Ʒ�Ʊ�ʶ
	    //ȡ�����һ���У���������span�е����ݣ����и�
	    var tdObj =trCur.getElementsByTagName("td")[3];
	    var offer_comments=tdObj.getElementsByTagName("div")[0].innerHTML
	    var spanH=tdObj.getElementsByTagName("span")[0].innerHTML;
		var spanHVs=spanH.split('|'); 
		//var exp_date_offset=spanHVs[0];//ʧЧʱ��ƫ����
		//var exp_date_offset_unit = spanHVs[1];//ʧЧʱ��ƫ�뵥λ
		//var offer_type = spanHVs[2];//����Ʒ����
		//var retKey = spanHVs[3];//��ѯ��ʽ~�ֻ�����/�������~/���ģ��/�����������ƴ�ӳɵĴ�
		//var retValue = spanHVs[4];//��ѯ��ʽ~�ֻ�����/�������~/���ģ��/����������͵�ֵ��ƴ�ӳɵĴ�
		
		var exp_date_offset=spanHVs[3];//ʧЧʱ��ƫ����
		var exp_date_offset_unit = spanHVs[4];
		var offer_type = spanHVs[5];          
		var retKey = spanHVs[6];              
		var retValue = spanHVs[7];  	
			
		var serv_bus_id =document.frmMain.servBusId.value;//ȡ�÷�������ID��servBusId

//		var retArr=chkLimit(xiaoxpCode,"1").split("@")
//		retCo=retArr[0].trim();
//		retMg=retArr[1];
//		
//		if(retCo!="0" )
//		{		
//			if(retCo=="110001"){
//		     	 if(rdShowConfirmDialog(retMg)!=1) return false;
//		  }else{
//		  		 rdShowConfirmDialog(retMg);
//		  		 return false;
//		  	}
//		}		
		if(mf_flag == "1"){
			pOfferQryByAttrLimit(xiaoxpCode);
		}
		if(mf_flag1 == "0"){
		return false;	
	  }
	
		ajaxGetLimitAdd(offerid);//  �������� hejwa add 2010��2��8��14:05:20
		if(reCodeAdd!="0"){
				rdShowMessageDialog(reCodeAdd+":"+reMsgAdd);
				return false;
		} 
		
		if(serv_bus_id==""){
					var msg =document.frmMain.retMsg.value;
					rdShowMessageDialog(msg);
					return false;
			}
			var delBut="";
			
			if(typeof(retKey) == "undefined" || typeof(retValue) == "undefined"){
				 delBut="<INPUT class=b_text id=but_add onclick='delTr();' type=button value=ɾ��><span style='display:none'>"+band_id+"|"+offer_comments+"|"+exp_date_offset+"|"+exp_date_offset_unit+"|"+offer_type+"|"+serv_bus_id+"</span>";
				}else{
					 delBut="<INPUT class=b_text id=but_add onclick='delTr();' type=button value=ɾ��><span style='display:none'>"+band_id+"|"+offer_comments+"|"+exp_date_offset+"|"+exp_date_offset_unit+"|"+offer_type+"|"+serv_bus_id+"|"+retKey+"|"+retValue+"</span>";
					}
		
 
		if(document.all.query01.checked==true||retQ08Flag()==true){
				delBut += "<INPUT class='b_text' id=but_add onclick='saveOffer("+offerid+");' type=button value=�ղ�>";
			}
				
							
			var arrTdCon=new Array(xiaoxpCode,xiaoxpName,bandName,"<div nowrap title="+offer_comments+">"+offer_comments.substring(0,20)+"..."+"</div>","<input type='hidden' id='"+offerid+"'/>"+delBut);
			if(flag){
				var tableId=g("productOfferList");
				var rowNum = tableId.rows.length;
				if(rowNum>1){
					for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
					}
				}
			}
			
			if(checkProductOfferList(offerid,"productOfferList"))
		    {
				if($("#productOfferList tr").length >1){
		    	if(rdShowConfirmDialog("���Ѿ�ѡ����һ������Ʒ��Ҫ�滻���е�����Ʒô��") == 1){
		    		$("#productOfferList tr").eq(1).remove();
		    		addTrOver("productOfferList","1",arrTdCon);
		    		getMidPrompt("10442",xiaoxpCode,codeChg("productOfferList"+"td_"+xiaoxpCode));	
		    	} 
		    }else{
		    	addTrOver("productOfferList","1",arrTdCon);	
		    	getMidPrompt("10442",xiaoxpCode,codeChg("productOfferList"+"td_"+xiaoxpCode));	
		    }
			}
}


function pOfferQryByAttrLimit(xiaoxpCode)
{
		if (productOfferQueryList.style.display = "none")
		{
		//������ѡ���������Ϣ��ѯ
		var offerCode = xiaoxpCode;
		var offerName ="";
		var offerType =document.frmMain.offerType.value;//����Ʒ����
		var offerAttrSeq = "";//����Ʒ���Ա�ʶ 
		var custGroupId = "";//�ͻ�Ⱥ��ʶ
		var channelSegment="";//�������ͱ�ʶ
		var group_id=document.frmMain.receiveRegion.value;//������
		var band_id= "";
		var offer_att_type="";
		
		var packet = new AJAXPacket("ajax_productOfferQryByAttr_m.jsp","���Ժ�...");
		packet.data.add("offerCode" ,offerCode);
		packet.data.add("offerName" ,offerName);
		packet.data.add("offerType" ,offerType);
		packet.data.add("offerAttrSeq" ,offerAttrSeq);
		packet.data.add("custGroupId" ,custGroupId);
		packet.data.add("channelSegment" ,channelSegment);
		packet.data.add("group_id" ,group_id);
		packet.data.add("band_id" ,band_id);
		packet.data.add("offer_att_type" ,offer_att_type);
		packet.data.add("goodFlag" ,"1");
		packet.data.add("opCode" ,"<%=opCode%>");
		core.ajax.sendPacket(packet,doPOfferQryByAttrLimit);
		packet =null;
		}
}

function doPOfferQryByAttrLimit(packet){
	var qryRetCode = packet.data.findValueByName("retCode"); 
	var qryRetMsg = packet.data.findValueByName("retMsg"); 
	var retResult = packet.data.findValueByName("retResult");
	 if(retResult==null||retResult==""||retResult.length==0){
		rdShowMessageDialog("�˹���û�в���Ȩ�ޣ�������ѡ��",0);
			mf_flag1 = "0";
			return false;	
		}else{
			mf_flag1 = "1";	
		}
}
//������ڵ㴥���¼�

function ajaxGetLimitAdd(offerId){
	var packet = new AJAXPacket("ajax_LimitAdd.jsp","���Ժ�...");
			packet.data.add("offerId" ,offerId);
			packet.data.add("opCode" ,"<%=opCode%>");
			core.ajax.sendPacket(packet,doAjaxGetLimitAdd);
			packet =null;
}

function doAjaxGetLimitAdd(packet){
	  reCodeAdd = packet.data.findValueByName("retCode"); 
		reMsgAdd = packet.data.findValueByName("retMsg"); 
}

//У����ѡ�б����Ƿ��Ѿ�����ѡ��
function checkProductOfferList(productOfferID,tableID)
{
	var tableId=g(tableID);
	var rowNum = tableId.rows.length;
	
	for(var i=0;i<rowNum;i++)
	{
		var temp = tableId.rows[i].cells[0].innerHTML;
		
		if(temp==productOfferID)
		{
			return false;
		}
	}
	
	return true;

}

function HoverLi(n,t){
	for(var i=1;i<=t;i++)
	{
		g('tb_'+i).className='normaltab';
		g('tbc_0'+i).className='mztree';
		g('tbc_0'+i).style.display="none"
	}
	g('tbc_0'+n).className='unmztree';
	g('tb_'+n).className='hovertab';
	g('tbc_0'+n).style.display="block"
}	
//������ͨ��ʽ��ѯ
function queryByNomal(){
	resetInfo();
	document.frmMain.result2.value = "";	
	document.all.trFGoodNo.style.display="none";
	document.all.trFGoodNo1.style.display="none";
	
	goodKind = "P";
	var flag=document.frmMain.good.value;
	if(flag=="130"){
				document.frmMain.good.value="";
		}
	getSelectFlag();
	document.getElementById("normal").style.display="block";
	document.getElementById("betterNo").style.display="none";
	document.getElementById("rentMac").style.display="none";
	document.getElementById("queryOfferList").style.display="block";
	document.getElementById("hotOfferQueryList").style.display="block";
	document.getElementById("myFavoriteList").style.display="block";
	var productOfferTab = g("productOfferList");
	var rowNum = productOfferTab.rows.length;
	if(rowNum>1)
	{
		for(var i=1;i<rowNum;i++)
					{
						delTr("productOfferList","1");
					}	
	}
	
	var tableId=g("queryOfferList");
			document.getElementById("queryOfferList").style.display="none";
			document.getElementById("productOfferQueryList").style.display="none";
			var rowNum = tableId.rows.length;
			if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    } 
	    myFavorite();
			hotOffer();
}
$(document).ready(function(){
	var nowOpcode = '<%=opCode%>';
	if(nowOpcode == 'g784'){
		$("#query11").attr("checked",'checked');
	}else if(nowOpcode == 'g785'){
		$("#query12").attr("checked",'checked');
	}
	else if(nowOpcode == 'm028'){
		$("#query13").attr("checked",'checked');
	}
	else if(nowOpcode == 'm094'){
		$("#query14").attr("checked",'checked');
	}
	
	
	<%if(opCode.equals(startOpCode)){
			if("3".equals(chooseRadio)){
			%>
			$("#query03").click();
			<%
			}else if("8".equals(chooseRadio)){
			%>
			$("#query08").click();
			<%
			}
		}%>
	
	$("#query01").click(function(){
		<%if(!opCode.equals(startOpCode)){%>
			window.location = "qryProductOfferComplex.jsp?opCode=<%=startOpCode%>&chooseRadio=1";
		<%}%>
	});
	$("#query03").click(function(){
		<%if(!opCode.equals(startOpCode)){%>
			window.location = "qryProductOfferComplex.jsp?opCode=<%=startOpCode%>&chooseRadio=3";
		<%}%>
	});
	$("#query08").click(function(){
		<%if(!opCode.equals(startOpCode)){%>
			window.location = "qryProductOfferComplex.jsp?opCode=<%=startOpCode%>&chooseRadio=8";
		<%}%>
	});
	$("#query11").click(function(){
		window.location = "qryProductOfferComplex.jsp?opCode=g784&startOpCode=<%=startOpCode%>";
	});
	$("#query12").click(function(){
		window.location = "qryProductOfferComplex.jsp?opCode=g785&startOpCode=<%=startOpCode%>";
	});
		$("#query13").click(function(){
		window.location = "qryProductOfferComplex.jsp?opCode=m028&startOpCode=<%=startOpCode%>";
	});
	 $("#query14").click(function(){
		window.location = "qryProductOfferComplex.jsp?opCode=m094&startOpCode=<%=startOpCode%>";
	});
	
	
});


	//����������뷽ʽ��ѯ
	function queryByGoodNo(){
		resetInfo();
	document.getElementById("myFavoriteList").style.display="none"; //�ղؼ�
  document.getElementById("hotOfferQueryList").style.display="none";  //�ȵ�����Ʒ
	getSelectFlag();
	document.getElementById("normal").style.display="none";
	document.getElementById("betterNo").style.display="block";
	document.getElementById("rentMac").style.display="none";
	document.getElementById("queryOfferList").style.display="none";
	var productOfferTab = g("productOfferList");
	var rowNum = productOfferTab.rows.length;
	if(rowNum>1)
	{
			for(var i=1;i<rowNum;i++)
					{
						delTr("productOfferList","1");
					}	
	}
	}
	//�������������ʽ��ѯ
	function queryByRentMac(){
	goodKind = "";
	getSelectFlag();
	document.getElementById("myFavoriteList").style.display="none"; //�ղؼ�
  document.getElementById("hotOfferQueryList").style.display="none";  //�ȵ�����Ʒ
	document.getElementById("normal").style.display="none";
	document.getElementById("betterNo").style.display="none";
	document.getElementById("rentMac").style.display="block";
	document.getElementById("queryOfferList").style.display="block";
	var productOfferTab = g("productOfferList");
	var rowNum = productOfferTab.rows.length;
	if(rowNum>1)
	{
		for(var i=1;i<rowNum;i++)
					{
						delTr("productOfferList","1");
					}	
	}
	
	var tableId=g("queryOfferList");
			document.getElementById("queryOfferList").style.display="none";
			document.getElementById("productOfferQueryList").style.display="none";
			var rowNum = tableId.rows.length;
			if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
	    
	}
	//ȡ��ѡ���ѯ��ʽ��Value
	function getSelectFlag(){
		var flags = document.getElementsByName("query");
		var selectValue;
		if(flags.length>0){
			for(var i=0;i<flags.length;i++){
				if(flags[i].checked==true){
					selectValue=flags[i].value;
					}
				}
				document.frmMain.selectValue.value= selectValue;
			}
		}
	//���ݻ������ŵõ������Ϣ
	var modeCode="";
	function getImei(){	
  	if(document.frmMain.imeiNo.value.length == 0)
    {
        rdShowMessageDialog("�������������",0);
        return false;
    }
    var imeiNo=document.frmMain.imeiNo.value;
    var pageTitle = "�ֻ�������Ϣ��ѯ";
    var fieldName = "ģ�����|ģ������|��ͬ����(��)|���ۼ۸�(Ԫ)|��������(��)|Ѻ��(Ԫ)|�������(Ԫ)|Ԥ�滰��(Ԫ)|�����ѵ���(Ԫ)|���ʷ�|���ػ��ѱ���|";
    var sqlStr = "select c.sale_mode,c.mode_name,c.contract_months,c.sale_price,c.exists_months,c.deposit_money,c.contract_money,c.prepay_fee,c.payoff_rate,c.bind_mode,c.inland_rate,c.bind_mode,c.res_price from dChnResMobInfo a,sChnResBindModeItem b,sChnResSaleMode c, schnresstatusswitch d ,sChnResBindMode rb, dchngroupinfo gi where   c.rent_type ='0' and  b.bind_mode=rb.bind_mode and c.is_valid=1 and rb.is_valid=1 and sysdate between c.begin_time and c.end_time and sysdate between rb.begin_time and rb.end_time and trim(a.imei_no)=trim(upper('"+imeiNo+"')) and a.res_code=b.res_code and b.bind_mode=c.bind_mode and c.group_id in(select parent_group_id from dChnGroupInfo where group_id='"+"<%=groupId%>"+"') and c.sale_type = '0' and a.status_code=d.src_status and a.kind_code=d.kind_code and d.func_type='0' and d.func_code='1109' and a.group_id=gi.group_id and gi.parent_group_id='"+"<%=groupId%>"+"'"; 	
    
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "13|0|1|2|3|4|5|6|7|8|9|10|11|12|";
    var retToField = "imeiString|";
    custInfoQuery(pageTitle,fieldName,sqlStr,selType,retQuence,retToField); 
		}
	function custInfoQuery(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
	
{
    /*
    ����1(pageTitle)����ѯҳ�����
    ����2(fieldName)�����������ƣ���'|'�ָ��Ĵ�
    ����3(sqlStr)��sql���
    ����4(selType)������1 rediobutton 2 checkbox
    ����5(retQuence)����������Ϣ������������� �������ʶ����'|'�ָ�����"3|0|2|3"��ʾ����3����0��2��3
    ����6(retToField))������ֵ����������,��'|'�ָ�
    */
    var path = "ajax_qryModelByMacNo.jsp";   //����Ϊ*
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    
    var imeiNo=document.all.imeiNo.value;
    path = path + "&imeiNo=" + imeiNo ;
    path = path + "&regionCode=" + "<%=regionCode%>" ;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;  
    
	  var obj33 = frmMain;
    retInfo = window.showModalDialog(path,obj33,"dialogWidth:50;dialogHeight:40;");
	
    if(typeof(retInfo) == "undefined")     
    {   
    	return false;   
    }
    var chPos_field = retToField.indexOf("|");
    var chPos_retStr;
    var valueStr;
    var obj;
    
    document.frmMain.contractInfo.value =retInfo;
}
//�������������Ϣ��ѯ������Ʒ�б�
function qryByRentMac(){
	if(document.frmMain.imeiNo.value.trim()=="" || document.frmMain.hid_sale_mode.value.trim()==""){
		rdShowMessageDialog("�ô��Ų����ڣ�����������");
		return false;
		}
	 if(productOfferQueryList.style.display = "none")
		  {
			productOfferQueryList.style.display = "block";
			var sale_mode = document.frmMain.hid_sale_mode.value;
			var packet = new AJAXPacket("ajax_qryProductOfferByRentInfo.jsp","���Ժ�...");
			packet.data.add("sale_mode" ,sale_mode);//ģ��ID
			core.ajax.sendPacket(packet,doProductOfferByRentInfo);
			packet =null;
			}
	}
	function doProductOfferByRentInfo(packet){
		var selectValue = document.frmMain.selectValue.value;
		var saleMode = document.frmMain.hid_sale_mode.value;
		var imeiNo = document.frmMain.imeiNo.value;
			var qryRetCode = packet.data.findValueByName("retCode"); 
			var qryRetMsg = packet.data.findValueByName("retMsg"); 
			var retResult = packet.data.findValueByName("retResult");
			var tableId=g("queryOfferList");
			var rowNum = tableId.rows.length;
						if(rowNum>1){
			      	     for(var i=2;i<=rowNum;i++){
										tableId.deleteRow();
					        }
				        }
			if(retResult==null||retResult==""){
				rdShowMessageDialog("û�в�ѯ�������������4");
				}else{
						if(qryRetCode==0){
						for(var i=0;i<retResult.length;i++){
							var arrTdCon=new Array(retResult[i][0],"<span id='td_"+retResult[i][0]+"'>"+retResult[i][1]+"</span>",retResult[i][3],"<div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][4]+"|"+retResult[i][5]+"|"+retResult[i][6]+"|20004~20005~20006|"+selectValue+"~"+imeiNo+"~"+saleMode+"</span>");
							addTrOver("queryOfferList","1",arrTdCon,1,"f5f5f5");
							getMidPrompt("10442",retResult[i][0],codeChg("queryOfferList"+"td_"+retResult[i][0]));	
							}
						}
					}
		}
	function resetInfo(){
				document.getElementById("queryInfo2").disabled=false;
				document.getElementById("queryFirst").disabled=false;
				//�����ѡ����Ʒ�б�
//				var productOfferTab = g("productOfferList");
//				var rowNum = productOfferTab.rows.length;
//				if(rowNum>1)
//				{
//					for(var i=1;i<rowNum;i++)
//					{
//						delTr("productOfferList","1");
//					}	
//				} 
							
				//����ͨ��ѯ�����ÿ�
				document.frmMain.offerName.value="";
				document.frmMain.offerCode.value="";
				//���������������ѯ�ÿ�
				
				document.frmMain.imeiNo.value="";
				document.frmMain.contractInfo.value="";
				document.frmMain.rentDeposit.value="";
				document.frmMain.rentCostPre.value="";
				//����������ѯ��Ϣ�ÿ�						
				document.all.goodNo.value = "";
				document.frmMain.goodNoBlind.value="";
				document.frmMain.blindCost.value="";
				document.frmMain.blindNetPre.value="";
				document.frmMain.blindBackMonth.value="";
				document.frmMain.blindNetDeposit.value="";
				document.frmMain.blindContractDate.value="";
				document.frmMain.blindAddCombo.value="";
				document.frmMain.blindSpecialSevice.value="";		
				setOnloadF();
				}
	//������������ѯ�������������
	function getGoodNo(){
		 
 		var goodno = document.all.goodNo.value;
		
			var tableId=g("queryOfferList");
			document.getElementById("queryOfferList").style.display="none";
			document.getElementById("productOfferQueryList").style.display="none";
			var rowNum = tableId.rows.length;
			if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
	    
		
		var productOfferTab = g("productOfferList");
				var rowNum = productOfferTab.rows.length;
				if(rowNum>1)
				{
					for(var i=1;i<rowNum;i++)
					{
						delTr("productOfferList","1");
					}	
				} 
  	if(document.frmMain.goodNo.value.length == 0 || document.frmMain.goodNo.value.trim()=="�������������")
    {
        rdShowMessageDialog("�������������",0);
        return false;
    } 
    	
    var goodNo = document.frmMain.goodNo.value.trim();
    var path="isGoodNoExist.jsp?goodNo="+goodNo;
    retInfo = window.showModalDialog(path,window,"dialogWidth:600px;dialogHeight:300px;");
    if(retInfo=="11"){//��ʾ��������뱻ռ��
    		document.frmMain.goodNo.value="�������������";
    		document.frmMain.goodNo.focus();
    	  return false;
    	}else if(retInfo=="22"){//��ѯ��¼����
    			rdShowMessageDialog("��ѯ��¼����");
    			document.frmMain.goodNo.value="�������������";
	    		document.frmMain.goodNo.focus();
	    	  return false;
    		}else if(retInfo=="00"){//��ʾ������������
    		/*2014/09/28 11:16:06 gaopeng �������������������ܺ�188���뿪������ĺ�
    			����188�Ŷε��жϣ����188�Ŷεĺ��벻��������룬��������������������п���
    		*/	
    		if(goodNo.substring(0,3)=="188"){
	    		var isGoddNo_Packet2 = new AJAXPacket("/npage/common/qcommon/isGoodNo.jsp","����У����룬���Ժ�......");
		 			isGoddNo_Packet2.data.add("selNumValue",goodNo);
		 			core.ajax.sendPacket(isGoddNo_Packet2,doIsGoodNo2);
		 			isGoddNo_Packet=null;
    		}
    		var packet = new AJAXPacket("ajax_qryGoodTypeByGoodNo.jsp","���Ժ�...");
    		packet.data.add("goodNo" ,goodNo);//�������
				core.ajax.sendPacket(packet,doGetGoodNo);
				packet =null;
    	}
	}
	
	function doIsGoodNo2(packet){
			var countGoodNo = packet.data.findValueByName("countGoodNo");
			if(countGoodNo==0){
					rdShowMessageDialog("�ú��벻��������룬����������������뿪����",0);
					document.frmMain.goodNo.value="�������������";
	    		document.frmMain.goodNo.focus();
	    		document.all.query01.checked = true;
					queryByNomal();
		   		return false;
				}
		}
		
	//�ص�����
	function doGetGoodNo(packet){
			var qryRetCode = packet.data.findValueByName("retCode"); 
			var qryRetMsg = packet.data.findValueByName("retMsg"); 
			var retResult = packet.data.findValueByName("retResult");
			
			document.all.goodNo_new.value = document.all.goodNo.value;
			
			if(retResult==null||retResult==""){
						rdShowMessageDialog("û�в�ѯ����Ӧ���������Ϣ");
						document.frmMain.goodNo.value="�������������";
		    		document.frmMain.goodNo.focus();
		    	  return false;
			}else{
							//ȡ�õ���ϢΪ:0����������ͣ�1��������ܷ��ã�2������Ԥ�棬3�󶨷��·�����4������Ѻ��5�󶨺�ͬ���ޣ�6���ײͣ�7�ط�,8���������
							document.frmMain.goodNoBlind.value = retResult[0][0];
							document.frmMain.blindCost.value = retResult[0][1];
							document.frmMain.blindNetPre.value = retResult[0][3];
							document.frmMain.blindBackMonth.value = retResult[0][3];
							document.frmMain.blindNetDeposit.value = retResult[0][4];
							document.frmMain.blindContractDate.value = retResult[0][5];
							
							if(retResult[0][4]=="0"){
								document.frmMain.blindAddCombo.value ="";
							}else{
								document.frmMain.blindAddCombo.value = retResult[0][5]+"|"+ retResult[0][6];
								}
							
							document.frmMain.blindSpecialSevice.value = retResult[0][7];
							
							goodKind = retResult[0][9];
							
							document.frmMain.result2.value = retResult[0][2];
							document.frmMain.result8.value = retResult[0][8];
							document.frmMain.result9.value = retResult[0][9];
							document.frmMain.result10.value = retResult[0][10];
							document.frmMain.result11.value = retResult[0][11];
							document.frmMain.result12.value = retResult[0][12];
							document.frmMain.result13.value = retResult[0][13];
							document.frmMain.result14.value = retResult[0][14];
							
							 if(document.all.goodNo_new.value.substring(0,3)=="188"&&document.frmMain.blindCost.value=="1"){
							 	document.all.trFGoodNo.style.display="";
							 	document.all.trFGoodNo1.style.display="";
							 	ajaxSetSmCodef();
							  ajaxSetpType();
							 	}else{
							 	document.all.trFGoodNo.style.display="";
							 	document.all.trFGoodNo1.style.display="";
								ajaxSetSmCodef();
							  ajaxSetpType();
							  if(document.frmMain.result2.value =="P"){
								  myFavorite();
								  hotOffer();
								  document.getElementById("myFavoriteList").style.display=""; //�ղؼ�
	  							document.getElementById("hotOfferQueryList").style.display="";  //�ȵ�����Ʒ
  							}
							}
					}
		}
		
		function qryByGoodNoType(){
			
				var productOfferTab = g("productOfferList");
				var rowNum = productOfferTab.rows.length;
				if(rowNum>1)
				{
					for(var i=1;i<rowNum;i++)
					{
						delTr("productOfferList","1");
					}	
				} 
			
			
			var selectValue = document.frmMain.selectValue.value;//��ѯ��ʽ��value
			//wangzc add
			//if(document.all.goodNo_new.value.substring(0,3)=="188"&&document.frmMain.blindCost.value=="1"){
				
				//if(productOfferQueryList.style.display = "none")
			 // {
				 // productOfferQueryList.style.display = "";
					//var packet = new AJAXPacket("ajax_getGoodNo_New.jsp","���Ժ�...");
	    		//packet.data.add("goodNo" ,document.all.goodNo_new.value);//�������
	    		//packet.data.add("goodNotype" ,document.frmMain.goodNoBlind.value);   //wangzc
	    		//packet.data.add("goodNotype" ,document.frmMain.result2.value)
	    		//packet.data.add("result8" ,document.frmMain.result8.value);
					//core.ajax.sendPacket(packet,doqryByGoodNoType);
					//packet =null;
			  //} 
			  
				//}else{
					
							var offerCode = document.frmMain.offerCodeGood.value;//����Ʒ����
							var offerName =document.frmMain.offerNameGood.value;//����Ʒ���� 
							var offerType =document.frmMain.offerType.value;//����Ʒ����
							var offerAttrSeq = "";//����Ʒ���Ա�ʶ 
							var custGroupId = "";//�ͻ�Ⱥ��ʶ
							var channelSegment="";//�������ͱ�ʶ
							var group_id=document.frmMain.receiveRegion.value;//������
							var band_id= document.frmMain.smCodeFGood.value;//Ʒ�Ʊ�ʶ
							var offer_att_type=document.all.offer_att_typeFGood.value;//����Ʒ�����ʶ
							
							//alert("band_id|"+band_id+"\n offer_att_type|"+offer_att_type);
							
							var packet = new AJAXPacket("ajax_productOfferQryByAttr.jsp","���Ժ�...");
							packet.data.add("offerCode" ,offerCode);
							packet.data.add("offerName" ,offerName);
							packet.data.add("offerType" ,offerType);
							packet.data.add("offerAttrSeq" ,offerAttrSeq);
							packet.data.add("custGroupId" ,custGroupId);
							packet.data.add("channelSegment" ,channelSegment);
							packet.data.add("group_id" ,group_id);
							packet.data.add("band_id" ,band_id);
							packet.data.add("offer_att_type" ,offer_att_type);
							packet.data.add("goodNotype" ,document.frmMain.result2.value);
							packet.data.add("goodFlag" ,"0");
							packet.data.add("opCode" ,"<%=opCode%>");
							core.ajax.sendPacket(packet,doProductOfferQryByAttrGood);
							packet =null;
			//}
		}
function doProductOfferQryByAttrGood(packet){
	var goodNo = document.frmMain.goodNo.value.trim();
	var goodType= document.frmMain.goodNoBlind.value;
					
  var selectValue = document.frmMain.selectValue.value;//��ѯ��ʽ��value
	var qryRetCode = packet.data.findValueByName("retCode"); 
	var qryRetMsg = packet.data.findValueByName("retMsg"); 
	var retResult = packet.data.findValueByName("retResult");
	document.getElementById("productOfferQueryList").style.display="";
	document.getElementById("queryOfferList").style.display="";
	var serv_bus_id =document.frmMain.servBusId.value;//ȡ�÷�������ID��servBusId
	//alert("serv_bus_id|"+serv_bus_id);
	var tableId=g("queryOfferList");
	var rowNum = tableId.rows.length;
	if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
	if(retResult==null||retResult==""){
		rdShowMessageDialog("û�в�ѯ�������������3��"+qryRetMsg);
		}else{
				if(qryRetCode==0){
				for(var i=0;i<retResult.length;i++){
					
					$("#queryOfferList").append("<tr onclick='clickTr()' style='cursor:pointer;'><td id='queryOfferList"+"_tr1_td"+i+"'>"+retResult[i][0]+"</td><td id='"+codeChg("queryOfferList"+"td_"+retResult[i][0])+"'>"+retResult[i][1]+"</td><td id='queryOfferList"+"_tr1_td"+(i+2)+"'>"+retResult[i][6]+"</td><td id='queryOfferList"+"_tr1_td"+(i+3)+"'><div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|20018|20004~20007~20008|"+selectValue+"~"+goodNo+"~"+goodType+"</span></td>");
					getMidPrompt("10442",retResult[i][0],codeChg("queryOfferList"+"td_"+retResult[i][0]));	
    			}
				}
			}
						//��ԭ���Ĳ�ѯ������Ϊ����
			document.frmMain.offerName.value="";
			document.frmMain.offerCode.value="";
			
			
}
/* ������ͨ78λTD���������û����Ʒ��Ͷ��Ź��ܵ����� */
<%
	String tdSql = "SELECT msg.class_code FROM dchngroupmsg msg WHERE msg.GROUP_ID = '" + groupId + "'";
	String inputParam = "214";
%>
 		<wtc:pubselect name="sPubSelect" outnum="1" retmsg="msgtd" retcode="codetd" 
 		 routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=tdSql%></wtc:sql>
 	  </wtc:pubselect>
	 <wtc:array id="tdresult" scope="end"/>
<%
	if(codetd.equals("000000")){
		if(tdresult != null && tdresult.length > 0){
			if(tdresult[0][0].equals("200") ){
				inputParam = "225";
			}
		}
	}
	if("4977".equals(opCode)){
		/* ����ǿ���������227 */
		inputParam = "227";
	}
	if("e887".equals(opCode)){
		/* �����IMS�̻�centrex��228 */
		inputParam = "228";
	}
	
	if("m462".equals(opCode)){
		/* �����IMS�̻�centrex��232 */
		inputParam = "232";
	}
	System.out.println("==== qryProductOfferComplex.jsp ===inputParam " + inputParam);
%>
		//��������Ʒ�ƺ�����Ʒ����
			<wtc:service name="sDynSqlCfm" routerKey="region" routerValue="<%=regionCode%>" outnum="3">
    		<wtc:param value="<%=inputParam%>"/>
    		</wtc:service>
    	<wtc:array id="result_t1" scope="end"/>
   
function 	ajaxSetSmCodef(){
		var selectObj = document.getElementById("smCodeFGood");
	  selectObj.length=0;
	  <%
		  for(int iii=0;iii<result_t1.length;iii++){
		  		String temp1 = result_t1[iii][0];
		  		String temp2 = result_t1[iii][1];
		%>
		
			selectObj.options.add(new Option("<%=temp1%>--><%=temp2%>","<%=temp1%>"));
		<%			
			}
		%>	
	}
function ajaxSetpType(){
		var packet = new AJAXPacket("ajax_getOfferType.jsp","���Ժ�...");
		packet.data.add("smCode" ,document.all.smCodeFGood.value);
		packet.data.add("goodKind" ,document.frmMain.result2.value );
		packet.data.add("opCode" ,"<%=opCode%>" );
		packet.data.add("goodFlag" ,"0");

		core.ajax.sendPacket(packet,doAjaxSetpType);	
}	
			
function 	doAjaxSetpType(packet){
		var retResult = packet.data.findValueByName("retResult"); 
		var selectObj = document.getElementById("offer_att_typeFGood");
	  selectObj.length=0;
		selectObj.options.add(new Option("--��ѡ��--",""));
		//if(document.frmMain.result2.value =="P"){
			document.all.offer_att_typeFGood.disabled=false;
		for(var i=0;i<retResult.length;i++){
			var reg = /\s/g;     
			var ss = retResult[i][0].replace(reg,""); 
				if(ss.length!=0){
					selectObj.options.add(new Option(retResult[i][0]+"-->"+retResult[i][1],retResult[i][0]));
				}
			}
	//}else{
			//document.all.offer_att_typeFGood.disabled=true;
			//}
	}	


function setOfferTypeFGood(){
		var packet = new AJAXPacket("ajax_getOfferType.jsp","���Ժ�...");
		packet.data.add("smCode" ,document.all.smCodeFGood.value);
		packet.data.add("goodFlag" ,"1");
		packet.data.add("opCode" ,"<%=opCode%>" );
		packet.data.add("goodKind" ,document.frmMain.result2.value );
		core.ajax.sendPacket(packet,dosetOfferTypeFGood);	
}	
			
function 	dosetOfferTypeFGood(packet){
		var retResult = packet.data.findValueByName("retResult"); 
		var selectObj = document.getElementById("offer_att_typeFGood");
	  selectObj.length=0;
		selectObj.options.add(new Option("--��ѡ��--",""));
		
		//if(document.frmMain.result2.value =="P"){
			document.all.offer_att_typeFGood.disabled=false;
		for(var i=0;i<retResult.length;i++){
			var reg = /\s/g;     
			var ss = retResult[i][0].replace(reg,""); 
				if(ss.length!=0){
					selectObj.options.add(new Option(retResult[i][0]+"-->"+retResult[i][1],retResult[i][0]));
				}
			}
		//}else{
			//	document.all.offer_att_typeFGood.disabled=true;
				//}	
	}
	
		
			
		function doqryByGoodNoType(packet){
			var goodNo = document.frmMain.goodNo.value.trim();
			var goodType= document.frmMain.goodNoBlind.value;
			var qryRetCode = packet.data.findValueByName("retCode"); 
			var qryRetMsg = packet.data.findValueByName("retMsg"); 
			var retResult = packet.data.findValueByName("retResult");
			var selectValue = document.frmMain.selectValue.value;//��ѯ��ʽ��value
			
			var selectValue = document.frmMain.selectValue.value;//��ѯ��ʽ��value
			var serv_bus_id =document.frmMain.servBusId.value;
			
			var tableId=g("queryOfferList");
			document.getElementById("queryOfferList").style.display="block";
			document.getElementById("productOfferQueryList").style.display="block";
			var rowNum = tableId.rows.length;
			if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
		if(retResult==null||retResult==""){
		rdShowMessageDialog("û�в�ѯ�������������3");
		}else{
				if(qryRetCode==0){
				for(var i=0;i<retResult.length;i++){
					var arrTdCon=new Array(retResult[i][0],retResult[i][1],retResult[i][6],"<div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004~20007~20008|"+selectValue+"~"+goodNo+"~"+goodType+"</span>");
					//addTrOver("queryOfferList","1",arrTdCon,1,"f5f5f5");  //18845115111
					$("#queryOfferList").append("<tr onclick='clickTr()' style='cursor:pointer;'><td id='queryOfferList"+"_tr1_td"+i+"'>"+retResult[i][0]+"</td><td id='"+codeChg("queryOfferList"+"td_"+retResult[i][0])+"'>"+retResult[i][1]+"</td><td id='queryOfferList"+"_tr1_td"+(i+2)+"'>"+retResult[i][6]+"</td><td id='queryOfferList"+"_tr1_td"+(i+3)+"'><div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|20018|20004~20007~20008|"+selectValue+"~"+goodNo+"~"+goodType+"</span></td>");
					getMidPrompt("10442",retResult[i][0],"queryOfferList"+"td_"+retResult[i][0]);	
					}
				}
			}		
		}
			
function setOfferType(){
		if("<%=opCode%>"=="4977"&&document.all.smCode.value=="72"){
			var phoneNo = "<%=phoneNo%>";
			
		}
		var packet = new AJAXPacket("ajax_getOfferType.jsp","���Ժ�...");
		packet.data.add("smCode" ,document.all.smCode.value);
		packet.data.add("phoneNo" ,"<%=phoneNo%>");
		packet.data.add("goodKind" ,document.frmMain.result2.value );
		packet.data.add("opCode" ,"<%=opCode%>" );
		core.ajax.sendPacket(packet,dosetOfferType);	
}	
			
function 	dosetOfferType(packet){
		
		var code = packet.data.findValueByName("code"); 
		var msg  = packet.data.findValueByName("msg"); 
		
		if("000000"==code){
			var retResult = packet.data.findValueByName("retResult"); 
			var selectObj = document.getElementById("offer_att_type");
		  selectObj.length=0;
			selectObj.options.add(new Option("--��ѡ��--",""));
			for(var i=0;i<retResult.length;i++){
				var reg = /\s/g;     
				var ss = retResult[i][0].replace(reg,""); 
					if(ss.length!=0){
						selectObj.options.add(new Option(retResult[i][0]+"-->"+retResult[i][1],retResult[i][0]));
						$("#offer_att_type").val("YnKB");
					}
				}
		}else{
			rdShowMessageDialog(code+"��"+msg);
			window.close();
		}
	}
	
	
var showPageNum = 1; //��ǰҳ��
var rowSum = 20;  //ÿҳ��ʾ��¼��		

function myFavorite(){
			rowSum = 5;
			var packet = new AJAXPacket("ajax_getMfOffer.jsp","���Ժ�...");
			packet.data.add("opCode" ,"<%=opCode%>");
			core.ajax.sendPacket(packet,doMyFavorite);
			packet =null;	
}

function doMyFavorite(packet){
			var qryRetCode = packet.data.findValueByName("retCode"); 
	    var qryRetMsg = packet.data.findValueByName("retMsg"); 
	    var retResult = packet.data.findValueByName("retResult");
			document.getElementById("myFavoriteList").style.display="";
			//document.getElementById("hotOfferQueryList").style.display="none";
			document.getElementById("queryhotOfferList").style.display="";
			//document.getElementById("productOfferQueryList").style.display="none";
			retResultJ =	retResult;
			var tempJ1 = retResult.length/rowSum;	
			if(retResult.length<rowSum){
					rowSum = retResult.length;
				}			
			var tempJ2 = "";
			var tempJ3 = "";
			if((tempJ1+"").indexOf(".")!=-1){
				tempJ2 = (tempJ1+"").substring(0,(tempJ1+"").indexOf("."));
				tempJ3 = parseInt(tempJ2)+1;
			}else{
				tempJ3 = tempJ1;
				}
			//document.all.myFavoriteP.value = tempJ3;
			document.all.sumPageNum.value = tempJ3;
		if(retResult==null||retResult==""){
			;
		//rdShowMessageDialog("û�в�ѯ�������������3"+qryRetMsg);
		}else{
			changePage("myFavoriteListT","S");
	 }
}

function hotOffer(){
		rowSum = 10;
		var packet = new AJAXPacket("ajax_getHotOffer.jsp","���Ժ�...");
		packet.data.add("groupId" ,"<%=groupId%>");
		core.ajax.sendPacket(packet,doHotOffer);
		packet =null;
}		

var retResultJ = "";
function doHotOffer(packet){
	var qryRetCode = packet.data.findValueByName("retCode"); 
	var qryRetMsg = packet.data.findValueByName("retMsg"); 
	var retResult = packet.data.findValueByName("retResult");

			//document.getElementById("myFavoriteList").style.display="none"; //�ղؼ�
			document.getElementById("hotOfferQueryList").style.display="";  //�ȵ�����Ʒ
			//document.getElementById("productOfferQueryList").style.display="none"; //�����ѯ�б�
			
			retResultJ =	retResult;
			var tempJ1 = retResult.length/rowSum;
			
			if(retResult.length<rowSum){
					rowSum = retResult.length;
				}
				
			var tempJ2 = "";
			var tempJ3 = "";
			
			if((tempJ1+"").indexOf(".")!=-1){
				tempJ2 = (tempJ1+"").substring(0,(tempJ1+"").indexOf("."));
				tempJ3 = parseInt(tempJ2)+1;
			}else{
				tempJ3 = tempJ1;
				}
			
			
			document.all.sumPageNum.value = tempJ3;
			//document.all.hotOfferP.value=tempJ3;
			
		if(retResult==null||retResult==""){
		;
		}else{
			changePage("queryhotOfferList","S");
	 }
}	



function changePage(tabName,pFlag){
	
	var tableId=g(tabName);
	var rowNum = tableId.rows.length;
			if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
	      	
	var goodNo = document.frmMain.goodNo.value.trim();
	var goodType= document.frmMain.goodNoBlind.value;
	var selectValue = document.frmMain.selectValue.value;//��ѯ��ʽ��value
	var serv_bus_id =document.frmMain.servBusId.value;	
	
	var showPageNumJ = showPageNum;  //��¼��ǰҳ��
	var retResult = retResultJ;
		
	var beginNum = 0;
	var endNum = retResult.length-1;
	
	
	
	//alert("beginNum|"+beginNum+"\nendNum|"+endNum);
	
	
	 for(var i=beginNum;i<=endNum;i++){
		//alert("retResult["+i+"][0]|"+retResult[i][0]+"\nretResult["+i+"][1]|"+retResult[i][1]+"\nretResult["+i+"][2]|"+retResult[i][2]+"\nretResult["+i+"][3]|"+retResult[i][3]+"\nretResult["+i+"][4]|"+retResult[i][4]+"\nretResult["+i+"][5]|"+retResult[i][5]+"\nretResult["+i+"][6]|"+retResult[i][6]);				
					
	 			if(tabName=="myFavoriteListT"){ //�����ղؼ�
	 				if(document.all.query01.checked||retQ08Flag()==true){
						var delBut="<div style='display:none'>"+retResult[i][2]+"</div>"+"<INPUT class='b_text' id=but_add onclick='delTr_m(\""+retResult[i][0]+"\");' type=button value=ɾ��><span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004|"+selectValue+"</span>";
						var arrTdCon=new Array(retResult[i][0],retResult[i][1],retResult[i][6],"<input type='hidden' id='"+retResult[i][0]+"'/>"+delBut);
					}else{
						var arrTdCon=new Array(retResult[i][0],retResult[i][1],retResult[i][6],"<div style='display:none'>"+retResult[i][2]+"</div>"+"<INPUT class='b_text' id=but_add onclick='delTr_m(\""+retResult[i][0]+"\");' type=button value=ɾ��><span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004~20007~20008|"+selectValue+"~"+goodNo+"~"+goodType+"</span>");
						}
				}else{//�����ȵ�
					if(document.all.query01.checked||retQ08Flag()==true){
						var delBut="<div style='display:none'>"+retResult[i][2]+"</div>"+" <span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004|"+selectValue+"</span>";
						var arrTdCon=new Array(retResult[i][0],retResult[i][1],retResult[i][6],"<input type='hidden' id='"+retResult[i][0]+"'/>"+delBut);
					}else{
						var arrTdCon=new Array(retResult[i][0],retResult[i][1],retResult[i][6],"<div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004~20007~20008|"+selectValue+"~"+goodNo+"~"+goodType+"</span>");
						}
				}
				
				addTrOver(tabName,"1",arrTdCon,1,"f5f5f5");
				getMidPrompt("10442",retResult[i][0],codeChg(tabName+"td_"+retResult[i][0]));	
		}
  }
  
function delTr_m(offer_id)
{
	var tableId=g("myFavoriteListT");
	var rowNum = tableId.rows.length;
			if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
	    
	var okno = confirm("ɾ��������¼ô��");
	if(okno){
	var packet = new AJAXPacket("ajax_DelMyFavorite.jsp","���Ժ�...");
		packet.data.add("offer_id" ,offer_id);
		core.ajax.sendPacket(packet,doDelTr_m);
		packet =null;
		}else{
			myFavorite();
			}
}

function doDelTr_m(packet){
	var retCode = packet.data.findValueByName("retCode"); 
	var retMsg = packet.data.findValueByName("retMsg"); 
		if(retCode==0)
	  {
	  	alert("ɾ���ɹ�!");
	  	myFavorite();
		}else{
		  alert(retMsg);
		}
	}
	
	
function saveOffer(offer_id){
		var packet = new AJAXPacket("ajax_saveProdBookMark.jsp","���Ժ�...");
		packet.data.add("offerCode" ,offer_id);
		packet.data.add("workNo" ,"<%=workNo%>");
		core.ajax.sendPacket(packet,dosaveOffer);
		packet =null;
}

	
function dosaveOffer(packet)
{
	var qryRetCode = packet.data.findValueByName("retCode"); 
	var qryRetMsg = packet.data.findValueByName("retMsg");
	var retVal1 = packet.data.findValueByName("retVal1");
	
	
  if(qryRetCode==0)
  {
  	rdShowMessageDialog(retVal1);
  	myFavorite();
	}else{
	  rdShowMessageDialog(qryRetCode+":"+qryRetMsg);
	}
}

    	<wtc:service name="sDynSqlCfm" routerKey="region" routerValue="<%=regionCode%>" outnum="2">
    		  <wtc:param value="25"/>
    		  <wtc:param value="<%=workNo%>"/>
    	</wtc:service>
    	<wtc:array id="rowsRegionH" scope="end"/>
 
 		function 	addRegCode(){
				var selectObj = document.getElementById("receiveRegion");
			  selectObj.length=0;
			  <%
				  for(int iii=0;iii<rowsRegionH.length;iii++){
				  		String temp1 = rowsRegionH[iii][0];
				  		String temp2 = rowsRegionH[iii][1];
				%>
					 selectObj.options.add(new Option("<%=temp1%>--><%=temp2%>","<%=temp1%>"));
				<%			
					}
				%>	
			}
		
			<%
				String sqlStr1= "SELECT band_id,band_name FROM band WHERE ban_band_id IN (1,2,3)";
			%>
							
			<wtc:service name="sDynSqlCfm" routerKey="region" routerValue="<%=regionCode%>" outnum="3">
    		<wtc:param value="<%=inputParam%>"/>
    	</wtc:service>
    	<wtc:array id="result_t1" scope="end"/>
   
function 	addSmCode(){
		var selectObj = document.getElementById("smCode");
	  selectObj.length=0;
	  
	  <%
		  for(int iii=0;iii<result_t1.length;iii++){
		  		String temp1 = result_t1[iii][0];
		  		String temp2 = result_t1[iii][1];
		  		if(opCode.equals("d535")){
					%>
						selectObj.options.add(new Option("82-->IMS�̻�","82"));	
				  <%
				  	break;
				  }else if(opCode.equals("4977")){
				  	
				  	%>
					  	if("<%=temp1%>"!="63"){
					  		selectObj.options.add(new Option("<%=temp1%>--><%=temp2%>","<%=temp1%>"));
					  	}
				  		
				  		$("#smCode").val("67");
				  	<%
				  	
				  }
					else{
					%>
						selectObj.options.add(new Option("<%=temp1%>--><%=temp2%>","<%=temp1%>"));
					<%
					}	
			}
		%>	
	}
			 	
    		
function setOnloadF(){
	//addSmCode();
	//setOfferType();
	//addRegCode();
}	   	
/*************
addTrOver ����  Ҫ��������Id ���������ڱ���ĵڼ��У�Ҫ��������ݣ��������Ƿ����ظ��������У��������а��¼���ʱ��������ȥ����ɫ��

***********/
function addTrOver(tableID,trIndex,arrTdCont,num,bg)
{
	var tableId=g(tableID);
	var tableTr=g(tableID).getElementsByTagName("tr");
	if(typeof(num)!="undefined")
	{
		for (var i=0;i<tableTr.length;i++)
		{
			var tabaleTd=tableTr[i].getElementsByTagName("td");	
			var tdArrs=new Array();
			for(var j=0;j<tabaleTd.length;j++)
			{
				tdArrs.push(tabaleTd[j].innerHTML);
			}
			var tempnum=String(num);
			var nums=tempnum.split('|');
			var a = parseInt(nums[0]);
			var b = parseInt(nums[1]);
			if(b)
			{
				if((tdArrs[a]==arrTdCont[a])&&(tdArrs[b]==arrTdCont[b])) return false;
			}
			else
			{
				if(tdArrs[num]==arrTdCont[num]) return false;
			}
		}
	}
	var insertTr=tableId.insertRow(trIndex);
	if(typeof(bg)!="undefined")
	{
	
		insertTr.onclick=function()
		{
			if(tableID=="myFavoriteListT"){
				mf_flag = "1";
			}else{
				mf_flag = "0";
			} 
			clickTr(event);
		}
		insertTr.onmouseover=function()
		{
			insertTr.style.cursor="pointer";
			insertTr.style.background="#"+bg;
		}
		insertTr.onmouseout=function()
		{
			insertTr.style.cursor="none";
			insertTr.style.background="";
		}
	}
	//insertTr.setAttribute("id",codeChg("td_"+arrTdCont[0]));
	var arrTd=new Array();
	for(var i=0;i<arrTdCont.length;i++)
	{
		if(i==1){
			arrTd[i]=insertTr.insertCell(i);
			arrTd[i].setAttribute("id",codeChg(tableID+"td_"+arrTdCont[0]));
		}else{
			arrTd[i]=insertTr.insertCell(i);
			arrTd[i].setAttribute("id",tableID+"_tr"+trIndex+"_td"+i);			
		}
	}
	for(var i=0;i<arrTdCont.length;i++)
	{
		arrTdCont[i] = arrTdCont[i]+""
		arrTd[i].innerHTML=arrTdCont[i];
	}
}


 
</script>
</head>
<body onload="" style="overflow-y:auto; overflow-x:hidden;">
	<form  name="frmMain" action="" method="post">
<%@ include file="/npage/include/header_pop.jsp" %>

			<div class="mztree" id="tbc_02">
			<div class="product_chooseL" >
			    <div class="title">
					<div id="title_zi">�����Բ�ѯ</div>
				</div>

			<table cellspacing=0>
						<tr>			
							<td align="center">
							<input type="radio" name="query" id="query01" value="01" onclick="queryByNomal();" checked>��ͨ����
							<!--input type="radio" name="query" id="query02" value="03" onclick="queryByRentMac();">�������-->
							<%
				       if(!(opCode.equals("4977")) && !(opCode.equals("e887"))&& !(opCode.equals("m462"))){
				       %>
							<input type="radio" name="query" id="query03" value="04" onclick="queryByGoodNo();">�����������
							<%
							if(Integer.parseInt(cardLimit)  > 0){
							%>
							<input type="radio" name="query" id="query08" value="08" onclick="queryByNomal();">һ��˫��ҵ�񸱿�����
							<%}
							if("Y".equals(prodFuncArr[0])){
							%>
							<input type="radio" name="query" id="query11" value="11" >ǰ̨Ԥ����
							<%
							}
							if("Y".equals(prodFuncArr[1])){
							%>
							<input type="radio" name="query" id="query12" value="12" >ǰ̨У԰Ӫ��Ԥ����
							<%
							}
							if("Y".equals(prodFuncArr[2])){
							%>
							<input type="radio" name="query" id="query13" value="13" >��è����
							<%
							}
							if("Y".equals(prodFuncArr[3])){
							%>
							<input type="radio" name="query" id="query14" value="14" >�ƶ��̳ǿ���
							<%
							}
							
								}%>
						</td>
						</tr>
				</table>

					<table cellspacing=0 id="normal" style="display:none">
						<tr>
						<td class='blue' nowrap>����Ʒ����</td>
						<td>
						<input class="" name="offerName" value="" >
						</td>
						<td class='blue' nowrap>����Ʒ����</td>
						<td>
						<input class="" name="offerCode" value="" >
						</td>
					  </tr>
						<tr>
						<td class='blue' nowrap>Ʒ��</td>
						<td>
						
					   <SELECT name="smCode" id="smCode"  onchange="setOfferType()"> 
			       </SELECT>
					  </td>
					  
					  
				 <td class='blue' nowrap style="display:none">��������</td>
				 
				 <td style="display:none">
				  <SELECT name="receiveRegion" id="receiveRegion"> 
          </SELECT>
				 </td>
 
						<td class='blue' nowrap>����Ʒ����</td>
						<td >
					<SELECT name="offer_att_type" id="offer_att_type"> 
						<option value="">--��ѡ��--</option>
    			</SELECT>
						</td>
						</tr>
						<tr id='footer'>
						  <td colspan="4" align="center">
						  	<input class="b_foot" id="queryInfo1" type="button" value="��ѯ" onClick="productOfferQryByAttr()">
						  	<input class="b_foot" type="button" value="����" onClick="resetInfo();"></td>
						</tr>	
						</table>
					<table cellspacing=0 id="rentMac" style="display:none">
							<tr>
								<td class='blue'>��������</td>
								<td><input class="" name="imeiNo" value="�����봮��" onfocus='if(this.value=="�����봮��")this.value=""' onblur='if(this.value=="")this.value="�����봮��"' onKeyPress="if(event.keyCode == 13)getImei()">
									  <input type="button" class="b_text"  value="��ѯ" onclick="getImei();">
								</td>
								<td class='blue'>��ͬ��Ϣ��</td>
								<td><input class="" name="contractInfo" value="" readonly></td>
							</tr>
							<tr>
								<td class='blue'>���Ѻ��</td>
								<td><input class="" name="rentDeposit" value="" readonly></td>
								<td class='blue'>���Ԥ���</td>
								<td><input class="" name="rentCostPre" value="" readonly></td>
							</tr>
						<tr id='footer'>
						   <td colspan="4" align="center"><input class="b_foot" id="queryInfo2" type="button" value="��ѯ" onClick="qryByRentMac();"><input class="b_foot" type="button" value="����" onClick="resetInfo();"></td>
						</tr>	
						
					</table>
					<table cellspacing=0 id="betterNo" style="display:none">
							<tr>
							<td class='blue'>�������</td>
								<td>
									<input id="goodNo" class="required" name="goodNo" value="�������������" onfocus='if(this.value=="�������������")this.value=""' onblur='if(this.value=="")this.value="�������������"' onKeyPress="if(event.keyCode == 13)getGoodNo()">
								  <input type="button" id="queryFirst" class="b_text"  value="��ѯ" onclick="getGoodNo();">
								</td>
							
								<td class='blue'>������������</td>
								<td><input class="required" name="goodNoBlind" value="" readonly></td>
								
							</tr>	
							<tr>
								<td class='blue'>������Ԥ��</td>
								<td><input class="" name="blindNetPre" value="" readonly></td>
								<td class='blue'>�󶨸����ײ�</td>
								<td><input class="" name="blindAddCombo" value="" readonly></td>
								
							</tr>
							<tr style="display:none">
								<td class='blue'>������Ѻ��</td>
								<td><input class="" name="blindNetDeposit" value="" readonly></td>
								<td class='blue'>�󶨺�ͬ����</td>
								<td><input class="" name="blindContractDate" value="" readonly></td>
							</tr>
							<tr style="display:none">
								<td class='blue'>�󶨷��·���</td>
								<td><input class="" name="blindBackMonth" value="" readonly></td>
								
								
								<td class='blue'>�󶨸�����Ʒ</td>
								<td><input class="" name="blindSpecialSevice" value="" readonly></td>
							</tr>
							<!--modify by zhengyha 2009-4-30 21:02:30-->
							<tr style="display:none">
								
								<td class='blue'>���ܷ���</td>
								<td><input class="" name="blindCost" value="" readonly></td>
							</tr>
							
								 <tr id="trFGoodNo" style="display:none">
											<td class='blue' nowrap>Ʒ��</td>
									<td>
								   <SELECT name="smCodeFGood" id="smCodeFGood"  onchange="setOfferTypeFGood()"> 
						       </SELECT>
								  </td>
								  <td class='blue' nowrap>����Ʒ����</td>
									<td >
								<SELECT name="offer_att_typeFGood" id="offer_att_typeFGood"> 
									<option value="">--��ѡ��--</option>
			    			</SELECT>
								</td>
							</tr>
							<tr>
								<tr  id="trFGoodNo1" style="display:none">
									<td class='blue' nowrap>����Ʒ����</td>
									<td>
									<input class="" name="offerNameGood" value="" >
									</td>
									<td class='blue' nowrap>����Ʒ����</td>
									<td>
									<input class="" name="offerCodeGood" value="" >
									</td>
								</tr>
							</div>
							<tr id='footer'>
							<td colspan="4" align="center"><input class="b_foot" id="queryInfo3" type="button" value="��ѯ" onClick="qryByGoodNoType()">
								<input class="b_foot" type="button" value="����" onClick="resetInfo();"></td>
							</tr>	
					</table>	

			<!--��-->
			</div>
			</div>
			
			</div>
			
<div id="Operation_Table">
	
<div style="width:99%">
	<div style="">
		<div style="width:99%">
			<div class="product_chooseR" id="myFavoriteList" style="height:130px;float:left;width:50%; overflow-y:auto; overflow-x:hidden;">
				<div class="title"><div id="title_zi">���ղص�����Ʒ�б�</div></div>
						<div class="list" style="">
							<table id="myFavoriteListT" cellspacing=0>
								<tr>
									<th>����Ʒ����</th>
									<th>����Ʒ����</th>
									<th>Ʒ������</th>
									<th>����</th>
								</tr>
								
						 </table>
					     <!--<div id="changePageDiv"  style="font-size:12px" align="center">
			              <a href="#" onClick="changePage('myFavoriteListT','S')"> ��ҳ </a>
			              <a href="#" onClick="changePage('myFavoriteListT','P')"> ��һҳ </a>
			              <a href="#" onClick="changePage('myFavoriteListT','N')"> ��һҳ </a>
			              <a href="#" onClick="changePage('myFavoriteListT','E')"> βҳ </a>
			              &nbsp;&nbsp;��<span><input type="text" name="myFavoriteP" class="InputGrey" redOnly size=1></span>ҳ&nbsp;&nbsp;&nbsp;
			              &nbsp;&nbsp;&nbsp;<span>��ǰ��<input type="text" name="myFavoriteCP" class="InputGrey" redOnly size=1 value=1>ҳ</span>
				       	</div>-->
					  </div>
			 </div>
			<div class="product_chooseR" id="hotOfferQueryList" style="float:right;width:49%;">
				<div class="title"><div id="title_zi">�ȵ�����Ʒ�б�</div></div>
			
						<div class="list" style="height:130px; overflow-y:auto; overflow-x:hidden;">
							
							<table id="queryhotOfferList" cellspacing=0>
								<tr>
									<th>����Ʒ����</th>
									<th>����Ʒ����</th>
									<th>Ʒ������</th>
									<th>˵��</th>
								</tr>
								
						 </table>
						<!-- <div id="changePageDiv"  style="font-size:12px" align="center">
			              <a href="#" onClick="changePage('queryhotOfferList','S')"> ��ҳ </a>
			              <a href="#" onClick="changePage('queryhotOfferList','P')"> ��һҳ </a>
			              <a href="#" onClick="changePage('queryhotOfferList','N')"> ��һҳ </a>
			              <a href="#" onClick="changePage('queryhotOfferList','E')"> βҳ </a>
			              &nbsp;&nbsp;��<span><input type="text" name="hotOfferP" class="InputGrey" redOnly size=1></span>ҳ&nbsp;&nbsp;&nbsp;
			              &nbsp;&nbsp;&nbsp;<span>��ǰ��<input type="text" name="hotOfferCP" class="InputGrey" redOnly size=1 value=1>ҳ</span>
				       	</div>-->
					</div>
			</div>	
			
		</div>
	</div>	
</div>
		<div class="product_chooseR" ></div>
		<div class="title"><div id="title_zi">�����Բ�ѯ����б�</div></div>
			
			<div class="product_chooseR" id="productOfferQueryList" style="display:none">
			<div class="list" style="height:156px; overflow-y:auto; overflow-x:hidden;">
				<table id="queryOfferList" cellspacing=0>
					<tr>
						<th>����Ʒ����</th>
						<th>����Ʒ����</th>
						<th>Ʒ������</th>
						<th>˵��</th>
					</tr>
					</table>
				
				</div>
			</div>
<br>
<div class="title">
	<div id="title_zi">��ѡ����Ʒ�б�</div>

</div>

			<div class="list" style="height:156px; overflow-y:auto; overflow-x:hidden;">
				<table id="productOfferList" cellspacing=0>
					<tr>
						<th>����Ʒ����</th>
						<th>����Ʒ����</th>
						<th>Ʒ������</th>
						<th>����Ʒ�ʷ�����</th>
						<th>����</th>
					</tr>					
				</table>
			</div>
				
			<div id="footer" >
				<input type="button" class="b_foot" value="ȷ��" onclick="cfm()"/>
			</div>
			<input type="hidden" name="servBusId" value="">
			<input type="hidden" name="retMsg" value="">
			<input type="hidden" name="selectValue" id="selectValue" value="">
			<input type="hidden" name="payCode">     								<!--�ʷѴ���---->
		  <input type="hidden" name ="hid_rentCostPre" value =0.00>   <!--���Ԥ���-->   
		  <input type="hidden" name ="hid_rentDeposit" value =0.00>   <!--���Ѻ��-->
   	  <input type="hidden" name="hid_sale_mode" value="">	<!---�����ģ����Ϣ-->
   	  <input type="hidden" name="good" value="">
   	  
   	  <input type="hidden" name="result2" value="">
   	  <input type="hidden" name="result8" value="">
   	  <input type="hidden" name="result9" value="">
   	  <input type="hidden" name="result10" value="">
   	  <input type="hidden" name="result11" value="">
   	  <input type="hidden" name="result12" value="">
   	  <input type="hidden" name="result13" value="">
   	  <input type="hidden" name="result14" value="">
   	  
   	  <input type="hidden" name="goodNo_new" value="">
   	  <input type="hidden" name="retResultH" id="retResultH" value="">
   	  <input type="hidden" name="showPageNum" id="showPageNum" value="1"> <!--��ǰҳ����-->
   	  <input type="hidden" name="sumPageNum" id="showPageNum" value="1"> <!--��ҳ����-->
   	  <input type="hidden" name="numPerPage" id="numPerPage" value="15"> <!--ÿҳ��ʾ�ļ�¼��-->
   	  <input type="hidden" name="offerType" id="offerType" value="10">
   	  <%@ include file="/npage/include/footer_new.jsp" %>
	</form>
</div>
</body>
</html>
