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
<%@ page import="java.util.*"%>
<%@ page import="com.sitech.boss.pub.util.Encrypt"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
String opCode = (String)request.getParameter("vopcode");
String opName = (String)request.getParameter("vopname");
if((opCode==null || "".equals(opCode)) || (opCode!="g049" && !"g049".equals(opCode)))
{
	opCode="1210";
	opName="�ͻ����ϱ��";
}
%>

<%
    /* add by qidp @ 2009-08-13 for ���϶˵������� . */
    String in_ChanceId = request.getParameter("in_ChanceId");
    String wa_no = request.getParameter("wa_no");
    /* end by qidp @ 2009-08-13 for ���϶˵������� . */
%>
<%
request.setCharacterEncoding("GBK");
%>
 <html xmlns="http://www.w3.org/1999/xhtml"> 

    <head>
        <title>�ͻ����ϱ��</title>
        <%
        //SPubCallSvrImpl co=new SPubCallSvrImpl();
        ArrayList arrSession = (ArrayList)session.getAttribute("allArr");
        String[][] baseInfoSession = (String[][])arrSession.get(0);
        String work_no = (String)session.getAttribute("workNo");
        System.out.println("work_no="+work_no);
        String loginName = baseInfoSession[0][3];
        //System.out.println("loginName="+loginName);
        String org_code = (String)session.getAttribute("orgCode");
        System.out.println("org_code="+org_code);
        //String[][] temfavStr=(String[][])arrSession.get(3);
        String[][] temfavStr = (String[][])session.getAttribute("favInfo");
        String booking_id = request.getParameter("booking_id");
        String[] favStr=new String[temfavStr.length];
        for(int i=0;i<favStr.length;i++)
        favStr[i]=temfavStr[i][0].trim();
		 boolean hfrf=false;
	//2011/6/23 wanghfa���� ������Ȩ������ start
    boolean pwrf=false;
	String pubOpCode = opCode;
	String pubWorkNo = work_no;
	String regCode = (String)session.getAttribute("regCode");
	String dNopass = (String)session.getAttribute("password");
	
	String gestoresName = "";
	String gestoresAddr = "";
	String gestoresIccId = "";
	String gestoresIdType = "";
	
	String accountType =  (String)session.getAttribute("accountType")==null?"":(String)session.getAttribute("accountType");//1 ΪӪҵ���� 2 Ϊ�ͷ�����
	/*gaopeng 2014/01/08 9:20:10 ���ڹ��ֹ�˾�����Ż�ģ����֤���ܵ���ʾ ��ת�����Ĳ���������У��*/
  String pwrfNeed = WtcUtil.repNull(request.getParameter("pwrfNeed"));
 
  	

%>
	<%@ include file="/npage/public/pubCheckPwdPower.jsp" %>
<%
	System.out.println("====wanghfa====s1210Main.jsp==== pwrf = " + pwrf);
	
	 /*gaopeng 2014/01/08 9:20:10 ���ڹ��ֹ�˾�����Ż�ģ����֤���ܵ���ʾ ��ת�����Ĳ���������У�� ���������/npage/public/pubCheckPwdPower.jsp ֮��*/
  if(pwrfNeed != null && !"".equals(pwrfNeed)){
  System.out.println("gaopengSeeLog++++==============pwrfNeed:"+pwrfNeed);
  	if("N".equals(pwrfNeed)){
  		pwrf=true;
  	}
 	}
  System.out.println("gaopengSeeLog++++==============pwrf:"+pwrf);	
	//2011/6/23 wanghfa���� ������Ȩ������ end


        //String phoneNo = request.getParameter("phoneNo");
        String op_code = (String)request.getParameter("vopcode");;
        String opCodeUp = request.getParameter("opCode");//��ȡ��һҳ�� opcode 
        
        //ArrayList retArray = new ArrayList();
        //String[][] retStr = new String[][]{};

        //---------------�����ύҳ�������������-----------------------------
        String ReqPageName=request.getParameter("ReqPageName");
        String cus_id=WtcUtil.repNull(request.getParameter("cus_id"));
        String phone_no_tosrv=WtcUtil.repStr(request.getParameter("phone_no"),"0");
        String qry_cond = null;
        if(cus_id.equals(""))
        {  
        response.sendRedirect("s1210Login.jsp?ReqPageName=s1210Main&retMsg=1&opCode=1210&opName=�ͻ����ϱ�� ");
        }
        String phone_no="";
        if(ReqPageName.equals("s1210Login"))
        {
        	qry_cond=request.getParameter("qry_cond");
        if(qry_cond.equals("2"))        //�ֻ������ѯ
             phone_no=request.getParameter("phone_no");
        else if(qry_cond.equals("0") || qry_cond.equals("1"))   //�ͻ�ID��ѯ
        {
        String sq2="select phone_no from dcustmsg where cust_id="+cus_id+" and substr(run_code,2,1)<'a' and rownum<2";
        //retArray = co.sPubSelect("1",sq2);
		%>
		<wtc:pubselect name="sPubSelect" outnum="1">
			<wtc:sql>select phone_no from dcustmsg where cust_id='?' and substr(run_code,2,1)<'a' and rownum<2</wtc:sql>
			<wtc:param value="<%=cus_id%>"/>
		</wtc:pubselect>
		<wtc:array id="retStr" scope="end"/>
		<%

        
        //retStr=(String[][])retArray.get(0);
        if(retStr==null ||retStr.length==0)
	        phone_no=" ";
	      else
	        phone_no=retStr[0][0];

        }
        }
        //------------------�������------------------------------------------

        //S1210Impl im=new S1210Impl();
        System.out.println("cus_id="+cus_id);
        System.out.println("op_code="+op_code);
        System.out.println("org_code="+org_code);
        //ArrayList custDoc=im.getCustDoc(cus_id,op_code,"region",org_code.substring(0,2));
        
        %>

        <%  
		ArrayList custDoc;
		//String sql1 = "select a.CUST_ID,a.REGION_CODE,a.DISTRICT_CODE,a.TOWN_CODE,a.CUST_NAME,a.CUST_PASSWD,a.CUST_STATUS,a.OWNER_GRADE,a.OWNER_TYPE,a.CUST_ADDRESS,a.ID_TYPE,a.ID_ICCID,a.ID_ADDRESS,to_char(a.ID_VALIDDATE,'YYYYMMDD'),a.CONTACT_PERSON,a.CONTACT_PHONE,a.CONTACT_ADDRESS,a.CONTACT_POST,a.CONTACT_MAILADDRESS,a.CONTACT_FAX,a.CONTACT_EMAILL,c.region_name from dcustdoc a,sRegionCode c where a.region_code=c.region_code and a.cust_id='?'";
		//String sql1111 = "select a.create_note from dcustdoc a,sRegionCode c where a.region_code=c.region_code and a.cust_id='?'";
		String yonghubeizhu="";
		String v_isDirectManageCust = "0";
		String v_directManageCustNo = "";
		String v_istestgrps = "0";
		String v_groupNo = "";
		String v_netGroup = "";
		String v_groupCust = "";
		/* update ȥ��ʵ��ʹ���������Ϣ for ���ڿ��������ն�CRMģʽAPP�ĺ� - ������@2015/3/27	
		String v_realUserName = "";
		String v_realUserIccId = "";
		String v_realUserAddr = "";
		*/
		
		String old_idtype = "";
		
		String Tax_identi_num = "";
		%>
	  
	<wtc:service name="sCust1210Qry" routerKey="region" routerValue="<%=regCode%>" retcode="retCode1" retmsg="retMsg1" outnum="33" >
    <wtc:param value="0"/>
    <wtc:param value="01"/>
    <wtc:param value="<%=opCode%>"/>
    <wtc:param value="<%=work_no%>"/>	
    <wtc:param value="<%=dNopass%>"/>		
    <wtc:param value=""/>	
    <wtc:param value=""/>
    <wtc:param value="<%=cus_id%>"/>
  </wtc:service>
  <wtc:array id="result1" scope="end"/>
  	
		
		<%
		
	for(int iii=0;iii<result1.length;iii++){
		for(int jjj=0;jjj<result1[iii].length;jjj++){
			System.out.println("----hejwa-----------------result1["+iii+"]["+jjj+"]=-----------------"+result1[iii][jjj]);
		}
	}		
		
		if (result1.length == 0){
		    custDoc = null;
		}else{
			
			Tax_identi_num = result1[0][32];
			old_idtype = result1[0][10];
			
			
			custDoc = new ArrayList();
			for (int i = 0; i < result1[0].length; i++)
  			if(i != 22 && i!= 23 && i!= 24 && i != 25 && i != 26 && i != 27 && i != 28 && i != 29 && i != 30 && i != 31&& i != 32){
  			  custDoc.add(result1[0][i]);
  			}else{
  				if(i == 22){
  					yonghubeizhu=result1[0][22].trim();//�ͻ���ע
  				}else if(i == 23){
  					v_isDirectManageCust = result1[0][23].trim();//�Ƿ�ֱ�ܿͻ�
  				}else if(i == 24){
  					v_directManageCustNo = result1[0][24].trim();//ֱ�ܿͻ�����
  				}else if(i == 25){
  					v_groupNo = result1[0][25].trim();//��֯��������
  				}else if(i == 26){
  					v_netGroup = result1[0][26].trim();//ȫ�����ű�ʶ�� 0�� 1��
  				}else if(i == 27){ //27 
  					v_groupCust = result1[0][27].trim(); //1Ϊ��ͨ�ͻ���0Ϊ���ſͻ�
  				}else if(i == 31){ //31 
  					v_istestgrps = result1[0][31]; 
  					if(v_istestgrps!=null) {
  						v_istestgrps=v_istestgrps.trim();
  					}
  				}
  				/* update ȥ��ʵ��ʹ���������Ϣ for ���ڿ��������ն�CRMģʽAPP�ĺ� - ������@2015/3/27	
  				else if(i == 28){ //ʵ��ʹ��������֤�š���������ַ
  					v_realUserIccId = result1[0][28].trim(); 
  				}else if(i == 29){
  					v_realUserName = result1[0][29].trim(); 
  				}else if(i == 30){
  					v_realUserAddr = result1[0][30].trim(); 
  				}
  				*/
  				
  			}
				
            String sql2 = "select hand_fee ,trim(favour_code) from snewFunctionFee where region_code='?' and function_code='?'";
            %>
            	<wtc:pubselect name="sPubSelect" routerKey="phone" routerValue="<%=phone_no%>" outnum="2">
        <wtc:sql><%=sql2%></wtc:sql>
        <wtc:param value="<%=(String)custDoc.get(1)%>"/>
            <wtc:param value="<%=op_code%>"/>
	</wtc:pubselect>
	<wtc:array id="result2" scope="end"/>
            <%
			if (result2.length == 0)
			{
				custDoc.add("");
				custDoc.add("");
			} else
			{
				custDoc.add(result2[0][0]);
				custDoc.add(result2[0][1]);
			}
			
			String sql3 = "select CUST_SEX,to_char(BIRTHDAY,'YYYYMMDD'),trim(PROFESSION_ID),trim(EDU_LEVEL),trim(CUST_LOVE),trim(CUST_HABIT) from dcustdocinadd where cust_id='?'";
%>
<wtc:pubselect name="sPubSelect" routerKey="phone" routerValue="<%=phone_no%>" outnum="6">
        <wtc:sql><%=sql3%></wtc:sql>
            <wtc:param value="<%=cus_id%>"/>
	</wtc:pubselect>
	<wtc:array id="result3" scope="end"/>
<%
			if (result3.length == 0)
			{
				for (int i = 0; i < 6; i++)
					custDoc.add("");//25 26 27 28 29 30 

			} else
			{
				for (int i = 0; i < result3[0].length; i++)
					custDoc.add(result3[0][i]);

			}
    
    }
    
    %>

        <%
        if(custDoc==null)
        {
        response.sendRedirect("s1210Login.jsp?ReqPageName=s1210Main&retMsg=2");
        }
        String init_region_code=(String)custDoc.get(1);
        
                System.out.println("init_region_code="+init_region_code);
        
        //String[] twoFlag=im.s1210Index(cus_id,"region",init_region_code);
        
        %>
        
        <%
		String[] twoFlag = new String[2];
		twoFlag[0] = "0";
		twoFlag[1] = "SUCCESS!";
		String fStr[][] = new String[0][];
		String sq1 = "select trim(attr_code) from dcustMsg where cust_id='?' and substr(run_code,2,1)<'a' and rownum<2";
		String temFlag = "";
		%>

<wtc:pubselect name="spubqry32" retcode="err_code" retmsg="err_message" routerKey="region" routerValue="<%=init_region_code%>" outnum="2">
        <wtc:sql><%=sq1%></wtc:sql>
            <wtc:param value="<%=cus_id%>"/>
	</wtc:pubselect>
    <wtc:array id="sPubQry32Arr" scope="end"/>
<%
			twoFlag[0] = err_code;
			twoFlag[1] = err_message;
			if (Integer.parseInt(err_code) == 0)
				fStr = sPubQry32Arr;
			if (fStr[0][1] == null)
				temFlag = "00000";
			else
				temFlag = fStr[0][1];
			if (!temFlag.equals(""))
			{
				String bigFlag = temFlag.substring(2, 4);
				String grpFlag = temFlag.substring(4, 5);
				System.out.println("bigFlag="+bigFlag);
				String sq2 = "select trim(card_name) from sBigCardCode where card_type='?'";
				String sq3 = "select trim(grp_name) from sGrpBigFlag where grp_flag='?'";
				System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
				System.out.println("bigFlag="+bigFlag);
				System.out.println("grpFlag="+grpFlag);
			
%>
<wtc:pubselect name="sPubMultiSel" retcode="err_code2" retmsg="err_message2" routerKey="region" routerValue="<%=init_region_code%>" outnum="2">
        <wtc:sql><%=sq2%></wtc:sql>
        <wtc:param value="<%=bigFlag%>"/>
</wtc:pubselect>
<wtc:array id="sPubMultiSelArr1" scope="end"/>
<%
System.out.println("*********************************err_message2="+err_message2);
                twoFlag[0] = err_code2;
				if (Integer.parseInt(err_code2) == 0)
				{
					twoFlag[0] = sPubMultiSelArr1[0][0];
				}
%>
<wtc:pubselect name="sPubMultiSel" retcode="err_code3" retmsg="err_message3" routerKey="region" routerValue="<%=init_region_code%>" outnum="2">
        <wtc:sql><%=sq3%></wtc:sql>
        <wtc:param value="<%=grpFlag%>"/>
</wtc:pubselect>
<wtc:array id="sPubMultiSelArr2" scope="end"/>
<%
     System.out.println("*********************************err_message3="+err_message3);
				twoFlag[1] = err_message3;
				if (Integer.parseInt(err_code3) == 0)
				{
					twoFlag[1] = sPubMultiSelArr2[0][0];
				}
			}
        %>
        <%
        
        if(twoFlag==null || twoFlag.length==0)
        {
        response.sendRedirect("s1210Login.jsp?ReqPageName=s1210Main&retMsg=10");
        }
        if(request.getParameter("ReqPageName").equals("s1210Login"))
        {
          String passTrans=WtcUtil.repNull(request.getParameter("cus_pass"));
	      if(!pwrf)
		  {
		  System.out.println("gaopengSeeLog++++22==============pwrf:"+pwrf);	
		     String passFromPage=Encrypt.encrypt(passTrans);
//2010-8-20 15:51 wanghfa�޸� ������֤�޸� start
%>
		<script language=javascript>
			var checkPwd_Packet = new AJAXPacket("/npage/public/pubCheckPwd.jsp","���ڽ�������У�飬���Ժ�......");
			checkPwd_Packet.data.add("custType","02");				//01:�ֻ����� 02 �ͻ�����У�� 03�ʻ�����У��
			checkPwd_Packet.data.add("phoneNo","<%=(String)custDoc.get(0)%>");	//�ƶ�����,�ͻ�id,�ʻ�id
			checkPwd_Packet.data.add("custPaswd","<%=passFromPage%>");//�û�/�ͻ�/�ʻ�����
			checkPwd_Packet.data.add("idType","en");				//en ����Ϊ���ģ�������� ����Ϊ����
			checkPwd_Packet.data.add("idNum","");					//����
			checkPwd_Packet.data.add("loginNo","<%=work_no%>");		//����
			core.ajax.sendPacket(checkPwd_Packet, doCheckPwd);
			checkPwd_Packet=null;
			
			function doCheckPwd(packet) {
				var retResult = packet.data.findValueByName("retResult");
				var msg = packet.data.findValueByName("msg");
				if (retResult != "000000") {
					rdShowMessageDialog(msg);
					if("<%=opCodeUp%>" == "1441"){
						window.location="<%=request.getContextPath()%>/npage/s5061/s1441.jsp?activePhone=<%=phone_no_tosrv%>";
					}else{
						  window.location="s1210Login.jsp?opCode=1210&opName=�ͻ����ϱ��"; 
				    }
				}
			}
			

		</script>
<%
/*
		     if(0==Encrypt.checkpwd2(((String)custDoc.get(5)).trim(),passFromPage))		   
				response.sendRedirect("s1210Login.jsp?ReqPageName=s1210Main&retMsg=3");
*/
//2010-8-20 15:51 wanghfa�޸� ������֤�޸� end
		  }
        }
        if(((String)custDoc.get(22)).trim().equals("") || ((String)custDoc.get(22)).trim().equals("0") || Double.parseDouble(((String)(custDoc.get(22))))==0)
        {
        hfrf=true;
        }
    else
        {
        if(!WtcUtil.haveStr(favStr,((String)custDoc.get(23)).trim()))
        {
        hfrf=true;
        }
        }
        //------------------------��ˮ---------

        //String paraStr[]=new String[1];
        //comImpl co1=new comImpl();
       // String prtSql="select to_char(sMaxSysAccept.nextval) from dual";
       
       String sLoginAccept = WtcUtil.repNull(request.getParameter("accept"));
       boolean printFlag = true;
       if ("".equals(sLoginAccept)){
 %>       
        <wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="phone"  routerValue="<%=phone_no%>" id="loginAccept"/>
       		 
 <%       
 					sLoginAccept = loginAccept;
 					printFlag = false;
 			 }
        //paraStr[0]=(((String[][])co1.fillSelect(prtSql))[0][0]).trim();
        System.out.println("sLoginAccept=" +sLoginAccept);


        //------------------����������----------------------------------------
%>

<wtc:pubselect name="sPubSelect" outnum="21">
<wtc:sql>select trim(district_name)||'#'||trim(district_code) from sDisCode where region_code='?' order by district_code
</wtc:sql>
          <wtc:param value="<%=init_region_code%>"/> 
</wtc:pubselect>
<wtc:array id="sub_metaData" scope="end"/>
  	
		
<%
        String init_city_code=WtcUtil.getOneTok(sub_metaData[0][0],"#",2);
        for(int i=0;i<sub_metaData.length;i++)
        {
        if((WtcUtil.getOneTok(sub_metaData[i][0],"#",2)).equals(((String)custDoc.get(2)).trim()))
        {
        init_city_code=(WtcUtil.getOneTok(sub_metaData[i][0],"#",2));
        break;
        }
        }
 %>
<wtc:pubselect name="sPubSelect" outnum="55">
    <wtc:sql>select trim(town_name)||'#'||trim(town_code) from sTownCode where region_code='?' and district_code='?'</wtc:sql>
    <wtc:param value="<%=init_region_code%>"/>
    <wtc:param value="<%=init_city_code%>"/>
</wtc:pubselect>
<wtc:array id="tri_metaData" scope="end"/>
<% 
	/*gaopeng 2013/12/17 15:43:00  ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���÷��񷵻� ��������Ϣ*/
 %>
<wtc:service name="sCustOprMsgQry" routerKey="region" routerValue="<%=regCode%>" retcode="retCodeC1" retmsg="retMsgC1" outnum="4" >
    <wtc:param value="<%=sLoginAccept%>"/>
    <wtc:param value="01"/>
    <wtc:param value="<%=opCode%>"/>
    <wtc:param value="<%=work_no%>"/>	
    <wtc:param value="<%=dNopass%>"/>		
    <wtc:param value=""/>	
    <wtc:param value=""/>
    <wtc:param value="��ѯ�ͻ���������Ϣ"/>
    <wtc:param value="<%=cus_id%>"/>
  </wtc:service>
  <wtc:array id="resultC1" scope="end"/>
  	
<%
	
	if("000000".equals(retCodeC1)){
		System.out.println("gaopengSeeLog=================����sCustOprMsgQry����ɹ���");
		
		gestoresName = resultC1[0][0];    
		gestoresAddr = resultC1[0][3];    
		gestoresIccId = resultC1[0][2];   
	  gestoresIdType = resultC1[0][1]; 
	  
	  System.out.println("gaopengSeeLog=================gestoresName="+gestoresName);
	  System.out.println("gaopengSeeLog=================gestoresAddr="+gestoresAddr);
	  System.out.println("gaopengSeeLog=================gestoresIccId="+gestoresIccId);
	  System.out.println("gaopengSeeLog=================gestoresIdType="+gestoresIdType);
	  
	}else{
		System.out.println("gaopengSeeLog=================����sCustOprMsgQry����ʧ�ܣ�");
	}
%>




<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>
<META content="MSHTML 5.00.3315.2870" name=GENERATOR>
<link rel="stylesheet" href="../../css/jl.css" type="text/css">
<script language=javascript>
    //core.loadUnit("debug");
    //core.loadUnit("rpccore");
			$(function(){
				
					var t = $('select[name="s_cus_type"]').find('option');
			<%if (opCode.equals("1210")){%>
          t.each(function(){
          		if ($(this).attr('value') != '01'){
          				$(this).remove();
          		}
          });
			<%} else if(opCode.equals("g049")){%>
          t.each(function(){
          		if ($(this).attr('value') == '01' || $(this).attr('value') == '05'){
          				$(this).remove();
          		}
          });
			<%}%>
			});
		var v_printAccept = "<%=sLoginAccept%>";
    onload=function()
    {
    	
        fillSelect();
        self.status="";
        
        $("#gestoresInfo1").show();
  			$("#gestoresInfo2").show();
  			
        $("#gestoresName").val("<%=gestoresName%>");
	  		$("#gestoresAddr").val("<%=gestoresAddr%>");
	  		$("#gestoresIccId").val("<%=gestoresIccId%>");
	  		$("#gestoresIdType").val("<%=gestoresIdType%>");
	  		
	  		if($("#s_idtype").val() == "0"||$("#s_idtype").val() == "D"){
	  			if("<%=opCode%>" == "1210"){
	  				$("#t_idno").attr("class","InputGrey");
						$("#t_idno").attr("readonly","readonly");
						$("#t_cus_name").attr("class","InputGrey");
						$("#t_cus_name").attr("readonly","readonly");
						$("#t_id_address").attr("class","InputGrey");
						$("#t_id_address").attr("readonly","readonly");
						$("#t_id_valid").attr("class","InputGrey");
						$("#t_id_valid").attr("readonly","readonly");
	  			}
					$("#scan_idCard_two").css("display","");
	  			$("#scan_idCard_two222").css("display","");	
	  		}else{
	  			$("#scan_idCard_two").css("display","none");
	  			$("#scan_idCard_two222").css("display","none");	
	  		}
  		  /* update ȥ��ʵ��ʹ���������Ϣ for ���ڿ��������ն�CRMģʽAPP�ĺ� - ������@2015/3/27	
  		  if("<%=opCode%>" == "1210"){ //ֻ���1210�ͻ����ϱ�������޸ģ���g049��չʾ����
  		  	if("<%=v_groupCust%>" == "0"){ //��λ����չʾʵ��ʹ����
  		  		$("#realUserInfo1").show();
		  			$("#realUserInfo2").show();
		  			/*����������
				  	document.all.gestoresName.v_must = "1";
				  	/*�����˵�ַ
				  	document.all.gestoresAddr.v_must = "1";
				  	/*������֤������
				  	document.all.gestoresIccId.v_must = "1";
				  	/*ʵ��ʹ��������
				  	document.all.realUserName.v_must = "1";
				  	/*��ʵ��ʹ���˵�ַ
				  	document.all.realUserAddr.v_must = "1";
				  	/*ʵ��ʹ����֤������
				  	document.all.realUserIccId.v_must = "1";
  		  	}
  		  }
  		  */
		  	if("<%=v_groupCust%>" == "0"){ //��λ
	  			if("<%=gestoresIdType%>" == "0"){ //����֤
	  				$("#scan_idCard_two3").css("display","");
	  				$("#scan_idCard_two31").css("display","");
	  				$("input[name='gestoresName']").attr("class","InputGrey");
			  		$("input[name='gestoresName']").attr("readonly","readonly");
			  		$("input[name='gestoresAddr']").attr("class","InputGrey");
			  		$("input[name='gestoresAddr']").attr("readonly","readonly");
			  		$("input[name='gestoresIccId']").attr("class","InputGrey");
			  		$("input[name='gestoresIccId']").attr("readonly","readonly");
	  			}else{
	  				$("#scan_idCard_two3").css("display","none");
	  				$("#scan_idCard_two31").css("display","none");
	  			}
        }else{
        	if("<%=gestoresIdType%>" == "0"){ //����֤
	  				$("#scan_idCard_two3").css("display","");
	  				$("#scan_idCard_two31").css("display","");
	  				$("input[name='gestoresName']").attr("class","InputGrey");
			  		$("input[name='gestoresName']").attr("readonly","readonly");
			  		$("input[name='gestoresAddr']").attr("class","InputGrey");
			  		$("input[name='gestoresAddr']").attr("readonly","readonly");
			  		$("input[name='gestoresIccId']").attr("class","InputGrey");
			  		$("input[name='gestoresIccId']").attr("readonly","readonly");
	  			}else{
	  				$("#scan_idCard_two3").css("display","none");
	  				$("#scan_idCard_two31").css("display","none");
	  			}
        }
	  		
        $("select[name='gestoresIdType']").find("option").each(function(){
        	var thisVal = $(this).val();
        	if(thisVal.length > 0){
	        	if(thisVal.split("|")[0] == "<%=gestoresIdType%>"){
	        		$(this).attr("selected","selected");
	        	}
        	}
        	
        });
        var checkIdType = $("select[name='gestoresIdType']").find("option:selected").val();
		  	/*����֤����У�鷽��*/
		  	if(checkIdType.indexOf("����֤") != -1){
		  		document.all.gestoresIccId.v_type = "idcard";
		  	}else{
		  		document.all.gestoresIccId.v_type = "string";
		  	}
        //document.all.s_city.focus();
        //core.rpc.onreceive = doProcess;
        
        if("<%=opCode%>" == "g049"){
        	$("#isDirectManageCustTr1").show();
        	$("#istestgrps").show();
        	$("#isceshijt_flag").val("<%=v_istestgrps%>");
        	$("#isDirectManageCust").val("<%=v_isDirectManageCust%>");
        	$("#directManageCustNo").val("<%=v_directManageCustNo%>");
        	$("#groupNo").val("<%=v_groupNo%>");
        }
        validateGesIdTypes("����֤");
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
    
  //��ȡֱ�ܿͻ���Ϣ
  function qryDirectManageCustInfo1(obj){
  	var custName = $("#t_cus_name").val();
		if(obj.value == "1"){ //��
			var h=450;
			var w=800;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			var prop="dialogHeight:"+h+"px;dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;status:no;help:no";
			var ret=window.showModalDialog("fg049_qryDirectManageCustInfo.jsp?custName=" + custName+"&opCode=<%=opCode%>","",prop);
			if(typeof(ret) == "undefined"){
				$("#isDirectManageCust").val("0");
				$("#directManageCustNo").val("");
				//$("#groupNo").val("");
			}else if(ret!=null && ret!=""){
				$("#directManageCustNo").val(ret.split("~")[0]);
				$("#groupNo").val(ret.split("~")[2]);
			}
		}else{ //��
			$("#directManageCustNo").val("");
			$("#groupNo").val("");
		}
  }
  
  function qryDirectManageCustInfo2(obj){
  	var isDirectManageCust = $("#isDirectManageCust").val();
  	if(isDirectManageCust == "0"){ //��
  		var packet = new AJAXPacket("fg049_ajax_qryDirectManageCustInfo2.jsp","���ڻ�����ݣ����Ժ�......");
	    	packet.data.add("directManageCustNo","");
	    	packet.data.add("groupNo",obj.value);
	    	packet.data.add("institutionName","");
	    	packet.data.add("directManageCustName","");
	    	packet.data.add("opCode","<%=opCode%>");
	    	core.ajax.sendPacket(packet,doQryDirectManageCustInfo2);
	    	packet = null;
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
		idTypeVal = document.all.s_idtype.value;
	}
	if(objType == 1){
		objName = "��ϵ������";
		idTypeVal = document.all.s_idtype.value;
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
	var objValue1 = obj.value;
	objValue = $.trim(objValue);
	/*��ȡ�����ֵ�ĳ���*/
	var objValueLength = objValue.length;
	if(objValue != ""&& "<%=work_no%>" != "aaa1zh" && "<%=work_no%>" != "200049"){
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
            if(objValue1.charAt(0).trim() == ""){
                rdShowMessageDialog("ֻ������Ӣ�ġ����֡����ġ����ġ����ġ����Ļ����롮���š��������һ�����ԣ����������룡");
                obj.value = "";
                
                nextFlag = false;
                return false;
              }
            var key = checkNameStr1(code); //У��
            
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
		
		if("<%=opCode%>" != "g049"){
			if(ifConnect == 0){
				if(nextFlag){
				 if(objType == 0){
				 	/*��ϵ��������ͻ����Ƹ������ı�*/
					document.all.t_comm_name.value = objValue;
					 
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
	var idTypeVal = "";
	if(objType == 0){
		objName = "֤����ַ";
		idTypeVal = document.all.s_idtype.value;
	}
	if(objType == 1){
		objName = "�ͻ���ַ";
		idTypeVal = document.all.s_idtype.value;
	}
	if(objType == 2){
		objName = "��ϵ�˵�ַ";
		idTypeVal = document.all.s_idtype.value;
	}
	if(objType == 3){
		objName = "��ϵ��ͨѶ��ַ";
		idTypeVal = document.all.s_idtype.value;
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
	
	if(objValue != ""&& "<%=work_no%>" != "aaa1zh" && "<%=work_no%>" != "200049"){
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
	if("<%=opCode%>" != "g049"){
		if(ifConnect == 0){
			if(nextFlag){
				/*֤����ַ�ı�ʱ����ֵ������ַ*/
				if(objType == 0){
				    document.all.t_cus_address.value=objValue;
				    document.all.t_comm_address.value=objValue;
				    document.all.t_comm_comm.value=objValue;
				}
				/*�ͻ���ַ�ı�ʱ����ֵ��ϵ�˵�ַ����ϵ��ͨѶ��ַ*/
				if(objType == 1){
					document.all.t_comm_address.value=objValue;
				  document.all.t_comm_comm.value=objValue;
				}
				/*��ϵ�˵�ַ�ı�ʱ����ֵ��ϵ��ͨѶ��ַ��2013/12/16 15:20:17 20131216 gaopeng ��ֵ��������ϵ��ַ����*/
				if(objType == 2){
					document.all.t_comm_comm.value=objValue;
					document.all.gestoresAddr.value=objValue;
				}
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
		idTypeVal = document.all.s_idtype.value;
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
	if(objValue != ""&& "<%=work_no%>" != "aaa1zh" && "<%=work_no%>" != "200049"){
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
		//rpc_chkX('idType','idIccid','A');
		
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
  	if(idtypeVal.indexOf("<%=gestoresIdType%>") != -1){ //ѡ���ʼ֤�����ͣ���ԭ��ʼ֤����Ϣ
			$("#gestoresName").val("<%=gestoresName%>");
			$("#gestoresAddr").val("<%=gestoresAddr%>");
			$("#gestoresIccId").val("<%=gestoresIccId%>");
		}else{
			$("input[name='gestoresName']").val("");
  		$("input[name='gestoresAddr']").val("");
  		$("input[name='gestoresIccId']").val("");	
		}
}
    //---------1------RPC��������------------------
    function doProcess(packet)
    {
        var rpc_page=packet.data.findValueByName("rpc_page");
        if(rpc_page=="chg_city")
        {
            var triListData = packet.data.findValueByName("tri_list");
            var triList=new Array(triListData.length);
            triList[0]="s_spot";
            for(i=0;i<triListData.length;i++)
            {
                  document.all(triList[i]).options.length=0;
                  document.all(triList[i]).options.length=triListData[i].length;
                  for(j=0;j<triListData[i].length;j++)
                  {
                      document.all(triList[i]).options[j].text=oneTok(triListData[i][j],"#",1);
                      document.all(triList[i]).options[j].value=oneTok(triListData[i][j],"#",2);
                  }
            }
        }
    }

    //-------2------������������----------------
    function chg_city()
    {
        var region_code = document.all.region_code.value;
        var city_code = document.all.s_city[document.all.s_city.selectedIndex].value;
        var myPacket = new AJAXPacket("chg_city.jsp","���ڻ�ù���������Ϣ�����Ժ�......");
        myPacket.data.add("region_code",region_code);
        myPacket.data.add("city_code",city_code);
        core.ajax.sendPacket(myPacket);
        myPacket=null;
    }

    //--------4---------��ʾ��ӡ�Ի���----------------
    function printCommit()
    {
    	
    	
	/*
	 *  1���޸������漰�����ˡ������˺�ʵ��ʹ���˵Ľ��棬��ϵͳ�������ƣ�����λ֤������ʱ��
	 *  ��������ʵ��ʹ���˵�֤�����벻������ͬ���������������˵�֤�����벻������ͬ��
	 */
 

	var idTypeSelect_isC = $("#s_idtype option:selected").val();//֤������ 
	//alert("idTypeSelect_isC=["+idTypeSelect_isC+"]");
	if(typeof(idTypeSelect_isC)=="undefined"){
		//�л�֤�����ͺ� selected �Ķ�ʧĬ��ȡ��һ��
		idTypeSelect_isC =  $("#idTypeSelect option:eq(0)").val();
	}
	if(
	   idTypeSelect_isC.indexOf("8")!=-1||
	   idTypeSelect_isC.indexOf("A")!=-1||
	   idTypeSelect_isC.indexOf("B")!=-1||
	   idTypeSelect_isC.indexOf("C")!=-1){
		//alert("��λ֤������");
		//��λ֤������
		if(typeof($("#gestoresIccId").val())!="undefined"&&typeof($("#responsibleIccId").val())!="undefined"){
			if($("#gestoresIccId").val().trim()!=""&&$("#responsibleIccId").val().trim()!=""){
				if($("#gestoresIccId").val().trim()==$("#responsibleIccId").val().trim()){
					rdShowMessageDialog("�����˵�֤�������������˵�֤�����벻������ͬ!",0);
					return;
				}
			}
		}
		
		if(typeof($("#gestoresIccId").val())!="undefined"&&typeof($("#realUserIccId").val())!="undefined"){
			if($("#gestoresIccId").val().trim()!=""&&$("#realUserIccId").val().trim()!=""){
				if($("#gestoresIccId").val().trim()==$("#realUserIccId").val().trim()){
					rdShowMessageDialog("�����˵�֤��������ʹ���˵�֤�����벻������ͬ!",0);
					return;
				}  		
			}
		}
		
	}   	
	
    	
 //1210 ���� ��λ ֤������ ���ܻ��� ���ڵ���һ֤5��ϵͳ����Ҫ��ĺ� hejwa 
 		if("1210"=="<%=opCode%>"){
			var old_idtype = "<%=old_idtype%>";
			if(old_idtype=="8"||old_idtype=="A"||old_idtype=="B"||old_idtype=="C"){
				if($("#s_idtype").val()!="8"&&$("#s_idtype").val()!="A"&&$("#s_idtype").val()!="B"&&$("#s_idtype").val()!="C"){
						rdShowMessageDialog("ԭ��λ֤��������֤������ֻ��ѡ��λ֤������");
						$("#s_idtype").val(old_idtype);
						return;
				}
			}else{
				if($("#s_idtype").val()=="8"||$("#s_idtype").val()=="A"||$("#s_idtype").val()=="B"||$("#s_idtype").val()=="C"){
						rdShowMessageDialog("ԭ����֤��������֤������ֻ��ѡ�����֤������");
						$("#s_idtype").val(old_idtype);
						return;
				}
			}   	
		}
		
		
    	
//alert($("#custTypeHide").val());
//alert(document.all.t_cus_address.value);
    		if(!checkElement(document.all.t_cus_address)){
    			return false;
    		}
    		if(!checkElement(document.all.t_id_address)){
    			return false;
    		}
    		//�� �Ƿ�ֱ�ܿͻ� ���и��ģ�����Ϊȫ�����ţ�����ʾ
    		if("<%=opCode%>" == "g049"){
    			if(($("#isDirectManageCust").val() != "<%=v_isDirectManageCust%>") && "<%=v_netGroup%>" == "1"){ 
    				rdShowMessageDialog("�ͻ������޸ĳɹ����뵽2037�ۼ��ſͻ���Ϣͬ���ݹ��������ֱ����Ϣ�޸�!");
    			}
    		}
    		
    	  /*2013/11/18 15:09:28 gaopeng �����ύ֮ǰ��У�� ���ڽ�һ������ʡ��֧��ϵͳʵ���Ǽǹ��ܵ�֪ͨ start*/
    		/*����У��*/
    		/*�ͻ�����*/
    		if(!checkCustNameFunc16New(document.all.t_cus_name,0,1)){
    			return false;
    		}
    		/*��ϵ������*/
    		if(!checkCustNameFunc(document.all.t_comm_name,1,1)){
					return false;
				}
				/*֤����ַ*/
				if(!checkAddrFunc(document.all.t_id_address,0,1)){
					return false;
				}
				/*�ͻ���ַ*/
				if(!checkAddrFunc(document.all.t_cus_address,1,1)){
					return false;
				}
				/*��ϵ�˵�ַ*/
				if(!checkAddrFunc(document.all.t_comm_address,2,1)){
					return false;
				}
				/*��ϵ��ͨѶ��ַ*/
				if(!checkAddrFunc(document.all.t_comm_comm,3,1)){
					return false;
				}
				/*֤������*/
				if(!checkIccIdFunc16New(document.all.t_idno,0,1)){
					return false;
				}
				
				/*gaopeng 20131216 2013/12/16 19:50:11 ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭������Ϣȷ�Ϸ���ǰУ�� start*/
					/*����������*/
					
					//����������
						if(!checkElement(document.all.gestoresName)){
							return false;
						}
						//��������ϵ��ַ
						if(!checkElement(document.all.gestoresAddr)){
							return false;
						}
						//������֤������
						if(!checkElement(document.all.gestoresIccId)){
							return false;
						}
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
				/*gaopeng 20131216 2013/12/16 19:50:11 ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭������Ϣȷ�Ϸ���ǰУ�� start*/
				/* update ȥ��ʵ��ʹ���������Ϣ for ���ڿ��������ն�CRMģʽAPP�ĺ� - ������@2015/3/27	
					if("<%=opCode%>" == "1210"){
						/*����������
						if(!checkElement(document.all.gestoresName)){
							return false;
						}
						/*��������ϵ��ַ
						if(!checkElement(document.all.gestoresAddr)){
							return false;
						}
						/*������֤������
						if(!checkElement(document.all.gestoresIccId)){
							return false;
						}
						if("<%=v_groupCust%>" == "0"){ //��λ����չʾʵ��ʹ����
							/*ʵ��ʹ��������
							if(!checkElement(document.all.realUserName)){
								return false;
							}
							/*ʵ��ʹ������ϵ��ַ
							if(!checkElement(document.all.realUserAddr)){
								return false;
							}
							/*ʵ��ʹ����֤������
							if(!checkElement(document.all.realUserIccId)){
								return false;
							}
						}						
					}
					*/
				
				/*2013/11/18 15:09:28 gaopeng �����ύ֮ǰ��У�� ���ڽ�һ������ʡ��֧��ϵͳʵ���Ǽǹ��ܵ�֪ͨ end*/
				
        getAfterPrompt();
       
        showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes");
    }

    function showPrtDlg(printType,DlgMessage,submitCfm)
    {
        if(check(frm))
        {
            if(((document.all.t_new_pass.value).trim()).length>0)
            {
                if(((document.all.t_new_pass.value).trim()).length!=6)
                {
                    rdShowMessageDialog("�¿ͻ����볤���������������룡");
                    document.all.t_new_pass.value="";
                    document.all.t_conf_pass.value="";
                    document.all.t_new_pass.focus();
                    return false;
                }
            }

            if(document.all.s_idtype.options[document.all.s_idtype.selectedIndex].value=="0")
            {
                if(!forIdCard(document.all.t_idno)) return false;
            }
            if(((document.all.t_id_valid.value).trim()).length>0)
            {
                var d= (new Date().getFullYear().toString()+(((new Date().getMonth()+1).toString().length>=2)?(new Date().getMonth()+1).toString():("0"+(new Date().getMonth()+1)))+(((new Date().getDate()).toString().length>=2)?(new Date().getDate()):("0"+(new Date().getDate()))).toString());

                if(!forDate(document.all.t_id_valid)) return false;
                
                if(!(compareDates((document.all.t_id_valid),d)==1))
                {
                    rdShowMessageDialog("֤����Ч�ڲ������ڵ�ǰʱ�䣬���������룡");
                    document.all.t_id_valid.select();
                    document.all.t_id_valid.focus();
                    return false;
                }

                if(!(compareDates((document.all.t_birth),d)==0))
                {
                    rdShowMessageDialog("�������ڲ������ڵ�ǰʱ�䣬���������룡");
                    document.all.t_birth.select();
                    document.all.t_birth.focus();
                    return false;
                }
                if(document.all.s_idtype.value=="0")
                {
                    if(!forIdCard(document.all.t_idno)) return false;
                }
            }

            document.all.t_sys_remark.value="�ͻ�"+"<%=cus_id%>"+"���ϱ��";
            if(((document.all.t_op_remark.value).trim()).length==0)
            {
                document.all.t_op_remark.value="����Ա<%=work_no%>"+"�Կͻ�"+"<%=cus_id%>"+"����<%=opName%>"
            }
            //��ʾ��ӡ�Ի���
            var h=210;
            var w=400;
            var t=screen.availHeight/2-h/2;
            var l=screen.availWidth/2-w/2;

           var pType="print";
           var billType="1";
           var sysAccept = <%=sLoginAccept%>;
           var mode_code = null;
           var fav_code = null;
           var area_code = null;
           var printStr = printInfo(printType);
						/* ningtn */
						var iccidInfoStr = $("#firstId").val() + "|" + $("#secondId").val();	
						var accInfoStr = $("#accInfoHid1").val() + "|" +$("#accInfoHid2").val()+ "|" +$("#accInfoHid3").val()+ "|" +$("#accInfoHid4").val();
						/* ningtn */
           var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no"; 
           var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_hw.jsp?DlgMsg=" + DlgMessage+ "&iccidInfo=" + iccidInfoStr + "&accInfoStr="+accInfoStr;
           var path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+sysAccept+"&phoneNo=&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
           var ret=window.showModalDialog(path,printStr,prop);

            if(typeof(ret)!="undefined")
            {
                if((ret=="confirm")&&(submitCfm == "Yes"))
                {
                    if(rdShowConfirmDialog('ȷ�ϵ��������')==1)
                    {
                        conf();
                    }
                }
                if(ret=="continueSub")
                {
                    if(rdShowConfirmDialog('ȷ��Ҫ�ύ<%=opName%>��Ϣ��')==1)
                    {
                        conf();
                    }
                }
            }
            else
                {
                    if(rdShowConfirmDialog('ȷ��Ҫ�ύ<%=opName%>��Ϣ��')==1)
                    {
                        conf();
                    }
                }
            }
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
  			  			
			    cust_info+="�ͻ�������"+document.all.t_cus_name.value+"|";
			    if("2" != <%=qry_cond%>)
			    {
			    	cust_info+="�ֻ����룺"+"����"+"|";
			    }else
			    {
			    	 cust_info+="�ֻ����룺"+document.all.noForPrt.value+"|";
			    }
  			   
					cust_info+="�û�ID��"+document.all.cus_id.value+"|";
					cust_info+="֤�����룺"+document.all.t_idno.value+"|";
					cust_info+="�ͻ���ַ��"+document.all.t_cus_address.value+"|";
					cust_info+="��ϵ��������"+document.all.t_comm_name.value+"|";
				
					opr_info+="ҵ�����ͣ�"+"<%=opName%>"+"|";
  			  opr_info+="��ˮ��"+<%=sLoginAccept%>+"|";
  			  opr_info+="�ͻ������ϣ�"+"|";
  			  opr_info+="�û����ƣ�"+document.all.t_cus_name.value+"|";
  			  opr_info+="֤�����룺"+document.all.t_idno.value+"|";
  			  opr_info+="֤����ַ��"+document.all.t_id_address.value+"|";
  			  opr_info+="��ϵ�˵绰��"+document.all.t_comm_phone.value+"|";
  			  opr_info+="��ϵ�˵�ַ��"+document.all.t_comm_address.value+"|";
  			  opr_info+="��ϵ��ͨѶ��ַ��"+document.all.t_comm_comm.value+"|";
					var note_info1="��ע��|";
					<%
					if (printFlag){
					%>
							note_info1 += '�����οͻ����ϱ����ͨ��ģ����֤�ķ�ʽ���а�������δ���߿�����ҵ�񹤵�����Ʊ��|';
							note_info1 += '���պ������ͻ������ƾ��Ҫ����й������ҹ�˾�����������أ��ɴ������ķ��������������ге���|';
					<%
					}
					%>
  			  retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
  			  retInfo=retInfo.replace(new RegExp("#","gm"),"%23"); 
  			  //alert(retInfo);
  			  return retInfo;

                }

                //--------5----------�ύ��������-------------------
                function conf()
                {
                    document.all.b_print.disabled=true;
                    document.all.b_clear.disabled=true;
                    document.all.b_back.disabled=true;
						
					document.frm.s_city_a.value = document.frm.s_city.value;
					document.frm.s_spot_a.value = document.frm.s_spot.value;
		
                    frm.action="s1210_conf.jsp";
                    frm.submit();
                }

                function canc()
                {
                    frm.submit();
                }

                //-------6--------ʵ����ר�ú���----------------
                function ChkHandFee()
                {
                    if(((document.all.oriHandFee.value).trim()).length>=1 && ((document.all.t_handFee.value).trim()).length>=1)
                    {
                        if(parseFloat(document.all.oriHandFee.value)<parseFloat(document.all.t_handFee.value))
                        {
                            rdShowMessageDialog("ʵ�������Ѳ��ܴ���ԭʼ�����ѣ�");
                            document.all.t_handFee.value=document.all.oriHandFee.value;
                            document.all.t_handFee.select();
                            document.all.t_handFee.focus();
                            return;
                        }
                    }

                    if(((document.all.oriHandFee.value).trim()).length>=1 && ((document.all.t_handFee.value).trim()).length==0)
                    {
                        document.all.t_handFee.value="0";
                    }
                }

                function getFew()
                {
                    if(window.event.keyCode==13)
                    {
                        var fee=document.all.t_handFee;
                        var fact=document.all.t_factFee;
                        var few=document.all.t_fewFee;
                        if(((fact.value).trim()).length==0)
                        {
                            rdShowMessageDialog("ʵ�ս���Ϊ�գ�");
                            fact.value="";
                            fact.focus();
                            return;
                        }
                        if(parseFloat(fact.value)<parseFloat(fee.value))
                        {
                            rdShowMessageDialog("ʵ�ս��㣡");
                            fact.value="";
                            fact.focus();
                            return;
                        }

                        var tem1=((parseFloat(fact.value)-parseFloat(fee.value))*100+0.5).toString();
                        var tem2=tem1;
                        if(tem1.indexOf(".")!=-1) tem2=tem1.substring(0,tem1.indexOf("."));
                        few.value=(tem2/100).toString();
                        few.focus();
                    }
                }
                
                /*begin diling update for �������ӿ�������ͻ��Ǽ���Ϣ��֤���ܵĺ�@2013/9/22*/
             
                  function checkNameStr(code){
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
                  function checkNameStr1(code){
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
	                    /*add 20170527����֤����Ϊ���������У��ͻ������м����Ϊ�ո�*/
	            	    if(forKuoHao16New1(code)) return "EH";//Ӣ�ķ���
               }
                  /*add 20170527����֤����Ϊ���������У��ͻ������м����Ϊ�ո�*/
                  function forKuoHao16New1(obj){ //�����������š�.�� �⼸�ָ���
                		var m = /^[\s]+$/;
                	  	var flag = m.test(obj);
                	  	//alert(flag);
                	  	if(flag){
                	  		return true;
                	  	}else{
                	  		return false;
                	  	}
                	}
              	
              	function reSetCustName(){
              	  $("#t_cus_name").val("<%=((String)custDoc.get(4)).trim()%>");
              	}
              	
              	function forKuoHao(obj){
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
                
                //�޸�֤������
                function changeIdtype(){
                	
                	//1210 ���� ��λ ֤������ ���ܻ��� ���ڵ���һ֤5��ϵͳ����Ҫ��ĺ� hejwa
                	if("1210"=="<%=opCode%>"){ 
									var old_idtype = "<%=old_idtype%>";
									if(old_idtype=="8"||old_idtype=="A"||old_idtype=="B"||old_idtype=="C"){
										if($("#s_idtype").val()!="8"&&$("#s_idtype").val()!="A"&&$("#s_idtype").val()!="B"&&$("#s_idtype").val()!="C"){
												rdShowMessageDialog("ԭ��λ֤��������֤������ֻ��ѡ��λ֤������");
												$("#s_idtype").val(old_idtype);
												return;
										}
									}else{
										if($("#s_idtype").val()=="8"||$("#s_idtype").val()=="A"||$("#s_idtype").val()=="B"||$("#s_idtype").val()=="C"){
												rdShowMessageDialog("ԭ����֤��������֤������ֻ��ѡ�����֤������");
												$("#s_idtype").val(old_idtype);
												return;
										}
									}
									}
									
                	checkCustNameFunc16New(document.all.t_cus_name,0,1);
                    if($("#s_idtype").val()=="1"){ //֤������Ϊ����֤���������еġ�֤����ַ������Ϊ��֤����ַ(����)��
                      $("#idAddrDiv").text("֤����ַ(����)");
                    }else{
                      $("#idAddrDiv").text("֤����ַ");
                    }
                    
                    if($("#s_idtype").val()=="0"||$("#s_idtype").val()=="D"){ //����֤
                    	$("#scan_idCard_two").css("display","");
                    	$("#scan_idCard_two222").css("display","");
                    	if("<%=opCode%>" == "1210"){
                    		$("#t_idno").attr("class","InputGrey");
									  		$("#t_idno").attr("readonly","readonly");
									  		$("#t_cus_name").attr("class","InputGrey");
									  		$("#t_cus_name").attr("readonly","readonly");
									  		$("#t_id_address").attr("class","InputGrey");
									  		$("#t_id_address").attr("readonly","readonly");
									  		$("#t_id_valid").attr("class","InputGrey");
									  		$("#t_id_valid").attr("readonly","readonly");
                    	}
                    	

                    	
                    }else {
                    	$("#scan_idCard_two").css("display","none");
                    	$("#scan_idCard_two222").css("display","none");
								  		$("#t_idno").removeAttr("class");
								  		$("#t_idno").removeAttr("readonly");
								  		$("#t_cus_name").removeAttr("class");
								  		$("#t_cus_name").removeAttr("readonly");
								  		$("#t_id_address").removeAttr("class");
								  		$("#t_id_address").removeAttr("readonly");
								  		$("#t_id_valid").removeAttr("class");
								  		$("#t_id_valid").removeAttr("readonly");
                    }
                    
                    if($("#s_idtype").val().indexOf("<%=WtcUtil.repNull(((String)custDoc.get(10)).trim())%>") != -1){ //ѡ���ʼ֤�����ͣ���ԭ��ʼ֤����Ϣ
											$("#t_cus_name").val("<%=((String)custDoc.get(4)).trim()%>");
											$("#t_id_address").val("<%=((String)custDoc.get(12)).trim()%>");
											$("#t_idno").val("<%=((String)custDoc.get(11)).trim()%>");
											$("#t_id_valid").val("<%=((String)custDoc.get(13)).trim()%>");
										}else{
											$("#t_cus_name").val("");
											$("#t_id_address").val("");
											$("#t_idno").val("");
											$("#t_id_valid").val("");
										}
										
										
								



            	    
            	    
                }
                
                function changeCardAddr1(obj){
                  var Str = $("#s_idtype").val();
                  
                    if((Str=="0")||(Str=="2")){ //֤������Ϊ����֤���߻��ڱ�ʱ
                      if(obj.value.length<8){
                        rdShowMessageDialog("Ҫ��8�������Ϻ��֣����������룡");
                        $("#t_id_address").val("<%=((String)custDoc.get(12)).trim()%>");
                  			return false;
                      }
                    }
                 
                }
                /*end diling update @2013/9/22*/
                
                function Idcardsdf(){
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
									var picpath_n = cre_dir +"\\"+picName+"_"+ document.all.cus_id.value +".jpg";
									
									var result;
									var result2;
									var result3;
									var username;
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
									
											subStrAddrLength("j1",IDaddress);
											document.all.t_cus_name.value =name;//����
											document.all.t_idno.value =code;//����֤��
											//document.all.t_cus_address.value =IDaddress;//����֤��ַ
											//document.all.t_id_valid.value =idValidDate_obj;//��Ч��
											
											//֤�����롢֤�����ơ�֤����ַ����Ч��
											if("<%=opCode%>" == "1210"){
												$("#t_idno").attr("class","InputGrey");
									  		$("#t_idno").attr("readonly","readonly");
									  		$("#t_cus_name").attr("class","InputGrey");
									  		$("#t_cus_name").attr("readonly","readonly");
									  		$("#t_id_address").attr("class","InputGrey");
									  		$("#t_id_address").attr("readonly","readonly");
									  		$("#t_id_valid").attr("class","InputGrey");
									  		$("#t_id_valid").attr("readonly","readonly");
											}
								  		checkIccIdFunc16New(document.all.t_idno,0,0);
											
										  
										  var aa= idValidDate_obj+"";
										  if(aa.indexOf("����") !=-1) {
										  	document.all.t_id_valid.value="21000101";
										  }else {
											  var bb=aa.substring(11,21);
												var cc = bb.replace("\.","");
												var dd = cc.replace("\.","");
												
											  document.all.t_id_valid.value =dd;
											}
										  
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
									var picpath_n = cre_dir +"\\"+picName+"_"+ document.all.cus_id.value +".jpg";
									
									var result;
									var result2;
									var result3;
									//var username;
									//var sfznamess1100="";
									//var sfzcodess1100="";
									//var sfzIDaddressss1100="";
									//var sfzbir_dayss1100="";
									//var sfzsexss1100="";
									//var sfzidValidDate_objss1100="";
									//var sfzpicturespathss1100="";
									//var photobuf;
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
											//photobuf=IdrControl1.GetPhotobuf();
												//sfznamess1100=name;
												//sfzcodess1100=code;
												//sfzIDaddressss1100=IDaddress;
												//sfzbir_dayss1100=bir_day;
												//sfzsexss1100=sex;
												//sfzidValidDate_objss1100=idValidDate_obj;
												//sfzpicturespathss1100=picpath_n;
									
											if(flag == "real"){ //ʵ��ʹ����
												document.all.realUserName.value =name;//����
												document.all.realUserIccId.value =code;//����֤��
												//document.all.realUserAddr.value =IDaddress;//����֤��ַ
											}else{  //������
												document.all.gestoresName.value =name;//����
												document.all.gestoresIccId.value =code;//����֤��
												//document.all.gestoresAddr.value =IDaddress;//����֤��ַ
											}
											subStrAddrLength(flag,IDaddress);//У������֤��ַ���������60���ַ������Զ���ȡǰ30����
											
											//document.all.idAddrH.value =IDaddress;//����֤��ַ
											//document.all.birthDay.value =bir_day;//����
											//document.all.birthDayH.value =bir_day;//����
											
											//if(sex!="1"&&sex!="2"&&sex!="3"){
											//	sex = "3"	;
											//}
										  //document.all.custSex.value=sex;//�Ա�
										  //document.all.idSexH.value=sex;//�Ա�
										  
										  //var aa= idValidDate_obj+"";
										  //if(aa.indexOf("����") !=-1) {
										  //	document.all.idValidDate.value="21000101";
										  //}else {				  
										  //var bb=aa.substring(11,21);
											//var cc = bb.replace("\.","");
											//var dd = cc.replace("\.","");
											//
										  //document.all.idValidDate.value =dd;
											//}
										  
										  //document.all.sf_flag.value ="success";//ɨ��ɹ���־
										  //document.all.pic_name.value = picpath_n;
										  //document.all.but_flag.value="1";
										  //changeCardAddr(document.all.idAddr);
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
													document.all.t_cus_name.value =xm;//����
													document.all.t_idno.value =zjhm;//����֤��
													//document.all.t_cus_address.value =zz;//����֤��ַ
													document.all.t_id_valid.value =v_validDates;//֤����Ч��
													if("<%=opCode%>" == "1210"){
														$("#idIccid").attr("class","InputGrey");
											  		$("#idIccid").attr("readonly","readonly");
											  		$("#custName").attr("class","InputGrey");
											  		$("#custName").attr("readonly","readonly");
											  		$("#idAddr").attr("class","InputGrey");
											  		$("#idAddr").attr("readonly","readonly");
											  		$("#idValidDate").attr("class","InputGrey");
											  		$("#idValidDate").attr("readonly","readonly");
													}
										  		checkIccIdFunc16New(document.all.t_idno,0,0);
										  		checkCustNameFunc16New(document.all.t_cus_name,0,0);
										  		//checkAddrFunc(document.all.t_cus_address,0,0);
												}else if(str == "31"){ //������
													document.all.gestoresName.value =xm;//����
													document.all.gestoresIccId.value =zjhm;//����֤��
													//document.all.gestoresAddr.value =zz;//����֤��ַ
												}else{ //ʵ��ʹ���� 22
													document.all.realUserName.value =xm;//����
													document.all.realUserIccId.value =zjhm;//����֤��
													//document.all.realUserAddr.value =zz;//����֤��ַ
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
										document.all.t_id_address.value =idAddr;//����֤��ַ
										checkAddrFunc(document.all.t_id_address,0,0);
									}else if(str == "31"){ //������
										document.all.gestoresAddr.value =idAddr;//����֤��ַ
									}else if(str == "22"){ //ʵ��ʹ���� 22
										document.all.realUserAddr.value =idAddr;//����֤��ַ
									}else if(str == "real"){ //ʵ��ʹ���� �ɰ�
										document.all.realUserAddr.value =idAddr;//����֤��ַ
									}else if(str == "manage"){ //������ �ɰ�
										document.all.gestoresAddr.value =idAddr;//����֤��ַ
									}else if(str == "j1"){ //��ȡ�ͻ�������Ϣ �ɰ�
										document.all.t_id_address.value =idAddr;//����֤��ַ
									}
								}

            </script>
        </head>
        <body>
            <form name="frm" method="POST" onKeyUp="chgFocus(frm)">
         
				<%
				String s_sql="select count(1) from dcustmsg t where t.sm_code in ('PB') and t.cust_id = "+cus_id;
				%>
				<wtc:pubselect name="sPubSelect" outnum="1">
				<wtc:sql><%=s_sql%></wtc:sql>
				<wtc:param value="<%=cus_id%>"/>
				</wtc:pubselect>
				<wtc:array id="rstStr" scope="end"/>
				<%
				String s_wlw_flag="0";
				if ( Integer.parseInt(rstStr[0][0])>0 )
				{
					s_wlw_flag="1";
				}
				%>
                <%@ include file="/npage/include/header.jsp" %>
                <input type="hidden" name="cus_id" id="cus_id" value="<%=cus_id%>">
                <input type="hidden" name="s_wlw_flag" id="s_wlw_flag" value="<%=s_wlw_flag%>">
                <input type="hidden" name="booking_id" id="booking_id" value="<%=booking_id%>">
                <input type="hidden" name="cust_name" id="cust_name" value="<%=(String)custDoc.get(4)%>">
                <input type="hidden" name="region_code" id="region_code" value="<%=((String)custDoc.get(1)).trim()%>">
                <input type="hidden" name="ReqPageName" id="ReqPageName" value="s1210Main">
                <input type="hidden" name="oriHandFee" id="oriHandFee" value="<%=((String)custDoc.get(22)).trim()%>">
                <input type="hidden" name="oldPass" id="oldPass" value="<%=((String)custDoc.get(5)).trim()%>">
                <input type=hidden name=loginAccept value="<%=sLoginAccept%>">
                <input type="hidden" name="old_name" id="old_name" value="<%=(String)custDoc.get(4)%>">
                <input type="hidden" name="old_phone" id="old_phone" value="<%=(String)custDoc.get(15)%>">
                <input type="hidden" name="old_address" id="old_address" value="<%=(String)custDoc.get(16)%>">
                <input type="hidden" name="old_idno" id="old_idno" value="<%=(String)custDoc.get(11)%>">
                <input type="hidden" name="noForPrt" id="noForPrt" value="<%=phone_no%>">
                <input type="hidden" name="phone_no_tosrv" id="phone_no_tosrv" value="<%=phone_no_tosrv%>">
                
                <input type="hidden" name="in_ChanceId" id="in_ChanceId" value="<%=in_ChanceId%>" />
                <input type="hidden" name="wa_no" id="wa_no" value="<%=wa_no%>" />
                
                <%@ include file="../../include/remark.htm" %>
                <div class="title">
                    <div id="title_zi"><%=opName%></div>
                </div>
                <table cellspacing="0">
                    <tr>
                        <td class="blue">��ͻ���־</td>
                        <td>
                            <b><font color="orange"><%=twoFlag[0]%></font></b>
                        </td>
                        <td class="blue">���ű�־</td>
                        <td colspan="3" class="blue"><%=twoFlag[1]%></td>
                    </tr>
                    <tr>
                        <td class="blue">�ͻ���������</td>
                        <td>
                            <input type="text" class="InputGrey" name="t_region" id="t_region" size="16"
                            value="<%=((String)custDoc.get(21)).trim()%>" readonly tabindex="0">
                        </td>
                        <td class="blue">��������</td>
                        <td>
                            <select name="s_city" id="s_city" onchange="chg_city()" index="0" disabled>
                            </select>
                            <input name="s_city_a" type="hidden"/> 
                        </td>
                        <td class="blue">��������</td>
                        <td>
                            <select name="s_spot" id="s_spot" index="1" disabled>
                            </select>
                            <input name="s_spot_a" type="hidden"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blue">�ͻ�����</td>
                        <td>
                            <input type="text" name="t_cus_name" id="t_cus_name" size="16" v_must="1"
                            value="<%=((String)custDoc.get(4)).trim()%>" v_minlength=1 v_maxlength=60 v_type=string  v_name="�ͻ�����"  index="2" maxlength="60" onblur="checkCustNameFunc16New(this,0,0);">
                            <font class="orange">*</font>
                        </td>
                        <td class="blue">�ͻ�״̬</td>
                        <td>
                            <select name="s_cus_status" index="3">
                                <wtc:qoption name="sPubSelect" outnum="4">
    							    <wtc:sql>select trim(status_code),trim(status_name) from sCustStatusCode order by  status_code</wtc:sql>
    							</wtc:qoption>
                            </select>
                        </td>
                        <td class="blue">�ͻ����</td>
                        <td>
                            <select name="s_cus_type" index="4">
                            	 <wtc:qoption name="sPubSelect" outnum="5">
							    							    <wtc:sql>select trim(type_code),trim(type_name) from sCustTypeCode order by type_code</wtc:sql>
							    							</wtc:qoption>
                            </select>
                        </td>
                    </tr>
                    <tr style="display:none">
                        <td class="blue" colspan="6">
                            <select name="s_cus_level" index="5" style="display:none">
                                <wtc:qoption name="sPubSelect" outnum="6">
    							    <wtc:sql>select trim(owner_code),trim(type_name) from sCustGradeCode where region_code='" + <%=init_region_code%> + "' order by owner_code</wtc:sql>
    							</wtc:qoption>
                            </select>
                            <input type="password" name="t_new_pass" id="t_new_pass" size="8"  v_type="pwd"
                            pwd2="t_conf_pass" v_name="�¿ͻ�����" v_maxlength=6 maxlength="6" index="6" style="display:none">
                            <input type="password" name="t_conf_pass" id="t_conf_pass" size="8" value=""
                            v_maxlength=8 v_name="ȷ�Ͽͻ�����" maxlength="8" index="7" style="display='none'">
                        </td>
                    </tr>
                    <tr>
                        <td class="blue">�ͻ���ַ</td>
                        <td class="blue" colspan="5">
                            <input type="text" name="t_cus_address" id="t_cus_address" size="60"
                            value="<%=((String)custDoc.get(9)).trim()%>" v_must=1 v_minlength=1 v_maxlength=60 v_type=addrs  v_name="�ͻ���ַ" maxlength="60" index="8"  onblur = "checkAddrFunc(this,1,0);" >
                            <font class="orange">*</font>
                        </td>
                    </tr>
                    <tr>
                        <td class="blue">֤������</td>
                        <td><select name="s_idtype" id="s_idtype" index="9" onchange="changeIdtype()">
                            <wtc:qoption name="sPubSelect" outnum="10">
    							    				<wtc:sql>select trim(id_type),trim(id_name) from sIdType order by id_type</wtc:sql>
    												</wtc:qoption>
                        </select></td>
                        <td class="blue">֤������</td>
                        <td>
                            <input type="text" name="t_idno" id="t_idno" size="18"
                            value="<%=((String)custDoc.get(11)).trim()%>" v_minlength=4 v_maxlength=20 v_type="string"  v_name="֤������" maxlength="20"  index="10" onblur = "checkIccIdFunc16New(this,0,0)">
                            <font class="orange">*</font>
                        </td>
                        <td class="blue">֤����Ч��</td>
                        <td>
                            <input type="text" name="t_id_valid" id="t_id_valid" v_format="yyyyMMdd" size="16"
                            value="<%=((String)custDoc.get(13)).trim()%>"   v_maxlength=8 v_type=date  v_name="֤����Ч��" index="11">
                        </td>
                    </tr>
                    <tr>
                        <td id="idAddrDiv" class="blue">֤����ַ</td>
                        <td colspan="5">
                            <input type="text" name="t_id_address" id="t_id_address" size="60"
                            value="<%=((String)custDoc.get(12)).trim()%>" v_minlength=1 v_maxlength=60 v_must=1 v_type=addrs  v_name="֤����ַ" maxlength="60" index="12" onBlur="if(checkElement(this)){checkAddrFunc(this,0,0)}">
                            <font class="orange">*</font>
                        		&nbsp;&nbsp;
                        		<input type="button" name="scan_idCard_two" id="scan_idCard_two" class="b_text"   value="����" onClick="Idcardsdf()" />
                        		<input type="button" name="scan_idCard_two222" id="scan_idCard_two222" class="b_text"   value="����(2��)" onClick="Idcard2('1')" >
                        </td>
                    </tr>
                    <tr>
                        <td class="blue">��ϵ������</td>
                        <td>
                            <input type="text" name="t_comm_name" id="t_comm_name" size="16"
                            value="<%=((String)custDoc.get(14)).trim()%>" v_maxlength=20 v_type=string  v_name="��ϵ������" index="13" maxlength="20" onblur="if(checkElement(this)){checkCustNameFunc(this,1,0)}">
                        </td>
                        <td class="blue">��ϵ�˵绰</td>
                        <td>
                            <input type="text" name="t_comm_phone" id="t_comm_phone" size="16"
                            value="<%=((String)custDoc.get(15)).trim()%>"  v_minlength=1  v_maxlength=20 v_type=phone  v_name="��ϵ�˵绰" index="14">
                            <font class="orange">*</font>
                        </td>
                        <td class="blue">��ϵ���ʱ�</td>
                        <td>
                            <input type="text" name="t_comm_postcode" id="t_comm_postcode" size="16"
                            value="<%=((String)custDoc.get(17)).trim()%>"  v_maxlength=6 v_type=zip  v_name="��ϵ���ʱ�" index="15" maxlength=6>
                        </td>
                    </tr>
                    <tr>
                        <td class="blue">��ϵ�˴���</td>
                        <td>
                            <input type="text" name="t_comm_fax" id="t_comm_fax" size="16"
                            value="<%=((String)custDoc.get(19)).trim()%>"   v_maxlength=30 v_type=phone  v_name="��ϵ�˴���" index="16">
                        </td>
                        <td class="blue">��ϵ��E_MAIL</td>
                        <td colspan="3">
                            <input type="text" name="t_comm_email" id="t_comm_email" size="16"
                            value="<%=((String)custDoc.get(20)).trim()%>"  v_type=email  v_name="��ϵ��E_MAIL" index="17">
                        </td>
                    </tr>
                    <tr>
                        <td class="blue">��ϵ�˵�ַ</td>
                        <td colspan="5">
                            <input type="text" name="t_comm_address" id="t_comm_address" size="60"  v_must=1
                            value="<%=((String)custDoc.get(16)).trim()%>" v_minlength=1 v_maxlength=60 v_type=addrs  v_name="��ϵ�˵�ַ" index="18" maxlength="60" onblur = "checkAddrFunc(this,2,0);">
                            <font class="orange">*</font>
                        </td>
                    </tr>
                    <tr>
                        <td class="blue">��ϵ��ͨѶ��ַ</td>
                        <td colspan="5">
                            <input type="text" name="t_comm_comm" id="t_comm_comm" size="60"  v_must=1
                            value="<%=((String)custDoc.get(18)).trim()%>" v_minlength=1 v_maxlength=60 v_type=addrs  v_name="��ϵ��ͨѶ��ַ" index="19" maxlength="60" onblur="if(checkElement(this)){checkAddrFunc(this,3,0)};" >
                            <font class="orange">*</font>
                        </td>
                    </tr>
                    
                     <!-- 20131216 gaopeng 2013/12/16 10:29:28 ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭������Ϣ start -->
		                 	<%@ include file="gestoresInfo.jsp" %>  
		                <!--20131216  gaopeng 2013/12/16 10:29:28 ������BOSS�����������ӵ�λ�ͻ���������Ϣ�ĺ� ���뾭������Ϣ end -->
		                
                    <tr>
                        <td class="blue">�ͻ��Ա�</td>
                        <td>
                            <select name="s_cus_sex" index="20">
                                <wtc:qoption name="sPubSelect" outnum="4">
    							    <wtc:sql>select trim(sex_code),trim(sex_name) from sSexCode order by sex_code</wtc:sql>
    							</wtc:qoption>
                            </select>
                        </td>
                        <td class="blue">��������</td>
                        <td>
                            <input type="text" name="t_birth" id="t_birth" v_format="yyyyMMdd" size="16"
                            value="<%=((String)custDoc.get(25)).trim()%>" v_maxlength=8 v_type=date  v_name="��������" index="21">
                        </td>
                        <td class="blue">ְҵ����</td>
                        <td>
                            <select name="s_busi_type" index="22">
                                <wtc:qoption name="sPubSelect" outnum="9">
    							    <wtc:sql>select trim(profession_id),trim(profession_name) from sProfessionId order by profession_id</wtc:sql>
    							</wtc:qoption>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="blue">ѧ��</td>
                        <td>
                            <select name="s_edu" index="23">
                                <wtc:qoption name="sPubSelect" outnum="9">
    							    <wtc:sql>select trim(work_code),trim(type_name) from sWorkCode where region_code='?' order by work_code</wtc:sql>
    							    <wtc:param value="<%=init_region_code%>"/>
    							</wtc:qoption>
                            </select>
                        </td>
                        <td class="blue">�ͻ�����</td>
                        <td>
                            <input type="text" name="t_cus_love" id="t_cus_love" size="16"
                            value="<%=((String)custDoc.get(28)).trim()%>"  v_maxlength=20 v_type=string v_name="�ͻ�����" index="24">
                        </td>
                        <td class="blue">�ͻ�ϰ��</td>
                        <td>
                            <input type="text" name="t_cus_habit" id="t_cus_habit" size="16"
                            value="<%=((String)custDoc.get(29)).trim()%>"  v_maxlength=20 v_type=string v_name="�ͻ�ϰ��" index="25">
                        </td>
                    </tr>
                    <TR id="isDirectManageCustTr1" style="display:none"> 
		                  <td class="blue" > �Ƿ�ֱ�ܿͻ�
		                  </td>
		                  <td> 
		                    <select name="isDirectManageCust" id="isDirectManageCust" onchange="qryDirectManageCustInfo1(this)">
		                    	<option value="0" selected>��</option>
		                    	<option value="1">��</option>
		                    </select>
		                  </td>
											<TD class="blue" > ֱ�ܿͻ�����
											</TD>
											<TD> 
												<input name="directManageCustNo" id="directManageCustNo"  class="button" v_must='0' v_type="string"  maxlength="60" v_maxlength=60 size="16" index="21"  />
											</TD>
		                  <TD class="blue" > ��֯��������
											</TD>
											<TD> 
												<input name="groupNo" id="groupNo"  class="button" v_must='0' v_type="string"  maxlength="60" v_maxlength=60 size="16" index="21"  onblur="qryDirectManageCustInfo2(this)" />
											</TD>
		                </tr>
		                
                    <TR id="istestgrps" style="display:none"> 
								      <td  class="blue" >�Ƿ���Լ���</td>
								      <td  colspan="5">
								        <select align="left" name="isceshijt_flag" id="isceshijt_flag" width=50 index="42">
								          <option class="button" value="0">��</option>
								          <option class="button" value="1">��</option>         
								        </select>
								      </td>
		                </tr>		     
		                
		                
		            <TR <%if(!opCode.equals("g049")){%>style="display:none"<%}%>> 
						      <TD width="16%" class="blue" > 
						        <div align="left">��˰��ʶ���</div>
						      </TD>
						      <TD  colspan="5"> 
						        <input type="text" id="Tax_identi_num" name="Tax_identi_num" value="<%=Tax_identi_num%>"  maxlength="30" v_type="string" v_minlength="15"  v_maxlength="30" />
						      </TD>
						    </TR>           
								                
                </table>
                </div>
                <div id="Operation_Table"> 
                <div class="title">
                    <div id="title_zi">������Ϣ</div>
                </div>
                <table>
                    <tr>
                        <td class="blue">������</td>
                        <td>
                            <input type="text" name="t_handFee" id="t_handFee" size="16"
                            value="<%=(((String)custDoc.get(22)).trim().equals(""))?("0"):(((String)custDoc.get(22)).trim()) %>" v_type=float v_name="������" <%if(hfrf){%>readonly<%}%> onblur="ChkHandFee()" index="26">
                        </td>
                        <td class="blue">ʵ��</td>
                        <td>
                            <input type="text" name="t_factFee" id="t_factFee" size="16" onKeyUp="getFew()"
                            v_type=float v_name="ʵ��"  index="27" <%
                            if(hfrf)
                            {
                            %>
                            readonly
                            <%
                            }
                            %>
                            >
                        </td>
                        <td class="blue">����</td>
                        <td>
                            <input type="text" name="t_fewFee" id="t_fewFee" size="16" readonly>
                        </td>
                    </tr>
                    <tr>
                        <td class="blue">ϵͳ��ע</td>
                        <td colspan="5">
                            <input type="text" name="t_sys_remark" id="t_sys_remark" size="60" readonly maxlength=30>
                        </td>
                    </tr>
                    <tr>
                        <td class="blue" style="display:none">�û���ע</td>
                        <td colspan="5" style="display:none">
                            <input type="text" name="t_op_remark" id="t_op_remark" size="60" v_maxlength=60  v_type=string  v_name="�û���ע" index="28" maxlength=60>
                        </td>
                    </tr>
                                        <tr>
                        <td class="blue" style="display:block">�û���ע</td>
                        <td colspan="5" style="display:block">
                            <input type="text" name="t_add_notes" id="t_add_notes" size="60"  value='<%=yonghubeizhu%>' v_type=string  v_name="�û���ע" index="28" maxlength=30>
                        </td>
                    </tr>
</table>

<!-- ningtn 2011-8-3 10:31:40 ������ӹ��� -->
<jsp:include page="/npage/public/hwReadCustCard.jsp">
	<jsp:param name="hwAccept" value="<%=sLoginAccept%>"  />
	<jsp:param name="showBody" value="01"  />
	<jsp:param name="sopcode" value="<%=opCode%>"  />		
</jsp:include>
<table>

                        <tr>
                            <td nowrap colspan="6" id="footer">
                                <input class="b_foot" type="button" name="b_print" value="ȷ��&��ӡ" onmouseup="printCommit()" onkeyup="if(event.keyCode==13)printCommit()" index="29">
                                <input class="b_foot" type="button" name="b_clear" value="���" onClick="frm.reset();" index="30">
                                <input class="b_foot" type="button" name="b_back" value="����" onClick="history.go(-1)" index="31">
                            </td>
                        </tr>
                </table>
                <!--20120828 gaopeng ���������� opcode �� opname -->
      <input type="hidden" name="vopcode" value="<%=opCode%>"/>
      <input type="hidden" name="vopname" value="<%=opName%>"/>
                <%@ include file="/npage/include/footer.jsp" %>
            </form>
        </body>
<!-- ningtn 2011-8-3 10:32:11 ���ӻ���������Χ -->
<%@ include file="/npage/public/hwObject.jsp" %> 
        <script language="JavaScript">
            function fillSelect()
            {

                //�����޸���-------------------
                <%
                int selObj_num=7;
                String[] selObj={"s_cus_status","s_cus_level","s_cus_type","s_idtype","s_cus_sex","s_busi_type","s_edu"};
                int[] firListLoc={6,7,8,10,24,26,27};
                for(int p=0;p<selObj_num;p++)
                {
                System.out.println("WtcUtil.repNull(((String)custDoc.get(firListLoc[p])).trim())="+(WtcUtil.repNull(((String)custDoc.get(firListLoc[p])).trim())));
                %>
                var len = document.all("<%=selObj[p]%>").options.length;

                for(i=0;i<len;i++)
                {
                if(document.all("<%=selObj[p]%>").options[i].value=="<%=WtcUtil.repNull(((String)custDoc.get(firListLoc[p])).trim())%>")
                {
                    document.all("<%=selObj[p]%>").options[i].selected=true;
                }

                }
                <%
                }

                int sub_num=1;
                String[] subObj={"s_city"};
                int[] subListLoc={2};
                for(int q=0;q<sub_num;q++)
                {
                %>
                document.all("<%=subObj[q]%>").options.length=<%=sub_metaData.length%>;
                <%
                for(int j=0;j<sub_metaData.length;j++)
                {
                %>
                document.all("<%=subObj[q]%>").options[<%=j%>].text='<%=WtcUtil.getOneTok(sub_metaData[j][q],"#",1)%>';
                document.all("<%=subObj[q]%>").options[<%=j%>].value='<%=WtcUtil.getOneTok(sub_metaData[j][q],"#",2)%>';
                if(document.all("<%=subObj[q]%>").options[<%=j%>].value=="<%=WtcUtil.repNull(((String)custDoc.get(subListLoc[q])).trim())%>")
                {
                    document.all("<%=subObj[q]%>").options[<%=j%>].selected=true;
                }
                <%
                }
                }
                
                int tri_num=1;
                String[] triObj={"s_spot"};
                int[] triListLoc={3};
                for(int r=0;r<tri_num;r++)
                {
                    System.out.println("count(town)="+tri_metaData.length);
                    %>
                    document.all("<%=triObj[r]%>").length=<%=tri_metaData.length%>;
                    <%
                    for(int k=0;k<tri_metaData.length;k++)
                        {
                        %>
                        document.all("<%=triObj[r]%>").options[<%=k%>].text='<%=WtcUtil.getOneTok(tri_metaData[k][r],"#",1)%>';
                        document.all("<%=triObj[r]%>").options[<%=k%>].value='<%=WtcUtil.getOneTok(tri_metaData[k][r],"#",2)%>';
                        if(document.all("<%=triObj[r]%>").options[<%=k%>].value=="<%=WtcUtil.repNull(((String)custDoc.get(triListLoc[r])).trim())%>")
                        {
                            document.all("<%=triObj[r]%>").options[<%=k%>].selected=true;
                        }
                        <%
                    }
                }
                %>
            }
        </script>
        <%@ include file="/npage/include/public_smz_check.jsp" %>
    </html>