<%
  /*
   * ����: 4G������������ m067
   * �汾: 1.0
   * ����: 2014/3/20 
   * ����: diling
   * ��Ȩ: si-tech
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd Xhtml 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page contentType= "text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<meta http-equiv="Expires" content="0">
<%
		request.setCharacterEncoding("GBK");
		
		String opCode="m067";
		String opName="4G������������";
    String workNo = (String)session.getAttribute("workNo");
    String regionCode=(String)session.getAttribute("regCode");
    String passWord = (String)session.getAttribute("password");
    String ip = request.getRemoteAddr();
    
		String execResult = "�ϴ����δ֪��";
		String opNote = "Ӫҵǰ̨"+workNo+"������"+opName+"����";
%>
		<wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>"  id="sysAccept"/>
<%
		/* ƴ���ļ��� */
    String filename = regionCode + sysAccept + ".txt";
    String sSaveName = request.getRealPath("/npage/tmp/") + "/" + filename;
		
		/* ׼���ϴ���webloigc������� */
		SmartUpload mySmartUpload =new SmartUpload();
		mySmartUpload.initialize(pageContext);
		
		try {
				mySmartUpload.setAllowedFilesList("txt,TXT");//�����ϴ�������
				mySmartUpload.upload();
		} catch (Exception e){
		
%>
				<SCRIPT language=javascript>
						rdShowMessageDialog("ֻ�����ϴ�.txt�����ı��ļ���", 0);
						window.location.href = "fm067_main.jsp?opCode=<%=opCode%>&opName=<%=opName%>";
				</script>
<%
        return;
		}
		
		try{ 
				com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
				if (myFile.isMissing()){
%>
						<SCRIPT language=javascript>
								rdShowMessageDialog("�ļ���ʧ���ϴ����ɹ���", 0);
								window.location.href = "fm067_main.jsp?opCode=<%=opCode%>&opName=<%=opName%>";
						</script>
<%
            return;
				}else{
						myFile.saveAs(sSaveName, SmartUpload.SAVE_PHYSICAL);
				}
		}catch (Exception e){
				System.out.println(e.toString()); 
%>
				<script language=javascript>
						rdShowMessageDialog("<%=e.toString()%>", 0);
						window.location.href = "fm067_main.jsp?opCode=<%=opCode%>&opName=<%=opName%>";
				</script>
<%
        return;
		}
		
		System.out.println("==============�ļ��ϴ����==========");
		/* ��ȡ�ļ���д��tuxedo������� */
		FileReader fr = new FileReader(sSaveName);
		BufferedReader br = new BufferedReader(fr);   
		String line = br.readLine();
		while(line != null && !line.trim().equals("")){
				String tmp = line + "\n";
%>
				<wtc:service name="sbatchWrite" routerKey="region" routerValue="<%=regionCode%>" retcode="errCode2" retmsg="errMsg2"  outnum="2" >
						<wtc:param value="<%=filename%>"/>
						<wtc:param value="<%=tmp%>"/>
				</wtc:service>
				<wtc:array id="resultArr" scope="end" />
<%
				line = br.readLine();
		}
		br.close();
		fr.close();
		
%>
		<wtc:service name="sm067CfmBat" routerKey="region" routerValue="<%=regionCode%>" retcode="Code" retmsg="Msg" outnum="6" >
	      <wtc:param value="<%=sysAccept%>"/>
      	<wtc:param value="01" />
      	<wtc:param value="<%=opCode%>" />
      	<wtc:param value="<%=workNo%>"/>
      	<wtc:param value="<%=passWord%>" />	
      	<wtc:param value=""/>
        <wtc:param value="" />
        <wtc:param value="<%=opNote%>"/>
        <wtc:param value="<%=filename%>"/>
		</wtc:service>
		<wtc:array id="result1" start="0" length="1" scope="end"/>
		<wtc:array id="result2" start="1" length="3" scope="end"/>
<%

String retcode = Code;
String retmsg = Msg;

if(!"000000".equals(Code)){
%>
    <script language="javascript">
  			rdShowMessageDialog("�ύ�������ʧ�ܣ�<%=retcode%>, <%=retmsg%>");
  			window.location.href = "fm067_main.jsp?opCode=<%=opCode%>&opName=<%=opName%>";
  	</script>
<%
}
		execResult = result1[0][0];
%>
		<script language="javascript">
				function goback(){
						window.location.href = "fm067_main.jsp?opCode=<%=opCode%>&opName=<%=opName%>";
				}
		</script>
		</head>
		<body>
		<form name="form1" id="form1" method="POST">
		<%@ include file="/npage/include/header.jsp" %>
			<div>
			<div class="title">
				<div id="title_zi">������</div>
			</div>
			
			<table cellspacing="0">
				<tr>
					<td width="100%"><%=execResult%></td>
				</tr>
			</table>
			
			<div class="title">
				<div id="title_zi">������ʾ</div>
			</div>
			<table cellspacing="0">
				<tr>
					<th>���</th>
					<th>�绰��</th>
					<th>��ʾ��Ϣ</th>
				</tr>
<%
		  	int retLength = result2.length;
		  	for(int i = 0; i < retLength; i++ ){
%>
					  <tr>
							<td><%=result2[i][0]%></td>
							<td><%=result2[i][1]%></td>
							<td><%=result2[i][2]%></td>
						</tr>
<%
		  	}
%>
			  <tr>
			  	<td id="footer" colspan="3">
			  		<input type="button" name="back" class="b_foot" value="����" onClick="goback()"  >
			  	</td>
			  </tr>
		  </table>
			</div>
		  <%@ include file="/npage/include/footer.jsp"%>
		</form>
		</body>
</html>