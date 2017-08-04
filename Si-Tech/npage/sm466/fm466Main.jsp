<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
/*
* 功能: 
* 版本: 1.0
* 日期: liangyl 2017/04/10 liangyl 新IMS固话业务支撑改造项目
* 作者: liangyl
* 版权: si-tech
*/
%>
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
		response.setHeader("Pragma","No-Cache"); 
		response.setHeader("Cache-Control","No-Cache");
		response.setDateHeader("Expires", 0); 
    
 		String opCode = "m466";
 		String opName = "IMS固话过户";
 		
 		String phoneNo = (String)request.getParameter("activePhone");
 		String broadPhone = (String)request.getParameter("activePhone");
 		String groupId =(String)session.getAttribute("groupId");
 		String regionCode= (String)session.getAttribute("regCode");
 		String workNo = (String)session.getAttribute("workNo");
 		String loginPwd = (String)session.getAttribute("password");
 		String[][] temfavStr=(String[][])session.getAttribute("favInfo");
		String[] favStr=new String[temfavStr.length];
		for(int i=0;i<favStr.length;i++)
			favStr[i]=temfavStr[i][0].trim();
%>
		<wtc:service name="sPubUsrBaseInfo" routerKey="region" routerValue="<%=regionCode%>" 
			retcode="retCode1" retmsg="retMsg1" outnum="30" >
			<wtc:param value=" "/>
			<wtc:param value="01"/>
			<wtc:param value="<%=opCode%>"/>
			<wtc:param value="<%=workNo%>"/>	
			<wtc:param value="<%=loginPwd%>"/>		
			<wtc:param value="<%=phoneNo%>"/>	
			<wtc:param value=" "/>
		</wtc:service>
		<wtc:array id="sPubUsrBaseInfoArr" scope="end"/>
			
		<%
		 String loginAccept = "";
		%>
		<wtc:sequence name="sPubSelect" key="sMaxSysAccept" 
			routerKey="region"  routerValue="<%=regionCode%>" id="sLoginAccept"/>
		<%
		/*2016/2/29 13:37:38 gaopeng  1238中原有逻辑 查询实际使用人信息*/
	String opNote = "用户"+phoneNo+"进行了["+opName+"]操作";
	String qRealUserName = "";
  String qRealUserAddr = "";
  String qRealUserIdType = "";
  String qRealUserIccId = "";
%>
<wtc:service name="sm245Qry" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode_realUser" retmsg="retMsg_realUser" outnum="6"	>
	<wtc:param value = "<%=loginAccept%>"/>
	<wtc:param value = "01"/>
	<wtc:param value = "<%=opCode%>"/>
	<wtc:param value = "<%=workNo%>"/>
	<wtc:param value = "<%=loginPwd%>"/>
	<wtc:param value = "<%=phoneNo%>"/>
	<wtc:param value = ""/>
	<wtc:param value = "<%=opNote%>"/>
</wtc:service>
<wtc:array id="ret_realUser" scope="end" />
<%

	if("000000".equals(retCode_realUser)){
		if(ret_realUser.length > 0){
			qRealUserIdType = ret_realUser[0][2];
		  qRealUserIccId = ret_realUser[0][3];
		  qRealUserName = ret_realUser[0][4];
		  qRealUserAddr = ret_realUser[0][5];
		}
	}
	
%>
		
<%
    if(!"000000".equals(retCode1)){
%>
      <script language=javascript>
        rdShowMessageDialog('错误代码：<%=retCode1%><br>错误信息：<%=retMsg1%>');
        removeCurrentTab();
      </script>
<%
      return;
    }
    ArrayList baseInfoList = new ArrayList();
		if(sPubUsrBaseInfoArr!=null&&sPubUsrBaseInfoArr.length>0&&retCode1.equals("000000")){
			for(int i=0;i<sPubUsrBaseInfoArr.length;i++){
				for(int j=0;j<sPubUsrBaseInfoArr[i].length;j++){
					baseInfoList.add(sPubUsrBaseInfoArr[i][j]);
					System.out.println("sPubUsrBaseInfoArr["+i+"]["+j+"]="+sPubUsrBaseInfoArr[i][j]);
				}
			}
		}else{
%>
			<script language=javascript>
        rdShowMessageDialog('错误代码：<%=retCode1%><br>错误信息：<%=retMsg1%>');
        removeCurrentTab();
      </script>
<%
		}
		String userRegionCode = ((String)baseInfoList.get(2)).length()>=2?((String)baseInfoList.get(2)).substring(0,2):"";
		String handFeeSqlStr = "select hand_fee ,trim(favour_code) from snewFunctionFee where region_code='"+userRegionCode+"' and function_code='"+opCode+"'";
%>
		<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" outnum="2">
		    <wtc:sql><%=handFeeSqlStr%>
		    </wtc:sql>
				</wtc:pubselect>
		<wtc:array id="handFeeSqlArr" scope="end"/>
<%
		if(handFeeSqlArr!=null&&handFeeSqlArr.length>0){
			for(int i=0;i<handFeeSqlArr[0].length;i++){
				baseInfoList.add(handFeeSqlArr[0][i]);
			}
		}else{
				baseInfoList.add("");
				baseInfoList.add("");
		}
		
		//服务返回参数可能不规范,比如返回四位等等.所以这样转化下,避免因为服务参数不规范带来的错误
		int returnCode = retCode1==""?999999:Integer.parseInt(retCode1);
		String returnMsg = retMsg1;
		baseInfoList.add(String.valueOf(returnCode));
		baseInfoList.add(returnMsg);

		//在这里进行链表转换一下
		ArrayList custDoc = baseInfoList;
		if(custDoc.size()<34){ //如果长度不够34,就表明出错了
%>
			<script language=javascript>
        rdShowMessageDialog("未能取得用户完整的基本信息!");
        removeCurrentTab();
      </script>
<%
		}
		/***用户品牌***/
		String sNewSmName = ((String)custDoc.get(3))==null?"":(String)custDoc.get(3);
		boolean hfrf=false;
		if(((String)custDoc.get(30)).trim().equals("") 
				|| ((String)custDoc.get(30)).trim().equals("0") 
				|| Double.parseDouble(((String)(custDoc.get(30))))==0){
 			hfrf=true;
		}else{
      if(!WtcUtil.haveStr(favStr,((String)custDoc.get(31)).trim())){
 				hfrf=true;
		  }
		}
%>

<%
		loginAccept = sLoginAccept;
		String main_str1="";
		String OldId=(String)custDoc.get(0);
		String sqlStrk = "SELECT '('||a.offer_id||' '||trim(b.offer_name)||')',a.offer_id FROM product_offer_instance a, product_offer b "+
	 				  "WHERE a.offer_id = b.offer_id and SYSDATE BETWEEN a.eff_date AND a.exp_date "+
	 				  "and b.offer_type = '10' and a.state = 'A' and a.serv_id = to_number('"+OldId+"')	";
%>
		<wtc:pubselect name="sPubSelect" routerKey="region" 
			 routerValue="<%=regionCode%>" outnum="2">
    <wtc:sql><%=sqlStrk%></wtc:sql>
		</wtc:pubselect>
		<wtc:array id="result" scope="end"/>
<%
	if(result!=null&&result.length>0){
		main_str1 = result[0][0];
	}
	
	String anzhcontactName="";
	String anzhcontactPhone="";
%>
<%
		/* add for 是否为社会渠道工号 1：是 @2014/11/19  */
		String workChnFlag = "0" ;
%>	
		<wtc:service name="s1100Check" outnum="30"
			routerKey="region" routerValue="<%=regionCode%>" retcode="rc" retmsg="rm" >
			<wtc:param value = ""/>
			<wtc:param value = "01"/>
			<wtc:param value = "<%=opCode%>"/>
			<wtc:param value = "<%=workNo%>"/>
			<wtc:param value = "<%=loginPwd%>"/>
				
			<wtc:param value = ""/>
			<wtc:param value = ""/>
		</wtc:service>
		<wtc:array id="rst" scope="end" />
<%

if ( rc.equals("000000") )
{
	if ( rst.length!=0 )
	{
		workChnFlag = rst[0][0];
	}
	else
	{
	%>
		<script>
			rdShowMessageDialog( "服务s1100Check没有返回结果!" );
			removeCurrentTab();
		</script>
	<%	
	}
}
else
{
%>
	<script>
		rdShowMessageDialog( "<%=rc%>:<%=rm%>" );
		removeCurrentTab();
	</script>
<%
}

    /*关于落实打击黑卡工作的BOSS优化补充需求地市配置表start*/
    String sql_appregionset1 = "select count(*) from sOrderCheck where group_id=:groupids and flag='Y' ";
    String sql_appregionset2 = "groupids="+groupId;
    String appregionflag="0";//==0只能进行工单查询，>0可以进行工单查询或者读卡
    System.out.println(sql_appregionset1+"------------"+sql_appregionset2);
 %>
 		<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCodeappregion" retmsg="retMsgappregion" outnum="1"> 
			<wtc:param value="<%=sql_appregionset1%>"/>
			<wtc:param value="<%=sql_appregionset2%>"/>
		</wtc:service>  
		<wtc:array id="appregionarry"  scope="end"/>
<%
	System.out.println("appregionarry==length===="+appregionarry.length);
			if("000000".equals(retCodeappregion)){
				if(appregionarry.length > 0){
					appregionflag = appregionarry[0][0]; 
					System.out.println("appregionarry[0][0]======"+appregionarry[0][0]);
				}
		}
		System.out.println("appregionflag======"+appregionflag);
		/*关于落实打击黑卡工作的BOSS优化补充需求地市配置表end*/
		String sql_sendListOpenFlag = "select count(*) from shighlogin where login_no='K' and op_code='m194'";
		String sendListOpenFlag = "0"; //下发工单开关 0：关，>0：开
%>
		<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode1" retmsg="retMsg1" outnum="1"> 
			<wtc:param value="<%=sql_sendListOpenFlag%>"/>
		</wtc:service>  
		<wtc:array id="ret1"  scope="end"/>
<%
		if("000000".equals(retCode1)){
			if(ret1.length > 0){
				sendListOpenFlag = ret1[0][0]; 
			}
		}
		
		String  sql_regionCodeFlag [] = new String[2];
		sql_regionCodeFlag[0] = "select count(*) from shighlogin where op_code ='m195' and login_no=:regincode";
		sql_regionCodeFlag[1] = "regincode="+regionCode;
		String regionCodeFlag = "N"; //地市是否可见 下发工单按钮 Y可见，N不可见
%>
		<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode2" retmsg="retMsg2" outnum="1"> 
			<wtc:param value="<%=sql_regionCodeFlag[0]%>"/>
			<wtc:param value="<%=sql_regionCodeFlag[1]%>"/>
		</wtc:service>  
		<wtc:array id="ret2"  scope="end"/>
<%
		if("000000".equals(retCode2)){
			if(ret2.length > 0){
				if(Integer.parseInt(ret2[0][0]) > 0){
					regionCodeFlag = "Y"; 
				}
			}
		}
%>



<html>
<head>
	<title>IMG固话过户</title>
	<script language="javascript">
		var v_printAccept;
		
		$(document).ready(function(){
			getUserBaseInfo();
			getCustId();
			getIdTypes();
			reSetCustName();
			/*读卡二代必须有的属性*/
			v_printAccept = "<%=loginAccept%>";
			
		});
		function jtrim(str){
			return str.replace( /^\s*/, "" ).replace( /\s*$/, "" );
    }
		function getUserBaseInfo(){
			/*获取用户信息*/
			var getdataPacket = new AJAXPacket("/npage/public/pubGetUserBaseInfo.jsp","正在获得数据，请稍候......");
			getdataPacket.data.add("phoneNo","<%=phoneNo%>");
			getdataPacket.data.add("opCode","<%=opCode%>");
			core.ajax.sendPacket(getdataPacket,doGetPrypayBack);
			getdataPacket = null;
		}
		function doGetPrypayBack(packet){
			var retCode = packet.data.findValueByName("retcode");
			var retMsg = packet.data.findValueByName("retmsg");
			var contactPhone = packet.data.findValueByName("stPMcontact_phone");
			var contactPerson = packet.data.findValueByName("stPMcontact_person");
			$("#contactPhone").text(contactPhone);
			$("#contactPerson").text(contactPerson);
		}
		function getCustId(){
			var getUserId_Packet = new AJAXPacket("/npage/s1210/s1238_getID.jsp","正在获得新客户ID，请稍候......");
			getUserId_Packet.data.add("retType","getID");
			getUserId_Packet.data.add("region_code","<%=regionCode%>");
			getUserId_Packet.data.add("idType","0");
			getUserId_Packet.data.add("oldId","0");
			core.ajax.sendPacket(getUserId_Packet,doGetCustIdBack);
			getUserId_Packet = null;
		}
		function doGetCustIdBack(packet){
			var retCode = packet.data.findValueByName("retCode");
			var retMsg = packet.data.findValueByName("retMessage");
			var retnewId = packet.data.findValueByName("retnewId");
			if(retCode == "000000"){
				$("#new_cus_id").val(retnewId);
				$("#custId").val(retnewId);
			}else{
				rdShowMessageDialog(retCode + ":" + retMsg);
				removeCurrentTab();
			}
		}
		function checkXi(){
			if(frm.xinYiDu.value>0){
				rdShowMessageDialog("信誉度不能大于零！");
				return;
			}
		}
		function reSetCustName(){/*重置客户名称*/
			document.all.custName.value="";
			document.all.newContactPerson.value="";
			getIdTypes();
			var checkVal = $("select[name='isJSX']").find("option:selected").val();
			
			if(checkVal == 1){
			  	$("#gestoresInfo1").show();
			  	$("#gestoresInfo2").show();
			  	$("#realUserInfo1").show();
			  	$("#realUserInfo2").show();
			  	$("#sendProjectList").hide(); //下发工单按钮
					$("#qryListResultBut").hide(); //工单结果查询按钮
			  	
			  	/*经办人姓名*/
			  	document.all.gestoresName.v_must = "1";
			  	/*经办人地址*/
			  	document.all.gestoresAddr.v_must = "1";
			  	/*经办人证件号码*/
			  	document.all.gestoresIccId.v_must = "1";
			  	var checkIdType = $("select[name='gestoresIdType']").find("option:selected").val();
			  	/*身份证加入校验方法*/
			  	if(checkIdType.indexOf("身份证") != -1){
			  		document.all.gestoresIccId.v_type = "idcard";
			  		$("#scan_idCard_two3").css("display","");
			  		$("#scan_idCard_two31").css("display","");
			  		$("input[name='gestoresName']").attr("class","InputGrey");
			  		$("input[name='gestoresName']").attr("readonly","readonly");
			  		$("input[name='gestoresAddr']").attr("class","InputGrey");
			  		$("input[name='gestoresAddr']").attr("readonly","readonly");
			  		$("input[name='gestoresIccId']").attr("class","InputGrey");
			  		$("input[name='gestoresIccId']").attr("readonly","readonly");
			  	}else{
			  		document.all.gestoresIccId.v_type = "string";
			  		$("#scan_idCard_two3").css("display","none");
			  		$("#scan_idCard_two31").css("display","none");
			  		$("input[name='gestoresName']").removeAttr("class");
			  		$("input[name='gestoresName']").removeAttr("readonly");
			  		$("input[name='gestoresAddr']").removeAttr("class");
			  		$("input[name='gestoresAddr']").removeAttr("readonly");
			  		$("input[name='gestoresIccId']").removeAttr("class");
			  		$("input[name='gestoresIccId']").removeAttr("readonly");
			  	}
			  	
			  	//责任人信息
			  	$("#responsibleInfo1").show();
			  	$("#responsibleInfo2").show();
			
			  	/*责任人人姓名*/
			  	document.all.responsibleName.v_must = "1";
			  	/*责任人人地址*/
			  	document.all.responsibleAddr.v_must = "1";
			  	/*经责任人人证件号码*/
			  	document.all.responsibleIccId.v_must = "1";
			  	var checkIdType22 = $("select[name='responsibleType']").find("option:selected").val();
			  	/*身份证加入校验方法*/
			  	if(checkIdType22.indexOf("身份证") != -1){
			  		document.all.responsibleIccId.v_type = "idcard";
			  		$("#scan_idCard_two3zrr").css("display","");
			  		$("#scan_idCard_two57zrr").css("display","");
			  		$("input[name='responsibleName']").attr("class","InputGrey");
			  		$("input[name='responsibleName']").attr("readonly","readonly");
			  		$("input[name='responsibleAddr']").attr("class","InputGrey");
			  		$("input[name='responsibleAddr']").attr("readonly","readonly");
			  		$("input[name='responsibleIccId']").attr("class","InputGrey");
			  		$("input[name='responsibleIccId']").attr("readonly","readonly");  		
			  		
			  	}else{
			  		document.all.responsibleIccId.v_type = "string";
			  		$("#scan_idCard_two3zrr").css("display","none");
			  		$("#scan_idCard_two57zrr").css("display","none");
			  		$("input[name='responsibleName']").removeAttr("class");
			  		$("input[name='responsibleName']").removeAttr("readonly");
			  		$("input[name='responsibleAddr']").removeAttr("class");
			  		$("input[name='responsibleAddr']").removeAttr("readonly");
			  		$("input[name='responsibleIccId']").removeAttr("class");
			  		$("input[name='responsibleIccId']").removeAttr("readonly");  		
			  		
			  	}  	
			  	
			  	/*实际使用人信息 必填*/
			  	/*实际使用人姓名*/
			  	document.all.realUserName.v_must = "1";
			  	/*经实际使用人地址*/
			  	document.all.realUserAddr.v_must = "1";
			  	/*实际使用人证件号码*/
			  	document.all.realUserIccId.v_must = "1";
			  	
			  	$("#realUserInfo1").find("td:eq(0)").attr("width","13%");
			  	$("#realUserInfo1").find("td:eq(0)").attr("nowrap","nowrap");
			  	$("#realUserInfo1").find("td:eq(1)").attr("nowrap","nowrap");
			  	$("#realUserInfo1").find("td:eq(2)").attr("width","13%");
			  	$("#realUserInfo1").find("td:eq(2)").attr("nowrap","nowrap");
			  	$("#realUserInfo1").find("td:eq(3)").attr("nowrap","nowrap");
			  	$("#realUserInfo1").find("td:eq(3)").attr("colSpan","3");
			  	
			  	$("#realUserInfo2").find("td:eq(0)").attr("width","13%");
			  	$("#realUserInfo2").find("td:eq(0)").attr("nowrap","nowrap");
			  	$("#realUserInfo2").find("td:eq(1)").attr("nowrap","nowrap");
			  	$("#realUserInfo2").find("td:eq(2)").attr("width","13%");
			  	$("#realUserInfo2").find("td:eq(2)").attr("nowrap","nowrap");
			  	$("#realUserInfo2").find("td:eq(3)").attr("nowrap","nowrap");
			  	$("#realUserInfo2").find("td:eq(3)").attr("colSpan","3");
			  	
			  	
  	
	  	
  	
  		}
			  /*没选择单位客户的时候，均不展示并设置为不需要必填选项*/
			  else{
			  	
			  	/* begin add 如 1238+普通开户+身份证+社会渠道工号+开关+开展地市，则显示“下发工单”按钮 for 关于电话用户实名登记近期重点工作的通知 @2014/11/4 */
	  if(checkVal == 0){
			var idTypeSelect = $("#idTypeSelect option[@selected]").val();//证件类型：身份证
			
			if(idTypeSelect.indexOf("|") != -1){
				var v_idTypeSelect = idTypeSelect.split("|")[0];
				if(v_idTypeSelect == "0" && "<%=workChnFlag%>" == "1" && "<%=opCode%>" == "m466" && (parseInt($("#sendListOpenFlag").val()) > 0) && "<%=regionCodeFlag%>" == "Y"){ 
					$("#sendProjectList").show();
					$("#qryListResultBut").show();
				}else{
					$("#sendProjectList").hide();
					$("#qryListResultBut").hide();
				}
			}
			
	  }
	  
			  	$("#gestoresInfo1").hide();
			  	$("#gestoresInfo2").hide();
			  	$("#realUserInfo1").hide();
			  	$("#realUserInfo2").hide();
			  	/*经办人姓名*/
			  	document.all.gestoresName.v_must = "0";
			  	/*经办人地址*/
			  	document.all.gestoresAddr.v_must = "0";
			  	/*经办人证件号码*/
			  	document.all.gestoresIccId.v_must = "0";
			  	
			  	//责任人信息
			  	$("#responsibleInfo1").hide();
			  	$("#responsibleInfo2").hide();
			
			  	/*责任人人姓名*/
			  	document.all.responsibleName.v_must = "0";
			  	/*责任人人地址*/
			  	document.all.responsibleAddr.v_must = "0";
			  	/*经责任人人证件号码*/
			  	document.all.responsibleIccId.v_must = "0";  
			  	
			  	/*实际使用人姓名*/
			  	document.all.realUserName.v_must = "0";
			  	/*经实际使用人地址*/
			  	document.all.realUserAddr.v_must = "0";
			  	/*实际使用人证件号码*/
			  	document.all.realUserIccId.v_must = "0"; 	
			  	
			  }
			
			
		}
		function change_ConPerson(){
			//联系人姓名随客户名称改名而改变
			document.all.newContactPerson.value = document.all.custName.value;
		}
		function feifaCustName(textName){
			if(textName.value != "")
			{
				if(document.all.isJSX.value=="0"){
					var m = /^[\u0391-\uFFE5]+$/;
					var flag = m.test(textName.value);
					if(!flag){
						rdShowMessageDialog("只允许输入中文！");
						reSetCustName();
					}
					if(textName.value.length > 6){
						rdShowMessageDialog("只允许输入6个汉字！");
						reSetCustName();
					}
				}else{
					if((textName.value.indexOf("~")) != -1 || (textName.value.indexOf("|")) != -1 || (textName.value.indexOf(";")) != -1)
					{
						rdShowMessageDialog("不允许输入非法字符，个人开户分类请选择介绍信开户！");
						textName.value = "";
			 	  		return;
					}
				}
			}
		}
		function change_idType(){
		
			/*2016/2/29 11:04:27 gaopeng 
				1）“个人开户分类”改为“普通客户”和“单位客户”。--ok
				2）“个人开户分类”为普通客户，则证件类型只可以看见军官证、户口簿、港澳通行证、警官证、台湾通行证、外国公民护照和身份证；--ok
				   “个人开户分类”为单位客户，则证件类型只可以看见营业执照、组织机构代码、单位法人证书、单位证明；
				3）如果证件类型是身份证，则将“扫描一代身份证”删除。
					同时增加“读卡(2代)”，即与“GSM过户(1238)”一致。
				4）如果证件类型是身份证，则客户名称、证件号码和证件地址不可以修改。
					如果证件地址超过60个字节，系统自动截取前60个字节传(因为dcustdoc的证件地址就支持60个字节)。
				5）如果证件类型是营业执照、组织机构代码、单位法人证书和单位证明，则界面增加经办人、责任人和实际使用人信息(如右下图)。
					系统需要对这三种信息做正常的合法性校验。如果用户有这三项信息，则默认展示，允许修改。如果没有，则必填填写。即与“GSM过户(1238)”一致。
				6）系统需要对“IMG固话过户(m466)”界面的所有证件信息，联系人信息、客户信息等做合法性校验，即与“GSM过户(1238)”一致。
				
				
				
			*/
			var Str = document.all.idType.value;
			if(Str.indexOf("0") > -1||Str.indexOf("D") > -1){
				document.all.idIccid.v_type = "idcard";  
				document.all("card_id_type").style.display="";
				document.all("read_idCard_one").style.display="none";
				/*
				如果证件类型是身份证，则客户名称、证件号码和证件地址不可以修改。
				如果证件地址超过60个字节，
				系统自动截取前60个字节传(因为dcustdoc的证件地址就支持60个字节)。
				*/
				var checkVal = document.all.isJSX.value;//个人开户分类 普通客户：0
				if(checkVal == "0" && "<%=workChnFlag%>" == "1" && "<%=opCode%>" == "m466" && (parseInt($("#sendListOpenFlag").val()) > 0) && "<%=regionCodeFlag%>" == "Y"){
					$("#sendProjectList").show();
					$("#qryListResultBut").show();
				}else{
					$("#sendProjectList").hide();
					$("#qryListResultBut").hide();
				}
				$("#idIccid").attr("class","InputGrey");
				$("#idIccid").attr("readonly","readonly");
				$("#custName").attr("class","InputGrey");
				$("#custName").attr("readonly","readonly");
				$("#idAddr").attr("class","InputGrey");
				$("#idAddr").attr("readonly","readonly");
				
			}
			else{
				$("#sendProjectList").hide();
					$("#qryListResultBut").hide();
				document.all.idIccid.v_type = "string";   
				document.all("card_id_type").style.display="none";
				document.all("read_idCard_one").style.display="";
				$("#idIccid").removeAttr("class");
				$("#idIccid").removeAttr("readonly");
				$("#custName").removeAttr("class");
				$("#custName").removeAttr("readonly");
				$("#idAddr").removeAttr("class");
				$("#idAddr").removeAttr("readonly");
			}
			




		}
		function getInfo_IccId_JustSee(){
			//根据客户证件号码得到相关信息
			if(jtrim(document.frm.idIccid.value).length == 0)
			{
				rdShowMessageDialog("请输入客户证件号码！");
				return false;
			}else if(jtrim(document.frm.idIccid.value).length < 5){
				rdShowMessageDialog("证件号码长度有误（最少五位）！");
				return false;
			}
			var pageTitle = "客户信息查询";
			var fieldName = "手机号码|开户时间|证件类型|证件号码|归属地|状态|";
			var sqlStr = "select c.phone_no,to_char(a.CREATE_TIME,'YYYY-MM-DD HH24:MI:SS'),b.ID_NAME,a.ID_ICCID," +
			       " trim(e.REGION_NAME)||'-->'||trim(f.DISTRICT_NAME)," +
			       " d.run_name from DCUSTDOC a,SIDTYPE b ,DCustMsg c ,sRuncode d ,sregioncode e,sdiscode f where a.region_code=d.region_code and substr(c.run_code,2,1)=d.run_code and  a.cust_id=c.cust_id and b.ID_TYPE = a.ID_TYPE " +
			       " and a.region_code=e.region_code and a.region_code=f.region_code and a.district_code=f.district_code and  a.ID_ICCID = '" + document.frm.idIccid.value + "' and substr(c.run_code,2,1)<'a'  and rownum<500 order by a.cust_name asc,a.create_time desc ";
			var selType = "S";    //'S'单选；'M'多选
			var retQuence = "7|0|1|3|4|5|6|7|";
			var retToField = "in0|in4|in3|in2|in5|in6|in1|";
			custInfoQueryJustSee(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
		}
		function custInfoQueryJustSee(pageTitle,fieldName,sqlStr,selType,retQuence,retToField){
		    /*
		    参数1(pageTitle)：查询页面标题
		    参数2(fieldName)：列中文名称，以'|'分隔的串
		    参数3(sqlStr)：sql语句
		    参数4(selType)：类型1 rediobutton 2 checkbox
		    参数5(retQuence)：返回域信息，返回域个数＋ 返回域标识，以'|'分隔，如"3|0|2|3"表示返回3个域0，2，3
		    参数6(retToField))：返回值存放域的名称,以'|'分隔
		    */
		var custnamess=document.all.custName.value.trim();
		var idTypesss="";
		var idTypeSelect = $("#idTypeSelect option[@selected]").val();//证件类型
		if(idTypeSelect.indexOf("|") != -1){
			  idTypesss = idTypeSelect.split("|")[0];
			  if(idTypesss=="0") {//身份证
				    if(custnamess.len() == 0)
				    {
				        //rdShowMessageDialog("请输入客户名称后再进行信息查询！");
				        //return false;
				    }
			   }   
    }

    var path = "/npage/sq100/getPhoneNumInner.jsp";
    path = path + "?idIccid=" + document.all.idIccid.value.trim()+"&idtype="+idTypesss+"&custnames="+custnamess+"&opcode=m466";
    window.showModalDialog(path,"","dialogWidth:30;dialogHeight:15;");
    
		}
		function chcek_pic1121(){
			var pic_path = document.all.filep.value;
			var d_num = pic_path.indexOf("\.");
			var file_type = pic_path.substring(d_num+1,pic_path.length);
			//判断是否为jpg类型 //厂家设备生成图片固定为jpg类型
			if(file_type.toUpperCase()!="JPG"){ 
				rdShowMessageDialog("请选择jpg类型图像文件");
				document.all.up_flag.value=3;
				//document.all.print.disabled=true;
				resetfilp();
				return ;
			}
			
			var pic_path_flag= document.all.pic_name.value;
			
			if(pic_path_flag==""){
				rdShowMessageDialog("请先扫描或读取证件信息");
				document.all.up_flag.value=4;
				//document.all.print.disabled=true;
				resetfilp();
				return;
			}
			else{
				if(pic_path!=pic_path_flag){
					rdShowMessageDialog("请选择最后一次扫描或读取证件而生成的证件图像文件"+pic_path_flag);
					document.all.up_flag.value=5;
					//document.all.print.disabled=true;
					resetfilp();
					return;
				}
				else{
					document.all.up_flag.value=2;
					document.all.uploadpic_b.disabled=false;//二代证
				}
			}
		}
		function resetfilp(){//二代证
			document.getElementById("filep").outerHTML = document.getElementById("filep").outerHTML;
		}
		function changeCardAddr(obj){
			document.all.custAddr.value=obj.value;
			document.all.contactAddr.value=obj.value;
			document.all.contactMAddr.value=obj.value;
		}
		function uploadpic(){//二代证
			if(document.all.filep.value==""){
				rdShowMessageDialog("请选择要上传的图片",0);
				return;
			}
			if(document.all.but_flag.value=="0"){
				rdShowMessageDialog("请先扫描或读取图片",0);
				return;
			}
			frm.target="upload_frame"; 
			document.frm.encoding="multipart/form-data";
			var actionstr ="/npage/s1210/s1238Main_uppic.jsp?custId="+document.frm.custId.value+
										"&regionCode="+document.frm.regionCode.value+
										"&filep_j="+document.all.filep.value+
										"&card_flag="+document.all.card_flag.value+ 
										"&but_flag="+document.all.but_flag.value+
										"&idSexH="+document.all.idSexH.value+
										"&custName="+document.all.custName.value+
										"&idAddrH="+document.all.idAddrH.value.replace(new RegExp("#","gm"),"%23")+
										"&birthDayH="+document.all.birthDayH.value+
										"&custId="+document.all.custId.value+
										"&idIccid="+document.all.idIccid.value+
										"&workno="+document.all.workno.value+
										"&zhengjianyxq="+document.all.idValidDate.value+
										"&upflag=1";
										
			frm.action = actionstr; 
			document.all.upbut_flag.value="1";
			frm.submit();
			resetfilp();
			document.frm.encoding="application/x-www-form-urlencoded";
			
		}
		function chkValid(){
			 var d= (new Date().getFullYear().toString()+(((new Date().getMonth()+1).toString().length>=2)?(new Date().getMonth()+1).toString():("0"+(new Date().getMonth()+1)))+(((new Date().getDate()).toString().length>=2)?(new Date().getDate()):("0"+(new Date().getDate()))).toString());
	
			 if(jtrim(document.all.idValidDate.value).length>0)
			 {
				if(forDate(document.all.idValidDate)==false) return false;
	
				if(to_date(document.all.idValidDate)<=d)
				{
				  rdShowMessageDialog("证件有效期不能早于当前时间，请重新输入！");
				  document.all.idValidDate.focus();
				  document.all.idValidDate.select();
				  return false;
				}
			}
		}
		function feifa(textName)
		{
			if(textName.value != "")
			{
				if((textName.value.indexOf("~")) != -1 || (textName.value.indexOf("|")) != -1 || (textName.value.indexOf(";")) != -1)
				{
					rdShowMessageDialog("不允许输入非法字符，请重新输入！");
					textName.value = "";
		 	  		return;
				}
			}
		}
		function chkPwdEasy1(pwd){
			if(pwd == ""){
				rdShowMessageDialog("请先输入密码！");
				return ;
			}
			var checkPwd_Packet = new AJAXPacket("../public/pubCheckPwdEasy.jsp","正在验证密码是否过于简单，请稍候......");
			checkPwd_Packet.data.add("password", pwd);
			checkPwd_Packet.data.add("phoneNo", "<%=phoneNo%>");
			checkPwd_Packet.data.add("idNo", frm.idIccid.value);
			checkPwd_Packet.data.add("opCode", "m466");
			checkPwd_Packet.data.add("custId", "");
		
			core.ajax.sendPacket(checkPwd_Packet, doCheckPwdEasy1);
			checkPwd_Packet=null;
		}
		function doCheckPwdEasy1(packet) {
			var retResult = packet.data.findValueByName("retResult");
			if (retResult == "1") {
				rdShowMessageDialog("尊敬的客户，您本次设置的密码为相同数字类密码，安全性较低，为了更好地保护您的信息安全，请您设置安全性更高的密码。");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "2") {
				rdShowMessageDialog("尊敬的客户，您本次设置的密码为连号类密码，安全性较低，为了更好地保护您的信息安全，请您设置安全性更高的密码。");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "3") {
				rdShowMessageDialog("尊敬的客户，您本次设置的密码为手机号码中的连续数字，安全性较低，为了更好地保护您的信息安全，请您设置安全性更高的密码。");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "4") {
				rdShowMessageDialog("尊敬的客户，您本次设置的密码为证件中的连续数字，安全性较低，为了更好地保护您的信息安全，请您设置安全性更高的密码。");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "0") {
				//rdShowMessageDialog("校验成功！密码可用！");
			}
		}
		function ChkHandFee(){
			if(jtrim(document.all.oriHandFee.value).length>=1 && jtrim(document.all.t_handFee.value).length>=1){
				if(parseFloat(document.all.oriHandFee.value)<parseFloat(document.all.t_handFee.value)){
					rdShowMessageDialog("实收手续费不能大于原始手续费！");
					document.all.t_handFee.value=document.all.oriHandFee.value;
					document.all.t_handFee.select();
					document.all.t_handFee.focus();
					return;
				}
			}
			
			if(jtrim(document.all.oriHandFee.value).length>=1 && jtrim(document.all.t_handFee.value).length==0){
				document.all.t_handFee.value="0";
			}
		 }
		 function getFew(){
				var fee=document.all.t_handFee;
				var fact=document.all.t_factFee;
				var few=document.all.t_fewFee;
				if(jtrim(fact.value).length==0){
					rdShowMessageDialog("实收金额不能为空！");
					fact.value="";
					fact.focus();
					return;
				}
				if(parseFloat(fact.value)<parseFloat(fee.value)){
					rdShowMessageDialog("实收金额不足！");
					fact.value="";
					fact.focus();
					return;
				}
				
				var tem1=((parseFloat(fact.value)-parseFloat(fee.value))*100+0.5).toString();
				var tem2=tem1;
				if(tem1.indexOf(".")!=-1) tem2=tem1.substring(0,tem1.indexOf("."));
				few.value=(tem2/100).toString();
				few.focus();
		 }
		 function printCommit(){


	/*
	 *  1、修改所有涉及经办人、责任人和实际使用人的界面，请系统增加限制，当单位证件类型时，
	 *  经办人与实际使用人的证件号码不可以相同，经办人与责任人的证件号码不可以相同。
	 */
 
	var idTypeSelect_isC = $("#idTypeSelect option[@selected]").val();//证件类型 
	//alert("idTypeSelect_isC=["+idTypeSelect_isC+"]");
	if(idTypeSelect_isC.indexOf("C")!=-1){
		//alert("单位证件类型");
		//单位证件类型
		if($("#gestoresIccId").val().trim()!=""&&$("#responsibleIccId").val().trim()!=""){
			if($("#gestoresIccId").val().trim()==$("#responsibleIccId").val().trim()){
				rdShowMessageDialog("经办人的证件号码与责任人的证件号码不可以相同!",0);
				return;
			}
		}
		
		if($("#gestoresIccId").val().trim()!=""&&$("#realUserIccId").val().trim()!=""){
			if($("#gestoresIccId").val().trim()==$("#realUserIccId").val().trim()){
				rdShowMessageDialog("经办人的证件号码与使用人的证件号码不可以相同!",0);
				return;
			}  		
		}
	}    	
	
		 	
		 			var checkVal = document.all.isJSX.value;//个人开户分类 普通客户：0
					var idTypeSelect = $("#idTypeSelect option[@selected]").val();//证件类型：身份证
					if(idTypeSelect.indexOf("|") != -1){
						var v_idTypeSelect = idTypeSelect.split("|")[0];
						
						if(checkVal == "0" && v_idTypeSelect == "0" && "<%=workChnFlag%>" == "1" && "<%=regionCodeFlag%>" == "Y"){ 
							if("<%=appregionflag%>"=="0") {//如果不在app配置表里则只能进行工单查询。
								if(($("#isQryListResultFlag").val() == "N") && (parseInt($("#sendListOpenFlag").val()) > 0)){ //已查询工单列表，并下发工单开关为开，则进行校验
									rdShowMessageDialog("请先进行工单结果查询，再进行过户!");
							    return false;		
								}
							}
						}
					}
		 	
		 		/*2016/2/29 14:26:25 gaopeng 重新校验*/
    		/*客户名称*/
    		if(!checkCustNameFunc16New(document.all.custName,0,1)){
    			return false;
    		}
    		/*联系人姓名*/
    		if(!checkCustNameFunc(document.all.contactPerson,1,1)){
					return false;
				}
				/*证件地址*/
				if(!checkAddrFunc(document.all.idAddr,0,1)){
					return false;
				}
				/*客户地址*/
				if(!checkAddrFunc(document.all.custAddr,1,1)){
					return false;
				}
				/*联系人地址*/
				if(!checkAddrFunc(document.all.contactAddr,2,1)){
					return false;
				}
				/*联系人通讯地址*/
				if(!checkAddrFunc(document.all.contactMAddr,3,1)){
					return false;
				}
				/*证件号码*/
				if(!checkIccIdFunc16New(document.all.idIccid,0,1)){
					return false;
				}
				else{
					rpc_chkX('idType','idIccid','A');
				}
				
				/*gaopeng 20131216 2013/12/16 19:50:11 关于在BOSS入网界面增加单位客户经办人信息的函 加入经办人信息确认服务前校验 start*/
					if(!checkElement(document.all.gestoresName)){
						return false;
					}
					if(!checkElement(document.all.gestoresAddr)){
						return false;
					}
					if(!checkElement(document.all.gestoresIccId)){
						return false;
					}
					/*经办人姓名*/
					if(!checkCustNameFunc16New(document.all.gestoresName,1,1)){
						return false;
					}
					/*经办人联系地址*/
					if(!checkAddrFunc(document.all.gestoresAddr,4,1)){
						return false;
					}
					/*经办人证件号码*/
					if(!checkIccIdFunc16New(document.all.gestoresIccId,1,1)){
						return false;
					}
					else{
						rpc_chkX('idType','idIccid','A');
					}
					/*责任人姓名*/
				if(!checkElement(document.all.responsibleName)){
					return false;
				}
				/*责任人联系地址*/
				if(!checkElement(document.all.responsibleAddr)){
					return false;
				}
				/*责任人证件号码*/
				if(!checkElement(document.all.responsibleIccId)){
					return false;
				}
				
				if(!checkCustNameFunc16New(document.all.responsibleName,2,1)){
					return false;
				}
			
				if(!checkAddrFunc(document.all.responsibleAddr,5,1)){
							return false;
				}
			
				if(!checkIccIdFunc16New(document.all.responsibleIccId,2,1)){
									return false;
				}
				else{
					rpc_chkX('idType','idIccid','A');
				}
				
					/*实际使用人姓名*/
					if(!checkElement(document.all.realUserName)){
						return false;
					}
					/*实际使用人联系地址*/
					if(!checkElement(document.all.realUserAddr)){
						return false;
					}
					/*实际使用人证件号码*/
					if(!checkElement(document.all.realUserIccId)){
						return false;
					}
			  if(!checkCustNameFunc16New(document.all.realUserName,3,1)){
					return false;
				}
			
				if(!checkAddrFuncNew(document.all.realUserAddr,5,1)){
							return false;
					}
			
				if(!checkIccIdFunc16New(document.all.realUserIccId,3,1)){
									return false;
				}
				else{
					rpc_chkX('idType','idIccid','A');
				}
				
		 	getAfterPrompt();
			showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes");
		 }
		 function showPrtDlg(printType,DlgMessage,submitCfm){
			//----------------------add by huy 20050722
			if(jtrim(document.all.xinYiDu.value).length==0){
				rdShowMessageDialog(document.all.xinYiDu.v_name+"不能为空！");
				document.all.xinYiDu.focus();
				return false;
			}
				if(jtrim(document.all.custPwd.value).length==0){
					/*rdShowMessageDialog(document.all.custPwd.v_name+"不能为空！");
					document.all.custPwd.focus();
					return false;*/
				}else{
					if(jtrim(document.all.custPwd.value).length!=6){
						rdShowMessageDialog(document.all.custPwd.v_name+"长度有误！");
						document.all.custPwd.focus();
						return false;
					}
				}
				if(jtrim(document.all.newContactPerson.value).length==0){
					rdShowMessageDialog(document.all.newContactPerson.v_name+"不能为空！");
					document.all.newContactPerson.focus();
					return false;
				}				
				if(jtrim(document.all.newContactPhone.value).length==0){
					rdShowMessageDialog(document.all.newContactPhone.v_name+"不能为空！");
					document.all.newContactPhone.focus();
					return false;
				}else {
					/*联系电话：数字*/
					var newContactPhoness = document.all.newContactPhone.value;
					if(newContactPhoness != ""){
						m = /^[0-9]+$/;
						var flag = m.test(newContactPhoness);
						if(!flag){
							rdShowMessageDialog("联系人电话只允许输入数字");
							return false;
						}
					}
				}
				
				
				change_idType();   //判断客户证件类型是否是身份证
				if(jtrim(document.all.contactMail.value) == ""){
					document.all.contactMail.value = "";
				}
				//判断生日、证件有效期有效性	birthDay	idValidDate
				if((typeof(document.all.birthDay)!="undefined") &&
					(document.all.birthDay.value != "")){
					if(forDate(document.all.birthDay) == false){	
						return false;
					}
				}else if((typeof(document.all.yzrq)!="undefined")&&
							(document.all.yzrq.value != "")){
					if(forDate(document.all.yzrq) == false){	return false;		}
				}
				
				var d= (new Date().getFullYear().toString()+(((new Date().getMonth()+1).toString().length>=2)?(new Date().getMonth()+1).toString():("0"+(new Date().getMonth()+1)))+(((new Date().getDate()).toString().length>=2)?(new Date().getDate()):("0"+(new Date().getDate()))).toString());
				
				if(jtrim(document.all.idValidDate.value).length>0){
					if(forDate(document.all.idValidDate)==false) return false;
					if(to_date(document.all.idValidDate)<=d){
						rdShowMessageDialog("证件有效期不能早于当前时间，请重新输入！");
						document.all.idValidDate.focus();
						document.all.idValidDate.select();
						return false;
					}
				}
				
				if(jtrim(document.all.birthDay.value).length>0){
					if(to_date(document.all.birthDay)>=d){
						rdShowMessageDialog("出生日期期不能晚于当前时间，请重新输入！");
						document.all.birthDay.focus();
						document.all.birthDay.select();
						return false;
					}
				}
			if((document.all.but_flag.value =="1")&&document.all.upbut_flag.value=="0"){//二代证
				rdShowMessageDialog("请先上传身份证照片",0);
				return false;
			}
			
			var upflag =document.all.up_flag.value;//二代证
			if(upflag==3&&(document.all.but_flag.value =="1")){
				rdShowMessageDialog("请选择jpg类型图像文件");
				return false;
			}
			if(upflag==4&&(document.all.but_flag.value =="1")){
				rdShowMessageDialog("请先扫描或读取证件信息");
				return false;
			}
			
			
			if(upflag==5&&(document.all.but_flag.value =="1")){
				rdShowMessageDialog("请选择最后一次扫描或读取证件而生成的证件图像文件"+document.all.pic_name.value);
				return false;
			}
			
			if((document.all.but_flag.value =="1")&&document.all.upbut_flag.value=="0"){//二代证
				rdShowMessageDialog("请先上传身份证照片",0);
				return false;
			}
			//20091201 begin
			var da_te= (new Date().getFullYear().toString()+(((new Date().getMonth()+1).toString().length>=2)?(new Date().getMonth()+1).toString():("0"+(new Date().getMonth()+1)))+(((new Date().getDate()).toString().length>=2)?(new Date().getDate()):("0"+(new Date().getDate()))).toString());
			if(document.all.GoodPhoneFlag.value == "Y"){
				if((document.all.GoodPhoneDate.value).trim().length != 8){
					rdShowMessageDialog("请按正确格式输入过户时间");
					document.frm1104.GoodPhoneDate.focus();
					return false;
				}
				if(to_date(document.all.GoodPhoneDate) < da_te){
					rdShowMessageDialog("过户限制时间小于当前系统时间，请重新输入！");
					document.all.GoodPhoneDate.focus();
					return false;
				}
			}
			//20091201 end
			
					/*
					if(!checkElement(document.all.anzhcontact_name)){
						return false;
					}
					if(!checkElement(document.all.anzhcontact_phoneno)){
						return false;
					}*/
			
			//-------------------------------------------
			//if(check(frm))
			{
				if("09" != "<%=regionCode%>"){
					if(checkPwd(document.all.custPwd,document.all.cfmPwd)==false) return false;
					chkPwdEasy(document.all.custPwd.value);
				} else {
					continueCfm();
				}
			}
		}
		function printInfo(printType){
			
 		  var retInfo = "";

 		  var cust_info="";
	    var opr_info="";
	    var note_info1="";
	    var note_info2="";
	    var note_info3="";
	    var note_info4="";

 		  cust_info+="客户姓名：   " +document.all.cust_name.value+"|";
      cust_info+="IMS固话帐号：   "+"<%=broadPhone%>"+"|";
      cust_info+="客户地址：   "+document.all.cust_addr.value+"|";
      cust_info+="证件号码：   "+document.all.ic_no.value+"|";

 		  opr_info+="办理业务名称："+"IMG固话过户"+"|";
		  /* 
	     * 关于协助开发省广电合作IMS固话话费营销案和融合套餐需求的函（单品部分）@2014/7/24 
	     * 新增省广电kg，备用品牌kh
	     */
 		  if("<%=sNewSmName%>" == "kf" || "<%=sNewSmName%>" == "kg" || "<%=sNewSmName%>" == "kh"){
 		  	opr_info+="业务生效时间: 立即生效"+"|";
 			}

		  opr_info+="操作流水："+document.all.loginAccept.value+"|";



		  opr_info+="IMS固话帐号"+"<%=broadPhone%>"+"由用户"+"<%=(String)custDoc.get(5)%>"+"过户到用户"+document.all.custName.value+"|";
		  opr_info+="新客户资料：客户名称："+document.all.custName.value+"*"+"证件号码："+document.all.idIccid.value+"|";
		  opr_info+="客户地址："+document.all.idAddr.value+"|";
		  
		  opr_info+=" "+"|";
		  opr_info+="当前主资费："+"<%=main_str1%>"+"|";
		  opr_info+="联系人姓名："+$("#newContactPerson").val()+"|";
		  opr_info+="联系电话："+$("#newContactPhone").val()+"|";
			/* 
	     * 关于协助开发省广电合作IMS固话话费营销案和融合套餐需求的函（单品部分）@2014/7/24 
	     * 新增省广电kg，备用品牌kh
	     */
			if("<%=sNewSmName%>" == "kf" || "<%=sNewSmName%>" == "kg" || "<%=sNewSmName%>" == "kh"){
				note_info1 += "备注："+"|";
				note_info1 += "1、当联系电话变动时，请及时与移动公司联系，以便于有新活动或服务到期时及时收到通知。"+"|";
				note_info1 += "2、如需帮助，请拨打服务热线：10086"+"|";
			}


		  //#23->#
			//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
			retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
			retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
		  return retInfo;
	 }
		function checkPwd(obj1,obj2){
			//密码一致性校验,明码校验
			var pwd1 = obj1.value;
			var pwd2 = obj2.value;
			if(pwd1 != pwd2){
				var message = "两次输入的密码不一致，请重新输入！";
				rdShowMessageDialog(message);
				if(obj1.type != "hidden"){   obj1.value = "";    }
				if(obj2.type != "hidden"){   obj2.value = "";    }
				obj1.focus();
				return false;
			}
			return true;
		}
		function chkPwdEasy(pwd){
			if(pwd == ""){
				rdShowMessageDialog("请先输入密码！");
				return ;
			}
			var checkPwd_Packet = new AJAXPacket("../public/pubCheckPwdEasy.jsp","正在验证密码是否过于简单，请稍候......");
			checkPwd_Packet.data.add("password", pwd);
			checkPwd_Packet.data.add("phoneNo", "<%=phoneNo%>");
			checkPwd_Packet.data.add("idNo", frm.idIccid.value);
			checkPwd_Packet.data.add("opCode", "m466");
			checkPwd_Packet.data.add("custId", "");
		
			core.ajax.sendPacket(checkPwd_Packet, doCheckPwdEasy);
			checkPwd_Packet=null;
		}
		
		
		
		function doCheckPwdEasy(packet) {
			var retResult = packet.data.findValueByName("retResult");
			if (retResult == "1") {
				rdShowMessageDialog("尊敬的客户，您本次设置的密码为相同数字类密码，安全性较低，为了更好地保护您的信息安全，请您设置安全性更高的密码。");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "2") {
				rdShowMessageDialog("尊敬的客户，您本次设置的密码为连号类密码，安全性较低，为了更好地保护您的信息安全，请您设置安全性更高的密码。");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "3") {
				rdShowMessageDialog("尊敬的客户，您本次设置的密码为手机号码中的连续数字，安全性较低，为了更好地保护您的信息安全，请您设置安全性更高的密码。");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "4") {
				rdShowMessageDialog("尊敬的客户，您本次设置的密码为证件中的连续数字，安全性较低，为了更好地保护您的信息安全，请您设置安全性更高的密码。");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "0") {
				//rdShowMessageDialog("校验成功！密码可用！");
				continueCfm();
			}
		}
		function continueCfm(){
			document.all.t_sys_remark.value="用户"+jtrim(document.all.cust_name.value)+"IMG固话过户到"+document.all.custName.value;
			
			if(jtrim(document.all.t_op_remark.value).length==0){
				document.all.t_op_remark.value="操作员<%=workNo%>"+"对用户手机"+jtrim(document.all.srv_no.value)+"进行IMG固话过户"
			}
			if(jtrim(document.all.assuNote.value).length==0){
				document.all.assuNote.value="操作员<%=workNo%>"+"对用户手机"+jtrim(document.all.srv_no.value)+"进行IMG固话过户"
			}
			
			//显示打印对话框
			var h=210;
			var w=400;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			var pType="subprint";
			var billType="1";
			
			var mode_code=null;
			var fav_code=null;
			var area_code=null
			
			var sysAccept = document.all.loginAccept.value;
			
			var printStr = printInfo("Detail");
			var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no;	scrollbars:yes; resizable:no;location:no;status:no;help:no"
			/* ningtn */
			var iccidInfoStr = $("#firstId").val() + "|" + $("#secondId").val();	
			var accInfoStr = $("#accInfoHid1").val() + "|" +$("#accInfoHid2").val()+ "|" +$("#accInfoHid3").val()+ "|" +$("#accInfoHid4").val();
			/* ningtn */
			var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_hw.jsp?DlgMsg=" + "确实要进行电子免填单打印吗？"+ "&iccidInfo=" + iccidInfoStr + "&accInfoStr="+accInfoStr;
			var path = path  + "&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+sysAccept+"&phoneNo=<%=phoneNo%>&loginacceptJT="+$("#loginacceptJT").val()+"&submitCfm=" + "Yes"+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
			
			var ret=window.showModalDialog(path,printStr,prop);
			
			if(typeof(ret)!="undefined"){
				if((ret=="confirm")){
					if(rdShowConfirmDialog('确认电子免填单吗？')==1){
						conf();
					}
				}
				if(ret=="continueSub"){
					if(rdShowConfirmDialog('确认要提交IMG固话过户信息吗？')==1){
						conf();
					}
				}
			}else{
				if(rdShowConfirmDialog('确认要提交IMG固话过户信息吗？')==1){
					conf();
				}
			}
		}
		function conf(){
			frm.target="_self";
			
			if($("#gestoresInfo1").css("display")=="none"){
				frm.action="fm466Cfm.jsp";
	        }
	        else{
	        	frm.action="fm466Cfm.jsp?xsjbrxx=1";
	        }
			frm.submit();
		}
		
		
			/*2013/11/07 21:14:36 gaopeng 关于实名制工作需求整合的函*/
		function getIdTypes(){
			 var checkVal = $("select[name='isJSX']").find("option:selected").val();
			 //alert(checkVal);
		   var getdataPacket = new AJAXPacket("/npage/sq100/fq100GetIdTypes.jsp","正在获得数据，请稍候......");
					getdataPacket.data.add("checkVal",checkVal);
					getdataPacket.data.add("opCode","e972");
					getdataPacket.data.add("opName","<%=opName%>");
					core.ajax.sendPacketHtml(getdataPacket,resIdTypes);
					getdataPacket = null;
			
		}
		function resIdTypes(data){
						//alert(data);
					//找到添加的select
						var markDiv=$("#tdappendSome"); 
						//清空原有表格
						markDiv.empty();
						markDiv.append(data);
						change_idType();
						setRealUserFormat();
		 
		}
		
		
		function setRealUserFormat(){
  	
		if(document.all.isJSX.value=="1"){ //单位客户
			$("#realUserInfo1").show();
			$("#realUserInfo2").show();
			/*实际使用人姓名*/
	  	document.all.realUserName.v_must = "1";
	  	/*经实际使用人地址*/
	  	document.all.realUserAddr.v_must = "1";
	  	/*实际使用人证件号码*/
	  	document.all.realUserIccId.v_must = "1";
		}else{
			$("#realUserInfo1").hide();
			$("#realUserInfo2").hide();
			/*实际使用人姓名*/
	  	document.all.realUserName.v_must = "0";
	  	/*经实际使用人地址*/
	  	document.all.realUserAddr.v_must = "0";
	  	/*实际使用人证件号码*/
	  	document.all.realUserIccId.v_must = "0";
		}
  	
		$("#realUserInfo1").find("td:eq(0)").attr("width","13%");
  	$("#realUserInfo1").find("td:eq(0)").attr("nowrap","nowrap");
  	$("#realUserInfo1").find("td:eq(1)").attr("nowrap","nowrap");
  	$("#realUserInfo1").find("td:eq(2)").attr("width","13%");
  	$("#realUserInfo1").find("td:eq(2)").attr("nowrap","nowrap");
  	$("#realUserInfo1").find("td:eq(3)").attr("nowrap","nowrap");
  	$("#realUserInfo1").find("td:eq(3)").attr("colSpan","3");
  	
  	$("#realUserInfo2").find("td:eq(0)").attr("width","13%");
  	$("#realUserInfo2").find("td:eq(0)").attr("nowrap","nowrap");
  	$("#realUserInfo2").find("td:eq(1)").attr("nowrap","nowrap");
  	$("#realUserInfo2").find("td:eq(2)").attr("width","13%");
  	$("#realUserInfo2").find("td:eq(2)").attr("nowrap","nowrap");
  	$("#realUserInfo2").find("td:eq(3)").attr("nowrap","nowrap");
  	$("#realUserInfo2").find("td:eq(3)").attr("colSpan","3");
  	
  	//给实际使用人赋值
		$("#realUserName").val("<%=qRealUserName%>");
		$("#realUserIccId").val("<%=qRealUserIccId%>");
		$("#realUserAddr").val("<%=qRealUserAddr%>");
		if("<%=qRealUserIdType%>" != ""){
			$("#realUserIdType option").each(function(){
		    if($(this).val().indexOf("<%=qRealUserIdType%>") != -1){
		      $(this).attr("selected","true");
		    }
		  });
		}
		if("<%=qRealUserIdType%>" == "0" || "<%=qRealUserIdType%>" == ""){ //身份证，则显示读卡按钮
			$("#scan_idCard_two2").css("display","");
			$("#scan_idCard_two22").css("display","");
			$("input[name='realUserName']").attr("class","InputGrey");
			$("input[name='realUserName']").attr("readonly","readonly");
			$("input[name='realUserAddr']").attr("class","InputGrey");
			$("input[name='realUserAddr']").attr("readonly","readonly");
			$("input[name='realUserIccId']").attr("class","InputGrey");
			$("input[name='realUserIccId']").attr("readonly","readonly");
			
		}else{
			$("#scan_idCard_two2").css("display","none");
			$("#scan_idCard_two22").css("display","none");
			$("input[name='realUserName']").removeAttr("class");
			$("input[name='realUserName']").removeAttr("readonly");
			$("input[name='realUserAddr']").removeAttr("class");
			$("input[name='realUserAddr']").removeAttr("readonly");
			$("input[name='realUserIccId']").removeAttr("class");
			$("input[name='realUserIccId']").removeAttr("readonly");
		}	
	}
		
		
		/*2013/12/16 15:41:14 gaopeng 经办人证件类型下拉表单改变函数*/
function validateGesIdTypes(idtypeVal){
	
		if(idtypeVal.indexOf("身份证") != -1){
  		document.all.gestoresIccId.v_type = "idcard";
  		$("#scan_idCard_two3").css("display","");
  		$("#scan_idCard_two31").css("display","");
  		$("input[name='gestoresName']").attr("class","InputGrey");
  		$("input[name='gestoresName']").attr("readonly","readonly");
  		$("input[name='gestoresAddr']").attr("class","InputGrey");
  		$("input[name='gestoresAddr']").attr("readonly","readonly");
  		$("input[name='gestoresIccId']").attr("class","InputGrey");
  		$("input[name='gestoresIccId']").attr("readonly","readonly");
  		$("input[name='gestoresName']").val("");
  		$("input[name='gestoresAddr']").val("");
  		$("input[name='gestoresIccId']").val("");
  	}else{
  		document.all.gestoresIccId.v_type = "string";
  		$("#scan_idCard_two3").css("display","none");
  		$("#scan_idCard_two31").css("display","none");
  		$("input[name='gestoresName']").removeAttr("class");
  		$("input[name='gestoresName']").removeAttr("readonly");
  		$("input[name='gestoresAddr']").removeAttr("class");
  		$("input[name='gestoresAddr']").removeAttr("readonly");
  		$("input[name='gestoresIccId']").removeAttr("class");
  		$("input[name='gestoresIccId']").removeAttr("readonly");
  	}
}

function validateresponIdTypes(idtypeVal){
		if(idtypeVal.indexOf("身份证") != -1){
  		document.all.responsibleIccId.v_type = "idcard";
  			$("#scan_idCard_two3zrr").css("display","");
  			$("#scan_idCard_two57zrr").css("display","");
	  		$("input[name='responsibleName']").attr("class","InputGrey");
	  		$("input[name='responsibleName']").attr("readonly","readonly");
	  		$("input[name='responsibleAddr']").attr("class","InputGrey");
	  		$("input[name='responsibleAddr']").attr("readonly","readonly");
	  		$("input[name='responsibleIccId']").attr("class","InputGrey");
	  		$("input[name='responsibleIccId']").attr("readonly","readonly");
	  		$("input[name='responsibleName']").val("");
	  		$("input[name='responsibleAddr']").val("");
	  		$("input[name='responsibleIccId']").val("");
  		
  	}else{
  		document.all.responsibleIccId.v_type = "string";
  			$("#scan_idCard_two3zrr").css("display","none");
  			$("#scan_idCard_two57zrr").css("display","none");
	  		$("input[name='responsibleName']").removeAttr("class");
	  		$("input[name='responsibleName']").removeAttr("readonly");
	  		$("input[name='responsibleAddr']").removeAttr("class");
	  		$("input[name='responsibleAddr']").removeAttr("readonly");
	  		$("input[name='responsibleIccId']").removeAttr("class");
	  		$("input[name='responsibleIccId']").removeAttr("readonly");
  		
  	}
}

//实际使用人证件类型改变
			function valiRealUserIdTypes(idtypeVal){
				if(idtypeVal == "0"){ //身份证
					document.all.realUserIccId.v_type = "idcard";
					$("#scan_idCard_two2").css("display","");
					$("#scan_idCard_two22").css("display","");
					$("input[name='realUserName']").attr("class","InputGrey");
					$("input[name='realUserName']").attr("readonly","readonly");
					$("input[name='realUserAddr']").attr("class","InputGrey");
					$("input[name='realUserAddr']").attr("readonly","readonly");
					$("input[name='realUserIccId']").attr("class","InputGrey");
					$("input[name='realUserIccId']").attr("readonly","readonly");
					$("input[name='realUserName']").val("");
					$("input[name='realUserAddr']").val("");
					$("input[name='realUserIccId']").val("");
				}else{
					document.all.realUserIccId.v_type = "string";
					$("#scan_idCard_two2").css("display","none");
					$("#scan_idCard_two22").css("display","none");
					$("input[name='realUserName']").removeAttr("class");
					$("input[name='realUserName']").removeAttr("readonly");
					$("input[name='realUserAddr']").removeAttr("class");
					$("input[name='realUserAddr']").removeAttr("readonly");
					$("input[name='realUserIccId']").removeAttr("class");
					$("input[name='realUserIccId']").removeAttr("readonly");
				}
				if($("#realUserIdType").val() == "<%=qRealUserIdType%>"){ //选择初始证件类型，则还原初始证件信息
					$("#realUserName").val("<%=qRealUserName%>");
					$("#realUserAddr").val("<%=qRealUserAddr%>");
					$("#realUserIccId").val("<%=qRealUserIccId%>");
				}else{
					$("input[name='realUserName']").val("");
					$("input[name='realUserAddr']").val("");
					$("input[name='realUserIccId']").val("");
				}
			}
			
			
			/*1、客户名称、联系人姓名 校验方法 objType 0 代表客户名称校验 1代表联系人姓名校验  ifConnect 代表是否联动赋值(点击确认按钮时，不进行联动赋值)*/
function checkCustNameFunc(obj,objType,ifConnect){
	var nextFlag = true;
	var objName = "";
	var idTypeVal ="";
		
	if(objType == 0){
		objName = "客户名称";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "联系人姓名";
		idTypeVal = document.all.idType.value;
	}
	/*2013/12/16 11:24:47 gaopeng 关于在BOSS入网界面增加单位客户经办人信息的函 加入经办人姓名*/
	if(objType == 2){
		objName = "经办人姓名";
		/*规则按照经办人证件类型*/
		idTypeVal = document.all.gestoresIdType.value;
	}
	
	if(objType == 3){
		objName = "责任人姓名";
		/*规则按照经办人证件类型*/
		idTypeVal = document.all.responsibleType.value;
	}
	
	idTypeVal = $.trim(idTypeVal);
	/*只针对个人客户*/
	var opCode = "<%=opCode%>";
	/*获取输入框的值*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*获取输入的值的长度*/
	var objValueLength = objValue.length;
	if(objValue != ""){
		/* 获取所选择的证件类型 
		0|身份证 1|军官证 2|户口簿 3|港澳通行证 
		4|警官证 5|台湾通行证 6|外国公民护照 7|其它 
		8|营业执照 9|护照 A|组织机构代码 B|单位法人证书 C|介绍信 
		*/
		
		/*获取证件类型主键 */
		var idTypeText = idTypeVal.split("|")[0];
		
		/*有临时、代办字样的都不行*/
		if(objValue.indexOf("临时") != -1 || objValue.indexOf("代办") != -1){
					rdShowMessageDialog(objName+"不能带有‘临时’或‘代办’字样！");
					
					nextFlag = false;
					return false;
			
		}
		
		/*客户名称、联系人姓名均要求“大于等于2个中文汉字”，外国公民护照除外（外国公民护照客户名称必须大于3个字符，不全为阿拉伯数字)*/
		
		/*如果不是外国公民护照*/
		if(idTypeText != "6"){
			/*原有的业务逻辑校验 只允许是英文、汉字、俄文、法文、日文、韩文其中一种语言！*/
			if(idTypeText == "3" || idTypeText == "9" || idTypeText == "8" || idTypeText == "A" || idTypeText == "B" || idTypeText == "C"){
				if(objValueLength < 2){
					rdShowMessageDialog(objName+"必须大于等于2个汉字！");
					nextFlag = false;
					return false;
				}
				var KH_length = 0;
		     var EH_length = 0;
		     var RU_length = 0;
		     var FH_length = 0;
		     var JP_length = 0;
		     var KR_length = 0;
		     var CH_length = 0;
         
         for (var i = 0; i < objValue.length; i ++){
            var code = objValue.charAt(i);//分别获取输入内容
            var key = checkNameStr(code); //校验
            if(key == undefined){
              rdShowMessageDialog(objName+"只允许是英文、汉字、俄文、法文、日文、韩文或其与‘括号’组合其中一种语言！请重新输入！");
              obj.value = "";
              
              nextFlag = false;
              return false;
            }
            if(key == "KH"){
            	KH_length++;
            }
            if(key == "EH"){
            	EH_length++;
            }
            if(key == "RU"){
            	RU_length++;
            }
            if(key == "FH"){
            	FH_length++;
            }
            if(key == "JP"){
            	JP_length++;
            }
            if(key == "KR"){
            	KR_length++;
            }
            if(key == "CH"){
            	CH_length++;
            }
         
         }	
            var machEH = KH_length + EH_length;
            var machRU = KH_length + RU_length;
            var machFH = KH_length + FH_length;
            var machJP = KH_length + JP_length;
            var machKR = KH_length + KR_length;
            var machCH = KH_length + CH_length;
            
            
            if((objValueLength != machEH 
            && objValueLength != machRU
            && objValueLength != machFH
            && objValueLength != machJP
            && objValueLength != machKR
            && objValueLength != machCH ) || objValueLength == KH_length){
            		rdShowMessageDialog(objName+"只允许是英文、汉字、俄文、法文、日文、韩文或其与‘括号’组合其中一种语言！请重新输入！");
                obj.value = "";
              	nextFlag = false;
                return false;
            }	
       }
       else{
					/*获取含有中文汉字的个数以及'()（）'的个数*/
					var m = /^[\u0391-\uFFE5]*$/;
					var mm = /^·|\.|\．*$/;
					var chinaLength = 0;
					var kuohaoLength = 0;
					var zhongjiandianLength=0;
					for (var i = 0; i < objValue.length; i ++){
			          var code = objValue.charAt(i);//分别获取输入内容
			          var flag22=mm.test(code);
			          var flag = m.test(code);
			          /*先校验括号*/
			          if(forKuoHao(code)){
			          	kuohaoLength ++;
			          }else if(flag){
			          	chinaLength ++;
			          }else if(flag22){
			          	zhongjiandianLength++;
			          }
			    }
			    var machLength = chinaLength + kuohaoLength+zhongjiandianLength;
					/*括号的数量+汉字的数量 != 总数量时 提示错误信息(这里需要注意一点，中文括号也是中文。。。所以这里只进行英文括号的匹配个数，否则会匹配多个)*/
					if(objValueLength != machLength || chinaLength == 0){
						rdShowMessageDialog(objName+"必须输入中文或中文与括号的组合(括号可以为中文或英文括号“()（）”)！");
						/*赋值为空*/
						obj.value = "";
						
						nextFlag = false;
						return false;
					}else if(objValueLength == machLength && chinaLength != 0){
						if(objValueLength < 2){
							rdShowMessageDialog(objName+"必须大于等于2个中文汉字！");
							
							nextFlag = false;
							return false;
						}
					}
					/*原有逻辑
					if(idTypeText == "0" || idTypeText == "2"){
						if(objValueLength > 6){
							rdShowMessageDialog(objName+"最多输入6个汉字！");
							
							nextFlag = false;
							return false;
						}
				}
				*/
			}
       
		}
		/*如果是外国公民护照 校验 外国公民护照客户名称(后续添加了联系人姓名也同理(sunaj已确定))必须大于3个字符，不全为阿拉伯数字*/
		if(idTypeText == "6"){
			/*如果校验客户名称*/
				if(objValue % 2 == 0 || objValue % 2 == 1){
						rdShowMessageDialog(objName+"不能全为阿拉伯数字!");
						/*赋值为空*/
						obj.value = "";
						
						nextFlag = false;
						return false;
				}
				if(objValueLength <= 3){
						rdShowMessageDialog(objName+"必须大于三个字符!");
						
						nextFlag = false;
						return false;
				}
         var KH_length = 0;
		     var EH_length = 0;
		     var RU_length = 0;
		     var FH_length = 0;
		     var JP_length = 0;
		     var KR_length = 0;
		     var CH_length = 0;
         
         for (var i = 0; i < objValue.length; i ++){
            var code = objValue.charAt(i);//分别获取输入内容
            var key = checkNameStr(code); //校验
            if(key == undefined){
              rdShowMessageDialog(objName+"只允许是英文、汉字、俄文、法文、日文、韩文或其与‘括号’组合其中一种语言！请重新输入！");
              obj.value = "";
              
              nextFlag = false;
              return false;
            }
            if(key == "KH"){
            	KH_length++;
            }
            if(key == "EH"){
            	EH_length++;
            }
            if(key == "RU"){
            	RU_length++;
            }
            if(key == "FH"){
            	FH_length++;
            }
            if(key == "JP"){
            	JP_length++;
            }
            if(key == "KR"){
            	KR_length++;
            }
            if(key == "CH"){
            	CH_length++;
            }
         
         }	
            var machEH = KH_length + EH_length;
            var machRU = KH_length + RU_length;
            var machFH = KH_length + FH_length;
            var machJP = KH_length + JP_length;
            var machKR = KH_length + KR_length;
            var machCH = KH_length + CH_length;
            
            
            if((objValueLength != machEH 
            && objValueLength != machRU
            && objValueLength != machFH
            && objValueLength != machJP
            && objValueLength != machKR
            && objValueLength != machCH ) || objValueLength == KH_length){
            		rdShowMessageDialog(objName+"只允许是英文、汉字、俄文、法文、日文、韩文或其与‘括号’组合其中一种语言！请重新输入！");
                obj.value = "";
              	nextFlag = false;
                return false;
            }
		}
		
		
		if(ifConnect == 0){
		
		if(nextFlag){
		 if(objType == 0){
		 	/*联系人姓名随客户名称改名而改变*/
			document.all.contactPerson.value = objValue;
			 
		 	}	
		}
			}
		
	}	
	return nextFlag;
}



/*
	2013/11/18 11:15:44
	gaopeng
	客户地址、证件地址、联系人地址校验方法
	“客户地址”、“证件地址”和“联系人地址”均需“大于等于8个中文汉字”
	（外国公民护照和台湾通行证除外，外国公民护照要求大于2个汉字，台湾通行证要求大于3个汉字）
*/

function checkAddrFunc(obj,objType,ifConnect){
	var nextFlag = true;
	var objName = "";
	var idTypeVal = "";
	if(objType == 0){
		objName = "证件地址";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "客户地址";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 2){
		objName = "联系人地址";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 3){
		objName = "联系人通讯地址";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 4){
		objName = "经办人联系地址";
		idTypeVal = document.all.gestoresIdType.value;
	}
	if(objType == 5){
		objName = "责任人联系地址";
		idTypeVal = document.all.responsibleType.value;
	}
	idTypeVal = $.trim(idTypeVal);
	/*只针对个人客户*/
	var opCode = "<%=opCode%>";
	/*获取输入框的值*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*获取输入的值的长度*/
	var objValueLength = objValue.length;
	
	if(objValue != ""){
		/* 获取所选择的证件类型 
		0|身份证 1|军官证 2|户口簿 3|港澳通行证 
		4|警官证 5|台湾通行证 6|外国公民护照 7|其它 
		8|营业执照 9|护照 A|组织机构代码 B|单位法人证书 C|介绍信 
		*/
		
		/*获取证件类型主键 */
		var idTypeText = idTypeVal.split("|")[0];
		
		/*获取含有中文汉字的个数*/
		var m = /^[\u0391-\uFFE5]*$/;
		var chinaLength = 0;
		for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//分别获取输入内容
          var flag = m.test(code);
          if(flag){
          	chinaLength ++;
          }
    }
      
		/*如果既不是外国公民护照 也不是台湾通行证 */
		if(idTypeText != "6" && idTypeText != "5"){
			/*含有至少8个中文汉字*/
			if(chinaLength < 8){
				rdShowMessageDialog(objName+"必须含有至少8个中文汉字！");
				/*赋值为空*/
				obj.value = "";
				
				nextFlag = false;
				return false;
			}
		
	}
	/*外国公民护照 大于2个汉字*/
	if(idTypeText == "6"){
		/*大于2个中文汉字*/
			if(chinaLength <= 2){
				rdShowMessageDialog(objName+"必须含有大于2个中文汉字！");
				
				nextFlag = false;
				return false;
			}
	}
	/*台湾通行证 大于3个汉字*/
	if(idTypeText == "5"){
		/*含有至少3个文汉字*/
			if(chinaLength <= 3){
				rdShowMessageDialog(objName+"必须含有大于3个中文汉字！");
				
				nextFlag = false;
				return false;
			}
	}
	/*联动赋值 ifConnect 传0时才赋值，否则不赋值*/
	if(ifConnect == 0){
		if(nextFlag){
			/*证件地址改变时，赋值其他地址*/
			if(objType == 0){
			    document.all.custAddr.value=objValue;
			    document.all.contactAddr.value=objValue;
			    document.all.contactMAddr.value=objValue;
			}
			/*客户地址改变时，赋值联系人地址和联系人通讯地址*/
			if(objType == 1){
				document.all.contactAddr.value = objValue;
	  		document.all.contactMAddr.value = objValue;
			}
			/*联系人地址改变时，赋值联系人通讯地址，2013/12/16 15:20:17 20131216 gaopeng 赋值经办人联系地址联动*/
			if(objType == 2){
				document.all.contactMAddr.value=objValue;
				document.all.gestoresAddr.value=objValue;
				document.all.responsibleAddr.value=objValue;
			}
		}
	}
	
	
}
return nextFlag;
}

/*
	2013/11/18 14:01:09
	gaopeng
	证件类型变更时，证件号码的校验方法
*/

function checkIccIdFunc(obj,objType,ifConnect){
	var nextFlag = true;
	var idTypeVal = "";
	if(objType == 0){
		var objName = "证件号码";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "经办人证件号码";
		idTypeVal = document.all.gestoresIdType.value;
	}
	if(objType == 2){
		objName = "责任人证件号码";
		idTypeVal = document.all.responsibleType.value;
	}	
	
	/*只针对个人客户*/
	var opCode = "<%=opCode%>";
	/*获取输入框的值*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*获取输入的值的长度*/
	var objValueLength = objValue.length;
	if(objValue != ""){
		/* 获取所选择的证件类型 
		0|身份证 1|军官证 2|户口簿 3|港澳通行证 
		4|警官证 5|台湾通行证 6|外国公民护照 7|其它 
		8|营业执照 9|护照 A|组织机构代码 B|单位法人证书 C|介绍信 
		*/
		
		/*获取证件类型主键 */
		var idTypeText = idTypeVal.split("|")[0];
		
		/*1、身份证及户口薄时，证件号码长度为18位*/
		if(idTypeText == "0" || idTypeText == "2"){
			if(objValueLength != 18){
					rdShowMessageDialog(objName+"必须是18位！");
					
					nextFlag = false;
					return false;
			}
		}
		/*军官证 警官证 外国公民护照时 证件号码大于等于6位字符*/
		if(idTypeText == "1" || idTypeText == "4" || idTypeText == "6"){
			if(objValueLength < 6){
					rdShowMessageDialog(objName+"必须大于等于六位字符！");
					
					nextFlag = false;
					return false;
			}
		}
		/*证件类型为港澳通行证的，证件号码为9位或11位，并且首位为英文字母“H”或“M”(只可以是大写)，其余位均为阿拉伯数字。*/
		if(idTypeText == "3"){
			if(objValueLength != 9 && objValueLength != 11){
					rdShowMessageDialog(objName+"必须是9位或11位！");
					
					nextFlag = false;
					return false;
			}
			/*获取首字母*/
			var valHead = objValue.substring(0,1);
			if(valHead != "H" && valHead != "M"){
					rdShowMessageDialog(objName+"首字母必须是‘H’或‘M’！");
					
					nextFlag = false;
					return false;
			}
			/*获取首字母之后的所有信息*/
			var varWithOutHead = objValue.substring(1,objValue.length);
			if(varWithOutHead % 2 != 0 && varWithOutHead % 2 != 1){
					rdShowMessageDialog(objName+"除首字母之外，其余位必须是阿拉伯数字！");
					
					nextFlag = false;
					return false;
			}
		}
		/*证件类型为
			台湾通行证 
			证件号码只能是8位或11位
			证件号码为11位时前10位为阿拉伯数字，
			最后一位为校验码(英文字母或阿拉伯数字）；
			证件号码为8位时，均为阿拉伯数字
		*/
		if(idTypeText == "5"){
			if(objValueLength != 8 && objValueLength != 11){
					rdShowMessageDialog(objName+"必须为8位或11位！");
					
					nextFlag = false;
					return false;
			}
			/*8位时，均为阿拉伯数字*/
			if(objValueLength == 8){
				if(objValue % 2 != 0 && objValue % 2 != 1){
					rdShowMessageDialog(objName+"必须为阿拉伯数字");
					
					nextFlag = false;
					return false;
				}
			}
			/*11位时，最后一位可以是英文字母或阿拉伯数字，前10位必须是阿拉伯数字*/
			if(objValueLength == 11){
				var objValue10 = objValue.substring(0,10);
				if(objValue10 % 2 != 0 && objValue10 % 2 != 1){
					rdShowMessageDialog(objName+"前十位必须为阿拉伯数字");
					
					nextFlag = false;
					return false;
				}
				var objValue11 = objValue.substring(10,11);
  			var m = /^[A-Za-z]+$/;
				var flag = m.test(objValue11);
				
				if(!flag && objValue11 % 2 != 0 && objValue11 % 2 != 1){
					rdShowMessageDialog(objName+"第11位必须为阿拉伯数字或英文字母！");
					
					nextFlag = false;
					return false;
				}
			}
			
		}
		/*组织机构代 证件号码大于等于9位，为数字、“-”或大写拉丁字母*/
		if(idTypeText == "A"){
		 if(objValueLength != 10){
					rdShowMessageDialog(objName+"必须是10位！");				
					nextFlag = false;
					return false;
			}
			if(objValue.substr(objValueLength-2,1)!="-" && objValue.substr(objValueLength-2,1)!="－") {
					rdShowMessageDialog(objName+"倒数第二位必须是“-”！");				
					nextFlag = false;
					return false;			
			}
		}
		/*营业执照 证件号码号码大于等于4位数字，出现其他如汉字等字符也合规*/
		if(idTypeText == "8"){
		
		 if(objValueLength != 13 && objValueLength != 15 && objValueLength != 18 && objValueLength != 20){
					rdShowMessageDialog(objName+"必须是13位或15位或18位或20位！");				
					nextFlag = false;
					return false;
			}
				    
			var m = /^[\u0391-\uFFE5]*$/;
			var numSum = 0;
			for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//分别获取输入内容
          var flag = m.test(code);
          if(flag){
          	numSum ++;
          }
    	}
			if(numSum > 0){
					rdShowMessageDialog(objName+"不允许录入汉字！");				
					nextFlag = false;
					return false;
			}

		}
		/*法人证书 证件号码大于等于4位字符*/
		if(idTypeText == "B"){
		 if(objValueLength != 12){
					rdShowMessageDialog(objName+"必须是12位！");				
					nextFlag = false;
					return false;
			}
				    
			var m = /^[\u0391-\uFFE5]*$/;
			var numSum = 0;
			for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//分别获取输入内容
          var flag = m.test(code);
          if(flag){
          	numSum ++;
          }
    	}
			if(numSum > 0){
					rdShowMessageDialog(objName+"不允许录入汉字！");				
					nextFlag = false;
					return false;
			}
			
		}
		/*调用原有逻辑*/
		rpc_chkX('idType','idIccid','A');
		
	}
	return nextFlag;
}

function rpc_chkX(x_type,x_no,chk_kind)
{
  var obj_type=document.all(x_type);
  var obj_no=document.all(x_no);
  var idname="";

  if(obj_type.type=="text")
  {
    idname=(obj_type.value).trim();
  }
  else if(obj_type.type=="select-one")
  {
    idname=(obj_type.options[obj_type.selectedIndex].text).trim();  
  }

  if((obj_no.value).trim().length>0)
  {
  	
   
      if(idname=="身份证")
    {
        if(checkElement(obj_no)==false) return false;
    }
  
  }
  else 
  return;
  var myPacket = new AJAXPacket("/npage/innet/chkX.jsp","正在验证黑名单信息，请稍候......");
    myPacket.data.add("retType","chkX");
    myPacket.data.add("retObj",x_no);
    myPacket.data.add("x_idType",getX_idno(idname));
    myPacket.data.add("x_idNo",obj_no.value);
    myPacket.data.add("x_chkKind",chk_kind);
    core.ajax.sendPacket(myPacket);
    myPacket=null;
  
}

function doProcess(packet)
	  {
			//RPC处理函数findValueByName
			var retType = packet.data.findValueByName("retType");
			var retCode = packet.data.findValueByName("retCode");
			var retMessage = packet.data.findValueByName("retMessage");
			
			if(retType=="chkX")
	   {
	   	
	    var retObj = packet.data.findValueByName("retObj");
	    if(retCode == "000000"){
	      }else if(retCode=="100001"){
	        retMessage = retCode + "："+retMessage;  
	        /*总提示黑名单~这里屏蔽了比较*/
	        //rdShowMessageDialog(retMessage);     
	        return true;
	      }else{
	        retMessage = "错误" + retCode + "："+retMessage;      
	        rdShowMessageDialog(retMessage,0);
	        return false;
	       
	    }
	   }
			
		}

/***验证黑名单的函数中调用此函数***/
			function getX_idno(xx)
		{
		  if(xx==null) return "0";

		  if(xx=="身份证") return "0";
		  else if(xx=="军官证") return "1";
		  else if(xx=="驾驶证") return "2";
		  else if(xx=="警官证") return "4";
		  else if(xx=="学生证") return "5";
		  else if(xx=="单位") return "6";
		  else if(xx=="校园") return "7";
		  else if(xx=="营业执照") return "8";
		  else return "0";
		}

function checkNameStr(code){
  	/*优先匹配括号*/
    if(forKuoHao(code)) return "KH";//括号
    if(forA2sssz1(code)) return "EH"; //英语
    var re2 =new RegExp("[\u0400-\u052f]");
    if(re2.test(code)) return "RU"; //俄文
    var re3 =new RegExp("[\u00C0-\u00FF]");
    if(re3.test(code)) return "FH"; //法文
    var re4 = new RegExp("[\u3040-\u30FF]");
    var re5 = new RegExp("[\u31F0-\u31FF]");
    if(re4.test(code)||re5.test(code)) return "JP"; //日文
    var re6 = new RegExp("[\u1100-\u31FF]");
    var re7 = new RegExp("[\u1100-\u31FF]");
    var re8 = new RegExp("[\uAC00-\uD7AF]");
    if(re6.test(code)||re7.test(code)||re8.test(code)) return "KR"; //韩国
    if(forHanZi1(code)) return "CH"; //汉字
    
   }
   
   //匹配由26个英文字母组成的字符串
  function forA2sssz1(obj)
  {
  	var patrn = /^[A-Za-z]+$/;
  	var sInput = obj;
  	if(sInput.search(patrn)==-1){
  		//showTip(obj,"必须为字母！");
  		return false;
  	}
  	if (!isLengthOf(obj,obj.v_minlength,obj.v_maxlength)){
  		//showTip(obj,"长度有错误！");
  		return false;
  	}
  
  	return true;
  }
  
  function forKuoHao(obj){
	var m = /^(\(?\)?\（?\）?)\·|\.|\．+$/;
  	var flag = m.test(obj);
  	if(!flag){
  		return false;
  	}else{
  		return true;
  	}
}
  
  function forEnKuoHao(obj){
	var m = /^(\(?\)?)+$/;
  	var flag = m.test(obj);
  	if(!flag){
  		return false;
  	}else{
  		return true;
  	}
}
  function forHanZi1(obj)
  {
  	var m = /^[\u0391-\uFFE5]+$/;
  	var flag = m.test(obj);
  	if(!flag){
  		//showTip(obj,"必须输入汉字！");
  		return false;
  	}
  		if (!isLengthOf(obj,obj.v_minlength*2,obj.v_maxlength*2)){
  		//showTip(obj,"长度有错误！");
  		return false;
  	}
  	return true;
  }
  function pubM032Cfm(){
  }
  
  /*1、客户名称、联系人姓名 校验方法 objType 0 代表客户名称校验 1代表联系人姓名校验  ifConnect 代表是否联动赋值(点击确认按钮时，不进行联动赋值)*/
function checkCustNameFuncNew(obj,objType,ifConnect){
	var nextFlag = true;
	
	if(document.all.realUserName.v_must !="1") {
	  return nextFlag;
	  return false;		
	}
	
	
	
	var objName = "";
	var idTypeVal = "";
	if(objType == 0){
		objName = "客户名称";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "联系人姓名";
		idTypeVal = document.all.idType.value;
	}
	/*2013/12/16 11:24:47 gaopeng 关于在BOSS入网界面增加单位客户经办人信息的函 加入经办人姓名*/
	if(objType == 2){
		objName = "经办人姓名";
		/*规则按照经办人证件类型*/
		idTypeVal = document.all.gestoresIdType.value;
	}
	
	if(objType == 3){
		objName = "实际使用人姓名";
		/*规则按照经办人证件类型*/
		idTypeVal = document.all.realUserIdType.value;
	}
	
	idTypeVal = $.trim(idTypeVal);
	
	/*只针对个人客户*/
	var opCode = "<%=opCode%>";
	/*获取输入框的值*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*获取输入的值的长度*/
	var objValueLength = objValue.length;
	if(objValue != ""){
		/* 获取所选择的证件类型 
		0|身份证 1|军官证 2|户口簿 3|港澳通行证 
		4|警官证 5|台湾通行证 6|外国公民护照 7|其它 
		8|营业执照 9|护照 A|组织机构代码 B|单位法人证书 C|介绍信 
		*/
		/*获取证件类型主键 */
		var idTypeText = idTypeVal;
		
		/*有临时、代办字样的都不行*/
		if(objValue.indexOf("临时") != -1 || objValue.indexOf("代办") != -1){
					rdShowMessageDialog(objName+"不能带有‘临时’或‘代办’字样！");
					
					nextFlag = false;
					return false;
			
		}
		
		/*客户名称、联系人姓名均要求“大于等于2个中文汉字”，外国公民护照除外（外国公民护照客户名称必须大于3个字符，不全为阿拉伯数字)*/
		
		/*如果不是外国公民护照*/
		if(idTypeText != "6"){
			/*原有的业务逻辑校验 只允许是英文、汉字、俄文、法文、日文、韩文其中一种语言！*/
			
			/*2014/08/27 16:14:22 gaopeng 哈分公司申请优化开户名称限制的请示 要求单位客户时，客户名称可以填写英文大小写组合 目前先搞成跟 idTypeText == "3" || idTypeText == "9" 一样的逻辑 后续问问可不可以*/
			if(idTypeText == "3" || idTypeText == "9" || idTypeText == "8" || idTypeText == "A" || idTypeText == "B" || idTypeText == "C"){
				if(objValueLength < 2){
					rdShowMessageDialog(objName+"必须大于等于2个汉字！");
					nextFlag = false;
					return false;
				}
				 var KH_length = 0;
		     var EH_length = 0;
		     var RU_length = 0;
		     var FH_length = 0;
		     var JP_length = 0;
		     var KR_length = 0;
		     var CH_length = 0;
         
         for (var i = 0; i < objValue.length; i ++){
            var code = objValue.charAt(i);//分别获取输入内容
            var key = checkNameStr(code); //校验
            if(key == undefined){
              rdShowMessageDialog("只允许是英文、汉字、俄文、法文、日文、韩文或其与‘括号’组合其中一种语言！请重新输入！");
              obj.value = "";
              
              nextFlag = false;
              return false;
            }
            if(key == "KH"){
            	KH_length++;
            }
            if(key == "EH"){
            	EH_length++;
            }
            if(key == "RU"){
            	RU_length++;
            }
            if(key == "FH"){
            	FH_length++;
            }
            if(key == "JP"){
            	JP_length++;
            }
            if(key == "KR"){
            	KR_length++;
            }
            if(key == "CH"){
            	CH_length++;
            }
         
         }	
            var machEH = KH_length + EH_length;
            var machRU = KH_length + RU_length;
            var machFH = KH_length + FH_length;
            var machJP = KH_length + JP_length;
            var machKR = KH_length + KR_length;
            var machCH = KH_length + CH_length;
            
            
            if((objValueLength != machEH 
            && objValueLength != machRU
            && objValueLength != machFH
            && objValueLength != machJP
            && objValueLength != machKR
            && objValueLength != machCH ) || objValueLength == KH_length){
            		rdShowMessageDialog("只允许是英文、汉字、俄文、法文、日文、韩文或其与‘括号’组合其中一种语言！请重新输入！");
                obj.value = "";
              	nextFlag = false;
                return false;
            }
       }
       else{
					
					/*获取含有中文汉字的个数以及'()（）'的个数*/
					var m = /^[\u0391-\uFFE5]*$/;
					var mm = /^·|\.|\．*$/;
					var chinaLength = 0;
					var kuohaoLength = 0;
					var zhongjiandianLength=0;
					for (var i = 0; i < objValue.length; i ++){
								
			          var code = objValue.charAt(i);//分别获取输入内容
			          var flag22=mm.test(code);
			          var flag = m.test(code);
			          /*先校验括号*/
			          if(forKuoHao(code)){
			          	kuohaoLength ++;
			          }else if(flag){
			          	chinaLength ++;
			          }else if(flag22){
			          	zhongjiandianLength++;
			          }
			          
			    }
			    var machLength = chinaLength + kuohaoLength+zhongjiandianLength;
					/*括号的数量+汉字的数量 != 总数量时 提示错误信息(这里需要注意一点，中文括号也是中文。。。所以这里只进行英文括号的匹配个数，否则会匹配多个)*/
					if(objValueLength != machLength || chinaLength == 0){
						rdShowMessageDialog(objName+"必须输入中文或中文与括号的组合(括号可以为中文或英文括号“()（）”)！");
						/*赋值为空*/
						obj.value = "";
						
						nextFlag = false;
						return false;
					}else if(objValueLength == machLength && chinaLength != 0){
						if(objValueLength < 2){
							rdShowMessageDialog(objName+"必须大于等于2个中文汉字！");
							
							nextFlag = false;
							return false;
						}
					}
					/*原有逻辑
					if(idTypeText == "0" || idTypeText == "2"){
						if(objValueLength > 6){
							rdShowMessageDialog(objName+"最多输入6个汉字！");
							
							nextFlag = false;
							return false;
						}
				}
				*/
			}
       
		}
		/*如果是外国公民护照 校验 外国公民护照客户名称(后续添加了联系人姓名也同理(sunaj已确定))必须大于3个字符，不全为阿拉伯数字*/
		if(idTypeText == "6"){
			/*如果校验客户名称*/
				if(objValue % 2 == 0 || objValue % 2 == 1){
						rdShowMessageDialog(objName+"不能全为阿拉伯数字!");
						/*赋值为空*/
						obj.value = "";
						
						nextFlag = false;
						return false;
				}
				if(objValueLength <= 3){
						rdShowMessageDialog(objName+"必须大于三个字符!");
						
						nextFlag = false;
						return false;
				}
				var KH_length = 0;
		     var EH_length = 0;
		     var RU_length = 0;
		     var FH_length = 0;
		     var JP_length = 0;
		     var KR_length = 0;
		     var CH_length = 0;
         
         for (var i = 0; i < objValue.length; i ++){
            var code = objValue.charAt(i);//分别获取输入内容
            var key = checkNameStr(code); //校验
            if(key == undefined){
              rdShowMessageDialog("只允许是英文、汉字、俄文、法文、日文、韩文或其与‘括号’组合其中一种语言！请重新输入！");
              obj.value = "";
              
              nextFlag = false;
              return false;
            }
            if(key == "KH"){
            	KH_length++;
            }
            if(key == "EH"){
            	EH_length++;
            }
            if(key == "RU"){
            	RU_length++;
            }
            if(key == "FH"){
            	FH_length++;
            }
            if(key == "JP"){
            	JP_length++;
            }
            if(key == "KR"){
            	KR_length++;
            }
            if(key == "CH"){
            	CH_length++;
            }
         
         }	
            var machEH = KH_length + EH_length;
            var machRU = KH_length + RU_length;
            var machFH = KH_length + FH_length;
            var machJP = KH_length + JP_length;
            var machKR = KH_length + KR_length;
            var machCH = KH_length + CH_length;
            
            
            if((objValueLength != machEH 
            && objValueLength != machRU
            && objValueLength != machFH
            && objValueLength != machJP
            && objValueLength != machKR
            && objValueLength != machCH ) || objValueLength == KH_length){
            		rdShowMessageDialog("只允许是英文、汉字、俄文、法文、日文、韩文或其与‘括号’组合其中一种语言！请重新输入！");
                obj.value = "";
              	nextFlag = false;
                return false;
            }
				
		}
		
		
		
	}	
	return nextFlag;
}


/*
	2013/11/18 11:15:44
	gaopeng
	客户地址、证件地址、联系人地址校验方法
	“客户地址”、“证件地址”和“联系人地址”均需“大于等于8个中文汉字”
	（外国公民护照和台湾通行证除外，外国公民护照要求大于2个汉字，台湾通行证要求大于3个汉字）
*/

function checkAddrFuncNew(obj,objType,ifConnect){
	var nextFlag = true;
	
		if(document.all.realUserAddr.v_must !="1") {
	  return nextFlag;
	  return false;		
	}
	
	
	var objName = "";
	var idTypeVal = ""
	if(objType == 0){
		objName = "证件地址";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "客户地址";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 2){
		objName = "联系人地址";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 3){
		objName = "联系人通讯地址";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 4){
		objName = "经办人联系地址";
		idTypeVal = document.all.gestoresIdType.value;
	}
	if(objType == 5){
		objName = "实际使用人联系地址";
		idTypeVal = document.all.realUserIdType.value;
	}
		
	idTypeVal = $.trim(idTypeVal);
	/*只针对个人客户*/
	var opCode = "<%=opCode%>";
	/*获取输入框的值*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*获取输入的值的长度*/
	var objValueLength = objValue.length;
	
	if(objValue != ""){
		/* 获取所选择的证件类型 
		0|身份证 1|军官证 2|户口簿 3|港澳通行证 
		4|警官证 5|台湾通行证 6|外国公民护照 7|其它 
		8|营业执照 9|护照 A|组织机构代码 B|单位法人证书 C|介绍信 
		*/
		
		/*获取证件类型主键 */
		var idTypeText = idTypeVal;
		
		/*获取含有中文汉字的个数*/
		var m = /^[\u0391-\uFFE5]*$/;
		var chinaLength = 0;
		for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//分别获取输入内容
          var flag = m.test(code);
          if(flag){
          	chinaLength ++;
          }
    }
      
		/*如果既不是外国公民护照 也不是台湾通行证 */
		if(idTypeText != "6" && idTypeText != "5"){
			/*含有至少8个中文汉字*/
			if(chinaLength < 8){
				rdShowMessageDialog(objName+"必须含有至少8个中文汉字！");
				/*赋值为空*/
				obj.value = "";
				
				nextFlag = false;
				return false;
			}
		
	}
	/*外国公民护照 大于2个汉字*/
	if(idTypeText == "6"){
		/*大于2个中文汉字*/
			if(chinaLength <= 2){
				rdShowMessageDialog(objName+"必须含有大于2个中文汉字！");
				
				nextFlag = false;
				return false;
			}
	}
	/*台湾通行证 大于3个汉字*/
	if(idTypeText == "5"){
		/*含有至少3个文汉字*/
			if(chinaLength <= 3){
				rdShowMessageDialog(objName+"必须含有大于3个中文汉字！");
				
				nextFlag = false;
				return false;
			}
	}
	
	
}
return nextFlag;
}

/*
	2013/11/18 14:01:09
	gaopeng
	证件类型变更时，证件号码的校验方法
*/

function checkIccIdFuncNew(obj,objType,ifConnect){
	var nextFlag = true;
	
	if(document.all.realUserIccId.v_must !="1") {
	  return nextFlag;
	  return false;		
	}
	
	
	var idTypeVal = "";
	if(objType == 0){
		var objName = "证件号码";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "经办人证件号码";
		idTypeVal = document.all.gestoresIdType.value;
	}
	if(objType == 2){
		objName = "实际使用人证件号码";
		idTypeVal = document.all.realUserIdType.value;
	}
	
	/*只针对个人客户*/
	var opCode = "<%=opCode%>";
	/*获取输入框的值*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*获取输入的值的长度*/
	var objValueLength = objValue.length;
	if(objValue != ""){
		/* 获取所选择的证件类型 
		0|身份证 1|军官证 2|户口簿 3|港澳通行证 
		4|警官证 5|台湾通行证 6|外国公民护照 7|其它 
		8|营业执照 9|护照 A|组织机构代码 B|单位法人证书 C|介绍信 
		*/
		
		/*获取证件类型主键 */
		var idTypeText = idTypeVal;
		
		/*1、身份证及户口薄时，证件号码长度为18位*/
		if(idTypeText == "0" || idTypeText == "2"){
			if(objValueLength != 18){
					rdShowMessageDialog(objName+"必须是18位！");
					
					nextFlag = false;
					return false;
			}
		}
		/*军官证 警官证 外国公民护照时 证件号码大于等于6位字符*/
		if(idTypeText == "1" || idTypeText == "4" || idTypeText == "6"){
			if(objValueLength < 6){
					rdShowMessageDialog(objName+"必须大于等于六位字符！");
					
					nextFlag = false;
					return false;
			}
		}
		/*证件类型为港澳通行证的，证件号码为9位或11位，并且首位为英文字母“H”或“M”(只可以是大写)，其余位均为阿拉伯数字。*/
		if(idTypeText == "3"){
			if(objValueLength != 9 && objValueLength != 11){
					rdShowMessageDialog(objName+"必须是9位或11位！");
					
					nextFlag = false;
					return false;
			}
			/*获取首字母*/
			var valHead = objValue.substring(0,1);
			if(valHead != "H" && valHead != "M"){
					rdShowMessageDialog(objName+"首字母必须是‘H’或‘M’！");
					
					nextFlag = false;
					return false;
			}
			/*获取首字母之后的所有信息*/
			var varWithOutHead = objValue.substring(1,objValue.length);
			if(varWithOutHead % 2 != 0 && varWithOutHead % 2 != 1){
					rdShowMessageDialog(objName+"除首字母之外，其余位必须是阿拉伯数字！");
					
					nextFlag = false;
					return false;
			}
		}
		/*证件类型为
			台湾通行证 
			证件号码只能是8位或11位
			证件号码为11位时前10位为阿拉伯数字，
			最后一位为校验码(英文字母或阿拉伯数字）；
			证件号码为8位时，均为阿拉伯数字
		*/
		if(idTypeText == "5"){
			if(objValueLength != 8 && objValueLength != 11){
					rdShowMessageDialog(objName+"必须为8位或11位！");
					
					nextFlag = false;
					return false;
			}
			/*8位时，均为阿拉伯数字*/
			if(objValueLength == 8){
				if(objValue % 2 != 0 && objValue % 2 != 1){
					rdShowMessageDialog(objName+"必须为阿拉伯数字");
					
					nextFlag = false;
					return false;
				}
			}
			/*11位时，最后一位可以是英文字母或阿拉伯数字，前10位必须是阿拉伯数字*/
			if(objValueLength == 11){
				var objValue10 = objValue.substring(0,10);
				if(objValue10 % 2 != 0 && objValue10 % 2 != 1){
					rdShowMessageDialog(objName+"前十位必须为阿拉伯数字");
					
					nextFlag = false;
					return false;
				}
				var objValue11 = objValue.substring(10,11);
  			var m = /^[A-Za-z]+$/;
				var flag = m.test(objValue11);
				
				if(!flag && objValue11 % 2 != 0 && objValue11 % 2 != 1){
					rdShowMessageDialog(objName+"第11位必须为阿拉伯数字或英文字母！");
					
					nextFlag = false;
					return false;
				}
			}
			
		}
		/*组织机构代 证件号码大于等于9位，为数字、“-”或大写拉丁字母*/
		if(idTypeText == "A"){
			var m = /^([0-9\-A-Z]*)$/;
			var flag = m.test(objValue);
			if(!flag){
					rdShowMessageDialog(objName+"必须由数字、‘-’、或大写字母组成！");
					
					nextFlag = false;
					return false;
			}
			if(objValueLength < 9){
					rdShowMessageDialog(objName+"必须大于等于9位！");
					
					nextFlag = false;
					return false;
				
			}
		}
		/*营业执照 证件号码号码大于等于4位数字，出现其他如汉字等字符也合规*/
		if(idTypeText == "8"){
			var m = /^[0-9]+$/;
			var numSum = 0;
			for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//分别获取输入内容
          var flag = m.test(code);
          if(flag){
          	numSum ++;
          }
    	}
			if(numSum < 4){
					rdShowMessageDialog(objName+"包含至少4个数字！");
					
					nextFlag = false;
					return false;
			}
			/*20131216 gaopeng 关于在BOSS入网界面增加单位客户经办人信息的函 界面中的证件类型为“营业执照”时，要求证件号码的位数为15位字符*/
			if(objValueLength != 15){
					rdShowMessageDialog(objName+"必须为15个字符！");
					nextFlag = false;
					return false;
			}
		}
		/*法人证书 证件号码大于等于4位字符*/
		if(idTypeText == "B"){
			if(objValueLength < 4){
					rdShowMessageDialog(objName+"必须大于等于4位！");
					
					nextFlag = false;
					return false;
			}
			
		}


	}else if(opCode == "1993"){

	}
	return nextFlag;
}

//下发工单
		  function sendProLists(){
				var packet = new AJAXPacket("/npage/sq100/fq100_ajax_sendProLists.jsp","正在获得数据，请稍候......");
				packet.data.add("opCode","<%=opCode%>");
				packet.data.add("phoneNo","<%=phoneNo%>");
				core.ajax.sendPacket(packet,doSendProLists);
				packet = null;
		  } 
		  
		  function doSendProLists(packet){
		  	var retCode = packet.data.findValueByName("retCode");
				var retMsg =  packet.data.findValueByName("retMsg");
				if(retCode != "000000"){
					rdShowMessageDialog( "下发工单失败!<br>错误代码："+retCode+"<br>错误信息："+retMsg,0 );
					//记录为没点击
					$("#isSendListFlag").val("N");
				}else{
					rdShowMessageDialog( "下发工单成功!" );
					//记录为点击
					$("#isSendListFlag").val("Y");
				}
		  }
		  
		  //工单结果查询
			function qryListResults(){
				var h=450;
				var w=800;
				var t=screen.availHeight/2-h/2;
				var l=screen.availWidth/2-w/2;
				var prop="dialogHeight:"+h+"px;dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;status:no;help:no";
				var ret=window.showModalDialog("/npage/sq100/f1100_qryListResults.jsp?opCode=<%=opCode%>&opName=<%=opName%>&accp="+Math.random(),"",prop);
				if(typeof(ret) == "undefined"){
					rdShowMessageDialog("如果没有工单查询结果，请先进行下发工单操作！");
					$("#isQryListResultFlag").val("N");//选择了工单查询结果
				}else if(ret!=null && ret!=""){
					$("#isQryListResultFlag").val("Y");//选择了工单查询结果
					$("#custName").val(ret.split("~")[0]); //客户姓名
					$("#idIccid").val(ret.split("~")[1]); //证件号码
					if($("#idIccid").val() != ""){
						checkIccIdFunc16New(document.all.idIccid,0,0);
						rpc_chkX('idType','idIccid','A');
					}
					$("#idAddr").val(ret.split("~")[2]);  //证件地址
					$("input[name='custAddr']").val(ret.split("~")[2]); //客户地址
					$("input[name='contactAddr']").val(ret.split("~")[2]); //联系人地址
					$("input[name='contactMAddr']").val(ret.split("~")[2]); //联系人通讯地址
					$("#idValidDate").val(ret.split("~")[3]); //证件有效期
					$("#loginacceptJT").val(ret.split("~")[4]); //集团流水
					
					$("#idIccid").attr("class","InputGrey");
		  		$("#idIccid").attr("readonly","readonly");
		  		$("#custName").attr("class","InputGrey");
		  		$("#custName").attr("readonly","readonly");
		  		$("#idAddr").attr("class","InputGrey");
		  		$("#idAddr").attr("readonly","readonly");	
		  		$("#idValidDate").attr("class","InputGrey");
		  		$("#idValidDate").attr("readonly","readonly");		
				}
			}  
			
			//只需要将table增加一个vColorTr='set' 属性就可以隔行变色
			$("table[vColorTr='set']").each(function(){
				$(this).find("tr").each(function(i,n){
					$(this).bind("mouseover",function(){
						$(this).addClass("even_hig");
					});
				
					$(this).bind("mouseout",function(){
						$(this).removeClass("even_hig");
					});
				
					if(i%2==0){
						$(this).addClass("even");
					}
				});
			});



	</script>
</head>
<body>
<form action="" method="post" name="frm">
	<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">用户信息</div>
	</div>
	<table>
		<tr>
			<td class="blue" width="15%">IMS固话账号</td>
			<td width="15%">
				<span id="cfmLogin"><%=broadPhone%></span>
			</td>
			<td class="blue" width="15%">业务品牌</td>
			<td width="10%">
				<span id="smCode"><%=sNewSmName%></span>
			</td>
			<td class="blue" width="15%">客户姓名</td>
			<td>
				<%=(String)custDoc.get(5)%>
			</td>
		</tr>
		<tr>
			<td class="blue" width="15%">当前预存</td>
			<td>
				<span id="showFee"><%=(String)custDoc.get(20)%></span>
			</td>
			<td class="blue" width="15%">当前欠费</td>
			<td>
				<span><%=(String)custDoc.get(19)%></span>
			</td>
			<td class="blue" width="15%">客户地址</td>
			<td>
				<span id="custAddress"><%=(String)custDoc.get(13)%></span>
			</td>
		</tr>
		<tr>
			<td class="blue" width="15%">证件号码</td>
			<td>
				<%=(String)custDoc.get(16)%>
			</td>
			<td class="blue" width="15%">联系人</td>
			<td>
				<span id="contactPerson"></span>
			</td>
			<td class="blue" width="15%">联系电话</td>
			<td>
				<span id="contactPhone"></span>
			</td>
		</tr>
	</table>
</div>
<div id="Operation_Table">
	<div class="title">
		<div id="title_zi">业务办理</div>
	</div>
	<table>
		<tr>
			<td class="blue">
				新客户ID
			</td>
			<td>
				<input type="text" name="new_cus_id" value="" id="new_cus_id" 
				size="14"  v_must=1 v_maxlength=14 v_type=int v_name="新客户ID" maxlength="14" 
				index="15" readonly="readonly" class="InputGrey"/>
			</td>
			<td  class=blue>
				信誉度
			</td>
			<td width=35% >
				<input v_name="信誉度" name= "xinYiDu" type="text" v_type="int" v_must=1 maxlength="6" value="0" size="10" onBlur="if(this.value!=''){if(checkElement(document.all.xinYiDu)==false){return false;}}; checkXi()" >
				<font class="orange">*</font>
			</td>
		</tr>
		<tr>
    	<td class="blue" >
        个人开户分类
      </td>
      <TD class="blue" colspan="3">
      	<select align="left" name="isJSX" onChange="reSetCustName()" width=50 index="6">
      		<option class="button" value="0">普通客户</option>
      		<option class="button" value="1">单位客户</option>
      	</select>
      	&nbsp;&nbsp;&nbsp;
				<input type="button" id="sendProjectList" name="sendProjectList" class="b_text" value="下发工单" onclick="sendProLists()" style="display:none" />                    
      	&nbsp;&nbsp;&nbsp;
				<input type="button" id="qryListResultBut" name="qryListResultBut" class="b_text" value="工单结果查询" onclick="qryListResults()" style="display:none" />    
      </TD>
    </tr>
		<tr>
			<td class="blue" width="13%">
				<div align="left">客户归属市县</div>
			</td>
			<td width="30%">
				<select align="left" name=districtCode width=50 index="16">
					<wtc:qoption name="sPubSelect" outnum="2">
					<wtc:sql>select trim(DISTRICT_CODE),DISTRICT_NAME from  SDISCODE Where region_code='<%=regionCode%>' order by DISTRICT_CODE</wtc:sql>
					</wtc:qoption>
				</select>
			</td>
			<td class="blue" width="13%">
				<div align="left">客户名称</div>
			</td>
			<td>
				<input id="custName" name="custName" v_must=0 v_type="string" v_name="客户名称" 
				 onChange="change_ConPerson()" onblur="checkCustNameFunc16New(this,0,0);" 
				  maxlength="30" size=35 index="17">
				<font class="orange">*</font>
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">证件类型</div>
			</td>
			<td id="tdappendSome">
                          
      </td>
			<td class="blue">
				<div align="left">证件号码</div>
			</td>
			<td>
				<input id="idIccid" name="idIccid" v_must=0 v_type="string" v_name="证件号码"  maxlength="18"  index="19" onBlur="checkIccIdFunc16New(this,0,0);rpc_chkX('idType','idIccid','A');">
				<font class="orange">*</font>
				<input name=IDQueryJustSee type=button class="b_text" 
				 style="cursor:hand" onClick="getInfo_IccId_JustSee()" 
				 id="custIdQueryJustSee" value="信息查询" />
			</td>
		</tr>
		<TR id="card_id_type">
			<td colspan=2 align=center>
				<input type="button" id="read_idCard_one" name="read_idCard_one" class="b_text"   value="扫描一代身份证" onClick="RecogNewIDOnly_oness()" >
				<input type="button" name="read_idCard_two" class="b_text"   value="扫描二代身份证" onClick="RecogNewIDOnly_twoss()">
				<input type="button" name="scan_idCard_two" class="b_text"   value="读卡" onClick="Idcardss()" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" name="scan_idCard_two222" id="scan_idCard_two222" class="b_text"   value="读卡(2代)" onClick="Idcard2('1')" >
			</td>
			<td  class="blue">
				证件照片上传
			</td>
			<td>
				<input type="file" name="filep" id="filep" onchange="chcek_pic1121();" >    &nbsp;
				<iframe name="upload_frame" id="upload_frame" style="display:none"></iframe>
				<input type="hidden" name="idSexH" value="1">
				<input type="hidden" name="birthDayH" value="20090625">
				<input type="hidden" name="idAddrH" value="哈尔滨">
				<input type="button" name="uploadpic_b" class="b_text"  
				 value="上传照片" onClick="uploadpic()"  disabled>
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">证件地址</div>
			</td>
			<td>
				<input id="idAddr" name=idAddr v_must=0 v_type="string" v_name="证件地址" v_maxlength=60 maxlength="60" size="30" index="20" onBlur="if(checkElement(this)){checkAddrFunc(this,0,0)}">
				<font class="orange">*</font>
			</td>
			<td class="blue">
				<div align="left">证件有效期</div>
			</td>
			<td>
				<input name="idValidDate" id="idValidDate" v_must=0 v_maxlength=8 v_type="date" v_name="证件有效期" maxlength=8 size="8" index="21" onBlur="chkValid();" v_format="yyyyMMdd" style="ime-mode:disabled" onKeyPress="return isKeyNumberdot(0)" >
			</td>
		</tr>
		<tr id ="divPassword" style="display:;">
			<td class="blue">
				<div align="left">客户密码</div>
			</td>
			<td>
				<input name="custPwd" type="password" onblur="" class="button"  maxlength="6">
				<input id="bttn1" name="bttn1" type="button" value="输入"  class="b_text" >
				<font class="orange">*</font>
			</td>
			<td class="blue">
				<div align="left">校验客户密码</div>
			</td>
			<td>
				<input  name="cfmPwd" type="password"  class="button" prefield="cfmPwd" filedtype="pwd"  maxlength="6">
				<input onclick="showNumberDialog(document.all.cfmPwd);" id="btn2" type="button" value="再输入" class="b_text" >
				<font class="orange">*</font>
			</td>
		</tr>
		<script type="text/javascript">
			var btn1Obj = document.getElementById("bttn1");
			btn1Obj.attachEvent("onclick",foo);
			btn1Obj.attachEvent("onclick",doo);
			function foo(){
				chkPwdEasy1(document.all.custPwd.value);
			}
			function doo(){
				showNumberDialog(document.all.custPwd);
			}
		</script>
		<tr>
			<td class="blue">
				<div align="left">客户状态</div>
			</td>
			<td colspan="3">
				<select align="left" name=custStatus width=50 index="24">
					<wtc:qoption name="sPubSelect" outnum="2">
						<wtc:sql>select trim(STATUS_CODE),STATUS_NAME from sCustStatusCode order by STATUS_CODE</wtc:sql>
					</wtc:qoption>
				</select>
				<select  align="left" name=custGrade width=50 index="25" style="display:none">
					<wtc:qoption name="sPubSelect" outnum="2">
						<wtc:sql>select trim(OWNER_CODE), TYPE_NAME from sCustGradeCode where REGION_CODE ='<%=regionCode%>' order by OWNER_CODE</wtc:sql>
					</wtc:qoption>
				</select>
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">客户地址</div>
			</td>
			<td colspan="3">
				<input name=custAddr v_type="string" v_must=0 v_name="客户地址"  v_maxlength=60 maxlength="60" size=35 index="26" onBlur="if(checkElement(this)){checkAddrFunc(this,1,0);}">
				<font class="orange">*</font> </td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">联系人姓名</div>
			</td>
			<td>
				<input name="newContactPerson" id="newContactPerson" v_must=0 v_type="string" v_name="联系人姓名" onblur="checkCustNameFunc(this,1,0);" maxlength="20" size=20 index="27" v_maxlength=20>
				<font class="orange">*</font>
			</td>
			<td class="blue">
				<div align="left">联系人电话</div>
			</td>
			<td>
				<input name="newContactPhone" id="newContactPhone" v_must=0 v_type="phone" v_name="联系人电话" maxlength="20"  index="28" size="20">
				<font class="orange">*</font> </td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">联系人地址</div>
			</td>
			<td>
				<input name=contactAddr  v_must=0 v_type="string" v_name="联系人地址" v_maxlength=60 maxlength="60" size=55 index="29" onBlur="if (checkElement(this)){ checkAddrFunc(this,2,0) }">
				<font class="orange">*</font> </td>
			<td class="blue">
				<div align="left">联系人邮编</div>
			</td>
			<td>
				<input name=contactPost v_type="zip" v_name="联系人邮编" maxlength="6"  index="30" size="20">
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">联系人传真</div>
			</td>
			<td>
				<input name=contactFax v_must=0 v_type="phone" v_name="联系人传真" maxlength="20"  index="31" size="20">
			</td>
			<td class="blue">
				<div align="left">联系人E_MAIL</div>
			</td>
			<td>
				<input name=contactMail v_must=0 v_type="email" v_name="联系人EMAIL" maxlength="30" size=30 index="32">
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">联系人通讯地址</div>
			</td>
			<td colspan="3">
				<input name=contactMAddr v_must=0 v_type="string" v_name="联系人通讯地址" v_maxlength=60 maxlength="60" size=55 index="33" onBlur="if(checkElement(this)){checkAddrFunc(this,3,0)};">
				<font class="orange">*</font>
			</td>
		</tr>
		<!--2016/2/29 13:20:46 gaopeng 关于协助新增IMS固话实名制标识及开发经分报表需求的函（BOSS侧）
			增加经办人信息
		 -->
		<%@ include file="/npage/sq100/gestoresInfo.jsp" %>
		<%@ include file="/npage/sq100/responsibleInfo.jsp" %>
		<%@ include file="/npage/sq100/realUserInfo.jsp" %>

   	
		
		<tr>
			<td class="blue">
				<div align="left">客户性别</div>
			</td>
			<td>
				<select align="left" name=custSex width=50 index="34">
					<wtc:qoption name="sPubSelect" outnum="2">
						<wtc:sql>select trim(SEX_CODE), SEX_NAME from ssexcode order by SEX_CODE</wtc:sql>
					</wtc:qoption>
				</select>
			</td>
			<td class="blue">
				<div align="left">出生日期</div>
			</td>
			<td>
				<input name=birthDay maxlength=8 index="35"  v_must=0 v_maxlength=8 v_type="date" v_name="出生日期" size="8" v_format="yyyyMMdd" onblur="checkElement(this);">
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">职业类别</div>
			</td>
			<td>
				<select align="left" name=professionId width=50 index="36">
					<wtc:qoption name="sPubSelect" outnum="2">
						<wtc:sql>select trim(PROFESSION_ID), PROFESSION_NAME from sprofessionid order by PROFESSION_ID DESC</wtc:sql>
					</wtc:qoption>
				</select>
			</td>
			<td class="blue">
				<div align="left">学历</div>
			</td>
			<td>
				<select align="left" name=vudyXl width=50 index="37">
					<wtc:qoption name="sPubSelect" outnum="2">
						<wtc:sql>select trim(WORK_CODE), TYPE_NAME from SWORKCODE Where region_code ='<%=regionCode%>' order by work_code DESC</wtc:sql>
					</wtc:qoption>
				</select>
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">客户爱好</div>
			</td>
			<td>
				<input name=custAh maxlength="20"  index="38" size="20">
			</td>
			<td class="blue">
				<div align="left">客户习惯</div>
			</td>
			<td>
				<input name=custXg maxlength="20"  index="39">
			</td>
			</tr>
	</table>
	
	
	<table cellspacing="0">
		
		<!-- 20091201 begin -->
		<TR style="display:none" id="Good_PhoneDate_GSM" >
			<TD nowrap class=blue width="13%">
				<div align="left">原服务号码过户限制</div>
			</TD>
			<TD nowrap>
				<select name ="GoodPhoneFlag" onchange="GoodPhoneDateChg();">
					<option class='button' value='0' selected>--请选择--</option>
					<option class='button' value='Y' >允许过户</option>
					<option class='button' value='N' >不允许过户</option>
				</select>
			</TD>
			<TD nowrap class=blue width="13%">
				<div align="left" >可办理过户的时间</div>
			</TD>
			<TD nowrap colspan="3">
				<input id="GoodPhoneDate" class="button" name="GoodPhoneDate" maxlength="8" disabled >
				<font class="orange">(格式YYYYMMDD)</font>&nbsp;&nbsp;
			</TD>
		</TR>
		<!-- 20091201 end -->
		<tr>
			<td class="blue" width="13%">
				<div align="left">手续费</div>
			</td>
			<td width="20%">
				<div align="left">
					<input type="text" name="t_handFee" id="t_handFee" size="16" 
					value="<%=(((String)custDoc.get(30)).trim().equals(""))?("0"):(((String)custDoc.get(30)).trim()) %>" 
					v_type=float v_name="手续费" <%if(hfrf){%>readonly<%}%> 
					onblur="ChkHandFee()" index="40">
				</div>
			</td>
			<td class="blue" width="13%">
				<div align="left">实收</div>
			</td>
			<td width="20%">
				<div align="left">
					<input type="text" name="t_factFee" id="t_factFee" index="41" 
						size="16"  onKeyUp="getFew()" v_type=float v_name="实收"
					<%
					System.out.println("hfrf====="+hfrf);
					if(hfrf){
						if(((String)custDoc.get(30)).trim().equals("") || ((String)custDoc.get(30)).trim().equals("0")  || Double.parseDouble(((String)(custDoc.get(30))))==0)
						{
						%>
							readonly
						<%
						}
					}
					%>
					>
				</div>
			</td>
			<td class="blue" width="13%">
				<div align="left">找零</div>
			</td>
			<td width="20%">
				<div align="left">
					<input type="text" name="t_fewFee" id="t_fewFee" size="16" readonly>
				</div>
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">资料查询</div>
			</td>
			<td nowrap colspan="5">
				<select name ="print_query" >
					<% //<option class='button' value='Y' >是</option> %>
					<option class='button' value='N' selected>否</option>
				</select>
				<font class="orange">* 说明:新机主是否有权察看过户前的所有资料</font>
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">系统备注</div>
			</td>
			<td nowrap colspan="5">
				<div align="left">
					<input type="text" name="t_sys_remark" id="t_sys_remark" size="60" readonly maxlength=60>
				</div>
			</td>
		</tr>
		<tr style="display:none">
			<td class="blue">
				<div align="left">用户备注</div>
			</td>
			<td nowrap colspan="5">
				<div align="left">
					<input type="text" name="t_op_remark" id="t_op_remark" size="60"	v_maxlength=60  v_type=string  v_name="用户备注" maxlength=60 >
				</div>
			</td>
		</tr>
		<tr >
			<td class="blue">用户备注</td>
			<td nowrap colspan="5">
				<input name=assuNote v_must=0 v_maxlength=60 v_type="string" v_name="用户备注" maxlength="60" size=60  value="" index="42">
			</td>
		</tr>
	</table>
	<jsp:include page="/npage/public/hwReadCustCard.jsp">
		<jsp:param name="hwAccept" value="<%=loginAccept%>"  />
		<jsp:param name="showBody" value="01"  />
	</jsp:include>
	
	<table>
		<tr > 
			<td id="footer">
			<input name="confirm" type="button" class="b_foot" value="确认&打印" onClick="printCommit()" />
			&nbsp; 
			<input name="reset" type="reset" class="b_foot" value="清除" />
			&nbsp; 
			<input name="back" onClick="removeCurrentTab();" type="button" class="b_foot" value="关闭" />
			&nbsp;
			</td>
		</tr>
	</table>
	<!-- 隐藏表单部分，为下一页面传参用 -->
	<input type="hidden" name="opCode" id="opCode" />
	<input type="hidden" name="opName" id="opName" />
	<input type="hidden" name="srv_no" id="srv_no" value="<%=phoneNo%>">
	<input type="hidden" name="cust_name" id="cust_name" value="<%=(String)custDoc.get(5)%>">
  <input type="hidden" name="cust_addr" id="cust_addr" value="<%=(String)custDoc.get(13)%>">
	<input type="hidden" name="regionCode" id="regionCode" value="<%=regionCode%>">
 	<input type="hidden" name="ic_no" id="ic_no" value="<%=(String)custDoc.get(16)%>">
	<input type="hidden" name="user_id" id="user_id" value="<%=(String)custDoc.get(0)%>">
	<input type="hidden" name="oriHandFee" id="oriHandFee" value="<%=((String)custDoc.get(23))%>">
  <input type="hidden" name="oldPass" id="oldPass" value="<%=((String)custDoc.get(6)).trim()%>">
  <input type="hidden" name="workno" value=<%=workNo%>>
	
	<input type="hidden" name="card_flag" value="">  <!--身份证几代标志-->
  <input type="hidden" name="m_flag" value="">   <!--扫描或者读取标志，用于确定上传图片时候的图片名-->
  <input type="hidden" name="sf_flag" value="">   <!--扫描是否成功标志-->
  <input type="hidden" name="pic_name" value="">   <!--标识上传文件的名称-->
	<input type="hidden" name="up_flag" value="0">
	<input type="hidden" name="but_flag" value="0"> <!--按钮点击标志-->
	<input type="hidden" name="upbut_flag" value="0"> <!--上传按钮点击标志-->
	<input type="hidden" name="custId" value="0">
	<input type="hidden" name="card2flag" value="0">
	<input type="hidden" name="loginAccept" value="<%=loginAccept%>">
	<input type="hidden" name="broadPhone" value="<%=broadPhone%>">
<input type="hidden" name="isSendListFlag" id="isSendListFlag" value="N" />
  <input type="hidden" name="isQryListResultFlag" id="isQryListResultFlag" value="N" />
  <input type="hidden" name="sendListOpenFlag" id="sendListOpenFlag" value="<%=sendListOpenFlag%>" />
  <input type="hidden" name="loginacceptJT" id="loginacceptJT" />
	<%@ include file="/npage/include/footer.jsp" %> 
	<%@ include file="/npage/common/pwd_comm.jsp" %>
	<%@ include file="/npage/include/public_smz_check.jsp" %>
</form>
</body>
	<%@ include file="/npage/public/hwObject.jsp" %> 
 	 <%@ include file="/npage/s1210/interface_provider1238.jsp" %> 
</html>
