   
<%
/********************
 version v2.0
 开发商 si-tech
 update hejw@2009-2-16
********************/
%>

<%@ page contentType="text/html;charset=gbk"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="java.util.*"%>

<%
	String loginNo = (String)session.getAttribute("workNo");
	String regionCode = (String)session.getAttribute("regCode");
	String dataJsp = "roleTreeXml.jsp?isRoot=true";
	String grouptype = request.getParameter("formFlag")==null?"form1":request.getParameter("formFlag");
	System.out.println("roletree.jsp");
	
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>角色结构树</title>
<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script language="JavaScript" src="xtree/script/loader.js"></script>
<link rel="stylesheet" type="text/css" href="xtree/css/xtree.css">
<style type="text/css">
a:link,a:visited { text-decoration: none; color: #111111 }
font { font-family: 宋体; font-size: 13px; }
</style>
<script language="JavaScript"> 
var treenode1;
//-----返回组织节点-------	
function saveTo(retRoleId,retRoleName,retRoleTypeCode,retPowerDes,retUseFlag,retOpNote,retCreatLogin,retCreatDate,retCreatName,retCreatGroup)
{
	<%
	if(grouptype.trim().equals("form1"))
	{
	%>
		window.opener.<%=grouptype%>.role_code_parter.value=retRoleId;
		window.opener.<%=grouptype%>.role_name_parter.value=retRoleName;
		window.opener.<%=grouptype%>.query_role_parter.disabled = true;
		window.close();
	<%
	}
	else
	{
	%>
		window.opener.<%=grouptype%>.role_code.value=retRoleId;     //将信息返回到调用的页面去
		window.opener.<%=grouptype%>.role_name.value=retRoleName;
		window.opener.<%=grouptype%>.roleType_code.value='5';
		window.opener.<%=grouptype%>.roleType_codeIn.value='5';
		window.opener.<%=grouptype%>.role_describe.value=retPowerDes;
		window.opener.<%=grouptype%>.use_flag.value=retUseFlag;
		window.opener.<%=grouptype%>.op_note.value=retOpNote;
		
		<%if(grouptype.trim().equals("form3"))
		{
		%>
			window.opener.<%=grouptype%>.create_login.value=retCreatLogin;
			window.opener.<%=grouptype%>.create_date.value=retCreatDate;
			window.opener.<%=grouptype%>.create_login_name.value=retCreatName;
			window.opener.<%=grouptype%>.create_login_GrpName.value=retCreatGroup;
		<%}%>
		
		window.opener.<%=grouptype%>.role_code.readOnly=true;
		window.opener.<%=grouptype%>.query_role.disabled=true;
		window.opener.form4.bSubmit4.disabled=false;
		window.close();
	<%}%>
}

</SCRIPT>
</head>
<body>
<form name="frm" method="post" action="">
    <%-- modified by hanfa 20061113 --%>
    
	<div id="POP_Title_block">
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="40%" align="left" class="shadow"><span id="titlename"><script language="javascript">document.write(document.title);</script></span></td>
				<td width="60%" align="right" class="shadow">&nbsp;
				</td>
			</tr>
		</table>
	</div>
	<%-- added by hanfa 20061113 --%>
	
	<table  cellspacing="0" border="0" >
    	<tr> 
    		<TD width="20" ></TD>
			<td height="300" valign="top" nowrap>
				<script>loader();</script>
				<div id="xtree"  XmlSrc="<%=dataJsp%>"></div>
				<script language="JavaScript">
				<!--
					document.all.xtree.className="xtree";
				//-->
				</script>
			</td>
		</tr>
	</table>
	<br>
	<br>
	</td>
	</tr>
</table>
</body>
</html>