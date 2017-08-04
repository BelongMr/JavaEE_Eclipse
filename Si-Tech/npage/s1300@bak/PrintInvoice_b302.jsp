<%
    /********************
     version v2.0
     开发商: si-tech
     *
     *update:zhanghonga@2008-08-19 页面改造,修改样式
     *
     ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.sitech.boss.pub.util.*"%>

<%
	//20100528 liuxmc 添加发票防伪码
		java.util.Random r = new java.util.Random();
		int ran = r.nextInt(9999);
		int ran1 = r.nextInt(10)*1000;
		if((ran+"").length()<4){
			ran = ran+ran1;
		}
		int key = 99999;
		int realKey = ran ^ key;
		System.out.println("realKey："+realKey);
		
		String bill_type = "2";
	/////////////////////////////////
	
	// 20090421 liyan 根据张怀韬申告要求，将备注字段打印开始列更改为5.
    String contractno = request.getParameter("contractno");
    String workNo = request.getParameter("workno");
    String payAccept = request.getParameter("payAccept");
    String total_date = request.getParameter("total_date");
    String op_code = "b301";
    String smphoneNo = request.getParameter("phoneNo");
    System.out.println("phoneNo==="+smphoneNo);
    String[][] favInfo = (String[][])session.getAttribute("favInfo");   //数据格式为String[0][0]---String[n][0]
    String workname = (String)session.getAttribute("workName");
    String org_code = (String)session.getAttribute("orgCode");
    String printNote = "0";
    int infoLen = favInfo.length;
    String tempStr = null;
    for (int i = 0; i < infoLen; i++) {
        tempStr = (favInfo[i][0]).trim();
        if (tempStr.equals("a092")) printNote = "1";
    }
    String regionCode = org_code.substring(0,2);

    String print_note = "0";

    String smop_code = request.getParameter("opCode");
    System.out.println("smop_code=" + smop_code);
    String sm_name = "";
    if (smop_code == null || smop_code == "") {
        smop_code = "0000";
    }
    if (smop_code.equals("b301")) {
    //    String smSql = "select decode(sm_code,'zn','神州行','gn','全球通','dn','动感地带') from dcustmsg where phone_no= '" + smphoneNo + "' and substr(run_code,2,1)<'a'";
	String[] inParam = new String[2];
	inParam[0] ="select decode(sm_code,'zn','神州行','gn','全球通','dn','动感地带') from dcustmsg where phone_no=: smphoneNo  and substr(run_code,2,1)<'a'";
	inParam[1] = "smphoneNo="+smphoneNo;
%>
	<wtc:service name="TlsPubSelCrm"  outnum="1" >
		<wtc:param value="<%=inParam[0]%>"/>
		<wtc:param value="<%=inParam[1]%>"/>
	</wtc:service>
	<wtc:array id="sm_name_arr" scope="end" />
<%
				if(sm_name_arr!=null&&sm_name_arr.length>0){
        	sm_name = "品牌:" + sm_name_arr[0][0];
        }

        if (printNote.equals("0")) {
            print_note = "0";
        } else {
            print_note = request.getParameter("print_note");
        }
    }
    String returnPage = "b301.jsp";
    if (request.getParameter("returnPage") != null) {
        returnPage = request.getParameter("returnPage");
    }

    String printtype = "0";
    if (request.getParameter("printtype") != null) {
        printtype = request.getParameter("printtype");
    }


    String year = total_date.substring(0, 4);
    String month = total_date.substring(4, 6);
    String day = total_date.substring(6, 8);

    String[] inParas = new String[4];
    inParas[0] = workNo;
    inParas[1] = contractno;
    inParas[2] = total_date;
    inParas[3] = payAccept;

    //CallRemoteResultValue value = viewBean.callService("1", org_code.substring(0, 2), "s1300Print", "17", inParas);
%>

	<wtc:service name="s1300Print" routerKey="phone" routerValue="<%=smphoneNo%>" outnum="33" >
		<wtc:param value="<%=inParas[0]%>"/>
		<wtc:param value="<%=inParas[1]%>"/>
		<wtc:param value="<%=inParas[2]%>"/>
		<wtc:param value="<%=inParas[3]%>"/>
	</wtc:service>
	<wtc:array id="result" scope="end"/>
		
<%
		
		
		String return_code = "999999";
		String temp[]=new String[10];
		String info=new String();
		int record=0;
		if(result!=null&&result.length>0){
			 return_code = result[0][0];
		
			
		   
		   
		}

    String error_msg = SystemUtils.ISOtoGB(ErrorMsg.getErrorMsg(return_code));
	System.out.println("return_code===="+return_code);
    if (return_code.equals("000000")) {
    		String phoneNo = "";
    		if(result!=null&&result.length>0){
		    		phoneNo = result[0][5].trim();
		        if (phoneNo.equals("99999999999")){
		            phoneNo = "";
		        }
	
		   int length1=result[0][16].length();
			 if(length1>0)
			 {
			 int size=60;
			 System.out.println("-------------------------"+result[0][16].length());
			 info=result[0][16].trim();
			 System.out.println("-------------------------"+result[0][16]);
			 record=length1/size;
			 System.out.println("-------------------------"+record);
			 for(int j=0;j<=record;j++)
			 {
			 if(info.length()>=size)
			 {
			 temp[j]=info.substring(0,size);
		   info=info.substring(size);
		   }
		   else
		   temp[j]=info;
		   System.out.println("-------------------------"+j+"  "+temp[j]);
		   
		   
		  
		   }
		   }
%>
<html>
<META http-equiv=Content-Type content="text/html; charset=GBK">
<SCRIPT language="JavaScript">
    function printInvoice()
    {
        printctrl.Setup(0);
        printctrl.StartPrint();
        printctrl.PageStart();
        /*20100528 liuxmc 添加发票防伪码*/
		//new begin
		printctrl.Print(20, 10, 9, 0, "<%=year+month+day%>");
		printctrl.Print(50, 10, 9, 0, "邮电通信业");
        /*******************************************/
        printctrl.Print(13, 12, 9, 0, "防伪码：<%=ran%>");

		printctrl.Print(13, 13, 9, 0, "工    号：<%=workNo%>");

        printctrl.Print(40, 13, 9, 0, "操作流水：<%=result[0][15]%>");
		printctrl.Print(63, 13, 9, 0, "业务名称：<%=result[0][2]%>");
		printctrl.Print(13, 14, 9, 0, "客户名称：<%=result[0][4]%>");
		printctrl.Print(63, 14, 9, 0, "卡    号："); 
		printctrl.Print(13, 15, 9, 0, "手机号码：<%=result[0][5]%>");
		
		printctrl.Print(33, 15, 9, 0, "<%=sm_name%>");

		printctrl.Print(40, 15, 9, 0, "协议号码：<%=result[0][6]%>");
        printctrl.Print(63, 15, 9, 0, "支票号码：<%=result[0][7]%>");

        printctrl.Print(13, 16, 9, 0, "合计金额：(大写)<%=result[0][8]%>");
        printctrl.Print(63, 16, 9, 0, "(小写)￥<%=result[0][9].trim()%>");
		
        printctrl.Print(13, 17, 9, 0, "(项目)");
        printctrl.Print(13, 19, 9, 0, "<%=result[0][11]%>");
        printctrl.Print(13, 20, 9, 0, "<%=result[0][12]%>");
        printctrl.Print(13, 21, 9, 0, "<%=result[0][13]%>");
        printctrl.Print(13, 22, 9, 0, "<%=result[0][14]%>");
		printctrl.Print(13, 30, 10, 0, "开票：<%=workname%>");
		printctrl.Print(37, 30, 10, 0, "收款：");
		printctrl.Print(63, 30, 10, 0, "复核：");
		//new end
		 


     /********tianyang add at 20090928 for POS缴费需求****start*****/
     /* result[0][17] 为 "1"  是pos缴费(冲正) */
     <%if (result[0][17] != null && result[0][17].equals("1")) {%>
	     	printctrl.Print(13, 23, 9, 9, "<%=result[0][18].trim()%>");/*商户名称（中英文)*/
				printctrl.Print(13, 24, 9, 9, "<%=result[0][29].trim()%>");/*交易卡号（屏蔽）*/
				printctrl.Print(43, 24, 9, 9, "<%=result[0][19].trim()%>");/*商户编码*/
				printctrl.Print(69, 24, 9, 9, "<%=result[0][24].trim()%>");/*批次号*/
				printctrl.Print(13, 25, 9, 9, "<%=result[0][21].trim()%>");/*发卡行号*/
				printctrl.Print(43, 25, 9, 9, "<%=result[0][20].trim()%>");/*终端编码*/
				printctrl.Print(69, 25, 9, 9, "<%=result[0][27].trim()%>");/*授权号*/
				printctrl.Print(13, 26, 9, 9, "<%=result[0][25].trim()%>");/*回应日期时间*/
				printctrl.Print(43, 26, 9, 9, "<%=result[0][26].trim()%>");/*参考号*/
				printctrl.Print(69, 26, 9, 9, "<%=result[0][28].trim()%>");/*流水号*/
				printctrl.Print(13, 27, 9, 9, "<%=result[0][22].trim()%>");/*收单行号*/
				printctrl.Print(60, 27, 9, 9, "签字：");
     <%}%>
     /********tianyang add at 20090928 for POS缴费需求****end*******/
     
				//ZLC测试 验证信息
      <% 
      if(length1>0){
       for(int i=0;i<=record;i++)
        {
        %>
        printctrl.Print(13, "<%=(i+21)%>", 9, 0, "<%=temp[i]%>");
        <%
        if(i==record){
        %>
        // printctrl.Print(13,"<%=(i+29)%>", 9, 0, "<%=workname%>");
        <%
        }
        }
        }
      else{
        %>
       // printctrl.Print(13,29, 9, 0, "<%=workname%>");
        <%}%>
        printctrl.PageEnd();
        printctrl.StopPrint();
    }

    function ifprint()
    {
        printInvoice();
        document.location.replace("<%=returnPage%>");
    }
</SCRIPT>

<body onload="ifprint()">
<OBJECT
        classid="clsid:28EE9D9D-1A80-4BFF-B464-0E6B69E26B05"
        codebase="/ocx/printatl.dll#version=1,0,0,1"
        id="printctrl"
        style="DISPLAY: none"
        VIEWASTEXT
        >
</OBJECT>

</body>
</html>

<%
	
	//liuxmc add  发票电子化添加入库服务

		String[] inParas0 = new String[26];
		inParas0[0] = realKey+"";
		inParas0[1] = result[0][15].trim();
		//inParas0[2] = smop_code;
		inParas0[2] = "b302";
    inParas0[3] = workNo;
    inParas0[4] = total_date;
    inParas0[5] = phoneNo;
    inParas0[6] = result[0][6];
    if(sm_name == null || sm_name.trim().length() == 0){
    	sm_name = "品牌：";
    }
    inParas0[7] = sm_name;
    System.out.println("=============sm_name====================="+sm_name);
    inParas0[8] = result[0][8].trim();
    inParas0[9] = result[0][9].trim();
    inParas0[10] = result[0][10].trim();
    inParas0[11] = result[0][11].trim();
    inParas0[12] = result[0][12].trim();
    inParas0[13] = result[0][13].trim();
    inParas0[14] = result[0][14].trim();
    if(result[0][16].trim().length() == 0){
    	result[0][16] = "备注:";
    }
		inParas0[15] = result[0][16].trim();
		
		inParas0[16] = result[0][18].trim();
		inParas0[17] = result[0][19].trim();
		inParas0[18] = result[0][20].trim();
		inParas0[19] = result[0][21].trim();
		inParas0[20] = result[0][22].trim();
		inParas0[21] = result[0][25].trim();
		inParas0[22] = result[0][26].trim();
		inParas0[23] = result[0][27].trim();
		inParas0[24] = result[0][28].trim();
		inParas0[25] = result[0][29].trim();

		System.out.println("====执行 s1300PrintInDB 开始=======");
%>		
		<wtc:service name="s1300PrintInDB" routerKey="region" routerValue="<%=regionCode%>" outnum="2" >
			<wtc:param value="<%=inParas0[0]%>"/>
			<wtc:param value="<%=inParas0[1]%>"/>
			<wtc:param value="<%=inParas0[2]%>"/>
			<wtc:param value="<%=inParas0[3]%>"/>
			<wtc:param value="<%=inParas0[4]%>"/>
			<wtc:param value="<%=inParas0[5]%>"/>
			<wtc:param value="<%=inParas0[6]%>"/>
			<wtc:param value="<%=inParas0[7]%>"/>
			<wtc:param value="<%=inParas0[8]%>"/>
			<wtc:param value="<%=inParas0[9]%>"/>
			<wtc:param value="<%=inParas0[10]%>"/>
			<wtc:param value="<%=inParas0[11]%>"/>
			<wtc:param value="<%=inParas0[12]%>"/>
			<wtc:param value="<%=inParas0[13]%>"/>
			<wtc:param value="<%=inParas0[14]%>"/>
			<wtc:param value="<%=inParas0[15]%>"/>
			<wtc:param value="<%=inParas0[16]%>"/>
			<wtc:param value="<%=inParas0[17]%>"/>
			<wtc:param value="<%=inParas0[18]%>"/>
			<wtc:param value="<%=inParas0[19]%>"/>
			<wtc:param value="<%=inParas0[20]%>"/>
			<wtc:param value="<%=inParas0[21]%>"/>
			<wtc:param value="<%=inParas0[22]%>"/>
			<wtc:param value="<%=inParas0[23]%>"/>
			<wtc:param value="<%=inParas0[24]%>"/>
			<wtc:param value="<%=inParas0[25]%>"/>
		</wtc:service>
		<wtc:array id="RetResult" scope="end"/>
<%
		System.out.println("====执行 s1300PrintInDB 结束=======");
		if(RetResult == null || RetResult.length == 0){
%>
					<script language="JavaScript">
					    rdShowMessageDialog("电子发票入库失败,s1300PrintInDB服务返回结果为空.",0);
					    document.location.replace("<%=returnPage%>");
					</script>
<%			
		}
			
		//////////////////////////////////////////////
				}else{
%>
					<script language="JavaScript">
					    rdShowMessageDialog("发票打印失败,s1300Print服务返回结果为空.<br>请使用补打发票交易打印发票!",0);
					    document.location.replace("<%=returnPage%>");
					</script>
<%
				}
		} else {
%>
		<script language="JavaScript">
		    rdShowMessageDialog("发票打印错误,请使用补打发票交易打印发票!<br>错误代码：'<%=return_code%>'，错误信息：'<%=error_msg%>'",0);
		    document.location.replace("<%=returnPage%>");
		</script>
<%
    }
%>
