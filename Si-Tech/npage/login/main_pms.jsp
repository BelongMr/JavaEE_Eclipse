<%
   /*
   * ����: ϵͳ�����
�� * �汾: v1.0
�� * ����: 2010-11-11 
�� * ����: hejwa
�� * ��Ȩ: sitech
   * �������绰����ϵͳ��ת��boss���ﳵ����
 ��*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType= "text/html;charset=GBK" %>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/wtc.tld" prefix="wtc" %>
<script type="text/javascript">
	window.opener=undefined
    window.parent=undefined
</script>	
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0);
	////��ֱֹ������URL����ģ��ҳ��
	String refererProxy=request.getHeader("referer");
	if(null==refererProxy||"".equals(refererProxy))
	{
	%>
			<script language="javascript">
				if(typeof(opener) == "undefined")
				{
				  //alert("��ֹ�Ƿ�����ҳ��!");
				  //window.opener=null;
				  //window.open("","_self");
              	  //window.close();	
        		}
		</script>
	<%
	}
%>
<%
//ȡsessionֵ
ArrayList retArray = (ArrayList)session.getAttribute("allArr");
String[][] lastInfo = (String[][])retArray.get(2);
String login_no   = (String)session.getAttribute("workNo");
String login_name = (String)session.getAttribute("workName");
String workNo = login_no;
String regionCode = (String)session.getAttribute("regionCode");
String cssPath = (String)session.getAttribute("cssPath");
String hotkey = (String)session.getAttribute("hotkey")==null?"Y":(String)session.getAttribute("hotkey");
String layout = (String)session.getAttribute("layout")==null?"2":(String)session.getAttribute("layout");
String phoneNoPms = (String)session.getAttribute("phoneNoPms")==null?"":(String)session.getAttribute("phoneNoPms");

		
%>
<%@ include file="./getCssPath.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">		
<head> 
	<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
	<title>�������ƶ��ۺϿͻ�����ϵͳ</title>
	<link href="<%=request.getContextPath()%>/nresources/<%=cssPath%>/css/framework.css" rel="stylesheet" type="text/css" />
	<link href="<%=request.getContextPath()%>/nresources/<%=cssPath%>/css/rightmenu.css" rel="stylesheet" type="text/css" />
	<style>
		#imgLeftRight{
			position:absolute;
			left:0px;
			top:300px;
			height:50px;
			width:6px;	
			z-index:10000;
		}
	</style>
</head>
<body>		
	<!--topPanel begin-->
	<%@ include file="../module/topPanel.jsp"%>
	<!-- �洢ajax���÷��ص�html -->
	<div id="ajaxResult" style="display:none"></div>
	<!--topPanel end-->

	<!--searchPanel begin-->
<div style="display:none">
	<%@ include file="../module/searchPanel.jsp"%>
</div>
	<!--searchPanel end-->
	
	<!--ContentArea bengin-->
	<div id="contentPanel">
		
		<!--navPanel begin-->
	<div style="display:none">
		<%@ include file="../module/navPanel.jsp"%>
	</div>
		<!--navPanel end-->
		<div id="borderWorkAndNav"></div>
		<!--workPanel begin-->
		<%@ include file="../module/workPanel_pms.jsp"%> 
		<!--workPanel end-->
	</div>
	<!--footPanel begin-->
	<div style="display:none">
		<%@ include file="../module/footPanel.jsp"%>
	</div>
	<!--footPanel end-->
	<!--��ֹҳ������-->	
	<noscript>
	<iframe src=""></iframe>
	</noscript>
<div id="currUserId" style="display:none"></div>
<div id="currPhoneNo" style="display:none"></div>
<div id="currBrandId" style="display:none"></div>
<div id="currBrandName" style="display:none"></div>
<div id="currMasterServId" style="display:none"></div>
<div id="currMasterServName" style="display:none"></div>
<div id="currMainProdId" style="display:none"></div>
<div id="currMainProdName" style="display:none"></div>
<div id="userFinishFlag" style="display:none"></div>
<div id="contentArr" style="display:none"></div>
<div id="targetUrlDiv" style="display:none"></div>
<script src="<%=request.getContextPath()%>/njs/system/jquery-1.3.2.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/njs/system/system.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/njs/plugins/autocomplete.js"  type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/njs/plugins/tabScript_jsa_pms.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/njs/plugins/MzTreeView12.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/njs/redialog/redialog.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">

var iCustId = "";
var iPhoneNo = "index";

//��ѯһ���˵�
function loadFirstMenu(){
	var packet =  new AJAXPacket("ajax_queryFirstMenu.jsp");
	core.ajax.sendPacketHtml(packet,doLoadFirstMenu);
	packet = null;

}

function doLoadFirstMenu(data){
	$("#ajaxResult").html(data);//���ط��ص�Html
	
	var retCode = $("#divRetCode").html();
	var retMsg = $("#divRetMsg").html();

	if(retCode=="0"){

		$("#oli").html($("#divShowFirstMenu").html());//data�а���divShowFirstMenu
		$("#otherFirstMenu").html($("#divOtherFirstMenu").html());//data�а���divOtherFirstMenu

	}else{
		showDialog(retMsg,0);
	}
}

/**************����ԭ��framework.js�Ĵ���*********/
// ���岼��
function layoutSwitch(n){
		
	$("#layoutStatus").val(n);
	
	$("#a1").attr("class","aSpace");
	$("#a2").attr("class","bSpace");
	$("#a3").attr("class","cSpace");
	$("#a4").attr("class","dSpace");
	
	
	if (n==1){//���������
		$("#navPanel").hide();
		$("#topPanel").hide();	
		$("#workPanel").css("margin-left","4px");
		$("#a1").attr("class","aSpaceOn");
	}
	if(n==2){//�ָ�������ͼ
		$("#topPanel").show();
		$("#navPanel").show();
		$("#workPanel").css("margin-left","201px");
		$("#a2").attr("class","bSpaceOn");
	}
	if(n==3){//����topPanel���
		$("#topPanel").hide();
		$("#navPanel").show();
		$("#workPanel").css("margin-left","201px");
		$("#a3").attr("class","cSpaceOn");
	}
	if(n==4){//����navPanel���
		$("#topPanel").show();
		$("#navPanel").hide();
		$("#workPanel").css("margin-left","4px");
		$("#a4").attr("class","dSpaceOn");
	}
	
	initPanel(n);
}

function initPanel(n){
	var marginHeight=9;
	if(n==1){
		$("#contentPanel").height($("body").height()-$("#searchPanel").height()-$("#footPanel").height()-marginHeight);	
	}else if(n==2){
		$("#contentPanel").height($("body").height()-$("#topPanel").height()-$("#searchPanel").height()-$("#footPanel").height()-marginHeight);	
	}else if(n==3){
		$("#contentPanel").height($("body").height()-$("#searchPanel").height()-$("#footPanel").height()-marginHeight);	
	}else if(n==4){
		$("#contentPanel").height($("body").height()-$("#topPanel").height()-$("#searchPanel").height()-$("#footPanel").height()-marginHeight);	
	}
	$("#contentArea").height($("#workPanel").height()-$("#tab").height()-3);
	setIframe();
	setNav("N");
}

//����һ��TAB��iframe�߶ȡ�����
function setIframe()
{
	var workPanel=g("workPanel");
	var tab=g("tab");
	var workPanelHeight=workPanel.clientHeight;
	var workPanelWidth=workPanel.clientWidth;
	var tabHeight = tab.clientHeight;
	var iframe=workPanel.getElementsByTagName("iframe");
	for(var i=0;i<iframe.length;i++)
	{
		iframe[i].style.height=(workPanelHeight-tabHeight)+"px";
		iframe[i].style.width=(workPanelWidth)+"px";
	}
}

//���õ����������ݵĸ߶�,flag:tree��ģ������
function setNav(flag)
{
	var marginHeight=3;
	if(flag == "tree")
	{
		$(".search_bar").show();
		$(".dis").height($("#navPanel").height()-$(".title").height()-$(".search_bar").height()-marginHeight-14);
	}else{
		$(".search_bar").hide();
		$(".dis").height($("#navPanel").height()-$(".title").height()-marginHeight-14);
	}
}

/************************************ topPanel ************************************/

//һ����Ŀ�л�
function HoverMenu(object,subobject)
{
	var tag=g(object).getElementsByTagName(subobject);
	for(var i=0;i<tag.length;i++)
	{
		(function(j){
			tag[j].onclick=function()
			{
				for(var n=0;n<tag.length;n++)
				{
					tag[n].className="";
				}
				tag[j].className="on";
				HoverNav("tree",tag[j].opcode,tag[j].opname);
			}
		})(i);
	}
}
var isExit = "0"; //Ĭ��Ϊֱ�ӹر�
 /*
   ���ӱ�������ϵͳ�˳�ʱ�رյ�������
 */
var winArray = new Array();
var nameArray = new Array();
function addWinName(obj,name){
	var flag = 0 ;
	var length = nameArray.length;
	for ( i=0; i<length; i++ ){
		if ( nameArray[i] == name ){
			flag = 1;
			break;
		}
	} 
	if ( flag == 0 ){
		winArray[length] = obj;
		nameArray[length] = name;
	}
	//alert("add done!");
}
//�������˳�ϵͳ
function closeWindow(){
	 var sendop_code = {};
	 sendop_code["workNo"] = "<%=login_no%>";
	 $.ajax({
			   url: 'sDCustOrder.jsp',
			   type: 'POST',
			   data: sendop_code
	 });
	 sendop_code=null;
	 for ( i=0; i<winArray.length; i++ ){
		try{
		     winArray[i].close();	
		    }catch(e){
		    	alert(e);
		    }
	 }
    var prop="dialogHeight:150px; dialogWidth:320px; status:no;unadorned:yes";
    window.showModalDialog("logout.jsp?loginNo=<%=login_no%>","",prop);
    window.opener=null;
    window.open('','_self');
    window.close();
}
/*
function doExit(){
	isExit = "1"; //���˳���ť 
	var prop="dialogHeight:122px; dialogWidth:402px; status:no;unadorned:yes";
	window.showModalDialog("logout2.jsp","",prop);
	window.opener=null;
	window.open('','_self');
	window.close();
}
*/

/************************************ searchPanel *********************************/
function chgLoginType()//�����û���½����������
{
	var select_panel = $(".select_panel");
	var select_panel_detail = $(".select_panel p");
	if(select_panel.css("display") == "none"){
		select_panel.css("display","block");
		select_panel_detail.hover(
			function(){
				$(this).css("background-color","#fefe9c");
				this.style.cursor = "hand";
			},
			function(){
			  $(this).css("background-color","");
				this.style.cursor = "point";
		  }
		);
		select_panel_detail.click(function(){
			$("#loginType").val(this.innerText);
			$("#loginType").attr("loginType",this.value);
			doChangeType(this);
			$("#phoneNo").val("��������Ϣ���в�ѯ(Alt+1)");
			//��������֤����ͼ������			
			if(this.value==="12"){
				$(".serverNum .ico_id").css("display","");
			}else{
				$(".serverNum .ico_id").css("display","none");
			}
		});
	}else{
		select_panel.css("display","none");
	}
}

function clearPhoneNo()//����û���½����
{
	$("#phoneNo").val("");
}
function clearCustName()
{
	$("#iCustName").val("");
}

//�ж��Ƿ��Ѿ��򿪿ͻ���ҳ
function isTabExist()
{
	var tabSize = $("#contentArea iframe").size();
	for(var i=0;i<tabSize;i++)
	{
		if($("#contentArea iframe")[i].id.length>12)
		{
			if($("#contentArea iframe")[i].id.substring(0,12)=="iframecustid")
			{
				showDialog("������굱ǰ�ͻ������������ͻ�",1);
				return false;
			}
			if($("#contentArea iframe")[i].id.substring(0,15)=="iframecustLater")
			{
				showDialog("������굱ǰҵ�������������ͻ�",1);
				return false;
			}
		}
	}
	return true;
}

/*����
function addTabBySearch()
{
	if(!isTabExist()) return false;
		
	var phoneNo = $("#phoneNo").val();
	if(phoneNo=="��������Ϣ���в�ѯ(Alt+1)"||phoneNo=="")
	{
		showDialog("�������ѯ����",1);
		return false;
	}
	
	var loginType = $("#loginType").attr("loginType");
	if(loginType==="11")
	{
		openDivWin("getUserList.jsp?phoneNo="+phoneNo+"&loginType="+loginType,'�û��б�','600','400');
	}else{
		getCustId(phoneNo,loginType);		
	}
}
*/
	function addTabBySearch(enterType)
	{
		 //����ǰ�ť�������
  	 if(enterType=='button')
  	 {
  	 	 var phoneNo = $("#phoneNo2").val();
  	 	 $("#phoneNo2").val("");
  	 }
  	 //�س�����
  	 else
  	 {
  	 	 var phoneNo = $("#phoneNo").val();
  	 }

	 var patrn=/^((\(\d{3}\))|(\d{3}\-))?[12][03458]\d{9}$/;
     if(phoneNo!=""&&(phoneNo.search(patrn)!=-1))
     {
				var sendphone_no = {};
				sendphone_no["phone_no"] = phoneNo;

				 $.ajax({
				    url: 'check_phoneno.jsp',
				    type: 'POST',
				    data: sendphone_no,
				    error: function(data){
								if(data.status=="404")
								{
								  alert( "�ļ�������!");
								}
								else if (data.status=="500")
								{
								  alert("�ļ��������!");
								}
								else{
								  alert("ϵͳ����!");
								}
				    },
				    success: function(ret_code){
				      if(ret_code.trim()=="000000"){
								$("#phoneNo").val("");
								addTab(true,phoneNo,phoneNo,'childTab2.jsp?activePhone='+phoneNo);
						  }else{
								rdShowMessageDialog("�ֻ�������Ϣ����ȷ,��Tabҳ����!");
				      }
				      $("#phoneNo").val("�������ֻ�����");
				    }
					});
					sendphone_no=null;
		 }
	}
	

function  getCustId(phoneNo,loginType,idNo){
	if(typeof(idNo)==="undefined") idNo = -1;
	var packet = new AJAXPacket("ajax_getcustid.jsp");
	packet.data.add("phoneNo" ,$.trim(phoneNo));
	packet.data.add("loginType" ,loginType);
	packet.data.add("idNo" ,idNo);
	core.ajax.sendPacket(packet,doGetCustId,true);
	packet =null;
}

function doGetCustId(packet)
{
	var retCode = packet.data.findValueByName("retCode");
	var retMsg = packet.data.findValueByName("retMsg");
	var detailMsg = packet.data.findValueByName("detailMsg");
	var custIdArr = packet.data.findValueByName("custIdArr");
	var custNameArr = packet.data.findValueByName("custNameArr");
	var custAddrArr = packet.data.findValueByName("custAddrArr");
	var staffArr = packet.data.findValueByName("staffArr");
	var contactArr = packet.data.findValueByName("contactArr");
	var loginType = packet.data.findValueByName("loginType");
	var phone_no = packet.data.findValueByName("phone_no");
	var signUserArr = packet.data.findValueByName("signUserArr");
	var id_no = packet.data.findValueByName("idNo");
	if(retCode!="0")
	{
		showDialog(retMsg,0,"detail="+detailMsg);
		return false;
	}else
	{
		if(custIdArr.length==1)
		{
			openCustMain(custIdArr,custNameArr,loginType,phone_no,signUserArr,id_no);
		}else if(custIdArr.length>1)
		{
			var phoneNo = $("#phoneNo").val();
			var loginType = $("#loginType").attr("loginType");
			var path="selectCustId.jsp?phone_no="+phoneNo+"&loginType="+loginType+"&idNo="+id_no;
			openDivWin(path,'ѡ��ͻ�','600','400');
		}else{
			showDialog("û�в�ѯ�����������Ŀͻ���",0);
		}
	}
	
	$("#phoneNo").val("��������Ϣ���в�ѯ(Alt+1)");
}
//��������֤����
function btnReadID2()
{
  try{		
	  if(IDCard1.Syn_ReadMsg(1001)!=0){
	       showDialog("�������������·ſ�!",0);
	       return false;
	  }
	  var cardNo = IDCard1.IDCardNo;//����֤����
	  $("#phoneNo").val(cardNo);
		  
	 }catch(e){
	 	  showDialog("������������ϵ����Ա��",0);
	 }
}
//��ʽ���ͻ�����
function formatString(sstr){
	var _temp = typeof(sstr)=="object"?sstr[0]:sstr;
	
	if(_temp===""||_temp.length===1){
		 return _temp;
	}else{
		var _first = _temp.substring(0,1);	
		_temp = _temp.substring(1);
		for(var i=0;i<_temp.length;i++){
			_temp = _temp.replace(_temp.charAt(i),"*");	
		}
		return (_first+_temp);
	}
}

function addTabBySearchCustName(phoneNo)
{
	var packet = new AJAXPacket("getCustId.jsp");
	packet.data.add("phoneNo" ,phoneNo);
	packet.data.add("loginType" ,"1");
	core.ajax.sendPacket(packet,doGetCustId,true);
	packet =null;
}
		
function doGetCustId(packet)
{
	var retCode = packet.data.findValueByName("retCode");
	var retMsg = packet.data.findValueByName("retMsg");
	var custIdArr = packet.data.findValueByName("custIdArr");
	var custNameArr = packet.data.findValueByName("custNameArr");
		
	var custIccidJ = packet.data.findValueByName("custIccid");
	var custCtimeJ = packet.data.findValueByName("custCtime");


	var loginType = packet.data.findValueByName("loginType");
	var phone_no = packet.data.findValueByName("phone_no");
	if(retCode!="0")
	{
		rdShowMessageDialog(retCode+","+retMsg,0);
		return false;
	}else
	{
		if(custIdArr.length==1)
		{
				parent.openCustMain(custIdArr,custNameArr,loginType,phone_no);
		}else
		{
				var path="selectCustId.jsp?opName=ѡ��ͻ�&custIdArr="+custIdArr+"&custNameArr="+custNameArr+"&custIccid="+custIccidJ+"&custCtime="+custCtimeJ+"&loginType="+loginType;
				//openDivWin(path,'ѡ��ͻ�','600','400');
				window.open(path,"newwindow","height=600, width=600,top=50,left=250,scrollbars=yes, resizable=no,location=no, status=yes");
		}
	}
			
	$("#phoneNo").val("��������Ϣ���в�ѯ");
}
function openCustMain(custId,custName,loginType,phone_no)
{
	//alert("openCustMain#custId|"+custId+"\ncustName|"+custName+"\nloginType|"+loginType+"\nphone_no|"+phone_no);
    iCustId = custId;
	if($("#contentArea iframe").size() < 11){
		addTab(true,"custid"+custId,custName,'childTab2.jsp?gCustId='+custId+'&loginType='+loginType+'&phone_no='+phone_no+'&activePhone='+phone_no);
		$("#phoneNo").val("��������Ϣ���в�ѯ").blur();
		//document.all.phoneNo.blur();
		//layoutSwitch(1,$(".a1")[0]);
	}else{
		rdShowMessageDialog("ֻ�ܴ�10��һ��tab");
	}
}
/* ����
function openCustMain(custId,custName,loginType,phone_no,signUser,id_no)
{
	showWinCover();
	if($("#contentArea iframe").size() < 11){
		addTab(true,"custid"+custId,formatString(custName),'childTab.jsp?gCustId='+custId+'&loginType='+loginType+'&phone_no='+phone_no+'&signUser='+signUser+"&idNo="+id_no+"&isMarket=true");
		$("#phoneNo").val("��������Ϣ���в�ѯ(Alt+1)");
		document.all.phoneNo.blur();
		bindRemoveTab("custid"+custId);
	}else{
		showDialog("ֻ�ܴ�10��һ��tab",1);
	}
}
*/
//������ɣ��򿪿ͻ���ҳ
function openCustMainForNewUser(custId,custName,loginType,phone_no,contactId,idNo,opType)
{
	if(!isTabExist()) return false; //��ֹ�������ͻ���ҳ
	if(loginType==="PHONE_NO") loginType="11";  //�������ô˷����ĵط���д��ΪPHONE_NO,Ϊ��������޸ģ�ת��Ϊ���ݿ��е�����
	showWinCover();
	if($("#contentArea iframe").size() < 11){
		addTab(true,"custid"+custId,formatString(custName),'childTab.jsp?gCustId='+custId+'&loginType='+loginType+'&phone_no='+phone_no+'&contactId='+contactId+'&idNo='+idNo+'&opType='+opType);
		
		bindRemoveTab("custid"+custId);
	}else{
		showDialog("ֻ�ܴ�10��һ��tab",1);
	}
}
//�Ӵ�������������򿪿ͻ���ҳ
function openCustMainForUnset(custId,custName,loginType,phone_no,signUser,unsetFrom,contentArr,idNo)
{	
	if(!isTabExist()) return false; //��ֹ�������ͻ���ҳ
	if(loginType==="PHONE_NO") loginType="11";  //�������ô˷����ĵط���д��ΪPHONE_NO,Ϊ��������޸ģ�ת��Ϊ���ݿ��е�����
	showWinCover();
	$("#contentArr").val(contentArr);
	if($("#contentArea iframe").size() < 11){
		addTab(true,"custid"+custId,custName,'childTab.jsp?gCustId='+custId+'&loginType='+loginType+'&phone_no='+phone_no+'&signUser='+signUser+'&unsetFrom='+unsetFrom+'&idNo='+idNo);
		
		bindRemoveTab("custid"+custId);
	}else{
		showDialog("ֻ�ܴ�10��һ��tab",1);
	}
}

function openCustMainGetCar(custId,custName,custOrderId)
{
	/*
	var tabSize = $("#contentArea iframe").size();
	for(var i=0;i<tabSize;i++)
	{
		if($("#contentArea iframe")[i].id.length>12)
		{
			if(($("#contentArea iframe")[i].id.substring(0,12)=="iframecustid")&&($("#contentArea iframe")[i].id!="iframecustid"+custId))
			{
				rdShowMessageDialog("������굱ǰ�ͻ������������ͻ�");
				return false;
			}
		}
	}
	*/
	if($("#contentArea iframe").size() < 11){
		addTab(true,"custid"+custId,custName,'childTab2.jsp?gCustId='+custId+'&custOrderId='+custOrderId);
		$("#phoneNo").val("��������Ϣ���в�ѯ");
		//document.all.phoneNo.blur();
		//layoutSwitch(1,$(".a1")[0]);
	}else{
		rdShowMessageDialog("ֻ�ܴ�10��һ��tab");
	}
}

function doChangeType(obj){
    var type = obj.value;
    if(type == "0"){
        $("#iCustName").val("������ͻ�ID���в�ѯ");
    }else if(type == "1"){
        $("#iCustName").val("�������ֻ������ѯ");
    }else if(type == "2"){
        $("#iCustName").val("�������ʻ�ID���в�ѯ");
    }else if(type == "4"){
        $("#iCustName").val("������֤��������в�ѯ");
    }else if(type == "6"){
        $("#iCustName").val("������ͻ����Ʋ�ѯ");
    }else{
        $("#iCustName").val("��������Ϣ���в�ѯ");
    }
}

function newCustF(){
		L("1","1100","�ͻ�����","sq100/sq100_1.jsp","000");
	}
function dnyCreatDiv(cust_id,phone_no){
    if(document.getElementById(cust_id)){
        document.getElementById(cust_id).parentNode.removeChild(document.getElementById(cust_id));
    }
    
	var newE = document.createElement("DIV");
    
    newE.id = cust_id;
    newE.phone_no=phone_no;
    //newE.innerHTML = "this is a test div " + new Date() + "<br/>";
    // newE.style.borderStyle = "solid";
    //newE.style.borderColor = "Red";
    newE.style.display = "none";

    //document.getElementById("div1").appendChild(newE);
    document.getElementById("borderWorkAndNav").insertBefore(newE,null);
    //document.body.appendChild(newE);
}

//BEGIN ����ת��
var quickFlag = true;	
var content_array;//���ٵ��� 0: openWay 1:functionCode 2:functionName 3:url 4:passFlag �Կո����
var opStr_quick = ""; //ϵͳģ������ ��ʽ"0121 ǩ�� QT,...."

function initSearch(){
	
	//����ģ��
	$("#funcText").focus(function(){
		focusQuickNav(this)
	});
	$("#funcText").blur(function(){
		if($("#funcText").val() == ""){
			$("#funcText").val("����ģ�� (Alt+3)");
		}
	});
	
	//����ת��
	$("#tb").focus(function(){
		focusQuickNav(this)
	});
	$("#tb").blur(function(){
		if($("#tb").val() == ""){
			$("#tb").val("����ת�� (Alt+2)");
		}
	});
}

function focusQuickNav(obj)
{
	if(quickFlag){
		quickFlag = false;
		obj.value="���ݼ�����...";
		//getQuickNavData(obj);
	}else{
 		obj.value="";
	}
}

function getQuickNavData(obj)
{
	var packet = new AJAXPacket("getQuickNavData.jsp","���Ժ�...");
	packet.data.add("objId" ,obj.id);
	core.ajax.sendPacket(packet,doProcessNav,true);//�첽
	packet = null;
}

function doProcessNav(packet)
{
  content_array = packet.data.findValueByName("contentStr");
  opStr_quick = packet.data.findValueByName("opStr");
  objId  = packet.data.findValueByName("objId");
  //actb(document.getElementById('tb'),document.getElementById('tb_h'),eval(opStr_quick));
  $("#"+objId).val("");
	$("#"+objId).blur();
	$("#"+objId).focus();
}

function initQuickNav()
{
 	document.getElementById('tb').value="����ת�� (Alt+2)";
}

function quicknav(arr)
{
	if(document.getElementById('tb_h').value!=-1)
	{
		L(arr[0],arr[1],arr[2],arr[3],arr[4]);
	}
}

function turnLock(obj)
{
	if(obj.className=="keyOn")
	{
		document.getElementById('tb').readOnly=true;
		obj.className="key";
		$('#tb').unbind('focus');
	}else{
		document.getElementById('tb').readOnly=false;
		obj.className="keyOn";
		
		quickFlag = true;
		$("#tb").focus(function(){
			focusQuickNav(this);
		});
	}
}
//END ����ת��

/************************************ navPanel ************************************/
// ����ϵͳ����
function searchFunc(keyword){

  var keyword = $.trim(keyword).toUpperCase();
	if(keyword == ""){
		 return;
	}else if(keyword.length < 2){
		alert("������������������",0);
		return;	
	}
	
	var isFunctionExit = false;
	var htmlString = "";
	opStr_quick = eval(opStr_quick);
	for(i=0;i<opStr_quick.length-1;i++){
		var temp = opStr_quick[i].split(" ");
		if((temp[0]).indexOf(keyword) != -1 || (temp[1]).indexOf(keyword) != -1 || ($.trim(temp[2]).toUpperCase()).indexOf(keyword) != -1){
		isFunctionExit = true;
		htmlString += "<li><a href=javascript:L(\""+content_array[i][0]+"\",\"" + content_array[i][1] + "\",\"" + content_array[i][2] +"\",\"" + content_array[i][3] +  
		"\",\""+ content_array[i][4] + "\");>" + "["+ temp[0] + "]" + temp[1] + "</a></li>";
		}
	}
	
	if(!isFunctionExit){
		htmlString += "���ܲ�����";
	}

	$('#functionResult').html(htmlString);
	$('#wait').hide();
	$('#system_search_result').show();
}

//�������л�;
function HoverNav(flag,parentNode,parentName){
	//����
	$.each( $(".navMain > div"), function(i, n){
		  $(".navMain > div")[i].className="undis";
	});
	
	$("#wait").show();
	if(flag =="fav")
	{
		$("#getFavFunc").addClass("on");
		$("#getTree").removeClass("on");
		$("#getAllTree").removeClass("on");
		//$("#getAuthorizeTree").removeClass("on");
		getFavFunc(flag);
	}else if(flag =="tree"){
		$("#getTree").addClass("on");
		$("#getFavFunc").removeClass("on");
		$("#getAllTree").removeClass("on");
		//$("#getAuthorizeTree").removeClass("on");
		getTree(parentNode,parentName);
	}else if(flag =="alltree"){
		$("#getAllTree").addClass("on");
		$("#getTree").removeClass("on");
		$("#getFavFunc").removeClass("on");
		//$("#getAuthorizeTree").removeClass("on");
		getTree(parentNode,parentName);
	}else if(flag =="authorizetree"){
		//$("#getAuthorizeTree").addClass("on");
		$("#getTree").removeClass("on");
		$("#getAllTree").removeClass("on");
		$("#getFavFunc").removeClass("on");
		getAuthorize();
	}
		
}

function reloadFavFunc(){
    //$("#node_favfunc").empty();
	var packet = new AJAXPacket("getFavFunc.jsp");
	core.ajax.sendPacketHtml(packet,doReloadFavFunc);
	packet =null;
}

function doReloadFavFunc(data){
    $("#node_favfunc").empty();
    $('#node_favfunc').html(data);
}

function getFavFunc(nodename)
{
	var node_favfunc = document.getElementById("node_favfunc");
	//alert(node_favfunc);
	if(node_favfunc == null)
	{
		node_favfunc = document.createElement("div");
		node_favfunc.setAttribute("className","dis");
		node_favfunc.setAttribute("id","node_favfunc");
		$(".navMain")[0].appendChild(node_favfunc);
			
		var packet = new AJAXPacket("getFavFunc.jsp");
		core.ajax.sendPacketHtml(packet,doGetFavFunc);
		packet =null;
	}else{
		setNav("fav");
		$('#node_favfunc')[0].className="dis";
		$("#wait").hide();
	}
}
 
function doGetFavFunc(data)
{
	setNav("fav");
	$("#wait").hide();
	$('#node_favfunc').html(data);
}

function getTree(parentNode,parentName)
{
	var treenode = document.getElementById("node"+parentNode);
	if(treenode == null)
	{
		treenode = document.createElement("div");
		treenode.setAttribute("className","dis");
		treenode.setAttribute("id","node"+parentNode);
		$(".navMain")[0].appendChild(treenode);
		
		var packet = new AJAXPacket("getTree.jsp");
		packet.data.add("parentNode" ,parentNode);
		packet.data.add("parentName" ,parentName);
		core.ajax.sendPacketHtml(packet,doGetTree);
		packet =null;
	}else{
		setNav("tree");
		treenode.className="dis";
		$("#wait").hide();
	}
}
 
function doGetTree(data)
{
	setNav("tree");
	$("#wait").hide();
	var currnode ;
	$.each( $(".navMain > div"), function(i, n){
		  if($(".navMain > div")[i].className=="dis")
		  {
		  	currnode=$(".navMain > div")[i].id;
		  	return false;
		  }
	}); 
	$("#"+currnode)[0].className="dis";
	$("#"+currnode).html(data);
}

function getAuthorize()
{
	
	var node_authorize = document.getElementById("node_authorize");
	if(node_authorize == null)
	{
		node_authorize = document.createElement("div");
		node_authorize.setAttribute("className","dis");
		node_authorize.setAttribute("id","node_authorize");
		$(".navMain")[0].appendChild(node_authorize);
			
		var packet = new AJAXPacket("ajax_getAuthorizeTree.jsp");
		core.ajax.sendPacketHtml(packet,doAuthorize);
		packet =null;
	}else{
		setNav("tree");
		$('#node_authorize')[0].className="dis";
		$("#wait").hide();
	}
}
 
function doAuthorize(data)
{
	setNav("tree");
	$("#wait").hide();
	$('#node_authorize').html(data);
}

//BEGIN HotKey
function getHotKey()
{
	var packet = new AJAXPacket("getHotKey.jsp");
  core.ajax.sendPacketHtml(packet,doProcessHotKey,true);
  packet =null;
}

function doProcessHotKey(data)
{
    var hotKeyScript = document.createElement("div");
	hotKeyScript.setAttribute("id","hotKeyScript");
	document.body.appendChild(hotKeyScript);
	$('#hotKeyScript').html(data);
}
//END HotKey
	
/* ����
function getHotKey()
{
	var packet = new AJAXPacket("ajax_gethotkey.jsp");
	core.ajax.sendPacketHtml(packet,doGetHotKey,true);
	packet =null;
}
	
function doGetHotKey(data)
{
	var hotKeyScript = document.createElement("div");
	hotKeyScript.setAttribute("id","hotKeyScript");
	document.body.appendChild(hotKeyScript);
	$('#hotKeyScript').html(data);
}
*/

function showFavMenu(functionCode)  //չ�ֳ���ģ���Ҽ��˵�
{
	var favMenu = document.getElementById('favMenu');
	
	var  rightedge  =  document.body.clientWidth-event.clientX; 
	var  bottomedge  =  document.body.clientHeight-event.clientY; 
	if  (rightedge  <  favMenu.offsetWidth) 
		favMenu.style.left  =  document.body.scrollLeft  +  event.clientX  -  favMenu.offsetWidth; 
	else 
		favMenu.style.left  =  document.body.scrollLeft  +  event.clientX; 
	if  (bottomedge  <  favMenu.offsetHeight) 
		favMenu.style.top  =  document.body.scrollTop  +  event.clientY  -  favMenu.offsetHeight-45; 
	else 
		favMenu.style.top  =  document.body.scrollTop  +  event.clientY-65; 
	favMenu.style.display  =  "block"; 
	
	activateTab('index');
	
	$('#favMenu #delIcon').bind('click',function(){
		addFavfunc(functionCode,"d","0");
	});
	
	$('#favMenu #editIcon').bind('click',function(){
		//addTab(true,'index','�����ռ�','../portal/work/portal.jsp');
		//document.getElementById("ifram").contentWindow.openDivWin("/npage/portal/work/modifyHotKey.jsp","�Զ����ݼ�","300","400");
		//hideFavMenu();
		});
		
	$('#favMenu #helpIcon').bind('click',function(){
		callHelp(functionCode)
	});
}
$(document).click(function(){
	hideFavMenu();
	
	})

function  hideFavMenu() //���س���ģ���Ҽ��˵�
{
	favMenu.style.display  =  "none"; 
	
	$('#favMenu #delIcon').unbind('click');
	$('#favMenu #editIcon').unbind('click');
}

/*
*�������ù���
*id ��ģ�����(function_code)
*op_type:��������(a,���ӳ��ù���;d,ɾ�����ù���;u,�޸�����˳��)
*/
function addFavfunc(function_code,op_type,show_order)
{
	var  f = function_code.indexOf("custLater");
	if(f>-1)function_code = function_code.substr(f+9);
	if(function_code.indexOf("custid")>-1||$.trim(function_code)==""){
		showDialog("��ǰ���ܲ��ܼ��볣�ù��ܣ�",1);
		return false;
	}
	var packet = new AJAXPacket("favfunc_cfm.jsp");
	packet.data.add("function_code",function_code);
	if(typeof(op_type)=="undefined"){
		packet.data.add("op_type","i");//a-���ӳ��ù���ʱֻ���������һ������
	}else{
		packet.data.add("op_type",op_type);
	}
	core.ajax.sendPacket(packet,doFavfunc,true);
	packet =null;
}

function doFavfunc(packet)
{
	
	var retCode = packet.data.findValueByName("retCode");
	var retMsg = packet.data.findValueByName("retMsg");
	var detailMsg = packet.data.findValueByName("detailMsg");
	if(retCode=="000000"){
		
		showDialog("�����ɹ�",2);


		//ˢ����ೣ�ù�����
		$(".navMain")[0].removeChild(document.getElementById("node_favfunc"));
		HoverNav('fav');

		//ˢ�¹����ռ�ĳ��ù���
		document.frames["ifram"].loadLoginMdl();

		//ˢ�¿ͻ���ҳ���ù�����
		var tabSize = $("#contentArea iframe").size();
		for(var i=0;i<tabSize;i++)
		{
			if($("#contentArea iframe")[i].id.length>12)
			{
				if($("#contentArea iframe")[i].id.substring(0,12)=="iframecustid")
				{
					var custIframeId = $("#contentArea iframe")[i].id;
					
					document.frames[custIframeId].frames["user_index"].getFavFunc();
				}
			}
		}

	}else{
		showDialog(retMsg,0,"detail="+detailMsg);
	}
}

function tempAuthorize(pop_type,function_code,function_name,jsp_name,auFlag){
    if(pop_type=="2")
    {
        if(g_activateTab.substr(0,6)=="custid"){
               top.openDivWin("/npage/login/tempGrant.jsp?pop_type="+pop_type+"&function_code="+function_code+"&function_name="+function_name+"&jsp_name="+jsp_name+"&auFlag="+auFlag,'��ʱ��Ȩ','505','294');
		}else
		{
				showDialog("��ѡ��Ҫ�����Ŀͻ�!",1);
		}
    }else
    {
    	top.openDivWin("/npage/login/tempGrant.jsp?pop_type="+pop_type+"&function_code="+function_code+"&function_name="+function_name+"&jsp_name="+jsp_name+"&auFlag="+auFlag,'��ʱ��Ȩ','505','294');
    }
}

/************************************ workPanel ************************************/
function callHelp(tabId)//����ϵͳ
{
	window.open("../help/h"+tabId+".html");
}

function comment(tabId)//ģ������
{
    /*ģ�����ָ���Ϊ��ѯ�������
	var path = "/npage/public/rating.jsp";
	openDivWin(path,'ģ������','405','194');
	*/
	L("1","1560","��ѯ�������","../npage/s1300/s1560.jsp","000");
}

var g_activateTab = "index";//active tabId
function activateTab(id)
{
    g_activateTab = id;
	if(document.getElementById(g_activateTab.substring(6,g_activateTab.length))!=null){
	iPhoneNo = "";
	iPhoneNo = document.getElementById(g_activateTab.substring(6,g_activateTab.length)).phone_no;
   }
}

function destroyTab(id)
{
	//�رտͻ�Tabʱ��session
	if(id.substring(0,6)=="custid")
	{
		var sendop_code = {};
		sendop_code["phone_no"] = id.substring(6,id.length);
		$.ajax({
		   url: 'destroy.jsp',
		   type: 'POST',
		   data: sendop_code,
		   error: function(data){
				if(data.status=="404")
				{
				  alert( "�ļ�������!");
				}else if (data.status=="500")
				{
				  alert("�ļ��������!");
				}else{
				  alert("ϵͳ����!");  					
				}
		   },
		   success: function(retCode){
		   }
		});
		sendop_code=null; 
		}
}

/************************************ footPanel ************************************/

function openwindow(url,name,iWidth,iHeight)
{
  var url;                            //ת����ҳ�ĵ�ַ;
  var name;                           //��ҳ���ƣ���Ϊ��;
  var iWidth;                         //�������ڵĿ���;
  var iHeight;                        //�������ڵĸ߶�;
  var iTop  = (window.screen.availHeight-30-iHeight)/2;       //��ô��ڵĴ�ֱλ��;
  var iLeft = (window.screen.availWidth-10-iWidth)/2;           //��ô��ڵ�ˮƽλ��;
  var winOP = window.open(url,name,'height='+iHeight+',,innerHeight='+iHeight+',width='+iWidth+',innerWidth='+iWidth+',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=auto,resizeable=yes,location=no,status=no');
  winOP.focus();     
}
		
/*******************end***************************/	
 	window.onunload=function(){
 	  if(isExit!=="1"){
 			closeWindow();
 		}
 	}
 	
 	window.onresize = function(){
		initPanel($("#layoutStatus").val());
	}
	/*
	 * ���߿ͻ���ҳ��ģ����й���У��
	 * 	valideVal	 N_N,Y_N,N_Y,Y_Y,��һλ��ʾ�Ƿ�ǿ����֤���ڶ�λ��ʾ�Ƿ���Ҫ��֤
	 */
	function funcVerify(valideVal,opcode,custId,g_activateTab,title,targetUrl){
		var  valideArr = valideVal.split("_");
		//alert(valideVal+"-->"+opcode);
		//alert(valideArr[0]+"-->"+valideArr[1]);
		addUserToSession(opcode,custId);
		//return  true;
		
		var  urlStr = "cust_id="+custId+"&opcode="+opcode+"&g_activateTab="+g_activateTab+"&title="+title;
		urlStr += "&id_no="+$.trim(top.document.getElementById("currUserId").value);
		document.getElementById("targetUrlDiv").value = targetUrl; //��URL��׺�ݴ�main.jsp,����֤ҳ��ȡ
		if(valideArr[0]==="Y"){
			top.openDivWin("ajax_forceVerify.jsp?isForce=Y&"+urlStr,"��֤��Ϣ","400","200");
		}else{
			if(valideArr[1]==="Y"){
				top.openDivWin("ajax_verify.jsp?isForce=N&"+urlStr,"��֤��Ϣ","400","200");
			}else{
				return  true;
			}			
		}
	}
	function  addUserToSession(opcode,custId){
		var sendop_code = {};
		sendop_code["id_no"] = $.trim(top.document.getElementById("currUserId").value);
		sendop_code["cust_id"] = custId;
		sendop_code["op_code"] = opcode;
		sendop_code["brand_id"] = $.trim(top.document.getElementById("currBrandId").value);
		sendop_code["master_serv_id"] = $.trim(top.document.getElementById("currMasterServId").value);
		sendop_code["service_no"] = $.trim(top.document.getElementById("currPhoneNo").value);
		$.ajax({
		   url: 'ajax_addSession.jsp',
		   type: 'POST',
		   data: sendop_code,
		   error: function(data){
				if(data.status=="404")
				{
				  alert( "�ļ�������!");
				}else if (data.status=="500")
				{
				  alert("�ļ��������!");
				}else{
				  alert("ϵͳ����!");  					
				}
		   },
		   success: function(retCode){
		   }
		});
		sendop_code=null; 
	}
	
  /*
	 * 	openflag	 1.first tab;2.second tab;other open
	 *	opcode
	 *	title			 tab show text
	 *	targetUrl  page url
	 *	valideVal	 
	 */
	var isValidateFlag = false;
	/* ����
	function L(openflag,opcode,title,targetUrl,valideVal,grantNo)
	{
		if($.trim(targetUrl)==""||targetUrl=="#")return  false;//����Ŀ¼�ڵ��ҳ��
		if(openflag=="1")//first tab
		{
			if(targetUrl!="#"){
				targetUrl = changeUrl("<%=request.getContextPath()%>/npage/"+targetUrl,opcode,title,grantNo);
				if($("#contentArea iframe").size() < 11){
					addTab(true,opcode,title,targetUrl);	
				}else{
					showDialog("ֻ�ܴ�10��һ��tab",1);
				}
			}
		}else if(openflag=="2")//second tab
		{
			if(g_activateTab.substr(0,6)	=="custid"){
				openSecondTab(g_activateTab,targetUrl,opcode,title,valideVal,grantNo);
			}else
			{
				showDialog("��ѡ��Ҫ�����Ŀͻ�!",1);
			}
		}else if(openflag=="3")//����ͻ���ҳ�Ѿ��򿪣���򿪶���tab�������һ��tab
		{
			var  _hasCustOpen = false;
			$("#contentArea iframe").each(function(){
				if($(this)[0].id.length>12&&$(this)[0].id.substring(0,12)=="iframecustid"){
					_hasCustOpen = true;
				}
			});
			
			if(_hasCustOpen){//�򿪶���tab
				if(g_activateTab.substr(0,6)=="custid"){
					openSecondTab(g_activateTab,targetUrl,opcode,title,valideVal,grantNo);
				}else
				{
					showDialog("��ѡ��Ҫ�����Ŀͻ�!",1);
				}
			}else{  //��һ��tab
				if(targetUrl!="#"){
					targetUrl = changeUrl("<%=request.getContextPath()%>/npage/"+targetUrl,opcode,title,grantNo);
					if($("#contentArea iframe").size() < 11){
						addTab(true,"custLater"+opcode,title,targetUrl);	////�Ե����ַ�ʽ�򿪵�ʱ���tab���±��
					}else{
						showDialog("ֻ�ܴ�10��һ��tab",1);
					}
				}
			}
		}else if(openflag=="4")//һ��tab�򿪼���ҳ��
		{
			if(targetUrl!="#"){
				if($("#contentArea iframe").size() < 11){
					addTab(true,opcode,title,targetUrl);	
				}else{
					showDialog("ֻ�ܴ�10��һ��tab",1);
				}
			}
		}
		else//������ʽ
		{
	  	if(targetUrl!="#"){
	  		targetUrl = "/npage/"+changeUrl(targetUrl,opcode,title,grantNo);
	  		var win= window.open(targetUrl,"","width="+screen.availWidth+",height="+screen.availHeight+",top=0,left=0,scrollbars=yes,resizable=yes,status=yes");
	  		setTimeout(function(){win.focus();},1000);
	  	}
	  }
	}
	*/
/*
	 * 	openflag	 1.first tab;2.second tab;3.callcenter;4.asweb|jlnewsaleweb;other
	 *	opcode
	 *	title			 tab show text
	 *	targetUrl  page url
	 *	valideVal
	 */
	function L(openflag,opcode,title,targetUrl,valideVal)
	{
		//alert("openflag|"+openflag+"\nopcode|"+opcode+"\ntitle|"+title+"\ntargetUrl|"+targetUrl+"\nvalideVal|"+valideVal);

		//first tab
		if(openflag=="1")
		{
				targetUrl = changeUrl("<%=request.getContextPath()%>/npage/"+targetUrl,opcode,title);
				addTab(true,opcode,title,targetUrl);
		}
		//second tab
		else if(openflag=="2")
		{  
		    if(iPhoneNo == "index"&&opcode!="1104"&&opcode!="q046"&&opcode!="4603"&&opcode!="4100"&&opcode!="7518"&&opcode!="4977"){
		        rdShowMessageDialog("�������ֻ�����!");
				    $("#iCustName").select();
				    return;
		    }
		    if(iPhoneNo == "custMain"){
		        rdShowMessageDialog("��ѡ��һ���û�!");
				    return;
		    }
		    if(iPhoneNo==""&&opcode!="1104"&&opcode!="q046"&&opcode!="4603"&&opcode!="4100"&&opcode!="7518"&&opcode!="4977"){
		        rdShowMessageDialog("�������ֻ�����!");
				    return;		    	
		    }
		    
			//var patrn=/^((\(\d{3}\))|(\d{3}\-))?[12][03458]\d{9}$/;
			//if(g_activateTab.search(patrn)!=-1){
		  		if(typeof(valideVal)!="undefined"&&(valideVal.indexOf("1")!=-1)){ //��Ҫ��֤
                chkIsValidate(valideVal,iPhoneNo,opcode);
                //if(isValidateFlag!=false)
                if(isValidateFlag==false)
                {
                 var path = "<%=request.getContextPath()%>/npage/public/publicValidate.jsp";
                 path =  path + "?valideVal="   + valideVal;
                 path =  path + "&titleName="   + title;
                 path =  path + "&activePhone=" + iPhoneNo;
                 path =  path + "&opCode=" + opcode;
                 var validateResult = window.showModalDialog(path,"","dialogWidth=450px;dialogHeight=250px");
                 if((validateResult=="undefined")||(validateResult!="1")){
                    return;
                  }
                }
          }
          targetUrl = changeUrl("<%=request.getContextPath()%>/npage/"+targetUrl,opcode,title);
          targetUrl = targetUrl+"&activePhone="+iPhoneNo;
          document.getElementById("iframe"+g_activateTab).contentWindow.addTab(false,opcode,title,targetUrl);
			//}
			//�ֻ�����
			//else
			//{
				//rdShowMessageDialog("�������ֻ�����!");
				//$("#iCustName").select();
			//}
		}
	  else if(openflag=="4")
	  {
	  	targetUrl = changeUrl(targetUrl,opcode,title);
	  	addTab(true,opcode,title,targetUrl);
	  }
	  //Ĭ�Ͼ�ҵ�񵯳���ʽ
	  else
	  {
	  	if(targetUrl!="#"){
	  		//targetUrl = changeUrl(targetUrl,opcode,title);
	  		
	  	  //targetUrl = changeUrl1(targetUrl,opcode,title);
	  		var win= window.open(targetUrl,opcode,"width="+screen.availWidth+",height="+screen.availHeight+",top=0,left=0,scrollbars=yes,resizable=yes,status=yes");
        addWinName(win,opcode);
        self.blur();
        setTimeout(function(){try {win.focus();} catch (e) {}},1000);
	  	}
	  }
	}
	
	function openPage(openflag,opcode,title,targetUrl,valideVal){
        L(openflag,opcode,title,targetUrl,valideVal);
    }
/*	
	//�򿪶���TAB  
	function  openSecondTab(g_activateTab,targetUrl,opcode,title,valideVal,grantNo){
		var user_index = document.getElementById("iframe"+g_activateTab).contentWindow.document.frames("user_index");
		if((!user_index)||(!user_index.document.all))return  false;
		if(typeof(user_index.document.all.isUserLoading)=="undefined")return false;
	//	if($.trim(user_index.document.all.isUserLoading.value)=="N")return false; //�ȴ��ͻ���ҳ���û��б��������
	//	if($.trim(top.document.getElementById("userFinishFlag").value)=="N")return false; //�½��û�������δ��⣬��Ҫ�ȴ����
		var  g_activeCustId = g_activateTab.substring(6);
		targetUrl = changeUrl("<%=request.getContextPath()%>/npage/"+targetUrl,opcode,title,grantNo);
		targetUrl = targetUrl+addCustInfoToUrl(g_activeCustId); 
		if(funcVerify(valideVal,opcode,g_activeCustId,g_activateTab,title,targetUrl)){
			document.getElementById("iframe"+g_activateTab).contentWindow.addTab(false,opcode,title,targetUrl);
		}
	}
	//����tab�򿪣���URL�����ӿͻ���ҳ�еĿͻ��û���Ϣ
	function  addCustInfoToUrl(custId){
		var appenUrl = "&activeCustId="+custId+"&activePhone="+document.getElementById("currPhoneNo").value
			appenUrl +="&activeIdNo="+document.getElementById("currUserId").value
			appenUrl +="&contactId="+document.getElementById("iframe"+g_activateTab).contentWindow.document.frames("user_index").document.all.contactId.value
			appenUrl +="&activeBrandId="+document.getElementById("currBrandId").value
			appenUrl +="&activeMasterServId="+document.getElementById("currMasterServId").value
			appenUrl +="&activeProdId="+document.getElementById("currMainProdId").value
			appenUrl +="&activeProdName="+document.getElementById("currMainProdName").value
			appenUrl +="&activeBrandName="+document.getElementById("currBrandName").value
			appenUrl +="&activeMasterServName="+document.getElementById("currMasterServName").value;
		return  appenUrl ;
	}
*/
	function changeUrl(targetUrl,opCode,title,grantNo)
	{
	  	var flag = targetUrl.indexOf("?");
	  	if(parseInt(flag)==-1)
	  	{
	  		targetUrl=targetUrl+"?opCode="+opCode+"&opName="+title+"&crmActiveOpCode="+opCode;
	  	}else
	  	{
	  		targetUrl=targetUrl+"&opCode="+opCode+"&opName="+title+"&crmActiveOpCode="+opCode;
	  	}
	  	if(grantNo!=undefined)
	  	{            
	  		targetUrl=targetUrl+"&grantNo="+grantNo;
	  	}
	  	return targetUrl;
	}
	
	function changeUrl1(targetUrl,opCode,title)
  {
        var flag = targetUrl.indexOf("?");
        if(parseInt(flag)==-1)
        {
          targetUrl=targetUrl+"?opCode="+opCode+"&opName="+title;
        }else
        {
          targetUrl=targetUrl+"&opCode="+opCode+"&opName="+title;
        }
        
        //alert(targetUrl);    
        targetUrl=strcat(targetUrl);
        targetUrl=targetUrl.replace(new RegExp("&","gm"),"%26");       
        var chkInfoPacket = new AJAXPacket("<%=request.getContextPath()%>/npage/public/timeValidate.jsp","���ڽ����û���Ч����֤,���Ժ�...");
        chkInfoPacket.data.add("retType" ,     "timeValidate"  );
        chkInfoPacket.data.add("targetUrl" ,  targetUrl);
        core.ajax.sendPacket(chkInfoPacket,doProcesspwd);
        chkInfoPacket =null;
        
        return oldjumpurl;

  }
	
	function strcat()
    {
    	var result = "";
    	for(var i = 0; i< arguments.length; i++)
    	{
    		result = result + replaceConnectChar(arguments[i]) + '#';
    	}
    	return result;
    }
    
    function replaceConnectChar(s)
    {
      //var str = s.replace(/%/g, "%25").replace(/\+/g, "%2B").replace(/\s/g, "+"); // % + \s
      //str = str.replace(/-/g, "%2D").replace(/\*/g, "%2A").replace(/\//g, "%2F"); // - * /
      //str = str.replace(/\&/g, "%26").replace(/!/g, "%21").replace(/\=/g, "%3D"); // & ! =
      //str = str.replace(/\?/g, "%3F").replace(/:/g, "%3A").replace(/\|/g, "%7C"); // ? : |
      //str = str.replace(/\,/g, "%2C").replace(/\./g, "%2E").replace(/#/g, "%23"); // , . #
      var str = s.replace(/#/g, "��");
      return str;
    }
	
	function chkIsValidate(validateVal,activePhone,opcode)
	{
	  	isValidateFlag = false;
	  	var chkInfoPacket = new AJAXPacket("<%=request.getContextPath()%>/npage/public/chkIsValidate.jsp","���ڽ����û���Ч����֤,���Ժ�...");

	    chkInfoPacket.data.add("retType" ,     "chkIsValidate"  );
	    chkInfoPacket.data.add("verifyVal" ,  validateVal);
	    chkInfoPacket.data.add("phoneNo" ,  activePhone);
	    chkInfoPacket.data.add("opCode" ,  opcode);
	    core.ajax.sendPacket(chkInfoPacket,doProcesspwd);
	    chkInfoPacket =null;
	}
	
    function doProcesspwd(packet)
	{
	    var retType = packet.data.findValueByName("retType");

	    if(retType=="chkIsValidate")
      {
      	var retCode = packet.data.findValueByName("retCode");
      	if(retCode=="000000")
      	 {
	         isValidateFlag = true;
      	 }
      }
      
       if(retType=="timeValidate")
      {
        var retCode   = packet.data.findValueByName("retCode");
        var timestamp = packet.data.findValueByName("timestamp");
        var targetUrl = packet.data.findValueByName("targetUrl");
        if(retCode=="000000")
         {
         	   if(targetUrl.indexOf("chncard") != -1){
         	   	   //alert('chncard');
         	   	   oldjumpurl=targetUrl;
         	  }else{
         	    targetUrl=targetUrl.substring(0,targetUrl.indexOf("#"));
         	    oldjumpurl=targetUrl+"&v99="+timestamp+"#";
         	      //alert(oldjumpurl);
         	   }
              return true;
         }else{
         	    
         	    alert("ʱ�����ʧ��");
         	    return false;
        }
      }
	}
	
   /********����cookie����begin*******/
    function Clearcookie()   //���� COOKIE  
    {  
	    var temp=document.cookie.split("; ");  
	    var len;  
	    var ts;  
	    for (len=0;len<temp.length;len++){  
	        ts=temp[len].split("=")[0];  
	        if (ts.indexOf("rkName")!=-1||ts=="cookieNum"){  //��� ts��"rkName"�����ɾ��
	            var exp = new Date();    
	            exp.setTime(exp.getTime()-100000);//ʱ��
	            var cval=temp[len].split("=")[1]; 
	            document.cookie = ts + "=" + cval + "; expires=" + exp.toGMTString();  
	        }
	    }   
    }  
   /******����cookie����end*******/
	
	$(document).ready(
		function(){
			layoutSwitch(<%=layout%>);			//��ʼ��ҳ������ֵĴ�С;����1,2,3,4
			loadFirstMenu();//����һ���˵�
			HoverMenu('oli','li');//��ʼ���˵�,��һ���˵��¼�,����getTree
			HoverNav("fav");
			<%if(hotkey.equals("Y"))
			{%>
			//getHotKey();					//��ȡ��ݼ��˵�
			<%}%>
			initSearch();					//��ʼ�������������
			/*
			$(".more_set").hover(function(){$(this).find(".more_panel").show()},function(){$(this).find(".more_panel").hide()})
		  	$(".menu_set").hover(function(){$(this).find(".more_panel").show()},function(){$(this).find(".more_panel").hide()})
		  	*/
		  	$(".more_set").hover(function(){$(this).find(".more_panel").show();$("#moresetIf").height($(this).find(".more_panel").height());},
				function(){$(this).find(".more_panel").hide()})
			$(".menu_set").hover(function(){$(this).find(".more_panel").show();$("#menusetIf").height($(this).find(".more_panel").height());},
				function(){$(this).find(".more_panel").hide()})
			Clearcookie();
			 
    		
    		layoutSwitch(1);
    		if("<%=phoneNoPms%>"!=""){
    			addTabBySearchCustName("<%=phoneNoPms%>");
    		}
		});
	
	function  bindRemoveTab(id){
		if(id.substring(0,6)=="custid")
		{
			var oldRemoveTab = removeTab;
			removeTab = function(id){
				try{
					if(id.substring(0,6)=="custid")
					{
						var user_index = document.getElementById("iframe"+id).contentWindow.document.frames("user_index");
						if(user_index){
							if(user_index.document.getElementById("shoppingCarList").rows.length>1){
								if(confirm("ȷ��Ҫ�˳��ͻ���ҳ��")){
									if(confirm("�Ƿ񳷵���")){
										user_index.remOrderConfirm();
									}else{
										return  false;
									}
								}else{
									return  false;
								}
							}
						}
					}
				    oldRemoveTab(id);
				 }catch(e){}
		    }
	    }
	}
	function imgLeftRight(){
 
	}
</script>	
</body>
</html>