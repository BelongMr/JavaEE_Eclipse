 <%request.setCharacterEncoding("GB2312");%>
<%@page contentType="text/html;charset=Gb2312"%>
<%@ include file="/npage/include/public_title_ajax.jsp" %>

<%!
    public static String createArray(String aimArrayName, int xDimension) {
        String stringArray = "var " + aimArrayName + " = new Array(";
        int flag = 1;
        for (int i = 0; i < xDimension; i++) {
            if (flag == 1) {
                stringArray = stringArray + "new Array()";
                flag = 0;
                continue;
            }
            if (flag == 0) {
                stringArray = stringArray + ",new Array()";
            }
        }

        stringArray = stringArray + ");";
        return stringArray;
    }
%>
<%
    String loginAccept = request.getParameter("loginAccept");
    String iChnSource = request.getParameter("iChnSource");
		String opCode  = request.getParameter("opCode");
		String workNo  = request.getParameter("workNo");
		String password = (String) session.getAttribute("password");
		String phoneNo = request.getParameter("phoneNo");
		phoneNo= phoneNo.trim();
		String iUserPwd = request.getParameter("iUserPwd ");

		String [] inputParam = new String [7] ;
		inputParam[0] = loginAccept;
		inputParam[1] = iChnSource;
		inputParam[2] = opCode;
		inputParam[3] = workNo;
		inputParam[4] = password;
		inputParam[5] = phoneNo;
		inputParam[6] = iUserPwd;	
%>
		<wtc:service name="sB540Init" routerKey="phone" routerValue="<%=phoneNo%>" outnum="38" >
		<wtc:param value="<%=inputParam[0]%>"/>
		<wtc:param value="<%=inputParam[1]%>"/>
		<wtc:param value="<%=inputParam[2]%>"/>
		<wtc:param value="<%=inputParam[3]%>"/>
		<wtc:param value="<%=inputParam[4]%>"/>
		<wtc:param value="<%=inputParam[5]%>"/>
		<wtc:param value="<%=inputParam[6]%>"/>
		</wtc:service>
		<wtc:array id="backUserInfo" scope="end"/>
<%

System.out.println("-------hejwa----------sB540Init----------retCode----->"+retCode);
System.out.println("-------hejwa----------sB540Init----------retMsg------>"+retMsg);


	if( !(retCode.equals("000000"))){
%>
			var response = new AJAXPacket();
			response.data.add("backString","");
			response.data.add("flag","9");
			response.data.add("errCode","<%=retCode%>");
			response.data.add("errMsg","<%=retMsg%>");
			core.ajax.receivePacket(response);
<%
	}else{
		String strArray = createArray("backUserInfo",backUserInfo.length);
%>
<%=strArray%>
<%

	if(backUserInfo.length>0){
		for(int j=0;j<backUserInfo[0].length;j++){
			System.out.println(backUserInfo[0][j]);
%>
			backUserInfo[0][<%=j%>] = "<%=backUserInfo[0][j]%>";
<%
		}
		
	}
%>
	var response = new AJAXPacket();
	response.data.add("backString",backUserInfo);
	response.data.add("errCode","<%=retCode%>");
	response.data.add("errMsg","<%=retMsg%>");
	response.data.add("phoneNo","<%=phoneNo%>");
	response.data.add("flag","0");
	core.ajax.receivePacket(response);
<%}%>
