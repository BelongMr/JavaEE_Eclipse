<%
    /*************************************
    * ��  ��: m282
    * ��  ��: version v1.0
    * ������: si-tech
    * ������: gaopeng @ 2015/3/27 14:31:11
    **************************************/
%>
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%
		System.out.println("gaopengSeeLog===m282====");
		
		String phoneNo = WtcUtil.repNull(request.getParameter("phoneNo"));
		String workNo = (String)session.getAttribute("workNo");
		String password = (String) session.getAttribute("password");
		String opCode = request.getParameter("opCode");
		String groupId = (String)session.getAttribute("groupId");
		String regCode = (String)session.getAttribute("regCode");
		
		String giftNo = request.getParameter("giftNo");
		String dhNum = request.getParameter("dhNum");
		String giftJf = request.getParameter("giftJf");
		String giftType = request.getParameter("giftType");
		
		String printAccept = request.getParameter("printAccept");
		
		String zddm = "0";
		String opNote = "���ţ�"+workNo+"����"+opCode+"����";
		
		String retCode11 = "";
		String retMsg11 = "";
		
		
		
		try{
%>

<wtc:service name="sm285Cfm" routerKey="regionCode" routerValue="<%=regCode%>" retcode="retCode" retmsg="retMsg" outnum="2">
		<wtc:param value="<%=printAccept%>"/>
		<wtc:param value="01"/>
		<wtc:param value="<%=opCode%>"/>
		<wtc:param value="<%=workNo%>"/>
		<wtc:param value="<%=password%>"/>
		<wtc:param value="<%=phoneNo%>"/>
	  <wtc:param value=""/>
	  <wtc:param value="<%=giftNo%>"/>
	  <wtc:param value="<%=dhNum%>"/>
	  <wtc:param value="<%=giftJf%>"/>
	  <wtc:param value="<%=giftType%>"/>
	  <wtc:param value="<%=opNote%>"/>
	  <wtc:param value=""/>
	  <wtc:param value=""/>
	  <wtc:param value=""/>
	  
	  
	</wtc:service>
	
<wtc:array id="result1"  scope="end"/>

	
var infoArray = new Array();


<%
	
	retCode11 = retCode;
	retMsg11 = retMsg;
	
	

}catch(Exception e){
	e.printStackTrace();
	retCode11 = "444444";
	retMsg11 = "����δ����������������ϵ����Ա��";
}
%>
var response = new AJAXPacket();
response.data.add("retCode","<%=retCode11%>");
response.data.add("retMsg","<%=retMsg11%>");
core.ajax.receivePacket(response);