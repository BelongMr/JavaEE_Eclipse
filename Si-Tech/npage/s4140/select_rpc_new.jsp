<%
/********************
 version v2.0
开发商: si-tech
********************/
%>
<%request.setCharacterEncoding("GB2312");%>
<%@ page contentType= "text/html;charset=gb2312" %>
<%@ page import="com.sitech.boss.pub.util.CreatePlanerArray"%>
<%@ page import="com.sitech.boss.s1210.pub.Pub_lxd"%>
<%@ page import="com.sitech.boss.s1270.viewBean.*" %>
<%@ page import="java.util.*;"%>
<%@ page import="java.io.*"%>
<%@ page import="com.sitech.boss.pub.*" %>
<%@ page import="com.sitech.boss.util.*"%>
<%@ taglib uri="/WEB-INF/wtc.tld" prefix="wtc" %> 
<%/*
*此页面用于对RPC连动调用服务，并穿回结果集
*/%>

<%
S1270View  callView = new S1270View();   
String sqlStrNo = ReqUtil.get(request,"sqlStrNo");
String sqlStrVal = ReqUtil.get(request,"sqlStrVal");
ArrayList retArray_select = new ArrayList();
String[][] result = new String[][]{};
String org_Code = (String)session.getAttribute("orgCode");
String regionCode = org_Code.substring(0,2);
//retArray_select = callView.spubqry32Process("2","0",sqlStrNo).getList();
%>
<wtc:service name="sBossDefSqlSel"  routerKey="region" routerValue="<%=regionCode%>" outnum="2">
        <wtc:param value="<%=sqlStrNo%>"/>
        <wtc:param value="<%=sqlStrVal%>"/>
</wtc:service>
<wtc:array id="returnStr1" scope="end" />
<%
System.out.println("sPubSelectsPubSelectsPubSelectsPubSelectsPubSelect===="+retCode);
String[][] tri_metaData =returnStr1;
String tri_metaDataStr = CreatePlanerArray.createArray("js_tri_metaDataStr",tri_metaData.length);
%>
<%=tri_metaDataStr %>
<%  
  for(int p=0;p<tri_metaData.length;p++)
  {
          for(int q=0;q<tri_metaData[p].length;q++)
          {
%>
        js_tri_metaDataStr[<%=p%>][<%=q%>]="<%=tri_metaData[p][q]%>";
<%
          }
  }
%>

var response = new AJAXPacket();
response.guid = '<%= request.getParameter("guid") %>';
response.data.add("rpc_page","chg_city");
response.data.add("tri_list",js_tri_metaDataStr);
response.data.add("retType","<%= request.getParameter("retType") %>");
core.ajax.receivePacket(response);
