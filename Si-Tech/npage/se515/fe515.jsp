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
		%>
		<script language="javascript">
		function doReset(){
			window.location.href = "fe515.jsp?opCode=<%=opCode%>&opName=<%=opName%>"
		}
		function quechoosee() {

				if(checkElement(document.frm.phoneNo)==false) {
				 return false;
				}
					var phoneNos = document.frm.phoneNo.value.trim();
					if(phoneNos.trim()=="") {
							rdShowMessageDialog("�û��ֻ��Ų���Ϊ�գ����������룡",0);
							return false;
					}
				  var myPacket = new AJAXPacket("fe515_qry.jsp","���ڲ�ѯ�ͻ��Ƿ���ʵ���ƿͻ������Ժ�......");
	myPacket.data.add("PhoneNo",(document.all.phoneNo.value).trim());
	myPacket.data.add("opCode","<%=opCode%>");
	myPacket.data.add("opName","<%=opName%>");
	core.ajax.sendPacketHtml(myPacket,checkSMZValue,true);
	getdataPacket = null;

		}
  function checkSMZValue(data) {
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
		    <td width="35%">
		  <input name="phoneNo" type="text"   id="phoneNo" value=""   v_type="mobphone"  maxlength="11">

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