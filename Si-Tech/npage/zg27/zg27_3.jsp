<%
/********************
 * version v2.0
 * ������: si-tech
 * update by zhangshuaia @ 2009-08-05
 ********************/
%>
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>

<%	
    String org_Code = (String)session.getAttribute("orgCode");
    String regionCode = org_Code.substring(0,2);				   
	
	String opName = "��ֵ˰��Ʊ���Ͽ�������";
	
	       
	String loginName = (String)session.getAttribute("workName");   
	String pass = (String)session.getAttribute("password");
	
	String tax_number= request.getParameter("tax_number");
    String tax_code= request.getParameter("tax_code");
	String s_cust_id= request.getParameter("s_cust_id");
	String op_code = "zg27";//��������
	String work_no = (String)session.getAttribute("workNo");
	String sprid= request.getParameter("sprid");//�����˹���
	String lxr_phone= request.getParameter("lxr_phone");
	String hzyy= request.getParameter("hzyy");
	String ifcheck= request.getParameter("ifcheck");
	String squery_type="0";
	String snotice_number= request.getParameter("accepts");//֪ͨ����ˮ
	 
	 
	String paraAray[] = new String[11]; 
	paraAray[0] = tax_number;
	paraAray[1] = tax_code;
	paraAray[2] = s_cust_id;
	paraAray[3] = op_code;
	paraAray[4] = work_no;
	paraAray[5] = sprid;
	paraAray[6] = lxr_phone;
	paraAray[7] = "0";
	paraAray[8] = "0";  
  
 
%>
<wtc:service name="bs_zg27Cfm" routerKey="region" routerValue="<%=regionCode%>" retcode="sCode" retmsg="sMsg" outnum="2" >
    <wtc:param value="<%=paraAray[0]%>"/>
    <wtc:param value="<%=paraAray[1]%>"/> 
    <wtc:param value="<%=paraAray[2]%>"/>
    <wtc:param value="<%=paraAray[3]%>"/>
    <wtc:param value="<%=paraAray[4]%>"/>
    <wtc:param value="<%=paraAray[5]%>"/>
    <wtc:param value="<%=paraAray[6]%>"/>
	<wtc:param value="<%=paraAray[7]%>"/>
	<wtc:param value="<%=paraAray[8]%>"/>
 
    
</wtc:service>
<wtc:array id="sArr" scope="end"/>
<%
	String retCode= sCode;
	String retMsg = sMsg;
   

	String errMsg = sMsg;
	if ( sCode.equals("000000"))
	{
 
%>
<script language="JavaScript">
	rdShowMessageDialog("�����ɹ���");
	window.location="zg27_1.jsp?opCode=zg27&opName=��ֵ˰���ַ�Ʊ��������";
	</script>
<%
	}else{
%>   
<script language="JavaScript">
	rdShowMessageDialog("����ʧ��: <%=retMsg%>,<%=sCode%>",0);
	window.location="zg27_1.jsp?opCode=zg27&opName=��ֵ˰���ַ�Ʊ��������";
	</script>
<%}
%>
