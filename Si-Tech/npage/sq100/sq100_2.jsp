<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http//www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http//www.w3.org/1999/xhtml">
<%
/********************
 version v2.0
 ������: si-tech
 update by liutong @ 2008.09.03
 update by qidp @ 2009-08-18 for ���ݶ˵�������
********************/
%>

<%@ include file="/npage/include/public_title_name.jsp" %>
<% request.setCharacterEncoding("GBK");%>
<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="com.sitech.boss.pub.util.Encrypt"%>
<%@ page import="java.text.SimpleDateFormat"%><!--����֤-->
<%@ page import="com.jspsmart.upload.*"%><!--����֤-->
<%@ page import="import java.sql.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.io.File"%><!--����֤-->
<%@ page import="com.uploadftp.*"%><!--����֤-->
<%@ page import="sun.misc.BASE64Decoder"%>
<%@ page import="import sun.misc.BASE64Encoder"%>
<%@ include file="getIccidFtpPas.jsp" %> 
<%!
	public static String GetImageStr(String imgFilePath) {// ��ͼƬ�ļ�ת��Ϊ�ֽ������ַ��������������Base64���봦��
		byte[] data = null;

		// ��ȡͼƬ�ֽ�����
		try {
			InputStream in = new FileInputStream(imgFilePath);
			data = new byte[in.available()];
			in.read(data);
			in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		// ���ֽ�����Base64����
		BASE64Encoder encoder = new BASE64Encoder();
		return encoder.encode(data);// ����Base64��������ֽ������ַ���

	}

%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title></title>
</head>
<body>

	<%-------------ng35��Ŀ�����ύ�ȴ���̬ͼƬ-----hejwa----2012��12��6��-----%>
		<style type="text/css">
				#addContainer{ 
				    position: absolute;
				    top: 50%;
				    left: 50%;
				    margin: -150px 0 0 -320px;
						text-align: center;
						width: 640px;
						padding: 20px 0 20px 0;
						border: 1px solid #339;
						background: #EEE;
						white-space: nowrap;
				}
				#addContainer img, #addContainer p{
						display: inline; 
						vertical-align: middle; 
						font: bold 12px "����", serif; 
				}
		</style>
		<script type="text/javascript">
			<!--
			     function loader(){
							var oDiv = document.createElement("div");
							oDiv.noWrap = true;
							oDiv.innerHTML = "<div id='addContainer'><nobr><img src='/nresources/default/images/progress.gif'><p class='orange'></p></nobr></div>"
							document.body.insertBefore(oDiv,document.body.firstChild);
							if(document.all){
								window.attachEvent("onload",function(){ oDiv.parentNode.removeChild(oDiv);});
							}else{
								window.addEventListener("load",function(){ oDiv.parentNode.removeChild(oDiv);},false);
							}
					 }
			//-->
		</script>
		<script>loader();</script>
	<%-------------ng35��Ŀ�����ύ�ȴ���̬ͼƬ-----hejwa----2012��12��6��-------����--%>


<%
String upflag = request.getParameter("upflag");//�ϴ���־//����֤

if(upflag==null) upflag ="0";//����֤
System.out.println("----------upflag---------"+upflag);

String workno = request.getParameter("workno");
//����11����Ѯ���ſͻ���CRM��BOSS�;���ϵͳ����ĺ�-3-ESOPϵͳ�������̻�����֧������ liangyl 20160823
String input_accept = request.getParameter("input_accept");
if(upflag.equals("1")){//����֤
  String sSaveName_db = "";
	String filePath = request.getParameter("filep_j");//ͼƬ·��
	System.out.println("----------filePath---------"+filePath);
  String card_flag = request.getParameter("card_flag");//����֤������־
  System.out.println("----------card_flag---------"+card_flag);
  String but_flag = request.getParameter("but_flag");//��ť��־����ȷ��ɨ����߶�ȡ��ֵΪ1
  System.out.println("----------but_flag---------"+but_flag);

	String opCode = "1100";
  String custSex = request.getParameter("idSexH");  	//�ͻ��Ա�
  System.out.println("----------custSex---------"+custSex);
  String regionCode = request.getParameter("regionCode");
  System.out.println("----------regionCode---------"+regionCode);
  String custName = request.getParameter("custName");
  System.out.println("----------custName---------"+custName);
  String idAddr = request.getParameter("idAddrH");
  System.out.println("----------idAddr---------"+idAddr);
	String birthDay = WtcUtil.repStr(request.getParameter("birthDayH")," "); //��������
	System.out.println("----------birthDay---------"+birthDay);
	String custId = request.getParameter("custId");
	System.out.println("----------custId---------"+custId);
	String idIccid = request.getParameter("idIccid");
	System.out.println("----------idIccid---------"+idIccid);
	String zhengjianyxq = request.getParameter("zhengjianyxq");
	System.out.println("----------zhengjianyxq---------"+zhengjianyxq);
	String password = (String)session.getAttribute("password");
	String up_fa = "1";
	
	
	System.out.println("----------birthDay---------"+birthDay);
	System.out.println("liangyl------"+input_accept);
	if(!birthDay.equals("")) {
	 birthDay =	birthDay.replaceAll("-", "");
	}
	
			/*********************************�ϴ�ͼƬ��������*************************************/
			if((filePath!=null||!filePath.equals(""))&&but_flag.equals("1")) 
			{
			System.out.println("-----------------------------if---------------------");
			SmartUpload mySmartUpload = new SmartUpload();
			String t_fileName = filePath ;
			String filename = filePath.substring(filePath.lastIndexOf("\\")+1,filePath.length());
			System.out.println("----------filename---------"+filename);
			File file_cre = new File(request.getRealPath("npage/cust_ID"));
			if(!file_cre.exists()){
			file_cre.mkdirs();
			}
			String sSaveName=request.getRealPath("npage/cust_ID/")+"/"+filename;
			
			sSaveName_db = sSaveName;
			String srvIP=request.getServerName();
			String iErrorNo ="";
			String sErrorMessage = "";

   SmartUpload su = new SmartUpload();
    su.initialize(pageContext);
    su.setMaxFileSize(10000000);
    su.setTotalMaxFileSize(20000000);
    su.setAllowedFilesList("doc,txt,jpg,rar,mid,waw,mp3,gif");
    boolean sign = true;
    try {
        su.setDeniedFilesList("exe,bat,jsp,htm,html");
        su.upload();
        String savapic =  request.getRealPath("npage/cust_ID/")+"/";
        System.out.println("--------------savapic----------------"+savapic);
        su.save(savapic);
        System.out.println("--------------su.save(savapic)----------------");        
 

		    String IDSex_t = "";
		    System.out.println("--------------custSex----------------"+custSex);
		    if(custSex.equals("1"))
		    	IDSex_t = "��";
		    else if(custSex.equals("2"))
		    	IDSex_t = "Ů";
		    else
		    	IDSex_t = "δ֪";


	      String sign_date =new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()).toString();
	     
				 	    
	  String idCard_path = "";  
 		FtpTools ftpT=new FtpTools();
 		
		String idRegion_S = idIccid.substring(0,2);
		String idRegion = idIccid.substring(2,4);
		String dirName = idIccid.substring(0,6)+"/";
		
		
		System.out.println("idRegion_S|"+idRegion_S);//����֤��ǰ2λ��ʡ�ݱ�־ 23
		System.out.println("idRegion|"+idRegion);//����֤3-4 λ�����б�־ 01
		
		String serverIP = "10.110.2.241";
		int serverPORT = 6790;
		String idPath = "";
		
	if(idRegion_S.equals("23")){
		if(idRegion.equals("01")){       //������
			idPath = "harb/"+dirName;
			
			/*serverIP = "10.110.0.204";
			idPath = "bossjsp/"+dirName;*/
		}else if(idRegion.equals("02")){			 //�������
			idPath = "qqhr/"+dirName;
		}else if(idRegion.equals("03")){			 //����
			idPath = "jix/"+dirName;
		}else if(idRegion.equals("04")){			 //�׸�
			idPath = "heg/"+dirName;
		}else if(idRegion.equals("05")){			 //˫Ѽɽ
			idPath = "sys/"+dirName;
		}else if(idRegion.equals("06")){			 //����
			idPath = "daq/"+dirName;
		}else if(idRegion.equals("07")){		   //����
			idPath = "yic/"+dirName;
		}else if(idRegion.equals("08")){			 //��ľ˹
			idPath = "jms/"+dirName;
		}else if(idRegion.equals("09")){		   //��̨��
			idPath = "qth/"+dirName;
		}else if(idRegion.equals("10")){       //ĵ����
			idPath = "mdj/"+dirName;
		}else if(idRegion.equals("11")){			 //�ں�
			idPath = "heih/"+dirName;
		}else if(idRegion.equals("23")){			 //�绯
			idPath = "suih/"+dirName;
		}else if(idRegion.equals("27")){			 //���˰���
			idPath = "dxal/"+dirName;
		}else{	   //�������� update for ��ѩ������Ժ�����ʡ����������Ҳ���д�����������other�ļ���@2015/2/15 
			idPath = "other/";
		}
	}else{												   //��������
		idPath = "other/";
	}
		
		String yearMon=new java.text.SimpleDateFormat("yyyyMM", Locale.getDefault()).format(new java.util.Date());
		idPath = idPath +yearMon+"/";
		String ftpsPassword = getPas();
		System.out.println("ftpsPassword|"+ftpsPassword);
		
	       String sql_iccidInfo="";
	       String sql_toiccid = "";
	    
	    	
		if(ftpT.connect(serverIP,serverPORT)){
			//System.out.println("---------------------------4--------------------------"+ftpT.login_S("LKPCOLOKLCLC","LKPCOLOKLCLC"));
			if(ftpT.login_S("iccid",ftpsPassword)){
				System.out.println("---------------------------5--------------------------");
			  idCard_path = serverIP+"_"+idPath+filename;
			  System.out.println("idCard_path|"+idCard_path);
				boolean upftpfile = ftpT.uploadFile("/"+idPath+filename,sSaveName);
				System.out.println("---------uploadFile ��һ������----------"+"/"+idPath+filename);
				System.out.println("---------uploadFile �ڶ�������----------"+sSaveName);
				System.out.println("----------sSaveName---------"+sSaveName);
				System.out.println("�ϴ�ͼƬ���Ϊ��"+upftpfile);
					if(!upftpfile){
					up_fa = "0";
					}
				ftpT.logout();
				}else{
				  ftpT.logout();
				  System.out.println("---------------------------1--------------------------");
				  up_fa = "0";
				} 
			}else{
				System.out.println("---------------------------2--------------------------");
				up_fa = "0";
				}
	if(up_fa.equals("1")){   
	
			  String sbasestrs = GetImageStr(sSaveName_db);
		    System.out.println(sbasestrs);
			  
System.out.println("---------------------------�������˶��������--------------------------");
		
	String  inputParsm [] = new String[17];
	inputParsm[0] = "";
	inputParsm[1] = "01";
	inputParsm[2] = opCode;
	inputParsm[3] = workno;
	inputParsm[4] = password;
	inputParsm[5] = "";
	inputParsm[6] = "";

	inputParsm[7] = idIccid;
	inputParsm[8] = "2��";
	inputParsm[9] = custName;
	inputParsm[10] = idAddr;
	inputParsm[11] = IDSex_t;
	inputParsm[12] = birthDay;
	inputParsm[13] = zhengjianyxq;

	inputParsm[14] = "";
	inputParsm[15] = custId;
	inputParsm[16] = idCard_path;
	System.out.println("diling---�ϴ�--sbasestrs="+sbasestrs);
	/*
	inputParsm[8] = "231026198110202388";
	inputParsm[9] = "���������ϸ���ѧ��·52��";
	inputParsm[10] = "�ﰮ��";
	inputParsm[11] = "2007.05.24-2017.05.24";
	*/
	%>
		<wtc:service name="sM032Cfm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode" retmsg="retMsg" outnum="1">
			<wtc:param value="<%=inputParsm[0]%>"/>
			<wtc:param value="<%=inputParsm[1]%>"/>
			<wtc:param value="<%=inputParsm[2]%>"/>
			<wtc:param value="<%=inputParsm[3]%>"/>
			<wtc:param value="<%=inputParsm[4]%>"/>
			<wtc:param value="<%=inputParsm[5]%>"/>
			<wtc:param value="<%=inputParsm[6]%>"/>
			<wtc:param value="<%=inputParsm[7]%>"/>
			<wtc:param value="<%=inputParsm[8]%>"/>
			<wtc:param value="<%=inputParsm[9]%>"/>
			<wtc:param value="<%=inputParsm[10]%>"/>
			<wtc:param value="<%=inputParsm[11]%>"/>	
			<wtc:param value="<%=inputParsm[12]%>"/>	
			<wtc:param value="<%=inputParsm[13]%>"/>
			<wtc:param value="<%=inputParsm[14]%>"/>
			<wtc:param value="<%=inputParsm[15]%>"/>		
			<wtc:param value="<%=inputParsm[16]%>"/>
	</wtc:service>
	<wtc:array id="ret" scope="end"/>
<%
	
	if("000000".equals(retCode)){
		%>

		<%
	}else {
				%>
		<script language="javascript">
			rdShowMessageDialog("��¼ʧ�ܣ�������룺<%=retCode%> ��������Ϣ��<%=retMsg%>",0);
		</script>
		<%
		}

				}
		    
		  
			  	}
			catch(Exception e)
			{
			up_fa = "0";
 
			e.printStackTrace();
			}
		  	 //ɾ��Ӳ���ϵ�ͼƬ�ļ�
		  	  File filePic =new File(sSaveName_db);
		  	  System.out.println("----------------------------sSaveName_db-----------------------------"+sSaveName_db);
 				  boolean dpa  = filePic.delete();
 				  System.out.println("----------------------------dpa-----------------------------"+dpa);
					System.out.println("---------------------------up_fa--------------------------"+up_fa);
	   if(up_fa.equals("1")){
	   %>

	   				<script language="JavaScript">
                function delete_pic(){
            		try{
            		var fso = new ActiveXObject("Scripting.FileSystemObject");  //ȡϵͳ�ļ�����
            		}catch(e){
								rdShowMessageDialog("�����ÿͻ��˰�ȫ��",0);
								}
	            		if(fso!=undefined)
	            		{
									tmpFolder = fso.GetSpecialFolder(0); //ȡ��ϵͳ��װĿ¼
									var strtemp= tmpFolder+"";
									var filep1 = strtemp.substring(0,1)//ȡ��ϵͳĿ¼�̷�
									var cre_dir = filep1+":\\custID";//����Ŀ¼
									//�ж��ļ����Ƿ����
										if(fso.FolderExists(cre_dir)) {
										var newFolderName = fso.DeleteFolder(cre_dir);
										}
									}
            		}
            		rdShowMessageDialog("�ϴ��ɹ�",2);
            		delete_pic();
            </script>
	   <%}
	  else{
	  	%>
	  				<script language="JavaScript">
	  					function delete_pic(){
            		try{
            		var fso = new ActiveXObject("Scripting.FileSystemObject");  //ȡϵͳ�ļ�����
            		}catch(e){
								rdShowMessageDialog("�����ÿͻ��˰�ȫ��",0);
								}
	            		if(fso!=undefined)
	            		{
									tmpFolder = fso.GetSpecialFolder(0); //ȡ��ϵͳ��װĿ¼
									var strtemp= tmpFolder+"";
									var filep1 = strtemp.substring(0,1)//ȡ��ϵͳĿ¼�̷�
									var cre_dir = filep1+":\\custID";//����Ŀ¼
									//�ж��ļ����Ƿ����
										if(fso.FolderExists(cre_dir)) {
										var newFolderName = fso.DeleteFolder(cre_dir);
										}
									}
            		}
            		rdShowMessageDialog("�ϴ�ʧ��"+"<%=up_fa%>",0);
            		delete_pic();
            </script>
	  	<%}
	/**********************************************************************/

  }
}
else
	{
	  System.out.println("----------------------------else--------------------------");
     String total_date,login_accept=request.getParameter("IccIdAccept");
  //  String[][] result = new String[][]{};
 	//S1100View callView = new S1100View();
 	/*--------------------------*/
	String custId = request.getParameter("custId"); 
	String regionCode = request.getParameter("regionCode"); 
	
	String belongCode = (String)session.getAttribute("orgCode");
	belongCode = belongCode.substring(0,7);
	
	String regionId = request.getParameter("regionCode") + request.getParameter("districtCode") + "999"; 
	
	String custName = request.getParameter("custName"); 
	String custPwd = WtcUtil.repStr(request.getParameter("custPwd"),"");
	String inputFlag = request.getParameter("inputFlag");
	System.out.println("# inputFlag = "+inputFlag);
	custPwd=Encrypt.encrypt(custPwd);
	String pic_name = request.getParameter("pic_name");
	System.out.println("----------pic_name---------"+pic_name);
	String custStatus = request.getParameter("custStatus"); 
	String custGrade = WtcUtil.repStr(request.getParameter("custGrade"),"00"); 
	String ownerType = request.getParameter("ownerType"); 
	String custAddr = WtcUtil.repNull(request.getParameter("custAddr")); 
	String idType = request.getParameter("idType");
	System.out.println("idType"+idType);
	idType = idType.substring(0,idType.indexOf("|"));    //֤�����ͣ�0-����֤
	/*20131216 gaopeng 2013/12/16 16:01:31 ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭������Ϣ start*/
	/*����������*/
	String gestoresName = WtcUtil.repStr(request.getParameter("gestoresName"),"");
	/*��������ϵ��ַ*/
	String gestoresAddr = WtcUtil.repStr(request.getParameter("gestoresAddr"),"");
	/*������֤������*/
	String gestoresIdType = WtcUtil.repStr(request.getParameter("gestoresIdType"),"");
	gestoresIdType = gestoresIdType.substring(0,gestoresIdType.indexOf("|"));
	/*������֤������*/
	String gestoresIccId = request.getParameter("gestoresIccId");
	String xsjbrxx=WtcUtil.repStr(request.getParameter("xsjbrxx"),"0");
	System.out.println("-----------gaopeng---------gestoresName------------------------------"+gestoresName);
	System.out.println("-----------gaopeng---------gestoresAddr------------------------------"+gestoresAddr);
	System.out.println("-----------gaopeng---------gestoresIdType------------------------------"+gestoresIdType);
	System.out.println("-----------gaopeng---------gestoresIccId------------------------------"+gestoresIccId);
	
	
		/*����������*/
	String responsibleName = WtcUtil.repStr(request.getParameter("responsibleName"),"");
	/*��������ϵ��ַ*/
	String responsibleAddr = WtcUtil.repStr(request.getParameter("responsibleAddr"),"");
	/*������֤������*/
	String responsibleType = WtcUtil.repStr(request.getParameter("responsibleType"),"");
	responsibleType = responsibleType.substring(0,responsibleType.indexOf("|"));
	/*������֤������*/
	String responsibleIccId = request.getParameter("responsibleIccId");
	

	/*ʹ��������*/
	String realUserName = WtcUtil.repStr(request.getParameter("realUserName"),"");
	/*ʹ������ϵ��ַ*/
	String realUserAddr = WtcUtil.repStr(request.getParameter("realUserAddr"),"");
	/*ʹ����֤������*/
	String realUserIdType = WtcUtil.repStr(request.getParameter("realUserIdType"),"");
	/*ʹ����֤������*/
	String realUserIccId = request.getParameter("realUserIccId");
	
	String jingbanrenstrss=gestoresName+"|"+gestoresIdType+"|"+gestoresIccId+"|"+gestoresAddr;
	String zerenrenstrss=responsibleType+"|"+responsibleIccId+"|"+responsibleName+"|"+responsibleAddr;
	
	
	/*20131216 gaopeng 2013/12/16 16:01:31 ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭������Ϣ end*/
	
  String isDirectManageCust = request.getParameter("isDirectManageCust");//�Ƿ�ֱ�ܿͻ�
  String directManageCustNo = request.getParameter("directManageCustNo");//ֱ�ܿͻ�����
  String groupNo = request.getParameter("groupNo");//��֯��������
	
	String idIccid = request.getParameter("idIccid"); 
	String idAddr = request.getParameter("idAddr"); 
	String idValidDate = WtcUtil.repStr(request.getParameter("idValidDate")," "); 
	if(idValidDate.trim().compareTo("")==0)
	{	  
	/*
	*��������
	int toy=Integer.parseInt(new SimpleDateFormat("yyyy", Locale.getDefault()).format(new Date())); 
	String tomd= new SimpleDateFormat("MMdd", Locale.getDefault()).format(new Date());  
	idValidDate=String.valueOf(toy+10)+tomd;
	*/
		Calendar cc = Calendar.getInstance();
            cc.setTime(new java.util.Date());
            cc.add(Calendar.YEAR, 10);
            java.util.Date _tempDate = cc.getTime();
            idValidDate = new SimpleDateFormat("yyyyMMdd", Locale.getDefault()).format(_tempDate);
	}
	
	String contactPerson = request.getParameter("contactPerson"); 
	String contactPhone = request.getParameter("contactPhone"); 
	String contactAddr = request.getParameter("contactAddr"); 
	String contactPost = request.getParameter("contactPost");
	if(contactPost.compareTo("")==0)
	{	contactPost = " ";	}
	String contactMAddr = request.getParameter("contactMAddr"); 	
	String contactFax = request.getParameter("contactFax"); 
	if(contactFax.compareTo("")==0)
	{	contactFax = " ";	}	
	String contactMail = request.getParameter("contactMail"); 
	if(contactMail.compareTo("")==0)
	{	contactMail = " ";	}
	String unitCode = request.getParameter("unitCode"); //��������
	String parentId = request.getParameter("parentId"); 
	if(parentId.compareTo("") == 0)
	{   parentId = custId;          	}
	String custSex = request.getParameter("custSex");  	//�ͻ��Ա�
	String birthDay = WtcUtil.repStr(request.getParameter("birthDay")," "); //��������
	if(birthDay.trim().compareTo("") == 0)
	{
 	  if(idIccid.trim().length()==15 && idType.equals("0")) 
		birthDay="19"+idIccid.substring(6,8)+idIccid.substring(8,12);
	  else if(idIccid.trim().length()==18 && idType.equals("0")) 
        birthDay=idIccid.substring(6,10)+idIccid.substring(10,14);
	  else
        birthDay="19491001";
	} 
	String professionId = request.getParameter("professionId"); 
	String vudyXl = request.getParameter("vudyXl"); //ѧ��
	String custAh = request.getParameter("custAh"); //�ͻ����� 
	if(custAh.length() == 0)
	{	custAh = "��";	}
	String custXg = request.getParameter("custXg"); //�ͻ�ϰ��
	if(custXg.compareTo("") == 0)
	{	custXg = "��";	}
	String unitXz = request.getParameter("unitXz"); //���Ź�ģ�ȼ�
	String yzlx = request.getParameter("yzlx"); //ִ������//��̨δ�õ�,���������䴫�Ͳ߷����ű�־
	String yzhm = request.getParameter("yzhm"); //ִ�պ���
	String yzrq = request.getParameter("yzrq"); //ִ����Ч��
	String frdm = request.getParameter("frdm"); //���˴���
	String groupCharacter = WtcUtil.repStr(request.getParameter("groupCharacter"),"��");//Ⱥ����Ϣ
	//String opCode = "1100";
	String opCode = WtcUtil.repStr(request.getParameter("opCode")," "); 
	if("".equals(opCode)){
	  opCode = "1100";
	}
	
	String shiyongrenstrss="";
	if("1993".equals(opCode)){
		shiyongrenstrss="@"+realUserIdType+"|"+realUserIccId+"|"+realUserName+"|"+realUserAddr;
	}
	else{
		shiyongrenstrss="";
	}
	zerenrenstrss = zerenrenstrss+shiyongrenstrss;
	workno = request.getParameter("workno");	
	String sysNote = request.getParameter("sysNote"); 
	String opNote = request.getParameter("opNote"); 
	String ip_Addr = request.getParameter("ip_Addr"); 
	String oriGrpNo=WtcUtil.repStr(request.getParameter("oriGrpNo"),"0");
	String sisJSX = WtcUtil.repNull(request.getParameter("isJSX"));
	String isceshijt_flag = WtcUtil.repNull(request.getParameter("isceshijt_flag"));
	
	/*luxc 20080326 add*/
	if("02".equals(ownerType)||"03".equals(ownerType)||"04".equals(ownerType))
	{
		String instigate_flag	= request.getParameter("instigate_flag");
		String getcontract_flag	= request.getParameter("getcontract_flag");
		if("null".equals(getcontract_flag))
		{
			getcontract_flag="N";
		}
		yzlx=instigate_flag+getcontract_flag;
		System.out.println("luxc:instigate_flag="+instigate_flag+"|getcontract_flag="+getcontract_flag);
		System.out.println("luxc:yzlx="+yzlx);
	}
	/*luxc 20080326 add end*/
	
    //------------------------

	/**	retArray = callView.view_s1100Cfm(custId, regionId, custName, custPwd,		//4
		            custStatus, custGrade, ownerType, custAddr, idType, idIccid, 	//10
		            idAddr, idValidDate, contactPerson, contactPhone, contactAddr, 	//15
		            contactPost, contactMAddr, contactFax, contactMail, unitCode, 	//20
		            parentId, custSex, birthDay, professionId, vudyXl, custAh, 		//26
		            custXg, unitXz, yzlx, yzhm, yzrq, frdm,groupCharacter,opCode,	//34
		            workno,sysNote,opNote,ip_Addr,oriGrpNo);						//39**/
  //wangzn add 091201 for Ǳ�ڼ�����ǩԼ
  String isPre = "1".equals(request.getParameter("isPre"))? "1":"0";
  String preUnitId = request.getParameter("preUnitId");
  String selSvcLvl = request.getParameter("selSvcLvl");
  String selU0002 = request.getParameter("selU0002");
  String selU0003 = request.getParameter("selU0003");
  
  
  	String Tax_identi_num = WtcUtil.repNull(request.getParameter("Tax_identi_num")); 

			System.out.println("**********************************opCode=["+opCode+"]**************************************************************8");
			System.out.println("--------------------login_accept------------------------------"+login_accept);
			System.out.println("--------------------custId------------------------------------"+custId);
			System.out.println("--------------------belongCode----------------------------------"+belongCode);
			System.out.println("--------------------custName----------------------------------"+custName);
			System.out.println("--------------------custPwd-----------------------------------"+custPwd);
			System.out.println("--------------------custStatus--------------------------------"+custStatus);
			System.out.println("--------------------custGrade---------------------------------"+custGrade);
			System.out.println("--------------------ownerType---------------------------------"+ownerType);
			System.out.println("--------------------custAddr----------------------------------"+custAddr);
			System.out.println("--------------------idType------------------------------------"+idType);
			System.out.println("--------------------idIccid-----------------------------------"+idIccid);
			System.out.println("--------------------idAddr------------------------------------"+idAddr);
			System.out.println("--------------------idValidDate-------------------------------"+idValidDate);
			System.out.println("--------------------contactPerson-----------------------------"+contactPerson);
			System.out.println("--------------------contactPhone------------------------------"+contactPhone);
			System.out.println("--------------------contactAddr-------------------------------"+contactAddr);
			System.out.println("--------------------contactPost-------------------------------"+contactPost);
			System.out.println("--------------------contactMAddr------------------------------"+contactMAddr);
			System.out.println("--------------------contactFax--------------------------------"+contactFax);
			System.out.println("--------------------contactMail-------------------------------"+contactMail);
			System.out.println("--------------------unitCode----------------------------------"+unitCode);	
			System.out.println("--------------------parentId----------------------------------"+parentId);
			System.out.println("--------------------custSex-----------------------------------"+custSex);
			System.out.println("--------------------birthDay----------------------------------"+birthDay);
			System.out.println("--------------------professionId------------------------------"+professionId);
			System.out.println("--------------------vudyXl------------------------------------"+vudyXl);
			System.out.println("--------------------custAh------------------------------------"+custAh);	
			System.out.println("--------------------custXg------------------------------------"+custXg);
			System.out.println("--------------------unitXz------------------------------------"+unitXz);
			System.out.println("--------------------yzlx--------------------------------------"+yzlx);
			System.out.println("--------------------yzhm--------------------------------------"+yzhm);
			System.out.println("--------------------yzrq--------------------------------------"+yzrq);
			System.out.println("--------------------frdm--------------------------------------"+frdm);
			System.out.println("--------------------groupCharacter----------------------------"+groupCharacter);
			System.out.println("--------------------opCode------------------------------------"+opCode);
			System.out.println("--------------------workno------------------------------------"+workno);
			System.out.println("--------------------sysNote-----------------------------------"+sysNote);
			System.out.println("--------------------opNote------------------------------------"+opNote);
			System.out.println("--------------------ip_Addr-----------------------------------"+ip_Addr);
			System.out.println("--------------------oriGrpNo----------------------------------"+oriGrpNo);   
			System.out.println("--------------------isPre-------------------------------------"+isPre); //wangzn add 091201 for Ǳ�ڼ�����ǩԼ
      System.out.println("--------------------preUnitId-------------------------------------"+preUnitId); //wangzn add 091201 for Ǳ�ڼ�����ǩԼ			
      System.out.println("--------------------selSvcLvl-------------------------------------"+selSvcLvl); //wangzn add 091201 for Ǳ�ڼ�����ǩԼ			
      System.out.println("q100--------------------selU0002-------------------------------------"+selU0002); //wangzn add 091201 for Ǳ�ڼ�����ǩԼ			
      System.out.println("q100--------------------selU0003-------------------------------------"+selU0003); //wangzn add 091201 for Ǳ�ڼ�����ǩԼ			
			System.out.println("--------------------Tax_identi_num----------------------------------"+Tax_identi_num);   
			System.out.println("************************************************************************************************8");

%>


<wtc:service name="s1100Cfm" routerKey="regionCode" routerValue="<%=regionCode%>"  retcode="ret_code" retmsg="retMessage"  outnum="4" >
					    <wtc:param value="<%=login_accept%>"/>
			        <wtc:param value="<%=custId%>"/>
			        <wtc:param value="<%=regionId%>"/>
			        <wtc:param value="<%=custName%>"/>
			        <wtc:param value="<%=custPwd%>"/>
			        <wtc:param value="<%=custStatus%>"/>
			        <wtc:param value="<%=custGrade%>"/>
			        <wtc:param value="<%=ownerType%>"/>         
			        <wtc:param value="<%=custAddr%>"/>
			        <wtc:param value="<%=idType%>"/>
			        <wtc:param value="<%=idIccid%>"/>
			        	
			        <wtc:param value="<%=idAddr%>"/>
			        <wtc:param value="<%=idValidDate%>"/>
			        <wtc:param value="<%=contactPerson%>"/>
			        <wtc:param value="<%=contactPhone%>"/>
			        <wtc:param value="<%=contactAddr%>"/>
			        <wtc:param value="<%=contactPost%>"/>
			        <wtc:param value="<%=contactMAddr%>"/>
			        <wtc:param value="<%=contactFax%>"/>
			        <wtc:param value="<%=contactMail%>"/>
			        <wtc:param value="<%=unitCode%>"/>	
			        	
			        <wtc:param value="<%=parentId%>"/>
			        <wtc:param value="<%=custSex%>"/>
			        <wtc:param value="<%=birthDay%>"/>
			        <wtc:param value="<%=professionId%>"/>
			        <wtc:param value="<%=vudyXl%>"/>
			        <wtc:param value="<%=custAh%>"/>	
			        <wtc:param value="<%=custXg%>"/>
			        <wtc:param value="<%=unitXz%>"/>
			        <wtc:param value="<%=yzlx%>"/>
			        <%if("1993".equals(opCode)){%>
			        		<wtc:param value="<%=isDirectManageCust%>"/>
					        <wtc:param value="<%=directManageCustNo%>"/>
					        <wtc:param value="<%=groupNo%>"/>
			        <%}else{%>
			        		<wtc:param value="<%=yzhm%>"/>
					        <wtc:param value="<%=yzrq%>"/>
					        <wtc:param value="<%=frdm%>"/>
			        <%}%>
			        
			        <wtc:param value="<%=groupCharacter%>"/>
			        <wtc:param value="<%=opCode%>"/>
			        <wtc:param value="<%=workno%>"/>
			        <wtc:param value="<%=sysNote%>"/>
			        <wtc:param value="<%=opNote%>"/>
			        <wtc:param value="<%=ip_Addr%>"/>
			        <wtc:param value="<%=oriGrpNo%>"/>
				      <wtc:param value="<%=isPre%>"/>
				      	
			        <wtc:param value="<%=preUnitId%>"/>
				      <wtc:param value="<%=selSvcLvl%>"/>
				      <wtc:param value="<%=selU0002%>"/>
				      <wtc:param value="<%=selU0003%>"/>
				    	<wtc:param value="<%=sisJSX%>"/>
				   	<%
					    	 /*��ѡ��λ����ʱ,�ٴ�ֵ*/
					    	if(sisJSX.equals("1") || "1993".equals(opCode)){
					    %>
					      <wtc:param value="<%=jingbanrenstrss%>"/>
					    	<wtc:param value="<%=zerenrenstrss%>"/>

					    <%
					    	}
					    	else if(xsjbrxx.equals("1")){
					    		%>
							      <wtc:param value="<%=jingbanrenstrss%>"/>
							    <%
					    	}
					    	else{
					    %>	
					    	<wtc:param value="|||"/>
					    	<wtc:param value="|||"/>

					    <%	
					    	}
					    	
					    	
              if("1993".equals(opCode)){%>
			        		<wtc:param value="<%=isceshijt_flag%>"/>
			        		<wtc:param value="<%=input_accept%>"/>
			        <%}else{%>
			        		<wtc:param value=""/>
			        		<wtc:param value=""/>
			        <%}%>
			        
			        
			</wtc:service>
			<wtc:array id="result" scope="end" />

<%
	System.out.println("%%%%%%%����ͳһ�Ӵ���ʼ%%%%%%%%");
	String retCodeForCntt = ret_code ;
    String retMsgForCntt =retMessage;
	String loginAccept =login_accept; 
	String opName = "�ͻ�����";
	String unit_id = "";
	
	if(ret_code.equals("0")||ret_code.equals("000000")){
		if(result.length>0){
			loginAccept=result[0][2];
			unit_id = result[0][3];
		}
	}
	System.out.println("# unit_id = "+unit_id);
	//String url = "/npage/contact/upCnttInfo.jsp?opCode="+opCode+"&retCodeForCntt="+retCodeForCntt+"&opName="+opName+"&workNo="+workno+"&loginAccept="+loginAccept+"&contactId="+custId+"&contactType=cust";
	String url = "/npage/contact/onceCnttInfo.jsp?opCode="+opCode+"&retCodeForCntt="+retCodeForCntt+"&retMsgForCntt="+retMsgForCntt+"&opName="+opName+"&workNo="+workno+"&loginAccept="+loginAccept+"&pageActivePhone=&opBeginTime="+opBeginTime+"&contactId="+custId+"&contactType=cust";
	System.out.println("url="+url);
		
	%>
	<jsp:include page="<%=url%>" flush="true" />
		
	<script src="<%=request.getContextPath()%>/njs/extend/jquery/jquery123_pack.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/njs/redialog/redialog.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/njs/si/core_sitech_pack.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/njs/si/autocomplete.js"  type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/njs/si/common.js"  type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/njs/si/framework2.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/njs/si/framework_extend.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/njs/si/tabScript_jsa.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/njs/extend/jquery/hotkey/jquery.hotkeys_jsa.js" type="text/javascript" ></script>
	<script src="<%=request.getContextPath()%>/njs/extend/jquery/block/jquery.blockUI.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/njs/si/validate_pack.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/njs/extend/mztree/MzTreeView12.js" type="text/javascript"></script>
	
	<%
		if((ret_code.trim()).compareTo("000000") == 0)
		{
		    if("1".equals(inputFlag)){
		        %>
                    <script language='jscript'>
                    	$("#addContainer").hide();
                        rdShowMessageDialog("�ͻ����������ɹ���",2);
        								window.returnValue = "<%=unit_id%>";
		                		window.close();
                    </script>            
                <%	
		    }else{
  %>
            <script language="JavaScript">
            	$("#addContainer").hide();
                rdShowMessageDialog("�ͻ����������ɹ���",2);
                var cusId = "<%=custId%>";
  							var custName = "<%=custName%>";
  							openCustMain(cusId,custName,'','');
									  
									  function openCustMain(custId,custName,loginType,phone_no)
											{
											    iCustId = custId;
												if($("#contentArea iframe").size() < 11){
													parent.addTab(true,"custid"+custId,custName,'childTab2.jsp?gCustId='+custId+'&loginType='+loginType+'&phone_no='+phone_no+'&activePhone='+phone_no);
                          /*begin diling update for ���ſ�����ֱ����ת��1902�����ź�ͬЭ��¼��ģ�� @2012/5/28 */
                          if("<%=ownerType%>"=="02"||"<%=ownerType%>"=="04"){
                            parent.addTab(true,"to1902","���ź�ͬЭ��¼��",'../s1901/f1902_main.jsp?gCustId='+custId+'&loginType='+loginType+'&phone_no='+phone_no+'&activePhone='+phone_no);
                          }	
                          /*end diling update@2012/5/28 */
													parent.removeTab("<%=opCode%>");
													//yanpxע�� ���� �ҵ���ҳ�汨��
													//$("#phoneNo").val("��������Ϣ���в�ѯ");
													//document.all.phoneNo.blur();
												}else{
													rdShowMessageDialog("ֻ�ܴ�10��һ��tab");
												}
											}
										 
            </script>            
<%		
            }
        }else
        {
%>
            <script language="JavaScript">
                rdShowMessageDialog("<%=retMessage%>" + "[" + "<%=ret_code%>" + "]");
                $("#addContainer").hide();
                <% if(!("1".equals(inputFlag))){ %>
                history.go(-1);
                <% } %>
            </script>
<%
        }
        }
%>
</body>
</html>