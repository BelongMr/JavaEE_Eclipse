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
		//String opCode = "ϵͳ�ں�";
		//String opName = "���д���ͳ�Ʊ�����ѯ";
		String opCode="zg16";
		String opName="�ܶ��������ƶ����ѱ���";
		String workno = (String)session.getAttribute("workNo");
		String workname = (String)session.getAttribute("workName");
		String org_code = (String)session.getAttribute("orgCode");
		String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
		String dateStr1 = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
		activePhone=(String)request.getParameter("activePhone");
		String opCode1 = request.getParameter("opCode");
		
%>
<HTML><HEAD>

<script language="JavaScript">
<!--	
  
 
 
  
 function sel1()
 {
            window.location.href='../rpt/f1768.jsp?activePhone='+"<%=activePhone%>";
 }
 function sel2()
 {
            window.location.href='../rpt/f4952.jsp?activePhone='+"<%=activePhone%>";
 }
 
 
 function doclear() {
 		frm.reset();
 }
-->
 </script> 
 
<title>������BOSS-ǰ̨�ں�</title>
</head>
<BODY  >
<FORM action="" method="post" name="frm"  >
<input type="hidden" name="busy_type"  value="2">
<input type="hidden" name="op_code"  value="e453">
<input type="hidden" name="totaldate"  value="<%=dateStr1%>">
<input type="hidden" name="yearmonth"  value="<%=dateStr%>">
<input type="hidden" name="billdate"  value="<%=dateStr.substring(0,6)%>">
<input type="hidden" name="water_number"  >
<input type="hidden" name="phoneNo" id = "pno"  value="" >
    
 <%@ include file="/npage/include/header.jsp" %>   
  	
		<div class="title">
			<div id="title_zi">��ѡ���ѯ����</div>
		</div>
              <table cellspacing="0">
                <tbody> 
                <tr> 
                  <td class="blue" width="15%">��ѯ����</td>
                  <td colspan="3"> 
                   
                    <input name="busyType1" id="sl1" type="radio" value="1" checked >
                    �ܶ��������ƶ�����ȫʡ���ܱ� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input name="busyType1" id="sl2" type="radio" value="2"  >
                    �ܶ��������ƶ�����ͳ�Ʊ�(������)<br>
                   
                  </td>
                 </tr>
                </tbody> 
              </table>
			  <TABLE cellSpacing="0">
          <TR > 
            <TD noWrap colspan="6" id="footer"> 
              <div align="center"> 
                <input type="button" name="query"  class="b_foot" value="ȷ��" onclick="doCfm()"  >
                &nbsp;
                 <input type="button" id="closeBtn"  name="closeBtn"  class="b_foot" value="�ر�" onClick="removeCurrentTab();" />
              </div>
            </TD>
          </TR>
        </TABLE>
             
 
	<%@ include file="/npage/include/footer_simple.jsp"%>
  <%@ include file="../../npage/common/pwd_comm.jsp" %>
  
</FORM>
<SCRIPT LANGUAGE="JavaScript">
function doCfm()
{
	var radios = document.getElementsByName("busyType1");
    var radioButtonVal = "";
    
    for(var i=0;i<radios.length;i++)
	{
		if(radios[i].checked)
		{
			radioButtonVal = radios[i].value;
			//alert("test radioButtonVal is "+radioButtonVal);
		}
     }

	 var opCode =radioButtonVal;
	 /*var checkPopedomPacket = new AJAXPacket("/npage/public/pubCheckPopedom.jsp", "���Ժ�......");
		checkPopedomPacket.data.add("workNo", "<%=workno%>");
		checkPopedomPacket.data.add("opCode", opCode);
		core.ajax.sendPacket(checkPopedomPacket, doCheckPopedom);
		checkPopedomPacket = null;*/

	 if(radioButtonVal=="1")
	 {
			frm.action="zg16_2.jsp";//�ܶ��������ƶ�����ȫʡ���ܱ�
     }
	 if(radioButtonVal=="2")
	 {
			frm.action="zg16_3.jsp";//�ܶ��������ƶ�����ͳ�Ʊ�(������)
     }
     
	 frm.submit();
}
<!--
var h=480;
var w=650;
var t=screen.availHeight/2-h/2;
var l=screen.availWidth/2-w/2;
var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";

 

  function doCheckPopedom (packet) {
		var retCode = packet.data.findValueByName("retCode");
		var popedomNo = packet.data.findValueByName("popedomNo");
		
		if (retCode == "000000" && parseInt(popedomNo) > 0) {
			//alert("test ok");
			document.frm.submit();
		} else {
			alert("���޴˹��ܵ�Ȩ�ޣ�");
			//window.close(); �ο�1302������
			//window.location.href="query/s1556_new.jsp?opCode="+"<%=opCode%>"+"&opName="+"<%=opName%>";
			removeCurrentTab();
			return false;
		}
	}

 
 function docheck()
 {
	document.frm.action="s1300Cfm.jsp";
    document.frm.submit();
}

//-->
</SCRIPT>

</BODY>
</HTML>