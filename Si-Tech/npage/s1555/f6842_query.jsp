<%
    /********************
     version v2.0
     开发商: si-tech
     *
     *update:zhanghonga@2008-09-03 页面改造,修改样式
     *
     ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="../../npage/bill/getMaxAccept.jsp" %>

<%
  //String opCode = "2266";
  String opName = "促销品统一付奖";

  String loginNo = (String)session.getAttribute("workNo");
  String ip_Addr = request.getRemoteAddr();
  String loginNoPass = (String)session.getAttribute("password");
  String loginName = (String)session.getAttribute("workName");
  String orgCode = (String)session.getAttribute("orgCode");
  String strRegionCode = orgCode.substring(0,2);
  String IccId = "";
  String cust_address = "";
  String loginname = loginName;
  System.out.println("loginname="+loginname);
%>
<%
  String retFlag="";
  String f2266QueryRetMsg="";//用于判断页面刚进入时的正确性

  String strPhoneNo = request.getParameter("phone_no");
  String strAwardCode = request.getParameter("awardcode");
  String strAwardDetailCode = request.getParameter("detailcode");
  
  String strAwardName = "";
  if("01".equals(strAwardCode))
  {
    strAwardName = "01 --> 营销案赠送";
  }
  else if("02".equals(strAwardCode))
  {
    strAwardName = "02 --> 有条件赠送";
  }
  else if("03".equals(strAwardCode))
  {
    strAwardName = "03 --> 无条件赠送";
  }
  else if("04".equals(strAwardCode))
  {
    strAwardName = "04 --> 积分兑换";
  }
  String strDetailName = request.getParameter("detail_name");
  String strOpCode = request.getParameter("opFlag");			//菜单操作类型
  String strUserPasswd = "";//用户密码
  String opCode = strOpCode;
  String bp_name = "";
  String passwordFromSer = "";

	/*取用户基本信息*/
	String sqlStr = "select nvl(b.cust_name,'NULL'),"+
									"nvl(trim(b.id_iccid),'无'),"+
									"nvl(trim(b.cust_address),'无'),"+
									"user_passwd "+
									"from dcustmsg a, dcustdoc b "+
									"where a.cust_id = b.cust_id "+
									"and a.phone_no = '" + strPhoneNo + "'";
%>
		<wtc:pubselect name="sPubSelect" routerKey="phone" routerValue="<%=strPhoneNo%>" outnum="4">
    <wtc:sql><%=sqlStr%>
    </wtc:sql>
		</wtc:pubselect>
		<wtc:array id="baseArr" scope="end"/>
<%
	if(baseArr!=null&&baseArr.length>0){
		  bp_name = (baseArr[0][0]).trim();
		  IccId = (baseArr[0][1]).trim();
		  cust_address = (baseArr[0][2]).trim();
		  passwordFromSer = (baseArr[0][3]).trim();
	}

  if (bp_name.equals("")){
		retFlag = "1";
	  f2266QueryRetMsg = "用户号码基本信息为空或不存在!<br>";
 	}

	//设置title
	String titlename = "";  //窗体名称
	String op_code = "";  //op_code

	if (strOpCode.equals("2266")){
		titlename = "促销品统一付奖";
	}else if (strOpCode.equals("2279")){
		titlename = "促销品统一付奖冲正";
	}else if (strOpCode.equals("2249")){
		titlename = "促销品统一付奖预约登记";
	}

  System.out.println("strAwardName="+strAwardName);
  System.out.println("strDetailName="+strDetailName);
  System.out.println("strOpCode="+strOpCode);

  strAwardName = strAwardName.substring(strAwardName.indexOf("-->")+4,strAwardName.length());
  strDetailName = strDetailName.substring(strDetailName.indexOf("-->")+4,strDetailName.length());


  System.out.println("strAwardName="+strAwardName);
  System.out.println("strDetailName="+strDetailName);

 	String[] paraAray1 = new String[9];
  paraAray1[0] = loginNo; 			/* 操作工号   */
  paraAray1[1] = loginNoPass; 	/* 操作工号   */
  paraAray1[2] = strOpCode;			/* 操作代码*/
  paraAray1[3] = strPhoneNo;		/* 手机号码   */
  paraAray1[4] = strAwardCode;
  paraAray1[5] = strAwardDetailCode;
  paraAray1[6] = strOpCode;
  paraAray1[7] = strUserPasswd;
	/***
		strcpy(chLoginNo, input_parms[0]);
		strcpy(chLoginPasswd, input_parms[1]);
		strcpy(chOpCode, input_parms[2]);
		strcpy(chPhoneNo, input_parms[3]);
		strcpy(chAwardCode, input_parms[4]);
		strcpy(chDetailCode, input_parms[5]);
		strcpy(chInUserPasswd, input_parms[7]);
	***/
  for(int i=0; i<paraAray1.length; i++)
  {
        System.out.println(paraAray1[i]);
		if( paraAray1[i] == null )
		{
	  	paraAray1[i] = "";
		}
  }
  //retList = impl.callFXService("s2266Init", paraAray1, "12","phone",strPhoneNo);
%>
 	<wtc:service name="s2266Init" routerKey="phone" routerValue="<%=strPhoneNo%>" outnum="13" >
	<wtc:param value="<%=paraAray1[0]%>"/>
	<wtc:param value="<%=paraAray1[1]%>"/>
	<wtc:param value="<%=paraAray1[2]%>"/>
	<wtc:param value="<%=paraAray1[3]%>"/>
	<wtc:param value="<%=paraAray1[4]%>"/>
	<wtc:param value="<%=paraAray1[5]%>"/>
	<wtc:param value="<%=paraAray1[6]%>"/>
	<wtc:param value="<%=paraAray1[7]%>"/>
	</wtc:service>
	<wtc:array id="s2266InitArr" scope="end"/>
<%
 	int errCode = retCode==""?999999:Integer.parseInt(retCode);
  String errMsg = retMsg;

  if(s2266InitArr == null)
  {
		retFlag = "1";
	  f2266QueryRetMsg = "s2266Init查询号码基本信息为空!<br>" + "errCode: " + errCode + "<br>errMsg: " +  errMsg;
  }else if (errCode != 0){
  	retFlag = "1";
    f2266QueryRetMsg = "s2266Init查询用户促销品统一付奖信息失败!<br>" + "errCode: " + errCode + "<br>errMsg: " +  errMsg;
 	}
%>
	 <wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="phone" routerValue="<%=strPhoneNo%>" id="sLoginAccept"/>
<%
		/****得到打印流水****/
		String printAccept="";
	  	printAccept = sLoginAccept;
	  	String cnttActivePhone = strPhoneNo;
%>
<html>
<head>
<%@ include file="../../npage/s1555/head_2266_javascript.htm" %>
<title><%=titlename%></title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<script language="JavaScript">
  <%if(retFlag.equals("1")){%>
    rdShowMessageDialog("<%=f2266QueryRetMsg%>");
   window.location.href="f2266.jsp?activePhone=<%=strPhoneNo%>";
  <%}%>
<!--
  //定义应用全局的变量
  var SUCC_CODE	= "0";   		//自己应用程序定义
  var ERROR_CODE  = "1";			//自己应用程序定义
  var YE_SUCC_CODE = "0000";	 	//根据营业系统定义而修改

onload=function()
{
	if((<%=strAwardCode%>=="01")&&(<%=strAwardDetailCode%>=="2520"))
	{
		document.all.opNote.readOnly = false;
	}
}

 function changradio()
 {
		document.all.awardNo.value = "";
 		document.all.awardInfo.value = "";

		if (document.frm.opcode.value != "2279"){
			document.all.selectaward.style.display = "";
		}
		document.all.confirm.disabled = false;
 }

//校验是否选中领奖纪录
function checkIfSelect()
{
	var radio1 = document.getElementsByName("radio1");
	var doc = document.forms[0];
	var flag = 0;
	for(var i=0; i<radio1.length; i++)
	{
		if(radio1[i].checked)
		{
			var vFlag = eval("doc.flag"+radio1[i].value+".value.substr(0,4)");
			if(vFlag=="未领过期" )
			{
					rdShowConfirmDialog("奖品在规定时间范围内未领取,现已经不能领取！");
					return false;
			}

			if(document.all.opcode.value=="2266" && vFlag=="已领取" )
			{
					rdShowConfirmDialog("促销品已经领取！");
					return false;
			}

			if (document.all.opcode.value=="2249" && vFlag=="已登记")
			{
				rdShowConfirmDialog("促销品已登记！");
				return false;
			}
			document.frm.awardId.value=eval("doc.awardId"+radio1[i].value+".value");
			document.frm.ressum.value=eval("doc.ressum"+radio1[i].value+".value");
			document.frm.flag.value=eval("doc.flag"+radio1[i].value+".value");
			document.frm.awardidname.value=eval("doc.awardidname"+radio1[i].value+".value");
			document.frm.payAccept.value=eval("doc.payAccept"+radio1[i].value+".value");
			document.frm.printPackageCont.value=eval("doc.printPackageCont"+radio1[i].value+".value");
			if (document.frm.opcode.value == "2279")
			{
				document.frm.awardInfo.value = eval("doc.awardidname"+radio1[i].value+".value");
				document.frm.ressum.value = eval("doc.ressum"+radio1[i].value+".value");
			}
			flag=1;
			break;
		}
	}
	if(flag==0)
	{
		rdShowConfirmDialog("请选择一条领奖纪录！");
		return false;
	}
	return true;
}


/******为备注赋值********/
function setOpNote()
{
	if(document.frm.opNote.value=="")
	{
		if (document.frm.opcode.value == "2279"){
	  	document.frm.opNote.value = "用户"+document.frm.phoneNo.value+"领奖冲正";
	  }else if (document.frm.opcode.value == "2249"){
	  	document.frm.opNote.value = "用户"+document.frm.phoneNo.value+"预约登记";
		}else{
			document.frm.opNote.value = "用户"+document.frm.phoneNo.value+"领奖";
		}
	}
	return true;
}

function printCommit()
{
	getAfterPrompt();
	document.all.confirm.disabled = true;
	with(document.frm){

		if (opcode.value == "2266" || opcode.value == "2249" || opcode.value == "2279"){
			//如果是付奖或登记
//			if (awardId.value.substring(0,1) == "G"){
			if (opcode.value != "2279"){
				if(awardNo.value==""){
					rdShowConfirmDialog("请选择促销品!");
					awardNo.focus();
					return false;
				}
			 }

				setOpNote();//备注赋值

				if (document.frm.opNote.value.length > 30){
			 		rdShowConfirmDialog("输入的备注信息过长");
					return false;
				}
		}else{
			document.frm.opNote.value = "促销品统一付奖冲正";
		}

	if(!(checkIfSelect()))
		return false;

	if (awardId.value.substring(0,1) != "D"){
		document.frm.printPackageCont.value = document.all.awardInfo.value + "~"+document.frm.ressum.value+"~";
	}

  var varPrintInfo = '<%=loginName%>'+"|"
    +document.frm.phoneNo.value.trim()+"|"
    +document.frm.bp_name.value.trim()+"|"
  	+document.frm.IccId.value.trim()+"|"
  	+document.frm.cust_address.value.trim()+"|"
  	+'<%=strOpCode%>'+"|"
  	+document.frm.printAccept.value.trim()+"|"
  	+document.frm.awardInfo.value.trim()+"|"
  	+document.frm.opNote.value.trim()+"|"
  	+document.frm.ressum.value.trim()+"|"
  	+document.frm.printPackageCont.value.trim()+"|";

	//打印工单并提交表单
	var ret = showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes",varPrintInfo);
  	if(typeof(ret)!="undefined")
  	{
  		if((ret=="confirm"))
  		{
	    	if(rdShowConfirmDialog('确认电子免填单吗？如确认,将提交本次业务!')==1)
	    	{
	    		if(awardId.value.substring(0,1)=='G')
	    		{
	    			awardId.value=awardId.value+"|"+awardNo.value;

	    		}
	    		document.all.printcount.value="1";
		    	frmCfm();
	      	}
		}

	  	if(ret=="continueSub"){
	    	if(rdShowConfirmDialog('确认要提交信息吗？')==1)
	    	{
	    		if(awardId.value.substring(0,1)=='G')
	    		{
	    			awardId.value=awardId.value+"|"+awardNo.value;

	    		}
	    		document.all.printcount.value="0";
		    	frmCfm();
	      	}
		}
	}else
	{
	  	if(rdShowConfirmDialog('确认要提交信息吗？')==1)
	  	{
	  		  if(awardId.value.subtring(0,1)=='G')
	    		{
	    			awardId.value=awardId.value+"|"+awardNo.value;

	    		}
	    	document.all.printcount.value="0";
		  	frmCfm();
	    }
	}
	return true;
	}
}


/**查询奖品**/
function getAwardInfo()
{
	//调用公共js得到奖品
  var pageTitle = "促销品代码查询";
  var fieldName = "选择|促销品代码|促销品名称|数量|";//弹出窗口显示的列、列名
  var sqlStr = "";
  if ("P" == document.frm.awardId.value.substring(0,1))//礼品包
  {
  	sqlStr = "select distinct '选项',a.PACKAGE_CODE,a.PACKAGE_NAME,' ' "+
  					 "from dbgiftrun.RS_PROGIFT_PACKAGE_INFO a, dbgiftrun.rs_chngroup_rel b "+
  					 "where a.group_id = b.parent_group_id "+
  					 " and a.valid_flag=1 "+
  					 " and a.PACKAGE_CODE='"+document.frm.awardId.value.substring(1,document.frm.awardId.value.length)
  					 +"' and b.group_id=(select group_id from dloginmsg where login_no='"+"<%=loginNo%>"+"')";
  }else if ("G" == document.frm.awardId.value.substring(0,1))//礼品等级
  {
  	sqlStr="select distinct '选项',b.res_code,b.res_name,' ' "+
  				 "from dbgiftrun.sChnActiveGrade a, dbgiftrun.rs_code_info b ,dbgiftrun.sChnActiveGradeCfg c,dbgiftrun.rs_chngroup_rel d "+
  				 "where a.GRADE_CODE = c.GRADE_CODE "+
  				 "and b.RES_CODE = c.RES_CODE "+
  				 "and c.group_id = d.parent_group_id "+
  				 "and c.PACKAGE_FLAG = 'N' "+
  				 "and d.group_id = (select group_id from dloginmsg where login_no='"+"<%=loginNo%>"+"') "+
  				 "and a.grade_code= '"+document.frm.awardId.value.substring(1,document.frm.awardId.value.length)+"' "+
  				 "union all "+
  				 "select '选项','P'||d.PACKAGE_CODE,d.PACKAGE_NAME,' ' "+
					 "from dbgiftrun.sChnActiveGrade a, dbgiftrun.sChnActiveGradeCfg b,dbgiftrun.rs_chngroup_rel c,dbgiftrun.RS_PROGIFT_PACKAGE_INFO d "+
					 "where a.GRADE_CODE = b.GRADE_CODE "+
 					 " and b.group_id = c.parent_group_id "+
 					 " and b.RES_CODE = d.PACKAGE_CODE "+
 					 " and b.PACKAGE_FLAG = 'Y' "+
 					 " and d.valid_flag=1 " +
 					 " and c.group_id = (select group_id from dloginmsg where login_no='"+"<%=loginNo%>"+"') "+
 					 " and a.grade_code='"+document.frm.awardId.value.substring(1,document.frm.awardId.value.length)+"' ";
  }else if ("D" == document.frm.awardId.value.substring(0,1))//BOSS动态礼口包
  {
	sqlStr="select distinct '选项',a.package_code,c.res_name,b.res_sum "+
		   "from dDynamicPackage a, dDynamicPackageDetail b,dbgiftrun.rs_code_info c "+
		   "where a.package_code = b.package_code "+
		   "and b.res_code = c.RES_CODE "+
		   "and a.package_code = '"+document.frm.awardId.value.substring(1,document.frm.awardId.value.length)+"' ";
  }else{
  	sqlStr="select '选项',res_code,res_name,' ' from dbgiftrun.rs_code_info where res_code = '"+document.frm.awardId.value+"' order by res_code";
  }

  var selType = "S";    //'S'单选；'M'多选
  var retQuence = "2|1|2|";//返回字段
  var retToField = "awardNo|awardInfo|";//返回赋值的域

  if(PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField))
	changeResCode();
}
function PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
  var path = "<%=request.getContextPath()%>/npage/public/fPubSimpSel.jsp";
  path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
  path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
  path = path + "&selType=" + selType;
  retInfo = window.showModalDialog(path);
  if(retInfo ==undefined)
  {
		return false;
  }

  var chPos_field = retToField.indexOf("|");
  var chPos_retStr;
  var valueStr;
  var obj;
  var iRec = 0;
  while(chPos_field > -1)
  {
    iRec = iRec+1;
    obj = retToField.substring(0,chPos_field);
    chPos_retInfo = retInfo.indexOf("|");
    valueStr = retInfo.substring(0,chPos_retInfo);
		if (iRec ==2)
		{						
				document.all(obj).value = valueStr;
   	   }else
   	   {
    		document.all(obj).value = valueStr;
   	   }
    retToField = retToField.substring(chPos_field + 1);
    retInfo = retInfo.substring(chPos_retInfo + 1);
    chPos_field = retToField.indexOf("|");
  }
	return true;
}

function cardInfo(packet)
{
	var result = packet.data.findValueByName("result");
	if(result == "true")
	{
		document.forms[0].cardType.value = packet.data.findValueByName("card_type");
		document.forms[0].cardNum.value = packet.data.findValueByName("card_num");
		document.all.checkCardNo.style.display = "block";
	}
}

/*奖品名称变化触发函数*/
function changeResCode()
{
	if (document.frm.opcode.value == "2266")
	{
		var res_code = document.forms[0].awardNo.value;
		checkResName(res_code);
	}
}

function checkResName(res_code)
{
	//数据初始化
	document.forms[0].cardType.value = "";
	document.forms[0].cardNum.value = "";
	document.forms[0].card_no.value = "";
	document.all.checkCardNo.style.display = "none";

	if(res_code != "00000000")
	{
		//一定要是同步调用.
		var myPacket = new AJAXPacket("fGetCardInfo.jsp", "查询奖品类别明细,请稍等...");
		myPacket.data.add("res_code",res_code);
	    core.ajax.sendPacket(myPacket,cardInfo);
	    myPacket = null;
	}
}

/*查询手机充值卡*/
function checkCard()
{
	var prop="dialogHeight:300px; dialogWidth:550px; dialogLeft:400px; dialogTop:400px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
	card_num = parseInt(document.forms[0].cardNum.value);
	if(card_num == -1)
	{
		card_num = document.forms[0].ressum.value;
	}
	card_type = document.forms[0].cardType.value;
	var ret = window.showModalDialog("./f2266_query_card.jsp?card_num="+card_num+"&card_type="+card_type,"",prop);
	if(ret)
	{
		document.all.card_no.value = ret;
	}
	else
	{
		//do Nothing
		;
	}
}

//-->
</script>
</head>


<body>
<form name="frm" method="post">
<%@ include file="/npage/include/header.jsp" %>
<div class="title">
    <div id="title_zi">用户信息</div>
</div>
<table cellspacing="0">
    <tr>
        <td class="blue">手机号码</td>
        <td>
            <input name="phoneNo" class="InputGrey" type="text" id="phoneNo" value="<%=strPhoneNo%>" readonly>
        <td class="blue">客户名称</td>
        <td>
            <input name="bp_name" class="InputGrey" type="text" id="bp_name" size="60" value="<%=bp_name%>" readonly>
        </td>
    </tr>
</table>
<table cellspacing="0">
    <tr>
        <td class="blue">身份证号</td>
        <td>
            <input name="IccId" class="InputGrey" type="text" id="IccId" value="<%=IccId%>" readonly>
        </td>
        <td class="blue">客户地址</td>
        <td>
            <input name="cust_address" class="InputGrey" type="text" id="cust_address" size="60" value="<%=cust_address%>" readonly>
        </td>
    </tr>
</table>
 </div>
 <div id="Operation_Table">
	<div class="title">
		<div id="title_zi">付奖明细</div>
	</div>
	<TABLE cellSpacing="0">
   	<TBODY>
		  <tr align="center">
	  		<th>选择</td>
			  <th>奖品类别</th>
			  <th>营销案名称</th>
			  <th>数量</th>
			  <th>奖品名称</th>
			  <th>领取标志</th>
			  <th>中奖日期</th>
			  <th>操作流水</th>
			  <th>领奖工号</th>
			  <th>领奖日期</th>
		  </tr>
		  </tr>
  <%
  		String tbclass="";
		  for(int j=0;j<s2266InitArr.length;j++){
		  	if(j%2==0){
		  		tbclass="Grey";
		  	}else{
		  		tbclass="";
		  	}
   %>
			<tr align="center">
				<td class="<%=tbclass%>"><input type="radio"  name="radio1" onClick = "changradio()" value="<%=j%>"></td>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][1]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][2]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][3]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][4]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][5]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][6]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][7]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][8]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][9]%></TD>

				<input name="awardId<%=j%>" type="hidden" value="<%=s2266InitArr[j][0]%>">
				<input name="ressum<%=j%>" type="hidden" value="<%=s2266InitArr[j][3]%>">
				<input name="awardidname<%=j%>" type="hidden" value="<%=s2266InitArr[j][4]%>">
				<input name="flag<%=j%>" type="hidden" value="<%=s2266InitArr[j][5]%>">
				<input name="payAccept<%=j%>" type="hidden" value="<%=s2266InitArr[j][7]%>">
				<input name="printPackageCont<%=j%>" type="hidden" value="<%=s2266InitArr[j][11]%>">
			</tr>
	<%
		}
	%>
 		</TBODY>
	</TABLE>
  <table cellspacing="0">
		<tr id = "selectaward" style="display:none" >
			<td class="blue">奖品名称</td>
			<td colspan="3">
				<input type="text" name="awardNo" size="8" maxlength="8" v_must=1>
				<input type="text" name="awardInfo" size="30" v_must=1 v_name=奖品名称  onchange="changeResCode()">&nbsp;&nbsp;
				<font class="orange">*</font>
			  <input name=awardInfoQuery type=button class="b_text"  style="cursor:hand" onClick="if(checkIfSelect()) getAwardInfo()" value=查询>
      </tr>
          <!-- 手机充值卡输入卡卡号 -->
     <tr  id="checkCardNo" style="display:none">
 		<td class="blue">手机充值卡卡号</td>
   		<td nowrap>
  	  	<input id="card_no"  type="text" name="card_no" size="40"  readonly >
  	  	<font color="orange">*</font>
      	<input  type="button" name="card_no_qry" class="b_text" value="查询" onClick="checkCard()">
      	<input type="hidden" name="cardType">
		<input type="hidden" name="cardNum">
   		</td>
  	</tr>

	  <tr>
    	<td class="blue">备注</td>
      <td colspan="3">
      	<input name="opNote" type="text" id="opNote" class="button" size="60" maxlength="60" onFocus="setOpNote();" readonly>
    	</td>
    </tr>
    <tr>
    	<td colspan="4" id="footer">
				<div align="center">
				<input name="confirm" class="b_foot" id="confirm" type="button"  value="确认&打印" onClick="printCommit()" >
					&nbsp;
				<input name="reset" class="b_foot" type="reset" value="清除" >
					&nbsp;
				<input name="back" class="b_foot" onClick="window.location.href='f2266.jsp?activePhone=<%=strPhoneNo%>'" type="button" value="返回">
					&nbsp;
				</div>
			</td>
   	</tr>
	</TABLE>
 <%@ include file="/npage/include/footer.jsp" %>
  <input type="hidden" name="loginname" value="">
  <input type="hidden" name="awardId" value="">
  <input type="hidden" name="flag" value="">
  <input type="hidden" name="awardidname" value="">
  <input type="hidden" name="payAccept" value="">
  <input type="hidden" name="titlename" value="">
  <input type="hidden" name="regioncode" value="<%=strRegionCode%>">
  <input type="hidden" name="opcode" value="<%=strOpCode%>">
  <input type="hidden" name="awardcode" value="<%=strAwardCode%>">
  <input type="hidden" name="awarddetailcode" value="<%=strAwardDetailCode%>">
  <input type="hidden" name="awardname" value="<%=strAwardName%>">
  <input type="hidden" name="ressum" value="">
  <input type="hidden" name="detailname" value="<%=strDetailName%>">
  <input type="hidden" name="printAccept" value="<%=printAccept%>">
  <input type="hidden" name="printPackageCont" value="">
  <input type="hidden" name="rescode_sum_new" value="1">
  <input type="hidden" name="cust_info">
  <input type="hidden" name="opr_info">
  <input type="hidden" name="note_info1">
  <input type="hidden" name="note_info2">
  <input type="hidden" name="note_info3">
  <input type="hidden" name="note_info4">
  <input type="hidden" name="printcount">
  <input type="hidden" name="smName">
  <input type="hidden" name="phone_no" value="<%=strPhoneNo%>">
</form>
</body>
</html>

