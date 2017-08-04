<%
/********************
 version v2.0
 开发商 si-tech
 update hejw@2009-2-5
********************/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http//www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http//www.w3.org/1999/xhtml">
	
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %> 

<%
  response.setHeader("Pragma","No-cache");
  response.setHeader("Cache-Control","no-cache");
  response.setDateHeader("Expires", 0);
%>

<%@ page import="com.sitech.boss.common.viewBean.comImpl"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.sitech.boss.spubcallsvr.viewBean.*" %>
<%@ page import="com.sitech.boss.spubcallsvr.viewBean.SPubCallSvrImpl"%>
<%@ page import="com.sitech.boss.pub.util.Encrypt"%>
<%@ page import="com.sitech.boss.common.viewBean.comImpl"%>
<%@ include file="/npage/bill/getMaxAccept.jsp" %>
<%@ page import="java.math.*"%>


<%		
	String opCode = "8031";
	String opName = "集团用户预存话费赠机冲正";
	String loginNo = (String)session.getAttribute("workNo");
	String regionCode = (String)session.getAttribute("regCode");
%>
<%
	String retFlag="",retMsg="";
	String[] paraAray1 = new String[4];
	String phoneNo = request.getParameter("phoneNo");
	String opcode = request.getParameter("opcode");
	String backaccept = request.getParameter("backaccept");
	String passwordFromSer="";
	
	String[][] result = new String[][]{};
	String awardName = new String();
	String sqlStr = "select res_info from wawarddata where flag = 'Y' and phone_no = '"+phoneNo+"'"+" and login_accept="+backaccept;
	//ArrayList retArray = impl.sPubSelect("1",sqlStr);
%>

		<wtc:pubselect name="sPubSelect" outnum="1" retmsg="msg1" retcode="code1" routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=sqlStr%></wtc:sql>
 	  </wtc:pubselect>
	 <wtc:array id="result_t1" scope="end"/>

<%  

  if(result_t1 != null&&result_t1.length>0)
  {
	  awardName = result_t1[0][0];		  
	  System.out.println("awardName2="+awardName);

  	if(!awardName.equals("")){
%>
		  <script language="JavaScript" >
		  rdShowMessageDialog("此用户已在促销品统一付奖中进行<%=awardName%>领奖，请进行促销品统一付奖冲正，并确保奖品完好");
			//history.go(-1);
			</script>
<%	}
	}
  
  paraAray1[0] = phoneNo;		/* 手机号码   */ 
  paraAray1[1] = opcode; 	    /* 操作代码   */
  paraAray1[2] = loginNo;	    /* 操作工号   */
  paraAray1[3] = backaccept;	    /* 操作流水   */

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

  //retList = impl.callFXService("s8031Init", paraAray1, "32","phone",phoneNo);
  
%>

    <wtc:service name="s8031Init" outnum="32" retmsg="msg2" retcode="code2" routerKey="phone" routerValue="<%=phoneNo%>">
			<wtc:params value="<%=paraAray1%>" />
		</wtc:service>
		<wtc:array id="result_t2" scope="end"/>

<%  
  String  bp_name="",bp_add="",cardId_type="",cardId_no="",sm_code="",region_name="",run_name="",vip="",posint="",prepay_fee="",sale_name="",sum_pay="",card_no="",card_num="",limit_pay="",use_point="",card_summoney="",mach="",machine_type="", vUnitId="",vUnitName="",vUnitAddr="",vUnitZip="",vServiceNo="",vServiceName="",vContactPhone="",vContactPost="", vProductId="",vProductCode="",vTargetName="",vProductName="";
  String errCode = code2;
  String errMsg = msg2;
  if(result_t2 == null)
  {
	if(!retFlag.equals("1"))
	{
		System.out.println("retFlag="+retFlag);
	   retFlag = "1";
	   retMsg = "s8031Init查询号码基本信息为空!<br>errCode " + errCode + "<br>errMsg+" + errMsg;
    }    
  }else if(!(result_t2 == null))
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
	    bp_name = result_t2[0][2];//机主姓名
	    bp_add = result_t2[0][3];//客户地址
	    cardId_type = result_t2[0][4];//证件类型
	    cardId_no = result_t2[0][5];//证件号码
	    sm_code = result_t2[0][6];//业务品牌
	    region_name = result_t2[0][7];//归属地
	    run_name = result_t2[0][8];//当前状态
	    vip = result_t2[0][9];//ＶＩＰ级别
	    posint = result_t2[0][10];//当前积分
	    prepay_fee = result_t2[0][11];//可用预存
	    sale_name = result_t2[0][12];//营销方案名
	    sum_pay = result_t2[0][13];//应付金额
	    card_no = result_t2[0][14];//卡金额串
	    card_num = result_t2[0][15];//卡张数串
	    limit_pay = result_t2[0][16];//预存话费
	    use_point = result_t2[0][17];//销费积分数
	    card_summoney = result_t2[0][18];//卡类总金额
	    machine_type = result_t2[0][19];//机器类型
	    vUnitId = result_t2[0][20];//集团ID
	    vUnitName = result_t2[0][21];//集团名称
	    vUnitAddr = result_t2[0][22];//单位地址
	    vUnitZip = result_t2[0][23];//单位邮编
	    vServiceNo = result_t2[0][24];//集团工号
	    vServiceName = result_t2[0][25];//集团工号姓名
	    vContactPhone = result_t2[0][26];//联系电话
	    vContactPost = result_t2[0][27];//联系邮编
	    vProductId = result_t2[0][28];//产品id
	    vProductCode = result_t2[0][29];//产品代码
	    vTargetName = result_t2[0][30];//终端营销目的
	    vProductName= result_t2[0][31];//产品名称
	
	double mach_fee;
	double sum=0.00;
	double limit=0.00;

	sum=Double.parseDouble(sum_pay);
	limit=Double.parseDouble(limit_pay);
	mach_fee=sum-limit;
	DecimalFormat currencyFormatter = new DecimalFormat("0.00");
	currencyFormatter.format(mach_fee);
	mach=currencyFormatter.format(mach_fee)+"";
	/*mach =String.valueOf(mach_fee);*/
	System.out.println("mach="+mach);
	}else{
		
	}
  }

%>
 <%  //优惠信息//********************得到营业员权限，核对密码，并设置优惠权限*****************************//   

  String[][] favInfo = (String[][])session.getAttribute("favInfo");  //数据格式为String[0][0]---String[n][0]
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
// **************得到冲正流水***************//
String printAccept="";
printAccept = getMaxAccept();
System.out.println(printAccept);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>预存话费优惠购机</title>
<META content="no-cache" http-equiv="Pragma">
<META content="no-cache" http-equiv="Cache-Control">
<META content="0" 	     http-equiv="Expires" > 
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script language="JavaScript">

<!--
 
  
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
  
 //打印工单并提交表单
  var ret = showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes"); 
  
  
  if(typeof(ret)!="undefined")
  {
    if((ret=="1"))
    {
      if(rdShowConfirmDialog('确认电子免填单吗？')==1)
      {
	    frmCfm();
      }
	}
	if(ret=="0")
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
    var h=180;
     var w=350;
     var t=screen.availHeight/2-h/2;
     var l=screen.availWidth/2-w/2;
   
     var printStr = printInfo();
	 //alert(printStr);
   
     var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no"; 
     
     var pType="subprint";                     // 打印类型print 打印 subprint 合并打印
     var billType="1";                      //  票价类型1电子免填单、2发票、3收据
     var sysAccept =document.all.login_accept.value;                       // 流水号
     var printStr = printInfo(printType);   //调用printinfo()返回的打印内容
     var mode_code=null;                        //资费代码
     var fav_code=null;                         //特服代码
     var area_code=null;                        //小区代码
     var opCode =   "<%=opCode%>";                           //操作代码
     var phoneNo = "<%=phoneNo%>";                             //客户电话
     
    var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc.jsp?DlgMsg=" + DlgMessage+ "&submitCfm=" + submitCfm;
		var path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+sysAccept+"&phoneNo="+phoneNo+"&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
		var ret=window.showModalDialog(path,printStr,prop);  

}

function printInfo(printType)
{
  

      	var retInfo = "";
		var note_info1 = "";
		var note_info2 = "";
		var note_info3 = "";
		var note_info4 = "";
		var opr_info = "";
		var cust_info = "";
		
	cust_info+="手机号码："+document.all.phone_no.value+"|";
	cust_info+="客户姓名："+document.all.cust_name.value+"|";
	cust_info+="联系人电话："+'<%=vContactPhone%>'+"|";
	cust_info+="客户地址："+document.all.cust_addr.value+"|";
	opr_info+="邮政编码："+'<%=vContactPost%>'+"|";
	opr_info+="单位地址："+'<%=vUnitAddr%>'+"|";
	opr_info+="邮政编码：："+'<%=vUnitZip%>'+"|";
	opr_info+="客户经理："+'<%=vServiceName%>'+"|";
	opr_info+="业务种类集团客户手机冲正："+"|";
  	opr_info+="业务流水："+document.all.login_accept.value+"|";
  	opr_info+="手机型号："+document.all.machine_type.value+"|";
 	opr_info+="退款合计："+document.all.sum_money.value+"元、含预存话费"+"<%=limit_pay%>"+"元"+"|";
	opr_info+="业务执行时间："+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd ", Locale.getDefault()).format(new java.util.Date())%>'+"|";
    
    note_info1+="备注:"+"|";
   
    retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
    retInfo=retInfo.replace(new RegExp("#","gm"),"%23"); //把“#"替换为url格式

    return retInfo;
		
}


//-->
</script>
</head>
<body>
<form name="frm" method="post" action="f8031Cfm.jsp" onload="init()">
	<%@ include file="/npage/include/header.jsp" %>


	<div class="title">
		<div id="title_zi">集团用户预存话费优惠购机－－冲正</div>
	</div>
        <table cellspacing="0" >
		  <tr> 
            <td class="blue">操作类型</td>
            <td class="blue">集团用户预存话费优惠购机--冲正</td>
            <td class="blue">&nbsp;</td>
            <td class="blue">&nbsp;</td>
          </tr>
          <tr> 
            <tr> 
            <td class="blue">集团ID</td>
            <td class="blue">
			  <input name="vUnitId" value="<%=vUnitId%>" type="text"  v_must=1 readonly  Class="InputGrey" id="vUnitId" maxlength="20" v_name="集团ID"> 
			  <font class="orange">*</font>
            </td>
            <td class="blue">集团名称</td>
            <td class="blue">
			  <input name="vUnitName" value="<%=vUnitName%>" type="text"  v_must=1 readonly Class="InputGrey" id="vUnitName" maxlength="20" size="38"> 
			  <font class="orange">*</font>
            </td>
            </tr>
			 <tr> 
            <td class="blue">产品名称</td>
            <td class="blue">
			  <input name="vProductCode" value="<%=vProductName%>" type="text"  v_must=1 readonly  Class="InputGrey" id="vProductCode" maxlength="20" v_name="产品名称"> 
			  <font class="orange">*</font>
            </td>
            <td class="blue">产品ID</td>
            <td class="blue">
			  <input name="vProductId" value="<%=vProductId%>" type="text"  v_must=1 readonly  Class="InputGrey" id="vProductId" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            </tr>
			<tr> 
            <td class="blue">客户姓名</td>
            <td class="blue">
			  <input name="cust_name" value="<%=bp_name%>" type="text"  v_must=1 readonly  Class="InputGrey" id="cust_name" maxlength="20" v_name="姓名"> 
			  <font class="orange">*</font>
            </td>
            <td class="blue">客户地址</td>
            <td class="blue">
			  <input name="cust_addr" value="<%=bp_add%>" type="text"  v_must=1 readonly  Class="InputGrey" id="cust_addr" maxlength="20" size="38"> 
			  <font class="orange">*</font>
            </td>
            </tr>
            <tr> 
            <td class="blue">证件类型</td>
            <td class="blue">
			  <input name="cardId_type" value="<%=cardId_type%>" type="text"  v_must=1 readonly  Class="InputGrey" id="cardId_type" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            <td class="blue">证件号码</td>
            <td class="blue">
			  <input name="cardId_no" value="<%=cardId_no%>" type="text"  v_must=1 readonly  Class="InputGrey" id="cardId_no" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            </tr>
            <tr> 
            <td class="blue">业务品牌</td>
            <td class="blue">
			  <input name="sm_code" value="<%=sm_code%>" type="text"  v_must=1 readonly  Class="InputGrey" id="sm_code" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            <td class="blue">运行状态</td>
            <td class="blue">
			  <input name="run_type" value="<%=run_name%>" type="text"  v_must=1 readonly  Class="InputGrey" id="run_type" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            </tr>
            <tr> 
            <td class="blue">VIP级别</td>
            <td class="blue">
			  <input name="vip" value="<%=vip%>" type="text"  v_must=1 readonly  Class="InputGrey" id="vip" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            <td class="blue">可用预存</td>
            <td class="blue">
			  <input name="prepay_fee" value="<%=prepay_fee%>" type="text"  v_must=1 readonly  Class="InputGrey" id="prepay_fee" maxlength="20" > 
			  <font class="orange">*</font>
            </td>
            </tr>
           <tr> 
            <td class="blue">营销方案</td>
            <td >
				<input name="sale_name" value="<%=sale_name%>" type="text"  v_must=1 readonly  Class="InputGrey" id="sale_name" maxlength="20" size="38"> 
			    <font class="orange">*</font>
			</td>
			<td  class="blue">应退金额</td>
            <td >
			  <input name="sum_money" type="text"  id="sum_money" value="<%=sum_pay%>" readonly Class="InputGrey" >
			  <font class="orange">*</font>
			</td>            
          </tr>
          <tr> 
            <td  class="blue">购机款</td>
            <td >
			  <input name="price" type="text"  id="price" value="<%=mach%>" readonly  Class="InputGrey"  >
			  <font class="orange">*</font>	
			</td>
            <td class="blue">预存话费</td>
            <td class="blue">
			  <input name="limit_pay" type="text"   id="limit_pay" value="<%=limit_pay%>" readonly Class="InputGrey" >
			  <font class="orange">*</font>
			</td>
          </tr>

          <tr> 
            <td height="32"   class="blue">备注</td>
            <td colspan="4" height="32">
             <input name="opNote" type="text"  id="opNote" size="60" maxlength="60" value="集团用户预存话费优惠购机--冲正" readonly Class="InputGrey" > 
            </td>
            
          </tr>
          <tr> 
            <td colspan="4" id="footer"> <div align="center"> 
                <input name="confirm" type="button"  index="2" value="确认&打印" onClick="printCommit()" class="b_foot_long">
                &nbsp; 
                <input name="reset" type="reset"  value="清除" class="b_foot">
                &nbsp; 
                <input name="back" onClick="history.go(-1)" type="button"  value="返回" class="b_foot">
                &nbsp; </div></td>
          </tr>
        </table>

    <input type="hidden" name="phone_no" value="<%=phoneNo%>">
    <input type="hidden" name="opCode" value="<%=opCode%>">
    <input type="hidden" name="opName" value="<%=opName%>">
	<input type="hidden" name="opcode" value="<%=opcode%>">
    <input type="hidden" name="login_accept" value="<%=printAccept%>">
	<input type="hidden" name="backaccept" value="<%=backaccept%>">
    <input type="hidden" name="card_dz" value="0" >
	<input type="hidden" name="sale_type" value="1" >
    <input type="hidden" name="used_point" value="0" >  
	<input type="hidden" name="point_money" value="0" > 
	<input type="hidden" name="machine_type" value="<%=machine_type%>" >
	<%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>