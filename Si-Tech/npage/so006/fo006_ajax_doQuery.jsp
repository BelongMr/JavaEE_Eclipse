<%
   /*
   * 功能: 增值税纳税人审批信息列表
　 * 版本: v1.0
　 * 日期: 2013-08-30
　 * 作者: wangjxc	
　 * 版权: sitech
   * 修改历史
   * 修改日期:  	
   * 修改人:
   * 修改目的:
 　*/
%>
 
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_ajax.jsp" %>

<%
		String  regionCode   = (String)request.getParameter("regionCode");
		String  model   = (String)request.getParameter("model");
		String workNo = (String)session.getAttribute("workNo");
		String passWord = (String)session.getAttribute("passWord");
		String groupId = (String)session.getAttribute("groupId");
		int page_num=Integer.parseInt((String)request.getParameter("PAGE_NUM"));//页码
		String page_num_string=page_num+"";
%>

<wtc:service name="sTaxCustRelQry" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode" retmsg="retMsg" outnum="18">
	  <wtc:param value="<%=regionCode%>"/>
	  <wtc:param value="<%=model%>"/>
	  <wtc:param value="<%=page_num_string%>"/>
	  <wtc:param value="10"/>
</wtc:service>
<wtc:array id="retList"  scope="end"/>
	<%
	String[][] AllPageNum   = new String[][]{};
	AllPageNum   = retList;
	String data_num="";
	int anum = 0;
	if(retList.length>0)
	{
		data_num = AllPageNum[0][0];
		anum = Integer.parseInt(data_num);
	}	
	%>	


<div class="list">
		<table id="tbSort">
	<tr>
		<th>总机构编码</th>
		<th>总机构名称</th>
		<th>分机构编码</th>
		<th>分机构名称</th>
    	<th>申请人工号</th>
		<th>申请人名称</th>
		<th>申请人部门</th>
		<th>审批类型</th>
	</tr>

	<% 
	if("000000".equals(retCode)){
			int nowPage = 1;
			int allPage = 0;
			int pre_page = 0;
			int next_page = 0;
			
			if(retList.length==0){
				out.println("<tr height='25' align='center'><td colspan='12'>");
				out.println("<font class='orange'>没有任何记录！</font>");
				out.println("</td></tr>");
			}else if(retList.length>0){
				for(int i=0;i<retList.length;i++){
				
				
	%>
   <tr>
		<td><a href="javascript:viewTaxPayerInfo('<%=retList[i][2]%>','2')"><%=retList[i][7]%></td>
		<td><%=retList[i][8]%></td>
		<td><a href="javascript:viewTaxPayerInfo('<%=retList[i][1]%>','2')"><%=retList[i][5]%></td>
		<td><%=retList[i][6]%></td>
		<td><%=retList[i][9]%></td>
		<td><%=retList[i][10]%></td>
		<td><%=retList[i][11]%></td>
		<%
		 if ("2".equals(model)){ %>
		<td>
			<input value="通过" type="button" title="新增审批通过"  onClick="uptTaxrel('<%=retList[i][1]%>','1')"/>
			<input value="打回" type="button" title="新增审批打回"  onClick="uptTaxrel('<%=retList[i][1]%>','2')"/>
			<%-- <input class="butCha" type="button" title="新增审批通过"  onClick="uptTaxrel('<%=retList[i][1]%>','1')"/>
			<input class="butDel" type="button" title="新增审批打回" value="打回" onClick="uptTaxrel('<%=retList[i][1]%>','2')"/> --%>
		</td>
		<%} 
		 else if ("3".equals(model)){ %>
		<td>
			<input  type="button" title="删除审批通过" value="通过" onClick="uptTaxrel('<%=retList[i][1]%>','3')"/>
			<input  type="button" title="删除审批打回" value="打回" onClick="uptTaxrel('<%=retList[i][1]%>','4')"/>
			<%-- <input class="butCha" type="button" title="删除审批通过" value="通过" onClick="uptTaxrel('<%=retList[i][1]%>','3')"/>
			<input class="butDel" type="button" title="删除审批打回" value="打回" onClick="uptTaxrel('<%=retList[i][1]%>','4')"/> --%>
		</td>
		<%} %>				
   </tr>
   <%
		
	}
   %>
</table>
</div>
	

	<%
	allPage = anum/ 10 + 1 ;	
	pre_page = (page_num>1)?(page_num-1):page_num;		
	next_page = ((page_num+1)<allPage)?(page_num+1):allPage;

	 %>	
	
	
	<div align="center">
				<table align="center">
					<tr>
						<td align="center">
						总记录数：<font name="totalPertain" id="totalPertain"><%=retList[0][0]%></font>&nbsp;&nbsp;
						总页数：<font name="totalPage" id="totalPage"><%=allPage%></font>&nbsp;&nbsp;
						每页行数：10
						<a href="javascript:doQueryApproveList('1');">[第一页]</a>&nbsp;&nbsp;
						<a href="javascript:doQueryApproveList('<%=pre_page+""%>');">[上一页]</a>&nbsp;&nbsp;
						<a href="javascript:doQueryApproveList('<%=next_page+""%>');">[下一页]</a>&nbsp;&nbsp;
						<a href="javascript:doQueryApproveList('<%=allPage%>');">[最后一页]</a>&nbsp;&nbsp;
						<span class="pages">转到第 
			<input type="text" class="W_30px" name="jump" value="" onkeyup="if(event.keyCode===13){doQueryApproveList(this.value,'<%=allPage+""%>');}" /> 页</span>
			<span class="pages">第<%=page_num+""%>/<%=allPage+""%>页</span>
			
						</td>
					</tr>
				</table>
				</div>
				<input type="hidden" id="nowPage" />
  				<input type="hidden" id="allPage" value="<%= allPage %>" />
	
	
<%	}}else{

		return;
	}
	%>
	<input type="hidden" name="retCode" id="retCode" value="<%=retCode%>" />
	<input type="hidden" name="retMsg" id="retMsg" value="<%=retMsg%>" />
	
