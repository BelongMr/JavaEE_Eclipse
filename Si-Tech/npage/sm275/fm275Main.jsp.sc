<%
/********************
 version v2.0
 ������: si-tech
 update by liutong @ 2008.09.03
 update by qidp @ 2009-08-18 for ���ݶ˵�������
********************/
%>
<%--baixf modify 20070815 �ͻ������ݵ�¼�����Ƿ��м��ſͻ�����Ȩ�޶���ʾ���š�ec����
    op_code:1993 ���ſͻ�����
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="java.text.SimpleDateFormat"%> <!--����֤-->
<%@ page import="java.util.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="java.security.*" %>
<%@ page import="javax.crypto.*;" %>

<%        
  
  String printAccept = "";
  String IccIdAccept="";
  response.setHeader("Pragma","No-cache");
  response.setHeader("Cache-Control","no-cache"); 
%>

<%
    /**        
    ArrayList arr = (ArrayList)session.getAttribute("allArr");
    String[][] baseInfo = (String[][])arr.get(0);
    String[][] agentInfo = (String[][])arr.get(2);
    String workNo = baseInfo[0][2];
    String workName = baseInfo[0][3];
    String Role = baseInfo[0][5];
    String Department = baseInfo[0][16];
    String belongCode = Department.substring(0,7);
    String ip_Addr = agentInfo[0][2];
    String regionCode = Department.substring(0,2);
    String districtCode = Department.substring(2,4);
    String rowNum = "16";
    String getAcceptFlag = "";
    **/   
    
    // zhouby add for �����Ż�Ȩ��
    String[][] temfavStr = (String[][])session.getAttribute("favInfo");
    String[] favStr = new String[temfavStr.length];
    boolean openFav = false;
    for(int i = 0; i < favStr.length; i ++) {
    	favStr[i] = temfavStr[i][0].trim();
    }
    if (WtcUtil.haveStr(favStr, "a386")) {
    	openFav = true;
    }
    
    String opCode=request.getParameter("opCode");
    String opName=request.getParameter("opName");
    String workNo =(String)session.getAttribute("workNo");
    String workName =(String)session.getAttribute("workName");
    String powerRight =(String)session.getAttribute("powerRight");
    String Role =(String)session.getAttribute("Role");
    String orgCode =(String)session.getAttribute("orgCode");
    String regionCode = orgCode.substring(0,2);
    String groupId =(String)session.getAttribute("groupId");
    String ip_Addr =(String)session.getAttribute("ip_Addr");
    String belongCode =orgCode.substring(0,7);
    String districtCode =orgCode.substring(2,4);
    String rowNum = "16";
    String getAcceptFlag = "";
    System.out.println("gaopengSeeLogm275======groupId=="+groupId);
    
    
    /*������ʵ����ڿ�������BOSS�Ż���������������ñ�start*/
    String sql_appregionset1 = "select count(*) from sOrderCheck where group_id=:groupids and flag='Y' ";
    String sql_appregionset2 = "groupids="+groupId;
    String appregionflag="0";//==0ֻ�ܽ��й�����ѯ��>0���Խ��й�����ѯ���߶���
 %>
 		<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCodeappregion" retmsg="retMsgappregion" outnum="1"> 
			<wtc:param value="<%=sql_appregionset1%>"/>
			<wtc:param value="<%=sql_appregionset2%>"/>
		</wtc:service>  
		<wtc:array id="appregionarry"  scope="end"/>
			
		<wtc:service name="sDynSqlCfm" routerKey="region" routerValue="<%=regionCode%>" outnum="2">
  		  <wtc:param value="25"/>
  		  <wtc:param value="<%=workNo%>"/>
  	</wtc:service>
    <wtc:array id="rowsRegionH" scope="end"/>
    		
<%
			if("000000".equals(retCodeappregion)){
				if(appregionarry.length > 0){
					appregionflag = appregionarry[0][0]; 
				}
		}
		/*������ʵ����ڿ�������BOSS�Ż���������������ñ�end*/
    String accountType =  (String)session.getAttribute("accountType")==null?"":(String)session.getAttribute("accountType");//1 ΪӪҵ���� 2 Ϊ�ͷ�����
		String sql_sendListOpenFlag = "select count(*) from shighlogin where login_no='K' and op_code='m194'";
		String sendListOpenFlag = "0"; //�·��������� 0���أ�>0����
%>
		<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode1" retmsg="retMsg1" outnum="1"> 
			<wtc:param value="<%=sql_sendListOpenFlag%>"/>
		</wtc:service>  
		<wtc:array id="ret1"  scope="end"/>
<%
		if("000000".equals(retCode1)){
			if(ret1.length > 0){
				sendListOpenFlag = ret1[0][0]; 
			}
		}
		
		String sql_regionCodeFlag [] = new String[2];
	  sql_regionCodeFlag[0] = "select count(*) from shighlogin where op_code ='m195' and login_no=:regincode";
	  sql_regionCodeFlag[1] = "regincode="+regionCode;
		String regionCodeFlag = "N"; //�����Ƿ�ɼ� �·�������ť Y�ɼ���N���ɼ�
%>
		<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode12" retmsg="retMsg12" outnum="1"> 
			<wtc:param value="<%=sql_regionCodeFlag[0]%>"/>
			<wtc:param value="<%=sql_regionCodeFlag[1]%>"/>
		</wtc:service>  
		<wtc:array id="ret2"  scope="end"/>
<%
		if("000000".equals(retCode12)){
			if(ret2.length > 0){
				if(Integer.parseInt(ret2[0][0]) > 0){
					regionCodeFlag = "Y"; 
				}
			}
		}

String passwd = ( String )session.getAttribute( "password" );
String workChnFlag = "0" ;
%>
<wtc:service name="s1100Check" outnum="30"
	routerKey="region" routerValue="<%=regionCode%>" retcode="rc" retmsg="rm" >
	<wtc:param value = ""/>
	<wtc:param value = "01"/>
	<wtc:param value = "<%=opCode%>"/>
	<wtc:param value = "<%=workNo%>"/>
	<wtc:param value = "<%=passwd%>"/>
		
	<wtc:param value = ""/>
	<wtc:param value = ""/>
</wtc:service>
<wtc:array id="rst" scope="end" />
<%
if ( rc.equals("000000") )
{
	if ( rst.length!=0 )
	{
		workChnFlag = rst[0][0];
	}
	else
	{
	%>
		<script>
			rdShowMessageDialog( "����s1100Checkû�з��ؽ��!" );
			removeCurrentTab();
		</script>
	<%	
	}
}
else
{
%>
	<script>
		rdShowMessageDialog( "<%=rc%>:<%=rm%>" );
		removeCurrentTab();
	</script>
<%
}
%>

<%
   /**     //ȡ�ô�ӡ��ˮ
        try
        {
                String sqlStr ="select sMaxSysAccept.nextval from dual";
                retArray = callView.view_spubqry32("1",sqlStr);
                result = (String[][])retArray.get(0);
                printAccept = (result[0][0]).trim();
        }catch(Exception e){
                out.println("rdShowMessageDialog('ȡϵͳ������ˮʧ�ܣ�',0);");
                getAcceptFlag = "failed";
        }    
        **/
     String sqlStrl ="select sMaxSysAccept.nextval from dual";
    //ȡ�ô�ӡ��ˮ(�滻ԭejb)   ��ҳ����� 20080828
  %>
    <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCodel" retmsg="retMsgl" outnum="1">
    <wtc:sql><%=sqlStrl%></wtc:sql>
    </wtc:pubselect>
    <wtc:array id="resultl" scope="end" />
  <%
    if(retCodel.equals("000000")){
        printAccept = (resultl[0][0]).trim();
      IccIdAccept = printAccept;/*wangdana add*/
    }else{
      getAcceptFlag = "failed";
    }               
  String sqlStrl0 ="SELECT count(*) FROM dChnGroupMsg a,dbChnAdn.sChnClassMsg b WHERE a.group_id='"+groupId+"' AND a.is_active='Y' AND a.class_code=b.class_code AND b.class_kind='2'";  
  %> 
    <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCodel0" retmsg="retMsgl0" outnum="1">
    <wtc:sql><%=sqlStrl0%></wtc:sql>
    </wtc:pubselect>
    <wtc:array id="resultl0" scope="end" />
  
  <%
  /* add by qidp @ 2009-08-12 for ���ݶ˵������� . */
      String inputFlag = (String)request.getParameter("inputFlag");   //��ʾλ��ֵΪ1ʱ��ʾ�Ǵ����۷���ת��
      System.out.println("# inputFlag = "+inputFlag);
      inputFlag = "";
      String cont_tp = "";
      String group_name = "";
      String cont_user = "";
      String cont_mobile = "";
      String cont_addr = "";
      String cont_email = "";
      String cont_zip = "";
      
      if("1".equals(inputFlag)){
          cont_tp = (String)request.getParameter("cont_tp");          //���ſͻ�����
          group_name = (String)request.getParameter("group_name");    //���ſͻ�����
          cont_user = (String)request.getParameter("cont_user");      //���ſͻ���ϵ��
          cont_mobile = (String)request.getParameter("cont_mobile");  //���ſͻ���ϵ�绰
          cont_addr = (String)request.getParameter("cont_addr");      //���ſͻ���ϵ��ַ
          cont_email = (String)request.getParameter("cont_email");    //���ſͻ���ϵ����
          cont_zip = (String)request.getParameter("cont_zip");        //���ſͻ���ϵ�ʱ�
      }
  /* end by qidp @ 2009-08-12 for ���ݶ˵������� . */
  %>
<!------------------------------------------------------------->
<html> 
<head>
<title>�ͻ�����</title>
<meta content=no-cache http-equiv=Pragma>
<meta content=no-cache http-equiv=Cache-Control>
<link href="<%=request.getContextPath()%>/nresources/default/css/spCar.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/nresources/default/css/products.css" rel="stylesheet"type="text/css">
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/njs/extend/mztree/stTree.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/si/validate_class.js"></script>
<script type="text/javascript" src="/njs/si/desPlusPub.js"></script>
</head>
<!----------------------------------------------------------------->
<SCRIPT type=text/javascript>
var numStr="0123456789"; 

var v_groupId = "<%=groupId%>";
var v_printAccept = "<%=printAccept%>";
var v_workNo = "<%=workNo%>";
var phone_no = "";
onload=function(){
	
  
  addRegCode();
  //getIdTypes();
  /* begin add �� 1100+��ͨ����+����֤+�����������+����+��չ���У�����ʾ���·���������ť for ���ڵ绰�û�ʵ���Ǽǽ����ص㹤����֪ͨ @2014/11/19 */
  if("<%=opCode%>" == "m275"){
  	var checkVal = $("select[name='isJSX']").find("option:selected").val();//���˿������� ��ͨ�ͻ���0
		var idTypeSelect = $("#idTypeSelect option[@selected]").val();//֤�����ͣ�����֤
		if(idTypeSelect.indexOf("|") != -1){
			var v_idTypeSelect = idTypeSelect.split("|")[0];
			if(checkVal == "0" && v_idTypeSelect == "0" && "<%=workChnFlag%>" == "1" && (parseInt($("#sendListOpenFlag").val()) > 0) && "<%=regionCodeFlag%>" == "Y" ){
				$("#sendProjectList").show();
				$("#qryListResultBut").show();
			}
			/* begin update for ���ڿ��������ն�CRMģʽAPP�ĺ� - �ڶ���@2015/3/10 */
			if(v_idTypeSelect == "0"||v_idTypeSelect == "D"){ //����֤ ��������֤
				if("<%=workChnFlag%>" != "1"){ //����Ӫҵ��
					$("#idIccid").attr("class","InputGrey");
					$("#idIccid").attr("readonly","readonly");
					$("#custName").attr("class","InputGrey");
					$("#custName").attr("readonly","readonly");
					$("#idAddr").attr("class","InputGrey");
					$("#idAddr").attr("readonly","readonly");
					$("#idValidDate").attr("class","InputGrey");
					$("#idValidDate").attr("readonly","readonly");
					$("#idIccid").val("");
					$("#custName").val("");
					$("#idAddr").val("");
					$("#idValidDate").val("");
				}else{ //�������
					if((parseInt($("#sendListOpenFlag").val()) > 0) && "<%=regionCodeFlag%>" == "Y"){ //���Ź�˾���鿪��Ϊ������+���п���Ϊ������ʱ
						$("#idIccid").attr("class","InputGrey");
						$("#idIccid").attr("readonly","readonly");
						$("#custName").attr("class","InputGrey");
						$("#custName").attr("readonly","readonly");
						$("#idAddr").attr("class","InputGrey");
						$("#idAddr").attr("readonly","readonly");
						$("#idValidDate").attr("class","InputGrey");
						$("#idValidDate").attr("readonly","readonly");
						$("#idIccid").val("");
						$("#custName").val("");
						$("#idAddr").val("");
						$("#idValidDate").val("");
					}
				}
			}
			/* end update for ���ڿ��������ն�CRMģʽAPP�ĺ� - �ڶ���@2015/3/10 */
		}
  }
  /* end add for ���ڵ绰�û�ʵ���Ǽǽ����ص㹤����֪ͨ @2014/11/19 */
  check_newCust();
  
    document.all.pa_flag.value="1";
    if(typeof(frm1100.custId)!="undefined")
    {   
        if(frm1100.custId.value != "")      //�ָ����ύǰ�Ŀͻ�ID��ť��ʾ״̬
        {       frm1100.custQuery.disabled = true;           }
    }
    if((typeof(frm1100.idType)!="undefined")&&(typeof(frm1100.idIccid)!="undefined"))
    { change_idType('1');}  //��ԭ���ύǰ��֤������   
    change();//luxc 2008326 add ��Ϊ������� ����ҳ�治��ȷ
    change_instigate();
    
    /*  add by qidp @ 2009-08-12 for ���ݶ˵������� .  */
    <% if("1".equals(inputFlag)){ %>
        document.all.ownerType[1].selected = true;
        change();
        
        document.all.unitXz.value = "<%=cont_tp%>";
        document.all.custName.value = "<%=group_name%>";
        document.all.contactPerson.value = "<%=cont_user%>";
        document.all.contactPhone.value = "<%=cont_mobile%>";
        document.all.custAddr.value = "<%=cont_addr%>";
        document.all.contactAddr.value = "<%=cont_addr%>";
        document.all.contactMAddr.value = "<%=cont_addr%>";
        document.all.contactMail.value = "<%=cont_email%>";
        document.all.contactPost.value = "<%=cont_zip%>";
    <% } %>
    /* end by qidp @ 2009-08-12 for ���ݶ˵������� . */
    getId();
}
/*2013/11/07 21:14:36 gaopeng ����ʵ���ƹ����������ϵĺ�*/
function getIdTypes(){
	 var checkVal = $("select[name='isJSX']").find("option:selected").val();
   var getdataPacket = new AJAXPacket("/npage/sq100/fq100GetIdTypes.jsp","���ڻ�����ݣ����Ժ�......");
			
			getdataPacket.data.add("checkVal",checkVal);
			getdataPacket.data.add("opCode","<%=opCode%>");
			getdataPacket.data.add("opName","<%=opName%>");
			getdataPacket.data.add("workChnFlag","<%=workChnFlag%>");
			core.ajax.sendPacketHtml(getdataPacket,resIdTypes);
			getdataPacket = null;
	
}
function pubM032Cfm(){
	/*2015/8/19 16:12:01 gaopeng �����޸�BOSSϵͳʵ���ж��������ھ���ϵͳ������ȫʡʵ�����Ǽ��ձ����ĺ�-��������
					��������÷��� sM032Cfm 
				*/
				
				var myPacket = new AJAXPacket("/npage/public/pubM032Cfm.jsp","���ڲ�ѯ��Ϣ�����Ժ�......");
			  myPacket.data.add("idSexH",document.all.idSexH.value);
			  myPacket.data.add("custName",document.all.custName.value);
			  myPacket.data.add("idAddrH",document.all.idAddrH.value.replace(new RegExp("#","gm"),"%23"));
			  myPacket.data.add("birthDayH",document.all.birthDayH.value);
			  myPacket.data.add("custId",document.all.custId.value);
			  myPacket.data.add("idIccid",document.all.idIccid.value);
			  myPacket.data.add("zhengjianyxq",document.all.idValidDate.value);
			  myPacket.data.add("opCode","<%=opCode%>");
			  
			  core.ajax.sendPacket(myPacket,function(packet){
			  	var retCode=packet.data.findValueByName("retCode");
				  var retMsg=packet.data.findValueByName("retMsg");
				  
				  if(retCode == "000000"){
				  	//document.all.uploadpic_b.disabled=false;
				 	}else{
				 		//rdShowMessageDialog("������룺"+retCode+",������Ϣ��"+retMsg,0);
				 		//document.all.uploadpic_b.disabled=true;
						//return  false;
				 	}
		 		});
				myPacket = null;
}
function resIdTypes(data){
				//alert(data);
			//�ҵ����ӵ�select
				var markDiv=$("#tdappendSome"); 
				//���ԭ�б���
				markDiv.empty();
				markDiv.append(data);
				var idTypeSelect = $("#idTypeSelect option[@selected]").val();
				/*2014/12/02 9:23:07 gaopeng ���ӹ�������-�������Ӹ����Ƕ���֤ʶ���� ����֤��ʱ�� 
				��ʾ�����ǰ�ť*/
				if(idTypeSelect == "0|����֤"){
					$("input[name='highView']").show();
				}else{
					$("input[name='highView']").hide();
				}
}
function 	addRegCode(){
		var selectObj = document.getElementById("receiveRegion");
	  selectObj.length=0;
	  <%
		  for(int iii=0;iii<rowsRegionH.length;iii++){
		  		String temp1 = rowsRegionH[iii][0];
		  		String temp2 = rowsRegionH[iii][1];
		%>
			 selectObj.options.add(new Option("<%=temp1%>--><%=temp2%>","<%=temp1%>"));
		<%			
			}
		%>	
}
			
function doProcess(packet)
{
    //RPC��������findValueByName
    var retType = packet.data.findValueByName("retType");
    var retCode = packet.data.findValueByName("retCode"); 
    var retMessage = packet.data.findValueByName("retMessage"); 
    self.status="";
  if((retCode).trim()=="")
  {
       rdShowMessageDialog("����"+retType+"����ʱʧ�ܣ�");
       return false;
  }
    //---------------------------------------    
    if(retType == "ClientId")
    {
            //�õ��½��ͻ�ID
        var retnewId = packet.data.findValueByName("retnewId");
        if(retCode=="000000")
        {
      document.frm1100.custId.value = retnewId;
      document.frm1100.temp_custId.value = retnewId;
      document.frm1100.districtCode.focus();
      document.frm1100.districtCode.focus();
     
      document.all.read_idCard_one.disabled=false;//����֤
      document.all.read_idCard_two.disabled=false;//����֤
      document.all.scan_idCard_two.disabled=false;//����֤
      document.all.scan_idCard_two222.disabled=false;//����֤
      $("#scan_idCard_two222").attr("disabled",false);
      
        }
        else
        {
      retMessage = retMessage + "[errorCode1:" + retCode + "]";
      rdShowMessageDialog(retMessage,0);
      return false;
        }       
     }
    //-----------------------------------------
    if(retType == "checkPwd")
    {
        //��������У��
        var retResult = packet.data.findValueByName("retResult");
    frm1100.checkPwd_Flag.value = retResult; 
      if(frm1100.checkPwd_Flag.value == "false")
      {
        rdShowMessageDialog("�ϼ��ͻ�����У��ʧ�ܣ����������룡",0);
        frm1100.parentPwd.value = "";
        frm1100.parentPwd.focus();
        frm1100.checkPwd_Flag.value = "false";        
        return false;           
      }
    else
    {
      rdShowMessageDialog("�ϼ��ͻ�����У��ɹ���",2);
    }
    //Ϊ����,����������������ж� sunaj 20100126
    if("09" == "<%=regionCode%>")
    {
      if(document.frm1100.parentPwd.value == "000000"||document.frm1100.parentPwd.value == "111111"||document.frm1100.parentPwd.value == "222222"
       ||document.frm1100.parentPwd.value == "333333"||document.frm1100.parentPwd.value == "444444"||document.frm1100.parentPwd.value == "555555"
       ||document.frm1100.parentPwd.value == "666666"||document.frm1100.parentPwd.value == "777777"||document.frm1100.parentPwd.value == "888888"
       ||document.frm1100.parentPwd.value == "999999"||document.frm1100.parentPwd.value == "123456")
        {
          rdShowMessageDialog("������ڼ򵥣����޸ĺ��ٰ���ҵ��");
          return false;
        }
      } 
     }        
    //----------------------------------------
    if(retType == "getInfo_withID")
    {
            clear_CustInfo();  
        if(retCode == "000000")
        {
           var retInfo = packet.data.findValueByName("retInfo");
           if(retInfo != "")
           {
               //var recordNum = acket.data.findValueByName("recordNum"); 
               //showParentInfo(retInfo);       
               for(i=0;i<7;i++)
               {           
                    var chPos = retInfo.indexOf("|");
                    valueStr = retInfo.substring(0,chPos);
                    retInfo = retInfo.substring(chPos+1);
                    var obj = "in" + i;
                    document.all(obj).value = valueStr;
                } 
             }
       else
       {
         rdShowMessageDialog("�ͻ������ڣ�",0);  
         return false;
       }
         }           
         else
         {
             retMessage = retMessage + "[errorCode2:" + retCode + "]";
             rdShowMessageDialog(retMessage,0);
       return false;
         }
     }
   if(retType=="chkX")
   {
    var retObj = packet.data.findValueByName("retObj");
    if(retCode == "000000"){
        //rdShowMessageDialog("У��ɹ�111!",2);     
        document.all.print.disabled=false;
        document.all.uploadpic_b.disabled=false;//����֤
      }else if(retCode=="100001"){
        retMessage = retCode + "��"+retMessage;  
        rdShowMessageDialog(retMessage);     
        document.all.print.disabled=false;
        document.all.uploadpic_b.disabled=false;//����֤
        return true;
      }else{
        retMessage = "����" + retCode + "��"+retMessage;      
        rdShowMessageDialog(retMessage,0);
        /*document.all.print.disabled=true;*/
        document.all.uploadpic_b.disabled=true;//����֤
        document.all(retObj).focus();
        return false;
       
    }
   }
   if(retType=="checkName")
   {
      var flag = packet.data.findValueByName("flag");
      var custId = packet.data.findValueByName("custId");
      if(flag=="0"){
        rdShowMessageDialog("�ÿͻ����ƿ�������ʹ�ã�",2);
      }
      else if(flag=="1"){
        
        rdShowMessageDialog("�ÿͻ������Ѿ����ڣ�<BR>�ͻ�IDΪ"+custId+"��",0);
      }
    
   }
   
   if(retType=="iccIdCheck")
   {
    if(retCode == "000000")
    {
      rdShowMessageDialog("У��ͨ����");
      document.all.get_Photo.disabled=false;
      //document.all.print.disabled=false;
    }
    else
    {

      retMessage = retCode + "��"+retMessage;  
      rdShowMessageDialog(retMessage);
      document.all.idIccid.value="";
    }
   }
  
}

//dujl add at 20100415 for ����֤У��
function checkIccId()
{
  if(document.all.idType.value.split("|")[0] != "0")
  {
    rdShowMessageDialog("ֻ������֤����У�飡");
    return false;
  }
  if(document.all.custName.value.trim() == "")
  {
    rdShowMessageDialog("��������ͻ����ƣ�");
    return false;
  }
  if(document.all.idIccid.value.trim() == "")
  {
    rdShowMessageDialog("��������֤�����룡");
    return false;
  }
  if(document.all.ziyou_check.value != 0)
  {
    rdShowMessageDialog("������Ӫҵ�������Բ�ѯ��");
    return false;
  }
  var Str = document.all.idType.value;
  
    if(Str.indexOf("����֤") > -1){
      if($("#idIccid").val().length<18){
        rdShowMessageDialog("����֤���������18λ��");
        document.all.idIccid.focus();
        return false;
      }
    }
  
  //document.all.iccIdCheck.disabled=true;
  var myPacket = new AJAXPacket("/npage/innet/fIccIdCheck.jsp","������֤����֤��Ϣ�����Ժ�......");
  myPacket.data.add("retType","iccIdCheck");
  myPacket.data.add("idIccid",document.all.idIccid.value);
  myPacket.data.add("custName",document.all.custName.value);
  myPacket.data.add("IccIdAccept",document.all.IccIdAccept.value);
  myPacket.data.add("opCode",document.all.opCode.value);
  core.ajax.sendPacket(myPacket);
  myPacket=null;
  //document.all.iccIdCheck.disabled=false;
}

//dujl add at 20100421 for ����֤У��
// ��ȡ����֤��Ƭ
function getPhoto()
{
  window.open("../innet/fgetIccIdPhoto.jsp?idIccid="+document.all.idIccid.value,"","width="+(screen.availWidth*1-900)+",height="+(screen.availHeight*1-500) +",left=450,top=240,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no");
}

//   copy from common_util.js   ҳ�����   liutong@20080828
function rpc_chkX(x_type,x_no,chk_kind)
{
  var obj_type=document.all(x_type);
  var obj_no=document.all(x_no);
  var idname="";

  if(obj_type.type=="text")
  {
    idname=(obj_type.value).trim();
  }
  else if(obj_type.type=="select-one")
  {
    idname=(obj_type.options[obj_type.selectedIndex].text).trim();  
  }

  if((obj_no.value).trim().length>0)
  {
  	
   
      if(idname=="����֤")
    {
        if(checkElement(obj_no)==false) return false;
    }
  
  }
  else 
  return;
  var myPacket = new AJAXPacket("/npage/innet/chkX.jsp","������֤��������Ϣ�����Ժ�......");
    myPacket.data.add("retType","chkX");
    myPacket.data.add("retObj",x_no);
    myPacket.data.add("x_idType",getX_idno(idname));
    myPacket.data.add("x_idNo",obj_no.value);
    myPacket.data.add("x_chkKind",chk_kind);
    core.ajax.sendPacket(myPacket);
    myPacket=null;
  
}
function getX_idno(xx)
{
  if(xx==null) return "0";
  
  if(xx=="����֤") return "0";
  else if(xx=="����֤") return "1";
  else if(xx=="��ʻ֤") return "2";
  else if(xx=="����֤") return "4";
  else if(xx=="ѧ��֤") return "5";
  else if(xx=="��λ") return "6";
  else if(xx=="У԰") return "7";
  else if(xx=="Ӫҵִ��") return "8";
  else return "0";
}

//--------------------------------------------
//����ϼ��ͻ���Ϣ
function clear_CustInfo()
{
        for(i=0;i<6;i++)
        {          
                var obj = "in" + i;
                document.all(obj).value = "";
        }
}
//--------------------------------------------
function check_newCust(){ 
/** if("09" == "<%=regionCode%>")
  {
    var divPassword = document.getElementById("divPassword"); 
      divPassword.style.display="none";
  }*/ 
  
      if(document.all.custQuery.disabled==true){document.all.custQuery.disabled=false}
      //document.all.Reset.click();
         //�½��ͻ�����������
         document.getElementById("svcLvl").style.display="none";
         document.getElementById("trU00020003").style.display="none";
        if(document.frm1100.newCust.checked == true){
        window.document.frm1100.oldCust.checked = false;
        var temp1="tbs"+9;           
            document.all(temp1).style.display = "none";
            document.all("card_id_type").style.display="";
            window.document.frm1100.parentId.value = "";
            window.document.frm1100.parentPwd.value = "";
            window.document.frm1100.parentName.value = "";
            window.document.frm1100.parentAddr.value = "";
            window.document.frm1100.parentIdType.value = "";
            window.document.frm1100.parentIdidIccid.value = "";
        }
}
function check_oldCust(){
  /**
  if("09" == "<%=regionCode%>")
  {
    var divPassword = document.getElementById("divPassword"); 
      divPassword.style.display="none";
  }*/
  document.getElementById("svcLvl").style.display="none";
  document.getElementById("trU00020003").style.display="none";
  //document.all.Reset.click();
  document.all("card_id_type").style.display="none";
  document.all.oldCust.checked=true;
         //���ͻ�����������    
    if(document.frm1100.oldCust.checked == true)
    {
        window.document.frm1100.newCust.checked = false;
        var temp2="tbs"+9;           
            document.all(temp2).style.display="";
    }
}

function change(){      
        //�Ը�������������Ŀ���       
        var ic = document.frm1100.ownerType.options[document.frm1100.ownerType.selectedIndex].value;
        document.getElementById("preBox").style.checked=false;//wangzn 091203
    if(ic=="01")
      { 
            document.all("tb0").style.display="none";   
        document.all("tb1").style.display="none";      
        document.all("td2").style.display="none";
        document.all("td3").style.display="none";
        document.all("checkName").style.display="none";
        document.all("ownerType_Type").style.display="";/** tianyang add for custNameCheck **/
        document.all("print").disabled=true;
        //document.all.custPwd.value="123456";
        //document.all.cfmPwd.value="123456";
       document.getElementById("preBox").style.display="none";//wangzn 091201
          document.getElementById("svcLvl").style.display="none";//zhangyan 2011-12-13 15:46:32 
          document.getElementById("trU00020003").style.display="none";//zhangyan 2011-12-13 15:46:32  
    }
    else if(ic=="02")
    {
         document.all("tb0").style.display="none";
         document.all("tb1").style.display="none";
         document.all("td2").style.display="none";
         document.all("td3").style.display="";   
         document.all("checkName").style.display="inline";
         document.all("ownerType_Type").style.display="none";/** tianyang add for custNameCheck **/
         document.all("print").disabled=true;
         //document.all.custPwd.value="111111";
       //document.all.cfmPwd.value="111111";
         document.getElementById("preBox").style.display="";//wangzn 091201
            document.getElementById("svcLvl").style.display="";//zhangyan 2011-12-13 15:46:32
            document.getElementById("trU00020003").style.display="";//zhangyan 2011-12-13 15:46:32
    }
    else if(ic=="03")
    {
         document.all("tb0").style.display="none";
         document.all("tb1").style.display="none";
         document.all("td2").style.display="";    
         document.all("td3").style.display="none";
         document.all("checkName").style.display="none";
         document.all("ownerType_Type").style.display="none";/** tianyang add for custNameCheck **/
         document.all("print").disabled=true;
           document.getElementById("preBox").style.display="none";//wangzn 091201
      document.getElementById("svcLvl").style.display="none";//zhangyan 2011-12-13 15:46:32 
      document.getElementById("trU00020003").style.display="none";//zhangyan 2011-12-13 15:46:32  
    }
    else if(ic=="04")
    {
       document.all("tb0").style.display="none";
       document.all("tb1").style.display="none";
         document.all("td2").style.display="none";
         document.all("td3").style.display="";   
         document.all("checkName").style.display="inline";
         document.all("ownerType_Type").style.display="none";/** tianyang add for custNameCheck **/
         document.all("print").disabled=true;
         document.getElementById("preBox").style.display="";//wangzn 091201
         //document.all.custPwd.value="111111";
       //document.all.cfmPwd.value="111111";
    document.getElementById("svcLvl").style.display="";//zhangyan 2011-12-13 15:46:32 
    document.getElementById("trU00020003").style.display="";//zhangyan 2011-12-13 15:46:32  
    }
    
  //dujl add at 20100421 for ����֤У��
  if(document.all.ownerType.value != "01")
  {
    //document.all.iccIdCheck.disabled = true;
  }
  else
  {
    //document.all.iccIdCheck.disabled = false;
  }
}

function change_instigate()
{
  if(document.all.instigate_flag.value=="Y")
  {
    document.all.getcontract_flag.disabled=false;
  }
  else
  {
    document.all.getcontract_flag.value="0";
    document.all.getcontract_flag.disabled=true;
  }
}

function change_idType(chgFlag)//����֤
{   
     var Str = document.all.idType.value;
	  /* begin diling update for �������ӿ�������ͻ��Ǽ���Ϣ��֤���ܵĺ�@2013/9/22 */
   
      checkCustNameFunc16New(document.all.custName,0,1); //У��ͻ������Ƿ����
      if(Str.indexOf("����֤") > -1){
  	    $("#idAddrDiv").text("֤����ַ(����)");
  	  }else{
  	    $("#idAddrDiv").text("֤����ַ");
  	  }
    
	  /* end diling update@2013/9/22 */
    if(document.all.idType.value=="0|����֤"||document.all.idType.value=="D|��������֤")
    {
      document.all.pa_flag.value="1"; 
	    document.all("card_id_type").style.display="";
	    $("#iccidShowFlag").show();
	    
	    /* begin add �� 1100+��ͨ����+����֤+�����������+����+��չ���У�����ʾ���·���������ť for ���ڵ绰�û�ʵ���Ǽǽ����ص㹤����֪ͨ @2014/11/4 */
			var checkVal = document.all.isJSX.value;//���˿������� ��ͨ�ͻ���0
			if(checkVal == "0" && "<%=workChnFlag%>" == "1" && "<%=opCode%>" == "1100" && (parseInt($("#sendListOpenFlag").val()) > 0) && "<%=regionCodeFlag%>" == "Y"){
				$("#sendProjectList").show();
				$("#qryListResultBut").show();
			}else{
				$("#sendProjectList").hide();
				$("#qryListResultBut").hide();
			}
			/* end add for ���ڵ绰�û�ʵ���Ǽǽ����ص㹤����֪ͨ @2014/11/4 */
			
			/* begin update for ���ڿ��������ն�CRMģʽAPP�ĺ� - �ڶ���@2015/3/10 */
			if("<%=workChnFlag%>" != "1"){ //����Ӫҵ��
				$("#idIccid").attr("class","InputGrey");
				$("#idIccid").attr("readonly","readonly");
				$("#custName").attr("class","InputGrey");
				$("#custName").attr("readonly","readonly");
				$("#idAddr").attr("class","InputGrey");
				$("#idAddr").attr("readonly","readonly");
				$("#idValidDate").attr("class","InputGrey");
				$("#idValidDate").attr("readonly","readonly");
				if(chgFlag == "1"){
					$("#idIccid").val("");
					$("#custName").val("");
					$("#idAddr").val("");
					$("#idValidDate").val("");
				}
			}else{ //�������
				if((parseInt($("#sendListOpenFlag").val()) > 0) && "<%=regionCodeFlag%>" == "Y"){ //���Ź�˾���鿪��Ϊ������+���п���Ϊ������ʱ
					$("#idIccid").attr("class","InputGrey");
					$("#idIccid").attr("readonly","readonly");
					$("#custName").attr("class","InputGrey");
					$("#custName").attr("readonly","readonly");
					$("#idAddr").attr("class","InputGrey");
					$("#idAddr").attr("readonly","readonly");
					$("#idValidDate").attr("class","InputGrey");
					$("#idValidDate").attr("readonly","readonly");
					if(chgFlag == "1"){
						$("#idIccid").val("");
						$("#custName").val("");
						$("#idAddr").val("");
						$("#idValidDate").val("");
					}
				}
			}
			/* end update for ���ڿ��������ն�CRMģʽAPP�ĺ� - �ڶ���@2015/3/10 */		
			
			
			

	
    }
    else{
      $("#iccidShowFlag").hide();
	    document.all.pa_flag.value="0";
	    document.all("card_id_type").style.display="none";
	    $("#sendProjectList").hide();
			$("#qryListResultBut").hide();
			/* begin update for ���ڿ��������ն�CRMģʽAPP�ĺ� - �ڶ���@2015/3/10 */
			if("<%=workChnFlag%>" != "1"){ //����Ӫҵ��
				$("#idIccid").removeAttr("class");
				$("#idIccid").removeAttr("readonly");
				$("#custName").removeAttr("class");
				$("#custName").removeAttr("readonly");
				$("#idAddr").removeAttr("class");
				$("#idAddr").removeAttr("readonly");
				$("#idValidDate").removeAttr("class");
				$("#idValidDate").removeAttr("readonly");
			}else{ //�������
				if((parseInt($("#sendListOpenFlag").val()) > 0) && "<%=regionCodeFlag%>" == "Y"){ //���Ź�˾���鿪��Ϊ������+���п���Ϊ������ʱ
					$("#idIccid").removeAttr("class");
					$("#idIccid").removeAttr("readonly");
					$("#custName").removeAttr("class");
					$("#custName").removeAttr("readonly");
					$("#idAddr").removeAttr("class");
					$("#idAddr").removeAttr("readonly");
					$("#idValidDate").removeAttr("class");
					$("#idValidDate").removeAttr("readonly");
				}
			}
			/* end update for ���ڿ��������ն�CRMģʽAPP�ĺ� - �ڶ���@2015/3/10 */		
  	}
    var Str = document.frm1100.idType.value;
    if(Str.indexOf("����֤") > -1)
    {   document.frm1100.idIccid.v_type = "idcard";   }
    else
    {   document.frm1100.idIccid.v_type = "string";   }
    /*document.all.print.disabled=true;*/
    
    
 
}

function change_custPwd()
{   
    check_HidPwd(frm1100.parentPwd.value,"show",(frm1100.in1.value).trim(),"hid");
    /*
    if(frm1100.checkPwd_Flag.value != "true");
    {
      rdShowMessageDialog("�ϼ��ͻ�����У��ʧ�ܣ����������룡",0);
      frm1100.parentPwd.value = "";
      frm1100.parentPwd.focus();
      return false;           
    }
    frm1100.checkPwd_Flag.value = "false"; 
    */
}
//------------------------------------
function printCommit()
{       
	/* begin add �� û�н��С����������ѯ��,���ܽ����ύ for ���ڵ绰�û�ʵ���Ǽǽ����ص㹤����֪ͨ @2014/11/4 */
	if("<%=opCode%>" == "m275"){
  	var checkVal = document.all.isJSX.value;//���˿������� ��ͨ�ͻ���0
		var idTypeSelect = $("#idTypeSelect option[@selected]").val();//֤�����ͣ�����֤
		if(idTypeSelect.indexOf("|") != -1){
			var v_idTypeSelect = idTypeSelect.split("|")[0];
			if(checkVal == "0" && v_idTypeSelect == "0" && "<%=workChnFlag%>" == "1" && "<%=regionCodeFlag%>" == "Y"){ 
				if("<%=appregionflag%>"=="0") {//�������app���ñ�����ֻ�ܽ��й�����ѯ��
				if(($("#isQryListResultFlag").val() == "N") && (parseInt($("#sendListOpenFlag").val()) > 0)){ //�Ѳ�ѯ�����б������·���������Ϊ���������У��
					rdShowMessageDialog("���Ƚ��й��������ѯ���ٽ��п���!");
			    return false;		
					}
				}
			}
		}
  }
	/* end add for ���ڵ绰�û�ʵ���Ǽǽ����ص㹤����֪ͨ @2014/11/4 */

	if(!checkElement(document.all.custId)){
		return false;
	}
	/*2013/11/18 15:09:28 gaopeng �����ύ֮ǰ��У�� ���ڽ�һ������ʡ��֧��ϵͳʵ���Ǽǹ��ܵ�֪ͨ start*/
	/*����У��*/
    		/*�ͻ�����*/
    		if(!checkCustNameFunc16New(document.all.custName,0,1)){
    			return false;
    		}
    		/*��ϵ������*/
    		if(!checkCustNameFunc(document.all.contactPerson,1,1)){
					return false;
				}
				/*֤����ַ*/
				if(!checkAddrFunc(document.all.idAddr,0,1)){
					return false;
				}
				/*�ͻ���ַ*/
				if(!checkAddrFunc(document.all.custAddr,1,1)){
					return false;
				}
				/*��ϵ�˵�ַ*/
				if(!checkAddrFunc(document.all.contactAddr,2,1)){
					return false;
				}
				/*��ϵ��ͨѶ��ַ*/
				if(!checkAddrFunc(document.all.contactMAddr,3,1)){
					return false;
				}
				/*֤������*/
				if(!checkIccIdFunc16New(document.all.idIccid,0,1)){
					return false;
				}
				else{
					rpc_chkX('idType','idIccid','A');
				}
				/*gaopeng 20131216 2013/12/16 19:50:11 ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭������Ϣȷ�Ϸ���ǰУ�� start*/
					/*����������*/
					if(!checkCustNameFunc16New(document.all.gestoresName,1,1)){
						return false;
					}
					/*��������ϵ��ַ*/
					if(!checkAddrFunc(document.all.gestoresAddr,4,1)){
						return false;
					}
					/*������֤������*/
					if(!checkIccIdFunc16New(document.all.gestoresIccId,1,1)){
						return false;
					}
					else{
						rpc_chkX('idType','idIccid','A');
					}
				/*gaopeng 20131216 2013/12/16 19:50:11 ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭������Ϣȷ�Ϸ���ǰУ�� start*/
				
					/*����������*/
					if(!checkElement(document.all.gestoresName,2,1)){
						return false;
					}
					/*��������ϵ��ַ*/
					if(!checkElement(document.all.gestoresAddr,4,1)){
						return false;
					}
					/*������֤������*/
					if(!checkElement(document.all.gestoresIccId,1,1)){
						return false;
					}
	/*2013/11/18 15:09:28 gaopeng �����ύ֮ǰ��У�� ���ڽ�һ������ʡ��֧��ϵͳʵ���Ǽǹ��ܵ�֪ͨ end*/
	
  getAfterPrompt();
  if(frm1100.ownerType.value=="02"||frm1100.ownerType.value=="04")
  {
    if(frm1100.custPwd.value == "")
    {
      rdShowMessageDialog("���ſ������벻��Ϊ��!",0);
        //frm1100.parentPwd.focus();
        return false;
    }
    /*luxc 20080326 add*/
    if(document.all.instigate_flag.value=="0"||document.all.instigate_flag.value=="")
    {
      rdShowMessageDialog("��ѡ��߷����ű�־!",0);
      return false;
    }
    else if(document.all.instigate_flag.value=="Y" 
      && (document.all.getcontract_flag.value=="0"||document.all.getcontract_flag.value==""))
    {
      rdShowMessageDialog("��ѡ�� �Ƿ��þ�������Э��!",0);
      return false;
    }
  }
    
    var obj = null;
    //��ȷ�ϴ�ӡ����������ڴ�ӡ��Ʊ
        if(frm1100.oldCust.checked == true)
        { //���ϻ��������ж�
          //parentId parentPwd parentIdidIccid parentName
          if(frm1100.parentId.value == "")
          { 
            rdShowMessageDialog("ѡ���ϻ����ͻ�ID����Ϊ�գ�",0);
            frm1100.parentId.focus();
            return false;
          }
          /*if(frm1100.parentPwd.value == "")
          { 
            rdShowMessageDialog("ѡ���ϻ����ͻ����벻��Ϊ�գ�",0);
            frm1100.parentPwd.focus();
            return false;
          }*/
          if(frm1100.parentIdidIccid.value == "")
          { 
            rdShowMessageDialog("ѡ���ϻ����ͻ�֤�����벻��Ϊ�գ�",0);
            frm1100.parentIdidIccid.focus();
            return false;
          }
          if(frm1100.parentName.value == "")
          { 
            rdShowMessageDialog("ѡ���ϻ����ͻ����Ʋ���Ϊ�գ�",0);
            frm1100.parentName.focus();
            return false;
          }   
          if(frm1100.parentName.value.trim().indexOf('~')>0)
      {
        rdShowMessageDialog("�ϼ��ͻ��������зǷ��ַ�'~'�����޸ģ�",0);
        return false;
      } 
      if(frm1100.parentAddr.value.trim().indexOf('~')>0)
      {
        rdShowMessageDialog("�ϼ��ͻ���ַ���зǷ��ַ�'~'�����޸ģ�",0);
        return false;
      }         
        }
        if(frm1100.custName.value.trim().indexOf('~')>0)
    {
      rdShowMessageDialog("�ͻ��������зǷ��ַ�'~'�����޸ģ�",0);
      return false;
    } 
    if(frm1100.idAddr.value.trim().indexOf('~')>0)
    {
      rdShowMessageDialog("֤����ַ���зǷ��ַ�'~'�����޸ģ�",0);
      return false;
    } 
    if(frm1100.contactAddr.value.trim().indexOf('~')>0)
    {
      rdShowMessageDialog("��ϵ�˵�ַ���зǷ��ַ�'~'�����޸ģ�",0);
      return false;
    }
    if(frm1100.contactPerson.value.trim().indexOf('~')>0)
    {
      rdShowMessageDialog("��ϵ���������зǷ��ַ�'~'�����޸ģ�",0);
      return false;
    }
    if(frm1100.contactPhone.value.trim().indexOf('~')>0)
    {
      rdShowMessageDialog("��ϵ�˵绰���зǷ��ַ�'~'�����޸ģ�",0);
      return false;
      
    }
    if(document.frm1100.contactMAddr.value.trim().indexOf('~')>0)
    {
      rdShowMessageDialog("��ϵ��ͨѶ��ַ���зǷ��ַ�'~'�����޸ģ�",0);
      return false;
    }
        change_idType('2');   //�жϿͻ�֤�������Ƿ�������֤ 
        if((frm1100.contactMail.value).trim() == "")
        {
      frm1100.contactMail.value = "";         
        }
        //�ж����ա�֤����Ч����Ч�� birthDay  idValidDate
        obj = "tb" + 0;
        obj1 = "tb" + 1;
        if((typeof(frm1100.birthDay)!="undefined")&&
           (frm1100.birthDay.value != "")&&
           (document.all(obj).style.display == ""))
        { 
          if(validDate(frm1100.birthDay) == false)
          { return false;   }
        }
        else if((typeof(frm1100.yzrq)!="undefined")&&
           (frm1100.yzrq.value != "")&&
           (document.all(obj1).style.display == ""))
        { 
          if(validDate(frm1100.yzrq) == false)
          { return false;   }     
        }
    
       if((document.all.but_flag.value =="1")&&document.all.upbut_flag.value=="0"){//����֤
  rdShowMessageDialog("�����ϴ�����֤��Ƭ",0);
  return false;
  }
        
var upflag =document.all.up_flag.value;//����֤
if(upflag==3&&(document.all.but_flag.value =="1"))//����֤
{
  rdShowMessageDialog("��ѡ��jpg����ͼ���ļ�");
  return false;
  }
if(upflag==4&&(document.all.but_flag.value =="1"))//����֤
{
  rdShowMessageDialog("����ɨ����ȡ֤����Ϣ");
  return false;
  }
  
  
if(upflag==5&&(document.all.but_flag.value =="1"))//����֤
{
  rdShowMessageDialog("��ѡ�����һ��ɨ����ȡ֤�������ɵ�֤��ͼ���ļ�"+document.all.pic_name.value);
  return false;
  }
      
if((document.all.but_flag.value =="1")&&document.all.upbut_flag.value=="0"){//����֤
  rdShowMessageDialog("�����ϴ�����֤��Ƭ",0);
  return false;
  }
    var d= (new Date().getFullYear().toString()+(((new Date().getMonth()+1).toString().length>=2)?(new Date().getMonth()+1).toString():("0"+(new Date().getMonth()+1)))+(((new Date().getDate()).toString().length>=2)?(new Date().getDate()):("0"+(new Date().getDate()))).toString());

    if((frm1100.idValidDate.value).trim().length>0)
      {    
           if(validDate(frm1100.idValidDate)==false) return false;

       if(to_date(frm1100.idValidDate)<=d)
       {
        rdShowMessageDialog("֤����Ч�ڲ������ڵ�ǰʱ�䣬���������룡");
            document.all.idValidDate.focus();
        document.all.idValidDate.select();
          return false;
       }
    }

    if(document.all.ownerType.options[document.all.ownerType.selectedIndex].text=="��ͨ")
    {
             if((document.all.birthDay.value).trim().length>0)
         {
           if(to_date(frm1100.birthDay)>=d)
           {
           rdShowMessageDialog("���������ڲ������ڵ�ǰʱ�䣬���������룡");
               document.all.birthDay.focus();
           document.all.birthDay.select();
             return false;
           }
       }
    }
    else
    {
             if((document.all.yzrq.value).trim().length>0)
         {
           if(to_date(frm1100.yzrq)<=d)
           {
           rdShowMessageDialog("Ӫҵִ����Ч�ڲ������ڵ�ǰʱ�䣬���������룡");
               document.all.yzrq.focus();
           document.all.yzrq.select();
             return false;
           }
       }
    }

    /*if(document.all("td2").style.display=="")
      {
      if(jtrim(document.all.oriGrpNo.value).length==0)
      {
              rdShowMessageDialog("������ԭ���źţ�");
              document.all.oriGrpNo.focus();
        return false;
      }
    }*/
        
        //--------------------------       
        //alert(2);      
     if(check(frm1100))
          {
           //alert(1);
              if(document.all.custPwd.value == "" || document.frm1100.cfmPwd.value == ""){
                rdShowMessageDialog("��������ͻ����룡");
                return false;
              } 
            
            
          if((document.all.custPwd.value).trim().length>0)
          {
           if(document.all.custPwd.value.length!=6)
           {
             rdShowMessageDialog("�ͻ����볤������");
             document.all.custPwd.focus();
             return false;
           }
             if(checkPwd(document.frm1100.custPwd,document.frm1100.cfmPwd)==false)
              return false;
          }
            var t = null;
            var i;
            if(document.frm1100.newCust.checked == true)
            {
                document.frm1100.parentId.value = document.frm1100.custId.value;
                sysNote = "�½���:�ͻ�ID[" + 
                     document.frm1100.custId.value + "]";
            } 
            else
            {
                sysNote = "���ϻ�:�ͻ�ID[" + 
                     document.frm1100.custId.value + "]:�ϼ��ͻ�ID[" + 
                     document.frm1100.parentId.value + "]";
            }
            document.frm1100.sysNote.value = sysNote;
        if((document.all.opNote.value).trim().length==0)
        {//luxc20061218�޸ı�ע�ֶ� ��ֹ̫���岻��wchg��
                document.all.opNote.value="<%=workName%>"+"��["+(document.all.custName.value).trim().substring(0,14)+"]"+document.all.ownerType.options[document.all.ownerType.selectedIndex].text+"�ͻ�����";
        }
        if((document.all.opNote.value).trim().length>60)
        {
          rdShowMessageDialog("�û���ע��ֵ����ȷ�������д���");
          document.all.opNote.focus();
          return false;
        }
        //wangzn 091202
        if(document.frm1100.isPre.checked){
          if(!document.frm1100.preUnitId.readOnly){
            rdShowMessageDialog("��ѡ��Ǳ�ڼ��ű�ţ�");
            return false;
          }
          }
        
      if(!check(frm1100)){
      return false;
      }else{
      	
      
      var subFlag = true;
			if(subFlag){	
	      if(rdShowConfirmDialog("ȷ��Ҫ�ύ�ͻ�������Ϣ��")==1) {
	        <% if("1".equals(inputFlag)){ %>
	          document.frm1100.target="hidden_frame";
	        <% }else{ %>
	          //����֤
	          frm1100.target=""; 
	        <% } %>
	        //wangzn 20091202
	        var isPre = "0";
	        if(document.frm1100.isPre.checked) {
	          isPre="1";
	        }
	        
	        var xsjbrxx="0";
	        if($("#gestoresInfo1").css("display")=="none"){
	        	xsjbrxx="0";
	        }
	        else{
	        	xsjbrxx="1";
	        }
	        
	        /*�ύ�����ָ������iframe*/
	        frm1100.target = "cfm_frame";
	        frm1100.action="/npage/sm275/fm275CustOpen.jsp?inputFlag="+document.frm1100.inputFlag.value+"&custId="+document.frm1100.custId.value+"&regionCode="+document.frm1100.regionCode.value+"&districtCode="+document.frm1100.districtCode.value+"&custName="+document.frm1100.custName.value+"&custPwd="+document.frm1100.custPwd.value+"&custStatus="+document.frm1100.custStatus.value+"&custGrade="+document.frm1100.custGrade.value+"&ownerType="+document.frm1100.ownerType.value+"&custAddr="+document.frm1100.custAddr.value.replace(new RegExp("#","gm"),"%23")+"&idType="+document.frm1100.idType.value+"&idIccid="+document.frm1100.idIccid.value+"&idAddr="+document.frm1100.idAddr.value.replace(new RegExp("#","gm"),"%23")+"&idValidDate="+document.frm1100.idValidDate.value+"&contactPerson="+document.frm1100.contactPerson.value+"&contactPhone="+document.frm1100.contactPhone.value+"&contactAddr="+document.frm1100.contactAddr.value.replace(new RegExp("#","gm"),"%23")+"&contactPost="+document.frm1100.contactPost.value+"&contactMAddr="+document.frm1100.contactMAddr.value.replace(new RegExp("#","gm"),"%23")+"&contactFax="+document.frm1100.contactFax.value+"&contactMail="+document.frm1100.contactMail.value+"&unitCode="+document.frm1100.unitCode.value+"&parentId="+document.frm1100.parentId.value+"&custSex="+document.frm1100.custSex.value+"&birthDay="+document.frm1100.birthDay.value+"&professionId="+document.frm1100.professionId.value+"&vudyXl="+document.frm1100.vudyXl.value+"&custAh="+document.frm1100.custAh.value+"&custXg="+document.frm1100.custXg.value+"&unitXz="+document.frm1100.unitXz.value+"&yzlx="+document.frm1100.yzlx.value+"&yzhm="+document.frm1100.yzhm.value+"&yzrq="+document.frm1100.yzrq.value+"&frdm="+document.frm1100.frdm.value+"&groupCharacter=''"+"&workno="+document.frm1100.workno.value+"&sysNote="+document.frm1100.sysNote.value+"&opNote="+document.frm1100.opNote.value+"&opNote="+document.frm1100.opNote.value+"&ip_Addr="+document.frm1100.ip_Addr.value+"&oriGrpNo="+document.frm1100.oriGrpNo.value+"&instigate_flag"+document.frm1100.instigate_flag.value+"&getcontract_flag="+document.frm1100.getcontract_flag.value+"&filep="+document.frm1100.filep.value+"&card_flag="+document.frm1100.card_flag.value+"&m_flag="+document.frm1100.m_flag.value+"&sf_flag="+document.frm1100.sf_flag.value+"&idType="+document.frm1100.idType.value+"&pic_name="+document.all.pic_name.value+"&but_flag="+document.all.but_flag.value+"&isPre="+isPre+"&preUnitId="+document.all.preUnitId.value+"&IccIdAccept="+document.all.IccIdAccept.value
	          +"&opCode=<%=opCode%>"
	          +"&selU0002="+document.all.selU0002.value
	          +"&selU0003="+document.all.selU0003.value
		  			+"&selSvcLvl="+document.all.selSvcLvl.value
	          +"&isJSX="+document.all.isJSX.value
	          +"&gestoresName="+document.all.gestoresName.value
	          +"&gestoresAddr="+document.all.gestoresAddr.value.replace(new RegExp("#","gm"),"%23")
	          +"&gestoresIdType="+document.all.gestoresIdType.value
	          +"&gestoresIccId="+document.all.gestoresIccId.value
	        	+"&isDirectManageCust="+$("#isDirectManageCust").val()
	        	+"&directManageCustNo="+$("#directManageCustNo").val()
	        	+"&groupNo="+$("#groupNo").val()
	        	+"&myidNo="+$("#myidNo").val()
	        	+"&myofferId="+$("#myofferId").val()
	        	+"&myofferName="+$("#myofferName").val()
	        	+"&myofferType="+$("#myofferType").val()
	        	+"&myservBusiId="+$("#myservBusiId").val()
	        	+"&myofferInfoCode="+$("#myofferInfoCode").val()
	        	+"&myofferInfoValue="+$("#myofferInfoValue").val()
	        	+"&xsjbrxx="+xsjbrxx;
	        	
	       	
	        frm1100.submit();
	      }
    	}
      
    }
        
  }else{
      return false;
  }
}



/*��һ����ť����fm275To1104.jsp ����������������תҳ�����Ϣ*/
function nextStepOpen(){
	
	
		  	
	var productOfferTab = g("productOfferList");
	var rowNum = productOfferTab.rows.length;
	if(rowNum<=1)
	{
		rdShowMessageDialog("����ѡ������Ʒ!");
		return false;
	}
	
	/*2015/7/8 16:30:35 gaopeng R_CMI_HLJ_guanjg_2015_2310398@���ڹ��������봢������У԰ӭ��ϵͳ����ʾ
        	������������sXYYXInnetChk  �ж��Ƿ���Կ���
        */
	  var subFlag = false;
		var myPacket = new AJAXPacket("/npage/sm275/fm275InnetChk.jsp","���ڲ�ѯ��Ϣ�����Ժ�......");
	  myPacket.data.add("innetIdIccid",document.frm1100.idIccid.value); 
	  myPacket.data.add("iOpCode","<%=opCode%>");
	  myPacket.data.add("iOfferId",$("#myofferId").val());
	  
	  core.ajax.sendPacket(myPacket,function(packet){
	  	var retCode=packet.data.findValueByName("retCode");
		  var retMsg=packet.data.findValueByName("retMsg");
		  
		  if(retCode == "000000"){
		  	subFlag = true;
		 	}else{
		 		subFlag = false;
		 		rdShowMessageDialog("������룺"+retCode+",������Ϣ��"+retMsg,0);
				return  false;
		 	}
 		});
		myPacket = null;	
	if(subFlag){
		//if(rdShowConfirmDialog("ȷ��ѡ������ʷ���Ϣô��")==1) {
			
			var custId = $("#myCustId").val();
			var custName = $("#myCustName").val();
			
			var myidNo = $("#myidNo").val();
			var myofferId = $("#myofferId").val();
			var myofferName = $("#myofferName").val();
			var myofferType = $("#myofferType").val();
			var myservBusiId = $("#myservBusiId").val();
			var myofferInfoCode = $("#myofferInfoCode").val();
			var myofferInfoValue = $("#myofferInfoValue").val();
			
			var custPwd = $("input[name='custPwd']").val();
			custPwd = base64encode(utf16to8(custPwd));
			var path = "/npage/sm275/fm275To1104.jsp?opcode="+"m275";
				path += "&activePhone="+custName;
				path += "&opCode=<%=opCode%>";
				path += "&opName=У԰ӭ������";
				path += "&initOpenPhone="+custName;
				path += "&idNo="+myidNo;
				path += "&offerId="+myofferId;
				path += "&offerName="+myofferName;
				path += "&offerType="+myofferType;
				path += "&servBusiId="+myservBusiId;
				path += "&offerInfoCode="+myofferInfoCode;
				path += "&offerInfoValue="+myofferInfoValue;
				path += "&oCustId="+custId;
				path += "&oCustName="+custName;
				path += "&oCustPwd="+custPwd;
											
				var retPath = window.showModalDialog(path,null,"dialogWidth:350px;dialogHeight:350px;help:no;status:no");  
				if(retPath.length != 0){	
					$("#configBtn").attr("disabled","disabled");				
		  		myLoadTest(retPath);
		//  	}					
		
		}
	}
}

/*��ֵ���صĿͻ����� custID custName ��Ϣ*/
function setCustInfo(custId,custName){
	$("#myCustId").val(custId);
	$("#myCustName").val(custName);
	/*�û�*/
	$("input[name='print']").attr("disabled","disabled");
	/*��ȡ���ʷ���Ϣ,չʾ���ʷ���Ϣ�б�*/
	productOfferQryByAttr();
	$("#showAndHideUserOpen").show();
	readOnlyAllCustInfo("canReadOnlyAll");
}

/*�رչ��ﳵ*/
function toSopCar(){
	//hejwa 2012��8��27�� �жϹ��ﳵ �Ƿ����
	var D = parent.document.getElementById("tabtag").getElementsByTagName("li");
	for(var $=0;$<D.length;$++){
		if("custid" == D[$].id.substr(0,6)){//����һ�����ﳵ���ص����й��ﳵ
			parent.parent.removeTab(D[$].id);
			break;
		}
		if("m275" == D[$].id.substr(0,4)){
			parent.parent.removeTab(D[$].id);
			break;
		}
	}
	
}

function encryptPubJs(myCode)
{ 
	var code = myCode+"";
	var c = String.fromCharCode(code.charCodeAt(0)+code.length);
	for(var i=1;i<code.length;i++){
		c+=String.fromCharCode(code.charCodeAt(i)+code.charCodeAt(i-1));
	}
	return escape(c);
}
function decryptPubJs(myCode)
{
	var code = myCode+"";
	code=unescape(code);
	var c=String.fromCharCode(code.charCodeAt(0)-code.length);
	for(var i=1;i<code.length;i++){
		c+=String.fromCharCode(code.charCodeAt(i)-c.charCodeAt(i-1));
	}
	return c;
}


function myLoadTest(path){
	path = path+"&newMath="+Math.random();
	document.getElementById("myLoadSome").innerHTML = "<iframe frameBorder=\"0\" id=\"iClassCodeFrame\" align=\"center\" name=\"iClassCodeFrame\" scrolling=\"no\" style=\"height:100%; visibility:inherit; width:100%; z-index:1; \" onload=\"document.getElementById('iClassCodeFrame').style.height=iClassCodeFrame.document.body.scrollHeight+'px'\" src='"+path+"'></iframe>";
	//document.getElementById('iClassCodeFrame').style.height=iClassCodeFrame.document.body.scrollHeight+'px';
	
}

/*2010-8-9 8:43 wanghfa���� ��֤������ڼ� start*/
function checkPwdEasy(pwd) {
  
  if(pwd == ""){
    rdShowMessageDialog("�����������룡");
    return ;
  }
  
  var checkPwd_Packet = new AJAXPacket("../public/pubCheckPwdEasy.jsp","������֤�����Ƿ���ڼ򵥣����Ժ�......");
  checkPwd_Packet.data.add("password", pwd);
  checkPwd_Packet.data.add("phoneNo", "00000000000");
  checkPwd_Packet.data.add("idNo", frm1100.idIccid.value);
  checkPwd_Packet.data.add("opCode", "1100");
  checkPwd_Packet.data.add("custId", "");

  core.ajax.sendPacket(checkPwd_Packet, doCheckPwdEasy);
  checkPwd_Packet=null;
}

function doCheckPwdEasy(packet) {
  var retResult = packet.data.findValueByName("retResult");
  if (retResult == "1") {
    rdShowMessageDialog("�𾴵Ŀͻ������������õ�����Ϊ��ͬ���������룬��ȫ�Խϵͣ�Ϊ�˸��õر���������Ϣ��ȫ���������ð�ȫ�Ը��ߵ����롣");
    document.all.custPwd.value="";
    document.all.cfmPwd.value="";
    return;
  } else if (retResult == "2") {
    rdShowMessageDialog("�𾴵Ŀͻ������������õ�����Ϊ���������룬��ȫ�Խϵͣ�Ϊ�˸��õر���������Ϣ��ȫ���������ð�ȫ�Ը��ߵ����롣");
    document.all.custPwd.value="";
    document.all.cfmPwd.value="";
    return;
  } else if (retResult == "3") {
    rdShowMessageDialog("�𾴵Ŀͻ������������õ�����Ϊ�ֻ������е��������֣���ȫ�Խϵͣ�Ϊ�˸��õر���������Ϣ��ȫ���������ð�ȫ�Ը��ߵ����롣");
    document.all.custPwd.value="";
    document.all.cfmPwd.value="";
    return;
  } else if (retResult == "4") {
    rdShowMessageDialog("�𾴵Ŀͻ������������õ�����Ϊ֤���е��������֣���ȫ�Խϵͣ�Ϊ�˸��õر���������Ϣ��ȫ���������ð�ȫ�Ը��ߵ����롣");
    document.all.custPwd.value="";
    document.all.cfmPwd.value="";
    return;
  } else if (retResult == "0") {
   
  } 
}


function chkValid()
{
     var d= (new Date().getFullYear().toString()+(((new Date().getMonth()+1).toString().length>=2)?(new Date().getMonth()+1).toString():("0"+(new Date().getMonth()+1)))+(((new Date().getDate()).toString().length>=2)?(new Date().getDate()):("0"+(new Date().getDate()))).toString());

   if((frm1100.idValidDate.value).trim().length>0)
   {     
        if(validDate(frm1100.idValidDate)==false) return false;

      if(to_date(frm1100.idValidDate)<=d)
      {
      rdShowMessageDialog("֤����Ч�ڲ������ڵ�ǰʱ�䣬���������룡");
        document.all.idValidDate.focus();
      document.all.idValidDate.select();
        return false;
      }
  }
}

function validDate(obj)
{
  var theDate="";
  var one="";
  var flag="0123456789";
  for(i=0;i<obj.value.length;i++)
  { 
     one=obj.value.charAt(i);
     if(flag.indexOf(one)!=-1)
     theDate+=one;
  }
  if(theDate.length!=8)
  {
  rdShowMessageDialog("���ڸ�ʽ������ȷ��ʽΪ�����������������ա������������룡");
  
  obj.select();
  obj.focus();
  return false;
  }
  else
  {
     var year=theDate.substring(0,4);
   var month=theDate.substring(4,6);
   var day=theDate.substring(6,8);
   if(myParseInt(year)<1900 || myParseInt(year)>3000)
   {
       rdShowMessageDialog("��ĸ�ʽ������Ч���Ӧ����1900-3000֮�䣬���������룡");
     
     obj.select();
     obj.focus();
     return false;
   }
     if(myParseInt(month)<1 || myParseInt(month)>12)
   {
       rdShowMessageDialog("�µĸ�ʽ������Ч�·�Ӧ����01-12֮�䣬���������룡");
       
     obj.select();
     obj.focus();
     return false;
   }
     if(myParseInt(day)<1 || myParseInt(day)>31)
   {
       rdShowMessageDialog("�յĸ�ʽ������Ч����Ӧ����01-31֮�䣬���������룡");
    
     obj.select();
       obj.focus();
     return false;
   }

     if (month == "04" || month == "06" || month == "09" || month == "11")             
   {
         if(myParseInt(day)>30)
         {
         rdShowMessageDialog("���·����30��,û��31�ţ�");
         
       obj.select();
           obj.focus();
             return false;
         }
      }                 
       
      if (month=="02")
      {
         if(myParseInt(year)%4==0 && myParseInt(year)%100!=0 || (myParseInt(year)%4==0 && myParseInt(year)%400==0))
     {
           if(myParseInt(day)>29)
       {
         rdShowMessageDialog("������·����29�죡");
             //obj.value="";
       obj.select();
           obj.focus();
             return false;
       }
     }
     else
     {
           if(myParseInt(day)>28)
       {
         rdShowMessageDialog("��������·����28�죡");
             //obj.value="";
       obj.select();
          obj.focus();
           return false;
       }
     }
      }
  }
  return true;
}

function myParseInt(nu)
{
  var ret=0;
  if(nu.length>0)
  {
    if(nu.substring(0,1)=="0")
  {
       ret=parseInt(nu.substring(1,nu.length));
  }
  else
  {
       ret=parseInt(nu);
  }
  }
  return ret;
}
function to_date(obj)
{
  var theTotalDate="";
  var one="";
  var flag="0123456789";
  for(i=0;i<obj.value.length;i++)
  { 
     one=obj.value.charAt(i);
     if(flag.indexOf(one)!=-1)
     theTotalDate+=one;
  }
  return theTotalDate;
}





function checkPwd(obj1,obj2)
{
        //����һ����У��,����У��
        var pwd1 = obj1.value;
        var pwd2 = obj2.value;
        if(pwd1 != pwd2)
        {
                var message = "�û������ȷ���û����벻һ�£����������룡";
                rdShowMessageDialog(message,0);
                if(obj1.type != "hidden")
                {   obj1.value = "";    }
                if(obj2.type != "hidden")
                {   obj2.value = "";    }
                obj1.focus();
                return false;
        }
        return true;
}

function check_HidPwd(Pwd1,Pwd1Type,Pwd2,Pwd2Type)
{
  /*
      Pwd1,Pwd2:����
      wd1Type:����1�����ͣ�Pwd2Type������2������      show:���룻hid������
    
  if((Pwd1).trim().length==0)
  {
        rdShowMessageDialog("�ͻ����벻��Ϊ�գ�",0);
        frm1100.custPwd.focus();
    return false;
  }
    else 
  {
     if((Pwd2).trim().length==0)
     {
         rdShowMessageDialog("ԭʼ�ͻ�����Ϊ�գ���˶����ݣ�",0);
         frm1100.custPwd.focus();
     return false;
     }
  }*/
  var checkPwd_Packet = new AJAXPacket("/npage/sq100/pubCheckPwd.jsp","���ڽ�������У�飬���Ժ�......");
  checkPwd_Packet.data.add("retType","checkPwd"); 
  checkPwd_Packet.data.add("Pwd1",Pwd1);
  checkPwd_Packet.data.add("Pwd1Type",Pwd1Type);
  checkPwd_Packet.data.add("Pwd2",(Pwd2).trim());
  checkPwd_Packet.data.add("Pwd2Type",Pwd2Type);
  core.ajax.sendPacket(checkPwd_Packet);
  checkPwd_Packet=null;
  
  if("<%=regionCode%>"=="09"){
    if(pwd1 == "000000"||pwd1 == "111111"||pwd1 == "222222"
     ||pwd1 == "333333"||pwd1 == "444444"||pwd1 == "555555"
     ||pwd1 == "666666"||pwd1 == "777777"||pwd1 == "888888"
     ||pwd1 == "999999"||pwd1 == "123456")
    {
      rdShowMessageDialog("������ڼ򵥣����޸ĺ��ٰ���ҵ��");
      return false;
    }
  }   
}

function getId()
{
    /*�õ��ͻ�ID*/
        document.frm1100.custId.readonly = true;
        document.frm1100.custQuery.disabled = true;   
        var getUserId_Packet = new AJAXPacket("/npage/sq100/f1100_getId.jsp","���ڻ�ÿͻ�ID�����Ժ�......");
      getUserId_Packet.data.add("retType","ClientId");
        getUserId_Packet.data.add("region_code","<%=regionCode%>");
        getUserId_Packet.data.add("idType","0");
        getUserId_Packet.data.add("oldId","0");
        core.ajax.sendPacket(getUserId_Packet);
        getUserId_Packet=null;
}
function getInfo_IccId_JustSee()
{ 
    var Str = document.all.idType.value;
   
      if(Str.indexOf("����֤") > -1){
        if($("#idIccid").val().length<18){
          rdShowMessageDialog("����֤���������18λ��");
          document.all.idIccid.focus();
          return false;
        }
      }
    
 
    /*���ݿͻ�֤������õ������Ϣ*/
    if(document.frm1100.idIccid.value.trim().len() == 0)
    {
        rdShowMessageDialog("������ͻ�֤�����룡");
        return false;
    }
  /*liujian 2013-5-15 9:24:11 �޸��½��ͻ��͹�������,����֤����ֻ������18λ��֤������,�������15λ��,�뱨��*/
  var item = $("#idTypeSelect option[@selected]").text();
  if(item == '����֤' && document.frm1100.idIccid.value.trim().len() != 18) {
        rdShowMessageDialog("����֤֤�����볤�ȱ�����18λ��");
        return false;
  }
  
    var pageTitle = "�ͻ���Ϣ��ѯ";
    var fieldName = "�������|����ʱ��|֤������|֤������|������|״̬|";
    /**
    var sqlStr = "select c.phone_no,
    to_char(a.CREATE_TIME,'YYYY-MM-DD HH24:MI:SS'),
    b.ID_NAME,
    a.ID_ICCID," +
    " trim(e.REGION_NAME)||'-->'||trim(f.DISTRICT_NAME)," + 
    " d.run_name
                      from DCUSTDOC a,SIDTYPE b ,DCustMsg c ,sRuncode d ,sregioncode e,sdiscode f where a.region_code=d.region_code and substr(c.run_code,2,1)=d.run_code and  a.cust_id=c.cust_id and b.ID_TYPE = a.ID_TYPE " +
                     " and a.region_code=e.region_code and a.region_code=f.region_code and
                      a.district_code=f.district_code and  a.ID_ICCID = '" + 
                      document.frm1100.idIccid.value + "' and substr(c.run_code,2,1)<'a'
                        and rownum<500 order by a.cust_name asc,a.create_time desc "; 
    */
    var selType = "S";    /*'S'��ѡ��'M'��ѡ*/
    var retQuence = "7|0|1|3|4|5|6|7|";
    var retToField = "in0|in4|in3|in2|in5|in6|in1|";
    
    custInfoQueryJustSee(document.frm1100.idIccid.value);                    
}
function custInfoQueryJustSee(idIccid)
{
    var path = "/npage/sq100/getCustInfo.jsp";
    path = path + "?idIccid=" + idIccid;
    window.showModalDialog(path,"","dialogWidth:60;dialogHeight:35;");
}

function choiceSelWay()
{ 
  if(frm1100.parentIdidIccid.value != "")
  { /*�ͻ�֤������*/
    getInfo_IccId();
    return true;
  }
  if(frm1100.parentName.value != "")
  { /*�ͻ�����*/
    getInfo_withName();
    return true;
  }
  rdShowMessageDialog("�ͻ���Ϣ������ID��֤����������ƽ��в�ѯ��������������������Ϊ��ѯ������",0);
}

function getInfo_withId()
{
    //���ݿͻ�ID�õ������Ϣ
    if(document.frm1100.parentId.value == "")
    {
        rdShowMessageDialog("������ͻ�ID��",0);
        return false;
    }
  else
  {
    if((document.all.parentId.value).trim().length>14)
    {
         rdShowMessageDialog("�ͻ�ID��������",0);
         return false;
    }
  }
    if(for0_9(frm1100.parentId) == false)
    { 
      frm1100.parentId.value = "";
      return false; 
    }
    var getIdPacket = new AJAXPacket("/npage/sq100/f1100_rpc.jsp","���ڻ���ϼ��ͻ���Ϣ�����Ժ�......");
        var parentId = document.frm1100.parentId.value;
        getIdPacket.data.add("retType","getInfo_withID");
        getIdPacket.data.add("fieldNum","6");
        getIdPacket.data.add("sqlStr","");
        core.ajax.sendPacket(getIdPacket);
        getIdPacket=null; 
}   
function for0_9(obj) //�ж��ַ��Ƿ���0��9���������
{  
  
    if (!forString(obj)){
    ltflag = 1;
    obj.select();
    obj.focus();
    return false;
  }else{
    if (obj.value.length == 0){
      return true;
    }
  }    
  if (!isMadeOf(obj.value,numStr)){
      flag = 1;
      rdShowMessageDialog("'" + obj.v_name + "'��ֵ����ȷ�����������֣�");
    obj.select();
    obj.focus();
    return false;
    } 
  return true;  
}
function isMadeOf(val,str)
{

  var jj;
  var chr;
  for (jj=0;jj<val.length;++jj){
    chr=val.charAt(jj);
    if (str.indexOf(chr,0)==-1)
      return false;     
  }
  
  return true;
}
function custInfoQuery(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
    /*
    ����1(pageTitle)����ѯҳ�����
    ����2(fieldName)�����������ƣ���'|'�ָ��Ĵ�
    ����3(sqlStr)��sql���
    ����4(selType)������1 rediobutton 2 checkbox
    ����5(retQuence)����������Ϣ������������� �������ʶ����'|'�ָ�����"3|0|2|3"��ʾ����3����0��2��3
    ����6(retToField))������ֵ����������,��'|'�ָ�
    */
    /*var path = "../../page/public/fPubSimpSel.jsp";  ������ʾ*/
    var path = "/npage/sq100/pubGetCustInfo.jsp";   //����Ϊ*
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;  
    /*
    var ret = window.open (path, "���д���", 
          "height=400, width=600,left=200, top=200,toolbar=no,menubar=no, scrollbars=yes, resizable=no, location=no, status=yes"); 
  ret.opener.bankCode.value = "1111111111";
  */
    var retInfo = window.showModalDialog(path,"","dialogWidth:70;dialogHeight:35;");
    if(typeof(retInfo) == "undefined")     
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
  rpc_chkX("parentIdType","parentIdidIccid","B");
}

function getInfo_withName()
{ 
        /*���ݿͻ����Ƶõ������Ϣ*/
    if(document.frm1100.parentName.value == "")
    {
        rdShowMessageDialog("������ͻ����ƣ�",0);
        return false;
    }
    var pageTitle = "�ͻ���Ϣ��ѯ";
    var fieldName = "�ͻ�ID|�ͻ�����|����ʱ��|֤������|֤������|�ͻ���ַ|��������|�ͻ�����|";
    var sqlStr = "";
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "7|0|1|3|4|5|6|7|";
    var retToField = "in0|in4|in3|in2|in5|in6|in1|"; 
    custInfoQuery(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)                           
    
    rpc_chkX("parentIdType","parentIdidIccid","B");
}


function getInfo_IccId()
{ 
    /*���ݿͻ�֤������õ������Ϣ*/
    if((document.frm1100.parentIdidIccid.value).trim().length == 0)
    {
        rdShowMessageDialog("������ͻ�֤�����룡",0);
        return false;
    }
  else if((document.frm1100.parentIdidIccid.value).trim().length < 5)
  {
        rdShowMessageDialog("֤�����볤������������λ����",0);
        return false;
  }

    var pageTitle = "�ͻ���Ϣ��ѯ";
    var fieldName = "�ͻ�ID|�ͻ�����|����ʱ��|֤������|֤������|�ͻ���ַ|��������|�ͻ�����|";
    var sqlStr = "";
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "7|0|1|3|4|5|6|7|";
    var retToField = "in0|in4|in3|in2|in5|in6|in1|";
     custInfoQuery(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);                    
     
}

function get_inPara()
{
    /*��֯���˵Ĳ���*/
    var inPara_Str = "";    
        inPara_Str = inPara_Str + document.frm1100.temp_custId.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.regionCode.value + "|" + document.frm1100.districtCode.value + "|";
        inPara_Str = inPara_Str + document.frm1100.custName.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.custPwd.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.custStatus.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.custGrade.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.ownerType.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.custAddr.value + "|";
        var tempStr = document.frm1100.idType.value; 
        inPara_Str = inPara_Str + tempStr.substring(0,tempStr.indexOf("|")) + "|"; 
        inPara_Str = inPara_Str + document.frm1100.idIccid.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.idAddr.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.idValidDate.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactPerson.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactPhone.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactAddr.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactPost.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactMAddr.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactFax.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.contactMail.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.unitCode.value + "|"; //��������
        inPara_Str = inPara_Str + document.frm1100.parentId.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.custSex.value + "|";  //�ͻ��Ա�
        inPara_Str = inPara_Str + document.frm1100.birthDay.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.professionId.value + "|"; 
        inPara_Str = inPara_Str + document.frm1100.vudyXl.value + "|"; //ѧ��
        inPara_Str = inPara_Str + document.frm1100.custAh.value + "|"; //�ͻ����� 
        inPara_Str = inPara_Str + document.frm1100.custXg.value + "|"; //�ͻ�ϰ��
        inPara_Str = inPara_Str + document.frm1100.unitXz.value + "|"; //��λ����
        inPara_Str = inPara_Str + document.frm1100.yzlx.value + "|"; //ִ������
        inPara_Str = inPara_Str + document.frm1100.yzhm.value + "|"; //ִ�պ���
        inPara_Str = inPara_Str + document.frm1100.yzrq.value + "|"; //ִ����Ч��
        inPara_Str = inPara_Str + document.frm1100.frdm.value + "|"; //���˴���
        inPara_Str = inPara_Str + document.frm1100.groupCharacter.value + "|";//Ⱥ����Ϣ
        inPara_Str = inPara_Str + "1100" + "|";
        inPara_Str = inPara_Str + document.frm1100.workno.value + "|";  
        inPara_Str = inPara_Str + document.frm1100.sysNote.value + "|";
        inPara_Str = inPara_Str + document.frm1100.opNote.value + "|";  
        document.frm1100.inParaStr.value = inPara_Str;
}


function jspReset()
{
    /*ҳ��ؼ���ʼ�� */   
    var obj = null;
    var t = null;
        var i;
    for (i=0;i<document.frm1100.length;i++)
    {    
                obj = document.frm1100.elements[i];                                              
                packUp(obj); 
            obj.disabled = false;
    }
    document.frm1100.commit.disabled = "none"; 
} 
 
function jspCommit()
{
         /*ҳ���ύ*/
         document.frm1100.commit.disabled = "none";
         action="/npage/sm275/fm275CustOpen.jsp?opCode=<%=opCode%>"
         frm1100.submit();   /*����������������ύ*/
}

function change_ConPerson()
{   
  /*��ϵ��������ͻ����Ƹ������ı�*/
  if(document.all.ownerType.value=="02"){
    frm1100.contactPerson.value = frm1100.custName.value;
    /*document.all.print.disabled=true;*/
  }
}
function change_ConAddr(obj)
{   /*��ϵ��������ͻ����Ƹ������ı�*/
	
  
}

function checkName(){
  if(!forString(document.all.custName)){
    return false;
  }
  var custName=document.all.custName.value;
  var checkPwd_Packet = new AJAXPacket("/npage/sq100/f1100_checkName.jsp?custName="+custName,"���ڽ��пͻ�����У�飬���Ժ�......");
  checkPwd_Packet.data.add("retType","checkName");
  core.ajax.sendPacket(checkPwd_Packet);
  checkPwd_Packet=null;
}

function changeCardAddr(obj){
  var Str = document.all.idType.value;
  
    if((Str.indexOf("����֤") > -1)||(Str.indexOf("���ڲ�") > -1)){
      if(obj.value.length<8){
        rdShowMessageDialog("Ҫ��8�������Ϻ��֣����������룡");
        obj.focus();
  			return false;
      }
    }
  
  if(document.all.ownerType.value=="01"){
    document.all.custAddr.value=obj.value;
    document.all.contactAddr.value=obj.value;
    document.all.contactMAddr.value=obj.value;
  }
}

function chcek_pic()/*����֤*/
{
  
var pic_path = document.all.filep.value;
  
var d_num = pic_path.indexOf("\.");
var file_type = pic_path.substring(d_num+1,pic_path.length);
/*�ж��Ƿ�Ϊjpg���� //�����豸����ͼƬ�̶�Ϊjpg����*/
if(file_type.toUpperCase()!="JPG")
{ 
    rdShowMessageDialog("��ѡ��jpg����ͼ���ļ�");
    document.all.up_flag.value=3;
    /*document.all.print.disabled=true;*/
    resetfilp();
  return ;
  }

  var pic_path_flag= document.all.pic_name.value;
  
  if(pic_path_flag=="")
  {
  rdShowMessageDialog("����ɨ����ȡ֤����Ϣ");
  document.all.up_flag.value=4;
  /*document.all.print.disabled=true;*/
  resetfilp();
  return;
}
  else
    {
      if(pic_path!=pic_path_flag)
      {
      rdShowMessageDialog("��ѡ�����һ��ɨ����ȡ֤�������ɵ�֤��ͼ���ļ�"+pic_path_flag);
      document.all.up_flag.value=5;
      /*document.all.print.disabled=true;*/
      resetfilp();
    return;
    }
    else{
      document.all.up_flag.value=2;
      }
      }
      
  }
  
/*** dujl add at 20090806 for R_HLJMob_cuisr_CRM_PD3_2009_0314@���ڹ淶�ͻ����������л��������зǷ��ַ�У������� ****/


/**** tianyang add for �����ַ����� start ****/ 

/*function feifaCustName(textName)
{
  if(textName.value != "")
  {
      if((textName.value.indexOf("~")) != -1 || (textName.value.indexOf("|")) != -1 || (textName.value.indexOf(";")) != -1)
      {
        rdShowMessageDialog("����������Ƿ��ַ������������룡");
        textName.value = "";
          return;
      }
  }
}*/

function feifaCustName(textName)
{
  if(textName.value != "")
  {
    if(document.all.ownerType.value=="01"&&document.all.isJSX.value=="0"){
      var m = /^[\u0391-\uFFE5]+$/;
      var flag = m.test(textName.value);
      if(!flag){
        rdShowMessageDialog("ֻ�����������ģ�");
        reSetCustName();
      }
      if(textName.value.length > 6){
        rdShowMessageDialog("ֻ��������6�����֣�");
        reSetCustName();
      }
    }else{
      if((textName.value.indexOf("~")) != -1 || (textName.value.indexOf("|")) != -1 || (textName.value.indexOf(";")) != -1)
      {
        rdShowMessageDialog("����������Ƿ��ַ������˿���������ѡ������ſ�����");
        textName.value = "";
          return;
      }
    }
  }
}
function forKuoHao(obj){ //�����������š�.�� �⼸�ָ���
	var m = /^(\(?\)?\��?\��?)\��|\.|\��+$/;
  	var flag = m.test(obj);
  	if(!flag){
  		return false;
  	}else{
  		return true;
  	}
}
function forEnKuoHao(obj){
	var m = /^(\(?\)?)+$/;
  	var flag = m.test(obj);
  	if(!flag){
  		return false;
  	}else{
  		return true;
  	}
}
function forHanZi1(obj)
  {
  	var m = /^[\u0391-\uFFE5]+$/;
  	var flag = m.test(obj);
  	if(!flag){
  		//showTip(obj,"�������뺺�֣�");
  		return false;
  	}
  		if (!isLengthOf(obj,obj.v_minlength*2,obj.v_maxlength*2)){
  		//showTip(obj,"�����д���");
  		return false;
  	}
  	return true;
  }
  
  //ƥ����26��Ӣ����ĸ��ɵ��ַ���
  function forA2sssz1(obj)
  {
  	var patrn = /^[A-Za-z]+$/;
  	var sInput = obj;
  	if(sInput.search(patrn)==-1){
  		//showTip(obj,"����Ϊ��ĸ��");
  		return false;
  	}
  	if (!isLengthOf(obj,obj.v_minlength,obj.v_maxlength)){
  		//showTip(obj,"�����д���");
  		return false;
  	}
  
  	return true;
  }
  
/*
	2013/11/15 15:33:56 gaopeng ���ڽ�һ������ʡ��֧��ϵͳʵ���Ǽǹ��ܵ�֪ͨ  
	ע�⣺ֻ��Ը��˿ͻ� start
*/  

/*1���ͻ����ơ���ϵ������ У�鷽�� objType 0 �����ͻ�����У�� 1������ϵ������У��  ifConnect �����Ƿ�������ֵ(���ȷ�ϰ�ťʱ��������������ֵ)*/
function checkCustNameFunc(obj,objType,ifConnect){
	var nextFlag = true;
	var objName = "";
	var idTypeVal = "";
	if(objType == 0){
		objName = "�ͻ�����";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "��ϵ������";
		idTypeVal = document.all.idType.value;
	}
	/*2013/12/16 11:24:47 gaopeng ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭��������*/
	if(objType == 2){
		objName = "����������";
		/*�����վ�����֤������*/
		idTypeVal = document.all.gestoresIdType.value;
	}
	
	idTypeVal = $.trim(idTypeVal);
	
	/*ֻ��Ը��˿ͻ�*/
	var opCode = "<%=opCode%>";
	/*��ȡ������ֵ*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*��ȡ�����ֵ�ĳ���*/
	var objValueLength = objValue.length;
	if(objValue != ""){
		/* ��ȡ��ѡ���֤������ 
		0|����֤ 1|����֤ 2|���ڲ� 3|�۰�ͨ��֤ 
		4|����֤ 5|̨��ͨ��֤ 6|��������� 7|���� 
		8|Ӫҵִ�� 9|���� A|��֯�������� B|��λ����֤�� C|������ 
		*/
		/*��ȡ֤���������� */
		var idTypeText = idTypeVal.split("|")[0];
		
		/*����ʱ�����������Ķ�����*/
		if(objValue.indexOf("��ʱ") != -1 || objValue.indexOf("����") != -1){
					rdShowMessageDialog(objName+"���ܴ��С���ʱ���򡮴��졯������");
					
					nextFlag = false;
					return false;
			
		}
		
		/*�ͻ����ơ���ϵ��������Ҫ�󡰴��ڵ���2�����ĺ��֡�����������ճ��⣨��������տͻ����Ʊ������3���ַ�����ȫΪ����������)*/
		
		/*����������������*/
		if(idTypeText != "6"){
			/*ԭ�е�ҵ���߼�У�� ֻ������Ӣ�ġ����֡����ġ����ġ����ġ���������һ�����ԣ�*/
			
			/*2014/08/27 16:14:22 gaopeng ���ֹ�˾�����Ż������������Ƶ���ʾ Ҫ��λ�ͻ�ʱ���ͻ����ƿ�����дӢ�Ĵ�Сд��� Ŀǰ�ȸ�ɸ� idTypeText == "3" || idTypeText == "9" һ�����߼� �������ʿɲ�����*/
			if(idTypeText == "3" || idTypeText == "9" || idTypeText == "8" || idTypeText == "A" || idTypeText == "B" || idTypeText == "C"){
				if(objValueLength < 2){
					rdShowMessageDialog(objName+"������ڵ���2�����֣�");
					nextFlag = false;
					return false;
				}
				 var KH_length = 0;
		     var EH_length = 0;
		     var RU_length = 0;
		     var FH_length = 0;
		     var JP_length = 0;
		     var KR_length = 0;
		     var CH_length = 0;
         
         for (var i = 0; i < objValue.length; i ++){
            var code = objValue.charAt(i);//�ֱ��ȡ��������
            var key = checkNameStr(code); //У��
            if(key == undefined){
              rdShowMessageDialog("ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
              obj.value = "";
              
              nextFlag = false;
              return false;
            }
            if(key == "KH"){
            	KH_length++;
            }
            if(key == "EH"){
            	EH_length++;
            }
            if(key == "RU"){
            	RU_length++;
            }
            if(key == "FH"){
            	FH_length++;
            }
            if(key == "JP"){
            	JP_length++;
            }
            if(key == "KR"){
            	KR_length++;
            }
            if(key == "CH"){
            	CH_length++;
            }
         
         }	
            var machEH = KH_length + EH_length;
            var machRU = KH_length + RU_length;
            var machFH = KH_length + FH_length;
            var machJP = KH_length + JP_length;
            var machKR = KH_length + KR_length;
            var machCH = KH_length + CH_length;
            
            
            if((objValueLength != machEH 
            && objValueLength != machRU
            && objValueLength != machFH
            && objValueLength != machJP
            && objValueLength != machKR
            && objValueLength != machCH ) || objValueLength == KH_length){
            		rdShowMessageDialog("ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
                obj.value = "";
              	nextFlag = false;
                return false;
            }
       }
       else{
					
					/*��ȡ�������ĺ��ֵĸ����Լ�'()����'�ĸ���*/
					var m = /^[\u0391-\uFFE5]*$/;
					var mm = /^��|\.|\��*$/;
					var chinaLength = 0;
					var kuohaoLength = 0;
					var zhongjiandianLength=0;
					for (var i = 0; i < objValue.length; i ++){
								
			          var code = objValue.charAt(i);//�ֱ��ȡ��������
			          var flag22=mm.test(code);
			          var flag = m.test(code);
			          /*��У������*/
			          if(forKuoHao(code)){
			          	kuohaoLength ++;
			          }else if(flag){
			          	chinaLength ++;
			          }else if(flag22){
			          	zhongjiandianLength++;
			          }
			          
			    }
			    var machLength = chinaLength + kuohaoLength+zhongjiandianLength;
					/*���ŵ�����+���ֵ����� != ������ʱ ��ʾ������Ϣ(������Ҫע��һ�㣬��������Ҳ�����ġ�������������ֻ����Ӣ�����ŵ�ƥ������������ƥ����)*/
					if(objValueLength != machLength || chinaLength == 0){
						rdShowMessageDialog(objName+"�����������Ļ����������ŵ����(���ſ���Ϊ���Ļ�Ӣ�����š�()������)��");
						/*��ֵΪ��*/
						obj.value = "";
						
						nextFlag = false;
						return false;
					}else if(objValueLength == machLength && chinaLength != 0){
						if(objValueLength < 2){
							rdShowMessageDialog(objName+"������ڵ���2�����ĺ��֣�");
							
							nextFlag = false;
							return false;
						}
					}
					/*ԭ���߼�
					if(idTypeText == "0" || idTypeText == "2"){
						if(objValueLength > 6){
							rdShowMessageDialog(objName+"�������6�����֣�");
							
							nextFlag = false;
							return false;
						}
				}
				*/
			}
       
		}
		/*�������������� У�� ��������տͻ�����(������������ϵ������Ҳͬ��(sunaj��ȷ��))�������3���ַ�����ȫΪ����������*/
		if(idTypeText == "6"){
			/*���У��ͻ�����*/
				if(objValue % 2 == 0 || objValue % 2 == 1){
						rdShowMessageDialog(objName+"����ȫΪ����������!");
						/*��ֵΪ��*/
						obj.value = "";
						
						nextFlag = false;
						return false;
				}
				if(objValueLength <= 3){
						rdShowMessageDialog(objName+"������������ַ�!");
						
						nextFlag = false;
						return false;
				}
				var KH_length = 0;
		     var EH_length = 0;
		     var RU_length = 0;
		     var FH_length = 0;
		     var JP_length = 0;
		     var KR_length = 0;
		     var CH_length = 0;
         
         for (var i = 0; i < objValue.length; i ++){
            var code = objValue.charAt(i);//�ֱ��ȡ��������
            var key = checkNameStr(code); //У��
            if(key == undefined){
              rdShowMessageDialog("ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
              obj.value = "";
              
              nextFlag = false;
              return false;
            }
            if(key == "KH"){
            	KH_length++;
            }
            if(key == "EH"){
            	EH_length++;
            }
            if(key == "RU"){
            	RU_length++;
            }
            if(key == "FH"){
            	FH_length++;
            }
            if(key == "JP"){
            	JP_length++;
            }
            if(key == "KR"){
            	KR_length++;
            }
            if(key == "CH"){
            	CH_length++;
            }
         
         }	
            var machEH = KH_length + EH_length;
            var machRU = KH_length + RU_length;
            var machFH = KH_length + FH_length;
            var machJP = KH_length + JP_length;
            var machKR = KH_length + KR_length;
            var machCH = KH_length + CH_length;
            
            
            if((objValueLength != machEH 
            && objValueLength != machRU
            && objValueLength != machFH
            && objValueLength != machJP
            && objValueLength != machKR
            && objValueLength != machCH ) || objValueLength == KH_length){
            		rdShowMessageDialog("ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
                obj.value = "";
              	nextFlag = false;
                return false;
            }
				
		}
		
		
		if(ifConnect == 0){
		if(nextFlag){
		 if(objType == 0){
		 	/*��ϵ��������ͻ����Ƹ������ı�*/
			  if(document.all.ownerType.value=="02"){
			    document.frm1100.contactPerson.value = frm1100.custName.value;
			    /*document.all.print.disabled=true;*/
			  }
		 	}	
		}
		}
		
	}	
	return nextFlag;
}


/*
	2013/11/18 11:15:44
	gaopeng
	�ͻ���ַ��֤����ַ����ϵ�˵�ַУ�鷽��
	���ͻ���ַ������֤����ַ���͡���ϵ�˵�ַ�����衰���ڵ���8�����ĺ��֡�
	����������պ�̨��ͨ��֤���⣬���������Ҫ�����2�����֣�̨��ͨ��֤Ҫ�����3�����֣�
*/

function checkAddrFunc(obj,objType,ifConnect){
	var nextFlag = true;
	var objName = "";
	var idTypeVal = ""
	if(objType == 0){
		objName = "֤����ַ";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "�ͻ���ַ";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 2){
		objName = "��ϵ�˵�ַ";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 3){
		objName = "��ϵ��ͨѶ��ַ";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 4){
		objName = "��������ϵ��ַ";
		idTypeVal = document.all.gestoresIdType.value;
	}
	idTypeVal = $.trim(idTypeVal);
	/*ֻ��Ը��˿ͻ�*/
	var opCode = "<%=opCode%>";
	/*��ȡ������ֵ*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*��ȡ�����ֵ�ĳ���*/
	var objValueLength = objValue.length;
	
	if(objValue != ""){
		/* ��ȡ��ѡ���֤������ 
		0|����֤ 1|����֤ 2|���ڲ� 3|�۰�ͨ��֤ 
		4|����֤ 5|̨��ͨ��֤ 6|��������� 7|���� 
		8|Ӫҵִ�� 9|���� A|��֯�������� B|��λ����֤�� C|������ 
		*/
		
		/*��ȡ֤���������� */
		var idTypeText = idTypeVal.split("|")[0];
		
		/*��ȡ�������ĺ��ֵĸ���*/
		var m = /^[\u0391-\uFFE5]*$/;
		var chinaLength = 0;
		for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//�ֱ��ȡ��������
          var flag = m.test(code);
          if(flag){
          	chinaLength ++;
          }
    }
      
		/*����Ȳ������������ Ҳ����̨��ͨ��֤ */
		if(idTypeText != "6" && idTypeText != "5"){
			/*��������8�����ĺ���*/
			if(chinaLength < 8){
				rdShowMessageDialog(objName+"���뺬������8�����ĺ��֣�");
				/*��ֵΪ��*/
				obj.value = "";
				
				nextFlag = false;
				return false;
			}
		
	}
	/*��������� ����2������*/
	if(idTypeText == "6"){
		/*����2�����ĺ���*/
			if(chinaLength <= 2){
				rdShowMessageDialog(objName+"���뺬�д���2�����ĺ��֣�");
				
				nextFlag = false;
				return false;
			}
	}
	/*̨��ͨ��֤ ����3������*/
	if(idTypeText == "5"){
		/*��������3���ĺ���*/
			if(chinaLength <= 3){
				rdShowMessageDialog(objName+"���뺬�д���3�����ĺ��֣�");
				
				nextFlag = false;
				return false;
			}
	}
	/*������ֵ ifConnect ��0ʱ�Ÿ�ֵ�����򲻸�ֵ*/
	if(ifConnect == 0){
		if(nextFlag){
			/*֤����ַ�ı�ʱ����ֵ������ַ*/
			if(objType == 0){
				if(document.all.ownerType.value=="01"){
					
			    document.all.custAddr.value=objValue;
			    document.all.contactAddr.value=objValue;
			    document.all.contactMAddr.value=objValue;
			  }
			}
			/*�ͻ���ַ�ı�ʱ����ֵ��ϵ�˵�ַ����ϵ��ͨѶ��ַ*/
			if(objType == 1){
				frm1100.contactAddr.value = objValue;
	  		frm1100.contactMAddr.value = objValue;
			}
			/*��ϵ�˵�ַ�ı�ʱ����ֵ��ϵ��ͨѶ��ַ��2013/12/16 15:20:17 20131216 gaopeng ��ֵ��������ϵ��ַ����*/
			if(objType == 2){
				document.all.contactMAddr.value=objValue;
				document.all.gestoresAddr.value=objValue;
			}
		}
	}
	
	
}
return nextFlag;
}

/*
	2013/11/18 14:01:09
	gaopeng
	֤�����ͱ��ʱ��֤�������У�鷽��
*/

function checkIccIdFunc(obj,objType,ifConnect){
	var nextFlag = true;
	var idTypeVal = "";
	if(objType == 0){
		var objName = "֤������";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "������֤������";
		idTypeVal = document.all.gestoresIdType.value;
	}
	
	/*ֻ��Ը��˿ͻ�*/
	var opCode = "<%=opCode%>";
	/*��ȡ������ֵ*/
	var objValue = obj.value;
	objValue = $.trim(objValue);
	/*��ȡ�����ֵ�ĳ���*/
	var objValueLength = objValue.length;
	if(objValue != ""){
		/* ��ȡ��ѡ���֤������ 
		0|����֤ 1|����֤ 2|���ڲ� 3|�۰�ͨ��֤ 
		4|����֤ 5|̨��ͨ��֤ 6|��������� 7|���� 
		8|Ӫҵִ�� 9|���� A|��֯�������� B|��λ����֤�� C|������ 
		*/
		
		/*��ȡ֤���������� */
		var idTypeText = idTypeVal.split("|")[0];
		
		/*1������֤�����ڱ�ʱ��֤�����볤��Ϊ18λ*/
		if(idTypeText == "0" || idTypeText == "2"){
			if(objValueLength != 18){
					rdShowMessageDialog(objName+"������18λ��");
					
					nextFlag = false;
					return false;
			}
		}
		/*����֤ ����֤ ���������ʱ ֤��������ڵ���6λ�ַ�*/
		if(idTypeText == "1" || idTypeText == "4" || idTypeText == "6"){
			if(objValueLength < 6){
					rdShowMessageDialog(objName+"������ڵ�����λ�ַ���");
					
					nextFlag = false;
					return false;
			}
		}
		/*֤������Ϊ�۰�ͨ��֤�ģ�֤������Ϊ9λ��11λ��������λΪӢ����ĸ��H����M��(ֻ�����Ǵ�д)������λ��Ϊ���������֡�*/
		if(idTypeText == "3"){
			if(objValueLength != 9 && objValueLength != 11){
					rdShowMessageDialog(objName+"������9λ��11λ��");
					
					nextFlag = false;
					return false;
			}
			/*��ȡ����ĸ*/
			var valHead = objValue.substring(0,1);
			if(valHead != "H" && valHead != "M"){
					rdShowMessageDialog(objName+"����ĸ�����ǡ�H����M����");
					
					nextFlag = false;
					return false;
			}
			/*��ȡ����ĸ֮���������Ϣ*/
			var varWithOutHead = objValue.substring(1,objValue.length);
			if(varWithOutHead % 2 != 0 && varWithOutHead % 2 != 1){
					rdShowMessageDialog(objName+"������ĸ֮�⣬����λ�����ǰ��������֣�");
					
					nextFlag = false;
					return false;
			}
		}
		/*֤������Ϊ
			̨��ͨ��֤ 
			֤������ֻ����8λ��11λ
			֤������Ϊ11λʱǰ10λΪ���������֣�
			���һλΪУ����(Ӣ����ĸ���������֣���
			֤������Ϊ8λʱ����Ϊ����������
		*/
		if(idTypeText == "5"){
			if(objValueLength != 8 && objValueLength != 11){
					rdShowMessageDialog(objName+"����Ϊ8λ��11λ��");
					
					nextFlag = false;
					return false;
			}
			/*8λʱ����Ϊ����������*/
			if(objValueLength == 8){
				if(objValue % 2 != 0 && objValue % 2 != 1){
					rdShowMessageDialog(objName+"����Ϊ����������");
					
					nextFlag = false;
					return false;
				}
			}
			/*11λʱ�����һλ������Ӣ����ĸ���������֣�ǰ10λ�����ǰ���������*/
			if(objValueLength == 11){
				var objValue10 = objValue.substring(0,10);
				if(objValue10 % 2 != 0 && objValue10 % 2 != 1){
					rdShowMessageDialog(objName+"ǰʮλ����Ϊ����������");
					
					nextFlag = false;
					return false;
				}
				var objValue11 = objValue.substring(10,11);
  			var m = /^[A-Za-z]+$/;
				var flag = m.test(objValue11);
				
				if(!flag && objValue11 % 2 != 0 && objValue11 % 2 != 1){
					rdShowMessageDialog(objName+"��11λ����Ϊ���������ֻ�Ӣ����ĸ��");
					
					nextFlag = false;
					return false;
				}
			}
			
		}
		/*��֯������ ֤��������ڵ���9λ��Ϊ���֡���-�����д������ĸ*/
		if(idTypeText == "A"){
			var m = /^([0-9\-A-Z]*)$/;
			var flag = m.test(objValue);
			if(!flag){
					rdShowMessageDialog(objName+"���������֡���-�������д��ĸ��ɣ�");
					
					nextFlag = false;
					return false;
			}
			if(objValueLength < 9){
					rdShowMessageDialog(objName+"������ڵ���9λ��");
					
					nextFlag = false;
					return false;
				
			}
		}
		/*Ӫҵִ�� ֤�����������ڵ���4λ���֣����������纺�ֵ��ַ�Ҳ�Ϲ�*/
		if(idTypeText == "8"){
			var m = /^[0-9]+$/;
			var numSum = 0;
			for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//�ֱ��ȡ��������
          var flag = m.test(code);
          if(flag){
          	numSum ++;
          }
    	}
			if(numSum < 4){
					rdShowMessageDialog(objName+"��������4�����֣�");
					
					nextFlag = false;
					return false;
			}
			/*20131216 gaopeng ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� �����е�֤������Ϊ��Ӫҵִ�ա�ʱ��Ҫ��֤�������λ��Ϊ15λ�ַ�*/
			if(objValueLength != 15){
					rdShowMessageDialog(objName+"����Ϊ15���ַ���");
					nextFlag = false;
					return false;
			}
		}
		/*����֤�� ֤��������ڵ���4λ�ַ�*/
		if(idTypeText == "B"){
			if(objValueLength < 12){
					rdShowMessageDialog(objName+"������ڵ���12λ�ַ���");
					
					nextFlag = false;
					return false;
			}
			
		}
		/*����ԭ���߼�*/
		rpc_chkX('idType','idIccid','A');
	}else if(opCode == "1993"){
		rpc_chkX('idType','idIccid','A');
	}
	return nextFlag;
}


/*
	2013/11/15 15:33:56 gaopeng ���ڽ�һ������ʡ��֧��ϵͳʵ���Ǽǹ��ܵ�֪ͨ  
	ע�⣺ֻ��Ը��˿ͻ� end
*/ 

/*2013/12/16 15:41:14 gaopeng ������֤���������������ı亯��*/
function validateGesIdTypes(idtypeVal){
		if(idtypeVal.indexOf("0") != -1||idtypeVal.indexOf("D") != -1){
  		document.all.gestoresIccId.v_type = "idcard";
  		if("<%=opCode%>" != "1993"){
  			$("#scan_idCard_two3").css("display","");
  			$("#scan_idCard_two31").css("display","");
	  		$("input[name='gestoresName']").attr("class","InputGrey");
	  		$("input[name='gestoresName']").attr("readonly","readonly");
	  		$("input[name='gestoresAddr']").attr("class","InputGrey");
	  		$("input[name='gestoresAddr']").attr("readonly","readonly");
	  		$("input[name='gestoresIccId']").attr("class","InputGrey");
	  		$("input[name='gestoresIccId']").attr("readonly","readonly");
	  		$("input[name='gestoresName']").val("");
	  		$("input[name='gestoresAddr']").val("");
	  		$("input[name='gestoresIccId']").val("");
  		}
  	}else{
  		document.all.gestoresIccId.v_type = "string";
  		if("<%=opCode%>" != "1993"){
  			$("#scan_idCard_two3").css("display","none");
  			$("#scan_idCard_two31").css("display","none");
	  		$("input[name='gestoresName']").removeAttr("class");
	  		$("input[name='gestoresName']").removeAttr("readonly");
	  		$("input[name='gestoresAddr']").removeAttr("class");
	  		$("input[name='gestoresAddr']").removeAttr("readonly");
	  		$("input[name='gestoresIccId']").removeAttr("class");
	  		$("input[name='gestoresIccId']").removeAttr("readonly");
  		}
  	}
}


function checkNameStr(code){
			/* gaopeng 2014/01/17 9:50:35 ����ƥ������ ��Ϊ���ſ���������Ҳ������Ӣ�ģ����ȷ���KH ��֤�߼���ʧ��*/
				if(forKuoHao(code)) return "KH";//����
		    if(forA2sssz1(code)) return "EH"; //Ӣ��
		    var re2 =new RegExp("[\u0400-\u052f]");
		    if(re2.test(code)) return "RU"; //����
		    var re3 =new RegExp("[\u00C0-\u00FF]");
		    if(re3.test(code)) return "FH"; //����
		    var re4 = new RegExp("[\u3040-\u30FF]");
		    var re5 = new RegExp("[\u31F0-\u31FF]");
		    if(re4.test(code)||re5.test(code)) return "JP"; //����
		    var re6 = new RegExp("[\u1100-\u31FF]");
		    var re7 = new RegExp("[\u1100-\u31FF]");
		    var re8 = new RegExp("[\uAC00-\uD7AF]");
		    if(re6.test(code)||re7.test(code)||re8.test(code)) return "KR"; //����
		    if(forHanZi1(code)) return "CH"; //����
    
   }

function reSetCustName(){/*���ÿͻ�����*/
  document.all.custName.value="";
  document.all.contactPerson.value="";
  
  /*20131216 gaopeng 2013/12/16 15:11:05 ��ѡ��λ����ʱ��չʾ��������Ϣ��������Ϣ���Ϊ����ѡ�� start*/
  var checkVal = $("select[name='isJSX']").find("option:selected").val();
  if(checkVal == 1){ //��λ�ͻ�
  	$("#gestoresInfo1").show();
  	$("#gestoresInfo2").show();
		$("#sendProjectList").hide(); //�·�������ť
		$("#qryListResultBut").hide(); //���������ѯ��ť
  	/*����������*/
  	document.all.gestoresName.v_must = "1";
  	/*�����˵�ַ*/
  	document.all.gestoresAddr.v_must = "1";
  	/*������֤������*/
  	document.all.gestoresIccId.v_must = "1";
  	var checkIdType = $("select[name='gestoresIdType']").find("option:selected").val();
  	/*����֤����У�鷽��*/
  	if(checkIdType.indexOf("����֤") != -1){
  		document.frm1100.gestoresIccId.v_type = "idcard";
  		$("#scan_idCard_two3").css("display","");
  		$("#scan_idCard_two31").css("display","");
  		$("input[name='gestoresName']").attr("class","InputGrey");
  		$("input[name='gestoresName']").attr("readonly","readonly");
  		$("input[name='gestoresAddr']").attr("class","InputGrey");
  		$("input[name='gestoresAddr']").attr("readonly","readonly");
  		$("input[name='gestoresIccId']").attr("class","InputGrey");
  		$("input[name='gestoresIccId']").attr("readonly","readonly");
  	}else{
  		document.frm1100.gestoresIccId.v_type = "string";
  		$("#scan_idCard_two3").css("display","none");
  		$("#scan_idCard_two31").css("display","none");
  		$("input[name='gestoresName']").removeAttr("class");
  		$("input[name='gestoresName']").removeAttr("readonly");
  		$("input[name='gestoresAddr']").removeAttr("class");
  		$("input[name='gestoresAddr']").removeAttr("readonly");
  		$("input[name='gestoresIccId']").removeAttr("class");
  		$("input[name='gestoresIccId']").removeAttr("readonly");
  	}
  }
  /*ûѡ��λ�ͻ���ʱ�򣬾���չʾ������Ϊ����Ҫ����ѡ��*/
  else{
  	$("#gestoresInfo1").hide();
  	$("#gestoresInfo2").hide();
  	/*����������*/
  	document.all.gestoresName.v_must = "0";
  	/*�����˵�ַ*/
  	document.all.gestoresAddr.v_must = "0";
  	/*������֤������*/
  	document.all.gestoresIccId.v_must = "0";
  }
  /*20131216 gaopeng 2013/12/16 15:11:05 ��ѡ��λ����ʱ��չʾ��������Ϣ��������Ϣ���Ϊ����ѡ�� end*/
  
  //getIdTypes();
  /* begin add �� 1100+��ͨ����+����֤+�����������+����+��չ���У�����ʾ���·���������ť for ���ڵ绰�û�ʵ���Ǽǽ����ص㹤����֪ͨ @2014/11/4 */
  var idTypeSelect = $("#idTypeSelect option[@selected]").val();//֤�����ͣ�����֤
  if(checkVal == 0){
		if(idTypeSelect.indexOf("|") != -1){
			var v_idTypeSelect = idTypeSelect.split("|")[0];
			if(v_idTypeSelect == "0" && "<%=workChnFlag%>" == "1" && "<%=opCode%>" == "1100" && (parseInt($("#sendListOpenFlag").val()) > 0) && "<%=regionCodeFlag%>" == "Y"){
				$("#sendProjectList").show();
				$("#qryListResultBut").show();
			}else{
				$("#sendProjectList").hide();
				$("#qryListResultBut").hide();
			}
		}
  }
  /* end add for ���ڵ绰�û�ʵ���Ǽǽ����ص㹤����֪ͨ @2014/11/4 */
  /* begin update for ���ڿ��������ն�CRMģʽAPP�ĺ� - �ڶ���@2015/3/10 */
  if(idTypeSelect.indexOf("|") != -1){
  	var v_idTypeSelect1 = idTypeSelect.split("|")[0];
		if(v_idTypeSelect1 == "0"){ //����֤
			if("<%=workChnFlag%>" != "1"){ //����Ӫҵ��
				$("#idIccid").attr("class","InputGrey");
				$("#idIccid").attr("readonly","readonly");
				$("#custName").attr("class","InputGrey");
				$("#custName").attr("readonly","readonly");
				$("#idAddr").attr("class","InputGrey");
				$("#idAddr").attr("readonly","readonly");
				$("#idValidDate").attr("class","InputGrey");
				$("#idValidDate").attr("readonly","readonly");
				$("#idIccid").val("");
				$("#custName").val("");
				$("#idAddr").val("");
				$("#idValidDate").val("");
			}else{ //�������
				if((parseInt($("#sendListOpenFlag").val()) > 0) && "<%=regionCodeFlag%>" == "Y"){ //���Ź�˾���鿪��Ϊ������+���п���Ϊ������ʱ
					$("#idIccid").attr("class","InputGrey");
					$("#idIccid").attr("readonly","readonly");
					$("#custName").attr("class","InputGrey");
					$("#custName").attr("readonly","readonly");
					$("#idAddr").attr("class","InputGrey");
					$("#idAddr").attr("readonly","readonly");
					$("#idValidDate").attr("class","InputGrey");
					$("#idValidDate").attr("readonly","readonly");
					$("#idIccid").val("");
					$("#custName").val("");
					$("#idAddr").val("");
					$("#idValidDate").val("");
				}
			}
		}else{
			if("<%=workChnFlag%>" != "1"){ //����Ӫҵ��
				$("#idIccid").removeAttr("class");
				$("#idIccid").removeAttr("readonly");
				$("#custName").removeAttr("class");
				$("#custName").removeAttr("readonly");
				$("#idAddr").removeAttr("class");
				$("#idAddr").removeAttr("readonly");
				$("#idValidDate").removeAttr("class");
				$("#idValidDate").removeAttr("readonly");
			}else{ //�������
				if((parseInt($("#sendListOpenFlag").val()) > 0) && "<%=regionCodeFlag%>" == "Y"){ //���Ź�˾���鿪��Ϊ������+���п���Ϊ������ʱ
					$("#idIccid").removeAttr("class");
					$("#idIccid").removeAttr("readonly");
					$("#custName").removeAttr("class");
					$("#custName").removeAttr("readonly");
					$("#idAddr").removeAttr("class");
					$("#idAddr").removeAttr("readonly");
					$("#idValidDate").removeAttr("class");
					$("#idValidDate").removeAttr("readonly");
				}
			}
		}
  }
  /* end update for ���ڿ��������ն�CRMģʽAPP�ĺ� - �ڶ���@2015/3/10 */	
}
/**** tianyang add for �����ַ����� end ****/


function feifa1(textName)
{
  if(textName.value != "")
  {
    if((textName.value.indexOf("~")) != -1 || (textName.value.indexOf("|")) != -1 || (textName.value.indexOf(";")) != -1)
    {
      rdShowMessageDialog("����������Ƿ��ַ������������룡");
      textName.value = "";
        return;
    }
  }
  
  var Str = document.all.idType.value;
 
    if(Str.indexOf("����֤") > -1){
      if($("#idIccid").val().length<18){
        rdShowMessageDialog("����֤���������18λ��");
        document.all.idIccid.focus();
        return false;
      }
    }
  
  
  rpc_chkX('idType','idIccid','A');
}
  
function uploadpic(){//����֤
  
  if(document.all.filep.value==""){
    rdShowMessageDialog("��ѡ��Ҫ�ϴ���ͼƬ",0);
    return;
    }
  if(document.all.but_flag.value=="0"){
    rdShowMessageDialog("����ɨ����ȡͼƬ",0);
    return;
    }
  
  frm1100.target="upload_frame"; 
  var actionstr ="/npage/sm275/fm275CustOpen.jsp?custId="+document.frm1100.custId.value+
                  "&regionCode="+document.frm1100.regionCode.value+
                  "&filep_j="+document.frm1100.filep.value+
                  "&card_flag="+document.all.card_flag.value+ 
                  "&but_flag="+document.all.but_flag.value+
                  "&idSexH="+document.all.idSexH.value+
                  "&custName="+document.all.custName.value+
                  "&idAddrH="+document.all.idAddrH.value.replace(new RegExp("#","gm"),"%23")+
                  "&birthDayH="+document.all.birthDayH.value+
                  "&custId="+document.all.custId.value+
                  "&idIccid="+document.all.idIccid.value+
                  "&workno="+document.all.workno.value+
                  "&zhengjianyxq="+document.all.idValidDate.value+
                  "&opCode=<%=opCode%>"+
                  "&upflag=1"
                   +"&isJSX="+document.all.isJSX.value;
                  
  frm1100.action = actionstr; 
  document.all.upbut_flag.value="1";
  frm1100.submit();
  resetfilp();
  }
  
  function resetfilp(){//����֤
    document.getElementById("filep").outerHTML = document.getElementById("filep").outerHTML;
    }
  
  function preGrpQuery(){//wangzn add 091201 for Ǳ�ڼ�����ǩԼ
    
    if(!checkElement(document.getElementById('preUnitId')))
    {
      return false;
    }
    if(document.getElementById('preUnitId').value.length==0)
    {
      rdShowMessageDialog("������Ǳ�ڼ��ű�ţ��ٵ����ѯ��",0);
      return;
    }
    
    var preUnitId = document.getElementById("preUnitId").value;
    var sqlStr = "SELECT Unit_Id,Unit_Name,unit_addr,contact_person,contact_phone,unit_zip,fax FROM dbvipadm.dgrppremsg where Unit_Id like '%25"+preUnitId+"%25' and add_flag <> 'F' and substr(boss_org_code,1,2)='<%=regionCode%>' ";
    
    var sqlStr = "48";
    var params = "preUnitId="+"%25"+preUnitId+"%25" +",regionCode=<%=regionCode%>";
    
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "2|3|4|5|6|0|1|";//�����ֶ� zhangyan mod ���Ӽ�������
    var fieldName = "���ű��|��������|���ŵ�ַ|��ϵ������|��ϵ�˵绰|��ϵ���ʱ�|��ϵ�˴���|";//����������ʾ���С�����
    var pageTitle = "Ǳ�ڼ�����Ϣ��ѯ";
    
    var path = "/npage/sq100/fPubSimpSel_new.jsp";
    path = path + "?sqlStr=" +sqlStr + "&retQuence=" + retQuence+"&params="+params;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;
    var retInfo = window.showModalDialog(path,"","dialogWidth:70;dialogHeight:35;");
    if(retInfo ==undefined)
    {
      return;
    }
      var retToField="contactAddr|contactPerson|contactPhone|contactPost|contactFax|preUnitId|custName|";/*zhangyan ����Ǳ�ڼ�������*/
  
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
      document.getElementById("preUnitId").readOnly = true;
  }
  
  function preTrShow(preBox){//wangzn add 091201 for Ǳ�ڼ�����ǩԼ
    document.all("preTr").style.display="none";
    document.all("preUnitId").value="";
    document.all("preUnitId").readOnly=false;
    if(preBox.checked){
      document.all("preTr").style.display="";
    }
  }
  
  //�·�����
  function sendProLists(){
		var packet = new AJAXPacket("/npage/sq100/fq100_ajax_sendProLists.jsp","���ڻ�����ݣ����Ժ�......");
		packet.data.add("opCode","<%=opCode%>");
		core.ajax.sendPacket(packet,doSendProLists);
		packet = null;
  } 
  
  function doSendProLists(packet){
  	var retCode = packet.data.findValueByName("retCode");
		var retMsg =  packet.data.findValueByName("retMsg");
		if(retCode != "000000"){
			rdShowMessageDialog( "�·�����ʧ��!<br>������룺"+retCode+"<br>������Ϣ��"+retMsg,0 );
			//��¼Ϊû���
			$("#isSendListFlag").val("N");
		}else{
			rdShowMessageDialog( "�·������ɹ�!",2 );
			//��¼Ϊ���
			$("#isSendListFlag").val("Y");
		}
  }
  
  //���������ѯ
	function qryListResults(){
		var h=450;
		var w=800;
		var t=screen.availHeight/2-h/2;
		var l=screen.availWidth/2-w/2;
		var prop="dialogHeight:"+h+"px;dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;status:no;help:no";
		var ret=window.showModalDialog("/npage/sq100/f1100_qryListResults.jsp?opCode=<%=opCode%>&opName=<%=opName%>&accp="+Math.random(),"",prop);
		if(typeof(ret) == "undefined"){
			rdShowMessageDialog("���û�й�����ѯ��������Ƚ����·�����������");
			$("#isQryListResultFlag").val("N");//ѡ���˹�����ѯ���
		}else if(ret!=null && ret!=""){
			$("#isQryListResultFlag").val("Y");//ѡ���˹�����ѯ���
			$("#custName").val(ret.split("~")[0]); //�ͻ�����
			$("#idIccid").val(ret.split("~")[1]); //֤������
			if($("#idIccid").val() != ""){
				checkIccIdFunc16New(document.all.idIccid,0,0);
				rpc_chkX('idType','idIccid','A');
			}
			$("#idAddr").val(ret.split("~")[2]);  //֤����ַ
			$("input[name='custAddr']").val(ret.split("~")[2]); //�ͻ���ַ
			$("input[name='contactAddr']").val(ret.split("~")[2]); //��ϵ�˵�ַ
			$("input[name='contactMAddr']").val(ret.split("~")[2]); //��ϵ��ͨѶ��ַ
			$("#idValidDate").val(ret.split("~")[3]); //֤����Ч��
			$("#idIccid").attr("class","InputGrey");
  		$("#idIccid").attr("readonly","readonly");
  		$("#custName").attr("class","InputGrey");
  		$("#custName").attr("readonly","readonly");
  		$("#idAddr").attr("class","InputGrey");
  		$("#idAddr").attr("readonly","readonly");	
  		$("#idValidDate").attr("class","InputGrey");
  		$("#idValidDate").attr("readonly","readonly");			
		}
	}  
	
	//ֻ��Ҫ��table����һ��vColorTr='set' ���ԾͿ��Ը��б�ɫ
	$("table[vColorTr='set']").each(function(){
		$(this).find("tr").each(function(i,n){
			$(this).bind("mouseover",function(){
				$(this).addClass("even_hig");
			});
		
			$(this).bind("mouseout",function(){
				$(this).removeClass("even_hig");
			});
		
			if(i%2==0){
				$(this).addClass("even");
			}
		});
	});
  
  //��ȡֱ�ܿͻ���Ϣ
  function qryDirectManageCustInfo1(obj){
  	var custName = $("#custName").val();
		if(obj.value == "1"){ //��
			var h=450;
			var w=800;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			var prop="dialogHeight:"+h+"px;dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;status:no;help:no";
			var ret=window.showModalDialog("/npage/sq100/f1993_qryDirectManageCustInfo.jsp?custName=" + custName+"&opCode=<%=opCode%>","",prop);
			if(typeof(ret) == "undefined"){
				$("#isDirectManageCust").val("0");
				$("#directManageCustNo").val("");
				//$("#groupNo").val("");
			}else if(ret!=null && ret!=""){
				$("#directManageCustNo").val(ret.split("~")[0]);
				$("#groupNo").val(ret.split("~")[2]);
			}
		}else{
			$("#directManageCustNo").val("");
			$("#groupNo").val("");
		}
  }
  
  function qryDirectManageCustInfo2(obj){
  	if($("#isDirectManageCust").val() == "0"){ //�� ����ֱ�ܿͻ� 
  		if(obj.value != "" && obj.value != null){ //��֯�������� ��ֵ
  			var isDirectManageCust = $("#isDirectManageCust").val();
		  	if(isDirectManageCust == "0"){ //��
		  		var packet = new AJAXPacket("/npage/sq100/f1993_ajax_qryDirectManageCustInfo2.jsp","���ڻ�����ݣ����Ժ�......");
			    	packet.data.add("directManageCustNo","");
			    	packet.data.add("groupNo",obj.value);
			    	packet.data.add("institutionName","");
			    	packet.data.add("directManageCustName","");
			    	packet.data.add("opCode","<%=opCode%>");
			    	core.ajax.sendPacket(packet,doQryDirectManageCustInfo2);
			    	packet = null;
		  	}
  		}
  	}
  }
  
  function doQryDirectManageCustInfo2(packet){
		var retCode = packet.data.findValueByName("retCode");
		var retMsg =  packet.data.findValueByName("retMsg");
		var v_directManageCustNo =  packet.data.findValueByName("v_directManageCustNo");
		var v_groupNo =  packet.data.findValueByName("v_groupNo");
		if(v_directManageCustNo.length > 0 && v_directManageCustNo != ""){
			var confirmFlag = rdShowConfirmDialog("�ü��ſͻ�Ϊֱ�ܿͻ����Ƿ񽫱������޸�Ϊֱ�ܿͻ���");
			if(confirmFlag == 1){
				$("#isDirectManageCust").val("1");
				$("#directManageCustNo").val(v_directManageCustNo);
				$("#groupNo").val(v_groupNo);
			}else{
				//$("#directManageCustNo").val("");
				//$("#groupNo").val("");
			}
		}
  }
  
  function getCuTime(){
	 var curr_time = new Date(); 
	 with(curr_time) 
	 { 
	 var strDate = getYear()+"-"; 
	 strDate +=getMonth()+1+"-"; 
	 strDate +=getDate()+" "; //ȡ��ǰ���ڣ�������ġ��ա��ֱ�ʶ 
	 strDate +=getHours()+"-"; //ȡ��ǰСʱ 
	 strDate +=getMinutes()+"-"; //ȡ��ǰ���� 
	 strDate +=getSeconds(); //ȡ��ǰ���� 
	 return strDate; //������ 
	 } 
	}
  
  function Idcard_realUser(flag){
		//��ȡ��������֤
		//document.all.card_flag.value ="2";
		
		var picName = getCuTime();
		var fso = new ActiveXObject("Scripting.FileSystemObject");  //ȡϵͳ�ļ�����
		var tmpFolder = fso.GetSpecialFolder(0); //ȡ��ϵͳ��װĿ¼
		var strtemp= tmpFolder+"";
		var filep1 = strtemp.substring(0,1)//ȡ��ϵͳĿ¼�̷�
		var cre_dir = filep1+":\\custID";//����Ŀ¼
		//�ж��ļ����Ƿ���ڣ��������򴴽�Ŀ¼
		if(!fso.FolderExists(cre_dir)) {
			var newFolderName = fso.CreateFolder(cre_dir);  
		}
		var picpath_n = cre_dir +"\\"+picName+"_"+ document.all.custId.value +".jpg";
		
		var result;
		var result2;
		var result3;
	
		result=IdrControl1.InitComm("1001");
		if (result==1)
		{
			result2=IdrControl1.Authenticate();
			if ( result2>0)
			{              
				result3=IdrControl1.ReadBaseMsgP(picpath_n); 
				if (result3>0)           
				{     
			  var name = IdrControl1.GetName();
				var code =  IdrControl1.GetCode();
				var sex = IdrControl1.GetSex();
				var bir_day = IdrControl1.GetBirthYear() + "" + IdrControl1.GetBirthMonth() + "" + IdrControl1.GetBirthDay();
				var IDaddress  =  IdrControl1.GetAddress();
				var idValidDate_obj = IdrControl1.GetValid();
		
				if(flag == "manage"){  //������
					document.all.gestoresName.value =name;//����
					document.all.gestoresIccId.value =code;//����֤��
					//document.all.gestoresAddr.value =IDaddress;//����֤��ַ
				}
				subStrAddrLength(flag,IDaddress);//У������֤��ַ���������60���ַ������Զ���ȡǰ30����
				}
				else
				{
					rdShowMessageDialog(result3); 
					IdrControl1.CloseComm();
				}
			}
			else
			{
				IdrControl1.CloseComm();
				rdShowMessageDialog("�����½���Ƭ�ŵ���������");
			}
		}
		else
		{
			IdrControl1.CloseComm();
			rdShowMessageDialog("�˿ڳ�ʼ�����ɹ�",0);
		}
		IdrControl1.CloseComm();
	}
  
  function Idcard2(str){
			//ɨ���������֤
		var fso = new ActiveXObject("Scripting.FileSystemObject");  //ȡϵͳ�ļ�����
		tmpFolder = fso.GetSpecialFolder(0); //ȡ��ϵͳ��װĿ¼
		var strtemp= tmpFolder+"";
		var filep1 = strtemp.substring(0,1)//ȡ��ϵͳĿ¼�̷�
		var cre_dir = filep1+":\\custID";//����Ŀ¼
		if(!fso.FolderExists(cre_dir)) {
			var newFolderName = fso.CreateFolder(cre_dir);
		}
	var ret_open=CardReader_CMCC.MutiIdCardOpenDevice(1000);
	if(ret_open!=0){
		ret_open=CardReader_CMCC.MutiIdCardOpenDevice(1001);
	}	
	var cardType ="11";
	if(ret_open==0){
			//�๦���豸RFID��ȡ
			var ret_getImageMsg=CardReader_CMCC.MutiIdCardGetImageMsg(cardType,"c:\\custID\\cert_head_"+v_printAccept+str+".jpg");
			if(str=="1"){
				try{
					document.all.pic_name.value = "C:\\custID\\cert_head_"+v_printAccept+str+".jpg";
					document.all.but_flag.value="1";
					document.all.card_flag.value ="2";
				}catch(e){
						
				}
			}
			//alert(ret_getImageMsg);
			//ret_getImageMsg = "0";
			if(ret_getImageMsg==0){
				//����֤������ϳ�
				var xm =CardReader_CMCC.MutiIdCardName;					
				var xb =CardReader_CMCC.MutiIdCardSex;
				var mz =CardReader_CMCC.MutiIdCardPeople;
				var cs =CardReader_CMCC.MutiIdCardBirthday;
				var yx =CardReader_CMCC.MutiIdCardSigndate+"-"+CardReader_CMCC.MutiIdCardValidterm;
				var yxqx = CardReader_CMCC.MutiIdCardValidterm;//֤����Ч��
				var zz =CardReader_CMCC.MutiIdCardAddress; //סַ
				var qfjg =CardReader_CMCC.MutiIdCardOrgans; //ǩ������
				var zjhm =CardReader_CMCC.MutiIdCardNumber; //֤������
				var base64 =CardReader_CMCC.MutiIdCardPhoto;
				var v_validDates = "";
				if(yxqx.indexOf("\.") != -1){
					yxqx = yxqx.split(".");
					if(yxqx.length >= 3){
						v_validDates = yxqx[0]+yxqx[1]+yxqx[2]; 
					}else{
						v_validDates = "21000101";
					}
				}else{
					v_validDates = "21000101";
				}
				
				if(str == "1"){ //��ȡ�ͻ�������Ϣ
					//֤�����롢֤�����ơ�֤����ַ����Ч��
					document.all.custName.value =xm;//����
					document.all.idIccid.value =zjhm;//����֤��
					//document.all.idAddr.value =zz;//����֤��ַ
					document.all.idValidDate.value =v_validDates;//֤����Ч��
					document.all.birthDay.value =cs;//����
					document.all.birthDayH.value =cs;//����
					document.all.custSex.value=xb;//�Ա�
		  		document.all.idSexH.value=xb;//�Ա�
		  		document.all.custName.value =xm;//����
		  		$("#kehuMingcheng").val(xm);//����
		  		lianxirenXm();
		  		
				$("#idIccid").attr("class","InputGrey");
		  		$("#idIccid").attr("readonly","readonly");
		  		$("#custName").attr("class","InputGrey");
		  		$("#custName").attr("readonly","readonly");
		  		$("#idAddr").attr("class","InputGrey");
		  		$("#idAddr").attr("readonly","readonly");
		  		$("#idValidDate").attr("class","InputGrey");
		  		$("#idValidDate").attr("readonly","readonly");
		  		checkIccIdFunc16New(document.all.idIccid,0,0);
		  		rpc_chkX('idType','idIccid','A');
		  		checkCustNameFunc16New(document.all.custName,0,0);
		  		
		  		pubM032Cfm();
		  		
				}else if(str == "31"){ //������
					document.all.gestoresName.value =xm;//����
					document.all.gestoresIccId.value =zjhm;//����֤��
					//document.all.gestoresAddr.value =zz;//����֤��ַ
				}
				subStrAddrLength(str,zz);//У������֤��ַ���������60���ַ������Զ���ȡǰ30����

			}else{
					rdShowMessageDialog("��ȡ��Ϣʧ��");
					return ;
			}
	}else{
					rdShowMessageDialog("���豸ʧ��");
					return ;
	}
	//�ر��豸
	var ret_close=CardReader_CMCC.MutiIdCardCloseDevice();
	if(ret_close!=0){
		rdShowMessageDialog("�ر��豸ʧ��");
		return ;
	}
	
}

function subStrAddrLength(str,idAddr){
	var packet = new AJAXPacket("/npage/sq100/fq100_ajax_subStrAddrLength.jsp","���ڻ�����ݣ����Ժ�......");
	packet.data.add("str",str);
	packet.data.add("idAddr",idAddr);
	core.ajax.sendPacket(packet,doSubStrAddrLength);
	packet = null;
}

function doSubStrAddrLength(packet){
	var str = packet.data.findValueByName("str");
	var idAddr = packet.data.findValueByName("idAddr");
	if(str == "1"){ //��ȡ�ͻ�������Ϣ
		document.all.idAddr.value =idAddr;//����֤��ַ
		document.all.idAddrH.value =idAddr;//����֤��ַ
		checkAddrFunc(document.all.idAddr,0,0);
	}else if(str == "31"){ //������
		document.all.gestoresAddr.value =idAddr;//����֤��ַ
	}else if(str == "manage"){ //������ �ɰ�
		document.all.gestoresAddr.value =idAddr;//����֤��ַ
	}else if(str == "j1"){ //��ȡ�ͻ�������Ϣ �ɰ�
		document.all.idAddr.value =idAddr;//����֤��ַ
		document.all.idAddrH.value =idAddr;//����֤��ַ
	}
}


/*2015/6/30 16:55:51 gaopeng ����Ϊ��ѯ ���ʷ� ��Ϣ���� start*/
function productOfferQryByAttr()
{
	
	var offerCode="";
	var offerName="";
	var offerType="10";
	var offerAttrSeq="";
	var custGroupId="";
	var channelSegment="";
	var group_id=document.all.receiveRegion.value;//������;
	
	var band_id="";
	var offer_att_type="";
	var goodFlag="1";
	var retQ08_flag="0";
	var opCode="m275";

	var packet = new AJAXPacket("/npage/portal/shoppingCar/ajax_productOfferQryByAttr.jsp","���Ժ�...");
	packet.data.add("offerCode" ,offerCode);
	packet.data.add("offerName" ,offerName);
	packet.data.add("offerType" ,offerType);
	packet.data.add("offerAttrSeq" ,offerAttrSeq);
	packet.data.add("custGroupId" ,custGroupId);
	packet.data.add("channelSegment" ,channelSegment);
	packet.data.add("group_id" ,group_id);
	packet.data.add("band_id" ,band_id);
	packet.data.add("offer_att_type" ,offer_att_type);
	packet.data.add("goodFlag" ,goodFlag);
	packet.data.add("retQ08_flag" ,retQ08_flag);
	packet.data.add("opCode" ,opCode);
	core.ajax.sendPacket(packet,doProductOfferQryByAttr);
	packet =null;
}

function doProductOfferQryByAttr(packet)
{
	var qryRetCode = packet.data.findValueByName("retCode"); 
	var qryRetMsg = packet.data.findValueByName("retMsg"); 
	var retResult = packet.data.findValueByName("retResult");
	var selectValue = "01";
	var serv_bus_id = "";
	if(retResult==null||retResult==""){
			rdShowMessageDialog("��ȡ���ʷ���Ϣʧ�ܣ�������룺"+qryRetCode+",������Ϣ��"+qryRetMsg);
			return false;
		}else{
				if(qryRetCode==0){
				for(var i=0;i<retResult.length;i++){
					
					$("#queryOfferList").append("<tr id='queryOfferList"+"_tr_td"+i+"' onclick='clickTr()' style='cursor:pointer;'><td>"+retResult[i][0]+"</td><td id='"+codeChg("queryOfferList"+"td_"+retResult[i][0])+"'>"+retResult[i][1]+"</td><td>"+retResult[i][6]+"</td><td><div style='display:none'>"+retResult[i][2]+"</div>"+"<span style='display:none'>"+retResult[i][0]+"|"+retResult[i][2]+"|"+retResult[i][3]+"|"+retResult[i][4]+"|"+retResult[i][5]+"|"+serv_bus_id+"|20004|"+selectValue+"</span></td>");
					//getMidPrompt("10442",retResult[i][0],codeChg("queryOfferList"+"td_"+retResult[i][0]));
    			}
				}
			}
}

//ȡ�÷�������ID(servBusID)
function getServBusId(offer_id){
			var packet = new AJAXPacket("/npage/portal/shoppingCar/getServBusId.jsp","���Ժ�...");
			packet.data.add("offer_id" ,offer_id);
			core.ajax.sendPacket(packet,getMebAttr);
	}
function getMebAttr(packet){
	var backArrMsg =packet.data.findValueByName("backArrMsg");
	var retMsg=retMsg =packet.data.findValueByName("retMsg");
	if(backArrMsg==null || backArrMsg==""){
			backArrMsg="";
		}
	document.all.servBusId.value = backArrMsg;
	}
	


//�Ӳ�ѯ�б��е�����¼��󣬰�ѡ�е���Ϣ���ӵ���һ���б�
var reCodeAdd = "";
var reMsgAdd = "";
function clickTr()
{
	var e = arguments[0] || window.event;
	var trCur = e.srcElement.parentNode || e.target.parentNode;
	//if(trCur.getElementsByTagName("td").length==0) return;
	var offerid = trCur.getElementsByTagName("td")[0].innerHTML;
	//���÷���ȡ��servBusId
	getServBusId(offerid);
	    //�Ӳ�ѯ�б���ȡ�������е�����
		 var xiaoxpCode=trCur.getElementsByTagName("td")[0].innerHTML;//����Ʒ����
	    var xiaoxpName=trCur.getElementsByTagName("td")[1].innerHTML;//x����Ʒ����
	    var bandName=trCur.getElementsByTagName("td")[2].innerHTML;	    //Ʒ������
	   // var offer_comments=trCur.getElementsByTagName("td")[3].innerHTML.split("|")[1];//����Ʒ����
	    
	    //�и����һ�У�ȡ����Ҫ������Ʒ��������
	    //var index = offerComments.indexOf('<');
	    //var offer_comments = offerComments.substring(0,index);
	    //var band_id = document.all.smCode.value;//Ʒ�Ʊ�ʶ
	    var band_id = "";//Ʒ�Ʊ�ʶ
	    //ȡ�����һ���У���������span�е����ݣ����и�
	    var tdObj =trCur.getElementsByTagName("td")[3];
	    var offer_comments=tdObj.getElementsByTagName("div")[0].innerHTML
	    var spanH=tdObj.getElementsByTagName("span")[0].innerHTML;
		var spanHVs=spanH.split('|'); 
		//var exp_date_offset=spanHVs[0];//ʧЧʱ��ƫ����
		//var exp_date_offset_unit = spanHVs[1];//ʧЧʱ��ƫ�뵥λ
		//var offer_type = spanHVs[2];//����Ʒ����
		//var retKey = spanHVs[3];//��ѯ��ʽ~�ֻ�����/�������~/���ģ��/�����������ƴ�ӳɵĴ�
		//var retValue = spanHVs[4];//��ѯ��ʽ~�ֻ�����/�������~/���ģ��/����������͵�ֵ��ƴ�ӳɵĴ�
		
		var exp_date_offset=spanHVs[3];//ʧЧʱ��ƫ����
		var exp_date_offset_unit = spanHVs[4];
		var offer_type = spanHVs[5];          
		var retKey = spanHVs[6];              
		var retValue = spanHVs[7];  	
			
		var serv_bus_id =document.all.servBusId.value;//ȡ�÷�������ID��servBusId
		
	
		ajaxGetLimitAdd(offerid);//  �������� hejwa add 2010��2��8��14:05:20
		if(reCodeAdd!="0"){
				rdShowMessageDialog(reCodeAdd+":"+reMsgAdd);
				return false;
		} 
		
		if(serv_bus_id==""){
			var msg =document.all.retMsg.value;
			rdShowMessageDialog(msg);
			return false;
		}
		var delBut = "";	
		if(typeof(retKey) == "undefined" || typeof(retValue) == "undefined"){
				 delBut="<INPUT class=b_text id=but_add onclick='delTr();' type=button value=ɾ��><span style='display:none'>"+band_id+"|"+offer_comments+"|"+exp_date_offset+"|"+exp_date_offset_unit+"|"+offer_type+"|"+serv_bus_id+"</span>";
				}else{
					 delBut="<INPUT class=b_text id=but_add onclick='delTr();' type=button value=ɾ��><span style='display:none'>"+band_id+"|"+offer_comments+"|"+exp_date_offset+"|"+exp_date_offset_unit+"|"+offer_type+"|"+serv_bus_id+"|"+retKey+"|"+retValue+"</span>";
					}
		
		var arrTdCon=new Array(xiaoxpCode,xiaoxpName,bandName,"<div nowrap title="+offer_comments+">"+offer_comments.substring(0,20)+"..."+"</div>","<input type='hidden' id='"+offerid+"'/>"+delBut);
		
		var tableId=g("productOfferList");
		var rowNum = tableId.rows.length;
		if(rowNum>1){
			for(var i=2;i<=rowNum;i++){
			tableId.deleteRow();
			}
		}
		
		addTrOver("productOfferList","1",arrTdCon);	
	  getMidPrompt("10442",xiaoxpCode,codeChg("productOfferList"+"td_"+xiaoxpCode));
	  
	  myCfm();	
			
}

function myCfm(){
	var productOfferTab = g("productOfferList");
	var rowNum = productOfferTab.rows.length;
	if(rowNum<=1)
	{
		rdShowMessageDialog("����ѡ������Ʒ!");
		return false;
	}
	else
	{
		var resultList;
		var tabID="productOfferList";
		var lineV="5";
		var lineHid ="4";
		
		resultList = getTableData(tabID,lineV,lineHid);
		
		var result1 = resultList.split("|");
    for (var n = 0; n < result1.length; n++)
    {
        var result2 = result1[n].split(",");
        var idNo = ""; 										//
        var offerId = result2[0];					//����Ʒ��ʶ
        var offerName = result2[1];				//����Ʒ����
        var offerType = result2[7];	      //����Ʒ���� 30��� 10����
        var servBusiId = result2[9];
        var offerInfoCode = result2[10];
        var offerInfoValue = result2[11];
       	
       	$("#myidNo").val(idNo);
       	$("#myofferId").val(offerId);
       	$("#myofferName").val(offerName);
       	$("#myofferType").val(offerType);
       	$("#myservBusiId").val(servBusiId);
       	$("#myofferInfoCode").val(offerInfoCode);
       	$("#myofferInfoValue").val(offerInfoValue);
     }
	}
}


/*************
addTrOver ����  Ҫ��������Id ���������ڱ���ĵڼ��У�Ҫ��������ݣ��������Ƿ����ظ��������У��������а��¼���ʱ��������ȥ����ɫ��

***********/
function addTrOver(tableID,trIndex,arrTdCont,num,bg)
{
	var tableId=g(tableID);
	var tableTr=g(tableID).getElementsByTagName("tr");
	if(typeof(num)!="undefined")
	{
		for (var i=0;i<tableTr.length;i++)
		{
			var tabaleTd=tableTr[i].getElementsByTagName("td");	
			var tdArrs=new Array();
			for(var j=0;j<tabaleTd.length;j++)
			{
				tdArrs.push(tabaleTd[j].innerHTML);
			}
			var tempnum=String(num);
			var nums=tempnum.split('|');
			var a = parseInt(nums[0]);
			var b = parseInt(nums[1]);
			if(b)
			{
				if((tdArrs[a]==arrTdCont[a])&&(tdArrs[b]==arrTdCont[b])) return false;
			}
			else
			{
				if(tdArrs[num]==arrTdCont[num]) return false;
			}
		}
	}
	var insertTr=tableId.insertRow(trIndex);
	if(typeof(bg)!="undefined")
	{
	
		insertTr.onclick=function()
		{
			if(tableID=="myFavoriteListT"){
				mf_flag = "1";
			}else{
				mf_flag = "0";
			} 
			clickTr(event);
		}
		insertTr.onmouseover=function()
		{
			insertTr.style.cursor="pointer";
			insertTr.style.background="#"+bg;
		}
		insertTr.onmouseout=function()
		{
			insertTr.style.cursor="none";
			insertTr.style.background="";
		}
	}
	//insertTr.setAttribute("id",codeChg("td_"+arrTdCont[0]));
	var arrTd=new Array();
	for(var i=0;i<arrTdCont.length;i++)
	{
		if(i==1){
			arrTd[i]=insertTr.insertCell(i);
			arrTd[i].setAttribute("id",codeChg(tableID+"td_"+arrTdCont[0]));
		}else{
			arrTd[i]=insertTr.insertCell(i);
			arrTd[i].setAttribute("id",tableID+"_tr"+trIndex+"_td"+i);			
		}
	}
	for(var i=0;i<arrTdCont.length;i++)
	{
		arrTdCont[i] = arrTdCont[i]+""
		arrTd[i].innerHTML=arrTdCont[i];
	}
}
function ajaxGetLimitAdd(offerId){
	var packet = new AJAXPacket("/npage/portal/shoppingCar/ajax_LimitAdd.jsp","���Ժ�...");
			packet.data.add("offerId" ,offerId);
			packet.data.add("opCode" ,"<%=opCode%>");
			core.ajax.sendPacket(packet,doAjaxGetLimitAdd);
			packet =null;
}

function doAjaxGetLimitAdd(packet){
	  reCodeAdd = packet.data.findValueByName("retCode"); 
		reMsgAdd = packet.data.findValueByName("retMsg"); 
}

/*�û�����*/
function readOnlyAllCustInfo(divId){

	$('#'+divId).find('td').each(function(i){
	
		var $this = $(this);
	
		$this.find('input').each(function(){
	
			var thisType = $(this).attr("type");
			if(thisType == "button"){
				$(this).attr("disabled","disabled");
			}
			if(thisType == "text"){
				$(this).attr("readonly","readonly");
				$(this).attr("class","InputGrey");
			}
			if(thisType == "password"){
				$(this).attr("readonly","readonly");
				$(this).attr("class","InputGrey");
			}
			if(thisType == "file"){
				$(this).attr("readonly","readonly");
				$(this).attr("class","InputGrey");
			}
	
		});
	
		$this.find('select').each(function(){
	
			$(this).attr("disabled","disabled");
	
		});
	
	}); 
	
}
function lianxirenXm(){
	$("#contactPerson").val($("#kehuMingcheng").val());
}


/*2015/6/30 16:55:51 gaopeng ����Ϊ��ѯ ���ʷ� ��Ϣ���� end*/
</SCRIPT>
<body onMouseDown="hideEvent()" onKeyDown="hideEvent()">
  <!--����֤-->
<FORM method=post name="frm1100"   onKeyUp="chgFocus(frm1100)"   ENCTYPE="multipart/form-data"  ><!--����֤-->
       
       <%@ include file="/npage/include/header.jsp" %>   
       <div class="title">
      	<div id="title_zi">�ͻ�����</div>
    	 </div>

  <!------------------------------------------------------------------------>
  		 <div id="canReadOnlyAll">
              <TABLE cellspacing="0" style="display:none;">
                <TBODY> 
                <TR> 
                  <TD width="16%" class="blue" > 
                    <div align="left">��������</div>
                  </TD>
                  <TD> 
                    <input name="newCust" onClick="check_newCust()" type="radio" value="new" checked index="2">
                    �½��� 
                    <input type="radio" name="oldCust" onClick="check_oldCust()" value="old" index="3">
                    ���ϻ� 
          			</TD>
                </TR>
                </TBODY> 
              </TABLE>                                
              <TABLE id=tbs9 width=100%  cellSpacing="0" style="display:none">
                <TBODY> 
                <TR> 
                  <TD width="16%" class="blue" > 
                    <div align="left">�ϼ��ͻ�֤������</div>
                  </TD>
                  <TD width="34%"> <font class=orange> 
                    <input id=in2 name=parentIdidIccid class="button" maxlength="20" onKeyUp="if(event.keyCode==13)getInfo_IccId();" index="4">
                    *</font> 
                    <input name=IDQuery type=button style="cursor:hand" onClick="choiceSelWay()" class="b_text" id="custIdQuery" value=��Ϣ��ѯ>
                  </TD>
                  <TD width="16%" align="left"   class="blue" > 
                    <div align="left">�ϼ��ͻ�����</div>
                  </TD>
                  <TD width="34%">
            <jsp:include page="/npage/common/pwd_1.jsp">
                  <jsp:param name="width1" value="16%"  />
                  <jsp:param name="width2" value="34%"  />
                  <jsp:param name="pname" value="parentPwd"  />
                  <jsp:param name="pwd" value="12345"  />
                  </jsp:include> 
        <!--
                    <input class="button" id=in6 type="password" name=parentPwd  onkeyUp="if(event.keyCode==13)change_custPwd();" maxlength="6" index="5" value="">
        -->
                    <input name=custQuery2 type=button class="b_text" onClick="change_custPwd();" style="cursor:hand" id="accountIdQuery" value=У��>
                  </TD>
                </TR>
                <TR> 
                  <TD class="blue" > 
                    <div align="left">�ϼ��ͻ�����</div>
                  </TD>
                  <TD> 
                    <input class="button" id=in4 name=parentName onKeyUp="if(event.keyCode==13)getInfo_withName();feifaCustName(this);" size=20   maxlength="60">
                    <font class=orange> *</font>
                    <!--<font class=orange> *&nbsp;(�ϼ��ͻ�����Ϊ�����Ҳ��ó�������)</font>-->
                  </TD>
                  <TD class="blue" > 
                    <div align="left">�ϼ��ͻ�֤������</div>
                  </TD>
                  <TD> 
                    <input class="button" id=in3 name=parentIdType readonly>
                  </TD>
                </TR>
                <TR> 
                  <TD class="blue" >
                    <div align="left">�ϼ��ͻ�ID</div>
                  </TD>
                  <TD> <font class=orange> 
                    <input class="button" id=in0 name=parentId  maxlength="22" onKeyUp="if(event.keyCode==13)getInfo_withId();"  v_type="0_9" v_must=0 v_maxlength=14 >
                    *</font> </TD>
                  <TD class="blue" > 
                    <div align="left">�ϼ��ͻ���ַ</div>
                  </TD>
                  <TD> 
                    <input class="button" id=in5 size=35 name=parentAddr   readonly maxlength="60">
                  </TD>
                </TR>
                </TBODY> 
              </TABLE>
              
              <TABLE cellSpacing="0" >
                <TBODY> 
                <TR> 
                  <TD width=16% class="blue"> 
                    <div align="left">�ͻ����</div>
                  </TD>
                  <TD width=34%> 
                    <select align="left" name=ownerType onChange="change()" width=50 index="6">
          <%
          //�õ��������
          String sqlStrt ="select TYPE_CODE,TYPE_NAME from sCustTypeCode Order By TYPE_CODE";
          //retArray = callView.view_spubqry32("2",sqlStr);
          //int recordNum = Integer.parseInt((String)retArray.get(0));
          //result = (String[][])retArray.get(1);
          // result = (String[][])retArray.get(0);  
          %>
          <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCodet" retmsg="retMsgt" outnum="2">
          <wtc:sql><%=sqlStrt%></wtc:sql>
          </wtc:pubselect>
          <wtc:array id="resultt" scope="end" />
          <%  
          int recordNum=0;
          if(retCodet.equals("000000")){
            System.out.println("����sPubSelect���óɹ�");
            recordNum = resultt.length;  
            System.out.println("recordNum  _________________________________________________________"+recordNum);
          }   

      %>
      					<option value="01">����</option>
                    </select>
          <!--wangzn add 091201 Ǳ�ڼ�����ǩԼ b-->
          <span id="preBox" style="display:none" value='1'>&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;
          Ǳ�ڼ�����ǩԼ<input type="checkbox" id="isPre" name="isPre" onClick="preTrShow(this)" /></span>
          <!--wangzn add 091201 Ǳ�ڼ�����ǩԼ e-->
                  </TD>
                  
                  <TD width=16% class="blue" > 
                    <div align="left">�ͻ�ID</div>
                  </TD>
                  <TD width="34%" class="blue" > 
                    <input name="custId" v_type="0_9" class="button" v_must="1" v_name="�ͻ�ID" maxlength="14" readonly>
                    <font class=orange>*</font> 
                    <input name=custQuery type=hidden class="b_text" onmouseup="getId();" onkeyup="if(event.keyCode==13)getId();" style="cursor:hand" id="accountIdQuery" value=��� index="7">
                  </TD>
                </TR>
                
                <!-- tianyang add for custNameCheck start -->
                <tr id="ownerType_Type">
                  <TD width=16% class="blue" > 
                    <div align="left">���˿�������</div>
                  </TD>
                  <TD colspan="3" width="34%" class="blue" >
                    <select align="left" name="isJSX" onChange="reSetCustName()" width=50 index="6">
                      <option class="button" value="0">��ͨ�ͻ�</option>
                   
                    </select>
                    &nbsp;&nbsp;&nbsp;
										<input type="button" id="sendProjectList" name="sendProjectList" class="b_text" value="�·�����" onclick="sendProLists()" style="display:none" />                    
                  	&nbsp;&nbsp;&nbsp;
                  	<input type="button" id="qryListResultBut" name="qryListResultBut" class="b_text" value="���������ѯ" onclick="qryListResults()" style="display:none" />     
                  </TD>
                </tr>
                <!-- tianyang add for custNameCheck end -->
        <!--zhangyan add �ͻ�����ȼ� b-->
                <tr id="trU00020003"  style="display:none">
                  <TD width=16% class="blue" > 
                      <div align="left">�ܲ�ֱ�ܿͻ�</div>
                  </TD>
                    <TD  width="16%" class="blue" >
            <select align="left"  name = "selU0002" id = "selU0002" >
              <option class="button"  value="X" >---��ѡ��---</option>
              <option class="button"  value="1" >1��>��</option>
              <option class="button"  value="0" >0��>��</option>
            </select>
                    </TD>
                  <TD width=16% class="blue" > 
                      <div align="left">ʡ���ͻ�</div>
                  </TD>
                    <TD  width="16%" class="blue" >
            <select align="left"  name = "selU0003" id = "selU0003" >
              <option class="button"  value="X" >---��ѡ��---</option>
              <option class="button"  value="1" >1��>��</option>
              <option class="button"  value="0" >0��>��</option>
            </select>
                    </TD>                   
                </tr>         
                <tr id="svcLvl"  style="display:none">
                  <TD width=16% class="blue" > 
                      <div align="left">�ͻ�����ȼ�</div>
                  </TD>
                    <TD colspan="3" width="34%" class="blue" >
            <select align="left"  name = "selSvcLvl" id = "selSvcLvl" >
              <option class="button"  value="00" >00��>��׼������</option>
              <option class="button"  value="01" >01��>���Ƽ�����</option>
              <option class="button"  value="02" >02��>���Ƽ�����</option>
              <option class="button"  value="03" >03��>ͭ�Ƽ�����</option>
            </select>
                    </TD>
                </tr> 
                <!--zhangyan add �ͻ�����ȼ� e-->   
                                
                <TR> 
                  <TD> 
                    <div align="left" class="blue" >�ͻ���������</div>
                  </TD>
                  <TD> 
                    <select align="left" name=districtCode width=50 index="8">
                      <%
        //�õ��������
                String sqlStr2 ="select trim(DISTRICT_CODE),DISTRICT_NAME from  SDISCODE Where region_code='" + regionCode + "' order by DISTRICT_CODE";                     
               // retArray = callView.view_spubqry32("2",sqlStr);
                
      %>
      <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode2" retmsg="retMsg2" outnum="2">
      <wtc:sql><%=sqlStr2%></wtc:sql>
      </wtc:pubselect>
      <wtc:array id="result2" scope="end" />
      <%


 if(retCode2.equals("000000")){
     
      System.out.println("���÷���ɹ���");
              int recordNum2 = result2.length;
                for(int i=0;i<recordNum2;i++){
                  if(result2[i][0].trim().equals(districtCode)){
                    out.println("<option class='button' value='" + result2[i][0] + "'  selected >" + result2[i][1] + "</option>");
                  }
                  else{
                    out.println("<option class='button' value='" + result2[i][0] + "' >" + result2[i][1] + "</option>");
                  }
                }
      
       }else{
       System.out.println("***********************************************************************");
         System.out.println("���÷���ʧ�ܣ�");
         
      }         
               
               
%>
                    </select>
                  </TD>
                  <TD class="blue" > 
                    <div align="left">�ͻ�����</div>
                  </TD>
                  <TD> 
                    <input name=custName id="kehuMingcheng" value=""  v_must=1 v_maxlength=60 v_type="string"   maxlength="60" size=20 index="9" onkeydown="lianxirenXm()" onkeyup="lianxirenXm()" onblur="if(checkElement(this)){checkCustNameFunc16New(this,0,0)};lianxirenXm();">
                    <div id="checkName" style="display:none"><input type="button" class="b_text" value="��֤" onclick="checkName()"></div>
                   <font class=orange>*</font>
                    </TD>
                </TR>
                <tr> 
                  <td width=16% class="blue" > 
                    <div align="left">֤������</div>
                  </td>
                  <td id="tdappendSome" width=34%> 
                    <select name="idType" id="idTypeSelect" onChange="change_idType()">
						  				<option value="0|����֤">����֤</option>
						  				<option value="2|���ڲ�">���ڲ�</option>
						  				<option value="6|���������">���������</option>
						  				<option value="D|��������֤">��������֤</option>
						  			</select>
                  </td>
                  <td width=16% class="blue" > 
                    <div align="left">֤������</div>
                  </td>
                  <td width=34%> 
                    <input name="idIccid"  id="idIccid"   value=""  v_minlength=4 v_maxlength=20 v_type="string" onChange="change_idType('1')" maxlength="18"   index="11" value="" onBlur="checkIccIdFunc16New(this,0,0);rpc_chkX('idType','idIccid','A');">
                    <input name=IDQueryJustSee type=button class="b_text" style="cursor:hand" onClick="getInfo_IccId_JustSee()" id="custIdQueryJustSee" value=��Ϣ��ѯ >
                    <input type="button" name="iccIdCheck" class="b_text" value="У��" onclick="checkIccId()" disabled>
        						<input type="hidden" name="IccIdAccept" value="<%=IccIdAccept%>">
                    </td>
                </tr>
                
<TR id="card_id_type">
      
      <td colspan=2 align=center>
        <input type="button" name="read_idCard_one" style="display:none;" class="b_text"   value="ɨ��һ������֤" onClick="RecogNewIDOnly_one()" disabled>
        <input type="button" name="read_idCard_two" class="b_text"   value="ɨ���������֤" onClick="RecogNewIDOnly_two()"disabled>
        <input type="button" name="scan_idCard_two" class="b_text"   value="����" onClick="Idcard()" disabled>
        <input type="button" name="scan_idCard_two222" id="scan_idCard_two222" class="b_text"   value="����(2��)" onClick="Idcard2('1')" disabled>
         <input type="hidden"  class="b_text"   value="�ϴ�����֤ͼ��" onClick="sfztpsc1100()">
         <input type="button" name="highView"  class="b_text" style="display:none"   value="������ʶ��" onClick="highViewBtn()">	
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="button" name="get_Photo" class="b_text"   value="��ʾ��Ƭ" onClick="getPhoto()" disabled>
        
        </td>
  <td  class="blue">
        ֤����Ƭ�ϴ�
      </td>
      <td>
        
         <input type="file" name="filep" id="filep" onchange="chcek_pic();" >    &nbsp;
         
         <iframe name="upload_frame" id="upload_frame" style="display:none"></iframe>
         <iframe name="cfm_frame" id="cfm_frame" style="display:none"></iframe>
        
        <input type="hidden" name="idSexH" value="1">
        <input type="hidden" name="birthDayH" value="20090625">
        <input type="hidden" name="idAddrH" value="������">
        
         <input type="button" name="uploadpic_b" class="b_text"   value="�ϴ�����֤ͼ��" onClick="uploadpic()"  disabled>
        
        </td>
     </tr>
                <tr> 
                  <td class="blue" > 
                    <div id="idAddrDiv" align="left">֤����ַ</div>
                  </td>
                  <td> 
                    <input name=idAddr  id="idAddr" value=""   v_must=1 v_type="addrs"  maxlength="60" v_maxlength=60 size=30 index="12" onblur="if(checkElement(this)){checkAddrFunc(this,0,0)}">
                    <font class=orange>*</font> </td>
                  <td class="blue" > 
                    <div align="left">֤����Ч��</div>
                  </td>
                  <td> 
                    <input class="button" name="idValidDate" id="idValidDate" v_must=0 v_maxlength=8 v_type="date"  maxlength=8 size="8" index="13" onblur="if(checkElement(this)){chkValid();}">
                    <!--
                    <img src="../../js/common/date/button.gif" style="cursor:hand"  onclick="fPopUpCalendarDlg(idValidDate);return false" alt=�������������˵� align=absMiddle readonly>
                     -->
                  </td>
                </tr>
        
            
      <TR id ="divPassword" style="display:;"> 
           <jsp:include page="/npage/sq100/f1100_pwd.jsp">
            <jsp:param name="width1" value="16%"  />
            <jsp:param name="width2" value="34%"  />
            <jsp:param name="pname" value="custPwd"  />
            <jsp:param name="pcname" value="cfmPwd"  />
            <jsp:param name="pvalue" value="" />
           </jsp:include>
        </TR>
                <!--TR bgcolor="#EEEEEE"> 
                  <TD> 
                    <div align="left">�ͻ����룺</div>
                  </TD>
                  <TD bgcolor="#EEEEEE"> 
                    <input name=custPwd type="password" v_type="0_9" class="button" v_must=0 v_maxlength=6 v_name="�ͻ�����" maxlength="6" id=passwd1 index="14">
                  </TD>
                  <TD> 
                    <div align="left">У��ͻ����룺</div>
                  </TD>
                  <TD> 
                    <input name=cfmPwd type="password" class="button" v_type="0_9" v_must=0 v_maxlength=6 v_name="У��ͻ�����" maxlength="6"  index="15">
                  </TD>
                </TR-->
                <TR style="display:none"> 
                  <TD class="blue" > 
                    <div align="left">�ͻ�״̬</div>
                  </TD>
                  <TD colspan="3"> 
                    <select align="left" name=custStatus width=50 index="16">
                      <%
        //�õ��������
       
                String sqlStr4 ="select trim(STATUS_CODE),STATUS_NAME from sCustStatusCode order by STATUS_CODE";                      
               // retArray = callView.view_spubqry32("2",sqlStr4);
                //int recordNum = Integer.parseInt((String)retArray.get(0));
                //result = (String[][])retArray.get(1);
               // result = (String[][])retArray.get(0);
               
%>
<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode4" retmsg="retMsg4" outnum="2">
<wtc:sql><%=sqlStr4%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result4" scope="end" /> 
<%
         
          if(retCode4.equals("000000")){
     
      System.out.println("���÷���ɹ���");
              
                int recordNum4 = result4.length;                  
                for(int i=0;i<recordNum4;i++){
                        out.println("<option class='button' value='" + result4[i][0] + "'>" + result4[i][1] + "</option>");
                }
      
       }else{
       System.out.println("***********************************************************************");
         System.out.println("���÷���ʧ�ܣ�");
         
      }      
%>


<%             
%>
                    </select>
                    <select  align="left" name=custGrade width=50 index="17" style="display:none" >
                      <%
        //�õ��������
          String sqlStr5 ="select trim(OWNER_CODE), TYPE_NAME from sCustGradeCode " + 
                   " where REGION_CODE ='" + regionCode + "' order by OWNER_CODE";                  
                //retArray = callView.view_spubqry32("2",sqlStr5);
                //int recordNum = Integer.parseInt((String)retArray.get(0));
                //result = (String[][])retArray.get(1);
                //result = (String[][])retArray.get(0);
               
%>
<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode5" retmsg="retMsg5" outnum="2">
<wtc:sql><%=sqlStr5%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result5" scope="end" /> 

<%    
    if(retCode5.equals("000000")){
     
      System.out.println("���÷���ɹ���");
              
               int recordNum5 = result5.length;                  
                for(int i=0;i<recordNum;i++){
                        out.println("<option class='button' value='" + result5[i][0] + "'>" + result5[i][1] + "</option>");
                }
      
       }else{
       System.out.println("***********************************************************************");
         System.out.println("���÷���ʧ�ܣ�");
         
      }      

               
%>
                    </select>
                  </TD>
                </TR>
                <TR> 
                  <TD class="blue" > 
                    <div align="left">�ͻ���ַ</div>
                  </TD>
                  <TD colspan="3"> 
                    <input name=custAddr class="button"  v_type="addrs" v_must=1 v_maxlength=60   maxlength="60" size=35 index="18" onblur="if(checkElement(this)){checkAddrFunc(this,1,0)}">
                    <font class=orange>*</font> 
                  </TD>
                  </TD>
                </TR>
                <!--wangzn add 091201 forǱ�ڼ�����ǩԼ b-->
                <tr id="preTr" style="display:none"> 
                  <td class="blue" >Ǳ�ڼ��ű��</td>
                  <td colspan="3"><input name="preUnitId" id="preUnitId" class="button"  maxlength="20" size=20 v_type=0_9 v_must=0 v_minlength=10 ><font class=orange>*</font>
                  <input name=preUnitIdQuery type=button class="b_text" onmouseup="preGrpQuery()" onkeyup="if(event.keyCode==13)preGrpQuery();" style="cursor:hand" id="preUnitIdQuery" value=��ѯ >
                </tr>
                 <!--wangzn add 091201 forǱ�ڼ�����ǩԼ e-->                
                <TR> 
                  <TD class="blue" > 
                    <div align="left">��ϵ������</div>
                  </TD>
                  <TD> 
                    <input id="contactPerson" name=contactPerson onclick="lianxirenXm()" class="button" value="" v_type="string"  maxlength="60" size=20 index="19" v_must=1 v_maxlength=60 onblur="if(checkElement(this)){checkCustNameFunc(this,1,0)}">
                    <font class=orange>*</font>
                    <font class=orange></font>
                    <!--<font class=orange>*&nbsp;(��ϵ������Ϊ�����Ҳ��ó�������)</font>-->
                  </TD>
                  <TD class="blue" > 
                    <div align="left">��ϵ�˵绰</div>
                  </TD>
                  <TD> 
                    <input name=contactPhone class="button" v_must=1 v_type="phone" maxlength="20"  index="20" size="20" onblur="checkElement(this);" value="">
                    <font class=orange>*</font> </TD>
                </TR>
                <TR> 
                  <TD class="blue" > 
                    <div align="left">��ϵ�˵�ַ</div>
                  </TD>
                  <TD> 
                    <input name=contactAddr  class="button" v_must=1 v_type="addrs"  maxlength="60" v_maxlength=60 size=30 index="21"  onblur="if(checkElement(this)){ checkAddrFunc(this,2,0);}">
                    <font class=orange>*</font> </TD>
                  <TD class="blue" > 
                    <div align="left">��ϵ���ʱ�</div>
                  </TD>
                  <TD> 
                    <input name=contactPost class="button" v_type="zip" v_name="��ϵ���ʱ�" maxlength="6"  index="22" size="20">
                  </TD>
                </TR>
                <TR> 
                  <TD class="blue" > 
                    <div align="left">��ϵ�˴���</div>
                  </TD>
                  <TD> 
                    <input name=contactFax class="button" v_must=0 v_type="phone" v_name="��ϵ�˴���" maxlength="20"  index="23" size="20">
                  </TD>
                  <TD class="blue" > 
                    <div align="left">��ϵ��E_MAIL</div>
                  </TD>
                  <TD> 
                    <input name=contactMail class="button" v_must=0 v_type="email" v_name="��ϵ��E_MAIL" maxlength="30" size=30 index="24">
                  </TD>
                </TR>
                <TR> 
                  <TD class="blue" > 
                    <div align="left">��ϵ��ͨѶ��ַ</div>
                  </TD>
                  <TD colspan="3"> 
                    <input name=contactMAddr class="button" v_must=1 v_maxlenth=60 v_type="addrs"  maxlength="60" size=35 index="25" onblur="if(checkElement(this)){checkAddrFunc(this,3,0)}">
                    <font class=orange>*</font></TD>
                </TR>
                
                <!-- 20131216 gaopeng 2013/12/16 10:29:28 ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭������Ϣ start -->
                <%@ include file="/npage/sq100/gestoresInfo.jsp" %>  
								             
                <TR id="isDirectManageCustTr1" style="display:none"> 
                  <td width=16% class="blue" > 
                    <div align="left">�Ƿ�ֱ�ܿͻ�</div>
                  </td>
                  <td width=34%> 
                    <select name="isDirectManageCust" id="isDirectManageCust" onchange="qryDirectManageCustInfo1(this)">
                    	<option value="0" selected>��</option>
                    	<option value="1">��</option>
                    </select>
                  </td>
									<TD width=16%  class="blue" > 
										<div align="left">ֱ�ܿͻ�����</div>
									</TD>
									<TD width=34%> 
										<input name="directManageCustNo" id="directManageCustNo"  class="button" v_must='0' v_type="string"  maxlength="60" v_maxlength=60 size=30 index="21" />
									</TD>
                </TR>
                <tr id="isDirectManageCustTr2" style="display:none"> 
                  <TD width=16% class="blue" > 
										<div align="left">��֯��������</div>
									</TD>
									<TD width=34% colspan="3"> 
										<input name="groupNo" id="groupNo"  class="button" v_must='0' v_type="string"  maxlength="60" v_maxlength=60 size=30 index="21"  onblur="qryDirectManageCustInfo2(this)" />
									</TD>
                </tr>
                </TBODY> 
              </TABLE> 
                                        
              <TABLE id=tb0 cellSpacing="0" style="display:none">
                <TBODY> 
                <TR> 
                  <TD width=16% class="blue" > 
                    <div align="left">�ͻ��Ա�</div>
                  </TD>
                  <TD width=34%> 
                    <select align="left" name=custSex width=50 index="26">
                      <%
        //�õ��������
            String sqlStr6 ="select trim(SEX_CODE), SEX_NAME from ssexcode order by SEX_CODE";                 
                //retArray = callView.view_spubqry32("2",sqlStr6);
                //int recordNum = Integer.parseInt((String)retArray.get(0));
                //result = (String[][])retArray.get(1);
                //result = (String[][])retArray.get(0);
              
 %>
 <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode6" retmsg="retMsg6" outnum="2">
<wtc:sql><%=sqlStr6%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result6" scope="end" /> 

<%    
    if(retCode6.equals("000000")){
     
      System.out.println("���÷���ɹ���");
              
                int recordNum6 = result6.length;                  
                for(int i=0;i<recordNum6;i++){
                        out.println("<option class='button' value='" + result6[i][0] + "'>" + result6[i][1] + "</option>");
                }
      
       }else{
       System.out.println("***********************************************************************");
         System.out.println("���÷���ʧ�ܣ�");
         
      }            
%>
                    </select>
                  </TD>
                  <TD width=16%  class="blue" > 
                    <div align="left">��������</div>
                  </TD>
                  <TD width="34%"> 
                    <input  name=birthDay id="birthDay"   maxlength=8 index="27"  v_must=0 v_maxlength=8 v_type="date" size="8" onblur="checkElement(this);">
                    <!--
                    <img src="../../js/common/date/button.gif" style="cursor:hand"  onclick="fPopUpCalendarDlg(birthDay);return false" alt=�������������˵� align=absMiddle >
                -->
                  </TD>
                </TR>
                <TR> 
                  <TD class="blue" > 
                    <div align="left">ְҵ���</div>
                  </TD>
                  <TD> 
                    <select align="left" name=professionId width=50 index="28">
                      <%
        //�õ��������
      
                String sqlStr7 ="select trim(PROFESSION_ID), PROFESSION_NAME from sprofessionid order by PROFESSION_ID DESC";                      
              //  retArray = callView.view_spubqry32("2",sqlStr7);
                //int recordNum = Integer.parseInt((String)retArray.get(0));
                //result = (String[][])retArray.get(1);
               // result = (String[][])retArray.get(0);
               
%>
 <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode7" retmsg="retMsg7" outnum="2">
<wtc:sql><%=sqlStr7%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result7" scope="end" /> 

<%    
    if(retCode7.equals("000000")){
     
      System.out.println("���÷���ɹ���");
              
               int recordNum7 = result7.length;                  
                for(int i=0;i<recordNum7;i++){
                        out.println("<option class='button' value='" + result7[i][0] + "'>" + result7[i][1] + "</option>");
                }
      
       }else{
       System.out.println("***********************************************************************");
         System.out.println("���÷���ʧ�ܣ�");
         
      }            
%>
                    </select>
                  </TD>
                  <TD class="blue" > 
                    <div align="left">ѧ��</div>
                  </TD>
                  <TD> 
                    <select align="left" name=vudyXl width=50 index="29">
                      <%
        //�õ��������
           String sqlStr8 ="select trim(WORK_CODE), TYPE_NAME from SWORKCODE Where region_code ='" + regionCode + "' order by work_code DESC";                    
              //  retArray = callView.view_spubqry32("2",sqlStr8);
                //int recordNum = Integer.parseInt((String)retArray.get(0));
                //result = (String[][])retArray.get(1);
                //result = (String[][])retArray.get(0);
               
%>
<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode8" retmsg="retMsg8" outnum="2">
<wtc:sql><%=sqlStr8%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result8" scope="end" /> 

<%    
    if(retCode8.equals("000000")){
     
      System.out.println("���÷���ɹ���");
              
             int recordNum8 = result8.length;                  
                for(int i=0;i<recordNum8;i++){
                        out.println("<option class='button' value='" + result8[i][0] + "'>" + result8[i][1] + "</option>");
                }
      
       }else{
       System.out.println("***********************************************************************");
         System.out.println("���÷���ʧ�ܣ�");
         
      }    
  %>
                    </select>
                  </TD>
                </TR>
                <TR> 
                  <TD class="blue" > 
                    <div align="left">�ͻ�����</div>
                  </TD>
                  <TD> 
                    <input name=custAh class="button" maxlength="20"  index="30" size="20">
                  </TD>
                  <TD class="blue" > 
                    <div align="left">�ͻ�ϰ��</div>
                  </TD>
                  <TD> 
                    <input name=custXg class="button" maxlength="20"  index="31">
                  </TD>
                </TR>
                </TBODY> 
              </TABLE>                                
        
              <TABLE id=tb1 cellSpacing="0" style="display:none">
                <TBODY> 

                <TR> 
                  <TD width=16% class="blue" > 
                    <div align="left">��λ����</div>
                  </TD>
                  <TD width=34%> 
                    <select align="left" name=unitXz1 width=50 index="32">
                      <%
                      //�õ��������
               
                String sqlStr9 ="select trim(TYPE_CODE), TYPE_NAME from sunittype order by TYPE_CODE";                    
                //retArray = callView.view_spubqry32("2",sqlStr9);
                //int recordNum = Integer.parseInt((String)retArray.get(0));
                //result = (String[][])retArray.get(1);
                //result = (String[][])retArray.get(0);
                
%>
<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode9" retmsg="retMsg9" outnum="2">
<wtc:sql><%=sqlStr9%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result9" scope="end" /> 

<%    
    if(retCode9.equals("000000")){
     
      System.out.println("���÷���ɹ���");
              
            int recordNum9 = result9.length;                  
                for(int i=0;i<recordNum9;i++){
                        out.println("<option class='button' value='" + result9[i][0] + "'>" + result9[i][1] + "</option>");
                }
      
       }else{
       System.out.println("***********************************************************************");
         System.out.println("���÷���ʧ�ܣ�");
         
      }          
%>
                    </select>
                  </TD>
                  <TD width=16% class="blue" > 
                    <div align="left">Ӫҵִ������</div>
                  </TD>
                  <TD width=34%> 
                    <select align="left" name=yzlx width=50 index="33">
                      <%
        //�õ��������
        
                String sqlStr10 ="select trim(LINCENT_TYPE), TYPE_NAME from slicencetype order by LINCENT_TYPE";                
               // retArray = callView.view_spubqry32("2",sqlStr10);
                //int recordNum = Integer.parseInt((String)retArray.get(0));
                //result = (String[][])retArray.get(1);
               // result = (String[][])retArray.get(0);
              
%>
<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode10" retmsg="retMsg10" outnum="2">
<wtc:sql><%=sqlStr10%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result10" scope="end" /> 
<%    
    if(retCode10.equals("000000")){
     
      System.out.println("���÷���ɹ���");
              
           int recordNum10 = result10.length;                  
                for(int i=0;i<recordNum10;i++){
                        out.println("<option class='button' value='" + result10[i][0] + "'>" + result10[i][1] + "</option>");
                }
      
       }else{
       System.out.println("***********************************************************************");
         System.out.println("���÷���ʧ�ܣ�");
         
      }                       
%>
                    </select>
                  </TD>
                </TR>
                
                
                <TR> 
                  <TD class="blue" > 
                    <div align="left">Ӫҵִ�պ���</div>
                  </TD>
                  <TD> 
                    <input name=yzhm class="button" maxlength="20"  index="34">
                  </TD>
                  <TD class="blue" > 
                    <div align="left">Ӫҵִ����Ч��</div>
                  </TD>
                  <TD> 
                    <input name=yzrq class="button"  index="35" v_must=0 v_maxlength=8 v_type="date" v_name="Ӫҵִ����Ч��" maxlength=8 size="8">
                  </TD>
                </TR>
                <TR> 
                  <TD class="blue" > 
                    <div align="left">���˴���</div>
                  </TD>
                  <TD COLSPAN="3"> 
                    <input name=frdm class="button" maxlength="20"  index="36">
                  </TD>
                </TR>
                </TBODY> 
              </TABLE>
              
              
           <TABLE width=100% id=td2 cellSpacing="0" style="display:none">
            
                <TR> 
             
                  <TD width=16% class="blue" > 
                    <div align="left">ԭ���ź�</div>
                  </TD>
                  <TD width=84%> 
                <div align="left"><input name=oriGrpNo class="button" maxlength="10"  index="37" v_must=0 v_maxlength=10 v_type=0_9 v_name="ԭ���ź�"></div>
             </td>
           </tr>
           
           
         <TABLE id=td3  cellSpacing="0" style="display:none">
          <TBODY> 
               <TR> 
         <TD width=16% class="blue" > 
                    <div align="left">���ŵȼ�</div>
                  </TD>
                  <TD width=34% colspan="3"> 
                    <select align="left" name=unitXz width=50 index="32">
<%
                //�õ��������
           
                String sqlStr11 ="select trim(owner_code), owner_NAME from dbvipadm.sGrpOwnerCode  where owner_code in ('C1','C2','C3','E')";                    
               // retArray = callView.view_spubqry32("2",sqlStr11);
                //int recordNum = Integer.parseInt((String)retArray.get(0));
                //result = (String[][])retArray.get(1);
              //  result = (String[][])retArray.get(0);
              
%>
<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode11" retmsg="retMsg11" outnum="2">
<wtc:sql><%=sqlStr11%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result11" scope="end" /> 

<%    
    if(retCode11.equals("000000")){
     
      System.out.println("���÷���ɹ���");
              
            int recordNum11 = result11.length;                  
                for(int i=0;i<recordNum11;i++){
                        out.println("<option class='button' value='" + result11[i][0] + "'>" + result11[i][1] + "</option>");
                }
      
       }else{
       System.out.println("***********************************************************************");
         System.out.println("���÷���ʧ�ܣ�");
         
      }            


      
%>
                   </select>
                  </TD>
                </TR>
    <!--luxc 20080326 add-->
    <tr>
      <td width=16% class="blue" >�Ƿ��ǲ߷�����</td>
      <td width=34%>
        <select align="left" name="instigate_flag" onChange="change_instigate()" width=50 index="42">
          <option class="button" value="0">...��ѡ��...</option>
          <option class="button" value="Y">��->Y</option>
          <option class="button" value="N">��->N</option>
        </select>
        <font class=orange>*</font>
      </td>
      <td width=17% class="blue" >�Ƿ��þ�������Э��</td>
        
      <td width=33%>
        <select align="left" name="getcontract_flag" width=50 index="42" disabled >
          <option class="button" value="0">...��ѡ��...</option>
          <option class="button" value="Y">��->Y</option>
          <option class="button" value="N">��->N</option>
        </select>
      </td>
  </tr>  
  <!--luxc 20080326 add end-->
  
     </TBODY> 
    </TABLE>        
  <TABLE cellSpacing="0">
    <TBODY> 
    <TR style="display:none"> 
      <TD width=16% class="blue" > 
        <div align="left">ϵͳ��ע</div>
      </TD>
      <TD> 
        <input class="button" name=sysNote size=60 readonly maxlength="60">
      </TD>
      <td style="display:none">
				  <SELECT name="receiveRegion" id="receiveRegion"> 
          </SELECT>
				 </td>
    </TR>
    <TR style="display:none"> 
      <TD width="16%" class="blue" > 
        <div align="left">�û���ע</div>
      </TD>
      <TD> 
        <input name=opNote class="button" size=60 maxlength="60" index="38"  v_must=0 v_maxlength=60 v_type="string" v_name="�û���ע">
      </TD>
    </TR>
    </TBODY> 
  </TABLE>
  
  
  <TABLE cellSpacing="0">
  <TBODY>
    <TR> 
      <td align=center id="footer"> 
        <input class="b_foot_long" name="print"  onclick="printCommit()" onkeyup="if(event.keyCode==13)printCommit()" disabled="disabled" type=button value="�ͻ�����"  index="39" >
      	<input class="b_foot" name=reset1 type=button  onclick=" window.location.reload();" value=���� index="40">
    	</td>
     </TR>
  </TBODY>
</TABLE>
</div>
	<div id="showAndHideUserOpen" style="display:none">
	
	  <div class="title">
			<div id="title_zi">�û��������ʷ���Ϣ</div>
		</div>
		<div class="title">
			<div id="title_zi">���ʷ��б�</div>
		</div>
		<div class="list" style="height:156px; overflow-y:auto; overflow-x:hidden;">
			<table id="queryOfferList" cellspacing=0>
			<tr>
				<th>����Ʒ����</th>
				<th>����Ʒ����</th>
				<th>Ʒ������</th>
				<th>˵��</th>
			</tr>
			</table>
		</div>
		<div class="title">
			<div id="title_zi">��ѡ���ʷ���Ϣ</div>
		</div>
		<div class="list" style="height:60px; overflow-y:auto; overflow-x:hidden;">
			<table id="productOfferList" cellspacing=0>
				<tr>
					<th>����Ʒ����</th>
					<th>����Ʒ����</th>
					<th>Ʒ������</th>
					<th>����Ʒ�ʷ�����</th>
					<th>����</th>
				</tr>					
			</table>
		</div>
		
		<table>
	   <tr>
			<td align=center colspan="4" id="footer">
				<input class="b_foot" id="configBtn" name="configBtn"  type="button" value="��һ��"   onclick="nextStepOpen();">&nbsp;&nbsp;
			</td>
		</tr>
		
		</table>
		
		<div id="myLoadSome">
			
		</div>
	</div>                                   

  <input type="hidden" name="ReqPageName" value="f1100_1">
  <input type="hidden" name="workno" value=<%=workNo%>>
  <input type="hidden" name="opCode" value="<%=opCode%>">
  <input type="hidden" name="regionCode" value=<%=regionCode%>> 
  <input type="hidden" name="unitCode" value=<%=orgCode%>>
  <input type="hidden" id=in6 name="belongCode" value=<%=belongCode%>>  
  <input type="hidden" id=in1 name="hidPwd" v_name="ԭʼ����">
  <input type="hidden" name="hidCustPwd">       <!--���ܺ�Ŀͻ�����-->
  <input type="hidden" name="temp_custId">
  <input type="hidden" name="ip_Addr" value=<%=ip_Addr%>>
  <input type="hidden" name="inParaStr" >
  <input type="hidden" name="checkPwd_Flag" value="false">    <!--����У���־-->
  <input type="hidden" name="workName" value=<%=workName%> >
  <input type="hidden" name="assu_name" value="">
  <input type="hidden" name="assu_phone" value="">
  <input type="hidden" name="assu_idAddr" value="">
  <input type="hidden" name="assu_idIccid" value="">
  <input type="hidden" name="assu_conAddr" value="">
  <input type="hidden" name="assu_idType" value="">
  <input type="hidden" name="inputFlag" value="<%=inputFlag%>">
  <iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>
  <input type="hidden" name="card_flag" value="">  <!--����֤������־-->
  <input type="hidden" name="pa_flag" value="">  <!--֤����־-->
  <input type="hidden" name="m_flag" value="">   <!--ɨ����߶�ȡ��־������ȷ���ϴ�ͼƬʱ���ͼƬ��-->
  <input type="hidden" name="sf_flag" value="">   <!--ɨ���Ƿ�ɹ���־-->
  <input type="hidden" name="pic_name" value="">   <!--��ʶ�ϴ��ļ�������-->
  <input type="hidden" name="up_flag" value="0">
  <input type="hidden" name="but_flag" value="0"> <!--��ť�����־-->
  <input type="hidden" name="upbut_flag" value="0"> <!--�ϴ���ť�����־-->
  <input type="hidden" name="ziyou_check" value="<%=resultl0[0][0]%>">
  <input type="hidden" name="isSendListFlag" id="isSendListFlag" value="N" />
  <input type="hidden" name="isQryListResultFlag" id="isQryListResultFlag" value="N" />
  <input type="hidden" name="sendListOpenFlag" id="sendListOpenFlag" value="<%=sendListOpenFlag%>" />
  <input type="hidden" name="servBusId" value="">
  
  <input type="hidden" id="myidNo" name="myidNo" value="">
  <input type="hidden" id="myofferId" name="myofferId" value="">
  <input type="hidden" id="myofferName" name="myofferName" value="">
  <input type="hidden" id="myofferType" name="myofferType" value="">
  <input type="hidden" id="myservBusiId" name="myservBusiId" value="">
  <input type="hidden" id="myofferInfoCode" name="myofferInfoCode" value="">
  <input type="hidden" id="myofferInfoValue" name="myofferInfoValue" value="">
  
  
  
  <input type="hidden" id="myCustId" name="myCustId" value="">
  <input type="hidden" id="myCustName" name="myCustName" value="">
  
  
  <%@ include file="/npage/include/footer.jsp" %> 
 
<jsp:include page="/npage/common/pwd_comm.jsp"/>
</form>
</body>
<OBJECT id="CardReader_CMCC" height="0" width="0"  classid="clsid:FFD3E742-47CD-4E67-9613-1BB0D67554FF" codebase="/npage/public/CardReader_AGILE.cab#version=1,0,0,6"></OBJECT>
<%@ include file="/npage/sq100/interface_provider.jsp" %>   
<%@ include file="/npage/include/public_smz_check.jsp" %>
</html>