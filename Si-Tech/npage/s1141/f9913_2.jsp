<%
	/********************
	 version v2.0
	开发商: si-tech
	update:anln@2009-02-08 页面改造,修改样式
	********************/
%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType= "text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.sitech.boss.pub.util.Encrypt"%>
<%@ include file="/npage/bill/getMaxAccept.jsp" %>


<%		
 	//String opCode = "9913";	
	//String opName = "手机邮箱商用取消";	//header.jsp需要的参数  
  String opCode = request.getParameter("opCode");
  String opName = request.getParameter("opName");   
	String loginNo = (String)session.getAttribute("workNo");    //工号 		   
	String regionCode = (String)session.getAttribute("regCode"); 
 	String loginName = (String)session.getAttribute("workName");
 	String  password = (String)session.getAttribute("password");     
%>
<%
	String retFlag="",retMsg="";
 	//SPubCallSvrImpl impl = new SPubCallSvrImpl();
  	//ArrayList retList = new ArrayList();
  	String[] paraAray1 = new String[4];
	String phoneNo = request.getParameter("activePhone");
	String opcode = request.getParameter("opCode");
  	String passwordFromSer="";
  
  	paraAray1[0] = phoneNo;		/* 手机号码   */ 
  	paraAray1[1] = opCode; 	    /* 操作代码   */
  	paraAray1[2] = loginNo;	    /* 操作工号   */
  	paraAray1[3] = password;    /* 工号密码   */
 

	  for(int i=0; i<paraAray1.length; i++)
	  {		
  		if( paraAray1[i] == null )
  		{
  		  paraAray1[i] = "";
  		  
  		}
	  }
 /* 输出参数： 返回码，返回信息，客户姓名，客户地址，证件类型，证件号码，业务品牌，
 			归属地，当前状态，VIP级别，当前积分,可用预存
 */

  	//retList = impl.callFXService("s9913Qry", paraAray1, "20","phone",phoneNo);
  %>
  	<wtc:service name="s9913Qry"   routerKey="phone" routerValue="<%=phoneNo%>" retcode="retCode1" retmsg="retMsg1" outnum="22" >
	<wtc:param value=" " />
	<wtc:param value="01" />
	<wtc:param value="<%=paraAray1[1]%>"/>
	<wtc:param value="<%=paraAray1[2]%>"/>	
	<wtc:param value="<%=paraAray1[3]%>" />	
	<wtc:param value="<%=paraAray1[0]%>"/>
    <wtc:param value=" " /> 		
		
	</wtc:service>
	<wtc:array id="retList" scope="end"/>
 <%	  	
  	String  bp_name="",bp_add="",cardId_type="",cardId_no="",sm_code="",region_name="",run_name="",vip="",posint="",prepay_fee="";
  	String curlevel="",nextlevel="",text_curlevel="",text_nextlevel="",text_qxlevel="",qxlevel="";
  	String spcode="",opercode="",freeFlag = "";
  	String[][] tempArr= new String[][]{};
  	//int errCode = impl.getErrCode();
  	//String errMsg = impl.getErrMsg();
  	String errCode = retCode1;
  	String errMsg= retMsg1;
  if(retList == null)
  {
	if(!retFlag.equals("1"))
	{
		System.out.println("retFlag="+retFlag);
	   retFlag = "1";
	   retMsg = "s1141Qry查询号码基本信息为空!<br>errCode: " + errCode + "<br>errMsg+" + errMsg;
    }    
  }
  else{
  	if(!errCode.equals("000000")){%>
  		<script language="JavaScript">
  			rdShowMessageDialog("错误代码：<%=errCode%>，错误信息：<%=errMsg%>",0);
  			//history.go(-1);
  			//window.location.href="f9913_1.jsp?opCode=<%=opCode%>&opName=<%=opName%>&activePhone=<%=phoneNo%>";
  			removeCurrentTab();
  		</script>
   <%}else{
  	  if(retList.length>0){
  		 // tempArr = (String[][])retList.get(2);
  		    tempArr=retList;
  		  if(!(tempArr==null)){
  		    bp_name = tempArr[0][2];//机主姓名
  		    System.out.println(bp_name);
  		  }
  		  //tempArr = (String[][])retList.get(3);
  		  if(!(tempArr==null)){
  		    bp_add = tempArr[0][3];//客户地址
  		  }
  		  //tempArr = (String[][])retList.get(4);
  		  if(!(tempArr==null)){
  		    cardId_type = tempArr[0][4];//证件类型
  		  }
  		  //tempArr = (String[][])retList.get(5);
  		  if(!(tempArr==null)){
  		    cardId_no = tempArr[0][5];//证件号码
  		  }
  		  //tempArr = (String[][])retList.get(6);
  		  if(!(tempArr==null)){
  		    sm_code = tempArr[0][6];//业务品牌
  		  }
  		  //tempArr = (String[][])retList.get(7);
  		  if(!(tempArr==null)){
  		    region_name = tempArr[0][7];//归属地
  		  }
  		  //tempArr = (String[][])retList.get(8);
  		  if(!(tempArr==null)){
  		    run_name = tempArr[0][8];//当前状态
  		  }
  		  //tempArr = (String[][])retList.get(9);
  		  if(!(tempArr==null)){
  		    vip = tempArr[0][9];//ＶＩＰ级别
  		  }
  		  //tempArr = (String[][])retList.get(10);
  		  if(!(tempArr==null)){
  		    posint = tempArr[0][10];//当前积分
  		  }
  		  //tempArr = (String[][])retList.get(11);
  		  if(!(tempArr==null)){
  		    prepay_fee = tempArr[0][11];//可用预存
  		  }
  		  //tempArr = (String[][])retList.get(13);
  		  if(!(tempArr==null)){
  		    passwordFromSer = tempArr[0][13];  //密码
  		  }
  		  //tempArr = (String[][])retList.get(14);
  		  if(!(tempArr==null)){
  		    curlevel = tempArr[0][14];  //密码
  		  }
  		  	  	
  		  //tempArr = (String[][])retList.get(15);
  		  if(!(tempArr==null)){
  			nextlevel = tempArr[0][15];  //密码
  		  }
  		  //tempArr = (String[][])retList.get(16);
  		  if(!(tempArr==null)){
  			text_curlevel = tempArr[0][16];  //当前级别
  		  }
  		  //tempArr = (String[][])retList.get(17);
  		  if(!(tempArr==null)){
  			text_nextlevel = tempArr[0][17];  //密码
  		  }
  		  //tempArr = (String[][])retList.get(18);
  		  if(!(tempArr==null)){
  			spcode = tempArr[0][18];  //密码
  		  }
  		  //tempArr = (String[][])retList.get(19);
  		  if(!(tempArr==null)){
  			opercode = tempArr[0][19];  //密码
  		  }
  		   if(!(tempArr==null)){
  			freeFlag = tempArr[0][21];  //免费标识位
  		  }
  		  
  		  if((tempArr[0][20]).equals("1"))
  		  {%>
  			<script language="JavaScript">
  				rdShowMessageDialog("请提示客户：取消139邮箱业务，黑莓个人邮箱业务也将一并取消！");
  			</script>
  		  <%}
  	  }
  	  if(curlevel.equals("0")){
  	  	curlevel="";
  	  }
  	  if(nextlevel.equals("0")){
  	  	nextlevel="";
  	  }
  	  if(nextlevel.equals("xx")){
  	   text_qxlevel=text_curlevel;
  	   qxlevel="QXYX"+curlevel.trim();
  	  }else{
  	  	text_qxlevel=text_nextlevel;
  	  	qxlevel="QXYX"+nextlevel.trim();
  	  }
  	  if("Y".equals(freeFlag)){
  	    text_curlevel = text_curlevel + "(免费版)";
  	    text_qxlevel = text_qxlevel + "(免费版)";
  	  }
  	}
  }

%>

<%
	//******************得到下拉框数据***************************//
	String printAccept="";
	printAccept = getMaxAccept();
	System.out.println("=============================="+printAccept);
	String exeDate="";
	exeDate = getExeDate("1","1141");

 
  
%>

<html>
<head>
	<title>手机邮箱商用取消</title>
	<script type="text/javascript" src="../../npage/s3000/js/S3000.js"></script>
	<script language="JavaScript" src="../../npage/s1400/pub.js"></script> 
	<script language="JavaScript">
		<!--
		  //定义应用全局的变量
		  var SUCC_CODE	= "0";   		//自己应用程序定义
		  var ERROR_CODE  = "1";			//自己应用程序定义
		  var YE_SUCC_CODE = "0000";		//根据营业系统定义而修改
			var checke177flag="yes";
		  //***
		  function frmCfm(){
		 	frm.submit();
			return true;
		  }
		 //***IMEI 号码校验

		 function printCommit()
		 { 
		 	
		<%if(curlevel.trim().equals("5")) {%> 
		var packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s1141/checkQuitType.jsp","请稍后...");
		packet.data.add("phoneno","<%=phoneNo%>");
		packet.data.add("seseq","80005");
		core.ajax.sendPacket(packet,dochecke177);
		packet =null;
		<%}%>
		
		  getAfterPrompt();
		 	  
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
		{  
			var pType="subprint";                     // 打印类型print 打印 subprint 合并打印
	     		var billType="1";                      //  票价类型1电子免填单、2发票、3收据
			var sysAccept ="<%=printAccept%>";                       // 流水号
			var printStr = printInfo(printType);   //调用printinfo()返回的打印内容
			var mode_code=null;                        //资费代码
			var fav_code=null;                         //特服代码
			var area_code=null;                    //小区代码
			var opCode =   "<%=opCode%>";                         //操作代码
			var phoneNo = <%=phoneNo%>;                           //客户电话
			
			//显示打印对话框 
			var h=180;
			var w=352;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			
			var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no" 	   
		   	var path= "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_hw.jsp?DlgMsg=" + DlgMessage+ "&submitCfm=" + submitCfm;
			var path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+sysAccept+"&phoneNo="+phoneNo+"&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
			var ret=window.showModalDialog(path,printStr,prop); 	   
			   
		}

		function printInfo(printType)
		{	  
			/*var retInfo = "";
			retInfo+='<%=loginNo%>'+' '+'<%=loginName%>'+"|";
			retInfo+='<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
			retInfo+="用户号码："+document.all.phone_no.value+"|";
			retInfo+="用户姓名："+document.all.cust_name.value+"|";
			retInfo+="用户地址："+document.all.cust_addr.value+"|";
			retInfo+="证件号码："+document.all.cardId_no.value+"|";
			retInfo+=" "+"|";
			retInfo+=" "+"|";
			retInfo+=" "+"|";
			retInfo+=" "+"|";
			retInfo+=" "+"|";
			retInfo+=" "+"|";
			retInfo+="业务类型：手机邮箱商用取消"+"|";
		  	retInfo+="操作类型：取消"+document.all.textqxlevel.value+"|";
			retInfo+="SP企业代码:"+"<%=spcode%>"+"   SP业务代码:"+"<%=opercode%>"+"|";
			retInfo+=" "+"|";
			retInfo+=" "+"|";	
		    	return retInfo;	*/
		    	
		    	var cust_info=""; //客户信息
		      	var opr_info=""; //操作信息
		      	var retInfo = "";  //打印内容
		      	var note_info1=""; //备注1
		      	var note_info2=""; //备注2
		      	var note_info3=""; //备注3
		      	var note_info4=""; //备注4 
					 
			cust_info+="客户姓名：   "+document.all.cust_name.value+"|";
      		        cust_info+="手机号码：   "+document.all.phone_no.value+"|";
      		        cust_info+="客户地址：   "+document.all.cust_addr.value+"|";
      		        cust_info+="证件号码：   "+document.all.cardId_no.value+"|";
      		        
      		        opr_info+="业务类型：<%=opName%>"+"|";
		  	opr_info+="操作类型：取消"+document.all.textqxlevel.value+"|";
			opr_info+="SP企业代码:"+"<%=spcode%>"+"   SP业务代码:"+"<%=opercode%>"+"|";
			opr_info+="尊敬的客户，您已退订139邮箱功能。详询10086。 "+"|";
			
			retInfo= strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
	  	      	retInfo=retInfo.replace(new RegExp("#","gm"),"%23"); //把“#"替换为url格式
	    	      	return retInfo;	
		}
		
		function goBack(){
		  //window.location.href="f9913_1.jsp?opCode=<%=opCode%>&opName=<%=opName%>&activePhone=<%=phoneNo%>";
		  removeCurrentTab();
		}
		
		function dochecke177(packet){
	var errorCode = packet.data.findValueByName("errorCode");
	var errormsg = packet.data.findValueByName("errorMsg");
	if(errorCode =="000000"){
	checke177flag="yes";		
	var returncode = packet.data.findValueByName("returncode");
	var returnmsg11 = packet.data.findValueByName("returnmsg");
	if(returncode=="000000") {
	}else {
	rdShowMessageDialog(returnmsg11);
	}
	}else{
		rdShowMessageDialog(errormsg);
		checke177flag="no";
		return false;
	}
}

		//-->
	</script>
</head>
<body>
	<form name="frm" method="post" action="f9913Cfm.jsp" onKeyUp="chgFocus(frm)">	
		<%@ include file="/npage/include/header.jsp" %>  	
		<div class="title">
			<div id="title_zi"><%=opName%></div>
		</div>
        	<table cellspacing="0">
			  <tr> 
			            <td class="blue">操作类型</td>
			            <td colspan="3"><%=opName%></td>			            
		          </tr>
		          <tr> 
			            <td class="blue">客户姓名</td>
			            <td>
					<input name="cust_name" value="<%=bp_name%>" type="text"  v_must=1 readonly class="InputGrey" id="cust_name" maxlength="20" > 
					<font class="orange">*</font>
			            </td>
		            	    <td class="blue">证件类型</td>
			            <td>
					<input name="cardId_type" value="<%=cardId_type%>" type="text"  v_must=1 readonly class="InputGrey" id="cardId_type" maxlength="20" > 
					<font class="orange">*</font>
			            </td>
			</tr>
		        <tr style="display:none"> 
			            <td class="blue">&nbsp;</td>
			            <td>
					<input name="cust_addr" value="<%=bp_add%>" type="hidden"  v_must=1 readonly class="InputGrey" id="cust_addr" maxlength="20" > 
			            </td>
			            <td class="blue">&nbsp;</td>
			            <td>
					<input name="cardId_no" value="<%=cardId_no%>" type="hidden"  v_must=1 readonly class="InputGrey" id="cardId_no" maxlength="20" > 
			            </td>
		      </tr>
		      <tr> 
		            <td class="blue">业务品牌</td>
		            <td>
				<input name="sm_code" value="<%=sm_code%>" type="text"  v_must=1 readonly  class="InputGrey" id="sm_code" maxlength="20" > 
				<font class="orange">*</font>
		            </td>
		            <td class="blue">运行状态</td>
		            <td>
				<input name="run_type" value="<%=run_name%>" type="text"  v_must=1 readonly class="InputGrey" id="run_type" maxlength="20" > 
				<font class="orange">*</font>
		            </td>
		     </tr>
		     <tr> 
		            <td class="blue">VIP级别</td>
		            <td>
				<input name="vip" value="<%=vip%>" type="text"  v_must=1 readonly class="InputGrey" id="vip" maxlength="20" > 
				<font class="orange">*</font>
		            </td>
		            <td class="blue">可用预存</td>
		            <td>
				<input name="prepay_fee" value="<%=prepay_fee%>" type="text"  v_must=1 readonly class="InputGrey" id="prepay_fee" maxlength="20" > 
				<font class="orange">*</font>
		            </td>  
		    <tr> 
		            <td class="blue">当前级别</td>
		            <td>
				<input name="cur_level" value="<%=text_curlevel%>"  type="text"  id="cur_level"   readonly class="InputGrey" >
				<font class="orange">*</font>	
			     </td>
		            <td class="blue">预约级别</td>
		            <td>
				<input name="next_level" value="<%=text_nextlevel%>"  type="text"   id="next_level"    readonly class="InputGrey">
				<font class="orange">*</font>
			    </td>
          	     </tr>
	          <tr> 
		            <td class="blue">取消级别</td>
		            <td>
					<input name="textqxlevel" value="<%=text_qxlevel%>"  type="text"  id="cur_level"   readonly   class="InputGrey">
					<font class="orange">*</font>	
			    </td>
	            	    <td>&nbsp;</td>
	            	    <td>&nbsp;</td>	            
	          </tr>
	</table>
	<table cellspacing="0">
	          <tr> 
		            <td id="footer"> 
		                <input name="confirm"  class="b_foot_long"  type="button"  index="2" value="确认&打印" onClick="printCommit()"  >
		                &nbsp; 
		                <input name="back"  class="b_foot"  onClick="goBack()" type="button"  value="关闭">
		                &nbsp; 
		           </td>
	          </tr>
        </table>
        
    	<input type="hidden" name="phone_no" value="<%=phoneNo%>">
    	<input type="hidden" name="work_no" value="<%=loginName%>">
	<input type="hidden" name="opcode" value="<%=opcode%>">
    	<input type="hidden" name="login_accept" value="<%=printAccept%>">
    	<input type="hidden" name="card_dz" value="0" >
	<input type="hidden" name="sale_type" value="1" >
    	<input type="hidden" name="used_point" value="0" >  
	<input type="hidden" name="point_money" value="0" > 
	<input type="hidden" name="phone_typename" value="" >
	<input type="hidden" name="qx_level" value="<%=qxlevel%>" >
	<input type="hidden" name="opCode" value="<%=opCode%>" />
	<input type="hidden" name="opName" value="<%=opName%>" />
	<%@ include file="/npage/include/footer.jsp" %>		
</form>
</body>
</html>
