<%
/********************
 * version v2.0
 * ������: si-tech
 * author:
 * update by qidp @ 2009-06-01 ҳ������
 * update by qidp @ 2009-09-14 ���ݶ˵�������
 * update by qidp @ 2009-11-23 ���ݶ���100����
 * update by hejwa @ 2013-1-14 ng3.5��Ŀ�ض���
 ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="/npage/public/pubSASql.jsp" %>
<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="com.sitech.boss.pub.*" %>
<%@ page import="com.sitech.boss.s1900.config.productCfg" %>
<%@ page import="com.sitech.boss.pub.util.*"%>

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
	
    String opCode = "3690";
    String opName = "���Ų�Ʒ����";
    
   
    
    Logger logger = Logger.getLogger("f3690_1.jsp");

    String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
    String dateStr22 = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
    int iDate = Integer.parseInt(dateStr);
    //String addDate = Integer.toString(iDate+1);//qidp:�˷�ʽ�����⣬06-30��һ��Ϊ06-31��������Ҫ��
    
     String date_yyyyMM = new java.text.SimpleDateFormat("yyyyMM").format(new java.util.Date());
     
    /*add by qidp @ 2009-06-30*/
    Date dateTmp = new Date();
    long timeLen = dateTmp.getTime();
    Date dateTmp2 = new Date(timeLen+1*24*60*60*1000);//��һ��
    String addDate = new java.text.SimpleDateFormat("yyyyMMdd").format(dateTmp2);
    
    String Date100 = Integer.toString(iDate+1000000);

    String ip_Addr = (String)session.getAttribute("ipAddr");
    String workno = (String)session.getAttribute("workNo");
    String workname = (String)session.getAttribute("workName");
    String org_code = (String)session.getAttribute("orgCode");
    String nopass  = (String)session.getAttribute("password");
    String powerRight = (String)session.getAttribute("powerRight");
    String Department = org_code;
    String regionCode = Department.substring(0,2);
    String districtCode = Department.substring(2,4);
    String townCode = Department.substring(4,7);
    
    boolean haveA323 = false;
    boolean have_a324 = false;//
    boolean have_a325 = false;//
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
		
    String [] paraIn = new String[2];
    
    String sqlStr = "";
    String sqlStrHl = "";
    String [] paraInHl = new String[2];
    int aHl = 0;
    int bHl = 0;    
    /*diling add*/
    String [] paraIn_ID = new String[2];
    String sqlstr_ID = "";
    String v_retCodeID = "";
    String[][] v_retArrID = new String[][]{};
    /*end diling add*/
	String cust_address = "";
    ArrayList retArray = new ArrayList();
    String[][] result = new String[][]{};
    productCfg prodcfg = new productCfg();
	String[][] resultList = new String[][]{};
	/*��Ʒ�ͷ���ķ���Ȩ��*/
    int iPowerRight = Integer.parseInt(((String)session.getAttribute("powerRight")).trim()); //����Ȩ��
	//ȡ����ʡ�ݴ��� -- Ϊ�������ӣ�ɽ������ʹ��session
	String[][] result2  = null;
	sqlStr = "";//������agent_prov_code='21'
 
	String ProvinceRun = "";
 
    //ȡ���������GROUP_ID
    String GroupId = "";
    String OrgId = "";
     
		GroupId = (String)session.getAttribute("groupId");
		OrgId = (String)session.getAttribute("orgId");

	int nextFlag=1;
	String listShow="none";
	StringBuffer nameList=new StringBuffer();
	StringBuffer nameValueList=new StringBuffer();
	StringBuffer nameGroupList=new StringBuffer();
	//String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
	//String [] valueList=new String[30]{};
    //�õ�ҳ����� 
	String iccid = "";
	String cust_id = "";
	String unit_id = "";
	String cust_name = "";
	String province = "";
	String openType = "";
	String userType = "";
	//String product_attr1 = "";
	String product_code = "";
	String product_append = "";
	String grp_id = "";
	String grp_name = "";
	String account_id = "";
	String grp_userno = "";
	String channel_code = "";
	String belong_code = "";
	String group_id = "";/*add by liwd 20081127,group_id����dcustDoc��group_id*/
	//String sm_code = "";
	String custAddress = "";
	String[][] contact_info = null;
	String disabledArr[][] = new String[][]{};
	String ownerType = "";
	String bizCode = "";
	String bizName = "";
	String BizServcode="";
	String bizattrtype="";
	String billingtype="";
	String i_prod_direct="";
	String telNo = "";
	String F00017 = "";
	String F00018 = "";
	String product_name = "";
	String product_prices = "";
	String oBizCode = "";
	String catalog_item_id="";
	String cust_price="";
	String iBtnId = "";
	/* add by qidp @ 2009-11-16 */
	String smsFlag = "";
	String smsMinLen = "";
	String smsMaxLen = "";
	String amsBaseServCode = "";
	/* end of add */
	String iChildAccept = "";
	String f5000Label = "none";
	String iBizTypeL = "";
	String iBizTypeS = "";
	/*DILING add */
  String iSmCodeHidden = "";
  String iBizTypeLHidden = "";
  String iBizTypeSHidden = "";
	
	StringBuffer numberList=new StringBuffer();
    
    String inOpenFlag = WtcUtil.repNull((String)request.getParameter("openFlag"));/* From4091:�˵��˽���,DL100:����100���� */
    String in_GrpId = request.getParameter("in_GrpId");
    String in_ChanceId = request.getParameter("in_ChanceId");
    String inBatchNo = request.getParameter("batch_no");
    System.out.println("### inBatchNo = "+inBatchNo);
    String sm_code = request.getParameter("sm_code");
    String wa_no = request.getParameter("wa_no1");
    String inCount = WtcUtil.repNull((String)request.getParameter("count"));
    String action = "";
    //����11����Ѯ���ſͻ���CRM��BOSS�;���ϵͳ����ĺ�-3-ESOPϵͳ�������̻�����֧������
    String input_accept = WtcUtil.repNull((String)request.getParameter("input_accept"));
    
    String iA_prodUnitIdHidden = "";  
    String iA_prodIccidHidden = "";
    String iAProd_grpIdNoHidden = "";
    String iret_prodCodeHidden = "";
    String iret_prodNameHidden = "";
    
    /**************
     * add by qidp.
     * ���ӱ�־λ(openLabel)
     * link  ���߶˵�������ͨ��������ƽ���˶���ģ�飻
     * opcode�����߶˵������̣�ͨ��opcode�򿪴�ҳ�棻
     * DL100 ���߶���100���̡�
     **************/
    String openLabel = "";
    String MLFlag = "";/* add by qidp.��־λ�����ڱ�ʶ�Ƿ�ΪML-����MAS */
    String oMLFlag = "";
    
    /*add by qidp.�жϽ����ģ��ķ�ʽ��������Ӧ�Ĵ�����*/
    /*modify by qidp @ 2009-11-23 for 4091ģ�����ӱ�־λ�ж��Ƿ�Ϊ�˵��ˡ�
    if(in_ChanceId != null){//�������������ʱ���̻����벻Ϊ�ա�
    */
    System.out.println("# inOpenFlag = "+inOpenFlag);
    if("From4091".equals(inOpenFlag)){//��4091����ʱ����Ϊ�˵������̡�
        if(!"ML".equals(sm_code)){
            action = "select";
            openLabel = "link";
        }else{
            MLFlag = "ML";
        }
        iChildAccept = WtcUtil.repNull((String)request.getParameter("child_accept"));
    }else if("DL100".equals(inOpenFlag)){//��DL100����ʱ����Ϊ����100���̡�
        action = "";
        openLabel = "DL100";
        inCount = "";
        iChildAccept = WtcUtil.repNull((String)request.getParameter("in_childAccept"));
        in_ChanceId = "";
        inBatchNo = "";
    }else{
        in_GrpId = "";
        in_ChanceId = "";
        inBatchNo = "";
        wa_no = "";
        inCount = "";
        action = request.getParameter("action");
        if(sm_code == null){
            sm_code = "";
        }
        openLabel = "opcode";
    }
    System.out.println("# openLabel = "+openLabel);
    //�õ��б�����
	//String sm_code=request.getParameter("sm_code1");
	int resultListLength=0;

    if("DL100".equals(openLabel)){
        iccid = WtcUtil.repNull((String)request.getParameter("inIccid"));
        cust_id = WtcUtil.repNull((String)request.getParameter("inCustId"));
        unit_id = WtcUtil.repNull((String)request.getParameter("inUnitId"));
        cust_name = WtcUtil.repNull((String)request.getParameter("inCustName"));  
        belong_code = WtcUtil.repNull((String)request.getParameter("inBelongCode"));
        sm_code = WtcUtil.repNull((String)request.getParameter("sm_code"));
        userType = sm_code;
        String inProductCode = WtcUtil.repNull((String)request.getParameter("in_productCode"));
        String inProductName = WtcUtil.repNull((String)request.getParameter("in_productName"));
        if(!"".equals(inProductCode) && !"".equals(inProductName)){
            F00017 = inProductCode+"|"+inProductName;
            product_code = F00017;
            product_name = inProductName;
        }
        String inBizCode = WtcUtil.repNull((String)request.getParameter("in_bizCode"));
        String inBizName = WtcUtil.repNull((String)request.getParameter("in_bizName"));
        if(!"".equals(inBizCode) && !"".equals(inBizName)){
            bizCode = inBizCode;
            oBizCode = inBizCode;
            F00018 = inBizName;
        }
        System.out.println("# oBizCode = "+oBizCode);
        iBtnId = WtcUtil.repNull((String)request.getParameter("btn_id"));
        catalog_item_id = request.getParameter("catalog_item_id");
        System.out.println("# catalog_item_id = "+catalog_item_id);
        
        %>
            <wtc:service name="sGrpCustQry" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode434" retmsg="retMsg434" outnum="1" >
              <wtc:param value="0"/>
              <wtc:param value="01"/>
              <wtc:param value="<%=opCode%>"/>
              <wtc:param value="<%=workno%>"/>	
              <wtc:param value="<%=nopass%>"/>		
              <wtc:param value=""/>	
              <wtc:param value=""/>
              <wtc:param value=""/>
              <wtc:param value="<%=cust_id%>"/>
              <wtc:param value=""/>
              <wtc:param value=""/>
              <wtc:param value="<%=opCode%>"/>
              <wtc:param value=""/>	
              <wtc:param value=""/>
              <wtc:param value=""/>
              <wtc:param value=""/>
              <wtc:param value=""/>
              <wtc:param value="2"/>
              <wtc:param value=""/>
              <wtc:param value="1"/>
              <wtc:param value=""/>
              <wtc:param value=""/>
              <wtc:param value=""/>
              <wtc:param value=""/>
            </wtc:service>
            <wtc:array id="retArr434" scope="end"/>   
        <%
        if("000000".equals(retCode434)){
            group_id = retArr434[0][0];
        }else{
            %>
            <script>
                rdShowMessageDialog("ȡ�ͻ�GroupId������",0);
                window.close();
            </script>
            <%
        }
    }
    
    if (action!=null&&action.equals("select"))
    {
        try{
            //hid_createFlag=request.getParameter("hid_createFlag");
            iccid=(request.getParameter("iccid") == null)?"":(request.getParameter("iccid"));
            cust_id=(request.getParameter("cust_id") == null)?"":(request.getParameter("cust_id"));
            unit_id=(request.getParameter("unit_id") == null)?"":(request.getParameter("unit_id"));
            cust_name=(request.getParameter("cust_name") == null)?"":(request.getParameter("cust_name"));
            province=request.getParameter("province");
            sm_code=request.getParameter("sm_code");/////
            i_prod_direct=request.getParameter("prod_direct");
            telNo = request.getParameter("telNo")==null ? "" : request.getParameter("telNo");
            F00017 = request.getParameter("F00017")==null ? "" : request.getParameter("F00017");
            F00018 = request.getParameter("F00018")==null ? "" : request.getParameter("F00018");
            product_name = request.getParameter("product_name")==null ? "" : request.getParameter("product_name");
            product_prices = request.getParameter("product_prices")==null ? "" : request.getParameter("product_prices");
            oBizCode = request.getParameter("biz_code")==null ? "" : request.getParameter("biz_code");
            System.out.println("###  oBizCode = "+oBizCode);
            iBtnId = WtcUtil.repNull((String)request.getParameter("btn_id"));
            System.out.println("&&&&&&&&&&&&&&&&&&&&&&&&&&7openLabel="+openLabel);
            openLabel = (request.getParameter("open_label")==null)?openLabel:(request.getParameter("open_label"));
            oMLFlag = WtcUtil.repNull((String)request.getParameter("MLFlag"));
            if("ML".equals(oMLFlag)){
                inBatchNo = request.getParameter("batch_no");
            }
            System.out.println("&&&&&&&&&&&&&&&&&&&&&&&&&&7openLabel="+openLabel);
            inCount = WtcUtil.repNull((String)request.getParameter("count"));
            iChildAccept = WtcUtil.repNull((String)request.getParameter("child_accept"));
            /*diling add*/
            iSmCodeHidden = WtcUtil.repNull((String)request.getParameter("smCodeHidden"));
            iBizTypeLHidden = WtcUtil.repNull((String)request.getParameter("bizTypeLHidden"));
            iBizTypeSHidden = WtcUtil.repNull((String)request.getParameter("bizTypeSHidden"));
            
            /*****************************
             * add by qidp @ 2009-03-12 
             * ������Ʒ��Ϊ ADC������MAS��ȫ��MAS ʱ���Ե�ǰ�û��Ƿ��ܹ�������ҵ�������жϡ�
             * �ܹ����� ADC������MAS��ȫ��MAS ҵ��ĸ��������� ���� dcustdoc �� owner_type �ֶε�ֵΪ '04' ��
             *****************************/
            if((openLabel!=null && openLabel.equals("opcode")) || "DL100".equals(openLabel)){
                System.out.println("-------====|sm_code|====-------"+sm_code);
                if(sm_code.equals("AD") || sm_code.equals("ML") || sm_code.equals("MA")){
                    String ssql = "select owner_type from dcustdoc where cust_id =:cust_id";
                    
                    paraIn[0] = ssql;    
                    paraIn[1] = "cust_id="+cust_id;
                    
                %>
                    <wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCodeX" retmsg="retMsgX" outnum="1" >
                        <wtc:param value="<%=paraIn[0]%>"/>
                        <wtc:param value="<%=paraIn[1]%>"/> 
                    </wtc:service>
                    <wtc:array id="retArrX" scope="end"/>
                <%
                    if(retArrX.length>0 && retCodeX.equals("000000")){
                        System.out.println("-------====|owner_type|====-------"+retArrX[0][0]);
                        ownerType = retArrX[0][0];
                    }
                    if(!(ownerType.equals("04"))){
                %>
                    <script>
                        rdShowMessageDialog("�ÿͻ�����EC���ţ����ܰ�����ҵ��",0);
                        this.location="f3690_1.jsp";
                    </script>
                <%
                    }           
                }
            }
            
            /*********** end of add **********/
            
            openType=request.getParameter("openType");
            userType=sm_code;
            System.out.println(".................. userType.........."+userType);
            product_code=request.getParameter("F00017");
            System.out.println(".................. product_code.........."+product_code);
            product_append=(request.getParameter("product_append")==null)?"":(request.getParameter("product_append"));
            grp_id=request.getParameter("grp_id");
            grp_name=request.getParameter("grp_name");
            account_id=request.getParameter("account_id");
            grp_userno=request.getParameter("grp_userno");
            channel_code=request.getParameter("channel_code");
            belong_code = request.getParameter("belong_code");
            group_id = request.getParameter("group_id");/*add by liwd 20081127,group_id����dcustDoc��group_id*/
            custAddress = request.getParameter("cust_address");
            bizCode=request.getParameter("bizCode");
            bizName=request.getParameter("bizName");
            BizServcode = 	request.getParameter("BizServcode");
            bizattrtype= 	request.getParameter("bizattrtype");
            billingtype = 	request.getParameter("billingtype");
            catalog_item_id= 	request.getParameter("catalog_item_id");
            System.out.println("catalog_item_id+===================================="+catalog_item_id);
            
            if(openLabel!=null && openLabel.equals("link")){
                if("AD".equals(sm_code) || "ML".equals(sm_code)){
                    String sql1 = "select biz_code from DBSALESADM.dmktchanceprodrel where chance_id = '"+in_ChanceId+"' ";
                    %>
                    	<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode44" retmsg="retMsg44" outnum="1">
                    		<wtc:sql><%=sql1%></wtc:sql>
                    	</wtc:pubselect>
                    	<wtc:array id="result44" scope="end" />
                    <%
                        if("000000".equals(retCode44) && result44.length>0){
                            bizCode = result44[0][0];
                            oBizCode = bizCode;
                        }else{
                    %>
                            <script>
                                rdShowMessageDialog("ȡbizCodeʧ�ܣ�",0);
                    		    history.go(-1);
                            </script>
                    <%
                        }
                }
            }
            System.out.println("bizCode ==== "+bizCode);
 %>
 	<wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>" id="printAccept"/>           
<%  
            iSmCodeHidden = WtcUtil.repNull((String)request.getParameter("smCodeHidden"));
            iBizTypeLHidden = WtcUtil.repNull((String)request.getParameter("bizTypeLHidden"));
            iBizTypeSHidden = WtcUtil.repNull((String)request.getParameter("bizTypeSHidden"));
            String[] qryParams = new String[13];
            qryParams[0] = printAccept;
            qryParams[1] = "01";
            qryParams[2] = opCode;
            qryParams[3] = workno;
            qryParams[4] = nopass;
            qryParams[5] = "";
            qryParams[6] = "";
            qryParams[7] = sm_code;
            qryParams[8] = bizCode;
            qryParams[9] = catalog_item_id;
            qryParams[10] = iBizTypeSHidden;
            qryParams[11] = iBizTypeLHidden;
            qryParams[12] = catalog_item_id;
           
      %>
              <wtc:service name="sUserAttrQry" routerKey="region" routerValue="<%=regionCode%>" 
              		retcode="retCode13" retmsg="retMsg13" outnum="15" >
                <wtc:param value="<%=qryParams[0]%>"/>
                <wtc:param value="<%=qryParams[1]%>"/> 
                <wtc:param value="<%=qryParams[2]%>"/>
                <wtc:param value="<%=qryParams[3]%>"/>
                <wtc:param value="<%=qryParams[4]%>"/>
                <wtc:param value="<%=qryParams[5]%>"/> 
                <wtc:param value="<%=qryParams[6]%>"/>
                <wtc:param value="<%=qryParams[7]%>"/>
                <wtc:param value="<%=qryParams[8]%>"/>
                <wtc:param value="<%=qryParams[9]%>"/> 
                <wtc:param value="<%=qryParams[10]%>"/>
                <wtc:param value="<%=qryParams[11]%>"/>
                <wtc:param value="<%=qryParams[12]%>"/>
              </wtc:service>
              <wtc:array id="retArr13" start="0" length="13" scope="end"/>
			  <wtc:array id="retQry" start="13" length="2" scope="end"/>
        <%
        	if(retQry[0][0].equals("000000")){
            	System.out.println("-----liujian3690---retArr13.length=" +retArr13.length);
                resultList = retArr13;
            
            	String test[][] = retArr13;
	            for(int i=0;i<retArr13.length;i++) {
	               for(int j=0;j<retArr13[i].length;j++) {
	             	   System.out.println("---liujian3690--" + retArr13[i][j]);
	               }
	            }
	            
	            for(int outer=0 ; test != null && outer< test.length; outer++) {
	                for(int inner=0 ; test[outer] != null && inner< test[outer].length; inner++)
	                {
	                    if(inner == 0) {
	                    	System.out.print("|"+test[outer][inner]);
	                    }else if(inner == 1){
	                    	System.out.print("\t|"+test[outer][inner]+"\t\t");
	                    }else{
	                    	System.out.print("\t|"+test[outer][inner]);
	                    }
	                }
	                    System.out.println(" | ");
	            }
	            
	            if (resultList != null) {
	                for(int i=0;i<resultList.length;i++)  {
	                    if (resultList[i][2].equals("10")){
	                        numberList.append(resultList[i][0]+"|");
	                    }
	                }
	            }
            }else {
%>            	
            	<script>
            		rdShowMessageDialog("�������:<%=retQry[0][0]%>,������Ϣ:<%=retQry[0][1]%>",0);
                    removeCurrentTab();
            	</script>
<%            	
            }
            
         /*****************************
             * ��ȡ��̬����һ�������ӹ��̷ѵ�����
             *****************************/
           System.out.println(" zhoubyx + catalog_item_id " + catalog_item_id);
           if(openLabel!=null && openLabel.equals("link")||"hl".equals(userType)){
           //if(openLabel!=null && openLabel.equals("link")){
             if("hl".equals(userType)|| "hj".equals(userType)){
               sqlStrHl = " select a.field_code,a.field_name,a.field_purpose,a.field_type,to_char(a.field_length) as field_length, "  
                    +" b.field_grp_no,c.field_grp_name,c.max_rows,c.min_rows,b.ctrl_info,b.field_defvalue,b.open_param_flag ,'N' "  
                    +" from sUserFieldCode a,suserfieldfee b,sUserTypeGroup c "  
                    +" where a.field_code=b.field_code "  
                    +" and b.user_type=:catalog_item_id "
                    +" and b.user_type = c.user_type "  
                    +" and b.field_grp_no = c.field_grp_no ";    
                    paraInHl[0] = sqlStrHl;
                    paraInHl[1] = "catalog_item_id="+catalog_item_id;
               %>
                  <wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCodeHl" retmsg="retMsgHl" outnum="13" >
                      <wtc:param value="<%=paraInHl[0]%>"/>
                      <wtc:param value="<%=paraInHl[1]%>"/> 
                  </wtc:service>
                  <wtc:array id="retArrHl" scope="end"/>
              <%
                  String[][] resultListNew = new String[resultList.length+retArrHl.length][13];
                  if("000000".equals(retCodeHl)){
                    //resultList = retArrHl;
                    if(retArrHl.length>0){
                      for(int i=0;i<retArrHl.length;i++){
                         for(int j=0;j<retArrHl[i].length;j++){
                           resultListNew[i][j] = retArrHl[i][j];
                         }
                      }
                      for(int i=0;i<resultList.length;i++){
                         for(int j=0;j<resultList[i].length;j++){
                           resultListNew[i+1][j] = resultList[i][j];
                         }
                      }
                      resultList = resultListNew;
                    }
                  }
            }
          }
            
            resultListLength=result.length;
            nextFlag=2;
            listShow="";
            //�õ����ݵ�����
            //�õ���������
        }
        catch(Exception e){
            e.printStackTrace();
        }

	
    	 /*****************************
          * ��ȡ������ϵ����Ϣ������������ϵ�绰����ַ����
          *****************************/
    	if((openLabel!=null && openLabel.equals("opcode")) || "DL100".equals(openLabel)){
        	String sqlFilter = "";
        
            if (iccid.trim().length() > 0)
                sqlFilter = sqlFilter + " and a.id_iccid = '" + iccid + "'";
            if (unit_id.trim().length() > 0)
                sqlFilter = sqlFilter + " and b.unit_id = " + unit_id;                                          
            if (cust_id.trim().length() > 0)
                sqlFilter = sqlFilter + " and b.cust_id = " + cust_id;
        
            String sqlStr1 = "select b.contact_person ,b.unit_addr ,b.CONTACT_MOBILE_PHONE, a.org_id from dCustDoc a, dCustDocOrgAdd b where a.cust_id = b.cust_id " + sqlFilter;
            System.out.println("@@@@@@@@@@@@@@@@@@@@@@@"+sqlStr1);
        %>
            <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode222" retmsg="retMsg222" outnum="5">
        	    <wtc:sql><%=sqlStr1%></wtc:sql>
        	</wtc:pubselect>
        	<wtc:array id="resultTemp" scope="end" />
        <%
            if (resultTemp.length>0 && retCode222.equals("000000")){
                contact_info = resultTemp;
            }
        }
    %>
    
    <%
        /*****************************
         * ����ҳ���������-ҵ����Ϣ�У�����Ʒ������Ϣ��չʾ
         *****************************/
        String tempSmCode = "";
        if (sm_code.equals("va") || sm_code.equals("vp") || sm_code.equals("CR") || sm_code.equals("AD") || sm_code.equals("ML")){
            tempSmCode = sm_code;
        }else{
            tempSmCode = "BY";
        }
        String sqlDisabled = "select name_id from sgrpmsgdisabled where sm_code = '"+tempSmCode+"' and OP_TYPE = '0'  and disabled_flag = 'N'";
    %>
        <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCodeDisabled" retmsg="retMsgDisabled" outnum="1">
    	    <wtc:sql><%=sqlDisabled%></wtc:sql>
    	</wtc:pubselect>
    	<wtc:array id="resultDisabled" scope="end" />
    <% 
        if (retCodeDisabled.equals("000000") && resultDisabled.length>0){
            disabledArr = resultDisabled;
        }
        
        /*****************************
         * ����ADC/MASʱ������Ϣ�������ĳ�����ʾ��
         * add by qidp @ 2009-11-16
         *****************************/
         String smsSql = "SELECT c.length_flag,c.server_minlength,c.server_maxlength,a.ACCESSNUMBER "
                           +"FROM sBillSPCode a,sNetAttr b,cServerNoLimit c "
                          +"WHERE a.net_attr = b.net_attr "
                            +"AND a.bizcodeadd = '"+oBizCode+"' "
                            +"AND b.net_attr = c.net_attr "
                            +"AND c.sm_code = '"+sm_code+"'";
                            
    %>
        <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCodeSms" retmsg="retMsgSms" outnum="4">
    	    <wtc:sql><%=smsSql%></wtc:sql>
    	</wtc:pubselect>
    	<wtc:array id="resultSms" scope="end" />
    <%
        if("000000".equals(retCodeSms) && resultSms.length>0){
            smsFlag = resultSms[0][0];
            smsMinLen = resultSms[0][1];
            smsMaxLen = resultSms[0][2];
            amsBaseServCode = resultSms[0][3];
        }
        /* end of add */
        
        String productCodeTmp = F00017;
        int productCnt = 0;
        productCnt = productCodeTmp.indexOf("|");
        if(productCnt != -1){
            productCodeTmp = productCodeTmp.substring(0, productCnt);
        }
        if("DL".equals(sm_code)){
            /*
            String f5000Sql = "SELECT count(*) FROM PRODUCT_OFFER_DETAIL a, sRegionCode b, region c ,product_offer d " +
                              " WHERE a.offer_id = to_number('"+productCodeTmp+"') AND b.group_id(+) = c.group_id AND (b.region_code = '01' or c.group_id = '10014') " +  
                              " AND c.offer_id = a.element_id AND a.element_type = '10C' AND a.rule_id = '1' AND a.STATE = 'A' " +
                              " and a.element_id = 5000  and a.element_id = d.offer_id and  d.offer_type = '40' " +
                              " and  d.state = 'A' and  d.exp_date>sysdate ";
            */
            String f5000Sql = "SELECT count(*) FROM busi_offer_relation " +
                            " WHERE external_code = '"+oBizCode+"' " +
                            " and  offer_id = 5000 " +
                            " and  relation_type_id = 7 " +
                            " and eff_date<=sysdate " +
                            " and exp_date >sysdate";
            %>
                <wtc:pubselect name="sPubSelect" retcode="retCode54" retmsg="retMsg54" outnum="1" routerKey="region" routerValue="<%=regionCode%>">
                	<wtc:sql><%=f5000Sql%></wtc:sql>
                </wtc:pubselect>
                <wtc:array id="retArr54" scope="end"/>
            <%
            if(Integer.parseInt(retArr54[0][0]) > 0){
                f5000Label = "";
            }else{
                f5000Label = "none";
            }
        }
    }
    
    String in_ChanceIdTemp = WtcUtil.repNull((String)request.getParameter("in_ChanceId3"));
    String waNoTemp = WtcUtil.repNull((String)request.getParameter("waNo3"));
    
    String xProductCode = F00017;
    int iii = 0;
    iii = xProductCode.indexOf("|"); //�õ�����Ʒ����
    if(iii != -1){
        xProductCode = xProductCode.substring(0, iii);
    }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>���Ų�Ʒ����</TITLE>
<script language="JavaScript" src="<%=request.getContextPath()%>/npage/s3690/pub.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/njs/si/tabScript_jsa.js"></script>
<style type="text/css">
html{
_overflow:hidden;
}
body{
_overflow:auto;
height:100%;
}
#div{
height:1500px;
}
a#returntop{
	background: url('/nresources/default/images/icon_top.png') 0 0 no-repeat;
	width:17px;
	height:92px;
	right:25px;
	bottom:30px;
	display:block;
	font-size:1px;
	position:fixed;
	_position:absolute;
	display:none;
}
a#returntop:hover{
	background:url('/nresources/default/images/icon_top.png') 0 -100px no-repeat;
	text-decoration:none;
}
</style>

</HEAD>
	


<SCRIPT type=text/javascript>
//core.loadUnit("debug");
//core.loadUnit("rpccore");
//yuanqs add 2010/9/6 9:44:15 ������ˢ�»��ǹر�
var isRefresh = true;
onload=function(){
    changeSmCode();
    document.all.checkPayTR.style.display="none";  
    document.all.in_ChanceId2.value = "<%=in_ChanceId%>";
    var sm_code = document.frm.sm_code.value;	
    var disableStr = "";
    
    if(sm_code == "ML"){
        $("#in_ChanceId3").val("<%=in_ChanceIdTemp%>");
        $("#waNo3").val("<%=waNoTemp%>");
	}

    if(sm_code != "vp" && sm_code != "va"){
        document.all.grpNoFlag1.style.display="none";
        document.all.grpNoFlag2.style.display="none";
        getGrpUserNo();
    }else{
        document.all.grpNoFlag1.style.display="";
        document.all.grpNoFlag2.style.display="";
    }
    
    <%if(!"aavg21".equals(workno.toLowerCase())){%>
    if(sm_code == "vp"){
        if($("#F10328") != null){
            $("#F10328").attr("readOnly",true);
            $("#F10328").addClass("InputGrey");
        }
    }
    <%}%>
    
    var disableStr = "";
<%
    if (action!=null&&action.equals("select")){
        if (disabledArr != null){
            for (int i=0;i<disabledArr.length;i++){
                out.print("document.all."+disabledArr[i][0]+".disabled='true';");
            }
        }
%>
if( "ML" == sm_code){
    document.all.smsInfoTR.style.display="";
    if("<%=smsFlag%>" == "Y"){
        $("#smsInfo").after("<font color=red>����Ϣ�������Ϊ�����������"+$("#F00006").val()+" +XXXX  ���ѣ����ŷ�����볤�ȱ���Ϊ<%=smsMinLen%>-<%=smsMaxLen%>λ!��˶Ժ���ȷ�ϡ�</font>");
    }else if("<%=smsFlag%>" == "N"){
        $("#smsInfo").after("<font color=red>����Ϣ�������Ϊ�����������"+$("#F00006").val()+" +XXXX  ���ѣ����ŷ�����볤�������ơ�</font>");
    }
    if($("#F00004") != null){
        $("#F00004").after("<font color='red'>[0:������]</font>");
    }
    if($("#F00005") != null){
        $("#F00005").after("<font color='red'>[0:������]</font>");
    }
}else if("AD" == sm_code){
	
}else{
    document.all.smsInfoTR.style.display="none";
}
/* begin add for ������ר�߿�����������ͳ̸ר����Ŀ��дԪ�صĺ�@2014/11/24 */
if(typeof($("#F10773")) != "undefined" && typeof($("[name=F10774]:checkbox")) != "undefined"){
	if($("#F10773").val() == "01"){
		$("[name=F10774]:checkbox").attr('disabled', true);
	}else{
		$("[name=F10774]:checkbox").attr('disabled', false);
	}
}
/* end add for ������ר�߿�����������ͳ̸ר����Ŀ��дԪ�صĺ�@2014/11/24 */
if("hl" == sm_code){
    //$("#F10011").after("<font color='red'>&nbsp;����λ:M(��)��</font>");
    /*begin diling add for ��ҵ�����������ר�ߣ���ʾ�������@2012/12/25 */
    <%
      iBizTypeLHidden = WtcUtil.repNull((String)request.getParameter("bizTypeLHidden"));
    %>
    if("<%=iBizTypeLHidden%>"=="02"){
      document.all.trAProdInfosFlag.style.display="";
      document.all.trAProdUnitInfosFlag.style.display="";
      document.all.trRetAProdInfoOne.style.display="";
      document.all.trRetAProdInfoTwo.style.display="";
      document.all.getRetAProdProperTab.style.display="";
      $("#AProdInfosBtn").attr("disabled",true);
      $("#AProdGrpIdNoBtn").attr("disabled",true);
      <%
          iA_prodUnitIdHidden = WtcUtil.repNull((String)request.getParameter("A_prodUnitId"));
          iA_prodIccidHidden = WtcUtil.repNull((String)request.getParameter("A_prodIccid"));
          iAProd_grpIdNoHidden = WtcUtil.repNull((String)request.getParameter("AProd_grpIdNoHidden"));
          iret_prodCodeHidden = WtcUtil.repNull((String)request.getParameter("ret_prodCode")); 
          iret_prodNameHidden = WtcUtil.repNull((String)request.getParameter("ret_prodName")); 
      %>
       var AProd_grpIdNoHidden = $("#AProd_grpIdNoHidden").val();
       var custId = $("#cust_id").val();
       var packet = new AJAXPacket("f3690_ajax_getAProdUnitProperty.jsp","���ڻ�����ݣ����Ժ�......");
       packet.data.add("opCode","<%=opCode%>");
       packet.data.add("AProd_grpIdNoHidden",AProd_grpIdNoHidden);
       packet.data.add("custId",custId);
       core.ajax.sendPacket(packet,doGetAProdUnitProperty);
       packet = null;
    }
    /*end diling add @2012/12/25 */
}
        if(sm_code=="AD" || sm_code=="ML" || sm_code=="MA"){//ADC������MAS��ȫ��MAS
            document.all.productGroup.style.display="none";//����ԭ�С����Ų�Ʒ�����Ÿ��Ӳ�Ʒ��ѡ��
            document.all.grpProId.style.display="";
        }else{
            document.all.productGroup.style.display="none";
            document.all.grpProId.style.display="none";
        }
        if(sm_code=="vp"){//VPMN
            //document.all.province_id.style.display="";
            document.all.cashPay_div.style.display="none";
            document.all.pay_type22.style.display="none";
            document.all.payTypeId.style.display="";
            document.all.sure.disabled="";//��"ȷ��"��ť��Ϊ����
        }else{
            document.all.cashPay_div.style.display="";
            document.all.pay_type22.style.display="";
            document.all.payTypeId.style.display="none";
        }
        if(sm_code=="va"){//BOSS��VPMN
            document.all.grp_userno.readOnly=false;
            document.all.sure.disabled="";//��"ȷ��"��ť��Ϊ����
        }
        <%if((openLabel!=null && openLabel.equals("opcode")) || "DL100".equals(openLabel)){%>
            if(sm_code == "CR"){//�����Ʒ
                //document.all.proType.style.display="";
                //document.all.ProdAppendQuery.disabled="true";
            <%
                /*****************************
                 * �����Ʒʱ����ҪԤ�Ƚ�����֤��
                 *****************************/
                String[][] resultList123 = new String[][]{};			 
                
            %>
                <wtc:service name="sGrpCustQry" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode113" retmsg="retMsg113" outnum="1" >
                  <wtc:param value="0"/>
                  <wtc:param value="01"/>
                  <wtc:param value="<%=opCode%>"/>
                  <wtc:param value="<%=workno%>"/>	
                  <wtc:param value="<%=nopass%>"/>		
                  <wtc:param value=""/>	
                  <wtc:param value=""/>
                  <wtc:param value=""/>
                  <wtc:param value="<%=cust_id%>"/>
                  <wtc:param value=""/>
                  <wtc:param value=""/>
                  <wtc:param value="<%=opCode%>"/>
                  <wtc:param value=""/>	
                  <wtc:param value=""/>
                  <wtc:param value=""/>
                  <wtc:param value=""/>
                  <wtc:param value=""/>
                  <wtc:param value="1"/>
                  <wtc:param value=""/>
                  <wtc:param value="1"/>
                  <wtc:param value="<%=sm_code%>"/>
                  <wtc:param value=""/>
                  <wtc:param value=""/>
                  <wtc:param value=""/>
                </wtc:service>
                <wtc:array id="retArr113" scope="end"/>  
            <%      
                if(retArr113.length>0 && retCode113.equals("000000")){
                    resultList123 = retArr113;
                }
                
                int recordNum1 = Integer.parseInt(resultList123[0][0].trim());
                
                if(recordNum1==1){
            %>
                    rdShowMessageDialog("�˼��ſͻ��Ѿ��ǲ����û����û���Ԥ��״̬��");
                    this.location="f3690_1.jsp";
                <%}%>
            }
        <%}%>
    <%}%>
    
    <%if (request.getParameter("custPwd")!=null){%>
        document.all.custPwd.value="<%=request.getParameter("custPwd")%>";
    <%}%>

<%
    /*****************************
     * �߶˵���ʱ�����÷��񣬻�ȡ���۷��洫������ݡ�
     *****************************/
    if(openLabel!=null && openLabel.equals("link")){
        try{
        %>
            <wtc:service name="QryServMC" routerKey="region" routerValue="<%=regionCode%>" retcode="QryServMCCode" retmsg="QryServMCMsg" outnum="23" >
                <wtc:param value="<%=in_GrpId%>"/>
                <wtc:param value="<%=in_ChanceId%>"/> 
                <wtc:param value="0"/>
                <wtc:param value=""/>
                <wtc:param value="<%=inBatchNo%>"/>
            </wtc:service>
            <wtc:array id="QryServMCArr" start="6" length="17" scope="end"/>
            <wtc:array id="QryServMCArr2" start="0" length="6" scope="end"/>
            
        <%
            if("000000".equals(QryServMCCode) && QryServMCArr2.length>0){
            System.out.println("f3690_1.jsp -> service QryServMC :"+QryServMCCode+"----"+QryServMCMsg);
                for(int i=0;i<QryServMCArr2.length;i++){
                    if("F00019".equals(QryServMCArr2[i][1]) && !("".equals(QryServMCArr2[i][3]))){
                        out.print("document.all.tr_gongnengfee.style.display=\"\";");
                    }
                    out.print("if(document.getElementById('"+QryServMCArr2[i][1]+"') != null){");
                    //zhouby
                    
                    System.out.println(" zhoubyt " + QryServMCArr2[i][1]);
                    System.out.println(" zhoubyt " + QryServMCArr2[i][3]);
%>

                    var zValue = '<%=QryServMCArr2[i][3]%>';
                    var zTarget = document.getElementById("<%=QryServMCArr2[i][1]%>");
                    //����Ƕ˵�����Ŀ������
<%               if ("hl".equals(sm_code) || "hj".equals(sm_code)){%>
                    if ($(zTarget).is('select') && zValue == ''){
                        $(zTarget).empty().html('<option value=""></option>');
                    } else {
                        $(zTarget).val(zValue);
                    }
<%               } else {  %>
                    //���Ƕ˵���������
                    zTarget.value = zValue;
<%               }  
                    out.print("}");

                    if(!"F00006".equals(QryServMCArr2[i][1])){//�����ź����⣬��Ϊ�����޸ġ�
                        /* ���Σ��ں���ͳһ�������� # by qidp @ 2009-08-06 .
                        out.print("if(document.getElementById('"+QryServMCArr2[i][1]+"') != null){");
                        out.print("document.getElementById('"+QryServMCArr2[i][1]+"').disabled=true;");
                        out.print("}");
                        */
                    }else{
                        out.print("document.all.F00006.readOnly=false;");
                        out.print("$(document.all.F00006).removeClass(\"InputGrey\");");
                    }
                    System.out.println("----code="+QryServMCArr2[i][1]+"--value="+QryServMCArr2[i][3]);
                }
            }else{
                %>
                rdShowMessageDialog("<%=QryServMCCode%>" + "[" + "<%=QryServMCMsg%>" + "]" ,0);
                removeCurrentTab();
                <%
                System.out.println("f3690_1.jsp -> service QryServMC :"+QryServMCCode+"----"+QryServMCMsg);
            }
            
            if("000000".equals(QryServMCCode) && QryServMCArr.length>0){
                out.print("document.all.iccid.value=\""+QryServMCArr[0][0]+"\";");
                out.print("document.all.cust_id.value=\""+QryServMCArr[0][1]+"\";");
                out.print("document.all.unit_id.value=\""+QryServMCArr[0][2]+"\";");
                out.print("document.all.cust_name.value=\""+QryServMCArr[0][3]+"\";");
                out.print("document.all.F10305.value=\""+QryServMCArr[0][4]+"\";");
                out.print("document.all.F10306.value=\""+QryServMCArr[0][5]+"\";");
                out.print("document.all.F10307.value=\""+QryServMCArr[0][6]+"\";");
                out.print("document.all.grp_name.value=\""+QryServMCArr[0][7]+"\";");
                //if("AD".equals(sm_code) || "MA".equals(sm_code) || "ML".equals(sm_code)){
                //    out.print("document.all.prod_direct.value=\""+QryServMCArr[0][8]+"\";");
                //}
                out.print("document.all.F00018.value=\""+QryServMCArr[0][9]+"\";");
                out.print("document.all.F00017.value=\""+QryServMCArr[0][10]+"\";");
                F00017 = QryServMCArr[0][10];
                out.print("document.all.belong_code.value=\""+QryServMCArr[0][11]+"\";");
                out.print("document.all.group_id.value=\""+QryServMCArr[0][12]+"\";");
                out.print("document.all.bizCode.value=\""+QryServMCArr[0][13]+"\";");
                out.print("document.all.product_prices.value=\""+QryServMCArr[0][15]+"\";");
                out.print("document.all.catalog_item_id.value=\""+QryServMCArr[0][16]+"\";");
                out.print("document.all.iccid.disabled=true;");
                out.print("document.all.cust_id.disabled=true;");
                out.print("document.all.unit_id.disabled=true;");
                out.print("document.all.cust_name.disabled=true;");
                out.print("document.all.F10305.disabled=true;");
                out.print("document.all.F10306.disabled=true;");
                out.print("document.all.F10307.disabled=true;");
                if(!"hl".equals(sm_code)){  //Ʒ��Ϊhlʱ���û����Ʋ��û�
                  out.print("document.all.grp_name.disabled=true;");
                }
                //if("AD".equals(sm_code) || "MA".equals(sm_code) || "ML".equals(sm_code)){
                //    out.print("document.all.prod_direct.disabled=true;");
                //}
                out.print("document.all.F00018.disabled=true;");
                //out.print("document.all.F00017.disabled=true;");
                out.print("document.all.ProdQuery.disabled=true;");
                out.print("document.all.ProdQuery2.disabled=true;");
                /*********************
                 *  begin ��Ϊ�˵��˵���������ļ���ר�߶�����������ר�ߡ�����ר�ߡ�GPRSӦ�ý��롢������ר�ߡ����Ž����࣬�ڲ�Ʒ����ʱ���޸�Ϊ����ѡ���Ų�Ʒ�ʷ�@2012/7/11 
                 *********************/
                String  grodDisableStr [] = new String[2];
                grodDisableStr[0] = "SELECT main_type FROM sbiztypecode WHERE external_code = :externalCode";
                grodDisableStr[1] = "externalCode="+catalog_item_id;
             %>
                <wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="grodDisableRetCode" retmsg="grodDisableRetMsg" outnum="1"> 
                  <wtc:param value="<%=grodDisableStr[0]%>"/>
                  <wtc:param value="<%=grodDisableStr[1]%>"/> 
                </wtc:service>  
                <wtc:array id="grodDisableStrRet"  scope="end"/>
             <%
                if("000000".equals(grodDisableRetCode)){
                  if(grodDisableStrRet.length>0){
                    System.out.println("---------3690--------grodDisableStrRet[0][0]="+grodDisableStrRet[0][0]);
                    System.out.println("---------3690--------catalog_item_id="+catalog_item_id);
                    if("118".equals(catalog_item_id) || "119".equals(catalog_item_id) || "120".equals(catalog_item_id) || "121".equals(catalog_item_id) || "122".equals(catalog_item_id) || "211".equals(catalog_item_id) || "227".equals(catalog_item_id)){
                      out.print("document.all.F00017.disabled=false;");
                      out.print("document.all.ProdQuery2.disabled=false;");
                    }
                  }
                }
                /*  end @2012/7/11 */
                for(int i=0;i<QryServMCArr[0].length;i++){
                    System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@["+i+"]==="+QryServMCArr[0][i]);
                }
                
            }
        }catch(Exception e){
            e.printStackTrace();
            System.out.println("f3690_1.jsp -> Call service QryServMC failed!");
        }
        
        String pricesql="select nvl(if_cust_price,'F')  from product_offer where offer_id ="+F00017.substring(0,F00017.indexOf("|")); 
        %>
        	<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCodepp" retmsg="retMsgpp" outnum="1">
        		<wtc:sql><%=pricesql%></wtc:sql>
        	</wtc:pubselect>
        	<wtc:array id="resultprice" scope="end" />
        <%
        if("000000".equals(retCodepp) && resultprice.length>0){
            cust_price = resultprice[0][0];
            System.out.println("cust_pricecust_pricecust_pricecust_pricecust_pricecust_pricecust_pricecust_price===="+cust_price);
        } 
        
        /*****************************
         * �߶˵���ʱ��һЩԪ�ز������޸ġ�
         *****************************/
        String sql33 = "";
        try{
            sql33 = "select name_id,name_type from sgrpmsgdisabled where sm_code = '"+sm_code+"' and OP_TYPE = '1' and disabled_flag = 'N'";
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
        }catch(Exception e){
            e.printStackTrace();
            System.out.println("# f3690_1.jsp -> failed! SQL = " + sql33);
        }
        
        out.print("document.all.ProdAttrQuery.disabled=true;");
        
       /*****************************
       * �߶˵���ʱ������Z�����Բ����޸�
       *****************************/
       try{
       %>
      <wtc:service name="QryServMC" routerKey="region" routerValue="<%=regionCode%>" retcode="QryServMCCodeQuality" retmsg="QryServMCMsgQuality" outnum="24" >
        <wtc:param value="<%=in_GrpId%>"/>
        <wtc:param value="<%=in_ChanceId%>"/> 
        <wtc:param value="0"/>
        <wtc:param value=""/>
        <wtc:param value="<%=inBatchNo%>"/>
      </wtc:service>
      <wtc:array id="QryServMCArrQuality" scope="end"/>
      <%
       if("000000".equals(QryServMCCodeQuality)){
        if(QryServMCArrQuality.length>0){
          String insertStr = "";
          int terminalTr = 0;
          int tdVal = 13 ;
          int row = 1;
          for(int i=0;i<QryServMCArrQuality.length;i++){
            //int coll = 10637;
            int coll = 10657;
            if((!"".equals(QryServMCArrQuality[i][23]))&&(QryServMCArrQuality[i][23]!=null)){ //z������ֵ
              for(int j = 0;j < (QryServMCArrQuality.length-1);j++){
                if((!"".equals(QryServMCArrQuality[j][23]))&&(QryServMCArrQuality[j][23]!=null)){
                  if((row == Integer.parseInt(QryServMCArrQuality[j][23],10))&& ("F10622".equals(QryServMCArrQuality[j][1]))){
                    insertStr =insertStr + QryServMCArrQuality[j][3] + "|";
                  }
                }
              }
              for(int p = 0;p < 20;p++){
                for(int k = 0;k < QryServMCArrQuality.length;k++){
                  if((!"".equals(QryServMCArrQuality[k][23]))&&(QryServMCArrQuality[k][23]!=null)){
                    if((row == Integer.parseInt(QryServMCArrQuality[k][23],10)) && (coll == Integer.parseInt((QryServMCArrQuality[k][1].substring(1,QryServMCArrQuality[k][1].length()))))){
                       insertStr = insertStr + QryServMCArrQuality[k][3] + "|";
                    }
                  }
                }
                
      		      if(coll==10663){
                  coll = coll + 25;//10688
                }else if(coll==10689){ 
                  coll = coll - 25;//10664
                }else if(coll==10670){
                  coll = coll + 20; //10690
                }else if(coll==10691){
                  coll = coll - 5; //10686
                }else{ 
                  coll = coll + 1;
                }
                //coll = coll + 1;
              }
              row = row + 1;
            }else{//��������ֵ �����Ѿ���ֵ�������д���
              //out.print("$('#"+QryServMCArrQuality[i][1]+"').val('"+QryServMCArrQuality[i][3]+"');");
            }
          }
          String insertArr[]  = insertStr.split("\\|");
          if(insertArr.length>0){
           if((insertArr.length)%tdVal==0){ //��ȡ���� ÿ��13������
              
           }else if((insertArr.length)%7==0){
             tdVal = 7;
           }
           terminalTr = insertArr.length/tdVal;
            for(int ii = 0;ii<terminalTr;ii++){ 
              if( ii+1 != terminalTr){
                out.print(" $('input[name^=\"addSegment\"]').click();");
              }
              for(int zz = 0;zz<tdVal;zz++){
                if(insertArr[ii*tdVal+zz]!=null&&!("".equals(insertArr[ii*tdVal+zz]))){
                  out.print("$('#segMentTab1 tr:eq("+(ii+2)+")').find(':text:eq("+zz+")').val('"+insertArr[ii*tdVal+zz]+"');");
                }else{
                  out.print("$('#segMentTab1 tr:eq("+(ii+2)+")').find(':text:eq("+zz+")').val('"+" "+"');");
                }
              }
              for(int i = 0;i<insertArr.length;i++){
                //out.print("$('#segMentTab1 tr:eq("+(ii+2)+")').find(':text:eq("+i+")').val('"+insertArr[i]+"');");
                out.print("$('#segMentTab1 tr:eq("+(ii+2)+")').find(':text:eq("+i+")').attr(\"readOnly\",\"true\");");
                out.print("$('#segMentTab1 tr:eq("+(ii+2)+")').find(':text:eq("+i+")').addClass(\"InputGrey\");");
                out.print("$('#segMentTab1 tr:eq("+(ii+2)+")').find(':button:eq("+i+")').attr(\"disabled\",\"true\");");
              }
            }
            out.print("$('input[name^=\"addSegment\"]').attr(\"disabled\",\"true\");");
          }
        }
       }
     }catch(Exception e){
       e.printStackTrace();
       System.out.println("# f3690_1.jsp -> failed! serviceName = QryServMC---222");
     }
   }
    
    /*****************************
     * �߶˵���ʱ��ML-����MAS�������⴦����
     *****************************/
    if("ML".equals(MLFlag)){
        String[][] MLArr = new String[][]{};
        try{
        %>
            <wtc:service name="sGrpBizQry" routerKey="region" routerValue="<%=regionCode%>" retcode="sGrpBizQryCode" retmsg="sGrpBizQryMsg" outnum="7" >
            	<wtc:param value="<%=in_GrpId%>"/>
            	<wtc:param value="<%=in_ChanceId%>"/>
            	<wtc:param value="<%=regionCode.substring(0,2)%>"/>
            </wtc:service>
            <wtc:array id="sGrpBizQryArr" scope="end"/>
        <%
            if("000000".equals(sGrpBizQryCode) && sGrpBizQryArr.length>0){
                MLArr = sGrpBizQryArr;
                %>
                    $("#iccid").val("<%=MLArr[0][0]%>");
                    $("#cust_id").val("<%=MLArr[0][1]%>");
                    $("#unit_id").val("<%=in_GrpId%>");
                    $("#cust_name").val("<%=MLArr[0][2]%>");
                    $("#sm_code").val("<%=sm_code%>");
                    $("#belong_code").val("<%=MLArr[0][4]%>");
                    $("#group_id").val("<%=MLArr[0][5]%>");
                    changeSmCode();
                    $("#biz_code").val("<%=MLArr[0][6]%>");
                    $("#iccid").attr("readOnly",true);
                    $("#iccid").addClass("InputGrey");
                    $("#custQuery").attr("disabled",true);
                    $("#cust_id").attr("readOnly",true);
                    $("#cust_id").addClass("InputGrey");
                    $("#unit_id").attr("readOnly",true);
                    $("#unit_id").addClass("InputGrey");
                    $("#cust_name").attr("readOnly",true);
                    $("#cust_name").addClass("InputGrey");
                    $("#biz_code").attr("readOnly",true);
                    $("#biz_code").addClass("InputGrey");
                    $("#sm_code").find("option:not(:selected)").remove(); 
                <%
            }else{
                %>
                    rdShowMessageDialog("�������:<%=sGrpBizQryCode%>,������Ϣ:<%=sGrpBizQryMsg%>",0);
                    removeCurrentTab();
                <%
            }
        }catch(Exception e){
            e.printStackTrace();
            System.out.println("# return from f3690_1.jsp -> Call Service sGrpBizQry Failed!");
            %>
                rdShowMessageDialog("���÷���sGrpBizQryʧ�ܣ�",0);
                removeCurrentTab();
            <%
        }
    }
%>
    <%if("ML".equals(sm_code) || ("AD".equals(sm_code) && "opcode".equals(openLabel))){%>
        if("<%=billingtype%>" == "00" || "<%=billingtype%>" == "01")//�����ѻ����
    	{
    		document.all.tr_gongnengfee.style.display = "none";
    	}
    	else if("<%=billingtype%>" == "02")//�������
    	{
    		document.all.tr_gongnengfee.style.display = "block";
    	}
    <%}%>
    
    <%
    if("hl".equals(sm_code))
    {%>
     	$("#bizTypeLFlag2").attr("disabled",true); 
		$("#F10634").width('200px');
		if ( $("#F10634").val()=="������" )
		{
			$("#F10671").parent().show();
			$("#F10671").parent().prev().show();
			$("#F10671").width('200px');
		}
		else 
		{
			$("#hdF10671").val("1");
			$("#F10671").parent().hide();
			$("#F10671").parent().prev().hide();
		}   
    <%}%>
    
    <%if("DL100".equals(openLabel)){%>
        if($("#iccid").val() != ""){
            $("#iccid").attr("readOnly",true);
            $("#iccid").addClass("InputGrey");
        }
        if($("#cust_id").val() != ""){
            $("#cust_id").attr("readOnly",true);
            $("#cust_id").addClass("InputGrey");
        }
        if($("#unit_id").val() != ""){
            $("#unit_id").attr("readOnly",true);
            $("#unit_id").addClass("InputGrey");
        }
        if($("#cust_name").val() != ""){
            $("#cust_name").attr("readOnly",true);
            $("#cust_name").addClass("InputGrey");
        }
        if($("#F00017").val() != ""){
            $("#F00017").attr("readOnly",true);
            $("#F00017").addClass("InputGrey");
            $("#ProdQuery2").attr("disabled",true);
        }
        if($("#biz_code").val() != ""){
            $("#biz_code").attr("readOnly",true);
            $("#biz_code").addClass("InputGrey");
        }
        $("#sm_code").find("option:not(:selected)").remove();
    <%}%>
    
    /*********************
     * �˵������̣�
     *      ML:չʾbiz_code,sm_code���ɱ༭����Ʒ��ѡ��ҵ���С�಻չʾ��
     *      AD:չʾbiz_code,sm_code,��Ʒ���ɱ༭��Ĭ��չʾ��һ��֮�����ݡ�
     *      ����Ʒ��:չʾsm_code,��Ʒ���ɱ༭��Ĭ��չʾ��һ��֮�����ݡ�
     * ����100���̣�
     *      DL:չʾsm_code,��Ʒ���ɱ༭��
     *      AD/ML:ͬ�˵���ML��
     *      ����Ʒ�ƣ�sm_code���ɱ༭�����������С�ࡢҵ����������չʾ��
     *********************/
    <% if("From4091".equals(inOpenFlag)){%>
        if(sm_code == "ML"){
            $("#bizTypeFlag").css("display","none"); 
            $("#trBizCodeFlag").css("display","");
        }else if(sm_code == "AD"){
            $("#bizTypeFlag").css("display","none");
            $("#trBizCodeFlag").css("display","");
        }else if(sm_code == "hl"){
    		var fwpp2 = "<%=catalog_item_id%>";
        	if(fwpp2=="118"||fwpp2=="119"||fwpp2=="120"||fwpp2=="121"||fwpp2=="122"||fwpp2=="227"){ //licqa
            $("#bizTypeFlag").css("display","");  //licqa
            $("#bizTypeLFlag1").css("display",""); //licqa
            $("#bizTypeLFlag2").css("display",""); //licqa
            $("#bizTypeLFlag2").attr("disabled",true); 
    	}
        else{
        
        	 $("#bizTypeFlag").css("display","none");

         
          }
            $("#trBizCodeFlag").css("display","none");
            $("#10634").attr("disabled","true");//ҵ��Χ���ɸ�
        }
        document.frm.ProdQuery2.disabled=true;
    <%}else if("DL100".equals(inOpenFlag)){%>
        if(sm_code == "AD" || sm_code == "ML"){
            $("#bizTypeFlag").css("display","none");
            $("#trBizCodeFlag").css("display","");
        }else if(sm_code == "DL"){
            $("#bizTypeFlag").css("display","none");
            $("#trBizCodeFlag").css("display","none");
        }else{
            getBizLevel();
        }
        
    <%}else{%>
        
    <%}%>
    
    <% if("select".equals(action)){ %>
        /*********************
         * ����һ�����󣬴���С�಻չʾ��
         * AD��MLʱ��չʾҵ����룻����Ʒ�Ʋ�չʾ��
         *********************/
        $("#bizTypeFlag").css("display","none");
        if(sm_code == "AD" || sm_code == "ML"){
            $("#trBizCodeFlag").css("display","");
        }
        else if(sm_code == "hl"){
        	 var fwpp2 = "<%=catalog_item_id%>"; 
        	 if(fwpp2=="118"||fwpp2=="119"||fwpp2=="120"||fwpp2=="121"||fwpp2=="122"||fwpp2=="227")
       		 $("#bizTypeFlag").css("display",""); //licqa
    	}
        else{
            $("#trBizCodeFlag").css("display","none");
        }
    <% } %>
    
    /*begin add �������б��еĿ�ֵ���д��� for ��CRMϵͳ���ӡ�Ӫ�������ֶε�����@2015/4/22 */
    if(typeof($("#F10818")) != "undefined"){
			$("#F10818 option").each(function(){
	      if($(this).val() == ""){
	      	$(this).remove();
	      }
	    });
		}
		/*end add �������б��еĿ�ֵ���д��� for ��CRMϵͳ���ӡ�Ӫ�������ֶε�����@2015/4/22 */
		
		/*���������������ſͻ���Ϣ����Ŀ(��Ʒ)Ͷ�ʺ������Զ���ƥ�䱨���ĺ�
		 * liangyl 2016-07-11
		 * F10985
		 */
		if (typeof ($("#F10985").val())!="undefined" ){
			$("#F10985").parent().append("&nbsp;<input type='button' class='b_text' value='У��' onclick='ajax_check_F10985()' />"); 
		}
}

function doProcess(packet)
{
    var retType = packet.data.findValueByName("retType");
    var retCode = packet.data.findValueByName("retCode");
    var retMessage=packet.data.findValueByName("retMessage");
    self.status="";
    
    if(retType == "checkContract")
    {
    		//yuanqs add 2010/9/6 9:42:51 ������ˢ�»��ǹر�
    		isRefresh = false;
        if (parseInt(retCode) == 0)
        {
            //alert(packet.data.findValueByName("grpFlag"));
            //alert(packet.data.findValueByName("iCount"));
            if (packet.data.findValueByName("grpFlag")=="Y")
            if (packet.data.findValueByName("iCount")=="0")
            {
                rdShowMessageDialog("����¼�뼯�ź�ͬ");
                return false;
            }
            frm.action="f3690_1.jsp?action=select";
            frm.method="post";
            frm.submit();
        }
        else
        {
            rdShowMessageDialog("������룺" + retCode + "<br>������Ϣ��" + retMessage,0);
            return false;
        }
    }
    if(retType == "UserId")
    {
        if(retCode == "000000")
        {
            var retUserId = packet.data.findValueByName("retnewId");    	    
            document.frm.grp_id.value = retUserId;
            document.frm.grpQuery.disabled = true;
        }
        else
        {
            rdShowMessageDialog("û�еõ��û�ID,�����»�ȡ��");
            return false;
        }
        //�õ������û���ŵ�ʱ�򣬵õ����Ŵ���
        //getGrpId();
    }
    if(retType == "GrpId") //�õ����Ŵ���
    {
        if(retCode == "000000")
        {
            var GrpId = packet.data.findValueByName("GrpId");
            document.frm.grp_userno.value = oneTok(GrpId,"|",1);
        }
        else
        {
            var retMessage = packet.data.findValueByName("retMessage");
            rdShowMessageDialog(retMessage,0);
        }
    }
    if(retType == "GrpNo") //�õ������û����
    {
        if(retCode == "000000")
        {
            var GrpNo = packet.data.findValueByName("GrpNo");
            document.frm.grp_userno.value = GrpNo;
            document.frm.getGrpNo.disabled = true;
            //licqa
             $("#bizTypeFlag,#bizTypeLFlag1,#bizTypeLFlag2").css("display","");
                $("#bizTypeSFlag1,#bizTypeSFlag2,#trBizCodeFlag").css("display","none");
                getBizTypeL();
            //licqa
               
        }
        else
        {
            var retMessage = packet.data.findValueByName("retMessage");
            rdShowMessageDialog(retMessage,0);
        }
        
    }
    //---------------------------------------
    if(retType == "GrpCustInfo") //�û�����ʱ�ͻ���Ϣ��ѯ
    {
        var retname = packet.data.findValueByName("retname");
        if(retCode=="000000")
        {
            document.frm.cust_name.value = retname;
			document.frm.unit_id.focus();
        }
        else
        {
            retMessage = retMessage + "[errorCode1:" + retCode + "]";
            rdShowMessageDialog(retMessage,0);
			return false;
        }
     }
    if(retType == "AccountId") //�õ��ʻ�ID
    {
        if(retCode == "000000")
        {
            var retnewId = packet.data.findValueByName("retnewId");
            document.frm.account_id.value = retnewId;
            document.frm.accountQuery.disabled = true;
			//document.frm.user_passwd.focus();
        }
        else
        {
            rdShowMessageDialog("û�еõ��ʻ�ID,�����»�ȡ��");
        }
    }
    //---------------------------------------
    if(retType == "UnitInfo")
    {
        //������Ϣ��ѯ
        var retname = packet.data.findValueByName("retname");
        if(retCode=="000000")
        {
            document.frm.unit_name.value = retname;
			document.frm.contract_name.focus();
        }
        else
        {
            retMessage = retMessage + "[errorCode1:" + retCode + "]";
            rdShowMessageDialog(retMessage,0);
			return false;
        }
     }
     //---------------------------------------
     if(retType == "CheckMng_user") //����Ա�ʻ�У��
     {        
        if(retCode !=0)
        {     	
            rdShowMessageDialog(retMessage,0);
            document.frm.F10303.value = "";
            document.frm.F10303.focus();
            return false;
         }
        else
        {
          rdShowMessageDialog("����Ա�˻�У��ɹ�",2);
          document.frm.sure.disabled = false;
          //document.frm.sure2.disabled = false; 
        }
     } 
     //---------------------------------------
     if(retType == "checkPwd") //���ſͻ�����У��
     {
        if(retCode == "000000")
        {
            var retResult = packet.data.findValueByName("retResult");
            if (retResult == "false") {
    	    	rdShowMessageDialog("�ͻ�����У��ʧ�ܣ����������룡",0);
	        	frm.custPwd.value = "";
	        	frm.custPwd.focus();
    	    	return false;	        	
            } else {
                rdShowMessageDialog("�ͻ�����У��ɹ���",2);
                if(<%=nextFlag%>==1){
                	document.frm.next.disabled = false;
                }
                
            }
         }
        else
        {
            rdShowMessageDialog("�ͻ�����У�������������У�飡",0);
    		return false;
        }
     }	

     //---------------------------------------

    //zhouby ����select��ǩ
    if(retType == "getProdDirect")
    {
        if(retCode == "000000")
        {
			var backString = packet.data.findValueByName("backString");
         	var temLength = backString.length+1;
			var arr = new Array(temLength);
			var v_prod_direct = "<%=i_prod_direct%>";
			var label = "";
			/* add by qidp @ 2009-11-06 for [���ӡ���ѡ��] */
			arr[0] = "<OPTION value='' pvalue=''>---- ��ѡ�� ----</OPTION>";
			for(var i = 0 ; i < backString.length ; i ++)
			{
			    if(v_prod_direct == backString[i][0]){
			        label = " selected ";
			    }else{
			        label = "";
			    }
				arr[i+1] = "<OPTION value="+backString[i][0]+" pvalue="+backString[i][1]+" "+label+" >" +backString[i][1] + "</OPTION>";
			}
          	prod_direct_div.innerHTML = "<select id=prod_direct size=1 onChange=changeProdDirect() name=prod_direct>" + arr.join() + "</SELECT>&nbsp;<font class='orange'>*</font>";
         	chgGrpName();
		}
        else
        {
            rdShowMessageDialog("û�еõ����Ų�Ʒ����,�����»�ȡ��");
			return false;
        }
		
    }
    
    if(retType=="getBillingType")//�õ�sbillspcode�е� billingtype luxc add 20070916
    {
    	
    	if(retCode="000000")
    	{
    		
    		var billingtype = packet.data.findValueByName("billingtype");
    		var baseservcode=packet.data.findValueByName("baseservcode");
    		var bizattrtype=packet.data.findValueByName("bizattrtype");
    		//alert(baseservcode);
    		document.all.billingtype.value = billingtype;
    		document.all.BizServcode.value=baseservcode;
    		document.all.bizattrtype.value=bizattrtype;
    		
    		<%if(openLabel!=null && openLabel.equals("link")){%>
        		// document.all.F00006.value=baseservcode; wangzn modify 2012/2/29 10:06:40
        		document.all.F00006.readOnly = false;
        		$(document.all.F00006).removeClass("InputGrey");//�Ƴ�F00006�ϵġ�InputGrey����ʽ//add by qidp
        		showTip(document.all.F00006,"�������޸Ķ��ŷ������");
        	<%}else{%>
        	    document.all.telNo.value=baseservcode;
        	<%}%>
    		<%if("opcode".equals(openLabel) || "ML".equals(sm_code)){%>
        		if(billingtype == "00" || billingtype == "01")//�����ѻ����
        		{
        			document.all.tr_gongnengfee.style.display = "none";
        		}
        		else if(billingtype == "02")//�������
        		{
        			document.all.tr_gongnengfee.style.display = "block";
        		}
        		else
        		{
        			rdShowMessageDialog("��ѯsbillspcode,billingtype����="+billingtype,0);
        		}
        	<%}%>
    	}
    	else
    	{
    		rdShowMessageDialog(retMessage);
    	}
    }
    //---------------------------------------
     if(retType == "checkPhonePwd") //���Ѻ�������У��
     {
        if(retCode == "000000")
        {
            var retResult = packet.data.findValueByName("retResult");
            if (retResult == "false") {
    	    	rdShowMessageDialog("���Ѻ������벻�������������룡",0);
	        	frm.F10334.value = "";
	        	frm.F10334.focus();
    	    	return false;	        	
            } else {
                rdShowMessageDialog("���Ѻ�������У��ɹ���",2);
                frm.chkPass2.disabled = true;
                frm.F10333.readonly = true;
            }
         }
        else
        {
            rdShowMessageDialog("���Ѻ�������У�������������У�飡",0);
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
						doCfm();
        }
        else
        {
            rdShowMessageDialog("��ѯ��ˮ����,�����»�ȡ��",0);
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
				if(frm.real_handfee.value==''){
					frm.checkPay.value='0.00';
				}
				else
				{
				    frm.checkPay.value = frm.real_handfee.value;//add
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
	if(retType == "custaddress")//add
	{   //�õ��ͻ���ַ 
        if(retCode == "0")
        {
            var custAddress = packet.data.findValueByName("custAddress");
            if (custAddress == "false") {
    	    	rdShowMessageDialog("��ȡ�ͻ���ַʧ�ܣ�",0);
    	    	return false;	        	
            } else {
                document.frm.cust_address.value = custAddress;
            }
         }
        else
        {
            rdShowMessageDialog("��ȡ�ͻ���ַʧ�ܣ������»�ȡ��",0);
    		return false;
        }
	}
	if(retType == "query_channelid")/////////////
	{   //�õ�query_channelid
        if(retCode == "0")
        {
            var channel_name = packet.data.findValueByName("channel_name");
			var channel_id = packet.data.findValueByName("channel_id");
			//alert(channel_id);
            if (channel_id == "false") {
    	    	rdShowMessageDialog("��ȡchannelidʧ�ܣ�",0);
    	    	return false;	        	
            } else {
                document.frm.channel_id.value = channel_id;
            }
         }
        else
        {
            rdShowMessageDialog("��ȡchannelidʧ�ܣ������»�ȡ��",0);
    		return false;
        }
	}
	
    if(retType == "getBizLevel")
	{
        if(retCode == "000000")
        {
            var vBizLevel = packet.data.findValueByName("bizLevel");
            
            $("#bizLevel").val(vBizLevel);
            
            if(vBizLevel == "1"){
                $("#bizTypeFlag,#trBizCodeFlag").css("display","none");
            }else if(vBizLevel == "2"){
                $("#bizTypeFlag,#bizTypeLFlag1,#bizTypeLFlag2").css("display","");
                $("#bizTypeSFlag1,#bizTypeSFlag2,#trBizCodeFlag").css("display","none");
                getBizTypeL();
            }else if(vBizLevel == "3"){
            	  
                $("#bizTypeFlag,#bizTypeLFlag1,#bizTypeLFlag2,#bizTypeSFlag1,#bizTypeSFlag2").css("display","");
                $("#trBizCodeFlag").css("display","none");
                getBizTypeL();
            }else if(vBizLevel == "4"){
                $("#bizTypeFlag,#bizTypeLFlag1,#bizTypeLFlag2,#bizTypeSFlag1,#bizTypeSFlag2,#trBizCodeFlag").css("display","");
                getBizTypeL();
            }
        }
        else
        {
            rdShowMessageDialog(retMessage,0);
    		return false;
        }
	}

	if(retType == "getBizTypeL")
	{
        if(retCode == "000000")
        {
    		var backString = packet.data.findValueByName("backString");
         	var temLength = backString.length+1;
    		var arr = new Array(temLength);
    		
    		var fwpp = "<%=catalog_item_id%>";
    		//alert(fwpp);
    		//arr[0] = "<option value=''>--- ��ѡ�� ---</option>";
    		for(var i = 0 ; i < temLength-1 ; i ++)
    		{
    			if(fwpp=="118"&&backString[i][0]=="01")
    			{   			
	    			arr[0] = "<OPTION value="+backString[i][0]+">" +backString[i][1] + "</OPTION>";
	    			break;
    			}
    		  	if(fwpp=="119"&&backString[i][0]=="02") 
    		  	{
	    		  	arr[0] = "<OPTION value="+backString[i][0]+">" +backString[i][1] + "</OPTION>";
	    		  	break;
    		  	}
    		  	if(fwpp=="227"&&backString[i][0]=="09")//�˵�����ת�����ݴ��� ���� ��������ר��
    		  	{
	    		  	arr[0] = "<OPTION value="+backString[i][0]+">" +backString[i][1] + "</OPTION>";
	    		  	break;
    		  	}
    		  	 if(fwpp=="120"&&backString[i][0]=="03")
    		  	{
    		  	arr[0] = "<OPTION value="+backString[i][0]+">" +backString[i][1] + "</OPTION>";
    		  	break;
    		  	}
    		  	 if(fwpp=="121"&&backString[i][0]=="04")
    		  	{
    		  	arr[0] = "<OPTION value="+backString[i][0]+">" +backString[i][1] + "</OPTION>";
    		  	break;
    		  	}
    		  	 if(fwpp=="122"&&backString[i][0]=="05")
    		  	{
    		  	arr[0] = "<OPTION value="+backString[i][0]+">" +backString[i][1] + "</OPTION>";
    		  	break;
    		  	}
    		  	
				arr[i+1] = "<OPTION value="+backString[i][0]+">" +backString[i][1] + "</OPTION>";

    		}
    		
    		$("#bizTypeL").empty();
    		 <%
		    if(!"hl".equals(sm_code))
		    	{
		    %>
    			$("<option value=''>--- ��ѡ�� ---</option>").appendTo("#bizTypeL");
    		<%
    		}
    		%>
          	$(arr.join("")).appendTo("#bizTypeL");
          	
          	$("#bizTypeS").empty();
          	$("<option value=''>--- ��ѡ�� ---</option>").appendTo("#bizTypeS");
    	}
        else
        {
            rdShowMessageDialog("��ȡҵ�����ʧ��[������룺"+retCode+",������Ϣ��"+retMessage+"]",0);
    		return false;
        }
	}
	
	if(retType == "getBizTypeS")
	{
        if(retCode == "000000")
        {
    		var backString = packet.data.findValueByName("backString");
         	var temLength = backString.length;
    		var arr = new Array(temLength);
    		for(var i = 0 ; i < temLength ; i ++)
    		{
    			arr[i] = "<OPTION value="+backString[i][0]+">" +backString[i][1] + "</OPTION>";
    		}
    		
    		$("#bizTypeS").empty();
          	$(arr.join("")).appendTo("#bizTypeS");
    	}
        else
        {
            rdShowMessageDialog("��ȡҵ�����ʧ��[������룺"+retCode+",������Ϣ��"+retMessage+"]",0);
    		return false;
        }
	}
}

function showPrtDlg(printType,DlgMessage,submitCfm){
      var h=180;
			var w=350;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			
			var pType="subprint";             				 		//��ӡ���ͣ�print ��ӡ subprint �ϲ���ӡ
			var billType="1";              				 			  //Ʊ�����ͣ�1���������2��Ʊ��3�վ�
			var sysAccept = document.frm.login_accept.value;       //��ˮ��
			var mode_code=null;           							  //�ʷѴ���
			var fav_code=null;                				 		//�ط�����
			var area_code=null;             				 		  //С������
			var opCode = "<%=opCode%>";
			
		
		
			printStr = printInfo(printType);
			var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+
					"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
				
			var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_dz.jsp?DlgMsg=" + DlgMessage ;
			path += "&mode_code="+mode_code+
				"&fav_code="+fav_code+"&area_code="+area_code+
				"&opCode="+opCode+"&sysAccept="+sysAccept+
				"&submitCfm="+submitCfm+"&pType="+
				pType+"&billType="+billType+ "&printInfo=" + printStr;
				
			var ret=window.showModalDialog(path,printStr,prop);
			return ret;
    }
  
 var main_note = ""; 
 function printInfo(printType)
	{ 
		var vPayType = $("#payType").val();
    var vPayTypeTxt = "";
    if(vPayType == "0"){
        vPayTypeTxt = "�ֽ�";
    }else{
        vPayTypeTxt = "֧Ʊ";
    }
	
		/*2014/08/25 15:36:34 gaopeng ����ֹ�˾���ڵ��ӹ���Ӧ��������⼰����ķ��� 
			�����ϰ�������ӡ����Ϊ�������
		*/
		/*��󷵻ص��ַ���*/
		var retInfo = "";
		/*�û���Ϣ��*/
		var cust_info="";
		/*����ҵ����Ϣ��*/
		var opr_info="";
		/*��ע��Ϣ��*/
		var note_info1="";
		var note_info2="";
		var note_info3="";
		var note_info4="";
		
		cust_info += "�ͻ�������   "+ $("#cust_name").val() +"|";
		cust_info += "֤�����룺   "+ document.frm.iccid.value +"|";
		cust_info += "���ſͻ����룺   "+ document.frm.grp_id.value +"|";
		
	
    
    opr_info += "���ʽ��   "+ vPayTypeTxt +"|";
    opr_info += "�����˺ţ�   "+ document.frm.account_id.value +"|";
    
    opr_info += "����ҵ��   "+ "���Ų�Ʒ����" +"|";
    opr_info += "������ˮ��   "+ document.frm.login_accept.value +"|";
    opr_info += "�����Ʒ��   "+ document.frm.product_name.value +"|";
		
		if($("#sm_code").val()=="IC"){
					opr_info += "������Ϣ��|"
			    opr_info += "        ICTҵ�񼯳ɷ� "+$("#F10980").val()+"Ԫ|";
    			opr_info += "        ICT������Ϣ�����ɷ� "+$("#F10981").val()+"Ԫ|";
		}
		//����Ƶ�������Ӳ�ѯע������� hejwa  2015��9��16��16:59:32
	  if($("#sm_code").val()=="SH"){
	  	var product_code = document.all.F00017.value;
			var chPos = product_code.indexOf("|");
			product_code = product_code.substring(0,chPos);
	  	ajax_get_main_note(product_code);
	  	opr_info+="�ʷ�˵����"+main_note+"|";
	  }
	  
	  
		note_info1 += "ϵͳ��ע�� "+ document.frm.sysnote.value +"|";
		note_info1 += "�û���ע�� "+ document.frm.tonote.value +"|";
		
		retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
		retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
		return retInfo;	
		
	}   

function ajax_get_main_note(product_code){
	    var packet = new AJAXPacket("ajax_get_main_note.jsp","���Ժ�...");
        packet.data.add("mode_code",product_code); 
        packet.data.add("opCode","<%=opCode%>"); 
    core.ajax.sendPacket(packet,doAjax_get_main_note);
    packet =null;
}
function doAjax_get_main_note(packet){
    	 main_note =  packet.data.findValueByName("main_note");
}

function doCfm(){
	var prtFlag=0;
	var confirmFlag=0;
	
	showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes");
		//hejwa add �����ϱ����ſͻ���2014��2�µ�һ��ϵͳ����ĺ�-1-�Ż�����ר�߶˵�����Ϣ֧��ϵͳ���ֹ���  2014��3��12��15:22:27
		//�����ʾ�鷳���ñ����ķ�ʽ������ʾ��
		var hitMessage = "";
		if($("#sm_code").val()=="hl"){
			hitMessage = "��ȷ��ѡ����ʷ�Ϊ�����ʷѷ���Ŀ�ʷѣ�";
		}else{
			hitMessage = "�Ƿ��ύ���β�����";
		}
confirmFlag = rdShowConfirmDialog(hitMessage);

	if (confirmFlag==1){
		    //����ӡ��Ҫ����Ӧ����
			spellList();
			/* begin for ������ר�߿�����������ͳ̸ר����Ŀ��дԪ�صĺ�@2014/11/24 */
			if(typeof($("[name=F10774]:checkbox")) != "undefined"){
				var checks = "";
				$("input[name='F10774']").each(function(){
					if($(this).attr("checked") == true){
						checks += $(this).val() + ","; //��̬ƴȡѡ�е�checkbox��ֵ���á�,�����ŷָ�
					}
				});
				if(checks.length>0){
					checks= checks.substr(0,checks.length-1);
				}
				$("input[name='F10774']").val(checks);
			}
			/* end for ������ר�߿�����������ͳ̸ר����Ŀ��дԪ�صĺ�@2014/11/24 */
			if(document.all.f5000Flag2.style.display == "" && $("#F10500").val() != ""){
                var vAppendVal = $("#product_append").val();
                var vAppendArr = vAppendVal.split(",");
                var vAppendFlag = "Y";
                for(var s=0;s<vAppendArr.length;s++){
                    if(vAppendArr[s] == "5000"){
                        vAppendFlag = "N";
                        break;
                    }
                }
                if(vAppendFlag == "Y"){
                    if(vAppendVal == ""){
                        vAppendVal = "5000";
                    }else{
                        vAppendVal += ",5000";
                    }
                }
            }
            $("#product_append").val(vAppendVal);
			$("input:text:disabled").attr("disabled",false);
			$("select:disabled").attr("disabled",false);
			$("#sure").attr("disabled",true);
			
		 
			if(document.frm.sm_code.value=='CK'){
				document.frm.nameList.value      = document.frm.nameList.value      + "10967|10968|10969|10970|";
				document.frm.nameGroupList.value = document.frm.nameGroupList.value + "0|0|0|0|";
				document.frm.openFlagList.value  = document.frm.openFlagList .value + "Y|Y|Y|Y|";
				
			}
			
			

			
			frm.action="f3690_2.jsp";
			frm.submit();
	        loading();
		}
}

function check_HidPwd()
{
		var cust_id = document.all.cust_id.value;
		var Pwd1 = document.all.custPwd.value;
		var checkPwd_Packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s3690/pubCheckPwd.jsp","���ڽ�������У�飬���Ժ�......");
		checkPwd_Packet.data.add("retType","checkPwd");
		checkPwd_Packet.data.add("cust_id",cust_id);
		checkPwd_Packet.data.add("Pwd1",Pwd1);
		core.ajax.sendPacket(checkPwd_Packet);
		checkPwd_Packet = null;
}

function check_mnguser()//��֤����Ա�ʻ�
{    
	 if(((document.frm.F10303.value).trim()) == "")
    {
        rdShowMessageDialog("����Ա�û�����Ϊ�գ�");
        return false;
    } 
    var checkPwd_Packet = new AJAXPacket("CheckMng_user.jsp","���ڽ�������У�飬���Ժ�......");
    checkPwd_Packet.data.add("retType","CheckMng_user");
	  checkPwd_Packet.data.add("orgCode","<%=org_code%>");
	  checkPwd_Packet.data.add("LoginNo","<%=workno%>");
	  checkPwd_Packet.data.add("op_code",document.frm.op_code.value);
	  checkPwd_Packet.data.add("Mng_user",document.frm.F10303.value);
	  core.ajax.sendPacket(checkPwd_Packet);
	  checkPwd_Packet = null;
}

function getAccountId()
{

	//query_custaddress();//�õ��ͻ���ַ
	//�õ��ʻ�ID
	  var getAccountId_Packet = new AJAXPacket("../s3690/f1100_getId.jsp","���ڻ���ʻ�ID�����Ժ�......");
	getAccountId_Packet.data.add("region_code","<%=regionCode%>");
	getAccountId_Packet.data.add("retType","AccountId");
	getAccountId_Packet.data.add("idType","1");
	getAccountId_Packet.data.add("oldId","0");
	core.ajax.sendPacket(getAccountId_Packet); 
	getAccountId_Packet = null;

}

//�õ������û����user_no
function getGrpUserNo()
{
    var sm_code = document.frm.sm_code.value;

    //�����ж��Ƿ��Ѿ�ѡ���˷���Ʒ��
    if(document.frm.sm_code.value == "")
    {
        rdShowMessageDialog("������ѡ������Ϣ����Ʒ��",0);
        return false;
    }

    var getgrp_Userno_Packet = new AJAXPacket("getGrpUserno.jsp","���ڻ�ü��Ų�Ʒ��ţ����Ժ�......");
    getgrp_Userno_Packet.data.add("retType","GrpNo");
    getgrp_Userno_Packet.data.add("orgCode","<%=org_code%>");
    getgrp_Userno_Packet.data.add("smCode",sm_code);
    core.ajax.sendPacket(getgrp_Userno_Packet);
    getgrp_Userno_Packet = null;
}
//У�鸶�Ѻ��������
function check_PayPwd()
{
    var payno = document.all.F10333.value;
    var Pwd1 = document.all.F10334.value;
    var checkPwd_Packet = new AJAXPacket("pubCheckPwd2.jsp","���ڽ��и��Ѻ�������У�飬���Ժ�......");
    checkPwd_Packet.data.add("retType","checkPhonePwd");
	checkPwd_Packet.data.add("phone_no",payno);
	checkPwd_Packet.data.add("Pwd1",Pwd1);
	core.ajax.sendPacket(checkPwd_Packet);
	checkPwd_Packet = null;		
}

function getGrpId()
{
    //�õ������������û�����
    var getgrp_no_Packet = new AJAXPacket("../s3690/getGrpId.jsp","���ڻ�ü��Ŵ��룬���Ժ�......");
    getgrp_no_Packet.data.add("retType","GrpId");
    getgrp_no_Packet.data.add("orgCode","<%=org_code%>");
    core.ajax.sendPacket(getgrp_no_Packet);
    getgrp_no_Packet=null;
}

function getUserId()
{
    //�õ������û�ID���͸����û�IDһ��
    var getUserId_Packet = new AJAXPacket("../s3690/f1100_getId.jsp","���ڻ���û�ID�����Ժ�......");
	getUserId_Packet.data.add("region_code","<%=regionCode%>");
	getUserId_Packet.data.add("retType","UserId");
	getUserId_Packet.data.add("idType","1");
	getUserId_Packet.data.add("oldId","0");
	core.ajax.sendPacket(getUserId_Packet);
	getUserId_Packet = null;
}
 //��һ��
function nextStep()
{
    // zhouby add for �������ƶ�iNG ESOP v2.0.02(����)ҳ���������  2013-11-28
    if (!validateCallCenter()){
        return false;
    }
    
    /*begin diling add for Ʒ�ƣ�ҵ����࣬ҵ��С��@2012/6/21 */
    var v_smCode = $("#sm_code").val();  
    var v_bizTypeL= $("#bizTypeL").val();
    var v_bizTypeS = $("#bizTypeS").val();
    $("#smCodeHidden").val(v_smCode);
    $("#bizTypeLHidden").val(v_bizTypeL);
    $("#bizTypeSHidden").val(v_bizTypeS);
    /*end diling add @2012/6/21 */
    
    /*begin diling add for ��ѡ�����Ʒ��Ϊ����ר�ߣ�ҵ�����Ϊ������ר�ߡ�ʱ���ж��Ƿ�����д�������@2012/12/6*/
    var v_A_prodUnitId = $("#A_prodUnitId").val();
    var v_A_prodIccid = $("#A_prodIccid").val();
    var v_AProd_grpIdNoHidden = $("#AProd_grpIdNoHidden").val();
    var v_chkAproInfoFlag = $("#chkAproInfoFlag").val();
    if("From4091"!="<%=inOpenFlag%>"&&"DL100"!="<%=inOpenFlag%>"){//ֱ�ӿ�����ʱ��
      if($("#sm_code").val()=="hl"&&$("#bizTypeL").val()=="02"){//������������ֹ�˾���뼯��ר��3690��Ʒ����Ȩ�޵���ʾ@2013/4/2 ��ȥ����������ⲿ������@2013/4/11��
        if(v_A_prodUnitId==""&&v_A_prodIccid==""){
          rdShowMessageDialog("����дA�˲�Ʒ���ű�ţ�����A�˲�Ʒ֤�����룡",0);
          $("#A_prodUnitId").focus();
          return false;
        }
        if(v_AProd_grpIdNoHidden==""){
          rdShowMessageDialog("���A�˼��Ų�ƷID���ݽ���У�飡",0);
          $("#AProd_grpIdNoHidden").focus();
          return false;
        }
        if(v_chkAproInfoFlag=="N"){
          rdShowMessageDialog("���A�˼��Ų�ƷID���ݽ���У�飡",0);
          return false;
        }
      }
      /*2016/6/30 14:41:28 gaopeng �޸�ȥ��02�ж�*/
      else if($("#sm_code").val()=="hl"&&$("#bizTypeL").val()!="02"){//������������ֹ�˾���뼯��ר��3690��Ʒ����Ȩ�޵���ʾ@2013/4/2 ��ȥ����������ⲿ������@2013/4/11��
        rdShowMessageDialog("����ר��ҵ���뵽�˵��˰�����",0);
        return false;
      }
    }

    /*end diling add @2012/12/6 */
    var vGrpProduct = $("#F00017").val();
    if(vGrpProduct == ''){
        rdShowMessageDialog("��ѡ���Ų�Ʒ��",0);
        $("#ProdQuery2").focus();
        return false;
    }
    
    var checkContract = new AJAXPacket("f3500_checkContract.jsp","���ڼ���û���Ϣ�����Ժ�......");
	checkContract.data.add("retType","checkContract");
	checkContract.data.add("sm_code",document.all.sm_code.value);
	checkContract.data.add("cust_id",document.all.cust_id.value);
	core.ajax.sendPacket(checkContract);
	checkContract = null;


}
//��һ��
function previouStep(){
	frm.action="f3690_1.jsp";
	frm.method="post";
	frm.submit();
}
//��ѯ�ͻ���ַ
function query_custaddress()
{
	if(document.frm.cust_id.value == "")
	{
		return false;
	}

    var getInfoPacket = new AJAXPacket("s3500_custaddress.jsp","���ڲ�ѯ�ͻ���ַ�����Ժ�......");
	getInfoPacket.data.add("retType","custaddress");
	getInfoPacket.data.add("cust_id",document.frm.cust_id.value);
	core.ajax.sendPacket(getInfoPacket);
	getInfoPacket = null;
}
//��ѯchannel_id
function query_channelid()
{
    var getInfoPacket = new AJAXPacket("s3500_channelid.jsp","���ڲ�ѯ�����Ժ�......");
	getInfoPacket.data.add("retType","query_channelid");
	getInfoPacket.data.add("org_code","<%=org_code%>");
	getInfoPacket.data.add("town_code",document.frm.town_code.value);
	core.ajax.sendPacket(getInfoPacket);
	getInfoPacket=null;
}
//���ù������棬���м����ʻ�ѡ��
function getInfo_Acct()
{
    var pageTitle = "�����ʻ�ѡ��";
    var fieldName = "���Ų�ƷID|���Ų�Ʒ����|��Ʒ����|�����ʺ�|";
	var sqlStr = "";
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "4|0|1|2|3|";
    var retToField = "tmp1|tmp2|tmp3|account_id|"; //����ֻ��Ҫ�����ʺ�
    var cust_id = document.frm.cust_id.value;

    if(document.frm.cust_id.value == "")
    {
        rdShowMessageDialog("����ѡ���ſͻ������ܽ��м����ʻ���ѯ��");
        document.frm.iccid.focus();
        return false;
    }

    if(PubSimpSelAcct(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));
}

function PubSimpSelAcct(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
    var path = "<%=request.getContextPath()%>/npage/s3690/fpubcustacct_sel.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType+"&cust_id=" + document.all.cust_id.value;

    retInfo = window.open(path,"newwindow","height=450, width=650,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");

    document.frm.accountQuery.disabled = false;

	return true;
}

function getvalueacct(retInfo)
{
  var retToField = "tmp1|tmp2|tmp3|account_id|";;
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
}

//���ù������棬���м��ſͻ�ѡ��
function getInfo_Cust()
{
    var pageTitle = "���ſͻ�ѡ��";

    var fieldName = "֤������|�ͻ�ID|�ͻ�����|����ID|��������|������|������֯|";
	var sqlStr = "";
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "7|0|1|2|3|4|5|6|";
    var retToField = "iccid|cust_id|cust_name|unit_id|unit_name|belong_code|group_id|";
    /**add by liwd 20081127,group_id����dcustDoc��group_id end **/
    var cust_id = document.frm.cust_id.value;

    if(document.frm.iccid.value == "" &&
        document.frm.cust_id.value == "" &&
        document.frm.unit_id.value == "")
    {
        rdShowMessageDialog("������֤�����롢�ͻ�ID����ID���в�ѯ��");
        document.frm.iccid.focus();
        return false;
    }

    if(document.frm.cust_id.value != "" && forNonNegInt(frm.cust_id) == false)
    {
    	frm.cust_id.value = "";
        rdShowMessageDialog("���������֣�");
    	return false;
    }

    if(document.frm.unit_id.value != "" && forNonNegInt(frm.unit_id) == false)
    {
    	frm.unit_id.value = "";
        rdShowMessageDialog("���������֣�");
    	return false;
    }

    if(PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));
}

function PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
    var path = "<%=request.getContextPath()%>/npage/s3690/fpubcust_sel.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType+"&iccid=" + document.all.iccid.value;
    path = path + "&cust_id=" + document.all.cust_id.value;
    path = path + "&unit_id=" + document.all.unit_id.value;
    path = path + "&regionCode=" + document.frm.OrgCode.value.substr(0,2);

    retInfo = window.open(path,"newwindow","height=450, width=800,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");

	return true;
}

function getvaluecust(retInfo)
{
    /*add by liwd 20081127,group_id����dcustDoc��group_id
    **var retToField = "iccid|cust_id|cust_name|unit_id|unit_name|belong_code|";;
    **/
    var retToField = "iccid|cust_id|cust_name|unit_id|unit_name|belong_code|group_id|";
    /**add by liwd 20081127,group_id����dcustDoc��group_id end **/
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
	document.all.grp_name.value = document.all.unit_name.value;
	query_custaddress();///////////////add
}

//���ݿͻ�ID��ѯ�ͻ���Ϣ
function getInfo_CustId()
{
    var cust_id = document.frm.cust_id.value;

    //���ݿͻ�ID�õ������Ϣ
    if(document.frm.cust_id.value == "")
    {
        rdShowMessageDialog("������ͻ�ID��");
        return false;
    }
    if(for0_9(frm.cust_id) == false)
    {
    	frm.cust_id.value = "";
        rdShowMessageDialog("�ͻ�ID���������֣�");
    	return false;
    }

    var getInfoPacket = new AJAXPacket("f1902_Infoqry.jsp","���ڻ�ü��ſͻ���Ϣ�����Ժ�......");
    var cust_id = document.frm.cust_id.value;
    getInfoPacket.data.add("region_code","<%=regionCode%>");
    getInfoPacket.data.add("retType","GrpCustInfo");
    getInfoPacket.data.add("cust_id",cust_id);
    core.ajax.sendPacket(getInfoPacket);
    getInfoPacket=null;
}

//���ݿͻ�ID��ѯ�ͻ���Ϣ
function getInfo_UnitId()
{
    var cust_id = document.frm.cust_id.value;
    var unit_id = document.frm.unit_id.value;

    //���ݿͻ�ID�õ������Ϣ
    if(document.frm.cust_id.value == "")
    {
        rdShowMessageDialog("���������뼯�ſͻ�ID��");
        return false;
    }
    if(for0_9(frm.cust_id) == false)
    {
    	frm.cust_id.value = "";
        rdShowMessageDialog("���ſͻ�ID���������֣�");
    	return false;
    }
    if(document.frm.unit_id.value == "")
    {
        rdShowMessageDialog("���������뼯��ID��");
        return false;
    }
    if(for0_9(frm.unit_id) == false)
    {
    	frm.unit_id.value = "";
        rdShowMessageDialog("����ID���������֣�");
    	return false;
    }

    var getInfoPacket = new AJAXPacket("f1902_Infoqry.jsp","���ڻ�ü��ſͻ���Ϣ�����Ժ�......");
    var cust_id = document.frm.cust_id.value;
    getInfoPacket.data.add("region_code","<%=regionCode%>");
    getInfoPacket.data.add("retType","UnitInfo");
    getInfoPacket.data.add("cust_id",cust_id);
    getInfoPacket.data.add("unit_id",unit_id);
    core.ajax.sendPacket(getInfoPacket);
    getInfoPacket=null;
}


//���ù������棬���в�Ʒ����ѡ��
function getInfo_ProdAttr(defFlag)
{
    var pageTitle = "��Ʒ����ѡ��";
    var fieldName = "��Ʒ���Դ���|��Ʒ����|";
		var sqlStr = "";
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "1|0|";
    var retToField = "product_attr|";

    //�����ж��Ƿ��Ѿ�ѡ���˷���Ʒ��
    if(document.frm.sm_code.value == "")
    {
        rdShowMessageDialog("������ѡ������Ϣ����Ʒ��");
        return false;
    }

    if(PubSimpSelProdAttr(pageTitle,fieldName,sqlStr,selType,retQuence,retToField, defFlag));
}

//��ѯ֧Ʊ����
function getBankCode()
{
    if((frm.checkNo.value).trim() == "")
    {
        rdShowMessageDialog("������֧Ʊ���룡");
        frm.checkNo.focus();
        return false;
    }
    var getCheckInfo_Packet = new AJAXPacket("getBankCode.jsp","���ڻ��֧Ʊ�����Ϣ�����Ժ�......");
    getCheckInfo_Packet.data.add("retType","getCheckInfo");
    getCheckInfo_Packet.data.add("checkNo",document.frm.checkNo.value);
    core.ajax.sendPacket(getCheckInfo_Packet);
    getCheckInfo_Packet = null;     
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
 
function PubSimpSelProdAttr(pageTitle,fieldName,sqlStr,selType,retQuence,retToField, defFlag)
{
  var path = "<%=request.getContextPath()%>/npage/s3690/fpubprodattr_sel.jsp";
  path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
  path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
  path = path + "&selType=" + selType;
  path = path + "&groupFlag=Y";
	path = path + "&op_code=" + document.all.op_code.value;
	path = path + "&sm_code=" + document.all.sm_code.value; 
	path = path + "&defFlag=" + defFlag; 

    retInfo = window.open(path,"newwindow","height=450, width=650,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
	return true;
}

function getvalueProdAttr(retInfo)
{
    //alert(retInfo);
    var retToField = "product_attr|";
    if(retInfo ==undefined)      
    {   return false;   }
    
    chPos_retInfo = retInfo.indexOf("|");
    var valueStr = retInfo.substring(0,chPos_retInfo);
    document.frm.product_attr.value= valueStr;
    retInfo = retInfo.substring(chPos_retInfo + 1);
    chPos_retInfo = retInfo.indexOf("|");
    valueStr = retInfo.substring(0,chPos_retInfo);
    document.frm.product_attr_hidden.value=valueStr;
    //document.frm.product_code.value = "";
    document.frm.product_append.value = "";
}

function changeTownCode(){
   document.all.town_name.value="";
}

function getTownCode()
{
    var pageTitle = "�����̲�ѯ";
    var fieldName = "�����̴���|����������|";
		var sqlStr="";
    if(document.all.town_code.value != "")
    {
        sqlStr = "90000158";
    }else{
    		sqlStr = "90000157";
    }
    
    params = ""+document.all.OrgCode.value+"|"+document.all.OrgCode.value+"|"+document.all.town_code.value+"";
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "2|0|1|";
    var retToField = "town_code|town_name|";
    PubSimpSel2(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
}

function PubSimpSel2(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
    var path = "/npage/public/fPubSimpSel.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;  
    path += "&params="+params;
    retInfo = window.showModalDialog(path);
    if(typeof(retInfo)=="undefined")      
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
	//��ѯchannel_id
	query_channelid();

}

//���ù������棬���в�Ʒ��Ϣѡ�� - ������Ʒ
function getInfo_Prod()
{
    var pageTitle = "���Ų�Ʒѡ��";
    var fieldName = "��Ʒ����|��Ʒ����|�Ƿ��������|";
	var sqlStr = "";
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "2|0|1|";
    var retToField = "product_code|product_name|";

    //�����ж��Ƿ��Ѿ�ѡ���˷���Ʒ��
    if(document.frm.sm_code.value == "")
    {
        rdShowMessageDialog("������ѡ������Ϣ����Ʒ��");
        return false;
    }


    if(PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));
}

function PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
    var path = "<%=request.getContextPath()%>/npage/s3690/fpubprod_sel.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;
	path = path + "&op_code=" + document.all.op_code.value;
	path = path + "&sm_code=" + document.all.sm_code.value; 
    path = path + "&product_attr=" + document.all.product_attr.value; 

    retInfo = window.open(path,"newwindow","height=450, width=800,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
	
	return true;
}

function getvalue(retInfo, retInfoDetail)
{
  var retToField = "product_code|product_name|";
  if(retInfo ==undefined)      
    {   return false;   }

  //document.all.product_code.value = retInfo;
  document.frm.product_prices.value = retInfoDetail;
  //alert(document.all.product_code.value);
  //alert(document.frm.product_prices.value);
  var classValue=retInfo.split("|")[0];
  getMidPrompt("10442",codeChg(classValue),"ipTd");
}

/*diling add for ��ѯ���š�����ר�ߡ���Ʒ @2012/12/6 */
function getInfo_AProdInfo(){
  document.all.qryFlag.value="qryCust";
  var pageTitle = "���ſͻ�ѡ��";
  var fieldName = "֤������|�ͻ�ID|�ͻ�����|�û�ID|�û���� |�û�����|��Ʒ����|��Ʒ����|���ű��|�����ʻ�|Ʒ������|Ʒ�ƴ���|";
  var sqlStr = "";
  var selType = "S";    //'S'��ѡ��'M'��ѡ
  var retQuence = "12|0|1|2|3|4|5|6|7|8|9|10|11|";
  //var retToField = "iccid|cust_id|cust_name|grpIdNo|user_no|grp_name|product_code2|product_name2|unit_id|account_id|sm_name|sm_code|";
  var retToField = "AProd_iccidHidden|AProd_cust_idHidden|AProd_cust_nameHidden|AProd_grpIdNoHidden|AProd_user_noHidden|AProd_grp_nameHidden|AProd_product_code2Hidden|AProd_product_name2Hidden|AProd_unit_idHidden|AProd_account_idHidden|AProd_sm_nameHidden|AProd_sm_codeHidden|";
                   
  var cust_id = document.frm.cust_id.value;
  
  var v_A_prodUnitId = $("#A_prodUnitId").val();
  var v_A_prodIccid = $("#A_prodIccid").val();
  if(v_A_prodUnitId==""&&v_A_prodIccid==""){
    rdShowMessageDialog("������A�˲�Ʒ���ű�ţ�����A�˲�Ʒ֤��������в�ѯ��",0);
    $("#v_A_prodUnitId").focus();
    return false;
  }
  
  if(document.frm.unit_id.value != "" && forNonNegInt(frm.unit_id) == false)
  {
  	frm.unit_id.value = "";
      rdShowMessageDialog("���������֣�",0);
  	return false;
  }
  
  PubSimpSelCustForAPro(pageTitle,fieldName,sqlStr,selType,retQuence,retToField); 
}

function PubSimpSelCustForAPro(pageTitle,fieldName,sqlStr,selType,retQuence,retToField){
  var path = "<%=request.getContextPath()%>/npage/s3690/f3690_fpubcust_sel.jsp";
  path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
  path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
  path = path + "&selType=" + selType+"&iccid=" + document.all.A_prodIccid.value;
  path = path + "&cust_id=" + document.all.AProd_cust_idHidden.value;
  path = path + "&unit_id=" + document.all.A_prodUnitId.value;
  path = path + "&user_no=" + document.all.AProd_user_noHidden.value;
  path = path + "&qryFlag=" + document.all.qryFlag.value;
  retInfo = window.open(path,"newwindow","height=450, width=1000,top=50,left=100,scrollbars=yes, resizable=no,location=no, status=yes");

  return true;
}

function getvaluecustForAPro(retInfo){
  //var retToField = "iccid|cust_id|cust_name|grpIdNo|user_no|grp_name|product_code2|product_name2|unit_id|account_id|sm_name|sm_code|";
  var retToField = "AProd_iccidHidden|AProd_cust_idHidden|AProd_cust_nameHidden|AProd_grpIdNoHidden|AProd_user_noHidden|AProd_grp_nameHidden|AProd_product_code2Hidden|AProd_product_name2Hidden|AProd_unit_idHidden|AProd_account_idHidden|AProd_sm_nameHidden|AProd_sm_codeHidden|";
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
  
  $("#trAProdUnitInfosFlag").css("display","");
  //nextStep()
}

//У�� A�˲�Ʒ���� 
function chkInfo_AProdCode(){
	
  var custId = $("#cust_id").val();
  var AProd_grpIdNoHidden = $("#AProd_grpIdNoHidden").val();
  var packet = new AJAXPacket("f3690_ajax_chkInfo_AProdCode.jsp","���ڻ�����ݣ����Ժ�......");
  packet.data.add("opCode","<%=opCode%>");
	packet.data.add("AProd_grpIdNoHidden",AProd_grpIdNoHidden);
	packet.data.add("custId",custId);
	core.ajax.sendPacket(packet,doChkInfo_AProdCode);
	packet = null;
}

function doChkInfo_AProdCode(packet){
  var retCode_chkProdCode = packet.data.findValueByName("retCode_chkProdCode");
  var retMsg_chkProdCode =  packet.data.findValueByName("retMsg_chkProdCode");
  var arr =  packet.data.findValueByName("array");
  var ret_prodCode =  packet.data.findValueByName("ret_prodCode");
  var ret_prodName =  packet.data.findValueByName("ret_prodName");
  if(retCode_chkProdCode == "000000"){
		$("#ret_prodCode").val(ret_prodCode);
		$("#ret_prodName").val(ret_prodName);
		$("#trRetAProdInfoOne").css("display","");
		$("#trRetAProdInfoTwo").css("display","");
		$("#getRetAProdProperTab").css("display","");
		$("#chkAproInfoFlag").val("Y");//У���ʶ ͨ��Y δͨ����δУ��ΪN
		$("#terminal").empty();
		if(arr.length > 0){
		  var insertStr = "";
		  var row = 1;
		   for(var i=0,len=arr.length;i<len;i++) {
		    //var coll = 10637;
		    var coll = 10657;
		    if(arr[i].v3.trim() != null || arr[i].v3.trim() != ""){
		      insertStr += "<tr>"; 
		      for(var j = 0;j < arr.length;j++){
		       if(arr[j].v3 == row && arr[j].v1 == '10622'){
		          insertStr += "<td>"+arr[j].v2+"</td>";
		        }
		      }
		      for(var p = 0;p < 20;p++){
  		      for(var k = 0;k < arr.length;k++){
  		       if(arr[k].v3 == row && arr[k].v1 == coll){
  		        insertStr += "<td>"+arr[k].v2+"</td>";
  		        }
  		      }
  		      if(coll==10663){
              coll = coll + 25;//10688
            }else if(coll==10689){ 
              coll = coll - 25;//10664
            }else if(coll==10670){
              coll = coll + 20; //10690
            }else if(coll==10691){
              coll = coll - 5; //10686
            }else{ 
              coll = coll + 1;
            }
		      }
		      
		      for(var j = 0;j < arr.length;j++){
            if(arr[j].v3 == row && arr[j].v1 == '10984'){
              if(arr[j].v2!="" && arr[j].v2!=null){
                insertStr += "<td v_id='"+arr[j].v1+"'>"+arr[j].v2+"</td>";
              }else{
                insertStr += "<td>"+" "+"</td>";
              }
            }
		      }
		      
		      
		      row = row + 1;
  		    insertStr += "</tr>";
  		  }
		   }
		   $("#terminal").append(insertStr);
		 }else{
		   var insertStr1 = "<tr><td colspan='21'>�޲�ѯ�����</td></tr>";
		   $("#terminal").append(insertStr1);
		 }
	}else{
		rdShowMessageDialog("������룺"+retCode_chkProdCode+"<br>������Ϣ��"+retMsg_chkProdCode,0);
		window.location.href="f3690_1.jsp";
	}
}

function doGetAProdUnitProperty(packet){
  var retCode_getAProdPoperty = packet.data.findValueByName("retCode_getAProdPoperty");
  var retMsg_getAProdPoperty =  packet.data.findValueByName("retMsg_getAProdPoperty");
  //alert(document.frm.F10622.value);
  var arr =  packet.data.findValueByName("array");
  if(retCode_getAProdPoperty == "000000"){
		$("#terminal").empty();
		if(arr.length > 0){
		   var insertStr = "";
		   var row = 1;
		   for(var i=0,len=arr.length;i<len;i++) {
		    //var coll = 10637;
		    var coll = 10657;
		    if(arr[i].v3.trim() != null && arr[i].v3.trim() != ""){
		      insertStr += "<tr>"; 
		      for(var j = 0;j < arr.length;j++){
            if(arr[j].v3 == row && arr[j].v1 == '10622'){
              if(arr[j].v2!="" && arr[j].v2!=null){
                insertStr += "<td v_id='"+arr[j].v1+"'>"+arr[j].v2+"</td>";
              }else{
                insertStr += "<td>"+" "+"</td>";
              }
            }
		      }
		      for(var p = 0;p < 20;p++){
		      	
  		      for(var k = 0;k < arr.length;k++){
  		       if(arr[k].v3 == row && arr[k].v1 == coll){
  		        if(arr[k].v2!="" && arr[k].v2!=null){
                insertStr += "<td v_id='"+arr[k].v1+"'>"+arr[k].v2+"</td>";
              }else{
                insertStr += "<td>"+" "+"</td>";
              }
  		        //insertStr += "<td>"+arr[k].v2+"</td>";
  		       }
  		      }
  		      //coll = coll + 1;
  		      if(coll==10663){
              coll = coll + 25;//10688
            }else if(coll==10689){ 
              coll = coll - 25;//10664
            }else if(coll==10670){
              coll = coll + 20; //10690
            }else if(coll==10691){
              coll = coll - 5; //10686
            }else{ 
              coll = coll + 1;
            }
		      }
		      
		      for(var j = 0;j < arr.length;j++){
            if(arr[j].v3 == row && arr[j].v1 == '10984'){
              if(arr[j].v2!="" && arr[j].v2!=null){
                insertStr += "<td v_id='"+arr[j].v1+"'>"+arr[j].v2+"</td>";
              }else{
                insertStr += "<td>"+" "+"</td>";
              }
            }
		      }
		      
		      row = row + 1;
  		      insertStr += "</tr>";
  		    }else{
                //alert("arr[j].v1="+arr[i].v1+"-------arr[j].v2="+arr[i].v2);
                $("#F"+arr[i].v1).val(arr[i].v2);
                //$("#F"+arr[i].v1).attr("disabled","true");
  		   }
		 }
		   $("#terminal").append(insertStr);
		   //��ȡ��Щ������Ҫ�û�
       chkInfoDisable();
		 }else{
		   var insertStr1 = "<tr><td colspan='21'>�޲�ѯ�����</td></tr>";
		   $("#terminal").append(insertStr1);
		 }
         var terminalTr = $("#terminal tr:has(td)").length;
         for(var ii=0;ii<terminalTr;ii++){
           if(ii + 1 != terminalTr){
             $("input[name^='addSegment']").click();//AZ������ ���������������Ϸ�A������ �������һ��
           }
           $("#terminal tr:has(td):eq("+ii+")").children().each(function(i,n){
            if($(this).text()!="�޲�ѯ�����"){//���Ϸ�A������Ϊ��ֵʱ���Ÿ��·���ֵ
              var v_id = "F"+$(this).attr("v_id");//����ѭ��չʾ��idֵ
              //���ݱ������õ����ͣ����Ϸ�չʾ�� AZ�˼��� ����ֵ���·�����ͳһ
              //Ŀǰֻ�� �����б� �� �ı��� �����˶�Ӧ����
              /** ���������б� **/
              var optionLength = $("#segMentTab1 tr:eq("+(ii+2)+")").find("select").length;//�м��������б�
              if(optionLength>0){//�������б�
                for(var j=0;j<optionLength;j++){
                  var obj = $("#segMentTab1 tr:eq("+(ii+2)+")").find("select:eq("+j+")");//�����б���idֵ��obj.attr("id")
                  if(v_id==obj.attr("id")){
                    obj.val($(this).text()); 
                  }
                }
              }
              /** �����ı��� **/
              var textLength = $("#segMentTab1 tr:eq("+(ii+2)+")").find("input[type='text']").length;
              if(textLength>0){
                for(var z=0;z<textLength;z++){
                  var obj = $("#segMentTab1 tr:eq("+(ii+2)+")").find("input[type='text']:eq("+z+")");//�ı����idֵ��obj.attr("id")
                  if(v_id==obj.attr("id")){
                    obj.val($(this).text()); 
                  }
                }
              }
              
              $("#segMentTab1 tr:eq("+(ii+2)+")").find(":text:eq("+i+")").val($(this).text());
              $("#segMentTab1 tr:eq("+(ii+2)+")").find(":button:eq("+i+")").attr("disabled","true");
              $("#segMentTab1 tr:eq("+(ii+2)+")").find(":text:eq("+i+")").attr("readOnly","true");
              $("#segMentTab1 tr:eq("+(ii+2)+")").find(":text:eq("+i+")").addClass("InputGrey");
              $("#segMentTab1 tr:eq("+(ii+2)+")").find("select").attr("disabled","true");

							$("#segMentTab1 tr:eq("+(ii+2)+")").find(":text:eq(0)").attr("readOnly","true");
              $("#segMentTab1 tr:eq("+(ii+2)+")").find(":text:eq(0)").addClass("InputGrey");
              
              
            }
           });
         }
         
         
         
         
         
         $("input[name^='addSegment']").attr("disabled","true");
	}else{
		rdShowMessageDialog("������룺"+retCode_getAProdPoperty+"<br>������Ϣ��"+retMsg_getAProdPoperty,0);
		window.location.href="f3690_1.jsp";
	}
}


$(document).ready(function (){
	var fwpp2 = "<%=catalog_item_id%>";
	var inOpenFlag = "<%=inOpenFlag%>";
	//alert("119 ��־λ fwpp2=["+fwpp2+"]"+"\n�˵��˱�־λ inOpenFlag=["+inOpenFlag+"]");
	if(fwpp2=="119"&&inOpenFlag!="From4091"){
		$("#segMentTab1 tr:gt(0)").each(function(){
			
				if($(this).find("td:last").find("input").html()!=null){
				
					$(this).find("td:last").find("input").attr("readOnly","readOnly");
					$(this).find("td:last").find("input").addClass("InputGrey");
					
					if($(this).find("td:last").find("input").val().trim()==""){
							rdShowMessageDialog("�뵽3691���ö�Ӧ�ġ�A�˽�����������ڽ���Z�˿�����");	
							removeCurrentTab();
					}
				}
				
		});
	}
	
	
});


function chkInfoDisable(){
  var v_sm_code = $("#sm_code").val();
  var packet = new AJAXPacket("f3690_ajax_chkInfoDisable.jsp","���ڻ�����ݣ����Ժ�......");
	packet.data.add("v_sm_code",v_sm_code);
	core.ajax.sendPacket(packet,doChkInfoDisable);
	packet = null;
}

function doChkInfoDisable(packet){
  var retCode = packet.data.findValueByName("retCode");
  var retMsg =  packet.data.findValueByName("retMsg");
  var nameIdArr =  packet.data.findValueByName("nameIdArr");
  var nameTypeArr =  packet.data.findValueByName("nameTypeArr"); //����
  //alert(nameIdArr.length+"-----"+nameTypeArr.length+"---"+nameIdArr[0]);
  if("000000"==retCode && nameIdArr.length>0){
    for(var i=0;i<nameIdArr.length;i++){
      //alert(nameTypeArr[i]);
      if("01"==nameTypeArr[i]){//01:�ı���
        if(document.all(nameIdArr[i])!=null){
          document.all(nameIdArr[i]).readOnly=true;
          $(document.all(nameIdArr[i])).addClass("InputGrey");
        }
        //ר���������޸�
        $("#F10019").removeAttr("readOnly");
        $("#F10019").removeClass("InputGrey");
      }else if("02"==nameTypeArr[i]){//02:������
        if(document.all(nameIdArr[i])!=null){
          document.all(nameIdArr[i]).disabled=true;
          //disableStr = disableStr + nameIdArr[i] + "|";
          //alert(disableStr);
        }
      }else if("03"==nameTypeArr[i]){//03:��ť
        if(document.all(nameIdArr[i])!=null){
          document.all(nameIdArr[i]).disabled=true;
        }
      }
    }
  }
}

//չʾ�����Ϣ
function getInfo_disPriceMsg_detail(){
  var prodCode = $("#ret_prodCode").val();//��Ʒ����
  var cust_id = $("#cust_id").val();//���ſͻ�ID
  var path = "<%=request.getContextPath()%>/npage/s3690/getInfo_disPriceMsg_detail.jsp?prodCode="+prodCode+"&cust_id="+cust_id;
    window.open(path,'_blank','height=450,width=800,scrollbars=yes');
}

/*diling add @2012/12/6 */

//���ù������棬���в�Ʒ��Ϣѡ�� - ADC/MAS��Ʒ ---��ͨ��ƷҲʹ�ô���ѡ��
function getInfo_Prod2()
{
    //�����ж��Ƿ��Ѿ�ѡ���˷���Ʒ��
 
    var vSmCode = document.frm.sm_code.value;
    if(vSmCode == "")
    {
        rdShowMessageDialog("������ѡ�����Ʒ�ƣ�",0);
        $("#sm_code").focus();
        return false;
    }
    
    var vBizLevel = $("#bizLevel").val();
    var vBizTypeL = $("#bizTypeL").val()==null?'':$("#bizTypeL").val();
    var vBizTypeS = $("#bizTypeS").val()==null?'':$("#bizTypeS").val();
    var vBizCode  = $("#biz_code").val();
    if(vBizLevel == "4"){
        if(vBizCode == ""){
            if(vBizTypeL == "" && vBizTypeS == ""){
                rdShowMessageDialog("����С�ࡢҵ����벻��ͬʱΪ�գ�",0);
                return false;
            }
            if(vBizTypeL == ""){
                rdShowMessageDialog("��ѡ��ҵ����࣡",0);
                $("#bizTypeL").focus();
                return false;
            }
            if(vBizTypeS == ""){
                rdShowMessageDialog("��ѡ��ҵ��С�࣡",0);
                $("#bizTypeS").focus();
                return false;
            }
        }
    }else if(vBizLevel == "3"){
        if(vBizTypeL == ""){
            rdShowMessageDialog("��ѡ��ҵ����࣡",0);
            $("#bizTypeL").focus();
            return false;
        }
        if(vBizTypeS == ""){
            rdShowMessageDialog("��ѡ��ҵ��С�࣡",0);
            $("#bizTypeS").focus();
            return false;
        }
    }else if(vBizLevel == "2"){
        if(vBizTypeL == ""){
            rdShowMessageDialog("��ѡ��ҵ����࣡",0);
            $("#bizTypeL").focus();
            return false;
        }
    }
    
    var pageTitle = "���Ų�Ʒѡ��";
    var fieldName = "";
    var retQuence = "";
    var retToField = "";
    
    if(vSmCode == "ML" || vSmCode == "AD"){
        fieldName = "��Ʒ����|��Ʒ����|�Ƿ��������|ҵ�����|ҵ������|";
        retQuence = "6|3|4|13|15|16|17|";
        retToField = "F00017|product_name|chg_price|bizCode|F00018|catalog_item_id|";
    }else{
        fieldName = "��Ʒ����|��Ʒ����|�Ƿ��������|";
        retQuence = "4|3|4|13|17|";
        retToField = "F00017|product_name|chg_price|catalog_item_id|";
    }
	var sqlStr = "";
    var selType = "S";    //'S'��ѡ��'M'��ѡ

    if(PubSimpSelProd(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));
   
    /* add by liubo */
    /* modify by qidp
    var temp1=document.all.ProdType.value ;    //[S][]  //��Ʒ����
    var temp2=document.all.sm_code.value ;    //[T][]  //Ʒ��  
    var temp3=""; 
    if(document.all.prod_direct!=undefined){  
         temp3=document.all.prod_direct.value ;    //[V][]  //ҵ������
    }
     
    var temp4=document.all.biz_code.value ;    //[W][]  //ҵ�����
    var targeturl="newTree.jsp?ProdType="+temp1+"&sm_code="+temp2+"&prod_direct="+temp3+"&biz_code="+temp4;
    window.open(targeturl,'_blank','height=500,width=600,scrollbars=yes'); 
    	*/
    	
    	
    	
    //if(getBillingType(document.all.bizCode.value));
    //F00017|product_name|bizCode|F00018|
    /*
    var temp1=document.all.ProdType.value ;    //[S][]  //��Ʒ����
    var temp2=document.all.sm_code.value ;    //[T][]  //Ʒ��  
    var temp3=""; 
    if(document.all.prod_direct!=undefined){  
         temp3=document.all.prod_direct.value ;    //[V][]  //ҵ������
    }
    */
    /* add by qidp for [AD,MLʱ,��ҵ������У��] */
    /*
    if(temp2 == "AD" || temp2 == "ML"){
        if($("#biz_code").val() == "" && temp3 == ""){
            rdShowMessageDialog("����ѡ��ҵ�����ͣ�",0);
            $("#prod_direct").focus();
            return false;
        }
    }
    */
    /* end of add */
    /*
    var temp4=document.all.biz_code.value ;    //[W][]  //ҵ�����
    var targeturl="bizModeTree.jsp?ProdType="+temp1+"&sm_code="+temp2+"&prod_direct="+temp3+"&biz_code="+temp4;
    win=window.open(targeturl,'_blank','height=500,width=300,scrollbars=no');
    */
}

function PubSimpSelProd(pageTitle,fieldName,sqlStr,selType,retQuence,retToField){
  var catalog_item_id = $("#catalog_item_id").val();
    var product_code = document.all.F00017.value;
	var chPos = product_code.indexOf("|");
	product_code = product_code.substring(0,chPos);
	var path = "<%=request.getContextPath()%>/npage/s3690/fpubprod_sel2.jsp";
	path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
	path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
	path = path + "&selType=" + selType;
	path = path + "&showType=" + "Default";
	path = path + "&op_code=" + document.all.op_code.value;
	path = path + "&sm_code=" + document.all.sm_code.value; 
	path = path + "&product_code=" + product_code; 
	path = path + "&grp_id=" + document.all.grp_id.value;
	path = path + "&bizTypeL=" + ($("#bizTypeL").val()==null?'':$("#bizTypeL").val());
	path = path + "&bizTypeS=" + ($("#bizTypeS").val()==null?'':$("#bizTypeS").val());
	path = path + "&biz_code=" + $("#biz_code").val();
	path = path + "&catalog_item_id=" + $("#catalog_item_id").val();/*diling add ����ҵ��������*/
	path = path + "&openLabel=<%=openLabel%>" ;/*diling add ���Ӳ��� link  ���߶˵�������ͨ��������ƽ���˶���ģ�飻*/
	path = path + "&cust_id=" + $("#cust_id").val();

    retInfo = window.open(path,"newwindow","height=450, width=800,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
	return true;
}

function getValueProd2(retInfo, retInfoDetail){

    var tmpProductShow = "";
    var retToField = "";
    var vSmCode = document.frm.sm_code.value;
    if(vSmCode == "ML" || vSmCode == "AD"){
        retToField = "F00017|product_name|chg_price|bizCode|F00018|catalog_item_id|";
    }else{
        retToField = "F00017|product_name|chg_price|catalog_item_id|";
    }
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
    
    $("#product_prices").val(retInfoDetail);
    
    $("#F00017").val($("#F00017").val() + "|" + $("#product_name").val());
    
    if(vSmCode == "ML"){
        $("#biz_code").val($("#bizCode").val());
        getBillingType(document.all.bizCode.value);
    }else if(vSmCode == "AD"){
    	$("#biz_code").val($("#bizCode").val());	
    }
}
/*����ADC��ҵ��ļƷ�����*/
$(document).ready(function(){
	
	
	/*2016/6/24 10:52:09 gaopeng 
		 ����5����Ѯ���ſͻ���CRM��BOSS�;���ϵͳ����ĺ�-1-������ר�߿���ʱ������ϵ��кͽ�����������Ϣ������
		 3690 ���� 10984 A�˽������ �����޸�
		*/
		
		if (typeof ($("#F10984").val())!="undefined" )
		{
			$("input[name='F10984']").each(function(){
				
				var vF810311 = $.trim($(this).val());
				
					$(this).attr("readonly",false);
		    	$(this).attr("disabled","");
		    	$(this).attr("class","");
		    	
			});
			
		}
		
    
    
	var vSmCode = $('#sm_code').val(); 
	if(vSmCode == "JJ"){
		if(typeof($(this).find('#F10957').val()) != "undefined" ){
			//�����ж��������������Դ���Ϊ10957ʱ����Ҫ���������ƺ������Ӻ�ɫ��������
			$(this).find('#F10957').parent().prev().html("���Ѻ����ʱ����<font class='orange'>(9:00-11:00)</font>");
			
			/*��ȡȨ��a325*/
			if("<%=have_a325%>" == "true"){
				$(this).find('#F10957').empty();
				$(this).find('#F10957').append("<option selected value='1' selected >1--��</option><option  value='2'>2--��</option>");
			}else{
				$(this).find('#F10957').empty();
				$(this).find('#F10957').append("<option selected value='1'>1--��</option>");
			}
		}
	}
	
	if(vSmCode == "LL"){
		if(typeof($(this).find('#F10954').val()) != "undefined" ){
			/*��ȡȨ��a324*/
			if("<%=have_a324%>" == "true"){
				$(this).find('#F10954').empty();
				$(this).find('#F10954').append("<option selected value='1'>1--��</option><option  value='2'>2--��</option>");
			}else{
				$(this).find('#F10954').empty();
				$(this).find('#F10954').append("<option selected value='1'>1--��</option>");
			}
		}
	}
	
	if(vSmCode == "JJ"){
		if(typeof($(this).find('#F10833').val()) != "undefined" ){
			/*��ȡȨ��a323*/
			if("<%=haveA323%>" == "true"){
				$(this).find('#F10833').empty();
				$(this).find('#F10833').append("<option value='0' selected>0--��</option><option value='1'>1--��</option>");
			}else{
				$(this).find('#F10833').empty();
				$(this).find('#F10833').append("<option value='0' selected>0--��</option>");
			}
		}
	}
	if(vSmCode == "AD"){
		$("input[name$='BizServcode']").val('<%=amsBaseServCode%>');
		if($('#F00016').val()==''){
			$('#F00016').val('<%=amsBaseServCode%>');
		}
		if($('#F00006').val()==''){
			$('#F00006').val('<%=amsBaseServCode%>');
		}
		$("#F00016").bind("propertychange", function() { 
			if($('#F00016').val().indexOf($("input[name$='BizServcode']").val())!=0){
				$('#F00016').val($("input[name$='BizServcode']").val());
				return;
			}
			
			if($('#F00006').val().indexOf($("#F00016").val())!=0){
				//alert($(this).val());
				$('#F00006').val($(this).val());
			}
			$('#span_F00016').text($(this).val());
		}); 
		$("#F00006").bind("propertychange", function() { 
			
			if($('#F00006').val().indexOf($("#F00016").val())!=0){
				
				$('#F00006').val($("#F00016").val());
				return;
			}
		});

		
		//�Ʒ�����(F00022) Ϊ���ˣ�02����ʱ�� ���ָ��˸��ѻ��Ǽ��Ÿ���		
		$('#F00022').change(function(){
			if($(this).val()=="00" || $(this).val()=="01" )
			{
				document.all.tr_gongnengfee.style.display = "none";
				
			}
			else
			{
				document.all.tr_gongnengfee.style.display = "block";
			}
	    
	  	});
	  	if($('#F00022').val()=="00" || $('#F00022').val()=="01" )
		{
			document.all.tr_gongnengfee.style.display = "none";
			
		}
		else
		{
			document.all.tr_gongnengfee.style.display = "block";
		}
	  	
	  	
	}
	if("AD" == vSmCode){
	    document.all.smsInfoTR.style.display="";
	    if("<%=smsFlag%>" == "Y"){
	    	
	        $("#smsInfo").after("<font color=red>����Ϣ�������Ϊ��EC���������<span id='span_F00016'>"+$("#F00016").val()+"</span> +XXXX  ���ѣ����ŷ�����볤�ȱ���Ϊ<%=smsMinLen%>-<%=smsMaxLen%>λ!��˶Ժ���ȷ�ϡ�</font>");
	        $("#smsInfo").after("<font color=red>EC���������Ϊ��SI���������"+$("input[name$='BizServcode']").val()+" +XXXX </font><br/>");
	    }else if("<%=smsFlag%>" == "N"){
	        $("#smsInfo").after("<font color=red>����Ϣ�������Ϊ��EC���������"+$("#F00006").val()+" +XXXX  ���ѣ����ŷ�����볤�������ơ�</font>");
	        $("#smsInfo").after("<font color=red>EC���������Ϊ��SI���������"+$("input[name$='BizServcode']").val()+" +XXXX </font><br/>");
	    }
	    if($("#F00004") != null){
	        $("#F00004").after("<font color='red'>[0:������]</font>");
	    }
	    if($("#F00005") != null){
	        $("#F00005").after("<font color='red'>[0:������]</font>");
	    }
	}else if("ML" == vSmCode){
		
	}else{
	    document.all.smsInfoTR.style.display="none";
	}
	
	//�Ʒ�����  00��ѣ������ۡ�����д0
  	if($('#F00022').val()=='00')
  	{
  		$('#F00051').val("0");
  		$('#F00051').attr("readOnly",true);
  		$('#F00051').attr("class",'InputGrey');
  	}
  	else
  	{
  		$('#F00051').removeAttr("readOnly");
  		$('#F00051').removeAttr("class");
  	}	
  	$("#F00022").bind("propertychange", function() { 
		
		if($('#F00022').val()=='00')
	  	{
	  		$('#F00051').val("0");
	  		$('#F00051').attr("readOnly",true);
	  		$('#F00051').attr("class",'InputGrey');
	  	}
	  	else
	  	{
	  		$('#F00051').removeAttr("readOnly");
  			$('#F00051').removeAttr("class");
	  	}
	});
	
	
	
	if(vSmCode == "AD"||vSmCode == "ML")
	{
		//���ŵ�ҵ�����ſ���չ ���ŵ�ҵ�����Ų�����չ
		var bizCode = $("#biz_code").val();
		var one="";
		var num_flag="0123456789";	
		var i;
		for(i = 0;i<bizCode.length;i++)
		{ 
			one=bizCode.charAt(i);
			if(num_flag.indexOf(one)<0){
				break;	
			}	
		}
		
		if(i==bizCode.length)//MMSҵ���ҵ�����Ϊȫ����
		{
			$("#F00006").attr("readOnly",true);
            $("#F00006").addClass("InputGrey");
		}
		else //SMSҵ���ҵ�����Ϊ�ַ�
		{
			$('#F00006').removeAttr("readOnly");
  			$('#F00006').removeAttr("class");
		}
		
	}
	
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
		$('#F10983').parent().parent().hide();
	}
	
	
	
		/*���ڼ���ҵ�������ϵͳʵ������ĺ�-4-����ESOP�����߲�Ʒ��ͬ�������ܵ�����
	 * hejwa 2016-6-8 15:47:44
	 * F10807
	 */
	 if(typeof($(this).find('#F10807').val()) != "undefined" ){
	 	$("#F10807").parent().append("&nbsp;<input type='button' class='b_text' value='У��' onclick='ajax_check_F10807()' />"); 
	 }
	
	
});



function ajax_check_F10807(){
	  var packet = new AJAXPacket("ajax_check_F10807.jsp","���Ժ�...");
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
    		rdShowMessageDialog("����ͬ��š�δ�ɹ��鵵�����������˶Ժ�����¼��");
    		$("#F10807").val("");
    	}
    }else{//���÷���ʧ��
	    rdShowMessageDialog(error_code+":"+error_msg);
    }
}
/*
function PubSimpSel2(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
    var path = "<%=request.getContextPath()%>/npage/s3690/fpubprod_sel_2890.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;
		path = path + "&op_code=" + document.all.op_code.value;
		path = path + "&sm_code=" + document.all.sm_code.value; 
		path = path + "&direct_id=" + document.all.prod_direct.value; 

    retInfo = window.open(path,"newwindow","height=450, width=800,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
	  
	return true;
}

function getvalue2(retInfo, retInfoDetail)
{
	//alert(retInfoDetail);
	var tmpProductShow = "";
	var retToField = "F00017|product_name|bizCode|F00018|";
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
    ---------------var  tmpValue = document.all.F00017.value + "|" + document.all.product_name.value+"|"
    ---------------document.all.F00017.value = tmpValue;
    ---------------document.frm.product_prices.value = retInfoDetail;
    ---------------if(getBillingType(document.all.bizCode.value));
}

*/

function getBillingType(product_code)
{
	if(((product_code).trim()) == "")
    {
       	rdShowMessageDialog("ѡ���Ų�Ʒʧ��24!",0);
        return false;
    }
    
    var getBillingType_Packet = new AJAXPacket("fgetBillingType.jsp","���ڻ�ȡbillingtype�����Ժ�......");
	getBillingType_Packet.data.add("retType","getBillingType");
    getBillingType_Packet.data.add("product_code",product_code);
	core.ajax.sendPacket(getBillingType_Packet);
	getBillingType_Packet = null;
}

//���Ÿ��Ӳ�Ʒѡ��
function getInfo_ProdAppend()
{
    var pageTitle = "���Ÿ��Ӳ�Ʒѡ��";
    var fieldName = "��Ʒ����|��Ʒ����|";
	var sqlStr = "";
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "2|0|1|";
    var retToField = "product_append|product_name|";
    var product_code = document.frm.product_code.value;

    //�����ж��Ƿ��Ѿ�ѡ���˷���Ʒ��
    if(document.frm.sm_code.value == "")
    {
        rdShowMessageDialog("������ѡ������Ϣ����Ʒ��");
        return false;
    }

    //�����ж��Ƿ��Ѿ������˼��Ų�Ʒ
    if(document.frm.product_code.value == "")
    {
        rdShowMessageDialog("������ѡ���Ų�Ʒ��");
        return false;
    }

    if(PubSimpSelAppend(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));
}

function PubSimpSelAppend(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
        var vBizCode = "";
        if($("#sm_code").val() == "DL"){
            vBizCode = $("#biz_code").val();
        }else{
            vBizCode = "";
        }
		var product_code = document.all.F00017.value;
		var chPos = product_code.indexOf("|");
		product_code = product_code.substring(0,chPos);
		var path = "<%=request.getContextPath()%>/npage/s3690/fpubprodappend_sel.jsp";
		path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
		path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
		path = path + "&selType=" + selType;
		path = path + "&showType=" + "Default";
		path = path + "&op_code=" + document.all.op_code.value;
		path = path + "&sm_code=" + document.all.sm_code.value; 
		path = path + "&product_code=" + product_code; 
		path = path + "&biz_code=" + vBizCode; 

    retInfo = window.open(path,"newwindow","height=450, width=800,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");

	return true;
}

function getvalueProdAppend(retInfo)
{
    var retToField = "product_append|product_name|";
    if(retInfo ==undefined)      
    {   return false;   }
    
    document.all.product_append.value = retInfo;          
    var classValue=retInfo.split(",")[0];              
    //alert(classValue);                               
    getMidPrompt("10442",codeChg(classValue),"ipTd1");
    
    /* add by qidp @ 2009-12-05 for ��������� */
    /*
    var appendArr = retInfo.split(",");
    var flag = "N";
    for(var i=0;i<appendArr.length;i++){
        if(appendArr[i] == "5000"){
            flag = "Y";
            break;
        }
    }
    
    if(flag == "Y" && $("#sm_code").val() == "DL"){
        $("#f5000Flag1").css("display","");
        $("#f5000Flag2").css("display","");
    }else{
        $("#f5000Flag1").css("display","none");
        $("#f5000Flag2").css("display","none");
    }
    */
    /* end of add */
} 

function checkPwd(obj1,obj2)
{
    //����һ����У��,����У��
    var pwd1 = obj1.value;
    var pwd2 = obj2.value;
    if(pwd1 != pwd2)
    {
        var message = "������������벻һ�£����������룡";
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

//����Ʒ�Ʊ���¼�
function changeSmCode() {
	document.frm.product_attr.value = "";
	//document.frm.product_code.value = "";
	//document.frm.product_append.value = "";
	document.frm.grp_userno.value = "";
	document.frm.getGrpNo.disabled = false;
	
	/*diling add for ���������Ʒ��ʱ������A�˲�Ʒ����,�Լ������Ϣ @2012/11/26*/
	if("<%=nextFlag%>"=="1"){ //��һ�μ���ҳ��
  	$("#trAProdInfosFlag").css("display","none");
  	$("#A_prodUnitId").val("");
  	$("#A_prodIccid").val("");
  	$("#trAProdUnitInfosFlag").css("display","none");
  	//$("#AProd_user_noHidden").val("");
  	//$("#AProd_cust_idHidden").val("");
  	$("#AProd_grpIdNoHidden").val("");
  	$("#trRetAProdInfoOne").css("display","none");
    $("#trRetAProdInfoTwo").css("display","none");
    $("#getRetAProdProperTab").css("display","none");
    $("#AProd_grpIdNoHidden").val("");
    $("#ret_prodCode").val("");
    $("#ret_prodName").val("");
	}
	
	<%if("opcode".equals(openLabel) && !"select".equals(action)){%>
	$("#biz_code").val("");
	$("#F00017").val("");
    <%}%>
  
    <%if("select".equals(action)){%>
        chgGrpName2();
    <%}%>
    /*********************
     * ����Ʒ�Ƹı�ʱ������
     *    ����getBizLevel(),��ѯ�Ƿ�չʾҵ����ࡢҵ��С�ࡢҵ�����
     *    ���أ�
     *      1��ֻչʾ����Ʒ��
     *      2��չʾ����Ʒ����ҵ�����
     *      3��չʾ����Ʒ�ơ�ҵ����ࡢҵ��С��
     *      4��չʾ����Ʒ�ơ�ҵ����ࡢҵ��С�༰ҵ�����
     * ���ҵ�����չʾʱ
     *    ����getBizTypeL(),��ѯҵ�����������չʾ����,����̬����
     * ���ҵ��С��չʾʱ��ҵ�����ı�ʱ
     *    ����getBizTypeS(),��ѯҵ��С��������չʾ����,����̬����
     *********************/
  
    <%if("opcode".equals(openLabel)){%>
        getBizLevel();
    <%}%>
}

/* ��ѯ�Ƿ�չʾҵ����ࡢҵ��С�ࡢҵ����� */
function getBizLevel(){
    var vSmCode = $("#sm_code").val();
    
    var getBizLevel_Packet = new AJAXPacket("fgetBizLevel.jsp","���ڻ�������Ϣ�����Ժ�......");
	getBizLevel_Packet.data.add("retType","getBizLevel");
    getBizLevel_Packet.data.add("sm_code",vSmCode);
    core.ajax.sendPacket(getBizLevel_Packet);
	getBizLevel_Packet = null;
}

/* ��ѯ���� */
function getBizTypeL(){
    var vSmCode = $("#sm_code").val();
    
    var getBizTypeL_Packet = new AJAXPacket("fgetBizTypeL.jsp","���ڻ�������Ϣ�����Ժ�......");
	getBizTypeL_Packet.data.add("retType","getBizTypeL");
    getBizTypeL_Packet.data.add("sm_code",vSmCode);
	core.ajax.sendPacket(getBizTypeL_Packet);
	getBizTypeL_Packet = null;
}

/* ��ѯС�� */
function getBizTypeS(){
    var vBizLevel = $("#bizLevel").val();
    /*begin diling add for ������Ʒ��Ϊ����ר�ߣ���ҵ�����Ϊ����ר��ʱ��ҳ��Ԫ��������A�˲�Ʒ���ű�š�����A�˲�Ʒ֤�����롱�� @2012/11/26*/
    if("<%=nextFlag%>"=="1"){ //��һ�μ���ҳ��
      if("From4091"!="<%=inOpenFlag%>"&&"DL100"!="<%=inOpenFlag%>"){//ֱ�ӿ�����ʱ��
        if($("#sm_code").val()=="hl"&&$("#bizTypeL").val()=="02"){
        $("#trAProdInfosFlag").css("display","");
        $("#trRetAProdInfoOne").css("display","none");
        $("#trRetAProdInfoTwo").css("display","none");
        $("#getRetAProdProperTab").css("display","none");
        $("#AProd_grpIdNoHidden").val("");
        $("#ret_prodCode").val("");
        $("#ret_prodName").val("");
        }else{
          $("#trAProdInfosFlag").css("display","none");
          $("#A_prodUnitId").val("");
          $("#A_prodIccid").val("");
          $("#trAProdUnitInfosFlag").css("display","none");
          //$("#AProd_user_noHidden").val("");
          //$("#AProd_cust_idHidden").val("");
          $("#AProd_grpIdNoHidden").val("");
          $("#trRetAProdInfoOne").css("display","none");
          $("#trRetAProdInfoTwo").css("display","none");
          $("#getRetAProdProperTab").css("display","none");
          $("#AProd_grpIdNoHidden").val("");
          $("#ret_prodCode").val("");
          $("#ret_prodName").val("");
        }
      }
    }
   
    /*end diling add  @2012/11/26*/

    if(vBizLevel > 2){
        var vSmCode = $("#sm_code").val();
        var vBizTypeL = $("#bizTypeL").val();
    
        if(vBizTypeL.trim() == ""){
            $("#bizTypeS").empty();
            $("<option value=''>--- ��ѡ�� ---</option>").appendTo("#bizTypeS");
            return;
        }
        
        var getBizTypeS_Packet = new AJAXPacket("fgetBizTypeS.jsp","���ڻ�������Ϣ�����Ժ�......");
    	getBizTypeS_Packet.data.add("retType","getBizTypeS");
        getBizTypeS_Packet.data.add("sm_code",vSmCode);
        getBizTypeS_Packet.data.add("bizTypeL",vBizTypeL);
    	core.ajax.sendPacket(getBizTypeS_Packet);
    	getBizTypeS_Packet = null;
    }
}

function chgGrpName2()
{
    var z_sm_code;
    var vSmCode = document.frm.sm_code.value;
<%
    if("select".equals(action)){
        try{
            sqlStr = "select sm_name from sSmCode where sm_code = '"+ sm_code +"' and region_code = '"+ regionCode +"'";
            paraIn[0] = sqlStr;    
            paraIn[1]="sm_code="+sm_code+",regionCode="+regionCode;
        %>
            <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode55" retmsg="retMsg55"  outnum="1">
                <wtc:sql><%=sqlStr%></wtc:sql>
            </wtc:pubselect>
            <wtc:array id="retArr55" scope="end" />
        <%
            if(retArr55.length>0 && retCode55.equals("000000")){
                result = retArr55;
            }
            out.print("z_sm_code = '"+result[0][0]+"';");
        }catch(Exception e){
            e.printStackTrace();
            logger.error("Call sunView is Failed!");
        }
    }
%>
    if(vSmCode == "AD" || vSmCode == "ML"){
        document.all.grp_name.value = z_sm_code + "-" + "<%=F00018%>".split("--")[1];
    }else{
        document.all.grp_name.value = z_sm_code;
    }
}

//��ѯҵ������
function getProdDirect()
{ 
    if(((frm.sm_code.value).trim()) == "")
    {
        rdShowMessageDialog("���ȡҵ�����ͣ�",0);
        frm.sm_code.focus();
        return false;
    }
    var getProdDirect_Packet = new AJAXPacket("f2890_getProdDirect.jsp","���ڻ�������Ϣ�����Ժ�......");
	getProdDirect_Packet.data.add("retType","getProdDirect");
    getProdDirect_Packet.data.add("sm_code",document.frm.sm_code.value);
	core.ajax.sendPacket(getProdDirect_Packet);
	getProdDirect_Packet = null;
}
 
//��Ʒ���Ա���¼�
function changeProdAttr() {
	//document.frm.product_code.value = "";
    document.frm.product_append.value = "";
}

function changeProdDirect() {
    //document.frm.product_code.value = "";
    chgGrpName();
}

function chgGrpName()
{
	var z_sm_code ;
    if(document.all.sm_code.value=="AD")
    {
    	z_sm_code="ADC";
    }else if(document.all.sm_code.value=="ML")
    {
    	z_sm_code="����MAS";
    }else if(document.all.sm_code.value=="MA")
    {
    	z_sm_code="ȫ��MAS";
    }
   
    for(j = 0 ; j < document.all.prod_direct.length ; j ++){
		if(document.all.prod_direct.options[j].selected){
		 z_sm_code= z_sm_code+"-"+document.frm.prod_direct.options[j].pvalue;
		}
	}
	document.all.grp_name.value = z_sm_code;
}
	
//��Ʒ����¼�
function changeProduct() {
    document.frm.product_append.value = "";
}

function changeOpenType()
{
	if (document.frm.grp_userno.value != "")
	{
		document.frm.grp_userno.value =  document.frm.openType.value
		                               + document.frm.grp_userno.value(2, document.frm.grp_userno.value.length);
	}
}
function dateCompare(sDate1,sDate2){
	
	if(sDate1>sDate2)	//sDate1 ���� sDate2
		return 1;
	if(sDate1==sDate2)	//sDate1��sDate2 Ϊͬһ��
		return 0;
	return -1;		//sDate1 ���� sDate2
}

//
function isDecimal(obj) {
    if (obj.search(/^\d+$/) != -1)
    {
        return true;
    }else{
        return false;
    }
}

function call_flags(){
    var h=580;
    var w=1150;
    var t=screen.availHeight/2-h/2;
    var l=screen.availWidth/2-w/2;
    var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
	   
	var str=window.showModalDialog('group_flags.jsp?flags='+document.frm.F10315.value+'&sm_code=<%=sm_code%>',"",prop);
	   
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

function checkInvalidTime()
{
	var chekTimeFlag = true;
	var invalidTimeList  = new Array();
	$('#segMentTab7').find("TR").each(function(i){
		if(typeof($(this).find('#F00034').val()) != "undefined" ){
			var invalidTime = new Object();
			invalidTime.begin = Number($(this).find('#F00034').val());
			invalidTime.end = Number($(this).find('#F00035').val());
			invalidTime.index = i;
			if($(this).find('#F00034').val() != ""){
				if(!validTime($(this).find('#F00034').val())){
					rdShowMessageDialog("�������·���ʼʱ���ʽ������ȷ��ʽΪ��ʱʱ�ַ����롱�����������룡");
					//return false;
					chekTimeFlag = false;
				}
			}
			if($(this).find('#F00035').val() != ""){
				if(!validTime($(this).find('#F00035').val())){
					rdShowMessageDialog("�������·�����ʱ���ʽ������ȷ��ʽΪ��ʱʱ�ַ����롱�����������룡");
					//return false;
					chekTimeFlag = false;
				}
			}
			invalidTimeList.push(invalidTime);
			if(($(this).find('#F00034').val() != "" )&& ($(this).find('#F00035').val() != "")){
				if($(this).find('#F00034').val()>=$(this).find('#F00035').val()){
					rdShowMessageDialog("�������·���ʼʱ�� ӦС�� �������·�����ʱ��,����!");
					//return false;
					chekTimeFlag = false;
				}
			}
		}
	});
	$(invalidTimeList).each(function(){
		var invalidTime = $(this);
		$(invalidTimeList).each(function(){
			if(invalidTime.index = this.index)
			{
				
			}else if((invalidTime.begin>=this.begin&&invalidTime.begin<=this.end)||
				(invalidTime.end>=this.begin&&invalidTime.end<=this.end)
			)
			{
				rdShowMessageDialog("�����·�ʱ���֮�䲻���н���Ͱ���,����!");
				//return false;
				chekTimeFlag = false;
			}
		});
	});
	return chekTimeFlag ;
}

function validTime(inval){
  inval=inval+"";
  var theTime="";
  var one="";
  var flag="0123456789";
  for(i=0;i<inval.length;i++){ 
     one=inval.charAt(i);
     if(flag.indexOf(one)!=-1)
		 theTime+=one;
  }
  if(theTime.length!=6){
		//obj.value="";
		return false;
  }else{
     var hour=theTime.substring(0,2);
		 var minute=theTime.substring(2,4);
		 var second=theTime.substring(4,6);
	 if(myParseInt(hour)<0 || myParseInt(hour)>24){
	   //obj.value="";
	   return false;
	 }
   if(myParseInt(minute)<0 || myParseInt(minute)>60){
	   return false;
	 }
   if(myParseInt(second)<0 || myParseInt(second)>60){
	   return false;
	 }
  }
  return true;
}

var openFlag = 0;  //yuanqs add 2010/10/12 12:53:31
function refMain(){


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
	
		if($("#F10964").html()!=null&&$("#F10965").html()!=null){
				if($("#F10964").val()=="3"||$("#F10964").val()=="4"){
						if($("#F10965").val()==""){
							rdShowMessageDialog("��������ز�Ʒ�˺�");
							return;
						}
				}
		}
		/*���������������ſͻ���Ϣ����Ŀ(��Ʒ)Ͷ�ʺ������Զ���ƥ�䱨���ĺ�
		* liangyl 2016-07-11
		* F10985
		*/
		
		if($("#F10985").html()!=null&&$("#F10985").html()!=null){
			ajax_check_F10985();
			if($("#F10985").val()!=""&&F10985_flag==0){
				
				return;
			}
		}
		
if(document.frm.sm_code.value=='CK'){
	if(!checkElement(document.all.F10967)){
				return false;
	}
	
	if(!checkElement(document.all.F10968)){
				return false;
	}
	
	if(!checkElement(document.all.F10969)){
				return false;
	}
	
	if(!checkElement(document.all.F10970)){
				return false;
	}
}	
	
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
		




	var chekInvFlag = true;
	chekInvFlag = checkInvalidTime();
	if(!chekInvFlag){
		return false;
	}
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
  	
  	//$("#F10623").val($("#F10675").val()*300+$("#F10676").val()*1000+$("#F10677").val()*$("#F10678").val());
	

	$("#F10675").val()*300+$("#F10676").val()*1000+$("#F10677").val()*$("#F10678").val()
	var vF10675=0;
	if ( typeof ($("#F10675").val())!="undefined" )
	{
		vF10675=$("#F10675").val();
	}
	if ( typeof ($("#F81026").val())!="undefined" )
	{
		document.frm.F81026.v_type = "smobilePhone";
		if(!checkElement(document.frm.F81026)){
			return false;
		}
	}
	var vF10676=0;
	if ( typeof ($("#F10676").val())!="undefined" )
	{
		vF10676=$("#F10676").val();
	}
	
	var vF10677=0;
	if ( typeof ($("#F10677").val())!="undefined" )
	{
		vF10677=$("#F10677").val();
	}	
	
	var vF10678=0;
	if ( typeof ($("#F10678").val())!="undefined" )
	{
		vF10678=$("#F10678").val();
	}		
	
	$("#F10623").val(vF10675*300+vF10676*1000+vF10677*vF10678);	
	
	var v10680=$("#F10680").val();
	if ( document.getElementById("F10680")!=null  )
	{
		var reg = new RegExp("^[0-9]+(.[0-9]{1,2})?$");
		if(!reg.test(v10680))
		{
			rdShowMessageDialog("�����������ΪС�������λ",0);
			return false;
		}
	}  

	if ( document.all.cptId.value.trim()=="" )
	{
		rdShowMessageDialog("��ƷЭ���Ų���Ϊ��!");
		return false;			
	}
	/*2013/11/29 14:31:56 gaopeng �ƶ��������� 81024����Ա�˻�����ĸ��������� start*/
	if (typeof ($("#F81024").val())!="undefined" )
	{
		var vF81024 = $.trim($("#F81024").val());
		var m = /^([0-9A-Za-z]*)$/;
		var flag = m.test(vF81024);
		if(!flag){
			rdShowMessageDialog("����Ա�˻����������֡���ĸ��ɣ�");
			return false;
		}
	}
	if (typeof ($("#F81025").val())!="undefined" )
	{
		var vF81024 = $.trim($("#F81025").val());
		var m = /^([0-9A-Za-z]*)$/;
		var flag = m.test(vF81024);
		if(!flag){
			rdShowMessageDialog("����Ա������������֡���ĸ��ɣ�");
			return false;
		}
		if(vF81024.length != 8){
			rdShowMessageDialog("����Ա���������8λ��");
			return false;
		}
	}
	/*2013/11/29 14:31:56 gaopeng �ƶ��������� 81024����Ա�˻�����ĸ��������� end*/
	
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
	
	if (typeof ($("#F81028").val())!="undefined" )
	{
		var vF81028 = $.trim($("#F81028").val());
		var re=/^[0-9]*$/;  
		var flag = re.test(vF81028);
		if(!flag){
			rdShowMessageDialog("�û���֯����ID������������ɣ�");
			return false;
		}
		if(vF81028.length != 20){
			rdShowMessageDialog("�û���֯����ID������20λ��");
			return false;
		}
	}
	if (typeof ($("#F81039").val())!="undefined" )
	{
		var vF81039 = $.trim($("#F81039").val());
		var re=/^[0-9]*$/;  
		var flag = re.test(vF81039);
		if(!flag){
			rdShowMessageDialog("��ҵ���������������ɣ�");
			return false;
		}
		if(vF81039.length != 20){
			rdShowMessageDialog("��ҵ���������20λ��");
			return false;
		}
	}
	if (typeof ($("#F81033").val())!="undefined" )
	{
		var vF81033 = $.trim($("#F81033").val());
		if(vF81033.length != 6){
			rdShowMessageDialog("��½���������6λ��");
			return false;
		}
	}
	if (typeof ($("#F81042").val())!="undefined" )
	{
		var vF81042 = $.trim($("#F81042").val());
		if(vF81042.length != 6){
			rdShowMessageDialog("����Ա���������6λ��");
			return false;
		}
	}
	
	if (typeof ($("#F00022").val())!="undefined" && typeof ($("#F00051").val())!="undefined"){
		if($('#F00022').val()!='00'){
			if(parseFloat($('#F00051').val().trim()) <= 0){
				rdShowMessageDialog("����Ʒ����Ͳ�Ϊ���ʱ���򵥼���Ҫ����0!",0);
				return false;
			}
		}
	}

	if ( parseInt(document.all.cptId.value,10)<1000000000  )
	{
		rdShowMessageDialog("��ƷЭ���ű�����10λ!",0);
		return false;
	}	
	
	if ( document.all.cnttId.value.trim()!=="" )
	{
			if ( parseInt(document.all.cnttId.value,10)<1000000000  )
			{
				rdShowMessageDialog("��Ŀ��ͬ��ű�����10λ!",0);
				return false;
			}	

	}	
	
	/*liujian 2013-1-30 11:11:19*/
	if('<%=sm_code%>' == 'hj' && $('#catalog_item_id').val() == '214'){	
		if(!$('#provSelect').val())	{
			rdShowMessageDialog("��ѡ����ҵ���ڵع̻����ţ�",0);
			return false;
		}
		if(!$('#citySelect').val())	{
			rdShowMessageDialog("��ѡ����ҵ���ڵع̻����ţ�",0);
			return false;
		}
	}
	openFlag = 1; //yuanqs add 2010/10/12 12:53:52
	getAfterPrompt();
    //У�鶯̬���ɵ��ֶ�
	if(!checkDynaFieldValues(false))
        return false;
    var checkFlag; //ע��javascript��JSP�ж���ı���Ҳ������ͬ,���������ҳ����.

    //˵��:���ֳ�����,һ���������Ƿ��ǿ�,��һ���������Ƿ�Ϸ�.
    if(check(frm))
    {
    	
    	
        /*begin diling add for У�� SSID��ʶ��Portal��½�˺� ��ʽ@2012/7/10*/
        // SSID��ʶ 
        var re=/^([0-9a-zA-Z\-]*)$/; 
        //var re=/\a-\z\A-\Z0-9\u4E00-\u9FA5\@\/; 
        var re2=/^[0-9a-z]*$/;  
        if( document.frm.F10625 !=null && document.frm.F10625.value == "" ){
          rdShowMessageDialog("SSID��ʶ��������!!");
          document.frm.F10625.select();
          return false;
        }
        if(document.frm.F10625 != null && document.frm.F10625.value != ""){
          if(re.test(document.frm.F10625.value)==false){
            rdShowMessageDialog("SSID��ʶ����Ϊ��ĸ,���ֻ���- !");
            document.frm.F10625.select();
            return false;
          }
        }

        var sm_code = document.frm.sm_code.value;
        
        //if(sm_code == "AD" || sm_code == "ML" || sm_code == "MA"){
            if(  document.frm.F00017 != null && document.frm.F00017.value == "") {
                rdShowMessageDialog("���Ų�Ʒ����Ϊ��!",0);
                return false;
            }
        //}else{
        //    if(  document.frm.product_code != null && document.frm.product_code.value == "") {
        //        rdShowMessageDialog("���Ų�Ʒ����Ϊ��!",0);
        //        return false;
        //    }
        //}
        if(  document.frm.F10333 != null && document.frm.F10333.value != "") {
            if (document.frm.chkPass2.disabled == false) {
                rdShowMessageDialog("���Ÿ��Ѻ���:"+document.frm.F10333.value+"��δ��������У��!");
                document.frm.chkPass2.select();
                return false;
            }
        }
        
        if(  document.frm.grp_name.value == "" ){
            rdShowMessageDialog("�û�����:"+document.frm.grp_name.value+",��������!!");
            document.frm.grp_name.select();
            return false;
        }
        if(  document.frm.grp_id.value == "" ){
            rdShowMessageDialog("���Ų�ƷID�����ȡ!!");
            document.frm.grp_id.select();
            return false;
        }
        
        //2.ת��ҵ����ʼ���ں�ҵ��������ڵ�YYYYMMDD---->YYYY-MM-DD
		checkFlag = isValidYYYYMMDD(document.frm.srv_start.value);
        if(checkFlag < 0){
            rdShowMessageDialog("ҵ����ʼ����:"+document.frm.srv_start.value+",���ڲ��Ϸ�!!");
            document.frm.srv_start.select();
            return false;
        }
        checkFlag = isValidYYYYMMDD(document.frm.srv_stop.value);
        if(checkFlag < 0){
            rdShowMessageDialog("ҵ���������:"+document.frm.srv_stop.value+",���ڲ��Ϸ�!!");
            document.frm.srv_stop.select();
            return false;
        }
        
        if(document.frm.srv_start.value < "<%=dateStr%>"){
            rdShowMessageDialog("ҵ����ʼ����Ӧ��С�ڵ�ǰ����!!");
            document.frm.srv_start.select();
            return false;
        }
        
        //ҵ����ʼ���ں�ҵ��������ڵ�ʱ��Ƚ�
        checkFlag = dateCompare(document.frm.srv_start.value,document.frm.srv_stop.value);
        if( checkFlag == 1 ){
            rdShowMessageDialog("ҵ���������Ӧ�ô���ҵ����ʼ����!!");
            document.frm.srv_stop.select();
            return false;
        }
        if(document.all.sm_code.value =="pi")
        {
        	if(document.all.F10333.value =="")
        	{
        		rdShowMessageDialog("�����뼯�Ÿ��Ѻ���!!");
            document.all.F10333.select();
            return false;
        	}
        	if(document.all.F10334.value =="")
        	{
        		rdShowMessageDialog("�����뼯�Ÿ��Ѻ�������!!");
            document.all.F10334.select();
            return false;
        	}
        }
        
		//��������У��
		if(((document.all.user_passwd.value).trim()).length>0)
        {
            if(document.all.user_passwd.value.length!=6)
            {
                rdShowMessageDialog("�û����볤������",0);
                document.all.user_passwd.focus();
                return false;
             }
             if(checkPwd(document.frm.user_passwd,document.frm.account_passwd)==false)
                return false;
        }
        else
        {
            rdShowMessageDialog("�û����벻��Ϊ�գ�");
            document.all.user_passwd.focus();
            return false;
        }
        
        if( document.frm.F10000 !=null && document.frm.F10000.value == "" )
		{
			rdShowMessageDialog("���������ʱ�������!!");
			document.frm.F10000.focus();
			return false;
		}
        //У�����Ա�ʻ�����
        if(document.frm.F10304 !=null && document.all.F10304.value.length<6)
        {
            rdShowMessageDialog("����Ա�˻����볤������",0);
            document.all.F10304.value="";
            document.all.F10304.focus();
            return false;
        }  
      
        if(document.frm.F10304 !=null && !isDecimal(document.all.F10304.value)){
            rdShowMessageDialog("����Ա�˻�����ֻ�������ִ���",0);
            document.all.F10304.value="";
            document.all.F10304.focus();
            return false;
        }
        if( document.frm.F10304 !=null && document.frm.F10304.value == "" ){
            document.frm.F10304.value="111111";
        }
        
        if( document.frm.F10317 !=null && document.frm.F10317.value == "" ){
            rdShowMessageDialog("���ڷ���������������!!");
            document.frm.F10317.select();
            return false;
        }
        if( document.frm.F10319 !=null && document.frm.F10319.value == "" ){
            rdShowMessageDialog("����������������������!!");
            document.frm.F10319.select();
            return false;
        }
        if( document.frm.F10321 !=null && document.frm.F10321.value == "" ){
            rdShowMessageDialog("���Ź����������������!!");
            document.frm.F10321.select();
            return false;
        }
        if( document.frm.F10318 !=null && document.frm.F10318.value == "" ){
            rdShowMessageDialog("�������������������!!");
            document.frm.F10318.select();
            return false;
        }
        if( document.frm.F10320 !=null && document.frm.F10320.value == "" ){
            rdShowMessageDialog("���Żݷ���������������!!");
            document.frm.F10320.select();
            return false;
        }
        if( document.frm.F10322 !=null && document.frm.F10322.value == "" ){
            rdShowMessageDialog("���л���Աת�Ӻű�������!!");
            document.frm.F10322.select();
            return false;
        }
        if( document.frm.F10328 !=null && document.frm.F10328.value == "" ){
            rdShowMessageDialog("��������û�����������!!",0);
            document.frm.F10328.select();
            return false;
        }
    

		//�ж�real_handfee
		if(!checkElement(document.frm.real_handfee)) return false;
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
		}
        //���ڲ���̫�࣬��Ҫͨ��form��post����,���,��Ҫ����������ݸ��Ƶ���������. yl.
        document.frm.chgsrv_start.value = changeDateFormat(document.frm.srv_start.value);
        document.frm.chgsrv_stop.value  = changeDateFormat(document.frm.srv_stop.value);
        
        if( document.frm.F10326 !=null && parseInt(document.frm.F10326.value) > 5){
            rdShowMessageDialog("�����û����ɼ���ıպ�Ⱥ��:"+document.frm.F10326.value+",��Χ[0,5]!!",0);
            document.frm.F10326.select();
            return false;
        }
        if(document.frm.F10328 != null){
            checkFlag = parseInt(document.frm.F10328.value);
            if(checkFlag < 20 || checkFlag > 1000){
                rdShowMessageDialog("���ſ�ӵ�е�����û���:"+document.frm.F10328.value+",��Χ[20,1000]!!",0);
                document.frm.F10328.select();
                return false;
            }
        }
        if(document.frm.F10330 != null && document.frm.F10330.value != ""){
            checkFlag = isValidYYYYMMDD(document.frm.F10330.value);
            if(checkFlag < 0 ){
                rdShowMessageDialog("�ʷ��ײ���Ч����:"+document.frm.F10330.value+",���ڲ��Ϸ�!!",0);
                document.frm.F10330.select();
                return false;
            }
        }
        //�������ڵ�ǰ����
        if(document.frm.F10330 != null && document.frm.F10330.value != "" && document.frm.srv_start != null){
            checkFlag = dateCompare(document.frm.srv_start.value,document.frm.F10330.value);
            if( (checkFlag == 1) || (checkFlag == 0) ){
                rdShowMessageDialog("�������ڵ�ǰ����!!",0);
                document.frm.F10330.select();
                return false;
            }
        }
        
        //Portal��½�˺�
        if( document.frm.F10626 !=null && document.frm.F10626.value == "" ){
          rdShowMessageDialog("��½�˺ű�������!!");
          document.frm.F10626.select();
          return false;
        }
        if(document.frm.F10626 != null && document.frm.F10626.value != ""){
          if(re.test(document.frm.F10626.value)==false){
            rdShowMessageDialog("��½�˺ű���Ϊ��ĸ+����!!");
            document.frm.F10626.select();
            return false;
          }
        }
        //��ҵ���
        if( document.frm.F10629 !=null && document.frm.F10629.value == "" ){
          rdShowMessageDialog("��ҵ��Ʊ�������!!");
          document.frm.F10629.select();
          return false;
        }
        if(document.frm.F10629 != null && document.frm.F10629.value != ""){
          if(re2.test(document.frm.F10629.value) == false){
            rdShowMessageDialog("��ҵ��Ʊ���ΪСд��ĸ�������֣�����Сд��ĸ+����!!");
            document.frm.F10629.select();
            return false;
          }
          if(((document.frm.F10629.value).trim()).length>0){
            if(document.frm.F10629.value.length<2||document.frm.F10629.value.length>6){
              rdShowMessageDialog("��ҵ��Ƴ��ȱ���Ϊ2-6λ��",0);
              document.frm.F10629.select();
              return false;
            }
          }
        }
        /*end diling add for @2012/7/10 */
       
        <%if(userType.equals("pe")) {%>
        document.frm.sysnote.value = "�ֻ����伯�Ų�Ʒ����";
        <%}else{%>
        document.frm.sysnote.value = "���Ų�Ʒ����";

        <%}%>	
		getSysAccept();
    }
}
//��ӡ���
//ȡ��ˮ
function getSysAccept()
{
	var getSysAccept_Packet = new AJAXPacket("pubSysAccept.jsp","�������ɲ�����ˮ�����Ժ�......");
	getSysAccept_Packet.data.add("retType","getSysAccept");
	core.ajax.sendPacket(getSysAccept_Packet,doProcess,true);
	getSysAccept_Packet = null;   
}
//ѡ��֧����ʽ
function changePayType(){
	if (document.all.checkPayTR.style.display==""){
		document.all.checkPayTR.style.display="none";
		document.all.cashPay_div.style.display="";
		
		if(document.frm.sm_code.value=='CK'){
			document.all.cashPay_div_add1.style.display="";
			document.all.cashPay_div_add2.style.display="";
		}
		
		
		if(document.frm.cashPay.value=='' && document.frm.sm_code.value!='va')
		{
		    document.frm.sure.disabled = true;
		}
	}
	else {
		if(document.frm.sm_code.value=='CK'){
			document.all.cashPay_div_add1.style.display="none";
			document.all.cashPay_div_add2.style.display="none";
		}
		document.all.checkPayTR.style.display="";
		document.all.cashPay_div.style.display="none";
		document.frm.sure.disabled = false;
	}
}
 //����ܼƽ��
function getCashNum(){
if (typeof ($("#F10984").val())!="undefined" )
		{
			var retflag = true;
			$("input[name='F10984']").each(function(){
				
				var vF810311 = $.trim($(this).val());
		    	
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
				
			});
			if(!retflag){
				return false;
			}
		}
	
	$("#F10675").val()*300+$("#F10676").val()*1000+$("#F10677").val()*$("#F10678").val()
	var vF10675=0;
	if ( typeof ($("#F10675").val())!="undefined" )
	{
		vF10675=$("#F10675").val();
	}
	
	var vF10676=0;
	if ( typeof ($("#F10676").val())!="undefined" )
	{
		vF10676=$("#F10676").val();
	}
	
	var vF10677=0;
	if ( typeof ($("#F10677").val())!="undefined" )
	{
		vF10677=$("#F10677").val();
	}	
	
	var vF10678=0;
	if ( typeof ($("#F10678").val())!="undefined" )
	{
		vF10678=$("#F10678").val();
	}		
	
	  	$("#F10623").val(vF10675*300+vF10676*1000+vF10677*vF10678);

	if(!checkDynaFieldValues(true)){//������������
		return false;
	}
	var retToField = "<%=numberList%>";
	var chPos_field = retToField.indexOf("|");
	var chPos_retStr;
	var valueStr;
	var obj;
	var temp;
	var addSub=0;
	while(chPos_field > -1)
	{
		obj = "F"+retToField.substring(0,chPos_field);
	   
		if(typeof(document.all(obj).length)=="undefined")
		{
			temp=document.all(obj).value;
			addSub=addSub+Number(temp); 
		}
		else{
			for(var n = 0 ; n < Number(eval(document.all(obj).length)) ; n++)
			{
				temp=eval("document.frm."+obj+"[n].value");
				addSub=addSub+Number(temp);
			}
		}
		
		retToField = retToField.substring(chPos_field + 1);
		chPos_field = retToField.indexOf("|");
	}    
	document.frm.cashNum.value=addSub;
}
function check_cashPay(){
	if(document.frm.cashNum.value==""){
		rdShowMessageDialog("���ѯ������!");
		return false;
	}
	var real_handfee = document.frm.real_handfee.value;
	var cashNum = document.frm.cashNum.value;
	if (parseFloat(document.frm.real_handfee.value)>parseFloat(document.frm.should_handfee.value))
	{
		rdShowMessageDialog("ʵ�������Ѳ�Ӧ����Ӧ��������");
		document.frm.real_handfee.focus();
		return false;	
	}
	document.frm.cashPay.value=Math.round(real_handfee)+Math.round(cashNum);//�ܷ�
	rdShowMessageDialog("�������ɹ�!",2);
	document.frm.real_handfee.readOnly=true;
	document.frm.sure.disabled = false;
			
}
function closefields()//�����һ��ʱ���Ѿ���õ��ֶβ����޸�
{
	document.frm.custQuery.disabled=true;
	//document.frm.chkPass.disabled=true;
	document.frm.sm_code.disabled=true;
	document.frm.ProdQuery2.disabled=true;
	document.frm.biz_code.readOnly=true;
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
	divF10340.innerHTML=f10340txt;
	divF10341.innerHTML=f10341txt;
}


function ctrlF10341(selectId)
{
	var f10341txt = "";
	if(selectId.value == "00")
	{
		f10341txt = "<input id='F10341' name='F10341'  class='button' type='text' datatype=67  v_must=1 value=''>&nbsp;<font class='orange'>*</font>";
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

// ��ѯ���۴�����
function selSales(){
    var pageTitle = "���۴����̲�ѯ";
    var fieldName = "�����̴���|����������|";
    /* ningtn �����Ż����ſͻ�SA������ϵͳ�ĺ�*/
		var sqlStr="90000156";
		params = "<%=pubSAGroupId%>|";		
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "1|0|";
    var retToField = "F1006|";
    PubSimpSelSales(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
}

function PubSimpSelSales(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
    var path = "/npage/public/fPubSimpSel.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;  
    path += "&params="+params;
    retInfo = window.showModalDialog(path);
    if(typeof(retInfo)=="undefined")      
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
}
var params = "";
// ��ѯ�������˿ں�
function selExchgPorts(){
    var pageTitle = "�������豸�˿ںŲ�ѯ";
    var fieldName = "�˿ںŴ���|�豸�˿ں�����|���ſͻ�����|";
		var sqlStr="90000155";
		params = "1|";
    var selType = "M";    //'S'��ѡ��'M'��ѡ
    var retQuence = "4|0|1|2|3|";
    var retToField = "F10775|";
    PubSimpSelExchgPorts(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
}

function PubSimpSelExchgPorts(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
    var path = "fPubSimpSel.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;  
    path += "&params="+params;
    var retInfo = window.showModalDialog(path);
    if(typeof(retInfo)=="undefined")      
    {   return false;   }
    $("#F10775").val(retInfo); //�������˿ں�
}

//yuanqs add 2010/9/2 13:39:59 ���ID:10471.����100���޷�ȡ����
function doResume() {
			var v_btnId = "<%=iBtnId%>";
			opener.document.getElementById(v_btnId).disabled = false; //yuanqs add 2010-9-2 17:14:17
			window.close();
}

//yuanqs add 2010/9/6 9:36:32 ���ID:10471.����100���޷�ȡ����ҳ��ر�ʱ����
function doRefresh() {
		if(openFlag == 0) {//yuanqs add 2010/10/12 13:04:47
			var v_btnId = "<%=iBtnId%>";
			if(isRefresh) {
				opener.document.getElementById(v_btnId).disabled = false; //yuanqs add 2010-9-2 17:14:17
			}
		}
}


/**
 * ����2����Ѯ���ſͻ���CRM��BOSS�;���ϵͳ����ĺ�-2-boss������ר��0Ԫ�ʷ�˵����Ϣ������
 * 2016��4��12��9:42:51
 * hejwa ������
 */
$(document).ready(function(){
		if($("#F10964").html()!=null&&$("#F10965").html()!=null){
			go_check_F10964_F10965();
			$("#F10965").blur(function(){
					if($("#F10964").val()==""){
						rdShowMessageDialog("��ѡ�����ԭ��");
						$("#F10965").val("");
					}
					if($("#F10964").val()=="3"||$("#F10964").val()=="4"){
						go_check_F10965();
					}
			});
		}
		
	
	/*
	 * ���ֺ󸶷Ѽ��Ų�Ʒʵ������¼����ſع��ܵ�ҵ������
	 */		
		$("input[name='F10975']").attr("readOnly","readOnly");
		$("input[name='F10975']").addClass("InputGrey");		
		
		var val_F10817 = "12";
		var val_F10975 = "<%=db_cu_date%>";
		$("select[name='F10817']").val(val_F10817);
		$("input[name='F10975']").val(val_F10975);
});

function go_check_F10964_F10965(){
	  var packet = new AJAXPacket("check_F10964_F10965.jsp","���Ժ�...");
        packet.data.add("sPChanceId","<%=in_ChanceId%>");//
    core.ajax.sendPacket(packet,do_check_F10964_F10965);
    packet =null;	
}
function do_check_F10964_F10965(packet){
    var error_code = packet.data.findValueByName("code");//���ش���
    var error_msg =  packet.data.findValueByName("msg");//������Ϣ

    if(error_code=="000000"){//�����ɹ�
    	var result_count =  packet.data.findValueByName("result_count");
    	if(result_count!="0"){
    		$("#F10964").attr("disabled","disabled");
    		$("#F10965").attr("disabled","disabled");
    	}
    }else{//���÷���ʧ��
	    rdShowMessageDialog(error_code+":"+error_msg);
    }
}

function go_check_F10965(){
	  var packet = new AJAXPacket("check_F10965.jsp","���Ժ�...");
        packet.data.add("prod_id",$("#F10965").val());//
        packet.data.add("unit_id",$("#unit_id").val());//
        packet.data.add("opCode","<%=opCode%>");//
				packet.data.add("c_prod_id","");//        
    core.ajax.sendPacket(packet,do_check_F10965);
    packet =null;		
}
function do_check_F10965(packet){
    var error_code = packet.data.findValueByName("code");//���ش���
    var error_msg =  packet.data.findValueByName("msg");//������Ϣ

    if(error_code=="000000"){//�����ɹ�
    	var result_count =  packet.data.findValueByName("result_count");
    	if(result_count=="0"){
    		rdShowMessageDialog("���ԭ��ѡ��������Ϣ����Ŀ���͡���������ҵ��Ӧ�á�ʱ����Ҫ��дͬһ���ű����µ�������Ʒ�˺�");
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


$(document).ready(function(){
	
	if("ML"=="<%=sm_code%>"){
		if(typeof($("#F12056")) != "undefined"){
			jFunc_set_F12056();
			$("#biz_code").blur(function(){
				 jFunc_set_F12056();
			});
			
		}
	}
});

function jFunc_set_F12056(){
			var biz_code = $("#biz_code").val();
			var sub78_biz_code = "";
			if(biz_code.length>8){
				sub78_biz_code = biz_code.substring(6,8);
			}
			
			
			if("53"==sub78_biz_code){
				$("#F12056").val("0");
				$("#F12056").attr("disabled","disabled");
			}else if("51"==sub78_biz_code||"52"==sub78_biz_code||"54"==sub78_biz_code){
				$("#F12056").val("1");
				$("#F12056").removeAttr("disabled");
			}else{
				$("#F12056").val("1");
				$("#F12056").attr("disabled","disabled");
			}	
}

</script>
<!-- yuanqs add 2010/9/3 15:58:15 ����-->
<BODY onUnload="doRefresh()">
<FORM action="" method="post" name="frm" >
<%@ include file="/npage/include/header.jsp" %>
<div class="title">
	<div id="title_zi">������֤</div>
</div>
<input type="hidden" id=hidPwd name="hidPwd" v_name="ԭʼ����">
<input type="hidden" name="chgsrv_start" value="">
<input type="hidden" name="chgsrv_stop"  value="">
<input type="hidden" name="product_level"  value="1">
<input type="hidden" name="product_name" id="product_name" value="<%=product_name%>">
<input type="hidden" name="belong_code" id="belong_code" value="<%=belong_code%>">
<input type="hidden" name="prod_appendname"  value="">
<input type="hidden" name="tfFlag" value="n">
<input type="hidden" name="chgpkg_day"   value="">
<input type="hidden" name="TCustId"  value="">
<input type="hidden" name="unit_name"  value="">
<input type="hidden" name="tmp1"  value="">
<input type="hidden" name="tmp2"  value="">
<input type="hidden" name="tmp3"  value="">
<input type="hidden" id="hdF10671" name="hdF10671" value="0" />
<input type="hidden" name="org_id"  value="<%=OrgId%>">
<!-- add by liwd 20081127,group_id����dcustdoc��group_id
<input type="hidden" name="group_id"  value="<%=GroupId%>">
-->
<input type="hidden" name="group_id" id="group_id" value="<%=group_id%>">
<!--add by liwd 20081127,group_id����dcustDoc��group_id end -->
<input type="hidden" id="login_accept" name="login_accept"  value="0"> <!-- ������ˮ��-->
<input type='hidden' id='child_accept' name='child_accept' value='<%=iChildAccept%>' /> <!-- ����ˮ�� -->
<input type="hidden" name="opName" value="<%=opName%>">
<input type="hidden" name="bill_type"  value="0"> <!-- �������� -->
<input type="hidden" name="product_prices" id="product_prices" value="<%=product_prices%>">
<input type="hidden" name="product_type"  value="">
<input type="hidden" name="pay_no"  value="">
<input type="hidden" name="op_code"  value="3690">
<input type="hidden" name="OrgCode"  value="<%=org_code%>">
<input type="hidden" name="region_code"  value="<%=regionCode%>">
<input type="hidden" name="district_code"  value="<%=districtCode%>">
<input type="hidden" name="town_code1"  value="<%=townCode%>">
<input type="hidden" name="WorkNo"   value="<%=workno%>">
<input type="hidden" name="NoPass"   value="<%=nopass%>">
<input type="hidden" name="ip_Addr"  value=<%=ip_Addr%>>
<input type="hidden" name="cust_address"  value="<%=custAddress%>">
<input type="hidden" name="channel_id"  value="">
<input type="hidden" name="userType"  value="<%=userType%>">
<input type="hidden" name="bizCode" id="bizCode" value="<%=bizCode%>">
<input type="hidden" name="BizServcode" value="<%=BizServcode%>" >
<input type="hidden" name="bizattrtype" value="<%=bizattrtype%>" >
<input type="hidden" name="billingtype"  value="<%=billingtype%>">
<input type="hidden" name="StartTime" value="">
<input type="hidden" name="EndTime" value="">
<input type="hidden" name="MOCode" value="">
<input type="hidden" name="CodeMathMode" value="">
<input type="hidden" name="MOType" value="">
<input type="hidden" name="DestServCode" value="">
<input type="hidden" name="ServCodeMathMode" value="">
<input type="hidden" name="max_outnumcl"  value="10">
<input type="hidden" name="fee_rate"  value="1">
<input type="hidden" name="lock_flag"  value="0">
<input type="hidden" name="busi_type"  value="01">
<input type="hidden" name="use_status"  value="Y">
<input type="hidden" name="cover_region"  value="">
<input type="hidden" name="chg_flag"  value="N">
<input type="hidden" name="catalog_item_id" id="catalog_item_id" value="<%=catalog_item_id%>">
<input type='hidden' id='chg_price' name='chg_price' value='' />
<a href="#none" id="returntop"></a>
<TABLE cellSpacing=0>
    <TR>
        <TD class=blue>֤������</TD>
        <TD>
            <input name=iccid <%if(nextFlag==2)out.println("readonly");%> id="iccid" size="24" maxlength="20" value="<%=iccid%>" v_type="string" v_must=1 index="1">
            <input name=custQuery type=button id="custQuery" class="b_text" onClick="getInfo_Cust();" onKeyUp="if(event.keyCode==13)getInfo_Cust();" style="cursor:hand" value=��ѯ>
            <font class="orange">*</font>
        </TD>
        <TD class=blue>���ſͻ�ID</TD>
        <!--wuxy alter maxlength="12" 20080706-->
        <TD>
            <input type="text" <%if(nextFlag==2)out.println("readonly");%> value="<%=cust_id%>" name="cust_id" id="cust_id" size="20" maxlength="12" v_type="0_9" v_must=1 index="2">
            <font class="orange">*</font>
        </TD>
    </TR>
    
    <TR>
        <TD class=blue>���ű��</TD>
        <TD>
            <input name=unit_id <%if(nextFlag==2)out.println("readonly");%> value="<%=unit_id%>" id="unit_id" size="24" maxlength="11" v_type="0_9" v_must=1 index="3">
            <font class="orange">*</font>
        </TD>
        <TD class=blue>���ſͻ�����</TD>
        <TD>
            <input name="cust_name" id="cust_name" size="20" readonly value="<%=cust_name%>" v_must=1 v_type=string index="4">
            <font class="orange">*</font>
        </TD>
    </TR>
    
    <TR>
        <TD class=blue>���ſͻ�����</TD>
        <TD>
        <%
            if(!ProvinceRun.equals("20"))  //������Ǽ���
            {
            %>        
                <jsp:include page="/npage/common/pwd_1.jsp">
                <jsp:param name="width1" value="16%"  />
                <jsp:param name="width2" value="34%"  />
                <jsp:param name="pname" value="custPwd"  />
                <jsp:param name="pwd" value="<%=123%>"  />
                </jsp:include>
            <%}else{%>
                <input name=custPwd value="" type="password" id="custPwd" size="6" maxlength="6" v_must=1>
            <%}%>   
            <input name=chkPass type=button onClick="check_HidPwd();" class="b_text" style="cursor:hand" id="chkPass2" value=У��>
            <font class="orange">*</font>
        </TD>
        <TD class=blue>����Ʒ��</TD>
        <TD>
            <%
            if(userType!=""){
            %>
                <select name="sm_code" id="sm_code"  onChange="changeSmCode()" v_must=1 v_type="string" index="10" >
            <%
            }else{
            %>
                <select name="sm_code" id="sm_code"  onChange="changeSmCode()" v_must=1 v_type="string" index="10" >
            <%}%>
        <%
        try
        {
            String in_chance_id = in_ChanceId;
            String in_ChanceId3 = WtcUtil.repNull((String)request.getParameter("in_ChanceId3"));
            System.out.println("#################################inChanceId======="+in_ChanceId3);
            if(in_ChanceId3 != null && !"".equals(in_ChanceId3)){
                in_chance_id = in_ChanceId3;
            }
            System.out.println("#################################inChanceId======="+in_chance_id);
            String dlLabel = "";
            if("DL100".equals(openLabel)){
                dlLabel = "1";
            }
            System.out.println("# dlLabel = "+dlLabel);
            %>
                <wtc:service name="sGrpSmCheckQryE" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode16" retmsg="retMsg16" outnum="2" >
                    <wtc:param value="u01"/>
                    <wtc:param value="<%=workno%>"/> 
                    <wtc:param value="<%=nopass%>"/> 
                    <wtc:param value="<%=regionCode%>"/> 
                    <wtc:param value="<%=in_chance_id%>"/>
                    <wtc:param value="<%=dlLabel%>"/>
                    <wtc:param value="<%=unit_id%>"/>
                    <wtc:param value="<%=sm_code%>"/>
                </wtc:service>
                <wtc:array id="retArr16" scope="end"/>
            <%	
            System.out.println("# from f3690_1.jsp , return by sGrpSmCheckQry - > retcode = "+retCode16); 
            if(retCode16.equals("000000")){
                result = retArr16;
            }
        	else
        	{
        	%>
        		<script>
        			rdShowMessageDialog("<%=retCode16%>:<%=retMsg16%>");
        			removeCurrentTab();
        		</script>
        	<%}
            int recordNum = result.length;
            for(int i=0;i<recordNum;i++)
            {
                if (userType.equals(result[i][0]))
                {
                    out.println("<option class='button' value='" + result[i][0].trim() + "' selected>" + result[i][1] + "</option>");
                }
                else
                {
                    out.println("<option class='button' value='" + result[i][0].trim() + "'");
                    out.print(">" + result[i][1] + "</option>");
                }
            }
        }catch(Exception e){
            logger.error("Call sGrpSmCheckQry is Failed!");
        }
        %>
            </select>
        </TD>
    </TR>
    
    <TR id="bizTypeFlag" name="bizTypeFlag" style="display:none;">
        <TD class=blue>
            <span id='bizTypeLFlag1' style='display:none;'>ҵ�����</span>&nbsp;
        </TD>
        <TD>
            <span id='bizTypeLFlag2' style='display:none;'>
                <select id='bizTypeL' name='bizTypeL' onChange='getBizTypeS()'>
             
                </select>
            </span>&nbsp;
        </td>
        <TD class=blue>
            <span id='bizTypeSFlag1' style='display:none;'>ҵ��С��</span>&nbsp;
        </TD>
        <TD>
            <span id='bizTypeSFlag2' style='display:none;'>
                <select id='bizTypeS' name='bizTypeS'>
             
                </select>
            </span>&nbsp;
        </td>
      </TR>
      
      <tr id='trAProdInfosFlag' style='display:none;'>
        <TD class=blue>A�˲�Ʒ���ű��</TD>
        <TD>
            <input type="text" <%if(nextFlag==2)out.println("readonly");%> id='A_prodUnitId' name='A_prodUnitId' value="<%=iA_prodUnitIdHidden%>" size='20' v_must=0 v_type='0_9'  maxlength="11" />
        </TD>
        <TD class=blue>A�˲�Ʒ֤������</TD>
        <TD>
            <input type="text" <%if(nextFlag==2)out.println("readonly");%> id='A_prodIccid' name='A_prodIccid' value='<%=iA_prodIccidHidden%>' size='20' v_must=0 v_type='string' maxlength="20"  />
            <input name='AProdInfosBtn' type='button' id='AProdInfosBtn'  class='b_text' onClick='getInfo_AProdInfo();' onKeyUp='if(event.keyCode==13)getInfo_AProdInfo();' value='��ѯ' />
        </TD>
     </tr>
     <tr id='trAProdUnitInfosFlag' style='display:none;'>
        <TD class=blue>A�˼��Ų�ƷID</TD>
        <TD colspan='3'>
            <input type="text" <%if(nextFlag==2)out.println("readonly");%> id='AProd_grpIdNoHidden' name='AProd_grpIdNoHidden' value='<%=iAProd_grpIdNoHidden%>' size='20' v_must=0 v_type='string' maxlength="20" class="InputGrey" readonly />
            <input name='AProdGrpIdNoBtn' type='button' id='AProdGrpIdNoBtn'  class='b_text' onClick='chkInfo_AProdCode();' onKeyUp='if(event.keyCode==13)chkInfo_AProdCode();' value='У��' />
        </TD>
     </tr>
     <tr id='trRetAProdInfoOne' style='display:none;'>
        <TD class=blue>��Ʒ����</TD>
        <TD >
            <input type="text" id='ret_prodCode' name='ret_prodCode' value='<%=iret_prodCodeHidden%>' size='20' v_must=0  class="InputGrey" readonly />
        </TD>
        <TD colspan='2'>
            <A style="cursor: hand" onMouseOver="this.style.color='#ff0000'" onclick="getInfo_disPriceMsg_detail()" >
              <font class="orange">�����Ϣ</font>&nbsp;
            </A>
        </TD>
     </tr>
    
     <tr id='trRetAProdInfoTwo' style='display:none;'>
        <TD class=blue>��Ʒ����</TD>
        <TD colspan='3  '>
            <input type="text" id='ret_prodName' name='ret_prodName' value='<%=iret_prodNameHidden%>' size='20' v_must=0 class="InputGrey" readonly />
        </TD>
     </tr>
     
     
      
     <tr id='trBizCodeFlag' style='display:none;'>
        <TD class=blue>ҵ�����</TD>
        <TD colspan='3'>
            <input type="text" id='biz_code' name='biz_code' value='<%=oBizCode%>' size='20' v_must=0 v_type='string'>
            <input type="hidden" id='biz_name' name='biz_code' value='<%=bizName%>' size='20' v_must=0 v_type='string'>
        </TD>
     </tr>
     <TR id="prodFlag" name="prodFlag" style="display:">   
        <td class=blue>���Ų�Ʒ</td>
        <td colspan='3'>
            <input type='text' id='F00017' name='F00017' size='20' readonly onChange='changeProduct()' v_must=1 v_type='string' value="<%=F00017%>">
            <input name='prodQuery2' type='button' id='ProdQuery2'  class='b_text' onClick='getInfo_Prod2();' onKeyUp='if(event.keyCode==13)getInfo_Prod2();' value='ѡ��'>
            <font class="orange">*</font>
        </td> 
    </TR>
    <tr style='display:none'>
        <TD class=blue>���Ų�Ʒ����</TD>
        <TD colspan='3'>
            <select name="ProdType" >
            	<option  value='0' selected>����ҵ��</option>
            	<option  value='1' >������ҵ��</option>
            	
            </select>
        </TD>
    </tr>
    <TR id="province_id" style="display:none">
        <TD class=blue>��������ʡ����</TD>
        <TD colspan=3>
            <input class="InputGrey" type="text" name="province" size="20"  
        <%
            try
            {
                sqlStr = "select AGENT_PROV_CODE from sprovinceCode where run_flag = 'Y'";
                //sqlStr = "select '16' from dual";
                //retArray = callView.sPubSelect("1",sqlStr);
            %>
                <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode15" retmsg="retMsg15"  outnum="1">
                    <wtc:sql><%=sqlStr%></wtc:sql>
                </wtc:pubselect>
                <wtc:array id="retArr15" scope="end" />
            <%
                //result = (String[][])retArray.get(0);
                if(retCode15.equals("000000")){
                    result = retArr15;
                }
                int recordNum = result.length;
                for(int i=0;i<recordNum;i++){
                    out.println("value='" + result[i][0] + "'");
                }
            }catch(Exception e){
                logger.error("��ѯ����ʡ����ʧ��!");
            }
        %>
            readonly v_must=1 v_type="0_9" index="11"> 
            <font class="orange">*</font>
        </TD>
    </TR>
    
</TABLE>
<div style="overflow-x:scroll;padding:0px;width:auto;" id="Operation_Table"  >
      <TABLE id="getRetAProdProperTab" class="groupTab" cellSpacing=0 style="display:none;">
        <TR>
          <TD colspan=100>
            <span id = "title_zi"><b>AZ�˼�������</b></span>&nbsp;&nbsp;
          </TD>
        </TR>
        <TR>
          <TD nowrap >ר��ʵ�����</TD>
          <TD nowrap >A���û�����</TD>
          <TD nowrap >����A</TD>
          <TD nowrap >A����������</TD>
          <TD nowrap >�˵�A��ϸ��ַ</TD>
          <TD nowrap >A���û�������ϵ��</TD>
          <TD nowrap >A���û�������ϵ�绰</TD>
          <TD nowrap >A��·�ɱ�����ʽ</TD>
          <TD nowrap >A��ҵ���ϵȼ�</TD>
          <TD nowrap >Z���û�����</TD>
          <TD nowrap >����Z</TD>
          <TD nowrap >Z����������</TD>
          <TD nowrap >�˵�Z��ϸ��ַ</TD>
          <TD nowrap >Z���û�������ϵ��</TD>
          <TD nowrap >Z���û�������ϵ�绰</TD>
          <TD nowrap >Z��·�ɱ�����ʽ</TD>
          <TD nowrap >Z��ҵ���ϵȼ�</TD>
          <TD nowrap >ר��״̬</TD>
          <TD nowrap >״̬ʱ��</TD>
          <TD nowrap >A�˽������</TD>
        </TR>
        <tr>
        <tbody id="terminal"></tbody>
        </tr>
	       </TABLE>
    </div>

<!---- ���ص��б�-->
<%
    //Ϊinclude�ļ��ṩ���� 
    int fieldCount=0;
    boolean isGroup = true;
    
    if (resultList != null)
    {
    	fieldCount = resultList.length;
    }
    String []fieldCodes=new String[fieldCount];
    String []fieldNames=new String[fieldCount];
    String []fieldPurposes=new String[fieldCount];
    String []fieldValues=new String[fieldCount];
    String []dataTypes=new String[fieldCount];
    String []fieldLengths=new String[fieldCount];
    String []fieldGroupNo=new String[fieldCount];
    String []fieldGroupName=new String[fieldCount];
    String []fieldMaxRows=new String[fieldCount];
    String []fieldMinRows=new String[fieldCount];
    String []fieldCtrlInfos=new String[fieldCount];
    String []openParamFlag=new String[fieldCount];
    System.out.println("====yuanqs---fieldCount--" + fieldCount);
    String []fieldReadOnly = new String[fieldCount];	//yuanqs add 2011/5/24 10:57:32 ����readonly
    int iField=0;
    while(iField<fieldCount)
	{
		fieldCodes[iField]=resultList[iField][0];
		fieldNames[iField]=resultList[iField][1];
		fieldPurposes[iField]=resultList[iField][2];
		fieldValues[iField]=resultList[iField][10];
		dataTypes[iField]=resultList[iField][3];
		System.out.println("--------------------===qidp===--------------------"+dataTypes[iField]);
		System.out.println("--------------------===yuanqs===--iField------------------"+iField);
		System.out.println("--------------------===yuanqs===--resultList[iField][12]------------------"+resultList[iField][11]);	
		System.out.println("--------------------===yuanqs===--resultList[iField][12]------------------"+resultList[iField][12]);		
		fieldLengths[iField]=resultList[iField][4];
		System.out.println("!@#$%^&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"+fieldLengths[iField]);
		fieldGroupNo[iField]=resultList[iField][5];
		fieldGroupName[iField]=resultList[iField][6];
		fieldMaxRows[iField]=resultList[iField][7];
		fieldMinRows[iField]=resultList[iField][8];
		fieldCtrlInfos[iField]=resultList[iField][9];
		openParamFlag[iField]=resultList[iField][11];
		fieldReadOnly[iField]=resultList[iField][12];
		iField++;
	}
	
	request.setAttribute("fieldCodes",fieldCodes);
  request.setAttribute("fieldNames",fieldNames);
  request.setAttribute("fieldPurposes",fieldPurposes);
  request.setAttribute("fieldValues",fieldValues);
  request.setAttribute("dataTypes",dataTypes);
  request.setAttribute("fieldLengths",fieldLengths);
  request.setAttribute("fieldGroupNo",fieldGroupNo);
  request.setAttribute("fieldGroupName",fieldGroupName);
  request.setAttribute("fieldMaxRows",fieldMaxRows);
  request.setAttribute("fieldMinRows",fieldMinRows);
  request.setAttribute("fieldCtrlInfos",fieldCtrlInfos);
  request.setAttribute("fieldReadOnly",fieldReadOnly);
  request.setAttribute("openParamFlag",openParamFlag);
  request.setAttribute("resultList",resultList);
  
  /*update ���ҳ�������������ı������⣬��ҳ�����÷�ʽ�����޸ġ�@2013/8/27 */
%>
	<jsp:include page="/npage/s3690/fpubDynaFields_2.jsp">
	  <jsp:param name="isGroup" value="<%=isGroup%>"  />
	  <jsp:param name="fieldCount" value="<%=fieldCount%>"  />
	  <jsp:param name="nextFlag" value="<%=nextFlag%>"  />
	  <jsp:param name="iField" value="<%=iField%>"  />
	  <jsp:param name="listShow" value="<%=listShow%>"  />
	  <jsp:param name="regionCode" value="<%=regionCode%>"  />
	  <jsp:param name="workno" value="<%=workno%>"  />
	  <jsp:param name="org_code" value="<%=org_code%>"  />
	  <jsp:param name="districtCode" value="<%=districtCode%>"  />
	  <jsp:param name="userType" value="<%=userType%>"  />
	  <jsp:param name="sqlStr" value=""  />
	  <jsp:param name="powerRight" value="<%=powerRight%>"  />
	  <jsp:param name="addDate" value="<%=addDate%>"  />
	  <jsp:param name="openLabel" value="<%=openLabel%>"  />
	  <jsp:param name="telNo" value="<%=telNo%>"  />
	  <jsp:param name="dateStr" value="<%=dateStr%>"  />
	  <jsp:param name="xProductCode" value="<%=xProductCode%>"  />           
	  <jsp:param name="v_regionCode" value="<%=regionCode%>"  />         
	</jsp:include>
	
<tr>
    <td class=blue>��ϵ������</td>
    <td colspan='3'>
    	<input id='F10305' name='F10305' type='text' readOnly class='InputGrey'  v_must=0 v_type='string' index='14' value='<%=(contact_info == null)?"":(contact_info[0][0])%>'>
    </td>
</tr>

<tr>
    <td class=blue>������ϵ�绰</td>
    <td>
    	<!-- yuanqs add 2011/6/10 16:28:41 ���Ӽ�����ϵ�绰�������ƣ�֮ǰ�������뺺�� -->
        <input id='F10306' name='F10306' type='text' onkeyup="value=value.replace(/[^\d]/g, '')" onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g, ''))" onKeyPress='return isKeyNumberdot(0)'  v_must=0 v_type='string' maxlength="18" value='<%=(contact_info == null)?"":(contact_info[0][2])%>'>
    </td>
    <td class=blue>������ϵ��ַ</td>
    <td>
        <input id='F10307' name='F10307' type='text' readOnly class='InputGrey' onKeyPress='return isKeyNumberdot(0)'  v_must=0 v_type='string' value='<%=(contact_info == null)?"":(contact_info[0][1])%>'>
    </td>
</tr>

<tr id="payTypeId">
    <td class=blue>���ʽ</td>
    <td colspan=3>
        <select name="F10311" id="F10311" v_must=1 v_type="string" index="10">
    <%
        String[][] result33 = null;
        try
        {
            sqlStr = "select pay_code, pay_name from sPayCode where region_code = '" + regionCode + "' order by pay_code";
            //retArray = callView.sPubSelect("2",sqlStr);
        %>
            <wtc:pubselect name="sPubSelect" outnum="2" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
                <wtc:sql><%=sqlStr%></wtc:sql>
            </wtc:pubselect>
            <wtc:array id="result_tu3" scope="end"/>               
        <%
            result = result_tu3;
            int recordNum = result.length;
            for(int i=0;i<recordNum;i++){
                out.println("<option value='" + result[i][0] + "'>" + result[i][1] + "</option>");
            }
        }catch(Exception e){
            logger.error("Call sunView is Failed!");
        }
    %>
        </select>
        <font class="orange">*</font>    
    </td>
</tr>

<tr id="grpProId">
    
    <TD class=blue>ҵ������</TD>
    <TD>
    	<input type="text" name="F00018" size="20" readonly value="<%=F00018%>">
    </TD>
    <TD class=blue>��������</TD>
    <TD>
        <select name="F00015" id="F00015" disabled >
        <%//add
        try
        {
            sqlStr = "select substr('"+org_code+"',1,2),substr('"+org_code+"',1,7),'�������ڵ�' from dual "
               +" union all select region_code,belong_code,belong_name from sBelongCode";
            String[] inParams = new String[2];
            inParams[0] = "select substr(:org_code,1,2),substr(:org_code2,1,7),'�������ڵ�' from dual "
               +" union all select region_code,belong_code,belong_name from sBelongCode";
            inParams[1] = "org_code="+org_code+",org_code2="+org_code;
            //retArray = callView.sPubSelect("3",sqlStr);
            System.out.println("------------%%%%%%%%%%%%%%%%%----"+sqlStr);
        %>
            <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode2" retmsg="retMsg2" outnum="3">
                <wtc:sql><%=sqlStr%></wtc:sql>
            </wtc:pubselect>
            <wtc:array id="resultTemp2" scope="end" />
        <%
            if(resultTemp2.length!=0)
                result = resultTemp2;
            //System.out.println("result[[][]===="+result[0][0]);
            int recordNum = result.length;
            for(int i=0;i<recordNum;i++)
            {
                //System.out.println(result[i][1]+"--"+result[i][2]);
            %>
                <option value="<%=result[i][1]%>" ><%=result[i][1]%>--<%=result[i][2]%></option>
            <%
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        %>
        </select>
    </TD>
</tr>

<TR id="tr_gongnengfee"  name="tr_gongnengfee" style="display:none" >
    <TD class="blue">���ܷѸ��ѷ�ʽ</TD>
    <TD colspan=3>
        <select name="F00019" id="F00019" <%if(nextFlag==2)out.println("readonly");%>>
            <option value="0"> 0-���Ÿ��� </option>
            <option value="1"> 1-���˸��� </option>
        </select>
    <font color="orange">*</font>
</TD>
    
<TR style="display:none" id="proType">
    <TD class=blue>��Ʒ����</TD>
    <TD colspan='3'>
        <input type="text" name="product_attr_hidden" size="20" readonly  onChange="changeProdAttr()" v_must=0 v_type="string">
        <input name="ProdAttrQuery" type="button" id="ProdAttrQuery"  class="b_text" onClick="getInfo_ProdAttr('0');" onKeyUp="if(event.keyCode==13)getInfo_ProdAttr('0');" value="ѡ��">
        
        <input type="hidden" name="product_attr" value="<%=product_code%>"/>
    </TD>
</TR>

    <TR id="productGroup"  style="display:none">
        <TD class=blue>���Ų�Ʒ</TD>
        <TD id="ipTd">
            <input type="text" name="product_code" size="20" readonly onChange="changeProduct()" v_must=1 v_type="string" value="<%=product_code%>">
            <input name="prodQuery" type="button" id="ProdQuery"  class="b_text" onClick="getInfo_Prod();" onKeyUp="if(event.keyCode==13)getInfo_Prod();" value="ѡ��">
            <font class="orange">*</font>
        </TD>
        <TD class=blue></TD>
        <TD id="ipTd1"></TD>
    </TR>
    <tr>
        <TD class=blue>���Ÿ��Ӳ�Ʒ</TD>
        <TD>
            <input type="text" name="product_append" id="product_append" size="20" readonly v_must=0 v_type="string" value="<%=product_append%>">
            <input name="ProdAppendQuery" type="button" id="ProdAppendQuery"  class="b_text" onClick="getInfo_ProdAppend();" onKeyUp="if(event.keyCode==13)getInfo_ProdAppend();" value="ѡ��">
        </TD>
        <td class='blue'>
            <span id="f5000Flag1" name="f5000Flag1" style="display:<%=f5000Label%>;">���������</span>&nbsp;
        </td>
        <td>
            <span id="f5000Flag2" name="f5000Flag2" style="display:<%=f5000Label%>;">
                <select id="F10500" name="F10500">
                    <option value="">--��ѡ��--</option>
                    <option value="1">һ����</option>
                    <option value="2">������</option>
                    <option value="3">������</option>
                </select>
                &nbsp;<font class='orange'>*</font>
            </span>&nbsp;
        </td>
    </tr>
    <TR>
        <TD class=blue>���Ų�ƷID</TD>
        <TD>
            <input name="grp_id" id="grp_id" type="text" size="20" maxlength="12" readonly v_type="0_9" v_must=1>
            <input name="grpQuery" type="button" id="grpQuery"  class="b_text" onClick="getUserId();" onKeyUp="if(event.keyCode==13)getUserId();" value="��ȡ">
            <font class="orange">*</font>
        </TD>
        <TD class=blue>�û�����</TD>
        <TD>
            <input name="grp_name" type="text" size="20" maxlength="60" v_must=1 v_maxlength=60 v_type="string" value="<%=grp_name%>">
            <font class="orange">*</font>
        </TD>
    </TR>
          
    <TR>
        <TD class=blue>��Ʒ�ʻ�ID</TD>
        <TD>
            <input name="account_id" type="text" size="20" maxlength="12" readonly v_type="0_9" v_must=1>
            <input name="accountQuery" type="button" class="b_text" id="accountQuery" onClick="getAccountId();" onKeyUp="if(event.keyCode==13)getAccountId();" value="��ȡ" >
            <font class="orange">*</font>
        </TD>
        <TD class=blue>
            <span id='grpNoFlag1'>���Ų�Ʒ���</span>&nbsp;
        </TD>
        <TD>
            <span id='grpNoFlag2'>
                <input name="grp_userno" id="grp_userno" type="text" size="20" maxlength="4" readonly v_type="string" v_must=1>
                <input name="getGrpNo" type="button" class="b_text" id="getGrpNo" onClick="getGrpUserNo();" onKeyUp="if(event.keyCode==13)getGrpUserNo();" value="��ȡ">
                <font class="orange">*</font>
            </span>&nbsp;
        </TD>
    </TR>
          
    <TR>
        <%if(!ProvinceRun.equals("20"))  //���Ǽ���
        {
        %>  
            <jsp:include page="/npage/common/pwd_4.jsp">
                <jsp:param name="width1" value="18%"  />
                <jsp:param name="width2" value="32%"  />
                <jsp:param name="pname" value="user_passwd"  />
                <jsp:param name="pcname" value="account_passwd"  />
            </jsp:include>
        <%}else{%>
            <TD class=blue> 
                <div align="left">�ʻ�����</div>
            </TD>
            <TD>
                <input name="user_passwd" type="password" class="button" maxlength=6 pwdlength="6">
            </TD>
            <TD class=blue> 
                <div align="left">����У��</div>
            </TD>
            <TD>
                <input  name="account_passwd" type="password" class="button" prefield="user_passwd" filedtype="pwd" maxlength=6 pwdlength=6>	
            </TD>
        <%}%> 
    </TR>
           
    <TR id="srv_date" style="display:">
        <TD class=blue>ҵ����ʼ����</TD>
        <TD>
            <input name="srv_start" type="text" id="srv_start" v_format="HHmmss" readOnly class="InputGrey" onKeyPress="return isKeyNumberdot(0)" value="<%=dateStr%>" size="20" maxlength="8" v_must=1 v_type="date" > <font class="orange">*</font>
        </TD>
        <TD class=blue>ҵ���������</TD>
        <TD>
            <input name="srv_stop" type="text" id="srv_stop" v_format="HHmmss" readOnly class="InputGrey" onKeyPress="return isKeyNumberdot(0)" value="20500101" size="20" maxlength="8" v_must=1 v_type="date"  readonly> <font class="orange">*</font>
        </TD>
    </TR>
    
    <TR id="credit" style="display:none">
        <TD class=blue>���ö�</TD>
        <TD>
            <input name="credit_value" type="text" value="1000" id="credit_value" size="20" maxlength="6" v_must=0 v_type="string" >
            <font class="orange"></font>
        </TD>
        <TD class=blue>���õȼ�</TD>
        <TD>
            <input name="credit_code" type="text" id="credit_code3" value="0" size="20" maxlength="2" v_must=0 v_type="string" >
            <font class="orange"></font>
        </TD>
    </TR>

    <TR>
        <%
        String handfee2 = "0.00";
        try{
            sqlStr = "select hand_fee from sNewFunction where function_Code ='3500'";
            //retArray = callView.sPubSelect("1",sqlStr);
        %>
            <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode17" retmsg="retMsg17"  outnum="1">
                <wtc:sql><%=sqlStr%></wtc:sql>
            </wtc:pubselect>
            <wtc:array id="retArr17" scope="end" />
        <%
            //result = (String[][])retArray.get(0);
            if(retArr17.length>0 && retCode17.equals("000000")){
                handfee2 = retArr17[0][0];
            }
        }
        catch(Exception e){
            System.out.println("�����ѳ���!");
        }
        %>
        <%if(!(userType.equals("pe"))) {%>
            <TD class=blue>Ӧ��������</TD>
            <TD >
                <input name="should_handfee" id="should_handfee" class=InputGrey value="<%=handfee2%>" readonly>
            </TD>
            <TD class=blue>ʵ��������</TD>
            <TD width="32%">
                <input  name="real_handfee" id="real_handfee" value="0" v_must=0 v_type=money>
            </TD>
        <%}else{%>
            <input type="hidden" name="should_handfee" value="0">
            <input type="hidden" name="real_handfee" value="0">
        <%}%>
    </TR>
    
<TR id="pay_type22">
    <TD class=blue>���ʽ</TD>
    <TD>
        <select name='payType' id='payType' onchange='changePayType()'>
            <option value='0'>�ֽ�</option>
            <option value='9'>֧Ʊ</option>
        </select>
        <font class="orange">&nbsp;*</font>
    </TD>
    <TD class=blue>һ���Ը�����</TD>
    <TD colspan="1">
        <input name="cashNum" type="text" v_must=1 v_maxlength=8 v_type="string" index="8" value="" readOnly>
        <input name=cash_num type=button id="cash_num" class="b_text" onClick="getCashNum();getGrpUserNo();" onKeyUp="if(event.keyCode==13)getCashNum();getGrpUserNo();" style="cursor��hand" value=��ѯ>
        <font class="orange">*</font>
    </TD>
</TR>

    <tr id="cashPay_div" style="display:''">
        <td class=blue>�ֽ𽻿�</td>
        <td >
            <input type="text" name="cashPay" maxlength="10" readOnly value="">
            <input name="checkPass" id="next5" type="button" onClick="check_cashPay()" class="b_text" value="����У��">
            <font class="orange">*</font>
        </td>
        <%
        if(cust_price.equals("T")){
        %>
          <td class=blue>Ӧ�տ���</td>
           <td colspan=3>
          <input type="text" name="cust_price" v_must=1 maxlength="10"  value="0.00"> 
          <font class="orange">*</font>
          </td>
        
        <%}else{%>
         <td >&nbsp;</td>
         <td >&nbsp;</td> 
        <%}%>
    </tr>
         
<%if("CK".equals(sm_code)){%>
<tr id="cashPay_div_add1" style="display:''">
	<td class="blue">Ʊ�ݺ���</td>	
	<td><input type="text" id="F10967" name="F10967" maxlength="256" v_must="1" v_type='string' /></td>	
	<td class="blue">��Ӧ����</td>	
	<td><input type="text" id="F10968" name="F10968" maxlength="256" v_must="1" v_type='string' /></td>	
</tr>

<tr id="cashPay_div_add2" style="display:''">
	<td class="blue">���˽��</td>	
	<td><input type="text" id="F10969" name="F10969" maxlength="256" v_must="1" v_type="money"/></td>	
	<td class="blue">Ʊ��ʱ��</td>	
	<td><input type="text" id="F10970" name="F10970" maxlength="8"   v_must="1" v_type="date" /></td>	
</tr>

<%}%>
<TBODY>
    <TR id='checkPayTR'> 
        <TD class=blue nowrap> 
            <div align="left">֧Ʊ����</div>
        </TD>
        <TD width="32%" nowrap> 
            <input class="button" v_must=0 v_type="0_9" name=checkNo maxlength=20 onkeyup="if(event.keyCode==13)getBankCode();" index="50">
            <font class="orange">*</font>
            <input name=bankCodeQuery type=button class="b_text" style="cursor:hand" onClick="getBankCode()" value=��ѯ>
        </TD>
        <TD class=blue nowrap> 
            <div align="left">���д���</div>
        </TD>
        <TD width="32%" nowrap> 
            <input name=bankCode size=12 maxlength="12" readonly>
            <input name=bankName size=20 readonly>
        </TD>                                              
    </TR>
</TBODY>
    
<TBODY> 
    <TR id='checkShow' style='display:none'> 
        <TD class=blue nowrap> 
            <div align="left">֧Ʊ����</div>
        </TD>
        <TD width=32%>
            <input class="button" v_must=0 v_type=money v_account=subentry name="checkPay" value="0.00" maxlength=15 index="51">
            <font class="orange">*</font> </TD> 
        <TD class=blue> 
            <div align="left">֧Ʊ���</div>
        </TD>
        <TD width=32%> 
            <input class="button" name="checkPrePay" value=0.00 readonly>
        </TD>               
    </TR>            
</TBODY>
	
	<TR>
        <TD class=blue>��Ŀ��ͬ��</TD>
        <TD width="32%">
            <input type='text' name="cnttId"  maxlength='10' >

        </TD>
        <TD class=blue>��ƷЭ���</TD>
        <TD width="32%">
            <input type='text' name="cptId" maxlength='10' >
            <font class='orange'>*</font>
        </TD>        
    </TR>
           
    <TR>
        <TD class=blue>��ע</TD>
        <TD width="82%" colspan="3">
            <input class="InputGrey" name="sysnote" size="60" readonly>
        </TD>
    </TR>
    
    <TR style="display:none">
            <TD class=blue>�û���ע</TD>
            <TD width="82%" colspan="3">
            <input name="tonote" size="60" value="<%=workno%>���в���">
        </TD>
    </TR>
</TABLE>

 <!-----------���ص��б�--> 
<TABLE cellSpacing=0>
    <TR id="footer">        
        <TD align=center>
        <%
            if (nextFlag==1){
        %>
                <input name="next" class="b_foot"  type=button value="��һ��" onclick="nextStep()" disabled>
        <%
            }else {
        %>
                <script>
                    closefields();
                </script>
                <input class="b_foot" name="previous"  type=button value="��һ��" onclick="previouStep()" style="display:none">
                <input class="b_foot" name="sure" id="sure" type=button value="ȷ��" onclick="refMain()" >
        <%
            }
        %>
        <%if(!"DL100".equals(openLabel)){%>
            <input class="b_foot" name=back  type=button value="���" onclick="window.location='f3690_1.jsp'">
        <%}%>
            <input class="b_foot" name="kkkk"  onClick="
            <%if("DL100".equals(openLabel)){%>
                doResume() //yuanqs add 2010-9-2 17:18:18
            <%}else{%>
                removeCurrentTab()
            <%}%>
            " type=button value="�ر�">
        </TD>
    </TR>
    <!-------------������--------------->
    <input type="hidden" name="modeType">
    <input type="hidden" name="typeName">
    <input type="hidden" name="addMode">
    <input type="hidden" name="modeName">
    <input type="hidden" name="nameList">
    <input type="hidden" name="nameGroupList">	
    <input type="hidden" name="fieldNamesList">
    <input type="hidden" name="openFlagList">
    <input type='hidden' id='bizLevel' name='bizLevel' value='1' />
    <input type="hidden" name="choiceFlag">
    <input type="hidden" name="in_ChanceId2">
    <input type="hidden" name="waNo" value="<%=wa_no%>">
    <input type="hidden" name="input_accept" value="<%=input_accept%>">
    <input type="hidden" name="telNo" value="">
    <input type="hidden" name="in_ChanceId3" id="in_ChanceId3" value="<%=in_ChanceId%>" />
    <input type="hidden" name="waNo3" id="waNo3" value="<%=wa_no%>" />
    <input type='hidden' id='open_label' name='open_label' value='<%=openLabel%>' />
    <input type='hidden' id='btn_id' name='btn_id' value='<%=iBtnId%>' />
    <input type='hidden' id='count' name='count' value='<%=inCount%>' />
    <input type='hidden' id='batch_no' name='batch_no' value='<%=inBatchNo%>' />
    <input type="hidden" id="MLFlag" name="MLFlag" value="<%=MLFlag%>" />
    <input type="hidden" id="oMLFlag" name="oMLFlag" value="<%=oMLFlag%>" />
    <input type="hidden" id="smCodeHidden" name="smCodeHidden" value="" />
    <input type="hidden" id="bizTypeLHidden" name="bizTypeLHidden" value="" />
    <input type="hidden" id="bizTypeSHidden" name="bizTypeSHidden" value="" />
    
    
    <input type="hidden" id="AProd_iccidHidden" name="AProd_iccidHidden" value="" />
    <input type="hidden" id="AProd_cust_idHidden" name="AProd_cust_idHidden" value="" />
    <input type="hidden" id="AProd_cust_nameHidden" name="AProd_cust_nameHidden" value="" />
    <!-- <input type="hidden" id="AProd_grpIdNoHidden" name="AProd_grpIdNoHidden" value="" /> -->
    <input type="hidden" id="AProd_user_noHidden" name="AProd_user_noHidden" value="" /> 
    <input type="hidden" id="AProd_grp_nameHidden" name="AProd_grp_nameHidden" value="" />
    <input type="hidden" id="AProd_product_code2Hidden" name="AProd_product_code2Hidden" value="" /> 
    <input type="hidden" id="AProd_product_name2Hidden" name="AProd_product_name2Hidden" value="" />
    <input type="hidden" id="AProd_unit_idHidden" name="AProd_unit_idHidden" value="" />
    <input type="hidden" id="AProd_account_idHidden" name="AProd_account_idHidden" value="" />
    <input type="hidden" id="AProd_sm_nameHidden" name="AProd_sm_nameHidden" value="" />
    <input type="hidden" id="AProd_sm_codeHidden" name="AProd_sm_codeHidden" value="" />
    <input type="hidden" name="qryFlag"   value="" />
    <input type="hidden" id="chkAproInfoFlag" name="chkAproInfoFlag"   value="N" />
    <input type="hidden" id="bizTypeLHiddenSub" name="bizTypeLHiddenSub" value="<%=iBizTypeLHidden%>" />
    <input type="hidden" id="inOpenFlag" name="inOpenFlag" value="<%=inOpenFlag%>" />
    
    <!-------------������--------------->
</TABLE>
	<div id="msgDiv">
	    <span></span>
	</div>
<jsp:include page="/npage/common/pwd_comm.jsp"/>
<%@ include file="/npage/include/footer.jsp" %>
</FORM>
<%if (nextFlag==1){%>
    <script language="JavaScript">
        document.frm.iccid.focus();
        //query_prodAttr();
    </script>
<%}%>
</BODY>
</HTML>

<script>
    /*liujian 2012-12-24 14:55:47 ��ά��ҵ��
    * 1. ���ö�ά��ʹ�÷�(Ԫ)(10641)����Ϊ���ɱ༭
    * 2. ���ö�ά������(10639) �� �������ʣ�Ԫ/����(10640)��key�¼���ʹ ��ά��ʹ�÷�(Ԫ) = ��ά������ �� �������ʣ�Ԫ/����
    * 3. ��ά���������������ʡ���ά��ʹ�÷Ѷ�������������
    */
    $(function() {
    	if($('#catalog_item_id').val() == '212') {
    		var ids = new Array();
	    //    ids.push('F10638');
	      /*  ids.push('F10639');
	        ids.push('F10640');
	        ids.push('F10641');
	        ids.push('F10642');
	        ids.push('F10643');
	        */
	        
    		$('#Operation_Table #segMentTab0').css('display','none');
    		var obj = $('#segMentTab0 tbody');
            var segment = displayNone(obj,ids);
            $('#Operation_Table #segMentTab0 tbody').empty().append(segment);
            $('#Operation_Table #segMentTab0').css('display','block');
            
    		//��ʼ����ά���������������ʡ���ά��ʹ�÷�
    		$('#F10641').attr('readOnly',true);
    		$('#F10641').addClass("InputGrey");
	    	setSignalValue($('#F10639'));
	    	setSignalValue($('#F10640'));
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
	        $('#F10638').keyup(function() {
	            setSignalValue($(this));
	        });
	        //ע��һ���Կ��������¼���ֻ��������
	        $('#F10637').keyup(function() {
	            setSignalValue($(this));
	        });
    	}
    	/*liujian 2013-1-23 10:28:23 ���ڿ�������ʽ��������BOSSϵͳ����ĺ� begin*/
    	if('<%=sm_code%>' == 'hj' && $('#catalog_item_id').val() == '214'){
    		$('#F10653').val($('#cust_name').val());
    		$('#F10654').css('display','none');
    		//��ȡʡ������
    		var packet = new AJAXPacket("f3690_ajax_rent.jsp","���ڻ�����ݣ����Ժ�......");
	        packet.data.add("method","getProv");
	        core.ajax.sendPacket(packet,doGetProv);
	        packet = null;
    	}
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
	    		var packet = new AJAXPacket("f3690_ajax_rent.jsp","���ڻ�����ݣ����Ժ�......");
		        packet.data.add("method","getCity");
		        packet.data.add("prov_code",pv);
		        core.ajax.sendPacket(packet,doGetCity);
		        packet = null;		
    		}
    		
    	});
    	$('#provSelect').change();
    	$('#citySelect').change(function() {
    		if(!$('#citySelect').val()) {
    			$('#F10654').val('none');
    		}else {
    			$('#F10654').val($('#citySelect').val());
    		}
    	});
    	$('#citySelect').change();
    	/*liujian 2013-1-23 10:28:23 ���ڿ�������ʽ��������BOSSϵͳ����ĺ� end*/
    });
    
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
    
    function doGetCity(packet) {
    	var retCode = packet.data.findValueByName("retCode");
		var retMsg = packet.data.findValueByName("retMsg");
		var cityArray = packet.data.findValueByName("cityArray");
		var stm = new Array();
		if($('#citySelect').val()=='' || $('#citySelect').val() ) {
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
					if(i == 0) {
						$('#F10654').val(city.code);	
					}
					stm.push('<option value="' + city.code + '">' + city.name + '</option>');	
				}	
			}
			$('#citySelect').append(stm.join(''));
			
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
    
            /*
            ֻ֧���ĸ�td
           <tr>
                <td>����1</td>
                <td>����1</td>
                <td>����2</td>
                <td>����2</td>
            </tr>
        */
        function displayNone($parent,idArr) {
            var sgmHtml = new Array();
            /*��¼��չʾ��ҳ���ϵ�html��tr�е�td�ĸ��������ĸ�������tr*/
            var oddTd = 0;
            $parent.find('tr').each(function() {
                var tdNum = 0;//��¼tr�еĵڼ���td
                var $tr = $(this);
                $tr.find('td').each(function() {
                    tdNum++;
                    var $td = $(this);
                    var $input = $td.find('input');
                    var $select = $td.find('select');
                    var flag = -1;//��¼��text����select
                    var _id = '';//td�����Ľڵ��id
                    if(typeof($input.val()) != 'undefined') {
                        flag = 0;
                        _id = $input.attr('id');
                    }else if(typeof($select.val()) != 'undefined') {
                        flag = 1;
                        _id = $select.attr('id');
                    }
                    if(flag == 0 || flag == 1) {
                        var isHidden = false;
                        //ѭ��idArr������һ�µ�id������style������idArrɾ������
                        for(var i = 0,len = idArr.length; i < len; i++) {
                            if(_id == idArr[i]) {
                                //���ô�td �� ǰһ��td��style=��display �� none��
                                if(tdNum -2 >= 0){
                                    $tr.find('td:eq(' + (tdNum-2)+ ')').css('display','none');
                                }
                                $td.css('display','none');
                                //��idArrɾ������
                                idArr.splice(i, 1);

                                //������ʾ�Ĳ���¼oddTd
                                isHidden = true;

                            }
                        }
                        if(!isHidden) {
                            if(oddTd == 0) {
                                sgmHtml.push('<tr>');
                            }
                            oddTd = oddTd + 2;
                        }
                        //���ӵ�htmlƬ��
                        addSegment($tr.find('td:eq(' + (tdNum-2)+ ')'),sgmHtml);
                        addSegment($td,sgmHtml);
                        if(oddTd != 0 && oddTd % 4 == 0) {
                            sgmHtml.push('</tr>');
                            oddTd = 0;
                        }
                    }
                });
            });
            if(oddTd == 2) {
                sgmHtml.push('<td></td></tr>');
            }
            return sgmHtml.join('');
        }

        function addSegment($td,segArray) {
           segArray.push($td[0].outerHTML);
        }


    /* liujian 2012-12-24 15:34:48 ��ά��ҵ�� ����*/
        
	//�ض�������
var getDiv=document.getElementById('returntop');
getDiv.onclick=function(){
window.scrollTo(0,0);
}
window.onscroll=function(){
if(document.documentElement.scrollTop){
getDiv.style.display="block";
}else if(document.body.scrollTop){
getDiv.style.display="block";
}else{
getDiv.style.display="none";
}
}
function getWinSize(){
var winHeight=window.innerHeight,winWidth=window.innerWidth;
if(document.documentElement.clientHeight){
winHeight=document.documentElement.clientHeight;
winWidth=document.documentElement.clientWidth;
}else{
winHeight=document.body.clientHeight;
winWidth=document.body.clientWidth;
}
var height=winHeight-92;
var width=winWidth-42;
getDiv.style.top=height+"px";
getDiv.style.left=width+"px";
}
getWinSize();
window.onresize=getWinSize;
</SCRIPT>
<script>
	//liujian 
	$(function() {
		if($('#F01200').attr('name') == 'F01200') {
			$('#F01200').val('');
			$('#F01200').attr('readonly',true).addClass('InputGrey');
			$('#F01200').parent().append('<input class="b_text" type="button" value="��ȡ" id="getReqBtn" />');	
		}	
		$('#getReqBtn').click(function() {
			var packet = new AJAXPacket("f3690_ajax_getReq.jsp","���ڻ�������Ϣ�����Ժ�......");
			 var _data = packet.data;
			 core.ajax.sendPacket(packet,doGetReq);
			 packet = null;
		});
	});
	
	function doGetReq(packet) {
		var loginAccept = packet.data.findValueByName("loginAccept");
		$('#F01200').val(loginAccept);
		$('#getReqBtn').attr('disabled',true);
	}
	
	// zhouby add for �������ƶ�iNG ESOP v2.0.02(����)ҳ���������  2013-11-28
	function validateCallCenter(){
	    var phoneCallCenter = $('#sm_code');
	    var bizType = $('#bizTypeL');
	    
	    if (phoneCallCenter.length > 0 && bizType.length > 0){
	        var phoneCallCenterValue = phoneCallCenter.val();
	        var bizTypeValue = bizType.val();
	        
	        if (phoneCallCenterValue == 'hj' && bizTypeValue == '01'){
	            rdShowMessageDialog('��������ֱ��ҵ���뵽�˵��˰�����');
	            return false;
	        }
	    }
	    
	    return true;
	}
	
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
	
	$(function(){
			/*2015/03/05 17:28:15 gaopeng 
				R_CMI_HLJ_guanjg_2015_2109554  ������ESOPBOSSϵͳʵ��IDC�ؼ���Ϣ¼�빦�ܵ�����ĺ�
			*/
    	letItRedFunc();	
	   
	});



$(document).ready(function (){
	
	
	if(typeof($(this).find('#F10984').val()) != "undefined" ){
      
      if("From4091"=="<%=inOpenFlag%>"){
		 	 		$('#F10984').removeAttr("readOnly");
  				$('#F10984').removeAttr("class");
    	}else{
    		 $("#F10984").attr("readOnly",true);
     		 $("#F10984").addClass("InputGrey");
    	}
	}	
	
	
	
	if(typeof($('#F10817'))!="undefined"&&typeof($('#F10817').val())!="undefined"){
		if("RH"==document.frm.sm_code.value){
			$("#F10817").find("option[value='6']").remove();
			$("#F10817").find("option[value='12']").remove();
		}
	}
	
	
	
});

</script>