<%
	/********************
	 *version v2.0
	 *������: si-tech
	 *author:
	 *update:anln@2009-02-12 ҳ�����,�޸���ʽ
	 *update by qidp @ 2009-04-10 ����ҳ������
	 *update by qidp @ 2009-06-02 ���϶˵�������
	 ********************/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.sitech.boss.s1900.config.productCfg" %>
<%@ page import="org.apache.log4j.Logger"%>

<%
	String db_cu_date = "";
	String regionCode_date = (String)session.getAttribute("regCode");
%>
	<wtc:pubselect name="sPubSelect" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode_date%>">
  		<wtc:sql>select to_char(sysdate,'yyyyMMdd') as cu_date from dual</wtc:sql>
 		</wtc:pubselect>
	<wtc:array id="result_cu_date" scope="end"/>		
<%
	if(result_cu_date.length>0){
		db_cu_date = result_cu_date[0][0];
	}
%>

<%
   	String opCode = "3691";	
	String opName = "���Ų�Ʒ���ϱ��";	//header.jsp��Ҫ�Ĳ���  
	Logger logger = Logger.getLogger("f3691_1.jsp");
	String dateStr1 = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
	String dateStr22 = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
	String date_yyyyMM = new java.text.SimpleDateFormat("yyyyMM").format(new java.util.Date());
	
    int iDate = Integer.parseInt(dateStr1);
    String addDate = Integer.toString(iDate+1);
	String op_code="3691"; 
	String unit_id = request.getParameter("unit_id");
	String groupUserId = request.getParameter("grpIdNo");
	String ip_Addr = (String)session.getAttribute("ipAddr");
	String workno = (String)session.getAttribute("workNo");
	String org_code = ((String)session.getAttribute("orgCode")).substring(0,7);
	String nopass  =(String)session.getAttribute("password"); 
	String Department = (String)session.getAttribute("orgCode");
	String regionCode = (String)session.getAttribute("regCode");
	String districtCode = Department.substring(2,4);
	String powerRight = (String)session.getAttribute("powerRight"); 
	String sqlStr = "";
	String service_name = "";
	String m2mFlag1 = "N";
	String m2mFlag2 = "N";
	
	boolean haveA323 = false;
	boolean have_a324 = false;
	boolean have_a325 = false;
	
	String F10954_selected = "";
	String F10957_selected = "";
	String F10340_selected = "";
	String F10341_selected = "";
	
  String tempStr = "";
  /*2015/8/17 9:25:54 gaopeng ����7����Ѯ���ſͻ���CRM��BOSSϵͳ����ĺ�--2.�������������Ѽ��Ͱ�����Ʒ������*/
  String[][] favInfo = (String[][])session.getAttribute("favInfo");
	for(int feefavi = 0; feefavi< favInfo.length; feefavi++){
			tempStr = (favInfo[feefavi][0]).trim();
			if(tempStr.compareTo("a323") == 0){
				/*���Ż��Ѽ��Ͱ�����Ȩ��*/
				haveA323 = true;
			}
			
			if(tempStr.compareTo("a324") == 0){
					have_a324 = true;
			}
			
			if(tempStr.compareTo("a325") == 0){
					have_a325 = true;
			}
	}

System.out.println("----hejwa------------have_a324----------------->"+have_a324);
	
	ArrayList retArray = new ArrayList();
	String[][] result = new String[][]{};
	String[][] resulta = new String[][]{};
	String[][] resultList = new String[][]{};
	String[][] resultList2 = new String[][]{};
	int resultListLength2=0;

    	//SPubCallSvrImpl callView = new SPubCallSvrImpl();
    	productCfg prodcfg = new productCfg();
	int nextFlag=1; //����ǵ�һ�����ǵڶ���
	String listShow="none";
	
	StringBuffer nameList=new StringBuffer();
	StringBuffer nameValueList=new StringBuffer();
	StringBuffer nameGroupList=new StringBuffer();
	StringBuffer nameListNew=new StringBuffer();
	StringBuffer nameGroupListNew=new StringBuffer();
	
	String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());	
	
	//ȡ����ʡ�ݴ��� -- Ϊ�������ӣ�ɽ������ʹ��session
	//String[][] result2  = null;
	sqlStr = "select agent_prov_code FROM sProvinceCode where run_flag='Y'";
	//result2 = (String[][])callView.sPubSelect("1",sqlStr).get(0);
%>
	<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode1" retmsg="retMsg1" outnum="1">
		<wtc:sql><%=sqlStr%></wtc:sql>
	</wtc:pubselect>
	<wtc:array id="result2" scope="end" />
<%
	String ProvinceRun = "";
	if (result2 != null && result2.length != 0) {
		ProvinceRun = result2[0][0];
	}
	
	
	//�õ�ҳ�����
	String grpOutNo = "";
	String idcMebNo   ="";
	String smCode      ="";
	String smName    ="";
	String custName    ="";
	String iUserPwd    ="";
	String runCode      ="";
	String runName  ="";
	String ownerGrade   ="";
	String gradeName="";
	String ownerType ="";
	String ownerTypeName   ="";
	String custAddr   ="";
	String idType="";
	String idName="";
	String idIccid="";
	String card_name="";
	String totalOwe="";
	String totalPrepay="";
	String firstOweConNo="";
	String firstOweFee="";
	String bak_field="";
	String backPrepay="";
	String backInterest="";
	String notBackPrepay="";
	String openTime="";
	String grpIdNo="";
	String iccid="";
	String idNo="";
	String temp_buf="";
	String user_no2="";
	String unit_id2="";
	String cust_id2="";
	String iccid2 = "";
	String product_code3="";
	Vector temp=new Vector();
	StringBuffer fieldCode=new StringBuffer();
	StringBuffer fieldCode2=new StringBuffer();//for add item


	StringBuffer numberList=new StringBuffer();
	System.out.println("1");
	//�õ��б�����
	//String action=request.getParameter("action");
	
	/******* add by qidp @ 2009-06-02 ���϶˵������� *******/
	String in_GrpId = request.getParameter("in_GrpId");
	String in_IdNo = request.getParameter("IdNo");
    String in_ChanceId = request.getParameter("in_ChanceId");
    String wa_no = request.getParameter("wa_no1");
    String action = "";
    String openLabel = "";/*���ӱ�־λ��link���߶˵�������ͨ��������ƽ���˶���ģ�飻opcode�����߶˵������̣�ͨ��opcode�򿪴�ҳ�档*/
	String qryFlag=request.getParameter("qryFlag")==null?"":request.getParameter("qryFlag");
    /*�жϽ����ģ��ķ�ʽ��������Ӧ�Ĵ�����*/
    if(in_ChanceId != null){//�������������ʱ���̻����벻Ϊ�ա�
        action = "query";
        openLabel = "link";
        //liujian 2012-9-13 17:56:43 ���
        qryFlag = "qryCust";
        
    }else{
        in_GrpId = "";
        in_ChanceId = "";
        wa_no = "";
        in_IdNo = "";
        action = request.getParameter("action");
        openLabel = "opcode";
    }
    
	
	
	System.out.println("3691~~~~qryFlag"+qryFlag);    
    String ccDisp="";
    if ( qryFlag.equals("qryCptCpm") )
    {
    ccDisp="block"; 
    }
	else
	{
	 ccDisp="none"; 
	}
    
    /******* end of add *******/
	String []   paramsArray=new String [38];
	String [][] paramsOut=new String[][]{};	
	String [][] paramsOut26=new String[][]{};
	String [][] paramsOut27=new String[][]{};
	String [][] paramsOut28=new String[][]{};
	String [][] paramsOut29=new String[][]{};
	String [][] paramsOut30=new String[][]{};
	String [][] paramsOut31=new String[][]{};
	String [][] userFieldGrpNo=new String[][]{}; 
	String [][] userFieldGrpName=new String[][]{};
	String [][]userFieldMaxRows=new String[][]{};
	String [][]userFieldMinRows=new String[][]{};
	String [][]userFieldCtrlInfos=new String[][]{};
	String [][]userUpdateFlag=new String[][]{};
	String [][]openParamFlag=new String[][]{};
	String [][]timeMOStr=new String[][]{};
	String [][]vpmnStr=new String[][]{};
	String [][]manyPropertyStr=new String[][]{};
	String [][]liuliangStr=new String[][]{};
	String workNoLimit = "";//����Ȩ��
	String modeType=request.getParameter("userType");
	String error_code="9";
	String error_msg="";
	int resultListLength=0;
	System.out.println("&&&&&&&&&&&&&&*****************%%%%%%%%%%%%%%%%%%%%%%---"+action);
	if (action!=null&&action.equals("query")){
		//try{
			grpIdNo=request.getParameter("grpIdNo");
			iccid=request.getParameter("iccid");
			 idcMebNo=request.getParameter("idcMebNo");		
			 //user_no2=request.getParameter("user_no");	
			 //unit_id2=request.getParameter("unit_id");
			 //cust_id2=request.getParameter("cust_id");
			 //iccid2 = request.getParameter("iccid");
			 
			 iccid2=(request.getParameter("iccid") == null)?"":(request.getParameter("iccid"));
            cust_id2=(request.getParameter("cust_id") == null)?"":(request.getParameter("cust_id"));
            unit_id2=(request.getParameter("unit_id") == null)?"":(request.getParameter("unit_id"));
            user_no2=(request.getParameter("user_no") == null)?"":(request.getParameter("user_no"));
            iUserPwd=WtcUtil.repNull((String)request.getParameter("userPassword"));
            
			 product_code3=request.getParameter("product_code2");

			 if(openLabel!=null && openLabel.equals("link")){
			    grpIdNo = in_IdNo;
			 }

		     	 String [] paramsIn=new String []{workno,grpIdNo,"3517"};
		     	 %>
		     	 	<wtc:service name="s3691QryE" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode2" retmsg="retMsg2" outnum="58" >
					<wtc:param value="<%=workno%>"/>
					<wtc:param value="<%=grpIdNo%>"/>
					<wtc:param value="3517"/>					
					<wtc:param value="<%=in_ChanceId%>"/>
					<wtc:param value="<%=nopass%>"/> 
				</wtc:service>
				<%
				System.out.println("&&&&&&&&&&&&&&*****************%%%%%%%%%%%%%%%%%%%%%%---"+grpIdNo);
				%>
				<wtc:array id="paramsOut1" start="0" length="40" scope="end"/>
				<wtc:array id="workNoLimit1" start="11" length="1" scope="end"/>
				<wtc:array id="paramsOut261" start="26" length="4" scope="end"/>
				<wtc:array id="paramsOut271" start="27" length="1" scope="end"/>
				<wtc:array id="paramsOut281" start="28" length="1" scope="end"/>
				<wtc:array id="paramsOut291" start="29" length="1" scope="end"/>
				<wtc:array id="paramsOut301" start="30" length="1" scope="end"/>
				<wtc:array id="paramsOut311" start="31" length="1" scope="end"/>
				<wtc:array id="userFieldGrpNo1" start="32" length="1" scope="end"/>
				<wtc:array id="userFieldGrpName1" start="33" length="1" scope="end"/>
				<wtc:array id="userFieldMaxRows1" start="34" length="1" scope="end"/>
				<wtc:array id="userFieldMinRows1" start="35" length="2" scope="end"/>				
				<wtc:array id="userFieldCtrlInfos1" start="37" length="1" scope="end"/>
				<wtc:array id="userUpdateFlag1" start="38" length="1" scope="end"/>
				<wtc:array id="openParamFlag1" start="39" length="1" scope="end"/>
				<wtc:array id="timeMOStr1" start="40" length="2" scope="end"/>
				<wtc:array id="vpmnStr1" start="42" length="12" scope="end"/>
				<wtc:array id="manyPropertyStr1" start="54" length="1" scope="end"/>
				<!--2015/9/15 15:47:10 gaopeng R_CMI_HLJ_guanjg_2015_2405555@������ҵӦ����������ƷBOSSϵͳ����վ�����ĺ��������հ���
					�������� �������������ͣ�����������������û�з��ػ���Ϊ�ա�
					0-�հ���1-�°���2-�������3-���
				 -->
				<wtc:array id="liuliangStr1" start="55" length="1" scope="end"/>
		     	 <%
		     	  String test[][] = paramsOut261;

        System.out.println("+++++++++++++++++++++++++++++++++++++++++++++++++");
        for(int outer=0 ; test != null && outer< test.length; outer++)
        {
                for(int inner=0 ; test[outer] != null && inner< test[outer].length; inner++)
                {
                        System.out.print(" | "+test[outer][inner]);
                }
                System.out.println(" | ");
        }
        System.out.println("+++++++++++++++++++++++++++++++++++++++++++++++++");
		     	 System.out.println("gaopengSeeLog369111======liuliangStr1.length"+liuliangStr1.length+"---paramsOut281.length==="+paramsOut281.length);
		     	 	paramsOut=paramsOut1;
		     	 	paramsOut26=paramsOut261;
		     	 	paramsOut27=paramsOut271;
		     	 	paramsOut28=paramsOut281;
		     	 	paramsOut29=paramsOut291;
		     	 	paramsOut30=paramsOut301;
		     	 	paramsOut31=paramsOut311;
		     	 	userFieldGrpNo=userFieldGrpNo1;
		     	 	userFieldGrpName=userFieldGrpName1;
		     	 	userFieldMaxRows=userFieldMaxRows1;
		     	 	userFieldMinRows=userFieldMinRows1;
		     	 	userFieldCtrlInfos=userFieldCtrlInfos1;
		     	 	userUpdateFlag = userUpdateFlag1;
		     	 	openParamFlag = openParamFlag1;
		     	 	timeMOStr = timeMOStr1;
		     	 	vpmnStr = vpmnStr1;
		     	 	manyPropertyStr = manyPropertyStr1;
		     	 	liuliangStr = liuliangStr1;
		     	 	System.out.println("vpmnStr1==========="+vpmnStr1.length);

		     	 	
		     	 	
for(int i=0;i<paramsOut261.length;i++){
		if("10954".equals(paramsOut261[i][0])){
			F10954_selected = paramsOut261[i][1];
		}
		
		if("10957".equals(paramsOut261[i][0])){
			F10957_selected = paramsOut261[i][1];
		}
		
		if("10340".equals(paramsOut261[i][0])){
			F10340_selected = paramsOut261[i][1];
		}
			if("10341".equals(paramsOut261[i][0])){
			F10341_selected = paramsOut261[i][1];
		}
}



  	 	
		     	 	error_code=retCode2;             		
                    error_msg=retMsg2;
             if(!(error_code.equals("000000")))
			{
%>
                <script>
                    rdShowMessageDialog("������룺<%=error_code%>������Ϣ��<%=error_msg%>",0);
				    history.go(-1);
                </script>
<%
			}
			if(paramsOut!=null&&paramsOut.length>0){
				 for (int i=0;i<26;i++){				
					paramsArray[i]=paramsOut[0][i];
				 }
			}
			System.out.println("-----xCott-----paramsOut26.length---"+paramsOut26.length);

			for (int i=0;i<paramsOut26.length;i++){
				fieldCode.append(paramsOut26[i][0]+"|");
			}
			
			if(workNoLimit1.length>0){
				workNoLimit = workNoLimit1[0][0];
			}
			
			/*paramsOut27=(String[][])retArray.get(27);
			paramsOut28=(String[][])retArray.get(28);
			paramsOut29=(String[][])retArray.get(29);
			paramsOut30=(String[][])retArray.get(30);
			paramsOut31=(String[][])retArray.get(31);
			userFieldGrpNo=(String[][])retArray.get(32);
			userFieldGrpName=(String[][])retArray.get(33);
			userFieldMaxRows=(String[][])retArray.get(34);
			userFieldMinRows=(String[][])retArray.get(35);
			userFieldCtrlInfos=(String[][])retArray.get(37);*/
			
System.out.println("3");
			if(paramsOut30!=null&&paramsOut30.length>0){
				for (int i=0;i<paramsOut30.length;i++){		
					if (paramsOut30[i][0].equals("14")){
						temp.add(paramsOut26[i][0]);
					}
				}
			}
			System.out.println("000000000000000000000000000000000000000="+retCode2);
			
			 
			 nextFlag=2;
			 listShow="";
				//�õ����ݵ�����
				//�õ���������
			//�õ������û�����add
			String bizCode = "";
			if ("ML".equals(paramsArray[9])||"AD".equals(paramsArray[9])){
                String sql1="select trim(field_value) from dgrpusermsgadd where id_no = '"+paramsArray[0]+"' and TRIM(field_code) = 'YWDM0'";
                %>
                	<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode44" retmsg="retMsg44" outnum="1">
                		<wtc:sql><%=sql1%></wtc:sql>
                	</wtc:pubselect>
                	<wtc:array id="result44" scope="end" />
                <%
                    
                    if("000000".equals(retCode44) && result44.length>0){
                        bizCode = result44[0][0];
                    }else{
                %>
                        <script>
                            rdShowMessageDialog("ȡbizCodeʧ�ܣ�",0);
                		    history.go(-1);
                        </script>
                <%
                    }
            }
		     	 	
//------------add by hansen-------------
//----�õ����û�û�����ӵ���
System.out.println("=========================&&&&&--vpmn--"+paramsArray[0]);
/*
        if ("ML".equals(paramsArray[9])){
            sqlStr=" select a.param_code,a.param_name,'11',a.param_type,a.param_length,b.null_able,b.open_param_flag "
            +"   from sbizparamcode a, sbizparamdetail b "
            +"  where a.param_code = b.param_code "
            +"    and b.param_set = '9999'  "
            +"    and b.update_flag = 'Y'  "
            +"    and a.param_code in (SELECT a.param_code "
            +"                           FROM sbizparamcode a, sbizparamdetail b "
            +"                          WHERE a.param_code = b.param_code "
            +"    						   and b.param_set = '9999' "
            +"                             and a.param_code not in ('00020','00021')"
            +"                         MINUS "
            +"                         SELECT a.field_code "
            +"                           FROM DGRPUSERMSGADD a "
            +"                          WHERE a.id_no = '"+paramsArray[0]+"') "
            +"  order by b.param_order, a.param_type ";
        }else if("AD".equals(paramsArray[9])){
            sqlStr=" select a.param_code,a.param_name,'11',a.param_type,a.param_length,b.null_able,b.open_param_flag "
            +"   from sbizparamcode a, sbizparamdetail b "
            +"  where a.param_code = b.param_code "
            +"    and b.param_set = '9998'  "
            +"    and b.update_flag = 'Y'  "
            +"    and a.param_code in (SELECT a.param_code "
            +"                           FROM sbizparamcode a, sbizparamdetail b "
            +"                          WHERE a.param_code = b.param_code "
            +"    						   and b.param_set = '9998' "
            +"                             and a.param_code not in ('00020','00021')"
            +"                         MINUS "
            +"                         SELECT a.field_code "
            +"                           FROM DGRPUSERMSGADD a "
            +"                          WHERE a.id_no = '"+paramsArray[0]+"') "
            +"  order by b.param_order, a.param_type ";
*/

        if ("ML".equals(paramsArray[9])||"AD".equals(paramsArray[9])){
            /* ��������ҵ����1.0 
            sqlStr=" select a.param_code,a.param_name,'11',a.param_type,a.param_length,b.null_able,b.open_param_flag "
            +"   from sbizparamcode a, sbizparamdetail b ,SBILLSPCODE c"
            +"  where a.param_code = b.param_code "
            +"    and b.param_set = c.param_set  "
            +"    and trim( c.bizcodeadd )='"+bizCode+"' "
            +"    and b.update_flag = 'Y'  "
            +"    and b.multi_able = 'N'  "
            +"    and b.show_flag = 'Y'   "
            +"    and a.param_code in (SELECT a.param_code "
            +"                           FROM sbizparamcode a, sbizparamdetail b,SBILLSPCODE c "
            +"                          WHERE a.param_code = b.param_code "
            +"    						   and b.param_set = c.param_set "
            +"    						   and trim( c.bizcodeadd )='"+bizCode+"' "
            +"                             and a.param_code not in ('00020','00021')"
            +"                         MINUS "
            +"                         SELECT a.field_code "
            +"                           FROM DGRPUSERMSGADD a "
            +"                          WHERE a.id_no = '"+paramsArray[0]+"') "
            +"  order by b.param_order, a.param_type ";
            */
            /* ��������ҵ����2.0 [����] */
            
            sqlStr=" select a.param_code,a.param_name,'11',a.param_type,a.param_length,b.null_able,b.open_param_flag "
            +"   from sbizparamcode a, sbizparamdetail b ,SBILLSPCODE c"
            +"  where a.param_code = b.param_code "
            +"    and b.param_set = c.param_set  "
            +"    and trim( c.bizcodeadd )= '"+bizCode+"' "
            +"    and b.update_flag = 'Y'  "
            +"    and b.multi_able = 'N'  "
            +"    and b.show_flag = 'Y'   "
            +"    and a.param_code in (SELECT a.param_code "
            +"                           FROM sbizparamcode a, sbizparamdetail b,SBILLSPCODE c "
            +"                          WHERE a.param_code = b.param_code "
            +"    						   and b.param_set = c.param_set "
             +"    						   and trim( c.bizcodeadd )= '"+bizCode+"' "
            +"                             and a.param_code not in ('00034','00035','00040','00041','00042','00043','00044','00045','00046')"
            +"                         MINUS "
            +"                         SELECT a.field_code "
            +"                           FROM DGRPUSERMSGADD a "
            +"                          WHERE a.id_no = '"+paramsArray[0]+"') "
            +"  order by b.param_order, a.param_type "; 
            
        }else{
            sqlStr="select a.field_code,a.field_name,a.field_purpose,a.field_type,a.field_length,b.ctrl_info,b.open_param_flag "
         +"  from sUserFieldCode a,SGRPSMFIELDRELA b"
         +"     where a.field_code=b.field_code"
         +"     AND b.user_type = '"+paramsArray[9]+"'"
         +"     AND b.update_flag = 'Y'"
         +"     AND a.field_code not in ( 'ZHWW0')"
         +"   and a.field_code in("
         +" SELECT a.field_code"
             +"      FROM suserfieldcode a, SGRPSMFIELDRELA b"
             +"      where a.field_code = b.field_code"
             +"      AND b.user_type = '"+paramsArray[9]+"'"
             +"      MINUS"
             +"      SELECT a.field_code"
             +"      FROM DGRPUSERMSGADD a, SGRPSMFIELDRELA c"
             +"      WHERE a.id_no = '"+paramsArray[0]+"'"
             +"      AND a.field_code = c.field_code"
             +"      AND a.user_type = c.user_type)"
             +" order by b.field_order,a.field_type";
             
            }
                if(!"va".equals(paramsArray[9])){
			//resultList2=(String[][])callView.sPubSelect("6",sqlStr).get(0);
			%>
				<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode3" retmsg="retMsg3" outnum="7">
					<wtc:sql><%=sqlStr%></wtc:sql>
				</wtc:pubselect>
				<wtc:array id="result3" scope="end" />
			<%
			resultList2=result3;
			if (retCode3.equals("000000")&&resultList2 != null&&resultList2.length>0)
			{
				if (resultList2[0][0].equals(""))
				{
					resultList2 = null;
				}
			}
			if (retCode3.equals("000000")&&resultList2 != null&&resultList2.length>0)
			{
				for(int i=0;i<resultList2.length;i++)
				{
					if (resultList2[i][2].equals("10")){
						numberList.append(resultList2[i][0]+"|");
					}
				}
			}

			resultListLength2=0;
			if (resultList2 != null&&resultList2.length>0){
				resultListLength2=resultList2.length;
				//����ƴ�����ݵ��¸�ҳ��
			    for (int i=0;i<resultListLength2;i++){
					fieldCode2.append(resultList2[i][0]+"|");
					for(int j=0;j<resultList2[0].length;j++){
					    System.out.println("============:"+resultList2[i][j]);
					}
				}
			}
		  	
}
//---------------------------


		
	}
	String busiFlag = "";
	String getBusiFlagSql = "";
    if ("link".equals(openLabel)){
        getBusiFlagSql = "select trim(field_value) from dgrpusermsgadd where id_no = " + in_IdNo + " and field_code = '1010' ";
    }else {
       getBusiFlagSql = "select trim(field_value) from dgrpusermsgadd where id_no = " + groupUserId + " and field_code = '1010' ";
    }
    
    if ("hj".equals(paramsArray[9])){
%>
        <wtc:service name="TlsPubSelCrm" outnum="1" retcode="retCode111" retmsg="retMsg111">
    		<wtc:param value="<%=getBusiFlagSql%>"/>
    	</wtc:service>
        <wtc:array id="busiFlagResult" scope="end"/> 
<%  
        if (busiFlagResult.length > 0){
            busiFlag = busiFlagResult[0][0];
        }
    }
    
    
    /*begin hejwa add for �ж��Ƿ��в���Ȩ�� 2015-5-29 15:57:18 */
  String[][] temfavStr = (String[][])session.getAttribute("favInfo");
	String[] favStr = new String[temfavStr.length];
	boolean operFlag = false;
	for(int i = 0; i < favStr.length; i ++) {
		favStr[i] = temfavStr[i][0].trim();
	}
	if (WtcUtil.haveStr(favStr, "a402")) {
		operFlag = true;
	}
	
	
	     
%>



<%
String flag_10635 = "";
String sql_10635_str = "select count(1) from dgrpusermsgadd t where t.id_no = :grpIdNo  and t.field_code = '10635'";
String sql_10635_prm = "grpIdNo="+grpIdNo;
%>
  <wtc:service name="TlsPubSelCrm" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=sql_10635_str%>" />
		<wtc:param value="<%=sql_10635_prm%>" />	
	</wtc:service>
	<wtc:array id="result_10635" scope="end"    />
<%
if(result_10635.length>0){
	flag_10635 = result_10635[0][0];
}
System.out.println("------------------flag_10635--------->"+flag_10635);





String str_10313_flag = "";
String sql_10313_flag = "SELECT Field_value FROM dbcustadm.dgrpusermsgadd WHERE id_no = :grpIdNo and field_code = '10313' ";

%>  

  <wtc:service name="TlsPubSelCrm" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=sql_10313_flag%>" />
		<wtc:param value="<%=sql_10635_prm%>" />	
	</wtc:service>
	<wtc:array id="result_10313" scope="end"    />
		
<%
	if(result_10313.length>0){
		str_10313_flag = result_10313[0][0];
	}
	
	
	System.out.println("-------hejwa---------sql_10313_flag---------------->"+sql_10313_flag);
	System.out.println("-------hejwa---------str_10313_flag---------------->"+str_10313_flag);

%>		
    
	<HEAD>
	<TITLE>���Ų�Ʒ���ϱ��</TITLE>	
	<SCRIPT type=text/javascript>	

$(document).ready(function(){
	
			var workno         = "<%=workno%>";
			var str_10313_flag = "<%=str_10313_flag%>";
			
			/*
			alert(
				"workno=["+workno+"]"+"\n"+
				"str_10313_flag=["+str_10313_flag+"]"+"\n"+
				"typeof($(\"#F10313\"))=["+typeof($("#F10313"))+"]"+"\n"
			);
			*/
			
	    if(typeof($("#F10313")) != "undefined"&&str_10313_flag!=""){
	    	if(workno=="aavg21"){
	    		$("#F10313").val(str_10313_flag);
	    	}else{
	    		//ֻ��һ��0 
	    		if(str_10313_flag=="1"){
	    			$("#F10313").append(" <option value='1' selected>1->ȫʡ����</option>");
	    		}
	    		
	    		if(str_10313_flag=="2"){
	    			$("#F10313").append(" <option value='2' selected>2->ȫ������</option>");
	    		}
	    		
	    		if(str_10313_flag=="3"){
	    			$("#F10313").append(" <option value='3' selected>3->���ػ�ʡ������</option>");
	    		}
	    		
	    	}
	    }
	
});		




		onload=function(){	
			
		    var disableStr = "";
		    document.all.in_ChanceId2.value = "<%=in_ChanceId%>";
				/*begin add �������б��еĿ�ֵ���д��� for ��CRMϵͳ���ӡ�Ӫ�������ֶε�����@2015/4/22 */
		    if(typeof($("#F10818")) != "undefined"){
					$("#F10818 option").each(function(){
			      if($(this).val() == ""){
			      	$(this).remove();
			      }
			    });
				}
				/*end add �������б��еĿ�ֵ���д��� for ��CRMϵͳ���ӡ�Ӫ�������ֶε�����@2015/4/22 */
        <%
            /*****************************
             * �߶˵���ʱ�����÷��񣬻�ȡ���۷��洫������ݡ�
             *****************************/
//            try{
                if(openLabel!=null && openLabel.equals("link")){
                %>
                    <wtc:service name="QryServMC" routerKey="region" routerValue="<%=regionCode%>" retcode="QryServMCCode" retmsg="QryServMCMsg" outnum="21" >
                        <wtc:param value="<%=in_GrpId%>"/>
                        <wtc:param value="<%=in_ChanceId%>"/> 
                        <wtc:param value="1"/>
                        <wtc:param value="<%=in_IdNo%>"/>
                        <wtc:param value=""/>
                    </wtc:service>
                    <wtc:array id="QryServMCArr" start="6" length="15" scope="end"/>
                    <wtc:array id="QryServMCArr2" start="0" length="6" scope="end"/>
                    
                <%
                    if("000000".equals(QryServMCCode) && QryServMCArr2.length>0){
                        for(int i=0;i<QryServMCArr2.length;i++){
                            out.print("if(document.getElementById('"+QryServMCArr2[i][1]+"') != null){");
%>
                            var zValue = '<%=QryServMCArr2[i][3]%>';
                            var zTarget = document.getElementById("<%=QryServMCArr2[i][1]%>");
<%                      
                        //if ("hl".equals(paramsArray[9]) || 
                          //      ("hj".equals(paramsArray[9]) && "211".equals(busiFlag))
                            //){
                        if (("hl".equals(paramsArray[9]) || "hj".equals(paramsArray[9])) && 
                                openLabel.equals("link")){%>
                            if ($(zTarget).is('select') && zValue == ''){
                                $(zTarget).empty().html('<option value=""></option>');
                            } else {
                                $(zTarget).val(zValue);
                            }
<%                      }else{%>
                            zTarget.value = zValue;
<%                      }
                            out.print("}");
                        }
                    }else{
                        %>
                        rdShowMessageDialog("<%=QryServMCCode%>" + "[" + "<%=QryServMCMsg%>" + "]" ,0);
                        <%
                        System.out.println("f3691_1.jsp -> service QryServMC :"+QryServMCCode+"----"+QryServMCMsg);
                    }
                    
                    if("000000".equals(QryServMCCode) && QryServMCArr.length>0){
                        out.print("document.all.iccid.value=\""+QryServMCArr[0][0]+"\";");
                        out.print("document.all.cust_id.value=\""+QryServMCArr[0][1]+"\";");
                        out.print("document.all.unit_id.value=\""+QryServMCArr[0][2]+"\";");
                        out.print("document.all.user_no.value=\""+QryServMCArr[0][14]+"\";");
                    }
                }
//            }catch(Exception e){
//                e.printStackTrace();
//                System.out.println("f3691_1.jsp -> Call service QryServMC failed!");
//            }
if (action!=null&&action.equals("query")){
%>
    $("#chkPass").attr("disabled",true);
<%
        if("ML".equals(paramsArray[9]) || "AD".equals(paramsArray[9])){
            if(timeMOStr.length>0){
%>
         	 	    var timeStr = "<%=timeMOStr[0][0]%>";
         	 	    var timeArray = new Array();
                    timeArray = timeStr.split('~');
                    if(document.all.F00020 != null)
                    document.all.F00020.value = timeArray[0];
                    if(document.all.StartTime != null)
                    document.all.StartTime.value = timeArray[1];
                    if(document.all.EndTime != null)
                    document.all.EndTime.value = timeArray[2];
                    
                    var moStr = "<%=timeMOStr[0][1]%>";
                    var moArray = new Array();
                    moArray = moStr.split('~');
                    if(document.all.F00021 != null) document.all.F00021.value = moArray[0];
                    if(document.all.MOCode != null) document.all.MOCode.value = moArray[1];
                    if(document.all.CodeMathMode != null) document.all.CodeMathMode.value = moArray[2];
                    if(document.all.MOType != null) document.all.MOType.value = moArray[3];
                    if(document.all.DestServCode != null) document.all.DestServCode.value = moArray[4];
                    if(document.all.ServCodeMathMode != null) document.all.ServCodeMathMode.value = moArray[5];
<%
            }
        }
        /* begin add for ��ҵӦ��������BOSSϵͳ�������@2014/9/3 */
        if("LL".equals(paramsArray[9])){
        
%>
					
					$("td[name^='liuliangB']").each(function(){
						var LLType = $(this).attr("LLtype");
						var hideTrObj = $(this).parent();
						if(LLType == "1"){
							
						}else if(LLType == "0" || LLType == "2" || LLType == "3"){
							hideTrObj.hide();
						}
						
					});
					
					$("select[name='F10685']").each(function(){ //��Ϊ���ͷ���ʱ��������Ĭ�����ͱ���һ����ʾ
						if($(this).val() != "F"){
        			$("td[name^='acquScaleTd']").css("display","none");
        		}else{
        			$("td[name^='acquScaleTd']").css("display","");
        		}
					});
        	$("select[name='F10685']").change(function(){
        		if($(this).val() != "F"){
        			$("td[name^='acquScaleTd']").css("display","none");
        		}else{ //���ͷ���ʱ����
        			$("td[name^='acquScaleTd']").css("display","");
        		}
        	});
<%
        }
        /* end add for ��ҵӦ��������BOSSϵͳ�������@2014/9/3 */
        if("vp".equals(paramsArray[9])){
%>
            document.all.vpmn_flag.style.display = "";
            document.all.group_name.value = "<%=vpmnStr[0][0]%>";
            document.all.province.value = "<%=vpmnStr[0][1]%>";
            document.all.contact.value = "<%=vpmnStr[0][2]%>";
            document.all.telephone.value = "<%=vpmnStr[0][3]%>";
            document.all.address.value = "<%=vpmnStr[0][4]%>";
            document.all.srv_start.value = "<%=vpmnStr[0][5]%>";
            document.all.srv_stop.value = "<%=vpmnStr[0][6]%>";
            document.all.fee_rate.value = "<%=vpmnStr[0][7]%>";
            document.all.busi_type.value = "<%=vpmnStr[0][8]%>";
            document.all.chg_flag.value = "<%=vpmnStr[0][9]%>";
            document.all.cover_region.value = "<%=vpmnStr[0][10]%>";
            document.all.max_outnumcl.value = "<%=vpmnStr[0][11]%>";
        <%}}%>
        <%
        /*****************************
         * �߶˵���ʱ������Ҫ��һЩԪ�ز������޸ġ�
         *****************************/
     
        String sql33 = "";
//        try{
            if(openLabel!=null && openLabel.equals("link")){
                sql33 = "select name_id,name_type from sgrpmsgdisabled where sm_code = '"+paramsArray[9]+"' and OP_TYPE = '2' and disabled_flag = 'N'";
                System.out.println("sql33 = " + sql33);
            %>
            	<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode00" retmsg="retMsg00" outnum="2">
            		<wtc:sql><%=sql33%></wtc:sql>
            	</wtc:pubselect>
            	<wtc:array id="result00" scope="end" />
            <%
                if(retCode00.equals("000000") && result00.length>0){
                    for(int i=0;i<result00.length;i++){
                        if("01".equals(result00[i][1])){//01:�ı���
                            out.print("if(document.all('"+result00[i][0]+"') != null){");
                                out.print("document.all('"+result00[i][0]+"').readOnly=true;");
                                out.print("$(document.all('"+result00[i][0]+"')).addClass(\"InputGrey\");");
                            out.print("}");
                        }else if("02".equals(result00[i][1])){//02:������
                            out.print("if(document.all('"+result00[i][0]+"')!=null){");
                                out.print("document.all('"+result00[i][0]+"').disabled=true;");
                                out.print("disableStr = disableStr + \""+result00[i][0]+"\" + \"|\";");
                                out.print("");
                            out.print("}");
                        }else if("03".equals(result00[i][1])){//03:��ť
                            out.print("if(document.all('"+result00[i][0]+"')!=null){");
                                out.print("document.all('"+result00[i][0]+"').disabled=true;");
                            out.print("}");
                        }
                    }
                }
            }
//        }catch(Exception e){
//            e.printStackTrace();
//            System.out.println("# f3691_1.jsp -> failed! SQL = " + sql33);
//        }
        %>
        
    <%if(!"aavg21".equals(workno.toLowerCase())){
        if("vp".equals(paramsArray[9])){
    %>
            if($("#F10328") != null){
                $("#F10328").attr("readOnly",true);
                $("#F10328").addClass("InputGrey");
            }
    <%
        }
    }%>
		}

/*2015/9/16 9:56:27 gaopeng R_CMI_HLJ_guanjg_2015_2405555@������ҵӦ����������ƷBOSSϵͳ����վ�����ĺ��������հ���
	��������Ϣ �����б��������
*/		
function LLTypeSelChg(){
	var LLTypeSel = $("select[name='LLTypeSel']").find("option:selected").val();
	if("LL" == "<%=paramsArray[9]%>"){
		$("td[name^='liuliangB']").each(function(){
						var LLType = $(this).attr("LLtype");
						var hideTrObj = $(this).parent();
						if(LLType == "1" || LLType == "0" || LLType == "2" || LLType == "3"){
							if(LLType == LLTypeSel){
								hideTrObj.show();
							}else{
								hideTrObj.hide();
							}
						}
						
		});
	}
	
}

function doProcess(packet)
{
    var retType = packet.data.findValueByName("retType");
    var retCode = packet.data.findValueByName("retCode");
    self.status="";
     if(retType == "checkPwd") //���ſͻ�����У��
     {
        if(retCode == "000000")
        {
            var retResult = packet.data.findValueByName("retResult");
            if (retResult == "false") {
    	    	rdShowMessageDialog("�ͻ�����У��ʧ�ܣ����������룡",0);
	        	frm.userPassword.value = "";
	        	frm.userPassword.focus();
    	    	return false;	        	
            } else {
                rdShowMessageDialog("�ͻ�����У��ɹ���",2);
                document.frm.sysnote.value ="���Ų�Ʒ���ϱ��"+document.frm.idcMebNo.value;
                document.frm.tonote.value = "���Ų�Ʒ���ϱ��"+document.frm.idcMebNo.value;
                document.frm.next.disabled = false;
            }
         }
        else
        {
            rdShowMessageDialog("�ͻ�����У�������������У�飡");
    		return false;
        }
     }	
	 if(retType == "check_no") //�����û�����
     {
        if(retCode == "000000")
        {
            var tmp_fld = packet.data.findValueByName("tmp_fld");
            if (tmp_fld == "false") {
    	    	rdShowMessageDialog("�����û�����У��ʧ�ܣ����������룡",0);
    	    	return false;	        	
            } else {
				GetIdcMebNo();
            }
         }
        else
        {
			var retMsg = packet.data.findValueByName("retMsg");
            rdShowMessageDialog(retMsg);
			document.frm.grpOutNo.focus();
    		return false;
        }
     }
	 if(retType == "getCheckInfo")
	{   //�õ�֧Ʊ��Ϣ
        var obj = "checkShow"; 
        if(retCode=="000000")
    	{
            var bankCode = packet.data.findValueByName("bankCode");
            var bankName = packet.data.findValueByName("bankName");
            var checkPrePay = packet.data.findValueByName("checkPrePay");
            if(checkPrePay == "0.00"){
                frm.bankCode.value = "";
                frm.bankName.value = "";                
                frm.checkNo.focus();
                document.all(obj).style.display = "none";
                rdShowMessageDialog("��֧Ʊ���ʻ����Ϊ0��");
            }
            else {   
					document.all(obj).style.display = "";            
			        frm.bankCode.value = bankCode;
					frm.bankName.value = bankName;
		            frm.checkPrePay.value = checkPrePay;
					if(frm.real_handfee.value==''){//add
						frm.checkPay.value='0.00';
					}
					else
					{
					    frm.checkPay.value = frm.real_handfee.value;
					}
			}
		}
    	else
    	{
    		frm.checkNo.value = "";
            frm.bankCode.value = "";
            frm.bankName.value = "";
            document.all(obj).style.display = "none"; 
            frm.checkNo.focus();
    	    retMessage = retMessage + "[errorCode9:" + retCode + "]";
    		rdShowMessageDialog(retMessage,0);               		
			return false;
    	}	
	}
	 //ȡ��ˮ
	if(retType == "getSysAccept")
     {
        if(retCode == "000000")
        {
            var sysAccept = packet.data.findValueByName("sysAccept");
			document.frm.login_accept.value=sysAccept;
			/*
			var prtFlag=0;
			//prtFlag = rdShowConfirmDialog("�Ƿ��ӡ���������");
			//�ύ��ӡ����		
			if (prtFlag==1) {
			var printPage="<%=request.getContextPath()%>/npage/s3691/sGrpPubPrint.jsp?op_code=3517"
														+"&phone_no=" +document.all.idcMebNo.value       
														+"&function_name=���Ų�Ʒ���ϱ��"   
														+"&work_no="+"<%=workno%>"        
														+"&cust_name="+document.all.custName.value     
														+"&login_accept="+document.all.login_accept.value 
														+"&idIccid=" +"<%=iccid%>"       
														+"&hand_fee=" +document.all.real_handfee.value       
														+"&mode_name="+document.all.smName.value       
														+"&custAddress="+document.all.custAddr.value     
														+"&system_note="+document.all.sysnote.value     
														+"&op_note="+document.all.tonote.value          
														+"&space="           
														+"&copynote="
														+"&pay_type=";

		   var printPage2 = window.open(printPage,"","width=200,height=200")
		   
	    } 
	    	*/
	    	/* begin update ͳһ�����ʽ for ��ҵӦ���������������׼�¼����������ֱ���������@2015/4/16 */
	    	
	    	
	    	
		    var ret = showPrtDlg1("Detail","ȷʵҪ���е��������ӡ��","Yes");
				if(typeof(ret)!="undefined")
				{
					if((ret=="confirm"))
					{
						if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
						{
							doCfm();
						}
					}
					if(ret=="continueSub")
					{
						if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
						{
							doCfm();
						}
					}
				}
				else
				{
					if(rdShowConfirmDialog('ȷ��Ҫ�ύ��Ϣ��')==1)
					{
						doCfm();
					}
				}
				/* end update ͳһ�����ʽ for ��ҵӦ���������������׼�¼����������ֱ���������@2015/4/16 */
      }
        else
        {
                rdShowMessageDialog("��ѯ��ˮ����,�����»�ȡ��");
				return false;
        }
	 }
}

	function doCfm(){
		var confirmFlag=0;
		confirmFlag = rdShowConfirmDialog("�Ƿ��ύ���β�����");
		if (confirmFlag==1) {
		 //����ӡ��Ҫ����Ӧ����
		  spellList();
		  

		  $("#sure").attr("disabled",true);
		  $("input:text:disabled").attr("disabled",false);
			$("select:disabled").attr("disabled",false);
		  frm.action="f3691_2.jsp";
			frm.method="post";
		  frm.submit();
		  loading();
		}
	}


	function changePayType(){
		if (document.all.checkPayTR.style.display=="none"){
			document.all.checkPayTR.style.display="";
		}
		else {
			document.all.checkPayTR.style.display="none";
		}
	}
	function getBankCode()
	{ 
	  	//���ù���js�õ����д���
	    if(frm.checkNo.value.trim()== "")
	    {
	        rdShowMessageDialog("������֧Ʊ���룡",0);
	        frm.checkNo.focus();
	        return false;
	    }
	    var getCheckInfo_Packet = new AJAXPacket("getBankCode.jsp","���ڻ��֧Ʊ�����Ϣ�����Ժ�......");
		getCheckInfo_Packet.data.add("retType","getCheckInfo");
	    getCheckInfo_Packet.data.add("checkNo",document.frm.checkNo.value);
		core.ajax.sendPacket(getCheckInfo_Packet);
		getCheckInfo_Packet=null; 
	 }
	function check_HidPwd()
	{
	    var idNo = document.frm.grpIdNo.value;
	    var Pwd1 = document.frm.userPassword.value;
	    var checkPwd_Packet = new AJAXPacket("pubCheckPwdIDC.jsp","���ڽ�������У�飬���Ժ�......");
	    checkPwd_Packet.data.add("retType","checkPwd");
		checkPwd_Packet.data.add("idNo",idNo);
		checkPwd_Packet.data.add("Pwd1",Pwd1);
		core.ajax.sendPacket(checkPwd_Packet);
		checkPwd_Packet=null;	
		
	}
	 //��һ��
	function nextStep(){
		
		
		
		
		
		if(frm.grpIdNo.value.trim() == "")
	  {
	      rdShowMessageDialog("�����뼯���û����룡");
	      frm.grpIdNo.focus();
	      return false;
	  }
	  	//liujian 2013-1-24 14:10:16 ���ڿ�������ʽ��������BOSSϵͳ����ĺ�
		//���Ų�Ʒҵ��Ψһ��ʶ==214 && �������==1 ����ת������ű��ҳ��
		if($('#uniqueStatus').val() == '214' && $('#changeType').val() == '1') {
			frm.action="f3691_numberChange.jsp?opCode=<%=opCode%>&opName=<%=opName%>";
			frm.method="post";
			frm.submit();
			frm.next.disabled=true;//add
		}else {
			frm.action="f3691_1.jsp?action=query";
			frm.method="post";
			frm.submit();
			frm.next.disabled=true;//add
		}
	}
	//��һ��
	function previouStep(){
		frm.action="f3691_1.jsp";
		frm.method="post";
		frm.submit();
	}
	//��ӡ��Ϣ
	function printInfo(printType)
	{
	     var retInfo = "";
	    //getChinaFee(frm1104.sumPay.value);
	    if(printType == "Detail")
	    {	//��ӡ�������
	        retInfo+=document.frm.idcMebNo.value+"|"+"֤������"+"|";
			retInfo+="<%=new java.text.SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(new java.util.Date())%>"+"|";
			retInfo = retInfo + "15|10|10|0|" +document.frm.idcMebNo.value+ "|";   //�ֻ���	
	        retInfo = retInfo + "5|19|9|0|" + "���Ų�Ʒ���ϱ����ҵ��Ʊ��" + "|"; //ҵ����Ŀ    
	 	}  
	 	return retInfo;	
	}
	//��ʾ��ӡ�Ի���
	function showPrtDlg(printType,DlgMessage,submitCfm)
	{  
	   var h=150;
	   var w=350;
	   var t=screen.availHeight/2-h/2;
	   var l=screen.availWidth/2-w/2;
	   var printStr = printInfo(printType);
	   if(printStr == "failed")
	   {    return false;   }
	   var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no"
	   var path = "gdPrint.jsp?DlgMsg=" + DlgMessage;
	   var path = path + "&printInfo=" + printStr + "&submitCfm=" + submitCfm;
	   var ret=window.showModalDialog(path,"",prop);
	}
	
	function showPrtDlg1(printType,DlgMessage,submitCfm)
	{  //��ʾ��ӡ�Ի��� 
		var h=210;
		var w=400;
		var t=screen.availHeight/2-h/2;
		var l=screen.availWidth/2-w/2;
		var pType="subprint";
		var billType="1";  
		
		var smCode = '<%=paramsArray[9]%>';
		
		var printStr = "";
		if(smCode=="IC"){
		 printStr = printInfo_IC(printType);
		}else{
			printStr = printInfo1(printType);
		}
	   
		var mode_code=null;
		var fav_code=null;
		var area_code=null;
		var phoneNo = null;
		var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no"; 
		var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_dz.jsp?DlgMsg=" + DlgMessage;
		path = path  + "&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+document.frm.login_accept.value+"&phoneNo="+phoneNo+"&submitCfm=" + submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
		var ret=window.showModalDialog(path,printStr,prop);
		return ret;
	}
	
	
	function printInfo_IC(printType)
	{
		var cust_info="";
		var opr_info="";
		var note_info1="";
		var note_info2="";
		var note_info3="";
		var note_info4="";
		
		var retInfo = "";
		 
		cust_info+="֤�����룺"+"<%=iccid%>"+"|";
		cust_info+="���ſͻ����ƣ�"+document.all.custName.value+"|";
		cust_info+="�����û���ţ�"+document.all.idcMebNo.value+"|";
		
<%
	String ic_vPayType = "";
	String vPayTypeSql = "select bill_type,user_no from dgrpusermsg t where t.id_no =:grpIdNo";
	String vPayTypeSql_grpIdNo = "grpIdNo="+grpIdNo;
%>		
  <wtc:service name="TlsPubSelCrm" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=vPayTypeSql%>" />
		<wtc:param value="<%=vPayTypeSql_grpIdNo%>" />	
	</wtc:service>
	<wtc:array id="result_vPayType" scope="end"  />
	
<%
	if(result_vPayType.length>0){
		ic_vPayType = result_vPayType[0][0]; 
	}
	
%>	
		var vPayType = "<%=ic_vPayType%>";
    var vPayTypeTxt = "";
    if(vPayType == "0"){
        vPayTypeTxt = "�ֽ�";
    }else{
        vPayTypeTxt = "֧Ʊ";
    }
    
  	opr_info += "���ʽ��   "+ vPayTypeTxt +"|";
    opr_info += "�����˺ţ�   "+ document.frm.idcMebNo.value +"|";
    
    opr_info += "����ҵ��   "+ "���Ų�Ʒ���ϱ��" +"|";
    opr_info += "������ˮ��   "+ document.all.login_accept.value+"|";
    opr_info += "�����Ʒ��   <%=paramsArray[3]%>|";
		
		opr_info += "������Ϣ��|"
    opr_info += "        ICTҵ�񼯳ɷ� "+$("#F10980").val()+"Ԫ|";
		opr_info += "        ICT������Ϣ�����ɷ� "+$("#F10981").val()+"Ԫ|";
		
		note_info1+="��ע��"+document.all.sysnote.value+"|";
	
		retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
		retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
	  return retInfo;
	}
	
	
	function printInfo1(printType)
	{
		var cust_info="";
		var opr_info="";
		var note_info1="";
		var note_info2="";
		var note_info3="";
		var note_info4="";
		
		var retInfo = "";
		 
		cust_info+="֤�����룺"+"<%=iccid%>"+"|";
		cust_info+="���ſͻ����ƣ�"+document.all.custName.value+"|";
		cust_info+="�����û���ţ�"+document.all.idcMebNo.value+"|";
		
		opr_info+="����ҵ��"+"���Ų�Ʒ���ϱ��"+"|";
		opr_info+="������ˮ��"+document.all.login_accept.value+"|";
		var arr=[10681,10682,10683,10762,10763,10764,10765,10766,10767,10778,10822,10823,10824,10830,10831,10832];
		for(var j=0;j<arr.length;j++){
			var packFieldCode = "F"+arr[j];
			if(typeof($("#"+packFieldCode).val()) != "undefined"){
				if($("#"+packFieldCode).val().trim() > 0){
					var packFieldName = $("#"+packFieldCode).parent().parent().find("td").eq(2).text();
					if(packFieldName.indexOf("����") != -1){
						packFieldName = packFieldName.substring(0,packFieldName.length-2);
						opr_info+="������������λ��"+packFieldName+"��";
						$("select[name='F10685']").each(function(){ //��Ϊ���ͷ���ʱ��������Ĭ�����ͱ���һ����ʾ
							if($(this).val() == "F"){
								opr_info+="�����ײͰ�������"+$("#"+packFieldCode).val().trim()+"��";
								var packAcquiescentScale = $("#"+packFieldCode).parent().parent().find("td").eq(5).find("input").val();
								packAcquiescentScale = Math.round(packAcquiescentScale*100)+"%";
	        			opr_info+="����������"+packAcquiescentScale+"��"+"|";
	        		}else{ 
	        			opr_info+="�����ײͰ�������"+$("#"+packFieldCode).val().trim()+"��"+"|";
	        		}
						});
					}
				}			
			}
		}
		
		note_info1+="��ע��"+document.all.sysnote.value+"|";
	
		retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
		retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
	  return retInfo;
	}

	function getSi()
    { 
        if((frm.FPAYSI.value).trim() == "")
        {
            rdShowMessageDialog("���������Si��");
            frm.FPAYSI.focus();
            return false;
        }
        var path = "<%=request.getContextPath()%>/npage/s3690/getSi.jsp";    
        path = path + "?pay_si=" + document.frm.FPAYSI.value;
        retInfo = window.open(path,"newwindow","height=450, width=650,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
        return true;
    }
	//ȡ��ˮ
	function getSysAccept()
	{
		var getSysAccept_Packet = new AJAXPacket("pubSysAccept.jsp","�������ɲ�����ˮ�����Ժ�......");
		getSysAccept_Packet.data.add("retType","getSysAccept");
		core.ajax.sendPacket(getSysAccept_Packet);
		getSysAccept_Packet=null;
	}
	
	function check_mnguser()//��֤����Ա�ʻ�
{    
	 if(((document.frm.F10303.value).trim()) == "")
    {
        rdShowMessageDialog("����Ա�û�����Ϊ�գ�");
        return false;
    } 
    var checkPwd_Packet = new AJAXPacket("../s3690/CheckMng_user.jsp","���ڽ�������У�飬���Ժ�......");
    checkPwd_Packet.data.add("retType","CheckMng_user");
	  checkPwd_Packet.data.add("orgCode","<%=org_code%>");
	  checkPwd_Packet.data.add("LoginNo","<%=workno%>");
	  checkPwd_Packet.data.add("op_code",document.frm.op_code.value);
	  checkPwd_Packet.data.add("Mng_user",document.frm.F10303.value);
	  core.ajax.sendPacket(checkPwd_Packet);
	  checkPwd_Packet = null;
}

	function refMain(param){




	/*
	 * hejwa 2017/3/18 ������ 11:14:24
	 * �����Ż�ר�߲�Ʒ����ͳ�����ݵ�����
	 * רƱԭ���޷�Ԥ���ѣ�ѡ���ǡ�������ͬԤ�������ڡ��������ѡ��񡰺�ͬԤ�������ڡ���������Կ��Բ��ô�ֵ��
	 */
	if(typeof($('#F10999'))!="undefined"&&typeof($('#F10999').val())!="undefined"){
		if(typeof($('#F11000'))!="undefined"&&typeof($('#F11000').val())!="undefined"){
				
				if($('#F10999').val()=="Y"){
					if($('#F11000').val()==""){
						rdShowMessageDialog("�������ͬԤ��������");
						return;
					}
				}else{
					//ѡ���ʱ�����Ϊ��
					$('#F11000').val("");
				}

		}
	}

	
	
			
		if(typeof($("input[name='F10984']").val()) != "undefined" && "<%=flag_10635%>"!="0" ){
				rdShowMessageDialog("����ϵA�˵������ơ�A�˽�����������ԣ��ٽ��б�������");
				return;
		}
		
		
		if (typeof ($("#F10984").val())!="undefined" )
		{
			var retflag = true;
			$("input[name='F10984']").each(function(){
				
				var vF810311 = $.trim($(this).val());
				if(vF810311.length!=0){
		    	
		    	var vF81031 = $.trim($(this).val());
		    	
					var m = /^\d+(\.\d{2})?$/;
					var flag = m.test(vF81031);
					if(!flag){
						rdShowMessageDialog("A�˽������,������0��1��С��������ȷ��С�������λ��");
						retflag = false;
						$(this).focus();
						return false;
					}
					if(vF81031 > 1 || vF81031 < 0){
						rdShowMessageDialog("A�˽����������Ϊ0-1֮���С����");
						retflag = false;
						$(this).focus();
						return false;
					}
		    	
		    	
				}
				
			});
			if(!retflag){
				return false;
			}
		}
			
	/**
	 * �����ƶ���������ҵ��BOSS���ܿ�������ĺ�
	 * hejwa add 3690 ��3691 ��ѯ���Ų�Ʒ����֮�� �����������Ϊ38 ����ҪУ�������ֵ�Ƿ�Ϊ�����ʽ
	 * ��̨��Ա �� haoyy
	 **/
	if(typeof($('#F10749'))!="undefined"&&typeof($('#F10749').val())!="undefined"){
		if($('#F10749').val().trim()==""){
				rdShowMessageDialog("����Ա���������ַ����Ϊ��!",0);
				$('#F10749').focus();
		    return false;	
		}else{
			if($('#F10749').attr("datatype")==38){
				if(!forMail(document.frm.F10749)){ 
					return false;
				}
			}
		}
	}
		$(".pattern_tr").remove(); 
		
		
		/*���������������ſͻ���Ϣ����Ŀ(��Ʒ)Ͷ�ʺ������Զ���ƥ�䱨���ĺ�
		* liangyl 2016-07-11
		* F10985
		*/
		
		if(typeof($('#F10985'))!="undefined"&&typeof($('#F10985').val())!="undefined"){
			ajax_check_F10985();
			if($("#F10985").val()!=""&&F10985_flag==0){
				return;
			}
		}
		
		
		
		/* begin add for ��ҵӦ��������BOSSϵͳ�������@2014/9/13 */
		if(typeof($('#F10776'))!="undefined"&&typeof($('#F10776').val())!="undefined"){
			if($('#F10776').val().trim()==""){
				rdShowMessageDialog("�ͻ��绰����Ϊ��!",1);
				$('#F10776').focus();
		    return false;	
			}
		}
		var chk_acquiescentScale = true;
		if($("td[name^='acquScaleTd']").css("display") == "block"){ //�������ͱ�������ʾʱ���Ž����ж�
			if (typeof ($("input[name='acquiescentScale']").val())!="undefined" ){
				$("input[name='acquiescentScale']").each(function(){
					$(this).attr("v_type","money");
					if(!checkElement(this)){
						chk_acquiescentScale = false;
						return false;	
					}
					if("<%=workNoLimit%>" == "0"){//û��Ȩ�ޣ����������ͱ�������У��
						var v_fieldCode = $(this).parent().parent().children('td').eq(1).find('input[class=InputGrey]').attr("id");
						v_fieldCode = v_fieldCode.substring(1,v_fieldCode.length);
						
						var v_limitNum = $(this).parent().parent().children('td').eq(3).find('input').val();
												
						if($(this).val() != "" ){
							var checkPwd_Packet = new AJAXPacket("f3691_ajax_getMaxScale.jsp","���ڻ�ȡ������ͱ��������Ժ�......");
					    checkPwd_Packet.data.add("v_fieldCode",v_fieldCode);
						  checkPwd_Packet.data.add("v_limitNum",v_limitNum);
						  checkPwd_Packet.data.add("currValue",$(this).val());
						  checkPwd_Packet.data.add("currObj",$(this));
						  core.ajax.sendPacket(checkPwd_Packet,function(packet){
							  var retCode = packet.data.findValueByName("retCode");
								var retMsg = packet.data.findValueByName("retMsg");
								var v_maxScale = packet.data.findValueByName("v_maxScale");
								var currValue = packet.data.findValueByName("currValue");
								var currObj = packet.data.findValueByName("currObj");
								//alert("currValue = "+currValue+"\nv_maxScale = "+v_maxScale);
								if(parseFloat(currValue) > parseFloat(v_maxScale) ){
									rdShowMessageDialog("���ܴ���������ͱ���ֵ����������д��",0);
			            chk_acquiescentScale = false;
			            return false;	
								}
						  });
						  checkPwd_Packet = null;
						}
					  if(chk_acquiescentScale == false){
					  	$(this).focus();
							return false;
						}
					}
				});
			}
		}
		
		
/*
 * hejwa ����5����Ѯ���ſͻ���CRM��BOSSϵͳ����ĺ�-3-������3691ҳ�����ͱ����ı�������Ȩ�޵�����
 * ��̨��Ա liuming
 * ������������������ѡ�����ͷ���ʱ������ʱ��ѡ��ĸ������������ͱ�������Ϊ�գ�Ϊ���򱨴�����ʾ�û������������ͱ���
 * �����>0 �������� 0-1 С����2λ��0.12
 */
		if($("select[name='F10685']").val()=="F"){
			var F10685_S = "";
			$("input[name='acquiescentScale']").each(function(){
				var v_limitName = $(this).parent().parent().children('td').eq(2).text();//����������
				var v_limitNum  = $(this).parent().parent().children('td').eq(3).find('input').val();//����������
				var v_limitPer  = $(this).parent().parent().children('td').eq(5).find('input').val();//���ͱ���
				
				if(v_limitNum!=""&&parseInt(v_limitNum)>0){
					if(v_limitPer==""||parseFloat(v_limitPer)>=1||parseFloat(v_limitPer)<0){
						F10685_S = v_limitName;
						return false;//����each
					}
				}else{
					$(this).parent().parent().children('td').eq(5).find('input').val("");
				}
			});
			
			if(F10685_S!=""&&chk_acquiescentScale){
				rdShowMessageDialog(F10685_S+"���ͱ�������Ϊ0��1֮��С����2λ��С��",0);
	      return false;	
			}
		}
		
		
		
		if(chk_acquiescentScale == false){
			return false;
		}
		/* end add for ��ҵӦ��������BOSSϵͳ�������@2014/9/13 */
		
		var chk_f00025 = true;
		if($('#F00025').val()=='4'){
			$("select[name='F00042']").each(function(){
				if($(this).val()!='0'){
					rdShowMessageDialog("�㲥���͵�ҵ��,ָ������ֻ��Ϊ�㲥����!",0);
	                chk_f00025 = false ;
	                return false;	
				}
			});
		}
		else if($('#F00025').val()=='1'||$('#F00025').val()=='2'||$('#F00025').val()=='3'){
			$("select[name='F00042']").each(function(){
				if($(this).val()=='0'){
					rdShowMessageDialog("�ǵ㲥����ҵ��ָ�����Ͳ���Ϊ�㲥����!",0);
	                chk_f00025 = false ;
	                return false;	
				}
			});
		}
		if(chk_f00025==false)
		{
			return false;	
		}
		var chk_f00040 = true; 
		$("input[name='F00040']").each(function(){
			
			if($(this).val().length<=3){	
				var one="";
	  			var num_flag="0123456789";	
	  			var i_f00040;
				for(i_f00040 = 0;i_f00040<$(this).val().length;i_f00040++)
				{ 
					one=$(this).val().charAt(i_f00040);
					if(num_flag.indexOf(one)<0){
						break;	
					}	
				}
				if(i_f00040==$(this).val().length)
				{
					rdShowMessageDialog("������������������Ϊ��λ���ڵ����֣�",0);
					chk_f00040 = false ;
		            return false;	
				}
			}
			
			if($(this).val().toUpperCase().indexOf('SIM')==0||
				$(this).val().toUpperCase().indexOf('0000')==0||
				$(this).val().toUpperCase().indexOf('00000')==0||
				$(this).val().toUpperCase().indexOf('11111')==0||
				$(this).val().toUpperCase().indexOf('CX')==0||
				$(this).val().toUpperCase().indexOf('HELP')==0
			){
				rdShowMessageDialog("�������������������������ַ���ͷ��SIM��0000��00000��11111��CX��HELP�Լ�0��1����λ���ڵ����֣������ִ�Сд����",0);
				chk_f00040 = false ;
	            return false;	
			}
		});
		if(chk_f00040==false)
		{
			return false;	
		}
		/*liujian 2013-1-30 11:11:19*/ 
		if('<%=paramsArray[9]%>' == 'hj' && '<%=paramsArray[10]%>'=='214'){	
			if(!$('#provSelect').val())	{
				rdShowMessageDialog("��ѡ����ҵ���ڵع̻����ţ�",0);
				return false;
			}
			if(!$('#citySelect').val())	{
				rdShowMessageDialog("��ѡ����ҵ���ڵع̻����ţ�",0);
				return false;
			}
		}
		/*2013/11/29 14:31:56 gaopeng �ƶ��������� 81026ֻ�����ƶ����� start*/
		if ( typeof ($("#F81026").val())!="undefined" )
		{
			document.all.F81026.v_type = "smobilePhone";
			if(!checkElement(document.all.F81026)){
				return false;
			}
		}
		/*2013/11/29 14:31:56 gaopeng �ƶ��������� 81026ֻ�����ƶ����� end*/
		
		/*2014/01/17 15:38:50 gaopeng ��������ҵ������ 81031����Ա�������Ϊ��ĸ�����ֵ���� start*/
		if (typeof ($("#F81031").val())!="undefined" )
		{
			var vF81031 = $.trim($("#F81031").val());
			var m = /^([0-9A-Za-z]*)$/;
			var flag = m.test(vF81031);
			if(!flag){
				rdShowMessageDialog("����Ա������������֡���ĸ��ɣ�");
				return false;
			}
		}
	/*2014/01/17 15:38:50 gaopeng ��������ҵ������ 81031����Ա�������Ϊ��ĸ�����ֵ���� end*/
	
		
			if (typeof ($("#F10835").val())!="undefined" )
		{
			var timess = $.trim($("#F10835").val());
			var jintiantimess="<%=dateStr22%>";
		
		if(timess!="") {
		 	if (timess <= jintiantimess) {
		 	   rdShowMessageDialog("�����·�ʱ�������ڵ�ǰʱ�䣡");
		 	   return false;
		 	}
	 	}
	 	
		}
		
			if (typeof ($("#F10836").val())!="undefined" )
		{
			var vF10836 = $.trim($("#F10836").val());
		
		if(!checkElement(document.all.F10836)){
				return false;
		}
		
		if(vF10836 !="" && $("#F10835").val().trim() =="") {
		 	   rdShowMessageDialog("�������Ѷ�������������������Ѷ���ʱ�䣡");
		 	   return false;		
		}
	 	
		}
		
		
		
		if (document.all.qryFlag.value=="qryCptCpm")/*��ͬЭ���޸�*/
		{
			if (document.all.prodRight.value=="1")
			{
				rdShowMessageDialog("�ù���û��Ȩ�޽����޸�!",0);
				return false;
			}
			
			if ( document.all.cntNo.value.len()<10 )
			{
				rdShowMessageDialog("��Ŀ��ͬ��ű�����10λ!",0);
				return false;
			}	
			
			if (!document.all.cptNo.value.trim()=="")
			{
					if ( document.all.cptNo.value.len()<10  )
					{
						rdShowMessageDialog("��ƷЭ���ű�����10λ!",0);
						return false;
					}	
			}

		    document.frm.action="f3691UpdCnttCpt.jsp";
			document.frm.method="post";
		    document.frm.submit();
		}
		
		if (document.all.qryFlag.value=="proProgress")/*��Ʒ��չ�����޸�*/
		{
		    document.frm.action="f3691ProAttrUpdate.jsp";
			  document.frm.method="post";
		    document.frm.submit();
		}
		
	    document.all.opCodeFlag.value=param;
		getAfterPrompt();
			<%
			if (qryFlag.equals("qryCust"))
			{
				%>
				if(!checkDynaFieldValues(true))
					return false;
				<%
			}
			%>
		
			
    	    if("<%=paramsArray[9]%>" == "vp"){
    		    //��������ҵ����ʼ����
    		    var vSrvStart = document.frm.srv_start.value;
    		    var vF10330 = document.frm.F10330.value;
    		    
    		    if(document.frm.srv_start.value >= document.frm.F10330.value){
    		    	rdShowMessageDialog("��������ҵ����ʼ����!!",0);
    		    	document.frm.F10330.select();
    		    	return false;
    		    }
    	    }
			//if(!checkDynaFieldValues2(true))
			<%
			if (qryFlag.equals("qryCust"))
			{
				%>
				if (!calcAllFieldValues())
					return false;
				<%
			}
			%>

	        if(!check(document.frm)){
            	return false;			
            }

			var checkFlag; //ע��javascript��JSP�ж���ı���Ҳ������ͬ,���������ҳ����.
			//�жϽ��
			/*if(!checkElement("real_handfee")) return false;
	        if (parseFloat(document.frm.real_handfee.value)>parseFloat(document.frm.should_handfee.value))
	        {
					rdShowMessageDialog("ʵ�������Ѳ�Ӧ����Ӧ��������");
					document.frm.real_handfee.focus();
					return false;	
	        }
			if (parseFloat(document.frm.checkPay.value)!=parseFloat(document.frm.real_handfee.value))
	        {
					rdShowMessageDialog("֧Ʊ����Ӧ����ʵ��������");
					document.frm.checkPay.focus();
					return false;	
	        }
			if (parseFloat(document.frm.checkPay.value)>parseFloat(document.frm.checkPrePay.value))
	        {
					rdShowMessageDialog("֧Ʊ����ӦС��֧Ʊ���");
					document.frm.checkPay.focus();
					return false;	
	        }
			if (parseFloat(document.frm.should_handfee.value)==0)
			{
				document.frm.real_handfee.value="0.00";
			}*/
			//˵�������ֳ�����,һ���������Ƿ��ǿ�,��һ���������Ƿ�Ϸ�
			
			
		if (typeof ($("#F10980").val())!="undefined" ){
			v_F10980 = $("#F10980").val();
			
			if(v_F10980.indexOf(".")==-1){
				$("#F10980").val($("#F10980").val()+".00");
			}else{
				var t_arr = v_F10980.split(".");
				if(t_arr[1].length!=2){
					rdShowMessageDialog("ICTҵ�񼯳ɷѾ�ȷ��С����2λ");
					return;
				}
			}
			
			
			if(parseInt(v_F10980)<0){
				rdShowMessageDialog("ICTҵ�񼯳ɷѲ������븺��");
				return;
			}
			
		}
		
		if (typeof ($("#F10981").val())!="undefined" ){
			
			v_F10981 = $("#F10981").val();
			
			if(v_F10981.indexOf(".")==-1){
				$("#F10981").val($("#F10981").val()+".00");
			}else{
				var t_arr = v_F10981.split(".");
				if(t_arr[1].length!=2){
					rdShowMessageDialog("ICT������Ϣ�����ɷѾ�ȷ��С����2λ");
					return;
				}
			}
			
			
			if(parseInt($("#F10981").val())<0){
				rdShowMessageDialog("ICT������Ϣ�����ɷѲ������븺��");
				return;
			}
		}
		
		
			getSysAccept()
	}
	//�жϼ����û������Ƿ����
	function GetIdcMebNo2()
	{
		var my_Packet = new AJAXPacket("fpubcheck_no.jsp","���ڼ��鼯���û����룬���Ժ�......");
		my_Packet.data.add("grpOutNo",document.frm.grpOutNo.value);
		my_Packet.data.add("retType","check_no");
		core.ajax.sendPacket(my_Packet);
		my_Packet=null
	}
	//������ײ�
	function GetIdcMebNo()
	{
		var pageTitle = "IDC��Ա�����ѯ";
	    	var fieldName = "��Ա�û�ID|��Ա����|ҵ������";
		var sqlStr = "select member_id,member_no,e.sm_name"
	              +"  from dGrpUserMebMsg a,dGrpUserMsg b,dAccountIdInfo c,"
	              +" sBusiTypeSmCode d,sSmCode e"
	              +" where a.id_no=b.id_no"
	              +" and b.user_no=c.msisdn"
	              +" and b.sm_code=c.service_type"
	              +" and c.service_no='"+document.frm.grpOutNo.value+"'"
	              +" and c.service_type=d.sm_code"
	              +" and c.service_type=e.sm_code"
	              +" and e.region_code='"+document.frm.OrgCode.value.substring(0,2)+"'";
		var selType = "S";    //'S'��ѡ��'M'��ѡ
		var retQuence = "1|1";
		var retToField = "idcMebNo";
		var returnNum="3";
		PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,returnNum);
	}

	//���ù������棬���м��ſͻ�ѡ��
	function getCptCpmIfo(flag)
	{
 if (flag == '2'){
		  document.all.qryFlag.value="proProgress";
	  } else {
	    document.all.qryFlag.value="qryCptCpm";
	  }
	    var pageTitle = "���ſͻ�ѡ��";
	    var fieldName = "֤������|�ͻ�ID|�ͻ�����|�û�ID|�û���� |�û�����|��Ʒ����|��Ʒ����|���ű��|�����ʻ�|Ʒ������|Ʒ�ƴ���|";
		var sqlStr = "";
	    var selType = "S";    //'S'��ѡ��'M'��ѡ
	    var retQuence = "12|0|1|2|3|4|5|6|7|8|9|10|11|";
	    var retToField = "iccid|cust_id|cust_name|grpIdNo|user_no|grp_name|product_code2|product_name2|unit_id|account_id|sm_name|sm_code|";
	    var cust_id = document.frm.cust_id.value;
	    if(document.frm.iccid.value == "" &&
	       document.frm.cust_id.value == "" &&
	       document.frm.unit_id.value == "" &&
	       document.frm.user_no.value == "")
	    {
	        rdShowMessageDialog("������֤�����롢�ͻ�ID�����ű�Ż��źŽ��в�ѯ��",0);
	        document.frm.iccid.focus();
	        return false;
	    }
	
	    if(document.frm.cust_id.value != "" && forNonNegInt(frm.cust_id) == false)
	    {
	    	frm.cust_id.value = "";
	        rdShowMessageDialog("���������֣�",0);
	    	return false;
	    }
	
	    if(document.frm.unit_id.value != "" && forNonNegInt(frm.unit_id) == false)
	    {
	    	frm.unit_id.value = "";
	        rdShowMessageDialog("���������֣�",0);
	    	return false;
	    }
	
	    if(document.frm.user_no.value == "0")
	    {
	    	frm.user_no.value = "";
	        rdShowMessageDialog("���źŲ���Ϊ0��",0);
	    	return false;
	    }
	
	    PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField); 
	}

	function getInfo_Cust()
	{
			document.all.qryFlag.value="qryCust";
	    var pageTitle = "���ſͻ�ѡ��";
	    var fieldName = "֤������|�ͻ�ID|�ͻ�����|�û�ID|�û���� |�û�����|��Ʒ����|��Ʒ����|���ű��|�����ʻ�|Ʒ������|Ʒ�ƴ���|";
		var sqlStr = "";
	    var selType = "S";    //'S'��ѡ��'M'��ѡ
	    var retQuence = "12|0|1|2|3|4|5|6|7|8|9|10|11|";
	    var retToField = "iccid|cust_id|cust_name|grpIdNo|user_no|grp_name|product_code2|product_name2|unit_id|account_id|sm_name|sm_code|";
	    var cust_id = document.frm.cust_id.value;
	    if(document.frm.iccid.value == "" &&
	       document.frm.cust_id.value == "" &&
	       document.frm.unit_id.value == "" &&
	       document.frm.user_no.value == "")
	    {
	        rdShowMessageDialog("������֤�����롢�ͻ�ID�����ű�Ż��źŽ��в�ѯ��",0);
	        document.frm.iccid.focus();
	        return false;
	    }
	
	    if(document.frm.cust_id.value != "" && forNonNegInt(frm.cust_id) == false)
	    {
	    	frm.cust_id.value = "";
	        rdShowMessageDialog("���������֣�",0);
	    	return false;
	    }
	
	    if(document.frm.unit_id.value != "" && forNonNegInt(frm.unit_id) == false)
	    {
	    	frm.unit_id.value = "";
	        rdShowMessageDialog("���������֣�",0);
	    	return false;
	    }
	
	    if(document.frm.user_no.value == "0")
	    {
	    	frm.user_no.value = "";
	        rdShowMessageDialog("���źŲ���Ϊ0��",0);
	    	return false;
	    }
	
	    PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField); 
	}

	function PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
	{
	    var path = "<%=request.getContextPath()%>/npage/s3691/f3691_sel.jsp";
	    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
	    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
	    path = path + "&selType=" + selType+"&iccid=" + document.all.iccid.value;
	    path = path + "&cust_id=" + document.all.cust_id.value;
	    path = path + "&unit_id=" + document.all.unit_id.value;
	    path = path + "&user_no=" + document.all.user_no.value;
	    path = path + "&qryFlag=" + document.all.qryFlag.value;
	    
	
	    retInfo = window.open(path,"newwindow","height=450, width=1000,top=50,left=100,scrollbars=yes, resizable=no,location=no, status=yes");
	
		return true;
	}
	//liujian ����obj��Σ���f3691_sel.jsp����
	function getvaluecust(retInfo,object)
	{
	  var retToField = "iccid|cust_id|cust_name|grpIdNo|user_no|grp_name|product_code2|product_name2|unit_id|account_id|sm_name|sm_code|";
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
	    //liujian 2013-1-24 13:55:59 ���ڿ�������ʽ��������BOSSϵͳ����ĺ�
	    if(object) {
	    	var uniqueStatus = object.uniqueStatus;
	    //	uniqueStatus = '214';
	    	$('#uniqueStatus').val(uniqueStatus);
	    	if(uniqueStatus == '214') {
	    		$('#changeTypeTr').css('display','block');
	    	}else {
	    		$('#changeTypeTr').css('display','none');	
	    	}	
	    }
	    //nextStep()
	}
	function call_flags(){
       var h=580;
       var w=1150;
       var t=screen.availHeight/2-h/2;
       var l=screen.availWidth/2-w/2;
       var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
    	   
    	var str=window.showModalDialog('group_flags.jsp?flags='+document.frm.F10315.value+'&sm_code=<%=paramsArray[9]%>',"",prop);/*diling add for ����Ʒ�Ʋ���@2012/11/6 */
    	   
    	if( str != undefined ){
    		document.frm.F10315.value = str;
    	}
    	return true;
    }
    
    //���ò������·�ʱ����б�
    function setTime()
    {
    	window.open('f2890_setTime.jsp','','width='+(screen.availWidth*1-10)+',height='+(screen.availHeight*1-76) +',left=0,top=0,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no');
    	
    }
    //��������ҵ��ָ��
    function setMO()
    {
    	window.open('f2890_setMo.jsp','','width='+(screen.availWidth*1-10)+',height='+(screen.availHeight*1-76) +',left=0,top=0,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no');
    }
    
function ctrlF10340(selectId)
{
	var f10340txt = "";
	var f10341txt = "";
	if(selectId.value == "11")
	{
		f10340txt = "<select id='F10340' name='F10340' datatype=66 onchange='ctrlF10341(frm.F10340);'>";
		f10340txt = f10340txt + "<option  value='01'>01--��ר��APN</option>";
		f10340txt = f10340txt + "<option  value='00'>00--ר��APN</option>";
		f10340txt = f10340txt + "</select>";
		f10341txt = "<input id='F10341' name='F10341'  class='button' type='hidden' datatype=67  value='0'>&nbsp";
	}
	else
	{
		f10340txt = "<input id='F10340' name='F10340'  class='button' type='hidden' datatype=66  value='0'>&nbsp";
		f10341txt = "<input id='F10341' name='F10341'  class='button' type='hidden' datatype=67  value='0'>&nbsp";
	}
	$("#divF10340").html(f10340txt);
	$("#divF10341").html(f10341txt);

	//divF10340.innerHTML=f10340txt;
	//divF10341.innerHTML=f10341txt;
}


function ctrlF10341(selectId)
{
	var f10341txt = "";
	if(selectId.value == "00")
	{
		f10341txt = "<input id='F10341' name='F10341'  class='button' type='text' datatype=67  value='<%=F10341_selected%>' v_must=1>&nbsp;<font class='orange'>*</font>";
	}
	else
	{
		f10341txt = "<input id='F10341' name='F10341'  class='button' type='hidden' datatype=67  value='0'>&nbsp";
	}
	divF10341.innerHTML=f10341txt;
}

//TD-���񱦣�"ҵ������"���"2G����"�ı������������ 
//ADD by shengzd @ 20090519
function ctrlF10342(selectId)
{
	var f10342txt = "";
	if(selectId.value == "01")
	{
		f10342txt = "<input id='F10344' name='F10344'  class='button' type='text' datatype=72 maxlength=11 value=''>&nbsp"; //�����ص�"2G����"Ĭ��ֵΪ�� 
	}
	else
	{
		f10342txt = "<input id='F10344' name='F10344'  class='button' type='hidden' datatype=72 maxlength=11 value='0'>&nbsp";
	}
	divF10344.innerHTML=f10342txt;
}
function getPersonalInfo(){
    var flag = $('#queryType').val();
    if (flag == '0'){
        getInfo_Cust();
    } else if (flag == '1'){
        getCptCpmIfo();
    } else{
        getCptCpmIfo(flag);
    }
}

/*
 * hejwa ����5����Ѯ���ſͻ���CRM��BOSSϵͳ����ĺ�-3-������3691ҳ�����ͱ����ı�������Ȩ�޵�����
 * ��̨��Ա liuming
 * �жϹ���Ȩ�� �д�Ȩ�޵Ĺ�����3691���Կ�����ѡ�û��Ȩ�ޣ���ֻ�ܿ���������
 */
$(document).ready(function(){
	
	if (typeof ($("#F10984").val())!="undefined" )
		{
			$("input[name='F10984']").each(function(){
				
				var vF810311 = $.trim($(this).val());
				/*ûֵ��ʱ������޸� */
				if(vF810311.length==0){
					$(this).attr("readonly",false);
		    	$(this).attr("disabled","");
		    	$(this).attr("class","");
				}else{
					$(this).attr("readonly",true);
		    	$(this).attr("disabled","disabled");
		    	$(this).attr("class","InputGrey");
					
				}
				
			});
			
		}
	
	var smCode = '<%=paramsArray[9]%>';
	
	if(smCode.trim() == "LL"){
		if(typeof($(this).find('#F10954').val()) != "undefined" ){
			//2=��  1=��
			var F10954_selected = "<%=F10954_selected%>";
			
			if("2"==F10954_selected){
				$(this).find('#F10954').empty();
				$(this).find('#F10954').append("<option selected value='1'>1--��</option><option  value='2' selected>2--��</option>");
			}else{
				/*��ȡȨ��a324*/
				if("<%=have_a324%>" == "true"){
					$(this).find('#F10954').empty();
					$(this).find('#F10954').append("<option selected value='1' selected>1--��</option><option  value='2'>2--��</option>");
				}else{
					$(this).find('#F10954').empty();
					$(this).find('#F10954').append("<option selected value='1'>1--��</option>");
				}
			}
		}
	}
	
		if(smCode.trim() == "JJ"){
		if(typeof($(this).find('#F10957').val()) != "undefined" ){
			//�����ж��������������Դ���Ϊ10957ʱ����Ҫ���������ƺ������Ӻ�ɫ��������
			$(this).find('#F10957').parent().prev().html("���Ѻ����ʱ����<font class='orange'>(9:00-11:00)</font>");
			
			//2=��  1=��
			var F10957_selected = "<%=F10957_selected%>";
			if("2"==F10957_selected){
				$(this).find('#F10957').empty();
				$(this).find('#F10957').append("<option selected value='1'>1--��</option><option  value='2' selected>2--��</option>");
			}else{
				/*��ȡȨ��a324*/
				if("<%=have_a325%>" == "true"){
					$(this).find('#F10957').empty();
					$(this).find('#F10957').append("<option selected value='1' selected>1--��</option><option  value='2'>2--��</option>");
				}else{
					$(this).find('#F10957').empty();
					$(this).find('#F10957').append("<option selected value='1'>1--��</option>");
				}
			}
		}
	}
	if(smCode.trim() == "MM"){
		ctrlF10340(document.getElementById("F10339"));
		var F10340_selected = "<%=F10340_selected%>"
		$("#F10340").val(F10340_selected);
		ctrlF10341(document.getElementById("F10340"));
	}
	
	if("<%=operFlag%>"=="true"){//��Ȩ�ޣ�����
		
	}else{//��Ȩ�ޣ�����һ��ѡ������ͱ�����Ҳ����
		$("select[name='F10685']").find("option[value='F']").remove();
		$("td[name^='acquScaleTd']").css("display","none");
	}
	
	$("select[name='F10833']").change(function(){
		var optionVal = $(this).find("option:selected").val();
		/*���ѡ�����ǣ�ͬʱû��Ȩ��*/
		if("<%=haveA323%>" != "true" && optionVal == "1"){
			rdShowMessageDialog("�ù��Ų����С����Ż��Ѽ��Ͱ�����Ȩ�ޡ�!,ѡ�ÿ���Ƿ����ͳ���10�򡱲�����ѡ��1--�ǡ���");
			$("select[name='F10833']").find("option[value='0']").attr("selected",true);
			return false;
		}
		
	});
	
	
	
	/*
	 * ���ֺ󸶷Ѽ��Ų�Ʒʵ������¼����ſع��ܵ�ҵ������
	 */
		
		var val_F10975 = $("input[name='F10975']").val();
		var val_F10817 = $("select[name='F10817']").val();
		
		
		
		if(val_F10817==""){
			val_F10817 = "12";
		}

		if(val_F10975==""){
			val_F10975 = "<%=db_cu_date%>";
		}

		$("input[name='F10975']").attr("readOnly","readOnly");
		$("input[name='F10975']").addClass("InputGrey");

		var div_obj = $("input[name='F10975']").parent().parent().parent().parent().prev();
		
		if(div_obj.text()=="���û���Ҫ��������"){
			
			val_F10817 = "12";
			val_F10975 = "<%=db_cu_date%>";
			
			$("select[name='F10817']").val(val_F10817);
			$("input[name='F10975']").val(val_F10975);
								
		}
		
		
		$("select[name='F10817']").change(function(){
					  var a_Packet = new AJAXPacket("f3691_ajax_checkF10817.jsp","���Ժ�......");
					  a_Packet.data.add("ID_NO",document.frm.grpIdNo.value);
					  core.ajax.sendPacket(a_Packet,function(packet){
							var ret_val = packet.data.findValueByName("ret_val");
							if(parseFloat(ret_val)>0){
								
								var smCode = '<%=paramsArray[9]%>';
	
								if(smCode.trim() == "RH"){
									//����ʾ
								}else{
			
									rdShowMessageDialog("���˻��Ѿ�Ƿ�ѣ�����������ɷ����ڱ�����뼰ʱ�ɷѣ�");
									$("select[name='F10817']").val(val_F10817);
									$("input[name='F10975']").val(val_F10975);
								}
							}else{
								$("input[name='F10975']").val("<%=db_cu_date%>");
							}
					  });
					  a_Packet = null;
		});
		
		
		
		
		//���� �ſؿ�ʼʱ�� ֻ������ǰʱ�� �ɷ�����Ĭ�ϳ���   
		
		//�޸� �ſؿ�ʼʱ�� ֻ����Ĭ�ϲ������ʱ�䣬û��Ϊ��ǰʱ�䣬�ɷ�����Ĭ�ϲ�ѯ����
		
		
		//3690
		//���� �ſؿ�ʼʱ�� ֻ�����ɷ�����Ĭ�ϳ���
		
		
		
		
		
		
	/*���ڼ���ҵ�������ϵͳʵ������ĺ�-4-����ESOP�����߲�Ʒ��ͬ�������ܵ�����
	 * hejwa 2016-6-8 15:47:44
	 * F10807
	 */
	 if (typeof ($("#F10807").val())!="undefined" ){
	 	$("#F10807").parent().append("&nbsp;<input type='button' class='b_text' value='У��' onclick='ajax_check_F10807()' />"); 
	 }
	 
	 /*���������������ſͻ���Ϣ����Ŀ(��Ʒ)Ͷ�ʺ������Զ���ƥ�䱨���ĺ�
	 * liangyl 2016-07-11
	 * F10985
	 */
	if (typeof ($("#F10985").val())!="undefined" ){
		$("#F10985").parent().append("&nbsp;<input type='button' class='b_text' value='У��' onclick='ajax_check_F10985()' />"); 
	}



<%
	String flag_10980 = "0";
	
	String sql_10980 = "select count(1) from dgrpusermsgadd t where t.id_no = :id_no and t.field_code = '10980'";
	String sql_10980_param = "id_no="+grpIdNo;
%>

  <wtc:service name="TlsPubSelCrm" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=sql_10980%>" />
		<wtc:param value="<%=sql_10980_param%>" />	
	</wtc:service>
	<wtc:array id="result_t10980" scope="end"   />
<%
	if(result_t10980.length>0){
		flag_10980 = result_t10980[0][0];
	}
	
	System.out.println("---s3691-----flag_10980----------->"+flag_10980);
%>	

	var v_F10982 = $('#F10982').val();
	var v_F10983 = $('#F10983').val();
	var v_F10982_v_F10983_flag = 0;
	if(v_F10982!="undefined"&&typeof(v_F10982)!="undefined"){
			$('#F10982').val("<%=date_yyyyMM%>");
			v_F10982_v_F10983_flag++;
	}
	
	if(v_F10983!="undefined"&&typeof(v_F10983)!="undefined"){
			$('#F10983').val("<%=date_yyyyMM%>");
			v_F10982_v_F10983_flag++;
	}
	
	if(v_F10982_v_F10983_flag==2){
		if("<%=flag_10980%>"!="0"){
				var in_html_temp = 
													 "<tr>"+
													 "<td class='blue'>ICTҵ�񼯳ɷ���ʷ</td>"+
													 "<td><input type='text' id='F10980_add' value='"+$('#F10980').val()+"' disabled></td>"+
													 "<td class='blue'>ICT������Ϣ�����ɷ���ʷ</td>"+
													 "<td><input type='text' id='F10981_add'  value='"+$('#F10981').val()+"' disabled></td>"+
													 "</tr>"+
													 "<tr>"+
													 "<td class='blue'>ICTҵ�񼯳ɷ���ʷ����</td>"+
													 "<td><input type='text' id='F10982_add' value='"+v_F10982+"' disabled></td>"+
													 "<td class='blue'>ICT������Ϣ�����ɷ���ʷ����</td>"+
													 "<td><input type='text' id='F10983_add' value='"+v_F10983+"' disabled></td>"+
													 "</tr>";
		
				$('#F10983').parent().parent().append(in_html_temp);
		}		
		$('#F10982').parent().parent().hide();
		
		
		if($('#F10982').val()!=$("#F10982_add").val()){
			$("#F10980").val("0.00");
		}
		
		if($('#F10983').val()!=$("#F10983_add").val()){
			$("#F10981").val("0.00");
		}
		
	}
	
	
	
	if("<%=flag_10635%>"!="0" ){
		$("input[name='F10984']").attr("readOnly","readOnly");
		$("input[name='F10984']").addClass("InputGrey");
	}
	
});
	

function ajax_check_F10807(){
		if($("#F10807").val().trim()==""){
				rdShowMessageDialog("�������ͬ���");
				return;
		}
	  var packet = new AJAXPacket("../s3690/ajax_check_F10807.jsp","���Ժ�...");
        packet.data.add("F10807_val",$("#F10807").val());//
    core.ajax.sendPacket(packet,do_ajax_check_F10807);
    packet =null;	
}
function do_ajax_check_F10807(packet){
    var error_code = packet.data.findValueByName("code");//���ش���
    var error_msg =  packet.data.findValueByName("msg");//������Ϣ

    if(error_code=="000000"){//�����ɹ�
    	var result_count =  packet.data.findValueByName("result_count");
    	if(result_count=="0"){
    		rdShowMessageDialog("����ͬ���롱δ�ɹ��鵵�����������˶Ժ�����¼��");
    		$("#F10807").val("");
    	}
    }else{//���÷���ʧ��
	    rdShowMessageDialog(error_code+":"+error_msg);
    }
} 
/*���������������ſͻ���Ϣ����Ŀ(��Ʒ)Ͷ�ʺ������Զ���ƥ�䱨���ĺ�
* liangyl 2016-07-11
* F10985
*/
var F10985_flag=0;
function ajax_check_F10985(){
	F10985_flag=0;
	if($("#F10985").val()==""){
		F10985_flag=1;
	}
	else{
		var packet = new AJAXPacket("../s3690/ajax_check_F10985.jsp","���Ժ�...");
        packet.data.add("F10985_val",$("#F10985").val());//
    	core.ajax.sendPacket(packet,do_ajax_check_F10985);
   	 	packet =null;	
	}
}
function do_ajax_check_F10985(packet){
    var error_code = packet.data.findValueByName("code");//���ش���
    var error_msg =  packet.data.findValueByName("msg");//������Ϣ
    if(error_code=="000000"){//�����ɹ�
    	var result_count =  packet.data.findValueByName("result_count");
    	if(result_count=="0"){
    		rdShowMessageDialog("�������Ŀ��Ŵ�����˶Ժ���������!");
    	}
    	else{
    		F10985_flag=1;
    	}
    }else{//���÷���ʧ��
	    rdShowMessageDialog(error_code+":"+error_msg);
    }
}

</script>
</HEAD>
<BODY>
	<FORM action="" method="post" name="frm" >
		<%@ include file="/npage/include/header.jsp" %>     	
		<div class="title">
			<div id="title_zi">�����û����ϱ��</div>
		</div>	
		<input type="hidden" name="product_code" value="">
		<input type="hidden" name="product_level"  value="1">
		<input type="hidden" name="op_type" value="1">
		<input type="hidden" name="grp_no" value="0">
		<input type="hidden" name="tfFlag" value="n">
		<input type="hidden" name="chgpkg_day"   value="">
		<input type="hidden" name="TCustId"  value="">
		<input type="hidden" name="unit_name"  value="">
		<input type="hidden" name="login_accept"  value="0"> <!-- ������ˮ�� -->
		<input type="hidden" name="op_code"  value="3691">
		<input type="hidden" name="OrgCode"  value="<%=org_code%>">
		<input type="hidden" name="region_code"  value="<%=regionCode%>">
		<input type="hidden" name="district_code"  value="<%=districtCode%>">
		<input type="hidden" name="WorkNo"   value="<%=workno%>">
		<input type="hidden" name="NoPass"   value="<%=nopass%>">
		<input type="hidden" name="ip_Addr"  value=<%=ip_Addr%>>
		<input type="hidden" name="grpOutNo"   value="">
		<input type="hidden" name="custAddr"   value="">
		<input type="hidden" name="idIccid"   value="">
		<input type="hidden" name="unit_idAdd"   value="<%=unit_id%>">
		<input type="hidden" name="qryFlag"   value="<%=qryFlag%>">



        <TABLE  cellSpacing=0>
<%
            if (action == null){
           %>
          <tr>
            <td class="blue">��ѯ��ʽ</td>
            <td colspan="3">
              <select id="queryType">
                 <option value="0">��Ʒ���Բ�ѯ</option>
                 <option value="1">Э���ͬ��ѯ</option>    
                 <option value="2">��Ʒ��չ������ѯ</option>
              </select>
            </td>
          </tr>
          <%}%>
	    <TR>
	        <TD width="18%" class="blue">
	              ֤������
	        </TD>
            	<TD width="32%">
                <input name=iccid  id="iccid" size="20" maxlength="18" v_type="string" v_must=1  index="1"  value="<%=iccid2%>" 
                <%
                    if (action!=null&&action.equals("query")){
                        out.print(" readOnly class='InputGrey' ");
                    }
                %>
                >
                <input name=custQuery class="b_text" type=button id="custQuery"  
 onKeyUp="if(event.keyCode==13)getPersonalInfo();" onClick="getPersonalInfo();" 
                	style="cursor��hand" value=��ѯ 
                <%
                    if (action!=null&&action.equals("query")){
                        out.print(" disabled ");
                    }
                %>
                >
                     
                
            </TD>
            <TD width="18%" class="blue">���ſͻ�ID</TD>
            <TD width="32%">
             	<input  type="text" name="cust_id" size="20" maxlength="18" v_type="0_9" v_must=1  index="2" value="<%=cust_id2%>"
             	<%
                    if (action!=null&&action.equals("query")){
                        out.print(" readOnly class='InputGrey' ");
                    }
                %>
             	>
            </TD>
          </TR>
          <TR>
            <TD class="blue">
               ���ű��
            </TD>
            <TD>		    
               <input name=unit_id  id="unit_id" size="20" maxlength="10" v_type="0_9" v_must=1  index="3" value="<%=unit_id2%>"
               <%
                    if (action!=null&&action.equals("query")){
                        out.print(" readOnly class='InputGrey' ");
                    }
                %>
               >            
            </TD>
            <TD class="blue" width="18%">���źŻ����������</TD>
            <TD>
              <input  name="user_no" size="20" v_must=1 v_type=string  index="4" value="<%=user_no2%>"
              <%
                    if (action!=null&&action.equals("query")){
                        out.print(" readOnly class='InputGrey' ");
                    }
                %>
              >
            </TD>
          </TR>
          <TR>
	     <TD width=18% nowrap class="blue"> �����û�ID</TD>
             <TD width="32%" >
		<input name=grpIdNo  id="grpIdNo" size="24" maxlength="15" v_type="0_9" v_must=1  index="3" value="<%=grpIdNo%>"
		<%
                    if (action!=null&&action.equals("query")){
                        out.print(" readOnly class='InputGrey' ");
                    }
                %>
		>
		<font class="orange">*</font>
		              <input type="hidden" name="cust_name">
		              <input type="hidden" name="grp_name">
		              <input type="hidden" name="product_code2" value="<%=product_code3%>">
		              <input type="hidden" name="product_name2">
		              <input type="hidden" name="account_id">
		              <input type="hidden" name="sm_name">
		              <input type="hidden" name="sm_code" id="sm_code">
	    </TD> 
		<TD class="blue">���Ų�Ʒ����</TD>
            <TD >
           	<%if(!ProvinceRun.equals("20"))  //���Ǽ���
			  		{
					%>  
                <jsp:include page="/npage/common/pwd_8.jsp">
                <jsp:param name="width1" value="16%"  />
	            <jsp:param name="width2" value="34%"  />
	            <jsp:param name="pname" value="userPassword"  />
	            <jsp:param name="pwd" value="<%=iUserPwd%>"  />
 	            </jsp:include>
          <%}else{%>
 	            <input name=userPassword type="password"  id="custPwd" size="6" maxlength="6" value="<%=iUserPwd%>" v_must=1>
         <%}%>
            <input name=chkPass type=button onClick="check_HidPwd();"  class="b_text" style="cursor��hand" id="chkPass" value=У��>
	    <font class="orange">*</font>
	   </TD>
	</TR>
	<!-- liujian 2013-1-24 14:01:34 ���ڿ�������ʽ��������BOSSϵͳ����ĺ� -->
	<tr id="changeTypeTr" style="display:none">
		<td class="blue">�������</td>
		<input type="hidden" value="" id="uniqueStatus" />
		<td>
			<select id="changeType">
				<option value="0">���Ա��</option>	
				<option value="1">����ű��</option>	
			</select>
		</td>
		<td></td>
		<td></td>
	</tr>
        </TABLE>
	<!---- ���ص��б�-->
        <TABLE  cellSpacing=0  style="display:<%=listShow%>">
	   <TR>
            <TD width="18%" class="blue">
              �����û�����
            </TD>
            <TD width="32%">
                <input name="idcMebNo" class="InputGrey" id="idcMebNo" size="24" maxlength="18" v_type="string" v_must=1  index="1" value="<%=paramsArray[1]%>" readonly>
                <font class="orange">*</font>
            </TD>
	    <TD width=18% class="blue">�ͻ�����</TD>
            <TD width="32%">
              <input name=custName class="InputGrey"  id="custName" size="24" maxlength="10" v_type="0_9" v_must=1  index="3" value="<%=paramsArray[4]%>" readonly>
            </TD>
          </TR>
          <TR>
            <TD width="18%" class="blue">Ʒ������</TD>
            <TD width="32%">
              <input  name="smName" size="24" readonly v_must=1 v_type=string class="InputGrey"  index="4" value="<%=paramsArray[2]%>" readonly>
            </TD>
            <TD class="blue">��Ʒ����</TD>
            <TD>
              <input  name="smName" size="24" readonly v_must=1 v_type=string class="InputGrey"  index="4" value="<%=paramsArray[3]%>" readonly>
            </TD>
          </TR>
          </TABLE>
         
		  
	<%
		System.out.println("$$$$$$$$$$$$$$$$$$$$$$111111");
		//Ϊinclude�ļ��ṩ����
		int fieldCount=paramsOut28.length;
		
		//fieldCount=9;	//add
		boolean isGroup = false;
		String []fieldCodes=new String[fieldCount];
		String []fieldNames=new String[fieldCount];
		String []fieldPurposes=new String[fieldCount];//add
		String []fieldValues=new String[fieldCount];
		String []dataTypes=new String[fieldCount];
		String []fieldLengths=new String[fieldCount];
		String []fieldGrpName=new String[fieldCount];
		String []fieldGrpNo=new String[fieldCount];
		String []fieldMaxRow=new String[fieldCount];
		String []fieldMinRow=new String[fieldCount];
		String []fieldCtrlInfos=new String[fieldCount];
		String []updateFlag=new String[fieldCount];
		String []openFlag=new String[fieldCount];
		String []manyPropertys=new String[fieldCount];
		String userType=paramsArray[9];
		int iField=0;
		while(iField<fieldCount)
		{
			fieldCodes[iField]=paramsOut26[iField][0];
			fieldNames[iField]=paramsOut28[iField][0];
			fieldPurposes[iField]=paramsOut29[iField][0];//add
			fieldValues[iField]=paramsOut27[iField][0];
			dataTypes[iField]=paramsOut30[iField][0];
			fieldLengths[iField]=paramsOut31[iField][0];
			fieldGrpNo[iField]=userFieldGrpNo[iField][0];
			fieldMaxRow[iField]=userFieldMaxRows[iField][0];
			fieldMinRow[iField]=userFieldMinRows[iField][0];
			fieldGrpName[iField]=userFieldGrpName[iField][0];
			fieldCtrlInfos[iField]=userFieldCtrlInfos[iField][0];
			updateFlag[iField]=userUpdateFlag[iField][0];
			openFlag[iField]=openParamFlag[iField][0];
			manyPropertys[iField] = manyPropertyStr[iField][0];
			
			iField++;
		}
	%>
	
	<%
		System.out.println("$$$$$$$$$$$$$$$$$$$$$$111111");
		//Ϊinclude�ļ��ṩ����
		int fieldCount333=liuliangStr.length;
		
		String []liuliangs=new String[fieldCount];
		
		int iField333=0;
		while(iField333<fieldCount333)
		{
			liuliangs[iField333] = liuliangStr[iField333][0];
			iField333++;
		}
	%>
	
		<% //------add by hansen-----
		//Ϊinclude�ļ��ṩ����  
		int fieldCount2=resultListLength2;
		String []fieldCodes2=new String[fieldCount2];
		String []fieldNames2=new String[fieldCount2];
		String []fieldPurposes2=new String[fieldCount2];
		String []fieldValues2=new String[fieldCount2];
		String []dataTypes2=new String[fieldCount2];
		String []fieldLengths2=new String[fieldCount2];
		String []fieldCtrlInfos2=new String[fieldCount2];
		String []openFlagNew=new String[fieldCount2];
		int iField2=0;
		while(iField2<fieldCount2)
		{
		
			fieldCodes2[iField2]=resultList2[iField2][0];
			fieldNames2[iField2]=resultList2[iField2][1];
			fieldPurposes2[iField2]=resultList2[iField2][2];
			fieldValues2[iField2]="";
			dataTypes2[iField2]=resultList2[iField2][3];
			fieldLengths2[iField2]=resultList2[iField2][4];
			fieldCtrlInfos2[iField2]=resultList2[iField2][5];
			openFlagNew[iField2]=resultList2[iField2][6];
			
			iField2++;
		}
	%>
	<%
		System.out.println("3691~~~qryFlag~~~~"+qryFlag);//qryCptCpm
		if(qryFlag.equals("qryCust") )
		{
		%>
		<%@ include file="fpubDynaFields_modify.jsp"%>			
		<%
		} else if ("proProgress".equals(qryFlag)){
		  //���Ų�Ʒ��չ������ѯ
		    %>
		    <wtc:service name="sDevelopQry" routerKey="region" routerValue="<%=regionCode%>" 
		        retcode="retCodeDev" retmsg="retMsgDev" outnum="3" >
    			<wtc:param value=""/>
    			<wtc:param value="01"/>
    			<wtc:param value="3691"/>
    			<wtc:param value="<%=workno%>"/>
    			<wtc:param value="<%=nopass%>"/>
    			<wtc:param value=""/>
    			<wtc:param value=""/>
    			<wtc:param value="<%=grpIdNo%>"/>					
    		</wtc:service>
		    <wtc:array id="oDevelopValue" start="0" length="1" scope="end"/>
		    <wtc:array id="sDevelopQryResult" start="1" length="2" scope="end"/>
		    <%
		    if ("000000".equals(retCodeDev)){
%>      		
      		<div class="title">	
      			<div id="title_zi">���Ų�Ʒ��չ������Ϣ</div>
      		</div>
      	
      		<table cellSpacing=0>
      			<td class='blue' width="14%">���ŵ�ǰ��չ����</td>
      			<td width="36%">
      				<select id="grpCurrentAttr" name="grpCurrentAttr">
<%
      				 for(int x = 0; x < sDevelopQryResult.length; x++){
                 String selected = "";
                 if (sDevelopQryResult[x][0].equals(oDevelopValue[0][0])){
                 	 selected = "selected";
                 }else{
                 	 selected = "";
                 }
%>		
                  <option value="<%=sDevelopQryResult[x][0]%>" <%=selected%> ><%=sDevelopQryResult[x][1]%></option>
<%
          		}
%>
      				</select>
      			</td>
      			<td width="14%"></td>
      			<td></td>
      		</table>
<%
		    }
		  }else{
		%>		
		
		<wtc:service name="sQryContractNo" routerKey="region" routerValue="<%=regionCode%>" 
			retcode="ccRc" retmsg="ccRm" outnum="54" >
			<wtc:param value=""/>
			<wtc:param value="01"/>
			<wtc:param value="3690"/>
			<wtc:param value="<%=workno%>"/>
			<wtc:param value="<%=nopass%>"/>
			<wtc:param value=""/>
			<wtc:param value=""/>
			<wtc:param value="<%=grpIdNo%>"/>					
		</wtc:service>
		<wtc:array id="ccrst" scope="end"/>
		<%
		if (!ccRc.equals("000000"))
		{
		%>
		<script>
			rdShowMessageDialog("<%=ccRc%>:<%=ccRm%>");
			removeCurrentTab();
			
		</script>
		<%
		}
		
		
			for ( int i=0;i<ccrst[0].length;i++ )
			{
				System.out.println("3691~~~~ccrst[0]["+i+"]=="+ccrst[0][i]);
			}
		%>
		<div class="title"   style="display:<%=ccDisp%>" >
			<div id="title_zi">��Ŀ��ͬ��ƷЭ����Ϣ</div>
		</div>	
		<TABLE  cellSpacing=0 id= 'tabCnttCpt' name= 'tabCnttCpt' style="display:<%=ccDisp%>" >
			<td class='blue'>��Ŀ��ͬ���</td>
			<td>
				<input type='text' name='cntNo' value='<%=ccrst[0][1]%>' maxlength='10'>
				<font class='orange'>*</font>
			</td>
			<td class='blue'>��ƷЭ����</td>
			<td>
				<input type='text' name='cptNo' value='<%=ccrst[0][0]%>'maxlength='10'>
				<input type="hidden" name="prodOpenTime" value='<%=ccrst[0][6]%>' >
				<!--Ȩ�ޱ�ʶ-->
				<input type="hidden" name="prodRight" value='<%=ccrst[0][2]%>' >
				<!--## 5	oCnttCode		��ͬ�����-->
				<input type="hidden" name="oCnttCode" value='<%=ccrst[0][3]%>' >
				<!--## 6	oCptCode		Э�鸸���-->
				<input type="hidden" name="oCptCode" value='<%=ccrst[0][4]%>' >
				<!--## 7	oUnitId			���ű��-->
				<input type="hidden" name="oUnitId" value='<%=ccrst[0][5]%>' >
			</td>	
		</table>
		<%
		}
		%>

	
        <TABLE  cellSpacing=0  style="display:<%=listShow%>">
	<TR style='display:none'>
		  <%
			
				String result_hand = "0.0";	 
				sqlStr = "select hand_fee from snewfunctionfee where function_Code ='3517'";
				%>
					<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode30" retmsg="retMsg30" outnum="1">
							<wtc:sql><%=sqlStr%></wtc:sql>
					</wtc:pubselect>
					<wtc:array id="result35" scope="end" />
				<%
	                	//retArray = callView.sPubSelect("1",sqlStr);
		            	//result = (String[][])retArray.get(0); 
		            	if(result35!=null&&result35.length>0){
				           if (!"".equals(result35[0][0])){
						result_hand=result35[0][0];
					}
				 }					
				
				
			%>
			
				<TD width="18%" class="blue">Ӧ��������</TD>
				<TD width="32%">
				<input  name="should_handfee" id="should_handfee" value="<%=result_hand%>" readonly>
				</TD>
				<TD width="18%" class="blue">ʵ��������</TD>
				<TD width="32%">
				<input  name="real_handfee" id="real_handfee" value="0" v_must=0  v_type=money>
			    </TD>
		   </TR>
		   <TR style='display:none'>
				<TD width="18%" class="blue">���ʽ</TD>
				<TD width="32%" colspan="3">
				        <select name='payType' onchange='changePayType()'>
					<option value='1'>�ֽ�</option>
					<option value='2'>֧Ʊ</option>
					</select><font class="orange">*</font>
				</TD>
		 </TR>
		<TR id='checkPayTR' style="display:none"> 
	                <TD width="18%" nowrap class="blue"> 
	                   ֧Ʊ����
	                </TD>
	                <TD width="32%" nowrap> 
	                    <input  v_must=0  v_type="0_9" name=checkNo maxlength=20 onkeyup="if(event.keyCode==13)getBankCode();" index="50">
	                    <font class="orange">*</font>
			    <input name=bankCodeQuery type=button  class="b_text" style="cursor:hand" onClick="getBankCode()" value=��ѯ>
			</TD>
	                <TD width="18%" nowrap class="blue"> 
	                    ���д���
	                </TD>
	                <TD width="32%" nowrap> 
	                    <input name=bankCode size=12  maxlength="12" readonly>
			    <input name=bankName size=20  readonly>
	                </TD>                                              
            </TR>
	    <TR  id='checkShow' style='display:none'> 
                  <TD width=18% nowrap class="blue"> 
                    ֧Ʊ����
                  </TD>
            	<TD width="32%">
              	    <input v_must=0  v_type=money v_account=subentry name=checkPay value=0.00 maxlength=15 index="51" >
                    <font class="orange">*</font> </TD> 
                  <TD width=18% class="blue"> 
                    ֧Ʊ���
                  </TD>
                  <TD width=32%> 
                    <input  name="checkPrePay" value=0.00 readonly>
                  </TD>               
            </TR>

<tbody id="vpmn_flag" style="display:none">
<TR>
<TD class="blue">��������</TD>
<TD>
<input name="group_name" type="text"  id="group_name" readOnly class="InputGrey">
</TD>
<TD class="blue">��������ʡ����</TD>
<TD>
<input  name="province" type="text" id="province" readonly class="InputGrey">
</TD>
</TR>  
<TR>
<TD class="blue">ҵ����ʼ����</TD>
<TD>
<input name="srv_start" type="text" id="srv_start" onKeyPress="return isKeyNumberdot(0)" readonly class="InputGrey">
</TD>
<TD class="blue">ҵ����ֹ����</TD>
<TD>
<input name="srv_stop" type="text"id="srv_stop" onKeyPress="return isKeyNumberdot(0)">
</TD>
</TR>
<TR>
<TD class="blue">��ϵ������</TD>
<TD>
<input name="contact" type="text" id="contact" maxlength = 18 value="">
</TD>
<TD class="blue">������ϵ�绰</TD>
<TD>
<input name="telephone" type="text" id="telephone" onKeyPress="return isKeyNumberdot(0)">
</TD>
</TR>
<TR>
<TD class="blue">������ϵ��ַ</TD>
<TD colspan=3>
<input name="address" type="text" id="address" size=60>
</TD>
</TR>
</tbody>


	<%
	if(qryFlag=="qryCust")
	{
	%>
		<TR >
		<TD width="18%" class="blue">��ע</TD>
		<TD colspan="3">
		<input  name="sysnote" size="60" value="���Ų�Ʒ���ϱ��" readonly class="InputGrey" >
		</TD>
		</TR>    
	<%
	}
	else
	{
	%>
		<TR style='display:none'>
		<TD width="18%" class="blue">��ע</TD>
		<TD colspan="3">
		<input  name="sysnote" size="60" value="���Ų�Ʒ���ϱ��" readonly class="InputGrey" >
		</TD>
		</TR>    
	<%	
	}
	%>
       </TABLE>
 <!-----------���ص��б�-->
        <TABLE cellSpacing="0">        
            <TR>
              <TD id="footer">
			 <%
			 if (nextFlag==1){
			 %>
			 &nbsp;
			  <input name="next" id="next"  type=button class="b_foot" value="��ѯ" onclick="nextStep()" >
			 <%
			 }else {
			 %>			
			 &nbsp;
			  <input  name="previous"  class="b_foot" type=button value="��һ��" onclick="previouStep()" style="display:none">
			  &nbsp;

					<input  name="sure"  class="b_foot" type=button value="�޸�" onclick="refMain('3202')"  /> 
			  
			  
<%
				if ("vp".equals(paramsArray[9])) {
%>
					&nbsp;<input  name="sure22"  class="b_foot" type=button value="����" onclick="refMain('3204')"  >
					&nbsp;<input  name="sure33"  class="b_foot" type=button value="ȥ����" onclick="refMain('3205')"  >
<%
				} else if ("j1".equals(paramsArray[9])) {	//wanghfa���� 2010-12-7 14:57 �����ܻ�����BOSSϵͳ����
%>
					&nbsp;<input  name="sure22"  class="b_foot" type=button value="��ͣ" onclick="refMain('3204')"  >
					&nbsp;<input  name="sure33"  class="b_foot" type=button value="�ָ�" onclick="refMain('3205')"  >
<%
				}
%>
			 <%
			 }
			 %>
              		&nbsp; 
              		<input  name=back  class="b_foot" type=button value="���" onclick="window.location='f3691_1.jsp'">
			&nbsp;
              		<input  name="kkkk"  class="b_foot" onClick="removeCurrentTab()" type=button value="�ر�">
              	     </TD>
            </TR>	
        </TABLE>
      			<!-------------������--------------->
			<input type="hidden" name="modeCode" value="">
			<input type="hidden" name="oldPwd" value="<%=(paramsArray[4])%>">
			<input type="hidden" name="modeType" value="<%=paramsArray%>">
			<input type="hidden" name="typeName">
			<input type="hidden" name="addMode">
			<input type="hidden" name="modeName">
			<input type="hidden" name="openFlagList">
			<input type="hidden" name="openFlagListNew">
			<input type="hidden" name="nameList"  value="<%=nameList%>">
			<input type="hidden" name="nameValueList"  value="<%=nameValueList%>">
			<input type="hidden" name="nameGroupList"  value="<%=nameGroupList%>">
			<input type="hidden" name="nameListNew"  value="<%=nameListNew%>">
			<input type="hidden" name="nameGroupListNew"  value="<%=nameGroupListNew%>">
			<input type="hidden" name="fieldNamesList">
			<input type="hidden" name="choiceFlag">
			<input type="hidden" name="tonote" size="60" value="���Ų�Ʒ���ϱ��">
			<input type="hidden" name="StartTime" value="">
            <input type="hidden" name="EndTime" value="">
            <input type="hidden" name="MOCode" value="">
            <input type="hidden" name="CodeMathMode" value="">
            <input type="hidden" name="MOType" value="">
            <input type="hidden" name="DestServCode" value="">
            <input type="hidden" name="ServCodeMathMode" value="">
            <input type="hidden" name="in_ChanceId2" value="">
            <input type="hidden" name="fee_rate"  value="">
            <input type="hidden" name="busi_type"  value="">
            <input type="hidden" name="cover_region"  value="">
            <input type="hidden" name="chg_flag"  value="">
            <input type="hidden" name="max_outnumcl"  value="">
            <input type="hidden" name="opCodeFlag" value="">
            <input type="hidden" name="waNo" value="<%=wa_no%>">
      <input type="hidden" name="v_smCode" id="v_smCode" value="<%=paramsArray[9]%>">
			<!-------------������--------------->
			<jsp:include page="/npage/common/pwd_comm.jsp"/>
			<%@ include file="/npage/include/footer.jsp" %>  
</FORM>
	 <script language="JavaScript">
	 	 <%if (nextFlag==1){%>
	 		document.frm.grpIdNo.focus();
	  	<%}%>
		<%
		if (nextFlag==2 && qryFlag.equals("qryCust") ){
			out.println("calcAllFieldValues();");
		}
		%>
	 </script>
</BODY>
</HTML>
<script>
	
		/*2015/03/05 17:28:15 gaopeng 
			R_CMI_HLJ_guanjg_2015_2109554  ������ESOPBOSSϵͳʵ��IDC�ؼ���Ϣ¼�빦�ܵ�����ĺ�
		*/
		function letItRedFunc(){
			for(var i=10803;i<10816;i++){
				var appendStr = "<font class='orange'>����ͬ��Ϣ¼�룩</font>";
	  		var F10803CodeObj = $('#F'+i).parent().prev("td");
	  		if(typeof(F10803CodeObj) != "undefined"){
	  			F10803CodeObj.append(appendStr);
	  		}
			}	
		}
    /*liujian 2012-12-24 14:55:47 ��ά��ҵ��
    * 1. ���ö�ά��ʹ�÷�(Ԫ)(10641)����Ϊ���ɱ༭
    * 2. ���ö�ά������(10639) �� �������ʣ�Ԫ/����(10640)��key�¼���ʹ ��ά��ʹ�÷�(Ԫ) = ��ά������ �� �������ʣ�Ԫ/����
    * 3. ��ά���������������ʡ���ά��ʹ�÷Ѷ�������������
    */
    $(function() {
    	var smCode = '<%=paramsArray[9]%>';
    	
  		/*2015/03/05 17:28:15 gaopeng 
				R_CMI_HLJ_guanjg_2015_2109554  ������ESOPBOSSϵͳʵ��IDC�ؼ���Ϣ¼�빦�ܵ�����ĺ�
			*/
    	letItRedFunc();	
    		
    	if($.trim(smCode) == 'EW') {
    		//��ʼ����ά���������������ʡ���ά��ʹ�÷�
    		$('#F10641').attr('readOnly',true);
    		$('#F10641').addClass("InputGrey");
    		
	    	setSignalValue($('#F10639'));
	    	setSignalValue($('#F10640'));
	    	setSignalValue($('#F10642'));
	    	setSignalValue($('#F10643'));
	    	setSumValue();
	    	//ע���ά�����������¼�
	        $('#F10639').keyup(function() {
	            setSignalValue($(this));
	            setSumValue();
	        });
	        //ע�ᵥ�����ʼ����¼�
	        $('#F10640').keyup(function() {
	            setSignalValue($(this));
	            setSumValue();
	        });
	        //ע�������豸���¼���ֻ��������
	        $('#F10642').keyup(function() {
	            setSignalValue($(this));
	        });
	        //ע��һ���Կ��������¼���ֻ��������
	        $('#F10643').keyup(function() {
	            setSignalValue($(this));
	        });
    	}
    	var cityCode = '';
    	if($.trim(smCode).toLowerCase() == 'hj' && '<%=paramsArray[10]%>'=='214') {
    		if($('#F10652').val()) {
    			$('#F10652').parent().append("<br><span>��д����Ʒ���н���ţ��������������1��ʱ�ɱ��</span>");	
    		}
    		$('#F10654').css('display','none');
    		cityCode = $('#F10654').val();
    		
    		//��ȡʡ������
    		var packet = new AJAXPacket("../s3690/f3690_ajax_rent.jsp","���ڻ�����ݣ����Ժ�......");
	        packet.data.add("method","getProv");
	        core.ajax.sendPacket(packet,doGetProv);
	        packet = null;	
	        $('#provSelect').change(function() {
	    		var pv = $('#provSelect').val();
	    		var stm = new Array();
	    		if(pv == '') {
	    			if($('#citySelect').val()) {
						$('#citySelect').empty();
						stm.push('<option value="">��ѡ��</option>');	
						$('#citySelect').append(stm.join(''));
					}else {
						stm.push('<select id="citySelect">');
						stm.push('	<option value="">��ѡ��</option>');	
						stm.push('</select>');
						$('#provSelect').after(stm.join(''));	
					}
	    		}else {
		    		//��ȡ��������
		    		var packet = new AJAXPacket("../s3690/f3690_ajax_rent.jsp","���ڻ�����ݣ����Ժ�......");
			        packet.data.add("method","getCity");
			        packet.data.add("prov_code",pv);
			        core.ajax.sendPacket(packet,doGetCity);
			   		packet = null;	
		    	}
	    	});
	    	$('#provSelect').change();
	    	$('#citySelect').change(function() {
	    		$('#F10654').val($('#citySelect').val());
	    	});
	    	$('#citySelect').change();
	    	//ͨ������code��ȡʡ��code
    		//��ȡʡ������
    		var codepacket = new AJAXPacket("../s3690/f3690_ajax_rent.jsp","���ڻ�����ݣ����Ժ�......");
	        codepacket.data.add("method","getProvCode");
	        codepacket.data.add("cityCode",cityCode);
	        core.ajax.sendPacket(codepacket,doGetProvCode);
	        codepacket = null;	
    	}
    	
    });
    //��ȡ���е�ʡ�ݣ�����ʡ��������
    function doGetProv(packet) {
		var retCode = packet.data.findValueByName("retCode");
		var retMsg = packet.data.findValueByName("retMsg");
		var provArray = packet.data.findValueByName("provArray");
		if(retCode == '000000') {
			var stm = new Array();
			if(provArray && provArray.length > 0) {
				stm.push('<select id="provSelect">');
				stm.push('	<option value="">��ѡ��</option>');
				for(var i = 0,len = provArray.length; i < len; i++) {
					var prov = provArray[i];
					stm.push('<option value="' + prov.code + '">' + prov.name + '</option>');	
				}	
				stm.push('</select>');
			}
			$('#F10654').after(stm.join(''));
		}else {
			rdShowMessageDialog("�������:" + retCode + ",������Ϣ:" + retMsg,0);	
		}
		
    }
    //��ȡĳ��ʡ�������еĳ��У����ó���������
    function doGetCity(packet) {
    	var retCode = packet.data.findValueByName("retCode");
		var retMsg = packet.data.findValueByName("retMsg");
		var cityArray = packet.data.findValueByName("cityArray");
		var stm = new Array();
		if($('#citySelect').val()=='' || $('#citySelect').val()) {
			$('#citySelect').empty();	
		}else {
			stm.push('<select id="citySelect">');
			stm.push('</select>');
			$('#provSelect').after(stm.join(''));	
		}
		if(retCode == '000000') {
			stm = [];
			if(cityArray && cityArray.length > 0) {	
				for(var i = 0,len = cityArray.length; i < len; i++) {
					var city = cityArray[i];
					stm.push('<option value="' + city.code + '">' + city.name + '</option>');	
				}	
			}
			$('#citySelect').append(stm.join(''));
			
		}else {
			rdShowMessageDialog("�������:" + retCode + ",������Ϣ:" + retMsg,0);	
		}	
    }
    //��ȡ��Ӧ��ʡ�ݣ�����ʡ��������
    function doGetProvCode(packet) {
    	var retCode = packet.data.findValueByName("retCode");
		var retMsg = packet.data.findValueByName("retMsg");
		var provCode = packet.data.findValueByName("provCode");
		var cityCode = packet.data.findValueByName("cityCode");
		if(retCode == '000000') {
			$('#provSelect').val(provCode);
			$('#provSelect').change();
			$('#citySelect').val(cityCode);
			$('#citySelect').change();
		}else {
			rdShowMessageDialog("�������:" + retCode + ",������Ϣ:" + retMsg,0);	
		}	
    }
    
    //���ö�ά���������������ʵ�ֵ
    function setSignalValue($this) {
        var _this = $this.val()?$this.val():'';
        $this.val(_this.replace(/[^\.\d]/g,''));
        _this = $this.val();
        if(!_this || isNaN(_this)) {
            $this.val(0);
        }else {
	        $this.val(parseInt($this.val(),10));
	    }
    }
    //�����ά��ʹ�÷�
    function setSumValue() {
        var first = parseInt($('#F10639').val(),10);
        var second = parseInt($('#F10640').val(),10);
        $('#F10641').val(first * second );
    }
    /* liujian 2012-12-24 15:34:48 ��ά��ҵ�� ����*/
    
  


$(document).ready(function (){
	
	
	var smCode = '<%=paramsArray[9]%>';
	
	if(typeof($('#F10817'))!="undefined"&&typeof($('#F10817').val())!="undefined"){
		if(smCode.trim() == "RH"){
			//3 1 ���ܱ䵽 6 12 
			//3 1 ���ܻ����
			var old_F10817_value=$("#F10817").val();
			//alert("old_F10817_value=["+old_F10817_value+"]");
			
			$("#F10817").change(function (){
				var new_F10817_value=$("#F10817").val();
				//alert("new_F10817_value=["+new_F10817_value+"]");
				
				if(old_F10817_value=="1"||old_F10817_value=="3"){
					if(new_F10817_value=="6"||new_F10817_value=="12"){
						rdShowMessageDialog("�������޸�Ϊ���ꡢ�꣬��������д");
						$("#F10817").val(old_F10817_value);
					}
				}
				
				if(old_F10817_value=="6"){
					if(new_F10817_value=="12"){
						rdShowMessageDialog("�������޸�Ϊ���ꡢ�꣬��������д");
						$("#F10817").val(old_F10817_value);
					}
				}
				
				
				if(old_F10817_value=="12"){
					if(new_F10817_value=="6"){
						rdShowMessageDialog("�������޸�Ϊ���ꡢ�꣬��������д");
						$("#F10817").val(old_F10817_value);
					}
				}
				
				
			});
			
		}
	}
	
	
	
});
</script>