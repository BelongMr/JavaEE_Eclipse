<%
/********************
 * version v2.0
 * ������: si-tech
 * update by qidp @ 2009-01-06
 ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" import="java.sql.*" %>
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="com.sitech.boss.pub.util.*" %>
<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="java.io.*"%>
<%@ include file="/npage/properties/getRDMessage.jsp" %>
<%String Readpaths = request.getRealPath("npage/properties")+"/getRDMessage.properties";%>

<%          
    String opCode = "2283";
    String opName = "ȫ��ͨǩԼ����";
    String loginNo = (String)session.getAttribute("workNo");
    String loginName = (String)session.getAttribute("workName");
    String powerCode= (String)session.getAttribute("powerCode");
    String orgCode = (String)session.getAttribute("orgCode");
    String ip_Addr = (String)session.getAttribute("ipAddr");
    String regionCode = orgCode.substring(0,2);
    
    /* liujian ��ȫ�ӹ��޸� 2012-4-6 16:18:13 begin */
 // String loginNoPass = (String)session.getAttribute("password");
		String op_strong_pwd = (String) session.getAttribute("password");
	  /* liujian ��ȫ�ӹ��޸� 2012-4-6 16:18:13 end */
	        //comImpl co1 = new comImpl();
    String paraStr[]=new String[1];
        //String prtSql="select to_char(sMaxSysAccept.nextval) from dual";
        //paraStr[0]=(((String[][])co1.fillSelect(prtSql))[0][0]).trim();
%>
    <wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>"  id="seq"/>
<%
    paraStr[0] = seq;
    System.out.println("sysAccept===   "+paraStr[0]);
    String printAccept=seq;
    ArrayList retList = new ArrayList();
    String[][] tempArr= new String[][]{};
    
    String  retFlag="",retMsg="";  
    String  bp_name="",sm_code="",family_code="",rate_code="",bigCust_flag="",sm_name="";
    String  rate_name="",bigCust_name="",next_rate_code="",next_rate_name="",lack_fee="";
    String  prepay_fee="",bp_add="",cardId_type="", cardId_no="", cust_id="",cust_belong_code="";
    String  group_type_code="",group_type_name="",imain_stream="",next_main_stream="",hand_fee="";
    String  favorcode="",card_no="",print_note="",contract_flag="",high_flag="",passwordFromSer="";

	
	String iPhoneNo = request.getParameter("srv_no");
	//String phoneNo = request.getParameter("srv_no");
    	//String iLoginNo = request.getParameter("iLoginNo");
    	//String iOrgCode = request.getParameter("iOrgCode");
	String iOpCode = request.getParameter("opcode");
	String cus_pass = request.getParameter("cus_pass");
	String getCardCodeSql="select card_code from dbvipadm.dGrpBigUserMsg where phone_no ='"+iPhoneNo+"'";
	System.out.println("getCardCodeSql|"+getCardCodeSql);
	String cardCode="";	    
%>
<wtc:pubselect name="sPubSelect"  retcode="retCode1" retmsg="retMsg1" outnum="1">
 <wtc:sql><%=getCardCodeSql%>
 </wtc:sql>
 </wtc:pubselect>
<wtc:array id="result1" scope="end"/>		
<%
	if(result1.length!=0){
  		cardCode=result1[0][0];
	}

	//SPubCallSvrImpl co2 = new SPubCallSvrImpl();
	String  inputParsm [] = new String[4];
	inputParsm[0] = iPhoneNo;
	inputParsm[1] = loginNo;
	inputParsm[2] = orgCode;
	inputParsm[3] = iOpCode;
	System.out.println("phoneNO === "+ iPhoneNo);


    //retList = co2.callFXService("s126bInit", inputParsm, "29","phone",iPhoneNo);
%>
    <wtc:service name="s126bInit" routerKey="phone" routerValue="<%=iPhoneNo%>" retcode="s126bInitCode" retmsg="s126bInitMsg" outnum="29">
        <wtc:param value=""/>
				<wtc:param value="01"/>
				<wtc:param value="<%=iOpCode%>"/>
				<wtc:param value="<%=loginNo%>"/>
				<wtc:param value="<%=op_strong_pwd%>"/>
				<wtc:param value="<%=iPhoneNo%>"/>
				<wtc:param value=""/>
				<wtc:param value="<%=inputParsm[2]%>"/>
    </wtc:service>
    <wtc:array id="s126bInitArr" scope="end" />
<% 
  String errCode = s126bInitCode;
  String errMsg = s126bInitMsg;

	//co2.printRetValue();
  
  if(s126bInitArr == null)
  {
	   retFlag = "1";
	   retMsg = "s126bInit��ѯ���������ϢΪ��!<br>errCode: " + errCode + "<br>errMsg+" + errMsg;
  }
  else
  {
	  if (errCode.equals("000000") ){
    	  //tempArr = (String[][])retList.get(3);
    	  if(!(s126bInitArr[0][3].equals(""))){
    	    bp_name = s126bInitArr[0][3];           //��������
    	  }
    
    	  //tempArr = (String[][])retList.get(4);
    	  if(!(s126bInitArr[0][4].equals(""))){
    	    bp_add = s126bInitArr[0][4];            //�ͻ���ַ
    	  }
    
    	  //tempArr = (String[][])retList.get(2);
    	  if(!(s126bInitArr[0][2].equals(""))){
    	    passwordFromSer = s126bInitArr[0][2];  //����
    	  }
    
    	  //tempArr = (String[][])retList.get(11);
    	  if(!(s126bInitArr[0][11].equals(""))){
    	    sm_code = s126bInitArr[0][11];         //ҵ�����
    	  }
    
    	  //tempArr = (String[][])retList.get(12);
    	  if(!(s126bInitArr[0][12].equals(""))){
    	    sm_name = s126bInitArr[0][12];        //ҵ���������
    	  }
    
    	  //tempArr = (String[][])retList.get(13);
    	  if(!(s126bInitArr[0][13].equals(""))){
    	    hand_fee = s126bInitArr[0][13];      //������
    	  }
    	  System.out.println("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    	  System.out.println(hand_fee);
    
    	  //tempArr = (String[][])retList.get(14);
    	  if(!(s126bInitArr[0][4].equals(""))){
    	    favorcode = s126bInitArr[0][14];     //�Żݴ���
    	  }
    
    	  //tempArr = (String[][])retList.get(5);
    	  if(!(s126bInitArr[0][5].equals(""))){
    	    rate_code = s126bInitArr[0][5];     //�ʷѴ���
    	  }
    
    	  //tempArr = (String[][])retList.get(6);
    	  if(!(s126bInitArr[0][6].equals(""))){
    	    rate_name = s126bInitArr[0][6];    //�ʷ�����
    	  }
    
    	  //tempArr = (String[][])retList.get(7);
    	  if(!(s126bInitArr[0][7].equals(""))){
    	    next_rate_code = s126bInitArr[0][7];//�����ʷѴ���
    	  }
    
    	  //tempArr = (String[][])retList.get(8);
    	  if(!(s126bInitArr[0][8].equals(""))){
    	    next_rate_name = s126bInitArr[0][8];//�����ʷ�����
    	  }
    
    	  //tempArr = (String[][])retList.get(9);
    	  if(!(s126bInitArr[0][9].equals(""))){
    	    bigCust_flag = s126bInitArr[0][9];//��ͻ���־
    	  }
    
    	  //tempArr = (String[][])retList.get(10);
    	  if(!(s126bInitArr[0][10].equals(""))){
    	    bigCust_name = s126bInitArr[0][10];//��ͻ�����
    	  }
    
    	  //tempArr = (String[][])retList.get(15);
    	  if(!(s126bInitArr[0][15].equals(""))){
    	    lack_fee = s126bInitArr[0][15];//��Ƿ��
    	  }
    
    	  //tempArr = (String[][])retList.get(16);
    	  if(!(s126bInitArr[0][16].equals(""))){
    	    prepay_fee = s126bInitArr[0][16];//��Ԥ��
    	  }
    
    	  //tempArr = (String[][])retList.get(17);
    	  if(!(s126bInitArr[0][17].equals(""))){
    	    cardId_type = s126bInitArr[0][17];//֤������
    	  }
    
    	  //tempArr = (String[][])retList.get(18);
    	  if(!(s126bInitArr[0][18].equals(""))){
    	    cardId_no = s126bInitArr[0][18];//֤������
    	  }
    
    	  //tempArr = (String[][])retList.get(19);
    	  if(!(s126bInitArr[0][19].equals(""))){
    	    cust_id = s126bInitArr[0][19];//�ͻ�id
    	  }
    
    	  //tempArr = (String[][])retList.get(20);
    	  if(!(s126bInitArr[0][20].equals(""))){
    	    cust_belong_code = s126bInitArr[0][20];//�ͻ�����id
    	  }
    
    	  //tempArr = (String[][])retList.get(21);
    	  if(!(s126bInitArr[0][21].equals(""))){
    	    group_type_code = s126bInitArr[0][21];//���ſͻ�����
    	  }
    
    	  //tempArr = (String[][])retList.get(22);
    	  if(!(s126bInitArr[0][22].equals(""))){
    	    group_type_name = s126bInitArr[0][22];//���ſͻ���������
    	  }
    
    	  //tempArr = (String[][])retList.get(23);
    	  if(!(s126bInitArr[0][23].equals(""))){
    	    imain_stream = s126bInitArr[0][23];//��ǰ�ʷѿ�ͨ��ˮ
    	  }
    
    	  //tempArr = (String[][])retList.get(24);
    	  if(!(s126bInitArr[0][24].equals(""))){
    	    next_main_stream = s126bInitArr[0][24];//ԤԼ�ʷѿ�ͨ��ˮ
    	  }
    
    	  //tempArr = (String[][])retList.get(25);
    	  if(!(s126bInitArr[0][25].equals(""))){
    	    print_note = s126bInitArr[0][25];//�������
    	  }
    
    	  //tempArr = (String[][])retList.get(27);
    	  if(!(s126bInitArr[0][27].equals(""))){
    	    contract_flag = s126bInitArr[0][27];//�Ƿ������˻�
    	  }
    
    	  //tempArr = (String[][])retList.get(28);
    	  if(!(s126bInitArr[0][28].equals(""))){
    	    high_flag = s126bInitArr[0][28];//�Ƿ��и߶��û�
    	  }
	 }else{%>
		<script language="JavaScript">
			rdShowMessageDialog("������룺<%=errCode%>��������Ϣ��<%=errMsg%>",0);
			history.go(-1);

		</script>
<%	 }
	}
	//String rpcPage = "qryCus_s2283Init";

	
	
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>ȫ��ͨǩԼ����</title>
<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>
<META content="MSHTML 5.00.3315.2870" name=GENERATOR>

 
<script language="JavaScript">
<!--
  //core.loadUnit("debug");
  //core.loadUnit("rpccore");
  onload=function()
  {
    
  	document.all.phoneNo.focus();
   	//core.rpc.onreceive = doProcess;
   	self.status="";
   }
  var arrbrandcode = new Array();//�ֻ��ͺŴ���
  var arrbrandname = new Array();//�ֻ��ͺ�����
  var arrbrandmoney = new Array();//�����̴���
  
  var arrPhoneType = new Array();//�ֻ��ͺŴ���
  var arrPhoneName = new Array();//�ֻ��ͺ�����
  var arrAgentCode = new Array();//�����̴���
  var selectStatus = 0;
  
  var arrsalecode =new Array();
  var arrsaleName=new Array();
  var arrsalebarnd=new Array();
  var arrsaletype=new Array();
  var arrtypemoney=new Array();
  var arrsalemoney=new Array();
  
  var arrdetbase=new Array();
  var arrdetfree=new Array();
  var arrdetfavour=new Array();
  var arrdetconsume=new Array();
  var arrdetmonbase=new Array();
  var arrdetmode=new Array();
  var arrdetsummoney=new Array();
  var arrdetsalecode=new Array();
//--------1---------doProcess����----------------

  function doProcess(packet)
  {
  
    var vRetPage=packet.data.findValueByName("rpc_page");
    
    if(vRetPage == "qryCus_s2283Init")
    {   
    //alert("run at doProcess");
    var retCode = packet.data.findValueByName("retCode");
    var retMsg = packet.data.findValueByName("retMsg");

    var bp_name         = packet.data.findValueByName("bp_name"        );
    var sm_code         = packet.data.findValueByName("sm_code"        );
    var family_code     = packet.data.findValueByName("family_code"    );
    var rate_code       = packet.data.findValueByName("rate_code"      );
    var bigCust_flag    = packet.data.findValueByName("bigCust_flag"   );
    var sm_name         = packet.data.findValueByName("sm_name"        );
    var rate_name       = packet.data.findValueByName("rate_name"      );
    var bigCust_name    = packet.data.findValueByName("bigCust_name"   );
    var next_rate_code  = packet.data.findValueByName("next_rate_code" );
    var next_rate_name  = packet.data.findValueByName("next_rate_name" );
    var lack_fee        = packet.data.findValueByName("lack_fee"       );
    var prepay_fee      = packet.data.findValueByName("prepay_fee"     );
    var bp_add          = packet.data.findValueByName("bp_add"         );
    var cardId_type     = packet.data.findValueByName("cardId_type"    );
    var cardId_no       = packet.data.findValueByName("cardId_no"      );
    var cust_id         = packet.data.findValueByName("cust_id"        );
    var cust_belong_code= packet.data.findValueByName("cust_belong_code");
    var group_type_code = packet.data.findValueByName("group_type_code");
    var group_type_name = packet.data.findValueByName("group_type_name");
    var imain_stream    = packet.data.findValueByName("imain_stream"   );
    var next_main_stream= packet.data.findValueByName("next_main_stream");
    var hand_fee        = packet.data.findValueByName("hand_fee"       );
    var favorcode       = packet.data.findValueByName("favorcode"      );
    var card_no         = packet.data.findValueByName("card_no"        );
    var print_note      = packet.data.findValueByName("print_note"     );
    var contract_flag   = packet.data.findValueByName("contract_flag"  );
    var high_flag       = packet.data.findValueByName("high_flag"      );		
							
		if(retCode == 000000)
		{
		document.all.i2.value = cust_id;
		document.all.i16.value = rate_code;						
		document.all.belong_code.value = cust_belong_code;			
		document.all.print_note.value = print_note;			

		document.all.i4.value = bp_name;						
		document.all.i5.value = bp_add;						
		document.all.i6.value = cardId_type;			
		document.all.i7.value = cardId_no;	
		document.all.i8.value = sm_code+"--"+sm_name;			
		document.all.i9.value = contract_flag;			

		document.all.ipassword.value = "";						
		document.all.group_type.value = group_type_code+"--"+group_type_name;			
		document.all.ibig_cust.value =  bigCust_flag+"--"+bigCust_name;	

		document.all.favorcode.value = favorcode;						
		document.all.maincash_no.value = rate_code;			
		document.all.imain_stream.value =  imain_stream;	
		document.all.next_main_stream.value =  next_main_stream;

		document.all.i18.value = next_rate_code+"--"+next_rate_name;			
		document.all.i19.value = hand_fee;	
		document.all.i20.value = hand_fee;
								
		document.all.oCustName.value = bp_name;
		document.all.oSmCode.value = sm_code;
		document.all.oSmName.value = sm_name;
		document.all.oModeCode.value = rate_code;
		document.all.oModeName.value = rate_name;
		document.all.oPrepayFee.value = prepay_fee;	
		document.all.oMarkPoint.value = "0";
		}
		else
		{
				rdShowMessageDialog("����:"+ retCode + "->" + retMsg,0);
				return;
		}    
  	} 

    if(vRetPage == "qryPayPrepay")
    {    
    var retCode = packet.data.findValueByName("retCode");
    var retMsg = packet.data.findValueByName("retMsg");

    var pay_pre        = packet.data.findValueByName("pay_pre"        );
							
		if(retCode == 000000)
		{
		document.all.oPayPre.value = pay_pre;
		}
		else
		{
				rdShowMessageDialog("����:"+ retCode + "->" + retMsg,0);
				return;
		}
     getbrand();
    }

    if(vRetPage == "qryAreaFlag")
    {    
    var retCode = packet.data.findValueByName("retCode");
    var retMsg = packet.data.findValueByName("retMsg");
    var area_flag        = packet.data.findValueByName("area_flag"        );

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
				rdShowMessageDialog("����:"+ retCode + "->" + retMsg,0);
				return;
		}
	}
	
	if(vRetPage == "querySmcode") //added by hanfa 20070116
	{
		var errCode = packet.data.findValueByName("errCode");
	    var errMsg = packet.data.findValueByName("errMsg");
		var m_smCode = packet.data.findValueByName("m_smCode");
		
		if(errCode == 000000)
		{
			document.all.m_smCode.value = m_smCode;			
		}else			
		{
			rdShowMessageDialog("����:"+ errCode + "->" + errMsg,0);
			return false;
		}  
	}   		
 }
  
  //--------2---------��֤��ťר�ú���-------------

      function checksmz()
  {

  var myPacket = new AJAXPacket("checkSMZ.jsp","���ڲ�ѯ�ͻ��Ƿ���ʵ���ƿͻ������Ժ�......");
	myPacket.data.add("PhoneNo",(document.frm.phoneNo.value).trim());
	core.ajax.sendPacket(myPacket,checkSMZValue);
	myPacket=null;
  }
  function checkSMZValue(packet) {
      document.all.smzvalue.value="";
			var smzvalue = packet.data.findValueByName("smzvalue");
      document.all.smzvalue.value=smzvalue;
}
  function frmCfm()
  {
  	var userCardCode = '<%=cardCode%>';
    if(!checkElement(document.frm.phoneNo)) return;
	  if(document.all.Gift_Code.value==""){
	  rdShowMessageDialog("������Ӫ������!");
      document.all.Gift_Code.focus();
	  return false;
	}
         if (document.all.i9.value == "Y")
         {
         	rdShowMessageDialog("���û��������û�,Ԥ������������ʱ�ջأ�");
         }
         
         //if(document.all.i9.value == "N" && parseFloat(document.all.oPayPre.value)<parseFloat(document.all.Prepay_Fee.value))
         //{
          // rdShowMessageDialog("���ν���Ԥ����,���ܰ���!");
           //return;
        // }
        
    //added and modified by hanfa 20070116 begin
    
  		if(document.all.oSmCode.value == "zn" && document.all.m_smCode.value == "gn")
  		{
  			//ѦӢ�� 20070716 R_HLJMob_cuisr_CRM_PD3_2007_226@���ڻ��������������������� zn->gn ���ֲ�����
  		}
  		else
  		{
	  		if((document.all.m_smCode.value !="") && (document.all.m_smCode.value != document.all.oSmCode.value))
	  		{
		  		if(document.all.oSmCode.value == "gn"){
		  			if((userCardCode == "01" || userCardCode == "02" || userCardCode == "03")){
			  			//rdShowMessageDialog("�ò����漰��Ʒ�Ʊ�����������л��֣���Mֵ������Ʒ�Ʊ����ЧʱʧЧ��������ʱ�һ�; ");
			  			rdShowMessageDialog("��ĿǰΪȫ��ͨVIP��Ա������Ʒ�ƣ�����VIP��Ա�ʸ���ҵ����Ч���Զ�ȡ����ͬʱ��������ȫ��ͨ�ͻ������ܲ���VIP������");
			  		}else{
			  			rdShowMessageDialog("��ȫ��ͨ�ͻ������ܲ���VIP������");
			  		}
		  		}else if(document.all.oSmCode.value == "dn"){
		  			//rdShowMessageDialog("�ò����漰��Ʒ�Ʊ�����������л��ֻ�Mֵ����Ʒ�Ʊ����ЧʱʧЧ�����������ʷ���Чǰ��ʱ�һ���");
		  		}

		  		if(document.all.oSmCode.value != "zn" && document.all.m_smCode.value=="zn" && document.all.oSmCode.value !="") {//
		  			checksmz();
		  			var smzvalues =document.all.smzvalue.value.trim();
		  			if(smzvalues=="3") {//��ʵ����ȫ��ͨ�����еش��ͻ�ת��Ϊ�����пͻ�
		  				rdShowMessageDialog("<%=readValue("2283","ps","jf",Readpaths)%>");
		  			}
		  		}
	  		}

  		}
	
	//added and modified by hanfa 20070116 end
		    frm.submit();
         
  }
   
 function judge_area()
 {
  var myPacket = new AJAXPacket("qryAreaFlag.jsp","���ڲ�ѯ�ͻ������Ժ�......");
	myPacket.data.add("orgCode",(document.all.orgCode.value).trim());
	myPacket.data.add("modeCode",(document.all.New_Mode_Code.value).trim());
	core.ajax.sendPacket(myPacket);
	myPacket = null; 
 }
 
 //-------------------
 function getInfo_code()
 { 
  	//���ù���js
  	var regionCode = "<%=regionCode%>";
    var pageTitle = "Ӫ������ѡ��";
    var fieldName = "��������|��������|����Ԥ��|�Ԥ��|�ۼ�����|��������|�µ���|�����ʷ�|��Ԥ��|��ע|";//����������ʾ���С����� 
    var sqlStr = "select gift_code,gift_name,base_fee,free_fee,mark_subtract,consume_term,mon_base_fee,mode_code,prepay_fee,note from  sBargainGiftCode where region_code='"+regionCode+"' and flag='0' and op_type='1' ";
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "10|0|1|2|3|4|5|6|7|8|9|";//�����ֶ�
    var retToField = "Gift_Code|Gift_Name|Base_Fee|Free_Fee|Mark_Subtract|Consume_Term|Mon_Base_Fee|New_Mode_Code|Prepay_Fee|New_Mode_Name|";//���ظ�ֵ����
    if(MySimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,50));

    document.frm.i1.value=document.frm.phoneNo.value;    
    document.frm.ip.value=document.frm.New_Mode_Code.value;
	document.all.do_note.value = "�û�"+document.all.phoneNo.value+"����ȫ��ͨǩԼ���񣬷������룺"+document.all.Gift_Code.value;    
	document.frm.iAddStr.value=document.frm.Gift_Code.value+"|"+document.frm.Prepay_Fee.value+"|"+
	                        document.frm.Base_Fee.value+"|"+document.frm.Free_Fee.value+"|"+
	                        document.frm.Mark_Subtract.value+"|"+document.frm.Consume_Term.value+"|"+
	                        document.frm.Mon_Base_Fee.value+"|"+document.frm.Gift_Name.value+"|";

    judge_area();      
    getMidPrompt("10442",codeChg(document.frm.New_Mode_Code.value),"ipTd")
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
function getFlagCode1()
	{
		document.all.commit.disabled=false;
		if (document.frm.back_flag_code.value == 2) 
		{
 	 	  document.all.flagCodeTextTd.style.display = "";
    	document.all.flagCodeTd.style.display = "";
	  }		
  }
	
function getFlagCode()
{ 
  	//���ù���js
    var pageTitle = "�ʷѲ�ѯ";
    var fieldName = "С������|С������|";//����������ʾ���С����� 
    /*var sqlStr ="select a.flag_code, a.flag_code_name,a.rate_code from sRateFlagCode a, sBillModeDetail b where a.region_code=b.region_code and a.rate_code=b.detail_code and b.detail_type='0' and a.region_code='" + document.frm.orgCode.value.substring(0,2) + "' and b.mode_code='" + document.frm.New_Mode_Code.value + "' order by a.flag_code" ;*/
    var sqlStr ="select a.flag_code, a.flag_code_name from sofferflagcode a, sregioncode b where a.group_id = b.group_id and b.region_code = '" + document.frm.orgCode.value.substring(0,2) + "' and a.offer_id = " + document.frm.New_Mode_Code.value;
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "0|1";//�����ֶ�
    var retToField = "flag_code|flag_code_name";//���ظ�ֵ����
    
    if(PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));
}

function MySimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,dialogWidth)
{
    var path = "<%=request.getContextPath()%>/npage/public/fPubSimpSel.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;  
    retInfo = window.showModalDialog(path,"","dialogWidth:"+dialogWidth);
    if(retInfo ==undefined)      
    {   return false;   }
    var chPos_field = retToField.indexOf("|");
    var chPos_retStr;
    var valueStr;
    var obj;
    while(chPos_field > -1)
    {
        obj = retToField.substring(0,chPos_field);
        chPos_retInfo = retInfo.indexOf("|");
        valueStr = retInfo.substring(0,chPos_retInfo);
        document.all(obj).value = valueStr;
        retToField = retToField.substring(chPos_field + 1);
        retInfo = retInfo.substring(chPos_retInfo + 1);
        chPos_field = retToField.indexOf("|");
    }
    
    //added by hanfa 20070116
    if(document.all.New_Mode_Code.value != "")
    {
    	querySmcode();
    } 
    
	return true;
}

function getbrand(){

	var myEle2 ;
   	var x2 ;
   	for (var q2=document.all.agent_code.options.length;q2>=0;q2--) document.all.agent_code.options[q2]=null;
   	
   	myEle2 = document.createElement("option") ;
    	myEle2.value = "";
        myEle2.text ="--��ѡ��--";
        document.all.agent_code.add(myEle2) ;
        for ( x2 = 0 ; x2 < arrbrandcode.length  ; x2++ )
   	{
      		if ( arrbrandmoney[x2] <=parseInt(document.all.oPayPre.value,10))
      		{
        		myEle2 = document.createElement("option") ;
        		myEle2.value = arrbrandcode[x2];
        		myEle2.text = arrbrandname[x2];
        		document.all.agent_code.add(myEle2) ;
      		}
   	}
	
}

  //������������ѯ�ʷѴ�����Ӧ��Ʒ�ƴ��� added by hanfa 20070116
  function querySmcode()
  {
	  var myPacket = new AJAXPacket("querySmcode_rpc.jsp","���ڻ����Ϣ�����Ժ�......");
	  myPacket.data.add("modeCode",(document.all.New_Mode_Code.value).trim());
	  core.ajax.sendPacket(myPacket);
	  myPacket = null;
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

//-->
</script>

</head>


<body>
	<form name="frm" method="post" action="f1270_3.jsp" onKeyUp="chgFocus(frm)">
<%@ include file="/npage/include/header.jsp" %>
<div class="title">
	<div id="title_zi">ҵ�����</div>
</div>
		<input name="oSmCode" type="hidden" class="button" id="oSmCode" value="<%=sm_code%>">
		<input name="oModeCode" type="hidden" class="button" id="oModeCode" value="<%=rate_code%>">
		<input type="hidden" name="back_flag_code" value="">
		<input type="hidden" name="loginAccept" value="<%=paraStr[0]%>">
		<!-- added by hanfa 20070116-->
  		<input type="hidden" name="m_smCode" value="">
	

	<table cellspacing="0" >
		<tr>
			<td class="blue">�ֻ�����</td>
            <td>
				<input class="InputGrey"  type="text" v_must="1" v_type="mobphone" v_must=1 name="phoneNo" value="<%=iPhoneNo%>" id="phoneNo" onBlur="if(this.value!=''){if(checkElement(this)==false){return false;}}" maxlength=11 index="3" readonly >
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
            <td>
				<input name="oPrepayFee" type="text" class="InputGrey" id="oPrepayFee" value="<%=prepay_fee%>" readonly>
			</td>
            <td class="blue">
            	��ǰ����
            </td>
            <td>
				<input name="oMarkPoint" type="text" class="InputGrey" id="oMarkPoint" value="<%=print_note%>" readonly>
			</td>            
		</tr>		
          <tr> 
         
            <td class="blue">��������</td>
            <td id="ipTd">
              <input  type="text" name="Gift_Code" id="Gift_Code" readonly>              
			  <input class="b_text" type="button" name="qryId_No" value="��ѯ" onClick="getInfo_code()" > 	  
              </select>
			  <font class="orange">*</font>
			</td>
            <td class="blue">
            	��Ʒ����
            </td>
            <td>
			<input name="Gift_Name" type="text" class="InputGrey" id="Gift_Name" v_type="string" v_must=1 value="" readonly>
			</td>      
          </tr>
	
		<tr>
			
			<td class="blue">
				����Ԥ��
			</td>
            <td>
				<input name="Base_Fee" type="text" class="InputGrey" id="Base_Fee" readonly>
			</td> 
			<td class="blue">
            	�Ԥ��
            </td>
            <td>
				<input name="Free_Fee" type="text" class="InputGrey" id="Free_Fee"   readonly>
			</td> 
		</tr>
		<tr> 
            
			<td class="blue">
				�ۼ�����
			</td>
            <td>
				<input name="Mark_Subtract" type="text" class="InputGrey" id="Mark_Subtract"   readonly> 
				<font class="orange">(�ۼ�����<0Ϊ���ͻ���)</font>
			</td>  
			 <td class="blue">
            	��������
            </td>
            <td>
            	<input name="Consume_Term" type="text" class="InputGrey" id="Consume_Term"   readonly>
			</td>           
		</tr>
		<tr> 
           
			<td class="blue">
				�µ���
			</td>
            <td>
				<input name="Mon_Base_Fee" type="text" class="InputGrey" id="Mon_Base_Fee" readonly>
			</td>  
            <td class="blue">
            	Ӧ�ս��
            </td>
            <td >
            	<input name="Prepay_Fee" type="text" class="InputGrey" id="Prepay_Fee"   readonly>
			</td>
		</tr>
		<tr> 
 			<td class="blue">
				�����ʷ�
			</td>
            <td colspan=3>
				<input name="New_Mode_Code" type="text" class="InputGrey" id="New_Mode_Code" value="" readonly>
			</td> 	          	          
		</tr>

		<tr> 
			<!-- dujl �޸�class="button" 20090428 -->
 			<td class="blue">
				��&nbsp;&nbsp;ע
			</td>
            <td colspan="4" >
				<input name="do_note" type="text" class="button" id="do_note" value="" size="60" maxlength="60" >
			</td> 	          
		</tr>
		  <tr id="flagCodeTr" style="display:none">
		    <TD  class="blue">С������</TD>
			  <TD >
				    <input class="InputGrey" type="hidden" size="17" name="rate_code" id="rate_code" readonly>
            <input type="text" class="InputGrey" name="flag_code" size="8" maxlength="10" readonly>
			      <input type="text" class="InputGrey" name="flag_code_name" size="18" readonly >&nbsp;&nbsp;
			      <input name="newFlagCodeQuery" type="button" class="b_text"  style="cursor:hand" onClick="getFlagCode()" value=ѡ��>
        </TD>
      </tr>
		<tr id="footer"> 
			<td colspan="4"> 
				<input name="commit" id="commit" type="button" class="b_foot"   value="��һ��" onClick="frmCfm();">
                <input name="reset" type="reset" class="b_foot" value="���" >
                <input name="close" onClick="history.go(-1)" type="button" class="b_foot" value="����">
			</td>
		</tr>
	</table>
<div name="licl" id="licl">
			<input type="hidden" name="iOpCode" value="2283">
			<input type="hidden" name="loginNo" value="<%=loginNo%>">
			<input type="hidden" name="orgCode" value="<%=orgCode%>">	
			<!--���²�����Ϊ��f1270_3.jsp������Ĳ���
			i2:�ͻ�ID
			i16:��ǰ���ײʹ���
			ip:�������ײʹ���
			belong_code:belong_code
			print_note:��������
			iAddStr:
			
			i1:�ֻ�����
			i4:�ͻ�����
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
			-->				
			<input type="hidden" name="i2" value="<%=cust_id%>">	                			
			<input type="hidden" name="i16" value="<%=rate_code%>">	
			<input type="hidden" name="ip" value="">				

			<input type="hidden" name="belong_code" value="<%=cust_belong_code%>">								
			<input type="hidden" name="print_note" value="<%=print_note%>">
			<input type="hidden" name="iAddStr" value="">

			<input type="hidden" name="i1" value="">
			<input type="hidden" name="i4" value="<%=bp_name%>">			
			<input type="hidden" name="i5" value="<%=bp_add%>">
			<input type="hidden" name="i6" value="<%=cardId_type%>">
			<input type="hidden" name="i7" value="<%=cardId_no%>">
			<input type="hidden" name="i8" value="<%=sm_code%>--<%=sm_name%>">			
			<input type="hidden" name="i9" value="<%=contract_flag%>">			

			<input type="hidden" name="ipassword" value="">
			<input type="hidden" name="group_type" value="<%=group_type_code%>--<%=group_type_name%>">
			<input type="hidden" name="ibig_cust" value="<%=bigCust_flag%>--<%=bigCust_name%>">
			<input type="hidden" name="favorcode" value="<%=favorcode%>">
			<input type="hidden" name="maincash_no" value="<%=rate_code%>">			
			<input type="hidden" name="imain_stream" value="<%=imain_stream%>">
			<input type="hidden" name="next_main_stream" value="<%=next_main_stream%>">
			
			<input type="hidden" name="i18" value="<%=next_rate_code%>--<%=next_rate_name%>">
			<input type="hidden" name="i19" value="<%=hand_fee%>">			
			<input type="hidden" name="i20" value="<%=hand_fee%>">
			<input type="hidden" name="cus_pass" value="<%=cus_pass%>">
			<input type="hidden" name="opName" value="<%=opName%>">	
			<input type="hidden" name="opCode" value="<%=opCode%>">		
			<input type="hidden" name="mode_type" value="">			
			<input type="hidden" name="New_Mode_Name" value="�����ʷ�����">
			<input type="hidden" name="return_page" value="/npage/bill/f2283_1.jsp">	
			<input type="hidden" name="smzvalue" >		
</div>
<%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>        