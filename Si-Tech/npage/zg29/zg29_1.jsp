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
String opCode = "zg29";
String opName = "��ֵ˰��Ʊ���Ͽ���";
String workno = (String)session.getAttribute("workNo");
String contextPath = request.getContextPath();
 

%> 
<HTML>
<HEAD>
<script language="JavaScript">
function docheck()
{
	var tax_number = document.all.tax_number.value;
	var tax_code = document.all.tax_code.value;
	var cust_id = document.all.cust_id.value; 
	var tax_no = document.all.tax_no.value; 
	//var year_month =  document.all.year_month.value;
	if(tax_number=="")
	{
		rdShowMessageDialog("���������ַ�Ʊ����!");
		return false;
	}
	else if(tax_code=="")
	{
		rdShowMessageDialog("���������ַ�Ʊ����!");
		return false;
	}
	else if(tax_no=="")
	{
		rdShowMessageDialog("��������˰��ʶ���!");
		return false;
	}
	else if(cust_id=="")
	{
		rdShowMessageDialog("������ͻ�ID!");
		return false;
	}
	/*
	else if(year_month=="")
	{
		rdShowMessageDialog("������רƱ��������!");
		return false;
	}*/
	else
	{
		var h=480;
		var w=650;
		var t=screen.availHeight/2-h/2;
		var l=screen.availWidth/2-w/2;
		var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
		//alert("1");
		//1.��ѯcust_id ���û�ȥѡ
		//cust_id="33005780155";
		//tax_no="1233";
		returnValue = window.showModalDialog('../zg12/getContractByCustId.jsp?cust_id='+cust_id+"&tax_no="+tax_no+"&qry_flag=2","",prop);
		alert("here add test "+returnValue);
		document.frm.tax_contract_no.value=returnValue.split(",")[6];
		document.frm.tax_name.value=returnValue.split(",")[2];
		document.frm.tax_no1.value=returnValue.split(",")[1];
		document.frm.tax_address.value=returnValue.split(",")[3];
		document.frm.tax_phone.value=returnValue.split(",")[4];
		document.frm.tax_khh.value=returnValue.split(",")[5];
		document.frm.tax_contract_no.value=returnValue.split(",")[6];
		document.frm.action="zg29_2.jsp";
		//alert("test111 "+document.frm.action);
	    document.frm.submit();
	}
	
} 

	
function doProcess(packet)
{
	var tax_number = document.all.tax_number.value;
	var tax_code = document.all.tax_code.value;
	var cust_id = document.all.cust_id.value;
	var s_flag = packet.data.findValueByName("s_flag");
	var s_good_name = packet.data.findValueByName("s_good_name");
	var s_ggxh = packet.data.findValueByName("s_ggxh");
	var s_dw = packet.data.findValueByName("s_dw");
	var s_sl = packet.data.findValueByName("s_sl");
	var s_dj = packet.data.findValueByName("s_dj");
	var s_je = packet.data.findValueByName("s_je");
	var s_tax_rate = packet.data.findValueByName("s_tax_rate");
	var s_se = packet.data.findValueByName("s_se");
 
	
	//alert("s_flag is "+s_flag+" and s_contract_no is "+s_contract_no);
	if(s_flag=="Y")
	{
		document.frm.action="zg27_2.jsp?s_good_name="+s_good_name+"&s_ggxh="+s_ggxh+"&s_dw="+s_dw+"&s_sl="+s_sl+"&s_dj="+s_dj+"&s_je="+s_je+"&s_tax_rate="+s_tax_rate+"&s_se="+s_se+"&tax_number="+tax_number+"&tax_code="+tax_code+"&cust_id="+cust_id;
	    document.frm.submit();
	}
	else
	{
		rdShowMessageDialog("���ַ�Ʊ��Ϣ�����ڣ�����������!");
		return false;
	}
}	
 

 
 
  function doclear() {
 		frm.reset();
 }


 function inits()
 {
	 //document.getElementById("query_id").disabled=true;
	
 }

 
  function doExport()
  {
	  
	  document.frm.action="zg12_export.jsp";
	  document.frm.submit();

  }
  function doImport()
  {
	  alert("1");
	  document.frm.action="zg12_import.jsp";
	  document.frm.submit();
  }
  function doTest()
  {
	  alert("1");
	  document.frm.action="zg12_xmltest.jsp";
	  document.frm.submit();
  }
  function do_paynote()
  {
	  alert("?");
	  document.frm.action="zg12_paynote.jsp";
	  document.frm.submit();
  }
 </script> 
 
<title>������BOSS-��ͨ�ɷ�</title>
</head>
<BODY onload="inits()">
<form action="" method="post" name="frm">
<input type="hidden" name="tax_name">
<input type="hidden" name="tax_no1">
<input type="hidden" name="tax_address">
<input type="hidden" name="tax_phone">
<input type="hidden" name="tax_khh">
<input type="hidden" name="tax_contract_no">		
		<%@ include file="/npage/include/header.jsp" %>   
  	 
	<table cellspacing="0">
    <tr> 
      <td class="blue" width="15%">ԭ���ַ�Ʊ����</td>
      <td> 
        <input class="button"type="text" name="tax_number" size="20"  colspan=2  onKeyPress="return isKeyNumberdot(0)"  >
      </td>
    </tr>
	<tr> 
      <td class="blue" width="15%">ԭ���ַ�Ʊ����</td>
      <td> 
        <input class="button"type="text" name="tax_code" size="20"  colspan=2  onKeyPress="return isKeyNumberdot(0)"  >
      </td>
    </tr>

	<tr> 
      <td class="blue" width="15%">��˰��ʶ���</td>
      <td> 
        <input class="button"type="text" name="tax_no" size="20"  colspan=2   onKeyPress="return isKeyNumberdot(0)"  >
      </td>
	  
    </tr>
	<tr> 
      <td class="blue" width="15%">�ͻ�ID</td>
      <td> 
        <input class="button"type="text" name="cust_id" size="20"  colspan=2   onKeyPress="return isKeyNumberdot(0)"  >
      </td>
    </tr>
	<!--
	<tr> 
      <td class="blue" width="15%">��ѯ����</td>
      <td> 
        <input class="button"type="text" name="year_month" size="20"  colspan=2 maxlength=6 onKeyPress="return isKeyNumberdot(0)"  >(YYYYMM)
      </td>
    </tr>  
	-->


  </table>
  <table cellSpacing="0">
    <tr> 
      <td id="footer"> 
	  <!--
	  <input type="button" id="test" name="test" class="b_foot" value="����չʾpay_note" onclick="do_paynote()" >
	  <input type="button" id="query_id" name="export" class="b_foot" value="javabeantest" onclick="doTest()" >
		   <input type="button" id="query_id" name="export" class="b_foot" value="����" onclick="doExport()" >	
		   <input type="button" id="imp_id" name="import" class="b_foot" value="����" onclick="doImport()" >	
        -->
      <input type="button" id="query_id" name="query" class="b_foot" value="��ѯ" onclick="docheck()" >
        
	  <input type="button" name="return1" class="b_foot" value="���" onclick="doclear()" >

	  <input type="button" name="return2" class="b_foot" value="�ر�" onClick="removeCurrentTab()" >
	  </td>
	   
    </tr>
  </table>
	<%@ include file="/npage/include/footer_simple.jsp"%>
  <%@ include file="../../npage/common/pwd_comm.jsp" %>
</form>
 </BODY>
</HTML>