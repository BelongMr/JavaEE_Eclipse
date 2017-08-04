 <%
	/********************
	 version v2.0
	开发商: si-tech
	update:anln@2009-01-20 页面改造,修改样式
	********************/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="../../include/remark.htm" %>

<%   
	String opCode = "4112";	
	String opName = "批量付费计划变更";	//header.jsp需要的参数   
	
	String regionCode1 = (String)session.getAttribute("regCode") ;	
    	String[][]  favInfo = (String[][])session.getAttribute("favInfo");  
    	String ip_Addr = (String)session.getAttribute("ipAddr");
   	 String workno = (String)session.getAttribute("workNo");
    	String workname = (String)session.getAttribute("workName");
    	String org_code = ((String)session.getAttribute("orgCode")).substring(0,7);
    	String nopass = (String)session.getAttribute("password");   
    	//String Department = baseInfo[0][16];
    	String Department = (String)session.getAttribute("orgCode");
    	String regionCode = Department.substring(0,2);       
    	String districtCode = Department.substring(2,4);
    	String townCode = Department.substring(4,7);
    	String  GroupId = (String)session.getAttribute("groupId");     
    	String  OrgId = (String)session.getAttribute("orgId");   
    	String sqlStr = "";
    	ArrayList retArray = new ArrayList();
    	//String[][] result = new String[][]{};
    	//SPubCallSvrImpl callView = new SPubCallSvrImpl();
    
	/*产品和服务的访问权限*/
	int favFlag = 0 ;
	for(int i = 0 ; i < favInfo.length ; i ++){
		if(favInfo[i][0].trim().equals("a272")){
			favFlag = 1;
		}
	}
%>
<HTML>
	<HEAD>
		<TITLE>批量付费计划变更 </TITLE> 	
	<SCRIPT type=text/javascript>
		var opFlag="add";
		onload=function(){
		  	var obj=document.all.l_msg.style;
		    	document.all.l_msg.size=8;
		    	obj.backgroundColor="#dddddd";
		    	obj.color="black";
		    	obj.width="100%";
			obj.fontSize="13";
		    	obj.borderStyle="none";		
		    document.all.PosFile.disabled=true;    
		}
		function doProcess(packet){
		    	var retType = packet.data.findValueByName("retType");
		    	var retCode = packet.data.findValueByName("retCode");
			var retMessage=packet.data.findValueByName("retMessage");
			var verifyType = packet.data.findValueByName("verifyType");	   
			var backArrMsg = packet.data.findValueByName("backArrMsg");
			var errorCode = packet.data.findValueByName("errorCode");
		    	self.status="";
		    if(retType == "UserId"){
		        if(retCode == "000000"){								
		            	var retUserId = packet.data.findValueByName("retnewId");    	    
		    	    	document.frm.grp_id.value = retUserId;
				document.frm.grp_userno.value=retUserId;
		            	document.frm.reset1.disabled = false;
		    	    	document.frm.grpQuery.disabled = true;
		            	document.frm.grp_name.focus();
		         }else{
		            rdShowMessageDialog("没有得到用户ID,请重新获取！");
					return false;
		        }
				//得到集团产品编号的时候，得到集团代码
				//getGrpId();
		    }
		    if(retType == "GrpId") //得到集团代码
		    {
		        if(retCode == "000000")
		        {
		            var GrpId = packet.data.findValueByName("GrpId");
		            document.frm.grp_userno.value = oneTok(GrpId,"|",1);
		         }
		        else
		        {
		            var retMessage = packet.data.findValueByName("retMessage");
		            rdShowMessageDialog(retMessage, 0);
		        }
			}
		    if(retType == "GrpNo") //得到集团产品编号
		    {
		        if(retCode == "0")
		        {
		            var GrpNo = packet.data.findValueByName("GrpNo");
		            document.frm.grp_userno.value = GrpNo;
		            document.frm.getGrpNo.disabled = true;
		         }
		        else
		        {
		            var retMessage = packet.data.findValueByName("retMessage");
		            rdShowMessageDialog(retMessage, 0);
		        }
			}
		    //---------------------------------------
		    if(retType == "GrpCustInfo") //用户开户时客户信息查询
		    {
		        var retname = packet.data.findValueByName("retname");
		        if(retCode=="000000")
		        {
		            document.frm.cust_name.value = retname;
					document.frm.unit_id.focus();
		        }
		        else
		        {
		            retMessage = retMessage + "[errorCode1:" + retCode + "]";
		                rdShowMessageDialog(retMessage,0);
						return false;
		        }
		     }
		    if(retType == "AccountId") //得到帐户ID
		    {
		        if(retCode == "000000")
		        {
		            var retnewId = packet.data.findValueByName("retnewId");
		            document.frm.account_id.value = retnewId;
		            document.frm.accountQuery.disabled = true;
					document.frm.user_passwd.focus();
		         }
		        else
		        {
		            rdShowMessageDialog("没有得到帐户ID,请重新获取！");
		        }
		    }
		    //---------------------------------------
		    if(retType == "UnitInfo")
		    {
		        //集团信息查询
		        var retname = packet.data.findValueByName("retname");
		        if(retCode=="000000")
		        {
		            document.frm.unit_name.value = retname;
					document.frm.contract_name.focus();
		        }
		        else
		        {
		            retMessage = retMessage + "[errorCode1:" + retCode + "]";
		                rdShowMessageDialog(retMessage,0);
						return false;
		        }
		     }
		     //---------------------------------------
		     if(retType == "checkPwd") //集团客户密码校验
		     {
		        if(retCode == "000000")
		        {
		            var retResult = packet.data.findValueByName("retResult");
		            if (retResult == "false") {
		    	    	rdShowMessageDialog("客户密码校验失败，请重新输入！",0);
			        	frm.custPwd.value = "";
			        	frm.custPwd.focus();
		    	    	return false;	        	
		            } else {
		                rdShowMessageDialog("客户密码校验成功！");
		                document.frm.sure.disabled = false;
		            }
		         }
		        else
		        {
		            rdShowMessageDialog("客户密码校验出错，请重新校验！");
		    		return false;
		        }
		     }	
		
		     //---------------------------------------
			//取流水
			if(retType == "getSysAccept")
		     {
		        if(retCode == "000000")
		        {
					var opMode=document.all.opMode.value;
					var unit_id=document.all.unit_id.value;
		            var sysAccept = packet.data.findValueByName("sysAccept");
					document.frm.login_accept.value=sysAccept;
							/*begin add 当品牌代码为“DF”时，增加生效规则 for 省内代付产品付费关系生效规则优化@2015/3/26 */
							var v_effectRule = "";
							if(document.all.vsmCode.value == "DF"){
								v_effectRule = $("#effectRule").find("option:selected").val();
							}
							/*end add 当品牌代码为“DF”时，增加生效规则 for 省内代付产品付费关系生效规则优化@2015/3/26 */
					showPrtDlg("Detail","确实要打印电子免填单吗？","Yes");
					if (rdShowConfirmDialog("是否提交确认操作？")==1){
					    $("#PosFile").attr("disabled",false);
						page = "s3705_2.jsp?opMode="+opMode+"&unit_id="+unit_id+"&login_accept="+sysAccept+"&unit_name2="+document.all.grpName.value+"&v_effectRule="+v_effectRule;
						frm.action=page;
						frm.method="post";
						frm.submit();
						document.frm.sure.disabled = true;
						loading();
					}
					else return false;
		         }
		        else
		        {
		                rdShowMessageDialog("查询流水出错,请重新获取！");
						return false;
		        }
		    }
			if(verifyType=="getAccountId"){//检测送费模式
				if( errorCode == "000000"){
					tmpObj="accountMsg";
					document.all(tmpObj).options.length=0;
					document.all(tmpObj).options.length=backArrMsg.length;
					
		
					for(i=0;i<backArrMsg.length;i++)
					    {
						  for(j=0;j<backArrMsg[i].length;j++)
						  {
						    document.all(tmpObj).options[i].text=oneTok(backArrMsg[i][j],"#",1);
						    document.all(tmpObj).options[i].value=oneTok(backArrMsg[i][j],"#",1);
				 		  }
					    }
					}else{
						rdShowMessageDialog("取信息错误:"+error_msg+"!");
						return;			
					}
			}
		}

		function check_HidPwd(){
		    	var cust_id = document.all.cust_id.value;
		   	var Pwd1 = document.all.custPwd.value;
		   	var checkPwd_Packet = new AJAXPacket("pubCheckPwd.jsp","正在进行密码校验，请稍候......");
		    	checkPwd_Packet.data.add("retType","checkPwd");
			checkPwd_Packet.data.add("cust_id",cust_id);
			checkPwd_Packet.data.add("Pwd1",Pwd1);
			core.ajax.sendPacket(checkPwd_Packet);
			checkPwd_Packet=null;		
		}

		function getAccountId()
		{
			//得到帐户ID
		    	var getAccountId_Packet = new AJAXPacket("/npage/innet/f1100_getId.jsp","正在获得帐户ID，请稍候......");
			getAccountId_Packet.data.add("region_code","<%=regionCode%>");
			getAccountId_Packet.data.add("retType","AccountId");
			getAccountId_Packet.data.add("idType","1");
			getAccountId_Packet.data.add("oldId","0");
			core.ajax.sendPacket(getAccountId_Packet);
			getAccountId_Packet=null;
		}
		//调用公共界面，进行集团客户选择
		function getInfo_Cust(){
		    var pageTitle = "集团客户选择";
		    var fieldName = "证件号码|集团客户ID|集团用户ID|集团产品编号|集团ID|集团产品名称|集团名称|品牌|";/*diling update for s4112Init增加一个出参@2012/9/26 */
		    var sqlStr = "";
		    var selType = "S";    //'S'单选；'M'多选
		    var retQuence = "8|0|1|2|3|4|5|6|7|";/*diling update for s4112Init增加一个出参@2012/9/26 */
		    var retToField = "iccid|cust_id|unit_id|cust_name|unit_name|belong_code|grpName|vsmCode";/*diling update for s4112Init增加一个出参@2012/9/26 */
		    var cust_id = document.frm.cust_id.value;
		
		    if(document.frm.iccid.value == "" &&
		       document.frm.cust_id.value == "" &&
		       document.frm.unit_id.value == "")
		    {
		        rdShowMessageDialog("请输入身份证号、客户ID或集团编号进行查询！",0);
		        document.frm.iccid.focus();
		        return false;
		    }
		
		    if(document.frm.cust_id.value != "" && forNonNegInt(frm.cust_id) == false)
		    {
		    	frm.cust_id.value = "";
		        rdShowMessageDialog("必须是数字！",0);
		    	return false;
		    }
		
		    if(document.frm.unit_id.value != "" && forNonNegInt(frm.unit_id) == false)
		    {
		    	frm.unit_id.value = "";
		        rdShowMessageDialog("必须是数字！",0);
		    	return false;
		    }
		
		    if(PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));
		}
		
		function PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField){
		    var path = "<%=request.getContextPath()%>/npage/s3700/fpubgrpusr_sel.jsp";
		    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
		    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
		    path = path + "&selType=" + selType+"&iccid=" + document.all.iccid.value;
		    path = path + "&cust_id=" + document.all.cust_id.value;
		    path = path + "&unit_id=" + document.all.unit_id.value;
		
		    retInfo = window.open(path,"newwindow","height=450, width=800,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
		
			return true;
		}

		function getvaluecust(retInfo){
		  var retToField = "iccid|cust_id|unit_name|cust_name|unit_id|belong_code|grpName|vsmCode|";/*diling update for s4112Init增加一个出参@2012/9/26 */
		  if(retInfo ==undefined)      
		    {   return false;   }
		
			var chPos_field = retToField.indexOf("|");
		    var chPos_retStr;
		    var valueStr;
		    var obj;
		    while(chPos_field > -1)
		    {
		        obj = retToField.substring(0,chPos_field);
		        chPos_retInfo = retInfo.indexOf("|");
		        valueStr = retInfo.substring(0,chPos_retInfo);
		        document.all(obj).value = valueStr;
		        retToField = retToField.substring(chPos_field + 1);
		        retInfo = retInfo.substring(chPos_retInfo + 1);
		        chPos_field = retToField.indexOf("|");
		        
		    }
			document.all.grp_name.value = document.all.unit_name.value;
			getAccountMsg();
			/*begin add 当品牌代码为“DF”时，增加生效规则 for 省内代付产品付费关系生效规则优化@2015/3/26 */
			if(document.all.vsmCode.value == "DF"){
				$("#effectRuleTr").show();
			}else{
				$("#effectRuleTr").hide();
			}
			/*end add for 省内代付产品付费关系生效规则优化@2015/3/26 */
		}

		function getvalueProdAttr(retInfo)
		{
		  var retToField = "product_attr|";
		  if(retInfo ==undefined)      
		    {   return false;   }
		
			var chPos_field = retToField.indexOf("|");
		    var chPos_retStr;
		    var valueStr;
		    var obj;
		    while(chPos_field > -1)
		    {
		        obj = retToField.substring(0,chPos_field);
		        chPos_retInfo = retInfo.indexOf("|");
		        valueStr = retInfo.substring(0,chPos_retInfo);
		        document.all(obj).value = valueStr;
		        retToField = retToField.substring(chPos_field + 1);
		        retInfo = retInfo.substring(chPos_retInfo + 1);
		        chPos_field = retToField.indexOf("|");
		        
		    }
		    document.frm.product_code.value = "";
		    document.frm.product_append.value = "";
		}

		function PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
		{
		    var path = "<%=request.getContextPath()%>/npage/s3432/fpubprod_sel.jsp";
		    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
		    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
		    path = path + "&selType=" + selType;
			path = path + "&op_code=" + document.all.op_code.value;
			path = path + "&sm_code=" + document.all.sm_code.value; 
		    path = path + "&product_attr=" + document.all.product_attr.value; 
		
		    retInfo = window.open(path,"newwindow","height=450, width=650,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
		
			return true;
		}

		function getvalue(retInfo)
		{
		  var retToField = "product_code|product_name|";
		  if(retInfo ==undefined)      
		    {   return false;   }
		
		  document.all.product_code.value = retInfo;
		  document.frm.product_append.value = "";
		}
		function checkPwd(obj1,obj2)
		{
		        //密码一致性校验,明码校验
		        var pwd1 = obj1.value;
		        var pwd2 = obj2.value;
		        if(pwd1 != pwd2)
		        {
		                var message = "'" + obj1.v_name + "'和'" + obj2.v_name + "'不一致，请重新输入！";
		                rdShowMessageDialog(message,0);
		                if(obj1.type != "hidden")
		                {   obj1.value = "";    }
		                if(obj2.type != "hidden")
		                {   obj2.value = "";    }
		                obj1.focus();
		                return false;
		        }
		        return true;
		}
		function refMain(){
			getAfterPrompt();
			if (document.all.opType.value=='a' || document.all.opType.value=='u'){
				if (document.all.opMode.value=='phoneNo')
				{
					if(document.all.userPhone.value==""){
						rdShowMessageDialog("请输入用户号码！");
						return;
					}
				
					if (document.all.limitNum.value=='')
					{
						rdShowMessageDialog("请输入限额！");
						return;
					}
				}
				var temFeeCode="";
				var temDetailCode="";
				var temFeeName="";
				var temRateCode="";
				var temPayOrder="";
				var lsLen=document.all.l_msg.options.length;
				for(var i=0;i<lsLen;i++)
				{
					temPayOrder+=document.all.l_msg.options[i].text.substring(0,20).trim()+"#";
					temFeeCode+=document.all.l_msg.options[i].text.substring(21,42).trim()+"#";
					temDetailCode+=document.all.l_msg.options[i].text.substring(43,64).trim()+"#";
					temRateCode+=document.all.l_msg.options[i].text.substring(65,86).trim()+"#";
					temFeeName+=document.all.l_msg.options[i].text.substring(97,document.all.l_msg.options[i].text.length).trim()+"#";
				}
				//alert(temPayOrder);
				//alert(temFeeCode);
				//alert(temDetailCode);
				//alert(temRateCode);
				if (document.all.detailFlag.value=='Y'&&temPayOrder=="")
				{
					rdShowMessageDialog("请增加优惠明细！");
					return;
				}
				if (parseFloat(document.frm.should_handfee.value)==0)
				{
					document.frm.real_handfee.value="0.00";
				}
		        if (parseFloat(document.frm.should_handfee.value)<parseFloat(document.frm.real_handfee.value))
		        {
						rdShowMessageDialog("实收手续费应小于应收手续费");
						return false;	
		        }
				document.all.temPayOrder.value=temPayOrder;
				document.all.temFeeCode.value=temFeeCode;
				document.all.temDetailCode.value=temDetailCode;
				document.all.temRateCode.value=temRateCode;
				var checkFlag; //注意javascript和JSP中定义的变量也不能相同,否则出现网页错误.				
		    //说明:检测分成两类,一类是数据是否是空,另一类是数据是否合法.
		        //由于参数太多，需要通过form的post传输,因此,需要将传输的内容复制到隐含域中. yl.
		        document.frm.chgsrv_start.value = changeDateFormat(document.frm.chgsrv_start.value);
		        document.frm.chgsrv_stop.value  = changeDateFormat(document.frm.chgsrv_stop.value);
		        document.frm.sysnote.value = "操作员<%=workno%>对用户号码"+document.frm.userPhone.value+"进行批量付费计划"+document.all.opType.options[document.all.opType.selectedIndex].text;
		        document.frm.tonote.value = "操作员<%=workno%>对用户号码"+document.frm.userPhone.value+"进行批量付费计划"+document.all.opType.options[document.all.opType.selectedIndex].text;	
				getSysAccept();
			}
			else{
				if (document.all.opMode.value=='phoneNo')
				{
					if(document.all.userPhone.value==""){
						rdShowMessageDialog("请输入用户号码！");
						return;
					}
				}
				if (parseFloat(document.frm.should_handfee.value)==0)
				{
					document.frm.real_handfee.value="0.00";
				}
		        if (parseFloat(document.frm.should_handfee.value)<parseFloat(document.frm.real_handfee.value))
		        {
						rdShowMessageDialog("实收手续费应小于应收手续费");
						return false;	
		        }
				document.frm.sysnote.value = "操作员<%=workno%>对用户号码"+document.frm.userPhone.value+"进行批量付费计划"+document.all.opType.options[document.all.opType.selectedIndex].text;
		        document.frm.tonote.value = "操作员<%=workno%>对用户号码"+document.frm.userPhone.value+"进行批量付费计划"+document.all.opType.options[document.all.opType.selectedIndex].text;	
				getSysAccept();
			}
		}
		//打印相关
		 function printInfo(printType)
		 { 
		 	var cust_info=""; //客户信息
			var opr_info=""; //操作信息
			var note_info1=""; //备注1
			var note_info2=""; //备注2
			var note_info3=""; //备注3
			var note_info4=""; //备注4
		    var retInfo = "";  //打印内容
			
			cust_info+="客户姓名："+document.frm.grpName.value+"|";
			cust_info+="证件号码："+document.frm.iccid.value+"|";
	
	    	opr_info+="集团产品编号："+document.frm.cust_name.value+"|";
			opr_info+="付费帐户："+document.frm.accountMsg.value+"|";
	    	opr_info+="操作类型："+document.frm.opType.options[document.frm.opType.selectedIndex].text+"|";	  
	    	opr_info+="限额："+document.frm.limitNum.value+"|";			 
			
	    	opr_info+="业务类型：批量付费计划变更"+"|";
	    	opr_info+="流水："+document.frm.login_accept.value+"|";
	    	
	    	note_info1+="备注："+document.all.sysnote.value+"|";
	    	note_info1+=document.all.tonote.value+" "+document.all.simBell.value+"|";
	    	
	    	retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
			retInfo=retInfo.replace(new RegExp("#","gm"),"%23"); 
	
			 return retInfo;
		 }
		function showPrtDlg(printType,DlgMessage,submitCfm)
		{  //显示打印对话框
		   var h=210;
		   var w=400;
		   var t=screen.availHeight/2-h/2;
		   var l=screen.availWidth/2-w/2;
		
		   var pType="print";                                                                               
		   var billType="1";                                                                                 
		   var sysAccept=document.all.login_accept.value;                      
		   var printStr=printInfo(printType);                                                        
		   var mode_code=null;                                                  
		   var fav_code=null;                                                   
		   var area_code=null;                                                  
		   var opCode="<%=opCode%>";                                                   
		   var phoneNo="";                             
		
		   var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
		   var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_dz.jsp?DlgMsg=" + DlgMessage+ "&submitCfm=" + submitCfm;
		   path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+sysAccept+"&phoneNo="+phoneNo+"&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
		   var ret=window.showModalDialog(path,printStr,prop);
		   return ret;
		}
		//取流水
		function getSysAccept()
		{
			var getSysAccept_Packet = new AJAXPacket("pubSysAccept.jsp","正在生成操作流水，请稍候......");
			getSysAccept_Packet.data.add("retType","getSysAccept");
			core.ajax.sendPacket(getSysAccept_Packet);
			getSysAccept_Packet=null;  
		}
		 function f_add()
		 {
		   var choicedFeeCode="";
		   var Fees="";
		   for(var i=0;i<document.all.l_msg.options.length;i++)
		   {
		     choicedFeeCode=document.all.l_msg.options[i].text.substring(21,42).trim();
			 Fees+=choicedFeeCode+"|";
		   }
		
		   var h=600;
		   var w=700;
		   var t=screen.availHeight/2-h/2;
		   var l=screen.availWidth/2-w/2;
		   var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no"
		   var ret=window.showModalDialog("/npage/s1210/Dlg_s1212Add.jsp?Fees="+Fees,"",prop);
		   
		   if(typeof(ret)!="undefined")
		   {
		     var optNums=getTokNums(ret,"|");
		
		     var oneOpt;
		 	 if(opFlag=="mod" || opFlag=="add")
			 {
		       var existNum=document.all.l_msg.options.length;
			   if(existNum==-1) existNum=0;
			     var existOpt=new Array(existNum);
			     for(var i=0;i<existNum;i++){
		 	       existOpt[i]=document.all.l_msg.options[i].text;}
		
			     document.all.l_msg.options.length=0;
			     document.all.l_msg.options.length=optNums+existNum;
		         
				 var totalOpt=new Array(optNums+existNum);
			     var tem1="";
			     var temSeri="";
		
			     for(var i=0;i<existNum;i++)
			     {
				   totalOpt[i]=existOpt[i];
				   tem1+=totalOpt[i].substring(0,13).trim()+totalOpt[i].substring(21,42).trim()+"#";
				   temSeri+=i+"#";
			     }
		
			     for(var i=0;i<optNums;i++)
			     {
		           oneOpt=oneTok(ret,"|",i+1);
		        
				totalOpt[i+existNum]=oneTok(oneOpt,"#",4)+thinkAdd(oneTok(oneOpt,"#",4),21)+
					                 oneTok(oneOpt,"#",1)+thinkAdd(oneTok(oneOpt,"#",1),22)+
						             oneTok(oneOpt,"#",2)+thinkAdd(oneTok(oneOpt,"#",2),22)+
					                 oneTok(oneOpt,"#",5)+thinkAdd(oneTok(oneOpt,"#",5),22)+ 
					                 oneTok(oneOpt,"#",3);
		        
		           tem1+=totalOpt[i+existNum].substring(0,20).trim()+totalOpt[i+existNum].substring(21,42).trim()+"#";
				   temSeri+=(existNum+i)+"#";
			     }
		
			   //-------------------s_order---------------------
			   var tem2=orderOtherStr(tem1,temSeri,"#");
		 	   var len2=getTokNums(tem2,"#");
		       var orderArr=new Array(len2);
		
			   for(var i=0;i<optNums+existNum;i++)
			   {
		  	     orderArr[i]=oneTok(tem2,"#",i+1);
		 	   }
		
		   	   for(var i=0;i<optNums+existNum;i++){
			       document.all.l_msg.options[i].text=totalOpt[orderArr[i]];
				   }
		
		       //-------------------e_order---------------------
			 }
		   }
		 }
		   function thinkAdd(str,len)
		  {
		    var existLen=0;
			var one="";
			var ret="";
		
			for(var i=0;i<str.length;i++)
			{
		  	  existLen++;
			  if(str.charCodeAt(i)>127)
		        existLen++;
			}
		
			for(var i=0;i<len-existLen;i++)
				ret+=" ";
			return ret;
		  }
		 function f_del()
		 {
		   var newOpt=new Array();
		   var nowArr=0;
		
		   if(document.all.l_msg.selectedIndex=="-1")
			 {
			   rdShowMessageDialog("请先选择费用代码！");
			   return;
			 }
		
		   for(var i=0;i<document.all.l_msg.options.length;i++)
		   {
		     if(document.all.l_msg.options[i].selected==false)
			 {
		       newOpt[nowArr]=document.all.l_msg.options[i].text;
			   nowArr++;
			 }
		   }
		
		   document.all.l_msg.options.length=0;
		   document.all.l_msg.options.length=newOpt.length;
		
		   for(var i=0;i<newOpt.length;i++)
		   {
		      document.all.l_msg.options[i].text=newOpt[i];
		   }
		 }
		 //得到付费账户信息
		function getAccountMsg()
		{
				var param = "";
				var sqlStr = "";
				var wtcOutNum = "";
				
				var sm_code="";
		 		var sqlBuf="";
				var iccid=document.all.iccid.value;	  
				var unitId=document.all.unit_name.value;
				var myPacket = new AJAXPacket("CallCommONESQL.jsp","正在获得账户信息，请稍候......");
				//sqlBuf="select a.account_id from dgrpusermsg a,dcustdoc b where a.cust_id=b.cust_id and a.id_no='"+unitId+"'and b.id_iccid='"+iccid+"'";
				
				sqlBuf = "44";	
				params = "unitId="+unitId+",iccid="+iccid;
				myPacket.data.add("verifyType","getAccountId");
				
				myPacket.data.add("sqlBuf",sqlBuf);
				myPacket.data.add("params",params);
				//alert("sqlBuf=["+sqlBuf+"]"+"\n"+"params=["+params+"]");
				
				
				myPacket.data.add("recv_number",1);
				core.ajax.sendPacket(myPacket);
				myPacket=null;		
		}
		function changeDetail(){
			if(document.all.detailFlag.value=='Y'){
				document.all.b_add.disabled=false;
			}
			else
				document.all.b_add.disabled=true;
		}
		function changMode()
		{
			//alert("ww");
			if (document.all.opMode.value=="file")
			{
				 document.all.userPhone.value="";
				 document.all.USERNAME.value="";
			   document.all.userPhone.readOnly=true;
			   document.all.userPhone.v_must="0";
			   userPhonechange.style.display="none";
			   document.all.USERNAME.v_must="0";
			   USERNAMEchange.style.display="none";
			   PosFilechange.style.display="";
			   document.all.addCondConfirm.disabled=true;
			   document.all.PosFile.disabled=false;
			   
				document.all.limitNum.value="";
				document.all.limitNum.v_must="0";
				limitnumber.style.display="none";
				hiddenTip(document.all.limitNum);
				$("#limitNum").attr("disabled",true);

			}
			else
			{
			   document.all.userPhone.readOnly=false;
			   document.all.userPhone.v_must="1";
			   userPhonechange.style.display="";
			   document.all.USERNAME.v_must="1";
			   USERNAMEchange.style.display="";
			   PosFilechange.style.display="none";
			   document.all.addCondConfirm.disabled=false;
			   document.all.PosFile.disabled=true;
			  
			  	if(document.all.opType.value=="d")
				  { 
					document.all.limitNum.value="";
					document.all.limitNum.v_must="0";
					limitnumber.style.display="none";
					hiddenTip(document.all.limitNum);
					$("#limitNum").attr("disabled",true);
					}else {
					document.all.limitNum.value="";
					document.all.limitNum.v_must="1";
					limitnumber.style.display="";
					$("#limitNum").attr("disabled",false);
					}
			}
		}
		 function call_ISDNNOINFO()
		    {
		        if(!checkElement(document.frm.userPhone)) return false;
		
		        var path = "f3210_no_infor.jsp";
		        path = path + "?loginNo=" + document.all.workNo.value + "&phoneNo=" + document.all.userPhone.value;
		        path = path + "&opCode=" + "4112" + "&orgCode=<%=org_code%>";
		        path = path + "&v_smCode=" + document.all.vsmCode.value;/*diling add for 新增一个品牌参数@2012/9/26 */
		
		        var retInfo = window.showModalDialog(path);
		        if(typeof(retInfo) == "undefined")
		        {
		            document.all.USERNAME.value = "";
		            document.all.IDCARD.value = ""   ;
		        }else{
		            document.all.USERNAME.value = oneTokSelf(retInfo,"|",1);
		            document.all.IDCARD.value = oneTokSelf(retInfo,"|",2);
		        }
		    }
		function oneTokSelf(str,tok,loc)
		   {
		
		   var temStr=str;
		   //if(str.charAt(0)==tok) temStr=str.substring(1,str.length);
		   //if(str.charAt(str.length-1)==tok) temStr=temStr.substring(0,temStr.length-1);
		
		    var temLoc;
		    var temLen;
		    for(ii=0;ii<loc-1;ii++)
		    {
		       temLen=temStr.length;
		       temLoc=temStr.indexOf(tok);
		       temStr=temStr.substring(temLoc+1,temLen);
		    }
		    if(temStr.indexOf(tok)==-1)
		      return temStr;
		    else
		      return temStr.substring(0,temStr.indexOf(tok));
		  }
	  
  
		function changeOpType()
		{
			if(document.all.opType.value=="d")
			{
				document.all.limitNum.value="";
				document.all.limitNum.v_must="0";
				limitnumber.style.display="none";
				hiddenTip(document.all.limitNum);
				$("#limitNum").attr("disabled",true);
				//$("#detailFlag").attr("disabled",true);
				$("#deFlg1").css("display","none");
				$("#deFlg2").css("display","none");
				$("#b_add").attr("disabled",true);
				$("#filexzsm").html('<font class="orange">文件只能是文本文件，不支持EXCEL文件；格式为每行一个号码，最多200个号码。</font>');
			}
			else 
			{
				document.all.limitNum.value="";
				document.all.limitNum.v_must="1";
				limitnumber.style.display="";
				$("#limitNum").attr("disabled",false);
				//$("#detailFlag").attr("disabled",false);
				$("#deFlg1").css("display","");
				$("#deFlg2").css("display","");
				$("#b_add").attr("disabled",false);
				$("#filexzsm").html('<font class="orange">文件只能是文本文件，不支持EXCEL文件；格式为每行：一个号码、空格、限额，</br>如：13000000000 50</br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;13000000001 0</br>最多200个号码。</font>');
				if(document.all.opMode.value=="file") {
						document.all.limitNum.value="";
						document.all.limitNum.v_must="0";
						limitnumber.style.display="none";
						hiddenTip(document.all.limitNum);
						$("#limitNum").attr("disabled",true);
				}else {
				
				}
			}
		}
		function changeDateFormat(sDate)
		{
		year = sDate.substring(0,4);
		month= sDate.substring(4,6);
		day= sDate.substring(6,8);
		
		return year+"-"+month+"-"+day;
	
		}
</script>
</HEAD>
<BODY>    
        	<FORM action="" method="post" name="frm" ENCTYPE="multipart/form-data">        		
			<input type="hidden" id="hidPwd" name="hidPwd">
			<input type="hidden" name="chgsrv_start" value="">
			<input type="hidden" name="chgsrv_stop"  value="">
			<input type="hidden" name="product_level"  value="1">
			<input type="hidden" name="product_name"  value="集团BOSS优惠">
			<input type="hidden" name="belong_code"  value="">
			<input type="hidden" name="prod_appendname"  value="">
			<input type="hidden" name="tfFlag" value="n">
			<input type="hidden" name="chgpkg_day"   value="">
			<input type="hidden" name="TCustId"  value="">
			<input type="hidden" name="unit_name"  value="">
			<input type="hidden" name="tmp1"  value="">
			<input type="hidden" name="tmp2"  value="">
			<input type="hidden" name="tmp3"  value="">
			<input type="hidden" name="org_id"  value="<%=OrgId%>">
			<input type="hidden" name="group_id"  value="<%=GroupId%>">
			<input type="hidden" name="login_accept"> <!-- 操作流水号 -->
			<input type="hidden" name="bill_type"  value="0"> <!-- 出帐周期 -->				
			<input type="hidden" name="grp_name"  value="">
			<input type="hidden" name="product_prices"  value="">
			<input type="hidden" name="product_type"  value="服">
			<input type="hidden" name="service_code"  value="M001">
			<input type="hidden" name="service_attr"  value="np000000">
			<input type="hidden" name="pay_no"  value="">
			<input type="hidden" name="grpName"  value="">
			<input type="hidden" name="vsmCode"  value=""><!-- diling add for 品牌@2012/9/26 -->
			<input type="hidden" name="temPayOrder"  value="">
			<input type="hidden" name="temFeeCode"  value="">
			<input type="hidden" name="temDetailCode"  value="">
			<input type="hidden" name="temRateCode"  value="">
			<input type="hidden" name="opCode"  value="4112">
			<input type="hidden" name="OrgCode"  value="<%=org_code%>">
			<input type="hidden" name="region_code"  value="<%=regionCode%>">
			<input type="hidden" name="district_code"  value="<%=districtCode%>">
			<input type="hidden" name="town_code"  value="<%=townCode%>">
			<input type="hidden" name="workNo"   value="<%=workno%>">
			<input type="hidden" name="NoPass"   value="<%=nopass%>">
			<input type="hidden" name="ip_Addr"  value=<%=ip_Addr%>>
			<input type="hidden" name="IDCARD"  value="">
			<input type="hidden" name=favFlag value="<%=favFlag%>">			
			<input  type="hidden" name="tonote" size="60">			
			<%@ include file="/npage/include/header.jsp" %>  
			<div class="title">
				<div id="title_zi">批量付费计划变更</div>
			</div>	
		<table  cellspacing="0">
          		<TR>
           	 		<TD width="18%" class="blue">身份证号</TD>
            			<TD width="32%">
                			<input name=iccid  id="iccid" size="24" maxlength="18" v_type="string" v_must=1  index="1" >
                			<input class="b_text" name=custQuery type=button id="custQuery"  onMouseUp="getInfo_Cust();" onKeyUp="if(event.keyCode==13)getInfo_Cust();" style="cursor:hand" value=查询>
                			<font class="orange">*</font>
            			</TD>
            			<TD width="18%" class="blue">集团客户ID</TD>
            			<TD width="32%">
              				<input  type="text" name="cust_id" size="20" maxlength="20" v_type="0_9" v_must=1  index="2" >
              				<font class="orange">*</font>
            			</TD>
          		</TR>
          		<TR>
            			<TD class="blue">集团编码</TD>
            			<TD>
		    			<input name=unit_id  id="unit_id" size="24" maxlength="20" v_type="0_9" v_must=1  index="3" >
            				<font class="orange">*</font>
            			</TD>
            			<TD width=18% class="blue">集团产品编号</TD>
            			<TD width=32%>
              				<input  name="cust_name" size="20"  v_must=1 v_type=string  index="4" readonly class="InputGrey">
              				<font class="orange">*</font> 
              			</TD>
          		</TR>
          			<TR>           
            				<TD class="blue">付费帐户</TD>
            				<TD>
			  			<select name='accountMsg' v_type="string"  v_must="1">
			  			</select>
			  			<font class="orange">*</font>
            				</TD>
            				<td>
            					&nbsp;
            				</td>
            				<td>
            					&nbsp;
            				</td>
					
          			</TR>
		  		<TR>
          <TD width=18% class="blue">操作类型</TD>
					<TD>   
						  <select name="opType" onchange="changeOpType()">
							  <option value="a">增加</option>
							  <option value="u">修改</option>
							  <option value="d">删除</option>
						  </select>
			  			<font class="orange">*</font>
            				</TD>
            				<TD width=18% class="blue">操作方式</TD>
            				<TD width=32%>
						  <select name="opMode" onchange="changMode()">
							  <option value="phoneNo">单个号码</option>
							  <option value="file">批量</option>
						  </select>
              					  <font class="orange">*</font> 
          	</TD>
          </TR>
          <TR id="effectRuleTr" style="display:none">
          	<TD width=18% class="blue">生效规则</TD>
						<TD colspan="3">   
						  <select name="effectRule" id="effectRule">
							  <option value="0">0-立即生效</option>
							  <option value="1">1-下账期生效</option>
						  </select>
			  			<font class="orange">*</font>
          	</TD>
          </TR>
		  		<TR>
            				<TD class="blue">用户号码</TD>
            				<TD> 
            					<input name="userPhone"  id="userPhone" size="24" maxlength="15" v_type="0_9" v_must=1  index="3">
						<input name="addCondConfirm" type="button"  class="b_text" id="addCondConfirm" value="查询" onClick="call_ISDNNOINFO()">
            					<font class="orange" id=userPhonechange style="display:bolck">*</font>
            				</TD>
            				<TD width=18% class="blue">用户名称</TD>
            				<TD width=32%>
              					<input  name="USERNAME" size="20" v_must=1 v_type=string index="4" onblur="checkElement(this)" readOnly>
              					<font class="orange" id=USERNAMEchange style="display=''">*</font> 
            				</TD>
          			</TR>
		  		<TR>
            				<TD  class="blue">文件名称</TD>
            				<TD>
						<input type="file" name="PosFile" id="PosFile" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;'>
            					<font class="orange" id=PosFilechange style="display:none">*</font>
            				</TD>
					<TD  class="blue">限额</TD>
            				<TD nowrap>
		    				<input name="limitNum"  id="limitNum" size="24" maxlength="10" v_type="0_9" v_must=1  index="3" onblur="checkElement(this)"><font class="orange" id=limitnumber style="display:">*</font>
            				</TD>
            
					
          			</TR>
		  		<TR>
		  			<TD width=18% class="blue">文件限制说明</TD>
            <TD width=32% class="blue" id="filexzsm"><font class="orange">文件只能是文本文件，不支持EXCEL文件；格式为每行：一个号码、空格、限额，</br>如：13000000000 50</br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;13000000001 0</br>最多200个号码。</font></TD>
            		<TD width=18% class="blue"><span id="deFlg1">明细标志</span>&nbsp;</TD>
					<TD><span id="deFlg2">
						  <select name="detailFlag" id="detailFlag" onchange="changeDetail()">
							  <option value="Y">有明细</option>
							  <option value="N">无明细</option>
						  </select>
			  			<font class="orange">*</font>
			  	<!--
						<TD width=18% class="blue">停机标记</TD>
            <TD width=32%>			
						  <select name="stopFlag">
							  <option value="Y">停机</option>
							  <option value="N">不停机</option>
						  </select>
              					<font class="orange">*</font> 
            </TD>
						-->
						<input type="hidden" name="stopFlag" value="Y">
                    </span>&nbsp;
          			</TR>
		  		<TR>
					  <%
							String result = "0.0";	 
							sqlStr = "select hand_fee from snewfunctionfee where function_Code ='4112'";
						%>
							<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode1%>"  retcode="retCode1" retmsg="retMsg1" outnum="3">
								<wtc:sql><%=sqlStr%></wtc:sql>
							</wtc:pubselect>
							<wtc:array id="result1" scope="end" />
						
						<%
							
				                	//retArray = callView.sPubSelect("1",sqlStr);
				                	//result = (String[][])retArray.get(0);
				                	if(result1!=null&&result1.length>0){
				                		if (!"".equals(result1[0][0])){
									result=result1[0][0];
								}
				                	}
				                							
						%>
					<TD width="16%" class="blue">应收手续费</TD>
					<TD width="34%">
						<input  name="should_handfee" id="should_handfee" value="<%=result%>" readonly class="InputGrey">
					</TD>
					<TD width="16%" class="blue">实收手续费</TD>
					<TD width="34%">
						<input  name="real_handfee" id="real_handfee" value="">
					</TD>
		   		</TR>	
		   	</table>
		   	<br>
		   	<div class="title">
				<div id="title_zi">付费明细</div>
			</div>	
			
              		<table  cellspacing="0">                		
                			<th> <div align="center"> 冲销顺序</div></th>
                			<th> <div align="center"> 费用代码</div></th>
                			<th> <div align="center"> 明细代码</div></th>
                			<th> <div align="center"> 费用比率</div></th>
                			<th> <div align="center"> 费用名称</div></th>                		
                		</tr>
                		<tr> 
			                  <td colspan="5"> 
			                    	<div align="center"> 
			                      		<select name="l_msg" size="10" multiple index="14">
			                      		</select>
			                    	</div>
			                  </td>
                		</tr>
                	</table>
                	<table  cellspacing="0">
                		<tr> 
			                  <td colspan="5"> 
			                    	<div align="center"> 
			                      		<input  type="button" name="b_add" id="b_add" class="b_text" value="增加" onmouseup="f_add()"  onkeyup="if(event.keyCode==13)f_add()" index="15">
			                      		<input  type="button" name="b_del" class="b_text"  value="删除" onmouseup="f_del()"  onkeyup="if(event.keyCode==13)f_del()" index="16">
			                    	</div>
			                  </td>
                		</tr>
              		</table>
            		<div class="title">
				<div id="title_zi">其他信息</div>
			</div>	
       			<table  cellspacing="0">
		           <TR>
			               <TD class="blue">备注</TD>
			               <TD colspan="3">
			               		<input  name="sysnote" size="60" readonly class="InputGrey">
			               </TD>
		           </TR>    
          		</table>
          		<table  cellspacing="0">
          			<tr>
		              		<TD id="footer">
					  	<%if(favFlag==1){%>
					 		<input  name="sure"  class="b_foot" type=button value="确认" onclick="refMain()" >
						<%} else {%>
							<input  name="sure"  class="b_foot" type=button value="确认" onclick="refMain()">
						<%}%>
		              			<input  name="reset1" class="b_foot" onClick="" type=reset value="清除">
		              			<input  name="kkkk"  class="b_foot" onClick="removeCurrentTab();" type=button value="关闭">
              				</TD>
            			</TR>
            		</table>
            		<%@ include file="/npage/include/footer.jsp" %>	
              </FORM> 
	 <script language="JavaScript">
	 	document.frm.iccid.focus();
	 </script>
</BODY>
</HTML>
