<% /* * 功能: 查询一级菜单 * 版本: v1.0 * 日期: 2009-11-05 * 作者: hujie * 版权: sitech * 修改历史 * 修改日期:2010-04-27      	修改人:liubo      修改目的:部署黑龙江 */%><%@ page contentType="text/html;charset=GBK"%><%@ include file="/npage/include/public_title_ajax.jsp" %><%@ include file="/npage/login/dispatch.jsp" %><%! //以下方法为加密方法private String encrypt(String host){	if (host==null || "".equals(host)){		return ""; 	}	try{		Cipher encryptCipher = null;		/*密钥*/		String strDefaultKey = "dmcsadmin";		//Security.addProvider(new com.sun.crypto.provider.SunJCE());		Key key = getKey(strDefaultKey.getBytes());		encryptCipher = Cipher.getInstance("DES");		encryptCipher.init(Cipher.ENCRYPT_MODE, key);		return byteArr2HexStr(encryptCipher.doFinal(host.getBytes()));	}	catch(Exception e){		e.printStackTrace();		return "";	}}private static String byteArr2HexStr(byte[] arrB) throws Exception {	int iLen = arrB.length;	//每个byte用两个字符才能表示，所以字符串的长度是数组长度的两倍	StringBuffer sb = new StringBuffer(iLen * 2);	for (int i = 0; i < iLen; i++) {		int intTmp = arrB[i];		//把负数转换为正数		while (intTmp < 0) {			intTmp = intTmp + 256;		}		//小于0F的数需要在前面补0		if (intTmp < 16) {			sb.append("0");		}		sb.append(Integer.toString(intTmp, 16));	}	return sb.toString();}private Key getKey(byte[] arrBTmp) throws Exception {	//创建一个空的8位字节数组（默认值为0）	byte[] arrB = new byte[8];	//将原始字节数组转换为8位	for (int i = 0; i < arrBTmp.length && i < arrB.length; i++) {		arrB[i] = arrBTmp[i];	}	//生成密钥	Key key = new javax.crypto.spec.SecretKeySpec(arrB, "DES");	return key;}%><%String workNo = (String)session.getAttribute("workNo");System.out.println(workNo+"---jjjjs-");String workName = (String)session.getAttribute("workName");String orgCode = (String)session.getAttribute("orgCode");String passWord = (String)session.getAttribute("password");String regionCode = orgCode.substring(0,2);String infoFlag = "0";String urlStr = getLink("3","chninfo/fd955.do?operate=main","d955",session,request,"班前工作");%><!--取一级栏目--><wtc:service name="sGetWorkDataNew" outnum="9" routerKey="region" routerValue="<%=regionCode%>">  <wtc:param value="<%=workNo%>" />  <wtc:param value="1" />  <wtc:param value="99999" />  <wtc:param value="1" /></wtc:service><wtc:array id="firstMenu" scope="end"/><div id="divRetCode"><%=retCode%></div><div id="divRetMsg"><%=retMsg%></div><%if(retCode.equals("0")){  if(firstMenu!=null){	int lth =firstMenu.length ;	if(firstMenu.length >= 10){		lth = 10;	}%>	<div id="divShowFirstMenu"><%	for(int i=0; i<lth ; i++){		if ("99041".equals(firstMenu[i][1])) {			infoFlag = "1";%>		<li opcode="<%=firstMenu[i][1]%>" opname="<%=firstMenu[i][2]%>">			<a href="#" onclick=openChninfo(); class="text"><%=firstMenu[i][2]%></a>		</li><%		}else{%>		<li opcode="<%=firstMenu[i][1]%>" opname="<%=firstMenu[i][2]%>">			<a href="#" class="text"><%=firstMenu[i][2]%></a>		</li><%	 }	 }%>	</div>	<div id="divOtherFirstMenu"><%	if(firstMenu.length >= 10){		for(int i=10; i < firstMenu.length; i++){			if ("99041".equals(firstMenu[i][1])) {				infoFlag = "1";%>			  <li><a href="#this" onclick=openChninfo();HoverNav("tree","<%=firstMenu[i][1]%>","<%=firstMenu[i][2]%>")><%=firstMenu[i][2]%></a></li><%			} else {%>		  <li><a href="#this" onclick=HoverNav("tree","<%=firstMenu[i][1]%>","<%=firstMenu[i][2]%>")><%=firstMenu[i][2]%></a></li><%			}			}		}%><!-- begin : add by qidp @ 2010-06-24 --><%                              	String encryptUrl = "";%><%	String[] fcode = new String[9];	String[] fdisplay= new String[9];	fcode[0] = "91800";	fcode[1] = "2826";	fcode[2] = "99010";	fcode[3] = "99011";	fcode[4] = "99012";	fcode[5] = "99991";	fcode[6] = "99880";	fcode[7] = "99076";	fcode[8] = "d300";	StringBuffer sql = new StringBuffer();	sql.append("select * FROM (SELECT a.login_no, b.popedom_code                  \n");	sql.append("FROM sLoginRoalRelation a, sRolePdomRelation b, sPopedomCode c,sFuncCodenew d    \n");	sql.append("WHERE a.role_code = b.role_code                                   \n");	sql.append("AND a.login_no = '?'                                              \n");	sql.append("AND b.popedom_code = c.popedom_code                               \n");	sql.append("AND c.reflect_code = d.function_code                              \n");	sql.append("AND d.main_code='1'                                               \n");	sql.append("AND c.reflect_code ='?'                                           \n");	sql.append("UNION ALL                                                         \n");	sql.append("SELECT c.login_no, c.popedom_code                                 \n");	sql.append("FROM sLoginPdomRelation c, sPopedomCode d                         \n");	sql.append("WHERE c.login_no = '?'                                            \n");	sql.append("AND c.popedom_code = d.popedom_code                               \n");	sql.append("AND reflect_code = '?'                                            \n");	sql.append("AND rela_type = '0'                                               \n");	sql.append("MINUS                                                             \n");	sql.append("SELECT c.login_no, c.popedom_code                                 \n");	sql.append("FROM sLoginPdomRelation c, sPopedomCode d                         \n");	sql.append("WHERE c.login_no = '?'                                            \n");	sql.append("AND c.popedom_code = d.popedom_code                               \n");	sql.append("AND d.reflect_code = '?'                                          \n");	sql.append("AND rela_type = '1')                                              \n");for(int i=0;i<fcode.length;i++){%> <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" outnum="4">		<wtc:sql><%=sql.toString()%></wtc:sql> <wtc:param value="<%=workNo%>"/> <wtc:param value="<%=fcode[i]%>"/> <wtc:param value="<%=workNo%>"/> <wtc:param value="<%=fcode[i]%>"/> <wtc:param value="<%=workNo%>"/> <wtc:param value="<%=fcode[i]%>"/>	</wtc:pubselect>	<wtc:array id="myresult" scope="end" /><%	if(myresult.length>0){		fdisplay[i]="";	}else{		fdisplay[i]="none";	}}%><%	/**获取电子工单稽核随机码 ningtn**/%><wtc:service name="sd585Cfm" outnum="6" routerKey="region" 	 routerValue="<%=regionCode%>" retcode="retCode9" retmsg="retMsg9">  <wtc:param value="0" />  <wtc:param value="01" />  <wtc:param value="" />  <wtc:param value="<%=workNo%>" />	<wtc:param value="<%=passWord%>" />	<wtc:param value="" />	<wtc:param value="" /></wtc:service><wtc:array id="orderList" scope="end"/><%	String orderStyle = "none";	String regionInfo = "|";	String areaInfo = "|";	String hallInfo = "|";	String randomStr = "";	System.out.println(" @@@###############################@ " + workName + "|" + retCode9);	if("000000".equals(retCode9)){			if(orderList != null && orderList.length > 0){				orderStyle = "";				for(int iter = 0; iter < orderList[0].length; iter++){					System.out.println(" @@@@ " + orderList[0][iter]);				}				if(orderList[0][2] != null){					regionInfo = orderList[0][2];				}				if(orderList[0][3] != null){					areaInfo = orderList[0][3];				}				if(orderList[0][4] != null){					hallInfo = orderList[0][4];				}				if(orderList[0][5] != null){					randomStr = orderList[0][5];				}			}	}else{		orderStyle = "none";	}	session.setAttribute("regionInfo",regionInfo);	session.setAttribute("areaInfo",areaInfo);	session.setAttribute("hallInfo",hallInfo);	/*2015/04/23 14:21:42 gaopeng 加密后的工号*/ 	String encLoginNo = encrypt(workNo);%><%/*正式环境放开*/String token4a = (String)session.getAttribute("token4a");/*测试环境上线需要封掉String token4a = "token4atest";*/System.out.println("zhangyan  ~~~~~~~~~~~~~~~~~~token4a~~~~~~~~~~~~~``````"+token4a);String path = request.getContextPath();String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";%>	<!--生产IP	-->	<li class="othersystem" style="display:<%=fdisplay[0]%>"><a href="#" onclick="javascript:window.open('http://10.110.45.7/csp/bsf/index.action')" >知识库6.0</a></li>	<li class="othersystem" style="display:<%=orderStyle%>"><a href="#" onclick="javascript:window.open('http://10.110.0.100:39000/npage/login/index.html')">店员积分系统</a></li> 	<li class="othersystem" style="display:<%=fdisplay[0]%>"><a href="#" onclick="javascript:openZSKWindow('<%=basePath%>npage/login/ssoOpenNew.jsp?login_no=<%=workNo%>')" >新版知识库</a></li>	<li class="othersystem" style="display:<%=fdisplay[1]%>"><a href="#" onclick="javascript:window.open('http://10.110.2.242:7001/phone/index.jsp?login_no=<%=workNo%>');">终端管理</a></li>	<li class="othersystem" style="display:<%=fdisplay[2]%>"><a href="#" onclick="javascript:window.open('/AuthSend_vip.jsp?system_code=99010&targeturl=http://10.110.0.100:41000/main1.jsp?token4a=<%=token4a%>')">VIP客户管理</a></li>	<li class="othersystem" style="display:<%=fdisplay[3]%>"><a href="#" onclick="javascript:window.open('/AuthSend_vip.jsp?system_code=99011&targeturl=http://10.110.0.100:41000/main1.jsp?token4a=<%=token4a%>')">集团客户管理</a></li>	<li class="othersystem" style="display:<%=fdisplay[4]%>"><a href="#" onclick="javascript:window.open('/AuthSend.jsp?system_code=99012&targeturl=http://10.161.1.137:7001/loginCheck1.jsp');">网管</a></li>	<li class="othersystem" style="display:<%=fdisplay[6]%>"><a href="#" onclick="javascript:window.open('http://10.110.32.121/iwflow/login/VerifyLogin?workNo=<%=workNo%>');">客服投诉</a></li>	<li class="othersystem" style="display:<%=fdisplay[7]%>"><a href="#" onclick="javascript:window.open('http://10.110.2.23:7901/LoginServlet?<%=encryptUrl%>')" >计费系统</a></li>	<li class="othersystem" style="display:<%=fdisplay[8]%>"><a href="#" onclick="javascript:window.open('http://10.110.0.100:52000/npage/login/Accept.jsp?workNo=<%=workNo%>&pass=<%=passWord%>')">业务库系统</a></li>	<li class="othersystem" style="display:<%=orderStyle%>"><a href="#" onclick="javascript:window.open('http://10.110.0.100:59000/bp007.go?method=init&workNo=<%=workNo%>&workName=<%=workName%>&regionInfo=<%=regionInfo%>&areaInfo=<%=areaInfo%>&hallInfo=<%=hallInfo%>&checkNo=<%=randomStr%>')">电子工单系统</a></li>	<li class="othersystem" style="display:<%=orderStyle%>"><a href="#" onclick="javascript:window.open('http://10.110.0.100:62100/login.do?login_no=<%=workNo%>&encLoginNo=<%=encLoginNo %>')">业务稽核系统</a></li>  		<!--<li class="othersystem" style="display:<%=fdisplay[0]%>"><a href="#" onclick="javascript:window.open('http://10.110.32.120/csp/bsf/index.action')" >知识库6.0</a></li>-->	<!--测试	<li class="othersystem" style="display:<%=fdisplay[0]%>"><a href="#" onclick="javascript:openIE('<%=basePath%>npage/login/ssoJava_new.jsp?login_no=<%=workNo%>')" >客服知识库7.0</a></li>	<li class="othersystem" style="display:<%=fdisplay[1]%>"><a href="#" onclick="javascript:window.open('http://10.110.2.241:7001/phone/index.jsp?login_no=<%=workNo%>');">终端管理</a></li>	<li class="othersystem" style="display:<%=fdisplay[2]%>"><a href="#" onclick="javascript:window.open('/AuthSend_vip.jsp?system_code=99010&targeturl=http://10.110.0.204:10006/main1.jsp?token4a=<%=token4a%>')">VIP客户管理</a></li>	<li class="othersystem" style="display:<%=fdisplay[3]%>"><a href="#" onclick="javascript:window.open('/AuthSend_vip.jsp?system_code=99011&targeturl=http://10.110.0.204:10006/main1.jsp?token4a=<%=token4a%>')">集团客户管理</a></li>	<li class="othersystem" style="display:<%=fdisplay[4]%>"><a href="#" onclick="javascript:window.open('/AuthSend.jsp?system_code=99012&targeturl=http://10.161.1.137:7001/loginCheck1.jsp');">网管</a></li>	<li class="othersystem" style="display:<%=fdisplay[6]%>"><a href="#" onclick="javascript:window.open('http://10.110.32.121/iwflow/login/VerifyLogin?workNo=<%=workNo%>');">客服投诉</a></li>	<li class="othersystem" style="display:<%=fdisplay[8]%>"><a href="#" onclick="javascript:window.open('http://10.110.0.206:26001/npage/login/Accept.jsp?workNo=<%=workNo%>&pass=<%=passWord%>')">业务库系统</a></li>	<li class="othersystem" style="display:<%=orderStyle%>"><a href="#" onclick="javascript:window.open('http://10.110.0.204:8899/logincheck.php?workNo=<%=workNo%>&workName=<%=workName%>&regionInfo=<%=regionInfo%>&areaInfo=<%=areaInfo%>&hallInfo=<%=hallInfo%>&checkNo=<%=randomStr%>')">电子工单系统</a></li>	-->	</div><%	}}%><input name="chninfoFlag" id="chninfoFlag" /><script language="javascript">var xbzhsHandle="";	$(document).ready(function(){		var infoFlagVal = "<%=infoFlag%>";		if("1" == infoFlagVal){			var packet = new AJAXPacket("getInfoPower.jsp","请稍后...");			core.ajax.sendPacket(packet,doAjaxGetInfo);			}	});	function doAjaxGetInfo(packet){		var showInfoFlag = packet.data.findValueByName("showInfoFlag");		$("#chninfoFlag").val(showInfoFlag);	}	function openChninfo(){		if("1" == $("#chninfoFlag").val()){			window.open("<%=urlStr%>","99041","width="+screen.availWidth+",height="+screen.availHeight+",top=0,left=0,scrollbars=yes,resizable=yes,status=yes");		}	}	function openZSKWindow(url){ 	if(xbzhsHandle!=null&&xbzhsHandle!=''&&(xbzhsHandle.closed!=undefined&&!xbzhsHandle.closed)){		xbzhsHandle.focus(); 	}else{ 		xbzhsHandle=window.open(url); 	}}</script>