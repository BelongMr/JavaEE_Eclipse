<%
/********************
 version v2.0
开发商: si-tech
作者: dujl
********************/
%>
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>

<%	
	
	String work_no =(String)session.getAttribute("workNo");
	String work_name =(String)session.getAttribute("workName");
	String orgCode =(String)session.getAttribute("orgCode");
	String regionCode = orgCode.substring(0,2);
	String ip_Addr =(String)session.getAttribute("ip_Addr");
	String pass = (String)session.getAttribute("password");
	String op_code=request.getParameter("opcode");
	String opName="使用部门配置";
	
	String paraAray[] = new String[9];
				
	paraAray[0] = work_no;
	paraAray[1] = request.getParameter("opType");

	if(paraAray[1].equals("a")){
		paraAray[2] = request.getParameter("typeCode");
		paraAray[3] = request.getParameter("unitCode");
		paraAray[4] = request.getParameter("adepartmentCode");
		paraAray[5] = request.getParameter("departmentName");
	
	}else if(paraAray[1].equals("d")){
		paraAray[2] = request.getParameter("stypeCode");
		paraAray[3] = request.getParameter("sunitCode");
		paraAray[4] = request.getParameter("sdepartmentCode");
		paraAray[5] = request.getParameter("departmentName");
	
	}
		
%>	

      	<wtc:service name="s4243Cfm" routerKey="regionCode" routerValue="<%=regionCode%>"  retcode="errCode" retmsg="errMsg"  outnum="2" >
			   <wtc:params value="<%=paraAray%>"/>
		</wtc:service>
			<wtc:array id="result1" scope="end" />
				<%

	      if(errCode.equals("0")||errCode.equals("000000")){
          	System.out.println("调用服务s4243Cfm in f4243_1.jsp 成功@@@@@@@@@@@@@@@@@@@@@@@@@@");
         %> 
          <script language="JavaScript">
							rdShowMessageDialog("操作成功!");
							window.location="f4243_1.jsp?opCode=<%=op_code%>";
						</script>
         	<%
 	        		        	
 	     	}else{
			 			System.out.println("调用服务s4243Cfm in f4243Cfm.jsp 失败@@@@@@@@@@@@@@@@@@@@@@@@@@");
			 			System.out.println(errCode+"   errCode    "+errMsg+"    errMsg");
						%>   
						<script language="JavaScript">
							rdShowMessageDialog("操作失败!<%=errMsg%>");
							window.location="f4243_1.jsp?opCode=<%=op_code%>";
						</script>
						<%	
 			}
	%>

