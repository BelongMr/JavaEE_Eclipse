<!DOCTYPE html PUBLIC "-//W3C//Dtd Xhtml 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<%
  /*
   * ����: �µ�������ͳ�Ʊ���2149
   * �汾: 1.0
   * ����: 2009/03/17
   * ����: leimd
   * ��Ȩ: si-tech
   * update:
  */
%>
<%@	page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%	request.setCharacterEncoding("GBK");%> 
<%
	String opCode ="2149";
	String opName = "�µ�������ͳ�Ʊ���";
	String workNo = (String)session.getAttribute("workNo");
	String rpt_right = (String)session.getAttribute("rptRight");//�õ�����Ȩ�� rpt_right
	
    String sqlStr="";
	int i=0;
	String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());

%>

<html xmlns="http://www.w3.org/1999/xhtml">
	<HEAD><TITLE>�µ�������ͳ�Ʊ�</TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"></HEAD>
<!-------------------------------------------------------------------------------->
<%if(rpt_right.compareTo("4")>=0){%>
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
	var path = "<%=request.getContextPath()%>/npage/rpt/common/grouptree.jsp?execJsp=rpt_f1640upg";
    window.open(path,'_blank','height=600,width=300,scrollbars=yes');
}
</script>
<script src="f1640_boss.js" type="text/javascript"></script>	
<script src="f1640_crm.js?v=2" type="text/javascript"></script>	
<script src="f1640_crm_report.js?v=1" type="text/javascript"></script>	
<SCRIPT language="JavaScript">
function doSubmit()
{
	
	var sdate = document.form1.begin_time.value;
	var edate = document.form1.end_time.value;
	getAfterPrompt();
	if(document.form1.groupName.value==""){
		rdShowMessageDialog("'��֯�ڵ�'Ϊ������,�������д!");
		return false;	
	}
	/* begin add for �����Ż�������ӡҳ����������@2014/12/3 */
	if(document.all.bGroupId.value == "0"){
  	rdShowMessageDialog("'��ʼ��֯�ڵ�'Ϊ������,�������д!");
    return false;
  }
  if(document.all.eGroupId.value == "0"){
  	rdShowMessageDialog("'������֯�ڵ�'Ϊ������,�������д!");
    return false;
  }
  /* end add for �����Ż�������ӡҳ����������@2014/12/3 */
	if(!check(form1))
	{
		rdShowMessageDialog("���Form����",0);
		return false;
	}
	if(document.form1.bGroupId.value>document.form1.eGroupId.value)
	{
		rdShowMessageDialog("��ʼ��֯�ڵ�Ƚ�����֯�ڴ�!");
		return false;
	}
  
	//xl add 32
	if(document.form1.rpt_type.value==85||document.form1.rpt_type.value==22||document.form1.rpt_type.value==146||document.form1.rpt_type.value==158 ||document.form1.rpt_type.value==314 || document.form1.rpt_type.value==321|| document.form1.rpt_type.value==32|| document.form1.rpt_type.value==334){
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
  
	// add by wanglm 2010-8-30
	select_boss(document.form1);
	select_crm_bao(document.form1);
	select_crm(document.form1);
	//alert(document.form1.rpt_type.value);
	alert("document.form1.action=["+document.form1.action+"]");
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

function callDisCode(){
	var i = 0;
	var regionCode = 0;
	for(i = 0 ; i < document.form1.region_code.length ; i ++){
		if(document.form1.region_code.options[i].selected){
			regionCode = document.form1.region_code.options[i].value;
			
		}
	}	
    var myPacket = new AJAXPacket("callDisCode.jsp","���ڲ�ѯ�����Ժ�......");
		  myPacket.data.add("region_code",regionCode);
    	core.ajax.sendPacket(myPacket);
    	myPacket = null;
    	
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
			 onpropertychange="blurSearchFunc('rpt_type','searchTextrpt','->','tochange')" />
		</td>
	</tr>
	<tr>
		<td class="blue">��������</td>
        	<td colspan="3"  >
		      <select name=rpt_type onChange="tochange('change_rpt')" style='width:400px' >
		       <wtc:qoption name="sPubSelect" outnum="2">
		          <wtc:sql>
		          	select select_value,select_name 
		          	from sreportfunc 
		          	where function_code = '<%=opCode%>' 
		          	order by select_value
							</wtc:sql>
			      </wtc:qoption>
					</select>
            </TD>
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
        	
		<tr id="group_head">
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
			<td class="blue">�����Ŷ�</td>
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
	  <input type="hidden" name="workNo" value="<%=workNo%>">    
      <input type="hidden" name="hDbLogin" value ="dbchange">
      <input type="hidden" name="rptRight" value="R">
      <input type="hidden" name="hParams1" value="">
      <input type="hidden" name="hTableName" value="">
	<%@ include file="/npage/public/pubSearchText.jsp" %>
	<%@ include file="/npage/include/footer.jsp" %> 
</FORM>
</BODY>
</HTML>

<script language="javascript">
/*----------------------------����RPC������������------------------------------------------*/

 onload=function()
 {
	form1.reset();
	core.ajax.onreceive = doProcess;
 }
function tochange()
{
		var group_id = document.all.groupId.value;
		var myPacket = new AJAXPacket("select_rpc.jsp","���ڻ����֯������Ϣ�����Ժ�......");
		var sqlStr = "90000012";
		var outNum = "2";
		var params = group_id + "|";
		myPacket.data.add("sqlStr",sqlStr);
		myPacket.data.add("outNum",outNum);
		myPacket.data.add("params",params);
		core.ajax.sendPacket(myPacket);
		myPacket = null;
}

/*-----------------------------RPC��������------------------------------------------------*/
  function doProcess(packet)
  {
	  var rpc_page=packet.data.findValueByName("rpc_page");
 
	 
	    var triListData = packet.data.findValueByName("tri_list"); 
    
  	    var triList=new Array(triListData.length);
  	    triList[0]="bGroupId";
		document.all("bGroupId").length=0;
		document.all("bGroupId").options.length=triListData.length+1;//triListData[i].length;
		document.all("bGroupId").options[0].text='δѡ��';
		document.all("bGroupId").options[0].value='0';
		for(j=0;j<triListData.length;j++)
		{
			document.all("bGroupId").options[j+1].text=triListData[j][1];
			document.all("bGroupId").options[j+1].value=triListData[j][0];
		}//��ʼ��֯�ڵ����� 
		document.all("eGroupId").length=0;
		document.all("eGroupId").options.length=triListData.length+1;//triListData[i].length;
		document.all("eGroupId").options[0].text='δѡ��';
		document.all("eGroupId").options[0].value='0';
		for(j=triListData.length-1;j>=0;j--)
		{
			k=triListData.length-1-j;
			document.all("eGroupId").options[k+1].text=triListData[j][1];
			document.all("eGroupId").options[k+1].value=triListData[j][0];
		}//������֯�ڵ�����
  	    
	
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