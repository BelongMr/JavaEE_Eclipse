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
		String opCode = "d568";
		String opName = "�����ն˽ɷ���Ϣ��ѯ";
		Calendar today = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		String dtime = sdf.format(today.getTime());
    today.add(Calendar.MONTH,-12);
    /*Ĭ�ϣ�12����֮ǰ*/
    String startTime = sdf.format(today.getTime());
	activePhone = request.getParameter("activePhone");	
%>
<HTML>
<HEAD>
<script language="JavaScript">
<!--	








function check_HidPwd()
{
  if(document.frm.phoneno.value=="")
  {
     rdShowMessageDialog("������������!");
     document.frm.phoneno.focus();
     return false;
  }
  

  if( document.frm.phoneno.value!="" && document.frm.phoneno.value.length != 11 )
  {
     rdShowMessageDialog("�������ֻ����11λ!");
     document.frm.phoneno.value = "";
     document.frm.phoneno.focus();
     return false;
  }
	            
	
}

 function docheck()
{
	
  if(document.frm.check_code.value=="" && document.frm.check_no.value=="" &&document.frm.loginno.value=="" &&document.frm.phoneno.value=="")
  {
      rdShowMessageDialog("���������뷢Ʊ���롢��Ʊ���롢�������Ż�ɷѺ����е�һ����Ϊ��ѯ����!");
     	document.frm.check_code.focus();
     	return false;
  }
  if(document.frm.print_begin.value=="" &&document.frm.print_end.value=="")
  {
      rdShowMessageDialog("��ӡ��ʼ�ͽ���ʱ����ôȷ��?");
     	document.frm.print_begin.focus();
     	return false;
  }
		var s_begin = document.frm.print_begin.value;
		var s_end = document.frm.print_end.value;
  
        
		if(((/^20[0-9][0-9]((0[1-9])|(1[0-2]))$/.test(s_begin)) == false) )
		{
			rdShowMessageDialog("��ӡ��ʼʱ���ʽ����ȷ!�밴YYYYMM��ʽ����!");
			document.frm.print_begin.value="";
			document.frm.print_begin.focus();
			return false;
		}
		if(((/^20[0-9][0-9]((0[1-9])|(1[0-2]))$/.test(s_end)) == false) )
		{
			rdShowMessageDialog("��ӡ����ʱ���ʽ����ȷ!�밴YYYYMM��ʽ����!");
			document.frm.print_end.value="";
			document.frm.print_end.focus();
			return false;
		}
		//���� ��ʼʱ��>����ʱ��Ļ� ����~
		if(s_begin>s_end)
		{
			rdShowMessageDialog("��ӡ��ʼʱ�䲻���Դ��ڽ���ʱ��!");
			return false;
		}
		//���� ����ʱ��-��ʼʱ��>12������
		 
		var month_1 =  DateDiff2(s_begin,s_end);
		//alert("�·ݲ��� "+month_1);
		if(month_1>12){
			rdShowMessageDialog("��ӡ��ʼ���ӡ����ʱ���������Դ���12����!");
			return false;
		}
	   document.frm.action="d568_2.jsp?check_code="+document.frm.check_code.value+"&check_no="+document.frm.check_no.value+"&loginno="+document.frm.loginno.value+"&phoneno="+document.frm.phoneno.value;
	   document.frm.query.disabled=true;
	   document.frm.submit();
 
	 
 } 
//�����²�ĺ���
function DateDiff2(date1,date2){
	  var year1 =  date1.substr(0,4);
	  var year2 =  date2.substr(0,4); 
	  var month1 = date1.substr(4,2);
	  var month2 = date2.substr(4,2);
	  
	  var len=(year2-year1)*12+(month2-month1);
	  
	  return len;


}
 


 
 
  function doclear() {
 		frm.reset();
 }


//��ȡ��ʼ����ʱ���
function GetDateT(){
	
  var d,s;
  d = new Date();
  //ȡ���
  s = d.getYear().toString() ;
  //ȡ�·�
  if(d.getMonth()<9){
		s = s + "0"+((d.getMonth() + 1).toString()) ;
  }
  else{
		s = s + ((d.getMonth() + 1).toString()) ;
  }
  //ȡ����
  /*if(d.getDate()<10){
	  s = s+"0"+d.getDate().toString() ;
  }
  else{
	  s = s+d.getDate().toString() ;
  }*/
  document.getElementById("edate").value=s ;
  //��ʼʱ�� �����鷳���㷨
  var s1,s2;
  alert("d.getMonth is "+d.getMonth());
  if(d.getMonth()>5 ){ // ���ֵ �Ժ�������
		s2 = d.getMonth() + 1-12;
		if(s2<10){
		 s2 = "0"+s2.toString();
		}
		s1 = d.getYear().toString() ;
  }
  else if(d.getMonth()< 5){
    s2 = d.getMonth() + 1+12-12;
		if(s2<10){
		s2 = "0"+s2.toString();
		}
		s1 = (d.getYear()-1).toString() ;
  }
  else{
	  s2 = 12;
	  s1 = (d.getYear()-1).toString() ;
  }
  s1 = s1 + s2 ;//ȡ�·�
  //ȡ����
  /*
  if(d.getDate() <10 ){
		s1 = s1+ "0"+d.getDate().toString() ;
  }
  else{
		s1 = s1+ d.getDate().toString() ;
  }*/
  document.getElementById("bdate").value=s1 ;
  alert('full is '+s);
}



-->
 </script> 
 
<title>������BOSS-��ͨ�ɷ�</title>
</head>
<BODY>
<form action="" method="post" name="frm">
		
		<%@ include file="/npage/include/header.jsp" %>   
  	<div class="title">
			<div id="title_zi">�������ѯ����</div>
		</div>
	<table cellspacing="0">
    <tr> 
      <td class="blue" width="15%">��Ʊ����</td>
      <td> 
        <input class="button"type="text" name="check_code" size="20" maxlength="12"  onKeyPress="return isKeyNumberdot(0)" >
      </td>
      <td class="blue">��Ʊ����</td>
      <td> 
        <input type="text" name="check_no" size="20" maxlength="20" onKeyPress="return isKeyNumberdot(0)" >
      </td>
       
    </tr>
	<tr>
		<td class="blue">��ӡ��ʼ�·�</td>
      <td> 
        <input type="text" name="print_begin" id = "bdate" value="<%=startTime%>" size="20" maxlength="6" onKeyPress="return isKeyNumberdot(0)" >
      </td>
       <td class="blue">��ӡ�����·�</td>
      <td> 
        <input type="text" name="print_end" id= "edate" value="<%=dtime%>" size="20" maxlength="6" onKeyPress="return isKeyNumberdot(0)"  >
      </td>
	</tr>

	<tr>
		<td class="blue">��������</td>
      <td> 
        <input type="text" name="loginno" size="20" maxlength="20"  >
      </td>
       <td class="blue">�ɷѺ���</td>
      <td> 
        <input type="text" name="phoneno" value="<%=activePhone%>" readonly size="20" maxlength="20" onKeyPress="return isKeyNumberdot(0)"  >
      </td>
	</tr>


  </table>
  <table cellSpacing="0">
    <tr> 
      <td id="footer"> 
           <input type="button" name="query" class="b_foot" value="��ѯ" onclick="docheck()" >
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