<%
    /********************
     version v2.0
     ������: si-tech
     *
     *update:zhanghonga@2008-09-03 ҳ�����,�޸���ʽ
     *
     ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="../../npage/bill/getMaxAccept.jsp" %>

<%
  //String opCode = "2266";
  String opName = "����Ʒͳһ����";

  String loginNo = (String)session.getAttribute("workNo");
  String ip_Addr = request.getRemoteAddr();
  String loginNoPass = (String)session.getAttribute("password");
  String loginName = (String)session.getAttribute("workName");
  String orgCode = (String)session.getAttribute("orgCode");
  String strRegionCode = orgCode.substring(0,2);
  String IccId = "";
  String cust_address = "";
  String loginname = loginName;
  System.out.println("loginname="+loginname);
%>
<%
  String retFlag="";
  String f2266QueryRetMsg="";//�����ж�ҳ��ս���ʱ����ȷ��

  String strPhoneNo = request.getParameter("phone_no");
  String strAwardCode = request.getParameter("awardcode");
  String strAwardDetailCode = request.getParameter("detailcode");
  
  String strAwardName = "";
  if("01".equals(strAwardCode))
  {
    strAwardName = "01 --> Ӫ��������";
  }
  else if("02".equals(strAwardCode))
  {
    strAwardName = "02 --> ����������";
  }
  else if("03".equals(strAwardCode))
  {
    strAwardName = "03 --> ����������";
  }
  else if("04".equals(strAwardCode))
  {
    strAwardName = "04 --> ���ֶһ�";
  }
  String strDetailName = request.getParameter("detail_name");
  String strOpCode = request.getParameter("opFlag");			//�˵���������
  String strUserPasswd = "";//�û�����
  String opCode = strOpCode;
  String bp_name = "";
  String passwordFromSer = "";

	/*ȡ�û�������Ϣ*/
	String sqlStr = "select nvl(b.cust_name,'NULL'),"+
									"nvl(trim(b.id_iccid),'��'),"+
									"nvl(trim(b.cust_address),'��'),"+
									"user_passwd "+
									"from dcustmsg a, dcustdoc b "+
									"where a.cust_id = b.cust_id "+
									"and a.phone_no = '" + strPhoneNo + "'";
%>
		<wtc:pubselect name="sPubSelect" routerKey="phone" routerValue="<%=strPhoneNo%>" outnum="4">
    <wtc:sql><%=sqlStr%>
    </wtc:sql>
		</wtc:pubselect>
		<wtc:array id="baseArr" scope="end"/>
<%
	if(baseArr!=null&&baseArr.length>0){
		  bp_name = (baseArr[0][0]).trim();
		  IccId = (baseArr[0][1]).trim();
		  cust_address = (baseArr[0][2]).trim();
		  passwordFromSer = (baseArr[0][3]).trim();
	}

  if (bp_name.equals("")){
		retFlag = "1";
	  f2266QueryRetMsg = "�û����������ϢΪ�ջ򲻴���!<br>";
 	}

	//����title
	String titlename = "";  //��������
	String op_code = "";  //op_code

	if (strOpCode.equals("2266")){
		titlename = "����Ʒͳһ����";
	}else if (strOpCode.equals("2279")){
		titlename = "����Ʒͳһ��������";
	}else if (strOpCode.equals("2249")){
		titlename = "����Ʒͳһ����ԤԼ�Ǽ�";
	}

  System.out.println("strAwardName="+strAwardName);
  System.out.println("strDetailName="+strDetailName);
  System.out.println("strOpCode="+strOpCode);

  strAwardName = strAwardName.substring(strAwardName.indexOf("-->")+4,strAwardName.length());
  strDetailName = strDetailName.substring(strDetailName.indexOf("-->")+4,strDetailName.length());


  System.out.println("strAwardName="+strAwardName);
  System.out.println("strDetailName="+strDetailName);

 	String[] paraAray1 = new String[9];
  paraAray1[0] = loginNo; 			/* ��������   */
  paraAray1[1] = loginNoPass; 	/* ��������   */
  paraAray1[2] = strOpCode;			/* ��������*/
  paraAray1[3] = strPhoneNo;		/* �ֻ�����   */
  paraAray1[4] = strAwardCode;
  paraAray1[5] = strAwardDetailCode;
  paraAray1[6] = strOpCode;
  paraAray1[7] = strUserPasswd;
	/***
		strcpy(chLoginNo, input_parms[0]);
		strcpy(chLoginPasswd, input_parms[1]);
		strcpy(chOpCode, input_parms[2]);
		strcpy(chPhoneNo, input_parms[3]);
		strcpy(chAwardCode, input_parms[4]);
		strcpy(chDetailCode, input_parms[5]);
		strcpy(chInUserPasswd, input_parms[7]);
	***/
  for(int i=0; i<paraAray1.length; i++)
  {
        System.out.println(paraAray1[i]);
		if( paraAray1[i] == null )
		{
	  	paraAray1[i] = "";
		}
  }
  //retList = impl.callFXService("s2266Init", paraAray1, "12","phone",strPhoneNo);
%>
 	<wtc:service name="s2266Init" routerKey="phone" routerValue="<%=strPhoneNo%>" outnum="13" >
	<wtc:param value="<%=paraAray1[0]%>"/>
	<wtc:param value="<%=paraAray1[1]%>"/>
	<wtc:param value="<%=paraAray1[2]%>"/>
	<wtc:param value="<%=paraAray1[3]%>"/>
	<wtc:param value="<%=paraAray1[4]%>"/>
	<wtc:param value="<%=paraAray1[5]%>"/>
	<wtc:param value="<%=paraAray1[6]%>"/>
	<wtc:param value="<%=paraAray1[7]%>"/>
	</wtc:service>
	<wtc:array id="s2266InitArr" scope="end"/>
<%
 	int errCode = retCode==""?999999:Integer.parseInt(retCode);
  String errMsg = retMsg;

  if(s2266InitArr == null)
  {
		retFlag = "1";
	  f2266QueryRetMsg = "s2266Init��ѯ���������ϢΪ��!<br>" + "errCode: " + errCode + "<br>errMsg: " +  errMsg;
  }else if (errCode != 0){
  	retFlag = "1";
    f2266QueryRetMsg = "s2266Init��ѯ�û�����Ʒͳһ������Ϣʧ��!<br>" + "errCode: " + errCode + "<br>errMsg: " +  errMsg;
 	}
%>
	 <wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="phone" routerValue="<%=strPhoneNo%>" id="sLoginAccept"/>
<%
		/****�õ���ӡ��ˮ****/
		String printAccept="";
	  	printAccept = sLoginAccept;
	  	String cnttActivePhone = strPhoneNo;
%>
<html>
<head>
<%@ include file="../../npage/s1555/head_2266_javascript.htm" %>
<title><%=titlename%></title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<script language="JavaScript">
  <%if(retFlag.equals("1")){%>
    rdShowMessageDialog("<%=f2266QueryRetMsg%>");
   window.location.href="f2266.jsp?activePhone=<%=strPhoneNo%>";
  <%}%>
<!--
  //����Ӧ��ȫ�ֵı���
  var SUCC_CODE	= "0";   		//�Լ�Ӧ�ó�����
  var ERROR_CODE  = "1";			//�Լ�Ӧ�ó�����
  var YE_SUCC_CODE = "0000";	 	//����Ӫҵϵͳ������޸�

onload=function()
{
	if((<%=strAwardCode%>=="01")&&(<%=strAwardDetailCode%>=="2520"))
	{
		document.all.opNote.readOnly = false;
	}
}

 function changradio()
 {
		document.all.awardNo.value = "";
 		document.all.awardInfo.value = "";

		if (document.frm.opcode.value != "2279"){
			document.all.selectaward.style.display = "";
		}
		document.all.confirm.disabled = false;
 }

//У���Ƿ�ѡ���콱��¼
function checkIfSelect()
{
	var radio1 = document.getElementsByName("radio1");
	var doc = document.forms[0];
	var flag = 0;
	for(var i=0; i<radio1.length; i++)
	{
		if(radio1[i].checked)
		{
			var vFlag = eval("doc.flag"+radio1[i].value+".value.substr(0,4)");
			if(vFlag=="δ�����" )
			{
					rdShowConfirmDialog("��Ʒ�ڹ涨ʱ�䷶Χ��δ��ȡ,���Ѿ�������ȡ��");
					return false;
			}

			if(document.all.opcode.value=="2266" && vFlag=="����ȡ" )
			{
					rdShowConfirmDialog("����Ʒ�Ѿ���ȡ��");
					return false;
			}

			if (document.all.opcode.value=="2249" && vFlag=="�ѵǼ�")
			{
				rdShowConfirmDialog("����Ʒ�ѵǼǣ�");
				return false;
			}
			document.frm.awardId.value=eval("doc.awardId"+radio1[i].value+".value");
			document.frm.ressum.value=eval("doc.ressum"+radio1[i].value+".value");
			document.frm.flag.value=eval("doc.flag"+radio1[i].value+".value");
			document.frm.awardidname.value=eval("doc.awardidname"+radio1[i].value+".value");
			document.frm.payAccept.value=eval("doc.payAccept"+radio1[i].value+".value");
			document.frm.printPackageCont.value=eval("doc.printPackageCont"+radio1[i].value+".value");
			if (document.frm.opcode.value == "2279")
			{
				document.frm.awardInfo.value = eval("doc.awardidname"+radio1[i].value+".value");
				document.frm.ressum.value = eval("doc.ressum"+radio1[i].value+".value");
			}
			flag=1;
			break;
		}
	}
	if(flag==0)
	{
		rdShowConfirmDialog("��ѡ��һ���콱��¼��");
		return false;
	}
	return true;
}


/******Ϊ��ע��ֵ********/
function setOpNote()
{
	if(document.frm.opNote.value=="")
	{
		if (document.frm.opcode.value == "2279"){
	  	document.frm.opNote.value = "�û�"+document.frm.phoneNo.value+"�콱����";
	  }else if (document.frm.opcode.value == "2249"){
	  	document.frm.opNote.value = "�û�"+document.frm.phoneNo.value+"ԤԼ�Ǽ�";
		}else{
			document.frm.opNote.value = "�û�"+document.frm.phoneNo.value+"�콱";
		}
	}
	return true;
}

function printCommit()
{
	getAfterPrompt();
	document.all.confirm.disabled = true;
	with(document.frm){

		if (opcode.value == "2266" || opcode.value == "2249" || opcode.value == "2279"){
			//����Ǹ�����Ǽ�
//			if (awardId.value.substring(0,1) == "G"){
			if (opcode.value != "2279"){
				if(awardNo.value==""){
					rdShowConfirmDialog("��ѡ�����Ʒ!");
					awardNo.focus();
					return false;
				}
			 }

				setOpNote();//��ע��ֵ

				if (document.frm.opNote.value.length > 30){
			 		rdShowConfirmDialog("����ı�ע��Ϣ����");
					return false;
				}
		}else{
			document.frm.opNote.value = "����Ʒͳһ��������";
		}

	if(!(checkIfSelect()))
		return false;

	if (awardId.value.substring(0,1) != "D"){
		document.frm.printPackageCont.value = document.all.awardInfo.value + "~"+document.frm.ressum.value+"~";
	}

  var varPrintInfo = '<%=loginName%>'+"|"
    +document.frm.phoneNo.value.trim()+"|"
    +document.frm.bp_name.value.trim()+"|"
  	+document.frm.IccId.value.trim()+"|"
  	+document.frm.cust_address.value.trim()+"|"
  	+'<%=strOpCode%>'+"|"
  	+document.frm.printAccept.value.trim()+"|"
  	+document.frm.awardInfo.value.trim()+"|"
  	+document.frm.opNote.value.trim()+"|"
  	+document.frm.ressum.value.trim()+"|"
  	+document.frm.printPackageCont.value.trim()+"|";

	//��ӡ�������ύ����
	var ret = showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes",varPrintInfo);
  	if(typeof(ret)!="undefined")
  	{
  		if((ret=="confirm"))
  		{
	    	if(rdShowConfirmDialog('ȷ�ϵ����������ȷ��,���ύ����ҵ��!')==1)
	    	{
	    		if(awardId.value.substring(0,1)=='G')
	    		{
	    			awardId.value=awardId.value+"|"+awardNo.value;

	    		}
	    		document.all.printcount.value="1";
		    	frmCfm();
	      	}
		}

	  	if(ret=="continueSub"){
	    	if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
	    	{
	    		if(awardId.value.substring(0,1)=='G')
	    		{
	    			awardId.value=awardId.value+"|"+awardNo.value;

	    		}
	    		document.all.printcount.value="0";
		    	frmCfm();
	      	}
		}
	}else
	{
	  	if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
	  	{
	  		  if(awardId.value.subtring(0,1)=='G')
	    		{
	    			awardId.value=awardId.value+"|"+awardNo.value;

	    		}
	    	document.all.printcount.value="0";
		  	frmCfm();
	    }
	}
	return true;
	}
}


/**��ѯ��Ʒ**/
function getAwardInfo()
{
	//���ù���js�õ���Ʒ
  var pageTitle = "����Ʒ�����ѯ";
  var fieldName = "ѡ��|����Ʒ����|����Ʒ����|����|";//����������ʾ���С�����
  var sqlStr = "";
  if ("P" == document.frm.awardId.value.substring(0,1))//��Ʒ��
  {
  	sqlStr = "select distinct 'ѡ��',a.PACKAGE_CODE,a.PACKAGE_NAME,' ' "+
  					 "from dbgiftrun.RS_PROGIFT_PACKAGE_INFO a, dbgiftrun.rs_chngroup_rel b "+
  					 "where a.group_id = b.parent_group_id "+
  					 " and a.valid_flag=1 "+
  					 " and a.PACKAGE_CODE='"+document.frm.awardId.value.substring(1,document.frm.awardId.value.length)
  					 +"' and b.group_id=(select group_id from dloginmsg where login_no='"+"<%=loginNo%>"+"')";
  }else if ("G" == document.frm.awardId.value.substring(0,1))//��Ʒ�ȼ�
  {
  	sqlStr="select distinct 'ѡ��',b.res_code,b.res_name,' ' "+
  				 "from dbgiftrun.sChnActiveGrade a, dbgiftrun.rs_code_info b ,dbgiftrun.sChnActiveGradeCfg c,dbgiftrun.rs_chngroup_rel d "+
  				 "where a.GRADE_CODE = c.GRADE_CODE "+
  				 "and b.RES_CODE = c.RES_CODE "+
  				 "and c.group_id = d.parent_group_id "+
  				 "and c.PACKAGE_FLAG = 'N' "+
  				 "and d.group_id = (select group_id from dloginmsg where login_no='"+"<%=loginNo%>"+"') "+
  				 "and a.grade_code= '"+document.frm.awardId.value.substring(1,document.frm.awardId.value.length)+"' "+
  				 "union all "+
  				 "select 'ѡ��','P'||d.PACKAGE_CODE,d.PACKAGE_NAME,' ' "+
					 "from dbgiftrun.sChnActiveGrade a, dbgiftrun.sChnActiveGradeCfg b,dbgiftrun.rs_chngroup_rel c,dbgiftrun.RS_PROGIFT_PACKAGE_INFO d "+
					 "where a.GRADE_CODE = b.GRADE_CODE "+
 					 " and b.group_id = c.parent_group_id "+
 					 " and b.RES_CODE = d.PACKAGE_CODE "+
 					 " and b.PACKAGE_FLAG = 'Y' "+
 					 " and d.valid_flag=1 " +
 					 " and c.group_id = (select group_id from dloginmsg where login_no='"+"<%=loginNo%>"+"') "+
 					 " and a.grade_code='"+document.frm.awardId.value.substring(1,document.frm.awardId.value.length)+"' ";
  }else if ("D" == document.frm.awardId.value.substring(0,1))//BOSS��̬��ڰ�
  {
	sqlStr="select distinct 'ѡ��',a.package_code,c.res_name,b.res_sum "+
		   "from dDynamicPackage a, dDynamicPackageDetail b,dbgiftrun.rs_code_info c "+
		   "where a.package_code = b.package_code "+
		   "and b.res_code = c.RES_CODE "+
		   "and a.package_code = '"+document.frm.awardId.value.substring(1,document.frm.awardId.value.length)+"' ";
  }else{
  	sqlStr="select 'ѡ��',res_code,res_name,' ' from dbgiftrun.rs_code_info where res_code = '"+document.frm.awardId.value+"' order by res_code";
  }

  var selType = "S";    //'S'��ѡ��'M'��ѡ
  var retQuence = "2|1|2|";//�����ֶ�
  var retToField = "awardNo|awardInfo|";//���ظ�ֵ����

  if(PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField))
	changeResCode();
}
function PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
  var path = "<%=request.getContextPath()%>/npage/public/fPubSimpSel.jsp";
  path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
  path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
  path = path + "&selType=" + selType;
  retInfo = window.showModalDialog(path);
  if(retInfo ==undefined)
  {
		return false;
  }

  var chPos_field = retToField.indexOf("|");
  var chPos_retStr;
  var valueStr;
  var obj;
  var iRec = 0;
  while(chPos_field > -1)
  {
    iRec = iRec+1;
    obj = retToField.substring(0,chPos_field);
    chPos_retInfo = retInfo.indexOf("|");
    valueStr = retInfo.substring(0,chPos_retInfo);
		if (iRec ==2)
		{						
				document.all(obj).value = valueStr;
   	   }else
   	   {
    		document.all(obj).value = valueStr;
   	   }
    retToField = retToField.substring(chPos_field + 1);
    retInfo = retInfo.substring(chPos_retInfo + 1);
    chPos_field = retToField.indexOf("|");
  }
	return true;
}

function cardInfo(packet)
{
	var result = packet.data.findValueByName("result");
	if(result == "true")
	{
		document.forms[0].cardType.value = packet.data.findValueByName("card_type");
		document.forms[0].cardNum.value = packet.data.findValueByName("card_num");
		document.all.checkCardNo.style.display = "block";
	}
}

/*��Ʒ���Ʊ仯��������*/
function changeResCode()
{
	if (document.frm.opcode.value == "2266")
	{
		var res_code = document.forms[0].awardNo.value;
		checkResName(res_code);
	}
}

function checkResName(res_code)
{
	//���ݳ�ʼ��
	document.forms[0].cardType.value = "";
	document.forms[0].cardNum.value = "";
	document.forms[0].card_no.value = "";
	document.all.checkCardNo.style.display = "none";

	if(res_code != "00000000")
	{
		//һ��Ҫ��ͬ������.
		var myPacket = new AJAXPacket("fGetCardInfo.jsp", "��ѯ��Ʒ�����ϸ,���Ե�...");
		myPacket.data.add("res_code",res_code);
	    core.ajax.sendPacket(myPacket,cardInfo);
	    myPacket = null;
	}
}

/*��ѯ�ֻ���ֵ��*/
function checkCard()
{
	var prop="dialogHeight:300px; dialogWidth:550px; dialogLeft:400px; dialogTop:400px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
	card_num = parseInt(document.forms[0].cardNum.value);
	if(card_num == -1)
	{
		card_num = document.forms[0].ressum.value;
	}
	card_type = document.forms[0].cardType.value;
	var ret = window.showModalDialog("./f2266_query_card.jsp?card_num="+card_num+"&card_type="+card_type,"",prop);
	if(ret)
	{
		document.all.card_no.value = ret;
	}
	else
	{
		//do Nothing
		;
	}
}

//-->
</script>
</head>


<body>
<form name="frm" method="post">
<%@ include file="/npage/include/header.jsp" %>
<div class="title">
    <div id="title_zi">�û���Ϣ</div>
</div>
<table cellspacing="0">
    <tr>
        <td class="blue">�ֻ�����</td>
        <td>
            <input name="phoneNo" class="InputGrey" type="text" id="phoneNo" value="<%=strPhoneNo%>" readonly>
        <td class="blue">�ͻ�����</td>
        <td>
            <input name="bp_name" class="InputGrey" type="text" id="bp_name" size="60" value="<%=bp_name%>" readonly>
        </td>
    </tr>
</table>
<table cellspacing="0">
    <tr>
        <td class="blue">����֤��</td>
        <td>
            <input name="IccId" class="InputGrey" type="text" id="IccId" value="<%=IccId%>" readonly>
        </td>
        <td class="blue">�ͻ���ַ</td>
        <td>
            <input name="cust_address" class="InputGrey" type="text" id="cust_address" size="60" value="<%=cust_address%>" readonly>
        </td>
    </tr>
</table>
 </div>
 <div id="Operation_Table">
	<div class="title">
		<div id="title_zi">������ϸ</div>
	</div>
	<TABLE cellSpacing="0">
   	<TBODY>
		  <tr align="center">
	  		<th>ѡ��</td>
			  <th>��Ʒ���</th>
			  <th>Ӫ��������</th>
			  <th>����</th>
			  <th>��Ʒ����</th>
			  <th>��ȡ��־</th>
			  <th>�н�����</th>
			  <th>������ˮ</th>
			  <th>�콱����</th>
			  <th>�콱����</th>
		  </tr>
		  </tr>
  <%
  		String tbclass="";
		  for(int j=0;j<s2266InitArr.length;j++){
		  	if(j%2==0){
		  		tbclass="Grey";
		  	}else{
		  		tbclass="";
		  	}
   %>
			<tr align="center">
				<td class="<%=tbclass%>"><input type="radio"  name="radio1" onClick = "changradio()" value="<%=j%>"></td>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][1]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][2]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][3]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][4]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][5]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][6]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][7]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][8]%></TD>
				<td class="<%=tbclass%>"><%=s2266InitArr[j][9]%></TD>

				<input name="awardId<%=j%>" type="hidden" value="<%=s2266InitArr[j][0]%>">
				<input name="ressum<%=j%>" type="hidden" value="<%=s2266InitArr[j][3]%>">
				<input name="awardidname<%=j%>" type="hidden" value="<%=s2266InitArr[j][4]%>">
				<input name="flag<%=j%>" type="hidden" value="<%=s2266InitArr[j][5]%>">
				<input name="payAccept<%=j%>" type="hidden" value="<%=s2266InitArr[j][7]%>">
				<input name="printPackageCont<%=j%>" type="hidden" value="<%=s2266InitArr[j][11]%>">
			</tr>
	<%
		}
	%>
 		</TBODY>
	</TABLE>
  <table cellspacing="0">
		<tr id = "selectaward" style="display:none" >
			<td class="blue">��Ʒ����</td>
			<td colspan="3">
				<input type="text" name="awardNo" size="8" maxlength="8" v_must=1>
				<input type="text" name="awardInfo" size="30" v_must=1 v_name=��Ʒ����  onchange="changeResCode()">&nbsp;&nbsp;
				<font class="orange">*</font>
			  <input name=awardInfoQuery type=button class="b_text"  style="cursor:hand" onClick="if(checkIfSelect()) getAwardInfo()" value=��ѯ>
      </tr>
          <!-- �ֻ���ֵ�����뿨���� -->
     <tr  id="checkCardNo" style="display:none">
 		<td class="blue">�ֻ���ֵ������</td>
   		<td nowrap>
  	  	<input id="card_no"  type="text" name="card_no" size="40"  readonly >
  	  	<font color="orange">*</font>
      	<input  type="button" name="card_no_qry" class="b_text" value="��ѯ" onClick="checkCard()">
      	<input type="hidden" name="cardType">
		<input type="hidden" name="cardNum">
   		</td>
  	</tr>

	  <tr>
    	<td class="blue">��ע</td>
      <td colspan="3">
      	<input name="opNote" type="text" id="opNote" class="button" size="60" maxlength="60" onFocus="setOpNote();" readonly>
    	</td>
    </tr>
    <tr>
    	<td colspan="4" id="footer">
				<div align="center">
				<input name="confirm" class="b_foot" id="confirm" type="button"  value="ȷ��&��ӡ" onClick="printCommit()" >
					&nbsp;
				<input name="reset" class="b_foot" type="reset" value="���" >
					&nbsp;
				<input name="back" class="b_foot" onClick="window.location.href='f2266.jsp?activePhone=<%=strPhoneNo%>'" type="button" value="����">
					&nbsp;
				</div>
			</td>
   	</tr>
	</TABLE>
 <%@ include file="/npage/include/footer.jsp" %>
  <input type="hidden" name="loginname" value="">
  <input type="hidden" name="awardId" value="">
  <input type="hidden" name="flag" value="">
  <input type="hidden" name="awardidname" value="">
  <input type="hidden" name="payAccept" value="">
  <input type="hidden" name="titlename" value="">
  <input type="hidden" name="regioncode" value="<%=strRegionCode%>">
  <input type="hidden" name="opcode" value="<%=strOpCode%>">
  <input type="hidden" name="awardcode" value="<%=strAwardCode%>">
  <input type="hidden" name="awarddetailcode" value="<%=strAwardDetailCode%>">
  <input type="hidden" name="awardname" value="<%=strAwardName%>">
  <input type="hidden" name="ressum" value="">
  <input type="hidden" name="detailname" value="<%=strDetailName%>">
  <input type="hidden" name="printAccept" value="<%=printAccept%>">
  <input type="hidden" name="printPackageCont" value="">
  <input type="hidden" name="rescode_sum_new" value="1">
  <input type="hidden" name="cust_info">
  <input type="hidden" name="opr_info">
  <input type="hidden" name="note_info1">
  <input type="hidden" name="note_info2">
  <input type="hidden" name="note_info3">
  <input type="hidden" name="note_info4">
  <input type="hidden" name="printcount">
  <input type="hidden" name="smName">
  <input type="hidden" name="phone_no" value="<%=strPhoneNo%>">
</form>
</body>
</html>
