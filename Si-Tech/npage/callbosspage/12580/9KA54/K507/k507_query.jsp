<%
  /*
   * ����: ������־��ѯ����
�� * �汾: 1.0.0
�� * ����: 2009/01/09
�� * ����: libin
�� * ��Ȩ: sitech
   * update:
�� */
%>

<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_ajax.jsp"%>
<%@ page import="com.sitech.crmpd.core.wtc.util.*,java.util.*,java.text.SimpleDateFormat"%>

<%
	SimpleDateFormat esdf = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
	String bnowdate = esdf.format(new Date());
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String nowdate = sdf.format(new Date());
	
	String opCode = "K507";
	String opName = "������־��ѯ����";
	String loginNo = (String) session.getAttribute("workNo"); 
%>

<html>
<head>
<title>������־��ѯ����</title>
<meta http-equiv=Content-Type content="text/html; charset=GBK">
		<link
			href="<%=request.getContextPath()%>/nresources/default/css/FormText.css"
			rel="stylesheet" type="text/css"></link>
		<link
			href="<%=request.getContextPath()%>/nresources/default/css/font_color.css"
			rel="stylesheet" type="text/css"></link>
		<link
			href="<%=request.getContextPath()%>/nresources/default/css/ValidatorStyle.css"
			rel="stylesheet" type="text/css"></link>
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/njs/extend/jquery/jquery123_pack.js"></script>
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/njs/si/core_sitech_pack.js"></script>
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/njs/redialog/redialog.js"></script>
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/njs/extend/jquery/block/jquery.blockUI.js"></script>
		<script language="JavaScript"
			src="<%=request.getContextPath()%>/njs/si/validate_pack.js"></script>
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/njs/extend/jquery/hotkey/jquery.hotkeys_jsa.js"></script>
		<script language="javascript" type="text/javascript"
			src="<%=request.getContextPath()%>/npage/callbosspage/js/datepicker/WdatePicker.js"></script>
	<script language=javascript>
		function queryData(){
		  window.sitechform.action="k507_list.jsp";
		  window.sitechform.target="rightFrame";
   		window.sitechform.method="post";
   		window.sitechform.submit();
		}
		
	</script>
</head>

<body>
<form name="sitechform" id="sitechform">
			<div id="Operation_Table">
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th align="center">����</th>
					<th align="center">ֵ</th>
				</tr>
				<tr>
					<td>������ʼʱ��</td>
					<td>
						<input id="begintime" name="beginTime" type="text" value="<%=bnowdate %>"/>
						<img onclick="WdatePicker({el:$dp.$('begintime'),dateFmt:'yyyy-MM-dd HH:mm:ss',position:{top:'under'}})" src="<%=request.getContextPath()%>/npage/callbosspage/js/datepicker/skin/datePicker.gif" width="16" height="22" align="absmiddle">
					</td>
				</tr>
				<tr>
					<td>��������ʱ��</td>
					<td>
						<input id="endtime" name="endTime" type="text" value="<%=nowdate %>"/>
						<img onclick="WdatePicker({el:$dp.$('endtime'),dateFmt:'yyyy-MM-dd HH:mm:ss',position:{top:'under'}})" src="<%=request.getContextPath()%>/npage/callbosspage/js/datepicker/skin/datePicker.gif" width="16" height="22" align="absmiddle">
					</td>
				</tr>
				<tr>
					<td>����Ա����</td>
					<td><input name="send_login_no" value="<%=loginNo%>" /></td>
				</tr>
				<tr>
					<td>���к���</td>
					<td><input name="caller_phone" value="" /></td>
				</tr>
				<tr>
					<td>Ŀ�����</td>
					<td><input name="user_phone" value="" /></td>
				</tr>
			</table>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td id="footer" align=center>
						<input class="b_foot" name="submit1" type="button" value="��ѯ" onclick="queryData();">
						<input class="b_foot" name="reset1" type="reset" value="����">
					</td>
				</tr>
			</table>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						��������
					</td>
				</tr>
				<tr>
					<td>
						<textarea name="content" cols="37" rows="10" readonly="true"></textarea>
					</td>
				</tr>
			</table> 
		</div>
</form>
</body>
</html>