<%
/********************
 version v2.0
开发商: si-tech
********************/
%>
<%@ page contentType="text/html;charset=gbk"%>
<%@ page import="com.sitech.boss.spubcallsvr.viewBean.*" %>
<%@ include file="/npage/include/public_title_name.jsp" %>

<!-- **** ningtn add for pos @ 20100408 ******加载建行控件页 BankCtrl ******** -->
<%@ include file="/npage/public/posCCB.jsp" %>
<!-- **** ningtn add for pos @ 20100408 ******加载工行控件页 KeeperClient ******** -->
<%@ include file="/npage/public/posICBC.jsp" %>
<%@ include file="../../npage/bill/getMaxAccept.jsp" %>
<%! /**这个方法是用来格式化后面的小写金额的**/ public static String
          formatNumber(String num, int zeroNum) { DecimalFormat form =
   (DecimalFormat)NumberFormat.getInstance(Locale.getDefault()); StringBuffer
patBuf = new StringBuffer("0"); if(zeroNum > 0) { patBuf.append("."); for(int i
                 = 0; i < zeroNum; i++) { patBuf.append("0"); }

        }
        form.applyPattern(patBuf.toString());
        return form.format(Double.parseDouble(num)).toString();
    }
%>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/common/redialog/redialog.js"></script>
<%
String workNo = (String)session.getAttribute("workNo");
String password = (String)session.getAttribute("password");
String regionCode= (String)session.getAttribute("regCode");
String phoneNo = request.getParameter("phoneNo");	
String iAddStr = WtcUtil.repNull(request.getParameter("iAddStr"));
String ip_Addr = (String)session.getAttribute("ipAddr");
String tonote = request.getParameter("tonote");	
String realcash = WtcUtil.repNull(request.getParameter("i19")); 
String fircash = WtcUtil.repNull(request.getParameter("i20")); 
String favour = WtcUtil.repNull(request.getParameter("favorcode"));
String name = WtcUtil.repNull(request.getParameter("i4")); 
String stream = WtcUtil.repNull(request.getParameter("backaccept"));
//发票需要的参数
String thework_no = (String)session.getAttribute("workNo"); 
%>
		<wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="regioncode" 
			routerValue="<%=regionCode%>"  id="loginAccept" />
		<%
	String work_name = (String)session.getAttribute("workName");
	String brand_code="";
	String type_code="";
	String prepay_fee="";
	String prepay_money="";
	String chinaFee="";
	String xx_money="";
	String IMEINo="";
	String iadd_str=iAddStr;

	int aa=0;
	int bb=0;
	//String aString ="0000000001|200.00|aaaaaa|";
 	for (int i=1; i<13; i++)
	{ 
		aa=iadd_str.indexOf("|",aa+1);
	 //iAddStr格式 原流水|营销代码|机型名称|赠送话费|购机款|	
		//if(i==1){=iadd_str.substring(bb,aa);}
		if(i==2){type_code=iadd_str.substring(bb,aa);}
		if(i==3){brand_code=iadd_str.substring(bb,aa);}
		if(i==4){prepay_fee=iadd_str.substring(bb,aa);}
		if(i==5){prepay_money=iadd_str.substring(bb,aa);}
		bb=aa+1;

	} 
	xx_money=formatNumber(prepay_money,2);
%>
		<wtc:service name="sToChinaFee" routerKey="region" routerValue="<%=regionCode%>" outnum="3" >
		<wtc:param value="<%=xx_money%>"/>
		</wtc:service>
		<wtc:array id="chinaFeeArr" scope="end"/>	
<%
	 if(chinaFeeArr!=null&&chinaFeeArr.length>0){
			chinaFee = chinaFeeArr[0][2];
		}

		%>
			
	<wtc:service name="s8028Cfm" routerKey="region" routerValue="<%=regionCode%>"  retcode="errCode" retmsg="errMsg"  outnum="2" >
	<wtc:param value="<%=loginAccept%>"/>
	<wtc:param value="01"/>
	<wtc:param value="8028"/>
	<wtc:param value="<%=workNo%>"/>
	<wtc:param value="<%=password%>"/>
	<wtc:param value="<%=phoneNo%>"/>
	<wtc:param value=""/>
	<wtc:param value="<%=iAddStr%>"/>
	<wtc:param value="<%=ip_Addr%>"/>
	<wtc:param value="<%=tonote%>"/>
	<wtc:param value="<%=stream%>"/>
		<wtc:param value="<%=type_code%>"/>


	</wtc:service>
		<wtc:array id="ret" scope="end"/>
	<%if (errCode.equals("000000"))
	{
	 System.out.println("s8028Cfm in f8028Cfm.jsp 成功@@@@@@@@@@@@@@@@@@@@@@@@@@");
	%>
  <script language="JavaScript">
   rdShowMessageDialog("提交成功! 下面将打印发票！");
	 var infoStr="";                                                                         
	 infoStr+="<%=thework_no%>  <%=loginAccept%>"+"     买手机，送话费冲正"+"|";//工号                                                 
     	 infoStr+='<%=new java.text.SimpleDateFormat("yyyy", Locale.getDefault()).format(new java.util.Date())%>'+"|";//日期
	 infoStr+='<%=new java.text.SimpleDateFormat("MM", Locale.getDefault()).format(new java.util.Date())%>'+"|";
	 infoStr+='<%=new java.text.SimpleDateFormat("dd", Locale.getDefault()).format(new java.util.Date())%>'+"|";
	 infoStr+='<%=name%>'+"|";//移动号码                                                   
	 infoStr+=" "+"|";//合同号码                                                          
	 infoStr+='<%=phoneNo%>'+"|";//用户名称                                                
	 infoStr+=""+"|";//用户地址
	 infoStr+="手机型号:"+'<%=brand_code%>'+"|";
	 
	 infoStr+="<%=chinaFee%>"+"|";//合计金额(大写)
	 infoStr+="<%=xx_money%>"+"|";//小写 
	
	 infoStr+="缴款合计：  <%=prepay_money%>"+ "元　赠送话费 <%=prepay_fee%>"+ "元"+"|";
	 infoStr+="<%=work_name%>"+"|";//开票人
	 infoStr+=" "+"|";//收款人
	 infoStr+=" "+"|";
	 var dirtPage=""; 
	dirtPate = "/npage/bill/f8027.jsp";
	//location="/npage/public/hljBillPrint.jsp?retInfo="+infoStr+"&dirtPage=/npage/bill/f8027.jsp?activePhone=<%=phoneNo%>%26opCode=8027%26opName=买手机、送话费冲正";
	location="/npage/public/hljBillPrintNew.jsp?retInfo="+infoStr+"&op_code=8028&loginAccept=<%=loginAccept%>&dirtPage=/npage/bill/f8027.jsp?activePhone=<%=phoneNo%>%26opCode=8028%26opName=买手机、送话费冲正";
	</script>
	<%
	}
	
	else{
			 			System.out.println("调用服务s8028Cfm in f8028Cfm.jsp 失败@@@@@@@@@@@@@@@@@@@@@@@@@@");
			 			System.out.println(errCode+"   errCode    "+errMsg+"    errMsg");
						%>
						<script language="JavaScript">
							rdShowMessageDialog("买手机，送话费失败!<%=errMsg%>");
							window.location="f8027.jsp?activePhone=<%=phoneNo%>&opCode=8027";
						</script>
						<%


 			}

	%>
	
