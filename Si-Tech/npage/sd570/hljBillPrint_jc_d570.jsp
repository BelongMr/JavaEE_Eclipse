<%
/********************
*version v3.0
*开发商: si-tech
*
*update:ZZ@2008-10-13 页面改造,修改样式
*1104,1238等模块使用过的弹出对话框
*
********************/
%>
<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.sitech.crmpd.core.wtc.WtcUtil"%>
<%@ taglib uri="/WEB-INF/wtc.tld" prefix="wtc" %>
<HTML>
<HEAD>
<TITLE>打印</TITLE>
<script type="text/javascript" src="/njs/extend/jquery/jquery123_pack.js"></script>	
<script type="text/javascript" src="/njs/si/core_sitech_pack.js"></script>	
<script type="text/javascript" src="/njs/redialog/redialog.js"></script>
<script type="text/javascript" src="/njs/extend/jquery/block/jquery.blockUI.js"></script>
<script language="JavaScript" src="/njs/si/validate_pack.js"></script>

</HEAD>
<%@ include file="/npage/innet/splitStr.jsp" %>
<% 
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0);
	String work_no = (String)session.getAttribute("workNo");
	String work_name = (String)session.getAttribute("workName");
	String org_code = (String)session.getAttribute("orgCode");
	
	
	String DlgMsg = request.getParameter("DlgMsg");
	String printInfo = request.getParameter("printInfo");
	String saleFlag = request.getParameter("saleFlag");
	if ("1".equals(saleFlag)) {
		printInfo += "话费未返还完前不能办理预销业务。如您的固话因质量问题不能继续使用，请到营业厅重新购机或办理重新捆绑业务。允许用户业务未到期前提前取消。业务到期前若申请取消，按违约规定您获赠的TD固话机将按TD固话机原价补交差额，并按剩余预存款的30%交纳违约金。已办理本业务的号码不允许再次办理欢乐家庭业务。在不同的区域可根据网络覆盖情况选择中国移动G3网络或GSM网络使用上网业务。" + "|";
		printInfo += "家庭内由手机主卡统一缴费并统一付费，若主卡欠费，家庭内所有号码将停机。" + "|";
		printInfo += "本月新入网客户办理欢乐家庭当月即生效，其他客户当月办理欢乐家庭套餐下月生效。家庭成员优惠资费及家庭内统一付费关系与欢乐家庭套餐生效日期一致。" + "|";
		printInfo += "办理当月TD固话资费为：0月租、0元来电显示，5元彩铃必选，10元底线（含市话和国内长途点对点短信。）小区内市话首三分钟0.2元，超过后0.1元/分钟，拨打国内长途0.25元/分钟(不含港澳台 )，本地被叫免费。小区外主叫0.25元/分钟，被叫免费，国内长途0.6元/分钟(不含港澳台)，其他按现行标准资费收取。" + "|";
		printInfo += "主卡可以办理增加副卡号码，副卡号码可以办理退出家庭。" + "|";
		printInfo += "欢乐家庭成员必须归属同一地区。" + "|";
		printInfo += "您办理业务的TD固话号码只能同TD固话一起使用，如发生拆包现象（即办理的号码未与TD固话一起使用），则本次办理的资费将转为拆包后的资费（高单价资费）：0元月租，0元来电显示，5元彩铃，月底线消费30元（含市话、国内（不含港澳台）长途、点对点短信），小区内本地基本通话市话主叫首三分钟0.20元，首三分钟后0.10元/分钟，本地拨打国内（不含港澳台）长途0.15元/分钟，本地被叫免费。小区外本地基本通话费市话主叫0.25元/分钟，拨打国内（不含港澳台）长途0.60元/分钟，其他资费按标准资费收取区号范围内被叫免费。可设5个家庭成员号码(本地移动号码)，月赠送TD固话与家庭成员间本地通话时长600分钟，超出赠送分钟数后0.05元/分钟，单向收费。您可以到营业厅办理资费变更，当月办理次月生效。" + "|#";
	} else if ("0".equals(saleFlag)) {
		printInfo += "您办理的办理欢乐家庭套餐当月办理次月生效。" + "|";
		printInfo += "家庭内由手机主卡统一缴费并统一付费，若主卡欠费，家庭内所有号码将停机。" + "|";
		printInfo += "本月新入网客户办理欢乐家庭当月即生效，其他客户当月办理欢乐家庭套餐下月生效。家庭成员优惠资费及家庭内统一付费关系与欢乐家庭套餐生效日期一致。" + "|";
		printInfo += "主卡可以办理增加副卡号码，副卡号码可以办理退出家庭。" + "|";
		printInfo += "您办理业务的TD固话号码只能同TD固话一起使用，如发生拆包现象（即办理的号码未与TD固话一起使用），则本次办理的资费将转为拆包后的资费（高单价资费）。您可以到营业厅办理资费变更，当月办理次月生效。" + "|";
		printInfo += "如您的固话因质量问题不能继续使用，请到营业厅重新购机或办理重新捆绑业务。已办理本业务的号码不允许再次办理欢乐家庭业务。在不同的区域可根据网络覆盖情况选择中国移动G3网络或GSM网络使用上网业务。" + "|";
		printInfo += "欢乐家庭成员必须归属同一地区。" + "|#";
	}

/*
	if ("1".equals(saleFlag)) {
		printInfo += "话费未返还完前不能办理预销业务。如您的固话因质量问题不能继续使用，请到营业厅重新购机或办理重新捆绑业务。若话费未返还客户解散家庭则话费不再返还，由移动公司一次性扣除。已办理本业务的号码不允许再次办理欢乐家庭业务。在不同的区域可根据网络覆盖情况选择中国移动G3网络或GSM网络使用上网业务。" + "|";
		printInfo += "家庭内由手机主卡统一缴费并统一付费，若主卡欠费，家庭内所有号码将停机。" + "|";
		printInfo += "本月新入网客户办理欢乐家庭当月即生效，其他客户当月办理欢乐家庭套餐下月生效。家庭成员优惠资费及家庭内统一付费关系与欢乐家庭套餐生效日期一致。" + "|";
		printInfo += "主卡可以办理增加副卡号码，副卡号码可以办理退出家庭。" + "|";
		printInfo += "欢乐家庭成员必须归属同一地区。" + "|";
		printInfo += "办理当月TD固话资费为：0月租、0元来电显示，5元彩铃必选，10元底线（含市话和国内长途点对点短信。）小区内市话首三分钟0.2元，超过后0.1元/分钟，拨打国内长途0.25元/分钟(不含港澳台 )，本地被叫免费。小区外主叫0.25元/分钟，被叫免费，国内长途0.6元/分钟(不含港澳台)，其他按现行标准资费收取。" + "|";
		printInfo += "您办理业务的TD固话号码只能同TD固话一起使用，如发生拆包现象（即办理的号码未与TD固话一起使用），则本次办理的资费将转为拆包后的资费（高单价资费）：0元月租，0元来电显示，5元彩铃，月底线消费30元（含市话、国内（不含港澳台）长途、点对点短信），小区内本地基本通话市话主叫首三分钟0.20元，首三分钟后0.10元/分钟，本地拨打国内（不含港澳台）长途0.15元/分钟，本地被叫免费。小区外本地基本通话费市话主叫0.25元/分钟，拨打国内（不含港澳台）长途0.60元/分钟，其他资费按标准资费收取区号范围内被叫免费。可设5个家庭成员号码(本地移动号码)，月赠送TD固话与家庭成员间本地通话时长600分钟，超出赠送分钟数后0.05元/分钟，单向收费。您可以到营业厅办理资费变更，当月办理次月生效。" + "|#";
	} else if ("0".equals(saleFlag)) {
		printInfo += "家庭内由手机主卡统一缴费并统一付费，若主卡欠费，家庭内所有号码将停机。" + "|";
		printInfo += "本月新入网客户办理欢乐家庭当月即生效，其他客户当月办理欢乐家庭套餐下月生效。家庭成员优惠资费及家庭内统一付费关系与欢乐家庭套餐生效日期一致。" + "|";
		printInfo += "主卡可以办理增加副卡号码，副卡号码可以办理退出家庭。" + "|";
		printInfo += "您办理业务的TD固话号码只能同TD固话一起使用，如发生拆包现象（即办理的号码未与TD固话一起使用），则本次办理的资费将转为拆包后的资费（高单价资费）：0元月租，0元来电显示，5元彩铃，月底线消费30元（含市话、国内（不含港澳台）长途、点对点短信），小区内本地基本通话市话主叫首三分钟0.20元，首三分钟后0.10元/分钟，本地拨打国内（不含港澳台）长途0.15元/分钟，本地被叫免费。小区外本地基本通话费市话主叫0.25元/分钟，拨打国内（不含港澳台）长途0.60元/分钟，其他资费按标准资费收取区号范围内被叫免费。可设5个家庭成员号码(本地移动号码)，月赠送TD固话与家庭成员间本地通话时长600分钟，超出赠送分钟数后0.05元/分钟，单向收费。您可以到营业厅办理资费变更，当月办理次月生效。" + "|";
		printInfo += "如您的固话因质量问题不能继续使用，请到营业厅重新购机或办理重新捆绑业务。若话费未返还客户解散家庭则话费不再返还，由移动公司一次性扣除。已办理本业务的号码不允许再次办理欢乐家庭业务。在不同的区域可根据网络覆盖情况选择中国移动G3网络或GSM网络使用上网业务。" + "|";
		printInfo += "欢乐家庭成员必须归属同一地区。" + "|#";
	}
*/	
	System.out.println("====wanghfa==== printInfo = " + printInfo);
	String pType = request.getParameter("pType");
	String billType = request.getParameter("billType");
	String phoneNo = request.getParameter("phoneNo");
	String opCode = request.getParameter("opCode");
	System.out.println("pType+++++++++++++++++++++++++++++++++++++" + pType);
	System.out.println("pType+++++++++++++++++++++++++++++++++++++" + pType);
	String submitCfm = request.getParameter("submitCfm");
	
	String mode_code = request.getParameter("mode_code");  //资费代码 如果没有值 前台传过来的就是字符串 null
	String fav_code = request.getParameter("fav_code");    //特服代码 如果没有值 前台传过来的就是字符串 null
	String area_code = request.getParameter("area_code");  //小区代码 如果没有值 前台传过来的就是字符串 null
	System.out.println("mode_code+++++++++++++++++++++++++++++++++++++" + mode_code);
	String[] mode_list = null;
	String[] fav_list  = null;
	String[] area_list = new String[1];
	if(mode_code!="null"){
		mode_list = mode_code.split("~");
	}
	if(fav_code!="null"){
		fav_list = fav_code.split("\\|");
	}
	if(area_code!="null"){
		area_list[0] = area_code;
	}	
	String login_accept=request.getParameter("sysAccept");   
	String disabledFlag="";
	
	System.out.println("area_list[0]="+area_list[0]);
	System.out.println("mode_code="+mode_code);
	System.out.println("fav_code="+fav_code);

  System.out.println("====out====");
  
	/*************************************yanpx20100830 为客服部弹打印页面增加***************************************************/
	String accountType = (String)session.getAttribute("accountType"); //1 为营业工号 2 为客服工号
	if("2".equals(accountType)){
		%>
		<script language='jscript'>
			window.returnValue="confirm"; //yuanqs add 2010/9/10 17:24:57
		    window.close();
		</script>
		<%
	}
	/*********************************end********************************************************/  
  
   String classsql="select class_name,class_code from sclass where print_flag=1";
%>
		<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=org_code.substring(0,2)%>" outnum="2">
			<wtc:sql><%=classsql%></wtc:sql>
		</wtc:pubselect>
		<wtc:array id="result" scope="end" />
<%
		HashMap hm=new HashMap();
		for(int i=0;i<result.length;i++){
			hm.put(result[i][0],result[i][1]);
		}
		String favPassDesc = "";
		String [][] retInfo=getParamIn(printInfo,work_no,work_name,hm,favPassDesc);	
%>
		<wtc:service name="sPrt_Create" routerKey="region" routerValue="<%=org_code.substring(0,2)%>" outnum="2" >
			<wtc:param value="<%=opCode%>"/>
			<wtc:param value="<%=billType%>"/>
			<wtc:param value="<%=work_no%>"/>
			<wtc:param value="<%=login_accept%>"/>
		  <wtc:param value="<%=phoneNo%>"/>
			<wtc:param value="<%=phoneNo%>"/>
			<wtc:params value="<%=retInfo[0]%>"/>
			<wtc:params value="<%=retInfo[1]%>"/>
			<wtc:params value="<%=retInfo[2]%>"/>
			<wtc:params value="<%=mode_list%>"/>
			<wtc:params value="<%=fav_list%>"/>
			<wtc:params value="<%=area_list%>"/>
		</wtc:service>
<%
	System.out.println("!!!!!!!!!!!!!"+retCode);
  if(!retCode.equals("000000")){  
  	if(!retCode.equals("696006")){
      disabledFlag="disabled";
      DlgMsg="生成工单错误,重新生成？点击下一步提交此次业务则无法打印工单！" ;
      System.out.println(retCode+"%%%%%");
%>
		<script language='jscript'>
		    var ret_code = "<%=retCode%>";
		    var ret_msg = "<%=retMsg%>";
		    alert("生成工单错误！错误代码：<%=retCode%>。错误信息：<%=retMsg%>。");
		    //window.close();
		</script>
<%
   }
  }
%>
<SCRIPT type="text/javascript">
onload=function()
{
	//core.rpc.onreceive = doProcess;	
  //var rdBackColor = "#E3EEF9";
  // If IE version >=5.5, This will be works
  // gradient start color
  //var rdGradientStartColor = "#FFFFFFFF";
  // gradient end color
  //var rdGradientEndColor = "#FFFDEDC1";
  // gradient type, 1 represents from left to right, 0 reresents from top to bottom
  //var rdGradientType = "0";
  //var fillter = "progid:DXImageTransform.Microsoft.Gradient(startColorStr="+rdGradientStartColor+",endColorStr="+rdGradientEndColor+", gradientType="+rdGradientType+")";
  //document.bgColor = rdBackColor;
  //document.body.style.filter = fillter;	
//  var obj =window.dialogArguments;
//  alert(obj.name);
}

function doProcess(packet)
{	
  //RPC处理函数findValueByName
  var retType = packet.data.findValueByName("retType");
  var retCode = packet.data.findValueByName("errCode"); 
  var retMessage = packet.data.findValueByName("errMsg");	
  
  var fColor = 0*65536+0*256+0;  
  self.status="";
	
 	if((retCode).trim()=="")
	{
    alert("调用"+retType+"服务时失败！");
    return false;
	}
	
	if(retType == "subprint")
  {
  	if(retCode=="000000")
    {	 
        var impResultArr = packet.data.findValueByName("impResultArr");
        var num = impResultArr.length;   //总行数  
        var page=Math.ceil((num/45));//每页45行  由于工单头部三行内容在纸上打在同一行，减去2行。
		var x = 0;
        for(var j=0;j<page;j++){
					try{
						//打印初始化
						printctrl.Setup(0);
						printctrl.StartPrint();
						printctrl.PageStart();
							
							for(var i=j*45;i<(j+1)*45;i++){
							 if(i<num){
									if(impResultArr[i][6]=="N"){
										 impResultArr[i][6]=0
									}else{
										 impResultArr[i][6]=5
									}
										printctrl.PrintEx(parseInt(impResultArr[i][3]),parseInt(impResultArr[i][2]-j*45),impResultArr[i][12],parseInt(impResultArr[i][4]),fColor,impResultArr[i][6],impResultArr[i][11],impResultArr[i][10]);
								}
							 //x++;
							}
						//x = 0;
						//打印结束

						printctrl.PageEnd();
						printctrl.StopPrint();

				  }catch(e){
				  	//alert(e);
				  }finally{
						//返回打印确认信息
						var cfmInfo = "<%=submitCfm%>";
						var retValue = "";
						if(cfmInfo == "Yes")
						{	retValue = "confirm";	}
						window.returnValue= retValue;     
						window.close(); 
					}
			  }
        document.spubPrint.getElementById("message")="未打印工单合并打印成功！";	
    }else{
    	   alert("错误代码："+retCode+"错误信息："+retMessage);
			var cfmInfo = "<%=submitCfm%>";
			var retValue = "";
			if(cfmInfo == "Yes")
			{	retValue = "confirm";	}
			window.returnValue= retValue;     
			window.close(); 
	  }
	 
  }
  
  if(retType == "print")
  {
  	if(retCode=="000000")
    {	
     		var impResultArr = packet.data.findValueByName("impResultArr");
				try{
					//打印初始化
					printctrl.Setup(0);
					printctrl.StartPrint();
					printctrl.PageStart();
						for(var i=0;i<impResultArr.length;i++){
									if(impResultArr[i][6]=="N"){
										 impResultArr[i][6]=0
									}else{
										 impResultArr[i][6]=5
									}
							printctrl.PrintEx(parseInt(impResultArr[i][3]),parseInt(impResultArr[i][2]),impResultArr[i][12],parseInt(impResultArr[i][4]),fColor,impResultArr[i][6],impResultArr[i][11],impResultArr[i][10]);
						}
					//打印结束
					printctrl.PageEnd();
					printctrl.StopPrint();
			  }catch(e){
			  	alert(e);
			  }finally{
					//返回打印确认信息
					var cfmInfo = "<%=submitCfm%>";
					var retValue = "";
					if(cfmInfo == "Yes")
					{	retValue = "confirm";	}
					window.returnValue= retValue;     
					window.close(); 
				}
    }
    else{
      alert("错误代码："+retCode+"错误信息："+retMessage);
			var cfmInfo = "<%=submitCfm%>";
			var retValue = "";
			if(cfmInfo == "Yes")
			{	retValue = "confirm";	}
			window.returnValue= retValue;     
			window.close(); 
    }
  }
  if(retType == "noprint"){
  	if(retCode!="000000"){
  		alert("错误代码："+retCode+"错误信息："+retMessage);	
  	}
	  window.returnValue="continueSub";
	  window.close();
  }
}



//免填单打印
function doPrint()
{	
	//调用普通打印程序	
	var print_Packet = new AJAXPacket("../public/fPubSavePrint.jsp","正在打印，请稍候......");
	print_Packet.data.add("retType","print");
	print_Packet.data.add("opCode",'<%=opCode%>');
	print_Packet.data.add("phoneNo",'<%=phoneNo%>');
	print_Packet.data.add("billType",'<%=billType%>');
	print_Packet.data.add("login_accept",'<%=login_accept%>');
	core.ajax.sendPacket(print_Packet);
	print_Packet=null;	 	
	
}
//合并打印
function doSubPrint()
{	
	//调用合并打印程序	
	var subprint_Packet = new AJAXPacket("../public/fPubSaveSubPrint.jsp","正在打印，请稍候......");
	subprint_Packet.data.add("retType","subprint");
	subprint_Packet.data.add("phoneNo",'<%=phoneNo%>');
	subprint_Packet.data.add("billType",'<%=billType%>');
	subprint_Packet.data.add("login_accept",'<%=login_accept%>');
	core.ajax.sendPacket(subprint_Packet);
	subprint_Packet=null;	 		
}
//不打印
function doNOPrint()
{
	var noprint_Packet = new AJAXPacket("../public/fPubSaveNoPrint.jsp","正在打印，请稍候......");
	noprint_Packet.data.add("retType","noprint");
	noprint_Packet.data.add("phoneNo",'<%=phoneNo%>');
	noprint_Packet.data.add("opCode",'<%=opCode%>');
	noprint_Packet.data.add("billType",'<%=billType%>');
	noprint_Packet.data.add("login_accept",'<%=login_accept%>');
	core.ajax.sendPacket(noprint_Packet);
	noprint_Packet=null;	 
}
function doSub()
{
  window.returnValue="continueSub";
  window.close();
}
function codeChg(s)
{
  var str = s.replace(/%/g, "%25").replace(/\+/g, "%2B").replace(/\s/g, "+"); // % + \s
  str = str.replace(/-/g, "%2D").replace(/\*/g, "%2A").replace(/\//g, "%2F"); // - * /
  str = str.replace(/\&/g, "%26").replace(/!/g, "%21").replace(/\=/g, "%3D"); // & ! =
  str = str.replace(/\?/g, "%3F").replace(/:/g, "%3A").replace(/\|/g, "%7C"); // ? : |
  str = str.replace(/\,/g, "%2C").replace(/\./g, "%2E").replace(/#/g, "%23"); // , . #
  return str;
}
</SCRIPT>
<!--**************************************************************************************-->

<body style="overflow-x:hidden;overflow-y:hidden">
	<head>
		<title>黑龙江移动BOSS</title>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK">
		<link href="/nresources/default/css/FormText.css" rel="stylesheet" type="text/css"></link>
		<link href="/nresources/default/css/font_color.css" rel="stylesheet" type="text/css"></link>	
	</head>
<FORM method=post name="spubPrint">
  <!------------------------------------------------------>
  <div class="popup">
	  	<div class="popup_qu" id="rdImage" align=center>
		  	<div class="popup_zi orange" id="message"><%=DlgMsg%></div>
		  </div>

	    <div align="center">
	      <input class="b_foot" name=commit onClick="doPrint()"  <%=disabledFlag%> type=button value="打印">
	      <%if(pType.equals("subprint")){%> 
	      <input class="b_foot" name=commit onClick="doSubPrint()"  <%=disabledFlag%> type=button value="合并打印">
	      <input class="b_foot" name=back onClick="doSub()"  type=button value="打印存储">
				<%}else if(pType.equals("printstore")){%>
				<input class="b_foot" name=back onClick="doSub()"  type=button value="打印存储">
				<%}%>
			  <input class="b_foot" name=commit onClick="doNOPrint()"  type=button value="下一步">
	    </div>
	    <br>   
	 </div>
</FORM>
<OBJECT
classid="clsid:0CBD5167-6DF3-45C4-AC69-852C6CB75D32"
codebase="/ocx/PrintEx.cab#version=1,1,0,3"
id="printctrl"
style="DISPLAY: none"
VIEWASTEXT
>
</OBJECT>
</BODY>
</HTML>    
