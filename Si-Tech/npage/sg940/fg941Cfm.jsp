<%@ page contentType= "text/html;charset=gb2312" %>
<%@ include file="../../npage/bill/getMaxAccept.jsp" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
  String workNo = (String)session.getAttribute("workNo");
  String regionCode= (String)session.getAttribute("regCode");
  String password = (String)session.getAttribute("password");
  String phoneNo = request.getParameter("phoneNo");
  String opCode = request.getParameter("opCode");
  String opName = request.getParameter("opName");
  String beizhu=phoneNo+"�������п��������Լ";
  String loginAccept = request.getParameter("loginAccept");

  String fuphoneno = request.getParameter("fuphoneno");
  String RechAmount = WtcUtil.repNull((String)request.getParameter("RechAmount"));
  String RechThreshold = WtcUtil.repNull((String)request.getParameter("RechThreshold"));

	String  inputParsm [] = new String[10];
	inputParsm[0] = "";
	inputParsm[1] = "01";
	inputParsm[2] = opCode;
	inputParsm[3] = workNo;
	inputParsm[4] = password;
	inputParsm[5] = phoneNo;
	inputParsm[6] = "";
	inputParsm[7] = beizhu;
	inputParsm[8] = "01";
	inputParsm[9] = phoneNo;

	
%>
	<wtc:service name="sG941Cfm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode" retmsg="retMsg" outnum="1">
			<wtc:param value="<%=inputParsm[0]%>"/>
			<wtc:param value="<%=inputParsm[1]%>"/>
			<wtc:param value="<%=inputParsm[2]%>"/>
			<wtc:param value="<%=inputParsm[3]%>"/>
			<wtc:param value="<%=inputParsm[4]%>"/>
			<wtc:param value="<%=inputParsm[5]%>"/>
			<wtc:param value="<%=inputParsm[6]%>"/>
			<wtc:param value="<%=inputParsm[7]%>"/>
			<wtc:param value="<%=inputParsm[8]%>"/>
			<wtc:param value="<%=inputParsm[9]%>"/>
	</wtc:service>
	<wtc:array id="ret" scope="end"/>
<%
	if("000000".equals(retCode)){
		System.out.println(" ======== sG969Cfm ���óɹ� ========");
%>	
    <script language="javascript">
 	      rdShowMessageDialog("�����������Լ�ɹ���",2);
 	      window.location="fg941.jsp?activePhone=<%=phoneNo%>&opCode=<%=opCode%>&opName=<%=opName%>";
 	  </script>
<%}else{
	  System.out.println(" ======== sG969Cfm ����ʧ�� ========");
%>
  	<script language="javascript">
 	    rdShowMessageDialog("������룺<%=retCode%> ��������Ϣ��<%=retMsg%>",0);
 		  window.location="fg941.jsp?activePhone=<%=phoneNo%>&opCode=<%=opCode%>&opName=<%=opName%>";
 	  </script>
<%
	}
%>