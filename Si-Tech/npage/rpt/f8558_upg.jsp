<!DOCTYPE html PUBLIC "-//W3C//Dtd Xhtml 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<%
  /*
   * ����: ��Ӫҵ������ͳ�Ʊ���(��ͨ)8558
   * �汾: 1.0
   * ����: 2010/06/14
   * ����: wangyua
   * ��Ȩ: si-tech
   * update:
  */
%>
<%@	page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %> 
<%	request.setCharacterEncoding("GBK");%>
<%
	String opCode="8558";
	String opName="��Ӫҵ������ͳ�Ʊ���(��ͨ)";
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
<HEAD><TITLE>��Ӫҵ������ͳ�Ʊ���(��ͨ)</TITLE>
</HEAD>
<body>
<!-------------------------------------------------------------------------------->
<%if(rpt_right.compareTo("9")>=0){%>
<script language="jscript">
	rdShowMessageDialog('��û�в����˱�����Ȩ��!');
	window.close();
</script>
<%}%>
<!-------------------------------------------------------------------------------->
<script language=JavaScript>
//----����һ����ҳ��ѡ����֯�ڵ�--- ����
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
    	document.all("rpt_format").options[0].text='��ϸ';
    	document.all("rpt_format").options[0].value='10000';
    	document.all("rpt_format").options[1].text='���ѷ�ʽС��';
    	document.all("rpt_format").options[1].value='01000';
    	document.all("rpt_format").options[2].text='����';
    	document.all("rpt_format").options[2].value='00100';
    	document.all("rpt_format").options[3].text='��ϸ+���ѷ�ʽС��';
    	document.all("rpt_format").options[3].value='11000';
    	document.all("rpt_format").options[4].text='��ϸ+����';
    	document.all("rpt_format").options[4].value='10100';
    	document.all("rpt_format").options[5].text='��ϸ+���ѷ�ʽС��+����';
    	document.all("rpt_format").options[5].value='11100';
 		}
 		else{
    	document.all("rpt_format").options.length=1;
    	document.all("rpt_format").options[0].text='��ϸ';
    	document.all("rpt_format").options[0].value='10000';
  	}
}

function doSubmit()
{
 
  getAfterPrompt();
  if(document.form1.all("begin_time").value.length == 8)
      document.form1.begin_time.value=document.form1.begin_time.value+" 00:00:00";
  if(document.form1.all("end_time").value.length == 8)
      document.form1.end_time.value=document.form1.end_time.value+" 23:59:59";
  if(!check(form1))
  {
    return false;
  }
  if(document.form1.begin_login.value>document.form1.end_login.value)
  {
    alert("��ʼ���űȽ������Ŵ�");
    return false;
  }

  var begin_time=document.form1.begin_time.value;
  var end_time=document.form1.end_time.value;
  if(begin_time>end_time)
  {
    alert("��ʼʱ��Ƚ���ʱ���");
    return false;
  }
  with(document.forms[0])
  {
    if(document.form1.rpt_type.value==1)
    {
      hTableName.value="rbo006";
      hParams1.value= "prc_1625_TD184_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
    }
    else if(document.form1.rpt_type.value==2)
    {
      hTableName.value="rbo006";
    	hParams1.value= "prc_1625_TD185_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
    }
     else if(document.form1.rpt_type.value==3)
    {
      hTableName.value="rbo006";
    	hParams1.value= "prc_1625_TD186_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
    }
     else if(document.form1.rpt_type.value==4)
    {
      hTableName.value="rbo006";
    	hParams1.value= "PRC_1625_TD187_UPG('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
    }
    else if(document.form1.rpt_type.value==5)
    {
     	hTableName.value="rpt003";
			hParams1.value= "DBCUSTADM.prc_8558_pt003_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"','"+document.form1.rpt_format.value+"'";
			document.form1.action = "print_rpt_boss.jsp";
    }

        else if(document.form1.rpt_type.value==6)
    {
     	hTableName.value="rbt003";
			hParams1.value= "PRC_8558_OP003_UPG('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"','"+document.form1.rpt_format.value+"'";
			document.form1.action="print_rpt_crm_report.jsp"; 
    }
        else if(document.form1.rpt_type.value==7)
    {
     	hTableName.value="rcd002";
			hParams1.value= "PRC_8558_KH002_UPG('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
			document.form1.action="print_rpt_crm_report.jsp"; 
    }
            else if(document.form1.rpt_type.value==8)
    {
     	hTableName.value="rbo006";
			hParams1.value= "prc_8558_301TD_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";

    }
    
            else if(document.form1.rpt_type.value==9)
    {
     	hTableName.value="rct003";
			hParams1.value= "prc_8558_pr0016_1_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
			document.form1.action="print_rpt_crm_report.jsp"; 
    }
    
            else if(document.form1.rpt_type.value==10)
    {
     	hTableName.value="rct003";
			hParams1.value= "prc_8558_pr0017_1_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
			document.form1.action="print_rpt_crm_report.jsp"; 
    }
    
           else if(document.form1.rpt_type.value==11)
    {
     	hTableName.value="rct003";
			hParams1.value= "prc_8558_2_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
			document.form1.action="print_rpt_crm_report.jsp"; 
    }
           else if(document.form1.rpt_type.value==12)
    {
     	hTableName.value="RPT2266";
			hParams1.value= "prc_8558_rpt25_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
			document.form1.action="print_rpt_crm_report.jsp"; 
    }
           else if(document.form1.rpt_type.value==13)
    {
     	hTableName.value="dbo005";
			hParams1.value= "prc_8558_newsale_mx_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
    }
           else if(document.form1.rpt_type.value==14)
    {
     	hTableName.value="dbo005";
			hParams1.value= "prc_8558_newsale_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
    }
           else if(document.form1.rpt_type.value==15)
    {
     	hTableName.value="rbo006";
			hParams1.value= "prc_8558_210_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
    }
           else if(document.form1.rpt_type.value==16)
    {
     	hTableName.value="rbo006";
			hParams1.value= "prc_8558_318_upg('"+document.form1.workNo.value+"','"+document.form1.groupId.value+"','"+document.form1.begin_login.value+"','"+document.form1.end_login.value+"','"+document.form1.begin_time.value+"','"+document.form1.end_time.value+"'";
    }
    
	submit();
  }
}

</SCRIPT>

<FORM method=post name="form1" action="/npage/rpt/print_rpt.jsp">
	<%@ include file="/npage/include/header.jsp" %>
<table cellSpacing="0">
	<tr>
		<td class="blue">��������</td>
		<td>
			<select name=rpt_type onChange="changerpt()" style='width:400px'>
				<option class='button' value=1>1->Ӫҵ��Ԥ�滰����TD�̻�(��ͨ)ͳ�Ʊ���</option>
				<option class='button' value=2>2->Ӫҵ��Ԥ�滰����TD����̻�ͳ�Ʊ���(��ͨ)</option>
				<option class='button' value=3>3->Ӫҵ����TD����̻�����ͨ�ŷ�(��ͨ)ͳ�Ʊ���(���¹���)</option>
				<option class='button' value=4>4->Ӫҵ��Ԥ�滰����TD�̻�(��ͨ)ͳ�Ʊ���(���¹���)</option>
				<option class='button' value=5>5->Ӫҵ�����Ѳ���(��ͨ)ͳ�Ʊ���</option>
				<option class='button' value=6>6->Ӫҵ��ҵ�����ͳ�Ʊ�����ͨ��</option>
				<option class='button' value=7>7->Ӫҵ������ҵ��ͳ�Ʊ�������ͨ��</option>
				<option class='button' value=8>8->Ӫҵ����TD����̻���ͨ�ŷ�ͳ�Ʊ���(��ͨ)</option>
				<option class='button' value=9>9->Ӫҵ��������ϸ����(��ͨ)</option>
				<option class='button' value=10>10->Ӫҵ��ҵ�����ͳ�Ʊ���(��ͨ)</option>
				<option class='button' value=11>11->Ӫҵ�����û���ͳ�Ʊ���(��ͨ)</option>
				<option class='button' value=12>12->Ӫҵ������Ʒͳһ����ͳ�Ʊ���(��ͨ)</option>
				<option class='button' value=13>13->Ӫҵ���°����Ʒͳһ������ϸ����(��ͨ)</option>
				<option class='button' value=14>14->Ӫҵ���°����Ʒͳһ����ͳ�Ʊ���(��ͨ)</option>
				<option class='button' value=15>15->Ӫҵ�����ӷ�Ʊͳ�Ʊ���(��ͨ)</option>
				<option class='button' value=16>16->Ӫҵ�����ӻ�����ͳ�Ʊ���(��ͨ)</option>
			</select>
		</td>
		<td class="blue">������ʽ</td>
		<td>
			<select name=rpt_format>
				<option class='button' value=10000>��ϸ</option>
			</select>
		</td>
	</tr>
	
	<tr>
		<td class="blue">��֯�ڵ�</td>
		<td colspan="3">
			<input type="hidden" name="groupId">
			<input type="text" name="groupName" v_must="1" v_type="string" maxlength="60" class="InputGrey" readonly>&nbsp;<font color="orange">*</font>
			<input name="addButton" class="b_text" type="button" value="ѡ��" onClick="select_groupId()" >	
		</td>
	</tr>
                
	<tr>
		<td class="blue">��ʼ����</td>
		<td>
			<input type="text" name="begin_login" class="button" maxlength="6" size="8" onChange="changeBeginLogin()">
			<input type="text" name="begin_name" class="button" disabled>
			<input name="loginNoQuery" class="b_text" type="button" onClick="getBeginLogin()" value="��ѯ">
		</td>
		<td class="blue">��������</td>
		<td>
			<input type="text" name="end_login" class="button" maxlength="6" size="8" onChange="changeEndLogin()">
			<input type="text" name="end_name" class="button" disabled>
			<input name="loginNoQuery" class="b_text" type="button" onClick="getEndLogin()" value="��ѯ">
		</td>
    </tr>
	<tr>
		<td class="blue">��ʼʱ��</td>
		<td>
			<input type="text"   name="begin_time" value=<%=dateStr%> size="17" maxlength="17">
		</td>
		<td class="blue">����ʱ��</td>
		<td>
			<input type="text"   name="end_time" value=<%=dateStr%> size="17" maxlength="17">
		</td>
	</tr>
	
	<tr> 
		<td align="center" id="footer" colspan="4">
			&nbsp; <input id=submits class="b_foot" name=submits onclick="return(doSubmit())" type=button value=ȷ��>
			&nbsp; <input class="b_foot" name=reee  type=button onClick="form1.reset()" value=���>
			&nbsp; <input class="b_foot" name=back onClick="history.go(-1)" type=button value=����>
			&nbsp; <input class="b_foot" name=back onClick="removeCurrentTab()" type=button value=�ر�>
		</td>
	</tr>
      <input type="hidden" name="workNo" value="<%=work_no%>">
       <input type="hidden" name="org_code" value="<%=org_code%>">
      <input type="hidden" name="rptRight" value="T">
      <input type="hidden" name="hDbLogin" value ="dbchange">
      <input type="hidden" name="hParams1" value="">
      <input type="hidden" name="hTableName" value="">
</table>
	<%@ include file="/npage/include/footer.jsp" %>
</FORM>
</BODY>
</HTML>

<script language="javascript">
/*----------------------------����RPC������������------------------------------------------*/

 onload=function(){
	form1.reset();
	}
var change_flag = "";//����RPC����ȫ�ֱ��� ��ѯ����:flag_dis  ��ѯӪҵ��:flag_town Ĭ��:""
function tochange(par)
{       if(par == "change_dis")//��ѯ����
			{   
				change_flag = "flag_dis";
				var region_code = document.all.region_code[document.all.region_code.selectedIndex].value.substring(0,2);
				var myPacket = new AJAXPacket("select_rpc.jsp","���ڻ��������Ϣ�����Ժ�......");
				//var sqlStr = "select region_code||district_code,district_code||'-- >'||district_name from sDisCode where region_code = '"+region_code+"' Order By district_code";
				
				var sqlStr = "90000062" ;
				var params = region_code+"|";
				var outNum = "2";				
			}
		
		if(par == "change_town")//��ѯӪҵ��
			{
				change_flag = "flag_town";
				var region_code = document.all.region_code[document.all.region_code.selectedIndex].value.substring(0,2);
				var district_code = document.all.district_code[document.all.district_code.selectedIndex].value.substring(2,4);
				var myPacket = new AJAXPacket("select_rpc.jsp","���ڻ��Ӫҵ����Ϣ�����Ժ�......");
				//var sqlStr = "select region_code||district_code||town_code,town_code||'-- >'||TOWN_NAME from sTownCode where region_code = '"+region_code+"' and district_code = '"+district_code+"' Order By town_code";
				var sqlStr = "90000063" ;
				var params = region_code+"|"+district_code+"|";
				var outNum = "2";		
			}
		if(par == "change_workno")//��ѯӪԱ
			{
				change_flag = "flag_workno";
				var town_code = document.all.town_code[document.all.town_code.selectedIndex].value.substring(0,7);
				var myPacket = new AJAXPacket("select_rpc.jsp","���ڻ�ù�����Ϣ�����Ժ�......");
				//var sqlStr = "select login_no,login_no||'-- >'||nvl(login_name,login_no) from dLoginMsg where org_code like '"+town_code+"%' Order By login_no";
				var sqlStr = "90000064" ;
				var params = town_code+district_code+"|";
				var outNum = "2";						
			}
			//alert(change_flag);
		myPacket.data.add("sqlStr",sqlStr);
		core.ajax.sendPacket(myPacket);
		delete(myPacket);
}

/*-----------------------------RPC��������------------------------------------------------*/
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
			  }//���ؽ����
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
			  }//Ӫҵ�������
			  document.all("town_code").options[0].selected=true;
			  tochange("change_workno");
		}
	else if(change_flag == "flag_workno")
		{
			  triList[0]="begin_login";
			  document.all("begin_login").length=0;
			  document.all("begin_login").options.length=triListdata.length+1;//triListdata[i].length;
				document.all("begin_login").options[0].text='δѡ��';
				document.all("begin_login").options[0].value=document.all.town_code[document.all.town_code.selectedIndex].value.substring(0,7);
			  for(j=0;j<triListdata.length;j++)
			  {
				document.all("begin_login").options[j+1].text=triListdata[j][1];
				document.all("begin_login").options[j+1].value=triListdata[j][0];
			  }//��ʼ���Ž����

			  document.all("end_login").length=0;
			  document.all("end_login").options.length=triListdata.length+1;//triListdata[i].length;
				document.all("end_login").options[0].text='δѡ��';
				document.all("end_login").options[0].value=document.all.town_code[document.all.town_code.selectedIndex].value.substring(0,7);
			  for(j=triListdata.length-1;j>=0;j--)
			  {
			  	k=triListdata.length-1-j
				document.all("end_login").options[k+1].text=triListdata[j][1];
				document.all("end_login").options[k+1].value=triListdata[j][0];
			  }//�������Ž����
			  
		}
//////////////////////////////////////////////////////////////////////////////////////////
		
	  
   }
function getBeginLogin(){
    if(document.all.groupName.value==''){
	    rdShowMessageDialog("���Ȳ�ѯ��֯�ڵ�!");
		form1.town_code.focus();
	    return;
	}
    var pageTitle = "ӪҵԱ��ѯ";
    var fieldName = "ӪҵԱ����|ӪҵԱ����|";
	/****************************************************
	var sqlStr=" select rtrim(login_no),rtrim(login_name)   from dloginmsg" +
				         " where org_code like '" +document.all.district_code.value+document.all.town_code.value+
				         "%' ";
    *****************************************************/
    //var sqlStr=" select rtrim(login_no),rtrim(login_name)   from dloginmsg  where group_id= '"+document.all.groupId.value+"'";
    
    var sqlStr = "90000065"
		var params = document.all.groupId.value+"|";
		
    if(document.form1.begin_login.value != "")
    {
        //sqlStr = sqlStr + " and login_no like '" + document.form1.begin_login.value + "%'";
        var sqlStr = "90000066"
				var params = document.all.groupId.value+"|"+document.form1.begin_login.value+"|";
    }
    //sqlStr = sqlStr + " order by login_no" ;
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "2|0|1|";
    var retToField = "begin_login|begin_name|";
    //PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
    
    	var path = "<%=request.getContextPath()%>/npage/public/fPubSimpSel.jsp";
			path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
			path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
			path = path + "&selType=" + selType+ "&params=" + params;
			var retInfo = window.showModalDialog(path,"","dialogWidth:70;dialogHeight:35;");
			if(typeof(retInfo)!="undefined"){
				var tempArr = retInfo.split("|");
				document.form1.begin_login.value = tempArr[0];
				document.form1.begin_name.value = tempArr[1];
			}
			
}
function changeBeginLogin(){
   document.all.begin_name.value="";
}
function getEndLogin(){
    if(document.all.groupName.value==''){
	    rdShowMessageDialog("���Ȳ�ѯ��֯�ڵ�!");
		form1.town_code.focus();
	    return;
	}
    var pageTitle = "ӪҵԱ��ѯ";
    var fieldName = "ӪҵԱ����|ӪҵԱ����|";
	/****************************************************
	var sqlStr=" select rtrim(login_no),rtrim(login_name)   from dloginmsg" +
				         " where org_code like '" +document.all.district_code.value+document.all.town_code.value+
				         "%' ";
    *****************************************************/
   
    var sqlStr = "90000065"
		var params = document.all.groupId.value+"|";
		
    if(document.form1.begin_login.value != "")
    {
        //sqlStr = sqlStr + " and login_no like '" + document.form1.begin_login.value + "%'";
        var sqlStr = "90000066"
				var params = document.all.groupId.value+"|"+document.form1.end_login.value+"|";
    }
    //sqlStr = sqlStr + " order by login_no" ;
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "2|0|1|";
    var retToField = "end_login|end_name|";
    //PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
    
    	var path = "<%=request.getContextPath()%>/npage/public/fPubSimpSel.jsp";
			path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
			path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
			path = path + "&selType=" + selType+ "&params=" + params;
			var retInfo = window.showModalDialog(path,"","dialogWidth:70;dialogHeight:35;");
			if(typeof(retInfo)!="undefined"){
				var tempArr = retInfo.split("|");
				document.form1.end_login.value = tempArr[0];
				document.form1.end_name.value = tempArr[1];
			}
}
function changeEndLogin(){
   document.all.end_name.value="";
}
</script>