<%
/********************
 version v2.0
������: si-tech
*
*update:zhanghonga@2008-08-15 ҳ�����,�޸���ʽ
*
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="java.text.*" %> 
<%@ page import="java.util.*" %>
<%
String opCode = "zg12";
String opName = "��ֵ˰רƱ��������";
String workno = (String)session.getAttribute("workNo");
String contextPath = request.getContextPath();

String[] inParas_dx = new String[2]; 
//�������� tax_id ��ˮ ����ʱ�� ��Ʒ����
//��ѯ �������µļ�¼
//�� DINVOICE_TAX_split and to_char(op_time,'YYYYMM')>=to_char(add_months(sysdate,-1),'yyyymm') ��һ���µ� 
inParas_dx[0]="select tax_name,to_char(phone_no),begin_ym,end_ym,to_char(login_accpet),to_char(op_time,'YYYYMMDD hh24:mi:ss')  from DINVOICE_TAX_split where spr=:s_no and flag='0' and  to_char(op_time,'YYYYMM')>=to_char(add_months(sysdate,-1),'yyyymm') order by op_time desc";
inParas_dx[1]="s_no="+workno;
%> 
<wtc:service name="TlsPubSelBoss" routerKey="phone" routerValue="15004675829"  retcode="retCodeims" retmsg="retMsgims" outnum="7">
	<wtc:param value="<%=inParas_dx[0]%>"/>
	<wtc:param value="<%=inParas_dx[1]%>"/>	
</wtc:service>
<wtc:array id="ret_ims" scope="end" />
<HTML>
<HEAD>
<script language="JavaScript">
 function doclear() {
 		frm.reset();
 }


 function inits()
 {
	 //document.getElementById("query_id").disabled=true;
 }
 function sel1()
 {
	window.location.href='zg12_1.jsp';
 }
 function sel2()
 {
	 window.location.href='zg12_tax.jsp';
 }
 function doQry(phone_no)
 {
	document.frm.action="zg12_2_cf.jsp?login_accept="+phone_no;
	//alert("test?"+document.frm.action);
	document.frm.submit();
 }
 </script> 
 
<title>������BOSS-��ͨ�ɷ�</title>
</head>
<BODY onload="inits()">
<form action="" method="post" name="frm">
		
<%@ include file="/npage/include/header.jsp" %>   
   
 
  
  <table cellSpacing="0">	 
	 <tr>
		<td><b>������˰������</b></td>
		<td><b>��Ʒ����</b></td>
		<td><b>רƱ�������뿪ʼ����</b></td>
		<td><b>רƱ���������������</b></td>
		<td><b>ҵ����ˮ</b></td>
		<td><b>����ʱ��</b></td>
		<td><b>����</b></td>
	 </tr>
		<%
			
			for(int i=0;i<ret_ims.length;i++)
			{
				%>
					<tr>
						<td><%=ret_ims[i][0]%></td>
						<td><%=ret_ims[i][1]%></td>
						<td><%=ret_ims[i][2]%></td>
						<td><%=ret_ims[i][3]%></td>
						<td><%=ret_ims[i][4]%></td>
						<td><%=ret_ims[i][5]%></td>
						<td><input type="button" name="qry" value="��ѯ" onclick="doQry('<%=ret_ims[i][4]%>')"></td>
					</tr>
				<%
			}
		%>	
	 
<input type="hidden" name="tax_contract_no">
<input type="hidden" name="tax_name">
<input type="hidden" name="tax_no1">
<input type="hidden" name="tax_address">
<input type="hidden" name="tax_phone">
<input type="hidden" name="tax_khh">
  </table>
  <table cellSpacing="0">
    <tr> 
      <td id="footer"> 
 
	  <input type="button" id="back_id" name="back" class="b_foot" value="����" onclick="window.location.href='zg12_1.jsp'" >
 
	  <input type="button" id="query_id" name="query" class="b_foot" value="��ѯ" onclick="doQry()" >
          &nbsp;
		    <input type="button" name="return1" class="b_foot" value="���" onclick="doclear()" >
          &nbsp;
		      <input type="button" name="return2" class="b_foot" value="�ر�" onClick="removeCurrentTab()" >
	 
      </td>
    </tr>
  </table>
	<%@ include file="/npage/include/footer_simple.jsp"%>
  <%@ include file="../../npage/common/pwd_comm.jsp" %>
</form>
 </BODY>
</HTML>