<%
/********************
 version v2.0
 开发商: si-tech
 update zhaohaitao at 2009.02.25
********************/
%>


<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page contentType="text/html;charset=GBK"%>

<%

	response.setHeader("Pragma", "no-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	
%>

<%

    String workNo   = (String)session.getAttribute("workNo");
    String org_code = (String)session.getAttribute("orgCode");
    String regCode = (String)session.getAttribute("regCode");
    
    String mode_id = request.getParameter("mode_id");
    String mode_name = request.getParameter("mode_name");
    String mode_note = request.getParameter("mode_note");
    String disp_flag = request.getParameter("request_privs");
    
    String grade_id = request.getParameter("grade_id");
    String month_fee = request.getParameter("month_fee");
    String call_disp = request.getParameter("call_disp");
    String base_line = request.getParameter("base_line");
    String local_call_send = request.getParameter("local_call_send");
    String local_call_recv = request.getParameter("local_call_recv");
    String local_long_send = request.getParameter("local_long_send");
    String province_call_send = request.getParameter("province_call_send");
    String province_call_recv = request.getParameter("province_call_recv");
    String interprov_call_send = request.getParameter("interprov_call_send");
    String interprov_call_recv = request.getParameter("interprov_call_recv");
    String hk_mac_tw_call = request.getParameter("hk_mac_tw_call");
    String intl_call = request.getParameter("intl_call");
    String short_msg = request.getParameter("short_msg");
    String color_msg = request.getParameter("color_msg");
    String gprs_wap = request.getParameter("gprs_wap");
    String present_src = request.getParameter("present_src");
    
    mode_note=mode_note.replaceAll("\r\n","<br>");
   
    String paraArray[] = new String[21];
    paraArray[0] = mode_id;
    paraArray[1] = mode_name;
    paraArray[2] = mode_note;
    paraArray[3] = disp_flag;
    paraArray[4] = workNo;
    
    paraArray[5] = month_fee;
    paraArray[6] = call_disp;
    paraArray[7] = base_line;
    paraArray[8] = local_call_send;
    paraArray[9] = local_call_recv;
    paraArray[10] = local_long_send;
    paraArray[11] = province_call_send;
    paraArray[12] = province_call_recv;
    paraArray[13] = interprov_call_send;
    paraArray[14] = interprov_call_recv;
    paraArray[15] = hk_mac_tw_call;
    paraArray[16] = intl_call;
    paraArray[17] = short_msg;
    paraArray[18] = color_msg;
    paraArray[19] = gprs_wap;
    paraArray[20] = present_src;
    
    
    //impl.callService("s6208Modify",paraArray,"2","region",org_code.substring(0,2));
%>
	<wtc:service name="s6208Modify" routerKey="region" routerValue="<%=regCode%>" retcode="retCode1" retmsg="retMsg1" outnum="2">			
	<wtc:params value="<%=paraArray%>"/>	
	</wtc:service>	
	<wtc:array id="result1"  scope="end"/>
<%
    
    String errCode = retCode1;
    String errMsg = retMsg1;
   
    System.out.println("errCode===="+errCode);
    System.out.println("errMsg===="+errMsg);
    if (errCode.equals("000000"))
    {
        response.sendRedirect("f6208.jsp?retCode=2&opCode=6208&opName=资费导购套餐配置");
    }
    else
    {
        response.sendRedirect("../common/errorpage.jsp");
    }

%>

