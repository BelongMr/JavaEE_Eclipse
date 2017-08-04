<%
/********************
 version v2.0
开发商: si-tech
********************/
%>
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.jspsmart.upload.*"%>
<%/*
* name    : 
* author  : sungq@si-tech.com.cn
* created : 2003-11-01
* revised : 2003-12-31
*/%>
<%
    String workno = (String)session.getAttribute("workNo");
    String workname =  (String)session.getAttribute("workName");
	String orgcode = (String)session.getAttribute("orgCode");
	String regionCode = (String)session.getAttribute("regCode");
	String sysAccept = "";
    %>
        <wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>"  id="seq"/>
    <%
    sysAccept = seq;
    System.out.println("#  @@@@@@@@@@     - 流水："+sysAccept);
    
	String filename = orgcode.substring(0,2)+sysAccept+".txt";
	String    iErrorNo ="";
	String    sErrorMessage = " ";
	String op_code = "1008"  ;
	String seled = request.getParameter("seled");
	//System.out.println("seed====="+seled);
	String billym = request.getParameter("billym");
	String remark = request.getParameter("remark");
	String sSaveName=request.getRealPath("/npage/tmp/")+"/"+filename;
	//System.out.println("sSaveName:"+sSaveName);
	SmartUpload mySmartUpload = new SmartUpload();
	try
	{
		mySmartUpload.initialize(pageContext);
        mySmartUpload.upload();
    }
    catch(Exception ex) {
        System.out.println("上载文件传输中出错！");
        iErrorNo = "139045";
		sErrorMessage = "上载文件传输中出错！";
    }
    System.out.println("########################## abcd");
    try {
		com.jspsmart.upload.File myFile  = mySmartUpload.getFiles().getFile(0);
		if (!myFile.isMissing()){
		System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ abcd");
		    myFile.saveAs(sSaveName);
		}
    }catch(Exception ex) {
        //System.out.println("上载文件存储时出错！");
        iErrorNo = "139046";
		sErrorMessage = "上载文件存储时出错！";
    }
	ArrayList arlist2 = new ArrayList();
	String paraAray[] = new String[2];
	paraAray[0] = filename;
	paraAray[1] = remark;
	
	String [][] result = new String[][]{};
	String [][] result2 = new String[][]{};
	String  sReturnCode = "";
	int		flag = 0;
	%>
	<wtc:service name="sbatchDel" routerKey="regionCode" routerValue="<%=regionCode%>" 
					retcode="errCode" retmsg="errMsg"  outnum="2" >
		<wtc:param value="<%=paraAray[0]%>"/>
		<wtc:param value="<%=paraAray[1]%>"/>
	</wtc:service>
	<wtc:array id="arlist" scope="end" />
	<%
	if(errCode.equals("0")||errCode.equals("000000")){
		result = arlist;
	}
	iErrorNo = result[0][0];
	//System.out.println("*********:'"+iErrorNo+"'");
	sErrorMessage = result[0][1];

	if (iErrorNo.equals("000000")==false)
	{
		//System.out.println(" 错误代码 : " + iErrorNo);
		//System.out.println(" 错误信息 : " + sErrorMessage);
        flag = -1;
	}

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
        if (phoneText.length()>=1000){
%>
			<wtc:service name="sbatchWrite" routerKey="regionCode" routerValue="<%=regionCode%>" 
						retcode="errCode2" retmsg="errMsg2"  outnum="2" >
			<wtc:param value="<%=paraAray2[0]%>"/>
			<wtc:param value="<%=paraAray2[1]%>"/>
			</wtc:service>
			<wtc:array id="resultArr" scope="end" />
<%
			result2 = resultArr;
			iErrorNo = result2[0][0];
			//System.out.println("*********:'"+iErrorNo+"'");
			sErrorMessage = result2[0][1];
			
			if (iErrorNo.equals("000000")==false)
			{
				//System.out.println(" 错误代码 : " + iErrorNo);
				//System.out.println(" 错误信息 : " + sErrorMessage);
				flag = -1;
			}
			phoneText="";
        }
    }while (line!=null);        
    br.close();
    fr.close();
%>
	<wtc:service name="sbatchWrite" routerKey="regionCode" routerValue="<%=regionCode%>" outnum="2" >
	<wtc:param value="<%=paraAray2[0]%>"/>
	<wtc:param value="<%=paraAray2[1]%>"/>
	</wtc:service>
	<wtc:array id="resultArr3" scope="end" />
<%
	result2 = resultArr3;
	iErrorNo = result2[0][0];
	//System.out.println("*********:'"+iErrorNo+"'");
	sErrorMessage = result2[0][1];

	if (iErrorNo.equals("000000")==false)
	{
		//System.out.println(" 错误代码 : " + iErrorNo);
		//System.out.println(" 错误信息 : " + sErrorMessage);
           flag = -1;
	}
   
	// 判断处理是否成功
	if (flag == 0)
	{
		//System.out.println("success!");
	}
	else
	{
		//System.out.println("failed, 请检查 !");
	}
	
%>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/common/redialog/redialog.js"></script>
<SCRIPT type=text/javascript>
function ifprint(){
     <% 

     if (flag == 0){%>
     frm_print_invoice.submit();
     <% }else {%>
    rdShowMessageDialog("文件准备失败。<br>错误代码：'<%=iErrorNo%>'。<br>错误信息：'<%=sErrorMessage%>'。",0);
    history.go(-1);
    <%}
     %>
} 						
</SCRIPT>
<html>
<body onload="ifprint()">
<form action="f1008cfm2.jsp" name="frm_print_invoice" method="post">
<INPUT TYPE="hidden" name="billym" value="<%=billym%>">
<INPUT TYPE="hidden" name="remark" value="<%=remark%>">
<INPUT TYPE="hidden" name="sSaveName" value="<%=sSaveName%>">
<INPUT TYPE="hidden" name="filename" value="<%=filename%>">
<INPUT TYPE="hidden" name="seled" value="<%=seled%>">

</form>
</body></html>
