<%
/********************
 version v2.0
 ������: si-tech
 ģ�飺���Ŀ�ȡ��
 update zhaohaitao at 2008.12.25
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml">
	
<%@ include file="/npage/include/public_title_name.jsp" %>	
<%@ page contentType="text/html;charset=GBK"%>

<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>

<%
  response.setDateHeader("Expires", 0);

  String opCode = request.getParameter("opCode");
  String opName = request.getParameter("opName");
	    
  String loginNo = (String)session.getAttribute("workNo");
  String orgCode = (String)session.getAttribute("orgCode");
  String regionCode = (String)session.getAttribute("regCode");
%>
<%
  String retFlag="",retMsg="";//�����ж�ҳ��ս���ʱ����ȷ��
/****************���ƶ�����õ����롢���������� ����Ϣ s1251Init***********************/
  String[] paraAray1 = new String[4];
  String phoneNo = request.getParameter("srv_no");
  String passwordFromSer="";
  
  paraAray1[0] = phoneNo;	/* �ֻ�����   */ 
  paraAray1[1] = loginNo; 	/* ��������   */
  paraAray1[2] = orgCode;	/* ��������   */
  paraAray1[3] = "1254";	/* ��������   */
  for(int i=0; i<paraAray1.length; i++)
  {		
	if( paraAray1[i] == null )
	{
	  paraAray1[i] = "";
	}
  }
  //retList = impl.callFXService("s1251Init", paraAray1, "36","phone",phoneNo);
 %>
 	<wtc:service name="s1251Init" routerKey="phone" routerValue="<%=phoneNo%>" retcode="retCode1" retmsg="retMsg1" outnum="36" >
		<wtc:param value="<%=paraAray1[0]%>"/>
		<wtc:param value="<%=paraAray1[1]%>"/>
		<wtc:param value="<%=paraAray1[2]%>"/>
		<wtc:param value="<%=paraAray1[3]%>"/>
	</wtc:service>
	<wtc:array id="tempArr" scope="end"/>
 <%
  String  bp_name="",sm_code="",family_code="",rate_code="",op_type="2",bigCust_flag="",sm_name="",rate_name="",bigCust_name="",next_rate_code="",next_rate_name="",lack_fee="",prepay_fee="",bp_add="",cardId_type="", cardId_no="", cust_id="",cust_belong_code="",group_type_code="",group_type_name="",imain_stream="",next_main_stream="",hand_fee="",favorcode="",card_no="",print_note="";
  String errCode = retCode1;
  String errMsg = retMsg1;
  
   if(!errCode.equals("000000"))
  {
	 if(!retFlag.equals("1"))
	 {
	   retFlag = "1";
	   retMsg = "s1251Init��ѯ���������ϢΪ��!<br>" + "errCode: " + errCode + "<br>errMsg: " +  errMsg;
     }
  }else if(errCode.equals("000000"))
  {
	
	    bp_name = tempArr[0][3];//��������
	 
	    bp_add = tempArr[0][4];//�ͻ���ַ
	 
	    passwordFromSer = tempArr[0][2];//����
	  
	    sm_code = tempArr[0][11];//ҵ�����
	  
	    sm_name = tempArr[0][12];//ҵ���������
	
	    hand_fee = tempArr[0][13];//������
	 
	    favorcode = tempArr[0][14];//�Żݴ���
	 
	    rate_code = tempArr[0][5];//�ʷѴ���
	 
	    rate_name = tempArr[0][6];//�ʷ�����
	 
	    next_rate_code = tempArr[0][7];//�����ʷѴ���
	 
	    next_rate_name = tempArr[0][8];//�����ʷ�����
	 
	    bigCust_flag = tempArr[0][9];//��ͻ���־
	 
	    bigCust_name = tempArr[0][10];//��ͻ�����
	  
	    lack_fee = tempArr[0][15];//��Ƿ��
	 
	    prepay_fee = tempArr[0][16];//��Ԥ��
	 
	    cardId_type = tempArr[0][18];//֤������
	  
	    cardId_no = tempArr[0][19];//֤������
	 
	    cust_id = tempArr[0][20];//�ͻ�id
	 
	    cust_belong_code = tempArr[0][21];//�ͻ�����id
	 
	    group_type_code = tempArr[0][22];//���ſͻ�����
	 
	    group_type_name = tempArr[0][23];//���ſͻ���������
	 
	    imain_stream = tempArr[0][24];//��ǰ�ʷѿ�ͨ��ˮ
	 
	    next_main_stream = tempArr[0][25];//ԤԼ�ʷѿ�ͨ��ˮ
	
	    card_no = tempArr[0][26];//�м���֤
	 
	    print_note = tempArr[0][27];//��������
		System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"+card_no);
	  if((card_no==null) || (card_no.trim().equals(""))){
		  if(!retFlag.equals("1"))
	      {
	         retFlag = "1";
	         retMsg = "s1251Init���ֻ������Ѿ����밮�Ŀ�!<br>" + "errCode: " + errCode + "<br>errMsg: " +  errMsg;
          }
	  }
	}
	else{
		if(!retFlag.equals("1"))
	    {
	         retFlag = "1";
	         retMsg = "s1251Init��ѯ���������Ϣʧ��!<br>" + "errCode: " + errCode + "<br>errMsg: " +  errMsg;
        }
	}
//********************�õ�ӪҵԱȨ�ޣ��˶����룬�������Ż�Ȩ��*****************************// 
   //�Ż���Ϣ
 String[][] favInfo =  (String[][])session.getAttribute("favInfo");   //���ݸ�ʽΪString[0][0]---String[n][0]
  String handFee_Favourable = "readonly";        //a230  ������
  int infoLen = favInfo.length;
  String tempStr = "";
  for(int i=0;i<infoLen;i++)
  {
    tempStr = (favInfo[i][0]).trim();
    
	if(tempStr.compareTo(favorcode) == 0)
    {
      handFee_Favourable = "";
    }
  }
//******************�õ�����������***************************//
  //�ʷѴ��� 
  String sqlNewRateCode  = "";  
  sqlNewRateCode  = "select a.mode_code, a.mode_code||'--'||b.mode_name from sRegionNormal a, sBillModeCode b where a.region_code=b.region_code and a.mode_code=b.mode_code and a.region_code='" + orgCode.substring(0,2) + "'";
  String [] paraIn = new String[2];
  paraIn[0] = sqlNewRateCode;    
  paraIn[1] = "orgCode.substring(0,2)="+orgCode.substring(0,2);
  //ArrayList newRateCodeArr  = co.spubqry32("2",sqlNewRateCode );
%>
	<wtc:service name="sPubSelect"  retcode="retCode2" retmsg="retMsg2" outnum="2">
	<wtc:param value="<%=paraIn[0]%>"/>
	<wtc:param value="<%=paraIn[1]%>"/> 
	</wtc:service>
	<wtc:array id="newRateCodeStr" scope="end"/>


<head>
<title>���Ŀ�ȡ��</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
 
<script language="JavaScript">
<!--
  <%if(retFlag.equals("1")){%>
    rdShowMessageDialog("<%=retMsg%>");
    history.go(-1);
  <%}%>
  //����Ӧ��ȫ�ֵı���
  var SUCC_CODE	= "0";   		//�Լ�Ӧ�ó�����
  var ERROR_CODE  = "1";			//�Լ�Ӧ�ó�����
  var YE_SUCC_CODE = "0000";	 	//����Ӫҵϵͳ������޸�

  var oprType_Add = "a";
  var oprType_Upd = "u";
  var oprType_Del = "d";
  var oprType_Qry = "q";

  onload=function()
  {		
  }
  
  //***
  function frmCfm(){
 	frm.submit();
	return true;
  }
  //***//У��
  function check(){
	if(!checkElement(document.all.hand_fee)) return false;
 	with(document.frm){	
	  if(new_rate_code.value==""){
	    rdShowMessageDialog("��ѡ�����ʷѴ���!");
		new_rate_code.focus();
		return false;
	  }
	}
	return true;
  }

    //�����һ����ťʱ,Ϊ��һ��ҳ����֯����
  function setParaForNext(){
    var iOpCode = "1254";//iOpCode    
	var iAddStr = document.frm.card_no.value +"|" + ""+"|"+"<%=bp_name%>";//iAddStr
	var belong_code = "<%=cust_belong_code%>"; //belong_code 
    var i2 =  "<%=cust_id%>"  ; //�ͻ�ID
    var i16 = "<%=rate_code+"--"+rate_name%>";//�����ײʹ��루�ϣ�
    var ip = document.frm.new_rate_code.value;//�������ײʹ���(��)
    var i1 = document.frm.phoneNo.value;//  �ֻ�����
    var i4 = "<%=bp_name%>";//  �ͻ�����
    var i5 = "<%=bp_add%>";//  �ͻ���ַ
    var i6 = "<%=cardId_type%>";//   ֤������
    var i7 = "<%=cardId_no%>";//  ֤������
    var ipassword = ""; // ����
    var group_type = "<%=group_type_code+"--"+group_type_name%>";//���ſͻ����
    var ibig_cust = "<%=bigCust_flag+"--"+bigCust_name%>";// ��ͻ����
    var i18 =  "<%=next_rate_code + "--" + next_rate_name%>"; //�������ײͣ�
    var i19 =  "<%=hand_fee%>";//   ������
    var i20 =  "<%=hand_fee%>";  // ���������
    var i8 =   "<%=sm_name%>";  //   ҵ��Ʒ��
    var do_note = document.frm.opNote.value;// �û���ע��
    var favorcode =  "<%=favorcode%>";  // �������Ż�Ȩ��
    var maincash_no = "<%=rate_code%>";//�����ײʹ��루�ϣ�
    var imain_stream = "<%=imain_stream%>"; //��ǰ���ʷѿ�ͨ��ˮ
    var next_main_stream = "<%=next_main_stream%>";//ԤԼ���ʷѿ�ͨ��ˮ	

	/*var str = "iOpCode="+iOpCode+
		                              "&iAddStr="+iAddStr + 
				                      "&belong_code="+belong_code +
				                      "&i2="+i2 +
				                      "&i16="+i16 +
				                      "&ip="+ip +
				                      "&i1="+i1 +
				                      "&i4="+i4 +
				                      "&i5="+i5 +
				                      "&i6="+i6 +
				                      "&i7="+i7 +
				                      "&ipassword="+ipassword +
				                      "&group_type="+group_type +
				                      "&ibig_cust="+ibig_cust +
				                      "&i18="+i18 +
				                      "&i19="+i19 +
				                      "&i20="+i20 +
				                      "&i8="+i8 +
				                      "&do_note="+do_note +
				                      "&favorcode="+favorcode +
				                      "&maincash_no="+maincash_no +
				                      "&imain_stream="+imain_stream +
				                      "&next_main_stream="+next_main_stream;
	
	alert(str);*/
	document.frm.iOpCode.value = iOpCode;
	document.frm.iAddStr.value = iAddStr;
	document.frm.belong_code.value = belong_code;
	document.frm.i2.value = i2;
	document.frm.i16.value = i16;
	document.frm.ip.value = ip;
	document.frm.i1.value = i1;
	document.frm.i4.value = i4;
	document.frm.i5.value = i5;
	document.frm.i6.value = i6;
	document.frm.i7.value = i7;
	document.frm.ipassword.value = ipassword;
	document.frm.group_type.value = group_type;
	document.frm.ibig_cust.value = ibig_cust;
	document.frm.i18.value = i18;
	document.frm.i19.value = i19;
	document.frm.i20.value = i20;
	document.frm.i8.value = i8;
	document.frm.do_note.value = do_note;
	document.frm.favorcode.value = favorcode;
    document.frm.maincash_no.value = maincash_no;
	document.frm.imain_stream.value = imain_stream;
	document.frm.next_main_stream.value = next_main_stream;
	frm.action = "f1270_3.jsp";
  }

  function printCommit(subButton){
	controlButt(subButton);//��ʱ���ư�ť�Ŀ�����
	//У��
	if(!check()) return false;
	setOpNote();//Ϊ��ע��ֵ
	//Ϊ��һ��ҳ����֯���ݲ���
	setParaForNext();
    //�ύ����
    frmCfm();	
	return true;
  }
/******Ϊ��ע��ֵ********/
function setOpNote(){
	if(document.frm.opNote.value=="")
	{
	  document.frm.opNote.value = "���Ŀ�ȡ��;����:"+document.frm.phoneNo.value; 
	}
	return true;
}
function getmidpromt(){
	var newcode=codeChg(document.all.new_rate_code.value);
	getMidPrompt("10442",newcode,"ipTd");
}
//-->
</script>

</head>

<body>
<form name="frm" method="post">
<%@ include file="/npage/include/header.jsp" %>  
	
	<div class="title">
		<div id="title_zi"><%=opName%></div>
	</div>
  
  <table cellspacing="0">
	  <tr> 
        <td class="blue">��������</td>
        <td>ȡ��</td>
        <td class="blue">�ֻ�����</td>
        <td>
		  <input name="phoneNo" type="text" class="InputGrey" id="phoneNo" value="<%=phoneNo%>" readonly> 
		</td>  
      </tr>
      <tr> 
	    <td class="blue">ҵ������</td>
        <td>
		  <input name="sm_name" type="text" class="InputGrey" id="sm_name" value="<%=sm_code + "--" + sm_name%>" readonly>
		</td>
        <td class="blue">��ͻ���־</td>
        <td>
		<input name="bigCust_flag" type="text" class="InputGrey" id="bigCust_flag" value="<%=bigCust_flag+"--"+bigCust_name%>" readonly>
		</td>            
      </tr>
      <tr> 
        <td class="blue">��ǰ���ײ�</td>
        <td>
		  <input name="rate_name" type="text" class="InputGrey" id="rate_name" size="30" value="<%=rate_code+"--"+rate_name%>" readonly>
		</td>
		<td class="blue">�������ײ�</td>
        <td>
		  <input name="next_rate_name" type="text" class="InputGrey" id="next_rate_name" size="30"  value="<%=next_rate_code+"--"+next_rate_name%>" readonly>
		</td>             
      </tr>
	  <tr>
	    <td class="blue">��������</td>
        <td>
		  <input name="bp_name" type="text" class="InputGrey" id="bp_name" value="<%=bp_name%>" readonly>			  
		</td>
		<td class="blue">�м���֤</td>
        <td>
		  <input name="card_no" type="text" class="InputGrey" id="card_no"  maxlength="6" value="<%=card_no%>" readonly >
		</td>           
      </tr>
	  <tr> 
        <td class="blue">��Ƿ��</td>
        <td>
		  <input name="lack_fee" type="text" class="InputGrey" id="lack_fee" value="<%=lack_fee%>" readonly >
        </td>
        <td class="blue">��Ԥ��</td>
        <td>
		  <input name="prepay_fee" type="text" class="InputGrey" id="prepay_fee" value="<%=prepay_fee%>" readonly>
		</td>
      </tr>
	  <tr>
        <td class="blue">������</td>
        <td>
		   <input name="hand_fee" type="text" id="hand_fee" value="<%=hand_fee%>" v_type="money" v_must="1"  <%=handFee_Favourable%> >
		   <font color="orange">*</font>
		</td>
		<td class="blue">���ײʹ���</td>
        <td id="ipTd">
		  <select  name="new_rate_code" onChange="getmidpromt();">
		    <option value="">--��ѡ��--</option>
            <%for(int i = 0 ; i < newRateCodeStr.length ; i ++){%>
            <option value="<%=newRateCodeStr[i][0]%>"><%=newRateCodeStr[i][1]%></option>
            <%}%>
          </select>
		  <font color="orange">*</font>
        </td> 
      </tr>
      <tr> 
        <td class="blue">��ע</td>
        <td colspan="3">
         <input name="opNote" type="text" class="InputGrey" readOnly id="opNote" size="60" maxlength="60" onFocus="setOpNote();"> 
        </td>
      </tr>
	  <tr> 
        <td colspan="4"> <div align="center"> 
            &nbsp; 
			<input name="next" id="next" type="button" class="b_foot"   value="��һ��" onClick="printCommit(this)">
            &nbsp; 
            <input name="reset" type="reset" class="b_foot" value="���" >
            &nbsp; 
            <input name="back" onClick="history.go(-1);" type="button" class="b_foot" value="����">
            &nbsp; 
			</div>
		</td>
      </tr>
  </table>
  
  <input type="hidden" name="iOpCode">
  <input type="hidden" name="iAddStr">
  <input type="hidden" name="belong_code">
  <input type="hidden" name="i2">
  <input type="hidden" name="i16">
  <input type="hidden" name="ip">
  <input type="hidden" name="i1">
  <input type="hidden" name="i4">
  <input type="hidden" name="i5">
  <input type="hidden" name="i6">
  <input type="hidden" name="i7">
  <input type="hidden" name="ipassword">
  <input type="hidden" name="group_type">
  <input type="hidden" name="ibig_cust">
  <input type="hidden" name="i18">
  <input type="hidden" name="i19">
  <input type="hidden" name="i20">
  <input type="hidden" name="i8">
  <input type="hidden" name="do_note">
  <input type="hidden" name="favorcode">
  <input type="hidden" name="maincash_no">
  <input type="hidden" name="imain_stream">
  <input type="hidden" name="next_main_stream">
  <input type="hidden" name="smName" value="<%=sm_name%>">
  <input type="hidden" name="print_note" value="<%=print_note%>">
   <%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>
