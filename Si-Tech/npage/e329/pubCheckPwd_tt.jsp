<%
/********************
 version v2.0
������: si-tech
*
*create:wanghfa@2010-8-16 У�������Ƿ���ȷ
*
********************/
%>
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_ajax.jsp" %>

<%
	System.out.println("=zhangyan==14=pubCheckPwd.jsp====wanghfa=��������Ƿ���ȷ===========");

	String accountType = (String)session.getAttribute("accountType"); 		//yanpx ���� Ϊ�ж��Ƿ�Ϊ�ͷ�����
	String custType = WtcUtil.repStr(request.getParameter("custType"),"");	//01:�û�����У�� 02 �ͻ�����У�� 03�ʻ�����У��
		System.out.println("=zhangyan==18=pubCheckPwd.jsp====wanghfa=��������Ƿ���ȷ===========");

	String phoneNo = WtcUtil.repStr(request.getParameter("phoneNo"),"");	//ttkd���� ��Ҫͨ��ת�� ��209����
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
			alert("��������ȷ����ͨ�����ʺţ�");
			//window.location="e329_1.jsp?opCode=e329&opName=��ͨ������Ϣ��ѯ&crmActiveOpCode=e329";
		  </script><%
	}
	else
	{
		tt_phone_no=resulttt[0][0];
	}
	System.out.println("=zhangyan==21=pubCheckPwd.jsp====wanghfa=��������Ƿ���ȷ===========");

	String custPaswd = WtcUtil.repStr(request.getParameter("custPaswd"),"");//�û�/�ͻ�/�ʻ�����
	String idType = WtcUtil.repStr(request.getParameter("idType"),"");		//en ����Ϊ���ģ�������� ����Ϊ����
	String idNum = WtcUtil.repStr(request.getParameter("idNum"),"");		//����
	String loginNo = WtcUtil.repStr(request.getParameter("loginNo"),"");	//����
	String retCode1 = new String();
	String retMsg1 = new String();
	System.out.println("=zhangyan===pubCheckPwd.jsp====wanghfa=��������Ƿ���ȷ===========");
	System.out.println("=zhangyan==========wanghfa============ custType = " + custType);
	System.out.println("=zhangyan==========wanghfa============ phoneNo = " + phoneNo);
	System.out.println("=zhangyan==========wanghfa============ custPaswd = " + custPaswd);
	System.out.println("=zhangyan==========wanghfa============ idType = " + idType);
	System.out.println("=zhangyan==========wanghfa============ idNum = " + idNum);
	System.out.println("=zhangyan==========wanghfa============ loginNo = " + loginNo);

/*yanpx ���� �ͷ����Ų�����������֤ ֱ��ͨ��20100907 ��ʼ */
if( accountType.equals("2") ){
	retCode1 = "000000";
	retMsg1  = "������֤ͨ��";
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
/*yanpx ���� ����*/
%>
var response = new AJAXPacket();
var retResult = "<%=retCode1%>";
var msg = "<%=retMsg1%>";

response.data.add("retResult",retResult);
response.data.add("msg",msg);

core.ajax.receivePacket(response);