<!DOCTYPE html PUBLIC "-//W3C//DTD Xhtml 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
  /*
   * 功能: 退预存款1362
   * 版本: 1.0
   * 日期: 2008/12/22
   * 作者: leimd
   * 版权: si-tech
   * update:
  */
%>
<%@	page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>

<%
	String opCode=(String)request.getParameter("opCode");
	String opName=(String)request.getParameter("opName");
	String phoneno = (String)request.getParameter("phoneNo");
	String contractno=request.getParameter("contractno");
	String busy_type = request.getParameter("busy_type");
	String orgcode = (String)session.getAttribute("orgCode");
	String regionCode= (String)session.getAttribute("regCode");
//    ScallSvrViewBean viewBean = new ScallSvrViewBean();
//    CallRemoteResultValue  value1 = null;
    String[] inParas1 = new String[2];
//	String[][] result1  = null ;
	String count_num="0";
	String contract_num="0";

	String s_sm_code="";
%>
	
<%
	
	String phoneno_out=request.getParameter("phoneno"); 
    System.out.println("QQQQQQQQQQQQQQQQQQQQQQQQQQQQaaaaaaaaaaaaaaaaaaaaaaa test service=s1362Init；  opCode is "+opCode+" and contractno is "+contractno+" and phoneno is  "+phoneno+" and phoneno_out is "+phoneno_out);
	inParas1[0] = "select to_char(nvl(count(*),0)) from dConShort where contract_no = '"+ contractno +"'";
	inParas1[1] = "contractno="+contractno;
//		value1 = viewBean.callService("0", null, "sPubSelect", "1",inParas1);
%>
	<wtc:service name="TlsPubSelBoss"  outnum="1" >
		<wtc:param value="<%=inParas1[0]%>"/>
		<wtc:param value="<%=inParas1[1]%>"/> 
	</wtc:service>
	<wtc:array id="result1" scope="end"/>
<%	
		
//		System.out.println("tempArr================"+tempArr[0][0]);
//        result1 = value1.getData();
//       System.out.println("result1================"+result1[0][0]);
		if (result1.length == 1) {
		   count_num = result1[0][0];
		}
		if(count_num.equals("0")) {
			inParas1[0] = "select to_char(nvl(count(*),0)) from dconusermsg where contract_no = '"+ contractno +"'";
//			value1 = viewBean.callService("0", null, "sPubSelect", "1", inParas1);
	String[] inParas_sm = new String[2];
	
	inParas_sm[0]="select sm_code from dcustmsg where phone_no=:s_no";
	inParas_sm[1]="s_no="+phoneno;
%>
	<wtc:service name="TlsPubSelBoss"  outnum="1" >
		<wtc:param value="<%=inParas_sm[0]%>"/>
		<wtc:param value="<%=inParas_sm[1]%>"/> 
	</wtc:service>
	<wtc:array id="result_sm" scope="end"/>
<%
	if(result_sm.length>0)
	{
		s_sm_code=result_sm[0][0];
	}
%>
	<wtc:service name="TlsPubSelBoss"  outnum="1" >
		<wtc:param value="<%=inParas1[0]%>"/>
		<wtc:param value="<%=inParas1[1]%>"/> 
	</wtc:service>
	<wtc:array id="result1" scope="end"/>
<%				
//			result1 = value1.getData();
			if (result1.length == 1) {
			  contract_num = result1[0][0];
			}
		}

	//ScallSvrViewBean viewBean = new ScallSvrViewBean();

		 String[] inParas = new String[4];
         inParas[0] = contractno;
         inParas[1] = orgcode;
         inParas[2] = busy_type;
         inParas[3] = phoneno;
 
//    CallRemoteResultValue  value  = viewBean.callService("1",orgcode.substring(0,2),  "s1362Init", "7" ,  inParas) ;
%>  
	<wtc:service name="s1362Init" routerKey="region" routerValue="<%=regionCode%>" outnum="7" retcode="retCode" retmsg="retMsg">
		<wtc:param value="<%=inParas[0]%>"/>
		<wtc:param value="<%=inParas[1]%>"/>
		<wtc:param value="<%=inParas[2]%>"/>
		<wtc:param value="<%=inParas[3]%>"/>
	</wtc:service>
	<wtc:array id="result" scope="end"/>
<%
//           String [][] result  = value.getData();

	   	  String return_code =result[0][0];
		  String return_message = result[0][1];
 
 if ( return_code.equals("000000")) 
{
	String return_money = result[0][2].trim();
	String unbill_total =result[0][3].trim();
	String prepay_fee =result[0][4].trim();
	String cust_name =result[0][5].trim();
	String interest = result[0][6].trim();
 %>

<html xmlns="http://www.w3.org/1999/xhtml">
	<HEAD><TITLE><%=opName%></TITLE>
<META content="text/html; charset=gbk" http-equiv=Content-Type>
<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>
<script language="JavaScript" src="/npage/s1300/common_1300.js"></script>
 
<script language="JavaScript">
 

function form_load()
{
　form.nopay_money.focus();
}
function conShort()
{
	rdShowMessageDialog("此帐户号码没有配置退费短信接收号码，请配置缴、退费短信接收号码！");
	window.open("<%=request.getContextPath()%>/page/s1211/f1771.jsp?contractNo="+document.all.contractno.value,"","width=1000,height=600");
}
function docheck()
{
   getAfterPrompt();
   var v_fee = document.form.nopay_money.value;  
   var pay_message="退费金额不能小于0!"; 
   var null_message="退费金额不能为空!"; 
   var NaN_message="退费金额应为数字型!";
   var larger_message="退费金额不能大于可退金额!";
   var pos;
   if(document.form.count_num.value ==0 && document.form.contract_num.value ==0 || document.form.contract_num.value >=2){
		conShort();
   }
	var	prtFlag = rdShowConfirmDialog("是否确定退费？");
	if (prtFlag !=1)
		return false;

   if(v_fee == null || v_fee == "") 
   {        
	    rdShowMessageDialog(null_message); 
	    document.form.nopay_money.value=<%=return_money%>; 
	    document.form.nopay_money.select(); 
		return false; 
   } 
 
   if(v_fee><%=return_money%>) 
   {        
	    rdShowMessageDialog(larger_message); 
	    document.form.nopay_money.value=<%=return_money%>; 
	    document.form.nopay_money.select(); 
		return false; 
   } 
   if(parseFloat(v_fee) == 0) 
   {        
	    rdShowMessageDialog(pay_message); 
	    document.form.nopay_money.value=<%=return_money%>; 

	    document.form.nopay_money.select(); 
		return false; 
   }        
   if(isNaN(parseFloat(v_fee)))   
   {        
		rdShowMessageDialog(NaN_message); 
	    document.form.nopay_money.value=<%=return_money%>; 
	    document.form.nopay_money.select(); 
	    return false; 
   }
   if(v_fee>9999999999.99)
   {
		rdShowMessageDialog("退费金额不能大于9999999999.99");
	    document.form.nopay_money.value=<%=return_money%>; 

		document.form.nopay_money.select(); 
		return false;
   }
  
   var  tmp_fee = v_fee.toString().replace(/\$|\,/g,'');
    if(isNaN(tmp_fee))
	{
		rdShowMessageDialog("退费金额的格式不对！");
	    document.form.nopay_money.value=<%=return_money%>; 

		document.form.nopay_money.select(); 
		return false;
	}

   
   pos=v_fee.indexOf(".");
   if(pos!=-1)
   {
 		if(v_fee.length-pos>3)
		{
			rdShowMessageDialog("退费金额小数点后不能大于2位！");
	       document.form.nopay_money.value=<%=return_money%>; 

			document.form.nopay_money.select(); 
			return false;
		}
   }
 
document.form.sure.disabled=true;
document.form.reset.disabled=true;
document.form.action="s1362_2.jsp";
document.form.submit();
}

 function showSelWindow() {
	var h=500;
	var w=500;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;

	var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
	var returnValue=window.showModalDialog('getPreAcount.jsp?contractno=<%=contractno%>',"",prop);
    
	if(typeof(returnValue) != "undefined") {   
	    rdShowMessageDialog(returnValue);	   
	}
 }
 function tzz()//打印纸质发票
{
	//alert("zz");
	/*
	document.all.cfm.style.display="block";
	document.all.cfmdz.style.display="none";
	document.all.zz_flag.value="1";*/
	document.all.cfm.style.display="none";
	document.all.cfmdz.style.display="block";
	document.all.zz_flag.value="1";
}
function tdz()//打印电子发票
{
	//alert("s_sm_code is "+"<%=s_sm_code%>");
	if("<%=s_sm_code%>"=="kf" ||"<%=s_sm_code%>"=="kg"||"<%=s_sm_code%>"=="ki")
	{
		document.all.cfm.style.display="none";
		document.all.cfmdz.style.display="block";
		document.all.zz_flag.value="e";
	}
	else
	{
		rdShowMessageDialog("该品牌不允许开具电子发票!");
		history.go(-1);
	}
	
}
function zz1()
{
	document.all.cfm.style.display="none";
	document.all.cfmdz.style.display="block";
	document.all.zz_flag.value="2";
}
function inits()
{
	document.all.cfm.style.display="none";
	document.all.cfmdz.style.display="none";
}
function doqry()
{
	//alert("1");
	var dzhm = document.all.dzhm.value;
	var dzdm = document.all.dzdm.value;
	var kyny = document.all.kyny.value;
	var phone_no = "<%=phoneno%>";
	//alert("qry phone_no is "+phone_no);
	var fp_flag = document.all.zz_flag.value;
	if(fp_flag=="2")
	{
		//新增逻辑
		var hm_length = dzhm.length;
		var dm_length = dzdm.length;
		//alert("1 dzhm is "+hm_length+" and dm_length is "+dm_length);
		if(hm_length>8 || dm_length>12)
		{
			rdShowMessageDialog("发票号码不能超过8个字符,发票代码不能超过12个字符!");
			return false;
		}
		else
		{
			document.getElementById("s_accept").value="";
			document.all.s_money.value=document.all.nopay_money.value;
			docheck();
		}
	}
	else
	{
		if(dzhm=="" ||dzdm=="" ||kyny=="")
		{
			rdShowMessageDialog("请输入发票号码、发票代码和发票开具年月!");
			return false;
		}
		else
		{
			var pactket2 = new AJAXPacket("../s1300/sget_fp.jsp","正在进行发票预占取消，请稍候......");
			pactket2.data.add("dzhm",dzhm);
			pactket2.data.add("dzdm",dzdm);
			pactket2.data.add("kyny",kyny);
			pactket2.data.add("fp_flag",fp_flag);
			pactket2.data.add("phone_no",phone_no);
			core.ajax.sendPacket(pactket2,fpGet);
		}
	}
	
}
function fpGet(packet)
{
	var s_flag = packet.data.findValueByName("s_flag");
	var s_money = packet.data.findValueByName("s_money");
	var s_accept = packet.data.findValueByName("s_accept");
	document.getElementById("s_accept").value=s_accept;
	//alert("s_flag is "+s_flag+" and s_money is "+s_money);
	document.all.s_money.value=s_money;
	var tfje = document.all.nopay_money.value;
	if(s_flag=="1")
	{
		rdShowMessageDialog("电子发票信息查询失败!");
		return false;
	}
	else
	{
		if(parseFloat(s_money)<parseFloat(tfje))
		{
			rdShowMessageDialog("蓝字发票退费金额"+s_money+"小于退费金额"+tfje+",请重新输入退费金额!");
			return false;
		}
		else
		{
			docheck();
		}
	}
}
</script>
</HEAD>
<BODY onload="inits()">
<FORM action="" method=post name=form>
	<%@ include file="/npage/include/header.jsp" %>
	<input type="hidden" id="s_accept" name="saccept">
<input type="hidden" name="busy_type"  value="<%=busy_type%>">
<input type="hidden" name="count_num"  value="<%=count_num%>">
<input type="hidden" name="contract_num"  value="<%=contract_num%>">
<input type="hidden" name="opCode"  value="<%=opCode%>">
<input type="hidden" name="opName"  value="<%=opName%>">
<input type="hidden" name="zz_flag"><!--1=纸质 e=电子-->
<table cellspacing="0">
	<tr> 
		<th class="blue">服务号码</th>
		<th> 
			<input type="text" name="phoneno" maxlength="11" value="<%=phoneno%>" class="InputGrey" readOnly>
		</th>
		<th colspan="4">部门：<%=orgcode%></th>
	</tr>
	<tr> 
		<td class="blue">帐户号码</td>
		<td> 
			<input type="text" name="contractno" value="<%=contractno%>" class="InputGrey" readOnly>
		</td>
		<td class="blue">用户名称</td>
		<td>
			<input type="text" name="cust_name" value="<%=cust_name%>" class="InputGrey" readOnly>
		</td>
	</tr>
	<tr> 
		<td class="blue"> 现有预存金额 </td>
		<td> 
			<input type="text" name="prepay_fee" value="<%=prepay_fee%>" class="InputGrey" readOnly>
		</td>
		<td class="blue">总欠费</td>
		<td> 
			<input type="text" name="unbill_total" value="<%=unbill_total%>" class="InputGrey" readOnly>
		</td>
	</tr>
	<tr> 
		<td class="blue"> 可退金额 </td>
		<td> 
			<input type="text" name="textfield" value="<%=return_money%>" class="InputGrey" readOnly>
		</td>
			<% if (busy_type.equals("1")) {%>
		<td colspan="2">
			<input type="hidden" name="interest" value="<%=interest%>" class="InputGrey" readOnly>
		</td>
			<%} else {%>
		<td class="blue">结息</td>
		<td> 
			<input type="text" name="interest" value="<%=interest%>" class="InputGrey" readOnly>
		</td>
			<%}%>
	</tr>
	<tr> 
		<td class="blue">退费金额</td>
		<td colspan="3"> 
			<input class="button" name=nopay_money value="<%=return_money%>" onKeyPress="return isKeyNumberdot(1)">
		</td>
	</tr>
	 <input type="hidden" name="phoneno_out" value="<%=phoneno_out%>">
	<tr> 
		<td align=center id="footer" colspan="4"> 
			<input type="radio" name="opFlag" value="0" onclick="tzz()"  >纸质发票(校验发票号码)
			&nbsp;
			&nbsp;
			<input type="radio" name="opFlag" value="1" onclick="tdz()"  >电子发票
			&nbsp;
			&nbsp;
			<input type="radio" name="opFlag" value="1" onclick="zz1()"  >纸质发票(不校验发票号码)
			<!--
		 
			&nbsp;
			<input class="b_foot" name=reset type=reset value=返回 onClick="history.go(-1)">
			&nbsp;
			-->
		</td>
	</tr>
	<tr>
	<td colspan=4>备注： 
纸质发票(检验发票号码):当原业务打印的是纸质发票，本业务想打印电子发票时选择。
 </td>
	</tr>
	<tr>
	<td colspan=4>纸质发票(不检验发票号码):当原业务打印的是纸质发票，但无法提供纸质发票号码或原业务是通过自助缴费机缴费，本业务想打印纸质发票时选择，如本次业务想打印电子发票时不可选择。
 </td>
	</tr>
	<tr>
	<td colspan=4>电子发票:当原业务打印的是电子发票，本业务只能选择电子发票。
</td>

	 
	</tr>
	<tr id="cfm">
		<td align=center id="footer" colspan="4"> 
		<input class="b_foot" name=sure type=button value=确认 onclick="docheck()">
			&nbsp;
		<input class="b_foot" name=reset type=reset value=返回 onClick="history.go(-1)">
			&nbsp;
		</td>
	</tr>
	<!--电子的 查询电子发票号码 代码 年月等-->
	<tr id="cfmdz">
		<td > 
			发票号码:<input type="text" name="dzhm">
		</td>
		<td > 
			发票代码:<input type="text" name="dzdm">
		</td>
		<td > 
			发票开具年月:<input type="text" name="kyny" maxlength="6">(例:201704)
		</td>
		<td  > 
			<input type="button" name="qry" value="查询" onclick="doqry()">
		</td>
	</tr>
	<input type="hidden" name="s_money">
</table>
	<%@ include file="/npage/include/footer.jsp" %>
</FORM>
</BODY>
</HTML>
<%}
else
{
%>
	 <script language="JavaScript">
			rdShowMessageDialog("查询错误!<br>错误代码：'<%=return_code%>'，错误信息：'<%=return_message%>'。",0);
			window.location.href="e033_1.jsp?opCode=<%=opCode%>&opName=<%=opName%>";
	 </script>
<%
	}
%>

