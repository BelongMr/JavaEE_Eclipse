<%
/********************
 * version v2.0
 * 开发商: si-tech
 * author:
 * update by qidp @ 2009-06-01 页面整合
 * update by qidp @ 2009-09-14 兼容端到端流程
 * update by qidp @ 2009-11-23 兼容动力100流程
 * update by hejwa @ 2013-1-14 ng3.5项目回顶部
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
    String opName = "集团产品订购";
    
   
    
    Logger logger = Logger.getLogger("f3690_1.jsp");

    String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
    String dateStr22 = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
    int iDate = Integer.parseInt(dateStr);
    //String addDate = Integer.toString(iDate+1);//qidp:此方式有问题，06-30加一天为06-31，不符合要求
    
     String date_yyyyMM = new java.text.SimpleDateFormat("yyyyMM").format(new java.util.Date());
     
    /*add by qidp @ 2009-06-30*/
    Date dateTmp = new Date();
    long timeLen = dateTmp.getTime();
    Date dateTmp2 = new Date(timeLen+1*24*60*60*1000);//加一天
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
    /*2015/8/17 9:25:54 gaopeng 关于7月上旬集团客户部CRM、BOSS系统需求的函--2.关于新增“话费加油包”产品的需求*/
    String[][] favInfo = (String[][])session.getAttribute("favInfo");
		for(int feefavi = 0; feefavi< favInfo.length; feefavi++){
				tempStr = (favInfo[feefavi][0]).trim();
				if(tempStr.compareTo("a323") == 0){
					/*集团话费加油包特殊权限*/
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
	/*产品和服务的访问权限*/
    int iPowerRight = Integer.parseInt(((String)session.getAttribute("powerRight")).trim()); //工号权限
	//取运行省份代码 -- 为吉林增加，山西可以使用session
	String[][] result2  = null;
	sqlStr = "";//黑龙江agent_prov_code='21'
 
	String ProvinceRun = "";
 
    //取工号密码和GROUP_ID
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
    //得到页面参数 
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
	String group_id = "";/*add by liwd 20081127,group_id来自dcustDoc的group_id*/
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
    
    String inOpenFlag = WtcUtil.repNull((String)request.getParameter("openFlag"));/* From4091:端到端接入,DL100:动力100接入 */
    String in_GrpId = request.getParameter("in_GrpId");
    String in_ChanceId = request.getParameter("in_ChanceId");
    String inBatchNo = request.getParameter("batch_no");
    System.out.println("### inBatchNo = "+inBatchNo);
    String sm_code = request.getParameter("sm_code");
    String wa_no = request.getParameter("wa_no1");
    String inCount = WtcUtil.repNull((String)request.getParameter("count"));
    String action = "";
    //关于11月上旬集团客户部CRM、BOSS和经分系统需求的函-3-ESOP系统中新增商机管理支撑内容
    String input_accept = WtcUtil.repNull((String)request.getParameter("input_accept"));
    
    String iA_prodUnitIdHidden = "";  
    String iA_prodIccidHidden = "";
    String iAProd_grpIdNoHidden = "";
    String iret_prodCodeHidden = "";
    String iret_prodNameHidden = "";
    
    /**************
     * add by qidp.
     * 添加标志位(openLabel)
     * link  ：走端到端流程通过任务控制进入此订购模块；
     * opcode：不走端到端流程，通过opcode打开此页面；
     * DL100 ：走动力100流程。
     **************/
    String openLabel = "";
    String MLFlag = "";/* add by qidp.标志位：用于表识是否为ML-本地MAS */
    String oMLFlag = "";
    
    /*add by qidp.判断接入此模块的方式，并做相应的处理。*/
    /*modify by qidp @ 2009-11-23 for 4091模块增加标志位判断是否为端到端。
    if(in_ChanceId != null){//由任务管理接入时，商机编码不为空。
    */
    System.out.println("# inOpenFlag = "+inOpenFlag);
    if("From4091".equals(inOpenFlag)){//由4091接入时，此为端到端流程。
        if(!"ML".equals(sm_code)){
            action = "select";
            openLabel = "link";
        }else{
            MLFlag = "ML";
        }
        iChildAccept = WtcUtil.repNull((String)request.getParameter("child_accept"));
    }else if("DL100".equals(inOpenFlag)){//由DL100接入时，此为动力100流程。
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
    //得到列表操作
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
                rdShowMessageDialog("取客户GroupId出错！",0);
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
             * 当服务品牌为 ADC、本地MAS、全网MAS 时，对当前用户是否能够办理此业务做出判断。
             * 能够办理 ADC、本地MAS、全网MAS 业务的附加条件是 “表 dcustdoc 中 owner_type 字段的值为 '04' ”
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
                        rdShowMessageDialog("该客户不是EC集团，不能办理此业务！",0);
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
            group_id = request.getParameter("group_id");/*add by liwd 20081127,group_id来自dcustDoc的group_id*/
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
                                rdShowMessageDialog("取bizCode失败！",0);
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
            		rdShowMessageDialog("错误代码:<%=retQry[0][0]%>,错误信息:<%=retQry[0][1]%>",0);
                    removeCurrentTab();
            	</script>
<%            	
            }
            
         /*****************************
             * 获取动态配置一次性连接工程费的数据
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
            //得到数据的行数
            //得到具体数据
        }
        catch(Exception e){
            e.printStackTrace();
        }

	
    	 /*****************************
          * 获取集团联系人信息，“姓名，联系电话，地址”。
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
         * 控制页面第三部分-业务信息中，各产品个性信息的展示
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
         * 控制ADC/MAS时，短消息服务代码的长度提示。
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
    iii = xProductCode.indexOf("|"); //得到主产品代码
    if(iii != -1){
        xProductCode = xProductCode.substring(0, iii);
    }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>集团产品开户</TITLE>
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
//yuanqs add 2010/9/6 9:44:15 区分是刷新还是关闭
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
        $("#smsInfo").after("<font color=red>短消息服务代码为：基本接入号"+$("#F00006").val()+" +XXXX  提醒：短信服务号码长度必须为<%=smsMinLen%>-<%=smsMaxLen%>位!请核对好再确认。</font>");
    }else if("<%=smsFlag%>" == "N"){
        $("#smsInfo").after("<font color=red>短消息服务代码为：基本接入号"+$("#F00006").val()+" +XXXX  提醒：短信服务号码长度无限制。</font>");
    }
    if($("#F00004") != null){
        $("#F00004").after("<font color='red'>[0:不限制]</font>");
    }
    if($("#F00005") != null){
        $("#F00005").after("<font color='red'>[0:不限制]</font>");
    }
}else if("AD" == sm_code){
	
}else{
    document.all.smsInfoTR.style.display="none";
}
/* begin add for 关于在专线开户界面增加统谈专线项目填写元素的函@2014/11/24 */
if(typeof($("#F10773")) != "undefined" && typeof($("[name=F10774]:checkbox")) != "undefined"){
	if($("#F10773").val() == "01"){
		$("[name=F10774]:checkbox").attr('disabled', true);
	}else{
		$("[name=F10774]:checkbox").attr('disabled', false);
	}
}
/* end add for 关于在专线开户界面增加统谈专线项目填写元素的函@2014/11/24 */
if("hl" == sm_code){
    //$("#F10011").after("<font color='red'>&nbsp;【单位:M(兆)】</font>");
    /*begin diling add for 如业务大类是数据专线，显示相关内容@2012/12/25 */
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
       var packet = new AJAXPacket("f3690_ajax_getAProdUnitProperty.jsp","正在获得数据，请稍候......");
       packet.data.add("opCode","<%=opCode%>");
       packet.data.add("AProd_grpIdNoHidden",AProd_grpIdNoHidden);
       packet.data.add("custId",custId);
       core.ajax.sendPacket(packet,doGetAProdUnitProperty);
       packet = null;
    }
    /*end diling add @2012/12/25 */
}
        if(sm_code=="AD" || sm_code=="ML" || sm_code=="MA"){//ADC、本地MAS、全网MAS
            document.all.productGroup.style.display="none";//隐藏原有“集团产品、集团附加产品”选择
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
            document.all.sure.disabled="";//将"确定"按钮置为可用
        }else{
            document.all.cashPay_div.style.display="";
            document.all.pay_type22.style.display="";
            document.all.payTypeId.style.display="none";
        }
        if(sm_code=="va"){//BOSS侧VPMN
            document.all.grp_userno.readOnly=false;
            document.all.sure.disabled="";//将"确定"按钮置为可用
        }
        <%if((openLabel!=null && openLabel.equals("opcode")) || "DL100".equals(openLabel)){%>
            if(sm_code == "CR"){//彩铃产品
                //document.all.proType.style.display="";
                //document.all.ProdAppendQuery.disabled="true";
            <%
                /*****************************
                 * 彩铃产品时，需要预先进行验证。
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
                    rdShowMessageDialog("此集团客户已经是彩铃用户或用户是预销状态！");
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
     * 走端到端时，调用服务，获取销售方面传入的数据。
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
                    //如果是端到端项目走这里
<%               if ("hl".equals(sm_code) || "hj".equals(sm_code)){%>
                    if ($(zTarget).is('select') && zValue == ''){
                        $(zTarget).empty().html('<option value=""></option>');
                    } else {
                        $(zTarget).val(zValue);
                    }
<%               } else {  %>
                    //不是端到端走这里
                    zTarget.value = zValue;
<%               }  
                    out.print("}");

                    if(!"F00006".equals(QryServMCArr2[i][1])){//除短信号码外，置为不可修改。
                        /* 屏蔽，在后面统一进行设置 # by qidp @ 2009-08-06 .
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
                if(!"hl".equals(sm_code)){  //品牌为hl时，用户名称不置灰
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
                 *  begin 当为端到端电子流发起的集团专线订购，互联网专线、数据专线、GPRS应用接入、语言类专线、短信接入类，在产品开户时，修改为可以选择集团产品资费@2012/7/11 
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
         * 走端到端时，一些元素不允许修改。
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
                    if("01".equals(result00[i][1])){//01:文本框
                        out.print("if(document.all('"+result00[i][0]+"') != null){");
                            out.print("document.all('"+result00[i][0]+"').readOnly=true;");
                            out.print("$(document.all('"+result00[i][0]+"')).addClass(\"InputGrey\");");
                        out.print("}");
                    }else if("02".equals(result00[i][1])){//02:下拉框
                        out.print("if(document.all('"+result00[i][0]+"')!=null){");
                            out.print("document.all('"+result00[i][0]+"').disabled=true;");
                            out.print("disableStr = disableStr + \""+result00[i][0]+"\" + \"|\";");
                            out.print("");
                        out.print("}");
                    }else if("03".equals(result00[i][1])){//03:按钮
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
       * 走端到端时，多条Z端属性不可修改
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
            if((!"".equals(QryServMCArrQuality[i][23]))&&(QryServMCArrQuality[i][23]!=null)){ //z端属性值
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
            }else{//单个属性值 上面已经赋值，不进行处理
              //out.print("$('#"+QryServMCArrQuality[i][1]+"').val('"+QryServMCArrQuality[i][3]+"');");
            }
          }
          String insertArr[]  = insertStr.split("\\|");
          if(insertArr.length>0){
           if((insertArr.length)%tdVal==0){ //获取行数 每行13条数据
              
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
     * 走端到端时，ML-本地MAS进行特殊处理。
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
                    rdShowMessageDialog("错误代码:<%=sGrpBizQryCode%>,错误信息:<%=sGrpBizQryMsg%>",0);
                    removeCurrentTab();
                <%
            }
        }catch(Exception e){
            e.printStackTrace();
            System.out.println("# return from f3690_1.jsp -> Call Service sGrpBizQry Failed!");
            %>
                rdShowMessageDialog("调用服务sGrpBizQry失败！",0);
                removeCurrentTab();
            <%
        }
    }
%>
    <%if("ML".equals(sm_code) || ("AD".equals(sm_code) && "opcode".equals(openLabel))){%>
        if("<%=billingtype%>" == "00" || "<%=billingtype%>" == "01")//如果免费或包月
    	{
    		document.all.tr_gongnengfee.style.display = "none";
    	}
    	else if("<%=billingtype%>" == "02")//如果按次
    	{
    		document.all.tr_gongnengfee.style.display = "block";
    	}
    <%}%>
    
    <%
    if("hl".equals(sm_code))
    {%>
     	$("#bizTypeLFlag2").attr("disabled",true); 
		$("#F10634").width('200px');
		if ( $("#F10634").val()=="本地市" )
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
     * 端到端流程：
     *      ML:展示biz_code,sm_code不可编辑；产品可选；业务大小类不展示。
     *      AD:展示biz_code,sm_code,产品不可编辑；默认展示下一步之后内容。
     *      其他品牌:展示sm_code,产品不可编辑；默认展示下一步之后内容。
     * 动力100流程：
     *      DL:展示sm_code,产品不可编辑。
     *      AD/ML:同端到端ML。
     *      其他品牌：sm_code不可编辑；其他如大类小类、业务代码等正常展示。
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
            $("#10634").attr("disabled","true");//业务范围不可改
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
         * “下一步”后，大类小类不展示。
         * AD、ML时，展示业务代码；其他品牌不展示。
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
    
    /*begin add 对下拉列表中的空值进行处理 for 在CRM系统增加“营销区域”字段的需求@2015/4/22 */
    if(typeof($("#F10818")) != "undefined"){
			$("#F10818 option").each(function(){
	      if($(this).val() == ""){
	      	$(this).remove();
	      }
	    });
		}
		/*end add 对下拉列表中的空值进行处理 for 在CRM系统增加“营销区域”字段的需求@2015/4/22 */
		
		/*关于申请制作集团客户信息化项目(产品)投资和收益自动化匹配报表的函
		 * liangyl 2016-07-11
		 * F10985
		 */
		if (typeof ($("#F10985").val())!="undefined" ){
			$("#F10985").parent().append("&nbsp;<input type='button' class='b_text' value='校验' onclick='ajax_check_F10985()' />"); 
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
    		//yuanqs add 2010/9/6 9:42:51 区分是刷新还是关闭
    		isRefresh = false;
        if (parseInt(retCode) == 0)
        {
            //alert(packet.data.findValueByName("grpFlag"));
            //alert(packet.data.findValueByName("iCount"));
            if (packet.data.findValueByName("grpFlag")=="Y")
            if (packet.data.findValueByName("iCount")=="0")
            {
                rdShowMessageDialog("请先录入集团合同");
                return false;
            }
            frm.action="f3690_1.jsp?action=select";
            frm.method="post";
            frm.submit();
        }
        else
        {
            rdShowMessageDialog("错误代码：" + retCode + "<br>错误信息：" + retMessage,0);
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
            rdShowMessageDialog("没有得到用户ID,请重新获取！");
            return false;
        }
        //得到集团用户编号的时候，得到集团代码
        //getGrpId();
    }
    if(retType == "GrpId") //得到集团代码
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
    if(retType == "GrpNo") //得到集团用户编号
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
    if(retType == "GrpCustInfo") //用户开户时客户信息查询
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
    if(retType == "AccountId") //得到帐户ID
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
            rdShowMessageDialog("没有得到帐户ID,请重新获取！");
        }
    }
    //---------------------------------------
    if(retType == "UnitInfo")
    {
        //集团信息查询
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
     if(retType == "CheckMng_user") //管理员帐户校验
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
          rdShowMessageDialog("管理员账户校验成功",2);
          document.frm.sure.disabled = false;
          //document.frm.sure2.disabled = false; 
        }
     } 
     //---------------------------------------
     if(retType == "checkPwd") //集团客户密码校验
     {
        if(retCode == "000000")
        {
            var retResult = packet.data.findValueByName("retResult");
            if (retResult == "false") {
    	    	rdShowMessageDialog("客户密码校验失败，请重新输入！",0);
	        	frm.custPwd.value = "";
	        	frm.custPwd.focus();
    	    	return false;	        	
            } else {
                rdShowMessageDialog("客户密码校验成功！",2);
                if(<%=nextFlag%>==1){
                	document.frm.next.disabled = false;
                }
                
            }
         }
        else
        {
            rdShowMessageDialog("客户密码校验出错，请重新校验！",0);
    		return false;
        }
     }	

     //---------------------------------------

    //zhouby 设置select标签
    if(retType == "getProdDirect")
    {
        if(retCode == "000000")
        {
			var backString = packet.data.findValueByName("backString");
         	var temLength = backString.length+1;
			var arr = new Array(temLength);
			var v_prod_direct = "<%=i_prod_direct%>";
			var label = "";
			/* add by qidp @ 2009-11-06 for [增加“请选择”] */
			arr[0] = "<OPTION value='' pvalue=''>---- 请选择 ----</OPTION>";
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
            rdShowMessageDialog("没有得到集团产品类型,请重新获取！");
			return false;
        }
		
    }
    
    if(retType=="getBillingType")//得到sbillspcode中的 billingtype luxc add 20070916
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
        		$(document.all.F00006).removeClass("InputGrey");//移除F00006上的“InputGrey”样式//add by qidp
        		showTip(document.all.F00006,"提醒您修改短信服务号码");
        	<%}else{%>
        	    document.all.telNo.value=baseservcode;
        	<%}%>
    		<%if("opcode".equals(openLabel) || "ML".equals(sm_code)){%>
        		if(billingtype == "00" || billingtype == "01")//如果免费或包月
        		{
        			document.all.tr_gongnengfee.style.display = "none";
        		}
        		else if(billingtype == "02")//如果按次
        		{
        			document.all.tr_gongnengfee.style.display = "block";
        		}
        		else
        		{
        			rdShowMessageDialog("查询sbillspcode,billingtype出错="+billingtype,0);
        		}
        	<%}%>
    	}
    	else
    	{
    		rdShowMessageDialog(retMessage);
    	}
    }
    //---------------------------------------
     if(retType == "checkPhonePwd") //付费号码密码校验
     {
        if(retCode == "000000")
        {
            var retResult = packet.data.findValueByName("retResult");
            if (retResult == "false") {
    	    	rdShowMessageDialog("付费号码密码不符，请重新输入！",0);
	        	frm.F10334.value = "";
	        	frm.F10334.focus();
    	    	return false;	        	
            } else {
                rdShowMessageDialog("付费号码密码校验成功！",2);
                frm.chkPass2.disabled = true;
                frm.F10333.readonly = true;
            }
         }
        else
        {
            rdShowMessageDialog("付费号码密码校验出错，请重新校验！",0);
    		return false;
        }
     }	
     
	//取流水
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
            rdShowMessageDialog("查询流水出错,请重新获取！",0);
			return false;
        }
    }
	if(retType == "getCheckInfo")
	{   //得到支票信息
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
                rdShowMessageDialog("该支票的帐户余额为0！");
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
	{   //得到客户地址 
        if(retCode == "0")
        {
            var custAddress = packet.data.findValueByName("custAddress");
            if (custAddress == "false") {
    	    	rdShowMessageDialog("获取客户地址失败！",0);
    	    	return false;	        	
            } else {
                document.frm.cust_address.value = custAddress;
            }
         }
        else
        {
            rdShowMessageDialog("获取客户地址失败，请重新获取！",0);
    		return false;
        }
	}
	if(retType == "query_channelid")/////////////
	{   //得到query_channelid
        if(retCode == "0")
        {
            var channel_name = packet.data.findValueByName("channel_name");
			var channel_id = packet.data.findValueByName("channel_id");
			//alert(channel_id);
            if (channel_id == "false") {
    	    	rdShowMessageDialog("获取channelid失败！",0);
    	    	return false;	        	
            } else {
                document.frm.channel_id.value = channel_id;
            }
         }
        else
        {
            rdShowMessageDialog("获取channelid失败，请重新获取！",0);
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
    		//arr[0] = "<option value=''>--- 请选择 ---</option>";
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
    		  	if(fwpp=="227"&&backString[i][0]=="09")//端到端跳转后，数据大类 新增 本地数据专线
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
    			$("<option value=''>--- 请选择 ---</option>").appendTo("#bizTypeL");
    		<%
    		}
    		%>
          	$(arr.join("")).appendTo("#bizTypeL");
          	
          	$("#bizTypeS").empty();
          	$("<option value=''>--- 请选择 ---</option>").appendTo("#bizTypeS");
    	}
        else
        {
            rdShowMessageDialog("获取业务大类失败[错误代码："+retCode+",错误信息："+retMessage+"]",0);
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
            rdShowMessageDialog("获取业务大类失败[错误代码："+retCode+",错误信息："+retMessage+"]",0);
    		return false;
        }
	}
}

function showPrtDlg(printType,DlgMessage,submitCfm){
      var h=180;
			var w=350;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			
			var pType="subprint";             				 		//打印类型：print 打印 subprint 合并打印
			var billType="1";              				 			  //票价类型：1电子免填单、2发票、3收据
			var sysAccept = document.frm.login_accept.value;       //流水号
			var mode_code=null;           							  //资费代码
			var fav_code=null;                				 		//特服代码
			var area_code=null;             				 		  //小区代码
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
        vPayTypeTxt = "现金";
    }else{
        vPayTypeTxt = "支票";
    }
	
		/*2014/08/25 15:36:34 gaopeng 大庆分公司关于电子工单应用相关问题及建议的反馈 
			将最老版的免填单打印改造为电子免填单
		*/
		/*最后返回的字符串*/
		var retInfo = "";
		/*用户信息区*/
		var cust_info="";
		/*操作业务信息区*/
		var opr_info="";
		/*备注信息区*/
		var note_info1="";
		var note_info2="";
		var note_info3="";
		var note_info4="";
		
		cust_info += "客户姓名：   "+ $("#cust_name").val() +"|";
		cust_info += "证件号码：   "+ document.frm.iccid.value +"|";
		cust_info += "集团客户编码：   "+ document.frm.grp_id.value +"|";
		
	
    
    opr_info += "付款方式：   "+ vPayTypeTxt +"|";
    opr_info += "付费账号：   "+ document.frm.account_id.value +"|";
    
    opr_info += "申请业务：   "+ "集团产品开户" +"|";
    opr_info += "操作流水：   "+ document.frm.login_accept.value +"|";
    opr_info += "申请产品：   "+ document.frm.product_name.value +"|";
		
		if($("#sm_code").val()=="IC"){
					opr_info += "属性信息：|"
			    opr_info += "        ICT业务集成费 "+$("#F10980").val()+"元|";
    			opr_info += "        ICT教育信息化集成费 "+$("#F10981").val()+"元|";
		}
		//云视频会议增加查询注意事项库 hejwa  2015年9月16日16:59:32
	  if($("#sm_code").val()=="SH"){
	  	var product_code = document.all.F00017.value;
			var chPos = product_code.indexOf("|");
			product_code = product_code.substring(0,chPos);
	  	ajax_get_main_note(product_code);
	  	opr_info+="资费说明："+main_note+"|";
	  }
	  
	  
		note_info1 += "系统备注： "+ document.frm.sysnote.value +"|";
		note_info1 += "用户备注： "+ document.frm.tonote.value +"|";
		
		retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
		retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
		return retInfo;	
		
	}   

function ajax_get_main_note(product_code){
	    var packet = new AJAXPacket("ajax_get_main_note.jsp","请稍后...");
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
	
	showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes");
		//hejwa add 关于上报集团客户部2014年2月第一期系统需求的函-1-优化集团专线端到端信息支撑系统部分功能  2014年3月12日15:22:27
		//多次提示麻烦，用变量的方式设置提示词
		var hitMessage = "";
		if($("#sm_code").val()=="hl"){
			hitMessage = "请确认选择的资费为单条资费非项目资费！";
		}else{
			hitMessage = "是否提交本次操作？";
		}
confirmFlag = rdShowConfirmDialog(hitMessage);

	if (confirmFlag==1){
		    //不打印需要的相应操作
			spellList();
			/* begin for 关于在专线开户界面增加统谈专线项目填写元素的函@2014/11/24 */
			if(typeof($("[name=F10774]:checkbox")) != "undefined"){
				var checks = "";
				$("input[name='F10774']").each(function(){
					if($(this).attr("checked") == true){
						checks += $(this).val() + ","; //动态拼取选中的checkbox的值，用“,”符号分隔
					}
				});
				if(checks.length>0){
					checks= checks.substr(0,checks.length-1);
				}
				$("input[name='F10774']").val(checks);
			}
			/* end for 关于在专线开户界面增加统谈专线项目填写元素的函@2014/11/24 */
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
		var checkPwd_Packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s3690/pubCheckPwd.jsp","正在进行密码校验，请稍候......");
		checkPwd_Packet.data.add("retType","checkPwd");
		checkPwd_Packet.data.add("cust_id",cust_id);
		checkPwd_Packet.data.add("Pwd1",Pwd1);
		core.ajax.sendPacket(checkPwd_Packet);
		checkPwd_Packet = null;
}

function check_mnguser()//验证管理员帐户
{    
	 if(((document.frm.F10303.value).trim()) == "")
    {
        rdShowMessageDialog("管理员用户不能为空！");
        return false;
    } 
    var checkPwd_Packet = new AJAXPacket("CheckMng_user.jsp","正在进行密码校验，请稍候......");
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

	//query_custaddress();//得到客户地址
	//得到帐户ID
	  var getAccountId_Packet = new AJAXPacket("../s3690/f1100_getId.jsp","正在获得帐户ID，请稍候......");
	getAccountId_Packet.data.add("region_code","<%=regionCode%>");
	getAccountId_Packet.data.add("retType","AccountId");
	getAccountId_Packet.data.add("idType","1");
	getAccountId_Packet.data.add("oldId","0");
	core.ajax.sendPacket(getAccountId_Packet); 
	getAccountId_Packet = null;

}

//得到集团用户编号user_no
function getGrpUserNo()
{
    var sm_code = document.frm.sm_code.value;

    //首先判断是否已经选择了服务品牌
    if(document.frm.sm_code.value == "")
    {
        rdShowMessageDialog("请首先选择集团信息化产品！",0);
        return false;
    }

    var getgrp_Userno_Packet = new AJAXPacket("getGrpUserno.jsp","正在获得集团产品编号，请稍候......");
    getgrp_Userno_Packet.data.add("retType","GrpNo");
    getgrp_Userno_Packet.data.add("orgCode","<%=org_code%>");
    getgrp_Userno_Packet.data.add("smCode",sm_code);
    core.ajax.sendPacket(getgrp_Userno_Packet);
    getgrp_Userno_Packet = null;
}
//校验付费号码的密码
function check_PayPwd()
{
    var payno = document.all.F10333.value;
    var Pwd1 = document.all.F10334.value;
    var checkPwd_Packet = new AJAXPacket("pubCheckPwd2.jsp","正在进行付费号码密码校验，请稍候......");
    checkPwd_Packet.data.add("retType","checkPhonePwd");
	checkPwd_Packet.data.add("phone_no",payno);
	checkPwd_Packet.data.add("Pwd1",Pwd1);
	core.ajax.sendPacket(checkPwd_Packet);
	checkPwd_Packet = null;		
}

function getGrpId()
{
    //得到智能网集团用户代码
    var getgrp_no_Packet = new AJAXPacket("../s3690/getGrpId.jsp","正在获得集团代码，请稍候......");
    getgrp_no_Packet.data.add("retType","GrpId");
    getgrp_no_Packet.data.add("orgCode","<%=org_code%>");
    core.ajax.sendPacket(getgrp_no_Packet);
    getgrp_no_Packet=null;
}

function getUserId()
{
    //得到集团用户ID，和个人用户ID一致
    var getUserId_Packet = new AJAXPacket("../s3690/f1100_getId.jsp","正在获得用户ID，请稍候......");
	getUserId_Packet.data.add("region_code","<%=regionCode%>");
	getUserId_Packet.data.add("retType","UserId");
	getUserId_Packet.data.add("idType","1");
	getUserId_Packet.data.add("oldId","0");
	core.ajax.sendPacket(getUserId_Packet);
	getUserId_Packet = null;
}
 //下一步
function nextStep()
{
    // zhouby add for 黑龙江移动iNG ESOP v2.0.02(三期)页面改造内容  2013-11-28
    if (!validateCallCenter()){
        return false;
    }
    
    /*begin diling add for 品牌，业务大类，业务小类@2012/6/21 */
    var v_smCode = $("#sm_code").val();  
    var v_bizTypeL= $("#bizTypeL").val();
    var v_bizTypeS = $("#bizTypeS").val();
    $("#smCodeHidden").val(v_smCode);
    $("#bizTypeLHidden").val(v_bizTypeL);
    $("#bizTypeSHidden").val(v_bizTypeS);
    /*end diling add @2012/6/21 */
    
    /*begin diling add for 当选择服务品牌为集团专线，业务大类为“数据专线”时，判断是否已填写相关内容@2012/12/6*/
    var v_A_prodUnitId = $("#A_prodUnitId").val();
    var v_A_prodIccid = $("#A_prodIccid").val();
    var v_AProd_grpIdNoHidden = $("#AProd_grpIdNoHidden").val();
    var v_chkAproInfoFlag = $("#chkAproInfoFlag").val();
    if("From4091"!="<%=inOpenFlag%>"&&"DL100"!="<%=inOpenFlag%>"){//直接开户的时候
      if($("#sm_code").val()=="hl"&&$("#bizTypeL").val()=="02"){//关于齐齐哈尔分公司申请集团专线3690产品开户权限的请示@2013/4/2 （去掉齐齐哈尔这部分限制@2013/4/11）
        if(v_A_prodUnitId==""&&v_A_prodIccid==""){
          rdShowMessageDialog("请填写A端产品集团编号，或者A端产品证件号码！",0);
          $("#A_prodUnitId").focus();
          return false;
        }
        if(v_AProd_grpIdNoHidden==""){
          rdShowMessageDialog("请对A端集团产品ID内容进行校验！",0);
          $("#AProd_grpIdNoHidden").focus();
          return false;
        }
        if(v_chkAproInfoFlag=="N"){
          rdShowMessageDialog("请对A端集团产品ID内容进行校验！",0);
          return false;
        }
      }
      /*2016/6/30 14:41:28 gaopeng 修改去掉02判断*/
      else if($("#sm_code").val()=="hl"&&$("#bizTypeL").val()!="02"){//关于齐齐哈尔分公司申请集团专线3690产品开户权限的请示@2013/4/2 （去掉齐齐哈尔这部分限制@2013/4/11）
        rdShowMessageDialog("该类专线业务请到端到端办理！",0);
        return false;
      }
    }

    /*end diling add @2012/12/6 */
    var vGrpProduct = $("#F00017").val();
    if(vGrpProduct == ''){
        rdShowMessageDialog("请选择集团产品！",0);
        $("#ProdQuery2").focus();
        return false;
    }
    
    var checkContract = new AJAXPacket("f3500_checkContract.jsp","正在检查用户信息，请稍候......");
	checkContract.data.add("retType","checkContract");
	checkContract.data.add("sm_code",document.all.sm_code.value);
	checkContract.data.add("cust_id",document.all.cust_id.value);
	core.ajax.sendPacket(checkContract);
	checkContract = null;


}
//上一步
function previouStep(){
	frm.action="f3690_1.jsp";
	frm.method="post";
	frm.submit();
}
//查询客户地址
function query_custaddress()
{
	if(document.frm.cust_id.value == "")
	{
		return false;
	}

    var getInfoPacket = new AJAXPacket("s3500_custaddress.jsp","正在查询客户地址，请稍候......");
	getInfoPacket.data.add("retType","custaddress");
	getInfoPacket.data.add("cust_id",document.frm.cust_id.value);
	core.ajax.sendPacket(getInfoPacket);
	getInfoPacket = null;
}
//查询channel_id
function query_channelid()
{
    var getInfoPacket = new AJAXPacket("s3500_channelid.jsp","正在查询，请稍候......");
	getInfoPacket.data.add("retType","query_channelid");
	getInfoPacket.data.add("org_code","<%=org_code%>");
	getInfoPacket.data.add("town_code",document.frm.town_code.value);
	core.ajax.sendPacket(getInfoPacket);
	getInfoPacket=null;
}
//调用公共界面，进行集团帐户选择
function getInfo_Acct()
{
    var pageTitle = "集团帐户选择";
    var fieldName = "集团产品ID|集团产品名称|产品名称|集团帐号|";
	var sqlStr = "";
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "4|0|1|2|3|";
    var retToField = "tmp1|tmp2|tmp3|account_id|"; //这里只需要返回帐号
    var cust_id = document.frm.cust_id.value;

    if(document.frm.cust_id.value == "")
    {
        rdShowMessageDialog("请先选择集团客户，才能进行集团帐户查询！");
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

//调用公共界面，进行集团客户选择
function getInfo_Cust()
{
    var pageTitle = "集团客户选择";

    var fieldName = "证件号码|客户ID|客户名称|集团ID|集团名称|归属地|归属组织|";
	var sqlStr = "";
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "7|0|1|2|3|4|5|6|";
    var retToField = "iccid|cust_id|cust_name|unit_id|unit_name|belong_code|group_id|";
    /**add by liwd 20081127,group_id来自dcustDoc的group_id end **/
    var cust_id = document.frm.cust_id.value;

    if(document.frm.iccid.value == "" &&
        document.frm.cust_id.value == "" &&
        document.frm.unit_id.value == "")
    {
        rdShowMessageDialog("请输入证件号码、客户ID或集团ID进行查询！");
        document.frm.iccid.focus();
        return false;
    }

    if(document.frm.cust_id.value != "" && forNonNegInt(frm.cust_id) == false)
    {
    	frm.cust_id.value = "";
        rdShowMessageDialog("必须是数字！");
    	return false;
    }

    if(document.frm.unit_id.value != "" && forNonNegInt(frm.unit_id) == false)
    {
    	frm.unit_id.value = "";
        rdShowMessageDialog("必须是数字！");
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
    /*add by liwd 20081127,group_id来自dcustDoc的group_id
    **var retToField = "iccid|cust_id|cust_name|unit_id|unit_name|belong_code|";;
    **/
    var retToField = "iccid|cust_id|cust_name|unit_id|unit_name|belong_code|group_id|";
    /**add by liwd 20081127,group_id来自dcustDoc的group_id end **/
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

//根据客户ID查询客户信息
function getInfo_CustId()
{
    var cust_id = document.frm.cust_id.value;

    //根据客户ID得到相关信息
    if(document.frm.cust_id.value == "")
    {
        rdShowMessageDialog("请输入客户ID！");
        return false;
    }
    if(for0_9(frm.cust_id) == false)
    {
    	frm.cust_id.value = "";
        rdShowMessageDialog("客户ID必须是数字！");
    	return false;
    }

    var getInfoPacket = new AJAXPacket("f1902_Infoqry.jsp","正在获得集团客户信息，请稍候......");
    var cust_id = document.frm.cust_id.value;
    getInfoPacket.data.add("region_code","<%=regionCode%>");
    getInfoPacket.data.add("retType","GrpCustInfo");
    getInfoPacket.data.add("cust_id",cust_id);
    core.ajax.sendPacket(getInfoPacket);
    getInfoPacket=null;
}

//根据客户ID查询客户信息
function getInfo_UnitId()
{
    var cust_id = document.frm.cust_id.value;
    var unit_id = document.frm.unit_id.value;

    //根据客户ID得到相关信息
    if(document.frm.cust_id.value == "")
    {
        rdShowMessageDialog("请首先输入集团客户ID！");
        return false;
    }
    if(for0_9(frm.cust_id) == false)
    {
    	frm.cust_id.value = "";
        rdShowMessageDialog("集团客户ID必须是数字！");
    	return false;
    }
    if(document.frm.unit_id.value == "")
    {
        rdShowMessageDialog("请首先输入集团ID！");
        return false;
    }
    if(for0_9(frm.unit_id) == false)
    {
    	frm.unit_id.value = "";
        rdShowMessageDialog("集团ID必须是数字！");
    	return false;
    }

    var getInfoPacket = new AJAXPacket("f1902_Infoqry.jsp","正在获得集团客户信息，请稍候......");
    var cust_id = document.frm.cust_id.value;
    getInfoPacket.data.add("region_code","<%=regionCode%>");
    getInfoPacket.data.add("retType","UnitInfo");
    getInfoPacket.data.add("cust_id",cust_id);
    getInfoPacket.data.add("unit_id",unit_id);
    core.ajax.sendPacket(getInfoPacket);
    getInfoPacket=null;
}


//调用公共界面，进行产品属性选择
function getInfo_ProdAttr(defFlag)
{
    var pageTitle = "产品属性选择";
    var fieldName = "产品属性代码|产品属性|";
		var sqlStr = "";
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "1|0|";
    var retToField = "product_attr|";

    //首先判断是否已经选择了服务品牌
    if(document.frm.sm_code.value == "")
    {
        rdShowMessageDialog("请首先选择集团信息化产品！");
        return false;
    }

    if(PubSimpSelProdAttr(pageTitle,fieldName,sqlStr,selType,retQuence,retToField, defFlag));
}

//查询支票号码
function getBankCode()
{
    if((frm.checkNo.value).trim() == "")
    {
        rdShowMessageDialog("请输入支票号码！");
        frm.checkNo.focus();
        return false;
    }
    var getCheckInfo_Packet = new AJAXPacket("getBankCode.jsp","正在获得支票相关信息，请稍候......");
    getCheckInfo_Packet.data.add("retType","getCheckInfo");
    getCheckInfo_Packet.data.add("checkNo",document.frm.checkNo.value);
    core.ajax.sendPacket(getCheckInfo_Packet);
    getCheckInfo_Packet = null;     
}

function getSi()
{ 
    if((frm.FPAYSI.value).trim() == "")
    {
        rdShowMessageDialog("请输入结算Si！");
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
    var pageTitle = "渠道商查询";
    var fieldName = "渠道商代码|渠道商名称|";
		var sqlStr="";
    if(document.all.town_code.value != "")
    {
        sqlStr = "90000158";
    }else{
    		sqlStr = "90000157";
    }
    
    params = ""+document.all.OrgCode.value+"|"+document.all.OrgCode.value+"|"+document.all.town_code.value+"";
    var selType = "S";    //'S'单选；'M'多选
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
	//查询channel_id
	query_channelid();

}

//调用公共界面，进行产品信息选择 - 其他产品
function getInfo_Prod()
{
    var pageTitle = "集团产品选择";
    var fieldName = "产品代码|产品名称|是否允许议价|";
	var sqlStr = "";
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "2|0|1|";
    var retToField = "product_code|product_name|";

    //首先判断是否已经选择了服务品牌
    if(document.frm.sm_code.value == "")
    {
        rdShowMessageDialog("请首先选择集团信息化产品！");
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

/*diling add for 查询集团“数据专线”产品 @2012/12/6 */
function getInfo_AProdInfo(){
  document.all.qryFlag.value="qryCust";
  var pageTitle = "集团客户选择";
  var fieldName = "证件号码|客户ID|客户名称|用户ID|用户编号 |用户名称|产品代码|产品名称|集团编号|付费帐户|品牌名称|品牌代码|";
  var sqlStr = "";
  var selType = "S";    //'S'单选；'M'多选
  var retQuence = "12|0|1|2|3|4|5|6|7|8|9|10|11|";
  //var retToField = "iccid|cust_id|cust_name|grpIdNo|user_no|grp_name|product_code2|product_name2|unit_id|account_id|sm_name|sm_code|";
  var retToField = "AProd_iccidHidden|AProd_cust_idHidden|AProd_cust_nameHidden|AProd_grpIdNoHidden|AProd_user_noHidden|AProd_grp_nameHidden|AProd_product_code2Hidden|AProd_product_name2Hidden|AProd_unit_idHidden|AProd_account_idHidden|AProd_sm_nameHidden|AProd_sm_codeHidden|";
                   
  var cust_id = document.frm.cust_id.value;
  
  var v_A_prodUnitId = $("#A_prodUnitId").val();
  var v_A_prodIccid = $("#A_prodIccid").val();
  if(v_A_prodUnitId==""&&v_A_prodIccid==""){
    rdShowMessageDialog("请输入A端产品集团编号，或者A端产品证件号码进行查询！",0);
    $("#v_A_prodUnitId").focus();
    return false;
  }
  
  if(document.frm.unit_id.value != "" && forNonNegInt(frm.unit_id) == false)
  {
  	frm.unit_id.value = "";
      rdShowMessageDialog("必须是数字！",0);
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

//校验 A端产品编码 
function chkInfo_AProdCode(){
	
  var custId = $("#cust_id").val();
  var AProd_grpIdNoHidden = $("#AProd_grpIdNoHidden").val();
  var packet = new AJAXPacket("f3690_ajax_chkInfo_AProdCode.jsp","正在获得数据，请稍候......");
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
		$("#chkAproInfoFlag").val("Y");//校验标识 通过Y 未通过或未校验为N
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
		   var insertStr1 = "<tr><td colspan='21'>无查询结果！</td></tr>";
		   $("#terminal").append(insertStr1);
		 }
	}else{
		rdShowMessageDialog("错误代码："+retCode_chkProdCode+"<br>错误信息："+retMsg_chkProdCode,0);
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
		   //获取哪些内容需要置灰
       chkInfoDisable();
		 }else{
		   var insertStr1 = "<tr><td colspan='21'>无查询结果！</td></tr>";
		   $("#terminal").append(insertStr1);
		 }
         var terminalTr = $("#terminal tr:has(td)").length;
         for(var ii=0;ii<terminalTr;ii++){
           if(ii + 1 != terminalTr){
             $("input[name^='addSegment']").click();//AZ端属性 中新增行数，和上方A端属性 结果保持一致
           }
           $("#terminal tr:has(td):eq("+ii+")").children().each(function(i,n){
            if($(this).text()!="无查询结果！"){//当上方A端属性为有值时，才给下方赋值
              var v_id = "F"+$(this).attr("v_id");//上面循环展示的id值
              //根据表中配置的类型，将上方展示的 AZ端集团 属性值和下方进行统一
              //目前只对 下拉列表 和 文本框 进行了对应限制
              /** 处理下拉列表 **/
              var optionLength = $("#segMentTab1 tr:eq("+(ii+2)+")").find("select").length;//有几个下拉列表
              if(optionLength>0){//有下拉列表
                for(var j=0;j<optionLength;j++){
                  var obj = $("#segMentTab1 tr:eq("+(ii+2)+")").find("select:eq("+j+")");//下拉列表的id值：obj.attr("id")
                  if(v_id==obj.attr("id")){
                    obj.val($(this).text()); 
                  }
                }
              }
              /** 处理文本框 **/
              var textLength = $("#segMentTab1 tr:eq("+(ii+2)+")").find("input[type='text']").length;
              if(textLength>0){
                for(var z=0;z<textLength;z++){
                  var obj = $("#segMentTab1 tr:eq("+(ii+2)+")").find("input[type='text']:eq("+z+")");//文本框的id值：obj.attr("id")
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
		rdShowMessageDialog("错误代码："+retCode_getAProdPoperty+"<br>错误信息："+retMsg_getAProdPoperty,0);
		window.location.href="f3690_1.jsp";
	}
}


$(document).ready(function (){
	var fwpp2 = "<%=catalog_item_id%>";
	var inOpenFlag = "<%=inOpenFlag%>";
	//alert("119 标志位 fwpp2=["+fwpp2+"]"+"\n端到端标志位 inOpenFlag=["+inOpenFlag+"]");
	if(fwpp2=="119"&&inOpenFlag!="From4091"){
		$("#segMentTab1 tr:gt(0)").each(function(){
			
				if($(this).find("td:last").find("input").html()!=null){
				
					$(this).find("td:last").find("input").attr("readOnly","readOnly");
					$(this).find("td:last").find("input").addClass("InputGrey");
					
					if($(this).find("td:last").find("input").val().trim()==""){
							rdShowMessageDialog("请到3691设置对应的“A端结算比例”后在进行Z端开户！");	
							removeCurrentTab();
					}
				}
				
		});
	}
	
	
});


function chkInfoDisable(){
  var v_sm_code = $("#sm_code").val();
  var packet = new AJAXPacket("f3690_ajax_chkInfoDisable.jsp","正在获得数据，请稍候......");
	packet.data.add("v_sm_code",v_sm_code);
	core.ajax.sendPacket(packet,doChkInfoDisable);
	packet = null;
}

function doChkInfoDisable(packet){
  var retCode = packet.data.findValueByName("retCode");
  var retMsg =  packet.data.findValueByName("retMsg");
  var nameIdArr =  packet.data.findValueByName("nameIdArr");
  var nameTypeArr =  packet.data.findValueByName("nameTypeArr"); //类型
  //alert(nameIdArr.length+"-----"+nameTypeArr.length+"---"+nameIdArr[0]);
  if("000000"==retCode && nameIdArr.length>0){
    for(var i=0;i<nameIdArr.length;i++){
      //alert(nameTypeArr[i]);
      if("01"==nameTypeArr[i]){//01:文本框
        if(document.all(nameIdArr[i])!=null){
          document.all(nameIdArr[i]).readOnly=true;
          $(document.all(nameIdArr[i])).addClass("InputGrey");
        }
        //专线条数可修改
        $("#F10019").removeAttr("readOnly");
        $("#F10019").removeClass("InputGrey");
      }else if("02"==nameTypeArr[i]){//02:下拉框
        if(document.all(nameIdArr[i])!=null){
          document.all(nameIdArr[i]).disabled=true;
          //disableStr = disableStr + nameIdArr[i] + "|";
          //alert(disableStr);
        }
      }else if("03"==nameTypeArr[i]){//03:按钮
        if(document.all(nameIdArr[i])!=null){
          document.all(nameIdArr[i]).disabled=true;
        }
      }
    }
  }
}

//展示议价信息
function getInfo_disPriceMsg_detail(){
  var prodCode = $("#ret_prodCode").val();//产品号码
  var cust_id = $("#cust_id").val();//集团客户ID
  var path = "<%=request.getContextPath()%>/npage/s3690/getInfo_disPriceMsg_detail.jsp?prodCode="+prodCode+"&cust_id="+cust_id;
    window.open(path,'_blank','height=450,width=800,scrollbars=yes');
}

/*diling add @2012/12/6 */

//调用公共界面，进行产品信息选择 - ADC/MAS产品 ---普通产品也使用此项选择
function getInfo_Prod2()
{
    //首先判断是否已经选择了服务品牌
 
    var vSmCode = document.frm.sm_code.value;
    if(vSmCode == "")
    {
        rdShowMessageDialog("请首先选择服务品牌！",0);
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
                rdShowMessageDialog("大类小类、业务代码不能同时为空！",0);
                return false;
            }
            if(vBizTypeL == ""){
                rdShowMessageDialog("请选择业务大类！",0);
                $("#bizTypeL").focus();
                return false;
            }
            if(vBizTypeS == ""){
                rdShowMessageDialog("请选择业务小类！",0);
                $("#bizTypeS").focus();
                return false;
            }
        }
    }else if(vBizLevel == "3"){
        if(vBizTypeL == ""){
            rdShowMessageDialog("请选择业务大类！",0);
            $("#bizTypeL").focus();
            return false;
        }
        if(vBizTypeS == ""){
            rdShowMessageDialog("请选择业务小类！",0);
            $("#bizTypeS").focus();
            return false;
        }
    }else if(vBizLevel == "2"){
        if(vBizTypeL == ""){
            rdShowMessageDialog("请选择业务大类！",0);
            $("#bizTypeL").focus();
            return false;
        }
    }
    
    var pageTitle = "集团产品选择";
    var fieldName = "";
    var retQuence = "";
    var retToField = "";
    
    if(vSmCode == "ML" || vSmCode == "AD"){
        fieldName = "产品代码|产品名称|是否允许议价|业务代码|业务名称|";
        retQuence = "6|3|4|13|15|16|17|";
        retToField = "F00017|product_name|chg_price|bizCode|F00018|catalog_item_id|";
    }else{
        fieldName = "产品代码|产品名称|是否允许议价|";
        retQuence = "4|3|4|13|17|";
        retToField = "F00017|product_name|chg_price|catalog_item_id|";
    }
	var sqlStr = "";
    var selType = "S";    //'S'单选；'M'多选

    if(PubSimpSelProd(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));
   
    /* add by liubo */
    /* modify by qidp
    var temp1=document.all.ProdType.value ;    //[S][]  //产品类型
    var temp2=document.all.sm_code.value ;    //[T][]  //品牌  
    var temp3=""; 
    if(document.all.prod_direct!=undefined){  
         temp3=document.all.prod_direct.value ;    //[V][]  //业务类型
    }
     
    var temp4=document.all.biz_code.value ;    //[W][]  //业务代码
    var targeturl="newTree.jsp?ProdType="+temp1+"&sm_code="+temp2+"&prod_direct="+temp3+"&biz_code="+temp4;
    window.open(targeturl,'_blank','height=500,width=600,scrollbars=yes'); 
    	*/
    	
    	
    	
    //if(getBillingType(document.all.bizCode.value));
    //F00017|product_name|bizCode|F00018|
    /*
    var temp1=document.all.ProdType.value ;    //[S][]  //产品类型
    var temp2=document.all.sm_code.value ;    //[T][]  //品牌  
    var temp3=""; 
    if(document.all.prod_direct!=undefined){  
         temp3=document.all.prod_direct.value ;    //[V][]  //业务类型
    }
    */
    /* add by qidp for [AD,ML时,对业务类型校验] */
    /*
    if(temp2 == "AD" || temp2 == "ML"){
        if($("#biz_code").val() == "" && temp3 == ""){
            rdShowMessageDialog("请您选择业务类型！",0);
            $("#prod_direct").focus();
            return false;
        }
    }
    */
    /* end of add */
    /*
    var temp4=document.all.biz_code.value ;    //[W][]  //业务代码
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
	path = path + "&catalog_item_id=" + $("#catalog_item_id").val();/*diling add 增加业务大类参数*/
	path = path + "&openLabel=<%=openLabel%>" ;/*diling add 增加参数 link  ：走端到端流程通过任务控制进入此订购模块；*/
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
/*处理ADC类业务的计费类型*/
$(document).ready(function(){
	
	
	/*2016/6/24 10:52:09 gaopeng 
		 关于5月下旬集团客户部CRM、BOSS和经分系统需求的函-1-关于在专线开户时增加配合地市和结算比例相关信息的需求
		 3690 属性 10984 A端结算比例 可以修改
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
			//界面判断如果服务输出属性代码为10957时，需要在属性名称后面增加红色提醒字体
			$(this).find('#F10957').parent().prev().html("话费红包限时赠送<font class='orange'>(9:00-11:00)</font>");
			
			/*获取权限a325*/
			if("<%=have_a325%>" == "true"){
				$(this).find('#F10957').empty();
				$(this).find('#F10957').append("<option selected value='1' selected >1--开</option><option  value='2'>2--关</option>");
			}else{
				$(this).find('#F10957').empty();
				$(this).find('#F10957').append("<option selected value='1'>1--开</option>");
			}
		}
	}
	
	if(vSmCode == "LL"){
		if(typeof($(this).find('#F10954').val()) != "undefined" ){
			/*获取权限a324*/
			if("<%=have_a324%>" == "true"){
				$(this).find('#F10954').empty();
				$(this).find('#F10954').append("<option selected value='1'>1--开</option><option  value='2'>2--关</option>");
			}else{
				$(this).find('#F10954').empty();
				$(this).find('#F10954').append("<option selected value='1'>1--开</option>");
			}
		}
	}
	
	if(vSmCode == "JJ"){
		if(typeof($(this).find('#F10833').val()) != "undefined" ){
			/*获取权限a323*/
			if("<%=haveA323%>" == "true"){
				$(this).find('#F10833').empty();
				$(this).find('#F10833').append("<option value='0' selected>0--否</option><option value='1'>1--是</option>");
			}else{
				$(this).find('#F10833').empty();
				$(this).find('#F10833').append("<option value='0' selected>0--否</option>");
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

		
		//计费类型(F00022) 为按此（02）的时候 区分个人付费还是集团付费		
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
	    	
	        $("#smsInfo").after("<font color=red>短消息服务代码为：EC基本接入号<span id='span_F00016'>"+$("#F00016").val()+"</span> +XXXX  提醒：短信服务号码长度必须为<%=smsMinLen%>-<%=smsMaxLen%>位!请核对好再确认。</font>");
	        $("#smsInfo").after("<font color=red>EC基本接入号为：SI基本接入号"+$("input[name$='BizServcode']").val()+" +XXXX </font><br/>");
	    }else if("<%=smsFlag%>" == "N"){
	        $("#smsInfo").after("<font color=red>短消息服务代码为：EC基本接入号"+$("#F00006").val()+" +XXXX  提醒：短信服务号码长度无限制。</font>");
	        $("#smsInfo").after("<font color=red>EC基本接入号为：SI基本接入号"+$("input[name$='BizServcode']").val()+" +XXXX </font><br/>");
	    }
	    if($("#F00004") != null){
	        $("#F00004").after("<font color='red'>[0:不限制]</font>");
	    }
	    if($("#F00005") != null){
	        $("#F00005").after("<font color='red'>[0:不限制]</font>");
	    }
	}else if("ML" == vSmCode){
		
	}else{
	    document.all.smsInfoTR.style.display="none";
	}
	
	//计费类型  00免费，“单价”需填写0
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
		//短信的业务接入号可扩展 彩信的业务接入号不可扩展
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
		
		if(i==bizCode.length)//MMS业务的业务代码为全数字
		{
			$("#F00006").attr("readOnly",true);
            $("#F00006").addClass("InputGrey");
		}
		else //SMS业务的业务代码为字符
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
	
	
	
		/*关于集团业务大检查中系统实现需求的函-4-关于ESOP中上线产品合同管理功能的需求
	 * hejwa 2016-6-8 15:47:44
	 * F10807
	 */
	 if(typeof($(this).find('#F10807').val()) != "undefined" ){
	 	$("#F10807").parent().append("&nbsp;<input type='button' class='b_text' value='校验' onclick='ajax_check_F10807()' />"); 
	 }
	
	
});



function ajax_check_F10807(){
	  var packet = new AJAXPacket("ajax_check_F10807.jsp","请稍后...");
        packet.data.add("F10807_val",$("#F10807").val());//
    core.ajax.sendPacket(packet,do_ajax_check_F10807);
    packet =null;	
}
function do_ajax_check_F10807(packet){
    var error_code = packet.data.findValueByName("code");//返回代码
    var error_msg =  packet.data.findValueByName("msg");//返回信息

    if(error_code=="000000"){//操作成功
    	var result_count =  packet.data.findValueByName("result_count");
    	if(result_count=="0"){
    		rdShowMessageDialog("“合同编号”未成功归档或输入错误，请核对后重新录入");
    		$("#F10807").val("");
    	}
    }else{//调用服务失败
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
       	rdShowMessageDialog("选择集团产品失败24!",0);
        return false;
    }
    
    var getBillingType_Packet = new AJAXPacket("fgetBillingType.jsp","正在获取billingtype，请稍候......");
	getBillingType_Packet.data.add("retType","getBillingType");
    getBillingType_Packet.data.add("product_code",product_code);
	core.ajax.sendPacket(getBillingType_Packet);
	getBillingType_Packet = null;
}

//集团附加产品选择
function getInfo_ProdAppend()
{
    var pageTitle = "集团附加产品选择";
    var fieldName = "产品代码|产品名称|";
	var sqlStr = "";
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "2|0|1|";
    var retToField = "product_append|product_name|";
    var product_code = document.frm.product_code.value;

    //首先判断是否已经选择了服务品牌
    if(document.frm.sm_code.value == "")
    {
        rdShowMessageDialog("请首先选择集团信息化产品！");
        return false;
    }

    //首先判断是否已经申请了集团产品
    if(document.frm.product_code.value == "")
    {
        rdShowMessageDialog("请首先选择集团产品！");
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
    
    /* add by qidp @ 2009-12-05 for 免费试用期 */
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
    //密码一致性校验,明码校验
    var pwd1 = obj1.value;
    var pwd2 = obj2.value;
    if(pwd1 != pwd2)
    {
        var message = "两次输入的密码不一致，请重新输入！";
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

//服务品牌变更事件
function changeSmCode() {
	document.frm.product_attr.value = "";
	//document.frm.product_code.value = "";
	//document.frm.product_append.value = "";
	document.frm.grp_userno.value = "";
	document.frm.getGrpNo.disabled = false;
	
	/*diling add for 当变更服务品牌时，隐藏A端产品编码,以及相关信息 @2012/11/26*/
	if("<%=nextFlag%>"=="1"){ //第一次加载页面
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
     * 服务品牌改变时，首先
     *    调用getBizLevel(),查询是否展示业务大类、业务小类、业务代码
     *    返回：
     *      1：只展示服务品牌
     *      2：展示服务品牌与业务大类
     *      3：展示服务品牌、业务大类、业务小类
     *      4：展示服务品牌、业务大类、业务小类及业务代码
     * 如果业务大类展示时
     *    调用getBizTypeL(),查询业务大类下拉框展示内容,并动态插入
     * 如果业务小类展示时，业务大类改变时
     *    调用getBizTypeS(),查询业务小类下拉框展示内容,并动态插入
     *********************/
  
    <%if("opcode".equals(openLabel)){%>
        getBizLevel();
    <%}%>
}

/* 查询是否展示业务大类、业务小类、业务代码 */
function getBizLevel(){
    var vSmCode = $("#sm_code").val();
    
    var getBizLevel_Packet = new AJAXPacket("fgetBizLevel.jsp","正在获得相关信息，请稍候......");
	getBizLevel_Packet.data.add("retType","getBizLevel");
    getBizLevel_Packet.data.add("sm_code",vSmCode);
    core.ajax.sendPacket(getBizLevel_Packet);
	getBizLevel_Packet = null;
}

/* 查询大类 */
function getBizTypeL(){
    var vSmCode = $("#sm_code").val();
    
    var getBizTypeL_Packet = new AJAXPacket("fgetBizTypeL.jsp","正在获得相关信息，请稍候......");
	getBizTypeL_Packet.data.add("retType","getBizTypeL");
    getBizTypeL_Packet.data.add("sm_code",vSmCode);
	core.ajax.sendPacket(getBizTypeL_Packet);
	getBizTypeL_Packet = null;
}

/* 查询小类 */
function getBizTypeS(){
    var vBizLevel = $("#bizLevel").val();
    /*begin diling add for 当服务品牌为集团专线，且业务大类为数据专线时，页面元素新增“A端产品集团编号”，“A端产品证件号码”项 @2012/11/26*/
    if("<%=nextFlag%>"=="1"){ //第一次加载页面
      if("From4091"!="<%=inOpenFlag%>"&&"DL100"!="<%=inOpenFlag%>"){//直接开户的时候
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
            $("<option value=''>--- 请选择 ---</option>").appendTo("#bizTypeS");
            return;
        }
        
        var getBizTypeS_Packet = new AJAXPacket("fgetBizTypeS.jsp","正在获得相关信息，请稍候......");
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

//查询业务类型
function getProdDirect()
{ 
    if(((frm.sm_code.value).trim()) == "")
    {
        rdShowMessageDialog("请获取业务类型！",0);
        frm.sm_code.focus();
        return false;
    }
    var getProdDirect_Packet = new AJAXPacket("f2890_getProdDirect.jsp","正在获得相关信息，请稍候......");
	getProdDirect_Packet.data.add("retType","getProdDirect");
    getProdDirect_Packet.data.add("sm_code",document.frm.sm_code.value);
	core.ajax.sendPacket(getProdDirect_Packet);
	getProdDirect_Packet = null;
}
 
//产品属性变更事件
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
    	z_sm_code="本地MAS";
    }else if(document.all.sm_code.value=="MA")
    {
    	z_sm_code="全网MAS";
    }
   
    for(j = 0 ; j < document.all.prod_direct.length ; j ++){
		if(document.all.prod_direct.options[j].selected){
		 z_sm_code= z_sm_code+"-"+document.frm.prod_direct.options[j].pvalue;
		}
	}
	document.all.grp_name.value = z_sm_code;
}
	
//产品变更事件
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
	
	if(sDate1>sDate2)	//sDate1 早于 sDate2
		return 1;
	if(sDate1==sDate2)	//sDate1、sDate2 为同一天
		return 0;
	return -1;		//sDate1 晚于 sDate2
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

//设置不允许下发时间段列表
function setTime()
{
	window.open('f2890_setTime.jsp','','width='+(screen.availWidth*1-10)+',height='+(screen.availHeight*1-76) +',left=0,top=0,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no');
}

//设置上行业务指令
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
					rdShowMessageDialog("不允许下发开始时间格式有误，正确格式为“时时分分秒秒”，请重新输入！");
					//return false;
					chekTimeFlag = false;
				}
			}
			if($(this).find('#F00035').val() != ""){
				if(!validTime($(this).find('#F00035').val())){
					rdShowMessageDialog("不允许下发结束时间格式有误，正确格式为“时时分分秒秒”，请重新输入！");
					//return false;
					chekTimeFlag = false;
				}
			}
			invalidTimeList.push(invalidTime);
			if(($(this).find('#F00034').val() != "" )&& ($(this).find('#F00035').val() != "")){
				if($(this).find('#F00034').val()>=$(this).find('#F00035').val()){
					rdShowMessageDialog("不允许下发开始时间 应小于 不允许下发结束时间,请检查!");
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
				rdShowMessageDialog("不允下发时间段之间不能有交叉和包含,请检查!");
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
	 * hejwa 2017/3/18 星期六 11:14:24
	 * 关于优化专线产品量化统计内容的需求
	 * 专票原因无法预付费（选择“是”，“合同预付费账期”）如果（选择否“合同预付费账期”，这个属性可以不用传值）
	 */
	if(typeof($('#F10999'))!="undefined"&&typeof($('#F10999').val())!="undefined"){
		if(typeof($('#F11000'))!="undefined"&&typeof($('#F11000').val())!="undefined"){
				
				if($('#F10999').val()=="Y"){
					if($('#F11000').val()==""){
						rdShowMessageDialog("请输入合同预付费账期");
						return;
					}
				}else{
					//选否的时候必须为空
					$('#F11000').val("");
				}

		}
	}

	
  /**
	 * 关于移动财铃新增业务BOSS功能开发需求的函
	 * hejwa add 3690 和3691 查询集团产品属性之后 如果属性类型为38 则需要校验输入的值是否为邮箱格式
	 * 后台人员 ： haoyy
	 **/
	if(typeof($('#F10749'))!="undefined"&&typeof($('#F10749').val())!="undefined"){
		if($('#F10749').val().trim()==""){
				rdShowMessageDialog("管理员电子邮箱地址不能为空!",0);
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
							rdShowMessageDialog("请输入相关产品账号");
							return;
						}
				}
		}
		/*关于申请制作集团客户信息化项目(产品)投资和收益自动化匹配报表的函
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
		 	   rdShowMessageDialog("短信下发时间必须大于当前时间！");
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
		 	   rdShowMessageDialog("输入提醒短信内容则必须输入提醒短信时间！");
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
				rdShowMessageDialog("点播类型的业务,指令类型只能为点播类型!",0);
                chk_f00025 = false ;
                return false;	
			}
		});
	}
	else if($('#F00025').val()=='1'||$('#F00025').val()=='2'||$('#F00025').val()=='3'){
		$("select[name='F00042']").each(function(){
			if($(this).val()=='0'){
				rdShowMessageDialog("非点播类型业务，指令类型不能为点播类型!",0);
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
				rdShowMessageDialog("短信内容特征串不能为三位以内的数字！",0);
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
			rdShowMessageDialog("短信内容特征串不能以如下字符开头：SIM、0000、00000、11111、CX、HELP以及0、1等三位以内的数字（不区分大小写）。",0);
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
			rdShowMessageDialog("租用面积必须为小数点后两位",0);
			return false;
		}
	}  

	if ( document.all.cptId.value.trim()=="" )
	{
		rdShowMessageDialog("产品协议编号不能为空!");
		return false;			
	}
	/*2013/11/29 14:31:56 gaopeng 移动网盘需求 81024管理员账户，字母和数字组合 start*/
	if (typeof ($("#F81024").val())!="undefined" )
	{
		var vF81024 = $.trim($("#F81024").val());
		var m = /^([0-9A-Za-z]*)$/;
		var flag = m.test(vF81024);
		if(!flag){
			rdShowMessageDialog("管理员账户必须由数字、字母组成！");
			return false;
		}
	}
	if (typeof ($("#F81025").val())!="undefined" )
	{
		var vF81024 = $.trim($("#F81025").val());
		var m = /^([0-9A-Za-z]*)$/;
		var flag = m.test(vF81024);
		if(!flag){
			rdShowMessageDialog("管理员密码必须由数字、字母组成！");
			return false;
		}
		if(vF81024.length != 8){
			rdShowMessageDialog("管理员密码必须是8位！");
			return false;
		}
	}
	/*2013/11/29 14:31:56 gaopeng 移动网盘需求 81024管理员账户，字母和数字组合 end*/
	
	/*2014/01/17 15:38:50 gaopeng 会务助理业务需求 81031管理员密码必须为字母和数字的组合 start*/
	if (typeof ($("#F81031").val())!="undefined" )
	{
		
		var vF81031 = $.trim($("#F81031").val());
		var m = /^([0-9A-Za-z]*)$/;
		var flag = m.test(vF81031);
		if(!flag){
			rdShowMessageDialog("管理员密码必须由数字、字母组成！");
			return false;
		}
	}
	/*2014/01/17 15:38:50 gaopeng 会务助理业务需求 81031管理员密码必须为字母和数字的组合 end*/
	
	if (typeof ($("#F81028").val())!="undefined" )
	{
		var vF81028 = $.trim($("#F81028").val());
		var re=/^[0-9]*$/;  
		var flag = re.test(vF81028);
		if(!flag){
			rdShowMessageDialog("用户组织机构ID必须由数字组成！");
			return false;
		}
		if(vF81028.length != 20){
			rdShowMessageDialog("用户组织机构ID必须是20位！");
			return false;
		}
	}
	if (typeof ($("#F81039").val())!="undefined" )
	{
		var vF81039 = $.trim($("#F81039").val());
		var re=/^[0-9]*$/;  
		var flag = re.test(vF81039);
		if(!flag){
			rdShowMessageDialog("企业编码必须由数字组成！");
			return false;
		}
		if(vF81039.length != 20){
			rdShowMessageDialog("企业编码必须是20位！");
			return false;
		}
	}
	if (typeof ($("#F81033").val())!="undefined" )
	{
		var vF81033 = $.trim($("#F81033").val());
		if(vF81033.length != 6){
			rdShowMessageDialog("登陆密码必须是6位！");
			return false;
		}
	}
	if (typeof ($("#F81042").val())!="undefined" )
	{
		var vF81042 = $.trim($("#F81042").val());
		if(vF81042.length != 6){
			rdShowMessageDialog("管理员密码必须是6位！");
			return false;
		}
	}
	
	if (typeof ($("#F00022").val())!="undefined" && typeof ($("#F00051").val())!="undefined"){
		if($('#F00022').val()!='00'){
			if(parseFloat($('#F00051').val().trim()) <= 0){
				rdShowMessageDialog("如果计费类型不为免费时，则单价需要大于0!",0);
				return false;
			}
		}
	}

	if ( parseInt(document.all.cptId.value,10)<1000000000  )
	{
		rdShowMessageDialog("产品协议编号必须是10位!",0);
		return false;
	}	
	
	if ( document.all.cnttId.value.trim()!=="" )
	{
			if ( parseInt(document.all.cnttId.value,10)<1000000000  )
			{
				rdShowMessageDialog("项目合同编号必须是10位!",0);
				return false;
			}	

	}	
	
	/*liujian 2013-1-30 11:11:19*/
	if('<%=sm_code%>' == 'hj' && $('#catalog_item_id').val() == '214'){	
		if(!$('#provSelect').val())	{
			rdShowMessageDialog("请选择企业所在地固话区号！",0);
			return false;
		}
		if(!$('#citySelect').val())	{
			rdShowMessageDialog("请选择企业所在地固话区号！",0);
			return false;
		}
	}
	openFlag = 1; //yuanqs add 2010/10/12 12:53:52
	getAfterPrompt();
    //校验动态生成的字段
	if(!checkDynaFieldValues(false))
        return false;
    var checkFlag; //注意javascript和JSP中定义的变量也不能相同,否则出现网页错误.

    //说明:检测分成两类,一类是数据是否是空,另一类是数据是否合法.
    if(check(frm))
    {
    	
    	
        /*begin diling add for 校验 SSID标识、Portal登陆账号 格式@2012/7/10*/
        // SSID标识 
        var re=/^([0-9a-zA-Z\-]*)$/; 
        //var re=/\a-\z\A-\Z0-9\u4E00-\u9FA5\@\/; 
        var re2=/^[0-9a-z]*$/;  
        if( document.frm.F10625 !=null && document.frm.F10625.value == "" ){
          rdShowMessageDialog("SSID标识必须输入!!");
          document.frm.F10625.select();
          return false;
        }
        if(document.frm.F10625 != null && document.frm.F10625.value != ""){
          if(re.test(document.frm.F10625.value)==false){
            rdShowMessageDialog("SSID标识必须为字母,数字或者- !");
            document.frm.F10625.select();
            return false;
          }
        }

        var sm_code = document.frm.sm_code.value;
        
        //if(sm_code == "AD" || sm_code == "ML" || sm_code == "MA"){
            if(  document.frm.F00017 != null && document.frm.F00017.value == "") {
                rdShowMessageDialog("集团产品不能为空!",0);
                return false;
            }
        //}else{
        //    if(  document.frm.product_code != null && document.frm.product_code.value == "") {
        //        rdShowMessageDialog("集团产品不能为空!",0);
        //        return false;
        //    }
        //}
        if(  document.frm.F10333 != null && document.frm.F10333.value != "") {
            if (document.frm.chkPass2.disabled == false) {
                rdShowMessageDialog("集团付费号码:"+document.frm.F10333.value+"尚未进行密码校验!");
                document.frm.chkPass2.select();
                return false;
            }
        }
        
        if(  document.frm.grp_name.value == "" ){
            rdShowMessageDialog("用户名称:"+document.frm.grp_name.value+",必须输入!!");
            document.frm.grp_name.select();
            return false;
        }
        if(  document.frm.grp_id.value == "" ){
            rdShowMessageDialog("集团产品ID必须获取!!");
            document.frm.grp_id.select();
            return false;
        }
        
        //2.转换业务起始日期和业务结束日期的YYYYMMDD---->YYYY-MM-DD
		checkFlag = isValidYYYYMMDD(document.frm.srv_start.value);
        if(checkFlag < 0){
            rdShowMessageDialog("业务起始日期:"+document.frm.srv_start.value+",日期不合法!!");
            document.frm.srv_start.select();
            return false;
        }
        checkFlag = isValidYYYYMMDD(document.frm.srv_stop.value);
        if(checkFlag < 0){
            rdShowMessageDialog("业务结束日期:"+document.frm.srv_stop.value+",日期不合法!!");
            document.frm.srv_stop.select();
            return false;
        }
        
        if(document.frm.srv_start.value < "<%=dateStr%>"){
            rdShowMessageDialog("业务起始日期应不小于当前日期!!");
            document.frm.srv_start.select();
            return false;
        }
        
        //业务起始日期和业务结束日期的时间比较
        checkFlag = dateCompare(document.frm.srv_start.value,document.frm.srv_stop.value);
        if( checkFlag == 1 ){
            rdShowMessageDialog("业务结束日期应该大于业务起始日期!!");
            document.frm.srv_stop.select();
            return false;
        }
        if(document.all.sm_code.value =="pi")
        {
        	if(document.all.F10333.value =="")
        	{
        		rdShowMessageDialog("请输入集团付费号码!!");
            document.all.F10333.select();
            return false;
        	}
        	if(document.all.F10334.value =="")
        	{
        		rdShowMessageDialog("请输入集团付费号码密码!!");
            document.all.F10334.select();
            return false;
        	}
        }
        
		//进行密码校验
		if(((document.all.user_passwd.value).trim()).length>0)
        {
            if(document.all.user_passwd.value.length!=6)
            {
                rdShowMessageDialog("用户密码长度有误！",0);
                document.all.user_passwd.focus();
                return false;
             }
             if(checkPwd(document.frm.user_passwd,document.frm.account_passwd)==false)
                return false;
        }
        else
        {
            rdShowMessageDialog("用户密码不能为空！");
            document.all.user_passwd.focus();
            return false;
        }
        
        if( document.frm.F10000 !=null && document.frm.F10000.value == "" )
		{
			rdShowMessageDialog("集团主费率必须输入!!");
			document.frm.F10000.focus();
			return false;
		}
        //校验管理员帐户密码
        if(document.frm.F10304 !=null && document.all.F10304.value.length<6)
        {
            rdShowMessageDialog("管理员账户密码长度有误！",0);
            document.all.F10304.value="";
            document.all.F10304.focus();
            return false;
        }  
      
        if(document.frm.F10304 !=null && !isDecimal(document.all.F10304.value)){
            rdShowMessageDialog("管理员账户密码只能是数字串！",0);
            document.all.F10304.value="";
            document.all.F10304.focus();
            return false;
        }
        if( document.frm.F10304 !=null && document.frm.F10304.value == "" ){
            document.frm.F10304.value="111111";
        }
        
        if( document.frm.F10317 !=null && document.frm.F10317.value == "" ){
            rdShowMessageDialog("网内费率索引必须输入!!");
            document.frm.F10317.select();
            return false;
        }
        if( document.frm.F10319 !=null && document.frm.F10319.value == "" ){
            rdShowMessageDialog("网外号码费率索引必须输入!!");
            document.frm.F10319.select();
            return false;
        }
        if( document.frm.F10321 !=null && document.frm.F10321.value == "" ){
            rdShowMessageDialog("集团管理接入码必须输入!!");
            document.frm.F10321.select();
            return false;
        }
        if( document.frm.F10318 !=null && document.frm.F10318.value == "" ){
            rdShowMessageDialog("网外费率索引必须输入!!");
            document.frm.F10318.select();
            return false;
        }
        if( document.frm.F10320 !=null && document.frm.F10320.value == "" ){
            rdShowMessageDialog("非优惠费率索引必须输入!!");
            document.frm.F10320.select();
            return false;
        }
        if( document.frm.F10322 !=null && document.frm.F10322.value == "" ){
            rdShowMessageDialog("呼叫话务员转接号必须输入!!");
            document.frm.F10322.select();
            return false;
        }
        if( document.frm.F10328 !=null && document.frm.F10328.value == "" ){
            rdShowMessageDialog("集团最大用户数必须输入!!",0);
            document.frm.F10328.select();
            return false;
        }
    

		//判断real_handfee
		if(!checkElement(document.frm.real_handfee)) return false;
        if (parseFloat(document.frm.real_handfee.value)>parseFloat(document.frm.should_handfee.value))
        {
			rdShowMessageDialog("实收手续费不应大于应收手续费");
			document.frm.real_handfee.focus();
			return false;	
        }
		if (parseFloat(document.frm.checkPay.value)!=parseFloat(document.frm.real_handfee.value))
        {
			rdShowMessageDialog("支票交款应等于实收手续费");
			document.frm.checkPay.focus();
			return false;	
        }
		if (parseFloat(document.frm.checkPay.value)>parseFloat(document.frm.checkPrePay.value))
        {
			rdShowMessageDialog("支票交款应小于支票余额");
			document.frm.checkPay.focus();
			return false;	
        }
		if (parseFloat(document.frm.should_handfee.value)==0)
		{
			document.frm.real_handfee.value="0.00";
		}
        //由于参数太多，需要通过form的post传输,因此,需要将传输的内容复制到隐含域中. yl.
        document.frm.chgsrv_start.value = changeDateFormat(document.frm.srv_start.value);
        document.frm.chgsrv_stop.value  = changeDateFormat(document.frm.srv_stop.value);
        
        if( document.frm.F10326 !=null && parseInt(document.frm.F10326.value) > 5){
            rdShowMessageDialog("单个用户最大可加入的闭合群数:"+document.frm.F10326.value+",范围[0,5]!!",0);
            document.frm.F10326.select();
            return false;
        }
        if(document.frm.F10328 != null){
            checkFlag = parseInt(document.frm.F10328.value);
            if(checkFlag < 20 || checkFlag > 1000){
                rdShowMessageDialog("集团可拥有的最大用户数:"+document.frm.F10328.value+",范围[20,1000]!!",0);
                document.frm.F10328.select();
                return false;
            }
        }
        if(document.frm.F10330 != null && document.frm.F10330.value != ""){
            checkFlag = isValidYYYYMMDD(document.frm.F10330.value);
            if(checkFlag < 0 ){
                rdShowMessageDialog("资费套餐生效日期:"+document.frm.F10330.value+",日期不合法!!",0);
                document.frm.F10330.select();
                return false;
            }
        }
        //必须晚于当前日期
        if(document.frm.F10330 != null && document.frm.F10330.value != "" && document.frm.srv_start != null){
            checkFlag = dateCompare(document.frm.srv_start.value,document.frm.F10330.value);
            if( (checkFlag == 1) || (checkFlag == 0) ){
                rdShowMessageDialog("必须晚于当前日期!!",0);
                document.frm.F10330.select();
                return false;
            }
        }
        
        //Portal登陆账号
        if( document.frm.F10626 !=null && document.frm.F10626.value == "" ){
          rdShowMessageDialog("登陆账号必须输入!!");
          document.frm.F10626.select();
          return false;
        }
        if(document.frm.F10626 != null && document.frm.F10626.value != ""){
          if(re.test(document.frm.F10626.value)==false){
            rdShowMessageDialog("登陆账号必须为字母+数字!!");
            document.frm.F10626.select();
            return false;
          }
        }
        //企业简称
        if( document.frm.F10629 !=null && document.frm.F10629.value == "" ){
          rdShowMessageDialog("企业简称必须输入!!");
          document.frm.F10629.select();
          return false;
        }
        if(document.frm.F10629 != null && document.frm.F10629.value != ""){
          if(re2.test(document.frm.F10629.value) == false){
            rdShowMessageDialog("企业简称必须为小写字母，或数字，或者小写字母+数字!!");
            document.frm.F10629.select();
            return false;
          }
          if(((document.frm.F10629.value).trim()).length>0){
            if(document.frm.F10629.value.length<2||document.frm.F10629.value.length>6){
              rdShowMessageDialog("企业简称长度必须为2-6位！",0);
              document.frm.F10629.select();
              return false;
            }
          }
        }
        /*end diling add for @2012/7/10 */
       
        <%if(userType.equals("pe")) {%>
        document.frm.sysnote.value = "手机邮箱集团产品开户";
        <%}else{%>
        document.frm.sysnote.value = "集团产品开户";

        <%}%>	
		getSysAccept();
    }
}
//打印相关
//取流水
function getSysAccept()
{
	var getSysAccept_Packet = new AJAXPacket("pubSysAccept.jsp","正在生成操作流水，请稍候......");
	getSysAccept_Packet.data.add("retType","getSysAccept");
	core.ajax.sendPacket(getSysAccept_Packet,doProcess,true);
	getSysAccept_Packet = null;   
}
//选择支付方式
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
 //获得总计金额
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
						rdShowMessageDialog("A端结算比例,请输入0到1的小数！并精确到小数点后两位！");
						retflag = false;
						$(this).focus();
						return false;
					}
					if(vF81031 > 1 || vF81031 < 0){
						rdShowMessageDialog("A端结算比例必须为0-1之间的小数！");
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

	if(!checkDynaFieldValues(true)){//输入基本月租费
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
		rdShowMessageDialog("请查询付款金额!");
		return false;
	}
	var real_handfee = document.frm.real_handfee.value;
	var cashNum = document.frm.cashNum.value;
	if (parseFloat(document.frm.real_handfee.value)>parseFloat(document.frm.should_handfee.value))
	{
		rdShowMessageDialog("实收手续费不应大于应收手续费");
		document.frm.real_handfee.focus();
		return false;	
	}
	document.frm.cashPay.value=Math.round(real_handfee)+Math.round(cashNum);//总费
	rdShowMessageDialog("交款计算成功!",2);
	document.frm.real_handfee.readOnly=true;
	document.frm.sure.disabled = false;
			
}
function closefields()//点击下一步时，已经填好的字段不可修改
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
		f10340txt = f10340txt + "<option  value='01'>01--无专用APN</option>";
		f10340txt = f10340txt + "<option  value='00'>00--专用APN</option>";
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

//TD-商务宝："业务类型"域对"2G号码"文本域的联动控制 
//ADD by shengzd @ 20090519
function ctrlF10342(selectId)
{
	var f10342txt = "";
	if(selectId.value == "01")
	{
		f10342txt = "<input id='F10344' name='F10344'  class='button' type='text' datatype=72 maxlength=11 value=''>&nbsp"; //被隐藏的"2G号码"默认值为空 
	}
	else
	{
		f10342txt = "<input id='F10344' name='F10344'  class='button' type='hidden' datatype=72 maxlength=11 value='0'>&nbsp";
	}
	divF10344.innerHTML=f10342txt;
}

// 查询销售代理商
function selSales(){
    var pageTitle = "销售代理商查询";
    var fieldName = "代理商代码|代理商名称|";
    /* ningtn 关于优化集团客户SA酬金结算系统的函*/
		var sqlStr="90000156";
		params = "<%=pubSAGroupId%>|";		
    var selType = "S";    //'S'单选；'M'多选
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
// 查询交换机端口号
function selExchgPorts(){
    var pageTitle = "交换机设备端口号查询";
    var fieldName = "端口号代码|设备端口号名称|集团客户名称|";
		var sqlStr="90000155";
		params = "1|";
    var selType = "M";    //'S'单选；'M'多选
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
    $("#F10775").val(retInfo); //交换机端口号
}

//yuanqs add 2010/9/2 13:39:59 申告ID:10471.动力100包无法取消。
function doResume() {
			var v_btnId = "<%=iBtnId%>";
			opener.document.getElementById(v_btnId).disabled = false; //yuanqs add 2010-9-2 17:14:17
			window.close();
}

//yuanqs add 2010/9/6 9:36:32 申告ID:10471.动力100包无法取消，页面关闭时调用
function doRefresh() {
		if(openFlag == 0) {//yuanqs add 2010/10/12 13:04:47
			var v_btnId = "<%=iBtnId%>";
			if(isRefresh) {
				opener.document.getElementById(v_btnId).disabled = false; //yuanqs add 2010-9-2 17:14:17
			}
		}
}


/**
 * 关于2月下旬集团客户部CRM、BOSS和经分系统需求的函-2-boss侧增加专线0元资费说明信息的需求
 * 2016年4月12日9:42:51
 * hejwa 、陈琳
 */
$(document).ready(function(){
		if($("#F10964").html()!=null&&$("#F10965").html()!=null){
			go_check_F10964_F10965();
			$("#F10965").blur(function(){
					if($("#F10964").val()==""){
						rdShowMessageDialog("请选择免费原因");
						$("#F10965").val("");
					}
					if($("#F10964").val()=="3"||$("#F10964").val()=="4"){
						go_check_F10965();
					}
			});
		}
		
	
	/*
	 * 部分后付费集团产品实现账期录入和信控功能的业务需求
	 */		
		$("input[name='F10975']").attr("readOnly","readOnly");
		$("input[name='F10975']").addClass("InputGrey");		
		
		var val_F10817 = "12";
		var val_F10975 = "<%=db_cu_date%>";
		$("select[name='F10817']").val(val_F10817);
		$("input[name='F10975']").val(val_F10975);
});

function go_check_F10964_F10965(){
	  var packet = new AJAXPacket("check_F10964_F10965.jsp","请稍后...");
        packet.data.add("sPChanceId","<%=in_ChanceId%>");//
    core.ajax.sendPacket(packet,do_check_F10964_F10965);
    packet =null;	
}
function do_check_F10964_F10965(packet){
    var error_code = packet.data.findValueByName("code");//返回代码
    var error_msg =  packet.data.findValueByName("msg");//返回信息

    if(error_code=="000000"){//操作成功
    	var result_count =  packet.data.findValueByName("result_count");
    	if(result_count!="0"){
    		$("#F10964").attr("disabled","disabled");
    		$("#F10965").attr("disabled","disabled");
    	}
    }else{//调用服务失败
	    rdShowMessageDialog(error_code+":"+error_msg);
    }
}

function go_check_F10965(){
	  var packet = new AJAXPacket("check_F10965.jsp","请稍后...");
        packet.data.add("prod_id",$("#F10965").val());//
        packet.data.add("unit_id",$("#unit_id").val());//
        packet.data.add("opCode","<%=opCode%>");//
				packet.data.add("c_prod_id","");//        
    core.ajax.sendPacket(packet,do_check_F10965);
    packet =null;		
}
function do_check_F10965(packet){
    var error_code = packet.data.findValueByName("code");//返回代码
    var error_msg =  packet.data.findValueByName("msg");//返回信息

    if(error_code=="000000"){//操作成功
    	var result_count =  packet.data.findValueByName("result_count");
    	if(result_count=="0"){
    		rdShowMessageDialog("免费原因选择“整体信息化项目”和“承载其他业务应用”时，需要填写同一集团编码下的其他产品账号");
    	}
    }else{//调用服务失败
	    rdShowMessageDialog(error_code+":"+error_msg);
    }
}

/*关于申请制作集团客户信息化项目(产品)投资和收益自动化匹配报表的函
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
		var packet = new AJAXPacket("../s3690/ajax_check_F10985.jsp","请稍后...");
        packet.data.add("F10985_val",$("#F10985").val());//
    	core.ajax.sendPacket(packet,do_ajax_check_F10985);
   	 	packet =null;	
	}
}

function do_ajax_check_F10985(packet){
    var error_code = packet.data.findValueByName("code");//返回代码
    var error_msg =  packet.data.findValueByName("msg");//返回信息
    if(error_code=="000000"){//操作成功
    	var result_count =  packet.data.findValueByName("result_count");
    	if(result_count=="0"){
    		rdShowMessageDialog("输入的项目编号错误请核对后重新输入!");
    	}
    	else{
    		F10985_flag=1;
    	}
    }else{//调用服务失败
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
<!-- yuanqs add 2010/9/3 15:58:15 添加-->
<BODY onUnload="doRefresh()">
<FORM action="" method="post" name="frm" >
<%@ include file="/npage/include/header.jsp" %>
<div class="title">
	<div id="title_zi">集团验证</div>
</div>
<input type="hidden" id=hidPwd name="hidPwd" v_name="原始密码">
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
<!-- add by liwd 20081127,group_id来自dcustdoc的group_id
<input type="hidden" name="group_id"  value="<%=GroupId%>">
-->
<input type="hidden" name="group_id" id="group_id" value="<%=group_id%>">
<!--add by liwd 20081127,group_id来自dcustDoc的group_id end -->
<input type="hidden" id="login_accept" name="login_accept"  value="0"> <!-- 操作流水号-->
<input type='hidden' id='child_accept' name='child_accept' value='<%=iChildAccept%>' /> <!-- 子流水号 -->
<input type="hidden" name="opName" value="<%=opName%>">
<input type="hidden" name="bill_type"  value="0"> <!-- 出帐周期 -->
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
        <TD class=blue>证件号码</TD>
        <TD>
            <input name=iccid <%if(nextFlag==2)out.println("readonly");%> id="iccid" size="24" maxlength="20" value="<%=iccid%>" v_type="string" v_must=1 index="1">
            <input name=custQuery type=button id="custQuery" class="b_text" onClick="getInfo_Cust();" onKeyUp="if(event.keyCode==13)getInfo_Cust();" style="cursor:hand" value=查询>
            <font class="orange">*</font>
        </TD>
        <TD class=blue>集团客户ID</TD>
        <!--wuxy alter maxlength="12" 20080706-->
        <TD>
            <input type="text" <%if(nextFlag==2)out.println("readonly");%> value="<%=cust_id%>" name="cust_id" id="cust_id" size="20" maxlength="12" v_type="0_9" v_must=1 index="2">
            <font class="orange">*</font>
        </TD>
    </TR>
    
    <TR>
        <TD class=blue>集团编号</TD>
        <TD>
            <input name=unit_id <%if(nextFlag==2)out.println("readonly");%> value="<%=unit_id%>" id="unit_id" size="24" maxlength="11" v_type="0_9" v_must=1 index="3">
            <font class="orange">*</font>
        </TD>
        <TD class=blue>集团客户名称</TD>
        <TD>
            <input name="cust_name" id="cust_name" size="20" readonly value="<%=cust_name%>" v_must=1 v_type=string index="4">
            <font class="orange">*</font>
        </TD>
    </TR>
    
    <TR>
        <TD class=blue>集团客户密码</TD>
        <TD>
        <%
            if(!ProvinceRun.equals("20"))  //如果不是吉林
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
            <input name=chkPass type=button onClick="check_HidPwd();" class="b_text" style="cursor:hand" id="chkPass2" value=校验>
            <font class="orange">*</font>
        </TD>
        <TD class=blue>服务品牌</TD>
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
            <span id='bizTypeLFlag1' style='display:none;'>业务大类</span>&nbsp;
        </TD>
        <TD>
            <span id='bizTypeLFlag2' style='display:none;'>
                <select id='bizTypeL' name='bizTypeL' onChange='getBizTypeS()'>
             
                </select>
            </span>&nbsp;
        </td>
        <TD class=blue>
            <span id='bizTypeSFlag1' style='display:none;'>业务小类</span>&nbsp;
        </TD>
        <TD>
            <span id='bizTypeSFlag2' style='display:none;'>
                <select id='bizTypeS' name='bizTypeS'>
             
                </select>
            </span>&nbsp;
        </td>
      </TR>
      
      <tr id='trAProdInfosFlag' style='display:none;'>
        <TD class=blue>A端产品集团编号</TD>
        <TD>
            <input type="text" <%if(nextFlag==2)out.println("readonly");%> id='A_prodUnitId' name='A_prodUnitId' value="<%=iA_prodUnitIdHidden%>" size='20' v_must=0 v_type='0_9'  maxlength="11" />
        </TD>
        <TD class=blue>A端产品证件号码</TD>
        <TD>
            <input type="text" <%if(nextFlag==2)out.println("readonly");%> id='A_prodIccid' name='A_prodIccid' value='<%=iA_prodIccidHidden%>' size='20' v_must=0 v_type='string' maxlength="20"  />
            <input name='AProdInfosBtn' type='button' id='AProdInfosBtn'  class='b_text' onClick='getInfo_AProdInfo();' onKeyUp='if(event.keyCode==13)getInfo_AProdInfo();' value='查询' />
        </TD>
     </tr>
     <tr id='trAProdUnitInfosFlag' style='display:none;'>
        <TD class=blue>A端集团产品ID</TD>
        <TD colspan='3'>
            <input type="text" <%if(nextFlag==2)out.println("readonly");%> id='AProd_grpIdNoHidden' name='AProd_grpIdNoHidden' value='<%=iAProd_grpIdNoHidden%>' size='20' v_must=0 v_type='string' maxlength="20" class="InputGrey" readonly />
            <input name='AProdGrpIdNoBtn' type='button' id='AProdGrpIdNoBtn'  class='b_text' onClick='chkInfo_AProdCode();' onKeyUp='if(event.keyCode==13)chkInfo_AProdCode();' value='校验' />
        </TD>
     </tr>
     <tr id='trRetAProdInfoOne' style='display:none;'>
        <TD class=blue>产品代码</TD>
        <TD >
            <input type="text" id='ret_prodCode' name='ret_prodCode' value='<%=iret_prodCodeHidden%>' size='20' v_must=0  class="InputGrey" readonly />
        </TD>
        <TD colspan='2'>
            <A style="cursor: hand" onMouseOver="this.style.color='#ff0000'" onclick="getInfo_disPriceMsg_detail()" >
              <font class="orange">议价信息</font>&nbsp;
            </A>
        </TD>
     </tr>
    
     <tr id='trRetAProdInfoTwo' style='display:none;'>
        <TD class=blue>产品名称</TD>
        <TD colspan='3  '>
            <input type="text" id='ret_prodName' name='ret_prodName' value='<%=iret_prodNameHidden%>' size='20' v_must=0 class="InputGrey" readonly />
        </TD>
     </tr>
     
     
      
     <tr id='trBizCodeFlag' style='display:none;'>
        <TD class=blue>业务代码</TD>
        <TD colspan='3'>
            <input type="text" id='biz_code' name='biz_code' value='<%=oBizCode%>' size='20' v_must=0 v_type='string'>
            <input type="hidden" id='biz_name' name='biz_code' value='<%=bizName%>' size='20' v_must=0 v_type='string'>
        </TD>
     </tr>
     <TR id="prodFlag" name="prodFlag" style="display:">   
        <td class=blue>集团产品</td>
        <td colspan='3'>
            <input type='text' id='F00017' name='F00017' size='20' readonly onChange='changeProduct()' v_must=1 v_type='string' value="<%=F00017%>">
            <input name='prodQuery2' type='button' id='ProdQuery2'  class='b_text' onClick='getInfo_Prod2();' onKeyUp='if(event.keyCode==13)getInfo_Prod2();' value='选择'>
            <font class="orange">*</font>
        </td> 
    </TR>
    <tr style='display:none'>
        <TD class=blue>集团产品类型</TD>
        <TD colspan='3'>
            <select name="ProdType" >
            	<option  value='0' selected>本地业务</option>
            	<option  value='1' >包订购业务</option>
            	
            </select>
        </TD>
    </tr>
    <TR id="province_id" style="display:none">
        <TD class=blue>集团所在省区号</TD>
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
                logger.error("查询集团省区号失败!");
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
            <span id = "title_zi"><b>AZ端集团属性</b></span>&nbsp;&nbsp;
          </TD>
        </TR>
        <TR>
          <TD nowrap >专线实例编号</TD>
          <TD nowrap >A端用户名称</TD>
          <TD nowrap >城市A</TD>
          <TD nowrap >A端所属区县</TD>
          <TD nowrap >端点A详细地址</TD>
          <TD nowrap >A端用户技术联系人</TD>
          <TD nowrap >A端用户技术联系电话</TD>
          <TD nowrap >A端路由保护方式</TD>
          <TD nowrap >A端业务保障等级</TD>
          <TD nowrap >Z端用户名称</TD>
          <TD nowrap >城市Z</TD>
          <TD nowrap >Z端所属区县</TD>
          <TD nowrap >端点Z详细地址</TD>
          <TD nowrap >Z端用户技术联系人</TD>
          <TD nowrap >Z端用户技术联系电话</TD>
          <TD nowrap >Z端路由保护方式</TD>
          <TD nowrap >Z端业务保障等级</TD>
          <TD nowrap >专线状态</TD>
          <TD nowrap >状态时间</TD>
          <TD nowrap >A端结算比例</TD>
        </TR>
        <tr>
        <tbody id="terminal"></tbody>
        </tr>
	       </TABLE>
    </div>

<!---- 隐藏的列表-->
<%
    //为include文件提供数据 
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
    String []fieldReadOnly = new String[fieldCount];	//yuanqs add 2011/5/24 10:57:32 增加readonly
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
  
  /*update 针对页面代码过大引发的报错问题，对页面引用方式进行修改。@2013/8/27 */
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
    <td class=blue>联系人姓名</td>
    <td colspan='3'>
    	<input id='F10305' name='F10305' type='text' readOnly class='InputGrey'  v_must=0 v_type='string' index='14' value='<%=(contact_info == null)?"":(contact_info[0][0])%>'>
    </td>
</tr>

<tr>
    <td class=blue>集团联系电话</td>
    <td>
    	<!-- yuanqs add 2011/6/10 16:28:41 增加集团联系电话输入限制，之前可以输入汉字 -->
        <input id='F10306' name='F10306' type='text' onkeyup="value=value.replace(/[^\d]/g, '')" onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g, ''))" onKeyPress='return isKeyNumberdot(0)'  v_must=0 v_type='string' maxlength="18" value='<%=(contact_info == null)?"":(contact_info[0][2])%>'>
    </td>
    <td class=blue>集团联系地址</td>
    <td>
        <input id='F10307' name='F10307' type='text' readOnly class='InputGrey' onKeyPress='return isKeyNumberdot(0)'  v_must=0 v_type='string' value='<%=(contact_info == null)?"":(contact_info[0][1])%>'>
    </td>
</tr>

<tr id="payTypeId">
    <td class=blue>付款方式</td>
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
    
    <TD class=blue>业务名称</TD>
    <TD>
    	<input type="text" name="F00018" size="20" readonly value="<%=F00018%>">
    </TD>
    <TD class=blue>归属地区</TD>
    <TD>
        <select name="F00015" id="F00015" disabled >
        <%//add
        try
        {
            sqlStr = "select substr('"+org_code+"',1,2),substr('"+org_code+"',1,7),'工号所在地' from dual "
               +" union all select region_code,belong_code,belong_name from sBelongCode";
            String[] inParams = new String[2];
            inParams[0] = "select substr(:org_code,1,2),substr(:org_code2,1,7),'工号所在地' from dual "
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
    <TD class="blue">功能费付费方式</TD>
    <TD colspan=3>
        <select name="F00019" id="F00019" <%if(nextFlag==2)out.println("readonly");%>>
            <option value="0"> 0-集团付费 </option>
            <option value="1"> 1-个人付费 </option>
        </select>
    <font color="orange">*</font>
</TD>
    
<TR style="display:none" id="proType">
    <TD class=blue>产品类型</TD>
    <TD colspan='3'>
        <input type="text" name="product_attr_hidden" size="20" readonly  onChange="changeProdAttr()" v_must=0 v_type="string">
        <input name="ProdAttrQuery" type="button" id="ProdAttrQuery"  class="b_text" onClick="getInfo_ProdAttr('0');" onKeyUp="if(event.keyCode==13)getInfo_ProdAttr('0');" value="选择">
        
        <input type="hidden" name="product_attr" value="<%=product_code%>"/>
    </TD>
</TR>

    <TR id="productGroup"  style="display:none">
        <TD class=blue>集团产品</TD>
        <TD id="ipTd">
            <input type="text" name="product_code" size="20" readonly onChange="changeProduct()" v_must=1 v_type="string" value="<%=product_code%>">
            <input name="prodQuery" type="button" id="ProdQuery"  class="b_text" onClick="getInfo_Prod();" onKeyUp="if(event.keyCode==13)getInfo_Prod();" value="选择">
            <font class="orange">*</font>
        </TD>
        <TD class=blue></TD>
        <TD id="ipTd1"></TD>
    </TR>
    <tr>
        <TD class=blue>集团附加产品</TD>
        <TD>
            <input type="text" name="product_append" id="product_append" size="20" readonly v_must=0 v_type="string" value="<%=product_append%>">
            <input name="ProdAppendQuery" type="button" id="ProdAppendQuery"  class="b_text" onClick="getInfo_ProdAppend();" onKeyUp="if(event.keyCode==13)getInfo_ProdAppend();" value="选择">
        </TD>
        <td class='blue'>
            <span id="f5000Flag1" name="f5000Flag1" style="display:<%=f5000Label%>;">免费试用期</span>&nbsp;
        </td>
        <td>
            <span id="f5000Flag2" name="f5000Flag2" style="display:<%=f5000Label%>;">
                <select id="F10500" name="F10500">
                    <option value="">--请选择--</option>
                    <option value="1">一个月</option>
                    <option value="2">两个月</option>
                    <option value="3">三个月</option>
                </select>
                &nbsp;<font class='orange'>*</font>
            </span>&nbsp;
        </td>
    </tr>
    <TR>
        <TD class=blue>集团产品ID</TD>
        <TD>
            <input name="grp_id" id="grp_id" type="text" size="20" maxlength="12" readonly v_type="0_9" v_must=1>
            <input name="grpQuery" type="button" id="grpQuery"  class="b_text" onClick="getUserId();" onKeyUp="if(event.keyCode==13)getUserId();" value="获取">
            <font class="orange">*</font>
        </TD>
        <TD class=blue>用户名称</TD>
        <TD>
            <input name="grp_name" type="text" size="20" maxlength="60" v_must=1 v_maxlength=60 v_type="string" value="<%=grp_name%>">
            <font class="orange">*</font>
        </TD>
    </TR>
          
    <TR>
        <TD class=blue>产品帐户ID</TD>
        <TD>
            <input name="account_id" type="text" size="20" maxlength="12" readonly v_type="0_9" v_must=1>
            <input name="accountQuery" type="button" class="b_text" id="accountQuery" onClick="getAccountId();" onKeyUp="if(event.keyCode==13)getAccountId();" value="获取" >
            <font class="orange">*</font>
        </TD>
        <TD class=blue>
            <span id='grpNoFlag1'>集团产品编号</span>&nbsp;
        </TD>
        <TD>
            <span id='grpNoFlag2'>
                <input name="grp_userno" id="grp_userno" type="text" size="20" maxlength="4" readonly v_type="string" v_must=1>
                <input name="getGrpNo" type="button" class="b_text" id="getGrpNo" onClick="getGrpUserNo();" onKeyUp="if(event.keyCode==13)getGrpUserNo();" value="获取">
                <font class="orange">*</font>
            </span>&nbsp;
        </TD>
    </TR>
          
    <TR>
        <%if(!ProvinceRun.equals("20"))  //不是吉林
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
                <div align="left">帐户密码</div>
            </TD>
            <TD>
                <input name="user_passwd" type="password" class="button" maxlength=6 pwdlength="6">
            </TD>
            <TD class=blue> 
                <div align="left">密码校验</div>
            </TD>
            <TD>
                <input  name="account_passwd" type="password" class="button" prefield="user_passwd" filedtype="pwd" maxlength=6 pwdlength=6>	
            </TD>
        <%}%> 
    </TR>
           
    <TR id="srv_date" style="display:">
        <TD class=blue>业务起始日期</TD>
        <TD>
            <input name="srv_start" type="text" id="srv_start" v_format="HHmmss" readOnly class="InputGrey" onKeyPress="return isKeyNumberdot(0)" value="<%=dateStr%>" size="20" maxlength="8" v_must=1 v_type="date" > <font class="orange">*</font>
        </TD>
        <TD class=blue>业务结束日期</TD>
        <TD>
            <input name="srv_stop" type="text" id="srv_stop" v_format="HHmmss" readOnly class="InputGrey" onKeyPress="return isKeyNumberdot(0)" value="20500101" size="20" maxlength="8" v_must=1 v_type="date"  readonly> <font class="orange">*</font>
        </TD>
    </TR>
    
    <TR id="credit" style="display:none">
        <TD class=blue>信用度</TD>
        <TD>
            <input name="credit_value" type="text" value="1000" id="credit_value" size="20" maxlength="6" v_must=0 v_type="string" >
            <font class="orange"></font>
        </TD>
        <TD class=blue>信用等级</TD>
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
            System.out.println("手续费出错!");
        }
        %>
        <%if(!(userType.equals("pe"))) {%>
            <TD class=blue>应收手续费</TD>
            <TD >
                <input name="should_handfee" id="should_handfee" class=InputGrey value="<%=handfee2%>" readonly>
            </TD>
            <TD class=blue>实收手续费</TD>
            <TD width="32%">
                <input  name="real_handfee" id="real_handfee" value="0" v_must=0 v_type=money>
            </TD>
        <%}else{%>
            <input type="hidden" name="should_handfee" value="0">
            <input type="hidden" name="real_handfee" value="0">
        <%}%>
    </TR>
    
<TR id="pay_type22">
    <TD class=blue>付款方式</TD>
    <TD>
        <select name='payType' id='payType' onchange='changePayType()'>
            <option value='0'>现金</option>
            <option value='9'>支票</option>
        </select>
        <font class="orange">&nbsp;*</font>
    </TD>
    <TD class=blue>一次性付款金额</TD>
    <TD colspan="1">
        <input name="cashNum" type="text" v_must=1 v_maxlength=8 v_type="string" index="8" value="" readOnly>
        <input name=cash_num type=button id="cash_num" class="b_text" onClick="getCashNum();getGrpUserNo();" onKeyUp="if(event.keyCode==13)getCashNum();getGrpUserNo();" style="cursor：hand" value=查询>
        <font class="orange">*</font>
    </TD>
</TR>

    <tr id="cashPay_div" style="display:''">
        <td class=blue>现金交款</td>
        <td >
            <input type="text" name="cashPay" maxlength="10" readOnly value="">
            <input name="checkPass" id="next5" type="button" onClick="check_cashPay()" class="b_text" value="交款校验">
            <font class="orange">*</font>
        </td>
        <%
        if(cust_price.equals("T")){
        %>
          <td class=blue>应收款项</td>
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
	<td class="blue">票据号码</td>	
	<td><input type="text" id="F10967" name="F10967" maxlength="256" v_must="1" v_type='string' /></td>	
	<td class="blue">供应商名</td>	
	<td><input type="text" id="F10968" name="F10968" maxlength="256" v_must="1" v_type='string' /></td>	
</tr>

<tr id="cashPay_div_add2" style="display:''">
	<td class="blue">入账金额</td>	
	<td><input type="text" id="F10969" name="F10969" maxlength="256" v_must="1" v_type="money"/></td>	
	<td class="blue">票据时间</td>	
	<td><input type="text" id="F10970" name="F10970" maxlength="8"   v_must="1" v_type="date" /></td>	
</tr>

<%}%>
<TBODY>
    <TR id='checkPayTR'> 
        <TD class=blue nowrap> 
            <div align="left">支票号码</div>
        </TD>
        <TD width="32%" nowrap> 
            <input class="button" v_must=0 v_type="0_9" name=checkNo maxlength=20 onkeyup="if(event.keyCode==13)getBankCode();" index="50">
            <font class="orange">*</font>
            <input name=bankCodeQuery type=button class="b_text" style="cursor:hand" onClick="getBankCode()" value=查询>
        </TD>
        <TD class=blue nowrap> 
            <div align="left">银行代码</div>
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
            <div align="left">支票交款</div>
        </TD>
        <TD width=32%>
            <input class="button" v_must=0 v_type=money v_account=subentry name="checkPay" value="0.00" maxlength=15 index="51">
            <font class="orange">*</font> </TD> 
        <TD class=blue> 
            <div align="left">支票余额</div>
        </TD>
        <TD width=32%> 
            <input class="button" name="checkPrePay" value=0.00 readonly>
        </TD>               
    </TR>            
</TBODY>
	
	<TR>
        <TD class=blue>项目合同号</TD>
        <TD width="32%">
            <input type='text' name="cnttId"  maxlength='10' >

        </TD>
        <TD class=blue>产品协议号</TD>
        <TD width="32%">
            <input type='text' name="cptId" maxlength='10' >
            <font class='orange'>*</font>
        </TD>        
    </TR>
           
    <TR>
        <TD class=blue>备注</TD>
        <TD width="82%" colspan="3">
            <input class="InputGrey" name="sysnote" size="60" readonly>
        </TD>
    </TR>
    
    <TR style="display:none">
            <TD class=blue>用户备注</TD>
            <TD width="82%" colspan="3">
            <input name="tonote" size="60" value="<%=workno%>进行操作">
        </TD>
    </TR>
</TABLE>

 <!-----------隐藏的列表--> 
<TABLE cellSpacing=0>
    <TR id="footer">        
        <TD align=center>
        <%
            if (nextFlag==1){
        %>
                <input name="next" class="b_foot"  type=button value="下一步" onclick="nextStep()" disabled>
        <%
            }else {
        %>
                <script>
                    closefields();
                </script>
                <input class="b_foot" name="previous"  type=button value="上一步" onclick="previouStep()" style="display:none">
                <input class="b_foot" name="sure" id="sure" type=button value="确认" onclick="refMain()" >
        <%
            }
        %>
        <%if(!"DL100".equals(openLabel)){%>
            <input class="b_foot" name=back  type=button value="清除" onclick="window.location='f3690_1.jsp'">
        <%}%>
            <input class="b_foot" name="kkkk"  onClick="
            <%if("DL100".equals(openLabel)){%>
                doResume() //yuanqs add 2010-9-2 17:18:18
            <%}else{%>
                removeCurrentTab()
            <%}%>
            " type=button value="关闭">
        </TD>
    </TR>
    <!-------------隐藏域--------------->
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
    
    <!-------------隐藏域--------------->
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
    /*liujian 2012-12-24 14:55:47 二维码业务
    * 1. 设置二维码使用费(元)(10641)表单为不可编辑
    * 2. 设置二维码条数(10639) 和 单条费率（元/条）(10640)的key事件，使 二维码使用费(元) = 二维码条数 × 单条费率（元/条）
    * 3. 二维码条数、单条费率、二维码使用费都必须输入整数
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
            
    		//初始化二维码条数、单条费率、二维码使用费
    		$('#F10641').attr('readOnly',true);
    		$('#F10641').addClass("InputGrey");
	    	setSignalValue($('#F10639'));
	    	setSignalValue($('#F10640'));
	    	setSumValue();
	    	//注册二维码条数键盘事件
	        $('#F10639').keyup(function() {
	            setSignalValue($(this));
	            setSumValue();
	        });
	        //注册单条费率键盘事件
	        $('#F10640').keyup(function() {
	            setSignalValue($(this));
	            setSumValue();
	        });
	        //注册验码设备费事件，只能是整数
	        $('#F10638').keyup(function() {
	            setSignalValue($(this));
	        });
	        //注册一次性开发费用事件，只能是整数
	        $('#F10637').keyup(function() {
	            setSignalValue($(this));
	        });
    	}
    	/*liujian 2013-1-23 10:28:23 关于开发租赁式呼叫中心BOSS系统需求的函 begin*/
    	if('<%=sm_code%>' == 'hj' && $('#catalog_item_id').val() == '214'){
    		$('#F10653').val($('#cust_name').val());
    		$('#F10654').css('display','none');
    		//获取省份名称
    		var packet = new AJAXPacket("f3690_ajax_rent.jsp","正在获得数据，请稍候......");
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
					stm.push('<option value="">请选择</option>');	
					$('#citySelect').append(stm.join(''));
				}else {
					stm.push('<select id="citySelect">');
					stm.push('	<option value="">请选择</option>');	
					stm.push('</select>');
					$('#provSelect').after(stm.join(''));	
				}
    		}else {
    			//获取区号名称
	    		var packet = new AJAXPacket("f3690_ajax_rent.jsp","正在获得数据，请稍候......");
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
    	/*liujian 2013-1-23 10:28:23 关于开发租赁式呼叫中心BOSS系统需求的函 end*/
    });
    
    function doGetProv(packet) {
		var retCode = packet.data.findValueByName("retCode");
		var retMsg = packet.data.findValueByName("retMsg");
		var provArray = packet.data.findValueByName("provArray");
		if(retCode == '000000') {
			var stm = new Array();
			if(provArray && provArray.length > 0) {
				stm.push('<select id="provSelect">');
				stm.push('	<option value="">请选择</option>');
				for(var i = 0,len = provArray.length; i < len; i++) {
					var prov = provArray[i];
					stm.push('<option value="' + prov.code + '">' + prov.name + '</option>');	
				}	
				stm.push('</select>');
			}
			$('#F10654').after(stm.join(''));
		}else {
			rdShowMessageDialog("错误代码:" + retCode + ",错误信息:" + retMsg,0);	
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
			rdShowMessageDialog("错误代码:" + retCode + ",错误信息:" + retMsg,0);	
		}	
    }
    //设置二维码条数、单条费率的值
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
    //计算二维码使用费
    function setSumValue() {
        var first = parseInt($('#F10639').val(),10);
        var second = parseInt($('#F10640').val(),10);
        $('#F10641').val(first * second );
    }
    
            /*
            只支持四个td
           <tr>
                <td>名称1</td>
                <td>表单1</td>
                <td>名称2</td>
                <td>表单2</td>
            </tr>
        */
        function displayNone($parent,idArr) {
            var sgmHtml = new Array();
            /*记录待展示到页面上的html的tr中的td的个数，够四个就添加tr*/
            var oddTd = 0;
            $parent.find('tr').each(function() {
                var tdNum = 0;//记录tr中的第几个td
                var $tr = $(this);
                $tr.find('td').each(function() {
                    tdNum++;
                    var $td = $(this);
                    var $input = $td.find('input');
                    var $select = $td.find('select');
                    var flag = -1;//记录是text还是select
                    var _id = '';//td包含的节点的id
                    if(typeof($input.val()) != 'undefined') {
                        flag = 0;
                        _id = $input.attr('id');
                    }else if(typeof($select.val()) != 'undefined') {
                        flag = 1;
                        _id = $select.attr('id');
                    }
                    if(flag == 0 || flag == 1) {
                        var isHidden = false;
                        //循环idArr，查找一致的id，设置style，并在idArr删除此项
                        for(var i = 0,len = idArr.length; i < len; i++) {
                            if(_id == idArr[i]) {
                                //设置此td 和 前一个td的style=“display ： none”
                                if(tdNum -2 >= 0){
                                    $tr.find('td:eq(' + (tdNum-2)+ ')').css('display','none');
                                }
                                $td.css('display','none');
                                //在idArr删除此项
                                idArr.splice(i, 1);

                                //隐藏显示的不记录oddTd
                                isHidden = true;

                            }
                        }
                        if(!isHidden) {
                            if(oddTd == 0) {
                                sgmHtml.push('<tr>');
                            }
                            oddTd = oddTd + 2;
                        }
                        //添加到html片段
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


    /* liujian 2012-12-24 15:34:48 二维码业务 结束*/
        
	//回顶部处理
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
			$('#F01200').parent().append('<input class="b_text" type="button" value="获取" id="getReqBtn" />');	
		}	
		$('#getReqBtn').click(function() {
			var packet = new AJAXPacket("f3690_ajax_getReq.jsp","正在获得相关信息，请稍候......");
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
	
	// zhouby add for 黑龙江移动iNG ESOP v2.0.02(三期)页面改造内容  2013-11-28
	function validateCallCenter(){
	    var phoneCallCenter = $('#sm_code');
	    var bizType = $('#bizTypeL');
	    
	    if (phoneCallCenter.length > 0 && bizType.length > 0){
	        var phoneCallCenterValue = phoneCallCenter.val();
	        var bizTypeValue = bizType.val();
	        
	        if (phoneCallCenterValue == 'hj' && bizTypeValue == '01'){
	            rdShowMessageDialog('呼叫中心直连业务请到端到端办理！');
	            return false;
	        }
	    }
	    
	    return true;
	}
	
	/*2015/03/05 17:28:15 gaopeng 
			R_CMI_HLJ_guanjg_2015_2109554  关于在ESOPBOSS系统实现IDC关键信息录入功能的需求的函
		*/
		function letItRedFunc(){
			for(var i=10803;i<10816;i++){
				var appendStr = "<font class='orange'>（合同信息录入）</font>";
	  		var F10803CodeObj = $('#F'+i).parent().prev("td");
	  		if(typeof(F10803CodeObj) != "undefined"){
	  			F10803CodeObj.append(appendStr);
	  		}
			}	
		}
	
	$(function(){
			/*2015/03/05 17:28:15 gaopeng 
				R_CMI_HLJ_guanjg_2015_2109554  关于在ESOPBOSS系统实现IDC关键信息录入功能的需求的函
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
