<%
  /*
   * ����: �ƻ����ʼ�
�� * �汾: 1.0.0
�� * ����: 2008/11/05
�� * ����: mixh
�� * ��Ȩ: sitech
   * update:
�� */
%>
<%@page contentType="text/html;charset=GBK"%>
<%
	String opCode = request.getParameter("opCode");
	String opName = request.getParameter("opName");
	if(opCode == null || opCode ==""){
			opCode = "K217";
	}
	if(opName == null || opName ==""){
			opName = "����ˮ�����ʼ�";
	}	
%>

<%
	/****************����ʼ������ˮ������������ˮ������ͨ����ˮ��ʼ******************/
	String object_id  = request.getParameter("object_id");
	String content_id = request.getParameter("content_id");
	String serialnum  = request.getParameter("serialnum");
	String isOutPlanflag  = request.getParameter("isOutPlanflag");
	String staffno = (String)request.getParameter("staffno");
	String plan_id = request.getParameter("plan_id");
	String group_flag = request.getParameter("group_flag");
	String tabId   = request.getParameter("tabId");//tabҳ���idֵ
	String qc_objectvalue = request.getParameter("qc_objectvalue");
	String qc_contentvalue = request.getParameter("qc_contentvalue");
	String qcCount        = request.getParameter("qcCount");
	String tempQcCount    = request.getParameter("tempQcCount");
	/****************����ʼ������ˮ������������ˮ������ͨ����ˮ����******************/
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title><%=opName%></title>
</head>

<frameset cols="170,*" frameborder="no" border="0" framespacing="0">
<frame src="<%=request.getContextPath()%>/npage/callbosspage/checkWork/K217/K217_qc_item_tree.jsp?object_id=<%=object_id%>&content_id=<%=content_id%>" name="leftFrame" scrolling="auto" id="leftFrame" style="border:solid #DFE8F6 3px;cursor:move"/>
<frame src="<%=request.getContextPath()%>/npage/callbosspage/checkWork/K217/K217_out_plan_qc_form.jsp?serialnum=<%=serialnum%>&opCode=<%=opCode%>&opName=<%=opName%>&object_id=<%=object_id%>&content_id=<%=content_id%>&isOutPlanflag=<%=isOutPlanflag%>&staffno=<%=staffno%>&plan_id=<%=plan_id%>&group_flag=<%=group_flag%>&tabId=<%=tabId%>&qc_objectvalue=<%=qc_objectvalue%>&qc_contentvalue=<%=qc_contentvalue%>" name="mainFrame" id="mainFrame" style="border:solid #DFE8F6 3px;cursor:move"/>
</frameset>

<noframes>
<body>
</body>
</noframes>
</html>