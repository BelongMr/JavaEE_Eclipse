<%
	/********************
	 *version v2.0
	 *开发商: si-tech
	 *author:
	 *update:anln@2009-02-12 页面改造,修改样式
	 *update by qidp @ 2009-04-10 集团页面整合
	 *update by qidp @ 2009-06-02 整合端到端流程
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
	String opName = "集团产品资料变更";	//header.jsp需要的参数  
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

System.out.println("----hejwa------------have_a324----------------->"+have_a324);
	
	ArrayList retArray = new ArrayList();
	String[][] result = new String[][]{};
	String[][] resulta = new String[][]{};
	String[][] resultList = new String[][]{};
	String[][] resultList2 = new String[][]{};
	int resultListLength2=0;

    	//SPubCallSvrImpl callView = new SPubCallSvrImpl();
    	productCfg prodcfg = new productCfg();
	int nextFlag=1; //标记是第一步还是第二步
	String listShow="none";
	
	StringBuffer nameList=new StringBuffer();
	StringBuffer nameValueList=new StringBuffer();
	StringBuffer nameGroupList=new StringBuffer();
	StringBuffer nameListNew=new StringBuffer();
	StringBuffer nameGroupListNew=new StringBuffer();
	
	String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());	
	
	//取运行省份代码 -- 为吉林增加，山西可以使用session
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
	
	
	//得到页面参数
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
	//得到列表操作
	//String action=request.getParameter("action");
	
	/******* add by qidp @ 2009-06-02 整合端到端流程 *******/
	String in_GrpId = request.getParameter("in_GrpId");
	String in_IdNo = request.getParameter("IdNo");
    String in_ChanceId = request.getParameter("in_ChanceId");
    String wa_no = request.getParameter("wa_no1");
    String action = "";
    String openLabel = "";/*添加标志位，link：走端到端流程通过任务控制进入此订购模块；opcode：不走端到端流程，通过opcode打开此页面。*/
	String qryFlag=request.getParameter("qryFlag")==null?"":request.getParameter("qryFlag");
    /*判断接入此模块的方式，并做相应的处理。*/
    if(in_ChanceId != null){//由任务管理接入时，商机编码不为空。
        action = "query";
        openLabel = "link";
        //liujian 2012-9-13 17:56:43 申告
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
	String workNoLimit = "";//工号权限
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
				<!--2015/9/15 15:47:10 gaopeng R_CMI_HLJ_guanjg_2015_2405555@关于行业应用流量包产品BOSS系统、网站升级的函（新增日包）
					新增出参 返回流量包类型，不是流量包的属性没有返回或者为空。
					0-日包，1-月包，2-半年包，3-年包
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
                    rdShowMessageDialog("错误代码：<%=error_code%>错误信息：<%=error_msg%>",0);
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
				//得到数据的行数
				//得到具体数据
			//得到集团用户编码add
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
                            rdShowMessageDialog("取bizCode失败！",0);
                		    history.go(-1);
                        </script>
                <%
                    }
            }
		     	 	
//------------add by hansen-------------
//----得到该用户没有添加的项
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
            /* 适用于行业网关1.0 
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
            /* 适用于行业网关2.0 [备用] */
            
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
				//代码拼串传递到下个页面
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
    
    
    /*begin hejwa add for 判断是否有操作权限 2015-5-29 15:57:18 */
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
	<TITLE>集团产品资料变更</TITLE>	
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
	    		//只有一个0 
	    		if(str_10313_flag=="1"){
	    			$("#F10313").append(" <option value='1' selected>1->全省集团</option>");
	    		}
	    		
	    		if(str_10313_flag=="2"){
	    			$("#F10313").append(" <option value='2' selected>2->全国集团</option>");
	    		}
	    		
	    		if(str_10313_flag=="3"){
	    			$("#F10313").append(" <option value='3' selected>3->本地化省级集团</option>");
	    		}
	    		
	    	}
	    }
	
});		




		onload=function(){	
			
		    var disableStr = "";
		    document.all.in_ChanceId2.value = "<%=in_ChanceId%>";
				/*begin add 对下拉列表中的空值进行处理 for 在CRM系统增加“营销区域”字段的需求@2015/4/22 */
		    if(typeof($("#F10818")) != "undefined"){
					$("#F10818 option").each(function(){
			      if($(this).val() == ""){
			      	$(this).remove();
			      }
			    });
				}
				/*end add 对下拉列表中的空值进行处理 for 在CRM系统增加“营销区域”字段的需求@2015/4/22 */
        <%
            /*****************************
             * 走端到端时，调用服务，获取销售方面传入的数据。
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
        /* begin add for 行业应用流量包BOSS系统变更需求@2014/9/3 */
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
					
					$("select[name='F10685']").each(function(){ //当为赠送非闲时流量包，默认赠送比例一列显示
						if($(this).val() != "F"){
        			$("td[name^='acquScaleTd']").css("display","none");
        		}else{
        			$("td[name^='acquScaleTd']").css("display","");
        		}
					});
        	$("select[name='F10685']").change(function(){
        		if($(this).val() != "F"){
        			$("td[name^='acquScaleTd']").css("display","none");
        		}else{ //赠送非闲时流量
        			$("td[name^='acquScaleTd']").css("display","");
        		}
        	});
<%
        }
        /* end add for 行业应用流量包BOSS系统变更需求@2014/9/3 */
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
         * 走端到端时，根据要求，一些元素不允许修改。
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

/*2015/9/16 9:56:27 gaopeng R_CMI_HLJ_guanjg_2015_2405555@关于行业应用流量包产品BOSS系统、网站升级的函（新增日包）
	流量包信息 下拉列表变更方法
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
     if(retType == "checkPwd") //集团客户密码校验
     {
        if(retCode == "000000")
        {
            var retResult = packet.data.findValueByName("retResult");
            if (retResult == "false") {
    	    	rdShowMessageDialog("客户密码校验失败，请重新输入！",0);
	        	frm.userPassword.value = "";
	        	frm.userPassword.focus();
    	    	return false;	        	
            } else {
                rdShowMessageDialog("客户密码校验成功！",2);
                document.frm.sysnote.value ="集团产品资料变更"+document.frm.idcMebNo.value;
                document.frm.tonote.value = "集团产品资料变更"+document.frm.idcMebNo.value;
                document.frm.next.disabled = false;
            }
         }
        else
        {
            rdShowMessageDialog("客户密码校验出错，请重新校验！");
    		return false;
        }
     }	
	 if(retType == "check_no") //集团用户编码
     {
        if(retCode == "000000")
        {
            var tmp_fld = packet.data.findValueByName("tmp_fld");
            if (tmp_fld == "false") {
    	    	rdShowMessageDialog("集团用户编码校验失败，请重新输入！",0);
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
	 //取流水
	if(retType == "getSysAccept")
     {
        if(retCode == "000000")
        {
            var sysAccept = packet.data.findValueByName("sysAccept");
			document.frm.login_accept.value=sysAccept;
			/*
			var prtFlag=0;
			//prtFlag = rdShowConfirmDialog("是否打印电子免填单？");
			//提交打印界面		
			if (prtFlag==1) {
			var printPage="<%=request.getContextPath()%>/npage/s3691/sGrpPubPrint.jsp?op_code=3517"
														+"&phone_no=" +document.all.idcMebNo.value       
														+"&function_name=集团产品资料变更"   
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
	    	/* begin update 统一免填单样式 for 行业应用流量包新增交易记录类别及新增经分报表的需求@2015/4/16 */
	    	
	    	
	    	
		    var ret = showPrtDlg1("Detail","确实要进行电子免填单打印吗？","Yes");
				if(typeof(ret)!="undefined")
				{
					if((ret=="confirm"))
					{
						if(rdShowConfirmDialog('确认要提交信息吗？')==1)
						{
							doCfm();
						}
					}
					if(ret=="continueSub")
					{
						if(rdShowConfirmDialog('确认要提交信息吗？')==1)
						{
							doCfm();
						}
					}
				}
				else
				{
					if(rdShowConfirmDialog('确认要提交信息吗？')==1)
					{
						doCfm();
					}
				}
				/* end update 统一免填单样式 for 行业应用流量包新增交易记录类别及新增经分报表的需求@2015/4/16 */
      }
        else
        {
                rdShowMessageDialog("查询流水出错,请重新获取！");
				return false;
        }
	 }
}

	function doCfm(){
		var confirmFlag=0;
		confirmFlag = rdShowConfirmDialog("是否提交本次操作？");
		if (confirmFlag==1) {
		 //不打印需要的相应操作
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
	  	//调用公共js得到银行代码
	    if(frm.checkNo.value.trim()== "")
	    {
	        rdShowMessageDialog("请输入支票号码！",0);
	        frm.checkNo.focus();
	        return false;
	    }
	    var getCheckInfo_Packet = new AJAXPacket("getBankCode.jsp","正在获得支票相关信息，请稍候......");
		getCheckInfo_Packet.data.add("retType","getCheckInfo");
	    getCheckInfo_Packet.data.add("checkNo",document.frm.checkNo.value);
		core.ajax.sendPacket(getCheckInfo_Packet);
		getCheckInfo_Packet=null; 
	 }
	function check_HidPwd()
	{
	    var idNo = document.frm.grpIdNo.value;
	    var Pwd1 = document.frm.userPassword.value;
	    var checkPwd_Packet = new AJAXPacket("pubCheckPwdIDC.jsp","正在进行密码校验，请稍候......");
	    checkPwd_Packet.data.add("retType","checkPwd");
		checkPwd_Packet.data.add("idNo",idNo);
		checkPwd_Packet.data.add("Pwd1",Pwd1);
		core.ajax.sendPacket(checkPwd_Packet);
		checkPwd_Packet=null;	
		
	}
	 //下一步
	function nextStep(){
		
		
		
		
		
		if(frm.grpIdNo.value.trim() == "")
	  {
	      rdShowMessageDialog("请输入集团用户编码！");
	      frm.grpIdNo.focus();
	      return false;
	  }
	  	//liujian 2013-1-24 14:10:16 关于开发租赁式呼叫中心BOSS系统需求的函
		//集团产品业务唯一标识==214 && 变更类型==1 则跳转到接入号变更页面
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
	//上一步
	function previouStep(){
		frm.action="f3691_1.jsp";
		frm.method="post";
		frm.submit();
	}
	//打印信息
	function printInfo(printType)
	{
	     var retInfo = "";
	    //getChinaFee(frm1104.sumPay.value);
	    if(printType == "Detail")
	    {	//打印电子免填单
	        retInfo+=document.frm.idcMebNo.value+"|"+"证件号码"+"|";
			retInfo+="<%=new java.text.SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(new java.util.Date())%>"+"|";
			retInfo = retInfo + "15|10|10|0|" +document.frm.idcMebNo.value+ "|";   //手机号	
	        retInfo = retInfo + "5|19|9|0|" + "集团产品资料变更（业务发票）" + "|"; //业务项目    
	 	}  
	 	return retInfo;	
	}
	//显示打印对话框
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
	{  //显示打印对话框 
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
		 
		cust_info+="证件号码："+"<%=iccid%>"+"|";
		cust_info+="集团客户名称："+document.all.custName.value+"|";
		cust_info+="集团用户编号："+document.all.idcMebNo.value+"|";
		
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
        vPayTypeTxt = "现金";
    }else{
        vPayTypeTxt = "支票";
    }
    
  	opr_info += "付款方式：   "+ vPayTypeTxt +"|";
    opr_info += "付费账号：   "+ document.frm.idcMebNo.value +"|";
    
    opr_info += "申请业务：   "+ "集团产品资料变更" +"|";
    opr_info += "操作流水：   "+ document.all.login_accept.value+"|";
    opr_info += "申请产品：   <%=paramsArray[3]%>|";
		
		opr_info += "属性信息：|"
    opr_info += "        ICT业务集成费 "+$("#F10980").val()+"元|";
		opr_info += "        ICT教育信息化集成费 "+$("#F10981").val()+"元|";
		
		note_info1+="备注："+document.all.sysnote.value+"|";
	
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
		 
		cust_info+="证件号码："+"<%=iccid%>"+"|";
		cust_info+="集团客户名称："+document.all.custName.value+"|";
		cust_info+="集团用户编号："+document.all.idcMebNo.value+"|";
		
		opr_info+="申请业务："+"集团产品资料变更"+"|";
		opr_info+="操作流水："+document.all.login_accept.value+"|";
		var arr=[10681,10682,10683,10762,10763,10764,10765,10766,10767,10778,10822,10823,10824,10830,10831,10832];
		for(var j=0;j<arr.length;j++){
			var packFieldCode = "F"+arr[j];
			if(typeof($("#"+packFieldCode).val()) != "undefined"){
				if($("#"+packFieldCode).val().trim() > 0){
					var packFieldName = $("#"+packFieldCode).parent().parent().find("td").eq(2).text();
					if(packFieldName.indexOf("新增") != -1){
						packFieldName = packFieldName.substring(0,packFieldName.length-2);
						opr_info+="购买流量包档位："+packFieldName+"，";
						$("select[name='F10685']").each(function(){ //当为赠送非闲时流量包，默认赠送比例一列显示
							if($(this).val() == "F"){
								opr_info+="购买套餐包个数："+$("#"+packFieldCode).val().trim()+"，";
								var packAcquiescentScale = $("#"+packFieldCode).parent().parent().find("td").eq(5).find("input").val();
								packAcquiescentScale = Math.round(packAcquiescentScale*100)+"%";
	        			opr_info+="回馈比例："+packAcquiescentScale+"。"+"|";
	        		}else{ 
	        			opr_info+="购买套餐包个数："+$("#"+packFieldCode).val().trim()+"。"+"|";
	        		}
						});
					}
				}			
			}
		}
		
		note_info1+="备注："+document.all.sysnote.value+"|";
	
		retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
		retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
	  return retInfo;
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
	//取流水
	function getSysAccept()
	{
		var getSysAccept_Packet = new AJAXPacket("pubSysAccept.jsp","正在生成操作流水，请稍候......");
		getSysAccept_Packet.data.add("retType","getSysAccept");
		core.ajax.sendPacket(getSysAccept_Packet);
		getSysAccept_Packet=null;
	}
	
	function check_mnguser()//验证管理员帐户
{    
	 if(((document.frm.F10303.value).trim()) == "")
    {
        rdShowMessageDialog("管理员用户不能为空！");
        return false;
    } 
    var checkPwd_Packet = new AJAXPacket("../s3690/CheckMng_user.jsp","正在进行密码校验，请稍候......");
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

	
	
			
		if(typeof($("input[name='F10984']").val()) != "undefined" && "<%=flag_10635%>"!="0" ){
				rdShowMessageDialog("请联系A端地市完善“A端结算比例”属性，再进行本操作！");
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
		    	
		    	
				}
				
			});
			if(!retflag){
				return false;
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
		$(".pattern_tr").remove(); 
		
		
		/*关于申请制作集团客户信息化项目(产品)投资和收益自动化匹配报表的函
		* liangyl 2016-07-11
		* F10985
		*/
		
		if(typeof($('#F10985'))!="undefined"&&typeof($('#F10985').val())!="undefined"){
			ajax_check_F10985();
			if($("#F10985").val()!=""&&F10985_flag==0){
				return;
			}
		}
		
		
		
		/* begin add for 行业应用流量包BOSS系统变更需求@2014/9/13 */
		if(typeof($('#F10776'))!="undefined"&&typeof($('#F10776').val())!="undefined"){
			if($('#F10776').val().trim()==""){
				rdShowMessageDialog("客户电话不能为空!",1);
				$('#F10776').focus();
		    return false;	
			}
		}
		var chk_acquiescentScale = true;
		if($("td[name^='acquScaleTd']").css("display") == "block"){ //当“赠送比例”显示时，才进行判断
			if (typeof ($("input[name='acquiescentScale']").val())!="undefined" ){
				$("input[name='acquiescentScale']").each(function(){
					$(this).attr("v_type","money");
					if(!checkElement(this)){
						chk_acquiescentScale = false;
						return false;	
					}
					if("<%=workNoLimit%>" == "0"){//没有权限，需和最大赠送比例进行校验
						var v_fieldCode = $(this).parent().parent().children('td').eq(1).find('input[class=InputGrey]').attr("id");
						v_fieldCode = v_fieldCode.substring(1,v_fieldCode.length);
						
						var v_limitNum = $(this).parent().parent().children('td').eq(3).find('input').val();
												
						if($(this).val() != "" ){
							var checkPwd_Packet = new AJAXPacket("f3691_ajax_getMaxScale.jsp","正在获取最大赠送比例，请稍候......");
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
									rdShowMessageDialog("不能大于最大赠送比例值，请重新填写！",0);
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
 * hejwa 关于5月下旬集团客户部CRM、BOSS系统需求的函-3-流量包3691页面赠送比例文本框设置权限的需求
 * 后台人员 liuming
 * 当流量包赠送类型下选则“赠送非闲时流量”时，选择的各款流量包赠送比例不能为空，为空则报错，提示用户必须输入赠送比例
 * 输入框>0 比例必填 0-1 小数点2位如0.12
 */
		if($("select[name='F10685']").val()=="F"){
			var F10685_S = "";
			$("input[name='acquiescentScale']").each(function(){
				var v_limitName = $(this).parent().parent().children('td').eq(2).text();//流量包名称
				var v_limitNum  = $(this).parent().parent().children('td').eq(3).find('input').val();//新增包数量
				var v_limitPer  = $(this).parent().parent().children('td').eq(5).find('input').val();//赠送比例
				
				if(v_limitNum!=""&&parseInt(v_limitNum)>0){
					if(v_limitPer==""||parseFloat(v_limitPer)>=1||parseFloat(v_limitPer)<0){
						F10685_S = v_limitName;
						return false;//跳出each
					}
				}else{
					$(this).parent().parent().children('td').eq(5).find('input').val("");
				}
			});
			
			if(F10685_S!=""&&chk_acquiescentScale){
				rdShowMessageDialog(F10685_S+"赠送比例必须为0到1之间小数点2位的小数",0);
	      return false;	
			}
		}
		
		
		
		if(chk_acquiescentScale == false){
			return false;
		}
		/* end add for 行业应用流量包BOSS系统变更需求@2014/9/13 */
		
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
		/*liujian 2013-1-30 11:11:19*/ 
		if('<%=paramsArray[9]%>' == 'hj' && '<%=paramsArray[10]%>'=='214'){	
			if(!$('#provSelect').val())	{
				rdShowMessageDialog("请选择企业所在地固话区号！",0);
				return false;
			}
			if(!$('#citySelect').val())	{
				rdShowMessageDialog("请选择企业所在地固话区号！",0);
				return false;
			}
		}
		/*2013/11/29 14:31:56 gaopeng 移动网盘需求 81026只能是移动号码 start*/
		if ( typeof ($("#F81026").val())!="undefined" )
		{
			document.all.F81026.v_type = "smobilePhone";
			if(!checkElement(document.all.F81026)){
				return false;
			}
		}
		/*2013/11/29 14:31:56 gaopeng 移动网盘需求 81026只能是移动号码 end*/
		
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
		
		
		
		if (document.all.qryFlag.value=="qryCptCpm")/*合同协议修改*/
		{
			if (document.all.prodRight.value=="1")
			{
				rdShowMessageDialog("该工号没有权限进行修改!",0);
				return false;
			}
			
			if ( document.all.cntNo.value.len()<10 )
			{
				rdShowMessageDialog("项目合同编号必须是10位!",0);
				return false;
			}	
			
			if (!document.all.cptNo.value.trim()=="")
			{
					if ( document.all.cptNo.value.len()<10  )
					{
						rdShowMessageDialog("产品协议编号必须是10位!",0);
						return false;
					}	
			}

		    document.frm.action="f3691UpdCnttCpt.jsp";
			document.frm.method="post";
		    document.frm.submit();
		}
		
		if (document.all.qryFlag.value=="proProgress")/*产品发展归属修改*/
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
    		    //必须晚于业务起始日期
    		    var vSrvStart = document.frm.srv_start.value;
    		    var vF10330 = document.frm.F10330.value;
    		    
    		    if(document.frm.srv_start.value >= document.frm.F10330.value){
    		    	rdShowMessageDialog("必须晚于业务起始日期!!",0);
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

			var checkFlag; //注意javascript和JSP中定义的变量也不能相同,否则出现网页错误.
			//判断金额
			/*if(!checkElement("real_handfee")) return false;
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
			}*/
			//说明：检测分成两类,一类是数据是否是空,另一类是数据是否合法
			
			
		if (typeof ($("#F10980").val())!="undefined" ){
			v_F10980 = $("#F10980").val();
			
			if(v_F10980.indexOf(".")==-1){
				$("#F10980").val($("#F10980").val()+".00");
			}else{
				var t_arr = v_F10980.split(".");
				if(t_arr[1].length!=2){
					rdShowMessageDialog("ICT业务集成费精确到小数点2位");
					return;
				}
			}
			
			
			if(parseInt(v_F10980)<0){
				rdShowMessageDialog("ICT业务集成费不能输入负数");
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
					rdShowMessageDialog("ICT教育信息化集成费精确到小数点2位");
					return;
				}
			}
			
			
			if(parseInt($("#F10981").val())<0){
				rdShowMessageDialog("ICT教育信息化集成费不能输入负数");
				return;
			}
		}
		
		
			getSysAccept()
	}
	//判断集团用户编码是否存在
	function GetIdcMebNo2()
	{
		var my_Packet = new AJAXPacket("fpubcheck_no.jsp","正在检验集团用户编码，请稍候......");
		my_Packet.data.add("grpOutNo",document.frm.grpOutNo.value);
		my_Packet.data.add("retType","check_no");
		core.ajax.sendPacket(my_Packet);
		my_Packet=null
	}
	//获得主套餐
	function GetIdcMebNo()
	{
		var pageTitle = "IDC成员编码查询";
	    	var fieldName = "成员用户ID|成员编码|业务类型";
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
		var selType = "S";    //'S'单选；'M'多选
		var retQuence = "1|1";
		var retToField = "idcMebNo";
		var returnNum="3";
		PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,returnNum);
	}

	//调用公共界面，进行集团客户选择
	function getCptCpmIfo(flag)
	{
 if (flag == '2'){
		  document.all.qryFlag.value="proProgress";
	  } else {
	    document.all.qryFlag.value="qryCptCpm";
	  }
	    var pageTitle = "集团客户选择";
	    var fieldName = "证件号码|客户ID|客户名称|用户ID|用户编号 |用户名称|产品代码|产品名称|集团编号|付费帐户|品牌名称|品牌代码|";
		var sqlStr = "";
	    var selType = "S";    //'S'单选；'M'多选
	    var retQuence = "12|0|1|2|3|4|5|6|7|8|9|10|11|";
	    var retToField = "iccid|cust_id|cust_name|grpIdNo|user_no|grp_name|product_code2|product_name2|unit_id|account_id|sm_name|sm_code|";
	    var cust_id = document.frm.cust_id.value;
	    if(document.frm.iccid.value == "" &&
	       document.frm.cust_id.value == "" &&
	       document.frm.unit_id.value == "" &&
	       document.frm.user_no.value == "")
	    {
	        rdShowMessageDialog("请输入证件号码、客户ID、集团编号或集团号进行查询！",0);
	        document.frm.iccid.focus();
	        return false;
	    }
	
	    if(document.frm.cust_id.value != "" && forNonNegInt(frm.cust_id) == false)
	    {
	    	frm.cust_id.value = "";
	        rdShowMessageDialog("必须是数字！",0);
	    	return false;
	    }
	
	    if(document.frm.unit_id.value != "" && forNonNegInt(frm.unit_id) == false)
	    {
	    	frm.unit_id.value = "";
	        rdShowMessageDialog("必须是数字！",0);
	    	return false;
	    }
	
	    if(document.frm.user_no.value == "0")
	    {
	    	frm.user_no.value = "";
	        rdShowMessageDialog("集团号不能为0！",0);
	    	return false;
	    }
	
	    PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField); 
	}

	function getInfo_Cust()
	{
			document.all.qryFlag.value="qryCust";
	    var pageTitle = "集团客户选择";
	    var fieldName = "证件号码|客户ID|客户名称|用户ID|用户编号 |用户名称|产品代码|产品名称|集团编号|付费帐户|品牌名称|品牌代码|";
		var sqlStr = "";
	    var selType = "S";    //'S'单选；'M'多选
	    var retQuence = "12|0|1|2|3|4|5|6|7|8|9|10|11|";
	    var retToField = "iccid|cust_id|cust_name|grpIdNo|user_no|grp_name|product_code2|product_name2|unit_id|account_id|sm_name|sm_code|";
	    var cust_id = document.frm.cust_id.value;
	    if(document.frm.iccid.value == "" &&
	       document.frm.cust_id.value == "" &&
	       document.frm.unit_id.value == "" &&
	       document.frm.user_no.value == "")
	    {
	        rdShowMessageDialog("请输入证件号码、客户ID、集团编号或集团号进行查询！",0);
	        document.frm.iccid.focus();
	        return false;
	    }
	
	    if(document.frm.cust_id.value != "" && forNonNegInt(frm.cust_id) == false)
	    {
	    	frm.cust_id.value = "";
	        rdShowMessageDialog("必须是数字！",0);
	    	return false;
	    }
	
	    if(document.frm.unit_id.value != "" && forNonNegInt(frm.unit_id) == false)
	    {
	    	frm.unit_id.value = "";
	        rdShowMessageDialog("必须是数字！",0);
	    	return false;
	    }
	
	    if(document.frm.user_no.value == "0")
	    {
	    	frm.user_no.value = "";
	        rdShowMessageDialog("集团号不能为0！",0);
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
	//liujian 添加obj入参，从f3691_sel.jsp返回
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
	    //liujian 2013-1-24 13:55:59 关于开发租赁式呼叫中心BOSS系统需求的函
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
    	   
    	var str=window.showModalDialog('group_flags.jsp?flags='+document.frm.F10315.value+'&sm_code=<%=paramsArray[9]%>',"",prop);/*diling add for 增加品牌参数@2012/11/6 */
    	   
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
 * hejwa 关于5月下旬集团客户部CRM、BOSS系统需求的函-3-流量包3691页面赠送比例文本框设置权限的需求
 * 后台人员 liuming
 * 判断工号权限 有此权限的工号在3691可以看到个选项。没有权限，则只能看到无赠送
 */
$(document).ready(function(){
	
	if (typeof ($("#F10984").val())!="undefined" )
		{
			$("input[name='F10984']").each(function(){
				
				var vF810311 = $.trim($(this).val());
				/*没值的时候可以修改 */
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
			//2=关  1=开
			var F10954_selected = "<%=F10954_selected%>";
			
			if("2"==F10954_selected){
				$(this).find('#F10954').empty();
				$(this).find('#F10954').append("<option selected value='1'>1--开</option><option  value='2' selected>2--关</option>");
			}else{
				/*获取权限a324*/
				if("<%=have_a324%>" == "true"){
					$(this).find('#F10954').empty();
					$(this).find('#F10954').append("<option selected value='1' selected>1--开</option><option  value='2'>2--关</option>");
				}else{
					$(this).find('#F10954').empty();
					$(this).find('#F10954').append("<option selected value='1'>1--开</option>");
				}
			}
		}
	}
	
		if(smCode.trim() == "JJ"){
		if(typeof($(this).find('#F10957').val()) != "undefined" ){
			//界面判断如果服务输出属性代码为10957时，需要在属性名称后面增加红色提醒字体
			$(this).find('#F10957').parent().prev().html("话费红包限时赠送<font class='orange'>(9:00-11:00)</font>");
			
			//2=关  1=开
			var F10957_selected = "<%=F10957_selected%>";
			if("2"==F10957_selected){
				$(this).find('#F10957').empty();
				$(this).find('#F10957').append("<option selected value='1'>1--开</option><option  value='2' selected>2--关</option>");
			}else{
				/*获取权限a324*/
				if("<%=have_a325%>" == "true"){
					$(this).find('#F10957').empty();
					$(this).find('#F10957').append("<option selected value='1' selected>1--开</option><option  value='2'>2--关</option>");
				}else{
					$(this).find('#F10957').empty();
					$(this).find('#F10957').append("<option selected value='1'>1--开</option>");
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
	
	if("<%=operFlag%>"=="true"){//有权限，不变
		
	}else{//无权限，隐藏一个选项，把赠送比例列也隐藏
		$("select[name='F10685']").find("option[value='F']").remove();
		$("td[name^='acquScaleTd']").css("display","none");
	}
	
	$("select[name='F10833']").change(function(){
		var optionVal = $(this).find("option:selected").val();
		/*如果选择了是，同时没有权限*/
		if("<%=haveA323%>" != "true" && optionVal == "1"){
			rdShowMessageDialog("该工号不具有“集团话费加油包特殊权限”!,选项“每月是否赠送超过10万”不可以选择“1--是”。");
			$("select[name='F10833']").find("option[value='0']").attr("selected",true);
			return false;
		}
		
	});
	
	
	
	/*
	 * 部分后付费集团产品实现账期录入和信控功能的业务需求
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
		
		if(div_obj.text()=="该用户需要新增的项"){
			
			val_F10817 = "12";
			val_F10975 = "<%=db_cu_date%>";
			
			$("select[name='F10817']").val(val_F10817);
			$("input[name='F10975']").val(val_F10975);
								
		}
		
		
		$("select[name='F10817']").change(function(){
					  var a_Packet = new AJAXPacket("f3691_ajax_checkF10817.jsp","请稍候......");
					  a_Packet.data.add("ID_NO",document.frm.grpIdNo.value);
					  core.ajax.sendPacket(a_Packet,function(packet){
							var ret_val = packet.data.findValueByName("ret_val");
							if(parseFloat(ret_val)>0){
								
								var smCode = '<%=paramsArray[9]%>';
	
								if(smCode.trim() == "RH"){
									//不提示
								}else{
			
									rdShowMessageDialog("该账户已经欠费，不允许发起缴费周期变更，请及时缴费！");
									$("select[name='F10817']").val(val_F10817);
									$("input[name='F10975']").val(val_F10975);
								}
							}else{
								$("input[name='F10975']").val("<%=db_cu_date%>");
							}
					  });
					  a_Packet = null;
		});
		
		
		
		
		//新增 信控开始时间 只读，当前时间 缴费周期默认成年   
		
		//修改 信控开始时间 只读，默认查出来的时间，没有为当前时间，缴费周期默认查询数据
		
		
		//3690
		//新增 信控开始时间 只读，缴费周期默认成年
		
		
		
		
		
		
	/*关于集团业务大检查中系统实现需求的函-4-关于ESOP中上线产品合同管理功能的需求
	 * hejwa 2016-6-8 15:47:44
	 * F10807
	 */
	 if (typeof ($("#F10807").val())!="undefined" ){
	 	$("#F10807").parent().append("&nbsp;<input type='button' class='b_text' value='校验' onclick='ajax_check_F10807()' />"); 
	 }
	 
	 /*关于申请制作集团客户信息化项目(产品)投资和收益自动化匹配报表的函
	 * liangyl 2016-07-11
	 * F10985
	 */
	if (typeof ($("#F10985").val())!="undefined" ){
		$("#F10985").parent().append("&nbsp;<input type='button' class='b_text' value='校验' onclick='ajax_check_F10985()' />"); 
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
													 "<td class='blue'>ICT业务集成费历史</td>"+
													 "<td><input type='text' id='F10980_add' value='"+$('#F10980').val()+"' disabled></td>"+
													 "<td class='blue'>ICT教育信息化集成费历史</td>"+
													 "<td><input type='text' id='F10981_add'  value='"+$('#F10981').val()+"' disabled></td>"+
													 "</tr>"+
													 "<tr>"+
													 "<td class='blue'>ICT业务集成费历史年月</td>"+
													 "<td><input type='text' id='F10982_add' value='"+v_F10982+"' disabled></td>"+
													 "<td class='blue'>ICT教育信息化集成费历史年月</td>"+
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
				rdShowMessageDialog("请输入合同编号");
				return;
		}
	  var packet = new AJAXPacket("../s3690/ajax_check_F10807.jsp","请稍后...");
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
    		rdShowMessageDialog("“合同编码”未成功归档或输入错误，请核对后重新录入");
    		$("#F10807").val("");
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

</script>
</HEAD>
<BODY>
	<FORM action="" method="post" name="frm" >
		<%@ include file="/npage/include/header.jsp" %>     	
		<div class="title">
			<div id="title_zi">集团用户资料变更</div>
		</div>	
		<input type="hidden" name="product_code" value="">
		<input type="hidden" name="product_level"  value="1">
		<input type="hidden" name="op_type" value="1">
		<input type="hidden" name="grp_no" value="0">
		<input type="hidden" name="tfFlag" value="n">
		<input type="hidden" name="chgpkg_day"   value="">
		<input type="hidden" name="TCustId"  value="">
		<input type="hidden" name="unit_name"  value="">
		<input type="hidden" name="login_accept"  value="0"> <!-- 操作流水号 -->
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
            <td class="blue">查询方式</td>
            <td colspan="3">
              <select id="queryType">
                 <option value="0">产品属性查询</option>
                 <option value="1">协议合同查询</option>    
                 <option value="2">产品发展归属查询</option>
              </select>
            </td>
          </tr>
          <%}%>
	    <TR>
	        <TD width="18%" class="blue">
	              证件号码
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
                	style="cursor：hand" value=查询 
                <%
                    if (action!=null&&action.equals("query")){
                        out.print(" disabled ");
                    }
                %>
                >
                     
                
            </TD>
            <TD width="18%" class="blue">集团客户ID</TD>
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
               集团编号
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
            <TD class="blue" width="18%">集团号或智能网编号</TD>
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
	     <TD width=18% nowrap class="blue"> 集团用户ID</TD>
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
		<TD class="blue">集团产品密码</TD>
            <TD >
           	<%if(!ProvinceRun.equals("20"))  //不是吉林
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
            <input name=chkPass type=button onClick="check_HidPwd();"  class="b_text" style="cursor：hand" id="chkPass" value=校验>
	    <font class="orange">*</font>
	   </TD>
	</TR>
	<!-- liujian 2013-1-24 14:01:34 关于开发租赁式呼叫中心BOSS系统需求的函 -->
	<tr id="changeTypeTr" style="display:none">
		<td class="blue">变更类型</td>
		<input type="hidden" value="" id="uniqueStatus" />
		<td>
			<select id="changeType">
				<option value="0">属性变更</option>	
				<option value="1">接入号变更</option>	
			</select>
		</td>
		<td></td>
		<td></td>
	</tr>
        </TABLE>
	<!---- 隐藏的列表-->
        <TABLE  cellSpacing=0  style="display:<%=listShow%>">
	   <TR>
            <TD width="18%" class="blue">
              集团用户号码
            </TD>
            <TD width="32%">
                <input name="idcMebNo" class="InputGrey" id="idcMebNo" size="24" maxlength="18" v_type="string" v_must=1  index="1" value="<%=paramsArray[1]%>" readonly>
                <font class="orange">*</font>
            </TD>
	    <TD width=18% class="blue">客户名称</TD>
            <TD width="32%">
              <input name=custName class="InputGrey"  id="custName" size="24" maxlength="10" v_type="0_9" v_must=1  index="3" value="<%=paramsArray[4]%>" readonly>
            </TD>
          </TR>
          <TR>
            <TD width="18%" class="blue">品牌名称</TD>
            <TD width="32%">
              <input  name="smName" size="24" readonly v_must=1 v_type=string class="InputGrey"  index="4" value="<%=paramsArray[2]%>" readonly>
            </TD>
            <TD class="blue">产品名称</TD>
            <TD>
              <input  name="smName" size="24" readonly v_must=1 v_type=string class="InputGrey"  index="4" value="<%=paramsArray[3]%>" readonly>
            </TD>
          </TR>
          </TABLE>
         
		  
	<%
		System.out.println("$$$$$$$$$$$$$$$$$$$$$$111111");
		//为include文件提供数据
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
		//为include文件提供数据
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
		//为include文件提供数据  
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
		  //集团产品发展归属查询
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
      			<div id="title_zi">集团产品发展归属信息</div>
      		</div>
      	
      		<table cellSpacing=0>
      			<td class='blue' width="14%">集团当前发展归属</td>
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
			<div id="title_zi">项目合同产品协议信息</div>
		</div>	
		<TABLE  cellSpacing=0 id= 'tabCnttCpt' name= 'tabCnttCpt' style="display:<%=ccDisp%>" >
			<td class='blue'>项目合同编号</td>
			<td>
				<input type='text' name='cntNo' value='<%=ccrst[0][1]%>' maxlength='10'>
				<font class='orange'>*</font>
			</td>
			<td class='blue'>产品协议编号</td>
			<td>
				<input type='text' name='cptNo' value='<%=ccrst[0][0]%>'maxlength='10'>
				<input type="hidden" name="prodOpenTime" value='<%=ccrst[0][6]%>' >
				<!--权限标识-->
				<input type="hidden" name="prodRight" value='<%=ccrst[0][2]%>' >
				<!--## 5	oCnttCode		合同父编号-->
				<input type="hidden" name="oCnttCode" value='<%=ccrst[0][3]%>' >
				<!--## 6	oCptCode		协议父编号-->
				<input type="hidden" name="oCptCode" value='<%=ccrst[0][4]%>' >
				<!--## 7	oUnitId			集团编号-->
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
			
				<TD width="18%" class="blue">应收手续费</TD>
				<TD width="32%">
				<input  name="should_handfee" id="should_handfee" value="<%=result_hand%>" readonly>
				</TD>
				<TD width="18%" class="blue">实收手续费</TD>
				<TD width="32%">
				<input  name="real_handfee" id="real_handfee" value="0" v_must=0  v_type=money>
			    </TD>
		   </TR>
		   <TR style='display:none'>
				<TD width="18%" class="blue">付款方式</TD>
				<TD width="32%" colspan="3">
				        <select name='payType' onchange='changePayType()'>
					<option value='1'>现金</option>
					<option value='2'>支票</option>
					</select><font class="orange">*</font>
				</TD>
		 </TR>
		<TR id='checkPayTR' style="display:none"> 
	                <TD width="18%" nowrap class="blue"> 
	                   支票号码
	                </TD>
	                <TD width="32%" nowrap> 
	                    <input  v_must=0  v_type="0_9" name=checkNo maxlength=20 onkeyup="if(event.keyCode==13)getBankCode();" index="50">
	                    <font class="orange">*</font>
			    <input name=bankCodeQuery type=button  class="b_text" style="cursor:hand" onClick="getBankCode()" value=查询>
			</TD>
	                <TD width="18%" nowrap class="blue"> 
	                    银行代码
	                </TD>
	                <TD width="32%" nowrap> 
	                    <input name=bankCode size=12  maxlength="12" readonly>
			    <input name=bankName size=20  readonly>
	                </TD>                                              
            </TR>
	    <TR  id='checkShow' style='display:none'> 
                  <TD width=18% nowrap class="blue"> 
                    支票交款
                  </TD>
            	<TD width="32%">
              	    <input v_must=0  v_type=money v_account=subentry name=checkPay value=0.00 maxlength=15 index="51" >
                    <font class="orange">*</font> </TD> 
                  <TD width=18% class="blue"> 
                    支票余额
                  </TD>
                  <TD width=32%> 
                    <input  name="checkPrePay" value=0.00 readonly>
                  </TD>               
            </TR>

<tbody id="vpmn_flag" style="display:none">
<TR>
<TD class="blue">集团名称</TD>
<TD>
<input name="group_name" type="text"  id="group_name" readOnly class="InputGrey">
</TD>
<TD class="blue">集团所在省区号</TD>
<TD>
<input  name="province" type="text" id="province" readonly class="InputGrey">
</TD>
</TR>  
<TR>
<TD class="blue">业务起始日期</TD>
<TD>
<input name="srv_start" type="text" id="srv_start" onKeyPress="return isKeyNumberdot(0)" readonly class="InputGrey">
</TD>
<TD class="blue">业务终止日期</TD>
<TD>
<input name="srv_stop" type="text"id="srv_stop" onKeyPress="return isKeyNumberdot(0)">
</TD>
</TR>
<TR>
<TD class="blue">联系人姓名</TD>
<TD>
<input name="contact" type="text" id="contact" maxlength = 18 value="">
</TD>
<TD class="blue">集团联系电话</TD>
<TD>
<input name="telephone" type="text" id="telephone" onKeyPress="return isKeyNumberdot(0)">
</TD>
</TR>
<TR>
<TD class="blue">集团联系地址</TD>
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
		<TD width="18%" class="blue">备注</TD>
		<TD colspan="3">
		<input  name="sysnote" size="60" value="集团产品资料变更" readonly class="InputGrey" >
		</TD>
		</TR>    
	<%
	}
	else
	{
	%>
		<TR style='display:none'>
		<TD width="18%" class="blue">备注</TD>
		<TD colspan="3">
		<input  name="sysnote" size="60" value="集团产品资料变更" readonly class="InputGrey" >
		</TD>
		</TR>    
	<%	
	}
	%>
       </TABLE>
 <!-----------隐藏的列表-->
        <TABLE cellSpacing="0">        
            <TR>
              <TD id="footer">
			 <%
			 if (nextFlag==1){
			 %>
			 &nbsp;
			  <input name="next" id="next"  type=button class="b_foot" value="查询" onclick="nextStep()" >
			 <%
			 }else {
			 %>			
			 &nbsp;
			  <input  name="previous"  class="b_foot" type=button value="上一步" onclick="previouStep()" style="display:none">
			  &nbsp;

					<input  name="sure"  class="b_foot" type=button value="修改" onclick="refMain('3202')"  /> 
			  
			  
<%
				if ("vp".equals(paramsArray[9])) {
%>
					&nbsp;<input  name="sure22"  class="b_foot" type=button value="激活" onclick="refMain('3204')"  >
					&nbsp;<input  name="sure33"  class="b_foot" type=button value="去激活" onclick="refMain('3205')"  >
<%
				} else if ("j1".equals(paramsArray[9])) {	//wanghfa添加 2010-12-7 14:57 集团总机接入BOSS系统需求
%>
					&nbsp;<input  name="sure22"  class="b_foot" type=button value="暂停" onclick="refMain('3204')"  >
					&nbsp;<input  name="sure33"  class="b_foot" type=button value="恢复" onclick="refMain('3205')"  >
<%
				}
%>
			 <%
			 }
			 %>
              		&nbsp; 
              		<input  name=back  class="b_foot" type=button value="清除" onclick="window.location='f3691_1.jsp'">
			&nbsp;
              		<input  name="kkkk"  class="b_foot" onClick="removeCurrentTab()" type=button value="关闭">
              	     </TD>
            </TR>	
        </TABLE>
      			<!-------------隐藏域--------------->
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
			<input type="hidden" name="tonote" size="60" value="集团产品资料变更">
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
			<!-------------隐藏域--------------->
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
    /*liujian 2012-12-24 14:55:47 二维码业务
    * 1. 设置二维码使用费(元)(10641)表单为不可编辑
    * 2. 设置二维码条数(10639) 和 单条费率（元/条）(10640)的key事件，使 二维码使用费(元) = 二维码条数 × 单条费率（元/条）
    * 3. 二维码条数、单条费率、二维码使用费都必须输入整数
    */
    $(function() {
    	var smCode = '<%=paramsArray[9]%>';
    	
  		/*2015/03/05 17:28:15 gaopeng 
				R_CMI_HLJ_guanjg_2015_2109554  关于在ESOPBOSS系统实现IDC关键信息录入功能的需求的函
			*/
    	letItRedFunc();	
    		
    	if($.trim(smCode) == 'EW') {
    		//初始化二维码条数、单条费率、二维码使用费
    		$('#F10641').attr('readOnly',true);
    		$('#F10641').addClass("InputGrey");
    		
	    	setSignalValue($('#F10639'));
	    	setSignalValue($('#F10640'));
	    	setSignalValue($('#F10642'));
	    	setSignalValue($('#F10643'));
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
	        $('#F10642').keyup(function() {
	            setSignalValue($(this));
	        });
	        //注册一次性开发费用事件，只能是整数
	        $('#F10643').keyup(function() {
	            setSignalValue($(this));
	        });
    	}
    	var cityCode = '';
    	if($.trim(smCode).toLowerCase() == 'hj' && '<%=paramsArray[10]%>'=='214') {
    		if($('#F10652').val()) {
    			$('#F10652').parent().append("<br><span>填写本产品已有接入号，当接入号数大于1个时可变更</span>");	
    		}
    		$('#F10654').css('display','none');
    		cityCode = $('#F10654').val();
    		
    		//获取省份名称
    		var packet = new AJAXPacket("../s3690/f3690_ajax_rent.jsp","正在获得数据，请稍候......");
	        packet.data.add("method","getProv");
	        core.ajax.sendPacket(packet,doGetProv);
	        packet = null;	
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
		    		var packet = new AJAXPacket("../s3690/f3690_ajax_rent.jsp","正在获得数据，请稍候......");
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
	    	//通过城市code获取省份code
    		//获取省份名称
    		var codepacket = new AJAXPacket("../s3690/f3690_ajax_rent.jsp","正在获得数据，请稍候......");
	        codepacket.data.add("method","getProvCode");
	        codepacket.data.add("cityCode",cityCode);
	        core.ajax.sendPacket(codepacket,doGetProvCode);
	        codepacket = null;	
    	}
    	
    });
    //获取所有的省份，设置省份下拉框
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
    //获取某个省份下所有的城市，设置城市下拉框
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
			rdShowMessageDialog("错误代码:" + retCode + ",错误信息:" + retMsg,0);	
		}	
    }
    //获取对应的省份，设置省份下拉框
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
    /* liujian 2012-12-24 15:34:48 二维码业务 结束*/
    
  


$(document).ready(function (){
	
	
	var smCode = '<%=paramsArray[9]%>';
	
	if(typeof($('#F10817'))!="undefined"&&typeof($('#F10817').val())!="undefined"){
		if(smCode.trim() == "RH"){
			//3 1 不能变到 6 12 
			//3 1 不能互相变
			var old_F10817_value=$("#F10817").val();
			//alert("old_F10817_value=["+old_F10817_value+"]");
			
			$("#F10817").change(function (){
				var new_F10817_value=$("#F10817").val();
				//alert("new_F10817_value=["+new_F10817_value+"]");
				
				if(old_F10817_value=="1"||old_F10817_value=="3"){
					if(new_F10817_value=="6"||new_F10817_value=="12"){
						rdShowMessageDialog("不允许修改为半年、年，请重新填写");
						$("#F10817").val(old_F10817_value);
					}
				}
				
				if(old_F10817_value=="6"){
					if(new_F10817_value=="12"){
						rdShowMessageDialog("不允许修改为半年、年，请重新填写");
						$("#F10817").val(old_F10817_value);
					}
				}
				
				
				if(old_F10817_value=="12"){
					if(new_F10817_value=="6"){
						rdShowMessageDialog("不允许修改为半年、年，请重新填写");
						$("#F10817").val(old_F10817_value);
					}
				}
				
				
			});
			
		}
	}
	
	
	
});
</script>