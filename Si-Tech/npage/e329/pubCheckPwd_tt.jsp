<%
/********************
 version v2.0
开发商: si-tech
*
*create:wanghfa@2010-8-16 校验密码是否正确
*
********************/
%>
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_ajax.jsp" %>

<%
	System.out.println("=zhangyan==14=pubCheckPwd.jsp====wanghfa=检查密码是否正确===========");

	String accountType = (String)session.getAttribute("accountType"); 		//yanpx 添加 为判断是否为客服工号
	String custType = WtcUtil.repStr(request.getParameter("custType"),"");	//01:用户密码校验 02 客户密码校验 03帐户密码校验
		System.out.println("=zhangyan==18=pubCheckPwd.jsp====wanghfa=检查密码是否正确===========");

	String phoneNo = WtcUtil.repStr(request.getParameter("phoneNo"),"");	//ttkd号码 需要通过转换 成209号码
	String tt_phone_no="";
	String [] paraIn = new String[2];
	paraIn[0]="select trim(to_char(phone_no)) from dbroadbandmsg where cfm_login=:s_no";
	paraIn[1]="s_no="+phoneNo;
%>
	<wtc:service name="TlsPubSelBoss"   retcode="retCodett" retmsg="retMsgtt" outnum="1" >
    	<wtc:param value="<%=paraIn[0]%>"/>
    	<wtc:param value="<%=paraIn[1]%>"/> 
    </wtc:service>
    <wtc:array id="resulttt" scope="end"/>
<%
	if(resulttt.length==0)
	{
		%><script language="javascript">
			alert("请输入正确的铁通宽带帐号！");
			//window.location="e329_1.jsp?opCode=e329&opName=铁通交费信息查询&crmActiveOpCode=e329";
		  </script><%
	}
	else
	{
		tt_phone_no=resulttt[0][0];
	}
	System.out.println("=zhangyan==21=pubCheckPwd.jsp====wanghfa=检查密码是否正确===========");

	String custPaswd = WtcUtil.repStr(request.getParameter("custPaswd"),"");//用户/客户/帐户密码
	String idType = WtcUtil.repStr(request.getParameter("idType"),"");		//en 密码为密文，其它情况 密码为明文
	String idNum = WtcUtil.repStr(request.getParameter("idNum"),"");		//传空
	String loginNo = WtcUtil.repStr(request.getParameter("loginNo"),"");	//工号
	String retCode1 = new String();
	String retMsg1 = new String();
	System.out.println("=zhangyan===pubCheckPwd.jsp====wanghfa=检查密码是否正确===========");
	System.out.println("=zhangyan==========wanghfa============ custType = " + custType);
	System.out.println("=zhangyan==========wanghfa============ phoneNo = " + phoneNo);
	System.out.println("=zhangyan==========wanghfa============ custPaswd = " + custPaswd);
	System.out.println("=zhangyan==========wanghfa============ idType = " + idType);
	System.out.println("=zhangyan==========wanghfa============ idNum = " + idNum);
	System.out.println("=zhangyan==========wanghfa============ loginNo = " + loginNo);

/*yanpx 添加 客服工号不进行密码验证 直接通过20100907 开始 */
if( accountType.equals("2") ){
	retCode1 = "000000";
	retMsg1  = "密码验证通过";
} else {
%>
<wtc:service name="sPubCustCheck" routerKey="phone" routerValue="<%=phoneNo%>" retcode="retCode" retmsg="retMsg" outnum="5">
	<wtc:param value="<%=custType%>"/>
	<wtc:param value="<%=tt_phone_no%>"/>
	<wtc:param value="<%=custPaswd%>"/>
	<wtc:param value="<%=idType%>"/>
	<wtc:param value="<%=idNum%>"/>
	<wtc:param value="<%=loginNo%>"/>
</wtc:service>
<wtc:array id="result" scope="end"/>
<%
	System.out.println("=zhangyan==========wanghfa============retCode=" + retCode);
	System.out.println("=zhangyan==========wanghfa============retMsg=" + retMsg);
	retCode1 = retCode;
	retMsg1  = retMsg;

	if ("000000".equals(retCode)) {
		for (int i = 0; i < result.length; i ++ ) {
			for (int j = 0; j < result[i].length; j ++) {
				System.out.println("==zhangyan=======wanghfa==========result[" + i + "][" + j + "]" + result[i][j]);
			}
		}
	}

}
/*yanpx 添加 结束*/
%>
var response = new AJAXPacket();
var retResult = "<%=retCode1%>";
var msg = "<%=retMsg1%>";

response.data.add("retResult",retResult);
response.data.add("msg",msg);

core.ajax.receivePacket(response);
