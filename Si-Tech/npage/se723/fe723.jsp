<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<head>
	<%
   response.setHeader("Pragma","No-cache");
   response.setHeader("Cache-Control","no-cache");
   response.setDateHeader("Expires", 0);
		String opCode = request.getParameter("opCode");
		String opName = request.getParameter("opName");
		String workNo = (String)session.getAttribute("workNo");
		String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
		%>
		<script language="javascript">
		function doReset(){
			window.location.href = "fe723.jsp?opCode=<%=opCode%>&opName=<%=opName%>"
		}
		function quechoosee() {
		 
					var phoneNos = document.frm.phoneNo.value.trim();
				if(checkElement(document.frm.phoneNo)==false) {
				 return false;
				}
				  if(!check(frm))
					  {
					    return false;
					  }
					if(phoneNos.trim()=="") {
							rdShowMessageDialog("�û��ֻ��Ų���Ϊ�գ����������룡");
							return false;
					}
	 var begin_time=document.frm.begin_time.value;
  var end_time=document.frm.end_time.value;
  if(begin_time>end_time)
  {
    rdShowMessageDialog("��ʼʱ��Ƚ���ʱ������������룡");
    return false;
  }
  document.all.quchoose.disabled = true;
  //alert(end_time.trim());
				  var myPacket = new AJAXPacket("fe723_qry.jsp","���ڲ�ѯ�ַ��һ�������Ϣ�����Ժ�......");
	myPacket.data.add("PhoneNo",(document.all.phoneNo.value).trim());
	myPacket.data.add("begin_time",begin_time.trim());
	myPacket.data.add("end_time",end_time.trim());
	core.ajax.sendPacketHtml(myPacket,checkSMZValue,true);
	getdataPacket = null;

		}
  function checkSMZValue(data) {
  document.all.quchoose.disabled = false;
				//�ҵ����ӱ����div
				var markDiv=$("#gongdans"); 
				//���ԭ�б���
				markDiv.empty();
				markDiv.append(data);
}
		
				
		</script>
		<body>
		<form name="frm" method="POST" action="">
	<%@ include file="/npage/include/header.jsp" %>
		<div class="title">
		<div id="title_zi"><%=opName%></div>
	</div>
	      <table cellspacing="0" >
		  <tr>
		    <td class="blue" width="15%">�û��ֻ�����</td>
		    <td colspan="3">
		  <input name="phoneNo" type="text"   id="phoneNo" value=""   v_type="mobphone"  maxlength="11" size="17">

		</td>

	</tr>
			<tr id=a_time >
		<td class="blue">��ʼʱ��</td>
		<td>
			<input type="text"   name="begin_time" value=<%=dateStr%>  size="17" maxlength="8">
		</td>
		<td class="blue">����ʱ��</td>
		<td>
			<input type="text"   name="end_time" value=<%=dateStr%>  size="17" maxlength="8">
		</td>
	</tr> 
	<tr>
		<td colspan="4">
			<font class="orange">ʱ���ʽ��yyyyMMdd</font>
	</td>
	</tr>
</table>


	 	<table cellspacing="0">
		<tr>
			<td noWrap id="footer">
			<div align="center">
					<input type="button"  name="quchoose" class="b_foot" value="��ѯ" onclick="quechoosee()" />		
				&nbsp;
				<input name="back" onClick="doReset()" type="button" class="b_foot"  value="���">
				&nbsp;
				<input type="button" name="close" class="b_foot" value="�ر�" onClick="removeCurrentTab();"/>
			</div>
			</td>
		</tr>
	</table>
		<div id="gongdans">
		</div>	  
	    
 <%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>