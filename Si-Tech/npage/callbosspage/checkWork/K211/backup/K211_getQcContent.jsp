<%
  /*
   * ����: �������ѯ
�� * �汾: 1.0
�� * ����: 2008/11/10
�� * ����: hanjc 
�� * ��Ȩ: sitech
   * 
   *  
 ��*/
 %>
<%@ page contentType="text/html;charset=gb2312"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="javax.servlet.http.HttpServletRequest,com.sitech.crmpd.core.wtc.util.*,com.sitech.boss.util.excel.*"%>
<%! 
		/** 
		 ����˵��: ����һ��������sql.Ȼ��ҳ�����ģʽ��  [�����_=_�ֶ���] ��  [�����_like_�ֶ���]
		 ����columnΪ��ѯ�ֶ�.��һλ�������.����Ų����ظ�.�ظ����������һ��ֵ.�ұ���������.��С������1,11,123.
		 */ 
        public String returnSql(HttpServletRequest request){
        StringBuffer buffer = new StringBuffer();

		   //�������.
		Map map = request.getParameterMap();
		Object[] objNames = map.keySet().toArray();
		Map temp = new HashMap();
		String name="";
		String[] names= new String[0];
		String value="";
		//���������������.key������.�����ֽ�������.value�������object�����ֵ.
		for (int i = 0; i < objNames.length; i++) {
			name = objNames[i] == null ? "" : objNames[i]
			.toString();
			//String name
			names = name.split("_");
			//��name����'_'�ֳ�3������.
			if (names.length >= 3) {
		//������ܷ�˵�����ֲ��Ϸ�.̫�����ֲ���.
		    value = request.getParameter(name);
		//�������ֵõ�value
		if (value.trim().equals("")) {
			//���value��""����.
			continue;
		}
		Object[] objs = new Object[3];
		objs[0] = names[1];
		//���� ��һ���ַ���.��like ���� =
		name = name.substring(name.indexOf("_") + 1);
		name = name.substring(name.indexOf("_") + 1);
		//��ط������ݿ���ֶδ���.������'_'�Ժ�Ķ������ݿ��ֶ���.
		objs[1] = name;
		//�ڶ����ַ���.��ѯ����.
		objs[2] = value;
		//������.��ѯ��ֵ.
	//	System.out.println("~~~~~~~~~~~~~" + objs[0]);
		try {
			temp.put(Integer.valueOf(names[0]), objs);
			//����ط��ǽ��ַ���ת��������.Ȼ���������.����19Ҫ��2֮��.
		} catch (Exception e) {

		}
		//������������key����,ojbs����ŵ�value����.
			}
		}
		Object[] objNos = temp.keySet().toArray();
		//�õ�һ�����������.
		Arrays.sort(objNos);
		//�����ֽ�������.
		for (int i = 0; i < objNos.length; i++) {
			Object[] objs = null;
			objs = (Object[]) temp.get(objNos[i]);
			//�����like �� = �ֱ���.
			if (objs[0].toString().toLowerCase().equalsIgnoreCase(
			"like")) {
		buffer.append(" and " + objs[1] + " " + objs[0] + " '%%"
				+ objs[2].toString().trim() + "%%' ");
			}
			if (objs[0].toString().equalsIgnoreCase("=")) {
		buffer.append(" and " + objs[1] + " " + objs[0] + " '"
				+ objs[2].toString().trim() + "' ");
			}
		}

        return buffer.toString();
}
    public  String getCurrDateStr(String str) {
		java.text.SimpleDateFormat objSimpleDateFormat = new java.text.SimpleDateFormat(
				"yyyyMMdd");
		return objSimpleDateFormat.format(new java.util.Date())+" "+str;
	}
%>

<%
    String opCode="K211";
    String opName="�ʼ��ѯ-�������ѯ";
	  String loginNo = (String)session.getAttribute("workNo");  
	  String orgCode = (String)session.getAttribute("orgCode"); 
	  String regionCode = "";
	  if(orgCode!=null){
	  regionCode = orgCode.substring(0,2);
	  }
		
  	String sqlStr = "select contact_id,contact_accept,caller_phone,callee_phone,cust_name,sm_code,grade_code,region_code,mail_address,fax_no,contact_address,contact_phone,accept_phone,begin_date,end_date,accept_long,accept_login_no,lang_code,statisfy_code,call_cause_id,qc_flag from dcallcall200810";
		String strCountSql="select to_char(count(*)) count  from dcallcall200810";
		String strDateSql="";
    int Temp =0;

    String start_date    =  request.getParameter("start_date");      
    String end_date      =  request.getParameter("end_date");        
    String login_no      =  request.getParameter("0_=_login_no");    
    String be_login_no   =  request.getParameter("1_=_be_login_no"); 
    String op_type       =  request.getParameter("2_=_op_type");     
%>			


<html>
<head>
<title>�������ѯ</title>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/npage/callbosspage/js/datepicker/WdatePicker.js"></script>
<script language=javascript>
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

function submitMe(){
   window.sitechform.myaction.value="doLoad";
   window.sitechform.action="K211_evaItemQry.jsp";
   window.sitechform.method='post';
   window.sitechform.submit(); 
}

//���������¼
function clearValue(){
var e = document.forms[0].elements;
for(var i=0;i<e.length;i++){
  if(e[i].type=="select-one"||e[i].type=="text")
   e[i].value="";
 }
}


//��ʾͨ����ϸ��Ϣ
function getCallDetail(contact_id,start_date){
		var path="<%=request.getContextPath()%>/npage/callbosspage/k170/k170_getCallDetail.jsp";
    path = path + "?contact_id=" + contact_id;
    path = path + "&start_date=" + start_date;
    window.open(path,"newwindow","height=768, width=1072,top=50,left=100,scrollbars=yes, resizable=no,location=no, status=yes");
	return true;
}

// ��iframemiddle��ֵ��ˢ��ҳ��
function sendIframemiddleId(selectedItemId){
	alert(selectedItemId);
	var iframemiddle = window.frames['framemiddle']
	iframemiddle.location.href="<%=request.getContextPath()%>/npage/callbosspage/checkWork/K211/K211_qcContent.jsp?selectedItemId="+selectedItemId;
	//iframemiddle.document.sitechform.selectedItemId.value=selectedItemId;
	//iframemiddle.location.reload();
 }

//��ѡȡ���������ظ�����
function setQryCondition(){
	 window.opener.sitechform.qcobjectid.value=window.sitechform.beQcObjId.value;
	 window.opener.sitechform.qcobjectName.value=window.sitechform.beQcObjName.value;
	 if(window.sitechform.beQcContentName.value!=""){
	   window.opener.sitechform.beQcObjId.value=window.sitechform.beQcContentId.value;
	   window.opener.sitechform.beQcObjName.value=window.sitechform.beQcContentName.value;
	 }
	 window.close();
}

</script>
</head>


<body >
<form id=sitechform name=sitechform>
	<div id="Operation_Table">
		<div class="title">�������ѯ</div>
		<table cellspacing="0" >
      <tr >
       <td > ��ѡ������� 
				<input  id="beQcObjName" name="beQcObjName" type="text"  onclick=""   value="">
        ��ѡ�ʼ�����
			  <input id="beQcContentName" name ="beQcContentName" type="text" onclick=""   value="">
			</td>
    </tr>
		</table>    
	</div>
	<iframe name="frameleft" id="frameleft" marginHeight="0" marginWidth="0" frameborder="1"  scrolling="auto" src="<%=request.getContextPath()%>/npage/callbosspage/checkWork/K211/K211_beQcObjTree.jsp" width="40%" height="75%"></iframe>
	<iframe name="framemiddle" id="framemiddle" marginHeight="0" marginWidth="0" frameborder="1" scrolling="auto" src="<%=request.getContextPath()%>/npage/callbosspage/checkWork/K211/K211_qcContent.jsp" width="60%" height="75%"></iframe>
				<p  align="center" id="footer" style="width:680px">
          <input name="cfm" type="button"  id="add" value="ȷ��" onClick="setQryCondition();return false;">
          <input name="camcle" type="button"  id="search" value="ȡ��" onClick="window.close();return false;">
       </p>
  <input  id="beQcObjId" name="beQcObjId" type="hidden"  value="">
	<input id="beQcContentId" name ="beQcContentId" type="hidden"  value="">
</form>
</body>
</html>
