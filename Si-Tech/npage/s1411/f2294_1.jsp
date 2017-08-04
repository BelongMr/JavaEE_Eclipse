   
<%
/********************
 version v2.0
 开发商 si-tech
 update hejw@2009-2-24
********************/
%>
              
<%
  String opCode = "2294";
  String opName = "集团客户预存送礼";
%>              

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http//www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http//www.w3.org/1999/xhtml">
<%@ include file="/npage/include/public_title_name.jsp" %> 
<%
  response.setHeader("Pragma","No-cache");
  response.setHeader("Cache-Control","no-cache");
  response.setDateHeader("Expires", 0);
%>

<%@ page contentType="text/html;charset=gb2312"%>
<%@ page import="java.text.*" %>
<%@ page import="com.sitech.boss.pub.util.Encrypt"%>
<%@ include file="../../npage/bill/getMaxAccept.jsp" %>


<%		
  String loginNo = (String)session.getAttribute("workNo");
  String loginName = (String)session.getAttribute("workName");
  String regionCode = (String)session.getAttribute("regCode");
  
%>
<%
String retFlag="",retMsg="";
  String[] paraAray1 = new String[3];
  String phoneNo = request.getParameter("srv_no");
  String opcode = request.getParameter("opcode");
  String passwordFromSer="";
  String dept=request.getParameter("dept");
 
 
  
  paraAray1[0] = phoneNo;		/* 手机号码   */ 
  paraAray1[1] = opcode; 	    /* 操作代码   */
  paraAray1[2] = loginNo;	    /* 操作工号   */

  for(int i=0; i<paraAray1.length; i++)
  {		
	if( paraAray1[i] == null )
	{
	  paraAray1[i] = "";
	  
	}
  }
 /* 输出参数 返回码，返回信息，客户姓名，客户地址，证件类型，证件号码，业务品牌，
 			归属地，当前状态，VIP级别，当前积分,可用预存
 */

//  retList = impl.callFXService("s2294Init", paraAray1, "22","phone",phoneNo);
  %>
  
    <wtc:service name="s2294Init" outnum="22" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
			<wtc:param value="<%=paraAray1[0]%>" />
			<wtc:param value="<%=paraAray1[1]%>" />
			<wtc:param value="<%=paraAray1[2]%>" />		
		</wtc:service>
		<wtc:array id="result_t" scope="end" />  
  
  <%
  String  bp_name="",bp_add="",cardId_type="",cardId_no="",sm_code="",region_name="",run_name="",vip="",posint="",prepay_fee="",
  vUnitId="",vUnitName="",vUnitAddr="",vUnitZip="",vServiceNo="",vServiceName="",vContactPhone="",vContactPost="";
  String zhanbi_name="",product_name="";
  String[][] tempArr= new String[][]{};
  String errCode = code;
  String errMsg = msg;
  if(result_t == null)
  {
	if(!retFlag.equals("1"))
	{
		System.out.println("retFlag="+retFlag);
	   retFlag = "1";
	   retMsg = "s8030Init查询号码基本信息为空!<br>errCode: " + errCode + "<br>errMsg+" + errMsg;
    }    
  }else if(!(result_t == null))
  {System.out.println("errCode="+errCode);
  System.out.println("errMsg="+errMsg);
  if(!errCode.equals("000000")){%>
<script language="JavaScript">
<!--
  	rdShowMessageDialog("错误代码<%=errCode%>错误信息<%=errMsg%>",0);
 	 history.go(-1);
  	//-->
  </script>
  <%}
	if (errCode.equals("000000")){
	    bp_name = result_t[0][2];//机主姓名
	    bp_add = result_t[0][3];//客户地址
	    cardId_type = result_t[0][4];//证件类型
	    cardId_no = result_t[0][5];//证件号码
	    sm_code = result_t[0][6];//业务品牌
	    region_name = result_t[0][7];//归属地
	    run_name = result_t[0][8];//当前状态
	    vip = result_t[0][9];//ＶＩＰ级别
	    posint = result_t[0][10];//当前积分
	    prepay_fee = result_t[0][11];//可用预存
	    vUnitId = result_t[0][12];//集团ID
	    vUnitName = result_t[0][13];//集团名称
	    vUnitAddr = result_t[0][14];//单位地址
	    vUnitZip = result_t[0][15];//单位邮编
	    vServiceNo = result_t[0][16];//集团工号
	    vServiceName = result_t[0][17];//集团工号名称
	    vContactPhone = result_t[0][18];//联系电话
	    vContactPost = result_t[0][19];//个人邮编
	    zhanbi_name = result_t[0][20];//集团类别
	    product_name = result_t[0][21];//集团产品
  }
}
%>
 <%  //优惠信息//********************得到营业员权限，核对密码，并设置优惠权限*****************************//   

  String[][] favInfo = (String[][])session.getAttribute("favInfo"); //数据格式为String[0][0]---String[n][0]
  boolean pwrf = false;//a272 密码免验证
  String handFee_Favourable = "readonly";        //a230  手续费
  int infoLen = favInfo.length;
  String tempStr = "";
  for(int i=0;i<infoLen;i++)
  {
    tempStr = (favInfo[i][0]).trim();
    if(tempStr.compareTo("a272") == 0)
    {
      pwrf = true;
    }
	
  }
 
  String passTrans=WtcUtil.repNull(request.getParameter("cus_pass")); 
  if(!pwrf)
  {
     String passFromPage=Encrypt.encrypt(passTrans);
     if(0==Encrypt.checkpwd2(passwordFromSer.trim(),passFromPage))	{
	   if(!retFlag.equals("1"))
	   {
	      retFlag = "1";
          retMsg = "密码错误!";
	   }
	    
    }       
  }
 %>
<%
//******************得到下拉框数据***************************//
String printAccept="";
printAccept = getMaxAccept();
System.out.println(printAccept);
String exeDate="";
exeDate = getExeDate("1","1141");

  //赠送礼品
  String sqlAgentCode = " select  unique gift_code,trim(gift_name) from sGrpGiftCfg where region_code='" + regionCode + "' and valid_flag='Y'";
  System.out.println("sqlAgentCode====="+sqlAgentCode);
  //ArrayList agentCodeArr = co.spubqry32("2",sqlAgentCode);
  %>
  
 	<wtc:pubselect name="sPubSelect" outnum="2" retmsg="msg1" retcode="code1" routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=sqlAgentCode%></wtc:sql>
 	  </wtc:pubselect>
	 <wtc:array id="result_t1" scope="end"/> 
  
  <%
  String[][] agentCodeStr =result_t1;
  //应收预存
  String sqlPhoneType = "select gift_code,pay_money from sGrpGiftCfg where region_code='" + regionCode + "' and valid_flag='Y'";
  System.out.println("sqlPhoneType====="+sqlPhoneType);
  //ArrayList phoneTypeArr = co.spubqry32("2",sqlPhoneType);
  
  %>
  
		<wtc:pubselect name="sPubSelect" outnum="2" retmsg="msg2" retcode="code2" routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=sqlPhoneType%></wtc:sql>
 	  </wtc:pubselect>
	 <wtc:array id="result_t2" scope="end"/>  
  
  <%
  String[][] phoneTypeStr = result_t2;
 
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>集团客户预有礼</title>
<META content="no-cache" http-equiv="Pragma">
<META content="no-cache" http-equiv="Cache-Control">
<META content="0" 	     http-equiv="Expires" > 
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
 
<script language="JavaScript">

<!--
  //定义应用全局的变量
  var SUCC_CODE	= "0";   		//自己应用程序定义
  var ERROR_CODE  = "1";			//自己应用程序定义
  var YE_SUCC_CODE = "0000";		//根据营业系统定义而修改

  var oprType_Add = "a";
  var oprType_Upd = "u";
  var oprType_Del = "d";
  var oprType_Qry = "q";

  var arrPhoneType = new Array();//手机型号代码
  var arrPhoneName = new Array();//手机型号名称
  var arrAgentCode = new Array();//代理商代码
  var selectStatus = 0;
  
  var arrsalecode =new Array();
  var arrsaleName=new Array();
  var arrsalePrice=new Array();
  var arrsaleLimit=new Array();
  var arrsaletype=new Array();
  


 
<%  
  for(int i=0;i<phoneTypeStr.length;i++)
  {
	out.println("arrPhoneType["+i+"]='"+phoneTypeStr[i][0]+"';\n");
	out.println("arrPhoneName["+i+"]='"+phoneTypeStr[i][1]+"';\n");
	
  }  

%>
	
  //***
  function frmCfm(){
 	frm.submit();
	return true;
  }
 //***
 

 
 function printCommit()
 { 
 	getAfterPrompt();
  //校验
  //if(!check(frm)) return false;
  with(document.frm){
    if(cust_name.value==""){
	  rdShowMessageDialog("请输入姓名!",0);
      cust_name.focus();
	  return false;
	}
	
	
	
	if(agent_code.value==""){
	  rdShowMessageDialog("请输入赠送礼品!",0);
      agent_code.focus();
	  return false;
	}
	if(prepay_fee.value==""){
	  rdShowMessageDialog("请输入应收预存!",0);
      phone_type.focus();
	  return false;
	}
	
	
	document.all.phone_typename.value=document.all.agent_code.options[document.all.agent_code.selectedIndex].text;
  }
 //打印工单并提交表单
  var ret = showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes"); 
  if(typeof(ret)!="undefined")
  {
    if((ret=="confirm"))
    {
      if(rdShowConfirmDialog('确认电子免填单吗？')==1)
      {
	    frmCfm();
      }
	}
	if(ret=="continueSub")
	{
      if(rdShowConfirmDialog('确认要提交信息吗？')==1)
      {
	    frmCfm();
      }
	}
  }
  else
  {
     if(rdShowConfirmDialog('确认要提交信息吗？')==1)
     {
	   frmCfm();
     }
  }
  return true;
}
function showPrtDlg(printType,DlgMessage,submitCfm)
{  //显示打印对话框 
   var h=150;
   var w=350;
   var t=screen.availHeight/2-h/2;
   var l=screen.availWidth/2-w/2;
   
   var printStr = printInfo(printType);
   var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no"; 
     var pType="subprint";                     // 打印类型print 打印 subprint 合并打印
     var billType="1";                      //  票价类型1电子免填单、2发票、3收据
     var sysAccept =document.frm.login_accept.value;                       // 流水号
     var printStr = printInfo(printType);   //调用printinfo()返回的打印内容
     var mode_code=null;                        //资费代码
     var fav_code=null;                         //特服代码
     var area_code=null;                        //小区代码
     var opCode =   "<%=opCode%>";                         //操作代码
     var phoneNo = "<%=phoneNo%>";                            //客户电话
    var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc.jsp?DlgMsg=" + DlgMessage+ "&submitCfm=" + submitCfm;
		var path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+sysAccept+"&phoneNo="+phoneNo+"&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
		var ret=window.showModalDialog(path,printStr,prop);   
		
		
   return ret;    
}

function printInfo(printType)
{
  vUnitId="",vUnitName="",vUnitAddr="",vUnitZip="",vServiceNo="",vServiceName="",vContactPhone="",vContactPost="";
	var month_fee ;
	
   	var retInfo = "";
		var note_info1 = "";
		var note_info2 = "";
		var note_info3 = "";
		var note_info4 = "";
		var opr_info = "";
		var cust_info = "";
		
	cust_info+="手机号码："+document.all.phone_no.value+"|";
	cust_info+="客户姓名："+document.all.cust_name.value+"|";
	cust_info+="客户地址："+document.all.cust_addr.value+"|";
	cust_info+="证件号码："+'<%=cardId_no%>'+"|";
	
	opr_info+="单位地址："+'<%=vUnitAddr%>'+"|";
	opr_info+="联系电话："+'<%=vContactPhone%>'+"|";
	opr_info+="集团ID："+'<%=vUnitId%>'+"|";
	opr_info+="集团名称："+'<%=vUnitName%>'+"|";
	opr_info+="业务种类集团客户预存有礼："+"|";
	opr_info+="客户预存款："+parseInt(document.all.prepay_money.value)+"元"+"|";
    opr_info+="赠送礼品："+document.all.phone_typename.value+"|";
	opr_info+="赠送时间："+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd ", Locale.getDefault()).format(new java.util.Date())%>'+"|";
	opr_info+="业务流水："+document.all.login_accept.value+"|";
	note_info1+="备注：欢迎您参加中国移动“预存有礼”活动，感谢您对中国移动的支持，如在使用中遇到任何问题可咨询您所在集团的客户经理。"+"|";

	  retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
    retInfo=retInfo.replace(new RegExp("#","gm"),"%23"); //把“#"替换为url格式
    return retInfo;
}



//-->
</script>

<script language="JavaScript">
<!--
/****************根据agent_code动态生成phone_type下拉框************************/

 function selectChange(){
 
 	
   	var x1 ;
   	for ( x1 = 0 ; x1 < arrPhoneType.length  ; x1++ )
   	{ //alert(arrPhoneType[x1] );
   	  //alert(document.all.agent_code.value);
      		if ( arrPhoneType[x1] == document.all.agent_code.value)
      		{
        		
        		document.all.prepay_money.value=arrPhoneName[x1] ;
        		
      		}
   	}

 }



//-->
</script>


</head>


<body>
<form name="frm" method="post" action="f2294_2.jsp" onKeyUp="chgFocus(frm)">
	<%@ include file="/npage/include/header.jsp" %>                         


	<div class="title">
		<div id="title_zi">集团客户预存送礼</div>
	</div>
 

        <table  cellspacing="0">
		  <tr> 
            <td class="blue">操作类型</td>
            <td class="blue">集团客户预存送礼--申请</td>
            <td class="blue">&nbsp;</td>
            <td class="blue">&nbsp;</td>
          </tr>        
		  <tr> 
            <td class="blue">集团ID</td>
            <td class="blue">
			  <input name="vUnitId" value="<%=vUnitId%>" type="text"  v_must=1 readonly  class="InputGrey" id="vUnitId" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            <td class="blue">集团名称</td>
            <td class="blue">
			  <input name="vUnitName" value="<%=vUnitName%>" type="text"  v_must=1 readonly  class="InputGrey" id="vUnitName" maxlength="60" > 
			  <font class="orange">*</font>
            </td>
            </tr>

			
		  
		  
		  <tr> 
            <td class="blue">客户姓名</td>
            <td class="blue">
			  <input name="cust_name" value="<%=bp_name%>" type="text"  v_must=1 readonly  class="InputGrey" id="cust_name" maxlength="20" v_name="姓名"> 
			  <font class="orange">*</font>
            </td>
            <td class="blue">客户地址</td>
            <td class="blue">
			  <input name="cust_addr" value="<%=bp_add%>" type="text"  v_must=1 readonly  class="InputGrey" id="cust_addr" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            </tr>
            <tr> 
            <td class="blue">证件类型</td>
            <td class="blue">
			  <input name="cardId_type" value="<%=cardId_type%>" type="text"  v_must=1 readonly  class="InputGrey" id="cardId_type" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            <td class="blue">证件号码</td>
            <td class="blue">
			  <input name="cardId_no" value="<%=cardId_no%>" type="text"  v_must=1 readonly  class="InputGrey" id="cardId_no" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            </tr>
            <tr> 
            <td class="blue">业务品牌</td>
            <td class="blue">
			  <input name="sm_code" value="<%=sm_code%>" type="text"  v_must=1 readonly  class="InputGrey" id="sm_code" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            <td class="blue">运行状态</td>
            <td class="blue">
			  <input name="run_type" value="<%=run_name%>" type="text"  v_must=1 readonly  class="InputGrey" id="run_type" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            </tr>
            <tr> 
            <td class="blue">VIP级别</td>
            <td class="blue">
			  <input name="vip" value="<%=vip%>" type="text"  v_must=1 readonly  class="InputGrey" id="vip" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            <td class="blue">可用预存</td>
            <td class="blue">
			  <input name="prepay_fee" value="<%=prepay_fee%>" type="text"  v_must=1 readonly  class="InputGrey" id="prepay_fee" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            </tr>
            
            <tr> 
            <td class="blue">集团归类</td>
            <td class="blue">
			  <input name="group_type" value="<%=zhanbi_name%>" type="text"  v_must=1 readonly class="InputGrey" id="group_type" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            <td class="blue">&nbsp;</td>
             <td class="blue">&nbsp;</td>
            </tr>
			
			
			
			
			<tr> 
            <td class="blue">赠送礼品</td>
            <td class="blue">
			  <SELECT id="agent_code" name="agent_code" v_must=1  onchange="selectChange();" v_name="手机代理商">  
			    <option value ="">--请选择--</option>
                <%for(int i = 0 ; i < agentCodeStr.length ; i ++){%>
                <option value="<%=agentCodeStr[i][0]%>"><%=agentCodeStr[i][1]%></option>
                <%}%>
              </select>
			  <font class="orange">*</font>	
			</td>
	 <td class="blue">应交预存</td>
            <td class="blue">
			  <input type="text" name="prepay_money" id="prepay_money" v_must=1 v_name="应交预存"  readonly class="InputGrey"  >	
			  	  
             
			  <font class="orange">*</font>
			</td>
          </tr>
          
       
		  <tr> 
            <td height="32"   class="blue">备注</td>
            <td colspan="3" height="32">
             <input name="opNote" type="text"  readonly class="InputGrey"  id="opNote" size="60" maxlength="60" value="集团客户预存送礼" > 
            </td>
          </tr>
          <tr> 
            <td colspan="4" id="footer"> <div align="center"> 
                <input name="confirm" type="button" class="b_foot_long"  index="2" value="确认&打印" onClick="printCommit()">
                &nbsp; 
                <input name="reset" type="reset" class="b_foot" value="清除" >
                &nbsp; 
                <input name="back" onClick="history.go(-1);" class="b_foot"  type="button"  value="返回">
                &nbsp; </div></td>
          </tr>
        </table>
 
    <input type="hidden" name="phone_no" value="<%=phoneNo%>">
    <input type="hidden" name="work_no" value="<%=loginName%>">
	<input type="hidden" name="opcode" value="<%=opcode%>">
    <input type="hidden" name="login_accept" value="<%=printAccept%>">
    <input type="hidden" name="card_dz" value="0" >
	<input type="hidden" name="sale_type" value="9" >
    <input type="hidden" name="used_point" value="0" >  
	<input type="hidden" name="point_money" value="0" > 
	<input type="hidden" name="phone_typename" value="" >
	<%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>