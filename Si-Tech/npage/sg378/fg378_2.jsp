<%
/*************************************
* ��  ��: g378������V���û����� 
* ��  ��: version v1.0
* ������: si-tech
* ������: liujian @ 2012-12-31 13:52:45
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
  			 var packet = new AJAXPacket("fg378_3.jsp","���ڻ�������Ϣ�����Ժ�......");
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
  			//liujian 2013-1-14 9:59:54 ����confirm
  			if(rdShowConfirmDialog('ȷ��������') != 1){
  				return false;
  			}
  			
  			//window.parent.showBox();
  			if($('#checkStatus').val() != 'Y') {
  				rdShowMessageDialog("������֤�û��ֻ����룡",0);
  				return false;	
  			}else {
  			
  			var ret = showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes");
  if(typeof(ret)!="undefined")
  { 
    if((ret=="confirm"))
    {
      if(rdShowConfirmDialog('ȷ�ϵ��������')==1)
      {
	   // frmCfm();
      }
	}
	if(ret=="continueSub")
	{
      if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
      {
	    //frmCfm();
      }
	}
  }
  else
  {
     if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
     {
	   //frmCfm();
     }
  }
  					var sm= new Array();
  					var offersid="";
  					sm =$('#offerSelect').val().split("<-!->");
						offersid=sm[0];
  				var packet = new AJAXPacket("fg378_3.jsp","���ڻ�������Ϣ�����Ժ�......");
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
			 rdShowMessageDialog("������룺<%=retCode%>��������Ϣ��<%=retMsg%>",0);
		}
		//���ظ�ҳ�������
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
		
		rdShowMessageDialog("������֤ͨ����");
	}else {
		setCheckBtnDisabled(false);
		rdShowMessageDialog("������룺" + checkCode +  "��������Ϣ��" + checkMsg,0);	
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
		rdShowMessageDialog("�������ӳɹ���");
		
	}else {
		rdShowMessageDialog("������룺" + addRstCode +  "��������Ϣ��" + addRstMsg,0);	
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
{  //��ʾ��ӡ�Ի���
   var h=180;
   var w=350;
   var t=screen.availHeight/2-h/2;
   var l=screen.availWidth/2-w/2;

  var pType="subprint";             				 	//��ӡ���ͣ�print ��ӡ subprint �ϲ���ӡ
	var billType="1";              				 			  //Ʊ�����ͣ�1���������2��Ʊ��3�վ�
	var sysAccept =document.all.sysAccept.value;             	//��ˮ��
	var printStr = printInfo(printType);			 		//����printinfo()���صĴ�ӡ����
	var mode_code=null;           							  //�ʷѴ���
	var fav_code=null;                				 		//�ط�����
	var area_code=null;             				 		  //С������
	var opCode="g378" ;                   			 	//��������
	var phoneNo=document.all.userPhoneNo.value;                  //�ͻ��绰

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
	var cust_info="";  				//�ͻ���Ϣ
	var opr_info="";   				//������Ϣ
	var note_info1=""; 				//��ע1
	var note_info2=""; 				//��ע2
	var note_info3=""; 				//��ע3
	var note_info4=""; 				//��ע4
	var retInfo = "";  				//��ӡ����
	//var _consumeTerm = parseInt(document.getElementById("Consume_Term").value,10);/* diling add �������ޱ����������� 2011/8/30 11:17:17 */

	opr_info+='<%=workNo%>'+' '+'<%=workName%>'+"|";
	opr_info+='<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
	cust_info+="�ֻ����룺"+document.all.userPhoneNo.value+"|";
	cust_info+="�ͻ�������"+document.all.usernamess.value+"|";	
	cust_info+="�ͻ���ַ��"+"|";
	cust_info+="���ű�ţ�<%=groupNo_new%>"+"|";
	cust_info+="�������ƣ�<%=groupName%>"+"|";



	retInfo+=" "+"|";
	retInfo+=" "+"|";
	retInfo+=" "+"|";
	retInfo+=" "+"|";
	retInfo+=" "+"|";
	retInfo+=" "+"|";
	opr_info+="ҵ����ˮ��"+document.all.sysAccept.value+"|";
	opr_info+="ҵ�����ͣ����ų�Ա����"+"|";
  opr_info+="���Ų�Ʒ���ƣ�BOSS������V��"+"|";
  opr_info+="BOSS������V���ʷ��ײ�������"+offersid+"--"+offerscoments+"|";
	opr_info+="���ų�Ա���ӣ���Чʱ��Ϊ24Сʱ��"+"|"; /*diling add  ����ҵ����Ч�� 2011/8/30 11:17:17 */

	note_info1+="��ע��"+"|";


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
							rdShowMessageDialog("�����ļ�����������ѡ�������ļ���");
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
								<th>���ź�</th>			
								<th>��������</th>
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
				<div id="title_zi">�û���������</div>
			</div>
			
			<div id="Operation_Table" style="padding:0px">
				<table cellspacing=0 >
					<tr>
				<td class='blue' nowrap width='18%'>�������뷽ʽ</td>
        <td colspan="">
            <input type='radio' id='opFlag' name='opFlag' onClick='clickss()' value='vpmnMulti' checked/>��������
            <input type='radio' id='opFlag' name='opFlag' onClick='clickss()' value='vpmnFile' />�ļ�¼��
        </td>
        </tr>
      </table>
      <table  id="wenjian" name="wenjian" style="display:none">
    <tr>
        <td class='blue' nowrap width='18%'>¼���ļ�</td>	   
        <td > 
            <input type="file" name="j1PosFile" id="j1PosFile" class="button"  />
        </td>
        <td class='blue'>ѡ���ʷ�</td>
						<td>
							<select id="offerSelect2" ></select>
						</td>
    </tr>
    <tr>        
             <font class='orange'>&nbsp;&nbsp; �ϴ��ļ�Ϊ�ı���ʽ.txt�ı��ļ�������Ϊ���ֻ�����س�</font>

    </tr>
</table>
      <table id="dangehaoma">
					
				    <tr >
						<td class='blue'>�ֻ�����</td>
						<td>
							<input type="hidden" name="checkStatus" id="checkStatus" value="" />
							<input type="text" name="userPhoneNo" id="userPhoneNo" value="" maxlength='11' onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
							<input type="button" value="У��" class="b_text" id="checkUserPhoneNo" />
						</td>
						<td class='blue'>�û�����</td>
						<td>

							<input type="text" name="usernamess" id="usernamess" value=""  readOnly />


						</td>

						<td class='blue'>ѡ���ʷ�</td>
						<td>
							<select id="offerSelect"></select>
						</td>
				    </tr>
				    					    <tr id='footer'>
				        <td colspan='6'>
				            <input type="button"  id="addUserBtn" class='b_foot' value="����" name="addUserBtn" />
				            <input type="button"  id="clearUserBtn" class='b_foot' value="���" name="clearUserBtn" />
				        </td>
				    </tr>

				</table>
				
				 <table id="wenjian2" name="wenjian2" style="display:none">
				    					    
				   <tr id='footer'>
				        <td colspan='6'>
				            <input type="button" name="addUserBtnss"  id="addUserBtnss" class='b_foot' value="����" onClick="addwenjian()" />
				             <input type="button" value="���" class='b_foot' onclick="j1PosFile.outerHTML=j1PosFile.outerHTML">
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