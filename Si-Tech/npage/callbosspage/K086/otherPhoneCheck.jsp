



<%@page contentType="text/html;charset=GBK"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<title>������֤</title>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
	<link href="<%=request.getContextPath() %>/nresources/default/css/portalet.css" rel="stylesheet" type="text/css">
	<link href="<%=request.getContextPath() %>/nresources/default/css/font_color.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" language="javascript" src="<%= request.getContextPath() %>/njs/si/base.js"></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath() %>/njs/si/ajax.js"></script>
	<script language="JavaScript" src="<%= request.getContextPath() %>/njs/csp/CCcommonTool.js"></script>
	<script language="JavaScript" src="<%= request.getContextPath() %>/njs/csp/sitechcallcenter.js"></script>
	<style type="text/css">
	#get_rest_title{
	text-align: left;
	height: 25px;
	width: 100%;
	float: left;
	font-size: 12px;
	line-height: 25px;
	font-weight: bold;
	color: #FFFFFF;
    }
	</style>	
	<script type="text/javascript">
	function rest(){
	    /*
	     *��Ҫ���ֻ��������jsǰ�˵�У��
	     */
	     var rest_time = '';
	     var radios = document.getElementsByName('rest_time');
	     for(var i = 0; i < radios.length; i++){
	        if(radios[i].checked){
	        	rest_time = radios[i].value;
	        }
	     }
		//window.opener.cCcommonTool.getRest(rest_time);
		window.opener.exeRest(rest_time);
		//window.close();
	}
	</script>
  </head>
  
  <body>
	<div class="groupItem" id="div1_show">
		<!--<div class="itemHeader"><div id="get_rest_title">���β���</div>-->
	</div>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
						<td class="blue">
							������֤<input type="radio" name="checkType" value="0" checked onclick="checkMode(this.value);">
							������֤<input type="radio" name="checkType" value="1" onclick="checkMode(this.value);">
						</td>
					</tr>
					<tr>
						<td class="blue">
							�绰���룺<input type="text" name="secondDial" value="" readOnly maxlength="12"/>
						</td>
					</tr>

				</table>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td id="footer" align=center>
							<input class="b_foot" name="submit1" type="button" value="ȷ��"
								onclick="submitConfig()">
							&nbsp;&nbsp;&nbsp;<input class="b_foot" name="cancel" type="button"
								onclick="goaway();" value="ȡ��">
						</td>
					</tr>
				</table>
</body>
</html>
<script language="javascript">
	var retCode='';//���ӱ�ʶ��0�����������֤��1������������֤
	getCaller();
	function getCaller(){
		var ret;
		if(window.opener.outCallFlag==1)
		//if(window.opener.cCcommonTool.getOp_code()=='K025')
		{
			if(window.opener.cCcommonTool.getCalled() != "" && (window.opener.cCcommonTool.getCalled().indexOf('10086')==0 ||window.opener.cCcommonTool.getCalled().indexOf('12580')==4)){
				
				document.getElementById("secondDial").value= window.opener.cCcommonTool.getCaller();
			}
			else{
				document.getElementById("secondDial").value= window.opener.cCcommonTool.getCalled();
			}
			/*if(window.opener.cCcommonTool.getCalled() != "" && window.opener.cCcommonTool.getCalled().indexOf('10086') < 0){
				document.getElementById("secondDial").value= window.opener.cCcommonTool.getCalled();
			}else{
				document.getElementById("secondDial").value= window.opener.cCcommonTool.getCaller();
			}*/
			//document.getElementById("secondDial").value= window.opener.cCcommonTool.getCalled();
			retCode='0';
		}
		else
		{
			if(window.opener.cCcommonTool.getCalled() != "" && (window.opener.cCcommonTool.getCalled().indexOf('10086')==0 ||window.opener.cCcommonTool.getCalled().indexOf('12580')==4)){
				
				document.getElementById("secondDial").value= window.opener.cCcommonTool.getCaller();
			}
			else{
				document.getElementById("secondDial").value= window.opener.cCcommonTool.getCalled();
			}
		  retCode='1';
		}
	}
function submitConfig()
{

var returnvalue="";
if(document.getElementById("secondDial").value=="")
{
   rdShowMessageDialog("������绰����!",1);
   document.getElementById("secondDial").focus();
   return;
}else if(!(/[1]{1}\d{10}/.test(document.getElementById("secondDial").value)) || !(/[1]{0}[1]{1}\d{10}/.test(document.getElementById("secondDial").value))){	
		rdShowMessageDialog("�绰���벻��ȷ,����������!",1);
		document.getElementById("secondDial").value="";
		document.getElementById("secondDial").focus();
		return false;	
			
}	
if(document.getElementById("checkType").checked==true){
returnvalue="0";
}
else{
	returnvalue="1";
}
/*window.returnValue=document.getElementById("secondDial").value+"isnowsend"+returnvalue; 
alert("window.returnValue"+window.returnValue); */

var caller= document.getElementById("secondDial").value;
if(caller.indexOf("0")==0){
	caller = caller.substring(1,caller.length);
}
var updflag=updateVerify();
//alert('updflag = '+updflag);

if(updflag!=false && retCode!=''){
	
	//window.opener.cCcommonTool.checkPassword(caller,retCode);
	//ivr������� type = 2 by fangyuan 20090429
  window.opener.handleIVRData('3');
	window.opener.cCcommonTool.checkPassword(caller);

}
window.close();
}
function goaway()
{
window.returnValue="cancel";   

window.close();
}

function checkMode(checkValue)
{
if(checkValue==0)
{
document.getElementById("secondDial").readOnly = true; 
	//if(window.opener.cCcommonTool.getOp_code()=='K025')
	if(window.opener.outCallFlag==1)
	{
		
		if(window.opener.cCcommonTool.getCalled() != "" && (window.opener.cCcommonTool.getCalled().indexOf('10086')==0 ||window.opener.cCcommonTool.getCalled().indexOf('12580')==4)){
				
				document.getElementById("secondDial").value= window.opener.cCcommonTool.getCaller();
			}
			else{
				document.getElementById("secondDial").value= window.opener.cCcommonTool.getCalled();
			}
		//document.getElementById("secondDial").value= window.opener.cCcommonTool.getCalled();	
	}
	else
	{
		if(window.opener.cCcommonTool.getCalled() != "" && (window.opener.cCcommonTool.getCalled().indexOf('10086')==0 ||window.opener.cCcommonTool.getCalled().indexOf('12580')==4)){
				
				document.getElementById("secondDial").value= window.opener.cCcommonTool.getCaller();
			}
			else{
				document.getElementById("secondDial").value= window.opener.cCcommonTool.getCalled();
			}
		//document.getElementById("secondDial").value= window.opener.cCcommonTool.getCaller();
	}
}	
if(checkValue==1)
{
document.getElementById("secondDial").readOnly = false; 
//modify by fangyuan 090326 �Զ������������
//document.getElementById("secondDial").value="";
document.getElementById("secondDial").value=window.opener.document.getElementById("acceptPhoneNo").value;
}
}
//add by fangyuan 20090302
//����dcallcall����֤�ֶ� 
function updateVerify(){
	var len = document.getElementsByName("checkType").length;
	//type=0�Ǳ�����֤��type=1��������֤��
	var type=0;
	for(var i=0;i<len;i++){
		if(document.getElementsByName("checkType")[i].checked){
			type = document.getElementsByName("checkType")[i].value;
			//ȫ�ֱ���checkPwdType��¼������֤��ʽ �����sitechcallcenter.js by fangyuan 20090427
			window.opener.checkPwdType = type;
		}
	}
	var mycotactId = window.opener.document.getElementById("contactId").value;
	//alert('mycotactId = '+mycotactId);
	if(mycotactId.length==0){
		return false;
	}else{
		/*
		var packet=new AJAXPacket(<%=request.getContextPath()%>"/npage/callbosspage/K086/updatePhoneCheck.jsp","\u6b63\u5728\u5904\u7406,\u8bf7\u7a0d\u540e...");	
		packet.data.add('type',type);
		packet.data.add('contactId',mycotactId);	
		core.ajax.sendPacket(packet,doUpdate,true);
		packet=null;
		return true;
		*/
	var urlStrl='<%=request.getContextPath()%>/npage/callbosspage/K086/updatePhoneCheck.jsp?type='+type+'&contactId='+mycotactId;
		asyncGetText(urlStrl,doUpdate);  
	}
}
//add by fangyuan 20090302
// public callback method
function doUpdate(packet){
	/*
	var retCode2 = packet.data.findValueByName("retCode");
	if(retCode2=='000000'){
	}
	*/
}
if(opener.outCallFlag==1){
  opener.callOutSetRouteData();
}

</script>