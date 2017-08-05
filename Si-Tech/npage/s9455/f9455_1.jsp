<%
/********************
 * version v2.0
 * ������: si-tech
 * author: daixy
 * date  : 20100226
 ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="../../npage/bill/getMaxAccept.jsp" %>
<%@ include file="../../npage/public/fPubPrintNote.jsp" %>
<%@ page import="java.util.*"%>

<%
    String opCode = (String)request.getParameter("opCode");
    String opName = (String)request.getParameter("opName");
	String iPhoneNo =(String)request.getParameter("iPhoneNo");
	String iUserPwd = "";
	String iChnSource = "";
    String iLoginNo = (String)session.getAttribute("workNo");
    String iLoginName =(String)session.getAttribute("workName");
    String iLoginPwd = (String)session.getAttribute("password");
    String regionCode = (String)session.getAttribute("regCode");
    String offerId = "";
    String iLoginAccept = getMaxAccept();
    String vLevelId = "";
    String vOfferName = "";

    String [] inParas = new String[7];
    inParas[0] = iLoginAccept;
    inParas[1] = iChnSource;
    inParas[2] = opCode;
    inParas[3] = iLoginNo;
    inParas[4] = iLoginPwd;
	inParas[5] = iPhoneNo;
    inParas[6] = iUserPwd;
%>
<wtc:service name="s9455Init" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode1" retmsg="retMsg1" outnum="10">
	<wtc:param value="<%=inParas[0]%>" />
	<wtc:param value="<%=inParas[1]%>" />
	<wtc:param value="<%=inParas[2]%>" />
	<wtc:param value="<%=inParas[3]%>" />
	<wtc:param value="<%=inParas[4]%>" />
	<wtc:param value="<%=inParas[5]%>" />
    <wtc:param value="<%=inParas[6]%>" />
</wtc:service>
<wtc:array id="result1"  scope="end"/>
<%
	String vCustName = "";
	String vCustAddress = "";
	String vIdName = "";
	String vIdIccid = "";
	String vSmName = "";
	String vRegionName = "";
	String vRunName = "";
	String vCustStatus = "";
	String vOpNote = "";

	if (result1.length>0 && retCode1.equals("000000"))
	{
		vCustName = result1[0][2];
		vCustAddress = result1[0][3];
		vIdName = result1[0][4];
		vIdIccid = result1[0][5];
		vSmName = result1[0][6];
		vRegionName = result1[0][7];
		vRunName = result1[0][8];
		vCustStatus = result1[0][9];
	}else{
%>
	<script language="JavaScript">
		rdShowMessageDialog("��ѯ����!<br>������룺'<%=retCode1%>'��������Ϣ��'<%=retMsg1%>'��",0);
		history.go(-1);
	</script>
<%
	}
%>

<%
		String levelsql = "select level_id,offer_name,busi_type from sBlackBerrylevel order by level_id";
%>
 		<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode2" retmsg="retMsg2" outnum="3">
		<wtc:sql><%=levelsql%></wtc:sql>
		</wtc:pubselect>
		<wtc:array id="result2" scope="end" />
<%
		if(retCode2.equals("0")||retCode2.equals("000000"))
		{
			System.out.println("result2.length="+result2.length);
		}else{
 			System.out.println("retCode2="+retCode2+"retMsg2"+retMsg2);
%>
		<script language=javascript>
		rdShowMessageDialog("��ѯBlackBerry�����ʷѳ���<br>������룺"+retCode2+"������Ϣ��"+retMsg2);
		</script>
<%
 		}
%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">

<title>BlackBerry����ҵ��ע��</title>

<script language="JavaScript">
var myArrayId = new Array();
var myArrayName = new Array();
var myBusiType = new Array();

<%
	for(int i=0;i<result2.length;i++)
  	{
		out.println("myArrayId["+i+"]='"+result2[i][0]+"';\n");
		out.println("myArrayName["+i+"]='"+result2[i][1]+"';\n");
		out.println("myBusiType["+i+"]='"+result2[i][2]+"';\n");
  	}
%>

onload=function()
{
	rdShowMessageDialog("��ȡ��139����ҵ�񣬽�ͬʱȡ����ݮ��������ҵ��");
}

function printInfo(printType)
{
  if(document.frm.opNote.value==""){
  document.frm.opNote.value="����Ա"+"<%=iLoginNo%>"+"���û�"+document.frm.phoneNo.value+"����"+"<%=opName%>"
  }
  var retInfo = "";
  var cust_info="";
  var opr_info="";
  var note_info1="";
  var note_info2="";
  var note_info3="";
  var note_info4="";

  cust_info+="�ͻ�������" +document.frm.custName.value+"|";
  cust_info+="�ֻ����룺"+document.frm.phoneNo.value+"|";


  opr_info+="����ʱ�䣺"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
  opr_info+="�����˹��ţ�" +"<%=iLoginNo%>"+"  ����������: "+"<%=iLoginName%>" +"|";
  opr_info+="�������ݣ�" +"<%=opName%>"+"|";
  if(document.frm.iLevelId.value=="1")
  {
  	opr_info+="��ݮ�������䣺98Ԫ/�¡����30M����GPRS�����ѡ������ײ��������Ĺ�����������0.29Ԫ/M�Ʒѡ�"+"|";
  }
  if(document.frm.iLevelId.value=="2")
  {
  	opr_info+="��ݮ�������䣺108Ԫ/�¡����50M����GPRS�����ѡ������ײ��������Ĺ�����������0.29Ԫ/M�Ʒѡ�"+"|";
  }
  

  note_info1+="��ע��Ϣ��"+document.all.opNote.value+"|";
  document.all.cust_info.value=cust_info+"#";
  document.all.opr_info.value=opr_info+"#";
  document.all.note_info1.value=note_info1+"#";
  document.all.note_info2.value=note_info2+"#";
  document.all.note_info3.value=note_info3+"#";
  document.all.note_info4.value=note_info4+"#";
  retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
  retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
  return retInfo;
}

function showPrtDlg(printType,DlgMessage,submitCfm)
{  //��ʾ��ӡ�Ի���
   var h=200;
   var w=400;
   var t=screen.availHeight/2-h/2;
   var l=screen.availWidth/2-w/2;

   var pType="subprint";                                      // ��ӡ���ͣ�print ��ӡ subprint �ϲ���ӡ
   var billType="1";                                          // Ʊ�����ͣ�1���������2��Ʊ��3�վ�
   var sysAccept="<%=iLoginAccept%>";                         // ��ˮ��
   var printStr=printInfo(printType);                         //����printinfo()���صĴ�ӡ����
   var mode_code=null;                                        //�ʷѴ���
   var fav_code=null;                                         //�ط�����
   var area_code=null;                                        //С������
   var opCode="<%=opCode%>";                                  //��������
   var phoneNo="<%=iPhoneNo%>";                               //�ͻ��绰

   var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
   var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc.jsp?DlgMsg=" + DlgMessage+ "&submitCfm=" + submitCfm;
   path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode="+opCode+"&sysAccept="+sysAccept+"&phoneNo="+phoneNo+"&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
   var ret=window.showModalDialog(path,printStr,prop);

   return ret;
}

function frmCfm()
{
 	if(document.all.iBusiType.value == "" || document.all.iLevelId.value == "")
 	{
 		rdShowMessageDialog("��ѡ����Ч��ҵ�����ͺ��ʷ����!");
 		return;	
 	}
 	frm.submit();
	return true;
}

function doprint()
{
	getAfterPrompt();
	document.all.print.disabled=true;

	//��ӡ�������ύ����
    var ret = showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes");
    if(typeof(ret)!="undefined")
    {
      if((ret=="confirm"))
      {
        if(rdShowConfirmDialog('ȷ�ϵ����������ȷ��,���ύ����ҵ��!')==1)
        {
          document.all.printcount.value="1";
	      frmCfm();
        }
	  }
	  if(ret=="continueSub")
	  {
        if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
        {
          document.all.printcount.value="0";
	      frmCfm();
        }
	  }
    }
    else
    {
       if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
       {
       	 document.all.printcount.value="0";
	     frmCfm();
       }
    }
	document.all.print.disabled=false;
	return true;
}

function selectLevel()
{
	var iBusiType= document.all.iBusiType.value;
	
	for (var q1=document.all.iLevelId.options.length;q1>=0;q1--) document.all.iLevelId.options[q1]=null;
	
	for(i=0;i<myArrayId.length;i++)
	{
		if(iBusiType==myBusiType[i])
		{
			var a1 = document.createElement('option');
			a1.text = myArrayName[i];
			a1.value = myArrayId[i];
			document.all.iLevelId.add(a1);
		}
	}
}

</script>
</head>

<body>
<form name="frm" action="f9455_Cfm.jsp" method="post">
<%@ include file="/npage/include/header.jsp" %>
<div class="title">
	<div id="title_zi"><%=opName%></div>
</div>
<input type="hidden" name="opCode" value="<%=opCode%>">
<input type="hidden" name="iLoginAccept" value="<%=iLoginAccept%>">
<input type="hidden" name="opName" value="<%=opName%>">
<input type="hidden" name="printcount">
<input type="hidden" name="cust_info">
<input type="hidden" name="opr_info">
<input type="hidden" name="note_info1">
<input type="hidden" name="note_info2">
<input type="hidden" name="note_info3">
<input type="hidden" name="note_info4">
<table cellspacing="0">
	<tr>
		<td class="blue">�ͻ�����</td>
		<td><input name="custName" type="text" value="<%=vCustName%>" class="InputGrey" readonly></td>
		<td class="blue">�ֻ�����</td>
		<td><input name="phoneNo" type="text" value="<%=iPhoneNo%>" class="InputGrey" readonly></td>
	</tr>

	<tr>
		<td class="blue">�ͻ���ַ</td>
		<td><input name="custAddress" type="text" value="<%=vCustAddress%>" class="InputGrey" size="25" readonly></td>
		<td class="blue">ҵ��Ʒ��</td>
		<td><input name="smname" type="text" value="<%=vSmName%>" class="InputGrey" readonly></td>
	</tr>

	<tr>
		<td class="blue">֤������</td>
		<td><input name="idname" type="text" value="<%=vIdName%>" class="InputGrey" readonly></td>
		<td class="blue">֤������</td>
		<td><input name="icIccid" type="text" value="<%=vIdIccid%>" class="InputGrey" readonly></td>
	</tr>

	<tr>
		<td class="blue">��������</td>
		<td><input name="regionname" type="text" value="<%=vRegionName%>" class="InputGrey" readonly></td>
		<td class="blue">����״̬</td>
		<td><input name="runname" type="text" value="<%=vRunName%>" class="InputGrey" readonly></td>
	</tr>

	<tr>
		<td class="blue">ҵ������</td>
		<td><select name="iBusiType" onchange="selectLevel()">
			<option value="" selected="selected">--��ѡ��--</option>
			<option value="01">BlackBerry�����������</option>
			<!--<option value="02">BlackBerry����ȫ����</option>-->
			</select>
		</td>
		<td class="blue">�ʷ����</td>
		<td><select name="iLevelId">
			<option value="" selected="selected">--��ѡ��--</option>
			</select>
		</td>	
	</tr>

	<tr>
		<td class="blue">��ע</td>
		<td colspan="3"><input  name="opNote" type="text" value="<%=vOpNote%>" ></td>
	</tr>

	<tr>
    	<td noWrap colspan="6" id="footer">
		<div align="center">
 		<input type="button" name="print" class="b_foot" value="ȷ��&��ӡ" onClick="doprint()">
              &nbsp;
        <input type="button" name="return1" class="b_foot" value="����" onClick="history.go(-1)">
              &nbsp;
        <input type="button" name="close1" class="b_foot" value="�ر�" onClick="removeCurrentTab()">
      	</div>
   		</td>
	</tr>

<table>
	<%@ include file="/npage/include/footer.jsp" %>
<form>
</body>
</html>