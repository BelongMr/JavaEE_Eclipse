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
    //从公共配置文件中读取配置信息，此信息被多sever共享
    CGI_PATH = SystemUtils.getConfig("CGI_PATH");
	DETAIL_PATH = SystemUtils.getConfig("DETAIL_PATH");
    //如果不以"/"格式结束,加上"/"
    if(!CGI_PATH.endsWith("/")){
		CGI_PATH=CGI_PATH+"/";
	    DETAIL_PATH=DETAIL_PATH+"/"; 
    }
  }
%>

<%
	String phoneNo = request.getParameter("phoneNo");		//手机号码
	String qryName = request.getParameter("qryName");		//二级明细名称
	String outFile = request.getParameter("outFile");		//生成的文件
%>
<html>
<head>
<title> 安保部详单查询-<%=qryName%></title>
</head>	
<body>
	<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">中国移动通信客户<%=qryName%>详单</div>
	</div>
<table cellspacing="0">
    <%
       //得到输出文件 
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