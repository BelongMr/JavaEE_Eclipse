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
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="../../npage/bill/getMaxAccept.jsp" %>
<script language="javascript">
	var prepay_fee_all = new Array();
	var transin_fee = new Array();//where���� �� projectCode Ҫ��ѯ��ʾ���� fee
	var i_contract_no = new Array();
</script>

<%
	String workno = (String)session.getAttribute("workNo");
    String workname = (String)session.getAttribute("workName");
	String opCode = "e832";
	String opName = "���Ų�Ʒת��";
 	String[][] result = new String[][]{}; 
	String zjhm = request.getParameter("zjhm");	
	String accountid = request.getParameter("accountid");	
 	String phoneNo1 =  request.getParameter("phoneNo1");
	String khid = request.getParameter("khid");
	String jtbh = request.getParameter("jtbh");
	String jtmc = request.getParameter("jtmc");
	String jtcpmc = request.getParameter("jtcpmc");
	//xl add for sm_code
	String sm_code = request.getParameter("sm_code");
	System.out.println("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa e832 sm_code is "+sm_code);
    /****�õ���ӡ��ˮ****/
	String printAccept="";
	printAccept = getMaxAccept();

	String inParas[] = new String[2]; //��ѯ��Ʒ�˺ŵ�sql
	/*
	inParas[0] ="select to_char(d.account_id),to_char(user_no),f.offer_name from dgrpusermsg d,product_offer f where d.run_code!='a' and f.offer_id=to_number(d.product_code) and  d.cust_id =:cust_id and d.account_id <> :khid";
	inParas[1] ="cust_id="+khid+",khid="+accountid;
	*/
	inParas[0] ="select to_char(d.account_id),to_char(user_no),f.offer_name,d.sm_code from dgrpusermsg d,product_offer f where d.run_code!='a' and f.offer_id=to_number(d.product_code) and  d.cust_id =:cust_id and d.account_id <> :khid ";
	inParas[1] ="cust_id="+khid+",khid="+accountid;
%> 
<wtc:service name="TlsPubSelCrm" retcode="sretCode2" retmsg="sretMsg2" outnum="4">
    <wtc:param value="<%=inParas[0]%>"/> 
    <wtc:param value="<%=inParas[1]%>"/>  
</wtc:service>
<wtc:array id="SpecResult" scope="end" />

<wtc:service name="se832Init" retcode="sretCode" retmsg="sretMsg" outnum="9">
    <wtc:param value="<%=accountid%>"/> 
    <wtc:param value="<%=khid%>"/>  
 
 
</wtc:service>
<wtc:array id="ret_val" scope="end" />
<wtc:array id="result2" start="5" length="4" scope="end"/>
 
<html>
<HEAD><TITLE>���Ų�Ʒת��</TITLE>
</HEAD>
<body  >
<FORM method=post name="form" >
	<%@ include file="/npage/include/header.jsp" %>
	
	<%
		System.out.println("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA sretCode is "+sretCode);
		String return_code =ret_val[0][0];
		String return_message = ret_val[0][1];
		//String error_msg = SystemUtils.ISOtoGB(ErrorMsg.getErrorMsg(return_code));
		String return_money="";
		if((!return_code.equals("000000")))
		{
			%>
				<script language="javascript">
					//rdShowMessageDialog("<%=sretMsg%>");
					rdShowMessageDialog("��ѯ����<br>������룺'<%=return_code%>'��<br>������Ϣ��'<%=return_message%>'��",0);
					//window.location='e832_1.jsp';
					history.go(-1);
				</script>
			<%
		}
		else
		{
			if(ret_val==null||ret_val.length==0 || result2==null||result2.length==0)
			{
				%>�޼�¼<%
			}
			else
			{
				return_money=ret_val[0][2];
				%>
				<div class="title">
					<div id="title_zi">���Ų�Ʒ�˻���Ϣ</div>
				</div>
					<table cellspacing="0">
						<tr>
							<td class="blue">���Ų�Ʒ����</td>
							<td class="blue">
								<input type="text" name="grpName" class="InputGrey" readonly value="<%=ret_val[0][3]%>">
							</td>
							<td class="blue">���ź���</td>
							<td class="blue">
								<input type="text" name="grpphoneNo" id="grp_phone_id" class="InputGrey" readonly value="<%=phoneNo1%>">
								<input type="hidden" name="grpconNo" value="<%=accountid%>">  
								<input type="hidden" name="custid" value="<%=khid%>">
							</td>
						</tr>
						<tr>
							<td class="blue">δ��Ƿ��</td>
							<td colspan="3">
								<input type="text" name="cur_owe" class="InputGrey" readonly value="<%=ret_val[0][4]%>">
							</td>
						</tr>
					</table>
					<br>
					<div class="title">
						<div id="title_zi">���Ų�ƷԤ����ϸ</div>
					</div>
					<table cellspacing="0" >
						<tr>
						<th>
							<div align="center">Ԥ������</div>
						</th> 
						<th>
							<div align="center">Ԥ����</div>
						</th>
						<th>
							<div align="center">˳��</div>
						</th>
						<th>
							<div align="center">�Ƿ����</div>
						</th>
						</tr>
						<tr>
						<%
							for(int y=0;y<result2.length;y++){
							String tdClass = ((y%2)==1)?"Grey":"";
						%>
						<%
							for(int j=0;j<result2[0].length;j++)
							{
						%>
						<td height="25" class="<%=tdClass%>"><div align="center"><%= result2[y][j]%></div></td>
						<%	}
						%>
						</tr>
						<%
						}
						%>
					</table>

					<br>
					<div class="title">
						<div id="title_zi">ת����ϸ</div>
					</div>
					<table cellspacing="0">
						<tr>
							<td class="blue">ת���˺�</td>
							<td  >
								<select style="width:353px" name="trans_contract" onchange="getPhone(this,project_code,transin_fee,smCodeArray)" >
									<option value="0" selected>--->��ѡ��</option>
									<%
										//System.out.println("AAAAAAAAAAASSSSSSSSSSSSSSS SpecResult.length is "+SpecResult.length);
										for(int i=0; i<SpecResult.length; i++)
										{%>
											<option value="<%=SpecResult[i][0]%>">
												<%=SpecResult[i][0]%>--><%=SpecResult[i][2]%>
											</option>
										<%
										 }
									%>
								</select>
								<input type="hidden" name="zczh" id="zczhid">
								<input type="hidden" name="zcpmName" id="zcpm">
							</td>
						    <td class="blue">ת�����<input id="cz" type="text" class="InputGrey" name = "zchm" readonly> </td> 
						</tr>
						<tr>
							<td class="blue">��ת����</td>
							<td>
								<input class="InputGrey" readonly name=remark2 value="<%=ret_val[0][2]%>">
							</td>
							<td class="blue">ת���� 
								<input class="button" name=return_money value="<%=ret_val[0][2]%>">
							</td>
						</tr>
						<tr>
							<td align=center id="footer" colspan="4">
							<input class="b_foot" name=sure type=button value=ȷ�� onclick="docheck()">
							&nbsp;
							<input class="b_foot" name=clear type=reset value=���>
							&nbsp;
							<input class="b_foot" name=reset type=reset value=���� onClick="history.go(-1)">
							&nbsp; </td>
							<input type="hidden" name="printAccept" value="<%=printAccept%>">

						</tr>
					</table>
				<%
			}
		}
		
	%>
	 
	<%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>
<script language="javascript">
 var project_code = new Array();
 var transin_fee = new Array();//where���� �� projectCode Ҫ��ѯ��ʾ���� fee
 var smCodeArray = new Array();
<%
	System.out.println("qweqwe1888888888888888888888888888881111111111111");
	if(SpecResult.length >0){
		for(int m=0;m<SpecResult.length;m++)
		  {
			out.println("project_code["+m+"]='"+SpecResult[m][0]+"';\n");
			out.println("transin_fee["+m+" ]='"+SpecResult[m][1]+"';\n");
			out.println("smCodeArray["+m+" ]='"+SpecResult[m][3]+"';\n");
			
		  }
	}
	else{
	System.out.println("qweqwe9888800000000000000000111");
	}
	


%>


function getPhone(choose,ItemArray,GroupArray,smArray)
{
	document.getElementById("cz").value ="";
	for ( x = 0 ; x < ItemArray.length  ; x++ )
    {
	  //alert("ItemArray[x] is "+ItemArray[x]+" and choose.value is "+choose.value);
	  if ( ItemArray[x] == choose.value )
	  {
		document.getElementById("cz").value = GroupArray[x];
		document.getElementById("zczhid").value = choose.value;
		document.getElementById("zcpm").value = smArray[x];
	  }
	 	
    }
	//alert("ttt");
}
function docheck()
{
  // alert("sm_code is "+"<%=sm_code%>");
   var zrpmid = document.getElementById("zcpm").value;
   //alert("zrpm is "+zrpmid);
   if("<%=sm_code%>"=="PB")
   {
	 //  alert("1");
	   rdShowMessageDialog("���������벻�����ɷ�!");
	   return false;
   }
   else if ("<%=sm_code%>"=="YC"||"<%=sm_code%>"=="HL"||"<%=sm_code%>"=="ZX") 
   {
		//alert("2");
		if(zrpmid!="YC" &&zrpmid!="HL" &&zrpmid!="ZX")
	    {
			rdShowMessageDialog("��Ʒ�Ʋ��������YC��HL��ZXƷ��ת��");
			return false;
		}
		else
		{
		  // alert("here?");
		   getAfterPrompt();
		   var v_fee = document.form.return_money.value;
		   //alert("v_fee is "+v_fee);
		   var pay_message="ת�ʽ���С��0!";
		   var null_message="ת�ʽ���Ϊ��!";
		   var NaN_message="ת�ʽ��ӦΪ������!";
		   var larger_message="ת�ʽ��ܴ����ʻ�ʣ����!";
		   var pos;
		   if(document.form.trans_contract.value == "0")
		   {
			   rdShowMessageDialog("��ѡ��ת���˺ţ�");
			   return false;
		   }	
		   var contractno2 = document.form.trans_contract.value;
		   if(v_fee == null || v_fee == "")
		   {
				rdShowMessageDialog(null_message);
				document.form.return_money.select();
				return false;
		   }
		   if(v_fee><%=return_money%>)
		   {
				rdShowMessageDialog(larger_message);
				document.form.return_money.select();
				return false;
		   }
		   if(parseFloat(v_fee) <= 0)
		   {
				rdShowMessageDialog(pay_message);
				document.form.return_money.select();
				return false;
		   }
		   if(isNaN(parseFloat(v_fee)))
		   {
				rdShowMessageDialog(NaN_message);
				document.form.return_money.select();
				return false;
		   }
		   if(v_fee>9999999999.99)
		   {
				rdShowMessageDialog("ת�ʽ��ܴ���9999999999.99");
				document.form.return_money.select();
				return false;
		   }
		   pos=v_fee.indexOf(".");
		   if(pos!=-1)
		   {
				if(pos>10)
				{
					rdShowMessageDialog("ת�ʽ��С����ǰ���ܴ���10λ��");
					document.form.return_money.select();
					return false;
				}
				if(v_fee.length-pos>3)
				{
					rdShowMessageDialog("ת�ʽ��С������ܴ���2λ��");
					document.form.return_money.select();
					return false;
				}
		   }
		   else
		   {
				if(v_fee.length>10)
				{
					rdShowMessageDialog("ת�ʽ��С����ǰ���ܴ���10λ��");
					document.form.return_money.select();
					return false;
				}
		   }

		//xl add begin
			var ret = showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes");

			if((ret=="confirm"))
			{
				if(rdShowConfirmDialog('ȷ�ϵ��������')==1)
				{
					  form.action="e832_cfm.jsp";
					  form.submit();
				}

				if(ret=="remark")
				{
					if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
					 {
						   form.action="e832_cfm.jsp";
						   form.submit();
					}
				}

			}
			else
			{
				if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
				{
					 form.action="e832_cfm.jsp";
					 form.submit();
				}
			}

			document.form.sure.disabled=true;
			document.form.clear.disabled=true;
			document.form.reset.disabled=true;
	   }	
   }
   else
   {
		  // alert("here?");
		   getAfterPrompt();
		   var v_fee = document.form.return_money.value;
		   //alert("v_fee is "+v_fee);
		   var pay_message="ת�ʽ���С��0!";
		   var null_message="ת�ʽ���Ϊ��!";
		   var NaN_message="ת�ʽ��ӦΪ������!";
		   var larger_message="ת�ʽ��ܴ����ʻ�ʣ����!";
		   var pos;
		   if(document.form.trans_contract.value == "0")
		   {
			   rdShowMessageDialog("��ѡ��ת���˺ţ�");
			   return false;
		   }	
		   var contractno2 = document.form.trans_contract.value;
		   if(v_fee == null || v_fee == "")
		   {
				rdShowMessageDialog(null_message);
				document.form.return_money.select();
				return false;
		   }
		   if(v_fee><%=return_money%>)
		   {
				rdShowMessageDialog(larger_message);
				document.form.return_money.select();
				return false;
		   }
		   if(parseFloat(v_fee) <= 0)
		   {
				rdShowMessageDialog(pay_message);
				document.form.return_money.select();
				return false;
		   }
		   if(isNaN(parseFloat(v_fee)))
		   {
				rdShowMessageDialog(NaN_message);
				document.form.return_money.select();
				return false;
		   }
		   if(v_fee>9999999999.99)
		   {
				rdShowMessageDialog("ת�ʽ��ܴ���9999999999.99");
				document.form.return_money.select();
				return false;
		   }
		   pos=v_fee.indexOf(".");
		   if(pos!=-1)
		   {
				if(pos>10)
				{
					rdShowMessageDialog("ת�ʽ��С����ǰ���ܴ���10λ��");
					document.form.return_money.select();
					return false;
				}
				if(v_fee.length-pos>3)
				{
					rdShowMessageDialog("ת�ʽ��С������ܴ���2λ��");
					document.form.return_money.select();
					return false;
				}
		   }
		   else
		   {
				if(v_fee.length>10)
				{
					rdShowMessageDialog("ת�ʽ��С����ǰ���ܴ���10λ��");
					document.form.return_money.select();
					return false;
				}
		   }

		//xl add begin
			var ret = showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes");

			if((ret=="confirm"))
			{
				if(rdShowConfirmDialog('ȷ�ϵ��������')==1)
				{
					  form.action="e832_cfm.jsp";
					  form.submit();
				}

				if(ret=="remark")
				{
					if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
					 {
						   form.action="e832_cfm.jsp";
						   form.submit();
					}
				}

			}
			else
			{
				if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
				{
					 form.action="e832_cfm.jsp";
					 form.submit();
				}
			}

			document.form.sure.disabled=true;
			document.form.clear.disabled=true;
			document.form.reset.disabled=true;
	   }
   	
  
//xi add end


}
function showPrtDlg(printType,DlgMessage,submitCfn)
{  //��ʾ��ӡ�Ի���
	var h=180;
	var w=350;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;

	var pType="subprint";             				 		//��ӡ���ͣ�print ��ӡ subprint �ϲ���ӡ
	var billType="1";              				 			//Ʊ�����ͣ�1���������2��Ʊ��3�վ�
	var sysAccept =<%=printAccept%>;             			//��ˮ��
	var printStr = printInfo(printType);			 		//����printinfo()���صĴ�ӡ����
	var mode_code=null;           							//�ʷѴ���
	var fav_code=null;                				 		//�ط�����
	var area_code=null;             				 		//С������
	var opCode="e832" ;                   			 		//��������
	var phoneNo=document.getElementById("grp_phone_id").value; //ԭ����zchm ��Ϊȡת���ĺ���
	var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no"
	var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_dz.jsp?DlgMsg=" + DlgMessage+ "&submitCfm=" + submitCfn;
	path+="&mode_code="+mode_code+
		"&fav_code="+fav_code+"&area_code="+area_code+
		"&phoneNo="+phoneNo+
		"&opCode=<%=opCode%>&sysAccept="+sysAccept+
		"&submitCfm="+submitCfn+"&pType="+
		pType+"&billType="+billType+ "&printInfo=" + printStr;

	var ret=window.showModalDialog(path,printStr,prop);
	return ret;
}

function printInfo(printType)
{
    //alert("test "+document.form.trans_contract.options[document.form.trans_contract.selectedIndex].text);
	var cust_info="";  				//�ͻ���Ϣ
	var opr_info="";   				//������Ϣ
	var note_info1=""; 				//��ע1
	var note_info2=""; 				//��ע2
	var note_info3=""; 				//��ע3
	var note_info4=""; 				//��ע4
	var retInfo = "";  				//��ӡ����

    var a ="<%=return_money%>";
	var b = document.form.return_money.value;
	var c=a-b;

	/*
    cust_info+="�ֻ����룺"+document.form.grpphoneNo.value+"|";
    cust_info+="�ͻ�������"+ "|";
    cust_info+="֤�����룺"+ "|";
    cust_info+="�ͻ���ַ��"+ "|";*/
	
	cust_info+="�����˹���:"+"<%=workno%>"+"|";
	cust_info+="����������:"+"<%=workname%>"+"|";
 
    opr_info+="�������ͣ����Ų�Ʒת��"+"|";
    opr_info+="���ű�ţ�"+"<%=jtbh%>"+"|";
	opr_info+="��������: "+"<%=jtmc%>"+"|";
	opr_info+="ת����Ʒ�ʺţ�"+"<%=accountid%>"+"|";
	opr_info+="ת����Ʒ���ƣ�"+"<%=jtcpmc%>"+"|";
	opr_info+="ת���Ʒ�˺�-->���ƣ�"+document.form.trans_contract.options[document.form.trans_contract.selectedIndex].text+"|";
	
	opr_info+="�漰��"+document.form.return_money.value+"|";
    
 
    opr_info+='<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
    retInfo+=""+"|";
    retInfo+=""+"|";
    retInfo+=""+"|";
	retInfo+=""+"|";
    retInfo+=""+"|";
	retInfo+=""+"|";

	retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
	retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
    return retInfo;

}
</script>