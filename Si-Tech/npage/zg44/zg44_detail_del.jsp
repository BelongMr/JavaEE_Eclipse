<%
/********************
 * version v2.0
 * 开发商: si-tech
 * update by zhangshuaia @ 2009-08-05
 ********************/
%>
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>

<%	
    String org_Code = (String)session.getAttribute("orgCode");
    String regionCode = org_Code.substring(0,2);				   
	
	String opCode = "zg44";
	String opName = "虚拟集团关系配置";
	
	       
	String loginName = (String)session.getAttribute("workName");   
	String pass = (String)session.getAttribute("password");
	
	String unit_id= request.getParameter("unit_id");
    String phone_no= request.getParameter("phone_no");
	String contract_no= request.getParameter("contract_no");
 
	String work_no = (String)session.getAttribute("workNo");
	 
	 
	 
	String paraAray[] = new String[6]; 
	paraAray[0] = unit_id;
	paraAray[1]= "";
	paraAray[2] = work_no;
	paraAray[3] = regionCode;
	paraAray[4] = phone_no;
	paraAray[5] = contract_no;
  
 
%>
<wtc:service name="sgrpdetaildel" routerKey="region" routerValue="<%=regionCode%>" retcode="sCode" retmsg="sMsg" outnum="2" >
    <wtc:param value="<%=paraAray[0]%>"/>
    <wtc:param value="<%=paraAray[1]%>"/> 
	<wtc:param value="<%=paraAray[2]%>"/> 
	<wtc:param value="<%=paraAray[3]%>"/> 
	<wtc:param value="<%=paraAray[4]%>"/>
	<wtc:param value="<%=paraAray[5]%>"/>
</wtc:service>
<wtc:array id="sArr" scope="end"/>
<%
	String retCode= sCode;
	String retMsg = sMsg;
   

	String errMsg = sMsg;
	if ( sCode.equals("000000"))
	{
 
%>
<script language="JavaScript">
	rdShowMessageDialog("办理成功！");
	window.location="zg44_1.jsp?opCode=zg27&opName=增值税红字发票开具申请";
	</script>
<%
	}else{
%>   
<script language="JavaScript">
	rdShowMessageDialog("办理失败: <%=retMsg%>,<%=sCode%>",0);
	window.location="zg44_1.jsp?opCode=zg27&opName=增值税红字发票开具申请";
	</script>
<%}
%>

