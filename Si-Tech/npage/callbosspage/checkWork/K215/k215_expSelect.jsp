<%

 	/*
   * ����: �ƻ�ִ�������ѯ����
�� * �汾: 1.0
�� * ����: 2009/01/09
�� * ����: zengzq 
�� * ��Ȩ: sitech
   * 
   *  
 ��*/
 %>
<%@ page contentType="text/html;charset=gb2312"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="/npage/callbosspage/public/hashlisttoarray.jsp" %>
<%@ page import="com.sitech.crmpd.kf.ejb.client.KFEjbClient"%>
<%@ page import="javax.servlet.http.HttpServletRequest,com.sitech.crmpd.core.wtc.util.*,com.sitech.boss.util.excel.*"%>
<%
    String expFlag = request.getParameter("exp");
    String pageFlag = request.getParameter("flag");
	   //�ж��ǵ���ȫ�����ǵ��뵱ǰҳ
    //String sqlFilter = request.getParameter("sqlFilter");
    String sql=request.getParameter("sql");
    String loginNo = (String)session.getAttribute("workNo"); 
    String seq=request.getParameter("seq");// �����û�ѡ��״̬����
    String strseq=""; 
    String headName=request.getParameter("headName");
    
    //20091120 �󶨱�������
    int start=0;
    int end=0;  
    String[][] queryList = new String[][] {};
    String start_date    =  request.getParameter("start_date");      
    String end_date      =  request.getParameter("end_date");  
    String beQcObjId     = request.getParameter("beQcObjId");      

    String evterno   = request.getParameter("evterno");                                                         
    String staffno = request.getParameter("staffno");                                                       
    String plan_id   = request.getParameter("plan_id"); 

    String qcobjectid         = request.getParameter("qcobjectid");
    String qcGroupId        = request.getParameter("qcGroupId");
    String beQcGroupId      = request.getParameter("beQcGroupId");
    
    String qcobjectName     = request.getParameter("qcobjectName");
    String qcGroupName   = request.getParameter("qcGroupName");                                                         
    String beQcGroupName = request.getParameter("beQcGroupName");                                                       
    String beQcObjName   = request.getParameter("beQcObjName"); 
    String current_times     = request.getParameter("current_times");
	//:~
    String[][] dataRows = new String[][]{};
    int rowCount =0;
    int pageSize = 15;            // Rows each page
    int pageCount=0;               // Number of all pages
    int curPage=0;                 // Current page
    String strPage;               // ��Ҫ�ӵ�ǰ��һҳ�洫����
    String sqlTemp ="";
    String sqlStr ="";
    String stautsflag=request.getParameter("stautsflag");  // �����û�ѡ��״̬����
    
    HashMap pMap=new HashMap();
		pMap.put("op_code", "K215");
		pMap.put("boss_login_no", loginNo);
		pMap.put("start_date", start_date);
		pMap.put("end_date", end_date);
   		pMap.put("sqlstr",sql);
   		pMap.put("qcGroupId"      , qcGroupId);
		pMap.put("beQcGroupId"    ,beQcGroupId);
		pMap.put("beQcObjId"      ,beQcObjId);
		pMap.put("evterno"        ,evterno);
		pMap.put("staffno"        ,staffno);
		pMap.put("plan_id"        ,plan_id);
		pMap.put("qcobjectid"     ,qcobjectid);
		pMap.put("qcobjectName"   ,qcobjectName);
		pMap.put("qcGroupName"    ,qcGroupName);
		pMap.put("beQcGroupName"  ,beQcGroupName);
		pMap.put("beQcObjName"    ,beQcObjName);
		pMap.put("current_times"  ,current_times);
    
	
	String[] strHead =null;
	String head[]=null;
	String excelName="�ƻ�ִ�������ѯ";
	int intMaxRow=5000;
	  if(headName!=null){
	  if(!"".equalsIgnoreCase(headName)){
	   	head =headName.split(",");
	   	strHead =new String[head.length];
	  for (int i = 0; i < head.length; i++) {
	    strHead[i]=head[i];
      }
    }
	  }        
	  
%>	
		
<%
   //��һ������ҳ�棬��ȡ�ϴ�ѡ�м�¼
   if("cur".equalsIgnoreCase(pageFlag)||"all".equalsIgnoreCase(pageFlag)){
   		  List iDataList3 =(List)KFEjbClient.queryForList("dcallexpstatus",pMap);                              
		    queryList = getArrayFromListMap(iDataList3 ,0,1); 	
		    if(queryList.length!=0){
				strseq=queryList[0][0];
			}
			if(!"".equalsIgnoreCase(strseq)){
				stautsflag="Y";
			}
	}
			
   //������ǰ��ʾ����
   if("cur".equalsIgnoreCase(expFlag)){ 
       rowCount = ( ( Integer )KFEjbClient.queryForObject("query_k215_planOprResult_strCountSql",pMap)).intValue();
        
        strPage = request.getParameter("page");
        if ( strPage == null || strPage.equals("") || strPage.trim().length() == 0 ) {
          	curPage = 1; 
        }                
        else {           
        	curPage = Integer.parseInt(strPage);
          	if( curPage < 1 ) curPage = 1;
        }                
        pageCount = ( rowCount + pageSize - 1 ) / pageSize;
        if ( curPage > pageCount ) curPage = pageCount;
        start = (curPage - 1) * pageSize + 1;
		end = curPage * pageSize;
		pMap.put("start", ""+start);
		pMap.put("end", ""+end);
        
        
        List queryList1 =(List)KFEjbClient.queryForList("exp_k215_planOprResult_cur",pMap);     
        queryList = getArrayFromListMap(queryList1 ,1,17);   

		XLSExport.toExcel(strHead,queryList,intMaxRow,excelName,response);
        out.print("<script language='javascript'>window.close();</script>");
   }
   if("all".equalsIgnoreCase(expFlag)){
		  List iDataList2 =(List)KFEjbClient.queryForList("exp_k215_planOprResult_all",pMap);                              
		  queryList = getArrayFromListMap(iDataList2 ,0,16); 	
     
          XLSExport.toExcel(strHead,queryList,intMaxRow,excelName,response);
		  out.print("<script language='javascript'>window.close();</script>");
	}
			//�����û�ѡ�����  
			if("all".equalsIgnoreCase(expFlag)||"cur".equalsIgnoreCase(expFlag)){
			String deleteStatus="delete from DCALLEXPSTATUS t where t.boss_login_no=:v1 and t.op_code='K215'&&"+loginNo;
			String insertStatus="insert into DCALLEXPSTATUS t(t.boss_login_no,t.op_code,t.field_id,t.create_time) values(:v1,'K215',:v2,sysdate)&&"+loginNo+"^"+seq;
			List sqlList=new ArrayList();
			String[] sqlArr = new String[]{};
			if("Y".equalsIgnoreCase(stautsflag)){
				sqlList.add(deleteStatus);
			}
			sqlList.add(insertStatus);
			sqlArr = (String[])sqlList.toArray(new String[0]);
			String outnum = String.valueOf(sqlArr.length + 1);   
			String orgCode_sqlMulKfCfm = (String)session.getAttribute("orgCode");
			String regionCode_sqlMulKfCfm = orgCode_sqlMulKfCfm.substring(0,2); 
			String sqlMulKfCfm="";
	   
			%>
			<wtc:service name="sModifyMulKfCfm"  outnum="2" routerKey="region" routerValue="<%=regionCode_sqlMulKfCfm%>">
			<wtc:param value="<%=sqlMulKfCfm%>"/>
			<wtc:param value="dbchange"/>
			<wtc:params value="<%=sqlArr%>"/>
			</wtc:service>
			<wtc:array id="retRows"  scope="end"/>
				
<%
   }   
%>


<html>
<head>
<title>�ƻ�ִ�������ѯ����</title>

</head>
<body >
<form name="sitechform" method="post" action="">
<div id="Operation_Table" >
<div class="title"><div id="title_zi">�����б�</div></div>
<div id="title_zi"><input type="checkbox" id="checkAll" name="checkbox" value="checkbox" onclick="s_all('area[]')"/>ȫѡ/ȡ��<br>
<input name="area[]" type="checkbox" id="area[]" seq="0" sql="t1.plan_id" value="�ƻ���ˮ��" onclick="judgeCheckAll('area[]')" />�ƻ���ˮ��<br>
<input name="area[]" type="checkbox" id="area[]" seq="1" sql="t1.plan_name" value="�ƻ�����" onclick="judgeCheckAll('area[]')" />�ƻ�����<br>
<input name="area[]" type="checkbox" id="area[]" seq="2" sql="t4.object_name" value="�������" onclick="judgeCheckAll('area[]')" />�������<br>
<input name="area[]" type="checkbox" id="area[]" seq="3" sql="t5.name" value="�ʼ�����" onclick="judgeCheckAll('area[]')" />�ʼ�����<br>
<input name="area[]" type="checkbox" id="area[]" seq="4" sql="t2.login_no" value="���칤��" onclick="judgeCheckAll('area[]')" />���칤��<br> 
<input name="area[]" type="checkbox" id="area[]" seq="5" sql="t3.check_login_no" value="�ʼ칤��" onclick="judgeCheckAll('area[]')" />�ʼ칤��<br>
<input name="area[]" type="checkbox" id="area[]" seq="6" sql="decode(t1.check_kind,'0','�Զ�����','1','�˹�ָ��') check_kind" value="������ʽ" onclick="judgeCheckAll('area[]')" />������ʽ<br>
<input name="area[]" type="checkbox" id="area[]" seq="7" sql="decode(t1.check_type,'0','ʵʱ�ʼ�','1','�º��ʼ�') check_type" value="�������" onclick="judgeCheckAll('area[]')" />�������<br>
<input name="area[]" type="checkbox" id="area[]" seq="8" sql="t1.plan_time" value="�ƻ�����" onclick="judgeCheckAll('area[]')" />�ƻ�����<br>
<input name="area[]" type="checkbox" id="area[]" seq="9" sql="t1.min_time" value="�������" onclick="judgeCheckAll('area[]')" />�������<br>
<input name="area[]" type="checkbox" id="area[]" seq="10" sql="t1.max_time" value="�������" onclick="judgeCheckAll('area[]')" />�������<br>
<input name="area[]" type="checkbox" id="area[]" seq="11" sql="t2.current_times" value="ʵ�ʴ���" onclick="judgeCheckAll('area[]')" />ʵ�ʴ���<br>
<input name="area[]" type="checkbox" id="area[]" seq="12" sql="t1.alert_days" value="�������" onclick="judgeCheckAll('area[]')" />�������<br>
<input name="area[]" type="checkbox" id="area[]" seq="13" sql="t1.alert_value" value="����ֵ" onclick="judgeCheckAll('area[]')" />����ֵ<br>
<input name="area[]" type="checkbox" id="area[]" seq="14" sql="decode(t2.alert_flag,'Y','�ѱ���','N','δ����','','δ����','null','δ����') alert_flag" value="������־" onclick="judgeCheckAll('area[]')" />������־<br>
<input name="area[]" type="checkbox" id="area[]" seq="15" sql="to_char(t1.begin_date,'yyyy-MM-dd hh24:mi:ss') begin_date" value="��ʼ����" onclick="judgeCheckAll('area[]')" />��ʼ����<br>
<input name="area[]" type="checkbox" id="area[]" seq="16" sql="to_char(t1.end_date,'yyyy-MM-dd hh24:mi:ss') end_date" value="��ֹ����" onclick="judgeCheckAll('area[]')" />��ֹ����<br>


<input name="start_date"                  type="hidden" value="">
<input name="end_date"                    type="hidden" value="">
<input name="qcGroupId"                   type="hidden" value="">
<input name="beQcGroupId"                 type="hidden" value="">
<input name="beQcObjId"                   type="hidden" value="">    
<input name="evterno"                     type="hidden" value="">
<input name="staffno"                     type="hidden" value="">
<input name="plan_id"                     type="hidden" value="">
<input name="qcobjectid"                  type="hidden" value="">
<input name="qcobjectName"                type="hidden" value="">
<input name="qcGroupName"                 type="hidden" value="">
<input name="beQcGroupName"               type="hidden" value="">
<input name="beQcObjName"                 type="hidden" value="">
<input name="current_times"               type="hidden" value="">



<input type="hidden" name="page" value="">
<input type="hidden" name="headName" value="">
<input type="hidden" name="sql" value="">
<input type="hidden" name="stautsflag" value="stautsflag">
<input type="hidden" name="seq" value="">
<input type="button" name="expbutton" value="����" class="b_text" onclick="s_exp('area[]')"/>
<input type="button" name="expclose" value="�ر�" class="b_text" onclick="window.close();"/>
</div>
</p>
</div>
</form>
</body>
</html>

<script language="javascript" type="text/javascript"> 
$(document).ready(
		function()
		{
	    $("td").not("[input]").addClass("blue");
			$("#footer input:button").addClass("b_foot");
			$("td:not(#footer) input:button").addClass("b_text");
			$("input:text[@v_type]").blur(checkElement2);	
		
			$("a").hover(function() {
				$(this).css("color", "orange");
			}, function() {
				$(this).css("color", "blue");
			});
		}
	);

	function checkElement2() { 
				checkElement(this); 
		}	  
 function s_all(x){
 	var tmpCheck = document.getElementById("checkAll");
  var inps = document.getElementsByName(x);
  if(tmpCheck.checked==true){
  	for(var i=0;i<inps.length;i++){
  		inps[i].checked = true;
  	}
  }
  if(tmpCheck.checked==false){
  	for(var i=0;i<inps.length;i++){
  		inps[i].checked = false;
  	}
  }
 }

 //��ȫѡ��ȥ��ĳ��ѡ����,��ȫѡ������ zengzq add 
 function judgeCheckAll(x){
 	var tmpCheck = document.getElementById("checkAll");
 	var inps = document.getElementsByName(x);
 	var count = 0;
 		for(var i=0;i<inps.length;i++){
  		if(inps[i].checked == false){
  			tmpCheck.checked = false;
  			count++ ;
  		}
  	}
  	if(count==0){
  			tmpCheck.checked = true;
  	}
 }
 
 //�ж�һ���ַ����Ƿ������г���
function isStr(str,strArr){
	if(strArr!=null&&strArr!=''){
		for(var j=0;j<strArr.length;j++){
     		if(str==strArr[j]){
     			return true;
     		}
		}
	}
	return false;
}
//�����û��ϻ�����״̬
 function setStauts(){
  var inps = document.forms['sitechform'].elements['area[]'];
  var arrid ="<%=strseq%>";
  var temarr=new Array();
  //zengzq add 
  var count = 0;
  if(arrid!=''){
  	temarr=arrid.split(",");
  	for(var i=0;i<inps.length;i++){
	   	if(isStr(inps[i].seq,temarr)){
	   	inps[i].checked=true;
	   	//zengzq add 
	   	count++;
	   	}
  	}
  	//����ϴ�ȫѡ,��˴ν�"ȫѡ/ȡ��"��ѡ zengzq add  
  	if(inps.length==count){
  			document.getElementById('checkAll').checked = true;
  	} else{
  			document.getElementById('checkAll').checked = false;
  	}
 }
 }
 setStauts();
 
function s_exp(x){
	
	var head=getCheckboxValue();
	var sql=getCheckboxSql();
	var seq=getCheckboxSeq();
	var stautsflag="<%=stautsflag%>";
	var temSql='';
	var expFlag="<%=pageFlag%>";
	//window.sitechform.sqlFilter.value = opener.document.sitechform.sqlWhere.value;
	window.sitechform.page.value = opener.document.sitechform.page.value;
    window.sitechform.headName.value = head;
    window.sitechform.sql.value = sql;
    window.sitechform.seq.value = seq;
    window.sitechform.stautsflag.value = stautsflag;
    //20091120 �󶨱�������
    window.sitechform.start_date.value                        = opener.sitechform.start_date.value;                    
    window.sitechform.end_date.value                          = opener.sitechform.end_date.value;                      
    window.sitechform.qcGroupId.value                        = opener.sitechform.qcGroupId.value;                    
    window.sitechform.beQcGroupId.value                       = opener.sitechform.beQcGroupId.value;                   
    window.sitechform.beQcObjId.value                   = opener.sitechform.beQcObjId.value;               
    window.sitechform.evterno.value                          = opener.document.all("4_=_t3.check_login_no").value;                      
    window.sitechform.staffno.value                      = opener.document.all("5_=_t2.login_no").value;                  
    window.sitechform.plan_id.value                      = opener.document.all("6_=_t1.plan_id").value;                  
    window.sitechform.qcobjectid.value                     = opener.document.all("3_=_t1.content_id"        ).value;             
    window.sitechform.qcobjectName.value                 = opener.sitechform.qcobjectName.value;             
    window.sitechform.qcGroupName.value                   = opener.sitechform.qcGroupName.value;               
    window.sitechform.beQcGroupName.value                           = opener.sitechform.beQcGroupName.value;                       
    window.sitechform.beQcObjName.value                     = opener.sitechform.beQcObjName.value;                 
    window.sitechform.current_times.value                         = opener.document.all("2_<>=_t2.current_times").value;                     
    //:~
  
    if(head==''){
   	return;
   	}
   	//temSql="select "+sql+ "from dqcplan t1,dqcloginplan t2,dqccheckloginplan t3,dqcobject t4,dqccheckcontect t5 "+ window.sitechform.sqlFilter.value;
   submitExp(expFlag);
 }
 function submitExp(str){
 	 window.sitechform.action="k215_expSelect.jsp?exp="+str;
 	 window.sitechform.method='post';
   window.sitechform.submit(); 
 	}
function getCheckboxValue()
{
   var checkbox=document.forms['sitechform'].elements['area[]'];
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
function getCheckboxSql()
{
   var checkbox=document.forms['sitechform'].elements['area[]'];
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
			val[val.length] = checkbox[i].sql;
		}
	}
	
	return (val.length)?val:'';
}
function getCheckboxSeq()
{
   var checkbox=document.forms['sitechform'].elements['area[]'];
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
			val[val.length] = checkbox[i].seq;
		}
	}
	
	return (val.length)?val:'';
}
 </script>