
<%
/********************
 version v2.0
开发商: si-tech
ningtn 2012-3-13 16:01:25 新版改造
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<%@ page contentType="text/html; charset=GBK"%>
	<%@ include file="/npage/include/public_title_name.jsp"%>
	<%@ include file="/npage/client4A/connect4A.jsp" %>
<%@ include file="/npage/client4A/XMLHelper.jsp" %>
<%@ include file="/npage/client4A/BASE64Crypt.jsp" %>
<%@ include file="/npage/properties/getRDMessage.jsp" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.sitech.boss.pub.util.*" %>
	<%@ page import="com.sitech.common.*" %>
	<HEAD>
		<TITLE>安保部普通详单查询</TITLE>

<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0);
	String opCode = request.getParameter("opCode");
	String opName = request.getParameter("opName");
	String loginNo = (String)session.getAttribute("workNo");
	String flag4A = (String)session.getAttribute("flag4A");
	String appSessionId = (String)session.getAttribute("appSessionId");
	if(flag4A == null){
		flag4A = "0";
	}
	if(appSessionId == null){
		appSessionId = "0";
	}

	/* 操作时间 requestTime节点 */
	String currTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new Date());
	/* 获取敏感数据和敏感操作 */
	String readPath = request.getRealPath("npage/properties")+"/treasury.properties";
	/* 资源ID */
	String appId = readValue("treasury",opCode,"appId",readPath);
	/* 资源名称 */
	String appName = readValue("treasury",opCode,"appName",readPath);
	/* 场景ID sceneId */
	String sceneId = readValue("treasury",opCode,"sceneId",readPath);
	/* 测试用场景ID，上线删掉 by zhangyta at 20120824*/
	/*sceneId = "ff808081395641c901395641c9220000";*/
	/* 场景名称 sceneName */
	String sceneName = readValue("treasury",opCode,"sceneName",readPath);
	String ipAddr = (String)session.getAttribute("ipAddr");
%>

<%
	ArrayList retArray = new ArrayList();
	String[][] result = new String[][]{};
%>
<%
	ArrayList arr = (ArrayList)session.getAttribute("allArr");
	String[][] baseInfo = (String[][])arr.get(0);
	String workNo = baseInfo[0][2];
	String workName = baseInfo[0][3];
	String nopass = (String)session.getAttribute("password");	
	String Role = baseInfo[0][5];
	String orgCode = baseInfo[0][16];
	
	String[][] temfavStr=(String[][])arr.get(3);
	String[] favStr = new String[temfavStr.length];
	for(int i=0;i<favStr.length;i++) {
		favStr[i]=temfavStr[i][0].trim();
	}
	/* 使用新的方式校验是否有免密权限 */
	boolean pwrf = false;
	String pubOpCode = opCode;
	String pubWorkNo = loginNo;	
	%>
  	<%@ include file="/npage/public/pubCheckPwdPower.jsp" %>
  <%
	
	String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
	String[] mon = new String[]{"","","","","",""};

	Calendar cal = Calendar.getInstance(Locale.getDefault());
	cal.set(Integer.parseInt(dateStr.substring(0,4)),
					(Integer.parseInt(dateStr.substring(4,6)) - 1),
					Integer.parseInt(dateStr.substring(6,8)));
	for(int i=0;i<=5;i++){
		if(i!=5){
			mon[i] = new java.text.SimpleDateFormat("yyyyMM", Locale.getDefault()).format(cal.getTime());
			cal.add(Calendar.MONTH,-2);
		}
		else
			mon[i] = new java.text.SimpleDateFormat("yyyyMM", Locale.getDefault()).format(cal.getTime());
	}                                       
%>
</HEAD>

<body>
<jsp:include page="/npage/client4A/treasuryStatus.jsp">
	<jsp:param name="opCode" value="<%=opCode%>"  />
	<jsp:param name="opName" value="<%=opName%>"  />
</jsp:include>
<SCRIPT language="JavaScript">
	function isNumberString (InString,RefString){
			if(InString.length==0) return (false);
			for (Count=0; Count < InString.length; Count++)  {
				TempChar= InString.substring (Count, Count+1);
				if (RefString.indexOf (TempChar, 0)==-1)  
				return (false);
			}
			return true;
	}
	
	function doCheck(){
		if(!forDate(document.frm1527.searchTime)){
		  rdShowMessageDialog("出帐年月输入格式不正确,请重新输入!");
		  return false;
		}

		if(!check(document.frm1527)){
			return false;
		}
		if( document.frm1527.phoneNo.value.length<11) {	
			rdShowMessageDialog("服务号码不能小于11位，请重新输入 !");
			document.frm1527.phoneNo.focus();
			return false;
		} else if (!document.frm1527.passWord.disabled) {
			if (document.frm1527.passWord.value.length == 0) {
				rdShowMessageDialog("查询密码不能为空，请重新输入 !");
				document.frm1527.passWord.focus();
				return false;
			} else {
				document.frm1527.action="fDetQry1516.jsp?qryType="+document.frm1527.detType.value+"&qryName="
				+document.frm1527.detType.options[document.frm1527.detType.options.selectedIndex].text;
				
				frm1527.submit();
			}
		} else {
			document.frm1527.action="fDetQry1516.jsp?qryType="+document.frm1527.detType.value+"&qryName="
			+document.frm1527.detType.options[document.frm1527.detType.options.selectedIndex].text;
			var getdataPacket = new AJAXPacket("fAjax5085.jsp","正在获得数据，请稍候......");
				getdataPacket.data.add("loginNo","<%=loginNo%>");
				getdataPacket.data.add("sceneId","<%=sceneId%>");
				getdataPacket.data.add("sceneName","<%=sceneName%>");
				getdataPacket.data.add("phoneNo",document.frm1527.phoneNo.value);
				getdataPacket.data.add("currTime","<%=currTime%>");
				getdataPacket.data.add("appId","<%=appId%>");
				getdataPacket.data.add("appName","<%=appName%>");
				getdataPacket.data.add("flag4A","<%=flag4A%>");
				getdataPacket.data.add("appSessionId","<%=appSessionId%>");
				getdataPacket.data.add("ipAddr","<%=ipAddr%>");
				
				core.ajax.sendPacket(getdataPacket,doFileInput);
				getdataPacket = null;
		}
		return true;
	}
	function doFileInput(packet){
			var result = packet.data.findValueByName("result");
		   // alert("test result is "+result);
			var resultDesc = packet.data.findValueByName("resultDesc");
			if(result == "1"){
				/**调用成功 */
				frm1527.submit();
			}else{
				/**调用失败 */
				rdShowMessageDialog("执行失败，失败原因：" + resultDesc);
				return false;
			}
		}
	function seltimechange() {
		if (document.frm1527.searchType.selectedIndex == 0) {
		   IList1.style.display = "";
		   IList2.style.display = "none";
		} else {
		   IList1.style.display = "none";
		   IList2.style.display = "";
		}
	}
	function doReset(){
		$("#resetBtn").click();
		seltimechange();
	}
</SCRIPT>

		<FORM method=post name="frm1527">
			<input type="hidden" name="opCode" value="<%=opCode%>" />
			<input type="hidden" name="opName" value="<%=opName%>" />
			
			<input type="hidden" name="monNum" value="1" />
	    <%@ include file="/npage/include/header.jsp" %>
	    <div class="title">
	        <div id="title_zi">请选择查询类型</div>
	    </div>
						<TABLE cellSpacing="0">
							<TR>
								<TD width=16% class="blue">
									服务号码
								</TD>
								<TD width=34%>
									<input type="text" name="phoneNo" size="20" maxlength="11" v_type="mobphone" v_must="1" onblur = "checkElement(this)"  />
									<font class="orange">*</font>
								</TD>
								<TD class="blue">
									查询密码
								</TD>
								<%if(pwrf) {%>
								<TD width=34%>
									<input type="password" class="button" name="passWord"
										size="20" maxlength="8" disabled>
								</TD>
								<% } else { %>
								<TD width=34%>
									<jsp:include page="/page/common/pwd_1.jsp">
										<jsp:param name="width1" value="16%" />
										<jsp:param name="width2" value="34%" />
										<jsp:param name="pname" value="passWord" />
										<jsp:param name="pwd" value="12345" />
									</jsp:include>
								</TD>
								<%}%>
							</TR>

							<TR>
								<TD width=16% class="blue">
									查询类型
								</TD>
								<TD width=34%>
									<select name="searchType" onchange="seltimechange()">
										<option value="0" selected>
											时间范围
										</option>
										<option value="1">
											出帐年月
										</option>
									</select>
								</TD>
								<TD width=16%></TD>
								<TD width=34%></TD>
							</TR>

							<TR id="IList1">
								<TD width=16% class="blue">
									开始日期
								</TD>
								<TD width=34%>
									<input type="text" name="beginTime" size="20" maxlength="8"
										 value="<%=mon[1]+"01"%>" v_type="date" onblur="checkElement(this)" />
								</TD>
								<TD width=16% class="blue">
									结束日期
								</TD>
								<TD width=34%>
									<input type="text" name="endTime" size="20" maxlength="8"
										 value="<%=dateStr%>" v_type="date" onblur="checkElement(this)" />
								</TD>
							</TR>

							<TR style="display:none;" id="IList2">
								<TD width=16% class="blue">
									出帐年月
								</TD>
								<TD width=34%>
									<input type="text" class="button" name="searchTime" size="20"
										maxlength="6" value="<%=mon[1]%>" v_format="yyyyMM" onblur="checkElement(this)" />
								</TD>
								<TD width=16%></TD>
								<TD width=34%></TD>
							</TR>

							<TR>
								<TD class="blue">
									详单类型
								</TD>
								<TD>
									<select align="left" name="detType" width=50 index="4">
										<option class="button" value="0">
											全部
										</option>
										<option class="button" value="1">
											普通语音详单
										</option>
										<option class="button" value="2">
											神州行语音详单
										</option>
										<option class="button" value="3">
											短信
										</option>
										<option class="button" value="4">
											神州行互联短信
										</option>
										<option class="button" value="5">
											互联短信
										</option>
										<option class="button" value="6">
											神州行短信
										</option>
										<option class="button" value="7">
											呼转
										</option>
									</select>
								</TD>
								<TD width=16% class="blue">
									二次密码
								</TD>

								<%if(pwrf) {%>
								<TD width=34%>
									<input type="password" class="button" name="towPassWord"
										size="20" maxlength="8" disabled>
								</TD>
								<% } else { %>
								<TD width=34%>
									<jsp:include page="/page/common/pwd_1.jsp">
										<jsp:param name="width1" value="16%" />
										<jsp:param name="width2" value="34%" />
										<jsp:param name="pname" value="towPassWord" />
										<jsp:param name="pwd" value="12345" />
									</jsp:include>
								</TD>
								<%}%>
							</TR>
						</TABLE>

					<!------------------------>

					<table cellspacing="0">
						<tr>
							<td id="footer">
								&nbsp; <input class="b_foot" name=Button1 type="button"
									onClick="doCheck()" value=查询 />
								&nbsp; <input class="b_foot" name=reset type="button" onClick="doReset()"
									value=清除 />
									<input name="resetBtn" id="resetBtn" type="reset" style="display:none;" />
								&nbsp; <input class="b_foot" name=back
									onClick="removeCurrentTab();" type=button value=关闭 />
								&nbsp; 
							</td>
						</tr>
					</table>
					<%@ include file="/npage/include/footer.jsp" %>
					<jsp:include page="/page/common/pwd_comm.jsp" />
		</FORM>
	</BODY>
</HTML>
