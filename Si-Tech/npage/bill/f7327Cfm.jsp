<% /******************** version v2.0 开发商: si-tech * *update:zhanghonga@2008
          -08-19 页面改造,修改样式 * ********************/ %> <%@page
              contentType="text/html;charset=GBK"%> <%@ include
 file="/npage/include/public_title_name.jsp" %> <%@ page import="java.text.*"%>
             <%@ page import="com.sitech.boss.pub.util.*" %> <%/* *
  注：变量的命名依据页面文本域的位置的先后顺序，如第一个文本域为i1，以此类推。
    部分变量的命名依据对此变量使用的意义，或用途。 */ %> <% String opCode2 =
(String)request.getParameter("opCode"); if (opCode2 == null){ opCode2 = "1270";
    } %> <%! /**这个方法是用来格式化后面的小写金额的**/ public static String
          formatNumber(String num, int zeroNum) { DecimalFormat form =
   (DecimalFormat)NumberFormat.getInstance(Locale.getDefault()); StringBuffer
patBuf = new StringBuffer("0"); if(zeroNum > 0) { patBuf.append("."); for(int i
                 = 0; i < zeroNum; i++) { patBuf.append("0"); }

        }
        form.applyPattern(patBuf.toString());
        return form.format(Double.parseDouble(num)).toString();
    }
%>
<HTML>
<head>
</HEAD>
<BODY>
<FORM action="" method=post name="form1">
</FORM>
<BODY>
</HTML>
<%      
/*--------------------------------组织s7327Cfm的传入参数-------------------------------*/
String thework_no = (String)session.getAttribute("workNo");                                   //操作工号                    0  操作工号 iLoginNo                          
String psw =(String)session.getAttribute("password");                                         //工号密码					1  工号密码 iLoginPwd                           
String theop_code = WtcUtil.repNull(request.getParameter("opCode"));                         //操作代码					2  iOpCode                                                                             //登陆IP					    16 登录IP  iIpAddr                            										
String returnPage = WtcUtil.repNull(request.getParameter("return_page"));
String main_card = WtcUtil.repNull(request.getParameter("main_card"));
String mem_num = WtcUtil.repNull(request.getParameter("mem_num"));
String pay_fee = WtcUtil.repNull(request.getParameter("pay_fee"));
String begin_time = WtcUtil.repNull(request.getParameter("begin_time"));
String end_time = WtcUtil.repNull(request.getParameter("end_time"));
String op_flag = WtcUtil.repNull(request.getParameter("op_flag"));
String stream = WtcUtil.repNull(request.getParameter("stream"));       //系统流水												  

/*--------------------------------开始调用s7969Cfm--------------------------------*/
		String paraAray[] = new String[7];			    
		paraAray[0] = main_card; //  家长号码          
		paraAray[1] = mem_num; //     被付费号码         
		paraAray[2] = pay_fee; //     付费金额                       
		paraAray[3] = theop_code; //   op_code       
		paraAray[4] = thework_no; // 操作工号
		paraAray[5] = op_flag; //  操作类型         
		paraAray[6] = stream; //  打印流水   
	for(int i=0;i<paraAray.length;i++){
		System.out.println("paraAray["+i+"]="+paraAray[i]);
	}		
%>		
		<wtc:service name="s7327Cfm" routerKey="phoneNo" routerValue="<%=main_card%>" outnum="3" >
		<wtc:param value="<%=paraAray[0]%>"/>
		<wtc:param value="<%=paraAray[1]%>"/>
		<wtc:param value="<%=paraAray[2]%>"/>
		<wtc:param value="<%=paraAray[3]%>"/>
		<wtc:param value="<%=paraAray[4]%>"/>
		<wtc:param value="<%=paraAray[5]%>"/>
		<wtc:param value="<%=paraAray[6]%>"/>	
		</wtc:service>
		<wtc:array id="result4" scope="end"/>	
<%	
		int ret_code = 999999;	
		if(retCode!=""){
			ret_code = Integer.parseInt(retCode);
		}
        String ret_msg = retMsg;
		System.out.println("ret_code=====222=============="+ret_code);
	
		System.out.println("%%%%%%%调用统一接触开始%%%%%%%%");	
		String cnttLoginAccept = "";
		String opName2 = (String)request.getParameter("opName");
		
		System.out.println("%%%%%%%传入参数 theop_code%%%%%%%%"+theop_code);	
		System.out.println("%%%%%%%传入参数 retCode%%%%%%%%"+retCode);	
		System.out.println("%%%%%%%传入参数 opName2%%%%%%%%"+opName2);	
		System.out.println("%%%%%%%传入参数 thework_no%%%%%%%%"+thework_no);	
		System.out.println("%%%%%%%传入参数 stream%%%%%%%%"+stream);	
		System.out.println("%%%%%%%传入参数 mem_num%%%%%%%%"+mem_num);	
			
		String url = "/npage/contact/upCnttInfo.jsp?opCode="+theop_code+"&retCodeForCntt="+retCode+"&opName="+opName2+"&workNo="+thework_no+"&loginAccept="+stream+"&pageActivePhone="+mem_num+"&opBeginTime="+opBeginTime+"&contactId="+mem_num+"&contactType=user";
		System.out.println("%%%%%%%传入参数 url%%%%%%%%"+url);	
%>
		<jsp:include page="<%=url%>" flush="true" />
<%	
		System.out.println("%%%%%%%调用统一接触结束%%%%%%%%");

/*------------------------------依据调用服务返回结果进行页面跳转------------------------------*/
%>
</script>

<%if(ret_code==0){%>
<script language='jscript'>
rdShowMessageDialog('操作成功！',2);
if("<%=returnPage%>"!="")
{
  location="<%=returnPage%>";
}
else
{
  parent.removeTab('<%=opCode2%>');
}
</script>
<%}%>



<%if(!(ret_code==0)){%>
<script language='jscript'>
	var ret_code = "<%=ret_code%>";
	var ret_msg = "<%=ret_msg%>";
	rdShowMessageDialog("查询错误！<br>错误代码：'<%=ret_code%>'。<br>错误信息：'<%=ret_msg%>'。");
	history.go(-2);
</script>
<%}%>
