<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page import="import java.text.SimpleDateFormat;"%>
<%
	String regionCode=(String)session.getAttribute("regCode");
	int	flag=0;
	String pcode = request.getParameter("pcode");
	String fileName = request.getParameter("filenamelujing");
	fileName=fileName.substring(fileName.length()-3,fileName.length());
	System.out.println(fileName+"--------------fileName--------------");

	
	String current_timeNAME3=new SimpleDateFormat("yyyyMMdd HH:mm:ss", Locale.getDefault()).format(new java.util.Date());
%>
<wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>"  id="seq"/>	
<%
			/* ƴ���ļ��� */
				String iErrorNo ="";
				String sErrorMessage = " ";
				String sysAccept = "";
				sysAccept = seq;				
		    String filename=regionCode+sysAccept+"."+fileName;
		    String sSaveName=request.getRealPath("/npage/tmp/")+"/"+filename;
				System.out.println("sSaveName:"+sSaveName);
				/* ׼���ϴ���webloigc������� */
				SmartUpload mySmartUpload =new SmartUpload();
				mySmartUpload.initialize(pageContext);
				try {
					mySmartUpload.setAllowedFilesList(fileName);//�˴����ļ���ʽ���Ը�����Ҫ�Լ��޸�
					//�����ļ� 
					mySmartUpload.upload();
				} catch (Exception e){
%>
					<SCRIPT language=javascript>
					rdShowMessageDialog("ֻ�����ϴ�.txt��.TXT�����ı��ļ���");
					window.location="fg863Cfm.jsp";
					</script>
<%
				}
				try{ 
					com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
					if (myFile.isMissing()){
%>
					<SCRIPT language=javascript>
					rdShowMessageDialog("����ѡ��Ҫ�ϴ����ļ���");					
					window.location="fg863Cfm.jsp";
					</script>
<%
					}else{
						myFile.saveAs(sSaveName,SmartUpload.SAVE_PHYSICAL);
					}
				}catch (Exception e){
					System.out.println(e.toString()); 
%>
					<SCRIPT language=javascript>
					rdShowMessageDialog("<%=e.toString()%>",0);						
					window.location="fg863Cfm.jsp";
					</script>
<%
				}
				System.out.println("==============�ļ��ϴ����==========");
				/* ��ȡ�ļ���д��tuxedo������� */
				FileReader fr = new FileReader(sSaveName);
				BufferedReader br = new BufferedReader(fr);   
				String phoneText="";
				String line = null;
				String paraAray2[] = new String[2];
				paraAray2[0] = filename;
				paraAray2[1] = phoneText;
				do {
					line = br.readLine();
					if (line==null) continue;       
					if (line.trim().equals("")) continue;   
					phoneText+=line+"\n"; 
					System.out.println("==phoneText== " + phoneText);
					if (phoneText.length()>=1000){
						paraAray2[1] = phoneText;
%>
						<wtc:service name="sbatchWrite" routerKey="region" 
							 routerValue="<%=regionCode%>" 
									retcode="errCode2" retmsg="errMsg2"  outnum="2" >
						<wtc:param value="<%=paraAray2[0]%>"/>
						<wtc:param value="<%=paraAray2[1]%>"/>
						</wtc:service>
						<wtc:array id="resultArr" scope="end" />
<%
					System.out.println("==errCode2== " + errCode2);
						if(errCode2.equals("0")==false)
						{
					    flag=-1;
						}
						iErrorNo=resultArr[0][0];
						phoneText="";
					}
				}while (line!=null);        
				br.close();
				fr.close();
				paraAray2[1] = phoneText;
%>
				<wtc:service name="sbatchWrite" routerKey="region" 
					 routerValue="<%=regionCode%>" outnum="2" >
				<wtc:param value="<%=paraAray2[0]%>"/>
				<wtc:param value="<%=paraAray2[1]%>"/>
				</wtc:service>
				<wtc:array id="resultArr3" scope="end" />
<%
					System.out.println("==retCode== " + retCode);
				if(retCode.equals("0")==false)
				{
			    flag=-1;
				}
				iErrorNo=resultArr3[0][0];
%>					

<SCRIPT type=text/javascript>
	function ifprint(){
<% 
	
		if(flag==0){
%>
		frm_print_invoice.submit();
<% 
		}
		else{
%>
		rdShowMessageDialog("�ļ�׼��ʧ�ܡ�<br>������룺'<%=iErrorNo%>'��<br>������Ϣ��'<%=sErrorMessage%>'��",0);
		history.go(-1);
<%
  	}
%>
	} 						
</SCRIPT>
<html>
	<body onload="ifprint()">
		<form action="fg863Cfm.jsp" name="frm_print_invoice" method="post">
			<INPUT TYPE="hidden" name="pcode" value="<%=pcode%>">
			<INPUT TYPE="hidden" name="sSaveName" value="<%=sSaveName%>">
			<INPUT TYPE="hidden" name="filename" value="<%=filename%>">
			<INPUT TYPE="hidden" name="current_timeNAME3" value="<%=current_timeNAME3%>">

		</form>
	</body>
</html>
