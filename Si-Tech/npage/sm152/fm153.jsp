<%
/********************
 version v2.0
������: si-tech
create by wanglm 20110321
********************/
%>	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="com.sitech.boss.util.page.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
  request.setCharacterEncoding("GBK");
  String opCode = (String)request.getParameter("opCode");
  String opName = (String)request.getParameter("opName");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=opName%></title>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
    String work_no = (String)session.getAttribute("workNo");
    String loginName = (String)session.getAttribute("workName");
    String current_timeNAME=new SimpleDateFormat("yyyyMMdd HH:mm:ss", Locale.getDefault()).format(new java.util.Date());
%>
<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>
<script language="javascript" type="text/javascript" src="/njs/plugins/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">
  function queryGroup(){
  	  var win = window.open('fe121_setpdmain.jsp','','width='+(screen.availWidth*1-10)+',height='+(screen.availHeight*1-76) +',left=0,top=0,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no');
  }
  function getWorkNo(){
  	var chkPacket = new AJAXPacket ("ajax_getTab.jsp","��ȴ�������");
	chkPacket.data.add("groupId" , $("#groupId").val());
	chkPacket.data.add("PageSize" , $("#pageRows").val());
	core.ajax.sendPacketHtml(chkPacket,showMsg,true);
	chkPacket =null;	
  }
  function showMsg(data){
	$("#showTab").empty().append(data);
	$("#pageTr").show();
	/* ningtn */
}
	function getFileName(obj){
		var pos = obj.lastIndexOf("\\");
		return obj.substring(pos+1);
	}
	function getFileExt(obj)
	{
	    var pos = obj.lastIndexOf(".");
	    return obj.substring(pos+1);
	}
 function doCfm(){
 	
 	 
 var radio1 = document.getElementsByName("opFlag");
 var radiovlues="";
  for(var i=0;i<radio1.length;i++)
  {
    if(radio1[i].checked)
	{
	  var opFlag = radio1[i].value;
	  if(opFlag=="add")
	  {
	  	radiovlues="0";
	  	
	  }else if(opFlag=="del")
	  {
			radiovlues="1";
	    	
	  }
	}
  }
  
     var power_codes = $("#power_code").val();
  
 			 	if(radiovlues==""){
					rdShowMessageDialog("��ѡ���������!");
					return false;
				}
	
	 			 	if(power_codes==""){
					rdShowMessageDialog("��ѡ���ɫ��Ϣ!");
					return false;
				}
 			 	if($("#oaNumber").val()==""){
 					rdShowMessageDialog("������OA��ţ�");
 					return;
 				}
 				if($("#oaTitle").val()==""){
 					rdShowMessageDialog("������OA���⣡");
 					return;
 				}
			
   
 			 	if(form1.feefile.value.length<1){
					rdShowMessageDialog("���ϴ��ļ�!");
					document.form1.feefile.focus();
					return false;
				}

		 		var fileVal = getFileExt($("#feefile").val());
				if("txt" == fileVal){
					//��չ����txt
				}else{
					rdShowMessageDialog("�ϴ��ļ�����չ������ȷ",0);
					return false;
				}
				document.form1.action = "fm153Cfm.jsp?checkvalue="+radiovlues+"&opCode=<%=opCode%>&opName=<%=opName%>&power_codess="+power_codes+"&oaNumber="+$("#oaNumber").val()+"&oaTitle="+$("#oaTitle").val();
   			document.form1.submit();
 }
 	function selPage(){
    getWorkNo();	
 	}
 	function resetPage(){
 		window.location.href = "fm153Cfm.jsp?opCode=<%=opCode%>&opName=<%=opName%>";
	}
	
		//ѡ�񷢲���֯�ڵ�
	function queryRoleCode(formName)
	{
		var path = "";
		var path = "/npage/s8175/roletree.jsp?formFlag="+formName;
	  	window.open(path,'_blank','height=600,width=300,scrollbars=yes');
	}

</script>
</head>
<body>
<form name="form1" id="form1" method="POST" ENCTYPE="multipart/form-data">
<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi"><%=opName%></div>
	</div>


	<div id="showTab" ></div>
	
	<table>
		<tr>
			<td class="blue">
				��������
			</td>
			<td colspan="3">
		<input type="radio" name="opFlag" value="add" >����
		<input type="radio" name="opFlag" value="del" >ɾ��
	</td>
	</tr>
			<tr>
			<td class="blue">
				��ɫ��Ϣ
			</td>
			<td colspan="3">
							<input type=text id=power_code name=power_code v_type="string"  v_must=1 size=8  value="">
							<input type=text name="power_name" value="" readonly class="InputGrey">
							<input type="button"  class="b_text" name="btnQueryRoleCode" onclick="queryRoleCode('form1')" value="ѡ��">
							<font class="orange">*</font>
	</td>
	</tr>
	<tr>
			<td class="blue">&nbsp;OA���</td>
			<td><input type="text" id="oaNumber" name="oaNumber" maxlength="30"/><font color="orange">*</font>
			</td>
			<td class="blue">&nbsp;OA����</td>
			<td><input type="text" id="oaTitle" name="oaTitle" maxlength="30"/><font color="orange">*</font>
			</td>
		</tr>
	
		<tr id="fileUpLoad">
			<td class="blue">
				�ļ��ϴ�
			</td>
			<td>
				<input type="file" name="feefile" id="feefile">
			</td>
			<td class="blue">
				�ļ��ϴ�˵��
			</td>
			<td>
				<span>
					�����ļ�����Ϊ<font color="red">txt</font>��ʽ��ÿ�м�¼Ϊ��������<br />
					һ��������200������<br />
					&nbsp;�磺<br />
					&nbsp;&nbsp;&nbsp;aaaaxp<br />
					&nbsp;&nbsp;&nbsp;aaaax1<br />

			</span>
			</td>
		</tr>

      </table>
              <table cellspacing="0">
          <tr>
            <td noWrap id="footer">
              <div align="center">	
              <input class="b_foot" type=button name="confirm" value="ȷ��" onClick="doCfm(this)" index="2">
              <input class="b_foot" type=button name=back value="���" onClick="resetPage()">
		      <input class="b_foot" type=button name=qryP value="�ر�" onClick="removeCurrentTab()">
              </div>
            </td>
          </tr>
        </table>
      <input type="hidden" name="opCode" id="opCode" value="<%=opCode%>"/>
      <input type="hidden" name="opName" id="opName" value="<%=opName%>"/>
    <%@ include file="/npage/include/footer_simple.jsp"%>
   </form>
</body>
</html>