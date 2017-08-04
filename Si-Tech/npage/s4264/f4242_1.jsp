<!DOCTYPE html PUBLIC "-//W3C//Dtd Xhtml 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<%

  /*
   * 功能:使用中心配置
   * 版本: 1.0
   * 日期: 2009/3/23
   * 作者: dujl
   * 版权: si-tech
  */
%>
<%@	page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*"%>

<%
	response.setHeader("Pragma","No-Cache"); 
	response.setHeader("Cache-Control","No-Cache");
	response.setDateHeader("Expires", 0); 
    
	String opCode = "4242";
	String opName = "使用中心配置";
	String dateStr = new java.text.SimpleDateFormat("yyyyMM").format(new java.util.Date());
	String orgCode =(String)session.getAttribute("orgCode");
	String regionCode = orgCode.substring(0,2);
	
	StringBuffer  insql = new StringBuffer();
	insql.append("select type_code,unit_code,department_code,center_code, center_name ");
	insql.append("  from sUseCenter ");
	insql.append(" where USE_FLAG = 'Y' ");
	insql.append(" order by type_code,unit_code,department_code,center_code ");
	System.out.println("insql====="+insql);
	
	StringBuffer  stypesql = new StringBuffer();
	stypesql.append("select type_code, nvl(b.region_name,'省公司') ");
	stypesql.append("  from sUseCenter a, sregioncode b  ");
	stypesql.append(" where a.USE_FLAG = 'Y'  ");
	stypesql.append(" and  a.type_code=b.region_code(+) ");
	stypesql.append(" group by type_code,nvl(b.region_name,'省公司') ");
	stypesql.append(" order by type_code ");
	System.out.println("stypesql====="+stypesql);
	
	StringBuffer  sunitsql = new StringBuffer();
	sunitsql.append("select type_code, nvl(b.region_name,'省公司') ");
	sunitsql.append("  from sUseDepartment a, sregioncode b  ");
	sunitsql.append(" where a.USE_FLAG = 'Y'  ");
	sunitsql.append(" and  a.type_code=b.region_code(+) ");
	sunitsql.append(" group by type_code,nvl(b.region_name,'省公司') ");
	sunitsql.append(" order by type_code ");
	System.out.println("sunitsql====="+sunitsql);
	
%>
<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode1" retmsg="retMsg1" outnum="5">
<wtc:sql><%=insql%></wtc:sql>
</wtc:pubselect>
<wtc:array id="cneterData" scope="end" />

<wtc:pubselect name="sPubSelect"  routerKey="region" routerValue="<%=regionCode%>" outnum="2">
<wtc:sql><%=stypesql%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result1" scope="end" />

<wtc:pubselect name="sPubSelect"  routerKey="region" routerValue="<%=regionCode%>" outnum="2">
<wtc:sql><%=sunitsql%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result2" scope="end" />

<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<script language="JavaScript">
<!--	
var oprType_Add = "a";
var oprType_Del = "d";
var oprType_Qry = "q";

var arrtypeCode=new Array();
var arrunitcode=new Array();
var arrdepartmentcode=new Array();
var arrCentercode=new Array();
var arrCentername=new Array();
    
<%  
  	for(int i=0;i<cneterData.length;i++)
  	{
		out.println("arrtypeCode["+i+"]='"+cneterData[i][0]+"';\n");
		out.println("arrunitcode["+i+"]='"+cneterData[i][1]+"';\n");
		out.println("arrdepartmentcode["+i+"]='"+cneterData[i][2]+"';\n");
		out.println("arrCentercode["+i+"]='"+cneterData[i][3]+"';\n");
		out.println("arrCentername["+i+"]='"+cneterData[i][4]+"';\n");
	}
%>

onload=function()
{		
	init();
}

// 初始化
function init()
{
	chg_opType();
}

// 操作类型
function chg_opType()
{
	with(document.frm4242)
	{
		var op_type = opType[opType.selectedIndex].value;

		if( op_type == oprType_Add )
		{
			add.style.display="";
			other.style.display="none";
			showAdd.style.display="";
			showOther.style.display="none";	
			codeAdd.style.display="";
			codeOther.style.display="none";
			dAdd.style.display="";	
			dOther.style.display="none";
		}
		else
		{
			add.style.display="none";
			other.style.display="";
			showAdd.style.display="none";
			showOther.style.display="";
			codeAdd.style.display="none";
			codeOther.style.display="";	
			dAdd.style.display="none";	
			dOther.style.display="";
		}
		enabledInput();
		chg_sCenterCode();
		
		if(op_type == oprType_Add)
		{
			typeCode.value = "";
			unitCode.value = "";
			adepartmentCode.value = "";
			centerName.value = "";
		}
		stypeCode.value = "";
		sunitCode.value = "";
		sdepartmentCode.vlue = "";
		sCenterCode.value = "";
		aCenterCode.value = "";
	}
	if(op_type == oprType_Add)
	{
		chg_addtypeCode();
		chg_aunitCode();
		document.all.adepartmentCode.value = "";
	}
	else
	{
		chg_typeCode();
	}
}	


// 名称活性控制
function enabledInput()
{
	with(document.frm4242)
	{
		var op_type = opType[opType.selectedIndex].value;
		if(op_type == oprType_Add)
		{
			centerName.disabled =  false;
		}
		else
		{
			centerName.disabled =  true;
		}						
	}
}

// 名称清空	
function clearInput()
{
	with(document.frm4242)
	{
		centerName.value = "";
	}		
}
 
// check
function judge_valid()
{
	with(document.frm4242)
	{
		var op_type = document.frm4242.opType[document.frm4242.opType.selectedIndex].value;
		if(op_type == oprType_Add)
		{
			if(typeCode.value==""){
	  				rdShowMessageDialog("请输入省市标志!");
	  				return false;
			}
			if(unitCode.value==""){
	  				rdShowMessageDialog("请输入单位代码");
	  				return false;
			}
			if(adepartmentCode.value==""){
				rdShowMessageDialog("请输入部门代码!");
				return false;
			}
			if(aCenterCode.value==""){
				rdShowMessageDialog("请输入中心代码!");
				return false;
			}
			if(centerName.value==""){
				rdShowMessageDialog("请输入中心名称!");
				return false;
			}
		}
		if(op_type == oprType_Del)
		{
			if(stypeCode.value==""){
	  				rdShowMessageDialog("请输入省市标志!");
	  				return false;
			}
			if(sunitCode.value==""){
	  				rdShowMessageDialog("请输入单位代码");
	  				return false;
			}
			if(sdepartmentCode.value==""){
				rdShowMessageDialog("请输入部门代码!");
				return false;
			}
			if(sCenterCode.value==""){
				rdShowMessageDialog("请输入中心代码!");
				return false;
			}
		}
	return true
	}
}

// 列表
function DoList()
{
	if (IList.style.display != "none")
	{
		IList.style.display = "none";
	}
	else
	{
		IList.style.display = "";
	}
}

// 清除
function resetJsp()
{
	var op_type = document.frm4242.opType[document.frm4242.opType.selectedIndex].value;
	if( op_type == oprType_Add )
	{	
		document.frm4242.adepartmentCode.value = "";
		clearInput();
	}	
}

// 确认
function commitJsp()
{
	var tmpStr="";
	var op_type = document.frm4242.opType[document.frm4242.opType.selectedIndex].value;
	var procSql = "";
	if( op_type == oprType_Qry )
	{
		rdShowMessageDialog("查询不能确认!");
		return false;					
	}	
	if( !judge_valid() )
	{
		return false;
	}
	
	frm4242.submit();
}

// code连动名称
function chg_sCenterCode()
{
 	for ( x1 = 0 ; x1 < arrtypeCode.length  ; x1++ )
 	{
 		if((arrtypeCode[x1] == document.all.stypeCode.value) && (arrCentercode[x1] == document.all.sCenterCode.value))
 		{
 			document.all.centerName.value=arrCentername[x1];
 		}
 	}
 	IList.style.display = "none";
}

function fillSelect(obj,code,text)
{
	obj.length=0;
	var option0 = new Option("--请选择--","");
	obj.add(option0);
	for(var i=0; i<code.length; i++)
	{
		var option1 = new Option(text[i],code[i]);
        obj.add(option1);
	}
}

function fillSelectAdd(obj,code,text)
{
	obj.length=0;
	var option0 = new Option("--请选择--","");
	obj.add(option0);
	for(var i=0; i<code.length; i++)
	{
		var option1 = new Option(code[i]+"-->"+text[i],code[i]);
        obj.add(option1);
	}
}

// 省市标志--单位代码(other)
function chg_typeCode()
{
	if(document.all.stypeCode.value != "")
	{
		var sql = "90000239";
		var sqlParam = document.all.stypeCode.value+"|"+document.all.stypeCode.value+"|";
		var rpc_flag = "chg_typeCode";
		sendRpc(sql,sqlParam,rpc_flag);
	}
	document.all.sdepartmentCode.value = "";
	document.all.sCenterCode.value = "";
	document.all.centerName.value = "";
}

// 判断rpc_select的迁移
function doProcess(packet)
{
	var retCode = packet.data.findValueByName("retCode");
	var retMsg =  packet.data.findValueByName("retMsg");
	var rpc_flag = packet.data.findValueByName("rpc_flag");
	self.status="";
	
	if(retCode != "000000")
	{
		rdShowMessageDialog(retMsg);
		return;
	}
	if(rpc_flag == "chg_typeCode")
	{
		var code = packet.data.findValueByName("code");
		var text =  packet.data.findValueByName("text");
		fillSelectAdd(document.all.sunitCode,code,text);
	}
	else if(rpc_flag == "chg_suitCode")
	{
		var code = packet.data.findValueByName("code");
		var text =  packet.data.findValueByName("text");
		fillSelectAdd(document.all.sdepartmentCode,code,text);
	}
	else if(rpc_flag == "chg_sdepartmentCode")
	{
		var code = packet.data.findValueByName("code");
		var text =  packet.data.findValueByName("text");
		fillSelectAdd(document.all.sCenterCode,code,text);
	}
	else if(rpc_flag == "chg_addtypeCode")
	{
		var code = packet.data.findValueByName("code");
		var text =  packet.data.findValueByName("text");
		fillSelectAdd(document.all.unitCode,code,text);
	}
	else if(rpc_flag == "chg_aunitCode")
	{
		var code = packet.data.findValueByName("code");
		var text =  packet.data.findValueByName("text");
		fillSelectAdd(document.all.adepartmentCode,code,text);
	}
}

// AJAXPacket
function sendRpc(sql,sqlparam,rpc_flag)
{
	var myPacket = new AJAXPacket("/npage/s9387/rpc_select.jsp","正在获取信息，请稍候......"); 
	myPacket.data.add("sql",sql);
	myPacket.data.add("sqlParam",sqlparam);
	myPacket.data.add("rpc_flag", rpc_flag);
	core.ajax.sendPacket(myPacket);
	myPacket=null;  
}

// 单位代码--部门代码(other)
function chg_suitCode()
{
	if(document.all.sunitCode.value != "")
	{
		var sql = "90000240";
		var sqlParam = document.all.stypeCode.value+"|"+document.all.sunitCode.value+"|"+document.all.stypeCode.value+"|"+document.all.sunitCode.value + "|";
		var rpc_flag = "chg_suitCode";
		sendRpc(sql,sqlParam,rpc_flag);
	}
	document.all.sCenterCode.value = "";
	document.all.centerName.value = "";
}

// 部门代码--中心(other)
function chg_sdepartmentCode()
{
	if(document.all.sdepartmentCode.value != "")
	{
		var sql = "90000241";
		var sqlParam = document.all.stypeCode.value+"|"+document.all.sunitCode.value+"|"+document.all.sdepartmentCode.value+"|";
		var rpc_flag = "chg_sdepartmentCode";
		sendRpc(sql,sqlParam,rpc_flag);
	}
	document.all.centerName.value = "";
}

// 省市标志--单位代码(add)
function chg_addtypeCode()
{
	if(document.all.typeCode.value != "")
	{
		var sql = "90000242";
		var sqlParam = document.all.typeCode.value+"|"+document.all.typeCode.value+"|";
		var rpc_flag = "chg_addtypeCode";
		sendRpc(sql,sqlParam,rpc_flag);
	}
	document.all.adepartmentCode.value = "";
}

// 单位代码--部门代码(add)
function chg_aunitCode()
{
	if(document.all.unitCode.value != "")
	{
		var sql = "90000243";
		var sqlParam = document.all.typeCode.value+"|"+document.all.unitCode.value+"|";
		var rpc_flag = "chg_aunitCode";
		sendRpc(sql,sqlParam,rpc_flag);
	}
	document.all.adepartmentCode.value = "";
}

</script> 
 
<title>使用中心配置</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<BODY>
<form action="f4242Cfm.jsp" method="post" name="frm4242"  >
	<input type="hidden" name="opCode" value="<%=opCode%>">
	<input type="hidden" name="opName" value="<%=opName%>">
	<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">使用中心配置</div>
	</div>
<table cellspacing="0">           
	<tr> 
		<td class="blue" width="8%" nowrap>操作类型</td>
		<td width="35%"> 
			<select name="opType" class="button" id="select" onChange="chg_opType()">
				<option value="a">增加</option>
        		<option value="d">删除</option>
        		<option value="q" selected>查询</option>
      		</select>
    	</td>
    </tr>
    <tr id="other">
    	<td class="blue" width="8%" nowrap>省市标志</td>
    	<td>
    	<select name="stypeCode" class="button" id="select" onchange="chg_typeCode()" >
    		<option value="">--请选择--</option>
    		<%for (int i = 0; i < result1.length; i++) {%>
	      		<option value="<%=result1[i][0]%>"><%=result1[i][1]%>
	      		</option>
	    	<%}%>
    	</select>
    	</td>
	  	</tr>
  	<tr id="add">
  		<td class="blue" width="8%" nowrap>省市标志</td>
  		<td>
    	<select name="typeCode" class="button" id="select" onchange="chg_addtypeCode()" >
    		<option value="">--请选择--</option>
			<%for (int i = 0; i < result2.length; i++) {%>
	      	<option value="<%=result2[i][0]%>"><%=result2[i][1]%>
	      	</option>
	    	<%}%>
    	</select>
    	</td>
	</tr>
	<tr id="codeOther">
		<td class="blue" width="8%">单位代码</td>
		<td>
			<select name="sunitCode" id="unitCode1" onchange="chg_suitCode()">
				<option value="">--请选择--</option>
			</select>
		</td>
		
	</tr>
	<tr id="codeAdd">
		<td class="blue" width="8%">单位代码</td>
		<td>
			<select name="unitCode" id="unitCode" onchange="chg_aunitCode()">
				<option value="">--请选择--</option>
			</select>
		</td>
	</tr>
	<tr id="dOther">
		<td class="blue" width="8%">部门代码</td>
		<td>
			<select name="sdepartmentCode" id="departmentCode" onchange="chg_sdepartmentCode()"> 
			    <option value="">--请选择--</option>
      		</select>
		</td>
	</tr>
	<tr id="dAdd">
		<td class="blue" width="8%">部门代码</td>
		<td>
			<select name="adepartmentCode" id="departmentCode" > 
			    <option value="">--请选择--</option>
      		</select>
		</td>
	</tr>
	<tr id="showOther" >
		<td class="blue" width="8%">中心代码</td>
		<td> 
			<select name="sCenterCode" id="centerCode" onchange="chg_sCenterCode()"> 
			    <option value="">--请选择--</option>
      		</select>
    	</td>
	</tr>
	<tr id="showAdd" >
		<td class="blue" width="8%">中心代码</td>
		<td><input name="aCenterCode" type="text" class="button" id="aCenterCode" v_type="0_9" maxlength="4" style="ime-mode:disabled" onKeyPress="return isKeyNumberdot(0)" v_must=1 v_name="中心代码"> 
		</td>
	</tr>
	<tr>
		<td class="blue" width="8%">中心名称</td>
		<td><input name="centerName" type="text" class="button" id="cneterName" size="60" v_must=1 v_type=string v_name="中心名称"></td>
	</tr>		
	<tr> 
		<td align="center" id="footer" colspan="4"> 
			<input type="button" name="IList"  class="b_foot" value="列表" onclick="DoList()">
			&nbsp;
			<input type="button" name="confirm" class="b_foot" value="确认" onclick="commitJsp()">
			&nbsp;
			<input type="button" name="reset" class="b_foot" value="清除" onclick="resetJsp()">
		</td>
	</tr>
</table>
<table style="display='none'" id="IList" border="2" align="center" cellPadding=0 cellSpacing=0  width="95%">
   <tr>
   	<td>
   <table align="center" valign="top" border="1" cellPadding=4 cellSpacing=0  width="100%">
 <%
 	out.println("<tr height=30>");
 	out.println("<th align='center'>省市标志</th>");
 	out.println("<th align='center'>单位代码</th>");
 	out.println("<th align='center'>部门代码</th>");
 	out.println("<th align='center'>中心代码</th>");
 	out.println("<th align='center'>中心名称</th>");
 	out.println("</tr>");
 	for(int i =0; i < cneterData.length; i++)
 	{
	 		out.println("<tr align=center>");
	 		out.println("<td>" + cneterData[i][0]  +  "</td>");
	 		out.println("<td>" + cneterData[i][1]  +  "</td>");
	 		out.println("<td>" + cneterData[i][2]  +  "</td>");
	 		out.println("<td>" + cneterData[i][3]  +  "</td>");
	 		out.println("<td>" + cneterData[i][4]  +  "</td>");
	 		out.println("</tr>");
 	} 
 %>
 </table>

  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <p>&nbsp;</p>

</td>
</tr>
</table>
	 <%@ include file="/npage/include/footer.jsp" %>
</form>
</BODY>
</HTML>
