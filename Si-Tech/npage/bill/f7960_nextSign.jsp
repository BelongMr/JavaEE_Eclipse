<%
/********************
 version v2.0
 ������: si-tech
 update zhaohaitao at 2009.1.8
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml">
	
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page contentType="text/html;charset=GBK"%>
<%@ page language="java" import="java.sql.*" %>
<%@ page import="java.util.*"%>
<%@ page import="com.sitech.boss.common.viewBean.comImpl"%>
<%@ page import="com.sitech.boss.s1210.pub.Pub_lxd"%>
<%@ page import="com.sitech.boss.pub.util.*" %>
<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="com.sitech.boss.spubcallsvr.viewBean.SPubCallSvrImpl"%>
<%@ page import="java.io.*"%>

<%              
  String opCode = request.getParameter("opCode");
  String opName = request.getParameter("opName");
  String iPhoneNo = request.getParameter("srv_no");
            
  String loginNo = (String)session.getAttribute("workNo");
  String orgCode = (String)session.getAttribute("orgCode");
  String regionCode = (String)session.getAttribute("regCode");
  
  //String paraStr[]=new String[1];
  //String prtSql="select to_char(sMaxSysAccept.nextval) from dual";
  //paraStr[0]=(((String[][])co1.fillSelect(prtSql))[0][0]).trim();
%>
	<wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="phone" routerValue="<%=iPhoneNo%>"  id="paraStr"/>
<%
  String printAccept = paraStr;
  String  retFlag="",retMsg="";  
  String  bp_name="",sm_code="",rate_code="",sm_name="",bigCust_flag="",bigCust_name="";
  String  rate_name="",next_rate_code="",next_rate_name="";
  String  total_prepay="",bp_add="",cardId_type="", cardId_no="", cust_id="",cust_belong_code="";
  String  imain_stream="",next_main_stream="",favorcode="",hand_fee="";
  String  card_no="",print_note="",group_type_code="",group_type_name="";
  String  oSaleName="",oSaleCode="",oModeCode="";
  String  omodename="",oColorMode="",oColorName="",oNextMode="";
  String  oBeginTime="",oEndTime="";
 
  
  String iLoginNoAccept = request.getParameter("backaccept");
  //String iOrgCode = request.getParameter("iOrgCode");
  String iOpCode = request.getParameter("opCode");
  SPubCallSvrImpl co = new SPubCallSvrImpl();
	String  inputParsm [] = new String[5];
	inputParsm[0] = iPhoneNo;
	inputParsm[1] = loginNo;
	inputParsm[2] = orgCode;
	inputParsm[3] = iOpCode;
	inputParsm[4] = iLoginNoAccept;
	System.out.println("phoneNO === "+ iPhoneNo);
	System.out.println("opCode === "+ iOpCode);


  //retList = co.callFXService("s7960cInit", inputParsm, "39","phone",iPhoneNo);
%>
	<wtc:service name="s7960cInit" routerKey="phone" routerValue="<%=iPhoneNo%>" retcode="retCode1" retmsg="retMsg1" outnum="39">
	<wtc:param value="<%=inputParsm[0]%>"/>	
	<wtc:param value="<%=inputParsm[1]%>"/>	
	<wtc:param value="<%=inputParsm[2]%>"/>	
	<wtc:param value="<%=inputParsm[3]%>"/>	
	<wtc:param value="<%=inputParsm[4]%>"/>	
	</wtc:service>	
	<wtc:array id="tempArr"  scope="end"/>
<%
  String errCode = retCode1;
  String errMsg = retMsg1;

	//co.printRetValue();
  if(tempArr.length==0)
  {
	   retFlag = "1";
	   retMsg = "s7960cInit��ѯ���������ϢΪ��!<br>errCode: " + errCode + "<br>errMsg+" + errMsg;  
  }
  else if(errCode.equals("000000") && tempArr.length>0)
  {
	  
	    bp_name = tempArr[0][3];           //��������
	 
	    bp_add = tempArr[0][4];            //�ͻ���ַ
	 
	    sm_code = tempArr[0][11];         //ҵ�����
	
	    sm_name = tempArr[0][12];        //ҵ���������
	  
	    rate_code = tempArr[0][5];     //�ʷѴ���
	 
	    rate_name = tempArr[0][6];    //�ʷ�����
	 
	    next_rate_code = tempArr[0][7];//�����ʷѴ���
	
	    next_rate_name = tempArr[0][8];//�����ʷ�����
	    
	    bigCust_flag = tempArr[0][9];//��ͻ���־
	 
	    bigCust_name = tempArr[0][10];//��ͻ�����
	    
	    hand_fee = tempArr[0][13];      //������
	    
	    favorcode = tempArr[0][14];     //�Żݴ���
	    
	    total_prepay = tempArr[0][16];//��Ԥ��
	 
	    cardId_type = tempArr[0][17];//֤������
	  
	    cardId_no = tempArr[0][18];//֤������
	 
	    cust_id = tempArr[0][19];//�ͻ�id
	  
	    cust_belong_code = tempArr[0][20];//�ͻ�����id
	    
	    group_type_code = tempArr[0][21];//���ſͻ�����
	 
	    group_type_name = tempArr[0][22];//���ſͻ���������
	 
	    imain_stream = tempArr[0][23];//��ǰ�ʷѿ�ͨ��ˮ
	 
	    next_main_stream = tempArr[0][24];//ԤԼ�ʷѿ�ͨ��ˮ
	 
	    oSaleCode = tempArr[0][25];//Ӫ��������
	 
	    oSaleName = tempArr[0][26];//Ӫ��������
	 
	    oModeCode = tempArr[0][27];//���ʷѴ���
	 
	    omodename = tempArr[0][28];//���ʷ�����
	    
	    System.out.println("omodename="+omodename);
	 
	    oColorMode = tempArr[0][29];//�����ʷѴ���
	  
	    oColorName = tempArr[0][30];//�����ʷ�����
	 
	    //oPayMoney = tempArr[0][31];//
	
	    oBeginTime = tempArr[0][32];//��ͨʱ��
	 
	    oEndTime = tempArr[0][33];//����ʱ��
	    
		oNextMode = tempArr[0][38]; //ȡ�����ʷѴ���
	 
	    print_note = tempArr[0][37];//����
	 		  
	 } 
	else{%>
	 <script language="JavaScript">
  		rdShowMessageDialog("������룺<%=errCode%>������Ϣ��<%=errMsg%>",0);  		
  	 	history.go(-1);
  	</script>
<%	
	}
%>

<head>
<title>����������ǩ</title>
<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>
<META content="MSHTML 5.00.3315.2870" name=GENERATOR>
 
<script language="JavaScript">
<!--
 
  onload=function()
  {
    
  	document.all.phoneNo.focus();
   	self.status="";
   }

//--------1---------doProcess����----------------
 
  function doProcess(packet)
  {
    var vRetPage=packet.data.findValueByName("rpc_page");
    var retType=packet.data.findValueByName("retType");
    if(vRetPage == "qryCus_s7960cInit")
    {
    var retCode = packet.data.findValueByName("retCode");
    var retMsg = packet.data.findValueByName("retMsg");
    var bp_name        = packet.data.findValueByName("bp_name"        );
    var sm_code         = packet.data.findValueByName("sm_code"        );
   	var bigCust_flag    = packet.data.findValueByName("bigCust_flag"   );
    var rate_code       = packet.data.findValueByName("rate_code"      );
    var sm_name         = packet.data.findValueByName("sm_name"        );
    var rate_name       = packet.data.findValueByName("rate_name"      );
   	var group_type_code = packet.data.findValueByName("group_type_code");
	  var group_type_name = packet.data.findValueByName("group_type_name");
    var next_rate_code  = packet.data.findValueByName("next_rate_code" );
    var next_rate_name  = packet.data.findValueByName("next_rate_name" );
   	var hand_fee        = packet.data.findValueByName("hand_fee"       );
	  var favorcode       = packet.data.findValueByName("favorcode"      );  
    var total_prepay    = packet.data.findValueByName("total_prepay"   );
    var bp_add          = packet.data.findValueByName("bp_add"         );
    var cardId_type     = packet.data.findValueByName("cardId_type"    );
    var cardId_no       = packet.data.findValueByName("cardId_no"      );
    var cust_id         = packet.data.findValueByName("cust_id"        );
    var cust_belong_code= packet.data.findValueByName("cust_belong_code");
    var bigCust_name    = packet.data.findValueByName("bigCust_name"   );
    var imain_stream    = packet.data.findValueByName("imain_stream"   );
    var next_main_stream= packet.data.findValueByName("next_main_stream");
      
    var card_no         = packet.data.findValueByName("card_no"        );
    var print_note      = packet.data.findValueByName("print_note"     );
    var oSaleCode      = packet.data.findValueByName("oSaleCode"     );
    var oSaleName       = packet.data.findValueByName("oSaleName"      );
    var oModeCode       = packet.data.findValueByName("oModeCode"      );
    var omodename     = packet.data.findValueByName("omodename"    );
    var oColorMode        = packet.data.findValueByName("oColorMode"       );
    var oColorName        = packet.data.findValueByName("oColorName"       );
    var oNextMode		= packet.data.findValueByName("oNextMode"       );  
       
		if(retCode == 000000)
		{
		document.all.i1.value = document.all.phoneNo.value;
		document.all.i2.value = cust_id;
		document.all.i16.value = rate_code;
    	document.frm.ip.value= next_rate_code;							
		document.all.belong_code.value = cust_belong_code;			
		document.all.print_note.value = print_note;			

		document.all.i4.value = bp_name;
		document.all.i5.value = bp_add;						
		document.all.i6.value = cardId_type;			
		document.all.i7.value = cardId_no;	
		document.all.i8.value = sm_code+"--"+sm_name;			

		document.all.ipassword.value = "";						
		document.all.i19.value = hand_fee;
		document.all.i20.value = hand_fee;
		document.all.favorcode.value = favorcode;
		document.all.group_type.value = group_type_code+"--"+group_type_name;	
		document.all.ibig_cust.value =  bigCust_flag+"--"+bigCust_name;
					
		document.all.maincash_no.value = rate_code;			
		document.all.imain_stream.value =  imain_stream;	
		document.all.next_main_stream.value =  next_main_stream;

		document.all.i18.value = next_rate_code+"--"+next_rate_name;			
		
		

		document.all.oCustName.value = bp_name;
		document.all.oSmCode.value = sm_code;
		document.all.oSmName.value = sm_name;
		document.all.oModeCode.value = rate_code;
		document.all.oModeName.value = rate_name;
		document.all.oPrepayFee.value = total_prepay;	
		//document.all.oMarkPoint.value = "0";
				
		document.all.Sale_Code.value = oSaleCode;
		document.all.Sale_Name.value = oSaleName;		
		document.all.Mode_Code.value = oModeCode;
		document.all.Mode_Name.value = omodename;
		document.all.Color_Name.value = oColorName;		
		document.all.Color_Mode.value = oCorlorMode;

		document.all.do_note.value = document.all.phoneNo.value+"�������������"+document.all.Sale_Code.value+"����Ʒ���룺"+document.all.Sale_Name.value;
	  document.frm.iAddStr.value=document.frm.backaccept.value+"|"+document.frm.Sale_Name.value+"|"+
	                        document.frm.Color_Mode.value+"|"+document.frm.Color_Name.value+"|"+document.frm.Mode_Name.value+"|"+
	                        document.frm.Mode_Code.value+"|";
	      //alert(document.frm.iAddStr.value);                  
		}else
			{
				rdShowMessageDialog("����:"+ retCode + "->" + retMsg,0);
				return;
			}    
  	}
  	if(vRetPage == "qryAreaFlag")
    {    
	    var retCode = packet.data.findValueByName("retCode");
	    var retMsg = packet.data.findValueByName("retMsg");
	    var area_flag        = packet.data.findValueByName("area_flag");

		if(retCode == 000000)
		{
		    if(parseInt(area_flag)>0)
		    {
		       document.all.flagCodeTr.style.display="";
		       getFlagCode();
		    }
		}
		else
		{
				rdShowMessageDialog("����:"+ retCode + "->" + retMsg);
				return;
		}
	} 
	
 }
  
  //--------2---------��֤��ťר�ú���-------------
 
  function chkPass()
  {    	
  var myPacket = new AJAXPacket("qryCus_s7960cInit.jsp","���ڲ�ѯ�ͻ������Ժ�......");
	myPacket.data.add("iPhoneNo",jtrim(document.all.phoneNo.value));
	myPacket.data.add("iLoginNo",jtrim(document.all.loginNo.value));
	myPacket.data.add("iOrgCode",jtrim(document.all.orgCode.value));
	myPacket.data.add("iOpCode",jtrim(document.all.iOpCode.value));
	
	core.ajax.sendPacket(myPacket);
	myPacket=null;
  }


  function frmCfm()
  {
  		 if(document.frm.op.value=="")
     	document.frm.op.value="�û������˲���Ӫ������ǩ����";
  		 //getAfterPrompt();
         if(!checkElement(document.all.phoneNo)) return;
         document.frm.iAddStr.value=document.frm.Nsale_code.value+"|"+document.frm.Ncolor_mode.value+"|"+document.frm.Npay_money.value+"|"+document.frm.End_Time.value+"|"+document.all.op.value+"|"+document.frm.backaccept.value+"|";
       	//alert(document.frm.iAddStr.value);
         
		    frm.submit();
        
  }

 function judge_area()
 {
	var myPacket = new AJAXPacket("qryAreaFlag.jsp","���ڲ�ѯ�ͻ������Ժ�......");
	myPacket.data.add("orgCode",(document.all.orgCode.value).trim());
	myPacket.data.add("modeCode",(document.all.Nmode_code.value).trim());
	core.ajax.sendPacket(myPacket);
	myPacket=null; 
 }
 
function salechage()
{
	document.all.commit.disabled=true;
	document.getElementById("flagCodeTr").style.display="none";
	document.all.flag_code.value="";
	document.all.flag_code_name.value="";
  	//���ù���js
  	var regionCode = "<%=regionCode%>";
  	var rate_code = "<%=rate_code%>";
    var pageTitle = "Ӫ������Ϣ";
    var fieldName = "�ʷѴ���|�ʷ�����|���ʷѴ���|���ʷ�����|�����ʷѴ���|�����ʷ�����|��������|�����ʷ�";//����������ʾ���С����� 
    /*
    var sqlStr = "select a.sale_code,a.sale_name,a.mode_code,b.mode_name,a.color_mode,c.mode_name color_name,e.pay_money,a.next_mode from DBCUSTADM.SCOLORRINGSALECFG a,sbillmodecode b,sbillmodecode c,cbillbbchg d,scolormode e "
               + "where a.region_code='"+regionCode+"' and a.region_code=b.region_code and a.region_code=c.region_code and a.color_mode=c.mode_code and sysdate between��a.begin_time and a.end_time and a.mode_code=b.mode_code and a.mode_code=d.new_mode and d.old_mode='"+rate_code+"' and d.op_code='"+document.all.opCode.value+"' and a.region_code=e.region_code and a.color_mode=e.product_code and e.mode_bind='1'";
    */
    //var sqlStr = "select a.sale_code,a.sale_name,a.mode_code,b.offer_name,a.color_mode,c.offer_name color_name,e.pay_money,a.next_mode from DBCUSTADM.SCOLORRINGSALECFG a,product_offer b,product_offer c,cbillbbchg d,scolormode e "
    //						+" where a.color_mode=c.offer_id and a.mode_code=b.offer_id  and a.mode_code=d.new_mode and a.color_mode=e.product_code and sysdate between��a.begin_time and a.end_time and d.old_mode='"+rate_code+"' and d.op_code='"+document.all.opCode.value+"' and e.mode_bind='1'";  
    
    var sqlStr = "select a.sale_code,a.sale_name,a.mode_code,b.offer_name,a.color_mode,c.offer_name color_name,e.pay_money,a.next_mode from DBCUSTADM.SCOLORRINGSALECFG a,product_offer b,product_offer c,product_offer_relation d,scolormode e "
	    						+" where a.color_mode=c.offer_id and a.mode_code=b.offer_id  and a.color_mode=e.product_code and sysdate between��a.begin_time and a.end_time and d.offer_a_id='"+rate_code+"' and a.mode_code=d.offer_z_id and e.mode_bind='1'";      
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "0|1|2|3|4|5|6|7";//�����ֶ�
    var retToField = "Nsale_code|Nsale_name|Nmode_code|Nmode_name|Ncolor_mode|Ncolor_name|Npay_money|next_mode";//���ظ�ֵ����
	if(PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));    
    	document.frm.iAddStr.value=document.frm.Nsale_code.value+"|"+document.frm.Ncolor_mode.value+"|"+document.frm.Npay_money.value+"|";
    	
    //alert("daixy test 111111111"+rate_code+"op_code"+document.all.opCode.value);	
	document.frm.ip.value=document.frm.Nmode_code.value;
		document.frm.i1.value=document.frm.phoneNo.value;	
     getMidPrompt("10442",codeChg(document.frm.Nmode_code.value),"ipTd");
     getMidPrompt("10442",codeChg(document.frm.Ncolor_mode.value),"ipTd1");
     	document.all.commit.disabled=false;
     judge_area();
     //alert(document.frm.Nmode_code.value);
}
function oneTokSelf(str,tok,loc)
  {
	    var temStr=str;
		var temLoc;
		var temLen;
	    for(ii=0;ii<loc-1;ii++)
		{
			temLen=temStr.length;
			temLoc=temStr.indexOf(tok);
			temStr=temStr.substring(temLoc+1,temLen);
	 	}
		if(temStr.indexOf(tok)==-1)
		  	return temStr;
		else
	      	return temStr.substring(0,temStr.indexOf(tok));
  }  
function getFlagCode()
{
  	
  	//���ù���js
    var pageTitle = "�ʷѲ�ѯ";
    var fieldName = "С������|С������|��������";//����������ʾ���С����� 
    //var sqlStr ="select a.flag_code, a.flag_code_name,a.rate_code from sRateFlagCode a where  a.region_code='" + document.frm.orgCode.value.substring(0,2) + "' order by a.flag_code" ;
	var sqlStr ="select a.flag_code, a.flag_code_name from sofferflagcode a, sregioncode b where a.group_id = b.group_id and b.region_code = '" + document.frm.orgCode.value.substring(0,2) + "' and offer_id = "+ document.frm.mode_code.value +""
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "0|1|2";//�����ֶ�
    var retToField = "flag_code|flag_code_name|rate_code";//���ظ�ֵ����
    
    if(PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));
}

function codeChg(s)
{
  var str = s.replace(/%/g, "%25").replace(/\+/g, "%2B").replace(/\s/g, "+"); // % + \s
  str = str.replace(/-/g, "%2D").replace(/\*/g, "%2A").replace(/\//g, "%2F"); // - * /
  str = str.replace(/\&/g, "%26").replace(/!/g, "%21").replace(/\=/g, "%3D"); // & ! =
  str = str.replace(/\?/g, "%3F").replace(/:/g, "%3A").replace(/\|/g, "%7C"); // ? : |
  str = str.replace(/\,/g, "%2C").replace(/\./g, "%2E").replace(/#/g, "%23"); // , . #
  return str;
}
//����Ӫ������ǩ

//-->
</script>

</head>

<body>
	<form name="frm" method="post" action="f1270_3.jsp?activePhone=<%=iPhoneNo%>" onKeyUp="chgFocus(frm)">
		<%@ include file="/npage/include/header.jsp" %>   
  	
		<div class="title">
			<div id="title_zi">�û���Ϣ</div>
		</div>
		<input name="oSmCode" type="hidden" class="button" id="oSmCode" value="<%=sm_code%>">
		<input name="oModeCode" type="hidden" class="button" id="oModeCode" value="<%=rate_code%>">
		<input type="hidden" name="back_flag_code" value="">
		<input type="hidden" name="loginAccept" value="<%=paraStr%>">
	

	<table cellspacing="0">
		<tr>
			<td class="blue">�ֻ�����</td>
            <td>
				<input class="InputGrey"  type="text" v_must="1" v_type="mobphone" v_must=1 name="phoneNo" id="phoneNo" onBlur="if(this.value!=''){if(checkElement(document.all.phoneNo)==false){return false;}}" maxlength=11 index="3" value="<%=iPhoneNo%>" readonly >
			</td> 
			<td class="blue">��������</td>
			<td>
				<input name="oCustName" type="text" class="InputGrey" id="oCustName" value="<%=bp_name%>" readonly>                    
			</td>           
		</tr>
		<tr> 
			<td class="blue">ҵ��Ʒ��</td>
            <td>
				<input name="oSmName" type="text" class="InputGrey" id="oSmName" value="<%=sm_name%>" readonly>
			</td>
            <td class="blue">�ʷ�����</td>
            <td>
				<input name="oModeName" type="text" class="InputGrey" id="oModeName" value="<%=rate_name%>" readonly>
			</td>            
		</tr>
		<tr> 
			<td class="blue">
				�ʺ�Ԥ��
			</td>
            <td >
				<input name="oPrepayFee" type="text" class="InputGrey" id="oPrepayFee" value="<%=total_prepay%>" readonly>
			</td>
			<td>
				<input name="1" type="hidden" class="InputGrey" id="1"  readonly>
			</td>
			<td>
				<input name="2" type="hidden" class="InputGrey" id="2"  readonly>
			</td>
		</tr>
	</table>
</div>
<div id="Operation_Table"> 
	<div class="title">
	<div id="title_zi">��ǰҵ����ϸ</div>
	</div>
		<TABLE cellSpacing="0">
          <TBODY> 
		<tr>	
            <td class="blue">
            	��ǰӪ����
            </td>
            <td>
            	<input type="text" name="Sale_Code" id="Sale_Code" value="<%=oSaleCode%>" readonly class="InputGrey">
			</td>            
            <td class="blue">
            	��ǰӪ��������
            </td>
            <td>
				<input name="Sale_Name" type="text" class="InputGrey" id="Sale_Name" value="<%=oSaleName%>" readonly>
			</td>
		</tr>
		<tr>	
			<td class="blue">
				��ǰ���ʷѴ���
			</td>
            <td>
				<input name="Mode_Code" type="text" class="InputGrey" id="Mode_Code" readonly value="<%=oModeCode%>">
			</td>  
			<td class="blue">
				��ǰ���ʷ�����
			</td>
			<td>
				<input name="Mode_Name" type="text" class="InputGrey" id="Mode_Name" readonly value="<%=omodename%>">
		</tr>
			<tr>	
            <td class="blue">
            	��ǰҵ��ͨ����
            </td>
            <td>
            	<input type="text" name="Begin_Time" id="Begin_Time" value="<%=oBeginTime%>" readonly class="InputGrey">
			</td>            
            <td class="blue">
            	��ǰҵ��������
            </td>
            <td>
				<input name="End_Time" type="text" class="InputGrey" id="End_Time" value="<%=oEndTime%>" readonly>
			</td>
		</tr>		
		<tr> 
     	 <td class="blue">
       		 ��ǰ�������
      	</td>
      		<td>
				<input name="Color_Mode" type="text" class="InputGrey" id="Color_Mode"  value="<%=oColorMode%>" readonly>
			</td>
			<td class="blue">
				��ǰ��������
			</td>
            <td>
				<input name="Color_Name" type="text" class="InputGrey" id="Color_Name"  value="<%=oColorName%>" readonly>
			</td>             
		</tr>
	</table>
</div>
<div id="Operation_Table"> 
	<div class="title">
	<div id="title_zi">��ҵ����Ϣ</div>
	</div>
		<TABLE cellSpacing="0">
          <TBODY> 
		<tr>
		 <td class="blue">��Ӫ��������</td>
            <td>
			  <input name="Nsale_code" type="text" class="button" id="Nsale_code" size="8" readonly>
              
              <input name="qry" class="b_text" type="button" value="��ѯ" onclick="salechage()">
         	</td>
         <td class="blue">��Ӫ��������</td>	
         	<td>
         		<input name="Nsale_name" type="text" class="InputGrey" id="Nsale_name" size="8" readonly>
         	</td>
         	<td>
         	</td>
		</tr>
		
		<tr>

			<td class="blue">
				�����ʷѴ���
			</td>
            <td id="ipTd">
				<input name="Nmode_code" type="text" class="InputGrey" id="Nmode_code"   readonly>
			</td>  
			 <td class="blue">
            	�����ʷ�����
            </td>
            <td>
            	<input name="Nmode_name" type="text" class="InputGrey" id="Nmode_name"   readonly>
			</td>
		</tr>
		<tr> 

			<td class="blue">
				�²����ʷѴ���
			</td>
            <td id="ipTd1">
				<input name="Ncolor_mode" type="text" class="InputGrey" id="Ncolor_mode" readonly>
			</td>  
			<td class="blue">
				�²����ʷ�����
			</td>
            <td>
            	<input name="Ncolor_name" type="text" class="InputGrey" id="Ncolor_name" readonly>
			</td>
		</tr>
		<tr>
            <td class="blue">
            	��������
            </td>
            <td>
            	<input name="Npay_money" type="text" class="InputGrey" id="Npay_money" readonly>
            </td>
            <td colspan=2>
   				<input name="next_mode" type="hidden" class="button" id="next_mode" readonly>
        		<input name="op" type="hidden" class="button" id="op" maxlength=30>
        	</td>
		</tr>
		<tr id="flagCodeTr" style="display:none">
		    <TD class="blue">С������</TD>
			  <TD colspan="3">
				    <input type="hidden" size="17" name="rate_code" id="rate_code" class="button" readonly>
           			<input type="text" class="button" name="flag_code" size="8" maxlength="10" readonly>
			      <input type="text" class="button" name="flag_code_name" size="18" readonly >&nbsp;&nbsp;
			      <input name="newFlagCodeQuery" type="button" class="b_text"  style="cursor:hand" onClick="getFlagCode()" value=ѡ��>
       		 </TD>
      	</tr>		
		<tr> 
			<td colspan="4" id="footer"> 
				<div align="center"> 
                &nbsp; 
				<input name="commit" id="commit" type="button" class="b_foot"   value="��һ��" onClick="frmCfm();" disabled >
                &nbsp; 
                <input name="reset" type="reset" class="b_foot" value="���" >
                &nbsp; 
                <input name="close" onClick="removeCurrentTab();" type="button" class="b_foot" value="�ر�">
                &nbsp; 
				</div>
			</td>
		</tr>
	</table>
<div name="licl" id="licl">	
			<input type="hidden" name="opCode" value="7965">
			<input type="hidden" name="iOpCode" value="7965">
			<input type="hidden" name="opName" value="<%=opName%>">
			<input type="hidden" name="loginNo" value="<%=loginNo%>">
			<input type="hidden" name="orgCode" value="<%=orgCode%>">			
	    <!--���²�����Ϊ��f1270_3.jsp������Ĳ���
			i2:�ͻ�ID
			i16:��ǰ���ײʹ���
			ip:�������ײʹ���
			belong_code:belong_code
			print_note:��������
			
			i1:�ֻ�����
			i5:�ͻ���ַ
			i6:֤������
			i7:֤������
			i8:ҵ��Ʒ��
			
			ipassword:����
			group_type:���ſͻ����
			ibig_cust:��ͻ����
			do_note:�û���ע
			favorcode:�������Ż�Ȩ��
			maincash_no:�����ײʹ��루�ϣ�
			imain_stream:��ǰ���ʷѿ�ͨ��ˮ
			next_main_stream:ԤԼ���ʷѿ�ͨ��ˮ
			
			i18:�������ײ�
			i19:������
			i20:���������
			
			beforeOpCode:ԭҵ�������op_code
			-->				
			<input type="hidden" name="i2" value="<%=cust_id%>">	                			
			<input type="hidden" name="i16"  value="<%=rate_code%>">	
			<input type="hidden" name="ip" 	value="<%=next_rate_code%>">		

			<input type="hidden" name="belong_code" value="<%=cust_belong_code%>">								
			<input type="hidden" name="print_note" value="<%=print_note%>">
			<input type="hidden" name="iAddStr" value="">

			<input type="hidden" name="i1" value="<%=iPhoneNo%>">
			<input type="hidden" name="i4" value="<%=bp_name%>">			
			<input type="hidden" name="i5" value="<%=bp_add%>">
			<input type="hidden" name="i6" value="<%=cardId_type%>">
			<input type="hidden" name="i7" value="<%=cardId_no%>">
			<input type="hidden" name="i8" value="<%=sm_code%>"+"--"+"<%=sm_name%>">			

			<input type="hidden" name="ipassword" value="">
			<input type="hidden" name="favorcode" value="<%=favorcode%>">
			<input type="hidden" name="group_type" value="<%=group_type_code%>--<%=group_type_name%>">
			<input type="hidden" name="do_note" value="<%=iPhoneNo%>"+"������ǩ">
			<input type="hidden" name="ibig_cust" value="<%=bigCust_flag%>--<%=bigCust_name%>">
			<input type="hidden" name="maincash_no" value="<%=rate_code%>">			
			<input type="hidden" name="imain_stream" value="<%=imain_stream%>">
			<input type="hidden" name="next_main_stream" value="<%=next_main_stream%>">
			<input type="hidden" name="i19" value="<%=hand_fee%>">			
			<input type="hidden" name="i20" value="<%=hand_fee%>">	
			<input type="hidden" name="i18" value="<%=next_rate_code%>"+"--"+"<%=next_rate_name%>">
				
			<input type="hidden" name="beforeOpCode" value="7960">	
			<input type="hidden" name="backaccept" value="<%=iLoginNoAccept%>">		
			
			<input type="hidden" name="return_page" value="/npage/bill/f7960_login.jsp?activePhone=<%=iPhoneNo%>&opName=<%=opName%>&opCode=<%=opCode%>">	
			<input type="hidden" name="ipAddr" value="<%=(String)session.getAttribute("ipAddr")%>" >	
</div>				
			<%@ include file="/npage/include/footer.jsp" %>        	
</form>
</body>
</html>