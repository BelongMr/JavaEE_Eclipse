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
    String org_Code = (String)session.getAttribute("orgCode");
    String regionCode = org_Code.substring(0,2);				   
	
	String opCode = "1322";
	String opName = "集团发票打印";
	
	       
	String loginName = (String)session.getAttribute("workName");   
	String pass = (String)session.getAttribute("password");
	
	String unit_id= request.getParameter("unit_id");
	String work_no = (String)session.getAttribute("workNo");
	 
	 
	 
	 
 
	String sparas_accept[] = new String[1]; 
	sparas_accept[0]="select to_char(sMaxPayAccept.nextval) from dual";
	String[] inParas_detail = new String[2];
	inParas_detail[0]="select bank_cust,to_char(contract_no) from dconmsg b where b.contract_no=:contract_no"; 

	String bill_ym = request.getParameter("bill_ym");
	String begin_ym = request.getParameter("begin_ym");
	String end_ym = request.getParameter("end_ym");
 
	//xl add 发票预占接口
	String paySeq="";
	String groupId = (String)session.getAttribute("groupId");
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

<wtc:service name="TlsPubSelBoss" routerKey="region" routerValue="<%=regionCode%>" retcode="sCode2_accept" retmsg="sMsg2_accept" outnum="1" >
    <wtc:param value="<%=sparas_accept[0]%>"/>
</wtc:service>
<wtc:array id="s_invoice_accept" scope="end"/>
<%
	paySeq=s_invoice_accept[0][0];
%>


<!--xl add s1322Left begin-->
<wtc:service name="s1322Left" routerKey="region" routerValue="<%=regionCode%>" retcode="sCode3" retmsg="sMsg3" outnum="8" >
    <wtc:param value="<%=unit_id%>"/>
    <wtc:param value="<%=work_no%>"/>
	<wtc:param value="<%=regionCode%>"/>
	<wtc:param value="<%=begin_ym%>"/>
	<wtc:param value="<%=end_ym%>"/>
</wtc:service>
<wtc:array id="s_result" scope="end" start="0"  length="4" />
<wtc:array id="s_1322qry" scope="end" start="4"  length="4"/>
<%
	if(sCode3=="000000" ||(sCode3.equals("000000")))
	{
		//如果s_1322qry.length==0 说明没查到记录 调用取消预占接口
		if(s_1322qry.length>0)
		{
		   %>
			<HEAD><TITLE>虚拟集团查询结果</TITLE>
				</HEAD>
				<body onload="inits()">

				<script language="javascript">
					function inits()
					{
						document.getElementById("jtfpdy").disabled=true;
						//document.getElementById("jtfpdy_all").disabled=true;
					}
					function doqx(packet)
					{
						var s_flag = packet.data.findValueByName("s_flag");	
						var s_code = packet.data.findValueByName("s_code");	//貌似没啥用
						var s_note = packet.data.findValueByName("s_note");	
						var s_invoice_code  = packet.data.findValueByName("s_invoice_code");//貌似也没啥用	
						//alert("s_flag is "+s_flag+" and s_code is "+s_code+" and s_note is "+s_note);
						//s_flag="1";
						//alert("s_flag is "+s_flag+" and s_code is "+s_code+" and s_note is "+s_note);
						if(s_flag=="1")
						{
							rdShowMessageDialog("预占取消接口调用异常!");
							window.location.href="s1322.jsp";
						}
						else
						{
							if(s_flag=="0")
							{
								rdShowMessageDialog("发票预占取消成功,打印完成!",2);
								window.location.href="s1322.jsp";
							}
							else
							{
								rdShowMessageDialog("发票预占失败! 错误代码:"+return_flag,0);

							}
						}
					 }
					 function doyz(packet)
					 {
						var ocpy_begin_no = packet.data.findValueByName("ocpy_begin_no");	 
						var ocpy_end_no = packet.data.findValueByName("ocpy_end_no");	
						var ocpy_num  = packet.data.findValueByName("ocpy_num"); 
						var res_code= packet.data.findValueByName("res_code"); 
						var bill_code= packet.data.findValueByName("bill_code");
						var bill_accept= packet.data.findValueByName("bill_accept");
						var s_invoice_flag= packet.data.findValueByName("s_invoice_flag");
						var u_id = document.getElementById("u_id").value;
						var u_name = document.getElementById("u_name").value;
						//从上一个页面ajax传过来的值
						var grp_phone_no = packet.data.findValueByName("grp_phone_no");
						var grp_contract_no = packet.data.findValueByName("grp_contract_no");
						var s_money = packet.data.findValueByName("s_money");
						var s_accepts = packet.data.findValueByName("s_accepts");
						if(s_invoice_flag=="1")
						{
							rdShowMessageDialog("预占接口调用异常!");
							window.location.href="s1322.jsp";
						}
						else
						{
							if(s_invoice_flag=="0")
							{
								var prtFlag=0;
								prtFlag=rdShowConfirmDialog("当前发票号码是"+ocpy_begin_no+",发票代码是"+bill_code+",是否打印发票?");
								if (prtFlag==1)
								{
									document.frm1508_2.action="s1322_print.jsp?u_id="+u_id+"&u_name="+u_name+"&invoice_number="+ocpy_begin_no+"&invoice_code="+bill_code+"&login_accept="+"<%=paySeq%>"+"&begin_ym="+"<%=begin_ym%>"+"&end_ym="+"<%=end_ym%>";
									document.frm1508_2.phone_id.value=grp_phone_no;
									document.frm1508_2.contract_id.value=grp_contract_no;
									document.frm1508_2.s_money_id.value=s_money;
									document.frm1508_2.s_loginaccept_id.value=s_accepts;
									document.frm1508_2.submit();  
								}
								else
								{
									var pactket2 = new AJAXPacket("sdis_ocpy.jsp","正在进行发票预占取消，请稍候......");
									//alert("1 服务里应该是按流水改状态 不是插入了");
									pactket2.data.add("ocpy_begin_no",ocpy_begin_no);
									pactket2.data.add("bill_code",bill_code);
									pactket2.data.add("paySeq","<%=paySeq%>");
									pactket2.data.add("bill_code",bill_code);
									pactket2.data.add("op_code","1322");
									pactket2.data.add("phoneNo","<%=unit_id%>");
									pactket2.data.add("contractno","");
									pactket2.data.add("payMoney",document.getElementById("s_sum").value);
									pactket2.data.add("userName",document.frm1508_2.items.value);
									core.ajax.sendPacket(pactket2,doqx);
									pactket2=null;
								}
							}
							else
							{
								rdShowMessageDialog("发票预占失败! 错误代码:"+return_flag,0);

							}
						}
					 } 

					function doCfm()
					{
						var  grp_phone_no=[];
						var  grp_contract_no=[];
						var  s_accepts=[];
						var  s_money=[];
						var  s_sum_money = 0.0;
						var len = "";
						len=document.frm1508_2.regionCheck.length;
						//alert("test "+len);
						var i_flag=0;//不可以操作
						var u_id = document.getElementById("u_id").value;
						var u_name = document.getElementById("u_name").value;

						//开票项目
						var items = document.frm1508_2.items.value;
						if(items=="")
						{
							rdShowMessageDialog("请输入开票项目!");
							return false;
						}
						else
						{
							if(len==undefined)
							{
								
								if (document.frm1508_2.regionCheck.checked == true)
								{
									len=1;
									i=0;
									var s_phone = document.getElementById("s_phone"+i).value;
									grp_phone_no.push(s_phone);
									var s_contract = document.getElementById("s_contract"+i).value;
									grp_contract_no.push(s_contract);
									var s_moneys = document.getElementById("s_money"+i).value;
									var accepts= document.getElementById("s_accept"+i).value;
									s_accepts.push(accepts);
									if(s_moneys=="")
									{
										rdShowMessageDialog("请输入欲开具发票金额");
									}
									else
									{
										s_money.push(s_moneys);
										document.getElementById("s_sum").value=s_moneys;
										var ss = parseFloat(document.getElementById("s_money"+i).value);
										s_sum_money += ss;
										document.getElementById("s_sum").value=s_sum_money.toFixed(2);
										i_flag=1;
									}
									
									//alert("1:grp_phone_no is "+grp_phone_no+" and grp_contract_no is "+grp_contract_no+" and s_money is "+s_money);
								}
								 
								
							}
							else
							{
								for (i = 0; i < len; i++) 
								{
									if (document.frm1508_2.regionCheck[i].checked == true) 
									{
										var s_phone = document.getElementById("s_phone"+i).value;
										grp_phone_no.push(s_phone);
										var s_contract = document.getElementById("s_contract"+i).value;
										grp_contract_no.push(s_contract);
										var s_moneys = document.getElementById("s_money"+i).value;
										var accepts= document.getElementById("s_accept"+i).value;;
										s_accepts.push(accepts);
										if(s_moneys=="")
										{
											rdShowMessageDialog("请输入欲开具发票金额");
										}
										else
										{
											s_money.push(s_moneys);
											var ss = parseFloat(document.getElementById("s_money"+i).value);
											//alert("test ss is "+ ss);
											s_sum_money += ss;
											document.getElementById("s_sum").value=s_sum_money.toFixed(2);
											//alert("s_sum_money is "+s_sum_money.toFixed(2));
											i_flag=1;
										}
										
										
									}
									 
								}
								
							}
						}
						
						if(i_flag==1)
						{
							//xl add for 改造电子发票选择框
							var h=480;
							var w=650;
							var t=screen.availHeight/2-h/2;
							var l=screen.availWidth/2-w/2;
							var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
							var path="select_invoice.jsp";
							var returnValue = window.showModalDialog(path,"",prop);
							if(returnValue=="1")
							{
								var pactket1 = new AJAXPacket("sfp_ocpy_1322.jsp","正在进行发票预占，请稍候......");
								pactket1.data.add("ocpy_begin_no","<%=ocpy_begin_no%>");
								pactket1.data.add("bill_code","<%=bill_code%>");
								pactket1.data.add("paySeq","<%=paySeq%>");
								pactket1.data.add("op_code","1322");
								pactket1.data.add("phoneNo","<%=unit_id%>");
								pactket1.data.add("contractno","");
								pactket1.data.add("payMoney",s_sum_money.toFixed(2));
								pactket1.data.add("userName",document.frm1508_2.items.value);
								//xl add for 1322特意准备的 传递几个数组参数 grp_phone_no grp_contract_no s_money  s_invoice_accept
								pactket1.data.add("grp_phone_no",grp_phone_no);
								pactket1.data.add("grp_contract_no",grp_contract_no);
								pactket1.data.add("s_money",s_money);
								pactket1.data.add("s_invoice_accept",s_accepts);
								core.ajax.sendPacket(pactket1,doyz);
								pactket1=null;
							}
							else if(returnValue=="3")
							{
				        //add by zhangleij 20170628 for sunqy 关于做好增值税发票管理有关工作的通知 begin
				        var h=300;
			          var w=680;
			          var t=screen.availHeight/2-h/2;
			          var l=screen.availWidth/2-w/2;
			          var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
			          var path1="getNsrsbh.jsp?param_no="+"<%=unit_id%>"+"&param_type=1";
			          var returnValue1 = window.showModalDialog(path1,"",prop);
			          //alert("test returnValue1 is "+returnValue1);
				        //add by zhangleij 20170628 for sunqy 关于做好增值税发票管理有关工作的通知 end
								
								//alert("电子的");
								var s_kpxm="1322_集团打印发票";
								var s_ghmfc=document.frm1508_2.items.value;
								var s_jsheje=s_sum_money.toFixed(2);//价税合计金额
								var s_hjbhsje=0;//合计不含税金额
								var s_hjse=0;
								var s_xmmc="集团打印发票";//项目名称 crm可能为多条? 看下zg17多组怎么传的
								var s_ggxh="";
								var s_hsbz="1";//含税标志 1=含税
								var s_xmdj=s_sum_money.toFixed(2);
								var s_xmje=s_sum_money.toFixed(2);
								var s_sl="*";
								var s_se="0";
								//新增
								var op_code="1322";
								var payaccept="<%=paySeq%>";
								var id_no="0";
								var sm_code="0";
								var phone_no="<%=unit_id%>";
								var pay_note=s_kpxm;
								var returnPage ="s1322.jsp";
								var chbz="1";
								var kphjje=s_sum_money.toFixed(2);
								//new 
								var u_id = document.getElementById("u_id").value;
								var u_name = document.getElementById("u_name").value;
								//开票项目
								var items = document.frm1508_2.items.value;
								//document.frm1508_2.action="PrintInvoice1322_dz.jsp?s_kpxm="+s_kpxm+"&s_ghmfc="+s_ghmfc+"&s_jsheje="+s_jsheje+"&hjse="+s_hjse+"&s_xmmc="+s_xmmc+"&s_ggxh="+s_ggxh+"&s_hsbz="+s_hsbz+"&s_xmdj="+s_xmdj+"&s_xmje="+s_xmje+"&s_sl="+s_sl+"&s_se="+s_se+"&op_code="+op_code+"&payaccept="+payaccept+"&id_no="+id_no+"&sm_code="+sm_code+"&phone_no="+phone_no+"&pay_note="+pay_note+"&chbz="+chbz+"&returnPage="+returnPage+"&xmsl=1&hjbhsje="+s_hjbhsje+"&kphjje="+kphjje+"&u_id="+u_id+"&u_name="+u_name+"&items="+items+"&grp_phone_no_new="+grp_phone_no+"&grp_contract_no="+grp_contract_no+"&s_accepts="+s_accepts+"&s_money="+s_money+"&begin_ym="+"<%=begin_ym%>"+"&end_ym="+"<%=end_ym%>";
								//add by zhangleij 20170628 for sunqy 关于做好增值税发票管理有关工作的通知 begin
								document.frm1508_2.action="PrintInvoice1322_dz.jsp?s_kpxm="+s_kpxm+"&s_ghmfc="+s_ghmfc+"&s_jsheje="+s_jsheje+"&hjse="+s_hjse+"&s_xmmc="+s_xmmc+"&s_ggxh="+s_ggxh+"&s_hsbz="+s_hsbz+"&s_xmdj="+s_xmdj+"&s_xmje="+s_xmje+"&s_sl="+s_sl+"&s_se="+s_se+"&op_code="+op_code+"&payaccept="+payaccept+"&id_no="+id_no+"&sm_code="+sm_code+"&phone_no="+phone_no+"&pay_note="+pay_note+"&chbz="+chbz+"&returnPage="+returnPage+"&xmsl=1&hjbhsje="+s_hjbhsje+"&kphjje="+kphjje+"&u_id="+u_id+"&u_name="+u_name+"&items="+items+"&grp_phone_no_new="+grp_phone_no+"&grp_contract_no="+grp_contract_no+"&s_accepts="+s_accepts+"&s_money="+s_money+"&begin_ym="+"<%=begin_ym%>"+"&end_ym="+"<%=end_ym%>";
								//add by zhangleij 20170628 for sunqy 关于做好增值税发票管理有关工作的通知 end
								document.frm1508_2.submit(); 
								
							}
							else//qx的
							{
								var paySeq="<%=paySeq%>";
								var phoneno="<%=unit_id%>";
								var kphjje=s_sum_money.toFixed(2);//开票合计金额
								var s_hjbhsje=0;//合计不含税金额
								var s_hjse=0;
								var contractno="0";
								var id_no="0";
								var sm_code="0";
								var s_xmmc="<%=opName%>";//项目名称 crm可能为多条? 看下zg17多组怎么传的
								var opCode="<%=opCode%>";
								var return_page = "s1322.jsp";
								document.frm1508_2.action="PrintInvoice_qx.jsp?opCode="+opCode+"&paySeq="+paySeq+"&phoneno="+phoneno+"&kphjje="+kphjje+"&s_hjbhsje="+s_hjbhsje+"&hjse="+s_hjse+"&returnPage="+return_page+"&hsbz=1&xmdj="+kphjje+"&contractno="+contractno+"&id_no="+id_no+"&sm_code="+sm_code+"&chbz=1&s_xmmc="+s_xmmc+"&paynote=1322发票打印";
								
								document.frm1508_2.submit();
							}
							//end of 电子发票
							/*
							var	prtFlag = rdShowConfirmDialog("本次发票号码"+"<%=ocpy_begin_no%>,本次发票代码"+"<%=bill_code%>,预开发票总金额是"+s_sum_money.toFixed(2)+"元，是否确定本次操作？");
							if (prtFlag==1)
							{
								
								document.frm1508_2.action="s1322_print.jsp?u_id="+u_id+"&u_name="+u_name+"&invoice_number="+"<%=ocpy_begin_no%>"+"&invoice_code="+"<%=bill_code%>"+"&login_accept="+"<%=paySeq%>"+"&begin_ym="+"<%=begin_ym%>"+"&end_ym="+"<%=end_ym%>";

								document.frm1508_2.phone_id.value=grp_phone_no;
								document.frm1508_2.contract_id.value=grp_contract_no;
								document.frm1508_2.s_money_id.value=s_money;
								document.frm1508_2.s_loginaccept_id.value=s_accepts;
								document.frm1508_2.submit();  
							}
							else
							{ 
								var pactket1 = new AJAXPacket("sdis_ocpy.jsp","正在进行发票预占取消，请稍候......");
								pactket1.data.add("ocpy_begin_no","<%=ocpy_begin_no%>");
								pactket1.data.add("bill_code","<%=bill_code%>");
								pactket1.data.add("paySeq","<%=paySeq%>");
								pactket1.data.add("bill_code","<%=bill_code%>");
								pactket1.data.add("op_code","1322");
								pactket1.data.add("phoneNo","<%=unit_id%>");
								pactket1.data.add("contractno","0");
								pactket1.data.add("payMoney","0");
								pactket1.data.add("userName","");
								core.ajax.sendPacket(pactket1,retsWLWI);
								pactket1=null;
							}
							
						}
						else
						{
							rdShowMessageDialog("请勾选欲开具发票的集团信息!");
							return false;
						}*/
					}
					}
					//取消打印的操作 
					function retsWLWI(packet)
					{
						var s_flag = packet.data.findValueByName("s_flag");	
						var s_code = packet.data.findValueByName("s_code");	//貌似没啥用
						var s_note = packet.data.findValueByName("s_note");	
						var s_invoice_code  = packet.data.findValueByName("s_invoice_code");//貌似也没啥用	
						//alert("s_flag is "+s_flag+" and s_code is "+s_code+" and s_note is "+s_note);
						//s_flag="1";
						//alert("s_flag is "+s_flag+" and s_code is "+s_code+" and s_note is "+s_note);
						if(s_flag=="1")
						{
							rdShowMessageDialog("预占取消接口调用异常!");
							window.location.href="s1322.jsp";
						}
						else
						{
							if(s_flag=="0")
							{
								rdShowMessageDialog("发票预占取消成功,打印完成!",2);
								window.location.href="s1322.jsp";
							}
							else
							{
								rdShowMessageDialog("发票预占失败! 错误代码:"+return_flag,0);

								 
							}
						}
					 }
					//全选
					function doSelectAllNodes()
					{
						document.getElementById("jtfpdy").disabled=true;
				//		document.all.jtfpdy_all.disabled=false;
						if(document.getElementById("check_all_id").checked)
						{
							var regionChecks = document.getElementsByName("regionCheck");
							for(var i=0;i<regionChecks.length;i++){
								regionChecks[i].checked=true;
							}
							document.getElementById("check_not_id").checked=false;
						}
						
						   
					}
					function doCancelChooseAll()
					{
						if(document.getElementById("check_not_id").checked)
						{
							var regionChecks = document.getElementsByName("regionCheck");
							for(var i=0;i<regionChecks.length;i++){
								regionChecks[i].checked=false;
							}
							document.getElementById("check_all_id").checked=false;
						}	
					}
					function doCfm_all()
					{
						var  grp_phone_no=[];
						var  grp_contract_no=[];
						var  s_accepts=[];
						var  s_money=[];
						var  s_sum_money = 0.0;
						var len = "";
						len=document.frm1508_2.regionCheck.length;
						//alert("test "+len);
						var i_flag=0;//不可以操作
						var u_id = document.getElementById("u_id").value;
						var u_name = document.getElementById("u_name").value;

						//开票项目
						var items = document.frm1508_2.items.value;
						if(items=="")
						{
							rdShowMessageDialog("请输入开票项目!");
							return false;
						}
						else
						{
							if(len==undefined)
							{
								
								if (document.frm1508_2.regionCheck.checked == true)
								{
									len=1;
									i=0;
									var s_moneys = document.getElementById("s_money"+i).value;
									if(s_moneys=="")
									{
										rdShowMessageDialog("请输入欲开具发票金额");
									}
									else
									{
										s_money.push(s_moneys);
										document.getElementById("s_sum").value=s_moneys;
										var ss = parseFloat(document.getElementById("s_money"+i).value);
										s_sum_money += ss;
										document.getElementById("s_sum").value=s_sum_money.toFixed(2);
										i_flag=1;
									}
									
									//alert("1:grp_phone_no is "+grp_phone_no+" and grp_contract_no is "+grp_contract_no+" and s_money is "+s_money);
								}
								 
								
							}
							else
							{
								for (i = 0; i < len; i++) 
								{
									if (document.frm1508_2.regionCheck[i].checked == true) 
									{
										var s_moneys = document.getElementById("s_money"+i).value;
										if(s_moneys=="")
										{
											rdShowMessageDialog("请输入欲开具发票金额");
										}
										else
										{
											s_money.push(s_moneys);
											var ss = parseFloat(document.getElementById("s_money"+i).value);
											//alert("test ss is "+ ss);
											s_sum_money += ss;
											document.getElementById("s_sum").value=s_sum_money.toFixed(2);
											//alert("s_sum_money is "+s_sum_money.toFixed(2));
											i_flag=1;
										}
										
										
									}
									 
								}
								
							}
						}
						
						if(i_flag==1)
						{
							 
							var	prtFlag = rdShowConfirmDialog("本次发票号码"+"<%=ocpy_begin_no%>,本次发票代码"+"<%=bill_code%>,预开发票总金额是"+s_sum_money.toFixed(2)+"元，是否确定本次操作？");
							if (prtFlag==1)
							{
								
								document.frm1508_2.action="s1322_print_all.jsp?u_id="+u_id+"&u_name="+u_name+"&invoice_number="+"<%=ocpy_begin_no%>"+"&invoice_code="+"<%=bill_code%>"+"&login_accept="+"<%=paySeq%>"+"&begin_ym="+"<%=begin_ym%>"+"&end_ym="+"<%=end_ym%>";

								//document.frm1508_2.action="s1322_print.jsp?s_accepts="+s_accepts;
								document.frm1508_2.phone_id.value=grp_phone_no;
								document.frm1508_2.contract_id.value=grp_contract_no;
								document.frm1508_2.s_money_id.value=s_money;
								document.frm1508_2.s_loginaccept_id.value=s_accepts;
								//alert1(document.frm1508_2.action);
								document.frm1508_2.submit();  
							}
							else
							{ 
								//调用取消接口
								//alert("取消 服务是scancelInDB_pt 这个服务在页面一开始就会调用一次 是预占，后面一次是取消预占");
								var pactket1 = new AJAXPacket("sdis_ocpy.jsp","正在进行发票预占取消，请稍候......");
								//alert("1 服务里应该是按流水改状态 不是插入了");
								pactket1.data.add("ocpy_begin_no","<%=ocpy_begin_no%>");
								pactket1.data.add("bill_code","<%=bill_code%>");
								pactket1.data.add("paySeq","<%=paySeq%>");
								pactket1.data.add("bill_code","<%=bill_code%>");
								pactket1.data.add("op_code","1322");
								pactket1.data.add("phoneNo","<%=unit_id%>");
								pactket1.data.add("contractno","0");
								pactket1.data.add("payMoney","0");
								pactket1.data.add("userName","");
								core.ajax.sendPacket(pactket1,retsWLWI);
								//core.ajax.sendPacket(pactket1);
								pactket1=null;
							}
							
						}
						else
						{
							rdShowMessageDialog("请勾选欲开具发票的集团信息!");
							return false;
						}
					}

					/*
					算法：
					如果是全部选中 则全选按钮可用 发票打印按钮为灰
					如果不是全选状态 则全选按钮为灰 发票打印按钮可用
					*/
					function test_check_all()
					{
						/*
						document.all.jtfpdy_all.disabled=true;
						document.all.jtfpdy.disabled=true;
						var regionChecks = document.getElementsByName("regionCheck");
						for(var i=0;i<regionChecks.length;i++)
						{
							if(regionChecks[i].checked &&i==regionChecks.length-1)
							{
								document.getElementById("check_not_id").checked=false;
								document.all.jtfpdy_all.disabled=false;
								document.all.jtfpdy.disabled=true;
							}
							else
							{
								document.getElementById("check_all_id").checked=false;
								document.all.jtfpdy_all.disabled=true;
								document.all.jtfpdy.disabled=false;
							}
						}*/
						document.getElementById("check_all_id").checked=false;
					//	document.all.jtfpdy_all.disabled=true;
						document.all.jtfpdy.disabled=false;
						 
					}
				</script>

				<FORM method=post name="frm1508_2">
				<%@ include file="/npage/include/header.jsp" %>
				 
				<div class="title">
					<div id="title_zi">查询结果</div>
				</div>
					 
					  <table cellspacing="0"  >
								<tr> 
								  <th>虚拟集团号码</th>
								  <th>虚拟集团名称</th>
								  <th>可开具金额</th>
								  <th>开票项目</th>
								</tr>
								<tr>
									<td ><%=unit_id%></td>
									<td><%=s_result[0][2]%>
									<input type="hidden" value="<%=s_result[0][2]%>" name="grpname"></td>
									<td> <input type="text" id="s_sum" name="s_sum1" readonly></td>
							 
									<td><input type="text" name="items"></td>
									<input type="hidden" id="u_id" value="<%=unit_id%>">
									<input type="hidden" id="u_name" value="<%=s_result[0][2]%>">
								</tr>
								<tr> 
								  <th>集团成员手机号码</th>
								  <th>集团成员账户号码</th>
								  <th>集团成员名称</th>
								  <th>发票可开具金额</th>
							 
								  <th>
									 
									<input type="checkbox" id="check_all_id" onclick="doSelectAllNodes()">全选 &nbsp;&nbsp;&nbsp;&nbsp;
									<input type="checkbox" id="check_not_id" onclick="doCancelChooseAll()">取消全选 
								 <input type="hidden" id="phone_id" name="grp_phone_no_new">
								 <input type="hidden" id="contract_id" name="grp_contract_no">
								 <input type="hidden" id="s_money_id" name="s_money"> 
								 <input type="hidden" id="s_loginaccept_id" name="s_accepts">
								  </th>
								</tr>
						<%
							for(int y=0;y<s_1322qry.length;y++)
							{
								inParas_detail[1]="contract_no="+s_1322qry[y][1];
								%>
								 <wtc:service name="TlsPubSelBoss" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode1" retmsg="retMsg1" outnum="2">
									<wtc:param value="<%=inParas_detail[0]%>"/>
									<wtc:param value="<%=inParas_detail[1]%>"/>
								</wtc:service>
								<wtc:array id="result1_name" scope="end" />
								
									<tr>
										<td><input type="hidden" id="s_phone<%=y%>" value="<%=s_1322qry[y][0]%>"><%=s_1322qry[y][0]%></td>
										<td><input type="hidden" id="s_contract<%=y%>" value="<%=s_1322qry[y][1]%>"><%=s_1322qry[y][1]%></td>
										<td><%=result1_name[0][0]%></td>
										<td><input type="text" id="s_money<%=y%>" value="<%=s_1322qry[y][2]%>" readonly ></td>
										 <input type="hidden" id="s_accept<%=y%>" value="<%=s_1322qry[y][3]%>" readonly > 
										<td><input type="checkbox" name="regionCheck" id="chks<%=y%>" onclick="test_check_all()"></td>
									</tr>
								<%
								
							}
						%>
						
						  <tr id="footer"> 
							<td colspan="5">
							 
							  <input class="b_foot" id="jtfpdy" onClick="doCfm() " type=button value=集团发票打印>
							 <!--
							  <input class="b_foot" id="jtfpdy_all" onClick="doCfm_all() " type=button value=全选集团发票打印>
							  -->
							  <input class="b_foot" name=back onClick="window.location = 's1322.jsp'  " type=button value=返回>
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
		
	}
	else
	{
		%>
			<script language="javascript">
				rdShowMessageDialog("查询服务调用失败!错误原因:"+"<%=sCode3%>,错误代码:"+"<%=sMsg3%>");
				window.location.href="s1322.jsp";
				//return false;
			</script>
		<%
	}
%>
<!--end of for s1322Left-->


 
 
		

 

 

 



