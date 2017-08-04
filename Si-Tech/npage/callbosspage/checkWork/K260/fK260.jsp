<%
/*zhengjiang 20090930去掉顶端引入规范*/
%>
<%
  /*
   * 功能: 放弃原因定义
   * 版本: 1.0
   * 日期: 2008/11/05
   * 作者: kouwb
   * 版权: si-tech
  */
%>
<%@ page contentType="text/html;charset=gb2312"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
	String opCode = "K260";
	String opName = "放弃原因定义";
  request.setCharacterEncoding("gb2312");
  String org_code = (String)session.getAttribute("orgCode");
  String regionCode=org_code.substring(0,2);
  String workNo = (String)session.getAttribute("workNo");
  String sql = "";
%>
<wtc:service name="sK260Qry"  routerKey="region"  routerValue="<%=regionCode%>"  outnum="5">
</wtc:service>
<wtc:array id="result" scope="end"/>

<html>
	<head>
		<title>放弃原因定义</title> 
		
		<script type="text/javascript" src="<%=request.getContextPath()%>/njs/csp/checkWork_dialog.js"></script>
		
		<script language="javascript">
			var prevclick = "";
			var parentnode = "";
			function tdop(){
				event.srcElement.style.color='red';
				if(prevclick != "" && prevclick != event.srcElement.id)
					document.all[""+prevclick].style.color = "#003399";
				prevclick = event.srcElement.id;	
				parentnode = trim(event.srcElement.nextSibling.nextSibling.innerHTML);			
			}
			
			function add_data(){
				if(parentnode == ""){
					similarMSNPop("请先选择父节点！");
					return;
				}
				var etime=new Date();
        var h=390;
        var w=500;
        var t=screen.availHeight/2-h/2;
        var l=screen.availWidth/2-w/2;
        var cssv = "dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:yes;location:no;status:yes;help:no";
        var retValue = "";
        retValue = window.showModalDialog("fK260_update.jsp?op=add&parentnod=" + parentnode + "&etime=" + etime,"",cssv);
				if(typeof(retValue) != "undefined"){
					retValue = trim(retValue);
					if(retValue != ""){
						var arr = retValue.split("~");
						if(arr[0] == "000000"){
							var tr = document.all.ErrTable.insertRow();
							var td = tr.insertCell();
							var td1 = tr.insertCell();
							var td2 = tr.insertCell();
							var td3 = tr.insertCell();
							var td4 = tr.insertCell();
							td.innerText = arr[2];
							td1.innerText = arr[3]==""?"  ":arr[3];
							td2.innerText = arr[4];
							td3.innerText = arr[5];
							td4.innerText = arr[6];
							td.id = "tdata" + trim(arr[4]);
							td.className = "blue";
							td1.className = "blue";
							td2.className = "blue";
							td3.className = "blue";
							td4.className = "blue";
							td.style.cursor = "hand";
							td.onclick = function(){
								tdop(this);
							}
							td.onmouseover = function(){
								this.style.backgroundColor="#ececec";
							}
							td.onmouseout = function(){
								this.style.backgroundColor="#F7F7F7";
							}
							
							document.form1.data_rows.value = parseInt(document.form1.data_rows.value) + 1;
							try{window.parent.frames.leftFrame.window.location.reload(true);}catch(e){alert(e.message)}
						}
					}
				}        			
			}
			
			function mod_data(){
				if(prevclick.indexOf("tdata")==-1){
					similarMSNPop("请选择修改放弃原因！！");
				}else{
					var etime=new Date();
					var reason_name = trim(document.all[""+prevclick].innerText);
					var note = trim(document.all[""+prevclick].nextSibling.innerText);
					var reason_id = trim(document.all[""+prevclick].nextSibling.nextSibling.innerText);
					var parent_reason_id = trim(document.all[""+prevclick].nextSibling.nextSibling.nextSibling.innerText);
					var valid_flag = trim(document.all[""+prevclick].nextSibling.nextSibling.nextSibling.nextSibling.innerText);
					var param = "&reason_name=" + reason_name +
											"&note=" + note +
											"&reason_id=" + reason_id +
											"&parent_reason_id=" + parent_reason_id +
											"&valid_flag=" + valid_flag;
	        var h=390;
	        var w=500;
	        var t=screen.availHeight/2-h/2;
	        var l=screen.availWidth/2-w/2;
	        var cssv = "dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:yes;location:no;status:yes;help:no";
	        var retValue = "";
	        retValue = window.showModalDialog("fK260_update.jsp?op=mod" + param + "&etime=" + etime,"",cssv);
					if(typeof(retValue) != "undefined"){
						retValue = trim(retValue);
						if(retValue != ""){
							var arr = retValue.split("~");
							if(arr[0] == "000000"){
								document.all[""+prevclick].innerText = arr[2];
								document.all[""+prevclick].nextSibling.innerText = arr[3]==""?"  ":arr[3];
								document.all[""+prevclick].nextSibling.nextSibling.innerText = arr[4];
								document.all[""+prevclick].nextSibling.nextSibling.nextSibling.innerText = arr[5];
								document.all[""+prevclick].nextSibling.nextSibling.nextSibling.nextSibling.innerText = arr[6];
								/*
								if("N"==arr[6].trim()){
									for(var k=0;k<document.all["ErrTable"].firstChild.childNodes.length;k++){
										if(document.all["ErrTable"].firstChild.childNodes[k].firstChild.id == prevclick){
											document.all["ErrTable"].deleteRow(k);
										}
									}
									prevclick = "";
								}
								*/
								try{window.parent.frames.leftFrame.window.location.reload(true);}catch(e){alert(e.message)}
							}
						}
					}  
				} 				
			}
			
			function del_data(){
				if(prevclick.indexOf("tdata")==-1){
						similarMSNPop("请选择要删除的放弃原因！");
				}else{
					//zengzq 20091019 增加判断，根节点不允许删除
					var tmpId = trim(document.all[""+prevclick].nextSibling.nextSibling.innerText);
					if("0" == tmpId){
							similarMSNPop("根节点不允许删除！");
							return false;
					}
					
					if(rdShowConfirmDialog("确认删除当前选中的放弃原因么？") == 1){
						var myPacket = new AJAXPacket("fK260I_AddMod.jsp","正在提交，请稍候......");
						myPacket.data.add("retType","del");
						myPacket.data.add("login_no","<%=workNo%>");
						myPacket.data.add("reason_id",tmpId);
						core.ajax.sendPacket(myPacket,doProcess,true);
						myPacket=null;
					}
				}			
		}
			
			
			function doProcess(packet)
			{
				var retType = packet.data.findValueByName("retType");		
				var retCode = packet.data.findValueByName("retCode");
				var retMsg = packet.data.findValueByName("retMsg");		
				
				if(retCode=='000000')
				{
					similarMSNPop(retMsg + "[" + retCode + "]");
					for(var k=0;k<document.all["ErrTable"].firstChild.childNodes.length;k++){
						if(document.all["ErrTable"].firstChild.childNodes[k].firstChild.id == prevclick){
							document.all["ErrTable"].deleteRow(k);
						}
					}
					prevclick = "";
					parentnode = "";
					try{window.parent.frames.leftFrame.window.location.reload(true);}catch(e){alert(e.message)}
				}
				else
				{
					similarMSNPop(retMsg + "[" + retCode + "]");
				}
			}				
			
			function ltrim(s){
			 return s.replace( /^\s*/, ""); 
			} 
			function rtrim(s){
			 return s.replace( /\s*$/, ""); 
			} 
			function trim(s){
			 return rtrim(ltrim(s)); 
			}						
		</script>
	</head>
	<body>
		<form name="form1" method="POST">
			<!--
			<%@ include file="/npage/include/header.jsp" %>	
			-->
			<div id="Operation_Table" style="width: 100%;"><!--zhengjiang20090930-->
				<div class="title"><div id="title_zi"><div style="float:left">放弃原因定义</div>
					<div style="float:right">
						<input type="button" name="add" class="b_foot" value="新增" onclick="add_data()"/>
						<input type="button" name="mod" class="b_foot" value="修改" onclick="mod_data()"/>
						<input type="button" name="del" class="b_foot" value="删除" onclick="del_data()"/>
					</div>
					</div>
				</div>
				<table id="ErrTable" cellspacing="0">
					<tr>
						<th align="left" class="blue" width="5%" ><nobr> 名称 </th>
						<th align="left" class="blue" width="5%" > 描述 </th>
						<th align="left" class="blue" width="5%" ><nobr> 编号 </th>
						<th align="left" class="blue" width="5%" ><nobr> 上层节点 </th>
						<th align="left" class="blue" width="5%" ><nobr> 是否可用 </th>
					</tr>
<%
	int i = 0;
	for(i=0;i<result.length;i++){	
%>
					<tr>
						<td id="tdata<%=result[i][2]%>" class="blue" style="cursor:hand" onclick="tdop(this)" onmouseover="javascript:this.style.backgroundColor='#ececec';" onmouseout="javascript:this.style.backgroundColor='#F7F7F7'">
							<%=result[i][0]%>
						</td>
						<td class="blue">
							<%=(result[i][1]==null||result[i][1].equals(""))?"&nbsp;&nbsp;":result[i][1]%>
						</td>
						<td class="blue">
							<%=result[i][2]%>
						</td>
						<td class="blue">
							<%=result[i][3]%>
						</td>
						<td class="blue">
							<%=result[i][4]%>
						</td>
					</tr>
<%
	}
%>
				</table>
				<input type="hidden" name="data_rows" value="<%=i%>"/>
			<!--	
			<%@ include file="/npage/include/footer.jsp" %>
			-->
			</div>
		</form>
	</body>
</html>
