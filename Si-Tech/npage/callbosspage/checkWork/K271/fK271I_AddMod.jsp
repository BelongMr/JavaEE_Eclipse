<%
  /*
   * ����: ����ԭ����  
�� * �汾: 2.0
�� * ����: 2008/11/04
�� * ����: 
�� * ��Ȩ: sitech
��*/
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%

	String org_code = (String)session.getAttribute("orgCode");
	String regionCode=org_code.substring(0,2);
	String retType = request.getParameter("retType");
	String login_no = request.getParameter("login_no");
	String remark_class_name = request.getParameter("remark_class_name");
	String note = request.getParameter("note");
	String remark_class_id = request.getParameter("remark_class_id");
	String parent_remark_class_id = request.getParameter("parent_remark_class_id");
	String valid_flag = request.getParameter("valid_flag");
	String opType = new String();
	if(retType.equals("add")){
		opType = "0";
	}else if(retType.equals("mod")){
		opType = "1";
	}else{
		opType = "2";
	}
	
%> 
 	<wtc:service name="sK271IUCfm"  routerKey="region"  routerValue="<%=regionCode%>"  outnum="2">
 		<wtc:param value="<%=opType%>"/>
		<wtc:param value="<%=login_no%>"/>
		<wtc:param value="<%=remark_class_name%>"/>
		<wtc:param value="<%=note%>"/>
		<wtc:param value="<%=remark_class_id%>"/>
		<wtc:param value="<%=parent_remark_class_id%>"/>
		<wtc:param value="<%=valid_flag%>"/>
	</wtc:service>
	<wtc:array id="result"  scope="end"/>

  var response = new AJAXPacket(); 
	response.data.add("retType","<%=retType%>"); 
	response.data.add("retCode","<%=retCode%>" );  
	response.data.add("retMsg","<%=retMsg%>" );                                                                                                                                                                                                                    
	core.ajax.receivePacket(response);	 