<%
/********************
 version v2.0
������: si-tech
*
*add:liangyl@2016-07-25 ҳ�濪��
*
********************/
%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	
<%@ page contentType= "text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%@ page import="java.text.SimpleDateFormat"%>


<%        
	
	String regionCode =  (String)session.getAttribute("regCode");
	String phone_no  = request.getParameter("phone_no");	
	String opcodess=request.getParameter("opcodess");
	String plworkorgcode=request.getParameter("plworkorgcode");
	String plywaccept=request.getParameter("plywaccept");
	String plstarttimes=request.getParameter("plstarttimes");
	String plendtimes=request.getParameter("plendtimes");
	String work_no = (String)session.getAttribute("workNo");
	String noteopr =work_no+"����Ա�������¼��ѯ����";
	String current_timeNAME=new SimpleDateFormat("yyyyMMddHHmmss", Locale.getDefault()).format(new java.util.Date());
	//add by diling for ��ȫ�ӹ��޸ķ����б�
	String password = (String) session.getAttribute("password");
	
	String  inputParsm [] = new String[17];
	inputParsm[0] = plywaccept;
	inputParsm[1] = "01";
	inputParsm[2] = "m272";
	inputParsm[3] = work_no;
	inputParsm[4] = password;
	inputParsm[5] = "";
	inputParsm[6] = "";
	inputParsm[7] = plworkorgcode;
	inputParsm[8] = plstarttimes;
	inputParsm[9] = plendtimes;

	
%>
	
	
	<wtc:service name="sm272BatchQry" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode2" retmsg="retMsg2" outnum="20">
			<wtc:param value="<%=inputParsm[0]%>"/>
			<wtc:param value="<%=inputParsm[1]%>"/>
			<wtc:param value="m275"/>
			<wtc:param value="<%=inputParsm[3]%>"/>
			<wtc:param value="<%=inputParsm[4]%>"/>
			<wtc:param value="<%=inputParsm[5]%>"/>
			<wtc:param value="<%=inputParsm[6]%>"/>
			<wtc:param value="<%=inputParsm[7]%>"/>
			<wtc:param value="<%=inputParsm[8]%>"/>
			<wtc:param value="<%=inputParsm[9]%>"/>
	</wtc:service>
	<wtc:array id="result2" scope="end" />
	
<HTML><HEAD><TITLE></TITLE>

</HEAD>
<body>


	
	
	<div id="Operation_Table2">
		<div class="title">
			<div id="title_zi">����</div>
		</div>
		<table cellspacing="0" name="t1" id="t1">
			<tr align="center">
				<th>Ա�����</th>
				<th>ҵ����ˮ</th>
				<th>ҵ�����</th>
				<th>ҵ������</th>
				<th>��������</th>
				<th>����ʱ��</th>
				<th>�������</th>
			</tr>
			<%
		if(retCode2.equals("000000")) {
		System.out.println("length======="+result2.length);
		if(result2.length>0) {
			String tbClass="";
			for(int y=0;y<result2.length;y++){
				if(y%2==0){
					tbClass="Grey";
				}else{
					tbClass="";
				}
		%>
			<tr align="center">
				<td class="<%=tbClass%>"><%=result2[y][0]%></td>
				<td class="<%=tbClass%>"><%=result2[y][1]%></td>
				<td class="<%=tbClass%>"><%=result2[y][2]%></td>
				<td class="<%=tbClass%>"><%=result2[y][3]%></td>
				<td class="<%=tbClass%>"><%=result2[y][4]%></td>
				<td class="<%=tbClass%>"><%=result2[y][5]%></td>
				<td class="<%=tbClass%>"><%=result2[y][6]%></td>
			</tr>
			<%
		    }
		  }else {
		%>
			<tr height='25' align='center' onclick="plshowDetail()">
				<td colspan='7'>��ѯ��ϢΪ�գ�</td>
			</tr>
			<%}}else {
			%>
			<tr height='25' align='center'>
				<td colspan='7'>��ѯʧ�ܣ�<%=retCode2%>--<%=retMsg2%></td>
			</tr>
			<%
	}%>
		</table>
	</div>

</body>
</HTML>
