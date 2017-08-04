<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
  /*
   
　 */
%>
<%@ page language="java" pageEncoding="gb2312"%>
<%@ include file="/npage/include/public_title_name.jsp"%>
<%@ page import="com.sitech.crmpd.core.wtc.util.*,java.util.*"%>
<%
	String opCode = " ";
	String opName = "特殊名单类型";
	
%>
<HTML>
	<HEAD>
		<LINK
			href="<%=request.getContextPath()%>/css/dtmltree_css/style.css"
			type=text/css rel=STYLESHEET>
	</HEAD>
	<BODY>
		<form name="testForm">
		<%@ include file="/npage/include/header.jsp" %>
		<TABLE width="100%" border="0"  >
				 <TR>
	 
          <td class="blue">等级名称 </td>
  				<td class="blue" width="70%">
       				<input id="NodeName" name="NodeName" size="30" type="text" readOnly  Class="InputGrey"  value="">
	  			</td>	
       
			</TR>
		 <tr>
  				<td class="blue">来电提示信息 </td>
  				<td width="70%">
  					<input id="message" name="message" size="30" type="text" value="" v_must="1" v_type="string"  >
	    				<font color="orange">*</font>
	  			</td>
			</tr>
			<tr>
  				<td class="blue">显示颜色 </td>
  				<td width="70%">
  					<select name="font_bg_color" style="width:60px"> 
<option style="background-color:#FF0000" value="red"> 
<option style="background-color:#FFA500" value="orange"> 
<option style="background-color:#FFFF00" value="yellow"> 
<option style="background-color:#00FF00" value="lime"> 
<option style="background-color:#00FFFF" value="cyan"> 
<option style="background-color:#0000FF" value="blue"> 
<option style="background-color:#800080" value="olive" selected> 
<option style="background-color:#FFFFFF" value="white"> 
<option style="background-color:#000000" value="black"> 
  </select>
	  			</td>
			</tr>
		</TABLE>
		<%@ include file="/npage/include/footer.jsp" %> 
		</form>
	</BODY>
</html>
<SCRIPT type=text/javascript> 
//parent.rightFootFrame.window.showTable();
	// 说明： 用 Javascript 验证表单（form）中多选框（checkbox）值
function getCheckboxValue(checkbox)
{
	if (!checkbox.length && checkbox.type.toLowerCase() == 'checkbox') 
	{ return (checkbox.checked)?checkbox.value:''; }
	
	if (checkbox[0].tagName.toLowerCase() != 'input' || 
		checkbox[0].type.toLowerCase() != 'checkbox')
	{ return ''; }

	var val = [];
	var len = checkbox.length;
	for(i=0; i<len; i++)
	{
		if (checkbox[i].checked)
		{
			val[val.length] = checkbox[i].value;
		}
	}
	
	return (val.length)?val:'';
}

// 说明： 用 Javascript 验证表单（form）中的单选（radio）值
function getRadioValue(radio)
{
	if (!radio.length && radio.type.toLowerCase() == 'radio') 
	{ return (radio.checked)?radio.value:'';  }

	if (radio[0].tagName.toLowerCase() != 'input' || 
		radio[0].type.toLowerCase() != 'radio')
	{ return ''; }

	var len = radio.length;
	for(i=0; i<len; i++)
	{
		if (radio[i].checked)
		{
			return radio[i].value;
		}
	}
	return '';
}

 
function ischeckBoxSelect(selectedItemId){
	 
 
	var nodeName =parent.frameleft.window.tree.getSelectedItemText();
 
	document.getElementById('NodeName').value=nodeName; 
  getRoles(selectedItemId);
 
}

function getRoles(selectedItemId){
	var packet = new AJAXPacket(<%=request.getContextPath()%>"/npage/callbosspage/K196/k196_getRolesList.jsp","aa");
	packet.data.add("selectedItemId",selectedItemId);
	core.ajax.sendPacket(packet,doProcessRoles,false);
	packet=null;
}
//getRoles的回调函数
function doProcessRoles(packet){
   	var showmessage = packet.data.findValueByName("showmessage");
   	document.getElementById('message').value=showmessage; 
}


function setGroupLoginNoNum(tree,num){
	if(tree.getUserData(tree.getSelectedItemId(),"flag")!='0'){
		if(tree.getUserData(tree.getSelectedItemId(),"isleaf")=='Y'){
			tree.setItemText(tree.getSelectedItemId(),tree.getSelectedItemText()+'('+num+')人');
			tree.setUserData(tree.getSelectedItemId(),"flag",'0');	
		}else{
			tree.setItemText(tree.getSelectedItemId(),tree.getSelectedItemText()+'('+num+')人,不包括子组人数');
			tree.setUserData(tree.getSelectedItemId(),"flag",'0');	
			}
	}
}
 
//创建表格
function insertTable(dataArr,flag){

	var dataTable = document.getElementById("dataTable");
	clearRow(dataTable);
	var rowObj = dataTable.insertRow();
	var m=0;
	var xin=1; /*add by yinzx*/
	var cellObj2;
	var strArr=new Array();

	for(var i = 0; i <dataArr.length; i++ ){
	 
		m = i%5;
		if(i == 0 || m == 0){
			cellObj2 = rowObj.insertCell();
			if(flag[i]==true){
				cellObj2.innerHTML+= "<tr><input type='checkbox' checked='checked' name='loginNo' isgroup='false' value='"+dataArr[i][1]+"'/><td class='blue'>"+dataArr[i][0]+"</td></tr><p>";		
			}else{
				cellObj2.innerHTML+= "<tr><input type='checkbox' name='loginNo' isgroup='false' value='"+dataArr[i][1]+"'/><td class='blue'>"+dataArr[i][0]+"</td></tr><p>";		
			}
     	 	 cellObj2.setAttribute("vAlign","top");
		}else{			
			if(flag[i]==true){
				cellObj2.innerHTML+= "<tr><input type='checkbox' name='loginNo' checked='checked' isgroup='false' value='"+dataArr[i][1]+"'/><td class='blue'>"+dataArr[i][0]+"</td></tr><p>";		
			}else{
				cellObj2.innerHTML+= "<tr><input type='checkbox' name='loginNo' isgroup='false' value='"+dataArr[i][1]+"'/><td class='blue'>"+dataArr[i][0]+"</td></tr><p>";		
			}
      	 	cellObj2.setAttribute("vAlign","top");
		}
	}
}

//清除表格
function clearRow(objTable){ 
var length= objTable.rows.length ; 
for( var i=0; i<length; i++ )
{
objTable.deleteRow(i); 
}
}
  function   findInPage(str)     
  {     
    var   txt,   i,   found,n   =   0;     
    if   (str == "")     
    {     
      return   false;     
    }     
    txt   =   document.body.createTextRange();     
    for   (i   =   0;   i   <=   n   &&   (found   =   txt.findText(str))   !=   false;   i++)     
    {     
      txt.moveStart("character",   1);     
      txt.moveEnd("textedit");     
    }     
    if   (found)     
    {     
      txt.moveStart("character",   -1);     
      txt.findText(str);     
      txt.select();     
      txt.scrollIntoView();     
      n++;         
    }else{     
      if   (n   >   0){     
        n   =   0;     
        findInPage(str);     
      }else{     
        //alert(str   +   "...您要找的文字不存在。\n   \n请试着输入页面中的关键字再次查找！");     
      }     
    }     
    return   false;     
  }
//范围选择定位功能
function selectCheckLoginNo(flag,loginNo) {
    var el = document.getElementsByTagName('input');
    var len = el.length;
    for (var i = 0; i < len; i++) {
        if ((el[i].type == "checkbox") && (el[i].name == 'loginNo')) {
           // alert("loginNo:"+loginNo+"el[i].value"+el[i].value);
            if(loginNo==el[i].value){
            	if(flag=='0'){
            	 el[i].checked = true;
            	}
            if(flag=='1'){
            	el[i].checked = false;
            	}	 
            	}
        }
    }
}

//清除全部选中复选框
function clearAll(name) {
    var el = document.getElementsByTagName('input');
    var len = el.length;
    for (var i = 0; i < len; i++) {
        if ((el[i].type == "checkbox") && (el[i].name == name)) {
            el[i].checked = false;
        }
    }
}
//选中全部复选框
function checkAll(name) {
    var el = document.getElementsByTagName('input');
    var len = el.length;
    //alert(len);
    for (var i = 0; i < len; i++) {
        if ((el[i].type == "checkbox") && (el[i].name == name)) {
            el[i].checked = true;
        }
    }
}

function generatejs(){
	var packet = new AJAXPacket("<%=request.getContextPath()%>/npage/callbosspage/K098/k098_getRalationArray.jsp","正在处理,请稍后...");
     core.ajax.sendPacket(packet,doProcessGenjs,true);
	chkPacket =null;
}

function doProcessGenjs(packet){
	//alert('回调genjs');
	var retCode = packet.data.findValueByName("retCode");	
   	if(retCode="000000"){
     	rdShowMessageDialog("处理成功",2);
	} else {
		rdShowMessageDialog("处理失败",0);
		return;
	}
	
}



//单选按钮的响应事件
function isRadioSelect(){
var selectItemId=parent.frameleft.window.tree.getSelectedItemId();
setHiddenOrShow();
ischeckBoxSelect(selectItemId);
 }
//设置操作按钮隐藏或者显示
function setHiddenOrShow(){
var radioValue=parent.rightTopFrame.window.getRadioValue();
if(radioValue=='selfAndSub'){
	//alert("隐藏");
	parent.rightFootFrame.window.hiddenTable();
	}
if(radioValue=='self'){
    parent.rightFootFrame.window.showTable();
	//alert("显示");
	}
}
 //判断一个字符串是否在数组中出现
function isStr(str,strArr){
	if(strArr!=null&&strArr!=''){
		for(var j=0;j<strArr.length;j++){
		//	alert("strArr[j] "+strArr[j]);
     		if(str==strArr[j]){
     			return true;
     		}
		}
	}
	return false;
}


function getUnCheckboxValue()
{
	var checkbox =document.all('loginNo');
	var val = [];
	var len = checkbox.length;
	if(len=='undefined'||len==undefined){
	 if (!checkbox.checked&&checkbox.isgroup=='false')
	 {
			return checkbox.value;
	 }else{
	 	  return '';
	 	}
	}else{
	for(i=0; i<len; i++)
	{
		if (!checkbox[i].checked&&checkbox[i].isgroup=='false')
		{
			val[val.length] = checkbox[i].value;
		}
	}
	}
	return (val.length)?val:'';
}

function getCheckboxValue()
{
	var checkbox =document.all('loginNo');
	var val = [];
	var len = checkbox.length;
	if(len=='undefined'||len==undefined){
		//alert(len);
	 if (checkbox.checked&&checkbox.isgroup=='false')
	 {
			//alert(checkbox.value);
			return checkbox.value;
	 }else{
	 	  return '';
	 	}
	}else{
	for(i=0; i<len; i++)
	{
		if (checkbox[i].checked&&checkbox[i].isgroup=='false')
		{
			val[val.length] = checkbox[i].value;
		}
	}
	}
	return (val.length)?val:'';
}

function saveChange(){
	
var rolesChkArr=document.all('loginNo');

var chkedRolesArr=getCheckboxValue();
var unChkedRolesArr=getUnCheckboxValue();


saveRolesMenuRel(parent.frameleft.window.tree.getSelectedItemId(),chkedRolesArr,unChkedRolesArr);
	
}


function saveRolesMenuRel(selectedItemId,chkedRolesArr,unChkedRolesArr){
	var packet = new AJAXPacket(<%=request.getContextPath()%>"/npage/callbosspage/K098/k098_saveRoles.jsp","aa");
	packet.data.add("selectedItemId",selectedItemId);
	//做类型转换，否则传值有误
	packet.data.add("chkedRolesArr",""+chkedRolesArr);
	packet.data.add("unChkedRolesArr",""+unChkedRolesArr);
	core.ajax.sendPacket(packet,doProcessCheckLoginNo,true);
	packet=null;
	
}

//getLoginNo的回调函数
function doProcessCheckLoginNo(packet){
   	var retCode = packet.data.findValueByName("retCode");
   	if(retCode="000000"){
       ischeckBoxSelect(parent.frameleft.window.tree.getSelectedItemId());
       rdShowMessageDialog("处理成功",2);
		} else {
			rdShowMessageDialog("处理失败",0);
			return;
		}
}
function cancel(){
	if(rdShowConfirmDialog('您确认退出吗？')==1){
		window.top.close();
		}
	
}
function showCheckItemWin(){

	var time     = new Date();
	var winParam = 'dialogWidth=360px;dialogHeight=150px';
	window.showModalDialog("k290_selectCheckOrUnCheckWin.jsp?time="+time,window, winParam);
}
function memberMsgWin(){

	var time     = new Date();
	var winParam = 'dialogWidth=400px;dialogHeight=240px';
	window.showModalDialog("k290_showLoginNoInfoWin.jsp?time="+time,window, winParam);
}


function saveChangea(){
	var packet = new AJAXPacket(<%=request.getContextPath()%>"/npage/callbosspage/K196/k196_saveRoles.jsp","aa");
	packet.data.add("selectedItemId",parent.frameleft.window.tree.getSelectedItemId());
	packet.data.add("NodeName",document.getElementById('NodeName').value);
	packet.data.add("message",document.getElementById('message').value);
	packet.data.add("font_bg_color",document.getElementById('font_bg_color').value);
	core.ajax.sendPacket(packet,doProcesssValue,false);
	packet=null;
}
 
function doProcesssValue(packet){
   	 var retCode = packet.data.findValueByName("retCode");
  if (retCode == "000000") {
	 
		rdShowMessageDialog("\u5904\u7406\u6210\u529f",2);
		return;
	} else {
		rdShowMessageDialog("\u5904\u7406\u5931\u8d25",0);
		return false;
	}	
     
}

</SCRIPT>