<%
/********************
 * version v2.0
 * 开发商: si-tech
 * update by hejw @ 2009-01-15 界面改造
 * update by qidp @ 2009-06-15 整合端到端流程
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

    String iLoginAccept    = request.getParameter("login_accept");     //操作流水号
    String iOpCode         = request.getParameter("op_code");          //操作代码
    String opName		   = (String)request.getParameter("opName");   //模块名称
    String iWorkNo         = request.getParameter("WorkNo");           //操作员工号
    String iLogin_Pass     = request.getParameter("NoPass");           //操作员密码
    String iOrgCode        = request.getParameter("OrgCode");          //操作员机构代码
    String iSys_Note       = request.getParameter("sysnote");          //系统操作备注
    String iOp_Note        = request.getParameter("tonote");           //用户操作备注
    String iIpAddr         = request.getParameter("ip_Addr");          //操作员IP地址
    String iGrp_Id         = request.getParameter("grp_id");           //集团用户ID
    //String delMemFlag      = "1";           						   //删除成员标志(0:不删除， 1：删除)
    String delMemFlag      = "0";           						   //删除成员标志(0:不删除， 1：删除)
    String iAccId			=request.getParameter("acc_id");
    String iBackPrepay		=request.getParameter("grpbackprepay");
    
    System.out.println("---liujian3096---iAccId=" + iAccId + "---iBackPrepay=" + iBackPrepay);
    /******* add by qidp @ 2009-06-15 整合端到端流程 *******/
    
    /**************
     * 预销服务 s3096Cfm 增加以下三个参数。
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
  	/*begin add 预销恢复提交服务 by diling@2012/5/14 */
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
            rdShowMessageDialog("参数错误op_code!!",0);
            history.go(-1);
        </script>
  	
<%
  	}
    
    if(error_code.equals("000000") && "3523".equals(iOpCode) && "APN产品销户第二天生效!".equals(error_msg))
    {
%>
        <script language='jscript'>
            rdShowMessageDialog("成功!APN产品销户第2天生效,注意在集团业务查询页面查询状态!",2);
            removeCurrentTab();
        </script>
<%  }
	else if(error_code.equals("000000") && "3523".equals(iOpCode))
	{
%>
		<script language='jscript'>
            rdShowMessageDialog("集团用户销户操作成功！",2);
            removeCurrentTab();
        </script>

<%
	}
	/*begin add by diling@2012/5/14*/
	else if(error_code.equals("000000") && "e844".equals(iOpCode))
	{
%>
		<script language='jscript'>
            rdShowMessageDialog("集团用户销户恢复操作成功！",2);
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
        rdShowMessageDialog("集团用户预销操作成功！",2);
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
