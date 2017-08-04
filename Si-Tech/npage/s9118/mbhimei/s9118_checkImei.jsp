<%
/********************
 * version v2.0
 * ������: si-tech
 * update by qidp @ 2009-02-05
 ********************/
%>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%@ page contentType= "text/html;charset=GBK" %>
<%
String regionCode = (String)session.getAttribute("regCode");
String imei=request.getParameter("imei");
String inputName=request.getParameter("inputName");
String sqlStr="select  a.imei_no imeiNo, b.parm_value ID ,res_code resCode    from   dbchnterm.rs_term_imei_unsell_info a,dbchnterm.RS_TERM_IMEIADD_INFO b    where a.imei_no=b.imei_no    and b.parm_name_en='ID'    and a.status='0'    and a.imei_no = ? and rownum=1";	
int callDataNum = 0;
System.out.println("test001=="+sqlStr);
%>
	<wtc:pubselect  name="sPubSelect"  routerKey="region" routerValue="<%=regionCode%>" outnum="2">
		<wtc:sql><%=sqlStr%></wtc:sql>
		<wtc:param  value="<%=imei%>"/>	
	</wtc:pubselect>
	<wtc:array  id="callData" scope="end"/>	
<%
	if(callData!=null&&callData.length>0){
			callDataNum = callData.length;	
	} 
	
	String stringArray = WtcUtil.createArray("arrMsg",callDataNum);
	
	System.out.println("test001=="+callData.length);

%> 
	<%=stringArray%>
<%
	for(int i = 0 ; i < callData.length ; i ++){
	  for(int j = 0 ; j < callData[i].length ; j ++){
			if(callData[i][j].trim().equals("") || callData[i][j] == null){
			   callData[i][j] = "";
			}
%>
			arrMsg[<%=i%>][<%=j%>] = "<%=callData[i][j].trim()%>";
<%
	  }
	}
%>  
var response = new AJAXPacket();

response.guid = '<%= request.getParameter("guid") %>';
response.data.add("verifyType","checkImei");
response.data.add("inputName",'<%=inputName%>');
response.data.add("errorCode","0");
response.data.add("errorMsg","success");
response.data.add("backArrMsg",arrMsg );

core.ajax.receivePacket(response);
