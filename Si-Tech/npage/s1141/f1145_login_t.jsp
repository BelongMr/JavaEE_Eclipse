<%
/********************
 version v2.0
开发商: si-tech
update:yanpx@2008-10-08
********************/
%>
<%@ page contentType="text/html;charset=GB2312"%>

<%
  request.setCharacterEncoding("GBK");
  String opCode = "1145";//模块代码
  String opName = "购机赠礼";//模块名称
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=opName%></title>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
  String workNoFromSession=(String)session.getAttribute("workNo");
	boolean workNoFlag=false;
	if(workNoFromSession.substring(0,1).equals("k"))
	  workNoFlag=true;

    String work_no = (String)session.getAttribute("workNo");
    String loginName = (String)session.getAttribute("workName");
    String org_Code = (String)session.getAttribute("orgCode");

	  String[][] temfavStr=(String[][])session.getAttribute("favInfo");
    String[] favStr=new String[temfavStr.length];
    for(int i=0;i<favStr.length;i++)
    favStr[i]=temfavStr[i][0].trim();
    boolean pwrf=true;
%>
<%
  //comImpl co=new comImpl();
 
  String sql = " select  unique sale_type,sale_type||'-->'||trim(sal_name) from sSaleType ";
  System.out.println("sql====="+sql);
  //ArrayList agentCodeArr = co.spubqry32("2",sql);
  //String[][] agentCodeStr = (String[][])agentCodeArr.get(0);
%>

</script>
<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>
<script type="text/javascript" src="/npage/s3000/js/S3000.js"></script>
<script language=javascript>
  onload=function()
  {
    document.all.srv_no.focus();
  }

//----------------验证及提交函数-----------------
var subButt2;
function controlButt(subButton){
	subButt2 = subButton;
	subButt2.disabled = true;
	setTimeout("subButt2.disabled = false",3000);
}
function doCfm(subButton)
{
  controlButt(subButton);//延时控制按钮的可用性
 //if(!check(frm)) return false; 
  var radio1 = document.getElementsByName("opFlag");
  for(var i=0;i<radio1.length;i++)
  {
    if(radio1[i].checked)
	{
	  var opFlag = radio1[i].value;
	  if(opFlag=="one")
	  {
	  	
	    	frm.action="f1145_1.jsp";
	    	document.all.opcode.value="1145";
	    	
	  }else if(opFlag=="two")
	  {
	    if(document.all.backaccept.value==""){
	    	rdShowMessageDialog("请输入业务流水！");
	    	return;
	    }
	   
	    	frm.action="f1146_1.jsp";
	    	document.all.opcode.value="1146";
	    	
	  }
	}
  }
	    
	
 
  frm.submit();	
  return true;
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
		<div id="title_zi">购机赠礼</div>
	</div>
      <table cellspacing="0">
	        <tr> 
	          <td class="blue" width="16%">操作类型</td>
              <td width="34%">
							<input type="radio" name="opFlag" value="one" onclick="opchange()" checked >申请&nbsp;&nbsp;
							<!--因一期上线无冲正，应崔琦要求暂时屏蔽 <input type="radio" name="opFlag" value="two" onclick="opchange()" >冲正  -->
	          </td>
	          <td colspan="2">&nbsp</td>
			      <input type="hidden" name="opcode" >
         </tr>    
         <tr> 
            <td class="blue" nowrap width="16%"> 
              手机号码
            </td>
            <td nowrap width="34%"> 
                <input value="<%=activePhone%>" readonly Class="InputGrey"  type="text" size="12" name="srv_no" id="srv_no" v_minlength=1 v_maxlength=16 v_type="mobphone" v_must=1  v_name="服务号码" maxlength="11" index="0">
            </td>          
	          <td colspan="2">&nbsp</td>
         </tr>
         <tr class="blue" style="display:none" id="backaccept_id"> 
	          <td>业务流水</td>
            <td>
								<input type="text" name="backaccept" v_must=1 >
								<font class="orange">*</font>
	          </td>
	          <td colspan="2">&nbsp</td>
         <tr> 
            <td colspan="4" align="center"> 
              <input class="b_foot" type=button name="confirm" value="确认" onClick="doCfm(this)" index="2">    
              <input class="b_foot" type=button name=back value="清除" onClick="frm.reset()">
		     			<input class="b_foot" type=button name=qryP value="关闭" onClick="parent.removeTab(<%=opCode%>);">
           </td>
        </tr>
      </table>
      	<%@ include file="/npage/include/footer_simple.jsp"%>
    <%@ include file="../../npage/common/pwd_comm.jsp" %>
   </form>
</body>
</html>