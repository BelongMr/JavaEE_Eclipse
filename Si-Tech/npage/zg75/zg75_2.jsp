<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%request.setCharacterEncoding("GBK");%>
<%@ page contentType="text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.sitech.boss.pub.config.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/wtc.tld" prefix="wtc" %>

<%
    String groupId = (String)session.getAttribute("groupId");
	String opCode = "zg75";
    String opName = "特殊工号月结发票打印";
	String orgCode = (String)session.getAttribute("orgCode");
	String regionCode = orgCode.substring(0,2);
	String workno = (String)session.getAttribute("workNo");
	String workname = (String)session.getAttribute("workName");
	String nopass = (String)session.getAttribute("password");

	  String phoneno=request.getParameter("contract_no");
	  //开始 结束
	  String print_begin = request.getParameter("begin_ym");
  
	  String result[][] = new String[][]{};
	  String result_1[][] = new String[][]{};
	  String s_code="";
	  String s_msg="";
	  
	  String[] inParam2 = new String[1];
	  inParam2[0]="select to_char(sysdate,'YYYYMMDD hh24:mi:ss') from dual";
	  String s_time="";
	  String result_check[][]=new String[][]{};
%>
<html xmlns="http://www.w3.org/1999/xhtml">
			<HEAD><TITLE>月结发票打印查询结果</TITLE>
			</HEAD>
			<body>


			<FORM method=post name="frm1508_2">
			<%@ include file="/npage/include/header.jsp" %>
			<div class="title">
				<div id="title_zi">查询结果</div>
			</div>
<%
	//String s_invoice_tmp="";
	String return_flag="";
	String return_note="";
	String ocpy_begin_no="";
	String ocpy_end_no="";
	String ocpy_num="";
	String res_code="";
	String bill_code="";
	String bill_accept="";
	String s_invoice_flag="";
%>

	<wtc:service name="TlsPubSelBoss"  outnum="1" >
		<wtc:param value="<%=inParam2[0]%>"/>
	</wtc:service>
	<wtc:array id="retList" scope="end" />
<%
	result_check = retList;
	if(result_check.length>0)
	{
		s_time=result_check[0][0];
	}
		
	  String[] inParas2 = new String[10];
	  inParas2[0]="0";
	  inParas2[1]="01";
	  inParas2[2]=opCode;
	  inParas2[3]=workno;
	  inParas2[4]=nopass;
	  inParas2[5]=phoneno;
	  inParas2[6]="";//用户密码
	  inParas2[7]="月结通用机打发票打印";
	  inParas2[8]=s_time;
	  inParas2[9]=print_begin;
	  //xl add for xuxza 字符串为zhouwy接口传出
	  String s_accepts="";
	  String s_op_time="";
	  String s_flag="";
%>
<wtc:service name="sBusiIdQry" retcode="retCode_1" retmsg="retMsg_1" outnum="2" >
		<wtc:param value="<%=phoneno%>"/>
	</wtc:service>
<wtc:array id="retList_1" scope="end" />
<%
	//retCode_1="000000";
	if(retCode_1=="000000" ||retCode_1.equals("000000"))
	{
		s_accepts=retList_1[0][0];
		s_op_time=retList_1[0][1];
		System.out.println("aaaaaaaaaaaaaaaaaaaaaaaa s_accepts is "+s_accepts);
		%>
		<wtc:service name="bs_zg17Init" routerKey="phone" routerValue="<%=phoneno%>" retcode="retCode1" retmsg="retMsg1" outnum="17" >
		<wtc:param value="<%=inParas2[0]%>"/>
		<wtc:param value="<%=inParas2[1]%>"/>
		<wtc:param value="<%=inParas2[2]%>"/>
		<wtc:param value="<%=inParas2[3]%>"/>
		<wtc:param value="<%=inParas2[4]%>"/>
		<wtc:param value="<%=inParas2[5]%>"/>
		<wtc:param value="<%=inParas2[6]%>"/>
		<wtc:param value="<%=inParas2[7]%>"/>
		<wtc:param value="<%=inParas2[8]%>"/>
		<wtc:param value="<%=inParas2[9]%>"/>
		<wtc:param value="<%=s_accepts%>"/>
		<wtc:param value="<%=s_op_time%>"/>
	</wtc:service>
	<wtc:array id="sVerifyTypeArr" scope="end" /> 
	 
	<%
		result_1=sVerifyTypeArr;
		System.out.println("fffffffffffffffffffaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa result_1[0][15] is "+result_1[0][15] +" and s_code is "+s_code+" and result_1[0][1] is "+result_1[0][1]); 
		s_code=retCode1;
		s_msg=retMsg1;
		if(s_code=="000000" ||s_code.equals("000000"))
		{
			s_flag=result_1[0][16];
			//xl add 如果发票可打印金额>0 则进行发票预占
			//s_flag="N"; 	
			%>

			
				<script language="javascript">
					 function doyz(packet)
					 {
						var ocpy_begin_no = packet.data.findValueByName("ocpy_begin_no");	 
						var ocpy_end_no = packet.data.findValueByName("ocpy_end_no");	
						var ocpy_num  = packet.data.findValueByName("ocpy_num"); 
						var res_code= packet.data.findValueByName("res_code"); 
						var bill_code= packet.data.findValueByName("bill_code");
						var bill_accept= packet.data.findValueByName("bill_accept");
						var s_invoice_flag= packet.data.findValueByName("s_invoice_flag");
						var return_page="../zg75/zg75_1.jsp?activePhone="+"<%=phoneno%>";
						//var czfx=document.getElementById("czfx").value ;
						//new
						var s_ret_code  =  packet.data.findValueByName("s_ret_code");
						var s_ret_msg  =  packet.data.findValueByName("s_ret_msg");
						if(s_invoice_flag=="1")
						{
							rdShowMessageDialog("预占接口调用异常!");
							window.location.href= return_page ;
						}
						else
						{
							if(s_invoice_flag=="0")
							{
								var prtFlag=0;
								prtFlag=rdShowConfirmDialog("当前发票号码是"+ocpy_begin_no+",发票代码是"+bill_code+",是否打印发票?");
								if (prtFlag==1)
								{
									document.frm1508_2.action="zg75_3.jsp?check_seq="+ocpy_begin_no+"&bill_code="+bill_code;
									document.frm1508_2.submit();
								}
								else
								{
									var pactket2 = new AJAXPacket("../zg17/sdis_ocpy.jsp","正在进行发票预占取消，请稍候......");
									//alert("1 服务里应该是按流水改状态 不是插入了");
									pactket2.data.add("ocpy_begin_no",ocpy_begin_no);
									pactket2.data.add("bill_code",bill_code);
									pactket2.data.add("paySeq","<%=result_1[0][13]%>");
									pactket2.data.add("op_code","<%=opCode%>");
									pactket2.data.add("phoneNo","<%=phoneno%>");
									pactket2.data.add("contractno","0");
									pactket2.data.add("payMoney","<%=result_1[0][12]%>");
									pactket2.data.add("userName","<%=result_1[0][2]%>");
									//alert("2 "+pactket1.data);
									 
									core.ajax.sendPacket(pactket2,doqx);
								 
									pactket2=null;
								}
							}
							else
							{
								rdShowMessageDialog("发票预占失败!错误原因:"+s_ret_msg,0);
								window.location.href="zg75_1.jsp?activePhone="+"<%=phoneno%>";
							 
							}
						}
					 }
					 function doqx(packet)
					 {
						var s_flag = packet.data.findValueByName("s_flag");	
						var s_code = packet.data.findValueByName("s_code");	//貌似没啥用
						var s_note = packet.data.findValueByName("s_note");	
						var s_invoice_code  = packet.data.findValueByName("s_invoice_code");//貌似也没啥用	
						var return_page="../zg75/zg75_1.jsp?activePhone="+"<%=phoneno%>";
						if(s_flag=="1")
						{
							rdShowMessageDialog("预占取消接口调用异常!");
							window.location.href=return_page;
						}
						else
						{
							if(s_flag=="0")
							{
								rdShowMessageDialog("发票预占取消成功,打印完成!",2);
								window.location.href=return_page;
							}
							else
							{
								rdShowMessageDialog("发票预占失败! 错误代码:"+s_code,0);
								window.location.href=return_page;
								 
							}
						}
					 }
	 
					function left_input()
					{
						rdShowMessageDialog("请回收用户余额发票,并录入余额发票金额!余额发票仅可以录入一次,请确认好金额！")
						if(document.frm1508_2.left_invoice.value=="")
					    {
						   rdShowMessageDialog("请录入余额发票金额!");
						   return false;
					    }
					    else
					    {
						   var prtFlag=0;
						   prtFlag=rdShowConfirmDialog("本次录入金额"+document.frm1508_2.left_invoice.value+"元，是否确定录入余额发票信息?");
						   if (prtFlag==1)
						   {
							   document.frm1508_2.action="zg17_input.jsp";
							   document.frm1508_2.submit();
						   }
						   else
						   {
							   return false;
						   }	
						   
					    }	 
					}
					function doPrint()
					{
						//alert("result_1[0][12] is "+"<%=result_1[0][12]%>"+" and s_invoice_flag is "+"<%=s_invoice_flag%>");
						if("<%=result_1[0][12]%>"<=0)
						{
							rdShowMessageDialog("月结发票金额为0，请作废用户的预存发票后重新打印月结发票!");
							//return false;
						}		
						else
						{
							//电子发票begin
							var h=480;
							var w=650;
							var t=screen.availHeight/2-h/2;
							var l=screen.availWidth/2-w/2;
							var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
							var path="../s1300/select_invoice.jsp";
							var returnValue = window.showModalDialog(path,"",prop);
							if(returnValue=="1")
							{
								var pactket1 = new AJAXPacket("../s1300/sfp_ocpy.jsp","正在进行发票预占，请稍候......");
								pactket1.data.add("ocpy_begin_no","<%=ocpy_begin_no%>");
								pactket1.data.add("bill_code","<%=bill_code%>");
								pactket1.data.add("paySeq","<%=result_1[0][13]%>");
								pactket1.data.add("op_code","zg75");
								pactket1.data.add("phoneNo","<%=phoneno%>");
								pactket1.data.add("contractno","0");
								pactket1.data.add("payMoney","<%=result_1[0][12]%>");
								pactket1.data.add("userName","<%=result_1[0][2]%>");
								core.ajax.sendPacket(pactket1,doyz);
								pactket1=null;
							}
							else if(returnValue=="3")
							{
								
								//alert("电子的");
								var txfwf = document.all.txfwf.value;//通信服务费
								var xszk = document.all.xszk.value;//销售折扣
								var yckykjje = document.all.yckykjje.value;//预存款已出具发票金额
								var czkykjje = document.all.czkykjje.value;//充值卡已出具发票金额 	
								var xtcz = document.all.xtcz.value;//系统赠送
								var hytcf = document.all.hytcf.value;//合约套餐费
								var s_flag = "<%=s_flag%>";//Y=有合约套餐费
								
								var s_kpxm="";//"zg17月结发票打印";
								var s_xmdj="<%=result_1[0][12]%>";
								var s_xmje="<%=result_1[0][12]%>";
								var s_hsbz="";//含税标志 1=含税
								var s_sl="";//传0试试
								var s_se="";
								var s_xmsl="";
								var xmdw="";
								var s_ggxh="";
								var s_zg17_note="";//放到备注里
								/*
								if(s_flag=="Y")
								{
									s_zg17_note="通信服务费:"+txfwf+",销售折扣:"+xszk+",预存款已出具发票金额:"+yckykjje+",充值卡已出具发票金额:"+czkykjje+",系统赠送:"+xtcz+",合约套餐费:"+hytcf;
									 
								}
								else
								{
									s_zg17_note="通信服务费:"+txfwf+",销售折扣:"+xszk+",预存款已出具发票金额:"+yckykjje+",充值卡已出具发票金额:"+czkykjje+",系统赠送:"+xtcz;
								}
								s_xmje=s_xmdj;
								s_hsbz="1";
								s_sl="*";
								s_se="0";
								s_xmsl="1";
								xmdw="";
								s_ggxh="";
								//s_kpxm=s_zg17_note;
								s_kpxm="月结发票开具";*/
								var s_ycjqt="<%=result_1[0][11]%>";
								if(s_flag=="Y")
								{
									s_kpxm="通信服务费,销售折扣,预存款已出具发票金额,充值卡已出具发票金额,系统赠送,合约套餐费,已出具其他";
									s_xmdj=txfwf+","+xszk+","+yckykjje+","+czkykjje+","+xtcz+","+hytcf+","+s_ycjqt;
									s_xmje=s_xmdj;
									s_hsbz="1,1,1,1,1,1,1";
									s_sl="*,*,*,*,*,*,*";
									s_se="0,0,0,0,0,0,0";
									s_xmsl="1,1,1,1,1,1,1";
									xmdw=",,,,,,";
									s_ggxh=",,,,,,";
								}
								/*
								else
								{
									s_kpxm="通信服务费,销售折扣,预存款已出具发票金额,充值卡已出具发票金额,系统赠送";
									s_xmdj=txfwf+","+xszk+","+yckykjje+","+czkykjje+","+xtcz;
									s_xmje=s_xmdj;
									s_hsbz="1,1,1,1,1";
									s_sl="*,*,*,*,*";
									s_se="0,0,0,0,0";
									s_xmsl="1,1,1,1,1";
									xmdw=",,,,";
									s_ggxh=",,,,";
								}
								*/
								else
								{
									s_kpxm="通信服务费";
									s_xmdj="<%=result_1[0][12]%>";
									s_xmje=s_xmdj;
									s_hsbz="1";
									s_sl="*";
									s_se="0";
									s_xmsl="1";
									xmdw="";
									s_ggxh="";
								}
								var s_ghmfc="<%=result_1[0][2]%>";
								var s_jsheje="<%=result_1[0][12]%>";//价税合计金额
								var s_hjbhsje=0;//合计不含税金额
								var s_hjse=0;
								var s_xmmc=s_kpxm;
								
								
								//新增
								var op_code="zg75";
								var payaccept="<%=result_1[0][13]%>";
								var id_no="0";
								var sm_code="0";
								var phone_no="<%=phoneno%>";
								//var pay_note=s_kpxm;
								//var pay_note=s_zg17_note;
								var dyzq = document.getElementById("dyzq").value;
								var pay_note=s_kpxm+",话费账期:"+dyzq;
								var returnPage="../zg75/zg75_1.jsp?activePhone="+phone_no;
								var chbz="1";
								var contractno="0";
								var kphjje="<%=result_1[0][12]%>";
								document.frm1508_2.action="../zg17/PrintInvoice_dz.jsp?s_kpxm="+s_kpxm+"&s_ghmfc="+s_ghmfc+"&s_jsheje="+s_jsheje+"&hjse="+s_hjse+"&s_xmmc="+s_xmmc+"&s_ggxh="+s_ggxh+"&s_hsbz="+s_hsbz+"&s_xmdj="+s_xmdj+"&s_xmje="+s_xmje+"&s_sl="+s_sl+"&s_se="+s_se+"&op_code="+op_code+"&payaccept="+payaccept+"&id_no="+id_no+"&sm_code="+sm_code+"&phone_no="+phone_no+"&pay_note="+pay_note+"&chbz="+chbz+"&returnPage="+returnPage+"&xmsl="+s_xmsl+"&contractno="+contractno+"&hjbhsje="+s_hjbhsje+"&kphjje="+kphjje+"&xmdw="+xmdw+"&dyzq="+dyzq;
								document.frm1508_2.submit(); 
								
							}
							else
							{
								var paySeq="<%=result_1[0][13]%>";
								var phoneno="<%=phoneno%>";
								var kphjje="<%=result_1[0][12]%>";//开票合计金额
								var s_hjbhsje=0;//合计不含税金额
								var s_hjse=0;
								var contractno="0";
								var id_no="0";
								var sm_code="0";
								var s_xmmc="<%=opName%>";//项目名称 crm可能为多条? 看下zg17多组怎么传的
								var opCode="zg75";
								var return_page = "../zg75/zg75_1.jsp?activePhone="+phoneno;
								document.frm1508_2.action="../s1300/PrintInvoice_qx.jsp?opCode="+opCode+"&paySeq="+paySeq+"&phoneno="+phoneno+"&kphjje="+kphjje+"&s_hjbhsje="+s_hjbhsje+"&hjse="+s_hjse+"&returnPage="+return_page+"&hsbz=1&xmdj="+kphjje+"&contractno="+contractno+"&id_no="+id_no+"&sm_code="+sm_code+"&chbz=1&s_xmmc="+s_xmmc+"&paynote=zg75";
								
								document.frm1508_2.submit();
							}
							//end 电子发票
							 
						}
					}
				</script>
					  <table cellspacing="0" id = "PrintA">
							<tr> 
							  <td>客户名称</td><td><%=result_1[0][2]%></td>
							  <input type="hidden" name="cust_name" value="<%=result_1[0][2]%>">
							  <td>客户品牌</td><td><%=result_1[0][3]%></td>
							  <input type="hidden" name="sm_name" value="<%=result_1[0][3]%>">
							</tr>
							<tr> 
							  <td>通信服务费</td><td><%=result_1[0][4]%></td>
							  <td>销售折扣</td><td><%=result_1[0][5]%></td>
							   <input type="hidden" name="txfwf" value="<%=result_1[0][4]%>">
								<input type="hidden" name="xszk" value="<%=result_1[0][5]%>">
							</tr>
							<tr> 
							  <td>合计</td><td><%=result_1[0][6]%></td> 
							  <input type="hidden" name="hj" value="<%=result_1[0][6]%>">
							  <td>已开具发票金额</td><td><%=result_1[0][7]%></td>
							  <input type="hidden" name="ykjje" value="<%=result_1[0][7]%>">	
							</tr>
							<tr> 
							  <td>预存款已出具发票金额</td><td><%=result_1[0][8]%></td>
							  <input type="hidden" name="yckykjje" value="<%=result_1[0][8]%>">
							  <td>充值卡已开具金额</td><td><%=result_1[0][9]%></td>
							  <input type="hidden" name="czkykjje" value="<%=result_1[0][9]%>">
							</tr>
							<tr>
							  <td>当月系统赠送金额</td><td><%=result_1[0][10]%></td>	
							  <td>其他</td><td><%=result_1[0][11]%></td>
							  <input type="hidden" name="xtcz" value="<%=result_1[0][10]%>">
							  <input type="hidden" name="qt" value="<%=result_1[0][11]%>">
							</tr>
							<tr>
							  <td>本次发票金额</td><td><%=result_1[0][12]%></td>	
							  <td>打印流水</td><td><%=result_1[0][13]%></td>
							   <input type="hidden" name="invoice_money" value="<%=result_1[0][12]%>">
							   <input type="hidden" name="login_accept" value="<%=result_1[0][13]%>">
							   <input type="hidden" name="phoneno" value="<%=phoneno%>">
							   <input type="hidden" name="print_begin" value="<%=print_begin%>">
							   <input type="hidden" name="s_time" value="<%=s_time%>">
							   <input type="hidden" name="hytcf" value="<%=result_1[0][15]%>">
							   <input type="hidden" name="s_flag" value="<%=s_flag%>">
							   
							   
							</tr>
							<tr>
							  <td>打印账期</td><td><%=result_1[0][14]%></td>
							  <input type="hidden" id="dyzq" value="<%=result_1[0][14]%>">
							  <td>合约套餐费</td><td><%=result_1[0][15]%></td>
							</tr>
							<!--
							<tr>
							  <td>用户余额发票</td><td colspan=3><input type="text" name="left_invoice">&nbsp;&nbsp;
							  <input type="button"  class="b_foot" value="余额发票录入" onclick="left_input()" ></td>
							</tr>
							-->
						 <tr id="footer"> 
							<td colspan="9">
							  <input class="b_foot" id="dayin" onClick="doPrint()" type=button value=打印>	
							  <input class="b_foot" name=back onClick="window.location = 'zg75_1.jsp?activePhone=<%=phoneno%>' " type=button value=返回>
							  <input class="b_foot" name=back onClick="window.close();" type=button value=关闭>
						
							</td>
						  </tr>
						  
					  </table>
					  <tr id="footer"> 
						   
						  </tr>
					
						
							
						

				<%@ include file="/npage/include/footer.jsp" %>
				</FORM>
				</BODY></HTML>
			<%
		}
		else
		{
			%>
				<script language="javascript">
					rdShowMessageDialog("查询失败,错误代码:"+"<%=s_code%>"+",错误原因:"+"<%=s_msg%>");
					document.location.replace('zg75_1.jsp?activePhone=<%=phoneno%>');
				</script>
			<%
		}
	%>
			<%
		}
	else
	{
		%>
			<script language="javascript">
				rdShowMessageDialog("查询失败,错误代码:"+"<%=retCode_1%>"+",错误原因:"+"<%=retMsg_1%>");
				document.location.replace('zg75_1.jsp?activePhone=<%=phoneno%>');
			</script>
		<%
	}
%>

	 
 


