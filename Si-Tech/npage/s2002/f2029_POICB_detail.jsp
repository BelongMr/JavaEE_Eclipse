<%
/*关于跨省专线业务两级订单流改造的需求*/
%>
<%
   /*
   * 功能: 问题反馈
　 * 版本: v1.0
　 * 日期: 2008年10月25日
　 * 作者: piaoyi
　 * 版权: sitech
   * 修改历史
   * 修改日期      修改人      修改目的
 　*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd>
<HTML xmlns="http://www.w3.org/1999/xhtml">
<%@ taglib uri="weblogic-tags.tld" prefix="wl" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%
	response.setHeader("Pragma","No-Cache");
	response.setHeader("Cache-Control","No-Cache");
  response.setDateHeader("Expires", 0);
  String opCode="";
  String opName="ICB参数值";
  String sqlStr="";
%>
<HTML>
<HEAD>
<link href="<%=request.getContextPath()%>/css/jl.css" rel="stylesheet" type="text/css">
<link href="s2002.css" rel="stylesheet" type="text/css">
</HEAD>
<BODY>
<div id="Main">
<DIV id="Operation_Table">

	
 <div class="title"><div id="title_zi">ICB参数值</div></div>
 <input type="hidden" id="p_POSpecNumber" value="">
 <input type="hidden" id="p_POOrderNumber" value="">
 <input type="hidden" id="p_POSpecRatePolicyID" value="">
 <input type="hidden" id="p_RatePlanID" value="">
 <input type="hidden" id="p_ParAcceptID" value="">
 <input type="hidden" id="p_AcceptID" value="">
 
 <table>
  <tr>
   <td>参数编码   	
   </td>
   <td>
   	   <input id="p_ParameterNumber" type="string" size="20" maxlength="20" class="InputGrey" readonly >
   	  <input id="getParameterNumber" type="button" class="b_text" onclick="getParameterNumber()" value="查询">
   </td>
   <td>参数名   	
   </td>
   <td>
   	   <input id="p_ParameterName" type="string" size="20" maxlength="20" class="InputGrey" readonly >
   		   	  
   </td>
 	</tr> 
<tr>
   <td>参数值   	
   </td>
   <td colspan="3">
   	   <input id="p_ParameterValue" type="string" size="20" v_maxlength="12" maxlength="12" v_type="money"> 
   	   <!--<input id="getParameterValue" type="button" class="b_text" onclick="getParameterValue()" value="查询">-->  		   	  
   </td>
 	</tr> 		 	
 </table>

<table>
  <tr>
    <td align="center" id="footer" colspan="4">
    	<input class="b_foot" id=confirm type=button value="确认" onClick="">
      <input class="b_foot" id=closebtn type=button value="关闭" onClick="window.close()">
    </td>
  </tr>
</table>
</div>
</div>
<script>
var ProductOrderICB;

function ConfirmCheck(){
	
	
  if($("#p_ParameterNumber").val()=="")
  {
  	rdShowMessageDialog("参数编码不能为空!");
  	return;
  }
  if($("#p_ParameterName").val()=="")
  {
  	rdShowMessageDialog("参数名称不能为空!");
  	return;
  }
  if($("#p_ParameterValue").val()=="")
  {
  	rdShowMessageDialog("参数值不能为空!");
  	return;
  } else if (!checkElement(document.getElementById("p_ParameterValue"))) {
  	rdShowMessageDialog("参数值必须是大于等于0的，长度小于等于12位的数字！");
  	return;
  } else if (parseInt(document.getElementById("p_ParameterValue").value) < 0) {
  	rdShowMessageDialog("参数值必须是大于等于0的，长度小于等于12位的数字！");
  	return;
  }
 	 if (document.getElementById("p_ParameterValue").value.indexOf(".")>9) {
    	rdShowMessageDialog("参数值结构必须是9位数字加两位小数！");
      return;	
   }
    
  ProductOrderICB[0] = $("#p_ParameterNumber").val();
  ProductOrderICB[1] = $("#p_ParameterName").val();
  ProductOrderICB[2] = $("#p_ParameterValue").val();
  ProductOrderICB[3] = $("#p_POSpecNumber").val();
  ProductOrderICB[4] = $("#p_POOrderNumber").val();
  ProductOrderICB[5] = $("#p_POSpecRatePolicyID").val();
  ProductOrderICB[6] = $("#p_RatePlanID").val();
  ProductOrderICB[8] = $("#p_ParAcceptID").val();
  ProductOrderICB[9] = $("#p_AcceptID").val();
    
  window.returnValue = "Y";    
  window.close();
}
//页面装载
$(document).ready(function () {
	  ProductOrderICB=window.dialogArguments;	  
	  $("#p_ParameterNumber").val(ProductOrderICB[0]);  
	  $("#p_ParameterName").val(ProductOrderICB[1]); 
	  $("#p_ParameterValue").val(ProductOrderICB[2]); 	  	      
	  $("#p_POSpecNumber").val(ProductOrderICB[3]);	 
	  $("#p_POOrderNumber").val(ProductOrderICB[4]);	  
	  $("#p_POSpecRatePolicyID").val(ProductOrderICB[5]);
	  $("#p_RatePlanID").val(ProductOrderICB[6]);
	  $("#p_ParAcceptID").val(ProductOrderICB[8]);
	  $("#p_AcceptID").val(ProductOrderICB[9]);
	  
	  if($("#p_AcceptID").val()=="1")
	  {
	  		$("#getParameterNumber").hide();
	  		document.all.p_ParameterNumber.readOnly=true;
	  		document.all.p_ParameterName.readOnly=true;
	  		document.all.p_ParameterValue.readOnly=true;
	   }
	  
	  
	  //注册确认
    $('#confirm').click(function(){
  	   ConfirmCheck();
  	});
});
function getParameterNumber(){	  
	  var pageTitle = "ICB参数值";
    var fieldName = "参数编码|参数名|流水|";
    var sqlStr = "";
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "3|0|1|2|";

    var retToField = "p_ParameterNumber|p_ParameterName|p_AcceptID|";

    var path = "<%=request.getContextPath()%>/npage/s2002/f2029_getPOICB_list.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName="+fieldName;
    path = path + "&selType="+selType;
    path = path + "&retQuence="+retQuence;
    path = path + "&retToField="+retToField;
    path = path + "&sPOSpecNumber=" +$("#p_POSpecNumber").val();
    path = path + "&sPOOrderNumber="+$("#p_POOrderNumber").val();
    path = path + "&sPOSpecRatePolicyID=" +$("#p_POSpecRatePolicyID").val();
    path = path + "&sRatePlanID="+$("#p_RatePlanID").val();
    
    retInfo = window.open(path,
                          "newwindow",
                          "height=400, width=700,top=300,left=350,scrollbars=yes, resizable=no,location=no, status=yes");
    return true;
}

function getParameterNumberRtn(retInfo)
{
    var retToField = "p_ParameterNumber|p_ParameterName|p_AcceptID|";
    
    if (retInfo == undefined)
    {
        return false;
    }
    var chPos_field = retToField.indexOf("|");
    var chPos_retStr;
    var valueStr;
    var obj;
    while (chPos_field > -1)
    {
        obj = retToField.substring(0, chPos_field);
        chPos_retInfo = retInfo.indexOf("|");
        valueStr = retInfo.substring(0, chPos_retInfo);
        document.all(obj).value = valueStr;
        retToField = retToField.substring(chPos_field + 1);
        retInfo = retInfo.substring(chPos_retInfo + 1);
        chPos_field = retToField.indexOf("|");
    }
}

function getParameterValue(){
	
	if($("#p_ParameterNumber").val()=="")
	{
		rdShowMessageDialog("请先选择一个参数代码!");
  	      return;
	}
	 var pageTitle = "ICB参数值";
    var fieldName = "参数编码|参数值|流水|";
    var sqlStr = "";
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "3|0|1|2|";

    var retToField = "p_ParameterNumber|p_ParameterValue|p_AcceptID|";

    var path = "<%=request.getContextPath()%>/npage/s2002/f2029_getPOICBVal_list.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName="+fieldName;
    path = path + "&selType="+selType;
    path = path + "&retQuence="+retQuence;
    path = path + "&retToField="+retToField;
    path = path + "&sPOSpecNumber=" +$("#p_POSpecNumber").val();
    path = path + "&sPOOrderNumber="+$("#p_POOrderNumber").val();
    path = path + "&sPOSpecRatePolicyID=" +$("#p_POSpecRatePolicyID").val();
    path = path + "&sRatePlanID="+$("#p_RatePlanID").val();
    path = path + "&sParamcode="+$("#p_ParameterNumber").val();
    
    retInfo = window.open(path,
                          "newwindow",
                          "height=400, width=700,top=300,left=350,scrollbars=yes, resizable=no,location=no, status=yes");
    return true;
	
	
}

function getParameterValueRtn(retInfo)
{
    var retToField = "p_ParameterNumber|p_ParameterValue|p_AcceptID|";
    if (retInfo == undefined)
    {
        return false;
    }
    var chPos_field = retToField.indexOf("|");
    var chPos_retStr;
    var valueStr;
    var obj;
    while (chPos_field > -1)
    {
        obj = retToField.substring(0, chPos_field);
        chPos_retInfo = retInfo.indexOf("|");
        valueStr = retInfo.substring(0, chPos_retInfo);
        document.all(obj).value = valueStr;
        retToField = retToField.substring(chPos_field + 1);
        retInfo = retInfo.substring(chPos_retInfo + 1);
        chPos_field = retToField.indexOf("|");
    }
}
</script>
</BODY>
</HTML>
