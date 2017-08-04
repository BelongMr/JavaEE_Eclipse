<%
    /********************
     * @ OpCode    :  7983
     * @ OpName    :  集团成员增加
     * @ CopyRight :  si-tech
     * @ Author    :  qidp
     * @ Date      :  2009-10-20
     * @ Update    :  
     ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ include file="../../npage/public/checkPhone.jsp" %>


<%!
		/**
     * 在日期上增加数个整月
     */
    public static Date addMonthPub(Date date, int n) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.MONTH, n);
        return cal.getTime();
    }
    
    /**
     * 使用参数Format格式化Date成字符串
     */
    public static String formatPub(Date date, String pattern) {
        String returnValue = "";

        if (date != null) {
            SimpleDateFormat df = new SimpleDateFormat(pattern);
            returnValue = df.format(date);
        }

        return (returnValue);
    }

%>
<%
    String opCode = "7983";
    String opName = "集团成员增加";
    String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
    Logger logger = Logger.getLogger("f7983_1.jsp");
    String dateStr2 = "";
    String levelFlag = "";//liujian 便于fpubDynaFields.jsp读取
    Date date = new Date();
    SimpleDateFormat df = new SimpleDateFormat("yyyyMM");
    GregorianCalendar gc = new GregorianCalendar();
    gc.setTime(date); 
    gc.add(2,1);
    gc.set(gc.get(gc.YEAR),gc.get(gc.MONTH),gc.get(gc.DATE));
    String beginDate=df.format(gc.getTime())+"01";
    gc.add(1,1);
    String endDate=df.format(gc.getTime())+"01";
    System.out.println("xxxxxxxxxxxxxxxx"+beginDate);
    System.out.println("xxxxxxxxxxxxxxxx"+endDate);
    
     /*获取当前时间*/
    Date nowTime = new Date();
    /*当前时间增加1个月*/
    Date addMonthT = addMonthPub(nowTime,1);
    /*增加1个月*/
    String addMonthTStr = formatPub(addMonthT,"yyyyMM");
    
    String workNo = WtcUtil.repNull((String)session.getAttribute("workNo"));
    String workName = WtcUtil.repNull((String)session.getAttribute("workName"));
    String workPwd = WtcUtil.repNull((String)session.getAttribute("password"));
    String regionCode = WtcUtil.repNull((String)session.getAttribute("regCode"));
    String orgCode = WtcUtil.repNull((String)session.getAttribute("orgCode"));
    String powerRight = WtcUtil.repNull((String)session.getAttribute("powerRight"));
    String groupId = WtcUtil.repNull((String)session.getAttribute("groupId"));
    String districtCode = orgCode.substring(2,4);
    
    String busiFlag = WtcUtil.repNull(request.getParameter("busiFlag")); 
    String phoneHeader = WtcUtil.repNull(request.getParameter("phoneHeader")); 
    
    String fileExplain="文件说明:一个号码一行(注意：上传文件格式必须为文本文件，不支持EXCEL格式上传文件)。每次最多50个,彩铃30个。";
    System.out.println(" zhouby busiFlag"+busiFlag);
    System.out.println(" zhouby phoneHeader"+phoneHeader);
    
    String showExplain = "&nbsp;&nbsp; 6位短号码|11位成员用户号码|";
    String showExplain2 = "&nbsp;&nbsp; 6位短号码|11位成员用户号码|联系人姓名|联系电话|是否开通移动固话（“是”或“否”）|固话对应的手机号码（11位）|";
    
    /*begin wanghyd add for 判断是否有优惠类操作权限@2012/11/6 */
  String[][] temfavStr = (String[][])session.getAttribute("favInfo");
	String[] favStr = new String[temfavStr.length];
	boolean operFlag = false;
	
	String a290_flag = "false";
	for(int i = 0; i < favStr.length; i ++) {
		favStr[i] = temfavStr[i][0].trim();
	}
	if (WtcUtil.haveStr(favStr, "a385")) {
		operFlag = true;
	}
	
	if (WtcUtil.haveStr(favStr, "a290")) {
		a290_flag = "true";
	}
	
	 /*end wanghyd add @2012/11/6 */
    
    String[][] result = new String[][]{};
    String[][] payArr = new String[][]{};
    String[][] packArr = new String[][]{};
    String[][] resultList = new String[][]{};
    int resultListLength=0;
    
    String nextFlag = "1";
    String iIccid = "";
    String iUnitId = "";
    String iCustId = "";
    String iServiceNo = "";
    String iProductId = "";
    String iAccountId = "";
    String iSmCode = "";
    String iSmName = "";
    String iBelongCode = "";
    String iProductPwd = "";
    String iRequestType = "";
    String id_no = "";
    String listShow="none";
    String iMonthFlag = "";
    String iUserType = "";
    String iGrpName = "";
    String iProductName = "";
    String zhwwFlag = "";
    String iMaxTermNum = "";
    String iAddTermNum = "";
    String iUseTermNum = "";
    String limitcount = "";
    String arcFlag = "";
    
    /*begin 定义客户经理工号和姓名、集团类别 变量 by diling*/
    String iCustManagerNoHiden = "";
    String iCustManagerNameHiden = "";
    String iUnitTypeHiden = "";
    /*end add by diling*/
    /*begin 定义目前占比、上限占比、可添加智能网成员数、地市 变量 by diling@2012/6/12 */
    String iPreProportionHiden = "";
    String iHighestLimitHiden = "";
    String iAddVpMemberHiden = "";
    String iRegionNameHiden = "";
    /*end add by diling*/
    String uniqueStatus = "";
	String iBizCode = ""; //wanghao add
    String action = WtcUtil.repNull((String)request.getParameter("action"));
    /* 点击"下一步"后，进行处理。 */
    if("next".equals(action)){
        nextFlag = "2";
        iIccid = WtcUtil.repNull((String)request.getParameter("iccid"));
        iCustId = WtcUtil.repNull((String)request.getParameter("cust_id"));
        iUnitId = WtcUtil.repNull((String)request.getParameter("unit_id"));
        iServiceNo = WtcUtil.repNull((String)request.getParameter("service_no"));
        iProductId = WtcUtil.repNull((String)request.getParameter("product_id"));
        iAccountId = WtcUtil.repNull((String)request.getParameter("account_id"));
        iSmCode = WtcUtil.repNull((String)request.getParameter("sm_code"));
        //iSmCode = "vp";
        iSmName = WtcUtil.repNull((String)request.getParameter("sm_name"));
        id_no = WtcUtil.repNull((String)request.getParameter("id_no"));
        iBelongCode = WtcUtil.repNull((String)request.getParameter("belong_code"));
        iProductPwd = WtcUtil.repNull((String)request.getParameter("product_pwd"));
        iRequestType = WtcUtil.repNull((String)request.getParameter("request_type"));
        iMonthFlag = WtcUtil.repNull((String)request.getParameter("month_flag"));
        iGrpName = WtcUtil.repNull((String)request.getParameter("grp_name"));
        iProductName = WtcUtil.repNull((String)request.getParameter("product_name"));
        iMaxTermNum = WtcUtil.repNull((String)request.getParameter("max_term_num_tmp"));
        iAddTermNum = WtcUtil.repNull((String)request.getParameter("add_term_num_tmp"));
        iUseTermNum = WtcUtil.repNull((String)request.getParameter("use_term_num_tmp"));
        limitcount = WtcUtil.repNull((String)request.getParameter("limitcount"));
        
        /*begin add by diling@2012/5/14 */
        iCustManagerNoHiden = WtcUtil.repNull((String)request.getParameter("custManagerNoHiden"));
        iCustManagerNameHiden = WtcUtil.repNull((String)request.getParameter("custManagerNameHiden"));
        iUnitTypeHiden = WtcUtil.repNull((String)request.getParameter("unitTypeHiden"));
        /*end add by diling*/
        /*begin add by diling for 获取目前占比、上限占比、可添加智能网成员数、地市 变量 @2012/6/12 */
        iPreProportionHiden = WtcUtil.repNull((String)request.getParameter("preProportionHiden"));
        iHighestLimitHiden = WtcUtil.repNull((String)request.getParameter("highestLimitHiden"));
        iAddVpMemberHiden = WtcUtil.repNull((String)request.getParameter("addVpMemberHiden"));
        iRegionNameHiden = WtcUtil.repNull((String)request.getParameter("regionNameHiden"));
        /*end add by diling@2012/6/12*/
       
       	/*liujian 2013-1-29 10:32:23 */
       	uniqueStatus = WtcUtil.repNull((String)request.getParameter("uniqueStatus"));
        /*********************
         * 判断工号或集团是否有办理此业务的权限
         *********************/
        try{
            %>
                <wtc:service name="sCheckLogin" routerKey="region" routerValue="<%=regionCode%>" retcode="sCheckLoginCode" retmsg="sCheckLoginMsg" outnum="2" >
                	<wtc:param value="<%=workNo%>"/>
                	<wtc:param value="<%=workPwd%>"/> 
                    <wtc:param value="<%=iSmCode%>"/>
                    <wtc:param value="m01"/>
                    <wtc:param value="<%=iRequestType%>"/>
                    <wtc:param value="<%=iProductId%>"/>
                    <wtc:param value="<%=iCustId%>"/>
                 	<wtc:param value="<%=id_no%>"/>
                </wtc:service>
            <%
            if(!"000000".equals(sCheckLoginCode)){
                %>
                    <script type=text/javascript>
                        rdShowMessageDialog("错误代码：<%=sCheckLoginCode%><br/>错误信息:<%=sCheckLoginMsg%>",0);
                        window.location.href="f7983_1.jsp";
                    </script>
                <%
            }
        }catch(Exception e){
            %>
                <script type=text/javascript>
                    rdShowMessageDialog("调用服务sCheckLogin失败！",0);
                    window.location.href="f7983_1.jsp";
                </script>
            <%
            e.printStackTrace();
        }

        /* 取biz_code,用于后面取付费信息与套餐信息 */

        try{
            String bizCodeSql = "";
    		bizCodeSql="select nvl(field_value,'') from dGrpUserMsgAdd "
    			    +" where field_code='YWDM0' and id_no="+id_no;
    		%>
        		<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode01" retmsg="retMsg01" outnum="1">
                    <wtc:sql><%=bizCodeSql%></wtc:sql>
        		</wtc:pubselect>
        		<wtc:array id="result01" scope="end" />	
    		<%
    		if ("000000".equals(retCode01)){
    		    if(result01.length>0){
    			    iBizCode = result01[0][0];
    			}else{
    			    iBizCode = "";
    			}
    		}else{
			%>
    			<script type=text/javascript>
                    rdShowMessageDialog("查询业务代码失败！<br>错误代码：<%=retCode01%>,错误信息：<%=retMsg01%>",0);
                    window.location.href="f7983_1.jsp";
                </script>
			<%
    		}
        }catch(Exception e){
        %>
			<script type=text/javascript>
                rdShowMessageDialog("查询业务代码失败！",0);
                window.location.href="f7983_1.jsp";
            </script>
		<%
            e.printStackTrace();
        }

        /*********************
         * 取付费信息
         * field_code2 : 1-付费方式可用
         * field_code3 : 0-固定集团付费;1-默认集团可选;2-固定个人付费;3-默认个人可选 
         *********************/
        try{
            String paySql = "select field_code2,field_code3 from dbvipadm.scommoncode where common_code ='1002' and field_code1='"+iSmCode+"'" ; 
			if("AD".equals(iSmCode)||"ML".equals(iSmCode)||"MA".equals(iSmCode)){
				paySql = paySql + "and  field_code4='"+iRequestType+"' ";
			}
			System.out.println("# paySql = "+paySql);
            %>
                <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode1" retmsg="retMsg1"  outnum="2">
                	<wtc:sql><%=paySql%></wtc:sql>
                </wtc:pubselect>
                <wtc:array id="retArr1" scope="end"/>
            <%
            if("000000".equals(retCode1)){
                if(retArr1.length>0){
                    payArr = retArr1;
                }else{
                    paySql="select count(*) from dGrpUserMsgAdd a, dbvipadm.sCommonCode b where  a.field_value = '"+iBizCode+"'"+
	                    " and b.common_code = '1002'   and a.field_value = b.field_code1 and a.id_no = "+id_no+" and a.field_code='YWDM0'  and b.field_code2='"+regionCode+"'";
                    %>
                		<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode12" retmsg="retMsg12" outnum="1">
                		    <wtc:sql><%=paySql%></wtc:sql>
                		</wtc:pubselect>
                		<wtc:array id="result12" scope="end" />	
            		<%
            		if("000000".equals(retCode12)){
            		    if(result12.length>0 && Integer.parseInt(result12[0][0])>0){
                		    /*chendx 20110315 新增common_code=1004字段标识业务代码和付费方式的显示关系*/
		                   paySql="select field_code4 from dGrpUserMsgAdd a, dbvipadm.sCommonCode b where  a.field_value = '"+iBizCode+"'"+
	                    		" and b.common_code = '1002'  and a.field_value = b.field_code1 and a.id_no = "+id_no+" and a.field_code='YWDM0'  and b.field_code2='"+regionCode+"'";
		                	%>
		                		<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode00" retmsg="retMsg00" outnum="1">
		                		    <wtc:sql><%=paySql%></wtc:sql>
		                		</wtc:pubselect>
		                		<wtc:array id="result00" scope="end" />	
		            		<%
		            		System.out.println("# paySql = "+paySql);
		            		if("000000".equals(retCode00) && result00.length>0){
		            			 payArr = new String[][]{{"1","1"}};
		            			 payArr[0][1] = result00[0][0];
		            			 System.out.println("2222 payArr[0] = "+payArr[0][0]);
	                    		 System.out.println("2222 payArr[1] = "+payArr[0][1]);	
		            		}else{
		            			payArr = new String[][]{{"1","1"}};
	                		    System.out.println("33333 payArr[0] = "+payArr[0][0]);
	                    		System.out.println("33333 payArr[1] = "+payArr[0][1]);	
		            		}
		            		/*chendx 20110315 end*/
                		}else{
                		    paySql="select count(*) from dGrpUserMsg a, dbvipadm.sCommonCode b where a.run_code='A' "+
	                            " and b.common_code = '1002'   and a.product_code = b.field_code1 and a.id_no = "+id_no+" and field_code2='"+regionCode+"'";
                            %>
                    			<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode13" retmsg="retMsg13" outnum="1">
                    			    <wtc:sql><%=paySql%></wtc:sql>
                    			</wtc:pubselect>
                    			<wtc:array id="result13" scope="end" />	
                			<%
                			if("000000".equals(retCode13)){
                			    if(result13.length>0 && Integer.parseInt(result13[0][0])>0){
                			        payArr = new String[][]{{"1","1"}};
                			    }else{
                			    	//liujian 2013-1-28 9:57:37 关于开发租赁式呼叫中心BOSS系统需求的函 begin
					            	String [] paraIns_pay = new String[2];
					            	paraIns_pay[0] = "Select b.field_code2,b.field_code4 from dGrpUserMsgAdd a , dbvipadm.scommoncode b Where b.common_code ='1002' and a.field_code = '1010' and a.field_value =  b.field_code1 and a.id_no=:id_no";    
					        		paraIns_pay[1]="id_no="+id_no;
					            	
					            	%>
								        <wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode_pay" retmsg="retMsg_pay" outnum="2" >
								        	<wtc:param value="<%=paraIns_pay[0]%>"/>
								        	<wtc:param value="<%=paraIns_pay[1]%>"/> 
								        </wtc:service>
								        <wtc:array id="retArr_pay" scope="end"/>
								    <%
					            	if(retCode_pay.equals("000000")){
					            		if(retArr_pay.length > 0) {
					            			payArr = new String[][]{{retArr_pay[0][0],retArr_pay[0][1]}};
					            		}else {
					            			payArr = new String[][]{{"",""}};
					            		}
							        }else {
							        %>
		                                <script type=text/javascript>
		                                    rdShowMessageDialog("取付费信息失败！<br>错误代码：<%=retCode_pay%>,错误信息：<%=retMsg_pay%>",0);
		                                    window.location.href="f7983_1.jsp";
		                                </script>
		                            <%	
                			        payArr = new String[][]{{"",""}};
                			      }
                			    }
                			}else{
                    	    %>
                                <script type=text/javascript>
                                    rdShowMessageDialog("取付费信息失败！<br>错误代码：<%=retCode13%>,错误信息：<%=retMsg13%>",0);
                                    window.location.href="f7983_1.jsp";
                                </script>
                            <%
                			}
            		    }
                	}else{
                	    %>
                            <script type=text/javascript>
                                rdShowMessageDialog("取付费信息失败！<br>错误代码：<%=retCode12%>,错误信息：<%=retMsg12%>",0);
                                window.location.href="f7983_1.jsp";
                            </script>
                        <%
            	    }
                }
            }else{
            %>
                <script type=text/javascript>
                    rdShowMessageDialog("取付费信息失败！<br>错误代码：<%=retCode1%>,错误信息：<%=retMsg1%>",0);
                    window.location.href="f7983_1.jsp";
                </script>
            <%
            }
        }catch(Exception e){
            e.printStackTrace();
            %>
                <script type=text/javascript>
                    rdShowMessageDialog("取付费信息失败！",0);
                    window.location.href="f7983_1.jsp";
                </script>
            <%
        }
        
        /*********************
         * 取套餐信息
         * field_code4 : 有值-套餐信息可用
         * field_code4 : (套餐选择类型) 1-彩铃类;2-AD类;3-其他类
         *********************/
        try{
            String sRequestType = "";
            if("AD".equals(iSmCode)){
                sRequestType = iRequestType;
            }else if("CT".equals(iSmCode)||"RH".equals(iSmCode)){
            	String [] paraIn = new String[2];
            	String sqlStr = "select trim(field_value) FROM dgrpusermsgadd where id_no=:id_no and field_code = '1010' ";
            	paraIn[0] = sqlStr;    
        		paraIn[1]="id_no="+id_no;
            	
            	%>
			        <wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode_CT" retmsg="retMsg_CT" outnum="1" >
			        	<wtc:param value="<%=paraIn[0]%>"/>
			        	<wtc:param value="<%=paraIn[1]%>"/> 
			        </wtc:service>
			        <wtc:array id="retArr_CT" scope="end"/>
			    <%
            	if(retCode_CT.equals("000000")){
		            sRequestType = ((String[][])retArr_CT)[0][0];
		        }
            	
            }
            else{
                sRequestType = " ";
            }
            String packSql = "select field_code4 from dbvipadm.scommoncode where common_code ='1001' and field_code1='"+iSmCode+"' and field_code2='"+regionCode+"' and field_code3='"+sRequestType+"' ";
			System.out.println("# packSql = "+packSql);
            %>
                <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode2" retmsg="retMsg2"  outnum="1">
                	<wtc:sql><%=packSql%></wtc:sql>
                </wtc:pubselect>
                <wtc:array id="retArr2" scope="end"/>
            <%
            if("000000".equals(retCode2)){
                if(retArr2.length>0){
                    packArr = retArr2;
                }else{
                    packSql="select count(*) from dGrpUserMsgAdd a, dbvipadm.sCommonCode b where  a.field_value = '"+iBizCode+"'"+
	                    " and b.common_code = '1001'   and a.field_value = b.field_code1 and a.id_no = "+id_no+" and field_code='YWDM0' and field_code2='"+regionCode+"'";
					System.out.println("# packSql = "+packSql);
        		%>
            		<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode22" retmsg="retMsg22" outnum="1">
                        <wtc:sql><%=packSql%></wtc:sql>
            		</wtc:pubselect>
            		<wtc:array id="result22" scope="end" />	
        		<%
        		    if("000000".equals(retCode22)){
        		        if(result22.length>0 && Integer.parseInt(result22[0][0])>0){
        		            packArr = new String[][]{{"2"}};
        		        }else{
        		            packSql="select count(*) from dGrpUserMsg a, dbvipadm.sCommonCode b where a.run_code='A' and"+
	                            " b.common_code = '1001'   and a.product_code = b.field_code1 and a.id_no = "+id_no+ "and field_code2='"+regionCode+"'";
            			%>
                			<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode23" retmsg="retMsg23" outnum="1">
                				<wtc:sql><%=packSql%></wtc:sql>
                			</wtc:pubselect>
                			<wtc:array id="result23" scope="end" />	
            			<%
            			    if("000000".equals(retCode23)){
            			        if(result23.length>0 && Integer.parseInt(result23[0][0])>0){
            			            packArr = new String[][]{{"2"}};
            			        }else{
            			            //liujian 2013-1-28 9:57:37 关于开发租赁式呼叫中心BOSS系统需求的函 begin
					            	String [] paraIns = new String[2];
					            	paraIns[0] = "Select count(*) from dGrpUserMsgAdd a , dbvipadm.scommoncode b Where b.common_code ='1002' and a.field_code = '1010' and a.field_value =  b.field_code1 and a.id_no=:id_no";    
					        		paraIns[1]="id_no="+id_no;
					            	%>
								        <wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode_new" retmsg="retMsg_new" outnum="1" >
								        	<wtc:param value="<%=paraIns[0]%>"/>
								        	<wtc:param value="<%=paraIns[1]%>"/> 
								        </wtc:service>
								        <wtc:array id="retArr_new" scope="end"/>
								    <%
					            	if(retCode_new.equals("000000")){
					            		if(retArr_new.length > 0 && Integer.parseInt(retArr_new[0][0])>0) {
					            			packArr = new String[][]{{"2"}};
					            		}else {
					            			packArr = new String[][]{};	
					            		}
					            		
							        }else {
							        %>
		                                <script type=text/javascript>
		                                    rdShowMessageDialog("取套餐信息失败！<br>错误代码：<%=retCode_new%>,错误信息：<%=retMsg_new%>",0);
		                                    window.location.href="f7983_1.jsp";
		                                </script>
		                            <%	
							        }
            	//liujian 2013-1-28 9:57:37 关于开发租赁式呼叫中心BOSS系统需求的函 end	 
            			        }
                			}else{
                            %>
                                <script type=text/javascript>
                                    rdShowMessageDialog("取套餐信息失败！<br>错误代码：<%=retCode23%>,错误信息：<%=retMsg23%>",0);
                                    window.location.href="f7983_1.jsp";
                                </script>
                            <%
            			    }
        		        }
        		    }else{
                    %>
                        <script type=text/javascript>
                            rdShowMessageDialog("取套餐信息失败！<br>错误代码：<%=retCode22%>,错误信息：<%=retMsg22%>",0);
                            window.location.href="f7983_1.jsp";
                        </script>
                    <%
        		    }
                }
            }else{
            %>
                <script type=text/javascript>
                    rdShowMessageDialog("取套餐信息失败！<br>错误代码：<%=retCode2%>,错误信息：<%=retMsg2%>",0);
                    window.location.href="f7983_1.jsp";
                </script>
            <%
            }
        }catch(Exception e){
            e.printStackTrace();
            %>
                <script type=text/javascript>
                    rdShowMessageDialog("取套餐信息失败！",0);
                    window.location.href="f7983_1.jsp";
                </script>
            <%
        }
        
        /* vp时,查询综合v网信息 */
        if("vp".equals(iSmCode)){
            /* modify by qidp @ 2009-11-11
            String zhwwSql = "select trim(field_value) from dgrpusermsgadd where id_no=(select group_id from dvpmngrpmsg where group_no = '" + iUnitId+ "') and field_code='ZHWW0'";
            */
            String zhwwSql = "select trim(field_value) from dgrpusermsgadd where id_no='"+id_no+"' and field_code='ZHWW0'";
            System.out.println("# zhwwSql = "+zhwwSql);
            %>
            <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" retcode="zhwwCode" retmsg="zhwwMsg"  outnum="1">
                <wtc:sql><%=zhwwSql%></wtc:sql>
            </wtc:pubselect>
            <wtc:array id="zhwwArr" scope="end"/>
            <%
            if("000000".equals(zhwwCode)){
                if(zhwwArr.length>0){
                    zhwwFlag = zhwwArr[0][0];
                }else{
                    zhwwFlag = "";
                }
                System.out.println("# return from f7983_1.jsp -> zhwwFlag = "+zhwwFlag);
            }else{
            %>
		        <script type=text/javascript>
		            rdShowMessageDialog("查询综合v网信息失败！",0);
		            window.location.href="f7983_1.jsp";
		        </script>
		    <%
            }
            
            String  insql = "select to_char(last_day(sysdate)+1,'YYYY-MM-DD')  from  dual";
            %>
            <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode6" retmsg="retMsg61" outnum="1">
                <wtc:sql><%=insql%></wtc:sql>
            </wtc:pubselect>
            <wtc:array id="result6" scope="end" />
            <%
            if("000000".equals(retCode6) && result6.length>0){
                dateStr2 = result6[0][0];
            }else{
                dateStr2 = "";
            }
            /*chendx 20100727 添加vp成员增加时判断是否为安利集团*/
            String acrSql = "SELECT COUNT(*) FROM dacrossvpmnrelation WHERE group_no = '"+iServiceNo+"' AND acr_group_no = '6002002500'";
            System.out.println("acrSql = "+acrSql);
        		%>
            <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="acrCode" retmsg="acrMsg" outnum="1">
                <wtc:sql><%=acrSql%></wtc:sql>
            </wtc:pubselect>
            <wtc:array id="acrCount" scope="end" />
            <%
            if( "000000".equals(acrCode) && Integer.parseInt(acrCount[0][0])>0 ){
                 arcFlag = "1";
            }else{
                 arcFlag = "0";
            }
            /*20100727 end*/
        }
    }else{
        
    }
    
    /* 组织动态展示数据 */
    String sqlStr = "";
    if("2".equals(nextFlag)){
        iUserType = iSmCode;
        String levelFlagSql = "SELECT level_flag FROM sbusitypesmcode WHERE sm_code = '" + iSmCode + "'";
%>
		<wtc:pubselect name="sPubSelect" routerKey="region" 
			 routerValue="<%=regionCode%>"  retcode="levelFlagCode" retmsg="levelFlagMsg" outnum="1">
        <wtc:sql><%=levelFlagSql%></wtc:sql>
        </wtc:pubselect>
        <wtc:array id="levelFlagRet" scope="end" />
<%
		if("000000".equals(levelFlagCode)){
			if(levelFlagRet != null && levelFlagRet.length > 0){
				levelFlag = levelFlagRet[0][0];
			}
		}
        String[] qryParams = new String[14];
        qryParams[0] = "";
        qryParams[1] = "01";
        qryParams[2] = opCode;
        qryParams[3] = workNo;
        qryParams[4] = workPwd;
        qryParams[5] = "";
        qryParams[6] = "";
        qryParams[7] = "m01";
        qryParams[8] = iSmCode;
        qryParams[9] = "";
        qryParams[10] = "";
        qryParams[11] = "";
        qryParams[12] = "";
        qryParams[13] = id_no;
 %>              	
       <wtc:service name="sMemberAttrQry" routerKey="region" routerValue="<%=regionCode%>" 
      		retcode="retCode4" retmsg="retMsg4" outnum="11" >
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
        <wtc:param value="<%=qryParams[13]%>"/>
      </wtc:service>
      <wtc:array id="retArr4" scope="end"/>
                	
            <%
            
            String test[][] = retArr4;
            if(retCode4.equals("000000")){
                resultList = retArr4;
            }else{
                %>
    		        <script type=text/javascript>
    		            rdShowMessageDialog("错误代码：<%=retCode4%> <br/>错误信息：<%=retMsg4%>",0);
    		            window.location.href="f7983_1.jsp";
    		        </script>
    		    <%
            }
    		resultListLength=resultList.length;
    		if(resultListLength>0){
    		    listShow="";
    		}
    }
    
        /*********************
         * 选择是否允许批量或者单个号码操作
         * field_code3 : 0-单个号码 1-批量号码\文件录入 2-VPMN类 3-批量号码 4-支持文件上传
         *********************/
         //wanghao 从前面copy过来
        String phoneType = "";
		String sRequestType = "";
        if("AD".equals(iSmCode)||"ML".equals(iSmCode)||"MA".equals(iSmCode)){
            sRequestType = iRequestType;
        }else{
            sRequestType = " ";
        }
        try{
            String phoneSql = "select field_code3,field_code4 from dbvipadm.scommoncode where common_code = '1003' and field_code1 = '"+iSmCode+"' and field_code2 = '"+sRequestType+"'"; 
            System.out.println("# phoneSql = "+phoneSql);
            %>
                <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode6" retmsg="retMsg6"  outnum="2">
                	<wtc:sql><%=phoneSql%></wtc:sql>
                </wtc:pubselect>
                <wtc:array id="retArr6" scope="end"/>
            <%
            if("000000".equals(retCode6)){
                if(retArr6.length>0){
                    phoneType = retArr6[0][0];
                    if("4".equals(phoneType)){
                    	fileExplain = "文件说明:一个号码一行(注意：上传文件格式必须为文本文件，不支持EXCEL格式上传文件)。每次最多50个。<br>文件格式："+retArr6[0][1]+"。";
                    }
                }
            }else{
            %>
                <script type=text/javascript>
                    rdShowMessageDialog("取套餐信息失败！<br>错误代码："+retCode6+"错误信息："+retMsg6,0);
                    window.location.href="f7983_1.jsp";
                </script>
            <%
            }
        }catch(Exception e){
            e.printStackTrace();
            %>
                <script type=text/javascript>
                    rdShowMessageDialog("取套餐信息失败！",0);
                    window.location.href="f7983_1.jsp";
                </script>
            <%
        }
        
    String addModeFlag = "";
    
    /* requestListShow:控制操作类型的展示 */
    String requestListShow = "none";
    if("AD".equals(iSmCode) || "ML".equals(iSmCode) || "MA".equals(iSmCode)){
        requestListShow = "";
    }else{
        requestListShow = "none";
    }
    System.out.println("### requestListShow = "+requestListShow);
    
    /* payListShow:控制付费信息的展示 */
    String payListShow = "none";
    String payValue = "";
    if(payArr.length>0 && "1".equals(payArr[0][0])){
        payListShow = "";
        payValue = payArr[0][1];
        addModeFlag = "10";
    }else{
        payListShow = "none";
    }
    System.out.println("### payListShow = "+payListShow);
	
	/* packListShow:控制套餐信息的展示 */
	String packListShow = "none";
	String packListShowCR = "none";
	String packValue = "";
	String packFlag = "";
    if(packArr.length>0 && !"".equals(packArr[0][0]) && !"03".equals(iRequestType) && !"04".equals(iRequestType)){
        if("CR".equals(iSmCode)){
            packListShow = "none";
            packListShowCR = "";
        }else{
            packListShow = "";
            packListShowCR = "none";
        }
        packFlag = "";
        packValue = packArr[0][0];
        addModeFlag = "9";
    }else{
        packFlag = "none";
        packListShow = "none";
        packListShowCR = "none";
    }
    
    if(payListShow == "" && packFlag == ""){
        addModeFlag = "11";
    }
    
    if(payListShow == "none" && packFlag == "none"){
        addModeFlag = "0";
    }
    
	String phoneListShow = "none";
    if("1".equals(phoneType)){
        phoneListShow = "";
    }else{
        phoneListShow = "none";
    }
    System.out.println("### phoneListShow = "+phoneListShow);
	
    /* 取操作流水 */
    String sysAccept = "";
    %>
        <wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>"  id="seq"/>
    <%
    sysAccept = seq;
    System.out.println("#           - 流水："+sysAccept);
%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>集团成员增加</title>
    <style>
        .overSelect {
            position: absolute;
            margin-top: 0px;
            margin-left: 0px;
            overflow:auto;
            background:#f0f0f0;
        }
    </style>
<script type=text/javascript>
    var dynTbIndex=1;				//用于动态表数据的索引位置,开始值为1.考虑表头
    var oprType_Add = "a";
    
    onload=function(){
        changeOthers();
        <% if("2".equals(nextFlag)){ %>
            /*add by diling*/
            $("#custManagerInfo").css("display","");
            $("#unitTypeInfo").css("display","");
            /*end */
            $("#iccid").attr("readOnly",true);
            $("#iccid").addClass("InputGrey");
            $("#cust_id").attr("readOnly",true);
            $("#cust_id").addClass("InputGrey");
            $("#unit_id").attr("readOnly",true);
            $("#unit_id").addClass("InputGrey");
            $("#service_no").attr("readOnly",true);
            $("#service_no").addClass("InputGrey");
            $("#product_id").attr("readOnly",true);
            $("#product_id").addClass("InputGrey");
            $("#product_name").attr("readOnly",true);
            $("#product_name").addClass("InputGrey");
            $("#account_id").attr("readOnly",true);
            $("#account_id").addClass("InputGrey");
            $("#sm_code").attr("readOnly",true);
            $("#sm_code").addClass("InputGrey");
            $("#sm_name").attr("readOnly",true);
            $("#sm_name").addClass("InputGrey");
            $("#product_pwd").attr("readOnly",true);
            $("#product_pwd").addClass("InputGrey");
            $("#belong_code").find("option:not(:selected)").remove();
            
            if("<%=iSmCode%>" == "AD" || "<%=iSmCode%>" == "ML" || "<%=iSmCode%>" == "MA"){
                //选择黑名单类和白名单类时显示期望日期
            	var vRequestType = "<%=iRequestType%>";
            	document.all.request_type.value=vRequestType;
            	$("#request_type").find("option:not(:selected)").remove();
            	if(vRequestType == "03" || vRequestType == "04"){
            	    document.all.expTime.style.display="";
            	}else{
            	    document.all.expTime.style.display="none";
            	}
            }
            
            if($("#sm_code").val() == "ap" || $("#sm_code").val() == "ZH"){//diling add 2012/7/23 15:12 增加智慧城管对静态ip地址的验证，如为IP类型为动态，则不需要输入ip地址
              $("#F81008").change(function(){
                if(document.all.F81008.value == "1"){
                  $("#F81002").attr("readOnly",true);
                  $("#F81002").val("");
                }else{
                  $("#F81002").removeAttr("readOnly");
                }  
              }); 
            }
            
        <% } %>
        
        if("<%=iSmCode%>" == "vp"){
            /* vp时,查询综合v网信息 */
            if("<%=zhwwFlag%>" == ""){
                document.all.F80023.value="0";
                document.all.ZHWW.value="0";
            }
            else if("<%=zhwwFlag%>" == "vm"){
                document.all.F80023.value="1";
                document.all.ZHWW.value="1";
            }
            else if("<%=zhwwFlag%>" == "vt"){
                document.all.F80023.value="2";
                document.all.ZHWW.value="2";
            }
            else{
                document.all.F80023.value="0";
                document.all.ZHWW.value="0";
            }
            
            //$("#F80023").attr("disabled",true);
            $("#F80023").find("option:not(:selected)").remove();
            
            if($("#F80023").val() == "0"){
                //document.all.phone_type.value="1";
                //$("#phone_type").find("option:selected").remove(); 
                $("#phone_type").find("option[value='1']").remove(); 
            }
            
            /* vp时,下月套餐资费生效日期赋值为下月第一天 */
            document.all.F80006.value="<%=dateStr2%>";
        }
        
<%
        if ("j1".equals(iSmCode)) {
%>
            chkMulti();
<%
    	} else if("1".equals(phoneType)){
%>
            $("#single_type").css("display","none");
            document.all.input_type[1].checked = true;
            chkMulti();
<%
		} else if ("3".equals(phoneType)) {
%>
            document.all.input_type[1].checked = true;
            chkMulti();
<%
		}else if ("4".equals(phoneType)) {
%>
			document.all.input_type[2].checked = true;
			chkFile();
<%
		}
%>
    }
    
    /* 查询集团用户信息 */
    function getCustInfo(){
        var pageTitle = "集团客户选择";
        var fieldName = "证件号码|集团客户ID|集团客户名称|集团产品ID|集团号|产品代码|产品名称|集团编号|产品付费帐户|品牌代码|品牌名称|包月标识|操作类型|最大终端数量|已增加终端数量|可用数量|limitcount|集团类别|集团客户经理姓名|集团客户经理工号|目前占比公式|上限占比公式|可添加智能网成员数|地市名称|";//update diling@2012/6/12
        var sqlStr = "";
        var selType = "S";    //'S'单选；'M'多选
        var retQuence = "24|0|1|7|4|5|8|9|3|11|2|6|10|12|13|14|15|16|17|18|19|20|21|22|23|"; //update diling

        var retToField = "iccid|cust_id|unit_id|service_no|product_id|account_id|sm_code|id_no|month_flag|grp_name|product_name|sm_name|request_type_flag|max_term_num_tmp|add_term_num_tmp|use_term_num_tmp|limitcount|unitTypeHiden|custManagerNameHiden|custManagerNoHiden|preProportionHiden|highestLimitHiden|addVpMemberHiden|regionNameHiden|";//update diling@2012/6/12 
        /**add by liwd 20081127,group_id来自dcustDoc的group_id end **/

        if(document.frm.iccid.value == "" && document.frm.cust_id.value == "" && document.frm.unit_id.value == "" && document.frm.service_no.value == "")
        {
            rdShowMessageDialog("请输入证件号码、客户ID、集团ID或集团号进行查询！");
            document.frm.iccid.focus();
            return false;
        }
        
        if((document.frm.cust_id.value) != "" && forNonNegInt(frm.cust_id) == false)
        {
            frm.cust_id.value = "";
            rdShowMessageDialog("客户ID必须是数字！");
            return false;
        }
        
        if((document.frm.unit_id.value) != "" && forNonNegInt(frm.unit_id) == false)
        {
            frm.unit_id.value = "";
            rdShowMessageDialog("集团ID必须是数字！");
            return false;
        }
        
        PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
    }
    
    function PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField){
        var path = "<%=request.getContextPath()%>/npage/s7983/fpubcust_sel.jsp";
        path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
        path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
        path = path + "&selType=" + selType+"&iccid=" + document.frm.iccid.value;
        path = path + "&cust_id=" + document.frm.cust_id.value;
        path = path + "&unit_id=" + document.frm.unit_id.value;
        path = path + "&service_no=" + document.frm.service_no.value;
        path = path + "&regionCode=" + document.frm.iRegionCode.value;
        retInfo = window.open(path,"newwindow","height=450, width=1000,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
    	return true;
    }
    
    function getvaluecust(retInfo,object){
        var retToField = "iccid|cust_id|unit_id|service_no|product_id|account_id|sm_code|id_no|month_flag|grp_name|product_name|sm_name|request_type_flag|max_term_num_tmp|add_term_num_tmp|use_term_num_tmp|limitcount|unitTypeHiden|custManagerNameHiden|custManagerNoHiden|preProportionHiden|highestLimitHiden|addVpMemberHiden|regionNameHiden|"; //diling add@2012/6/12
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
        var vSmCode = $("#sm_code").val();
        if(vSmCode == "AD" || vSmCode == "ML" || vSmCode == "MA"){
            document.all.requestTab1.style.display="";
            document.all.requestTab2.style.display="";
            document.all.request_type.value=$("#request_type_flag").val();
            $("#request_type").find("option:not(:selected)").remove();
        }else{
            document.all.requestTab1.style.display="none";
            document.all.requestTab2.style.display="none";
        }
        
        $("#iccid").attr("readOnly",true);
        $("#cust_id").attr("readOnly",true);
        $("#unit_id").attr("readOnly",true);
        $("#service_no").attr("readOnly",true);
        
        //liujian 2013-1-24 13:55:59 关于开发租赁式呼叫中心BOSS系统需求的函
	    if(object && object.uniqueStatus) {
	    	$('#uniqueStatus').val(object.uniqueStatus);
	    }
	    if (object.busiFlag){
	        document.getElementById('busiFlag').value = object.busiFlag;
	    }
	    if (object.phoneHeader){
	        document.getElementById('phoneHeader').value = object.phoneHeader;
	    }
    }
    
    /* 校验集团产品密码 */
    function chkProductPwd(){
        var cust_id = document.all.cust_id.value;
        var Pwd1 = document.all.product_pwd.value;
        var checkPwd_Packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s7983/pubCheckPwd.jsp","正在进行密码校验，请稍候......");
        checkPwd_Packet.data.add("retType","checkPwd");
    	checkPwd_Packet.data.add("cust_id",cust_id);
    	checkPwd_Packet.data.add("Pwd1",Pwd1);
    	core.ajax.sendPacket(checkPwd_Packet);
    	checkPwd_Packet = null;
    }
    
    function doProcess(packet)
    {
        var retType = packet.data.findValueByName("retType");
        var retCode = packet.data.findValueByName("retCode");
        var retMessage=packet.data.findValueByName("retMessage");

		var backArrMsg = packet.data.findValueByName("backArrMsg");
		var backArrMsg1 = packet.data.findValueByName("backArrMsg1");
		var backArrMsg2=packet.data.findValueByName("backArrMsg2");
        
        self.status="";
        if(retType == "checkPwd") //集团客户密码校验
        {
            if(retCode == "000000")
            {
                var retResult = packet.data.findValueByName("retResult");
                if (retResult == "false") {
                    rdShowMessageDialog("客户密码校验失败，请重新输入！",0);
                    frm.product_pwd.value = "";
                    frm.product_pwd.focus();
                    return false;	        	
                } else {
                    rdShowMessageDialog("客户密码校验成功！",2);
                    if(<%=nextFlag%>==1){
                        $("#next").attr("disabled",false);
                    }
                }
            }
            else
            {
                rdShowMessageDialog("客户密码校验出错，请重新校验！",0);
                return false;
            }
        }
        else if(retType == "phoneno"){
            if( parseInt(retCode) == 0 ){
                var num = backArrMsg[0][0];
                if( parseInt(num) < 2){
                    $("#PHONENO").val("");
                    $("#ISDNNO").val("");
                    $("#USERNAME").val("");
                    $("#IDCARD").val("");
                    $("#PCOMMENT").val("");
                    rdShowMessageDialog("欠费用户(非托收用户)不能申请VPMN业务!",0);
                    document.frm.ISDNNO.focus();
                    return false;
                }
                else{
                    dynAddRow();
                }
            }else{
                $("#PHONENO").val("");
                $("#ISDNNO").val("");
                $("#USERNAME").val("");
                $("#IDCARD").val("");
                $("#PCOMMENT").val("");
                rdShowMessageDialog("错误代码："+retCode+"</br>错误信息："+retMessage+"!",0);
                return false;
            }
        }
        else if(retType == "checkPhone"){
        	
        	var retIdNo = packet.data.findValueByName("returnIdNo");//wangzn add 2011/6/8 16:19:08
        	var postCode = packet.data.findValueByName("postCode");//wangzn add 2011/6/8 16:19:08
        	var IMPI = packet.data.findValueByName("IMPI");//wangzn add 2011/6/8 16:19:08
        	var IMPUList = packet.data.findValueByName("IMPUList");//wangzn add 2011/6/8 16:19:08
        	var sCtShortNo  =packet.data.findValueByName("sCtShortNo");
			var sUserType   =packet.data.findValueByName("sUserType");
			var PortalName  =packet.data.findValueByName("PortalName");
			var PortalPass  =packet.data.findValueByName("PortalPass");
            if(parseInt(retCode) == 0){
                rdShowMessageDialog("校验成功！",2);
				$("#checkPhoneFlag").val("1");
                $("#sure").attr("disabled",false);
                if($("#F70003").val()!=undefined)
                {
	                $("#F70003").val('+86'+$("#single_phoneno").val());//wangzn add 2011/6/7 16:30:27
	                $("#F70003").val($("#F70003").val().replace("+860", "+86"));
	                $("#F70003").attr("readOnly",true);//wangzn 2011/6/7 16:31:48
            	}
            	if($("#F70001").val()!=undefined)
            	{
	                $("#F70001").val($("#single_phoneno").val());//wangzn add 2011/6/8 16:20:09
	                $("#F70001").attr("readOnly",true);//wangzn add 2011/6/8 16:20:09
            	}
            	if($("#F70027").val()!=undefined)
            	{
            		$("#F70027").val(postCode);//wangzn add 2011/6/8 16:20:09
                	$("#F70027").attr("readOnly",true);//wangzn add 2011/6/8 16:20:09
            	}
                if($("#F70028").val()!=undefined)
                {
                	 $("#F70028").val(IMPI);//wangzn add 2011/6/8 16:20:09
               		 $("#F70028").attr("readOnly",true);//wangzn add 2011/6/8 16:20:09
                }
                if( $("#F70029").val()!=undefined)
                {
	                $("#F70029").val(IMPUList);//wangzn add 2011/6/8 16:20:09
	                $("#F70029").attr("readOnly",true);//wangzn add 2011/6/8 16:20:09
				}
				if( $("#F70026").val()!=undefined)
                {
	                $("#F70026").val(sCtShortNo);
	            }
	            if( $("#F70019").val()!=undefined)
                {
	                $("#F70019").val(sUserType);
	            }
	            if( $("#F70022").val()!=undefined)
                {
	                $("#F70022").val(PortalName);
	            }
	            if( $("#F70023").val()!=undefined)
                {
	                $("#F70023").val(PortalPass);
	            }
            }else{
                //rdShowMessageDialog("错误代码："+retCode+"<br/>错误信息："+retMessage,0);
                if (rdShowConfirmDialog("错误代码"+retCode+"<br>错误信息"+retMessage +"<br>是否保存错误信息？")==1)	
        		{
        			var path="/npage/s7983/f7983_printxls.jsp?phoneNo=" + document.all.single_phoneno.value;
        			path = path + "&grpName=" + document.all.grp_name.value;
					path = path + "&returnMsg=" + retMessage;
					path = path + "&unitID=" + document.all.unit_id.value;
  					path = path + "&op_Code=" + "7983";
  					path = path + "&orgCode=" + document.all.org_code.value;
  					path = path + "&sm_name=" + document.all.sm_name.value;
  					window.open(path);
        		}		
            }
        }
        else if(retType =="phonenoMobile"){
        	if( parseInt(retCode) == 0 ){
        		document.all.mobile_phone.value=backArrMsg;
        	}
        	else{
                $("#PHONENO").val("");
                $("#ISDNNO").val("");
                $("#USERNAME").val("");
                $("#IDCARD").val("");
                $("#PCOMMENT").val("");
                rdShowMessageDialog("错误代码："+retCode+"</br>错误信息："+retMessage+"!",0);
                return false;
            }
        }else if (retType =="rhphonenoMobile"){
            if( parseInt(retCode) == 0 ){
        		document.all.mobile_phone.value=backArrMsg;
        	}
        	else{
        	    document.all.real_no.value = '';
        	    document.all.short_no.value = '';
        	    
                rdShowMessageDialog("错误代码："+retCode+"</br>错误信息："+retMessage+"!",0);
                return false;
            }
        } else if (retType == "checkJ1Phone") {	//wanghfa添加 2010-12-3 11:08 移动总机接入BOSS系统需求
            if(parseInt(retCode) == 0){
                var num = backArrMsg[0][0];
                if(parseInt(num) < 2){
                    $("#j1PhoneNo").val("");
                    rdShowMessageDialog("欠费用户(非托收用户)不能申请VPMN业务!",0);
                    document.getElementById("j1PhoneNo").focus();
                    return;
                }
                else{
                    dynAddRow();
                }
            }else{
                rdShowMessageDialog("错误代码："+retCode+"</br>错误信息："+retMessage+"!",0);
                return false;
            }
        }
        else{
            rdShowMessageDialog("错误代码："+retCode+"错误信息："+retMessage+"",0);
            return false;
        }
    }
    
        /* 清除 */
    function resetJsp(){
        //document.all.frm.reset();
        window.location='f7983_1.jsp';
    }
    
    /* 下一步 */
    function nextStep(){
    		var vSmCode = $("#sm_code").val();
    		if(vSmCode == "vp"){
    			var flag4A = allCheck4A("<%=opCode%>");
					if(!flag4A){
						return false;
					}
    		}
        if(!check(document.all.frm)){return false}
        
        
        if(vSmCode == "AD" || vSmCode == "ML" || vSmCode == "MA"){
            if($("#request_type").val().trim() == ''){
                rdShowMessageDialog("请选择操作类型！",0);
                return false;
            }
        }
        
        var busiFlag = document.getElementById('busiFlag').value;
        var phoneHeader = document.getElementById('phoneHeader').value;
        frm.action="f7983_1.jsp?action=next&busiFlag=" + busiFlag +"&phoneHeader=" + phoneHeader;
        frm.method="post";
        frm.submit();
    }
    
    /* 上一步 */
    function previouStep(){
        frm.action="f7983_1.jsp";
    	frm.method="post";
    	frm.submit();
    }
    
    /* 点选单个输入时 */
    function chkSingle(){
        $("#inputType").val("single");
        $("#sure").attr("disabled",true);
        $("#single").css("display","block");
        $("#multi").css("display","none");
        $("#file").css("display","none");
        <%
        if ("ap".equals(iSmCode)) {
        	%>
					//document.getElementById("F81002").value = "";
					document.getElementById("F81002").disabled = false;
					document.all.sure.disabled = true;
					<%
        }
        %>
    }
    
    /* 点选批量输入时 */
    function chkMulti(){
        $("#inputType").val("multi");
        $("#sure").attr("disabled",false);
        $("#single").css("display","none");
        $("#multi").css("display","block");
        $("#file").css("display","none");
    }
    
    /* 点选录入文件时 */
    function chkFile(){
        $("#inputType").val("file");
        $("#sure").attr("disabled",false);
        $("#single").css("display","none");
        $("#multi").css("display","none");
        $("#file").css("display","block");
        <%
        if ("ap".equals(iSmCode)) {
        	%>
					//document.getElementById("F81002").value = "";
					document.getElementById("F81002").disabled = true;
					<%
        }
        %>
    }
    
    /* 点选vpmn号码输入时 */
    function chkVpmnMulti(){
        $("#vpmnInputType").val("vpmnMulti");
        $("#vpmnMulti").css("display","block");
        $("#vpmnFile").css("display","none");
    }
    
    /* 点选vpmn文件录入时 */
    function chkVpmnFile(){
        $("#vpmnInputType").val("vpmnFile");
        $("#vpmnMulti").css("display","none");
        $("#vpmnFile").css("display","block");
    }
    
    /* 从txt文件录入手机号码 */
    function checkPhNo(){
        fso = new ActiveXObject("Scripting.FileSystemObject");
        var ForReading =1,f2;
        f2 = fso.OpenTextFile(document.all.PosFile.value,ForReading);
        var temps = f2.ReadAll();
        document.all.multi_phoneNo.value=temps;
        
        var phnoNoArr = temps.split("|");
        
        for(var i=0;i<phnoNoArr.length-1;i++){
            if(phnoNoArr[i].replace(/\s/g,'').length!=11){
                rdShowMessageDialog("电话号码应该为11位"+phnoNoArr[i]);
            }
            for(var j=i+1;j<phnoNoArr.length-1;j++){
                if(phnoNoArr[i].replace(/\s/g,'')==phnoNoArr[j].replace(/\s/g,'')){
                    rdShowMessageDialog("电话号码重复"+phnoNoArr[j]);
                }
            }
        }
        resetfilp();
    }
    
    function resetfilp(){
        document.getElementById("PosFile").outerHTML = document.getElementById("PosFile").outerHTML;
    }
    
    function call_ISDNNOINFO()
    {
        if(!checkElement(document.all.ISDNNO)) return false;	
        /*lilm增加对短号的校验 短号应判断必须是6开头，且第二位不能为0，位数是4-6位 */
        /*wuxy增加 网外短号可以是7开头 ，位数为3-8位**/
        if(!checkElement(document.all.PHONENO)) return false;
        //wuxy add 20100330 
        check_nomobile_phone();
        var mobile_flag=document.all.mobile_phone.value;
        var shortNo = document.frm.PHONENO.value;
        if(mobile_flag.substr(0,1)==0)
        {
        	if(shortNo.substr(0,1)==7)
        	{
        		if(shortNo.length<3||shortNo.length>8)
        		{
        			rdShowMessageDialog("7开头的短号码位数必须为3-8位!");
        		    return false;
        		}
        	}
        	else
        	{
        		if(shortNo.substr(0,1) !=6)
        		{
        		    rdShowMessageDialog("短号码必须是6或7开头!");
        		    return false;
        		}
        		if(shortNo.length<4||shortNo.length>6)
        		{
        			rdShowMessageDialog("6开头的短号码位数必须为4-6位!");
        		    return false;
        		}
        		
        		if(shortNo.substr(1,1) ==0)
        		{
        		    rdShowMessageDialog("短号码第二位不能为0!");
        		    return false;
        		}  
        	}
        }
        else
        {
        	if(shortNo.length<4||shortNo.length>6)
        	{
        		rdShowMessageDialog("短号码位数必须为4-6位!");
        	    return false;
        	}
        	<%
        	if(operFlag==true) {
        	%>
        	 if(shortNo.substr(0,1) !=6 && shortNo.substr(0,1) !=7)
        	{
        	    rdShowMessageDialog("短号码必须是6或者7开头!");
        	    return false;
        	}
        <%}else {%>
        	if(shortNo.substr(0,1) !=6)
        	{
        	    rdShowMessageDialog("短号码必须是6开头!");
        	    return false;
        	}
        	<%}%>
        	if(shortNo.substr(1,1) ==0)
        	{
        	    rdShowMessageDialog("短号码第二位不能为0!");
        	    return false;
        	}  
        	
        }
       
        
        			        		       			
        var path = "f7983_no_infor.jsp";
        path = path + "?loginNo=" + document.frm.work_no.value + "&phoneNo=" + document.frm.ISDNNO.value;
        path = path + "&opCode=" + document.frm.op_code.value + "&orgCode=" + document.frm.org_code.value;
        path = path + "&ZHWW=" + document.frm.ZHWW.value;
        path = path + "&phone_type=" + document.frm.phone_type.value;
        //alert(path);
        var retInfo = window.showModalDialog(path);
        if(typeof(retInfo) == "undefined")
        {
            document.frm.USERNAME.value = "";
            document.frm.IDCARD.value = "";			           
        }else{ 
            if(parseInt(document.frm.ZHWW.value)>=1){ 
                document.frm.USERNAME.value = oneTokSelf(retInfo,"|",1);
                document.frm.IDCARD.value = oneTokSelf(retInfo,"|",2);
                dynAddRow();
            }else{
                document.frm.USERNAME.value = oneTokSelf(retInfo,"|",1);
                document.frm.IDCARD.value = oneTokSelf(retInfo,"|",2);
                var sSmCode = oneTokSelf(retInfo,"|",3);
                if( sSmCode == "cb" )
                {
                    rdShowConfirmDialog("长白行用户不能申请VPMN业务!",0);    
                    document.all.ISDNNO.focus();
                    return false;
                }
                var run_code = oneTokSelf(retInfo,"|",6);
                if( run_code != "A" && run_code != "B" && run_code != "C" && 
                    run_code != "D" && run_code != "E" && run_code != "F" && 
                    run_code != "G" && run_code != "H" && run_code != "I" && 
                    run_code != "K" && run_code != "L" && run_code != "M" &&
                    run_code != "O") //diling update@2011/10/24 增加一个O状态
                {
                    rdShowConfirmDialog("非正常状态用户[" + run_code + "]，不能办理VPMN业务!",0);	
                    document.all.ISDNNO.focus();
                    return false;
                }
                var sTotalFee = oneTokSelf(retInfo,"|",4);
                if ( parseInt(sTotalFee) > 0 ){
                    check_phone();
                }else{
                    dynAddRow();
                }
            } 			           
        }
        
        selAttr();
    }
    
    function call_RH_ISDNNOINFO(){
        // zhouby 真实号码不能为空
        if(!checkElement(document.all.real_no)) return false;
        if(!checkElement(document.all.short_no)) return false;
        
        check_rh_nomobile_phone();
        var mobile_flag = document.all.mobile_phone.value;
        var shortNo = document.frm.short_no.value;
        
        var path = "addButtonSummary.jsp";
        path = path + "?loginNo=" + document.frm.work_no.value + "&phoneNo=" + document.frm.real_no.value;
        path = path + "&opCode=" + document.frm.op_code.value + "&orgCode=" + document.frm.org_code.value;
        path = path + "&portalName=" + $('#portalName').val();
        path = path + "&portalPassword=" + $('#portalPassword').val();
        path = path + "&shortNo=" + $('#short_no').val();
        path = path + "&realNo=" + $('#real_no').val();
        //path = path + "&userType=" + $('select[name="F70019"]').val();
        //alert(path);
        var retInfo = window.showModalDialog(path);
        
        if(typeof(retInfo) != "undefined"){ 
            //检验用户品牌
            var sSmCode = retInfo.smCode;
            var userType = $('select[name="F70019"]').val();
            //alert(sSmCode);
            if (userType == '0' && sSmCode != 'GH'){
                rdShowMessageDialog("该用户类型不能选择这个品牌!");
                return false;
            } else if (userType == '1' && sSmCode != 'zn' && sSmCode != 'gn' && sSmCode != 'dn'){
                rdShowMessageDialog("该用户类型不能选择这个品牌!");
                return false;
            }
            
            //校验用户状态
            var run_code = retInfo.runCode;
            if( run_code != "A" && run_code != "B" && run_code != "C" && 
                run_code != "D" && run_code != "E" && run_code != "F" && 
                run_code != "G" && run_code != "H" && run_code != "I" && 
                run_code != "K" && run_code != "L" && run_code != "M" &&
                run_code != "O") {
                rdShowConfirmDialog("非正常状态用户[" + run_code + "]，不能办理!",0);	
                return false;
            }
            
            var sTotalFee = retInfo.totalOwe;
            //alert(' todo 看看欠费这里到底是多少' + sTotalFee);
            if (parseInt(sTotalFee) > 0 ){
                rdShowMessageDialog('用户欠费，不能办理该业务！');
                return false;
            }
            dynAddRow();
        }
        
        selAttr();
    }
    // 查出 当前默认属性
    function selAttr(){
       var cust_id = document.all.cust_id.value;
       var myPacket = new AJAXPacket("selAttr.jsp","正在查询套餐名称，请稍候......");	
       myPacket.data.add("cust_id",cust_id);
       core.ajax.sendPacket(myPacket,doMsg);
       myPacket = null;
    }
    function doMsg(packet){
         var retCode = packet.data.findValueByName("retCode");
         var retMessage = packet.data.findValueByName("retMessage");
         var retResult = packet.data.findValueByName("result");
         if(retCode == "000000")
         {
         	$("#attr").val(retResult);
         }else{
            rdShowMessageDialog("错误代码："+retCode+"  错误信息："+retMessage+"!");	
            return;
         }
      }
    //wanghfa添加方法 2010-12-2 17:42 移动总机接入BOSS系统
	function j1AddPhoneNo() {
		if (!checkElement(document.getElementById("j1No"))) {
			rdShowMessageDialog("分机号码为4-6位数字，请重新填写！", 1);
			document.getElementById("j1No").focus();
			return false;
		} else if (!checkElement(document.getElementById("j1PhoneNo"))) {
			document.getElementById("j1PhoneNo").focus();
			return false;
		} else if (!checkElement(document.getElementById("j1UserName"))) {
			document.getElementById("j1UserName").focus();
			return false;
		} else if (!checkElement(document.getElementById("j1ShortName"))) {
			document.getElementById("j1ShortName").focus();
			return false;
		} else {
		  	var patrn=/^[a-z]$/;
		  	if(document.getElementById("j1ShortName").value.trim().substring(0,1).search(patrn) == -1){
				rdShowMessageDialog("成员姓名拼音首字母必须以小写字母开始！");
				document.getElementById("j1No").focus();
				return;
			}
		}
		
		var j1Provider = document.getElementById("j1Provider").value;
		if (j1Provider == "0") {
		  	var patrn=/^[6][1-9]\d{2,4}$/;
		  	if(document.getElementById("j1No").value.search(patrn) == -1){
				rdShowMessageDialog("移动运营商分机号码第一位必须为6；第二位不能为0，请重新输入！");
				document.getElementById("j1No").focus();
				return;
			}
		} else if (j1Provider == "1") {
		  	var patrn=/^[8]\d{3,5}$/;
		  	if(document.getElementById("j1No").value.search(patrn) == -1){
				rdShowMessageDialog("其他运营商分机号码第一位必须为8，请重新输入！");
				document.getElementById("j1No").focus();
				return;
			}
		}
		
		//if (j1Provider == "0") {
			var path = "f7983_no_infor.jsp";
			path = path + "?loginNo=" + document.frm.work_no.value + "&phoneNo=" + document.getElementById("j1PhoneNo").value;
			path = path + "&opCode=" + document.frm.op_code.value + "&orgCode=" + document.frm.org_code.value;
			path = path + "&ZHWW=1&j1=1";
			path = path + "&phone_type=" + j1Provider;
			
			var retInfo = window.showModalDialog(path);
			
			if(typeof(retInfo) == "undefined") {
				return;
			} else if (retInfo == "-4") {
				rdShowMessageDialog("运营商错误，此号码为移动运营商号码！", 0);
				return;
			} else {
				dynAddRow();
			}
	}
	
    function check_phone()
    {
        var sqlBuf="90000230";
		var params_=document.frm.ISDNNO.value+"|";
		var outNum = "1";
        var myPacket = new AJAXPacket("CallCommONESQL.jsp","正在验证用户号码，请稍候......");
        if(!checkElement(document.frm.PHONENO)) return false;
        if(!checkElement(document.all.ISDNNO)) return false;
        myPacket.data.add("verifyType","phoneno");
        myPacket.data.add("sqlBuf",sqlBuf);
		myPacket.data.add("recv_number",outNum);
		myPacket.data.add("params",params_);
        core.ajax.sendPacket(myPacket);
        myPacket=null;			
    }
	
	//wanghfa添加 2010-12-3 11:14 移动总机接入BOSS系统需求
    function j1CheckPhone() {
		var sqlBuf="90000230";
		var params_=document.getElementById("j1PhoneNo").value +"|";
		var outNum = "1";
		var myPacket = new AJAXPacket("CallCommONESQL.jsp","正在验证用户号码，请稍候......");
		myPacket.data.add("verifyType", "checkJ1Phone");
		myPacket.data.add("sqlBuf", sqlBuf);
		 myPacket.data.add("recv_number",outNum);
		myPacket.data.add("params",params_);
		core.ajax.sendPacket(myPacket);
		myPacket=null;			
    }
	
        function check_nomobile_phone()
    {
        var sqlBuf="90000231";
		var params_=document.frm.ISDNNO.value+"|";
		var outNum = "1";
        var myPacket = new AJAXPacket("CallCommONESQL.jsp","正在验证用户号码，请稍候......");
        if(!checkElement(document.frm.PHONENO)) return false;
        if(!checkElement(document.all.ISDNNO)) return false;
        myPacket.data.add("verifyType","phonenoMobile");
        myPacket.data.add("sqlBuf",sqlBuf);
		myPacket.data.add("recv_number",outNum);
		myPacket.data.add("params",params_);
        core.ajax.sendPacket(myPacket);
        myPacket=null;			
    }
    
     function check_rh_nomobile_phone()
    {
        var sqlBuf="90000231";
		var params_=document.frm.real_no.value+"|";
		var outNum = "1";
        var myPacket = new AJAXPacket("CallCommONESQL.jsp","正在验证用户号码，请稍候......");
        if(!checkElement(document.frm.short_no)) return false;
        if(!checkElement(document.all.real_no)) return false;
        myPacket.data.add("verifyType","rhphonenoMobile");
        myPacket.data.add("sqlBuf",sqlBuf);
		myPacket.data.add("recv_number",outNum);
		myPacket.data.add("params",params_);
        core.ajax.sendPacket(myPacket);
        myPacket=null;			
    }
    
    function oneTokSelf(str,tok,loc)
    {
        var temStr=str;
        
        var temLoc;
        var temLen;
        for(ii=0;ii<loc-1;ii++)
        {
            temLen=temStr.length;
            temLoc=temStr.indexOf(tok);
            temStr=temStr.substring(temLoc+1,temLen);
        }
        if(temStr.indexOf(tok)==-1)
            return temStr;
        else
            return temStr.substring(0,temStr.indexOf(tok));
    }
    
    //wanghfa修改 2010-12-3 13:51 移动总机接入BOSS系统需求
    function dynAddRow() {
    	var smCode = document.getElementById("sm_code").value;
    	if (smCode == "j1") {
    		var j1No = document.getElementById("j1No").value;
    		var j1PhoneNo = document.getElementById("j1PhoneNo").value;
    		var j1UserName = document.getElementById("j1UserName").value;
    		var j1ShortName = document.getElementById("j1ShortName").value;
    		
			if (parseInt(document.all.addRecordNum.value) > 4 ) {
				rdShowMessageDialog("最多只能操作5个号码 !!");
				return;
			} else if(verifyUnique(j1No, j1PhoneNo) == false) {
				rdShowMessageDialog("已经有一条”分机号码“或者”真实号码“相同的数据!!");
				return;
			}
			
			var tr1 = dyntb.insertRow();	//注意：插入的必须与下面的在一起,否则造成空行.yl.
			tr1.id="tr"+dynTbIndex;
			tr1.insertCell().innerHTML = '<div align="center"><input id=R0 type=checkBox size=4 value="删除" onClick="dynDelRow()" ></input></div>';
			tr1.insertCell().innerHTML = '<div><input id=R1 type=text size=10 value="' + j1No + '" class="InputGrey" readonly></input></div>';
			tr1.insertCell().innerHTML = '<div><input id=R2 type=text value="'+ j1PhoneNo+'"  class="InputGrey" readonly></input></div>';
			tr1.insertCell().innerHTML = '<div><input id=R3 type=text value="'+ j1UserName+'" maxlength=10 class="InputGrey"  readonly ></input></div>';
			tr1.insertCell().innerHTML = '<div><input id=R5 type=text value="'+ j1ShortName+'" class="InputGrey"  readonly></input></div>';
			//tr1.insertCell().innerHTML = '<div><input id=R6 type=text size=8 value=""  class="InputGrey" readonly ></input></div>';
			dynTbIndex++;
			document.all.addRecordNum.value = document.all.dyntb.rows.length-2;
    	}else if (smCode == "RH" && '<%=busiFlag%>' == '186'){
	        addFusionRow();
    	}else {
	        var phone_no="";
	        var isdn_no="";
	        var user_name="";
	        var id_card="";
	        var note="";
	        var add_no="";
	        var tmpStr="";
	        var flag=false;
	        
            phone_no = document.all.PHONENO.value;
            isdn_no = document.all.ISDNNO.value;
            
            if(!checkElement(document.all.PHONENO)) return false;
            if(!checkElement(document.all.ISDNNO)) return false;
	        
	        user_name = document.all.USERNAME.value;
	        id_card = document.all.IDCARD.value;
	        note = document.all.PCOMMENT.value;
	        queryAddAllRow(0,phone_no,isdn_no,user_name,id_card,note);
    	}
    }

    function queryAddAllRow(add_type,phone_no,isdn_no,user_name,id_card,note)
    {
        var tr1="";
        var i=0;
        var tmp_flag=false;
        
        var exec_status="";
        if ( parseInt(document.all.addRecordNum.value) > 4 )
        {
            rdShowMessageDialog("最多只能操作5个号码 !!");
            return false;
        }
        /*begin diling add for 如果为vp用户，则增加成员不能超过可添加成员数量@2012/6/12*/
        var smCode_vpFlag = document.getElementById("sm_code").value;
        if(smCode_vpFlag=="vp"){
          var v_addVpMember = document.getElementById("addVpMember").value; //可添加vpmn成员数
          var v_iRegionNameHiden = $("#iRegionNameHiden").val();
          if ( (Number(document.all.addRecordNum.value)+1 )> Number(v_addVpMember) ){
          rdShowMessageDialog(""+v_iRegionNameHiden+"公司的智能网总容量已达到上限，不能再新增成员！");
          return false;
          }
        }
        /*begin diling add @2012/6/12*/
        tmp_flag = verifyUnique(phone_no,isdn_no);
        if(tmp_flag == false)
        {
            rdShowMessageDialog("已经有一条'短号'或者'真实号码'相同的数据!!");
            return false;
        }
        tr1=dyntb.insertRow();    //注意：插入的必须与下面的在一起,否则造成空行.yl.
        tr1.id="tr"+dynTbIndex;
        tr1.insertCell().innerHTML = '<div align="center"><input id=R0    type=checkBox    size=4 value="删除" onClick="dynDelRow()" ></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R1    type=text   size=10 value="'+ phone_no+'" class="InputGrey" readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R2    type=text   value="'+ isdn_no+'"  class="InputGrey" readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R3    type=text   value="'+ user_name+'" maxlength=10 class="InputGrey"  readonly ></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R4    type=text   value="'+ id_card+'" class="InputGrey"  readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R5    type=text   value="'+ note+'"   class="InputGrey" readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R6    type=text  size=8 value="'+ exec_status+'"  class="InputGrey" readonly ></input></div>';
        dynTbIndex++;
        document.all.addRecordNum.value = document.all.dyntb.rows.length-2;
    }
    
    var addRowNum = 0;
    function validateRow(phoneNo,realNo){
        var flag = false;
        if (addRowNum >= 5){
            rdShowMessageDialog("号码输入最多只能单次添加5条！", 0);
            return false;
        }
        
        $('tr.futionRow').each(function(i, e){
            if ($(this).find('.row-phoneNo').text() == phoneNo ||
                    $(this).find('.row-realNo').text() == realNo){
                rdShowMessageDialog('成员用户号码和短号均不能重复！');
                flag = true;
                return true;
            }
        });
        
        if (flag){
            return false;
        }
        return true;
    }
    function addFusionRow(){
        
        var phoneNo = document.all.short_no.value;
        var realNo = document.all.real_no.value;
        var portalName = document.all.portalName.value;
        var portalPassword = document.all.portalPassword.value;
        
        if (!validateRow(phoneNo, realNo)){
            return;
        }
        
        var contactName = $("#contactName").val();
        var contactPhone = $("#contactPhone").val();
        var $tr  = $('<tr>').attr('class', 'futionRow');
        var $operation = $('<td></td>').appendTo($tr).html('<input type="button" class="b_text deleteRHRow" value="删除"/>');
        var $phoneNo = $('<td class="row-phoneNo">').text(phoneNo).appendTo($tr);
        var $realNo = $('<td class="row-realNo">').text(realNo).appendTo($tr);
        var $portalName = $('<td class="row-portalName">').text(portalName).appendTo($tr);
        var $portalPassword = $('<td class="row-portalPassword">').text(portalPassword).appendTo($tr);
        var $contactName = $('<td class="row-contactName">').text(contactName).appendTo($tr);
        var $contactPhone = $('<td class="row-contactPhone">').text(contactPhone).appendTo($tr);
        if(document.all.RH_openSettledPhone_tr.style.display == ""){
        	var isOpenSettledPhone = $("#isOpenSettledPhone").find("option:selected").text()
        	var settledPhone = $("#settledPhone").val();
        	var $isOpenSettledPhone = $('<td class="row-isOpenSettledPhone">').text(isOpenSettledPhone).appendTo($tr);
        	var $settledPhone = $('<td class="row-settledPhone">').text(settledPhone).appendTo($tr);
        }
        
        setSubmitStatus('increase');
        $('#rhListTarget').append($tr);
        addListenerForDeleteButton();
    }
    
    function setSubmitStatus(flag){
        if (flag == 'increase'){
            addRowNum++;
            $('#showAddRowNum').text(addRowNum);
        } else {
            addRowNum--;
            $('#showAddRowNum').text(addRowNum);
        }
        
        if (addRowNum > 0 ){
            $('#sure').attr('disabled', false);
        } else {
            $('#sure').attr('disabled', 'disabled');
        }
    }
    
    function addListenerForDeleteButton(){
        $('.deleteRHRow').click(function(e){
            e.stopPropagation();
            e.preventDefault();
            
            setSubmitStatus();
            $(this).parents('tr:first').remove();
        });
    }

    function dynDelRow()
    {
        for(var a = document.all.dyntb.rows.length-2 ;a>0; a--)//删除从tr1开始，为第三行
        {
            if(document.all.R0[a].checked == true)
            {
                document.all.dyntb.deleteRow(a+1);
                break;
            }
        }
        document.all.addRecordNum.value = document.all.dyntb.rows.length-2;
    }


    function dyn_deleteAll()
    {
    //清除增加表中的数据
        for(var a = document.all.dyntb.rows.length-2 ;a>0; a--)//删除从tr1开始，为第三行
        {
            document.all.dyntb.deleteRow(a+1);
        }
        document.all.addRecordNum.value = document.all.dyntb.rows.length-2;
    }

    function verifyUnique(phone_no,isdn_no)
    {
        var tmp_phoneNo="";
        var tmp_isdnNo="";
        var op_type = oprType_Add;
        
        for(var a = document.all.dyntb.rows.length-2 ;a>0; a--)//删除从tr1开始，为第三行
        {
            tmp_phoneNo = document.all.R1[a].value;
            tmp_isdnNo = document.all.R2[a].value;
            
            if( op_type == oprType_Add)
            {
                if( (phone_no.trim() == tmp_phoneNo.trim()) || (isdn_no.trim()== tmp_isdnNo.trim())){
                    return false;
                }
            }else{
                if( (isdn_no.trim() == tmp_isdnNo.trim())){
                    return false;
                }
            }
        }
        return true;
    }
    
    function changeOthers(){
        if($("#sm_code").val() == "CR"){
            var vPayFlag = $("#pay_flag").val();
            var vMebMonthFlag = $("#mebMonthFlag").val();
            
            if(vPayFlag == "1" && vMebMonthFlag == "N"){
                document.all.tbs2.style.display = "";
                document.all.tbs3.style.display = "";
            }else{
                document.all.tbs2.style.display = "none";
                document.all.tbs3.style.display = "none";
            }
        }
    }
    
    function changeMatureFlag(){
        var iMatureFlag = $("#matureFlag").val();
        if(iMatureFlag == "Y"){
            $("#matureProdCodeQuery").attr("disabled",false);
        }else{
            $("#matureProdCodeQuery").attr("disabled",true);
        }
    }
    
    function getmatureProdCodeQuery()
    {  
     	var pageTitle = "保年到期转包月产品选择";
        var fieldName = "产品属性代码|产品属性|";    
    		var sqlStr = "";
        var selType = "S";    //'S'单选；'M'多选
        var retQuence = "2|2|3|";
        var retToField = "matureProdCode|matureProdName|";
        var product_id = document.frm.product_id.value;
        //首先判断是否已经选择了集团信息
        if(document.frm.product_id.value == "")
       {
        rdShowMessageDialog("请首先选择集团信息！",0);
        return false;
       }
    	if(PubSimpSelmatureProdAttr(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));
    }
 
    function PubSimpSelmatureProdAttr(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
    {   
        var vGrpProdCode = $("#product_id").val();
        var vOpType = $("#request_type").val();
        var vIdNo = $("#id_no").val();
        var vSmCode = $("#sm_code").val();
        var vRegionCode = $("#iRegionCode").val();
        var vOpCode = $("#op_code").val();
        var vBizCode = $("#iBizCode").val();
        var vPayFlag = "";
        if(vSmCode == "CR"){
            vPayFlag = $("#pay_flag").val();
        }else{
            vPayFlag = "";
        }
        
        var path = "/npage/s7983/fpubmatureProdCode_sel.jsp"; 
        path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
        path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
        path = path + "&selType=" + selType;
        path = path + "&groupFlag=Y";
        path = path + "&product_id=" + document.all.product_id.value;  
        path = path + "&mebMonthFlag=" + document.all.mebMonthFlag.value;  
        path = path + "&payType=" +document.all.pay_flag.value; 
        path = path + "&id_no=" + vIdNo;
        path = path + "&smCode=" + vSmCode;
        path = path + "&regionCode=" + vRegionCode;
        path = path + "&opCode=" + vOpCode;
        path = path + "&bizCode=" + vBizCode;
        path = path + "&payFlag=" + vPayFlag;
        path = path + "&grpProdCode=" + vGrpProdCode;
        path = path + "&opType="+vOpType;
        retInfo = window.open(path,"newwindow","height=450, width=650,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
    	return true;	
    }

    function getmatureProd(retInfo)
    { 
    	var retToField = "matureProdCode|matureProdName|";
    	if(retInfo ==undefined)      
    	{
    		//ChgCurrStep("custQuery");
    		return false;
    	}
    	
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
    
    function getAdditiveBill(){
        var vMebMonthFlag = $("#mebMonthFlag").val();
        var vGrpProdCode = $("#product_id").val();
        var vOpType = $("#request_type").val();
        var vIdNo = $("#id_no").val();
        var vSmCode = $("#sm_code").val();
        var vRegionCode = $("#iRegionCode").val();
        var vOpCode = $("#op_code").val();
        var vBizCode = $("#iBizCode").val();
        var vPayFlag = "";
        var vUnitId= $("#unit_id").val();
        if(vSmCode == "CR"){
            vPayFlag = $("#pay_flag").val();
        }else{
            vPayFlag = "";
          if("186" == "<%=busiFlag%>"){
	        		if($("#addProductName").val() != "" ){
	        			rdShowMessageDialog("不能重复选择附加套餐！");
								return false;
	        		}
        	}
        }
        var path = "/npage/s7983/pubAdditiveBill.jsp";
        path = path + "?mebMonthFlag=" + vMebMonthFlag;
        path = path + "&grpProdCode=" + vGrpProdCode;
        path = path + "&opType="+vOpType;
        path = path + "&id_no=" + vIdNo;
        path = path + "&smCode=" + vSmCode;
        path = path + "&regionCode=" + vRegionCode;
        path = path + "&opCode=" + vOpCode;
        path = path + "&bizCode=" + vBizCode;
        path = path + "&payFlag=" + vPayFlag;
        path = path + "&unitId=" + vUnitId;
        path = path + "&userType=" + $('select[name="F70019"]').val();
        
        retInfo = window.open(path,"newwindow","height=450, width=400,top=90,left=300,scrollbars=yes, resizable=no,location=no, status=yes");
    	return true;
    }


    
    function getAdditiveBillYH(){
        var vMebMonthFlag = $("#mebMonthFlag").val();
        var vGrpProdCode = $("#product_id").val();
        var vOpType = $("#request_type").val();
        var vIdNo = $("#id_no").val();
        var vSmCode = $("#sm_code").val();
        var vRegionCode = $("#iRegionCode").val();
        var vOpCode = $("#op_code").val();
        var vBizCode = $("#iBizCode").val();
        var vPayFlag = "";
        var vUnitId= $("#unit_id").val();
        if(vSmCode == "CR"){
            vPayFlag = $("#pay_flag").val();
        }else{
            vPayFlag = "";
          if("186" == "<%=busiFlag%>"){
	        		if($("#addProductNameYH").val() != "" ){
	        			rdShowMessageDialog("不能重复选择附加套餐！");
								return false;
	        		}
        	}
        }
        var path = "pubAdditiveBillYH.jsp";
        path = path + "?mebMonthFlag=" + vMebMonthFlag;
        path = path + "&grpProdCode=" + vGrpProdCode;
        path = path + "&opType="+vOpType;
        path = path + "&id_no=" + vIdNo;
        path = path + "&smCode=" + vSmCode;
        path = path + "&regionCode=" + vRegionCode;
        path = path + "&opCode=" + vOpCode;
        path = path + "&bizCode=" + vBizCode;
        path = path + "&payFlag=" + vPayFlag;
        path = path + "&unitId=" + vUnitId;
        path = path + "&userType=" + $("#selectAdditiveYH").attr("v_result");
        
        retInfo = window.open(path,"newwindow","height=450, width=400,top=90,left=300,scrollbars=yes, resizable=no,location=no, status=yes");
    	return true;
    }    
    
    
   function doQueryRateYH(rateCode,rateName){
						$("#addProductIdYH").val(rateCode);
            $("#addProductNameYH").val(rateName);
    }    
    
    
    
    /* getAdditiveBill()方法中获取的新资费信息，在pubAdditiveBill.jsp中调用 */
    function doQueryRate(rateCode,rateName){
        if($("#sm_code").val() != "CR"){
            $("#addProductId").val(rateCode);
            $("#addProductName").val(rateName);
            if("186" == "<%=busiFlag%>"){
							var packet = new AJAXPacket("f7983_ajax_isOpenRHFlag.jsp","正在提交，请稍候......");
							packet.data.add("iSmCode","<%=iSmCode%>");
							packet.data.add("busiFlag","<%=busiFlag%>");
							packet.data.add("rateCode",rateCode);
							core.ajax.sendPacket(packet,doIsOpenRHFlag);
							packet = null;     	
            }
        }else{
            $("#addProductIdCR").val(rateCode);
            $("#addProductNameCR").val(rateName);
            $("#pay_flag").find("option:not(:selected)").remove(); // 彩铃时，选择附加套餐后，付费方式改为不可变。
        }
			
			set_F80000();
			        
      if($("#sm_code").val() == "RH"){
        go_check_FIELD_CODE3(rateCode);
      }
      
      var userType = $('select[name="F70019"]').val();
      if (userType =="1"
         &&$("#sm_code").val() == "RH" 
         && "186" == '<%=busiFlag%>'){
      	go_check_scommoncode(rateCode);
      }
    }

   	function go_check_scommoncode(offerId){
   		var packet = new AJAXPacket("f7983_go_check_scommoncode.jsp","正在提交，请稍候......");
					packet.data.add("offerId",offerId);
					core.ajax.sendPacket(packet,do_check_scommoncode);
					packet = null;    
   	}
   	
   	function do_check_scommoncode(packet){
			var retCode = packet.data.findValueByName("retCode");
			var retMsg = packet.data.findValueByName("retMsg");
			var result = packet.data.findValueByName("result");
			$("#selectAdditiveYH").attr("v_result","");
			
   		if(result != ""){
   			$("#td_addProductNameYH2").show();
   			$("#td_addProductNameYH1").show();
   			$("#td_addProductNameYH4").hide();
   			$("#td_addProductNameYH3").hide();
   			
   			$("#selectAdditiveYH").attr("v_result",result);
   			$("#selectAdditiveYH").removeAttr("disabled");
   		}
   		
   	}   	
   	    
   	function doIsOpenRHFlag(packet){
			var retCode = packet.data.findValueByName("retCode");
			var retMsg = packet.data.findValueByName("retMsg");
			var isOpenCountFlag = packet.data.findValueByName("isOpenCountFlag");
   		if(retCode == "000000"){
   			$("#isOpenCountFlagHidden").val(isOpenCountFlag);
   		}else{
   			rdShowMessageDialog("判断是否开通移动固话失败！错误代码："+retCode+"错误信息："+retMsg,0);
   			$("#isOpenCountFlagHidden").val("0");
   			return false;
   		}
   	}
   	
   	//-----------关于黑龙江省边防总队集团固话新增资费开发配置需求的函------------hejwa-------2015-8-17 16:53:13--------
   	
   	function go_check_FIELD_CODE3(rateCode){
   		var packet = new AJAXPacket("f7983_go_check_FIELD_CODE3.jsp","正在提交，请稍候......");
							packet.data.add("rateCode",rateCode);
							core.ajax.sendPacket(packet,do_check_FIELD_CODE3);
							packet = null;    
   	}
    function do_check_FIELD_CODE3(packet){
    	var retCode = packet.data.findValueByName("code");
			var retMsg = packet.data.findValueByName("msg");
			
			var result = packet.data.findValueByName("result");
			
			if(result!="0"){//统付方式只能选择统付
				$("#pay_flag option[value='1']").remove();
			}else{
					//<option value="1">1--个人付费</option>					
				if($("#pay_flag option[value='1']").size()==0){
					$("#pay_flag").append("<option value='1'>1--个人付费</option>");
				}
			}
			
			
    }
    
    
/// begin    add by yanpx 20091126
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
	rdShowMessageDialog("日期格式有误，正确格式为“年年年年月月日日”，请重新输入！");
	//obj.value="";
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
       rdShowMessageDialog("年的格式有误，有效年份应介于1900-3000之间，请重新输入！");
	   //obj.value="";
	   obj.select();
	   obj.focus();
	   return false;
	 }
     if(myParseInt(month)<1 || myParseInt(month)>12)
	 {
       rdShowMessageDialog("月的格式有误，有效月份应介于01-12之间，请重新输入！");
  	   //obj.value="";
	   obj.select();
	   obj.focus();
	   return false;
	 }
     if(myParseInt(day)<1 || myParseInt(day)>31)
	 {
       rdShowMessageDialog("日的格式有误，有效日期应介于01-31之间，请重新输入！");
	   //obj.value="";
	   obj.select();
       obj.focus();
	   return false;
	 }

     if (month == "04" || month == "06" || month == "09" || month == "11")  	         
	 {
         if(myParseInt(day)>30)
         {
	 	     rdShowMessageDialog("该月份最多30天,没有31号！");
 	         //obj.value="";
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
 		     rdShowMessageDialog("闰年二月份最多29天！");
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
 		     rdShowMessageDialog("非闰年二月份最多28天！");
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
function doEncryptPwdBack(packet)
{
	var retcode = packet.data.findValueByName("retcode");
	var retmsg = packet.data.findValueByName("retmsg");
	var returnPwd = packet.data.findValueByName("returnPwd");
	if(retcode != "000000")
	{
		rdShowMessageDialog("密码加密失败",0);
		document.all.F81021.value = "";
	}
	else
	{
		 document.all.F81021.value = returnPwd;
	}
}

    function refMain(){

        <% if(resultList.length>0){ %>
        if(!checkDynaFieldValues(false)){
			return false;
		}
		<%}%>
    	if ( document.all.F81021 != null  )
    	{
    		var re=/^([0-9a-zA-Z]*)$/; 

    		if ( 0 == document.all.F81021.value.trim().length  )
    		{
    			rdShowMessageDialog("WLAN用户密码必须填写",0);
    			return false;
    		}
    		
    		if ( 6 > document.all.F81021.value.trim().length )
    		{
     			rdShowMessageDialog("WLAN用户密码长度必须是6到8位",0);
    			return false;   			
    		}
    		
    		if ( !re.test(document.frm.F81021.value) )
    		{
    			rdShowMessageDialog("WLAN用户密码必须是纯数字，纯字母，或者数字字母组合",0);
    			return false;
    		}
    		
			var getEncryptPwd_Packet = new AJAXPacket("/npage/public/pubBroadEncrypt.jsp","密码加密，请稍候......");
			getEncryptPwd_Packet.data.add("encryptType","encrypt");
			getEncryptPwd_Packet.data.add("password",document.all.F81021.value);
			core.ajax.sendPacket(getEncryptPwd_Packet,doEncryptPwdBack);
			getEncryptPwd_Packet = null;
    		
    	}
        var ind1Str ="";
        var ind2Str ="";
        var ind3Str ="";
        var ind4Str ="";
        var ind5Str ="";

        /* vpmn时,拼写数据 */
        if($("#sm_code").val() == "vp"){
            if($("#vpmnInputType").val() == "vpmnMulti"){         //vpmn号码录入
                if( dyntb.rows.length == 2){//缓冲区没有数据
                    rdShowMessageDialog("没有指定成员号码，请增加数据!",0);
                    return false;
                }else{
                    for(var a=1; a<document.all.R0.length ;a++)//删除从tr1开始，为第三行
                    {
                        ind1Str =ind1Str +document.all.R1[a].value+"|";
                        ind2Str =ind2Str +document.all.R2[a].value+"|";
                        ind3Str =ind3Str +document.all.R3[a].value+"|";
                        ind4Str =ind4Str +document.all.R4[a].value+"|";
                        ind5Str =ind5Str +document.all.R5[a].value+"|";
                    }
                }
                
                //2.对form的隐含字段赋值
                
                document.all.tmpR1.value = ind1Str;
                document.all.tmpR2.value = ind2Str;
                document.all.tmpR3.value = ind3Str;
                document.all.tmpR4.value = ind4Str;
                document.all.tmpR5.value = ind5Str;
            }else{  //vpmn文件录入
                if($("#vpmnPosFile").val() == ""){    //文件录入
                    rdShowMessageDialog("请选择文件！",0);
                    $("#vpmnPosFile").focus();
                    return false;
                }
            }
            //wangzn 091205 B
            //alert("["+document.all.limitcount.value+"]");
            //alert("["+document.all.F80003.value+"]");
            if(document.all.limitcount.value=="1"&&document.all.F80003.value=="0")
					{
							rdShowMessageDialog("该集团主资费不可使用，请为集团成员选择个人套餐资费!");
			        return false;
					}
					if(document.all.limitcount.value=="1"&&document.all.F80004.value=="0")
					{
							rdShowMessageDialog("该集团主资费不可使用，请为集团成员选择个人套餐资费!");
			        return false;
					}
            //wangzn 091205 E
            
            
        }else if ($("#sm_code").val() == "RH" && "186" == '<%=busiFlag%>'){
            var ind1Str = '';
            var ind2Str = '';
            var ind4Str = '';
            var ind3Str = '';
            var ind6Str = '';
            var ind7Str = '';
            var ind8Str = '';
            
            $('.futionRow').each(function(i, e){
                ind1Str += $(this).find('.row-phoneNo').text() + '|';
                ind2Str += $(this).find('.row-realNo').text() + '|';
                ind4Str += $(this).find('.row-portalName').text() + '|';
                ind3Str += $(this).find('.row-portalPassword').text() + '|';
                ind6Str += $(this).find('.row-settledPhone').text() + '|';
                ind7Str += $(this).find('.row-contactName').text() + '|';
                ind8Str += $(this).find('.row-contactPhone').text() + '|';
            });
            document.all.tmpR1.value = ind1Str;
            document.all.tmpR2.value = ind2Str;
            document.all.tmpR4.value = ind4Str;
            document.all.tmpR3.value = ind3Str;
            document.all.tmpR6.value = ind6Str;
            document.all.tmpR7.value = ind7Str;
            document.all.tmpR8.value = ind8Str;
            
            //$('#pay_flag').removeAttr('disabled'); // update for 关于融合通信聚类和家庭客户营帐优化需求的函@2014/12/21 
        } else if($("#sm_code").val() == "j1"){	//wanghfa添加此判断体 2010-12-2 16:43 移动总机j1接入BOSS系统
            if ($("#inputType").val() == "multi") {         //j1号码录入
                if ( dyntb.rows.length == 2) {//缓冲区没有数据
                    rdShowMessageDialog("没有指定成员号码，请增加数据！",0);
                    return;
                } else {
                    for(var a=1; a<document.all.R0.length ;a++) {
                        ind1Str =ind1Str + document.all.R1[a].value+"|";
                        ind2Str =ind2Str + document.all.R2[a].value+"|";
                        ind3Str =ind3Str + document.all.R3[a].value+"|";
                        //ind4Str =ind4Str + document.all.R4[a].value+"|";
                        ind5Str =ind5Str + document.all.R5[a].value+"|";
                    }
                }
                
                //2.对form的隐含字段赋值
                
                document.all.tmpR1.value = ind1Str;
                document.all.tmpR2.value = ind2Str;
                document.all.tmpR3.value = ind3Str;
                document.all.tmpR4.value = ind4Str;
                document.all.tmpR5.value = ind5Str;
            } else if ($("#inputType").val() == "file") {  //j1文件录入
                if($("#vpmnPosFile").val() == ""){    //文件录入
                    rdShowMessageDialog("请选择文件！",0);
                    $("#vpmnPosFile").focus();
                    return false;
                }
            }
            
        } else if($("#sm_code").val() == "np"){
            if($("#allPayFlag").val() == "1"){
                if($("#allFlag").val() == "0"){
                    if($("#cycleMoney").val() == ""){
                        rdShowMessageDialog("请您输入定额金额！",0);
                        $("#cycleMoney").focus();
                        return false;
                    }else{
                        if(!forMoney(document.all.cycleMoney)){
                            $("#cycleMoney").val("");
                            $("#cycleMoney").focus();
                            return false;
                       }
                    }
                }
                if($("#beginDate").val() == ""){
                    rdShowMessageDialog("请您输入开始时间！",0);
                    $("#beginDate").focus();
                    return false;
                }else{
                    if(!forDate(document.all.beginDate)){
                        $("#beginDate").val("");
                        $("#beginDate").focus();
                        return false;
                    }
                }
                
                if($("#endDate").val() == ""){
                    rdShowMessageDialog("请您输入结束时间！",0); 
                    $("#endDate").focus();
                    return false;
                }else{
                    if(!forDate(document.all.endDate)){
                        $("#endDate").val("");
                        $("#endDate").focus();
                        return false;
                    }
                }
                
                if($("#beginDate").val()<"<%=dateStr%>"){
                    rdShowMessageDialog("开始时间应不小于当前日期！",0);
                    $("#beginDate").val("");
                    $("#beginDate").focus();
                    return false;
                }
                
                if($("#beginDate").val() > $("#endDate").val()){
                    rdShowMessageDialog("结束时间应不小于开始日期！",0);
                    $("#endDate").val("");
                    $("#endDate").focus();
                    return false;
                }
            }
            
            if(document.all.input_type[0].checked){         //单个录入
                if($("#single_phoneno").val() == ""){
                    rdShowMessageDialog("成员用户手机号码不能为空！",0);
                    $("#single_phoneno").focus();
                    return false;
                }else{
                    if(!forMobil(document.all.single_phoneno)){
                        return false;
                    }
                }
            }else if(document.all.input_type[1].checked){    //批量录入
                if($("#multi_phoneNo").val() == ""){
                    rdShowMessageDialog("号码不能为空！",0);
                    $("#multi_phoneNo").focus();
                    return false;
                } else {	//2011/7/7 wanghfa添加 解决入参空格导致服务down掉
                	while ($("#multi_phoneNo").val().indexOf(" ") != -1) {
	                	$("#multi_phoneNo").val($("#multi_phoneNo").val().replace(" ", ""));
                	}
                }
            }else{
                if($("#PosFile").val() == ""){    //文件录入
                    rdShowMessageDialog("请选择文件！",0);
                    $("#PosFile").focus();
                    return false;
                }
            }
            
        }else if($("#sm_code").val() == "hj" && "214" == $('#uniqueStatus').val()) {
        	//liujian 2013-1-29 14:18:52 add
			if ($("#inputType").val() == "multi") {
				$('#extPhoneSubTbody').find('tr').length == 0
                if ($('#extPhoneSubTbody').find('tr').length == 0) {
                    rdShowMessageDialog("分机号码列表为空，请增加数据！",0);
                    return;
                } else {
                	$('#extPhoneSubTbody').find('tr').each(function() {
                			ind1Str = ind1Str + $(this).find("td:eq(1)").text() + "|";
                			ind2Str = ind2Str + $(this).find("td:eq(2)").text() + "|";
                	});
                }
                
                //2.对form的隐含字段赋值
                document.all.tmpR1.value = ind1Str;
                document.all.tmpR2.value = ind2Str;
            } else if ($("#inputType").val() == "file") {
                if($("#extUploadFile").val() == ""){ 
                    rdShowMessageDialog("请选择文件！",0);
                    $("#vpmnPosFile").focus();
                    return false;
                }
            }
        }else{
            if(document.all.input_type[0].checked){         //单个录入
                if($("#single_phoneno").val() == ""){
                    rdShowMessageDialog("成员用户手机号码不能为空！",0);
                    $("#single_phoneno").focus();
                    return false;
                }else{
                    if(!forMobil(document.all.single_phoneno)){
                        return false;
                    }
                }
            }else if(document.all.input_type[1].checked){    //批量录入
                if($("#multi_phoneNo").val() == ""){
                    rdShowMessageDialog("号码不能为空！",0);
                    $("#multi_phoneNo").focus();
                    return false;
                } else {	//2011/7/7 wanghfa添加 解决入参空格导致服务down掉
                	while ($("#multi_phoneNo").val().indexOf(" ") != -1) {
	                	$("#multi_phoneNo").val($("#multi_phoneNo").val().replace(" ", ""));
                	}
                }
            }else{
                if($("#PosFile").val() == ""){    //文件录入
                    rdShowMessageDialog("请选择文件！",0);
                    $("#PosFile").focus();
                    return false;
                }
            }
            
            if($("#sm_code").val() == "AD" || $("#sm_code").val() == "ML" || $("#sm_code").val() == "MA"){
                if($("#request_type").val() == '03' || $("#request_type").val() == '04'){
                    if($("#expect_time").val() == ""){
                        rdShowMessageDialog("请输入期望日期！",0);
                        $("#expect_time").select();
                        $("#expect_time").focus();
                        return false;
                    }else{
						if(validDate(document.all.expect_time)==false) return false;
                    }
                }
            }  
          }

        if($("#sm_code").val() == "ap" && document.all.input_type[0].checked){
            if(document.all.F81008 != null && document.all.F81008.value == "0"){
                if($("#F81002").val() == ""){
                    rdShowMessageDialog("请输入IP地址！",0);
                    $("#F81002").focus();
                    return false;
                }else{
                    if(!forIp(document.all.F81002)){
                        return false;
                    }
                }
            }
        }
        if($("#sm_code").val() == "ZH" && document.all.input_type[0].checked){//haoyy add 2012/7/23 15:12 增加智慧城管对静态ip地址的验证
            if(document.all.F81008 != null && document.all.F81008.value == "0"){
                if($("#F81002").val() == ""){
                    rdShowMessageDialog("请输入IP地址！",0);
                    $("#F81002").focus();
                    return false;
                }else{
                    if(!forIp(document.all.F81002)){
                        return false;
                    }
                }
            }
        }
        if($("#sm_code").val() == "ap" || $("#sm_code").val() == "ZH"){//diling add 2012/7/23 15:12 增加智慧城管对静态ip地址的验证，如为IP类型为动态，则不需要输入ip地址
            if(document.all.F81008 != null && document.all.F81008.value == "1"){
                if($("#F81002").val() != ""){
                    $("#F81002").val("");
                }
            }
        }
        <%if("".equals(packFlag)){%>
            if($("#sm_code").val() != "CR"){
                if($("#addProductId").val() == ""){
                    rdShowMessageDialog("请您选择附加资费！",0);
                    $("#selectAdditive").focus();
                    return false;
                }
            }else{
                if($("#addProductIdCR").val() == ""){
                    rdShowMessageDialog("请您选择附加资费！",0);
                    $("#selectAdditiveCR").focus();
                    return false;
                }
            }
        <%}%>
        
        if($("#pay_flag").val()=="1" && $("#mebMonthFlag").val()=="N" && $("#matureFlag").val()=="Y" && $("#matureProdCode").val()==""){
            rdShowMessageDialog("请您选择包年转包月产品！",0);
            $("#matureProdCodeQuery").focus();
            return false;
        }        
        var phonNos = document.all.tmpR2.value;
		var phonNoArr = phonNos.split("\|");
		var phonNosLength = phonNoArr.length;
		if(phonNosLength > 2){
			$("#phoneFlag").val("more");
		}
		if($("#inputType").val() == 'file' || $("#vpmnInputType").val() == 'vpmnFile'){
			$("#phoneFlag").val("file");
		}
		$("#phonNosLength").val(phonNosLength);
        	   // 文件录入的方式 多余一个时， 并且是 vpmn
        if(("<%=iSmCode%>" == "vp") && ( $("#inputType").val() == 'file' || $("#vpmnInputType").val() == 'vpmnFile' || phonNosLength>2 ) ){
        	$("#phonNosLength").val(3);//数字无实际意义，让其大于2，是为了，下个页面能打印免填单,将多余1个和文件上传打印合在一起
        	 <% if(resultList.length>0){ %>
    			spellList();
    		 <% } %>
    		 
    		       if($("#F80003").val()!=undefined)
                {
                  if($("#F80004").val()!=undefined)
                  {
                  $('#F80004').val($('#F80003').val());
                  }
                }
                
               
    		 
        	    document.frm.target="_self";
    		    document.frm.encoding="application/x-www-form-urlencoded";
        		frm.action="f7983_2.jsp";
    		    frm.method="post";
    		    frm.submit();
        }else{
        showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes");
        
        var confirmFlag=0;
		confirmFlag = rdShowConfirmDialog("是否提交本次操作？");
		if (confirmFlag==1) {
		    <% if(resultList.length>0){ %>
    			spellList();
    		<% } %>
    		
    		    		if($("#F80003").val()!=undefined)
                {
                  if($("#F80004").val()!=undefined)
                  {
                  $('#F80004').val($('#F80003').val());
                  }
                }
                
    		$("#sure").attr("disabled",true);
    		if($("#inputType").val() == 'file' || $("#vpmnInputType").val() == 'vpmnFile' || ('<%=iSmCode%>'== 'RH' && '<%=busiFlag%>' == '186')){
        		document.frm.target="_self";
    		    document.frm.encoding="application/x-www-form-urlencoded";
    		}

			frm.action="f7983_2.jsp";
    		frm.method="post";
    		frm.submit();
    		$("#sure").attr("disabled",true);
    		loading();
		} else {
   		$("#sure").attr("disabled",false);
			if ( document.all.F81021 != null  )
			{
				document.all.F81021.value = "";
			}
			return;	
		}
        }
     
    }
    
	//打印信息
	function printInfoVP(printType)
	{ 
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
		
		
		var phonNo = "";
		var tmpOpCode= "<%=opCode%>";
		var thisType = $("#F80003 option:selected").text().split("-->")[1]; // 当月套餐类型
		var thatType = $("#F80004 option:selected").text().split("-->")[1]; // 下月套餐类型
		if(thisType == "初始值"){
			thisType = $("#attr").val();
		}
		if(thatType == "初始值"){
			thatType = $("#attr").val();
		}
	    var phonNos = document.all.tmpR2.value;
		var phonNoArr = phonNos.split("\|");
		//if(phonNoArr.length > 2){
		//	for(var i=0;i<phonNoArr.length-1;i++){
				///if(i == phonNoArr.length-2){
				//	phonNo = phonNo + phonNoArr[i];
				//}else{
		//		    phonNo = phonNo + phonNoArr[i] + ",";
			    //}
		//	}
		//}else{
	        phonNo = phonNoArr[0];
	    //}
		var nameN = document.all.tmpR3.value.substr(0,document.all.tmpR3.value.indexOf("\|"));
		var shortNo = document.all.tmpR1.value.substr(0,document.all.tmpR1.value.indexOf("\|"));
		
		cust_info += "客户姓名：   "+document.frm.grp_name.value+"|";
		cust_info += "证件号码：   "+document.frm.iccid.value+"|";
		cust_info += "集团客户编码：   "+document.frm.cust_id.value+"|";
		
    	//retInfo+="用户名称:"+document.frm.grp_name.value+"|";
    	opr_info+="集团产品名称：   "+document.frm.product_name.value+"|";
    	opr_info+="业务类型：   集团成员增加"+"|";
    	
        opr_info+="手机号：   "+phonNo+"|";
        if(phonNoArr.length == 2){
        opr_info+="姓名：   "+nameN+"|";
    	opr_info+="当月集团V网资费套餐名称：   "+thisType+"|";
    	opr_info+="下月集团V网资费套餐名称：   "+thatType+"|";
    	opr_info+="新短号：   "+shortNo+"|";
    	
        }
    	
    	opr_info+="流水：   "+document.frm.sysAccept.value+"|";
    	opr_info+="操作工号：   "+'<%=workNo%>'+"|";
    	opr_info+="操作时间：   "+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
    
    retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
		retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
		return retInfo;	
	   
	}
	
	
		function printInfo(printType)
	{ 
	
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
		
		cust_info += "客户姓名：   "+document.frm.grp_name.value+"|";
		cust_info += "证件号码：   "+document.frm.iccid.value+"|";
		cust_info += "集团客户编码：   "+document.frm.cust_id.value+"|";
		
   
    
    opr_info += "集团产品名称：   "+document.frm.product_name.value+"|";
    opr_info += "业务类型：   集团成员增加"+"|";
    opr_info += "流水：   "+document.frm.sysAccept.value+"|";
		
		note_info1 += document.frm.op_note.value+"|";
		
		retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
		retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
		return retInfo;	
		
	}
    
     function showPrtDlg(printType,DlgMessage,submitCfm){
      var h=180;
			var w=350;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			
			var pType="subprint";             				 		//打印类型：print 打印 subprint 合并打印
			var billType="1";              				 			  //票价类型：1电子免填单、2发票、3收据
			var sysAccept =document.frm.sysAccept.value;       //流水号
			var mode_code=null;           							  //资费代码
			var fav_code=null;                				 		//特服代码
			var area_code=null;             				 		  //小区代码
			var opCode = "<%=opCode%>";
			
		var hljPrint="hljPrint.jsp";
		if("<%=iSmCode%>" == "vp"){
			printStr = printInfoVP(printType);
		    hljPrint = "hljPrint_jt.jsp";	
		}else{
			printStr = printInfo(printType);
		}
		if(printStr == "failed")
		{
			return false;
		}
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
    
    function changePayFlag(){
    	if(document.all.allPayFlag.value=="0")
    	{
    		document.all.line_111.style.display="none";
    		document.all.line_1.style.display="none";
    		document.all.line_2.style.display="none";
    	}
    	else
    	{
    		document.all.line_111.style.display="";
    		document.all.line_1.style.display="";
    		document.all.line_2.style.display="";
    	}
    }
    
    function changeFlag(){
    	if(document.all.allFlag.value=="1"){
    		document.all.line_111.style.display="none";
    		document.all.cycleMoney.value="0";
    	}
    	else{
    		document.all.line_111.style.display="";
    		document.all.cycleMoney.value="";
    	}
    }
    
    function call_flags()
    {
        var h=480;
        var w=800;
        var t=screen.availHeight/2-h/2;
        var l=screen.availWidth/2-w/2;
        var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
        var str=window.showModalDialog('user_flags.jsp?flags='+document.frm.F80016.value+'&sm_code='+$("#sm_code").val(),"",prop);
        if( typeof(str) != "undefined" ){
            document.frm.F80016.value = str;
        }
        return true;
    }
    
    // zhouby add
    function call_rh_flags(){
        var h=480;
        var w=800;
        var t=screen.availHeight/2-h/2;
        var l=screen.availWidth/2-w/2;
        var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
        var str=window.showModalDialog('user_rh_flags.jsp?flags='+ document.frm.F01002.value + '&sm_code=' + $("#sm_code").val(), "", prop);
        if( typeof(str) != "undefined" ){
            document.frm.F01002.value = str;
        }
        return true;
    }
    
    function phoneNoCheck(){
        if($("#single_phoneno").val() == ""){
            rdShowMessageDialog("成员用户手机号码不能为空！",0);
            $("#single_phoneno").focus();
            return false;
        }else{
            if(!forMobil(document.all.single_phoneno)){
                return false;
            }
        }
        
         /*2016/8/24 14:26:34 gaopeng 合同有效期
							新增属性：合同有效期，文本框录入，格式YYYYMM，判断至少大于等于下月
							*/
							if(typeof($('#F87004'))!="undefined"&&typeof($('#F87004').val())!="undefined"){
								$('#F87004').attr("v_type","date.year_month");
								if($('#F87004').val().trim()==""){
										rdShowMessageDialog("合同有效期不能为空!",0);
										$('#F87004').focus();
								    return false;	
								}
								if(!checkElement(document.frm.F87004)){ 
											return false;
								}
								var nowTimeMo = $.trim($('#F87004').val());
								if(Number(nowTimeMo) < Number("<%=addMonthTStr%>")){
									rdShowMessageDialog("合同有效期至少是下个月[<%=addMonthTStr%>]！");
									$('#F87004').focus();
									return false;
								}
								
							}
                
        var vLoginNo = "<%=workNo%>";
        var vLoginPwd = "<%=workPwd%>";
        var vOpCode = "<%=opCode%>";
        var vOrgCode = "<%=orgCode%>";
        var vGrpIdNo = $("#id_no").val();
        var vPhoneNo = $("#single_phoneno").val();
        var vProductId = $("#product_id").val();
        var vSmCode = $("#sm_code").val();
        var vRequestType = $("#request_type").val();
        
        var myPacket = new AJAXPacket("<%=request.getContextPath()%>/npage/s7983/pubCheckPhoneNo.jsp","正在进行手机号码校验，请稍候......");
        myPacket.data.add("retType","checkPhone");
    	myPacket.data.add("loginNo",vLoginNo);
    	myPacket.data.add("loginPwd",vLoginPwd);
    	myPacket.data.add("opCode",vOpCode);
    	myPacket.data.add("orgCode",vOrgCode);
    	myPacket.data.add("grpIdNo",vGrpIdNo);
    	myPacket.data.add("phoneNo",vPhoneNo);
    	myPacket.data.add("productId",vProductId);
    	myPacket.data.add("smCode",vSmCode);
    	myPacket.data.add("requestType",vRequestType);
    	core.ajax.sendPacket(myPacket);
    	myPacket = null;
    }
    
    function doUnLoading(){
        $("#sure").attr("disabled",false);
        unLoading();
    }
//关于基于新固话业务的六款资费上线的开发需求函 hejwa 2016-7-7 10:49:54 后台 yull    
$(document).ready(function(){
	
	$("#F80000").attr("disabled","disabled");
	
	$("#F70019").change(set_F80000);
	
});

function set_F80000(){
	<%if ("RH".equals(iSmCode) && "186".equals(busiFlag)){%>
		    var packet = new AJAXPacket("ajax_check_F80000.jsp","请稍后...");
		        packet.data.add("InNewRate",$("#addProductId").val());
		        packet.data.add("vSrvCode","<%=busiFlag%>");
		    core.ajax.sendPacket(packet,do_set_F80000);
		    packet =null;
	<%}%>		    
		
		 var userType = $('select[name="F70019"]').val();
		if(userType!="1"){
			$("#addProductNameYH").val("");
			$("#addProductIdYH").val("");
			
			$("#selectAdditiveYH").attr("disabled","disabled");
			$("#td_addProductNameYH2").hide();
   		$("#td_addProductNameYH1").hide();
   		
   		$("#td_addProductNameYH4").show();
   		$("#td_addProductNameYH3").show();
   			
		}
}

function do_set_F80000(packet){
    var error_code = packet.data.findValueByName("code");//返回代码
    var error_msg =  packet.data.findValueByName("msg");//返回信息

		var result =  packet.data.findValueByName("result");
		
		if($("#F70019").val()=="1"&&"<%=a290_flag%>"=="true"&&result=="1"){
			if($("#F80000").val()!=undefined){
				$("#F80000").removeAttr("disabled");
			}
		}else{
			if($("#F80000").val()!=undefined){
				$("#F80000").attr("disabled","disabled");
			}
		}
}
</script>

</head>
<body>
<form name="frm" action="" method="post" >
<%@ include file="/npage/include/header.jsp" %>
<div class="title">
	<div id="title_zi">集团用户信息查询</div>
</div>
<table cellspacing=0>
    <tr>
        <td class='blue' nowrap width='18%'>证件号码</td>
        <td width='32%'><input type='text' name='iccid' id='iccid' value='<%=iIccid%>' v_must='1' />
            <input type='button' class='b_text' name='iccid_query' id='iccid_query' value='查询' onClick="getCustInfo()" />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap width='18%'>集团客户ID</td>
        <td>
            <input type='text' id='cust_id' name='cust_id' value='<%=iCustId%>' v_must='1' />
            <font class='orange'>*</font>
        </td>
    </tr>
    
    <tr>
        <td class='blue' nowrap>集团编号</td>
        <td>
            <input type='text' name='unit_id' id='unit_id' value='<%=iUnitId%>' v_must='1' />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap>集团号或智能网编号</td>
        <td>
            <input type='text' id='service_no' name='service_no' value='<%=iServiceNo%>' v_must='1' />
            <font class='orange'>*</font>
        </td>
    </tr>
    
    <tr>
        <td class='blue' nowrap>产品名称</td>
        <td>
            <input type='text' id='product_name' name='product_name' value='<%=iProductName%>' readOnly/>
            <input type='hidden' name='product_id' id='product_id' value='<%=iProductId%>' v_must='1' readOnly />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap>产品付费账户</td>
        <td>
            <input type='text' id='account_id' name='account_id' value='<%=iAccountId%>' v_must='1' readOnly />
            <font class='orange'>*</font>
        </td>
    </tr>
    
    <tr>
        <td class='blue' nowrap>品牌名称</td>
        <td>
            <input type='text' name='sm_name' id='sm_name' value='<%=iSmName%>' v_must='1' readOnly />
            <input type='hidden' name='sm_code' id='sm_code' value='<%=iSmCode%>' v_must='1' readOnly />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap>归属地区</td>
        <td>
            
            <select name="belong_code" id="belong_code">
<%
				try
				{
					String sqlStr2 = "select substr(:org_code,1,2),substr(:org_code,1,7)||'|'||:GroupId,'工号所在地' from dual";
					System.out.println("sqlStr================"+sqlStr2);
					System.out.println("org_code="+orgCode+",GroupId="+groupId);
                    String paraIn1="org_code="+orgCode+",GroupId="+groupId;
                    %>
                    <wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode14" retmsg="retMsg14" outnum="3" >
                    	<wtc:param value="<%=sqlStr2%>"/>
                    	<wtc:param value="<%=paraIn1%>"/> 
                    </wtc:service>
                    <wtc:array id="retArr14" scope="end"/>
                    <%
                    if(retCode14.equals("000000") && retArr14.length>0){
                        result = retArr14;
                    }
					int recordNum = result.length;
					for(int i=0;i<recordNum;i++)
					{
					    if("2".equals(nextFlag) && iBelongCode.equals(result[i][1])){
						%>
						    <option value="<%=result[i][1]%>" selected><%=result[i][1]%>--<%=result[i][2]%></option>
						<%
					    }else{
					    %>
						    <option value="<%=result[i][1]%>"><%=result[i][1]%>--<%=result[i][2]%></option>
						<%
					    }
					}
				}catch(Exception e){
					System.out.println("Call Service TlsPubSelCrm is Failed!");
				}
%>
            </select>
        </td>
    </tr>
    
    <tr>
        <td class='blue' nowrap>集团产品密码</td>
        <td>
            <jsp:include page="/npage/common/pwd_8.jsp">
                <jsp:param name="width1" value="16%"  />
                <jsp:param name="width2" value="34%"  />
                <jsp:param name="pname" value="product_pwd"  />
                <jsp:param name="pwd" value="<%=iProductPwd%>"  />
            </jsp:include>
            <input type='button' class='b_text' id='chk_productPwd' name='chk_productPwd' onClick='chkProductPwd()' value='校验' />
            <font class="orange">*</font>
        </td>

        <td class='blue' nowrap>
			<span id='requestTab1' name='requestTab1' style="display:<%=requestListShow%>">
			操作类型
			</span>&nbsp;
		</td>
		<td >
			<span id='requestTab2' name='requestTab2' style="display:<%=requestListShow%>">
				<select name="request_type" id="request_type">
				    <option value=' '>---请选择---</option>
				    <option value='01'
				    <%
				        if("01".equals(iRequestType)){
				            out.print(" selected ");
				        }
				    %>
				    >01->通用类</option>
				    <option value='02'
				    <%
				        if("02".equals(iRequestType)){
				            out.print(" selected ");
				        }
				    %>    
				    >02->IPT类</option>
				    <option value='03'
				    <%
				        if("03".equals(iRequestType)){
				            out.print(" selected ");
				        }
				    %>
				    >03->黑名单类</option>
				    <option value='04'
				    <%
				        if("04".equals(iRequestType)){
				            out.print(" selected ");
				        }
				    %>
				    >04->白名单类</option>
				</select>
			</span>&nbsp;
		</td>
    </tr>
     <%/*begin 点击下一步展示客户经理工号和姓名、集团类别 by diling@2012/5/14 */%>
     <input type='hidden' id='custManagerNoHiden' name='custManagerNoHiden'  value='' />
     <input type='hidden' id='custManagerNameHiden' name='custManagerNameHiden' value='' />
     <input type='hidden' id='unitTypeHiden' name='unitTypeHiden' value='' />
    <tr id="custManagerInfo" style="display:none">
        <td class='blue' nowrap>客户经理工号</td>
        <td>
            <input type='text' class="InputGrey" id='custManagerNo' name='custManagerNo' value='<%=iCustManagerNoHiden%>' readOnly/>
        </td>
        <td class='blue' nowrap>客户经理姓名</td>
        <td>
            <input type='text' class="InputGrey" id='custManagerName' name='custManagerName' value='<%=iCustManagerNameHiden%>' v_must='1' readOnly />
        </td>
    </tr>
    <tr id="unitTypeInfo" style="display:none">
        <td class='blue' nowrap>集团类别</td>
        <td colspan="3">
            <input type='text' class="InputGrey" id='unitType' name='unitType' value='<%=iUnitTypeHiden%>' readOnly/>
        </td>
    </tr>
    <%/*end by diling */%>
</table>
</div>

<div id="packInfo" name="packInfo" style="display:<%=packListShow%>">
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">套餐信息</div>
</div>
<table cellspacing=0>
    <tr>
        <td class='blue' nowrap width='18%'>附加套餐</td>
        <td width='32%'>
            <input name="addProductName" id="addProductName" type="text" v_must=1 v_maxlength=8 v_type="string" readonly>
            <input class="b_text" id="selectAdditive" name="selectAdditive" onClick="getAdditiveBill()" style="cursor:hand" type="button" value="选择" />
            <font class='orange'>*</font>
            <input name="addProductId" id="addProductId" type="hidden" />
        </td>
        	
        	<td class='blue' nowrap width='18%' id="td_addProductNameYH4" >&nbsp;</td>
        	<td class='blue' nowrap width='32%' id="td_addProductNameYH3"  >&nbsp;</td>
        	
        	
	        <td class='blue' nowrap width='18%' id="td_addProductNameYH1" style="display:none">优惠资费</td>
	        <td width='32%'   id="td_addProductNameYH2"  style="display:none">
	            <input name="addProductNameYH" id="addProductNameYH" type="text" v_must=1 v_maxlength=8 v_type="string" readonly>
	            <input class="b_text" v_result="" id="selectAdditiveYH" name="selectAdditiveYH" disabled onClick="getAdditiveBillYH()" style="cursor:hand" type="button" value="选择" />
	            <font class='orange'>*</font>
	            <input name="addProductIdYH" id="addProductIdYH" type="hidden" />
	        </td>
        
    </tr>
</table>
</div>
</div>

<div id="payInfo" name="payInfo" style="display:<%=payListShow%>">
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">付费信息</div>
</div>
<TABLE cellSpacing=0>
    <TR>        
        <td class='blue' nowrap width='18%'>付费方式</td>
        <td width='32%'>
            <select name="pay_flag" id="pay_flag" onChange="changeOthers()">
                <%if("0".equals(payValue)){%>
                	<option value="0" selected>0--集团统付</option> 
            	<%}else if("1".equals(payValue)){%>
            	    <option value="0" selected>0--集团统付</option> 
                	<option value="1">1--个人付费</option>
            	<%}else if("2".equals(payValue)){%>
                	<option value="1" selected>1--个人付费</option>
            	<%}else if("3".equals(payValue)){%>
            	    <option value="0">0--集团统付</option> 
                	<option value="1" selected>1--个人付费</option>
            	<%}else{%>
                	<option value="0">0--集团统付</option> 
                	<option value="1">1--个人付费</option>
            	<%}%>
            </select>
            <font class='orange'>*</font>
        </td>
        
        <td class='blue' nowrap width='18%'>计费时间</TD>
        <TD>
            <input name="billTime" id="billTime" class="InputGrey" type="text" readOnly v_must=1 v_maxlength=8 v_type="string" value="<%=dateStr%>" maxlength=8>
        </TD>
    </tr>
    <%if("CR".equals(iSmCode)){%>
        <tr id="packInfoCR" name="packInfoCR" style="display:<%=packListShowCR%>">
        <td class='blue' nowrap width='18%'>附加套餐</td>
        <td colspan='3'>
            <input name="addProductNameCR" id="addProductNameCR" type="text" v_must=1 v_maxlength=8 v_type="string" readonly>
            <input class="b_text" id="selectAdditiveCR" name="selectAdditiveCR" onClick="getAdditiveBill()" style="cursor:hand" type="button" value="选择" />
            <font class='orange'>*</font>
            <input name="addProductIdCR" id="addProductIdCR" type="hidden" />
        </td>
    </tr>
    <tr>
        <td class="blue">产品周期</TD>
        <TD >
            <SELECT name="mebMonthFlag"  id="mebMonthFlag"  onChange="changeOthers()">
                <%if("N".equals(iMonthFlag)){%>
                    <option value="N" >包年</option>
                <%}else if("Y".equals(iMonthFlag)){%>
                    <option value="Y" >包月 </option>
                <%}else{%>
                    <option value="N" >包年</option>
                    <option value="Y" >包月 </option>
                <%}%>
            </SELECT>
            <font class="orange">*</font>
        </TD>
        
        <td class="blue">
            <span id=tbs2 style="display:none">包年到期转包月</span>&nbsp;
        </TD>								
        <TD >
            <span id=tbs3 style="display:none">																
                <SELECT name="matureFlag"  id="matureFlag" onChange="changeMatureFlag()" >
                    <option value="Y" >是 </option>
                    <option value="N" selected>否 </option>
                </SELECT>									         		      
                <input  type="text" id="matureProdName"  name="matureProdName" size="15" value="" readonly>
                <input name="matureProdCodeQuery" type="button" id="matureProdCodeQuery" disabled class="b_text" onClick="getmatureProdCodeQuery();" value="选择">
                <font class="orange">*</font>		 			   	  														 			
            </span>&nbsp;
        </TD>	
    </tr>
    <%}%>
</table>
</div>
</div>
<%
  /* diling update for 当品牌为“智慧城管”时，删除页面"品牌信息"展示区域 @2012/10/9
    if("ap".equals(iSmCode)||"ZH".equals(iSmCode)){
  */
%>
<%if("ap".equals(iSmCode)){%>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">品牌信息</div>
</div>
<table cellspacing=0>
    <tr>
        <td class='blue' nowrap width='18%'>APN号码</td>
        <td width='32%'>
            <select  size=1 name="apnNo" id="apnNo">
                <wtc:qoption name="sPubSelect" outnum="2">
                  <wtc:sql>select field_value,field_value from dgrpusermsgadd where id_no = '<%=id_no%>' and field_code ='10033'</wtc:sql>
                </wtc:qoption>
            </select>
        </td>
        <td class='blue' nowrap width='18%'>最大终端数量</td>
        <td>
            <input type='text' id='max_term_num' name='max_term_num' value='<%=iMaxTermNum%>' readOnly class='InputGrey' />
        </td>
    </tr>
    <tr>
        <td class='blue' nowrap width='18%'>已增加的终端数</td>
        <td>
            <input type='text' id='add_term_num' name='add_term_num' value='<%=iAddTermNum%>' readOnly class='InputGrey' />
        </td>
        <td class='blue' nowrap width='18%'>可用数量</td>
        <td>
            <input type='text' id='use_term_num' name='use_term_num' value='<%=iUseTermNum%>' readOnly class='InputGrey' />
        </td>
    </tr>
</table>
</div>
<%}%>
<%/*begin 点击下一步展示目前占比公式、上限占比公式、可添加智能网成员数 by diling@2012/6/12 */%>
<input type='hidden' id='preProportionHiden' name='preProportionHiden'  value='' />
<input type='hidden' id='highestLimitHiden' name='highestLimitHiden' value='' />
<input type='hidden' id='addVpMemberHiden' name='addVpMemberHiden' value='' />
<input type='hidden' id='regionNameHiden' name='regionNameHiden' value='' />
<input type='hidden' id='iRegionNameHiden' name='iRegionNameHiden' value='<%=iRegionNameHiden%>' />

<%/*end by diling@2012/6/12 */%>
<%if("vp".equals(iSmCode)){%>

<div id="Operation_Table">
<div class="title">
	<div id="title_zi">vp品牌信息</div>
</div>
<table cellspacing=0>
    <tr>
        <td class="blue" width='18%'>集团管理系统ID</td>
        <td>
            <input type='text' id='grp_unit_id' name='grp_unit_id' value='<%=iUnitId%>' class='InputGrey' readOnly />
        </td>
        <td class="blue" width='18%'>集团管理系统名称</td>
        <td>
            <input type='text' id='grp_unit_name' name='grp_unit_name' value='<%=iGrpName%>' class='InputGrey' readOnly />
        </td>
    </tr>
    <%/*begin 点击下一步展示目前占比、上限占比、可添加智能网成员数 by diling@2012/6/12 */%>
    <tr id="proportionInfo" >
        <td class='blue' nowrap>目前占比</td>
        <td>
            <input type='text' class="InputGrey" id='preProportion' name='preProportion' value='<%=iPreProportionHiden%>%' readOnly/>
        </td>
        <td class='blue' nowrap>上限占比</td>
        <td>
            <input type='text' class="InputGrey" id='highestLimit' name='highestLimit' value='<%=iHighestLimitHiden%>%' v_must='1' readOnly />
        </td>
    </tr>
    <tr id="addVpMemberInfo" >
        <td class='blue' nowrap>可添加智能网成员数</td>
        <td colspan="3">
            <input type='text' class="InputGrey" id='addVpMember' name='addVpMember' value='<%=iAddVpMemberHiden%>' readOnly/>
        </td>
    </tr>
    <%/*end by diling */%>
</table>
</div>
<%}%>

<%if("np".equals(iSmCode)){%>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">np品牌信息</div>
</div>
<table cellspacing=0>
    <TR id="line_0"> 		
        <TD class="blue" width='18%'>统付标志</TD>
        <TD  colspan=3>	              	
            <select name="allPayFlag" id="allPayFlag" onchange="changePayFlag()">	 
                <option value="1">统付</option>
                <option value="0">按账目项付费</option>
            </select>
            &nbsp;<font class="orange">*</font>
        </TD>
    </TR> 
    <TR id="line_1"> 		
        <TD class="blue">全额标志</TD>
        <TD colspan=3>	              	
            <select name="allFlag" id="allFlag" onchange="changeFlag()">
                <option value="0">定额交费</option>
                <option value="1">全额交费</option>
            </select>
            &nbsp;<font class="orange">*</font>
        </TD>
    </TR> 
    <TR id="line_111">    	              
        <TD class="blue">定额金额</TD>
        <TD colspan=3>
            <input type="text"  v_type="money"  v_must="1" v_minlength="1" v_maxlength="14" id="cycleMoney"  name="cycleMoney" maxlength="14" onBlur="if(this.value!=''){forMoney(this)}" >&nbsp;<font class="orange">*</font>
        </TD>
    </TR>
    
    <TR id="line_2"> 
        <TD class="blue" width='18%'>开始日期</TD>
        <TD height = 20 width='32%'>
            <input type="text"  name="beginDate" id="beginDate" maxlength="8" value="<%=dateStr%>" v_type="date"  v_must="1" v_format="yyyyMMdd" onBlur="if(this.value!='' && !forDate(this)){return false;}" style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)'>
            &nbsp;(格式:yyyymmdd)&nbsp;<font class="orange">*</font>            	
        </TD> 			
        <TD class="blue" width='18%'>结束日期</TD>
        <TD height = 20 width='32%'>
            <input type="text" name="endDate" id="endDate" maxlength="8" value="<%=endDate%>" v_type="date"  v_must="1"  v_format="yyyyMMdd" onBlur="if(this.value!='' && !forDate(this)){return false;}" style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)'>
            &nbsp;(格式:yyyymmdd)&nbsp;<font class="orange">*</font>  
        </TD> 		            	              
    </TR>
</table>
</div>
<%}%>

<%if("2".equals(nextFlag)){%>

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
		int iField=0;
		while(iField<fieldCount)
		{
			fieldCodes[iField]=resultList[iField][0];
			fieldNames[iField]=resultList[iField][1];
			fieldPurposes[iField]=resultList[iField][2];
			fieldValues[iField]=resultList[iField][10];
			dataTypes[iField]=resultList[iField][3];
			fieldLengths[iField]=resultList[iField][4];
			fieldGroupNo[iField]=resultList[iField][5];
			fieldGroupName[iField]=resultList[iField][6];
			fieldMaxRows[iField]=resultList[iField][7];
			fieldMinRows[iField]=resultList[iField][8];
			fieldCtrlInfos[iField]=resultList[iField][9];
			iField++;
		}
		if(fieldCount>0){
		%>
	<%@ include file="fpubDynaFields.jsp"%>
	<%}%>
<div id="Operation_Table">
<%
System.out.println(" zhouby  iSmCode ++ " + iSmCode);
System.out.println(" zhouby  busiFlag ++ " + busiFlag);

if("vp".equals(iSmCode)){%><!--wanghfa修改判断语句 2010-12-2 14:51 关于移动总计业务接入BOSS系统需求-->
<div class="title">
	<div id="title_zi">VPMN号码输入</div>
</div>
<table  cellspacing="0">
    <tr>
        <td class='blue' nowrap width='18%'>号码输入方式</td>
        <td width='32%'>
            <input type='radio' id='vpmn_input_type' name='vpmn_input_type' onClick='chkVpmnMulti()' value='vpmnMulti' checked/>号码输入
            <input type='radio' id='vpmn_input_type' name='vpmn_input_type' onClick='chkVpmnFile()' value='vpmnFile' />文件录入
        </td>
    <td class="blue"  width='18%'>号码运营商</td>
    <td class="formTd" colspan='3'>
        <select name=phone_type id=phone_type> 
            <option value="0">移动</option>	
            <option value="1">铁通</option>	
            <!--
            <option value="2">联通</option>
            <option value="3">网通</option>	
            <option value="4">电信</option>
            -->
        </select>	
        <font class="orange">*</font>
    </td>    
    </tr>
</table>
<span id="vpmnMulti" name="vpmnMulti">
<table  cellspacing="0">
    <tr id="SHOWADD1" >
        <td  class="blue" width='18%'>短号</td>
        <td  width='32%'>
            <input name="PHONENO" type="text"  id="PHONENO" maxlength="8" style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_must=1 v_type=0_9 v_minlength=3 v_maxlength=8  onblur="checkElement(this)" > 
            <font class="orange">*</font>
        </td>
        <td  class="blue"  width='18%'>真实号码</td>
        <td >
            <input name="ISDNNO" type="text"  id="ISDNNO" maxlength='12' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_must=1 v_type=0_9 v_minlength=1 v_maxlength=12  onblur="checkElement(this)">
            <font class="orange">*</font>		
        </td>
    </tr>
    <tr id="UserId">
        <td  class="blue">用户姓名</td>
        <td>
            <input name="USERNAME" type="text"  id="USERNAME" maxlength="18">
        </td>
        <td  class="blue">证件号码</td>
        <td>
            <input name="IDCARD" type="text"  id="IDCARD" maxlength="36">
        </td>
    </tr>
    <tr>
        <td class="blue">描述信息对应关系</td>
        <td>
            <input name="PCOMMENT" type="text"  id="PCOMMENT" maxlength="36">
        </td>
        <td >
            <input name="addCondConfirm" type="button" class="b_text" id="addCondConfirm" value="增加" onClick="call_ISDNNOINFO();">
        </td>
        <td  class="blue">已增加记录数
            <input name="addRecordNum" type="text"  class="InputGrey" id="addRecordNum" value="" size=7 readonly>
        </td>
    </tr>	
</table>		
          
<table cellspacing="0" id="dyntb">	
    <tr>
        <th>删除操作</th>
        <th>短号</th>
        <th>真实号码</th>
        <th>用户姓名</th>
        <th>证件号码</th>
        <th>描述信息</th>
        <th>执行状态</th>
    </tr>
    <tr id="tr0" style="display:none">
        <td>
            <input type="checkBox" id="R0" value="">
        </td>
        <td>
            <input type="text" id="R1" value="">
        </td>
        <td>
            <input type="text" id="R2" value="">
        </td>
        <td>
            <input type="text" id="R3" value="">
        </td>
        <td>
            <input type="text" id="R4" value="">
        </td>
        <td>
            <input type="text" id="R5" value="">
        </td>
        <td>
            <input type="text" id="R6" value="">
        </td>
    </tr>
</table>
</span>
<span id="vpmnFile" name="vpmnFile" style="display:none">
<table cellspacing=0>
    <TR>
        <TD align="left" class=blue width=18%>录入文件</TD>	   
        <TD colspan='3'> 
            <input type="file" name="vpmnPosFile" id="vpmnPosFile" class="button" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' />
        </TD>
    </TR>
    <tr>
        <td colspan="6"> 
            &nbsp;&nbsp;文件格式说明<br>
            &nbsp;&nbsp; 上传文件文本格式为，示例如下：<br>
            <font class='orange'>&nbsp;&nbsp; 6位短号码 11位真实号码 附加信息</font>
            <br>
            &nbsp;&nbsp; 
            <b>
            <br>&nbsp;&nbsp; 注：格式中的每一项均不允许存在空格,且每一项必须以" "（空格）为间隔符。每次最多50个。
            </b> 
        </td>
    </tr>
</table>
</span>
<%} else if ("j1".equals(iSmCode)) {%>
<!--wanghfa添加 2010-12-2 14:51 关于移动总计业务接入BOSS系统需求 start-->
<div class="title">
	<div id="title_zi">分机号码输入</div>
</div>
<table  cellspacing="0">
    <tr>
        <td class='blue' nowrap width='18%'>号码输入方式</td>
        <td width='32%'>
            <input type='radio' id='j1_input_type' name='j1_input_type' onClick='chkMulti()' value='j1Multi' checked/>号码输入
            <input type='radio' id='j1_input_type' name='j1_input_type' onClick='chkFile()' value='j1File' />文件录入
        </td>
	    <td class="blue"  width='18%'>号码运营商</td>
	    <td colspan='3'>
	        <select name="j1Provider" id="j1Provider"> 
	            <option value="0">移动</option>	
	            <option value="1">其他</option>	
	        </select>
	        <font class="orange">*</font>
	    </td>
    </tr>
</table>
<span id="multi" name="multi">
<table  cellspacing="0">
    <tr>
        <td  class="blue" width='18%'>分机号码</td>
        <td  width='32%'>
            <input name="j1No" type="text"  id="j1No" maxlength="6" style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_must=1 v_type=0_9 v_minlength=4 v_maxlength=6  onblur="checkElement(this)" > 
            <font class="orange">*</font>
        </td>
        <td class="blue"  width='18%'>电话号码</td>
        <td >
            <input name="j1PhoneNo" type="text" id="j1PhoneNo" maxlength='12' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_must=1 v_type=0_9 v_minlength=1 v_maxlength=12 onblur="checkElement(this)">
            <font class="orange">*</font>		
        </td>
    </tr>
    <tr>
        <td  class="blue">成员姓名</td>
        <td>
            <input name="j1UserName" type="text" v_must=1 id="j1UserName" maxlength="18">
        </td>
        <td  class="blue">成员姓名拼音首字母</td>
        <td>
            <input name="j1ShortName" type="text" v_must=1 id="j1ShortName" maxlength="36">
        </td>
    </tr>
    <tr>
        <td >
            <input name="addCondConfirm" type="button" class="b_text" id="addCondConfirm" value="增加" onClick="j1AddPhoneNo();">
        </td>
        <td class="blue" colspan="3">已增加记录数
            <input name="addRecordNum" type="text"  class="InputGrey" id="addRecordNum" value="" size=7 readonly>
        </td>
    </tr>	
</table>		
          
<table cellspacing="0" id="dyntb">	
    <tr>
        <th>删除操作</th>
        <th>分机号码</th>
        <th>电话号码</th>
        <th>成员姓名</th>
        <th>成员姓名拼音首字母</th>
    </tr>
    <tr id="j1Tr0" style="display:none">
        <td>
            <input type="checkBox" id="R0" value="">
        </td>
        <td>
            <input type="text" id="R1" value="">
        </td>
        <td>
            <input type="text" id="R2" value="">
        </td>
        <td>
            <input type="text" id="R3" value="">
        </td>
        <td>
            <input type="text" id="R5" value="">
        </td>
    </tr>
</table>
</span>
<span id="file" name="file" style="display:none">
<table cellspacing=0>
    <TR>
        <TD align="left" class=blue width=18%>录入文件</TD>	   
        <TD colspan='3'> 
            <input type="file" name="j1PosFile" id="j1PosFile" class="button" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' />
        </TD>
    </TR>
    <tr>
        <td colspan="6"> 
            &nbsp;&nbsp;文件格式说明<br>
            &nbsp;&nbsp; 上传文件文本格式为，示例如下：<br>
            <font class='orange'>&nbsp;&nbsp; 4-6位短号码 11位真实号码 成员姓名 成员姓名拼音首字母</font>
            <br>
            &nbsp;&nbsp; 
            <b>
            <br>&nbsp;&nbsp; 注：格式中的每一项均不允许存在空格,且每一项必须以" "（空格）为间隔符。每次最多50个。
            </b> 
        </td>
    </tr>
</table>
</span>
<%} else if ("ap".equals(iSmCode)||"ZH".equals(iSmCode)) {%><!--wanghfa添加 2011/9/5 10:06 关于BOSS系统APN数据卡绑定静态IP地址绑定添加批量导入功能-->
<div class="title">
	<div id="title_zi">号码输入</div>
</div>
<table  cellspacing="0">
	<tr>
		<td class='blue' nowrap width='18%'>
			号码输入方式
		</td>
		<td>
			<input type='radio' id='input_type' name='input_type' onClick='chkSingle()' value='single' checked />单个输入
			<span style="display:none"><input type='radio' id='input_type' name='input_type' onClick='chkMulti()' value='multi' />批量输入</span>
			<input type='radio' id='input_type' name='input_type' onClick='chkFile()' value='file' />文件录入
		</td>
	</tr>
</table>
<span id="single" name="single">
<table cellspacing="0">
	<tr>
		<td class='blue' nowrap width='18%'></td>
		<td colspan='3'>
			<input type='text' id='single_phoneno' name='single_phoneno' value="" onChange="document.all.sure.disabled=true" maxlength='11' onblur='if(this.value!=""){if(!forMobil(this)){return false;}}' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' />
			<input type='button' id='checkPhoneNo' name='checkPhoneNo' value="校验" onClick='phoneNoCheck()' class='b_text' />
			<font class='orange'>*</font>
		</td>
	</tr>
</table>

</span>
<span id="file" name="file" style="display:none">
<table cellspacing=0>
	<TR>
		<TD align="left" class=blue width=18%>录入文件</TD>	   
		<TD colspan='3'> 
			<input type="file" name="PosFile" id="PosFile" class="button" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' />
		</TD>
	</TR>
	<tr>
		<td colspan="6">
			&nbsp;&nbsp;文件格式说明<br>
			&nbsp;&nbsp; 上传文件文本格式为，示例如下：<br>
			<font class='orange'>
			  <%if ("ZH".equals(iSmCode)) {/*diling update for 当集团“智慧城管”集团产品品牌时，“号码输入”为文件录入的，修改上传文件文本格式修改为11位真实号码 @2012/10/9 */%>
			    &nbsp;&nbsp;11位真实号码
			  <%}else{%>
				  &nbsp;&nbsp;11位真实号码 IP地址
				<%}%>
			</font>
			<br>
			&nbsp;&nbsp;
			<b>
			<br>&nbsp;&nbsp; 注：格式中的每一项均不允许存在空格,且每一项必须以" "（空格）为间隔符。每次最多50个。
			</b>
		</td>
	</tr>
</table>
</span>
<%}else if ("RH".equals(iSmCode) && "186".equals(busiFlag)){//186是集团固话 187是一号通（融合通信）
%>
<div class="title">
	<div id="title_zi">号码输入</div>
</div>
<table cellspacing=0>
    <tr>
        <td class='blue' nowrap width='18%'>号码输入方式</td>
        <td colspan='3'>
            <label><input type='radio' name="RH_input_radio" value="no" targetId="addSingleRH" adverseId="addMultiRH"/>号码输入</label>
            <label><input type='radio' name="RH_input_radio" value="file" targetId="addMultiRH" adverseId="addSingleRH"/>文件录入</label>
        </td>
    </tr>
    
    <tbody class="addSingleRH">
        <tr>
            <td class='blue' nowrap width='18%'>短号</td>
            <td>
                <input type='text' value="" name="short_no" id="short_no" v_must=1 maxlength="8"  v_type=0_9 />
                <font class='orange'>*</font>
            </td>
            
            <td class='blue' nowrap width='18%'>成员用户号码</td>
            <td>
                <input type='text' value="" name="real_no" id="real_no" v_must=1 v_type=0_9 v_minlength=1 v_maxlength=12 maxlength='11' />
                <font class='orange'>*</font>
            </td>
        </tr>
        
        <tr>
            <td class='blue' nowrap width='18%'>Portal登录名</td>
            <td>
                <input type='text' value="" id="portalName" name="portalName" class="InputGrey" readonly="readonly"/>
            </td>
            
            <td class='blue' nowrap width='18%'>Portal登录密码</td>
            <td>
                <input type='text' value="000000" name="portalPassword" id="portalPassword" class="InputGrey" readonly="readonly"/>
            </td>
        </tr>
        <%
	    	  /* 
	      	 * begin 关于融合通信新增移动固话业务的需求@2014/7/14  
	      	 */
        %>
        <tr id="RH_openSettledPhone_tr" style="display:none">
            <td class='blue' nowrap width='18%'>是否开通移动固话</td>
            <td>
	            <select name="isOpenSettledPhone" id="isOpenSettledPhone"> 
		            <option value="0">否</option>	
		            <option value="1">是</option>	
	        		</select>
            </td>
            
            <td class='blue' nowrap width='18%'>固话对应的手机号码</td>
            <td>
                <input type='text' value="" name="settledPhone" id="settledPhone" />
            </td>
        </tr>
        <%
	    	  /* 
	      	 * end 关于融合通信新增移动固话业务的需求@2014/7/14  
	      	 */
        %>
                <%
	    	  /* 
	      	 * begin 关于融合通信聚类和家庭客户营帐优化需求的函@2014/12/21  
	      	 */
        %>
        <tr id="RH_contactInfo_tr" >
            <td class='blue' nowrap width='18%'>联系人姓名</td>
            <td>
	            <input type='text' name="contactName" id="contactName" value="" maxlength="100" />
            </td>
            
            <td class='blue' nowrap width='18%'>联系电话</td>
            <td>
            	<input type='text' name="contactPhone" id="contactPhone" value="" maxlength="15" />
            </td>
        </tr>
        <%
	    	  /* 
	      	 * end 关于融合通信新增移动固话业务的需求@2014/12/21 
	      	 */
        %>
        <tr>
            <td class='blue' nowrap width='18%'>操作</td>
            <td>
                <input class="b_text" type="button" id="addRealNo" value="增加"/>
                <input type='hidden' id='userTypeHidden' name='userTypeHidden' value='' />
                <input type='hidden' id='isOpenCountFlagHidden' name='isOpenCountFlagHidden' value='' />
            </td>
            
            <td class='blue' nowrap width='18%'>已增加记录数</td>
            <td id="showAddRowNum">0</td>
        </tr>
    </tbody>
    
    <tbody class="addMultiRH">
        <TR>
            <TD align="left" class=blue width=12%>录入文件</TD>
            <TD colspan="3"> 
                <input type="file" name="rhFile" class="button" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;'/>
            </TD>
        </tr>
        
        <tr>
            <td colspan="4"> 
                &nbsp;&nbsp;文件格式说明<br>
                &nbsp;&nbsp; 上传文件文本格式为，示例如下：<br>
                <font class='orange' id="RH_showExplain"></font>
                <br>
                &nbsp;&nbsp;
                <b>
                <br>&nbsp;&nbsp; 注：格式中的每一项均不允许存在空格,且每一项必须以"|"为间隔符。每次最多50个。
                </b> 
            </td>
        </tr>
    </tbody>
</table>
<table class="addSingleRH">
    <tbody id="rhListTarget">
      <tr id="rhListTargetTr" class="rhTitle">
        <th>操作</th>
        <th>短号</th>
        <th>成员用户号码</th>
        <th>Portal登录名</th>
        <th>Portal登录密码</th>
        <th>联系人姓名</th>
        <th>联系电话</th>
      </tr>
    </tbody>
</table>
<%    
} else {%><!--wanghfa修改判断语句 2010-12-2 14:51 关于移动总计业务接入BOSS系统需求-->
<div class="title" id="singleTitle">
	<div id="title_zi">号码输入</div>
</div>
<table cellspacing=0>
    <tr id="inputFlag" name="inputFlag" style='display:<%=phoneListShow%>'>
        <td class='blue' nowrap width='18%'>号码输入方式</td>
        <td colspan='3'>
            <span id='single_type' name='single_type'><input type='radio' id='input_type' name='input_type' onClick='chkSingle()' value='single' checked />单个输入</span>
            <input type='radio' id='input_type' name='input_type' onClick='chkMulti()' value='multi' />批量输入
            <input type='radio' id='input_type' name='input_type' onClick='chkFile()' value='file' />文件录入
        </td>
    </tr>
    <tbody id='single' name='single'>
    <tr>
        <td class='blue' nowrap width='18%' id="user_phone_no">成员用户号码</td>
        <td colspan='3'>
            <input type='text' id='single_phoneno' name='single_phoneno' value="" onChange="document.all.sure.disabled=true" maxlength='11' onblur='if(this.value!=""){if(!forMobil(this)){return false;}}' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' />
            <input type='button' id='checkPhoneNo' name='checkPhoneNo' value="校验" onClick='phoneNoCheck()' class='b_text' />
            <font class='orange'>*</font>
        </td>
    </tr>
    </tbody>
    <tbody id='multi' name='multi' style='display:none'>
    <tr>
        <TD class=blue>号码</TD>
        <TD>
            <textarea cols=30 rows=8 name="multi_phoneNo" id="multi_phoneNo" style="overflow:auto" /></textarea>
        </TD>
        <TD colspan='2'>
            注：批量增加号码时,请用"|"作为分隔符,并且最后一个号码也请用"|"作为结束.
            <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;每次最多50个,彩铃30个。
            <br>&nbsp;例如：
            <br>&nbsp;13900000001|
            <br>&nbsp;13900000002|
        </TD>
        </TR>
    </tbody>
    <tbody id='file' name='file' style='display:none'>
        <TR>
        <TD align="left" class=blue width=12%>录入文件</TD>	   
        <TD> 
            <input type="file" name="PosFile" id="PosFile" class="button" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' />
        </TD>
        <TD colspan="2"><font color='red'><%=fileExplain%></font>
        </TD>
    </tr>
    </tbody>
        <tbody id='expTime' name='expTime' style='display:none'>
        <td class='blue' nowrap>期望日期</td>
        <td colspan='3'>
            <input type='text' id='expect_time' name='expect_time' v_must="1" value="<%=dateStr%>" v_format = "yyyyMMdd" style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)'/>
            &nbsp;<font class="orange">*&nbsp;(格式:yyyymmdd)</font>
        </td>
    </tbody>
</table>
<%}%>

<div id="extPhoneDiv"  style="display:none">
	<div class="title">
		<div id="title_zi">分机号码输入</div>
	</div>
	<table  cellspacing="0">
	    <tr>
	        <td class='blue' nowrap width='18%'>号码输入方式</td>
	        <td width='32%'>
	            <input type='radio' id='ext_input_text' name='ext_input_type' value='extText' checked/>号码输入
	            <input type='radio' id='ext_input_file' name='ext_input_type' value='extFile' />文件录入
	        </td>
	        <td></td>
	        <td></td>
	    </tr>
	</table>
	<div id="extPhoneTextDiv">
		<table  cellspacing="0">
		    <tr>
		        <td class='blue' nowrap width='18%'>分机号码</td>
		        <td width='32%'>
		            <input type='text' id='ext_sub_number' name='ext_sub_number' 
		            	maxlength="8" value=''/>
		            <font class='orange'>*</font>
		        </td>
		        <td class='blue' nowrap width='18%'>手机号码</td>
		        <td width='32%'>
		            <input type='text' id='ext_sub_phone' name='ext_sub_phone' value=''
		            	maxlength="11" onkeyup="this.value=this.value.replace(/\D/g,'')" 
						onafterpaste="this.value=this.value.replace(/\D/g,'')"/>
		            <font class='orange'>*</font>
		        </td>
		    </tr>
		    <tr>
		        <td class='blue' nowrap width='18%'><input type="button" class="b_text" value="增加" id="addExtPhone"/></td>
		        <td colspan="3">
	        		已增加记录数
	        		<input type='text' id='ext_sub_recordCount' name='ext_sub_recordCount' class="InputGrey" readonly value='0'/>
		        </td>
		    </tr>
		</table>
		<table  cellspacing="0">
		    <thead>
		    	<th>删除操作</th>	
		    	<th>分机号码</th>	
		    	<th>电话号码</th>	
		    </thead>
		    <tbody id="extPhoneSubTbody">
		    	
		    </tbody>
		</table>
	</div>
	
	<div id="extPhoneFileDiv" style="display:none">
		<table  cellspacing="0">
		    <tbody>
		        <TR>
			        <TD align="left" class=blue width=12%>录入文件</TD>	   
			        <TD> 
			            <input type="file" name="extUploadFile" id="extUploadFile" class="button" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' />
			        </TD>
			        <TD colspan="2"></TD>
			    </tr>
			    <tr>
			        <td colspan="4"> 
			            &nbsp;&nbsp;文件格式说明<br>
			            &nbsp;&nbsp; 上传文件文本格式为，示例如下：<br>
			            <font class='orange'>&nbsp;&nbsp; 4-8位分机号 11位真实号码</font>
			            <br>
			            &nbsp;&nbsp; 
			            <b>
			            <br>&nbsp;&nbsp; 注：格式中的每一项均不允许存在空格,且每一项必须以" "（空格）为间隔符。每次最多50个。
			            </b> 
			        </td>
			    </tr>
		    </tbody>
		</table>
	</div>
	
	
	
</div>

<TABLE cellSpacing=0>
    <TR id="footer">        
        <TD align=center>
            <input class="b_foot" name="previous" id="previous" type=button value="上一步" onclick="previouStep()" style='display:none'/>
            <input class="b_foot" name="sure" id="sure" type=button value="确认" onclick="
            if(document.all.inputType.value == 'file' || document.all.vpmnInputType.value == 'vpmnFile' ||('<%=iSmCode%>'== 'RH' && '<%=busiFlag%>' == '186')){
                doUpload();
            }else{
                refMain();
            }
            " 
            <%
            if(!"vp".equals(iSmCode)){
                out.print(" disabled='true' ");
            }
            %>/>
            <input class="b_foot" name='clear2' id='clear2' type='button' value="清除" onClick="resetJsp()" />
            <input class="b_foot" name="close2"  onClick="removeCurrentTab()" type=button value="关闭" />
        </TD>
    </TR>
</table>
<%}%>
<%if("1".equals(nextFlag)){%>
<div id="Operation_Table">
<TABLE cellSpacing=0>
    <TR id="footer">        
        <TD align=center>
            <input name="next" id="next" class="b_foot"  type=button value="下一步" onclick="nextStep()"  />
            <input class="b_foot" name='clear1' id='clear1' type='button' value="清除" onClick="resetJsp()" />
            <input class="b_foot" name="close1"  onClick="removeCurrentTab()" type=button value="关闭" />
        </TD>
    </TR>
</table>
<%}%>
<input type='hidden' id='iRegionCode' name='iRegionCode' value='<%=regionCode%>' />
<input type='hidden' id='op_code' name='op_code' value='<%=opCode%>' />
<input type='hidden' id='work_no' name='work_no' value='<%=workNo%>' />
<input type='hidden' id='id_no' name='id_no' value='<%=id_no%>' />
<input type='hidden' id='org_code' name='org_code' value='<%=orgCode%>' />
<input name="ZHWW" type="hidden" id="ZHWW" value="0">
<input type='hidden' id='month_flag' name='month_flag' />
<input type="hidden" name="matureProdCode" id="matureProdCode" value="">
<input type='hidden' id='sysAccept' name='sysAccept' value='<%=sysAccept%>' />
<input type='hidden' id='op_note' name='op_note' value="操作员<%=workNo%>进行集团成员增加操作！"/>
<input type='hidden' id='user_type' name='user_type' value='<%=iUserType%>' />
<input type="hidden" name="nameList">
<input type="hidden" name="nameGroupList">	
<input type="hidden" name="fieldNamesList">
<input type="hidden" name="tmpR1" id="tmpR1" value="">
<input type="hidden" name="tmpR2" id="tmpR2" value="">
<input type="hidden" name="tmpR3" id="tmpR3" value="">
<input type="hidden" name="tmpR4" id="tmpR4" value="">
<input type="hidden" name="tmpR5" id="tmpR5" value="">
<input type="hidden" name="tmpR6" id="tmpR6" value="">
<input type="hidden" name="tmpR7" id="tmpR7" value="">
<input type="hidden" name="tmpR8" id="tmpR8" value="">
<input type='hidden' id='grp_name' name='grp_name' value='<%=iGrpName%>' />
<input type='hidden' id='iBizCode' name='iBizCode' value='<%=iBizCode%>' />
<input type='hidden' id='add_mode_flag' name='add_mode_flag' value='<%=addModeFlag%>' />
<input type='hidden' id='pay_list_show' name='pay_list_show' value='<%=payListShow%>' />
<input type='hidden' id='inputType' name='inputType' value='single' />
<input type='hidden' id='vpmnInputType' name='vpmnInputType' value='vpmnMulti' />
<input type='hidden' id='inputFile' name='inputFile' value='' />
<input type='hidden' id='request_type_flag' name='request_type_flag' value='' />
<input type='hidden' id='max_term_num_tmp' name='max_term_num_tmp' value='' />
<input type='hidden' id='add_term_num_tmp' name='add_term_num_tmp' value='' />
<input type='hidden' id='use_term_num_tmp' name='use_term_num_tmp' value='' />
<input type='hidden' id='attr' name='attr' value='' /><!--wanglma 20110428 存放默认的套餐名称 -->
<input type='hidden' id='phonNosLength' name='phonNosLength' value='' /><!--wanglma 20110428 存放提交号码的个数 -->
<input type='hidden' id='mobile_phone' name='mobile_phone' value='' /><!--wuxy 20100331 -->
<input type='hidden' id='phoneFlag' name='phoneFlag' value='' />
<input type='hidden' id='limitcount' name='limitcount'  value='<%=limitcount%>' /> <!--wangzn 091205-->
<input type="hidden" value="<%=uniqueStatus%>" name="uniqueStatus" id="uniqueStatus" /><!-- liujian 2013-1-28 17:15:45-->
<input type="hidden" value="" name="extInputType" id="extInputType" /><!-- liujian 2013-1-28 17:15:45-->
<input type="hidden" value="" name="EncryptPwd" id="EncryptPwd" /><!-- liujian 2013-1-28 17:15:45-->
<input type="hidden" value="<%=busiFlag%>" name="busiFlag" id="busiFlag" /><!-- zhouby add -->
<input type="hidden" name="phoneHeader" id="phoneHeader" value=""/>
            
<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>
<jsp:include page="/npage/common/pwd_comm.jsp"/>
<!-- 2014/12/26 14:47:50 gaopeng 关于完善金库模式管理和敏感信息模糊化的需求 引入公共页面 openType用来区分普通金库校验和定制类公共校验-->
<jsp:include page="/npage/public/intf4A/common/intfCommon4A.jsp">
	<jsp:param name="openType" value="SPECIAL"  />
</jsp:include>
<%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>

<script type="text/javascript">
    /*提交到f7983_upload.jsp页面，用于上传附件，上传成功后调用refMain()方法。*/
    function doUpload()
	{
        <% if(resultList.length>0){ %>
        if(!checkDynaFieldValues(false)){
			return false;
		}
		<%}%>
        var ind1Str ="";
        var ind2Str ="";
        var ind3Str ="";
        var ind4Str ="";
        var ind5Str ="";
        /* vpmn时,拼写数据 */
        if($("#sm_code").val() == "vp"){
			var v_addVpMember = document.getElementById("addVpMember").value; //可添加vpmn成员数
			var v_iRegionNameHiden = $("#iRegionNameHiden").val();
			if ( ( Number(v_addVpMember) )<=0 )
			{
				rdShowMessageDialog(""+v_iRegionNameHiden
					+"公司的智能网总容量已达到上限，不能再新增成员！");
				return false;
			}
        
            if($("#vpmnInputType").val() == "vpmnMulti"){         //vpmn号码录入
                if( dyntb.rows.length == 2){//缓冲区没有数据
                    rdShowMessageDialog("没有指定成员号码，请增加数据!",0);
                    return false;
                }else{
                    for(var a=1; a<document.all.R0.length ;a++)//删除从tr1开始，为第三行
                    {
                        ind1Str =ind1Str +document.all.R1[a].value+"|";
                        ind2Str =ind2Str +document.all.R2[a].value+"|";
                        ind3Str =ind3Str +document.all.R3[a].value+"|";
                        ind4Str =ind4Str +document.all.R4[a].value+"|";
                        ind5Str =ind5Str +document.all.R5[a].value+"|";
                    }
                }
                
                //2.对form的隐含字段赋值
                
                document.all.tmpR1.value = ind1Str;
                document.all.tmpR2.value = ind2Str;
                document.all.tmpR3.value = ind3Str;
                document.all.tmpR4.value = ind4Str;
                document.all.tmpR5.value = ind5Str;
            }else{  //vpmn文件录入
                if($("#vpmnPosFile").val() == ""){    //文件录入
                    rdShowMessageDialog("请选择文件！",0);
                    $("#vpmnPosFile").focus();
                    return false;
                }
            }
            
            //wangzn 091205 B
           
            if(document.all.limitcount.value=="1"&&document.all.F80003.value=="0")
					{
							rdShowMessageDialog("该集团主资费不可使用，请为集团成员选择个人套餐资费!");
			        return false;
					}
					if(document.all.limitcount.value=="1"&&document.all.F80004.value=="0")
					{
							rdShowMessageDialog("该集团主资费不可使用，请为集团成员选择个人套餐资费!");
			        return false;
					}
            //wangzn 091205 E
            
        }else if($("#sm_code").val() == "np"){
            if($("#allPayFlag").val() == "1"){
                if($("#allFlag").val() == "0"){
                    if($("#cycleMoney").val() == ""){
                        rdShowMessageDialog("请您输入定额金额！",0);
                        $("#cycleMoney").focus();
                        return false;
                    }else{
                        if(!forMoney(document.all.cycleMoney)){
                            $("#cycleMoney").val("");
                            $("#cycleMoney").focus();
                            return false;
                       }
                    }
                }
                if($("#beginDate").val() == ""){
                    rdShowMessageDialog("请您输入开始时间！",0);
                    $("#beginDate").focus();
                    return false;
                }else{
                    if(!forDate(document.all.beginDate)){
                        $("#beginDate").val("");
                        $("#beginDate").focus();
                        return false;
                    }
                }
                
                if($("#endDate").val() == ""){
                    rdShowMessageDialog("请您输入结束时间！",0); 
                    $("#endDate").focus();
                    return false;
                }else{
                    if(!forDate(document.all.endDate)){
                        $("#endDate").val("");
                        $("#endDate").focus();
                        return false;
                    }
                }
                
                if($("#beginDate").val()<"<%=dateStr%>"){
                    rdShowMessageDialog("开始时间应不小于当前日期！",0);
                    $("#beginDate").val("");
                    $("#beginDate").focus();
                    return false;
                }
                
                if($("#beginDate").val() > $("#endDate").val()){
                    rdShowMessageDialog("结束时间应不小于开始日期！",0);
                    $("#endDate").val("");
                    $("#endDate").focus();
                    return false;
                }
            }
            
            if(document.all.input_type[0].checked){         //单个录入
                if($("#single_phoneno").val() == ""){
                    rdShowMessageDialog("成员用户手机号码不能为空！",0);
                    $("#single_phoneno").focus();
                    return false;
                }else{
                    if(!forMobil(document.all.single_phoneno)){
                        return false;
                    }
                }
            }else if(document.all.input_type[1].checked){    //批量录入
                if($("#multi_phoneNo").val() == ""){
                    rdShowMessageDialog("号码不能为空！",0);
                    $("#multi_phoneNo").focus();
                    return false;
                } else {	//2011/7/7 wanghfa添加 解决入参空格导致服务down掉
                	while ($("#multi_phoneNo").val().indexOf(" ") != -1) {
	                	$("#multi_phoneNo").val($("#multi_phoneNo").val().replace(" ", ""));
                	}
                }
            }else{
                if($("#PosFile").val() == ""){    //文件录入
                    rdShowMessageDialog("请选择文件！",0);
                    $("#PosFile").focus();
                    return false;
                }
            }
            
        } else if($("#sm_code").val() == "j1"){	//wanghfa添加此判断体 2010-12-6 10:40 移动总机j1接入BOSS系统
        	if ($("#inputType").val() == "file") {  //j1文件录入
                if($("#j1PosFile").val() == ""){    //文件录入
                    rdShowMessageDialog("请选择文件！",0);
                    $("#j1PosFile").focus();
                    return false;
                }
            }
        } else if("hj" == '<%=iSmCode%>' && "214" == $('#uniqueStatus').val()) {
			if($("#extUploadFile").val() == ""){    //文件录入
	            rdShowMessageDialog("请选择文件！",0);
	            $("#extUploadFile").focus();
	            return false;
	        }else{
	            var uploadfile = document.all.extUploadFile.value;
	        	var ext = "*.txt";
	        	var file_name = uploadfile.substr(uploadfile.lastIndexOf(".")); 
	        	if(ext.indexOf("*"+file_name)==-1){   
	                rdShowMessageDialog("程序只支持txt格式文件(*.txt)！",0);  
	                return false;  
	            }
	        }
	    }else if (document.getElementById("sm_code").value == "RH" && '<%=busiFlag%>' == '186'){
	        
	    } else{
            if(document.all.input_type[0].checked){         //单个录入
                if($("#single_phoneno").val() == ""){
                    rdShowMessageDialog("成员用户手机号码不能为空！",0);
                    $("#single_phoneno").focus();
                    return false;
                }else{
                    if(!forMobil(document.all.single_phoneno)){
                        return false;
                    }
                }
            }else if(document.all.input_type[1].checked){    //批量录入
                if($("#multi_phoneNo").val() == ""){
                    rdShowMessageDialog("号码不能为空！",0);
                    $("#multi_phoneNo").focus();
                    return false;
                } else {	//2011/7/7 wanghfa添加 解决入参空格导致服务down掉
                	while ($("#multi_phoneNo").val().indexOf(" ") != -1) {
	                	$("#multi_phoneNo").val($("#multi_phoneNo").val().replace(" ", ""));
                	}
                }
            }else{
                if($("#PosFile").val() == ""){    //文件录入
                    rdShowMessageDialog("请选择文件！",0);
                    $("#PosFile").focus();
                    return false;
                }else{
                    var uploadfile = document.all.PosFile.value;
                	var ext = "*.txt";
                	var file_name = uploadfile.substr(uploadfile.lastIndexOf(".")); 
                	if(ext.indexOf("*"+file_name)==-1){   
                        rdShowMessageDialog("程序只支持txt格式文件(*.txt)！",0);  
                        return;  
                    }
                }
            }
            
            if($("#sm_code").val() == "AD" || $("#sm_code").val() == "ML" || $("#sm_code").val() == "MA"){
                if($("#request_type").val() == '03' || $("#request_type").val() == '04'){
                    if($("#expect_time").val() == ""){
                        rdShowMessageDialog("请输入期望日期！",0);
                        $("#expect_time").select();
                        $("#expect_time").focus();
                        return false;
                    }else{
						if(validDate(document.all.expect_time)==false) return false;
                    }
                }
            }
        }
        
        if($("#sm_code").val() == "ap" && document.all.input_type[0].checked){
            if(document.all.F81008 != null && document.all.F81008.value == "0"){
                if($("#F81002").val() == ""){
                    rdShowMessageDialog("请输入IP地址！",0);
                    $("#F81002").focus();
                    return false;
                }else{
                    if(!forIp(document.all.F81002)){
                        return false;
                    }
                }
            }
        }
        
        <%if("".equals(packFlag)){%>
            if($("#sm_code").val() != "CR"){
                if($("#addProductId").val() == ""){
                    rdShowMessageDialog("请您选择附加资费！",0);
                    $("#selectAdditive").focus();
                    return false;
                }
            }else{
                if($("#addProductIdCR").val() == ""){
                    rdShowMessageDialog("请您选择附加资费！",0);
                    $("#selectAdditiveCR").focus();
                    return false;
                }
            }
        <%}%>
        if($("#pay_flag").val()=="1" && $("#mebMonthFlag").val()=="N" && $("#matureFlag").val()=="Y" && $("#matureProdCode").val()==""){
            rdShowMessageDialog("请您选择包年转包月产品！",0);
            $("#matureProdCodeQuery").focus();
            return false;
        }
        
	    document.frm.target="hidden_frame";
	    document.frm.encoding="multipart/form-data";
	    document.frm.action="f7983_upload.jsp";
	    document.frm.method="post";
	    document.frm.submit();
	    $("#sure").attr("disabled",true);
	    //loading();
	}
	
</script>



<script type="text/javascript">
	/*liujian 2013-1-28 15:39:28 关于开发租赁式呼叫中心BOSS系统需求的函  呼叫中心--虚拟呼叫中心 显示分机号码输入*/
	$(function() {
		if("hj" == '<%=iSmCode%>' && "214" == $('#uniqueStatus').val()) {
			overSelect($('#F81018'));
			$('#single').css('display','none');
			$('#singleTitle').css('display','none');
			$('#extPhoneDiv').removeAttr('style');	
			$("#inputType").val("multi");
			$("#extInputType").val("multi");
			$('#addExtPhone').click(function() {
				var number = $('#ext_sub_number').val();	
				var phone = $('#ext_sub_phone').val();	
				if(!number|| $.trim(number).length < 4) {
					 rdShowMessageDialog("分机号码长度只能在4到8位之间,请输入正确的分机号码!");
					 return false;
				}
				if(!phone || $.trim(phone).length == 0 || $.trim(phone).length > 11) {
					 rdShowMessageDialog("手机号码必填且最多11位，请输入正确的手机号码");
					 return false;
				}
				var hasExist = false;
				//分机号码和手机号码是1：1的，都不允许重复
				$('#extPhoneSubTbody').find('tr').each(function() {
					var $this = $(this);
					if($this.find('td:eq(1)').text() == number)	{
						rdShowMessageDialog("分机号码已经存在，必须保证分机号码和手机号码未被添加过！");
						hasExist = true;
						return false;
					}
					if($this.find('td:eq(2)').text() == phone)	{
						rdShowMessageDialog("手机号码已经存在，必须保证分机号码和手机号码未被添加过！");
						hasExist = true;
						return false;
					}
				});
				if(!hasExist) {
					var smg = new Array();
					smg.push('<tr>');
					smg.push('	<td><input type="checkbox" onclick="delExtRecord(this)" /></td>');
					smg.push('	<td>' + number + '</td>');
					smg.push('	<td>' + phone + '</td>');
					smg.push('</tr>');
					$('#extPhoneSubTbody').append(smg.join(''));
					setSureBtnDisabled(false);
					var count = $('#ext_sub_recordCount').val();
					if(count) {
						$('#ext_sub_recordCount').val(Number(count)	+ 1);
					}else {
						$('#ext_sub_recordCount').val(1);	
					}
					$('#ext_sub_number').val('');
					$('#ext_sub_phone').val('');
				}
			});
			$('#ext_input_text').click(function() {
				$('#extPhoneTextDiv').removeAttr('style');	
				$('#extPhoneFileDiv').attr('style','display:none');	
				$("#inputType").val("multi");
				$("#extInputType").val("multi");
				$('#extUploadFile').val("");
				//设置确认按钮不可点击
				setSureBtnDisabled(true);
			});
			$('#ext_input_file').click(function() {
				$('#extPhoneTextDiv').attr('style','display:none');	
				$('#extPhoneFileDiv').removeAttr('style');		
				$("#inputType").val("file");
				$("#extInputType").val("file");
				$('#ext_sub_number').val('');
				$('#ext_sub_phone').val('');
				$('#ext_sub_recordCount').val('0');
				$('#extPhoneSubTbody').empty();
				setSureBtnDisabled(false);
			});
		}
		
		//zhouby add for 关于优化融合通信相关产品营业和资费需求的函 2013-12-12
        $('select[name="F70019"]').change(function(){
            var targetValue = $(this).val();
            //$('#pay_flag').val(targetValue);
            
            $('#portalName,#short_no').val('');//将portalName和短号置空
            /* 
          	 * begin 关于融合通信新增移动固话业务的需求@2014/7/14  
          	 */
         	<%if("186".equals(busiFlag)){ //RH的集团固话186 %>
         			var th1 = "<th>操作</th><th>短号</th><th>成员用户号码</th><th>Portal登录名</th><th>Portal登录密码</th>";
         			var th2 = "<th>联系人姓名</th><th>联系电话</th><th>是否开通移动固话</th><th>固话对应的手机号码</th>";
         			if(typeof($('.futionRow').length) != "undefined"){
         				if (parseInt($('.futionRow').length)> 0 ){
	         				rdShowMessageDialog("请将已增加的内容删除，再修改用户类型！");
	         				$(this).val($("#userTypeHidden").val());
									return false;
	         			}else{
	         				$('#addProductId,#addProductName').val('');//将套餐置空
	         			}
         			}
         			// update 针对固话号码的成员，修改付费模式规则，提供统付和个付两种方式，默认统付。for 关于融合通信聚类和家庭客户营帐优化需求的函@2014/12/21 
         			$('#pay_flag').val("0");
         			
            	if(targetValue == "0"){//用户类型为固话用户
            		$("#isOpenSettledPhone").val("0");
	            	$("#RH_openSettledPhone_tr").css("display","");
	            	$("#RH_contactInfo_tr").css("display","");
	            	$("#RH_showExplain").html("<%=showExplain2%>");
	            	$("#rhListTargetTr").empty();
	            	$("#rhListTargetTr").append(th1+th2);
	            }else{
	            	$("#RH_openSettledPhone_tr").css("display","none");
	            	$("#RH_contactInfo_tr").css("display","none");
	            	$("#RH_showExplain").html("<%=showExplain%>");
            		$("#rhListTargetTr").empty();
            		$("#rhListTargetTr").append(th1);
	            }
	            $("#userTypeHidden").val(targetValue);
          <%}else{%>
          	$('#addProductId,#addProductName').val('');//将套餐置空
          <%}%>
            /* 
          	 * end 关于融合通信新增移动固话业务的需求@2014/7/14  
          	 */
          	 
            /* begin add for 关于IMS融合通信营帐优化、新增资费配置和经分报表开发需求的函@2014/8/13 
		        if ("<%=busiFlag%>" == '186'){
		          if(targetValue == "1"){ //用户类型为 移动用户,付费方式可修改
	            	$('#pay_flag').removeAttr('disabled');
	            }else{
	            	$('#pay_flag').attr('disabled', 'disabled');
	            }
		        }
		         end add for 关于IMS融合通信营帐优化、新增资费配置和经分报表开发需求的函@2014/8/13 */
        }).change();
        
        var smCode = document.getElementById("sm_code").value;
        /*
         * update 针对固话号码的成员，修改付费模式规则，提供统付和个付两种方式，默认统付。for 关于融合通信聚类和家庭客户营帐优化需求的函@2014/12/21 
         */
        /* begin add for 关于IMS融合通信营帐优化、新增资费配置和经分报表开发需求的函@2014/8/13 
        if (smCode == "RH" && '<%=busiFlag%>' == '186'){
        		
            if($('select[name="F70019"]').val() == "1"){ //用户类型为 移动用户,付费方式可修改
            	$('#pay_flag').removeAttr('disabled');
            }else{
            	//初始化对其禁用，提交的时候一定要放开，不然不能传值
            	$('#pay_flag').attr('disabled', 'disabled');	
            }
        }
         end add for 关于IMS融合通信营帐优化、新增资费配置和经分报表开发需求的函@2014/8/13 */
        
        var rhRadios = $('input[name="RH_input_radio"]').click(function(e){
            e.stopPropagation();
            
            var targetId = $(this).attr('targetId');
            var adverseId = $(this).attr('adverseId');
            $('.' + targetId).show();
            $('.' + adverseId).hide();
            
            if ($(this).attr('targetId') == "addSingleRH"){
                if (addRowNum <= 0){
                    $('#sure').attr('disabled', 'disabled');
                }
            } else {
                $('#sure').removeAttr('disabled');
            }
        });
        
        $(rhRadios[0]).click();
        
        $('#addRealNo').click(function(e){
            e.preventDefault();
            //1 校验短号 2 将portal name修改为跟其一样            
            if(!validatePhoneHeader()){
                return;
            }
            /* 
          	 * begin 关于融合通信新增移动固话业务的需求@2014/7/14  
          	 */
          <%if("186".equals(busiFlag)){ //RH的集团固话186 %>
          		if($("#addProductName").val()==""){ //附加套餐
          			rdShowMessageDialog("请先选择附加套餐！");
		            $("#addProductName").focus();
		            return false;
          		}
          		if($('select[name="F70019"]').val() == "0"){ //用户类型为固定用户时，校验
	            	if($('select[name="isOpenSettledPhone"]').val() == "1"){ //是否开通移动固话为：是，则需要校验“固话对应的手机号码”
	            		$("#settledPhone").attr("v_must","1");
	            		$("#settledPhone").attr("v_type","mobphone");
	            		if(!checkElement(document.all.settledPhone)) return false;
	            	}else{
	            		$("#settledPhone").attr("v_must","");
	            		$("#settledPhone").val("");
	            		hiddenTip(document.all.settledPhone);
	            	}
	            }
          <%}%>
            
            /* 
          	 * end 关于融合通信新增移动固话业务的需求@2014/7/14  
          	 */
          	/*wuxy alter 20141222 portal名字改为长号var value = $('input[name="short_no"]').val();*/
            var value = $('input[name="real_no"]').val();
            $('#portalName').val(value);
            call_RH_ISDNNOINFO();
        });
        
        $("#isOpenSettledPhone").change(function(){
        	if($(this).val() == "1"){ //选择是
        		if($("#addProductName").val()==""){ //附加套餐
        			rdShowMessageDialog("请先选择附加套餐！");
        			$("#isOpenSettledPhone").val("0");
	            $("#addProductName").focus();
	            return false;
        		}else{
        			if(parseInt($("#isOpenCountFlagHidden").val()) == 0 ){
        				rdShowMessageDialog("此附加套餐不能进行开通移动固话操作！");
	        			$("#isOpenSettledPhone").val("0");
		            $("#addProductName").focus();
		            return false;
        			}
        		}
        	}
        });
	});
	
	/**
	固话成员短号号首从产品属性自动获取，号首如果为“-”，限制固话成员短号码首位只能为7且长度限制为5-6位；
    固话号首如果为7，固话短号码首位不做限制但限制长度为4-5位；
    
    固话短号号首对手机成员无约束，及无论固话号首是什么，
    手机成员短号码首位限制为6，且长度限制为5-6位。
	*/
	function validatePhoneHeader(){
	    var result = false;
	    var msg = "";
	    var value = $.trim($('input[name="short_no"]').val());
	    var userType = $('select[name="F70019"]').val();
	    //短号规则处理
        var phoneHeader = '<%=phoneHeader%>';
        if (userType == '0'){//固话
            if (phoneHeader == '-' || phoneHeader == '无' ||phoneHeader == ''){
                if (value.substring(0,1) != '7' || 
                      (value.length != 5 && value.length != 6)){
                    msg = '短号号码要以7开头，且位数必须是5位或6位！';
                    result = true;
                }
            }else if (phoneHeader == '7'){
                if (value.length != 5 && value.length != 4){
                    msg = '位数必须是4位或5位！';
                    result = true;
                }
            }
        } else if (userType == '1'){//手机
            if (value.substring(0,1) != '6' || 
                    (value.length != 5 && value.length != 6)){
                msg = '短号号码要以6开头，且位数必须是5位或6位！';
                result = true;
            }
        }
        
        if (result){
            rdShowMessageDialog(msg);
            $('#portalName').text('');
            return false;
        }
        
        return true;
	}
	
	function delExtRecord(obj) {
		$(obj).parent().parent().remove();
		var count = $('#ext_sub_recordCount').val();
		if(count) {
			$('#ext_sub_recordCount').val(Number(count)	- 1);
		}else {
			$('#ext_sub_recordCount').val(0);	
		}
	}
	
	function setSureBtnDisabled(flag) {
		if(flag) {
			$("#sure").attr("disabled",true);	
		}else {
			$("#sure").removeAttr("disabled");	
		}
	}
	//遮罩F81018，如果直接设置成disabled，后台获取数据为null
	function overSelect($obj){
        var dvHtml ='<div id="overSelectDiv" class="overSelect"></div>';
        $("body").append(dvHtml);
        $("#overSelectDiv").show();
        $("#overSelectDiv").css("left",$obj.offset().left+"px");
        $("#overSelectDiv").css("top",$obj.offset().top+"px");
        $("#overSelectDiv").css("width",$obj.width()+5+"px");
        $("#overSelectDiv").css("height",$obj.height()+5+"px");
        $("#overSelectDiv").css("opacity",50/100);
        $("#overSelectDiv").css("z-Index","10");
        }
	/*
	function extUploadFile() {
		if($("#extUploadFile").val() == ""){    //文件录入
            rdShowMessageDialog("请选择文件！",0);
            $("#extUploadFile").focus();
            return false;
        }else{
            var uploadfile = document.all.extUploadFile.value;
        	var ext = "*.txt";
        	var file_name = uploadfile.substr(uploadfile.lastIndexOf(".")); 
        	if(ext.indexOf("*"+file_name)==-1){   
                rdShowMessageDialog("程序只支持txt格式文件(*.txt)！",0);  
                return;  
            }
        }
        document.frm.target="hidden_frame";
	    document.frm.encoding="multipart/form-data";
	    document.frm.action="f7983_upload.jsp";
	    document.frm.method="post";
	    document.frm.submit();
	    $("#sure").attr("disabled",true);
	}
	*/
	
</script>


<script>
	//liujian 2013-3-29 8:58:50 添加
	$(function() {
		if($('#F70019').attr('name') == 'F70019') {
			if($('#F70019').val() != '1') {
				if($('#F70026').attr('name') == 'F70026') {
					$('#F70026').parent().append('<font style="color:red">若未订购融合V网业务，短号互拨功能将不能生效</font>')	
				}		
			}
		}
		
		if($('#F81051').attr('name') == 'F81051') {
					$('#F81051').parent().append('&nbsp;<font style="color:red">00为长期有效</font>')			
		}
		
	});
</script>