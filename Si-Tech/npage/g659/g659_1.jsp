<%
/********************
 version v2.0
������: si-tech
*
*update:liutong@2008-8-15
*
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	
<%@ page contentType="text/html; charset=GB2312" %>
<%@ include file="/npage/include/public_title_name.jsp" %>



<%
		/**ArrayList arr = (ArrayList)session.getAttribute("allArr");
		String[][] baseInfo = (String[][])arr.get(0);
		String workno = baseInfo[0][2];
		String workname = baseInfo[0][3];
		String org_code = baseInfo[0][16];
		String belongName = baseInfo[0][16];
		String[][] password = (String[][])arr.get(4);//��ȡ�������� 
		String pass = password[0][0];
		String[][] info1 = (String[][])arr.get(1);
		String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
		String dateStr1 = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
		**/
		String opCode = "g659";
		String opName = "��ͥ�ɷ�";
		String workno = (String)session.getAttribute("workNo");
		String workname = (String)session.getAttribute("workName");
		String org_code = (String)session.getAttribute("orgCode");
		String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
		String dateStr1 = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
		
		
%>
<HTML><HEAD>

<script language="JavaScript">
<!--	
  
   function doProcess(packet)
  {
     if(document.frm.contractno.value=="")
      {
			rdShowMessageDialog("�������ʻ�����!");
			document.frm.contractno.focus();
			return false;
     }
    var retResult=packet.data.findValueByName("retResult");
	if(retResult == "false")
	  {
	rdShowMessageDialog("�ͻ�������ڼ�,���޸����룡");
      }
	var contract_new=packet.data.findValueByName("contract_out");
	//alert("�˺Žɷѵ� contract_new is "+contract_new);
	var phone_new=packet.data.findValueByName("phone_new");
	
	//document.all.contractno.value=contract_new;
	document.getElementById("phoneNo").value= phone_new;
	//rdShowMessageDialog("test contract_new is "+contract_new+" and phone_new is "+phone_new+" and retResult is "+retResult);
    if(retResult=="true")
	{
		document.getElementById("div1").style.display="";
		document.all.contractno1.value=contract_new;
		document.all.phone_input.value=document.all.contractno1.value;
	}
	
	//docheck(); 
  }
  function getpasswd(){
  	if(document.all.contractno.value.trim().len()==0){
  		rdShowMessageDialog("�ɷѺ��벻��Ϊ��!");
  		return false;
  	}
  	
  	document.all.dbBand_Account.value=document.all.contractno.value;
  	
   	var myPacket = new AJAXPacket("getKdNo_new.jsp","���ڲ�ѯ�ͻ������Ժ�......");
		myPacket.data.add("contractNo",(document.all.contractno.value).trim());
		myPacket.data.add("busyType",(document.all.busy_type.value).trim());
		myPacket.data.add("return_page","g659_1.jsp");
		core.ajax.sendPacket(myPacket);
		myPacket=null;
  }
  function getpasswd1()
  {
	  docheck(); 
  }
 function sel1()
 {
            window.location.href='s1300.jsp';
 }
 function sel2()
 {
           window.location.href='g659_1.jsp';
  }
 

 
 function sel5() {
           window.location.href='e034.jsp';
 }

 function init()
 {
    document.frm.contractno.focus();  
	document.getElementById("div1").style.display="none";
 }
 function doclear() {
 		frm.reset();
 }
-->
 </script> 
 
<title>������BOSS-��ͨ�ɷ�</title>
</head>
<BODY  onLoad="init()" >
<FORM action="" method="post" name="frm"  >
<input type="hidden" name="busy_type"  value="2">
<input type="hidden" name="op_code"  value="g659">
<input type="hidden" name="totaldate"  value="<%=dateStr1%>">
<input type="hidden" name="yearmonth"  value="<%=dateStr%>">
<input type="hidden" name="billdate"  value="<%=dateStr.substring(0,6)%>">
<input type="hidden" name="water_number"  >
<input type="hidden" name="phoneNo" id = "pno"  value="" >
    
 <%@ include file="/npage/include/header.jsp" %>   
  	
		<div class="title">
			<div id="title_zi">��ѡ��ɷѷ�ʽ</div>
		</div>
              <table cellspacing="0">
                <tbody> 
                <tr> 
                  <td class="blue" width="15%">�ɷѷ�ʽ</td>
                  <td colspan="3"> 
                    <!--
					<input name="busyType1" type="radio" onClick="sel1()" value="1"  >
                    ��ͨ�̻� 
					-->
                    <input name="busyType1" type="radio" onClick="sel2()" value="2"  checked>
                    ��ͥ�ɷ�
                    <!--
						<input name="busyType5" type="radio" onClick="sel5()" value="5"  >
                    ������������
				    -->
					</td>
                 </tr>   
                </tbody> 
              </table>
              <table cellspacing="0" >
                <tr> 
                  <td  class="blue" width="15%">��ͥ��Ա����</td>
                  <td> 
                    <input type="text" name="contractno" size="20" maxlength="25" style="ime-mode:disabled"   onKeyDown="if(event.keyCode==13) getpasswd();" index="5" >
					<input type="button" name="query"  class="b_foot" value="��ѯ" onclick="getpasswd()"  >
                  </td>
                  <td nowrap> </td>
                  <td> 
                   </td>
 				</tr>

				<tr id="div1"> 
                  <td  class="blue" width="15%">��ͥ�ʺ�</td>
                  <td> 
                    <input type="text" name="contractno1" size="20" maxlength="25" style="ime-mode:disabled"   onKeyDown="if(event.keyCode==13)  " index="5" readonly>
					<input type="button" name="query1"  class="b_foot" value="��һ��" onclick="getpasswd1()"  >
                  </td>
                  <td nowrap> </td>
                  <td> 
                  </td>
 				</tr>
              </table>
         <input type="hidden" name="phone_input">
         <input type="hidden" name="dbBand_Account">
        <TABLE cellSpacing="0">
          <TR > 
            <TD noWrap colspan="6" id="footer"> 
              <div align="center"> 
                
                &nbsp;
                <input type="button" name="return1" class="b_foot" value="���" onclick="doclear()" >
                &nbsp;
				<!--
				<input type="button" name="reprint"  class="b_foot" value="�ش�Ʊ" onclick="doreprint()"  >
                &nbsp;
                <input type="button" name="nopay" class="b_foot_long" value="�ϱʽɷѳ���" onclick="donopay()"  >
                &nbsp;
				-->
               <input type="button" name="return2" class="b_foot" value="�ر�" onClick="parent.removeTab('<%=opCode%>');"  >
              </div>
            </TD>
          </TR>
        </TABLE>
      
	<%@ include file="/npage/include/footer_simple.jsp"%>
  <%@ include file="../../npage/common/pwd_comm.jsp" %>
  
</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!--
var h=480;
var w=650;
var t=screen.availHeight/2-h/2;
var l=screen.availWidth/2-w/2;
var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";


 

 
 function docheck()
 {
	document.frm.action="s1300Cfm.jsp";
    document.frm.submit();
}

//-->
</SCRIPT>

</BODY>
</HTML>