<%
/********************
 * version v2.0
 * 开发商: si-tech
 * update by hejw @ 2009-01-15 界面改造
 * update by qidp @ 2009-06-12 整合端到端流程
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
        opName="集团产品预销";
        check="checked";
    }else if(opCode.equals("3523")){
        opName="集团产品销户";	
        check1="checked";
    }else{            //diling add@2012/5/14
        opName="集团产品预销恢复";	
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
	
	
	/******* add by qidp @ 2009-06-12 整合端到端流程 *******/
	String in_GrpId = request.getParameter("in_GrpId");
    String in_ChanceId = request.getParameter("wa_no1");
   	System.out.println("gaopengSee=========================in_ChanceId:"+in_ChanceId);
    String in_IdNo = request.getParameter("IdNo");



    String openLabel = "";/*添加标志位，link：走端到端流程通过任务控制进入此订购模块；opcode：不走端到端流程，通过opcode打开此页面。*/
    System.out.println(in_ChanceId);
    System.out.println(in_GrpId);
    System.out.println(in_IdNo);
    /*判断接入此模块的方式，并做相应的处理。*/
    String op_type = "1";
    
    System.out.println( "zhangyan~~~~~in_ChanceId = " + in_ChanceId );
    if(in_ChanceId != null)
    {//由任务管理接入时，商机编码不为空。
		openLabel = "link";
		op_type = request.getParameter("op_type") != null ? request.getParameter("op_type") : "";
		if(op_type.equals("u04"))
		{
			opCode = "3096";
			opName="集团产品预销";
			check="checked";
		}
		else if(op_type.equals("u05"))
		{
			opCode = "3523";
			opName="集团产品销户";	
			check1="checked";
		}
		else if(op_type.equals("u08"))
		{            
			opCode = "e844";
			opName="集团产品预销恢复";	
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
<TITLE>集团产品销户</TITLE>
</HEAD>
<SCRIPT type=text/javascript>
	var returnvalues="0";
onload=function(){
     /*getBeforePrompt(<%=opCode%>);*/
     
     /******* add by qidp @ 2009-06-12 整合端到端流程 *******/
     
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
			/*2013/12/12 13:30:35 gaopeng 端到端集团项目 如果是端到端任务接受过来的，同时是预销恢复的，不展示转存帐户号码 */
			document.all.trAcc.style.display='none';
			
     	}

            //liujian 2013-1-17 17:00:24 关于优化集团客户业务相关系统功能的函 设置确认按钮
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
      * 由任务管理接入时，从销售端获得数据；输入opcode直接进入时，不调用此方法。
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
	    	 System.out.println("TlsPubSelCrm sql1 查询结果为空！");
	    	 
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

function getValue(nameInfo,valueInfo){// 此方法用于根据获得的name和value实现对页面中字段的动态赋值。
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
            rdShowMessageDialog("查询可用预存出错");
            return false;
		}
	}
    //---------------------------------------
    if(retType == "GrpCustInfo") //用户集团用户销户时客户信息查询
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
			showPrtDlg("Detail","确实要打印电子免填单吗？","Yes");
			if (rdShowConfirmDialog("是否提交确认操作？")==1){
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
                rdShowMessageDialog("查询流水出错,请重新获取！");
				return false;
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
	        	//liujian 2013-1-17 14:10:08 关于优化集团客户业务相关系统功能的函 设置pwdCheckStatus为false
	        	//端到端可以不用验证密码
	        	if($('#linkStatus').val() == 'link') {
	        		$('#pwdCheckStatus').val('true');
	        	}else {
	        		$('#pwdCheckStatus').val('false');	
	        	}
    	    	return false;	        	
            } 
            else 
            {
                rdShowMessageDialog("客户密码校验成功！",2);
                if(document.frm.op_code.value=="3096")
                {
                		document.frm.sysnote.value = "对集团["+document.frm.unit_id.value+"]的"+document.frm.product_name.value+"产品预销";
                		document.frm.tonote.value = "对集团["+document.frm.unit_id.value+"]的"+document.frm.product_name.value+"产品预销";
                }
                /*begin add by diling @2012/5/14*/
                if(document.frm.op_code.value=="e844"){
                    document.frm.sysnote.value = "对集团["+document.frm.unit_id.value+"]的"+document.frm.product_name.value+"产品预销恢复";
                		document.frm.tonote.value = "对集团["+document.frm.unit_id.value+"]的"+document.frm.product_name.value+"产品预销恢复";
                }
                /*end add by diling*/
                else 
                {
                		document.frm.sysnote.value = "对集团["+document.frm.unit_id.value+"]的"+document.frm.product_name.value+"产品销户";
                		document.frm.tonote.value = "对集团["+document.frm.unit_id.value+"]的"+document.frm.product_name.value+"产品销户";
              	}
              	//liujian 2013-1-17 13:51:30 关于优化集团客户业务相关系统功能的函 添加预销和销户时对确认按钮的控制
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
            rdShowMessageDialog("客户密码校验出错，请重新校验！",0);
    		return false;
        }
     }
}

//zhangyan调用公共界面,进行转存帐号查询
var params = "";
function qryAcc(){
	var sqlStr = "";
	if(document.frm.acc_id.value.trim().length != 0){
		sqlStr = "90000154";
	}else{
		sqlStr = "90000153";
	}
	params = ""+document.frm.cust_id.value+"|"+document.frm.grp_id.value+"|"+document.frm.acc_id.value.trim()+"|";
	
	var selType = "S";    //'S'单选；'M'多选
	var retQuence = "2|0|1|";//返回字段 
	var fieldName = "转存帐户|资费名称|";//弹出窗口显示的列、列名
	var pageTitle = "转存帐号查询";
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
	
	//liujian 2013-1-17 15:59:17 关于优化集团客户业务相关系统功能的函
	$('#planStatus').val('true');
	setSubmitBtnDisabled();
}
//调用公共界面，进行集团客户选择
function getInfo_Cust()
{
    var pageTitle = "集团客户选择";
    var fieldName = "证件号码|客户ID|客户名称|用户ID|用户编号 |用户名称|产品代码|产品名称|集团ID|付费帐户|品牌名称|品牌代码|APN编号|";
	  var sqlStr = "";
    var selType = "S";    //'S'单选；'M'多选
    var retQuence = "13|0|1|2|3|4|5|6|7|8|9|10|11|12|";
    var retToField = "iccid|cust_id|cust_name|grp_id|user_no|grp_name|product_code|product_name|unit_id|account_id|sm_name|sm_code|apn_no|";
    var cust_id = document.frm.cust_id.value;
    if(document.frm.iccid.value == "" &&
       document.frm.cust_id.value == "" &&
       document.frm.unit_id.value == "" &&
       document.frm.user_no.value == "")
    {
        rdShowMessageDialog("请输入证件号码、集团客户ID、集团编号或集团用户编号进行查询！",0);
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
        rdShowMessageDialog("集团用户编号不能为0！",0);
    	return false;
    }

    PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField);
}

function PubSimpSelCust(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
    var path = "";
    if(document.all.change_II.checked==true){ //预销
		    path = "/npage/s3096/fpubgrpusr_sel.jsp";
    }else if(document.all.change_countRecover.checked==true){ /*add by diling @2012/5/14 */
        path = "/npage/s3096/fpubgrpusr_sel_countRecover.jsp";
    }else{         // 销户
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

//liujian  关于优化集团客户业务相关系统功能的函 添加一个入参
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
	
    
    /**调RPC来回填预存**/
    var rpc_account_id= document.all.account_id.value;
    //alert(rpc_account_id);
    var checkbackfee_Packet = new AJAXPacket("/npage/s3096/backfee.jsp","正在查询预存,请稍候......");
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
			//预销
			//端到端过来也是与预销，所以不用处理，只需判断转存账户号码
			//可退预存是0，则转存帐户号码可以为空
			if(!backprepay || backprepay == '') {
				$('#showMustStatus').attr('style','display:none');	
				$('#planStatus').val('true');
			}else if(backprepay > 0) {
				$('#planStatus').val('false');
				$('#showMustStatus').removeAttr('style');		
			}
			
		}else if(_opCode == '3523') {			
			//销户
			/*
				预销不能存在弹出提示框问题
				只有是销户时，(状态 != '' && 状态 != 'A')时才提示弹出框
				服务那边控制：状态为空则保证转存账户号码也是空
			*/
			if(backprepay > 0 && _status && _status != 'A') {
				setTimeout("showDialog();", 500);
				$('input[name="acc_id"]').focus();
			} else if(_status && _status == 'A'){
				$('input[name="acc_id"]').val(_cardNum);	
			}	
			//可退预存 不是0，则转存帐户号码必须有值，其他不考虑有值与否
			//分为预销和销户
			//预销的时候，只需要判断可退预存是否为0，如果不为0则必须输入转存账户号码
			/*
			销户
			if( 可退预存 > 0 &&  (转存账户号码 == ''  ||   (转存账户号码 != '' && 状态不为A))  {
				不可确认
			}else {
				回显
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
	// 1.查询号码正常 2.校验密码通过，通过隐藏表单
	//设置两个变量：pwdCheckStatus --> 密码是否检验通过，如果通过为true，不通过为false
	//				planStatus 	   --> 检验查询证件号后，回显的数据是否正常，正常为true，否则为false
	var pwdCheckStatus = $('#pwdCheckStatus').val();
	var planStatus = $('#planStatus').val();
	if(pwdCheckStatus == 'true' && planStatus == 'true') {
		$('#sure').removeAttr('disabled');	
	}else {
		$('#sure').attr('disabled','disabled');	
	}
		
}
function showDialog() {
	rdShowMessageDialog("设置的转存账户已失效，请重新查询转存帐户号码！");		
}
function checkVPNValue(packet) {
 var vpnflag = packet.data.findValueByName("vpnflag");
 		if(vpnflag=="1") {//办理VP预销时，需判断是否有短号短信产品，如果有，则提示需先预销短号短信产品，才能办理VP的预销
 		rdShowMessageDialog("请先预销短号短信产品，后办理vp的预销！");
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
    var checkPwd_Packet = new AJAXPacket("/npage/s3096/pubCheckPwd.jsp","正在进行密码校验，请稍候......");
    checkPwd_Packet.data.add("retType","checkPwd");
	  checkPwd_Packet.data.add("cust_id",cust_id);
	  checkPwd_Packet.data.add("Pwd1",Pwd1);
	  core.ajax.sendPacket(checkPwd_Packet);
	  checkPwd_Packet = null ;		
}
function getSysAccept()
{
	var getSysAccept_Packet = new AJAXPacket("/npage/s3096/pubSysAccept.jsp","正在生成操作流水，请稍候......");
	getSysAccept_Packet.data.add("retType","getSysAccept");
	core.ajax.sendPacket(getSysAccept_Packet);
	getSysAccept_Packet =null ;  
}
function showPrtDlg(printType,DlgMessage,submitCfm)
{  //显示打印对话框
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
    	retInfo+="证件号码:"+document.frm.iccid.value+"|";
    	retInfo+="集团客户名称:"+document.frm.cust_name.value+"|";
    	retInfo+="集团产品编号:"+document.frm.user_no.value+"|";
    	retInfo+="帐户ID:"+document.frm.account_id.value+"|";
    	retInfo+="服务品牌:"+document.frm.sm_name.value+"|";
    	retInfo+="集团编号:"+document.frm.unit_id.value+"|";
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
    	retInfo+="业务类型"+document.frm.sm_name.value+document.frm.sysnote.value+"|";
    	retInfo+="流水"+document.frm.login_accept.value+"|";
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
    var checkFlag; //注意javascript和JSP中定义的变量也不能相同,否则出现网页错误.
    //说明检测分成两类,一类是数据是否是空,另一类是数据是否合法.
    if(check(frm))
    {
        if(  document.frm.grp_name.value == "" ){
            rdShowMessageDialog("集团名称"+document.frm.grp_name.value+",必须输入!!");
            document.frm.grp_name.select();
            return false;
        }
        if(  document.frm.grp_id.value == "" ){
            rdShowMessageDialog("集团代码必须输入!!");
            document.frm.grp_id.select();
            return false;
        }
        /* liujian 2013-1-22 14:47:27 关于优化集团客户业务相关系统功能的函
        if (document.all.grpbackprepay.value > 0 && document.all.op_code.value=="3523")
        {
        	rdShowMessageDialog("预存大于0,不允许销户!");
            return false;
        }
        */
        //------wanghyd20120222增加提示需先预销短号短信产品，才能办理VP的预销
        if ( typeof( document.all.change_II ) != "undefined" )
        {
	        if(document.all.change_II.checked==true){
	         var grp_idse = document.all.grp_id.value.trim();
	         //alert(grp_idse);
	          var myPacket = new AJAXPacket("/npage/s3096/checkVPNyx.jsp","正在验证该产品是否为vp产品，并且当前集团有短号短信产品未预销,请稍候......");
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
	
	//liujian 2013-1-17 16:33:35 关于优化集团客户业务相关系统功能的函
	//$('#showMustStatus').css('display','block');
	$('#showMustStatus').removeAttr('style');	
	//端到端过来时，不必输入密码
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
	//liujian 2013-1-15 17:21:36  关于优化集团客户业务相关系统功能的函
	//document.all.trAcc.style.display="none";
	document.all.trAcc.style.display="block";
	$('#showMustStatus').attr('style','display:none');	
	//端到端过来时，不必输入密码
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
	//liujian 2013-1-21 9:06:41 关于优化集团客户业务相关系统功能的函
	//端到端过来时，不必输入密码
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
<input type="hidden" name="login_accept"  value="0"> <!-- 操作流水号 -->
<input type="hidden" name="op_code"  value="<%=opCode%>">
<input type="hidden" name="OrgCode"  value="<%=org_code%>">
<input type="hidden" name="region_code"  value="<%=regionCode%>">
<input type="hidden" name="district_code"  value="<%=districtCode%>">
<input type="hidden" name="WorkNo"   value="<%=workno%>">
<input type="hidden" name="opName" value="<%=opName%>">
<input type="hidden" name="NoPass"   value="<%=nopass%>">
<input type="hidden" name="ip_Addr"  value="<%=ip_Addr%>">
<input type="hidden" name="chanceId"  value="<%=in_ChanceId%>"> <!-- 商机编码，端到端时有值；其他情况为空。add by qidp. -->

		<div class="title">
		<div id="title_zi">集团产品销户</div>
	</div>
        <TABLE cellSpacing="0">
        	
        	<TR>
            <TD class="blue">
              <div align="left">操作类型</div>
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
						out.print("预销"); 
					}
					else if("3523".equals(opCode))
					{
						out.print("<input type='radio' name='change_aa' onClick='change_a()' value='3523' index='3' "+check1+">");
						out.print("销户"); 
					}
					else if("e844".equals(opCode))
					{
						out.print("<input type='radio' name='change_countRecover' onClick='change_countRecoverr()' value='e844' index='4' "+check2+">");
						out.print("预销恢复"); 
					}
				}
				else 
				{
					out.print( "<input type='radio' name='change_II'" );
					out.print(" onClick='change_I()' "+check); 
					out.print(" value='3096'  index='2' >"); 
					out.print("预销"); 
					out.print("<input type='radio' name='change_aa' onClick='change_a()' value='3523' index='3' "+check1+">");
					out.print("销户"); 	
					out.print("<input type='radio' name='change_countRecover' onClick='change_countRecoverr()' value='e844' index='4' "+check2+">");
					out.print("预销恢复"); 									
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
              <div align="left">证件号码</div>
            </TD>
            <TD>
                <input name=iccid  id="iccid" maxlength="18" v_type="string" v_must=1 v_name="证件号码" index="1">
                <input name=custQuery type=button id="custQuery" class="b_text"  onClick="getInfo_Cust();" onKeyUp="if(event.keyCode==13)getInfo_Cust();" style="cursorhand" value=查询>
                <font class="orange">*</font>
            </TD>
            <TD class="blue">集团客户ID</TD>
            <TD>
              <input  type="text" name="cust_id" id = "cust_id" size="20" maxlength="18" v_type="0_9" v_must=1 v_name="客户ID" index="2">
              <font class="orange">*</font>
            </TD>
          </TR>
          <TR>
            <TD class="blue">
               <div align="left">集团编号</div>
            </TD>
            <TD>
		    <input name=unit_id  id="unit_id"  maxlength="10" v_type="0_9" v_must=1 v_name="集团编号" index="3">
            <font class="orange">*</font>
            </TD>
            <TD class="blue">集团产品编号</TD>
            <TD>
              <input  name="user_no" id = "user_no" size="20" v_must=1 v_type=string v_name="集团产品编号" index="4">
              <font class="orange">*</font>
            </TD>
          </TR>
          <TR>
            <TD class="blue">集团客户名称</TD>
            <TD COLSPAN="3">
              <input  name="cust_name" size="20" readonly  Class="InputGrey" v_must=1 v_type=string v_name="客户名称" index="4">
              <font class="orange">*</font>
            </TD>
          </TR>
          <TR>
            <TD class="blue">集团产品ID</TD>
            <TD>
              <input name="grp_id" type="text"  size="20" maxlength="12" readonly   Class="InputGrey" v_type="0_9" v_must=1 v_name="集团用户ID" index="3">
              <font class="orange">*</font>
            </TD>
           <TD class="blue">集团用户名称</TD>
            <TD>
              <input name="grp_name" type="text"  size="20" maxlength="60" readonly  Class="InputGrey" v_must=1 v_maxlength=60 v_type="string" v_name="集团用户名称" index="4">
            <font class="orange">*</font>
            </TD>
          </TR>
          <TR>
            <TD class="blue">产品付费帐户</TD>
            <TD>
              <input name="account_id" type="text"  size="20" maxlength="12" readonly   Class="InputGrey" v_type="0_9" v_must=1 v_name="集团付费帐户" index="5">
              <font class="orange">*</font>
            </TD>
            <TD class="blue">集团主产品</TD>
            <TD>
              <input  type="text" name="product_name" size="20" readonly   Class="InputGrey" v_must=1 v_type="string" v_name="集团主产品" index="6"  Class="InputGrey"> <font class="orange">*</font>
            </TD>
          </TR>
          
          <!--luxc20070205-->
          
          <TR>
            <TD class="blue">可退预存</TD>
            <TD>
              <input name="grpbackprepay" 	id="grpbackprepay" type="text"  size="20" readonly  Class="InputGrey" v_name="可退预存">
            </TD>
            <TD class="blue">不可退预存</TD>
            <TD>
              <input name="grpnobackprepay" type="text"  size="20" readonly  Class="InputGrey" v_name="不可退预存"> 
            </TD>
          </TR>
          
			<TR id="trAcc" >
				<TD class="blue">转存帐户号码</TD>
				<TD colspan='3'>
					<input name="acc_id" type="text"  size="20" >
					<input type='button' id="qryBtn" value='查询' onclick='qryAcc()'  class='b_text'> 
					<font class="orange" id="showMustStatus">*</font>
				</TD>
			</TR> 
                   
          <!--luxc20070205结束-->
          
          <TR>
            <TD class="blue">集团客户密码</TD>
            <TD colspan="3">
				<jsp:include page="/npage/common/pwd_1.jsp">
					<jsp:param name="width1" value="16%"  />
					<jsp:param name="width2" value="34%"  />
					<jsp:param name="pname" value="custPwd"  />
					<jsp:param name="pwd" value=""  />
				</jsp:include>
            <input name=chkPass type=button onClick="check_HidPwd();"  class="b_text" style="cursor:hand" id="chkPass2" value=校验>
            <font class="orange">*</font>
            <input type="hidden" value="false" id="pwdCheckStatus" name="pwdCheckStatus"/><!-- liujian 2013-1-17 13:53:59 关于优化集团客户业务相关系统功能的函添加 -->
            <input type="hidden" value="false" id="planStatus" /><!-- liujian 2013-1-17 13:53:59 关于优化集团客户业务相关系统功能的函添加 -->
            </TD>
          </TR>


           
           
             <TR>
               <TD class="blue">备注信息</TD>
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
              <input class="b_foot" name="sure" id="sure"  type=button value="确认"  onclick="refMain()" disabled >
              <input class="b_foot" name="reset1"  onClick="rstClk()" type=reset value="清除" >
              <input class="b_foot" name="kkkk"  onClick="removeCurrentTab()" type=button value="关闭">
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