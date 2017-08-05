<%
    /********************
     * @ OpCode    :  7897
     * @ OpName    :  ���ų�Ա�ʷѱ��
     * @ CopyRight :  si-tech
     * @ Author    :  qidp
     * @ Date      :  2009-10-13
     * @ Update    :
     ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    String opCode = "7897";
    String opName = "���ų�Ա�ʷѱ��";

    String workNo = WtcUtil.repNull((String)session.getAttribute("workNo"));
    String workName = WtcUtil.repNull((String)session.getAttribute("workName"));
    String orgCode = WtcUtil.repNull((String)session.getAttribute("orgCode"));
    String regionCode = WtcUtil.repNull((String)session.getAttribute("regCode"));

    /**************
     * ȡ������ˮ
     **************/
    String sysAccept = "";
    %>
        <wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>"  id="seq"/>
    <%
    sysAccept = seq;
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>���ų�Ա���Ա��</title>

<script type=text/javascript>
    /* ��ȡ�����û���Ϣ */
    function getCustInfo(){
        var pageTitle = "���ſͻ�ѡ��";

        var fieldName = "֤������|���ſͻ�ID|���ſͻ�����|���Ų�ƷID|���ź�|��Ʒ����|��Ʒ����|���ű��|��Ʒ�����ʻ�|Ʒ�ƴ���|Ʒ������|���±�ʶ|��������|";
        var sqlStr = "";
        var selType = "S";    //'S'��ѡ��'M'��ѡ
        var retQuence = "11|0|1|7|4|5|9|10|3|2|6|12|";

        var retToField = "iccid|cust_id|unit_id|user_no|product_id|sm_code|sm_name|id_no|cust_name|product_name|requestType|";
        /**add by liwd 20081127,group_id����dcustDoc��group_id end **/

        if(document.frm.iccid.value == "" && document.frm.cust_id.value == "" && document.frm.unit_id.value == "" && document.frm.user_no.value == "")
        {
            rdShowMessageDialog("������֤�����롢�ͻ�ID������ID���źŽ��в�ѯ��");
            document.frm.iccid.focus();
            return false;
        }

        if((document.frm.cust_id.value) != "" && forNonNegInt(frm.cust_id) == false)
        {
            frm.cust_id.value = "";
            rdShowMessageDialog("�ͻ�ID���������֣�");
            return false;
        }

        if((document.frm.unit_id.value) != "" && forNonNegInt(frm.unit_id) == false)
        {
            frm.unit_id.value = "";
            rdShowMessageDialog("����ID���������֣�");
            return false;
        }

        PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
    }

    function PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField){
        var path = "<%=request.getContextPath()%>/npage/s7897/fpubcust_sel.jsp";
        path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
        path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
        path = path + "&selType=" + selType+"&iccid=" + document.frm.iccid.value;
        path = path + "&cust_id=" + document.frm.cust_id.value;
        path = path + "&unit_id=" + document.frm.unit_id.value;
        path = path + "&service_no=" + document.frm.user_no.value;
        path = path + "&regionCode=" + document.frm.iRegionCode.value;
        retInfo = window.open(path,"newwindow","height=450, width=1000,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
    	return true;
    }

    function getvaluecust(retInfo){
        var retToField = "iccid|cust_id|unit_id|user_no|product_id|sm_code|sm_name|id_no|cust_name|product_name|requestType|";
        if(retInfo ==undefined)
        {   return false;   }

    	var chPos_field = retToField.indexOf("|");
        var chPos_retStr;
        var valueStr;
        var obj;
        while(chPos_field > -1)
        {
            obj = retToField.substring(0,chPos_field);
            chPos_retInfo = retInfo.indexOf("|");
            valueStr = retInfo.substring(0,chPos_retInfo);
            document.all(obj).value = valueStr;
            retToField = retToField.substring(chPos_field + 1);
            retInfo = retInfo.substring(chPos_retInfo + 1);
            chPos_field = retToField.indexOf("|");
        }

        $("#iccid").attr("readOnly",true);
        $("#cust_id").attr("readOnly",true);
        $("#unit_id").attr("readOnly",true);
        $("#user_no").attr("readOnly",true);
        $("#id_no").attr("readOnly",true);
        $("#cust_name").attr("readOnly",true);
        $("#product_id").attr("readOnly",true);
        $("#requestType").attr("readOnly",true);
        $("#product_name").attr("readOnly",true);

        $("#iccid").addClass("InputGrey");
        $("#cust_id").addClass("InputGrey");
        $("#unit_id").addClass("InputGrey");
        $("#user_no").addClass("InputGrey");
        $("#id_no").addClass("InputGrey");
        $("#cust_name").addClass("InputGrey");
        $("#product_id").addClass("InputGrey");
        $("#product_name").addClass("InputGrey");

        checkWorkNoPerm();

        set_MM_pl();
    }

/*
 * hejwa yull 2016/11/2 9:24:12 add
 * 1�� ������������
 *   ��1�� ��ԡ���7897�����ų�Ա�ʷѱ�������M2Mҵ��������������Ա�ʷѱ��������ֻ���M2M�ĳ�Ա�ʷѣ�
 *       ���д����ʷѱ����������Ա�ʷ�ԤԼ��Ч�������е���������Ա�ʷѱ��������ͬ��
 *   ��2�� ��ԡ���7896�����ų�Ա���Ա�������棬������������M2M�ۿ��ʷѵĹ��ܣ��˴�ֻ�����ۿ��ʷѣ��ۿ��ʷ�ԤԼ��Ч��
 */
function set_MM_pl(){
	if($("#sm_code").val()=="MM"){
		$("#div_mm_chg_type").show();
	}else{
		$("#div_mm_chg_type").hide();
	}
}
    /* �жϹ��Ż����Ƿ��а�����ҵ���Ȩ�� */
    function checkWorkNoPerm(){
        var vSmCode = $("#sm_code").val();
        var vOpType = "m03";
        var vRequestType = "";
        var vProductId = $("#product_id").val();
        var vCustId = $("#cust_id").val();
        var vIdNo = $("#id_no").val();

        var checkWorkNoPermPacket = new AJAXPacket("<%=request.getContextPath()%>/npage/s7897/checkWorkNoPerm.jsp","���ڲ�ѯ����Ȩ����Ϣ�����Ժ�......");
    	checkWorkNoPermPacket.data.add("smCode",vSmCode);
    	checkWorkNoPermPacket.data.add("opType",vOpType);
    	checkWorkNoPermPacket.data.add("requestType",vRequestType);
    	checkWorkNoPermPacket.data.add("productId",vProductId);
    	checkWorkNoPermPacket.data.add("custId",vCustId);
    	checkWorkNoPermPacket.data.add("idNo",vIdNo);
    	core.ajax.sendPacket(checkWorkNoPermPacket,doCheckWorkNoPermPacket,true);
    	checkWorkNoPermPacket = null;
    }

    function doCheckWorkNoPermPacket(packet){
        var returnCode = packet.data.findValueByName("retCode");
        var returnMsg = packet.data.findValueByName("retMsg");

        if(returnCode == "000000"){

        }else if(returnCode == "999999"){
            rdShowMessageDialog("ȡ����Ȩ����Ϣʧ�ܣ�<br/>������Ϣ:"+returnMsg,0);
            window.location="f7897_1.jsp";
        }else{
            rdShowMessageDialog("������룺"+returnCode+"<br/>������Ϣ:"+returnMsg,0);
            window.location="f7897_1.jsp";
        }
    }

    /* ��ȡ��Ա�ʷ���Ϣ */
    function queryPhoneNo(){
        if($("#phone_no").val() == ""){
            rdShowMessageDialog("��Ա�ֻ����벻��Ϊ�գ�",0);
            $("#phone_no").select();
            $("#phone_no").focus();
            return false;
        }

        var vPhoneNo = $("#phone_no").val();
        var vSmCode = $("#sm_code").val();
        var vGrpIdNo = $("#id_no").val();
        var vOpCode = "<%=opCode%>";
        var vWorkNo = "<%=workNo%>";
        var vProductId = $("#product_id").val();
        var vRequestType=$("#requestType").val();

        var queryPhoneNoPacket = new AJAXPacket("<%=request.getContextPath()%>/npage/s7897/queryPhoneNo.jsp","���ڲ�ѯ��Ա��Ϣ�����Ժ�......");
    	queryPhoneNoPacket.data.add("phoneNo",vPhoneNo);
    	queryPhoneNoPacket.data.add("smCode",vSmCode);
    	queryPhoneNoPacket.data.add("grpIdNo",vGrpIdNo);
    	queryPhoneNoPacket.data.add("opCode",vOpCode);
    	queryPhoneNoPacket.data.add("workNo",vWorkNo);
    	queryPhoneNoPacket.data.add("productId",vProductId);
    	queryPhoneNoPacket.data.add("requestType",vRequestType);
    	core.ajax.sendPacket(queryPhoneNoPacket,doQueryPhoneNo);
    	queryPhoneNoPacket = null;
    }

    /* ��ȡAJAX����queryPhoneNo()�ķ���ֵ,���д��� */
    function doQueryPhoneNo(packet){
        var returnCode = packet.data.findValueByName("retCode");
        var returnMsg = packet.data.findValueByName("retMsg");

        if(returnCode == "000000"){
            var rUserIdNo = packet.data.findValueByName("userIdNo");
            var rSmCode = packet.data.findValueByName("smCode");
            var rSmName = packet.data.findValueByName("smName");
            var rCustName = packet.data.findValueByName("custName");
            var rUserPwd = packet.data.findValueByName("userPwd");
            var rMainRate = packet.data.findValueByName("mainRate");
            var rMainRateName = packet.data.findValueByName("mainRateName");
            var rRunCode = packet.data.findValueByName("runCode");
            var rRunNameErr = packet.data.findValueByName("runNameErr");
            var rIccid = packet.data.findValueByName("iccid");
            var rCustAddr = packet.data.findValueByName("custAddr");

            $("#user_id").val(rUserIdNo);
            $("#user_name").val(rCustName);
            $("#fee_code").val(rMainRate);
            $("#fee_name").val(rMainRateName);

            $("#phone_no").attr("readOnly",true);
            $("#phone_no").addClass("InputGrey");
        }else if(returnCode == "999998"){
            rdShowMessageDialog("û�д˳�Ա��Ϣ�����������룡",0);
            $("#phone_no").val("");
            $("#phone_no").focus();
        }else{
            rdShowMessageDialog("������룺"+returnCode+",������Ϣ��"+returnMsg,0);
            $("#phone_no").val("");
            $("#phone_no").focus();
        }
    }

    /* ��ȡ���ʷ���Ϣ */
    function queryRate(){
        var vUserType = "";
        var vBizCode = "";
        var vMebMonthFlag = "Y";
        var vGrpProdCode = $("#product_id").val();
        var vRegionCode = $("#iRegionCode").val();
        var vSmCode = $("#sm_code").val();
        var vOpType = "";
        var vOpCode = $("#op_code").val();
        var vOldFeeCode = $("#fee_code").val();
        var vIdNo = $("#id_no").val();
		var vPhoneNo = $("#phone_no").val();//haoyy add 20120216 ��������������ͨҵ���������ʾ

				//2���޸�ҳ����÷���sGetAddProduct���߼����֣����ѡ������
				//�±� 8����δ�0
				if($("input[name='mm_chg_type']:checked").val()=="2"){
					vOldFeeCode = "0";
				}
        var path = "queryRate.jsp";
        path = path + "?userType=" + vUserType + "&bizCode=" + vBizCode;
        path = path + "&mebMonthFlag=" + vMebMonthFlag + "&grpProdCode=" + vGrpProdCode;
        path = path + "&regionCode=" + vRegionCode + "&smCode=" + vSmCode;
        path = path + "&opType=" + vOpType;
        path = path + "&opCode=" + vOpCode;
        path = path + "&oldFeeCode=" + vOldFeeCode;
        path = path + "&idNo=" + vIdNo;
        path = path + "&phoneNo=" + vPhoneNo;//haoyy add 20120216 ��������������ͨҵ���������ʾ
        retInfo = window.open(path,"newwindow","height=450, width=400,top=90,left=300,scrollbars=yes, resizable=no,location=no, status=yes");
    	return true;
    }

    /* ����queryRate()�����л�ȡ�����ʷ���Ϣ����queryRate.jsp�е��� */
    function doQueryRate(rateCode,rateName){
        $("#new_fee_code").val(rateCode);
        $("#new_fee_name").val(rateName);
    }

    /* �ύ */
    function refMain(){
        if($("#id_no").val() == ""){
            rdShowMessageDialog("�����û�ID����Ϊ�գ�",0);
            $("#id_no").select();
            $("#id_no").focus();
            return false;
        }
        if($("#user_no").val() == ""){
            rdShowMessageDialog("�����ⲿ��Ų���Ϊ�գ�",0);
            $("#user_no").select();
            $("#user_no").focus();
            return false;
        }


			var cfm_phoneNo = "";
			
			if($("input[name='mm_chg_type']:checked").val()=="1"){
				//��������ԭУ���߼�
        if($("#phone_no").val() == ""){
            rdShowMessageDialog("��Ա�ֻ����벻��Ϊ�գ�",0);
            $("#phone_no").select();
            $("#phone_no").focus();
            return false;
        }else{
            if(!forMobil(document.all.phone_no)){
                return false;
            }
        }
        
        cfm_phoneNo = $("#phone_no").val()+"|";
        
      }else{
      	if(!check_bath_phoneNo()){
      		return false;
      	}
      	
      		var phoneNoText = $("#textarea_batch").text().trim();
					var phoneNo_arr = phoneNoText.split("|");
	
      		for(var i=0;i<phoneNo_arr.length;i++){
						phoneNo_temp = phoneNo_arr[i].trim();
				
						if(phoneNo_temp!=""){
							cfm_phoneNo = cfm_phoneNo + phoneNo_temp +"|";
						}
					}
					
      	
      }
      
				$("#cfmPnoneNo").val(cfm_phoneNo);
				
        if($("#new_fee_code").val() == ""){
            rdShowMessageDialog("��Ա���ʷѴ��벻��Ϊ�գ�",0);
            $("#new_fee_code").select();
            $("#new_fee_code").focus();
            return false;
        }

        $("#opNote").val("����Ա<%=workNo%>���м��ų�Ա�ʷѱ��������");

        showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes");

        var confirmFlag=0;
		confirmFlag = rdShowConfirmDialog("�Ƿ��ύ���β�����");
		if (confirmFlag==1) {
		    $("#bSure").attr("disabled",true);
			frm.action="f7897_2.jsp";
    		frm.method="post";
    		frm.submit();
    		$("bSure").attr("disabled",true);
    		loading();
		}
    }

	//��ӡ��Ϣ
	function printInfo(printType)
	{
		var retInfo = "";
		var tmpOpCode= "<%=opCode%>";

		retInfo+='<%=workName%>'+"|";
    	retInfo+='<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
    	retInfo+="֤������:"+document.frm.iccid.value+"|";
    	retInfo+="�û�����:"+document.frm.cust_name.value+"|";
    	retInfo+="���Ų�Ʒ����:"+document.frm.product_name.value+"|";
    	retInfo+=""+"|";
        retInfo+=""+"|";
        retInfo+=""+"|";
        retInfo+=""+"|";
        retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+="ҵ�����ͣ����ų�Ա�ʷѱ��"+"|";
    	retInfo+="��ˮ��"+document.frm.sys_accept.value+"|";
    	retInfo+=" "+"|";
    	retInfo+=" "+"|";
    	retInfo+=" "+"|";
    	retInfo+=" "+"|";
    	retInfo+=" "+"|";
    	retInfo+=" "+"|";
    	retInfo+="���ʷѣ�"+document.frm.new_fee_name.value+"|";
    	retInfo+=document.frm.opNote.value+"|";
		return retInfo;

	}

    function showPrtDlg(printType,DlgMessage,submitCfm){
        var h=200;
		var w=352;
		var t=screen.availHeight/2-h/2;
		var l=screen.availWidth/2-w/2;
		var printStr = printInfo(printType);
		if(printStr == "failed")
		{
			return false;
		}
		var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no"
		var path = "<%=request.getContextPath()%>/npage/innet/hljPrint.jsp?DlgMsg=" + DlgMessage;
		var path = path + "&printInfo=" + printStr + "&submitCfm=" + submitCfm;
		var ret=window.showModalDialog(path,"",prop);
    }

    /* У�鼯�Ų�Ʒ���� */
    function chkProductPwd(){
        var cust_id = document.all.cust_id.value;
        var Pwd1 = document.all.product_pwd.value;
        var checkPwd_Packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s7897/pubCheckPwd.jsp","���ڽ�������У�飬���Ժ�......");
        checkPwd_Packet.data.add("retType","checkPwd");
    	checkPwd_Packet.data.add("cust_id",cust_id);
    	checkPwd_Packet.data.add("Pwd1",Pwd1);
    	core.ajax.sendPacket(checkPwd_Packet);
    	checkPwd_Packet = null;
    }

    function doProcess(packet)
    {
        error_code = packet.data.findValueByName("errorCode");
        error_msg =  packet.data.findValueByName("errorMsg");
        verifyType = packet.data.findValueByName("verifyType");
        var backArrMsg = packet.data.findValueByName("backArrMsg");
        var backArrMsg1 = packet.data.findValueByName("backArrMsg1");
        self.status="";

        if(verifyType == "checkPwd") //���ſͻ�����У��
        {
            if(error_code == "000000")
            {
                var retResult = packet.data.findValueByName("retResult");
                if (retResult == "false") {
                    rdShowMessageDialog("�ͻ�����У��ʧ�ܣ����������룡",0);
                    frm.product_pwd.value = "";
                    frm.product_pwd.focus();
                    return false;
                } else {
                    rdShowMessageDialog("�ͻ�����У��ɹ���",2);
                    $("#bSure").attr("disabled",false);
                    $("#phoneno_query").attr("disabled",false);
                    $("#fee_query").attr("disabled",false);
                }
            }
            else
            {
                rdShowMessageDialog("�ͻ�����У�������������У�飡",0);
                return false;
            }
        }
        else{
            rdShowMessageDialog("������룺"+error_code+"������Ϣ��"+error_msg+"",0);
            return false;
        }
    }

//У���ֻ����룺���������ֿ�ͷ���������⣬�ɺ��С�-��
function forMobilPhoneNo(val){
	var patrn=/^((\(\d{3}\))|(\d{3}\-))?[12][0358]\d{9}$/;
	var sInput = val;
	if(sInput.search(patrn)==-1){
		return false;
	}
	return true;
}

function check_bath_phoneNo(){

	var phoneNoText = $("#textarea_batch").text().trim();

	if(phoneNoText==""){
		rdShowMessageDialog("�������벻��Ϊ��");
		return false;
	}

	var phoneNo_arr = phoneNoText.split("|");

	var count_phoneNo = 0;


	var phoneNo_temp = "";
	for(var i=0;i<phoneNo_arr.length;i++){
		phoneNo_temp = phoneNo_arr[i].trim();
		if(phoneNo_temp!=""){
			count_phoneNo ++;
		}
	}
	$("#count_phoneNo").text(count_phoneNo+"");

	count_phoneNo = 0;
	phoneNo_temp = "";
	var is_ok = 0;
	for(var i=0;i<phoneNo_arr.length;i++){
		phoneNo_temp = phoneNo_arr[i].trim();

		if(phoneNo_temp!=""){
			if(!forMobilPhoneNo(phoneNo_temp)){
				is_ok = 1;
				break;
			}

			//�ָ����ȴ���2�϶����ظ���
			if(phoneNoText.split(phoneNo_temp).length>2){
				is_ok = 2;
				break;
			}

			count_phoneNo ++;
		}
	}


	if(count_phoneNo>50){
		rdShowMessageDialog("������������50��");
		return false;
	}

	if(is_ok==1){
		rdShowMessageDialog("�б������ݣ�"+phoneNo_temp+" �����ֻ���");
		return false;
	}else if(is_ok==2){
		rdShowMessageDialog("�б������ݣ�"+phoneNo_temp+" Ϊ�ظ�����");
		return false;
	}{
		return true;
	}

}

function chg_MM_tab_show(flag){
	if(flag=="1"){
		$("#MM_batch").hide();
		$("#MM_general").show();
		//$("#fee_query").attr("disabled","disabled");
	}else{
		$("#MM_batch").show();
		$("#MM_general").hide();
		//$("#fee_query").removeAttr("disabled");
	}
		$("#textarea_batch").text("");
		$("#count_phoneNo").text("0");
	  $("#new_fee_code").val("");
	  $("#new_fee_name").val("");
	  
}
</script>

</head>
<body>
<form name="frm" action="" method="post" >
<%@ include file="/npage/include/header.jsp" %>
<div class="title">
	<div id="title_zi">�����û���Ϣ</div>
</div>
<table cellspacing=0>
    <tr>
        <td class='blue' nowrap width='18%'>֤������</td>
        <td width='32%'>
            <input name='iccid' id='iccid' maxlength='18' v_type='string' v_must='1' index='1' />
            <input type='button' class='b_text' name='iccid_query' id='iccid_query' value='��ѯ' onClick="getCustInfo()" />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap width='18%'>���ſͻ�ID</td>
        <td width='32%'>
            <input type='text' id='cust_id' name='cust_id' value='' v_must='1' />
            <font class='orange'>*</font>
        </td>
    </tr>

    <TR>
        <td class='blue' nowrap>���ű��</TD>
        <TD>
            <input name=unit_id id="unit_id" value=""  maxlength="11" v_type="0_9" v_must=1 index="3"  >
            <font class="orange">*</font>
        </TD>
        <TD class="blue">���źŻ����������</TD>
        <TD>
            <input name="user_no" id='user_no'  v_must=1 v_type=string index="4"  >
            <font class="orange">*</font>
        </TD>
    </TR>

    <TR>
        <TD class="blue">���Ų�ƷID</TD>
        <TD>
            <input type="text"   name="id_no" id='id_no'  maxlength="18" v_type="0_9" v_must=1 index="2"  >
            <font class="orange">*</font>
        </TD>
        <TD class="blue">���ſͻ�����</TD>
        <TD COLSPAN="1">
            <input type="text"   name="cust_name" id='cust_name'  maxlength="18" v_type="0_9" v_must=1 index="2"  >
        </TD>
    </TR>
    <TR>
        <TD class="blue">��Ʒ����</TD>
        <TD>
            <input type='text' id='product_name' name='product_name' readOnly/>
            <input type="hidden"   name="product_id"  id='product_id'  maxlength="18" v_type="0_9" v_must=1 index="2"  >
            <input type="hidden"   name="requestType"  id='requestType'  maxlength="2" v_type="0_9" index="2"  >
        </TD>

        <td class='blue' nowrap>���Ų�Ʒ����</td>
        <td>
                <jsp:include page="/npage/common/pwd_8.jsp">
                    <jsp:param name="width1" value="16%"  />
                    <jsp:param name="width2" value="34%"  />
                    <jsp:param name="pname" value="product_pwd"  />
                    <jsp:param name="pwd" value=""  />
                </jsp:include>
            <input type='button' class='b_text' id='chk_productPwd' name='chk_productPwd' onClick='chkProductPwd()' value='У��' />
            <font class="orange">*</font>
        </td>
    </TR>
</table>

</div>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">
		��Ա�ʷ���Ϣ
		<span id="div_mm_chg_type" style="display:none">
			<input type="radio" name="mm_chg_type" value="1"    onclick="chg_MM_tab_show(1)" checked/>����
			<input type="radio" name="mm_chg_type" value="2"    onclick="chg_MM_tab_show(2)"         />����
		</span>
	</div>
</div>



<TABLE  cellSpacing="0" id="MM_batch" style="display:none">
<tr>
	<td class="blue"  width='18%'>��������<br>����<span id="count_phoneNo">0</span>������</td>
	<td  width='32%'>
		<textarea id="textarea_batch" name="textarea_batch" style="width:200px;height:200px;" onchange="check_bath_phoneNo()"></textarea>
	</td>
	<td>
		 <font class="orange">
		 	ÿ��ֻ����һ���ֻ����룬ʹ�����߷ָ�<br>
		 	���50��<br>
		 	<br><br>
		 	ʾ�����£�<br>
		 	13904511100|<br>
		 	13904511101|<br>
		 </font>
	</td>
</tr>
</table>

<TABLE  cellSpacing="0" id="MM_general">
    <TR>
        <TD class="blue" width='18%'>�ֻ�����</TD>
        <TD width='32%'>
            <input name="phone_no"  id="phone_no"  maxlength='11' onblur='if(this.value!="" && !forMobil(this)){return false;}' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)'  v_type="string" v_must=1 >
            <input type='button' class='b_text' name='phoneno_query' id='phoneno_query' value='��ѯ' onClick="queryPhoneNo()" disabled />
            <font class="orange">*</font>
        </TD>
        <TD class="blue" width='18%'>Ʒ������</TD>
        <TD width='32%'>
            <input type="text" name="sm_name" id="sm_name" v_must=1 readOnly class='InputGrey' >
            <font class="orange">*</font>
            <input type="hidden" name="sm_code" id="sm_code" v_must=1 >
        </TD>
    </TR>
    <TR>
        <TD class="blue">�û�ID</TD>
        <TD>
            <input name=user_id id="user_id" maxlength="11" v_type="0_9" readOnly class='InputGrey' >
        </TD>
        <TD class="blue">�û�����</TD>
        <TD>
            <input name="user_name" id='user_name' v_type=string readOnly class='InputGrey' >
        </TD>
    </TR>
    <TR>
        <TD class="blue">��Ա�ʷѴ���</TD>
        <TD>
            <input type="text"   name="fee_code" id="fee_code"  maxlength="18" v_type="0_9" readOnly class='InputGrey' >
        </TD>
        <TD class="blue">��Ա�ʷ�����</TD>
        <TD>
            <input type="text"   name="fee_name" id="fee_name"  maxlength="18" readOnly class='InputGrey' >
        </TD>
    </TR>
</table>

<!--
</div>
<div id="Operation_Table">
<div id="CRInfo" style="display:none">
<div class="title">
	<div id="title_zi">������Ϣ</div>
</div>

<TABLE  cellSpacing="0">
    <TR>
        <TD class="blue">��Ʒ����</TD>
        <TD>
            <select name="product_type" id="product_type">
            </select>
            <font class="orange">*</font>
        </TD>
        <TD class="blue">���ų�Ա��Ʒ</TD>
        <TD>
            <select name="member_product" id="member_product">
            </select>
        </TD>
    </TR>
</table>
</div>

-->
</div>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">�ʷ���Ϣ</div>
</div>

<TABLE  cellSpacing="0">
    <TR>
        <TD class="blue" width='18%'>��Ա���ʷѴ���</TD>
        <TD width='32%'>
            <input name="new_fee_code"  id="new_fee_code" class="InputGrey" readOnly v_type="string" v_must=1 >
            <input type='button' class='b_text' name='fee_query' id='fee_query' value='��ѯ' onClick="queryRate()" disabled  />
            <font class="orange">*</font>
        </TD>
        <TD class="blue">��Ա���ʷ�����</TD>
        <TD>
            <input name="new_fee_name"  id="new_fee_name" class="InputGrey" readOnly v_type="string" v_must=1 >
        </TD>
    </TR>
</table>

<TABLE cellSpacing="0">
    <TR>
        <TD id="footer">
            <input class="b_foot" name="bSure" id="bSure" type=button value="ȷ��" onclick="refMain()" disabled />
            <input class="b_foot" name="bBack" id="bBack" type=button value="���" onclick='window.location="f7897_1.jsp?opCode=<%=opCode%>&opName=<%=opName%>"'>
            <input class="b_foot" name="bClose" id="bClose" onClick="removeCurrentTab()" type=button value="�ر�">
        </TD>
    </TR>
</TABLE>

<input type='hidden' id='iRegionCode' name='iRegionCode' value='<%=regionCode%>' />
<input type='hidden' id='op_code' name='op_code' value='<%=opCode%>' />
<input type="hidden" name="sys_accept" id="sys_accept" value="<%=sysAccept%>" />
<input type='hidden' id='opNote' name='opNote' />

<input type='hidden' id='cfmPnoneNo' name='cfmPnoneNo' />


<jsp:include page="/npage/common/pwd_comm.jsp"/>
<%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>