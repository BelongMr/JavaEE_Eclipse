<%
    /********************
     * @ OpCode    :  7896
     * @ OpName    :  ���ų�Ա���Ա��
     * @ CopyRight :  si-tech
     * @ Author    :  qidp
     * @ Date      :  2009-09-27
     * @ Update    :  
     ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%!
		/**
     * ��������������������
     */
    public static Date addMonthPub(Date date, int n) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.MONTH, n);
        return cal.getTime();
    }
    
    /**
     * ʹ�ò���Format��ʽ��Date���ַ���
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
    String opCode = "7896";
    String opName = "���ų�Ա���Ա��";
    
    String workNo = WtcUtil.repNull((String)session.getAttribute("workNo"));
    String workName = WtcUtil.repNull((String)session.getAttribute("workName"));
    String workPwd = WtcUtil.repNull((String)session.getAttribute("password"));
    String orgCode = WtcUtil.repNull((String)session.getAttribute("orgCode"));
    String groupId = WtcUtil.repNull((String)session.getAttribute("groupId"));
    String regionCode = WtcUtil.repNull((String)session.getAttribute("regCode"));
    String powerRight = WtcUtil.repNull((String)session.getAttribute("powerRight"));
    String districtCode = orgCode.substring(2,4);
    
    String busiFlag = WtcUtil.repNull(request.getParameter("busiFlag")); 
    String phoneHeader = WtcUtil.repNull(request.getParameter("phoneHeader")); 
    
    Logger logger = Logger.getLogger("f7896_1.jsp");
    
    String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
    
        /*begin wanghyd add for �ж��Ƿ����Ż������Ȩ��@2012/11/6 */
  String[][] temfavStr = (String[][])session.getAttribute("favInfo");
	String[] favStr = new String[temfavStr.length];
	boolean operFlag = false;
	for(int i = 0; i < favStr.length; i ++) {
		favStr[i] = temfavStr[i][0].trim();
	}
	if (WtcUtil.haveStr(favStr, "a385")) {
		operFlag = true;
	}
	
	/*��ȡ��ǰʱ��*/
    Date nowTime = new Date();
    /*��ǰʱ������1����*/
    Date addMonthT = addMonthPub(nowTime,1);
    /*����1����*/
    String addMonthTStr = formatPub(addMonthT,"yyyyMM");
	
	
	 /*end wanghyd add @2012/11/6 */
    
    String nextFlag = "1";
    String[][] result = new String[][]{};
    String[][] result2= new String[][]{};
    String handfee2 = "";
    String dateStr2 = "";
    
    String iIccid = "";     //֤������
    String iCustId = "";    //�ͻ�ID
    String iUnitId = "";
    String iServiceNo = "";
    String iProductId = "";
    String iAccountId = "";
    String iSmCode = "";    //����Ʒ��
    String iSmName = "";
    String iBelongCode = "";
    String iProductPwd = "";
    String modeCode = "";
    String iPayFlag = "";
    String iBillTime = "";
    String iUserTypeName = "";
    String iUserType = "";  //��Ա�û�����
    String iAddProduct = "";
    String iRequestType = "";
	String id_no = "";
	String iGrpName = "";
	String iProductName = "";
    String iUserType2 = "";
    String limitcount = "";
    String arcFlag = "";
     /*begin ����ͻ��������ź�������������� ���� by diling*/
    String iCustManagerNoHiden = "";
    String iCustManagerNameHiden = "";
    String iUnitTypeHiden = "";
    /*end add by diling*/
        
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
	String [][]userFieldUpdateFlag=new String[][]{};
    
    int resultListLength=0;
    String[][] resultList = new String[][]{};
    String listShow="none";
    String vplistShow="none";
    String j1listShow="none";
    String nplistShow="none";
    String otherShow="none";
    String single_phoneno="";
    String member_use = "";
    
	Date date = new Date();
	SimpleDateFormat df = new SimpleDateFormat("yyyyMM");
	GregorianCalendar gc = new GregorianCalendar();
	gc.setTime(date); 
	gc.add(2,1);
	gc.set(gc.get(gc.YEAR),gc.get(gc.MONTH),gc.get(gc.DATE));
	String beginDate=df.format(gc.getTime())+"01";
	gc.add(1,1);
	String endDate=df.format(gc.getTime())+"01";
    
    String action = WtcUtil.repNull((String)request.getParameter("action"));
    /* ���"��һ��"�󣬽��д����� */
    if("next".equals(action)){
        nextFlag = "2";
        iIccid = WtcUtil.repNull((String)request.getParameter("iccid"));
        iCustId = WtcUtil.repNull((String)request.getParameter("cust_id"));
        iUnitId = WtcUtil.repNull((String)request.getParameter("unit_id"));
        iServiceNo = WtcUtil.repNull((String)request.getParameter("service_no"));
        iProductId = WtcUtil.repNull((String)request.getParameter("product_id"));
        iAccountId = WtcUtil.repNull((String)request.getParameter("account_id"));
        iSmCode = WtcUtil.repNull((String)request.getParameter("sm_code"));
        iSmName = WtcUtil.repNull((String)request.getParameter("sm_name"));
        id_no = WtcUtil.repNull((String)request.getParameter("id_no"));
        iBelongCode = WtcUtil.repNull((String)request.getParameter("belong_code"));
        iProductPwd = WtcUtil.repNull((String)request.getParameter("product_pwd"));
        iPayFlag = WtcUtil.repNull((String)request.getParameter("pay_flag"));
        iBillTime = WtcUtil.repNull((String)request.getParameter("bill_time"));
        iUserTypeName = WtcUtil.repNull((String)request.getParameter("user_type_name"));
        iUserType = WtcUtil.repNull((String)request.getParameter("user_type"));
        iAddProduct = WtcUtil.repNull((String)request.getParameter("add_product"));
        if ("j1".equals(iSmCode)) {
	        iRequestType = WtcUtil.repNull((String)request.getParameter("j1_request_type"));
        } else {
	        iRequestType = WtcUtil.repNull((String)request.getParameter("request_type"));
	        System.out.println("---liujian7896---iRequestType=" + iRequestType);
        }
        iGrpName = WtcUtil.repNull((String)request.getParameter("grp_name"));
        iProductName = WtcUtil.repNull((String)request.getParameter("product_name"));
        limitcount = WtcUtil.repNull((String)request.getParameter("limitcount"));
        iUserType = iSmCode;
        iUserType2 = iUserType;
        
        System.out.println("#  iUserType = "+iUserType2);
         /*begin add by diling@2012/5/14 */
        iCustManagerNoHiden = WtcUtil.repNull((String)request.getParameter("custManagerNoHiden"));
        iCustManagerNameHiden = WtcUtil.repNull((String)request.getParameter("custManagerNameHiden"));
        iUnitTypeHiden = WtcUtil.repNull((String)request.getParameter("unitTypeHiden"));
        /*end add by diling*/
        
        /*********************
         * �жϹ��Ż����Ƿ��а�����ҵ���Ȩ��
         *********************/
        try{
        	if("".equals(iRequestType))
        	{
        		iRequestType ="m02";
        	}
    		System.out.println("====wanghfa====f7896_1.jsp====sCheckLogin====0====" + workNo);
    		System.out.println("====wanghfa====f7896_1.jsp====sCheckLogin====1====" + workPwd);
    		System.out.println("====wanghfa====f7896_1.jsp====sCheckLogin====2====" + iSmCode);
    		System.out.println("====wanghfa====f7896_1.jsp====sCheckLogin====3====" + iRequestType);
    		System.out.println("====wanghfa====f7896_1.jsp====sCheckLogin====4====");
    		System.out.println("====wanghfa====f7896_1.jsp====sCheckLogin====5====" + iProductId);
    		System.out.println("====wanghfa====f7896_1.jsp====sCheckLogin====6====" + iCustId);
    		System.out.println("====wanghfa====f7896_1.jsp====sCheckLogin====7====" + id_no);
            %>
                <wtc:service name="sCheckLogin" routerKey="region" routerValue="<%=regionCode%>" retcode="sCheckLoginCode" retmsg="sCheckLoginMsg" outnum="2" >
                	<wtc:param value="<%=workNo%>"/>
                	<wtc:param value="<%=workPwd%>"/> 
                    <wtc:param value="<%=iSmCode%>"/>
                    <wtc:param value="<%=iRequestType%>"/>
                    <wtc:param value=""/>
                    <wtc:param value="<%=iProductId%>"/>
                    <wtc:param value="<%=iCustId%>"/>
                    <wtc:param value="<%=id_no%>"/>
                </wtc:service>
            <%
            if(!"000000".equals(sCheckLoginCode)){
                %>
                    <script type=text/javascript>
                        rdShowMessageDialog("������룺<%=sCheckLoginCode%><br/>������Ϣ:<%=sCheckLoginMsg%>",0);
                        history.go(-1);
                    </script>
                <%
            }
        }catch(Exception e){
            %>
                <script type=text/javascript>
                    rdShowMessageDialog("���÷���sCheckLoginʧ�ܣ�",0);
                    history.go(-1);
                </script>
            <%
            e.printStackTrace();
        }
    }else{
        iBillTime = dateStr;
    }
    
    /* ��֯��̬չʾ���� */
    String mm_phoneType=request.getParameter("mm_phoneType"); //MMƷ�ƺ����Ƿ�������־
System.out.println("-------hejwa--1111-------------mm_phoneType------------->"+mm_phoneType);

    
    String bath_cfmPnoneNo=request.getParameter("cfmPnoneNo");
    String sqlStr = "";
    //���Ǵ�MMƷ�Ƶ�������ת������
	if("2".equals(nextFlag)&&(!"2".equals(mm_phoneType)&&!"3".equals(mm_phoneType))){
	
		
		String service_no=request.getParameter("service_no");
		single_phoneno=request.getParameter("single_phoneno");
		member_use=request.getParameter("member_use");
		
		
		
		
		
		System.out.println("====wanghfa====f7896_1.jsp====sc506Init====0====workNo = " + workNo);
		System.out.println("====wanghfa====f7896_1.jsp====sc506Init====1====single_phoneno = " + single_phoneno);
		System.out.println("====wanghfa====f7896_1.jsp====sc506Init====2====3508");
		System.out.println("====wanghfa====f7896_1.jsp====sc506Init====3====iSmCode = " + iSmCode);
		System.out.println("====wanghfa====f7896_1.jsp====sc506Init====4====id_no = " + id_no);
		System.out.println("====wanghfa====f7896_1.jsp====sc506Init====5====iProductId = " + iProductId);
%>
			<wtc:service name="sc506Init" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode3" retmsg="retMsg3"  outnum="41">
			<wtc:param value="0"/>
			<wtc:param value=""/>
			<wtc:param value="3508"/>
			<wtc:param value="<%=workNo%>"/>
			<wtc:param value="<%=workPwd%>"/>
			<wtc:param value="<%=single_phoneno%>"/>
			<wtc:param value=""/>
			<wtc:param value="<%=iSmCode%>"/>
      <wtc:param value="<%=id_no%>"/>
      <wtc:param value="<%=iProductId%>"/>
			</wtc:service>
			<wtc:array id="paramsOut261" start="26" length="1" scope="end"/>
			<wtc:array id="paramsOut271" start="27" length="1" scope="end"/>
			<wtc:array id="paramsOut281" start="28" length="1" scope="end"/>
			<wtc:array id="paramsOut291" start="29" length="1" scope="end"/>
			<wtc:array id="paramsOut301" start="30" length="1" scope="end"/>
			<wtc:array id="paramsOut311" start="31" length="1" scope="end"/>
			<wtc:array id="userFieldGrpNo1" start="32" length="1" scope="end"/>
			<wtc:array id="userFieldGrpName1" start="33" length="1" scope="end"/>
			<wtc:array id="userFieldMaxRows1" start="34" length="1" scope="end"/>
			<wtc:array id="userFieldMinRows1" start="35" length="1" scope="end"/>
			<wtc:array id="userFieldCtrlInfos1" start="37" length="1" scope="end"/>
			<wtc:array id="userFieldUpdateFlag1" start="38" length="1" scope="end"/>
			<wtc:array id="retArray" scope="end"/>			
<%
			int error_code = Integer.parseInt(retCode3);
	        String error_msg=retMsg3;
	        
	        /*liujian 2013-3-28 10:49:12 7896 ��ӡ����鿴 begin*/
		/*
	        for(int i=0;i<userFieldGrpNo1.length;i++) {
	        	for(int j=0;j<userFieldGrpNo1[i].length;j++) {
	        		System.out.println("---liujian 7896---userFieldGrpName1[" + i + "][" + j + "]=" + userFieldGrpName1[i][j]);
	        		System.out.println("---liujian 7896---userFieldGrpNo1[" + i + "][" + j + "]=" + userFieldGrpNo1[i][j]);
	        		System.out.println("---liujian 7896---userFieldMaxRows1[" + i + "][" + j + "]=" + userFieldMaxRows1[i][j]);
	        		System.out.println("---liujian 7896---CODE[" + i + "][" + j + "]=" + paramsOut261[i][j]);
	        		System.out.println("---liujian 7896---NAME[" + i + "][" + j + "]=" + paramsOut271[i][j]);
	        	}
	        }
	        */
	        /*liujian 2013-3-28 10:49:12 7896 ��ӡ����鿴 end*/
	        
	        
	        
	        
	        
		System.out.println("*************error_msg*******"+error_msg+"***********");
		if(error_code!=0)
		{
				
%>
				<script language="javascript">
					rdShowMessageDialog("������룺<%=error_code%>������Ϣ��<%=error_msg%>",0);
					location = "f7896_1.jsp";
				</script>
<%
		}
		else
		{
			System.out.println("-----------1---------");
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
			userFieldUpdateFlag=userFieldUpdateFlag1;
			
			System.out.println("-----------2----------");
			System.out.println("-------paramsOut27--------");
			//----�õ����û�û�����ӵ���
/*			sqlStr="select a.field_code,a.field_name,a.field_purpose,a.field_type,a.field_length,b.ctrl_info"
        	+"  from sUserFieldCode a,sUserTypeFieldRela b"
        	+" where a.busi_type = b.busi_type"
        	+"     AND a.field_code=b.field_code"
        	+"     AND b.user_type = '"+paramsArray[9]+"'"
        	+"   and a.field_code in("
        	+" SELECT a.field_code"
        	+"      FROM suserfieldcode a, susertypefieldrela b"
        	+"      WHERE a.busi_type = b.busi_type"
        	+"      AND a.field_code = b.field_code"
        	+"      AND b.user_type = '"+paramsArray[9]+"'"
        	+"      and b.field_grp_no ='0'"
        	+"      MINUS"
        	+"      SELECT a.field_code"
        	+"      FROM dcustmsgadd a, susertypefieldrela c"
        	+"      WHERE a.id_no = '"+paramsArray[0]+"'"
        	+"      AND a.busi_type = c.busi_type"
        	+"      AND a.field_code = c.field_code"
        	+"      AND a.user_type = c.user_type)"
        	+" order by b.field_order,a.field_type";
			resultList2=(String[][])callView.sPubSelect("6",sqlStr).get(0);
			System.out.println("----------------"+resultList2.length+"----------------------");
			if (resultList2 != null)
			{
				if (resultList2[0][0].equals(""))
				{
					resultList2 = null;
				}
			}
			if (resultList2 != null)
			{
				for(int i=0;i<resultList2.length;i++)
				{
					if (resultList2[i][2].equals("10"))
					{
						numberList.append(resultList2[i][0]+"|");
					}
				}
			}

			resultListLength2=0;
			if (resultList2 != null)
			{
				resultListLength2=resultList2.length;
				//����ƴ�����ݵ��¸�ҳ��
			    for (int i=0;i<resultListLength2;i++)
			    {
					fieldCode2.append(resultList2[i][0]+"|");
					System.out.println("============:"+resultList2[i][0]);
				}
			}
*/		  	

			//---------------------------				
				
				
				
				
				
				
				
			listShow="";
			System.out.println("gaopengSeeLog--------7896-----iSmCode=="+iSmCode);
			if("vp".equals(iSmCode))
			{
				vplistShow="";
			} else if ("j1".equals(iSmCode)) {	//wanghfa���� 2010-12-7 15:45 �����ܻ�����BOSSϵͳ
				j1listShow="";
			} else if("np".equals(iSmCode))
			{
				nplistShow="";
			}else
			{
				otherShow="";
			}
		}
		
		if("vp".equals(iSmCode)){
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
            
             /*chendx 20100818 ����vp��Ա����ʱ�ж��Ƿ�Ϊ��������*/
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
            /*20100818 end*/
        }
    }else{
	}
	
    /**************
     * ȡ������ˮ
     **************/
    String sysAccept = "";
    %>
        <wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>"  id="seq"/>
    <%
    sysAccept = seq;
%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>���ų�Ա���Ա��</title>
    
<script type=text/javascript>
    var dynTbIndex=1;				//���ڶ�̬�����ݵ�����λ��,��ʼֵΪ1.���Ǳ�ͷ
    var dynTb2Index=1;
    var oprType_Add = "a";

    onload=function(){
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
            $("#product_name").addClass("InputGrey")
            $("#account_id").attr("readOnly",true);
            $("#account_id").addClass("InputGrey");
            $("#sm_code").attr("readOnly",true);
            $("#sm_code").addClass("InputGrey");
            $("#sm_name").attr("readOnly",true);
            $("#sm_name").addClass("InputGrey");
            $("#product_pwd").attr("readOnly",true);
            $("#product_pwd").addClass("InputGrey");
            $("#belong_code").find("option:not(:selected)").remove();
            
            //diling update
            if(document.all.single_phoneno!=null){
                $("#single_phoneno").attr("readOnly",true);
            }
            
            /*begin diling add for ��ǰBOSSϵ7896ģ����APN��Ա���Բ�����ʽ������ */
            if((document.all.sm_code.value) != "vp" &&(document.all.sm_code.value) != "np" && document.all.sm_code.value != "j1")	//wanghfa�޸� 2010-12-7 15:38 �����ܻ�����BOSSϵͳ����
            {
            	div1.style.display="";
              var v_smCode = document.all.sm_code.value;
              var myPacket = new AJAXPacket("f7896_ajax_chkMemberFileShow.jsp","���ڻ�ȡ��Ϣ�����Ժ�......");
              myPacket.data.add("v_smCode",v_smCode);
              core.ajax.sendPacket(myPacket,doChkMemberShow);
              myPacket=null;
        	  }
        	  /*end diling add */
        	  // liujian ���� m10���ж�
            if("<%=iSmCode%>" == "vp" && ("<%=iRequestType%>" == "m02" || "<%=iRequestType%>" == "m10")){
                /* vpʱ,�����ײ��ʷ���Ч���ڸ�ֵΪ���µ�һ�� */
                document.all.F80006.value="<%=dateStr2%>";
            }
            
            if(document.all.member_use!=null){
                $("#member_use").attr("readOnly",true);
            }
            /* 
          	 * begin �����ں�ͨ�������ƶ��̻�ҵ�������@2014/7/14  
          	 */
            if($("#sm_code").val() == "RH" && document.all.busiFlag.value == '186'){
            	$("#isOpenSettledPhoneHidd").val($("select[name='F70052']").val());//�ƶ��̻���������
							$("select[name='F70052']").change(function(){
								if($("select[name='F70050']").val() == "0" && $(this).val() == "1"){ //�Ƿ�ͨ�ƶ��̻�Ϊ�����ܽ��н��
									rdShowMessageDialog("��ͨ�ƶ��̻�Ϊ��ʱ�����ܽ��н�������");
									$(this).val($("#isOpenSettledPhoneHidd").val());
									if($("select[name='F70052']").val() == "2"){
										$("input[name='F70051']").attr("disabled",false);
									}else{
										$("input[name='F70051']").attr("disabled",true);
									}
									return false;
								}
								if($("select[name='F70050']").val() == "1" && $(this).val() == "2"){ //�Ƿ�ͨ�ƶ��̻�Ϊ�ǣ����ܽ��а�
									rdShowMessageDialog("��ͨ�ƶ��̻�Ϊ��ʱ�����ܽ��а󶨲�����");
									$(this).val($("#isOpenSettledPhoneHidd").val());
									if($("select[name='F70052']").val() == "2"){
										$("input[name='F70051']").attr("disabled",false);
									}else{
										$("input[name='F70051']").attr("disabled",true);
									}
									return false;
								}
								if($("select[name='F70052']").val() == "2"){ //�����ƶ��̻��������͡�Ϊ��ʱ�����ܶԡ��̻���Ӧ���ֻ����롱�����޸�
									$("input[name='F70051']").attr("disabled",false);
								}else{
									$("input[name='F70051']").attr("disabled",true);
								}
							});
							if($("select[name='F70052']").val() == "2"){
								$("input[name='F70051']").attr("disabled",false);
							}else{
								$("input[name='F70051']").attr("disabled",true);
							}
            }
            /* 
          	 * end �����ں�ͨ�������ƶ��̻�ҵ�������@2014/7/14  
          	 */
            
        <% } %>
        
        <%
            for(int i=0;i<paramsOut26.length;i++){
                if("N".equals(userFieldUpdateFlag[i][0])){
                    String tFieldCode = "F" + paramsOut26[i][0];
                    if("17".equals(paramsOut30[i][0])){
                        String tpCode0 = "$(\"#"+tFieldCode+"\").find(\"option:not(:selected)\").remove()";
                        out.print("eval("+tpCode0+");");
                    }else{
                        String tpCode1 = "$(\"#"+tFieldCode+"\").addClass(\"InputGrey\")";
                        String tpCode2 = "$(\"#"+tFieldCode+"\").attr(\"readOnly\",true)";
                        out.print("eval("+tpCode1+");");
                        out.print("eval("+tpCode2+");");
                    }
                }
            }
        %>
    }
    
    function doChkMemberShow(packet){
      var retCode = packet.data.findValueByName("retcode");
      var retMsg = packet.data.findValueByName("retmsg");
      var isMemberFileShow = packet.data.findValueByName("isMemberFileShow");
      if(retCode!="000000"){
       rdShowMessageDialog("������룺"+retCode+"<br>������Ϣ��"+retMsg,0);
       return false;
      }else{
        //alert("isMemberFileShow="+isMemberFileShow);
        if(isMemberFileShow=="1"){ // ��������ģʽ��0-�������� 1-����\�ļ�¼�� Ĭ��Ϊ0
          if("2"=="<%=nextFlag%>"){
            div1.style.display="";
            selRadios.style.display = "";
            single_no.style.display = "";
            input_file.style.display = "none";
            document.getElementById("single_phoneno").readOnly = false;
          }
        }else{
          div1.style.display="";
          selRadios.style.display = "none";
          single_no.style.display = "";
          input_file.style.display = "none";
        }
      }
    }

    function allChoose()
    {   //��ѡ��ȫ��ѡ��
        for (i = 0; i < document.frm.elements.length; i++)
        {
            if (document.frm.elements[i].type == "checkbox")
            {    //�ж��Ƿ��ǵ�ѡ��ѡ��
                document.frm.elements[i].checked = true;
            }
        }
    }
	function cancelChoose()
    {   //ȡ����ѡ��ȫ��ѡ��
        for (i = 0; i < document.frm.elements.length; i++)
        {
            if (document.frm.elements[i].type == "checkbox")
            {    //�ж��Ƿ��ǵ�ѡ��ѡ��
                document.frm.elements[i].checked = false;
            }
        }
    }
	
	function queryAddAllRow(add_type,phone_no,isdn_no,user_name,id_card,pStatus,curpkgtype,pkg_name)
	{
    	var exec_status="";
	    var tr1="";
	    var i=0;
	    tr1=dyntb.insertRow();    //ע�⣺����ı������������һ��,������ɿ���.yl.
	    tr1.id="tr"+dynTbIndex;
	    tr1.insertCell(0).innerHTML = '<div align="center"><input id=R0    type=checkBox size=4 value="'+ phone_no+'"></input></div>';
	    tr1.insertCell(1).innerHTML = '<div align="center"><input id=R1    type=text   size=10 value="'+ phone_no+'" class=InputGrey e></input></div>';
	    tr1.insertCell(2).innerHTML = '<div align="center"><input id=R2    type=text   value="'+ isdn_no+'"  class=InputGrey readonly></input></div>';
	    tr1.insertCell(3).innerHTML = '<div align="center"><input id=R3    type=text   value="'+ curpkgtype+"->"+pkg_name+'" class=InputGrey  readonly></input></div>';
    }
	
	//wanghfa���� j1����BOSS
	function j1QueryAddAllRow(j1No, phoneNo)
	{
    	var exec_status="";
	    var tr1="";
	    var i=0;
	    tr1=dyntb.insertRow();    //ע�⣺����ı������������һ��,������ɿ���.yl.
	    tr1.id="tr"+dynTbIndex;
	    tr1.insertCell(0).innerHTML = '<div align="center"><input id=R0    type=checkBox size=4 value="'+ j1No+'"></input></div>';
	    tr1.insertCell(1).innerHTML = '<div align="center"><input id=R1    type=text   size=10 value="'+ j1No+'" class=InputGrey e></input></div>';
	    tr1.insertCell(2).innerHTML = '<div align="center"><input id=R2    type=text   value="'+ phoneNo+'"  class=InputGrey readonly></input></div>';
    }

    /* ��ѯ�����û���Ϣ */
    function getCustInfo(){
        var pageTitle = "���ſͻ�ѡ��";

        var fieldName = "֤������|���ſͻ�ID|���ſͻ�����|���Ų�ƷID|���ź�|��Ʒ����|��Ʒ����|���ű��|��Ʒ�����ʻ�|Ʒ�ƴ���|Ʒ������|���±�ʶ|��������|limitcount|limitcount|limitcount|limitcount|�������|���ſͻ���������|���ſͻ���������|";//update diling
        var sqlStr = "";
        var selType = "S";    //'S'��ѡ��'M'��ѡ
        var retQuence = "15|0|1|7|4|5|8|9|3|2|6|10|16|17|18|19|"; //update diling

        var retToField = "iccid|cust_id|unit_id|service_no|product_id|account_id|sm_code|id_no|grp_name|product_name|sm_name|limitcount|unitTypeHiden|custManagerNameHiden|custManagerNoHiden|";//update diling
        /**add by liwd 20081127,group_id����dcustDoc��group_id end **/

        if(document.frm.iccid.value == "" && document.frm.cust_id.value == "" && document.frm.unit_id.value == "" && document.frm.service_no.value == "")
        {
            rdShowMessageDialog("������֤�����롢�ͻ�ID������ID���źŽ��в�ѯ��");
            document.frm.iccid.focus();
            return false;
        }
        
        if((document.frm.cust_id.value) != "" && forNonNegInt(frm.cust_id) == false)
        {
            frm.cust_id.value = "";
            rdShowMessageDialog("�ͻ�ID���������֣�");
            return false;
        }
        
        if((document.frm.unit_id.value) != "" && forNonNegInt(frm.unit_id) == false)
        {
            frm.unit_id.value = "";
            rdShowMessageDialog("����ID���������֣�");
            return false;
        }
        
        PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
    }
    
    function PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField){
        var path = "<%=request.getContextPath()%>/npage/s7896/fpubcust_sel.jsp";
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
    
    function getvaluecust(retInfo, extensionValue){
        var retToField = "iccid|cust_id|unit_id|service_no|product_id|account_id|sm_code|id_no|grp_name|product_name|sm_name|limitcount|unitTypeHiden|custManagerNameHiden|custManagerNoHiden|";//diling add
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
        if((document.all.sm_code.value)=="vp")
        {	
        	tbs1.style.display="";
        	tbs2.style.display="";
        	//liujian 2013-1-15 14:39:01 �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ�
        	var $select = $('#request_type option[value="m10"]');
        	if( $select && $select.text() == '2-�����޸�(���������ʷ�)') {
        		
        	}else {
        		$('#request_type').append('<option value="m10">2-�����޸�(���������ʷ�)</option>');
        	}
        	
        } else if (document.all.sm_code.value == "j1") {	//wanghfa���� 2010-12-7 15:38 �����ܻ�����BOSSϵͳ����
        	tbs3.style.display="";
        	tbs4.style.display="";
		}
		    //diling update for ��ǰBOSSϵ7896ģ����APN��Ա���Բ�����ʽ������
        if((document.all.sm_code.value) != "vp" &&(document.all.sm_code.value) != "np" && document.all.sm_code.value != "j1")	//wanghfa�޸� 2010-12-7 15:38 �����ܻ�����BOSSϵͳ����
        {
          var v_smCode = document.all.sm_code.value;
          var myPacket = new AJAXPacket("f7896_ajax_chkMemberFileShow.jsp","���ڻ�ȡ��Ϣ�����Ժ�......");
          myPacket.data.add("v_smCode",v_smCode);
          core.ajax.sendPacket(myPacket,doChkMemberShow);
          myPacket=null;
        	//div1.style.display="";
    	  }
    	
        $("#iccid").attr("readOnly",true);
        $("#cust_id").attr("readOnly",true);
        $("#unit_id").attr("readOnly",true);
        $("#service_no").attr("readOnly",true);
        
        document.all.phoneHeader.value = extensionValue.phoneHeader;
        document.all.busiFlag.value = extensionValue.busiFlag;
        
        
        set_MM_pl();
        
    }
 
 
 
/*
 * hejwa yull 2016/11/2 9:24:12 add
 * 1�� ������������
 *   ��1�� ��ԡ���7897�����ų�Ա�ʷѱ�������M2Mҵ��������������Ա�ʷѱ��������ֻ���M2M�ĳ�Ա�ʷѣ�
 *       ���д����ʷѱ����������Ա�ʷ�ԤԼ��Ч�������е���������Ա�ʷѱ��������ͬ��
 *   ��2�� ��ԡ���7896�����ų�Ա���Ա�������棬������������M2M�ۿ��ʷѵĹ��ܣ��˴�ֻ�����ۿ��ʷѣ��ۿ��ʷ�ԤԼ��Ч��
 */
function set_MM_pl(){
	if($("#sm_code").val()=="MM"){
		$("#div_mm_chg_type").show();
	}else{
		$("#div_mm_chg_type").hide();
	}
}

function chg_MM_tab_show(flag){
	
	$("#mm_phoneType").val(flag);
	
	if(flag=="1"){
		$("#MM_batch").hide();
		$("#MM_general").show();
	}else{
		$("#MM_batch").show();
		$("#MM_general").hide();
	}
		$("#textarea_batch").text("");
		$("#count_phoneNo").text("0");
}

//У���ֻ����룺���������ֿ�ͷ���������⣬�ɺ��С�-��
function forMobilPhoneNo(val){
	var patrn=/^((\(\d{3}\))|(\d{3}\-))?[12][0358]\d{9}$/;
	var sInput = val;
	if(sInput.search(patrn)==-1){
		return false;
	}
	return true;
}

$(document).ready(function(){
	
	
	
	if("<%=mm_phoneType%>"=="2"||"<%=mm_phoneType%>"=="3"){
		$("#mm_phoneType").val("<%=mm_phoneType%>");
		//ͨ��MM�����ķ�ʽ����
		$("#MM_batch").show();
		$("#MM_general").hide();
		
		$("#count_phoneNo").text(("<%=bath_cfmPnoneNo%>".split("|").length-1)+"");
		$("#textarea_batch").text("<%=bath_cfmPnoneNo%>");
		$("#textarea_batch").attr("disabled","disabled");
		
		$("#MM_batch_attr").show();
		
		if("<%=mm_phoneType%>"=="2"){
			$("#tr_show2").show();
		}
		
		if("<%=mm_phoneType%>"=="3"){
			$("#tr_show3").show();
		}
		
		
	}
});
function check_bath_phoneNo(){

	var phoneNoText = $("#textarea_batch").text().trim();

	if(phoneNoText==""){
		rdShowMessageDialog("�������벻��Ϊ��");
		return false;
	}

	var phoneNo_arr = phoneNoText.split("|");

	var count_phoneNo = 0;


	var phoneNo_temp = "";
	for(var i=0;i<phoneNo_arr.length;i++){
		phoneNo_temp = phoneNo_arr[i].trim();
		if(phoneNo_temp!=""){
			count_phoneNo ++;
		}
	}
	$("#count_phoneNo").text(count_phoneNo+"");

	count_phoneNo = 0;
	phoneNo_temp = "";
	var is_ok = 0;
	for(var i=0;i<phoneNo_arr.length;i++){
		phoneNo_temp = phoneNo_arr[i].trim();

		if(phoneNo_temp!=""){
			if(!forMobilPhoneNo(phoneNo_temp)){
				is_ok = 1;
				break;
			}

			//�ָ����ȴ���2�϶����ظ���
			if(phoneNoText.split(phoneNo_temp).length>2){
				is_ok = 2;
				break;
			}

			count_phoneNo ++;
		}
	}


	if(count_phoneNo>50){
		rdShowMessageDialog("������������50��");
		return false;
	}

	if(is_ok==1){
		rdShowMessageDialog("�б������ݣ�"+phoneNo_temp+" �����ֻ���");
		return false;
	}else if(is_ok==2){
		rdShowMessageDialog("�б������ݣ�"+phoneNo_temp+" Ϊ�ظ�����");
		return false;
	}{
		return true;
	}

}





    function validatePhoneHeader(){
	    var result = false;
	    var msg = "";
	    var value = $.trim($('input[name="F70026"]').val());
	    var userType = $('select[name="F70019"]').val();
	    //�̺Ź�����
        var phoneHeader = document.all.phoneHeader.value;
        if (userType == '0'){//�̻�
            if (phoneHeader == '-' || phoneHeader == '��' ||phoneHeader == ''){
                if (value.substring(0,1) != '7' || 
                      (value.length != 5 && value.length != 6)){
                    msg = '�̺ź���Ҫ��7��ͷ����λ��������5λ��6λ��';
                    result = true;
                }
            }else if (phoneHeader == '7'){
                if (value.length != 5 && value.length != 4){
                    msg = 'λ��������4λ��5λ��';
                    result = true;
                }
            }
        } else if (userType == '1'){//�ֻ�
            if (value.substring(0,1) != '6' || 
                    (value.length != 5 && value.length != 6)){
                msg = '�̺ź���Ҫ��6��ͷ����λ��������5λ��6λ��';
                result = true;
            }
        }
        
        if (result){
            rdShowMessageDialog(msg);
            return false;
        }
        
        return true;
    }
    
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
	
	/* add by qidp @ 2009-12-03 for PageNav */
	/* ��һҳ */
	function doPrePage(){
	    var vPageSize = Number($("#page_size").val());
	    var vTotalNum = Number($("#total_num").val());
	    var vStartPos = Number($("#start_pos").val());
	    var vEndPos = Number($("#end_pos").val());
	    var vCurrentPage = Number($("#current_page").val());
	    
	    if(vEndPos == vTotalNum){
	        $("#end_pos").val((vCurrentPage-1)*vPageSize);
	    }else{
	        $("#end_pos").val(vEndPos-vPageSize);
	    }
	    
	    if(vStartPos == "0"){
	        $("#start_pos").val("0");
	    }else{
    	    $("#start_pos").val(vStartPos-vPageSize);
    	}
    	
    	$("#current_page").val(vCurrentPage-1);
    	
	    getPhoneList();
	}
	
	/* ��һҳ */
	function doNextPage(){
	    var vPageSize = Number($("#page_size").val());
	    var vTotalNum = Number($("#total_num").val());
	    var vStartPos = Number($("#start_pos").val());
	    var vEndPos = Number($("#end_pos").val());
	    var vCurrentPage = Number($("#current_page").val());
	    
	    if(vTotalNum < vEndPos+vPageSize){
	        $("#end_pos").val(vTotalNum);
	    }else{
	        $("#end_pos").val(vEndPos+vPageSize);
	    }
	    
	    $("#start_pos").val(vStartPos+vPageSize);
	    
	    $("#current_page").val(vCurrentPage+1);
	    
	    getPhoneList();
	}
	
	/* ��һҳ */
	function doFirstPage(){
        var vPageSize = Number($("#page_size").val());
	    var vTotalNum = Number($("#total_num").val());
	    
	    $("#start_pos").val("0");
	    if(vTotalNum == vPageSize){
	        $("#end_pos").val(vTotalNum);
	    }else{
	        $("#end_pos").val(vPageSize);
	    }
    	$("#current_page").val("1");
    	
	    getPhoneList();
	}
	
	/* ���һҳ */
	function doEndPage(){
	    var vPageSize = Number($("#page_size").val());
	    var vTotalNum = Number($("#total_num").val());
	    
	    $("#end_pos").val(vTotalNum);
	    $("#start_pos").val(Math.floor(vTotalNum/vPageSize)*vPageSize);
	    $("#current_page").val(Math.ceil(vTotalNum/vPageSize));
	    
	    getPhoneList();
	}
	
	/* ת��ĳҳ */
	function gotoPage(){
	    var vPageNo = Number($("#selectGotoPage").val());
	    var vPageSize = Number($("#page_size").val());
	    var vTotalNum = Number($("#total_num").val());
	    var vTotalPage = Math.ceil(vTotalNum/vPageSize);    /* ��ҳ�� */
	    
	    $("#start_pos").val(vPageSize*(vPageNo-1));
	    if(vPageNo == vTotalPage){
	        $("#end_pos").val(vTotalNum);
	    }else{
	        $("#end_pos").val(vPageSize*vPageNo);
	    }
	    $("#current_page").val(vPageNo);
	    
	    getPhoneList();
    }    
	/* end of add */
	function getPhoneList(){
	    var vStartPos = $("#start_pos").val();
	    var vEndPos = $("#end_pos").val();
	    
		var rows=dyntb.rows.length
		for(i=1;i<rows;i++){
			dyntb.deleteRow(1);
		}
		
		if(!forNonNegInt(document.all.sNo) || !forNonNegInt(document.all.lNo)){
			return false;
		}
		var shortNo = document.frm.sNo.value;			
		
		var myPacket = new AJAXPacket("f3214_getPhoneNo.jsp","���ڶ�ȡ���ݣ����Ժ�......");
		var groupNo=document.all.service_no.value.trim();
		myPacket.data.add("retType","phoneNo1");
		myPacket.data.add("groupNo",groupNo);
		myPacket.data.add("sNo",document.all.sNo.value);
		myPacket.data.add("lNo",document.all.lNo.value);
		myPacket.data.add("idNo",document.all.id_no.value);
		myPacket.data.add("offerId",document.all.product_id.value);
		myPacket.data.add("startPos",vStartPos);
		myPacket.data.add("endPos",vEndPos);
		myPacket.data.add("opCode","<%=opCode%>");
		core.ajax.sendPacket(myPacket);
		myPacket=null;
		//delete(myPacket);
	}
	
	function getOtherPhoneList(){
		var rows=dyntb.rows.length;
		for(i=1;i<rows;i++){
			dyntb.deleteRow(1);
		}
		if(document.all.service_no.value==""){
			rdShowMessageDialog("�������뼯�ű�ţ�");
			return false;
		}
		
		if(!forNonNegInt(document.all.sNo) || !forNonNegInt(document.all.lNo)){
			return false;
		}
		
		var myPacket = new AJAXPacket("f3214_getOtherPhoneNo.jsp","���ڶ�ȡ���ݣ����Ժ�......");
		var groupNo=document.all.service_no.value.trim();
		myPacket.data.add("retType","phoneNo1");
		myPacket.data.add("smCode", document.all.sm_code.value);
		myPacket.data.add("idNo",document.all.id_no.value);
		myPacket.data.add("groupNo",groupNo);
		myPacket.data.add("sNo",document.all.sNo.value);
		myPacket.data.add("lNo",document.all.lNo.value);
		core.ajax.sendPacket(myPacket);
		myPacket=null;
	}
	
    /* У�鼯�Ų�Ʒ���� */
    function chkProductPwd(){
        var cust_id = document.all.cust_id.value;
        var Pwd1 = document.all.product_pwd.value;
        var checkPwd_Packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s7896/pubCheckPwd.jsp","���ڽ�������У�飬���Ժ�......");
        checkPwd_Packet.data.add("retType","checkPwd");
    	checkPwd_Packet.data.add("cust_id",cust_id);
    	checkPwd_Packet.data.add("Pwd1",Pwd1);
    	core.ajax.sendPacket(checkPwd_Packet);
    	checkPwd_Packet = null;
    }

    
    /* ��ѡ��������ʱ */
    function chkSingle(){
        $("#single").css("display","block");
        $("#multi").css("display","none");
    }
    
    /* ��ѡ��������ʱ */
    function chkMulti(){
        $("#single").css("display","none");
        $("#multi").css("display","block");
    }
    
    /* vpmn,��ѡ����������ʱ */
    function chgVpNo(){
        $("#vpmnInputType").val("vpmnNo");
        $("#vp_no").css("display","block");
        $("#vp_file").css("display","none");
    }
    
    /* vpmn,��ѡ���ļ�¼��ʱ */
    function chgVpFile(){
        $("#vpmnInputType").val("vpmnFile");
        $("#vp_no").css("display","none");
        $("#vp_file").css("display","block");
    }
    
     /* begin diling add @2012/6/27*/
    /*APNҵ��ĳ�Ա������� , ��ѡ����������ʱ*/
    function chgSingleNo(){
      $("#memberPhoneInputType").val("singleNo");
      $("#single_no").css("display","block");
      $("#input_file").css("display","none");
    }
    
    /*APNҵ��ĳ�Ա������� , ��ѡ���ļ�¼��ʱ*/
    function chgInputFile(){
      $("#memberPhoneInputType").val("inputFile");
      $("#single_no").css("display","none");
      $("#input_file").css("display","block");
    }
    /* end diling add @2012/6/27 */
    
    function chgJ1No(){
        $("#j1InputType").val("j1No");
        $("#j1_no").css("display","block");
        $("#j1_file").css("display","none");
    }
    
    function chgJ1File(){
        $("#j1InputType").val("j1File");
        $("#j1_no").css("display","none");
        $("#j1_file").css("display","block");
    }
    
	function changePayType(){
		if (document.all.checkPayTR.style.display=="none"){
			document.all.checkPayTR.style.display="";
		}
		else {
			document.all.checkPayTR.style.display="none";
		}
	}
    /* ��� */
    function resetJsp(){
        //document.all.frm.reset();
        window.location='f7896_1.jsp';
    }
    
    /* ��һ�� */
    function nextStep(){
    		var vSmCode = $("#sm_code").val();
    		if(vSmCode == "vp"){
    			var flag4A = allCheck4A("<%=opCode%>");
					if(!flag4A){
						return false;
					}
    		}
    		
    		
    		
      	
    		
        if(!check(document.all.frm)){return false}
        /*diling update for ��ǰBOSSϵ7896ģ����APN��Ա���Բ�����ʽ������
        if((document.all.sm_code.value) != "vp" &&(document.all.sm_code.value) != "np" && document.all.sm_code.value != "j1" && $("#single_phoneno").val() == ""){//wanghfa����?2010-12-7 15:38 �����ܻ�����BOSSϵͳ����
            rdShowMessageDialog("��ѡ���Ա�û��ֻ�����!",0);
            $("#selectNo").focus();
            return false;
        }*/
        
        if($("#sm_code").val() == "vp" && $("#request_type").val() == ""){
            rdShowMessageDialog("��ѡ�����ѡ��!");
            document.all.request_type.focus();
            return false;
        } else if ($("#sm_code").val() == "j1" && $("#j1_request_type").val() == "") {	//wanghfa����?2010-12-7 15:38 �����ܻ�����BOSSϵͳ����
            rdShowMessageDialog("��ѡ�����ѡ��!");
            document.all.j1_request_type.focus();
            return false;
        }
        
        
        
      	var cfm_phoneNo = "";
    	  var phoneNoText = $("#textarea_batch").text().trim();
				var phoneNo_arr = phoneNoText.split("|");

    		for(var i=0;i<phoneNo_arr.length;i++){
					phoneNo_temp = phoneNo_arr[i].trim();
			
					if(phoneNo_temp!=""){
						cfm_phoneNo = cfm_phoneNo + phoneNo_temp +"|";
					}
				}
				
				
				if($("input[name='mm_chg_type']:checked").val()=="1"){
				}else{
					if(!check_bath_phoneNo()){
	      		return false;
	      	}
				}
				
				
				$("#cfmPnoneNo").val(cfm_phoneNo);
				
        frm.action="f7896_1.jsp?action=next";
        frm.method="post";
        frm.submit();
    }
    
    /* ��һ�� */
    function previouStep(){
        frm.action="f7896_1.jsp";
    	frm.method="post";
    	frm.submit();
    }
    
    /* ����ύ */
    function refMain(){
    	
    	//alert("sm_code = "+$("#sm_code").val()+"\n"+"mm_phoneType = "+$("#mm_phoneType").val());
    	
    /*    if(!check(document.all.frm)){
            return false
        }
      */  
      
      			/*2016/8/24 14:26:34 gaopeng ��ͬ��Ч��
							�������ԣ���ͬ��Ч�ڣ��ı���¼�룬��ʽYYYYMM���ж����ٴ��ڵ�������
							*/
							if(typeof($('#F87004'))!="undefined"&&typeof($('#F87004').val())!="undefined"){
								$('#F87004').attr("v_type","date.year_month");
								if($('#F87004').val().trim()==""){
										rdShowMessageDialog("��ͬ��Ч�ڲ���Ϊ��!",0);
										$('#F87004').focus();
								    return false;	
								}
								if(!checkElement(document.frm.F87004)){ 
											return false;
								}
								var nowTimeMo = $.trim($('#F87004').val());
								if(Number(nowTimeMo) < Number("<%=addMonthTStr%>")){
									rdShowMessageDialog("��ͬ��Ч���������¸���[<%=addMonthTStr%>]��");
									$('#F87004').focus();
									return false;
								}
								
							}
      
      if ($("#sm_code").val() == "RH" && document.all.busiFlag.value == '186'){//�ں�v��У��
          if (!validatePhoneHeader()){
              return;
          }
          /* 
        	 * begin �����ں�ͨ�������ƶ��̻�ҵ�������@2014/7/14  
        	 */
          if($("select[name='F70050']").val() == "0" && $("select[name='F70052']").val() == "2"){ 
          	$("input[name='F70051']").attr("v_must","1");
        		$("input[name='F70051']").attr("v_type","mobphone");
            if(!checkElement(document.all.F70051)) return false;
          }
          /* 
        	 * end �����ں�ͨ�������ƶ��̻�ҵ�������@2014/7/14  
        	 */
      }
      
      
        var ind1Str ="";
        var ind2Str ="";
        var ind3Str ="";
        
        var ind1Str2 ="";
        var ind2Str2 ="";
        /* vpmnʱ,ƴд���� */
        //liujian 2013-1-21 10:11:16 ����m10�ж�
        if(($("#sm_code").val() == "vp" || $("#sm_code").val() == "j1") && ($("#request_type").val() == "m02" || $("#request_type").val() == "m10")){
            if($("#vpmnInputType").val() == 'vpmnFile'){
                if($("#vpmnPosFile").val() == ""){    //�ļ�¼��
                    rdShowMessageDialog("��ѡ���ļ���",0);
                    $("#vpmnPosFile").focus();
                    return false;
                }
            } else if ($("#j1InputType").val() == 'j1File') {	//wanghfa�޸� j1����BOSS
                if($("#j1PosFile").val() == ""){    //�ļ�¼��
                    rdShowMessageDialog("��ѡ���ļ���",0);
                    $("#j1PosFile").focus();
                    return false;
                }
            } else {
    			var a=0;
    			if( document.all.R0.length == undefined){
    				if( document.all.R0.checked == false){
    					rdShowMessageDialog("����ѡ���ų�Ա!!");
    					return false;
    				}else{
    						ind1Str =ind1Str +document.all.R1.value+"|";
    						ind2Str =ind2Str +document.all.R2.value+"|";
    						if ($("#sm_code").val() == "vp") {
	    						ind3Str =ind3Str +document.all.R3.value+"|";
    						}
    				}
    				a+=1;
    			}
    			else{
    				for (var i = 0; i < document.all.R0.length; i ++) {
    					if( document.all.R0[i].checked == true){
    						a+=1;
    						ind1Str =ind1Str +document.all.R1[i].value+"|";
    						ind2Str =ind2Str +document.all.R2[i].value+"|";
    						if ($("#sm_code").val() == "vp") {
	    						ind3Str =ind3Str +document.all.R3[i].value+"|";
    						}
    					}
    				}
    				if(a==0){
    					rdShowMessageDialog("����ѡ���ų�Ա!!");
    					return false;
    				}
    			}
                
                //2.��form�������ֶθ�ֵ
                
                document.all.tmpR1.value = ind1Str;
                document.all.tmpR2.value = ind2Str;
				if ($("#sm_code").val() == "vp") {
					document.all.tmpR3.value = ind3Str;
				}
                
                
                 //wangzn 091205 Begin
            if(document.all.limitcount.value=="1"&&document.all.F80004.value=="0")
					  {
							rdShowMessageDialog("�ü������ʷѲ���ʹ�ã���Ϊ���ų�Աѡ������ײ��ʷ�!");
			        return false;
					  }
            //wangzn 091205 End
                
            }
        }else if (($("#sm_code").val() == "vp" && $("#request_type").val() == "m05") || ($("#sm_code").val() == "j1" && $("#j1_request_type").val() == "m07")){
            if( dyntb2.rows.length == 2){//������û������
                rdShowMessageDialog("û��ָ����Ա���룬����������!",0);
                return false;
            }else{
                for(var a=1; a<document.all.R20.length ;a++)//ɾ����tr1��ʼ��Ϊ������
                {
                	if ($("#sm_code").val() == "vp") {
						ind1Str2 =ind1Str2 +document.all.R21[a].value+"|"+document.all.R22[a].value+"&";
                	} else if ($("#sm_code").val() == "j1") {
	                    ind1Str2 =ind1Str2 +document.all.R21[a].value+"|"+document.all.R22[a].value+"|"+document.all.R23[a].value+"|"+document.all.R24[a].value+"|&";
                	}
                }
            }
            document.all.tmpR21.value = ind1Str2;
        }else if($("#sm_code").val() == "np"){
            if($("#cycleMoney").val() == ""){
                rdShowMessageDialog("�������Ϊ�գ�",0);
                $("#cycleMoney").focus();
                return false;
            }
            
            if($("#beginDate").val() == ""){
                rdShowMessageDialog("��ʼʱ�䲻��Ϊ�գ�",0);
                $("#beginDate").focus();
                return false;
            }
            
            if($("#endDate").val() == ""){
                rdShowMessageDialog("����ʱ�䲻��Ϊ�գ�",0);
                $("#endDate").focus();
                return false;
            }
            
            if(!forDate($("#beginDate"))){
                rdShowMessageDialog("��ʼʱ���ʽ���ԣ�",0);
                $("#beginDate").focus();
                return false;
            }
            
            if(!forDate($("#endDate"))){
                rdShowMessageDialog("����ʱ���ʽ���ԣ�",0);
                $("#endDate").focus();
                return false;
            }
            
            var vInputType = $("#input_type").val();
            if(document.all.input_type[0].checked){         //����¼��
                if($("#single_phoneno1").val() == ""){
                    rdShowMessageDialog("��Ա�û��ֻ����벻��Ϊ�գ�",0);
                    $("#single_phoneno1").focus();
                    return false;
                }else{
                    
                }
            }else{    //����¼��
                if($("#multi_phoneNo").val() == ""){
                    rdShowMessageDialog("���벻��Ϊ�գ�",0);
                    $("#multi_phoneNo").focus();
                    return false;
                }
            }
        }else{
          if((document.all.sm_code.value) != "vp" &&(document.all.sm_code.value) != "np" && document.all.sm_code.value != "j1" ){//wanghfa����?2010-12-7 15:38 �����ܻ�����BOSSϵͳ����
            if($("#memberPhoneInputType").val() == 'inputFile'){ //�ļ�¼��
                if($("#memberPosFile").val() == ""){    //�ļ�¼��
                    rdShowMessageDialog("��ѡ���ļ���",0);
                    $("#memberPosFile").focus();
                    return false;
                }
            }else{ //����¼��
            	if($("#mm_phoneType").val()=="2"||$("#mm_phoneType").val()=="3"){
            		
            	}else{
	              if($("#single_phoneno").val() == ""){
	                rdShowMessageDialog("��ѡ���Ա�û��ֻ�����!",0);
	                $("#selectNo").focus();
	                return false;
	              }
            	}
            }
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
        }
        $("#opNote").val("����Ա<%=workNo%>���м��ų�Ա���Ա��������");
        
        showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes");
        
        var confirmFlag=0;
		confirmFlag = rdShowConfirmDialog("�Ƿ��ύ���β�����");
		if (confirmFlag==1) {
		    //if($("#sm_code").val() != "vp"){
		    <% if((!"m05".equals(iRequestType) && !"m07".equals(iRequestType)) && paramsOut28.length>0){ %>
    			spellList();
    		<% } %>
    		//}
    		$("#sure").attr("disabled",true);
    		if($("#vpmnInputType").val() == 'vpmnFile' || $("#j1InputType").val() == 'j1File' || $('#memberPhoneInputType').val()=='inputFile'){
        		document.frm.target="_self";
    		    document.frm.encoding="application/x-www-form-urlencoded";
    		}
    		
    		
    		if($("#mm_phoneType").val()=="2"){
    			  $("#mm_cfm_param_30").val("81047");
		    		$("#mm_cfm_param_31").val($("#mm_bath_F81047").val());
		    		$("#mm_cfm_param_32").val("0");
		    		
		    		$("#mm_phoneNoList").val($("#textarea_batch").text().trim());
    		}
    		
    		if($("#mm_phoneType").val()=="3"){
    			  $("#mm_cfm_param_30").val("81014");
		    		$("#mm_cfm_param_31").val($("#mm_bath_F81014").val());
		    		$("#mm_cfm_param_32").val("0");
		    		
		    		$("#mm_phoneNoList").val($("#textarea_batch").text().trim());
    		}
    		
    		
				frm.action="f7896_2.jsp";
    		frm.method="post";
    		frm.submit();
    		$("#sure").attr("disabled",true);
    		loading();
		}
    }
    
	//��ӡ��Ϣ
	function printInfo(printType)
	{ 
		var retInfo = "";
		var tmpOpCode= "<%=opCode%>";
		
		retInfo+='<%=workName%>'+"|";
    	retInfo+='<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
    	retInfo+="֤������:"+document.frm.iccid.value+"|";
    	retInfo+="�û�����:"+document.frm.grp_name.value+"|";
    	retInfo+="���Ų�Ʒ����:"+document.frm.product_name.value+"|";
    	retInfo+=""+"|";
        retInfo+=""+"|";
        retInfo+=""+"|";
        retInfo+=""+"|";
        retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";  
    	retInfo+="ҵ�����ͣ����ų�Ա���Ա��"+"|";
    	retInfo+="��ˮ��"+document.frm.sys_accept.value+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=document.frm.opNote.value+"|";
    	retInfo+=""+"|";
		return retInfo;
		
	}
    
    function showPrtDlg(printType,DlgMessage,submitCfm){
        var h=200;
		var w=352;
		var t=screen.availHeight/2-h/2;
		var l=screen.availWidth/2-w/2;
		var printStr = printInfo(printType);
		if(printStr == "failed")
		{
			return false;
		}
		var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no"
		var path = "<%=request.getContextPath()%>/npage/innet/hljPrint.jsp?DlgMsg=" + DlgMessage;
		var path = path + "&printInfo=" + printStr + "&submitCfm=" + submitCfm;
		var ret=window.showModalDialog(path,"",prop);
    }
    
    /* ��txt�ļ�¼���ֻ����� */
    function checkPhNo(){
        fso = new ActiveXObject("Scripting.FileSystemObject");
        var ForReading =1,f2;
        f2 = fso.OpenTextFile(document.all.PosFile.value,ForReading);
        var temps = f2.ReadAll();
        document.all.multi_phoneNo.value=temps;
        
        var phnoNoArr = temps.split("|");
        
        for(var i=0;i<phnoNoArr.length-1;i++){
            if(phnoNoArr[i].replace(/\s/g,'').length!=11){
                rdShowMessageDialog("�绰����Ӧ��Ϊ11λ"+phnoNoArr[i]);
            }
            for(var j=i+1;j<phnoNoArr.length-1;j++){
                if(phnoNoArr[i].replace(/\s/g,'')==phnoNoArr[j].replace(/\s/g,'')){
                    rdShowMessageDialog("�绰�����ظ�"+phnoNoArr[j]);
                }
            }
        }
        resetfilp();
    }
    
    function resetfilp(){
        document.getElementById("PosFile").outerHTML = document.getElementById("PosFile").outerHTML;
    }
    
    function doProcess(packet)
    {
        var retType = packet.data.findValueByName("retType");
        var retCode = packet.data.findValueByName("retCode");
        var retMessage=packet.data.findValueByName("retMessage");
        
        verifyType = packet.data.findValueByName("verifyType");
        error_code = packet.data.findValueByName("errorCode");
        error_msg =  packet.data.findValueByName("errorMsg");
		var backArrMsg = packet.data.findValueByName("backArrMsg");
		var backArrMsg1 = packet.data.findValueByName("backArrMsg1");
		var backArrMsg2=packet.data.findValueByName("backArrMsg2");
        
        self.status="";
        if(retType == "checkPwd") //���ſͻ�����У��
        {
            if(retCode == "000000")
            {
                var retResult = packet.data.findValueByName("retResult");
                if (retResult == "false") {
                    rdShowMessageDialog("�ͻ�����У��ʧ�ܣ����������룡",0);
                    frm.product_pwd.value = "";
                    frm.product_pwd.focus();
                    return false;	        	
                } else {
                    rdShowMessageDialog("�ͻ�����У��ɹ���",2);
                    if(<%=nextFlag%>==1){
                        $("#next").attr("disabled",false);
                    }
                }
            }
            else
            {
                rdShowMessageDialog("�ͻ�����У�������������У�飡",0);
                return false;
            }
        }
        else if(retType=="phoneNo1"){
            
			if(parseInt(error_code) == 0){
				var short_no = packet.data.findValueByName("short_no");
				var phone_no = packet.data.findValueByName("phone_no");
				var cust_name = packet.data.findValueByName("cust_name");
				var id_iccid = packet.data.findValueByName("id_iccid");
				var run_code = packet.data.findValueByName("run_code");
				var curpkgtype = packet.data.findValueByName("curpkgtype");
				var pkg_name = packet.data.findValueByName("pkg_name");
				var num = packet.data.findValueByName("num");
				if(num==0){
					rdShowMessageDialog("û���ҵ����ų�Ա��Ϣ��");
					return;
				}
                /* add by qidp */
                var vTotalNum = Number(packet.data.findValueByName("totalNum"));
                $("#total_num").val(vTotalNum);
                
                var vPageSize = Number($("#page_size").val());
        	    var vStartPos = Number($("#start_pos").val());
        	    var vEndPos = Number($("#end_pos").val());
        	    var vCurrentPage = Number($("#current_page").val());
        	    var vTotalPage = Math.ceil(vTotalNum/vPageSize);
                
                if(vTotalNum <= vPageSize){
                    $("#prePageNav").html("��һҳ");
                    $("#nextPageNav").html("��һҳ");
                    $("#tbPageNav").css("display","none");
                }else{
                    $("#prePageNav").html("<a id='prePage' href='#' onClick='doPrePage();'>��һҳ</a>");
                    $("#nextPageNav").html("<a id='nextPage' href='#' onClick='doNextPage();'>��һҳ</a>");
                    $("#tbPageNav").css("display","none"); //modify by qidp @ 2009-12-03 for ���η�ҳ.
                }
                
                $("#totalPageNav").html(vTotalPage);
                $("#totalNumNav").html(vTotalNum);
                $("#currentPageNav").html(vCurrentPage);
                $("#pageSizeNav").html(vPageSize);
                
                var selectStr = "<select id='selectGotoPage' name='selectGotoPage' onChange='gotoPage();'>";
                for(var i=1;i<vTotalPage+1;i++){
                    selectStr += "<option value='"+i+"' ";
                    if(i == vCurrentPage){
                        selectStr += " selected ";
                    }
                    selectStr += " >"+i+"</option>";
                }
                selectStr += "</select>";
                $("#spGotoPage").html(selectStr);
                
                if(vEndPos == vTotalNum){
                    $("#nextPageNav").html("��һҳ");
                    $("#endPageNav").html("���һҳ");
                }else{
                    $("#nextPageNav").html("<a id='nextPage' href='#' onClick='doNextPage();'>��һҳ</a>");
                    $("#endPageNav").html("<span id='endPageNav'><a id='endPage' href='#' onClick='doEndPage();'>���һҳ</a></span>");
                }
                
                if(vStartPos == "0"){
                    $("#prePageNav").html("��һҳ");
                    $("#firstPageNav").html("��һҳ");
                }else{
                    $("#prePageNav").html("<a id='prePage' href='#' onClick='doPrePage();'>��һҳ</a>");
                    $("#firstPageNav").html("<span id='firstPageNav'><a id='firstPage' href='#' onClick='doFirstPage();'>��һҳ</a></span>");
                }
                /* end of add by qidp */
                
				for(i=0;i<num;i++){
					if (document.getElementById("sm_code").value == "j1") {
						j1QueryAddAllRow(short_no[i], phone_no[i]);
					} else {
				  		queryAddAllRow(0,short_no[i],phone_no[i],cust_name[i],id_iccid[i],run_code[i],curpkgtype[i],pkg_name[i]);
				  	}
				}
			}else{
				rdShowMessageDialog("ȡ��Ϣ����:"+error_msg+"!",0);
				return;			
			}
		}
		else if(retType=="phoneno"){

			if( parseInt(error_code) == 0 ){

				var num = backArrMsg[0][0];
				if( parseInt(num) == 0 ){
					rdShowMessageDialog("�����ڴ��ֻ�����������û�!!",0);
					document.frm.newNo.select();
					document.frm.newNo.focus();
					return false;
				}else{
					dynAddRow();
				}

			}else{
				rdShowMessageDialog("������룺"+error_code+"������Ϣ��"+error_msg,0);
				return false;
			}

		}
		else if(retType == "getCheckInfo")
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
    	else if(retType =="phonenoMobile"){
        	if( parseInt(error_code) == 0 ){
        		document.all.mobile_phone.value=backArrMsg;
        	}
        	else{
                rdShowMessageDialog("������룺"+error_code+"</br>������Ϣ��"+error_msg+"!",0);
                return false;
            }
        }
        else{
            rdShowMessageDialog("������룺"+error_code+"������Ϣ��"+error_msg+"",0);
            return false;
        }


	
        
    }
    
    function getInfo_UserType()
    {
        var pageTitle = "�û�����ѡ��";
        var fieldName = "�û����ʹ���|��������|";
    		var sqlStr = "";
        var selType = "S";    //'S'��ѡ��'M'��ѡ
        var retQuence = "1|0|";
        var retToField = "userType|";
    
        //�����ж��Ƿ��Ѿ�ѡ���˷���Ʒ��
        if(document.frm.sm_code.value == "")
        {
            rdShowMessageDialog("������ѡ�����Ʒ�ƣ�");
            return false;
        }
        
        if(PubSimpSelUserType(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));
    }
    
    function PubSimpSelUserType(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
    { 
        var path = "fpubusertype_sel.jsp";
        path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
        path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
        path = path + "&selType=" + selType;
        path = path + "&groupFlag=N";
        path = path + "&grpProductCode=" + document.all.grpProductCode.value;
    	path = path + "&op_code=" + document.all.op_code.value;
    	path = path + "&sm_code=" + document.all.sm_code.value;
    
        retInfo = window.open(path,"newwindow","height=450, width=800,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
    
    	return true;
    }

    function getvalueUserType(retValue){
        var returnArr = retValue.split("|");
        document.all.user_type.value=returnArr[0];
        document.all.user_type_name.value=returnArr[1];
    }
    
    function getAdditiveBill()
    {
        var modeCode = document.frm.modeCode.value;
        var addMode = document.frm.add_product.value;
        var path = "pubAdditiveBill_7896.jsp";
        path = path + "?pageTitle=" + "��ѡ�ʷ�ѡ��";
        path = path + "&orgCode=" + "<%=orgCode%>";
        path = path + "&smCode="+document.all.sm_code.value;
        path = path + "&modeCode=" + modeCode;
        path = path + "&existModeCode=" + addMode;
        path = path + "&userType=" + document.frm.user_type.value;
        
        var retInfo = window.showModalDialog(path,"","dialogWidth:45;dialogHeight:30;");
        if(typeof(retInfo) == "undefined")     
        {   return false;   }
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
    
    function changeType()
    {
    	if ($("#sm_code").val() == "j1") {
	    	document.all.request_type1.value=document.all.j1_request_type.value;
    	} else {
    		document.all.request_type1.value=document.all.request_type.value;
    	}
    }
    function chkVpmnNo2(){
        var vServiceNo = $("#service_no").val();
        var vIdNo = $("#id_no").val();
        var vShortNo = $("#newNo").val();
        var updateNoType = document.all.updateNoType.value;
        
    }
      function check_nomobile_phone(updateNoType)
    {
        var sqlBuf="";
        var myPacket = new AJAXPacket("CallCommONESQL.jsp","������֤�û����룬���Ժ�......");
        if(!checkElement(document.all.newNo)) return false;
        if(!checkElement(document.all.oldNo)) return false;
        /*if(updateNoType=='10')
        {
        	sqlBuf="select count(*) from dbresadm.sNoType where trim(no)=substr('"+document.all.oldNo.value +"',1,3) ";
        }*/
        myPacket.data.add("verifyType","phonenoMobile");
        myPacket.data.add("sqlBuf",sqlBuf);
        myPacket.data.add("recv_number",1);
		myPacket.data.add("updateNoType",updateNoType);
		myPacket.data.add("j1PhoneNo","");
		myPacket.data.add("oldNo",document.all.oldNo.value);
		myPacket.data.add("newNo","");
        core.ajax.sendPacket(myPacket);
        myPacket=null;
    }
    
    
    function chkVpmnNo(){
        var vServiceNo = $("#service_no").val();
        var vIdNo = $("#id_no").val();
        var vProductId = $("#product_id").val();
        var vRealNo = $("#oldNo").val();
        var vShortNo = $("#newNo").val();
        var tdt1innre = document.getElementById("tdt1").innerText
        var tdt2innre = document.getElementById("tdt2").innerText;
        var updateNoType = document.all.updateNoType.value;
        //alert('['+updateNoType+']');
        //alert('['+tdt1innre+']['+tdt2innre+']');
        if(vRealNo == ""){
            rdShowMessageDialog(tdt1innre+"����Ϊ�գ�");
            $("#oldNo").focus();
            return false;
        }
        
        if(vShortNo == ""){
            rdShowMessageDialog("������"+tdt2innre+"��");
            $("#newNo").focus();
            return false;
        }
        
        //wuxy add 20100331���Ӷ̺����� 
        if(!checkElement(document.all.newNo)) return false;
        if(updateNoType=='10'||updateNoType=='00'){
        	if(updateNoType=='10'){
        		check_nomobile_phone(updateNoType);
        	}
        	var mobile_phone=document.all.mobile_phone.value;
        	if((mobile_phone.substr(0,1)==0&&updateNoType=='10'))
        	{
        		if(vShortNo.substr(0,1) == 7)
        		{
        			if(vShortNo.length > 8 || vShortNo.length < 3){
             	    rdShowMessageDialog("7��ͷ�Ķ̺ų��ȱ�����3-8λ!!");
             	    $("#newNo").val("");
             	    $("#newNo").focus();
             	    return false;	  			
             	    }
        		}
        		else
        		{
        			if(vShortNo.substr(0,1) != 6){
             	    rdShowMessageDialog("�̺��������6��7��ͷ!");
             	    $("#newNo").val("");
             	    $("#newNo").focus();
             	    return false;
             	    }
        			if(vShortNo.substr(1,1) == 0){
             	    rdShowMessageDialog("�̺���ڶ�λ����Ϊ0!");
             	    $("#newNo").val("");
             	    $("#newNo").focus();
             	    return false;
             	    } 
             	    if(vShortNo.length > 6 || vShortNo.length < 4){
             	    rdShowMessageDialog("6��ͷ�Ķ̺ų��ȱ�����4-6λ!!");
             	    $("#newNo").val("");
             	    $("#newNo").focus();
             	    return false;	  			
             	    }
        		}
        	}
        	else
        	{
             	if(vShortNo.length > 6 || vShortNo.length < 4){
             	    rdShowMessageDialog("�̺ų��ȱ�����4-6λ!!");
             	    $("#newNo").val("");
             	    $("#newNo").focus();
             	    return false;	  			
             	} 	
        	<%        	
        	if(operFlag==true) {
        	%>
        	    if(vShortNo.substr(0,1) != 6 && vShortNo.substr(0,1) != 7){        	     
             	    rdShowMessageDialog("�̺��������6����7��ͷ!");
             	    $("#newNo").val("");
             	    $("#newNo").focus();
             	    return false;
             	}
        	 <%}else {%>             	
             	if(vShortNo.substr(0,1) != 6){
             	    rdShowMessageDialog("�̺��������6��ͷ!");
             	    $("#newNo").val("");
             	    $("#newNo").focus();
             	    return false;
             	}
           <%}%>  	
             	if(vShortNo.substr(1,1) == 0){
             	    rdShowMessageDialog("�̺���ڶ�λ����Ϊ0!");
             	    $("#newNo").val("");
             	    $("#newNo").focus();
             	    return false;
             	} 
         	}
        }
        
        var packet = new AJAXPacket("pubCheckVpmnNo.jsp","���Ժ�...");
        packet.data.add("serviceNo",vServiceNo);
        packet.data.add("idNo" ,vIdNo);
        packet.data.add("productId" ,vProductId);
        packet.data.add("realNo" ,vRealNo);
        packet.data.add("shortNo",vShortNo);
        packet.data.add("updateNoType",updateNoType);
        core.ajax.sendPacket(packet,doChkVpmnNo,true);
        packet =null;
    }

    function doChkVpmnNo(packet){
        var retCode = packet.data.findValueByName("retCode"); 
        var retMsg = packet.data.findValueByName("retMsg"); 
        
        if(retCode == "000000"){
            rdShowMessageDialog("У��ɹ���",2);
            $("#addCondConfirm").attr("disabled",false);
        }else{
            var vNoType = packet.data.findValueByName("noType");       /*��������:0-��ʵ����;1-�̺�;2-�ɹ�.*/
            rdShowMessageDialog("�������:"+retCode+"</br>������Ϣ:"+retMsg,0);
            $("#addCondConfirm").attr("disabled",true);
            
            if(vNoType == '0'){ // ��ʵ����У�鲻ͨ��
                $("#oldNo").val("");
                $("#oldNo").focus();
            }else if(vNoType == '1'){ // �̺�У�鲻ͨ��
                $("#newNo").val("");
                $("#newNo").focus();
            }else{
                // У��ͨ��
            }
        }
    }
    
    function j1QryMember(qryType) {	//wanghfa���� 2010-12-9 17:29 �����ܻ�����BOSS
	    var pageTitle = "���ų�Ա��ѯ";
	    var fieldName = "�ֻ�����|��ʵ����|��Ա����|��Ա����ƴ������ĸ|";
		var sqlStr ="";
		var selType = "S";    //'S'��ѡ��'M'��ѡ
		var retQuence = "4|0|1|2|3";
		var retToField;
		var chooseRet;
		
		if(qryType == "0"){	//�ֻ�������
			retToField = "oldNo|j1PhoneNo|j1UserName|j1ShortName|";
			chooseRet = PubSimpSel_self(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
		} else if(qryType == "1") {	//�ֻ�������
			retToField = "oldNo|j1PhoneNo|j1UserName|j1ShortName|";
			
			sqlStr = "90000019";
			var params = document.frm.id_no.value + "|" + (document.frm.oldNo.value).trim() + "|";
			chooseRet = PubSimpSel_self2(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,params);
		} else if(qryType == "2") {	//��ʵ��������
			retToField = "j1No|oldNo|j1UserName|j1ShortName|";
			chooseRet = PubSimpSel_self(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
			
		} else if(qryType == "3") {	//��ʵ��������
			retToField = "j1No|oldNo|j1UserName|j1ShortName|";
			
			sqlStr = "90000020";
			var params = document.frm.id_no.value + "|" + encodeURI("%" + (document.frm.oldNo.value).trim()) + "|";
			chooseRet = PubSimpSel_self2(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,params);
		}
		
		if (chooseRet != false) {
			document.getElementById("j1No").className = "";
			//document.getElementById("j1PhoneNo").className = "InputGrey";
			document.getElementById("j1UserName").className = "";
			document.getElementById("j1ShortName").className = "";
			
			document.getElementById("j1No").readOnly = false;
			//document.getElementById("j1PhoneNo").readOnly = true;
			document.getElementById("j1UserName").readOnly = false;
			document.getElementById("j1ShortName").readOnly = false;
			$("#addCondConfirm").attr("disabled", false);
		} else {
			$("#addCondConfirm").attr("disabled", true);
		}
/*
		if (qryType == "0") {
			if (updateNoType == "00") {
				document.frm.oldNo.value = document.all.tmpAddShortNo.value;
			} else {
				document.frm.oldNo.value = document.all.tmpAddRealNo.value;
			}
		} else {//�޸ĺ����
		    if((update_no_type == "00") || (update_no_type == "10")) {
				document.frm.newNo.value = document.all.tmpAddShortNo.value;
			} else	{
				document.frm.newNo.value = document.all.tmpAddRealNo.value;
			}
		}
*/
    }

	function call_NoQry(call_type)
	{
		document.all.tmpAddShortNo.value="";
		document.all.tmpAddRealNo.value="";
		//alert(call_type);
	    var pageTitle = "���ų�Ա�����ѯ";
	    var fieldName = "�̺�|��ʵ����|���ź�|";
		var sqlStr ="";
		var update_no_type = document.frm.updateNoType[document.frm.updateNoType.selectedIndex].value;


		 if( document.frm.service_no.value == "" )
		 {
		  	rdShowMessageDialog("�����뼯�ź�!!");
		  	return false;
		 }
		if(!checkElement(document.all.service_no)) return false;
		
		/*lilm���ӶԶ̺ŵ�У�� �̺�Ӧ�жϱ�����6��ͷ���ҵڶ�λ����Ϊ0��λ����4-6λ */
		if(call_type == '1'){
    		if(!checkElement(document.all.newNo)) return false;
    		var shortNo = document.frm.newNo.value;			
    		
    		if(shortNo.length > 6 || shortNo.length < 4){
    		  	rdShowMessageDialog("�̺ų��ȱ�����4-6λ!!");
    		  	return false;	  			
    		}
    		
    	   <%
        	if(operFlag==true) {
        	%>
        	if(shortNo.substr(0,1) !=6 && shortNo.substr(0,1) !=7)
    	   	{
    	   		rdShowMessageDialog("�̺��������6����7��ͷ!");
    	   		return false;
    	   	}
        	<%}else {%> 
    	    if(shortNo.substr(0,1) !=6)
    	   	{
    	   		rdShowMessageDialog("�̺��������6��ͷ!");
    	   		return false;
    	   	}
    	   	<%}%> 
    	   	
    	   	if(shortNo.substr(1,1) ==0)
    	   	{
    	   		rdShowMessageDialog("�̺���ڶ�λ����Ϊ0!");
    	   		return false;
    	   	} 
    	}
//		sqlStr = "select short_no, phone_no, group_no from dvpmnusrmsg "+
//				 "where group_no = '" + document.frm.service_no.value + "'";
//				 
//		
//		if( call_type == "0" ){//���޸ĺ���
//		  if((update_no_type == "00") || (update_no_type == "01")) {
//				sqlStr =  sqlStr + " and short_no like '" + encodeURI("%" + (document.frm.oldNo.value).trim()) + "%'" ;
//			} else	{
//				sqlStr =  sqlStr + " and phone_no like '" + encodeURI("%" + (document.frm.oldNo.value).trim()) + "%'" ;
//			}
//		}	else {//�޸ĺ����
//		  if((update_no_type == "00") || (update_no_type == "10")) {
//				sqlStr =  sqlStr + " and short_no like '" + encodeURI("%" + (document.frm.newNo.value).trim()) + "%'" ;
//			} else {
//				sqlStr =  sqlStr + " and phone_no like '" + encodeURI("%" + (document.frm.newNo.value).trim()) + "%'" ;
//			}
//		}
//
//	  sqlStr = sqlStr + " order by short_no " ;

		/*sqlStr ="   select short_num,ACC_NBR,'" + document.frm.service_no.value + "' from group_instance_member a ,product_offer_instance b where b.serv_id='" + document.frm.id_no.value + "' and  b.offer_id='" + document.frm.product_id.value + "' and a.group_id =b.group_id " ;		 
		
		if( call_type == "0" ){//���޸ĺ���
		  if((update_no_type == "00") || (update_no_type == "01")) {
				sqlStr =  sqlStr + " and short_num like '" + encodeURI("%" + (document.frm.oldNo.value).trim()) + "%'" ;
			} else	{
				sqlStr =  sqlStr + " and ACC_NBR like '" + encodeURI("%" + (document.frm.oldNo.value).trim()) + "%'" ;
			}
		}	else {//�޸ĺ����
		  if((update_no_type == "00") || (update_no_type == "10")) {
				sqlStr =  sqlStr + " and short_num like '" + encodeURI("%" + (document.frm.newNo.value).trim()) + "%'" ;
			} else {
				sqlStr =  sqlStr + " and ACC_NBR like '" + encodeURI("%" + (document.frm.newNo.value).trim()) + "%'" ;
			}
		}

	  sqlStr = sqlStr + " order by short_num " ;*/



	  //alert(sqlStr);

	  var selType = "S";    //'S'��ѡ��'M'��ѡ
	  var retQuence = "3|0|1|2|";
	  var retToField = "tmpAddShortNo|tmpAddRealNo|service_no|";
	  PubSimpSel_self(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);

		if (call_type == "0") {//���޸ĺ���
		  if ((update_no_type == "00") || (update_no_type == "01")) {
				document.frm.oldNo.value = document.all.tmpAddShortNo.value;
			} else {
				document.frm.oldNo.value = document.all.tmpAddRealNo.value;
			}
		} else {//�޸ĺ����
		    if((update_no_type == "00") || (update_no_type == "10")) {
				document.frm.newNo.value = document.all.tmpAddShortNo.value;
			} else	{
				document.frm.newNo.value = document.all.tmpAddRealNo.value;
			}
		}
	}

	function PubSimpSel_self(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
	{
        var vGrpId = document.frm.id_no.value;
        var vRegionCode = "<%=regionCode%>";
        var vGroupNo = document.frm.service_no.value;
        var vUpdateNoType = document.frm.updateNoType[document.frm.updateNoType.selectedIndex].value;
        var vOfferId = document.frm.product_id.value;
        var vOldNo = document.frm.oldNo.value;
        var vSmCode = document.getElementById("sm_code").value;	//wanghfa����
        var vopCode = "<%=opCode%>"; //wuxy ��ȫ�ӹ�
        //vUpdateNoType='10';//��Ҫ�ķ��������²�ƷҪ���ߣ����ڲ������
		 
		var update_no_type = document.frm.updateNoType[document.frm.updateNoType.selectedIndex].value;
		var call_type = "0";
		var service_no = $("#service_no").val();
		var  id_no = $("#id_no").val();;
		var  product_id = $("#product_id").val();
		var  oldNo = $("#oldNo").val();
		var  newNo = $("#newNo").val();
		
	    var path = "<%=request.getContextPath()%>/npage/s7896/sShortNoSel.jsp";
	    //var path = "../public/fPubSimpSel.jsp";
	    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
	    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
	    path = path + "&selType=" + selType;
	    path = path + "&grpId=" + vGrpId;
	    path = path + "&regionCode=" + vRegionCode;
	    path = path + "&groupNo=" + vGroupNo;
	    path = path + "&updateNoType=" + vUpdateNoType;
	    path = path + "&offerId=" + vOfferId;
	    path = path + "&oldNo=" + vOldNo;
	    path = path + "&smCode=" + vSmCode;
	    path = path + "&opCode=" + vopCode;
		path = path + "&update_no_type=" + update_no_type + "&call_type=" + call_type;
		path = path + "&service_no="+service_no+"&id_no="+id_no+"&product_id="+product_id+"&oldNo="+oldNo+"&newNo="+newNo;
		
	    retInfo = window.showModalDialog(path);
		if(retInfo == undefined)
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
	
	function j1AddToList() {	//wanghfa���� 2010-12-10 14:01 j1����BOSS
		var updateNoType = document.getElementById("updateNoType").value;
		
		if(!checkElement(document.getElementById("oldNo"))) return false;
		if(!checkElement(document.getElementById("j1No"))) return false;
		if(!checkElement(document.getElementById("j1UserName"))) return false;
		if(!checkElement(document.getElementById("j1ShortName"))) return false;
		
	  	var patrn=/^[a-z]$/;
	  	if(document.getElementById("j1ShortName").value.trim().substring(0,1).search(patrn) == -1){
			rdShowMessageDialog("��Ա����ƴ������ĸ������Сд��ĸ��ʼ��");
			document.getElementById("j1No").focus();
			return;
		}
		
		var updateNoType = document.getElementById("updateNoType").value;
		
		var sqlBuf="";
		var myPacket = new AJAXPacket("CallCommONESQL.jsp","������֤�û����룬���Ժ�......");
		/*if (updateNoType == "00") {
			sqlBuf = "select count(*) from dbresadm.sNoType where trim(no)=substr('"+document.all.j1PhoneNo.value +"',1,3) ";
		} else if (updateNoType == "10") {
			sqlBuf = "select count(*) from dbresadm.sNoType where trim(no)=substr('"+document.all.oldNo.value +"',1,3) ";
		}*/
		myPacket.data.add("verifyType","phonenoMobile");
		myPacket.data.add("sqlBuf",sqlBuf);
		myPacket.data.add("recv_number",1);
		myPacket.data.add("updateNoType",updateNoType);
		myPacket.data.add("j1PhoneNo",document.all.j1PhoneNo.value);
		myPacket.data.add("oldNo",document.all.oldNo.value);
		myPacket.data.add("newNo","");
		core.ajax.sendPacket(myPacket);
		myPacket=null;
		
		var mobile_phone=document.all.mobile_phone.value;
		if (mobile_phone == "1") {	//����
			var patrn=/^[6][1-9]\d{2,4}$/;
			if(document.getElementById("j1No").value.search(patrn) == -1){
				rdShowMessageDialog("�ƶ���Ӫ�̷ֻ�����Ϊ4-6λ���룬��һλ����Ϊ6���ڶ�λ����Ϊ0�����������룡");
				document.getElementById("j1No").focus();
				return;
			}
		} else if (mobile_phone == "0") {	//����
			var patrn=/^[8]\d{3,5}$/;
			if(document.getElementById("j1No").value.search(patrn) == -1){
				rdShowMessageDialog("������Ӫ�̷ֻ�����Ϊ4-6λ���룬��һλ����Ϊ8�����������룡");
				document.getElementById("j1No").focus();
				return;
			}
		}
		
		var vServiceNo = $("#service_no").val();
		var vIdNo = $("#id_no").val();
		var vProductId = $("#product_id").val();
		var vNo1 = $("#oldNo").val();
		var vNo2 = $("#j1No").val();
		var updateNoType = document.all.updateNoType.value;
		
		var packet = new AJAXPacket("pubCheckVpmnNo.jsp","���Ժ�...");
		packet.data.add("serviceNo",vServiceNo);
		packet.data.add("idNo" ,vIdNo);
		packet.data.add("productId" ,vProductId);
		packet.data.add("realNo" ,vNo1);
		packet.data.add("shortNo",vNo2);
		packet.data.add("updateNoType",updateNoType);
		core.ajax.sendPacket(packet, j1AddResult, true);
		packet = null;
	}
	
	function j1AddResult(packet) {
		var retCode = packet.data.findValueByName("retCode");
		var retMsg = packet.data.findValueByName("retMsg");
		
		if(retCode == "000000"){
			j1DynAddRow();
	        $("#addCondConfirm").attr("disabled", true);
		}else{
			rdShowMessageDialog("�������:"+retCode+"</br>������Ϣ:"+retMsg,0);
	        $("#addCondConfirm").attr("disabled", false);
		}
	}
	
	function j1DynAddRow() {	//wanghfa���� 2010-12-10 14:01 j1����BOSS
		var j1OldNoObj = document.getElementById("oldNo");
		var j1NoObj = document.getElementById("j1No");
		var j1UserNameObj = document.getElementById("j1UserName");
		var j1ShortNameObj = document.getElementById("j1ShortName");
		
        var tr1="";
        var i=0;
        var tmp_flag = true;
        var exec_status="";

		for(var a = document.all.dyntb2.rows.length-2; a > 0; a --) {
			j1OldNo = document.all.R21[a].value;
			j1No = document.all.R22[a].value;
			if (j1OldNoObj.value == j1OldNo || j1NoObj.value == j1No) {
				rdShowMessageDialog("�Ѿ���һ����Ҫ�޸ĵĺ��롱���޸ĺ�ĺ��롱��ͬ�����ݣ��������ӣ�");
				return;
			}
		}
		
        tr1=dyntb2.insertRow();	//ע�⣺����ı������������һ��,������ɿ���.yl.
        tr1.id="tr"+dynTb2Index;
        
        tr1.insertCell().innerHTML = '<div align="center"><input id=R20 type=checkBox size=4 value="ɾ��" onClick="dynDelRow()" ></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R21 type=text   value="'+ j1OldNoObj.value+'" class="InputGrey" readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R22 type=text   value="'+ j1NoObj.value+'" class="InputGrey" readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R23 type=text   value="'+ j1UserNameObj.value+'" class="InputGrey" readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R24 type=text   value="'+ j1ShortNameObj.value+'" class="InputGrey" readonly></input></div>';
        dynTb2Index++;
		j1OldNoObj.value = "";
		j1NoObj.value = "";
		j1UserNameObj.value = "";
		j1ShortNameObj.value = "";
		
		document.all.addRecordNum.value = document.all.dyntb2.rows.length-2;
	}
	
	function check_phone()
	{

 		var sqlBuf="";
		var myPacket = new AJAXPacket("CallCommONESQL.jsp","������֤�û����룬���Ժ�......");
		var update_no_type = document.frm.updateNoType[document.frm.updateNoType.selectedIndex].value;

		  if(!checkElement(document.all.oldNo)) return false;
		  if(!checkElement(document.all.newNo)) return false;
		  
		  var shortNo = document.frm.newNo.value;		

		if( update_no_type == "00" ){//�̺�
			if(document.frm.oldNo.value.length > 6 ){
			  	rdShowMessageDialog("�̺ų��������6λ!!");
			  	document.frm.oldNo.select();
			  	document.frm.oldNo.focus();
			  	return false;
			}
			if(document.frm.newNo.value.length > 6 ){
			  	rdShowMessageDialog("�̺ų��������6λ!!");
			  	document.frm.newNo.select();
			  	document.frm.newNo.focus();
			  	return false;
			}
			dynAddRow();
		}else if ( update_no_type == "10" ){
			//wuxy add 20100331
			var mobile_phone=document.all.mobile_phone.value;
			if(mobile_phone.substr(0,1)==0)
			{
				if(shortNo.substr(0,1) == 7)
        		{
        			if(shortNo.length > 8 || shortNo.length < 3){
             	    rdShowMessageDialog("7��ͷ�Ķ̺ų��ȱ�����3-8λ!!");
             	    document.frm.newNo.select();
			  		document.frm.newNo.focus();
             	    return false;	  			
             	    }
        		}
        		else
        		{
        			if(shortNo.substr(0,1) != 6){
             	    rdShowMessageDialog("�̺��������6��7��ͷ!");
             	    document.frm.newNo.select();
			  		document.frm.newNo.focus();
             	    return false;
             	    }
        			if(shortNo.substr(1,1) == 0){
             	    rdShowMessageDialog("�̺���ڶ�λ����Ϊ0!");
             	    document.frm.newNo.select();
			  		document.frm.newNo.focus();
             	    return false;
             	    } 
             	    if(shortNo.length > 6 || shortNo.length < 4){
             	    rdShowMessageDialog("6��ͷ�Ķ̺ų��ȱ�����4-6λ!!");
             	    document.frm.newNo.select();
			  		document.frm.newNo.focus();
             	    return false;	  			
             	    }
        		}
				
			}
			else
			{
			
				if(document.frm.newNo.value.length > 6 ){
			  	rdShowMessageDialog("�̺ų��������6λ!!");
			  	document.frm.newNo.select();
			  	document.frm.newNo.focus();
			  	return false;
			  	}
			  	/*lilm 20090115 �ڵ�����Ӱ�ť��ʱ�򣬼���̺ŵ��ж�*/
			  	
			  		
		
				if(shortNo.length > 6 || shortNo.length < 4){
				  	rdShowMessageDialog("�̺ų��ȱ�����4-6λ!!");
				  	document.frm.newNo.select();
			  	    document.frm.newNo.focus();
				  	
				  	return false;	  			
				}
				
    	   <%
        	if(operFlag==true) {
        	%>
        	if(shortNo.substr(0,1) !=6 && shortNo.substr(0,1) !=7)
			   	{
			   		rdShowMessageDialog("�̺��������6����7��ͷ!");
				  	document.frm.newNo.select();
			  	    document.frm.newNo.focus();
			   		return false;
			   	}
        	<%}else {%> 			
			    if(shortNo.substr(0,1) !=6)
			   	{
			   		rdShowMessageDialog("�̺��������6��ͷ!");
				  	document.frm.newNo.select();
			  	    document.frm.newNo.focus();
			   		return false;
			   	}
			   	<%}%>
			   	
			   	if(shortNo.substr(1,1) ==0)
			   	{
			   		rdShowMessageDialog("�̺���ڶ�λ����Ϊ0!");
				  	document.frm.newNo.select();
			  	    document.frm.newNo.focus();
			   		return false;
			   	} 
			 }
			  	

			
			dynAddRow();
		}else{
			/*sqlBuf="select count(*) from dcustmsg where phone_no ='"+document.frm.newNo.value+"'" +
					" and substr(run_code,2,1 ) < 'a' ";*/

			myPacket.data.add("verifyType","phoneno");

			myPacket.data.add("sqlBuf",sqlBuf);
			myPacket.data.add("recv_number",1);
			myPacket.data.add("updateNoType",update_no_type);
			myPacket.data.add("j1PhoneNo","");
			myPacket.data.add("oldNo","");
			myPacket.data.add("newNo",document.frm.newNo.value);
			core.ajax.sendPacket(myPacket);
			delete(myPacket);
		}
        $("#addCondConfirm").attr("disabled",true);
	}

    function Getsingle_phoneno(){
        var vSinglePhoneNo = $("#single_phoneno").val();
        var vIdNo = $("#id_no").val();
        var vSmCode = $("#sm_code").val();
        var vProductId = $("#product_id").val();
        var vRequestType = "";
        if(vSinglePhoneNo != ""){
            if(!forMobil(document.all.single_phoneno)){
                rdShowMessageDialog("�ֻ������ʽ����ȷ�����������룡",0);
                $("#single_phoneno").val("");
                $("#single_phoneno").focus();
                return false;
            }
            var packet = new AJAXPacket("<%=request.getContextPath()%>/npage/s7896/pubChkNo.jsp","���ڻ�ó�Ա��Ϣ�����Ժ�......");
        	packet.data.add("workNo","<%=workNo%>");
        	packet.data.add("opCode","<%=opCode%>");
        	packet.data.add("idNo",vIdNo);
        	packet.data.add("smCode",vSmCode);
        	packet.data.add("productId",vProductId);
        	packet.data.add("singlePhoneNo",vSinglePhoneNo);
        	packet.data.add("requestType",vRequestType);
        	core.ajax.sendPacket(packet,doGetsingle_phoneno);
        	packet = null;
        }else{
            GetMemberPhoneno();
        }
    }
    
    function doGetsingle_phoneno(packet){
        var retCode = packet.data.findValueByName("retCode");		
        var retMsg = packet.data.findValueByName("retMessage");
        var retPhoneNoNum = packet.data.findValueByName("retPhoneNoNum");
        var retMemberUse = packet.data.findValueByName("retMemberUse");
        var retSinglePhoneno = packet.data.findValueByName("retSinglePhoneno");
        
        if(retCode == "000000"){
            if(retPhoneNoNum != 0){
                $("#member_use").val(retMemberUse);
                $("#single_phoneno").val(retSinglePhoneno);
                return true;
            }else{
                rdShowMessageDialog("�˼���û�иó�Ա��Ϣ,���������룡",0);
                $("#single_phoneno").val("");
                $("#single_phoneno").focus();
                return false;
            }
        }else{
            rdShowMessageDialog("������룺"+retCode+"<br/>������Ϣ��"+retMsg,0);
            return false;
        }
    }



	//������ײ�
function GetMemberPhoneno()
{
	var pageTitle = "���ų�Ա�����ѯ";
    var fieldName = "��Ա�û�ID|��Ա�û��ֻ�����|ҵ������|";
    /* modify by qidp
    var sqlStr  = " select a.id_no, f.phone_no, e.sm_name, c.service_no"
                + " from dCustMsgAdd     a,"
                + " dGrpUserMsg     b,"
                + " dAccountIdInfo  c,"
                + " sBusiTypeSmCode d,"
                + " sSmCode         e,"
                + " dcustmsg        f"
                + " where a.FIELD_VALUE = to_char(b.id_no)"
                + " and a.id_no = f.id_no"
                + " and a.FIELD_CODE = '1004'"
                + " and b.user_no = c.msisdn"
                + " and b.sm_code = c.service_type"
                + " and c.service_no='"+document.frm.service_no.value+"'"
                + " and c.service_type = d.sm_code"
                + " and c.service_type = e.sm_code"
                + " and e.region_code = '"+document.frm.org_code.value.substring(0,2)+"'"; 
    */
    var sqlStr = "";
	var selType = "S";    //'S'��ѡ��'M'��ѡ
	var retQuence = "2|0|1|";
	var retToField = "member_use|single_phoneno|";
	var returnNum="3";
	PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,returnNum);
}

function PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,returnNum)
{
    var vSinglePhoneNo = $("#single_phoneno").val();
    var vIdNo = $("#id_no").val();
    var vSmCode = $("#sm_code").val();
    var vProductId = $("#product_id").val();
    var vWorkNo = "<%=workNo%>";
    var vOpCode = "<%=opCode%>";
    var vOpType = "m02";
    var vRequestType = "";
    
    var path = "<%=request.getContextPath()%>/npage/s7896/fGetPhoneNo.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType; 
	path = path + "&returnNum=" + returnNum;
	path = path + "&phoneNo="+vSinglePhoneNo;
	path = path + "&idNo="+vIdNo;
	path = path + "&smCode="+vSmCode;
	path = path + "&productId="+vProductId;
	path = path + "&workNo="+vWorkNo;
	path = path + "&opCode="+vOpCode;
	path = path + "&opType="+vOpType;
	path = path + "&requestType="+vRequestType;
    retInfo = window.showModalDialog(path);
    if(retInfo ==undefined)      
    {
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
	return true;
}

function j1ChangeUpdateNoType() {	//wanghfa���� 2010-12-9 17:01 �����ܻ�����BOSS
	
	if (document.all.addRecordNum.value != "0" && document.all.addRecordNum.value != "") {
		rdShowMessageDialog("�������������ݣ����ܸ����޸ĺ������ͣ�", 1);
		var updateNoTypeObj = document.getElementById("updateNoType");
		if (updateNoTypeObj.value == "00") {
			updateNoTypeObj.value = "10";
		} else if (updateNoTypeObj.value == "10") {
			updateNoTypeObj.value = "00";
		}
		
		return;
	}
	document.getElementById("oldNo").value = "";
	document.getElementById("j1No").value = "";
	document.getElementById("j1PhoneNo").value = "";
	document.getElementById("j1UserName").value = "";
	document.getElementById("j1ShortName").value = "";
	
	var updateNoType = document.getElementById("updateNoType").value;
	var innerShortNoQryObj = document.getElementById("innerShortNoQry");
	var outerShortNoQryObj = document.getElementById("outerShortNoQry");
	var InnerOldNoQryObj = document.getElementById("InnerOldNoQry");
	var outerOldNoQryObj = document.getElementById("outerOldNoQry");
	var tdt1 = document.getElementById("tdt1");
	//var tdt2 = document.getElementById("tdt2");
	//var updateNoTypeTemp = document.getElementById("updateNoTypeTemp");
	
	if (updateNoType == "00") {
		tdt1.innerText = "Ҫ�޸ĵķֻ�����";
		innerShortNoQryObj.style.display = "";
		outerShortNoQryObj.style.display = "";
		InnerOldNoQryObj.style.display = "none";
		outerOldNoQryObj.style.display = "none";
	} else if (updateNoType == "10") {
		tdt1.innerText = "Ҫ�޸ĵ���ʵ����";
		innerShortNoQryObj.style.display = "none";
		outerShortNoQryObj.style.display = "none";
		InnerOldNoQryObj.style.display = "";
		outerOldNoQryObj.style.display = "";
	}
}

function changeUpdateNoType(){
	document.all.oldNo.value="";
	document.all.newNo.value="";
	if(document.all.updateNoType.value=="00"){
		document.getElementById("tdt1").innerText="���޸Ķ̺ţ�";
		document.getElementById("tdt2").innerText="�޸ĺ�̺ţ�";
		document.all.oldNoQry.style.display='';
    document.all.OtherNoButton.style.display='none';
    document.all.newNoQry.style.display='none';
    document.all.newNoQry2.style.display='';

	}
	if(document.all.updateNoType.value=="01"){
		document.getElementById("tdt1").innerText="���޸Ķ̺ţ�";
		document.getElementById("tdt2").innerText="�޸ĺ���ʵ���룺";
		document.all.oldNoQry.style.display='';
    document.all.OtherNoButton.style.display='none';
    document.all.newNoQry.style.display='none';
    document.all.newNoQry2.style.display='';
	}
	if(document.all.updateNoType.value=="10"){
		document.getElementById("tdt1").innerText="���޸���ʵ���룺";
		document.getElementById("tdt2").innerText="�޸ĺ�̺ţ�";
		document.all.oldNoQry.style.display='';
    document.all.OtherNoButton.style.display='';
    document.all.newNoQry.style.display='';
    document.all.newNoQry2.style.display='none';
	}
	if(document.all.updateNoType.value=="11"){
		document.getElementById("tdt1").innerText="���޸���ʵ���룺";
		document.getElementById("tdt2").innerText="�޸ĺ���ʵ���룺";
		document.all.oldNoQry.style.display='';
    document.all.OtherNoButton.style.display='none';
    document.all.newNoQry.style.display='none';
    document.all.newNoQry2.style.display='';
	}
}

function getOtherPhoneList2(call_type)
	{
		document.all.tmpAddShortNo.value="";
		document.all.tmpAddRealNo.value="";
		//alert(call_type);
	  var pageTitle = "���ų�Ա�����ѯ";
	  var fieldName = "�̺�|��ʵ����|���ź�|";
		var sqlStr ="";
		var params = "";
		var update_no_type = document.frm.updateNoType[document.frm.updateNoType.selectedIndex].value;


		 if( document.frm.service_no.value == "" )
		 {
		  	rdShowMessageDialog("�����뼯�ź�!!");
		  	return false;
		 }
		if(!checkElement(document.all.service_no)) return false;

		
				 
		
		if( call_type == "0" ){//���޸ĺ���
			params = document.frm.service_no.value + "|" + document.frm.oldNo.value + "|";
			
		  if((update_no_type == "00") || (update_no_type == "01")) {
				sqlStr =  "90000021" ;
			} else	{
				sqlStr =  "90000022" ;
			}
		}	else {//�޸ĺ����
			params = document.frm.service_no.value + "|" + document.frm.newNo.value + "|";
			
		  if((update_no_type == "00") || (update_no_type == "10")) {
				sqlStr =  "90000023" ;
			} else {
				sqlStr =  "90000024" ;
			}
		}

	  
	  //alert(sqlStr);

	  var selType = "S";    //'S'��ѡ��'M'��ѡ
	  var retQuence = "3|0|1|2|";
	  var retToField = "tmpAddShortNo|tmpAddRealNo|service_no|";
	  
		
	  PubSimpSel_self2(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,params);

		if (call_type == "0") {//���޸ĺ���
		  if ((update_no_type == "00") || (update_no_type == "01")) {
				document.frm.oldNo.value = document.all.tmpAddShortNo.value;
			} else {
				document.frm.oldNo.value = document.all.tmpAddRealNo.value;
			}
		} else {//�޸ĺ����
		  if((update_no_type == "00") || (update_no_type == "10")) {
				document.frm.newNo.value = document.all.tmpAddShortNo.value;
			} else	{
				document.frm.newNo.value = document.all.tmpAddRealNo.value;
			}
		}
	}
	
    function PubSimpSel_self2(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,params)
	{
        var vGrpId = document.frm.id_no.value;
        var vRegionCode = "<%=regionCode%>";
        var vGroupNo = document.frm.service_no.value;
        var vUpdateNoType = document.frm.updateNoType[document.frm.updateNoType.selectedIndex].value;
        var vOfferId = document.frm.product_id.value;
        var vOldNo = document.frm.oldNo.value;

	    var path = "../public/fPubSimpSel.jsp";
	    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
	    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
	    path = path + "&selType=" + selType;
	    path = path + "&grpId=" + vGrpId;
	    path = path + "&regionCode=" + vRegionCode;
	    path = path + "&groupNo=" + vGroupNo;
	    path = path + "&updateNoType=" + vUpdateNoType;
	    path = path + "&offerId=" + vOfferId;
	    path = path + "&oldNo=" + vOldNo;
	    path = path + "&params=" + params;

	    retInfo = window.showModalDialog(path);
		if(retInfo == undefined)
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
	
    function dynAddRow()
	{
		var old_no="";
		var new_no="";

	    var tmpStr="";

        old_no = document.all.oldNo.value;
        new_no = document.all.newNo.value;
        
        if(!checkElement(document.all.oldNo)) return false;
        if(!checkElement(document.all.newNo)) return false;

	    queryAddAllRow2(0,old_no,new_no);
	}

	function queryAddAllRow2(add_type,old_no,new_no)
	{
        var tr1="";
        var i=0;
        var tmp_flag=false;
        var exec_status="";


        tmp_flag = verifyUnique(old_no,new_no);
        if(tmp_flag == false)
        {
            rdShowMessageDialog("�Ѿ���һ��'���޸ĺ���' '�޸ĺ����'��ͬ������!!");
            return false;
        }
        
        tr1=dyntb2.insertRow();	//ע�⣺����ı������������һ��,������ɿ���.yl.
        tr1.id="tr"+dynTb2Index;
        
        tr1.insertCell().innerHTML = '<div align="center"><input id=R20 type=checkBox    size=4 value="ɾ��" onClick="dynDelRow()" ></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R21 type=text   value="'+ old_no+'"  readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R22 type=text   value="'+ new_no+'"  readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R23 type=text   value="'+ exec_status+'"  readonly></input></div>';
        
        dynTb2Index++;
        document.all.oldNo.value = "";
        document.all.newNo.value = "";
        
        
        document.all.addRecordNum.value = document.all.dyntb2.rows.length-2;
	}

	function dynDelRow()
	{

		for(var a = document.all.dyntb2.rows.length-2 ;a>0; a--)//ɾ����tr1��ʼ��Ϊ������
		{
	        if(document.all.R20[a].checked == true)
	        {
	            document.all.dyntb2.deleteRow(a+1);
	            break;
	        }
		}
		document.all.addRecordNum.value = document.all.dyntb2.rows.length-2;

	}


	function dyn_deleteAll()
	{
		//������ӱ��е�����
		for(var a = document.all.dyntb2.rows.length-2 ;a>0; a--)//ɾ����tr1��ʼ��Ϊ������
		{
	        document.all.dyntb2.deleteRow(a+1);
		}
		document.all.addRecordNum.value = document.all.dyntb2.rows.length-2;
	}
	
    function verifyUnique(old_no,new_no)
	{
		var tmp_oldNo="";
		var tmp_newNo="";

		for(var a = document.all.dyntb2.rows.length-2 ;a>0; a--)//ɾ����tr1��ʼ��Ϊ������
		{
			  tmp_oldNo = document.all.R21[a].value;
			  tmp_newNo = document.all.R22[a].value;

			  if( ((tmp_oldNo).trim() == (old_no).trim())
			  	|| ((tmp_newNo).trim() == (new_no).trim())
			  	|| ((tmp_oldNo).trim() == (new_no).trim())
			  	|| ((tmp_newNo).trim() == (old_no).trim())
			  ){
			        return false;
			    }

		}

        return true;
    }
    
    function call_flags()
    {
        var h=600;
        var w=900;
        var t=screen.availHeight/2-h/2;
        var l=screen.availWidth/2-w/2;
        var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no";
        var str=window.showModalDialog('user_flags.jsp?flags='+document.frm.F80016.value+'&sm_code=<%=iSmCode%>&requestType='+$("#request_type").val(),"",prop);
        if( typeof(str) != "undefined" ){
            document.frm.F80016.value = str;
        }
        return true;
    }
    
    function doUnLoading(){
        $("#sure").attr("disabled",false);
        unLoading();
    }
</script>

</head>
<body>
<form name="frm" action="" method="post" >
<%@ include file="/npage/include/header.jsp" %>
<div class="title">
	<div id="title_zi">�����û���Ϣ��ѯ</div>
</div>
<table cellspacing=0>
    <tr>
        <td class='blue' nowrap width='18%'>֤������</td>
        <td width='32%'>
            <input type='text' name='iccid' id='iccid' value='<%=iIccid%>' v_must='1' />
            <input type='button' class='b_text' name='iccid_query' id='iccid_query' value='��ѯ' onClick="getCustInfo()" />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap width='18%'>���ſͻ�ID</td>
        <td>
            <input type='text' id='cust_id' name='cust_id' value='<%=iCustId%>' v_must='1' />
            <font class='orange'>*</font>
        </td>
    </tr>
    
    <tr>
        <td class='blue' nowrap>���ű��</td>
        <td>
            <input type='text' name='unit_id' id='unit_id' value='<%=iUnitId%>' v_must='1' />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap>���źŻ����������</td>
        <td>
            <input type='text' id='service_no' name='service_no' value='<%=iServiceNo%>' v_must='1' />
            <font class='orange'>*</font>
        </td>
    </tr>
    
    <tr>
        <td class='blue' nowrap>���Ų�Ʒ����</td>
        <td>
            <input type='text' id='product_name' name='product_name' value='<%=iProductName%>' readOnly/>
            <input type='hidden' name='product_id' id='product_id' value='<%=iProductId%>' v_must='1' readOnly />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap>��Ʒ�����˻�</td>
        <td>
            <input type='text' id='account_id' name='account_id' value='<%=iAccountId%>' v_must='1' readOnly />
            <font class='orange'>*</font>
        </td>
    </tr>
    
    <tr>
        <td class='blue' nowrap>����Ʒ��</td>
        <td>
            <input type='text' name='sm_name' id='sm_name' value='<%=iSmName%>' v_must='1' readOnly />
            <input type='hidden' name='sm_code' id='sm_code' value='<%=iSmCode%>' v_must='1' readOnly />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap>��������</td>
        <td>
            
            <select name="belong_code" id="belong_code">
<%
				try
				{
					String sqlStr2 = "select substr(:org_code,1,2),substr(:org_code,1,7)||'|'||:GroupId,'�������ڵ�' from dual";
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
        <td class='blue' nowrap>���Ų�Ʒ����</td>
        <td  >
            <jsp:include page="/npage/common/pwd_8.jsp">
                <jsp:param name="width1" value="16%"  />
                <jsp:param name="width2" value="34%"  />
                <jsp:param name="pname" value="product_pwd"  />
                <jsp:param name="pwd" value="<%=iProductPwd%>"  />
            </jsp:include>
            <input type='button' class='b_text' id='chk_productPwd' name='chk_productPwd' onClick='chkProductPwd()' value='У��' />
            <font class="orange">*</font>
        </td>

		<td class='blue' nowrap>
			<span id=tbs1 style="display:<%=vplistShow%>">
			����ѡ��
			</span>
			<span id=tbs3 style="display:<%=j1listShow%>">
			����ѡ��
			</span>&nbsp;
		</td>
		<td >
			<span id=tbs2 style="display:<%=vplistShow%>">
				<select name="request_type" id="request_type"  onchange="changeType()">
				    <%
				    System.out.println("gaopengSeeLog--------7896-----iRequestType=="+iRequestType);
					if("m05".equals(iRequestType)){
					System.out.println("gaopengSeeLog--------7896-----iRequestType=="+1);
					%>
					    <option value='m05' >0-�̺��޸�</option>
					<%
					}else if("m02".equals(iRequestType)){
						System.out.println("gaopengSeeLog--------7896-----iRequestType=="+2);
					%>
					    <option value='m02' >1-�޸������ʷ�</option>
					<%
					}else if("m10".equals(iRequestType)){
						System.out.println("gaopengSeeLog--------7896-----iRequestType=="+3);
					%>
						<option value='m10' >2-�����޸�(���������ʷ�)</option>
					<%	
					}else{
						System.out.println("gaopengSeeLog--------7896-----iRequestType=="+4);
					%>
    					<option value="" selected>--��ѡ��--</option>
    					<option value="m05" >0-�̺��޸�</option>
    					<option value="m02" >1-�޸������ʷ�</option>
					<%}%>	
				</select>
			</span>
			<span id=tbs4 style="display:<%=j1listShow%>">
				<select name="j1_request_type" id="j1_request_type"  onchange="changeType()">
				    <%
				    System.out.println("gaopengSeeLog--------7896-----iRequestType=="+5);
					if("m07".equals(iRequestType)){
					System.out.println("gaopengSeeLog--------7896-----iRequestType=="+6);
					%>
					    <option value='m07' >0-�ֻ����޸�</option>
					<%
					}else if("m02".equals(iRequestType)){
						System.out.println("gaopengSeeLog--------7896-----iRequestType=="+7);
					%>
					    <option value='m02' >1-�����޸�</option>
					<%
					}else{
						System.out.println("gaopengSeeLog--------7896-----iRequestType=="+8);
					%>
    					<option value="" selected>--��ѡ��--</option>
    					<option value="m07" >0-�ֻ����޸�</option>
    					<option value="m02" >1-�����޸�</option>
					<%}%>	
				</select>
			</span>&nbsp;
		</td>
    </tr>
     <%/*begin �����һ��չʾ�ͻ��������ź�������������� by diling@2012/5/14 */%>
     <input type='hidden' id='custManagerNoHiden' name='custManagerNoHiden'  value='' readOnly/>
     <input type='hidden' id='custManagerNameHiden' name='custManagerNameHiden' value='' readOnly/>
     <input type='hidden' id='unitTypeHiden' name='unitTypeHiden' value='' readOnly/>
    <tr id="custManagerInfo" style="display:none">
        <td class='blue' nowrap>�ͻ���������</td>
        <td>
            <input type='text' class="InputGrey" id='custManagerNo' name='custManagerNo' value='<%=iCustManagerNoHiden%>' readOnly/>
        </td>
        <td class='blue' nowrap>�ͻ���������</td>
        <td>
            <input type='text' class="InputGrey" id='custManagerName' name='custManagerName' value='<%=iCustManagerNameHiden%>' v_must='1' readOnly />
        </td>
    </tr>
    <tr id="unitTypeInfo" style="display:none">
        <td class='blue' nowrap>�������</td>
        <td colspan="3">
            <input type='text' class="InputGrey" id='unitType' name='unitType' value='<%=iUnitTypeHiden%>' readOnly/>
        </td>
    </tr>
    <%/*end by diling */%>
</table>
</div>

<div id=div1 style="display:<%=otherShow%>">
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">
		��Ա�������
		<span id="div_mm_chg_type" style="display:none">
			<input type="radio" name="mm_chg_type" value="1"    onclick="chg_MM_tab_show(1)" checked/>����
			<input type="radio" name="mm_chg_type" value="2"    onclick="chg_MM_tab_show(2)"         />��������ۿ�
			<input type="radio" name="mm_chg_type" value="2"    onclick="chg_MM_tab_show(3)"         />�������GPRS����
		</span>
	</div>
</div>
<span id='selRadios' name='selRadios' >
	
	
<TABLE  cellSpacing="0">
    <tr id="vpInputFlag" name="vpInputFlag" style='display:'>
        <td class='blue' nowrap width='18%'>�������뷽ʽ</td>
        <td colspan='3'>
            <input type='radio' id='phoneNo_input_type' name='phoneNo_input_type' onClick='chgSingleNo()' value='no' checked />����������
            <input type='radio' id='phoneNo_input_type' name='phoneNo_input_type' onClick='chgInputFile()' value='file' />���ļ�¼��
        </td>
    </tr>
</table>



</span>
<span id='single_no' name='single_no' >
<table cellspacing=0  id="MM_general">
    <tr>
        <td class='blue' nowrap width='18%'>��Ա�û��ֻ�����</td>
        <td width='32%'>
            <input type='text' id='single_phoneno' name='single_phoneno'  v_type="string" value="<%=single_phoneno%>"  maxlength='13' onblur='if(this.value!="" && !forMobil(this)){return false;}' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' />
            <input class="b_text" id="selectNo" onClick="Getsingle_phoneno()" type=button value="ѡ��" />
            <font class='orange'>*</font>
        </td>
        <td class='blue' nowrap width='18%'>��Ա�û�ID</td>
        <td width='32%'>
            <input type='text' id='member_use' name='member_use' v_must=0 v_type="string" value='<%=member_use%>' />
        </td>
	</tr>
</table>


<TABLE  cellSpacing="0" id="MM_batch" style="display:none">
<tr>
	<td class="blue"  width='18%'>��������<br>����<span id="count_phoneNo">0</span>������</td>
	<td  width='32%'>
		<textarea id="textarea_batch" name="textarea_batch" style="width:200px;height:200px;" onchange="check_bath_phoneNo()"></textarea>
	</td>
	<td>
		 <font class="orange">
		 	ÿ��ֻ����һ���ֻ����룬ʹ�����߷ָ�<br>
		 	���50��<br>
		 	<br><br>
		 	ʾ�����£�<br>
		 	13904511100|<br>
		 	13904511101|<br>
		 </font>
	</td>
</tr>
</table>


<div id="MM_batch_attr" style="display:none">
<div class="title">
	<div id="title_zi">
		��Ա������Ϣ
	</div>
</div>
<%
String sql81047 = " SELECT param_code,param_name FROM DBCUSTADM.suserfieldparamcode WHERE field_code  =  '81047'";
%>
  <wtc:service name="TlsPubSelCrm" outnum="2" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=sql81047%>" />
	</wtc:service>
	<wtc:array id="result_81047" scope="end"   />

<TABLE  cellSpacing="0" id="MM_batch" >
	<tr id="tr_show2" style="display:none">
		<TD class=blue width='18%'>��Ա�ۿ��ʷ���Ϣ</TD>
		<TD width='32%' colspan=1> 
			<select id='mm_bath_F81047' name='mm_bath_F81047' >
<%
		for (int i=0;i<result_81047.length;i++){
%>
				<option  value="<%=result_81047[i][0]%>"><%=result_81047[i][0]%>--<%=result_81047[i][1]%></option>
<%		
		}
%>				
	
			</select> 
		</TD>
	</tr>
	<tr id="tr_show3" style="display:none">
		<TD class=blue width='18%'>GPRS��̬��������</TD>
		<TD width='32%' >
			 <select id='mm_bath_F81014' name='mm_bath_F81014' >
				 <option selected value='N'>N--�ر�</option>
				 <option  value='Y'>Y--��ͨ</option>
			 </select>
	 </TD>
	</tr>
</table>
</div>

</span>
<span id='input_file' name='input_file' style='display:none;'>
    <table cellspacing=0>
        <TR>
            <TD align="left" class=blue width=18%>¼���ļ�</TD>	   
            <TD colspan='3'> 
                <input type="file" name="memberPosFile" id="memberPosFile" class="button" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' value="" />
            </TD>
        </TR>
<%		
  if("ZH".equals(iSmCode)){
%>
        <TR>
            <TD colspan="4">
              <font color="#FF0000">
                <%/*diling update for �޸ġ���Ա������롱���ļ�¼�뷽ʽ���޸�Ϊ11λ��ʵ���룬ɾ��IP��ַ��ɾ�����ݣ���ʵ�����IP��ַ�á� �����ո񣩷ָIP��ַ�������޸�ʱ��Ϊ�գ� @2012/10/9 */%>
                �ļ�˵��:11λ��ʵ���� (ע�⣺�ϴ��ļ���ʽ����Ϊ�ı��ļ�(.txt)����֧��EXCEL��ʽ�ϴ��ļ�)��ÿ�����50����
              </font>
            </TD>
        </TR>
<%
  }else{
%>
        <TR>
            <TD colspan="4"><font color="#FF0000">�ļ�˵��:��ʵ���룬һ������һ��
                (ע�⣺�ϴ��ļ���ʽ����Ϊ�ı��ļ�(.txt)����֧��EXCEL��ʽ�ϴ��ļ�)��ÿ�����50����</font>
            </TD>
        </TR>
<%
  }
%>
	</table>
</span>
</div>
</div>
<%
	if ("2".equals(nextFlag)){

%>

<!---- ���ص��б�-->
	<%
		//Ϊinclude�ļ��ṩ���� 
		int fieldCount=0;
		boolean isGroup = true;
		
		if (resultList != null||paramsOut28 != null)
		{
			fieldCount=paramsOut28.length;
			System.out.println("---------fieldCount---------"+fieldCount);
			
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

				System.out.println("---------hello other---------"+iSmCode);
				fieldCodes[iField]=paramsOut26[iField][0];
				fieldNames[iField]=paramsOut28[iField][0];
				fieldPurposes[iField]=paramsOut29[iField][0];//add
				fieldValues[iField]=paramsOut27[iField][0];
				dataTypes[iField]=paramsOut30[iField][0];
				fieldLengths[iField]=paramsOut31[iField][0];
				fieldGroupNo[iField]=userFieldGrpNo[iField][0];
				fieldGroupName[iField]=userFieldGrpName[iField][0];
				fieldCtrlInfos[iField]=userFieldCtrlInfos[iField][0];
				//liujian 2013-3-28 11:12:23 �����������
				fieldMaxRows[iField] = userFieldMaxRows[iField][0];
			iField++;
		}
		System.out.println("----------page begin---------------");
		
		if(!"m05".equals(iRequestType) && !"m07".equals(iRequestType) && fieldCount>0){	//wanghfa�޸� 2010-12-14 11:16 j1����BOSS
	%>
			<%@ include file="fpubDynaFields.jsp"%>
        <%}%>

	<%		
	if("np".equals(iSmCode)){
	%>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">��������</div>
</div>

<table cellspacing=0>
	            <TR id="line_0"> 		
			    <TD class="blue" width='18%'>ͳ����־</TD>
	            <TD  colspan=3>	              	
	            	<select name="allPayFlag" onchange="changePayFlag()">	 
	              	<option value="0">ͳ��</option>
	              	<!--<option value="1">����Ŀ���</option> -->
	              	</select>&nbsp;<font class="orange">*</font>
	            </TD>
	          </TR> 
            <TR id="line_1"> 		
			    <TD class="blue">ȫ���־</TD>
	            <TD colspan=3>	              	
	            	<select name="allFlag" onchange="changeFlag()">
	            			<option value="0">�����</option> 
	              		<!--<option value="1">ȫ���</option>    -->        		
	              	</select>&nbsp;<font class="orange">*</font>
	            </TD>
	          </TR> 
	         <TR id="line_111">    	              
	            <TD class="blue">������</TD>
	            <TD colspan=3>
	              	<input type="text"  v_type="money"  v_must="1" v_minlength="1" v_maxlength="14"  id="cycleMoney" name="cycleMoney" maxlength="14">&nbsp;<font class="orange">*</font>
	            </TD>
	         </TR>
	         
	         <TR id="line_2"> 
				<TD class="blue" width='18%'>��ʼ����</TD>
	            <TD height = 20 width='32%'>
	              	<input type="text" id="beginDate" name="beginDate" maxlength="8" value="<%=dateStr%>" v_type="date"  v_must="1" v_format="yyyyMMdd" onblur="forDate(this)">
	              	&nbsp;(��ʽ:yyyymmdd)&nbsp;<font class="orange">*</font>            	
	            </TD> 			
			    <TD class="blue" width='18%'>��������</TD>
	            <TD height = 20>
	              	<input type="text"  id="endDate" name="endDate" maxlength="8" value="<%=endDate%>" v_type="date"  v_must="1"  v_format="yyyyMMdd" onblur="forDate(this)">
	              	&nbsp;(��ʽ:yyyymmdd)&nbsp;<font class="orange">*</font>  
	            </TD> 		            	              
	         </TR>
    <tr>
        <td class='blue' nowrap width='15%'>�������뷽ʽ</td>
        <td colspan='3'>
            <input type='radio' id='input_type' name='input_type' onClick='chkSingle()' value='single' checked />��������
            <input type='radio' id='input_type' name='input_type' onClick='chkMulti()' value='multi' />��������
        </td>
    </tr>
    <tbody id='single' name='single'>
    <tr>
        <td class='blue' nowrap>��Ա�û��ֻ�����</td>
        <td colspan='3'>
            <input type='text' id='single_phoneno1' name='single_phoneno1' value=""  maxlength='13' onblur='if(this.value!="" ){return false;}' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' />
            <font class='orange'>*</font>
        </td>
    </tr>
    </tbody>
    <tbody id='multi' name='multi' style='display:none'>
    <tr>
        <TD class=blue>����</TD>
        <TD>
            <textarea cols=30 rows=8 id="multi_phoneNo" name="multi_phoneNo" style="overflow:auto" /></textarea>
        </TD>
        <TD colspan='2'>
            ע���������Ӻ���ʱ,����"|"��Ϊ�ָ���,�������һ������Ҳ����"|"��Ϊ����.
            <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ÿ�����50��,����30����
            <br>&nbsp;���磺
            <br>&nbsp;13900000001|
            <br>&nbsp;13900000002|
        </TD>
        </TR>			
        <TR style='display:none'>
        <TD align="left" class=blue width=12%>¼���ļ�</TD>	   
        <TD> 
            <input type="file" name="PosFile" id="PosFile" class="button" onchange="checkPhNo()" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' />
        </TD>
        <TD colspan="2"><font color='red'>�ļ�˵��:һ������һ��
            (ע�⣺�ϴ��ļ���ʽ����Ϊ�ı��ļ�����֧��EXCEL��ʽ�ϴ��ļ�)��ÿ�����50��,����30����</font>
        </TD>
    </tr>
    </tbody>
</table>
</div>
<%
} else if("vp".equals(iSmCode)) {
	if("m02".equals(iRequestType)||"m10".equals(iRequestType)) {
%>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">vpƷ����Ϣ</div>
</div>
<table cellspacing=0>
    <tr>
        <td class="blue" width='18%'>���Ź���ϵͳID</td>
        <td>
            <input type='text' id='grp_unit_id' name='grp_unit_id' value='<%=iUnitId%>' class='InputGrey' readOnly />
        </td>
        <td class="blue" width='18%'>���Ź���ϵͳ����</td>
        <td>
            <input type='text' id='grp_unit_name' name='grp_unit_name' value='<%=iGrpName%>' class='InputGrey' readOnly />
        </td>
    </tr>

</table>
</div>

<div id="Operation_Table">
<div class="title">
	<div id="title_zi">VPMN��������</div>
</div>
        <table cellspacing="0">
            <tr id="vpInputFlag" name="vpInputFlag" style='display:'>
                <td class='blue' nowrap width='18%'>�������뷽ʽ</td>
                <td colspan='3'>
                    <input type='radio' id='vp_input_type' name='vp_input_type' onClick='chgVpNo()' value='no' checked />����������
                    <input type='radio' id='vp_input_type' name='vp_input_type' onClick='chgVpFile()' value='file' />���ļ�¼��
                </td>
            </tr>
        </table>
        <span id='vp_no' name='vp_no'>
	  	<table cellspacing="0">
	          <tr>
		            <td width="18%" class="blue">�̺�</td>
		            <td width="32%">
		              		<input name="sNo" type="text"  id="sNo" maxlength="6" style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_type=0_9 >
		             </td>
		            <td width="18%" class="blue">��ʵ����</td>
		            <td>
			              <input name="lNo" type="text"  id="lNo" maxlength='11' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_type=0_9   >
			              <input name="NoButton" type="button" class="b_text" id="NoButton" value="��ѯ" onclick="getPhoneList()">
			              <input name="OtherNoButton" type="button" class="b_text" id="OtherNoButton" value="��ѯ���ƶ�����" onclick="getOtherPhoneList()">
		           </td>
	          </tr>	    
	                
	          <tr>
	            	<td colspan=4 width="15%"><font color="#FF0000">(ע�⣺ÿ�β�ѯֻѡ������������ǰ50����)</font></td>
	          </tr>
	          </table>          
		 
              	<table  id="dyntb" cellspacing="0" style="border-bottom:#c4d3d8 1px solid">
	                <tr>
		                  <td align=center nowrap class="blue">ѡ��
		                  <input type="button" class="b_text" value="ȫѡ" onclick="allChoose()">	
		                  <input type="button" class="b_text" value="ȡ��" onclick="cancelChoose()">
		                  </td>
		                  <td align=center class="blue">�̺�</td>
		                  <td align=center  class="blue">��ʵ����</td>
		                  <td align=center class="blue">��ǰ�ʷ�</td>		               
	                </tr>
                        <tr id="tr0" style="display:none">
		                  <td>
		                    <div align="center">
		                      <input type="checkBox" id="R0" value="">
		                    </div>
		                  </td>
		                  <td>
		                    <div align="center">
		                      <input type="text" id="R1" value="">
		                    </div>
		                  </td>
		                  <td>
		                    <div align="center">
		                      <input type="text" id="R2" value="">
		                    </div>
		                  </td>
		                  <td>
		                    <div align="center">
		                      <input type="text" id="R3" value="">
		                    </div>
		                  </td>
                		</tr>
			</table>
			<table cellspacing=0 id='tbPageNav' name='tbPageNav' style='display:none;'>
			    <tr>
        		    <td colspan='4'>
        		        �ܼ�¼��:<span id='totalNumNav'></span> ��ҳ��:<span id='totalPageNav'></span> ��ǰҳ:<span id='currentPageNav'></span> ÿҳ����:<span id='pageSizeNav'></span> [<span id='firstPageNav'><a id="firstPage" href="#" onClick="doFirstPage();">��һҳ</a></span>]  [<span id='prePageNav'><a id="prePage" href="#" onClick="doPrePage();">��һҳ</a></span>]  [<span id='nextPageNav'><a id="nextPage" href="#" onClick="doNextPage();">��һҳ</a></span>]  [<span id='endPageNav'><a id="endPage" href="#" onClick="doEndPage();">���һҳ</a></span>]  ��ת��ָ��ҳ<span id='spGotoPage'></span>
        		    </td>
        		</tr>
        	</table>
        </span>
        <span id='vp_file' name='vp_file' style='display:none;'>
            <table cellspacing=0>
                <TR>
                    <TD align="left" class=blue width=18%>¼���ļ�</TD>	   
                    <TD colspan='3'> 
                        <input type="file" name="vpmnPosFile" id="vpmnPosFile" class="button" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' />
                    </TD>
                </TR>
                <TR>
                    <TD colspan="4"><font color="#FF0000">�ļ�˵��:��ʵ����(����Ҫ����̺�)��һ������һ��
                        (ע�⣺�ϴ��ļ���ʽ����Ϊ�ı��ļ�(.txt)����֧��EXCEL��ʽ�ϴ��ļ�)��ÿ�����50����</font>
                    </TD>
                </TR>
        	</table>
        </span>
</div>
<%
	} else if("m05".equals(iRequestType)) {
%>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">�������Ӻ�����Ϣ</div>
</div>
<table cellspacing=0>
          <tr>
            <td class='blue' nowrap  width='18%'>��ѡ���������</td>
            <td class='blue' nowrap colspan='3'>
            	<select name="updateNoType" onchange="changeUpdateNoType()">
            		    <option value="00" >00--&gt;�̺źͶ̺�</option>
            		    <option value="01" >01--&gt;�̺ź���ʵ����</option>
                    <option value="10" selected>10--&gt;��ʵ����Ͷ̺�</option>
                    <option value="11" >11--&gt;��ʵ�������ʵ����</option>
                </select>
            </td>
          </tr>
          <tr>
            <td class='blue' nowrap id="tdt1" width='18%'>���޸���ʵ����</td>
            <td class='blue' nowrap width='32%'>
            	<input name="oldNo" type="text" class="button" id="oldNo" maxlength="12" v_must=1 v_type=0_9 v_minlength=1>
              <input name="oldNoQry" type="button" class="b_text" value="��ѯ" onClick="call_NoQry(0)">
               <input name="OtherNoButton" type="button" class="b_text" id="OtherNoButton" value="���ƶ�����" onclick="getOtherPhoneList2(0)">
            </td>
            <td class='blue' nowrap id="tdt2" width='18%'>�޸ĺ�̺�</td>
            <td>
            	<input name="newNo" type="text" id="newNo" class="button" maxlength="11" v_must=1 v_type=0_9 v_minlength=1 >
              <input name="newNoQry" type="button" class="b_text" value="У��" onClick="chkVpmnNo()">
              <input name="newNoQry2" type="button" class="b_text" value="У��" onClick="chkVpmnNo()" style='display:none'>
            </td>
          </tr>
          <tr >
            <td class='blue' nowrap>
            	<input name="addCondConfirm" type="button" class="b_text" id="addCondConfirm" value="����" disabled onClick="check_phone(); //dynAddRow()"></td>
            <td class='blue' nowrap>&nbsp;</td>
            <td class='blue' nowrap>�����Ӽ�¼��</td>
            <td> <input name="addRecordNum" type="text" class="InputGrey" id="addRecordNum" value="" size=7 readonly></td>
          </tr>
        </table>
            	<table  id="dyntb2" cellspacing="0">
                <tr>
                  <th align='center' nowrap>ɾ������</th>
                  <th align='center' nowrap>���޸ĺ���</th>
                  <th align='center' nowrap>�޸ĺ����</th>
                  <th align='center' nowrap>ִ��״̬</th>
                </tr>
                <tr id="tr20" style="display:none">
                  <td><div align="center">
                      <input type="checkBox" id="R20" value="">
                    </div></td>
                  <td><div align="center">
                      <input type="text" id="R21" value="">
                    </div></td>
                   <td><div align="center">
                      <input type="text" id="R22" value="">
                    </div></td>
                   <td><div align="center">
                      <input type="text" id="R23" value="">
                    </div></td>
                </tr>
              </table>
</div>

<%
	}
} else if("j1".equals(iSmCode)) {	//wanghfa���� 2010-12-9 16:04 j1����BOSS
	if("m02".equals(iRequestType)) {
%>
<div id="Operation_Table">
<div class="title" style="display:none">
	<div id="title_zi">j1Ʒ����Ϣ</div>
</div>
<table cellspacing=0 style="display:none">
    <tr>
        <td class="blue" width='18%'>���Ź���ϵͳID</td>
        <td>
            <input type='text' id='grp_unit_id' name='grp_unit_id' value='<%=iUnitId%>' class='InputGrey' readOnly />
        </td>
        <td class="blue" width='18%'>���Ź���ϵͳ����</td>
        <td>
            <input type='text' id='grp_unit_name' name='grp_unit_name' value='<%=iGrpName%>' class='InputGrey' readOnly />
        </td>
    </tr>
</table>
</div>

<div id="Operation_Table">
<div class="title">
	<div id="title_zi">�����ܻ���������</div>
</div>
<table cellspacing="0">
	<tr id="vpInputFlag" name="vpInputFlag" style='display:'>
		<td class='blue' nowrap width='18%'>�������뷽ʽ</td>
		<td colspan='3'>
			<input type='radio' id='j1_input_type' name='j1_input_type' onClick='chgJ1No()' value='no' checked />����������
			<input type='radio' id='j1_input_type' name='j1_input_type' onClick='chgJ1File()' value='file' />���ļ�¼��
		</td>
	</tr>
</table>
<span id='j1_no' name='j1_no'>
<table cellspacing="0">
	<tr>
		<td width="18%" class="blue">�ֻ���</td>
		<td width="32%">
			<input name="sNo" type="text"  id="sNo" maxlength="6" style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_type=0_9 >
		</td>
		<td width="18%" class="blue">��ʵ����</td>
		<td>
			<input name="lNo" type="text"  id="lNo" maxlength='11' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_type=0_9>
			<input name="NoButton" type="button" class="b_text" id="NoButton" value="���ڲ�ѯ" onclick="getPhoneList()">
			<input name="OtherNoButton" type="button" class="b_text" id="OtherNoButton" value="�����ѯ" onclick="getOtherPhoneList()">
		</td>
	</tr>
	
	<tr>
		<td colspan=4 width="15%"><font color="#FF0000">��ע�⣺ÿ�β�ѯֻѡ������������ǰ50������</font></td>
	</tr>
</table>

<table  id="dyntb" cellspacing="0">
	<tr>
		<td align=center nowrap class="blue" width="20%">ѡ��
			<input type="button" class="b_text" value="ȫѡ" onclick="allChoose()">	
			<input type="button" class="b_text" value="ȡ��" onclick="cancelChoose()">
		</td>
		<td align=center class="blue" width="30%">�ֻ�����</td>
		<td align=center  class="blue" width="50%">��ʵ����</td>
	</tr>
	<tr id="tr0" style="display:none">
		<td>
			<div align="center">
				<input type="checkBox" id="R0" value="">
			</div>
		</td>
		<td>
			<div align="center">
				<input type="text" id="R1" value="">
			</div>
		</td>
		<td>
			<div align="center">
				<input type="text" id="R2" value="">
			</div>
		</td>
	</tr>
</table>
	<table cellspacing=0 id='tbPageNav' name='tbPageNav' style='display:none;'>
		<tr>
			<td colspan='4'>
				�ܼ�¼��:<span id='totalNumNav'></span> ��ҳ��:<span id='totalPageNav'></span> ��ǰҳ:<span id='currentPageNav'></span> ÿҳ����:<span id='pageSizeNav'></span> [<span id='firstPageNav'><a id="firstPage" href="#" onClick="doFirstPage();">��һҳ</a></span>]  [<span id='prePageNav'><a id="prePage" href="#" onClick="doPrePage();">��һҳ</a></span>]  [<span id='nextPageNav'><a id="nextPage" href="#" onClick="doNextPage();">��һҳ</a></span>]  [<span id='endPageNav'><a id="endPage" href="#" onClick="doEndPage();">���һҳ</a></span>]  ��ת��ָ��ҳ<span id='spGotoPage'></span>
			</td>
		</tr>
	</table>
</span>
<span id='j1_file' name='j1_file' style='display:none;'>
	<table cellspacing=0>
		<TR>
			<TD align="left" class=blue width=18%>¼���ļ�</TD>	   
			<TD colspan='3'> 
				<input type="file" name="j1PosFile" id="j1PosFile" class="button" style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;' />
			</TD>
		</TR>
		<TR>
			<TD colspan="4"><font color="#FF0000">�ļ�˵��:��ʵ����(����Ҫ����ֻ�����)��һ������һ�� (ע�⣺�ϴ��ļ���ʽ����Ϊ�ı��ļ�(.txt)����֧��EXCEL��ʽ�ϴ��ļ�)��ÿ�����50����</font>
			</TD>
		</TR>
	</table>
</span>
</div>
<%
	} else if("m07".equals(iRequestType)) {
%>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">���������޸���Ϣ</div>
</div>
<table cellspacing=0>
	<tr>
		<td class='blue' nowrap width='18%'>��ѡ���������</td>
		<td class='blue' nowrap width='32%' colspan="3">
			<select name="updateNoType" id="updateNoType" onchange="j1ChangeUpdateNoType()">
				<option value="00" selected>00--&gt;�ֻ�����ͷֻ�����</option>
				<option value="10">10--&gt;��ʵ����ͷֻ�����</option>
			</select>
            <input name="j1PhoneNo" type="hidden" id="j1PhoneNo" maxlength='11' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_must=1 v_type=0_9 v_minlength=1 v_maxlength=12 class="InputGrey" readonly>
		</td>
	</tr>
	<tr>
		<td class='blue' nowrap id="tdt1" width='18%'>Ҫ�޸ĵķֻ�����</td>
		<td class='blue' nowrap width='32%'>
			<input name="oldNo" type="text" class="button" id="oldNo" onKeyPress='return isKeyNumberdot(0)' maxlength="12" v_must=1 v_type=0_9 v_minlength=1>
			<input name="innerShortNoQry" id="innerShortNoQry" type="button" class="b_text" value="���ڲ�ѯ" onClick="j1QryMember('0')">
			<input name="outerShortNoQry" id="outerShortNoQry" type="button" class="b_text" value="�����ѯ" onClick="j1QryMember('1')">
			<input name="InnerOldNoQry" id="InnerOldNoQry" type="button" class="b_text" value="���ڲ�ѯ" onClick="j1QryMember('2')" style="display:none">
			<input name="outerOldNoQry" id="outerOldNoQry" type="button" class="b_text" value="�����ѯ" onclick="j1QryMember('3')" style="display:none">
		</td>
		<td class='blue' nowrap width='18%'>�޸ĺ�ֻ�����</td>
		<td>
			<input name="j1No" type="text" id="j1No" maxlength="6" style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_must=1 v_type=0_9 v_minlength=4 v_maxlength=6 value="" class="InputGrey" readonly>
		</td>
	</tr>
	<tr>
		<td class='blue' nowrap>��Ա����</td>
		<td>
            <input name="j1UserName" type="text" v_must=1 id="j1UserName" maxlength="18" class="InputGrey" readonly>
		</td>
		<td class='blue' nowrap>��Ա����ƴ������ĸ</td>
		<td>
			<input name="j1ShortName" type="text" v_must=1 id="j1ShortName" maxlength="36" class="InputGrey" readonly>
		</td>
	</tr>
	<tr>
		<td class='blue' nowrap>
			<input name="addCondConfirm" type="button" class="b_text" id="addCondConfirm" value="����" onClick="j1AddToList();" disabled></td>
		<td class='blue' nowrap>&nbsp;</td>
		<td class='blue' nowrap>�����Ӽ�¼��</td>
		<td> <input name="addRecordNum" type="text" class="InputGrey" id="addRecordNum" value="" size=7 readonly></td>
	</tr>
</table>
<table id="dyntb2" cellspacing="0">
	<tr>
		<th align='center' nowrap>ɾ������</th>
		<th align='center' nowrap>Ҫ�޸ĵĺ���</th>
		<th align='center' nowrap>�޸ĺ�ķֻ�����</th>
		<th align='center' nowrap>��Ա����</th>
		<th align='center' nowrap>��Ա����ƴ������ĸ</th>
	</tr>
	<tr id="tr20" style="display:none">
		<td>
			<div align="center">
				<input type="checkBox" id="R20" value="">
			</div>
		</td>
		<td>
			<div align="center">
				<input type="text" id="R21" value="">
			</div>
		</td>
		<td>
			<div align="center">
				<input type="text" id="R22" value="">
			</div>
		</td>
		<td>
			<div align="center">
				<input type="text" id="R23" value="">
			</div>
		</td>
		<td>
			<div align="center">
				<input type="text" id="R24" value="">
			</div>
		</td>
	</tr>
</table>
</div>

<%
	}
} else {
%>
<div id="Operation_Table">
<div class="title">
	<div id="title_zi">���ʽ</div>
</div>
<table  cellspacing="0">
    <TR>
	  <%
			try{
			    sqlStr = "SELECT use_code FROM cGrpOpLimit WHERE sm_code='"+iSmCode+"' AND op_type='m02'";
			    %>
                    <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode45" retmsg="retMsg45"  outnum="1">
                    	<wtc:sql><%=sqlStr%></wtc:sql>
                    </wtc:pubselect>
                    <wtc:array id="retArr45" scope="end"/>
                <%
			    String iUseCode = retArr45[0][0];
			    
				sqlStr = "select hand_fee from snewfunctionfee where function_Code ='"+iUseCode+"'";
                //retArray = callView.sPubSelect("1",sqlStr);
                %>
                    <wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode44" retmsg="retMsg44"  outnum="1">
                    	<wtc:sql><%=sqlStr%></wtc:sql>
                    </wtc:pubselect>
                    <wtc:array id="retArr44" scope="end"/>
                <%
                
	            result2 = retArr44;
				if (result2.length==0 || result2[0][0]==""){
					handfee2="0.00";
				}else{
				    handfee2=result2[0][0];
				}
			}
			catch(Exception e){
			    e.printStackTrace();
				System.out.println("��ѯ�����ѳ���!");
			}
		%>
			<td class='blue' nowrap>Ӧ��������</TD>
			<TD>
			<input name="should_handfee" id="should_handfee" value="<%=handfee2%>" readonly class='InputGrey' />
			</TD>
			<td class='blue' nowrap>ʵ��������</TD>
			<TD>
			<input name="real_handfee" id="real_handfee" value="0" v_must=0 v_type=money>
		</TD>
	   </TR>
		   
	<TR >
		<TD class="blue">���ʽ</TD>
		<TD colspan='3'>
			<select name='payType' id='payType' onchange='changePayType()'>
			<option value='1'>�ֽ�</option>
			<option value='2'>֧Ʊ</option>
			</select>
			<font class='orange'>*</font>
		</TD>
	</TR>
	<TR id='checkPayTR' style="display:none"> 
		<TD class="blue">֧Ʊ����</TD>
		<TD class="blue"> 
			<input v_must=0 v_type="0_9" name=checkNo id='checkNo' maxlength=20 onkeyup="if(event.keyCode==13)getBankCode();" index="50">
			<font class='orange'>*</font>
			<input type='button' class='b_text' name=bankCodeQuery   style="cursor:hand" onClick="getBankCode()" value=��ѯ>
		</TD>
                <TD class="blue">���д���</TD>
                <TD nowrap> 
                    <input name=bankCode id='bankCode' size=12 maxlength="12" readonly>
					<input name=bankName id='bankName' size=20 readonly>
                </TD>                                              
            </TR>
			<TR id='checkShow' style='display:none'> 
                  <TD class="blue"> 
                    <div align="left">֧Ʊ����</div>
                  </TD>
            <TD class="blue">
              	    <input v_must=0 v_type=money v_account=subentry name=checkPay id='checkPay' value=0.00 maxlength=15 index="51" >
                    <font class='orange'>*</font>
                    </TD> 
                  <TD class="blue">֧Ʊ���</TD>
                  <TD class="blue"> 
                    <input name="checkPrePay" id='checkPrePay' value=0.00 readonly>
                  </TD>               
            </TR>
	</table>
</div>	
	
<%	
	}
%>





<div id="Operation_Table">
<div class="title">
	<div id="title_zi">��ע��Ϣ</div>
</div>
<table cellspacing="0">
    <tr>
        <td class="blue">��ע��Ϣ</td>
        <td colspan="5">
            <input name="opNote" type="text"  class="InputGrey" id="opNote" size="60" maxlength="10" readonly >  
        </td>
    </tr>	
<table>
</div>
<%
    }
%>
<div id="Operation_Table">
<TABLE cellSpacing=0>
    <TR id="footer">        
        <TD align=center>
        <%
            if ("1".equals(nextFlag)){
        %>
                <input name="next" id="next" class="b_foot"  type=button value="��һ��" onclick="nextStep()" disabled />
        <%
            }else {
        %>
                <input class="b_foot" name="previous" id="previous" type=button value="��һ��" onclick="previouStep()" style="display:none"/>
                <input class="b_foot" name="sure" id="sure" type=button value="ȷ��" onClick="
                if($('#vpmnInputType').val() == 'vpmnFile' || $('#j1InputType').val() == 'j1File' || $('#memberPhoneInputType').val()=='inputFile'){
                    doUpload();
                }else{
                    refMain();
                }
                " />
        <%
            }
        %>
            <input class="b_foot" name='clear' id='clear' type='button' value="���" onClick="resetJsp()" />
            <input class="b_foot" name="close"  onClick="removeCurrentTab()" type=button value="�ر�" />
        </TD>
    </TR>
</table>
<input type='hidden' id='iRegionCode' name='iRegionCode' value='<%=regionCode%>' />
<input type='hidden' id='op_code' name='op_code' value='<%=opCode%>' />
<input type='hidden' id='work_no' name='work_no' value='<%=workNo%>' />
<input type='hidden' id='id_no' name='id_no' value='<%=id_no%>' />
<input type='hidden' id='org_code' name='org_code' value='<%=orgCode%>' />
<input type='hidden' id='grpProductCode' name='grpProductCode' value='' />
<input type='hidden' id='modeCode' name='modeCode' value='<%=(modeCode==null)?"":modeCode%>' />
<input type="hidden" name="nameList">

<input type="hidden" name="nameGroupList">	
<input type="hidden" name="fieldNamesList">
<input name="ZHWW" type="hidden" id="ZHWW" value="0">
<input type="hidden" name="tmpR1" id="tmpR1" value="">
<input type="hidden" name="tmpR2" id="tmpR2" value="">
<input type="hidden" name="tmpR3" id="tmpR3" value="">
<input type="hidden" name="tmpR21" id="tmpR21" value="">
<input type="hidden" name="tmpR22" id="tmpR22" value="">
<input type="hidden" name="request_type1" id="request_type1" value="">
<input type="hidden" name="tmpAddShortNo" id="tmpAddShortNo" value="">
<input type="hidden" name="tmpAddRealNo" id="tmpAddRealNo" value="">
<input type="hidden" name="sys_accept" id="sys_accept" value="<%=sysAccept%>">
<input type='hidden' id='grp_name' name='grp_name' value='<%=iGrpName%>' />
<input type='hidden' id='start_pos' name='start_pos' value='0' />
<input type='hidden' id='end_pos' name='end_pos' value='50' />
<input type='hidden' id='total_num' name='total_num' value='0' />
<input type='hidden' id='page_size' name='page_size' value='50' />  <!-- vpmn��ҳ,ÿҳ��ʾ���� -->
<input type='hidden' id='current_page' name='current_page' value='1' />
<input type='hidden' id='vpmnInputType' name='vpmnInputType' value='vpmnNo' />
<input type='hidden' id='j1InputType' name='j1InputType' value='j1No' />	<!--wanghfa���� j1����BOSS����-->
<input type='hidden' id='memberPhoneInputType' name='memberPhoneInputType' value='singleNo' /><!--diling����-->
<input type='hidden' id='inputFile' name='inputFile' value='' />
<input name="limitcount" type="hidden"  id="limitcount"   value="<%=limitcount%>"> <!--wangzn 091205-->
<input type='hidden' id='mobile_phone' name='mobile_phone' value='' /><!--wuxy 20100331 -->
<input type='hidden' id='phoneHeader' name='phoneHeader' value='<%=phoneHeader%>' />
<input type='hidden' id='busiFlag' name='busiFlag' value='<%=busiFlag%>' />
<input type='hidden' id='isOpenSettledPhoneHidd' name='isOpenSettledPhoneHidd' value='' /> <!-- �Ƿ�ͨ�ƶ��̻�@2014/7/16 -->
<input type='hidden' id='cfmPnoneNo' name='cfmPnoneNo' />

<input type='hidden' id='mm_phoneNoList' name='mm_phoneNoList' />
<input type='hidden' id='mm_phoneType' name='mm_phoneType' value="1" />
<input type='hidden' id='mm_cfm_param_30' name='mm_cfm_param_30' />
<input type='hidden' id='mm_cfm_param_31' name='mm_cfm_param_31' />
<input type='hidden' id='mm_cfm_param_32' name='mm_cfm_param_32' />

<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>
<jsp:include page="/npage/common/pwd_comm.jsp"/>
<!-- 2014/12/26 14:47:50 gaopeng �������ƽ��ģʽ������������Ϣģ���������� ���빫��ҳ�� openType����������ͨ���У��Ͷ����๫��У��-->
<jsp:include page="/npage/public/intf4A/common/intfCommon4A.jsp">
	<jsp:param name="openType" value="SPECIAL"  />
</jsp:include>
<%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>

<script type="text/javascript">
    /*�ύ��f7896_upload.jspҳ�棬�����ϴ��������ϴ��ɹ������refMain()������*/
    function doUpload()
	{
    /*    if(!check(document.all.frm)){
            return false
        }
      */  
        var ind1Str ="";
        var ind2Str ="";
        var ind3Str ="";
        
        var ind1Str2 ="";
        var ind2Str2 ="";
        
        /* vpmnʱ,ƴд���� */
        if(($("#sm_code").val() == "vp" || $("#sm_code").val() == "j1") && $("#request_type").val() == "m02"){
            if($("#vpmnInputType").val() == 'vpmnFile'){
            	
            	//wangzn 091205 Begin
	            if(document.all.limitcount.value=="1"&&document.all.F80004.value=="0")
						  {
								rdShowMessageDialog("�ü������ʷѲ���ʹ�ã���Ϊ���ų�Աѡ������ײ��ʷ�!");
				        return false;
						  }
	            //wangzn 091205 End
	            
                if($("#vpmnPosFile").val() == ""){    //�ļ�¼��
                    rdShowMessageDialog("��ѡ���ļ���",0);
                    $("#vpmnPosFile").focus();
                    return false;
                }
            } else if ($("#j1InputType").val() == 'j1File') {	//wanghfa�޸� j1����BOSS
                if($("#j1PosFile").val() == ""){    //�ļ�¼��
                    rdShowMessageDialog("��ѡ���ļ���",0);
                    $("#j1PosFile").focus();
                    return false;
                }
            } else {
    			var a=0;
    			if( document.all.R0.length == undefined){
    				if( document.all.R0.checked == false){
    					rdShowMessageDialog("����ѡ���ų�Ա!!");
    					return false;
    				}else{
    						ind1Str =ind1Str +document.all.R1.value+"|";
    						ind2Str =ind2Str +document.all.R2.value+"|";
    						ind3Str =ind3Str +document.all.R3.value+"|";
    				}
    				a+=1;
    			}
    			else{
    				
    				for(var i=0; i<document.all.R0.length ;i++){
    					if( document.all.R0[i].checked == true){
    						a+=1;
    						ind1Str =ind1Str +document.all.R1[i].value+"|";
    						ind2Str =ind2Str +document.all.R2[i].value+"|";
    						ind3Str =ind3Str +document.all.R3[i].value+"|";
    					}
    				}
    				if(a==0){
    					rdShowMessageDialog("����ѡ���ų�Ա!!");
    					return false;
    				}
    			}   
    			
                //2.��form�������ֶθ�ֵ
                
                document.all.tmpR1.value = ind1Str;
                document.all.tmpR2.value = ind2Str;
                document.all.tmpR3.value = ind3Str;
            }
        }else if (($("#sm_code").val() == "vp"&&$("#request_type").val() == "m05") || ($("#sm_code").val() == "j1"&&$("#request_type").val() == "m07")){	//wanghfa�޸� 2010-12-14 15:36
            if( dyntb2.rows.length == 2){//������û������
                rdShowMessageDialog("û��ָ����Ա���룬����������!",0);
                return false;
            }else{
                for(var a=1; a<document.all.R20.length ;a++)//ɾ����tr1��ʼ��Ϊ������
                {
                    ind1Str2 =ind1Str2 +document.all.R21[a].value+"|"+document.all.R22[a].value+"&";
                    //if(a>1){ind1Str =ind1Str +"&";}
                    ind2Str2 =ind2Str2 +document.all.R22[a].value+"|";
                }
            }
            document.all.tmpR21.value = ind1Str2;
            document.all.tmpR22.value = ind2Str2;
            
        }else if($("#sm_code").val() == "np"){
            if($("#cycleMoney").val() == ""){
                rdShowMessageDialog("�������Ϊ�գ�",0);
                $("#cycleMoney").focus();
                return false;
            }
            
            if($("#beginDate").val() == ""){
                rdShowMessageDialog("��ʼʱ�䲻��Ϊ�գ�",0);
                $("#beginDate").focus();
                return false;
            }
            
            if($("#endDate").val() == ""){
                rdShowMessageDialog("����ʱ�䲻��Ϊ�գ�",0);
                $("#endDate").focus();
                return false;
            }
            
            if(!forDate($("#beginDate"))){
                rdShowMessageDialog("��ʼʱ���ʽ���ԣ�",0);
                $("#beginDate").focus();
                return false;
            }
            
            if(!forDate($("#endDate"))){
                rdShowMessageDialog("����ʱ���ʽ���ԣ�",0);
                $("#endDate").focus();
                return false;
            }
            
            var vInputType = $("#input_type").val();
            if(document.all.input_type[0].checked){         //����¼��
                if($("#single_phoneno1").val() == ""){
                    rdShowMessageDialog("��Ա�û��ֻ����벻��Ϊ�գ�",0);
                    $("#single_phoneno1").focus();
                    return false;
                }else{
                   
                }
            }else{    //����¼��
                if($("#multi_phoneNo").val() == ""){
                    rdShowMessageDialog("���벻��Ϊ�գ�",0);
                    $("#multi_phoneNo").focus();
                    return false;
                }
            }
           
        }else{
          if((document.all.sm_code.value) != "vp" &&(document.all.sm_code.value) != "np" 
          	&& document.all.sm_code.value != "j1" ){//wanghfa����?2010-12-7 15:38 �����ܻ�����BOSSϵͳ����
            if($("#memberPhoneInputType").val() == 'inputFile'){ //�ļ�¼��
                if($("#memberPosFile").val() == ""){    //�ļ�¼��
                    rdShowMessageDialog("��ѡ���ļ���",0);
                    $("#memberPosFile").focus();
                    return false;
                }
            }else{ //����¼��
              if($("#single_phoneno").val() == ""){
                rdShowMessageDialog("��ѡ���Ա�û��ֻ�����!",0);
                $("#selectNo").focus();
                return false;
              }
            }
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
        }

    		frm.target="hidden_frame";
	        frm.encoding="multipart/form-data";
			frm.action="f7896_upload.jsp";
    		frm.method="post";
    		frm.submit();
    		$("#sure").attr("disabled",true);
    		loading();
	}
	
	
	//liujian 2013-1-15 15:14:35 �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ� begin
		$(function() {
			//���ܲ��ã����Ǹĺã�֮ǰ��fpubDynafields.jsp��Ҫ�ĺöࡣ����
			if('<%=iRequestType%>' == 'm10') {
				var ids = new Array();
		        
				var obj = $('#segMentTab0 tbody');
		        var segment = displayNone(obj,ids);	
		       	segment=segment.replace('colSpan=3','');
		        $('#segMentTab0 tbody').empty().append(segment);
			}
			
			if ($("#sm_code").val() == "RH" && document.all.busiFlag.value == '187'){//�ں�v��У��
			    $('#F70040').change(function(e){
    			    
    			    if ($(this).val() == '0'){
    			        $('#F70049').parents('table:first').hide();
    			    }else {
    			        $('#F70049').parents('table:first').show();
    			    }
    			}).change();
			}
		})
	
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
                sgmHtml.push('<td></td><td></td></tr>');
            }
            return sgmHtml.join('');
        }

        function addSegment($td,segArray) {
           segArray.push($td[0].outerHTML);
        }


    /* liujian 2012-12-24 15:34:48 �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ� ����*/
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
</script>