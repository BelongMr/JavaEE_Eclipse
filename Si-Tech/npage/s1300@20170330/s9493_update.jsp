<!-------------------------------------------->
<!---����:  2003-10-23                    ---->
<!---����:  sunzhe                        ---->
<!---����:  fPubSimpSel.jsp               ---->
<!---���ܣ� ��ӡȷ�Ͻ���                  ---->
<!---�޸ģ� qidp @ 2009-01-06             ---->



<!--
Setup ��ʾ��ӡ���öԻ��� 1 ��ʾ 0 ����ʾ
StartPrint ��ʼ��ӡ
PageStart �µ�ҳ
Print 
����1 x���꣨0 - 100��һ�����꣩
����2 y���꣨0 - 100��һ�����꣩
����3 �ֺţ�0 - 100��0Ϊϵͳȱʡ�ֺţ�
����4 �ִ�ϸ��0 - 10��0Ϊϵͳȱʡ��
����5 Ҫ��ӡ���ַ���

PageEnd ҳ����
StopPrint ֹͣ��ӡ
<!-------------------------------------------->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType= "text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.sitech.boss.pub.util.*" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.sitech.boss.amd.viewbean.*" %>
<%@ page import="com.sitech.boss.pub.CallRemoteResultValue" %>
<%@ page import="com.sitech.boss.s1310.viewBean.*" %>
<%@ page import="com.sitech.boss.pub.config.*" %>
<%@ page import="com.sitech.boss.pub.util.*"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
    <TITLE>��Ʊ��ӡ</TITLE>
</HEAD>

<% 
    
	ArrayList arrSession = (ArrayList)session.getAttribute("allArr");

	String[][] baseInfoSession = (String[][])arrSession.get(0);
    String work_no = (String)session.getAttribute("workNo");
	//System.out.println("111111111111111��Ϣ¼�뿪ʼ~~~~~~~~~~~~~~~~~������"+work_no);
   /* String loginName = (String)session.getAttribute("workName");
    String org_code = (String)session.getAttribute("orgCode");
	String op_code = "1210";
	  ��¼��Ʊ���������־��doucm��*/
	request.setCharacterEncoding("GBK");
	String invoice_number=request.getParameter("Invoice_number");
	String invoice_code=request.getParameter("Invoice_code");
	String Invoice_login = request.getParameter("Invoice_login"); 
    String result[][] = new String[][]{};
	
	%>
<wtc:service name="sInvoiceUPDB" routerKey="phone" routerValue="15004678912" retcode="retCode1"  outnum="1" >
	<wtc:param value="<%=invoice_number%>"/>
	<wtc:param value="<%=invoice_code%>"/>
	<wtc:param value="<%=work_no%>"/>
    <wtc:param value="<%=Invoice_login%>"/> 
	
	</wtc:service>
	<wtc:array id="sVerifyTypeArr" scope="end"/>
<%
	result = sVerifyTypeArr;
	if(result!=null&&result.length>0){
		if(result[0][0].length()>0){
			%>
			<script language="javascript">
			rdShowMessageDialog("��Ʊ��Ϣ�޸ĳɹ�!");
			window.location.href="s9493_5.jsp";
			</script>
			<%	
		}
	}
	else{
	%>
			<script language="javascript">
			rdShowMessageDialog("��Ʊ��Ϣ�޸�ʧ��!����ԭ��"+";������룺"+"<%=retCode1%>");
			window.location.href="s9493_5.jsp";
			</script>
			<%
	}
%>
	 
<SCRIPT type=text/javascript>

function doPrint()
{
  alert("hello!!");
 
  
  
  
}
function chineseNumber(num)
{
if(parseFloat(num)<=0.01) return "��Բ��"
if (isNaN(num) || num > Math.pow(10, 12)) return ""
var cn = "��Ҽ��������½��ƾ�"
var unit = new Array("ʰ��Ǫ", "�ֽ�")
var unit1= new Array("����", "")
var numArray = num.toString().split(".")
var start = new Array(numArray[0].length-1, 2)

	function toChinese(num, index)
	{
	var num = num.replace(/\d/g, function ($1)
	{
	return cn.charAt($1)+unit[index].charAt(start--%4 ? start%4 : -1)
	})
	return num
	}

for (var i=0; i<numArray.length; i++)
{
var tmp = ""
for (var j=0; j*4<numArray[i].length; j++)
{
var strIndex = numArray[i].length-(j+1)*4
var str = numArray[i].substring(strIndex, strIndex+4)
var start = i ? 2 : str.length-1
var tmp1 = toChinese(str, i)
tmp1 = tmp1.replace(/(��.)+/g, "��").replace(/��+$/, "")
tmp1 = tmp1.replace(/^Ҽʰ/, "ʰ")
tmp = (tmp1+unit1[i].charAt(j-1)) + tmp
}
numArray[i] = tmp 
}

numArray[1] = numArray[1] ? numArray[1] : ""
numArray[0] = numArray[0] ? numArray[0]+"Բ" : numArray[0], numArray[1] = numArray[1].replace(/^��+/, "")
numArray[1] = numArray[1].match(/��/) ? numArray[1] : numArray[1]+"��"
return numArray[0]+numArray[1]
}
 </SCRIPT>
<!--**************************************************************************************-->
<link href="<%=request.getContextPath()%>/css/jl.css" rel="stylesheet" type="text/css">
<FORM method=post name="spubPrint">
<!------------------------------------------------------>
    <BODY  ><!--onload="doPrint()"-->
          
    </BODY>
</FORM>


</HTML>    