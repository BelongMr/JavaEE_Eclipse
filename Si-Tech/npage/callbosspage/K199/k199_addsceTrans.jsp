<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
  /*
   * 功能: 客服中心运营指标体系
　 * 版本: 1.0.0
　 * 日期: 2009/08/09
　 * 作者: yinzx
　 * 版权: sitech
   * 
　 */
%>

<%@ page contentType="text/html;charset=gbk"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
String boss_login_no =  request.getParameter("boss_login_no");
%>
<html>
<head>
<title>客服中心运营指标体系</title>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/npage/callbosspage/js/datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/csp/checkWork_dialog.js"></script>
<script language=javascript>
	
/**
  * 
  */
function addsceTrans(){
	 
	if(!check(sitechform))
	{
		return false;
	}
	
	var xinval="";
	var yinval="";
  
	for(var i=0;i<83;i++)
	{
			 xinval+=$("input")[i].value+",";
  }
  
  
	var packet = new AJAXPacket("k199_sceTrans_rpc.jsp","...");
	packet.data.add("retType","addsceTrans");
	packet.data.add("addvalxin" ,xinval);
 
  
	
	core.ajax.sendPacket(packet,doProcessaddsceTrans,true);
	packet=null;
}

/**
  *返回处理函数
  */
function doProcessaddsceTrans(packet) {
	var retType = packet.data.findValueByName("retType");
	var retCode = packet.data.findValueByName("retCode");

	if (retCode == "000000") {
		rdShowMessageDialog("新增数据成功！");		
    closeWin();
	} else {
		rdShowMessageDialog("新增数据失败！");

	}
}

// 清除表单记录
function genid(){
		var ACCESSCODE = document.getElementById("ACCESSCODE").value;
  	var city_code = document.getElementById("city_code").value;
  	var user_class = document.getElementById("user_class").value;
  	var DIGITCODE = document.getElementById("DIGITCODE").value;
  	
  		document.sitechform.ID.value = ACCESSCODE + city_code+user_class+DIGITCODE;
  		document.sitechform.SUPERID.value = document.sitechform.ID.value.substr( 0,document.sitechform.ID.value.length -1);

}

// 清除表单记录
function cleanValue(){
			var e = document.sitechform.elements;
			for(var i=0;i<e.length;i++){
				if(e[i].type=="select-one"||e[i].type=="text"||e[i].type=="hidden"){
				  e[i].value="";
				}else{
			  		e[i].checked=false;
			    }
			}   
}

function closeWin(){
	window.close();
}

function initValue(){

}

</script>
</head>

<body >
<form id="sitechform" name="sitechform">
	<div id="Operation_Table">
		<div class="title"><div id="title_zi">客服中心运营指标体系</div></div>
		<table>
	 <TR class=content2>
          <TD></TD>
          <TD noWrap>具体指标</TD>
          <TD noWrap>结果</TD>
        </TR>
        
        <TR class=content3>
          <td noWrap rowSpan=10>人员管理</TD>
          <td noWrap>员工满意度<font color=#ff0000 
            >*</FONT></TD></TD>
          <td><input class=form1 id=text1 
            v_must=1 type=text size=18 value = 0 >
          <!-- <input class=form1 id=btnGetNewCommonInfo type=button title="获取当前来话信息，同步到基本信息" value=同步>--></TD>
        </TR>
        
        <TR class=content2>
          <td noWrap>总体流失率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text2 
            v_must=1 type=text size=18 value = 0 ></TD></TR>
            
        <TR class=content3>
          <td noWrap>主动流失率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text3 
            v_must=1 type=text size=18 value = 0 > </TD></TR>
            
        <TR class=content2>  
          <td noWrap>人员招聘及时率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text4 
            v_must=1 type=text size=18 value = 0 > </TD></TR>
            
        <TR class=content3>
          <td noWrap>到岗及时率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text5 
            v_must=1 type=text size=18 value = 0 ></TD></TR>
            
        <TR class=content2>   
          <td noWrap>新员工转正率（上岗率）<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text6 
            v_must=1 type=text size=18 value = 0 ></TD></TR>
            
        <TR class=content3>   
          <td noWrap>培训满意率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text7 
            v_must=1 type=text size=18 value = 0 ></TD></TR>
            
        <tr class=content2>
          <td noWrap><font color=#ff0000 
            ><font color=#0f384b 
            >培训按时完成率</FONT>*</FONT> </TD>
          <td noWrap><input class=form1 id=text8 
            v_must=1 type=text size=18 value = 0 ></TD></TR>
        
        <tr class=content3>    
          <td noWrap>培训出勤率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text9 
            v_must=1 type=text size=18 value = 0 > </TD></TR>
            
        <tr class=content2>    
          <td noWrap>培训合格率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text10 
            v_must=1 type=text size=18 value = 0 > </TD></TR>
         
        <TR class=content2>
          <td noWrap rowSpan=9>服务质量</TD>    
          <td noWrap>客户满意度<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text11 
            v_must=1 type=text size=18 value = 0 ></TD></TR>
            
        <TR class=content3>    
          <td noWrap>挂机满意率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text12 
            v_must=1 type=text size=18 value = 0 > </TD></TR>
            
        <tr class=content2>    
          <td noWrap>拨测综合得分<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text13 
            v_must=1 type=text size=18 value = 0 > </TD></TR>
            
        <tr class=content3>
          <td noWrap><font color=#ff0000 
            ><font color=#0f384b 
            >人工服务差错率</FONT>*</FONT></TD>
          <td noWrap><input class=form1 id=text14 
            v_must=1 type=text size=18 value = 0 ></TD></TR>
            
         <tr class=content2>   
          <td noWrap>一次解决率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text15 
            v_must=1 type=text size=18 value = 0 > </TD></TR>
            
         <tr class=content3>   
          <td noWrap>质检差错率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text16 
            v_must=1 type=text size=18 value = 0 > </TD></TR>
            
        <tr class=content2>
          <td noWrap>辅导及时率<font 
            color=#ff0000>*</FONT></TD>
          <td noWrap><input class=form1 id=text17 
            v_must=1 type=text size=18 value = 0 ></TD></TR>
            
         <tr class=content3>
          <td noWrap>辅导满意率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text18 
            v_must=1 type=text size=18 value = 0 > </TD></TR>
          
         <tr class=content2>
          <td noWrap>服务投诉率<font 
            color=#ff0000>*</FONT></TD>
          <td noWrap><input class=form1 id=text19 
            v_must=1 type=text size=18 value = 0 ></TD></TR> 
         
         <tr class=content3>
          <td noWrap rowSpan=12>成本收入</td>
          <td noWrap>运营总成本<font 
            color=#ff0000>*</FONT></TD>
          <td noWrap><input class=form1 id=text20
            v_must=1 type=text size=18 value = 0 ></TD></tr>
            
         <tr class=content2>  
          <td noWrap>运营总收入<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text21 
            v_must=1 type=text size=18 value = 0 > </TD></tr> 
          
         <tr class=content3>  
          <td noWrap>服务营销总收入<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text22 
            v_must=1 type=text size=18 value = 0 > </TD></tr>   
         
         <tr class=content2>  
          <td noWrap>人均服务营销收入<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text23 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
            
         <tr class=content3>  
          <td noWrap>营销总收入<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text24 
            v_must=1 type=text size=18 value = 0 > </TD></tr>   
         
         <tr class=content2>  
          <td noWrap>人均营销收入<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text25 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content3>  
          <td noWrap>座席外包总收入<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text26 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
            
         <tr class=content2>  
          <td noWrap>座席外包平均每客户收入<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text27 
            v_must=1 type=text size=18 value = 0 > </TD></tr> 
         
         <tr class=content3>  
          <td noWrap>平均单呼成本<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text28 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content2>  
          <td noWrap>平均人工服务成本<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text29 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
            
         <tr class=content3>  
          <td noWrap>平均每客户服务成本<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text30 
            v_must=1 type=text size=18 value = 0 > </TD></tr>            
         
         <tr class=content2>  
          <td noWrap>外呼营销收入额<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text31 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
            
         <tr class=content2>  
          <td noWrap rowSpan=7>投诉管理</td>
          <td noWrap>投诉工单合格率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text32 
            v_must=1 type=text size=18 value = 0 > </TD></tr>      
         
         <tr class=content3>  
          <td noWrap>投诉处理及时率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text33 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content2>  
          <td noWrap>投诉派单错误率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text34 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content3>  
          <td noWrap>投诉电话率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text35 
            v_must=1 type=text size=18 value = 0 > </TD></tr>   
            
         <tr class=content2>  
          <td noWrap>重复投诉率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text36 
            v_must=1 type=text size=18 value = 0 > </TD></tr>   
            
         <tr class=content3>  
          <td noWrap>升级投诉率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text37 
            v_must=1 type=text size=18 value = 0 > </TD></tr>   
            
         <tr class=content2>  
          <td noWrap>投诉处理满意率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text38 
            v_must=1 type=text size=18 value = 0 > </TD></tr>   
         
         <tr class=content3>  
          <td noWrap rowSpan=29>排班管理</td>
          <td noWrap>服务水平（15秒整体接通率）<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text39 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content2>  
          <td noWrap>人工服务放弃率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text40 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content3>  
          <td noWrap>队列放置率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text41 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content2>  
          <td noWrap>平均排队时间<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text42 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content3>  
          <td noWrap>接通排队时间<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text43 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content2>  
          <td noWrap>放弃排队时间<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text44 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content3>  
          <td noWrap>人工请求量<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text45 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content2>  
          <td noWrap>人工接通量<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text46 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content3>  
          <td noWrap>排队呼入率（人工接通率）<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text47 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content2>  
          <td noWrap>VIP20秒接通率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text48 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content3>  
          <td noWrap>全球通20秒接通率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text49 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content2>  
          <td noWrap>神州行30秒接通率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text50 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content3>  
          <td noWrap>动感地带30秒接通率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text51 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content2>  
          <td noWrap>它网异地30秒接通率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text52 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content3>  
          <td noWrap>平均延迟时间<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text53 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content2>  
          <td noWrap>平均处理时长<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text54 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content3>  
          <td noWrap>平均交谈时长（通话均长）<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text55 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content2>  
          <td noWrap>平均持线时长<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text56 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content3>  
          <td noWrap>平均事后处理时长<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text57 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
         
         <tr class=content2>  
          <td noWrap>人均每小时电话处理量<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text58 
            v_must=1 type=text size=18 value = 0 > </TD></tr> 
            
         <tr class=content3>  
          <td noWrap>在线利用率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text59 
            v_must=1 type=text size=18 value = 0 > </TD></tr>    
            
         <tr class=content2>  
          <td noWrap>工时利用率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text60 
            v_must=1 type=text size=18 value = 0 > </TD></tr>    
            
         <tr class=content3>  
          <td noWrap>出勤率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text61 
            v_must=1 type=text size=18 value = 0 > </TD></tr>   
            
          <tr class=content2>  
          <td noWrap>人工服务占比<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text62 
            v_must=1 type=text size=18 value = 0 > </TD></tr>   
            
          <tr class=content3>  
          <td noWrap>话务波动系数<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text63 
            v_must=1 type=text size=18 value = 0 > </TD></tr>  
            
          <tr class=content2>  
          <td noWrap>人工服务预测准确率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text64 
            v_must=1 type=text size=18 value = 0 > </TD></tr>   
            
          <tr class=content3>  
          <td noWrap>排班吻合率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text65 
            v_must=1 type=text size=18 value = 0 > </TD></tr>    
          
          <tr class=content2>  
          <td noWrap>服务水平符合率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text66 
            v_must=1 type=text size=18 value = 0 > </TD></tr>   
            
          <tr class=content3>  
          <td noWrap>每小时交接班人数<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text67 
            v_must=1 type=text size=18 value = 0 > </TD></tr>  
            
          <tr class=content2>  
          <td noWrap rowSpan=9>外呼管理</td>
          <td noWrap>项目外呼总量<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text68 
            v_must=1 type=text size=18 value = 0 > </TD></tr>  
            
          <tr class=content3>  
          <td noWrap>外呼接通量<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text69 
            v_must=1 type=text size=18 value = 0 > </TD></tr>  
            
         <tr class=content2>  
          <td noWrap>外呼营销成功量<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text70 
            v_must=1 type=text size=18 value = 0 > </TD></tr>   
           
         <tr class=content3>  
          <td noWrap>每小时外呼量<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text71 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
           
          <tr class=content2>  
          <td noWrap>计划拨出量<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text72 
            v_must=1 type=text size=18 value = 0 > </TD></tr> 
           
          <tr class=content3>  
          <td noWrap>接触成功率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text73 
            v_must=1 type=text size=18 value = 0 > </TD></tr> 
           
          <tr class=content2>  
          <td noWrap>销售成功率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text74 
            v_must=1 type=text size=18 value = 0 > </TD></tr> 
           
          <tr class=content3>  
          <td noWrap>质检合格率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text75 
            v_must=1 type=text size=18 value = 0 > </TD></tr> 
           
          <tr class=content2>  
          <td noWrap>主动营销投诉率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text76 
            v_must=1 type=text size=18 value = 0 > </TD></tr> 
           
          <tr class=content3>  
          <td noWrap rowSpan=2>自动语音</td>
          <td noWrap>人工转自动比率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text77 
            v_must=1 type=text size=18 value = 0 > </TD></tr> 
           
          <tr class=content2>  
          <td noWrap>IVR满意率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text78 
            v_must=1 type=text size=18 value = 0 > </TD></tr>  
           
          <tr class=content2> 
          <td noWrap rowSpan=4>支撑系统</td> 
          <td noWrap>知识库满意率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text79 
            v_must=1 type=text size=18 value = 0 > </TD></tr>  
           
         <tr class=content3> 
          <td noWrap>系统接通率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text80 
            v_must=1 type=text size=18 value = 0 > </TD></tr>   
          
         <tr class=content2> 
          <td noWrap>系统满负荷率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text81 
            v_must=1 type=text size=18 value = 0 > </TD></tr> 
             
         <tr class=content3> 
          <td noWrap>故障率<font color=#ff0000 
            >*</FONT></TD>
          <td noWrap><input class=form1 id=text82 
            v_must=1 type=text size=18 value = 0 > </TD></tr>
            
         <tr class=content2>
          <td nowrap> </td>   
          <td noWrap><font color=#00ff00>提交日期</font><font 
            color=#ff0000>*</FONT></TD>
          <td noWrap> <input id="start_date" name ="start_date" type="text"  v_must=1 value="" onclick="WdatePicker({dateFmt:'yyyyMMdd HH:mm:ss',position:{top:'under'}});hiddenTip(document.sitechform.start_date);return false;">
		    <img onclick="WdatePicker({el:$dp.$('start_date'),dateFmt:'yyyyMMdd HH:mm:ss',position:{top:'under'}});return false;" src="<%=request.getContextPath()%>/npage/callbosspage/js/datepicker/skin/datePicker.gif" width="16" height="22" align="absmiddle">
		    <font color="orange">*</font>
          </TD></TR>
          
        <tr class=content3>
          <td noWrap colSpan=6>
            <p><font color=#ff0000><strong>注：以上数据均为数字型！输入时请注意！若为百分率制数据时请将其转化为小数型（例：23.58%转化后为0.2358）</strong></font></p>
            <p><strong><font color=#ff0000>&nbsp;&nbsp;&nbsp; <font 
            color=#00ff00>提交日期</font>在插入数据时不能为空，以方便后面修改数据时按提交日期查询数据用。</font></strong></p></TD></TR>
			<tr >
  				<td colspan="6" align="center" id="footer">
   					<input name="add" type="button" class="b_text" id="add" value="添加" onClick="addsceTrans()">
   					<input name="clean" type="button" class="b_text" id="clean" value="重设" onClick="cleanValue()">
   					<input name="close" type="button" class="b_text" id="close" value="关闭" onClick="closeWin()">
  				</td>
			</tr>
		</table>
	</div>
</form>
</body>
</html>
<script language=javascript>
</script>