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
<%@ page import="java.util.*"%>
<%@ page import="com.sitech.crmpd.core.wtc.WtcUtil"%>
<%@ taglib uri="/WEB-INF/wtc.tld" prefix="wtc" %>
<%@ page contentType= "text/html;charset=GBK" %>

<%
  String workNo = (String)session.getAttribute("workNo");
  String org_code = (String)session.getAttribute("orgCode");
  String regionCode=org_code.substring(0,2);
  String sPOSpecNumber = request.getParameter("sPOSpecNumber");
  String sPOSpecRatePolicyID = request.getParameter("sPOSpecRatePolicyID");   
%>

<div id="form">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<form id="bug_form" method="post" action="">
	      <tr>
	        <th width="25%" nowrap>资费计划标识</th>
	        <th width="75%" nowrap>资费描述</th>		        
	      </tr>
        <tbody>
<wtc:service name="s9100DetQry" outnum="6" routerKey="region" routerValue="<%=regionCode%>">		
	<wtc:param value="<%=sPOSpecRatePolicyID%>"/>
    <wtc:param value="1"/>
  	<wtc:param value="<%=sPOSpecNumber%>"/>
</wtc:service>
<wtc:array id="result" start="2" length="3" scope="end" />
<%
if(retCode.equals("000000")){
	if(result.length>0){
		for(int i=0;i<result.length;i++){
%>
  			  <tr
  			  	 a_RatePlanID = "<%=result[i][1]%>"
  			  	 a_Description  = "<%=result[i][2]%>"
  			  >					
					  <td>
					  <a class="p_RatePlanID" style="cursor: hand;"><%=result[i][1]%></a>						  	
					  &nbsp;</td>
					  <td class=p_Description><%=result[i][2]%>
					  &nbsp;</td>
	        </tr>
<%
    }
  }
}
%>
	      </tbody>
		</form>
	</table>
</div>
<script>
//隐藏滚动条
$("#wait2").hide();
	 //更新函数
	function RatePlanUpdate(){
		//alert("222");
    var RatePlanUpdateTR = $(this).parent().parent();    
	 	var RatePlanUpdate=[
	 	  	        $(RatePlanUpdateTR).attr("a_RatePlanID"),              //0资费计划标识
	 	  	        $(RatePlanUpdateTR).attr("a_Description"),             //1资费描述    	 	  	       	 	  	       
	 	  	        '<%=sPOSpecNumber%>',                                    //2商品规格编码 
	 	  	        '<%=sPOSpecRatePolicyID%>'                               //3资费策略编码
	 	  	        ];
	 	//alert(RatePlanUpdate);
	  var retInfo = window.showModalDialog
	  (
	  'f2004_RatePlan_detail.jsp',
	  RatePlanUpdate,
	  'dialogHeight:500px; dialogWidth:700px;scrollbars:yes;resizable:no;location:no;status:no'
	  );
	  //alert(retInfo);
	  //alert("234323");
	  return true;
	}
$(document).ready(function(){
	 //注册更新函数
	 $('.p_RatePlanID').bind('click', RatePlanUpdate);
});
</script>
