<%
/********************
 version v2.0
������: si-tech
update: sunaj@2009-06-22
********************/

%>
 <!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<%
  response.setHeader("Pragma","No-cache");
  response.setHeader("Cache-Control","no-cache");
  response.setDateHeader("Expires", 0);
%>

<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="../../npage/bill/getMaxAccept.jsp" %>
<%@ include file="/npage/include/public_title_name.jsp" %>

<%
  String opCode = "8674";
  String opName = "��G3�ֻ�����ͨ�ŷ�����";

  String loginNo = (String)session.getAttribute("workNo");
  String loginName = (String)session.getAttribute("workName");
  String powerCode= (String)session.getAttribute("powerCode");
  String orgCode = (String)session.getAttribute("orgCode");
  String ip_Addr = (String)session.getAttribute("ipAddr");
  String regionCode = orgCode.substring(0,2);
  String loginNoPass = (String)session.getAttribute("password");
  String iOpCode=request.getParameter("opCode");
  String iOpName=request.getParameter("opName");
  
  /*��ȡϵͳʱ��*/
  java.util.Date sysdate = new java.util.Date();
  SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd HH:mm:ss");
  String begin_time = sf.format(sysdate);

%>
<%
  String retFlag="",retMsg="";
  String[] paraAray1 = new String[4];
  String phoneNo = request.getParameter("srv_no");
  String opcode = request.getParameter("opCode");
  String passwordFromSer="";
  int sale_num = 0;

 /* ��������� �����룬������Ϣ���ͻ��������ͻ���ַ��֤�����ͣ�֤�����룬ҵ��Ʒ�ƣ�
 			�����أ���ǰ״̬��VIP���𣬵�ǰ����,����Ԥ��
 */

  String  bp_name="",bp_add="",cardId_type="",cardId_no="",sm_code="",region_name="",run_name="",vip="",posint="",prepay_fee="";
  String[][] tempArr= new String[][]{};
  String[][] result2  = null;
%>
<wtc:service  name="s1145Qry" routerKey="phone" routerValue="<%=phoneNo%>" outnum="21"  retcode="errCode" retmsg="errMsg">
		<wtc:param value=" "/>
		<wtc:param value="01"/>
		<wtc:param value="<%=opcode%>"/>
		<wtc:param value="<%=loginNo%>"/>
		<wtc:param value="<%=loginNoPass%>"/>
		<wtc:param value="<%=phoneNo%>"/>
		<wtc:param value=" "/>
	<wtc:param  value="21"/>
</wtc:service>
<wtc:array id="retList"  start="0" length="14" scope="end"/>
<wtc:array id="retList2" start="14" length="7" scope="end"/>
<%
  System.out.println("retList"+retList);
  if(retList == null)
  {
	if(!retFlag.equals("1"))
	{
	   System.out.println("retFlag="+retFlag);
	   retFlag = "1";
	   retMsg = "s1141Qry��ѯ���������ϢΪ��!<br>errCode: " + errCode + "<br>errMsg+" + errMsg;
    }
  }
  else
  {
  	System.out.println("errCode="+errCode);
  	System.out.println("errMsg="+errMsg);
	if(!errCode.equals("000000")&&!errCode.equals("0")){%>
		<script language="JavaScript">
			rdShowMessageDialog("������룺<%=errCode%>��������Ϣ��<%=errMsg%>",0);
			history.go(-1);
		</script>
	<%}
	else
	{
	  bp_name = retList[0][2];
	  bp_add = retList[0][3];
	  cardId_type = retList[0][4];
	  cardId_no = retList[0][5];
	  sm_code = retList[0][6];
	  region_name = retList[0][7];
	  run_name = retList[0][8];
	  vip = retList[0][9];
	  posint = retList[0][10];
	  prepay_fee = retList[0][11];
	  passwordFromSer = retList[0][13];

	  result2 = retList2;
	}
  }
%>

<%
//******************�õ�����������**************************//
String printAccept="";
printAccept = getMaxAccept();
System.out.println(printAccept);

  //�ֻ�Ʒ��
  String sqlAgentCode = " select  unique a.brand_code,trim(b.brand_name) from dphonesalecode a,schnresbrand b where a.region_code='" + regionCode + "' and a.sale_type='25' and a.brand_code=b.brand_code and valid_flag='Y' and is_valid='1'";
  System.out.println("sqlAgentCode====="+sqlAgentCode);

  //�ֻ�����
  String sqlPhoneType = "select unique a.type_code,trim(b.res_name), b.brand_code from dphonesalecode a,schnrescode_chnterm b where a.region_code='" + regionCode + "' and  a.type_code=b.res_code and a.brand_code=b.brand_code and valid_flag='Y' and a.sale_type='25' and is_valid='1'";
  System.out.println("sqlPhoneType====="+sqlPhoneType);

  //Ӫ������
  String sqlsaleType = "select unique a.sale_code,trim(a.sale_name), a.brand_code,a.type_code from dphonesalecode a where a.region_code='" + regionCode + "' and a.sale_type='25' and valid_flag='Y'";
  System.out.println("sqlsaleType====="+sqlsaleType);

   //Ӫ����ϸ
  String sqlsaledet = "select sale_price-prepay_gift-prepay_limit,prepay_gift,consume_term,prepay_limit,active_term,market_price,sale_price,sale_code from dphoneSaleCode  where region_code='" + regionCode + "' and sale_type='25' and valid_flag='Y'";
  System.out.println("sqlsaledet====="+sqlsaledet);

%>
<wtc:pubselect name="sPubSelect" outnum="2" retmsg="msg1" retcode="code1" routerKey="region" routerValue="<%=regionCode%>">
	<wtc:sql><%=sqlAgentCode%></wtc:sql>
</wtc:pubselect>
<wtc:array id="agentCodeStr" scope="end"/>

<wtc:pubselect name="sPubSelect" outnum="3" retmsg="msg2" retcode="code2" routerKey="region" routerValue="<%=regionCode%>">
	<wtc:sql><%=sqlPhoneType%></wtc:sql>
</wtc:pubselect>
<wtc:array id="phoneTypeStr" scope="end"/>

<wtc:pubselect name="sPubSelect" outnum="4" retmsg="msg2" retcode="code2" routerKey="region" routerValue="<%=regionCode%>">
	<wtc:sql><%=sqlsaleType%></wtc:sql>
</wtc:pubselect>
<wtc:array id="saleTypeStr" scope="end"/>

<wtc:pubselect name="sPubSelect" outnum="8" retmsg="msg2" retcode="code2" routerKey="region" routerValue="<%=regionCode%>">
	<wtc:sql><%=sqlsaledet%></wtc:sql>
</wtc:pubselect>
<wtc:array id="saledetStr" scope="end"/>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=opName%></title>

<META content="no-cache" http-equiv="Pragma">
<META content="no-cache" http-equiv="Cache-Control">
<META content="0" 	     http-equiv="Expires" >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">

 <script language=javascript>

 function doProcess(packet){

 	var retType = packet.data.findValueByName("retType");
    var retCode = packet.data.findValueByName("retCode");
   	var retMessage = packet.data.findValueByName("retMessage");
   	if(retType == "checkAward"){
    		window.status = "";
    		if(retCode!=0){
    			rdShowMessageDialog(retMessage);
    			document.all.need_award.checked = false;
    			document.all.award_flag.value = 0;
    			return;
    		}
    		document.all.award_flag.value = 1;
    	}else if(retType == "0"){
			//alert(retResult);
			var retResult = packet.data.findValueByName("retResult");
			if(retResult == "000000"){
					rdShowMessageDialog("IMEI��У��ɹ�1��",2);
					document.frm.IMEINo.readOnly=true;
					document.frm.confirm.disabled=false;
					return ;

			}else if(retResult == "000001"){
					rdShowMessageDialog("IMEI��У��ɹ�2��",2);
					document.frm.confirm.disabled=false;
					document.frm.IMEINo.readOnly=true;
					return ;

			}else if(retResult == "000003"){
					rdShowMessageDialog("IMEI�Ų���ӪҵԱ����Ӫҵ����IMEI����ҵ��������Ͳ�����",0);
					document.frm.confirm.disabled=true;
					return ;
			}else{
					rdShowMessageDialog("IMEI�Ų����ڻ����Ѿ�ʹ�ã�",0);
					document.frm.confirm.disabled=true;
					return false;
			}
		}
 }
 //***IMEI ����У��
 function checkimeino()
{
	 if (document.frm.IMEINo.value.length == 0) {
      rdShowMessageDialog("IMEI���벻��Ϊ�գ����������� !!",0);
      document.frm.IMEINo.focus();
      document.frm.confirm.disabled = true;
	  return false;
     }
	//alert(document.all.agent_code.options[document.all.agent_code.selectedIndex].value);
	//alert(document.all.phone_type.options[document.all.phone_type.selectedIndex].value);
	//alert(document.all.IMEINo.value);
	var myPacket = new AJAXPacket("queryimei.jsp","����У��IMEI��Ϣ�����Ժ�......");
	myPacket.data.add("imei_no",(document.all.IMEINo.value).trim());
	myPacket.data.add("brand_code",(document.all.agent_code.options[document.all.agent_code.selectedIndex].value).trim());
	myPacket.data.add("style_code",(document.all.phone_type.options[document.all.phone_type.selectedIndex].value).trim());
	myPacket.data.add("opcode",(document.all.opcode.value).trim());
	myPacket.data.add("retType","0");

	core.ajax.sendPacket(myPacket);
	myPacket = null;
}

function viewConfirm()
{
	if(document.frm.IMEINo.value=="")
	{
		document.frm.confirm.disabled=true;
	}
}

 </script>
<script language="JavaScript">

<!--
  //����Ӧ��ȫ�ֵı���
  var SUCC_CODE	= "0";   		    //�Լ�Ӧ�ó�����
  var ERROR_CODE  = "1";			//�Լ�Ӧ�ó�����
  var YE_SUCC_CODE = "0000";		//����Ӫҵϵͳ������޸�

  var oprType_Add = "a";
  var oprType_Upd = "u";
  var oprType_Del = "d";
  var oprType_Qry = "q";

  var arrPhoneType = new Array();//G3�ʼǱ��ͺŴ���
  var arrPhoneName = new Array();//G3�ʼǱ��ͺ�����
  var arrAgentCode = new Array();//�����̴���
  var selectStatus = 0;

  var arrsalecode  = new Array();
  var arrsaleName  = new Array();
  var arrsalebarnd = new Array();
  var arrsaletype  = new Array();

  var arrdetcard   = new Array();     /*������*/
  var arrdetprepay = new Array();     /*����*/
  var arrdetnet    = new Array();     /*����������*/
  var arrdetconsume= new Array();     /*������������*/
  var arrdetactive = new Array();     /*��������������*/
  var arrdetmarket = new Array();     /*�г���*/
  var arrdetcash   = new Array();     /*Ӧ�����*/
  var arrdetsalecode=new Array();     /*Ӫ������*/


<%
  for(int i=0;i<phoneTypeStr.length;i++)
  {

	out.println("arrPhoneType["+i+"]='"+phoneTypeStr[i][0]+"';\n");
	out.println("arrPhoneName["+i+"]='"+phoneTypeStr[i][1]+"';\n");
	out.println("arrAgentCode["+i+"]='"+phoneTypeStr[i][2]+"';\n");
  }
  for(int l=0;l<saleTypeStr.length;l++)
  {
	out.println("arrsalecode["+l+"]='"+saleTypeStr[l][0]+"';\n");
	out.println("arrsaleName["+l+"]='"+saleTypeStr[l][1]+"';\n");
	out.println("arrsalebarnd["+l+"]='"+saleTypeStr[l][2]+"';\n");
	out.println("arrsaletype["+l+"]='"+saleTypeStr[l][3]+"';\n");
  }
   for(int l=0;l<saledetStr.length;l++)
  {
	out.println("arrdetcard["+l+"]='"+saledetStr[l][0]+"';\n");
	out.println("arrdetprepay["+l+"]='"+saledetStr[l][1]+"';\n");
	out.println("arrdetconsume["+l+"]='"+saledetStr[l][2]+"';\n");
	out.println("arrdetnet["+l+"]='"+saledetStr[l][3]+"';\n");
	out.println("arrdetactive["+l+"]='"+saledetStr[l][4]+"';\n");
	out.println("arrdetmarket["+l+"]='"+saledetStr[l][5]+"';\n");
	out.println("arrdetcash["+l+"]='"+saledetStr[l][6]+"';\n");
	out.println("arrdetsalecode["+l+"]='"+saledetStr[l][7]+"';\n");
   }
%>

  //***
  function frmCfm(){
	 	 frm.submit();
		 return true;
  }
 //***
 function printCommit()

 {
 	 	getAfterPrompt();
  //У��
  //if(!check(frm)) return false;

  with(document.frm){
    if(cust_name.value==""){
	  rdShowMessageDialog("����������!",1);
      cust_name.focus();
	  return false;
	}
	if(agent_code.value==""){
	  rdShowMessageDialog("�������ֻ�Ʒ��!",1);
      agent_code.focus();
	  return false;
	}
	if(phone_type.value==""){
	  rdShowMessageDialog("�������ֻ��ͺ�!",1);
      phone_type.focus();
	  return false;
	}
	if(sale_code.value==""){
	  rdShowMessageDialog("������Ӫ������!",1);
      sale_code.focus();
	  return false;
	}
	if (IMEINo.value.length == 0) {
      rdShowMessageDialog("IMEI���벻��Ϊ�գ����������� !!",1);
      IMEINo.focus();
      confirm.disabled = true;
	  return false;
     }
     if(opNote.value=="")
     {
			opNote.value=phone_no.value+"������G3�ֻ�����ͨ�ŷ�ҵ��";
		}
	document.frm.confirm.disabled=true;
	phone_typename.value=document.all.agent_code.options[document.all.agent_code.selectedIndex].text+document.all.phone_type.options[document.all.phone_type.selectedIndex].text;

	//�ж��Ƿ�ѡ����Ҫ�޸�imei��
  }

 //��ӡ�������ύ����
 var ret = showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes");
  if(typeof(ret)!="undefined")
  {
    if((ret=="confirm"))
    {
      if(rdShowConfirmDialog('ȷ�ϵ��������')==1)
      {
	    frmCfm();
      }
	}
	if(ret=="continueSub")
	{
      if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
      {
	    document.frm.confirm.disabled=true;
	    frmCfm();
      }
	}
  }
  else
  {
     if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
     {
	   frmCfm();
     }
  }
  return true;
}
function showPrtDlg(printType,DlgMessage,submitCfm)
{  //��ʾ��ӡ�Ի���
	var h=210;
	var w=400;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;
	var pType="subprint";
	var billType="1";
	var sysAccept = document.all.login_accept.value;
	var printStr = printInfo(printType);

	var mode_code=null;
	var fav_code=null;
	var area_code=null

   var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
   //var path = "<%=request.getContextPath()%>/npage/innet/hljGdPrintNew.jsp?DlgMsg=" + DlgMessage;
   var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc.jsp?DlgMsg="+DlgMessage;
   var path = path  + "&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+sysAccept+"&phoneNo=<%=phoneNo%>&submitCfm=" + submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
   //alert(path);
   var ret=window.showModalDialog(path,printStr,prop);
   return ret;
}

function printInfo(printType)
{

     var cust_info="";
	 var opr_info="";
	 var note_info1="";
	 var note_info2="";
	 var note_info3="";
	 var note_info4="";
	 var retInfo = "";

	cust_info+= "�ֻ����룺     "+document.all.phone_no.value+"|";
	cust_info+= "�ͻ�������     "+document.all.cust_name.value+"|";
	cust_info+= "֤�����룺     "+document.all.cardId_no.value+"|";
	cust_info+= "�ͻ���ַ��     "+document.all.cust_addr.value+"|";


	opr_info+="ҵ�����ͣ���G3�ֻ�����ͨ�ŷ�"+"|";
	opr_info+="������ˮ��"+document.all.login_accept.value+"|";
	opr_info+="�ֻ�Ʒ���ͺţ�"+document.all.agent_code.options[document.all.agent_code.selectedIndex].text+document.all.phone_type.options[document.all.phone_type.selectedIndex].text
  				+"      IMEI�룺"+document.frm.IMEINo.value+"|";

    var jkinfo="";
   jkinfo+="����"+document.all.sum_money.value+"Ԫ�����ͻ���"+document.all.pay_money.value+"Ԫ����"+document.all.Consume_Term.value+"�������ͣ�"+document.all.Consume_Term.value+"����������ϣ�|";
   jkinfo+="����������"+document.all.net_money.value+"Ԫ����"+document.all.Active_Term.value+"�������ͣ�"+document.all.Active_Term.value+"�����������|";
   jkinfo+="ҵ��ִ��ʱ��: "+"<%=begin_time%>";


	opr_info+=jkinfo+"|";
	//retInfo+=jkinfo+"|";
	retInfo+=" "+"|";
	retInfo+=" "+"|";
	retInfo+=" "+"|";
	retInfo+=" "+"|";
	retInfo+=" "+"|";

	retInfo+=" "+"|";


	note_info1 =retInfo;
	note_info1+="      ��ע��"+document.all.opNote.value+"|";

	//if(document.all.type_code.value=="20000155"){
	//   note_info3+="����ǰȡ�������ò��˲�����"+"|";
	//}else{
	//	retInfo+=" "+"|";
	//	note_info3+=" "+"|";
	//}
	//retInfo+="�ֻ��ն˻��Զ��������϶�Ķ��Ž��в�֣���ͬ�ͺ��ֻ��ն˲��ԭ��ͬ���ҹ�˾�����ֻ��Զ�"+"|"+"��ֵ������շѡ�"+"|";

	//note_info3+="�ֻ��ն˻��Զ��������϶�Ķ��Ž��в�֣���ͬ�ͺ��ֻ��ն˲��ԭ��ͬ���ҹ�˾�����ֻ��Զ�"+"|"+"��ֵ������շѡ�"+"|";

	if(document.all.award_flag.value == "1")
	{
		//retInfo+= "�Ѳ���������Ʒ�"+"|";
		note_info4+= "�Ѳ���������Ʒ�"+"|";
	}
	else
	{
		//retInfo+= " "+"|";
		note_info4+= " "+"|";
	}
		//#23->#
		retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
		retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
    return retInfo;
}
//-->
</script>

<script language="JavaScript">
<!--
/****************����agent_code��̬����phone_type������************************/
 function selectChange(control, controlToPopulate, ItemArray, GroupArray)
 {


	var myEle ;
	var x ;
   // Empty the second drop down box of any choices
	for (var q=controlToPopulate.options.length;q>=0;q--) controlToPopulate.options[q]=null;
   // ADD Default Choice - in case there are no values

	myEle = document.createElement("option") ;
	myEle.value = "";
	myEle.text ="--��ѡ��--";
	controlToPopulate.add(myEle) ;
	for ( x = 0 ; x < ItemArray.length  ; x++ )
	{
      if ( GroupArray[x] == control.value )
      {
        myEle = document.createElement("option") ;
        myEle.value = arrPhoneType[x];
        myEle.text = ItemArray[x] ;
        controlToPopulate.add(myEle) ;
        document.all.type_code.value=arrPhoneType[x];
      }
	}
	document.all.need_award.checked = false;
	document.all.award_flag.value = 0;
 }
 function typechange(){

	var myEle1 ;
   	var x1 ;
   	for (var q1=document.all.sale_code.options.length;q1>=0;q1--) document.all.sale_code.options[q1]=null;
   	myEle1 = document.createElement("option") ;
	myEle1.value = "";
	myEle1.text ="--��ѡ��--";
	document.all.sale_code.add(myEle1) ;

   	for ( x1 = 0 ; x1 < arrsaletype.length  ; x1++ )
   	{
      	if ( arrsaletype[x1] == document.all.phone_type.value  && arrsalebarnd[x1] == document.all.agent_code.value)
      	{
        	myEle1 = document.createElement("option") ;
        	myEle1.value = arrsalecode[x1];
        	myEle1.text = arrsaleName[x1];
        	document.all.sale_code.add(myEle1) ;
      	}
   	}
   	document.all.need_award.checked = false;
    document.all.award_flag.value = 0;
 }
  function salechage(){
	var x3;
	for ( x3 = 0 ; x3 < arrdetsalecode.length  ; x3++ )
   	{
      	if ( arrdetsalecode[x3] == document.all.sale_code.value )
      	{
      		document.all.price.value=arrdetcard[x3];
        	document.all.pay_money.value=arrdetprepay[x3];
        	document.all.Consume_Term.value=arrdetconsume[x3];
        	document.all.net_money.value=arrdetnet[x3];
        	document.all.Active_Term.value=arrdetactive[x3];
        	document.all.Market_Price.value=arrdetmarket[x3];
        	document.all.sum_money.value=arrdetcash[x3];
      	}
 }
    document.all.opNote.value = "�û�"+document.all.phoneNo.value+"������G3�ֻ�����ͨ�ŷ�";
}

function checkAward()
{
	if(document.all.phone_type.value == "")
	{
		rdShowMessageDialog("����ѡ���ֻ��ͺ�",1);
		document.all.need_award.checked = false;
		document.all.award_flag.value = 0;
		return;
	}
	if(document.all.need_award.checked )
	{
		var packet = new AJAXPacket("phone_getAwardRpc.jsp","���ڻ�ý�Ʒ��ϸ�����Ժ�......");
		packet.data.add("retType","checkAward");
		packet.data.add("iOpCode","8674");
		packet.data.add("style_code",document.all.phone_type.value );

		core.ajax.sendPacket(packet);
		packet =null;
	}
 	 //document.all.award_flag.value = 0;
 }
/*
 function getSum(){
   with(document.frm){
	   if(!(num.value=="") && !(price.value=="")){
         if(!checkElement("num")) return false;
	     if(!checkElement("price")) return false;
	     sum_money.value = num.value * price.value;
	   }
   }
 }
 */
//-->
</script>
</head>
<body>
<form name="frm" method="post" action="f8674_2.jsp" onKeyUp="chgFocus(frm)">
<%@ include file="/npage/include/header.jsp" %>
	<div class="title">
		<div id="title_zi">�û���Ϣ</div>
	</div>
  <table  cellspacing="0">
	<tr>
            <td class="blue">��������</td>
            <td>��G3�ֻ�����ͨ�ŷ�����</td>
            <td class="blue">�ֻ�����</td>
	    	<td>
						<input class="InputGrey" type="text" v_must="1" v_type="mobphone" v_must=1 name="phoneNo" value="<%=phoneNo%>" id="phoneNo" onBlur="if(this.value!=''){if(checkElement(document.all.phoneNo)==false){return false;}}" maxlength=11 index="3" readonly >
			</td>
	</tr>
	<tr >
            <td class="blue">�ͻ�����</td>
            <td>
						<input name="cust_name" value="<%=bp_name%>" type="text" Class="InputGrey" v_must=1 readonly id="cust_name" maxlength="20" v_name="����">
            </td>
            <td class="blue">�ͻ���ַ</td>
            <td>
						<input name="cust_addr" value="<%=bp_add%>" type="text" Class="InputGrey" v_must=1 readonly id="cust_addr" maxlength="50" size="50" >
            </td>
	</tr>
	<tr>
            	<td class="blue">֤������</td>
            <td>
						<input name="cardId_type" value="<%=cardId_type%>" type="text" Class="InputGrey" v_must=1 readonly id="cardId_type" maxlength="20" >
            </td>
            <td class="blue">֤������</td>
            <td>
						<input name="cardId_no" value="<%=cardId_no%>" type="text" Class="InputGrey" v_must=1 readonly id="cardId_no" maxlength="20" >
            </td>
	</tr>
	<tr>
            <td class="blue">ҵ��Ʒ��</td>
            <td>
						<input name="sm_code" value="<%=sm_code%>" type="text" Class="InputGrey" v_must=1 readonly id="sm_code" maxlength="20" >
            </td>
            <td class="blue">����״̬</td>
            <td>
						<input name="run_type" value="<%=run_name%>" type="text" Class="InputGrey" v_must=1 readonly id="run_type" maxlength="20" >
            </td>
	</tr>
	<tr>
            <td class="blue">VIP����</td>
            <td>
						<input name="vip" value="<%=vip%>" type="text" Class="InputGrey" v_must=1 readonly id="vip" maxlength="20" >
            </td>
            <td class="blue">����Ԥ��</td>
            <td>
						<input name="prepay_fee" value="<%=prepay_fee%>" type="text" Class="InputGrey" v_must=1 readonly id="prepay_fee" maxlength="20" >
            </td>
	</tr>
    </table>
    </div>
    <div id="Operation_Table">
	 <div class="title">
		<div id="title_zi">ҵ�����</div>
	</div>
	<table cellspacing="0">
	<tr>
            <td class="blue">�ֻ�Ʒ��</td>
            <td>
			<SELECT id="agent_code" name="agent_code" v_must=1  onchange="selectChange(this, phone_type, arrPhoneName, arrAgentCode);" v_name="�ֻ�������">
						    <option value ="">--��ѡ��--</option>
			                <%for(int i = 0 ; i < agentCodeStr.length ; i ++){%>
			                <option value="<%=agentCodeStr[i][0]%>"><%=agentCodeStr[i][1]%></option>
			                <%}%>
			</select>
			                <font class="orange">*</font>
						    </td>
			<td class="blue">�ֻ��ͺ�</td>
            <td>
			<select size=1 name="phone_type" id="phone_type" v_must=1 v_name="�ֻ��ͺ�" onchange="typechange()">
		    <input type="hidden" name="type_code" id="type_code" >
			</select>
			  			   <font class="orange">*</font>
						  </td>
	</tr>
	<tr>
            <td class="blue">Ӫ������</td>
            <td >
						  <select size=1 name="sale_code" id="sale_code" v_must=1 v_name="Ӫ������" onchange="salechage()">
			        </select>
			 				<font class="orange">*</font>
						</td>
						<td class="blue" colspan="2">�Ƿ��������
								<input type="checkbox" name="need_award" onclick="checkAward()" />
								<input type="hidden" name="award_flag" value="0" />
						</td>
	</tr>
	<tr>
            <td class="blue">���ֻ���</td>
            <td >
						  <input name="price" type="text"  id="price" v_type="money" v_must=1   readonly v_name="�ֻ��۸�" >
						  <font class="orange">*</font>
						</td>
            <td class="blue">���ͻ���</td>
            <td>
						  <input name="pay_money" type="text"   id="pay_money" v_type="0_9" v_must=1   v_name="���ͻ���" readonly>
						  <font class="orange">*</font>
						</td>
	</tr>
	<tr>
		<td class="blue">������������</td>
            <td>
						  <input name="Consume_Term" type="text"   id="Consume_Term" v_type="0_9" v_must=1   v_name="������������" readonly>
						  <font class="orange">*</font>
						</td>
            <td class="blue">������������</td>
            <td >
						  <input name="net_money" type="text"  id="net_money" v_type="money" v_must=1   readonly v_name="������������" >
						  <font class="orange">*</font>
						</td>
	</tr>
    <tr>
          		<td class="blue">������������������</td>
            <td>
						  <input name="Active_Term" type="text"   id="Active_Term" v_type="0_9" v_must=1   v_name="��������������" readonly>
						  <font class="orange">*</font>
						</td>
            <td class="blue">Ӧ�����</td>
            <td >
						  <input name="sum_money" type="text"  id="sum_money" readonly>
						  <font class="orange">*</font>
						</td>
	</tr>
	<tr>
				<TD  class="blue" nowrap>IMEI��</TD>
          <TD >
				<input name="IMEINo"  type="text" v_type="0_9" v_name="IMEI��"  maxlength=15 value="" onblur="viewConfirm()">
				<input name="checkimei" class="b_text" type="button" value="У��" onclick="checkimeino()">
               <font class="orange">*</font>
          </TD>
					<TD>&nbsp;
					</td>
					<td>&nbsp;
						</td>
	</tr>
	<TR id=showHideTr >
					<TD  class="blue" nowrap>����ʱ��</TD>
					<TD >
						<input name="payTime"  type="text" v_name="����ʱ��"  value="<%=new java.text.SimpleDateFormat("yyyyMMdd ", Locale.getDefault()).format(new java.util.Date())%>">
						(������)<font class="orange">*</font>
					</TD>
					<TD class="blue" nowrap>����ʱ��</TD>
					<TD >
						<input name="repairLimit" v_type="date.month"  size="10" type="text" v_name="����ʱ��" value="12" onblur="viewConfirm()">
						(����)<font class="orange">*</font>
					</TD>
	</TR>
	<tr>
            <td  class="blue">�û���ע</td>
            <td colspan="3">
             <input name="opNote" type="text"  id="opNote" size="60" maxlength="60" value="��G3�ֻ�����ͨ�ŷ�" >
            </td>
	</tr>
	</table>
    </div>
	<div id="Operation_Table">
	<table cellspacing="0">
	<tr>
            <td colspan="6" align="center" id="footer">
                <input name="confirm" type="button" class="b_foot" index="2" value="ȷ��&��ӡ" onClick="printCommit()" disabled >
                <input name="reset" type="reset" class="b_foot" value="���" >
                <input name="back" onClick="history.go(-1);" type="button" class="b_foot" value="����">
            </td>
	</tr>
	</table>
	</div>
    <input type="hidden" name="phone_no" value="<%=phoneNo%>">
    <input type="hidden" name="work_no" value="<%=loginNo%>">
    <input type="hidden" name="login_accept" value="<%=printAccept%>">
    <input type="hidden" name="card_dz" >
    <input type="hidden" name="used_point" value="0" >
    <input type="hidden" name="point_money" value="0" >
    <input type="hidden" name="opcode" value="<%=opCode%>">
    <input type="hidden" name="sale_type" value="25" >
    <input type="hidden" name="phone_typename" >
    <input type="hidden" name="card_type" >
    <input type="hidden" name="cardy" >
    <input type="hidden" name="opName" value="<%=opName%>" >
	  <input type="hidden" name="opCode" value="<%=opCode%>" >
	
	<input type="hidden" name="orgCode" value="<%=orgCode%>">
	<input type="hidden" name="Market_Price" id="Market_Price">

	<%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>

