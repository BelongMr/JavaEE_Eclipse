<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.sitech.boss.pub.util.*" %>
<%@ page import="com.sitech.common.*" %>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0);
	String opCode = request.getParameter("opCode");
  String opName = request.getParameter("opName");
%>

<%!
private static String CGI_PATH = "";
private static String DETAIL_PATH = "";

static{
    //�ӹ��������ļ��ж�ȡ������Ϣ������Ϣ����sever����
    CGI_PATH = SystemUtils.getConfig("CGI_PATH");
	DETAIL_PATH = SystemUtils.getConfig("DETAIL_PATH");
    //�������"/"��ʽ����,����"/"
    if(!CGI_PATH.endsWith("/")){
		CGI_PATH=CGI_PATH+"/";
	    DETAIL_PATH=DETAIL_PATH+"/"; 
    }
  }
%>

<%
	String phoneNo = request.getParameter("phoneNo");		//�ֻ�����
	String qryName = request.getParameter("qryName");		//������ϸ����
	String outFile = request.getParameter("outFile");		//���ɵ��ļ�
%>
<html>
<head>
<title> �������굥��ѯ-<%=qryName%></title>
</head>	
<body>
	<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">�й��ƶ�ͨ�ſͻ�<%=qryName%>�굥</div>
	</div>
<table cellspacing="0">
    <%
       //�õ�����ļ� 
  	   String txtPath = DETAIL_PATH;
       File temp = new File(txtPath,outFile);
       
       String tline = null;
       FileReader outFrT1 = new FileReader(temp);
       BufferedReader outBrT1 = new BufferedReader(outFrT1);	
       
       do {
		     tline = outBrT1.readLine();
		     String tlinetep = "";
		     if (tline != null) {
		        tlinetep = tline.replaceAll(" ", "&nbsp;");
		     }
		     out.println("<tr><td align='left' nowrap>" + tlinetep + "</td></tr>");
		  } while(tline!=null);
       outBrT1.close();
	   outFrT1.close();
    %>    
</table>
<%@ include file="/npage/include/footer.jsp" %>
</body>
<SCRIPT type=text/javascript>
   onload=function() {
      window.print();
   }
</SCRIPT>
</html>