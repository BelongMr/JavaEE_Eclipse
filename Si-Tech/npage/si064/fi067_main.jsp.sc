<%
/********************
 version v2.0
 ������: si-tech
 2015/12/17 15:35:24 gaopeng ������ͨ����
********************/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="/npage/bill/getMaxAccept.jsp" %>
<%@ page import="java.text.SimpleDateFormat"%> <!--����֤-->
<wtc:sequence name="sPubSelect" key="sMaxSysAccept" id="sLoginAccept"/>
<%        
  //Logger logger = Logger.getLogger("f1100_1.jsp");
  //ArrayList retArray = new ArrayList();
  //String[][] result = new String[][]{};
  // S1100View callView = new S1100View(); 
  String printAccept = "";
  String IccIdAccept="";
  response.setHeader("Pragma","No-cache");
  response.setHeader("Cache-Control","no-cache"); 
  Calendar today =   Calendar.getInstance();  
  today.add(Calendar.MONTH,3);
  SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");  
  String addThreeMonth = sdf.format(today.getTime());
  System.out.println("### addThreeMonth = "+addThreeMonth);
  String dateStr2 =  new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
  String currTime = new SimpleDateFormat("yyyyMMdd HH:mm:ss", Locale.getDefault()).format(new Date());
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
    String loginAccept = getMaxAccept();
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
    
    String accountType =  (String)session.getAttribute("accountType")==null?"":(String)session.getAttribute("accountType");//1 ΪӪҵ���� 2 Ϊ�ͷ�����
%>
<%
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
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/product/autocomplete_ms.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/product/product.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/si/validate_class.js"></script>
<script type="text/javascript" src="/npage/public/checkGroup.js" ></script>
</head>
<!----------------------------------------------------------------->
<SCRIPT type=text/javascript>
var numStr="0123456789"; 
 
var v_groupId = "<%=groupId%>";
var v_printAccept = "<%=printAccept%>";
var v_workNo = "<%=workNo%>";
var phone_no = "";

onload=function(){
	getId();
	setOfferType();
	addRegCode();
	reSetCustName();
  /**
  if("09" == "<%=regionCode%>"){
    var divPassword = document.getElementById("divPassword"); 
      divPassword.style.display="none";
  }
  */
  
  getIdTypes();
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
function resIdTypes(data){
				//alert(data);
			//�ҵ����ӵ�select
				var markDiv=$("#tdappendSome"); 
				//���ԭ�б���
				markDiv.empty();
				markDiv.append(data);
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
  document.all.Reset.click();
 
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
            document.all("tb0").style.display="";   
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

function change_idType()//����֤
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
      
    if(document.all.idType.value=="0|����֤")
    { 
      document.all.pa_flag.value="1"; 
   
    
    }
    else{
     
    document.all.pa_flag.value="0";
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
	/*2013/11/18 15:09:28 gaopeng �����ύ֮ǰ��У�� ���ڽ�һ������ʡ��֧��ϵͳʵ���Ǽǹ��ܵ�֪ͨ start*/
	/*����У��*/
    		/*�ͻ�����*/
			if(!checkElement(document.all.custName)){
				return false;
			}
    		if(!checkCustNameFunc16New(document.all.custName,0,1)){
    			return false;
    		}
    		/*��ϵ������*/
    		if(!checkElement(document.all.contactPerson)){
				return false;
			}
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
					if(!checkElement(document.all.gestoresName)){
						return false;
					}
					/*��������ϵ��ַ*/
					if(!checkElement(document.all.gestoresAddr)){
						return false;
					}
					/*������֤������*/
					if(!checkElement(document.all.gestoresIccId)){
						return false;
					}
	/*2013/11/18 15:09:28 gaopeng �����ύ֮ǰ��У�� ���ڽ�һ������ʡ��֧��ϵͳʵ���Ǽǹ��ܵ�֪ͨ end*/
	
	
		/*����������*/
	if(!checkElement(document.all.responsibleName)){
		return false;
	}
	/*��������ϵ��ַ*/
	if(!checkElement(document.all.responsibleAddr)){
		return false;
	}
	/*������֤������*/
	if(!checkElement(document.all.responsibleIccId)){
		return false;
	}
	

	if(!checkCustNameFunc16New(document.all.responsibleName,2,1)){
		return false;
	}

	if(!checkAddrFunc(document.all.responsibleAddr,5,1)){
				return false;
	}

	if(!checkIccIdFunc16New(document.all.responsibleIccId,2,1)){
						return false;
	}
	else{
		rpc_chkX('idType','idIccid','A');
	}
	


				/*ʵ��ʹ��������*/
				if(!checkElement(document.all.realUserName)){
					return false;
				}
				/*ʵ��ʹ������ϵ��ַ*/
				if(!checkElement(document.all.realUserAddr)){
					return false;
				}
				/*ʵ��ʹ����֤������*/
				if(!checkElement(document.all.realUserIccId)){
					return false;
				}
				
			  if(!checkCustNameFunc16New(document.all.realUserName,3,1)){
					return false;
				}
			
				if(!checkAddrFuncNew(document.all.realUserAddr,5,1)){
							return false;
					}
			
				if(!checkIccIdFunc16New(document.all.realUserIccId,3,1)){
									return false;
				}		
				else{
					rpc_chkX('idType','idIccid','A');
				}
					
	
        if((document.all.opNote.value).trim().length==0)
        {//luxc20061218�޸ı�ע�ֶ� ��ֹ̫���岻��wchg��
                document.all.opNote.value="<%=workName%>"+"����Ԥ����";
        }
        if((document.all.opNote.value).trim().length>60)
        {
          rdShowMessageDialog("�û���ע��ֵ����ȷ�������д���");
          document.all.opNote.focus();
          return false;
        }
        
        var selOrderVal = $.trim($("input[name='selOrder'][checked]").val());
        if(selOrderVal.length == 0){
        	rdShowMessageDialog("���ѯ��ѡ������Ʒ��");
          return false;
        }
        
        //myTest();
        
      if(!check(frm1100)){
      	return false;
      }else{
      if(rdShowConfirmDialog("ȷ��Ҫ�ύ����������Ϣ��")==1) {
        <% if("1".equals(inputFlag)){ %>
          document.frm1100.target="hidden_frame";
        <% }else{ %>
          //����֤
          frm1100.target=""; 
        <% } %>
        
        
        
        /*ִ���ϴ��ļ��������ϴ��ļ�����÷���*/
				if($("#uploadFile").val() == ""){
					rdShowMessageDialog("��ѡ�����������ļ���");
					$("#uploadFile").focus();
					return false;
				}
        
        var formFile=document.all.uploadFile.value.lastIndexOf(".");
				var beginNum=Number(formFile)+1;
				var endNum=document.all.uploadFile.value.length;
				formFile=document.all.uploadFile.value.substring(beginNum,endNum);
				formFile=formFile.toLowerCase(); 
				if(formFile!="txt"){
					rdShowMessageDialog("�ϴ��ļ���ʽֻ����txt��������ѡ���ļ���",1);
					document.all.uploadFile.focus();
					return false;
				}
				else
					{
						var jsp_action = "/npage/si064/fi067_upload_cfm.jsp"+
														  "?logacc=<%=sLoginAccept%>"+
															"&chnSrc=01"+
															"&opCode=<%=opCode%>"+
															"&workNo=<%=workNo%>"+
															"&passwd=<%=passwd%>"+
															"&phoNo="+
															"&usrPwd="+
															"&opName=<%=opName%>"+	
															"&custName="+document.all.custName.value+
															"&idType="+document.all.idType.value+
															"&idIccid="+document.all.idIccid.value+
															"&idAddr="+document.all.idAddr.value+
															"&idValidDate="+document.all.idValidDate.value+
															"&contactPerson="+document.all.contactPerson.value+
															"&contactPhone="+document.all.contactPhone.value+
															"&contactAddr="+document.all.contactAddr.value+
															"&gestoresName="+document.all.gestoresName.value+
															"&gestoresAddr="+document.all.gestoresAddr.value+
															"&gestoresIdType="+document.all.gestoresIdType.value+
															"&gestoresIccId="+document.all.gestoresIccId.value+
															"&selOrder="+$.trim($("input[name='selOrder'][checked]").val())+
															"&responsibleName="+document.all.responsibleName.value+
															"&responsibleAddr="+document.all.responsibleAddr.value+
															"&responsibleType="+document.all.responsibleType.value+
															"&responsibleIccId="+document.all.responsibleIccId.value+
															"&realUserName="+document.all.realUserName.value+
															"&realUserAddr="+document.all.realUserAddr.value+
															"&realUserIdType="+document.all.realUserIdType.value+
															"&realUserIccId="+document.all.realUserIccId.value;
															
						/*׼���ϴ�*/
				    document.frm1100.encoding="multipart/form-data";
				    document.frm1100.action=jsp_action;
				    document.frm1100.method="post";
				    document.frm1100.submit();
						return true;
					}
      }
      
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

function printInfo(printType)
{
  var retInfo = "";
  var cust_info=""; //�ͻ���Ϣ
  var opr_info=""; //������Ϣ
  var note_info1=""; //��ע1
  var note_info2=""; //��ע2
  var note_info3=""; //��ע3
  var note_info4=""; //��ע4
  var retInfo = "";  //��ӡ����

    if(printType == "Detail")
    { 
      
        var getAcceptFlag = "<%=getAcceptFlag%>";
        if(getAcceptFlag == "failed")
        { return "failed";  }
      /*retInfo = retInfo + "10|2|0|0|��ӡ��ˮ:  " + "<%=printAccept%>" + "|"; */
    
   
    /*retInfo+='<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime())%>'+"|"; */
    
    cust_info+= "�ͻ�������     "+frm1100.custName.value+"|";
    //retInfo+= "֤�����ͣ�   "+frm1100.idType.value+"|";
    cust_info+= "֤�����룺     "+frm1100.idIccid.value+"|";
    cust_info+= "�ͻ���ַ��     "+frm1100.idAddr.value+"|";
    //retInfo+=" |";
    cust_info+= "��ϵ��������   "+frm1100.contactPerson.value+"|";
    cust_info+= "��ϵ�˵绰��   "+frm1100.contactPhone.value+"|";
    cust_info+= "��ϵ�˵�ַ��   "+frm1100.contactAddr.value+"|";
    
    opr_info+= "��ӡ��ˮ:     " + "<%=printAccept%>" + "|";
    opr_info+=" "+"|";
    opr_info+= "�ͻ�������*|";

    note_info1+=document.all.sysNote.value+"|";
    note_info1+=document.all.opNote.value+"|";
    note_info1+=" |";

    
    note_info2+=document.all.assu_name.value+"|";
    note_info2+=document.all.assu_phone.value+"|";
    note_info2+=document.all.assu_idAddr.value+"|";
    note_info2+=document.all.assu_idIccid.value+"|";
    
   
    retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
    retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
  }
    
    if(printType == "Bill")
    {
     
  }
  return retInfo; 
}



/*
	2013/11/18 11:15:44
	gaopeng
	�ͻ���ַ��֤����ַ����ϵ�˵�ַУ�鷽��
	���ͻ���ַ������֤����ַ���͡���ϵ�˵�ַ�����衰���ڵ���8�����ĺ��֡�
	����������պ�̨��ͨ��֤���⣬���������Ҫ�����2�����֣�̨��ͨ��֤Ҫ�����3�����֣�
*/

function checkAddrFuncNew(obj,objType,ifConnect){
	var nextFlag = true;
	
		if(document.all.realUserAddr.v_must !="1") {
	  return nextFlag;
	  return false;		
	}
	
	
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
	if(objType == 5){
		objName = "ʵ��ʹ������ϵ��ַ";
		idTypeVal = document.all.realUserIdType.value;
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
		var idTypeText = idTypeVal;
		
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
	
	
}
return nextFlag;
}

/*
	2013/11/18 14:01:09
	gaopeng
	֤�����ͱ��ʱ��֤�������У�鷽��
*/

function checkIccIdFuncNew(obj,objType,ifConnect){
	var nextFlag = true;
	
	if(document.all.realUserIccId.v_must !="1") {
	  return nextFlag;
	  return false;		
	}
	
	
	var idTypeVal = "";
	if(objType == 0){
		var objName = "֤������";
		idTypeVal = document.all.idType.value;
	}
	if(objType == 1){
		objName = "������֤������";
		idTypeVal = document.all.gestoresIdType.value;
	}
	if(objType == 2){
		objName = "ʵ��ʹ����֤������";
		idTypeVal = document.all.realUserIdType.value;
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
		var idTypeText = idTypeVal;
		
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
			if(objValueLength < 4){
					rdShowMessageDialog(objName+"������ڵ���4λ��");
					
					nextFlag = false;
					return false;
			}
			
		}


	}else if(opCode == "1993"){

	}
	return nextFlag;
}

/*1���ͻ����ơ���ϵ������ У�鷽�� objType 0 �����ͻ�����У�� 1������ϵ������У��  ifConnect �����Ƿ�������ֵ(���ȷ�ϰ�ťʱ��������������ֵ)*/
function checkCustNameFuncNew(obj,objType,ifConnect){
	var nextFlag = true;
	
	if(document.all.realUserName.v_must !="1") {
	  return nextFlag;
	  return false;		
	}
	
	
	
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
	
	if(objType == 3){
		objName = "ʵ��ʹ��������";
		/*�����վ�����֤������*/
		idTypeVal = document.all.realUserIdType.value;
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
		var idTypeText = idTypeVal;
		
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
		
		
		
	}	
	return nextFlag;
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
  var checkPwd_Packet = new AJAXPacket("pubCheckPwd.jsp","���ڽ�������У�飬���Ժ�......");
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
		//�õ��ͻ�ID

        var getUserId_Packet = new AJAXPacket("/npage/sq100/f1100_getId.jsp","���ڻ�ÿͻ�ID�����Ժ�......");
      getUserId_Packet.data.add("retType","ClientId");
		getUserId_Packet.data.add("region_code","<%=regionCode%>");
		getUserId_Packet.data.add("idType","0");
		getUserId_Packet.data.add("oldId","0");
		core.ajax.sendPacket(getUserId_Packet);
		getUserId_Packet = null;
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
    var getIdPacket = new AJAXPacket("f1100_rpc.jsp","���ڻ���ϼ��ͻ���Ϣ�����Ժ�......");
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
    var path = "pubGetCustInfo.jsp";   //����Ϊ*
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
  var checkPwd_Packet = new AJAXPacket("f1100_checkName.jsp?custName="+custName,"���ڽ��пͻ�����У�飬���Ժ�......");
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
    
    //-----------------------------------------
          
    //----------------------------------------
    
   if(retType=="chkX")
   {
    var retObj = packet.data.findValueByName("retObj");
    if(retCode == "000000"){
        //rdShowMessageDialog("У��ɹ�111!",2);     
        document.all.print.disabled=false;
        
      }else if(retCode=="100001"){
        retMessage = retCode + "��"+retMessage;  
        rdShowMessageDialog(retMessage);     
        document.all.print.disabled=false;
       
        return true;
      }else{
        retMessage = "����" + retCode + "��"+retMessage;      
        rdShowMessageDialog(retMessage,0);
        /*document.all.print.disabled=true;*/
        
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
   if(retType == "ClientId")
    {
			//�õ��½��ͻ�ID
			var retnewId = packet.data.findValueByName("retnewId");
			if(retCode=="000000"){
				document.frm1100.custId.value = retnewId;
			}else{
				retMessage = retMessage + "[errorCode1:" + retCode + "]";
				rdShowMessageDialog(retMessage,0);
				return false;
				}    
     }
  
}

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
function forKuoHao(obj){
	var m = /^(\(?\)?\��?\��?)+$/;
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
	if(objType == 3){
		objName = "����������";
		/*�����վ�����֤������*/
		idTypeVal = document.all.responsibleType.value;
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
            /*2014/9/2 8:56:11 gaopeng ���ֹ�˾�����Ż������������Ƶ���ʾ */
       }else{
					
					/*��ȡ�������ĺ��ֵĸ����Լ�'()����'�ĸ���*/
					var m = /^[\u0391-\uFFE5]*$/;
					var chinaLength = 0;
					var kuohaoLength = 0;
					for (var i = 0; i < objValue.length; i ++){
			          var code = objValue.charAt(i);//�ֱ��ȡ��������
			          var flag = m.test(code);
			          /*��У������*/
			          if(forKuoHao(code)){
			          	kuohaoLength ++;
			          }else if(flag){
			          	chinaLength ++;
			          }
			          
			    }
			    var machLength = chinaLength + kuohaoLength;
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
						rdShowMessageDialog(objName+"������������ַ�!1");
						
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
	if(objType == 5){
		objName = "��������ϵ��ַ";
		idTypeVal = document.all.responsibleType.value;
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
	if(objType == 2){
		objName = "������֤������";
		idTypeVal = document.all.responsibleType.value;
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
		 if(objValueLength != 10){
					rdShowMessageDialog(objName+"������10λ��");				
					nextFlag = false;
					return false;
			}
			if(objValue.substr(objValueLength-2,1)!="-" && objValue.substr(objValueLength-2,1)!="��") {
					rdShowMessageDialog(objName+"�����ڶ�λ�����ǡ�-����");				
					nextFlag = false;
					return false;			
			}
		}
		/*Ӫҵִ�� ֤�����������ڵ���4λ���֣����������纺�ֵ��ַ�Ҳ�Ϲ�*/
		if(idTypeText == "8"){
		
		 if(objValueLength != 13 && objValueLength != 15 && objValueLength != 18 && objValueLength != 20){
					rdShowMessageDialog(objName+"������13λ��15λ��18λ��20λ��");				
					nextFlag = false;
					return false;
			}
				    
			var m = /^[\u0391-\uFFE5]*$/;
			var numSum = 0;
			for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//�ֱ��ȡ��������
          var flag = m.test(code);
          if(flag){
          	numSum ++;
          }
    	}
			if(numSum > 0){
					rdShowMessageDialog(objName+"������¼�뺺�֣�");				
					nextFlag = false;
					return false;
			}

		}
		/*����֤�� ֤��������ڵ���4λ�ַ�*/
		if(idTypeText == "B"){
		 if(objValueLength != 12){
					rdShowMessageDialog(objName+"������12λ��");				
					nextFlag = false;
					return false;
			}
				    
			var m = /^[\u0391-\uFFE5]*$/;
			var numSum = 0;
			for (var i = 0; i < objValue.length; i ++){
          var code = objValue.charAt(i);//�ֱ��ȡ��������
          var flag = m.test(code);
          if(flag){
          	numSum ++;
          }
    	}
			if(numSum > 0){
					rdShowMessageDialog(objName+"������¼�뺺�֣�");				
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
	
		if(idtypeVal.indexOf("����֤") != -1){
  		document.all.gestoresIccId.v_type = "idcard";
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
  	}else{
  		document.all.gestoresIccId.v_type = "string";
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

function validateresponIdTypes(idtypeVal){
		if(idtypeVal.indexOf("����֤") != -1){
  		document.all.responsibleIccId.v_type = "idcard";
  		if("<%=opCode%>" != "1993"){
  			$("#scan_idCard_two3zrr").css("display","");
  			$("#scan_idCard_two57zrr").css("display","");
	  		$("input[name='responsibleName']").attr("class","InputGrey");
	  		$("input[name='responsibleName']").attr("readonly","readonly");
	  		$("input[name='responsibleAddr']").attr("class","InputGrey");
	  		$("input[name='responsibleAddr']").attr("readonly","readonly");
	  		$("input[name='responsibleIccId']").attr("class","InputGrey");
	  		$("input[name='responsibleIccId']").attr("readonly","readonly");
	  		$("input[name='responsibleName']").val("");
	  		$("input[name='responsibleAddr']").val("");
	  		$("input[name='responsibleIccId']").val("");
  		}
  	}else{
  		document.all.responsibleIccId.v_type = "string";
  		if("<%=opCode%>" != "1993"){
  			$("#scan_idCard_two3zrr").css("display","none");
  			$("#scan_idCard_two57zrr").css("display","none");
	  		$("input[name='responsibleName']").removeAttr("class");
	  		$("input[name='responsibleName']").removeAttr("readonly");
	  		$("input[name='responsibleAddr']").removeAttr("class");
	  		$("input[name='responsibleAddr']").removeAttr("readonly");
	  		$("input[name='responsibleIccId']").removeAttr("class");
	  		$("input[name='responsibleIccId']").removeAttr("readonly");
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
  if(checkVal == 1){
  	$("#gestoresInfo1").show();
  	$("#gestoresInfo2").show();
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
  	
  	//��������Ϣ
  	$("#responsibleInfo1").show();
  	$("#responsibleInfo2").show();

  	/*������������*/
  	document.all.responsibleName.v_must = "1";
  	/*�������˵�ַ*/
  	document.all.responsibleAddr.v_must = "1";
  	/*����������֤������*/
  	document.all.responsibleIccId.v_must = "1";
  	
  	
  	$("#realUserInfo1").show();
  	$("#realUserInfo2").show(); 	
  	
  	document.all.realUserName.v_must = "1";
  	document.all.realUserAddr.v_must = "1";
  	document.all.realUserIccId.v_must = "1";
  	
  	
  	var checkIdType22 = $("select[name='responsibleType']").find("option:selected").val();
  	/*����֤����У�鷽��*/
  	if(checkIdType22.indexOf("����֤") != -1){
  		document.frm1100.responsibleIccId.v_type = "idcard";
  		$("#scan_idCard_two3zrr").css("display","");
  		$("#scan_idCard_two57zrr").css("display","");
  		$("input[name='responsibleName']").attr("class","InputGrey");
  		$("input[name='responsibleName']").attr("readonly","readonly");
  		$("input[name='responsibleAddr']").attr("class","InputGrey");
  		$("input[name='responsibleAddr']").attr("readonly","readonly");
  		$("input[name='responsibleIccId']").attr("class","InputGrey");
  		$("input[name='responsibleIccId']").attr("readonly","readonly");  		
  		
  	}else{
  		document.frm1100.responsibleIccId.v_type = "string";
  		$("#scan_idCard_two3zrr").css("display","none");
  		$("#scan_idCard_two57zrr").css("display","none");
  		$("input[name='responsibleName']").removeAttr("class");
  		$("input[name='responsibleName']").removeAttr("readonly");
  		$("input[name='responsibleAddr']").removeAttr("class");
  		$("input[name='responsibleAddr']").removeAttr("readonly");
  		$("input[name='responsibleIccId']").removeAttr("class");
  		$("input[name='responsibleIccId']").removeAttr("readonly");  		
  		
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
  	
  	
   	$("#realUserInfo1").hide();
  	$("#realUserInfo2").hide(); 	
  	document.all.realUserName.v_must = "0";
  	document.all.realUserAddr.v_must = "0";
  	document.all.realUserIccId.v_must = "0";
  	
  	
  	//��������Ϣ
  	$("#responsibleInfo1").hide();
  	$("#responsibleInfo2").hide();

  	/*������������*/
  	document.all.responsibleName.v_must = "0";
  	/*�������˵�ַ*/
  	document.all.responsibleAddr.v_must = "0";
  	/*����������֤������*/
  	document.all.responsibleIccId.v_must = "0";  	  	
  	
  }
  /*20131216 gaopeng 2013/12/16 15:11:05 ��ѡ��λ����ʱ��չʾ��������Ϣ��������Ϣ���Ϊ����ѡ�� end*/
  
  getIdTypes();
  
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
  

function setOfferType(){
		var packet = new AJAXPacket("/npage/portal/shoppingCar/ajax_getOfferType.jsp","���Ժ�...");
		packet.data.add("smCode" ,document.all.smCode.value);
		packet.data.add("goodKind" ,"" );
		packet.data.add("opCode" ,"<%=opCode%>" );
		core.ajax.sendPacket(packet,dosetOfferType);	
}	
			
function 	dosetOfferType(packet){
		var retResult = packet.data.findValueByName("retResult"); 
		var selectObj = document.getElementById("offer_att_type");
	  selectObj.length=0;
		selectObj.options.add(new Option("--��ѡ��--",""));
		for(var i=0;i<retResult.length;i++){
			var reg = /\s/g;     
			var ss = retResult[i][0].replace(reg,""); 
				if(ss.length!=0){
					selectObj.options.add(new Option(retResult[i][0]+"-->"+retResult[i][1],retResult[i][0]));
				}
			}
	}
	
function productOfferQryByAttr(){
	
	var packet = new AJAXPacket("/npage/portal/shoppingCar/ajax_productOfferQryByAttr.jsp","���Ժ�...");
		packet.data.add("offerCode" ,"");//����Ʒ����
		packet.data.add("offerName" ,"");//����Ʒ����
		packet.data.add("offerType" ,"10");//����Ʒ����
		packet.data.add("offerAttrSeq" ,"");
		packet.data.add("custGroupId" ,"");
		packet.data.add("channelSegment" ,"");
		packet.data.add("group_id" ,document.all.receiveRegion.value);
		packet.data.add("band_id" ,document.all.smCode.value);
		packet.data.add("offer_att_type" ,document.all.offer_att_type.value);
		packet.data.add("goodFlag" ,"1");
		packet.data.add("retQ08_flag" ,"0");
		packet.data.add("opCode" ,"1104");// ��ʱд��
		core.ajax.sendPacket(packet,doProductOfferQryByAttr);
		packet =null;
	
}
function doProductOfferQryByAttr(packet)
{
	var retCode = packet.data.findValueByName("retCode"); 
	var retMsg = packet.data.findValueByName("retMsg"); 
	var retArray = packet.data.findValueByName("retResult");
	if(retCode==0){
				
				$("#resultContent").show();
				$("#appendBody").empty();
			
				var appendTh = 
					"<tr>"
					+"<th width='8%'>����</th>"
					+"<th width='23%'>����Ʒ����</th>"
					+"<th width='23%'>����Ʒ����</th>"
					+"<th width='23%'>Ʒ������</th>"
					+"<th width='23%'>˵��</th>"
					+"</tr>";
				$("#appendBody").append(appendTh);	
				for(var i=0;i<retArray.length;i++){
					var appendStr = "<tr>";
					appendStr += "<td width='8%'>"+"<input type='radio' name='selOrder' value='"+retArray[i][0]+"' onclick='jdugeAreaHidden("+retArray[i][0]+");'/>"+"</td>"
											+"<td width='23%'>"+retArray[i][0]+"</td>"
											+"<td width='23%'>"+retArray[i][1]+"</td>"
											+"<td width='23%'>"+retArray[i][6]+"</td>"
											+"<td width='23%'></td>"

					appendStr +="</tr>";						
					$("#appendBody").append(appendStr);
				}
				$("#excelExp").attr("disabled","");
				
			}else{
				$("#resultContent").hide();
				$("#appendBody").empty();
			
				rdShowMessageDialog("������룺"+retCode+",������Ϣ��"+retMsg,1);
				
			}
				
	}


    	<wtc:service name="sDynSqlCfm" routerKey="region" routerValue="<%=regionCode%>" outnum="2">
    		  <wtc:param value="25"/>
    		  <wtc:param value="<%=workNo%>"/>
    	</wtc:service>
    	<wtc:array id="rowsRegionH" scope="end"/>
 
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
		
				if(flag == "manage"){ //������
					document.all.gestoresName.value =name;//����
					document.all.gestoresIccId.value =code;//����֤��
					//document.all.gestoresAddr.value =IDaddress;//����֤��ַ
				}
				
				if(flag == "zerenren"){  //������
					document.all.responsibleName.value =name;//����
					document.all.responsibleIccId.value =code;//����֤��
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
		//alert(v_printAccept+"--"+str);
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
				
				if(str == "31"){ //������
					document.all.gestoresName.value =xm;//����
					document.all.gestoresIccId.value =zjhm;//����֤��
					//document.all.gestoresAddr.value =zz;//����֤��ַ
				}else if(str == "57"){ //������
					document.all.responsibleName.value =xm;//����
					document.all.responsibleIccId.value =zjhm;//����֤��
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
/* begin update for ���ڿ��������ն�CRMģʽAPP�ĺ� - �ڶ���@2015/3/10 */
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
	if(str == "31"){ //������
		document.all.gestoresAddr.value =idAddr;//����֤��ַ
	}else if(str == "manage"){ //������ �ɰ�
		document.all.gestoresAddr.value =idAddr;//����֤��ַ
	}else if(str == "zerenren"){ //������ �ɰ�
		document.all.responsibleAddr.value =idAddr;//����֤��ַ
	}else if(str == "57"){ //������ 
		document.all.responsibleAddr.value =idAddr;//����֤��ַ
	}
}


/*2015/12/17 15:55:28 gaopeng  ����ΪС�����벿��*/

var xqdm = "";   //С���Ʒ�
/*2014/12/03 9:24:16 gaopeng С���ʷ���С���������� 
	����С�����������б�չʾʱ��Ҳ����ajax_jdugeAreaHidden.jsp ����Yʱ�����ʷ�ΪС���ʷѵ�ȫ�ֱ�����Ĭ�ϲ���С���ʷ�
*/
var xqjfFlag = false;
var offerId = "";
function jdugeAreaHidden(offer_id){
	offerId = offer_id;
	//getMajorProd(offer_id);
	
  var packet = new AJAXPacket("/npage/s1104/ajax_jdugeAreaHidden.jsp","���Ժ�...");
	packet.data.add("offerId",offer_id);
 	packet.data.add("phoneNo","");
	packet.data.add("opCode","<%=opCode%>");
	core.ajax.sendPacket(packet,doJdugeAreaHidden);
	packet =null;	
} 


var v_hiddenFlag = "";
var v_code = new Array();
var v_text = new Array();

function doJdugeAreaHidden(packet){
  var retCode = packet.data.findValueByName("retCode");
  var retMsg =  packet.data.findValueByName("retMsg");
  var code =  packet.data.findValueByName("code");
  var text =  packet.data.findValueByName("text");
  var hiddenFlag =  packet.data.findValueByName("hiddenFlag");//�Ƿ���ʾС�������ʶ
  var offer_id =  packet.data.findValueByName("offerId");//�ʷѴ���
  if(retCode == "000000"){
    v_hiddenFlag = hiddenFlag;
    if(code.length>0&&text.length>0){
      for(var i=0;i<code.length;i++){
        v_code[i] = code[i];
        v_text[i] = text[i];
      }
    }
    getOfferAttr(offer_id);
	}else{
		rdShowMessageDialog(retCode + ":" + retMsg,0);
		//getOfferAttr();
		return false;
	}
}

function getOfferAttr(offer_id)

{
    if(v_hiddenFlag=="Y"){ //��ΪYʱ�������°�С������չʾҳ��
      var packet1 = new AJAXPacket("/npage/s1104/getOfferAttrNew.jsp","���Ժ�...");
      packet1.data.add("v_code" ,v_code);
      packet1.data.add("v_text" ,v_text);
      packet1.data.add("myActivePhone" ,"");
     
    }else{
      var packet1 = new AJAXPacket("/npage/s1104/getOfferAttr.jsp","���Ժ�...");
    }
		packet1.data.add("OfferId" ,offer_id);
		core.ajax.sendPacketHtml(packet1,doGetOfferAttr);
		packet1 =null;
}

function doGetOfferAttr(data)
{
	/*���*/
	$("#OfferAttribute").html("");
  if(v_hiddenFlag=="Y"){ //��ΪYʱ�������°�С������չʾҳ��
    $("#OfferAttribute").append(data);
  }else{
    $("#OfferAttribute").html(data);
  }
	$("#OfferAttribute :input").not(":button").keyup(function stopSpe(){
			var b=this.value;
			if(/[^0-9a-zA-Z\.\@\u4E00-\u9FA5]/.test(b)) this.value=this.value.replace(/[^0-9a-zA-Z\u4E00-\u9FA5]/g,'');
	});
	$("#hideAreaSome").hide();
}


/*2015/12/17 16:25:01 gaopeng ��Ʒ��Ϣ����*/
function getMajorProd(offerId)
{
	 	var packet1 = new AJAXPacket("/npage/s1104/getMajorProd.jsp","���Ժ�...");
		packet1.data.add("offerId" ,offerId);
		core.ajax.sendPacketHtml(packet1,doGetMajorProd);
		packet1 =null;
}

function doGetMajorProd(data)
{
		
		/*���*/
		$("#offer_component").html("");
	  $("#offer_component").html(data);
	  
	  
		var majorProductId = "";
		if(typeof(majorProductArr) != "undefined" && majorProductArr.length > 0)
		{
		 	majorProductId = majorProductArr[1];
		 	$("input[name='majorProductId']").val(majorProductArr[1]);
		 	
		  
		  getProdCompInfo(majorProductId);
		  getProdCompRel(majorProductId);
		  
		  
		 	//����Ʒ�ĺ�����������//	
		}
		else
		{
			rdShowMessageDialog("������Ʒû������Ʒ��Ϣ!");
			window.close();
			return false;	
		}
}

function getProdCompRel(majorProductId)
{
	var packet2 = new AJAXPacket("/npage/s1104/getProdCompRel.jsp","���ڼ��ظ�����Ʒ��������ϵ,���Ժ�...");
	packet2.data.add("majorProductId" ,majorProductId);
	core.ajax.sendPacketHtml(packet2,doGetProdCompRel);
	packet2 =null;
}

function  doGetProdCompRel(data)
{
	 $("#majorProdRel").html("");
	 $("#majorProdRel").html(data);
	 
	 for(var i=0;i<prodCompIdArray.length;i++){
			initProdRel(prodCompIdArray[i]);
	 }	
}

function getProdCompInfo(majorProductId)
{
	var packet3 = new AJAXPacket("/npage/s1104/getProdCompDet.jsp","���Ժ�...");
	packet3.data.add("goodNo" ,""); //caohq 20101206 ���� 
	packet3.data.add("groupId" ,"<%=groupId%>");
	packet3.data.add("selOfferType","");//weigp add ���� 
	packet3.data.add("majorProductId" ,majorProductId);
	packet3.data.add("offerId" ,offerId);
	packet3.data.add("sopcodes" ,"<%=opCode%>");
	core.ajax.sendPacket(packet3,doGetProdCompInfo);
	packet3 =null;
}

var prodCompIdArray = [];									//���Ӳ�Ʒ������Ϣ
//��¼���е���������
var myArrs = new Array("1027","1026","1025","2042");

function doGetProdCompInfo(packet)
{
	var error_code = packet.data.findValueByName("errorCode");
	var error_msg =  packet.data.findValueByName("errorMsg");
	var prodCompInfo = packet.data.findValueByName("prodCompInfo");

	if(error_code == "0"){
		if(typeof(prodCompInfo) != "undefined"){
			/*��ղ�����tr*/
			
			$("#tab_addprod tr").empty();
			
			$("#tab_addprod").show();
			var nodeIdStr = "";
			var nodeNameStr = "";
			var etFlagStr = "";
			var compRoleCdHash = new Object();
			$("#tab_addprod tr").append("<td><div id='items'><div class='item-col2 col-1'><div id='compProdInfoDiv'></div></div><div class='item-row2 col-2'><div class='title'><div id='title_zi'>�Ѷ�����Ʒ��Ϣ</div></div><div id='pro_component'></div></div></div></td>");
			
			$("#pro_component").append("<div id='prod_"+offerId+"'></div>"); 
        	$("#prod_"+offerId).after("<div id='pro_"+offerId+"' ></div>");
        	$("#pro_"+offerId).append("<table id='tab_pro' cellspacing=0></table>");
        	$("#tab_pro").append("<tr><th>��Ʒ����</th><th>��ʼʱ��</th><th>����ʱ��</th><th>����</th></tr>");
			
			
			for(var i=0;i<prodCompInfo.length;i++){
				if(typeof(compRoleCdHash[prodCompInfo[i][3]]) == "undefined"){	//���ɽ�ɫ��
					$("#compProdInfoDiv").append("<div  name='compProdrole' id='"+prodCompInfo[i][3]+"' style='cursor:hand'><div class='title'><div id='title_zi'>���Ӳ�Ʒ</div></div></div><table cellspacing='0'><tr><td><div id='div_"+prodCompInfo[i][3]+"' style='font-family:\"����\";'></div></td></tr></table>");
					compRoleCdHash[prodCompInfo[i][3]] = "1";
				}	
			}
			
			for(var i=0;i<prodCompInfo.length;i++){
			    var tempStr = "";
			    if(i != 0){
			        tempStr = "&nbsp;";
			    }
				prodCompIdArray[i] = prodCompInfo[i][11];
				var relationType = prodCompInfo[i][9];
				
				// caohq 20101206 end
				var checkStr = "";
				var spaceStr = "";
				
				if(relationType == "0"){
					checkStr = "checked disabled";
					etFlagStr = etFlagStr + "0" + "|";
				}
				else if(relationType == "2"){
					checkStr = "checked";		
					etFlagStr = etFlagStr + "2" + "|";
				}
				// 20101206 caohq begin
				else if(relationType == "3"){
					checkStr = "disabled";		
					etFlagStr = etFlagStr + "3" + "|";
				}
				// 20101206 caohq end
				if(relationType == "0" || relationType == "2"){
				    nodeIdStr = nodeIdStr + prodCompInfo[i][11]+"|";
				    nodeNameStr = nodeNameStr + prodCompInfo[i][2]+"|";
				}
				
				var strLen = fucCheckLength(prodCompInfo[i][2]);
				if(prodCompInfo[i][13] == "1"){
				    if(strLen<10){
    				    var len = 10 - strLen;
    				    for(var li=0;li<len;li++){
        				        spaceStr = spaceStr + "&nbsp;";
    				    }
    				}
				}else{
    				if(strLen<16){
    				    var len = 16 - strLen;
    				    for(var li=0;li<len;li++){
        				        spaceStr = spaceStr + "&nbsp;";
    				    }
    				}
    			}
    			//liujian ceshi  begin
				//alert(111);
				//liujian ceshi end
				$("#div_"+prodCompInfo[i][3]).append(tempStr+"<span id='compSpan_"+prodCompInfo[i][11]+"'><input type='checkbox' onclick='showDetailProd2(\""+prodCompInfo[i][11]+"\",\""+prodCompInfo[i][2]+"\",this,1)' name='checkbox_"+prodCompInfo[i][2]+"' id='"+prodCompInfo[i][11]+"' _mutexNum='0' "+checkStr+" groupTitle='"+prodCompInfo[i][14]+"'  minNum='" + prodCompInfo[i][15] + "' maxNum='" + prodCompInfo[i][16] + "' />"+prodCompInfo[i][2]+"</span>"+spaceStr);
				
				if(prodCompInfo[i][13] == "1"){
					$("#compSpan_"+prodCompInfo[i][11]).append("<input type='button' name='prod_"+prodCompInfo[i][2]+"' value='����' id='att_"+prodCompInfo[i][11]+"' class='b_text' />");
				}
				if($("#div_"+prodCompInfo[i][3]+" span").length%3 == 0){	//�������
					$("#div_"+prodCompInfo[i][3]).append("<br>");	
				}
			}
			var nodeIdArr = nodeIdStr.split("|");
			var nodeNameArr = nodeNameStr.split("|");
			var etFlagArr = etFlagStr.split("|");

			for(var i=0;i<nodeIdArr.length-1;i++){
				  //alert("nodeIdArr["+i+"]|="+nodeIdArr[i]+"#nodeNameArr["+i+"]|="+nodeNameArr[i]);
			    showDetailProd2(nodeIdArr[i],nodeNameArr[i],"undefined",etFlagArr[i]);
    		}
		}
	$("#tab_addprod :checkbox").bind("click",checkProdRel);	//У�鸴�ϲ�Ʒ���ϵ
	$("#tab_addprod :button").bind("click",showAttribute);	//�趨���ϲ�Ʒ����
	
	$("#tab_addprod div[name='compProdrole']").toggle(
		  function () {
		    $("#div_"+this.id).css("display","none");
		  },
		  function () {
		    $("#div_"+this.id).css("display","");
		  }
		); 
	}		
}


function showDetailProd2(nodeId,nodeName,obj,etFlag){
	/*�����ӵ�У��*/
	if(!clickListener($("#"+ nodeId +""),'groupTitle',true)){
		$("#"+ nodeId +"").attr("checked","");
		return false;
	}
	if(findStrInArr(nodeId,myArrs) && getAllCheckedRomaBox() > 1){
		rdShowMessageDialog("�û�ֻ��ѡ��һ������",0);
		$("#"+ nodeId +"").attr("checked","");
		return false;
	}
    if(obj != undefined){
        if(obj.checked == false){
            $("#pro_detail_"+nodeId).remove();
            return;
        }
    }
  
  var packet = new AJAXPacket("/npage/s1104/complexPro_ajax.jsp","���Ժ�...");//��ϲ�Ʒ�Ӳ�Ʒչʾ
	packet.data.add("nodeId" ,nodeId);
	packet.data.add("nodeName" ,nodeName);
	packet.data.add("etFlag",etFlag);
	core.ajax.sendPacketHtml(packet,doGetHtml2);
	packet =null;
	
	
}
function doGetHtml2(data){
    eval(data);
}

function chkLimit1(id,iOprType)
{
	var retList="";
	var phoneNo="";
	var opCode="<%=opCode%>";
	var sendUrl = "/npage/s1104/limitChk1.jsp";
	var senddata={};
	senddata["opCode"] = opCode;
	senddata["prodId"] = id;
	senddata["iOprType"] = iOprType;
	senddata["vQtype"] = "0";
	senddata["idNo"] = "";
	
		$.ajax({
			url: sendUrl,
		  type: "POST",
		  data: senddata,
		  async: false,//ͬ��
		  error: function(data){
				if(data.status=="404")
				{
				  alert( "�ļ�������!");
				}
				else if (data.status=="500")
				{
				  alert("�ļ��������!");
				}
				else{
				  alert("ϵͳ����!");  					
				}
		  },
		  success: function(data)
		  {		   
		          retList = data;
		  }
		});
		senddata = null;
		return  retList;
}

/*2015/12/17 17:13:04 gaopeng  ������Ҫ�Ĺ�����*/

function findStrInArr(str1,arrObj){
	var reFlag = false;
	$.each(arrObj,function(i,n){
		if(n == str1){
			reFlag = true;
		}
	});
	return reFlag;
}

function getAllCheckedRomaBox(){
	var checkedBoxObjs = $("#tab_addprod :checkbox[@checked]");
	var romaBoxNum = 0;
	$.each(checkedBoxObjs,function(i,n){
		if(findStrInArr(n.id,myArrs)){
			romaBoxNum++;
		}
	});
	return romaBoxNum;
}

function fucCheckLength(strTemp)  
{  
 var i,sum;  
 sum=0;  
 for(i=0;i<strTemp.length;i++)  
 {  
  if ((strTemp.charCodeAt(i)>=0) && (strTemp.charCodeAt(i)<=255))  
   sum=sum+1;  
  else  
   sum=sum+2;  
 }  
 return sum;  
} 

function checkProdRel(){
	checkProdCompRel(this);
	var iOprType = "1";
	if(this.id == "4001"){
		if(typeof($(this).attr("checked")) == "undefined" 
				|| $(this).attr("checked") == "undefined"){
					iOprType = "3";
		}
		
		
		
	}
	 var retArr=chkLimit1(this.id,iOprType).split("@");
     retCo=retArr[0].trim();
     retMg=retArr[1];
     if(retCo!="0")
     {
     	   rdShowMessageDialog(retMg);
     	   $("#"+this.id).attr('checked','check');
     	   $("#pro_detail_"+this.id).remove();
     	   return false;
     }
}
var AttributeHash = new Object(); //����Ʒ/��ƷId=������Ϣ
function showAttribute(){
	var queryType = this.name.substring(0,4);
	var queryId = this.id.substring(4);
	var offerName = this.name.substring(4);
	var h=600;
	var w=800;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;
	var prop="dialogHeight:"+h+"px;dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
	if($(this).attr("class") == "but_property"){
		var ret=window.showModalDialog("/npage/s1104/showAttr.jsp?queryId="+queryId+"&queryType="+queryType,"",prop);
		if(typeof(ret) != "undefined"){
			if(ret.split("|")[1].length == 1){
				rdShowMessageDialog("δ�������ԣ�");	
				return false;
			}
			$(this).attr("class","but_property_on");
			AttributeHash[queryId]=ret;	//�����ص�Ⱥ����Ϣ��ӦqueryId����
		}	
		else{
			rdShowMessageDialog("δ�������ԣ�");	
			return false;
		}
	}
	else{
		var ret=window.showModalDialog("/npage/s1104/showAttr.jsp?queryId="+queryId+"&queryType="+queryType+"&attrInfo="+AttributeHash[queryId],"",prop);
		if(typeof(ret) != "undefined"){
			AttributeHash[queryId]=ret;	//�����ص�Ⱥ����Ϣ�Ծ�queryId����
		}
	}	
}
		
		
function myTest(){
	
	var exitFlag = 0;
	var pordIdArr = new Array();
	var prodEffectDate = []; 
	var prodExpireDate = [];  
	var isMainProduct = []; 
	
	var offerIdArr = new Array();
	var offerNameArr = new Array();
	var offerEffectTime = new Array();
	var offerExpireTime = new Array();
	
	var sonParentArr = []; //�������Ʒ,��Ʒ����~����ϵ
	var groupInstBaseInfo = "";				//Ⱥ����Ϣ
	var offer_productAttrInfo = ""; //����Ʒ,��Ʒ���Դ�
		
	var vFlag = true;
	//ѹ������Ʒ
		if(typeof(majorProductArr) != "undefined" && majorProductArr.length > 0){
			$("input[name='majorProductId']").val(majorProductArr[1]);
			sonParentArr.push($("input[name='majorProductId']").val()+"~"+offerId);
			pordIdArr.push($("input[name='majorProductId']").val());
			prodEffectDate.push("<%=currTime%>");
			prodExpireDate.push("20501231235959");
			isMainProduct.push(1);
		}
		else{
			rdShowMessageDialog("������Ʒ!");	
			return false;
		}

	//ѹ�븽�Ӳ�Ʒ
		$("#tab_addprod :checked").each(function(){
			sonParentArr.push(this.id+"~"+offerId);
			pordIdArr.push(this.id);
			
			//if(document.getElementById("startDate_"+this.id)!=null&document.getElementById("stopDate_"+this.id)!=null){
				if(compareDates((document.getElementById("startDate_"+this.id)),(document.getElementById("stopDate_"+this.id)))==-1){
	                rdShowMessageDialog("��ʼʱ���ʽ����ȷ,����������!",0);
	                (document.getElementById("startDate_"+this.id)).select();
	                vFlag = false;
	                return false;
	            }
	            if(compareDates((document.getElementById("startDate_"+this.id)),(document.getElementById("stopDate_"+this.id)))==-2){
	                rdShowMessageDialog("����ʱ���ʽ����ȷ,����������!",0);
	                (document.getElementById("stopDate_"+this.id)).select();
	                vFlag = false;
	                return false;
	            }
	            
			    if($(document.getElementById("startDate_"+this.id)).val() < "<%=dateStr2%>"){
	                rdShowMessageDialog("��ʼʱ��Ӧ��С�ڵ�ǰʱ��,����������!",0);
	                (document.getElementById("startDate_"+this.id)).select();
	                vFlag = false;
	                return false;
	            }
	            if($(document.getElementById("stopDate_"+this.id)).val() <= "<%=dateStr2%>"){
	                rdShowMessageDialog("����ʱ��Ӧ���ڵ�ǰʱ��,����������!",0);
	                (document.getElementById("stopDate_"+this.id)).select();
	                vFlag = false;
	                return false;
	            }
	            
	            if(compareDates((document.getElementById("startDate_"+this.id)),(document.getElementById("stopDate_"+this.id)))==1 || $(document.getElementById("startDate_"+this.id)).val()==$(document.getElementById("stopDate_"+this.id)).val()){
	                rdShowMessageDialog("��ʼʱ��ӦС�ڽ���ʱ��,����������!",0);
	                (document.getElementById("stopDate_"+this.id)).select();
	                vFlag = false;
	                return false;
	            }
	            
	            if($(document.getElementById("startDate_"+this.id)).val() > "<%=addThreeMonth%>"){
	                rdShowMessageDialog("��ʼʱ���������������,����������!",0);
	                (document.getElementById("startDate_"+this.id)).select();
	                vFlag = false;
	                return false;
	            }
	            
				//}
				
			var effDate = "";
    		var expDate = "";
    		if($(document.getElementById("startDate_"+this.id)).val() == "<%=dateStr2%>"){
    		    effDate = "<%=currTime%>";
    		}else{
    		    effDate = $(document.getElementById("startDate_"+this.id)).val() + "000000";
    		}
    		
    		expDate = $(document.getElementById("stopDate_"+this.id)).val() + "235959";
    		prodEffectDate.push(effDate);
    		prodExpireDate.push(expDate);
										
			isMainProduct.push(0);
			
			if(typeof(AttributeHash[this.id]) != "undefined"){		//װ�븽�Ӳ�Ʒ��������Ϣ
				offer_productAttrInfo += AttributeHash[this.id];
			}	
		});		
		
		if(!vFlag){
			    return false;
			}
				
		$("#div_offerComponent :checked").each(function(){
			if(this.name.substring(0,4)=="prod" && $("#"+nodesHash[this.id].parentOffer).attr("checked") == true && $("#effType_"+nodesHash[this.id].parentOffer).val() == "0"){	//ֻ��������Ч��
				sonParentArr.push(this.id+"~"+nodesHash[this.id].parentOffer);
				pordIdArr.push(this.id);
				prodEffectDate.push($.trim($("#effTime_"+nodesHash[this.id].parentOffer).attr("name")));
				prodExpireDate.push($.trim($("#expTime_"+nodesHash[this.id].parentOffer).attr("name")));
				isMainProduct.push(0);
				
				if(typeof(AttributeHash[this.id]) != "undefined"){		//װ���Ʒ��������Ϣ
					offer_productAttrInfo += AttributeHash[this.id];
				}	
			}
			if(this.name.substring(0,4)=="offe"){
				
				if(this.h_groupId!="0"){
					if(typeof(offerGroupHash[this.id])!="undefined"){
						if(offerGroupHash[this.id].indexOf(this.id)==-1){ //Ⱥ����Ϣ��û�����offerid��Ӧ����Ϣ��˵��Ⱥ������ʧ��
								rdShowMessageDialog("ѡ�������ʷѡ�"+this.h_offerName+"������������ѡ��",0);
								this.checked = false;
								checkOrderTab();
								exitFlag = 1;
						}
					}else{
								rdShowMessageDialog("ѡ�������ʷѡ�"+this.h_offerName+"������������ѡ��",0);
								this.checked = false;
								checkOrderTab();
								exitFlag = 1;
						}
				}
				
				sonParentArr.push(this.id+"~"+nodesHash[this.id].parentOffer);
				offerIdArr.push(this.id);
				offerEffectTime.push($("#effTime_"+this.id).attr("name"));
				
				offerExpireTime.push($("#expTime_"+this.id).attr("name"));
				
				if(typeof(AttributeHash[this.id]) != "undefined"){	//װ������Ʒ��������Ϣ
					offer_productAttrInfo += AttributeHash[this.id];
				}	
				
				/*
				if(nodesHash[this.id].attrFlag == 1 && typeof(AttributeHash[this.id]) == "undefined"){
					rdShowMessageDialog("���趨"+nodesHash[this.id].getName()+"��������Ϣ!");
					exitFlag = 1;
					return false;	
				}
				*/
				
				if(typeof(offerGroupHash[this.id]) != "undefined"){	//װ������Ʒ��Ⱥ����Ϣ
					groupInstBaseInfo = groupInstBaseInfo + offerGroupHash[this.id]+"^";
				}
			}
		});
		if(exitFlag == 1){
			return false;	
		}		
		$("input[name='productIdArr']").val(pordIdArr);
		$("input[name='prodEffectDate']").val(prodEffectDate);
		$("input[name='prodExpireDate']").val(prodExpireDate);
		$("input[name='isMainProduct']").val(isMainProduct);
		var endStr = "";
		/*
		for(var j=0;j<pordIdArr.length;j++){
			if(j==0){
				endStr = pordIdArr[j]+"#"+prodEffectDate[j]+"#"+prodExpireDate[j]+"#"+isMainProduct[j];
			}else{
				endStr += "$"+pordIdArr[j]+"#"+prodEffectDate[j]+"#"+prodExpireDate[j]+"#"+isMainProduct[j];
			}
		}*/
		for(var j=0;j<pordIdArr.length;j++){
			
		}
		endStr = pordIdArr.join(",")+"$"+prodEffectDate.join(",")+"$"+prodExpireDate.join(",")+"$"+isMainProduct.join(",");
		//alert(endStr);
		$("input[name='endStr']").val(endStr);
	
}

function replaceAll(s1,s2,str)
{
	if(str.length != 0){
		str.replace(new RegExp(s1,"gm"),s2);
		return str;
	}
}


	   
			//ʵ��ʹ����֤�����͸ı�
			function valiRealUserIdTypes(idtypeVal){
				if(idtypeVal == "0"||idtypeVal == ""){//��ֵĬ������֤
					document.all.realUserIccId.v_type = "idcard";
					$("#scan_idCard_two2").css("display","");
					$("#scan_idCard_two22").css("display","");
					$("input[name='realUserName']").attr("class","InputGrey");
					$("input[name='realUserName']").attr("readonly","readonly");
					$("input[name='realUserAddr']").attr("class","InputGrey");
					$("input[name='realUserAddr']").attr("readonly","readonly");
					$("input[name='realUserIccId']").attr("class","InputGrey");
					$("input[name='realUserIccId']").attr("readonly","readonly");
					$("input[name='realUserName']").val("");
					$("input[name='realUserAddr']").val("");
					$("input[name='realUserIccId']").val("");
				}else{
					document.all.realUserIccId.v_type = "string";
					$("#scan_idCard_two2").css("display","none");
					$("#scan_idCard_two22").css("display","none");
					$("input[name='realUserName']").removeAttr("class");
					$("input[name='realUserName']").removeAttr("readonly");
					$("input[name='realUserAddr']").removeAttr("class");
					$("input[name='realUserAddr']").removeAttr("readonly");
					$("input[name='realUserIccId']").removeAttr("class");
					$("input[name='realUserIccId']").removeAttr("readonly");
				}
				 
			}


/*
 * ���ڿ�����������������ʵ������Ϣ�洢���ܵĺ�
 * hejwa add 
 * 2016��12��23��
 */
function go_getInterThin_Info(){
	if($("#ipt_InterThin_No").val().trim()==""){
		rdShowMessageDialog("����������������");
		return;
	}
	
	  var packet = new AJAXPacket("fi067_getInterThin_Info.jsp","���Ժ�...");
        packet.data.add("opCode","<%=opCode%>");//
        packet.data.add("InterThin_No",$("#ipt_InterThin_No").val());//
    core.ajax.sendPacket(packet,do_getInterThin_Info);
    packet =null;
    
}

function do_getInterThin_Info(packet){
    var error_code = packet.data.findValueByName("code");//���ش���
    var error_msg =  packet.data.findValueByName("msg");//������Ϣ

    if(error_code!="000000"){//���÷���ʧ��
      rdShowMessageDialog(error_code+":"+error_msg);
	    return;
    }else{//�����ɹ�
			
			$("#btn_InterThin_No").attr("disabled","disabled");
			
			var retArray = packet.data.findValueByName("retArray");
     	
     	if(retArray.length>0){
	    	$("#custName").val(retArray[0][0]);//�ͻ�����                               /* oCustName          �ͻ�����                */
				
				//���֤������û�У�֤�����벻д
				$("#idTypeSelect").find("option").each(function (){
					if($(this).val().indexOf(retArray[0][1])!=-1){
							$(this).attr("selected","selected");//֤������                           /* oIdType          	֤������                */
		    			$("#idIccid").val(retArray[0][2]);//֤������                                /* oIdIccId          	֤������                */
					}
				});
				
				
	    	$("#idAddr").val(retArray[0][3]);//֤����ַ                                 /* oIdAddress         ֤����ַ                */
	    	$("input[name='custAddr']").val(retArray[0][4]); //�ͻ���ַ                 /* oCustAddress       �ͻ���ַ                */
	    	$("#idValidDate").val(retArray[0][5]);//֤����Ч��                          /* oIdValidate        ֤����Ч��	            */

	    	$("input[name='contactPerson']").val(retArray[0][6]);//��ϵ������           /* oContactName       ��ϵ������              */
	    	$("input[name='contactPhone']").val(retArray[0][7]);//��ϵ�˵绰            /* oContactPhone      ��ϵ�˵绰              */
	    	$("input[name='contactAddr']").val(retArray[0][8]);//��ϵ�˵�ַ             /* oContactAddress    ��ϵ�˵�ַ	            */
				
				if(retArray[0][10]=="0"||retArray[0][10]==""){
					validateGesIdTypes("����֤");
				}else{
					validateGesIdTypes("");
				}
				
				$("select[name='gestoresIdType']").find("option").each(function(){
					if($(this).val().indexOf(retArray[0][10])!=-1&&retArray[0][10]!=""){
						$(this).attr("selected","selected");
					}
				});
				
	    	$("input[name='gestoresName']").val(retArray[0][9]);//����������            /* oOprName          	����������              */
	    	$("input[name='gestoresIccId']").val(retArray[0][11]);//������֤������      /* oOprIdIccId        ������֤������	        */
	    	$("input[name='gestoresAddr']").val(retArray[0][12]);//��������ϵ��ַ       /* oOprAddress        ������֤����ַ          */

				if(retArray[0][14]=="0"||retArray[0][14]==""){
					validateresponIdTypes("����֤");
				}else{
					validateresponIdTypes("");
				}
				$("select[name='responsibleType']").find("option").each(function(){
					if($(this).val().indexOf(retArray[0][14])!=-1&&retArray[0][14]!=""){
						$(this).attr("selected","selected");
					}
				});

	    	$("input[name='responsibleName']").val(retArray[0][13]);//����������         /* oDutyName          ����������              */
	    	$("input[name='responsibleIccId']").val(retArray[0][15]);//������֤������    /* oDutyIdIccId       ������֤������	        */
	    	$("input[name='responsibleAddr']").val(retArray[0][16]);//��������ϵ��ַ     /* oDutyAddress       ������֤����ַ          */

				valiRealUserIdTypes(retArray[0][18]);
				
	    	$("select[name='realUserIdType']").val(retArray[0][18]);//ʵ��ʹ����֤������ /* oActualIdType      ʵ��ʹ����֤������      */
	    	$("input[name='realUserName']").val(retArray[0][17]);//ʵ��ʹ��������        /* oActualName        ʵ��ʹ��������          */
	    	$("input[name='realUserIccId']").val(retArray[0][19]);//ʵ��ʹ����֤������   /* oActualIdIccId     ʵ��ʹ����֤������	    */
	    	$("input[name='realUserAddr']").val(retArray[0][20]);//��������ϵ��ַ        /* oActualAddress     ʵ��ʹ����֤����ַ      */
    	}
    	
    	
    }
}



</SCRIPT>
<body onMouseDown="hideEvent()" onKeyDown="hideEvent()">
<FORM method="post" name="frmaaa" id="frmaaa"   >
	<input type="hidden" id="bphones" name="bphones" value=""/>
	<input type="hidden" id="userpwds" name="userpwds" value=""/>
	<input type="hidden" id="simnos" name="simnos" value=""/>
	<input type="hidden" id="prepays" name="prepays" value=""/>
	
	<input type="hidden" id="bTrueNames" name="bTrueNames" value=""/>
	<input type="hidden" id="bTrueIdTypes" name="bTrueIdTypes" value=""/>
	<input type="hidden" id="bTrueIdNos" name="bTrueIdNos" value=""/>
	<input type="hidden" id="bTrueAddrs" name="bTrueAddrs" value=""/>
	<input type="hidden" id="bSimFees" name="bSimFees" value=""/>
	<input type="hidden" id="fjxspStr" name="fjxspStr" value=""/>
	
</form>	
  <!--����֤-->
<FORM method=post name="frm1100" id="frm1100"   onKeyUp="chgFocus(frm1100)"   ><!--����֤-->
       
       <%@ include file="/npage/include/header.jsp" %>   
       <div class="title">
      <div id="title_zi"><%=opName%></div>
    </div>

  <!------------------------------------------------------------------------>
              
              <TABLE cellSpacing="0" >
                <TBODY> 
        				
                <TR> 
                  <TD width=16% class="blue"> 
                    <div align="left">�ͻ����</div>
                  </TD>
                  <TD width=84% colspan="3"> 
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
          //���ݵ�¼���ŵ�sfuncpower �в鿴�Ƿ��м��ſͻ�����Ȩ��
          /*
          sqlStr="select count(*) from sfuncpower where function_code='1993' and power_code in (select power_code from dloginmsg where login_no='" +workNo+ "')";
          retArray = callView.view_spubqry32("1",sqlStr);
          int recordNum1 = Integer.parseInt(((String[][])retArray.get(0))[0][0]);
          System.out.println("sqlStr="+sqlStr);
          System.out.println("recordNum="+recordNum1 );
          */
          //sunwt �޸� 20080429
          String paramsIn[] = new String[2];
          paramsIn[0] = workNo;       //����
          paramsIn[1] = "1993";        //��������
          
          //SPubCallSvrImpl callViewCheck = new SPubCallSvrImpl();
          //ArrayList acceptList = new ArrayList();
          /** try
          {
          acceptList = callViewCheck.callFXService("sFuncCheck", paramsIn, "1","region", regionCode); 
          errCode = callViewCheck.getErrCode();
          errMsg = callViewCheck.getErrMsg();
          }
          catch(Exception e)
          {
          e.printStackTrace();
          logger.error("Call sFuncCheck is Failed!");
          }
          **/
          %>
          <wtc:service name="sFuncCheck" routerKey="regionCode" routerValue="<%=regionCode%>"  retcode="retCode" retmsg="retMsg"  outnum="1" >
          <wtc:param value="sFuncCheck"/>
          <wtc:params value="<%=paramsIn%>"/>
          <wtc:param value="1"/>
          <wtc:param value="region"/>
          <wtc:param value="<%=regionCode%>"/>
          </wtc:service>
          <wtc:array id="resultr" scope="end" />          
          <%
            System.out.println("_________________________________________________________________________");
            for(int i=0;i<resultr.length;i++){
              for(int j=0;j<resultr[i].length;j++){
                System.out.println("resultr["+i+"]["+j+"]"+"   "+resultr[i][j]);
                          }
                      }
        System.out.println("_________________________________________________________________________");

      if(retCode.equals("000000")){
          System.out.println("***************************************************************************");
          System.out.println("����sFuncCheck�ɹ�"+"___retCode :"+retCode+"  retMsg: "+retMsg);
          int recordNum1 =  resultr.length;       //��count(*)ȡ��
          System.out.println("recordNum1________________________________"+recordNum1);
          for(int i=0;i<recordNum;i++){
          if(!"01".equals(resultt[i][0]) && 0==recordNum1) {
            continue;
          }
            if("01".equals(resultt[i][0])){
              out.println("<option class='button' value='" + resultt[i][0] + "'>" + resultt[i][1] + "</option>");
            }
          }
      }else{
          System.out.println("***************************************************************************");
          System.out.println("����sFuncCheckʧ��"+"___retCode :"+retCode+"  retMsg: "+retMsg);
      }

      %>
                    </select>
          
                  </TD>
                  
                </TR>
                
                <!-- tianyang add for custNameCheck start -->
                <tr id="ownerType_Type">
                  <TD width=16% class="blue" > 
                    <div align="left">���˿�������</div>
                  </TD>
                  <TD colspan="3" width="34%" class="blue" >
                    <select align="left" name="isJSX" onChange="reSetCustName()" width=50 index="6">
                      <!-- //update ȥ����ͨ�ͻ�ѡ��@���ڿ��������ն�CRMģʽAPP�ĺ�
                      	<option class="button" value="0">��ͨ�ͻ�</option>
                       -->
                    System.out.println(" gaopeng workChnFlag " + workChnFlag);  
<%

                    if (!(workChnFlag.equals("1") && openFav == false)){
%>
                        <option class="button" value="1" selected>��λ�ͻ�</option>
<%
                    }
%>
                    </select>
                  </TD>
                </tr>
                <TR > 
                  <TD class="blue" > 
                    <div align="left">����������</div>
                  </TD>
                  <TD colspan="3"> 
                    <input type="text" id="ipt_InterThin_No" name="ipt_InterThin_No"      />
                    <input type="button" class="b_text" value="��ѯ" id="btn_InterThin_No" onclick="go_getInterThin_Info()" />
                    </TD>
                </TR>                
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
                String sqlStr2 ="select trim(group_id),DISTRICT_NAME from  SDISCODE Where region_code='" + regionCode + "' order by DISTRICT_CODE";                     
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
                    <input name=custName id="custName" value=""  v_must=1 v_maxlength=60 v_type="string"   maxlength="60" size=20 index="9"  onblur="if(checkElement(this)){checkCustNameFunc16New(this,0,0)}">
                    <div id="checkName" style="display:none"><input type="button" class="b_text" value="��֤" onclick="checkName()"></div>
                   <font class=orange>*</font>
                    </TD>
                </TR>
                <tr> 
                  <td width=16% class="blue" > 
                    <div align="left">֤������</div>
                  </td>
                  <td id="tdappendSome" width=34%> 
                    
                  </td>
                  <td width=16% class="blue" > 
                    <div align="left">֤������</div>
                  </td>
                  <td width=34%> 
                    <input name="idIccid"  id="idIccid"   value=""  v_minlength=4 v_maxlength=20 v_type="string" onChange="change_idType()" maxlength="20"   index="11" value="" onBlur="checkIccIdFunc16New(this,0,0);rpc_chkX('idType','idIccid','A');">
                    <input name=IDQueryJustSee type=button class="b_text" style="cursor:hand" onClick="getInfo_IccId_JustSee()" id="custIdQueryJustSee" value=��Ϣ��ѯ >
                    <input type="button" name="iccIdCheck" class="b_text" value="У��" onclick="checkIccId()" disabled>
        						<input type="hidden" name="IccIdAccept" value="<%=IccIdAccept%>">
                    </td>
                </tr>
                

                <tr> 
                  <td class="blue" > 
                    <div id="idAddrDiv" align="left">֤����ַ</div>
                  </td>
                  <td> 
                    <input name=idAddr  id="idAddr" value=""   v_must=1 v_type="string"  maxlength="60" v_maxlength=60 size=30 index="12" onblur="if(checkElement(this)){checkAddrFunc(this,0,0)}">
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
              
                  
                <TR> 
                  <TD class="blue" > 
                    <div align="left">�ͻ���ַ</div>
                  </TD>
                  <TD colspan="3"> 
                    <input name=custAddr class="button"  v_type="string" v_must=1 v_maxlength=60   maxlength="60" size=35 index="18" onblur="if(checkElement(this)){checkAddrFunc(this,1,0)}">
                    <font class=orange>*</font> 
                  </TD>
                  </TD>
                </TR>
                         
                <TR> 
                  <TD class="blue" > 
                    <div align="left">��ϵ������</div>
                  </TD>
                  <TD> 
                    <input name=contactPerson class="button" value="" v_type="string"  maxlength="60" size=20 index="19" v_must=1 v_maxlength=60 onblur="if(checkElement(this)){checkCustNameFunc(this,1,0)}">
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
                    <input name=contactAddr  class="button" v_must=1 v_type="string"  maxlength="60" v_maxlength=60 size=30 index="21"  onblur="if(checkElement(this)){ checkAddrFunc(this,2,0);}">
                    <font class=orange>*</font> </TD>
                  <TD class="blue" > 
                    <div align="left">&nbsp;</div>
                  </TD>
                  <TD> 
                    <input type="hidden" name=contactPost class="button" v_type="zip" v_name="��ϵ���ʱ�" maxlength="6"  index="22" size="20">
                  </TD>
                </TR>
                <TR style="display:none"> 
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
                <TR style="display:none"> 
                  <TD class="blue" > 
                    <div align="left">&nbsp;</div>
                  </TD>
                  <TD colspan="3"> 
                    <input type="hidden" name=contactMAddr class="button" v_must=0 v_maxlenth=60 v_type="string"  maxlength="60" size=35 index="25" onblur="if(checkElement(this)){checkAddrFunc(this,3,0)}">
                    </TD>
                </TR>

                <!-- 20131216 gaopeng 2013/12/16 10:29:28 ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭������Ϣ start -->
                 <%@ include file="/npage/sq100/gestoresInfo.jsp" %>
                 <%@ include file="/npage/sq100/responsibleInfo.jsp" %>
                 <%@ include file="/npage/sq100/realUserInfo.jsp" %>
                 
                <tr>
									<td width="20%" class="blue">�����ļ�</td>
									<td width="80%" colspan="3">
										<input type="file" id="uploadFile" name="uploadFile" v_must="1"  
											style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' />&nbsp;<font color="red">*</font>
									</td>
								</tr>
								<tr>
									<td class="blue">
										�ļ���ʽ˵��
									</td>
					        <td colspan="3"> 
					            �ϴ��ļ��ı���ʽΪ����������|sim���š���ʾ�����£�<br>
					            <font class='orange'>
					            	14765355078|898600D69916C0051225<br/>
												18491010003|898602C99816C1505003<br/>

					            </font>
					            <b>
					            <br>&nbsp;&nbsp; ע����ʽ�е�ÿһ������������ڿո�,��ÿ�����ݶ���Ҫ�س����С�
					            <br>&nbsp;&nbsp; �ϴ��ļ���ʽΪtxt�ļ�������಻����500����
					            </b> 
					        </td>
	   					 	</tr>
	   					 	<tr>
                	<td class="blue">Ʒ��</td>
                	<td>
                			<select name="smCode" id="smCode" onchange="setOfferType()">
                				<option value="101" selected>101-->������</option>
                			</select>
                	</td>
                	<td class='blue' nowrap>����Ʒ����</td>
									<td >
											<SELECT name="offer_att_type" style="width:200px" id="offer_att_type"> 
												<option value="">--��ѡ��--</option>
						    			</SELECT>
						    			&nbsp;&nbsp;<input type="button" name="qrySmInfo" class="b_text" value="��ѯ" onclick="productOfferQryByAttr();"/>
									</td>
									 <td style="display:none">
								  <SELECT name="receiveRegion" id="receiveRegion"> 
				          </SELECT>
		 						</td>
                </tr>
                </TBODY> 
              </TABLE> 
                              
                   
 
  
		<div id="resultContent" style="display:none">
		<div class="title"><div id="title_zi">�����Բ�ѯ����б�</div></div>
		<div class="list" style="height:156px; overflow-y:auto; overflow-x:hidden;">
		<table id="exportExcel" name="exportExcel">
			<tbody id="appendBody">
				
			
			</tbody>
		</table>
		</div>
	</div>
	<div id="OfferAttribute"></div><!--С������-->   
	<!--��Ʒ��Ϣ-->   
	<DIV class="input" id="productInfo">
		<br>
			<div class="title">
			<div id="title_zi">��Ʒ��Ϣ</div>
		</div>
	
		<div id="majorProdRel"></div> 
		
		<div id="prodAttribute"></div> <!--��Ʒ����-->
		
		<TABLE cellSpacing=0 id="tab_addprod" style="display:none">
		  
				<TR>
		    
		  	</TR>
		</table>
	</DIV>
	
	<!-- ��������Ʒ ����-->
	<!-- ��������Ʒ ��ʼ-->
	<div class="undis" id="tbc_02" style="display:none">
			<div class="title">
			<div id="title_zi">��������Ʒ</div>
		</div>
	  <TABLE cellSpacing=0 id="adddiscount">
	  </TABLE>
	<div id="offer_component"></div> 
	<div id="div_offerComponent"></div> 
	
	</div>
       
	       <TABLE cellSpacing="0">
    <TBODY> 
    <TR style="display:none"> 
      <TD width=16% class="blue" > 
        <div align="left">ϵͳ��ע</div>
      </TD>
      <TD> 
        <input class="button" name=sysNote size=60 readonly maxlength="60">
      </TD>
    </TR>
    <TR> 
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
          <TD align=center id="footer"> 
            <input class="b_foot_long" name=print  onclick="printCommit()" onkeyup="if(event.keyCode==13)printCommit()"  type=button value=ȷ��  index="39" disabled>
            <!-- <input class="b_foot_long" name=mytests  onclick="myTest()"  type=button value=����  index="39" > -->
          <input class="b_foot" name=reset1 type=button  onclick=" window.location.href='/npage/si064/fi067_main.jsp?opCode=<%=opCode%>&opName=<%=opName%>';" value=��� index="40">
          <input class="b_foot" name=back type=button onclick="
          <% 
                if("1".equals(inputFlag)){ 
                    out.print(" window.close() ");
                }else{
                    out.print(" removeCurrentTab() ");
                } 
            %>
          " value=�ر� index="41">
            <input type="reset" name="Reset" value="Reset" style="display:none">
          </TD>
    </TR>
  </TBODY>
</TABLE>
  <input type="hidden" name="ReqPageName" value="f1100_1">
  <!--��ˮ�� -->
	<input type="hidden" name="printAccept" value="<%=loginAccept%>">
  <input type="hidden" name="workno" value=<%=workNo%>>
  <input type="hidden" name="opCode" value="<%=opCode%>">
  <input type="hidden" name="opName" value="<%=opName%>">
  <input type="hidden" name="regionCode" value=<%=regionCode%>> 
  <input type="hidden" name="unitCode" value=<%=orgCode%>>
  <input type="hidden" id=in6 name="belongCode" value=<%=belongCode%>>  
  <input type="hidden" id=in1 name="hidPwd" v_name="ԭʼ����">
  <input type="hidden" name="hidCustPwd">       <!--���ܺ�Ŀͻ�����-->
  <input type="hidden" name="temp_custId">
  <input type="hidden" name="custId" value="0">
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
  
  <input type="hidden" name="majorProductId" value="">
  
  <!--��Ʒ��Ϣ-->
	<input type="hidden" name="productIdArr" />
	<input type="hidden" name="prodEffectDate"/>
	<input type="hidden" name="prodExpireDate"/>
	<input type="hidden" name="isMainProduct"/>
	<input type="hidden" name="endStr"/>
  
  
  <%@ include file="/npage/include/footer.jsp" %> 
 
<jsp:include page="/npage/common/pwd_comm.jsp"/>
</form>
</body>
<%@ include file="/npage/sq100/interface_provider.jsp" %>
<%@ include file="/npage/include/public_smz_check.jsp" %>
<OBJECT id="CardReader_CMCC" height="0" width="0"  classid="clsid:FFD3E742-47CD-4E67-9613-1BB0D67554FF" codebase="/npage/public/CardReader_AGILE.cab#version=1,0,0,6"></OBJECT>
</html>