<%@ page contentType= "text/html;charset=gb2312" %>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%  
	/*midify by guozw 20091114 ������ѯ�����滻*/
	 String myParams="";
	 String org_code = (String)session.getAttribute("orgCode");
	 String regionCode = org_code.substring(0,2);

    String retType = WtcUtil.repNull(request.getParameter("retType"));
    String contactId = WtcUtil.repNull(request.getParameter("contactId"));
    String called = WtcUtil.repNull(request.getParameter("called"));
    String caller = WtcUtil.repNull(request.getParameter("caller"));
    String transagent = WtcUtil.repNull(request.getParameter("transagent"));
		String loginNo = (String)session.getAttribute("workNo");  //ȡlogin_no
	  String loginName = (String)session.getAttribute("workName"); //ȡlogin_name
		String transType = WtcUtil.repNull(request.getParameter("transType")); //transType
		String op_code = WtcUtil.repNull(request.getParameter("op_code")); //op_code
		String is_success = WtcUtil.repNull(request.getParameter("is_success")); //is_success
    String oper_type = WtcUtil.repNull(request.getParameter("oper_type")); //is_success
    String skillName = WtcUtil.repNull(request.getParameter("skillName"));
    String transfer_kf_login_no = (String)session.getAttribute("kfWorkNo");  //ȡ�ͷ�login_no	    
    String accept_kf_login_no="";
    
		String temp = "select kf_login_no from dloginmsgrelation where boss_login_no=:transagent";
		myParams = "transagent="+transagent ;

   %>
	 <wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>"  outnum="1">
	 		<wtc:param value="<%=temp%>"/>
	 		<wtc:param value="<%=myParams%>"/>
	 </wtc:service>
	 <wtc:array id="tempList"  scope="end"/>
	 <%		
    if(tempList.length>0){
     accept_kf_login_no=tempList[0][0];
    } 
%>
	<wtc:service name="sRK029Insert" outnum="2">
			<wtc:param value="<%=contactId%>"/>
			<wtc:param value="<%=contactId%>"/>
			<wtc:param value="<%=caller%>"/>
			<wtc:param value="<%=loginNo%>"/>
			<wtc:param value="<%=transagent%>"/>
			<wtc:param value="<%=oper_type%>"/>
			<wtc:param value="<%=transType%>"/>
			<wtc:param value="<%=skillName%>"/>
			<wtc:param value="<%=is_success%>"/>			
			<wtc:param value="<%=op_code%>"/>	
			<wtc:param value="<%=transfer_kf_login_no%>"/>
			<wtc:param value="<%=accept_kf_login_no%>"/>					
	</wtc:service>
	<wtc:array id="rows"  scope="end"/>
	<%
	  if(rows[0][0].equals("000001")){
	     retCode = "000001";
	     retMsg = "�����ϵʧ��";
	  }
	%>


	var response = new AJAXPacket();
	response.data.add("retType","<%=retType%>");
	response.data.add("retCode","<%=retCode%>");
	response.data.add("retMsg","<%=retMsg%>");
	core.ajax.receivePacket(response);

