<%
/********************
* ����: �ͻ����ϱ�� 1210
* version v3.0
* ������: si-tech
* update by qidp @ 2008-11-12
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>


<%@ page import="com.sitech.boss.pub.util.Encrypt"%>
<%@ page import="com.sitech.boss.pub.util.ErrorMsg"%>
<%
	String opCode = (String)request.getParameter("vopcode");
	String opName = (String)request.getParameter("vopname");
	request.setCharacterEncoding("GBK");
  String userPhone = request.getParameter("phoneNo");
  String retCode = "999999";
	String retMsg = "";
	String region_code=WtcUtil.repNull(request.getParameter("region_code"));
	String cus_id=WtcUtil.repNull(request.getParameter("cus_id"));
    ArrayList arrSession = (ArrayList)session.getAttribute("allArr");
	String loginAccept = request.getParameter("loginAccept");
  String work_no = (String)session.getAttribute("workNo");
  String loginName = (String)session.getAttribute("workName");
  String org_code = (String)session.getAttribute("orgCode");
	String op_code = opCode;
	String nopass = (String)session.getAttribute("password");
	
	String t_add_notess= request.getParameter("t_add_notes");
	
	String isceshijt_flag = WtcUtil.repNull(request.getParameter("isceshijt_flag"));

    /* add by qidp @ 2009-08-13 for ���϶˵������� . */
    String in_ChanceId = request.getParameter("in_ChanceId");
    String wa_no = request.getParameter("wa_no");
    System.out.println("# from s1210_conf.jsp -> in_Chanceid = " + in_ChanceId);
    System.out.println("# from s1210_conf.jsp -> wa_no = " + wa_no);
    /* end by qidp @ 2009-08-13 for ���϶˵������� . */

    String paraStr[]=new String[47];
    paraStr[0]=loginAccept;
 	paraStr[1]=op_code;
	paraStr[2]=work_no;
	paraStr[3]=nopass;
	paraStr[4]=org_code;
    paraStr[5]=WtcUtil.repSpac(request.getParameter("cus_id"));
	paraStr[6]=WtcUtil.repSpac(request.getParameter("region_code"));
	paraStr[7]=WtcUtil.repSpac(request.getParameter("s_city_a"));
    paraStr[8]=WtcUtil.repSpac(request.getParameter("s_spot_a"));
	paraStr[9]=WtcUtil.repSpac(request.getParameter("t_cus_name"));
 	if(WtcUtil.repSpac(request.getParameter("t_new_pass")).equals(" "))
      paraStr[10]=WtcUtil.repSpac(request.getParameter("oldPass"));
    else
	  paraStr[10]=Encrypt.encrypt(WtcUtil.repSpac(request.getParameter("t_new_pass")));
	paraStr[11]=WtcUtil.repSpac(request.getParameter("s_cus_status"));
	paraStr[12]="00";//WtcUtil.repSpac(request.getParameter("s_cus_level"));
	paraStr[13]=WtcUtil.repSpac(request.getParameter("s_cus_type"));
	paraStr[14]=WtcUtil.repSpac(request.getParameter("t_cus_address"));
	paraStr[15]=WtcUtil.repSpac(request.getParameter("s_idtype"));
	paraStr[16]=WtcUtil.repSpac(request.getParameter("t_idno"));           //����֤��
	paraStr[17]=WtcUtil.repSpac(request.getParameter("t_id_address"));
	paraStr[18]=WtcUtil.repSpac(request.getParameter("t_id_valid"));       //֤����Ч��
    if(paraStr[18].equals(" "))
	{	  
/*
        *��������
	  int toy=Integer.parseInt(new SimpleDateFormat("yyyy", Locale.getDefault()).format(new Date())); 
	  int tomd=Integer.parseInt(new SimpleDateFormat("MMdd", Locale.getDefault()).format(new Date())); 
	  paraStr[18]=String.valueOf(toy+10)+String.valueOf(tomd);
*/
		Calendar cc = Calendar.getInstance();
                cc.setTime(new Date());
                cc.add(Calendar.YEAR, 10);
                Date _tempDate = cc.getTime();
                paraStr[18] = new SimpleDateFormat("yyyyMMdd", Locale.getDefault()).format(_tempDate);
 	}
	paraStr[19]=WtcUtil.repSpac(request.getParameter("t_comm_name"));
	paraStr[20]=WtcUtil.repSpac(request.getParameter("t_comm_phone"));
	paraStr[21]=WtcUtil.repSpac(request.getParameter("t_comm_address"));

 	paraStr[22]=WtcUtil.repSpac(request.getParameter("t_comm_postcode"));
	paraStr[23]=WtcUtil.repSpac(request.getParameter("t_comm_comm"));
	paraStr[24]=WtcUtil.repSpac(request.getParameter("t_comm_fax"));
	paraStr[25]=WtcUtil.repSpac(request.getParameter("t_comm_email"));
	paraStr[26]=WtcUtil.repSpac(request.getParameter("s_cus_sex"));
	paraStr[27]=WtcUtil.repSpac(request.getParameter("t_birth"));         //��������
	if(paraStr[27].equals(" "))
	{
	  if(paraStr[16].trim().length()==15 && paraStr[15].equals("0")) 
		paraStr[27]="19"+paraStr[16].substring(6,8)+paraStr[16].substring(8,12);
	  else if(paraStr[16].trim().length()==18 && paraStr[15].equals("0"))
        paraStr[27]=paraStr[16].substring(6,10)+paraStr[16].substring(10,14);
	  else
        paraStr[27]="19491001"; 
	}
	paraStr[28]=WtcUtil.repSpac(request.getParameter("s_busi_type"));
	paraStr[29]=WtcUtil.repSpac(request.getParameter("s_edu"));
    paraStr[30]=WtcUtil.repSpac(request.getParameter("t_cus_love"));
	paraStr[31]=WtcUtil.repSpac(request.getParameter("t_cus_habit"));
 	paraStr[32]=WtcUtil.repSpac(request.getParameter("oriHandFee"));
  	paraStr[33]=WtcUtil.repSpac(request.getParameter("t_handFee"));
    paraStr[34]=WtcUtil.repSpac(request.getParameter("t_sys_remark"));
    paraStr[35]=WtcUtil.repSpac(request.getParameter("t_op_remark"));
	paraStr[36]=request.getRemoteAddr();		
	paraStr[37]=request.getParameter("phone_no_tosrv");
	
	/*20131216 gaopeng 2013/12/16 16:01:31 ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭������Ϣ start*/
	/*����������*/
	String gestoresName = request.getParameter("gestoresName");
	/*��������ϵ��ַ*/
	String gestoresAddr = request.getParameter("gestoresAddr");
	/*������֤������*/
	String gestoresIdType = request.getParameter("gestoresIdType");
	if(!"".equals(gestoresIdType)){
		gestoresIdType = gestoresIdType.substring(0,gestoresIdType.indexOf("|"));
	}
	/*������֤������*/
	String gestoresIccId = request.getParameter("gestoresIccId");
	System.out.println("-----------gaopeng---------gestoresName------------------------------"+gestoresName);
	System.out.println("-----------gaopeng---------gestoresAddr------------------------------"+gestoresAddr);
	System.out.println("-----------gaopeng---------gestoresIdType------------------------------"+gestoresIdType);
	System.out.println("-----------gaopeng---------gestoresIccId------------------------------"+gestoresIccId);
	paraStr[39] = gestoresName;
	paraStr[40] = gestoresAddr;
	paraStr[41] = gestoresIdType;
	paraStr[42] = gestoresIccId;
	
	paraStr[43]=WtcUtil.repSpac(request.getParameter("isDirectManageCust"))+""+isceshijt_flag;  //�Ƿ�ֱ�ܿͻ�
	paraStr[44]=WtcUtil.repSpac(request.getParameter("directManageCustNo"));//ֱ�ܿͻ�����
	paraStr[45]=WtcUtil.repSpac(request.getParameter("groupNo"));//��֯��������
	


 	/*if(Double.parseDouble(((paraStr[32].trim().equals(""))?("0"):(paraStr[32])))<0.01)
     paraStr[0]="0";
    else
	{
       SPubCallSvrImpl co=new SPubCallSvrImpl();
	   String prtSql="select to_char(sMaxSysAccept.nextval) from dual";
	   paraStr[0]=(((String[][])co.fillSelect(prtSql))[0][0]).trim();
	}*/
	String noForPrt=WtcUtil.repStr(request.getParameter("noForPrt")," ");
	
		String Tax_identi_num = WtcUtil.repSpac(request.getParameter("Tax_identi_num"));
		
		
	paraStr[38] = "0";

    //SPubCallSvrImpl im1210=new SPubCallSvrImpl();
    //String[] fg=im1210.callService("s1210Cfm", paraStr, "1", "region",region_code);
    //System.out.println("ffffffffffffffffffffffg[0]="+fg[0]);
    	String svc_name="";
		String s_wlw_flag=request.getParameter("s_wlw_flag");

    	if  (s_wlw_flag.equals("1")&&"1210".equals(opCode) )
		{
			svc_name="sWLWInterFace";
		}
		else
		{
			svc_name="s1210Cfm";
		}
    %>
    	<wtc:service name="<%=svc_name%>" routerKey="region" routerValue="<%=region_code%>" retcode="retCode1" retmsg="retMsg1" outnum="1" >
    <%
		if (s_wlw_flag.equals("1")&&"1210".equals(opCode))
		{
			String s_group_id = (String)session.getAttribute("groupId");
		%>
			<wtc:param value="<%=loginAccept%>"/>
			<wtc:param value="01"/>
			<wtc:param value="<%=opCode%>"/>
			<wtc:param value="<%=work_no%>"/>
			<wtc:param value="<%=nopass%>"/>
				
			<wtc:param value="<%=paraStr[37]%>"/>
			<wtc:param value=""/>
			<wtc:param value="<%=org_code%>"/>	
			<wtc:param value="<%=paraStr[5]%>"/>	
			<wtc:param value="<%=paraStr[6]%>"/>
					
			<wtc:param value="<%=paraStr[7]%>"/>	
			<wtc:param value="<%=paraStr[8]%>"/>	
			<wtc:param value="<%=paraStr[9]%>"/>	
			<wtc:param value="<%=paraStr[10]%>"/>	
			<wtc:param value="<%=paraStr[11]%>"/>	
				
			<wtc:param value="<%=paraStr[12]%>"/>	
			<wtc:param value="<%=paraStr[13]%>"/>	
			<wtc:param value="<%=paraStr[14]%>"/>	
			<wtc:param value="<%=paraStr[15]%>"/>	
			<wtc:param value="<%=paraStr[16]%>"/>
					
			<wtc:param value="<%=paraStr[17]%>"/>	
			<wtc:param value="<%=paraStr[18]%>"/>	
			<wtc:param value="<%=paraStr[19]%>"/>	
			<wtc:param value="<%=paraStr[20]%>"/>	
			<wtc:param value="<%=paraStr[21]%>"/>	
				
			<wtc:param value="<%=paraStr[22]%>"/>	
			<wtc:param value="<%=paraStr[23]%>"/>	
			<wtc:param value="<%=paraStr[24]%>"/>	
			<wtc:param value="<%=paraStr[25]%>"/>	
			<wtc:param value="<%=paraStr[26]%>"/>	
				
			<wtc:param value="<%=paraStr[27]%>"/>	
			<wtc:param value="<%=paraStr[28]%>"/>	
			<wtc:param value="<%=paraStr[29]%>"/>	
			<wtc:param value="<%=paraStr[30]%>"/>	
			<wtc:param value="<%=paraStr[31]%>"/>
					
			<wtc:param value="<%=s_group_id%>"/>	
			<wtc:param value="<%=in_ChanceId%>"/>	
			<wtc:param value="<%=wa_no%>"/>	
			<wtc:param value="<%=paraStr[32]%>"/>	
			<wtc:param value="<%=paraStr[33]%>"/>
				
			<wtc:param value="<%=paraStr[34]%>"/>
			<wtc:param value="<%=paraStr[35]%>"/>
			<wtc:param value="<%=paraStr[36]%>"/>
		<%
		}
		else
		{
    	%>
		<wtc:param value="<%=paraStr[0]%>"/>
		<wtc:param value="<%=paraStr[1]%>"/> 
		<wtc:param value="<%=paraStr[2]%>"/>
		<wtc:param value="<%=paraStr[3]%>"/>
		<wtc:param value="<%=paraStr[4]%>"/>
		<wtc:param value="<%=paraStr[5]%>"/> 
		<wtc:param value="<%=paraStr[6]%>"/>
		<wtc:param value="<%=paraStr[7]%>"/>	
		<wtc:param value="<%=paraStr[8]%>"/>
		<wtc:param value="<%=paraStr[9]%>"/> 
		<wtc:param value="<%=paraStr[10]%>"/>
		<wtc:param value="<%=paraStr[11]%>"/> 
		<wtc:param value="<%=paraStr[12]%>"/>
		<wtc:param value="<%=paraStr[13]%>"/>
		<wtc:param value="<%=paraStr[14]%>"/>
		<wtc:param value="<%=paraStr[15]%>"/> 
		<wtc:param value="<%=paraStr[16]%>"/>
		<wtc:param value="<%=paraStr[17]%>"/>	
		<wtc:param value="<%=paraStr[18]%>"/>
		<wtc:param value="<%=paraStr[19]%>"/> 
		<wtc:param value="<%=paraStr[20]%>"/>
		<wtc:param value="<%=paraStr[21]%>"/> 
		<wtc:param value="<%=paraStr[22]%>"/>
		<wtc:param value="<%=paraStr[23]%>"/>
		<wtc:param value="<%=paraStr[24]%>"/>
		<wtc:param value="<%=paraStr[25]%>"/> 
		<wtc:param value="<%=paraStr[26]%>"/>
		<wtc:param value="<%=paraStr[27]%>"/>	
		<wtc:param value="<%=paraStr[28]%>"/>
		<wtc:param value="<%=paraStr[29]%>"/>
		<wtc:param value="<%=paraStr[30]%>"/>
		<wtc:param value="<%=paraStr[31]%>"/> 
		<wtc:param value="<%=paraStr[32]%>"/>
		<wtc:param value="<%=paraStr[33]%>"/>
		<wtc:param value="<%=paraStr[34]%>"/>
		<wtc:param value="<%=paraStr[35]%>"/> 
		<wtc:param value="<%=paraStr[36]%>"/>
		<wtc:param value="<%=paraStr[37]%>"/>	
		<wtc:param value="<%=paraStr[38]%>"/>	
		<wtc:param value="<%=in_ChanceId%>"/>	
		<wtc:param value="<%=wa_no%>"/>	
		<wtc:param value="<%=t_add_notess%>"/>
			
    <wtc:param value="<%=paraStr[39]%>"/>
  	<wtc:param value="<%=paraStr[41]%>"/>
  	<wtc:param value="<%=paraStr[42]%>"/>
  	<wtc:param value="<%=paraStr[40]%>"/>
    
		<%
			if("g049".equals(opCode)){
		%>
				<wtc:param value="<%=paraStr[43]%>"/>
				<wtc:param value="<%=paraStr[44]%>"/>
				<wtc:param value="<%=paraStr[45]%>"/>
				<wtc:param value="<%=Tax_identi_num%>"/>
				
		<%
			}
		%>
		<%
		}
		%>
		</wtc:service>
		<wtc:array id="s1210CfmArr" scope="end"/>
<%		

if (!s_wlw_flag.equals("1"))
{

String iOpCode = 		"1210";
String iLoginNo = 		"";
String iLoginPwd = 		"";
String iPhoneNo = 		request.getParameter("asCustPhone");	
String iUserPwd = 		"";
String inOpNote = 		"";
String iBookingId = 	request.getParameter("booking_id");
String booking_url = "/npage/public/pubCfmBookingInfo.jsp?iOpCode="+iOpCode
	+"&iLoginNo="+iLoginNo
	+"&iLoginPwd="+iLoginPwd
	+"&iPhoneNo="+iPhoneNo
	+"&iUserPwd="+iUserPwd
	+"&inOpNote"+inOpNote
	+"&iLoginAccept="+loginAccept
	+"&iBookingId="+iBookingId;		
System.out.println("booking_url="+booking_url);
%>
<jsp:include page="<%=booking_url%>" flush="true" />
<%
System.out.println("%%%%%%%����ԤԼ�������%%%%%%%%"); 

System.out.println("s1210CfmArr[0][0]="+s1210CfmArr[0][0]);

		String s1210LoginAccept = s1210CfmArr.length>0?s1210CfmArr[0][0]:"";	
		retCode = retCode1==""?retCode:retCode1;
		retMsg = retMsg1;

	String url = "/npage/contact/onceCnttInfo.jsp?opCode="+opCode+"&retCodeForCntt="+retCode1+"&retMsgForCntt="+retMsg1+"&opName="+opName+"&workNo="+work_no+"&loginAccept="+loginAccept+"&pageActivePhone="+userPhone+"&opBeginTime="+opBeginTime+"&contactId="+cus_id+"&contactType=cust";
    if(Integer.parseInt(retCode) == 0)
    {
		String statisLoginAccept = loginAccept; /*��ˮ*/
		String statisOpCode="1210";
		String statisPhoneNo="";	
		String statisIdNo="";	
		String statisCustId=request.getParameter("cus_id");	

		String statisUrl = "/npage/public/pubCustSatisIn.jsp"
			+"?statisLoginAccept="+statisLoginAccept
			+"&statisOpCode="+statisOpCode
			+"&statisPhoneNo="+statisPhoneNo
			+"&statisIdNo="+statisIdNo	
			+"&statisCustId="+statisCustId;	
    	System.out.println("@zhangyan~~~~statisLoginAccept="+statisLoginAccept);
    	System.out.println("@zhangyan~~~~statisOpCode="+statisOpCode);
    	System.out.println("@zhangyan~~~~statisPhoneNo="+statisPhoneNo);
    	System.out.println("@zhangyan~~~~statisIdNo="+statisIdNo);
    	System.out.println("@zhangyan~~~~statisCustId="+statisCustId);
    	System.out.println("@zhangyan~~~~statisUrl="+statisUrl);
		%>
		<jsp:include page="<%=statisUrl%>" flush="true" />
		<%   	
    	
 	  if(Double.parseDouble(((paraStr[32].trim().equals(""))?("0"):(paraStr[32])))<0.01)
	  {
	  
	  
%>
        <script>
	     rdShowMessageDialog("�ͻ�<%=paraStr[8]%>(<%=paraStr[4]%>)�������ѱ��ɹ��޸ģ�",2);
         location="s1210Login.jsp?activePhone=<%=userPhone%>&opCode=<%=opCode%>&opName=<%=opName%>";
	    </script>
<%
	  }
      else
	  {
%>
        <script>
	     rdShowMessageDialog("�ͻ�<%=paraStr[8]%>(<%=paraStr[4]%>)�������ѱ��ɹ��޸ģ����潫��ӡ��Ʊ��",2);
 		 var infoStr="";

	     infoStr+="<%=paraStr[15]%>"+"|";
         infoStr+='<%=new java.text.SimpleDateFormat("yyyy", Locale.getDefault()).format(new java.util.Date())%>'+"|";
	     infoStr+='<%=new java.text.SimpleDateFormat("MM", Locale.getDefault()).format(new java.util.Date())%>'+"|";
	     infoStr+='<%=new java.text.SimpleDateFormat("dd", Locale.getDefault()).format(new java.util.Date())%>'+"|";
	     infoStr+="<%=noForPrt%>"+"|";
	     infoStr+=" "+"|";
	     infoStr+="<%=paraStr[8]%>"+"|";
	     infoStr+="<%=paraStr[13]%>"+"|";
		 infoStr+="�ֽ�"+"|";
		 infoStr+="<%=paraStr[32]%>"+"|";
	     infoStr+="<%=opName%>��*�����ѣ�"+"<%=paraStr[32]%>"+"*��ˮ�ţ�"+"<%=s1210LoginAccept%>"+"|";
		 location="chkPrint.jsp?retInfo="+infoStr+"&dirtPage=s1210Login.jsp?activePhone=<%=userPhone%>&opCode=<%=opCode%>&opName=<%=opName%>";
	    </script>
<%
	  }
   }
   else
   {
%>
     <script>
	   rdShowMessageDialog('����<%=retCode%>��'+'<%=retMsg%>�������²�����',0);
       location="s1210Login.jsp?activePhone=<%=userPhone%>&opCode=<%=opCode%>&opName=<%=opName%>";
	 </script>
<%
   }
%>
<jsp:include page="<%=url%>" flush="true" />
<%
}
else
{
	if (retCode1.equals("000000"))
	{
	
		if("g049".equals(opCode)){
		%>
	     <script>
		   	 rdShowMessageDialog('�޸ĳɹ�',2);
	       location="s1210Login.jsp?activePhone=<%=userPhone%>&opCode=<%=opCode%>&opName=<%=opName%>";
		 </script>	
		<%
		}else{
		%>
	     <script>
		   	 rdShowMessageDialog('�������û�������Ϣ�Ѿ����ͼ��Ź�˾������ͨ�������Ϊ������ҵ��',2);
	       location="s1210Login.jsp?activePhone=<%=userPhone%>&opCode=<%=opCode%>&opName=<%=opName%>";
		 </script>	
		<%
		}
	}
	else
	{
	
		if("g049".equals(opCode)){
		%>
	     <script>
		   rdShowMessageDialog('�޸�ʧ�ܣ�<%=retCode1%>��'+'<%=retMsg1%>',0);
	       location="s1210Login.jsp?activePhone=<%=userPhone%>&opCode=<%=opCode%>&opName=<%=opName%>";
		 </script>	
		<%			
		}else{
		%>
	     <script>
		   rdShowMessageDialog('�������û�������Ϣ����ʧ�ܣ�<%=retCode1%>��'+'<%=retMsg1%>�������²�����',0);
	       location="s1210Login.jsp?activePhone=<%=userPhone%>&opCode=<%=opCode%>&opName=<%=opName%>";
		 </script>	
		<%	
		}
	}
}

%>