<!DOCTYPE html PUBLIC "-//W3C//Dtd Xhtml 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<%
  /*
   * 功能: 新地区操作统计报表(铁通)8560
   * 版本: 1.0
   * 日期: 2010/06/14
   * 作者: wangyua
   * 版权: si-tech
   * update:
  */
%>
<%@	page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%	request.setCharacterEncoding("GBK");%> 
<%
	String opCode ="8560";
	String opName = "新地区操作统计报表(铁通)";
	String workNo = (String)session.getAttribute("workNo");
	String rpt_right = (String)session.getAttribute("rptRight");//得到报表权限 rpt_right
	
    String sqlStr="";
	int i=0;
	String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());

%>

<html xmlns="http://www.w3.org/1999/xhtml">
	<HEAD><TITLE>新地区操作统计表(铁通)</TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"></HEAD>
<!-------------------------------------------------------------------------------->
<%if(rpt_right.compareTo("4")>=0){%>
<script language="jscript">
	rdShowMessageDialog('您没有操作此报表的权限!');
	window.close();
</script>
<%}%>
<!-------------------------------------------------------------------------------->

<script language=JavaScript>
//----弹出一个新页面选择组织节点--- 增加
function select_groupId()
{
	var path = "<%=request.getContextPath()%>/npage/rpt/common/grouptreeTT.jsp?execJsp=rpt_f1640upg";
    window.open(path,'_blank','height=600,width=300,scrollbars=yes');
}
</script>

<SCRIPT language="JavaScript">
function doSubmit()
{
	getAfterPrompt();
	
	if(document.form1.rpt_type.value==14) {
	  if(document.form1.all("begin_time").value.length == 8)
      document.form1.begin_time.value=document.form1.begin_time.value+" 00:00:00";
  if(document.form1.all("end_time").value.length == 8)
      document.form1.end_time.value=document.form1.end_time.value+" 23:59:59";
    }
      
	if(document.form1.groupName.value==""){
		rdShowMessageDialog("'组织节点'为必填项,请务必填写!");
		return false;	
	}
	if(!check(form1))
	{
		rdShowMessageDialog("检查Form错误",0);
		return false;
	}
	if(document.form1.bGroupId.value>document.form1.eGroupId.value)
	{
		rdShowMessageDialog("开始组织节点比结束组织节大!");
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
     		 hTableName.value="rcr001";
      		hParams1.value= "prc_1640_TD206_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.bGroupId.value+"','"+document.form1.eGroupId.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"' ";
   		}
   		else if(document.form1.rpt_type.value==2)
    	{
     		 hTableName.value="rcr001";
      		hParams1.value= "prc_1640_TD207_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.bGroupId.value+"','"+document.form1.eGroupId.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"' ";
   		}
   		else if(document.form1.rpt_type.value==3)
    	{
     		 hTableName.value="rcr001";
      		hParams1.value= "prc_1640_TD208_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.bGroupId.value+"','"+document.form1.eGroupId.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"' ";
   		}
   		else if(document.form1.rpt_type.value==4)
    	{
     		 hTableName.value="rcr001";
      		hParams1.value= "prc_1640_TD209_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.bGroupId.value+"','"+document.form1.eGroupId.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"' ";
   		}
   		else if(document.form1.rpt_type.value==5)
    	{
     		 hTableName.value="rpr001";
      	 hParams1.value= "DBCUSTADM.PRC_8560_PR001_UPG('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.bGroupId.value+"','"+document.form1.eGroupId.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"' ";
   			 document.form1.action="print_rpt_boss.jsp";
   		}
   		   		else if(document.form1.rpt_type.value==6)

    	{
     		 hTableName.value="rbr001";
      	 hParams1.value= "PRC_8560_OP004_UPG('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.bGroupId.value+"','"+document.form1.eGroupId.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"' ";
   			 document.form1.action="print_rpt_crm_report.jsp"; 

   		}
   		 else if(document.form1.rpt_type.value==7)

    	{
     		 hTableName.value="rcd002";
      	 hParams1.value= "PRC_8560_KH004_UPG('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.bGroupId.value+"','"+document.form1.eGroupId.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"' ";
   			 document.form1.action="print_rpt_crm_report.jsp"; 

   		}
   		
   		   		 else if(document.form1.rpt_type.value==8)

    	{
     		 hTableName.value="rcr001";
      	 hParams1.value= "prc_8660_303TD_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.bGroupId.value+"','"+document.form1.eGroupId.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"' ";

   		}

   		   		 else if(document.form1.rpt_type.value==9)

    	{
     		 hTableName.value="rcr001";
      	 hParams1.value= "prc_8560_pr0017_3_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.bGroupId.value+"','"+document.form1.eGroupId.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"' ";
   			 document.form1.action="print_rpt_crm_report.jsp"; 

   		}
   		   		else if(document.form1.rpt_type.value==10)

    	{
     		 hTableName.value="rbr001";
      	 hParams1.value= "prc_8560_hwprt_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.bGroupId.value+"','"+document.form1.eGroupId.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"' ";

   		}
   		   		else if(document.form1.rpt_type.value==11)

    	{
     		 hTableName.value="rbo006";
      	 hParams1.value= "prc_8560_314_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.bGroupId.value+"','"+document.form1.eGroupId.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"' ";
   			 document.form1.action="print_rpt_crm_report.jsp"; 

   		}

   		
	submit();
  }
}
function callDisCode(){
	var i = 0;
	var regionCode = 0;
	for(i = 0 ; i < document.form1.region_code.length ; i ++){
		if(document.form1.region_code.options[i].selected){
			regionCode = document.form1.region_code.options[i].value;
			
		}
	}	
    var myPacket = new AJAXPacket("callDisCode.jsp","正在查询，请稍候......");
		  myPacket.data.add("region_code",regionCode);
    	core.ajax.sendPacket(myPacket);
    	myPacket = null;
    	
}


</SCRIPT>

<FORM method=post name="form1" action="print_rpt.jsp">
	<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">请选择操作报表</div>
	</div>
<table cellSpacing="0">
	<tr>
		<td class="blue">操作报表</td>
        <td colspan="3">
        <select name=rpt_type onChange="onChangeRptType()" style='width:400px'>
					<option class='button' value=1>1->地区预存话费赠TD固话(铁通)统计报表</option>
					<option class='button' value=2>2->地区预存话费赠TD商务固话统计报表(铁通)</option>
					<option class='button' value=3>3->地区重新购TD商务固话，赠通信费(铁通)统计报表</option>
					<option class='button' value=4>4->地区重新预存话费赠TD固话(铁通)统计报表</option>
					<option class='button' value=5>5->地区交费操作(铁通)统计报表</option>
					<option class='button' value=6>6->地市业务操作统计表（铁通）</option>
					<option class='button' value=7>7->地市开户业务统计表（铁通）</option>
					<option class='button' value=8>8->地区购TD商务固话赠通信费统计报表(铁通)</option>
					<option class='button' value=9>9->地区业务稽核统计报表(铁通)</option>
					<option class='button' value=10>10->地区电子化工单打印统计报表(铁通)</option>
					<option class='button' value=11>11->地区电子发票统计报表(铁通)</option>
				</select>
        </TD>
  </tr>
                 
    <tr>
			<td class="blue">组织节点</td>
			<td colspan="3">
				<input type="hidden" name="groupId" >
				<input type="text" name="groupName" v_must="1" v_type="string" maxlength="60" readonly>&nbsp;<font color="orange">*</font>
				<input name="addButton" class="b_text" type="button" value="选择" onClick="select_groupId()" >	
				<input name="refbutton" class="b_text" type="button" value="刷新" onClick= "tochange('change_group')" >	
			</td>
		</tr>       
        	
		<tr id="group_head">
			<td class="blue">开始组织节点</td>
			<td>	
				<select name="bGroupId" style="width:420px;">
					<option class='button' value='0'> 未选定 </option>
				</select>
			</td>
			<td class="blue">结束组织节点</td>
			<td>
				<select name="eGroupId" style="width:420px;">
					<option class='button' value='0'> 未选定 </option>
				</select>
			</td>
		</tr>  
		
		<tr>
			<td class="blue">开始时间</td>
			<td>
				<input type="text" v_type="date"  name="begin_time" value=<%=dateStr%> size="17" maxlength="17">
			</td>
			<td class="blue">结束时间</td>
			<td>
				<input type="text" v_type="date"  name="end_time" value=<%=dateStr%> size="17" maxlength="17">
			</td>
		</tr>   
		
		<tr id="phone_head" style="display:none">
			<td class="blue">开始号段</td>
			<td>
				<input type="text" class="button" name="begin_phonehead"  size="17" maxlength="7" >
			</td>
			<td class="blue">结束号段</td>
			<td>
				<input type="text" class="button" name="end_phonehead"  size="17" maxlength="7"  >
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
	  <input type="hidden" name="workNo" value="<%=workNo%>">    
      <input type="hidden" name="hDbLogin" value ="dbchange">
      <input type="hidden" name="rptRight" value="R">
      <input type="hidden" name="hParams1" value="">
      <input type="hidden" name="hTableName" value="">
      
	<%@ include file="/npage/include/footer.jsp" %> 
</FORM>
</BODY>
</HTML>

<script language="javascript">
/*----------------------------调用RPC处理连动问题------------------------------------------*/

 onload=function()
 {
	form1.reset();
	core.ajax.onreceive = doProcess;
 }
function tochange()
{
		var group_id = document.all.groupId.value;
		var myPacket = new AJAXPacket("select_rpc.jsp","正在获得组织机构信息，请稍候......");
		//var sqlStr = "select a.group_id,a.group_id||'-- >'||group_name    from dChnGroupMsg a,dbresadm.dChnGroupInfo b   where a.group_id=b.group_id     and b.parent_group_id='"+group_id+"'     and b.denorm_level=1   Order By a.group_id";
		
				var sqlStr = "90000070" ;
				var params = group_id+"|";
				var outNum = "2";		
				
				myPacket.data.add("sqlStr",sqlStr);
				myPacket.data.add("params",params);				
				myPacket.data.add("outNum",outNum);
				
		myPacket.data.add("sqlStr",sqlStr);
		core.ajax.sendPacket(myPacket);
		myPacket = null;
}

/*-----------------------------RPC处理函数------------------------------------------------*/
  function doProcess(packet)
  {
	  var rpc_page=packet.data.findValueByName("rpc_page");
 
	 
	    var triListData = packet.data.findValueByName("tri_list"); 
    
  	    var triList=new Array(triListData.length);
  	    triList[0]="bGroupId";
		document.all("bGroupId").length=0;
		document.all("bGroupId").options.length=triListData.length+1;//triListData[i].length;
		document.all("bGroupId").options[0].text='未选定';
		document.all("bGroupId").options[0].value='0';
		for(j=0;j<triListData.length;j++)
		{
			document.all("bGroupId").options[j+1].text=triListData[j][1];
			document.all("bGroupId").options[j+1].value=triListData[j][0];
		}//开始组织节点结果集
		document.all("eGroupId").length=0;
		document.all("eGroupId").options.length=triListData.length+1;//triListData[i].length;
		document.all("eGroupId").options[0].text='未选定';
		document.all("eGroupId").options[0].value='0';
		for(j=triListData.length-1;j>=0;j--)
		{
			k=triListData.length-1-j;
			document.all("eGroupId").options[k+1].text=triListData[j][1];
			document.all("eGroupId").options[k+1].value=triListData[j][0];
		}//结束组织节点结果集
  	    
	
   }


 function onChangeRptType()
{
	
	if(document.form1.rpt_type.value==79||document.form1.rpt_type.value==77)
	{
		
	//	document.form1.phone_head.style.visibility="visible";
		document.all.phone_head.style.display="block";
		
	}
	else
	{
	//	document.form1.phone_head.style.visibility="hidden";
		document.all.phone_head.style.display="none";
	}
	
	if(document.form1.rpt_type.value==144)
	{
		document.all.group_head.style.display="none";
	}
	else
	{
		document.all.group_head.style.display="block";
	}
	
}	
</script>
