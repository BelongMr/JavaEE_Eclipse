<%
/********************
 version v2.0
������: si-tech
*
*update:zhanghonga@2008-08-15 ҳ�����,�޸���ʽ
*
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=GB2312" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="java.text.*" %> 
<%@ page import="java.util.*" %>
<%@ page import="com.sitech.util.MoneyUtil"%>
<%
		String opCode = "zg55";
		String opName = "�ϰ漯�ŷ�Ʊ��ӡ";
		MoneyUtil mon = new MoneyUtil();
		String workno = (String)session.getAttribute("workNo");
		String orgCode = (String)session.getAttribute("orgCode");
		String regionCode = orgCode.substring(0,2);

	String tem1 = request.getParameter("tem1");
	String tem2 = request.getParameter("tem2");
	String tem3 = request.getParameter("tem3");
    String tem4 = request.getParameter("tem4");
    String tem5 = request.getParameter("tem5");
    String tem6 = request.getParameter("tem6");
    String tem7 = request.getParameter("tem7");
    String tem8 = request.getParameter("tem8");
    String tem9 = request.getParameter("tem9");
 String seq_num = request.getParameter("seq_num");
	String[] inParas = new String[10];
    inParas[0] = workno;
	inParas[1] = tem1;
	inParas[2] = tem3;
	inParas[3] = tem2;
	inParas[4] = tem4;
	inParas[5] = tem5;
	inParas[6] = tem6;
	inParas[7] = tem7;
	inParas[8] = tem8;
	inParas[9] = tem9;
	
	String loginAccept="";
	String sql_acc="SELECT to_char(sMaxPayAccept.nextval) FROM Dual ";
 
	 %>
     
	<wtc:service name="s1322Print" routerKey="region" routerValue="<%=regionCode%>" retcode="iErrorNo1" retmsg="sErrorMessage" outnum="1" >
		<wtc:param value="<%=inParas[0]%>"/>
		<wtc:param value="<%=inParas[1]%>"/>
		<wtc:param value="<%=inParas[2]%>"/>
		<wtc:param value="<%=inParas[3]%>"/>
		<wtc:param value="<%=inParas[4]%>"/>
		<wtc:param value="<%=inParas[5]%>"/>
		<wtc:param value="<%=inParas[6]%>"/>
		<wtc:param value="<%=inParas[7]%>"/>
		<wtc:param value="<%=inParas[8]%>"/>
		<wtc:param value="<%=inParas[9]%>"/>
	</wtc:service>
	<wtc:array id="s_result" scope="end" />
<%
	//xl add s1322Printִ�гɹ������ִ�к����
	System.out.println("iErrorNo1 aaaaaaaaaaaaaaaaaaaaaaa s_result is"+s_result[0][0] +"and iErrorNo1 is "+iErrorNo1+" and iErrorNo1 is "+iErrorNo1);
	if(iErrorNo1=="000000" ||iErrorNo1.equals("000000"))
	{
		//xl add ��ƱԤռ
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
		String sparas_accept[] = new String[1]; 
		sparas_accept[0]="select to_char(sMaxPayAccept.nextval) from dual";
		String op_code="zg55";
		String op_note="���ŷ�Ʊ��ӡ";
		 
	%>
	<wtc:service name="TlsPubSelBoss" routerKey="region" routerValue="<%=regionCode%>" retcode="sCode2_accept" retmsg="sMsg2_accept" outnum="1" >
		<wtc:param value="<%=sparas_accept[0]%>"/>
	</wtc:service>
	<wtc:array id="s_invoice_accept" scope="end"/>
	<%
		paySeq=s_invoice_accept[0][0];
	%>
 
	<script language="javascript">
	 function doqx(packet)
	 {
		var s_flag = packet.data.findValueByName("s_flag");	
		var s_code = packet.data.findValueByName("s_code");	//ò��ûɶ��
		var s_note = packet.data.findValueByName("s_note");	
		var s_invoice_code  = packet.data.findValueByName("s_invoice_code");//ò��Ҳûɶ��	
		//alert("s_flag is "+s_flag+" and s_code is "+s_code+" and s_note is "+s_note);
		//s_flag="1";
		//alert("s_flag is "+s_flag+" and s_code is "+s_code+" and s_note is "+s_note);
		if(s_flag=="1")
		{
			rdShowMessageDialog("Ԥռȡ���ӿڵ����쳣!");
			window.location.href="zg55_1.jsp";
		}
		else
		{
			if(s_flag=="0")
			{
				rdShowMessageDialog("��ƱԤռȡ���ɹ�,��ӡ���!",2);
				window.location.href="zg55_1.jsp";
			}
			else
			{
				rdShowMessageDialog("��ƱԤռʧ��! �������:"+s_code,0);
 
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
		//new
		var s_ret_code  =  packet.data.findValueByName("s_ret_code");
		var s_ret_msg  =  packet.data.findValueByName("s_ret_msg");
		if(s_invoice_flag=="1")
		{
			rdShowMessageDialog("Ԥռ�ӿڵ����쳣!");
			window.location.href="zg55_1.jsp";
		}
		else
		{
			if(s_invoice_flag=="0")
			{
				var prtFlag=0;
				prtFlag=rdShowConfirmDialog("��Ʊ���߳ɹ�!��ǰ��Ʊ������"+ocpy_begin_no+",��Ʊ������"+bill_code+",�Ƿ��ӡ��Ʊ?");
				if (prtFlag==1)
				{
					var infoStr="";
					infoStr+="<%=workno%>"+"|"; 
					infoStr+='<%=new java.text.SimpleDateFormat("yyyy", Locale.getDefault()).format(new java.util.Date())%>'+"|";
					infoStr+='<%=new java.text.SimpleDateFormat("MM", Locale.getDefault()).format(new java.util.Date())%>'+"|";
					infoStr+='<%=new java.text.SimpleDateFormat("dd", Locale.getDefault()).format(new java.util.Date())%>'+"|";
					infoStr+='<%=tem1%>'+"|";
					infoStr+="<%=tem3%>"+"|";
					infoStr+='<%=tem2%>'+"|"; 
					infoStr+=" "+"|"; 
					infoStr+="<%=tem4%>"+"|";

					infoStr+="<%=tem8%>"+"|";
					infoStr+="<%=mon.NumToRMBStr(Double.parseDouble(tem8))%>"+"|";//Сд
					infoStr+="<%=tem5%>"+"|";
					infoStr+="<%=tem6%>"+"|";
					infoStr+="<%=tem7%>"+"|";
					infoStr+="<%=tem9%>"+"|";
					dirtPate = "../zg55/zg55_1.jsp";
					document.location.replace("../../npage/public/hljBillPrintNew_1322.jsp?retInfo="+infoStr+"&dirtPage="+dirtPate+"&op_code=1322&loginAccept=<%=paySeq%>&bill_code="+bill_code+"&ocpy_begin_no="+ocpy_begin_no);
					
				}
				else
				{
					var pactket2 = new AJAXPacket("../s1300/sdis_ocpy.jsp","���ڽ��з�ƱԤռȡ�������Ժ�......");
					//alert("1 ������Ӧ���ǰ���ˮ��״̬ ���ǲ�����");
					pactket2.data.add("ocpy_begin_no",ocpy_begin_no);
					pactket2.data.add("bill_code",bill_code);
					pactket2.data.add("paySeq","<%=paySeq%>");
					pactket2.data.add("bill_code",bill_code);
					pactket2.data.add("op_code","<%=op_code%>");
					pactket2.data.add("phoneNo","<%=tem2%>");
					pactket2.data.add("contractno","0");
					pactket2.data.add("payMoney","<%=tem8%>");
					pactket2.data.add("userName","<%=tem1%>");
					//alert("2 "+pactket1.data);
					 
					core.ajax.sendPacket(pactket2,doqx);
				 
					pactket2=null;
				}
			}
			else
			{
				rdShowMessageDialog("zg55��ƱԤռʧ��!����ԭ��:"+s_ret_msg,0);
				window.location.href="zg55_1.jsp";
			}
		}
	 }
		function ifprint()
		{
			var h=480;
			var w=650;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
			var path="../s1300/select_invoice.jsp";
			var returnValue = window.showModalDialog(path,"",prop);
			if(returnValue=="1")
			{
				var pactket1 = new AJAXPacket("../s1300/sfp_ocpy.jsp","���ڽ��з�ƱԤռ�����Ժ�......");
				pactket1.data.add("ocpy_begin_no","<%=ocpy_begin_no%>");
				pactket1.data.add("bill_code","<%=bill_code%>");
				pactket1.data.add("paySeq","<%=paySeq%>");
				pactket1.data.add("bill_code","<%=bill_code%>");
				pactket1.data.add("op_code","<%=opCode%>");
				pactket1.data.add("phoneNo","<%=tem3%>");
				pactket1.data.add("contractno","<%=tem2%>");
				pactket1.data.add("payMoney","<%=tem8%>");
				pactket1.data.add("userName","<%=tem1%>");
				core.ajax.sendPacket(pactket1,doyz);
				pactket1=null;
			}
			else if(returnValue=="3")
			{
				//add by zhangleij 20170628 for sunqy ����������ֵ˰��Ʊ�����йع�����֪ͨ begin
				var h=300;
			  var w=550;
			  var t=screen.availHeight/2-h/2;
			  var l=screen.availWidth/2-w/2;
			  var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
			  var path1="../s1300/getNsrsbh.jsp?param_no="+"<%=tem3%>"+"&param_type=1";
			  var returnValue1 = window.showModalDialog(path1,"",prop);
			  //alert("test returnValue1 is "+returnValue1);
				//add by zhangleij 20170628 for sunqy ����������ֵ˰��Ʊ�����йع�����֪ͨ end
				
				//alert("���ӵ�");
				var s_kpxm="<%=opCode%>"+"<%=opName%>";
				var s_ghmfc="<%=tem1%>";
				var s_jsheje="<%=tem8%>";//��˰�ϼƽ��
				var s_hjbhsje=0;//�ϼƲ���˰���
				var s_hjse=0;
				var s_xmmc="���ӷ�Ʊ����";//��Ŀ���� crm����Ϊ����? ����zg17������ô����
				var s_ggxh="";
				var s_hsbz="1";//��˰��־ 1=��˰
				var s_xmdj="<%=tem8%>";
				var s_xmje="<%=tem8%>";
				var s_sl="*";
				var s_se="0";
				var op_code="zg55";
				var payaccept="<%=paySeq%>";
				var id_no="0";
				var sm_code="0";
				var phone_no="<%=tem3%>";
				var pay_note=s_kpxm;
				var returnPage="../zg55/zg55_1.jsp";
				var chbz="1";
				var contractno="<%=tem2%>";
				var kphjje=s_xmdj;
				//document.frm1508_2.action="../s1300/PrintInvoice_dz.jsp?s_kpxm="+s_kpxm+"&s_ghmfc="+s_ghmfc+"&s_jsheje="+s_jsheje+"&hjse="+s_hjse+"&s_xmmc="+s_xmmc+"&s_ggxh="+s_ggxh+"&s_hsbz="+s_hsbz+"&s_xmdj="+s_xmdj+"&s_xmje="+s_xmje+"&s_sl="+s_sl+"&s_se="+s_se+"&op_code=zg55&sm_code="+sm_code+"&phone_no="+phone_no+"&pay_note=zg55���ŷ�Ʊ��ӡ&chbz=1"+"&returnPage="+returnPage+"&xmsl=1"+"&contractno="+contractno+"&hjbhsje="+s_hjbhsje+"&kphjje="+kphjje;
				//add by zhangleij 20170628 for sunqy ����������ֵ˰��Ʊ�����йع�����֪ͨ begin
				document.frm1508_2.action="../s1300/PrintInvoice_dz.jsp?s_kpxm="+s_kpxm+"&s_ghmfc="+s_ghmfc+"&s_jsheje="+s_jsheje+"&hjse="+s_hjse+"&s_xmmc="+s_xmmc+"&s_ggxh="+s_ggxh+"&s_hsbz="+s_hsbz+"&s_xmdj="+s_xmdj+"&s_xmje="+s_xmje+"&s_sl="+s_sl+"&s_se="+s_se+"&op_code=zg55&sm_code="+sm_code+"&phone_no="+phone_no+"&pay_note=zg55���ŷ�Ʊ��ӡ&chbz=1"+"&returnPage="+returnPage+"&xmsl=1"+"&contractno="+contractno+"&hjbhsje="+s_hjbhsje+"&kphjje="+kphjje+"&s_gmfsbh="+returnValue1;
				//add by zhangleij 20170628 for sunqy ����������ֵ˰��Ʊ�����йع�����֪ͨ end
				document.frm1508_2.submit(); 
				
			}
			else
			{
				var paySeq="<%=paySeq%>";
				var phoneno="<%=tem3%>";
				var kphjje="<%=tem8%>";//��Ʊ�ϼƽ��
				var s_hjbhsje=0;//�ϼƲ���˰���
				var s_hjse=0;
				var contractno="<%=tem2%>";
				var id_no="0";
				var sm_code="0";
				var s_xmmc="<%=opName%>";//��Ŀ���� crm����Ϊ����? ����zg17������ô����
				var opCode="<%=opCode%>";
				var return_page = "../zg55/zg55_1.jsp";
				document.frm1508_2.action="../s1300/PrintInvoice_qx.jsp?opCode="+opCode+"&paySeq="+paySeq+"&phoneno="+phoneno+"&kphjje="+kphjje+"&s_hjbhsje="+s_hjbhsje+"&hjse="+s_hjse+"&returnPage="+return_page+"&hsbz=1&xmdj="+kphjje+"&contractno="+contractno+"&id_no="+id_no+"&sm_code="+sm_code+"&chbz=1&s_xmmc="+s_xmmc+"&paynote=�ɷ�";
				
				document.frm1508_2.submit();
			}

 

 
	}

 
	  
	</script>

	<HTML>
	<HEAD>
	<TITLE>�ϰ漯�ŷ�Ʊ��ӡ</TITLE>
	</HEAD>
	<body onload="ifprint()">


	<FORM method=post name="frm1508_2">
	<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">��ѯ���</div>
	</div>

	 <%@ include file="/npage/include/footer.jsp" %>
	</FORM>
	</BODY></HTML>
	<%
	}
	else
	{
		%>
			<script language="javascript">
				rdShowMessageDialog("���ŷ�Ʊ��ӡ���򱨴�! �������:"+"<%=iErrorNo1%>",0);
				window.location.href="zg55_1.jsp";
			</script>
		<%
	}
%>

