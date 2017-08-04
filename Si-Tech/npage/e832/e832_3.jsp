<%
/********************
 version v2.0
开发商: si-tech
*
*update:zhanghonga@2008-08-15 页面改造,修改样式
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
	var transin_fee = new Array();//where条件 是 projectCode 要查询显示的是 fee
	var i_contract_no = new Array();
</script>

<%
	String workno = (String)session.getAttribute("workNo");
    String workname = (String)session.getAttribute("workName");
	String opCode = "e832";
	String opName = "集团产品转账";
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
    /****得到打印流水****/
	String printAccept="";
	printAccept = getMaxAccept();

	String inParas[] = new String[2]; //查询产品账号的sql
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
<HEAD><TITLE>集团产品转账</TITLE>
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
					rdShowMessageDialog("查询错误！<br>错误代码：'<%=return_code%>'。<br>错误信息：'<%=return_message%>'。",0);
					//window.location='e832_1.jsp';
					history.go(-1);
				</script>
			<%
		}
		else
		{
			if(ret_val==null||ret_val.length==0 || result2==null||result2.length==0)
			{
				%>无记录<%
			}
			else
			{
				return_money=ret_val[0][2];
				%>
				<div class="title">
					<div id="title_zi">集团产品账户信息</div>
				</div>
					<table cellspacing="0">
						<tr>
							<td class="blue">集团产品名称</td>
							<td class="blue">
								<input type="text" name="grpName" class="InputGrey" readonly value="<%=ret_val[0][3]%>">
							</td>
							<td class="blue">集团号码</td>
							<td class="blue">
								<input type="text" name="grpphoneNo" id="grp_phone_id" class="InputGrey" readonly value="<%=phoneNo1%>">
								<input type="hidden" name="grpconNo" value="<%=accountid%>">  
								<input type="hidden" name="custid" value="<%=khid%>">
							</td>
						</tr>
						<tr>
							<td class="blue">未结欠费</td>
							<td colspan="3">
								<input type="text" name="cur_owe" class="InputGrey" readonly value="<%=ret_val[0][4]%>">
							</td>
						</tr>
					</table>
					<br>
					<div class="title">
						<div id="title_zi">集团产品预存明细</div>
					</div>
					<table cellspacing="0" >
						<tr>
						<th>
							<div align="center">预存类型</div>
						</th> 
						<th>
							<div align="center">预存金额</div>
						</th>
						<th>
							<div align="center">顺序</div>
						</th>
						<th>
							<div align="center">是否可退</div>
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
						<div id="title_zi">转账明细</div>
					</div>
					<table cellspacing="0">
						<tr>
							<td class="blue">转存账号</td>
							<td  >
								<select style="width:353px" name="trans_contract" onchange="getPhone(this,project_code,transin_fee,smCodeArray)" >
									<option value="0" selected>--->请选择</option>
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
						    <td class="blue">转存号码<input id="cz" type="text" class="InputGrey" name = "zchm" readonly> </td> 
						</tr>
						<tr>
							<td class="blue">可转存金额</td>
							<td>
								<input class="InputGrey" readonly name=remark2 value="<%=ret_val[0][2]%>">
							</td>
							<td class="blue">转存金额 
								<input class="button" name=return_money value="<%=ret_val[0][2]%>">
							</td>
						</tr>
						<tr>
							<td align=center id="footer" colspan="4">
							<input class="b_foot" name=sure type=button value=确认 onclick="docheck()">
							&nbsp;
							<input class="b_foot" name=clear type=reset value=清除>
							&nbsp;
							<input class="b_foot" name=reset type=reset value=返回 onClick="history.go(-1)">
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
 var transin_fee = new Array();//where条件 是 projectCode 要查询显示的是 fee
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
	   rdShowMessageDialog("物联网号码不允许缴费!");
	   return false;
   }
   else if ("<%=sm_code%>"=="YC"||"<%=sm_code%>"=="HL"||"<%=sm_code%>"=="ZX") 
   {
		//alert("2");
		if(zrpmid!="YC" &&zrpmid!="HL" &&zrpmid!="ZX")
	    {
			rdShowMessageDialog("该品牌不允许向非YC、HL、ZX品牌转账");
			return false;
		}
		else
		{
		  // alert("here?");
		   getAfterPrompt();
		   var v_fee = document.form.return_money.value;
		   //alert("v_fee is "+v_fee);
		   var pay_message="转帐金额不能小于0!";
		   var null_message="转帐金额不能为空!";
		   var NaN_message="转帐金额应为数字型!";
		   var larger_message="转帐金额不能大于帐户剩余金额!";
		   var pos;
		   if(document.form.trans_contract.value == "0")
		   {
			   rdShowMessageDialog("请选择转账账号！");
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
				rdShowMessageDialog("转帐金额不能大于9999999999.99");
				document.form.return_money.select();
				return false;
		   }
		   pos=v_fee.indexOf(".");
		   if(pos!=-1)
		   {
				if(pos>10)
				{
					rdShowMessageDialog("转帐金额小数点前不能大于10位！");
					document.form.return_money.select();
					return false;
				}
				if(v_fee.length-pos>3)
				{
					rdShowMessageDialog("转帐金额小数点后不能大于2位！");
					document.form.return_money.select();
					return false;
				}
		   }
		   else
		   {
				if(v_fee.length>10)
				{
					rdShowMessageDialog("转帐金额小数点前不能大于10位！");
					document.form.return_money.select();
					return false;
				}
		   }

		//xl add begin
			var ret = showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes");

			if((ret=="confirm"))
			{
				if(rdShowConfirmDialog('确认电子免填单吗？')==1)
				{
					  form.action="e832_cfm.jsp";
					  form.submit();
				}

				if(ret=="remark")
				{
					if(rdShowConfirmDialog('确认要提交信息吗？')==1)
					 {
						   form.action="e832_cfm.jsp";
						   form.submit();
					}
				}

			}
			else
			{
				if(rdShowConfirmDialog('确认要提交信息吗？')==1)
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
		   var pay_message="转帐金额不能小于0!";
		   var null_message="转帐金额不能为空!";
		   var NaN_message="转帐金额应为数字型!";
		   var larger_message="转帐金额不能大于帐户剩余金额!";
		   var pos;
		   if(document.form.trans_contract.value == "0")
		   {
			   rdShowMessageDialog("请选择转账账号！");
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
				rdShowMessageDialog("转帐金额不能大于9999999999.99");
				document.form.return_money.select();
				return false;
		   }
		   pos=v_fee.indexOf(".");
		   if(pos!=-1)
		   {
				if(pos>10)
				{
					rdShowMessageDialog("转帐金额小数点前不能大于10位！");
					document.form.return_money.select();
					return false;
				}
				if(v_fee.length-pos>3)
				{
					rdShowMessageDialog("转帐金额小数点后不能大于2位！");
					document.form.return_money.select();
					return false;
				}
		   }
		   else
		   {
				if(v_fee.length>10)
				{
					rdShowMessageDialog("转帐金额小数点前不能大于10位！");
					document.form.return_money.select();
					return false;
				}
		   }

		//xl add begin
			var ret = showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes");

			if((ret=="confirm"))
			{
				if(rdShowConfirmDialog('确认电子免填单吗？')==1)
				{
					  form.action="e832_cfm.jsp";
					  form.submit();
				}

				if(ret=="remark")
				{
					if(rdShowConfirmDialog('确认要提交信息吗？')==1)
					 {
						   form.action="e832_cfm.jsp";
						   form.submit();
					}
				}

			}
			else
			{
				if(rdShowConfirmDialog('确认要提交信息吗？')==1)
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
{  //显示打印对话框
	var h=180;
	var w=350;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;

	var pType="subprint";             				 		//打印类型：print 打印 subprint 合并打印
	var billType="1";              				 			//票价类型：1电子免填单、2发票、3收据
	var sysAccept =<%=printAccept%>;             			//流水号
	var printStr = printInfo(printType);			 		//调用printinfo()返回的打印内容
	var mode_code=null;           							//资费代码
	var fav_code=null;                				 		//特服代码
	var area_code=null;             				 		//小区代码
	var opCode="e832" ;                   			 		//操作代码
	var phoneNo=document.getElementById("grp_phone_id").value; //原来是zchm 改为取转出的号码
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
	var cust_info="";  				//客户信息
	var opr_info="";   				//操作信息
	var note_info1=""; 				//备注1
	var note_info2=""; 				//备注2
	var note_info3=""; 				//备注3
	var note_info4=""; 				//备注4
	var retInfo = "";  				//打印内容

    var a ="<%=return_money%>";
	var b = document.form.return_money.value;
	var c=a-b;

	/*
    cust_info+="手机号码："+document.form.grpphoneNo.value+"|";
    cust_info+="客户姓名："+ "|";
    cust_info+="证件号码："+ "|";
    cust_info+="客户地址："+ "|";*/
	
	cust_info+="受理人工号:"+"<%=workno%>"+"|";
	cust_info+="受理人名称:"+"<%=workname%>"+"|";
 
    opr_info+="操作类型：集团产品转账"+"|";
    opr_info+="集团编号："+"<%=jtbh%>"+"|";
	opr_info+="集团名称: "+"<%=jtmc%>"+"|";
	opr_info+="转出产品帐号："+"<%=accountid%>"+"|";
	opr_info+="转出产品名称："+"<%=jtcpmc%>"+"|";
	opr_info+="转入产品账号-->名称："+document.form.trans_contract.options[document.form.trans_contract.selectedIndex].text+"|";
	
	opr_info+="涉及金额："+document.form.return_money.value+"|";
    
 
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