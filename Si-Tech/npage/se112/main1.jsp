<%@ page contentType="text/html;charset=GB2312"%>
<%@ include file="/npage/se112/public_title_name.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.sitech.crmpd.core.bean.MapBean" %>
<%
	String brandId = "";//品牌
	String chanType = "0";//渠道类型
	String distictCode = "";//市县编码,黑龙江不用；
	String idNo = "";
	String custId = "";
	String innetMons = "";//客户入网月数
	String custLevel = "";//客户星级
	
	String accountType =(String)session.getAttribute("accountType");//工号类型
	if( "2".equals(accountType) ){//类型为为2的是客服工号
		chanType ="16";
	}

	String phoneNo = (String)request.getParameter("activePhone");//手机号
	String loginNo   = (String)session.getAttribute("workNo");//登录工号
	String password   = (String)session.getAttribute("password");//登录密码
	String reginCode = (String) session.getAttribute("regCode");//区域
	String groupId = (String) session.getAttribute("groupId");//营业节点编码
	/*gaopeng 2014/07/07 17:09:39 v_smCode 关于佳木斯分公司申请开通宽带零元初装费的请示 获取参数 v_smCode*/
	String v_smCode = (String)request.getParameter("v_smCode");//smcode
	//groupId="10039";
	String routerKey = request.getParameter("routerKey") == null ? "userno" : request.getParameter("routerKey");//服务的路由规则
	String routerValue = request.getParameter("routerValue") == null ? idNo : request.getParameter("routerValue");

	String orderArrayId = (String)request.getParameter("orderArrayId") == null ? "" : request.getParameter("orderArrayId");
	String custOrderId = (String)request.getParameter("custOrderId") == null ? "" : request.getParameter("custOrderId");
	String custOrderNo = (String)request.getParameter("custOrderNo") == null ? "" : request.getParameter("custOrderNo");
	String servBusiId = (String)request.getParameter("servBusiId");//手机号
	String prtFlag = (String)request.getParameter("prtFlag");//手机号
	String gCustId = (String)request.getParameter("gCustId");
	String op_Code = (String)request.getParameter("opCode"); 
	String opName = (String)request.getParameter("opName"); 
	String netCode = (String)request.getParameter("cfm_login");
	String actClass = (String)request.getParameter("ACT_CLASS");
	System.out.println("++++++++==================================================+++++++++++-actClass :"+actClass +"------------------------");
	System.out.println("+++++++++++++++++++-accountType:"+accountType+"------------------------");
	System.out.println("+++++++++++++++++++-chanType:"+chanType+"------------------------");
	System.out.println("+++++++++++++++++++-phoneNo:"+phoneNo+"------------------------");
	System.out.println("+++++++++++++++++++-loginNo:"+loginNo+"------------------------");
	System.out.println("+++++++++++++++++++-password:"+password+"------------------------");
	System.out.println("+++++++++++++++++++-reginCode:"+reginCode+"------------------------");
	System.out.println("+++++++++++++++++++-groupId:"+groupId+"------------------------");
	
	System.out.println("+++++++++++++++++++-orderArrayId:"+orderArrayId+"------------------------");
	System.out.println("+++++++++++++++++++-custOrderId:"+custOrderId+"------------------------");
	System.out.println("+++++++++++++++++++-custOrderNo:"+custOrderNo+"------------------------");
	System.out.println("+++++++++++++++++++-servBusiId:"+servBusiId+"------------------------");
	System.out.println("+++++++++++++++++++-prtFlag:"+prtFlag+"------------------------");
	System.out.println("+++++++++++++++++++-gCustId:"+gCustId+"------------------------");

	System.out.println("+++++++++++++++++++-opCode:"+op_Code+"------------------------");
	System.out.println("+++++++++++++++++++-opName:"+opName+"------------------------");
	
	
	System.out.println("+++++++++++++++++++++nectCode : +++++++++++++++++++++++++++++++"+netCode);
%>

<s:service name="sUserInfoQryWS_XML" >
		<s:param name="ROOT">
				<s:param name="iLoginAccept" type="string" value="0" />
				<s:param name="iChnSource" type="string" value="01" />
				<s:param name="iOpCode" type="string" value="" />
				<s:param name="iLoginNo" type="string" value="<%=loginNo %>" />
				<s:param name="iLoginPwd" type="string" value="<%=password %>" />
				<s:param name="iPhoneNo" type="string" value="<%=phoneNo %>" />
				<s:param name="iUserPwd" type="string" value="" />
		</s:param>
</s:service>
<%
 	if (result != null) {
		idNo = (String)result.getString("RESPONSE_INFO.ID_NO");	
		custId = (String)result.getString("RESPONSE_INFO.CUST_ID");	
		brandId =(String)result.getString("RESPONSE_INFO.BRAND_ID");
		innetMons =(String)result.getString("RESPONSE_INFO.INNET_MONS");
		custLevel = (String)result.getString("RESPONSE_INFO.CUST_LEVEL");
	}
	System.out.println("+++++++++++++++++++-idNo:"+idNo+"------------------------");
	System.out.println("+++++++++++++++++++-custId:"+custId+"------------------------");
	System.out.println("+++++++++++++++++++-brandId:"+brandId+"------------------------");
	System.out.println("+++++++++++++++++++-innetMons:"+innetMons+"------------------------");
	System.out.println("+++++++++++++++++++-custLevel:"+custLevel+"------------------------");
%>

<s:service name="sMKTPowerQryWS" >
		<s:param name="ROOT">
				<s:param name="LOGIN_NO" type="string" value="<%=loginNo %>" />
		</s:param>
</s:service>
<%
		StringBuffer sb = new StringBuffer();
		String opcodeStr = "";
		Map hm = new HashMap();
		List data = result.getList("OUT_DATA.BUSI_INFO");
		for(int i=0;i<data.size();i++){
			hm = MapBean.isMap(data.get(i));
			if(hm==null) continue;
			String opCode = (String) hm.get("OP_CODE"); 
			sb.append("'" + opCode + "'" + ",");
		}
		opcodeStr = sb.toString();
		if(opcodeStr.endsWith(",")){
			opcodeStr = opcodeStr.substring(0, opcodeStr.length()-1);
		}
		opcodeStr = "g794";
		System.out.println("+++++++++++++++++++-opcodeStr:"+opcodeStr+"------------------------");
%>

<html>
	<body>
		<form name="frm" action="" method="post">
			<div id="operation">
				<div id="operation_table">
				<%if(phoneNo != null && !"".equals(phoneNo) && result != null&&opcodeStr!=null&& !"".equals(opcodeStr)) { %>
					<s:service name="WsGetCanSaleAction" >
						<s:param name="ROOT">
							<s:param name="REQUEST_INFO">
								<s:param name="PHONE_NO" type="string" value="<%=phoneNo %>" />
								<s:param name="CHN_TYPE" type="string" value="<%=chanType %>" />
								<s:param name="GROUP_ID" type="string" value="<%=groupId %>" />
								<s:param name="LOGIN_NO" type="string" value="<%=loginNo %>" />
								<s:param name="OP_CODE" type="string" value="<%=opcodeStr %>" />
								<s:param name="ACT_CLASS" type="string" value="<%=actClass %>" />
							</s:param>
						</s:param>
					</s:service>	
				<%	if ("0".equals(retCode)) {
						List preActionList = result.getList("OUT_DATA.PRE_ACTIONS.ACTION");
						if(!"N/A".equals(preActionList.get(0))){
				%>
					<div class="title"><div class="text">客户预约办理活动列表</div></div>
					<div class="list">
						<table>
							<tr><th>活动名称</th><th>活动订购</th></tr>
							<%
								for(int i=0; i<preActionList.size(); i++){
									Map preActionInfo = MapBean.isMap(preActionList.get(i));
									String actId = preActionInfo.get("ACT_ID").toString();
									String actName = preActionInfo.get("ACT_NAME").toString();
									String custGroupId = preActionInfo.get("CUST_GROUP_ID").toString();
									String meansId = preActionInfo.get("MEANS_ID").toString();
									String orderId = preActionInfo.get("ORDER_ID").toString();
									String actionClass = preActionInfo.get("ACT_CLASS").toString();
									String score = preActionInfo.get("SCORE").toString();
									String validMode = preActionInfo.get("VALIDMODE").toString();
							%>
							<tr>
								<td><%=actName %></td>
								<td><input type="button" class="b_text" name="actBtn" value="活动订购"
										onclick="queryRule4Sale('<%=phoneNo%>','<%=custGroupId%>','<%=idNo%>','<%=actId%>', '<%=meansId %>','<%=orderId %>','N', '3', '<%=actionClass %>','<%=score %>','<%=validMode %>')" /></td>
							</tr>
							<%
								}
							%>
						</table>
					</div>
				<%													
					}						
				%>
						<div class="title">
							<div class="text">
							客户可以参加的活动列表
							</div>
						</div>
						<div class="list">
							<table>
								<tr>
									<th>
										活动类别
									</th>
									<th>
										活动名称
									</th>
									<th>
										营销用语
									</th>
									<th>
										活动订购
									</th>
								</tr>
								<%
										Map hmap = new HashMap();
										List datainfo = result.getList("OUT_DATA.ACTIONS.ACTION");
										for(int i=0;i<datainfo.size();i++){
											hmap = MapBean.isMap(datainfo.get(i));
											if(hmap==null) continue;
											String actName = (String) hmap.get("ACT_NAME") == null ? "" : (String) hmap.get("ACT_NAME");
											String actId = (String) hmap.get("ACT_ID") == null ? "" : (String) hmap.get("ACT_ID");
											String saleLang = (String) hmap.get("SALELANG") == null ? "" : (String) hmap.get("SALELANG");
											String custGroupId = (String) hmap.get("CUST_GROUP_ID") == null ? "" : (String) hmap.get("CUST_GROUP_ID");
											String actionClass = (String) hmap.get("ACT_CLASS") == null ? "" : (String) hmap.get("ACT_CLASS"); 
											String isLevel = (String) hmap.get("ISLEVEL") == null ? "" : (String) hmap.get("ISLEVEL");
											String busiType = (String) hmap.get("BUSI_TYPE") == null ? "" : (String) hmap.get("BUSI_TYPE");	
											String score = "";;	
								%>
								<tr>
									<td>
										<%=busiType%>
									</td>
									<td>
										<%=actName%>
									</td>
									<td>
										<%=saleLang%>
									</td>
									<td>
										<%
											if("Y".equals(isLevel)){
										%>
											<input type="button" class="b_text" name="actBtn" value="活动订购"
											onclick="queryRule4Sale('<%=phoneNo%>','<%=custGroupId%>','<%=idNo%>','<%=actId%>', '','','Y','0', '<%=actionClass %>','<%=score %>','')" />
											<input type="button" class="b_text" name="actBtn" value="换挡订购"
											onclick="queryRule4Sale('<%=phoneNo%>','<%=custGroupId%>','<%=idNo%>','<%=actId%>', '','','Y','1', '<%=actionClass %>','<%=score %>','')" />
										<%
											}else{
										%>
											<input type="button" class="b_text" name="actBtn" value="活动订购"
											onclick="queryRule4Sale('<%=phoneNo%>','<%=custGroupId%>','<%=idNo%>','<%=actId%>', '','','N','2', '<%=actionClass %>','<%=score %>','')" />
										<%	
											}
										%>
										
									</td>														
								</tr>							
								<%
									    }
									 }else{
								%>	 
									<script type="text/javascript">
										$(document).ready(function(){
												showDialog("查询可办活动列表接口正忙，请稍候再试！！",0);
										});
									</script>
								<%	 
									 }
								 }else {
								%>
								    <script type="text/javascript">
										$(document).ready(function(){
												showDialog("该工号没有操作g794营销执行权限，请联系管理员！！",0);
										});
									</script>
								<%
									return;
								}					
								%>
							</table>
						</div>	
					</div>
			</div>
		</form>
		
	</body>
</html>
<script language="JavaScript">
	//全局变量组
	var svcNum;
	var custGrpId;
	var idNo;
	var actId;
	var roleType="ZK";
	var selectMeansId = '';
	var selectvalidMode = "";
	var orderID = '';
	var checkNo = '';	
	var gActClass = '';
	var gScore = '';
	var oTrueCode = '';
	
	function queryRule4Sale(svcNum1,custGrpId1,idNo1,actId1, meansId,orderId,checkUp,checkno, actClass,sCore,validMode){
		//服务号码，目标客房群编号，目标客房群类型，id_no,活动编号，任务编号，是否需要身份验证（黑龙江不用）
		svcNum=svcNum1;
		custGrpId=custGrpId1;
		idNo=idNo1;
		actId=actId1;
		selectMeansId = meansId;
		selectvalidMode = validMode;
		orderID = orderId;
		checkNo = checkno;
		gActClass = actClass;
		gScore = sCore;
		oTrueCode = '';//将实名制的地市开通置为空
		if(""=="<%=orderArrayId%>" || ""=="<%=orderArrayId%>" || ""=="<%=orderArrayId%>"){
			showDialog("从crm得到参数数据为空，请联系管理员！！",0);
			return false;
		}
		if("<%=netCode%>" == null || "<%=netCode%>" == "null"){
			
		}else{
			if(gActClass !="16"){
				showDialog("必须是16小类才能与宽带开户一起放到购物车办理！！",0);
				return false;
			}
		}
		if(checkno==3){
			doMarketLimit();
		}else{
			if(checkUp=='Y'){
				var sPacket = null;
				sPacket = new AJAXPacket("gAssiFeeCheckFee.jsp","请稍候......");
				
				sPacket.data.add("loginNo","<%=loginNo%>");
				sPacket.data.add("iPhoneNo","<%=phoneNo%>");
				sPacket.data.add("fee_code","");
				sPacket.data.add("fee_name","");
				sPacket.data.add("meansId","");
				sPacket.data.add("act_id",actId);
				//==================================================
				core.ajax.sendPacketHtml(sPacket,doResCat,true);
				sPacket = null;
			}else{
				var sPacket = null;
				sPacket = new AJAXPacket("gAssiFeeCheckFee.jsp","请稍候......");
				
				sPacket.data.add("loginNo","<%=loginNo%>");
				sPacket.data.add("iPhoneNo","<%=phoneNo%>");
				sPacket.data.add("fee_code","");
				sPacket.data.add("fee_name","");
				sPacket.data.add("meansId","");
				sPacket.data.add("act_id","");
				//==================================================
				core.ajax.sendPacketHtml(sPacket,doResCat,true);
				sPacket = null;
			}
		}
	}

	function doResCat(data){
		var sdata = data.split("~");
		var retCode = sdata[0];
		var retMsg = sdata[1];
		var actID = sdata[2];
		if(retCode != 0){
			showDialog('升降档活动校验失败，请联系管理员',0);
			return false;
		}else if(retCode == 0&&checkNo==retMsg&&actId == actID){
			doMarketLimit();
		}else if(retCode == 0&&checkNo==2&&retMsg==0){
			doMarketLimit();
		}else if(retCode == 0&&checkNo==0&&retMsg==0){
			doMarketLimit();
		}else{
			if(checkNo == 2){
				showDialog('您已办理换挡取消业务，不允许办理非换挡活动订购！',0);
				return false;
			}
			if(retMsg==0){
				showDialog('您未办理过换挡取消业务，不允许办理换挡订购！',0);
				return false;		
			}
			 if(retMsg==1){
				if(actId == actID){
					showDialog('您已办理换挡取消业务，请选择换挡订购！',0);
					return false;
				}else{
					showDialog('您本次订购的活动与换挡的活动非同一活动，不允许办理！',0);
					return false;
				}
			}
		}
	}
	
	//营销侧业务限制
	function doMarketLimit(){
		var packet = null;
		$("#actBtn").attr("disabled","disabled");
		packet = new AJAXPacket("<%=request.getContextPath()%>/npage/se112/marketLimit.jsp","请稍后...");
		packet.data.add("actId",actId);
		packet.data.add("svcNum","<%=idNo%>");
		packet.data.add("phoneNo","<%=phoneNo%>");
		packet.data.add("opCode","g794");
		packet.data.add("actClass",gActClass);
		core.ajax.sendPacketHtml(packet,doFunction,true);
		packet =null;
	}
	function doFunction(data){
		var sdata = data.split("~");
		var retCode1 = sdata[0];
		var retMsg1 = sdata[1];
		var retCode2 = sdata[2];
		var retMsg2 = sdata[3];
		var retCode3 = sdata[4];
		var retMsg3 = sdata[5];
		oTrueCode = sdata[6];
		if(retCode1 ==000000 && retCode2 ==0 && retCode3 ==000000){
			checkAct();
		}else if(retCode1 !=000000){
			showDialog(retMsg1,1);
			return false;
		}else if (retCode2 != 0){
			showDialog(retMsg2,1);
			return false;
		}else if (retCode3 != 000000){
			showDialog(retMsg3,1);
			return false;
		}
	}
	
	//活动级业务限制
	function checkAct(){
		var myPacket = null;
		$("#actBtn").attr("disabled","disabled");
		myPacket = new AJAXPacket("<%=request.getContextPath()%>/npage/se112/checkAct.jsp","请稍后...");
		myPacket.data.add("actId",actId);
		myPacket.data.add("svcNum",svcNum);
		core.ajax.sendPacket(myPacket,toOrderAct);
		myPacket =null;
	}
	
	function toOrderAct(packet){
		var RETURN_CODE = packet.data.findValueByName("RETURN_CODE");
		var RETURN_MSG = packet.data.findValueByName("RETURN_MSG");
		
		if(RETURN_CODE == '000000'){
			$("#actBtn"+actId).attr("disabled","disabled");
			var param = "svcNum="+svcNum+"&custGrpId="+custGrpId+"&idNo="+idNo+"&actId="+actId+"&brandId=<%=brandId%>&custId=<%=custId%>&innetMons=<%=innetMons%>&chanType=<%=chanType%>&routerKey=<%=routerKey%>&routerValue=<%=routerValue%>&orderArrayId=<%=orderArrayId%>&custOrderId=<%=custOrderId%>&servBusiId=<%=servBusiId%>&opCode=<%=op_Code%>&opName=<%=opName%>&custOrderNo=<%=custOrderNo%>&prtFlag=<%=prtFlag%>&gCustId=<%=gCustId%>&netCode=<%=netCode%>&isPreengage=N&custLevel=<%=custLevel%>&selectMeansId="+selectMeansId+"&gScore="+gScore+"&orderID="+orderID+"&v_smCode=<%=v_smCode%>&oTrueCode="+oTrueCode+"&selectvalidMode="+selectvalidMode;
			url="main2.jsp?"+param;
			location = url;
		}else{
			showDialog(RETURN_MSG,1);
		}
	}
</script>
