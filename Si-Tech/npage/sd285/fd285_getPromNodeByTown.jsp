 <%
   /*
   * 功能: 提醒短信增加-查询区县代码
　 * 版本: v3.0
　 * 日期: 2011-3-28
　 * 作者: ningtn
　 * 版权: sitech
   * 修改历史
   * 修改日期      修改人      修改目的
 　*/
%>
		<%@ page contentType="text/html;charset=Gb2312"%>
		<%@ include file="/npage/include/public_title_name.jsp" %>
<%
 		String opCode = "d285";
 		String opName = "提醒短信增加";
 		
		String regionCode = (String)session.getAttribute("regCode");
		String groupId = (String)session.getAttribute("groupId");
		
		String prom_group_id = WtcUtil.repNull(request.getParameter("prom_group_id"));
		String root_distance = WtcUtil.repNull(request.getParameter("root_distance_int"));
		int root_distance_int = Integer.parseInt(root_distance);	
		
		String getTownSql = "select group_id,group_name from dChnGroupMsg where group_id in (select group_id from dChnGroupInfo where parent_group_id = '"+prom_group_id+"' and denorm_level = 1) and class_code = '6'";
		if(root_distance_int==3)
		{
			getTownSql = "select group_id,group_name from dChnGroupMsg where group_id = '"+groupId+"'";
		}
		
		
		System.out.println("getTownSql="+getTownSql);
%>
		<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode1" retmsg="retMsg1" outnum="2">
		<wtc:sql><%=getTownSql%></wtc:sql>
		</wtc:pubselect>
		<wtc:array id="sVerifyTypeArr" scope="end" />
<%		
		int totalNum = sVerifyTypeArr.length;
%>

<html>
	<head>
	<title><%=opName%></title>
	<meta content=no-cache http-equiv=Pragma>
	<meta content=no-cache http-equiv=Cache-Control>
	<script language="javascript">
		<!--		
			/**复选框全部选中**/
			function doSelectAllNodes(){
				var regionChecks = document.getElementsByName("regionCheck");
				for(var i=0;i<regionChecks.length;i++){
					regionChecks[i].checked=true;
				}
				doChange();	
			}
			
			/**取消复选框全部选中**/
			function doCancelChooseAll(){
				var regionChecks = document.getElementsByName("regionCheck");
				for(var i=0;i<regionChecks.length;i++){
					regionChecks[i].checked=false;
				}
				doChange();				
			}
			
			/**复选框选中或者取消的主要事件**/
			function doChange(){
				var regionChecks = document.getElementsByName("regionCheck");	
				var impCodeStr = "";
				var impNameStr = "";
				var regionLength = 0;
				for(var i=0;i<regionChecks.length;i++){
					if(regionChecks[i].checked){
						var impValue = regionChecks[i].value;
						var impArr = impValue.split("|");
						if(regionLength==0){
							impCodeStr = impArr[0];
							impNameStr = impArr[0]+" "+impArr[1];
						}else{
							impCodeStr += (","+impArr[0]);
							impNameStr += (","+impArr[0]+" "+impArr[1]);	
						}
						regionLength++;
					}
				}
				
				impNameStr += (" -->"+"一共选择"+regionLength+"个区域");
						
				parent.document.all.sGroupInfo.value = impNameStr;
				parent.document.all.sGroupId.value = impCodeStr;
			}
		//-->
	</script>
</head>
<body>
	<div id="Operation_Table">
     <table cellspacing="0">
			<tr align="center">
				<th width="15%" nowrap>选择</td>
				<th nowrap>区县编号</td>
				<th nowrap>区县名称</td> 
			</tr> 
	<%
			if(totalNum==0){
				out.println("<tr height='25' align='center'><td colspan='3'>");
				out.println("没有任何记录！");
				out.println("</td></tr>");
			}else if(totalNum>0){
				String tbclass = "";
				for(int i=0;i<totalNum;i++){
					tbclass = (i%2==0)?"Grey":"";
	%>
						<tr align="center">
							<td class="<%=tbclass%>">
								<input type="checkbox" name="regionCheck" value="<%=sVerifyTypeArr[i][0]%>|<%=sVerifyTypeArr[i][1]%>" onclick="doChange()">	
							</td>
							<td class="<%=tbclass%>"><%=sVerifyTypeArr[i][0]%>&nbsp;</td>
							<td class="<%=tbclass%>"><%=sVerifyTypeArr[i][1]%>&nbsp;</td>
						</tr>
	<%				
				}
			}
	%>
  </table>
	<table cellspacing="0">
	  <tr> 
	    <td id="footer"> 
	       <input type="button" name="allchoose"  class="b_text" value="全部选择" style="cursor:hand;" onclick="doSelectAllNodes()" >&nbsp;
	       <input type="button" name="cancelAll" class="b_text" value="取消全选" style="cursor:hand;" onClick="doCancelChooseAll()" >&nbsp;
	    </td>
	  </tr>
 </table>  
</div>
</body>
</html>    

