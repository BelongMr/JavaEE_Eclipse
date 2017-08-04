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
<%@ page import="java.text.*" %> 
<%@ page import="java.util.*" %>
<%
		String opCode = "zgbi";
		String opName = "冲正工号添加";
 	    String workno=(String)session.getAttribute("workNo");    //工号 
		String workname =(String)session.getAttribute("workName");//工号名称  	        
		String orgcode = (String)session.getAttribute("orgCode");  
		String regionCode = (String)session.getAttribute("regCode");
		String sysAccept = "";
%>
		<wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region"  routerValue="<%=regionCode%>" id="sLoginAccept"/>
<%   
    sysAccept = sLoginAccept;
    System.out.println("#           - 流水："+sysAccept);
%>

<HTML>
<HEAD>
<script language="JavaScript">
 
function xnjtcx()
{
	var phoneNo = document.frm.phoneNo.value;
	if(phoneNo=="")
	{
		rdShowMessageDialog("请输入集团虚拟账号!");
		return false;
	}
	else
	{
		//alert(phoneNo);
		var myPacket = new AJAXPacket("zg44_check.jsp","正在提交，请稍候......");
		myPacket.data.add("phoneNo",phoneNo);
		core.ajax.sendPacket(myPacket,doPosSubInfo3);
		myPacket=null;
	}
}
 function doPosSubInfo3(packet)
 {
	 //alert("2");
	 var s_flag =  packet.data.findValueByName("flag1");
	 var s_cust_name =  packet.data.findValueByName("s_cust_name");
	// alert("s_flag is "+s_flag+" and s_cust_name is "+s_cust_name);
	 if(s_flag=="0")
	 {
		document.getElementById("tj").disabled=false;
		document.frm.contract_name.value=s_cust_name;

	 }
	 else
	 {
		 rdShowMessageDialog("该虚拟集团账号不存在,请重新输入!");
		 document.frm.phoneNo.value="";
		 document.getElementById("tj").disabled=true;
	 }	
 }


 function doclear() {
 		frm.reset();
 }
   
 function sel1() {
 		window.location.href='zgbi_1.jsp';
 }

 function sel2(){
    window.location.href='zgbi_del.jsp';
 }
 function sel3(){
    window.location.href='zgbi_upload.jsp';
 } 
function sel4(){
    window.location.href='zgbi_pldel.jsp';
 }
 function sel5(){
    window.location.href='zgbi_plup.jsp';
 }
 function sel6(){
    window.location.href='zgbi_cx.jsp';
 }
 function cyzhtj()//成员添加
 {
	 //alert("cyzhtj");
	 document.getElementById("tjdetail").style.display="block";
	 document.getElementById("tjdetail2").style.display="block";
	 document.getElementById("tj").disabled=true;
	
 }
 
 function inits()
 {
	 document.getElementById("tjdetail").style.display="none";
	 document.getElementById("tjdetail2").style.display="none";
 }

 function addgrp()
 {
	// alert("addgrp");//手机号码可空
	 var phoneNo = document.frm.phoneNo.value;
	 var contract_name =  document.frm.contract_name.value;
	 var detail_phone =  document.frm.detail_phone.value;
	 var detail_contract =  document.frm.detail_contract.value;
	 if(detail_phone=="" ||detail_contract=="")
	 {
		rdShowMessageDialog("添加的虚拟集团成员号码和虚拟成员账号都不可以为空!");
		return false;
	 }	
	 else
	 {
		 var prtFlag=0;
		 prtFlag=rdShowConfirmDialog("是否确定进行虚拟集团添加操作?");
		 if (prtFlag==1){
			var myPacket = new AJAXPacket("zg44_add.jsp","正在提交，请稍候......");
			myPacket.data.add("unit_id",phoneNo);
			myPacket.data.add("contract_name",contract_name);
			myPacket.data.add("detail_phone",detail_phone);
			myPacket.data.add("detail_contract",detail_contract);
			core.ajax.sendPacket(myPacket,doPosSubInfo2);
			myPacket=null;
			
		 
		 }
		 else
		 { 
			return false;	
		 }
	 }
	 
 }

 function doPosSubInfo2(packet)
 {
	 //alert("2");
	 var s_flag =  packet.data.findValueByName("flag1");
	 var s_msg =   packet.data.findValueByName("s_msg");
	 var s_code =  packet.data.findValueByName("s_code");
	// alert("s_flag is "+s_flag);
	 if(s_flag=="0")
	 {
		rdShowMessageDialog("添加成功!");
		document.frm.detail_phone.value="";
		document.frm.detail_contract.value="";
	 }
	 else
	 {
		 rdShowMessageDialog("添加失败!错误代码"+s_code+",错误原因"+s_msg);
		 return false;
	 }
 }
 function dosubmit() 
 {
	 
	if(form.feefile.value.length<1)
	{
		rdShowMessageDialog("数据文件错误，请重新选择数据文件！");
		document.form.feefile.focus();
		return false;
	}
	else 
	{
		setOpNote();
		//alert(document.all.remark.value);
		var seled = $("#seled").val();
		document.form.action="zgbi_cfm1.jsp?remark="+document.form.remark.value+"&regCode="+"<%=regionCode%>"+"&sysAccept="+"<%=sysAccept%>"+"&seled="+seled+"&service_name=szgbiplgx";
		document.form.submit();
		document.form.sure.disabled=true;
		document.form.reset.disabled=true;
		return true;
	}
 }
 function setOpNote()
 {
	if(document.all.remark.value=="")
	{
	  document.all.remark.value = "操作员："+document.all.loginNo.value+"进行了批量信息导入"; 
	}
	return true;
 }
 </script> 
 
<title>黑龙江BOSS-普通缴费</title>
</head>
<BODY  >
<FORM action="g247_cfm1.jsp" method=post name=form ENCTYPE="multipart/form-data">
		
		<%@ include file="/npage/include/header.jsp" %>   
  	<div class="title">
			<div id="title_zi">请选择配置方式</div>
	</div>
	
	<table cellspacing="0">
      <tbody> 
	 
      <tr> 
        <td class="blue" width="15%">配置方式</td>
        <td colspan="4"> 
        	<q vType="setNg35Attr">
          <input name="busyType2" type="radio" onClick="sel3()" value="3"  >工号批量添加
          </q>
		  <q vType="setNg35Attr">
          <input name="busyType2" type="radio" onClick="sel4()" value="4" >工号批量删除
          </q>
		  <q vType="setNg35Attr">
          <input name="busyType2" type="radio" onClick="sel5()" value="5" checked>工号批量修改
          </q>
		  <q vType="setNg35Attr">
          <input name="busyType2" type="radio" onClick="sel6()" value="6">查询导出
          </q>
     </tr>
	   
    </tbody>
  </table>
	
  <table cellspacing="0">
		              <tbody> 
			              <tr> 
				                <td class="blue" align=center width="20%">操作类型</td>
				                <td width="30%" colspan="2">
					                    <input type="text" size="30" class="InputGrey" readonly value="冲正工号批量修改">
				                </td>				               		              
			                <td class="blue" align=center width="20%">数据文件</td>
			                <td width="30%" colspan="2"> 
			                  <input type="file" name="feefile">
			                </td>
		              	</tr>
		        </tbody> 
	    		</table>
		       <table  cellspacing="0">
		              <tbody> 
					  <!--
		              	 <TR id="bltys"  > 
						          <TD class="blue" align=center width="20%">数据来源</TD>
					              <TD >
					                 <select id="seled"  style="width:100px;">
														</select>
					
						          </TD>
						          </TR> 
						-->
			              <tr> 
				                <td class="blue" align=center width="20%">操作备注</td>
				                <td colspan="2"> 
				                  	<input name=remark size=60 maxlength="60" >
				                </td>
			              </tr>
			              <tr> 
				                <td colspan="3">说明：<br>
				        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="red">数据文件为TXT文件,使用|作为分隔符.</font><br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="red">格式为：工号|生效开始时间|生效结束时间 回车</font><br>
					 
						</td>
			              </tr>   
		              </tbody> 
		      </table>
		      <table  cellspacing="0">
		              <tbody> 
			              <tr> 
				                <td id="footer" > 
				                  <input class="b_foot" name=sure type=button value=确认 onClick="dosubmit()">
				                  &nbsp;
				                 <input type="button" name="rets" class="b_foot" value="返回" onClick="returnBefo()"/>
				                  &nbsp;			                  
				                  <input class="b_foot" name=reset type=reset value=关闭 onClick="removeCurrentTab()">
				                  &nbsp; 
				                 </td>
			              </tr>
		              </tbody> 	            
		   </table>	
		  
		   <input type="hidden" name="regCode" value="01" >
		   <input type="hidden" name="sysAccept" value="1234" >  
		   <input type="hidden" name="loginNo" value="<%=workno%>">
		   <input type="hidden" name="op_code" value="<%=opCode%>">
		   <input type="hidden" name="inputFile" value=""> 
	
	<%@ include file="/npage/include/footer_simple.jsp"%>
  <%@ include file="../../npage/common/pwd_comm.jsp" %>
</form>
 </BODY>
</HTML>