<%
  /*
   * ����: Ԥ������Ž���������������ҳ��
�� * �汾: 1.0.0
�� * ����: 2009/01/15
�� * ����: fengliang
�� * ��Ȩ: sitech
   * update:
�� */
%>
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%@ page import="com.sitech.crmpd.core.wtc.util.*,java.util.*"%>

<%

 response.setHeader("Pragma", "No-cache");
 response.setHeader("Cache-Control", "no-cache");
 response.setHeader("Expires", "0");

%>

<%
StringBuffer xml = new StringBuffer();
xml.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
xml.append("<tree id=\"-1\">");
xml.append("<item text=\"ȫ��Ԥ������ŷ���\" id=\"0\" open=\"0\" im0=\"folderClosed.gif\" im1=\"folderOpen.gif\" im2=\"folderClosed.gif\"  >");
//xml.append(" child=\"0\"  >");
xml.append("<userdata name='isleaf'>0</userdata>");
xml.append("<userdata name='super_id'>-1</userdata>");
xml.append("<userdata name='isscored'>0</userdata>");
xml.append("<userdata name='object_id'></userdata>");
xml.append("</item>");
xml.append("</tree>");

//System.out.println("xml :\n" + xml.toString());
response.setContentType("text/xml; charset=UTF-8");
response.getWriter().write(xml.toString());
response.getWriter().close();
%>