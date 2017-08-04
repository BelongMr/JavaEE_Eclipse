<%
    /********************
     * @ OpCode    :  7892
     * @ OpName    :  组合营销集团成员增加
     * @ CopyRight :  si-tech
     * @ Author    :  wangzn
     * @ Date      :  2010-4-20 14:15:36
     * @ Update    :  
     ********************/ 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.GregorianCalendar" %>
<%
    String opCode = "7482";
    String opName = "组合营销集团成员增加";
    
    String workNo =(String)session.getAttribute("workNo");
		String workName =(String)session.getAttribute("workName");
		String powerRight =(String)session.getAttribute("powerRight");
		String Role =(String)session.getAttribute("Role");
		String orgCode =(String)session.getAttribute("orgCode");
		String regionCode = orgCode.substring(0,2);
		String groupId =(String)session.getAttribute("groupId");
		String ip_Addr =(String)session.getAttribute("ip_Addr");
		String belongCode =orgCode.substring(0,7);
		String districtCode =orgCode.substring(2,4);
		
		String action = WtcUtil.repNull((String)request.getParameter("action"));
		String packetCode = WtcUtil.repNull((String)request.getParameter("packet_code"));
		String unitId = WtcUtil.repNull((String)request.getParameter("unit_id"));
		String productName = WtcUtil.repNull((String)request.getParameter("product_name"));
		String iccid = WtcUtil.repNull((String)request.getParameter("iccid"));
		//yuanqs add 2010/9/9 10:43:52 begin 
		String password = (String)session.getAttribute("password");
		String unit_id_q = WtcUtil.repNull((String)request.getParameter("unit_id_q"));
		String packet_code = WtcUtil.repNull((String)request.getParameter("packet_code"));
		
		    /*begin wanghyd add for 判断是否有优惠类操作权限@2012/11/6 */
  String[][] temfavStr = (String[][])session.getAttribute("favInfo");
	String[] favStr = new String[temfavStr.length];
	boolean operFlag = false;
	for(int i = 0; i < favStr.length; i ++) {
		favStr[i] = temfavStr[i][0].trim();
	}
	if (WtcUtil.haveStr(favStr, "a385")) {
		operFlag = true;
	}
	
	
	 /*end wanghyd add @2012/11/6 */
	 
		System.out.println("===============" + unit_id_q + "===========" +packet_code + "=======yuanqs");
		String[][] smCodeArr = null;
		
		String packet_code_is_600001 = "0";
		
		boolean j1Flag = false;
		if("step1".equals(action)) {
		%>
				<wtc:service name="s7482Qry" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode" retmsg="retMsg" outnum="14">
				<wtc:param value="<%=workNo%>"/>
				<wtc:param value="<%=password%>"/>
				<wtc:param value="<%=orgCode%>"/>
				<wtc:param value="<%=ip_Addr%>"/>
				<wtc:param value="<%=unit_id_q%>"/>
				<wtc:param value="<%=packet_code%>"/>
				</wtc:service>
			<wtc:array id="smCodeArr_ret" scope="end"/>
		<%  
			smCodeArr = (String[][])smCodeArr_ret;
			System.out.println("======length=====" + smCodeArr.length + "================yuanqs");
			for(int i=0; i<smCodeArr.length; i++) {
					for(int j=0; j<smCodeArr[i].length; j++) {
							System.out.println("===========" + smCodeArr[i][j] + "================yuanqs");
							//liujian 
							if(smCodeArr[i][0].equals("j1")) {
					        	j1Flag = true;
					        }
					}
			}
			System.out.println(retCode + "+++++++yuanqs");
			if(!"000000".equals(retCode)) {
			%>
				<script>
					rdShowMessageDialog("<%=retCode%>" + ": " + "<%=retMsg%>" +"！");
					window.location="f7482_1.jsp"
				</script>
			<%
			}
			
			
						String packet_code_sql = "SELECT count(*) 		FROM pd_unicodedef_dict 	WHERE code_class = :In_PacketCode";
			String packet_code_sql_param = "In_PacketCode="+packet_code;
%>
  <wtc:service name="TlsPubSelCrm" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=packet_code_sql%>" />
		<wtc:param value="<%=packet_code_sql_param%>" />	
	</wtc:service>
	<wtc:array id="result_packet_code" scope="end"   />

<%			
if(result_packet_code.length>0){
	packet_code_is_600001 = result_packet_code[0][0];
}
System.out.println("-----------hejwa------packet_code_is_600001-------------------->"+packet_code_is_600001);
	
		}
	//yuanqs add 2010/9/9 10:44:02 end
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
 <title>组合营销集团成员增加</title>
 <script type=text/javascript>
 	  var dynTbIndex=1;				//用于动态表数据的索引位置,开始值为1.考虑表头
    var oprType_Add = "a";
    onload=function(){
        	$("#divUnitId1").show();
        	$("#divUnitId2").hide();
     };
 	  $(document).ready(function (){
 	  	if('step1'=='<%=action%>'){
 	  		$("#unit_id").val('<%=request.getParameter("unit_id")%>');
 	  		$("#unit_name").val('<%=request.getParameter("unit_name")%>');
 	  		
 	  		$("#unit_id_qry").css("display","none");
 	  		
 	  		$("#divUnitId1").hide();
        $("#divUnitId2").show();
 	  	}
 	  });
 	
 	
 	
    function resetJsp(){
      window.location='f7482_1.jsp';
    }
    function getProInfo(){
    	var unitId = $("#unit_id_q").val().trim();
    	var custId = $("#cust_id").val().trim();
    	
    	if(unitId==""&&custId==""){
    		rdShowMessageDialog('请填写查询条件！',0);
    		return;
    	}
      
      var sqlStr = "";
	  var params_="";
	  var outNum = "";
	
      if(unitId!=''){
      	sqlStr = "90000211";
		params_ = unitId + "|";
		outNum = "4";
      }
      if(custId!=''){
      	sqlStr = "90000212";
		params_ = custId + "|";
		outNum = "4";
      }
	  var selType = "S";    //'S'单选；'M'多选
	  var retQuence = "0|1|2|3|";//返回字段
	  var fieldName = "集团编号|集团名称|彩铃产品id|智能网产品id|";//弹出窗口显示的列、列名
      var pageTitle = "集团产品信息查询";
      var retToField="unit_id|unit_name|cr_id_no|vp_id_no|";
      
      var path = "fPubSimpSel.jsp";
      path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
      path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
      path = path + "&selType=" + selType;
	  path = path + "&params=" + params_ + "&outNum="+outNum;
	  
      var retInfo = window.showModalDialog(path,"","dialogWidth:70;dialogHeight:35;");
      if(retInfo ==undefined){
      	return;
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
    function addMemb(){
    	if(!checkElement(document.getElementById('phone_no'))) return;
    	var phoneNo = $("#phone_no").val().trim();
    	
    	window.open("f7482_addMemb_1.jsp?phoneNo="+phoneNo);
    	//var retInfo = window.showModalDialog                                                         
      //    (                                                                                            
      //    "f7482_addMemb_1.jsp?phoneNo="+phoneNo,                                                                 
      //    window,                                                                                    
      //    'dialogHeight:550px; dialogWidth:750px;scrollbars:yes;resizable:no;location:no;status:no'
      //    );
      //alert(retInfo);
    }
    function chectUnit1(){
    	var unitId = $("#unit_id").val().trim();	
    	var packetCode = $("#packet_code").val().trim();
    	var params_=unitId+"|"+packetCode+"|";
		var outNum = "2";
    	var sqlBuf = "90000225";
    	
      var myPacket = new AJAXPacket("../s7983/CallCommONESQL.jsp","正在验证集团产品，请稍候......");
      myPacket.data.add("verifyType","unitId1");
	  myPacket.data.add("sqlBuf",sqlBuf);
	  myPacket.data.add("params",params_);
	  myPacket.data.add("recv_number",outNum);
      core.ajax.sendPacket(myPacket);
      myPacket=null;	
    }
    function getUnitInfo(){
    	var unitId = $("#unit_id_q").val().trim();
    	
    	if(unitId==""){
    		rdShowMessageDialog('请填写查询条件！',0);
    		return;
    	}
      
	  var params_=unitId+"|";
	  var outNum = "3";
      var sqlStr = "90000213";
      
	  var selType = "S";    //'S'单选；'M'多选
	  var retQuence = "0|1|2|";//返回字段
	  var fieldName = "集团编号|集团名称|证件号码|";//弹出窗口显示的列、列名
      var pageTitle = "集团选择";
      var retToField="unit_id|unit_name|iccid|";
      
      var path = "fPubSimpSel.jsp";
      path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
      path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
      path = path + "&selType=" + selType;
	  path = path + "&params=" + params_ + "&outNum="+outNum;
	  
     // alert(path);
      var retInfo = window.showModalDialog(path,"","dialogWidth:70;dialogHeight:35;");
      if(retInfo ==undefined){
      	return;
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
    
      
       $("#next").attr("disabled",false);
    	
    }
    function doNext(){
    	//yuanqs add 2010/9/9 9:36:09 begin
    	 document.frm.action="f7482_1.jsp?action=step1";
       document.frm.submit();	
    	//chectUnit1();
    	//yuanqs add 2010/9/9 9:36:25 end
    //$("#product_name").val($('#packet_code option:selected').text());
    //document.frm.action="f7482_1.jsp?action=step1";
    //document.frm.submit();
    	
    }
    
    var j_feeCode = "";//记录点了哪行
    
    function setProAttr(smCode,smName,feeCode){
    	j_feeCode = feeCode;
    	var idNo = $('#idNo'+smCode).val();
    	if(idNo==""){
    		rdShowMessageDialog("请选择"+smName+"产品！");
    		return;
    	}
    	var unitId = $('#unit_id').val();
    	var unitName = $('#unit_name').val();
    	
    	window.open("f7482_addProAttr_1.jsp?action=next&id_no="+idNo+"&unit_id="+unitId+"&sm_code="+smCode+"&sm_name="+smName+"&feeCode="+feeCode);

    	//alert("idNo["+idNo+"];unitId["+unitId+"]");
    	
    	//var retInfo = window.showModalDialog                                                         
      //    (                                                                                            
      //    "f7482_addProAttr_1.jsp?idNo="+idNo+"&unitId"+unitId+"&smCode"+smCode,                                                                 
      //    window,                                                                                    
      //    'dialogHeight:550px; dialogWidth:750px;scrollbars:yes;resizable:no;location:no;status:no'
      //    );
      //$('#loginAccept_'+smCode).val(retInfo);
      
    	
    }
    /*begin diling add for 目前占比、上限占比、可添加智能网成员数@2012/6/12*/
    function setProAttrVp(smCode,smName,feeCode,preProportion,highestLimit,addVpMember,regionName){
    	j_feeCode = feeCode;
      $("#addVpMemberHiden").val(addVpMember); //可添加vpmn成员人数
      $("#smCodeHiden").val(smCode); 
      $("#regionNameHiden").val(regionName);
      var idNo = $('#idNo'+smCode).val();
    	if(idNo==""){
    		rdShowMessageDialog("请选择"+smName+"产品！");
    		return;
    	}
    	var unitId = $('#unit_id').val();
    	var unitName = $('#unit_name').val();
    	
    	window.open("f7482_addProAttr_1.jsp?action=next&id_no="+idNo+"&unit_id="+unitId+"&sm_code="+smCode+"&sm_name="+smName+"&feeCode="+feeCode+"&preProportion="+preProportion+"&highestLimit="+highestLimit+"&addVpMember="+addVpMember);

    }
    /*end diling add@2012/6/12*/
    function getRtnAccept(smCode,retAccept){
    	if("step1"=="<%=action%>"&&"0"!="<%=packet_code_is_600001%>"){
				$("input[v_feeCode='"+j_feeCode+"']").val(retAccept);
    	}else{
    		//原逻辑
    		$('#loginAccept_'+smCode).val(retAccept);
    	}
    }
    
    function check_phone()
    {
		var params_=document.frm.ISDNNO.value+"|";
		var outNum = "1";
        var sqlBuf="90000226";
        var myPacket = new AJAXPacket("../s7983/CallCommONESQL.jsp","正在验证用户号码，请稍候......");
        if(!checkElement(document.frm.PHONENO)) return false;
        if(!checkElement(document.all.ISDNNO)) return false;
        myPacket.data.add("verifyType","phoneno");
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
    
    function check_nomobile_phone()
    {
        var sqlBuf="90000227";
		var params_=document.frm.ISDNNO.value+"|";
		var outNum = "1";
        var myPacket = new AJAXPacket("../s7983/CallCommONESQL.jsp","正在验证用户号码，请稍候......");
        if(!checkElement(document.frm.PHONENO)) return false;
        if(!checkElement(document.all.ISDNNO)) return false;
        myPacket.data.add("verifyType","phonenoMobile");
		myPacket.data.add("sqlBuf",sqlBuf);
		myPacket.data.add("params",params_);
        myPacket.data.add("recv_number",outNum);
        core.ajax.sendPacket(myPacket);
        myPacket=null;			
    }
     function dynAddRow()
    {
        var phone_no="";
        var isdn_no="";
        var user_name="";
        var id_card="";
        var note="";
        var add_no="";
        var tmpStr="";
        var flag=false;
        
        var op_type = oprType_Add;
        
        if( op_type == oprType_Add)
        {
            phone_no = document.all.PHONENO.value;
            isdn_no = document.all.ISDNNO.value;
            
            if(!checkElement(document.all.PHONENO)) return false;
            if(!checkElement(document.all.ISDNNO)) return false;
        }
        
        user_name = document.all.USERNAME.value;
        id_card = document.all.IDCARD.value;
        note = document.all.PCOMMENT.value;
        queryAddAllRow(0,phone_no,isdn_no,user_name,id_card,note);
    }
    function queryAddAllRow(add_type,phone_no,isdn_no,user_name,id_card,note)
    {
        var tr1="";
        var i=0;
        var tmp_flag=false;
        
        var exec_status="";
        if ( parseInt(document.all.addRecordNum.value) > 9 )
        {
            rdShowMessageDialog("最多只能操作10个号码 !!");
            return false;
        }
        /*begin diling add for 判断新增vpmn成员人数不能超过可添加智能网成员数@2012/6/12*/
        var v_smCodeHiden = $("#smCodeHiden").val(); 
        if(v_smCodeHiden=="vp"){
          var v_addVpMemberHiden =$("#addVpMemberHiden").val();//可添加vpmn成员数
          var v_regionNameHiden = $("#regionNameHiden").val();
          if ( (Number(document.all.addRecordNum.value)+1 )> Number(v_addVpMemberHiden) ){
            rdShowMessageDialog(""+v_regionNameHiden+"公司的智能网总容量已达到上限，不能再新增成员！");
            return false;
          }
        }
        /*end diling add @2012/6/12*/
        tmp_flag = verifyUnique(phone_no,isdn_no);
        if(tmp_flag == false)
        {
            rdShowMessageDialog("已经有一条'短号'或者'真实号码'相同的数据!!");
            return false;
        }
        tr1=dyntb.insertRow();    //注意：插入的必须与下面的在一起,否则造成空行.yl.
        tr1.id="tr"+dynTbIndex;
        tr1.insertCell().innerHTML = '<div align="center"><input id=R0    type=checkBox  style="width:40%"   value="删除2" onClick="dynDelRow()" ></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R1 style="width:80%" class="InputGrey"  type=text   value="'+ phone_no+'"  readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R2 style="width:80%" class="InputGrey"  type=text   value="'+ isdn_no+'"   readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R3 style="width:80%" class="InputGrey"  type=text   value="'+ user_name+'"   readonly ></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R4 style="width:80%" class="InputGrey"  type=text   value="'+ id_card+'"  readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R5 style="width:80%" class="InputGrey"  type=text   value="'+ note+'"    readonly></input></div>';
        tr1.insertCell().innerHTML = '<div align="center"><input id=R6 style="width:80%" class="InputGrey"  type=text   value="'+ exec_status+'"   readonly ></input></div>';
        if('<%=j1Flag%>' == 'true') {
        	var subPhone = $('#subPhone').val();
        	var userChName = $('#userChName').val();
        	var chShortName = $('#chShortName').val();
        	tr1.insertCell().innerHTML = '<div align="center"><input id=R7  style="width:80%" class="InputGrey"  type=text   value="'+ subPhone+'"   readonly></input></div>';
	        tr1.insertCell().innerHTML = '<div align="center"><input id=R8  style="width:80%" class="InputGrey"  type=text   value="'+ userChName+'"    readonly></input></div>';
	        tr1.insertCell().innerHTML = '<div align="center"><input id=R9  style="width:80%" class="InputGrey"  type=text   value="'+ chShortName+'"   readonly ></input></div>';
        }
        
        dynTbIndex++;
        document.all.addRecordNum.value = document.all.dyntb.rows.length-2;
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
        
        
       //liujian 2013-5-8 10:11:21 
       if('<%=j1Flag%>' == 'true') {
       		 if (!checkElement(document.getElementById("subPhone"))) {
				rdShowMessageDialog("分机号码为4-6位数字，请重新填写！", 1);
				document.getElementById("subPhone").focus();
				return false;
			} else if (!checkElement(document.getElementById("userChName"))) {
				document.getElementById("userChName").focus();
				return false;
			} else if (!checkElement(document.getElementById("chShortName"))) {
				document.getElementById("chShortName").focus();
				return false;
			}  else {
			  	var patrn=/^[a-z]$/;
			  	if(document.getElementById("chShortName").value.trim().substring(0,1).search(patrn) == -1){
					rdShowMessageDialog("成员姓名拼音首字母必须以小写字母开始！");
					document.getElementById("chShortName").focus();
					return;
				}
			}
			
			var j1Provider = document.getElementById("j1Provider").value;
			if (j1Provider == "0") {
			  	var patrn=/^[6][1-9]\d{2,4}$/;
			  	if(document.getElementById("subPhone").value.search(patrn) == -1){
					rdShowMessageDialog("移动运营商分机号码第一位必须为6；第二位不能为0，请重新输入！");
					document.getElementById("subPhone").focus();
					return;
				}
			} else if (j1Provider == "1") {
			  	var patrn=/^[8]\d{3,5}$/;
			  	if(document.getElementById("subPhone").value.search(patrn) == -1){
					rdShowMessageDialog("其他运营商分机号码第一位必须为8，请重新输入！");
					document.getElementById("subPhone").focus();
					return;
				}
			}
       }
      
        
        			        		       			
        var path = "../s7983/f7983_no_infor.jsp";
        path = path + "?loginNo=" + document.frm.work_no.value + "&phoneNo=" + document.frm.ISDNNO.value;
        path = path + "&opCode=" + document.frm.op_code.value + "&orgCode=" + document.frm.org_code.value;
        path = path + "&ZHWW=" + document.frm.ZHWW.value;
        path = path + "&phone_type=" + document.frm.phone_type.value;
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
                if ( parseInt(sTotalFee) > 0 )
                {
                    check_phone();
                }else{
                    dynAddRow();
                }
            } 			           
        }
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
        
        if(retType =="phonenoMobile"){
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
        }else if(retType == "phoneno"){
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
        }else if(retType == "unitId"){
            if( parseInt(retCode) == 0 ){
                var num = backArrMsg[0][0];
                if(num<=0){
                	rdShowMessageDialog("本集团下的vpmn产品或者彩铃产品有重复！",0);
                	return;
                }else{
                  $("#product_name").val($('#packet_code option:selected').text());
                  document.frm.action="f7482_1.jsp?action=step1";
                  document.frm.submit();	
                	
                }
            }else{
                rdShowMessageDialog("错误代码："+retCode+"</br>错误信息："+retMessage+"!",0);
                return false;
            }
        }else if(retType == "unitId1"){
        	  
            if( parseInt(retCode) == 0 ){
            	  for(var iji=0;iji<backArrMsg.length;iji++){
            	  	  
        	  	      var num = parseInt(backArrMsg[iji][0]);
        	  	      if(num>1){
                	     rdShowMessageDialog("本集团下的"+backArrMsg[iji][1]+"产品有重复！",0);
                	     return;
                    }else if(num<=0){
                    	var productName = backArrMsg[iji][1];
                    	if(backArrMsg[iji][1]=='CR'){
                    		 productName = '集团彩铃';
                    	}else if(backArrMsg[iji][1]=='vp'){
                    		 productName = '智能网VPMN';
                    	}
                    	rdShowMessageDialog("本集团下不存在"+productName+"产品！",0);
                	    return;	
                    }
                }    	

                  
                $("#product_name").val($('#packet_code option:selected').text());
                document.frm.action="f7482_1.jsp?action=step1";
                document.frm.submit();	

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
    
    //打印信息
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
			
			cust_info += "客户姓名：   "+document.frm.unit_name.value+"|";
			cust_info += "证件号码：   "+document.frm.iccid.value+"|";
			cust_info += "集团客户编码：   "+""+"|";
			
	   
	    
	    opr_info += "集团产品名称：   "+document.frm.product_name.value+"|";
	    opr_info += "业务类型：   组合营销集团成员增加"+"|";
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
    
    function doSubmit(){
       
       var flagAcc=0;
       
       if("step1"=="<%=action%>"&&"0"!="<%=packet_code_is_600001%>"){
       	$.each($(".loginAcceptS:visible"), function(i){
	       	  if($(this).val().trim()==''){
	       	  	flagAcc++;
	       	  }
	       });
	       
	       
	       if($("#idNoSel_new_VPMN").val()==""){
	       		rdShowMessageDialog("请选择VPMN！",0);
	          return;	
	       }
	       
	      var temp_Accept = "";
	      var ret_flag = false;
	      
				$("div[id^='attr_div_']:visible").find("input[type='text']").each(function(){
					
					temp_Accept = temp_Accept + $(this).val().trim()+"~";
					
					var td0_text = $(this).parent().parent().find("td:eq(0)").text().trim();
					if($(this).val().trim()==""){
						ret_flag = true;
						rdShowMessageDialog("请设置"+td0_text,0);
					}
					
				});
				
				if(ret_flag){
					return;
				}
					
					$("#i_600001_idNo").val($("#idNoSel_new_VPMN").find("option:selected").attr("v_idNo")+"~"+$("#idNoSel_new_yiqi").find("option:selected").attr("v_idNo"));
					$("#i_600001_Accept").val(temp_Accept);
					$("#i_600001_smCodes").val("vp~YQ~");
					
	
       }else{
       	//原逻辑
	       $.each($(".loginAcceptS"), function(i){
	       	  if($(this).val().trim()==''){
	       	  	flagAcc++;
	       	  }
	       });
	       if(flagAcc>0){
	       	  rdShowMessageDialog("请填写成员属性！",0);
	          return;	
	       }
     	 }
       
        var ind1Str ="";
        var ind2Str ="";
        var ind3Str ="";
        var ind4Str ="";
        var ind5Str ="";   
      
      	//liujian 2013-5-8 10:57:44 
        var ind7Str ="";
        var ind8Str =""; 
        var ind9Str ="";
        
        if( dyntb.rows.length == 2){
            rdShowMessageDialog("没有指定成员号码，请增加数据!",0);
            return false;
        }else{
            for(var a=1; a<document.all.R0.length ;a++)
            {
                ind1Str =ind1Str +document.all.R1[a].value+"|";
                ind2Str =ind2Str +document.all.R2[a].value+"|";
                ind3Str =ind3Str +document.all.R3[a].value+"|";
                ind4Str =ind4Str +document.all.R4[a].value+"|";
                ind5Str =ind5Str +document.all.R5[a].value+"|";
                //liujian 2013-5-8 10:56:25
               if('<%=j1Flag%>' == 'true') {
                	ind7Str =ind7Str +document.all.R7[a].value+"|";
                	ind8Str =ind8Str +document.all.R8[a].value+"|";
                	ind9Str =ind9Str +document.all.R9[a].value+"|";
                }
            }
        }
        
        //2.对form的隐含字段赋值
        
        document.all.tmpR1.value = ind1Str;
        document.all.tmpR2.value = ind2Str;
        document.all.tmpR3.value = ind3Str;
        document.all.tmpR4.value = ind4Str;
        document.all.tmpR5.value = ind5Str;
        //liujian 2013-5-8 10:58:29
        document.all.tmpR7.value = ind7Str;
        document.all.tmpR8.value = ind8Str;
        document.all.tmpR9.value = ind9Str;
        
        $("#op_note").val("操作员<%=workNo%>进行组合营销集团成员增加操作！");
        showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes");
        
    
        var confirmFlag=0;
		    confirmFlag = rdShowConfirmDialog("是否提交本次操作？");
		    if (confirmFlag==1) {
		    	
    		
           document.frm.action="f7482_2.jsp";       
           document.frm.submit();
        }
    
    }
    
       
$(document).ready(function(){
	if("step1"=="<%=action%>"&&"0"!="<%=packet_code_is_600001%>"){
		
				$("div[id^='attr_div_']").hide();
		
				//vpmn的下拉框
				var new_vpmn_select = "<select  name='idNoSel_new_VPMN' id='idNoSel_new_VPMN' onchange='set_new_yq_sel(this)' style='width:250px'>";
				new_vpmn_select += "<option  value=''>--请选择--</option>";
				//yiqi 下拉框
				var new_yiqi_select = "<select name='idNoSel_new_yiqi' id='idNoSel_new_yiqi' style='width:250px' disabled>";
				new_yiqi_select += "<option  value=''>--请选择--</option>";
			
			$("#show_sel_table tr").each(function(){//处理每行
				
				if($(this).find("td:eq(0)").text().trim()=="vp"){
						new_vpmn_select += "<option v_idNo='"+$(this).find("input[id^='idNo']:eq(0)").val()+"'  v_feeCode='"+$(this).find("input[id^='feeCode']:eq(0)").val()+"' v_yiqi='"+$(this).find("input[id^='yiqi_']:eq(0)").val()+"' value='"+$(this).find("select").val()+"'>"+$(this).find("select").find("option:eq(0)").text().trim()+"</option>";
				}
				
				if($(this).find("td:eq(0)").text().trim()=="YQ"){
						new_yiqi_select += "<option v_idNo='"+$(this).find("input[id^='idNo']:eq(0)").val()+ "' value='"+$(this).find("select").val()+"'>"+$(this).find("select").find("option:eq(0)").text().trim()+"</option>";
				}
				
				
				$(this).hide();
			});
				
				
				new_vpmn_select += "</select>";
				new_yiqi_select += "</select>";
				
				
				
			var table_html =  "<tr><td class='blue' width='15%'>VPMN</td><td width='35%'>"+new_vpmn_select+"</td>"+
												"<td   class='blue' width='15%'>一起增值版</td><td>"+new_yiqi_select+"</td>"
			$("#show_sel_table").append(table_html);
			
			
			
	}
});

function set_new_yq_sel(bt){
	$("input[name^='loginAccept_']").val("");
	if($(bt).val()==""){
		
		$("#idNoSel_new_yiqi").val("");
		$("div[id^='attr_div_']").hide();
	}else{
		var yiqi_flag = $(bt).find("option:selected").attr("v_yiqi");
		var v_feeCode = $(bt).find("option:selected").attr("v_feeCode");
		var v_idNo    = $(bt).find("option:selected").attr("v_idNo");
		
		$("div[id^='attr_div_']").hide();
		$("div[id='attr_div_"+yiqi_flag+"']").show();
		$("div[id='attr_div_"+v_feeCode+"']").show();
		
		$("#idNoSel_new_yiqi").find("option").each(function(){
			if($(this).text().indexOf(yiqi_flag)!=-1)	{
					$(this).attr("selected",true);
					return false;
			}
		});
	}
}    
 </script>
</head>
<body>
<form name="frm" action="" method="post">
<%@ include file="/npage/include/header.jsp" %>

<input type="hidden" id="i_600001_smCode"   name="i_600001_smCode"  />
<input type="hidden" id="i_600001_idNo"     name="i_600001_idNo"    />
<input type="hidden" id="i_600001_Accept"   name="i_600001_Accept"  />
<input type="hidden" id="i_600001_smCodes"  name="i_600001_smCodes" />

<div class="title">
	<div id="title_zi">组合营销选择</div>
</div>
<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode22" retmsg="retMsg22" outnum="2">
      <wtc:sql>SELECT packet_code,packet_name FROM dGrpProPacketFee WHERE region_code='<%=regionCode%>' AND (other IS NULL OR other <> 'N')</wtc:sql><!-- haoyy update 2012/3/19 9:29 启用other字段 -->
</wtc:pubselect>
<wtc:array id="packetCodeArr" scope="end" />	
<table cellspacing=0>
    <tr>
    	<td class='blue' nowrap width='18%'>营销组合方案</td>
    	<td colspan=3>
    		<!-- yuanqs add 2010-9-10 15:00:27 begin -->
    		<select id='packet_code' name='packet_code' >
    		<%
    			
	    		if("step1".equals(action)) {
							for(int i = 0;i<packetCodeArr.length;i++){
								if(packetCode.equals(packetCodeArr[i][0])) {
				%>
								<option value='<%=packetCodeArr[i][0]%>' checked><%=packetCodeArr[i][1]%></option>

				<%
								}
							}
					} else {
							for(int i = 0;i<packetCodeArr.length;i++){
				%>
									 <option value='<%=packetCodeArr[i][0]%>'><%=packetCodeArr[i][1]%></option>
				<%
							}
					}
				%>
    		  </select>
    		  <!-- yuanqs add 2010-9-10 15:00:27 end -->
      </td>
   </tr>
   <tr>
    	<td class='blue' nowrap width='18%' >集团编号</td>
    	<td>
    		<div id="divUnitId1">
    			<input type='text' name='unit_id_q' id='unit_id_q' v_must='0' v_name='unit_id_q' v_type='0_9'/>
    		  <font class='orange'>*</font>
    		  <input type='button' class='b_text' name='unit_id_qry' id='unit_id_qry' value='查询' onClick="getUnitInfo();" />
    	  </div>
    	  <div id="divUnitId2">
    		  <input type='text' name='unit_id' id='unit_id' Class="InputGrey" v_must='1'  readOnly /></td>
    		</div>
    	<td class='blue' nowrap width='18%' >集团名称</td>
    	<td><input type='text' name='unit_name' id='unit_name' Class="InputGrey" v_must='1' readOnly /></td>
    </tr>
</table>
<br/> 

      

<%
System.out.println("---------hejwa-------------packetCode-------------->"+packetCode);
System.out.println("---------hejwa-------------action------------------>"+action);
//---------hejwa-------------packetCode-------------->600001
//---------hejwa-------------action------------------>step1

if("step1".equals(action)){%>
<div class="title">
	<div id="title_zi">组合营销产品选择</div>
</div>

<%

System.out.println("----hejwa-------------------packetCode----------------------->"+packetCode);

if(!"0".equals(packet_code_is_600001)){
%>
<table cellspacing=0 id="show_sel_table">
<%
    
    String smCodes = "";
    for(int i=0;i<smCodeArr.length;i++){
    
        smCodes = smCodes+smCodeArr[i][0]+"~";
        
    %>
    <tr>
    	
    	<td class='blue' ><%=smCodeArr[i][0]%></td>
    	<td class='blue' ><%=smCodeArr[i][3]%></td>
    	<td class='blue' nowrap width='18%'><%=smCodeArr[i][1]%></td>
    	 
    	<td>
    		<select onchange='$("#idNo<%=smCodeArr[i][0]%>").val(this.options[this.selectedIndex].value);' id='idNoSel<%=smCodeArr[i][1]%>' name='idNoidNoSel<%=smCodeArr[i][1]%>' class='idNoSel' style="width:300px">
    		   <option value='<%=smCodeArr[i][3]%>'><%=smCodeArr[i][3]%>--><%=smCodeArr[i][4]%>--><%=smCodeArr[i][2]%></option>
    	  </select> 
    	</td>
    	<td>
    		<input type='text' name='idNo<%=smCodeArr[i][0]%>' id='idNo<%=smCodeArr[i][0]%>' value="<%=smCodeArr[i][3]%>" Class="InputGrey" v_must='1' readOnly />
    	  <input type='hidden' name='feeCode<%=smCodeArr[i][0]%>' id='feeCode<%=smCodeArr[i][0]%>' value='<%=smCodeArr[i][2]%>'	/>
    	  <input type='hidden' name='yiqi_<%=smCodeArr[i][11]%>' id='yiqi_<%=smCodeArr[i][11]%>' value='<%=smCodeArr[i][11]%>'	/>
    	</td>
    <%}%>
    <input type='hidden' name="smCodes" value='<%=smCodes%>' />
    </tr>
</table>
<%
}else{
%>
<table cellspacing=0 id="show_sel_table">
   
    <%
    String smCodes = "";
    for(int i=0;i<smCodeArr.length;i++){
        smCodes = smCodes+smCodeArr[i][0]+"~";
        
    %>
    <tr>
    	
    	<td class='blue' nowrap width='18%'><%=smCodeArr[i][1]%></td>
    	 
    	<td>
    		<select onchange='$("#idNo<%=smCodeArr[i][0]%>").val(this.options[this.selectedIndex].value);' id='idNoSel<%=smCodeArr[i][1]%>' name='idNoidNoSel<%=smCodeArr[i][1]%>' class='idNoSel'>
    			<option value=''>...请选择...</option>
    			<!-- yuanqs add 2010/9/9 13:36:55 -->
    		   <option value='<%=smCodeArr[i][3]%>'><%=smCodeArr[i][3]%>--><%=smCodeArr[i][4]%></option>
    	  </select> 
    	</td>
    	<td>
    		<input type='text' name='idNo<%=smCodeArr[i][0]%>' id='idNo<%=smCodeArr[i][0]%>' Class="InputGrey" v_must='1' readOnly />
    	  <input type='hidden' name='feeCode<%=smCodeArr[i][0]%>' id='feeCode<%=smCodeArr[i][0]%>' value='<%=smCodeArr[i][2]%>'	/>
    	</td>
    <%}%>
    <input type='hidden' name="smCodes" value='<%=smCodes%>' />
    </tr>
</table>
<%
}
%>
 
<%for(int i=0;i<smCodeArr.length;i++){%>
  
  <div id="attr_div_<%=smCodeArr[i][2]%>">
  	</br>
	<div class="title">
	   <div id="title_zi"><%=smCodeArr[i][1]%>产品成员属性填写</div>
  </div>
  <table cellspacing="0" >
  	<tr>
  	   <td class='blue' nowrap width='18%' ><%=smCodeArr[i][1]%>产品成员属性流水</td>
  	   <td>
			<input type='text' v_feeCode="<%=smCodeArr[i][2]%>" class="loginAcceptS" name='loginAccept_<%=smCodeArr[i][0]%>' id='loginAccept_<%=smCodeArr[i][0]%>' Class="InputGrey" v_must='1' readOnly />
		  </td>
		  <td>
		    <%
		      if("vp".equals(smCodeArr[i][0])){
		    %>
		        <input type='button' class='b_text' name='setProAttrBtn' id='setProAttrBtn' value='增加' onClick="setProAttrVp('<%=smCodeArr[i][0]%>','<%=smCodeArr[i][1]%>','<%=smCodeArr[i][2]%>','<%=smCodeArr[i][5]%>','<%=smCodeArr[i][6]%>','<%=smCodeArr[i][7]%>','<%=smCodeArr[i][8]%>');" />
		    <%
		      }else{
		    %>
		        <input type='button' class='b_text' name='setProAttrBtn' id='setProAttrBtn' value='增加' onClick="setProAttr('<%=smCodeArr[i][0]%>','<%=smCodeArr[i][1]%>','<%=smCodeArr[i][2]%>');" />
		    <%
		      }
		    %>
			
		  </td>
  	</tr>
  </table>
  </div>
<% 

}%>

<br/>
<div class="title">
	<div id="title_zi">成员列表</div>
</div>
<table  cellspacing="0">
    <tr id="SHOWADD1" >
        <td  class="blue" width='18%'>短号</td>
        <td  width='32%'>
            <input name="PHONENO" type="text"  id="PHONENO" maxlength="8" style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_must=1 v_type=0_9 v_minlength=3 v_maxlength=8  onblur="checkElement(this)" > 
            <font class="orange">*</font>
        </td>
        <td  class="blue"  width='18%'>真实号码</td>
        <td >
            <input name="ISDNNO" type="text"  id="ISDNNO" maxlength='11' style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_must=1 v_type=0_9 v_minlength=1 v_maxlength=12  onblur="checkElement(this)">
            <font class="orange">*</font>		
        </td>
    </tr>
    <!-- liujian 2013-5-8 9:46:29 分公司申请开通“移动总机”集团产品营销案的请示 begin-->
    <%
    	 if(j1Flag) {
    	 
    %>
		    <tr class="show" >
		    	<td class="blue"  width='18%'>号码运营商</td>
			    <td >
			        <select name="j1Provider" id="j1Provider"> 
			            <option value="0">移动</option>	
			            <option value="1">其他</option>	
			        </select>
			        <font class="orange">*</font>
			    </td>
		        <td  class="blue" width='18%'>分机号码</td>
		        <td  width='32%'>
		            <input name="subPhone" type="text"  id="subPhone" maxlength="8" style='ime-mode:disabled' onKeyPress='return isKeyNumberdot(0)' v_must=1 v_type=0_9 v_minlength=4 v_maxlength=8  onblur="checkElement(this)" > 
		            <font class="orange">*</font>
		        </td>
		        
		    </tr>
		    <tr id="show" >
		    	<td  class="blue"  width='18%'>成员姓名</td>
		        <td >
		            <input name="userChName" type="text"  id="userChName" v_must=1 maxlength="18"  onblur="checkElement(this)">
		            <font class="orange">*</font>		
		        </td>
		        <td  class="blue" width='18%'>成员姓名拼音首字母</td>
		        <td  width='32%'>
		        	<input name="chShortName" type="text" v_must=1 id="chShortName" maxlength="36">
		            <font class="orange">*</font>
		        </td>
		        
		    </tr>
    <%
    	}
    %>
    <!-- liujian 2013-5-8 9:46:29 分公司申请开通“移动总机”集团产品营销案的请示 end-->
    
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
    <%    
     if(j1Flag) {
    %>
    	<th>分机号码</th>
        <th>成员姓名</th>
        <th>成员姓名拼音首字母</th>
     <%
     }
     %>   
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
        <!-- liujian 2013-5-8 11:00:14 begin -->
        <td>
            <input type="text" id="R7" value="">
        </td>
        <td>
            <input type="text" id="R8" value="">
        </td>
        <td>
            <input type="text" id="R9" value="">
        </td>
        <!-- liujian 2013-5-8 11:00:14 end -->
    </tr>
</table>

<%}%>
<br/>
<TABLE cellSpacing=0>
    <TR id="footer">        
        <TD align=center>
        	  
        	  <%if("step1".equals(action)){%>
            <input class="b_foot" name="sure" id="sure" type=button value="确认" onclick="doSubmit();"/>
            <%}else{%>
            <input name="next" id="next" class="b_foot"  type=button value="下一步" onclick="doNext();"  disabled />
            <%}%>       
            <input class="b_foot" name='clear2' id='clear2' type='button' value="清除" onClick="resetJsp()" />
            <input class="b_foot" name="close2"  onClick="removeCurrentTab()" type=button value="关闭" />
        </TD>
    </TR>
</TABLE>

<input type='hidden' id='packet_code_is_600001' name='packet_code_is_600001' value='<%=packet_code_is_600001%>' />

<input type='hidden' id='mobile_phone' name='mobile_phone' value='' />
<input type='hidden' id='work_no' name='work_no' value='<%=workNo%>' />
<input type='hidden' id='op_code' name='op_code' value='<%=opCode%>' />
<input type='hidden' id='org_code' name='org_code' value='<%=orgCode%>' />
<input name="ZHWW" type="hidden" id="ZHWW" value="0">
<input name="phone_type" type="hidden" id="phone_type" value="0">
<input type="hidden" name="tmpR1" id="tmpR1" value="">
<input type="hidden" name="tmpR2" id="tmpR2" value="">
<input type="hidden" name="tmpR3" id="tmpR3" value="">
<input type="hidden" name="tmpR4" id="tmpR4" value="">
<input type="hidden" name="tmpR5" id="tmpR5" value="">
<!-- liujian 2013-5-8 10:56:44 begin-->
<input type="hidden" name="tmpR7" id="tmpR7" value="">
<input type="hidden" name="tmpR8" id="tmpR8" value="">
<input type="hidden" name="tmpR9" id="tmpR9" value="">
<!-- liujian 2013-5-8 10:56:44 end-->
<input type='hidden' id='op_note' name='op_note' />
<input type='hidden' id='iccid' name='iccid' value='<%=iccid%>'/>
<input type='hidden' id='product_name' name='product_name' value='<%=productName%>'/>
<input type='hidden' id='grp_name' name='grp_name' />
<input type='hidden' id='sysAccept' name='sysAccept' value='<%=sysAccept%>' />
<input type='hidden' id='addVpMemberHiden' name='addVpMemberHiden' value='' />
<input type='hidden' id='smCodeHiden' name='smCodeHiden' value='' />
<input type='hidden' id='regionNameHiden' name='regionNameHiden' value='' />
<jsp:include page="/npage/common/pwd_comm.jsp"/>
<%@ include file="/npage/include/footer.jsp" %>
</form>
</body>
</html>



<script>
	//liujian 2013-5-14 11:12:25
	$(function() {
		$('#j1Provider').change(function() {
			$('#phone_type').val($('#j1Provider').val());
		});	
	})	
</script>