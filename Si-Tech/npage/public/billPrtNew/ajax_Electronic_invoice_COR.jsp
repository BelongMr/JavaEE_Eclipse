<%
/********************
 -->>描述创建人、时间、模块的功能
 -------------------------创建-----------何敬伟(hejwa) 2016/11/18 11:13:41-------------------
 
 -------------------------后台人员：--------------------------------------------
********************/
%>

<%@ page contentType="text/html;charset=GB2312"%>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%@ page import="com.sitech.boss.pub.util.*"%>

<%

	String retCode = "";
	String retMsg  = "";
try{	
	String workNo = (String)session.getAttribute("workNo");
	String nopass = (String)session.getAttribute("password");
	String workname = (String)session.getAttribute("workName");
  String org_code = (String)session.getAttribute("orgCode");
  String printNote = "0";
	String groupId = (String)session.getAttribute("groupId");
	String[][] favInfo = (String[][])session.getAttribute("favInfo");   //数据格式为String[0][0]---String[n][0]
	int infoLen = favInfo.length;
    String tempStr = null;
    for (int i = 0; i < infoLen; i++) {
        tempStr = (favInfo[i][0]).trim();
        if (tempStr.equals("a092")) printNote = "1";
    }
    //路由
	String regionCode = org_code.substring(0,2);
	 String s_kpxm = request.getParameter("s_kpxm");
	String s_ghmfc  = request.getParameter("s_ghmfc");
	String s_jsheje  = request.getParameter("s_jsheje");
 
 
	String s_hsbz = request.getParameter("s_hsbz");
 
	String s_xmje  = request.getParameter("s_xmje");
 
	String payaccept = WtcUtil.repNull(request.getParameter("payaccept"));
	String op_code= WtcUtil.repNull(request.getParameter("op_code"));
	String phone_no= WtcUtil.repNull(request.getParameter("phone_no"));
	String pay_note= WtcUtil.repNull(request.getParameter("pay_note"));
	String id_no= WtcUtil.repNull(request.getParameter("id_no"));
	String sm_code= WtcUtil.repNull(request.getParameter("sm_code"));
	String s_xmmc= WtcUtil.repNull(request.getParameter("s_xmmc"));
	String xmdw= WtcUtil.repNull(request.getParameter("xmdw"));
	String s_ggxh= WtcUtil.repNull(request.getParameter("s_ggxh"));
	String xmsl= WtcUtil.repNull(request.getParameter("xmsl"));
	String hsbz= WtcUtil.repNull(request.getParameter("s_hsbz"));
	String s_xmdj= WtcUtil.repNull(request.getParameter("s_xmdj"));
	String s_sl= WtcUtil.repNull(request.getParameter("s_sl"));
	String s_se= WtcUtil.repNull(request.getParameter("s_se"));
	String chbz= WtcUtil.repNull(request.getParameter("chbz"));
	String old_accept= WtcUtil.repNull(request.getParameter("old_accept"));
	String old_ym= WtcUtil.repNull(request.getParameter("old_ym"));
	String contract_no= WtcUtil.repNull(request.getParameter("contract_no"));
	String kphjje= WtcUtil.repNull(request.getParameter("kphjje"));
	String hjbhsje= WtcUtil.repNull(request.getParameter("hjbhsje"));
	String hjse= WtcUtil.repNull(request.getParameter("hjse"));
	String contractno =  WtcUtil.repNull(request.getParameter("contractno"));
	String returnPage = WtcUtil.repNull(request.getParameter("returnPage"));
	System.out.println("returnPage=="+returnPage);
	String[] inPara_sj = new String[30];

	String s_e_accept="";
	String s_dz_fphm="";
	String s_dz_fpdm="";
	String s_loginaccept =  WtcUtil.repNull(request.getParameter("s_loginaccept"));
	String s_opCode =  WtcUtil.repNull(request.getParameter("s_opCode"));
	String s_old_ret_code="";
	String s_old_number = "";
	String s_old_code = "";
	String s_old_accept = "";
	//String s_qry_flag=WtcUtil.repNull(request.getParameter("s_qry_flag"));;//for yanpx 1=不用查询 2=需要调用接口查询
	s_old_number= WtcUtil.repNull(request.getParameter("s_old_number"));
	s_old_code= WtcUtil.repNull(request.getParameter("s_old_code"));
	s_old_accept= WtcUtil.repNull(request.getParameter("s_old_accept"));
	
	String parm11215= WtcUtil.repNull(request.getParameter("parm11215"));


		System.out.println("-------billnew---------old_accept------bs_sEInvIssue--------->"+old_accept);

	
	System.out.println("eeeeeeeeeeeeeeeeeeeeeeeeeeeeffffffffffffffffffffffffff s_old_number is "+s_old_number+" and s_old_code is "+s_old_code+" and s_old_accept is "+s_old_accept);
	String file_name="testtes1";//写死的
	inPara_sj[0]=payaccept;
	inPara_sj[1]="01";
	inPara_sj[2]=op_code;
	inPara_sj[3]=workNo;
	inPara_sj[4]=nopass;
	inPara_sj[5]=phone_no;
	inPara_sj[6]="";
	inPara_sj[7]=pay_note;
	inPara_sj[8]=new java.text.SimpleDateFormat("yyyyMMdd HH:mm:ss").format(new java.util.Date());//操作时间
	inPara_sj[9]=id_no;
	inPara_sj[10]=sm_code;
	inPara_sj[11]="e";
	inPara_sj[12]=s_old_code;
	inPara_sj[13]=s_old_number;
	inPara_sj[14]=s_xmmc;
	inPara_sj[15]=xmdw;
	inPara_sj[16]=s_ggxh;
	inPara_sj[17]=xmsl;
	inPara_sj[18]=hsbz;
	inPara_sj[19]=s_xmdj;
	inPara_sj[20]=s_sl;
	inPara_sj[21]=s_se;//
	inPara_sj[22]=chbz;
	inPara_sj[23]=old_accept;
	inPara_sj[24]=old_ym;
	inPara_sj[25]=contractno;
	inPara_sj[26]=kphjje;
	inPara_sj[27]=hjbhsje;//
	inPara_sj[28]=hjse;
	inPara_sj[29]=(String)session.getAttribute("orgCode");
	
	for(int i=0;i<inPara_sj.length;i++){
		System.out.println("-------billnew---------inPara_sj["+i+"]---------------->"+inPara_sj[i]);
	}
%>	 
 <wtc:service name="bs_sEInvIssue" routerKey="region" routerValue="<%=regionCode%>" retcode="sCodes1" retmsg="sMsgs1" outnum="6"  >
		<wtc:param value="<%=inPara_sj[0]%>"/>
		<wtc:param value="<%=inPara_sj[1]%>"/>
		<wtc:param value="<%=inPara_sj[2]%>"/>
		<wtc:param value="<%=inPara_sj[3]%>"/>
		<wtc:param value="<%=inPara_sj[4]%>"/>
		<wtc:param value="<%=inPara_sj[5]%>"/>
		<wtc:param value="<%=inPara_sj[6]%>"/>
		<wtc:param value="<%=inPara_sj[7]%>"/>
		<wtc:param value="<%=inPara_sj[8]%>"/>
		<wtc:param value="<%=inPara_sj[9]%>"/>
		<wtc:param value="<%=inPara_sj[10]%>"/>
		<wtc:param value="<%=inPara_sj[11]%>"/>
		<wtc:param value="<%=inPara_sj[12]%>"/>
		<wtc:param value="<%=inPara_sj[13]%>"/>
		<wtc:param value="<%=inPara_sj[14]%>"/>
		<wtc:param value="<%=inPara_sj[15]%>"/>
		<wtc:param value="<%=inPara_sj[16]%>"/>
		<wtc:param value="<%=inPara_sj[17]%>"/>
		<wtc:param value="<%=inPara_sj[18]%>"/>
		<wtc:param value="<%=inPara_sj[19]%>"/>
		<wtc:param value="<%=inPara_sj[20]%>"/>
		<wtc:param value="<%=inPara_sj[21]%>"/>
		<wtc:param value="<%=inPara_sj[22]%>"/>
		<wtc:param value="<%=old_accept%>"/>
		<wtc:param value="<%=inPara_sj[24]%>"/>
		<wtc:param value="<%=inPara_sj[25]%>"/>
		<wtc:param value="<%=inPara_sj[26]%>"/>
		<wtc:param value="<%=inPara_sj[27]%>"/>
		<wtc:param value="<%=inPara_sj[28]%>"/>
		<wtc:param value="<%=inPara_sj[29]%>"/>	
	</wtc:service>
	<wtc:array id="bill_cancel" scope="end"/>
<%


	
		retCode = sCodes1;
		retMsg  = "服务bs_sEInvIssue："+sMsgs1;
	
	
		if(("000000").equals(sCodes1)) {
						s_e_accept=bill_cancel[0][3];
						s_dz_fphm=bill_cancel[0][4];
						s_dz_fpdm=bill_cancel[0][5];
			
			%>
			<wtc:service name="bs_sEInvCancel" routerKey="region" routerValue="<%=regionCode%>" retcode="sCodes" retmsg="sMsgs" outnum="2" >
				<wtc:param value="<%=inPara_sj[0]%>"/>
				<wtc:param value="<%=inPara_sj[1]%>"/>
				<wtc:param value="<%=inPara_sj[2]%>"/>
				<wtc:param value="<%=inPara_sj[3]%>"/>
				<wtc:param value="<%=inPara_sj[4]%>"/>
				<wtc:param value="<%=inPara_sj[5]%>"/>
				<wtc:param value="<%=inPara_sj[6]%>"/>
				<wtc:param value="<%=inPara_sj[7]%>"/>
				<wtc:param value="<%=inPara_sj[8]%>"/>
				<wtc:param value="<%=inPara_sj[9]%>"/>
				<wtc:param value="<%=inPara_sj[10]%>"/>
				<wtc:param value="<%=inPara_sj[11]%>"/>
				<wtc:param value="<%=s_dz_fphm%>"/>
				<wtc:param value="<%=s_dz_fpdm%>"/>
				<wtc:param value="<%=inPara_sj[14]%>"/>
				<wtc:param value="<%=inPara_sj[15]%>"/>
				<wtc:param value="<%=inPara_sj[16]%>"/>
				<wtc:param value="<%=inPara_sj[17]%>"/>
				<wtc:param value="<%=inPara_sj[18]%>"/>
				<wtc:param value="<%=inPara_sj[19]%>"/>
				<wtc:param value="<%=inPara_sj[20]%>"/>
				<wtc:param value="<%=inPara_sj[21]%>"/>
				<wtc:param value="<%=inPara_sj[22]%>"/>
				<wtc:param value="<%=inPara_sj[23]%>"/>
				<wtc:param value="<%=inPara_sj[24]%>"/>
				<wtc:param value="<%=inPara_sj[25]%>"/>
				<wtc:param value="<%=inPara_sj[26]%>"/>
				<wtc:param value="<%=inPara_sj[27]%>"/>
				<wtc:param value="<%=inPara_sj[28]%>"/>
				<wtc:param value="<%=s_e_accept%>"/>
			</wtc:service>
			<wtc:array id="qx_cancel" scope="end"/>
			<%
			 	retCode = sCodes;
			  retMsg  = "服务bs_sEInvCancel："+sMsgs;
		 }
	

	
	System.out.println("--冲正发票----调用服务 bs_sEInvIssue 成功后调服务 bs_sEInvCancel---billnew---");
	System.out.println(retCode+"------retCode-------billnew---------retMsg------>"+retMsg);
		retMsg = retMsg.replaceAll("\"","”");
}catch(Exception e){
	e.printStackTrace();
	retCode = "BILL005";
	retMsg  = "调用服务出错";
	
	System.out.println(retCode+"------retCode-------billnew---------retMsg------>"+retMsg);
}			
%>

 
var response = new AJAXPacket();
response.data.add("retCode","<%=retCode%>");
response.data.add("retMsg","<%=retMsg%>");
core.ajax.receivePacket(response);
	