<%
/********************
 version v2.0
������: si-tech
********************/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>

<!-- **** ningtn add for pos @ 20100409 ******���ؽ��пؼ�ҳ BankCtrl ******** -->
<%@ include file="/npage/public/posCCB.jsp" %>
<!-- **** ningtn add for pos @ 20100409 ******���ع��пؼ�ҳ KeeperClient ******** -->
<%@ include file="/npage/public/posICBC.jsp" %>

<%
	//String[][] result = new String[][]{};
	//SPubCallSvrImpl impl = new SPubCallSvrImpl();

	//ArrayList retArray = new ArrayList();


	//ArrayList arr = (ArrayList)session.getAttribute("allArr");
	//String[][] baseInfo = (String[][])arr.get(0);
	//String[][] agentInfo = (String[][])arr.get(2);
	//String work_no = baseInfo[0][2];
	//String work_name = baseInfo[0][3];
	//String org_code = baseInfo[0][16];
	//String[][] password1 = (String[][])arr.get(4);//��ȡ��������
	//String pass = password1[0][0];
	//String ip_Addr = agentInfo[0][2];

		String work_no =(String)session.getAttribute("workNo");
		String work_name =(String)session.getAttribute("workName");
		String org_code =(String)session.getAttribute("orgCode");
		String regionCode = org_code.substring(0,2);
		String ip_Addr =(String)session.getAttribute("ip_Addr");
		String pass = (String)session.getAttribute("password");
		String opName="Ԥ�滰���Żݹ�������";

		String cust_name=request.getParameter("cust_name");
		String sum_money=request.getParameter("sum_money");
		String prepay_fee=request.getParameter("limit_pay");
		String sale_name=request.getParameter("sale_name");
		String card_info=request.getParameter("");
		String card_money=request.getParameter("");
		String machine_type=request.getParameter("machine_type");
		String op_code=request.getParameter("op_code");
		String paraAray[] = new String[23];

		///////<!-- ningtn add for pos start @ 20100409 -->
		String payType				 = request.getParameter("payType");/**�ɷ����� payType=BX �ǽ��� payType=BY �ǹ���**/
		String MerchantNameChs = request.getParameter("MerchantNameChs");/**�Ӵ˿�ʼ����Ϊ���в���**/
		String MerchantId      = request.getParameter("MerchantId");
		String TerminalId      = request.getParameter("TerminalId");
		String IssCode         = request.getParameter("IssCode");
		String AcqCode         = request.getParameter("AcqCode");
		String CardNo          = request.getParameter("CardNo");
		String BatchNo         = request.getParameter("BatchNo");
		String Response_time   = request.getParameter("Response_time");
		String Rrn             = request.getParameter("Rrn");
		String AuthNo          = request.getParameter("AuthNo");
		String TraceNo         = request.getParameter("TraceNo");
		String Request_time    = request.getParameter("Request_time");
		String CardNoPingBi    = request.getParameter("CardNoPingBi");
		String ExpDate         = request.getParameter("ExpDate");
		String Remak           = request.getParameter("Remak");
		String TC              = request.getParameter("TC");
		String TVprice         = request.getParameter("TVprice");
		String isNextDay       = request.getParameter("isNextDay");
		
		System.out.println("payType : " + payType);
		System.out.println("MerchantNameChs : " + MerchantNameChs);
		System.out.println("MerchantId : " + MerchantId);
		System.out.println("Response_time : " + Response_time);
		System.out.println("TerminalId : " + TerminalId);
		System.out.println("Request_time : " + Request_time);
		System.out.println("Rrn : " + Rrn);
		///////<!-- ningtn add for pos end @ 20100409 -->

		paraAray[0] =request.getParameter("login_accept");
		paraAray[1] = request.getParameter("phone_no");
		paraAray[2] = request.getParameter("opcode");
		paraAray[3] = work_no;
		paraAray[4] = request.getParameter("backaccept");
		paraAray[5] = request.getParameter("opNote");
///////<!-- ningtn add for pos start @ 20100409 -->
		paraAray[6]  = payType				 ;
		paraAray[7]  = MerchantNameChs ;
		paraAray[8]  = MerchantId      ;
		paraAray[9]  = TerminalId      ;
		paraAray[10] = IssCode         ;
		paraAray[11] = AcqCode         ;
		paraAray[12] = CardNo          ;
		paraAray[13] = BatchNo         ;
		paraAray[14] = Response_time   ;
		paraAray[15] = Rrn             ;
		paraAray[16] = AuthNo          ;
		paraAray[17] = TraceNo         ;
		paraAray[18] = Request_time    ;
		paraAray[19] = CardNoPingBi    ;
		paraAray[20] = ExpDate         ;
		paraAray[21] = Remak           ;
		paraAray[22] = TC              ;
///////<!-- ningtn add for pos end @ 20100409 -->


	//String[] ret = impl.callService("s1142Cfm",paraAray,"2","region",org_code.substring(0,2));
	//int errCode = impl.getErrCode();
	//String errMsg = impl.getErrMsg();
%>
			<wtc:service name="s1142Cfm" routerKey="regionCode" routerValue="<%=regionCode%>"  retcode="errCode" retmsg="errMsg"  outnum="2" >
				<wtc:param value="<%=paraAray[0]%>"/>
				<wtc:param value="01"/>
				<wtc:param value="<%=paraAray[2]%>"/>
				<wtc:param value="<%=paraAray[3]%>"/>
				<wtc:param value="<%=pass%>"/>  
				<wtc:param value="<%=paraAray[1]%>"/>
				<wtc:param value=""/>
	    	<wtc:param value="<%=paraAray[4]%>"/>
	    	<wtc:param value="<%=paraAray[5]%>"/>
	    	<wtc:param value="<%=paraAray[6]%>"/>
	    	<wtc:param value="<%=paraAray[7]%>"/>
	    	<wtc:param value="<%=paraAray[8]%>"/>
	    	<wtc:param value="<%=paraAray[9]%>"/>
	    	<wtc:param value="<%=paraAray[10]%>"/>
	    	<wtc:param value="<%=paraAray[11]%>"/>
	    	<wtc:param value="<%=paraAray[12]%>"/>
	    	<wtc:param value="<%=paraAray[13]%>"/>
	    	<wtc:param value="<%=paraAray[14]%>"/>
	    	<wtc:param value="<%=paraAray[15]%>"/>
	    	<wtc:param value="<%=paraAray[16]%>"/>
	    	<wtc:param value="<%=paraAray[17]%>"/>
	    	<wtc:param value="<%=paraAray[18]%>"/>
	    	<wtc:param value="<%=paraAray[19]%>"/>
	    	<wtc:param value="<%=paraAray[20]%>"/>
	    	<wtc:param value="<%=paraAray[21]%>"/>
	    	<wtc:param value="<%=paraAray[22]%>"/>
			</wtc:service>
			<wtc:array id="result1" scope="end" />

<%
if(errCode.equals("0")||errCode.equals("000000")){
%>
	<script language="javascript">
		/*** ningtn add for pos start @ 20100409 *****/
		if("<%=payType%>"=="BX" && "<%=isNextDay%>" == "0"){
			BankCtrl.TranOK();
		}
		if("<%=payType%>"=="BY" && "<%=isNextDay%>" == "0"){
			var IfSuccess = KeeperClient.UpdateICBCControlNum();
		}
		/*** ningtn add for pos end  @ 20100409 *****/
	</script>
<%
}
System.out.println("%%%%%%%����ͳһ�Ӵ���ʼ%%%%%%%%");
		String retCodeForCntt = errCode ;
		String loginAccept ="";

		if(errCode.equals("0")||errCode.equals("000000")){
		if(result1.length>0){
		loginAccept=request.getParameter("login_accept");
		}
		}

		String url = "/npage/contact/upCnttInfo.jsp?opCode="+paraAray[2] +"&retCodeForCntt="+errCode+"&opName="+opName+"&workNo="+work_no+"&loginAccept="+loginAccept+"&pageActivePhone="+paraAray[1]+"&retMsgForCntt="+errMsg+"&opBeginTime="+opBeginTime;
		System.out.println("url="+url);


		%>
		<jsp:include page="<%=url%>" flush="true" />
		<%
System.out.println("%%%%%%%����ͳһ�Ӵ�����%%%%%%%%");

	       if(errCode.equals("0")||errCode.equals("000000")){
          System.out.println("���÷���s1142Cfm in f1142Cfm.jsp �ɹ�@@@@@@@@@@@@@@@@@@@@@@@@@@");

 //__________________________________________

					//S1100View callView = new S1100View();

					//String chinaFee = ((String[][])(callView.view_sToChinaFee(Pub_lxd.formatNumber(sum_money,2)).get(0)))[0][2];//��д���

					String smalldata=(WtcUtil.formatNumber(sum_money,2));    //2008.09.04   add by liutong
					String chinaFee="";
						%>

						<wtc:service name="sToChinaFee" routerKey="regionCode" routerValue="<%=regionCode%>"  retcode="ret_code1" retmsg="errMsg1"  outnum="3" >
			          <wtc:param value="<%=smalldata%>"/>
						</wtc:service>
						<wtc:array id="result" scope="end" />


						<%
						 if(ret_code1.equals("0")||ret_code1.equals("000000")){
				          System.out.println("���÷���s1104Cfm in f1104_2.jsp �ɹ�@@@@@@@@@@@@@@@@@@@@@@@@@@");

				 	       	if(result.length!=0){
				 	       	  chinaFee=result[0][2];
				 	       	  	%>
											<script language="JavaScript">
											   rdShowMessageDialog("�ύ�ɹ�! ���潫��ӡ��Ʊ��");
											   var infoStr="";
											   infoStr+="<%=work_no%>  <%=work_name%>"+"       Ԥ�滰���Żݹ�������"+"|";//����
											   infoStr+='<%=new java.text.SimpleDateFormat("yyyy", Locale.getDefault()).format(new java.util.Date())%>'+"|";
											   infoStr+='<%=new java.text.SimpleDateFormat("MM", Locale.getDefault()).format(new java.util.Date())%>'+"|";
											   infoStr+='<%=new java.text.SimpleDateFormat("dd", Locale.getDefault()).format(new java.util.Date())%>'+"|";
											   infoStr+='<%=cust_name%>'+"|";
											   infoStr+=" "+"|";
											   infoStr+='<%=paraAray[1]%>'+"|";
											   infoStr+=" "+"|";//Э�����
											   infoStr+="�ֻ��ͺţ�"+"<%=machine_type%>"+"|";//�ֻ��ͺ�
											   infoStr+="<%=chinaFee%>"+"|";//�ϼƽ��(��д)
											   infoStr+="<%=WtcUtil.formatNumber(sum_money,2)%>"+"|";//Сд
											   infoStr+="�˿�ϼƣ�  <%=sum_money%>"+
													 "Ԫ����Ԥ�滰�ѣ� <%=prepay_fee%>"+
													 "Ԫ���ֻ����ӹ��ܷѣ�<%=TVprice%>"+"Ԫ|";
													 


												 infoStr+="<%=work_name%>"+"|";//��Ʊ��
												 infoStr+=" "+"|";//�տ���
												 
												 
													 /**** ningtn add for pos start @ 20100409 ****/
													 if("<%=payType%>"=="BX"||"<%=payType%>"=="BY"){
													 		infoStr+=" "+"|";/*ռλ��15������*/
													 		infoStr+=" "+"|";/*ռλ��16������*/
													 		infoStr+="<%=payType%>"+"|";
														 	infoStr+="<%=MerchantNameChs%>"+"|";
															infoStr+="<%=CardNoPingBi   %>"+"|";
															infoStr+="<%=MerchantId     %>"+"|";
															infoStr+="<%=BatchNo        %>"+"|";
															infoStr+="<%=IssCode        %>"+"|";
															infoStr+="<%=TerminalId     %>"+"|";
															infoStr+="<%=AuthNo         %>"+"|";
															infoStr+="<%=Response_time  %>"+"|";
															infoStr+="<%=Rrn            %>"+"|";
															infoStr+="<%=TraceNo        %>"+"|";
															infoStr+="<%=AcqCode        %>"+"|";
													 }
													 /**** ningtn add for pos end  @ 20100409****/
												 
											  // location="/page/s1210/chkPrint.jsp?retInfo="+infoStr+"&dirtPage=/page/s1775/f1775_1.jsp";
											  var dirtPage="/npage/s1141/f1141_login.jsp?activePhone=<%=paraAray[1]%>%26opCode=<%=op_code%>";
											  // location="/npage/public/hljBillPrint.jsp?retInfo="+infoStr+"&dirtPage="+dirtPage;
											    location="/npage/public/hljBillPrintNew.jsp?retInfo="+infoStr+"&dirtPage="+dirtPage+"&op_code=1142&loginAccept=<%=loginAccept%>";
											</script>
									<%


				 	       	}

				 	     	}else{
				 			System.out.println("���÷���s1104Cfm in f1104_2.jsp ʧ��@@@@@@@@@@@@@@@@@@@@@@@@@@");
				 			}


					System.out.print(chinaFee);



 //__________________________________________





 	     	}else{
 			System.out.println("���÷���s1142Cfm in f1142Cfm.jsp ʧ��@@@@@@@@@@@@@@@@@@@@@@@@@@");

				 	if (errCode.equals("0")||errCode.equals("000000") )
					{
					}else{
				%>
				<script language="JavaScript">
					rdShowMessageDialog("Ԥ�滰���Żݹ�������ʧ��!(<%=errMsg%>");
					window.location="f1141_login.jsp?activePhone=<%=paraAray[1]%>&opCode=<%=op_code%>";
				</script>
				<%}



 			}

%>



