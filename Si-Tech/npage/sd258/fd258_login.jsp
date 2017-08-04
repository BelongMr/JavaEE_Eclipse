<%
  /*
   * 功能: 无线监控营销活动 d258
   * 版本: 1.8.2
   * 日期: 2011/3/10
   * 作者: huangrong
   * 版权: si-tech
   * update:
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.io.*"%>

<%@ page import="java.util.*"%>
<%@ page import="java.nio.*%>
<%@ page import="java.nio.MappedByteBuffer%>

<%
request.setCharacterEncoding("GBK");
try{
		DataOutputStream out2 = 
		new DataOutputStream(
		new BufferedOutputStream(
		new FileOutputStream("data.txt")));
		out2.writeChars("\naaa\n");		
		out2.close();
		}
catch(EOFException e){
System.out.println("End of stream");
}
%>
<html>
<head>
<title>无线监控营销活动</title>
<%
  String workNoFromSession=(String)session.getAttribute("workNo");
	String userPhoneNo=(String)session.getAttribute("userPhoneNo");
	boolean workNoFlag=false;
  if(workNoFromSession.substring(0,1).equals("k"))
  workNoFlag=true;
  String opCode = request.getParameter("opCode");
	String opName = "无线监控营销活动";
	activePhone = request.getParameter("activePhone");
  String work_no =(String)session.getAttribute("workNo");
  String loginName =(String)session.getAttribute("workName");
  String powerRight =(String)session.getAttribute("powerRight");
  String orgCode =(String)session.getAttribute("orgCode");
  String regionCode = orgCode.substring(0,2);
  String[][]  favInfo = (String[][])session.getAttribute("favInfo");

  String[] favStr=new String[favInfo.length];
  for(int i=0;i<favStr.length;i++)
  favStr[i]=favInfo[i][0].trim();
  boolean pwrf=false;
  if(WtcUtil.haveStr(favStr,"a272"))
  pwrf=true;
	  
	String sql1 = " select to_char(count(*)) from shighlogin where login_no=:loginno and (op_code='d258' or op_code='d259')";
	String [] paraIn = new String[2];
  paraIn[0] = sql1;
  paraIn[1]="loginno="+work_no;

%>
<wtc:service name="TlsPubSelCrm" routerKey="login_no" routerValue="<%=work_no%>"  retcode="retCode1" retmsg="retMsg1" outnum="1">
	<wtc:param value="<%=paraIn[0]%>"/>
	<wtc:param value="<%=paraIn[1]%>"/> 
</wtc:service>
<wtc:array id="logincount" scope="end" />
<%
	if(logincount[0][0].equals("0")){
%>

<script language="JavaScript">
<!--
  	rdShowMessageDialog("此工号不允许操作");
  	parent.removeTab('<%=opCode%>');
//-->
</script>
<%}%>

<script language=javascript>
onload=function()
{
	var radio = document.getElementsByName("opFlag")
	if("<%=opCode%>"=="d259")
	{
		radio[1].checked =true;
		document.all.backaccept_id.style.display = "";
	}else
	{
		radio[0].checked=true;
		document.all.backaccept_id.style.display = "none";
	}
  document.all.srv_no.focus();
}
//----------------验证及提交函数-----------------
function doCfm(subButton)
{
  controlButt(subButton);//延时控制按钮的可用性
 
  var radio1 = document.getElementsByName("opFlag");
  for(var i=0;i<radio1.length;i++)
  {
    if(radio1[i].checked)
		{
	  	var opFlag = radio1[i].value;
	  	if(opFlag=="one")
	  	{	
	  		document.all.opcode.value="d258" ;	
	    	frm.action="fd258_1.jsp";
	  	}else if(opFlag=="two")
	  	{
	   	  if(document.all.backaccept.value==""){
	    	rdShowMessageDialog("请输入业务流水！");
	    	return;
	   		 }
	   		document.all.opcode.value="d259" ;	
	    	frm.action="fd259_1.jsp";	
	  	}
		}
  }
  frm.submit();	
  return true;
}

function controlButt(subButton){
	subButt2 = subButton;
	subButt2.disabled = true;
	setTimeout("subButt2.disabled = false",3000);
}
function opchange(){
	if(document.all.opFlag[0].checked==true) 
	{ 	
		document.all.backaccept_id.style.display = "none";
	}else {
		document.all.backaccept_id.style.display = "";
	}
}
</script>
</head>
<body>
	
<form name="frm" method="POST" onKeyUp="chgFocus(frm)">
	<%@ include file="/npage/include/header.jsp" %>   
  	
		<div class="title">
			<div id="title_zi">无线监控营销活动</div>
		</div>
	
    <table cellspacing="0">
			<TR> 
			  <TD width="16%" class="blue">操作类型</TD>
			  <TD width="84%" colspan="3">
				<input type="radio" name="opFlag" value="one" onclick="opchange()" checked >申请&nbsp;&nbsp;
				<input type="radio" name="opFlag" value="two" onclick="opchange()" >冲正
			  </TD>
			</TR>   
			
			<tr> 
				<td width="16%" nowrap class="blue"> 
				  <div align="left">手机号码</div>
				</td>
				<td nowrap  width="34%" colspan="3"> 
					<div align="left"> 
						<input   type="text" size="12" name="srv_no" id="srv_no" v_minlength=1 v_maxlength=16 v_type="mobphone" v_must=1   maxlength="11" index="0"  Class="InputGrey" readOnly  value ="<%=activePhone%>">
					</div>
				</td>
			</tr>
			
       <TR  style="display:none" id="backaccept_id"> 
          <TD width="16%" class="blue">业务流水</TD>
          <TD width="34%"  colspan="3">
						<input class="button" type="text" name="backaccept" v_must=1 onblur="checkElement(this);">
						<font class="orange">*</font>
          </TD>
       </TR>  
        
       <tr> 
          <td colspan="5" id="footer"> 
            <div align="center"> 
	            <input class="b_foot" type=button name="confirm" value="确认" onClick="doCfm(this)" index="2">    
	            <input class="b_foot" type=button name=back value="清除" onClick="frm.reset()">
		      		<input class="b_foot" type=button name=qryP value="关闭" onClick="parent.removeTab('<%=opCode%>');">
            </div>
         </td>
      </tr>
     </table>
	<%@ include file="/npage/include/footer_simple.jsp"%>
  <%@ include file="../../npage/common/pwd_comm.jsp" %>
  <input type="hidden" name="opcode">
</form>
</body>
</html>

