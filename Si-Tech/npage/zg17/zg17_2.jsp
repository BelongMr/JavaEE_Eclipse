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
	String opCode = "zg17";
    String opName = "�½ᷢƱ��ӡ";
	String orgCode = (String)session.getAttribute("orgCode");
	String regionCode = orgCode.substring(0,2);
	String workno = (String)session.getAttribute("workNo");
	String workname = (String)session.getAttribute("workName");
	String nopass = (String)session.getAttribute("password");

	  String phoneno=request.getParameter("contract_no");
	  //��ʼ ����
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
			<HEAD><TITLE>�½ᷢƱ��ӡ��ѯ���</TITLE>
			</HEAD>
			<body>


			<FORM method=post name="frm1508_2">
			<%@ include file="/npage/include/header.jsp" %>
			<div class="title">
				<div id="title_zi">��ѯ���</div>
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
	  inParas2[6]="";//�û�����
	  inParas2[7]="�½�ͨ�û���Ʊ��ӡ";
	  inParas2[8]=s_time;
	  inParas2[9]=print_begin;
	  //xl add for xuxza �ַ���Ϊzhouwy�ӿڴ���
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
			//s_flag="N";
			//xl add �����Ʊ�ɴ�ӡ���>0 ����з�ƱԤռ
			 	
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
						var return_page="zg17_1.jsp?activePhone="+"<%=phoneno%>";
						//var czfx=document.getElementById("czfx").value ;
						//new
						var s_ret_code  =  packet.data.findValueByName("s_ret_code");
						var s_ret_msg  =  packet.data.findValueByName("s_ret_msg");
						if(s_invoice_flag=="1")
						{
							rdShowMessageDialog("Ԥռ�ӿڵ����쳣!");
							window.location.href= return_page ;
						}
						else
						{
							if(s_invoice_flag=="0")
							{
								var prtFlag=0;
								prtFlag=rdShowConfirmDialog("��ǰ��Ʊ������"+ocpy_begin_no+",��Ʊ������"+bill_code+",�Ƿ��ӡ��Ʊ?");
								if (prtFlag==1)
								{
									document.frm1508_2.action="zg17_3.jsp?check_seq="+ocpy_begin_no+"&bill_code="+bill_code;
									document.frm1508_2.submit();
								}
								else
								{
									var pactket2 = new AJAXPacket("../zg17/sdis_ocpy.jsp","���ڽ��з�ƱԤռȡ�������Ժ�......");
									//alert("1 ������Ӧ���ǰ���ˮ��״̬ ���ǲ�����");
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
								rdShowMessageDialog("��ƱԤռʧ��!����ԭ��:"+s_ret_msg,0);
								window.location.href="zg17_1.jsp?activePhone="+"<%=phoneno%>";
							 
							}
						}
					 }
					 function doqx(packet)
					 {
						var s_flag = packet.data.findValueByName("s_flag");	
						var s_code = packet.data.findValueByName("s_code");	//ò��ûɶ��
						var s_note = packet.data.findValueByName("s_note");	
						var s_invoice_code  = packet.data.findValueByName("s_invoice_code");//ò��Ҳûɶ��	
						var return_page="zg17_1.jsp?activePhone="+"<%=phoneno%>";
						if(s_flag=="1")
						{
							rdShowMessageDialog("Ԥռȡ���ӿڵ����쳣!");
							window.location.href=return_page;
						}
						else
						{
							if(s_flag=="0")
							{
								rdShowMessageDialog("��ƱԤռȡ���ɹ�,��ӡ���!",2);
								window.location.href=return_page;
							}
							else
							{
								rdShowMessageDialog("��ƱԤռʧ��! �������:"+s_code,0);
								window.location.href=return_page;
								 
							}
						}
					 }
	 
					function left_input()
					{
						rdShowMessageDialog("������û���Ʊ,��¼����Ʊ���!��Ʊ������¼��һ��,��ȷ�Ϻý�")
						if(document.frm1508_2.left_invoice.value=="")
					    {
						   rdShowMessageDialog("��¼����Ʊ���!");
						   return false;
					    }
					    else
					    {
						   var prtFlag=0;
						   prtFlag=rdShowConfirmDialog("����¼����"+document.frm1508_2.left_invoice.value+"Ԫ���Ƿ�ȷ��¼����Ʊ��Ϣ?");
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
							rdShowMessageDialog("�½ᷢƱ���Ϊ0���������û���Ԥ�淢Ʊ�����´�ӡ�½ᷢƱ!");
							//return false;
						}		
						else
						{
							//���ӷ�Ʊbegin
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
								pactket1.data.add("paySeq","<%=result_1[0][13]%>");
								pactket1.data.add("op_code","zg17");
								pactket1.data.add("phoneNo","<%=phoneno%>");
								pactket1.data.add("contractno","0");
								pactket1.data.add("payMoney","<%=result_1[0][12]%>");
								pactket1.data.add("userName","<%=result_1[0][2]%>");
								core.ajax.sendPacket(pactket1,doyz);
								pactket1=null;
							}
							else if(returnValue=="3")
							{
								
								//alert("���ӵ�");
								var txfwf = document.all.txfwf.value;//ͨ�ŷ����
								var xszk = document.all.xszk.value;//�����ۿ�
								var yckykjje = document.all.yckykjje.value;//Ԥ����ѳ��߷�Ʊ���
								var czkykjje = document.all.czkykjje.value;//��ֵ���ѳ��߷�Ʊ��� 	
								var xtcz = document.all.xtcz.value;//ϵͳ����
								var hytcf = document.all.hytcf.value;//��Լ�ײͷ�
								var s_flag = "<%=s_flag%>";//Y=�к�Լ�ײͷ�
								
								var s_kpxm="";//"zg17�½ᷢƱ��ӡ";
								var s_xmdj="<%=result_1[0][12]%>";
								var s_xmje="<%=result_1[0][12]%>";
								var s_hsbz="";//��˰��־ 1=��˰
								var s_sl="";//��0����
								var s_se="";
								var s_xmsl="";
								var xmdw="";
								var s_ggxh="";
								var s_ycjqt="<%=result_1[0][11]%>";
								var s_zg17_note="";//�ŵ���ע��
								/*
								if(s_flag=="Y")
								{
									s_zg17_note="ͨ�ŷ����:"+txfwf+",�����ۿ�:"+xszk+",Ԥ����ѳ��߷�Ʊ���:"+yckykjje+",��ֵ���ѳ��߷�Ʊ���:"+czkykjje+",ϵͳ����:"+xtcz+",��Լ�ײͷ�:"+hytcf;
									 
								}
								else
								{
									s_zg17_note="ͨ�ŷ����:"+txfwf+",�����ۿ�:"+xszk+",Ԥ����ѳ��߷�Ʊ���:"+yckykjje+",��ֵ���ѳ��߷�Ʊ���:"+czkykjje+",ϵͳ����:"+xtcz;
								}
								s_xmje=s_xmdj;
								s_hsbz="1";
								s_sl="*";
								s_se="0";
								s_xmsl="1";
								xmdw="";
								s_ggxh="";
								s_kpxm=s_zg17_note;*/
								//s_kpxm="�½ᷢƱ����";<%=result_1[0][11]%>
								 
								if(s_flag=="Y")
								{
									s_kpxm="ͨ�ŷ����,�����ۿ�,Ԥ����ѳ��߷�Ʊ���,��ֵ���ѳ��߷�Ʊ���,ϵͳ����,��Լ�ײͷ�,�ѳ�������";
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
									s_kpxm="ͨ�ŷ����,�����ۿ�,Ԥ����ѳ��߷�Ʊ���,��ֵ���ѳ��߷�Ʊ���,ϵͳ����,�ѳ�������";
									s_xmdj=txfwf+","+xszk+","+yckykjje+","+czkykjje+","+xtcz+","+s_ycjqt;
									s_xmje=s_xmdj;
									s_hsbz="1,1,1,1,1,1";
									s_sl="*,*,*,*,*,*";
									s_se="0,0,0,0,0,0";
									s_xmsl="1,1,1,1,1,1";
									xmdw=",,,,,";
									s_ggxh=",,,,,";
								}
								*/
								else
								{
									s_kpxm="ͨ�ŷ����";
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
								var s_jsheje="<%=result_1[0][12]%>";//��˰�ϼƽ��
								var s_hjbhsje=0;//�ϼƲ���˰���
								var s_hjse=0;
								var s_xmmc=s_kpxm;
								
								
								//����
								var dyzq = document.getElementById("dyzq").value;
								var op_code="zg17";
								var payaccept="<%=result_1[0][13]%>";
								var id_no="0";
								var sm_code="0";
								var phone_no="<%=phoneno%>";
								var pay_note=s_kpxm+",��������:"+dyzq;
								var returnPage="../zg17/zg17_1.jsp?activePhone="+phone_no;
								var chbz="1";
								var contractno="0";
								var kphjje="<%=result_1[0][12]%>";
								//alert("test pay_note is "+pay_note);
								document.frm1508_2.action="PrintInvoice_dz.jsp?s_kpxm="+s_kpxm+"&s_ghmfc="+s_ghmfc+"&s_jsheje="+s_jsheje+"&hjse="+s_hjse+"&s_xmmc="+s_xmmc+"&s_ggxh="+s_ggxh+"&s_hsbz="+s_hsbz+"&s_xmdj="+s_xmdj+"&s_xmje="+s_xmje+"&s_sl="+s_sl+"&s_se="+s_se+"&op_code="+op_code+"&payaccept="+payaccept+"&id_no="+id_no+"&sm_code="+sm_code+"&phone_no="+phone_no+"&pay_note="+pay_note+"&chbz="+chbz+"&returnPage="+returnPage+"&xmsl="+s_xmsl+"&contractno="+contractno+"&hjbhsje="+s_hjbhsje+"&kphjje="+kphjje+"&xmdw="+xmdw+"&dyzq="+dyzq;
								document.frm1508_2.submit(); 
								
							}
							else
							{
								var paySeq="<%=result_1[0][13]%>";
								var phoneno="<%=phoneno%>";
								var kphjje="<%=result_1[0][12]%>";//��Ʊ�ϼƽ��
								var s_hjbhsje=0;//�ϼƲ���˰���
								var s_hjse=0;
								var contractno="0";
								var id_no="0";
								var sm_code="0";
								var s_xmmc="<%=opName%>";//��Ŀ���� crm����Ϊ����? ����zg17������ô����
								var opCode="zg17";
								var return_page = "../zg17/zg17_1.jsp?activePhone="+phoneno;
								document.frm1508_2.action="../s1300/PrintInvoice_qx.jsp?opCode="+opCode+"&paySeq="+paySeq+"&phoneno="+phoneno+"&kphjje="+kphjje+"&s_hjbhsje="+s_hjbhsje+"&hjse="+s_hjse+"&returnPage="+return_page+"&hsbz=1&xmdj="+kphjje+"&contractno="+contractno+"&id_no="+id_no+"&sm_code="+sm_code+"&chbz=1&s_xmmc="+s_xmmc+"&paynote=zg17";
								
								document.frm1508_2.submit();
							}
							//end ���ӷ�Ʊ
							 
						}
					}
				</script>
					  <table cellspacing="0" id = "PrintA">
							<tr> 
							  <td>�ͻ�����</td><td><%=result_1[0][2]%></td>
							  <input type="hidden" name="cust_name" value="<%=result_1[0][2]%>">
							  <td>�ͻ�Ʒ��</td><td><%=result_1[0][3]%></td>
							  <input type="hidden" name="sm_name" value="<%=result_1[0][3]%>">
							</tr>
							<tr> 
							  <td>ͨ�ŷ����</td><td><%=result_1[0][4]%></td>
							  <td>�����ۿ�</td><td><%=result_1[0][5]%></td>
							   <input type="hidden" name="txfwf" value="<%=result_1[0][4]%>">
								<input type="hidden" name="xszk" value="<%=result_1[0][5]%>">
							</tr>
							<tr> 
							  <td>�ϼ�</td><td><%=result_1[0][6]%></td> 
							  <input type="hidden" name="hj" value="<%=result_1[0][6]%>">
							  <td>�ѿ��߷�Ʊ���</td><td><%=result_1[0][7]%></td>
							  <input type="hidden" name="ykjje" value="<%=result_1[0][7]%>">	
							</tr>
							<tr> 
							  <td>Ԥ����ѳ��߷�Ʊ���</td><td><%=result_1[0][8]%></td>
							  <input type="hidden" name="yckykjje" value="<%=result_1[0][8]%>">
							  <td>��ֵ���ѿ��߽��</td><td><%=result_1[0][9]%></td>
							  <input type="hidden" name="czkykjje" value="<%=result_1[0][9]%>">
							</tr>
							<tr>
							  <td>����ϵͳ���ͽ��</td><td><%=result_1[0][10]%></td>	
							  <td>����</td><td><%=result_1[0][11]%></td>
							  <input type="hidden" name="xtcz" value="<%=result_1[0][10]%>">
							  <input type="hidden" name="qt" value="<%=result_1[0][11]%>">
							</tr>
							<tr>
							  <td>���η�Ʊ���</td><td><%=result_1[0][12]%></td>	
							  <td>��ӡ��ˮ</td><td><%=result_1[0][13]%></td>
							   <input type="hidden" name="invoice_money" value="<%=result_1[0][12]%>">
							   <input type="hidden" name="login_accept" value="<%=result_1[0][13]%>">
							   <input type="hidden" name="phoneno" value="<%=phoneno%>">
							   <input type="hidden" name="print_begin" value="<%=print_begin%>">
							   <input type="hidden" name="s_time" value="<%=s_time%>">
							   <input type="hidden" name="hytcf" value="<%=result_1[0][15]%>">
							   <input type="hidden" name="s_flag" value="<%=s_flag%>">
							   
							   
							</tr>
							<tr>
							  <td>��ӡ����</td><td><%=result_1[0][14]%></td>
							  <input type="hidden" id="dyzq" value="<%=result_1[0][14]%>">
							  <td>��Լ�ײͷ�</td><td><%=result_1[0][15]%></td>
							</tr>
							<!--
							<tr>
							  <td>�û���Ʊ</td><td colspan=3><input type="text" name="left_invoice">&nbsp;&nbsp;
							  <input type="button"  class="b_foot" value="��Ʊ¼��" onclick="left_input()" ></td>
							</tr>
							-->
						 <tr id="footer"> 
							<td colspan="9">
							  <input class="b_foot" id="dayin" onClick="doPrint()" type=button value=��ӡ>	
							  <input class="b_foot" name=back onClick="window.location = 'zg17_1.jsp?activePhone=<%=phoneno%>' " type=button value=����>
							  <input class="b_foot" name=back onClick="window.close();" type=button value=�ر�>
						
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
					rdShowMessageDialog("��ѯʧ��,�������:"+"<%=s_code%>"+",����ԭ��:"+"<%=s_msg%>");
					document.location.replace('zg17_1.jsp?activePhone=<%=phoneno%>');
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
				rdShowMessageDialog("��ѯʧ��,�������:"+"<%=retCode_1%>"+",����ԭ��:"+"<%=retMsg_1%>");
				document.location.replace('zg17_1.jsp?activePhone=<%=phoneno%>');
			</script>
		<%
	}
%>

	 
 

