<%
    /********************
     version v2.0
     开发商: si-tech
     *
     *update:zhanghonga@2008-08-27 页面改造,修改样式
     *
     ********************/
%>
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_ajax.jsp"%>
<%!
		public static String createArray(String aimArrayName, int xDimension)
    {
        String stringArray = "var " + aimArrayName + " = new Array(";
        int flag = 1;
        for(int i = 0; i < xDimension; i++)
        {
            if(flag == 1)
            {
                stringArray = stringArray + "new Array()";
                flag = 0;
                continue;
            }
            if(flag == 0)
            {
                stringArray = stringArray + ",new Array()";
            }
        }

        stringArray = stringArray + ");";
        return stringArray;
    }
%>
<%

    String[] inPubParams = new String[31];/*diling update*/
    inPubParams[0] = request.getParameter("loginAccept");
    inPubParams[1] = request.getParameter("iChnSource");
    inPubParams[2] = request.getParameter("opCode");
    inPubParams[3] = request.getParameter("workNo");
    inPubParams[4] = (String) session.getAttribute("password");
    inPubParams[5] = request.getParameter("idNo");
    inPubParams[6] = request.getParameter("iUserPwd");
    inPubParams[7] = request.getParameter("orgCode");
    inPubParams[8] = request.getParameter("handFee");
    inPubParams[9] = request.getParameter("factPay");
    inPubParams[10] = request.getParameter("sysRemark");
    inPubParams[11] = request.getParameter("remark");
    inPubParams[12] = request.getParameter("ipAdd");
    inPubParams[13] = request.getParameter("lx");
    inPubParams[14] = request.getParameter("asCustName");
    inPubParams[15] = request.getParameter("asCustPhone");
    inPubParams[16] = request.getParameter("asIdType");
    inPubParams[17] = request.getParameter("asIdIccid");
    inPubParams[18] = request.getParameter("asIdAddress");
    inPubParams[19] = request.getParameter("asContractAddress");
    inPubParams[20] = request.getParameter("asNotes");
    inPubParams[21] = request.getParameter("vConID");
    inPubParams[22] = request.getParameter("backPrepay");
    if("1213".equals(inPubParams[2])){
        inPubParams[23] = request.getParameter("lackPhoneNo");
    }else{
    	inPubParams[23] = request.getParameter("vPhoneNo");
    }
    inPubParams[24] = request.getParameter("preNo");
    inPubParams[25] = request.getParameter("preNoType");
    //String[] backInfo = impl.callService("s1213Cfm", inPubParams, "3", "phoneno", inPubParams[5]);
	
	inPubParams[26] = WtcUtil.repStr(request.getParameter("promptPhoneNo"),"");/*diling add for 欠费提醒号码@2012/9/6*/
	
	inPubParams[27] = request.getParameter("issqxh");
	inPubParams[28] = request.getParameter("zfsjhms");
	inPubParams[29] = request.getParameter("khlxdhs");
	
	for ( int i=0;i< inPubParams.length ; i++)
	{
		System.out.println("~~~~"+i+"~~~~"+inPubParams[i]+"~~~~~~hejwa~~~~~~~`");
	}
%>
		<wtc:service name="s1213Cfm" routerKey="phone" routerValue="<%=inPubParams[5]%>" outnum="3" >
		<wtc:param value="<%=inPubParams[0]%>"/>
		<wtc:param value="<%=inPubParams[1]%>"/>
		<wtc:param value="<%=inPubParams[2]%>"/>
		<wtc:param value="<%=inPubParams[3]%>"/>
		<wtc:param value="<%=inPubParams[4]%>"/>
		<wtc:param value="<%=inPubParams[5]%>"/>
		<wtc:param value="<%=inPubParams[6]%>"/>
		<wtc:param value="<%=inPubParams[7]%>"/>
		<wtc:param value="<%=inPubParams[8]%>"/>
		<wtc:param value="<%=inPubParams[9]%>"/>	
		<wtc:param value="<%=inPubParams[10]%>"/>
		<wtc:param value="<%=inPubParams[11]%>"/>
		<wtc:param value="<%=inPubParams[12]%>"/>
		<wtc:param value="<%=inPubParams[13]%>"/>
		<wtc:param value="<%=inPubParams[14]%>"/>
		<wtc:param value="<%=inPubParams[15]%>"/>
		<wtc:param value="<%=inPubParams[16]%>"/>
		<wtc:param value="<%=inPubParams[17]%>"/>
		<wtc:param value="<%=inPubParams[18]%>"/>
		<wtc:param value="<%=inPubParams[19]%>"/>	
		<wtc:param value="<%=inPubParams[20]%>"/>
		<wtc:param value="<%=inPubParams[21]%>"/>	
		<wtc:param value="<%=inPubParams[22]%>"/>
		<wtc:param value="<%=inPubParams[23]%>"/>	
		<wtc:param value="<%=inPubParams[24]%>"/>	
		<wtc:param value="<%=inPubParams[25]%>"/>	
		<wtc:param value="<%=inPubParams[26]%>"/><%/*diling add 欠费提醒号码@2012/9/6*/%>
			
		<wtc:param value="<%=inPubParams[27]%>"/>	
		<wtc:param value="<%=inPubParams[28]%>"/>	
		<wtc:param value="<%=inPubParams[29]%>"/>			
			
			
		</wtc:service>
		<wtc:array id="backInfo" scope="end"/>



<%	
String iLoginAccept = WtcUtil.repNull(request.getParameter("loginAccept"));	
String iOpCode = 		inPubParams[2] ;
String iLoginNo = 		"";
String iLoginPwd = 		"";
String iPhoneNo = 		request.getParameter("book_phoneNo");	
String iUserPwd = 		"";
String inOpNote = 		"";
String iBookingId = 	"";

System.out.println("zhangyan add  iLoginAccept = ["+iLoginAccept+"] ");
System.out.println("zhangyan add  iOpCode = ["+iOpCode+"] ");
System.out.println("zhangyan add  iLoginNo = ["+iLoginNo+"] ");
System.out.println("zhangyan add  iLoginPwd = ["+iLoginPwd+"] ");
System.out.println("zhangyan add  iPhoneNo = ["+iPhoneNo+"] ");
System.out.println("zhangyan add  inOpNote = ["+inOpNote+"] ");
System.out.println("zhangyan add  iBookingId = ["+iLoginAccept+"] ");

String booking_url = "/npage/public/pubCfmBookingInfo.jsp?iOpCode="+iOpCode
	+"&iLoginNo="+iLoginNo
	+"&iLoginPwd="+iLoginPwd
	+"&iPhoneNo="+iPhoneNo
	+"&iUserPwd="+iUserPwd
	+"&inOpNote"+inOpNote
	+"&iLoginAccept="+iLoginAccept
	+"&iBookingId="+iBookingId;		
System.out.println("booking_url="+booking_url);
if (iOpCode.equals("1214"))
{
	%>
	<jsp:include page="<%=booking_url%>" flush="true" />
	<%
}else
{
	System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~iOpCode==="+iOpCode);
}

System.out.println("%%%%%%%调用预约服务结束%%%%%%%%"); 



    String errCode = retCode;
    String errMsg = retMsg;
    String f1213LoginAccept="";
    if(backInfo.length>0){
    	f1213LoginAccept = backInfo[0][0];
    	System.out.println("###################################f1213->f1213LoginAccept->"+f1213LoginAccept);
    }
    //增加统一接触	
    String opBeginTime1  = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());//业务开始时间
	String url = "/npage/contact/upCnttInfo.jsp?opCode="+inPubParams[1]+"&retCodeForCntt="+retCode+"&opName=综合变更&workNo="+inPubParams[2]+"&loginAccept="+f1213LoginAccept+"&pageActivePhone="+inPubParams[5]+"&retMsgForCntt="+errMsg+"&opBeginTime="+opBeginTime1;
%>
		<jsp:include page="<%=url%>" flush="true" />
<%
    System.out.println("Msg1 :" + errCode + ":" + errMsg);
    System.out.println(backInfo.length);
    
    
        System.out.println(backInfo[0].length);
    String strArray = createArray("backInfo", backInfo.length);
%>
		<%=strArray%>
<%
		if(backInfo.length>0){
    	for (int j = 0; j < backInfo[0].length; j++) {
    	    	    System.out.println("backInfo[0][j]===="+backInfo[0][j]);
%>
				backInfo[0][<%=j%>] = "<%=backInfo[0][j]%>";
<%
    	}
    }
%>

		var response = new AJAXPacket();
		response.data.add("backString",backInfo);
		response.data.add("flag","1");
		response.data.add("errCode","<%=errCode%>");
		response.data.add("errMsg","<%=errMsg%>");
		core.ajax.receivePacket(response);
