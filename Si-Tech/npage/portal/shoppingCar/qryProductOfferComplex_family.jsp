<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GB2312"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ taglib uri="/WEB-INF/wtc.tld" prefix="wtc" %>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UType"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UtypeUtil"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UElement"%>
 
<%
	System.out.println("----销售品选择-------qryProductOfferComplex.jsp--------------");
	String orgCode = (String)session.getAttribute("orgCode");
	String regionCode = orgCode.substring(0,2);
	String band_id = WtcUtil.repNull(request.getParameter("band_id"));//品牌ID
	String workNo = (String) session.getAttribute("workNo");
	String groupId=(String)session.getAttribute("groupId");//员工归属节点
	String [][] goodTypeInfo=new String[1][8];
	String fuCardSql = " select count(1)  from dchngroupmsg   where group_id='"+groupId+"'   and class_code in (select msg.class_code  from schnclassmsg msg, schnclassinfo info where msg.class_code = info.class_code and info.parent_class_code = 'fail')";
	
	System.out.println("fuCardSql--"+fuCardSql);
	
	String opName = "销售品选择";
	String opCode = WtcUtil.repNull(request.getParameter("opCode"));//品牌ID
	
	System.out.println("-------------------opCode-------------------"+opCode);
%>
<wtc:pubselect name="sPubSelect" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
  <wtc:sql><%=fuCardSql%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result_Card" scope="end"/>
<%
String cardLimit = "0";
if(result_Card.length>0&&result_Card[0][0]!=null){
	cardLimit = result_Card[0][0];
}
%>	 	
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>销售品选择</title>
<style>
	html,
	body
	{
		overflow-x:hidden
	}
</style>
<link href="<%=request.getContextPath()%>/nresources/default/css/spCar.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/nresources/default/css/products.css" rel="stylesheet"type="text/css">
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/njs/extend/mztree/stTree.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/si/validate_class.js"></script>
<script language="javascript" type="text/javascript">
var flag;
var goodKind = ""; //特殊号码类型
var mf_flag = "0"; // 点击收藏夹tr 标志
var mf_flag1 = "1"; // 点击收藏夹校验成功 标志

$(document).ready(function () {
	  addSmCode();
		setOfferType();
		addRegCode();
		queryByNomal();
		var band_id = "<%=band_id%>";
		if(band_id!="")
		{
			flag=true;//表示返回单条记录
			$("#smCode").val("<%=band_id%>");
			$("#smCode").attr("disabled",true);
			myFavorite();
		  hotOffer();
		}else{ //表示从购物车页面过来
			flag=false;//表示返回多条记录
		  //myFavorite();
		  //hotOffer();
		}
});

function retQ08Flag(){
		 var query08Flag = false;
			<%
			System.out.println("======================" + cardLimit);
			if(Integer.parseInt(cardLimit)  > 0 && !opCode.equals("4977") && !opCode.equals("e887")){%>//显示的时候对其赋值
				//query08Flag = document.all.query08.checked;
			<%}%>
			return query08Flag;
}
//将选择的销售品信息返回到购物车
function cfm()
{	
	var productOfferTab = g("productOfferList");
	var rowNum = productOfferTab.rows.length;
	if(rowNum<=1)
	{
		rdShowMessageDialog("请您选择销售品!");
	}
	else
	{
		/*
		var resultList = new Array();
		
		for(var n=1;n<rowNum;n++)
		{
			var tempArray = new Array();
			for(var m=0;m<=3;m++)
			{
				tempArray[m] = productOfferTab.rows[n].cells[m].innerHTML;
			}
			resultList.push(tempArray);
		}
		*/
		var resultList
		var tabID="productOfferList";
		var lineV="5";
		var lineHid ="4";
		
		resultList = getTableData(tabID,lineV,lineHid);
		
		//window.returnValue = resultList;
		opener.resultProcess(resultList);
		window.close();
	}
}

//取得服务类型ID(servBusID)
function getServBusId(offer_id){
			var packet = new AJAXPacket("getServBusId.jsp","请稍后...");
			packet.data.add("offer_id" ,offer_id);
			core.ajax.sendPacket(packet,getMebAttr);
	}
function getMebAttr(packet){
	var backArrMsg =packet.data.findValueByName("backArrMsg");
	var retMsg=retMsg =packet.data.findValueByName("retMsg");
	if(backArrMsg==null || backArrMsg==""){
			backArrMsg="";
		}
	document.frmMain.servBusId.value=backArrMsg;
	document.frmMain.retMsg.value=retMsg;
	}
//查询附加销售品信息(按属性)
function productOfferQryByAttr()
{
		if(document.all.offerCode.value!=""){
		 	if(!forInt(document.all.offerCode)) return false;
		}
		
		if (productOfferQueryList.style.display = "none")
		{
			productOfferQueryList.style.display = "block";
		//按照所选择的属性信息查询
		var offerCode = document.frmMain.offerCode.value;//销售品编码
		var offerName =document.frmMain.offerName.value;//销售品名称 
		var offerType =document.frmMain.offerType.value;//销售品类型
		var offerAttrSeq = "";//销售品属性标识 
		var custGroupId = "";//客户群标识
		var channelSegment="";//渠道类型标识
		var group_id=document.frmMain.receiveRegion.value;//区域编号
		var band_id= document.frmMain.smCode.value;//品牌标识
		var offer_att_type=document.all.offer_att_type.value;//销售品分类标识
		var retQ08_flag=retQ08Flag();
		if(retQ08_flag)
		{
			retQ08_flag="1";
		}else
		{
			retQ08_flag="0";
		}
		var packet = new AJAXPacket("ajax_productOfferQryByAttr.jsp","请稍后...");
		packet.data.add("offerCode" ,offerCode);
		packet.data.add("offerName" ,offerName);
		packet.data.add("offerType" ,offerType);
		packet.data.add("offerAttrSeq" ,offerAttrSeq);
		packet.data.add("custGroupId" ,custGroupId);
		packet.data.add("channelSegment" ,channelSegment);
		packet.data.add("group_id" ,group_id);
		packet.data.add("band_id" ,band_id);
		packet.data.add("offer_att_type" ,offer_att_type);
		packet.data.add("goodFlag" ,"1");
		packet.data.add("retQ08_flag" ,retQ08_flag);
		packet.data.add("opCode" ,"<%=opCode%>");
		core.ajax.sendPacket(packet,doProductOfferQryByAttr);
		packet =null;
		}
}

//回调方法
function doProductOfferQryByAttr(packet)
{
	var goodNo = document.frmMain.goodNo.value.trim();
	var goodType= document.frmMain.goodNoBlind.value;
					
  var selectValue = document.frmMain.selectValue.value;//查询方式的value
	var qryRetCode = packet.data.findValueByName("retCode"); 
	var qryRetMsg = packet.data.findValueByName("retMsg"); 
	var retResult = packet.data.findValueByName("retResult");
	document.getElementById("productOfferQueryList").style.display="";
	document.getElementById("queryOfferList").style.display="";
	var serv_bus_id =document.frmMain.servBusId.value;//取得服务类型ID，servBusId
	var tableId=g("queryOfferList");
	var rowNum = tableId.rows.length;
	if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
	if(retResult==null||retResult==""){
		rdShowMessageDialog("没有查询到您所需的数据3");
		}else{
				if(qryRetCode==0){
				for(var i=0;i<retResult.length;i++){
					var arrTdCon=new Array(retResult[i][0],retResult[i][1],retResult[i][6],"<div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004|"+selectValue+"</span>");
					//var arrTdCon=new Array(retResult[i][0],"<span id='td_"+retResult[i][0]+"'>"+retResult[i][1]+"</span>",retResult[i][6],"<div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|40013|20004|"+selectValue+"</span>");
					//addTrOver("queryOfferList","1",arrTdCon,1,"f5f5f5");
					$("#queryOfferList").append("<tr id='queryOfferList"+"_tr_td"+i+"' onclick='clickTr()' style='cursor:pointer;'><td>"+retResult[i][0]+"</td><td id='"+codeChg("queryOfferList"+"td_"+retResult[i][0])+"'>"+retResult[i][1]+"</td><td>"+retResult[i][6]+"</td><td><div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004|"+selectValue+"</span></td>");
					getMidPrompt("10442",retResult[i][0],codeChg("queryOfferList"+"td_"+retResult[i][0]));	
    			}
				}
			}
						//将原来的查询条件置为“”
			document.frmMain.offerName.value="";
			document.frmMain.offerCode.value="";
			
			
}
//从查询列表中点击绑定事件后，把选中的信息添加到另一个列表
var reCodeAdd = "";
var reMsgAdd = "";
function clickTr()
{
	var e = arguments[0] || window.event;
	var trCur = e.srcElement.parentNode || e.target.parentNode;
	//if(trCur.getElementsByTagName("td").length==0) return;
	var offerid = trCur.getElementsByTagName("td")[0].innerHTML;
	//调用服务取得servBusId
	getServBusId(offerid);
	    //从查询列表中取得所需列的数据
		 var xiaoxpCode=trCur.getElementsByTagName("td")[0].innerHTML;//销售品代码
	    var xiaoxpName=trCur.getElementsByTagName("td")[1].innerHTML;//x销售品名称
	    var bandName=trCur.getElementsByTagName("td")[2].innerHTML;	    //品牌名称
	   // var offer_comments=trCur.getElementsByTagName("td")[3].innerHTML.split("|")[1];//销售品描述
	    
	    //切割最后一列，取得所要的销售品描述数据
	    //var index = offerComments.indexOf('<');
	    //var offer_comments = offerComments.substring(0,index);
	    var band_id = document.frmMain.smCode.value;//品牌标识
	    //取得最后一列中，所包含在span中的数据，并切割
	    var tdObj =trCur.getElementsByTagName("td")[3];
	    var offer_comments=tdObj.getElementsByTagName("div")[0].innerHTML
	    var spanH=tdObj.getElementsByTagName("span")[0].innerHTML;
		var spanHVs=spanH.split('|'); 
		//var exp_date_offset=spanHVs[0];//失效时间偏移量
		//var exp_date_offset_unit = spanHVs[1];//失效时间偏离单位
		//var offer_type = spanHVs[2];//销售品类型
		//var retKey = spanHVs[3];//查询方式~手机串号/特殊号码~/租机模板/特殊号码类型拼接成的串
		//var retValue = spanHVs[4];//查询方式~手机串号/特殊号码~/租机模板/特殊号码类型的值，拼接成的串
		
		var exp_date_offset=spanHVs[3];//失效时间偏移量
		var exp_date_offset_unit = spanHVs[4];
		var offer_type = spanHVs[5];          
		var retKey = spanHVs[6];              
		var retValue = spanHVs[7];  	
			
		var serv_bus_id =document.frmMain.servBusId.value;//取得服务类型ID，servBusId

//		var retArr=chkLimit(xiaoxpCode,"1").split("@")
//		retCo=retArr[0].trim();
//		retMg=retArr[1];
//		
//		if(retCo!="0" )
//		{		
//			if(retCo=="110001"){
//		     	 if(rdShowConfirmDialog(retMg)!=1) return false;
//		  }else{
//		  		 rdShowConfirmDialog(retMg);
//		  		 return false;
//		  	}
//		}		
		if(mf_flag == "1"){
			pOfferQryByAttrLimit(xiaoxpCode);
		}
		if(mf_flag1 == "0"){
		return false;	
	  }
		ajaxGetLimitAdd(offerid);//  增加限制 hejwa add 2010年2月8日14:05:20
		if(reCodeAdd!="0"){
				rdShowMessageDialog(reCodeAdd+":"+reMsgAdd);
				return false;
		} 
		if(serv_bus_id==""){
					var msg =document.frmMain.retMsg.value;
					rdShowMessageDialog(msg);
					return false;
			}
			var delBut="";
			
			if(typeof(retKey) == "undefined" || typeof(retValue) == "undefined"){
				 delBut="<INPUT class=b_text id=but_add onclick='delTr();' type=button value=删除><span style='display:none'>"+band_id+"|"+offer_comments+"|"+exp_date_offset+"|"+exp_date_offset_unit+"|"+offer_type+"|"+serv_bus_id+"</span>";
				}else{
					 delBut="<INPUT class=b_text id=but_add onclick='delTr();' type=button value=删除><span style='display:none'>"+band_id+"|"+offer_comments+"|"+exp_date_offset+"|"+exp_date_offset_unit+"|"+offer_type+"|"+serv_bus_id+"|"+retKey+"|"+retValue+"</span>";
					}
		
 
		if(retQ08Flag()==true){
				delBut += "<INPUT class='b_text' id=but_add onclick='saveOffer("+offerid+");' type=button value=收藏>";
			}
				
							
			var arrTdCon=new Array(xiaoxpCode,xiaoxpName,bandName,"<div nowrap title="+offer_comments+">"+offer_comments.substring(0,20)+"..."+"</div>","<input type='hidden' id='"+offerid+"'/>"+delBut);
			if(flag){
				var tableId=g("productOfferList");
				var rowNum = tableId.rows.length;
				if(rowNum>1){
					for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
					}
				}
			}
			
			if(checkProductOfferList(offerid,"productOfferList"))
		    {
				if($("#productOfferList tr").length >1){
		    	if(rdShowConfirmDialog("您已经选择了一个销售品，要替换已有的销售品么？") == 1){
		    		$("#productOfferList tr").eq(1).remove();
		    		addTrOver("productOfferList","1",arrTdCon);
		    		getMidPrompt("10442",xiaoxpCode,codeChg("productOfferList"+"td_"+xiaoxpCode));	
		    	} 
		    }else{
		    	addTrOver("productOfferList","1",arrTdCon);	
		    	getMidPrompt("10442",xiaoxpCode,codeChg("productOfferList"+"td_"+xiaoxpCode));	
		    }
			}
}


function pOfferQryByAttrLimit(xiaoxpCode)
{
		if (productOfferQueryList.style.display = "none")
		{
		//按照所选择的属性信息查询
		var offerCode = xiaoxpCode;
		var offerName ="";
		var offerType =document.frmMain.offerType.value;//销售品类型
		var offerAttrSeq = "";//销售品属性标识 
		var custGroupId = "";//客户群标识
		var channelSegment="";//渠道类型标识
		var group_id=document.frmMain.receiveRegion.value;//区域编号
		var band_id= "";
		var offer_att_type="";
		
		var packet = new AJAXPacket("ajax_productOfferQryByAttr_m.jsp","请稍后...");
		packet.data.add("offerCode" ,offerCode);
		packet.data.add("offerName" ,offerName);
		packet.data.add("offerType" ,offerType);
		packet.data.add("offerAttrSeq" ,offerAttrSeq);
		packet.data.add("custGroupId" ,custGroupId);
		packet.data.add("channelSegment" ,channelSegment);
		packet.data.add("group_id" ,group_id);
		packet.data.add("band_id" ,band_id);
		packet.data.add("offer_att_type" ,offer_att_type);
		packet.data.add("goodFlag" ,"1");
		packet.data.add("opCode" ,"<%=opCode%>");
		core.ajax.sendPacket(packet,doPOfferQryByAttrLimit);
		packet =null;
		}
}

function doPOfferQryByAttrLimit(packet){
	var qryRetCode = packet.data.findValueByName("retCode"); 
	var qryRetMsg = packet.data.findValueByName("retMsg"); 
	var retResult = packet.data.findValueByName("retResult");
	 if(retResult==null||retResult==""||retResult.length==0){
		rdShowMessageDialog("此工号没有操作权限，请重新选择",0);
			mf_flag1 = "0";
			return false;	
		}else{
			mf_flag1 = "1";	
		}
}
//点击树节点触发事件

function ajaxGetLimitAdd(offerId){
	var packet = new AJAXPacket("ajax_LimitAdd.jsp","请稍后...");
			packet.data.add("offerId" ,offerId);
			packet.data.add("opCode" ,"<%=opCode%>");
			core.ajax.sendPacket(packet,doAjaxGetLimitAdd);
			packet =null;
}

function doAjaxGetLimitAdd(packet){
	  reCodeAdd = packet.data.findValueByName("retCode"); 
		reMsgAdd = packet.data.findValueByName("retMsg"); 
}

//校验已选列表中是否已经存在选项
function checkProductOfferList(productOfferID,tableID)
{
	var tableId=g(tableID);
	var rowNum = tableId.rows.length;
	
	for(var i=0;i<rowNum;i++)
	{
		var temp = tableId.rows[i].cells[0].innerHTML;
		
		if(temp==productOfferID)
		{
			return false;
		}
	}
	
	return true;

}

function HoverLi(n,t){
	for(var i=1;i<=t;i++)
	{
		g('tb_'+i).className='normaltab';
		g('tbc_0'+i).className='mztree';
		g('tbc_0'+i).style.display="none"
	}
	g('tbc_0'+n).className='unmztree';
	g('tb_'+n).className='hovertab';
	g('tbc_0'+n).style.display="block"
}	
//根据普通方式查询
function queryByNomal(){
	resetInfo();
	document.frmMain.result2.value = "";	
	document.all.trFGoodNo.style.display="none";
	document.all.trFGoodNo1.style.display="none";
	
	goodKind = "P";
	var flag=document.frmMain.good.value;
	if(flag=="130"){
				document.frmMain.good.value="";
		}
	getSelectFlag();
	document.getElementById("normal").style.display="block";
	document.getElementById("betterNo").style.display="none";
	document.getElementById("rentMac").style.display="none";
	document.getElementById("queryOfferList").style.display="block";
	document.getElementById("hotOfferQueryList").style.display="block";
	document.getElementById("myFavoriteList").style.display="block";
	var productOfferTab = g("productOfferList");
	var rowNum = productOfferTab.rows.length;
	if(rowNum>1)
	{
		for(var i=1;i<rowNum;i++)
					{
						delTr("productOfferList","1");
					}	
	}
	
	var tableId=g("queryOfferList");
			document.getElementById("queryOfferList").style.display="none";
			document.getElementById("productOfferQueryList").style.display="none";
			var rowNum = tableId.rows.length;
			if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    } 
	    myFavorite();
			hotOffer();
}
	//根据特殊号码方式查询
	function queryByGoodNo(){
		resetInfo();
	document.getElementById("myFavoriteList").style.display="none"; //收藏夹
  document.getElementById("hotOfferQueryList").style.display="none";  //热点销售品
	getSelectFlag();
	document.getElementById("normal").style.display="none";
	document.getElementById("betterNo").style.display="block";
	document.getElementById("rentMac").style.display="none";
	document.getElementById("queryOfferList").style.display="none";
	var productOfferTab = g("productOfferList");
	var rowNum = productOfferTab.rows.length;
	if(rowNum>1)
	{
			for(var i=1;i<rowNum;i++)
					{
						delTr("productOfferList","1");
					}	
	}
	}
	//根据租机入网方式查询
	function queryByRentMac(){
	goodKind = "";
	getSelectFlag();
	document.getElementById("myFavoriteList").style.display="none"; //收藏夹
  document.getElementById("hotOfferQueryList").style.display="none";  //热点销售品
	document.getElementById("normal").style.display="none";
	document.getElementById("betterNo").style.display="none";
	document.getElementById("rentMac").style.display="block";
	document.getElementById("queryOfferList").style.display="block";
	var productOfferTab = g("productOfferList");
	var rowNum = productOfferTab.rows.length;
	if(rowNum>1)
	{
		for(var i=1;i<rowNum;i++)
					{
						delTr("productOfferList","1");
					}	
	}
	
	var tableId=g("queryOfferList");
			document.getElementById("queryOfferList").style.display="none";
			document.getElementById("productOfferQueryList").style.display="none";
			var rowNum = tableId.rows.length;
			if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
	    
	}
	//取得选择查询方式的Value
	function getSelectFlag(){
		var flags = document.getElementsByName("query");
		var selectValue;
		if(flags.length>0){
			for(var i=0;i<flags.length;i++){
				if(flags[i].checked==true){
					selectValue=flags[i].value;
					}
				}
				document.frmMain.selectValue.value= selectValue;
			}
		}
	//根据机器串号得到相关信息
	var modeCode="";
	function getImei(){	
  	if(document.frmMain.imeiNo.value.length == 0)
    {
        rdShowMessageDialog("请输入机器串号",0);
        return false;
    }
    var imeiNo=document.frmMain.imeiNo.value;
    var pageTitle = "手机串号信息查询";
    var fieldName = "模版编码|模版名称|合同期限(月)|销售价格(元)|在网年限(月)|押金(元)|在网金额(元)|预存话费(元)|月消费底线(元)|绑定资费|本地话费比率|";
    var sqlStr = "select c.sale_mode,c.mode_name,c.contract_months,c.sale_price,c.exists_months,c.deposit_money,c.contract_money,c.prepay_fee,c.payoff_rate,c.bind_mode,c.inland_rate,c.bind_mode,c.res_price from dChnResMobInfo a,sChnResBindModeItem b,sChnResSaleMode c, schnresstatusswitch d ,sChnResBindMode rb, dchngroupinfo gi where   c.rent_type ='0' and  b.bind_mode=rb.bind_mode and c.is_valid=1 and rb.is_valid=1 and sysdate between c.begin_time and c.end_time and sysdate between rb.begin_time and rb.end_time and trim(a.imei_no)=trim(upper('"+imeiNo+"')) and a.res_code=b.res_code and b.bind_mode=c.bind_mode and c.group_id in(select parent_group_id from dChnGroupInfo where group_id='"+"<%=groupId%>"+"') and c.sale_type = '0' and a.status_code=d.src_status and a.kind_code=d.kind_code and d.func_type='0' and d.func_code='1109' and a.group_id=gi.group_id and gi.parent_group_id='"+"<%=groupId%>"+"'"; 	
    
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "13|0|1|2|3|4|5|6|7|8|9|10|11|12|";
    var retToField = "imeiString|";
    custInfoQuery(pageTitle,fieldName,sqlStr,selType,retQuence,retToField); 
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
    var path = "ajax_qryModelByMacNo.jsp";   //密码为*
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    
    var imeiNo=document.all.imeiNo.value;
    path = path + "&imeiNo=" + imeiNo ;
    path = path + "&regionCode=" + "<%=regionCode%>" ;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;  
    
	  var obj33 = frmMain;
    retInfo = window.showModalDialog(path,obj33,"dialogWidth:50;dialogHeight:40;");
	
    if(typeof(retInfo) == "undefined")     
    {   
    	return false;   
    }
    var chPos_field = retToField.indexOf("|");
    var chPos_retStr;
    var valueStr;
    var obj;
    
    document.frmMain.contractInfo.value =retInfo;
}
//根据租机返回信息查询出销售品列表
function qryByRentMac(){
	if(document.frmMain.imeiNo.value.trim()=="" || document.frmMain.hid_sale_mode.value.trim()==""){
		rdShowMessageDialog("该串号不存在，请重新输入");
		return false;
		}
	 if(productOfferQueryList.style.display = "none")
		  {
			productOfferQueryList.style.display = "block";
			var sale_mode = document.frmMain.hid_sale_mode.value;
			var packet = new AJAXPacket("ajax_qryProductOfferByRentInfo.jsp","请稍后...");
			packet.data.add("sale_mode" ,sale_mode);//模板ID
			core.ajax.sendPacket(packet,doProductOfferByRentInfo);
			packet =null;
			}
	}
	function doProductOfferByRentInfo(packet){
		var selectValue = document.frmMain.selectValue.value;
		var saleMode = document.frmMain.hid_sale_mode.value;
		var imeiNo = document.frmMain.imeiNo.value;
			var qryRetCode = packet.data.findValueByName("retCode"); 
			var qryRetMsg = packet.data.findValueByName("retMsg"); 
			var retResult = packet.data.findValueByName("retResult");
			var tableId=g("queryOfferList");
			var rowNum = tableId.rows.length;
						if(rowNum>1){
			      	     for(var i=2;i<=rowNum;i++){
										tableId.deleteRow();
					        }
				        }
			if(retResult==null||retResult==""){
				rdShowMessageDialog("没有查询到您所需的数据4");
				}else{
						if(qryRetCode==0){
						for(var i=0;i<retResult.length;i++){
							var arrTdCon=new Array(retResult[i][0],"<span id='td_"+retResult[i][0]+"'>"+retResult[i][1]+"</span>",retResult[i][3],"<div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][4]+"|"+retResult[i][5]+"|"+retResult[i][6]+"|20004~20005~20006|"+selectValue+"~"+imeiNo+"~"+saleMode+"</span>");
							addTrOver("queryOfferList","1",arrTdCon,1,"f5f5f5");
							getMidPrompt("10442",retResult[i][0],codeChg("queryOfferList"+"td_"+retResult[i][0]));	
							}
						}
					}
		}
	function resetInfo(){
				document.getElementById("queryInfo2").disabled=false;
				document.getElementById("queryFirst").disabled=false;
				//清空已选销售品列表
//				var productOfferTab = g("productOfferList");
//				var rowNum = productOfferTab.rows.length;
//				if(rowNum>1)
//				{
//					for(var i=1;i<rowNum;i++)
//					{
//						delTr("productOfferList","1");
//					}	
//				} 
							
				//将普通查询条件置空
				document.frmMain.offerName.value="";
				document.frmMain.offerCode.value="";
				//将租机入网条件查询置空
				
				document.frmMain.imeiNo.value="";
				document.frmMain.contractInfo.value="";
				document.frmMain.rentDeposit.value="";
				document.frmMain.rentCostPre.value="";
				//将特殊号码查询信息置空						
				document.all.goodNo.value = "";
				document.frmMain.goodNoBlind.value="";
				document.frmMain.blindCost.value="";
				document.frmMain.blindNetPre.value="";
				document.frmMain.blindBackMonth.value="";
				document.frmMain.blindNetDeposit.value="";
				document.frmMain.blindContractDate.value="";
				document.frmMain.blindAddCombo.value="";
				document.frmMain.blindSpecialSevice.value="";		
				setOnloadF();
				}
	//根据特殊号码查询出特殊号码类型
	function getGoodNo(){
		 
 		var goodno = document.all.goodNo.value;
		
			var tableId=g("queryOfferList");
			document.getElementById("queryOfferList").style.display="none";
			document.getElementById("productOfferQueryList").style.display="none";
			var rowNum = tableId.rows.length;
			if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
	    
		
		var productOfferTab = g("productOfferList");
				var rowNum = productOfferTab.rows.length;
				if(rowNum>1)
				{
					for(var i=1;i<rowNum;i++)
					{
						delTr("productOfferList","1");
					}	
				} 
  	if(document.frmMain.goodNo.value.length == 0 || document.frmMain.goodNo.value.trim()=="请输入特殊号码")
    {
        rdShowMessageDialog("请输入特殊号码",0);
        return false;
    } 
    	
    var goodNo = document.frmMain.goodNo.value.trim();
    var path="isGoodNoExist.jsp?goodNo="+goodNo;
    retInfo = window.showModalDialog(path,window,"dialogWidth:600px;dialogHeight:300px;");
    if(retInfo=="11"){//表示该特殊号码被占用
    		document.frmMain.goodNo.value="请输入特殊号码";
    		document.frmMain.goodNo.focus();
    	  return false;
    	}else if(retInfo=="22"){//查询记录出错
    			rdShowMessageDialog("查询记录出错");
    			document.frmMain.goodNo.value="请输入特殊号码";
	    		document.frmMain.goodNo.focus();
	    	  return false;
    		}else if(retInfo=="00"){//表示该特殊号码可用
    		var packet = new AJAXPacket("ajax_qryGoodTypeByGoodNo.jsp","请稍后...");
    		packet.data.add("goodNo" ,goodNo);//特殊号码
				core.ajax.sendPacket(packet,doGetGoodNo);
				packet =null;
    	}
	}
	//回调函数
	function doGetGoodNo(packet){
			var qryRetCode = packet.data.findValueByName("retCode"); 
			var qryRetMsg = packet.data.findValueByName("retMsg"); 
			var retResult = packet.data.findValueByName("retResult");
			
			document.all.goodNo_new.value = document.all.goodNo.value;
			
			if(retResult==null||retResult==""){
						rdShowMessageDialog("没有查询到对应特殊号码信息");
						document.frmMain.goodNo.value="请输入特殊号码";
		    		document.frmMain.goodNo.focus();
		    	  return false;
			}else{
							//取得的信息为:0特殊号码类型，1特殊号码总费用，2绑定入网预存，3绑定分月返还，4绑定入网押金，5绑定合同期限，6绑定套餐，7特服,8绑定最低消费
							document.frmMain.goodNoBlind.value = retResult[0][0];
							document.frmMain.blindCost.value = retResult[0][1];
							document.frmMain.blindNetPre.value = retResult[0][3];
							document.frmMain.blindBackMonth.value = retResult[0][3];
							document.frmMain.blindNetDeposit.value = retResult[0][4];
							document.frmMain.blindContractDate.value = retResult[0][5];
							
							if(retResult[0][4]=="0"){
								document.frmMain.blindAddCombo.value ="";
							}else{
								document.frmMain.blindAddCombo.value = retResult[0][5]+"|"+ retResult[0][6];
								}
							
							document.frmMain.blindSpecialSevice.value = retResult[0][7];
							
							goodKind = retResult[0][9];
							
							document.frmMain.result2.value = retResult[0][2];
							document.frmMain.result8.value = retResult[0][8];
							document.frmMain.result9.value = retResult[0][9];
							document.frmMain.result10.value = retResult[0][10];
							document.frmMain.result11.value = retResult[0][11];
							document.frmMain.result12.value = retResult[0][12];
							document.frmMain.result13.value = retResult[0][13];
							document.frmMain.result14.value = retResult[0][14];
							
							 if(document.all.goodNo_new.value.substring(0,3)=="188"&&document.frmMain.blindCost.value=="1"){
							 	document.all.trFGoodNo.style.display="";
							 	document.all.trFGoodNo1.style.display="";
							 	ajaxSetSmCodef();
							  ajaxSetpType();
							 	}else{
							 	document.all.trFGoodNo.style.display="";
							 	document.all.trFGoodNo1.style.display="";
								ajaxSetSmCodef();
							  ajaxSetpType();
							  if(document.frmMain.result2.value =="P"){
								  myFavorite();
								  hotOffer();
								  document.getElementById("myFavoriteList").style.display=""; //收藏夹
	  							document.getElementById("hotOfferQueryList").style.display="";  //热点销售品
  							}
							}
					}
		}
		
		function qryByGoodNoType(){
				var productOfferTab = g("productOfferList");
				var rowNum = productOfferTab.rows.length;
				if(rowNum>1)
				{
					for(var i=1;i<rowNum;i++)
					{
						delTr("productOfferList","1");
					}	
				} 
			
			
			var selectValue = document.frmMain.selectValue.value;//查询方式的value
			//wangzc add
			//if(document.all.goodNo_new.value.substring(0,3)=="188"&&document.frmMain.blindCost.value=="1"){
				
				//if(productOfferQueryList.style.display = "none")
			 // {
				 // productOfferQueryList.style.display = "";
					//var packet = new AJAXPacket("ajax_getGoodNo_New.jsp","请稍后...");
	    		//packet.data.add("goodNo" ,document.all.goodNo_new.value);//特殊号码
	    		//packet.data.add("goodNotype" ,document.frmMain.goodNoBlind.value);   //wangzc
	    		//packet.data.add("goodNotype" ,document.frmMain.result2.value)
	    		//packet.data.add("result8" ,document.frmMain.result8.value);
					//core.ajax.sendPacket(packet,doqryByGoodNoType);
					//packet =null;
			  //} 
			  
				//}else{
					
							var offerCode = document.frmMain.offerCodeGood.value;//销售品编码
							var offerName =document.frmMain.offerNameGood.value;//销售品名称 
							var offerType =document.frmMain.offerType.value;//销售品类型
							var offerAttrSeq = "";//销售品属性标识 
							var custGroupId = "";//客户群标识
							var channelSegment="";//渠道类型标识
							var group_id=document.frmMain.receiveRegion.value;//区域编号
							var band_id= document.frmMain.smCodeFGood.value;//品牌标识
							var offer_att_type=document.all.offer_att_typeFGood.value;//销售品分类标识
							
							
							var packet = new AJAXPacket("ajax_productOfferQryByAttr.jsp","请稍后...");
							packet.data.add("offerCode" ,offerCode);
							packet.data.add("offerName" ,offerName);
							packet.data.add("offerType" ,offerType);
							packet.data.add("offerAttrSeq" ,offerAttrSeq);
							packet.data.add("custGroupId" ,custGroupId);
							packet.data.add("channelSegment" ,channelSegment);
							packet.data.add("group_id" ,group_id);
							packet.data.add("band_id" ,band_id);
							packet.data.add("offer_att_type" ,offer_att_type);
							packet.data.add("goodNotype" ,document.frmMain.result2.value);
							packet.data.add("goodFlag" ,"0");
							packet.data.add("opCode" ,"<%=opCode%>");
							core.ajax.sendPacket(packet,doProductOfferQryByAttrGood);
							packet =null;
			//}
		}
function doProductOfferQryByAttrGood(packet){
	var goodNo = document.frmMain.goodNo.value.trim();
	var goodType= document.frmMain.goodNoBlind.value;
					
  var selectValue = document.frmMain.selectValue.value;//查询方式的value
	var qryRetCode = packet.data.findValueByName("retCode"); 
	var qryRetMsg = packet.data.findValueByName("retMsg"); 
	var retResult = packet.data.findValueByName("retResult");
	document.getElementById("productOfferQueryList").style.display="";
	document.getElementById("queryOfferList").style.display="";
	var serv_bus_id =document.frmMain.servBusId.value;//取得服务类型ID，servBusId
	var tableId=g("queryOfferList");
	var rowNum = tableId.rows.length;
	if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
	if(retResult==null||retResult==""){
		rdShowMessageDialog("没有查询到您所需的数据3");
		}else{
				if(qryRetCode==0){
				for(var i=0;i<retResult.length;i++){
					$("#queryOfferList").append("<tr onclick='clickTr()' style='cursor:pointer;'><td id='queryOfferList"+"_tr1_td"+i+"'>"+retResult[i][0]+"</td><td id='"+codeChg("queryOfferList"+"td_"+retResult[i][0])+"'>"+retResult[i][1]+"</td><td id='queryOfferList"+"_tr1_td"+(i+2)+"'>"+retResult[i][6]+"</td><td id='queryOfferList"+"_tr1_td"+(i+3)+"'><div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|40013|20004~20007~20008|"+selectValue+"~"+goodNo+"~"+goodType+"</span></td>");
					getMidPrompt("10442",retResult[i][0],codeChg("queryOfferList"+"td_"+retResult[i][0]));	
    			}
				}
			}
						//将原来的查询条件置为“”
			document.frmMain.offerName.value="";
			document.frmMain.offerCode.value="";
			
			
}
/* 关于铁通78位TD无线座机用户限制发送短信功能的需求 */
<%
	String tdSql = "SELECT msg.class_code FROM dchngroupmsg msg WHERE msg.GROUP_ID = '" + groupId + "'";
	String inputParam = "214";
%>
 		<wtc:pubselect name="sPubSelect" outnum="1" retmsg="msgtd" retcode="codetd" 
 		 routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=tdSql%></wtc:sql>
 	  </wtc:pubselect>
	 <wtc:array id="tdresult" scope="end"/>
<%
	if(codetd.equals("000000")){
		if(tdresult != null && tdresult.length > 0){
			if(tdresult[0][0].equals("200") ){
				inputParam = "225";
			}
		}
	}
	if("4977".equals(opCode)){
		/* 如果是宽带开户，227 */
		inputParam = "227";
	}
	if("e887".equals(opCode)){
		/* 如果是IMS固话centrex，228 */
		inputParam = "228";
	}
	System.out.println("==== qryProductOfferComplex.jsp ===inputParam " + inputParam);
%>
		//特殊号码的品牌和销售品分类
			<wtc:service name="sDynSqlCfm" routerKey="region" routerValue="<%=regionCode%>" outnum="3">
    		<wtc:param value="<%=inputParam%>"/>
    		</wtc:service>
    	<wtc:array id="result_t1" scope="end"/>
   
function 	ajaxSetSmCodef(){
		var selectObj = document.getElementById("smCodeFGood");
	  selectObj.length=0;
	  <%
		  for(int iii=0;iii<result_t1.length;iii++){
		  		String temp1 = result_t1[iii][0];
		  		String temp2 = result_t1[iii][1];
		%>
		
			selectObj.options.add(new Option("<%=temp1%>--><%=temp2%>","<%=temp1%>"));
		<%			
			}
		%>	
	}
function ajaxSetpType(){
		var packet = new AJAXPacket("ajax_getOfferType.jsp","请稍后...");
		packet.data.add("smCode" ,document.all.smCodeFGood.value);
		packet.data.add("goodKind" ,document.frmMain.result2.value );
		packet.data.add("opCode" ,"<%=opCode%>" );
		packet.data.add("goodFlag" ,"0");

		core.ajax.sendPacket(packet,doAjaxSetpType);	
}	
			
function 	doAjaxSetpType(packet){
		var retResult = packet.data.findValueByName("retResult"); 
		var selectObj = document.getElementById("offer_att_typeFGood");
	  selectObj.length=0;
		selectObj.options.add(new Option("--请选择--",""));
		//if(document.frmMain.result2.value =="P"){
			document.all.offer_att_typeFGood.disabled=false;
		for(var i=0;i<retResult.length;i++){
			var reg = /\s/g;     
			var ss = retResult[i][0].replace(reg,""); 
				if(ss.length!=0){
					selectObj.options.add(new Option(retResult[i][0]+"-->"+retResult[i][1],retResult[i][0]));
				}
			}
	//}else{
			//document.all.offer_att_typeFGood.disabled=true;
			//}
	}	


function setOfferTypeFGood(){
		var packet = new AJAXPacket("ajax_getOfferType.jsp","请稍后...");
		packet.data.add("smCode" ,document.all.smCodeFGood.value);
		packet.data.add("goodFlag" ,"1");
		packet.data.add("opCode" ,"<%=opCode%>" );
		packet.data.add("goodKind" ,document.frmMain.result2.value );
		core.ajax.sendPacket(packet,dosetOfferTypeFGood);	
}	
			
function 	dosetOfferTypeFGood(packet){
		var retResult = packet.data.findValueByName("retResult"); 
		var selectObj = document.getElementById("offer_att_typeFGood");
	  selectObj.length=0;
		selectObj.options.add(new Option("--请选择--",""));
		
		//if(document.frmMain.result2.value =="P"){
			document.all.offer_att_typeFGood.disabled=false;
		for(var i=0;i<retResult.length;i++){
			var reg = /\s/g;     
			var ss = retResult[i][0].replace(reg,""); 
				if(ss.length!=0){
					selectObj.options.add(new Option(retResult[i][0]+"-->"+retResult[i][1],retResult[i][0]));
				}
			}
		//}else{
			//	document.all.offer_att_typeFGood.disabled=true;
				//}	
	}
	
		
			
		function doqryByGoodNoType(packet){
			var goodNo = document.frmMain.goodNo.value.trim();
			var goodType= document.frmMain.goodNoBlind.value;
			var qryRetCode = packet.data.findValueByName("retCode"); 
			var qryRetMsg = packet.data.findValueByName("retMsg"); 
			var retResult = packet.data.findValueByName("retResult");
			var selectValue = document.frmMain.selectValue.value;//查询方式的value
			
			var selectValue = document.frmMain.selectValue.value;//查询方式的value
			var serv_bus_id =document.frmMain.servBusId.value;
			
			var tableId=g("queryOfferList");
			document.getElementById("queryOfferList").style.display="block";
			document.getElementById("productOfferQueryList").style.display="block";
			var rowNum = tableId.rows.length;
			if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
		if(retResult==null||retResult==""){
		rdShowMessageDialog("没有查询到您所需的数据3");
		}else{
				if(qryRetCode==0){
				for(var i=0;i<retResult.length;i++){
					var arrTdCon=new Array(retResult[i][0],retResult[i][1],retResult[i][6],"<div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004~20007~20008|"+selectValue+"~"+goodNo+"~"+goodType+"</span>");
					//addTrOver("queryOfferList","1",arrTdCon,1,"f5f5f5");  //18845115111
					$("#queryOfferList").append("<tr onclick='clickTr()' style='cursor:pointer;'><td id='queryOfferList"+"_tr1_td"+i+"'>"+retResult[i][0]+"</td><td id='"+codeChg("queryOfferList"+"td_"+retResult[i][0])+"'>"+retResult[i][1]+"</td><td id='queryOfferList"+"_tr1_td"+(i+2)+"'>"+retResult[i][6]+"</td><td id='queryOfferList"+"_tr1_td"+(i+3)+"'><div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|40013|20004~20007~20008|"+selectValue+"~"+goodNo+"~"+goodType+"</span></td>");
					getMidPrompt("10442",retResult[i][0],"queryOfferList"+"td_"+retResult[i][0]);	
					}
				}
			}		
		}
			
function setOfferType(){
		var packet = new AJAXPacket("ajax_getOfferType.jsp","请稍后...");
		packet.data.add("smCode" ,document.all.smCode.value);
		packet.data.add("goodKind" ,document.frmMain.result2.value );
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
	
	
var showPageNum = 1; //当前页数
var rowSum = 20;  //每页显示记录数		

function myFavorite(){
			rowSum = 5;
			var packet = new AJAXPacket("ajax_getMfOffer.jsp","请稍后...");
			packet.data.add("opCode" ,"<%=opCode%>");
			core.ajax.sendPacket(packet,doMyFavorite,true);
			packet =null;	
}

function doMyFavorite(packet){
			var qryRetCode = packet.data.findValueByName("retCode"); 
	    var qryRetMsg = packet.data.findValueByName("retMsg"); 
	    var retResult = packet.data.findValueByName("retResult");
			document.getElementById("myFavoriteList").style.display="";
			//document.getElementById("hotOfferQueryList").style.display="none";
			document.getElementById("queryhotOfferList").style.display="";
			//document.getElementById("productOfferQueryList").style.display="none";
			retResultJ =	retResult;
			var tempJ1 = retResult.length/rowSum;	
			if(retResult.length<rowSum){
					rowSum = retResult.length;
				}			
			var tempJ2 = "";
			var tempJ3 = "";
			if((tempJ1+"").indexOf(".")!=-1){
				tempJ2 = (tempJ1+"").substring(0,(tempJ1+"").indexOf("."));
				tempJ3 = parseInt(tempJ2)+1;
			}else{
				tempJ3 = tempJ1;
				}
			//document.all.myFavoriteP.value = tempJ3;
			document.all.sumPageNum.value = tempJ3;
		if(retResult==null||retResult==""){
			;
		//rdShowMessageDialog("没有查询到您所需的数据3"+qryRetMsg);
		}else{
			changePage("myFavoriteListT","S");
	 }
}

function hotOffer(){
		rowSum = 10;
		var packet = new AJAXPacket("ajax_getHotOffer.jsp","请稍后...");
		packet.data.add("groupId" ,"<%=groupId%>");
		core.ajax.sendPacket(packet,doHotOffer,true);
		packet =null;
}		

var retResultJ = "";
function doHotOffer(packet){
	var qryRetCode = packet.data.findValueByName("retCode"); 
	var qryRetMsg = packet.data.findValueByName("retMsg"); 
	var retResult = packet.data.findValueByName("retResult");

			//document.getElementById("myFavoriteList").style.display="none"; //收藏夹
			document.getElementById("hotOfferQueryList").style.display="";  //热点销售品
			//document.getElementById("productOfferQueryList").style.display="none"; //结果查询列表
			
			retResultJ =	retResult;
			var tempJ1 = retResult.length/rowSum;
			
			if(retResult.length<rowSum){
					rowSum = retResult.length;
				}
				
			var tempJ2 = "";
			var tempJ3 = "";
			
			if((tempJ1+"").indexOf(".")!=-1){
				tempJ2 = (tempJ1+"").substring(0,(tempJ1+"").indexOf("."));
				tempJ3 = parseInt(tempJ2)+1;
			}else{
				tempJ3 = tempJ1;
				}
			
			
			document.all.sumPageNum.value = tempJ3;
			//document.all.hotOfferP.value=tempJ3;
			
		if(retResult==null||retResult==""){
		;
		}else{
			changePage("queryhotOfferList","S");
	 }
}	



function changePage(tabName,pFlag){
	
	var tableId=g(tabName);
	var rowNum = tableId.rows.length;
			if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
	      	
	var goodNo = document.frmMain.goodNo.value.trim();
	var goodType= document.frmMain.goodNoBlind.value;
	var selectValue = document.frmMain.selectValue.value;//查询方式的value
	var serv_bus_id =document.frmMain.servBusId.value;	
	
	var showPageNumJ = showPageNum;  //记录当前页数
	var retResult = retResultJ;
		
	var beginNum = 0;
	var endNum = retResult.length-1;
	
	
	
	
	
	 for(var i=beginNum;i<=endNum;i++){
					
	 			if(tabName=="myFavoriteListT"){ //添加收藏夹
	 				if(retQ08Flag()==true){
						var delBut="<div style='display:none'>"+retResult[i][2]+"</div>"+"<INPUT class='b_text' id=but_add onclick='delTr_m(\""+retResult[i][0]+"\");' type=button value=删除><span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004|"+selectValue+"</span>";
						var arrTdCon=new Array(retResult[i][0],retResult[i][1],retResult[i][6],"<input type='hidden' id='"+retResult[i][0]+"'/>"+delBut);
					}else{
						var arrTdCon=new Array(retResult[i][0],retResult[i][1],retResult[i][6],"<div style='display:none'>"+retResult[i][2]+"</div>"+"<INPUT class='b_text' id=but_add onclick='delTr_m(\""+retResult[i][0]+"\");' type=button value=删除><span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004~20007~20008|"+selectValue+"~"+goodNo+"~"+goodType+"</span>");
						}
				}else{//添加热点
					if(retQ08Flag()==true){
						var delBut="<div style='display:none'>"+retResult[i][2]+"</div>"+" <span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004|"+selectValue+"</span>";
						var arrTdCon=new Array(retResult[i][0],retResult[i][1],retResult[i][6],"<input type='hidden' id='"+retResult[i][0]+"'/>"+delBut);
					}else{
						var arrTdCon=new Array(retResult[i][0],retResult[i][1],retResult[i][6],"<div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004~20007~20008|"+selectValue+"~"+goodNo+"~"+goodType+"</span>");
						}
				}
				
				addTrOver(tabName,"1",arrTdCon,1,"f5f5f5");
				getMidPrompt("10442",retResult[i][0],codeChg(tabName+"td_"+retResult[i][0]));	
		}
  }
  
function delTr_m(offer_id)
{
	var tableId=g("myFavoriteListT");
	var rowNum = tableId.rows.length;
			if(rowNum>1){
		     for(var i=2;i<=rowNum;i++){
					tableId.deleteRow();
	      }
	    }
	    
	var okno = confirm("删除这条记录么？");
	if(okno){
	var packet = new AJAXPacket("ajax_DelMyFavorite.jsp","请稍后...");
		packet.data.add("offer_id" ,offer_id);
		core.ajax.sendPacket(packet,doDelTr_m);
		packet =null;
		}else{
			myFavorite();
			}
}

function doDelTr_m(packet){
	var retCode = packet.data.findValueByName("retCode"); 
	var retMsg = packet.data.findValueByName("retMsg"); 
		if(retCode==0)
	  {
	  	alert("删除成功!");
	  	myFavorite();
		}else{
		  alert(retMsg);
		}
	}
	
	
function saveOffer(offer_id){
		var packet = new AJAXPacket("ajax_saveProdBookMark.jsp","请稍后...");
		packet.data.add("offerCode" ,offer_id);
		packet.data.add("workNo" ,"<%=workNo%>");
		core.ajax.sendPacket(packet,dosaveOffer);
		packet =null;
}

	
function dosaveOffer(packet)
{
	var qryRetCode = packet.data.findValueByName("retCode"); 
	var qryRetMsg = packet.data.findValueByName("retMsg");
	var retVal1 = packet.data.findValueByName("retVal1");
	
	
  if(qryRetCode==0)
  {
  	rdShowMessageDialog(retVal1);
  	myFavorite();
	}else{
	  rdShowMessageDialog(qryRetCode+":"+qryRetMsg);
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
		
			<%
				String sqlStr1= "SELECT band_id,band_name FROM band WHERE ban_band_id IN (1,2,3)";
				
				if(opCode.equals("g629")){
					inputParam = "230";
				}
			%>
							
			<wtc:service name="sDynSqlCfm" routerKey="region" routerValue="<%=regionCode%>" outnum="3">
    		<wtc:param value="<%=inputParam%>"/>
    	</wtc:service>
    	<wtc:array id="result_t1" scope="end"/>
   
function 	addSmCode(){
		var selectObj = document.getElementById("smCode");
	  selectObj.length=0;
	  <%
		  for(int iii=0;iii<result_t1.length;iii++){
		  		String temp1 = result_t1[iii][0];
		  		String temp2 = result_t1[iii][1];
		  		if(opCode.equals("d535")){
					%>
						selectObj.options.add(new Option("82-->IMS固话","82"));	
				  <%
				  	break;
				  }
					else{
					%>
						selectObj.options.add(new Option("<%=temp1%>--><%=temp2%>","<%=temp1%>"));
					<%
					}	
			}
		%>	
	}
			 	
    		
function setOnloadF(){
	//addSmCode();
	//setOfferType();
	//addRegCode();
}	   	
/*************
addTrOver 参数  要插入表格的Id ，插入行在表格的第几行，要插入的内容，插入行是否有重复的依据列，插入行有绑定事件的时候鼠标放上去的颜色，

***********/
function addTrOver(tableID,trIndex,arrTdCont,num,bg)
{
	var tableId=g(tableID);
	var tableTr=g(tableID).getElementsByTagName("tr");
	if(typeof(num)!="undefined")
	{
		for (var i=0;i<tableTr.length;i++)
		{
			var tabaleTd=tableTr[i].getElementsByTagName("td");	
			var tdArrs=new Array();
			for(var j=0;j<tabaleTd.length;j++)
			{
				tdArrs.push(tabaleTd[j].innerHTML);
			}
			var tempnum=String(num);
			var nums=tempnum.split('|');
			var a = parseInt(nums[0]);
			var b = parseInt(nums[1]);
			if(b)
			{
				if((tdArrs[a]==arrTdCont[a])&&(tdArrs[b]==arrTdCont[b])) return false;
			}
			else
			{
				if(tdArrs[num]==arrTdCont[num]) return false;
			}
		}
	}
	var insertTr=tableId.insertRow(trIndex);
	if(typeof(bg)!="undefined")
	{
	
		insertTr.onclick=function()
		{
			if(tableID=="myFavoriteListT"){
				mf_flag = "1";
			}else{
				mf_flag = "0";
			} 
			clickTr(event);
		}
		insertTr.onmouseover=function()
		{
			insertTr.style.cursor="pointer";
			insertTr.style.background="#"+bg;
		}
		insertTr.onmouseout=function()
		{
			insertTr.style.cursor="none";
			insertTr.style.background="";
		}
	}
	//insertTr.setAttribute("id",codeChg("td_"+arrTdCont[0]));
	var arrTd=new Array();
	for(var i=0;i<arrTdCont.length;i++)
	{
		if(i==1){
			arrTd[i]=insertTr.insertCell(i);
			arrTd[i].setAttribute("id",codeChg(tableID+"td_"+arrTdCont[0]));
		}else{
			arrTd[i]=insertTr.insertCell(i);
			arrTd[i].setAttribute("id",tableID+"_tr"+trIndex+"_td"+i);			
		}
	}
	for(var i=0;i<arrTdCont.length;i++)
	{
		arrTdCont[i] = arrTdCont[i]+""
		arrTd[i].innerHTML=arrTdCont[i];
	}
}


 
</script>
</head>
<body onload="" style="overflow-y:auto; overflow-x:hidden;">
	<form  name="frmMain" action="" method="post">
<%@ include file="/npage/include/header_pop.jsp" %>

			<div class="mztree" id="tbc_02">
			<div class="product_chooseL" >
			    <div class="title">
					<div id="title_zi">按属性查询</div>
				</div>

			<table cellspacing=0>
						<tr>			
							<td align="center">
							<input type="radio" name="query" id="query01" value="01" onclick="queryByNomal();" checked>普通入网
							<!--input type="radio" name="query" id="query02" value="03" onclick="queryByRentMac();">租机入网-->
							<%
				       if(!(opCode.equals("4977")) && !(opCode.equals("e887"))&& !(opCode.equals("g629"))){
				       %>
							<input type="radio" name="query" id="query03" value="04" onclick="queryByGoodNo();">特殊号码入网
							<%
							if(Integer.parseInt(cardLimit)  > 0){
							%>
							<input type="radio" name="query" id="query08" value="08" onclick="queryByNomal();">一卡双号业务副卡入网
							<%}%>
							<%}%>
						</td>
						</tr>
				</table>

					<table cellspacing=0 id="normal" style="display:none">
						<tr>
						<td class='blue' nowrap>销售品名称</td>
						<td>
						<input class="" name="offerName" value="" >
						</td>
						<td class='blue' nowrap>销售品编码</td>
						<td>
						<input class="" name="offerCode" value="" >
						</td>
					  </tr>
						<tr>
						<td class='blue' nowrap>品牌</td>
						<td>
						
					   <SELECT name="smCode" id="smCode"  onchange="setOfferType()"> 
			       </SELECT>
					  </td>
					  
					  
				 <td class='blue' nowrap style="display:none">受理区域</td>
				 
				 <td style="display:none">
				  <SELECT name="receiveRegion" id="receiveRegion"> 
          </SELECT>
				 </td>
 
						<td class='blue' nowrap>销售品分类</td>
						<td >
					<SELECT name="offer_att_type" id="offer_att_type"> 
						<option value="">--请选择--</option>
    			</SELECT>
						</td>
						</tr>
						<tr id='footer'>
						  <td colspan="4" align="center">
						  	<input class="b_foot" id="queryInfo1" type="button" value="查询" onClick="productOfferQryByAttr()">
						  	<input class="b_foot" type="button" value="重置" onClick="resetInfo();"></td>
						</tr>	
						</table>
					<table cellspacing=0 id="rentMac" style="display:none">
							<tr>
								<td class='blue'>机器串号</td>
								<td><input class="" name="imeiNo" value="请输入串号" onfocus='if(this.value=="请输入串号")this.value=""' onblur='if(this.value=="")this.value="请输入串号"' onKeyPress="if(event.keyCode == 13)getImei()">
									  <input type="button" class="b_text"  value="查询" onclick="getImei();">
								</td>
								<td class='blue'>合同信息串</td>
								<td><input class="" name="contractInfo" value="" readonly></td>
							</tr>
							<tr>
								<td class='blue'>租机押金</td>
								<td><input class="" name="rentDeposit" value="" readonly></td>
								<td class='blue'>租机预存费</td>
								<td><input class="" name="rentCostPre" value="" readonly></td>
							</tr>
						<tr id='footer'>
						   <td colspan="4" align="center"><input class="b_foot" id="queryInfo2" type="button" value="查询" onClick="qryByRentMac();"><input class="b_foot" type="button" value="重置" onClick="resetInfo();"></td>
						</tr>	
						
					</table>
					<table cellspacing=0 id="betterNo" style="display:none">
							<tr>
							<td class='blue'>特殊号码</td>
								<td>
									<input id="goodNo" class="required" name="goodNo" value="请输入特殊号码" onfocus='if(this.value=="请输入特殊号码")this.value=""' onblur='if(this.value=="")this.value="请输入特殊号码"' onKeyPress="if(event.keyCode == 13)getGoodNo()">
								  <input type="button" id="queryFirst" class="b_text"  value="查询" onclick="getGoodNo();">
								</td>
							
								<td class='blue'>特殊号码绑定政策</td>
								<td><input class="required" name="goodNoBlind" value="" readonly></td>
								
							</tr>	
							<tr>
								<td class='blue'>绑定入网预存</td>
								<td><input class="" name="blindNetPre" value="" readonly></td>
								<td class='blue'>绑定附加套餐</td>
								<td><input class="" name="blindAddCombo" value="" readonly></td>
								
							</tr>
							<tr style="display:none">
								<td class='blue'>绑定入网押金</td>
								<td><input class="" name="blindNetDeposit" value="" readonly></td>
								<td class='blue'>绑定合同期限</td>
								<td><input class="" name="blindContractDate" value="" readonly></td>
							</tr>
							<tr style="display:none">
								<td class='blue'>绑定分月返还</td>
								<td><input class="" name="blindBackMonth" value="" readonly></td>
								<td class='blue'>绑定附属产品</td>
								<td><input class="" name="blindSpecialSevice" value="" readonly></td>
							</tr>
							<!--modify by zhengyha 2009-4-30 21:02:30-->
							<tr style="display:none">
								
								<td class='blue'>绑定总费用</td>
								<td><input class="" name="blindCost" value="" readonly></td>
							</tr>
							
								 <tr id="trFGoodNo" style="display:none">
											<td class='blue' nowrap>品牌</td>
									<td>
								   <SELECT name="smCodeFGood" id="smCodeFGood"  onchange="setOfferTypeFGood()"> 
						       </SELECT>
								  </td>
								  <td class='blue' nowrap>销售品分类</td>
									<td >
								<SELECT name="offer_att_typeFGood" id="offer_att_typeFGood"> 
									<option value="">--请选择--</option>
			    			</SELECT>
								</td>
							</tr>
							<tr>
								<tr  id="trFGoodNo1" style="display:none">
									<td class='blue' nowrap>销售品名称</td>
									<td>
									<input class="" name="offerNameGood" value="" >
									</td>
									<td class='blue' nowrap>销售品编码</td>
									<td>
									<input class="" name="offerCodeGood" value="" >
									</td>
								</tr>
							</div>
							<tr id='footer'>
							<td colspan="4" align="center"><input class="b_foot" id="queryInfo3" type="button" value="查询" onClick="qryByGoodNoType()">
								<input class="b_foot" type="button" value="重置" onClick="resetInfo();"></td>
							</tr>	
					</table>	

			<!--树-->
			</div>
			</div>
			
			</div>
			
<div id="Operation_Table">
	
<div style="width:99%">
	<div style="">
		<div style="width:99%">
			<div class="product_chooseR" id="myFavoriteList" style="height:130px;float:left;width:50%; overflow-y:auto; overflow-x:hidden;">
				<div class="title"><div id="title_zi">我收藏的销售品列表</div></div>
						<div class="list" style="">
							<table id="myFavoriteListT" cellspacing=0>
								<tr>
									<th>销售品代码</th>
									<th>销售品名称</th>
									<th>品牌名称</th>
									<th>操作</th>
								</tr>
								
						 </table>
					     <!--<div id="changePageDiv"  style="font-size:12px" align="center">
			              <a href="#" onClick="changePage('myFavoriteListT','S')"> 首页 </a>
			              <a href="#" onClick="changePage('myFavoriteListT','P')"> 上一页 </a>
			              <a href="#" onClick="changePage('myFavoriteListT','N')"> 下一页 </a>
			              <a href="#" onClick="changePage('myFavoriteListT','E')"> 尾页 </a>
			              &nbsp;&nbsp;共<span><input type="text" name="myFavoriteP" class="InputGrey" redOnly size=1></span>页&nbsp;&nbsp;&nbsp;
			              &nbsp;&nbsp;&nbsp;<span>当前第<input type="text" name="myFavoriteCP" class="InputGrey" redOnly size=1 value=1>页</span>
				       	</div>-->
					  </div>
			 </div>
			<div class="product_chooseR" id="hotOfferQueryList" style="float:right;width:49%;">
				<div class="title"><div id="title_zi">热点销售品列表</div></div>
			
						<div class="list" style="height:130px; overflow-y:auto; overflow-x:hidden;">
							
							<table id="queryhotOfferList" cellspacing=0>
								<tr>
									<th>销售品代码</th>
									<th>销售品名称</th>
									<th>品牌名称</th>
									<th>说明</th>
								</tr>
								
						 </table>
						<!-- <div id="changePageDiv"  style="font-size:12px" align="center">
			              <a href="#" onClick="changePage('queryhotOfferList','S')"> 首页 </a>
			              <a href="#" onClick="changePage('queryhotOfferList','P')"> 上一页 </a>
			              <a href="#" onClick="changePage('queryhotOfferList','N')"> 下一页 </a>
			              <a href="#" onClick="changePage('queryhotOfferList','E')"> 尾页 </a>
			              &nbsp;&nbsp;共<span><input type="text" name="hotOfferP" class="InputGrey" redOnly size=1></span>页&nbsp;&nbsp;&nbsp;
			              &nbsp;&nbsp;&nbsp;<span>当前第<input type="text" name="hotOfferCP" class="InputGrey" redOnly size=1 value=1>页</span>
				       	</div>-->
					</div>
			</div>	
		</div>
	</div>	
</div>
		<div class="product_chooseR" ></div>
		<div class="title"><div id="title_zi">按属性查询结果列表</div></div>
			
			<div class="product_chooseR" id="productOfferQueryList" style="display:none">
			<div class="list" style="height:156px; overflow-y:auto; overflow-x:hidden;">
				<table id="queryOfferList" cellspacing=0>
					<tr>
						<th>销售品代码</th>
						<th>销售品名称</th>
						<th>品牌名称</th>
						<th>说明</th>
					</tr>
					</table>
				</div>
			</div>
<br>
<div class="title">
	<div id="title_zi">已选销售品列表</div>
</div>
			<div class="list" style="height:156px; overflow-y:auto; overflow-x:hidden;">
				<table id="productOfferList" cellspacing=0>
					<tr>
						<th>销售品代码</th>
						<th>销售品名称</th>
						<th>品牌名称</th>
						<th>销售品资费描述</th>
						<th>操作</th>
					</tr>					
				</table>
			</div>
				
			<div id="footer" >
				<input type="button" class="b_foot" value="确定" onclick="cfm()"/>
			</div>
			<input type="hidden" name="servBusId" value="">
			<input type="hidden" name="retMsg" value="">
			<input type="hidden" name="selectValue" id="selectValue" value="">
			<input type="hidden" name="payCode">     								<!--资费代码---->
		  <input type="hidden" name ="hid_rentCostPre" value =0.00>   <!--租机预存费-->   
		  <input type="hidden" name ="hid_rentDeposit" value =0.00>   <!--租机押金-->
   	  <input type="hidden" name="hid_sale_mode" value="">	<!---租机的模版信息-->
   	  <input type="hidden" name="good" value="">
   	  
   	  <input type="hidden" name="result2" value="">
   	  <input type="hidden" name="result8" value="">
   	  <input type="hidden" name="result9" value="">
   	  <input type="hidden" name="result10" value="">
   	  <input type="hidden" name="result11" value="">
   	  <input type="hidden" name="result12" value="">
   	  <input type="hidden" name="result13" value="">
   	  <input type="hidden" name="result14" value="">
   	  
   	  <input type="hidden" name="goodNo_new" value="">
   	  <input type="hidden" name="retResultH" id="retResultH" value="">
   	  <input type="hidden" name="showPageNum" id="showPageNum" value="1"> <!--当前页面数-->
   	  <input type="hidden" name="sumPageNum" id="showPageNum" value="1"> <!--总页面数-->
   	  <input type="hidden" name="numPerPage" id="numPerPage" value="15"> <!--每页显示的记录数-->
   	  <input type="hidden" name="offerType" id="offerType" value="10">
   	  <%@ include file="/npage/include/footer_new.jsp" %>
	</form>
</div>
</body>
</html>

