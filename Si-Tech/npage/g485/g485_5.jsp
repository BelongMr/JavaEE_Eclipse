<%
/********************
 version v2.0
������: si-tech
*
*liuxmc
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>

<%
		String opCode = "g485";
		String opName = "�°淢Ʊͳ����Ϣ";
		String login_no = (String)session.getAttribute("workNo");
	  String sqlStr1 = "select region_code||group_id,region_name from sregioncode where region_code<=13 order by region_code";
		String sqlStr = "select region_code||district_code||group_id,district_name from sdiscode where use_flag='Y' and district_code!='99' order by district_code";
%>
<wtc:pubselect name="TlsPubSelBoss" outnum="2" retmsg="return_msg" retcode="return_code">
			<wtc:sql><%=sqlStr%></wtc:sql>
		  </wtc:pubselect>
<wtc:array id="return_result" scope="end"/>	 

<wtc:pubselect name="TlsPubSelBoss" outnum="2" retmsg="return_msg1" retcode="return_code1">
			<wtc:sql><%=sqlStr1%></wtc:sql>
		  </wtc:pubselect>
<wtc:array id="return_result1" scope="end"/>	 	

<%
   String case_options = "";
   String mode_options ="<option value=>--��ѡ��--</option>";
   for(int i=0;i<return_result.length;i++)
   {
     case_options += "<option value="+return_result[i][0]+">"+return_result[i][1]+"</option>";
   }
   
      for(int i=0;i<return_result1.length;i++)
   {
     mode_options += "<option value="+return_result1[i][0]+">"+return_result1[i][1]+"</option>";
   }
%>
<HTML>
<HEAD>
<script language="JavaScript">

  var modetypecode = new Array();//ģ�����
  var modetypename = new Array();//ģ������
  var casetypecode = new Array();//������ʹ���
  var casetypename = new Array();//�����������
  <%
  for(int m=0;m<return_result.length;m++)
  {
		out.println("casetypecode["+m+"]='"+return_result[m][0]+"';\n");
		out.println("casetypename["+m+"]='"+return_result[m][1]+"';\n");
  }
  for(int m=0;m<return_result1.length;m++)
  {
		out.println("modetypecode["+m+"]='"+return_result1[m][0]+"';\n");
		out.println("modetypename["+m+"]='"+return_result1[m][1]+"';\n");
  }
  %>
  
function getCase(control,controlToPopulate)
{
	for (var q=controlToPopulate.options.length;q>=0;q--) controlToPopulate.options[q]=null;
//  myEle = document.createElement("option") ;
//    myEle.value = control.value;
//      myEle.value = "00";
//        myEle.text = control.options[control.selectedIndex].text;
//        controlToPopulate.add(myEle) ;
	for ( x = 0 ; x < casetypecode.length  ; x++ )
   {
      if ( casetypecode[x].substr(0,2) == control.value.substr(0,2) )
      {
        myEle = document.createElement("option") ;
        myEle.value = casetypecode[x] ;
        myEle.text = casetypename[x] ;
        controlToPopulate.add(myEle) ;
      }
   }
	
}

function commit(){
	
	if(document.frm.s_Invoice_number.value=="")  {
     rdShowMessageDialog("��������ʼ��Ʊ����!");
     document.frm.s_Invoice_number.value = "";
     document.frm.s_Invoice_number.focus();
     return false;
  }
  
  if(document.frm.s_Invoice_number.value.length < 8)  {
     rdShowMessageDialog("��ʼ��Ʊ���볤�Ȳ���!");
     document.frm.s_Invoice_number.value = "";
     document.frm.s_Invoice_number.focus();
     return false;
  }
	
	if(document.frm.e_Invoice_number.value=="")  {
     rdShowMessageDialog("��������ֹ��Ʊ����!");
     document.frm.e_Invoice_number.value = "";
     document.frm.e_Invoice_number.focus();
     return false;
  }
  
  if(document.frm.e_Invoice_number.value.length < 8)  {
     rdShowMessageDialog("��ֹ��Ʊ���볤�Ȳ���!");
     document.frm.e_Invoice_number.value = "";
     document.frm.e_Invoice_number.focus();
     return false;
  }
  
  if(document.frm.Invoice_code.value=="")  {
     rdShowMessageDialog("�����뷢Ʊ����!");
     document.frm.Invoice_code.value = "";
     document.frm.Invoice_code.focus();
     return false;
  }
  
  if(document.frm.Invoice_code.value.length < 12)  {
     rdShowMessageDialog("��Ʊ���볤�Ȳ���!");
     document.frm.Invoice_code.value = "";
     document.frm.Invoice_code.focus();
     return false;
  }
  if(document.frm.s_in_ModeTypeCode.value =="")  {
     rdShowMessageDialog("��ѡ���������!");
     document.frm.s_in_ModeTypeCode.value = "";
     document.frm.s_in_ModeTypeCode.focus();
     return false;
  }
  if(document.frm.s_in_CaseTypeCode.value =="")  {
     rdShowMessageDialog("��ѡ����������!");
     document.frm.s_in_CaseTypeCode.value = "";
     document.frm.s_in_CaseTypeCode.focus();
     return false;
  }
  if(document.frm.yingyt.value =="")  {
     rdShowMessageDialog("��ѡ��Ӫҵ��!");
     document.frm.yingyt.value = "";
     document.frm.yingyt.focus();
     return false;
  }
  
	document.frm.submit();
	            
}

 function sel1() {
 		 
		window.location.href='g485_1.jsp';
 }

 function sel2(){
 
	window.location.href='e673_2.jsp';
 }
 
 function sel3(){
    window.location.href='e673_3.jsp';
 }
function sel4(){
    window.location.href='e673_4.jsp';
 }
function sel5(){
    window.location.href='e673_5.jsp';
 }
 
 function sel6(){
    window.location.href='e673_6.jsp';
 }
 function sel7(){
    window.location.href='e673_7.jsp';
}
 function doclear() {
 		frm.reset();
 }
 
function select_yyt()
{
	var region_code = document.all.s_in_ModeTypeCode[document.all.s_in_ModeTypeCode.selectedIndex].value.substring(0,2);
	var district_code = document.all.s_in_CaseTypeCode[document.all.s_in_CaseTypeCode.selectedIndex].value.substring(4);
	var myPacket = new AJAXPacket("../e673/e673_select.jsp","���ڻ��Ӫҵ����Ϣ�����Ժ�......");
//	alert(district_code);
//	var sqlStr = "select region_code||district_code||town_code,town_code||'-- >'||TOWN_NAME from sTownCode where region_code = '"+region_code+"' and district_code = '"+district_code+"' Order By town_code";
	var sqlStr = "select a.group_id,a.group_id||'-->'||b.group_name from dchngroupinfo a,dchngroupmsg b where a.parent_group_id = '"+district_code+"'and a.group_id = b.group_id and root_distance = 4 and b.is_active = 'Y'";
	myPacket.data.add("sqlStr",sqlStr);
	core.ajax.sendPacket(myPacket);
	myPacket = null;
}
function doProcess(packet)
{	 
    var triListdata = packet.data.findValueByName("tri_list");     
	document.all("yingyt").length=0;
	document.all("yingyt").options.length=triListdata.length;//triListdata[i].length;
	for(j=0;j<triListdata.length;j++)
	{
		document.all("yingyt").options[j].text=triListdata[j][1];
		document.all("yingyt").options[j].value=triListdata[j][0];
	}//Ӫҵ�������
	document.all("yingyt").options[0].selected=true;	  
}

 </script> 
 
<title>������BOSS-��Ʊ��Ϣ��ѯ��¼��</title>
</head>
<BODY>
<form action="g485_5Cfm.jsp" method="post" name="frm">
		<%@ include file="/npage/include/header.jsp" %>   
  	
		<div class="title">
			<div id="title_zi">�°淢Ʊͳ����Ϣ��¼��</div>
		</div> 

  <table cellspacing="0">
    <tr>
    	<td class="blue" width="15%">��ѯ��ʽ</td>
        <td> 
          <input name="busyType2" type="radio" onClick="sel1()" value="1">¼�뷢Ʊ����ͷ�Ʊ���� 
 
          <input name="busyType2" type="radio" onClick="sel5()" value="1" checked>Ӫҵ����Ʊ
       
      </td>
      
    </tr>
  </table>

  
  <table cellspacing="0">
    <tr>
    	<td align="left" class="blue" width="15%">��ʼ��Ʊ����:&nbsp;&nbsp;&nbsp;
        <input class="button" type="text" name="s_Invoice_number" size="10" maxlength="8" onKeyPress="return isKeyNumberdot(0)"><font color="#FF0000">*</font>
      </td>
      <td align="left" class="blue" width="15%">��ֹ��Ʊ����:&nbsp;&nbsp;&nbsp;
        <input class="button" type="text" name="e_Invoice_number" size="10" maxlength="8" onKeyPress="return isKeyNumberdot(0)"><font color="#FF0000">*</font>
      </td>
      <td align="left" class="blue" width="50%">��Ʊ����:&nbsp;&nbsp;&nbsp;
        <input class="button" type="text" name="Invoice_code" size="14" maxlength="12" onKeyPress="return isKeyNumberdot(0)"><font color="#FF0000">*</font>
      </td>      
    </tr>
    
    <tr>
    	<td align="left" class="blue" width="15%">��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��:&nbsp;&nbsp;&nbsp;
        <select name="s_in_ModeTypeCode" onchange="getCase(this,s_in_CaseTypeCode)">
          	<%=mode_options%>                   
          </select><font color="#FF0000">*</font>
      </td>
      <td align="left" class="blue" width="15%">��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��:&nbsp;&nbsp;&nbsp;
        <select name="s_in_CaseTypeCode" onchange="select_yyt()">
          	<option value="">--��ѡ��--</option>                   
          </select><font color="#FF0000">*</font>
      </td>
      <td align="left" class="blue" width="50%">Ӫҵ��:&nbsp;
        <select name="yingyt" style=width:80%>
          	<option value="">--��ѡ��--</option>                   
          </select><font color="#FF0000">*</font>
      </td>     
    </tr>
  </table>
           
  <table cellSpacing="0">
    <tr> 
      <td id="footer"> 
              <input type="button" name="query" class="b_foot" value="ȷ��" onclick="commit()" >
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
