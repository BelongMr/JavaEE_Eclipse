<%
  /**
   * 功能: 质检权限管理->分配质检权限->右侧顶部标题栏
　 * 版本: 1.0.0
　 * 日期: 2008/11/05
　 * 作者: mixh
　 * 版权: sitech
   * update:
　 */
%>
<%@ page language="java" pageEncoding="gbk"%>
<%@ include file="/npage/include/public_title_name.jsp"%>
<HTML>
		<HEAD>
		<LINK
			href="<%=request.getContextPath()%>/nresources/default/css/dtmltree_css/dhtmlxtree.css"
			type=text/css rel=STYLESHEET>
	</HEAD>
	<BODY>
		<TABLE width="100%" height="20" cellSpacing="0" valign="center">
			<TR id="Operation_Title">
				<TD width="220"  valign="center" align="left" >
					被检组信息
				</TD>
				<TD   valign="center" align="left" >
					被检组工号列表
				</TD>
			</TR>
		</TABLE>
	</BODY>
</html>
