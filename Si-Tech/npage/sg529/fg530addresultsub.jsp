<%@ page contentType= "text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%
		String workNo = (String)session.getAttribute("workNo");
		String regionCode= (String)session.getAttribute("regCode");
		String searchOpCode = request.getParameter("searchOpCode");
		String password = (String)session.getAttribute("password");
		String phonenos = request.getParameter("phonenos");
		String peisongjieguo = request.getParameter("peisongjieguo");
		String shibaireson = request.getParameter("shibaireson");

		String opnote =workNo+"����g530���ͽ����������";
%>
		<wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="regioncode" 
			routerValue="<%=regionCode%>"  id="loginAccept" />

		<wtc:service name="sg530Cfm" routerKey="region" routerValue="<%=regionCode%>"
					 retcode="retCode" retmsg="retMsg" outnum="1">
        <wtc:param value="<%=loginAccept%>"/>
        <wtc:param value="01"/>
        <wtc:param value="g530"/>
        	<wtc:param value="<%=workNo%>"/>
        	<wtc:param value="<%=password%>"/>
         	<wtc:param value="<%=phonenos%>"/>
        	<wtc:param value=""/>
        	<wtc:param value="<%=opnote%>"/>
        	<wtc:param value=""/>
        	<wtc:param value=""/>
        		<wtc:param value=""/>
        	<wtc:param value=""/>
        	<wtc:param value=""/>
        	<wtc:param value=""/>
        	<wtc:param value="<%=peisongjieguo%>"/>
        	<wtc:param value="<%=shibaireson%>"/>
        	<wtc:param value="2"/>
		</wtc:service>
		<wtc:array id="ret" scope="end"/>


	var response = new AJAXPacket();

	response.data.add("retcode","<%= retCode %>");
	response.data.add("retmsg","<%= retMsg %>");
	core.ajax.receivePacket(response);