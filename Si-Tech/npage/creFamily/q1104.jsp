 <%
	/**
	 * Title: 产品新装
	 * Description: 基本产品新装
	 * Copyright: Copyright (c) 2009/01/10
	 * Company: SI-TECH
	 * author：ranlf,zhengyha
	 * version 1.0 
	 */
%>
<%
	String opName = WtcUtil.repNull(request.getParameter("opName"));
	String opCode = WtcUtil.repNull(request.getParameter("opCode"));
%>
<%@ page contentType="text/html;charset=GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http//www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http//www.w3.org/1999/xhtml">
<%@ include file="/npage/include/public_title_name.jsp" %> 
<%@ include file="ignoreIn.jsp" %>
<%@ include file="/npage/common/qcommon/print_include1.jsp"%>
<%@ page import="com.sitech.boss.pub.util.CreatePlanerArray"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%

String passFlag = "";
boolean pwrf=false;
String tempStrf = "";


		 ArrayList arr = (ArrayList)session.getAttribute("allArr");
		 String[][] temfavStr=(String[][])arr.get(3);
		 int infoLen = temfavStr.length;
		    for(int i=0;i<infoLen;i++)
			{
			    tempStrf = (temfavStr[i][0]).trim();
			    if(tempStrf.trim().equals("aq01"))
			    {
			      	 pwrf = true;
			    }
			}
	
	if (pwrf)
	{
	 	passFlag="";
	}
	else
	{
		passFlag="none";
	}
	
	System.out.println("------------------passFlag---------------------"+passFlag);
	
    Calendar today =   Calendar.getInstance();  
    today.add(Calendar.MONTH,3);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");  
    String addThreeMonth = sdf.format(today.getTime());
    System.out.println("### addThreeMonth = "+addThreeMonth);
    
    String powerRight = WtcUtil.repNull((String)session.getAttribute("powerRight"));
    String workNo = (String)session.getAttribute("workNo");
    String password = (String)session.getAttribute("password");
    String workName = (String)session.getAttribute("workName");
    String orgCode = (String)session.getAttribute("orgCode");
    String strDistrictCode =orgCode.substring(2,4);
    String objectId=(String)session.getAttribute("groupId");
    String regionCode = orgCode.substring(0,2);
    String groupId = (String)session.getAttribute("groupId");
    System.out.println("---------------------groupId------------------------"+groupId);
    String num = WtcUtil.repNull(request.getParameter("num"));	
    System.out.println("---------------------num----------------------------"+num);
    String servBusiId = WtcUtil.repNull(request.getParameter("servBusiId"));	
    String custOrderId = WtcUtil.repNull(request.getParameter("custOrderId"));
    System.out.println("---------------servBusiId---------------------"+servBusiId);     
    System.out.println("---------------custOrderId---------------------"+custOrderId);     
    String custOrderNo=WtcUtil.repNull(request.getParameter("custOrderNo"));    
    String orderArrayId = WtcUtil.repNull(request.getParameter("orderArrayId"));
    String gCustId = WtcUtil.repNull(request.getParameter("gCustId"));
    String servOrderId = WtcUtil.repNull(request.getParameter("servOrderId"));
    String closeId = request.getParameter("closeId");
    String prtFlag = request.getParameter("prtFlag");
    
    String blindAddCombo = WtcUtil.repNull(request.getParameter("blindAddCombo"));
    
    String brandID = "";
		String brandName= "";
		String offerId = WtcUtil.repNull(request.getParameter("offerId"));
		String offerName	= WtcUtil.repNull(request.getParameter("offerName"));
		
		
		System.out.println("---------------orderArrayId---------------------"+orderArrayId);     
    System.out.println("---------------gCustId---------------------"+gCustId);
    System.out.println("---------------servOrderId---------------------"+servOrderId);     
    System.out.println("---------------closeId---------------------"+closeId);
    System.out.println("---------------prtFlag---------------------"+prtFlag);     
		System.out.println("---------------offerId---------------------"+offerId);     
		System.out.println("---------------offerName-------------------"+offerName);     
		
		String expDateOffset = "";
		String expDateOffsetUnit = "";
		String offerComments = "";
		String groupTypeId = "";
    
    String workFormId=orderArrayId;
		String svcInstId = WtcUtil.repNull(request.getParameter("offerSrvId"));
		System.out.println("---------------offerName-------------------"+offerName);     
		String branchNo="";

		String region_flag="sx";
		
		String offerName_h = "";
		
		String offerNameById = "select offer_name from product_offer where offer_id = '"+offerId+"'";
		
		/*分散账期 20121128 gaopeng 关于进行NGBOSS2-BOSS(V3.5)之分散帐期支撑分册实施的需求 start*/
		String fszqSqlStr = "select op_code from shighlogin where login_no='"+workNo+"' and op_code='FSZQ'";
		/*分散账期 20121128 gaopeng 关于进行NGBOSS2-BOSS(V3.5)之分散帐期支撑分册实施的需求 end*/
		
		String work_flow_no = WtcUtil.repNull(request.getParameter("work_flow_no"));
		String transJf      = WtcUtil.repNull(request.getParameter("transJf"));
    String transXyd     = WtcUtil.repNull(request.getParameter("transXyd"));
    String level4100    = WtcUtil.repNull(request.getParameter("level4100"));
    
    if(work_flow_no==null) work_flow_no = "";
    if(transJf==null) transJf = "";
    if(transXyd==null) transXyd = "";
    if(level4100==null) level4100 = "";
    
    System.out.println("mylog1---------------work_flow_no--------------"+work_flow_no);     
    System.out.println("mylog1---------------transJf-------------------"+transJf);     
    System.out.println("mylog1---------------transXyd------------------"+transXyd); 
    System.out.println("mylog1---------------level4100-----------------"+level4100); 
        
    /*ningtn 增加身份证开户数量限制*/
	
%>
			
		<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode2312" retmsg="retMsg2312" outnum="1">
			<wtc:sql><%=fszqSqlStr%></wtc:sql>
			</wtc:pubselect>
		<wtc:array id="resultFszq" scope="end" />
			
<!--查询地区标志-->

    <wtc:service name="sGetDetailCode" outnum="8" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
			<wtc:param value="<%=offerId%>" />
			<wtc:param value="<%=workNo%>" />	
			<wtc:param value="<%=opCode%>" />	
		</wtc:service>
		<wtc:array id="result_t33" scope="end"   />
			
<wtc:pubselect name="sPubSelect" outnum="1">
		<wtc:sql><%=offerNameById%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result22" scope="end"/>
	
<%

	if(result22.length>0&&result22[0][0]!=null){
		offerName_h= result22[0][0];
	}
	offerName = offerName_h;
%>	
<wtc:pubselect name="sPubSelect" outnum="1">
		<wtc:sql>select province_code from sProvinceCode where run_flag='Y'</wtc:sql>
</wtc:pubselect>
<wtc:array id="_region_flag">
	<%if(_region_flag[0][0].equals("089")){
					region_flag = "xj";
	}%>
</wtc:array>

<%
    String dateStr2 =  new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
    String sysDate_Good=dateStr2;
		String currTime = new SimpleDateFormat("yyyyMMdd HH:mm:ss", Locale.getDefault()).format(new Date());
		String userGroupId = "";
		String userGroupName = "";
		String sqlStr = "SELECT a.parent_group_id,b.group_name FROM  dChnGroupInfo a, dChnGroupMsg b WHERE a.group_Id ='"+groupId+"' AND a.parent_level=4 AND a.parent_group_id=b.group_id";
%>
<wtc:pubselect name="sPubSelect" outnum="2">
	<wtc:sql><%=sqlStr%></wtc:sql>
</wtc:pubselect>	
<wtc:array id="result1" scope="end"/>
<%
	if(retCode.equals("000000") && result1.length > 0){
		userGroupId = result1[0][0];
		userGroupName = result1[0][1];
	}
%>
<%String regionCode_sPMQPrdOffer = (String)session.getAttribute("regCode");%>
<wtc:utype name="sPMQPrdOffer" id="retVal" scope="end"  routerKey="region" routerValue="<%=regionCode_sPMQPrdOffer%>">	
	<wtc:uparam value="<%=offerId%>" type="LONG"/>
</wtc:utype>	
<%
	String errCode = String.valueOf(retVal.getValue(0));
	String errMsg = retVal.getValue(1);
	if(errCode.equals("0") && retVal.getUtype("2").getSize()>0){
		brandID = retVal.getValue("2.0");										
		brandName= retVal.getValue("2.1");	
		expDateOffset =	retVal.getValue("2.2");			
		expDateOffsetUnit = retVal.getValue("2.3");	
		offerComments = retVal.getValue("2.4").replaceAll("\\n"," ");	
		groupTypeId =	retVal.getValue("2.5");					
	}
	
	System.out.println("liubo groupTypeIdgroupTypeIdgroupTypeId==="+groupTypeId);
	
	String prodId = brandID;
%>
<%String regionCode_sQOrderGrp = (String)session.getAttribute("regCode");%>
<wtc:utype name="sQOrderGrp" id="retGrpVal" scope="end"  routerKey="region" routerValue="<%=regionCode_sQOrderGrp%>">	
	<wtc:uparam value="<%=custOrderId%>" type="STRING"/>
	<wtc:uparam value="<%=orderArrayId%>" type="STRING"/>
</wtc:utype>	
<%
	String returnCode = String.valueOf(retGrpVal.getValue(0));
	String returnMsg = retGrpVal.getValue(1);
	String groupIdStr = "";
	String groupNameStr = "";
	String groupType = "";
	String sqlStr1 = "select b.contract_no,c.bank_cust,d.type_name from dServOrderMsg a,dCustMsg b,dConMsg c,sAccountType  d where a.order_array_id='"+orderArrayId+"' and a.id_no = b.id_no and b.contract_no = c.contract_no AND c.account_type = d.account_type and a.service_no<>'0'";
	String contractInfo = "";
	if(returnCode.equals("0") && retGrpVal.getUtype("2").getSize()>0){
		for(int i=0;i<retGrpVal.getUtype("2").getSize();i++){
			groupIdStr = groupIdStr + retGrpVal.getValue("2."+i+".1")+",";
			groupNameStr = groupNameStr + retGrpVal.getValue("2."+i+".3")+",";
			if(retGrpVal.getValue("2."+i+".2").equals("180")){
				groupType = retGrpVal.getValue("2."+i+".2");
			}	
		}
	}
	
	if(groupType.equals("180")){
%>	
		<wtc:pubselect name="sPubSelect" outnum="3">
			<wtc:sql><%=sqlStr1%></wtc:sql>
		</wtc:pubselect>	
		<wtc:array id="result2" scope="end"/>
<%			
		if(retCode.equals("000000") && result2.length > 0){
			contractInfo = result2[0][0]+"~"+result2[0][1]+"~"+result2[0][2];
		}
	}
System.out.println("contractInfo=============================="+contractInfo);
System.out.println("hj=============================="+orderArrayId);
%>
<%String regionCode_sGetOrdAryData = (String)session.getAttribute("regCode");%>
<wtc:utype name="sGetOrdAryData" id="retOrdAryVal" scope="end"  routerKey="region" routerValue="<%=regionCode_sGetOrdAryData%>">	
	<wtc:uparam value="<%=orderArrayId%>" type="STRING"/>
</wtc:utype>	
<%
	 String strArray="var ordArray; ";
	 returnCode = String.valueOf(retOrdAryVal.getValue(0));
	 returnMsg = retGrpVal.getValue(1);
	 if(returnCode.equals("0") && retOrdAryVal.getUtype("2").getSize()>0){
	 	strArray = CreatePlanerArray.createArray("ordArray",retOrdAryVal.getUtype("2").getSize()); 
%>
			<SCRIPT language=JavaScript>
				<%=strArray%>	
			</script>	 
<%	 	
		for(int i=0;i<retOrdAryVal.getUtype("2").getSize();i++){
		 	for(int j=0;j<retOrdAryVal.getUtype("2."+i).getSize();j++){
%>
			<SCRIPT language=JavaScript>
				ordArray[<%=i%>][<%=j%>] = "<%=retOrdAryVal.getUtype("2."+i).getValue(j)%>";
			</script>	 
<%		 	
			}
		}	
	}
%>


<%
	String belongCode =orgCode.substring(0,7);
	String beginDate = new SimpleDateFormat("yyyyMMdd", Locale.getDefault()).format(new Date());
	String payCode = "0";
	String bankCode = "";
	String postCode = "";
	String accountType = "0";
	String endDate = "20501231";
	String accountNo = "0";

%>


<%
	String strCardSum="0";
	String strSql = "select card_sum from sInnetCard where region_code='"+regionCode+"' and district_code = '"+strDistrictCode+"' and op_code='"+opCode+"' and card_type='00' and sysdate between begin_time and end_time";
	System.out.println("strSql="+strSql);

	%>
	
	<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode2" retmsg="retMsg2" outnum="1">
	<wtc:sql><%=strSql%></wtc:sql>
	</wtc:pubselect>
	<wtc:array id="resultCard" scope="end" />
	
	<%
	System.out.println("resultCard="+resultCard);
	  if(!retCode2.equals("000000")){
%>
   <script language="javascript">
   	  rdShowMessageDialog("服务未能成功,服务代码:<%=retCode2%><br>服务信息:<%=retMsg2%>");
   	  parent.removeTab('<%=opCode%>');
	</script>
<%	
	}
		
  if (resultCard.length > 0){
		strCardSum = (resultCard[0][0]).trim();
		if(strCardSum.compareTo("") == 0){
			strCardSum = "0";
		}  
	}
%>
<wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>"  id="sysAcceptl" /> 
	
<%
System.out.println("-----------------------sysAcceptl---------------------------"+sysAcceptl);

%>	
<%
String cccTime=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date());
String sm_Code = "";
String smCodeSql = "SELECT  Sm_Code FROM Band where  Band_Id = "+brandID;
String custInfoSql = "SELECT cust_address, id_iccid  FROM dcustdoc where cust_id ="+gCustId;
System.out.println("smCodeSql|"+smCodeSql);
%>
		<wtc:pubselect name="sPubSelect" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=smCodeSql%></wtc:sql>
 	  </wtc:pubselect>
	 <wtc:array id="result_t1" scope="end"/>
	 	
	 	
	 	<wtc:pubselect name="sPubSelect" outnum="2" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=custInfoSql%></wtc:sql>
 	  </wtc:pubselect>
	 <wtc:array id="result_custInfo" scope="end"/>
	 	
	 	
<%	 	
if(result_t1.length>0&&result_t1[0][0]!=null)  sm_Code = result_t1[0][0];

String custIccid = "";
String custAddr = "";
if(result_custInfo.length>0){

	custAddr = result_custInfo[0][0];
	custIccid = result_custInfo[0][1];
}

String sqlOfferExpDate = "select exp_date_offset ,exp_date_offset_unit from product_offer where offer_id='"+offerId+"'";

%>
	 	<wtc:pubselect name="sPubSelect" outnum="2" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=sqlOfferExpDate%></wtc:sql>
 	  </wtc:pubselect>
	 <wtc:array id="result_ExpDateSet" scope="end"/>
	 	
	 	<%
	 		String offExpSet = "";
	 		String offExpSetUnit = "";
	 		
	 		if(result_ExpDateSet.length>0){
	 			offExpSet = result_ExpDateSet[0][0];
	 			offExpSetUnit = result_ExpDateSet[0][1];
	 		}
	 		System.out.println("---------offExpSet--------------------"+offExpSet);
	 		System.out.println("---------offExpSetUnit----------------"+offExpSetUnit);
	 		String offExpDate = getExpDate(offExpSet,offExpSetUnit);
	 		System.out.println("---------offExpDate----------------"+offExpDate);
	 	%>
<%!
		String getExpDate(String offExpSet,String offExpSetUnit){
		String retExpDate = "";
		java.text.SimpleDateFormat formatter=new java.text.SimpleDateFormat("yyyyMMddHHmmss");
		java.text.SimpleDateFormat formatter1=new java.text.SimpleDateFormat("yyyyMMdd");   
		java.util.Calendar lastDate = java.util.Calendar.getInstance();   
		int offExpSetv = Integer.parseInt(offExpSet);
		if(offExpSetUnit.equals("6")){ 
			     lastDate.set(java.util.Calendar.DATE,1); 
		       lastDate.add(java.util.Calendar.MONTH,offExpSetv);
		       retExpDate=formatter.format(lastDate.getTime()); 
		}else if(offExpSetUnit.equals("1")){ 
		       lastDate.add(java.util.Calendar.DATE,(offExpSetv)); 
		       retExpDate=formatter.format(lastDate.getTime()); 
		}else if(offExpSetUnit.equals("2")){ 
		       lastDate.add(java.util.Calendar.YEAR,offExpSetv); 
		       retExpDate=formatter.format(lastDate.getTime()); 
		}else if(offExpSetUnit.equals("0")){ 
			     lastDate.add(java.util.Calendar.MONTH,(offExpSetv)); 
		       retExpDate=formatter.format(lastDate.getTime()); 
		}else if(offExpSetUnit.equals("7")){ 
			     lastDate.set(java.util.Calendar.DATE,1); 
			     lastDate.set(java.util.Calendar.MONTH,0); 
			     lastDate.set(java.util.Calendar.YEAR,2000); 
			     lastDate.add(java.util.Calendar.MONTH,offExpSetv);
		       retExpDate=formatter.format(lastDate.getTime()); 
		}else if(offExpSetUnit.equals("3")){ 
			     lastDate.add(java.util.Calendar.MONTH,(offExpSetv*6)); 
		       retExpDate=formatter.format(lastDate.getTime()); 
		}else if(offExpSetUnit.equals("4")){ 
			     lastDate.add(java.util.Calendar.MONTH,(offExpSetv*3)); 
		       retExpDate=formatter.format(lastDate.getTime()); 
		}else if(offExpSetUnit.equals("5")){ 
			     lastDate.add(java.util.Calendar.DATE,(offExpSetv+1)); 
		       retExpDate=formatter1.format(lastDate.getTime())+"000000";   
		}else{
			retExpDate = "20501231235959";
		}
		return retExpDate;
	}
%>	 	
<HTML><HEAD><TITLE><%=brandID%>-<%=brandName%></TITLE>

<!--这段css样式是用来设置切换标签的样式,,,如果有更好的切换标签来替换,,,请删除这段样式,不影响页面其他内容-->
	<style type="text/css">
 .but_set {
	background: url(../images_sx/icon_but.png) no-repeat right -41px;
	margin: 0px 5px;
	padding: 0px;
	height: 16px;
	cursor: pointer;
	float:left;
}
.but_set span {
	padding: 0px 5px 0px 20px;
	margin: 0px;
	white-space: nowrap;
	height: 16px;
	float:left;
	line-height:normal;
	color: #ffaa55;
	background: url(../images_sx/icon_but.png) no-repeat left -1px;
}

.text_long {
  overflow: hidden;
	white-space: nowrap;
  display: block;
	width: 100px;
  -o-text-overflow: ellipsis;
  text-overflow: ellipsis;
}	 
.but_set_on {
	border: none;
	background: url(../images_sx/icon_but.png) no-repeat right -60px;
	margin: 0px 5px;
	padding: 0px;
	height: 16px;
	width: auto;
	cursor: pointer;
	float:left;
}
.but_set_on span {
	padding: 0px 5px 0px 20px;
	margin: 0px;
	white-space: nowrap;
	height: 16px;
	float:left;
	line-height:normal;
	color: #1367ba;
	background: url(../images_sx/icon_but.png) no-repeat left -20px;
}
    body {
      margin:0;
      padding:0;
      font:  12px/1.5em Verdana;
    }
		
    #tabsJ {
      float:left;
      width:100%;
      background:#f6f6f6;
      font-size:93%;
      line-height:normal;
    }
    #tabsJ ul {
      margin:0;
      padding:10px 10px 0 5px;
      list-style:none;
    }
    #tabsJ li {
      display:inline;
      margin:0;
      padding:0;
    }
    #tabsJ a {
      float:left;
      background:url("/nresources/default/images/tableftJ.gif") no-repeat left top;
      margin:0;
      padding:0 0 0 5px;
      text-decoration:none;
      cursor:hand;
    }
    #tabsJ a span {
      float:left;
      display:block;
      background:url("/nresources/default/images/tabrightJ.gif") no-repeat right top;
      padding:5px 15px 4px 6px;
      color:#24618E;
    }
    /* Commented Backslash Hack hides rule from IE5-Mac \*/
    #tabsJ a span {
    	float:none;
    }
    /* End IE5-Mac hack */
    #tabsJ a:hover span {
      color:#FFF;
    }
    #tabsJ a:hover {
      background-position:0% -42px;
    }
    #tabsJ a:hover span {
      background-position:100% -42px;
    }

    #tabsJ .current a {
      background-position:0% -42px;
    }
    #tabsJ .current a span {
			font: bold;
      background-position:100% -42px;
      color:#FFF;
    }
	</style>
	
<META http-equiv=Content-Type content="text/html; charset=gb2312">

<script type="text/javascript" src="<%=request.getContextPath()%>/njs/product/autocomplete_ms.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/product/product.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/si/validate_class.js"></script>
<script type="text/javascript" src="/npage/public/checkGroup.js" ></script>
<!-- 销售品明细项样式 -->
<SCRIPT language=JavaScript>
//tab页方法
var objectId="<%=objectId%>";//选号用
var branchNo=""; //选号用
var svcId = "1"; //服务id 选号用
var srcNum = "<%=num%>";	  //资源数量 选号用
var prodId = "";	//选号用
var vasProds = "<%=prodId%>"+"~"; //选号用
var masterServId = "";
var releaseNumFlag = true;		//是否释放号码标识

var offerId = "<%=offerId%>";	//销售品ID
var offerNodes;
var nodesHash = new Object(); //根据ID取销售品 产品节点
var groupHash = new Object(); //销售品Id=群组信息用于群组信息查看回显
var offerGroupHash = new Object(); //销售品Id=群组信息提交报文
var AttributeHash = new Object(); //销售品/产品Id=属性信息
var prodCompIdArray = [];									//附加产品构成信息

//-----各品牌主体服务类型说明-----
var CDMATypeId = "0";
var GUTypeId = "1";
var ADSLTypeId = "2";
var VPNTypeId = "10";
var NetElementTypeId = "5";
//---主体服务ID----
var MSID_CM = 8006;
var MSID_IDC = 8008;
var MSID_oneNum = 8009;
//-----销售品,产品类型说明----
var prodType = "O";
var majorProdType = "M";
var offerType = "10C";
var brandId_190 = "3";
var checkopenflag="0";
var isOfferLoaded = false;  //是否已经加载销售品构成明细

//-----销售品树选择方式---------
var selOfferType = "";
var ordArrayHash = new Object();
var xqdm = "";   //小区计费

//记录现有的四种漫游
var myArrs = new Array("1027","1026","1025","2042");

$(document).ready(function () {

		if(<%=resultFszq.length%>>0)
		{
			$("#fszqVal").show();
			$("#showandhide1").show();
		}


		if("<%=gCustId%>" == "0"){
			rdShowMessageDialog("客户ID异常,请联系管理员!");
			window.close();	
		}	
		if("<%=contractInfo%>" != ""){
			$("#btn_getConNo").attr("disabled",true);
			$("#contractNo").val("<%=contractInfo%>".split("~")[0]);
			$("input[name='contractName']").val("<%=contractInfo%>".split("~")[1]);
			$("input[name='contractType']").val("<%=contractInfo%>".split("~")[2]);
		}	
		
		if(typeof(ordArray) != "undefined"){
			for(var i=0;i<ordArray.length;i++){
				ordArrayHash[ordArray[i][1]] = ordArray[i][3];
				//alert("ordArray[i][1]|"+ordArray[i][1]+"\n"+"ordArray[i][3]|"+ordArray[i][3]);
				if(ordArray[i][1] == "20004"){
				 	selOfferType = ordArray[i][3];
				 	$("#innetType").val(selOfferType);
				}	
			}
			
			if(selOfferType == "03"){				//租机入网
				//$("#openType").html("<option value='03'>租机入网</option>");
				if(typeof(ordArrayHash["20005"]) != "undefined" && typeof(ordArrayHash["20006"]) != "undefined"){
					$("input[name='imeiNo']").val(ordArrayHash["20005"]);		
					$("input[name='saleMode']").val(ordArrayHash["20006"]);	
				}			
			}else if(selOfferType == "08"){				//副卡入网 weigp
				//alert("weigp add:"+selOfferType);
				//document.all.cardTypeN.options[1].selected = true;
				//$("#cardTypeN").attr("disabled",true);
				$("#simCode").attr("readonly",true);
				$("#simCode").removeClass("required"); 
				$("#cardTypeN").replaceWith("<div><input type='hidden' name='cardTypeN' value='1'/>是</div>"); 
				$("#sfgz1").css("display","none");
				$("#sfgz2").css("display","none");
				$("#sfzl").css("display","none");
				document.all.writecardbz.value="0";
				document.all.cardtype_bz.value="k";
				
				//$("#selNum").bind("blur",function(){alert("success");});
		  	}else if(selOfferType == "04"){		//靓号入网
				//$("#openType").html("<option value='04'>靓号入网</option>");
				if(typeof(ordArrayHash["20007"]) != "undefined" && typeof(ordArrayHash["20008"]) != "undefined"){
					//document.all.Good_PhoneDate_GSM.style.display = "";		
					$("input[name='selNum']").val(ordArrayHash["20007"]);	
					$("input[name='goodType']").val(ordArrayHash["20008"]);	
					document.all.selNum.readOnly=true;
					$("#serviceNoInfo :radio").attr("disabled",true);			//批量不可用
					//$("#tr_serviceNo :button:first").attr("disabled",true);		
				}
			}
			//else if(selOfferType == ""){
			//	rdShowMessageDialog("未取到销售品选择方式!");
				//window.close();	
			//}
		}
		else{
			rdShowMessageDialog("取销售品选择方式异常!");
			//window.close();		
		}
		
		if("<%=brandID%>" == "1012"){						//新疆需求
			$("#userpwd").val("123456");
			$("#userpwdcfm").val("123456");
		}
		
		//把组合产品中建的群组带到单一产品新装中
		if("<%=groupIdStr%>" != ""){
			$("#addGroupInfo").css("display","");
			var addGroupIdArray = "<%=groupIdStr%>".split(",");
			var addGroupNameArray = "<%=groupNameStr%>".split(",");
			for(var i=0;i<addGroupIdArray.length;i++){
				if(addGroupIdArray[i] != ""){
					$("#addGroupTd").append("<span><input type='checkbox' id='"+addGroupIdArray[i]+"' checked disabled >"+addGroupNameArray[i]+"</span>");
				}
				if($("#addGroupTd span").length%6 == 0){
					$("#addGroupTd").append("<br>");
				}
			}
		}
		
		$("#serviceNoInfo :radio").bind("click",choiceInputType);
		$("#orderInfoDiv").bind("click",getOrderInfo);
		$("#simCode").bind("change",function(){$("#cfmBtn").attr("disabled",true);});	//SIM卡变化时,确定按钮不可用
		$("#tr_contractNoType").css("display","none");
		
		if("<%=powerRight%>".trim() == "0"){		//权限为0时,不显示"不欠停"
			$("#controlType").html("<option value='B'>欠停</option>");
		}
		if("<%=groupTypeId%>" != "0"){
			$("#td_offerName").append("<input name='"+"<%=offerName%>"+"' type='button' onclick=\"showGroup('<%=offerId%>','<%=offerName%>','<%=groupTypeId%>')\"  value='群组' id='group_"+"<%=offerId%>"+"' _groupId='"+"<%=groupTypeId%>"+"' class='b_text but_groups' />");
			//$("#td_offerName :button[id^='group']").bind('click',showGroup);
		}
		
		if(typeof(offerId) != "undefined" && offerId != ""){
			$("#div_offerComponent").append("<div id='offer_"+offerId+"'></div>"); //生成销售品构成展示区域
			getMajorProd();
			//getOfferAttr();
			jdugeAreaHidden(offerId);//diling add for 判断是否显示新版小区代码@2013/3/14
			getOfferDetail();
  	  getOfferRel();
		}
		 
		if((typeof(document.all.vouch_idType)!="undefined")&&(typeof(document.all.vouch_idNo)!="undefined"))
		{	
			change_idType();			//还原到提交前的证件类型   
		}
		
		//$("#userName").val($("#custInfo td:eq(0)").text());				//继承客户信息
		//$("#contactCustName").val($("#custInfo td:eq(2)").text());
		
		$("#userGroupId").val("<%=userGroupId%>");					 		 
		 getMidPrompt("10442","<%=offerId%>","td_offerName");
		 
		/* ningtn 申告 */
		$("#contractNo").val("");

		Pz.busi.operBusi($('#tab_addprod input'),'groupTitle',true,3);
		
});


$(window).unload(function(){
	 if(releaseNumFlag){
			releaseNum();
		}
}); 

function GoodPhoneDateChg()
{
	if(document.all.GoodPhoneFlag.value == "Y")
	{
		//允许过户,默认可过户时间为系统时间且该时间可修改
		document.all.GoodPhoneDate.value = <%=sysDate_Good%>;
		document.all.GoodPhoneDate.disabled=false;
	}
	else
	{
		//不允许过户,默认可过户时间为固定时间且该时间不可修改
		document.all.GoodPhoneDate.value="20500101";
		document.all.GoodPhoneDate.disabled=true;
	}
}
	
function getMajorProd()
{
	 	var packet1 = new AJAXPacket("getMajorProd.jsp","请稍后...");
		packet1.data.add("offerId" ,offerId);
		core.ajax.sendPacketHtml(packet1,doGetMajorProd);
		packet1 =null;
}



function getOfferAttr()

{
    if(v_hiddenFlag=="Y"){ //当为Y时，进入新版小区代码展示页面
      var packet1 = new AJAXPacket("getOfferAttrNew.jsp","请稍后...");
      packet1.data.add("v_code" ,v_code);
      packet1.data.add("v_text" ,v_text);
    }else{
      var packet1 = new AJAXPacket("getOfferAttr.jsp","请稍后...");
    }
		packet1.data.add("OfferId" ,offerId);
		core.ajax.sendPacketHtml(packet1,doGetOfferAttr);
		packet1 =null;
}

function jdugeAreaHidden(offer_id){
  var packet = new AJAXPacket("ajax_jdugeAreaHidden.jsp","请稍后...");
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
    getOfferAttr();
	}else{
		rdShowMessageDialog(retCode + ":" + retMsg,0);
		getOfferAttr();
		//return false;
	}
}



function  getOfferDetail()
{
 		var packet = new AJAXPacket("offerDetailQry_new.jsp","正在加载附加销售品构成明细，请稍后...");
		packet.data.add("goodNo" ,document.all.selNum.value); 
		packet.data.add("offerId","<%=offerId%>"); 		
		packet.data.add("opCode","<%=opCode%>"); 		
		core.ajax.sendPacketHtml(packet,doGetHtml,false);
		packet =null;
}

//调整附加销售品时间
function setEffectTime()
{
	var addOfferId = this.id.substring(8);
	var effTime = nodesHash[addOfferId].begTime.substring(0,8);
	var expTime = nodesHash[addOfferId].expireTime.substring(0,8);
	if(this.value == 1){
		var spanType = "MM";
		var spanVal = 1;
		
		var newEffTime = setDateMove(effTime,spanType,spanVal,'yyyyMM')+"01";	//调整后的生效时间
		var newExpTime = setDateMove(expTime,spanType,spanVal,'yyyyMM')+"01";	//调整后的失效时间
		
		$("#effTime_"+addOfferId).text(newEffTime);
		$("#expTime_"+addOfferId).text(newExpTime);
		$("#effTime_"+addOfferId).attr("name",newEffTime+"000000");
		$("#expTime_"+addOfferId).attr("name",newExpTime+"000000");
	}else{
		$("#effTime_"+addOfferId).text(effTime);
		$("#expTime_"+addOfferId).text(expTime); 
		$("#effTime_"+addOfferId).attr("name",nodesHash[addOfferId].begTime);
		$("#expTime_"+addOfferId).attr("name",nodesHash[addOfferId].expireTime);
	}
}

function getOfferRel() 
{
	var packet2 = new AJAXPacket("getOfferRel.jsp","正在加载附加销售品构成依赖关系,请稍后...");
	packet2.data.add("offerId" ,offerId);
	core.ajax.sendPacketHtml(packet2,doGetOfferRel,false);
	packet2 =null;
}

function getMasterServType(majorProductId)
{
	var packet1 = new AJAXPacket("getMasterServType.jsp","请稍后...");
	packet1.data.add("majorProductId",majorProductId);
	core.ajax.sendPacket(packet1,doGetMasterServType);
	packet1 =null;
}

function  getProdAttr(majorProductId)
{
	var packet2 = new AJAXPacket("getProdAttr.jsp","请稍后...");
	packet2.data.add("majorProductId" ,majorProductId);
	core.ajax.sendPacketHtml(packet2,doGetpordAttribute);
	packet2 =null;
}

function getProdCompInfo(majorProductId)
{
	var packet3 = new AJAXPacket("getProdCompDet.jsp","请稍后...");
	packet3.data.add("goodNo" ,document.all.selNum.value); //caohq 20101206 需求 
	packet3.data.add("groupId" ,"<%=groupId%>");
	packet3.data.add("selOfferType",selOfferType);//weigp add 需求 
	packet3.data.add("majorProductId" ,majorProductId);
	packet3.data.add("offerId" ,offerId);
	core.ajax.sendPacket(packet3,doGetProdCompInfo);
	packet3 =null;
}

function getProdCompRel(majorProductId)
{
	var packet2 = new AJAXPacket("getProdCompRel.jsp","正在加载附属产品的依赖关系,请稍后...");
	packet2.data.add("majorProductId" ,majorProductId);
	core.ajax.sendPacketHtml(packet2,doGetProdCompRel);
	packet2 =null;
}

function  doGetProdCompRel(data)
{
	 $("#majorProdRel").html(data);
	 for(var i=0;i<prodCompIdArray.length;i++){
			initProdRel(prodCompIdArray[i]);
	 }	
}
//wanghyd2012/9/27 9:23增加如果选择销户找回开户，则调用一个服务进行校验身份证--start
function kaihfss() {
 var khtyspes = document.all.khType.value;
 var phonesno = document.all.selNum.value;
 var kehuids = document.all.contractNo.value;

	 if(khtyspes=="1") {
	  	 if(phonesno.trim()=="") {
 	      rdShowMessageDialog("请先输入服务号码！",0);
 	      document.all.khType.value="$$$$$$";
        document.all.selNum.focus();
        return ;
			 	 }
				var packet = new AJAXPacket("checkLastIDNO.jsp","请稍后...");
				packet.data.add("khtypes" ,khtyspes);
				packet.data.add("phonesno" ,phonesno);
				packet.data.add("kehuids" ,<%=gCustId%>);
				core.ajax.sendPacket(packet,getkaihuvalues);
				packet =null;
	 }
}
function getkaihuvalues(packet) {
	var error_code = packet.data.findValueByName("retcode");
	var error_msg =  packet.data.findValueByName("retmsg");
	if(error_code=="000000") {
	rdShowMessageDialog(error_msg,2);
	}else {
	rdShowMessageDialog(error_msg,0);
	}
}
//wanghyd2012/9/27 9:23增加如果选择销户找回开户，则调用一个服务进行校验身份证--end
function doGetMajorProd(data)
{
	  $("#offer_component").html(data);
	  
		var majorProductId = "";
		if(typeof(majorProductArr) != "undefined" && majorProductArr.length > 0)
		{
		 	majorProductId = majorProductArr[1];
		 	$("input[name='majorProductId']").val(majorProductArr[1]);
		 	
		  getMasterServType(majorProductId);
		  getProdAttr(majorProductId);
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

function setGdNumBindOfferIds(goodType){
	var packet = new AJAXPacket("getGdNumBindOfferIds.jsp","请稍后...");
	packet.data.add("goodType" ,goodType);
	core.ajax.sendPacket(packet,doSetGdNumBindOfferIds);
	packet =null;
}

var offerRoleID = "";
function doGetHtml(data)
{
	$("#offer_component").html(data);
	if(typeof(baseClass) != "undefined"){
		offerNodes = baseClass;
		showInfo(offerNodes);		//生成销售品构成展示
		
		for(var i=0;i<offerNodes.item.length;i++)
		  {
		  	if(offerNodes.item[i].getType() == "role"){
		  		offerRoleID+=offerNodes.item[i].getId()+"#";
				}
		  }	
		  
		trea("<%=blindAddCombo%>");
		initInfo(offerNodes);		//初始化构成,必选 可选 默认选中
		
		if(ordArrayHash["20004"] == "04"){
			setGdNumBindOfferIds(ordArrayHash["20008"]);	
		}
		
		$("#div_offerComponent :checkbox").bind("click",fn);
		$("#div_offerComponent :button[id^='att']").bind('click', showAttribute);
		$("#div_offerComponent select").bind('change',setEffectTime);
		
		setShowHid();
	}
}

function setShowHid(){    //销售品加载完成后 设置显示和隐藏
  
		var roleIdArray = offerRoleID.split("#");
		var tempEqtd1V = "";

		for(var i=0;i<roleIdArray.length;i++){
			tempEqtd1V = "";
			$("#tab_"+roleIdArray[i]+" :checkbox").each(function(){	//计算是否有选择
				 if(this.checked){
				 		tempEqtd1V = "1";
				 	}
		  });
		  
		  //roles_
		  if(roleIdArray[i]!=""){
					if(tempEqtd1V=="1"){
						 $("#"+roleIdArray[i]).attr("disabled",true);
						 $("#"+roleIdArray[i]).attr("checked",true);
						}else{
						$("#div_"+roleIdArray[i]).css("display","none");
						document.getElementById("chkbox_"+roleIdArray[i]).checked=false;		
					}
				}	
			
		}
	}
	

function doSetGdNumBindOfferIds(packet){
	var error_code = packet.data.findValueByName("errorCode");
	var error_msg =  packet.data.findValueByName("errorMsg");
	if(error_code == "000000"){
		var gdNumBindOfferIds =  packet.data.findValueByName("gdNumBindOfferIds");
		if(typeof(gdNumBindOfferIds) != "undefined" && gdNumBindOfferIds != ""){
			var offerIds = gdNumBindOfferIds.split("|");
			$.each(offerIds,function(i,n){
				if(typeof(n) != "undefined" && n != ""){
					$("#"+n).attr("checked",true);
					$("#"+n).attr("disabled",true);
					$("#expOffset_"+n).attr("disabled",false);
					$("#sel_"+n).attr("disabled",false);
					if(typeof(nodesHash[n]) != "undefined"){
						initInfo(nodesHash[n]);
					}else{
						rdShowMessageDialog("该靓号不能定购该销售品!");	
						window.close();
						return false;
					}	
				}	
			});
		}
		/*
		else{
			rdShowMessageDialog("未查询到该靓号绑定的销售品信息!");	
			window.close();
		}
		*/
	}
	else{
		rdShowMessageDialog("查询靓号绑定销售品信息失败!");
		window.close();
	}		
}


function choiceInputType(){
	if(this.value == 0){		//手工输入
		$("#frame_sub_1").contents().find(":input").attr("disabled",true);
		$("#tr_serviceNo :input").not(":radio").attr("disabled",false);
		$("#tr_serviceNo1 :input").not(":radio").attr("disabled",false);
		
		$("#cfmBtn").attr("disabled",true);
		$("#btn_batch").attr("disabled",true);
		$("#tr_contractNoType").css("display","none");
		$("input[name='resDetail']").attr("disabled",true);
		$("#btn_getConNo").attr("disabled",false);
		$("#contractNo").val("");
		
		
		document.all.simCode.readOnly=false;
		document.all.simCode.className="";
		
		document.all.selNum.readOnly=false;
		document.all.selNum.className="";
		
		chaCardType();
	}
	else if(this.value == 1){  //文件导入
		$("#frame_sub_1").contents().find(":input").attr("disabled",false);
		$("#tr_serviceNo :input").not(":radio").attr("disabled",true);
		$("#tr_serviceNo1 :input").not(":radio").attr("disabled",true);
		
		$("#tr_serviceNo :input").not(":button").val("");
		$("#tr_serviceNo1 :input").not(":button").val("");
		
		$("#cfmBtn").attr("disabled",true);
		$("input[name='resDetail']").attr("disabled",false);
		$("#btn_batch").attr("disabled",false);
		$("#tr_contractNoType").css("display","");
		$("#btn_getConNo").attr("disabled",true);
		$("#contractNo").val(0);
 		chaCardType();
				
	}else if(this.value == 3){										//独立账户
		$("#btn_getConNo").attr("disabled",true);
		$("#contractNo").val(0);
	}else if(this.value == 4){										//独立账户
		$("#btn_getConNo").attr("disabled",false);
		$("#contractNo").val("");
	}		
}

//根据主体服务类型加SIM卡号输入显示
function doGetMasterServType(packet)
{
	var error_code = packet.data.findValueByName("errorCode");
	var error_msg =  packet.data.findValueByName("errorMsg");
	var mastServerType = packet.data.findValueByName("mastServerType").trim();
	masterServId = packet.data.findValueByName("masterServId").trim();
	var serviceType = packet.data.findValueByName("serviceType").trim();

	if(error_code == "0"){
		if(typeof(mastServerType) != "undefined" && mastServerType != ""){
			if(mastServerType == CDMATypeId){		//如果CDMA的话，出现一个SIM号输入框,并隐藏地址信息
				$("#serviceNoInfo :hidden").not("#tr_contractNoType").css("display","");
				$("#frame_sub_1").contents().find(":input").attr("disabled",true);
				$("#th_simInfo,#td_simInfo").css("display","");
				
				$("#billModeCd").html("<option value='A'>后付费</option>");
				
				$("#cfmBtn").attr("disabled",true);
				$("#btn_batch").attr("disabled",true);
				$("#billDate").attr("readonly",true);	//计费开始时间
				
				$("#serviceOrderGroupId").html("<option value='0'></option>");
				$("#serviceOrderInfo").css("display","none");
			}
			if(mastServerType == VPNTypeId){
				getMemberId();
				
				$("#tr_serviceNo1 th").html("<span class='red'>*VPN号码：</span>");
			}
			if(masterServId == 8046 || masterServId == 8047 || masterServId == 8048 || masterServId == 8049 || masterServId == 8051){ //新疆需求	
				$("#serviceOrderGroupId").html("<option value='0'></option>");
				$("#serviceOrderInfo").css("display","none");
			}	
			
			prodId = mastServerType.trim();
			$("#mastServerType").val(mastServerType);
			$("#serviceType").val(serviceType);
		}
	}
	else{
		rdShowMessageDialog(error_msg);
	}		
}

function doGetOfferRel(data)
{
	$("#offer_component").html(data);
	
	isOfferLoaded = true;
}

function chkLimit1(id,iOprType)
{
	var retList="";
	var phoneNo="<%=svcInstId%>";
	var opCode="<%=opCode%>";
	var sendUrl = "limitChk1.jsp";
	var senddata={};
	senddata["opCode"] = opCode;
	senddata["prodId"] = id;
	senddata["iOprType"] = iOprType;
	senddata["vQtype"] = "0";
	senddata["idNo"] = "<%=svcInstId%>";
	
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


/*add by yanpx @ 2009-07-22 for 销售品限制*/
function chkLimit(id,iOprType)
{
	var retList="";
	var phoneNo="<%=svcInstId%>";
	var opCode="<%=opCode%>";
	var sendUrl = "limitChk.jsp";
	var senddata={};
	senddata["opCode"] = opCode;
	senddata["prodId"] = id;
	senddata["iOprType"] = iOprType;
	senddata["vQtype"] = "0";
	senddata["idNo"] = "<%=svcInstId%>";
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

/*end by yanpx @ 2009-07-22 for 销售品限制*/
function fn(){
  
	var retArr=chkLimit(this.id,"1").split("@");
	retCo=retArr[0].trim();
	retMg=retArr[1];
	if(retCo!="0" )
	{
						if(retCo=="110001"){
			     	 	if(rdShowConfirmDialog(retMg)!=1) 
			     	 			{
						     	 $("#"+this.id).attr('checked','check');
						     	 return false;
			     	 			}
						  	}else{
						  		rdShowMessageDialog(retMg);
						     	 $("#"+this.id).attr('checked','check');
						     	 return false;
						    }
	}
	
	try{
		var v_Id = "div_"+this.id;
		
		checkRel(this);
		
		if(this.checked == true){
			$("#"+v_Id).css("display","");
			$("#expOffset_"+this.id).attr("disabled",false);	//将失效时间偏移量输入框置为可用
			$("#sel_"+this.id).attr("disabled",false);
			initInfo(nodesHash[this.id]);
		}
		else{
			$("#"+v_Id).css("display","none");	
			$("#expOffset_"+this.id).attr("disabled",true);	//将失效时间偏移量输入框置为不可用
			$("#sel_"+this.id).attr("disabled",true);
			nodesHash[this.id].cancelChecked(nodesHash[this.id]);
			$("#orderTr_"+nodesHash[this.id].getId()).remove();
		}
		
		checkOrderTab();
 }
 catch(E){
 	  rdShowMessageDialog("正在加载销售品构成,请稍候....");
 	  $("#pro_detail_"+this.id).remove();
 	  return false;
 }

if(this.h_groupId!=0&&this.checked == true&&typeof(this.h_groupId)!="undefined"){
		showGroup(this.id,this.h_offerName,this.h_groupId);
	}
}

function checkOrderTab(){
	var hasTrHash = new Object();
	$("#orderInfo tr:gt(0)").each(function(){
		var v_id = this.id.substring(8);
		hasTrHash[v_id] = 1;
		if($("#"+v_id).attr("checked") != true){
			$(this).remove();	
		}
	});	
	
	$("#div_offerComponent :checked").each(function(){
		if(nodesHash[this.id].getType() == offerType && typeof(hasTrHash[this.id]) =="undefined" ){
			var node = nodesHash[this.id];
			$("#tab_order").append("<tr id='orderTr_"+node.getId()+"'><td>"+node.getId()+"</td><td>"+node.getName()+"</td><td>"+node.begTime.substring(0,8)+"</td><td>"+node.expireTime.substring(0,8)+"</td><td>"+node.description+"</td></tr>");
		}			
	});	
}


function g(o)
{
	return document.getElementById(o);
}

function HoverLi(n,t){
	
	if(n==1){
		document.all.changeSel.checked=true;
		document.all.changeSelh.checked=false;
		document.all.cfmOffer.style.display="none";
		}else{
			document.all.changeSel.checked=false;
		  document.all.changeSelh.checked=true;
			document.all.cfmOffer.style.display="";
			}
	for(var i=1;i<=t;i++)
	{
		g('tb_'+i).className='normaltab';
		g('tbc_0'+i).className='undis';
		g('tbc_0'+i).style.display="none"
		
	}
	g('tbc_0'+n).className='dis';
	g('tb_'+n).className='current';
	g('tbc_0'+n).style.display="block"
	
}	
//tab页方法

//展现销售品查询列表
function doQuery()
{
	var querycondition = document.all.text_xiaosp.value;
	if(querycondition == "")
	{
		rdShowMessageDialog("请输入查询条件！");
		document.all.text_xiaosp.focus();
		return false;
	}
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
  
  var packet = new AJAXPacket("complexPro_ajax.jsp","请稍后...");//组合产品子产品展示
	packet.data.add("nodeId" ,nodeId);
	packet.data.add("nodeName" ,nodeName);
	packet.data.add("etFlag",etFlag);
	core.ajax.sendPacketHtml(packet,doGetHtml2);
	packet =null;
	
	
}
function doGetHtml2(data){
    eval(data);
}

function doGetProdCompInfo(packet)
{
	var error_code = packet.data.findValueByName("errorCode");
	var error_msg =  packet.data.findValueByName("errorMsg");
	var prodCompInfo = packet.data.findValueByName("prodCompInfo");

	if(error_code == "0"){
		if(typeof(prodCompInfo) != "undefined"){
			$("#tab_addprod").css("display","");
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
			var selNum = $("#selNum").val();//取出号码
			var selNum3 = selNum.substring(0,3);//取出号码前3位
			for(var i=0;i<prodCompInfo.length;i++){
			    var tempStr = "";
			    if(i != 0){
			        tempStr = "&nbsp;";
			    }
				prodCompIdArray[i] = prodCompInfo[i][11];
				var relationType = prodCompInfo[i][9];
				// caohq 20101206 begin
				if((prodCompInfo[i][2].split(":")[0]) == "1025" || (prodCompInfo[i][2].split(":")[0]) == "1026" || (prodCompInfo[i][2].split(":")[0]) == "1027")
				{
					/* gaopeng 20120914  begin*/
					if(selNum3 == "157")
					{
						//relationType = "3";
						var packet33 = new AJAXPacket("/npage/bill/check157SuperTD.jsp","正在验证，请稍后。。。");
            packet33.data.add("phoneNo",document.prodCfm.selNum.value);
            core.ajax.sendPacket(packet33,doPro2);
            packet33 =null;
            
            if($("#flag").val() == "TD")
            {
         		relationType = "3";
         		$("#flag").val("true");
            }
						
					}
					/* gaopeng 20120914  end*/
					else if(selNum3 == "147")
					{
		                var packet = new AJAXPacket("/npage/bill/check147SuperTD.jsp","正在验证，请稍后。。。");
                        packet.data.add("phoneNo",document.prodCfm.selNum.value);
                        core.ajax.sendPacket(packet,doPro);
                        packet =null;
                        
                        if($("#flag").val() == "TD")
                        {
                     		relationType = "3";
                     		$("#flag").val("true");
                        }
                     }
				}else if((prodCompInfo[i][2].split(":")[0]) == "2042"){
					/* ningtn 如果是147 TD固话用户，只可以选择2042无漫游 */
					if(selNum3 == "147"){
							var packet = new AJAXPacket("/npage/bill/check147SuperTD.jsp","正在验证，请稍后。。。");
	            packet.data.add("phoneNo",document.prodCfm.selNum.value);
	            core.ajax.sendPacket(packet,doPro);
	            packet =null;
	            
	            if($("#flag").val() == "TD")
	            {
	         			relationType = "0";
	         			$("#flag").val("true");
	            }
					}
					/* gaopeng 20120914 如果是157 TD固话用户，只可以选择2042无漫游 */
					if(selNum3 == "157"){
							var packet = new AJAXPacket("/npage/bill/check157SuperTD.jsp","正在验证，请稍后。。。");
	            packet.data.add("phoneNo",document.prodCfm.selNum.value);
	            core.ajax.sendPacket(packet,doPro2);
	            packet =null;
	            if($("#flag").val() == "TD")
	            {
	            	
	         			relationType = "0";
	         			$("#flag").val("true");
	            }
					}
				}
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
function doPro(packet)
{
	var result = packet.data.findValueByName("result");
	if(result == "true")
	{
		$("#flag").val("TD");
		return ;
	}
}
function doPro2(packet)
{
	var result = packet.data.findValueByName("result");
	if(result == "true")
	{
		$("#flag").val("TD");
		return ;
	}
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
	 var retArr=chkLimit1(this.id,"1").split("@");
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

function doGetOfferAttr(data)
{
  if(v_hiddenFlag=="Y"){ //当为Y时，进入新版小区代码展示页面
    $("#OfferAttribute").append(data);
  }else{
    $("#OfferAttribute").html(data);
  }
	$("#OfferAttribute :input").not(":button").keyup(function stopSpe(){
			var b=this.value;
			if(/[^0-9a-zA-Z\.\@\u4E00-\u9FA5]/.test(b)) this.value=this.value.replace(/[^0-9a-zA-Z\u4E00-\u9FA5]/g,'');
	});
}

function doGetpordAttribute(data)
{
	$("#prodAttribute").html(data);
	
	$("#prodAttribute :input").not(":button").keyup(function stopSpe(){
			var b=this.value;
			if(/[^0-9a-zA-Z\.\@\u4E00-\u9FA5]/.test(b)) this.value=this.value.replace(/[^0-9a-zA-Z\u4E00-\u9FA5]/g,'');
	});
}

function showProdInfo(){
		$("#productInfo,#userinfo").css("display","block");
}

function doProcess(packet){
	var retType = packet.data.findValueByName("retType");
	if(retType.trim()=="releaseADSLNum")
	{
		var retCode = packet.data.findValueByName("retCode");
		if(retCode.trim()!="000000")
		{
			rdShowMessageDialog("号码释放失败,请与管理员联系！");
			return false;
		}
	}
	
	if(retType.trim()=="release3GNum")
	{
		var retCode = packet.data.findValueByName("errCode");
		if(retCode.trim()!="000000")
		{
			rdShowMessageDialog("号码释放失败,请与管理员联系！");
			return false;
		}
	}
	
	if(retType.trim()=="releaseGUNum")
	{
		var errCode_1 = packet.data.findValueByName("errCode_1");
		if(errCode_1.trim()!="000000")
		{
			rdShowMessageDialog("号码释放失败	,请与管理员联系！");
			return false;
		}
	}
}
function getContractNo()
{
    //得到帐户ID
  var getAccountId_Packet = new AJAXPacket("f1100_getId.jsp","正在获得帐户ID，请稍候......");
	getAccountId_Packet.data.add("region_code","<%=regionCode%>");
	getAccountId_Packet.data.add("retType","AccountId");
	getAccountId_Packet.data.add("idType","1");
	getAccountId_Packet.data.add("oldId","0");
	core.ajax.sendPacket(getAccountId_Packet,dogetContractNo);
	getAccountId_Packet = null;
}
 
function dogetContractNo(packet){
      var retCode = packet.data.findValueByName("retCode"); 
      var retMessage = packet.data.findValueByName("retMessage");	
		  var retnewId = packet.data.findValueByName("retnewId");
		  
     	if(retCode=="000000")
    	{
    	    var getAccountId_Packet = new AJAXPacket("ajaxContractNo.jsp","正在获得帐户ID，请稍候......");
					
					
					getAccountId_Packet.data.add("accountId",retnewId);
					getAccountId_Packet.data.add("gCustId","<%=gCustId%>");
					getAccountId_Packet.data.add("newPwd","111111");
					getAccountId_Packet.data.add("accountName",document.all.userName.value);
					getAccountId_Packet.data.add("belongCode","<%=belongCode%>");
					getAccountId_Packet.data.add("beginDate","<%=beginDate%>");
					getAccountId_Packet.data.add("payCode","<%=payCode%>");
					getAccountId_Packet.data.add("bankCode","<%=bankCode%>");
					getAccountId_Packet.data.add("postCode","<%=postCode%>");
					getAccountId_Packet.data.add("accountNo","<%=accountNo%>");
					getAccountId_Packet.data.add("accountType","<%=accountType%>"); 
					getAccountId_Packet.data.add("unitCode","<%=orgCode%>");
					getAccountId_Packet.data.add("endDate","<%=endDate%>");
					getAccountId_Packet.data.add("opCode","<%=opCode%>");
					
					core.ajax.sendPacket(getAccountId_Packet,doNewContractNo);
					getAccountId_Packet = null;
					
					document.all.btn_getConNo.disabled=true;
    	}
    	else{
    	    retMessage = retMessage + "[errorCode1:" + retCode + "]";
    			rdShowMessageDialog(retMessage,0);
					return false;
    	}	
    	
	}
	
function doNewContractNo(packet){
	var errorCode = packet.data.findValueByName("errorCode");
	var errorMsg = packet.data.findValueByName("errorMsg");
	var accountId = packet.data.findValueByName("accountId");
	if(errorCode.trim() == "0")
	{
		document.all.contractNo.value = accountId;
	}
	else{
		rdShowMessageDialog("账户开户失败！",0);
		return false;	
	}
} 

function doGetMemberId(packet){

		var errorCode = packet.data.findValueByName("errorCode");
		var errorMsg = packet.data.findValueByName("errorMsg");
		if(errorCode == "000000"){
			var memberId = packet.data.findValueByName("memberId");
			$("#IVPNMemberId").val(memberId);
		}
		else{
			rdShowMessageDialog("取VPN群组成员ID失败!");
			return false;
		}
}

function getMemberId(){
	var packet = new AJAXPacket("getMemberId.jsp","请稍后...");
	core.ajax.sendPacket(packet,doGetMemberId);
	packet = null;
}

function cfmOfferf(){
		if(g('tbc_01').style.display=="none") HoverLi(1,2); 
	}
	

/*2013/4/10 星期三 16:42:09 gaopeng 资源校验中判断用户办理的销售品品牌是不是物联网 如果是物联网，把输入的号码转换成205或206开头*/
function ajaxOrderCmtChk(){
	if(document.all.selNum.value == "")
    {
        rdShowMessageDialog("请输入服务号码！",0);
        document.all.selNum.focus();
        return ;
    }
    /*alert("<%=brandID%>");*/
    var giveliyana = document.all.selNum.value.trim();
    /*如果要开物联网*/
    if("<%=brandID%>"=="101"){
    if(giveliyana.substring(0,3)=="147")
    {
    //	giveliyana="206"+giveliyana.substring(3,giveliyana.length);
    }
    if(giveliyana.substring(0,5)=="10647")
    {
    	giveliyana="206"+giveliyana.substring(5,giveliyana.length);
    }
    if(giveliyana.substring(0,5)=="10648")
    {
    	giveliyana="205"+giveliyana.substring(5,giveliyana.length);
    }
  	}
   var myPacketsd = new AJAXPacket("ajaxWebOpen.jsp","正在验证是否是网上开户，请稍候......");
	myPacketsd.data.add("phoneNo",document.all.selNum.value);
	core.ajax.sendPacket(myPacketsd,checksimtypesd);
	myPacketsd=null;
	if(checkopenflag=="0") {
	   
 var  orderCmtChk_Packet = new AJAXPacket("ajaxOrderCmtChk.jsp","正在获得帐户ID，请稍候......");
			orderCmtChk_Packet.data.add("loginAccept","<%=sysAcceptl%>");
			orderCmtChk_Packet.data.add("offerId","<%=offerId%>");
			orderCmtChk_Packet.data.add("loginNo","<%=workNo%>");
			orderCmtChk_Packet.data.add("opCode","<%=opCode%>");
			//orderCmtChk_Packet.data.add("phoneNo",document.all.selNum.value);
			orderCmtChk_Packet.data.add("phoneNo",giveliyana);
			core.ajax.sendPacket(orderCmtChk_Packet,doAjaxOrderCmtChk);
			getAccountId_Packet = null;	
	}
	checkopenflag="0";
}

function doAjaxOrderCmtChk(packet){
	
	var retCodeFOrderCmtChk = "0";	
	var retMsgFOrderCmtChk = "";	

	retCodeFOrderCmtChk = packet.data.findValueByName("errorCode");
	retMsgFOrderCmtChk = packet.data.findValueByName("errorMsg");	
				if(retCodeFOrderCmtChk!="0"){
		    	rdShowMessageDialog(retCodeFOrderCmtChk+":"+retMsgFOrderCmtChk);
		 			document.all.cfmBtn.disabled=true;
		    }else{
					selectCheckSimNo();		    	
		    }	
}
  function checksimtypesd(packet) {
	var retCodeFOrderCmtChk = "0";	
	var retMsgFOrderCmtChk = "";	
	retCodeFOrderCmtChk = packet.data.findValueByName("errorCode");
	retMsgFOrderCmtChk = packet.data.findValueByName("errorMsg");	
				if(retCodeFOrderCmtChk!="0"){
		    	rdShowMessageDialog(retCodeFOrderCmtChk+":"+retMsgFOrderCmtChk);
		 			document.all.cfmBtn.disabled=true;
					checkopenflag="1";
		    }
 
 }

function setNoneRoma(romaArr,checkedFlag,disFlag){
		$.each(romaArr,function(i,n){
			if($("#" + n + "").length > 0){
				var romaName = $("#" + n + "").attr("name").substr(9);
				var romaAttr = $("#"+ n +"").attr("checked");
				if(checkedFlag){
					if(romaAttr != "true"){
						$("#"+ n +"").attr("checked","true");
						showDetailProd2(n,romaName,$("#"+ n +"")[0],1);
					}
				}else{
					if(romaAttr){
						$("#"+ n +"").removeAttr("checked");
						showDetailProd2(n,romaName,$("#"+ n +"")[0],1);
					}
				}
				if(disFlag){
					$("#"+ n +"").attr("disabled","true");
				}else{
					$("#"+ n +"").removeAttr("disabled");
				}
			}
		});
}

function mySub()
{
	if ( document.all.khType.value=="$$$$$$")
	{
		rdShowMessageDialog("开户类型必须选择" , 0);
		return false;	
	}
	
        getAfterPrompt();
    // ningtn 漫游改造 2013/4/11 星期四 8:41:35 gaopeng 加入物联网的判断，物联网没有这个限制
    if(getAllCheckedRomaBox() < 1&&"<%=brandID%>"!="1001"&&"<%=brandID%>"!="101"){
    	rdShowMessageDialog("必须选择一个漫游!");
			return false;
    }
    //提交前写卡判断 hejwa upd
    if((document.all.writecardbz.value!="0") && (document.all.cardtype_bz.value=="k")&&(document.all.cardTypeN.value=="1")){
 			rdShowMessageDialog("写卡未成功不能确认!");
 			return false;
 		}
		if(g('tbc_01').style.display=="none") HoverLi(1,2); 
		
		
	if(document.all.Good_PhoneDate_GSM.style.display == "")
	{
		if(document.all.GoodPhoneFlag.value != "Y" && document.all.GoodPhoneFlag.value != "N")
		{
			rdShowMessageDialog("请选择过户限制");
			document.all.GoodPhoneFlag.focus();
			return false;
		}
		else if(document.all.GoodPhoneFlag.value == "Y")
		{
			if((document.all.GoodPhoneDate.value).trim().length != 8)
			{
				rdShowMessageDialog("请按正确格式输入过户时间");
				document.all.GoodPhoneDate.focus();
				return false;
			}

	    var GoodPhoneDateChk = document.all.GoodPhoneDate.value;
	    var sysDate_GoodChk = <%=sysDate_Good%>;
	    if(GoodPhoneDateChk < sysDate_GoodChk)
	    {
        rdShowMessageDialog("过户时间不能小于当前系统时间");
        document.all.GoodPhoneDate.focus();
        return false;
	    }
		}
		
		document.all.isGPhoneFlag.value = document.all.GoodPhoneFlag.value;//记录特殊号码的过户条件
		document.all.isGPhoneDate.value = document.all.GoodPhoneDate.value;//记录过户号码的现在时间
		
	}
	
	
		if(document.all.pt_PhoneDate_GSM.style.display == "")  // 普通号码过户限制
		{
			if(document.all.ptPhoneFlag.value.trim()=="N"&&(document.all.ptPhoneDate.value).trim().length != 8)
			{
				rdShowMessageDialog("请按正确格式输入过户时间");
				document.all.ptPhoneDate.focus();
				return false;
			}
			
			if(document.all.ptPhoneFlag.value.trim()=="N"&&!forDate(document.all.ptPhoneDate)){
           	 	rdShowMessageDialog("过户时间输入格式不正确,请重新输入!");
            	document.all.ptPhoneDate.focus();
            	return false;
			}


	    var GoodPhoneDateChk = document.all.ptPhoneDate.value;
	    var sysDate_GoodChk = <%=sysDate_Good%>;
	    if(document.all.ptPhoneFlag.value.trim()=="N"&&GoodPhoneDateChk < sysDate_GoodChk)
	    {
        rdShowMessageDialog("过户时间不能小于当前系统时间");
        document.all.ptPhoneDate.focus();
        return false;
	    }
	    
	    document.all.isGPhoneFlag.value = document.all.ptPhoneFlag.value;//记录普通号码的过户条件
			document.all.isGPhoneDate.value = document.all.ptPhoneDate.value;//记录过户普通号码的限制时间
		
		}
		
		if(!checksubmit(prodCfm))
		{ 
			return false ;	
		}	
		if(!isOfferLoaded)
		{
			  rdShowMessageDialog("正在加载销售品构成!");
			  HoverLi(2,2);
			  return false;  
		}
		
		if($("#serviceType").val() == ""){
			rdShowMessageDialog("取服务类型出错!");
			return false;  
		}
		
		//if(!checkpwd1()) return false;			//密码校验
		
		
		<%if(!regionCode.equals("09")){%>
			if(checkPwd1(document.all.userpwd,document.all.userpwdcfm)==false)	return false;
		<%}%>
		
		if("<%=brandID%>" == brandId_190){
			if($("input[name='selNum']").val().trim().length < 11){
				rdShowMessageDialog("190业务的服务号码为固话带区号或手机号码!");
		 		return false;	
			}
		}	
		if("<%=brandID%>" == "1012"){						//新疆需求
			if($("#userpwd").val().trim().length != 8){
				rdShowMessageDialog("用户密码必须为8位!");
		 		return false;	
			}
		}
		if(!checkmin($('#tab_addprod input'),'groupTitle')){
			return false;
		}
	checkPwdEasy(document.all.userpwd.value);	//2010-8-9 8:43 wanghfa添加 验证密码过于简单
}

//2010-8-9 8:43 wanghfa添加 验证密码过于简单 start
function checkPwdEasy(pwd) {
	var checkPwd_Packet = new AJAXPacket("../public/pubCheckPwdEasy.jsp","正在验证密码是否过于简单，请稍候......");
	checkPwd_Packet.data.add("password", pwd);
	checkPwd_Packet.data.add("phoneNo", document.all.selNum.value);
	checkPwd_Packet.data.add("idNo", "");
	checkPwd_Packet.data.add("custId", "<%=gCustId%>");

	core.ajax.sendPacket(checkPwd_Packet, doCheckPwdEasy);
	checkPwd_Packet=null;
}

function doCheckPwdEasy(packet) {
	var retResult = packet.data.findValueByName("retResult");
	if (retResult == "1") {
		rdShowMessageDialog("尊敬的客户，您本次设置的密码为相同数字类密码，安全性较低，为了更好地保护您的信息安全，请您设置安全性更高的密码。");
		return;
	} else if (retResult == "2") {
		rdShowMessageDialog("尊敬的客户，您本次设置的密码为连号类密码，安全性较低，为了更好地保护您的信息安全，请您设置安全性更高的密码。");
		return;
	} else if (retResult == "3") {
		rdShowMessageDialog("尊敬的客户，您本次设置的密码为手机号码中的连续数字，安全性较低，为了更好地保护您的信息安全，请您设置安全性更高的密码。");
		return;
	} else if (retResult == "4") {
		rdShowMessageDialog("尊敬的客户，您本次设置的密码为证件中的连续数字，安全性较低，为了更好地保护您的信息安全，请您设置安全性更高的密码。");
		return;
	} else if (retResult == "0") {
		//判断带前缀的服务号码是否正确输入,v_fp为服务号码的前缀自定义属性
		if($("input[name='selNum']").attr("v_fp") != "" && $("input[name='selNum']").attr("v_fp") == $("input[name='selNum']").val()){
			rdShowMessageDialog("请正确输入服务号码!");
		  return false;  	
		}
		
		if(document.all.postName.value==""&&document.all.isPost.value=="0"){
				rdShowMessageDialog("请输入收件人!");
				document.all.postName.focus();
				return false;
			}
			
		$(":checkbox[name='contact_type']").each(function(){ //当未选择经办人,发展人,代理商等时,将它们的值都置空
			if(this.checked == false){
				$("#"+this.v_div+" input,#"+this.v_div+" select").each(function(){
					this.value = "";
				});
			}
		});
		
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
		
		var addGroupIdArr= [];
		//组合产品过来时,可选群组信息
		$("#addGroupInfo :checked").each(function(){
			addGroupIdArr.push(this.id);
		});
		//备注信息
		if($("input[name='op_note']").val() == ""){
			$("input[name='op_note']").val("操作员"+"<%=workNo%>"+"对客户"+"<%=gCustId%>"+"进行普通开户!");	
		}
		//压入基本销售品
		sonParentArr.push(offerId+"~"+"0");
		offerIdArr.push(offerId);
		offerEffectTime.push("<%=currTime%>");	//生失效时间还没确定
		offerExpireTime.push("<%=offExpDate%>");
		var mastServerType = $("#mastServerType").val();
		
		//压入基本销售品的群组信息
		if(mastServerType == VPNTypeId){
			var checkedOfferNum = 0;
			var checkedOfferId = "";
			if($("#group_"+offerId).attr("class") == "b_text but_groups"){
				rdShowMessageDialog("请设定基本销售品群组信息!");
			  return false; 	
			}
			$("#div_offerComponent :checked").each(function(){
				if(this.name.substring(0,4)=="offe"){
					checkedOfferNum++;
					checkedOfferId = this.id;
				}				
			});		
			if(checkedOfferNum == 0){					//IVPN下附加销售必选一个										
				rdShowMessageDialog("请选择附加销售品!");
			  return false; 	
			}
			if($("#group_"+checkedOfferId).attr("class") == "b_text but_groups"){
				rdShowMessageDialog("请设定"+nodesHash[checkedOfferId].getName()+"的群组信息!");
			  return false; 	
			}
			if(typeof(offerGroupHash[offerId]) != "undefined"){
				var addOfferInfo = offerGroupHash[checkedOfferId].split("|")[1];
				var addGroupId = addOfferInfo.split("$")[0];
				var VPNInfo = $("#IVPNMemberId").val()+"$0$0$2$70005$"+"<%=currTime%>"+"$20500101$0$"+addGroupId+"$";
				groupInstBaseInfo = groupInstBaseInfo + offerGroupHash[offerId]+VPNInfo+"^";
			}	
		}
		else{
			if(typeof(offerGroupHash[offerId]) != "undefined"){
				groupInstBaseInfo = groupInstBaseInfo + offerGroupHash[offerId]+"^";
			}	
		}
		
		//---------生成基本销售品属性信息----------
		var offerAttrStr = "";			//销售品属性串
		$("#OfferAttribute :input").not(":button,[type='hidden']").each(function(){
				offerAttrStr+=this.name.substring(2);
				offerAttrStr+="~";
				offerAttrStr+=$(this).val()+" $";
		});
		if(offerAttrStr != ""){
			offer_productAttrInfo += offerId+"|"+offerAttrStr+"^";
		}
		
		$("input[name='offerAttrStr']").val(offerAttrStr);
		
		var attrAry = offerAttrStr.split("\\$");	
		for(var i=0;i<attrAry.length;i++){
					var attrAry1= attrAry[i].split("~");	
					var attrId = attrAry1[0];
					var attrValue = attrAry1[1];
					if(attrId=="60001")
					{
						xqdm=attrValue.replace("$","").trim();
					}
	  }
		
		//alert("xqdm|"+xqdm);
		//---------生成主产品属性信息----------
		var productAttrStr = "";			//产品属性串
		
		$("#prodAttribute :input").not(":button,[type='hidden']").each(function(){
				productAttrStr+=this.name.substring(2);
				productAttrStr+="~";
				productAttrStr+=$(this).val()+" $";
		});
		
		if(productAttrStr != ""){
			offer_productAttrInfo += majorProductArr[1]+"|"+productAttrStr+"^";
		}
		$("input[name='productAttrStr']").val(productAttrStr);
		
	    var vFlag = true;
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
				prodEffectDate.push($("#effTime_"+nodesHash[this.id].parentOffer).attr("name"));
				prodExpireDate.push($("#expTime_"+nodesHash[this.id].parentOffer).attr("name"));
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
		
//		if(offerIdArr.length == 1){
//			if(rdShowConfirmDialog("您还未选择附加销售品,是否选择？") == 1){
//				HoverLi(2,2)
//				return false ;		
//			}
//		} 
		$("input[name='offer_productAttrInfo']").val(offer_productAttrInfo);
		$("input[name='sonParentArr']").val(sonParentArr);
		$("input[name='addGroupIdArr']").val(addGroupIdArr);	
		
		$("input[name='productIdArr']").val(pordIdArr);
		$("input[name='prodEffectDate']").val(prodEffectDate);
		$("input[name='prodExpireDate']").val(prodExpireDate);
		$("input[name='isMainProduct']").val(isMainProduct);
		//alert("offerIdArr|"+offerIdArr);
		$("input[name='offerIdArr']").val(offerIdArr);
		$("input[name='offerEffectTime']").val(offerEffectTime);
		$("input[name='offerExpireTime']").val(offerExpireTime);
		$("input[name='groupInstBaseInfo']").val(groupInstBaseInfo);
		
		$("input[name='sys_note']").val("<%=workNo%>"+"对"+"<%=gCustId%>"+"进行了"+"<%=offerName%>"+"新装!");
		$("#cfmBtn").attr("disabled",true);
		
		
		var path = showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes");
		rdShowMessageDialog("开户业务免填单打印移至统一缴费后打印！");
		if(rdShowConfirmDialog("请确认是否进行产品新装？")==1)
			{	
				conf(path);
			}else{
					$("#cfmBtn").attr("disabled",false);			
			}
	}
}


function conf(path){
	 	document.all.simCodeCfm.value = document.all.simCode.value;
	 	document.all.path.value = path;
		document.prodCfm.action="confm_new.jsp";
		document.prodCfm.submit();
	}
var retResultStr = "";
var retResultStr1 = "";
  function showPrtDlg(printType,DlgMessage,submitCfm)
  {   
   var h=198;
   var w=350;
   var t=screen.availHeight/2-h/2;
   var l=screen.availWidth/2-w/2;
   var pType="subprint";
   var billType="1";
   var sysAccept = "<%=sysAcceptl%>";
   var phone_no	= $("input[name='selNum']").val();
   
   var mode_code = document.all.offerIdArr.value;
   mode_code = mode_code.replace(/,/ig,"~");
   
   
   var fav_code = null;
   var area_code = null;
   var printStr = printInfo(printType);
		/* ningtn */
		var iccidInfoStr = $("#firstId").val() + "|" + $("#secondId").val();	
		var accInfoStr = $("#accInfoHid1").val() + "|" +$("#accInfoHid2").val()+ "|" +$("#accInfoHid3").val()+ "|" +$("#accInfoHid4").val();
		iccidInfoStr = iccidInfoStr.replace(/\\/g,"|xg|");
		accInfoStr = accInfoStr.replace(/\\/g,"|xg|");
		/* ningtn */
   var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no"; 
   var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_hw.jsp?DlgMsg=" + DlgMessage+ "&iccidInfo=" + iccidInfoStr + "&accInfoStr="+accInfoStr;  /** handwrite 工单电子化改造，指向新打印页 **/
   var path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+sysAccept+"&phoneNo="+phone_no+"&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
   //var ret=window.showModalDialog(path,printStr,prop);
   return path;

  }
  /***其他函数中要用到的过滤函数**/
function codeChg(s)
{
  var str = s.replace(/%/g, "%25").replace(/\+/g, "%2B").replace(/\s/g, "+"); // % + \s
  str = str.replace(/-/g, "%2D").replace(/\*/g, "%2A").replace(/\//g, "%2F"); // - * /
  str = str.replace(/\&/g, "%26").replace(/!/g, "%21").replace(/\=/g, "%3D"); // & ! =
  str = str.replace(/\?/g, "%3F").replace(/:/g, "%3A").replace(/\|/g, "%7C"); // ? : |
  str = str.replace(/\,/g, "%2C").replace(/\./g, "%2E").replace(/#/g, "%23"); // , . #
  return str;
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
	 
		
    cust_info+="客户姓名：	"+document.all.custNameforsQ046.value+"|";
    cust_info+="手机号码：	"+$("input[name='selNum']").val().trim()+"|";
    cust_info+="证件号码：	"+"<%=custIccid%>"+"|";
    cust_info+="客户地址：	"+"<%=custAddr%>"+"|";
		
		var cTime = "<%=cccTime%>";
		
		if(document.all.newSmCode.value=="dn")
		{
			opr_info+="业务受理时间："+cTime+"  "+"用户品牌:"+"动感地带"+"|";
		}else if(document.all.newSmCode.value=="gn"){
			opr_info+="业务受理时间："+cTime+"  "+"用户品牌:"+"全球通"+"|";
		}else if(document.all.newSmCode.value=="zn"){
			opr_info+="业务受理时间："+cTime+"  "+"用户品牌:"+"神州行"+"|";
		}else if(document.all.newSmCode.value=="TE"){
			opr_info+="业务受理时间："+cTime+"  "+"用户品牌:"+"铁通e固话"+"|";
		}
		
		 

		if((document.all.modedxpay.value).trim().length!=0){
			opr_info+="办理业务：普通开户"+"  "+"操作流水："+document.all.sysAcceptl.value+"   底线消费金额"+document.all.modedxpay.value+"元"+"|";
		}else{
			opr_info+="办理业务：普通开户"+"  "+"操作流水："+document.all.sysAcceptl.value+"|";
		}
		
		opr_info+= "SIM卡号："+document.all.simCode.value+" SIM卡费: SIMCARDFEE |";
		opr_info+= "预存款： PREMONEY 元"+"|";
		opr_info+="主资费："+"<%=offerId%>  <%=offerName %>"+"  生效时间：<%=dateStr2 %>  "+"|"; 
		
	  ajaxGetEPf('<%=offerId%>',xqdm);
		

		
		<%	
		String descStr = "";
		for(int hhh=0;hhh<result_t33.length;hhh++){
			descStr = result_t33[hhh][7];
			%>
		  if(document.all.dECode.value!="") {
			     opr_info+="  主资费二次批价："+document.all.dECode.value+"|";
	  	}else{
			     opr_info+="  主资费二次批价：<%=result_t33[hhh][2]%>|";
			 }
			<%
		}
		%>

		var tempNote_info2 = "";
		var tempArray1 = document.all.offerIdArr.value.split(",");
		var aaa = "";
		opr_info+="可选资费：";
		var tempDescById = "";
		
		for(var h=1;h<tempArray1.length;h++){
			if(tempArray1[h]!=""&&tempArray1[h]!="undefined")
			var node = nodesHash[tempArray1[h]];
			if(node!=""&&node!="undefined"){
				tempDescById = tempDescById+node.getId()+"|";
				if("<%=dateStr2%>"==node.begTime.substring(0,8)){		  		
						tempNote_info2+="("+node.getId()+"、"+node.getName()+"、24小时生效)";			
				}else{
						tempNote_info2+="("+node.getId()+"、"+node.getName()+"、预约生效)";			
					}
					 
				}
				
		}
		opr_info+= tempNote_info2+"|";	
		
		var tempV3 = "";
		var tableObj=document.getElementById("tab_pro");
		
		var trObjs=tableObj.getElementsByTagName("tr");
		
		var newTFV1 = ""; //新增特服24小时内生效
		var newTFV2 = ""; //新增特服预约生效名称
		var newTFVt2 = ""; //新增特服预约生效时间
		
		for(var i=1;i<trObjs.length;i++)
		{
		var tdObjs=trObjs[i].getElementsByTagName("td");
		
		var tempV2 = tableObj.rows[i].cells[0].innerHTML
		var inputV=tdObjs[1].getElementsByTagName("input")[0].value;
		var inputV1=tdObjs[2].getElementsByTagName("input")[0].value;
		
		
		if("<%=dateStr2%>"==inputV){
				newTFV1+=tempV2+"、";
			}else{
				newTFV2+=tempV2+"、";
				newTFVt2+=inputV+"、";
		 }
		}	
		
		if(newTFV1.length >0) newTFV1 = newTFV1.substring(0,newTFV1.length-1);
		if(newTFV2.length >0) newTFV2 = newTFV2.substring(0,newTFV2.length-1);
		if(newTFVt2.length >0) newTFVt2 = newTFVt2.substring(0,newTFVt2.length-1);
		
		
		opr_info+="开通特服："+newTFV1+"|";	
		opr_info+=newTFV2+"|";
		opr_info+=newTFVt2+"|";
				
		if(document.all.is_not_adward.value=="Y"){
			if("<%=regionCode%>"=="12"){
				note_info1+="您参与入网抽奖活动后，开户预存款未消费完结办理预销，需由您按原价购回礼品，并按剩余开户预存款的30%向移动公司支付违约金。"+"|";
				note_info1+="您参与活动并领取礼品后，不能进行开户及预存款冲正，所交话费不能退费。"+"|";
			}else if("<%=regionCode%>"=="02"){
				note_info1+="您参与活动并领取礼品后，不能进行开户及预存款冲正，所交话费不能退费。开户预存款没有使用完毕前,不能办理销号业务。"+"|";									
   				note_info1+="请您在入网当天在入网营业厅领取礼品，过期无效。"+"|";
			}
			else{
				note_info1+="您参与入网抽奖活动后，三个月(含入网当月)内不能进行资费变更。三个月内若变更资费，所得礼品需由您按原价买回,并按剩余预存款的30％向移动公司支付违约金。"+"|";
				note_info1+="您参与活动并领取礼品后，不能进行开户及预存款冲正，所交话费不能退费。"+"|";
			}
		}
 		note_info1+=" "+"|";
 		
 			if(document.all.newZOfferDesc.value!=""){
 				note_info1+="主资费描述："+document.all.newZOfferDesc.value+"|";
 			}else{
 				note_info1+="主资费描述：<%=offerComments%>"+"|";
 			}
		
		
	
		ajaxGetEPf1(tempDescById);
		note_info1+="可选资费描述：|"+retResultStr1+"|";		


		if((document.all.isGoodNo.value).trim()=='1'){
		    note_info4+=" "+"|";
			  note_info4+="备注：该号码为特殊号码，需在您选择的资费的基础上设置底线消费（底线不包含信息费），如您当月消费的话费（不包括信息费）不足底线额度，将按底线标准收取。"+"|";
		}
		//20100302 fengry add
		if((document.all.isGPhoneFlag.value).trim()=="N"){
			  note_info4+="客户自愿承诺（"+toStanDate(document.all.isGPhoneDate.value)+"前）本号码仅用于甲方本人使用，不转售、不赠送、不申请过户、不使用此号码时主动到乙方营业厅申请销户。"+"|";
		}
		//20100302 end
   
	  if(document.all.largess_card.value=="Y"){
			note_info4+="您获赠"+"<%=strCardSum%>" + "张10元面值充值卡,请您凭入网发票和服务密码于入网当日起的30天内到当地指定营业厅领取，过期作废。"+"|";			
		}else{
			note_info4+=" "+"|";
		}
    note_info4+="备注："+document.all.op_note.value+"|";
    /**
    	2013/3/21 星期四 17:37:35 gaopeng 添加如果选择分散账期，在后面加入一句话
    **/
    if(document.all.fszqVal.value=="1")
    {
    	var currentTime = "<%=currTime%>";
    	var getcuDate = currentTime.substring(6,8);
    	if(getcuDate=="25"||getcuDate=="26"||getcuDate=="27"||getcuDate=="28"||getcuDate=="29"||getcuDate=="30"||getcuDate=="31"||getcuDate=="01"||getcuDate=="02"||getcuDate=="03"||getcuDate=="04")
    	{
    		note_info4+="您的结账日是25日|";
    	}
    	if(getcuDate=="05"||getcuDate=="06"||getcuDate=="07"||getcuDate=="08"||getcuDate=="09")
    	{
    		note_info4+="您的结账日是05日|";
    	}
    	if(getcuDate=="10"||getcuDate=="11"||getcuDate=="12"||getcuDate=="13"||getcuDate=="14")
    	{
    		note_info4+="您的结账日是10日|";
    	}
    	if(getcuDate=="15"||getcuDate=="16"||getcuDate=="17"||getcuDate=="18"||getcuDate=="19")
    	{
    		note_info4+="您的结账日是15日|";
    	}
    	if(getcuDate=="20"||getcuDate=="21"||getcuDate=="22"||getcuDate=="23"||getcuDate=="24")
    	{
    		note_info4+="您的结账日是20日|";
    	}
    	
    }
 		
 
	retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
    retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
 	return retInfo;	
}

function toStanDate(isDatec)  {
	var yearStr = isDatec.substring(0,4);	
	var monthStr = isDatec.substring(4,6);	
	var dayStr = isDatec.substring(6,8);	
	var retStr = yearStr+"年"+monthStr+"月"+dayStr+"日";
	return retStr;
}
function ajaxGetEPf(offerIdv,offerId){
		var packet = new AJAXPacket("/npage/s1270/ajaxGetEPf.jsp","请稍后...");
		packet.data.add("offerIdv",offerIdv);
		packet.data.add("opCode","<%=opCode%>");
		packet.data.add("xqJf",offerId);
		core.ajax.sendPacket(packet,doAjaxGetEPf1);
		packet = null;
	}  
	
function doAjaxGetEPf1(packet){
		 retResultStr = packet.data.findValueByName("retResultStr");
		 
		 document.all.newZOfferECode.value = packet.data.findValueByName("newZOfferECode");
		 document.all.newZOfferDesc.value = packet.data.findValueByName("newZOfferDesc"); 
		 document.all.dOfferId.value = packet.data.findValueByName("dOfferId"); 
		 document.all.dOfferName.value = packet.data.findValueByName("dOfferName"); 
		 document.all.dECode.value = packet.data.findValueByName("dECode"); 
		 document.all.dOfferDesc.value = packet.data.findValueByName("dOfferDesc"); 
		 }
	
function ajaxGetEPf1(tempNote_info2v){
		var packet = new AJAXPacket("/npage/s1104/ajaxGetEPf.jsp","请稍后...");
		packet.data.add("tempNote_info2v",tempNote_info2v);
		packet.data.add("opCode","<%=opCode%>");
		core.ajax.sendPacket(packet,doAjaxGetEPf11);
		packet = null;
	}  
	
function doAjaxGetEPf11(packet){
		 retResultStr1 = packet.data.findValueByName("retResultStr");
	}		
		
		
function setLoginAccept(retVal){
	document.all.printAccept.value = retVal;
	releaseNumFlag = false;
	document.prodCfm.action="confm_new.jsp";
	document.prodCfm.submit();
}

function check_o(obj){ 
	if(obj.checked == true){
		document.getElementById(obj.v_div).style.display = "";
	}else{
		document.getElementById(obj.v_div).style.display = "none";
	}	
}

function releaseNum(){
	var selByWay = $("#selByWay").val();	//选号方式
	var NUM=document.all.selNum.value+"~";//需要释放的号码或号码串；
	if(document.all.selNum.value==''){
		return false;	
	}
	if(prodId==GUTypeId && selByWay == 1){		//只有选的号码才释放
		releaseGUNum(NUM);
	}else if(prodId==CDMATypeId && selByWay == 1 ){
		//release3GNum(NUM); //hejwa  注释 刷新报错 选号方式变更
	}
}

//---检验SIM卡资源---



function selectCheckSimNo(){
	
	
	var nuCardType = document.all.cardTypeN.value;
	if(nuCardType=="1"){ //空卡开户
			checksim();
		}else{
			qrySimType();
		}
	
        
	}
	

function checksim(){
	
	if(document.all.selNum.value == "")
    {
        rdShowMessageDialog("请输入服务号码！",0);
        document.all.selNum.focus();
        return ;
    }
    
    var giveliyana = document.all.selNum.value.trim();
    /*如果要开物联网*/
    if("<%=brandID%>"=="101"){
    if(giveliyana.substring(0,3)=="147")
    {
    //	giveliyana="206"+giveliyana.substring(3,giveliyana.length);
    }
    if(giveliyana.substring(0,5)=="10647")
    {
    	giveliyana="206"+giveliyana.substring(5,giveliyana.length);
    }
    if(giveliyana.substring(0,5)=="10648")
    {
    	giveliyana="205"+giveliyana.substring(5,giveliyana.length);
    }
  	}
    //if(!forMobil(document.all.selNum))  return false;	//验证输入的手机号码的有效性
    var operType = document.all.newSmCode.value;
    var sim_type = document.all.simTypeCfm.value;
    if(document.all.simCode.value == "")
    {
        rdShowMessageDialog("请输入SIM卡号码！",0);
        return false;
    } 
    if($("#yz").val() == "Y"){
    	if($("#yzID").val().trim().length == 0 || $("#yzID").val() == ""){
    		rdShowMessageDialog("请输入预占ID！",0);
        return false;
    	}
    }
    
		var checkResource_Packet = new AJAXPacket("f1104_5.jsp","正在进行资源校验，请稍候......");
		checkResource_Packet.data.add("retType","checkResource");
    checkResource_Packet.data.add("sIn_Phone_no",giveliyana);
    checkResource_Packet.data.add("sIn_OrgCode","<%=orgCode%>");
    checkResource_Packet.data.add("sIn_Sm_code",operType);
    checkResource_Packet.data.add("sIn_Sim_no",document.all.simCode.value);
    /*begin diling add for 关于对特殊号码审批专项测试结果进行优化的需求 增加参数：custIccid @2012/5/28 */
    checkResource_Packet.data.add("custIccid","<%=custIccid%>");
    /*end diling add*/
    //begin weigp add 控制逻辑入网类型08
    if("08" == selOfferType){
    	checkResource_Packet.data.add("sIn_Sim_type","10049");
    }else{
    	checkResource_Packet.data.add("sIn_Sim_type",sim_type);
    }
    //end weigp add 控制逻辑入网类型08
    checkResource_Packet.data.add("workno","<%=workNo%>");
    checkResource_Packet.data.add("innetType",document.all.innetType.value);
    
    var szph = "aaa";
    
    if(document.all.yzID.value.trim()!=""){ 
   		szph = document.all.yzID.value.trim();
   	}
   	
    checkResource_Packet.data.add("zph",szph);
    checkResource_Packet.data.add("sIn_cardtype",document.all.cardtype_bz.value);
		core.ajax.sendPacket(checkResource_Packet,doChecksim,false);
		checkResource_Packet=null;  
		
		
	}
function changeyz(){
	if($("#yz").val() == "Y"){
		$("#yzID").removeAttr("readonly");
	}else{
		$("#yzID").val("").attr("readonly","readonly");
	}
}
function doChecksim(packet){
					
		var retCode = packet.data.findValueByName("retCode");
		var retMessage = packet.data.findValueByName("retMessage");
		
		var isGoodNo = packet.data.findValueByName("isGoodNo");
		var prepayFee = packet.data.findValueByName("prepayFee");
		var mode_dxpay = packet.data.findValueByName("mode_dxpay"); 
		document.all.prepayFee.value = prepayFee;		
		document.all.isGoodNo.value = isGoodNo;
 		document.all.modedxpay.value = mode_dxpay;
 		 if(retCode=="0"||retCode=="000000"){
    	
    	    //getFee();   //得到费用参数
				    	   var tempSimType = $("#simType").val().trim();
				    	    if(tempSimType>="10013" && tempSimType<="10015"){
												if(tempSimType=='10013' && tempSimType!='bgn'){
												rdShowMessageDialog("只有业务品牌是全球通的用户才能用全球64KOTA卡！");
												return false;}
												if(tempSimType=='10014' && tempSimType!='bdn'){
												rdShowMessageDialog("只有业务品牌是动感地带的用户才能用动感地带64KOTA卡！");
												return false;}
												if(tempSimType=='10015' && tempSimType!='bzn'){
												rdShowMessageDialog("只有业务品牌是神洲行的用户才能用神洲行64KOTA卡！");
												return false;}
										}
		            rdShowMessageDialog("资源校验成功！");
		            //漫游改造需求 ningtn
		            	var romaselNum = $("#selNum").val();//取出号码
									var romaselNum3 = romaselNum.substring(0,3);//取出号码前3位
									/* gaopeng 20120914  begin 删除array里面的157号段*/
									var gheadArrs = new Array("045","046","451");
									if(findStrInArr(romaselNum3,gheadArrs)){
										setNoneRoma(myArrs,false,false);
										var roma2042Arrs = new Array("2042");
										setNoneRoma(roma2042Arrs,true,true);
									}
								//漫游改造需求 ningtn end
		            if(document.all.cardTypeN.value=="0"){   //非空卡开户资源校验成功后才能提交
									document.all.cfmBtn.disabled=false;		            	
		            }
		            //begin weigp add
		            if(document.all.cardTypeN.value=="1" && "08"==selOfferType){
		            	document.all.cfmBtn.disabled=false;
		            }
		             //end weigp add
								document.all.checksimN.disabled=true;
		            
						 if(document.all.cardtype_bz.value=='k'){
				  			document.all.b_write.disabled=false;
				  		}
			  		if(document.all.cardTypeN.value=="1" && "08"==selOfferType){// weigp add空卡开户资源校验成功后才能提交
	            	document.all.cfmBtn.disabled=false;
	            	document.all.b_write.disabled=true;
	           }
				  	document.all.selNum.readOnly=true;
					  document.all.selNum.className="InputGrey";	
					  document.all.simCode.readOnly=true;
					  document.all.simCode.className="InputGrey";			
					  /* 校验成功了就别改预占ID了 */
					  $("#yzID").attr("readonly","readonly");
					  $("#yz").attr("disabled","disabled");
    	}else{
    		    document.all.cfmBtn.disabled=true;
						document.all.checksimN.disabled=false;
						document.all.selNum.value="";/*20100128 add*/
						document.all.selNum.className = "";
						document.all.selNum.readOnly = false;
						document.all.simCode.value="";/*20100128 add*/
						document.all.simCode.className = "";
						document.all.simCode.readOnly = false;
    	    	retMessage = retMessage + "[errorCode8:" + retCode + "]";
    				rdShowMessageDialog(retMessage,0);
    				return false;
    	}
}


function qrySimType()
{
  var simCode	= $("#simCode").val().trim();
   //得到sim卡类型
  var getAccountId_Packet = new AJAXPacket("pubGetSimType.jsp","正在获得sim卡类型，请稍候......");
	getAccountId_Packet.data.add("region_code","<%=regionCode%>");
	getAccountId_Packet.data.add("simNo",simCode);
	core.ajax.sendPacket(getAccountId_Packet,doQrySimType,false);
	getAccountId_Packet=null;
}

function doQrySimType(packet){
		var retCode = packet.data.findValueByName("retCode"); 
    var retMessage = packet.data.findValueByName("retMessage");	
    
         var sim_type = packet.data.findValueByName("sim_type");    	    
         var sim_typename = packet.data.findValueByName("sim_typename");
				 
				
         
	    if(retCode=="000000")
		  {  
	     document.all.simTypeCfm.value = sim_type;
       document.all.simType.value = sim_type;  
			 if(sim_typename=="null"){
			 		
			 	}else{
			 		document.all.simTypeName.value=(sim_typename).trim();
			 		}
		
		  }else
	      {
				retMessage = retMessage + "[errorCode2:" + retCode + "]";
				rdShowMessageDialog(retMessage,0);
				return false;
      }
      
      checksim();
	}
	
	
function dochecksim1(packet){
					
		var errorCode = packet.data.findValueByName("errorCode");
		var errorMsg = packet.data.findValueByName("errorMsg");
		if(errorCode == "0"){
				var simType = packet.data.findValueByName("simType");
				var checkedSimCode = packet.data.findValueByName("checkedSimCode");
				var isSell = packet.data.findValueByName("isSell");
				var sellId = packet.data.findValueByName("sellId");
				
				$("input[name='sellGroupId']").val(sellId);
				
				if(simType != ""){
					$("input[name='simType']").val(simType);
					$("#simCode").val(checkedSimCode);
					rdShowMessageDialog("资源校验成功!");
					$("#cfmBtn").attr("disabled",false);
					if(document.all.cardtype_bz.value=='k'){
			  			document.all.b_write.disabled=false;
			  		}
				}
				else{
					rdShowMessageDialog("SIM卡类型为空!");
					return false;
				}		
				
				if(isSell == "Y"){
					if($("#openType").val() == "01"){
						rdShowMessageDialog("该号码应选择分销商返单入网方式!");
					}
					$("#openType").html("<option value='02'>分销商返单</option>");
				}else{
					if($("#openType").val() == "02"){
						rdShowMessageDialog("该号码应选择普通开户入网方式!");
					}
					$("#openType").html("<option value='01'>普通开户</option>");
					$("input[name='sellGroupId']").val("");
				}
		}
		else{
				rdShowMessageDialog("资源校验失败!"+errorMsg);
				$("#cfmBtn").attr("disabled",false);
				//return false;
		}
}

//---检验SIM卡资源---
function checkBatchSim(){


		var packet = new AJAXPacket("checkBatchSIM.jsp","请稍后...");
		packet.data.add("brandId","<%=brandID%>");
		packet.data.add("gCustId","<%=gCustId%>");
		packet.data.add("opCode","<%=opCode%>");
		packet.data.add("simFlag",document.all.simFlag.value);
		packet.data.add("fileName",document.all.psfileName.value);
		core.ajax.sendPacket(packet,doCheckBatchSim);
		packet = null;
}

function doCheckBatchSim(packet){
		var errorCode = packet.data.findValueByName("errorCode");
		var errorMsg = packet.data.findValueByName("errorMsg");
		if(errorCode == "000000"){
				var successNum = packet.data.findValueByName("successNum");
				var checkedPhoneNoStr = packet.data.findValueByName("checkedPhoneNoStr");
				var checkedSimNoStr = packet.data.findValueByName("checkedSimNoStr");
				var chFeeList = packet.data.findValueByName("chFeeList");
				if(successNum > 0){
					$("#phoneNoStr").val(checkedPhoneNoStr);
					$("#simNoStr").val(checkedSimNoStr);
					$("#chFeeList").val(chFeeList);
					rdShowMessageDialog("资源校验成功!");
					$("#cfmBtn").attr("disabled",false);	
				}
				else{
					rdShowMessageDialog("0个资源校验成功!");
					return false;	
				}	
		}
		else{
				rdShowMessageDialog("资源校验失败!"+errorMsg);
				return false;
		}
}

function viewRes()
{ 
	//查询资源详细信息
	var paraArr=new Array(4);
	paraArr[0]=$("#phoneNoStr").val();
	paraArr[1]=$("#simNoStr").val();
	paraArr[2]=$("#chFeeList").val();
	paraArr[3]=$("#phoneNoStr").val();
	paraArr[4]=$("#phoneNoStr").val();
 	
   var path = "f1114_4gn.jsp";
	
	var t=window.screen.availHeight-300;
	var l=window.screen.availWidth-300;
 	var window_location= "dialogWidth:30;dialogHeight:40;"
  var retInfo = window.showModalDialog(path,paraArr,window_location);

}
function showGroup(offIdv,offerNamev,groupIdv){
	var offerId = offIdv;
	var offerName = offerNamev;
	var groupTypeId = groupIdv;
	
	var curDate = new Date().getTime();
	var h=10;
	var w=10;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;
	var prop="dialogHeight:"+h+"px;dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
	if(true){
	var ret=window.showModalDialog("showGroup.jsp?opType=set&offerId="+offerId+"&offerName="+offerName+"&groupTypeId="+groupTypeId+"&brandID="+"<%=brandID%>"+"&curTime="+curDate+"&groutDesc="+document.all.groutDesc.value,"",prop);
		if(typeof(ret) != "undefined"){
			var retTemp =ret; 
			ret = ret.substring(0,ret.indexOf("#"));
			document.all.groutDesc.value =  retTemp.substring(retTemp.indexOf("#")+1,retTemp.length);
	
			groupHash[offerId]=ret.toString();	//将返回的群组信息对应offerId放入

			var offerGroupInfo = "";		//组装销售品的群组信息,格式:offerId,groupinfo1,groupinfo2,~
			offerGroupInfo += offerId;
			offerGroupInfo += "|";
			var temp = ret.toString().split("/");

			$.each(temp[0].split("$"),function(i,n){
				if(typeof(n) != "undefined"){
					if(i<6){											//前6个为群组基本信息,后面的为它的属性信息
						offerGroupInfo += n.split("~")[1];	
						offerGroupInfo += "$";	
					}
					else{
						offerGroupInfo += n.substring(2); //去除"s_",id~value
						offerGroupInfo += "$";
					}
				}	
			});
			offerGroupInfo += "/";	
			
			offerGroupInfo+=temp[1];
			offerGroupHash[offerId] = offerGroupInfo;
		}	
		else{
			rdShowMessageDialog("未设置群组！");	
			return false;
		}
	}
	else{
		var ret=window.showModalDialog("showGroup.jsp?opType=look&offerId="+offerId+"&offerName="+offerName+"&groupInfo="+groupHash[offerId]+"&groupTypeId="+groupTypeId+"&groutDesc="+document.all.groutDesc.value,"",prop);
	
		if(typeof(ret) != "undefined"){
				var retTemp = ret;
				
				ret = ret.substring(0,ret.indexOf("#"));
				document.all.groutDesc.value =  retTemp.substring(retTemp.indexOf("#")+1,retTemp.length);
			groupHash[offerId]=ret;	//将返回的群组信息对就offerId放入
			
			var offerGroupInfo = "";		//组装销售品的群组信息,格式:offerId,groupinfo1,groupinfo2,~
			offerGroupInfo += offerId;
			offerGroupInfo += "|";
			var temp = ret.toString().split("/");
			$.each(temp[0].split("$"),function(i,n){
				if(typeof(n) != "undefined"){
					if(i<6){											//前6个为群组基本信息,后面的为它的属性信息
						offerGroupInfo += n.split("~")[1];	
						offerGroupInfo += "$";	
					}
					else{
						offerGroupInfo += n.substring(2); //去除"s_"
						offerGroupInfo += "$";
					}
				}	
			});
			offerGroupInfo += "/";	
			
			offerGroupInfo+=temp[1];
			offerGroupHash[offerId] = offerGroupInfo;
		}
	}	
}
function showGroup1(offIdv,offerNamev,groupIdv){
	var offerId = offIdv;
	var offerName = offerNamev;
	var groupTypeId = groupIdv;
 
	 	
	  var packet1 = new AJAXPacket("showGroup.jsp","请稍后...");
	  		packet1.data.add("opType","set");
	  		packet1.data.add("offerId",offerId);
	  		packet1.data.add("offerName",offerName);
	  		packet1.data.add("groupTypeId",groupTypeId);
	  		packet1.data.add("brandID","<%=brandID%>");
	  		packet1.data.add("groutDesc",document.all.groutDesc.value);
				packet1.data.add("sOrderArrayId","<%=orderArrayId%>");
				core.ajax.sendPacket(packet1,doShowGroup,false);
				packet1 =null;
			
}
function doShowGroup(packet){			
	var ret = packet.data.findValueByName("ret");
	
	
		if(typeof(ret) != ""){
			var retTemp =ret; 
			ret = ret.substring(0,ret.indexOf("#"));
			document.all.groutDesc.value =  retTemp.substring(retTemp.indexOf("#")+1,retTemp.length);
	
			groupHash[offerId]=ret.toString();	//将返回的群组信息对应offerId放入

			var offerGroupInfo = "";		//组装销售品的群组信息,格式:offerId,groupinfo1,groupinfo2,~
			offerGroupInfo += offerId;
			offerGroupInfo += "|";
			var temp = ret.toString().split("/");
			
			$.each(temp[0].split("$"),function(i,n){
				if(typeof(n) != "undefined"){
					if(i<6){											//前6个为群组基本信息,后面的为它的属性信息
						offerGroupInfo += n.split("~")[1];	
						offerGroupInfo += "$";	
					}
					else{
						offerGroupInfo += n.substring(2); //去除"s_",id~value
						offerGroupInfo += "$";
					}
				}	
			});
			offerGroupInfo += "/";	
			
			offerGroupInfo+=temp[1];
			offerGroupHash[offerId] = offerGroupInfo;
		}	
		else{
			rdShowMessageDialog("未设置群组！");	
			return false;
		}
 
}

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
		var ret=window.showModalDialog("showAttr.jsp?queryId="+queryId+"&queryType="+queryType,"",prop);
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
		var ret=window.showModalDialog("showAttr.jsp?queryId="+queryId+"&queryType="+queryType+"&attrInfo="+AttributeHash[queryId],"",prop);
		if(typeof(ret) != "undefined"){
			AttributeHash[queryId]=ret;	//将返回的群组信息对就queryId放入
		}
	}	
}

//密码一致校验
function checkPwd1(obj1,obj2)
{
	var pwd1 = obj1.value;
	var pwd2 = obj2.value;
	if(pwd1==""){
			rdShowMessageDialog("请输入用户密码",0);
			obj1.focus();
			return false;
		}
		
		
	if(pwd1 != pwd2)
	{
		var message = "输入的密码不一致，请重新输入！";
		rdShowMessageDialog(message,0);
		obj1.value = "";
		obj2.value = "";
		obj1.focus();
		return false;
	}
	return true;
}

function getOrderInfo()
{
	var odValue = document.all.orderInfoV.value;
	if(odValue=="0"){
		$("#orderInfo").css("display","");	
		document.all.orderInfoV.value="1";
	}
	else{
		document.all.orderInfoV.value="0";
		$("#orderInfo").css("display","none");	
	}
}


function doPostInfo(){
	
	document.all.checksimN.disabled=false;
	
	document.all.innetCode.options.length=document.all("dnInnetCode").length;		
	for(var i=0;i<document.all("dnInnetCode").length;i++)
	{
	  document.all.innetCode.options[i].value=document.all("dnInnetCode").options[i].value;
	  document.all.innetCode.options[i].text=document.all("dnInnetCode").options[i].text;
	  document.all.innetCode.options[i].mainCode=document.all("dnInnetCode").options[i].mainCode;   
	  document.all.innetCode.options[i].mainName=document.all("dnInnetCode").options[i].mainName;
  	document.all.innetCode.options[i].subCount=document.all("dnInnetCode").options[i].subCount;
	}
	
	
	var ispost = document.all.isPost.value;
	if(ispost==0){
			document.getElementById("postInfo").style.display = "";
		}else{
			document.getElementById("postInfo").style.display = "none";
			}
	} 
	
	
function changelargesscard(){
	if (parseInt(prodCfm.largess_card_sum.value) == 0){
		document.all.largess_card[1].selected = true;
		rdShowMessageDialog("此地市或区县没有入网赠送充值卡活动");
		return false;
	}

 
}	

function isnotawardhange(){
 
    	if(document.all.is_not_adward.value=="Y"){
    		if (prodCfm.innetCode.options[prodCfm.innetCode.selectedIndex].text=="商务电话" || prodCfm.innetCode.options[prodCfm.innetCode.selectedIndex].text=="公免"||
						prodCfm.innetCode.options[prodCfm.innetCode.selectedIndex].text=="IP公话"){
    			rdShowMessageDialog("商务电话或IP公话或公免不能参加入网新惊喜活动");
				return false;
    		}
    	 if (prodCfm.goodphone.value=='Y'){
    			rdShowMessageDialog("特殊号码不能参加入网送福活动");
				return false;
    	}
	}
	
    	
}

function chaCardType(){  //空卡开户
	var nuCardType = document.all.cardTypeN.value;
	if(nuCardType=="1"){
 
		document.all.cardtype_bz.value="k";
		document.all.cfmBtn.disabled=true;	 // 空卡开户 提交置灰
		
  		 var phone = $("input[name='selNum']").val();;
  		 /****新增调大唐功能取SIM卡类型****/
  		 /* 
        * diling update for 修改营业系统访问远程写卡系统的访问地址，由现在的10.110.0.125地址修改成10.110.0.100！@2012/6/4
        */
  		 path ="http://10.110.0.100:33000/writecard/writecard/ReadCardInfo.jsp";
  		 var retInfo1 = window.showModalDialog("Trans.html",path,"","dialogWidth:10;dialogHeight:10;"); 
		 if(typeof(retInfo1) == "undefined")     
    	 {	
    		 rdShowMessageDialog("读卡类型出错!");
    		 document.all.cardTypeN.value = "0";  //重置 空卡开户 为否 hejwa add
    		 document.all.cardtype_bz.value="s";  // 空卡开户为否
    		 document.all.checksimN.disabled=false; //资源校验按钮可用 
    		return false;   
    	 }
    	var chPos;
    	chPosn = retInfo1.indexOf("&");
    	if(chPosn < 0)
    	{	
    		rdShowMessageDialog("读卡类型出错!");
    		document.all.cardTypeN.value = "0";  //重置 空卡开户 为否 hejwa add
    		document.all.cardtype_bz.value="s";  // 空卡开户为否
    		document.all.checksimN.disabled=false; //资源校验按钮可用 
    		return false ;	
    	} 
    	retInfo1=retInfo1+"&";
    	var retVal=new Array();   
    	for(i=0;i<4;i++)
    	{   	   
    		var chPos = retInfo1.indexOf("&");
        	valueStr = retInfo1.substring(0,chPos);
        	var chPos1 = valueStr.indexOf("=");
        	valueStr1 = valueStr.substring(chPos1+1);
        	retInfo1 = retInfo1.substring(chPos+1);
        	retVal[i]=valueStr1;
        	
    	} 
    	if(retVal[0]=="0")
    	{
    		var rescode_str=retVal[2]+"|";
    		var rescode_strstr="";
    		var chPosm = rescode_str.indexOf("|");
    		for(i=0;i<4;i++)
    		{   	   
    	
    			var chPos1 = rescode_str.indexOf("|");
        		valueStr = rescode_str.substring(0,chPos1);
        		rescode_str = rescode_str.substring(chPos1+1);
        		if(i==0 && valueStr=="")
        		{
        			rdShowMessageDialog("读卡类型出错!");
        			document.all.cardTypeN.value = "0";  //重置 空卡开户 为否 hejwa add
        			document.all.cardtype_bz.value="s";  // 空卡开户为否
        			document.all.checksimN.disabled=false; //资源校验按钮可用 
    		 		  return false;
        		}
        		if(valueStr!=""){
        			rescode_strstr=rescode_strstr+"'"+valueStr+"'"+",";
        		}
        	
    		} 
    		rescode_strstr=rescode_strstr.substring(0,rescode_strstr.length-1);
    		if(rescode_strstr=="")
    		{
    			rdShowMessageDialog("读卡类型出错!");
    			document.all.cardTypeN.value = "0";  //重置 空卡开户 为否 hejwa add
    			document.all.cardtype_bz.value="s";  // 空卡开户为否
    			document.all.checksimN.disabled=false; //资源校验按钮可用 
    		 	return false;   
    		}
  		}
  		else{
  			 rdShowMessageDialog("读卡类型出错!");
  			 document.all.cardTypeN.value = "0";  //重置 空卡开户 为否 hejwa add
  			 document.all.cardtype_bz.value="s";  // 空卡开户为否
  			 document.all.checksimN.disabled=false; //资源校验按钮可用 
    		 return false;   
    	}
  		 /****取SIM卡类型结束******/
    		 var path = "<%=request.getContextPath()%>/npage/innet/fgetsimno_1104.jsp";
    		 path = path + "?regioncode=" + "<%=regionCode%>";
    	         path = path + "&phone=" + phone + "&rescode=" + rescode_strstr+ "&pageTitle=" + "生成SIM卡号码";
    	       
    		 var retInfo = window.showModalDialog(path,"","dialogWidth:40;dialogHeight:20;");
    		
    		document.all.checksimN.disabled=false;
    		//document.all.b_write.disabled=false;  资源校验成功后才可以写卡
    		 if(typeof(retInfo) == "undefined")     
    			{	return false;   }
    		var simsim=oneTok(oneTok(retInfo,"~",1));
    		var typetype=oneTok(oneTok(retInfo,"~",2));
    		var cardcard=oneTok(oneTok(retInfo,"~",3));
    		document.all.simCode.value=simsim;
    		document.all.simType.value=(cardcard).trim();
    		document.all.simTypeCfm.value=(cardcard).trim();
    		
    		if((typetype).trim()=="null"){
    			
    			}else{
		 document.all.simTypeName.value=(typetype).trim();
    	}
		}else{
			document.all.cardtype_bz.value="s";
			}
	}
	
function setDateMove(time,moveFormat,moveNumber,outFormat)
{
    addSecond=function (dt,num)   
		{   
			dt.setSeconds(dt.getSeconds()+num);   
			return dt;   
		}   
	if(time.indexOf('/')==-1)
	{
		var arr=time.split(' ');
		var _time=arr[0].substr(0,4)+'/'+arr[0].substr(4,2)+'/'+arr[0].substr(6,2);
		arr[0]=_time;
		time=arr.join(" ");
		}
	if((date = new Date(time))=="NaN") {alert("时间格式不正确！"); return "";}
	var moveDate='';
	var get_Year='';
	var get_Mon='';
	var get_date='';
	var get_Hours='';
	var get_Min='';
	var get_Sec='';
	get_Mon=date.getMonth()+1;
	get_date=date.getDate();
	get_Hours=date.getHours();
	get_Min=date.getMinutes();
	get_Sec=date.getSeconds();
	if(isNaN(moveNumber=parseInt(moveNumber))){alert("时间位移必须为数值型！"); return "";}
	if(moveFormat=="hh") moveFormat = "kk";
	switch(moveFormat){
	case 'dd':
		moveNumber=moveNumber*24*60*60;
		moveDate=addSecond(date,moveNumber);
		get_Year=moveDate.getYear();
		get_Mon=moveDate.getMonth()+1;
		get_date=moveDate.getDate();
		get_Hours=moveDate.getHours();
		get_Min=moveDate.getMinutes();
		get_Sec=moveDate.getSeconds();
		break;
	case 'kk':
		moveNumber=moveNumber*60*60;
		moveDate=addSecond(date,moveNumber);
		get_Year=moveDate.getYear();
		get_Mon=moveDate.getMonth()+1;
		get_date=moveDate.getDate();
		get_Hours=moveDate.getHours();
		get_Min=moveDate.getMinutes();
		get_Sec=moveDate.getSeconds();
		break;
	case 'mm':
		moveNumber=moveNumber*60;
		moveDate=addSecond(date,moveNumber);
		get_Year=moveDate.getYear();
		get_Mon=moveDate.getMonth()+1;
		get_date=moveDate.getDate();
		get_Hours=moveDate.getHours();
		get_Min=moveDate.getMinutes();
		get_Sec=moveDate.getSeconds();
		break;
	case 'ss':
		moveDate=addSecond(date,moveNumber);
		get_Year=moveDate.getYear();
		get_Mon=moveDate.getMonth()+1;
		get_date=moveDate.getDate();
		get_Hours=moveDate.getHours();
		get_Min=moveDate.getMinutes();
		get_Sec=moveDate.getSeconds();
		break;
	case 'yyyy':
		date.setFullYear(date.getFullYear()+moveNumber); 	
		get_Year=date.getFullYear();
		get_Mon=date.getMonth()+1;
		get_date=date.getDate();
		get_Hours=date.getHours();
		get_Min=date.getMinutes();
		get_Sec=date.getSeconds();
		break;	
	case 'MM':
		date.setMonth(date.getMonth()+moveNumber);
		get_Year=date.getFullYear();
		get_Mon=date.getMonth()+1;
		get_date=date.getDate();
		get_Hours=date.getHours();
		get_Min=date.getMinutes();
		get_Sec=date.getSeconds();
		break;					
	default: 
		alert('参数错误');
		return "";
	}
	if(outFormat!=undefined)
	{
	    var times=outFormat.replace('yyyy',get_Year).replace('MM',("0"+get_Mon).slice(-2)).replace('dd',("0"+get_date).slice(-2)).replace('kk',("0"+get_Hours).slice(-2)).replace('mm',("0"+get_Min).slice(-2)).replace('ss',("0"+get_Sec).slice(-2));
	}
	else
		var times=get_Year+'/'+("0"+get_Mon).slice(-2)+'/'+("0"+get_date).slice(-2)+'/'+' '+("0"+get_Hours).slice(-2)+':'+("0"+get_Min).slice(-2)+':'+("0"+get_Sec).slice(-2);
	return times;
}

function ignoreThis(){
	
	if(rdShowConfirmDialog("请确认是否取消该业务？ 确认后，业务将被删除")==1){
		var packet1 = new AJAXPacket("ignoreThis.jsp","请稍后...");
				packet1.data.add("sOrderArrayId","<%=orderArrayId%>");
				core.ajax.sendPacket(packet1,doIgnoreThis,false);
				packet1 =null;
			}
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
function writechg(){
	if(document.all.simCode.value==""){
		rdShowMessageDialog("sim卡号不能是空!");
		return false;
	}
	if(document.all.cardtype_bz.value=="k"){
		var phone = $("input[name='selNum']").val();
  			document.all.b_write.disabled=true;
    		 var path = "<%=request.getContextPath()%>/npage/innet/fwritecard.jsp";
    		 path = path + "?regioncode=" + "<%=regionCode%>";
    		 path = path + "&sim_type=" +document.all.simTypeCfm.value;
    		 path = path + "&sim_no=" +document.all.simCode.value;
    		 path = path + "&op_code=" +"<%=opCode%>";
    	         path = path + "&phone=" + phone + "&pageTitle=" + "写卡";
    	         path = path + "&deleteShowCardNoFlag=" +"isDelCardNo"; //add by diling  for 关于哈分公司申请优化远程写卡操作步骤的请示
    		 var retInfo = window.showModalDialog(path,"","dialogWidth:40;dialogHeight:20;");
    		 if(typeof(retInfo) == "undefined")     
    			{	
    				 
    				document.all.writecardbz.value="1"; 
    				//document.all.b_write.disabled=false;
    				document.all.cfmBtn.disabled=true;   //写卡失败不能提交 hejwa add 
    				rdShowMessageDialog("写卡失败");
    				return false;   
    				
    			}
    		 
    		 var retsimcode=oneTok(oneTok(retInfo,"|",1));
    		 var retsimno=oneTok(oneTok(retInfo,"|",2));
    		 var cardstatus=oneTok(oneTok(retInfo,"|",3))
    		 
    		 if(retsimcode=="0"){rdShowMessageDialog("写卡成功");
    		 document.all.writecardbz.value="0";
    		 document.all.simCode.value=retsimno;
    		 document.all.simCodeCfm.value=retsimno;
    		 document.all.cardstatus.value=cardstatus;
    		 document.all.cfmBtn.disabled=false;
    		 
    		 	//if(cardstatus=="3"){document.all.simFee.value="0";}
    		 
    		 }else{
    		 	document.all.writecardbz.value="1";
    		 	//document.all.b_write.disabled=false;
    		 	document.all.cfmBtn.disabled=true;
    		 	rdShowMessageDialog("写卡失败");
    		 }
	}
	else{
		rdShowMessageDialog("实卡不能写卡");
		document.all.cfmBtn.disabled=true;   //写卡失败不能提交 hejwa add 
		document.all.b_write.disabled=true;
		return false;
	}
}

//dujl add at 20100409 for 关于调整SIM卡相关业务功能的需求
function getHlr()
{
	if(document.all.selNum.value.trim() == "")
	{
		rdShowMessageDialog("请先输入手机号码！");
		return false;
	}
	//isGoodNoF(document.all.selNum);
	var giveliyana = document.all.selNum.value.trim();
	/*如果要开物联网*/
    if("<%=brandID%>"=="101"){
    if(giveliyana.substring(0,3)=="147")
    {
    //	giveliyana="206"+giveliyana.substring(3,giveliyana.length);
    }
    if(giveliyana.substring(0,5)=="10647")
    {
    	giveliyana="206"+giveliyana.substring(5,giveliyana.length);
    }
    if(giveliyana.substring(0,5)=="10648")
    {
    	giveliyana="205"+giveliyana.substring(5,giveliyana.length);
    }
  	}
	//alert(giveliyana);
	var myPacket = new AJAXPacket("getHlrCode.jsp","正在提交，请稍候......");
	
	//myPacket.data.add("selNum",document.all.selNum.value);
	myPacket.data.add("selNum",giveliyana);
	myPacket.data.add("regionCode","<%=regionCode%>");
	core.ajax.sendPacket(myPacket,doGetHlrCode);
	myPacket=null;
}

function doGetHlrCode(packet)
{
	document.all.hlrCode.value = packet.data.findValueByName("result");
}

function setPtPDate(){
		if(document.all.ptPhoneFlag.value=="Y"){
			document.all.ptPhoneDate.readOnly=true;
		}else{
			document.all.ptPhoneDate.readOnly=false;
		}
}		
</SCRIPT>

</HEAD>
<BODY onload="doPostInfo()">
    <DIV id=operation>
<FORM name="prodCfm" action="" method="post" width="100%"><!-- operation_table -->
<%@ include file="/npage/include/header.jsp" %>	
<DIV id="Operation_table">
    <div class="title">
	<div id="title_zi">客户信息</div>
</div>


<div id="custInfo">
<%@ include file="/npage/common/qcommon/bd_0002.jsp" %>
</div>

<!-- tab start -->
<!--
<div id="tabsJ">
	<ul>
		<li class="current" id="tb_1"><a href="#" onclick="HoverLi(1,2);">基本销售品</a></li>
		<li id="tb_2"><a href="#" onclick="HoverLi(2,2);">销售品构成</a></li>
	</ul>
</div>
-->
<div id="tabsJ">
	<ul>
		<li class="current" id="tb_1"><input type='radio' name='changeSel' value='selBasic' checked onclick="HoverLi(1,2);">基本销售品&nbsp;</li>
		<li id="tb_2"><input type='radio' name='changeSelh' value='selStruc' onclick="HoverLi(2,2);">销售品构成</li>
	</ul>
</div>
<!-- tab end -->
<!-- 基本销售品 开始-->
<div class="dis" id="tbc_01">
<DIV id=tb_01>
<DIV class=input><!-- style="DISPLAY: none"-->
<div id=baseInfo></div>

<div class="title">
	<div id="title_zi">销售品信息</div>
</div>

<TABLE cellSpacing=0>
  <TR>
    <Td class="blue" width=17%>品牌</td>
  	<TD width=33%><%=brandName%>  
  		<input type="hidden" name="orderInfoV" value="0" />
  		<INPUT class=b_text id="orderInfoDiv"  type=button value=查看已选择附加销售品信息 /></TD>
    <Td class="blue"  width=17%>销售品名称</td>
     <TD id="td_offerName"><%=(offerId+"-->"+offerName)%> </TD>
	</TR>
	<tr>
    <Td class="blue">描述</Td>
    <TD colspan="3"><%=offerComments%></TD>
   </TR>
  </table>  
  
<div id="OfferAttribute"></div><!--销售品属性-->
</DIV>

<div class="list" id="orderInfo" style="display:none">
<DIV class=title><div id="title_zi">已选择附加销售品信息</div></DIV>
<div style="overflow-y:scroll;overflow-x:hidden;height:130px">	   	
<table cellSpacing=0 id="tab_order">
	<tr>
    <th>销售品ID</td><th>销售品名称</td><th>生效时间</td><th>失效时间</td><th>描述</td>
	</tr>
</table>	
</div>
</div>

<div class="input" style="display:none"  id="addGroupInfo">
<table cellSpacing=0 style="display:none">
	<tr>
    <td class="blue" style="width:100px">可加群组</td>
    <td id="addGroupTd"></td>
	</tr>
</table>	
</div>

<DIV class="input" id="userinfo">
	<br>
	<div class="title">
		<div id="title_zi">基本信息</div>
	</div>
<div id="userBaseInfo">
 	<%@ include file="include/fUserBaseInfo.jsp" %>
</div>
</div>
</div>

<DIV class="input" id="postInfo"  style="display:none">
		<div class="title">
			<div id="title_zi">邮寄信息</div>
		</div>
<TABLE id=tbPost0  cellSpacing="0">
                <TBODY> 
                <TR  > 
                	        <TD   nowrap class=blue > 
                    操作类型
                  </TD>
                  <TD nowrap  > 
                   <select align="left" name=OperateFlag id=OperateFlag  index="28">
                      <option value="1" selected>增加</option>
                      <option value="2">修改</option>
                      <option value="3">删除</option>
                    </select>
                  </TD>
                  
                  <TD  class=blue  nowrap  width=15%> 
                    <div align="left">邮寄类型</div>
                  </TD>
                  <TD  nowrap  width=35%> 
                    <select align="left" name=postType  index="28">
                      <option value="1" selected>邮寄帐单</option>
                      <option value="2">Email</option>
                      <option value="3">传真</option>
                    </select>
                  </TD>
                  
                </TR>
                <TR  > 
                		<TD  class=blue  nowrap  width=15%> 
                    <div align="left">收件人</div>
                  </TD>
                  <TD  nowrap  width=35%> 
                    <input class="button" name=postName  maxlength=40 v_must=1  v_maxlength=40 index="29" >
                    <font color="red">*</font> </TD>
                    	
                 
                  <TD nowrap  class=blue  > 
                    <div align="left">E_MAIL</div>
                  </TD>
                  <TD nowrap  > 
                    <input class="button" v_name="E_MAIL" name=postMail maxlength=30 v_must=1 v_maxlength=30  index="31" >
                  </TD>
                </TR>
                <TR  > 
                  <TD   nowrap class=blue > 
                    <div align="left">邮寄地址</div>
                  </TD>
                  <TD nowrap  > 
                    <input class="button" name=postAdd   maxlength=30 v_must=0 v_maxlength=30 v_name="邮寄地址" index="32" >
                  </TD>
                  <TD nowrap  > 
                    <div align="left" class=blue >邮寄编码</div>
                  </TD>
                  <TD nowrap  > 
                    <input class="button" name=postZip maxlength=10 v_must=0 v_maxlength=30 v_name="邮寄编码" index="33" >
                  </TD>
                </TR>
                
                 <TR  > 
          				 <TD nowrap  class=blue  > 
                    <div align="left">传真</div>
                  </TD>
                  <TD nowrap  > 
                    <input class="button"  name=postFax maxlength=30 v_must=1 v_maxlength=30 v_name="传真" index="30" >
                  </TD>
          
                  <TD nowrap  > 
                    &nbsp;
                  </TD>
                  <TD nowrap  > 
                   &nbsp;
                  </TD>
                </TR>
                
                </TBODY> 
              </TABLE> 	
</div>

	<div class="title">
		<div id="title_zi">资源信息</div>
	</div>
		
<table cellSpacing=0 id="serviceNoInfo">	
	<TR id="tr_serviceNo" >
		<td class="blue" style="display:none">
				<input type="radio" name="enterType" value="0" checked>号码选择
		</td>
	  <Td class="blue"> 服务号码</Td>
	  <TD ><%@ include file="/npage/common/qcommon/bd_0022.jsp" %>  <font class="orange">*</font>  
	  </TD>
	  <td class="blue">号码归属hlr</td>
	  <td><input class="button" type="text" name="hlrCode" size="20" readonly>
	  	<input type="button" name="b_hlr" value="查询" class="b_text" onClick="getHlr()"> 
	  </td>
	 <td class="blue">空卡开户 </td>
	 <td>
	  	<select align="left" id="cardTypeN" name="cardTypeN"  index="28" onchange="chaCardType()">
        <option value="0" selected>否</option>
        <option value="1">是</option>
      </select>	
   </td>
	</tr>
	<tr  id="tr_serviceNo1">
	  <td class="blue" style="display:none" id="th_simInfo"> SIM卡号 </td>
	  <td colspan="6" style="display:none" id="td_simInfo">
	  	<input name=simType type=hidden value="">
	  	<input name=simTypeName type=text  readonly index="11" Class="InputGrey">
	  	<input type='text' name='simCode' id='simCode' maxlength="20" class="required numOrLetter" value="">
	  	<input type="button" id="checksimN" name="checksimN" value="资源校验" class="b_text" onClick="ajaxOrderCmtChk()"> <font class="orange">*</font>
	  	<input type="button" name="b_write" value="写卡" class="b_text" onClick="writechg()" disabled > 
	  	</td>
	</tr>
	<%if(!passFlag.equals("none")){%>
	<tr style="display:none" >	
		<td class="blue" >
				<input type="radio" name="enterType" value="1" id="radioBatch">文件导入
		</td>
		<td colspan="2" >
			<iframe name="frame_sub_1" id="frame_sub_1" src="getFile.jsp" width="400" height="25" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" >
			</iframe>
		</td>
		<td colspan="2">
			<div id="file10" style="background: eeeeee; height:25">
				<a href="#" onmousemove="document.all.file10_sub.style.visibility='visible'" onMouseOut="document.all.file10_sub.style.visibility='hidden'">鼠标移至此查看文件格式</a>
				<span id="file10_sub" style="position: absolute; left: 0; top: -100;visibility: hidden; background: #eeeeee;width: 330px; margin: 0px; padding: 0px;border: 1px solid silver;overflow: visible;">
					<font color="red"></br>&nbsp;&nbsp;<font color="000000">文件类型:*.txt</font>
					<font color="red"></br>&nbsp;&nbsp;<font color="000000">文件格式:</font></br>
					&nbsp;&nbsp;服务号码&nbsp;sim卡号</br>&nbsp;&nbsp;13900000000 89860106956667239400</br>&nbsp;&nbsp;13900000001 89860106956667239401</br>&nbsp;&nbsp;...........
					</font>
				</span>		
				<input type="button" value="资源校验" class="b_text" id="btn_batch" onClick="checkBatchSim()">	
				<input  class="b_text"  name=resDetail onmouseup="viewRes()" onkeyup="if(event.keyCode==13)viewRes()" style="cursor:hand" type=button value=详细信息 index="25" disabled />	
			</div>	
		</td>	
	</tr>
	<%}%>
	<tr style="display:none" id="tr_contractNoType" >
		<td class="blue">账号类型</td>
		<td colspan="8">
			<input type="radio" name="contractNoType" value="3" checked />独立账户<input type="radio" name="contractNoType" value="4">公共账户
		</td>
	</tr>
</TABLE>


<table cellSpacing=0 id="Good_PhoneDate_GSM"  style="display:none" >
	<TR >
								<TD nowrap class=blue >
									<div align="left">特殊号码过户限制</div>
								</TD>
								<TD nowrap >
									<select name ="GoodPhoneFlag" >
										<!--option class='button' value='Y' >允许过户</option-->
										<option class='button' value='N' selected>不允许过户</option>
									</select>
								</TD>
								
								<TD nowrap class=blue >
									<div align="left" >可办理过户的时间</div>
								</TD>
								<TD nowrap >
									<input id="GoodPhoneDate"  name="GoodPhoneDate" maxlength="8"    value="20500101" readOnly class="InputGrey" >
									<font class="orange">*(格式YYYYMMDD)</font>&nbsp;&nbsp;
								</TD>
							 
							</TR>
	</table>

<table cellSpacing=0 id="pt_PhoneDate_GSM"   style="display:none">
	<TR >
								<TD nowrap class=blue >
									<div align="left">号码过户限制</div>
								</TD>
								<TD nowrap >
									<select name ="ptPhoneFlag" onchange="setPtPDate()">
										<option class='button' value='Y' selected>允许过户</option>
										<option class='button' value='N' >不允许过户</option>
									</select>
								</TD>
								
								<TD nowrap class=blue >
									<div align="left" >可办理过户的时间</div>
								</TD>
								<TD nowrap >
									<input id="ptPhoneDate"  name="ptPhoneDate" maxlength="8"  v_format="yyyyMMdd" v_type="date" readOnly >
									<font class="orange">*(格式YYYYMMDD)</font>&nbsp;&nbsp;
								</TD>
							 
							</TR>
	</table>
	
<!--hejwa 增加 过户限制 dgoodphoneres 表中有记录 显示 传服务-->
<SCRIPT language=JavaScript>
	
	function isGoodPhoneF(selNumValue){
		var isGoddNo_Packet = new AJAXPacket("isGoodPhoneres.jsp","正在获得绑定附加资费，请稍候......");
	 			isGoddNo_Packet.data.add("selNumValue",selNumValue);
	 			core.ajax.sendPacket(isGoddNo_Packet,doIsGoodPhoneF);
	 			isGoddNo_Packet=null; 
	}
	
	function doIsGoodPhoneF(packet){
			var countGoodNo = packet.data.findValueByName("countGoodNo");
			var innetType = $("#innetType").val();
			
			if(countGoodNo!=0){
					document.all.Good_PhoneDate_GSM.style.display = "";		
					document.all.pt_PhoneDate_GSM.style.display = "none";		
				}else{
					document.all.Good_PhoneDate_GSM.style.display = "none";		
					if(innetType=="01"){//普通号码入网才显示
						document.all.pt_PhoneDate_GSM.style.display = "";		
					}
				}
		}
		
		
$(document).ready(function () {
	isGoodPhoneF(document.all.selNum.value);
});

</SCRIPT>
<!--结束-->	
<table cellSpacing=0>	
	<TR>
		<td class="blue" width=9%>账号ID </td>
	  <TD><input type="text" name="contractNo" id="contractNo" class="required for0_9" size="16" maxlength="14" readonly>
	  <input type="button" class="b_text" value="获得" id="btn_getConNo" onClick="getContractNo()"> <font class="orange">*</font>  
	  <td></td> <td></td>
	  </TD>
	   
	</TR>
</TABLE>



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

<div id="serviceOrderInfo">
	<%@ include file="/npage/common/qcommon/serviceOrderInfo.jsp" %>	
</div>

<%@ include file="/npage/common/qcommon/bd_0007.jsp" %>	<!--sys_note op_note-->

<div id="people_info"><!--担保人,经办人等的信息-->
<DIV class=input>
	<table cellSpacing=0>
		<tr>
			<td  class="blue"  >开户方式</td>
			<td>
				<select id='khType' name='khType' style='width:90%'  onChange="kaihfss()">
					<option value="$$$$$$">---请选择---</option>
					<option value="0">0-->正常开户</option>
					<option value="1">1-->销户找回</option>
				</select>
				<font color='orange'>*</font>
			</td>
			<td id="showandhide1" class="blue" style='display:none'>分散账期</td>
			<td>
				<select id='fszqVal' name='fszqVal' style='width:90%;display:none' >
					<option value="" selected>---请选择---</option>
					<option value="1">1-->是</option>
					<option value="0">0-->否</option>
				</select>
			</td>
			<td class="blue" colspan=2>
				<input type="checkbox" value="5" name="contact_type" v_div="vouch" onclick="check_o(this)">担保人&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" name="servsla_info" v_div="servsla" onclick="check_o(this)">服务SLA信息&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>	
</table>
</DIV>
<div id="vouch" style="display:none">
    <%@ include file="/npage/common/qcommon/bd_0008.jsp" %>
</div>
<div id="servsla" style="display:none">
    <%@ include file="/npage/common/qcommon/bd_0019.jsp" %>
</div> 
</DIV>

</div>
</div><!--people_info end-->


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
<!-- 附加销售品 结束-->
<jsp:include page="/npage/public/hwReadCustCard.jsp">
	<jsp:param name="hwAccept" value="<%=sysAcceptl%>"  />
	<jsp:param name="showBody" value="01"  />
</jsp:include>
	<table cellSpacing=0  align="center">
		<tr id="footer"  align="center">
			 <td align="center"> 
		<INPUT class=b_foot_long id="cfmBtn" onClick="mySub()" type=button value=确定&打印 />
		<INPUT class=b_foot_long id="cfmOffer" onClick="cfmOfferf()" type=button value=销售品选择确认  style="display:none" />
		<INPUT class=b_foot onclick="ignoreThis()" type=button value=忽略> 
		<INPUT class=b_foot onclick="removeCurrentTab()" type=button value=取消> 
	</td>
</tr>
</table>
<input type="hidden" name="offerId" value="<%=offerId%>" />
<input type="hidden" name="majorProductId"/>
<input type="hidden" name="assureId" value="0"/><!--客户担保人标识-->
<input type="hidden" name="assureNum" value="0"/><!--已担保人数量-->
<input type="hidden" name="custOrderId" value="<%=custOrderId%>"/>
<input type="hidden" name="orderArrayId" value="<%=orderArrayId%>"/>
<input type="hidden" name="servOrderId" value="<%=servOrderId%>"/>
<input type="hidden" name="servBusiId" value="<%=servBusiId%>"/>
<input type="hidden" name="gCustId" value="<%=gCustId%>"/>
<input type="hidden" name="opCode" value="<%=opCode%>"/>
<input type="hidden" name="opName" value="<%=opName%>"/>
<input type="hidden" name="addrId" value="" />
<input type="hidden" name="brandId" value="<%=brandID%>" />
<input type="hidden" name="prtFlag" value="<%=prtFlag%>"/>
<input type="hidden" name="regionCode" value="<%=regionCode%>"/>
<input type="hidden" name="mastServerType" id="mastServerType" />
<input type="hidden" name="serviceType" id="serviceType" />
<input type="hidden" name="printAccept" id="printAccept" />
<input type="hidden" name="IVPNMemberId" id="IVPNMemberId" />
<input type="hidden" name="selByWay" id="selByWay" />
<input type="hidden" name="innetType" id="innetType" />
<input type="hidden" name="workNo" value="<%=workNo%>"/>
<input name=cardtype_bz type=hidden value="s">
<input type="hidden" name="sonParentArr"/>
<input type="hidden" name="closeId" value="<%=closeId%>"/>
<input name=writecardbz type=hidden value="">
<input name="cardstatus" type=hidden value="">
<!--销售品信息-->
<input type="hidden" name="offerIdArr"/>
<input type="hidden" name="offerEffectTime"/>
<input type="hidden" name="offerExpireTime"/>
<!--产品信息-->
<input type="hidden" name="productIdArr" />
<input type="hidden" name="prodEffectDate"/>
<input type="hidden" name="prodExpireDate"/>
<input type="hidden" name="isMainProduct"/>


<input type="hidden" name="newSmCode" value="<%=sm_Code%>"/>

<input type="hidden" name="offer_productAttrInfo"/><!--属性信息-->

<!--群组信息-->
<input type="hidden" name="groupInstBaseInfo"/>
<input type="hidden" name="addGroupIdArr"/><!--组合产品过来的可选群组-->

<!--批量开户-->
<input type="hidden" name="phoneNoStr" id="phoneNoStr"/>
<input type="hidden" name="simNoStr" id="simNoStr" />
<input type="hidden" name="chFeeList" id="chFeeList" />
<input type="hidden" name="psfileName" />
<input type="hidden" name="simFlag" value="0" />

<!--销售品选择方式相关参数-->
<input type="hidden" name="selOfferType" />
<input type="hidden" name="saleMode" />
<input type="hidden" name="imeiNo" />
<input type="hidden" name="goodType" />
<input type="hidden" name="sellGroupId" />
<input type="hidden" name="blindAddCombo" id="blindAddCombo" />

<input type="hidden" name="sysAcceptl" id="sysAcceptl" value="<%=sysAcceptl%>" /> <!--流水-->

<input type="hidden" name="groutDesc" id="groutDesc" value="" /> <!--流水-->
<input type="hidden" name="offId" id="offId" value="<%=offerId%>" />

<input type="hidden" name="modedxpay" id="modedxpay"   />
<input type="hidden" name="prepayFee" id="prepayFee"   />
<input type="hidden" name="isGoodNo" id="isGoodNo"   />
<input type="hidden" name="simTypeCfm" id="simTypeCfm"   />
<input type="hidden" name="simCodeCfm" id="simCodeCfm"   />

<input type="hidden" name="newZOfferECode"/>
<input type="hidden" name="newZOfferDesc"/>                         
<input type="hidden" name="dOfferId"/>
<input type="hidden" name="dOfferName"/>
<input type="hidden" name="dECode"/>
<input type="hidden" name="dOfferDesc"/>
<input type="hidden" name="path"/> <!-- yanpx add 添加打印使用隐藏变量-->

<input type="hidden" name= "largess_card_sum" value="<%=strCardSum%>"> <!-- 入网赠送充值卡的数量级-->
<input type="hidden" name="groupId" value="<%=groupId%>"/>

<input type="hidden" id="work_flow_no" name="work_flow_no" value="<%=work_flow_no%>"/>
<input type="hidden" id="level4100" name="level4100" value="<%=level4100%>"/>
<input type="hidden" id="transJf" name="transJf" value="<%=transJf%>"/>
<input type="hidden" id="transXyd" name="transXyd" value="<%=transXyd%>"/>

<input type="hidden" id="isGPhoneFlag" name="isGPhoneFlag" value=""/>
<input type="hidden" id="isGPhoneDate" name="isGPhoneDate" value=""/>
<input type="hidden" id="flag" name="flag" value="true"/> <!-- 20101206 caohq add TD固话不能办理漫游业务-->


<%@ include file="/npage/include/footer_new.jsp" %>
</FORM>
  <frameset rows="0,0,0,0" cols="0" frameborder="no" border="0" framespacing="0" >
  <frame src="../common/evalControlFrame.jsp"    name="evalControlFrame" id="evalControlFrame" />
</frameset>
</DIV>
</BODY>
<%@ include file="/npage/public/hwObject.jsp" %> 
</HTML>
