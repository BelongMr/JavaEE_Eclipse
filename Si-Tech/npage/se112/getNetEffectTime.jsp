<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/xservice.tld" prefix="s" %>
<%@ include file="/npage/se112/public_title_ajax.jsp" %>
<%@ page import="com.sitech.crmpd.core.bean.MapBean" %>
<%
	String H11_effDateStr = (String)request.getParameter("H11_effDateStr");
	String feeScores = (String)request.getParameter("feeScores");
	String actType = (String)request.getParameter("actType");
	
	System.out.println("||||||||||||||||||||||||========================================start");
	System.out.println("||||||||||||||||||||||||========================================"+H11_effDateStr);
	System.out.println("||||||||||||||||||||||||========================================"+feeScores);
	System.out.println("||||||||||||||||||||||||========================================"+actType);
 %>
	<s:service name="WsGetNetBindingEffectTime">
		<s:param name="ROOT">
			<s:param name="H11_effDateStr" type="string" value="<%=H11_effDateStr%>" />
			<s:param name="feeScores" type="string" value="<%=feeScores%>" />
			<s:param name="actType" type="string" value="<%=actType%>" />
		</s:param>
	</s:service>
<%	
	String RETURN_CODE = result.getString("RETURN_CODE");	
	String RETURN_MSG = result.getString("RETURN_MSG");
	System.out.println("||||||||||||||||||||||||========================================"+RETURN_CODE+"~~~"+RETURN_MSG);
	String effDateStr ="";
	String expDateStr ="";
	String split="";
	if("000000".equals(RETURN_CODE)){
        effDateStr = result.getString("effDateStr");
        expDateStr = result.getString("expDateStr");
		System.out.println("effDateStr:"+effDateStr+"------expDateStr:"+expDateStr);
	}
%>			
	var response = new AJAXPacket();
	response.data.add("RETURN_CODE","<%=RETURN_CODE%>");
	response.data.add("RETURN_MSG","<%=RETURN_MSG%>");
	response.data.add("effDateStr","<%=effDateStr%>");
	response.data.add("expDateStr","<%=expDateStr%>");
	core.ajax.receivePacket(response);