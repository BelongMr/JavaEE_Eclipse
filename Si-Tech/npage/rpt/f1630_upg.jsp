<!DOCTYPE html PUBLIC "-//W3C//Dtd Xhtml 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<%
  /*
   * ����: �����ز���ͳ�Ʊ���2148
   * �汾: 1.0
   * ����: 200/01/04
   * ����: leimd
   * ��Ȩ: si-tech
   * update:
  */
%>
<%@	page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%	request.setCharacterEncoding("GBK");%>
<%@ page import="org.apache.log4j.Logger"%>
<%
	String opCode="2148";
	String opName="�����ز���ͳ�Ʊ���";
	Logger logger = Logger.getLogger("f1630_upg.jsp");
	String work_no = (String)session.getAttribute("workNo");
	String rpt_right = (String)session.getAttribute("rptRight");
	String org_code = (String)session.getAttribute("orgCode");
    String sqlStr="";
	String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());

%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<HEAD><TITLE>�����ز���ͳ�Ʊ�</TITLE>
</HEAD>
<body>
<!-------------------------------------------------------------------------------->
<%if(rpt_right.compareTo("7")>=0){%>
<script language="jscript">
	rdShowMessageDialog('��û�в����˱�����Ȩ��!');
	window.close();
</script>
<%}%>
<!-------------------------------------------------------------------------------->
<script language="JavaScript">
//----����һ����ҳ��ѡ����֯�ڵ�--- ����
function select_groupId()
{
	var path = "<%=request.getContextPath()%>/npage/rpt/common/grouptree.jsp";
    window.open(path,'_blank','height=600,width=300,scrollbars=yes');
}
</script>

<script src="f1630_crm.js" type="text/javascript"></script>	
<script src="f1630_crm_report.js" type="text/javascript"></script>	
<script src="f1630_boss.js" type="text/javascript"></script>	

<SCRIPT language="JavaScript">
function doSubmit()
{
	var sdate = document.form1.begin_time.value;
	var edate = document.form1.end_time.value;
	getAfterPrompt()
  if(!check(form1))
  {
    return false;
  }
  
  /* begin add for �����Ż�������ӡҳ����������@2014/12/3 */
  if(document.all.groupId.value == ""){
  	rdShowMessageDialog("'��֯�ڵ�'Ϊ������,�������д!");
    return false;
  }
  if(document.all.bGroupId.value == "0"){
  	rdShowMessageDialog("'��ʼ��֯�ڵ�'Ϊ������,�������д!");
    return false;
  }
  if(document.all.eGroupId.value == "0"){
  	rdShowMessageDialog("'������֯�ڵ�'Ϊ������,�������д!");
    return false;
  }
  /* end add for �����Ż�������ӡҳ����������@2014/12/3 */
  
  if(document.form1.bGroupId.value>document.form1.eGroupId.value)
  {
    rdShowMessageDialog("��ʼ��֯�ڵ�Ƚ�����֯�ڴ�");
    return false;
  }
  /********************
  if(document.form1.begin_town.value>document.form1.end_town.value)
  {
    alert("��ʼӪҵ���Ƚ���Ӫҵ����");
    return false;
  }
  ********************/
  // xl add for 33 �¸ĵ�
  if(document.form1.rpt_type.value==79||document.form1.rpt_type.value==82||document.form1.rpt_type.value==149|| document.form1.rpt_type.value==160 || document.form1.rpt_type.value==311 || document.form1.rpt_type.value==104 || document.form1.rpt_type.value==315|| document.form1.rpt_type.value==33){
	  if(document.form1.all("begin_time").value.length == 8)
      document.form1.begin_time.value=document.form1.begin_time.value+" 00:00:00";
	 if(document.form1.all("end_time").value.length == 8)
      document.form1.end_time.value=document.form1.end_time.value+" 23:59:59";
  }
  var begin_time=document.form1.begin_time.value;
  var end_time=document.form1.end_time.value;
  if(begin_time>end_time)
  {
    rdShowMessageDialog("��ʼʱ��Ƚ���ʱ���");
    return false;
  }
  
  sdate = sdate.substring(0,4) + "-" + sdate.substring(4,6) + "-" + sdate.substring(6,8);
  edate = edate.substring(0,4) + "-" + edate.substring(4,6) + "-" + edate.substring(6,8);
  if(DateDiff(sdate,edate) > 30){
  	rdShowMessageDialog("Ϊ�����ӡʱ���ȹ��������������޷�������ӡ�������뽫��ӡʱ�䷶Χ������һ�������ڣ�");
    return false;
  }
    select_crm(document.form1);
    select_boss(document.form1);
  	select_crm_bao(document.form1);
    document.form1.submit();
  
}

function  DateDiff(sDate1,  sDate2){    //sDate1��sDate2��2002-12-18��ʽ  
       var  aDate,  oDate1,  oDate2,  iDays;  
       aDate  =  sDate1.split("-");  
       oDate1  =  new  Date(aDate[1]  +  '-'  +  aDate[2]  +  '-'  +  aDate[0]) ;   //ת��Ϊ12-18-2002��ʽ  
       aDate  =  sDate2.split("-");  
       oDate2  =  new  Date(aDate[1]  +  '-'  +  aDate[2]  +  '-'  +  aDate[0]);  
       iDays  =  parseInt(Math.abs(oDate1  -  oDate2)  /  1000  /  60  /  60  /24);    //�����ĺ�����ת��Ϊ����  
       return  iDays;  
}

</SCRIPT> 

<FORM method=post name="form1" >
	<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">��ѡ���������</div>
	</div>

<table cellSpacing="0">
			<!-- ningtn @ 2010-10-26 �Ż���Ŀ -->
   <tr>
		<td class="blue" >
			ģ������
		</td>
		<td colspan="3">
			<input type="text" id="searchTextrpt" name="searchTextrpt" 
			 value="�������ѯ����" 
			 size="40"
			 style="padding-top:3px;"
			 onFocus="form1.searchTextrpt.value='';clearResults();"  
			 onpropertychange="blurSearchFunc('rpt_type','searchTextrpt','->')" />
		</td>
	</tr>
	<tr>
		<td class="blue">��������</td>
		<td colspan="3">
			<select name=rpt_type onChange="onChangeRptType()" style='width:400px'>
				<wtc:qoption name="sPubSelect" outnum="2">
          <wtc:sql>
          	select select_value,select_name 
          	from sreportfunc where function_code = '<%=opCode%>' 
          	order by select_value
					</wtc:sql>
	      </wtc:qoption>
			</select>
		</td>
	</tr>
	
    <tr>
		<td class="blue">��֯�ڵ�</td>
		<td colspan="3">
			<input type="hidden" name="groupId" >
			<input type="text" name="groupName" v_must="1" v_type="string" maxlength="60" readonly onpropertychange="tochange('change_group')">&nbsp;<font color="orange">*</font>
			<input name="addButton" class="b_text" type="button" value="ѡ��" onClick="select_groupId()" >	
			<input name="refbutton" class="b_text" type="button" value="ˢ��" onClick= "tochange('change_group')" >	
		</td>
	</tr>
	<tr>
		<td class="blue">��ʼ��֯�ڵ�</td>
		<td>	
			<select name="bGroupId" style="width:420px;">
				<option class='button' value='0'> δѡ�� </option>
			</select>
		</td>
		<td class="blue">������֯�ڵ�</td>
		<td>
			<select name="eGroupId" style="width:420px;">
				<option class='button' value='0'> δѡ�� </option>
			</select>
		</td>
	</tr>
	<tr>
		<td class="blue">��ʼʱ��</td>
		<td>
			<input type="text" v_type="date"  name="begin_time" value=<%=dateStr%> size="17" maxlength="17">
		</td>
		<td class="blue">����ʱ��</td>
		<td>
			<input type="text" v_type="date"  name="end_time" value=<%=dateStr%> size="17" maxlength="17">
		</td>
	</tr>
	<tr id="phone_head" style="display:none">
		<td class="blue">��ʼ�Ŷ�</td>
		<td>
			<input type="text" class="button" name="begin_phonehead"  size="17" maxlength="7" >
		</td>
		<td class="blue">��ʼ�Ŷ�</td>
		<td>
			<input type="text" class="button" name="end_phonehead"  size="17" maxlength="7"  >
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
</table>
      <input type="hidden" name="workNo" value="<%=work_no%>">
      <input type="hidden" name="org_code" value="<%=org_code%>">
      <input type="hidden" name="hDbLogin" value ="dbchange">
      <input type="hidden" name="rptright" value="D">
      <input type="hidden" name="hParams1" value="">
      <input type="hidden" name="hTableName" value="">
  
  <%@ include file="/npage/public/pubSearchText.jsp" %>
	<%@ include file="/npage/include/footer.jsp" %> 
</FORM>
</BODY></HTML>
<script language="javascript">
/*----------------------------����RPC������������------------------------------------------*/

 onload=function(){
	form1.reset();
		
	}
var change_flag = "";//����RPC����ȫ�ֱ��� ��ѯ����:flag_dis  ��ѯӪҵ��:flag_town Ĭ��:""
function tochange(par)
{       
	    if(par == "change_dis")//��ѯ����
			{   

				change_flag = "flag_dis";
				var region_code = document.all.region_code[document.all.region_code.selectedIndex].value.substring(0,2);
				var myPacket = new AJAXPacket("select_rpc.jsp","���ڻ��������Ϣ�����Ժ�......");
				var sqlStr = "select region_code||district_code,district_code||'-- >'||district_name from sDisCode where region_code = '"+region_code+"' Order By district_code,district_name";
				myPacket.data.add("sqlStr",sqlStr);
				core.ajax.sendPacket(myPacket);
				myPacket=null
			}
		else if(par == "change_town")//��ѯӪҵ��
			{
				change_flag = "flag_town";
				var region_code = document.all.region_code[document.all.region_code.selectedIndex].value.substring(0,2);
				var district_code = document.all.district_code[document.all.district_code.selectedIndex].value.substring(2,4);
				var myPacket = new AJAXPacket("select_rpc.jsp","���ڻ��Ӫҵ����Ϣ�����Ժ�......");
				var sqlStr = "select region_code||district_code||town_code,town_code||'-- >'||TOWN_NAME from sTownCode where region_code = '"+region_code+"' and district_code = '"+district_code+"' Order By town_code";
				myPacket.data.add("sqlStr",sqlStr);
				core.ajax.sendPacket(myPacket); 
				myPacket=null
			}
		else if(par == "change_group")//��ѯ��֯�����ڵ�
			{
				change_flag = "flag_group";

				var group_id = document.all.groupId.value;
				var myPacket = new AJAXPacket("select_rpc.jsp","���ڻ����֯������Ϣ�����Ժ�......");
				var sqlStr = "90000011";
				// ningtn sqlע�����
				var outNum = "2";
				var params = group_id + "|";
				myPacket.data.add("sqlStr",sqlStr);
				myPacket.data.add("outNum",outNum);
				myPacket.data.add("params",params);
				core.ajax.sendPacket(myPacket);
				myPacket=null
			}

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
			  triList[0]="begin_town";
			  document.all("begin_town").length=0;
			  document.all("begin_town").options.length=triListdata.length+1;//triListdata[i].length;
				document.all("begin_town").options[0].text='δѡ��';
				document.all("begin_town").options[0].value=document.all.district_code[document.all.district_code.selectedIndex].value.substring(0,4);
			  for(j=0;j<triListdata.length;j++)
			  {
				document.all("begin_town").options[j+1].text=triListdata[j][1];
				document.all("begin_town").options[j+1].value=triListdata[j][0];
			  }//��ʼӪҵ�������
			  document.all("end_town").length=0;
			  document.all("end_town").options.length=triListdata.length+1;//triListdata[i].length;
				document.all("end_town").options[0].text='δѡ��';
				document.all("end_town").options[0].value=document.all.district_code[document.all.district_code.selectedIndex].value.substring(0,4);
			  for(j=triListdata.length-1;j>=0;j--)
			  {
			  	k=triListdata.length-1-j;
				document.all("end_town").options[k+1].text=triListdata[j][1];
				document.all("end_town").options[k+1].value=triListdata[j][0];
			  }//����Ӫҵ�������
		}
	else if(change_flag == "flag_group")
		{
			  triList[0]="bGroupId";
			  document.all("bGroupId").length=0;
			  document.all("bGroupId").options.length=triListdata.length+1;//triListdata[i].length;
				document.all("bGroupId").options[0].text='δѡ��';
				document.all("bGroupId").options[0].value='0';
			  for(j=0;j<triListdata.length;j++)
			  {
				document.all("bGroupId").options[j+1].text=triListdata[j][1];
				document.all("bGroupId").options[j+1].value=triListdata[j][0];
			  }//��ʼ��֯�ڵ�����
			  document.all("eGroupId").length=0;
			  document.all("eGroupId").options.length=triListdata.length+1;//triListdata[i].length;
				document.all("eGroupId").options[0].text='δѡ��';
				document.all("eGroupId").options[0].value='0';
			  for(j=triListdata.length-1;j>=0;j--)
			  {
			  	k=triListdata.length-1-j;
				document.all("eGroupId").options[k+1].text=triListdata[j][1];
				document.all("eGroupId").options[k+1].value=triListdata[j][0];
			  }//������֯�ڵ�����
		}
//////////////////////////////////////////////////////////////////////////////////////////
		
	  
   }

 function onChangeRptType()
{
	
	if(document.form1.rpt_type.value==71||document.form1.rpt_type.value==73)
	{
		document.all.phone_head.style.display="block";
	}
	else
	{
		document.all.phone_head.style.display="none";
	}
}	
</script>