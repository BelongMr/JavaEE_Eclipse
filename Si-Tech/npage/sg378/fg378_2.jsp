<%
/*************************************
* 功  能: g378·虚拟V网用户办理 
* 版  本: version v1.0
* 开发商: si-tech
* 创建者: liujian @ 2012-12-31 13:52:45
**************************************/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="com.sitech.boss.util.page.*"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
	
	String opCode     =  request.getParameter("opCode");
    String opName     =  request.getParameter("opName");
    String workNo     = (String)session.getAttribute("workNo");
    String workName     = (String)session.getAttribute("workName");
    String password = (String) session.getAttribute("password");
    String regionCode = (String)session.getAttribute("regCode");
    String phoneNo = request.getParameter("phoneNo");
    String groupNo = request.getParameter("groupNo");
    String powerRight = WtcUtil.repNull((String)session.getAttribute("powerRight"));
	boolean qryFlag = false;
	String groupName = "";
	String groupNo_new = "";
	StringBuffer offerSb = new StringBuffer("");
%>
	<wtc:sequence name="TlsPubSelCrm" key="sMaxSysAccept" routerKey="regioncode" 
			routerValue="<%=regionCode%>"  id="loginAccept" />
	<wtc:service name="sVVpmnUnitQry"  retcode="retCode" retmsg="retMsg" outnum="2">
		<wtc:param value="<%=loginAccept%>"/>
		<wtc:param value="01"/>
		<wtc:param value="<%=opCode%>"/>
		<wtc:param value="<%=workNo%>"/>	
		<wtc:param value="<%=password%>"/>
		<wtc:param value="<%=phoneNo%>"/>
		<wtc:param value=""/>
		<wtc:param value="<%=groupNo%>"/>
	</wtc:service>
	<wtc:array id="qryArr"  scope="end"/>
<%
	if(retCode.equals("000000") && qryArr.length > 0) {
		qryFlag = true;
		groupName = qryArr[0][1];
		groupNo_new = qryArr[0][0];
%>
		<wtc:sequence name="TlsPubSelCrm" key="sMaxSysAccept" routerKey="regioncode" 
			routerValue="<%=regionCode%>"  id="loginAccept" />
		<wtc:service name="sPkgCodeQry" routerKey="region" routerValue="<%=regionCode%>" retcode="rstCode2" retmsg="rstMsg2" outnum="3">
			<wtc:param value="<%=loginAccept%>"/>
			<wtc:param value="01"/>
			<wtc:param value="<%=opCode%>"/>
			<wtc:param value="<%=workNo%>"/>	
			<wtc:param value="<%=password%>"/>
			<wtc:param value="<%=phoneNo%>"/>
			<wtc:param value=""/>
			<wtc:param value="<%=regionCode%>"/>
			<wtc:param value="<%=powerRight%>"/>
		</wtc:service>
		<wtc:array id="result_offer" scope="end"/>
<%
		if(rstCode2.equals("000000") && result_offer.length > 0) {
			for(int i=0; i<result_offer.length; i++) {
				  offerSb.append("<option value ='").append(result_offer[i][0]+"<-!->"+result_offer[i][2]).append("'>")
						 .append(result_offer[i][1])
						 .append("</option>");
			}
		}
		
	}
%>		        	
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title><%=opName%></title>
</head>

<script type=text/javascript>
  $(function() {
  		$(window.parent.document).find("iframe[@id='groupIframe']").css('height','0px');	
  		setCheckBtnDisabled(false);
  		$('#offerSelect').css('width','300px');
  		$('#offerSelect2').css('width','300px');
  		$('#userPhoneNo').keyup(function() {
  			setCheckBtnDisabled(false);	
  		});
  		$('#checkUserPhoneNo').click(function() {
  			 var packet = new AJAXPacket("fg378_3.jsp","正在获得相关信息，请稍候......");
			 var _data = packet.data;
			 _data.add("opCode","<%=opCode%>");
			 _data.add("groupPhoneNo",'<%=phoneNo%>');
			 _data.add("groupNo",'<%=groupNo_new%>');
			 _data.add("userPhoneNo",$('#userPhoneNo').val());
			 _data.add("method","checkUserNo");
			 core.ajax.sendPacket(packet,checkUserNoProcess);
			 packet = null;	
  		});
  		$('#addUserBtn').click(function() {
  			//liujian 2013-1-14 9:59:54 添加confirm
  			if(rdShowConfirmDialog('确认添加吗？') != 1){
  				return false;
  			}
  			
  			//window.parent.showBox();
  			if($('#checkStatus').val() != 'Y') {
  				rdShowMessageDialog("请先验证用户手机号码！",0);
  				return false;	
  			}else {
  			
  			var ret = showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes");
  if(typeof(ret)!="undefined")
  { 
    if((ret=="confirm"))
    {
      if(rdShowConfirmDialog('确认电子免填单吗？')==1)
      {
	   // frmCfm();
      }
	}
	if(ret=="continueSub")
	{
      if(rdShowConfirmDialog('确认要提交信息吗？')==1)
      {
	    //frmCfm();
      }
	}
  }
  else
  {
     if(rdShowConfirmDialog('确认要提交信息吗？')==1)
     {
	   //frmCfm();
     }
  }
  					var sm= new Array();
  					var offersid="";
  					sm =$('#offerSelect').val().split("<-!->");
						offersid=sm[0];
  				var packet = new AJAXPacket("fg378_3.jsp","正在获得相关信息，请稍候......");
				var _data = packet.data;
				_data.add("opCode","<%=opCode%>");
				_data.add("groupPhoneNo",'<%=phoneNo%>');
				_data.add("groupNo",'<%=groupNo_new%>');
				_data.add("groupName",'<%=groupName%>');
				_data.add("userPhoneNo",$('#userPhoneNo').val());
				_data.add("offerId",offersid);
				_data.add("method","addUser");
				core.ajax.sendPacket(packet,addUserNoProcess);
				packet = null;		
  			}
  		});
  		$('#clearUserBtn').click(function() {
  			$('#userPhoneNo').val('');
  			$('#usernamess').val('');
  			$('#offerSelect')[0].selectedIndex = 0;
  			$('#offerSelect2')[0].selectedIndex = 0;
  			setCheckBtnDisabled(false);	
  		});
  		if(<%=qryFlag%>) {
			$('#offerSelect').append("<%=offerSb.toString()%>");
			$('#offerSelect2').append("<%=offerSb.toString()%>");
			showTable();
		}else {
			 clearTable();
			 rdShowMessageDialog("错误代码：<%=retCode%>，错误信息：<%=retMsg%>",0);
		}
		//隐藏父页面的遮罩
		window.parent.hideBox();
  });
  
  function showTable() {
  	$('#groupTable').css('display','block');
  	$('#userTable').css('display','block');
  	$(window.parent.document).find("iframe[@id='groupIframe']").css('height',$("body").height()+20 + 'px');		
  }
  function clearTable() {
  		$('#tabList2').empty();
  		$('#groupTable').css('display','none');
  		$('#userTable').css('display','none');
  }
  
  function checkUserNoProcess(package) {
  	var checkCode = package.data.findValueByName("checkCode");
	var checkMsg = package.data.findValueByName("checkMsg");	
	var usernames = package.data.findValueByName("usernames");
	var loginAccept = package.data.findValueByName("loginAccept");
	if(checkCode == '000000' || checkCode == '0') {
		setCheckBtnDisabled(true);
		$('#usernamess').val(usernames);
		$('#loginAccept').val(loginAccept);
		
		rdShowMessageDialog("号码验证通过！");
	}else {
		setCheckBtnDisabled(false);
		rdShowMessageDialog("错误代码：" + checkCode +  "，错误信息：" + checkMsg,0);	
	}
  }
  function addUserNoProcess(package) {
  	var addRstCode = package.data.findValueByName("addRstCode");
	var addRstMsg = package.data.findValueByName("addRstMsg");	
	if(addRstCode == '000000' || addRstCode == '0') {
		setCheckBtnDisabled(false);
		$('#offerSelect')[0].selectedIndex = 0;
		$('#offerSelect2')[0].selectedIndex = 0;
		$('#userPhoneNo').val('');
		$('#usernamess').val('');
  		setCheckBtnDisabled(false);	
		rdShowMessageDialog("号码添加成功！");
		
	}else {
		rdShowMessageDialog("错误代码：" + addRstCode +  "，错误信息：" + addRstMsg,0);	
	}	
	window.parent.hideBox();
  }
  
  function setCheckBtnDisabled(flag) {
  		if(flag) {
  			$('#checkStatus').val('Y');	
  			$('#checkUserPhoneNo').attr('disabled','disabled');
			$('#addUserBtn').removeAttr('disabled');
  		}else {
  			$('#checkStatus').val('N');	
  			$('#checkUserPhoneNo').removeAttr('disabled');
			$('#addUserBtn').attr('disabled','disabled');
  		}
  		
  }
  
  function showPrtDlg(printType,DlgMessage,submitCfm)
{  //显示打印对话框
   var h=180;
   var w=350;
   var t=screen.availHeight/2-h/2;
   var l=screen.availWidth/2-w/2;

  var pType="subprint";             				 	//打印类型：print 打印 subprint 合并打印
	var billType="1";              				 			  //票价类型：1电子免填单、2发票、3收据
	var sysAccept =document.all.sysAccept.value;             	//流水号
	var printStr = printInfo(printType);			 		//调用printinfo()返回的打印内容
	var mode_code=null;           							  //资费代码
	var fav_code=null;                				 		//特服代码
	var area_code=null;             				 		  //小区代码
	var opCode="g378" ;                   			 	//操作代码
	var phoneNo=document.all.userPhoneNo.value;                  //客户电话

    var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
    var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_dz.jsp?DlgMsg=" + DlgMessage+ "&submitCfm=" + submitCfm;
    path+="&mode_code="+mode_code+
			"&fav_code="+fav_code+"&area_code="+area_code+
			"&opCode=<%=opCode%>&sysAccept="+sysAccept+
			"&phoneNo="+phoneNo+
			"&submitCfm="+submitCfm+"&pType="+
			pType+"&billType="+billType+ "&printInfo=" + printStr;
     var ret=window.showModalDialog(path,printStr,prop);
     return ret;
}

function printInfo(printType)
{
  					var sm= new Array();
  					var offersid="";
  					var offerscoments="";
  					sm =$('#offerSelect').val().split("<-!->");
						offersid=sm[0];
						offerscoments=sm[1];
	var cust_info="";  				//客户信息
	var opr_info="";   				//操作信息
	var note_info1=""; 				//备注1
	var note_info2=""; 				//备注2
	var note_info3=""; 				//备注3
	var note_info4=""; 				//备注4
	var retInfo = "";  				//打印内容
	//var _consumeTerm = parseInt(document.getElementById("Consume_Term").value,10);/* diling add 消费期限保留整数部分 2011/8/30 11:17:17 */

	opr_info+='<%=workNo%>'+' '+'<%=workName%>'+"|";
	opr_info+='<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
	cust_info+="手机号码："+document.all.userPhoneNo.value+"|";
	cust_info+="客户姓名："+document.all.usernamess.value+"|";	
	cust_info+="客户地址："+"|";
	cust_info+="集团编号：<%=groupNo_new%>"+"|";
	cust_info+="集团名称：<%=groupName%>"+"|";



	retInfo+=" "+"|";
	retInfo+=" "+"|";
	retInfo+=" "+"|";
	retInfo+=" "+"|";
	retInfo+=" "+"|";
	retInfo+=" "+"|";
	opr_info+="业务流水："+document.all.sysAccept.value+"|";
	opr_info+="业务类型：集团成员添加"+"|";
  opr_info+="集团产品名称：BOSS侧虚拟V网"+"|";
  opr_info+="BOSS侧虚拟V网资费套餐描述："+offersid+"--"+offerscoments+"|";
	opr_info+="集团成员添加，生效时间为24小时。"+"|"; /*diling add  增加业务有效期 2011/8/30 11:17:17 */

	note_info1+="备注："+"|";


	retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
	retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
    return retInfo;
}


function clickss() {
		if (document.getElementsByName("opFlag")[0].checked) {


			document.getElementById("dangehaoma").style.display = "block";
			document.getElementById("wenjian").style.display = "none";
			document.getElementById("wenjian2").style.display = "none";
		} else if (document.getElementsByName("opFlag")[1].checked) {
		document.getElementById("dangehaoma").style.display = "none";
		document.getElementById("wenjian").style.display = "block";
		document.getElementById("wenjian2").style.display = "block";
		
		}
}

				function addwenjian() {
							if(frm2.j1PosFile.value.length<1)
						{
							rdShowMessageDialog("数据文件错误，请重新选择数据文件！");
							document.frm2.j1PosFile.focus();
							return false;
						}
						var sm= new Array();
  					var offersid="";
  					var offerscoments="";
  					sm =$('#offerSelect2').val().split("<-!->");
						$('#offeridxuan').val(sm[0]);
						
						document.all.addUserBtnss.disabled=true;
						
						document.frm2.target="groupIframe";
				    document.frm2.action="fg378_upload.jsp?opCodess=<%=opCode%>&opName=<%=opName%>&groupName=<%=groupName%>&groupNo_new=<%=groupNo_new%>&phone_nos=<%=phoneNo%>&offeridxuan="+sm[0];
				    document.frm2.submit();
				}


</script>

<body>
<form name="frm2" action="" method="post" ENCTYPE="multipart/form-data">
		<div id="groupTable">
			<div id="Operation_Table" style="padding:0px">
					<table id="tabList2" cellspacing=0>
							<tr>	
								<th>集团号</th>			
								<th>集团名称</th>
							</tr>
							<%
								if(qryFlag) {
									out.println("<tr><td>" + groupNo_new + "</td>" +
											        "<td>" + groupName + "</td></tr>");
								}
							%>
							
					</table>
			</div>
		</div>
		
		<div id="userTable">
			<div class="title">
				<div id="title_zi">用户号码添加</div>
			</div>
			
			<div id="Operation_Table" style="padding:0px">
				<table cellspacing=0 >
					<tr>
				<td class='blue' nowrap width='18%'>号码输入方式</td>
        <td colspan="">
            <input type='radio' id='opFlag' name='opFlag' onClick='clickss()' value='vpmnMulti' checked/>号码输入
            <input type='radio' id='opFlag' name='opFlag' onClick='clickss()' value='vpmnFile' />文件录入
        </td>
        </tr>
      </table>
      <table  id="wenjian" name="wenjian" style="display:none">
    <tr>
        <td class='blue' nowrap width='18%'>录入文件</td>	   
        <td > 
            <input type="file" name="j1PosFile" id="j1PosFile" class="button"  />
        </td>
        <td class='blue'>选择资费</td>
						<td>
							<select id="offerSelect2" ></select>
						</td>
    </tr>
    <tr>        
             <font class='orange'>&nbsp;&nbsp; 上传文件为文本格式.txt文本文件，内容为：手机号码回车</font>

    </tr>
</table>
      <table id="dangehaoma">
					
				    <tr >
						<td class='blue'>手机号码</td>
						<td>
							<input type="hidden" name="checkStatus" id="checkStatus" value="" />
							<input type="text" name="userPhoneNo" id="userPhoneNo" value="" maxlength='11' onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
							<input type="button" value="校验" class="b_text" id="checkUserPhoneNo" />
						</td>
						<td class='blue'>用户姓名</td>
						<td>

							<input type="text" name="usernamess" id="usernamess" value=""  readOnly />


						</td>

						<td class='blue'>选择资费</td>
						<td>
							<select id="offerSelect"></select>
						</td>
				    </tr>
				    					    <tr id='footer'>
				        <td colspan='6'>
				            <input type="button"  id="addUserBtn" class='b_foot' value="添加" name="addUserBtn" />
				            <input type="button"  id="clearUserBtn" class='b_foot' value="清除" name="clearUserBtn" />
				        </td>
				    </tr>

				</table>
				
				 <table id="wenjian2" name="wenjian2" style="display:none">
				    					    
				   <tr id='footer'>
				        <td colspan='6'>
				            <input type="button" name="addUserBtnss"  id="addUserBtnss" class='b_foot' value="添加" onClick="addwenjian()" />
				             <input type="button" value="清除" class='b_foot' onclick="j1PosFile.outerHTML=j1PosFile.outerHTML">
				        </td>
				    </tr>

				</table>

			</div>
		</div>
  <input type='hidden' id='inputFiless' name='inputFiless' value="" />
	<input type="hidden" name="loginAccept" id="loginAccept" value="" />	
	<input type="hidden" name="sm_code" id="sm_code" value="vp" />
	<input type="hidden" name="sysAccept" id="sysAccept" value="<%=loginAccept%>" />
	<input type="hidden" name="groupName" id="groupName" value="<%=groupName%>" />
	<input type="hidden" name="groupNo_new" id="groupNo_new" value="<%=groupNo_new%>" />
	<input type="hidden" name="offeridxuan" id="offeridxuan"  />
	<input type="hidden" name="opCodess" id="opCodess" value="<%=opCode%>" />
</form>
</body>
</html>