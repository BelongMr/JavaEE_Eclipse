<%
  /*
   * ����: e743 ȫ������ҵ�񶩵�����
   * �汾: 1.0
   * ����: 2012-03-31
   * ����: wanghfa
   * ��Ȩ: si-tech
  */ 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="/npage/common/serverip.jsp" %>
<%@ include file="../../npage/bill/getMaxAccept.jsp" %>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="org.json.JSONObject"%>
<%
	response.setHeader("Pragma","No-Cache"); 
	response.setHeader("Cache-Control","No-Cache");
	response.setDateHeader("Expires", 0); 
	request.setCharacterEncoding("GBK");
	String opCode = "e743";
	String opName = "ȫ������ҵ�񶩵�����";
	String workNo = (String)session.getAttribute("workNo");
	String password = (String)session.getAttribute("password");
	String regionCode = (String)session.getAttribute("regCode");
	String orgCode = (String)session.getAttribute("orgCode");
	String filePath = request.getRealPath("/npage/tmp/");
	String in_ChanceId = request.getParameter("in_ChanceId");//��7453��ת������ʱ�����ֵ������ʱ���ǿ�
	String WaNo = request.getParameter("wa_no1");
	if(WaNo == null) {
		WaNo = "";
	}
	System.out.println("---liujian---in_ChanceId=" + in_ChanceId);
	
	//liujian 2013-5-17 10:43:20 ����esop��Դ
	String fromType = request.getParameter("fromType");
	String sceneIdFromType = request.getParameter("SceneId");
%>
<%
	String printAccept="";
%>
	<wtc:sequence name="TlsPubSelCrm" key="sMaxSysAccept" routerKey="region" 
		 routerValue="<%=regionCode%>"  id="seq"/>
<%
		printAccept = seq;
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>ȫ������ҵ�񶩵�����</title>
<script language="javascript" type="text/javascript" src="json2.js"></script>
<script language="javascript" type="text/javascript" src="fe743_mainScript.js"></script>
<script language="javascript" type="text/javascript" src="multiSelect.js"></script>
<script type="text/javascript" src="/npage/public/pubLightBox.js"></script>	
<link rel="stylesheet" type="text/css" href="multiSelect.css" />
<script type=text/javascript>
	var interBOSS;
	var step = "0";	//0:Ĭ��; 1:��ʼ��; 2:ѡ��ͻ�
	onload = function() {
		//�������õ�url
		var _href = window.location.href;
		var pageHref = _href.substring(_href.indexOf('fe743.jsp'),_href.length);
		$('#pageHref').val(pageHref);
		
		//����in_ChanceId
		//in_ChanceId  wono chanceId�ǹ�����������
		//waNo  �ǹ�����������
		in_ChanceId ="<%=in_ChanceId%>";
		
		//liujian 2013-5-17 10:44:39 ����esop��Դ
		fromType = '<%=fromType%>';
		if(fromType == 'esop') {
			$('#e743footerTable').css('display','none');	
			sceneId = '<%=sceneIdFromType%>';
			getServiceMsg("se743QryBSR", "doGetMainAreas",1, sceneId,in_ChanceId);			
		}else {
			if (in_ChanceId == "null" || in_ChanceId == null) {
				in_ChanceId = '';
			}else {
				hideAddProBtn = true;
			}
			step = "1";
			getArea("opType", "����ѡ��", 0,0);
			initArea("opType");	
		}
		
		
		
		/*
		//alert(interBOSS.svcCont.orderInfoReq.orderSourceID.eleValue);
		var jsonText = JSON.stringify(interBOSS);
		interBOSS = trimJson(interBOSS);
		jsonText = JSON.stringify(interBOSS);
		$("#json2").val(jsonText);
		*/

		/*
		getArea("product", "��Ʒ��Ϣ", 20);
		getArea("accounting", "������Ϣ", 20);
		getArea("linkman", "��ϵ����Ϣ", 20);
		initArea("product");
		initArea("accounting");
		initArea("linkman");
		*/
		/*
		//�����б�
		getArea("POAttachment", "��Ʒ������Ӧ�ĸ�����Ϣ", 0);
		initArea("POAttachment");
		
		//ҵ��������Ϣ�б� POAudit �ɲ���
		getArea("POAudit", "ҵ��������Ϣ�б�", 0);
		initArea("POAudit");
		
		//��Ʒ��������ϵ����Ϣ ContactorInfo
		getArea("ContactorInfo", "��Ʒ��������ϵ����Ϣ", 0);
		initArea("ContactorInfo");
		
		//��Ʒ����ֵ�б�   ProductOrderCharacters
		getArea("ProductOrderCharacters", "��Ʒ����ֵ�б�", 0);
		initArea("ProductOrderCharacters");
		
		//��Ʒһ�������� 
		getArea("POOrderCharge", "��Ʒһ��������", 0);
		initArea("POOrderCharge");
		
		//��Ʒһ�����ʷ�   ProductOrderCharge
		getArea("ProductOrderCharge", "��Ʒһ��������", 0);
		initArea("ProductOrderCharge");
	
		//֧��ʡ           PayCompanys
		getArea("PayCompanys", "֧��ʡ", 0);
		initArea("PayCompanys");
		
		
		//�ײ��б� POOrderRatePolicys
		getArea("POOrderRatePolicys", "�ײ��б�", 0);
		initArea("POOrderRatePolicys");
		
		//��Ʒ����б�
		getArea("productspecqry", "��Ʒ����б�", 20,0);
		initArea("productspecqry");

		//��Ʒ���ʷ��б�   ProductOrderRatePlans
		getArea("ProductOrderRatePlans", "��Ʒ���ʷ��б�", 0);
		initArea("ProductOrderRatePlans");

		//��Ʒ����������Ϣ ProductOrderBase
		getArea("ProductOrderBase", "��Ʒ����������Ϣ", 0);
		initArea("ProductOrderBase");
		
		//��Ʒ�����б�
		getArea("ProductOrderList", "��Ʒ�����б�", 0);
		initArea("ProductOrderList");
		
		//����ҵ�����     ProductOrderBusinesses
		getArea("ProductOrderBusinesses", "����ҵ�����", 0);
		initArea("ProductOrderBusinesses");

		//��Ʒ����б�
		getArea("productRule", "��Ʒ����б�", 20,0);
		initArea("productRule");
		
		
		getArea("ManageNode", "ʡBOSS�ϴ������ڵ�", 20,0);
		initArea("ManageNode");
		*/
		
		/*���������������ſͻ���Ϣ����Ŀ(��Ʒ)Ͷ�ʺ������Զ���ƥ�䱨���ĺ�
		 * liangyl 2016-08-22
		 * 10985
		 */
		if (typeof ($("#10985").val())!="undefined" ){
			$("#10985").parent().append("&nbsp;<input type='button' class='b_text' value='У��' onclick='ajax_check_F10985()' />"); 
		}		
	}

					
	//footer��ȷ����ť
	function cfm() {

				
		//alert(step);
		/*
		$('#mapping').val('A501_1_999033734_0:1342163267578.xls');
		document.frm.target="hidden_frame";
	    document.frm.encoding="multipart/form-data";
	 	document.frm.action="fe743_upload.jsp";
	  	document.frm.method="post";
	  	document.frm.submit();	
		return false;
		*/
		if (step == "0") {
			rdShowMessageDialog("��ȴ�ҳ����г�ʼ��......");
			controlBtn(false);
			return;
		} else if (step == "1") {
			unAvailableOpTypeArea();
			getArea("businessScene", "ҵ�񳡾���Ϣ", 20,0);
			initArea("businessScene");
			step = "2";
		} else if (step == "2") {
			unAvailableBusinessSceneArea();
			sceneId = $('#businessScene').val();
			step = "3";
			if(!hideAddProBtn) {
				setBtnDisabled();
			}
			if(sceneObj[sceneId] && sceneObj[sceneId] == '2'||sceneObj[sceneId] && sceneObj[sceneId] == '3'||sceneObj[sceneId] && sceneObj[sceneId] == '4') {
				getArea("PoInstanceQry", "ʵ����ѯ", 20,0);
				initArea("PoInstanceQry");
			}else {
				showLightBox();  
				setTimeout(mainRun, 50); //���÷���
			}
		//	controlBtn(false);
			return false;
		} else if (step == "3") {
			
			 
			
			if(rdShowConfirmDialog('ȷ���ύ��')==1){
				
				if($("#10985").html()!=null&&$("#10985").html()!=null&&($("#poSpec").val()=="010101016"||$("#poSpec").val()=="110163"||$("#poSpec").val()=="110154"
					||$("#poSpec").val()=="110155"||$("#poSpec").val()=="110156"||$("#poSpec").val()=="010101017"
						||$("#poSpec").val()=="110157"||$("#poSpec").val()=="110158"||$("#poSpec").val()=="110159"
							||$("#poSpec").val()=="110163"||$("#poSpec").val()=="010101007")){
					ajax_check_F10985();
					
				}
				if($("#10985").html()!=null&&$("#10985").val()!=""&&F10985_flag==0&&($("#poSpec").val()=="010101016"||$("#poSpec").val()=="110163"||$("#poSpec").val()=="110154"
					||$("#poSpec").val()=="110155"||$("#poSpec").val()=="110156"||$("#poSpec").val()=="010101017"
						||$("#poSpec").val()=="110157"||$("#poSpec").val()=="110158"||$("#poSpec").val()=="110159"
							||$("#poSpec").val()=="110163"||$("#poSpec").val()=="010101007")){
					return false;
				}
				var subFlag=false;
				if (typeof ($("#1101634417").val())!="undefined"&&typeof ($("#1101634418").val())!="undefined"){
					if($("#1101634417").val()!=""&&$("#1101634418").val()!=""&&($("#1101634417").val()==$("#1101634418").val())){
						rdShowMessageDialog("������IP��ַ�Ͷ��ű���IP��ַ������ͬ!1");
						subFlag=true;
					}
				}
				if(subFlag){
					return false;
				}
				if (typeof ($("#1101634419").val())!="undefined"&&typeof ($("#1101634420").val())!="undefined"){
					if($("#1101634419").val()!=""&&$("#1101634420").val()!=""&&($("#1101634419").val()==$("#1101634420").val())){
						rdShowMessageDialog("������IP��ַ�Ͳ��ű���IP��ַ������ͬ!1");
						subFlag=true;
					}
				}
				if(subFlag){
					return false;
				}
				
				var ht_tr_obj     ;
				var ht_tr_obj_html = "";
				$('body').find('select').each(function() {
						var _this = $(this);
						if(_this.html().indexOf("��ͬ����")!=-1){
							ht_tr_obj = _this.parent().parent().parent();		
							ht_tr_obj_html = ht_tr_obj.html();
						}
				});		
					
					
				var formids_1116013001 = "0";
				var scheck_1116013006 = "0";
				var scheck_HT = "0";
				
				$('body').find('select').each(function() {
					//���ұ����
					var _this = $(this);
					if(_this.parent().parent().find('td:eq(0)').text() == '1116013001') {
						
						if(_this.val().trim() == '1') {
							
								if(ht_tr_obj!=null&&ht_tr_obj!=""){
									ht_tr_obj.remove();
								}
								
								formids_1116013001="1";
								return false;
						} 
					}
				});			
				
				
			 if(formids_1116013001 == "1"){
					
					$('body').find('input[type="file"]').each(function() {
						//���ұ����
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1116013006') {
							hiddenTip(_this);
							if(_this.val().trim() == '') {
									showTip(_this,"����Դ��Ʒ�Ż����͡�Ϊ����Ѳ��ԡ�ʱ�����������뵥��Ϊ����");
									scheck_1116013006="1";
									return false;
							}
						}
					});
				
			}
			
				if(scheck_1116013006=="1") {
					return false;
				}
				
				
				
				
				
				//checkForm
				var formArray = document.forms;
				for(var i=0,len=formArray.length;i<len;i++) {
					if(!check(formArray[i])){
						return false;
					}	
				}
				
				
				

				
				
				
				
				/*diling add for ����������Ϊ��ͨ���ύ����Ʒ���Ϊ���ڷ�����ҵ��ʱ�� ��Ʒ����ֵ�б� ������ֵУ���Ƿ�ͨ��@2012/12/13*/
				//У��ҵ������ 
				if(!chkBusinessLimit($("#orderType").val(),$("#poSpec").val())){
				  return false;
				}
				
				//�ж����б����select�Ƿ��Ѿ�����
				var returnFalse = false;
				$('body').find('select').each(function() {
					//���ұ����
					var _this = $(this);
					if(_this.parent().find('font[class="orange"]').text() == '*') {
						if(_this.val() == '') {
							showTip(_this,"��ѡ��");
							returnFalse = true;
						}
					}
				});
				
				/***  begin  ���ڷ�����ҵ���Ż�@2014/8/11 ***/
				$('body').find("input[v_id^='resEndTime_']").each(function(i) {
					if(!chekResEndTime(this,i,2))  returnFalse = true;
				});
				$('body').find("input[v_id^='resFeeRebate_']").each(function(i) {
					if(!checkFeeRebate(this,i,2))  returnFalse = true;
				});
				/***  end  ���ڷ�����ҵ���Ż�@2014/8/11 ***/
				
				$('body').find('input[type="file"]').each(function() {
					//���ұ����
					var _this = $(this);
					if(_this.parent().find('font[class="orange"]').text() == '*') {
						//�����׺null
						//if(_this.val() == '' && !_this.parent().find('a>p').text()) {
						if(_this.val() == '') {
							showTip(_this,"��ѡ��");
							returnFalse = true;
						}
					}
					//����ģ���ļ�����׺������xls����
					if(_this.attr('class') == 'onlyXls') {
						var v = _this.val();
						if(v) {
							var lastIndex = v.lastIndexOf('.');
							if(lastIndex+1 < v.length && v.substring(lastIndex+1,v.length) == 'xls' || v.substring(lastIndex+1,v.length) == 'xlsx') {
								
							}else {
								showTip(_this,"��ѡ��excel�ļ���");
								returnFalse = true;
							}
						}	
					}
				});
				
						var formids_229017402="0";//���ѡ����229017402 ���ſͻ��йܷ�ʽΪ���й���ӿڷ�����ip��ַ������д
						var scheck_229017402="0";
					$('body').find('select').each(function() {
					//���ұ����
					var _this = $(this);
					if(_this.parent().parent().find('td:eq(0)').text() == '229017402') {
						if(_this.val() == '02') {
								formids_229017402="1";
								return false;
						}
					}
				});
				
				
				if(formids_229017402=="1") {
						
					$('body').find('input[type="text"]').each(function() {
					//���ұ����
					var _this = $(this);
					if(_this.parent().parent().find('td:eq(0)').text() == '229017417') {
						if(_this.val().trim() == '') {
								showTip(_this,"���й�ʱ���������д��");
								scheck_229017402="1";
								return false;
						}
					}
				});
				
				}
				
				if(scheck_229017402=="1") {
				return false;
				}
				
				
				/*2015/04/29 10:46:03 gaopeng �����·�ʡ��ҵ������MASҵ��֧��ʵʩ������֪ͨ ---begin---*/
				/*
					���Դ���Ϊ1101634024���Ƿ�ͨ���š��������ֵѡ���ǡ���
					��������Դ���Ϊ1101631019��1101634414��1101634415�����Ա���ѡ��
					ͬʱ�Զ���д����1101631019��ֵͬ1101631009������ͬ�� ---begin---
				*/
				var formids_1101634024 = "0";
				var scheck_1101634024 = "0";
				/*���Ż��������*/
				var val_1101631019 = "";
				/*���Ż��������*/
				var val_1101631009 = "";
				
				$('body').find('select').each(function() {
					//���ұ����
					var _this = $(this);
					if(_this.parent().parent().find('td:eq(0)').text() == '1101634024') {
						if(_this.val() == '��') {
								formids_1101634024="1";
								return false;
						}
					}
				});
				
				if(formids_1101634024 == "1"){
					
					/*��ȡ���Ž����*/
					$('body').find('input[type="text"]').each(function() {
					//���ұ����
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101631009') {
							val_1101631009 = _this.val().trim();
						}
					});
					/*��ȡ���Ž����*/
					$('body').find('input[type="text"]').each(function() {
					//���ұ����
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101631019') {
							val_1101631019 = _this.val().trim();
							if(_this.val().trim() == '') {
									showTip(_this,"��ͨ����ʱ�����Ż�������ű�����д��");
									scheck_1101634024="1";
									return false;
							}
							if(val_1101631019 != val_1101631009){
								showTip(_this,"��ͨ����ʱ�����Ż�������źͲ��Ż�������ű�����ͬ��");
								scheck_1101634024="1";
								return false;
							}
						}
					});
					
					$('body').find('input[type="text"]').each(function() {
					//���ұ����
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101634414') {
							if(_this.val().trim() == '') {
									showTip(_this,"��ͨ����ʱ��EC/SI����������ش��������д��");
									scheck_1101634024="1";
									return false;
							}
						}
					});
					$('body').find('input[type="text"]').each(function() {
					//���ұ����
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101634415') {
							if(_this.val().trim() == '') {
									showTip(_this,"��ͨ����ʱ��EC/SI��������������Ʊ�����д��");
									scheck_1101634024="1";
									return false;
							}
						}
					});
					
				}
				
				if(scheck_1101634024=="1") {
					return false;
				}
				
				/*
					���Դ���Ϊ1101634024���Ƿ�ͨ���š��������ֵѡ���ǡ���
					��������Դ���Ϊ1101631019��1101634414��1101634415�����Ա���ѡ��
					ͬʱ�Զ���д����1101631019��ֵͬ1101631009������ͬ�� ---end---
				*/
				
				/*
					�����Դ���Ϊ1101544008���������͡�ֵΪ2����������ʱ��������1101544009����ѡ��
					---begin---
				*/
				var formids_1101544008 = "0";
				var scheck_1101544008 = "0";
				
				$('body').find('select').each(function() {
					//���ұ����
					var _this = $(this);
					if(_this.parent().parent().find('td:eq(0)').text() == '1101544008') {
						
						if(_this.val().trim() == '0') {
								formids_1101544008="1";
								return false;
						}
					}
				});
				
				if(formids_1101544008 == "1"){
					
					$('body').find('select').each(function() {
					//���ұ����
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101544009') {
							
							if(_this.val().trim() == '') {
									showTip(_this,"��������Ϊ������ʱ����������;����ѡ��");
									scheck_1101544008="1";
									return false;
							}
						}
					});
				}
				
				if(scheck_1101544008=="1") {
					return false;
				}
				/*
					�����Դ���Ϊ1101544008���������͡�ֵΪ2����������ʱ��������1101544009����ѡ��
					---end---
				*/
				
				
	
				
				/*
					�����Դ���Ϊ1101554008���������͡�ֵΪ2����������ʱ��������1101554009����ѡ��
					---begin---
				*/
				var formids_1101554008 = "0";
				var scheck_1101554008 = "0";
				
				$('body').find('select').each(function() {
					//���ұ����
					var _this = $(this);
					if(_this.parent().parent().find('td:eq(0)').text() == '1101554008') {
						
						if(_this.val() == '0') {
								formids_1101554008="1";
								return false;
						}
					}
				});
				
				if(formids_1101554008 == "1"){
					
					$('body').find('select').each(function() {
					//���ұ����
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101554009') {
							
							if(_this.val().trim() == '') {
									showTip(_this,"��������Ϊ������ʱ����������;����ѡ��");
									scheck_1101554008="1";
									return false;
							}
						}
					});
				}
				
				if(scheck_1101554008=="1") {
					return false;
				}
				/*
					�����Դ���Ϊ1101554008���������͡�ֵΪ2����������ʱ��������1101554009����ѡ��
					---end---
				*/
				
				
				
				/*
					�������� 1101574011 ���������͡��������� 1101574002 �������Ϊ 1065096 ��ͷ��
					ϵͳĬ�ϡ�����������Ϊ1065097��ͷ��ϵͳĬ�ϡ������������������޸ġ�
					������1101574011��������ֵΪ2������ʱ������1101574012����ѡ����д
					---begin---
				*/
				var scheck_1101574002 = "0";
				/*������� ������ֵ*/
				var idVal_1101574002 = "";
				
				$('body').find('input[type="text"]').each(function() {
					//���ұ����
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101574002') {
							idVal_1101574002 = _this.val().trim();
						}
				});
				/*��ȡ�ַ���*/
				var subStr_idVal_1101574002 = idVal_1101574002.substring(0,7);
				if(subStr_idVal_1101574002 == "1065097"){
					/*��ȡ�������� ������ ������ Ĭ��*/
					$('body').find('select').each(function() {
					
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101574011') {
							/*ѭ��*/
							_this.find("option").each(function(){
								if($(this).val() == "0"){
									$(this).attr("selected","selected");
								}
							});
						}
					});
				}
				if(subStr_idVal_1101574002 == "1065096"){
					/*��ȡ�������� ������ ������ Ĭ��*/
					$('body').find('select').each(function() {
					
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101574011') {
							/*ѭ��*/
							_this.find("option").each(function(){
								if($(this).val() == "2"){
									$(this).attr("selected","selected");
								}
							});

						}
					});
				}
				
				/*������ʱ����������;����ѡ��*/
				$('body').find('select').each(function() {
					
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101574011') {
							var selVal = _this.find("option:selected").val();
							if(selVal == "0"){
								
								$('body').find('select').each(function() {
									//���ұ����
										var _this2 = $(this);
										if(_this2.parent().parent().find('td:eq(0)').text() == '1101574012') {
											var selVal1 = _this2.find("option:selected").val();
											if(selVal1.trim().length == "0"){
												showTip(_this,"��������Ϊ������ʱ����������;����ѡ��");
												scheck_1101574002="1";
												return false;
											}
										}
								});
								
							}
						}
					});
					
				if(scheck_1101574002=="1") {
					return false;
				}
				
				/*
					�������� 1101574011 ���������͡��������� 1101574002 �������Ϊ 1065096 ��ͷ��
					ϵͳĬ�ϡ�����������Ϊ1065097��ͷ��ϵͳĬ�ϡ������������������޸ġ�
					������1101574011��������ֵΪ2������ʱ������1101574012����ѡ����д
					---end---
				*/
				
				
				/*2015/04/29 10:46:03 gaopeng �����·�ʡ��ҵ������MASҵ��֧��ʵʩ������֪ͨ ---end---*/
				
				
				
				
						//��229017405����������ͺ�229012009���ſͻ����������з���У��
						var servicesIDtype="";
						var servicesIDcode="";
				   $('body').find('select').each(function() {
					//���ұ����
					var _this = $(this);
					if(_this.parent().parent().find('td:eq(0)').text() == '229017405') {
						if(_this.val() != '') {
								servicesIDtype=_this.val();
						}
					}
				});
				
									$('body').find('input[type="text"]').each(function() {
					//���ұ����
					var _this = $(this);
					if(_this.parent().parent().find('td:eq(0)').text() == '229012009') {
						if(_this.val().trim() != '') {
								servicesIDcode=_this.val();
						}
					}
				});
				
				if($("#orderType").val()=="open_submit") {
				if(servicesIDtype!="" && servicesIDcode!="") {
				
				  var myPacket = new AJAXPacket("checkServicesType.jsp","���ڽ���У�飬���Ժ�......");
					myPacket.data.add("opCode","<%=opCode%>");
					myPacket.data.add("shuxingdaima","229012009");
					myPacket.data.add("shuxingzhi",servicesIDcode);
					myPacket.data.add("fuwuleixing",servicesIDtype);
					myPacket.data.add("jituanbianhao",document.all.unit_id.value);
					core.ajax.sendPacket(myPacket,getReturncode);
					myPacket = null;
		
				}
				}
				
				 var scheckfls = $("#scheckflags").val();
				 var scheck_229012009="0";
					if(scheckfls!="") {			
						if(scheckfls!="000000") {	
							$('body').find('input[type="text"]').each(function() {
							//���ұ����
							var _this = $(this);
									if(_this.parent().parent().find('td:eq(0)').text() == '229012009') {
												showTip(_this,scheckfls);
												scheck_229012009="1";
												return false;
									}
							});	
						}			
					}
					
				if(scheck_229012009=="1") {
				return false;
				}
				
				
				$('body').find('.ListText').each(function() {
					//���ұ����
					var _this = $(this);
					if(_this.parent().find('font[class="orange"]').text() == '*') {
						if(_this.val() == '��ѡ��' || _this.val() == '') {
							showTip(_this,"��ѡ��");
							returnFalse = true;
						}
					}
				});
				
				
				/*RatePlanID  1107 �� 1109����ͬʱ����*/
				var ratePlanLength = $("select[name='RatePlanID']").length;
				if(ratePlanLength == 2){
					var tmpStr = "";
					$("select[name='RatePlanID']").each(function(){
						tmpStr += $(this).val()+",";
					});
					if((tmpStr.indexOf("1106") != -1 && tmpStr.indexOf("1110") == -1)
							|| (tmpStr.indexOf("1110") != -1 && tmpStr.indexOf("1106") == -1)
						){
						rdShowMessageDialog("�ʷѼƻ�1106��1110����ɶ�ѡ��1107��1109����ɶ�ѡ��",1);
						returnFalse = true;
					}else if((tmpStr.indexOf("1107") != -1 && tmpStr.indexOf("1109") == -1)
							|| (tmpStr.indexOf("1109") != -1 && tmpStr.indexOf("1107") == -1)
						){
						rdShowMessageDialog("�ʷѼƻ�1106��1110����ɶ�ѡ��1107��1109����ɶ�ѡ��",1);
						returnFalse = true;
					}
				}
				
				
				if(returnFalse) {
					return false;	
				}
				//����ֵ����rstJson����
				showLightBox();
				rstSubmit();
				var mapp = new Array();
				for(var f in fileMapping) {
					mapp.push(f + ":" + fileMapping[f]);
				}
				if(mapp.length > 0) {
					$('#mapping').val(mapp.join(';'));	
				}
				//liujian 2013-3-14 13:58:42 se743file������Ҫ���Ӳ�Ʒ������ϵ���� begin
				//�鿴��Ʒʵ��dom�ṹ����Ʒʵ��dom(ProdInsQry_sub_201208091001_1_Area)������Ʒ����������Ϣ(productorderinfoArea)
				//�Ͳ�Ʒ����ֵ�б�(ProductOrderCharactersArea)��areaFunctions��Ų�Ʒ�б���dom�ṹ
				if(areaFunctions) {
					// && areaFunctions.mainArea && areaFunctions.subArea
					for(var attr in areaFunctions) {
						var areaAttr = areaFunctions[attr];
						if(areaAttr.mainArea && areaAttr.subArea) {
							for(var v = 0,len = areaAttr.mainArea.length; v < len; v++) {
								//���Ҳ�Ʒʵ��(��;��ҵ��һ��)dom����
								var $parent = $('body').find('div[id$="' + areaAttr.mainArea[v] + '_Area"]');
								//���Ҵ˲�Ʒʵ���µĲ�Ʒ����������Ϣ
								var $productArea = $parent.find('div[id=productorderinfoArea]');	
								//�жϲ�Ʒ����������Ϣdom�Ƿ����
								if($productArea) {
									//��ò�Ʒ������ϵ�������
									var $productID = $productArea.find('input[name="ProductID"]')
									if($productID) {
										var productIDVal = $productID.val();
										//��fileUpload.jsp��ͨ��name��ȡ��Ʒ������ϵ����
										//name��������PRO_ʵ��id_����_ID:����PRO_301_1_ID(����PRO �� ID�ǹ̶�����ĸ)
										//��fileUpload.jsp�л�ȡʱʹ��request.getParameter('PRO_***_ID')�������Ϊ����ֵ��������Ϊ����
										var productIDName = 'PRO_' + areaAttr.mainArea[v].replace('sub_','') + '_ID';
										//��body���������ر���
										//alert(productIDVal + '---' + productIDName);
										$('#productIDs').val('{"' + productIDName + '":"' + productIDVal +'"}');
									}	
								}
							}	
						}
					}
				}
				//liujian 2013-3-14 13:58:42 se743file������Ҫ���Ӳ�Ʒ������ϵ���� end
				/* ningtn start */
				checkPrint();
				/* ningtn end */
				/*
				alert("�ύ");
				hideLightBox();
				return false;
				*/
				
				if(rdShowConfirmDialog("ȷ�ϵ��������")==1){
					document.frm.target="hidden_frame";
					document.frm.encoding="multipart/form-data";
					document.frm.action="fe743_upload.jsp";
					document.frm.method="post";
					document.frm.submit();	
			  }else{
			  	hideLightBox();
			  }
			  	
			}
		}
	}
	
		function getReturncode(packet){
	   var errorCode = packet.data.findValueByName("errorCode");
	   var errorMsg = packet.data.findValueByName("errorMsg");
	   
	   if(errorCode=="000000") {
	   $("#scheckflags").val(errorCode);
	   }else {
	    $("#scheckflags").val(errorMsg);
	   }
	}
	
	function checkPrint(){
		var json1Text = $("#json1").val();
	//	alert(json1Text);
		var json1Obj = eval('('+json1Text+')');
		var printFlag = "";
		if(typeof(json1Obj.input.ProductOrders) != "undefined" && json1Obj.input.ProductOrders != null){
			if(json1Obj.input.ProductOrders.length > 0){
				var oper = json1Obj.input.ProductOrders[0].OperationSubTypeID;
				if(oper == "1"){
					printFlag = "add";
				}else if(oper == "5"){
					printFlag = "update";
				}else if(oper == "2"){
					printFlag = "del";
				}
			}
		}
		//alert(json1Obj.input.ProductOrders[0].OfferName);
		if(printFlag != ""){
			doPrint(printFlag);
		}
	}
	function doPrint(printFlag){
	//alert("��ӡ���"+printFlag);
	var ret=showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes",printFlag);
}
function showPrtDlg(printType,DlgMessage,submitCfm,printFlag){  
	//��ʾ��ӡ�Ի���
	var h=210;
	var w=400;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;

	var printStr = printInfo(printFlag);

	var pType="subprint";              // ��ӡ���ͣ�print ��ӡ subprint �ϲ���ӡ
	var billType="1";               //  Ʊ�����ͣ�1���������2��Ʊ��3�վ�
	var sysAccept=$("#printAccept").val();               // ��ˮ��
	var mode_code="";               //�ʷѴ���
	var fav_code="";                 //�ط�����
	var area_code="";             //С������
	var opCode="e743";

	var phoneNo="";                  //�ͻ��绰

	var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
	var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_dz.jsp?DlgMsg=" + DlgMessage+ "&submitCfm=" + submitCfm;
	path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+sysAccept+"&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr.trim();


	var ret=window.showModalDialog(path.trim(),printStr,prop);
  return ret;
}
function printInfo(printFlag)
{
	//alert(printFlag);
	var cust_info="";
	var opr_info="";
	var note_info1="";
	var note_info2="";
	var note_info3="";
	var note_info4="";
	var retInfo = "";
	$("#custId").val("");
	$("#acconId").val("");
	
	/********������Ϣ��**********/
	cust_info+="EC���ſͻ����룺" +rstJson.input.CustomerNumber+"|";
	cust_info+="���ſͻ����ƣ�"+rstJson.input.CustomerName+"|";
	var idNo = "";
	var conNo = "";
	for(var i = 0; i < rstJson.input.ProductOrders.length; i++){
		if(typeof(rstJson.input.ProductOrders[i].id_no) != "undefined" && rstJson.input.ProductOrders[i].id_no != null){
			idNo += rstJson.input.ProductOrders[i].id_no+ "��";
		}
		if(typeof(rstJson.input.ProductOrders[i].ContractNo) != "undefined" && rstJson.input.ProductOrders[i].ContractNo != null){
			conNo += rstJson.input.ProductOrders[i].ContractNo+ "��";
		}
	}
	cust_info+="�����û�ID��"+idNo+"|";
	cust_info+="���ѷ�ʽ��"+"�ֽ�"+"|";
	cust_info+="�����˺ţ�"+conNo+"|";
	if(printFlag == "add"){
		opr_info+="����ҵ�񣺼��Ų�Ʒ����"+"|" ;
	}else if(printFlag == "del"){
		opr_info+="����ҵ�񣺼��Ų�Ʒ����"+"|" ;
	}else if(printFlag == "update"){
		opr_info+="����ҵ�񣺼��Ų�Ʒ���"+"|" ;
	}
	opr_info+="������ˮ��"+$("#printAccept").val()+"|" ;
	
	if(printFlag == "add"){
		var prodStr = "";
		
		for(var i = 0; i < rstJson.input.ProductOrders.length; i++){
			prodStr += rstJson.input.ProductOrders[i].OfferId + ":" + rstJson.input.ProductOrders[i].OfferName + "��";
		}
		
		opr_info+="�����Ʒ���ƣ�"+prodStr+"|" ;
	}else if(printFlag == "update"){
		opr_info+="ԭ��Ʒ���ƣ�"+""+"|" ;
		

		opr_info+="�²�Ʒ���ƣ�"+""+"|" ;
	}else if(printFlag == "del"){
		var prodStr = "";
		
		for(var i = 0; i < rstJson.input.ProductOrders.length; i++){
			prodStr += rstJson.input.ProductOrders[i].OfferId + ":" + rstJson.input.ProductOrders[i].OfferName + "��";
		}
		opr_info+="������Ʒ���ƣ�"+prodStr+"|" ;
	}
	/*******��ע��**********/
	note_info1="��ע��"+"|"
	
	retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
	retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
	return retInfo;
}
	
	function mainRun() {
		getServiceMsg("se743QryBSR", "doGetMainAreas",1, sceneId,in_ChanceId);
		hideLightBox();	
	}
	function resetPage() {
		location = $('#pageHref').val();	
	}
	//liujian ���ÿͻ���Ϣ��һ������
	function doGetMainAreas(data) {
		$('#json1').val(data.trim());
		showMainAreas();
	}
	
	//�������һ�����򣬲�չʾ��������
	//Ĭ�ϰ����е�json���뵽#json1��
	function showMainAreas() {
		var businessSceneRuleJson = eval("(" + $("#json1").val() + ")");
		if (businessSceneRuleJson.ElementTypes != null) {
			//liujian �������񷵻ص�json������չʾ
			for (var a = 0; a < businessSceneRuleJson.ElementTypes.length; a ++) {
				
				var busi_json_elType = businessSceneRuleJson.ElementTypes[a];
				mainAreaArray.push(busi_json_elType.ContainerPath);
				//alert("busi_json_elType.ContainerPath="+busi_json_elType.ContainerPath+"\nbusi_json_elType.ElementTypeName="+busi_json_elType.ElementTypeName);
				getArea(busi_json_elType.ContainerPath, busi_json_elType.ElementTypeName, 20,0);
				initArea(busi_json_elType.ContainerPath);
				if(($("#PoInstanceQry_table").length>0) && (busi_json_elType.ContainerPath=="productspecqry")){//�������ʵ����ѯ,���в�ѯ��Ʒ����б�����չʾ ��Ʒ����� ��������
				  getNextArea($("#PoInstanceQry_table input[name=product_ec_idHid]").val());
				}
			}
		} else {
			rdShowMessageDialog("��ȡ��Ʒ��Ҫ�ع������", 1);
			location = $('#pageHref').val();	
		}
	}
	
	function getBaseInfoObj() {
		rstJson.input.loginNo = '<%=workNo%>';
		rstJson.input.LoginPwd = '<%=password%>';
		rstJson.input.opCode = 'e743';
		rstJson.input.OrgCode = '<%=orgCode%>';
		rstJson.input.vRealIp = '<%=realip%>';
		rstJson.input.vFilePath = '<%=filePath%>';
		if(in_ChanceId != null && in_ChanceId != '') {
			rstJson.input.ChanceId = parseInt(in_ChanceId);	
		}else {
			rstJson.input.ChanceId = '';
		}
		var _wano = '<%=WaNo%>';
		if(_wano != null && _wano != '') {
			rstJson.input.WaNo = parseInt(_wano);	
		}else {
			rstJson.input.WaNo = '';
		}
	}

	function setEcCodeBtnHide() {
		hideEcCodeBtn = true;	
	}
	function setBtnDisabled() {
		//$('#submitBtn').attr('disabled','disabled');
	}
	function removeBtnDisabled() {
		$('#submitBtn').removeAttr('disabled');	
	}
	function remove743Tab() {
		removeCurrentTab();
	}
	function hideLightBoxFn() {
		hideLightBox();
	}

	/*���������������ſͻ���Ϣ����Ŀ(��Ʒ)Ͷ�ʺ������Զ���ƥ�䱨���ĺ�
	* liangyl 2016-08-22
	* 10985
	*/
	var F10985_flag=0;
	function ajax_check_F10985(){
		F10985_flag=0;
		if($("#10985").val()==""){
			F10985_flag=1;
		}
		else{
			var packet = new AJAXPacket("ajax_check_F10985.jsp","���Ժ�...");
	        packet.data.add("F10985_val",$("#10985").val());//
	    	core.ajax.sendPacket(packet,do_ajax_check_F10985);
	   	 	packet =null;	
		}
	}

	function do_ajax_check_F10985(packet){
	    var error_code = packet.data.findValueByName("code");//���ش���
	    var error_msg =  packet.data.findValueByName("msg");//������Ϣ
	    if(error_code=="000000"){//�����ɹ�
	    	var result_count =  packet.data.findValueByName("result_count");
	    	if(result_count=="0"){
	    		rdShowMessageDialog("�������Ŀ��Ŵ�����˶Ժ���������!");
	    	}
	    	else{
	    		F10985_flag=1;
	    	}
	    }else{//���÷���ʧ��
		    rdShowMessageDialog(error_code+":"+error_msg);
	    }
	}
</script>
</head>
<body>
<form name="frm" id="frm" action="" method="post" >
<%@ include file="/npage/include/header.jsp" %>
<div id="startDiv" style=""></div>
<div id="testFujian" style=""></div>
<table id="e743footerTable">
	<!--<input type="file" class="onlyXls" name="A501_1_999033734_0" />-->
	<input type="hidden" id="hiddenGarden"/>
	<input type="hidden" id="mapping" name="mapping"/>
	<input type="hidden" id="waNo" />
	<input type="hidden" name="pageHref" id="pageHref" value="" />
	<input type="hidden" name="productIDs" id="productIDs" value="" /> 
	<input type="hidden" name="inType" id="inType" value="" /> 
	<input type="hidden" name="printAccept" id="printAccept" value="<%=printAccept%>" /> 
	<input type="hidden" name="scheckflags" id="scheckflags" value="" /> 
		
	<tr>
		<td colspan="4" align="center" id="footer">
			<input class="b_foot" type="button" name="submitBtn" id="submitBtn" value="ȷ��" onclick="cfm();" />
			<input class="b_foot" type="button" name="backBtn" id="backBtn" value="����" onclick="resetPage();" />
			<input class="b_foot" type="button" name="closeBtn" id="closeBtn" value="�ر�" onclick="removeCurrentTab();" />
		</td>
	</tr>
</table>
<iframe name="hidden_frame" id="hidden_frame" style="display:none"></iframe>
<table style="display:none;">
	<tr>
		<td class="blue" width="20%">��������</td>
		<td width="80%">
			<textarea name="json1" id="json1" cols="100" rows="10"></textarea>
			<br>
			<textarea name="json2" id="json2" cols="100" rows="10"></textarea>
			<br>
			<textarea name="test2" id="test2" cols="100" rows="10"></textarea>
		</td>
	</tr>
</table>

<%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>