<%
    /********************
     * @ OpCode    :  7895
     * @ OpName    :  ���ų�Աɾ��
     * @ CopyRight :  si-tech
     * @ Author    :  qidp
     * @ Date      :  2009-10-16
     * @ Update    :  
     ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>

<%
    String opCode = "7895";
    String opName = "���ų�Աɾ��";
    
    String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
    
    String workNo = WtcUtil.repNull((String)session.getAttribute("workNo"));
    String workName = WtcUtil.repNull((String)session.getAttribute("workName"));
    String workPwd = WtcUtil.repNull((String)session.getAttribute("password"));
    String orgCode = WtcUtil.repNull((String)session.getAttribute("orgCode"));
    String regionCode = WtcUtil.repNull((String)session.getAttribute("regCode"));
    String groupId = WtcUtil.repNull((String)session.getAttribute("groupId"));
    
    String[][] belongResult = new String[][]{};
    
    String nextFlag = "1";
    
    String iIccid = "";
    String iCustId = "";
    String iUnitId = "";
    String iServiceNo = "";
    String iProductId = "";
    String iAccountId = "";
    String iSmCode = "";
    String iSmName = "";
    String iBelongCode = "";
    String iProductPwd = "";
    String id_no="";
    String iRequestType = "";
    String listShow = "none";
    String iGrpName = "";
    String iProductName = "";
    
    /*begin ����ͻ��������ź�������������� ���� by diling*/
    String iCustManagerNoHiden = "";
    String iCustManagerNameHiden = "";
    String iUnitTypeHiden = "";
    /*end add by diling*/
    
    String action = WtcUtil.repNull((String)request.getParameter("action"));
    if("next".equals(action)){
        nextFlag = "2";
        iIccid = WtcUtil.repNull((String)request.getParameter("iccid"));
        iCustId = WtcUtil.repNull((String)request.getParameter("cust_id"));
        iUnitId = WtcUtil.repNull((String)request.getParameter("unit_id"));
        iServiceNo = WtcUtil.repNull((String)request.getParameter("service_no"));
        iProductId = WtcUtil.repNull((String)request.getParameter("product_id"));
        iAccountId = WtcUtil.repNull((String)request.getParameter("account_id"));
        iSmCode = WtcUtil.repNull((String)request.getParameter("sm_code"));
        iSmName = WtcUtil.repNull((String)request.getParameter("sm_name"));
        iBelongCode = WtcUtil.repNull((String)request.getParameter("belong_code"));
        iProductPwd = WtcUtil.repNull((String)request.getParameter("product_pwd"));
        id_no = WtcUtil.repNull((String)request.getParameter("id_no"));
        iRequestType = WtcUtil.repNull((String)request.getParameter("request_type"));
        iGrpName = WtcUtil.repNull((String)request.getParameter("grp_name"));
        iProductName = WtcUtil.repNull((String)request.getParameter("product_name"));
        
        /*begin add by diling@2012/5/14 */
        iCustManagerNoHiden = WtcUtil.repNull((String)request.getParameter("custManagerNoHiden"));
        iCustManagerNameHiden = WtcUtil.repNull((String)request.getParameter("custManagerNameHiden"));
        iUnitTypeHiden = WtcUtil.repNull((String)request.getParameter("unitTypeHiden"));
        /*end add by diling*/
        
        /*********************
         * �жϹ��Ż����Ƿ��а�����ҵ���Ȩ��
         *********************/
        try{
    		System.out.println("====wanghfa====f7895_1.jsp====sCheckLogin====0==== workNo = " + workNo);
    		System.out.println("====wanghfa====f7895_1.jsp====sCheckLogin====1==== workPwd = " + workPwd);
    		System.out.println("====wanghfa====f7895_1.jsp====sCheckLogin====2==== iSmCode = " + iSmCode);
    		System.out.println("====wanghfa====f7895_1.jsp====sCheckLogin====3==== m04");
    		System.out.println("====wanghfa====f7895_1.jsp====sCheckLogin====4==== ");
    		System.out.println("====wanghfa====f7895_1.jsp====sCheckLogin====5==== iRequestType = " + iRequestType);
    		System.out.println("====wanghfa====f7895_1.jsp====sCheckLogin====5==== iProductId = " + iProductId);
    		System.out.println("====wanghfa====f7895_1.jsp====sCheckLogin====6==== iCustId = " + iCustId);
    		System.out.println("====wanghfa====f7895_1.jsp====sCheckLogin====7==== id_no = " + id_no);
            %>
                <wtc:service name="sCheckLogin" routerKey="region" routerValue="<%=regionCode%>" retcode="sCheckLoginCode" retmsg="sCheckLoginMsg" outnum="2" >
                	<wtc:param value="<%=workNo%>"/>
                	<wtc:param value="<%=workPwd%>"/> 
                    <wtc:param value="<%=iSmCode%>"/>
                    <wtc:param value="m04"/>
                    <wtc:param value="<%=iRequestType%>"/>
                    <wtc:param value="<%=iProductId%>"/>
                    <wtc:param value="<%=iCustId%>"/>
                    <wtc:param value="<%=id_no%>"/>
                </wtc:service>
            <%
            if(!"000000".equals(sCheckLoginCode)){
                %>
                    <script type=text/javascript>
                        rdShowMessageDialog("������룺<%=sCheckLoginCode%><br/>������Ϣ:<%=sCheckLoginMsg%>",0);
                        history.go(-1);
                    </script>
                <%
            }
        }catch(Exception e){
            %>
                <script type=text/javascript>
                    rdShowMessageDialog("���÷���sCheckLoginʧ�ܣ�",0);
                    history.go(-1);
                </script>
            <%
            e.printStackTrace();
        }
        
        if("AD".equals(iSmCode) || "ML".equals(iSmCode) || "MA".equals(iSmCode)){
            listShow = "";
        }else{
            listShow = "none";
        }
    }
    
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
    <title>���ų�Աɾ��</title>
    
<script type=text/javascript>
    var dynTbIndex=1;				//���ڶ�̬�����ݵ�����λ��,��ʼֵΪ1.���Ǳ�ͷ
    var phoneNoReg = /^(\d{11}(\d{2})?\|)+$/;
    
    onload=function(){
        <% if("2".equals(nextFlag)){ %>
           /*add by diling*/
            $("#custManagerInfo").css("display","");
            $("#unitTypeInfo").css("display","");
            /*end */
            $("#iccid").attr("readOnly",true);
            $("#iccid").addClass("InputGrey");
            $("#cust_id").attr("readOnly",true);
            $("#cust_id").addClass("InputGrey");
            $("#unit_id").attr("readOnly",true);
            $("#unit_id").addClass("InputGrey");
            $("#service_no").attr("readOnly",true);
            $("#service_no").addClass("InputGrey");
            $("#product_id").attr("readOnly",true);
            $("#product_id").addClass("InputGrey");
            $("#product_name").attr("readOnly",true);
            $("#product_name").addClass("InputGrey");
            $("#account_id").attr("readOnly",true);
            $("#account_id").addClass("InputGrey");
            $("#sm_code").attr("readOnly",true);
            $("#sm_code").addClass("InputGrey");
            $("#sm_name").attr("readOnly",true);
            $("#sm_name").addClass("InputGrey");
            $("#product_pwd").attr("readOnly",true);
            $("#product_pwd").addClass("InputGrey");
            $("#belong_code").find("option:not(:selected)").remove();
        
            if("<%=iSmCode%>" == "AD" || "<%=iSmCode%>" == "ML" || "<%=iSmCode%>" == "MA"){
                //ѡ���������Ͱ�������ʱ��ʾ��������
            	var vRequestType = "<%=iRequestType%>";
            	document.all.request_type.value=vRequestType;
                $("#request_type").find("option:not(:selected)").remove();
            	if(vRequestType == "03" || vRequestType == "04"){
            	    document.all.expTime.style.display="";
            	}else{
            	    document.all.expTime.style.display="none";
            	}
            }
        <% } %>
    }
    
    /* ��ѯ�����û���Ϣ */
    function getCustInfo(){
        var pageTitle = "���ſͻ�ѡ��";

        var fieldName = "֤������|���ſͻ�ID|���ſͻ�����|���Ų�ƷID|���ź�|��Ʒ����|��Ʒ����|���ű��|��Ʒ�����ʻ�|Ʒ�ƴ���|Ʒ������|���±�ʶ|��������|�������|���ſͻ���������|���ſͻ���������|";//update diling";
        var sqlStr = "";
        var selType = "S";    //'S'��ѡ��'M'��ѡ
        var retQuence = "15|0|1|7|4|5|8|9|3|2|6|10|12|17|18|19|";//update diling

        var retToField = "iccid|cust_id|unit_id|service_no|product_id|account_id|sm_code|id_no|grp_name|product_name|sm_name|request_type_flag|unitTypeHiden|custManagerNameHiden|custManagerNoHiden|";//update diling
        /**add by liwd 20081127,group_id����dcustDoc��group_id end **/

        if(document.frm.iccid.value == "" && document.frm.cust_id.value == "" && document.frm.unit_id.value == "" && document.frm.service_no.value == "")
        {
            rdShowMessageDialog("������֤�����롢�ͻ�ID�����ű�Ż��źŽ��в�ѯ��");
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
            rdShowMessageDialog("���ű�ű��������֣�");
            return false;
        }
        
        PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
    }
    
    function PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField){
        var path = "<%=request.getContextPath()%>/npage/s7895/fpubcust_sel.jsp";
        path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
        path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
        path = path + "&selType=" + selType+"&iccid=" + document.frm.iccid.value;
        path = path + "&cust_id=" + document.frm.cust_id.value;
        path = path + "&unit_id=" + document.frm.unit_id.value;
        path = path + "&service_no=" + document.frm.service_no.value;
        path = path + "&regionCode=" + document.frm.iRegionCode.value;
        retInfo = window.open(path,"newwindow","height=450, width=1000,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
    	return true;
    }
    
    function getvaluecust(retInfo){
        var retToField = "iccid|cust_id|unit_id|service_no|product_id|account_id|sm_code|id_no|grp_name|product_name|sm_name|request_type_flag|unitTypeHiden|custManagerNameHiden|custManagerNoHiden|";//diling add
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
        
        var vSmCode = $("#sm_code").val();
        if(vSmCode == "AD" || vSmCode == "ML" || vSmCode == "MA"){
            document.all.requestTab1.style.display="";
            document.all.requestTab2.style.display="";
            document.all.request_type.value=$("#request_type_flag").val();
            $("#request_type").find("option:not(:selected)").remove();
        }else{
            document.all.requestTab1.style.display="none";
            document.all.requestTab2.style.display="none";
        }
        
        $("#iccid").attr("readOnly",true);
        $("#cust_id").attr("readOnly",true);
        $("#unit_id").attr("readOnly",true);
        $("#service_no").attr("readOnly",true);
    }
    
        /* У�鼯�Ų�Ʒ���� */
    function chkProductPwd(){
        var cust_id = document.all.cust_id.value;
        var Pwd1 = document.all.product_pwd.value;
        var checkPwd_Packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s7895/pubCheckPwd.jsp","���ڽ�������У�飬���Ժ�......");
        checkPwd_Packet.data.add("retType","checkPwd");
    	checkPwd_Packet.data.add("cust_id",cust_id);
    	checkPwd_Packet.data.add("Pwd1",Pwd1);
    	core.ajax.sendPacket(checkPwd_Packet);
    	checkPwd_Packet = null;
    }
    
    /* �����û���ѯ */
    function Getsingle_phoneno(){
        var vServiceNo = document.frm.service_no.value;
        var vRegionCode = document.all.frm.org_code.value.substring(0,2);
        var vSinglePhoneNo = $("#single_phoneno").val();
        var vIdNo = $("#id_no").val();
        var vSmCode = $("#sm_code").val();
        var vProductId = $("#product_id").val();
        var vRequestType = "";
        //alert("vIdNo="+vIdNo);
        if(vSmCode == "AD" || vSmCode == "ML"){
            vRequestType = $("#request_type").val();
        }
        if(vSinglePhoneNo != ""){
		if (vSmCode=='PA' || vSmCode=='PB')
		{
			/*
			if(vSinglePhoneNo.substring(0,5)=="10648")
			{
				vSinglePhoneNo="205"+vSinglePhoneNo.substring(5,vSinglePhoneNo.length);
			}
			else if(vSinglePhoneNo.substring(0,3)=="147")
			{
				vSinglePhoneNo="206"+vSinglePhoneNo.substring(3,phoneNo.length);
			}
			*/
		}

            var packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s7895/pubChkNo.jsp","���ڻ�ó�Ա��Ϣ�����Ժ�......");
        	packet.data.add("workNo","<%=workNo%>");
        	packet.data.add("opCode","<%=opCode%>");
        	packet.data.add("idNo",vIdNo);
        	packet.data.add("smCode",vSmCode);
        	packet.data.add("productId",vProductId);
        	packet.data.add("serviceNo",vServiceNo);
        	packet.data.add("regionCode",vRegionCode);
        	packet.data.add("singlePhoneNo",vSinglePhoneNo);
        	packet.data.add("requestType",vRequestType);
        	core.ajax.sendPacket(packet,doGetsingle_phoneno);
        	packet = null;
        }else{
            GetMemberPhoneno();
        }
    }
    
    function doGetsingle_phoneno(packet){
        var retCode = packet.data.findValueByName("retCode");		
        var retMsg = packet.data.findValueByName("retMessage");
        var retPhoneNoNum = packet.data.findValueByName("retPhoneNoNum");
        var retMemberUse = packet.data.findValueByName("retMemberUse");
        var retSinglePhoneno = packet.data.findValueByName("retSinglePhoneno");
        var singlephoneTypes = packet.data.findValueByName("singlephoneTypes");
        //singlephoneTypes="Y";
        if(retCode == "000000"){
            if(retPhoneNoNum != 0){
            		if(singlephoneTypes.trim()=="Y") {
            			if ($("#sm_code").val()=="ML"||$("#sm_code").val()=="WK")
            			{
							rdShowMessageDialog("����ȡʣ��ר���30%��ΪΥԼ��",1);
            			}
            			else
            			{
							rdShowMessageDialog("�ó�Ա�а����ʷ�δ���ڣ�����ǰȡ��������ר�һ���Կ۳���",1);
            			}
            		}
                $("#member_use").val(retMemberUse);
                $("#single_phoneno").val(retSinglePhoneno);
                return true;
            }else{
                rdShowMessageDialog("�˼���û�иó�Ա��Ϣ,���������룡",0);
                $("#single_phoneno").val("");
                $("#single_phoneno").focus();
                return false;
            }
        }else{
            rdShowMessageDialog("������룺"+retCode+"<br/>������Ϣ��"+retMsg,0);
            return false;
        }
    }
    
    function GetMemberPhoneno(){
    	var pageTitle = "���ų�Ա�����ѯ";
        var fieldName = "��Ա�û�ID|��Ա�û��ֻ�����|ҵ������|";
/*    	var sqlStr = "select a.member_id,a.member_no,e.sm_name"
                  +" from dGrpUserMebMsg a,dGrpUserMsg b,dAccountIdInfo c,"
                  +" sBusiTypeSmCode d,sSmCode e"
                  +" where a.id_no=b.id_no"
                  +" and b.user_no=c.msisdn"
                  +" and b.sm_code=c.service_type"
                  +" and c.service_no='"+document.frm.service_no.value+"'"
                  +" and c.service_type=d.sm_code"
                  +" and c.service_type=e.sm_code"
                  +" and e.region_code='"+document.frm.org_code.value.substring(0,2)+"'";
*/
/*
		var sqlStr = "select a.id_no,f.phone_no,e.sm_name"
                  +" from dCustMsgAdd a,dGrpUserMsg b,dAccountIdInfo c,"
                  +" sBusiTypeSmCode d,sSmCode e ,dCustMsg f"
                  +" where a.FIELD_VALUE=to_char(b.id_no)"
                  +" and a.field_code ='1004'"
                  +" and f.id_no = a.id_no"
                  +" and b.user_no=c.msisdn"
                  +" and b.sm_code=c.service_type"
                  +" and c.service_no='"+document.frm.service_no.value+"'"
                  +" and c.service_type=d.sm_code"
                  +" and c.service_type=e.sm_code"
                  +" and e.region_code='"+document.frm.org_code.value.substring(0,2)+"'"
                  +" and rownum < 100 ";
        if($("#single_phoneno").val() != ""){
            if(!forMobil(document.all.single_phoneno)){
                rdShowMessageDialog("�ֻ������ʽ����ȷ�����������룡",0);
                $("#single_phoneno").val("");
                $("#single_phoneno").focus();
                return false;
            }
            sqlStr = sqlStr + " and f.phone_no = '"+$("#single_phoneno").val()+"'";
        }
*/
    	var sqlStr = "";
    	var selType = "S";    //'S'��ѡ��'M'��ѡ
    	var retQuence = "2|0|1|";
    	var retToField = "member_use|single_phoneno|";
    	var returnNum="3";
    	PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,returnNum);
    }
    
    function PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,returnNum)
    {
        var vSinglePhoneNo = $("#single_phoneno").val();
        var vIdNo = $("#id_no").val();
        var vSmCode = $("#sm_code").val();
        var vProductId = $("#product_id").val();
        var vWorkNo = "<%=workNo%>";
        var vOpCode = "<%=opCode%>";
        var vOpType = "m04";
        var vRequestType = "";
        if(vSmCode == "AD" || vSmCode == "ML"){
            vRequestType = $("#request_type").val();
        }
        
        var path = "<%=request.getContextPath()%>/npage/s7895/fGetPhoneNo_1.jsp";
        path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
        path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
        path = path + "&selType=" + selType; 
    	path = path + "&returnNum=" + returnNum;
    	path = path + "&phoneNo="+vSinglePhoneNo;
    	path = path + "&idNo="+vIdNo;
    	path = path + "&smCode="+vSmCode;
    	path = path + "&productId="+vProductId;
    	path = path + "&workNo="+vWorkNo;
    	path = path + "&opCode="+vOpCode;
    	path = path + "&opType="+vOpType;
    	path = path + "&requestType="+vRequestType;
        retInfo = window.showModalDialog(path);
        if(retInfo ==undefined)      
        {
        	return false;
        }
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
        var sphonesno="";
        sphonesno = document.all.single_phoneno.value;
        if(sphonesno.indexOf(",")!=-1) {
        	var sphonesdno =sphonesno.trim().split(",");
        	document.all.single_phoneno.value=sphonesdno[0];
        	      if(sphonesdno[1].trim()=="Y") {
            			if ($("#sm_code").val()=="ML"||$("#sm_code").val()=="WK")
            			{
							rdShowMessageDialog("����ȡʣ��ר���30%��ΪΥԼ��",1);
            			}
            			else
            			{
							rdShowMessageDialog("�ó�Ա�а����ʷ�δ���ڣ�����ǰȡ��������ר�һ���Կ۳���",1);
            			}
               		}
        }
        
        
        
    	return true;
    }
    
    /* ��ѡ��������ʱ */
    function chkSingle(){
        $("#inputType").val("single");
        $("#single").css("display","block");
        $("#multi").css("display","none");
        $("#file").css("display","none");
    }
    
    /* ��ѡ��������ʱ */
    function chkMulti(){
        $("#inputType").val("multi");
        $("#single").css("display","none");
        $("#multi").css("display","block");
        $("#file").css("display","none");
    }
    
    /* ��ѡ¼���ļ�ʱ */
    function chkFile(){
        $("#inputType").val("file");
        $("#single").css("display","none");
        $("#multi").css("display","none");
        $("#file").css("display","block");
    }
    
    /* ��� */
    function resetJsp(){
        //document.all.frm.reset();
        window.location='f7895_1.jsp';
    }
    
    /* ��һ�� */
    function nextStep(){
    		var vSmCode = $("#sm_code").val();
    		if(vSmCode == "vp"){
    			var flag4A = allCheck4A("<%=opCode%>");
					if(!flag4A){
						return false;
					}
    		}
        if(!check(document.all.frm)){return false}
        
        
        if(vSmCode == "AD" || vSmCode == "ML" || vSmCode == "MA"){
            if($("#request_type").val().trim() == ''){
                rdShowMessageDialog("��ѡ��������ͣ�",0);
                return false;
            }
        }
        
        frm.action="f7895_1.jsp?action=next";
        frm.method="post";
        frm.submit();
    }
    
    /* ��һ�� */
    function previouStep(){
        frm.action="f7895_1.jsp";
    	frm.method="post";
    	frm.submit();
    }
    
    /* ����ύ */
    function refMain(){
        var ind1Str ="";
        /* vpmnʱ,ƴд���� */
        //if($("#sm_code").val() == "vp" || $("#sm_code").val() == "j1"){	//wanghfa�޸�
          if($("#sm_code").val() == "j1"){	/*diling update*/
            if( dyntb.rows.length == 2){//������û������
                rdShowMessageDialog("û��ָ����Ա���룬����������!",0);
                return false;
            }else{
                for(var a=1; a<document.all.R0.length ;a++)//ɾ����tr1��ʼ��Ϊ������
                {
                    ind1Str =ind1Str +document.all.R1[a].value+"|";
                }						
            }
            //2.��form�������ֶθ�ֵ
            document.all.tmpR1.value = ind1Str;
        }else{
            if(document.all.input_type[0].checked){         //����¼��
                if($("#single_phoneno").val() == ""){
                    rdShowMessageDialog("��ѡ���Ա�û��ֻ����룡",0);
                    $("#single_phoneno").select();
                    $("#single_phoneno").focus();
                    return false;
                }
            }else if(document.all.input_type[1].checked){    //����¼��
                var t = $("#multi_phoneNo").val();
                if(t == ""){
                    rdShowMessageDialog("������¼���ֻ����룡",0);
                    $("#multi_phoneNo").select();
                    $("#multi_phoneNo").focus();
                    return false;
                } else {	//2011/7/7 wanghfa���� �����οո��·���down��
                  	if (!phoneNoReg.test(t)){
                  	    rdShowMessageDialog("�������ĸ�ʽ����ȷ��",0);
                  	    return;
                  	}
                  	 
                  	while ($("#multi_phoneNo").val().indexOf(" ") != -1) {
  	                	$("#multi_phoneNo").val($("#multi_phoneNo").val().replace(" ", ""));
                  	}
                }
            }else{
                if($("#PosFile").val() == ""){    //�ļ�¼��
                    rdShowMessageDialog("��ѡ���ļ���",0);
                    $("#PosFile").focus();
                    return false;
                }
            }
            
            if($("#sm_code").val() == "AD" || $("#sm_code").val() == "ML" || $("#sm_code").val() == "MA"){
                var vRequestType = "<%=iRequestType%>";
                if(vRequestType == "03" || vRequestType == "04"){
                    if($("#expect_time").val() == ""){
                        rdShowMessageDialog("�������������ڣ�",0);
                        $("#expect_time").select();
                        $("#expect_time").focus();
                        return false;
                    }else{
                        if(!forDate(document.all.expect_time)){
                            return false;
                        }
                    }
                }
            }
        }
        
        $("#opNote").val("<%=workNo%>���м��ų�Աɾ��������");

        showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes");

        var confirmFlag=0;
		confirmFlag = rdShowConfirmDialog("�Ƿ��ύ���β�����");
		if (confirmFlag==1) {
		    $("#sure").attr("disabled",true);
    		if($("#inputType").val() == 'file'){
        		document.frm.target="_self";
    		    document.frm.encoding="application/x-www-form-urlencoded";
    		}
			frm.action="f7895_2.jsp";
    		frm.method="post";
    		frm.submit();
    		$("#sure").attr("disabled",true);
    		loading();
		}
    }
    
	//��ӡ��Ϣ
	function printInfoVP(printType)
	{ 
		/*2014/08/25 15:36:34 gaopeng ����ֹ�˾���ڵ��ӹ���Ӧ��������⼰����ķ��� 
			�����ϰ�������ӡ����Ϊ�������
		*/
		/*��󷵻ص��ַ���*/
		var retInfo = "";
		/*�û���Ϣ��*/
		var cust_info="";
		/*����ҵ����Ϣ��*/
		var opr_info="";
		/*��ע��Ϣ��*/
		var note_info1="";
		var note_info2="";
		var note_info3="";
		var note_info4="";
		
		var phonNo = "";
		var tmpOpCode= "<%=opCode%>";
		//var updateNoType = document.frm.updateNoType[document.frm.updateNoType.selectedIndex].value;
		var updateNoType = "1";//diling update
		var phonNos = document.all.tmpR1.value;
		var phonNos = $("#multi_phoneNo").val(); //diling update
		var phonNoArr = phonNos.split("\|");
			for(var i=0;i<phonNoArr.length-1;i++){
				//if(i == phonNoArr.length-2){
				//	phonNo = phonNo + phonNoArr[i];
				//}else{
				    phonNo = phonNo + phonNoArr[i] + ",";
			    //}
			}
		var nameN = "";//document.all.tmpR3.value.substr(0,document.all.tmpR3.value.indexOf("\|"));
    	//retInfo+="�û�����:"+document.frm.grp_name.value+"|";
    	
    	cust_info += "�ͻ�������   "+document.frm.grp_name.value+"|";
			cust_info += "֤�����룺   "+document.frm.iccid.value+"|";
			cust_info += "���ſͻ����룺   "+document.frm.cust_id.value+"|";
		
    	opr_info += "���Ų�Ʒ���ƣ�   "+document.frm.product_name.value+"|";
    	opr_info += "ҵ�����ͣ�   ���ų�Աɾ��"+"|";
    	
    	if(updateNoType == "1" ){
    	  	opr_info += "�ֻ��ţ�   "+phonNo+"|";
    	}else{
    	    opr_info += "�̺ţ�   "+phonNo+"|";	
    	}
        
       
    	
    	opr_info += "��ˮ��   "+document.frm.sys_accept.value+"|";
    	opr_info += "�������ţ�   "+'<%=workNo%>'+"|";
    	opr_info += "����ʱ�䣺   "+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
    	
			retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
			retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
			return retInfo;	
		
	}
	
	function printInfo(printType)
	{ 
		
		/*2014/08/25 15:36:34 gaopeng ����ֹ�˾���ڵ��ӹ���Ӧ��������⼰����ķ��� 
			�����ϰ�������ӡ����Ϊ�������
		*/
		/*��󷵻ص��ַ���*/
		var retInfo = "";
		/*�û���Ϣ��*/
		var cust_info="";
		/*����ҵ����Ϣ��*/
		var opr_info="";
		/*��ע��Ϣ��*/
		var note_info1="";
		var note_info2="";
		var note_info3="";
		var note_info4="";
		
		cust_info += "�ͻ�������   "+document.frm.grp_name.value+"|";
		cust_info += "֤�����룺   "+document.frm.iccid.value+"|";
		cust_info += "���ſͻ����룺   "+document.frm.cust_id.value+"|";
		
   
    
    opr_info += "���Ų�Ʒ���ƣ�   "+document.frm.product_name.value+"|";
    opr_info += "ҵ�����ͣ�   ���ų�Աɾ��"+"|";
    opr_info += "��ˮ��   "+document.frm.sys_accept.value+"|";
		
		note_info1 += document.frm.opNote.value+"|";
		
		retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
		retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
		return retInfo;	
		
	}
    
    function showPrtDlg(printType,DlgMessage,submitCfm){
       var h=180;
			var w=350;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			
			var pType="subprint";             				 		//��ӡ���ͣ�print ��ӡ subprint �ϲ���ӡ
			var billType="1";              				 			  //Ʊ�����ͣ�1���������2��Ʊ��3�վ�
			var sysAccept =document.frm.sys_accept.value;       //��ˮ��
			var mode_code=null;           							  //�ʷѴ���
			var fav_code=null;                				 		//�ط�����
			var area_code=null;             				 		  //С������
			var opCode = "<%=opCode%>";

		var phonNos = document.all.tmpR1.value;
		if("<%=iSmCode%>" == "vp"){//VPMN ʱ
		    //var phonNoArr = phonNos.split("\|");
		    var phonNoArr= $("#single_phoneno").length;
		    if(document.all.input_type[1].checked){ //vpmn���� diling update
		    //if(phonNoArr.length > 2){
		       	hljPrint = "hljPrint_more.jsp";
		       	printStr = printInfoVP(printType);
		       	if(printStr == "failed")
		          {
		          	return false;
		          }
	
		     	var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
					var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_dz.jsp?DlgMsg=" + DlgMessage ;
					path += "&mode_code="+mode_code+
						"&fav_code="+fav_code+"&area_code="+area_code+
						"&opCode="+opCode+"&sysAccept="+sysAccept+
						"&submitCfm="+submitCfm+"&pType="+
						pType+"&billType="+billType+ "&printInfo=" + printStr;
					
				 var ret=window.showModalDialog(path,printStr,prop);
				 return ret;
			
		    }else{
		        doUni();//��ɾ��һ��ʱ��Ҫ�����Ӧ�̺Ż����ֻ��ŵ��ײ�
		    }
		}else{
		    var printStr = printInfo(printType);
		    if(printStr == "failed")
		    {
			   return false;
		     }
		  		var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
					var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_dz.jsp?DlgMsg=" + DlgMessage ;
					path += "&mode_code="+mode_code+
						"&fav_code="+fav_code+"&area_code="+area_code+
						"&opCode="+opCode+"&sysAccept="+sysAccept+
						"&submitCfm="+submitCfm+"&pType="+
						pType+"&billType="+billType+ "&printInfo=" + printStr;
						
					 var ret=window.showModalDialog(path,printStr,prop);
					 return ret;
		}
		
		
    }
    
    function doUni(){
       /*diling update
         var updateNoType = document.frm.updateNoType[document.frm.updateNoType.selectedIndex].value;
       */
       var updateNoType = "1";
       //var phonNos = document.all.tmpR1.value;
       var cust_id = document.all.cust_id.value;
	     //var phonNoArr = phonNos.split("\|");
	   var phonNoArr = $("#single_phoneno").val();
       var myPacket = new AJAXPacket("selMealName.jsp","���ڲ�ѯ�ײ����ƣ����Ժ�......");

	   myPacket.data.add("updateNoType",updateNoType);
	   myPacket.data.add("phonNoArr",phonNoArr);
	   myPacket.data.add("unitId",document.frm.unit_id.value);
       myPacket.data.add("cust_id",cust_id);
       core.ajax.sendPacket(myPacket,doMsg);
       myPacket = null;
    }
    
     function doMsg(packet){
         var retCode = packet.data.findValueByName("retCode");
         var retMessage = packet.data.findValueByName("retMessage");
         var retResult = packet.data.findValueByName("result");
         if(retCode == "000000")
         {
            printInfoFile(retResult,"Detail","ȷʵҪ���е��������ӡ��","Yes"); // 
         }else{
            rdShowMessageDialog("������룺"+retCode+"  ������Ϣ��"+retMessage+"!");	
            return;
         }
      }
      
      function printInfoFile(retResult,printType,DlgMessage,submitCfm){
      	    /*diling update
      	      var updateNoType = document.frm.updateNoType[document.frm.updateNoType.selectedIndex].value;
      	    */
      	    
      	    var h=180;
						var w=350;
						var t=screen.availHeight/2-h/2;
						var l=screen.availWidth/2-w/2;
						
						var pType="subprint";             				 		//��ӡ���ͣ�print ��ӡ subprint �ϲ���ӡ
						var billType="1";              				 			  //Ʊ�����ͣ�1���������2��Ʊ��3�վ�
						var sysAccept =document.frm.sys_accept.value;       //��ˮ��
						var mode_code=null;           							  //�ʷѴ���
						var fav_code=null;                				 		//�ط�����
						var area_code=null;             				 		  //С������
						var opCode = "<%=opCode%>";
			
      	    var updateNoType ="1";
            
            /*2014/08/25 15:36:34 gaopeng ����ֹ�˾���ڵ��ӹ���Ӧ��������⼰����ķ��� 
						�����ϰ�������ӡ����Ϊ�������
						*/
						/*��󷵻ص��ַ���*/
						var retInfo = "";
						/*�û���Ϣ��*/
						var cust_info="";
						/*����ҵ����Ϣ��*/
						var opr_info="";
						/*��ע��Ϣ��*/
						var note_info1="";
						var note_info2="";
						var note_info3="";
						var note_info4="";
            
            
            var phoneNo = "";
            /*diling update
              var phonNos = document.all.tmpR1.value;
              var phonNos = $("#single_phoneno").val();
  	          var phonNoArr = phonNos.split("\|");
  	          phoneNo = phonNoArr[0];
  	        */
	        phoneNo =$("#single_phoneno").val();
            var thisType = retResult.split(",")[0];
            var thatType = retResult.split(",")[1];
            var nameN = retResult.split(",")[2];
            
            cust_info += "�ͻ�������   "+document.frm.grp_name.value+"|";
						cust_info += "֤�����룺   "+document.frm.iccid.value+"|";
						cust_info += "���ſͻ����룺   "+document.frm.cust_id.value+"|";
		
            opr_info += "���Ų�Ʒ���ƣ�   "+document.frm.product_name.value+"|";
    	    	opr_info += "ҵ�����ͣ�   ���ų�Աɾ��"+"|";
    		
    		if(updateNoType == "1" ){
    		   	 opr_info += "������   "+nameN+"|";
    	  	   opr_info += "�ֻ��ţ�   "+phoneNo+"|";
    		}else{
    	       opr_info += "������   "+nameN+"|";
    	  	   opr_info += "�̺ţ�   "+phoneNo+"|";
    		}
    			  opr_info += "���¼���V���ʷ��ײ����ƣ�   "+thisType+"|";
            opr_info += "���¼���V���ʷ��ײ����ƣ�   "+thatType+"|";
            
            opr_info += "��ˮ��   "+document.frm.sys_accept.value+"|";
            opr_info += "�������ţ�   "+'<%=workNo%>'+"|";
            opr_info += "����ʱ�䣺   "+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
            
            
            retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
						retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
						
						var printStr = retInfo;
						
            
            var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+
						"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
			
						var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_dz.jsp?DlgMsg=" + DlgMessage ;
						path += "&mode_code="+mode_code+
							"&fav_code="+fav_code+"&area_code="+area_code+
							"&opCode="+opCode+"&sysAccept="+sysAccept+
							"&submitCfm="+submitCfm+"&pType="+
							pType+"&billType="+billType+ "&printInfo=" + printStr;
						
						var ret=window.showModalDialog(path,printStr,prop);
						return ret;
            		
      }
    /* ��txt�ļ�¼���ֻ����� */
    function checkPhNo(){
        fso = new ActiveXObject("Scripting.FileSystemObject");
        var ForReading =1,f2;
        f2 = fso.OpenTextFile(document.all.PosFile.value,ForReading);
        var temps = f2.ReadAll();
        document.all.multi_phoneNo.value=temps;
        
        
        var phnoNoArr = temps.split("|");
        
        for(var i=0;i<phnoNoArr.length-1;i++){
            if(phnoNoArr[i].replace(/\s/g,'').length!=11){
                rdShowMessageDialog("�绰����Ӧ��Ϊ11λ"+phnoNoArr[i]);
            }
            for(var j=i+1;j<phnoNoArr.length-1;j++){
                if(phnoNoArr[i].replace(/\s/g,'')==phnoNoArr[j].replace(/\s/g,'')){
                    rdShowMessageDialog("�绰�����ظ�"+phnoNoArr[j]);
                }
            }
        }
        resetfilp();
    }
    
    function resetfilp(){
        document.getElementById("PosFile").outerHTML = document.getElementById("PosFile").outerHTML;
    }
    
    
    
    /* VPMNʱ,��֤�������ֻ����� */
    function check_phone()
	{

 		var sqlBuf=""; 		
		var myPacket = new AJAXPacket("CallCommONESQL.jsp","������֤�û����룬���Ժ�......");		
		var update_no_type = document.frm.updateNoType[document.frm.updateNoType.selectedIndex].value;
        var realAddNo1=document.frm.addNo.value.trim();
        var vIdNo = document.frm.id_no.value;
        var vProductId = document.frm.product_id.value;
		if( document.frm.unit_id.value == "" )
		{
		  	rdShowMessageDialog("�����뼯�ź�!!");
		  	document.frm.unit_id.focus();
		  	return false;		 
        }		
		
		if(!checkElement(document.all.addNo)) 
			return false;
		if( update_no_type == "0" )//�̺�
		{
			var shortNo = document.frm.addNo.value;
			if(shortNo.substr(0,1)==7)
			{
					if(shortNo.length > 8 || shortNo.length < 3){
				  	rdShowMessageDialog("7��ͷ�Ķ̺ų��ȱ�����3-8λ!!");
				  	document.frm.addNo.select();
				  	document.frm.addNo.focus();
				  	return false;
				    }
			}
			else
			{

				if(shortNo.substr(0,1) !=6)
	       		{
	       			rdShowMessageDialog("�̺��������6��7��ͷ!");
	       			document.frm.addNo.select();
				  	document.frm.addNo.focus();
	       			return false;
	       		}
				if(shortNo.length > 6 || shortNo.length < 4){
				  	rdShowMessageDialog("6��ͷ�Ķ̺ų��ȱ�����4-6λ!!");
				  	document.frm.addNo.select();
				  	document.frm.addNo.focus();
				  	return false;
				}
	       		if(shortNo.substr(1,1) ==0)
	       		{
	       			rdShowMessageDialog("6��ͷ�Ķ̺���ڶ�λ����Ϊ0!");
				  	document.frm.addNo.select();
				  	document.frm.addNo.focus();
	       			return false;
	       		}
	    	}
					
			myPacket.data.add("verifyType","verifyMebNo");
			myPacket.data.add("noType","0");
			myPacket.data.add("addNo",realAddNo1);
			myPacket.data.add("idNo",vIdNo);
			myPacket.data.add("productId",vProductId);
			core.ajax.sendPacket(myPacket);
			myPacket=null;
		}
		else
		{
            myPacket.data.add("verifyType","verifyMebNo");
			myPacket.data.add("noType","1");
			myPacket.data.add("addNo",realAddNo1);
			myPacket.data.add("idNo",vIdNo);
			myPacket.data.add("productId",vProductId);
			core.ajax.sendPacket(myPacket);
			myPacket=null;
		}
	}
	
    function j1CheckPhone()
	{
		var updateNoType = document.frm.updateNoType[document.frm.updateNoType.selectedIndex].value;
		var addNo = document.frm.addNo.value;
		var noType;
		if(!checkElement(document.all.addNo)) {
			return false;
		}
		
		if(updateNoType == "0" ) {	//�ֻ���
			noType = "0";
			if (addNo.trim().length > 6 || addNo.trim().length < 4) {
				rdShowMessageDialog("�ֻ�����Ϊ4-6λ���룬�ƶ���Ӫ�̵�һλ����Ϊ6���ڶ�λ����Ϊ0��������Ӫ�̷ֻ������һλ����Ϊ8�����������룡");
				document.getElementById("addNo").focus();
				return;
			}
			var patrn=/^([6][1-9])|([8]\d)\d{2,4}$/;
			if(addNo.search(patrn) != 0){
				rdShowMessageDialog("�ֻ�����Ϊ4-6λ���룬�ƶ���Ӫ�̵�һλ����Ϊ6���ڶ�λ����Ϊ0��������Ӫ�̷ֻ������һλ����Ϊ8�����������룡");
				document.getElementById("addNo").focus();
				return;
			}
		} else if(updateNoType == "1" ) {	//��ʵ����
			if(!checkElement(document.all.addNo)) {
				return false;
			}
			noType = "1";
		}
		var myPacket = new AJAXPacket("CallCommONESQL.jsp","������֤�û����룬���Ժ�......");
		myPacket.data.add("verifyType", "verifyMebNo");
		myPacket.data.add("noType", noType);
		myPacket.data.add("addNo", addNo.trim());
		myPacket.data.add("idNo", document.frm.id_no.value);
		myPacket.data.add("productId", document.frm.product_id.value);
		core.ajax.sendPacket(myPacket);
		myPacket=null;
	}
	
    function doProcess(packet)
    {
        error_code = packet.data.findValueByName("errorCode");
        error_msg =  packet.data.findValueByName("errorMsg");
        verifyType = packet.data.findValueByName("verifyType");
        var backArrMsg = packet.data.findValueByName("backArrMsg");		
        var backArrMsg1 = packet.data.findValueByName("backArrMsg1");
        self.status="";
       
        
        if(verifyType=="verifyMebNo")
        {
            if(error_code == "000000")
            {
                dynAddRow();
                /* �б���ֵʱ���������޸ĺ������� */
                $("#updateNoType").find("option:not(:selected)").remove(); 
            }
            else
            {
                rdShowMessageDialog("������룺"+error_code+"<br/>������Ϣ��"+error_msg+"",0);
                document.frm.addNo.select();
                document.frm.addNo.focus();
                return false;
            }
        }
        else if(verifyType == "checkPwd") //���ſͻ�����У��
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
                    if(<%=nextFlag%>==1){
                        $("#next").attr("disabled",false);
                    }
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
    
    function dynAddRow()
    {
        var phone_no="";
        var isdn_no="";
        var user_name="";
        var id_card="";
        var note="";
        var add_no="";
        var tmpStr="";
        add_no = document.all.addNo.value;
        if(!checkElement(document.all.addNo)) return false;		  		    	  
        queryAddAllRow(0,add_no);	  	
    }	
    
    function queryAddAllRow(add_type,add_no)
    {
        var tr1="";
        var i=0;
        var tmp_flag=false;
        var exec_status="";
        tmp_flag = verifyUnique(add_no);
        if(tmp_flag == false)
        {
            rdShowMessageDialog("�Ѿ���һ��'���Ӻ���'��ͬ������!!");
            return false;	  
        }
        
        tr1=dyntb.insertRow();	//ע�⣺����ı������������һ��,������ɿ���.yl.
        tr1.id="tr"+dynTbIndex;
        tr1.insertCell().innerHTML = '<div align="center"><input id=R0    type=checkBox    size=4 value="ɾ��" onClick="dynDelRow()" ></input></div>';         
        tr1.insertCell().innerHTML = '<div align="center"><input id=R1   class=InputGrey type=text   value="'+ add_no+'"  readonly></input></div>';
        
        dynTbIndex++;
        document.all.addNo.value = "";
        document.all.addRecordNum.value = document.all.dyntb.rows.length-2;
    }
    
    function dynDelRow()
    {
        for(var a = document.all.dyntb.rows.length-2 ;a>0; a--)//ɾ����tr1��ʼ��Ϊ������
        {
            if(document.all.R0[a].checked == true)
            {
                document.all.dyntb.deleteRow(a+1);
                break;
            }
        }
        document.all.addRecordNum.value = document.all.dyntb.rows.length-2;
        
        /* �б���պ󣬷ſ��Ժ������͵����� */
        if(document.all.dyntb.rows.length <= 2){
            $("#updateNoType").empty();
            $("<option value='0'>0--&gt;�̺��б�</option>").appendTo("#updateNoType");
            $("<option value='1' selected >1--&gt;��ʵ�����б�</option>").appendTo("#updateNoType");
        }
    }
    
    
    function dyn_deleteAll()
    {
        //������ӱ��е�����
        for(var a = document.all.dyntb.rows.length-2 ;a>0; a--)//ɾ����tr1��ʼ��Ϊ������
        {
            document.all.dyntb.deleteRow(a+1);
        }
        document.all.addRecordNum.value = document.all.dyntb.rows.length-2;		 	
    }	
    
    function verifyUnique(add_no)
	{
        var tmp_addNo="";
        for(var a = document.all.dyntb.rows.length-2 ;a>0; a--)//ɾ����tr1��ʼ��Ϊ������
        {
            tmp_addNo = document.all.R1[a].value;
            if( (tmp_addNo.trim() == add_no.trim())){
                return false;
            }			
        }
        return true;
    }
    
    function doUnLoading(){
        $("#sure").attr("disabled",false);
        unLoading();
    }
    
    function chkSingPhoneNo(obj){
    	if(obj.value.substring(0,4)=="0451"){
    		if(!forMobil2(obj)){return false;}
    	}else{
    		if(!forMobil(obj)){return false;}
    	}
    }
    
    function forMobil2(obj){
    	var patrn=/^((\(\d{3}\))|(\d{3}\-))?[12][0358]\d{9}$/;
			var sInput = obj.value;
			var sInput1 = sInput.substring(4,sInput.length);
			var patrn1=/^[0-9]{8}$/;
			if(sInput1.search(patrn1)==-1){
				showTip(obj,"�̻���ʽ����ȷ��");
				return false;
			}else{
				hiddenTip(obj);
				return true;
			}
			if(sInput.search(patrn)==-1){
				showTip(obj,"��ʽ����ȷ��");
				return false;
			}
			hiddenTip(obj);
			return true;
    }
</script>

</head>
<body>
<form name="frm" action="" method="post" >
<%@ include file="/npage/include/header.jsp" %>
<div class="title">
	<div id="title_zi">�����û���Ϣ��ѯ</div>
</div>
<table cellspacing=0>
    <tr>
        <td class='blue' nowrap width='18%'>֤������</td>
        <td width='32%'>
            <input type='text' name='iccid' id='iccid' value='<%=iIccid%>' v_must='1' />
            <input type='button' class='b_text' name='iccid_query' id='iccid_query' value='��ѯ' onClick='getCustInfo()' />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap width='18%'>���ſͻ�ID</td>
        <td>
            <input type='text' id='cust_id' name='cust_id' value='<%=iCustId%>' v_must='1' />
            <font class='orange'>*</font>
        </td>
    </tr>
    
    <tr>
        <td class='blue' nowrap>���ű��</td>
        <td>
            <input type='text' name='unit_id' id='unit_id' value='<%=iUnitId%>' v_must='1' />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap>���źŻ����������</td>
        <td>
            <input type='text' id='service_no' name='service_no' value='<%=iServiceNo%>' v_must='1' />
            <font class='orange'>*</font>
        </td>
    </tr>
    
    <tr>
        <td class='blue' nowrap>���Ų�Ʒ����</td>
        <td>
            <input type='text' id='product_name' name='product_name' value='<%=iProductName%>' readOnly/>
            <input type='hidden' name='product_id' id='product_id' value='<%=iProductId%>' v_must='1' readOnly/>
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap>��Ʒ�����˻�</td>
        <td>
            <input type='text' id='account_id' name='account_id' value='<%=iAccountId%>' v_must='1' readOnly/>
            <font class='orange'>*</font>
        </td>
    </tr>
    
    <tr>
        <td class='blue' nowrap>����Ʒ��</td>
        <td>
            <input type='text' name='sm_name' id='sm_name' value='<%=iSmName%>' v_must='1' readOnly/>
            <input type='hidden' name='sm_code' id='sm_code' value='<%=iSmCode%>' v_must='1' readOnly/>
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap>��������</td>
        <td>
            
            <select name="belong_code" id="belong_code">
<%
				try
				{
					String sqlStr2 = "select substr(:org_code,1,2),substr(:org_code,1,7)||'|'||:GroupId,'�������ڵ�' from dual";
					System.out.println("sqlStr================"+sqlStr2);
					System.out.println("org_code="+orgCode+",GroupId="+groupId);
                    String paraIn1="org_code="+orgCode+",GroupId="+groupId;
                    %>
                    <wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode14" retmsg="retMsg14" outnum="3" >
                    	<wtc:param value="<%=sqlStr2%>"/>
                    	<wtc:param value="<%=paraIn1%>"/> 
                    </wtc:service>
                    <wtc:array id="retArr14" scope="end"/>
                    <%
                    if(retCode14.equals("000000") && retArr14.length>0){
                        belongResult = retArr14;
                    }
					int recordNum = belongResult.length;
					for(int i=0;i<recordNum;i++)
					{
					    if("2".equals(nextFlag) && iBelongCode.equals(belongResult[i][1])){
						%>
						    <option value="<%=belongResult[i][1]%>" selected><%=belongResult[i][1]%>--<%=belongResult[i][2]%></option>
						<%
					    }else{
					    %>
						    <option value="<%=belongResult[i][1]%>"><%=belongResult[i][1]%>--<%=belongResult[i][2]%></option>
						<%
					    }
					}
				}catch(Exception e){
					System.out.println("Call Service TlsPubSelCrm is Failed!");
				}
%>
            </select>
        </td>
    </tr>
    
    <tr>
        <td class='blue' nowrap>���Ų�Ʒ����</td>
        <td>
                <jsp:include page="/npage/common/pwd_8.jsp">
                    <jsp:param name="width1" value="16%"  />
                    <jsp:param name="width2" value="34%"  />
                    <jsp:param name="pname" value="product_pwd"  />
                    <jsp:param name="pwd" value="<%=iProductPwd%>"  />
                </jsp:include>
            <input type='button' class='b_text' id='chk_productPwd' name='chk_productPwd' onClick='chkProductPwd()' value='У��' />
            <font class="orange">*</font>
        </td>
        
        <td class='blue' nowrap>
			<span id='requestTab1' name='requestTab1' style="display:<%=listShow%>">
			��������
			</span>&nbsp;
		</td>
		<td >
			<span id='requestTab2' name='requestTab2' style="display:<%=listShow%>">
				<select name="request_type" id="request_type">
				    <option value=''>---��ѡ��---</option>
				    <option value='01'
				    <%
				        if("01".equals(iRequestType)){
				            out.print(" selected ");
				        }
				    %>
				    >01->ͨ����</option>
				    <option value='02'
				    <%
				        if("02".equals(iRequestType)){
				            out.print(" selected ");
				        }
				    %>    
				    >02->IPT��</option>
				    <option value='03'
				    <%
				        if("03".equals(iRequestType)){
				            out.print(" selected ");
				        }
				    %>
				    >03->��������</option>
				    <option value='04'
				    <%
				        if("04".equals(iRequestType)){
				            out.print(" selected ");
				        }
				    %>
				    >04->��������</option>
				</select>
			</span>&nbsp;
		</td>
        
    </tr>
    <%/*begin �����һ��չʾ�ͻ��������ź�������������� by diling@2012/5/14 */%>
     <input type='hidden' id='custManagerNoHiden' name='custManagerNoHiden'  value='' readOnly/>
     <input type='hidden' id='custManagerNameHiden' name='custManagerNameHiden' value='' readOnly/>
     <input type='hidden' id='unitTypeHiden' name='unitTypeHiden' value='' readOnly/>
    <tr id="custManagerInfo" style="display:none">
        <td class='blue' nowrap>�ͻ���������</td>
        <td>
            <input type='text' class="InputGrey" id='custManagerNo' name='custManagerNo' value='<%=iCustManagerNoHiden%>' readOnly/>
        </td>
        <td class='blue' nowrap>�ͻ���������</td>
        <td>
            <input type='text' class="InputGrey" id='custManagerName' name='custManagerName' value='<%=iCustManagerNameHiden%>' v_must='1' readOnly />
        </td>
    </tr>
    <tr id="unitTypeInfo" style="display:none">
        <td class='blue' nowrap>�������</td>
        <td colspan="3">
            <input type='text' class="InputGrey" id='unitType' name='unitType' value='<%=iUnitTypeHiden%>' readOnly/>
        </td>
    </tr>
    <%/*end by diling */%>
</table>
<%
if ("2".equals(nextFlag)) {
    if ("vp".equals(iSmCode)) {
%>
</div>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">VPMN��������</div>
</div>
<%/*
<table cellspacing=0>
    <tr> 
        <td class="blue" width='18%'>��ѡ���������</td>
        <td width='32%'>
            <select name="updateNoType" id="updateNoType">
                <option value="0">0--&gt;�̺��б�</option>
                <option value="1" selected >1--&gt;��ʵ�����б�</option>
            </select>
        </td>
        <td class="blue" width='18%'>���Ӻ���</td>
        <td>
            <input name="addNo" type="text"  id="addNo" maxlength="12" v_must=1 v_type=0_9 v_minlength=1   > 
        </td>
    </tr>
    <tr style='display:none'> 
        <td class="blue">�ļ���</td>
        <td colspan="3">
            <input name="fileName" type="text"  class="InputGrey" id="fileName" size="60" maxlength="60" readonly>
        </td>
    </tr>              
    <tr> 
        <td>
            <input name="addCondConfirm" type="button" class="b_text" id="addCondConfirm" value="����" onClick="check_phone()"></td>
        <td>&nbsp;</td>
        <td class="blue">�����Ӽ�¼��</td>
        <td> 
            <input name="addRecordNum" type="text" class="InputGrey" id="addRecordNum" value="" size=7 readonly>
        </td>
    </tr>          
<table>

<table cellspacing="0" id="dyntb">
    <tr> 
        <td class="blue" width='50%'>ɾ������</td>
        <td class="blue"> ���Ӻ���</td>
    </tr>
    <tr id="tr0" style="display:none">
        <td>
            <input type="checkBox" id="R0" value="">
        </td>
        <td>
            <input type="text" id="R1" value="">
        </td>
    </tr>
</table>  
*/%>
<table cellspacing=0>
    <tr>
        <td class='blue' nowrap width='18%'>�������뷽ʽ</td>
        <td colspan='3'>
            <input type='radio' id='input_type' name='input_type' onClick='chkSingle()' value='single' checked />��������
            <input type='radio' id='input_type' name='input_type' onClick='chkMulti()' value='multi' />��������
        </td>
    </tr>
    <tbody id='single' name='single'>
    <tr>
        <td class='blue' nowrap width='18%'>��Ա�û��ֻ�����</td>
        <td width='32%'>
            <input type='text' id='single_phoneno' name='single_phoneno' maxlength='12' onblur='if(this.value != ""){chkSingPhoneNo(this);}' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_type="string" value="" />
            <input class="b_text" id="selectNo" onClick="Getsingle_phoneno()" type=button value="ѡ��" />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap width='18%'>��Ա�û�ID</td>
        <td>
            <input type='text' id='member_use' name='member_use' v_must=0 v_type="string" value='' />
        </td>
	</tr>
	
    </tbody>
    <tbody id='multi' name='multi' style='display:none'>
    <tr>
        <TD class=blue width='18%'>����</TD>
        <TD width='32%'>
            <textarea cols=30 rows=8 id='multi_phoneNo' name="multi_phoneNo" style="overflow:auto" v_must=1 
            	onkeyup="this.value=this.value.replace(/[^\|\d]/g,'');" 
				onafterpaste="this.value=this.value.replace(/[^\|\d]/g,'')"/></textarea>
        </TD>
        <TD colspan='2'>
            ע���������Ӻ���ʱ,����"|"��Ϊ�ָ���,�������һ������Ҳ����"|"��Ϊ����.
            <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����MAS��ڰ�����ҵ��ÿ�����100�����������50��������30��������30����
            <br>&nbsp;���磺
            <br>&nbsp;13900000001|13900000002|
        </TD>
        </TR>	
    </tbody>
    <tbody id='file' name='file' style='display:none'>		
        <TR>
        <TD align="left" class=blue width=12%>¼���ļ�</TD>	   
        <TD> 
            <input type="file" name="PosFile" id="PosFile" class="button" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' />
        </TD>
        <TD colspan="2"><font color='red'>�ļ�˵��:һ������һ��
            (ע�⣺�ϴ��ļ���ʽ����Ϊ�ı��ļ�����֧��EXCEL��ʽ�ϴ��ļ�)������MAS��ڰ�����ҵ��ÿ�����100�����������50��������30����</font>
        </TD>
    </tr>
    </tbody>
    <tbody id='expTime' name='expTime' style='display:none'>
        <td class='blue' nowrap>��������</td>
        <td colspan='3'>
            <input type='text' id='expect_time' name='expect_time' v_type="date" value="<%=dateStr%>" v_must="1" v_format="yyyyMMdd" onKeyPress='return isKeyNumberdot(0)' onBlur='if(!forDate(this)){return false;}'/>
            &nbsp;<font class="orange">*&nbsp;(��ʽ:yyyymmdd)</font>
        </td>
    </tbody>
</table>
<%
	} else if ("j1".equals(iSmCode)) {	//wanghfa���� j1����BOSS
%>
</div>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">�����ܻ���������</div>
</div>

<table cellspacing=0>
    <tr> 
        <td class="blue" width='18%'>��ѡ���������</td>
        <td width='32%'>
            <select name="updateNoType" id="updateNoType">
                <option value="0">0--&gt;�ֻ����б�</option>
                <option value="1" selected >1--&gt;��ʵ�����б�</option>
            </select>
        </td>
        <td class="blue" width='18%'>���Ӻ���</td>
        <td>
            <input name="addNo" type="text"  id="addNo" maxlength="12" v_must=1 v_type=0_9 v_minlength=4 v_maxlength=12> 
        </td>
    </tr>
    <tr> 
        <td>
            <input name="addCondConfirm" type="button" class="b_text" id="addCondConfirm" value="����" onClick="j1CheckPhone()"></td>
        <td>&nbsp;</td>
        <td class="blue">�����Ӽ�¼��</td>
        <td> 
            <input name="addRecordNum" type="text" class="InputGrey" id="addRecordNum" value="" size=7 readonly>
        </td>
    </tr>          
<table>

<table cellspacing="0" id="dyntb">
    <tr> 
        <td class="blue" width='30%'>ɾ������</td>
        <td class="blue"> ���Ӻ���</td>
    </tr>
    <tr id="tr0" style="display:none">
        <td>
            <input type="checkBox" id="R0" value="">
        </td>
        <td>
            <input type="text" id="R1" value="">
        </td>
    </tr>
</table>  
<%
	} else {
%>
</div>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">��������</div>
</div>

<table cellspacing=0>
    <tr>
        <td class='blue' nowrap width='18%'>�������뷽ʽ</td>
        <td colspan='3'>
            <input type='radio' id='input_type' name='input_type' onClick='chkSingle()' value='single' checked />��������
            <input type='radio' id='input_type' name='input_type' onClick='chkMulti()' value='multi' />��������
            <input type='radio' id='input_type' name='input_type' onClick='chkFile()' value='file' />�ļ�¼��
            
        </td>
    </tr>
    <tbody id='single' name='single'>
        <!--
    <tr>
        <td class='blue' nowrap>��Ա�û��ֻ�����</td>
        <td>
            <input type='text' id='single_phoneno' name='single_phoneno' value='' v_must='1' />
            <input type='button' class='b_text' name='single_query' id='single_query' value='��ѯ' onClick='getSingleUserInfo()' />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap>�û�����</td>
        <td>
            <input type='text' id='single_user_name' name='single_user_name' value='' />
        </td>
    </tr>
    -->
    
    <tr>
        <td class='blue' nowrap width='18%'>��Ա�û��ֻ�����</td>
        <td width='32%'>
            <input type='text' id='single_phoneno' name='single_phoneno' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_type="string" value="" />
            <input class="b_text" id="selectNo" onClick="Getsingle_phoneno()" type=button value="ѡ��" />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap width='18%'>��Ա�û�ID</td>
        <td>
            <input type='text' id='member_use' name='member_use' v_must=0 v_type="string" value='' />
        </td>
	</tr>
	
    </tbody>
    <tbody id='multi' name='multi' style='display:none'>
    <tr>
        <TD class=blue width='18%'>����</TD>
        <TD width='32%'>
            <textarea cols=30 rows=8 id='multi_phoneNo' name="multi_phoneNo" style="overflow:auto" v_must=1 
            	onkeyup="this.value=this.value.replace(/[^\|\d]/g,'');" 
				onafterpaste="this.value=this.value.replace(/[^\|\d]/g,'')"/></textarea>
        </TD>
        <TD colspan='2'>
            ע���������Ӻ���ʱ,����"|"��Ϊ�ָ���,�������һ������Ҳ����"|"��Ϊ����.
            <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����MAS��ڰ�����ҵ��ÿ�����100�����������50��������30����
            <br>&nbsp;���磺
            <br>&nbsp;13900000001|13900000002|
        </TD>
        </TR>	
    </tbody>
    <tbody id='file' name='file' style='display:none'>		
        <TR>
        <TD align="left" class=blue width=12%>¼���ļ�</TD>	   
        <TD> 
            <input type="file" name="PosFile" id="PosFile" class="button" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' />
        </TD>
        <TD colspan="2"><font color='red'>�ļ�˵��:һ������һ��
            (ע�⣺�ϴ��ļ���ʽ����Ϊ�ı��ļ�����֧��EXCEL��ʽ�ϴ��ļ�)������MAS��ڰ�����ҵ��ÿ�����100�����������50��������30����</font>
        </TD>
    </tr>
    </tbody>
    <tbody id='expTime' name='expTime' style='display:none'>
        <td class='blue' nowrap>��������</td>
        <td colspan='3'>
            <input type='text' id='expect_time' name='expect_time' v_type="date" value="<%=dateStr%>" v_must="1" v_format="yyyyMMdd" onKeyPress='return isKeyNumberdot(0)' onBlur='if(!forDate(this)){return false;}'/>
            &nbsp;<font class="orange">*&nbsp;(��ʽ:yyyymmdd)</font>
        </td>
    </tbody>
</table>
<%
    }
}
%>
<TABLE cellSpacing=0>
    <TR id="footer">        
        <TD align=center>
        <%
            if ("1".equals(nextFlag)){
        %>
                <input name="next" id="next" class="b_foot"  type=button value="��һ��" onclick="nextStep()" disabled />
        <%
            }else {
        %>
                <input class="b_foot" name="previous" id="previous" type=button value="��һ��" onclick="previouStep()" style="display:none"/>
                <input class="b_foot" name="sure" id="sure" type=button value="ȷ��" onclick="
                    if(document.all.inputType.value == 'file'){
                        doUpload();
                    }else{
                        refMain();
                    }
                " />
        <%
            }
        %>
            <input class="b_foot" name='clear' id='clear' type='button' value="���" onClick="resetJsp()" />
            <input class="b_foot" name="close"  onClick="removeCurrentTab()" type=button value="�ر�" />
        </TD>
    </TR>
</table>
<input type='hidden' id='iRegionCode' name='iRegionCode' value='<%=regionCode%>' />
<input type='hidden' id='org_code' name='org_code' value='<%=orgCode%>' />
<input type="hidden" name="sys_accept" id="sys_accept" value="<%=sysAccept%>" />
<input name="opNote" type="hidden" id="opNote" size="60" maxlength="60" />
<input type='hidden' id='id_no' name='id_no' value='<%=id_no%>' />
<input type="hidden" name="tmpR1" id="tmpR1" value="">
<input type='hidden' id='grp_name' name='grp_name' value='<%=iGrpName%>'/>
<input type='hidden' id='inputType' name='inputType' value='single' />
<input type='hidden' id='inputFile' name='inputFile' value='' />
<input type='hidden' id='request_type_flag' name='request_type_flag' value='' />
<input type='hidden' id='mobile_phone' name='mobile_phone' value='' /><!--wuxy 20100331 -->
<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>
<jsp:include page="/npage/common/pwd_comm.jsp"/>
<!-- 2014/12/26 14:47:50 gaopeng �������ƽ��ģʽ������������Ϣģ���������� ���빫��ҳ�� openType����������ͨ���У��Ͷ����๫��У��-->
<jsp:include page="/npage/public/intf4A/common/intfCommon4A.jsp">
	<jsp:param name="openType" value="SPECIAL"  />
</jsp:include>
<%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>

<script type="text/javascript">
    /*�ύ��f7895_upload.jspҳ�棬�����ϴ��������ϴ��ɹ������refMain()������*/
    function doUpload()
	{
        if($("#sm_code").val() == "vp" || $("#sm_code").val() == "j1"){	//wanghfa�޸�
            if(document.all.input_type[0].checked){         //����¼��
                if($("#single_phoneno").val() == ""){
                    rdShowMessageDialog("��ѡ���Ա�û��ֻ����룡",0);
                    $("#single_phoneno").select();
                    $("#single_phoneno").focus();
                    return false;
                }else{
                    if(!forMobil(document.all.single_phoneno)){
                        return false;
                    }
                }
            }else if(document.all.input_type[1].checked){    //����¼��
                var t = $("#multi_phoneNo").val();
                if($("#multi_phoneNo").val() == ""){
                    rdShowMessageDialog("������¼���ֻ����룡",0);
                    $("#multi_phoneNo").select();
                    $("#multi_phoneNo").focus();
                    return false;
                } else {	//2011/7/7 wanghfa���� �����οո��·���down��
                	  if (!phoneNoReg.test(t)){
                  	    rdShowMessageDialog("�������ĸ�ʽ����ȷ��",0);
                  	    return;
                  	}
                	
                  	while ($("#multi_phoneNo").val().indexOf(" ") != -1) {
  	                	$("#multi_phoneNo").val($("#multi_phoneNo").val().replace(" ", ""));
                  	}
                }
            }else{
                if($("#PosFile").val() == ""){    //�ļ�¼��
                    rdShowMessageDialog("��ѡ���ļ���",0);
                    $("#PosFile").focus();
                    return false;
                }else{
                    var uploadfile = document.all.PosFile.value;
                	var ext = "*.txt";
                	var file_name = uploadfile.substr(uploadfile.lastIndexOf(".")); 
                	if(ext.indexOf("*"+file_name)==-1){   
                        rdShowMessageDialog("����ֻ֧��txt��ʽ�ļ�(*.txt)��",0);  
                        return;  
                    }
                }
            }
            
            if($("#sm_code").val() == "AD" || $("#sm_code").val() == "ML" || $("#sm_code").val() == "MA"){
                var vRequestType = "<%=iRequestType%>";
                if(vRequestType == "03" || vRequestType == "04"){
                    if($("#expect_time").val() == ""){
                        rdShowMessageDialog("�������������ڣ�",0);
                        $("#expect_time").select();
                        $("#expect_time").focus();
                        return false;
                    }else{
                        if(!forDate(document.all.expect_time)){
                            return false;
                        }
                    }
                }
            }
        }
      
	    document.frm.target="hidden_frame";
	    document.frm.encoding="multipart/form-data";
	    document.frm.action="f7895_upload.jsp";
	    document.frm.method="post";
	    document.frm.submit();
	    $("#sure").attr("disabled",true);
	    loading();
	}
	
</script>