
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GB2312" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="/npage/bill/getMaxAccept.jsp" %>
<%
		System.out.println("-------hejwacustmain------------1------------->");
    String loginAccept = getMaxAccept();
    String workNo = (String) session.getAttribute("workNo");
    String workName = (String) session.getAttribute("workName");
    String orgCode = (String) session.getAttribute("orgCode");
    String regionCode = orgCode.substring(0, 2);
		String g_CustId = request.getParameter("gCustId");
		String loginNoPass = (String)session.getAttribute("password");
		String homeSData = request.getParameter("homeSData");//��ͥ�����ʷѴ�
		if(homeSData==null||homeSData.toLowerCase().equals("null")) homeSData = "";
    String gCustId = request.getParameter("gCustId");

    
    System.out.println("-------------hejwacustmain--------gCustId---------2-------------"+gCustId);
    String loginType = request.getParameter("loginType");
    String phone_no = request.getParameter("phone_no");
     
     System.out.println("----------hejwacustmain---00--------phone_no---------3-------------"+phone_no);   
    String custOrderId = request.getParameter("custOrderId");
		/* ningtn ��ͨ�����˺� */
    String broadPhone = request.getParameter("broadPhone");
    String openFlag = "";
    /* diling �Ƿ�Ϊ�ͷ�����*/
    String accountType = (String)session.getAttribute("accountType"); 
 
 	/*yanpx���� �Ƿ���1104Ȩ��*/
	 	ArrayList arrSession = (ArrayList)session.getAttribute("allArr");
	 	String[][] temfavStr=(String[][])arrSession.get(1);
	    String[] favStr=new String[temfavStr.length];
	    for(int i=0;i<favStr.length;i++)
	    {
	     favStr[i]=temfavStr[i][1].trim();
	    }
	    boolean pwrf=false;
	    if(WtcUtil.haveStr(favStr,"1104"))
	    {
			  pwrf=true;
			  System.out.println("WtcUtil.haveStr(favStr,1104) = "+WtcUtil.haveStr(favStr,"1104"));
			}
 	/*yanpx end*/   
 	/* ningtn �Ƿ���4977Ȩ�� */
	 	boolean pwrf4977=false;
	 	System.out.println(" === fav == temfavStr === " + temfavStr.length);
	  if(WtcUtil.haveStr(favStr,"4977"))
	  {
		  pwrf4977=true;
		  System.out.println("WtcUtil.haveStr(favStr,4977) = "+WtcUtil.haveStr(favStr,"4977"));
		  System.out.println("====fav====== pwrf4977 ========= " + pwrf4977);
		}
		System.out.println("=====fav===== pwrf4977 === 22 ====== " + pwrf4977);
 	/* ningtn �Ƿ���4977Ȩ�� end */
 	
 	/* liangyl �Ƿ���m462Ȩ�� */
	 	boolean pwrfm462=false; 
	 	System.out.println(" === fav == temfavStr === " + temfavStr.length);
	  if(WtcUtil.haveStr(favStr,"m462"))
	  {
		  pwrfm462=true;
		  System.out.println("WtcUtil.haveStr(favStr,m462) = "+WtcUtil.haveStr(favStr,"m462"));
		  System.out.println("====fav====== pwrfm462 ========= " + pwrfm462);
		}
		System.out.println("=====fav===== pwrfm462 === 22 ====== " + pwrfm462);
 	/* liangyl �Ƿ���m462Ȩ�� end */
 		
 		/* begin add ���ϻ��Ż�Ȩ�� for ���ڿ��������ն�CRMģʽAPP�ĺ� - �ڶ���@2015/3/11 */
 		String[][] v_temfavStr = (String[][])session.getAttribute("favInfo");
    String[] v_favStr = new String[v_temfavStr.length];
    boolean oldFav_a971 = false;
    for(int i = 0; i < v_favStr.length; i ++) {
    	v_favStr[i] = v_temfavStr[i][0].trim();
    }
    if (WtcUtil.haveStr(v_favStr, "a971")) {
    	oldFav_a971 = true;
    }
 		/* end add ���ϻ��Ż�Ȩ�� for ���ڿ��������ն�CRMģʽAPP�ĺ� - �ڶ���@2015/3/11 */
    /*  4603 4100 �õ� ʡ�ڿ������� ��Ҫ�Ĳ���    */
    String work_flow_no = ""; //4603  ������ 4100 ԭ�ֻ���
		String transJf      = ""; //4603 ת�ƻ��� 4100 ����
    String transXyd     = ""; //4603 ת�������� 4100 �������
    String level4100     = ""; //4100 �ͻ��ȼ�
		/*  4603 ��Ҫ�Ĳ���    */
		
		
    if(loginType.indexOf("open4603")!=-1){      //4603ʡ�ڿ�����������Ĳ���
			openFlag = loginType.split("��")[0];
			work_flow_no = loginType.split("��")[1];
			transJf = loginType.split("��")[2];
			transXyd = loginType.split("��")[3];
			loginType = "";  
		}else if(loginType.indexOf("open4100")!=-1){ //4100 ��������Ҫ����Ĳ���
			openFlag = loginType.split("��")[0];
			work_flow_no = loginType.split("��")[1];
			transJf = loginType.split("��")[2];
			transXyd = loginType.split("��")[3];
			level4100 = loginType.split("��")[4];
			loginType = "";  
		}
		
		
		/*
		System.out.println("-------mylog-------------openFlag--------------"+openFlag);
		System.out.println("-------mylog-------------work_flow_no----------"+work_flow_no);
		System.out.println("-------mylog-------------transJf---------------"+transJf);
		System.out.println("-------mylog-------------transXyd--------------"+transXyd);
		System.out.println("-------mylog-------------level4100-------------"+level4100);
		*/
		
    String retCode = "";
    String retMsg = "";
		String paramValue_zhaz="N";
    Map sessionMap = new HashMap();
    session.setAttribute(gCustId, sessionMap);
/*2013/07/04 8:43:08 gaopeng ��������д����*/    
    	String opCode = "1104";
    
		  if(openFlag.equals("open4100")){ 	
		  	opCode = "4100";  
		  }else if(openFlag.equals("open4603")){
		  	opCode = "4603";
		  }
    	
    System.out.println("-------mylog-------------opCode----------"+opCode);
    Map map = (Map)session.getAttribute("contactInfo");
    ContactInfo contactInfo = (ContactInfo) map.get(gCustId);
	  
	 //���Ӻ���������֤30������Ч�����ƣ�add by liubo
	 String dateStr=new java.text.SimpleDateFormat("yyyyMMddHHmmss", Locale.getDefault()).format(new java.util.Date());
    
    
    String Contact_id="";
    if(appCnttFlag!=null&&"Y".equals(appCnttFlag))
    {
	    Contact_id=contactInfo.getContact_id();  
	    System.out.println("Contact_id====="+Contact_id);
	  }
    
    Map InfoMap = (Map)session.getAttribute("contactInfoMap");
    Map relInfoMap = (Map)session.getAttribute("contactInfoRelation");   
    Map timeMap = (Map)session.getAttribute("contactTimeMap");  
%>
<!--ȡ�ͻ�������Ϣ-->
<%
	String bd0002_orgCode = (String)session.getAttribute("orgCode");
	String bd0002_regionCode = bd0002_orgCode.substring(0,2);
%>
<wtc:utype name="sQBasicInfo" id="retBd0002" scope="end"  routerKey="region" routerValue="<%=bd0002_regionCode%>">
     <wtc:uparam value="<%=gCustId%>" type="LONG"/>
</wtc:utype>
<%
String bd0002_retCode =retBd0002.getValue(0);
String bd0002_retMsg  =retBd0002.getValue(1);

String custName="";//�ͻ�����
String belongCity="";//��������
String custLevel="";//�ͻ�����
String linkmanName="";//��ϵ������
String bd0002_status="";//����״̬
String nationName = ""; //����
String agent_idType="";//֤������
String agent_idNo="";//֤������
String agent_phone="";//��ϵ�绰
String ba0002_black="";//������
String custLevelStar = "";//�Ǽ�
String custLevelStartTime = "";
String custLevelEndTime = "";

String ifUnitImpMember = "";
String ifABUnit = "";

String isJTCY="��";

%>
 <wtc:service name="sIsGrpQry" routerKey="region" routerValue="<%=bd0002_orgCode%>" retcode="jtinfo_retcode" retmsg="jtinfo_retMsg" outnum="6"> 
  <wtc:param value=""/>
  <wtc:param value="01"/>
  <wtc:param value="1500"/>
  <wtc:param value="<%=workNo%>"/>
  <wtc:param value="<%=loginNoPass%>"/>
  <wtc:param value="<%=phone_no%>"/>
  <wtc:param value=""/>
  </wtc:service>  
  <wtc:array id="jtinfoArry"  scope="end"/>
  	

<%
if("000000".equals(jtinfo_retcode)) {
  if(jtinfoArry.length>0) {
  		isJTCY=jtinfoArry[0][2];
  		
  		if("1".equals(isJTCY)) {
  			isJTCY="��";
  		}else if("0".equals(isJTCY)) {
  			isJTCY="��";
  		}
  }
}
else if("111111".equals(jtinfo_retcode)){
	%>
    <script language="javascript" type="text/javascript">
      rdShowMessageDialog("<%=jtinfo_retMsg%>",0);
      parent.parent.removeTab("custid"+"<%=gCustId%>");
    </script>
<%
}


		
if(bd0002_retCode.equals("0"))
{
	custName   =retBd0002.getValue("2.0");
	belongCity =retBd0002.getValue("2.1") == null ? "" : retBd0002.getValue("2.1");
	custLevel  =retBd0002.getValue("2.2");
	linkmanName=retBd0002.getValue("2.3");
	bd0002_status=retBd0002.getValue("2.4") == null ? "" : retBd0002.getValue("2.4");
	nationName =retBd0002.getValue("2.5");
	agent_idType =retBd0002.getValue("2.6");
	agent_idNo =retBd0002.getValue("2.7");
	agent_phone =retBd0002.getValue("2.8");
	ba0002_black =retBd0002.getValue("2.9");
	
}
if("1".equals(loginType)){
%>
 <wtc:service name="sGetCustLevel2" routerKey="region" routerValue="<%=bd0002_orgCode%>" retcode="bd0002_regionCode_custLevelStar" retmsg="bd0002_retMsg_custLevelStar" outnum="6"> 
  <wtc:param value="<%=loginAccept%>"/>
  <wtc:param value="01"/>
  <wtc:param value="1500"/>
  <wtc:param value="<%=workNo%>"/>
  <wtc:param value="<%=loginNoPass%>"/>
  <wtc:param value="<%=phone_no%>"/>
  <wtc:param value=""/>
  </wtc:service>  
  <wtc:array id="retbd0002_custLevelStar"  scope="end"/>
  	
<%
  
  if(bd0002_regionCode_custLevelStar.equals("000000") && retbd0002_custLevelStar.length > 0)
  {
  	custLevelStar = retbd0002_custLevelStar[0][1];
  	custLevelStartTime = retbd0002_custLevelStar[0][2];
   	custLevelEndTime = retbd0002_custLevelStar[0][3];
   	ifUnitImpMember = retbd0002_custLevelStar[0][5];
   	ifABUnit = retbd0002_custLevelStar[0][4];
    
  }else{
%>
    <script language="javascript" type="text/javascript">
      rdShowMessageDialog("������룺<%=bd0002_regionCode_custLevelStar%><br>������Ϣ��<%=bd0002_retMsg_custLevelStar%>",0);
    </script>
<%
  }
}
%>
<!--��ȡ�ͻ����� 20160307 liangyl-->
<wtc:service name="sCoventQry" routerKey="region" routerValue="<%=regionCode%>" retcode="coventQryRetCode" retmsg="coventQryRetMsg" outnum="9"> 
  <wtc:param value="<%=loginAccept%>"/>
  <wtc:param value="02"/>
  <wtc:param value=""/>
  <wtc:param value="<%=workNo%>"/>
  <wtc:param value="<%=loginNoPass%>"/>
  <wtc:param value="<%=phone_no%>"/>
  <wtc:param value=""/>
  </wtc:service>  
  <wtc:array id="CoventQryResult"  scope="end"/>
  	<%
  		String integral="0";
  	//	System.out.println("liangyouliang:-----"+coventQryRetCode);
  	//	System.out.println("liangyouliang:------"+CoventQryResult.length);
  //		for(int i=0;i<CoventQryResult[0].length;i++){
  	//		System.out.println("liangyouliang:"+CoventQryResult[0][i]);
  	//	}
  	if(coventQryRetCode.equals("000000") && CoventQryResult.length > 0){
	  	integral = CoventQryResult[0][7];
	  }
  	%>
  	
<!--ȡ�ͻ���Ʒ��Ϣ-->
<wtc:utype name="sCustOffer" id="retConsOffer" scope="end" routerKey="region" routerValue="<%=regionCode%>">
    <wtc:uparam value="<%=gCustId%>" type="LONG"/>
    <%
     if(loginType.equals("1") || "8".equals(loginType)){
    %>  
      <wtc:uparam value="<%=phone_no%>" type="STRING"/>
    <%
    }else{
    %>
     <wtc:uparam value="0" type="STRING"/>
    <%
    }
    %>
</wtc:utype>
<%
		/* ningtn ���ڿ���������ЭͬӪ����������ĺ� */
		
		
		/**
		*   hejwa add 2015-10-26 13:36:31
		*  �����Ż��������ҵ�������
		* 4���޸ġ���������ȡ��(e301)�����ܣ���������˺ſ�������2����Ȼ�£���������������ȡ����ʱ������ʾ��ϢΪ��
    * ����������ȡ��ʱ����ȡʣ��Ԥ���30%ΥԼ�𡱡�����10��20�տ�������ô12��1��0ʱ֮����㳬��2����Ȼ�¡�
    * ˵��������ϵͳ�п���2����Ȼ���ڲ���ȡΥԼ��2����Ȼ��֮�����ȡΥԼ���ˡ�
		*
		*/
		String e301_spCar_check     	= "0";
		String e301_spCar_check_sql 	= " select months_between(trunc(sysdate, 'MM'), trunc(a.bill_date, 'MM')) as result "+
																		"	  from dcustmsg a "+
																		"	 where a.phone_no = :phone_no ";
		String e301_spCar_check_param = "phone_no="+phone_no;
%>
  <wtc:service name="TlsPubSelCrm" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=e301_spCar_check_sql%>" />
		<wtc:param value="<%=e301_spCar_check_param%>" />
	</wtc:service>
	<wtc:array id="result_e301_spCar_check" scope="end"   />

<%
	if(result_e301_spCar_check.length>0){
		System.out.println("-----------hejwa-------result_e301_spCar_check[0][0]------------------->"+result_e301_spCar_check[0][0]);
		e301_spCar_check = result_e301_spCar_check[0][0];
	}
	
	System.out.println("-----------hejwa-------e301_spCar_check------------------->"+e301_spCar_check);
%>





<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
<title>���ﳵ</title>
<!-- <link href="<%=request.getContextPath()%>/nresources/default/css_sx/FormText.css" rel="stylesheet"type="text/css"> -->
<link href="<%=request.getContextPath()%>/nresources/<%=cssPath%>/css/products.css" rel="stylesheet"type="text/css">
<link href="/nresources/<%=cssPath%>/css/portal.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript" src="/njs/si/validate_class.js"></script>
<script language="javascript" type="text/javascript" src="/njs/extend/mztree/stTree.js"></script>
<style type="text/css">
        .pop-box {   
            z-index: 9999; /*�����ֵҪ�㹻�󣬲��ܹ���ʾ�����ϲ�*/  
            margin-bottom: 3px;   
            display: none;   
            position: absolute;   
            background: #99FFFF;   
            border:solid 1px #6e8bde;   
        }   
          
        .pop-box h4 {   
            color: #99FFFF;   
            cursor:default;   
            height: 18px;   
            font-size: 14px;   
            font-weight:bold;   
            text-align: left;   
            padding-left: 8px;   
            padding-top: 4px;   
            padding-bottom: 2px;   
            background: url("../images/header_bg.gif") repeat-x 0 0;   
        }   
          
        .pop-box-body {   
            clear: both;   
            margin: 4px;   
            padding: 2px;   
        } 
        
        
        .mask {   
            color:#C7EDCC;
            background-color:#DDDDDD;
            position:absolute;
            top:0px;
            left:0px;
            filter: Alpha(Opacity=60);
        } 
    </style>
<script language="javascript" type="text/javascript">
	var homeSData = "<%=homeSData%>";
	
$(document).ready(function(){
	if(homeSData!=""&&parent.orderFlag.value!="1"){//��ͥ���������Ʒ ���봮��ֱ��ȥ���ɶ����Ͷ�������
		custOrderCHome(homeSData);
	}
 
	if("1"==$("#isse276",window.parent.parent.document).val()){
		funCheck4977();
	}
 
});

function showsm468Init_val(m468Init_val){
	
	if(""!=m468Init_val){
		rdShowMessageDialog(m468Init_val);
	}
}

function show_sVolteQry_val(msg,flag_m286){
	
	if(""!=msg){
		var path = "show_sVolteQr_msg.jsp?msg="+msg+"&flag_m286="+flag_m286;
		var h=298;
   	var w=550;
   	var t=screen.availHeight/2-h/2;
   	var l=screen.availWidth/2-w/2;

		var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;  overflow-y:hidden; overflow-x:hidden;  toolbar:no; menubar:no; scrollbars:no; resizable:no;location:no;status:no;help:no";
		var ret=window.showModalDialog(path,"",prop);

		if(typeof(ret)!="undefined"){
			if("Y"==ret){
				show_sVolteQry_val_ret();
			}
		}

	}
 
}

function show_sVolteQry_val_ret(){
		parent.parent.openPage("2","m286","volte����","sm286/fm286Main.jsp","1");
}

/*
 * hejwa add 2014��2��12�� �������ƶ�Ӫ��ҵ����Դ����ϵͳ v3.0.0_����Ʒ������Ŀ
 * ֻ���ڶ���tab��ʹ�ã�ʹ�÷�����
 *		parent.document.getElementById("user_index").contentWindow.goTo_car_Func("g794","e280","&ACT_CLASS=64");
 * �ȵ��õ���ֻ��ź��������ж��Ƿ��Ѿ��ж������еĻ�ɾ��������g794֮�������һ������
 * newOpcode = Ҫ��ת�����ﳵ���ܵ�opcode
 * oldOpcode = Ҫ�رյ�opcode��Ҳ����ת������opcode
 * goCarParamf = ��������ת��һҳ��Ĳ�������ͬҵ�񴫵ݹ����ĸ�����Ҫ��ͬ�������� "&a=1" �� "&a=1&b=2"
 */

var goCarParam = ""; 
function goTo_car_Func(newOpcode,oldOpcode,goCarParamf){
	goCarParam = goCarParamf
	//alert("goTo_car_Func-->\nnewOpcode=["+newOpcode+"]\noldOpcode=["+oldOpcode+"]");
	//����չ��ﳵ
	clearCar();
	//�ҵ��ֻ��ŵ��У���������õ���ֻ����뺯��
	var prodListObj = document.getElementById("prodList_0");
	if(prodListObj!=null&&typeof(prodListObj)!="undefined"){
		prodListObj.click();
	}else{
		rdShowMessageDialog("�޿ͻ���Ʒ������Ϣ",0);
		return;
	}
	//�ж���û��newOpcode(g794)Ȩ�ޣ����õ��newOpcode(g794)����
	if(isContainMFunc(newOpcode)){
		document.getElementById("a_"+newOpcode).click();
		//��newOpcode(g794)�Ѿ����򿪣��ȹرշ������������ȥ����������Ҫ�޸�goNext������ƴ·������
		var newOpcodeTabObj = parent.document.getElementById(newOpcode);
		if(newOpcodeTabObj!=null&&typeof(newOpcodeTabObj)!="undefined"){
			//���ڼ��ر�
			parent.removeTab(newOpcode);
		}
		//��һ�������Ѿ����ûң��ָ������ſ��Ե���click����
		document.getElementById("nextBtn").disabled = false;
		//�����һ��
		document.getElementById("nextBtn").click();
		//�ص�ԭҳ��
		try{
			parent.removeTab(oldOpcode);
		}catch(e){
		}
	}else{
		rdShowMessageDialog("��"+newOpcode+"ģ��Ȩ��",0);
		return;
	}
}

/**
	hejwa add 2014��2��12��11:24:20
	�жϿͻ����������Ƿ����ĳopcode��Ӧ����
*/
function isContainMFunc(opCode){
	var retVal = false;
	$("#rootTree1 li").each(function(){
		var liId = $(this).attr("id");
		var opCodeLi = liId.substring(3,7);//id�ĸ�ʽ�̶�Ϊ li_1104������3-7λȡopcodeΪ1104
		if(opCodeLi==opCode){
			retVal = true;
			return false; //����eachѭ��
		}
	});
	//alert("retVal=["+retVal+"]");
	return retVal;
}


	function getMarketMsg(){
			var h=450;
			var w=600;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			var prop = "height="+h+"; width="+w+";top="+t+";left="+l+";toolbar=no; menubar=no; scrollbars=yes; resizable=no;location=no;status=no";
			var pageName="getMarket.jsp?phoneNo=<%=phone_no%>";
			var ret = window.open(pageName,'',prop);
	}
	function openSale(url){
		parent.parent.L("4","e177","Ӫ��ִ��",url,"0");
	}
//ȡ��ÿͻ��Ƽ���ҵ����Ϣ
function ini(phone_no) 
  {     	
		var packet = new AJAXPacket("getOper.jsp");
    packet.data.add("phone_no", phone_no);
    core.ajax.sendPacketHtml(packet, doGetOper, true);
    packet = null;	
  }	

function doGetOper(data)
{
    var insertOper=document.getElementById("insertOper");
    insertOper.innerHTML=data;
}
	
var initOpCode = "1104"	;
<%if(openFlag.equals("open4100")){%>
	initOpCode = "4100";
<%}else if(openFlag.equals("open4603")){%>
	initOpCode = "4603";
<%}%>
/*2013/07/04 8:50:50 gaopeng ִ����һ��*/
function goNext(custOrderId,custOrderNo,prtFlag)
{
	var packet = new AJAXPacket("/npage/portal/shoppingCar/sShowMainPlan.jsp");
	packet.data.add("custOrderId" ,custOrderId);
	packet.data.add("custOrderNo" ,custOrderNo);
	packet.data.add("prtFlag" ,prtFlag);
	core.ajax.sendPacket(packet,doNext);
	packet =null;
}
/*2013/07/04 8:51:13 gaopeng ִ����һ���ص�����*/
function doNext(packet)
{
    var retCode = packet.data.findValueByName("retCode"); 
	  var retMsg = packet.data.findValueByName("retMsg"); 
	  if(retCode=="0")
	  {
	  	var sData = packet.data.findValueByName("sData"); 
	  	parent.parent.$("#carNavigate").html(sData);
	  	var custOrderId = packet.data.findValueByName("custOrderId"); 
	  	var custOrderNo = packet.data.findValueByName("custOrderNo"); 
	  	var orderArrayId = packet.data.findValueByName("orderArrayId"); 
	  	var servOrderId = packet.data.findValueByName("servOrderId"); 
	  	var status = packet.data.findValueByName("status"); 
	  	var funciton_code = packet.data.findValueByName("funciton_code"); 
	  	var funciton_add = packet.data.findValueByName("funciton_add"); 
	  	var funciton_name = packet.data.findValueByName("funciton_name"); 
	  	var pageUrl = packet.data.findValueByName("pageUrl"); 
	  	var offerSrvId = packet.data.findValueByName("offerSrvId"); 
	  	var num = packet.data.findValueByName("num"); 
	  	var offerId = packet.data.findValueByName("offerId"); 
	  	var offerName = packet.data.findValueByName("offerName"); 
	  	var phoneNo = packet.data.findValueByName("phoneNo"); 
	  	var sitechPhoneNo = packet.data.findValueByName("sitechPhoneNo"); 
	  	var prtFlag = packet.data.findValueByName("prtFlag"); 
	  	var servBusiId = packet.data.findValueByName("servBusiId"); 
	  	var validVal = packet.data.findValueByName("validVal"); 
	  	var openWay = packet.data.findValueByName("openWay"); 
	  	var is0flag = packet.data.findValueByName("is0flag");
	  	var gundongyueFlag = packet.data.findValueByName("gundongyueFlag");
	  	//alert(is0flag);
	  	/*�����0Ԫ�����ʷ� ��ô�����g794Ӫ��ִ��һ�����������ʾ����*/
	  	if(is0flag == "yes"){
	  		var sData2 = getTableData("shoppingCarList", 2, 3);
	  		if(sData2.indexOf("4977") != -1){
	  			if(sData2.indexOf("g794") < 0){
		  			rdShowMessageDialog("������������ʱ����������������0Ԫ�����������ʷ�,����g794Ӫ��ִ��һͬ������",0);
		  			return false;
	  			}
	  		}
	  		
	  	}
	  	var gundongyueData = getTableData("shoppingCarList", 2, 3);
	  	if(gundongyueFlag=="1"&&gundongyueData.indexOf("g794")>0){
	  		rdShowMessageDialog("�����������°����ʷ�(����0Ԫ�����°���)��Ӫ����(g794)һ�����!",0);
  			return false;
	  	}
	  	
	  	var closeId=orderArrayId+servOrderId;
	  	//alert(funciton_code+"---functionCode?");
	  	if("<%=paramValue_zhaz%>" == "Y"){
		  	parent.parent.checkHasBill(funciton_code);
		  	if(parent.parent.hasBill == "N"){
			   		rdShowMessageDialog("������δ��������,���ܽ���ҵ�����!",0);
			   		//parent.parent.addTab(true,"r615","ӪҵԱ����ͳ�Ʊ���","../rpt_new/f1615.jsp");
			   		return false;
			   }
			   if(parent.parent.todayHasBill == "Y"){
			   		rdShowMessageDialog("�������Ѿ��������,���ܽ���ҵ�����!",0);
			   		return false;
			   }
	  	}
	  	if(closeId=="")
	  	{
	  		closeId= funciton_code;
	  	}
	  	/*2013/07/03 17:09:32 gaopeng ������ǵ����һ���İ�ť�ķ���*/
	  	var path=   pageUrl+"?gCustId=<%=g_CustId%>"
	  							+"&opCode="+funciton_code
	  						  +"&opName="+funciton_name
	  							+"&offerSrvId="+offerSrvId
	  							+"&num="+num
	  							+"&offerId="+offerId
	  							+"&offerName="+offerName
	  							+"&phoneNo="+phoneNo
	  							+"&sitechPhoneNo="+sitechPhoneNo
	  							+"&orderArrayId="+orderArrayId
	  							+"&custOrderId="+custOrderId
	  							+"&custOrderNo="+custOrderNo
	  							+"&servOrderId="+servOrderId
	  							+"&closeId="+funciton_code
	  							+"&servBusiId="+servBusiId
	  							+"&prtFlag="+prtFlag
	  							+"&work_flow_no=<%=work_flow_no%>"
	  							+"&transJf=<%=transJf%>"
	  							+"&transXyd=<%=transXyd%>"
	  							+"&level4100=<%=level4100%>"
	  							+"&opcodeadd="+funciton_add
	  							+goCarParam;//��̬���� hejwa add 2014��2��18��16:51:26
  	  	if(funciton_code=="1270"){
  	  	  var path = path + "&custLevelStar=<%=custLevelStar%>";
  	  	}
					if(initOpCode=="4100"||initOpCode=="4603"){
						 openWay = "2";                           //��ѯ����һ��table ���ﳵҪ��Ϊ����table
					}
				  parent.parent.L(openWay,funciton_code,funciton_name,path,validVal);
	 			
	  }else
	  {
	  		  rdShowMessageDialog("��������ʧ��!");
	  }
}
//�Ҳ� �ͻ����� 1104
function funCheck()
{ 
	
		if ($("#nextBtn")[0].custOrder != "")//����Ƕϵ�ָ��ģ����
    {
        clearCar();
        $("#nextBtn")[0].custOrder = "";
    }
		initOpCode = "1104";   
		//�ж��Ƿ���Խ���"���ϻ�"ҵ��
		var v_chkOldUserFlag = chkOldUserBusiness(initOpCode);
		if(!v_chkOldUserFlag){
			return false;
		}
    var pageName = "qryProductOfferComplex.jsp?opCode="+initOpCode;
    //var resultList = window.showModalDialog(pageName, window, "dialogWidth=840px;dialogHeight=600px;center=yes;status=yes");
   	window.open(pageName,'����Ʒѡ��','width=840px,height=600px,left=100,top=50,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no');
}
function funCheck4977(){
    if ($("#nextBtn")[0].custOrder != "")//����Ƕϵ�ָ��ģ����
    {
        clearCar();
        $("#nextBtn")[0].custOrder = "";
    }
    initOpCode = "4977";
    var pageName = "qryProductOfferComplex.jsp?opCode="+initOpCode+"&phoneNo=<%=activePhone%>";
    
    if("1"==$("#isse276",window.parent.parent.document).val()){
    	window.open(pageName,'����Ʒѡ��','width=1px,height=1px,left=9999,top=9999,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no');
	}
    else{
    	window.open(pageName,'����Ʒѡ��','width=840px,height=600px,left=100,top=50,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no');
    }
}
function funCheckm462(){
    if ($("#nextBtn")[0].custOrder != "")//����Ƕϵ�ָ��ģ����
    {
        clearCar();
        $("#nextBtn")[0].custOrder = "";
    }
    initOpCode = "m462";
    var pageName = "qryProductOfferComplex.jsp?opCode="+initOpCode+"&phoneNo=<%=activePhone%>&time=<%=new Date()%>";
    window.open(pageName,'����Ʒѡ��','width=840px,height=600px,left=100,top=50,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no');
}

function chkOldUserBusiness(initOpCode){
	var v_chkOldUserFlag = true;
	//�ж�����ͻ��Ƿ����¿����Ŀͻ�
	var isExitCustFlag = "N";
	var userIdType = "";
	var myPacket = new AJAXPacket("ajax_isExitForCust.jsp","���ڲ�ѯ��Ϣ�����Ժ�......");
  myPacket.data.add("g_CustId","<%=g_CustId%>"); 
  myPacket.data.add("opCode",initOpCode);
  core.ajax.sendPacket(myPacket,function(packet){
  	var retCode=packet.data.findValueByName("retCode");
	  var retMsg=packet.data.findValueByName("retMsg");
	  var v_isExitCustFlag=packet.data.findValueByName("isExitCustFlag"); //��ǰ�ͻ��£��û��Ƿ����
	  var v_userIdType=packet.data.findValueByName("userIdType"); //��ǰ�ͻ��£�����֤����
	  if(retCode == "000000"){
	  	isExitCustFlag = v_isExitCustFlag;
	  	userIdType = v_userIdType;
	 	}else{
	 		rdShowMessageDialog("��ѯ�˿ͻ��Ƿ�����û���Ϣʧ�ܣ��������:<%=retCode%><br>������Ϣ:<%=retMsg%>��",0);
	 		v_chkOldUserFlag = false;
			return  false;
	 	}
  });
  myPacket = null;
	if(isExitCustFlag == "Y"){//˵���ͻ��Ѵ����û�
		//1-�жϴ��û���ǰ֤�����ͣ��Ƿ�������֤
		if(userIdType == "0" || userIdType == "00"){ //����֤:���������֤�����ģ��Ͳ���������1104��ͨ������4977 ��������
			//rdShowMessageDialog("��ǰ�û�֤������Ϊ����֤�����������������Ͽͻ���ҵ�����½��ͻ���",1);
			//return  false;
		}else{ //2-�ж��Ƿ����Ż�Ȩ��
			var oldFav_a971 = <%=oldFav_a971%>;
			if(!oldFav_a971){ //��Ȩ�ޣ�����������
				rdShowMessageDialog("����û�в��Ͽͻ�Ȩ�ޣ����������������Ͽͻ���ҵ�����½��ͻ���",1);
				return  false;
			}else{//��Ȩ�ޣ�����Խ��в��ϻ�1104
				return true;
			}
		}
	}
	return v_chkOldUserFlag;
}  

function funCheckd535()
{
	  if ($("#nextBtn")[0].custOrder != "")//����Ƕϵ�ָ��ģ����
    {
        clearCar();
        $("#nextBtn")[0].custOrder = "";
    }
    initOpCode = "d535";
    var pageName = "qryProductOfferComplex.jsp?opCode="+initOpCode;
   	window.open(pageName,'����Ʒѡ��','width=840px,height=600px,left=100,top=50,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no');
}

function resultProcess(resultList,retOpCode){	 
    if (resultList != null)
    {
        var result1 = resultList.split("|");
        for (var n = 0; n < result1.length; n++)
        {
            var result2 = result1[n].split(",");
            var tabID = "shoppingCarList";
            var tabRowNum = document.getElementById(tabID).rows.length;
            var phoneNo = "";
            var idNo = ""; 										//�û�ID
            var opcode ;
            var offerId = result2[0];					//����Ʒ��ʶ
            var offerName = result2[1];				//����Ʒ����
            var offerType = result2[7];	      //����Ʒ���� 30��� 10����
            var servBusiId = result2[9];
            var offerInfoCode = result2[10];
            var offerInfoValue = result2[11];
            //alert("result2[0]|"+result2[0]+"\n"+"result2[1]|"+result2[1]+"\n"+"result2[2]|"+result2[2]+"\n"+"result2[3]|"+result2[3]+"\n"+"result2[4]|"+result2[4]+"\n"+"result2[5]|"+result2[5]+"\n"+"result2[6]|"+result2[6]+"\n"+"result2[7]|"+result2[7]+"\n"+"result2[8]|"+result2[8]+"\n"+"result2[9]|"+result2[9]+"\n"+"result2[10]|"+result2[10]+"\n"+"result2[11]|"+result2[11]);
            if (offerType == "30")//���
            {
                opcode = "q002";
            } else//��һ
            {
            	if(typeof(retOpCode) != "undefined"
            			&& retOpCode != "undefined"
            			&& retOpCode != "1104"){
            				opcode = retOpCode;
            	}else{
                opcode = initOpCode;
              }
            }
            var dealNum = "<input type='text' style='border:1px solid #666' onKeyUp=chkInt(this) onafterpaste=chkInt(this)  value='1' size='3'>&nbsp;";
            var delBut = "<input  type='button' value='ɾ��' class='b_text'   class='butDel' onclick='delTr()' id=''><span style='display:none'>N|" + idNo + "|" + offerId + "|" + opcode + "|" + servBusiId + "|" + offerInfoCode + "|" + offerInfoValue + "</span>&nbsp;";
            //alert("phoneNo|"+phoneNo+"\n"+"offerName|"+offerName+"\n"+"dealNum|"+dealNum+"\n"+"delBut|"+delBut);
            var arrTdCon = new Array(phoneNo, offerName, dealNum, delBut);
            
            
             if($("#shoppingCarList tr").length >1){
					    if(rdShowConfirmDialog("���Ѿ�ѡ����һ������Ʒ��Ҫ�滻���е�����Ʒô��") == 1){
					    		$("#shoppingCarList tr").eq(1).remove();
					    		addTr(tabID, "1", arrTdCon, "1");
					    	} 
					    }else{
					    	addTr(tabID, tabRowNum, arrTdCon, "1");
					    } 
            
         }
    }
}


function doGetProdSrv(data)
{
    if (data.trim() == "")
    {
      rdShowMessageDialog("û�в�Ʒ��Ϣ");
    } else {
       eval(data);
    }
}

//�ͻ�������
function drawCustServiceTree(phoneNo, idNo, prodId, offerId, brandId, flag, allSize,CustId)
{	
    for(var i=0;i<allSize;i++){
        if(flag == i){
            $("#prodList_"+i).addClass("orange");
        }else{
            $("#prodList_"+i).removeClass("orange");
        }
    }
    var packet = new AJAXPacket("getProdSrv.jsp");
    packet.data.add("prodId", prodId);
    packet.data.add("phoneNo", phoneNo);
    packet.data.add("idNo", idNo);
    packet.data.add("offerId", offerId);
    packet.data.add("brandId", brandId);
    packet.data.add("CustId", CustId);
    core.ajax.sendPacketHtml(packet, doGetProdSrv); //hejwa �޸�,֮ǰΪ�첽�е����⣬�޸�ΪĬ��ͬ�����������Ӳ���Ϊfalse
    packet = null;
    if('<%=loginType%>' != 1)
    {
    	ini(phoneNo);
    }
}

function chkInt(obj)
{
   obj.value = obj.value.replace(/\D/g, '')
}

function LK(opcode, functionName, phoneNo, idNo, servBusiId, offerId, brandId){
		
		
    if ($("#nextBtn")[0].custOrder != "")//����Ƕϵ�ָ��ģ����
    {
        clearCar();
        $("#nextBtn")[0].custOrder = "";
    }

    //�ж��Ƿ񻥳�
    var sData = getTableData("shoppingCarList", 2, 3);
    var packet = new AJAXPacket("chkProdSrvRel.jsp");
    packet.data.add("opcode", opcode);
    packet.data.add("functionName", functionName);
    packet.data.add("phoneNo", phoneNo);
    packet.data.add("idNo", idNo);
    packet.data.add("servBusiId", servBusiId);
    packet.data.add("sData", sData);
    packet.data.add("offerId", offerId);
    packet.data.add("brandId", brandId);
    packet.data.add("custId", '<%=gCustId%>');
    core.ajax.sendPacket(packet, doChkProdSrvRel);
    packet = null;
    
    
    
    if(opcode=="e301"&&"<%=e301_spCar_check%>"!="1"&&"<%=e301_spCar_check%>"!="0"){
    	rdShowMessageDialog("��������ȡ��ʱ����ȡʣ��Ԥ���30%ΥԼ��");
    }

}

//�ж��Ƿ񻥳�ص�
function doChkProdSrvRel(packet)
{
    var retCode = packet.data.findValueByName("retCode");
    var retMsg = packet.data.findValueByName("retMsg");
    var checkflag = packet.data.findValueByName("checkflag"); //��֤��ʶ
    var custAuthIdType = packet.data.findValueByName("CustIdType"); //��֤����
    var phoneNo = packet.data.findValueByName("phoneNo");
    var opcode = packet.data.findValueByName("opcode");
    var functionName = packet.data.findValueByName("functionName");
    var brandId = packet.data.findValueByName("brandId");
    var idNo = packet.data.findValueByName("idNo");
    var servBusiId = packet.data.findValueByName("servBusiId");
    var offerId = packet.data.findValueByName("offerId");
    var tabID = "shoppingCarList";
    var tabRowNum = document.getElementById(tabID).rows.length;

    if (retCode == "0")
    {
        var sizeFlag = packet.data.findValueByName("sizeFlag");

        if (parseInt(sizeFlag) > 0)
        {
            var prompt = packet.data.findValueByName("prompt");
            return false;
        } else {

           /* if (checkflag != "1")//��Ҫ��֤
            {
                var custAuthId = "";
                if (custAuthIdType == "0")//�ͻ�
                {
                    custAuthId = "<%=gCustId%>";
                } else if (custAuthIdType == "1")//�������
                {
                    custAuthId = phoneNo;
                }
                var str = "?brandId=" + brandId
                        + "&gCustId=<%=gCustId%>"
                        + "&custAuthId=" + custAuthId
                        + "&idNo=" + idNo
                        + "&offerId=" + offerId
                        + "&opCode=" + opcode
                        + "&opName=Ȩ����֤"
                        + "&servBusiId=" + servBusiId
                        + "&phoneNo=" + phoneNo
                        + "&functionName=" + functionName;

                var path = "sCustAuthQry.jsp" + str;
                openDivWin(path, 'Ȩ����֤', '500', '300');

            } else {//����Ҫ��֤ */
              insertCar(idNo, offerId, opcode, servBusiId, phoneNo, functionName);
            //}
        }
    } else if (retCode == "2")
    {
        rdShowMessageDialog("sessionʧЧ");
    } else
    {
        rdShowMessageDialog("[" + retCode + "]" + retMsg);
    }
}

function insertCar(idNo, offerId, opcode, servBusiId, phoneNo, functionName)
{
	  var packet = new AJAXPacket("checkOpCode.jsp");
	  		packet.data.add("idNo", idNo);
	  		packet.data.add("offerId", offerId);
        packet.data.add("opcode", opcode);
        packet.data.add("servBusiId", servBusiId);
        packet.data.add("phoneNo", phoneNo);
        packet.data.add("functionName", functionName);
        core.ajax.sendPacket(packet, doCheckOpCode);
        packet = null;
}

function doCheckOpCode(packet){
	var retCode = packet.data.findValueByName("retCode");
  var retMsg = packet.data.findValueByName("retMsg");
  
	if(retCode=="0"){
			var idNo = packet.data.findValueByName("idNo");
		  var offerId = packet.data.findValueByName("offerId");
		  var opcode = packet.data.findValueByName("opcode");
		  var servBusiId = packet.data.findValueByName("servBusiId");
		  var phoneNo = packet.data.findValueByName("phoneNo");
		  var functionName = packet.data.findValueByName("functionName");
		  
			var tabID = "shoppingCarList";
	    var tabRowNum = document.getElementById(tabID).rows.length;
	    var offerInfoCode = "";
	    var offerInfoValue = "";
	    var dealNum = "<input type='text' style='border:1px solid #FFF' name=test onKeyUp=chkInt(this) onafterpaste=chkInt(this) readonly value='1' size='3'>&nbsp;";
	    var delBut = "<input  type='button' value='ɾ��' class='b_text' onclick='delTr()' id=''><span style='display:none'>Y|" + idNo + "|" + offerId + "|" + opcode + "|" + servBusiId + "|" + offerInfoCode + "|" + offerInfoValue + "</span>&nbsp;";
	    var arrTdCon = new Array(phoneNo, functionName, dealNum, delBut);
	    addTr(tabID, tabRowNum, arrTdCon, 0|1);
		  
		}else{
			rdShowMessageDialog(retCode+":"+retMsg);
		}	
}
function custOrderCHome(sDataHome){
	var packet = new AJAXPacket("/npage/portal/shoppingCar/sCustOrderC.jsp");
        packet.data.add("sData", sDataHome);
        packet.data.add("optorMsg", sDataHome);
        packet.data.add("custId", "<%=gCustId%>");
        packet.data.add("prtFlagValue", 'N');
        core.ajax.sendPacket(packet, doCustOrderC);
        packet = null;
}	
function custOrderC()
{
		
		
    var sData = getTableData("shoppingCarList", 2, 3);
    var optorMsg = getOptorMsg();
     if (!checksubmit(frm)) return false;
		//��������Ϣδչ������ϵͳУ���ܲ������ã���Ҫ�ֹ�У�顣
    var agent_name = document.all.agent_name.value; 									//����������
    var agent_idNo = document.all.agent_idNo.value; 									//֤������
    var phone1 = document.all.agent_phone.value;
    var phone2 = document.all.ContactMobile.value;
    if (sData == "")
    {
        rdShowMessageDialog("��ѡ��ͻ�����");
        return false;
    }
    var prtFlag = document.all.prtFlag;
    var prtFlagValue = "";
    if (prtFlag[0].checked)
    {
        prtFlagValue = "Y";
    } else
    {
        prtFlagValue = "N";
    }
    if ($("#nextBtn")[0].custOrder == "")//��������
    {
    	//alert(660);
        var packet = new AJAXPacket("sCustOrderC.jsp");
        packet.data.add("sData", sData);
        packet.data.add("optorMsg", optorMsg);
        packet.data.add("custId", "<%=gCustId%>");
        packet.data.add("prtFlagValue", prtFlagValue);
        core.ajax.sendPacket(packet, doCustOrderC);
        packet = null;
    } else//�ɶ�����ֱ��next
    {
    		//alert(670);
        var custOrderId = $("#nextBtn")[0].custOrder;
        var custOrderNo = $("#nextBtn")[0].custOrder;
        goNext(custOrderId, custOrderNo, prtFlagValue);
        detBut();
    }
}

function getOptorMsg() {
    var agent_name = document.all.agent_name.value; 									//����������
    var agent_idType = document.all.agent_idType.value; 							//֤������
    var agent_idNo = document.all.agent_idNo.value; 									//֤������
    var agent_phone = document.all.agent_phone.value == "" ? " " : document.all.agent_phone.value;						  //��ϵ�绰
    var ContactMobile = document.all.ContactMobile.value == "" ? " " : document.all.ContactMobile.value;				//�ֻ�
    var zipcode = document.all.zipcode.value == "" ? " " : document.all.zipcode.value;													//��������
    var ContactUserAddr = document.all.ContactUserAddr.value == "" ? " " : document.all.ContactUserAddr.value;	//��ַ
    var ContactEmailAddress = document.all.ContactEmailAddress.value == "" ? " " : document.all.ContactEmailAddress.value;	//����
    var optorData = agent_name + "," + agent_idType + "," + agent_idNo + "," + agent_phone + "," + ContactMobile + "," + zipcode + "," + ContactUserAddr + "," + ContactEmailAddress;
    return optorData;
}
/*2013/07/04 8:49:56 gaopeng ��һ���������̻ص�����*/
function doCustOrderC(packet)
{
    var retCode = packet.data.findValueByName("retCode");
    var retMsg = packet.data.findValueByName("retMsg");
    if (retCode == "0")
    {
	    	if(homeSData!=""){
	    		// Ϊ��־��ֵ ���������ɹ� ʧ�ܵ������ͨ���鿴�������ָ�
	    		parent.orderFlag.value = "1";
	    	}
        var prtFlag = "";
        if (document.all.prtFlag[0].checked)
        {
            prtFlag = "Y";
        } else
        {
            prtFlag = "N";
        }
        var custOrderId = packet.data.findValueByName("custOrderId");
        var custOrderNo = packet.data.findValueByName("custOrderNo");
        
        goNext(custOrderId, custOrderNo, prtFlag);
        detBut();

    } else
    {
        rdShowMessageDialog("�����ͻ�����ʧ��!����ϵϵͳ����Ա!");
    }
}

function detBut()
{
    $(".butDel").remove(); //del butDel button
    $("#nextBtn")[0].disabled = true;
    $("#rootTree1").html("");
}
function getCustMore(obj)
{
    if (obj.flag == "1")
    {
        var oDiv = "<div class=blue><span style=font-size:10pt>���ڲ�ѯ����</span></div>";
        $(".moreCust").html(oDiv);
        var packet = new AJAXPacket("getCustMore.jsp");
        packet.data.add("custId", "<%=gCustId%>");
        core.ajax.sendPacketHtml(packet, doGetCustMore, true);
        packet = null;
        obj.flag = "2";
    } else
    {
        obj.src = "/nresources/default/images/icon_look1.gif";
        $(".moreCust").html("");
        obj.flag = "1";
    }
}

function doGetCustMore(data)
{
    $(".moreCust").html(data);
    $("#custMoreImg")[0].src = "/nresources/default/images/icon_look2.gif";
}

//���ɲ�Ʒ������
window.onload = function() {
    <%
      if("1".equals(loginType)&&!"".equals(custLevelStar)){
    %>
        $("#custLevelStarTr1").css("display","");
        $("#custLevelStarTr2").css("display","");
        //$("#custLevelStarTr3").css("display","");
    <%
      }
    %>
    if('<%=loginType%>' == 1){
        parent.parent.dnyCreatDiv("<%=g_CustId%>","<%=phone_no%>","<%=broadPhone%>");
        parent.parent.activateTab("custid"+"<%=g_CustId%>");
        ini('<%=phone_no%>');
    }else if('<%=loginType%>' == 8){
    		/* ѡ��ʹ����ͨ�������룬��ԭ��ʹ���ֻ����뷽ʽһ�� */
    		parent.parent.dnyCreatDiv("<%=g_CustId%>","<%=phone_no%>","<%=broadPhone%>");
        parent.parent.activateTab("custid"+"<%=g_CustId%>");
        ini('<%=phone_no%>');
    }else if('<%=loginType%>' == 10){
    		/* ��ͥ��������ԭ��ʹ���ֻ����뷽ʽһ�� */
    		parent.parent.dnyCreatDiv("<%=g_CustId%>","<%=phone_no%>","<%=broadPhone%>");
        parent.parent.activateTab("custid"+"<%=g_CustId%>");
        ini('<%=phone_no%>');
    }else{
        parent.parent.dnyCreatDiv("<%=g_CustId%>","index");
        parent.parent.activateTab("custid"+"<%=g_CustId%>");
    }
    var pwrf = "<%=pwrf%>";
    if(pwrf == "true"){
	    treeCS = new stdTree("treeCS", "rootTree1");
	    treeCS.imgSrc = "<%=request.getContextPath()%>/nresources/default/images/mztree/"
	    with (treeCS)
	    {
	         
	         if('<%=loginType%>' == 10){
         		N["g629"] = "g629"+";"+"g629"+"-��ͥ����;000;0;funCreFamily()";/*hejwa ���� ��ͥ����ҵ�� 2013��4��11��13:12:22 */
	         }else{
	         	N[initOpCode] = initOpCode+";"+initOpCode+"-��ͨ����;000;0;funCheck()";
	         }
	         /****N["4977"] = "4977"+";"+"4977"+"-��������;000;0;funCheck4977()";
	          �Ȱ�IMS�̻���������ڷ�ס
	         N["d535"] = "d535"+";"+"d535"+"-IMS�̻�����;000;0;funCheckd535()";
	         ****/
	    }
	    treeCS.writeTree();
	    treeCS = null;
	}
	var pwrf4977 = "<%=pwrf4977%>";
	    if(pwrf4977 == "true"){
	    treeCS = new stdTree("treeCS", "rootTree1");
	    treeCS.imgSrc = "<%=request.getContextPath()%>/nresources/default/images/mztree/"
	    with (treeCS)
	    {		
	    		if('<%=loginType%>' != 10){
	         N["4977"] = "4977"+";"+"4977"+"-��������;000;0;funCheck4977()";
	        }
	         /**** �Ȱ�IMS�̻���������ڷ�ס
	         N["d535"] = "d535"+";"+"d535"+"-IMS�̻�����;000;0;funCheckd535()";
	         ****/
	    }
	    treeCS.writeTree();
	    treeCS = null;
	}
    var pwrm462 = "<%=pwrfm462%>";
    if(pwrm462 == "true"){
	    treeCS = new stdTree("treeCS", "rootTree1");
	    treeCS.imgSrc = "<%=request.getContextPath()%>/nresources/default/images/mztree/"
	    with (treeCS)
	    {		
	    		if('<%=loginType%>' != 10){
	         N["m462"] = "m462"+";"+"m462"+"-IMS�̻�����;000;0;funCheckm462()";
	        }
	         /**** �Ȱ�IMS�̻���������ڷ�ס
	         N["d535"] = "d535"+";"+"d535"+"-IMS�̻�����;000;0;funCheckd535()";
	         ****/
	    }
	    treeCS.writeTree();
	    treeCS = null;
	}
    <%
    if(!custOrderId.equals("null"))
    {
  	%>
			getCarFirst("<%=custOrderId%>","<%=workNo%>");	//2011/8/19 wanghfa�޸�
  	<%
    }
    %>
    
    
    $('img.closeEl').bind('click', toggleContent);

    $('img.hideEl').bind('click', hideContent);
    
    
    $("#maingetAlert").attr("src","custMaingetAlert.jsp?phone_no=<%=phone_no%>&accountType=<%=accountType%>");
}
var custmsgFlag = "";
function ajaxGetDcustMsgByCustId(){
	var packet = new AJAXPacket("ajaxGetDcustMsgByCustId.jsp");
	    packet.data.add("g_CustId", "<%=g_CustId%>");
	    core.ajax.sendPacket(packet, doGetDcustMsgByCustId);
	    packet = null;
	return custmsgFlag ;
}
function doGetDcustMsgByCustId(packet){
	custmsgFlag = packet.data.findValueByName("custmsgFlag");
}

var g629_CT_HOMECUST_INFO_flag = "0";
function ajax_CT_HOMECUST_INFO(){
	var packet = new AJAXPacket("ajax_CT_HOMECUST_INFO.jsp");
	    packet.data.add("g_CustId", "<%=g_CustId%>");
	    core.ajax.sendPacket(packet, do_CT_HOMECUST_INFO);
	    packet = null;
	return g629_CT_HOMECUST_INFO_flag ;
}
function do_CT_HOMECUST_INFO(packet){
	g629_CT_HOMECUST_INFO_flag = packet.data.findValueByName("g629_CT_HOMECUST_INFO_flag");
}

function funCreFamily(){
		if(ajaxGetDcustMsgByCustId()!=""){
			rdShowMessageDialog("�˼�ͥ�ͻ����м�ͥ�û��������ٽ��м�ͥ�û�����");
			return;
		}
		
		
		if(ajax_CT_HOMECUST_INFO()!="0"&&ajax_CT_HOMECUST_INFO()!="1"){
			rdShowMessageDialog("һ���ֻ�����ֻ�ܰ���һ����ͥ�û���������");
			return;
		}
		
		
    if ($("#nextBtn")[0].custOrder != "")//����Ƕϵ�ָ��ģ����
    {
        clearCar();
        $("#nextBtn")[0].custOrder = "";
    }
    initOpCode = "g629";
    var pageName = "qryProductOfferComplex_family.jsp?opCode="+initOpCode;
   	window.open(pageName,'����Ʒѡ��','width=840px,height=600px,left=100,top=50,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no');
}
function getCarFirst(custOrderId,oldWorkNo)	//2011/8/19 wanghfa�޸�
{
	if(oldWorkNo!="<%=workNo%>")
	{
		rdShowMessageDialog("�˶���ֻ����"+oldWorkNo+"����");		
		return false;
	}
    $("#nextBtn")[0].custOrder = custOrderId;//��λ
    clearCar();//���

    var packet = new AJAXPacket("getCar.jsp");
    packet.data.add("custOrderId", custOrderId);
    core.ajax.sendPacketHtml(packet, doGetCar, true);
    packet = null;
}

//2011/6/21 wanghfa�޸ĶԹ��ŵ��ж�
var aCustOrderId = "";
function getCar(custOrderId,oldWorkNo) {
	aCustOrderId = custOrderId;
  var packet = new AJAXPacket("ajax_checkWorkNo.jsp");
  packet.data.add("workNo", "<%=workNo%>");
  packet.data.add("oldWorkNo", oldWorkNo);
  packet.data.add("phoneNo", "<%=phone_no%>");
  
  core.ajax.sendPacketHtml(packet, doCheckWorkNo, true);
  packet = null;
}

function doCheckWorkNo(data) {
	var retResult = data.trim();
	
	if (parseInt(retResult) == 0) {
		rdShowMessageDialog("�˶���������<%=workNo%>���������Ź���������ͣ�������ز�ͬ��", 1);
		return false;
	}
	
    $("#nextBtn")[0].custOrder = aCustOrderId;//��λ
    clearCar();//���

    var packet = new AJAXPacket("getCar.jsp");
    packet.data.add("custOrderId", aCustOrderId);
    core.ajax.sendPacketHtml(packet, doGetCar, true);
    packet = null;
}

function doGetCar(data)
{
    eval(data);
}

function clearCar()
{
    var otable = document.getElementById("shoppingCarList");
    var tabRowNum = otable.rows.length;
    var i = parseInt(tabRowNum) - 1;
    for (; i > 0; i--)
    {
        otable.deleteRow(i);
    }
}

function clearPage()
{
	  try{
			parent.delOtherTab("child_index");
		}catch(e){}
    parent.parent.$("#carNavigate").html("");
    window.location.reload();
}

var optorFlag = true;
function showOptor() {
    if (optorFlag) {
        document.getElementById("optor").style.display = "";
        document.all.agent_idType.value = document.all.idType_0002.value;
        optorFlag = false;
    } else {
        document.getElementById("optor").style.display = "none";
        optorFlag = true;
    }
}


function showDetailCar(orderId,serNo){
		var path = "showDetailCar.jsp?orderId="+orderId+"&serNo="+serNo;
    retInfo = window.showModalDialog(path,"","dialogWidth:60");
	}
	
function delTrOver()
{
	var e = arguments[0] || window.event;
	var cur = e.srcElement || e.target;
	var curTr=cur.parentNode.parentNode
	var curTable=cur.parentNode;
	while(curTable&&curTable.tagName!="TABLE")
	{
		curTable=curTable.parentNode;
	}
	var tabTds=curTr.getElementsByTagName("td");
	var arrTd=new Array();
	for(var i=0; i<tabTds.length;i++)
	{
		var curTd=tabTds[i].innerHTML
		arrTd.push(curTd);
	}
	curTable.getElementsByTagName('tbody')[0].removeChild(curTr);	
	
	var custArrOrderId=curTr.getElementsByTagName("input")[2].value;	
	var packet = new AJAXPacket("ajax_delTr.jsp");
  packet.data.add("custArrOrderId", custArrOrderId);
  core.ajax.sendPacket(packet, delTrProcess,true);
  packet = null;	
		
	return arrTd;
}	
	
function delTrProcess(packet){
	  var retCode = packet.data.findValueByName("retCode");
    var retMsg = packet.data.findValueByName("retMsg");
    if (retCode != "0")
    {
    	alert(retMsg);
	  }else{
	  	rdShowMessageDialog("ɾ����������ɹ���");	
	  	clearPage();  	
	  }
}	
//�Ƽ�ҵ����Ϣ
function nominateOper(phone_no,iCust_Type,vAction_Code,iCust_Type_code)
{
	if('<%=loginType%>' != 1)
	{
			var shopping_phoneno=document.getElementById("shopping_phoneno");
			shopping_phoneno.value=phone_no;
	}
	var packet = new AJAXPacket("ajax_addOper.jsp");
	packet.data.add("phone_no", phone_no);
  packet.data.add("iCust_Type", iCust_Type);
  packet.data.add("vAction_Code", vAction_Code);
  packet.data.add("iCust_Type_code", iCust_Type_code);
  core.ajax.sendPacket(packet, addOperProcess);
  packet = null;	
}

function addOperProcess(packet){
	  var retCode = packet.data.findValueByName("retCode");
    var retMsg = packet.data.findValueByName("retMsg");
    if (retCode != "000000")
    {
    	alert(retMsg);
	  }else{
	  	rdShowMessageDialog("�Ƽ�ҵ��ɹ���");	
	    if('<%=loginType%>' == 1)
	    {
  			ini('<%=phone_no%>');
  	  }
  	  else
			{
				var shopping_phoneno=document.getElementById("shopping_phoneno");
				phone_no=shopping_phoneno.value;
				ini(phone_no);
  	 	}
	  }
}	


 function popupDiv(div_id) { 
 				  
        var div_obj = $("#"+div_id);  
        var windowWidth = document.body.clientWidth;       
        var windowHeight = document.body.clientHeight;  
        var popupHeight = div_obj.height();       
        var popupWidth = div_obj.width();    
        //���Ӳ���ʾ���ֲ�   
        $("<div id='mask'></div>").addClass("mask")   
                                  .width(windowWidth + document.body.scrollWidth)   
                                  .height(windowHeight + document.body.scrollHeight)   
                                  .click(function() {})   
                                  .appendTo("body")   
                                  .fadeIn(200);   
        div_obj.css({"position": "absolute"})   
               .animate({left: windowWidth/2-popupWidth/2,    
                         top: 80, opacity: "show" }, "slow");   
                        
    }   
      
    function hideDiv(div_id) {   
        $("#mask").remove();   
        $("#" + div_id).animate({left: 0, top: 0, opacity: "hide" }, "slow");   
    }  
    
     function iFrameHeight() {

        var ifm= document.getElementById("iframepage");

        var subWeb = document.frames ? document.frames["iframepage"].document :ifm.contentDocument;

            if(ifm != null && subWeb != null) {

            ifm.height = subWeb.body.scrollHeight;

            }

    }


 
</script>
</head>

<body>
<form method="post" name="frm">
	<input type="hidden" id="shopping_phoneno"/>
  <div id="Operation_Table">
		<div class="title">
		   <div id="title_zi">������Ϣ&&<a href="#" onclick="showOptor()">��������Ϣ</a></div>
		  <!--div id="title_zi"><img src="/nresources/default/images_sx/form_th_icon1.gif"/>�ͻ���Ϣ</div-->

		</div>
    <div class="but_look">
        <img id="custMoreImg" src="/nresources/default/images/icon_look1.gif" flag="1" onclick="getCustMore(this)"/>
    </div>
            <div class="input">
             	<table cellspacing="0">
             		
             		<!-- hejwa 2015-6-1 14:55:38 -->
             		<!-- ���ڲ���BOSS�������ӿͻ��Ƿ�Ϊ4G��չ�����ݵĺ� -->
             		<!-- ����֮ǰ��custLevelStarTr custLevelStarTr2 custLevelStarTr3�߼�һ�������Ժϳ�3�е��� -->
<%
	/**
	 * ��ѯ�ֻ����Ƿ�Ϊ4G���û�
	 */
	 
	 String is_4G_sql       = "select to_char(count(*))  as is_4G_card   from dcustmsg a where a.phone_no =:phone_no   and a.service_type = '70' ";
	 String is_4G_sql_param = "phone_no="+phone_no;
	 
%>             		
  <wtc:service name="TlsPubSelCrm" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=is_4G_sql%>" />
		<wtc:param value="<%=is_4G_sql_param%>" />
	</wtc:service>
	<wtc:array id="result_is4G" scope="end"/>
		
<%

	
	String phone_no_is4G = "";
	if(result_is4G.length>0){
		if("0".equals(result_is4G[0][0])){//û�鵽��4G��
			phone_no_is4G = "��";
		}else{
			phone_no_is4G = "��";
		}
	}
	
%>		

             		<tr>
             			<td  class=blue>����</td>
             			<td><%=nationName%></td> 
             			<td  class=blue>��������</td>
             			<td>
             			    <%=belongCity%>
             				<input type="hidden" name="custNameforsQ046" value="<%=custName%>">
             				<%
             				if(ba0002_black.equals("N"))
             				{
             				}else
             				{
          				%>
          					<script>
          						rdShowMessageDialog("�ÿͻ����ں������ͻ�");
          					</script>
          				<%
             				}
             				%>
             			</td>
             		
             			<td  class=blue>�ͻ����� </td>
             			<td ><%=custLevel%></td> 
             			
             		</tr>
             	  
             	  <tr id="custLevelStarTr1" style="display:none">
             			<td  class=blue>�ͻ��ȼ� </td>
             			<td ><%=custLevelStar%></td> 
             			<td  class="blue">�Ǽ���ʼʱ�� </td>
             			<td ><%=custLevelStartTime%></td> 
             			<td  class="blue">�Ǽ�����ʱ�� </td>
             			<td ><%=custLevelEndTime%></td> 
             	  </tr>
             	  <tr id="custLevelStarTr2" style="display:none">
             			<td  class="blue">�Ƿ�����Ҫ��Ա </td>
             			<td ><%if("1".equals(ifUnitImpMember)){out.print("��");}else{out.print("��");}%></td> 
             			<td  class="blue">�Ƿ�AB�༯�� </td>
             			<td ><%if("1".equals(ifABUnit)){out.print("��");}else{out.print("��");}%></td> 
             			<% //System.out.println("liangyouliang:-"+"");
             			
             			int retSize = retConsOffer.getUtype("2").getSize();
             			
             		//	System.out.println("liangyouliang:-"+"retSize=="+retSize);
             			String retrunCode=String.valueOf(retConsOffer.getValue(0));		
             			if("0".equals(retrunCode) && retSize>0){
             				String retConsOfferSmName = WtcUtil.repNull(retConsOffer.getValue("2.0.14"));
             			%>
	             			<td class="blue"><%if("���еش�".equals(retConsOfferSmName)||"������".equals(retConsOfferSmName)||"ȫ��ͨ".equals(retConsOfferSmName)){
	             				%>�ɶһ�������<%
	             			}%></td>
	             			<td><%if("���еش�".equals(retConsOfferSmName)||"������".equals(retConsOfferSmName)||"ȫ��ͨ".equals(retConsOfferSmName)){
	             				%><%=integral%><%
	             			}%>&nbsp;</td>
             			<%}else{%>
             				<td class="blue"></td>
	             			<td></td>
             			<%}%>
             			
             	  </tr>
             	  <tr>
             	  	<td  class="blue">����״̬</td>
             			<td><%=bd0002_status%></td>   
             			<td class="blue">�Ƿ���4G���ͻ�</td>
             			<td><%=phone_no_is4G%></td>
             			<td class="blue">�Ƿ��ų�Ա</td>
             			<td><%=isJTCY%></td>
             	  </tr>
             	  <tr>
             	  	<input type="hidden" name="idType_0002" value="<%=agent_idType%>"/>
             	  </tr>
          	</table>
          </div>
            <div id="items" class="moreCust"></div>

            <div id="optor" style="display:none">

						<div class="title">
							<div id="title_zi">������</div>
						</div>

                    <table cellspacing=0>
                        <tr>
                            <td class="blue">����������</td>
                            <td>
                                <input type="text" name="agent_name" class="required" value=""/>
                                <input type="hidden" name="agent_name_hide" class="required" value="<%=linkmanName%>"/>
                            </td>
                            <script>
                            	if(document.all.agent_name.value==""){
                            			//document.all.agent_name.value = "<%=custName%>";
                            	}
                            </script>
                            <td class="blue">֤������</td>
                            <td>
                                <select name="agent_idType" class="required" onChange="change_idType(this,document.getElementById('agent_idNo'),document.getElementById('agent_len_text'))">
                                  <wtc:pubselect name="sPubSelect" outnum="3" retcode="ret" retmsg="retm" routerKey="region" routerValue="<%=regionCode%>">
                                      <wtc:sql>select trim(ID_TYPE),ID_NAME,ID_LENGTH from sIdType order by id_type</wtc:sql>
                                  </wtc:pubselect>
                                  <wtc:iter id="rowsjingban" indexId="i">
                                        <%if (rowsjingban[0].equals("2")) {%>
                                        <option selected="selected"
                                                value=<%=rowsjingban[0]%> v_ID_length=<%=rowsjingban[2]%>><%=rowsjingban[1]%>
                                        </option>
                                        <%} else {%>
                                        <option value=<%=rowsjingban[0]%> v_ID_length=<%=rowsjingban[2]%>><%=rowsjingban[1]%>
                                        </option>
                                        <%}%>
                                  </wtc:iter>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="blue">֤������</td>
                            <td>
                                <input type="text" name="agent_idNo" class="required idCard" v_minlength="18" v_maxlength="18"
                                       maxLength="18" id="agent_idNo" value=""/>
                                <input type="hidden" name="agent_idNo_hide" id="agent_idNo_hide" value="<%=agent_idNo%>"/>
                                <input type="text" name="agent_len_text" id="agent_len_text" value=""
                                       style="background:none;border:none" readonly>
                            </td>

                            <td class="blue">��ϵ�绰</td>
                            <td>
                                <input type="text" name="agent_phone" class="andCellphone" value="<%=agent_phone%>"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="blue">�ֻ�</td>
                            <td>
                                <input type="text" name="ContactMobile" class="andCellphone"/>
                            </td>
                            <td class="blue">��������</td>
                            <td>
                                <input type="text" name="zipcode" id="zipcode" class=""/>
                            </td>
                        </tr>
                        <tr>
                            <td class="blue">��ַ</td>
                            <td>
                                <input type="text" name="ContactUserAddr" class=""/>
                            </td>
                            <td class="blue">����</td>
                            <td>
                                <input type="text" name="ContactEmailAddress" class=""/>
                            </td>
                        </tr>
                    </table>
            </div>


            <!--div id="oper_title"><img src="/nresources/default/images_sx/form_th_icon1.gif"/>��Ʒ������Ϣ</div-->

            <div id="items">
                <div class="item-col col-1">
                    <div class="title">
                    	<div id="title_zi">��Ʒ������Ϣ</div>
                    </div>

                    <div class="list" style="height:100px; overflow-y:auto; overflow-x:hidden;_width:100%;">
                        <table cellspacing="0" id="customerInfo">
                            <tr>
                            	<th>ҵ�����</th>
                                <th>����Ʒ����</th>
                                <th>��������Ʒ����</th>
                                <th>����ƷƷ������</th>
                                <th>״̬</th>
                            </tr>
                            <%
                                retCode = retConsOffer.getValue(0);
                                if (retCode.equals("0")) {
                                    int xsize = retConsOffer.getSize("2");
                                    String[] phoneArr=new String[xsize];
                                    System.out.println("custMain.jsp �ͻ���������  xsize==="+xsize);
                                    for (int i = 0; i < xsize; i++) {
	                                    String phoneNO = retConsOffer.getValue("2." + i + ".21");
	                                    String offerName = retConsOffer.getValue("2." + i + ".8");
	                                    String offerNameShow = offerName;
	                                    
	                                    if(InfoMap.get(phoneNO)==null){
			                                    ContactInfo cInfo = new ContactInfo();
																			    cInfo.setPhoneno(phoneNO);
																			    if(appCnttFlag!=null&&"Y".equals(appCnttFlag))
                                          {
																			    	cInfo.setContact_id(Contact_id);																			    
																			    }
																			    InfoMap.put(phoneNO, cInfo);
																			    timeMap.put(phoneNO,dateStr);
			                                    phoneArr[i]=phoneNO;
	                                    }
	                                    
	                                    if(offerName.length()>10)
	                                    {
	                                    	 offerNameShow = offerName.substring(0,10)+"...";
	                                    }
	                                    if(loginType.equals("1")&&phoneNO.equals(phone_no))
	                                    {
	                                    
	                                    System.out.println("------------gaopengSeeLog---mylog----------------------1");
	                                    	 %>
							                            <tr id='prodList_<%=i%>'  style="cursor:pointer" onclick="drawCustServiceTree('<%=retConsOffer.getValue("2."+i+".21")%>','<%=retConsOffer.getValue("2."+i+".0")%>','<%=retConsOffer.getValue("2."+i+".1")%>','<%=retConsOffer.getValue("2."+i+".6")%>','<%=retConsOffer.getValue("2."+i+".13")%>','<%=i%>','<%=xsize%>','<%=g_CustId%>');reloadPhoneNo('<%=retConsOffer.getValue("2."+i+".21")%>');">
							                            	<td><%=retConsOffer.getValue("2." + i + ".21")%>&nbsp; </td>
							                                <td ><%=retConsOffer.getValue("2." + i + ".2")%> &nbsp;</td>
							                                <td nowrap title="<%=offerName%>"><%=offerNameShow%> &nbsp;</td>
							                                <td><%=retConsOffer.getValue("2." + i + ".14")%> &nbsp;</td>
							                                <td nowrap ><%=retConsOffer.getValue("2." + i + ".22")%>&nbsp;&nbsp;&nbsp;&nbsp;</td>
							                            </tr>
							                            <%
							                         break;
	                                    }
                                    }
                                    relInfoMap.put(gCustId,phoneArr);  
                                    
			                             for (int i = 0; i < xsize; i++) {
			                             		String phoneNO = retConsOffer.getValue("2." + i + ".21");
			                             		String offerName = retConsOffer.getValue("2." + i + ".8");
	                                    String offerNameShow = offerName;
	                                    if(offerName.length()>10)
	                                    {
	                                    	 offerNameShow = offerName.substring(0,10)+"...";
	                                    }
	                                    if((loginType.equals("1")&&!phoneNO.equals(phone_no))||!loginType.equals("1"))
	                                    {
	                                    System.out.println("-------------gaopengSeeLog--mylog----------------------2");
			                            %>
			                            <tr id='prodList_<%=i%>' style="cursor:pointer" onclick="drawCustServiceTree('<%=retConsOffer.getValue("2."+i+".21")%>','<%=retConsOffer.getValue("2."+i+".0")%>','<%=retConsOffer.getValue("2."+i+".1")%>','<%=retConsOffer.getValue("2."+i+".6")%>','<%=retConsOffer.getValue("2."+i+".13")%>','<%=i%>','<%=xsize%>','<%=g_CustId%>');reloadPhoneNo('<%=retConsOffer.getValue("2."+i+".21")%>');">
			                            		<td><%=retConsOffer.getValue("2." + i + ".21")%>&nbsp;</td>
			                                <td   style="display:none"><%=retConsOffer.getValue("2." + i + ".1")%> &nbsp;</td>
			                                <td><%=retConsOffer.getValue("2." + i + ".2")%> &nbsp;</td>
			                               
			                                <td><%=retConsOffer.getValue("2." + i + ".14")%> &nbsp;</td>
			                                <td nowrap ><%=retConsOffer.getValue("2." + i + ".22")%>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			                            </tr>
			                            <%
			                            		}
			                              }
                                }
                              else{
                              	
                              	 %>
                              	 <script language="javascript" type="text/javascript">
                              	  rdShowMessageDialog("ȡ�ͻ���Ϣʧ�ܣ�");
                              	 </script>
                              	<%
                              	}
                              	
                              	                                 
										     System.out.println(map); 	
										     System.out.println(InfoMap); 	
										     System.out.println(relInfoMap); 	 	
                            %>
                        </table>
                    </div>

                    <div class="title">
                    	<div id="title_zi">���ﳵ</div>
                    </div>

                    <div class="list">
                        <table cellspacing="0" id="shoppingCarList" style="border-collapse:collapse">
                            <tr>
                                <th>ҵ�����</th>
                                <th>��Ʒ����</th>
                                <th>��������</th>
                                <th>����</th>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="item-row col-2" style="width:26%;height:100%;overflow-y:no;overflow-x:no;">
                    <div class="title">
                    	<div id="title_zi">�ͻ�����</div>
                    </div>
                    <div id="rootTree1"></div>
                </div>
            </div>
        </div>
        <div id='pop-div' style="overflow-y:auto; overflow-x:auto; width:600px; height:500px;" class="pop-box">  
				    <iframe id="iframepage" style="width:100%;height:100%;"  align="center"  style="overflow-y:auto; overflow-x:auto;" id="win" name="win" frameborder="0" scrolling="no" src="/npage/portal/shoppingCar/getMarket.jsp?phoneNo=<%=phone_no%>" onload="this.height=0;var fdh=(this.Document?this.Document.body.scrollHeight:this.contentDocument.body.offsetHeight);this.height=(fdh>400?fdh:400)"></iframe>
				</div>
				<!--<input type=button id=btnTest  value='test' onclick="popupDiv('pop-div');"/>-->
				</div>
				<div id="insertOper">
				</div>
					
        <div id="footer" style="width: 98%;margin-left: 10px;">
            <div class="font12" style="width:40%;float:left;">
                <div style="display:none">
                <input type="radio" name="prtFlag" id="prtFlag" value="Y" checked="checked"/>�ϴ�
                <input type="radio" name="prtFlag" id="prtFlag" value="N"/>�ִ�
              </div>
            </div>
            <div style="float:left;text-align:left;">
                <input type="button" class="b_foot" value="��һ��" id="nextBtn" custOrder="" onclick="custOrderC()"/>
                <input type="button" class="b_foot" value="����" id="nextBtn" custOrder="" onclick="clearPage();"/>
            </div>
        </div>
        <input type="hidden" name="blindAddCombo" id="blindAddCombo" value=""/>
        <input type="hidden" id="phone_no_source" name="phone_no_source" value="<%=activePhone%>" />
        <%@ include file="/npage/include/footer_simple.jsp" %>
    </form>
    
<div id="page-warp">
    <div id="more-info-items">
    	<div class="item">
	        <div class="item-col col-1">
	            <div class="item">
	            	<div class="caption">
	            		<div class="text">�ط���ͨ</div>
	            		<div class="option">
	                        <div class="sub">
	                            <DIV class="li"><img id="div1_switch" class="closeEl" src="/nresources/<%=cssPath%>/images/jia.gif" style='cursor:hand' width="15" height="15"></DIV>
	                            <DIV><img class="hideEl" src="/nresources/<%=cssPath%>/images/cha.gif"   style='cursor:hand' width="15" height="15"></DIV>
	                        </div>
	            		</div>
	            	</div>
	            	<div class="content">
	            	    <DIV class="itemContent" id="mydiv1">
	            			<DIV id="wait1"><img src="/nresources/<%=cssPath%>/images/blue-loading.gif"  width="32" height="32"></DIV>
	            		</DIV>
	            	</div>
	            </div>
	        </div>
	        <div class="item-col col-2">
	            <div class="item">
	            	<div class="caption">
	            		<div class="text">��Դռ��</div>
	            		<div class="option">
	                        <div class="sub">
	                            <DIV class="li"><img id="div2_switch" class="closeEl" src="/nresources/<%=cssPath%>/images/jia.gif" style='cursor:hand' width="15" height="15"></DIV>
	                            <DIV><img class="hideEl" src="/nresources/<%=cssPath%>/images/cha.gif"   style='cursor:hand' width="15" height="15"></DIV>
	                        </div>
	            		</div>
	            	</div>
	            	<div class="content">
	            	    <DIV class="itemContent" id="mydiv2">
	            			<DIV id="wait2"><img src="/nresources/<%=cssPath%>/images/blue-loading.gif"  width="32" height="32"></DIV>
	            		</DIV>
	            	</div>
	            </div>
	        </div>
		</div>
    	<div class="item">		
		    <div class="item-col col-1">
		        <div class="item">
		        	<div class="caption">
		        		<div class="text">��ѡ�ʷ���Ϣ</div>
		        		<div class="option">
		                    <div class="sub">
		                        <DIV class="li"><img id="div3_switch" class="closeEl" src="/nresources/<%=cssPath%>/images/jia.gif" style='cursor:hand' width="15" height="15"></DIV>
		                        <DIV><img class="hideEl" src="/nresources/<%=cssPath%>/images/cha.gif"   style='cursor:hand' width="15" height="15"></DIV>
		                    </div>
		        		</div>
		        	</div>
		        	<div class="content">
		        	    <DIV class="itemContent" id="mydiv3">
		        			<DIV id="wait3"><img src="/nresources/<%=cssPath%>/images/blue-loading.gif"  width="32" height="32"></DIV>
		        		</DIV>
		        	</div>
		        </div>
		    </div>
		    
		    	        <div class="item-col col-2">
	            <div class="item">
	            	<div class="caption">
	            		<div class="text">�û�����</div>
	            		<div class="option">
	                        <div class="sub">
	                            <DIV class="li"><img id="div4_switch" class="closeEl" src="/nresources/<%=cssPath%>/images/jia.gif" style='cursor:hand' width="15" height="15"></DIV>
	                            <DIV><img class="hideEl" src="/nresources/<%=cssPath%>/images/cha.gif"   style='cursor:hand' width="15" height="15"></DIV>
	                        </div>
	            		</div>
	            	</div>
	            	<div class="content">
	            	    <DIV class="itemContent" id="mydiv4">
	            			<DIV id="wait5"><img src="/nresources/<%=cssPath%>/images/blue-loading.gif"  width="32" height="32"></DIV>
	            		</DIV>
	            	</div>
	            </div>
	        </div> 
		 </div>


	<div class="item">		
		    <div class="item-col col-1">
		        <div class="item">
		        	<div class="caption">
		        		<div class="text">ʵ��״̬</div>
		        		<div class="option">
		                    <div class="sub">
		                        <DIV class="li"><img id="div5_switch" class="closeEl" src="/nresources/<%=cssPath%>/images/jia.gif" style='cursor:hand' width="15" height="15"></DIV>
		                        <DIV><img class="hideEl" src="/nresources/<%=cssPath%>/images/cha.gif"   style='cursor:hand' width="15" height="15"></DIV>
		                    </div>
		        		</div>
		        	</div>
		        	<div class="content">
		        	    <DIV class="itemContent" id="mydiv6">
		        			<DIV id="wait6"><img src="/nresources/<%=cssPath%>/images/blue-loading.gif"  width="32" height="32"></DIV>
		        		</DIV>
		        	</div>
		        </div>
		    </div>
    
		    	        <div class="item-col col-2">
	            <div class="item">
	            	<div class="caption">
	            		<div class="text">������Ϣ</div>
	            		<div class="option">
	                        <div class="sub">
	                            <DIV class="li"><img id="div6_switch" class="closeEl" src="/nresources/<%=cssPath%>/images/jia.gif" style='cursor:hand' width="15" height="15"></DIV>
	                            <DIV><img class="hideEl" src="/nresources/<%=cssPath%>/images/cha.gif"   style='cursor:hand' width="15" height="15"></DIV>
	                        </div>
	            		</div>
	            	</div>
	            	<div class="content">
	            	    <DIV class="itemContent" id="mydiv7">
	            			<DIV id="wait7"><img src="/nresources/<%=cssPath%>/images/blue-loading.gif"  width="32" height="32"></DIV>
	            		</DIV>
	            	</div>
	            </div>
	        </div> 
		 </div>

<%
System.out.println("----------hejwa1---11--------phone_no----------------------"+phone_no);
%>		 
    <iframe id="maingetAlert" src="" style="display: none"></iframe>
    
</div>

<script>
    var _jspPage = {
	"div1_switch":["mydiv1","fserviceMsg.jsp?activePhone="+$("#phone_no_source").val(),"f"]
	,"div2_switch":["mydiv2","fsource_sel.jsp?activePhone="+$("#phone_no_source").val(),"f"]
	,"div3_switch":["mydiv3","fserviceMsg1.jsp?activePhone="+$("#phone_no_source").val(),"f"]
		,"div4_switch":["mydiv4","fserviceMsg2.jsp?activePhone="+$("#phone_no_source").val(),"f"]
		,"div5_switch":["mydiv6","fserviceMsg4.jsp?activePhone="+$("#phone_no_source").val(),"f"]
		,"div6_switch":["mydiv7","fserviceMsg6.jsp?activePhone="+$("#phone_no_source").val(),"f"]
	};
	
	var toggleContent = function(e)
    {
    	var targetContent = $('DIV.itemContent', this.parentNode.parentNode.parentNode.parentNode.parentNode);
    	if (targetContent.css('display') == 'none') {
    		targetContent.slideDown(300);
    		$(this).attr({ src: "../../../nresources/<%=cssPath%>/images/jian.gif"}); 
    		//���÷���
    		try{
    			var tmp = $(this).attr('id');
    			var tmp2 = eval("_jspPage."+tmp);
    			//alert(tmp2[2]);
    			if(tmp2[2]=="f"&&tmp2[1]!=''&&tmp2[1]!=undefined)
    			{
    				$("#"+tmp2[0]).load(tmp2[1]);
    				tmp2[2]="t";
    			}
    		}catch(e)
    		{
    		}
    		
    	} else {
    		targetContent.slideUp(300);
    		$(this).attr({ src: "../../../nresources/<%=cssPath%>/images/jia.gif"}); 
    	}
    	return false;
    };
	
	var hideContent = function(e)
    {
    	var targetContent = $(this.parentNode.parentNode.parentNode.parentNode.parentNode);
    	targetContent.hide();
    	
    	var div_id = $(this.parentNode.parentNode.parentNode.parentNode.parentNode).attr('id');
    	
    	if(div_id=="div1_show")
    	{
    		$("#div1").attr({checked:false});
    	}
    	else if(div_id=="div2_show")
    	{
    		$("#div2").attr({checked:false});
    	}else if(div_id=="div3_show")
    	{
    		$("#div3").attr({checked:false});
    	}
    	
    		
    };
	
	function reloadPhoneNo(phone_no){
	    var vPhoneNo = phone_no;
	    $("#phone_no_source").val(vPhoneNo);
	    $("#mydiv1").slideUp(300);
	    $("#mydiv2").slideUp(300);
	    $("#mydiv3").slideUp(300);
	    $("#mydiv4").slideUp(300);
	    $("#mydiv6").slideUp(300);
	    $("#mydiv7").slideUp(300);
        $('img.closeEl').attr({ src: "../../../nresources/<%=cssPath%>/images/jia.gif"}); 
    		
	    _jspPage = {
        	"div1_switch":["mydiv1","fserviceMsg.jsp?activePhone="+$("#phone_no_source").val(),"f"]
        	,"div2_switch":["mydiv2","fsource_sel.jsp?activePhone="+$("#phone_no_source").val(),"f"]
        	,"div3_switch":["mydiv3","fserviceMsg1.jsp?activePhone="+$("#phone_no_source").val(),"f"]
        	,"div4_switch":["mydiv4","fserviceMsg2.jsp?activePhone="+$("#phone_no_source").val(),"f"]
        	,"div5_switch":["mydiv6","fserviceMsg4.jsp?activePhone="+$("#phone_no_source").val(),"f"]
        	,"div6_switch":["mydiv7","fserviceMsg6.jsp?activePhone="+$("#phone_no_source").val(),"f"]
    	};
	}
</script>
</body>
</html>