<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
/********************
version v3.0
������: si-tech
ningtn 2011-9-21 14:28:59
********************/
%>
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
		response.setHeader("Pragma","No-Cache"); 
		response.setHeader("Cache-Control","No-Cache");
		response.setDateHeader("Expires", 0); 
    
 		String opCode = "e280";
 		String opName = "��ͥ��Ʒ���";
 		
 		String phoneNo = (String)request.getParameter("activePhone");
 		//hejwa add ������ӡ��Ʊʱ��ת��������ֻ��һ��������13904511160���ַ��������ﵥ������
 		if(phoneNo.indexOf("carFlag")!=-1){
 			phoneNo = phoneNo.replaceAll("carFlag","");//��ԭ�ֻ���

%>
<script language="javascript">
		parent.document.getElementById("user_index").contentWindow.goTo_car_Func("g794","e280","&ACT_CLASS=64");
</script>		
<% 		
		}
 		String regionCode= (String)session.getAttribute("regCode");
%>
<%
		/* �����û��ֻ����룬��ѯ�������С�ѡ��ļ�ͥҵ�������ǹ������� */
		String[] inParams = new String[2];
		String belongGroupId = "";
		String getCitySql = "SELECT msg.GROUP_ID"
			+" FROM dchngroupmsg msg, dchngroupinfo info, dcustmsg d"
			+" WHERE msg.root_distance = 2"
			+" AND msg.GROUP_ID = info.parent_group_id"
			+" AND info.GROUP_ID = d.GROUP_ID"
			+" AND d.phone_no = :phoneNo";
		inParams[0] = getCitySql;
		inParams[1] = "phoneNo=" + phoneNo;
%>
		<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" 
			retmsg="msg0" retcode="code0" outnum="1">
			<wtc:param value="<%=inParams[0]%>"/>
			<wtc:param value="<%=inParams[1]%>"/>
		</wtc:service>
		<wtc:array id="result0" scope="end" />
<%
		if("000000".equals(code0)){
			if(result0 != null && result0.length > 0){
				belongGroupId = result0[0][0];
			}
		}
		
		/* ��ͥ���� */
		String getFamilyOperSql = "select family_code,op_code,op_name from sfamilyoper order by op_code";
%>
		<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" 
			retmsg="msg1" retcode="code1" outnum="3">
			<wtc:param value="<%=getFamilyOperSql%>"/>
		</wtc:service>
		<wtc:array id="result1" scope="end" />
			

<html>
<head>
	<title>��ͥ��Ʒ���</title>
	<script language="javascript">
		var arrfamilyCode = new Array();//��ͥ��ͥ����
		var arrfamilyopCode = new Array();//��ͥ��������
		var arrfamilyopName = new Array();//��ͥ��������
		
		<%
		for(int i = 0; i < result1.length; i++){
		out.println("arrfamilyCode["+i+"]='"+result1[i][0]+"';\n");
		out.println("arrfamilyopCode["+i+"]='"+result1[i][1]+"';\n");
		out.println("arrfamilyopName["+i+"]='"+result1[i][2]+"';\n");
		}
		%>
		
		function selectChange(control,controlToPopulate,ItemArray,GroupArray){
			var myEle ;
			var x ;
			
			for (var q=controlToPopulate.options.length;q>=0;q--) controlToPopulate.options[q]=null;
			myEle = document.createElement("option") ;
			myEle.value = "";
			myEle.text ="--��ѡ��--";
			controlToPopulate.add(myEle);
			
			for ( x = 0 ; x < ItemArray.length  ; x++ )
			{
				if ( GroupArray[x] == control.value )
				{
					myEle = document.createElement("option") ;
					myEle.value = arrfamilyopCode[x] ;
					myEle.text = ItemArray[x] ;
					controlToPopulate.add(myEle) ;
				}
			}
			changeOperate();
		}
		
		function nextStep(subButton){
			var familyInfoVal = $("#familyInfo").val();
			var familyoperVal = $("#familyoper").val();
			if(typeof(familyInfoVal) == "undefined" || "" == familyInfoVal || "null" == familyInfoVal){
				rdShowMessageDialog("��ѡ���ͥҵ��",0);
		  	return false;
			}
			if(typeof(familyoperVal) == "undefined" || "" == familyoperVal || "null" == familyoperVal){
				rdShowMessageDialog("��ѡ���ͥ������",0);
		  	return false;
			}
			/* begin ����Э��ʵ��BOSS���������ƷѶԽӷ���������@2014/11/25  */
			if($("#familyInfo").val() == "HEJT" && $("#familyoper").val() == "e281"){
				chkTVCardNo();
				if(chkTVFlag == "N") return false;
			}
			/* end ����Э��ʵ��BOSS���������ƷѶԽӷ���������@2014/11/25  */
			if(($("#familyoper").val() == "e285" 
				|| $("#familyoper").val() == "e881"
				|| $("#familyoper").val() == "i089"
			) && $("#backAccept").val() == ""){
				rdShowMessageDialog("��������ˮ��",0);
		  	return false;
			}
			getPubCheck(familyoperVal,familyInfoVal,"");
			var checkObj = $("#checkFlag");
			if(checkObj.val() == "0"){
				/* ����������ִ�� */
				return false;
			}
			/* ��ť�ӳ� */
			controlButt(subButton);
			/* �º����� */
			getAfterPrompt();
			/* ���ò�����Ϊ��һҳ�� */
			$("#opCode").val(familyoperVal);
			$("#opName").val($("#familyoper option:selected").text());
			$("#familyCode").val(familyInfoVal);
			var familyNameStr = $("#familyInfo option:selected").text();
			familyNameStr = familyNameStr.substr(familyNameStr.indexOf("-->")+3,familyNameStr.length);
			$("#familyName").val(familyNameStr);
			$("#belongGroupId").val("<%=belongGroupId%>");
			//alert(familyInfoVal+"--"+familyoperVal);
			if(familyoperVal == "e281"){
				form1.action = "fe280Main.jsp";
				form1.submit();
			}else if(familyoperVal == "e282"){
				form1.action = "fe280Main.jsp";
				form1.submit();
			}else if(familyoperVal == "e283" || familyoperVal == "e284" || familyoperVal == "e285"){
				form1.action = "fe280Quit.jsp";
				form1.submit();
			}else if(familyoperVal == "e840") {
				form1.action = "fe280Vary.jsp";
				form1.submit();
			}else if(familyoperVal == "e855") {
				form1.action = "fe280ChangProd.jsp";
				form1.submit();
			}else if(familyoperVal == "e875" || familyoperVal == "e880" || familyoperVal == "e881") {
				form1.action = "fe875Main.jsp";
				form1.submit();
			}else if(familyoperVal == "g782") {
				form1.action = "fe782Main.jsp";
				form1.submit();
			}else if ( familyoperVal == "i088" )
			{
				form1.action = "fe280Main.jsp";
				form1.submit();
			}
			else if ( familyoperVal == "i089" )
			{
				form1.action = "fe280Quit.jsp";
				form1.submit();
			}
		}
		function getPubCheck(opcode,famCode,memberRoleId){
			var getdataPacket = new AJAXPacket("fe280PubCheck.jsp","���ڻ�����ݣ����Ժ�......");
			getdataPacket.data.add("parentPhone","<%=phoneNo%>");
			getdataPacket.data.add("opCode",opcode);
			getdataPacket.data.add("famCode",famCode);
			getdataPacket.data.add("memberRoleId",memberRoleId);
			getdataPacket.data.add("checkType","1");
			getdataPacket.data.add("backAccept",$("#backAccept").val());
			getdataPacket.data.add("parentPhoneNo","<%=phoneNo%>");
			core.ajax.sendPacket(getdataPacket,doPubCheckBack);
			getdataPacket = null;
		}
		function doPubCheckBack(packet){
			retCode = packet.data.findValueByName("retcode");
			retMsg = packet.data.findValueByName("retmsg");
			var checkObj = $("#checkFlag");
			if(retCode != "000000"){
				checkObj.val("0");
				rdShowMessageDialog(retCode + retMsg,0);
		  	return false;
			}else{
				checkObj.val("1");
			}
		}
		function changeOperate(){
			if($("#familyoper").val() == "e285"
			 || $("#familyoper").val() == "i089"
			 || $("#familyoper").val() == "e881"){
				/* ���� */
				$("#backTR").show();
			}else{
				$("#backTR").hide();
			}
			/* begin ����Э��ʵ��BOSS���������ƷѶԽӷ���������@2014/11/25  */
			if($("#familyInfo").val() == "HEJT" && $("#familyoper").val() == "e281"){
				$("#TVCardNoTR").show();
			}else{
				$("#TVCardNoTR").hide();
			}
		}
		
		var chkTVFlag = "N";
		function chkTVCardNo(){
			if(!checkElement(document.form1.TVCardNo)){
				chkTVFlag = "N";
				return false;
			}else{
				chkTVFlag = "Y";
			}
			var TVCardNo = $("#TVCardNo").val();
			var packet = new AJAXPacket("fe280_ajax_chkTVCardNo.jsp","���ڻ�����ݣ����Ժ�......");
    	packet.data.add("opCode","<%=opCode%>");
    	packet.data.add("TVCardNo",TVCardNo);
    	core.ajax.sendPacket(packet,doChkTVCardNo);
    	packet = null;
		}
		
		function doChkTVCardNo(packet){
			var retCode = packet.data.findValueByName("retCode");
			var retMsg = packet.data.findValueByName("retMsg");
			if(retCode != "000000"){
				rdShowMessageDialog("������룺"+retCode+"<br>������Ϣ��"+retMsg,0);
				chkTVFlag = "N";
				return false;
			}else{
				chkTVFlag = "Y";
			}
		}
		/* end ����Э��ʵ��BOSS���������ƷѶԽӷ���������@2014/11/25  */
	</script>
</head>
<body>
<form action="" method="post" name="form1">
	<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">��ͥ��Ʒ���</div>
	</div>
	<table>
		<tr>
			<td class="blue" width="15%">�ֻ�����</td>
			<td width="35%">
				<input type="text" name="parentPhone" id="parentPhone" value="<%=phoneNo%>"
				  class="InputGrey" readOnly />
			</td>
			<td class="blue" width="15%">��ͥҵ��</td>
			<td width="35%">
				<select id="familyInfo" style="width:170px;" name="familyInfo" onchange="selectChange(this,familyoper,arrfamilyopName,arrfamilyCode)" >
					<option value ="">--��ѡ��--</option>
					<wtc:qoption name="TlsPubSelCrm" outnum="2">
						<wtc:sql>
							SELECT family_code, family_code || '-->' || family_name
							  FROM sfamilyinfo
							 WHERE GROUP_ID = '?' and family_code <> 'JXJT' order by family_name
						</wtc:sql>
						<wtc:param value="<%=belongGroupId%>"/>
					</wtc:qoption>
				</select>
			</td>
		</tr>
		<tr>
			<td class="blue" >����</td>
			<td colspan="3">
					<select  name="familyoper" id="familyoper" onchange="changeOperate()" >	
			  	  
					</select>
			</td>
		</tr>
		<tr id="backTR" style="display:none;">
			<td class="blue" >������ˮ</td>
			<td colspan="3">
					<input type="text" name="backAccept" id="backAccept" maxlength="14" />
			</td>
		</tr>
		<tr id="TVCardNoTR" style="display:none;">
			<td class="blue" >�����ӿ���</td>
			<td colspan="3">
					<input type="text" name="TVCardNo" id="TVCardNo" maxlength="18" v_type="0_9" v_must="1" value="" onblur="chkTVCardNo()" />
			</td>
		</tr>
	</table>
	<input type="hidden" name="checkFlag" id="checkFlag" />
	<table>
		<tr > 
			<td id="footer"> <div align="center"> 
			<input name="confirm" type="button" class="b_foot" index="2" value="��һ��" onClick="nextStep(this)" />
			&nbsp; 
			<input name="reset" type="reset" class="b_foot" value="���" />
			&nbsp; 
			<input name="back" onClick="removeCurrentTab();" type="button" class="b_foot" value="�ر�" />
			&nbsp; </div>
			</td>
		</tr>
	</table>
	<!-- ���ر������֣�Ϊ��һҳ�洫���� -->
	<input type="hidden" name="opCode" id="opCode" />
	<input type="hidden" name="opName" id="opName" />
	<input type="hidden" name="familyCode" id="familyCode" />
	<input type="hidden" name="familyName" id="familyName" />
	<input type="hidden" name="belongGroupId" id="belongGroupId" />
	
	
	<%@ include file="/npage/include/footer.jsp" %> 
</form>
</body>
</html>