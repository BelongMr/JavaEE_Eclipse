<%
/********************
 * version v2.0
 * ������: si-tech
 * update by hejw @ 2009-01-15 �������
 * update by qidp @ 2009-06-12 ���϶˵�������
 ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %> 
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="com.sitech.boss.pub.*" %>
<%@ page import="com.sitech.boss.s1900.config.productCfg" %>
<%@ include file="../../include/remark.htm" %>
<%@ include file="/npage/common/pwd_comm.jsp" %>  
<%
	String opCode = request.getParameter("opCode");
    if(opCode.equals("1111")){
        opCode = "3096";
    }
    System.out.println("****************@@@@@@@@@@@@@@@@@@@@@@@   "+opCode);
    String opName = "";
    String check="";
    String check1="";
    String check2=""; //diling add@2012/5/14
    if(opCode.equals("3096")){
        opName="���Ų�ƷԤ��";
        check="checked";
    }else if(opCode.equals("3523")){
        opName="���Ų�Ʒ����";	
        check1="checked";
    }else{            //diling add@2012/5/14
        opName="���Ų�ƷԤ���ָ�";	
        check2="checked";
    }
%>

<%
    Logger logger = Logger.getLogger("f3096.jsp");

    ArrayList arr = (ArrayList)session.getAttribute("allArr");
    String[][] baseInfo = (String[][])arr.get(0);
    String Department = baseInfo[0][16];
    String districtCode = Department.substring(2,4);
    String[][] pass = (String[][])arr.get(4);

    String nopass  = pass[0][0];

    String ip_Addr = (String)session.getAttribute("ipAddr");
    String workno = (String)session.getAttribute("workNo");
    String workname = (String)session.getAttribute("workName");
    String org_code = (String)session.getAttribute("orgCode");
    String regionCode =(String)session.getAttribute("regCode");
    String password = (String)session.getAttribute("password"); 
    
    String sqlStr = "";
    productCfg prodcfg = new productCfg();
		boolean pwrf=false;
		String[][] temfavStr=(String[][])arr.get(3);
    String[] favStr=new String[temfavStr.length];
    for(int i=0;i<favStr.length;i++)
		{
			 if("a272".equals(temfavStr[i][0].trim()))
			{
				pwrf=true;
				break;
			 }
		}
	
	
	/******* add by qidp @ 2009-06-12 ���϶˵������� *******/
	String in_GrpId = request.getParameter("in_GrpId");
    String in_ChanceId = request.getParameter("wa_no1");
   	System.out.println("gaopengSee=========================in_ChanceId:"+in_ChanceId);
    String in_IdNo = request.getParameter("IdNo");



    String openLabel = "";/*���ӱ�־λ��link���߶˵�������ͨ��������ƽ���˶���ģ�飻opcode�����߶˵������̣�ͨ��opcode�򿪴�ҳ�档*/
    System.out.println(in_ChanceId);
    System.out.println(in_GrpId);
    System.out.println(in_IdNo);
    /*�жϽ����ģ��ķ�ʽ��������Ӧ�Ĵ�����*/
    String op_type = "1";
    
    System.out.println( "zhangyan~~~~~in_ChanceId = " + in_ChanceId );
    if(in_ChanceId != null)
    {//�������������ʱ���̻����벻Ϊ�ա�
		openLabel = "link";
		op_type = request.getParameter("op_type") != null ? request.getParameter("op_type") : "";
		if(op_type.equals("u04"))
		{
			opCode = "3096";
			opName="���Ų�ƷԤ��";
			check="checked";
		}
		else if(op_type.equals("u05"))
		{
			opCode = "3523";
			opName="���Ų�Ʒ����";	
			check1="checked";
		}
		else if(op_type.equals("u08"))
		{            
			opCode = "e844";
			opName="���Ų�ƷԤ���ָ�";	
			check2="checked";
		}        
    }else{
        in_GrpId = "";
        in_ChanceId = "";
        in_IdNo = "";
        openLabel = "opcode";
    }  
    %>
<%  
System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---");
System.out.println( "zhangyan~~~" + opCode);
System.out.println("zhangyan~~~" + opName);
System.out.println("zhangyan~~~" + check);
System.out.println("zhangyan~~~" + in_GrpId);
System.out.println("zhangyan~~~" + in_IdNo);
System.out.println("zhangyan~~~openLabel = " + openLabel);

/******* end of add *******/
%>
<HTML>
<HEAD>
<TITLE>���Ų�Ʒ����</TITLE>
</HEAD>
<SCRIPT type=text/javascript>
	var returnvalues="0";
onload=function(){
     /*getBeforePrompt(<%=opCode%>);*/
     
     /******* add by qidp @ 2009-06-12 ���϶˵������� *******/
     
     <%
        if("link".equals(openLabel)){
        
     %>
     	if ( "u04"==$("#op_type").val() )
     	{
			document.all.op_code.value = "3096";
			document.all.change_II.checked=true;
     	}
     	else if ( "u05"==$("#op_type").val() )
     	{
			document.all.op_code.value = "3523";
			document.all.change_aa.checked=true;     		
     	}
		else if ( "u08"==$("#op_type").val() )
     	{
			document.all.op_code.value = "e844";
			document.all.change_countRecover.checked=true;    
			/*2013/12/12 13:30:35 gaopeng �˵��˼�����Ŀ ����Ƕ˵���������ܹ����ģ�ͬʱ��Ԥ���ָ��ģ���չʾת���ʻ����� */
			document.all.trAcc.style.display='none';
			
     	}

            //liujian 2013-1-17 17:00:24 �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ� ����ȷ�ϰ�ť
            //document.all.sure.disabled=false;
            $('#linkStatus').val('link');
            $('#iccid').addClass('InputGrey');
            $('#unit_id').addClass('InputGrey');
            $('#cust_id').addClass('InputGrey');
            $('#user_no').addClass('InputGrey');
            
            $('#iccid').attr("readOnly" , true);
            $('#unit_id').attr("readOnly" , true);
            $('#cust_id').attr("readOnly" , true);
            $('#user_no').attr("readOnly" , true);
            $('#custQuery').hide();
     <%
        }
     %>
     /**************
      * �������������ʱ�������۶˻�����ݣ�����opcodeֱ�ӽ���ʱ�������ô˷�����
      **************/
     <%
        if("link".equals(openLabel)){
            String[][] allArr = new String[1][14];
            String[][] allArr1 = new String[][]{};
            String[][] allArr2 = new String[][]{};
            String aCcount_id = "";
            String [] paraIn1 = new String[2];
            String [] paraIn2 = new String[2];
            /* modify by qidp @ 2009-11-05
            String sql1 = " SELECT a.id_iccid, a.cust_id, TRIM (b.unit_name), c.id_no, Trim(e.service_no), TRIM (c.user_name), "
                        +" c.product_code, d.product_name, b.unit_id, c.account_id, g.sm_name, "
                        +" trim(to_char(sum(case when j.refund_flag='Y' and end_dt>to_char(sysdate,'yyyymmdd') then nvl(i.prepay_fee, 0) else 0 end),999999999999.99)), "
                        +" trim(to_char(sum(case when j.refund_flag <> 'Y' or j.refund_flag is null or end_dt<to_char(sysdate,'yyyymmdd') then nvl(i.prepay_fee, 0) else 0 end),999999999999.99))  "
                        +" FROM dcustdoc a, dcustdocorgadd b, dgrpusermsg c, sproductcode d, dAccountIdInfo e,ssmproduct f,ssmcode g,dGrpApnMsg h ,dConMsgPre i,sPayType j  "
                        +" WHERE c.product_code = d.product_code AND a.cust_id = b.cust_id and b.cust_id = c.cust_id AND d.product_level = 1  "
                        +" AND d.product_status = 'Y' AND c.bill_date > Last_Day(sysdate) + 1 and c.user_no = e.msisdn  "
                        +" and f.product_code=d.product_code and g.sm_code=f.sm_code and g.region_code=c.region_code  "
                        +" AND c.id_no=h.id_no(+) and c.REGION_CODE='"+regionCode+"' and c.run_code ='A' "
                        +" and b.unit_id = '"+in_GrpId+"' "
                        +" and c.id_no = '"+in_IdNo+"' "
                        +" and i.pay_type = j.pay_type(+)  "
                        +" and i.contract_no = c.account_id  "
                        +" group by a.id_iccid, a.cust_id, TRIM (b.unit_name), c.id_no, Trim(e.service_no),  "
                        +" TRIM (c.user_name), c.product_code, d.product_name, b.unit_id,  "
                        +" c.account_id, g.sm_name,c.user_no,h.apn_no ";
            */
            /* begin modify by wangdana @20100122*/
            /*String sql1 = " SELECT a.id_iccid, a.cust_id, TRIM (b.unit_name), c.id_no, Trim(e.service_no), TRIM (c.user_name),  "
                        + " c.product_code, d.offer_name, b.unit_id, c.account_id, g.sm_name,  "
                        + " trim(to_char(sum(case when j.refund_flag='Y' and end_dt>to_char(sysdate,'yyyymmdd') then nvl(i.prepay_fee, 0) else 0 end),999999999999.99)),  "
                        + " trim(to_char(sum(case when j.refund_flag <> 'Y' or j.refund_flag is null or end_dt<to_char(sysdate,'yyyymmdd') then nvl(i.prepay_fee, 0) else 0 end),999999999999.99))   "
                        + " FROM dcustdoc a, dcustdocorgadd b, dgrpusermsg c, product_offer d, dAccountIdInfo e,band f,ssmcode g  ,dConMsgPre i,sPayType j   "
                        + " WHERE c.product_code = d.offer_id "
                        + " and c.sm_code=f.sm_code and d.band_id = f.band_id and d.offer_attr_type = 'JT' "
                        + " AND a.cust_id = b.cust_id and b.cust_id = c.cust_id "
                        + " AND d.OFFER_TYPE = 10 "
                        + " AND d.STATE = 'A'  AND c.bill_date > Last_Day(sysdate) + 1 "
                        + " and g.region_code=c.region_code "
                        + " and g.sm_code = f.sm_code "
                        + " and c.run_code = 'A'  "
                        + " and c.REGION_CODE='"+regionCode+"'"
                        + " and c.user_no = e.msisdn  "
                        + " and b.unit_id = '"+in_GrpId+"'"
                        + " and c.id_no = '"+in_IdNo+"'"
                        + " and i.pay_type = j.pay_type(+)   "
                        + " and i.contract_no = c.account_id   "
                        + " group by a.id_iccid, a.cust_id, TRIM (b.unit_name), c.id_no, Trim(e.service_no),   "
                        + " TRIM (c.user_name), c.product_code, d.offer_name, b.unit_id,   "
                        + " c.account_id, g.sm_name,c.user_no"; 
                        */
            String sql1 = " SELECT a.id_iccid, to_char(a.cust_id), TRIM (b.unit_name), to_char(c.id_no), Trim(e.service_no), TRIM (c.user_name),  "
                        + " c.product_code, d.offer_name, to_char(b.unit_id), to_char(c.account_id), g.sm_name  "   
                        + " FROM dcustdoc a, dcustdocorgadd b, dgrpusermsg c, product_offer d, dAccountIdInfo e,band f,ssmcode g   "
                        + " WHERE c.product_code = d.offer_id "
                        + " and c.sm_code=f.sm_code and d.band_id = f.band_id and d.offer_attr_type = 'JT' "
                        + " AND a.cust_id = b.cust_id and b.cust_id = c.cust_id "
                        + " AND d.OFFER_TYPE = 10 "
                        + " AND c.bill_date > Last_Day(sysdate) + 1 "
                        + " and g.region_code=c.region_code "
                        + " and g.sm_code = f.sm_code "
                        + " and c.run_code = 'A'  "
                        + " and c.REGION_CODE= :regionCode"
                        + " and c.user_no = e.msisdn  "
                        + " and b.unit_id = :in_GrpId"
                        + " and c.id_no = :in_IdNo"          
                        + " group by a.id_iccid, a.cust_id, TRIM (b.unit_name), c.id_no, Trim(e.service_no),   "
                        + " TRIM (c.user_name), c.product_code, d.offer_name, b.unit_id,   "
                        + " c.account_id, g.sm_name,c.user_no";                            
            System.out.println(" zhangyan sql1=================="+sql1);
            
            String sql2 = " SELECT trim(to_char(sum(case when j.refund_flag='Y' and end_dt>to_char(sysdate,'yyyymmdd') then nvl(i.prepay_fee, 0) else 0 end),999999999999.99)),  "
                        + " trim(to_char(sum(case when j.refund_flag <> 'Y' or j.refund_flag is null or end_dt<to_char(sysdate,'yyyymmdd') then nvl(i.prepay_fee, 0) else 0 end),999999999999.99))   "
                        + " FROM dConMsgPre i,sPayType j   "
                        + " WHERE i.pay_type = j.pay_type(+)   "
                        + " and i.contract_no = :aCcount_id   ";
            System.out.println("sql2=================="+sql2);
            
            paraIn1[0] = sql1;    
           /* paraIn1[1]="regionCode="+"01"+","+"in_GrpId="+"4510845466"+",in_IdNo="+"13013929440"; */
            paraIn1[1]="regionCode="+regionCode+",in_GrpId="+in_GrpId+",in_IdNo="+in_IdNo;              
        %>     
        <wtc:service name="sGrpCustQry" outnum="11" retmsg="msg1" retcode="code1" routerKey="region" routerValue="<%=regionCode%>">
			<wtc:param value="0" />
			<wtc:param value="01" />	
			<wtc:param value="<%=opCode%>" />	
			<wtc:param value="<%=workno%>" />
			<wtc:param value="<%=password%>" />
			<wtc:param value="" />
			<wtc:param value="" />
			<wtc:param value="<%=in_GrpId%>" />
			<wtc:param value="" />
			<wtc:param value="" />
			<wtc:param value="" />
			<wtc:param value="<%=opCode%>" />	
			<wtc:param value="" />	
			<wtc:param value="<%=in_IdNo%>" />	
			<wtc:param value="<%=regionCode%>" />	
			<wtc:param value="" />
			<wtc:param value="" />	
			<wtc:param value="2" />	
			<wtc:param value="" />	
			<wtc:param value="" />			
			<wtc:param value="" />					
			</wtc:service>
	        <wtc:array id="result1" scope="end"/> 
	           
	    <%

	    
		for ( int i = 0 ; i < result1.length ; i ++ )
		{
			for ( int j = 0 ; j < result1[i].length ; j ++ )
			{
				System.out.println( "zhangyan ~~~~~~result1["+i+"]["+j+"] = " + result1[i][j]  );
			}
		}
	    	allArr1 = result1;
	    	 if(allArr1.length==0)
	    	 {
	    	 System.out.println("TlsPubSelCrm sql1 ��ѯ���Ϊ�գ�");
	    	 
	    	 }
	    	else
	    	{
	    	aCcount_id = allArr1[0][9];
	    	
	    	System.out.println("wang3096=======================aCcount_id="+aCcount_id);
	    	paraIn2[0] = sql2; 
            paraIn2[1]="aCcount_id="+aCcount_id;  
            }
	    %>        
            <wtc:service name="TlsPubSelBoss" outnum="2" retmsg="msg2" retcode="code2" >
		    <wtc:param value="<%=paraIn2[0]%>"/>
            <wtc:param value="<%=paraIn2[1]%>"/> 
            </wtc:service>
	        <wtc:array id="result2" scope="end"/> 
        	
        
        <%
            allArr2 = result2;
            if("000000".equals(code1) && allArr1.length>0&&"000000".equals(code2) && allArr2.length>0)
            {
            int len1 = allArr1[0].length;
            System.out.println(len1);
            for(int i=0;i<len1;i++){
	                allArr[0][i] = allArr1[0][i];
	                System.out.println("wang3096=======================allArr1[0]["+i+"]="+allArr1[0][i]);
	           }
	           if("".equals(allArr2[0][0])){
	           	 allArr2[0][0] = "0.00";
	           }
	           if("".equals(allArr2[0][1])){
	           	 allArr2[0][1] = "0.00";
	           }
	           allArr[0][11] = allArr2[0][0];
	           allArr[0][12] = allArr2[0][1];
	          }
	       
	            String valueStr = "";
	            int len = allArr[0].length;
	            for(int i=0;i<len;i++){
	                if(i != len-1){
	                    valueStr += allArr[0][i] + "|";
	                }else{
	                    valueStr += allArr[0][i];
	                }
	    
	              /* end modify by wangdana @20100122*/
	            String nameStr = "iccid|cust_id|cust_name|grp_id|user_no|grp_name|product_code|product_name|unit_id|account_id|sm_name|grpbackprepay|grpnobackprepay";
                
        %>
                getValue("<%=nameStr%>","<%=valueStr%>");
     <%
	        }
        }
     %>
}

function getValue(nameInfo,valueInfo){// �˷������ڸ��ݻ�õ�name��valueʵ�ֶ�ҳ�����ֶεĶ�̬��ֵ��
    var nameArr = nameInfo.split("|");
    var valueArr = valueInfo.split("|");
    for(var i=0;i<nameArr.length;i++){
        document.all(nameArr[i]).value=valueArr[i];
    }
}

/******* end of add *******/

function doProcess(packet)
{
    var retType = packet.data.findValueByName("retType");
    var retCode = packet.data.findValueByName("retCode");
    self.status="";
    
	if(retType == "checkbackfee")
	{
	
		if(retCode=="000000")
		{
			var backprepay   = packet.data.findValueByName("backprepay");
			var nobackprepay = packet.data.findValueByName("nobackprepay");
			document.frm.grpbackprepay.value = backprepay;
			document.frm.grpnobackprepay.value = nobackprepay;

		}
		else
		{
            rdShowMessageDialog("��ѯ����Ԥ�����");
            return false;
		}
	}
    //---------------------------------------
    if(retType == "GrpCustInfo") //�û������û�����ʱ�ͻ���Ϣ��ѯ
    {
        var retname = packet.data.findValueByName("retname");
        if(retCode=="000000")
        {
            document.frm.cust_name.value = retname;
			document.frm.unit_id.focus();
        }
        else
        {
            retMessage = retMessage + "[errorCode1" + retCode + "]";
            rdShowMessageDialog(retMessage,0);
            return false;
        }
     }
	 if(retType == "getSysAccept")
     {
        if(retCode == "000000")
        {
            var sysAccept = packet.data.findValueByName("sysAccept");
			document.frm.login_accept.value=sysAccept;
			showPrtDlg("Detail","ȷʵҪ��ӡ���������","Yes");
			if (rdShowConfirmDialog("�Ƿ��ύȷ�ϲ�����")==1){
			    $("#sure").attr("disabled",true);
				page = "f3096_2.jsp";
				frm.action=page;
				frm.method="post";
				frm.submit();
				loading();
			}
			else return false;
         }
        else
        {
                rdShowMessageDialog("��ѯ��ˮ����,�����»�ȡ��");
				return false;
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
	        	//liujian 2013-1-17 14:10:08 �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ� ����pwdCheckStatusΪfalse
	        	//�˵��˿��Բ�����֤����
	        	if($('#linkStatus').val() == 'link') {
	        		$('#pwdCheckStatus').val('true');
	        	}else {
	        		$('#pwdCheckStatus').val('false');	
	        	}
    	    	return false;	        	
            } 
            else 
            {
                rdShowMessageDialog("�ͻ�����У��ɹ���",2);
                if(document.frm.op_code.value=="3096")
                {
                		document.frm.sysnote.value = "�Լ���["+document.frm.unit_id.value+"]��"+document.frm.product_name.value+"��ƷԤ��";
                		document.frm.tonote.value = "�Լ���["+document.frm.unit_id.value+"]��"+document.frm.product_name.value+"��ƷԤ��";
                }
                /*begin add by diling @2012/5/14*/
                if(document.frm.op_code.value=="e844"){
                    document.frm.sysnote.value = "�Լ���["+document.frm.unit_id.value+"]��"+document.frm.product_name.value+"��ƷԤ���ָ�";
                		document.frm.tonote.value = "�Լ���["+document.frm.unit_id.value+"]��"+document.frm.product_name.value+"��ƷԤ���ָ�";
                }
                /*end add by diling*/
                else 
                {
                		document.frm.sysnote.value = "�Լ���["+document.frm.unit_id.value+"]��"+document.frm.product_name.value+"��Ʒ����";
                		document.frm.tonote.value = "�Լ���["+document.frm.unit_id.value+"]��"+document.frm.product_name.value+"��Ʒ����";
              	}
              	//liujian 2013-1-17 13:51:30 �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ� ����Ԥ��������ʱ��ȷ�ϰ�ť�Ŀ���
              	if(document.frm.op_code.value=="3096" || document.frm.op_code.value=="3523") {
              		$('#pwdCheckStatus').val('true');
              		setSubmitBtnDisabled();
              	}else {
              		document.frm.sure.disabled = false;	
              	} 
            }
         }
        else
        {
            rdShowMessageDialog("�ͻ�����У�������������У�飡",0);
    		return false;
        }
     }
}

//zhangyan���ù�������,����ת���ʺŲ�ѯ
var params = "";
function qryAcc(){
	var sqlStr = "";
	if(document.frm.acc_id.value.trim().length != 0){
		sqlStr = "90000154";
	}else{
		sqlStr = "90000153";
	}
	params = ""+document.frm.cust_id.value+"|"+document.frm.grp_id.value+"|"+document.frm.acc_id.value.trim()+"|";
	
	var selType = "S";    //'S'��ѡ��'M'��ѡ
	var retQuence = "2|0|1|";//�����ֶ� 
	var fieldName = "ת���ʻ�|�ʷ�����|";//����������ʾ���С�����
	var pageTitle = "ת���ʺŲ�ѯ";
	var path = "/npage/public/fPubSimpSel.jsp";
	path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
	path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
	path = path + "&selType=" + selType;
	path += "&params="+params;
	var retInfo = window.showModalDialog(path,"","dialogWidth:70;dialogHeight:35;");
	if(retInfo ==undefined)
	{
		return;
	}
	var retToField="acc_id|";

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
	document.getElementById("acc_id").readOnly = true;
	
	//liujian 2013-1-17 15:59:17 �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ�
	$('#planStatus').val('true');
	setSubmitBtnDisabled();
}
//���ù������棬���м��ſͻ�ѡ��
function getInfo_Cust()
{
    var pageTitle = "���ſͻ�ѡ��";
    var fieldName = "֤������|�ͻ�ID|�ͻ�����|�û�ID|�û���� |�û�����|��Ʒ����|��Ʒ����|����ID|�����ʻ�|Ʒ������|Ʒ�ƴ���|APN���|";
	  var sqlStr = "";
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "13|0|1|2|3|4|5|6|7|8|9|10|11|12|";
    var retToField = "iccid|cust_id|cust_name|grp_id|user_no|grp_name|product_code|product_name|unit_id|account_id|sm_name|sm_code|apn_no|";
    var cust_id = document.frm.cust_id.value;
    if(document.frm.iccid.value == "" &&
       document.frm.cust_id.value == "" &&
       document.frm.unit_id.value == "" &&
       document.frm.user_no.value == "")
    {
        rdShowMessageDialog("������֤�����롢���ſͻ�ID�����ű�Ż����û���Ž��в�ѯ��",0);
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
        rdShowMessageDialog("�����û���Ų���Ϊ0��",0);
    	return false;
    }

    PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
}

function PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
    var path = "";
    if(document.all.change_II.checked==true){ //Ԥ��
		    path = "/npage/s3096/fpubgrpusr_sel.jsp";
    }else if(document.all.change_countRecover.checked==true){ /*add by diling @2012/5/14 */
        path = "/npage/s3096/fpubgrpusr_sel_countRecover.jsp";
    }else{         // ����
        path = "/npage/s3096/fpubgrpusr_sel_3523.jsp";
    }
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType+"&iccid=" + document.all.iccid.value;
    path = path + "&cust_id=" + document.all.cust_id.value;
    path = path + "&unit_id=" + document.all.unit_id.value;
    path = path + "&user_no=" + document.all.user_no.value;
    path = path + "&op_code=" + document.all.op_code.value;

    retInfo = window.open(path,"newwindow","height=550, width=1000,top=0,left=0,scrollbars=yes, resizable=no,location=no, status=yes");
	  return true;
}

//liujian  �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ� ����һ�����
function getvaluecust(retInfo,param)
{
  var retToField = "iccid|cust_id|cust_name|grp_id|user_no|grp_name|product_code|product_name|unit_id|account_id|sm_name|";
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
	
    
    /**��RPC������Ԥ��**/
    var rpc_account_id= document.all.account_id.value;
    //alert(rpc_account_id);
    var checkbackfee_Packet = new AJAXPacket("/npage/s3096/backfee.jsp","���ڲ�ѯԤ��,���Ժ�......");
    checkbackfee_Packet.data.add("retType","checkbackfee");
    checkbackfee_Packet.data.add("account_id",rpc_account_id);
    
	core.ajax.sendPacket(checkbackfee_Packet);
	checkbackfee_Packet = null;
	if(param) {
		var _opCode = param.opCode;
		var _status = param.cardStatus;
		var _cardNum = param.cardNum;
		
		var backprepay = Number($('#grpbackprepay').val());
		if(_opCode == '3096') {
			//Ԥ��
			//�˵��˹���Ҳ����Ԥ�������Բ��ô�����ֻ���ж�ת���˻�����
			//����Ԥ����0����ת���ʻ��������Ϊ��
			if(!backprepay || backprepay == '') {
				$('#showMustStatus').attr('style','display:none');	
				$('#planStatus').val('true');
			}else if(backprepay > 0) {
				$('#planStatus').val('false');
				$('#showMustStatus').removeAttr('style');		
			}
			
		}else if(_opCode == '3523') {			
			//����
			/*
				Ԥ�����ܴ��ڵ�����ʾ������
				ֻ��������ʱ��(״̬ != '' && ״̬ != 'A')ʱ����ʾ������
				�����Ǳ߿��ƣ�״̬Ϊ����֤ת���˻�����Ҳ�ǿ�
			*/
			if(backprepay > 0 && _status && _status != 'A') {
				setTimeout("showDialog();", 500);
				$('input[name="acc_id"]').focus();
			} else if(_status && _status == 'A'){
				$('input[name="acc_id"]').val(_cardNum);	
			}	
			//����Ԥ�� ����0����ת���ʻ����������ֵ��������������ֵ���
			//��ΪԤ��������
			//Ԥ����ʱ��ֻ��Ҫ�жϿ���Ԥ���Ƿ�Ϊ0�������Ϊ0���������ת���˻�����
			/*
			����
			if( ����Ԥ�� > 0 &&  (ת���˻����� == ''  ||   (ת���˻����� != '' && ״̬��ΪA))  {
				����ȷ��
			}else {
				����
			}                                  
			*/
			if(backprepay > 0 && (_cardNum == '' || (_cardNum != '' && _status != 'A'))) {
				$('#planStatus').val('false');
			}else {
				$('#planStatus').val('true');
			}
			setSubmitBtnDisabled();
			if(backprepay > 0) {
				$('#showMustStatus').removeAttr('style');	
			}else {
				$('#showMustStatus').attr('style','display:none');		
			}
		}
	}
}


function setSubmitBtnDisabled() {
	// 1.��ѯ�������� 2.У������ͨ����ͨ�����ر���
	//��������������pwdCheckStatus --> �����Ƿ����ͨ�������ͨ��Ϊtrue����ͨ��Ϊfalse
	//				planStatus 	   --> �����ѯ֤���ź󣬻��Ե������Ƿ�����������Ϊtrue������Ϊfalse
	var pwdCheckStatus = $('#pwdCheckStatus').val();
	var planStatus = $('#planStatus').val();
	if(pwdCheckStatus == 'true' && planStatus == 'true') {
		$('#sure').removeAttr('disabled');	
	}else {
		$('#sure').attr('disabled','disabled');	
	}
		
}
function showDialog() {
	rdShowMessageDialog("���õ�ת���˻���ʧЧ�������²�ѯת���ʻ����룡");		
}
function checkVPNValue(packet) {
 var vpnflag = packet.data.findValueByName("vpnflag");
 		if(vpnflag=="1") {//����VPԤ��ʱ�����ж��Ƿ��ж̺Ŷ��Ų�Ʒ������У�����ʾ����Ԥ���̺Ŷ��Ų�Ʒ�����ܰ���VP��Ԥ��
 		rdShowMessageDialog("����Ԥ���̺Ŷ��Ų�Ʒ�������vp��Ԥ����");
 		document.all.reset1.click();
 		returnvalues="1";
 		}
 		else {
 		}
}
function check_HidPwd()
{
    var cust_id = document.all.cust_id.value;
    var Pwd1 = document.all.custPwd.value;
    var checkPwd_Packet = new AJAXPacket("/npage/s3096/pubCheckPwd.jsp","���ڽ�������У�飬���Ժ�......");
    checkPwd_Packet.data.add("retType","checkPwd");
	  checkPwd_Packet.data.add("cust_id",cust_id);
	  checkPwd_Packet.data.add("Pwd1",Pwd1);
	  core.ajax.sendPacket(checkPwd_Packet);
	  checkPwd_Packet = null ;		
}
function getSysAccept()
{
	var getSysAccept_Packet = new AJAXPacket("/npage/s3096/pubSysAccept.jsp","�������ɲ�����ˮ�����Ժ�......");
	getSysAccept_Packet.data.add("retType","getSysAccept");
	core.ajax.sendPacket(getSysAccept_Packet);
	getSysAccept_Packet =null ;  
}
function showPrtDlg(printType,DlgMessage,submitCfm)
{  //��ʾ��ӡ�Ի���
   var h=200;
   var w=400;
   var t=screen.availHeight/2-h/2;
   var l=screen.availWidth/2-w/2;
   var printStr = printInfo(printType);
   if(printStr == "failed")
   {    return false;   }

   var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:no; resizable:no;location:no;status:no;help:no";
   var path = "/npage/innet/hljPrint.jsp?DlgMsg=" + DlgMessage;
   var path = path + "&printInfo=" + printStr + "&submitCfm=" + submitCfm;
   var ret=window.showModalDialog(path,"",prop);
}
	 
function printInfo(printType)
{ 
		var retInfo = "";
 		retInfo+='<%=workname%>'+"|";
    	retInfo+='<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
    	retInfo+="֤������:"+document.frm.iccid.value+"|";
    	retInfo+="���ſͻ�����:"+document.frm.cust_name.value+"|";
    	retInfo+="���Ų�Ʒ���:"+document.frm.user_no.value+"|";
    	retInfo+="�ʻ�ID:"+document.frm.account_id.value+"|";
    	retInfo+="����Ʒ��:"+document.frm.sm_name.value+"|";
    	retInfo+="���ű��:"+document.frm.unit_id.value+"|";
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
    	retInfo+="ҵ������"+document.frm.sm_name.value+document.frm.sysnote.value+"|";
    	retInfo+="��ˮ"+document.frm.login_accept.value+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=""+"|";
    	retInfo+=document.all.tonote.value+"|";
		 return retInfo;
}
function refMain(){
	//getAfterPrompt();
    var checkFlag; //ע��javascript��JSP�ж���ı���Ҳ������ͬ,���������ҳ����.
    //˵�����ֳ�����,һ���������Ƿ��ǿ�,��һ���������Ƿ�Ϸ�.
    if(check(frm))
    {
        if(  document.frm.grp_name.value == "" ){
            rdShowMessageDialog("��������"+document.frm.grp_name.value+",��������!!");
            document.frm.grp_name.select();
            return false;
        }
        if(  document.frm.grp_id.value == "" ){
            rdShowMessageDialog("���Ŵ����������!!");
            document.frm.grp_id.select();
            return false;
        }
        /* liujian 2013-1-22 14:47:27 �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ�
        if (document.all.grpbackprepay.value > 0 && document.all.op_code.value=="3523")
        {
        	rdShowMessageDialog("Ԥ�����0,����������!");
            return false;
        }
        */
        //------wanghyd20120222������ʾ����Ԥ���̺Ŷ��Ų�Ʒ�����ܰ���VP��Ԥ��
        if ( typeof( document.all.change_II ) != "undefined" )
        {
	        if(document.all.change_II.checked==true){
	         var grp_idse = document.all.grp_id.value.trim();
	         //alert(grp_idse);
	          var myPacket = new AJAXPacket("/npage/s3096/checkVPNyx.jsp","������֤�ò�Ʒ�Ƿ�Ϊvp��Ʒ�����ҵ�ǰ�����ж̺Ŷ��Ų�ƷδԤ��,���Ժ�......");
	          myPacket.data.add("grp_id",grp_idse);
	          core.ajax.sendPacket(myPacket,checkVPNValue);
	          myPacket = null;
	        }
	        if(returnvalues=="1") {
	          returnvalues="0";
	        	return false;
	        }
        }

		getSysAccept();
		/*
        page = "f3096_2.jsp";
        frm.action=page;
        frm.method="post";
        frm.submit();
		*/
    }   
}
function change_I()
{
	document.all.reset1.click();
	document.all.change_II.checked=true;
	document.all.change_aa.checked=false;
	document.all.change_countRecover.checked=false;//diling add@2012/5/14
	document.all.op_code.value=document.all.change_II.value;
	document.all.trAcc.style.display="";
	
	//liujian 2013-1-17 16:33:35 �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ�
	//$('#showMustStatus').css('display','block');
	$('#showMustStatus').removeAttr('style');	
	//�˵��˹���ʱ��������������
	if('<%=openLabel%>' == 'link') {
		$('#pwdCheckStatus').val('true');	
	}else {
		$('#pwdCheckStatus').val('false');	
	}
	$('#planStatus').val('false');
	$('#sure').attr('disabled',true);
	//alert(document.all.op_code.value);
	//getBeforePrompt(document.all.op_code.value);
}
function change_a()
{
	//alert("change_a");
	document.all.reset1.click();
	document.all.change_aa.checked=true;
	document.all.change_II.checked=false;
	document.all.change_countRecover.checked=false;//diling add@2012/5/14
	document.all.op_code.value=document.all.change_aa.value;
	//liujian 2013-1-15 17:21:36  �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ�
	//document.all.trAcc.style.display="none";
	document.all.trAcc.style.display="block";
	$('#showMustStatus').attr('style','display:none');	
	//�˵��˹���ʱ��������������
	if('<%=openLabel%>' == 'link') {
		$('#pwdCheckStatus').val('true');	
	}else {
		$('#pwdCheckStatus').val('false');	
	}
	$('#planStatus').val('false');
	$('#sure').attr('disabled',true);
	//alert(document.all.op_code.value);
	//getBeforePrompt(document.all.op_code.value);
}

/*add by diling */
function change_countRecoverr(){
  document.all.reset1.click();
  document.all.trAcc.style.display="none";
	document.all.change_II.checked=false;
	document.all.change_aa.checked=false;
	document.all.change_countRecover.checked=true;
	document.all.op_code.value=document.all.change_countRecover.value;
}

function rstClk()
{	
	document.all.trAcc.style.display="";	
	//liujian 2013-1-21 9:06:41 �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ�
	//�˵��˹���ʱ��������������
	if('<%=openLabel%>' == 'link') {
		$('#pwdCheckStatus').val('true');	
	}else {
		$('#pwdCheckStatus').val('false');	
	}
	$('#planStatus').val('false');
	$('#sure').attr('disabled',true);
	
}

</script>
<BODY>
<FORM action="" method="post" name="frm" >
<%@ include file="/npage/include/header.jsp" %>
<input type="hidden" name="product_code" value="">
<input type="hidden" name="product_level"  value="1">
<input type="hidden" id="op_type" name="op_type" value="<%=op_type%>">
<input type="hidden" name="grp_no" value="0">
<input type="hidden" name="tfFlag" value="n">
<input type="hidden" name="chgpkg_day"   value="">
<input type="hidden" name="TCustId"  value="">
<input type="hidden" name="unit_name"  value="">
<input type="hidden" name="login_accept"  value="0"> <!-- ������ˮ�� -->
<input type="hidden" name="op_code"  value="<%=opCode%>">
<input type="hidden" name="OrgCode"  value="<%=org_code%>">
<input type="hidden" name="region_code"  value="<%=regionCode%>">
<input type="hidden" name="district_code"  value="<%=districtCode%>">
<input type="hidden" name="WorkNo"   value="<%=workno%>">
<input type="hidden" name="opName" value="<%=opName%>">
<input type="hidden" name="NoPass"   value="<%=nopass%>">
<input type="hidden" name="ip_Addr"  value="<%=ip_Addr%>">
<input type="hidden" name="chanceId"  value="<%=in_ChanceId%>"> <!-- �̻����룬�˵���ʱ��ֵ���������Ϊ�ա�add by qidp. -->

		<div class="title">
		<div id="title_zi">���Ų�Ʒ����</div>
	</div>
        <TABLE cellSpacing="0">
        	
        	<TR>
            <TD class="blue">
              <div align="left">��������</div>
            </TD>
            <TD>
				<%
				if ( "link".equals(openLabel) )
				{
					if("3096".equals(opCode))
					{
						out.print( "<input type='radio' name='change_II'" );
						out.print(" onClick='change_I()' "+check); 
						out.print(" value='3096'  index='2' >"); 
						out.print("Ԥ��"); 
					}
					else if("3523".equals(opCode))
					{
						out.print("<input type='radio' name='change_aa' onClick='change_a()' value='3523' index='3' "+check1+">");
						out.print("����"); 
					}
					else if("e844".equals(opCode))
					{
						out.print("<input type='radio' name='change_countRecover' onClick='change_countRecoverr()' value='e844' index='4' "+check2+">");
						out.print("Ԥ���ָ�"); 
					}
				}
				else 
				{
					out.print( "<input type='radio' name='change_II'" );
					out.print(" onClick='change_I()' "+check); 
					out.print(" value='3096'  index='2' >"); 
					out.print("Ԥ��"); 
					out.print("<input type='radio' name='change_aa' onClick='change_a()' value='3523' index='3' "+check1+">");
					out.print("����"); 	
					out.print("<input type='radio' name='change_countRecover' onClick='change_countRecoverr()' value='e844' index='4' "+check2+">");
					out.print("Ԥ���ָ�"); 									
				}
            /*end add by diling*/
          %>
					
            </TD>
            <TD>
               &nbsp;
            </TD>
            <TD>
            	  &nbsp;
            </TD>
        	</TR>
        	
          <TR>
           <TD class="blue">
              <div align="left">֤������</div>
            </TD>
            <TD>
                <input name=iccid  id="iccid" maxlength="18" v_type="string" v_must=1 v_name="֤������" index="1">
                <input name=custQuery type=button id="custQuery" class="b_text"  onClick="getInfo_Cust();" onKeyUp="if(event.keyCode==13)getInfo_Cust();" style="cursorhand" value=��ѯ>
                <font class="orange">*</font>
            </TD>
            <TD class="blue">���ſͻ�ID</TD>
            <TD>
              <input  type="text" name="cust_id" id = "cust_id" size="20" maxlength="18" v_type="0_9" v_must=1 v_name="�ͻ�ID" index="2">
              <font class="orange">*</font>
            </TD>
          </TR>
          <TR>
            <TD class="blue">
               <div align="left">���ű��</div>
            </TD>
            <TD>
		    <input name=unit_id  id="unit_id"  maxlength="10" v_type="0_9" v_must=1 v_name="���ű��" index="3">
            <font class="orange">*</font>
            </TD>
            <TD class="blue">���Ų�Ʒ���</TD>
            <TD>
              <input  name="user_no" id = "user_no" size="20" v_must=1 v_type=string v_name="���Ų�Ʒ���" index="4">
              <font class="orange">*</font>
            </TD>
          </TR>
          <TR>
            <TD class="blue">���ſͻ�����</TD>
            <TD COLSPAN="3">
              <input  name="cust_name" size="20" readonly  Class="InputGrey" v_must=1 v_type=string v_name="�ͻ�����" index="4">
              <font class="orange">*</font>
            </TD>
          </TR>
          <TR>
            <TD class="blue">���Ų�ƷID</TD>
            <TD>
              <input name="grp_id" type="text"  size="20" maxlength="12" readonly   Class="InputGrey" v_type="0_9" v_must=1 v_name="�����û�ID" index="3">
              <font class="orange">*</font>
            </TD>
           <TD class="blue">�����û�����</TD>
            <TD>
              <input name="grp_name" type="text"  size="20" maxlength="60" readonly  Class="InputGrey" v_must=1 v_maxlength=60 v_type="string" v_name="�����û�����" index="4">
            <font class="orange">*</font>
            </TD>
          </TR>
          <TR>
            <TD class="blue">��Ʒ�����ʻ�</TD>
            <TD>
              <input name="account_id" type="text"  size="20" maxlength="12" readonly   Class="InputGrey" v_type="0_9" v_must=1 v_name="���Ÿ����ʻ�" index="5">
              <font class="orange">*</font>
            </TD>
            <TD class="blue">��������Ʒ</TD>
            <TD>
              <input  type="text" name="product_name" size="20" readonly   Class="InputGrey" v_must=1 v_type="string" v_name="��������Ʒ" index="6"  Class="InputGrey"> <font class="orange">*</font>
            </TD>
          </TR>
          
          <!--luxc20070205-->
          
          <TR>
            <TD class="blue">����Ԥ��</TD>
            <TD>
              <input name="grpbackprepay" 	id="grpbackprepay" type="text"  size="20" readonly  Class="InputGrey" v_name="����Ԥ��">
            </TD>
            <TD class="blue">������Ԥ��</TD>
            <TD>
              <input name="grpnobackprepay" type="text"  size="20" readonly  Class="InputGrey" v_name="������Ԥ��"> 
            </TD>
          </TR>
          
			<TR id="trAcc" >
				<TD class="blue">ת���ʻ�����</TD>
				<TD colspan='3'>
					<input name="acc_id" type="text"  size="20" >
					<input type='button' id="qryBtn" value='��ѯ' onclick='qryAcc()'  class='b_text'> 
					<font class="orange" id="showMustStatus">*</font>
				</TD>
			</TR> 
                   
          <!--luxc20070205����-->
          
          <TR>
            <TD class="blue">���ſͻ�����</TD>
            <TD colspan="3">
				<jsp:include page="/npage/common/pwd_1.jsp">
					<jsp:param name="width1" value="16%"  />
					<jsp:param name="width2" value="34%"  />
					<jsp:param name="pname" value="custPwd"  />
					<jsp:param name="pwd" value=""  />
				</jsp:include>
            <input name=chkPass type=button onClick="check_HidPwd();"  class="b_text" style="cursor:hand" id="chkPass2" value=У��>
            <font class="orange">*</font>
            <input type="hidden" value="false" id="pwdCheckStatus" name="pwdCheckStatus"/><!-- liujian 2013-1-17 13:53:59 �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ����� -->
            <input type="hidden" value="false" id="planStatus" /><!-- liujian 2013-1-17 13:53:59 �����Ż����ſͻ�ҵ�����ϵͳ���ܵĺ����� -->
            </TD>
          </TR>


           
           
             <TR>
               <TD class="blue">��ע��Ϣ</TD>
               <TD  colspan="3">
               	<input  name="tonote" size="60" type="hidden">
               <input  name="sysnote" size="60" readonly class="InputGrey">
               </TD>
           </TR>
           
       </TABLE>

        <TABLE cellSpacing="0">
          <TBODY>
            <TR>
              <TD id="footer" align=center >
              <input class="b_foot" name="sure" id="sure"  type=button value="ȷ��"  onclick="refMain()" disabled >
              <input class="b_foot" name="reset1"  onClick="rstClk()" type=reset value="���" >
              <input class="b_foot" name="kkkk"  onClick="removeCurrentTab()" type=button value="�ر�">
              </TD>
			  <input  type="hidden" name="sm_name"  value="">
			  <input  type="hidden" name="linkStatus"  id="linkStatus" value="">
            </TR>
          </TBODY>
        </TABLE>

	 <%@ include file="/npage/include/footer.jsp" %>
</form>
</BODY>
</HTML>
	        <div id="relationArea" style="display:none"></div>
				<div id="wait" style="display:none">
				<img  src="/nresources/default/images/blue-loading.gif" />
			</div>
			<div id="beforePrompt"></div>
		</DIV>             
</DIV>

<script>
	$(function() {
		if($('#linkStatus').val() == 'link') {
			var _backprepay = Number($('#grpbackprepay').val());
            if(_backprepay) {
            	if(_backprepay == 0) {
            		$('#planStatus').val('true');
	            	document.all.sure.disabled=false;	
	            }else if(_backprepay > 0 && $('#acc_id').val()) {
	            	$('#planStatus').val('true');
	            	document.all.sure.disabled=false;		
	            }	
            }else {
            	$('#planStatus').val('true');
            	document.all.sure.disabled=false;		
            }
            $('#pwdCheckStatus').val('true');
		}
	})	
</script>	