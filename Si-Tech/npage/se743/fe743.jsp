<%
  /*
   * 功能: e743 全网集团业务订单受理
   * 版本: 1.0
   * 日期: 2012-03-31
   * 作者: wanghfa
   * 版权: si-tech
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
	String opName = "全网集团业务订单受理";
	String workNo = (String)session.getAttribute("workNo");
	String password = (String)session.getAttribute("password");
	String regionCode = (String)session.getAttribute("regCode");
	String orgCode = (String)session.getAttribute("orgCode");
	String filePath = request.getRealPath("/npage/tmp/");
	String in_ChanceId = request.getParameter("in_ChanceId");//从7453跳转过来的时候才有值，其他时候都是空
	String WaNo = request.getParameter("wa_no1");
	if(WaNo == null) {
		WaNo = "";
	}
	System.out.println("---liujian---in_ChanceId=" + in_ChanceId);
	
	//liujian 2013-5-17 10:43:20 添加esop来源
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
<title>全网集团业务订单受理</title>
<script language="javascript" type="text/javascript" src="json2.js"></script>
<script language="javascript" type="text/javascript" src="fe743_mainScript.js"></script>
<script language="javascript" type="text/javascript" src="multiSelect.js"></script>
<script type="text/javascript" src="/npage/public/pubLightBox.js"></script>	
<link rel="stylesheet" type="text/css" href="multiSelect.css" />
<script type=text/javascript>
	var interBOSS;
	var step = "0";	//0:默认; 1:初始化; 2:选择客户
	onload = function() {
		//设置重置的url
		var _href = window.location.href;
		var pageHref = _href.substring(_href.indexOf('fe743.jsp'),_href.length);
		$('#pageHref').val(pageHref);
		
		//设置in_ChanceId
		//in_ChanceId  wono chanceId是工作流订单号
		//waNo  是工作流工单号
		in_ChanceId ="<%=in_ChanceId%>";
		
		//liujian 2013-5-17 10:44:39 添加esop来源
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
			getArea("opType", "操作选择", 0,0);
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
		getArea("product", "产品信息", 20);
		getArea("accounting", "账务信息", 20);
		getArea("linkman", "联系人信息", 20);
		initArea("product");
		initArea("accounting");
		initArea("linkman");
		*/
		/*
		//附件列表
		getArea("POAttachment", "商品订购对应的附件信息", 0);
		initArea("POAttachment");
		
		//业务审批信息列表 POAudit 可操作
		getArea("POAudit", "业务审批信息列表", 0);
		initArea("POAudit");
		
		//商品订购的联系人信息 ContactorInfo
		getArea("ContactorInfo", "商品订购的联系人信息", 0);
		initArea("ContactorInfo");
		
		//产品属性值列表   ProductOrderCharacters
		getArea("ProductOrderCharacters", "产品属性值列表", 0);
		initArea("ProductOrderCharacters");
		
		//商品一次性消费 
		getArea("POOrderCharge", "商品一次性消费", 0);
		initArea("POOrderCharge");
		
		//产品一次性资费   ProductOrderCharge
		getArea("ProductOrderCharge", "产品一次性消费", 0);
		initArea("ProductOrderCharge");
	
		//支付省           PayCompanys
		getArea("PayCompanys", "支付省", 0);
		initArea("PayCompanys");
		
		
		//套餐列表 POOrderRatePolicys
		getArea("POOrderRatePolicys", "套餐列表", 0);
		initArea("POOrderRatePolicys");
		
		//产品规格列表
		getArea("productspecqry", "产品规格列表", 20,0);
		initArea("productspecqry");

		//产品级资费列表   ProductOrderRatePlans
		getArea("ProductOrderRatePlans", "产品级资费列表", 0);
		initArea("ProductOrderRatePlans");

		//产品订单基础信息 ProductOrderBase
		getArea("ProductOrderBase", "产品订单基础信息", 0);
		initArea("ProductOrderBase");
		
		//产品订单列表
		getArea("ProductOrderList", "产品订单列表", 0);
		initArea("ProductOrderList");
		
		//产级业务操作     ProductOrderBusinesses
		getArea("ProductOrderBusinesses", "产级业务操作", 0);
		initArea("ProductOrderBusinesses");

		//产品规格列表
		getArea("productRule", "产品规格列表", 20,0);
		initArea("productRule");
		
		
		getArea("ManageNode", "省BOSS上传管理节点", 20,0);
		initArea("ManageNode");
		*/
		
		/*关于申请制作集团客户信息化项目(产品)投资和收益自动化匹配报表的函
		 * liangyl 2016-08-22
		 * 10985
		 */
		if (typeof ($("#10985").val())!="undefined" ){
			$("#10985").parent().append("&nbsp;<input type='button' class='b_text' value='校验' onclick='ajax_check_F10985()' />"); 
		}		
	}

					
	//footer的确定按钮
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
			rdShowMessageDialog("请等待页面进行初始化......");
			controlBtn(false);
			return;
		} else if (step == "1") {
			unAvailableOpTypeArea();
			getArea("businessScene", "业务场景信息", 20,0);
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
				getArea("PoInstanceQry", "实例查询", 20,0);
				initArea("PoInstanceQry");
			}else {
				showLightBox();  
				setTimeout(mainRun, 50); //调用服务
			}
		//	controlBtn(false);
			return false;
		} else if (step == "3") {
			
			 
			
			if(rdShowConfirmDialog('确认提交吗？')==1){
				
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
						rdShowMessageDialog("短信主IP地址和短信备用IP地址不能相同!1");
						subFlag=true;
					}
				}
				if(subFlag){
					return false;
				}
				if (typeof ($("#1101634419").val())!="undefined"&&typeof ($("#1101634420").val())!="undefined"){
					if($("#1101634419").val()!=""&&$("#1101634420").val()!=""&&($("#1101634419").val()==$("#1101634420").val())){
						rdShowMessageDialog("彩信主IP地址和彩信备用IP地址不能相同!1");
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
						if(_this.html().indexOf("合同附件")!=-1){
							ht_tr_obj = _this.parent().parent().parent();		
							ht_tr_obj_html = ht_tr_obj.html();
						}
				});		
					
					
				var formids_1116013001 = "0";
				var scheck_1116013006 = "0";
				var scheck_HT = "0";
				
				$('body').find('select').each(function() {
					//查找必填的
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
						//查找必填的
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1116013006') {
							hiddenTip(_this);
							if(_this.val().trim() == '') {
									showTip(_this,"“资源产品优惠类型”为“免费测试”时，“测试申请单”为必填");
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
				
				
				

				
				
				
				
				/*diling add for 当订单类型为开通单提交，商品规格为公众服务云业务时， 产品属性值列表 的属性值校验是否通过@2012/12/13*/
				//校验业务限制 
				if(!chkBusinessLimit($("#orderType").val(),$("#poSpec").val())){
				  return false;
				}
				
				//判断所有必填的select是否已经必填
				var returnFalse = false;
				$('body').find('select').each(function() {
					//查找必填的
					var _this = $(this);
					if(_this.parent().find('font[class="orange"]').text() == '*') {
						if(_this.val() == '') {
							showTip(_this,"请选择！");
							returnFalse = true;
						}
					}
				});
				
				/***  begin  公众服务云业务优化@2014/8/11 ***/
				$('body').find("input[v_id^='resEndTime_']").each(function(i) {
					if(!chekResEndTime(this,i,2))  returnFalse = true;
				});
				$('body').find("input[v_id^='resFeeRebate_']").each(function(i) {
					if(!checkFeeRebate(this,i,2))  returnFalse = true;
				});
				/***  end  公众服务云业务优化@2014/8/11 ***/
				
				$('body').find('input[type="file"]').each(function() {
					//查找必填的
					var _this = $(this);
					if(_this.parent().find('font[class="orange"]').text() == '*') {
						//如果后缀null
						//if(_this.val() == '' && !_this.parent().find('a>p').text()) {
						if(_this.val() == '') {
							showTip(_this,"请选择！");
							returnFalse = true;
						}
					}
					//查找模板文件，后缀必须是xls或者
					if(_this.attr('class') == 'onlyXls') {
						var v = _this.val();
						if(v) {
							var lastIndex = v.lastIndexOf('.');
							if(lastIndex+1 < v.length && v.substring(lastIndex+1,v.length) == 'xls' || v.substring(lastIndex+1,v.length) == 'xlsx') {
								
							}else {
								showTip(_this,"请选择excel文件！");
								returnFalse = true;
							}
						}	
					}
				});
				
						var formids_229017402="0";//如果选择了229017402 集团客户托管方式为半托管则接口服务器ip地址必须填写
						var scheck_229017402="0";
					$('body').find('select').each(function() {
					//查找必填的
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
					//查找必填的
					var _this = $(this);
					if(_this.parent().parent().find('td:eq(0)').text() == '229017417') {
						if(_this.val().trim() == '') {
								showTip(_this,"半托管时此项必须填写！");
								scheck_229017402="1";
								return false;
						}
					}
				});
				
				}
				
				if(scheck_229017402=="1") {
				return false;
				}
				
				
				/*2015/04/29 10:46:03 gaopeng 关于下发省行业网关云MAS业务支撑实施方案的通知 ---begin---*/
				/*
					属性代码为1101634024“是否开通彩信“如果属性值选择”是“，
					则对于属性代码为1101631019、1101634414、1101634415的属性必须选择
					同时自动填写属性1101631019的值同1101631009属性相同。 ---begin---
				*/
				var formids_1101634024 = "0";
				var scheck_1101634024 = "0";
				/*彩信基本接入号*/
				var val_1101631019 = "";
				/*短信基本接入号*/
				var val_1101631009 = "";
				
				$('body').find('select').each(function() {
					//查找必填的
					var _this = $(this);
					if(_this.parent().parent().find('td:eq(0)').text() == '1101634024') {
						if(_this.val() == '是') {
								formids_1101634024="1";
								return false;
						}
					}
				});
				
				if(formids_1101634024 == "1"){
					
					/*获取短信接入号*/
					$('body').find('input[type="text"]').each(function() {
					//查找必填的
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101631009') {
							val_1101631009 = _this.val().trim();
						}
					});
					/*获取彩信接入号*/
					$('body').find('input[type="text"]').each(function() {
					//查找必填的
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101631019') {
							val_1101631019 = _this.val().trim();
							if(_this.val().trim() == '') {
									showTip(_this,"开通彩信时，彩信基本接入号必须填写！");
									scheck_1101634024="1";
									return false;
							}
							if(val_1101631019 != val_1101631009){
								showTip(_this,"开通彩信时，短信基本接入号和彩信基本接入号必须相同！");
								scheck_1101634024="1";
								return false;
							}
						}
					});
					
					$('body').find('input[type="text"]').each(function() {
					//查找必填的
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101634414') {
							if(_this.val().trim() == '') {
									showTip(_this,"开通彩信时，EC/SI接入彩信网关代码必须填写！");
									scheck_1101634024="1";
									return false;
							}
						}
					});
					$('body').find('input[type="text"]').each(function() {
					//查找必填的
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101634415') {
							if(_this.val().trim() == '') {
									showTip(_this,"开通彩信时，EC/SI接入彩信网关名称必须填写！");
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
					属性代码为1101634024“是否开通彩信“如果属性值选择”是“，
					则对于属性代码为1101631019、1101634414、1101634415的属性必须选择
					同时自动填写属性1101631019的值同1101631009属性相同。 ---end---
				*/
				
				/*
					当属性代码为1101544008“名单类型”值为2“黑名单”时，则属性1101544009必须选择。
					---begin---
				*/
				var formids_1101544008 = "0";
				var scheck_1101544008 = "0";
				
				$('body').find('select').each(function() {
					//查找必填的
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
					//查找必填的
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101544009') {
							
							if(_this.val().trim() == '') {
									showTip(_this,"名单类型为黑名单时，黑名单用途必须选择！");
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
					当属性代码为1101544008“名单类型”值为2“黑名单”时，则属性1101544009必须选择。
					---end---
				*/
				
				
	
				
				/*
					当属性代码为1101554008“名单类型”值为2“黑名单”时，则属性1101554009必须选择。
					---begin---
				*/
				var formids_1101554008 = "0";
				var scheck_1101554008 = "0";
				
				$('body').find('select').each(function() {
					//查找必填的
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
					//查找必填的
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101554009') {
							
							if(_this.val().trim() == '') {
									showTip(_this,"名单类型为黑名单时，黑名单用途必须选择！");
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
					当属性代码为1101554008“名单类型”值为2“黑名单”时，则属性1101554009必须选择。
					---end---
				*/
				
				
				
				/*
					对于属性 1101574011 “名单类型”，当属性 1101574002 服务代码为 1065096 开头，
					系统默认“白名单”；为1065097开头，系统默认“黑名单”。不允许修改。
					当属性1101574011名单类型值为2黑名单时，属性1101574012必须选择填写
					---begin---
				*/
				var scheck_1101574002 = "0";
				/*服务代码 输入框的值*/
				var idVal_1101574002 = "";
				
				$('body').find('input[type="text"]').each(function() {
					//查找必填的
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101574002') {
							idVal_1101574002 = _this.val().trim();
						}
				});
				/*截取字符串*/
				var subStr_idVal_1101574002 = idVal_1101574002.substring(0,7);
				if(subStr_idVal_1101574002 == "1065097"){
					/*获取名单类型 做限制 黑名单 默认*/
					$('body').find('select').each(function() {
					
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101574011') {
							/*循环*/
							_this.find("option").each(function(){
								if($(this).val() == "0"){
									$(this).attr("selected","selected");
								}
							});
						}
					});
				}
				if(subStr_idVal_1101574002 == "1065096"){
					/*获取名单类型 做限制 白名单 默认*/
					$('body').find('select').each(function() {
					
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101574011') {
							/*循环*/
							_this.find("option").each(function(){
								if($(this).val() == "2"){
									$(this).attr("selected","selected");
								}
							});

						}
					});
				}
				
				/*黑名单时，黑名单用途必须选择*/
				$('body').find('select').each(function() {
					
						var _this = $(this);
						if(_this.parent().parent().find('td:eq(0)').text() == '1101574011') {
							var selVal = _this.find("option:selected").val();
							if(selVal == "0"){
								
								$('body').find('select').each(function() {
									//查找必填的
										var _this2 = $(this);
										if(_this2.parent().parent().find('td:eq(0)').text() == '1101574012') {
											var selVal1 = _this2.find("option:selected").val();
											if(selVal1.trim().length == "0"){
												showTip(_this,"名单类型为黑名单时，黑名单用途必须选择！");
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
					对于属性 1101574011 “名单类型”，当属性 1101574002 服务代码为 1065096 开头，
					系统默认“白名单”；为1065097开头，系统默认“黑名单”。不允许修改。
					当属性1101574011名单类型值为2黑名单时，属性1101574012必须选择填写
					---end---
				*/
				
				
				/*2015/04/29 10:46:03 gaopeng 关于下发省行业网关云MAS业务支撑实施方案的通知 ---end---*/
				
				
				
				
						//对229017405服务代码类型和229012009集团客户服务代码进行服务校验
						var servicesIDtype="";
						var servicesIDcode="";
				   $('body').find('select').each(function() {
					//查找必填的
					var _this = $(this);
					if(_this.parent().parent().find('td:eq(0)').text() == '229017405') {
						if(_this.val() != '') {
								servicesIDtype=_this.val();
						}
					}
				});
				
									$('body').find('input[type="text"]').each(function() {
					//查找必填的
					var _this = $(this);
					if(_this.parent().parent().find('td:eq(0)').text() == '229012009') {
						if(_this.val().trim() != '') {
								servicesIDcode=_this.val();
						}
					}
				});
				
				if($("#orderType").val()=="open_submit") {
				if(servicesIDtype!="" && servicesIDcode!="") {
				
				  var myPacket = new AJAXPacket("checkServicesType.jsp","正在进行校验，请稍候......");
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
							//查找必填的
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
					//查找必填的
					var _this = $(this);
					if(_this.parent().find('font[class="orange"]').text() == '*') {
						if(_this.val() == '请选择' || _this.val() == '') {
							showTip(_this,"请选择！");
							returnFalse = true;
						}
					}
				});
				
				
				/*RatePlanID  1107 和 1109必须同时出现*/
				var ratePlanLength = $("select[name='RatePlanID']").length;
				if(ratePlanLength == 2){
					var tmpStr = "";
					$("select[name='RatePlanID']").each(function(){
						tmpStr += $(this).val()+",";
					});
					if((tmpStr.indexOf("1106") != -1 && tmpStr.indexOf("1110") == -1)
							|| (tmpStr.indexOf("1110") != -1 && tmpStr.indexOf("1106") == -1)
						){
						rdShowMessageDialog("资费计划1106、1110必须成对选择，1107、1109必须成对选择！",1);
						returnFalse = true;
					}else if((tmpStr.indexOf("1107") != -1 && tmpStr.indexOf("1109") == -1)
							|| (tmpStr.indexOf("1109") != -1 && tmpStr.indexOf("1107") == -1)
						){
						rdShowMessageDialog("资费计划1106、1110必须成对选择，1107、1109必须成对选择！",1);
						returnFalse = true;
					}
				}
				
				
				if(returnFalse) {
					return false;	
				}
				//返回值设置rstJson对象
				showLightBox();
				rstSubmit();
				var mapp = new Array();
				for(var f in fileMapping) {
					mapp.push(f + ":" + fileMapping[f]);
				}
				if(mapp.length > 0) {
					$('#mapping').val(mapp.join(';'));	
				}
				//liujian 2013-3-14 13:58:42 se743file服务需要添加产品订购关系编码 begin
				//查看产品实例dom结构：产品实例dom(ProdInsQry_sub_201208091001_1_Area)包含产品订单基本信息(productorderinfoArea)
				//和产品属性值列表(ProductOrderCharactersArea)，areaFunctions存放产品列表的dom结构
				if(areaFunctions) {
					// && areaFunctions.mainArea && areaFunctions.subArea
					for(var attr in areaFunctions) {
						var areaAttr = areaFunctions[attr];
						if(areaAttr.mainArea && areaAttr.subArea) {
							for(var v = 0,len = areaAttr.mainArea.length; v < len; v++) {
								//查找产品实例(在途等业务一样)dom对象
								var $parent = $('body').find('div[id$="' + areaAttr.mainArea[v] + '_Area"]');
								//查找此产品实例下的产品订单基本信息
								var $productArea = $parent.find('div[id=productorderinfoArea]');	
								//判断产品订单基本信息dom是否存在
								if($productArea) {
									//获得产品订购关系编码对象
									var $productID = $productArea.find('input[name="ProductID"]')
									if($productID) {
										var productIDVal = $productID.val();
										//在fileUpload.jsp中通过name获取产品订购关系编码
										//name命名规则PRO_实例id_序列_ID:比如PRO_301_1_ID(其中PRO 和 ID是固定的字母)
										//在fileUpload.jsp中获取时使用request.getParameter('PRO_***_ID')，如果不为空则传值，否则定义为‘’
										var productIDName = 'PRO_' + areaAttr.mainArea[v].replace('sub_','') + '_ID';
										//在body中添加隐藏表单
										//alert(productIDVal + '---' + productIDName);
										$('#productIDs').val('{"' + productIDName + '":"' + productIDVal +'"}');
									}	
								}
							}	
						}
					}
				}
				//liujian 2013-3-14 13:58:42 se743file服务需要添加产品订购关系编码 end
				/* ningtn start */
				checkPrint();
				/* ningtn end */
				/*
				alert("提交");
				hideLightBox();
				return false;
				*/
				
				if(rdShowConfirmDialog("确认电子免填单吗？")==1){
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
	//alert("打印免填单"+printFlag);
	var ret=showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes",printFlag);
}
function showPrtDlg(printType,DlgMessage,submitCfm,printFlag){  
	//显示打印对话框
	var h=210;
	var w=400;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;

	var printStr = printInfo(printFlag);

	var pType="subprint";              // 打印类型：print 打印 subprint 合并打印
	var billType="1";               //  票价类型：1电子免填单、2发票、3收据
	var sysAccept=$("#printAccept").val();               // 流水号
	var mode_code="";               //资费代码
	var fav_code="";                 //特服代码
	var area_code="";             //小区代码
	var opCode="e743";

	var phoneNo="";                  //客户电话

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
	
	/********基本信息类**********/
	cust_info+="EC集团客户编码：" +rstJson.input.CustomerNumber+"|";
	cust_info+="集团客户名称："+rstJson.input.CustomerName+"|";
	var idNo = "";
	var conNo = "";
	for(var i = 0; i < rstJson.input.ProductOrders.length; i++){
		if(typeof(rstJson.input.ProductOrders[i].id_no) != "undefined" && rstJson.input.ProductOrders[i].id_no != null){
			idNo += rstJson.input.ProductOrders[i].id_no+ "，";
		}
		if(typeof(rstJson.input.ProductOrders[i].ContractNo) != "undefined" && rstJson.input.ProductOrders[i].ContractNo != null){
			conNo += rstJson.input.ProductOrders[i].ContractNo+ "，";
		}
	}
	cust_info+="集团用户ID："+idNo+"|";
	cust_info+="付费方式："+"现金"+"|";
	cust_info+="付费账号："+conNo+"|";
	if(printFlag == "add"){
		opr_info+="申请业务：集团产品开户"+"|" ;
	}else if(printFlag == "del"){
		opr_info+="申请业务：集团产品销户"+"|" ;
	}else if(printFlag == "update"){
		opr_info+="申请业务：集团产品变更"+"|" ;
	}
	opr_info+="操作流水："+$("#printAccept").val()+"|" ;
	
	if(printFlag == "add"){
		var prodStr = "";
		
		for(var i = 0; i < rstJson.input.ProductOrders.length; i++){
			prodStr += rstJson.input.ProductOrders[i].OfferId + ":" + rstJson.input.ProductOrders[i].OfferName + "，";
		}
		
		opr_info+="申请产品名称："+prodStr+"|" ;
	}else if(printFlag == "update"){
		opr_info+="原产品名称："+""+"|" ;
		

		opr_info+="新产品名称："+""+"|" ;
	}else if(printFlag == "del"){
		var prodStr = "";
		
		for(var i = 0; i < rstJson.input.ProductOrders.length; i++){
			prodStr += rstJson.input.ProductOrders[i].OfferId + ":" + rstJson.input.ProductOrders[i].OfferName + "，";
		}
		opr_info+="销户产品名称："+prodStr+"|" ;
	}
	/*******备注类**********/
	note_info1="备注："+"|"
	
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
	//liujian 设置客户信息等一级区域
	function doGetMainAreas(data) {
		$('#json1').val(data.trim());
		showMainAreas();
	}
	
	//获得所有一级区域，并展示区域内容
	//默认把所有的json放入到#json1中
	function showMainAreas() {
		var businessSceneRuleJson = eval("(" + $("#json1").val() + ")");
		if (businessSceneRuleJson.ElementTypes != null) {
			//liujian 解析服务返回的json串进行展示
			for (var a = 0; a < businessSceneRuleJson.ElementTypes.length; a ++) {
				
				var busi_json_elType = businessSceneRuleJson.ElementTypes[a];
				mainAreaArray.push(busi_json_elType.ContainerPath);
				//alert("busi_json_elType.ContainerPath="+busi_json_elType.ContainerPath+"\nbusi_json_elType.ElementTypeName="+busi_json_elType.ElementTypeName);
				getArea(busi_json_elType.ContainerPath, busi_json_elType.ElementTypeName, 20,0);
				initArea(busi_json_elType.ContainerPath);
				if(($("#PoInstanceQry_table").length>0) && (busi_json_elType.ContainerPath=="productspecqry")){//如果存在实例查询,且有查询产品规格列表，则展示 产品规格编号 里面内容
				  getNextArea($("#PoInstanceQry_table input[name=product_ec_idHid]").val());
				}
			}
		} else {
			rdShowMessageDialog("读取商品级要素规则错误！", 1);
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

	/*关于申请制作集团客户信息化项目(产品)投资和收益自动化匹配报表的函
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
			var packet = new AJAXPacket("ajax_check_F10985.jsp","请稍后...");
	        packet.data.add("F10985_val",$("#10985").val());//
	    	core.ajax.sendPacket(packet,do_ajax_check_F10985);
	   	 	packet =null;	
		}
	}

	function do_ajax_check_F10985(packet){
	    var error_code = packet.data.findValueByName("code");//返回代码
	    var error_msg =  packet.data.findValueByName("msg");//返回信息
	    if(error_code=="000000"){//操作成功
	    	var result_count =  packet.data.findValueByName("result_count");
	    	if(result_count=="0"){
	    		rdShowMessageDialog("输入的项目编号错误请核对后重新输入!");
	    	}
	    	else{
	    		F10985_flag=1;
	    	}
	    }else{//调用服务失败
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
			<input class="b_foot" type="button" name="submitBtn" id="submitBtn" value="确认" onclick="cfm();" />
			<input class="b_foot" type="button" name="backBtn" id="backBtn" value="重置" onclick="resetPage();" />
			<input class="b_foot" type="button" name="closeBtn" id="closeBtn" value="关闭" onclick="removeCurrentTab();" />
		</td>
	</tr>
</table>
<iframe name="hidden_frame" id="hidden_frame" style="display:none"></iframe>
<table style="display:none;">
	<tr>
		<td class="blue" width="20%">测试区域</td>
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