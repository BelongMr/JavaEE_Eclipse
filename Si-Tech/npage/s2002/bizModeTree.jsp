<%
   /*
   * 功能: 服务类型属性树。
　 * 版本: v1.0
　 * 日期: 2007/06/20
　 * 作者: liubo
　 * 版权: sitech
   * 修改历史
 　*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
	String loginNo = WtcUtil.repNull((String)session.getAttribute("workNo"));
	String loginName = WtcUtil.repNull((String)session.getAttribute("workName"));
	String orgCode = WtcUtil.repNull((String)session.getAttribute("orgCode"));
	String ip_Addr = WtcUtil.repNull((String)session.getAttribute("ipAddr"));
	String regionCode = WtcUtil.repNull((String)session.getAttribute("regCode"));
	String nopass  = WtcUtil.repNull((String)session.getAttribute("password"));               //登陆密码
		
	String ProdType=WtcUtil.repNull(request.getParameter("ProdType"));//产品类型
	String sm_code=WtcUtil.repNull(request.getParameter("sm_code"));//品牌
	String prod_direct=WtcUtil.repNull(request.getParameter("prod_direct"));//业务类型
	String biz_code=WtcUtil.repNull(request.getParameter("biz_code"));//业务代码
	System.out.println("ProdType=="+ ProdType);
	System.out.println("sm_code=="+ sm_code);
	System.out.println("prod_direct=="+ prod_direct);
	System.out.println("biz_code=="+ biz_code);
	
	String grouptype = request.getParameter("grouptype")==null?"frm":request.getParameter("grouptype"); 
	
	String dataJsp = "bizModeXml.jsp?isRoot=true&ProdType="+ProdType+"&sm_code="+sm_code+"&prod_direct="+prod_direct+"&biz_code="+biz_code;
	String workNo = loginNo;	
	String workName = loginName;
	String opName = "服务类型属性树";
  
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<script language="JavaScript" src="xtree/script/loader.js"></script>
<link rel="stylesheet" type="text/css" href="xtree/css/xtree.css">
<style type="text/css">
a:link,a:visited { text-decoration: none; color: #003399 }
font { font-family: 宋体; font-size: 13px; }
</style>
<script language="JavaScript"> 
//-----返回组织节点-------	
function saveTo(product_code,product_name,catalog_item_id)
{
		//alert("销售品标识|"+product_code);
		//alert("销售品名称|"+product_name);
		//alert("销售品名称|"+catalog_item_id);		

		var packet = new AJAXPacket("newGrpTreeSave.jsp","请稍后...");
		packet.data.add("offer_id" ,product_code);
		packet.data.add("offer_name" ,product_name);
		packet.data.add("parent_offer_id" ,catalog_item_id);
		core.ajax.sendPacket(packet,doSaveTo,true);
		packet =null;
}
//-----返回组织节点-------
function doSaveTo(packet)
{
	  var retCode = packet.data.findValueByName("retCode"); 
	  var retMsg = packet.data.findValueByName("retMsg"); 
	  var product_code = packet.data.findValueByName("offer_id");
	  var product_name = packet.data.findValueByName("offer_name");
	  var biz_code = packet.data.findValueByName("biz_code");
	  var biz_name = packet.data.findValueByName("biz_name");
	  var catalog_item_id = packet.data.findValueByName("catalog_item_id");
	 // alert("["+product_code+"]["+product_name+"]["+biz_code+"]["+biz_name+"]["+catalog_item_id+"]");
	 if(retCode=="000000"){
	 	    window.opener.form1.product_name.value = product_name;
	 	    window.opener.form1.product_code1.value = product_name;
	 	    window.opener.form1.product_code.value = product_code;
		   
				window.close();
	 }else{
	 	 rdShowMessageDialog("错误"+retMsg);
	} 
}

</SCRIPT>
</head>
<body>
<form name="frm" method="post" action="">
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">销售品目录树</div>
</div>   
<table cellspacing="0" >
    <tr>
        <td height="600" valign="top" nowrap>
            <script>loader();</script>
            <div id="xtree"  XmlSrc="<%=dataJsp%>"></div>
            <script language="JavaScript">
                <!--
                    document.all.xtree.className="xtree";
                //-->
            </script>
        </td>
    </tr>
</table>
</div>
</form>
</body>
</html>