<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
/********************
version v1.0
������: si-tech
ningtn 2012-8-9 11:27:26
********************/
%>
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
		response.setHeader("Pragma","No-Cache"); 
		response.setHeader("Cache-Control","No-Cache");
		response.setDateHeader("Expires", 0); 
    
 		String opCode = "e972";
 		String opName = "��������";
 		
 		String phoneNo = (String)request.getParameter("activePhone");
 		String broadPhone = (String)request.getParameter("broadPhone");
 		String groupId =(String)session.getAttribute("groupId");
 		String regionCode= (String)session.getAttribute("regCode");
 		String workNo = (String)session.getAttribute("workNo");
 		String loginPwd = (String)session.getAttribute("password");
 		String[][] temfavStr=(String[][])session.getAttribute("favInfo");
		String[] favStr=new String[temfavStr.length];
		for(int i=0;i<favStr.length;i++)
			favStr[i]=temfavStr[i][0].trim();
%>
		<wtc:service name="sPubUsrBaseInfo" routerKey="region" routerValue="<%=regionCode%>" 
			retcode="retCode1" retmsg="retMsg1" outnum="30" >
			<wtc:param value=" "/>
			<wtc:param value="01"/>
			<wtc:param value="<%=opCode%>"/>
			<wtc:param value="<%=workNo%>"/>	
			<wtc:param value="<%=loginPwd%>"/>		
			<wtc:param value="<%=phoneNo%>"/>	
			<wtc:param value=" "/>
		</wtc:service>
		<wtc:array id="sPubUsrBaseInfoArr" scope="end"/>
			
		<%
		 String loginAccept = "";
		%>
		<wtc:sequence name="sPubSelect" key="sMaxSysAccept" 
			routerKey="region"  routerValue="<%=regionCode%>" id="sLoginAccept"/>
		<%
		/*2016/2/29 13:37:38 gaopeng  1238��ԭ���߼� ��ѯʵ��ʹ������Ϣ*/
	String opNote = "�û�"+phoneNo+"������["+opName+"]����";
	String qRealUserName = "";
  String qRealUserAddr = "";
  String qRealUserIdType = "";
  String qRealUserIccId = "";
%>
<wtc:service name="sm245Qry" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode_realUser" retmsg="retMsg_realUser" outnum="6"	>
	<wtc:param value = "<%=loginAccept%>"/>
	<wtc:param value = "01"/>
	<wtc:param value = "<%=opCode%>"/>
	<wtc:param value = "<%=workNo%>"/>
	<wtc:param value = "<%=loginPwd%>"/>
	<wtc:param value = "<%=phoneNo%>"/>
	<wtc:param value = ""/>
	<wtc:param value = "<%=opNote%>"/>
</wtc:service>
<wtc:array id="ret_realUser" scope="end" />
<%

	if("000000".equals(retCode_realUser)){
		if(ret_realUser.length > 0){
			qRealUserIdType = ret_realUser[0][2];
		  qRealUserIccId = ret_realUser[0][3];
		  qRealUserName = ret_realUser[0][4];
		  qRealUserAddr = ret_realUser[0][5];
		}
	}
	
%>
		
<%
    if(!"000000".equals(retCode1)){
%>
      <script language=javascript>
        rdShowMessageDialog('������룺<%=retCode1%><br>������Ϣ��<%=retMsg1%>');
        removeCurrentTab();
      </script>
<%
      return;
    }
    ArrayList baseInfoList = new ArrayList();
		if(sPubUsrBaseInfoArr!=null&&sPubUsrBaseInfoArr.length>0&&retCode1.equals("000000")){
			for(int i=0;i<sPubUsrBaseInfoArr.length;i++){
				for(int j=0;j<sPubUsrBaseInfoArr[i].length;j++){
					baseInfoList.add(sPubUsrBaseInfoArr[i][j]);
					System.out.println("sPubUsrBaseInfoArr["+i+"]["+j+"]="+sPubUsrBaseInfoArr[i][j]);
				}
			}
		}else{
%>
			<script language=javascript>
        rdShowMessageDialog('������룺<%=retCode1%><br>������Ϣ��<%=retMsg1%>');
        removeCurrentTab();
      </script>
<%
		}
		String userRegionCode = ((String)baseInfoList.get(2)).length()>=2?((String)baseInfoList.get(2)).substring(0,2):"";
		String handFeeSqlStr = "select hand_fee ,trim(favour_code) from snewFunctionFee where region_code='"+userRegionCode+"' and function_code='"+opCode+"'";
%>
		<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" outnum="2">
		    <wtc:sql><%=handFeeSqlStr%>
		    </wtc:sql>
				</wtc:pubselect>
		<wtc:array id="handFeeSqlArr" scope="end"/>
<%
		if(handFeeSqlArr!=null&&handFeeSqlArr.length>0){
			for(int i=0;i<handFeeSqlArr[0].length;i++){
				baseInfoList.add(handFeeSqlArr[0][i]);
			}
		}else{
				baseInfoList.add("");
				baseInfoList.add("");
		}
		
		//���񷵻ز������ܲ��淶,���緵����λ�ȵ�.��������ת����,������Ϊ����������淶�����Ĵ���
		int returnCode = retCode1==""?999999:Integer.parseInt(retCode1);
		String returnMsg = retMsg1;
		baseInfoList.add(String.valueOf(returnCode));
		baseInfoList.add(returnMsg);

		//�������������ת��һ��
		ArrayList custDoc = baseInfoList;
		if(custDoc.size()<34){ //������Ȳ���34,�ͱ���������
%>
			<script language=javascript>
        rdShowMessageDialog("δ��ȡ���û������Ļ�����Ϣ!");
        removeCurrentTab();
      </script>
<%
		}
		/***�û�Ʒ��***/
		String sNewSmName = ((String)custDoc.get(3))==null?"":(String)custDoc.get(3);
		boolean hfrf=false;
		if(((String)custDoc.get(30)).trim().equals("") 
				|| ((String)custDoc.get(30)).trim().equals("0") 
				|| Double.parseDouble(((String)(custDoc.get(30))))==0){
 			hfrf=true;
		}else{
      if(!WtcUtil.haveStr(favStr,((String)custDoc.get(31)).trim())){
 				hfrf=true;
		  }
		}
%>

<%
		loginAccept = sLoginAccept;
		String main_str1="";
		String OldId=(String)custDoc.get(0);
		String sqlStrk = "SELECT '('||a.offer_id||' '||trim(b.offer_name)||')',a.offer_id FROM product_offer_instance a, product_offer b "+
	 				  "WHERE a.offer_id = b.offer_id and SYSDATE BETWEEN a.eff_date AND a.exp_date "+
	 				  "and b.offer_type = '10' and a.state = 'A' and a.serv_id = to_number('"+OldId+"')	";
%>
		<wtc:pubselect name="sPubSelect" routerKey="region" 
			 routerValue="<%=regionCode%>" outnum="2">
    <wtc:sql><%=sqlStrk%></wtc:sql>
		</wtc:pubselect>
		<wtc:array id="result" scope="end"/>
<%
	if(result!=null&&result.length>0){
		main_str1 = result[0][0];
	}
	
	String anzhcontactName="";
	String anzhcontactPhone="";
%>
<%
		/* add for �Ƿ�Ϊ����������� 1���� @2014/11/19  */
		String workChnFlag = "0" ;
%>	
		<wtc:service name="s1100Check" outnum="30"
			routerKey="region" routerValue="<%=regionCode%>" retcode="rc" retmsg="rm" >
			<wtc:param value = ""/>
			<wtc:param value = "01"/>
			<wtc:param value = "<%=opCode%>"/>
			<wtc:param value = "<%=workNo%>"/>
			<wtc:param value = "<%=loginPwd%>"/>
				
			<wtc:param value = ""/>
			<wtc:param value = ""/>
		</wtc:service>
		<wtc:array id="rst" scope="end" />
<%

if ( rc.equals("000000") )
{
	if ( rst.length!=0 )
	{
		workChnFlag = rst[0][0];
	}
	else
	{
	%>
		<script>
			rdShowMessageDialog( "����s1100Checkû�з��ؽ��!" );
			removeCurrentTab();
		</script>
	<%	
	}
}
else
{
%>
	<script>
		rdShowMessageDialog( "<%=rc%>:<%=rm%>" );
		removeCurrentTab();
	</script>
<%
}

    /*������ʵ����ڿ�������BOSS�Ż���������������ñ�start*/
    String sql_appregionset1 = "select count(*) from sOrderCheck where group_id=:groupids and flag='Y' ";
    String sql_appregionset2 = "groupids="+groupId;
    String appregionflag="0";//==0ֻ�ܽ��й�����ѯ��>0���Խ��й�����ѯ���߶���
    System.out.println(sql_appregionset1+"------------"+sql_appregionset2);
 %>
 		<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCodeappregion" retmsg="retMsgappregion" outnum="1"> 
			<wtc:param value="<%=sql_appregionset1%>"/>
			<wtc:param value="<%=sql_appregionset2%>"/>
		</wtc:service>  
		<wtc:array id="appregionarry"  scope="end"/>
<%
	System.out.println("appregionarry==length===="+appregionarry.length);
			if("000000".equals(retCodeappregion)){
				if(appregionarry.length > 0){
					appregionflag = appregionarry[0][0]; 
					System.out.println("appregionarry[0][0]======"+appregionarry[0][0]);
				}
		}
		System.out.println("appregionflag======"+appregionflag);
		/*������ʵ����ڿ�������BOSS�Ż���������������ñ�end*/
		String sql_sendListOpenFlag = "select count(*) from shighlogin where login_no='K' and op_code='m194'";
		String sendListOpenFlag = "0"; //�·��������� 0���أ�>0����
%>
		<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode1" retmsg="retMsg1" outnum="1"> 
			<wtc:param value="<%=sql_sendListOpenFlag%>"/>
		</wtc:service>  
		<wtc:array id="ret1"  scope="end"/>
<%
		if("000000".equals(retCode1)){
			if(ret1.length > 0){
				sendListOpenFlag = ret1[0][0]; 
			}
		}
		
		String  sql_regionCodeFlag [] = new String[2];
		sql_regionCodeFlag[0] = "select count(*) from shighlogin where op_code ='m195' and login_no=:regincode";
		sql_regionCodeFlag[1] = "regincode="+regionCode;
		String regionCodeFlag = "N"; //�����Ƿ�ɼ� �·�������ť Y�ɼ���N���ɼ�
%>
		<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode2" retmsg="retMsg2" outnum="1"> 
			<wtc:param value="<%=sql_regionCodeFlag[0]%>"/>
			<wtc:param value="<%=sql_regionCodeFlag[1]%>"/>
		</wtc:service>  
		<wtc:array id="ret2"  scope="end"/>
<%
		if("000000".equals(retCode2)){
			if(ret2.length > 0){
				if(Integer.parseInt(ret2[0][0]) > 0){
					regionCodeFlag = "Y"; 
				}
			}
		}
%>



<html>
<head>
	<title>��������</title>
	<script language="javascript">
		var v_printAccept;
		
		$(document).ready(function(){
			getUserBaseInfo();
			getCustId();
			getIdTypes();
			reSetCustName();
			/*�������������е�����*/
			v_printAccept = "<%=loginAccept%>";
			
		});
		function jtrim(str){
			return str.replace( /^\s*/, "" ).replace( /\s*$/, "" );
    }
		function getUserBaseInfo(){
			/*��ȡ�û���Ϣ*/
			var getdataPacket = new AJAXPacket("/npage/public/pubGetUserBaseInfo.jsp","���ڻ�����ݣ����Ժ�......");
			getdataPacket.data.add("phoneNo","<%=phoneNo%>");
			getdataPacket.data.add("opCode","<%=opCode%>");
			core.ajax.sendPacket(getdataPacket,doGetPrypayBack);
			getdataPacket = null;
		}
		function doGetPrypayBack(packet){
			var retCode = packet.data.findValueByName("retcode");
			var retMsg = packet.data.findValueByName("retmsg");
			var contactPhone = packet.data.findValueByName("stPMcontact_phone");
			var contactPerson = packet.data.findValueByName("stPMcontact_person");
			$("#contactPhone").text(contactPhone);
			$("#contactPerson").text(contactPerson);
		}
		function getCustId(){
			var getUserId_Packet = new AJAXPacket("/npage/s1210/s1238_getID.jsp","���ڻ���¿ͻ�ID�����Ժ�......");
			getUserId_Packet.data.add("retType","getID");
			getUserId_Packet.data.add("region_code","<%=regionCode%>");
			getUserId_Packet.data.add("idType","0");
			getUserId_Packet.data.add("oldId","0");
			core.ajax.sendPacket(getUserId_Packet,doGetCustIdBack);
			getUserId_Packet = null;
		}
		function doGetCustIdBack(packet){
			var retCode = packet.data.findValueByName("retCode");
			var retMsg = packet.data.findValueByName("retMessage");
			var retnewId = packet.data.findValueByName("retnewId");
			if(retCode == "000000"){
				$("#new_cus_id").val(retnewId);
				$("#custId").val(retnewId);
			}else{
				rdShowMessageDialog(retCode + ":" + retMsg);
				removeCurrentTab();
			}
		}
		function checkXi(){
			if(frm.xinYiDu.value>0){
				rdShowMessageDialog("�����Ȳ��ܴ����㣡");
				return;
			}
		}
		function reSetCustName(){/*���ÿͻ�����*/
			document.all.custName.value="";
			document.all.newContactPerson.value="";
			getIdTypes();
			var checkVal = $("select[name='isJSX']").find("option:selected").val();
			
			if(checkVal == 1){
			  	$("#gestoresInfo1").show();
			  	$("#gestoresInfo2").show();
			  	$("#realUserInfo1").show();
			  	$("#realUserInfo2").show();
			  	$("#sendProjectList").hide(); //�·�������ť
					$("#qryListResultBut").hide(); //���������ѯ��ť
			  	
			  	/*����������*/
			  	document.all.gestoresName.v_must = "1";
			  	/*�����˵�ַ*/
			  	document.all.gestoresAddr.v_must = "1";
			  	/*������֤������*/
			  	document.all.gestoresIccId.v_must = "1";
			  	var checkIdType = $("select[name='gestoresIdType']").find("option:selected").val();
			  	/*����֤����У�鷽��*/
			  	if(checkIdType.indexOf("����֤") != -1){
			  		document.all.gestoresIccId.v_type = "idcard";
			  		$("#scan_idCard_two3").css("display","");
			  		$("#scan_idCard_two31").css("display","");
			  		$("input[name='gestoresName']").attr("class","InputGrey");
			  		$("input[name='gestoresName']").attr("readonly","readonly");
			  		$("input[name='gestoresAddr']").attr("class","InputGrey");
			  		$("input[name='gestoresAddr']").attr("readonly","readonly");
			  		$("input[name='gestoresIccId']").attr("class","InputGrey");
			  		$("input[name='gestoresIccId']").attr("readonly","readonly");
			  	}else{
			  		document.all.gestoresIccId.v_type = "string";
			  		$("#scan_idCard_two3").css("display","none");
			  		$("#scan_idCard_two31").css("display","none");
			  		$("input[name='gestoresName']").removeAttr("class");
			  		$("input[name='gestoresName']").removeAttr("readonly");
			  		$("input[name='gestoresAddr']").removeAttr("class");
			  		$("input[name='gestoresAddr']").removeAttr("readonly");
			  		$("input[name='gestoresIccId']").removeAttr("class");
			  		$("input[name='gestoresIccId']").removeAttr("readonly");
			  	}
			  	
			  	//��������Ϣ
			  	$("#responsibleInfo1").show();
			  	$("#responsibleInfo2").show();
			
			  	/*������������*/
			  	document.all.responsibleName.v_must = "1";
			  	/*�������˵�ַ*/
			  	document.all.responsibleAddr.v_must = "1";
			  	/*����������֤������*/
			  	document.all.responsibleIccId.v_must = "1";
			  	var checkIdType22 = $("select[name='responsibleType']").find("option:selected").val();
			  	/*����֤����У�鷽��*/
			  	if(checkIdType22.indexOf("����֤") != -1){
			  		document.all.responsibleIccId.v_type = "idcard";
			  		$("#scan_idCard_two3zrr").css("display","");
			  		$("#scan_idCard_two57zrr").css("display","");
			  		$("input[name='responsibleName']").attr("class","InputGrey");
			  		$("input[name='responsibleName']").attr("readonly","readonly");
			  		$("input[name='responsibleAddr']").attr("class","InputGrey");
			  		$("input[name='responsibleAddr']").attr("readonly","readonly");
			  		$("input[name='responsibleIccId']").attr("class","InputGrey");
			  		$("input[name='responsibleIccId']").attr("readonly","readonly");  		
			  		
			  	}else{
			  		document.all.responsibleIccId.v_type = "string";
			  		$("#scan_idCard_two3zrr").css("display","none");
			  		$("#scan_idCard_two57zrr").css("display","none");
			  		$("input[name='responsibleName']").removeAttr("class");
			  		$("input[name='responsibleName']").removeAttr("readonly");
			  		$("input[name='responsibleAddr']").removeAttr("class");
			  		$("input[name='responsibleAddr']").removeAttr("readonly");
			  		$("input[name='responsibleIccId']").removeAttr("class");
			  		$("input[name='responsibleIccId']").removeAttr("readonly");  		
			  		
			  	}  	
			  	
			  	/*ʵ��ʹ������Ϣ ����*/
			  	/*ʵ��ʹ��������*/
			  	document.all.realUserName.v_must = "1";
			  	/*��ʵ��ʹ���˵�ַ*/
			  	document.all.realUserAddr.v_must = "1";
			  	/*ʵ��ʹ����֤������*/
			  	document.all.realUserIccId.v_must = "1";
			  	
			  	$("#realUserInfo1").find("td:eq(0)").attr("width","13%");
			  	$("#realUserInfo1").find("td:eq(0)").attr("nowrap","nowrap");
			  	$("#realUserInfo1").find("td:eq(1)").attr("nowrap","nowrap");
			  	$("#realUserInfo1").find("td:eq(2)").attr("width","13%");
			  	$("#realUserInfo1").find("td:eq(2)").attr("nowrap","nowrap");
			  	$("#realUserInfo1").find("td:eq(3)").attr("nowrap","nowrap");
			  	$("#realUserInfo1").find("td:eq(3)").attr("colSpan","3");
			  	
			  	$("#realUserInfo2").find("td:eq(0)").attr("width","13%");
			  	$("#realUserInfo2").find("td:eq(0)").attr("nowrap","nowrap");
			  	$("#realUserInfo2").find("td:eq(1)").attr("nowrap","nowrap");
			  	$("#realUserInfo2").find("td:eq(2)").attr("width","13%");
			  	$("#realUserInfo2").find("td:eq(2)").attr("nowrap","nowrap");
			  	$("#realUserInfo2").find("td:eq(3)").attr("nowrap","nowrap");
			  	$("#realUserInfo2").find("td:eq(3)").attr("colSpan","3");
			  	
			  	
  	
	  	
  	
  		}
			  /*ûѡ��λ�ͻ���ʱ�򣬾���չʾ������Ϊ����Ҫ����ѡ��*/
			  else{
			  	
			  	/* begin add �� 1238+��ͨ����+����֤+�����������+����+��չ���У�����ʾ���·���������ť for ���ڵ绰�û�ʵ���Ǽǽ����ص㹤����֪ͨ @2014/11/4 */
	  if(checkVal == 0){
			var idTypeSelect = $("#idTypeSelect option[@selected]").val();//֤�����ͣ�����֤
			
			if(idTypeSelect.indexOf("|") != -1){
				var v_idTypeSelect = idTypeSelect.split("|")[0];
				if(v_idTypeSelect == "0" && "<%=workChnFlag%>" == "1" && "<%=opCode%>" == "e972" && (parseInt($("#sendListOpenFlag").val()) > 0) && "<%=regionCodeFlag%>" == "Y"){ 
					$("#sendProjectList").show();
					$("#qryListResultBut").show();
				}else{
					$("#sendProjectList").hide();
					$("#qryListResultBut").hide();
				}
			}
			
	  }
	  
			  	$("#gestoresInfo1").hide();
			  	$("#gestoresInfo2").hide();
			  	$("#realUserInfo1").hide();
			  	$("#realUserInfo2").hide();
			  	/*����������*/
			  	document.all.gestoresName.v_must = "0";
			  	/*�����˵�ַ*/
			  	document.all.gestoresAddr.v_must = "0";
			  	/*������֤������*/
			  	document.all.gestoresIccId.v_must = "0";
			  	
			  	//��������Ϣ
			  	$("#responsibleInfo1").hide();
			  	$("#responsibleInfo2").hide();
			
			  	/*������������*/
			  	document.all.responsibleName.v_must = "0";
			  	/*�������˵�ַ*/
			  	document.all.responsibleAddr.v_must = "0";
			  	/*����������֤������*/
			  	document.all.responsibleIccId.v_must = "0";  
			  	
			  	/*ʵ��ʹ��������*/
			  	document.all.realUserName.v_must = "0";
			  	/*��ʵ��ʹ���˵�ַ*/
			  	document.all.realUserAddr.v_must = "0";
			  	/*ʵ��ʹ����֤������*/
			  	document.all.realUserIccId.v_must = "0"; 	
			  	
			  }
			
			
		}
		function change_ConPerson(){
			//��ϵ��������ͻ����Ƹ������ı�
			document.all.newContactPerson.value = document.all.custName.value;
		}
		function feifaCustName(textName){
			if(textName.value != "")
			{
				if(document.all.isJSX.value=="0"){
					var m = /^[\u0391-\uFFE5]+$/;
					var flag = m.test(textName.value);
					if(!flag){
						rdShowMessageDialog("ֻ�����������ģ�");
						reSetCustName();
					}
					if(textName.value.length > 6){
						rdShowMessageDialog("ֻ��������6�����֣�");
						reSetCustName();
					}
				}else{
					if((textName.value.indexOf("~")) != -1 || (textName.value.indexOf("|")) != -1 || (textName.value.indexOf(";")) != -1)
					{
						rdShowMessageDialog("����������Ƿ��ַ������˿���������ѡ������ſ�����");
						textName.value = "";
			 	  		return;
					}
				}
			}
		}
		function change_idType(){
		
			/*2016/2/29 11:04:27 gaopeng 
				1�������˿������ࡱ��Ϊ����ͨ�ͻ����͡���λ�ͻ�����--ok
				2�������˿������ࡱΪ��ͨ�ͻ�����֤������ֻ���Կ�������֤�����ڲ����۰�ͨ��֤������֤��̨��ͨ��֤����������պ�����֤��--ok
				   �����˿������ࡱΪ��λ�ͻ�����֤������ֻ���Կ���Ӫҵִ�ա���֯�������롢��λ����֤�顢��λ֤����
				3�����֤������������֤���򽫡�ɨ��һ������֤��ɾ����
					ͬʱ���ӡ�����(2��)�������롰GSM����(1238)��һ�¡�
				4�����֤������������֤����ͻ����ơ�֤�������֤����ַ�������޸ġ�
					���֤����ַ����60���ֽڣ�ϵͳ�Զ���ȡǰ60���ֽڴ�(��Ϊdcustdoc��֤����ַ��֧��60���ֽ�)��
				5�����֤��������Ӫҵִ�ա���֯�������롢��λ����֤��͵�λ֤������������Ӿ����ˡ������˺�ʵ��ʹ������Ϣ(������ͼ)��
					ϵͳ��Ҫ����������Ϣ�������ĺϷ���У�顣����û�����������Ϣ����Ĭ��չʾ�������޸ġ����û�У��������д�����롰GSM����(1238)��һ�¡�
				6��ϵͳ��Ҫ�ԡ���������(e972)�����������֤����Ϣ����ϵ����Ϣ���ͻ���Ϣ�����Ϸ���У�飬���롰GSM����(1238)��һ�¡�
				
				
				
			*/
			var Str = document.all.idType.value;
			if(Str.indexOf("0") > -1||Str.indexOf("D") > -1){
				document.all.idIccid.v_type = "idcard";  
				document.all("card_id_type").style.display="";
				document.all("read_idCard_one").style.display="none";
				/*
				���֤������������֤����ͻ����ơ�֤�������֤����ַ�������޸ġ�
				���֤����ַ����60���ֽڣ�
				ϵͳ�Զ���ȡǰ60���ֽڴ�(��Ϊdcustdoc��֤����ַ��֧��60���ֽ�)��
				*/
				var checkVal = document.all.isJSX.value;//���˿������� ��ͨ�ͻ���0
				if(checkVal == "0" && "<%=workChnFlag%>" == "1" && "<%=opCode%>" == "e972" && (parseInt($("#sendListOpenFlag").val()) > 0) && "<%=regionCodeFlag%>" == "Y"){
					$("#sendProjectList").show();
					$("#qryListResultBut").show();
				}else{
					$("#sendProjectList").hide();
					$("#qryListResultBut").hide();
				}
				$("#idIccid").attr("class","InputGrey");
				$("#idIccid").attr("readonly","readonly");
				$("#custName").attr("class","InputGrey");
				$("#custName").attr("readonly","readonly");
				$("#idAddr").attr("class","InputGrey");
				$("#idAddr").attr("readonly","readonly");
				
			}
			else{
				$("#sendProjectList").hide();
					$("#qryListResultBut").hide();
				document.all.idIccid.v_type = "string";   
				document.all("card_id_type").style.display="none";
				document.all("read_idCard_one").style.display="";
				$("#idIccid").removeAttr("class");
				$("#idIccid").removeAttr("readonly");
				$("#custName").removeAttr("class");
				$("#custName").removeAttr("readonly");
				$("#idAddr").removeAttr("class");
				$("#idAddr").removeAttr("readonly");
			}
			




		}
		function getInfo_IccId_JustSee(){
			//���ݿͻ�֤������õ������Ϣ
			if(jtrim(document.frm.idIccid.value).length == 0)
			{
				rdShowMessageDialog("������ͻ�֤�����룡");
				return false;
			}else if(jtrim(document.frm.idIccid.value).length < 5){
				rdShowMessageDialog("֤�����볤������������λ����");
				return false;
			}
			var pageTitle = "�ͻ���Ϣ��ѯ";
			var fieldName = "�ֻ�����|����ʱ��|֤������|֤������|������|״̬|";
			var sqlStr = "select c.phone_no,to_char(a.CREATE_TIME,'YYYY-MM-DD HH24:MI:SS'),b.ID_NAME,a.ID_ICCID," +
			       " trim(e.REGION_NAME)||'-->'||trim(f.DISTRICT_NAME)," +
			       " d.run_name from DCUSTDOC a,SIDTYPE b ,DCustMsg c ,sRuncode d ,sregioncode e,sdiscode f where a.region_code=d.region_code and substr(c.run_code,2,1)=d.run_code and  a.cust_id=c.cust_id and b.ID_TYPE = a.ID_TYPE " +
			       " and a.region_code=e.region_code and a.region_code=f.region_code and a.district_code=f.district_code and  a.ID_ICCID = '" + document.frm.idIccid.value + "' and substr(c.run_code,2,1)<'a'  and rownum<500 order by a.cust_name asc,a.create_time desc ";
			var selType = "S";    //'S'��ѡ��'M'��ѡ
			var retQuence = "7|0|1|3|4|5|6|7|";
			var retToField = "in0|in4|in3|in2|in5|in6|in1|";
			custInfoQueryJustSee(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
		}
		function custInfoQueryJustSee(pageTitle,fieldName,sqlStr,selType,retQuence,retToField){
		    /*
		    ����1(pageTitle)����ѯҳ�����
		    ����2(fieldName)�����������ƣ���'|'�ָ��Ĵ�
		    ����3(sqlStr)��sql���
		    ����4(selType)������1 rediobutton 2 checkbox
		    ����5(retQuence)����������Ϣ������������� �������ʶ����'|'�ָ�����"3|0|2|3"��ʾ����3����0��2��3
		    ����6(retToField))������ֵ����������,��'|'�ָ�
		    */
		var custnamess=document.all.custName.value.trim();
		var idTypesss="";
		var idTypeSelect = $("#idTypeSelect option[@selected]").val();//֤������
		if(idTypeSelect.indexOf("|") != -1){
			  idTypesss = idTypeSelect.split("|")[0];
			  if(idTypesss=="0") {//����֤
				    if(custnamess.len() == 0)
				    {
				        //rdShowMessageDialog("������ͻ����ƺ��ٽ�����Ϣ��ѯ��");
				        //return false;
				    }
			   }   
    }

    var path = "/npage/sq100/getPhoneNumInner.jsp";
    path = path + "?idIccid=" + document.all.idIccid.value.trim()+"&idtype="+idTypesss+"&custnames="+custnamess+"&opcode=e972";
    window.showModalDialog(path,"","dialogWidth:30;dialogHeight:15;");
    
		}
		function chcek_pic1121(){
			var pic_path = document.all.filep.value;
			var d_num = pic_path.indexOf("\.");
			var file_type = pic_path.substring(d_num+1,pic_path.length);
			//�ж��Ƿ�Ϊjpg���� //�����豸����ͼƬ�̶�Ϊjpg����
			if(file_type.toUpperCase()!="JPG"){ 
				rdShowMessageDialog("��ѡ��jpg����ͼ���ļ�");
				document.all.up_flag.value=3;
				//document.all.print.disabled=true;
				resetfilp();
				return ;
			}
			
			var pic_path_flag= document.all.pic_name.value;
			
			if(pic_path_flag==""){
				rdShowMessageDialog("����ɨ����ȡ֤����Ϣ");
				document.all.up_flag.value=4;
				//document.all.print.disabled=true;
				resetfilp();
				return;
			}
			else{
				if(pic_path!=pic_path_flag){
					rdShowMessageDialog("��ѡ�����һ��ɨ����ȡ֤�������ɵ�֤��ͼ���ļ�"+pic_path_flag);
					document.all.up_flag.value=5;
					//document.all.print.disabled=true;
					resetfilp();
					return;
				}
				else{
					document.all.up_flag.value=2;
					document.all.uploadpic_b.disabled=false;//����֤
				}
			}
		}
		function resetfilp(){//����֤
			document.getElementById("filep").outerHTML = document.getElementById("filep").outerHTML;
		}
		function changeCardAddr(obj){
			document.all.custAddr.value=obj.value;
			document.all.contactAddr.value=obj.value;
			document.all.contactMAddr.value=obj.value;
		}
		function uploadpic(){//����֤
			if(document.all.filep.value==""){
				rdShowMessageDialog("��ѡ��Ҫ�ϴ���ͼƬ",0);
				return;
			}
			if(document.all.but_flag.value=="0"){
				rdShowMessageDialog("����ɨ����ȡͼƬ",0);
				return;
			}
			frm.target="upload_frame"; 
			document.frm.encoding="multipart/form-data";
			var actionstr ="/npage/s1210/s1238Main_uppic.jsp?custId="+document.frm.custId.value+
										"&regionCode="+document.frm.regionCode.value+
										"&filep_j="+document.all.filep.value+
										"&card_flag="+document.all.card_flag.value+ 
										"&but_flag="+document.all.but_flag.value+
										"&idSexH="+document.all.idSexH.value+
										"&custName="+document.all.custName.value+
										"&idAddrH="+document.all.idAddrH.value.replace(new RegExp("#","gm"),"%23")+
										"&birthDayH="+document.all.birthDayH.value+
										"&custId="+document.all.custId.value+
										"&idIccid="+document.all.idIccid.value+
										"&workno="+document.all.workno.value+
										"&zhengjianyxq="+document.all.idValidDate.value+
										"&upflag=1";
										
			frm.action = actionstr; 
			document.all.upbut_flag.value="1";
			frm.submit();
			resetfilp();
			document.frm.encoding="application/x-www-form-urlencoded";
			
		}
		function chkValid(){
			 var d= (new Date().getFullYear().toString()+(((new Date().getMonth()+1).toString().length>=2)?(new Date().getMonth()+1).toString():("0"+(new Date().getMonth()+1)))+(((new Date().getDate()).toString().length>=2)?(new Date().getDate()):("0"+(new Date().getDate()))).toString());
	
			 if(jtrim(document.all.idValidDate.value).length>0)
			 {
				if(forDate(document.all.idValidDate)==false) return false;
	
				if(to_date(document.all.idValidDate)<=d)
				{
				  rdShowMessageDialog("֤����Ч�ڲ������ڵ�ǰʱ�䣬���������룡");
				  document.all.idValidDate.focus();
				  document.all.idValidDate.select();
				  return false;
				}
			}
		}
		function feifa(textName)
		{
			if(textName.value != "")
			{
				if((textName.value.indexOf("~")) != -1 || (textName.value.indexOf("|")) != -1 || (textName.value.indexOf(";")) != -1)
				{
					rdShowMessageDialog("����������Ƿ��ַ������������룡");
					textName.value = "";
		 	  		return;
				}
			}
		}
		function chkPwdEasy1(pwd){
			if(pwd == ""){
				rdShowMessageDialog("�����������룡");
				return ;
			}
			var checkPwd_Packet = new AJAXPacket("../public/pubCheckPwdEasy.jsp","������֤�����Ƿ���ڼ򵥣����Ժ�......");
			checkPwd_Packet.data.add("password", pwd);
			checkPwd_Packet.data.add("phoneNo", "<%=phoneNo%>");
			checkPwd_Packet.data.add("idNo", frm.idIccid.value);
			checkPwd_Packet.data.add("opCode", "e972");
			checkPwd_Packet.data.add("custId", "");
		
			core.ajax.sendPacket(checkPwd_Packet, doCheckPwdEasy1);
			checkPwd_Packet=null;
		}
		function doCheckPwdEasy1(packet) {
			var retResult = packet.data.findValueByName("retResult");
			if (retResult == "1") {
				rdShowMessageDialog("�𾴵Ŀͻ������������õ�����Ϊ��ͬ���������룬��ȫ�Խϵͣ�Ϊ�˸��õر���������Ϣ��ȫ���������ð�ȫ�Ը��ߵ����롣");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "2") {
				rdShowMessageDialog("�𾴵Ŀͻ������������õ�����Ϊ���������룬��ȫ�Խϵͣ�Ϊ�˸��õر���������Ϣ��ȫ���������ð�ȫ�Ը��ߵ����롣");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "3") {
				rdShowMessageDialog("�𾴵Ŀͻ������������õ�����Ϊ�ֻ������е��������֣���ȫ�Խϵͣ�Ϊ�˸��õر���������Ϣ��ȫ���������ð�ȫ�Ը��ߵ����롣");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "4") {
				rdShowMessageDialog("�𾴵Ŀͻ������������õ�����Ϊ֤���е��������֣���ȫ�Խϵͣ�Ϊ�˸��õر���������Ϣ��ȫ���������ð�ȫ�Ը��ߵ����롣");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "0") {
				//rdShowMessageDialog("У��ɹ���������ã�");
			}
		}
		function ChkHandFee(){
			if(jtrim(document.all.oriHandFee.value).length>=1 && jtrim(document.all.t_handFee.value).length>=1){
				if(parseFloat(document.all.oriHandFee.value)<parseFloat(document.all.t_handFee.value)){
					rdShowMessageDialog("ʵ�������Ѳ��ܴ���ԭʼ�����ѣ�");
					document.all.t_handFee.value=document.all.oriHandFee.value;
					document.all.t_handFee.select();
					document.all.t_handFee.focus();
					return;
				}
			}
			
			if(jtrim(document.all.oriHandFee.value).length>=1 && jtrim(document.all.t_handFee.value).length==0){
				document.all.t_handFee.value="0";
			}
		 }
		 function getFew(){
				var fee=document.all.t_handFee;
				var fact=document.all.t_factFee;
				var few=document.all.t_fewFee;
				if(jtrim(fact.value).length==0){
					rdShowMessageDialog("ʵ�ս���Ϊ�գ�");
					fact.value="";
					fact.focus();
					return;
				}
				if(parseFloat(fact.value)<parseFloat(fee.value)){
					rdShowMessageDialog("ʵ�ս��㣡");
					fact.value="";
					fact.focus();
					return;
				}
				
				var tem1=((parseFloat(fact.value)-parseFloat(fee.value))*100+0.5).toString();
				var tem2=tem1;
				if(tem1.indexOf(".")!=-1) tem2=tem1.substring(0,tem1.indexOf("."));
				few.value=(tem2/100).toString();
				few.focus();
		 }
		 function printCommit(){


	 	    	
	/*
	 *  1���޸������漰�����ˡ������˺�ʵ��ʹ���˵Ľ��棬��ϵͳ�������ƣ�����λ֤������ʱ��
	 *  ��������ʵ��ʹ���˵�֤�����벻������ͬ���������������˵�֤�����벻������ͬ��
	 */

	var idTypeSelect_isC = $("#idTypeSelect option:selected").val();//֤������ 
	//alert("1 idTypeSelect_isC=["+idTypeSelect_isC+"]");
	if(typeof(idTypeSelect_isC)=="undefined"){
		//�л�֤�����ͺ� selected �Ķ�ʧĬ��ȡ��һ��
		idTypeSelect_isC =  $("#idTypeSelect option:eq(0)").val();
	}
	
	//alert("2 idTypeSelect_isC=["+idTypeSelect_isC+"]");
	if(
	   idTypeSelect_isC.indexOf("8")!=-1||
	   idTypeSelect_isC.indexOf("A")!=-1||
	   idTypeSelect_isC.indexOf("B")!=-1||
	   idTypeSelect_isC.indexOf("C")!=-1){
		//alert("��λ֤������");
		//��λ֤������
		if(typeof($("#gestoresIccId").val())!="undefined"&&typeof($("#responsibleIccId").val())!="undefined"){
			if($("#gestoresIccId").val().trim()!=""&&$("#responsibleIccId").val().trim()!=""){
				if($("#gestoresIccId").val().trim()==$("#responsibleIccId").val().trim()){
					rdShowMessageDialog("�����˵�֤�������������˵�֤�����벻������ͬ!",0);
					return;
				}
			}
		}
		
		if(typeof($("#gestoresIccId").val())!="undefined"&&typeof($("#realUserIccId").val())!="undefined"){
			if($("#gestoresIccId").val().trim()!=""&&$("#realUserIccId").val().trim()!=""){
				if($("#gestoresIccId").val().trim()==$("#realUserIccId").val().trim()){
					rdShowMessageDialog("�����˵�֤��������ʹ���˵�֤�����벻������ͬ!",0);
					return;
				}  		
			}
		}
		
	}   	
    		
	
	
		 			var checkVal = document.all.isJSX.value;//���˿������� ��ͨ�ͻ���0
					var idTypeSelect = $("#idTypeSelect option[@selected]").val();//֤�����ͣ�����֤
					if(idTypeSelect.indexOf("|") != -1){
						var v_idTypeSelect = idTypeSelect.split("|")[0];
						
						if(checkVal == "0" && v_idTypeSelect == "0" && "<%=workChnFlag%>" == "1" && "<%=regionCodeFlag%>" == "Y"){ 
							if("<%=appregionflag%>"=="0") {//�������app���ñ�����ֻ�ܽ��й�����ѯ��
								if(($("#isQryListResultFlag").val() == "N") && (parseInt($("#sendListOpenFlag").val()) > 0)){ //�Ѳ�ѯ�����б������·���������Ϊ���������У��
									rdShowMessageDialog("���Ƚ��й��������ѯ���ٽ��й���!");
							    return false;		
								}
							}
						}
					}
		 	
		 		/*2016/2/29 14:26:25 gaopeng ����У��*/
    		/*�ͻ�����*/
    		if(!checkCustNameFunc16New(document.all.custName,0,1)){
    			return false;
    		}
    		/*��ϵ������*/
    		if(!checkCustNameFunc(document.all.contactPerson,1,1)){
					return false;
				}
				/*֤����ַ*/
				if(!checkAddrFunc(document.all.idAddr,0,1)){
					return false;
				}
				/*�ͻ���ַ*/
				if(!checkAddrFunc(document.all.custAddr,1,1)){
					return false;
				}
				/*��ϵ�˵�ַ*/
				if(!checkAddrFunc(document.all.contactAddr,2,1)){
					return false;
				}
				/*��ϵ��ͨѶ��ַ*/
				if(!checkAddrFunc(document.all.contactMAddr,3,1)){
					return false;
				}
				/*֤������*/
				if(!checkIccIdFunc16New(document.all.idIccid,0,1)){
					return false;
				}
				else{
					rpc_chkX('idType','idIccid','A');
				}
				
				/*gaopeng 20131216 2013/12/16 19:50:11 ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭������Ϣȷ�Ϸ���ǰУ�� start*/
					if(!checkElement(document.all.gestoresName)){
						return false;
					}
					if(!checkElement(document.all.gestoresAddr)){
						return false;
					}
					if(!checkElement(document.all.gestoresIccId)){
						return false;
					}
					/*����������*/
					if(!checkCustNameFunc16New(document.all.gestoresName,1,1)){
						return false;
					}
					/*��������ϵ��ַ*/
					if(!checkAddrFunc(document.all.gestoresAddr,4,1)){
						return false;
					}
					/*������֤������*/
					if(!checkIccIdFunc16New(document.all.gestoresIccId,1,1)){
						return false;
					}
					else{
						rpc_chkX('idType','idIccid','A');
					}
					/*����������*/
				if(!checkElement(document.all.responsibleName)){
					return false;
				}
				/*��������ϵ��ַ*/
				if(!checkElement(document.all.responsibleAddr)){
					return false;
				}
				/*������֤������*/
				if(!checkElement(document.all.responsibleIccId)){
					return false;
				}
				
				if(!checkCustNameFunc16New(document.all.responsibleName,2,1)){
					return false;
				}
			
				if(!checkAddrFunc(document.all.responsibleAddr,5,1)){
							return false;
				}
			
				if(!checkIccIdFunc16New(document.all.responsibleIccId,2,1)){
									return false;
				}
				else{
					rpc_chkX('idType','idIccid','A');
				}
				
					/*ʵ��ʹ��������*/
					if(!checkElement(document.all.realUserName)){
						return false;
					}
					/*ʵ��ʹ������ϵ��ַ*/
					if(!checkElement(document.all.realUserAddr)){
						return false;
					}
					/*ʵ��ʹ����֤������*/
					if(!checkElement(document.all.realUserIccId)){
						return false;
					}
			  if(!checkCustNameFunc16New(document.all.realUserName,3,1)){
					return false;
				}
			
				if(!checkAddrFuncNew(document.all.realUserAddr,5,1)){
							return false;
					}
			
				if(!checkIccIdFunc16New(document.all.realUserIccId,3,1)){
									return false;
				}
				else{
					rpc_chkX('idType','idIccid','A');
				}
				
		 	getAfterPrompt();
			showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes");
		 }
		 function showPrtDlg(printType,DlgMessage,submitCfm){
			//----------------------add by huy 20050722
			if(jtrim(document.all.xinYiDu.value).length==0){
				rdShowMessageDialog(document.all.xinYiDu.v_name+"����Ϊ�գ�");
				document.all.xinYiDu.focus();
				return false;
			}
				if(jtrim(document.all.custPwd.value).length==0){
					/*rdShowMessageDialog(document.all.custPwd.v_name+"����Ϊ�գ�");
					document.all.custPwd.focus();
					return false;*/
				}else{
					if(jtrim(document.all.custPwd.value).length!=6){
						rdShowMessageDialog(document.all.custPwd.v_name+"��������");
						document.all.custPwd.focus();
						return false;
					}
				}
				if(jtrim(document.all.newContactPerson.value).length==0){
					rdShowMessageDialog(document.all.newContactPerson.v_name+"����Ϊ�գ�");
					document.all.newContactPerson.focus();
					return false;
				}				
				if(jtrim(document.all.newContactPhone.value).length==0){
					rdShowMessageDialog(document.all.newContactPhone.v_name+"����Ϊ�գ�");
					document.all.newContactPhone.focus();
					return false;
				}else {
					/*��ϵ�绰������*/
					var newContactPhoness = document.all.newContactPhone.value;
					if(newContactPhoness != ""){
						m = /^[0-9]+$/;
						var flag = m.test(newContactPhoness);
						if(!flag){
							rdShowMessageDialog("��ϵ�˵绰ֻ������������");
							return false;
						}
					}
				}
				
				
				change_idType();   //�жϿͻ�֤�������Ƿ�������֤
				if(jtrim(document.all.contactMail.value) == ""){
					document.all.contactMail.value = "";
				}
				//�ж����ա�֤����Ч����Ч��	birthDay	idValidDate
				if((typeof(document.all.birthDay)!="undefined") &&
					(document.all.birthDay.value != "")){
					if(forDate(document.all.birthDay) == false){	
						return false;
					}
				}else if((typeof(document.all.yzrq)!="undefined")&&
							(document.all.yzrq.value != "")){
					if(forDate(document.all.yzrq) == false){	return false;		}
				}
				
				var d= (new Date().getFullYear().toString()+(((new Date().getMonth()+1).toString().length>=2)?(new Date().getMonth()+1).toString():("0"+(new Date().getMonth()+1)))+(((new Date().getDate()).toString().length>=2)?(new Date().getDate()):("0"+(new Date().getDate()))).toString());
				
				if(jtrim(document.all.idValidDate.value).length>0){
					if(forDate(document.all.idValidDate)==false) return false;
					if(to_date(document.all.idValidDate)<=d){
						rdShowMessageDialog("֤����Ч�ڲ������ڵ�ǰʱ�䣬���������룡");
						document.all.idValidDate.focus();
						document.all.idValidDate.select();
						return false;
					}
				}
				
				if(jtrim(document.all.birthDay.value).length>0){
					if(to_date(document.all.birthDay)>=d){
						rdShowMessageDialog("���������ڲ������ڵ�ǰʱ�䣬���������룡");
						document.all.birthDay.focus();
						document.all.birthDay.select();
						return false;
					}
				}
			if((document.all.but_flag.value =="1")&&document.all.upbut_flag.value=="0"){//����֤
				rdShowMessageDialog("�����ϴ�����֤��Ƭ",0);
				return false;
			}
			
			var upflag =document.all.up_flag.value;//����֤
			if(upflag==3&&(document.all.but_flag.value =="1")){
				rdShowMessageDialog("��ѡ��jpg����ͼ���ļ�");
				return false;
			}
			if(upflag==4&&(document.all.but_flag.value =="1")){
				rdShowMessageDialog("����ɨ����ȡ֤����Ϣ");
				return false;
			}
			
			
			if(upflag==5&&(document.all.but_flag.value =="1")){
				rdShowMessageDialog("��ѡ�����һ��ɨ����ȡ֤�������ɵ�֤��ͼ���ļ�"+document.all.pic_name.value);
				return false;
			}
			
			if((document.all.but_flag.value =="1")&&document.all.upbut_flag.value=="0"){//����֤
				rdShowMessageDialog("�����ϴ�����֤��Ƭ",0);
				return false;
			}
			//20091201 begin
			var da_te= (new Date().getFullYear().toString()+(((new Date().getMonth()+1).toString().length>=2)?(new Date().getMonth()+1).toString():("0"+(new Date().getMonth()+1)))+(((new Date().getDate()).toString().length>=2)?(new Date().getDate()):("0"+(new Date().getDate()))).toString());
			if(document.all.GoodPhoneFlag.value == "Y"){
				if((document.all.GoodPhoneDate.value).trim().length != 8){
					rdShowMessageDialog("�밴��ȷ��ʽ�������ʱ��");
					document.frm1104.GoodPhoneDate.focus();
					return false;
				}
				if(to_date(document.all.GoodPhoneDate) < da_te){
					rdShowMessageDialog("��������ʱ��С�ڵ�ǰϵͳʱ�䣬���������룡");
					document.all.GoodPhoneDate.focus();
					return false;
				}
			}
			//20091201 end
			
					/*
					if(!checkElement(document.all.anzhcontact_name)){
						return false;
					}
					if(!checkElement(document.all.anzhcontact_phoneno)){
						return false;
					}*/
			
			//-------------------------------------------
			//if(check(frm))
			{
				if("09" != "<%=regionCode%>"){
					if(checkPwd(document.all.custPwd,document.all.cfmPwd)==false) return false;
					chkPwdEasy(document.all.custPwd.value);
				} else {
					continueCfm();
				}
			}
		}
		function printInfo(printType){
			
 		  var retInfo = "";

 		  var cust_info="";
	    var opr_info="";
	    var note_info1="";
	    var note_info2="";
	    var note_info3="";
	    var note_info4="";

 		  cust_info+="�ͻ�������   " +document.all.cust_name.value+"|";
      cust_info+="�����ʺţ�   "+"<%=broadPhone%>"+"|";
      cust_info+="�ͻ���ַ��   "+document.all.cust_addr.value+"|";
      cust_info+="֤�����룺   "+document.all.ic_no.value+"|";

 		  opr_info+="����ҵ�����ƣ�"+"��������"+"|";
		  /* 
	     * ����Э������ʡ��������������Ӫ�������ں��ײ�����ĺ�����Ʒ���֣�@2014/7/24 
	     * ����ʡ���kg������Ʒ��kh
	     */
 		  if("<%=sNewSmName%>" == "kf" || "<%=sNewSmName%>" == "kg" || "<%=sNewSmName%>" == "kh"){
 		  	opr_info+="ҵ����Чʱ��: ������Ч"+"|";
 			}

		  opr_info+="������ˮ��"+document.all.loginAccept.value+"|";



		  opr_info+="�����ʺ�"+"<%=broadPhone%>"+"���û�"+"<%=(String)custDoc.get(5)%>"+"�������û�"+document.all.custName.value+"|";
		  opr_info+="�¿ͻ����ϣ��ͻ����ƣ�"+document.all.custName.value+"*"+"֤�����룺"+document.all.idIccid.value+"|";
		  opr_info+="�ͻ���ַ��"+document.all.idAddr.value+"|";
		  
		  opr_info+=" "+"|";
		  opr_info+="��ǰ���ʷѣ�"+"<%=main_str1%>"+"|";
		  opr_info+="��ϵ��������"+$("#newContactPerson").val()+"|";
		  opr_info+="��ϵ�绰��"+$("#newContactPhone").val()+"|";
			/* 
	     * ����Э������ʡ��������������Ӫ�������ں��ײ�����ĺ�����Ʒ���֣�@2014/7/24 
	     * ����ʡ���kg������Ʒ��kh
	     */
			if("<%=sNewSmName%>" == "kf" || "<%=sNewSmName%>" == "kg" || "<%=sNewSmName%>" == "kh"){
				note_info1 += "��ע��"+"|";
				note_info1 += "1������ϵ�绰�䶯ʱ���뼰ʱ���ƶ���˾��ϵ���Ա������»�������ʱ��ʱ�յ�֪ͨ��"+"|";
				note_info1 += "2������������벦��������ߣ�10086"+"|";
			}


		  //#23->#
			//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
			retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
			retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
		  return retInfo;
	 }
		function checkPwd(obj1,obj2){
			//����һ����У��,����У��
			var pwd1 = obj1.value;
			var pwd2 = obj2.value;
			if(pwd1 != pwd2){
				var message = "������������벻һ�£����������룡";
				rdShowMessageDialog(message);
				if(obj1.type != "hidden"){   obj1.value = "";    }
				if(obj2.type != "hidden"){   obj2.value = "";    }
				obj1.focus();
				return false;
			}
			return true;
		}
		function chkPwdEasy(pwd){
			if(pwd == ""){
				rdShowMessageDialog("�����������룡");
				return ;
			}
			var checkPwd_Packet = new AJAXPacket("../public/pubCheckPwdEasy.jsp","������֤�����Ƿ���ڼ򵥣����Ժ�......");
			checkPwd_Packet.data.add("password", pwd);
			checkPwd_Packet.data.add("phoneNo", "<%=phoneNo%>");
			checkPwd_Packet.data.add("idNo", frm.idIccid.value);
			checkPwd_Packet.data.add("opCode", "e972");
			checkPwd_Packet.data.add("custId", "");
		
			core.ajax.sendPacket(checkPwd_Packet, doCheckPwdEasy);
			checkPwd_Packet=null;
		}
		
		
		
		function doCheckPwdEasy(packet) {
			var retResult = packet.data.findValueByName("retResult");
			if (retResult == "1") {
				rdShowMessageDialog("�𾴵Ŀͻ������������õ�����Ϊ��ͬ���������룬��ȫ�Խϵͣ�Ϊ�˸��õر���������Ϣ��ȫ���������ð�ȫ�Ը��ߵ����롣");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "2") {
				rdShowMessageDialog("�𾴵Ŀͻ������������õ�����Ϊ���������룬��ȫ�Խϵͣ�Ϊ�˸��õر���������Ϣ��ȫ���������ð�ȫ�Ը��ߵ����롣");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "3") {
				rdShowMessageDialog("�𾴵Ŀͻ������������õ�����Ϊ�ֻ������е��������֣���ȫ�Խϵͣ�Ϊ�˸��õر���������Ϣ��ȫ���������ð�ȫ�Ը��ߵ����롣");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "4") {
				rdShowMessageDialog("�𾴵Ŀͻ������������õ�����Ϊ֤���е��������֣���ȫ�Խϵͣ�Ϊ�˸��õر���������Ϣ��ȫ���������ð�ȫ�Ը��ߵ����롣");
				document.frm.custPwd.value="";
				document.frm.cfmPwd.value="";
				return;
			} else if (retResult == "0") {
				//rdShowMessageDialog("У��ɹ���������ã�");
				continueCfm();
			}
		}
		function continueCfm(){
			document.all.t_sys_remark.value="�û�"+jtrim(document.all.cust_name.value)+"����������"+document.all.custName.value;
			
			if(jtrim(document.all.t_op_remark.value).length==0){
				document.all.t_op_remark.value="����Ա<%=workNo%>"+"���û��ֻ�"+jtrim(document.all.srv_no.value)+"���п�������"
			}
			if(jtrim(document.all.assuNote.value).length==0){
				document.all.assuNote.value="����Ա<%=workNo%>"+"���û��ֻ�"+jtrim(document.all.srv_no.value)+"���п�������"
			}
			
			//��ʾ��ӡ�Ի���
			var h=210;
			var w=400;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			var pType="subprint";
			var billType="1";
			
			var mode_code=null;
			var fav_code=null;
			var area_code=null
			
			var sysAccept = document.all.loginAccept.value;
			
			var printStr = printInfo("Detail");
			var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no;	scrollbars:yes; resizable:no;location:no;status:no;help:no"
			/* ningtn */
			var iccidInfoStr = $("#firstId").val() + "|" + $("#secondId").val();	
			var accInfoStr = $("#accInfoHid1").val() + "|" +$("#accInfoHid2").val()+ "|" +$("#accInfoHid3").val()+ "|" +$("#accInfoHid4").val();
			/* ningtn */
			var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_hw.jsp?DlgMsg=" + "ȷʵҪ���е��������ӡ��"+ "&iccidInfo=" + iccidInfoStr + "&accInfoStr="+accInfoStr;
			var path = path  + "&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+sysAccept+"&phoneNo=<%=phoneNo%>&loginacceptJT="+$("#loginacceptJT").val()+"&submitCfm=" + "Yes"+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
			
			var ret=window.showModalDialog(path,printStr,prop);
			
			if(typeof(ret)!="undefined"){
				if((ret=="confirm")){
					if(rdShowConfirmDialog('ȷ�ϵ��������')==1){
						conf();
					}
				}
				if(ret=="continueSub"){
					if(rdShowConfirmDialog('ȷ��Ҫ�ύ����������Ϣ��')==1){
						conf();
					}
				}
			}else{
				if(rdShowConfirmDialog('ȷ��Ҫ�ύ����������Ϣ��')==1){
					conf();
				}
			}
		}
		function conf(){
			frm.target="_self";
			
			if($("#gestoresInfo1").css("display")=="none"){
				frm.action="fe972Cfm.jsp";
	        }
	        else{
	        	frm.action="fe972Cfm.jsp?xsjbrxx=1";
	        }
			frm.submit();
		}
		
		
			/*2013/11/07 21:14:36 gaopeng ����ʵ���ƹ����������ϵĺ�*/
		function getIdTypes(){
			 var checkVal = $("select[name='isJSX']").find("option:selected").val();
			 //alert(checkVal);
		   var getdataPacket = new AJAXPacket("/npage/sq100/fq100GetIdTypes.jsp","���ڻ�����ݣ����Ժ�......");
					getdataPacket.data.add("checkVal",checkVal);
					getdataPacket.data.add("opCode","<%=opCode%>");
					getdataPacket.data.add("opName","<%=opName%>");
					core.ajax.sendPacketHtml(getdataPacket,resIdTypes);
					getdataPacket = null;
			
		}
		function resIdTypes(data){
						//alert(data);
					//�ҵ����ӵ�select
						var markDiv=$("#tdappendSome"); 
						//���ԭ�б���
						markDiv.empty();
						markDiv.append(data);
						change_idType();
						setRealUserFormat();
		 
		}
		
		
		function setRealUserFormat(){
  	
		if(document.all.isJSX.value=="1"){ //��λ�ͻ�
			$("#realUserInfo1").show();
			$("#realUserInfo2").show();
			/*ʵ��ʹ��������*/
	  	document.all.realUserName.v_must = "1";
	  	/*��ʵ��ʹ���˵�ַ*/
	  	document.all.realUserAddr.v_must = "1";
	  	/*ʵ��ʹ����֤������*/
	  	document.all.realUserIccId.v_must = "1";
		}else{
			$("#realUserInfo1").hide();
			$("#realUserInfo2").hide();
			/*ʵ��ʹ��������*/
	  	document.all.realUserName.v_must = "0";
	  	/*��ʵ��ʹ���˵�ַ*/
	  	document.all.realUserAddr.v_must = "0";
	  	/*ʵ��ʹ����֤������*/
	  	document.all.realUserIccId.v_must = "0";
		}
  	
		$("#realUserInfo1").find("td:eq(0)").attr("width","13%");
  	$("#realUserInfo1").find("td:eq(0)").attr("nowrap","nowrap");
  	$("#realUserInfo1").find("td:eq(1)").attr("nowrap","nowrap");
  	$("#realUserInfo1").find("td:eq(2)").attr("width","13%");
  	$("#realUserInfo1").find("td:eq(2)").attr("nowrap","nowrap");
  	$("#realUserInfo1").find("td:eq(3)").attr("nowrap","nowrap");
  	$("#realUserInfo1").find("td:eq(3)").attr("colSpan","3");
  	
  	$("#realUserInfo2").find("td:eq(0)").attr("width","13%");
  	$("#realUserInfo2").find("td:eq(0)").attr("nowrap","nowrap");
  	$("#realUserInfo2").find("td:eq(1)").attr("nowrap","nowrap");
  	$("#realUserInfo2").find("td:eq(2)").attr("width","13%");
  	$("#realUserInfo2").find("td:eq(2)").attr("nowrap","nowrap");
  	$("#realUserInfo2").find("td:eq(3)").attr("nowrap","nowrap");
  	$("#realUserInfo2").find("td:eq(3)").attr("colSpan","3");
  	
  	//��ʵ��ʹ���˸�ֵ
		$("#realUserName").val("<%=qRealUserName%>");
		$("#realUserIccId").val("<%=qRealUserIccId%>");
		$("#realUserAddr").val("<%=qRealUserAddr%>");
		if("<%=qRealUserIdType%>" != ""){
			$("#realUserIdType option").each(function(){
		    if($(this).val().indexOf("<%=qRealUserIdType%>") != -1){
		      $(this).attr("selected","true");
		    }
		  });
		}
		if("<%=qRealUserIdType%>" == "0" || "<%=qRealUserIdType%>" == ""){ //����֤������ʾ������ť
			$("#scan_idCard_two2").css("display","");
			$("#scan_idCard_two22").css("display","");
			$("input[name='realUserName']").attr("class","InputGrey");
			$("input[name='realUserName']").attr("readonly","readonly");
			$("input[name='realUserAddr']").attr("class","InputGrey");
			$("input[name='realUserAddr']").attr("readonly","readonly");
			$("input[name='realUserIccId']").attr("class","InputGrey");
			$("input[name='realUserIccId']").attr("readonly","readonly");
			
		}else{
			$("#scan_idCard_two2").css("display","none");
			$("#scan_idCard_two22").css("display","none");
			$("input[name='realUserName']").removeAttr("class");
			$("input[name='realUserName']").removeAttr("readonly");
			$("input[name='realUserAddr']").removeAttr("class");
			$("input[name='realUserAddr']").removeAttr("readonly");
			$("input[name='realUserIccId']").removeAttr("class");
			$("input[name='realUserIccId']").removeAttr("readonly");
		}	
	}
		
		
		/*2013/12/16 15:41:14 gaopeng ������֤���������������ı亯��*/
function validateGesIdTypes(idtypeVal){
	
		if(idtypeVal.indexOf("����֤") != -1){
  		document.all.gestoresIccId.v_type = "idcard";
  		$("#scan_idCard_two3").css("display","");
  		$("#scan_idCard_two31").css("display","");
  		$("input[name='gestoresName']").attr("class","InputGrey");
  		$("input[name='gestoresName']").attr("readonly","readonly");
  		$("input[name='gestoresAddr']").attr("class","InputGrey");
  		$("input[name='gestoresAddr']").attr("readonly","readonly");
  		$("input[name='gestoresIccId']").attr("class","InputGrey");
  		$("input[name='gestoresIccId']").attr("readonly","readonly");
  		$("input[name='gestoresName']").val("");
  		$("input[name='gestoresAddr']").val("");
  		$("input[name='gestoresIccId']").val("");
  	}else{
  		document.all.gestoresIccId.v_type = "string";
  		$("#scan_idCard_two3").css("display","none");
  		$("#scan_idCard_two31").css("display","none");
  		$("input[name='gestoresName']").removeAttr("class");
  		$("input[name='gestoresName']").removeAttr("readonly");
  		$("input[name='gestoresAddr']").removeAttr("class");
  		$("input[name='gestoresAddr']").removeAttr("readonly");
  		$("input[name='gestoresIccId']").removeAttr("class");
  		$("input[name='gestoresIccId']").removeAttr("readonly");
  	}
}

function validateresponIdTypes(idtypeVal){
		if(idtypeVal.indexOf("����֤") != -1){
  		document.all.responsibleIccId.v_type = "idcard";
  			$("#scan_idCard_two3zrr").css("display","");
  			$("#scan_idCard_two57zrr").css("display","");
	  		$("input[name='responsibleName']").attr("class","InputGrey");
	  		$("input[name='responsibleName']").attr("readonly","readonly");
	  		$("input[name='responsibleAddr']").attr("class","InputGrey");
	  		$("input[name='responsibleAddr']").attr("readonly","readonly");
	  		$("input[name='responsibleIccId']").attr("class","InputGrey");
	  		$("input[name='responsibleIccId']").attr("readonly","readonly");
	  		$("input[name='responsibleName']").val("");
	  		$("input[name='responsibleAddr']").val("");
	  		$("input[name='responsibleIccId']").val("");
  		
  	}else{
  		document.all.responsibleIccId.v_type = "string";
  			$("#scan_idCard_two3zrr").css("display","none");
  			$("#scan_idCard_two57zrr").css("display","none");
	  		$("input[name='responsibleName']").removeAttr("class");
	  		$("input[name='responsibleName']").removeAttr("readonly");
	  		$("input[name='responsibleAddr']").removeAttr("class");
	  		$("input[name='responsibleAddr']").removeAttr("readonly");
	  		$("input[name='responsibleIccId']").removeAttr("class");
	  		$("input[name='responsibleIccId']").removeAttr("readonly");
  		
  	}
}

//ʵ��ʹ����֤�����͸ı�
			function valiRealUserIdTypes(idtypeVal){
				if(idtypeVal == "0"){ //����֤
					document.all.realUserIccId.v_type = "idcard";
					$("#scan_idCard_two2").css("display","");
					$("#scan_idCard_two22").css("display","");
					$("input[name='realUserName']").attr("class","InputGrey");
					$("input[name='realUserName']").attr("readonly","readonly");
					$("input[name='realUserAddr']").attr("class","InputGrey");
					$("input[name='realUserAddr']").attr("readonly","readonly");
					$("input[name='realUserIccId']").attr("class","InputGrey");
					$("input[name='realUserIccId']").attr("readonly","readonly");
					$("input[name='realUserName']").val("");
					$("input[name='realUserAddr']").val("");
					$("input[name='realUserIccId']").val("");
				}else{
					document.all.realUserIccId.v_type = "string";
					$("#scan_idCard_two2").css("display","none");
					$("#scan_idCard_two22").css("display","none");
					$("input[name='realUserName']").removeAttr("class");
					$("input[name='realUserName']").removeAttr("readonly");
					$("input[name='realUserAddr']").removeAttr("class");
					$("input[name='realUserAddr']").removeAttr("readonly");
					$("input[name='realUserIccId']").removeAttr("class");
					$("input[name='realUserIccId']").removeAttr("readonly");
				}
				if($("#realUserIdType").val() == "<%=qRealUserIdType%>"){ //ѡ���ʼ֤�����ͣ���ԭ��ʼ֤����Ϣ
					$("#realUserName").val("<%=qRealUserName%>");
					$("#realUserAddr").val("<%=qRealUserAddr%>");
					$("#realUserIccId").val("<%=qRealUserIccId%>");
				}else{
					$("input[name='realUserName']").val("");
					$("input[name='realUserAddr']").val("");
					$("input[name='realUserIccId']").val("");
				}
			}
			
			
			/*1���ͻ����ơ���ϵ������ У�鷽�� objType 0 �����ͻ�����У�� 1������ϵ������У��  ifConnect �����Ƿ�������ֵ(���ȷ�ϰ�ťʱ��������������ֵ)*/
function checkCustNameFunc(obj,objType,ifConnect){
	var nextFlag = true;
	var objName = "";
	var idTypeVal ="";
		
	if(objType == 0){
		objName = "�ͻ�����";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "��ϵ������";
		idTypeVal = document.all.idType.value;
	}
	/*2013/12/16 11:24:47 gaopeng ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭��������*/
	if(objType == 2){
		objName = "����������";
		/*�����վ�����֤������*/
		idTypeVal = document.all.gestoresIdType.value;
	}
	
	if(objType == 3){
		objName = "����������";
		/*�����վ�����֤������*/
		idTypeVal = document.all.responsibleType.value;
	}
	
	idTypeVal = $.trim(idTypeVal);
	/*ֻ��Ը��˿ͻ�*/
	var opCode = "<%=opCode%>";
	/*��ȡ������ֵ*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*��ȡ�����ֵ�ĳ���*/
	var objValueLength = objValue.length;
	if(objValue != ""){
		/* ��ȡ��ѡ���֤������ 
		0|����֤ 1|����֤ 2|���ڲ� 3|�۰�ͨ��֤ 
		4|����֤ 5|̨��ͨ��֤ 6|��������� 7|���� 
		8|Ӫҵִ�� 9|���� A|��֯�������� B|��λ����֤�� C|������ 
		*/
		
		/*��ȡ֤���������� */
		var idTypeText = idTypeVal.split("|")[0];
		
		/*����ʱ�����������Ķ�����*/
		if(objValue.indexOf("��ʱ") != -1 || objValue.indexOf("����") != -1){
					rdShowMessageDialog(objName+"���ܴ��С���ʱ���򡮴��졯������");
					
					nextFlag = false;
					return false;
			
		}
		
		/*�ͻ����ơ���ϵ��������Ҫ�󡰴��ڵ���2�����ĺ��֡�����������ճ��⣨��������տͻ����Ʊ������3���ַ�����ȫΪ����������)*/
		
		/*����������������*/
		if(idTypeText != "6"){
			/*ԭ�е�ҵ���߼�У�� ֻ������Ӣ�ġ����֡����ġ����ġ����ġ���������һ�����ԣ�*/
			if(idTypeText == "3" || idTypeText == "9" || idTypeText == "8" || idTypeText == "A" || idTypeText == "B" || idTypeText == "C"){
				if(objValueLength < 2){
					rdShowMessageDialog(objName+"������ڵ���2�����֣�");
					nextFlag = false;
					return false;
				}
				var KH_length = 0;
		     var EH_length = 0;
		     var RU_length = 0;
		     var FH_length = 0;
		     var JP_length = 0;
		     var KR_length = 0;
		     var CH_length = 0;
         
         for (var i = 0; i < objValue.length; i ++){
            var code = objValue.charAt(i);//�ֱ��ȡ��������
            var key = checkNameStr(code); //У��
            if(key == undefined){
              rdShowMessageDialog(objName+"ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
              obj.value = "";
              
              nextFlag = false;
              return false;
            }
            if(key == "KH"){
            	KH_length++;
            }
            if(key == "EH"){
            	EH_length++;
            }
            if(key == "RU"){
            	RU_length++;
            }
            if(key == "FH"){
            	FH_length++;
            }
            if(key == "JP"){
            	JP_length++;
            }
            if(key == "KR"){
            	KR_length++;
            }
            if(key == "CH"){
            	CH_length++;
            }
         
         }	
            var machEH = KH_length + EH_length;
            var machRU = KH_length + RU_length;
            var machFH = KH_length + FH_length;
            var machJP = KH_length + JP_length;
            var machKR = KH_length + KR_length;
            var machCH = KH_length + CH_length;
            
            
            if((objValueLength != machEH 
            && objValueLength != machRU
            && objValueLength != machFH
            && objValueLength != machJP
            && objValueLength != machKR
            && objValueLength != machCH ) || objValueLength == KH_length){
            		rdShowMessageDialog(objName+"ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
                obj.value = "";
              	nextFlag = false;
                return false;
            }	
       }
       else{
					/*��ȡ�������ĺ��ֵĸ����Լ�'()����'�ĸ���*/
					var m = /^[\u0391-\uFFE5]*$/;
					var mm = /^��|\.|\��*$/;
					var chinaLength = 0;
					var kuohaoLength = 0;
					var zhongjiandianLength=0;
					for (var i = 0; i < objValue.length; i ++){
			          var code = objValue.charAt(i);//�ֱ��ȡ��������
			          var flag22=mm.test(code);
			          var flag = m.test(code);
			          /*��У������*/
			          if(forKuoHao(code)){
			          	kuohaoLength ++;
			          }else if(flag){
			          	chinaLength ++;
			          }else if(flag22){
			          	zhongjiandianLength++;
			          }
			    }
			    var machLength = chinaLength + kuohaoLength+zhongjiandianLength;
					/*���ŵ�����+���ֵ����� != ������ʱ ��ʾ������Ϣ(������Ҫע��һ�㣬��������Ҳ�����ġ�������������ֻ����Ӣ�����ŵ�ƥ������������ƥ����)*/
					if(objValueLength != machLength || chinaLength == 0){
						rdShowMessageDialog(objName+"�����������Ļ����������ŵ����(���ſ���Ϊ���Ļ�Ӣ�����š�()������)��");
						/*��ֵΪ��*/
						obj.value = "";
						
						nextFlag = false;
						return false;
					}else if(objValueLength == machLength && chinaLength != 0){
						if(objValueLength < 2){
							rdShowMessageDialog(objName+"������ڵ���2�����ĺ��֣�");
							
							nextFlag = false;
							return false;
						}
					}
					/*ԭ���߼�
					if(idTypeText == "0" || idTypeText == "2"){
						if(objValueLength > 6){
							rdShowMessageDialog(objName+"�������6�����֣�");
							
							nextFlag = false;
							return false;
						}
				}
				*/
			}
       
		}
		/*�������������� У�� ��������տͻ�����(������������ϵ������Ҳͬ��(sunaj��ȷ��))�������3���ַ�����ȫΪ����������*/
		if(idTypeText == "6"){
			/*���У��ͻ�����*/
				if(objValue % 2 == 0 || objValue % 2 == 1){
						rdShowMessageDialog(objName+"����ȫΪ����������!");
						/*��ֵΪ��*/
						obj.value = "";
						
						nextFlag = false;
						return false;
				}
				if(objValueLength <= 3){
						rdShowMessageDialog(objName+"������������ַ�!");
						
						nextFlag = false;
						return false;
				}
         var KH_length = 0;
		     var EH_length = 0;
		     var RU_length = 0;
		     var FH_length = 0;
		     var JP_length = 0;
		     var KR_length = 0;
		     var CH_length = 0;
         
         for (var i = 0; i < objValue.length; i ++){
            var code = objValue.charAt(i);//�ֱ��ȡ��������
            var key = checkNameStr(code); //У��
            if(key == undefined){
              rdShowMessageDialog(objName+"ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
              obj.value = "";
              
              nextFlag = false;
              return false;
            }
            if(key == "KH"){
            	KH_length++;
            }
            if(key == "EH"){
            	EH_length++;
            }
            if(key == "RU"){
            	RU_length++;
            }
            if(key == "FH"){
            	FH_length++;
            }
            if(key == "JP"){
            	JP_length++;
            }
            if(key == "KR"){
            	KR_length++;
            }
            if(key == "CH"){
            	CH_length++;
            }
         
         }	
            var machEH = KH_length + EH_length;
            var machRU = KH_length + RU_length;
            var machFH = KH_length + FH_length;
            var machJP = KH_length + JP_length;
            var machKR = KH_length + KR_length;
            var machCH = KH_length + CH_length;
            
            
            if((objValueLength != machEH 
            && objValueLength != machRU
            && objValueLength != machFH
            && objValueLength != machJP
            && objValueLength != machKR
            && objValueLength != machCH ) || objValueLength == KH_length){
            		rdShowMessageDialog(objName+"ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
                obj.value = "";
              	nextFlag = false;
                return false;
            }
		}
		
		
		if(ifConnect == 0){
		
		if(nextFlag){
		 if(objType == 0){
		 	/*��ϵ��������ͻ����Ƹ������ı�*/
			document.all.contactPerson.value = objValue;
			 
		 	}	
		}
			}
		
	}	
	return nextFlag;
}



/*
	2013/11/18 11:15:44
	gaopeng
	�ͻ���ַ��֤����ַ����ϵ�˵�ַУ�鷽��
	���ͻ���ַ������֤����ַ���͡���ϵ�˵�ַ�����衰���ڵ���8�����ĺ��֡�
	����������պ�̨��ͨ��֤���⣬���������Ҫ�����2�����֣�̨��ͨ��֤Ҫ�����3�����֣�
*/

function checkAddrFunc(obj,objType,ifConnect){
	var nextFlag = true;
	var objName = "";
	var idTypeVal = "";
	if(objType == 0){
		objName = "֤����ַ";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "�ͻ���ַ";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 2){
		objName = "��ϵ�˵�ַ";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 3){
		objName = "��ϵ��ͨѶ��ַ";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 4){
		objName = "��������ϵ��ַ";
		idTypeVal = document.all.gestoresIdType.value;
	}
	if(objType == 5){
		objName = "��������ϵ��ַ";
		idTypeVal = document.all.responsibleType.value;
	}
	idTypeVal = $.trim(idTypeVal);
	/*ֻ��Ը��˿ͻ�*/
	var opCode = "<%=opCode%>";
	/*��ȡ������ֵ*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*��ȡ�����ֵ�ĳ���*/
	var objValueLength = objValue.length;
	
	if(objValue != ""){
		/* ��ȡ��ѡ���֤������ 
		0|����֤ 1|����֤ 2|���ڲ� 3|�۰�ͨ��֤ 
		4|����֤ 5|̨��ͨ��֤ 6|��������� 7|���� 
		8|Ӫҵִ�� 9|���� A|��֯�������� B|��λ����֤�� C|������ 
		*/
		
		/*��ȡ֤���������� */
		var idTypeText = idTypeVal.split("|")[0];
		
		/*��ȡ�������ĺ��ֵĸ���*/
		var m = /^[\u0391-\uFFE5]*$/;
		var chinaLength = 0;
		for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//�ֱ��ȡ��������
          var flag = m.test(code);
          if(flag){
          	chinaLength ++;
          }
    }
      
		/*����Ȳ������������ Ҳ����̨��ͨ��֤ */
		if(idTypeText != "6" && idTypeText != "5"){
			/*��������8�����ĺ���*/
			if(chinaLength < 8){
				rdShowMessageDialog(objName+"���뺬������8�����ĺ��֣�");
				/*��ֵΪ��*/
				obj.value = "";
				
				nextFlag = false;
				return false;
			}
		
	}
	/*��������� ����2������*/
	if(idTypeText == "6"){
		/*����2�����ĺ���*/
			if(chinaLength <= 2){
				rdShowMessageDialog(objName+"���뺬�д���2�����ĺ��֣�");
				
				nextFlag = false;
				return false;
			}
	}
	/*̨��ͨ��֤ ����3������*/
	if(idTypeText == "5"){
		/*��������3���ĺ���*/
			if(chinaLength <= 3){
				rdShowMessageDialog(objName+"���뺬�д���3�����ĺ��֣�");
				
				nextFlag = false;
				return false;
			}
	}
	/*������ֵ ifConnect ��0ʱ�Ÿ�ֵ�����򲻸�ֵ*/
	if(ifConnect == 0){
		if(nextFlag){
			/*֤����ַ�ı�ʱ����ֵ������ַ*/
			if(objType == 0){
			    document.all.custAddr.value=objValue;
			    document.all.contactAddr.value=objValue;
			    document.all.contactMAddr.value=objValue;
			}
			/*�ͻ���ַ�ı�ʱ����ֵ��ϵ�˵�ַ����ϵ��ͨѶ��ַ*/
			if(objType == 1){
				document.all.contactAddr.value = objValue;
	  		document.all.contactMAddr.value = objValue;
			}
			/*��ϵ�˵�ַ�ı�ʱ����ֵ��ϵ��ͨѶ��ַ��2013/12/16 15:20:17 20131216 gaopeng ��ֵ��������ϵ��ַ����*/
			if(objType == 2){
				document.all.contactMAddr.value=objValue;
				document.all.gestoresAddr.value=objValue;
				document.all.responsibleAddr.value=objValue;
			}
		}
	}
	
	
}
return nextFlag;
}

/*
	2013/11/18 14:01:09
	gaopeng
	֤�����ͱ��ʱ��֤�������У�鷽��
*/

function checkIccIdFunc(obj,objType,ifConnect){
	var nextFlag = true;
	var idTypeVal = "";
	if(objType == 0){
		var objName = "֤������";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "������֤������";
		idTypeVal = document.all.gestoresIdType.value;
	}
	if(objType == 2){
		objName = "������֤������";
		idTypeVal = document.all.responsibleType.value;
	}	
	
	/*ֻ��Ը��˿ͻ�*/
	var opCode = "<%=opCode%>";
	/*��ȡ������ֵ*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*��ȡ�����ֵ�ĳ���*/
	var objValueLength = objValue.length;
	if(objValue != ""){
		/* ��ȡ��ѡ���֤������ 
		0|����֤ 1|����֤ 2|���ڲ� 3|�۰�ͨ��֤ 
		4|����֤ 5|̨��ͨ��֤ 6|��������� 7|���� 
		8|Ӫҵִ�� 9|���� A|��֯�������� B|��λ����֤�� C|������ 
		*/
		
		/*��ȡ֤���������� */
		var idTypeText = idTypeVal.split("|")[0];
		
		/*1������֤�����ڱ�ʱ��֤�����볤��Ϊ18λ*/
		if(idTypeText == "0" || idTypeText == "2"){
			if(objValueLength != 18){
					rdShowMessageDialog(objName+"������18λ��");
					
					nextFlag = false;
					return false;
			}
		}
		/*����֤ ����֤ ���������ʱ ֤��������ڵ���6λ�ַ�*/
		if(idTypeText == "1" || idTypeText == "4" || idTypeText == "6"){
			if(objValueLength < 6){
					rdShowMessageDialog(objName+"������ڵ�����λ�ַ���");
					
					nextFlag = false;
					return false;
			}
		}
		/*֤������Ϊ�۰�ͨ��֤�ģ�֤������Ϊ9λ��11λ��������λΪӢ����ĸ��H����M��(ֻ�����Ǵ�д)������λ��Ϊ���������֡�*/
		if(idTypeText == "3"){
			if(objValueLength != 9 && objValueLength != 11){
					rdShowMessageDialog(objName+"������9λ��11λ��");
					
					nextFlag = false;
					return false;
			}
			/*��ȡ����ĸ*/
			var valHead = objValue.substring(0,1);
			if(valHead != "H" && valHead != "M"){
					rdShowMessageDialog(objName+"����ĸ�����ǡ�H����M����");
					
					nextFlag = false;
					return false;
			}
			/*��ȡ����ĸ֮���������Ϣ*/
			var varWithOutHead = objValue.substring(1,objValue.length);
			if(varWithOutHead % 2 != 0 && varWithOutHead % 2 != 1){
					rdShowMessageDialog(objName+"������ĸ֮�⣬����λ�����ǰ��������֣�");
					
					nextFlag = false;
					return false;
			}
		}
		/*֤������Ϊ
			̨��ͨ��֤ 
			֤������ֻ����8λ��11λ
			֤������Ϊ11λʱǰ10λΪ���������֣�
			���һλΪУ����(Ӣ����ĸ���������֣���
			֤������Ϊ8λʱ����Ϊ����������
		*/
		if(idTypeText == "5"){
			if(objValueLength != 8 && objValueLength != 11){
					rdShowMessageDialog(objName+"����Ϊ8λ��11λ��");
					
					nextFlag = false;
					return false;
			}
			/*8λʱ����Ϊ����������*/
			if(objValueLength == 8){
				if(objValue % 2 != 0 && objValue % 2 != 1){
					rdShowMessageDialog(objName+"����Ϊ����������");
					
					nextFlag = false;
					return false;
				}
			}
			/*11λʱ�����һλ������Ӣ����ĸ���������֣�ǰ10λ�����ǰ���������*/
			if(objValueLength == 11){
				var objValue10 = objValue.substring(0,10);
				if(objValue10 % 2 != 0 && objValue10 % 2 != 1){
					rdShowMessageDialog(objName+"ǰʮλ����Ϊ����������");
					
					nextFlag = false;
					return false;
				}
				var objValue11 = objValue.substring(10,11);
  			var m = /^[A-Za-z]+$/;
				var flag = m.test(objValue11);
				
				if(!flag && objValue11 % 2 != 0 && objValue11 % 2 != 1){
					rdShowMessageDialog(objName+"��11λ����Ϊ���������ֻ�Ӣ����ĸ��");
					
					nextFlag = false;
					return false;
				}
			}
			
		}
		/*��֯������ ֤��������ڵ���9λ��Ϊ���֡���-�����д������ĸ*/
		if(idTypeText == "A"){
		 if(objValueLength != 10){
					rdShowMessageDialog(objName+"������10λ��");				
					nextFlag = false;
					return false;
			}
			if(objValue.substr(objValueLength-2,1)!="-" && objValue.substr(objValueLength-2,1)!="��") {
					rdShowMessageDialog(objName+"�����ڶ�λ�����ǡ�-����");				
					nextFlag = false;
					return false;			
			}
		}
		/*Ӫҵִ�� ֤�����������ڵ���4λ���֣����������纺�ֵ��ַ�Ҳ�Ϲ�*/
		if(idTypeText == "8"){
		
		 if(objValueLength != 13 && objValueLength != 15 && objValueLength != 18 && objValueLength != 20){
					rdShowMessageDialog(objName+"������13λ��15λ��18λ��20λ��");				
					nextFlag = false;
					return false;
			}
				    
			var m = /^[\u0391-\uFFE5]*$/;
			var numSum = 0;
			for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//�ֱ��ȡ��������
          var flag = m.test(code);
          if(flag){
          	numSum ++;
          }
    	}
			if(numSum > 0){
					rdShowMessageDialog(objName+"������¼�뺺�֣�");				
					nextFlag = false;
					return false;
			}

		}
		/*����֤�� ֤��������ڵ���4λ�ַ�*/
		if(idTypeText == "B"){
		 if(objValueLength != 12){
					rdShowMessageDialog(objName+"������12λ��");				
					nextFlag = false;
					return false;
			}
				    
			var m = /^[\u0391-\uFFE5]*$/;
			var numSum = 0;
			for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//�ֱ��ȡ��������
          var flag = m.test(code);
          if(flag){
          	numSum ++;
          }
    	}
			if(numSum > 0){
					rdShowMessageDialog(objName+"������¼�뺺�֣�");				
					nextFlag = false;
					return false;
			}
			
		}
		/*����ԭ���߼�*/
		rpc_chkX('idType','idIccid','A');
		
	}
	return nextFlag;
}

function rpc_chkX(x_type,x_no,chk_kind)
{
  var obj_type=document.all(x_type);
  var obj_no=document.all(x_no);
  var idname="";

  if(obj_type.type=="text")
  {
    idname=(obj_type.value).trim();
  }
  else if(obj_type.type=="select-one")
  {
    idname=(obj_type.options[obj_type.selectedIndex].text).trim();  
  }

  if((obj_no.value).trim().length>0)
  {
  	
   
      if(idname=="����֤")
    {
        if(checkElement(obj_no)==false) return false;
    }
  
  }
  else 
  return;
  var myPacket = new AJAXPacket("/npage/innet/chkX.jsp","������֤��������Ϣ�����Ժ�......");
    myPacket.data.add("retType","chkX");
    myPacket.data.add("retObj",x_no);
    myPacket.data.add("x_idType",getX_idno(idname));
    myPacket.data.add("x_idNo",obj_no.value);
    myPacket.data.add("x_chkKind",chk_kind);
    core.ajax.sendPacket(myPacket);
    myPacket=null;
  
}

function doProcess(packet)
	  {
			//RPC��������findValueByName
			var retType = packet.data.findValueByName("retType");
			var retCode = packet.data.findValueByName("retCode");
			var retMessage = packet.data.findValueByName("retMessage");
			
			if(retType=="chkX")
	   {
	   	
	    var retObj = packet.data.findValueByName("retObj");
	    if(retCode == "000000"){
	      }else if(retCode=="100001"){
	        retMessage = retCode + "��"+retMessage;  
	        /*����ʾ������~���������˱Ƚ�*/
	        //rdShowMessageDialog(retMessage);     
	        return true;
	      }else{
	        retMessage = "����" + retCode + "��"+retMessage;      
	        rdShowMessageDialog(retMessage,0);
	        return false;
	       
	    }
	   }
			
		}

/***��֤�������ĺ����е��ô˺���***/
			function getX_idno(xx)
		{
		  if(xx==null) return "0";

		  if(xx=="����֤") return "0";
		  else if(xx=="����֤") return "1";
		  else if(xx=="��ʻ֤") return "2";
		  else if(xx=="����֤") return "4";
		  else if(xx=="ѧ��֤") return "5";
		  else if(xx=="��λ") return "6";
		  else if(xx=="У԰") return "7";
		  else if(xx=="Ӫҵִ��") return "8";
		  else return "0";
		}

function checkNameStr(code){
  	/*����ƥ������*/
    if(forKuoHao(code)) return "KH";//����
    if(forA2sssz1(code)) return "EH"; //Ӣ��
    var re2 =new RegExp("[\u0400-\u052f]");
    if(re2.test(code)) return "RU"; //����
    var re3 =new RegExp("[\u00C0-\u00FF]");
    if(re3.test(code)) return "FH"; //����
    var re4 = new RegExp("[\u3040-\u30FF]");
    var re5 = new RegExp("[\u31F0-\u31FF]");
    if(re4.test(code)||re5.test(code)) return "JP"; //����
    var re6 = new RegExp("[\u1100-\u31FF]");
    var re7 = new RegExp("[\u1100-\u31FF]");
    var re8 = new RegExp("[\uAC00-\uD7AF]");
    if(re6.test(code)||re7.test(code)||re8.test(code)) return "KR"; //����
    if(forHanZi1(code)) return "CH"; //����
    
   }
   
   //ƥ����26��Ӣ����ĸ��ɵ��ַ���
  function forA2sssz1(obj)
  {
  	var patrn = /^[A-Za-z]+$/;
  	var sInput = obj;
  	if(sInput.search(patrn)==-1){
  		//showTip(obj,"����Ϊ��ĸ��");
  		return false;
  	}
  	if (!isLengthOf(obj,obj.v_minlength,obj.v_maxlength)){
  		//showTip(obj,"�����д���");
  		return false;
  	}
  
  	return true;
  }
  
  function forKuoHao(obj){
	var m = /^(\(?\)?\��?\��?)\��|\.|\��+$/;
  	var flag = m.test(obj);
  	if(!flag){
  		return false;
  	}else{
  		return true;
  	}
}
  
  function forEnKuoHao(obj){
	var m = /^(\(?\)?)+$/;
  	var flag = m.test(obj);
  	if(!flag){
  		return false;
  	}else{
  		return true;
  	}
}
  function forHanZi1(obj)
  {
  	var m = /^[\u0391-\uFFE5]+$/;
  	var flag = m.test(obj);
  	if(!flag){
  		//showTip(obj,"�������뺺�֣�");
  		return false;
  	}
  		if (!isLengthOf(obj,obj.v_minlength*2,obj.v_maxlength*2)){
  		//showTip(obj,"�����д���");
  		return false;
  	}
  	return true;
  }
  function pubM032Cfm(){
  }
  
  /*1���ͻ����ơ���ϵ������ У�鷽�� objType 0 �����ͻ�����У�� 1������ϵ������У��  ifConnect �����Ƿ�������ֵ(���ȷ�ϰ�ťʱ��������������ֵ)*/
function checkCustNameFuncNew(obj,objType,ifConnect){
	var nextFlag = true;
	
	if(document.all.realUserName.v_must !="1") {
	  return nextFlag;
	  return false;		
	}
	
	
	
	var objName = "";
	var idTypeVal = "";
	if(objType == 0){
		objName = "�ͻ�����";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "��ϵ������";
		idTypeVal = document.all.idType.value;
	}
	/*2013/12/16 11:24:47 gaopeng ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭��������*/
	if(objType == 2){
		objName = "����������";
		/*�����վ�����֤������*/
		idTypeVal = document.all.gestoresIdType.value;
	}
	
	if(objType == 3){
		objName = "ʵ��ʹ��������";
		/*�����վ�����֤������*/
		idTypeVal = document.all.realUserIdType.value;
	}
	
	idTypeVal = $.trim(idTypeVal);
	
	/*ֻ��Ը��˿ͻ�*/
	var opCode = "<%=opCode%>";
	/*��ȡ������ֵ*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*��ȡ�����ֵ�ĳ���*/
	var objValueLength = objValue.length;
	if(objValue != ""){
		/* ��ȡ��ѡ���֤������ 
		0|����֤ 1|����֤ 2|���ڲ� 3|�۰�ͨ��֤ 
		4|����֤ 5|̨��ͨ��֤ 6|��������� 7|���� 
		8|Ӫҵִ�� 9|���� A|��֯�������� B|��λ����֤�� C|������ 
		*/
		/*��ȡ֤���������� */
		var idTypeText = idTypeVal;
		
		/*����ʱ�����������Ķ�����*/
		if(objValue.indexOf("��ʱ") != -1 || objValue.indexOf("����") != -1){
					rdShowMessageDialog(objName+"���ܴ��С���ʱ���򡮴��졯������");
					
					nextFlag = false;
					return false;
			
		}
		
		/*�ͻ����ơ���ϵ��������Ҫ�󡰴��ڵ���2�����ĺ��֡�����������ճ��⣨��������տͻ����Ʊ������3���ַ�����ȫΪ����������)*/
		
		/*����������������*/
		if(idTypeText != "6"){
			/*ԭ�е�ҵ���߼�У�� ֻ������Ӣ�ġ����֡����ġ����ġ����ġ���������һ�����ԣ�*/
			
			/*2014/08/27 16:14:22 gaopeng ���ֹ�˾�����Ż������������Ƶ���ʾ Ҫ��λ�ͻ�ʱ���ͻ����ƿ�����дӢ�Ĵ�Сд��� Ŀǰ�ȸ�ɸ� idTypeText == "3" || idTypeText == "9" һ�����߼� �������ʿɲ�����*/
			if(idTypeText == "3" || idTypeText == "9" || idTypeText == "8" || idTypeText == "A" || idTypeText == "B" || idTypeText == "C"){
				if(objValueLength < 2){
					rdShowMessageDialog(objName+"������ڵ���2�����֣�");
					nextFlag = false;
					return false;
				}
				 var KH_length = 0;
		     var EH_length = 0;
		     var RU_length = 0;
		     var FH_length = 0;
		     var JP_length = 0;
		     var KR_length = 0;
		     var CH_length = 0;
         
         for (var i = 0; i < objValue.length; i ++){
            var code = objValue.charAt(i);//�ֱ��ȡ��������
            var key = checkNameStr(code); //У��
            if(key == undefined){
              rdShowMessageDialog("ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
              obj.value = "";
              
              nextFlag = false;
              return false;
            }
            if(key == "KH"){
            	KH_length++;
            }
            if(key == "EH"){
            	EH_length++;
            }
            if(key == "RU"){
            	RU_length++;
            }
            if(key == "FH"){
            	FH_length++;
            }
            if(key == "JP"){
            	JP_length++;
            }
            if(key == "KR"){
            	KR_length++;
            }
            if(key == "CH"){
            	CH_length++;
            }
         
         }	
            var machEH = KH_length + EH_length;
            var machRU = KH_length + RU_length;
            var machFH = KH_length + FH_length;
            var machJP = KH_length + JP_length;
            var machKR = KH_length + KR_length;
            var machCH = KH_length + CH_length;
            
            
            if((objValueLength != machEH 
            && objValueLength != machRU
            && objValueLength != machFH
            && objValueLength != machJP
            && objValueLength != machKR
            && objValueLength != machCH ) || objValueLength == KH_length){
            		rdShowMessageDialog("ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
                obj.value = "";
              	nextFlag = false;
                return false;
            }
       }
       else{
					
					/*��ȡ�������ĺ��ֵĸ����Լ�'()����'�ĸ���*/
					var m = /^[\u0391-\uFFE5]*$/;
					var mm = /^��|\.|\��*$/;
					var chinaLength = 0;
					var kuohaoLength = 0;
					var zhongjiandianLength=0;
					for (var i = 0; i < objValue.length; i ++){
								
			          var code = objValue.charAt(i);//�ֱ��ȡ��������
			          var flag22=mm.test(code);
			          var flag = m.test(code);
			          /*��У������*/
			          if(forKuoHao(code)){
			          	kuohaoLength ++;
			          }else if(flag){
			          	chinaLength ++;
			          }else if(flag22){
			          	zhongjiandianLength++;
			          }
			          
			    }
			    var machLength = chinaLength + kuohaoLength+zhongjiandianLength;
					/*���ŵ�����+���ֵ����� != ������ʱ ��ʾ������Ϣ(������Ҫע��һ�㣬��������Ҳ�����ġ�������������ֻ����Ӣ�����ŵ�ƥ������������ƥ����)*/
					if(objValueLength != machLength || chinaLength == 0){
						rdShowMessageDialog(objName+"�����������Ļ����������ŵ����(���ſ���Ϊ���Ļ�Ӣ�����š�()������)��");
						/*��ֵΪ��*/
						obj.value = "";
						
						nextFlag = false;
						return false;
					}else if(objValueLength == machLength && chinaLength != 0){
						if(objValueLength < 2){
							rdShowMessageDialog(objName+"������ڵ���2�����ĺ��֣�");
							
							nextFlag = false;
							return false;
						}
					}
					/*ԭ���߼�
					if(idTypeText == "0" || idTypeText == "2"){
						if(objValueLength > 6){
							rdShowMessageDialog(objName+"�������6�����֣�");
							
							nextFlag = false;
							return false;
						}
				}
				*/
			}
       
		}
		/*�������������� У�� ��������տͻ�����(������������ϵ������Ҳͬ��(sunaj��ȷ��))�������3���ַ�����ȫΪ����������*/
		if(idTypeText == "6"){
			/*���У��ͻ�����*/
				if(objValue % 2 == 0 || objValue % 2 == 1){
						rdShowMessageDialog(objName+"����ȫΪ����������!");
						/*��ֵΪ��*/
						obj.value = "";
						
						nextFlag = false;
						return false;
				}
				if(objValueLength <= 3){
						rdShowMessageDialog(objName+"������������ַ�!");
						
						nextFlag = false;
						return false;
				}
				var KH_length = 0;
		     var EH_length = 0;
		     var RU_length = 0;
		     var FH_length = 0;
		     var JP_length = 0;
		     var KR_length = 0;
		     var CH_length = 0;
         
         for (var i = 0; i < objValue.length; i ++){
            var code = objValue.charAt(i);//�ֱ��ȡ��������
            var key = checkNameStr(code); //У��
            if(key == undefined){
              rdShowMessageDialog("ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
              obj.value = "";
              
              nextFlag = false;
              return false;
            }
            if(key == "KH"){
            	KH_length++;
            }
            if(key == "EH"){
            	EH_length++;
            }
            if(key == "RU"){
            	RU_length++;
            }
            if(key == "FH"){
            	FH_length++;
            }
            if(key == "JP"){
            	JP_length++;
            }
            if(key == "KR"){
            	KR_length++;
            }
            if(key == "CH"){
            	CH_length++;
            }
         
         }	
            var machEH = KH_length + EH_length;
            var machRU = KH_length + RU_length;
            var machFH = KH_length + FH_length;
            var machJP = KH_length + JP_length;
            var machKR = KH_length + KR_length;
            var machCH = KH_length + CH_length;
            
            
            if((objValueLength != machEH 
            && objValueLength != machRU
            && objValueLength != machFH
            && objValueLength != machJP
            && objValueLength != machKR
            && objValueLength != machCH ) || objValueLength == KH_length){
            		rdShowMessageDialog("ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
                obj.value = "";
              	nextFlag = false;
                return false;
            }
				
		}
		
		
		
	}	
	return nextFlag;
}


/*
	2013/11/18 11:15:44
	gaopeng
	�ͻ���ַ��֤����ַ����ϵ�˵�ַУ�鷽��
	���ͻ���ַ������֤����ַ���͡���ϵ�˵�ַ�����衰���ڵ���8�����ĺ��֡�
	����������պ�̨��ͨ��֤���⣬���������Ҫ�����2�����֣�̨��ͨ��֤Ҫ�����3�����֣�
*/

function checkAddrFuncNew(obj,objType,ifConnect){
	var nextFlag = true;
	
		if(document.all.realUserAddr.v_must !="1") {
	  return nextFlag;
	  return false;		
	}
	
	
	var objName = "";
	var idTypeVal = ""
	if(objType == 0){
		objName = "֤����ַ";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "�ͻ���ַ";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 2){
		objName = "��ϵ�˵�ַ";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 3){
		objName = "��ϵ��ͨѶ��ַ";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 4){
		objName = "��������ϵ��ַ";
		idTypeVal = document.all.gestoresIdType.value;
	}
	if(objType == 5){
		objName = "ʵ��ʹ������ϵ��ַ";
		idTypeVal = document.all.realUserIdType.value;
	}
		
	idTypeVal = $.trim(idTypeVal);
	/*ֻ��Ը��˿ͻ�*/
	var opCode = "<%=opCode%>";
	/*��ȡ������ֵ*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*��ȡ�����ֵ�ĳ���*/
	var objValueLength = objValue.length;
	
	if(objValue != ""){
		/* ��ȡ��ѡ���֤������ 
		0|����֤ 1|����֤ 2|���ڲ� 3|�۰�ͨ��֤ 
		4|����֤ 5|̨��ͨ��֤ 6|��������� 7|���� 
		8|Ӫҵִ�� 9|���� A|��֯�������� B|��λ����֤�� C|������ 
		*/
		
		/*��ȡ֤���������� */
		var idTypeText = idTypeVal;
		
		/*��ȡ�������ĺ��ֵĸ���*/
		var m = /^[\u0391-\uFFE5]*$/;
		var chinaLength = 0;
		for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//�ֱ��ȡ��������
          var flag = m.test(code);
          if(flag){
          	chinaLength ++;
          }
    }
      
		/*����Ȳ������������ Ҳ����̨��ͨ��֤ */
		if(idTypeText != "6" && idTypeText != "5"){
			/*��������8�����ĺ���*/
			if(chinaLength < 8){
				rdShowMessageDialog(objName+"���뺬������8�����ĺ��֣�");
				/*��ֵΪ��*/
				obj.value = "";
				
				nextFlag = false;
				return false;
			}
		
	}
	/*��������� ����2������*/
	if(idTypeText == "6"){
		/*����2�����ĺ���*/
			if(chinaLength <= 2){
				rdShowMessageDialog(objName+"���뺬�д���2�����ĺ��֣�");
				
				nextFlag = false;
				return false;
			}
	}
	/*̨��ͨ��֤ ����3������*/
	if(idTypeText == "5"){
		/*��������3���ĺ���*/
			if(chinaLength <= 3){
				rdShowMessageDialog(objName+"���뺬�д���3�����ĺ��֣�");
				
				nextFlag = false;
				return false;
			}
	}
	
	
}
return nextFlag;
}

/*
	2013/11/18 14:01:09
	gaopeng
	֤�����ͱ��ʱ��֤�������У�鷽��
*/

function checkIccIdFuncNew(obj,objType,ifConnect){
	var nextFlag = true;
	
	if(document.all.realUserIccId.v_must !="1") {
	  return nextFlag;
	  return false;		
	}
	
	
	var idTypeVal = "";
	if(objType == 0){
		var objName = "֤������";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "������֤������";
		idTypeVal = document.all.gestoresIdType.value;
	}
	if(objType == 2){
		objName = "ʵ��ʹ����֤������";
		idTypeVal = document.all.realUserIdType.value;
	}
	
	/*ֻ��Ը��˿ͻ�*/
	var opCode = "<%=opCode%>";
	/*��ȡ������ֵ*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*��ȡ�����ֵ�ĳ���*/
	var objValueLength = objValue.length;
	if(objValue != ""){
		/* ��ȡ��ѡ���֤������ 
		0|����֤ 1|����֤ 2|���ڲ� 3|�۰�ͨ��֤ 
		4|����֤ 5|̨��ͨ��֤ 6|��������� 7|���� 
		8|Ӫҵִ�� 9|���� A|��֯�������� B|��λ����֤�� C|������ 
		*/
		
		/*��ȡ֤���������� */
		var idTypeText = idTypeVal;
		
		/*1������֤�����ڱ�ʱ��֤�����볤��Ϊ18λ*/
		if(idTypeText == "0" || idTypeText == "2"){
			if(objValueLength != 18){
					rdShowMessageDialog(objName+"������18λ��");
					
					nextFlag = false;
					return false;
			}
		}
		/*����֤ ����֤ ���������ʱ ֤��������ڵ���6λ�ַ�*/
		if(idTypeText == "1" || idTypeText == "4" || idTypeText == "6"){
			if(objValueLength < 6){
					rdShowMessageDialog(objName+"������ڵ�����λ�ַ���");
					
					nextFlag = false;
					return false;
			}
		}
		/*֤������Ϊ�۰�ͨ��֤�ģ�֤������Ϊ9λ��11λ��������λΪӢ����ĸ��H����M��(ֻ�����Ǵ�д)������λ��Ϊ���������֡�*/
		if(idTypeText == "3"){
			if(objValueLength != 9 && objValueLength != 11){
					rdShowMessageDialog(objName+"������9λ��11λ��");
					
					nextFlag = false;
					return false;
			}
			/*��ȡ����ĸ*/
			var valHead = objValue.substring(0,1);
			if(valHead != "H" && valHead != "M"){
					rdShowMessageDialog(objName+"����ĸ�����ǡ�H����M����");
					
					nextFlag = false;
					return false;
			}
			/*��ȡ����ĸ֮���������Ϣ*/
			var varWithOutHead = objValue.substring(1,objValue.length);
			if(varWithOutHead % 2 != 0 && varWithOutHead % 2 != 1){
					rdShowMessageDialog(objName+"������ĸ֮�⣬����λ�����ǰ��������֣�");
					
					nextFlag = false;
					return false;
			}
		}
		/*֤������Ϊ
			̨��ͨ��֤ 
			֤������ֻ����8λ��11λ
			֤������Ϊ11λʱǰ10λΪ���������֣�
			���һλΪУ����(Ӣ����ĸ���������֣���
			֤������Ϊ8λʱ����Ϊ����������
		*/
		if(idTypeText == "5"){
			if(objValueLength != 8 && objValueLength != 11){
					rdShowMessageDialog(objName+"����Ϊ8λ��11λ��");
					
					nextFlag = false;
					return false;
			}
			/*8λʱ����Ϊ����������*/
			if(objValueLength == 8){
				if(objValue % 2 != 0 && objValue % 2 != 1){
					rdShowMessageDialog(objName+"����Ϊ����������");
					
					nextFlag = false;
					return false;
				}
			}
			/*11λʱ�����һλ������Ӣ����ĸ���������֣�ǰ10λ�����ǰ���������*/
			if(objValueLength == 11){
				var objValue10 = objValue.substring(0,10);
				if(objValue10 % 2 != 0 && objValue10 % 2 != 1){
					rdShowMessageDialog(objName+"ǰʮλ����Ϊ����������");
					
					nextFlag = false;
					return false;
				}
				var objValue11 = objValue.substring(10,11);
  			var m = /^[A-Za-z]+$/;
				var flag = m.test(objValue11);
				
				if(!flag && objValue11 % 2 != 0 && objValue11 % 2 != 1){
					rdShowMessageDialog(objName+"��11λ����Ϊ���������ֻ�Ӣ����ĸ��");
					
					nextFlag = false;
					return false;
				}
			}
			
		}
		/*��֯������ ֤��������ڵ���9λ��Ϊ���֡���-�����д������ĸ*/
		if(idTypeText == "A"){
			var m = /^([0-9\-A-Z]*)$/;
			var flag = m.test(objValue);
			if(!flag){
					rdShowMessageDialog(objName+"���������֡���-�������д��ĸ��ɣ�");
					
					nextFlag = false;
					return false;
			}
			if(objValueLength < 9){
					rdShowMessageDialog(objName+"������ڵ���9λ��");
					
					nextFlag = false;
					return false;
				
			}
		}
		/*Ӫҵִ�� ֤�����������ڵ���4λ���֣����������纺�ֵ��ַ�Ҳ�Ϲ�*/
		if(idTypeText == "8"){
			var m = /^[0-9]+$/;
			var numSum = 0;
			for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//�ֱ��ȡ��������
          var flag = m.test(code);
          if(flag){
          	numSum ++;
          }
    	}
			if(numSum < 4){
					rdShowMessageDialog(objName+"��������4�����֣�");
					
					nextFlag = false;
					return false;
			}
			/*20131216 gaopeng ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� �����е�֤������Ϊ��Ӫҵִ�ա�ʱ��Ҫ��֤�������λ��Ϊ15λ�ַ�*/
			if(objValueLength != 15){
					rdShowMessageDialog(objName+"����Ϊ15���ַ���");
					nextFlag = false;
					return false;
			}
		}
		/*����֤�� ֤��������ڵ���4λ�ַ�*/
		if(idTypeText == "B"){
			if(objValueLength < 4){
					rdShowMessageDialog(objName+"������ڵ���4λ��");
					
					nextFlag = false;
					return false;
			}
			
		}


	}else if(opCode == "1993"){

	}
	return nextFlag;
}

//�·�����
		  function sendProLists(){
				var packet = new AJAXPacket("/npage/sq100/fq100_ajax_sendProLists.jsp","���ڻ�����ݣ����Ժ�......");
				packet.data.add("opCode","<%=opCode%>");
				packet.data.add("phoneNo","<%=phoneNo%>");
				core.ajax.sendPacket(packet,doSendProLists);
				packet = null;
		  } 
		  
		  function doSendProLists(packet){
		  	var retCode = packet.data.findValueByName("retCode");
				var retMsg =  packet.data.findValueByName("retMsg");
				if(retCode != "000000"){
					rdShowMessageDialog( "�·�����ʧ��!<br>������룺"+retCode+"<br>������Ϣ��"+retMsg,0 );
					//��¼Ϊû���
					$("#isSendListFlag").val("N");
				}else{
					rdShowMessageDialog( "�·������ɹ�!" );
					//��¼Ϊ���
					$("#isSendListFlag").val("Y");
				}
		  }
		  
		  //���������ѯ
			function qryListResults(){
				var h=450;
				var w=800;
				var t=screen.availHeight/2-h/2;
				var l=screen.availWidth/2-w/2;
				var prop="dialogHeight:"+h+"px;dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;status:no;help:no";
				var ret=window.showModalDialog("/npage/sq100/f1100_qryListResults.jsp?opCode=<%=opCode%>&opName=<%=opName%>&accp="+Math.random(),"",prop);
				if(typeof(ret) == "undefined"){
					rdShowMessageDialog("���û�й�����ѯ��������Ƚ����·�����������");
					$("#isQryListResultFlag").val("N");//ѡ���˹�����ѯ���
				}else if(ret!=null && ret!=""){
					$("#isQryListResultFlag").val("Y");//ѡ���˹�����ѯ���
					$("#custName").val(ret.split("~")[0]); //�ͻ�����
					$("#idIccid").val(ret.split("~")[1]); //֤������
					if($("#idIccid").val() != ""){
						checkIccIdFunc16New(document.all.idIccid,0,0);
						rpc_chkX('idType','idIccid','A');
					}
					$("#idAddr").val(ret.split("~")[2]);  //֤����ַ
					$("input[name='custAddr']").val(ret.split("~")[2]); //�ͻ���ַ
					$("input[name='contactAddr']").val(ret.split("~")[2]); //��ϵ�˵�ַ
					$("input[name='contactMAddr']").val(ret.split("~")[2]); //��ϵ��ͨѶ��ַ
					$("#idValidDate").val(ret.split("~")[3]); //֤����Ч��
					$("#loginacceptJT").val(ret.split("~")[4]); //������ˮ
					
					$("#idIccid").attr("class","InputGrey");
		  		$("#idIccid").attr("readonly","readonly");
		  		$("#custName").attr("class","InputGrey");
		  		$("#custName").attr("readonly","readonly");
		  		$("#idAddr").attr("class","InputGrey");
		  		$("#idAddr").attr("readonly","readonly");	
		  		$("#idValidDate").attr("class","InputGrey");
		  		$("#idValidDate").attr("readonly","readonly");		
				}
			}  
			
			//ֻ��Ҫ��table����һ��vColorTr='set' ���ԾͿ��Ը��б�ɫ
			$("table[vColorTr='set']").each(function(){
				$(this).find("tr").each(function(i,n){
					$(this).bind("mouseover",function(){
						$(this).addClass("even_hig");
					});
				
					$(this).bind("mouseout",function(){
						$(this).removeClass("even_hig");
					});
				
					if(i%2==0){
						$(this).addClass("even");
					}
				});
			});



	</script>
</head>
<body>
<form action="" method="post" name="frm">
	<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">�û���Ϣ</div>
	</div>
	<table>
		<tr>
			<td class="blue" width="15%">�����˺�</td>
			<td width="15%">
				<span id="cfmLogin"><%=broadPhone%></span>
			</td>
			<td class="blue" width="15%">ҵ��Ʒ��</td>
			<td width="10%">
				<span id="smCode"><%=sNewSmName%></span>
			</td>
			<td class="blue" width="15%">�ͻ�����</td>
			<td>
				<%=(String)custDoc.get(5)%>
			</td>
		</tr>
		<tr>
			<td class="blue" width="15%">��ǰԤ��</td>
			<td>
				<span id="showFee"><%=(String)custDoc.get(20)%></span>
			</td>
			<td class="blue" width="15%">��ǰǷ��</td>
			<td>
				<span><%=(String)custDoc.get(19)%></span>
			</td>
			<td class="blue" width="15%">�ͻ���ַ</td>
			<td>
				<span id="custAddress"><%=(String)custDoc.get(13)%></span>
			</td>
		</tr>
		<tr>
			<td class="blue" width="15%">֤������</td>
			<td>
				<%=(String)custDoc.get(16)%>
			</td>
			<td class="blue" width="15%">��ϵ��</td>
			<td>
				<span id="contactPerson"></span>
			</td>
			<td class="blue" width="15%">��ϵ�绰</td>
			<td>
				<span id="contactPhone"></span>
			</td>
		</tr>
	</table>
</div>
<div id="Operation_Table">
	<div class="title">
		<div id="title_zi">ҵ�����</div>
	</div>
	<table>
		<tr>
			<td class="blue">
				�¿ͻ�ID
			</td>
			<td>
				<input type="text" name="new_cus_id" value="" id="new_cus_id" 
				size="14"  v_must=1 v_maxlength=14 v_type=int v_name="�¿ͻ�ID" maxlength="14" 
				index="15" readonly="readOnly" class="InputGrey"/>
			</td>
			<td  class=blue>
				������
			</td>
			<td width=35% >
				<input v_name="������" name= "xinYiDu" type="text" v_type="int" v_must=1 maxlength="6" value="0" size="10" onBlur="if(this.value!=''){if(checkElement(document.all.xinYiDu)==false){return false;}}; checkXi()" >
				<font class="orange">*</font>
			</td>
		</tr>
		<tr>
    	<td class="blue" >
        ���˿�������
      </td>
      <TD class="blue" colspan="3">
      	<select align="left" name="isJSX" onChange="reSetCustName()" width=50 index="6">
      		<option class="button" value="0">��ͨ�ͻ�</option>
      		<option class="button" value="1">��λ�ͻ�</option>
      	</select>
      	&nbsp;&nbsp;&nbsp;
				<input type="button" id="sendProjectList" name="sendProjectList" class="b_text" value="�·�����" onclick="sendProLists()" style="display:none" />                    
      	&nbsp;&nbsp;&nbsp;
				<input type="button" id="qryListResultBut" name="qryListResultBut" class="b_text" value="���������ѯ" onclick="qryListResults()" style="display:none" />    
      </TD>
    </tr>
		<tr>
			<td class="blue" width="13%">
				<div align="left">�ͻ���������</div>
			</td>
			<td width="30%">
				<select align="left" name=districtCode width=50 index="16">
					<wtc:qoption name="sPubSelect" outnum="2">
					<wtc:sql>select trim(DISTRICT_CODE),DISTRICT_NAME from  SDISCODE Where region_code='<%=regionCode%>' order by DISTRICT_CODE</wtc:sql>
					</wtc:qoption>
				</select>
			</td>
			<td class="blue" width="13%">
				<div align="left">�ͻ�����</div>
			</td>
			<td>
				<input id="custName" name="custName" v_must=0 v_type="string" v_name="�ͻ�����" 
				 onChange="change_ConPerson()" onblur="checkCustNameFunc16New(this,0,0);" 
				  maxlength="30" size=35 index="17">
				<font class="orange">*</font>
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">֤������</div>
			</td>
			<td id="tdappendSome">
                          
      </td>
			<td class="blue">
				<div align="left">֤������</div>
			</td>
			<td>
				<input id="idIccid" name="idIccid" v_must=0 v_type="string" v_name="֤������"  maxlength="18"  index="19" onBlur="checkIccIdFunc16New(this,0,0);rpc_chkX('idType','idIccid','A');">
				<font class="orange">*</font>
				<input name=IDQueryJustSee type=button class="b_text" 
				 style="cursor:hand" onClick="getInfo_IccId_JustSee()" 
				 id="custIdQueryJustSee" value="��Ϣ��ѯ" />
			</td>
		</tr>
		<TR id="card_id_type">
			<td colspan=2 align=center>
				<input type="button" id="read_idCard_one" name="read_idCard_one" class="b_text"   value="ɨ��һ������֤" onClick="RecogNewIDOnly_oness()" >
				<input type="button" name="read_idCard_two" class="b_text"   value="ɨ���������֤" onClick="RecogNewIDOnly_twoss()">
				<input type="button" name="scan_idCard_two" class="b_text"   value="����" onClick="Idcardss()" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" name="scan_idCard_two222" id="scan_idCard_two222" class="b_text"   value="����(2��)" onClick="Idcard2('1')" >
			</td>
			<td  class="blue">
				֤����Ƭ�ϴ�
			</td>
			<td>
				<input type="file" name="filep" id="filep" onchange="chcek_pic1121();" >    &nbsp;
				<iframe name="upload_frame" id="upload_frame" style="display:none"></iframe>
				<input type="hidden" name="idSexH" value="1">
				<input type="hidden" name="birthDayH" value="20090625">
				<input type="hidden" name="idAddrH" value="������">
				<input type="button" name="uploadpic_b" class="b_text"  
				 value="�ϴ���Ƭ" onClick="uploadpic()"  disabled>
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">֤����ַ</div>
			</td>
			<td>
				<input id="idAddr" name=idAddr v_must=0 v_type="string" v_name="֤����ַ" v_maxlength=60 maxlength="60" size="30" index="20" onBlur="if(checkElement(this)){checkAddrFunc(this,0,0)}">
				<font class="orange">*</font>
			</td>
			<td class="blue">
				<div align="left">֤����Ч��</div>
			</td>
			<td>
				<input name="idValidDate" id="idValidDate" v_must=0 v_maxlength=8 v_type="date" v_name="֤����Ч��" maxlength=8 size="8" index="21" onBlur="chkValid();" v_format="yyyyMMdd" style="ime-mode:disabled" onKeyPress="return isKeyNumberdot(0)" >
			</td>
		</tr>
		<tr id ="divPassword" style="display:;">
			<td class="blue">
				<div align="left">�ͻ�����</div>
			</td>
			<td>
				<input name="custPwd" type="password" onblur="" class="button"  maxlength="6">
				<input id="bttn1" name="bttn1" type="button" value="����"  class="b_text" >
				<font class="orange">*</font>
			</td>
			<td class="blue">
				<div align="left">У��ͻ�����</div>
			</td>
			<td>
				<input  name="cfmPwd" type="password"  class="button" prefield="cfmPwd" filedtype="pwd"  maxlength="6">
				<input onclick="showNumberDialog(document.all.cfmPwd);" id="btn2" type="button" value="������" class="b_text" >
				<font class="orange">*</font>
			</td>
		</tr>
		<script type="text/javascript">
			var btn1Obj = document.getElementById("bttn1");
			btn1Obj.attachEvent("onclick",foo);
			btn1Obj.attachEvent("onclick",doo);
			function foo(){
				chkPwdEasy1(document.all.custPwd.value);
			}
			function doo(){
				showNumberDialog(document.all.custPwd);
			}
		</script>
		<tr>
			<td class="blue">
				<div align="left">�ͻ�״̬</div>
			</td>
			<td colspan="3">
				<select align="left" name=custStatus width=50 index="24">
					<wtc:qoption name="sPubSelect" outnum="2">
						<wtc:sql>select trim(STATUS_CODE),STATUS_NAME from sCustStatusCode order by STATUS_CODE</wtc:sql>
					</wtc:qoption>
				</select>
				<select  align="left" name=custGrade width=50 index="25" style="display:none">
					<wtc:qoption name="sPubSelect" outnum="2">
						<wtc:sql>select trim(OWNER_CODE), TYPE_NAME from sCustGradeCode where REGION_CODE ='<%=regionCode%>' order by OWNER_CODE</wtc:sql>
					</wtc:qoption>
				</select>
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">�ͻ���ַ</div>
			</td>
			<td colspan="3">
				<input name=custAddr v_type="string" v_must=0 v_name="�ͻ���ַ"  v_maxlength=60 maxlength="60" size=35 index="26" onBlur="if(checkElement(this)){checkAddrFunc(this,1,0);}">
				<font class="orange">*</font> </td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">��ϵ������</div>
			</td>
			<td>
				<input name="newContactPerson" id="newContactPerson" v_must=0 v_type="string" v_name="��ϵ������" onblur="checkCustNameFunc(this,1,0);" maxlength="20" size=20 index="27" v_maxlength=20>
				<font class="orange">*</font>
			</td>
			<td class="blue">
				<div align="left">��ϵ�˵绰</div>
			</td>
			<td>
				<input name="newContactPhone" id="newContactPhone" v_must=0 v_type="phone" v_name="��ϵ�˵绰" maxlength="20"  index="28" size="20">
				<font class="orange">*</font> </td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">��ϵ�˵�ַ</div>
			</td>
			<td>
				<input name=contactAddr  v_must=0 v_type="string" v_name="��ϵ�˵�ַ" v_maxlength=60 maxlength="60" size=55 index="29" onBlur="if (checkElement(this)){ checkAddrFunc(this,2,0) }">
				<font class="orange">*</font> </td>
			<td class="blue">
				<div align="left">��ϵ���ʱ�</div>
			</td>
			<td>
				<input name=contactPost v_type="zip" v_name="��ϵ���ʱ�" maxlength="6"  index="30" size="20">
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">��ϵ�˴���</div>
			</td>
			<td>
				<input name=contactFax v_must=0 v_type="phone" v_name="��ϵ�˴���" maxlength="20"  index="31" size="20">
			</td>
			<td class="blue">
				<div align="left">��ϵ��E_MAIL</div>
			</td>
			<td>
				<input name=contactMail v_must=0 v_type="email" v_name="��ϵ��EMAIL" maxlength="30" size=30 index="32">
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">��ϵ��ͨѶ��ַ</div>
			</td>
			<td colspan="3">
				<input name=contactMAddr v_must=0 v_type="string" v_name="��ϵ��ͨѶ��ַ" v_maxlength=60 maxlength="60" size=55 index="33" onBlur="if(checkElement(this)){checkAddrFunc(this,3,0)};">
				<font class="orange">*</font>
			</td>
		</tr>
		<!--2016/2/29 13:20:46 gaopeng ����Э����������ʵ���Ʊ�ʶ���������ֱ�������ĺ���BOSS�ࣩ
			���Ӿ�������Ϣ
		 -->
		<%@ include file="/npage/sq100/gestoresInfo.jsp" %>
		<%@ include file="/npage/sq100/responsibleInfo.jsp" %>
		<%@ include file="/npage/sq100/realUserInfo.jsp" %>

   	
		
		<tr>
			<td class="blue">
				<div align="left">�ͻ��Ա�</div>
			</td>
			<td>
				<select align="left" name=custSex width=50 index="34">
					<wtc:qoption name="sPubSelect" outnum="2">
						<wtc:sql>select trim(SEX_CODE), SEX_NAME from ssexcode order by SEX_CODE</wtc:sql>
					</wtc:qoption>
				</select>
			</td>
			<td class="blue">
				<div align="left">��������</div>
			</td>
			<td>
				<input name=birthDay maxlength=8 index="35"  v_must=0 v_maxlength=8 v_type="date" v_name="��������" size="8" v_format="yyyyMMdd" onblur="checkElement(this);">
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">ְҵ���</div>
			</td>
			<td>
				<select align="left" name=professionId width=50 index="36">
					<wtc:qoption name="sPubSelect" outnum="2">
						<wtc:sql>select trim(PROFESSION_ID), PROFESSION_NAME from sprofessionid order by PROFESSION_ID DESC</wtc:sql>
					</wtc:qoption>
				</select>
			</td>
			<td class="blue">
				<div align="left">ѧ��</div>
			</td>
			<td>
				<select align="left" name=vudyXl width=50 index="37">
					<wtc:qoption name="sPubSelect" outnum="2">
						<wtc:sql>select trim(WORK_CODE), TYPE_NAME from SWORKCODE Where region_code ='<%=regionCode%>' order by work_code DESC</wtc:sql>
					</wtc:qoption>
				</select>
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">�ͻ�����</div>
			</td>
			<td>
				<input name=custAh maxlength="20"  index="38" size="20">
			</td>
			<td class="blue">
				<div align="left">�ͻ�ϰ��</div>
			</td>
			<td>
				<input name=custXg maxlength="20"  index="39">
			</td>
			</tr>
	</table>
	
	
	<table cellspacing="0">
		
		<!-- 20091201 begin -->
		<TR style="display:none" id="Good_PhoneDate_GSM" >
			<TD nowrap class=blue width="13%">
				<div align="left">ԭ��������������</div>
			</TD>
			<TD nowrap>
				<select name ="GoodPhoneFlag" onchange="GoodPhoneDateChg();">
					<option class='button' value='0' selected>--��ѡ��--</option>
					<option class='button' value='Y' >��������</option>
					<option class='button' value='N' >����������</option>
				</select>
			</TD>
			<TD nowrap class=blue width="13%">
				<div align="left" >�ɰ���������ʱ��</div>
			</TD>
			<TD nowrap colspan="3">
				<input id="GoodPhoneDate" class="button" name="GoodPhoneDate" maxlength="8" disabled >
				<font class="orange">(��ʽYYYYMMDD)</font>&nbsp;&nbsp;
			</TD>
		</TR>
		<!-- 20091201 end -->
		<tr>
			<td class="blue" width="13%">
				<div align="left">������</div>
			</td>
			<td width="20%">
				<div align="left">
					<input type="text" name="t_handFee" id="t_handFee" size="16" 
					value="<%=(((String)custDoc.get(30)).trim().equals(""))?("0"):(((String)custDoc.get(30)).trim()) %>" 
					v_type=float v_name="������" <%if(hfrf){%>readonly<%}%> 
					onblur="ChkHandFee()" index="40">
				</div>
			</td>
			<td class="blue" width="13%">
				<div align="left">ʵ��</div>
			</td>
			<td width="20%">
				<div align="left">
					<input type="text" name="t_factFee" id="t_factFee" index="41" 
						size="16"  onKeyUp="getFew()" v_type=float v_name="ʵ��"
					<%
					System.out.println("hfrf====="+hfrf);
					if(hfrf){
						if(((String)custDoc.get(30)).trim().equals("") || ((String)custDoc.get(30)).trim().equals("0")  || Double.parseDouble(((String)(custDoc.get(30))))==0)
						{
						%>
							readonly
						<%
						}
					}
					%>
					>
				</div>
			</td>
			<td class="blue" width="13%">
				<div align="left">����</div>
			</td>
			<td width="20%">
				<div align="left">
					<input type="text" name="t_fewFee" id="t_fewFee" size="16" readonly>
				</div>
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">���ϲ�ѯ</div>
			</td>
			<td nowrap colspan="5">
				<select name ="print_query" >
					<% //<option class='button' value='Y' >��</option> %>
					<option class='button' value='N' selected>��</option>
				</select>
				<font class="orange">* ˵��:�»����Ƿ���Ȩ�쿴����ǰ����������</font>
			</td>
		</tr>
		<tr>
			<td class="blue">
				<div align="left">ϵͳ��ע</div>
			</td>
			<td nowrap colspan="5">
				<div align="left">
					<input type="text" name="t_sys_remark" id="t_sys_remark" size="60" readonly maxlength=60>
				</div>
			</td>
		</tr>
		<tr style="display:none">
			<td class="blue">
				<div align="left">�û���ע</div>
			</td>
			<td nowrap colspan="5">
				<div align="left">
					<input type="text" name="t_op_remark" id="t_op_remark" size="60"	v_maxlength=60  v_type=string  v_name="�û���ע" maxlength=60 >
				</div>
			</td>
		</tr>
		<tr >
			<td class="blue">�û���ע</td>
			<td nowrap colspan="5">
				<input name=assuNote v_must=0 v_maxlength=60 v_type="string" v_name="�û���ע" maxlength="60" size=60  value="" index="42">
			</td>
		</tr>
	</table>
	<jsp:include page="/npage/public/hwReadCustCard.jsp">
		<jsp:param name="hwAccept" value="<%=loginAccept%>"  />
		<jsp:param name="showBody" value="01"  />
	</jsp:include>
	
	<table>
		<tr > 
			<td id="footer">
			<input name="confirm" type="button" class="b_foot" value="ȷ��&��ӡ" onClick="printCommit()" />
			&nbsp; 
			<input name="reset" type="reset" class="b_foot" value="���" />
			&nbsp; 
			<input name="back" onClick="removeCurrentTab();" type="button" class="b_foot" value="�ر�" />
			&nbsp;
			</td>
		</tr>
	</table>
	<!-- ���ر������֣�Ϊ��һҳ�洫���� -->
	<input type="hidden" name="opCode" id="opCode" />
	<input type="hidden" name="opName" id="opName" />
	<input type="hidden" name="srv_no" id="srv_no" value="<%=phoneNo%>">
	<input type="hidden" name="cust_name" id="cust_name" value="<%=(String)custDoc.get(5)%>">
  <input type="hidden" name="cust_addr" id="cust_addr" value="<%=(String)custDoc.get(13)%>">
	<input type="hidden" name="regionCode" id="regionCode" value="<%=regionCode%>">
 	<input type="hidden" name="ic_no" id="ic_no" value="<%=(String)custDoc.get(16)%>">
	<input type="hidden" name="user_id" id="user_id" value="<%=(String)custDoc.get(0)%>">
	<input type="hidden" name="oriHandFee" id="oriHandFee" value="<%=((String)custDoc.get(23))%>">
  <input type="hidden" name="oldPass" id="oldPass" value="<%=((String)custDoc.get(6)).trim()%>">
  <input type="hidden" name="workno" value=<%=workNo%>>
	
	<input type="hidden" name="card_flag" value="">  <!--����֤������־-->
  <input type="hidden" name="m_flag" value="">   <!--ɨ����߶�ȡ��־������ȷ���ϴ�ͼƬʱ���ͼƬ��-->
  <input type="hidden" name="sf_flag" value="">   <!--ɨ���Ƿ�ɹ���־-->
  <input type="hidden" name="pic_name" value="">   <!--��ʶ�ϴ��ļ�������-->
	<input type="hidden" name="up_flag" value="0">
	<input type="hidden" name="but_flag" value="0"> <!--��ť�����־-->
	<input type="hidden" name="upbut_flag" value="0"> <!--�ϴ���ť�����־-->
	<input type="hidden" name="custId" value="0">
	<input type="hidden" name="card2flag" value="0">
	<input type="hidden" name="loginAccept" value="<%=loginAccept%>">
	<input type="hidden" name="broadPhone" value="<%=broadPhone%>">
<input type="hidden" name="isSendListFlag" id="isSendListFlag" value="N" />
  <input type="hidden" name="isQryListResultFlag" id="isQryListResultFlag" value="N" />
  <input type="hidden" name="sendListOpenFlag" id="sendListOpenFlag" value="<%=sendListOpenFlag%>" />
  <input type="hidden" name="loginacceptJT" id="loginacceptJT" />
	<%@ include file="/npage/include/footer.jsp" %> 
	<%@ include file="/npage/common/pwd_comm.jsp" %>
	<%@ include file="/npage/include/public_smz_check.jsp" %>
</form>
</body>
	<%@ include file="/npage/public/hwObject.jsp" %> 
 	 <%@ include file="/npage/s1210/interface_provider1238.jsp" %> 
</html>