<%
/********************
 -->>���������ˡ�ʱ�䡢ģ��Ĺ���
 -------------------------����-----------�ξ�ΰ(hejwa) 2015-4-22 16:25:30-------------------
 
 -------------------------��̨��Ա�����ĸ�--------------------------------------------
********************/
%>

<%@ page contentType="text/html;charset=GB2312"%>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
	var retArray = new Array();//���巵������
<%

	String opCode         = WtcUtil.repNull(request.getParameter("opCode"));
	String cust_M_workNO  = WtcUtil.repNull(request.getParameter("cust_M_workNO"));
	
  String workNo     = (String)session.getAttribute("workNo");
  String regionCode = (String)session.getAttribute("regCode");
 	
 	String sql_str = " select count(1) from dgrploginmsg t where t.login_no = :workNo and t.active_flag = 'Y' ";
 	String param = "workNo="+cust_M_workNO;
 	
	String sql_result = "0";
	String login_M_name = "";
	String retCode = "";
	String retMsg  = "";
	
	String workNo_orgCode_flag = "0";
	
try{
%>
   <wtc:service name="TlsPubSelCrm" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=sql_str%>" />
		<wtc:param value="<%=param%>" />	
	</wtc:service>
	<wtc:array id="result_t" scope="end"   />
<%
	 
	if(result_t.length>0){
		sql_result = result_t[0][0];
	}
	
	if(!"0".equals(sql_result)){
		String sql_str1 = "select��a.login_name from dloginmsg a where a.login_no=:workNo ";		
%>
   <wtc:service name="TlsPubSelCrm" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=sql_str1%>" />
		<wtc:param value="<%=param%>" />	
	</wtc:service>
	<wtc:array id="result_t1" scope="end"   />
<%		

		if(result_t1.length>0){
			login_M_name = result_t1[0][0];
		}
	}
	
	
		String sql_orgCode        = "select substr(org_code,1,2)   from dloginmsg   WHERE login_no = :vLogin_No ";
		String sql_orgCode_param1 = "vLogin_No="+cust_M_workNO;
		String sql_orgCode_param2 = "vLogin_No="+workNo;
	
%>
   <wtc:service name="TlsPubSelCrm" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=sql_orgCode%>" />
		<wtc:param value="<%=sql_orgCode_param1%>" />	
	</wtc:service>
	<wtc:array id="result_orgCode1" scope="end"   />

   <wtc:service name="TlsPubSelCrm" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=sql_orgCode%>" />
		<wtc:param value="<%=sql_orgCode_param2%>" />	
	</wtc:service>
	<wtc:array id="result_orgCode2" scope="end"   />
				
<%	

	String workNo_orgCode1 = "";
	String workNo_orgCode2 = "";
	
	if(result_orgCode1.length>0){
		workNo_orgCode1 = result_orgCode1[0][0];
	}
	if(result_orgCode2.length>0){
		workNo_orgCode2 = result_orgCode2[0][0];
	}
		
	System.out.println("----------hejwa-------workNo_orgCode1-------------->"+workNo_orgCode1);
	System.out.println("----------hejwa-------workNo_orgCode2-------------->"+workNo_orgCode2);
	
	System.out.println("----------hejwa-------login_M_name-------------->"+login_M_name);
	
	if(!workNo_orgCode1.equals(workNo_orgCode2)){
		workNo_orgCode_flag = "1";
	} 
	
}catch(Exception ex){
	retCode = "404040";
	retMsg = "��ѯʧ�ܣ�����ϵ����Ա";
}

%> 	
var response = new AJAXPacket();
response.data.add("login_M_name","<%=login_M_name%>");
response.data.add("workNo_orgCode_flag","<%=workNo_orgCode_flag%>");
core.ajax.receivePacket(response);