 <!DOCTYPE html PUBLIC "-//W3C//DTD Xhtml 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
  /*
   * 功能: 号码信息查询5186
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
	String opCode="zgar";
	String opName="前台电子发票打印";
	//String phoneNo = (String)request.getParameter("activePhone");			//手机号码
 
	String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
%>

<html xmlns="http://www.w3.org/1999/xhtml">
	<HEAD><TITLE>前台电子发票打印</TITLE>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0);
%>
</HEAD>

<body>
<SCRIPT language="JavaScript">
function isNumberString (InString,RefString)
{
if(InString.length==0) return (false);
	for (Count=0; Count < InString.length; Count++)  {
		TempChar= InString.substring (Count, Count+1);
		if (RefString.indexOf(TempChar, 0)==-1)  
		return (false);
	}
	return true;
}
function doCheck()
{
	//if(jtrim(document.frm5186.cus_pass.value).length ==0)
	//	document.frm5186.cus_pass.value="123456";   
	var beginym = document.frm5186.beginym.value;
	var endym = document.frm5186.endym.value;
	var qryvalue = document.frm5186.qryvalue.value;
	var qry_type = document.frm5186.qrytype[document.frm5186.qrytype.selectedIndex].value;
	if(qry_type=="1")
	{
		document.frm5186.contract_no.value="99999999999";
	}
	else
	{
		document.frm5186.contract_no.value=qryvalue;
		qryvalue="";//是否需要置空?
	}
	if(document.frm5186.qryvalue.value=="")
	{	rdShowMessageDialog("请输入查询条件！");
		document.frm5186.qryvalue.focus();
		return false;
	}
	else if(beginym=="" ||endym=="")
	{
		rdShowMessageDialog("请输入查询年月日！");
		return false;
	}
	else if(beginym.substr(0,6)!=endym.substr(0,6))
	{
		rdShowMessageDialog("只能查询相同年月的电子发票!");
		return false;
	}
	/*只能查询同月的*/
	else{
		document.frm5186.action="zgar_2.jsp";
		frm5186.submit();
	}
	 
}

</SCRIPT>

<FORM method=post name="frm5186">
	<%@ include file="/npage/include/header.jsp" %>
<input type="hidden" name="opCode"  value="5186">
<input type="hidden" name="custPass"  value="">
	<div class="title">
		<div id="title_zi">前台电子发票打印</div>
	</div>
<table cellspacing="0">
		<TR> 
	      <td class="blue">查询方式</TD>
          <td colspan=3>
          	<select name="qrytype">
				<option value="0" selected>用户号码</option>
				<option value="1" >账户号码</option>
			</select>
			</td>
		</TR>
		<tr>
			<td class="blue">查询条件</TD>
			<td colspan=3>
				<input type="text" name="qryvalue">
			</td>
		</tr> 
		  <TR> 
	      <td class="blue">查询开始年月日</TD>
          <td>
          	
			<input type="text"  name="beginym" value="<%=dateStr%>"  onKeyPress="return isKeyNumberdot(0)" size="20" maxlength="8"  >
			</td>
          <td class="blue">查询结束年月日</TD>
          <td>
          	
			<input type="text"  name="endym" value="<%=dateStr%>"  onKeyPress="return isKeyNumberdot(0)" size="20" maxlength="8"  >
			</td>
          </TR>
		  <input type="hidden" name="contract_no">	
			 
	    <TR> 
	      <TD align="center" id="footer" colspan="4"> 
		  <input type="submit" class="b_foot" name="Button1" value="查询" onclick="doCheck()">
	        &nbsp; 
	        &nbsp;&nbsp;<input class="b_foot" name=back onClick="removeCurrentTab()" type=button value=关闭>
	        &nbsp; 
	      </TD>
	    </TR>
	    </table> 
    <%@ include file="/npage/include/footer.jsp" %>
</FORM>
</body>
</html> 
