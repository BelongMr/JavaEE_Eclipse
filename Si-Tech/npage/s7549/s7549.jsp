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

<%
		String opCode = "7549";
		String opName = "�ͻ����ó�����ϸ��ѯ";

%>
<HTML>
<HEAD>
<script language="JavaScript">

function commit(){
	
  if(document.frm.phoneNo.value=="")  {
     rdShowMessageDialog("������������!");
     document.frm.phoneNo.focus();
     return false;
  }
  
  if(document.frm.phoneNo.value.length != 11 ){
     rdShowMessageDialog("�������ֻ����11λ!");
     document.frm.phoneNo.value = "";
     document.frm.phoneNo.focus();
     return false;
  }
  
  var phoneNo = document.frm.phoneNo.value;
  
    var h=880;
    var w=1250;
   	var t=screen.availHeight/2-h/2;
		var l=screen.availWidth/2-w/2;

		var prop = "dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";

		var returnValue = window.showModalDialog('s7549_2.jsp?phoneNo='+phoneNo,"",prop);
	            
}

 function doclear() {
 		frm.reset();
 }


 </script> 
 
<title>������BOSS-�ͻ����ó�����ϸ��ѯ</title>
</head>
<BODY>
<form action="" method="post" name="frm">
		<%@ include file="/npage/include/header.jsp" %>   
  	
		<div class="title">
			<div id="title_zi">�ͻ����ó�����ϸ��ѯ</div>
		</div>

  
  <table cellspacing="0">
    <tr> 
      <td align="center" class="blue" width="15%">�������:&nbsp;&nbsp;&nbsp;
        <input class="button"type="text" name="phoneNo" size="20" maxlength="11"  onKeyPress="return isKeyNumberdot(0)" onKeyDown="if(event.keyCode==13) commit();">
      </td>
    </tr>
  </table>
           
  <table cellSpacing="0">
    <tr> 
      <td id="footer"> 
           <input type="button" name="query" class="b_foot" value="��ѯ" onclick="commit()" >
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