<%@ page contentType="text/html;charset=GBK"%>
<%
	String meansId = request.getParameter("meansId");
	String svcNum = request.getParameter("svcNum"); 
	String orderId = request.getParameter("orderId");
 %>
<html>
<head>
	</head>
	<body>
		<form name ="custInfoFrm" action="custInfo.jsp"  method="post">
			<input name ="custInfo" id="custInfo" type="hidden"/>
			<input name ="meansId" id="meansId" type="hidden" value = "<%=meansId%>"/>
			<input name ="svcNum" id="svcNum" type="hidden" value = "<%=svcNum%>"/>
			<input name ="orderId" id="orderId" type="hidden" value = "<%=orderId%>"/>
		</form>
	</body>
	<script type="text/javascript">
		window.onload=function(){
		 		document.forms[0].custInfo.value= parent.document.getElementById("global_custInfo").value;
		 		document.forms[0].submit();
		 }
	</script>
</html>