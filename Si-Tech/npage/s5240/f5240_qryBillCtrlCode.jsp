   
<%
/********************
 version v2.0
 ������ si-tech
 update hejw@2009-2-17
********************/
%>
              
<%
  String opCode = "5240";
  String opName = "��Ʒ����";
%>              

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http//www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http//www.w3.org/1999/xhtml">
	
<%@ include file="/npage/include/public_title_name.jsp" %> 
<%@page contentType="text/html;charset=gb2312"%>
<%@ page import="org.apache.log4j.Logger"%>
<%
String regionCode = (String)session.getAttribute("regCode");			
	String ctrlFlag = request.getParameter("ctrlFlag");	
	String region_code = request.getParameter("region_code");	

	String sqlStr1="";
	String[][] retListString1 = new String[][]{};
	sqlStr1 = "select ctrl_code, ctrl_name from sBillCtrlCode where region_code in ( '" +
			  region_code + "','99') and ctrl_flag  in ('" + ctrlFlag + "', 'S') order by ctrl_code";
			  %>
			  
		<wtc:pubselect name="sPubSelect" outnum="2" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=sqlStr1%></wtc:sql>
 	  </wtc:pubselect>
	 <wtc:array id="result_t" scope="end"/>
			  
			  <%
	//retList1 = impl.sPubSelect("2",sqlStr1,"region",regionCode);
	if(result_t.length>0&&code.equals("000000"))
 retListString1 = result_t;
%>

<html>
<head>
<title>�����б�</title>
<META content="text/html; charset=gb2312" http-equiv=Content-Type>
<meta http-equiv="Expires" content="0">
</head>
<body>
<form name="frm" method="POST" >
	<%@ include file="/npage/include/header_pop.jsp" %>                         


	<div class="title">
		<div id="title_zi">ѡ���������</div>
	</div>
<table  id="tab1"  cellspacing="0">
	<tr >
		<th height="26" align="center">
			ѡ��
		</th>
		<th  align="center">
			���ƴ���
		</th>
		<th align="center">
			��������
		</th>
	</tr>
</table>
<table  cellspacing="0">
	<tr>
		<td id="footer">
				<div align="center">
			      <input type="button" name="commit" onClick="doCommit();" value=" ȷ�� " class="b_foot">
			      &nbsp;
			      <input type="button" name="back" onClick="doClose();" value=" �ر� " class="b_foot">
		    </div>
		</td>
	</tr>
</table>
<%@ include file="/npage/include/footer_pop.jsp" %>
</form>
</body>
</html>

<script>
	  
		<%for(int i=0;i < retListString1.length;i++){ %>
			var str='<input type="hidden" name="befCtrlCode" value="<%=retListString1[i][0]%>">';
			str+='<input type="hidden" name="befCtrlCodeName" value="<%=retListString1[i][1]%>">';
		
			var rows = document.getElementById("tab1").rows.length;
			var newrow = document.getElementById("tab1").insertRow(rows);
			newrow.bgColor="#f5f5f5";
			newrow.height="20";
			newrow.align="center";
			newrow.insertCell(0).innerHTML ='<input type="radio" name="num" value="<%=i%>">'+str;
		  newrow.insertCell(1).innerHTML = '<%=retListString1[i][0]%>';
		  newrow.insertCell(2).innerHTML = '<%=retListString1[i][1]%>';
		<%}%>

		function doCommit()
		{
			if("<%=retListString1.length%>"=="0"){
				rdShowMessageDialog("��û��ѡ���κο��ƴ��룡");
				return false;
			}
			else if("<%=retListString1.length%>"=="1"){//ֵΪһ��ʱ����Ҫ������
				if(document.all.num.checked){
					if("<%=ctrlFlag%>" == "B")
					{
						window.opener.form1.before_ctrl_code.value=document.all.befCtrlCode.value;
						window.opener.form1.befCtrlCodeName.value=document.all.befCtrlCodeName.value;
					
					} else if("<%=ctrlFlag%>" == "E"){
						window.opener.form1.end_ctrl_code.value=document.all.befCtrlCode.value;
						window.opener.form1.endCtrlCodeName.value=document.all.befCtrlCodeName.value;
					}
					
				}
				else{
					rdShowMessageDialog("��û��ѡ���κο��ƴ��룡");
					return false;
				}
			}
			else{//ֵΪ����ʱ��Ҫ������
				var a=-1;
				for(i=0;i<document.all.num.length;i++){
					if(document.all.num[i].checked){
						a=i;
						break;
					}
				}
				if(a!=-1){
					if("<%=ctrlFlag%>" == "B"){
						window.opener.form1.before_ctrl_code.value=document.all.befCtrlCode[a].value;
						window.opener.form1.befCtrlCodeName.value=document.all.befCtrlCodeName[a].value;
					} else if("<%=ctrlFlag%>" == "E"){
						window.opener.form1.end_ctrl_code.value=document.all.befCtrlCode[a].value;
						window.opener.form1.endCtrlCodeName.value=document.all.befCtrlCodeName[a].value;
					}
					
				}
				else{
					rdShowMessageDialog("��û��ѡ���κο��ƴ��룡");
					return false;
				}
			}
			window.close();
		}
	
	function doClose()
	{
		
		window.close();
	}
</script>