<!DOCTYPE html PUBLIC "-//W3C//DTD Xhtml 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd">
<%
  /*
   * 功能: 新营业员操作统计报表(铁通)8557
   * 版本: 1.0
   * 日期: 2010/06/14
   * 作者: wangyua
   * 版权: si-tech
   * update:
  */
%>
<%@	page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%  request.setCharacterEncoding("GBK");%>
<%@ page import="org.apache.log4j.Logger"%>
<%
	String opCode="8557";
	String opName="新营业员操作统计报表(铁通)";
	Logger logger = Logger.getLogger("f8557_upg.jsp");
	String work_no = (String)session.getAttribute("workNo");
	String rpt_right = (String)session.getAttribute("rptRight");
	String org_code = (String)session.getAttribute("orgCode");

    String sqlStr="";
	String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());

%>

<script language=JavaScript>
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD><TITLE>新营业员操作统计表(铁通)</TITLE>
</HEAD>
<body>
<script language="JavaScript">
//----弹出一个新页面选择组织节点--- 增加
function select_groupId()
{
	var path = "<%=request.getContextPath()%>/npage/rpt/common/grouptreeTT.jsp";
    window.open(path,'_blank','height=600,width=300,scrollbars=yes');
}
</script>
<SCRIPT language="JavaScript">

function changerpt()
{
		if(document.form1.rpt_type.value==5){
			document.all("rpt_format").options.length=6;
    	document.all("rpt_format").options[0].text='明细';
    	document.all("rpt_format").options[0].value='10000';
    	document.all("rpt_format").options[1].text='交费方式小计';
    	document.all("rpt_format").options[1].value='01000';
    	document.all("rpt_format").options[2].text='分项';
    	document.all("rpt_format").options[2].value='00100';
    	document.all("rpt_format").options[3].text='明细+交费方式小计';
    	document.all("rpt_format").options[3].value='11000';
   	 	document.all("rpt_format").options[4].text='明细+分项';
    	document.all("rpt_format").options[4].value='10100';
    	document.all("rpt_format").options[5].text='明细+交费方式小计+分项';
    	document.all("rpt_format").options[5].value='11100';
		}
			else	if(document.form1.rpt_type.value==9){
			document.all("rpt_format").options.length=6;
    	document.all("rpt_format").options[0].text='明细';
    	document.all("rpt_format").options[0].value='10000';
    	document.all("rpt_format").options[1].text='交费方式小计';
    	document.all("rpt_format").options[1].value='01000';
    	document.all("rpt_format").options[2].text='分项';
    	document.all("rpt_format").options[2].value='00100';
    	document.all("rpt_format").options[3].text='明细+交费方式小计';
    	document.all("rpt_format").options[3].value='11000';
   	 	document.all("rpt_format").options[4].text='明细+分项';
    	document.all("rpt_format").options[4].value='10100';
    	document.all("rpt_format").options[5].text='明细+交费方式小计+分项';
    	document.all("rpt_format").options[5].value='11100';
		}
		else{
			document.all("rpt_format").options.length=1;
    	document.all("rpt_format").options[0].text='明细';
    	document.all("rpt_format").options[0].value='10000';
		}
    
  
}

function doSubmit()
{
  if(document.form1.all("begin_time").value.length == 8)
      document.form1.begin_time.value=document.form1.begin_time.value+" 00:00:00";
  if(document.form1.all("end_time").value.length == 8)
      document.form1.end_time.value=document.form1.end_time.value+" 23:59:59";
 
  if(!check(form1))
  {
    return false;
  }

  var begin_time=document.form1.begin_time.value;
  var end_time=document.form1.end_time.value;
  if(begin_time>end_time)
  {
    rdShowMessageDialog("开始时间比结束时间大");
    return false;
  }
  with(document.forms[0])
  {
    if(document.form1.rpt_type.value==1)
    {
      hTableName.value="rbo006";
      hParams1.value= "PRC_1615_TD139_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"','"+document.form1.rpt_format.value+"'";
    }
    else if(document.form1.rpt_type.value==2)
    {
      hTableName.value="rbo006";
      hParams1.value= "PRC_1615_TD140_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"','"+document.form1.rpt_format.value+"'";
    }
    else if(document.form1.rpt_type.value==3)
    {
      hTableName.value="rbo006";
      hParams1.value= "PRC_1615_TD142_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"','"+document.form1.rpt_format.value+"'";
    }
    else if(document.form1.rpt_type.value==4)
    {
      hTableName.value="rbo006";
      hParams1.value= "PRC_1615_TD143_UPG('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"','"+document.form1.rpt_format.value+"'";
    }
    else if(document.form1.rpt_type.value==5)
    {
    	
    	hTableName.value="rpo005";
			hParams1.value= "DBCUSTADM.prc_8557_po005_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"','"+document.form1.rpt_format.value+"'";
			document.form1.action="print_rpt_boss.jsp";    	
      
    }
        else if(document.form1.rpt_type.value==6)
    {
    	
    	hTableName.value="rbo005";
			hParams1.value= "PRC_8557_OP001_UPG('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"','"+document.form1.rpt_format.value+"'";
 	
      
    }
    else if(document.form1.rpt_type.value==7)
    {
    	
    	hTableName.value="rcd002";
			hParams1.value= "PRC_8557_KH001_UPG('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
			document.form1.action="print_rpt_crm_report.jsp";    	
      
    }
    
        else if(document.form1.rpt_type.value==8)
    {
    	
    	hTableName.value="rbo006";
			hParams1.value= "PRC_8557_300TD_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"','"+document.form1.rpt_format.value+"'";
			  	
      
    }    
            else if(document.form1.rpt_type.value==9)
    {//营业员积分兑换统计报表
    	
    	hTableName.value="rjo005";
			hParams1.value= "prc_8557_jo005_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"','"+document.form1.rpt_format.value+"'";
			  	     
    }
        else if(document.form1.rpt_type.value==10)
    {
    	
    	hTableName.value="rjo005";
			hParams1.value= "prc_8557_pr0017_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
			document.form1.action="print_rpt_crm_report.jsp";    	
      
    }
            else if(document.form1.rpt_type.value==11)
    {
    	
    	hTableName.value="rjo005";
			hParams1.value= "PRC_8557_1_UPG('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
			document.form1.action="print_rpt_crm_report.jsp";    	
      
    }
                else if(document.form1.rpt_type.value==12)
    {
    	
    	hTableName.value="rpt2266";
			hParams1.value= "prc_8557_rpt15_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
			document.form1.action="print_rpt_crm_report.jsp";    	
      
    }
                else if(document.form1.rpt_type.value==13)
    {
    	
    	hTableName.value="rbo005";
			hParams1.value= "prc_8557_po0106_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";   	
      
    }
              else if(document.form1.rpt_type.value==14)
    {
    	
    	hTableName.value="rbo005";
			hParams1.value= "prc_8557_po0107_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";   	
      
    }
              else if(document.form1.rpt_type.value==15)
    {
    	
    	hTableName.value="rbo005";
			hParams1.value= "prc_8557_po0108_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";   	
      
    }
             else if(document.form1.rpt_type.value==16)
    {
    	
    	hTableName.value="rbo005";
			hParams1.value= "prc_8557_po0109_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";   	
      
    }
             else if(document.form1.rpt_type.value==17)
    {
    	
    	hTableName.value="rbo005";
			hParams1.value= "prc_8557_hwprt_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"','"+document.form1.rpt_format.value+"'";
			   
    }
            else if(document.form1.rpt_type.value==18)
    {
    	
    	hTableName.value="dbo005";
			hParams1.value= "prc_8557_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";   	
      
    }   
           else if(document.form1.rpt_type.value==19)
    {
    	
    	hTableName.value="rbo006";
			hParams1.value= "prc_8557_154_upg('"+document.form1.workNo.value+"','"+document.form1.login_no.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";   	
      
    }
 
	submit();
  }
}

</SCRIPT>

<FORM method=post name="form1" action="/npage/rpt/print_rpt.jsp">
	<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">请选择操作报表</div>
	</div>
<table cellSpacing="0">
	<tr>
		<td class="blue">操作报表</td>
		<td>
			<select name=rpt_type onChange="changerpt()" style='width:400px'>
				<option class='button' value=1>1->营业员预存话费赠TD固话(铁通)统计报表</option>
				<option class='button' value=2>2->营业员预存话费赠TD商务固话统计报表(铁通)</option>
				<option class='button' value=3>3->营业员重新购TD商务固话，赠通信费(铁通)统计报表</option>
				<option class='button' value=4>4->重新预存话费赠TD固话(铁通)统计报表</option>
				<option class='button' value=5>5->营业员交费操作(铁通)统计报表</option>
				<option class='button' value=6>6->营业员业务操作统计报表(铁通)</option>
				<option class='button' value=7>7->营业员开户业务统计报表(铁通)</option>
				<option class='button' value=8>8->营业员购TD商务固话赠通信费统计报表(铁通)</option>
				<option class='button' value=9>9->营业员积分兑换统计报表(铁通)</option>
				<option class='button' value=10>10->营业员业务稽核统计报表(铁通)</option>
				<option class='button' value=11>11->营业员费用稽核统计报表(铁通)</option>
				<option class='button' value=12>12->营业员促销品统一付奖统计报表(铁通)</option>
				<option class='button' value=13>13->营业员远程写卡补卡统计报表(铁通)</option>
				<option class='button' value=14>14->营业员远程写卡补卡明细报表(铁通)</option>
				<option class='button' value=15>15->营业员远程写卡开户统计报表(铁通)</option>
				<option class='button' value=16>16->营业员远程写卡开户明细报表(铁通)</option>
				<option class='button' value=17>17->营业员电子化工单打印统计报表(铁通)</option>
				<option class='button' value=18>18->营业员新版促销品统一付奖统计报表(铁通)</option>
				<option class='button' value=19>19->营业员电子发票统计报表(铁通)</option>
			</select>
		</td>
		<td class="blue">报表格式</td>
		<td>
			<select name=rpt_format>
				<option class='button' value=10000>明细</option>
			</select>
		</td>
	</tr>
                
	<tr>
		<td class="blue">组织节点</td>
		<td>
			<input type="hidden" name="groupId">
			<input type="text" name="groupName" v_must="1" v_type="string" maxlength="60" class="InputGrey" readonly>&nbsp;<font color="orange">*</font>
			<input name="addButton" class="b_text"  type="button" value="选择" onClick="select_groupId()" >	
		</td>
		<td class="blue">营 业 员</td>
		<td>
			<input type="text" name="login_no" class="button" maxlength="6" size="8" onChange="changeLoginNo()">
			<input type="text" name="login_name" class="button" disabled>
			<input name="loginNoQuery" class="b_text" type="button" onClick="getLoginNo()" value="查询">
		</td>
	</tr>
	
	<tr id=a_time style="display=''">
		<td class="blue">开始时间</td>
		<td>
			<input type="text"   name="begin_time" value=<%=dateStr%>  size="17" maxlength="17">
		</td>
		<td class="blue">结束时间</td>
		<td>
			<input type="text"   name="end_time" value=<%=dateStr%>  size="17" maxlength="17">
		</td>
	</tr>
	
	<tr> 
		<td align="center" id="footer" colspan="4">
			&nbsp; <input id=submits class="b_foot" name=submits onclick="return(doSubmit())" type=button value=确认>
			&nbsp; <input class="b_foot" name=reee  type=button onClick="form1.reset()" value=清除>
			&nbsp; <input class="b_foot" name=back onClick="history.go(-1)" type=button value=返回>
			&nbsp; <input class="b_foot" name=back onClick="removeCurrentTab()" type=button value=关闭>
		</td>
	</tr>
</table>
      <input type="hidden" name="workNo" value="<%=work_no%>">
      <input type="hidden" name="org_code" value="<%=org_code%>">
      <input type="hidden" name="rptRight" value="L">
      <input type="hidden" name="hDbLogin" value ="dbchange">
      <input type="hidden" name="hParams1" value="">
      <input type="hidden" name="hTableName" value="">
   
	<%@ include file="/npage/include/footer.jsp" %>
</FORM>
</BODY>
</HTML>

<script language="javascript">
/*----------------------------调用RPC处理连动问题------------------------------------------*/

 onload=function(){
	form1.reset();
	}
var change_flag = "";//定义RPC联动全局变量 查询区县:flag_dis  查询营业厅:flag_town 默认:""
function tochange(par)
{
	
	       if(par == "change_dis")//查询区县
			{   
				change_flag = "flag_dis";
				var region_code = document.all.region_code[document.all.region_code.selectedIndex].value.substring(0,2);
				var myPacket = new AJAXPacket("select_rpc.jsp","正在获得区县信息，请稍候......");
				//var sqlStr = "select region_code||district_code,district_code||'-- >'||district_name from sDisCode where region_code = '"+region_code+"' Order By region_code";
				
				var sqlStr = "90000055" ;
				var params = region_code;
				var outNum = "2";
			}
		
		else if(par == "change_town")//查询营业厅
			{
				change_flag = "flag_town";
				var region_code = document.all.region_code[document.all.region_code.selectedIndex].value.substring(0,2);
				var district_code = document.all.district_code[document.all.district_code.selectedIndex].value.substring(2,4);
				var myPacket = new AJAXPacket("select_rpc.jsp","正在获得营业厅信息，请稍候......");
				//var sqlStr = "select region_code||district_code||town_code,town_code||'-- >'||TOWN_NAME from sTownCode where region_code = '"+region_code+"' and district_code = '"+district_code+"' Order By town_code";
				
				var sqlStr = "90000056";
				var params = region_code+"|"+district_code;
				var outNum = "2";
			}
		else if(par == "change_workno")//查询营业厅
			{
				change_flag = "flag_workno";
				var town_code = document.all.town_code[document.all.town_code.selectedIndex].value.substring(0,7);
				var myPacket = new AJAXPacket("select_rpc.jsp","正在获得工号信息，请稍候......");
				//var sqlStr = "select login_no,login_no||'-- >'||nvl(login_name,login_no) from dLoginMsg where org_code like '"+town_code+"%' Order By login_no ";
				
				var sqlStr = "90000057" ;
				var params = town_code;
				var outNum = "2";
			}
		myPacket.data.add("sqlStr",sqlStr);
		myPacket.data.add("params",params);
		myPacket.data.add("outNum",outNum);
		
		core.ajax.sendPacket(myPacket);
		delete(myPacket);
}

/*-----------------------------RPC处理函数------------------------------------------------*/
  function doProcess(packet)
  {
	  var rpc_page=packet.data.findValueByName("rpc_page");
 
	 
	    var triListData = packet.data.findValueByName("tri_list"); 
    
  	    var triList=new Array(triListData.length);
	if(change_flag == "flag_dis")
		{
			  triList[0]="district_code";
			  document.all("district_code").length=0;
			  document.all("district_code").options.length=triListData.length;//triListData[i].length;
			  for(j=0;j<triListData.length;j++)
			  {
				document.all("district_code").options[j].text=triListData[j][1];
				document.all("district_code").options[j].value=triListData[j][0];
			  }//区县结果集
			  document.all("district_code").options[0].selected=true;
			  tochange("change_town");
		}
	else if(change_flag == "flag_town")
		{
			  triList[0]="town_code";
			  document.all("town_code").length=0;
			  document.all("town_code").options.length=triListData.length;//triListData[i].length;
			  for(j=0;j<triListData.length;j++)
			  {
				document.all("town_code").options[j].text=triListData[j][1];
				document.all("town_code").options[j].value=triListData[j][0];
			  }//营业厅结果集
			  document.all("town_code").options[0].selected=true;
			  tochange("change_workno");
		}
	else if(change_flag == "flag_workno")
		{
			  triList[0]="login_no";
			  document.all("login_no").length=0;
			  document.all("login_no").options.length=triListData.length;//triListData[i].length;
			  for(j=0;j<triListData.length;j++)
			  {
				document.all("login_no").options[j].text=triListData[j][1];
				document.all("login_no").options[j].value=triListData[j][0];
			  }//工号结果集
		}
//////////////////////////////////////////////////////////////////////////////////////////
		
	  
   }
function getLoginNo(){
    if(document.all.groupName.value==''){
	    rdShowMessageDialog("请先查询组织节点!");
		form1.town_code.focus();
	    return;
	}
    
	/****************************************************
	var sqlStr=" select rtrim(login_no),rtrim(login_name)   from dloginmsg" +
				         " where org_code like '" +document.all.district_code.value+document.all.town_code.value+
				         "%' ";
    *****************************************************/
    //var sqlStr=" select rtrim(login_no),rtrim(login_name)   from dloginmsg  where group_id= '"+document.all.groupId.value+"'";
    
    var sqlStr = "90000058"
		var params = document.all.groupId.value+"|";
		
    if("<%=rpt_right%>" >= "9")
    {
    	//sqlStr = sqlStr + " and login_no = '< % = work_no % >'";
    	sqlStr = "90000059"
    	params = document.all.groupId.value+"|<%=work_no%>"+"|";
    }
    
    if(document.form1.login_no.value != "")
    {
        //sqlStr = sqlStr + " and login_no like '" + document.form1.login_no.value + "%'";
        if("90000059"==sqlStr){
        	sqlStr = "90000060"
        	params = document.all.groupId.value+"|<%=work_no%>"+"|"+ document.form1.login_no.value+"|";
      	}else if("90000058"==sqlStr){
      		sqlStr = "90000061"
        	params = document.all.groupId.value+"|"+ document.form1.login_no.value+"|";
      	}
    }
    
    //sqlStr = sqlStr + " order by login_no" ;
    
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "2|0|1|";
    var retToField = "login_no|login_name|";
    //PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
    

			
			var pageTitle = "营业员查询";
    	var fieldName = "营业员工号|营业员名称|";
			var path = "<%=request.getContextPath()%>/npage/public/fPubSimpSel.jsp";
			path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
			path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
			path = path + "&selType=" + selType+ "&params=" + params;
			var retInfo = window.showModalDialog(path,"","dialogWidth:70;dialogHeight:35;");
			if(typeof(retInfo)!="undefined"){
				var tempArr = retInfo.split("|");
				document.form1.login_no.value = tempArr[0];
				document.form1.login_name.value = tempArr[1];
			}
			
}
function changeLoginNo(){
   document.all.login_name.value="";
}	
</script>