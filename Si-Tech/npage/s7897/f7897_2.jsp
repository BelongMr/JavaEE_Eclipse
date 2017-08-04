<%
    /********************
     * @ OpCode    :  7897
     * @ OpName    :  集团成员资费变更
     * @ CopyRight :  si-tech
     * @ Author    :  qidp
     * @ Date      :  2009-10-19
     * @ Update    :  
     ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<%
    String opCode = "7897";
    String opName = "集团成员资费变更";
    
    String workNo           = WtcUtil.repNull((String)session.getAttribute("workNo"));
    String workName         = WtcUtil.repNull((String)session.getAttribute("workName"));
    String orgCode          = WtcUtil.repNull((String)session.getAttribute("orgCode"));
    String regionCode       = WtcUtil.repNull((String)session.getAttribute("regCode"));
    String loginPasswd      = WtcUtil.repNull((String)session.getAttribute("password"));
    String ipAddr           = WtcUtil.repNull((String)session.getAttribute("ipAddr"));
    
    String iLoginAccept     = WtcUtil.repNull((String)request.getParameter("sys_accept"));
    String iSysNote         = WtcUtil.repNull((String)request.getParameter("opNote"));
	String iOpNote          = WtcUtil.repNull((String)request.getParameter("opNote"));
	String iGrpIdNo         = WtcUtil.repNull((String)request.getParameter("id_no"));
	String iGrpOutNo        = WtcUtil.repNull((String)request.getParameter("user_no"));
	String iNewRate         = WtcUtil.repNull((String)request.getParameter("new_fee_code"));
	String iUnitId          = WtcUtil.repNull((String)request.getParameter("unit_id"));
	
	String iPhoneNo         = WtcUtil.repNull((String)request.getParameter("phone_no"));
	
	String cfmPnoneNo         = WtcUtil.repNull((String)request.getParameter("cfmPnoneNo"));
	
	System.out.println("----hejwa-------------cfmPnoneNo-------------------->"+cfmPnoneNo);
	
	String feeList = "0~0~0~0.00~0.00~0~0~";
	String iPayFlag = "";
	String iOpType = "m03";
	
	String iSmCode = WtcUtil.repNull((String)request.getParameter("sm_code"));
	String iRequestType = "";
	if("AD".equals(iSmCode)){
        iRequestType = "02";
    }
    else{
        iRequestType = "";
    }
    
    String sqlStr = "select pay_flag from sGrpSmCode where sm_code='"+iSmCode+"'";
    %>
        <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode1" retmsg="retMsg1"  outnum="1">
        	<wtc:sql><%=sqlStr%></wtc:sql>
        </wtc:pubselect>
        <wtc:array id="retArr1" scope="end"/>
    <%
    if("000000".equals(retCode1)){
        if(retArr1.length>0){
            iPayFlag = retArr1[0][0];
        }else{
            iPayFlag = "0";
        }
    }
    
    String retCodeForCntt = "";
    String retMsgForCntt = "";
    
    String errPhoneNo    = "";
    String errPhoneNoMsg = "";
    try{
    %>
        <wtc:service name="s7897Cfm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode" retmsg="retMsg" outnum="4" >
            <wtc:param value="<%=iLoginAccept%>"/>
            <wtc:param value="<%=opCode%>"/>
            <wtc:param value="<%=workNo%>"/>
            <wtc:param value="<%=loginPasswd%>"/>
            <wtc:param value="<%=orgCode%>"/>
            <wtc:param value="<%=iSysNote%>"/>
            <wtc:param value="<%=iOpNote%>"/>
            <wtc:param value="<%=ipAddr%>"/>
            <wtc:param value="<%=cfmPnoneNo%>"/>
            <wtc:param value="<%=iGrpIdNo%>"/>
            <wtc:param value="<%=iGrpOutNo%>"/>
            <wtc:param value="<%=iNewRate%>"/>
            <wtc:param value="<%=feeList%>"/>
            <wtc:param value="<%=iPayFlag%>"/>
            <wtc:param value="<%=iOpType%>"/>
            <wtc:param value="<%=iRequestType%>"/>
        </wtc:service>
        <wtc:array id="result_s7897Cfm" scope="end" />
        
    <%
    		if(result_s7897Cfm.length>0){
    			errPhoneNo    = result_s7897Cfm[0][2];
    			errPhoneNoMsg = result_s7897Cfm[0][3];
    			
    			if(errPhoneNo==null)       errPhoneNo = "";
    			if(errPhoneNoMsg==null) errPhoneNoMsg = "";
    		}
        retCodeForCntt = retCode;
        retMsgForCntt = retMsg;
    }catch(Exception e){
    %>
        <script type=text/javascript>
            rdShowMessageDialog("调用服务s7897Cfm失败！",0);
            history.go(-1);
        </script>
    <%
    	e.printStackTrace();
    	System.out.println("# return from f7897_2.jsp -> Call Service s7897Cfm Failed !");
    }
    
System.out.println("%%%%%%%%调用统一接触开始%%%%%%%%");
%>
<%String url = "/npage/contact/onceCnttInfo.jsp?opCode="+opCode+"&retCodeForCntt="+retCodeForCntt+"&retMsgForCntt="+retMsgForCntt+"&opName="+opName+"&workNo="+workNo+"&loginAccept="+iLoginAccept+"&pageActivePhone="+""+"&opBeginTime="+opBeginTime+"&contactId="+iUnitId+"&contactType=grp";%>
<jsp:include page="<%=url%>" flush="true" />
<%
System.out.println("%%%%%%%%调用统一接触结束%%%%%%%%");
%>


<head>
    <title>集团成员增加</title>
</head>
<script language="JavaScript">
    function print_xls(){
    	document.frm.action="/npage/public/pubExcl.jsp";
		document.frm.submit();
    }
</script>
<BODY>
<form name="frm" action="" method="post" >
<%@ include file="/npage/include/header.jsp" %>
<div class="title">
	<div id="title_zi">操作失败号码列表</div>
</div>
<%
java.util.Date sysdate = new java.util.Date();
java.text.SimpleDateFormat sf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

String createTime = sf.format(sysdate);

String pnt_B1=request.getParameter("cust_name")+"|"
	+iUnitId+"|"
	+iGrpIdNo+"|"
	+workNo+"|"
	+opName+"|"
	+createTime+"|"
	;
%>
<INPUT TYPE='hidden' ID = 'pnt_A' NAME = 'pnt_A' VALUE = '黑龙江移动通讯公司集团成员管理不成功记录|'>
<INPUT TYPE='hidden' ID = 'pnt_B' NAME = 'pnt_B' VALUE = '集团名称|集团编号|集团产品帐户|操作工号|操作功能|操作日期|'>
<INPUT TYPE='hidden' ID = 'pnt_B1' NAME = 'pnt_B1' VALUE = '<%=pnt_B1%>'>
<INPUT TYPE='hidden' ID = 'pnt_C' NAME = 'pnt_C' VALUE = '未成功号码|失败原因|'>
<INPUT TYPE='hidden' ID = 'pnt_C1' NAME = 'pnt_C1' VALUE = "<%=iPhoneNo%>~|<%=retMsgForCntt%>~|">
<INPUT TYPE='hidden' ID = 'opCode' NAME = 'opCode' VALUE = "<%=opCode%>">
<TABLE cellSpacing="0">
	<TR>
		<TH width='50%' align='center'>操作失败号码</TH>
		<TH width='50%'>失败原因</TH>
	</TR>
	<%
	if ( !"000000".equals(retCodeForCntt) ){
	%>
		<TR>
			<TD  align='center'><%=retCodeForCntt%></TD>
			<TD ><%=retMsgForCntt%></TD>
		</TR>	
	<%	
	}else{
		String errPhoneNoArr[]    = errPhoneNo.split("~");
		String errPhoneNoMsgArr[] = errPhoneNoMsg.split("~");
		
		for(int ei=0; ei<errPhoneNoArr.length; ei++){
		%>
		<TR>
			<TD  align='center'><%=errPhoneNoArr[ei]%></TD>
			<TD ><%=errPhoneNoMsgArr[ei]%></TD>
		</TR>	
		<%
		}
	}
	%>
</TABLE>

<TABLE cellspacing="0">
	<tr id="footer">
		<td>
			<input class="b_foot_long" name="prtxls" id="prtxls" type=button value="保存XLS文件" 
				onclick="print_xls()" style="cursor:hand">
			<input class="b_foot" name=back onClick="removeCurrentTab()" type=button value=关闭>
			<input class="b_foot" name=back onClick="window.location='f7897_1.jsp?opCode=7897&opName=集团成员资费变更&crmActiveOpCode=7897'" style="cursor:hand" type=button value=返回>
		</td>
	</tr>
</TABLE>

<%@ include file="/npage/include/footer.jsp" %>
</form>
</BODY>
</html>