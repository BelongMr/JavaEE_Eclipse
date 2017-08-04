<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="ignoreIn.jsp" %>
<%@ taglib uri="/WEB-INF/wtc.tld" prefix="wtc" %>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UType" %>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UtypeUtil" %>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UElement" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    Calendar today =   Calendar.getInstance();
    today.add(Calendar.MONTH,3);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    String addThreeMonth = sdf.format(today.getTime());
    System.out.println("### addThreeMonth = "+addThreeMonth);

  String dateStr2 =  new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
	String currTime = new SimpleDateFormat("yyyyMMddHHmmss", Locale.getDefault()).format(new Date());
	String current_time=new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(new java.util.Date());
	String currentTime = new java.text.SimpleDateFormat("yyyy-MM").format(new java.util.Date()); //当前时间
	Calendar calendar = Calendar.getInstance();
	String expTime=currentTime+"-"+calendar.getActualMaximum(Calendar.DAY_OF_MONTH)+" 23:59:59";
	String offerSrvId=WtcUtil.repNull(request.getParameter("offerSrvId"));
  System.out.println("===1219==客户id===="+offerSrvId);
  String simTypeOne ="";
  
	String custOrderId=WtcUtil.repNull(request.getParameter("custOrderId"));
	String custOrderNo=WtcUtil.repNull(request.getParameter("custOrderNo"));
	String servOrderId=WtcUtil.repNull(request.getParameter("servOrderId"));
  System.out.println("客户服务定单号="+servOrderId);
  String regionCode =((String)session.getAttribute("orgCode")).substring(0,2);
	String orderArrayId=WtcUtil.repNull(request.getParameter("orderArrayId"));
	String closeId=WtcUtil.repNull(request.getParameter("closeId"));
	String servBusiId=WtcUtil.repNull(request.getParameter("servBusiId"));
	String prtFlag=WtcUtil.repNull(request.getParameter("prtFlag"));
	String workNo=(String)session.getAttribute("workNo");
	/* liujian add workNo and password 2012-4-5 15:59:15 begin */
	String password = (String) session.getAttribute("password");
	
	String op_code = WtcUtil.repNull(request.getParameter("opCode"));
	/* ningtn opcode仍旧使用1219
	String op_code = "1219";*/
	String realOpCode = WtcUtil.repNull(request.getParameter("opCode"));
	/* liujian add workNo and password 2012-4-5 15:59:15 end */
	String cust_id=WtcUtil.repNull(request.getParameter("gCustId"));
	String gCustId=WtcUtil.repNull(request.getParameter("gCustId"));
	String groupId=(String)session.getAttribute("groupId");//区域标识
	    //String siteId =(String)session.getAttribute("siteId");//新区域标识
	String siteId =(String)session.getAttribute("groupId");//新区域标识
	String phone_no= WtcUtil.repNull(request.getParameter("phoneNo"));
	
	String accountType =  (String)session.getAttribute("accountType")==null?"":(String)session.getAttribute("accountType");//accountType == "2"时为客服工号进入

	String   sqlStrTempV1 = "select c.band_name from product_offer_instance a,product_offer b , band c where  a.offer_id = b.offer_id  and    b.band_id = c.band_id and    b.offer_type = 10 and    sysdate between a.eff_date and a.exp_date and    serv_id = "+offerSrvId;
	System.out.println("sqlStrTempV1|||"+sqlStrTempV1);
	String custPPv1 = "";
	System.out.println("-------------1219 sPMQryUserInfo-----new Date()-----------------"+new Date());
	
	String  inParamsSimType [] = new String[2];
  inParamsSimType[0] = "SELECT count(1) FROM wTDFixPhoneMsg a,dcustmsg b WHERE 1=1 and a.id_no=b.id_no and flag = '0' and b.phone_no=:phone_no";
  inParamsSimType[1] = "phone_no="+phone_no;

%>
<%String regionCode_sPMQryUserInfo = (String)session.getAttribute("regCode");%>
	<wtc:utype name="sPMQryUserInfo" id="retUserInfo" scope="end" routerKey="region" routerValue="<%=regionCode_sPMQryUserInfo%>">
     <wtc:uparam value="0" type="LONG"/>
     <wtc:uparam value="<%=phone_no%>" type="STRING"/>
     <wtc:uparam value="<%=workNo%>" type="string"/>
     <wtc:uparam value="<%=password%>" type="string"/>	
     <wtc:uparam value="<%=op_code%>" type="string"/>
    </wtc:utype>

		<wtc:pubselect name="sPubSelect" outnum="1">
			<wtc:sql>select nvl(b.service_no,a.phone_no) from dcustmsg a,daccountidinfo b where a.id_no='<%=offerSrvId%>' and a.phone_no=b.msisdn(+)</wtc:sql>
		</wtc:pubselect>
		<wtc:array id="row" scope="end" />
			
		<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode_simType" retmsg="retMessage_simType" outnum="1"> 
	    <wtc:param value="<%=inParamsSimType[0]%>"/>
	    <wtc:param value="<%=inParamsSimType[1]%>"/> 
	  </wtc:service>  
  	<wtc:array id="result_SimType"  scope="end"/>
		<%
			if("000000".equals(retCode_simType)){
	      if(result_SimType.length>0){
	        if(Integer.parseInt(result_SimType[0][0]) > 0){
	        	simTypeOne = "0";
	        }else{
	        	simTypeOne = "1";
	        }
	      }
	    }
			System.out.println("gaopengSeeLog1219==========simTypeOne==="+simTypeOne);
		%>

		<wtc:pubselect name="sPubSelect" outnum="1">
			<wtc:sql><%=sqlStrTempV1%></wtc:sql>
		</wtc:pubselect>
		<wtc:array id="result_y1" scope="end" />
<%
System.out.println("-------------1219 sPMQryUserInfo end-----new Date()-----------------"+new Date());
if(result_y1.length>0&&result_y1[0][0]!=null){
custPPv1 = result_y1[0][0];
}
	phone_no=row[0][0];
	%>
		<wtc:pubselect name="sPubSelect" outnum="1">
			<wtc:sql>select  decode(substr(attr_code, 5, 1),'0','0','1','1','2','2','3','3','0')  from  dCustMsg where  phone_no = '<%=phone_no%>' and substr(run_code, 2, 1) < 'a' </wtc:sql>
		</wtc:pubselect>
		<wtc:array id="row1" scope="end" />

		<wtc:pubselect name="sPubSelect" outnum="1">
			<wtc:sql>select  nvl(grp_name,'NULL')  from  sGrpBigFlag  where  grp_flag='<%=row1[0][0]%>' </wtc:sql>
		</wtc:pubselect>
		<wtc:array id="row2" scope="end" />
	<%
	String servId  = WtcUtil.repNull(request.getParameter("offerSrvId"));
	String proName="";
	String proEff="";
	String proExi="";
	String prodCompFlag="";
	String offerId =WtcUtil.repNull(request.getParameter("offerId"));
	
	String opCode=WtcUtil.repNull(request.getParameter("opCode"));
	/* ningtn opcode仍旧使用1219
	String opCode = "1219";*/
	String opName="产品变更";
	int num2=0;
	String Band_Id="";
	String custName="";
	String idIccid="";
	String custLevel="";
	String addr="";
	String Product_id="";
	String[] oldAttr=null;
	String offerMainInst="";
	String offerDis="";
	System.out.println("offerId================="+offerId);
	System.out.println("-------------1219 sInstance-----new Date()-----------------"+new Date());
%>
<%String regionCode_sInstance = (String)session.getAttribute("regCode");%>
<wtc:utype name="sInstance" id="mainInst" scope="end" routerKey="region" routerValue="<%=regionCode_sInstance%>">
	<wtc:uparam value="<%=servId%>" type="long" />
	<wtc:uparam value="<%=offerId%>" type="long" />
</wtc:utype>
<%
System.out.println("-------------1219 sInstance end-----new Date()-----------------"+new Date());
	String retCode2=mainInst.getValue(0);
	String retMsg2=mainInst.getValue(1);

	if(retCode2.equals("0"))
	{
	  if(mainInst.getUtype(2).getSize()>0)
	  {
			if(mainInst.getUtype("2.0").getSize()>0)
			{
				offerMainInst=mainInst.getValue("2.0.0");
			}else
			{
%>
<script>
			rdShowMessageDialog("查询主销售品实例Id错误");
			window.parent.removeTab("<%=closeId%>");
</script>
<%
			}
		}else
		{
%>
<script>
			rdShowMessageDialog("查询主销售品实例Id错误");
			window.parent.removeTab("<%=closeId%>");
</script>
<%
		}
	}
System.out.println("主销售品实例ID===="+offerMainInst);

String sm_code = "";
String sqll = "select sm_code from product_offer a, band b where a.band_id = b.band_id and a.offer_id = '"+offerId+"'";
%>
<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" retcode="sPubSelectCode" retmsg="sPubSelectMsg"  outnum="1">
	<wtc:sql><%=sqll%></wtc:sql>
</wtc:pubselect>
<wtc:array id="sPubSelectArr" scope="end" />
<%
    if("000000".equals(sPubSelectCode) && sPubSelectArr.length>0){
        sm_code = sPubSelectArr[0][0];
        System.out.println("# sm_code = "+sm_code);
    }else{
    %>
        <script>
            rdShowMessageDialog("查询smCode出错！",0);
        </script>
    <%
        System.out.println("# return from changeProduce.jsp -> 查询smCode出错！");
    }
    System.out.println("-------------1219 sGetUsrMain-----new Date()-----------------"+new Date());
%>
<%String regionCode_sGetUsrMain = (String)session.getAttribute("regCode");%>
<wtc:utype name="sGetUsrMain" id="mainProd" scope="end" routerKey="region" routerValue="<%=regionCode_sGetUsrMain%>">
	<wtc:uparam value="<%=offerSrvId%>" type="long"/>
</wtc:utype>
<%
System.out.println("-------------1219 sGetUsrMain end-----new Date()-----------------"+new Date());
  System.out.println("-------------1-----new Date()-----------------"+new Date());
	StringBuffer logBuffer9 = new StringBuffer(80);
	WtcUtil.recursivePrint(mainProd,1,"2",logBuffer9);
  //System.out.println(logBuffer9.toString());
	String retCode9=mainProd.getValue(0);
	String retMsg9=mainProd.getValue(1);
	if(retCode9.equals("0"))
	{
//System.out.println("size====="+mainProd.getUtype("2").getSize());
		Product_id=mainProd.getValue("2.0");
		proEff=mainProd.getValue("2.1");
		proExi=mainProd.getValue("2.2");
		prodCompFlag=mainProd.getValue("2.3");
		proName=mainProd.getValue("2.4");

		//System.out.println("----------------------------proEff-------------######################------"+proEff);
	}
	//System.out.println("----------------------------proEff-------------######################------"+proEff);
//System.out.println("主产品ID===="+Product_id);
%>
<wtc:pubselect name="sPubSelect" outnum="1">
	<wtc:sql>select band_id from product_offer where offer_id='<%=offerId%>'</wtc:sql>
</wtc:pubselect>
<wtc:array id="rows" scope="end" />
<%

System.out.println("-------------2-----new Date()-----------------"+new Date());
	if(retCode.equals("000000"))
	{
		Band_Id=rows[0][0];
	}

%>
<wtc:sequence name="sPubSelect"  key="sMaxSysAccept" id="loginAccept"/>

<%
System.out.println("------zhenghan-------1219 sGetCustOrdMsg -----new Date()-----------------"+new Date());
	System.out.println("zhangyan~chp~~~phoneNo="+phone_no);
%>
<%String regionCode_sGetCustOrdMsg = (String)session.getAttribute("regCode");%>
<wtc:utype name="sGetCustOrdMsg" id="retCustVal" scope="end" routerKey="region" routerValue="<%=regionCode_sGetCustOrdMsg%>">
		<wtc:uparam value="<%=cust_id%>" type="long" />
		<wtc:uparam value="<%=workNo%>" type="string"/>
		<wtc:uparam value="<%=groupId%>" type="string"/>
		<wtc:uparam value="<%=phone_no%>" type="string"/>
</wtc:utype>
<%

System.out.println("-------------1219 sGetCustOrdMsg end-----new Date()-----------------"+new Date());
	StringBuffer logBuffer = new StringBuffer(80);
	WtcUtil.recursivePrint(retCustVal,1,"2",logBuffer);
	//System.out.println(logBuffer.toString());
	String retCode0=retCustVal.getValue(0);
	String retMsg0=retCustVal.getValue(1);
	if(retCode0.equals("0"))
	{
		UType userOrdInfo=(UType)retCustVal.getUtype(2);
		custName=userOrdInfo.getValue(1);
		idIccid=userOrdInfo.getValue(2);
		custLevel=userOrdInfo.getValue(5);
		addr=userOrdInfo.getValue(4);
		System.out.println("-------------addr------------"+addr);
		for(int i=0;i<retCustVal.getUtype("2.6").getSize();i++)
		{
			if(retCustVal.getValue("2.6."+i+".0").equals(offerSrvId))
			{
				offerDis=retCustVal.getValue("2.6."+i+".9");//基本销售品描述
			}
		}
%>
<%
}else
{
%>
<script>
	rdShowMessageDialog("查询用户信息出错,"+"<%=retCode0%>"+"<%=retMsg0%>");
</script>
<%
}
System.out.println("-------------1219 sQProdIntAtr -----new Date()-----------------"+new Date());
%>
<%String regionCode_sQProdIntAtr = (String)session.getAttribute("regCode");%>
<wtc:utype name="sQProdIntAtr" id="retVal1" scope="end"  routerKey="region" routerValue="<%=regionCode_sQProdIntAtr%>">
	<wtc:uparam value="1" type="int" />
	<wtc:uparam value="<%=servId%>" type="long" />
</wtc:utype>
<%
System.out.println("-------------1219 sQProdIntAtr end -----new Date()-----------------"+new Date());
  	StringBuffer logBuffer2 = new StringBuffer(80);
		//System.out.println(logBuffer2.toString());
		WtcUtil.recursivePrint(retVal1,1,"2",logBuffer2);
		String retCode1 = retVal1.getValue(0);
		if(retCode1.equals("0"))
		{
//System.out.println("====属性组的数量==="+retVal1.getUtype(2).getSize());
		oldAttr=new String[retVal1.getUtype(2).getSize()];
  	for(int i=0;i<retVal1.getUtype(2).getSize();i++)
  	{
  				if(retVal1.getValue("2."+i+".4").equals(""))
  				{
  					oldAttr[i]=retVal1.getValue("2."+i+".3")+"~M^";
  				}else
  				{
  					oldAttr[i]=retVal1.getValue("2."+i+".3")+"~"+retVal1.getValue("2."+i+".4");
  				}
  	}
  	}
 System.out.println("-------------6-----new Date()-----------------"+new Date());
%>
	 <wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>"  id="sysAcceptl" />
	<%
	 System.out.println("-------------7-----new Date()-----------------"+new Date());
	%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title><%=opName%></title>
<!-- <link href="<%=request.getContextPath()%>/nresources/default/css_sx/FormText.css" rel="stylesheet"type="text/css"> -->
<link href="<%=request.getContextPath()%>/nresources/default/css/products.css" rel="stylesheet"type="text/css">
</head>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/product/autocomplete_ms.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/product/product.js"></script>
<script type="text/javascript" src="/npage/public/checkGroup.js" ></script>
<script type="text/javascript">
var offerId ="<%=offerId%>";
var offerNodes;
var trNum=0;
var nodesHash = new Object();

var myArrs = new Array("1027","1026","1025","2042");

function chgStartDate(nodeObj){
	var nodeId = nodeObj.id.substr(10);
	/*默认给国际漫游赋值时间 增加61天 这个与complexPro_ajax.jsp 获取默认时间异曲同工
		可有可无
	*/
	/* if("1027" == nodeId ){
		var showStatu = $("#proName_" + nodeId + "").text();
		if(showStatu != "不正常"){
			// CRM客服系统的需求，自动计算结束日期
			var endDateStr = "stopDate_" + nodeId;
			var endDateObj = $("input[name^='" + endDateStr + "']");
			var startDateVal = nodeObj.value;
			startDateVal = startDateVal.substr(0,4)+"/"+startDateVal.substr(4,2)+"/"+startDateVal.substr(6);
			var endDateVal = DateAdd(startDateVal);
			alert(endDateVal);
			endDateObj.val(endDateVal);
		}
	} */
	if(findStrInArr(nodeId,myArrs)){
		/*退订的话，就不更改时间了*/
		var objProText = $("#proName_"+nodeId).text();
		if("退订" == objProText){
			return false;
		}
		var startDateVal = nodeObj.value;
		setRomaDate(nodeId,startDateVal);
	}
}

function ifOver12Month(startTimeStr,endTimeStr){
	
		var number = 0;
		startTimeStr = startTimeStr.substring(0,4)+"-"+startTimeStr.substring(4,6)+"-"+startTimeStr.substring(6,8);
		endTimeStr = endTimeStr.substring(0,4)+"-"+endTimeStr.substring(4,6)+"-"+endTimeStr.substring(6,8);
		var startDate=new Date(startTimeStr.replace("-", "/").replace("-", "/"));    
    var endDate=new Date(endTimeStr.replace("-", "/").replace("-", "/")); 
    var yearToMonth = (endDate.getFullYear() - startDate.getFullYear()) * 12;      
    number += yearToMonth;      
    monthToMonth = endDate.getMonth() - startDate.getMonth();      
    number += monthToMonth;    
    var retNum = parseInt(number);
    return retNum;   
}

function DateAdd(dtDate)   {   
  var dtTmp = new Date(dtDate);   
  if (isNaN(dtTmp)) dtTmp = new Date();   
	dtTmp = new Date(Date.parse(dtTmp) + (86400000 * 61));
  var mStr=new String(dtTmp.getMonth()+1);
  var dStr=new String(dtTmp.getDate());
  if (mStr.length==1){
      mStr="0"+mStr;
  }
  if (dStr.length==1){
      dStr="0"+dStr;
  }
  return dtTmp.getFullYear()+mStr+dStr;
}  
function findStrInArr(str1,arrObj){
	var reFlag = false;
	$.each(arrObj,function(i,n){
		if(n == str1){
			reFlag = true;
		}
	});
	return reFlag;
}
function setRomaDate(handleId,setStartDate){
	selectedObj = $("input[name^='startDate_']");
	$.each(selectedObj,function(i,n){
		var objId = n.name.substr(10);
		if(objId != handleId && findStrInArr(objId,myArrs)){
			/* 非当前更改的，其他漫游的开始时间 */
			var objStartDate = n.value;
			/* 系统当前时间 */
			var sysTime = "<%=dateStr2%>";
			if(sysTime >= objStartDate){
				var endDateStr = "stopDate_" + objId;
				$("input[name='" + endDateStr +"']").val(setStartDate);
			}
			/* 如果是当前生效，那更改的漫游设置为退订 *
			if(sysTime == setStartDate){
				setUnsub(objId);
			}else if(sysTime < setStartDate){
				/* 如果是预约生效，那更改的漫游设置为正常 *
				setNormalStatu(objId);
			}
			***  提出要求，又不要此功能了  ***/
		}
	});
}

function checkRoma(oid){
	//如果新购的是漫游类，判断是否有多个漫游
	var reFlag = false;
	if(findStrInArr(oid,myArrs)){
		if(getRomaNum() >= 2){
			rdShowMessageDialog("不能预约多个漫游",0);
			reFlag = true;
		}
		var selectedObj = $("input[name^='startDate_']");
		$.each(selectedObj,function(i,n){
			var objId = n.name.substr(10);
			var objStartDate = n.value;
			var objProText = $("#proName_"+objId).text();
			/* 系统当前时间 */
			var sysTime = "<%=dateStr2%>";
			if(objStartDate > sysTime && "退订" != objProText && findStrInArr(objId,myArrs)){
				rdShowMessageDialog("不能预约多个漫游",0);
				reFlag = true;
			}
		});
	}
	return reFlag;
}
function getRomaNum(){
	var selectedObj = $("input[name^='startDate_']");
	var romaNum = 0;
	$.each(selectedObj,function(i,n){
		var objId = n.name.substr(10);
		if(findStrInArr(objId,myArrs)){
			romaNum++;
		}
	});
	return romaNum;
}
function getRomaArr(){
	var selectedObj = $("input[name^='startDate_']");
	var romaNum = 0;
	var romaArrs = new Array();
	$.each(selectedObj,function(i,n){
		var objId = n.name.substr(10);
		if(findStrInArr(objId,myArrs)){
			romaArrs[romaNum] = objId;
			romaNum++;
		}
	});
	return romaArrs;
}
function callOffRoma(oid){
	//取消的是否是漫游类
	var reFlag = false;
	if(findStrInArr(oid,myArrs)){
		//判断是否是正在生效的漫游，不可以取消
		var thisStartDateStr = "startDate_" + oid;
		var thisStartDate = $("input[name='" + thisStartDateStr + "']").val();
		/* 系统当前时间 */
		var sysTime = "<%=dateStr2%>";
		if(thisStartDate <= sysTime){
			rdShowMessageDialog("不能退订当前生效漫游",0);
			reFlag = true;
		}
	}
	return reFlag;
}
function callOffRomaDate(oid){
	//取消预约漫游时，更改正在生效的漫游时间
	if(findStrInArr(oid,myArrs)){
		//是漫游类
		//获取正在生效的漫游id
		var effRomaId = getEffRomaId(oid);
		if(effRomaId.length == 0){
			return false;
		}
		var stopDateSaveVal = $("input[name='stopDateSave_" + effRomaId + "']").val().substr(0,8);
		$("input[name='stopDate_" + effRomaId + "']").val(stopDateSaveVal);
		
		/* 取消掉勾选的漫游，恢复正在生效的漫游状态 */
		setNormalStatu(effRomaId);
	}
}
function unsubscribeRomaDate(oid){
	//退订掉预约漫游，更改正在生效的漫游时间
	if(findStrInArr(oid,myArrs)){
		//是漫游类
		//获取正在生效的漫游id
		var effRomaId = getEffRomaId(oid);
		/***   结束时间改成历史表中的结束时间****/
		var expTimeHis = $("input[id='expTimeHis_" + effRomaId + "']").val();
		$("input[name='stopDate_" + effRomaId + "']").val(expTimeHis);
		/* 取消掉勾选的漫游，恢复正在生效的漫游状态 */
		setNormalStatu(effRomaId);
	}
}
function getEffRomaId(oid){
	var selectedObj = $("input[name^='startDate_']");
	var returnVal = "";
	$.each(selectedObj,function(i,n){
			var objId = n.name.substr(10);
			/* 系统当前时间 */
			var sysTime = "<%=dateStr2%>";
			if(objId != oid && findStrInArr(objId,myArrs)){
				//是漫游类，判断开始时间结束时间
				var thisStartDate = $("input[name='startDate_"+objId+"']").val();
				var thisStopDate = $("input[name='stopDate_"+objId+"']").val();
				if(thisStartDate <= sysTime && sysTime <= thisStopDate){
					returnVal = objId;
				}
			}
	});
	return returnVal;
}

function setNormalStatu(setNodeId){
		$("#proName_"+setNodeId).text("正常");
		if($("#stopDate_"+setNodeId).attr("modFlag") == "true"){
			$("#stopDate_"+setNodeId).removeClass("InputGrey");
			$("#stopDate_"+setNodeId).attr("readOnly",false);
		}
		$("#" + setNodeId + "").attr("checked","true");
		$("#" + setNodeId + "").removeAttr("disabled");
}
function setUnsub(setNodeId){
		$("#proName_"+setNodeId).text("退订");
		if($("#stopDate_"+setNodeId).attr("modFlag") == "true"){
			$("#stopDate_"+setNodeId).addClass("InputGrey");
			$("#stopDate_"+setNodeId).attr("readOnly",true);
		}
		$("#" + setNodeId + "").attr("checked","");
		$("#" + setNodeId + "").attr("disabled","disabled");
}

$(document).ready(function () {
	if("<%=accountType%>" == "2"){
		rdShowMessageDialog("当前工号为客服类工号，不允许访问此功能！");
		removeCurrentTab();
	}
	$("#complex_pro").append("<div id='complex_"+offerId+"'></div>");
	$("#complex_"+offerId).after("<div id='complex_pro_"+offerId+"' ></div>");
	
	$("#pro_component").append("<div id='prod_"+offerId+"'></div>");
	$("#prod_"+offerId).after("<div id='pro_"+offerId+"' ></div>");
	$("#pro_"+offerId).append("<table id='tab_pro' cellspacing=0></table>");
	$("#tab_pro").append("<tr><th>产品名称</th><th>开始时间</th><th>结束时间</th><th>状态</th><th>操作</th></tr>");
	    var packet = new AJAXPacket("GetProdAttr2.jsp","请稍后...");
			packet.data.add("servId" ,"<%=servId%>");
			packet.data.add("flag" ,"1");
			packet.data.add("ProdId" ,"<%=Product_id%>");
			packet.data.add("isNew" ,"0");
			core.ajax.sendPacketHtml(packet,doGetAttrHtml);
			packet =null;
			loading("正在加载产品信息，请稍候······");
			var packet = new AJAXPacket("complexPro.jsp","请稍后...");//组合产品子产品展示
			packet.data.add("servId" ,"<%=servId%>");
			packet.data.add("offerId" ,"<%=offerId%>");
			packet.data.add("opCode" ,"<%=opCode%>");
			packet.data.add("com_pro_id" ,"<%=Product_id%>");
			packet.data.add("com_pro_intId" ,"<%=offerSrvId%>");
			packet.data.add("smCode" ,"<%=sm_code%>");
			packet.data.add("realOpCode" ,$("#realOpCode").val());
			core.ajax.sendPacketHtml(packet,doGetHtml2,true);
			packet =null;
			
		/*ningtn 为e904增加领导的必输框*/
		if($("#realOpCode").val() == "e904"){
			$("#leaderTab").show();
			$("#bd_0007_opnote").text("请求人情况说明");
			$("#op_note").attr("readonly","readonly");
		}
		
	
  });
//ng35 复选框后面文字可点 hejwa 2012-12-11 
function cheThis(bt){
	$(bt).prev().click();
}
function doGetAttrHtml(data)
{
	
	$("#attrlist").html(data);
	$("#attrlist :input").not(":button").each(chkDyAttribute);
}

function doGetHtml(data)
{
	$("#offer_component").html(data);
	offerNodes = baseClass;
	showInfo(offerNodes);		//生成销售品构成展示
	initInfo(offerNodes);		//初始化构成,必选 可选 默认选中
	$("#div_offerComponent :checkbox").bind("click",fn);
	var majorProductId = "";
	if(majorProductArr.length > 0){
	 	majorProductId = majorProductArr[1];
	}
	else{
		rdShowMessageDialog("无主产品信息!");
		return false;
	}
	if(majorProductArr[9]=="1")
	{
			var packet = new AJAXPacket("complexPro.jsp","请稍后...");//组合产品子产品展示
			packet.data.add("servId" ,"<%=servId%>");
			packet.data.add("com_pro_id" ,majorProductId);
			packet.data.add("com_pro_intId" ,majorProductArr[13]);
			packet.data.add("smCode" ,"<%=sm_code%>");
			packet.data.add("realOpCode" ,$("#realOpCode").val());
			core.ajax.sendPacketHtml(packet,doGetHtml2,true);
			packet =null;
	}else
	{
			var packet2 = new AJAXPacket("getOfferRel2.jsp","请稍后...");
			packet2.data.add("offerId" ,offerId);
			packet2.data.add("maxNum" ,majorProductArr[6]);
			core.ajax.sendPacketHtml(packet2,getOfferRel,true);
			packet2 =null;
	}
}
function doGetHtml2(data)
{
	$("#complex_component").html(data);
	offerNodes2 = baseClass2;
	showInfo2(offerNodes2);		//生成销售品构成展示
	initInfo2(offerNodes2);		//初始化构成,必选 可选 默认选中
	//alert($("#p_2049").html());
	//alert($("#realOpCode").val());
	/*2015/10/15 15:27:52 gaopeng 关于铁通TD固话业务受理BOSS系统增加相关功能的通知
		1219特服变更时，如果品牌是TE 判断是否为TD固话sim卡类型，显示或隐藏
		2049:开通短信接收
		1038:GPRS业务
	*/
	if($("#realOpCode").val() == "1219"){
		chgSimTypeOne();
	}else{
		$("#p_2049").hide();
		$("#1038").hide();
	}
	/****
		如果是e904 只保留漫游的列表
	*/
	if($("#realOpCode").val() == "e904"){
		var prodObj = $("#tab_pro tr[id^='pro_detail_']");
		$.each(prodObj,function(i,n){
			if($(this).attr("id") != "pro_detail_1027" 
					&& $(this).attr("id") != "pro_detail_1026"
					&& $(this).attr("id") != "pro_detail_1025"
					&& $(this).attr("id") != "pro_detail_2042"){
						$(this).hide();
			}
		});
	}
	
	var classValues = "";
	var classIds ="";
	/*zhangyan*/
	for(var i=0;i<offerNodes2.item.length;i++)
	{
		if(offerNodes2.item[i].getType() == "M"
			||offerNodes2.item[i].getType() == "O")
		{
			classValues=classValues+offerNodes2.item[i].getId()+"|";
			classIds+="p_"+offerNodes2.item[i].getId()+"|";

		}
	}

	btcGetMidPrompt("10431",classValues,classIds,"<%=sm_code%>");

	 $("#complex_pro :checkbox").bind("click",fn2);
	var packet2 = new AJAXPacket("getOfferRel2.jsp","请稍后...");
			packet2.data.add("offerId" ,offerId);
			packet2.data.add("maxNum" ,"");
			packet2.data.add("opCode" ,"<%=opCode%>");
			packet2.data.add("phoneNo" ,"<%=phone_no%>");
			core.ajax.sendPacketHtml(packet2,getOfferRel,true);
			packet2 =null;
	loading();
}

function chgSimTypeOne(){
	/*2015/10/12 14:54:14 gaopeng 关于铁通TD固话业务受理BOSS系统增加相关功能的通知
		修改“普通开户(1104)”功能，如果是铁通e固话(品牌为TE),则界面增加一个选择“SIM卡类型(TD固话SIM卡/非TD固话的SIM卡)”。
		1）如果选择“TD固话SIM卡”，则保持现有规则不变，如特服、SIM卡等.
		2）如果选择“非TD固话的SIM卡”，则可以使用普通的SIM卡，可以与137号段、139号码等非TD固话的SIM卡进行混补。在现有可以选择特服的前提下，
		增加“GPRS特服”和“开通短信接收”的展示，默认选中，可以去掉。
	*/
	var simTypeOne = "<%=simTypeOne%>";
	/*选中TD固话SIM卡 逻辑不变 隐藏 开通短信接收 和 GPRS特服
		
	*/
	/*隐藏 2049:开通短信接收 以及 GPRS*/
	
	if(simTypeOne == "1" && "<%=sm_code%>" == "TE"){
		//$("#2046").attr("disabled","disabled");
		$("#p_2049").hide();
		if(typeof($("#2049")) != "undefined"){
			if($("#2049").attr("checked")){
				$("#2049").click();
			}
		$("#2049").attr("disabled","");
		}
		
		$("#p_1038").hide();
		if(typeof($("#1038")) != "undefined"){
			if($("#1038").attr("checked")){
				$("#1038").click();
			}
		$("#1038").attr("disabled","");
		}
	}else if(simTypeOne == "0" && "<%=sm_code%>" == "TE"){
		//$("#2046").attr("disabled","disabled");
		$("#p_2049").show();
		if(typeof($("#2049")) != "undefined"){
			if($("#2049").attr("checked")){
				
			}else{
				$("#2049").click();
			}
			$("#2049").attr("disabled","");
		}
		$("#p_1038").show();
		if(typeof($("#1038")) != "undefined"){
			if($("#1038").attr("checked")){
				
			}else{
				$("#1038").click();
			}
			$("#1038").attr("disabled","");
		}
	}
}

function getOfferRel(data)
{	
	//$("#offer_component").html(data);
	$("#complex_component").html(data);
	unLoading();
		setSpecialGroup("D12042","1","2");
			Pz.busi.operBusi($('#complex_pro :checkbox'),'groupTitle',true,3);
}
function fn(){
	try{
		var vId = "div_"+this.id;
		checkRel(this);
		if(this.checked == true){
			$("#"+vId).css("display","");
		}
		else{
			$("#"+vId).css("display","none");
			nodesHash[this.id].cancelChecked(nodesHash[this.id]);
		}
	}catch(E){
		 	  rdShowMessageDialog("正在加载销售品构成,请稍候....");
		 	  return false;
	}
}
function fn2(){
	var oid = this.id;
	var obj = this;
	try{
		var vId = "div_"+this.id;
		checkRel2(this);
		
		if(this.checked == true){
			$("#"+vId).css("display","");
			var arrClassValue = new Array();
			arrClassValue.push(this.id);
			
		}
		else{
			$("#"+vId).css("display","none");
			nodesHash[this.id].cancelChecked(nodesHash[this.id]);
		}
	}catch(E){
		rdShowMessageDialog("正在加载销售品构成,请稍候....");
		if(obj.checked == true){
			nodesHash[oid].cancelChecked(nodesHash[oid]);
			$("#pro_detail_"+oid).remove();
		}else{
		
		}
		return false;
	}
}
function checkRel2(obj)
{
	var retCo="";
	var retMs="";
  var _id = obj.id;
  if(itemHash != null){
  	var items = itemHash[_id];
  }
  /*if(!chkDependens2(obj))
	{
		return false;
	}*/


	if(obj.checked==false){
		  var dependItems=new Object();
	  	if(dependHash != null){
		  	 dependItems= dependHash[_id];
		  }
		  if(typeof(dependItems) != "undefined"){
		  	/*$("#div_offerComponent :checked").each(function(){
			     if(dependItems.hasElement(this.id))
			     {
			     	 $("#"+this.id).attr('checked','');
			     	 chgDetailProd(_id);//联动取消右边产品那条记录
			     	 $("#div_"+this.id).css("display","none");
			     	 nodesHash[this.id].cancelChecked(nodesHash[this.id]);
			     }
				});*/
					$("#complex_pro :checked").each(function(){
			     if(dependItems.hasElement(this.id))
			     {
			     	 $("#"+this.id).attr('checked','');
			     	 chgDetailProd2(_id);//联动取消右边产品那条记录
			     	 chgDetailProd2(this.id);//联动取消右边产品那条记录
			     	 $("#div_"+this.id).css("display","none");
			     	 nodesHash[this.id].cancelChecked(nodesHash[this.id]);
			     }
				});
		  }

		  /*add by qidp @ 2009-07-21 for 销售品限制*/
        	if(nodesHash[_id].statu=="已订购")
           	{
        		 var retArr=chkLimit(_id,"0").split("@");
        	     retCo=retArr[0].trim();
        	     retMg=retArr[1];
        	     if(retCo!="0")
        	     {
        	     	   rdShowMessageDialog(retMg);
        	     	   $("#"+_id).attr('checked','checked');
        	     	   chgDetailProd2(_id);//联动取消右边产品那条记录
        	     	   return false;
        	     }
        	}
        /*end by qidp*/
	  }

		if(obj.checked==true)
		{
			if(typeof(items) != "undefined")
  		{
			/*$("#div_offerComponent :checkbox").each(function(){
			     if(items.raletionWith(this.id) == 1 && $("#"+this.id)[0].checked == true)
			     {
			     	 rdShowMessageDialog(nodesHash[_id].getName()+"与"+nodesHash[this.id].getName()+"互斥!");
			     	 $("#"+_id).attr('checked','');
			     	 chgDetailProd(_id);//联动取消右边产品那条记录
			     	 return false;
			     }

			     if(items.raletionWith(this.id) == 0 && $("#"+this.id)[0].checked == false)
			     {
			     	 rdShowMessageDialog(nodesHash[_id].getName()+"依赖于"+nodesHash[this.id].getName()+",请选择"+nodesHash[this.id].getName()+"!");
			     	 $("#"+_id).attr('checked','');
			     	 chgDetailProd(_id);//联动取消右边产品那条记录
			     	 return false;
			     }
			});*/
			$("#complex_pro :checkbox").each(function(){
			    /* if(items.raletionWith(this.id) == 1 && $("#"+this.id)[0].checked == true)
			     {
			     	 rdShowMessageDialog(nodesHash[_id].getName()+"与"+nodesHash[this.id].getName()+"互斥!",0);
			     	 $("#"+_id).attr('checked','');
			     	 chgDetailProd2(_id);//联动取消右边产品那条记录
			     	 return false;
			     }*/

			     if(items.raletionWith(this.id) == 0 && $("#"+this.id)[0].checked == false)
			     {
			     	 rdShowMessageDialog(nodesHash[_id].getName()+"依赖于"+nodesHash[this.id].getName()+",请选择"+nodesHash[this.id].getName()+"!",0);
			     	 $("#"+_id).attr('checked','');
			     	 chgDetailProd2(_id);//联动取消右边产品那条记录
			     	 return false;
			     }

			});
	  }

/*add by qidp @ 2009-07-21 for 销售品限制*/

	if(nodesHash[_id].statu=="未订购")
   	{
		 var retArr=chkLimit(_id,"1").split("@");
	     retCo=retArr[0].trim();
	     retMg=retArr[1];
	     if(retCo!="0")
	     {   
					if($("#realOpCode").val() == "e904" && retCo == "273"){
					}else{
						rdShowMessageDialog(retMg);
						$("#"+_id).attr('checked','');
						chgDetailProd2(_id);//联动取消右边产品那条记录
						return false;
					}
	     }
	}

/*end by qidp*/
/*add by yanpx @ 2009-07-21 for 销售品限制*/
/*
	   var retArr=chkLimit(_id).split("@");
			      retCo=retArr[0].trim();
			     retMg=retArr[1];
			     if(retCo!="0" && nodesHash[_id].statu=="未订购")
			     {
			     	   rdShowMessageDialog(retMg);
			     	   $("#"+_id).attr('checked','');
			     	   chgDetailProd2(_id);//联动取消右边产品那条记录
			     	   return false;
			     }
*/
/*end by yanpx*/
  }

}
/*
function chkLimit(id)
{
	var retList="";
	var phoneNo="<%=offerSrvId%>";
	var opCode="<%=opCode%>";
	var senddata={};
	senddata["phoneNo"] = phoneNo;
	senddata["opCode"] = opCode;
	senddata["prodId"] = id;
	senddata["vQtype"] = "1";

		$.ajax({
		  url: 'limitChk.jsp',
		  type: 'POST',
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
*/
/*add by qidp @ 2009-07-22 for 销售品限制*/
function chkLimit(id,iOprType)
{
	var retList="";
	var phoneNo="<%=offerSrvId%>";
	var opCode="<%=opCode%>";
	var senddata={};
	senddata["opCode"] = opCode;
	senddata["prodId"] = id;
	senddata["iOprType"] = iOprType;
	senddata["vQtype"] = "1";
	senddata["idNo"] = "<%=offerSrvId%>";
		$.ajax({
		  url: 'limitChk.jsp',
		  type: 'POST',
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
/*end by qidp*/
	function queryInfo(obj){
		var tmpStr = document.all("query"+obj).v_sql.split("~"); //拆分sql语句和fieldName
		var sqlStr = tmpStr[0];
		var fieldName = tmpStr[1];
		if(sqlStr.indexOf("#")>-1){
			var chPos1 = sqlStr.indexOf("#");
			var chPos2;
			var chObj;
			var chStr;
			var tmp = "";
			while(chPos1>-1){
				chStr = sqlStr.substring(chPos1+1);
				chPos2 = chStr.indexOf("#");
				chObj = chStr.substring(0,chPos2);
				tmp = "#"+chObj+"#";
				sqlStr = sqlStr.replace(tmp,"'"+document.all(chObj).value+"'");
				chPos1 = sqlStr.indexOf("#");
			}
		}
		var pageTitle = document.all(obj).v_name+"查询";
		var selType = "S";    //'S'单选；'M'多选
		var retQuence = "1|0";
		var retToField = obj+"";
		PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
	}
</script>
<script language="javascript">
	function shutdown()
	{
		window.parent.removeTab("<%=closeId%>");
	}
	function next()
	{
		//alert("next");
		var goOnFlag="true";
		$("#complex_pro :checkbox").each(function(){
	  	var _id=this.id;
	  	if($("#"+_id)[0].checked == true && $("#proName_"+_id).text()=="新购")
	  	{
	  		var items = itemHash[_id];
	  		if(typeof(items) != "undefined")
  			{
	  			$("#complex_pro :checkbox").each(function(i,n){
	  			 off_id=n.id;
			     if(items.raletionWith(off_id) == 1 && $("#"+off_id)[0].checked == true &&  (parseInt($("#startDate_"+_id).val())< parseInt($("#stopDate_"+off_id).val())))
			     {
			     	 if(parseInt($("#stopDate_"+_id).val())> parseInt($("#startDate_"+off_id).val()))
			     	 {
			     	 		rdShowMessageDialog(nodesHash[_id].getName()+"与"+nodesHash[this.id].getName()+"互斥且时间存在交叉",0);
			     	 		goOnFlag="false";
			     			// $("#"+_id).attr('checked','');
			     			// chgDetailProd2(_id);//联动取消右边产品那条记录
			     	 		return false;
			     	}
			     }
			    /* if(items.raletionWith(off_id) == 1 && $("#"+off_id)[0].checked == false && nodesHash[off_id].statu=="已订购" &&  (parseInt($("#startDate_"+_id).val())< parseInt($("#stopDate_"+off_id).val())|| parseInt($("#stopDate_"+_id).val())< parseInt($("#startDate_"+off_id).val())) )
			     {
			     		if(parseInt($("#stopDate_"+_id).val())> parseInt($("#startDate_"+off_id).val()))
			     	 {
			     	 		rdShowMessageDialog(nodesHash[_id].getName()+"与"+nodesHash[this.id].getName()+"互斥且时间存在交叉",0);
			     	 		goOnFlag="false";
			     	 		//$("#"+_id).attr('checked','');
			     	 		//chgDetailProd2(_id);//联动取消右边产品那条记录
			     	 		return false;
			     		}
			     }*/
			    });
			 }
	  }
});
if(goOnFlag=="false")
 return;
 
	/*ningtn 为e904增加领导的必输框*/
	if($("#realOpCode").val() == "e904"){
		var leaderName = $("#leader").val().trim();
		if(leaderName == ""){
			rdShowMessageDialog("请输入请求人的名字");
			$("#leader")[0].focus();
			return false;
		}
		document.all.op_note.value = leaderName + "要求为"+"<%=phone_no%>"+"号码开通国际漫游";
	}
document.all.sys_note.value = "用户<%=retUserInfo.getValue("2.0.2.1")%>特服变更";
if(document.all.op_note.value =="")
 document.all.op_note.value = "操作员<%=workNo%>对客户<%=retUserInfo.getValue("2.0.2.1")%>进行特服变更";

	    getAfterPrompt();
		//if(!checksubmit(document.frm))return false;
		var mainProAttr="";
		var attrCode = [];				//群组属性ID
  	var attrValue = [];		//群组属性value
  	   $("#attrlist :input").each(function(){
			if(this.value != "")
			{
				attrCode.push(this.name.substring(2));
				attrValue.push(this.value);
			}
		});
		for(var i=0;i<attrCode.length;i++)
		{
			mainProAttr=mainProAttr+attrCode[i]+"~"+attrValue[i]+",";
		}
		$("input[name='mainProAttrCode']").val(mainProAttr);
		var tempAttr="";
		var sonParentArr = []; //存放子~父
		var prodEffectDate = []; //产品生效时间
		var prodExpireDate = []; //产品失效时间
		var isMainProduct = [];//是否主产品标识
		var productStatu=[];//产品目前订购状态
		var attrFlag=[];//复合产品标志
		var prodNameArr =new Array();//产品名称（打印用）
		var proOptFlag=new Array();//产品操作代码
		var offerIdArr = new Array();//销售品代码
		var pordIdArr = new Array();//产品代码
		var offerEffectTime = new Array();//销售品生效时间
		var offerExpireTime = new Array();//销售品失效时间
		var offerStatu=new Array();//销售品状态(无用)
		var proAttrOptFlag=new Array();//产品属性操作代码
		var newStatu=new Array();//产品提交后状态
		var proIntIdArr= new Array();//产品实例ID
		var offerIntIdArr=new Array();//销售品实例ID
		var parentInstId = new Array();//上级产品实例ID
		var sureGG="true";//确定前的控制标记，如果新购产品有属性而未进行设置，不让提交。
		var adslPrint="";//速率打印
		proOptFlag.push("0");//主产品不会更改，操作代码填充0
		proIntIdArr.push("<%=offerSrvId%>");//塞入基本产品实例ID
		$("input[name='majorProductId']").val("<%=Product_id%>");
		pordIdArr.push("<%=Product_id%>");//塞入基本产品代码
		prodNameArr.push("<%=proName%>");
		productStatu.push("已订购");//塞入基本产品目前状态
		newStatu.push("A");//塞入基本产品提交后状态
		prodEffectDate.push("<%=proEff%>");
		prodExpireDate.push("<%=proExi%>");
		isMainProduct.push(1);//塞入是否基本产品代码
		offerIntIdArr.push("<%=offerMainInst%>");//塞入基本销售品实例ID


<%
		if(oldAttr!=null)
		{
			System.out.println("======oldAttr.length======"+oldAttr.length);
					for(int i=0;i<oldAttr.length;i++)
					{
						System.out.println("第"+i+"个属性："+oldAttr[i]);
							String[] attTmp=oldAttr[i].split("~");
							String attrid=attTmp[0];
							String attrval=attTmp[1];
							if(attrval.equals("M^"))
							{
								attrval="";
							}
%>
							$("#attrlist :input").each(function(){
							  if(this.name.substring(2)=="<%=attrid%>" && this.value!="<%=attrval%>")
							  {
							  	if(this.v_type=="5")
							  	{
							  		var temp=this.options[this.selectedIndex].text;
							  		adslPrint=adslPrint+this.v_name+"："+temp.substring(temp.indexOf(">")+1)+"^1|";
							  	}else
							  	{
							  		adslPrint=adslPrint+this.v_name+"："+this.value+"^1|";
							  	}
							  	if(this.value==""||typeof(this.value)=="undefined"||this.value==null)
							  	{
							  		tempAttr=tempAttr+this.name.substring(2)+"~"+"M^,";
							  	}else
							  	{
										tempAttr=tempAttr+this.name.substring(2)+"~"+this.value+",";
									}
								}
							});

<%
					}
		}
%>
		if(tempAttr=="")
		{
			if($("input[name='mainProAttrCode']").val()=="")//主产品属性没变且空的话定义一个值填充位置，解析的时候注意。
			{
				$("input[name='mainProAttrCode']").val("M");
			}
			tempAttr="M";
			proAttrOptFlag.push("0");//塞入主产品属性操作代码
		}else
		{
			proAttrOptFlag.push("2");
		}
		var prodAttrValueArr = tempAttr+"@";
		attrFlag.push("<%=prodCompFlag%>");//塞入主产品复合产品标识
		parentInstId.push("0");//主产品的上级实例ID为0
		sonParentArr.push("<%=Product_id%>"+"~"+"<%=offerId%>");
		offerIdArr.push("<%=offerId%>");//主销售品代码
/*---------------------------------------------begin对主产品附加产品树的解析拼串过程begin------------------------------------------------*/

				var vFlag = true;
$("#complex_pro :checkbox").each(function(){
	
				if($("#"+this.id)[0].checked == false && $("#proName_"+this.id).text()=="")//未定购的且这次没选中的，不做任何操作
				{
				}else
				{
					if($("#"+this.id)[0].checked == true && $("#proName_"+this.id).text()=="新购" && nodesHash[this.id].haveAttr==1 && $("#att_"+this.id).attr("class")=="but_property")
					{
						rdShowMessageDialog("请设置"+nodesHash[this.id].getName()+"的属性");
						sureGG="false";
						return false;
					}
					/***************************begin  拼产品的操作代码(0 无变化,1 增加,2 修改,3 删除)*********************/
							if($("#"+this.id)[0].checked == true && $("#proName_"+this.id).text()=="正常")
							{
								if(nodesHash[this.id].proStatu=="G")
								{
									proOptFlag.push("2");
									proIntIdArr.push(nodesHash[this.id].proIntId);
								}else if($(document.getElementById("startDate_"+this.id)).attr("class") != "InputGrey" && $(document.getElementById("startDate_"+this.id)).val() != $(document.getElementById("startDateSave_"+this.id)).val().substring(0,8)){
										if($(document.getElementById("startDate_"+this.id)).val()>"<%=dateStr2%>"){
											  proOptFlag.push("5");
											}else{
								    		proOptFlag.push("2");
								      }
									  proIntIdArr.push(nodesHash[this.id].proIntId);
								}else if($(document.getElementById("stopDate_"+this.id)).attr("class") != "InputGrey" && $(document.getElementById("stopDate_"+this.id)).val() != $(document.getElementById("stopDateSave_"+this.id)).val().substring(0,8)){
								    proOptFlag.push("2");
									proIntIdArr.push(nodesHash[this.id].proIntId);
								}else
								{
									proOptFlag.push("0");
									proIntIdArr.push(nodesHash[this.id].proIntId);
								}
							}else if($("#"+this.id)[0].checked == false && $("#proName_"+this.id).text()=="退订")
							{
								proOptFlag.push("3");
								proIntIdArr.push(nodesHash[this.id].proIntId);
							}else if($("#"+this.id)[0].checked == true && $("#proName_"+this.id).text()=="新购")
							{
								proOptFlag.push("1");
								proIntIdArr.push("0");
							}else
							{
								if(nodesHash[this.id].proStatu=="G")
								{
									proOptFlag.push("0");
									proIntIdArr.push(nodesHash[this.id].proIntId);
								}else
								{
									proOptFlag.push("2");
									proIntIdArr.push(nodesHash[this.id].proIntId);
								}
							}
				/***************************end  拼产品的操作代码(0 无变化,1 增加,2 修改,3 删除)*********************/
				/**********************begin  拼产品属性的操作代码(0 无变化,1 增加,2 修改,3 删除)*****************/
							offerIntIdArr.push("0");//主产品的附加产品的销售品实例ID为0
							/*如果是产品没属性的话proAttrOptFlag拼什么也就无所谓了*/
							if($("#proAttr_"+this.id).val()==""||typeof($("#proAttr_"+this.id).val())=="undefined")//变化的属性串值为空
							{
										proAttrOptFlag.push("0"); //不变
							}else  //新的不为空
							{
									if($("#newFlag_"+this.id).val()=="1")
									{
										proAttrOptFlag.push("1");
									}else
									{
										proAttrOptFlag.push("2"); //有变化的属性，修改
									}
							}
					 /*****************************end    拼产品属性的操作代码 *********************************************/
					 /********************************begin  拼属性串***************************************************/
									tempAttr=$("#proAttr_"+this.id).val();
									if($("#proAttr_"+this.id).val()==""||typeof($("#proAttr_"+this.id).val())=="undefined")//产品没属性
									{
										tempAttr="M";
									}
									prodAttrValueArr=prodAttrValueArr+tempAttr+"@";//产品属性总串
						/********************************end  拼属性串****************************************************/
						/****************************begin  拼新的产品状态(A 正常  B 注销  C 暂停，用户要求停机)************/
								if($("#proName_"+this.id).text()=="正常"||$("#proName_"+this.id).text()=="新购")
								{
									newStatu.push("A");
								}else if($("#proName_"+this.id).text()=="退订")
								{
									newStatu.push("a");
								}else if($("#proName_"+this.id).text()=="暂停"||$("#proName_"+this.id).text()=="报停")
								{
									newStatu.push("G");
								}
		       /***************************end  拼新的产品状态(A 正常  B 注销  C 暂停，用户要求停机)***************/
					 /*************************************如果是产品节点************************************************/
					 
									productStatu.push(nodesHash[this.id].statu);
									if(proOptFlag[proOptFlag.length-1]=="0"&&proAttrOptFlag[proAttrOptFlag.length-1]=="0")
									{
										pordIdArr.push("mshow");
									}else
									{
										pordIdArr.push(this.id);
									}
									prodNameArr.push(nodesHash[this.id].getName());
									attrFlag.push("0");
									parentInstId.push("<%=offerSrvId%>");
									if(proOptFlag[proOptFlag.length-1]=="1")
									{
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
                                        if(findStrInArr(this.id,myArrs) && getRomaNum()>=2){
                                    			if(($(document.getElementById("stopDate_"+this.id)).val() < "<%=dateStr2%>")&&($(document.getElementById("stopDate_"+this.id)).val()!=$(document.getElementById("stopDateSave_"+this.id)).val().substring(0,8))){
                                    				rdShowMessageDialog("结束时间应大于当前时间,请重新输入!",0);
                                            (document.getElementById("stopDate_"+this.id)).select();
                                            vFlag = false;
                                            return false;
                                    			}
                                    		}else if(($(document.getElementById("stopDate_"+this.id)).val() <= "<%=dateStr2%>")&&($(document.getElementById("stopDate_"+this.id)).val()!=$(document.getElementById("stopDateSave_"+this.id)).val().substring(0,8))){
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


										//prodExpireDate.push("20500101000000");
										var effDate = "";
										var expDate = "";
										if($(document.getElementById("startDate_"+this.id)).val() == "<%=dateStr2%>"){
										    effDate = "<%=currTime%>";
										}else{

										    effDate = $(document.getElementById("startDate_"+this.id)).val() + "000000";
										}
										if(findStrInArr(this.id,myArrs) && $(document.getElementById("stopDate_"+this.id)).val() == "<%=dateStr2%>"){
												expDate = "<%=currTime%>";
										}else{
											expDate = $(document.getElementById("stopDate_"+this.id)).val() + "000000";
										}
										prodEffectDate.push(effDate);
										prodExpireDate.push(expDate);
									}else if(proOptFlag[proOptFlag.length-1]=="3")
									{
										prodEffectDate.push(document.getElementById("startDateSave_"+this.id).value);
						        prodExpireDate.push("<%=currTime%>");
									}else
									{
                                        if(compareDates((document.getElementById("startDate_"+this.id)),(document.getElementById("stopDate_"+this.id)))==-2){
                                            rdShowMessageDialog("结束时间格式不正确,请重新输入!",0);
                                            (document.getElementById("stopDate_"+this.id)).select();
                                            vFlag = false;
                                            return false;
                                        }

                                        if(findStrInArr(this.id,myArrs) && getRomaNum()>=2){
                                    			if(($(document.getElementById("stopDate_"+this.id)).val() < "<%=dateStr2%>")&&($(document.getElementById("stopDate_"+this.id)).val()!=$(document.getElementById("stopDateSave_"+this.id)).val().substring(0,8))){
                                    				rdShowMessageDialog("结束时间应大于当前时间,请重新输入!",0);
                                            (document.getElementById("stopDate_"+this.id)).select();
                                            vFlag = false;
                                            return false;
                                    			}
                                    		}else if(($(document.getElementById("stopDate_"+this.id)).val() <= "<%=dateStr2%>")&&($(document.getElementById("stopDate_"+this.id)).val()!=$(document.getElementById("stopDateSave_"+this.id)).val().substring(0,8))){
                                            rdShowMessageDialog("结束时间应大于当前时间,请重新输入!",0);
                                            (document.getElementById("stopDate_"+this.id)).select();
                                            vFlag = false;
                                            return false;
                                        }
                                        /* ningtn 增加对漫游类的开始时间结束时间校验 */
                                        if(findStrInArr(this.id,myArrs) && getRomaNum()>=2 && document.getElementById("startDate_"+this.id).value > "<%=dateStr2%>"){
	                                        if(compareDates((document.getElementById("startDate_"+this.id)),(document.getElementById("stopDate_"+this.id)))==1 || $(document.getElementById("startDate_"+this.id)).val()==$(document.getElementById("stopDate_"+this.id)).val()){
	                                            rdShowMessageDialog("开始时间应小于结束时间,请重新输入!",0);
	                                            (document.getElementById("stopDate_"+this.id)).select();
	                                            vFlag = false;
	                                            return false;
	                                        }
	                                      }
                                        if($(document.getElementById("startDate_"+this.id)).attr("class") != "InputGrey" && $(document.getElementById("startDate_"+this.id)).val() < "<%=dateStr2%>"){
                                            rdShowMessageDialog("开始时间应不小于当前时间,请重新输入!",0);
                                            (document.getElementById("startDate_"+this.id)).select();
                                            vFlag = false;
                                            return false;
                                        }

                                        if($(document.getElementById("startDate_"+this.id)).val() > "<%=addThreeMonth%>"&&document.getElementById("startFlag_"+this.id).value!="0"){
                        	                rdShowMessageDialog("开始时间必须是三个月内,请重新输入!",0);
                        	                (document.getElementById("startDate_"+this.id)).select();
                        	                vFlag = false;
                        	                return false;
                        	            }


                                        var effDate = "";
										var expDate = "";
									if(proOptFlag[proOptFlag.length-1]!=5){
										if($(document.getElementById("startDate_"+this.id)).val() == "<%=dateStr2%>"){
										    effDate = "<%=currTime%>";
										}else if($(document.getElementById("startDate_"+this.id)).val() > "<%=dateStr2%>"){
										   effDate =$(document.getElementById("startDate_"+this.id)).val()+"000000";
										}else{
											 effDate =$(document.getElementById("startDateSave_"+this.id)).val();
											}

									}else{
										effDate = $(document.getElementById("startDateSave_"+this.id)).val()+"#"+$(document.getElementById("startDate_"+this.id)).val()+"000000";
										}
										
										if(findStrInArr(this.id,myArrs) && $(document.getElementById("stopDate_"+this.id)).val() == "<%=dateStr2%>"){
												expDate = "<%=currTime%>";
										}else{
											expDate = $(document.getElementById("stopDate_"+this.id)).val() + "000000";
										}	
										prodEffectDate.push(effDate);
										prodExpireDate.push(expDate);
									}
									
									
									if(this.id == "1027"&&proOptFlag[proOptFlag.length-1]==1){
										var startTime1027 = $(document.getElementById("startDate_"+this.id)).val();
										var endTime1027 = $(document.getElementById("stopDate_"+this.id)).val();
										
										var monthmi = ifOver12Month(startTime1027,endTime1027);
										var enddays = startTime1027.substring(6,8);
										var enddaye = endTime1027.substring(6,8);
										
										//var dateAdd60 = DateAdd(startTime1027);
										//alert("endTime1027="+endTime1027+"---dateAdd60="+dateAdd60);
								//		if((monthmi ==12 && (Number(enddaye)>=Number(enddays))) || monthmi>12){
	  	              //  rdShowMessageDialog("国际漫游的结束时间不能超过开始时间1年！",0);
	  	              //  (document.getElementById("stopDate_"+this.id)).select();
	  	             //   vFlag = false;
	  	             //   return false;
	  	            //	}
									}/*国际漫游的时候 判断开始结束时间差不能超过60天*/
									
									isMainProduct.push(0);
									
									
									
				}
		})
		if(!vFlag){
				    return false;
				}
/*---------------------------------------------end对主产品附加产品树的解析拼串过程end------------------------------------------------*/

/*---------------------------------------------begin对产品树的解析拼串过程begin------------------------------------------------*/
		if(sureGG=="false")
			return false;
/*---------------------------------------------end对产品树的解析拼串过程end------------------------------------------------*/
		/* ningtn 校验漫游时间是否有重叠或者不连续 */
		var romaArrs = getRomaArr();
		if(romaArrs.length == 2){
			var startDates = new Array();
			var stopDates = new Array();
			/* 是否需要校验，0是不需要，1是需要 */
			var checkFlag = "1";
			$.each(romaArrs,function(i,n){
				startDates[i] = $("input[name='startDate_" + n + "']").val().substr(0,8);
				stopDates[i] = $("input[name='stopDate_" + n + "']").val().substr(0,8);
				if("退订" == $("#proName_"+n).text()){
					checkFlag = "0";
				}
			});
			
			if("1" == checkFlag 
				&& startDates[0] != stopDates[1] && startDates[1] != stopDates[0]){
					rdShowMessageDialog("漫游时间存在重叠或者不连续,请重新输入!",0);
					return false;
			}
		}
		$("input[name='adslPrint']").val(adslPrint);
		$("input[name='proOptFlag']").val(proOptFlag);
		$("input[name='proIntIdArr']").val(proIntIdArr);
		$("input[name='parentInstId']").val(parentInstId);
		$("input[name='offerIntIdArr']").val(offerIntIdArr);
		$("input[name='proAttrOptFlag']").val(proAttrOptFlag);
		$("input[name='prodAttrValueArr']").val(prodAttrValueArr);
		$("input[name='sonParentArr']").val(sonParentArr);
		$("input[name='attrFlag']").val(attrFlag);
		$("input[name='productIdArr']").val(pordIdArr);
		$("input[name='prodNameArr']").val(prodNameArr);
		$("input[name='prodEffectDate']").val(prodEffectDate);
		$("input[name='prodExpireDate']").val(prodExpireDate);
		$("input[name='isMainProduct']").val(isMainProduct);
		$("input[name='productStatu']").val(productStatu);
		$("input[name='offerStatu']").val(offerStatu);
		$("input[name='offerIdArr']").val(offerIdArr);
		$("input[name='offerEffectTime']").val(offerEffectTime);
		$("input[name='offerExpireTime']").val(offerExpireTime);
		$("input[name='newStatu']").val(newStatu);
		
		//alert("操作类型proOptFlag|"+$("input[name='proOptFlag']").val()+"\n"+"失效时间prodEffectDate|"+$("input[name='prodEffectDate']").val()+"\n"+"生效时间prodExpireDate|"+$("input[name='prodExpireDate']").val()+"\n"+"特服名称prodNameArr|"+$("input[name='prodNameArr']").val());
		document.frm.action="changeProduceConfirm.jsp";



		showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes");

				var cust_id='<%=cust_id%>';
				document.all.sys_note.value="用户"+cust_id+"特服变更";
				if($("#realOpCode").val() != "e904"){
					document.all.op_note.value="增["+document.all.addfuncinfo.value+"]-删["+document.all.delfuncinfo.value+"]";
				}
			 if(document.all.op_note.value.length >60){
					rdShowMessageDialog("您本次变更特服过多，重新选择特服");
					return false;
				}

		if(rdShowConfirmDialog("请确认是否进行产品变更？")==1)
			{
				//document.all.sys_note.value="用户"+cust_id+"特服变更";
				//document.all.op_note.value="A["+document.all.addfuncinfo.value+"]-D["+document.all.delfuncinfo.value+"]";
				document.frm.submit();
			}
	}

	function showPrtDlg(printType,DlgMessage,submitCfm)
  {
   var h=198;
   var w=350;
   var t=screen.availHeight/2-h/2;
   var l=screen.availWidth/2-w/2;
   var pType="subprint";
   var billType="1";
   var sysAccept = "<%=sysAcceptl%>";
   var phone_no = "<%=phone_no%>";
   var offerIdArr = $("input[name='productIdArr']").val().split(",");
   var offerIdV1 = "";
   for(var io=0;io<offerIdArr.length;io++){
   	if(offerIdArr[io]!="mshow")
   	offerIdV1 +=offerIdArr[io]+"|";
   	}
   var mode_code = null;
   var fav_code = offerIdV1;
   var area_code = null;
   var printStr = printInfo(printType);
		/* ningtn */
		var iccidInfoStr = $("#firstId").val() + "|" + $("#secondId").val();	
		var accInfoStr = $("#accInfoHid1").val() + "|" +$("#accInfoHid2").val()+ "|" +$("#accInfoHid3").val()+ "|" +$("#accInfoHid4").val();
		/* ningtn */
   var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
   var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_hw.jsp?DlgMsg=" + DlgMessage+ "&iccidInfo=" + iccidInfoStr + "&accInfoStr="+accInfoStr;
   var path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+sysAccept+"&phoneNo="+phone_no+"&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
   var ret=window.showModalDialog(path,printStr,prop);

   return ret;
  }

  function printInfo(printType)
  {
   var retInfo = "";
   var cust_info="";
	 var opr_info="";
	 var note_info1="";
	 var note_info2="";
	 var note_info3="";
	 var note_info4="";

    if(printType == "Detail")
    {	//打印电子免填单
    <%
    String currTimeFPrt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new Date());
    %>
		var currTime = "<%=currTime%>".substring(0,8);

    cust_info+="客户姓名：	"+"<%=custName%>"+"|";
    cust_info+="手机号码：	"+"<%=phone_no%>"+"|";
    cust_info+="证件号码：	"+"<%=idIccid%>"+"|";
    cust_info+="客户地址：	"+"<%=addr%>"+"|";

			opr_info+= opr_info+="业务受理时间："+"<%=currTimeFPrt%>"+"  用户品牌：<%=custPPv1%>"+"|";
			opr_info+="办理业务：产品变更 "+"  "+"操作流水："+"<%=sysAcceptl%>"+"|";
			opr_info+="|";

 			var tProOptFlagArr = 	$("input[name='proOptFlag']").val().split(",");		        //操作类型
 			var tProdNameArrArr = 	$("input[name='prodNameArr']").val().split(",");		    //特服名称
 			var tProdEffectDateArr = 	$("input[name='prodEffectDate']").val().split(",");		//生效时间
 			var tProdExpireDateArr = 	$("input[name='prodExpireDate']").val().split(",");		//失效时间

			var tempV1 = "";
			var tempV1n = "";

			var tempV1yn = "";
			var tempV1yt = "";

			var tempV2 = "";
			var tempV2n = "";
			var tempV2t = "";

			var tempV3 = "";
			var tempV3n = "";

			var tempV5 = "";
			var tempV5n = "";
			var tempV5t = "";


			var tempAddVn1 = "";
			var tempAddVt1 = "";


 			for(var i=0;i<tProOptFlagArr.length;i++){
					if(tProOptFlagArr[i]=="1"){
						if(tProdEffectDateArr[i].substring(0,8)==currTime){
							tempV1n+=tProdNameArrArr[i]+",";
						}else{
							tempV1yn+=tProdNameArrArr[i]+",";
							tempV1yt+=tProdEffectDateArr[i].substring(0,8)+",";
						}
					}
					if(tProOptFlagArr[i]=="2"){
						if(tProdEffectDateArr[i].substring(0,8)>currTime){
								tempAddVn1 += tProdNameArrArr[i]+",";
								tempAddVt1 += tProdEffectDateArr[i].substring(0,8)+",";
							}else{
								tempV2n+=tProdNameArrArr[i]+",";
								tempV2t+=tProdExpireDateArr[i].substring(0,8)+",";
							}
					}
					if(tProOptFlagArr[i]=="3"){
						tempV3n+=tProdNameArrArr[i]+",";
					}
					if(tProOptFlagArr[i]=="5"){
						tempV5n+=tProdNameArrArr[i]+",";
						tempV5t+=(tProdEffectDateArr[i].substring(tProdEffectDateArr[i].indexOf("#")+1,tProdEffectDateArr[i].length)).substring(0,8)+",";
					}
 				}


 			tempV1n = replaceStrDf(tempV1n);
 			tempV1yn = replaceStrDf(tempV1yn);
 			tempV5n = replaceStrDf(tempV5n);
 			tempV1yt = replaceStrDf(tempV1yt);
 			tempV5t = replaceStrDf(tempV5t);
 			tempV3n = replaceStrDf(tempV3n);
 			tempV2n = replaceStrDf(tempV2n);
 			tempV2t = replaceStrDf(tempV2t);

 			tempAddVt1 = replaceStrDf(tempAddVt1);
 			tempAddVn1 = replaceStrDf(tempAddVn1);


 			var tempV1d = "";
 			var tempV2d = "";
      if(tempV1n!=""&&tempV5n!="") tempV1d = ","; else tempV1d = "";
 			if(tempV1yt!=""&&tempV5t!="") tempV2d = ","; else tempV2d = "";


 			opr_info+="新增特服(24小时之内生效)："+tempV1n+"|";
 			if(tempV1n.indexOf("1027") != -1){
 				$("#complex_pro :checkbox").each(function(){
				if(this.id == "1027"){
						var startTime1027 = $(document.getElementById("startDate_"+this.id)).val();
						var endTime1027 = $(document.getElementById("stopDate_"+this.id)).val();
						if($("#select_"+this.id).find("option:selected").text()=="长期"){
							opr_info+="根据客户需求开通国际/港澳台漫游业务，有效期为长期|";
						}
						else{
							opr_info+="根据客户需求开通国际/港澳台漫游业务，有效期为"+startTime1027+"至"+endTime1027+"。"+"|";
						}
						
					}						
				});
 				
 			}

 			opr_info+="新增特服(预约生效)："+tempV1yn+tempV1d+tempV5n+tempAddVn1+"|";

 			opr_info+="生效时间："+tempV1yt+tempV2d+tempV5t+tempAddVt1+"|";

 			opr_info+="取消特服(24小时之内生效)："+tempV3n+"|";

 			opr_info+="取消特服(预约生效)："+tempV2n+"|";

 			opr_info+="生效时间："+tempV2t+"|";
 			//add by liubo op_note详细
 			document.all.addfuncinfo.value=tempV1n+tempV1yn+tempV1d+tempV5n+tempAddVn1;
 			document.all.delfuncinfo.value=tempV3n+tempV2n;

   	  note_info4+="备注： <%=workNo%>为客户<%=custName%>做产品变更 "+"|";
  }
      //4G项目要求修改免填单 hejwa add 2014年3月6日8:59:57
 //note_info4+=""+"|";
// note_info4+="4G试商用提示："+"|";
// note_info4+="1、中国移动4G业务需要TD-LTE制式终端支持，并更换支持4G功能的USIM卡、开通4G服务功能；"+"|";
// note_info4+="2、客户入网时选用或更换支持4G功能USIM卡时，将同时开通4G服务功能；"+"|";
// note_info4+="3、4G网速较快，办理高档位套餐可以享受更多的流量优惠；"+"|";
// note_info4+="4、4G业务仅在4G网络所覆盖的范围内提供，中国移动将不断扩大4G覆盖区域、提高服务质量。"+"|";
	retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
  retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
 	return retInfo;
}
function replaceStrDf(tranStr){
		var retStr = "";
		if(tranStr!=""){
				retStr=tranStr.substring(0,tranStr.length-1);
			}

		return 	retStr;
	}
function ignoreThis(){

		var packet1 = new AJAXPacket("ignoreThis.jsp","请稍后...");
		packet1.data.add("sOrderArrayId","<%=orderArrayId%>");
		core.ajax.sendPacket(packet1,doIgnoreThis,true);
		packet1 =null;
}

	function doIgnoreThis(packet){
		var errorCode = packet.data.findValueByName("retrunCode");
		var returnMsg = packet.data.findValueByName("returnMsg");
		if(errorCode == "0"){
				rdShowMessageDialog("忽略成功",2);
				goNext("<%=custOrderId%>","<%=custOrderNo%>","<%=prtFlag%>");
			}else{
				rdShowMessageDialog("忽略失败:"+returnMsg,0);
				}

		}
		
		



</script>

<body>
	<form  name="frm" action="" method="post">
	    <input type="hidden" name="adslPrint" />
		<input type="hidden" name="workNo" value="<%=workNo%>"/>
		<input type="hidden" name="phoneNo" value="<%=phone_no%>">
		<input type="hidden" name="mainProAttrCode" value="">
		<input type="hidden" name="offerDis" value="<%=offerDis%>"/>
		<input type="hidden" name="prtFlag" value="<%=prtFlag%>">
		<input type="hidden" name="orderArrayId" value="<%=orderArrayId%>">
		<input type="hidden" name="offerSrvId" value="<%=offerSrvId%>">
		<input type="hidden" name="closeId" value="<%=closeId%>">
		<input type="hidden" name="gCustId" value="<%=gCustId%>">
		<input type="hidden" name="offerid" value="<%=offerId%>">
		<input type="hidden" name="str" value="">
		<input type="hidden" name="sonParentArr"/>
		<input type="hidden" name="selNum" value="<%=phone_no%>">
		<input type="hidden" name="Band_Id" value="<%=Band_Id%>">
		<input type="hidden" name="custOrderId" value="<%=custOrderId%>"/>
		<input type="hidden" name="custOrderNo" value="<%=custOrderNo%>"/>
		<input type="hidden" name="servOrderId" value="<%=servOrderId%>"/>
		<input type="hidden" name="servBusiId" value="<%=servBusiId%>"/>
	  <input type="hidden" name="regionCode" value="<%=regionCode%>">
		<input type="hidden" name="opCode" value="<%=opCode%>">
		<input type="hidden" name="opName" value="<%=opName%>">

		<!--销售品信息-->
		<input type="hidden" name="offerIdArr"/>
		<input type="hidden" name="offerEffectTime"/>
		<input type="hidden" name="offerExpireTime"/>
		<input type="hidden" name="offerStatu"/>
		<input type="hidden" name="offerIntIdArr"/>
		<!--产品信息-->
		<input type="hidden" name="prodNameArr" />
		<input type="hidden" name="newStatu" />
		<input type="hidden" name="proOptFlag" />
		<input type="hidden" name="proAttrOptFlag" />
		<input type="hidden" name="productIdArr" />
		<input type="hidden" name="attrFlag" />
		<input type="hidden" name="prodEffectDate"/>
		<input type="hidden" name="prodExpireDate"/>
		<input type="hidden" name="isMainProduct"/>
		<input type="hidden" name="prodAttrIdArr"/>
		<input type="hidden" name="prodAttrValueArr"/>
		<input type="hidden" name="productStatu"/>
		<input type="hidden" name="proIntIdArr"/>
		<input type="hidden" name="parentInstId"/>

		<input type="hidden" name="sysAcceptl" id="sysAcceptl"  value="<%=sysAcceptl%>"/>

	  <input type="hidden" name="addfuncinfo"/>
		<input type="hidden" name="delfuncinfo"/>
    <input type="hidden" name="custPPv1" value="<%=custPPv1%>"/>
    <input type="hidden" name="realOpCode" id="realOpCode" value="<%=realOpCode%>"/>
		
		<%

		String stPMtotalPrepay    = retUserInfo.getValue("2.0.2.34");
		String stPMtype_name      = retUserInfo.getValue("2.0.2.15");  /*用户类型名称*/
		String stPMowner_type     = retUserInfo.getValue("2.0.2.14");  /*用户类型代码*/
		String stPMcard_name      = retUserInfo.getValue("2.0.2.21");  /*客户卡类型名称*/
		String stPMgrpbig_name    = retUserInfo.getValue("2.0.2.24");  /*集团客户名称*/

		if(stPMtotalPrepay.indexOf(".")!=-1){
		  		stPMtotalPrepay = stPMtotalPrepay+"00";
		  	}else{
		  		stPMtotalPrepay = stPMtotalPrepay+".00";
		  		}

		  	stPMtotalPrepay = stPMtotalPrepay.substring(0,stPMtotalPrepay.indexOf(".")+3);
		  String 	stPMtotalOwe       = retUserInfo.getValue("2.0.2.33");
		  	if(stPMtotalOwe.indexOf(".")!=-1){
		  		stPMtotalOwe = stPMtotalOwe+"00";
		  	}else{
		  		stPMtotalOwe = stPMtotalOwe+".00";
		  		}

		  	stPMtotalOwe = stPMtotalOwe.substring(0,stPMtotalOwe.indexOf(".")+3);
		%>

		<%@ include file="/npage/include/header.jsp" %>
        <div class="title">
            <div id="title_zi">客户基本信息【CV001】</div>
        </div>

				<table cellspacing=0>
				<tr> <td class="blue">大客户标志</td> <td><%=stPMcard_name%></td>   <td class="blue">集团标志</td> <td><%=stPMgrpbig_name%></td>   </tr>
<tr> <td class="blue">用户ID</td> <td><%=retUserInfo.getValue("2.0.2.1")%></td>   <td class="blue">客户名称</td> <td><%=retUserInfo.getValue("2.0.2.8")%></td>   </tr>

<tr> <td class="blue">当前状态</td> <td><%=retUserInfo.getValue("2.0.2.11")%></td>   <td class="blue">级别</td> <td><%=retUserInfo.getValue("2.0.2.13")%></td>   </tr>
<tr> <td class="blue">证件类型</td> <td><%=retUserInfo.getValue("2.0.2.18")%></td>   <td class="blue">证件号码</td> <td><%=retUserInfo.getValue("2.0.2.19")%></td>   </tr>
<tr> <td class="blue">当前预存</td> <td><%=stPMtotalPrepay%></td>   <td class="blue">当前欠费</td> <td><%=stPMtotalOwe%></td>   </tr>
				</table>
				<input type="hidden" id="bandType" name="bandType" value="<%=retUserInfo.getValue("2.0.2.6")%>">
</div>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">基本产品信息</div>
</div>

			<table cellspacing=0>
			<tr>
			<td class="blue" nowrap>产品标识</td>
			<td><%=Product_id%>
			</td>
			<td class="blue">产品名称</td>
			<td><%=proName%>
			</td>
			</tr>
			</table>
</div>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">基本产品属性</div>
</div>
<div id="attrlist"></div>

</div>
<div id="Operation_Table">

<div id="items">
<div class="item-col2 col-1">

<div class="title">
	<div id="title_zi">附属产品构成信息</div>
</div>
			<!--<div class="title"><div class="text">附属产品构成信息</div></div>-->
			<div id="complex_component"></div>
			<div id="rootTree1"><div id="complex_pro"></div></div>
<!--			<div class="title"><div class="text">可选产品构成信息：</div></div>
		  <div id="offer_component"></div>
		  <div id="div_offerComponent"></div>-->
</div>
<div class="item-row2 col-2">

<div class="title">
	<div id="title_zi">已定购产品信息</div>
</div>
	<div id="pro_component"></div>
</div>

</div>
<table id="leaderTab" style="display:none;">
	<tr>
		<td width="18%" class="blue">请求人</td>
		<td>
			<input type="text" id="leader" name="leader" maxlength="8" />
			<font class="orange">*</font>
		</td>
	</tr>
</table>
			<%@ include file="/npage/common/qcommon/bd_0007.jsp" %>	<!--sys_note op_note-->
<!-- ningtn 2011-8-3 09:41:57 扩大电子工单 -->
<jsp:include page="/npage/public/hwReadCustCard.jsp">
	<jsp:param name="hwAccept" value="<%=loginAccept%>"  />
	<jsp:param name="showBody" value="01"  />
</jsp:include>
		<div id="footer">
		<input type="button" class="b_foot" value="确定" onclick="next()"/>
    <INPUT type=button   class="b_foot" value="忽略" onclick="ignoreThis()">
		<!--
		<input type="button" class="b_foot" value="关闭" onclick="shutdown()"/>
		-->
		</div>
		<%@ include file="/npage/include/footer_new.jsp" %>
	</form>
</body>

<script language="javascript">

</script>
<!-- ningtn 2011-8-3 09:42:11 电子化工单扩大范围 -->
<%@ include file="/npage/public/hwObject.jsp" %> 
</html>
