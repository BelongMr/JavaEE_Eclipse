<%
  /*
   * 关于实现BOSS前台业务模糊验证业务的需求
   * 非实名制客户过户模糊校验
   * 日期: 2013-03-26
   * 作者: zhouby
   */
%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd Xhtml 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">
	<meta http-equiv="Expires" content="0">
	<style>
		.centre-op{
				margin: 0 auto;
				display: block;
				width: 80px;
		}
	</style>
<%
	request.setCharacterEncoding("GBK");
	response.setHeader("Pragma","No-Cache"); 
  response.setHeader("Cache-Control","No-Cache");
  response.setDateHeader("Expires", 0);
  
  String currentMonth = new java.text.SimpleDateFormat("MM", Locale.getDefault())
  												.format(new java.util.Date());
	String currentYear = new java.text.SimpleDateFormat("yyyy", Locale.getDefault())
  												.format(new java.util.Date());
  
  String opCode = (String)request.getParameter("opCode");
  String opName = (String)request.getParameter("opName");
  String workNo = (String)session.getAttribute("workNo");
  String regionCode = (String)session.getAttribute("regCode");
  String phoneNo = (String)request.getParameter("activePhone");
%>
<wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>" id="accept"/>
	
<title><%=opName%></title>

<script language="javascript">
  var Constants = {
  		CURRENT_MONTH: '<%=currentMonth%>',
  		CURRENT_YEAR: '<%=currentYear%>',
  		OP_CODE			: '<%=opCode%>',
  		CUST_NAME   : '',
  		PHONE_NO   : '<%=phoneNo%>',
  		ACCEPT   : '<%=accept%>'
  };
  
  function Page(){
      this.initOthers();
      this.years = []; //年月要对应
      this.months = [];//年月要对应
      this.limit = 0;	 //总限制条件，超过4才能发起最终检测请求
      this.phoneLimit = 0;//通话记录计数器。ps：5个有过通话记录的电话，算一个制约条件
  }
  
  Page.prototype.initOthers = function () {
      var self = this;
      
      $("#closeBtn").click(function(e){
          e.stopPropagation();
          e.preventDefault();
          
          self.closeWindow();
      });
      
      $('#submitBtn').click(function(e){
          e.stopPropagation();
          e.preventDefault();
          
          self.checkBusiness();
      });
      
      $('.checkPhone').click(function(e){
      		e.stopPropagation();
            e.preventDefault();
  			var checkPhoneList = $(this).prevAll('.com-phone');
  			var checkFlag = 0;
	  		checkPhoneList.each(function(){
	  				if($(this).val().length>0){
	  					checkFlag++;
	  				}
	  				
	  		});
			//只有5个验证号码都填的时候 才进行验证
	  		if(checkFlag>1){
	  			
	  			for(var i=0;i<checkPhoneList.length;i++){
	  				if (!checkElement(checkPhoneList[i])){							
  							return;
					}
	  			}
	  			self.checkPhone($(this));
	  		}
      		
      });
      
      $('.turnToOther').click(function(e){
      		e.stopPropagation();
          e.preventDefault();
          
      		window.location.href = $(this).attr('targetUrl');
      });
      
      self.getCustInfo();
      self.getInDate();
      self.getBillInfo();
      self.setupInputArea();
  }
  
  /**
  	* 限制条件制约器
  	*/
  Page.prototype.increase = function () {
  		this.limit++;
  		if (this.limit >= 4){
  				$('#submitBtn').attr('disabled', false);
  		} else {
  				$('#submitBtn').attr('disabled', true);
  		}
  }
  Page.prototype.reduce = function(){
  		this.limit--;
  		if (this.limit < 0 ){
  				this.limit = 0;
  		}
  }
  
  Page.prototype.closeWindow = function () {
      if(window.opener == undefined) {
          removeCurrentTab();
      } else {
          window.close();
      }
  }
  
  Page.prototype.submitForm = function () {
      this.printCommit(Constants.OP_CODE);
  }
  
  Page.prototype.getBillInfo = function () {
      var self = this;
      
      var packet = new AJAXPacket("fg551GetBillList.jsp", "正在获取数据，请稍候...");
      packet.data.add("phoneNo", "<%=phoneNo%>");
      core.ajax.sendPacket(packet, function(packet){
          self.setupPageForBill(packet);
      });
      packet = null;
  }
  
  Page.prototype.setupPageForBill = function(packet){
  		var self = this;
  		
  		var retCode = packet.data.findValueByName('retCode');
  		var retMsg = packet.data.findValueByName('retMsg');
			if (retCode != '000000'){
					$('#submitBtn').attr('disabled', 'true');
					rdShowMessageDialog("" + retCode + " " + retMsg , 1);
					return;
			}
			var result = packet.data.findValueByName('result');
			var t = '<tr>\
					  		<td>2</td>\
					      <td>交费时间&nbsp;%s</td>\
					  		<td>交费信息&nbsp;%s元</td>\
					  		<td>上月消费额度&nbsp;%s元</td>\
					      <td>\
					      	<label class="centre-op">\
					      		<input type="checkbox" class="checkMiniBox" value="">确认正确\
					      	</label>\
					      </td>\
					  	</tr>';
			t = t.replace(/%s/, result[0][0]);  	
			t = t.replace(/%s/, result[0][1]);  	
			t = t.replace(/%s/, result[0][2]);  	
			$(t).appendTo($('#summary-info'));
			
			//注册事件
			$('.checkMiniBox').click(function(e){
      		e.stopPropagation();
          
      		if ($(this).is(':checked')){
      				self.increase();
      		} else {
      				self.reduce();
      		}
      });
  }
  function User(name,age){
          this.preMonth=name;
          this.age=age;
          this.canFly=false;
  } 
  Page.prototype.setupInputArea = function(){
  		var self = this;
  		
  		//计算当前月份的前三个月分别是什么月份,注意类型
  		var t = parseInt(Constants.CURRENT_MONTH, 10);
  		var y = parseInt(Constants.CURRENT_YEAR, 10);
  		
  		this.months = [t - 3, t - 2, t - 1];
		this.years = [y, y, y];
		for(var i = 0; i < this.months.length; i++){
				if (this.months[i] <= 0){
						this.months[i] = this.months[i] + 12;
						this.years[i] = y - 1;
				}
				
				if(this.months[i] <= 9){
				    this.months[i] = '0' + this.months[i];
				}
		}
			
			//消费额度
			var m = '<span>%s月消费额度</span><input type="text" value=""  v_type="money" v_maxlength="30">（元）\
					 &nbsp;&nbsp;\
		       		 <span>%s月消费额度</span><input type="text" value=""  v_type="money" v_maxlength="30">（元）\
		       		 &nbsp;&nbsp;\
		       		 <span>%s月消费额度</span><input type="text" value=""  v_type="money" v_maxlength="30">（元）\
		       		 <input class="b_text" type="button" dateText="" monthValue="" moneyValue="" id="dateValue" value="检验">';
		    var monthValue = "";
			for (var i = 0; i < 3; i++){
					m = m.replace(/%s/, this.months[i]);
					//m = m.replace(/%s/, this.years[i] + '' + this.months[i]);
					monthValue += this.years[i] + '' + this.months[i]+",";
			}
			
			var preMonth = this.years[2] + '' + this.months[2];
			var s = $('#bill-area').empty().html(m).find('input[type="button"]').click(function(e){
					e.preventDefault();
					e.stopPropagation();
					$('#dateValue').attr("dateText",preMonth);
					var testList = $('#bill-area').find('input[type="text"]')
					var moneyValue = "";
					var inputCount=0;
					for(var i = 2 ; i>=0;i--){
						if (!checkElement(testList[i])){							
  							return;
						}
						if(testList[i].value=="undefined"||testList[i].value==null||testList[i].value.length<=0||testList[i].value==""){
							moneyValue += "mhcx,"; //增加判断如果不输入给计费服务传入默认值 mhcx yanpx 20130528
							
						}else{
							moneyValue += testList[i].value+",";
							inputCount++;
						}
					}
					
					if(inputCount==0){
							rdShowMessageDialog("请至少输入一个月的消费额度！");
							return;
					}
					$('#dateValue').attr("moneyValue",moneyValue.substring(0,(moneyValue.length-1)));
					$('#dateValue').attr("monthValue",monthValue.substring(0,(monthValue.length-1)));
					self.checkBill($(this));
			});
  }
  
  Page.prototype.checkBusiness = function(){
  		var packet = new AJAXPacket("fg551Cfm.jsp", "正在发送，请稍候...");
      packet.data.add("opCode", "<%=opCode%>");
      packet.data.add("phoneNo", '<%=phoneNo%>');
      packet.data.add("accept", '<%=accept%>');
      core.ajax.sendPacket(packet, function(packet){
      		var retCode = packet.data.findValueByName("retCode");
      		var retMsg = packet.data.findValueByName("retMsg");
      		
      		if (retCode != '000000'){
							$('#submitBtn').attr('disabled', 'true');
							rdShowMessageDialog("" + retCode + " " + retMsg , 1);
							return;
					}
      	
          var result = packet.data.findValueByName("result");
          if (result[0][0] == '000000'){
          		$('.turnToOther').attr('disabled', false);
          }
      });
      packet = null;
  }
  
  Page.prototype.checkPhone = function(button){
  		var self = this;
  		var targetPhoneNos = $("input[name=['thjlPhone']");
  		
  		var targetPhoneNo = '';
  		$("input[name='thjlPhone']").each(function(){
  				
  				targetPhoneNo += $(this).attr('value')+",";
  		});
  		targetPhoneNo = targetPhoneNo.substring(0,(targetPhoneNo.length-1));
  		var packet = new AJAXPacket("fg551CheckPhone.jsp", "正在检测，请稍候...");
      packet.data.add("originalPhoneNo", "<%=phoneNo%>");
      packet.data.add("targetPhoneNo", targetPhoneNo);
      packet.data.add("opCode", '<%=opCode%>');
      core.ajax.sendPacket(packet, function(packet){
      		var retCode = packet.data.findValueByName("retCode");
      		var retMsg = packet.data.findValueByName("retMsg");
      		
      		if (retCode != '000000'){
							$('#submitBtn').attr('disabled', 'true');
							rdShowMessageDialog("" + retCode + " " + retMsg , 1);
							return;
					}
      	
          var result = packet.data.findValueByName("result");
          
          if (result[0][2] == '0'){
          		rdShowMessageDialog( '验证通过！');
          		$(button).attr('disabled', 'disabled');
          		self.increase();
          } else {
          		rdShowMessageDialog(targetPhoneNo + '验证失败！' + retMsg, 1 );
          }
      });
      packet = null;
  }
  
  Page.prototype.checkBill = function(button){
		var self = this;
		var date = $('#dateValue').attr("dateText"); //格式YYYYMM
		var value = $('#dateValue').attr("moneyValue");//消费额度
		var monthValue = $('#dateValue').attr("monthValue");//时间 使用逗号分隔  201301,201302,201304,
		
		var packet = new AJAXPacket("fg551CheckBill.jsp", "正在检测，请稍候...");
    packet.data.add("phoneNo", "<%=phoneNo%>");
    packet.data.add("date", date);
    packet.data.add("value", value);
    core.ajax.sendPacket(packet, function(packet){
      var result = packet.data.findValueByName("result");
      var retCode = packet.data.findValueByName('retCode');
	  	var retMsg = packet.data.findValueByName('retMsg');
	  	var value = packet.data.findValueByName('value');
	  	var valArr = value.split(",");
	  	
      if (retCode != '000000'){
				$('#submitBtn').attr('disabled', 'true');
				rdShowMessageDialog("" + retCode + " " + retMsg , 1);
				return;
		  }
      if (result[0][39] == '0'){
    		rdShowMessageDialog('消费额度通过验证！');
    		$(button).attr('disabled', 'disabled');
    		self.increase();
      } else {
      	var monthVal = "";
		  	if(result[0][40] != "null" && result[0][41] != "null" && result[0][42] != "null"){
		  		monthVal = monthValue.split(",")[0];
		  	}
		  	if(result[0][40] != "null" && result[0][41] != "null" && result[0][42] == "null"){
		  		monthVal = monthValue.split(",")[1];
		  	}
		  	if(result[0][40] != "null" && result[0][41] == "null" && result[0][42] == "null"){
		  		monthVal = monthValue.split(",")[2];
		  	}
		  	
      	rdShowMessageDialog(monthVal+'消费额度未通过验证！', 0);
      }
  	});
    packet = null;
  }
  
  Page.prototype.printInfo = function (opcode){
			var cust_info="";
			var opr_info="";
			var note_info1="";
			var note_info2="";
			var note_info3="";
			var note_info4="";
			
			var retInfo = "";
			/************客户信息************/
			cust_info += "手机号码：" + Constants.PHONE_NO + "|";
			cust_info += "客户姓名：" + Constants.CUST_NAME + "|";
			
			/************受理内容************/
			opr_info += "业务类型：139邮箱业务" + $('select option:selected').text() + "功能申请，资费" + this.charge() + "|";
			opr_info += "操作类型：申请|";
			opr_info += "操作时间：" + Constants.CURRENT_DATE + '|';

			/************注意事项************/
			note_info1 += "备注：订购139邮箱业务" + this.detectTimeLong() + 
			"功能到期后不退订自动转为包月资费。您可在营业厅或发送短信0000到10086根据短信提示进行退订。详询10086。|";

			retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
			retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
			return retInfo;
	}
	
  //显示打印对话框
  Page.prototype.showPrtDlg = function(opcode, DlgMessage, submitCfm){
			var h=180;
			var w=350;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			
			var pType = "subprint";             				 		//打印类型：print 打印 subprint 合并打印
			var billType = "1";              				 			  //票价类型：1电子免填单、2发票、3收据
			var sysAccept = "<%=accept%>";       						//流水号
			var printStr 
			printStr = this.printInfo(opcode);   						//调用printinfo()返回的打印内容
			
			var mode_code=null;           							  	//资费代码
			var fav_code=null;                				 			//特服代码
			var area_code=null;             				 		  	//小区代码
			var phoneNo = <%=phoneNo%>;     					    	//客户电话
			var prop = "dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+
				"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
															 
			var path = "/npage/innet/hljBillPrint_jc_hw.jsp?DlgMsg=" + DlgMessage;
			path += "&mode_code="+mode_code+
				"&fav_code="+fav_code+"&area_code="+area_code+
				"&opCode="+opcode+"&sysAccept="+sysAccept+
				"&phoneNo=" + phoneNo+
				"&submitCfm="+submitCfm+"&pType="+
				pType+"&billType="+billType+ "&printInfo=" + printStr;
				
			var ret = window.showModalDialog(path,printStr,prop);
			return ret;
	}
  
  Page.prototype.printCommit = function (opCode){
			var self = this;
			var ret = this.showPrtDlg(opCode, "确实要进行电子免填单打印吗？", "Yes");
			if ((typeof(ret) == "undefined") || (ret=="continueSub")){
					if(rdShowConfirmDialog('确认要提交信息吗？') == 1){
							self.frmCfm();
					}
			} else if(ret == "confirm"){
					if(rdShowConfirmDialog('确认电子免填单吗？') == 1){
							self.frmCfm();
					}
			}
	}
	
	//本方法中提供了防止重复点击按钮的控制
	Page.prototype.frmCfm = function(){
			showLightBox();
			$('form').attr('action', 'fg511Cfm.jsp');
			if (!$('form').data('alreadySubmit')){
					$('form').data('alreadySubmit', true).submit();
			}
	}
	
	Page.prototype.getDateFromString = function(str){
			var t = str.substring(0,4) + '/' + str.substring(4,6) + '/' + str.substring(6,8);
			var m = new Date(t);
			return m.getTime();
	}
	
	Page.prototype.getCustInfo = function(){
			var packet = new AJAXPacket("../public/pubGetUserBaseInfo.jsp","正在获取数据，请稍候......");
      packet.data.add("opCode", "<%=opCode%>");
      packet.data.add("phoneNo", "<%=phoneNo%>");
      core.ajax.sendPacket(packet, function(packet){
      		Constants.CUST_NAME = packet.data.findValueByName('stPMcust_name');
      		$('#custName').text(Constants.CUST_NAME);
      });
      packet = null;
	}
	
	Page.prototype.getInDate = function(){
			var self = this;
			
			var packet = new AJAXPacket("fg551GetIn.jsp", "正在获取数据，请稍候...");
      packet.data.add("phoneNo", Constants.PHONE_NO);
      core.ajax.sendPacket(packet, function(packet){
      		self.setupInDate(packet);
      });
      packet = null;
	}
	
	Page.prototype.setupInDate = function(packet){
			var self = this;
			
			var result = packet.data.findValueByName('result');
			var t = '<tr>';
					t += 	'<td>1</td>';
					t +=  '<td colspan="3">入网时间&nbsp;%s</td>';
					t +=  '<td>';
					t +=  	'<label class="centre-op">';
					t +=  		'<input class="checkMiniBox" type="checkbox" value="">确认正确';
					t +=  	'</label>';
					t +=  '</td>';
					t +='</tr>';
			t = t.replace(/%s/g, result[0][4]);
			$(t).prependTo($('#summary-info'));
	}

  $(function(){
      var page = new Page();
  });
</script>
</head>
<body>
<form name="frm" method="post" action="">
  <input type="hidden" name="opCode" id="opCode" value="<%=opCode%>">
  <input type="hidden" name="opName" id="opName" value="<%=opName%>">
  <input type="hidden" name="sysAccept" value="<%=accept%>">
  <input type="hidden" name="phoneNo" value="<%=phoneNo%>">
  
  <%@ include file="/npage/include/header.jsp" %>
  <div class="title">
    <div id="title_zi">基本信息</div>
  </div>
  
  <table cellspacing="0">
  	<tr>
      <td class="blue" width="14%">客户姓名</td>
      <td width="36%" id="custName">
      </td>
      <td class="blue" width="14%">手机号</td>
      <td width="36%" id="phoneNo"><%=phoneNo%>
      </td>
    </tr>
  </table>
  <%@ include file="/npage/include/footer_simple.jsp" %>
  
  <div id="Main">
		<div id="Operation_Table"> 
		  <div class="title">
		    <div id="title_zi">信息区</div>
		  </div>
		  
		  <table cellspacing="0" id="summary-info"></table>
  	</div>
  </div>
  
  <div id="Main">
		<div id="Operation_Table"> 
		  <div class="title">
		    <div id="title_zi">输入区</div>
		  </div>
		  
		  <table cellspacing="0">
		  	<tr>
		  		<td class="blue" width="14%">最近3月消费额度</td>
		      <td width="86%" id="bill-area">
		      </td>
		  	</tr>
		  	
		  	<tr>
		  		<td class="blue" width="14%">通话记录</td>
		      <td width="86%">
		      	<input name="thjlPhone" type="text" class="com-phone" value="" v_type="phone" maxLength="11" v_must="1" onkeyup="this.value=this.value.replace(/\D/g,'')">
		      	<input name="thjlPhone" type="text" class="com-phone" value="" v_type="phone" maxLength="11" v_must="1" onkeyup="this.value=this.value.replace(/\D/g,'')">
		      	<input name="thjlPhone" type="text" class="com-phone" value="" v_type="phone" maxLength="11" v_must="1" onkeyup="this.value=this.value.replace(/\D/g,'')">
		      	<input class="b_text checkPhone" type="button" value="检验">
		      </td>
		  	</tr>

		    <tr>
		      <td colspan="4" align="center" id="footer">
		        <input class="b_foot" type=button name="submitBtn" id="submitBtn" value="确定" disabled="true">    
		        <input class="b_foot" type=button name="closeBtn" id="closeBtn" value="关闭">
		        <input class="b_foot turnToOther" type=button name="" value="GSM过户(1238)" disabled="true"
		         targetUrl="/npage/s1210/s1238Login.jsp?opCode=1238&opName=GSM过户&crmActiveOpCode=1238&activePhone=<%=phoneNo%>&accept=<%=accept%>&broadPhone=">
		        <input class="b_foot turnToOther" type=button name="" value="客户资料变更(1210)" disabled="true"
		         targetUrl="/npage/s1210/s1210Login.jsp?opCode=1210&opName=客户资料变更&crmActiveOpCode=1210&oriPhoneNo=<%=phoneNo%>&accept=<%=accept%>">
		      	<input class="b_foot turnToOther" type=button name="" value="实名登记(m058)" disabled="true"
		      	 targetUrl="/npage/sm058/s1238Login.jsp?opCode=m058&opName=实名登记&crmActiveOpCode=m058&activePhone=<%=phoneNo%>&accept=<%=accept%>&broadPhone=">
		      </td>
		    </tr>
		  </table>
  	</div>
  </div>
</form>
<%@ include file="/npage/include/pubLightBox.jsp" %>
</body>
</html>