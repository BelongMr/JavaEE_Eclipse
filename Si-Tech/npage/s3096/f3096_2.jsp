<%
/********************
 * version v2.0
 * ������: si-tech
 * update by hejw @ 2009-01-15 �������
 * update by qidp @ 2009-06-15 ���϶˵�������
 ********************/
%>

<%@ page contentType= "text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>  
<%@ page import="org.apache.log4j.Logger"%>

<%
    String error_code = "";
    String error_msg = "";
    String resultArr[][] = new String[][]{};
    Logger logger = Logger.getLogger("f3096_2.jsp");

    String iLoginAccept    = request.getParameter("login_accept");     //������ˮ��
    String iOpCode         = request.getParameter("op_code");          //��������
    String opName		   = (String)request.getParameter("opName");   //ģ������
    String iWorkNo         = request.getParameter("WorkNo");           //����Ա����
    String iLogin_Pass     = request.getParameter("NoPass");           //����Ա����
    String iOrgCode        = request.getParameter("OrgCode");          //����Ա��������
    String iSys_Note       = request.getParameter("sysnote");          //ϵͳ������ע
    String iOp_Note        = request.getParameter("tonote");           //�û�������ע
    String iIpAddr         = request.getParameter("ip_Addr");          //����ԱIP��ַ
    String iGrp_Id         = request.getParameter("grp_id");           //�����û�ID
    //String delMemFlag      = "1";           						   //ɾ����Ա��־(0:��ɾ���� 1��ɾ��)
    String delMemFlag      = "0";           						   //ɾ����Ա��־(0:��ɾ���� 1��ɾ��)
    String iAccId			=request.getParameter("acc_id");
    String iBackPrepay		=request.getParameter("grpbackprepay");
    
    System.out.println("---liujian3096---iAccId=" + iAccId + "---iBackPrepay=" + iBackPrepay);
    /******* add by qidp @ 2009-06-15 ���϶˵������� *******/
    
    /**************
     * Ԥ������ s3096Cfm ������������������
     **************/
    String requestType = "3";
    String chance_id = request.getParameter("chanceId"); 
    String in_str = "";
    /******* end of add *******/

    String iRegion_Code = iOrgCode.substring(0,2);
		if("3096".equals(iOpCode))
		{
    		try
    		{
    			String [] paramsIn = new String[] { iLoginAccept, iOpCode, iWorkNo, iLogin_Pass, iOrgCode, iSys_Note, iOp_Note, iIpAddr, iGrp_Id, delMemFlag };
%>

        <wtc:service name="s3096CfmE" outnum="2" retmsg="msg1" retcode="code1" routerKey="region" routerValue="<%=iRegion_Code%>">
    		<wtc:param value="<%=iLoginAccept%>" />	
    		<wtc:param value="3096" />	
    		<wtc:param value="<%=iWorkNo%>" />	
    		<wtc:param value="<%=iLogin_Pass%>" />	
    		<wtc:param value="<%=iOrgCode%>" />	
    		<wtc:param value="<%=iSys_Note%>" />			
    		<wtc:param value="<%=iOp_Note%>" />	
    		<wtc:param value="<%=iIpAddr%>" />	
    		<wtc:param value="<%=iGrp_Id%>" />	
    		<wtc:param value="<%=delMemFlag%>" />	
    		<wtc:param value="<%=requestType%>" />
    		<wtc:param value="<%=chance_id%>" />
    		<wtc:param value="<%=in_str%>" />
            <wtc:param value="u04" />
			<wtc:param value="<%=iAccId%>" />
			<wtc:param value="<%=iBackPrepay%>" />
    	</wtc:service>
      <wtc:array id="s3096CfmERet"  scope="end"/>
<%

    		  	//retArray = callView.callFXService("s3096Cfm", paramsIn, "1", "region", iRegion_Code);
    		  	error_code = code1;
    		  	error_msg  = msg1;
    		  	resultArr = s3096CfmERet;
    		  	System.out.println("luxc:s3096Cfm"+error_code+error_msg);
    		}
    		catch(Exception e)
    		{
    		    logger.error("Call s3096Cfm is Failed!");
    		}
    }
  	else if ("3523".equals(iOpCode))
  	{
  			try
    		{
    				String [] paramsIn = new String[] { iLoginAccept, iOpCode, iWorkNo, iLogin_Pass, iOrgCode, iSys_Note, iOp_Note, iIpAddr, iGrp_Id, delMemFlag };
    		  	//retArray = callView.callFXService("s3523Cfm", paramsIn, "1", "region", iRegion_Code);

%>

        <wtc:service name="s3523CfmE" outnum="1" retmsg="msg2" retcode="code2" routerKey="region" routerValue="<%=iRegion_Code%>">
    		<wtc:param value="<%=iLoginAccept%>" />	
    		<wtc:param value="<%=iOpCode%>" />	
    		<wtc:param value="<%=iWorkNo%>" />	
    		<wtc:param value="<%=iLogin_Pass%>" />	
    		<wtc:param value="<%=iOrgCode%>" />	
    		<wtc:param value="<%=iSys_Note%>" />			
    		<wtc:param value="<%=iOp_Note%>" />	
    		<wtc:param value="<%=iIpAddr%>" />	
    		<wtc:param value="<%=iGrp_Id%>" />	
    		<wtc:param value="<%=delMemFlag%>" />	
    		<wtc:param value="<%=iAccId%>" />
			<wtc:param value="<%=iBackPrepay%>" />	
			<wtc:param value="<%=chance_id%>" />	
    	</wtc:service>

<%
    		  	error_code = code2;
    		  	error_msg  = msg2;
    		  	System.out.println("luxc:s3523Cfm"+error_code+error_msg);
    		}
    		catch(Exception e)
    		{
    		    logger.error("Call s3523Cfm is Failed!");
    		}
  	}
  	/*begin add Ԥ���ָ��ύ���� by diling@2012/5/14 */
  	else if ("e844".equals(iOpCode))
  	{
  			try
    		{
    				String [] paramsIn = new String[] { iLoginAccept, iOpCode, iWorkNo, iLogin_Pass, iOrgCode, iSys_Note, iOp_Note, iIpAddr, iGrp_Id, delMemFlag };

%>

        <wtc:service name="se844CfmE" outnum="1" retmsg="msg3" retcode="code3" routerKey="region" routerValue="<%=iRegion_Code%>">
    		<wtc:param value="<%=iLoginAccept%>" />	
    		<wtc:param value="<%=iOpCode%>" />	
    		<wtc:param value="<%=iWorkNo%>" />	
    		<wtc:param value="<%=iLogin_Pass%>" />	
    		<wtc:param value="<%=iOrgCode%>" />	
    		<wtc:param value="<%=iSys_Note%>" />			
    		<wtc:param value="<%=iOp_Note%>" />	
    		<wtc:param value="<%=iIpAddr%>" />	
    		<wtc:param value="<%=iGrp_Id%>" />	
    		<wtc:param value="<%=delMemFlag%>" />	
    		<wtc:param value="4" />	
    		<wtc:param value="<%=chance_id%>" />	
    		<wtc:param value="" />	
    		<wtc:param value="u08" />	
    	</wtc:service>

<%
    		  	error_code = code3;
    		  	error_msg  = msg3;
    		  	System.out.println("se844CfmE"+error_code+error_msg);
    		}
    		catch(Exception e)
    		{
    		    logger.error("Call se844CfmE is Failed!");
    		}
  	}
  	/*end add  by diling */
  	else
  	{
%>
				<script language='jscript'>
            rdShowMessageDialog("��������op_code!!",0);
            history.go(-1);
        </script>
  	
<%
  	}
    
    if(error_code.equals("000000") && "3523".equals(iOpCode) && "APN��Ʒ�����ڶ�����Ч!".equals(error_msg))
    {
%>
        <script language='jscript'>
            rdShowMessageDialog("�ɹ�!APN��Ʒ������2����Ч,ע���ڼ���ҵ���ѯҳ���ѯ״̬!",2);
            removeCurrentTab();
        </script>
<%  }
	else if(error_code.equals("000000") && "3523".equals(iOpCode))
	{
%>
		<script language='jscript'>
            rdShowMessageDialog("�����û����������ɹ���",2);
            removeCurrentTab();
        </script>

<%
	}
	/*begin add by diling@2012/5/14*/
	else if(error_code.equals("000000") && "e844".equals(iOpCode))
	{
%>
		<script language='jscript'>
            rdShowMessageDialog("�����û������ָ������ɹ���",2);
            removeCurrentTab();
        </script>
<%
	}
	/*end add by diling*/
	else if(error_code.equals("000000"))
	{
	  if(resultArr!=null&&resultArr.length>0&&resultArr[0][1]!=null){
%>
		<script language='jscript'>
        rdShowMessageDialog("<%=resultArr[0][1]%>",2);
        removeCurrentTab();
    </script>
<%    
	  }else{
%>
		<script language='jscript'>
        rdShowMessageDialog("�����û�Ԥ�������ɹ���",2);
        removeCurrentTab();
    </script>
<%
    }
	}
	else 
	{
%>
        <script language='jscript'>
            rdShowMessageDialog("<%=error_code%>" + "[" + "<%=error_msg%>" + "]" ,0);
            history.go(-1);
        </script>
<%
    }
    
    String url = "/npage/contact/onceCnttInfo.jsp?opCode="+iOpCode+"&retCodeForCntt="+error_code+"&retMsgForCntt="+error_msg
		+"&opName="+opName+"&workNo="+iWorkNo+"&loginAccept="+iLoginAccept+"&pageActivePhone="+""
		+"&opBeginTime="+opBeginTime+"&contactId="+iGrp_Id+"&contactType=grp";
%>
	<jsp:include page="<%=url%>" flush="true" />