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
		String opCode = "zg44";
		String opName = "���⼯�Ź�ϵ����";
 	    String workno=(String)session.getAttribute("workNo");    //���� 
		String workname =(String)session.getAttribute("workName");//��������  	        
		String orgcode = (String)session.getAttribute("orgCode");  
		String regionCode = (String)session.getAttribute("regCode");
		String sysAccept = "";
%>
		<wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region"  routerValue="<%=regionCode%>" id="sLoginAccept"/>
<%   
    sysAccept = sLoginAccept;
    System.out.println("#           - ��ˮ��"+sysAccept);
%>

<HTML>
<HEAD>
<script language="JavaScript">
 
function xnjtcx()
{
	var phoneNo = document.frm.phoneNo.value;
	if(phoneNo=="")
	{
		rdShowMessageDialog("�����뼯�������˺�!");
		return false;
	}
	else
	{
		//alert(phoneNo);
		var myPacket = new AJAXPacket("zg44_check.jsp","�����ύ�����Ժ�......");
		myPacket.data.add("phoneNo",phoneNo);
		core.ajax.sendPacket(myPacket,doPosSubInfo3);
		myPacket=null;
	}
}
 function doPosSubInfo3(packet)
 {
	 //alert("2");
	 var s_flag =  packet.data.findValueByName("flag1");
	 var s_cust_name =  packet.data.findValueByName("s_cust_name");
	// alert("s_flag is "+s_flag+" and s_cust_name is "+s_cust_name);
	 if(s_flag=="0")
	 {
		document.getElementById("tj").disabled=false;
		document.frm.contract_name.value=s_cust_name;

	 }
	 else
	 {
		 rdShowMessageDialog("�����⼯���˺Ų�����,����������!");
		 document.frm.phoneNo.value="";
		 document.getElementById("tj").disabled=true;
	 }	
 }


 function doclear() {
 		frm.reset();
 }
   
 function sel1() {
 		window.location.href='zg44_1.jsp';
 }

 function sel2(){
    window.location.href='zg44_3.jsp';
 }
 function sel3(){
    window.location.href='zg44_cx.jsp';
 }
 function sel4(){
    window.location.href='zg44_del.jsp';
 }

 function sel5(){
    window.location.href='zg44_pladd.jsp';
 }

 function cyzhtj()//��Ա����
 {
	 //alert("cyzhtj");
	 document.getElementById("tjdetail").style.display="block";
	 document.getElementById("tjdetail2").style.display="block";
	 document.getElementById("tj").disabled=true;
	
 }
 
 function inits()
 {
	 document.getElementById("tjdetail").style.display="none";
	 document.getElementById("tjdetail2").style.display="none";
 }

 function addgrp()
 {
	// alert("addgrp");//�ֻ�����ɿ�
	 var phoneNo = document.frm.phoneNo.value;
	 var contract_name =  document.frm.contract_name.value;
	 var detail_phone =  document.frm.detail_phone.value;
	 var detail_contract =  document.frm.detail_contract.value;
	 if(detail_phone=="" ||detail_contract=="")
	 {
		rdShowMessageDialog("���ӵ����⼯�ų�Ա����������Ա�˺Ŷ�������Ϊ��!");
		return false;
	 }	
	 else
	 {
		 var prtFlag=0;
		 prtFlag=rdShowConfirmDialog("�Ƿ�ȷ���������⼯�����Ӳ���?");
		 if (prtFlag==1){
			var myPacket = new AJAXPacket("zg44_add.jsp","�����ύ�����Ժ�......");
			myPacket.data.add("unit_id",phoneNo);
			myPacket.data.add("contract_name",contract_name);
			myPacket.data.add("detail_phone",detail_phone);
			myPacket.data.add("detail_contract",detail_contract);
			core.ajax.sendPacket(myPacket,doPosSubInfo2);
			myPacket=null;
			
		 
		 }
		 else
		 { 
			return false;	
		 }
	 }
	 
 }

 function doPosSubInfo2(packet)
 {
	 //alert("2");
	 var s_flag =  packet.data.findValueByName("flag1");
	 var s_msg =   packet.data.findValueByName("s_msg");
	 var s_code =  packet.data.findValueByName("s_code");
	// alert("s_flag is "+s_flag);
	 if(s_flag=="0")
	 {
		rdShowMessageDialog("���ӳɹ�!");
		document.frm.detail_phone.value="";
		document.frm.detail_contract.value="";
	 }
	 else
	 {
		 rdShowMessageDialog("����ʧ��!�������"+s_code+",����ԭ��"+s_msg);
		 return false;
	 }
 }
 function dosubmit() 
 {
	 
	if(form.feefile.value.length<1)
	{
		rdShowMessageDialog("�����ļ�����������ѡ�������ļ���");
		document.form.feefile.focus();
		return false;
	}
	else 
	{
		setOpNote();
		//alert(document.all.remark.value);
		var seled = $("#seled").val();
		document.form.action="zg44_cfm1.jsp?remark="+document.form.remark.value+"&regCode="+"<%=regionCode%>"+"&sysAccept="+"<%=sysAccept%>"+"&seled="+seled;
		document.form.submit();
		document.form.sure.disabled=true;
		document.form.reset.disabled=true;
		return true;
	}
 }
 function setOpNote()
 {
	if(document.all.remark.value=="")
	{
	  document.all.remark.value = "����Ա��"+document.all.loginNo.value+"������������Ϣ����"; 
	}
	return true;
 }
 </script> 
 
<title>������BOSS-��ͨ�ɷ�</title>
</head>
<BODY  >
<FORM action="g247_cfm1.jsp" method=post name=form ENCTYPE="multipart/form-data">
		
		<%@ include file="/npage/include/header.jsp" %>   
  	<div class="title">
			<div id="title_zi">��ѡ�����÷�ʽ</div>
	</div>
	
	<table cellspacing="0">
      <tbody> 
	 
      <tr> 
        <td class="blue" width="15%">���÷�ʽ</td>
        <td colspan="4"> 
        	<q vType="setNg35Attr">
          <input name="busyType1" id="busyType1" type="radio" onClick="sel1()" value="1" >���⼯������ 
        </q>
 
          <q vType="setNg35Attr">
          <input name="busyType2" type="radio" onClick="sel2()" value="2" > ���ų�Ա����
          </q>
         <q vType="setNg35Attr">
          <input name="busyType2" type="radio" onClick="sel4()" value="4"> ���⼯�Ų�ѯ��ɾ��
          </q>
		  <q vType="setNg35Attr">
          <input name="busyType2" type="radio" onClick="sel3()" value="3"> ���ų�Ա��ϵ��ѯ
          </q>
		  <!--xl add  ��������-->
		  <q vType="setNg35Attr">
          <input name="busyType2" type="radio" onClick="sel5()" value="3" checked> ������Ա����
          </q>
		  <!--
		  <q vType="setNg35Attr">
          <input name="busyType2" type="radio" onClick="sel4()" value="4"> ���ų�Ա��ϵɾ��
          </q>
			 -->
     </tr>
	   
    </tbody>
  </table>
	
  <table cellspacing="0">
		              <tbody> 
			              <tr> 
				                <td class="blue" align=center width="20%">��������</td>
				                <td width="30%" colspan="2">
					                    <input type="text" size="30" class="InputGrey" readonly value="���⼯�Ź�ϵ����">
				                </td>				               		              
			                <td class="blue" align=center width="20%">�����ļ�</td>
			                <td width="30%" colspan="2"> 
			                  <input type="file" name="feefile">
			                </td>
		              	</tr>
		        </tbody> 
	    		</table>
		       <table  cellspacing="0">
		              <tbody> 
					  <!--
		              	 <TR id="bltys"  > 
						          <TD class="blue" align=center width="20%">������Դ</TD>
					              <TD >
					                 <select id="seled"  style="width:100px;">
														</select>
					
						          </TD>
						          </TR> 
						-->
			              <tr> 
				                <td class="blue" align=center width="20%">������ע</td>
				                <td colspan="2"> 
				                  	<input name=remark size=60 maxlength="60" >
				                </td>
			              </tr>
			              <tr> 
				                <td colspan="3">˵����<br>
				        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="red">�����ļ�ΪTXT�ļ�</font>��<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="red">ע��������ȷ�ԣ����������޷���ֵ���ָ���Ϊ"|"��</font><br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="red">���б���Ϊregion_code����������Ϊ01,�������Ϊ02���Դ����ơ�</font><br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���⼯�ű���|���⼯������|����|���б���|��Ա�ֻ�����|��Ա�ʻ�����  �س�<br>
						</td>
			              </tr>   
		              </tbody> 
		      </table>
		      <table  cellspacing="0">
		              <tbody> 
			              <tr> 
				                <td id="footer" > 
				                  <input class="b_foot" name=sure type=button value=ȷ�� onClick="dosubmit()">
				                  &nbsp;
				                 <input type="button" name="rets" class="b_foot" value="����" onClick="returnBefo()"/>
				                  &nbsp;			                  
				                  <input class="b_foot" name=reset type=reset value=�ر� onClick="removeCurrentTab()">
				                  &nbsp; 
				                 </td>
			              </tr>
		              </tbody> 	            
		   </table>	
		  
		   <input type="hidden" name="regCode" value="01" >
		   <input type="hidden" name="sysAccept" value="1234" >  
		   <input type="hidden" name="loginNo" value="<%=workno%>">
		   <input type="hidden" name="op_code" value="<%=opCode%>">
		   <input type="hidden" name="inputFile" value=""> 
	
	<%@ include file="/npage/include/footer_simple.jsp"%>
  <%@ include file="../../npage/common/pwd_comm.jsp" %>
</form>
 </BODY>
</HTML>