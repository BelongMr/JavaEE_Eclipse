<%
  /*
   * 功能: 
   * 版本: 1.0
   * 日期: liangyl 2016/12/08 省内魔百和平台点播功能和支付功能开发需求
   * 作者: liangyl
   * 版权: si-tech
  */
%>

<%@ page contentType= "text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%@ include file="/npage/bill/getMaxAccept.jsp" %>
<%
		String regionCode = (String)session.getAttribute("regCode");

		String iLoginAccept = request.getParameter("iLoginAccept");
		String iChnSource = request.getParameter("iChnSource");
		String iOpCode =  "m441";
		String iWorkNo = request.getParameter("iWorkNo");
		String iWorkPwd =  request.getParameter("iWorkPwd");
		String iPhoneNo =  request.getParameter("iPhoneNo");
		String iUserPwd =  request.getParameter("iUserPwd");
		
		String sm441_imei =  request.getParameter("sm441_imei");
		String sm441_valueadded =  request.getParameter("sm441_valueadded");
		
		String  inputParsm [] = new String[9];
		inputParsm[0] = iLoginAccept;
		inputParsm[1] = iChnSource;
		inputParsm[2] = iOpCode;
		inputParsm[3] = iWorkNo;
		inputParsm[4] = iWorkPwd;
		inputParsm[5] = iPhoneNo;
		inputParsm[6] = iUserPwd;
		
		inputParsm[7] = sm441_imei;
		inputParsm[8] = sm441_valueadded;
		
		String retCode11 = "";
		String retMsg11 = "";
try{		
%>
		<wtc:service name="sm441Cfm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode" retmsg="retMsg" outnum="2">
			<wtc:param value="<%=inputParsm[0]%>"/>
			<wtc:param value="<%=inputParsm[1]%>"/>
			<wtc:param value="<%=inputParsm[2]%>"/>
			<wtc:param value="<%=inputParsm[3]%>"/>
			<wtc:param value="<%=inputParsm[4]%>"/>
			<wtc:param value="<%=inputParsm[5]%>"/>
			<wtc:param value="<%=inputParsm[6]%>"/>
			<wtc:param value="<%=inputParsm[7]%>"/>
			<wtc:param value="<%=inputParsm[8]%>"/>
		</wtc:service>
		<wtc:array id="sm441Cfm_result" scope="end"/>
			
	var infoArray = new Array();
	
<%
		retCode11 = retCode;
		retMsg11 = retMsg;
		
		}catch(Exception e){
			e.printStackTrace();
			retCode11 = "444444";
			retMsg11 = "服务未启动或不正常，请联系管理员！";
			%>
				var infoArray = new Array();
			<%
		}
%>
var response = new AJAXPacket();
response.data.add("code","<%=retCode11 %>");
response.data.add("msg","<%=retMsg11 %>");
core.ajax.receivePacket(response);                                                                                                                                                                                                                                                                                                                                                                         