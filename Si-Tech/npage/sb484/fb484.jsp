<%
    /********************
     version v2.0
     ������: si-tech
     *
     *create:wanghfa@2010-9-6 TD�̻����¹���
     *
     ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ page contentType="text/html; charset=GB2312" %>
<%@ include file="/npage/include/public_title_name.jsp" %>

<html>
<head>
<title>���ಿTD�̻�Ԥ����</title>
<META content="MSHTML 5.00.3315.2870" name=GENERATOR>
<%
	String opCode = WtcUtil.repStr(request.getParameter("opCode"), "");
	String opName = WtcUtil.repStr(request.getParameter("opName"), "");
	System.out.println("===wanghfa===" + opCode + opName);
%>

<script language=javascript>
	var opFlag;
	
	window.onload = function() {
		opchange();
	}
	
	function opchange() {
	 if (document.getElementsByName("opFlag")[0].checked) {
			opFlag = "2";
<%
			if ("b484".equals(opCode) || "b485".equals(opCode)) {
%>
				document.getElementById("opCode").value = "b485";
				document.getElementById("opName").value = "TD�̻����¹�������";
<%
			} else if ("b486".equals(opCode) || "b487".equals(opCode)) {
%>
				document.getElementById("opCode").value = "b487";
				document.getElementById("opName").value = "TD�̻����¹�����������ͨ��";
<%
			}
%>
			document.getElementById("backInput").style.display = "";
		}
	}
	
	function submitt() {
		if (opFlag == "1") {
			buttonSub = document.getElementById("cubmitt");
			buttonSub.disabled = "true";
			
			frm.action = "fb484_main.jsp";
			frm.submit();
		} else if (opFlag == "2") {
			if (!check(document.getElementById("frm"))) {
				if (document.getElementById("backAccept").value.trim().length == 0) {
					rdShowMessageDialog("��ˮ����Ϊ�գ����������롣");
					return;
				} else if (!checkElement(document.getElementById("backAccept"))) {
					rdShowMessageDialog("��ˮ��ʽ����ȷ�����������롣");
					return;
				}
			} else {
				buttonSub = document.getElementById("cubmitt");
				buttonSub.disabled = "true";
				
				frm.action = "fb485_main.jsp";
				frm.submit();
			}
		}
	}
</script>
</head>
<body>

<form name="frm" method="POST">
<input type="hidden" name="opCode" id="opCode" value="<%=opCode%>">
<input type="hidden" name="opName" id="opName" value="<%=opName%>">

<%@ include file="/npage/include/header.jsp" %>
<div class="title">
	<div name="title_zi" id="title_zi"><%=opName%></div>
</div>

<table cellspacing="0">
	<tr>
		<td class="blue" width="30%">
			��������
		</td>
		<td width="70%">
<%
			if ("b484".equals(opCode) || "b486".equals(opCode)) {
%>
			
			<input type="radio" name="opFlag" value="2" onclick="opchange()" checked>����&nbsp;&nbsp;
<%
			} else if ("b485".equals(opCode) || "b487".equals(opCode)) {
%>
			
			<input type="radio" name="opFlag" value="2" onclick="opchange()" checked>����&nbsp;&nbsp;
<%
			}
%>
		</td>
	</tr>
	<tr>
		<td class="blue">
			�绰����
		</td>
		<td>
			<input type="text" name="activePhone" id="activePhone" value="<%=activePhone%>" class="InputGrey" readonly>
		</td>
	</tr>
	<tr name="backInput" id="backInput" style="display:none">
		<td class="blue">
			ҵ����ˮ
		</td>
		<td>
			<input type="text" name="backAccept" id="backAccept" value="" v_must="1" v_type="0_9" v_name="ҵ����ˮ" maxlength="30" v_minlength="0" v_maxlength="30" onblur="checkElement(this);">
			<font class="orange">*</font>
		</td>
	</tr>
</table>
<table cellspacing="0">
	<tr>
	    <td colspan="3" id="footer">
	      <input class="b_foot" type=button name="cubmitt" value="ȷ��" onClick="submitt();">
	      <input class="b_foot" type=button name="closeB" value="�ر�" onClick="parent.removeTab('<%=opCode%>')">
	    </td>
	</tr>
</table>
<%@ include file="/npage/include/footer_simple.jsp" %> 
</form>
</body>
</html>