<%
/********************
 version v2.0
 开发商: si-tech
 2015/12/17 15:35:24 gaopeng 批量普通开户
********************/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="/npage/bill/getMaxAccept.jsp" %>
<%@ page import="java.text.SimpleDateFormat"%> <!--二代证-->
<%        
  //Logger logger = Logger.getLogger("f1100_1.jsp");
  //ArrayList retArray = new ArrayList();
  //String[][] result = new String[][]{};
  // S1100View callView = new S1100View(); 
  String printAccept = "";
  String IccIdAccept="";
  response.setHeader("Pragma","No-cache");
  response.setHeader("Cache-Control","no-cache"); 
  Calendar today =   Calendar.getInstance();  
  today.add(Calendar.MONTH,3);
  SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");  
  String addThreeMonth = sdf.format(today.getTime());
  System.out.println("### addThreeMonth = "+addThreeMonth);
  String dateStr2 =  new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
  String currTime = new SimpleDateFormat("yyyyMMdd HH:mm:ss", Locale.getDefault()).format(new Date());
%>
<%
    /**        
    ArrayList arr = (ArrayList)session.getAttribute("allArr");
    String[][] baseInfo = (String[][])arr.get(0);
    String[][] agentInfo = (String[][])arr.get(2);
    String workNo = baseInfo[0][2];
    String workName = baseInfo[0][3];
    String Role = baseInfo[0][5];
    String Department = baseInfo[0][16];
    String belongCode = Department.substring(0,7);
    String ip_Addr = agentInfo[0][2];
    String regionCode = Department.substring(0,2);
    String districtCode = Department.substring(2,4);
    String rowNum = "16";
    String getAcceptFlag = "";
    **/   
    String loginAccept = getMaxAccept();
    // zhouby add for 开户优惠权限
    String[][] temfavStr = (String[][])session.getAttribute("favInfo");
    String[] favStr = new String[temfavStr.length];
    boolean openFav = false;
    for(int i = 0; i < favStr.length; i ++) {
    	favStr[i] = temfavStr[i][0].trim();
    }
    if (WtcUtil.haveStr(favStr, "a386")) {
    	openFav = true;
    }
    
    String opCode=request.getParameter("opCode");
    String opName=request.getParameter("opName");
    String workNo =(String)session.getAttribute("workNo");
    String workName =(String)session.getAttribute("workName");
    String powerRight =(String)session.getAttribute("powerRight");
    String Role =(String)session.getAttribute("Role");
    String orgCode =(String)session.getAttribute("orgCode");
    String regionCode = orgCode.substring(0,2);
    String groupId =(String)session.getAttribute("groupId");
    String ip_Addr =(String)session.getAttribute("ip_Addr");
    String belongCode =orgCode.substring(0,7);
    String districtCode =orgCode.substring(2,4);
    String rowNum = "16";
    String getAcceptFlag = "";
    
    String accountType =  (String)session.getAttribute("accountType")==null?"":(String)session.getAttribute("accountType");//1 为营业工号 2 为客服工号
%>
<%
String passwd = ( String )session.getAttribute( "password" );
String workChnFlag = "0" ;
%>
<wtc:service name="s1100Check" outnum="30"
	routerKey="region" routerValue="<%=regionCode%>" retcode="rc" retmsg="rm" >
	<wtc:param value = ""/>
	<wtc:param value = "01"/>
	<wtc:param value = "<%=opCode%>"/>
	<wtc:param value = "<%=workNo%>"/>
	<wtc:param value = "<%=passwd%>"/>
		
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
%>

<%
   /**     //取得打印流水
        try
        {
                String sqlStr ="select sMaxSysAccept.nextval from dual";
                retArray = callView.view_spubqry32("1",sqlStr);
                result = (String[][])retArray.get(0);
                printAccept = (result[0][0]).trim();
        }catch(Exception e){
                out.println("rdShowMessageDialog('取系统操作流水失败！',0);");
                getAcceptFlag = "failed";
        }    
        **/
     String sqlStrl ="select sMaxSysAccept.nextval from dual";
    //取得打印流水(替换原ejb)   新页面改造 20080828
  %>
    <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCodel" retmsg="retMsgl" outnum="1">
    <wtc:sql><%=sqlStrl%></wtc:sql>
    </wtc:pubselect>
    <wtc:array id="resultl" scope="end" />
  <%
    if(retCodel.equals("000000")){
        printAccept = (resultl[0][0]).trim();
      IccIdAccept = printAccept;/*wangdana add*/
    }else{
      getAcceptFlag = "failed";
    }               
  String sqlStrl0 ="SELECT count(*) FROM dChnGroupMsg a,dbChnAdn.sChnClassMsg b WHERE a.group_id='"+groupId+"' AND a.is_active='Y' AND a.class_code=b.class_code AND b.class_kind='2'";  
  %> 
    <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCodel0" retmsg="retMsgl0" outnum="1">
    <wtc:sql><%=sqlStrl0%></wtc:sql>
    </wtc:pubselect>
    <wtc:array id="resultl0" scope="end" />
  
  <%
  /* add by qidp @ 2009-08-12 for 兼容端到端流程 . */
      String inputFlag = (String)request.getParameter("inputFlag");   //标示位，值为1时表示是从销售方面转入
      System.out.println("# inputFlag = "+inputFlag);
      String cont_tp = "";
      String group_name = "";
      String cont_user = "";
      String cont_mobile = "";
      String cont_addr = "";
      String cont_email = "";
      String cont_zip = "";
      
      if("1".equals(inputFlag)){
          cont_tp = (String)request.getParameter("cont_tp");          //集团客户级别
          group_name = (String)request.getParameter("group_name");    //集团客户名称
          cont_user = (String)request.getParameter("cont_user");      //集团客户联系人
          cont_mobile = (String)request.getParameter("cont_mobile");  //集团客户联系电话
          cont_addr = (String)request.getParameter("cont_addr");      //集团客户联系地址
          cont_email = (String)request.getParameter("cont_email");    //集团客户联系邮箱
          cont_zip = (String)request.getParameter("cont_zip");        //集团客户联系邮编
      }
  /* end by qidp @ 2009-08-12 for 兼容端到端流程 . */
  %>
<!------------------------------------------------------------->
<html> 
<head>
<title>客户开户</title>
<meta content=no-cache http-equiv=Pragma>
<meta content=no-cache http-equiv=Cache-Control>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/product/autocomplete_ms.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/product/product.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/si/validate_class.js"></script>
<script type="text/javascript" src="/npage/public/checkGroup.js" ></script>
</head>
<!----------------------------------------------------------------->
<SCRIPT type=text/javascript>
var numStr="0123456789"; 
 
var v_groupId = "<%=groupId%>";
var v_printAccept = "<%=printAccept%>";
var v_workNo = "<%=workNo%>";
var phone_no = "";

onload=function(){
	getId();
	setOfferType();
	addRegCode();
	reSetCustName();
  /**
  if("09" == "<%=regionCode%>"){
    var divPassword = document.getElementById("divPassword"); 
      divPassword.style.display="none";
  }
  */
  /*2013/11/07 21:15:23 gaopeng 获取证件类型方法*/		
  if("<%=opCode%>" == "1993"){
  $("#gestoresInfo1").show();
  	$("#gestoresInfo2").show();
  	/*经办人姓名*/
  	document.all.gestoresName.v_must = "1";
  	/*经办人地址*/
  	document.all.gestoresAddr.v_must = "1";
  	/*经办人证件号码*/
  	document.all.gestoresIccId.v_must = "1";
  	var checkIdType = $("select[name='gestoresIdType']").find("option:selected").val();
  	/*身份证加入校验方法*/
  	if(checkIdType.indexOf("身份证") != -1){
  		document.frm1100.gestoresIccId.v_type = "idcard";
  		$("#scan_idCard_two3").css("display","");
  		$("#scan_idCard_two31").css("display","");
  	}else{
  		document.frm1100.gestoresIccId.v_type = "string";
  		$("#scan_idCard_two3").css("display","none");
  		$("#scan_idCard_two31").css("display","none");
  	}
		$("input[name='gestoresName']").attr("class","InputGrey");
		$("input[name='gestoresName']").attr("readonly","readonly");
		$("input[name='gestoresAddr']").attr("class","InputGrey");
		$("input[name='gestoresAddr']").attr("readonly","readonly");
		$("input[name='gestoresIccId']").attr("class","InputGrey");
		$("input[name='gestoresIccId']").attr("readonly","readonly");
  }
  	
  getIdTypes();
}
/*2013/11/07 21:14:36 gaopeng 关于实名制工作需求整合的函*/
function getIdTypes(){
	
	 var checkVal = $("select[name='isJSX']").find("option:selected").val();
   var getdataPacket = new AJAXPacket("/npage/sq100/fq100GetIdTypes.jsp","正在获得数据，请稍候......");
			
			getdataPacket.data.add("checkVal",checkVal);
			getdataPacket.data.add("opCode","<%=opCode%>");
			getdataPacket.data.add("opName","<%=opName%>");
			getdataPacket.data.add("workChnFlag","<%=workChnFlag%>");
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
}


//dujl add at 20100415 for 身份证校验
function checkIccId()
{
  if(document.all.idType.value.split("|")[0] != "0")
  {
    rdShowMessageDialog("只有身份证可以校验！");
    return false;
  }
  if(document.all.custName.value.trim() == "")
  {
    rdShowMessageDialog("请先输入客户名称！");
    return false;
  }
  if(document.all.idIccid.value.trim() == "")
  {
    rdShowMessageDialog("请先输入证件号码！");
    return false;
  }
  if(document.all.ziyou_check.value != 0)
  {
    rdShowMessageDialog("非自有营业厅不可以查询！");
    return false;
  }
  var Str = document.all.idType.value;
  
    if(Str.indexOf("身份证") > -1){
      if($("#idIccid").val().length<18){
        rdShowMessageDialog("身份证号码必须是18位！");
        document.all.idIccid.focus();
        return false;
      }
    }
  
  //document.all.iccIdCheck.disabled=true;
  var myPacket = new AJAXPacket("/npage/innet/fIccIdCheck.jsp","正在验证身份证信息，请稍候......");
  myPacket.data.add("retType","iccIdCheck");
  myPacket.data.add("idIccid",document.all.idIccid.value);
  myPacket.data.add("custName",document.all.custName.value);
  myPacket.data.add("IccIdAccept",document.all.IccIdAccept.value);
  myPacket.data.add("opCode",document.all.opCode.value);
  core.ajax.sendPacket(myPacket);
  myPacket=null;
  //document.all.iccIdCheck.disabled=false;
}



//   copy from common_util.js   页面改造   liutong@20080828
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

//--------------------------------------------
//清空上级客户信息
function clear_CustInfo()
{
        for(i=0;i<6;i++)
        {          
                var obj = "in" + i;
                document.all(obj).value = "";
        }
}
//--------------------------------------------
function check_newCust(){ 

}
function check_oldCust(){
  /**
  if("09" == "<%=regionCode%>")
  {
    var divPassword = document.getElementById("divPassword"); 
      divPassword.style.display="none";
  }*/
  document.getElementById("svcLvl").style.display="none";
  document.getElementById("trU00020003").style.display="none";
  document.all.Reset.click();
 
  document.all.oldCust.checked=true;
         //并客户的相关域控制    
    if(document.frm1100.oldCust.checked == true)
    {
        window.document.frm1100.newCust.checked = false;
        var temp2="tbs"+9;           
            document.all(temp2).style.display="";
    }
}

function change(){      
        //对附加资料隐藏域的控制       
        var ic = document.frm1100.ownerType.options[document.frm1100.ownerType.selectedIndex].value;
        document.getElementById("preBox").style.checked=false;//wangzn 091203
    if(ic=="01")
      { 
            document.all("tb0").style.display="";   
        document.all("tb1").style.display="none";      
        document.all("td2").style.display="none";
        document.all("td3").style.display="none";
        document.all("checkName").style.display="none";
        document.all("ownerType_Type").style.display="";/** tianyang add for custNameCheck **/
        document.all("print").disabled=true;
        //document.all.custPwd.value="123456";
        //document.all.cfmPwd.value="123456";
       document.getElementById("preBox").style.display="none";//wangzn 091201
          document.getElementById("svcLvl").style.display="none";//zhangyan 2011-12-13 15:46:32 
          document.getElementById("trU00020003").style.display="none";//zhangyan 2011-12-13 15:46:32  
    }
    else if(ic=="02")
    {
         document.all("tb0").style.display="none";
         document.all("tb1").style.display="none";
         document.all("td2").style.display="none";
         document.all("td3").style.display="";   
         document.all("checkName").style.display="inline";
         document.all("ownerType_Type").style.display="none";/** tianyang add for custNameCheck **/
         document.all("print").disabled=true;
         //document.all.custPwd.value="111111";
       //document.all.cfmPwd.value="111111";
         document.getElementById("preBox").style.display="";//wangzn 091201
            document.getElementById("svcLvl").style.display="";//zhangyan 2011-12-13 15:46:32
            document.getElementById("trU00020003").style.display="";//zhangyan 2011-12-13 15:46:32
    }
    else if(ic=="03")
    {
         document.all("tb0").style.display="none";
         document.all("tb1").style.display="none";
         document.all("td2").style.display="";    
         document.all("td3").style.display="none";
         document.all("checkName").style.display="none";
         document.all("ownerType_Type").style.display="none";/** tianyang add for custNameCheck **/
         document.all("print").disabled=true;
           document.getElementById("preBox").style.display="none";//wangzn 091201
      document.getElementById("svcLvl").style.display="none";//zhangyan 2011-12-13 15:46:32 
      document.getElementById("trU00020003").style.display="none";//zhangyan 2011-12-13 15:46:32  
    }
    else if(ic=="04")
    {
       document.all("tb0").style.display="none";
       document.all("tb1").style.display="none";
         document.all("td2").style.display="none";
         document.all("td3").style.display="";   
         document.all("checkName").style.display="inline";
         document.all("ownerType_Type").style.display="none";/** tianyang add for custNameCheck **/
         document.all("print").disabled=true;
         document.getElementById("preBox").style.display="";//wangzn 091201
         //document.all.custPwd.value="111111";
       //document.all.cfmPwd.value="111111";
    document.getElementById("svcLvl").style.display="";//zhangyan 2011-12-13 15:46:32 
    document.getElementById("trU00020003").style.display="";//zhangyan 2011-12-13 15:46:32  
    }
    
  //dujl add at 20100421 for 身份证校验
  if(document.all.ownerType.value != "01")
  {
    //document.all.iccIdCheck.disabled = true;
  }
  else
  {
    //document.all.iccIdCheck.disabled = false;
  }
}

function change_instigate()
{
  if(document.all.instigate_flag.value=="Y")
  {
    document.all.getcontract_flag.disabled=false;
  }
  else
  {
    document.all.getcontract_flag.value="0";
    document.all.getcontract_flag.disabled=true;
  }
}

function change_idType()//二代证
{   
     var Str = document.all.idType.value;
     
	  /* begin diling update for 关于增加开户界面客户登记信息验证功能的函@2013/9/22 */
   
      checkCustNameFunc16New(document.all.custName,0,1); //校验客户名称是否符合
      
      if(Str.indexOf("军官证") > -1){
  	    $("#idAddrDiv").text("证件地址(部别)");
  	  }else{
  	    $("#idAddrDiv").text("证件地址");
  	  }
  	  
    
	  /* end diling update@2013/9/22 */
      
    if(document.all.idType.value=="0|身份证")
    { 
      document.all.pa_flag.value="1"; 
   
    
    }
    else{
     
    document.all.pa_flag.value="0";
  }
    var Str = document.frm1100.idType.value;
    
    if(Str.indexOf("身份证") > -1)
    {   document.frm1100.idIccid.v_type = "idcard";   }
    else
    {   document.frm1100.idIccid.v_type = "string";   }
    /*document.all.print.disabled=true;*/
}

function change_custPwd()
{   
  
    /*
    if(frm1100.checkPwd_Flag.value != "true");
    {
      rdShowMessageDialog("上级客户密码校验失败，请重新输入！",0);
      frm1100.parentPwd.value = "";
      frm1100.parentPwd.focus();
      return false;           
    }
    frm1100.checkPwd_Flag.value = "false"; 
    */
}
//------------------------------------
function printCommit()
{    
	/*2013/11/18 15:09:28 gaopeng 加入提交之前的校验 关于进一步提升省级支撑系统实名登记功能的通知 start*/
	/*重新校验*/
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
				/*gaopeng 20131216 2013/12/16 19:50:11 关于在BOSS入网界面增加单位客户经办人信息的函 加入经办人信息确认服务前校验 start*/
				/*经办人姓名*/
					if(!checkElement(document.all.gestoresName)){
						return false;
					}
					/*经办人联系地址*/
					if(!checkElement(document.all.gestoresAddr)){
						return false;
					}
					/*经办人证件号码*/
					if(!checkElement(document.all.gestoresIccId)){
						return false;
					}
	/*2013/11/18 15:09:28 gaopeng 加入提交之前的校验 关于进一步提升省级支撑系统实名登记功能的通知 end*/
	
	
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
	
	
	
        if((document.all.opNote.value).trim().length==0)
        {//luxc20061218修改备注字段 防止太长插不近wchg表
                document.all.opNote.value="<%=workName%>"+"批量预开户";
        }
        if((document.all.opNote.value).trim().length>60)
        {
          rdShowMessageDialog("用户备注的值不正确，长度有错误！");
          document.all.opNote.focus();
          return false;
        }
        
        var selOrderVal = $.trim($("input[name='selOrder'][checked]").val());
        if(selOrderVal.length == 0){
        	rdShowMessageDialog("请查询并选择销售品！");
          return false;
        }
        
        //myTest();
        
      if(!check(frm1100)){
      	return false;
      }else{
      if(rdShowConfirmDialog("确认要提交批量开户信息吗？")==1) {
        <% if("1".equals(inputFlag)){ %>
          document.frm1100.target="hidden_frame";
        <% }else{ %>
          //二代证
          frm1100.target=""; 
        <% } %>
        
        
        
        /*执行上传文件操作，上传文件后调用服务*/
				if($("#uploadFile").val() == ""){
					rdShowMessageDialog("请选择批量导入文件！");
					$("#uploadFile").focus();
					return false;
				}
        
        var formFile=document.all.uploadFile.value.lastIndexOf(".");
				var beginNum=Number(formFile)+1;
				var endNum=document.all.uploadFile.value.length;
				formFile=document.all.uploadFile.value.substring(beginNum,endNum);
				formFile=formFile.toLowerCase(); 
				if(formFile!="txt"){
					rdShowMessageDialog("上传文件格式只能是txt，请重新选择文件！",1);
					document.all.uploadFile.focus();
					return false;
				}
				else
					{
var jsp_action="fm349Upload_cfm.jsp?opCode=<%=opCode%>&opName=<%=opName%>"+
"&printAccept="+document.all.printAccept.value+
"&ownerType="+document.all.ownerType.value+
"&isJSX="+document.all.isJSX.value+
"&districtCode="+document.all.districtCode.value+
"&custName="+document.all.custName.value+
"&idType="+document.all.idType.value+
"&idIccid="+document.all.idIccid.value+
"&idAddr="+document.all.idAddr.value+
"&idValidDate="+document.frm1100.idValidDate.value+
"&custAddr="+document.all.custAddr.value+
"&contactPerson="+document.all.contactPerson.value+
"&contactPhone="+document.all.contactPhone.value+
"&contactAddr="+document.all.contactAddr.value+
"&contactPost="+document.all.contactPost.value+
"&contactFax="+document.all.contactFax.value+
"&contactMail="+document.all.contactMail.value+
"&contactMAddr="+document.all.contactMAddr.value+
"&gestoresName="+document.all.gestoresName.value+
"&gestoresAddr="+document.all.gestoresAddr.value+
"&gestoresIdType="+document.all.gestoresIdType.value+
"&gestoresIccId="+document.all.gestoresIccId.value+
"&sysNote="+document.all.sysNote.value+
"&selOrder="+$.trim($("input[name='selOrder'][checked]").val())+
"&responsibleName="+document.all.responsibleName.value+
"&responsibleAddr="+document.all.responsibleAddr.value+
"&responsibleType="+document.all.responsibleType.value+
"&responsibleIccId="+document.all.responsibleIccId.value+
"&xqdm="+xqdm+
"&endStr="+document.all.endStr.value;
																													 
						/*准备上传*/
				    document.frm1100.encoding="multipart/form-data";
				    document.frm1100.action=jsp_action;
				    document.frm1100.method="post";
				    document.frm1100.submit();
						return true;
					}
      }
      
    }
  
}

function chkValid()
{
     var d= (new Date().getFullYear().toString()+(((new Date().getMonth()+1).toString().length>=2)?(new Date().getMonth()+1).toString():("0"+(new Date().getMonth()+1)))+(((new Date().getDate()).toString().length>=2)?(new Date().getDate()):("0"+(new Date().getDate()))).toString());

   if((frm1100.idValidDate.value).trim().length>0)
   {     
        if(validDate(frm1100.idValidDate)==false) return false;

      if(to_date(frm1100.idValidDate)<=d)
      {
      rdShowMessageDialog("证件有效期不能早于当前时间，请重新输入！");
        document.all.idValidDate.focus();
      document.all.idValidDate.select();
        return false;
      }
  }
}

function validDate(obj)
{
  var theDate="";
  var one="";
  var flag="0123456789";
  for(i=0;i<obj.value.length;i++)
  { 
     one=obj.value.charAt(i);
     if(flag.indexOf(one)!=-1)
     theDate+=one;
  }
  if(theDate.length!=8)
  {
  rdShowMessageDialog("日期格式有误，正确格式为“年年年年月月日日”，请重新输入！");
  
  obj.select();
  obj.focus();
  return false;
  }
  else
  {
     var year=theDate.substring(0,4);
   var month=theDate.substring(4,6);
   var day=theDate.substring(6,8);
   if(myParseInt(year)<1900 || myParseInt(year)>3000)
   {
       rdShowMessageDialog("年的格式有误，有效年份应介于1900-3000之间，请重新输入！");
     
     obj.select();
     obj.focus();
     return false;
   }
     if(myParseInt(month)<1 || myParseInt(month)>12)
   {
       rdShowMessageDialog("月的格式有误，有效月份应介于01-12之间，请重新输入！");
       
     obj.select();
     obj.focus();
     return false;
   }
     if(myParseInt(day)<1 || myParseInt(day)>31)
   {
       rdShowMessageDialog("日的格式有误，有效日期应介于01-31之间，请重新输入！");
    
     obj.select();
       obj.focus();
     return false;
   }

     if (month == "04" || month == "06" || month == "09" || month == "11")             
   {
         if(myParseInt(day)>30)
         {
         rdShowMessageDialog("该月份最多30天,没有31号！");
         
       obj.select();
           obj.focus();
             return false;
         }
      }                 
       
      if (month=="02")
      {
         if(myParseInt(year)%4==0 && myParseInt(year)%100!=0 || (myParseInt(year)%4==0 && myParseInt(year)%400==0))
     {
           if(myParseInt(day)>29)
       {
         rdShowMessageDialog("闰年二月份最多29天！");
             //obj.value="";
       obj.select();
           obj.focus();
             return false;
       }
     }
     else
     {
           if(myParseInt(day)>28)
       {
         rdShowMessageDialog("非闰年二月份最多28天！");
             //obj.value="";
       obj.select();
          obj.focus();
           return false;
       }
     }
      }
  }
  return true;
}

function myParseInt(nu)
{
  var ret=0;
  if(nu.length>0)
  {
    if(nu.substring(0,1)=="0")
  {
       ret=parseInt(nu.substring(1,nu.length));
  }
  else
  {
       ret=parseInt(nu);
  }
  }
  return ret;
}
function to_date(obj)
{
  var theTotalDate="";
  var one="";
  var flag="0123456789";
  for(i=0;i<obj.value.length;i++)
  { 
     one=obj.value.charAt(i);
     if(flag.indexOf(one)!=-1)
     theTotalDate+=one;
  }
  return theTotalDate;
}

function printInfo(printType)
{
  var retInfo = "";
  var cust_info=""; //客户信息
  var opr_info=""; //操作信息
  var note_info1=""; //备注1
  var note_info2=""; //备注2
  var note_info3=""; //备注3
  var note_info4=""; //备注4
  var retInfo = "";  //打印内容

    if(printType == "Detail")
    { 
      
        var getAcceptFlag = "<%=getAcceptFlag%>";
        if(getAcceptFlag == "failed")
        { return "failed";  }
      /*retInfo = retInfo + "10|2|0|0|打印流水:  " + "<%=printAccept%>" + "|"; */
    
   
    /*retInfo+='<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime())%>'+"|"; */
    
    cust_info+= "客户姓名：     "+frm1100.custName.value+"|";
    //retInfo+= "证件类型：   "+frm1100.idType.value+"|";
    cust_info+= "证件号码：     "+frm1100.idIccid.value+"|";
    cust_info+= "客户地址：     "+frm1100.idAddr.value+"|";
    //retInfo+=" |";
    cust_info+= "联系人姓名：   "+frm1100.contactPerson.value+"|";
    cust_info+= "联系人电话：   "+frm1100.contactPhone.value+"|";
    cust_info+= "联系人地址：   "+frm1100.contactAddr.value+"|";
    
    opr_info+= "打印流水:     " + "<%=printAccept%>" + "|";
    opr_info+=" "+"|";
    opr_info+= "客户开户。*|";

    note_info1+=document.all.sysNote.value+"|";
    note_info1+=document.all.opNote.value+"|";
    note_info1+=" |";

    
    note_info2+=document.all.assu_name.value+"|";
    note_info2+=document.all.assu_phone.value+"|";
    note_info2+=document.all.assu_idAddr.value+"|";
    note_info2+=document.all.assu_idIccid.value+"|";
    
   
    retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
    retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
  }
    
    if(printType == "Bill")
    {
     
  }
  return retInfo; 
}




function checkPwd(obj1,obj2)
{
        //密码一致性校验,明码校验
        var pwd1 = obj1.value;
        var pwd2 = obj2.value;
        if(pwd1 != pwd2)
        {
                var message = "用户密码和确认用户密码不一致，请重新输入！";
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

function check_HidPwd(Pwd1,Pwd1Type,Pwd2,Pwd2Type)
{
  /*
      Pwd1,Pwd2:密码
      wd1Type:密码1的类型；Pwd2Type：密码2的类型      show:明码；hid：密码
    
  if((Pwd1).trim().length==0)
  {
        rdShowMessageDialog("客户密码不能为空！",0);
        frm1100.custPwd.focus();
    return false;
  }
    else 
  {
     if((Pwd2).trim().length==0)
     {
         rdShowMessageDialog("原始客户密码为空，请核对数据！",0);
         frm1100.custPwd.focus();
     return false;
     }
  }*/
  var checkPwd_Packet = new AJAXPacket("pubCheckPwd.jsp","正在进行密码校验，请稍候......");
  checkPwd_Packet.data.add("retType","checkPwd"); 
  checkPwd_Packet.data.add("Pwd1",Pwd1);
  checkPwd_Packet.data.add("Pwd1Type",Pwd1Type);
  checkPwd_Packet.data.add("Pwd2",(Pwd2).trim());
  checkPwd_Packet.data.add("Pwd2Type",Pwd2Type);
  core.ajax.sendPacket(checkPwd_Packet);
  checkPwd_Packet=null;
  
  if("<%=regionCode%>"=="09"){
    if(pwd1 == "000000"||pwd1 == "111111"||pwd1 == "222222"
     ||pwd1 == "333333"||pwd1 == "444444"||pwd1 == "555555"
     ||pwd1 == "666666"||pwd1 == "777777"||pwd1 == "888888"
     ||pwd1 == "999999"||pwd1 == "123456")
    {
      rdShowMessageDialog("密码过于简单，请修改后再办理业务！");
      return false;
    }
  }   
}

	 function getId()
	 {
		//得到客户ID

        var getUserId_Packet = new AJAXPacket("/npage/sq100/f1100_getId.jsp","正在获得客户ID，请稍候......");
      getUserId_Packet.data.add("retType","ClientId");
		getUserId_Packet.data.add("region_code","<%=regionCode%>");
		getUserId_Packet.data.add("idType","0");
		getUserId_Packet.data.add("oldId","0");
		core.ajax.sendPacket(getUserId_Packet);
		getUserId_Packet = null;
	 }
function getInfo_IccId_JustSee()
{ 
    var Str = document.all.idType.value;
   
      if(Str.indexOf("身份证") > -1){
        if($("#idIccid").val().length<18){
          rdShowMessageDialog("身份证号码必须是18位！");
          document.all.idIccid.focus();
          return false;
        }
      }
    
 
    /*根据客户证件号码得到相关信息*/
    if(document.frm1100.idIccid.value.trim().len() == 0)
    {
        rdShowMessageDialog("请输入客户证件号码！");
        return false;
    }
  /*liujian 2013-5-15 9:24:11 修改新建客户和过户界面,身份证号码只能输入18位的证件号码,如果输入15位的,请报错*/
  var item = $("#idTypeSelect option[@selected]").text();
  if(item == '身份证' && document.frm1100.idIccid.value.trim().len() != 18) {
        rdShowMessageDialog("身份证证件号码长度必须是18位！");
        return false;
  }
  
    var pageTitle = "客户信息查询";
    var fieldName = "服务号码|开户时间|证件类型|证件号码|归属地|状态|";
    /**
    var sqlStr = "select c.phone_no,
    to_char(a.CREATE_TIME,'YYYY-MM-DD HH24:MI:SS'),
    b.ID_NAME,
    a.ID_ICCID," +
    " trim(e.REGION_NAME)||'-->'||trim(f.DISTRICT_NAME)," + 
    " d.run_name
                      from DCUSTDOC a,SIDTYPE b ,DCustMsg c ,sRuncode d ,sregioncode e,sdiscode f where a.region_code=d.region_code and substr(c.run_code,2,1)=d.run_code and  a.cust_id=c.cust_id and b.ID_TYPE = a.ID_TYPE " +
                     " and a.region_code=e.region_code and a.region_code=f.region_code and
                      a.district_code=f.district_code and  a.ID_ICCID = '" + 
                      document.frm1100.idIccid.value + "' and substr(c.run_code,2,1)<'a'
                        and rownum<500 order by a.cust_name asc,a.create_time desc "; 
    */
    var selType = "S";    /*'S'单选；'M'多选*/
    var retQuence = "7|0|1|3|4|5|6|7|";
    var retToField = "in0|in4|in3|in2|in5|in6|in1|";
    
    custInfoQueryJustSee(document.frm1100.idIccid.value);                    
}
function custInfoQueryJustSee(idIccid)
{
    var path = "/npage/sq100/getCustInfo.jsp";
    path = path + "?idIccid=" + idIccid;
    window.showModalDialog(path,"","dialogWidth:60;dialogHeight:35;");
}

function choiceSelWay()
{ 
  if(frm1100.parentIdidIccid.value != "")
  { /*客户证件号码*/
    getInfo_IccId();
    return true;
  }
  if(frm1100.parentName.value != "")
  { /*客户名称*/
    getInfo_withName();
    return true;
  }
  rdShowMessageDialog("客户信息可以以ID、证件号码或名称进行查询，请输入其中任意项作为查询条件！",0);
}

function getInfo_withId()
{
    //根据客户ID得到相关信息
    if(document.frm1100.parentId.value == "")
    {
        rdShowMessageDialog("请输入客户ID！",0);
        return false;
    }
  else
  {
    if((document.all.parentId.value).trim().length>14)
    {
         rdShowMessageDialog("客户ID长度有误！",0);
         return false;
    }
  }
    if(for0_9(frm1100.parentId) == false)
    { 
      frm1100.parentId.value = "";
      return false; 
    }
    var getIdPacket = new AJAXPacket("f1100_rpc.jsp","正在获得上级客户信息，请稍候......");
        var parentId = document.frm1100.parentId.value;
        getIdPacket.data.add("retType","getInfo_withID");
        getIdPacket.data.add("fieldNum","6");
        getIdPacket.data.add("sqlStr","");
        core.ajax.sendPacket(getIdPacket);
        getIdPacket=null; 
}   
function for0_9(obj) //判断字符是否由0－9个数字组成
{  
  
    if (!forString(obj)){
    ltflag = 1;
    obj.select();
    obj.focus();
    return false;
  }else{
    if (obj.value.length == 0){
      return true;
    }
  }    
  if (!isMadeOf(obj.value,numStr)){
      flag = 1;
      rdShowMessageDialog("'" + obj.v_name + "'的值不正确！请输入数字！");
    obj.select();
    obj.focus();
    return false;
    } 
  return true;  
}
function isMadeOf(val,str)
{

  var jj;
  var chr;
  for (jj=0;jj<val.length;++jj){
    chr=val.charAt(jj);
    if (str.indexOf(chr,0)==-1)
      return false;     
  }
  
  return true;
}
function custInfoQuery(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
    /*
    参数1(pageTitle)：查询页面标题
    参数2(fieldName)：列中文名称，以'|'分隔的串
    参数3(sqlStr)：sql语句
    参数4(selType)：类型1 rediobutton 2 checkbox
    参数5(retQuence)：返回域信息，返回域个数＋ 返回域标识，以'|'分隔，如"3|0|2|3"表示返回3个域0，2，3
    参数6(retToField))：返回值存放域的名称,以'|'分隔
    */
    /*var path = "../../page/public/fPubSimpSel.jsp";  密码显示*/
    var path = "pubGetCustInfo.jsp";   //密码为*
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;  
    /*
    var ret = window.open (path, "银行代码", 
          "height=400, width=600,left=200, top=200,toolbar=no,menubar=no, scrollbars=yes, resizable=no, location=no, status=yes"); 
  ret.opener.bankCode.value = "1111111111";
  */
    var retInfo = window.showModalDialog(path,"","dialogWidth:70;dialogHeight:35;");
    if(typeof(retInfo) == "undefined")     
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
  rpc_chkX("parentIdType","parentIdidIccid","B");
}

function getInfo_withName()
{ 
        /*根据客户名称得到相关信息*/
    if(document.frm1100.parentName.value == "")
    {
        rdShowMessageDialog("请输入客户名称！",0);
        return false;
    }
    var pageTitle = "客户信息查询";
    var fieldName = "客户ID|客户名称|开户时间|证件类型|证件号码|客户地址|归属代码|客户密码|";
    var sqlStr = "";
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "7|0|1|3|4|5|6|7|";
    var retToField = "in0|in4|in3|in2|in5|in6|in1|"; 
    custInfoQuery(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)                           
    
    rpc_chkX("parentIdType","parentIdidIccid","B");
}


function getInfo_IccId()
{ 
    /*根据客户证件号码得到相关信息*/
    if((document.frm1100.parentIdidIccid.value).trim().length == 0)
    {
        rdShowMessageDialog("请输入客户证件号码！",0);
        return false;
    }
  else if((document.frm1100.parentIdidIccid.value).trim().length < 5)
  {
        rdShowMessageDialog("证件号码长度有误（最少五位）！",0);
        return false;
  }

    var pageTitle = "客户信息查询";
    var fieldName = "客户ID|客户名称|开户时间|证件类型|证件号码|客户地址|归属代码|客户密码|";
    var sqlStr = "";
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "7|0|1|3|4|5|6|7|";
    var retToField = "in0|in4|in3|in2|in5|in6|in1|";
     custInfoQuery(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);                    
     
}

function get_inPara()
{
    /*组织传人的参数*/
    var inPara_Str = "";    
        inPara_Str = inPara_Str + document.frm1100.temp_custId.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.regionCode.value + "|" + document.frm1100.districtCode.value + "|";
        inPara_Str = inPara_Str + document.frm1100.custName.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.custPwd.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.custStatus.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.custGrade.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.ownerType.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.custAddr.value + "|";
        var tempStr = document.frm1100.idType.value; 
        inPara_Str = inPara_Str + tempStr.substring(0,tempStr.indexOf("|")) + "|"; 
        inPara_Str = inPara_Str + document.frm1100.idIccid.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.idAddr.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.idValidDate.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactPerson.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactPhone.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactAddr.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactPost.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactMAddr.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactFax.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactMail.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.unitCode.value + "|"; //机构代码
        inPara_Str = inPara_Str + document.frm1100.parentId.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.custSex.value + "|";  //客户性别
        inPara_Str = inPara_Str + document.frm1100.birthDay.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.professionId.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.vudyXl.value + "|"; //学历
        inPara_Str = inPara_Str + document.frm1100.custAh.value + "|"; //客户爱好 
        inPara_Str = inPara_Str + document.frm1100.custXg.value + "|"; //客户习惯
        inPara_Str = inPara_Str + document.frm1100.unitXz.value + "|"; //单位性质
        inPara_Str = inPara_Str + document.frm1100.yzlx.value + "|"; //执照类型
        inPara_Str = inPara_Str + document.frm1100.yzhm.value + "|"; //执照号码
        inPara_Str = inPara_Str + document.frm1100.yzrq.value + "|"; //执照有效期
        inPara_Str = inPara_Str + document.frm1100.frdm.value + "|"; //法人代码
        inPara_Str = inPara_Str + document.frm1100.groupCharacter.value + "|";//群组信息
        inPara_Str = inPara_Str + "1100" + "|";
        inPara_Str = inPara_Str + document.frm1100.workno.value + "|";  
        inPara_Str = inPara_Str + document.frm1100.sysNote.value + "|";
        inPara_Str = inPara_Str + document.frm1100.opNote.value + "|";  
        document.frm1100.inParaStr.value = inPara_Str;
}


function jspReset()
{
    /*页面控件初始化 */   
    var obj = null;
    var t = null;
        var i;
    for (i=0;i<document.frm1100.length;i++)
    {    
                obj = document.frm1100.elements[i];                                              
                packUp(obj); 
            obj.disabled = false;
    }
    document.frm1100.commit.disabled = "none"; 
} 
 
function jspCommit()
{
         /*页面提交*/
         document.frm1100.commit.disabled = "none";
         action="sq100_2.jsp?opCode=<%=opCode%>"
         frm1100.submit();   /*将参数串的输入框提交*/
}

function change_ConPerson()
{   
  /*联系人姓名随客户名称改名而改变*/
  if(document.all.ownerType.value=="02"){
    frm1100.contactPerson.value = frm1100.custName.value;
    /*document.all.print.disabled=true;*/
  }
}
function change_ConAddr(obj)
{   /*联系人姓名随客户名称改名而改变*/
	
  
}

function checkName(){
  if(!forString(document.all.custName)){
    return false;
  }
  var custName=document.all.custName.value;
  var checkPwd_Packet = new AJAXPacket("f1100_checkName.jsp?custName="+custName,"正在进行客户名称校验，请稍候......");
  checkPwd_Packet.data.add("retType","checkName");
  core.ajax.sendPacket(checkPwd_Packet);
  checkPwd_Packet=null;
}

function changeCardAddr(obj){
  var Str = document.all.idType.value;
  
    if((Str.indexOf("身份证") > -1)||(Str.indexOf("户口簿") > -1)){
      if(obj.value.length<8){
        rdShowMessageDialog("要求8个及以上汉字！请重新输入！");
        obj.focus();
  			return false;
      }
    }
  
  if(document.all.ownerType.value=="01"){
    document.all.custAddr.value=obj.value;
    document.all.contactAddr.value=obj.value;
    document.all.contactMAddr.value=obj.value;
  }
}

function chcek_pic()/*二代证*/
{
  
var pic_path = document.all.filep.value;
  
var d_num = pic_path.indexOf("\.");
var file_type = pic_path.substring(d_num+1,pic_path.length);
/*判断是否为jpg类型 //厂家设备生成图片固定为jpg类型*/
if(file_type.toUpperCase()!="JPG")
{ 
    rdShowMessageDialog("请选择jpg类型图像文件");
    document.all.up_flag.value=3;
    /*document.all.print.disabled=true;*/
    resetfilp();
  return ;
  }

  var pic_path_flag= document.all.pic_name.value;
  
  if(pic_path_flag=="")
  {
  rdShowMessageDialog("请先扫描或读取证件信息");
  document.all.up_flag.value=4;
  /*document.all.print.disabled=true;*/
  resetfilp();
  return;
}
  else
    {
      if(pic_path!=pic_path_flag)
      {
      rdShowMessageDialog("请选择最后一次扫描或读取证件而生成的证件图像文件"+pic_path_flag);
      document.all.up_flag.value=5;
      /*document.all.print.disabled=true;*/
      resetfilp();
    return;
    }
    else{
      document.all.up_flag.value=2;
      }
      }
      
  }
  
function doProcess(packet)
{
    //RPC处理函数findValueByName
    var retType = packet.data.findValueByName("retType");
    
    var retCode = packet.data.findValueByName("retCode"); 
    var retMessage = packet.data.findValueByName("retMessage"); 
    self.status="";
  if((retCode).trim()=="")
  {
       rdShowMessageDialog("调用"+retType+"服务时失败！");
       return false;
  }
    //---------------------------------------    
    
    //-----------------------------------------
          
    //----------------------------------------
    
   if(retType=="chkX")
   {
    var retObj = packet.data.findValueByName("retObj");
    if(retCode == "000000"){
        //rdShowMessageDialog("校验成功111!",2);     
        document.all.print.disabled=false;
        
      }else if(retCode=="100001"){
        retMessage = retCode + "："+retMessage;  
        rdShowMessageDialog(retMessage);     
        document.all.print.disabled=false;
       
        return true;
      }else{
        retMessage = "错误" + retCode + "："+retMessage;      
        rdShowMessageDialog(retMessage,0);
        /*document.all.print.disabled=true;*/
        
        document.all(retObj).focus();
        return false;
       
    }
   }
   if(retType=="checkName")
   {
      var flag = packet.data.findValueByName("flag");
      var custId = packet.data.findValueByName("custId");
      if(flag=="0"){
        rdShowMessageDialog("该客户名称可以正常使用！",2);
      }
      else if(flag=="1"){
        
        rdShowMessageDialog("该客户名称已经存在！<BR>客户ID为"+custId+"！",0);
      }
    
   }
   
   if(retType=="iccIdCheck")
   {
    if(retCode == "000000")
    {
      rdShowMessageDialog("校验通过！");
      document.all.get_Photo.disabled=false;
      //document.all.print.disabled=false;
    }
    else
    {

      retMessage = retCode + "："+retMessage;  
      rdShowMessageDialog(retMessage);
      document.all.idIccid.value="";
    }
   }
   if(retType == "ClientId")
    {
			//得到新建客户ID
			var retnewId = packet.data.findValueByName("retnewId");
			if(retCode=="000000"){
				document.frm1100.custId.value = retnewId;
			}else{
				retMessage = retMessage + "[errorCode1:" + retCode + "]";
				rdShowMessageDialog(retMessage,0);
				return false;
				}    
     }
  
}

function feifaCustName(textName)
{
  if(textName.value != "")
  {
    if(document.all.ownerType.value=="01"&&document.all.isJSX.value=="0"){
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
function forKuoHao(obj){
	var m = /^(\(?\)?\（?\）?)+$/;
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
  
/*
	2013/11/15 15:33:56 gaopeng 关于进一步提升省级支撑系统实名登记功能的通知  
	注意：只针对个人客户 start
*/  

/*1、客户名称、联系人姓名 校验方法 objType 0 代表客户名称校验 1代表联系人姓名校验  ifConnect 代表是否联动赋值(点击确认按钮时，不进行联动赋值)*/
function checkCustNameFunc(obj,objType,ifConnect){
	var nextFlag = true;
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
            /*2014/9/2 8:56:11 gaopeng 哈分公司申请优化开户名称限制的请示 */
       }else{
					
					/*获取含有中文汉字的个数以及'()（）'的个数*/
					var m = /^[\u0391-\uFFE5]*$/;
					var chinaLength = 0;
					var kuohaoLength = 0;
					for (var i = 0; i < objValue.length; i ++){
			          var code = objValue.charAt(i);//分别获取输入内容
			          var flag = m.test(code);
			          /*先校验括号*/
			          if(forKuoHao(code)){
			          	kuohaoLength ++;
			          }else if(flag){
			          	chinaLength ++;
			          }
			          
			    }
			    var machLength = chinaLength + kuohaoLength;
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
						rdShowMessageDialog(objName+"必须大于三个字符!1");
						
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
		
		
		if(ifConnect == 0){
		if(nextFlag){
		 if(objType == 0){
		 	/*联系人姓名随客户名称改名而改变*/
			  if(document.all.ownerType.value=="02"){
			    document.frm1100.contactPerson.value = frm1100.custName.value;
			    /*document.all.print.disabled=true;*/
			  }
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
				if(document.all.ownerType.value=="01"){
					
			    document.all.custAddr.value=objValue;
			    document.all.contactAddr.value=objValue;
			    document.all.contactMAddr.value=objValue;
			  }
			}
			/*客户地址改变时，赋值联系人地址和联系人通讯地址*/
			if(objType == 1){
				frm1100.contactAddr.value = objValue;
	  		frm1100.contactMAddr.value = objValue;
			}
			/*联系人地址改变时，赋值联系人通讯地址，2013/12/16 15:20:17 20131216 gaopeng 赋值经办人联系地址联动*/
			if(objType == 2){
				document.all.contactMAddr.value=objValue;
				document.all.gestoresAddr.value=objValue;
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
	}else if(opCode == "1993"){
		rpc_chkX('idType','idIccid','A');
	}
	return nextFlag;
}


/*
	2013/11/15 15:33:56 gaopeng 关于进一步提升省级支撑系统实名登记功能的通知  
	注意：只针对个人客户 end
*/ 

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
  		if("<%=opCode%>" != "1993"){
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
  		}
  	}else{
  		document.all.responsibleIccId.v_type = "string";
  		if("<%=opCode%>" != "1993"){
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
}



function checkNameStr(code){
			/* gaopeng 2014/01/17 9:50:35 优先匹配括号 因为括号可能是中文也可能是英文，优先返回KH 保证逻辑不失误*/
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

function reSetCustName(){/*重置客户名称*/
  document.all.custName.value="";
  document.all.contactPerson.value="";
  
  /*20131216 gaopeng 2013/12/16 15:11:05 当选择单位开户时，展示经办人信息并将其信息设计为必填选项 start*/
  var checkVal = $("select[name='isJSX']").find("option:selected").val();
  if(checkVal == 1){
  	$("#gestoresInfo1").show();
  	$("#gestoresInfo2").show();
  	/*经办人姓名*/
  	document.all.gestoresName.v_must = "1";
  	/*经办人地址*/
  	document.all.gestoresAddr.v_must = "1";
  	/*经办人证件号码*/
  	document.all.gestoresIccId.v_must = "1";
  	var checkIdType = $("select[name='gestoresIdType']").find("option:selected").val();
  	/*身份证加入校验方法*/
  	if(checkIdType.indexOf("身份证") != -1){
  		document.frm1100.gestoresIccId.v_type = "idcard";
  		$("#scan_idCard_two3").css("display","");
  		$("#scan_idCard_two31").css("display","");
  		$("input[name='gestoresName']").attr("class","InputGrey");
  		$("input[name='gestoresName']").attr("readonly","readonly");
  		$("input[name='gestoresAddr']").attr("class","InputGrey");
  		$("input[name='gestoresAddr']").attr("readonly","readonly");
  		$("input[name='gestoresIccId']").attr("class","InputGrey");
  		$("input[name='gestoresIccId']").attr("readonly","readonly");
  	}else{
  		document.frm1100.gestoresIccId.v_type = "string";
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
  		document.frm1100.responsibleIccId.v_type = "idcard";
  		$("#scan_idCard_two3zrr").css("display","");
  		$("#scan_idCard_two57zrr").css("display","");
  		$("input[name='responsibleName']").attr("class","InputGrey");
  		$("input[name='responsibleName']").attr("readonly","readonly");
  		$("input[name='responsibleAddr']").attr("class","InputGrey");
  		$("input[name='responsibleAddr']").attr("readonly","readonly");
  		$("input[name='responsibleIccId']").attr("class","InputGrey");
  		$("input[name='responsibleIccId']").attr("readonly","readonly");  		
  		
  	}else{
  		document.frm1100.responsibleIccId.v_type = "string";
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
  /*没选择单位客户的时候，均不展示并设置为不需要必填选项*/
  else{
  	$("#gestoresInfo1").hide();
  	$("#gestoresInfo2").hide();
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
  	
  }
  /*20131216 gaopeng 2013/12/16 15:11:05 当选择单位开户时，展示经办人信息并将其信息设计为必填选项 end*/
  
  getIdTypes();
  
}
/**** tianyang add for 中文字符限制 end ****/


function feifa1(textName)
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
  
  var Str = document.all.idType.value;
 
    if(Str.indexOf("身份证") > -1){
      if($("#idIccid").val().length<18){
        rdShowMessageDialog("身份证号码必须是18位！");
        document.all.idIccid.focus();
        return false;
      }
    }
  
  
  rpc_chkX('idType','idIccid','A');
}
  
function changeType(opCode){
	
	if(opCode == "m349"){
		
		window.location.href='/npage/sm349/fm349Main.jsp?opCode=m349&opName=批量校园预开户';
	}
	if(opCode == "m109"){
		window.location.href='/npage/sm349/fm349Main.jsp?opCode=m109&opName=批量渠道预开户';
		
	}
}

function setOfferType(){
		var packet = new AJAXPacket("/npage/portal/shoppingCar/ajax_getOfferType.jsp","请稍后...");
		packet.data.add("smCode" ,document.all.smCode.value);
		packet.data.add("goodKind" ,"" );
		packet.data.add("opCode" ,"<%=opCode%>" );
		core.ajax.sendPacket(packet,dosetOfferType);	
}	
			
function 	dosetOfferType(packet){
		var retResult = packet.data.findValueByName("retResult"); 
		var selectObj = document.getElementById("offer_att_type");
	  selectObj.length=0;
		selectObj.options.add(new Option("--请选择--",""));
		for(var i=0;i<retResult.length;i++){
			var reg = /\s/g;     
			var ss = retResult[i][0].replace(reg,""); 
				if(ss.length!=0){
					selectObj.options.add(new Option(retResult[i][0]+"-->"+retResult[i][1],retResult[i][0]));
				}
			}
	}
	
function productOfferQryByAttr(){
	
	var packet = new AJAXPacket("/npage/portal/shoppingCar/ajax_productOfferQryByAttr.jsp","请稍后...");
		packet.data.add("offerCode" ,"");//销售品编码
		packet.data.add("offerName" ,"");//销售品名称
		packet.data.add("offerType" ,"10");//销售品类型
		packet.data.add("offerAttrSeq" ,"");
		packet.data.add("custGroupId" ,"");
		packet.data.add("channelSegment" ,"");
		packet.data.add("group_id" ,document.all.receiveRegion.value);
		packet.data.add("band_id" ,document.all.smCode.value);
		packet.data.add("offer_att_type" ,document.all.offer_att_type.value);
		packet.data.add("goodFlag" ,"1");
		packet.data.add("retQ08_flag" ,"0");
		packet.data.add("opCode" ,"<%=opCode%>");
		core.ajax.sendPacket(packet,doProductOfferQryByAttr);
		packet =null;
	
}
function doProductOfferQryByAttr(packet)
{
	var retCode = packet.data.findValueByName("retCode"); 
	var retMsg = packet.data.findValueByName("retMsg"); 
	var retArray = packet.data.findValueByName("retResult");
	if(retCode==0){
				
				$("#resultContent").show();
				$("#appendBody").empty();
			
				var appendTh = 
					"<tr>"
					+"<th width='8%'>操作</th>"
					+"<th width='23%'>销售品代码</th>"
					+"<th width='23%'>销售品名称</th>"
					+"<th width='23%'>品牌名称</th>"
					+"<th width='23%'>说明</th>"
					+"</tr>";
				$("#appendBody").append(appendTh);	
				for(var i=0;i<retArray.length;i++){
					var appendStr = "<tr>";
					appendStr += "<td width='8%'>"+"<input type='radio' name='selOrder' value='"+retArray[i][0]+"' onclick='jdugeAreaHidden("+retArray[i][0]+");'/>"+"</td>"
											+"<td width='23%'>"+retArray[i][0]+"</td>"
											+"<td width='23%'>"+retArray[i][1]+"</td>"
											+"<td width='23%'>"+retArray[i][6]+"</td>"
											+"<td width='23%'></td>"

					appendStr +="</tr>";						
					$("#appendBody").append(appendStr);
				}
				$("#excelExp").attr("disabled","");
				
			}else{
				$("#resultContent").hide();
				$("#appendBody").empty();
			
				rdShowMessageDialog("错误代码："+retCode+",错误信息："+retMsg,1);
				
			}
				
	}


    	<wtc:service name="sDynSqlCfm" routerKey="region" routerValue="<%=regionCode%>" outnum="2">
    		  <wtc:param value="25"/>
    		  <wtc:param value="<%=workNo%>"/>
    	</wtc:service>
    	<wtc:array id="rowsRegionH" scope="end"/>
 
 		function 	addRegCode(){
				var selectObj = document.getElementById("receiveRegion");
			  selectObj.length=0;
			  <%
				  for(int iii=0;iii<rowsRegionH.length;iii++){
				  		String temp1 = rowsRegionH[iii][0];
				  		String temp2 = rowsRegionH[iii][1];
				%>
					 selectObj.options.add(new Option("<%=temp1%>--><%=temp2%>","<%=temp1%>"));
				<%			
					}
				%>	
			}
			
	function getCuTime(){
	 var curr_time = new Date(); 
	 with(curr_time) 
	 { 
	 var strDate = getYear()+"-"; 
	 strDate +=getMonth()+1+"-"; 
	 strDate +=getDate()+" "; //取当前日期，后加中文“日”字标识 
	 strDate +=getHours()+"-"; //取当前小时 
	 strDate +=getMinutes()+"-"; //取当前分钟 
	 strDate +=getSeconds(); //取当前秒数 
	 return strDate; //结果输出 
	 } 
	}
  
  function Idcard_realUser(flag){
		//读取二代身份证
		//document.all.card_flag.value ="2";
		
		var picName = getCuTime();
		var fso = new ActiveXObject("Scripting.FileSystemObject");  //取系统文件对象
		var tmpFolder = fso.GetSpecialFolder(0); //取得系统安装目录
		var strtemp= tmpFolder+"";
		var filep1 = strtemp.substring(0,1)//取得系统目录盘符
		var cre_dir = filep1+":\\custID";//创建目录
		//判断文件夹是否存在，不存在则创建目录
		if(!fso.FolderExists(cre_dir)) {
			var newFolderName = fso.CreateFolder(cre_dir);  
		}
		var picpath_n = cre_dir +"\\"+picName+"_"+ document.all.custId.value +".jpg";
		
		var result;
		var result2;
		var result3;
	
		result=IdrControl1.InitComm("1001");
		if (result==1)
		{
			result2=IdrControl1.Authenticate();
			if ( result2>0)
			{              
				result3=IdrControl1.ReadBaseMsgP(picpath_n); 
				if (result3>0)           
				{     
			  var name = IdrControl1.GetName();
				var code =  IdrControl1.GetCode();
				var sex = IdrControl1.GetSex();
				var bir_day = IdrControl1.GetBirthYear() + "" + IdrControl1.GetBirthMonth() + "" + IdrControl1.GetBirthDay();
				var IDaddress  =  IdrControl1.GetAddress();
				var idValidDate_obj = IdrControl1.GetValid();
		
				if(flag == "manage"){ //经办人
					document.all.gestoresName.value =name;//姓名
					document.all.gestoresIccId.value =code;//身份证号
					//document.all.gestoresAddr.value =IDaddress;//身份证地址
				}
				
				if(flag == "zerenren"){  //责任人
					document.all.responsibleName.value =name;//姓名
					document.all.responsibleIccId.value =code;//身份证号
					//document.all.gestoresAddr.value =IDaddress;//身份证地址
				}				
				
				subStrAddrLength(flag,IDaddress);//校验身份证地址，如果超过60个字符，则自动截取前30个字
				}
				else
				{
					rdShowMessageDialog(result3); 
					IdrControl1.CloseComm();
				}
			}
			else
			{
				IdrControl1.CloseComm();
				rdShowMessageDialog("请重新将卡片放到读卡器上");
			}
		}
		else
		{
			IdrControl1.CloseComm();
			rdShowMessageDialog("端口初始化不成功",0);
		}
		IdrControl1.CloseComm();
	}
	
	function Idcard2(str){
			//扫描二代身份证
		var fso = new ActiveXObject("Scripting.FileSystemObject");  //取系统文件对象
		tmpFolder = fso.GetSpecialFolder(0); //取得系统安装目录
		var strtemp= tmpFolder+"";
		var filep1 = strtemp.substring(0,1)//取得系统目录盘符
		var cre_dir = filep1+":\\custID";//创建目录
		if(!fso.FolderExists(cre_dir)) {
			var newFolderName = fso.CreateFolder(cre_dir);
		}
	var ret_open=CardReader_CMCC.MutiIdCardOpenDevice(1000);
	if(ret_open!=0){
		ret_open=CardReader_CMCC.MutiIdCardOpenDevice(1001);
	}	
	var cardType ="11";
	if(ret_open==0){
		//alert(v_printAccept+"--"+str);
			//多功能设备RFID读取
			var ret_getImageMsg=CardReader_CMCC.MutiIdCardGetImageMsg(cardType,"c:\\custID\\cert_head_"+v_printAccept+str+".jpg");
			if(str=="1"){
				try{
					document.all.pic_name.value = "C:\\custID\\cert_head_"+v_printAccept+str+".jpg";
					document.all.but_flag.value="1";
					document.all.card_flag.value ="2";
				}catch(e){
						
				}
			}
			//alert(ret_getImageMsg);
			//ret_getImageMsg = "0";
			if(ret_getImageMsg==0){
				//二代证正反面合成
				var xm =CardReader_CMCC.MutiIdCardName;					
				var xb =CardReader_CMCC.MutiIdCardSex;
				var mz =CardReader_CMCC.MutiIdCardPeople;
				var cs =CardReader_CMCC.MutiIdCardBirthday;
				var yx =CardReader_CMCC.MutiIdCardSigndate+"-"+CardReader_CMCC.MutiIdCardValidterm;
				var yxqx = CardReader_CMCC.MutiIdCardValidterm;//证件有效期
				var zz =CardReader_CMCC.MutiIdCardAddress; //住址
				var qfjg =CardReader_CMCC.MutiIdCardOrgans; //签发机关
				var zjhm =CardReader_CMCC.MutiIdCardNumber; //证件号码
				var base64 =CardReader_CMCC.MutiIdCardPhoto;
				var v_validDates = "";
				if(yxqx.indexOf("\.") != -1){
					yxqx = yxqx.split(".");
					if(yxqx.length >= 3){
						v_validDates = yxqx[0]+yxqx[1]+yxqx[2]; 
					}else{
						v_validDates = "21000101";
					}
				}else{
					v_validDates = "21000101";
				}
				
				if(str == "31"){ //经办人
					document.all.gestoresName.value =xm;//姓名
					document.all.gestoresIccId.value =zjhm;//身份证号
					//document.all.gestoresAddr.value =zz;//身份证地址
				}else if(str == "57"){ //责任人
					document.all.responsibleName.value =xm;//姓名
					document.all.responsibleIccId.value =zjhm;//身份证号
					//document.all.gestoresAddr.value =zz;//身份证地址
				}
				
				subStrAddrLength(str,zz);//校验身份证地址，如果超过60个字符，则自动截取前30个字

			}else{
					rdShowMessageDialog("获取信息失败");
					return ;
			}
	}else{
					rdShowMessageDialog("打开设备失败");
					return ;
	}
	//关闭设备
	var ret_close=CardReader_CMCC.MutiIdCardCloseDevice();
	if(ret_close!=0){
		rdShowMessageDialog("关闭设备失败");
		return ;
	}
	
}
/* begin update for 关于开发智能终端CRM模式APP的函 - 第二批@2015/3/10 */
function subStrAddrLength(str,idAddr){
	var packet = new AJAXPacket("/npage/sq100/fq100_ajax_subStrAddrLength.jsp","正在获得数据，请稍候......");
	packet.data.add("str",str);
	packet.data.add("idAddr",idAddr);
	core.ajax.sendPacket(packet,doSubStrAddrLength);
	packet = null;
}

function doSubStrAddrLength(packet){
	var str = packet.data.findValueByName("str");
	var idAddr = packet.data.findValueByName("idAddr");
	if(str == "31"){ //经办人
		document.all.gestoresAddr.value =idAddr;//身份证地址
	}else if(str == "manage"){ //经办人 旧版
		document.all.gestoresAddr.value =idAddr;//身份证地址
	}else if(str == "zerenren"){ //责任人 旧版
		document.all.responsibleAddr.value =idAddr;//身份证地址
	}else if(str == "57"){ //责任人 
		document.all.responsibleAddr.value =idAddr;//身份证地址
	}
}


/*2015/12/17 15:55:28 gaopeng  以下为小区代码部分*/

var xqdm = "";   //小区计费
/*2014/12/03 9:24:16 gaopeng 小区资费无小区属性问题 
	加入小区代码下拉列表展示时，也就是ajax_jdugeAreaHidden.jsp 返回Y时，该资费为小区资费的全局变量，默认不是小区资费
*/
var xqjfFlag = false;
var offerId = "";
function jdugeAreaHidden(offer_id){
	offerId = offer_id;
	//getMajorProd(offer_id);
	
  var packet = new AJAXPacket("/npage/s1104/ajax_jdugeAreaHidden.jsp","请稍后...");
	packet.data.add("offerId",offer_id);
 	packet.data.add("phoneNo","");
	packet.data.add("opCode","<%=opCode%>");
	core.ajax.sendPacket(packet,doJdugeAreaHidden);
	packet =null;	
} 


var v_hiddenFlag = "";
var v_code = new Array();
var v_text = new Array();

function doJdugeAreaHidden(packet){
  var retCode = packet.data.findValueByName("retCode");
  var retMsg =  packet.data.findValueByName("retMsg");
  var code =  packet.data.findValueByName("code");
  var text =  packet.data.findValueByName("text");
  var hiddenFlag =  packet.data.findValueByName("hiddenFlag");//是否显示小区代码标识
  var offer_id =  packet.data.findValueByName("offerId");//资费代码
  if(retCode == "000000"){
    v_hiddenFlag = hiddenFlag;
    if(code.length>0&&text.length>0){
      for(var i=0;i<code.length;i++){
        v_code[i] = code[i];
        v_text[i] = text[i];
      }
    }
    getOfferAttr(offer_id);
	}else{
		rdShowMessageDialog(retCode + ":" + retMsg,0);
		//getOfferAttr();
		return false;
	}
}

function getOfferAttr(offer_id)

{
    if(v_hiddenFlag=="Y"){ //当为Y时，进入新版小区代码展示页面
      var packet1 = new AJAXPacket("/npage/s1104/getOfferAttrNew.jsp","请稍后...");
      packet1.data.add("v_code" ,v_code);
      packet1.data.add("v_text" ,v_text);
      packet1.data.add("myActivePhone" ,"");
     
    }else{
      var packet1 = new AJAXPacket("/npage/s1104/getOfferAttr.jsp","请稍后...");
    }
		packet1.data.add("OfferId" ,offer_id);
		core.ajax.sendPacketHtml(packet1,doGetOfferAttr);
		packet1 =null;
}

function doGetOfferAttr(data)
{
	/*清空*/
	$("#OfferAttribute").html("");
  if(v_hiddenFlag=="Y"){ //当为Y时，进入新版小区代码展示页面
    $("#OfferAttribute").append(data);
  }else{
    $("#OfferAttribute").html(data);
  }
	$("#OfferAttribute :input").not(":button").keyup(function stopSpe(){
			var b=this.value;
			if(/[^0-9a-zA-Z\.\@\u4E00-\u9FA5]/.test(b)) this.value=this.value.replace(/[^0-9a-zA-Z\u4E00-\u9FA5]/g,'');
	});
	$("#hideAreaSome").hide();
}


/*2015/12/17 16:25:01 gaopeng 产品信息部分*/
function getMajorProd(offerId)
{
	 	var packet1 = new AJAXPacket("/npage/s1104/getMajorProd.jsp","请稍后...");
		packet1.data.add("offerId" ,offerId);
		core.ajax.sendPacketHtml(packet1,doGetMajorProd);
		packet1 =null;
}

function doGetMajorProd(data)
{
		
		/*清空*/
		$("#offer_component").html("");
	  $("#offer_component").html(data);
	  
	  
		var majorProductId = "";
		if(typeof(majorProductArr) != "undefined" && majorProductArr.length > 0)
		{
		 	majorProductId = majorProductArr[1];
		 	$("input[name='majorProductId']").val(majorProductArr[1]);
		 	
		  
		  getProdCompInfo(majorProductId);
		  getProdCompRel(majorProductId);
		  
		  
		 	//主产品的函数放在这里//	
		}
		else
		{
			rdShowMessageDialog("该销售品没有主产品信息!");
			window.close();
			return false;	
		}
}

function getProdCompRel(majorProductId)
{
	var packet2 = new AJAXPacket("/npage/s1104/getProdCompRel.jsp","正在加载附属产品的依赖关系,请稍后...");
	packet2.data.add("majorProductId" ,majorProductId);
	core.ajax.sendPacketHtml(packet2,doGetProdCompRel);
	packet2 =null;
}

function  doGetProdCompRel(data)
{
	 $("#majorProdRel").html("");
	 $("#majorProdRel").html(data);
	 
	 for(var i=0;i<prodCompIdArray.length;i++){
			initProdRel(prodCompIdArray[i]);
	 }	
}

function getProdCompInfo(majorProductId)
{
	var packet3 = new AJAXPacket("/npage/s1104/getProdCompDet.jsp","请稍后...");
	packet3.data.add("goodNo" ,""); //caohq 20101206 需求 
	packet3.data.add("groupId" ,"<%=groupId%>");
	packet3.data.add("selOfferType","");//weigp add 需求 
	packet3.data.add("majorProductId" ,majorProductId);
	packet3.data.add("offerId" ,offerId);
	packet3.data.add("sopcodes" ,"<%=opCode%>");
	core.ajax.sendPacket(packet3,doGetProdCompInfo);
	packet3 =null;
}

var prodCompIdArray = [];									//附加产品构成信息
//记录现有的四种漫游
var myArrs = new Array("1027","1026","1025","2042");

function doGetProdCompInfo(packet)
{
	var error_code = packet.data.findValueByName("errorCode");
	var error_msg =  packet.data.findValueByName("errorMsg");
	var prodCompInfo = packet.data.findValueByName("prodCompInfo");

	if(error_code == "0"){
		if(typeof(prodCompInfo) != "undefined"){
			/*清空并加上tr*/
			
			$("#tab_addprod tr").empty();
			
			$("#tab_addprod").show();
			var nodeIdStr = "";
			var nodeNameStr = "";
			var etFlagStr = "";
			var compRoleCdHash = new Object();
			$("#tab_addprod tr").append("<td><div id='items'><div class='item-col2 col-1'><div id='compProdInfoDiv'></div></div><div class='item-row2 col-2'><div class='title'><div id='title_zi'>已定购产品信息</div></div><div id='pro_component'></div></div></div></td>");
			
			$("#pro_component").append("<div id='prod_"+offerId+"'></div>"); 
        	$("#prod_"+offerId).after("<div id='pro_"+offerId+"' ></div>");
        	$("#pro_"+offerId).append("<table id='tab_pro' cellspacing=0></table>");
        	$("#tab_pro").append("<tr><th>产品名称</th><th>开始时间</th><th>结束时间</th><th>操作</th></tr>");
			
			
			for(var i=0;i<prodCompInfo.length;i++){
				if(typeof(compRoleCdHash[prodCompInfo[i][3]]) == "undefined"){	//生成角色栏
					$("#compProdInfoDiv").append("<div  name='compProdrole' id='"+prodCompInfo[i][3]+"' style='cursor:hand'><div class='title'><div id='title_zi'>附加产品</div></div></div><table cellspacing='0'><tr><td><div id='div_"+prodCompInfo[i][3]+"' style='font-family:\"宋体\";'></div></td></tr></table>");
					compRoleCdHash[prodCompInfo[i][3]] = "1";
				}	
			}
			
			for(var i=0;i<prodCompInfo.length;i++){
			    var tempStr = "";
			    if(i != 0){
			        tempStr = "&nbsp;";
			    }
				prodCompIdArray[i] = prodCompInfo[i][11];
				var relationType = prodCompInfo[i][9];
				
				// caohq 20101206 end
				var checkStr = "";
				var spaceStr = "";
				
				if(relationType == "0"){
					checkStr = "checked disabled";
					etFlagStr = etFlagStr + "0" + "|";
				}
				else if(relationType == "2"){
					checkStr = "checked";		
					etFlagStr = etFlagStr + "2" + "|";
				}
				// 20101206 caohq begin
				else if(relationType == "3"){
					checkStr = "disabled";		
					etFlagStr = etFlagStr + "3" + "|";
				}
				// 20101206 caohq end
				if(relationType == "0" || relationType == "2"){
				    nodeIdStr = nodeIdStr + prodCompInfo[i][11]+"|";
				    nodeNameStr = nodeNameStr + prodCompInfo[i][2]+"|";
				}
				
				var strLen = fucCheckLength(prodCompInfo[i][2]);
				if(prodCompInfo[i][13] == "1"){
				    if(strLen<10){
    				    var len = 10 - strLen;
    				    for(var li=0;li<len;li++){
        				        spaceStr = spaceStr + "&nbsp;";
    				    }
    				}
				}else{
    				if(strLen<16){
    				    var len = 16 - strLen;
    				    for(var li=0;li<len;li++){
        				        spaceStr = spaceStr + "&nbsp;";
    				    }
    				}
    			}
    			//liujian ceshi  begin
				//alert(111);
				//liujian ceshi end
				$("#div_"+prodCompInfo[i][3]).append(tempStr+"<span id='compSpan_"+prodCompInfo[i][11]+"'><input type='checkbox' onclick='showDetailProd2(\""+prodCompInfo[i][11]+"\",\""+prodCompInfo[i][2]+"\",this,1)' name='checkbox_"+prodCompInfo[i][2]+"' id='"+prodCompInfo[i][11]+"' _mutexNum='0' "+checkStr+" groupTitle='"+prodCompInfo[i][14]+"'  minNum='" + prodCompInfo[i][15] + "' maxNum='" + prodCompInfo[i][16] + "' />"+prodCompInfo[i][2]+"</span>"+spaceStr);
				
				if(prodCompInfo[i][13] == "1"){
					$("#compSpan_"+prodCompInfo[i][11]).append("<input type='button' name='prod_"+prodCompInfo[i][2]+"' value='属性' id='att_"+prodCompInfo[i][11]+"' class='b_text' />");
				}
				if($("#div_"+prodCompInfo[i][3]+" span").length%3 == 0){	//多个换行
					$("#div_"+prodCompInfo[i][3]).append("<br>");	
				}
			}
			var nodeIdArr = nodeIdStr.split("|");
			var nodeNameArr = nodeNameStr.split("|");
			var etFlagArr = etFlagStr.split("|");

			for(var i=0;i<nodeIdArr.length-1;i++){
				  //alert("nodeIdArr["+i+"]|="+nodeIdArr[i]+"#nodeNameArr["+i+"]|="+nodeNameArr[i]);
			    showDetailProd2(nodeIdArr[i],nodeNameArr[i],"undefined",etFlagArr[i]);
    		}
		}
	$("#tab_addprod :checkbox").bind("click",checkProdRel);	//校验复合产品间关系
	$("#tab_addprod :button").bind("click",showAttribute);	//设定复合产品属性
	
	$("#tab_addprod div[name='compProdrole']").toggle(
		  function () {
		    $("#div_"+this.id).css("display","none");
		  },
		  function () {
		    $("#div_"+this.id).css("display","");
		  }
		); 
	}		
}


function showDetailProd2(nodeId,nodeName,obj,etFlag){
	/*新增加的校验*/
	if(!clickListener($("#"+ nodeId +""),'groupTitle',true)){
		$("#"+ nodeId +"").attr("checked","");
		return false;
	}
	if(findStrInArr(nodeId,myArrs) && getAllCheckedRomaBox() > 1){
		rdShowMessageDialog("用户只能选择一个漫游",0);
		$("#"+ nodeId +"").attr("checked","");
		return false;
	}
    if(obj != undefined){
        if(obj.checked == false){
            $("#pro_detail_"+nodeId).remove();
            return;
        }
    }
  
  var packet = new AJAXPacket("/npage/s1104/complexPro_ajax.jsp","请稍后...");//组合产品子产品展示
	packet.data.add("nodeId" ,nodeId);
	packet.data.add("nodeName" ,nodeName);
	packet.data.add("etFlag",etFlag);
	core.ajax.sendPacketHtml(packet,doGetHtml2);
	packet =null;
	
	
}
function doGetHtml2(data){
    eval(data);
}

function chkLimit1(id,iOprType)
{
	var retList="";
	var phoneNo="";
	var opCode="<%=opCode%>";
	var sendUrl = "/npage/s1104/limitChk1.jsp";
	var senddata={};
	senddata["opCode"] = opCode;
	senddata["prodId"] = id;
	senddata["iOprType"] = iOprType;
	senddata["vQtype"] = "0";
	senddata["idNo"] = "";
	
		$.ajax({
			url: sendUrl,
		  type: "POST",
		  data: senddata,
		  async: false,//同步
		  error: function(data){
				if(data.status=="404")
				{
				  alert( "文件不存在!");
				}
				else if (data.status=="500")
				{
				  alert("文件编译错误!");
				}
				else{
				  alert("系统错误!");  					
				}
		  },
		  success: function(data)
		  {		   
		          retList = data;
		  }
		});
		senddata = null;
		return  retList;
}

/*2015/12/17 17:13:04 gaopeng  各种需要的工具类*/

function findStrInArr(str1,arrObj){
	var reFlag = false;
	$.each(arrObj,function(i,n){
		if(n == str1){
			reFlag = true;
		}
	});
	return reFlag;
}

function getAllCheckedRomaBox(){
	var checkedBoxObjs = $("#tab_addprod :checkbox[@checked]");
	var romaBoxNum = 0;
	$.each(checkedBoxObjs,function(i,n){
		if(findStrInArr(n.id,myArrs)){
			romaBoxNum++;
		}
	});
	return romaBoxNum;
}

function fucCheckLength(strTemp)  
{  
 var i,sum;  
 sum=0;  
 for(i=0;i<strTemp.length;i++)  
 {  
  if ((strTemp.charCodeAt(i)>=0) && (strTemp.charCodeAt(i)<=255))  
   sum=sum+1;  
  else  
   sum=sum+2;  
 }  
 return sum;  
} 

function checkProdRel(){
	checkProdCompRel(this);
	var iOprType = "1";
	if(this.id == "4001"){
		if(typeof($(this).attr("checked")) == "undefined" 
				|| $(this).attr("checked") == "undefined"){
					iOprType = "3";
		}
		
		
		
	}
	 var retArr=chkLimit1(this.id,iOprType).split("@");
     retCo=retArr[0].trim();
     retMg=retArr[1];
     if(retCo!="0")
     {
     	   rdShowMessageDialog(retMg);
     	   $("#"+this.id).attr('checked','check');
     	   $("#pro_detail_"+this.id).remove();
     	   return false;
     }
}
var AttributeHash = new Object(); //销售品/产品Id=属性信息
function showAttribute(){
	var queryType = this.name.substring(0,4);
	var queryId = this.id.substring(4);
	var offerName = this.name.substring(4);
	var h=600;
	var w=800;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;
	var prop="dialogHeight:"+h+"px;dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
	if($(this).attr("class") == "but_property"){
		var ret=window.showModalDialog("/npage/s1104/showAttr.jsp?queryId="+queryId+"&queryType="+queryType,"",prop);
		if(typeof(ret) != "undefined"){
			if(ret.split("|")[1].length == 1){
				rdShowMessageDialog("未设置属性！");	
				return false;
			}
			$(this).attr("class","but_property_on");
			AttributeHash[queryId]=ret;	//将返回的群组信息对应queryId放入
		}	
		else{
			rdShowMessageDialog("未设置属性！");	
			return false;
		}
	}
	else{
		var ret=window.showModalDialog("/npage/s1104/showAttr.jsp?queryId="+queryId+"&queryType="+queryType+"&attrInfo="+AttributeHash[queryId],"",prop);
		if(typeof(ret) != "undefined"){
			AttributeHash[queryId]=ret;	//将返回的群组信息对就queryId放入
		}
	}	
}
		
		
function myTest(){
	
	var exitFlag = 0;
	var pordIdArr = new Array();
	var prodEffectDate = []; 
	var prodExpireDate = [];  
	var isMainProduct = []; 
	
	var offerIdArr = new Array();
	var offerNameArr = new Array();
	var offerEffectTime = new Array();
	var offerExpireTime = new Array();
	
	var sonParentArr = []; //存放销售品,产品间子~父关系
	var groupInstBaseInfo = "";				//群组信息
	var offer_productAttrInfo = ""; //销售品,产品属性串
		
	var vFlag = true;
	//压入主产品
		if(typeof(majorProductArr) != "undefined" && majorProductArr.length > 0){
			$("input[name='majorProductId']").val(majorProductArr[1]);
			sonParentArr.push($("input[name='majorProductId']").val()+"~"+offerId);
			pordIdArr.push($("input[name='majorProductId']").val());
			prodEffectDate.push("<%=currTime%>");
			prodExpireDate.push("20501231235959");
			isMainProduct.push(1);
		}
		else{
			rdShowMessageDialog("无主产品!");	
			return false;
		}

	//压入附加产品
		$("#tab_addprod :checked").each(function(){
			sonParentArr.push(this.id+"~"+offerId);
			pordIdArr.push(this.id);
			
			//if(document.getElementById("startDate_"+this.id)!=null&document.getElementById("stopDate_"+this.id)!=null){
				if(compareDates((document.getElementById("startDate_"+this.id)),(document.getElementById("stopDate_"+this.id)))==-1){
	                rdShowMessageDialog("开始时间格式不正确,请重新输入!",0);
	                (document.getElementById("startDate_"+this.id)).select();
	                vFlag = false;
	                return false;
	            }
	            if(compareDates((document.getElementById("startDate_"+this.id)),(document.getElementById("stopDate_"+this.id)))==-2){
	                rdShowMessageDialog("结束时间格式不正确,请重新输入!",0);
	                (document.getElementById("stopDate_"+this.id)).select();
	                vFlag = false;
	                return false;
	            }
	            
			    if($(document.getElementById("startDate_"+this.id)).val() < "<%=dateStr2%>"){
	                rdShowMessageDialog("开始时间应不小于当前时间,请重新输入!",0);
	                (document.getElementById("startDate_"+this.id)).select();
	                vFlag = false;
	                return false;
	            }
	            if($(document.getElementById("stopDate_"+this.id)).val() <= "<%=dateStr2%>"){
	                rdShowMessageDialog("结束时间应大于当前时间,请重新输入!",0);
	                (document.getElementById("stopDate_"+this.id)).select();
	                vFlag = false;
	                return false;
	            }
	            
	            if(compareDates((document.getElementById("startDate_"+this.id)),(document.getElementById("stopDate_"+this.id)))==1 || $(document.getElementById("startDate_"+this.id)).val()==$(document.getElementById("stopDate_"+this.id)).val()){
	                rdShowMessageDialog("开始时间应小于结束时间,请重新输入!",0);
	                (document.getElementById("stopDate_"+this.id)).select();
	                vFlag = false;
	                return false;
	            }
	            
	            if($(document.getElementById("startDate_"+this.id)).val() > "<%=addThreeMonth%>"){
	                rdShowMessageDialog("开始时间必须是三个月内,请重新输入!",0);
	                (document.getElementById("startDate_"+this.id)).select();
	                vFlag = false;
	                return false;
	            }
	            
				//}
				
			var effDate = "";
    		var expDate = "";
    		if($(document.getElementById("startDate_"+this.id)).val() == "<%=dateStr2%>"){
    		    effDate = "<%=currTime%>";
    		}else{
    		    effDate = $(document.getElementById("startDate_"+this.id)).val() + "000000";
    		}
    		
    		expDate = $(document.getElementById("stopDate_"+this.id)).val() + "235959";
    		prodEffectDate.push(effDate);
    		prodExpireDate.push(expDate);
										
			isMainProduct.push(0);
			
			if(typeof(AttributeHash[this.id]) != "undefined"){		//装入附加产品的属性信息
				offer_productAttrInfo += AttributeHash[this.id];
			}	
		});		
		
		if(!vFlag){
			    return false;
			}
				
		$("#div_offerComponent :checked").each(function(){
			if(this.name.substring(0,4)=="prod" && $("#"+nodesHash[this.id].parentOffer).attr("checked") == true && $("#effType_"+nodesHash[this.id].parentOffer).val() == "0"){	//只送立即生效的
				sonParentArr.push(this.id+"~"+nodesHash[this.id].parentOffer);
				pordIdArr.push(this.id);
				prodEffectDate.push($.trim($("#effTime_"+nodesHash[this.id].parentOffer).attr("name")));
				prodExpireDate.push($.trim($("#expTime_"+nodesHash[this.id].parentOffer).attr("name")));
				isMainProduct.push(0);
				
				if(typeof(AttributeHash[this.id]) != "undefined"){		//装入产品的属性信息
					offer_productAttrInfo += AttributeHash[this.id];
				}	
			}
			if(this.name.substring(0,4)=="offe"){
				
				if(this.h_groupId!="0"){
					if(typeof(offerGroupHash[this.id])!="undefined"){
						if(offerGroupHash[this.id].indexOf(this.id)==-1){ //群组信息中没有这个offerid对应的信息，说明群组设置失败
								rdShowMessageDialog("选择亲情资费“"+this.h_offerName+"”错误，请重新选择",0);
								this.checked = false;
								checkOrderTab();
								exitFlag = 1;
						}
					}else{
								rdShowMessageDialog("选择亲情资费“"+this.h_offerName+"”错误，请重新选择",0);
								this.checked = false;
								checkOrderTab();
								exitFlag = 1;
						}
				}
				
				sonParentArr.push(this.id+"~"+nodesHash[this.id].parentOffer);
				offerIdArr.push(this.id);
				offerEffectTime.push($("#effTime_"+this.id).attr("name"));
				
				offerExpireTime.push($("#expTime_"+this.id).attr("name"));
				
				if(typeof(AttributeHash[this.id]) != "undefined"){	//装入销售品的属性信息
					offer_productAttrInfo += AttributeHash[this.id];
				}	
				
				/*
				if(nodesHash[this.id].attrFlag == 1 && typeof(AttributeHash[this.id]) == "undefined"){
					rdShowMessageDialog("请设定"+nodesHash[this.id].getName()+"的属性信息!");
					exitFlag = 1;
					return false;	
				}
				*/
				
				if(typeof(offerGroupHash[this.id]) != "undefined"){	//装入销售品的群组信息
					groupInstBaseInfo = groupInstBaseInfo + offerGroupHash[this.id]+"^";
				}
			}
		});
		if(exitFlag == 1){
			return false;	
		}		
		$("input[name='productIdArr']").val(pordIdArr);
		$("input[name='prodEffectDate']").val(prodEffectDate);
		$("input[name='prodExpireDate']").val(prodExpireDate);
		$("input[name='isMainProduct']").val(isMainProduct);
		var endStr = "";
		/*
		for(var j=0;j<pordIdArr.length;j++){
			if(j==0){
				endStr = pordIdArr[j]+"#"+prodEffectDate[j]+"#"+prodExpireDate[j]+"#"+isMainProduct[j];
			}else{
				endStr += "$"+pordIdArr[j]+"#"+prodEffectDate[j]+"#"+prodExpireDate[j]+"#"+isMainProduct[j];
			}
		}*/
		for(var j=0;j<pordIdArr.length;j++){
			
		}
		endStr = pordIdArr.join(",")+"$"+prodEffectDate.join(",")+"$"+prodExpireDate.join(",")+"$"+isMainProduct.join(",");
		//alert(endStr);
		$("input[name='endStr']").val(endStr);
	
}

function replaceAll(s1,s2,str)
{
	if(str.length != 0){
		str.replace(new RegExp(s1,"gm"),s2);
		return str;
	}
}


</SCRIPT>
<body onMouseDown="hideEvent()" onKeyDown="hideEvent()">
<FORM method="post" name="frmaaa" id="frmaaa"   >
	<input type="hidden" id="bphones" name="bphones" value=""/>
	<input type="hidden" id="userpwds" name="userpwds" value=""/>
	<input type="hidden" id="simnos" name="simnos" value=""/>
	<input type="hidden" id="prepays" name="prepays" value=""/>
	
	<input type="hidden" id="bTrueNames" name="bTrueNames" value=""/>
	<input type="hidden" id="bTrueIdTypes" name="bTrueIdTypes" value=""/>
	<input type="hidden" id="bTrueIdNos" name="bTrueIdNos" value=""/>
	<input type="hidden" id="bTrueAddrs" name="bTrueAddrs" value=""/>
	<input type="hidden" id="bSimFees" name="bSimFees" value=""/>
	<input type="hidden" id="fjxspStr" name="fjxspStr" value=""/>
	
</form>	
  <!--二代证-->
<FORM method=post name="frm1100" id="frm1100"   onKeyUp="chgFocus(frm1100)"   ><!--二代证-->
       
       <%@ include file="/npage/include/header.jsp" %>   
       <div class="title">
      <div id="title_zi"><%=opName%></div>
    </div>

  <!------------------------------------------------------------------------>
              
              <TABLE cellSpacing="0" >
                <TBODY> 
                <tr>
			        		<td width=16% class="blue">操作类型</td>
			        		<td width=84% colspan="3">
			        			<input type="radio" name="opType"	value="m349" <%if("m349".equals(opCode)){out.print("checked");}%>  onclick="changeType(this.value);"/>m349-批量普通开户 &nbsp;&nbsp;
			        		</td>
        				</tr>
        				
                <TR> 
                  <TD width=16% class="blue"> 
                    <div align="left">客户类别</div>
                  </TD>
                  <TD width=84% colspan="3"> 
                    <select align="left" name=ownerType onChange="change()" width=50 index="6">
          <%
          //得到输入参数
          String sqlStrt ="select TYPE_CODE,TYPE_NAME from sCustTypeCode Order By TYPE_CODE";
          //retArray = callView.view_spubqry32("2",sqlStr);
          //int recordNum = Integer.parseInt((String)retArray.get(0));
          //result = (String[][])retArray.get(1);
          // result = (String[][])retArray.get(0);  
          %>
          <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCodet" retmsg="retMsgt" outnum="2">
          <wtc:sql><%=sqlStrt%></wtc:sql>
          </wtc:pubselect>
          <wtc:array id="resultt" scope="end" />
          <%  
          int recordNum=0;
          if(retCodet.equals("000000")){
            System.out.println("服务sPubSelect调用成功");
            recordNum = resultt.length;  
            System.out.println("recordNum  _________________________________________________________"+recordNum);
          }   
          //根据登录工号到sfuncpower 中查看是否有集团客户开户权限
          /*
          sqlStr="select count(*) from sfuncpower where function_code='1993' and power_code in (select power_code from dloginmsg where login_no='" +workNo+ "')";
          retArray = callView.view_spubqry32("1",sqlStr);
          int recordNum1 = Integer.parseInt(((String[][])retArray.get(0))[0][0]);
          System.out.println("sqlStr="+sqlStr);
          System.out.println("recordNum="+recordNum1 );
          */
          //sunwt 修改 20080429
          String paramsIn[] = new String[2];
          paramsIn[0] = workNo;       //工号
          paramsIn[1] = "1993";        //操作代码
          
          //SPubCallSvrImpl callViewCheck = new SPubCallSvrImpl();
          //ArrayList acceptList = new ArrayList();
          /** try
          {
          acceptList = callViewCheck.callFXService("sFuncCheck", paramsIn, "1","region", regionCode); 
          errCode = callViewCheck.getErrCode();
          errMsg = callViewCheck.getErrMsg();
          }
          catch(Exception e)
          {
          e.printStackTrace();
          logger.error("Call sFuncCheck is Failed!");
          }
          **/
          %>
          <wtc:service name="sFuncCheck" routerKey="regionCode" routerValue="<%=regionCode%>"  retcode="retCode" retmsg="retMsg"  outnum="1" >
          <wtc:param value="sFuncCheck"/>
          <wtc:params value="<%=paramsIn%>"/>
          <wtc:param value="1"/>
          <wtc:param value="region"/>
          <wtc:param value="<%=regionCode%>"/>
          </wtc:service>
          <wtc:array id="resultr" scope="end" />          
          <%
            System.out.println("_________________________________________________________________________");
            for(int i=0;i<resultr.length;i++){
              for(int j=0;j<resultr[i].length;j++){
                System.out.println("resultr["+i+"]["+j+"]"+"   "+resultr[i][j]);
                          }
                      }
        System.out.println("_________________________________________________________________________");

      if(retCode.equals("000000")){
          System.out.println("***************************************************************************");
          System.out.println("调用sFuncCheck成功"+"___retCode :"+retCode+"  retMsg: "+retMsg);
          int recordNum1 =  resultr.length;       //把count(*)取出
          System.out.println("recordNum1________________________________"+recordNum1);
          for(int i=0;i<recordNum;i++){
          if(!"01".equals(resultt[i][0]) && 0==recordNum1) {
            continue;
          }
            if("01".equals(resultt[i][0])){
              out.println("<option class='button' value='" + resultt[i][0] + "'>" + resultt[i][1] + "</option>");
            }
          }
      }else{
          System.out.println("***************************************************************************");
          System.out.println("调用sFuncCheck失败"+"___retCode :"+retCode+"  retMsg: "+retMsg);
      }

      %>
                    </select>
          
                  </TD>
                  
                </TR>
                
                <!-- tianyang add for custNameCheck start -->
                <tr id="ownerType_Type">
                  <TD width=16% class="blue" > 
                    <div align="left">个人开户分类</div>
                  </TD>
                  <TD colspan="3" width="34%" class="blue" >
                    <select align="left" name="isJSX" onChange="reSetCustName()" width=50 index="6">
                      <!-- //update 去除普通客户选项@关于开发智能终端CRM模式APP的函
                      	<option class="button" value="0">普通客户</option>
                       -->
                    System.out.println(" gaopeng workChnFlag " + workChnFlag);  
<%

                    if (!(workChnFlag.equals("1") && openFav == false)){
%>
                        <option class="button" value="1" selected>单位客户</option>
<%
                    }
%>
                    </select>
                  </TD>
                </tr>
                <!-- tianyang add for custNameCheck end -->
        <!--zhangyan add 客户服务等级 b-->
                <tr id="trU00020003"  style="display:none">
                  <TD width=16% class="blue" > 
                      <div align="left">总部直管客户</div>
                  </TD>
                    <TD  width="16%" class="blue" >
            <select align="left"  name = "selU0002" id = "selU0002" >
              <option class="button"  value="X" >---请选择---</option>
              <option class="button"  value="1" >1—>是</option>
              <option class="button"  value="0" >0—>否</option>
            </select>
                    </TD>
                  <TD width=16% class="blue" > 
                      <div align="left">省级客户</div>
                  </TD>
                    <TD  width="16%" class="blue" >
            <select align="left"  name = "selU0003" id = "selU0003" >
              <option class="button"  value="X" >---请选择---</option>
              <option class="button"  value="1" >1—>是</option>
              <option class="button"  value="0" >0—>否</option>
            </select>
                    </TD>                   
                </tr>         
                <tr id="svcLvl"  style="display:none">
                  <TD width=16% class="blue" > 
                      <div align="left">客户服务等级</div>
                  </TD>
                    <TD colspan="3" width="34%" class="blue" >
            <select align="left"  name = "selSvcLvl" id = "selSvcLvl" >
              <option class="button"  value="00" >00—>标准级服务</option>
              <option class="button"  value="01" >01—>金牌级服务</option>
              <option class="button"  value="02" >02—>银牌级服务</option>
              <option class="button"  value="03" >03—>铜牌级服务</option>
              
            </select>
                    </TD>
               
                </tr> 
                <!--zhangyan add 客户服务等级 e-->   
                                
                <TR> 
                  <TD> 
                    <div align="left" class="blue" >客户归属市县</div>
                  </TD>
                  <TD> 
                    <select align="left" name=districtCode width=50 index="8">
                      <%
        //得到输入参数
                String sqlStr2 ="select trim(group_id),DISTRICT_NAME from  SDISCODE Where region_code='" + regionCode + "' order by DISTRICT_CODE";                     
               // retArray = callView.view_spubqry32("2",sqlStr);
                
      %>
      <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode2" retmsg="retMsg2" outnum="2">
      <wtc:sql><%=sqlStr2%></wtc:sql>
      </wtc:pubselect>
      <wtc:array id="result2" scope="end" />
      <%


 if(retCode2.equals("000000")){
     
      System.out.println("调用服务成功！");
              int recordNum2 = result2.length;
                for(int i=0;i<recordNum2;i++){
                  if(result2[i][0].trim().equals(districtCode)){
                    out.println("<option class='button' value='" + result2[i][0] + "'  selected >" + result2[i][1] + "</option>");
                  }
                  else{
                    out.println("<option class='button' value='" + result2[i][0] + "' >" + result2[i][1] + "</option>");
                  }
                }
      
       }else{
       System.out.println("***********************************************************************");
         System.out.println("调用服务失败！");
         
      }         
               
               
%>
                    </select>
                  </TD>
                  <TD class="blue" > 
                    <div align="left">客户名称</div>
                  </TD>
                  <TD> 
                    <input name=custName id="custName" value=""  v_must=1 v_maxlength=60 v_type="string"   maxlength="60" size=20 index="9"  onblur="if(checkElement(this)){checkCustNameFunc16New(this,0,0)}">
                    <div id="checkName" style="display:none"><input type="button" class="b_text" value="验证" onclick="checkName()"></div>
                   <font class=orange>*</font>
                    </TD>
                </TR>
                <tr> 
                  <td width=16% class="blue" > 
                    <div align="left">证件类型</div>
                  </td>
                  <td id="tdappendSome" width=34%> 
                    
                  </td>
                  <td width=16% class="blue" > 
                    <div align="left">证件号码</div>
                  </td>
                  <td width=34%> 
                    <input name="idIccid"  id="idIccid"   value=""  v_minlength=4 v_maxlength=20 v_type="string" onChange="change_idType()" maxlength="20"   index="11" value="" onBlur="checkIccIdFunc16New(this,0,0);rpc_chkX('idType','idIccid','A');">
                    <input name=IDQueryJustSee type=button class="b_text" style="cursor:hand" onClick="getInfo_IccId_JustSee()" id="custIdQueryJustSee" value=信息查询 >
                    <input type="button" name="iccIdCheck" class="b_text" value="校验" onclick="checkIccId()" disabled>
        						<input type="hidden" name="IccIdAccept" value="<%=IccIdAccept%>">
                    </td>
                </tr>
                

                <tr> 
                  <td class="blue" > 
                    <div id="idAddrDiv" align="left">证件地址</div>
                  </td>
                  <td> 
                    <input name=idAddr  id="idAddr" value=""   v_must=1 v_type="string"  maxlength="60" v_maxlength=60 size=30 index="12" onblur="if(checkElement(this)){checkAddrFunc(this,0,0)}">
                    <font class=orange>*</font> </td>
                  <td class="blue" > 
                    <div align="left">证件有效期</div>
                  </td>
                  <td> 
                    <input class="button" name="idValidDate" id="idValidDate" v_must=0 v_maxlength=8 v_type="date"  maxlength=8 size="8" index="13" onblur="if(checkElement(this)){chkValid();}">
                    <!--
                    <img src="../../js/common/date/button.gif" style="cursor:hand"  onclick="fPopUpCalendarDlg(idValidDate);return false" alt=弹出日历下拉菜单 align=absMiddle readonly>
                     -->
                  </td>
                </tr>
        
            
      
                <!--TR bgcolor="#EEEEEE"> 
                  <TD> 
                    <div align="left">客户密码：</div>
                  </TD>
                  <TD bgcolor="#EEEEEE"> 
                    <input name=custPwd type="password" v_type="0_9" class="button" v_must=0 v_maxlength=6 v_name="客户密码" maxlength="6" id=passwd1 index="14">
                  </TD>
                  <TD> 
                    <div align="left">校验客户密码：</div>
                  </TD>
                  <TD> 
                    <input name=cfmPwd type="password" class="button" v_type="0_9" v_must=0 v_maxlength=6 v_name="校验客户密码" maxlength="6"  index="15">
                  </TD>
                </TR-->
              
                  
                <TR> 
                  <TD class="blue" > 
                    <div align="left">客户地址</div>
                  </TD>
                  <TD colspan="3"> 
                    <input name=custAddr class="button"  v_type="string" v_must=1 v_maxlength=60   maxlength="60" size=35 index="18" onblur="if(checkElement(this)){checkAddrFunc(this,1,0)}">
                    <font class=orange>*</font> 
                  </TD>
                  </TD>
                </TR>
                         
                <TR> 
                  <TD class="blue" > 
                    <div align="left">联系人姓名</div>
                  </TD>
                  <TD> 
                    <input name=contactPerson class="button" value="" v_type="string"  maxlength="60" size=20 index="19" v_must=1 v_maxlength=60 onblur="if(checkElement(this)){checkCustNameFunc(this,1,0)}">
                    <font class=orange>*</font>
                    <font class=orange></font>
                    <!--<font class=orange>*&nbsp;(联系人姓名为汉字且不得超过六个)</font>-->
                  </TD>
                  <TD class="blue" > 
                    <div align="left">联系人电话</div>
                  </TD>
                  <TD> 
                    <input name=contactPhone class="button" v_must=1 v_type="phone" maxlength="20"  index="20" size="20" onblur="checkElement(this);" value="">
                    <font class=orange>*</font> </TD>
                </TR>
                <TR> 
                  <TD class="blue" > 
                    <div align="left">联系人地址</div>
                  </TD>
                  <TD> 
                    <input name=contactAddr  class="button" v_must=1 v_type="string"  maxlength="60" v_maxlength=60 size=30 index="21"  onblur="if(checkElement(this)){ checkAddrFunc(this,2,0);}">
                    <font class=orange>*</font> </TD>
                  <TD class="blue" > 
                    <div align="left">联系人邮编</div>
                  </TD>
                  <TD> 
                    <input name=contactPost class="button" v_type="zip" v_name="联系人邮编" maxlength="6"  index="22" size="20">
                  </TD>
                </TR>
                <TR> 
                  <TD class="blue" > 
                    <div align="left">联系人传真</div>
                  </TD>
                  <TD> 
                    <input name=contactFax class="button" v_must=0 v_type="phone" v_name="联系人传真" maxlength="20"  index="23" size="20">
                  </TD>
                  <TD class="blue" > 
                    <div align="left">联系人E_MAIL</div>
                  </TD>
                  <TD> 
                    <input name=contactMail class="button" v_must=0 v_type="email" v_name="联系人E_MAIL" maxlength="30" size=30 index="24">
                  </TD>
                </TR>
                <TR> 
                  <TD class="blue" > 
                    <div align="left">联系人通讯地址</div>
                  </TD>
                  <TD colspan="3"> 
                    <input name=contactMAddr class="button" v_must=1 v_maxlenth=60 v_type="string"  maxlength="60" size=35 index="25" onblur="if(checkElement(this)){checkAddrFunc(this,3,0)}">
                    <font class=orange>*</font></TD>
                </TR>
                
                <!-- 20131216 gaopeng 2013/12/16 10:29:28 关于在BOSS入网界面增加单位客户经办人信息的函 加入经办人信息 start -->
                 <%@ include file="/npage/sq100/gestoresInfo.jsp" %>
                 <%@ include file="/npage/sq100/responsibleInfo.jsp" %>
                <tr>
									<td width="20%" class="blue">导入文件</td>
									<td width="80%" colspan="3">
										<input type="file" id="uploadFile" name="uploadFile" v_must="1"  
											style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' />&nbsp;<font color="red">*</font>
									</td>
								</tr>
								<tr>
									<td class="blue">
										文件格式说明
									</td>
					        <td colspan="3"> 
					            上传文件文本格式为“手机号码|sim卡号|密码|SIM卡费|预存款|实际使用人姓名|实际使用人证件类型|实际使用人证件号码|实际使用人联系地址”，示例如下：<br>
					            <font class='orange'>
					            	&nbsp;&nbsp; 13836141518|898600452154261|123321|10|100|张三|0|23233219800122XXXX|哈尔滨道里区XXXX<br/>
					            	&nbsp;&nbsp; 13836141519|898600452154262|123321|20|200|李四|0|23233219800122XXXX|哈尔滨道里区XXXX<br/>
					            	&nbsp;&nbsp; 13836141520|898600452154263|123321|30|300|王五|0|23233219800122XXXX|哈尔滨道里区XXXX<br/>
					            	&nbsp;&nbsp; 注：证件类型为 0--身份证 1--军官证 2--户口簿 3--港澳通行证 4--警官证 5--台湾通行证 6--外国公民护照
					            </font>
					            <b>
					            <br>&nbsp;&nbsp; 注：格式中的每一项均不允许存在空格,且每条数据都需要回车换行。
					            <br>&nbsp;&nbsp; 上传文件格式为txt文件。且最多不超过100条。
					            </b> 
					        </td>
	   					 	</tr>
	   					 	<tr>
                	<td class="blue">品牌</td>
                	<td>
                			<select name="smCode" id="smCode" onchange="setOfferType()">
                				<option value="21" selected>21-->全球通</option>
                				<option value="23">23-->动感地带</option>
                				<option value="24">24-->神州行</option>
                			</select>
                	</td>
                	<td class='blue' nowrap>销售品分类</td>
									<td >
											<SELECT name="offer_att_type" style="width:200px" id="offer_att_type"> 
												<option value="">--请选择--</option>
						    			</SELECT>
						    			&nbsp;&nbsp;<input type="button" name="qrySmInfo" class="b_text" value="查询" onclick="productOfferQryByAttr();"/>
									</td>
									 <td style="display:none">
								  <SELECT name="receiveRegion" id="receiveRegion"> 
				          </SELECT>
		 						</td>
                </tr>
                </TBODY> 
              </TABLE> 
                              
                   
 
  
		<div id="resultContent" style="display:none">
		<div class="title"><div id="title_zi">按属性查询结果列表</div></div>
		<div class="list" style="height:156px; overflow-y:auto; overflow-x:hidden;">
		<table id="exportExcel" name="exportExcel">
			<tbody id="appendBody">
				
			
			</tbody>
		</table>
		</div>
	</div>
	<div id="OfferAttribute"></div><!--小区代码-->   
	<!--产品信息-->   
	<DIV class="input" id="productInfo">
		<br>
			<div class="title">
			<div id="title_zi">产品信息</div>
		</div>
	
		<div id="majorProdRel"></div> 
		
		<div id="prodAttribute"></div> <!--产品属性-->
		
		<TABLE cellSpacing=0 id="tab_addprod" style="display:none">
		  
				<TR>
		    
		  	</TR>
		</table>
	</DIV>
	
	<!-- 基本销售品 结束-->
	<!-- 附加销售品 开始-->
	<div class="undis" id="tbc_02" style="display:none">
			<div class="title">
			<div id="title_zi">附加销售品</div>
		</div>
	  <TABLE cellSpacing=0 id="adddiscount">
	  </TABLE>
	<div id="offer_component"></div> 
	<div id="div_offerComponent"></div> 
	
	</div>
       
	       <TABLE cellSpacing="0">
    <TBODY> 
    <TR style="display:none"> 
      <TD width=16% class="blue" > 
        <div align="left">系统备注</div>
      </TD>
      <TD> 
        <input class="button" name=sysNote size=60 readonly maxlength="60">
      </TD>
    </TR>
    <TR> 
      <TD width="16%" class="blue" > 
        <div align="left">用户备注</div>
      </TD>
      <TD> 
        <input name=opNote class="button" size=60 maxlength="60" index="38"  v_must=0 v_maxlength=60 v_type="string" v_name="用户备注">
      </TD>
    </TR>
    </TBODY> 
  </TABLE>                
<TABLE cellSpacing="0">
  <TBODY>
    <TR> 
          <TD align=center id="footer"> 
            <input class="b_foot_long" name=print  onclick="printCommit()" onkeyup="if(event.keyCode==13)printCommit()"  type=button value=确认  index="39" disabled>
            <!-- <input class="b_foot_long" name=mytests  onclick="myTest()"  type=button value=测试  index="39" > -->
          <input class="b_foot" name=reset1 type=button  onclick=" window.location.href='/npage/sm349/fm349Main.jsp?opCode=<%=opCode%>&opName=<%=opName%>';" value=清除 index="40">
          <input class="b_foot" name=back type=button onclick="
          <% 
                if("1".equals(inputFlag)){ 
                    out.print(" window.close() ");
                }else{
                    out.print(" removeCurrentTab() ");
                } 
            %>
          " value=关闭 index="41">
            <input type="reset" name="Reset" value="Reset" style="display:none">
          </TD>
    </TR>
  </TBODY>
</TABLE>
  <input type="hidden" name="ReqPageName" value="f1100_1">
  <!--流水号 -->
	<input type="hidden" name="printAccept" value="<%=printAccept%>">
  <input type="hidden" name="workno" value=<%=workNo%>>
  <input type="hidden" name="opCode" value="<%=opCode%>">
  <input type="hidden" name="opName" value="<%=opName%>">
  <input type="hidden" name="regionCode" value=<%=regionCode%>> 
  <input type="hidden" name="unitCode" value=<%=orgCode%>>
  <input type="hidden" id=in6 name="belongCode" value=<%=belongCode%>>  
  <input type="hidden" id=in1 name="hidPwd" v_name="原始密码">
  <input type="hidden" name="hidCustPwd">       <!--加密后的客户密码-->
  <input type="hidden" name="temp_custId">
  <input type="hidden" name="custId" value="0">
  <input type="hidden" name="ip_Addr" value=<%=ip_Addr%>>
  <input type="hidden" name="inParaStr" >
  <input type="hidden" name="checkPwd_Flag" value="false">    <!--密码校验标志-->
  <input type="hidden" name="workName" value=<%=workName%> >
  <input type="hidden" name="assu_name" value="">
  <input type="hidden" name="assu_phone" value="">
  <input type="hidden" name="assu_idAddr" value="">
  <input type="hidden" name="assu_idIccid" value="">
  <input type="hidden" name="assu_conAddr" value="">
  <input type="hidden" name="assu_idType" value="">
  <input type="hidden" name="inputFlag" value="<%=inputFlag%>">
  <iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>
  <input type="hidden" name="card_flag" value="">  <!--身份证几代标志-->
  <input type="hidden" name="pa_flag" value="">  <!--证件标志-->
  <input type="hidden" name="m_flag" value="">   <!--扫描或者读取标志，用于确定上传图片时候的图片名-->
  <input type="hidden" name="sf_flag" value="">   <!--扫描是否成功标志-->
  <input type="hidden" name="pic_name" value="">   <!--标识上传文件的名称-->
  <input type="hidden" name="up_flag" value="0">
  <input type="hidden" name="but_flag" value="0"> <!--按钮点击标志-->
  <input type="hidden" name="upbut_flag" value="0"> <!--上传按钮点击标志-->
  <input type="hidden" name="ziyou_check" value="<%=resultl0[0][0]%>">
  
  <input type="hidden" name="majorProductId" value="">
  
  <!--产品信息-->
	<input type="hidden" name="productIdArr" />
	<input type="hidden" name="prodEffectDate"/>
	<input type="hidden" name="prodExpireDate"/>
	<input type="hidden" name="isMainProduct"/>
	<input type="hidden" name="endStr"/>
  
  
  <%@ include file="/npage/include/footer.jsp" %> 
 
<jsp:include page="/npage/common/pwd_comm.jsp"/>
</form>
</body>
<%@ include file="/npage/sq100/interface_provider.jsp" %>
<%@ include file="/npage/include/public_smz_check.jsp" %>
<OBJECT id="CardReader_CMCC" height="0" width="0"  classid="clsid:FFD3E742-47CD-4E67-9613-1BB0D67554FF" codebase="/npage/public/CardReader_AGILE.cab#version=1,0,0,6"></OBJECT>
</html>
