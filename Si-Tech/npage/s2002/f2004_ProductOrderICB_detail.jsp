<%
   /*
   * ����: ���ⷴ��
�� * �汾: v1.0
�� * ����: 2008��10��25��
�� * ����: piaoyi
�� * ��Ȩ: sitech
   * �޸���ʷ
   * �޸�����      �޸���      �޸�Ŀ��
 ��*/
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
  String opName="ICB����ֵ";
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

	
 <div class="title"><div id="title_zi">ICB����ֵ</div></div>
 <input type="hidden" id="p_POSpecNumber" value="">
 <input type="hidden" id="p_POSpecRatePolicyID" value="">
 <input type="hidden" id="p_RatePlanID" value="">
 
 <table>
  <tr>
   <td>�ʷ�ģʽ   	
   </td>
   <td>
   	   <input id="p_ICBPatterNumber" type="string" size="20" maxlength="20">   		   	  
   </td>
   <td>�ʷ�ģʽ����   	
   </td>
   <td>
   	   <input id="p_Description" type="string" size="20" maxlength="20">
   		   	  
   </td>
 	</tr> 	 	
 </table>
<br>  
 <DIV id="div0_show"   class="groupItem">
   <DIV class="title">
	    <DIV id="zi"><img id="div0_switch" class="closeEl" src="../../../nresources/default/images/jia.gif" style='cursor:hand' width="15" height="15"></DIV>
   	  <DIV id="zi0">�����б�</DIV>
   </DIV>
   <DIV class="itemContent" id="mydiv0">
	 	  <DIV id="wait0"><img src="/nresources/default/images/protalloading.gif"  width="150" height="30">
	 	  </DIV>
   </DIV>
</DIV>
<table>
  <tr>
    <td align="center" id="footer" colspan="4">
    	<input class="b_foot" id=confirm type=button value="ȷ��" onClick="window.close()">
      <input class="b_foot" id=closebtn type=button value="�ر�" onClick="window.close()">
    </td>
  </tr>
</table>
</div>
</div>
<script>
var CMCCPrd;

var _jspPage =
{"div0_switch":["mydiv0","f2004_ProductParameter_list.jsp","f"]
};
function hiddenSpider()
{
	document.getElementById("mydiv0").style.display='none';
}

$(document).ready(function () {
	//���ؽ�����
	hiddenSpider();
	$('img.closeEl').bind('click', toggleContent);
	$('#nextoper').click(function(){
     nextoper();
  });

  }
);

var toggleContent = function(e)
{
	var targetContent = $( 'DIV.itemContent',this.parentNode.parentNode.parentNode);
	if (targetContent.css('display') == 'none') {  	  
		   targetContent.slideDown(300);
		   $(this).attr({ src: "../../../nresources/default/images/jian.gif"});
		   //���÷���
		   try{
		   	var tmp = $(this).attr('id');
		   	var tmp2 = eval("_jspPage."+tmp);
		   	if(tmp2[2]=="f"&&tmp2[1]!=''&&tmp2[1]!=undefined)
		   	{  		   		
		   		$("#"+tmp2[0]).load(tmp2[1],{sPOSpecNumber:$("#p_POSpecNumber").val()
		   			                          ,sPOSpecRatePolicyID:$("#p_POSpecRatePolicyID").val()
		   			                          ,sRatePlanID:$("#p_RatePlanID").val()
		   			                          ,sICBPatterNumber:$("#p_ICBPatterNumber").val()
		   			                          });
		   		tmp2[2]="t";
		   	}
		   }catch(e)
		   {  		   	
		   }
	} else {
		targetContent.slideUp(300);
		$(this).attr({ src: "../../../nresources/default/images/jia.gif"});
	}
	return false;
};

//ҳ��װ��
$(document).ready(function () { 
	  POICB=window.dialogArguments;	  
	  $("#p_ICBPatterNumber").val(POICB[0].trim());  
	  $("#p_Description").val(POICB[1]);      
	  $("#p_POSpecNumber").val(POICB[2]);	  
	  $("#p_POSpecRatePolicyID").val(POICB[3]);
	  $("#p_RatePlanID").val(POICB[4]);		  		      
	}
);
</script>
</BODY>
</HTML>