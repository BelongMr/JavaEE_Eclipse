<!DOCTYPE html PUBLIC "-//W3C//Dtd Xhtml 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<%
  /*
   * 功能: 新营业员操作明细报表(铁通) g642
   * 版本: 1.0
   * 日期: 2013/04/19
   * 作者: diling
   * 版权: si-tech
   * update:
  */
%>
<% request.setCharacterEncoding("GBK");%>
<%@	page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.sitech.boss.pub.config.*" %>
<%@ page import="com.sitech.boss.s1100.viewBean.*" %>
<%@ page import="org.apache.log4j.Logger"%>
<%
	String opCode="g642";
	String opName="新营业员操作明细报表(铁通)";
	Logger logger = Logger.getLogger("fg642_upg.jsp");
	String work_no = (String)session.getAttribute("workNo");
	String org_code = (String)session.getAttribute("orgCode");
	String rpt_right= (String)session.getAttribute("rptRight");
	String regionCode=(String)session.getAttribute("regCode");
//	System.out.println("rpt_right============="+rpt_right);

	String sqlStr="";
	int recordNum=0;
	int i=0;

	String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());

%>
<script src="fg642_crm.js" type="text/javascript"></script>	
<script src="fg642_boss.js" type="text/javascript"></script>	
<script language=JavaScript>
//----弹出一个新页面选择组织节点--- 增加
function select_groupId()
{
	var path = "<%=request.getContextPath()%>/npage/rpt/common/grouptreeTT.jsp";
    window.open(path,'_blank','height=600,width=300,scrollbars=yes');
}
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD><TITLE>新营业员操作明细报表(铁通)</TITLE>
</HEAD>
<body>

<SCRIPT language="JavaScript">

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
  
  //yuanqs modify 100601 18:44 拆分crm维护和boss维护的报表
  	//select_boss(document.form1);
  	//select_crm_bao(document.form1);
  	select_crm(document.form1);
	select_boss(document.form1);
    document.form1.submit();
  
}

</SCRIPT>
<FORM method=post name="form1" >
	<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">请选择操作报表</div>
	</div>
<table cellSpacing="0">
    <tr>
		<td class="blue">操作报表</td>
		<td>
			<select name=rpt_type onChange="tochange('change_rpt')" style='width:400px'>
       <wtc:qoption name="sPubSelect" outnum="2">
          <wtc:sql>select select_value,select_name from sreportfunc where function_code = '<%=opCode%>' order by select_value asc
					</wtc:sql>
	      </wtc:qoption>
			</select>
		</td>
		<td class="blue">操作代码</td>
		<td>
			<select name=function_code style='width:200px'>
<%
        try
        {
         // sqlStr = "select function_code,function_code||'-->'||function_name from sFuncCode where function_code not like 'a%' and main_code <> '0' and length(rtrim(function_code))=4 order by function_code";
		    sqlStr = " select * from (select function_code,function_code||'-->'||function_name from sFuncCode where function_code not like 'a%' and main_code <> '0' and length(rtrim(function_code))=4 "+
                      		     " union select function_code,function_code||'-->'||function_name from sFuncCodenew where function_code not like 'a%' and main_code <> '0' and length(rtrim(function_code))=4 "+
                      		     " ) where  function_code != 'e506' order by function_code";

%>
	<wtc:pubselect name="sPubSelect"  routerKey="region" routerValue="<%=regionCode%>" outnum="2">
		<wtc:sql><%=sqlStr%></wtc:sql>
	</wtc:pubselect>
	<wtc:array id="result" scope="end" />
<%
          recordNum = result.length;
          out.println("<option class='button' value='ZZZZ'>ZZZZ-->全部操作</option>");
          for(i=0;i<recordNum;i++)
          {
            out.println("<option class='button' value='" + result[i][0] + "'>" + result[i][1] + "</option>");
          }

        }catch(Exception e)
        {
          logger.error("Call sunView is Failed!");
        }
%>
			</select>
		</td>
	</tr>

	<tr>
		<td class="blue">组织节点</td>
		<td>
			<input type="hidden" name="groupId">
			<input type="text" name="groupName" v_must="1" v_type="string" maxlength="60" class="InputGrey" readonly>&nbsp;<font color="orange">*</font>
			<input name="addButton" class="b_text" type="button" value="选择" onClick="select_groupId()" >
		</td>

		<td class="blue">营 业 员</td>
		<td>
			<input type="text" name="login_no" class="button" maxlength="6" size="8" onChange="changeLoginNo()">
			<input type="text" name="login_name" class="button" disabled>
			<input name="loginNoQuery" class="b_text" type="button" onClick="getLoginNo()" value="查询">
		</td>
	</tr>

	<tr>
		<td class="blue">开始时间</td>
		<td>
			<input type="text"    name="begin_time" value=<%=dateStr%> size="17" maxlength="17">
		</td>
		<td class="blue">结束时间</td>
		<td>
			<input type="text"    name="end_time" value=<%=dateStr%> size="17" maxlength="17">
		</td>
	</tr>

	<tr>
		<td colspan="4" align="center" id="footer">
		&nbsp; <input id=submits class="b_foot" name=submits onclick="return(doSubmit())" type=button value=确认>
		&nbsp; <input class="b_foot" name=reee  type=button onClick="form1.reset()" value=清除>
		&nbsp; <input class="b_foot" name=back onClick="history.go(-1)" type=button value=返回>
		&nbsp; <input class="b_foot" name=back onClick="removeCurrentTab()" type=button value=关闭>
		</td>
	</tr>
</table>
	<input type="hidden" name="rpt_code" value="0">
	<input type="hidden" name="rpt_code1" value="1">
	<input type="hidden" name="rpt_right" value="<%=rpt_right.trim()%>">
	<input type="hidden" name="workNo" value="<%=work_no%>">
	<input type="hidden" name="org_code" value="<%=org_code%>">
	<input type="hidden" name="hDbLogin" value ="dbchange">
	<input type="hidden" name="hParams1" value="">
	<input type="hidden" name="op_code" value="1610">
	<input type="hidden" name="login_accept" value="">
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
var change_flag = "";					//定义RPC联动全局变量 查询区县:flag_dis  查询营业厅:flag_town 默认:""
function tochange(par)
{
	if(par == "change_dis")//查询区县
			{
				change_flag = "flag_dis";
				var region_code = document.all.region_code[document.all.region_code.selectedIndex].value.substring(0,2);
				var myPacket = new AJAXPacket("select_rpc.jsp","正在获得区县信息，请稍候......");
				//var sqlStr = "select region_code||district_code,district_code||'-- >'||district_name from sDisCode where region_code = '"+region_code+"' Order By district_code";
				
				
				var sqlStr = "90000071" ;
				var params = region_code+"|";
				var outNum = "2";		
				

			}

		else if(par == "change_town")//查询营业厅
			{
				change_flag = "flag_town";
				var region_code = document.all.region_code[document.all.region_code.selectedIndex].value.substring(0,2);
				var district_code = document.all.district_code[document.all.district_code.selectedIndex].value.substring(2,4);
				var myPacket = new AJAXPacket("select_rpc.jsp","正在获得营业厅信息，请稍候......");
				//var sqlStr = "select region_code||district_code||town_code,town_code||'-- >'||TOWN_NAME from sTownCode where region_code = '"+region_code+"' and district_code = '"+district_code+"' Order By town_code";
				
				var sqlStr = "90000072" ;
				var params = region_code+"|"+district_code+"|";
				var outNum = "2";		
			}
		else if(par == "change_workno")//查询营员
			{
				change_flag = "flag_workno";
				var town_code = document.all.town_code[document.all.town_code.selectedIndex].value.substring(0,7);
				var myPacket = new AJAXPacket("select_rpc.jsp","正在获得工号信息，请稍候......");
				//var sqlStr = "select login_no,login_no||'-- >'||nvl(login_name,login_no) from dLoginMsg where org_code like '"+town_code+"%' Order By login_no";
				var sqlStr = "90000073" ;
				var params = town_code+"|";
				var outNum = "2";		
			}
		else if(par == "change_rpt")//报表
			{
				change_flag = "flag_rpt";
				var sqlStr ="";
				var rpt_type = document.all.rpt_type[document.all.rpt_type.selectedIndex].value.substring(0,2);
				//alert(rpt_type);
				var myPacket = new AJAXPacket("select_rpc.jsp","正在获得操作信息，请稍候......");
				if(rpt_type == "1"){
					//sqlStr = "select a.function_code,a.function_code||'-->'||a.function_name from sFuncCode a,sFuncCodeRpt b where a.function_code = b.function_code and a.function_code !='e506' and b.rpt_type = '"+rpt_type+"' order by a.function_code";				
					sqlStr = "90000074" ;
					var params = rpt_type+"|";
					var outNum = "2";		
				}
				/*else if (rpt_type == "2" || rpt_type == "3"  || rpt_type == "8" || rpt_type == "12" ||rpt_type == "13")*/
				else if(rpt_type == "2"){
					//sqlStr = "select 1 from dual where 1=2";
					sqlStr = "90000008" ;
					var params = "";
					var outNum = "2";
				}
				else if (rpt_type == "3"  || rpt_type == "8" || rpt_type == "12" ||rpt_type == "13"){
					//sqlStr = "select a.function_code,a.function_code||'-->'||a.function_name from sFuncCode a,sFuncCodeRpt b where a.function_code = b.function_code and b.rpt_type = '"+rpt_type+"' order by a.function_code";
					sqlStr = "90000075" ;
					var params = rpt_type+"|";
					var outNum = "2";		
				}
				else if(rpt_type == "4"){
					//sqlStr = "select store_type,store_type||'-->'||store_name from sStoreType";
					sqlStr = "90000076" ;
					var params = "";
					var outNum = "2";		
				}
				else if(rpt_type == "5"){
					//sqlStr = "select distinct function_code,function_code||'-->'||function_name from sFuncList";
					sqlStr = "90000077" ;
					var params = "";
					var outNum = "2";		
				}
				else if(rpt_type == "7"){
					//sqlStr = "select function_code,function_code||'-->'||function_name from sFuncCode where function_code like 'a%' and main_code <> '0' order by function_code";
					sqlStr = "90000078" ;
					var params = "";
					var outNum = "2";		
				}
				else if(rpt_type == "9"){
					//sqlStr = "select distinct a.mach_code,a.mach_code||'-->'||b.machine_name from dPackRes a,sMachCode b where a.region_code=b.region_code and a.mach_code=b.machine_code";
					sqlStr = "90000079" ;
					var params = "";
					var outNum = "2";							
				}
				else if(rpt_type == "10"){
					//sqlStr = "select function_code,function_code||'-->'||function_name from sFuncCode where main_code <> '0'  order by function_code";
					sqlStr = "90000080" ;
					var params = "";
					var outNum = "2";							
				}
				/*
				else if(rpt_type == "28")
					sqlStr = "select 1 from dual where 1=2";
				*/
				else if(rpt_type == "32"){
					//sqlStr = "select option_code,option_code||'-->'||option_name from soptiontype";
					sqlStr = "90000081" ;
					var params = "";
					var outNum = "2";							
				}
				else{
					//sqlStr = "select function_code,function_code||'-->'||function_name from sFuncCode where main_code <> '0'  order by function_code";
					sqlStr = "90000082" ;
					var params = "";
					var outNum = "2";		
				}

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
			  triList[0]="login_no";
			  document.all("login_no").length=0;
			  document.all("login_no").options.length=triListdata.length;//triListdata[i].length;
			  for(j=0;j<triListdata.length;j++)
			  {
				document.all("login_no").options[j].text=triListdata[j][1];
				document.all("login_no").options[j].value=triListdata[j][0];
			  }//工号结果集

		}
	else if(change_flag == "flag_rpt")
		{
			  triList[0]="function_code";
			  document.all("function_code").length=0;
			document.all("function_code").options.length=triListdata.length+1;//triListdata[i].length;
			document.all("function_code").options[0].text="ZZZZ -->全部操作";
			document.all("function_code").options[0].value="ZZZZ";
			//alert(triListdata.length);
			  for(j=0;j<triListdata.length;j++)
			  {
				document.all("function_code").options[j+1].text=triListdata[j][1];
				document.all("function_code").options[j+1].value=triListdata[j][0];
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
    var pageTitle = "营业员查询";
    var fieldName = "营业员工号|营业员名称";
	/****************************************************
	var sqlStr=" select rtrim(login_no),rtrim(login_name)   from dloginmsg" +
				         " where org_code like '" +document.all.district_code.value+document.all.town_code.value+
				         "%' ";
    *****************************************************/
    
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
