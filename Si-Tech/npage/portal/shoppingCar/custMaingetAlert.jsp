<!DOCTYPE html PUBLIC "-//W3C//Dtd Xhtml 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<%

%>
<%@ page contentType="text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="/npage/common/serverip.jsp" %>
<%
String workNo = (String) session.getAttribute("workNo");
String loginNoPass = (String)session.getAttribute("password");
String phone_no = request.getParameter("phone_no");
String scriptVal = "false";
String accountType = request.getParameter("accountType");

String bd0002_orgCode = (String)session.getAttribute("orgCode");
String bd0002_regionCode = bd0002_orgCode.substring(0,2);
boolean ifOpenMarket = false;

%>

	<wtc:service name="sCollQry" outnum="1" routerKey="region" 
		 routerValue="<%=bd0002_regionCode%>" retcode="retCodex1" retmsg="retMsgx1">
		<wtc:param value=""/>
		<wtc:param value="01"/>
		<wtc:param value=""/>
		<wtc:param value="<%=workNo%>"/>
		<wtc:param value="<%=loginNoPass%>"/>
		<wtc:param value="<%=phone_no%>"/>
		<wtc:param value=""/>
	</wtc:service>
	<wtc:array id="resultx" scope="end"/>
<%
		if("000000".equals(retCodex1)){
			if(resultx != null && resultx.length > 0){
			System.out.println("===hejwa======= " + resultx[0][0]);
				if(Integer.parseInt(resultx[0][0]) > 0){
					scriptVal = "true";
				}
			}
		}
		System.out.println("===hejwa====scriptVal=== " +scriptVal);
%>
<wtc:service name="sCollInitNew" routerKey="region" routerValue="<%=bd0002_regionCode%>" outnum="4" retcode="retCode1GetMarket" retMsg="retMsgGetMarket">
		<wtc:param value=""/> 
		<wtc:param value="01"/>
		<wtc:param value=""/>
		<wtc:param value="<%=workNo%>"/>
		<wtc:param value="<%=loginNoPass%>"/>
		<wtc:param value="<%=phone_no%>"/>
		<wtc:param value=""/>
	</wtc:service>
	<wtc:array id="resultGetMarket" scope="end"/>
  <%
		if(!"000000".equals(retCode1GetMarket)){
			ifOpenMarket = false;
	}else{
		if(resultGetMarket == null || resultGetMarket.length == 0){
			ifOpenMarket = false;
		}else{
			ifOpenMarket = true;
		}
	}
  
%>
<script type="text/javascript">
	if("<%=scriptVal%>" == "true"){
	  if("<%=accountType%>"!="2"){ //如果是客服工号登陆，则不弹出此营销推荐页面
	  	if("<%=ifOpenMarket%>" == "true"){
	  		window.parent.popupDiv('pop-div');
		}
	  }
	}
</script>
<wtc:service name="sHintMsgQry" outnum="1" routerKey="region" routerValue="<%=bd0002_regionCode%>" retcode="retCodeqth" retmsg="retMsgqth">
		<wtc:param value=""/>
		<wtc:param value="01"/>
		<wtc:param value=""/>
		<wtc:param value="<%=workNo%>"/>
		<wtc:param value="<%=loginNoPass%>"/>
		<wtc:param value="<%=phone_no%>"/>
		<wtc:param value=""/>
	</wtc:service>
	<wtc:array id="resultqth" scope="end"/>
<script type="text/javascript">
	if("<%=retCodeqth%>" == "000000"){
	}
	else{
		rdShowMessageDialog("<%=retMsgqth%>",1);//错误提示
	}
</script>



		

<wtc:service name="sm468Init" outnum="4" routerKey="region" routerValue="<%=bd0002_regionCode%>" retcode="retCodesm468Init" retmsg="retMsgsm468Init">
		<wtc:param value=""/>
		<wtc:param value="01"/>
		<wtc:param value=""/>
		<wtc:param value="<%=workNo%>"/>
		<wtc:param value="<%=loginNoPass%>"/>
		<wtc:param value="<%=phone_no%>"/>
		<wtc:param value=""/>
	</wtc:service>
<wtc:array id="serverResult" scope="end"/>

<%

 String sm468Init_val = "";
 if(serverResult.length>0){
 		sm468Init_val = serverResult[0][2];
 		sm468Init_val = sm468Init_val.trim();
 }
 System.out.println("-------hejwa------------sm468Init_val------------->"+sm468Init_val);
 if(!"".equals(sm468Init_val)){
%>

<script type="text/javascript">
	  		window.parent.showsm468Init_val('<%=sm468Init_val%>');
</script>

<% 
 }
%>

<wtc:service name="sVolteQry" outnum="3" routerKey="region" routerValue="<%=bd0002_regionCode%>" retcode="code_sVolteQry" retmsg="msg_sVolteQry">
		<wtc:param value=""/>
		<wtc:param value="01"/>
		<wtc:param value=""/>
		<wtc:param value="<%=workNo%>"/>
		<wtc:param value="<%=loginNoPass%>"/>
		<wtc:param value="<%=phone_no%>"/>
		<wtc:param value=""/>
	</wtc:service>
<wtc:array id="result_sVolteQry" scope="end"/>
	
<%
	 String val_sVolteQry          = "";
	 String val_sVolteQry_trueCode = "";
	 
	 if(result_sVolteQry.length>0){
	 		val_sVolteQry          = result_sVolteQry[0][0];
	 		val_sVolteQry_trueCode = result_sVolteQry[0][1];
	 }
	 
	 System.out.println("-------hejwa------------------code_sVolteQry------->"+code_sVolteQry);
	 System.out.println("-------hejwa------------------msg_sVolteQry------->"+msg_sVolteQry);
	 System.out.println("-------hejwa------------------val_sVolteQry_trueCode------->"+val_sVolteQry_trueCode);
	 System.out.println("-------hejwa------------------val_sVolteQry------->"+val_sVolteQry);
	 
	 String sVolteQry_msg = "";
	 
	 if("Y".equals(val_sVolteQry)){
	 		sVolteQry_msg += "该用户是VOLTE终端用户，但未办理VOLTE业务！<br>";
	 }
	 
	 if(!"1".equals(val_sVolteQry_trueCode)){
			sVolteQry_msg += "请进行实名登记，补充客户资料。<br>";
	 }
	 
	 if(!"".equals(sVolteQry_msg)){
	 %>

<script type="text/javascript">
	  		window.parent.show_sVolteQry_val("<%=sVolteQry_msg%>","<%=val_sVolteQry%>");
</script>

<% 
	 }
	 
%>









	