<!DOCTYPE html PUBLIC "-//W3C//Dtd Xhtml 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<%
  /*
   * 功能: 新营业厅操作统计报表2147
   * 版本: 1.0
   * 日期: 200/01/04
   * 作者: leimd
   * 版权: si-tech
   * update:
  */
%>
<%@	page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %> 
<%	request.setCharacterEncoding("GBK");%>
<%
	String opCode="2147";
	String opName="新营业厅操作统计报表";
	String work_no = (String)session.getAttribute("workNo");
	String rpt_right = (String)session.getAttribute("rptRight");
	String org_code = (String)session.getAttribute("orgCode");
	String town="";
    String sqlStr="";
	String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());

%>
<script language="JavaScript">
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD><TITLE>新营业厅操作统计表</TITLE>
</HEAD>
<body>

<script src="f1625_crm.js" type="text/javascript"></script>	
<script src="f1625_crm_report.js" type="text/javascript"></script>	
<script src="f1625_boss.js" type="text/javascript"></script>	
<!-------------------------------------------------------------------------------->
<%if(rpt_right.compareTo("9")>=0){%>
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
	/*2014/10/22 16:46:20 gaopeng 加入一个传值 传给grouptree.jsp 作为回调时调用默认赋值开始结束工号的标识 */
	var path = "<%=request.getContextPath()%>/npage/rpt/common/grouptree.jsp?execJsp=f1625_upg";
  window.open(path,'_blank','height=600,width=300,scrollbars=yes');
}
/*2014/10/22 17:00:35 gaopeng 获取默认开始工号结束工号方法*/
function getLoginNoDefault(groupId){
	var getdataPacket = new AJAXPacket("/npage/rpt/common/f1625DefLoginNo.jsp","正在获得数据，请稍候......");
	getdataPacket.data.add("groupId",groupId);
	core.ajax.sendPacket(getdataPacket,retGetDefLoginNo);
	getdataPacket = null;
}
/*回调函数*/
function retGetDefLoginNo(packet){
	var retCode = packet.data.findValueByName("retCode");
	var retMsg = packet.data.findValueByName("retMsg");
	if(retCode == "000000"){
		var begin_login = packet.data.findValueByName("begin_login");
		var begin_name = packet.data.findValueByName("begin_name");
		var end_login = packet.data.findValueByName("end_login");
		var end_name = packet.data.findValueByName("end_name");
		
		$("input[name='begin_login']").val(begin_login);
		$("input[name='begin_name']").val(begin_name);
		$("input[name='end_login']").val(end_login);
		$("input[name='end_name']").val(end_name);
		
	}else{
		rdShowMessageDialog("错误代码："+retCode+",错误信息："+retMsg,1);
	}
}
</script>

<SCRIPT language="JavaScript">

function changerpt()
{
  if(document.form1.rpt_type.value==1)
  {
    document.all("rpt_format").options.length=6;
    document.all("rpt_format").options[0].text='明细';
    document.all("rpt_format").options[0].value='10000';
    document.all("rpt_format").options[1].text='工号小计';
    document.all("rpt_format").options[1].value='01000';
    document.all("rpt_format").options[2].text='操作小计';
    document.all("rpt_format").options[2].value='00100';
    document.all("rpt_format").options[3].text='明细+工号小计';
    document.all("rpt_format").options[3].value='11000';
    document.all("rpt_format").options[4].text='明细+操作小计';
    document.all("rpt_format").options[4].value='10100';
    document.all("rpt_format").options[5].text='明细+工号小计+操作小计';
    document.all("rpt_format").options[5].value='11100';
  }
  else if(document.form1.rpt_type.value==2)
  {
    document.all("rpt_format").options.length=8;
    document.all("rpt_format").options[0].text='明细';
    document.all("rpt_format").options[0].value='10000';
    document.all("rpt_format").options[1].text='工号小计';
    document.all("rpt_format").options[1].value='01000';
    document.all("rpt_format").options[2].text='操作小计';
    document.all("rpt_format").options[2].value='00100';
    document.all("rpt_format").options[3].text='交费方式小计';
    document.all("rpt_format").options[3].value='00010';
    document.all("rpt_format").options[4].text='明细+工号小计';
    document.all("rpt_format").options[4].value='11000';
    document.all("rpt_format").options[5].text='明细+操作小计';
    document.all("rpt_format").options[5].value='10100';
    document.all("rpt_format").options[6].text='明细+交费方式小计';
    document.all("rpt_format").options[6].value='10010';
    document.all("rpt_format").options[7].text='明细+工号小计+操作小计+交费方式小计';
    document.all("rpt_format").options[7].value='11110';
  }
  else if(document.form1.rpt_type.value==3)
  {
    document.all("rpt_format").options.length=6;
    document.all("rpt_format").options[0].text='明细';
    document.all("rpt_format").options[0].value='10000';
    document.all("rpt_format").options[1].text='工号小计';
    document.all("rpt_format").options[1].value='01000';
    document.all("rpt_format").options[2].text='操作小计';
    document.all("rpt_format").options[2].value='00100';
    document.all("rpt_format").options[3].text='明细+工号小计';
    document.all("rpt_format").options[3].value='11000';
    document.all("rpt_format").options[4].text='明细+操作小计';
    document.all("rpt_format").options[4].value='10100';
    document.all("rpt_format").options[5].text='明细+工号小计+操作小计';
    document.all("rpt_format").options[5].value='11100';
  }
  else if(document.form1.rpt_type.value==4)
  {
    document.all("rpt_format").options.length=8;
    document.all("rpt_format").options[0].text='明细';
    document.all("rpt_format").options[0].value='10000';
    document.all("rpt_format").options[1].text='工号小计';
    document.all("rpt_format").options[1].value='01000';
    document.all("rpt_format").options[2].text='操作小计';
    document.all("rpt_format").options[2].value='00100';
    document.all("rpt_format").options[3].text='卡类小计';
    document.all("rpt_format").options[3].value='00010';
    document.all("rpt_format").options[4].text='明细+工号小计';
    document.all("rpt_format").options[4].value='11000';
    document.all("rpt_format").options[5].text='明细+操作小计';
    document.all("rpt_format").options[5].value='10100';
    document.all("rpt_format").options[6].text='明细+卡类小计';
    document.all("rpt_format").options[6].value='10010';
    document.all("rpt_format").options[7].text='明细+工号小计+操作小计+卡类小计';
    document.all("rpt_format").options[7].value='11110';
  }
  else if(document.form1.rpt_type.value==5)
  {
    document.all("rpt_format").options.length=8;
    document.all("rpt_format").options[0].text='明细';
    document.all("rpt_format").options[0].value='10000';
    document.all("rpt_format").options[1].text='工号小计';
    document.all("rpt_format").options[1].value='01000';
    document.all("rpt_format").options[2].text='操作小计';
    document.all("rpt_format").options[2].value='00100';
    document.all("rpt_format").options[3].text='特服小计';
    document.all("rpt_format").options[3].value='00010';
    document.all("rpt_format").options[4].text='明细+工号小计';
    document.all("rpt_format").options[4].value='11000';
    document.all("rpt_format").options[5].text='明细+操作小计';
    document.all("rpt_format").options[5].value='10100';
    document.all("rpt_format").options[6].text='明细+特服小计';
    document.all("rpt_format").options[6].value='10010';
    document.all("rpt_format").options[7].text='明细+工号小计+操作小计+特服小计';
    document.all("rpt_format").options[7].value='11110';
  }
  else if(document.form1.rpt_type.value==7)
  {
    document.all("rpt_format").options.length=8;
    document.all("rpt_format").options[0].text='明细';
    document.all("rpt_format").options[0].value='10000';
    document.all("rpt_format").options[1].text='工号小计';
    document.all("rpt_format").options[1].value='01000';
    document.all("rpt_format").options[2].text='操作小计';
    document.all("rpt_format").options[2].value='00100';
    document.all("rpt_format").options[3].text='优惠小计';
    document.all("rpt_format").options[3].value='00010';
    document.all("rpt_format").options[4].text='明细+工号小计';
    document.all("rpt_format").options[4].value='11000';
    document.all("rpt_format").options[5].text='明细+操作小计';
    document.all("rpt_format").options[5].value='10100';
    document.all("rpt_format").options[6].text='明细+优惠小计';
    document.all("rpt_format").options[6].value='10010';
    document.all("rpt_format").options[7].text='明细+工号小计+操作小计+优惠小计';
    document.all("rpt_format").options[7].value='11110';
  }
  else if(document.form1.rpt_type.value==8)
  {
    document.all("rpt_format").options.length=8;
    document.all("rpt_format").options[0].text='明细';
    document.all("rpt_format").options[0].value='10000';
    document.all("rpt_format").options[1].text='工号小计';
    document.all("rpt_format").options[1].value='01000';
    document.all("rpt_format").options[2].text='操作小计';
    document.all("rpt_format").options[2].value='00100';
    document.all("rpt_format").options[3].text='兑换名称小计';
    document.all("rpt_format").options[3].value='00010';
    document.all("rpt_format").options[4].text='明细+工号小计';
    document.all("rpt_format").options[4].value='11000';
    document.all("rpt_format").options[5].text='明细+操作小计';
    document.all("rpt_format").options[5].value='10100';
    document.all("rpt_format").options[6].text='明细+兑换名称小计';
    document.all("rpt_format").options[6].value='10010';
    document.all("rpt_format").options[7].text='明细+工号小计+操作小计+兑换名称小计';
    document.all("rpt_format").options[7].value='11110';
  }
  else if(document.form1.rpt_type.value==9)
  {
    document.all("rpt_format").options.length=8;
    document.all("rpt_format").options[0].text='明细';
    document.all("rpt_format").options[0].value='10000';
    document.all("rpt_format").options[1].text='工号小计';
    document.all("rpt_format").options[1].value='01000';
    document.all("rpt_format").options[2].text='操作小计';
    document.all("rpt_format").options[2].value='00100';
    document.all("rpt_format").options[3].text='手机型号小计';
    document.all("rpt_format").options[3].value='00010';
    document.all("rpt_format").options[4].text='明细+工号小计';
    document.all("rpt_format").options[4].value='11000';
    document.all("rpt_format").options[5].text='明细+操作小计';
    document.all("rpt_format").options[5].value='10100';
    document.all("rpt_format").options[6].text='明细+手机型号小计';
    document.all("rpt_format").options[6].value='10010';
    document.all("rpt_format").options[7].text='明细+工号小计+操作小计+手机型号小计';
    document.all("rpt_format").options[7].value='11110';
  }
  else if(document.form1.rpt_type.value==10)
  {
    document.all("rpt_format").options.length=8;
    document.all("rpt_format").options[0].text='明细';
    document.all("rpt_format").options[0].value='10000';
    document.all("rpt_format").options[1].text='工号小计';
    document.all("rpt_format").options[1].value='01000';
    document.all("rpt_format").options[2].text='操作小计';
    document.all("rpt_format").options[2].value='00100';
    document.all("rpt_format").options[3].text='回馈小计';
    document.all("rpt_format").options[3].value='00010';
    document.all("rpt_format").options[4].text='明细+工号小计';
    document.all("rpt_format").options[4].value='11000';
    document.all("rpt_format").options[5].text='明细+操作小计';
    document.all("rpt_format").options[5].value='10100';
    document.all("rpt_format").options[6].text='明细+回馈小计';
    document.all("rpt_format").options[6].value='10010';
    document.all("rpt_format").options[7].text='明细+工号小计+操作小计+回馈小计';
    document.all("rpt_format").options[7].value='11110';
  }
  else if(document.form1.rpt_type.value==11)
  {
    document.all("rpt_format").options.length=6;
    document.all("rpt_format").options[0].text='明细';
    document.all("rpt_format").options[0].value='10000';
    document.all("rpt_format").options[1].text='工号小计';
    document.all("rpt_format").options[1].value='01000';
    document.all("rpt_format").options[2].text='操作小计';
    document.all("rpt_format").options[2].value='00100';
    document.all("rpt_format").options[3].text='明细+工号小计';
    document.all("rpt_format").options[3].value='11000';
    document.all("rpt_format").options[4].text='明细+操作小计';
    document.all("rpt_format").options[4].value='10100';
    document.all("rpt_format").options[5].text='明细+工号小计+操作小计';
    document.all("rpt_format").options[5].value='11100';
  }
  else
  {
    document.all("rpt_format").options.length=1;
    document.all("rpt_format").options[0].text='明细';
    document.all("rpt_format").options[0].value='10000';
  }
}

function doSubmit()
{
	var sdate = document.form1.begin_time.value;
	var edate = document.form1.end_time.value;
  getAfterPrompt();
  if(document.form1.all("begin_time").value.length == 8)
      document.form1.begin_time.value=document.form1.begin_time.value+" 00:00:00";
  if(document.form1.all("end_time").value.length == 8)
      document.form1.end_time.value=document.form1.end_time.value+" 23:59:59";

  if(!check(form1))
  {
    return false;
  }
  /* begin add for 关于优化报表打印页面程序的需求@2014/12/3 */
  if(document.all.groupId.value == ""){
  	rdShowMessageDialog("'组织节点'为必填项,请务必填写!");
    return false;
  }
  /* end add for 关于优化报表打印页面程序的需求@2014/12/3 */
  if(document.form1.begin_login.value>document.form1.end_login.value)
  {
    alert("开始工号比结束工号大");
    return false;
  }

  var begin_time=document.form1.begin_time.value;
  var end_time=document.form1.end_time.value;
  if(begin_time>end_time)
  {
    alert("开始时间比结束时间大");
    return false;
  }

	sdate = sdate.substring(0,4) + "-" + sdate.substring(4,6) + "-" + sdate.substring(6,8);
  edate = edate.substring(0,4) + "-" + edate.substring(4,6) + "-" + edate.substring(6,8);
  if(DateDiff(sdate,edate) > 30){
  	rdShowMessageDialog("为避免打印时间跨度过大而造成其他人无法正常打印报表，请将打印时间范围限制在一个月以内！");
    return false;
  }
   	select_boss(document.form1);
  	select_crm(document.form1);
  	select_crm_bao(document.form1);
    document.form1.submit();

}

function  DateDiff(sDate1,  sDate2){    //sDate1和sDate2是2002-12-18格式  
       var  aDate,  oDate1,  oDate2,  iDays;  
       aDate  =  sDate1.split("-");  
       oDate1  =  new  Date(aDate[1]  +  '-'  +  aDate[2]  +  '-'  +  aDate[0]) ;   //转换为12-18-2002格式  
       aDate  =  sDate2.split("-");  
       oDate2  =  new  Date(aDate[1]  +  '-'  +  aDate[2]  +  '-'  +  aDate[0]);  
       iDays  =  parseInt(Math.abs(oDate1  -  oDate2)  /  1000  /  60  /  60  /24);    //把相差的毫秒数转换为天数  
       return  iDays;  
}

</SCRIPT>

<FORM method=post name="form1">
	<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">请选择操作报表</div>
	</div>
<table cellSpacing="0">
				<!-- ningtn @ 2010-10-26 优化项目 -->
   <tr>
		<td class="blue" >
			模糊检索
		</td>
		<td colspan="3">
			<input type="text" id="searchTextrpt" name="searchTextrpt" 
			 value="请输入查询条件" 
			 size="40"
			 style="padding-top:3px;"
			 onFocus="form1.searchTextrpt.value='';clearResults();"  
			 onpropertychange="blurSearchFunc('rpt_type','searchTextrpt','->')" />
		</td>
	</tr>
	<tr>
		<td class="blue">操作报表</td>
		<td>
			<select name=rpt_type onChange="changerpt()"  style='width:400px'>
				 <wtc:qoption name="sPubSelect" outnum="2">
          <wtc:sql>
          	select select_value,select_name 
          	from sreportfunc where function_code = '<%=opCode%>' 
          	order by select_value
					</wtc:sql>
	      </wtc:qoption>
			</select>
		</td>
		<td class="blue">报表格式</td>
		<td>
			<select name=rpt_format>
				<option class='button' value=10000>明细</option>
				<option class='button' value=01000>工号小计</option>
				<option class='button' value=00100>操作小计</option>
				<option class='button' value=11000>明细+工号小计</option>
				<option class='button' value=10100>明细+操作小计</option>
				<option class='button' value=11100>明细+工号小计+操作小计</option>
			</select>
		</td>
	</tr>
	
	<tr>
		<td class="blue">组织节点</td>
		<td colspan="3">
			<input type="hidden" name="groupId" >
			<input type="text" name="groupName" v_must="1" v_type="string" maxlength="60" class="InputGrey" readonly>&nbsp;<font color="orange">*</font>
			<input name="addButton" class="b_text" type="button" value="选择" onClick="select_groupId()" >	
		</td>
	</tr>
                
	<tr>
		<td class="blue">开始工号</td>
		<td>
			<input type="text" name="begin_login" class="button" maxlength="6" size="8" onChange="changeBeginLogin()">
			<input type="text" name="begin_name" class="button" disabled>
			<input name="loginNoQuery" class="b_text" type="button" onClick="getBeginLogin()" value="查询">
		</td>
		<td class="blue">结束工号</td>
		<td>
			<input type="text" name="end_login" class="button" maxlength="6" size="8" onChange="changeEndLogin()">
			<input type="text" name="end_name" class="button" disabled>
			<input name="loginNoQuery" class="b_text" type="button" onClick="getEndLogin()" value="查询">
		</td>
    </tr>
	<tr>
		<td class="blue">开始时间</td>
		<td>
			<input type="text"   name="begin_time" value=<%=dateStr%> size="17" maxlength="17">
		</td>
		<td class="blue">结束时间</td>
		<td>
			<input type="text"   name="end_time" value=<%=dateStr%> size="17" maxlength="17">
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
      <input type="hidden" name="workNo" value="<%=work_no%>">
       <input type="hidden" name="org_code" value="<%=org_code%>">
      <input type="hidden" name="rptRight" value="T">
      <input type="hidden" name="hDbLogin" value ="dbchange">
      <input type="hidden" name="hParams1" value="">
      <input type="hidden" name="hTableName" value="">
</table>
  <%@ include file="/npage/public/pubSearchText.jsp" %>
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
{       if(par == "change_dis")//查询区县
			{   
				change_flag = "flag_dis";
				var region_code = document.all.region_code[document.all.region_code.selectedIndex].value.substring(0,2);
				var myPacket = new AJAXPacket("select_rpc.jsp","正在获得区县信息，请稍候......");
				var sqlStr = "select region_code||district_code,district_code||'-- >'||district_name from sDisCode where region_code = '"+region_code+"' Order By district_code";
			}
		
		if(par == "change_town")//查询营业厅
			{
				change_flag = "flag_town";
				var region_code = document.all.region_code[document.all.region_code.selectedIndex].value.substring(0,2);
				var district_code = document.all.district_code[document.all.district_code.selectedIndex].value.substring(2,4);
				var myPacket = new AJAXPacket("select_rpc.jsp","正在获得营业厅信息，请稍候......");
				var sqlStr = "select region_code||district_code||town_code,town_code||'-- >'||TOWN_NAME from sTownCode where region_code = '"+region_code+"' and district_code = '"+district_code+"' Order By town_code";
			}
		if(par == "change_workno")//查询营员
			{
				change_flag = "flag_workno";
				var town_code = document.all.town_code[document.all.town_code.selectedIndex].value.substring(0,7);
				var myPacket = new AJAXPacket("select_rpc.jsp","正在获得工号信息，请稍候......");
				var sqlStr = "select login_no,login_no||'-- >'||nvl(login_name,login_no) from dLoginMsg where org_code like '"+town_code+"%' Order By login_no";
				
			}
			//alert(change_flag);
		myPacket.data.add("sqlStr",sqlStr);
		core.ajax.sendPacket(myPacket);
		delete(myPacket);
}

/*-----------------------------RPC处理函数------------------------------------------------*/
  function doProcess(packet)
  {
	  var rpc_page=packet.data.findValueByName("rpc_page");
 
	 
	    var triListdata = packet.data.findValueByName("tri_list"); 
    
  	    var triList=new Array(triListdata.length);
	if(change_flag == "flag_dis")
		{
			  triList[0]="district_code";
			  document.all("district_code").length=0;
			  document.all("district_code").options.length=triListdata.length;//triListdata[i].length;
			  for(j=0;j<triListdata.length;j++)
			  {
				document.all("district_code").options[j].text=triListdata[j][1];
				document.all("district_code").options[j].value=triListdata[j][0];
			  }//区县结果集
			  document.all("district_code").options[0].selected=true;
			  tochange("change_town");
		}
	else if(change_flag == "flag_town")
		{
			  triList[0]="town_code";
			  document.all("town_code").length=0;
			  document.all("town_code").options.length=triListdata.length;//triListdata[i].length;
			  for(j=0;j<triListdata.length;j++)
			  {
				document.all("town_code").options[j].text=triListdata[j][1];
				document.all("town_code").options[j].value=triListdata[j][0];
			  }//营业厅结果集
			  document.all("town_code").options[0].selected=true;
			  tochange("change_workno");
		}
	else if(change_flag == "flag_workno")
		{
			  triList[0]="begin_login";
			  document.all("begin_login").length=0;
			  document.all("begin_login").options.length=triListdata.length+1;//triListdata[i].length;
				document.all("begin_login").options[0].text='未选定';
				document.all("begin_login").options[0].value=document.all.town_code[document.all.town_code.selectedIndex].value.substring(0,7);
			  for(j=0;j<triListdata.length;j++)
			  {
				document.all("begin_login").options[j+1].text=triListdata[j][1];
				document.all("begin_login").options[j+1].value=triListdata[j][0];
			  }//开始工号结果集

			  document.all("end_login").length=0;
			  document.all("end_login").options.length=triListdata.length+1;//triListdata[i].length;
				document.all("end_login").options[0].text='未选定';
				document.all("end_login").options[0].value=document.all.town_code[document.all.town_code.selectedIndex].value.substring(0,7);
			  for(j=triListdata.length-1;j>=0;j--)
			  {
			  	k=triListdata.length-1-j
				document.all("end_login").options[k+1].text=triListdata[j][1];
				document.all("end_login").options[k+1].value=triListdata[j][0];
			  }//结束工号结果集
			  
		}
//////////////////////////////////////////////////////////////////////////////////////////
		
	  
   }
function getBeginLogin(){
    if(document.all.groupName.value==''){
	    rdShowMessageDialog("请先查询组织节点!");
		form1.town_code.focus();
	    return;
	}
    var pageTitle = "营业员查询";
    var fieldName = "营业员工号|营业员名称";
	/****************************************************
	var sqlStr=" select rtrim(login_no),rtrim(login_name)   from dloginmsg" +
				         " where org_code like '" +document.all.district_code.value+document.all.town_code.value+
				         "%' ";
    *****************************************************/
    var sqlStr=" select rtrim(login_no),rtrim(login_name)   from dloginmsg" +
				         " where vilid_flag='1' and group_id= '"+document.all.groupId.value+"'";
    
    if(document.form1.begin_login.value != "")
    {
    	/*2014/10/22 16:37:44 gaopeng 关于2147新营业厅操作统计报表的优化需求 发现这里少了个 and */
        sqlStr = sqlStr + " and login_no like '" + document.form1.begin_login.value + "%'";
    }
    sqlStr = sqlStr + " order by login_no" ;
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "0|1";
    var retToField = "begin_login|begin_name";
    PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
}
function changeBeginLogin(){
   document.all.begin_name.value="";
}
function getEndLogin(){
    if(document.all.groupName.value==''){
	    rdShowMessageDialog("请先查询组织节点!");
		form1.town_code.focus();
	    return;
	}
    var pageTitle = "营业员查询";
    var fieldName = "营业员工号|营业员名称";
	/****************************************************
	var sqlStr=" select rtrim(login_no),rtrim(login_name)   from dloginmsg" +
				         " where org_code like '" +document.all.district_code.value+document.all.town_code.value+
				         "%' ";
    *****************************************************/
    var sqlStr=" select rtrim(login_no),rtrim(login_name)   from dloginmsg" +
				         " where  vilid_flag='1' and group_id= '"+document.all.groupId.value+"'";
    
    if(document.form1.end_login.value != "")
    {
        sqlStr = sqlStr + " and login_no like '" + document.form1.end_login.value + "%'";
    }
    sqlStr = sqlStr + " order by login_no desc" ;
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "0|1";
    var retToField = "end_login|end_name";
    PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
}
function changeEndLogin(){
   document.all.end_name.value="";
}
</script>
