<%
/********************
 version v2.0
 开发商: si-tech
 模块: 退出欢乐家庭
 create by wanglma 20110429
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml">

<%
  response.setHeader("Pragma","No-Cache"); 
  response.setHeader("Cache-Control","No-Cache");
  response.setDateHeader("Expires", 0); 
  request.setCharacterEncoding("GBK");
%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ include file="../../npage/bill/getMaxAccept.jsp"%>
<%@ page import="com.sitech.boss.pub.util.Encrypt"%>
<%
  String opCode = request.getParameter("opCode");
  String opName = "退出欢乐家庭";
  String loginNo = (String)session.getAttribute("workNo");
  String loginName = (String)session.getAttribute("workName");
  String passWord = (String)session.getAttribute("password");
  String orgCode = (String)session.getAttribute("orgCode");
  String regionCode = (String)session.getAttribute("regCode");
%>
<%
  String phoneNo = request.getParameter("activePhone"); /* 家长号码*/
  String memberNo = request.getParameter("exitPhone"); /* 成员号码*/
  String flag = request.getParameter("flag"); /* 标志位，为0时 ，传入的是成员，1 传入的是家长*/
  String[][] famArr = new String[][]{};
  String memberNoFlag = "";
  if("0".equals(flag)){
     memberNoFlag =  memberNo; //把家长号存起来
  }
  /* 流水 */
  String printAccept="";
  printAccept = getMaxAccept();
  String  cyNo="",jzName="", custName ="",  custAddr="",mainFeeId="",famProdId="", opFuFeeId="", opMainFeeId="", idCardType="",  idCardNo="", custType="",  smName ="",  localName="",  mainFee="",  combo ="", opMainFee="", opFeeType="";
%>
    <wtc:service name="sd572Init" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode" retmsg="retMsg" outnum="20">
	<wtc:param value="<%=printAccept%>"/>
	<wtc:param value="01"/>
	<wtc:param value="<%=opCode%>"/>		
	<wtc:param value="<%=loginNo%>"/>
	<wtc:param value="<%=passWord%>"/>
	<%
	  if("1".equals(flag)){
	%>
	<wtc:param value="<%=memberNo%>"/>
	<wtc:param value=""/>
	<wtc:param value="<%=phoneNo%>"/>
	<%}else{%>
	<wtc:param value="<%=phoneNo%>"/>
	<wtc:param value=""/>
	<wtc:param value="<%=memberNo%>"/>
	<%}%>
	<wtc:param value=""/>
	</wtc:service>
    <wtc:array id="resultArr" scope="end" start="0" length="16"/>
    <wtc:array id="resultArr1" scope="end" start="16" length="4"/>
<%
   if(resultArr.length > 0){
      custName = resultArr[0][1];
      custAddr = resultArr[0][2];
      idCardType = resultArr[0][3];
      idCardNo = resultArr[0][4];
      smName = resultArr[0][5];
      custType = resultArr[0][6];
      localName = resultArr[0][7];
      mainFeeId = resultArr[0][8]; //成员当前主资费
      mainFee = resultArr[0][9];
      combo = resultArr[0][10];
      opMainFeeId = resultArr[0][11];//要办理主资费Id
      opFuFeeId = resultArr[0][12];//要办理附加资费Id
      famProdId = resultArr[0][13];
      cyNo = resultArr[0][14]; //成员号码
      jzName = resultArr[0][15]; //家长号码
   }
   
   famArr = resultArr1 ; //家庭信息
   for(int y=0;y<resultArr.length;y++){
      for(int t=0;t<resultArr[y].length;t++){
         System.out.println("---------------resultArr["+y+"]["+t+"]---------------------  "+resultArr[y][t]);
      }
   }
   if(!"000000".equals(retCode)){
      %>
        <script language="javascript">
        	rdShowMessageDialog("操作失败！errCode:<%=retCode%>   errMsg:<%=retMsg%>",0);
        	window.location="fd570.jsp?opCode=d573&activePhone=<%=phoneNo%>&opName=<%=opName%>";
        </script>
      <%
   }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>退出欢乐家庭</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">

<script language="JavaScript">

<!--
  //定义应用全局的变量

  function frmCfm()
  {
 	frm.submit();
	return true;
  }
  
  function controlButt(subButton){
	subButt2 = subButton;
    subButt2.disabled = true;
	setTimeout("subButt2.disabled = false",3000);
  }

 function printCommitOne(subButton){
 	getAfterPrompt();
	//controlButt(subButton);//延时控制按钮的可用性
	subButton.disabled = true;
 	document.frm.action = "fd573_cfm.jsp";
	//打印工单并提交表单
	showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes");
	if(rdShowConfirmDialog('确认电子免填单吗？如确认,将提交本次业务!')==1)
	{
		frmCfm();
	}else{
		subButton.disabled = false;
	}
}

 function showPrtDlg(printType,DlgMessage,submitCfm)
  {  //显示打印对话框
		var h=210;
		var w=400;
		var t=screen.availHeight/2-h/2;
		var l=screen.availWidth/2-w/2;

		var pType="subprint";                                      // 打印类型：print 打印 subprint 合并打印
		var billType="1";                                          //  票价类型：1电子免填单、2发票、3收据
		var sysAccept="<%=printAccept%>";                            // 流水号
		var printStr=printInfo(printType);                         //调用printinfo()返回的打印内容
		var mode_code=null;                                        //资费代码
		var fav_code=null;                                         //特服代码
		var area_code=null;                                        //小区代码
		var opCode="<%=opCode%>";                                  //操作代码
		var phoneNo="<%=phoneNo%>";                 //客户电话

		var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
		var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc.jsp?DlgMsg=" + DlgMessage+ "&submitCfm=" + submitCfm;
		path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode="+opCode+"&sysAccept="+sysAccept+"&phoneNo="+phoneNo+"&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
		var ret=window.showModalDialog(path,printStr,prop);
		return ret;
  }

  function printInfo(printType)
  {
		var exeDate = "<%=new java.text.SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(new java.util.Date())%>";//得到执行时间
		var count=0;
		var cust_info=""; //客户信息
		var opr_info=""; //操作信息
		var note_info1=""; //备注1
		var note_info2=""; //备注2
		var note_info3=""; //备注3
		var note_info4=""; //备注4
		var retInfo = "";  //打印内容

		cust_info+="手机号码："+$("#phoneNo").val()+"|";
		if("<%=flag%>" == "1"){
			cust_info+="客户姓名：<%=jzName%>|";
		}else{
		    cust_info+="客户姓名："+$("#custName").val()+"|";	
		}
		

		
		opr_info+="业务类型: 办理退出欢乐家庭业务|";
		<%
		   if("1".equals(flag)){
		     %>
		       opr_info+="<%=memberNo%>号码退出家庭，自次月起将不再享受欢乐家庭优惠套餐。|";
		     <%
		   }else{
		%>
 		opr_info+="<%=phoneNo%>号码退出家庭，自次月起将不再享受欢乐家庭优惠套餐。|";
 	    <%}%>
 	    opr_info+="移动手机号码退出家庭后，自下月起按照神州行畅听卡资费收取。|";
 	    note_info1+="您办理的办理退出欢乐家庭套餐当月办理次月生效。|";
 	    note_info1+="家庭内由手机主卡统一缴费并统一付费，若主卡欠费，家庭内所有号码将停机。|";
 	    note_info1+="欢乐家庭成员必须归属同一地区。|";
		retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
		retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
		return retInfo;
  }

//-->
//事中提示

</script>

</head>


<body>
<form name="frm" method="post">
	<%@ include file="/npage/include/header.jsp" %>

		<div class="title">
			<div id="title_zi"><%=opName%></div>
		</div>

     <table>
	<tr>
		<td class="blue" width="20%">
			成员号码
		</td>
		<td width="30%">
			<input type="text" name="memberNo" id="memberNo" value="<%=cyNo%>" v_must="1" class="InputGrey" readonly>
		</td>
		<td class="blue"width="20%">
			成员名称
		</td>
		<td width="30%">
			<input type="text" name="custName" id="custName" size="40" value="<%=custName%>" v_must="1" class="InputGrey" readonly>
		</td>
	</tr>
	<tr>
		<td class="blue" width="20%">
			成员地址
		</td>
		<td colspan="3">
			<input name="custAddr" id="custAddr" type="text" size="60" class="InputGrey" value="<%=custAddr%>" readonly>
		</td>
	</tr>
	<tr>
		<td class="blue" width="20%">
			成员证件类型
		</td>
		<td width="30%">
			<input name="idCardType" id="idCardType" type="text" class="InputGrey" value="<%=idCardType%>" readonly>
		</td>
		<td class="blue" width="20%">
			成员证件号码
		</td>
		<td width="30%">
			<input type="text" name="idCardNo" id="idCardNo" size="40" value="<%=idCardNo%>" v_must="1" class="InputGrey" readonly>
		</td>
	</tr>
	<tr>
		<td class="blue" width="20%">
			品牌名称
		</td>
		<td width="30%">
			<input name="smName" id="smName" type="text" class="InputGrey" value="<%=smName%>" readonly>
		</td>
		<td class="blue" width="20%">
			成员归属地
		</td>
		<td width="30%">
			<input type="text" name="localName" id="localName" size="40" value="<%=localName%>" v_must="1" class="InputGrey" readonly>
		</td>	
	</tr>
	<tr>
		<td class="blue" width="20%">
			当前主资费
		</td>
		<td width="30%">
			<input name="mainFee" id="mainFee" type="text" class="InputGrey" size="40" value="<%=mainFee%>" readonly>
		</td>
		<td class="blue">
			办理套餐类型
		</td>
		<td>
			<input name="combo" id="combo" type="text" class="InputGrey" size="40" value="欢乐家庭<%=combo%>套餐" readonly>
		</td>
	</tr>
	
</table>

<div id="Operation_Table">
<div class="title">
	<div id="title_zi">业务明细</div>
</div>
		<TABLE cellSpacing="0">
          <TBODY>
		  <tr>
			<tr>
		      <th align=center>手机号码</th>
			  <th align=center>角色类型</th>
			  <th align=center>生效时间</th>
			  <th align=center>失效时间</th>
			</tr>
			<%
			 for(int j=0;j<famArr.length;j++){
			%>
		    <tr>
			  <TD align=center class="Grey"><%=famArr[j][0]%></TD>
			  <TD align=center class="Grey">
			  	<%
			  	  if("11100".equals(famArr[j][1])){
			  	 %>
			  	  家长
			  	  <%}else{%>
			  	  成员
			  	  <%}%>
			  	 </TD>
			  <TD align=center class="Grey"><%=famArr[j][2]%></TD>
			  <TD align=center class="Grey"><%=famArr[j][3]%></TD>
			</tr>				
			<%
			 }
			%>
		</table>
	<table>
		  <tr>
            <td colspan="4" id="footer"> <div align="center">
                &nbsp;
				<input name="confirm" id="confirm" type="button" class="b_foot"  value="确认&打印" onClick="printCommitOne(this)" >
                &nbsp;
                <input name="reset" type="hidden" class="b_foot" value="清除" >
                &nbsp;
                <input name="back" onClick="history.go(-1);" type="button" class="b_foot" value="返回">
                &nbsp;
				</div>
			</td>
          </tr>
      </table>
      

    <input type="hidden" name="opCode" value="<%=opCode%>"  />
    <input type="hidden" name="phoneNo" id="phoneNo" value="<%=phoneNo%>"  />
    <input type="hidden" name="opMainFeeId" value="<%=opMainFeeId%>"  />
    <input type="hidden" name="opFuFeeId" value="<%=opFuFeeId%>"  />
    <input type="hidden" name="mainFeeId" value="<%=mainFeeId%>"  />
    <input type="hidden" name="famProdId" value="<%=famProdId%>"  />
    <input type="hidden" name="flag" value="<%=flag%>"  />
    <input type="hidden" name="memberNoFlag" value="<%=memberNoFlag%>"  />
    <%@ include file="/npage/include/footer.jsp" %>   
</form>
</body>
</html>
