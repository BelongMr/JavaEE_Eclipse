<%
/********************
 version v2.0
 ������: si-tech
 update zhaohaitao at 2009.1.8
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml">

<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.*"%>
<%
  request.setCharacterEncoding("GBK");
%>
<html>
<head>
<title>ǩԼ����</title>
<%

    String opCode = request.getParameter("opCode");
    String opName = request.getParameter("opName");
    String phoneNo = request.getParameter("activePhone");

%>


</script>
<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>
<META content="MSHTML 5.00.3315.2870" name=GENERATOR>

<script language=javascript>
  onload=function()
  {
  	var phoneNo = "<%=phoneNo%>";
  	if(phoneNo==null||phoneNo=="")
  		removeCurrentTab();
    //document.all.srv_no.focus();
    var opCode = "<%=opCode%>";
    if(opCode=="126i"){
    	document.all.opFlag[1].checked=true;
    }
    opchange();
  }

 function controlButt(subButton){
	subButt2 = subButton;
    subButt2.disabled = true;
	setTimeout("subButt2.disabled = false",3000);
  }


//----------------��֤���ύ����-----------------
function doCfm(subButton)
{
  controlButt(subButton);//��ʱ���ư�ť�Ŀ�����
  //if(!check(frm)) return false;
  var radio1 = document.getElementsByName("opFlag");
  for(var i=0;i<radio1.length;i++)
  {
    if(radio1[i].checked)
	{
	  var opFlag = radio1[i].value;
	  if(opFlag=="one")
	  {
	  		if(document.all.sale_kind.value=="2")
	  		{
	  			 document.all.main_phoneno.v_type="mobphone";
	  			 document.all.main_phoneno.v_must=1;
	  			 document.all.main_phoneno.v_name="��������";
	  			 document.all.main_phoneno.maxlength="11" 
	  			 if(!check(frm)) return false; 
	  			 if(document.all.main_phoneno.value==document.all.srv_no.value)
	  			 {
	  			 	rdShowMessageDialog("����ҵ��������������벻����ͬ��");
	    			return;
	  			 }
	  		}
	    	frm.action="f126h_1.jsp";
	    	document.all.opcode.value="126h";
	    	
	  }else if(opFlag=="two")
	  {
	    if(document.all.backaccept.value==""){
	    	rdShowMessageDialog("������ҵ����ˮ��");
	    	return;
	    }
	   
	    	frm.action="f126i_1.jsp";
	    	document.all.opcode.value="126i";
	    	
	  }
	}
  }
  frm.submit();
  return true;
}
function opchange(){

			document.all.backaccept_id.style.display = "";
	  	document.all.salekin_id.style.display="none";
	  	document.all.mainphone_id.style.display="none";
	  	document.all.sale_kind.value="0";
	 
}
function salekindchg(){
	if(document.all.sale_kind.value=="2")
	{
		document.all.mainphone_id.style.display="";
	}
	else{
		document.all.mainphone_id.style.display="none";
	}
}
</script>
</head>
<body>

<form name="frm" method="POST" onKeyUp="chgFocus(frm)">
	<%@ include file="/npage/include/header.jsp" %>

		<div class="title">
			<div id="title_zi"><%=opName%></div>
		</div>

      <table cellspacing="0">
	  <TR>
		<TD class="blue">��������</TD>
		<TD>
			<input type="radio" name="opFlag" value="two" onclick="opchange()" checked>����
		</TD>
		      <input type="hidden" name="opcode" >
         </TR>
         <tr>
            <td class="blue">
              <div align="left">�ֻ�����</div>
            </td>
            <td>
            <div align="left">
                <input class="InputGrey" readonly  type="text" name="srv_no" id="srv_no" value="<%=phoneNo%>" v_minlength=1 v_maxlength=16 v_type="mobphone" v_must=1 index="0">
            </td>
         </tr>
         <TR style="display:none" id="backaccept_id">
	          <TD class="blue">ҵ����ˮ</TD>
              <TD>
			<input type="text" name="backaccept" v_must=1 >
			<font color="orange">*</font>
	          </TD>
         </TR>
          <TR id="salekin_id">
	          <TD class="blue">Ӫ����ʽ</TD>
	          <TD>
				<select name="sale_kind" onchange="salekindchg()">
				<option value="0" > 0-->��ͨ</option>
				<option value="1"> 1-->����</option>
				<option value="2"> 2-->����</option>
			</select>
			<font color="orange">*</font>
	          </TD>
         </TR>
         <TR id="mainphone_id" style="display:none" >
	          <TD class="blue">��������</TD>
              <TD>
			<input type="text" name="main_phoneno">
			<font color="orange">*</font>
	          </TD>
         </tr>
         <tr>
            <td colspan="2" id="footer">
              <div align="center">
              <input class="b_foot" type=button name="confirm" value="ȷ��" onClick="doCfm(this)" index="2">
              <input class="b_foot" type=button name=back value="���" onClick="frm.reset()">
		      <input class="b_foot" type=button name=qryP value="�ر�" onClick="removeCurrentTab();">
              </div>
           </td>
        </tr>
      </table>

 <input type="hidden" name="opCode" value="<%=opCode%>" >
 <input type="hidden" name="opName" value="<%=opName%>" >
 <%@ include file="/npage/include/footer_simple.jsp" %>
   </form>

</body>
</html>