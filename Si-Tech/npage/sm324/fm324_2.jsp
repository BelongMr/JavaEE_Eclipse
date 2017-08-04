<%
/********************
 
 -->>描述创建人、时间、模块的功能
 -------------------------创建-----------何敬伟(hejwa)2015-10-9 14:19:54------------------
 关于合账分享业务业务限制及办理渠道拓展需求的函
 
 
 -------------------------后台人员：xiahk--------------------------------------------
 
********************/
%>
              

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http//www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http//www.w3.org/1999/xhtml">
<%@ include file="/npage/include/public_title_name.jsp" %> 

<%
	String opCode      		= WtcUtil.repNull(request.getParameter("opCode"));
  String opName      		= WtcUtil.repNull(request.getParameter("opName"));
  String iPhoneNoMaster = WtcUtil.repNull(request.getParameter("activePhone"));
  
  String currentDate = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
  
  String workNo    = (String)session.getAttribute("workNo");
  String password  = (String)session.getAttribute("password");
  String workName  = (String)session.getAttribute("workName");
  String orgCode   = (String)session.getAttribute("orgCode");
  String ipAddrss  = (String)session.getAttribute("ipAddr");
	String regionCode = (String)session.getAttribute("regCode");	
	String cust_name = "";
	  
  String cust_name_sql = " select b.cust_name "+
  											 " from dcustdoc b "+
 												 " where b.cust_id = "+
       									 " (select a.cust_id from dcustmsg a where a.phone_no = :phone_no) ";
	String cust_name_sql_param = "phone_no="+iPhoneNoMaster;       									 
	
%>
	<wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>"  id="loginAccept" /> 
		
		
  <wtc:service name="TlsPubSelCrm" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=cust_name_sql%>" />
		<wtc:param value="<%=cust_name_sql_param%>" />	
	</wtc:service>
	<wtc:array id="result_t" scope="end"/>
		
<%
	if(result_t.length>0){
		cust_name = result_t[0][0];
	}
	
	
		
	//7个标准化入参
	String paraAray[] = new String[8];
	
	paraAray[0] = "";                                       //流水
	paraAray[1] = "01";                                     //渠道代码
	paraAray[2] = opCode;                                   //操作代码
	paraAray[3] = (String)session.getAttribute("workNo");   //工号
	paraAray[4] = (String)session.getAttribute("password"); //工号密码
	paraAray[5] = iPhoneNoMaster;                                  //用户号码
	paraAray[6] = "";                        
	paraAray[7] = "a";   //a申请，d删除取消

	
%>

  <wtc:service name="sm324Qry" outnum="5" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
		<wtc:param value="<%=paraAray[0]%>" />
		<wtc:param value="<%=paraAray[1]%>" />
		<wtc:param value="<%=paraAray[2]%>" />
		<wtc:param value="<%=paraAray[3]%>" />
		<wtc:param value="<%=paraAray[4]%>" />
		<wtc:param value="<%=paraAray[5]%>" />
		<wtc:param value="<%=paraAray[6]%>" />					
		<wtc:param value="<%=paraAray[7]%>" />			
	</wtc:service>
	<wtc:array id="result_sm324Qry"  start="0"  length="2" scope="end" />
	<wtc:array id="result_sm324Qry2" start="2"  length="3" scope="end" />
		
<%

	System.out.println("--hejwa--------code--------------"+code);
	System.out.println("--hejwa--------msg---------------"+msg);
	
	for(int iii=0;iii<result_sm324Qry.length;iii++){
		for(int jjj=0;jjj<result_sm324Qry[iii].length;jjj++){
			System.out.println("------hejwa---------------result_sm324Qry["+iii+"]["+jjj+"]=-----------------"+result_sm324Qry[iii][jjj]);
		}
	}
	
	for(int iii=0;iii<result_sm324Qry2.length;iii++){
		for(int jjj=0;jjj<result_sm324Qry2[iii].length;jjj++){
			System.out.println("-----hejwa----------------result_sm324Qry2["+iii+"]["+jjj+"]=-----------------"+result_sm324Qry2[iii][jjj]);
		}
	}
	
	String num_can_phone_no = "";//主卡可以添加副卡个数
	if(result_sm324Qry.length>0){
		num_can_phone_no = result_sm324Qry[0][1];
	}
	
	if(!"000000".equals(code)){
%>
<SCRIPT language=JavaScript>
		rdShowMessageDialog("<%=code%>：<%=msg%>");
		removeCurrentTab();
</SCRIPT>
<%	
	}
%>
<%@ page contentType="text/html;charset=GBK"%>
<HTML><HEAD><TITLE><%=opName%></TITLE>
<SCRIPT language=JavaScript>

var NCPN = "<%=num_can_phone_no%>";//最多可添加副卡数量


//重置刷新页面
function reSetThis(){
	  location = location;	
}
    function goCfm(){
     	if($("#upgMainTab tr[type='add']").size()==0){
				rdShowMessageDialog("请添加副卡");
				return;
			}

      var ret = showPrtDlg("Detail","确实要进行电子免填单打印吗？","Yes"); 
      if(typeof(ret)!="undefined"){
        if((ret=="confirm")){
          if(rdShowConfirmDialog('确认要提交信息吗？')==1){
            frmCfm();
          }
        }
        if(ret=="continueSub"){
          if(rdShowConfirmDialog('确认要提交信息吗？')==1){
            frmCfm();
          }
        }
      }else{
        if(rdShowConfirmDialog('确认要提交信息吗？')==1){
          frmCfm();
        }
      }
    }

		function frmCfm(){
			
			var f_phone_no_strs   = "";
			var f_phone_pass_strs = "";
			
			
			$("#upgMainTab tr[type='add']").each(function(){
				f_phone_no_strs   += $(this).find("td:eq(0)").html().trim()+"|";
				f_phone_pass_strs += $(this).find("td:eq(1)").html().trim()+"|";
			});
			
			
      var packet = new AJAXPacket("fm324_5.jsp","请稍后...");
    			packet.data.add("op_type","a");//
	    		packet.data.add("opCode","<%=opCode%>");//opcode
	    		packet.data.add("loginAccept","<%=loginAccept%>");//流水
	        packet.data.add("iPhoneNoMaster","<%=iPhoneNoMaster%>");//主卡号码
	        packet.data.add("f_phone_no_strs",f_phone_no_strs);//副卡号码
	        packet.data.add("f_phone_pass_strs",f_phone_pass_strs);//副卡密码
	    core.ajax.sendPacket(packet,do_frmCfm);
	    packet =null;	
    }
    
    function do_frmCfm(packet){
    	 	var error_code = packet.data.findValueByName("code");//返回代码
		    var error_msg =  packet.data.findValueByName("msg");//返回信息
		
		    if(error_code=="000000"){//操作成功
		    	rdShowMessageDialog("操作成功",2);
					location = location;
		    }else{//调用服务失败
		    	rdShowMessageDialog(error_code+":"+error_msg);
		    }
    }

    function showPrtDlg(printType,DlgMessage,submitCfm){  //显示打印对话框 
      var h=180;
      var w=350;
      var t=screen.availHeight/2-h/2;
      var l=screen.availWidth/2-w/2;		   	   
      var pType="subprint";             				 	//打印类型：print 打印 subprint 合并打印
      var billType="1";              				 			  //票价类型：1电子免填单、2发票、3收据
      var sysAccept =<%=loginAccept%>;             	//流水号
        var printStr = printInfo(printType);
      
	 		                      //调用printinfo()返回的打印内容
      var mode_code=null;           							  //资费代码
      var fav_code=null;                				 		//特服代码
      var area_code=null;             				 		  //小区代码
      var opCode="<%=opCode%>" ;                   			 	//操作代码
      var phoneNo="<%=iPhoneNoMaster%>";                  //客户电话
      
      var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
      var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_dz.jsp?DlgMsg=" + DlgMessage;
      path+="&mode_code="+mode_code+
      	"&fav_code="+fav_code+"&area_code="+area_code+
      	"&opCode=<%=opCode%>&sysAccept="+sysAccept+
      	"&phoneNo="+phoneNo+
      	"&submitCfm="+submitCfm+"&pType="+
      	pType+"&billType="+billType+ "&printInfo=" + printStr;
      var ret=window.showModalDialog(path,printStr,prop);
      return ret;
    }				
			
    function printInfo(printType){
      var cust_info="";
      var opr_info="";
      var note_info1="";
      var note_info2="";
      var note_info3="";
      var note_info4="";
      var retInfo = "";
      
      cust_info+="手机号码：   "+"<%=iPhoneNoMaster%>"+"|";
      cust_info+="客户姓名：   "+"<%=cust_name%>"+"|";
      
      var f_phone_nos = "";
      
    	$("#upgMainTab tr[type='add']").each(function(){
				f_phone_nos +=$(this).find("td:eq(0)").text().trim()+" ";
			});
			
      opr_info +="业务类型：集团客户部之合账分享"+"|"+"业务流水: "+"<%=loginAccept%>" +"|";
      opr_info += "主卡号码：<%=iPhoneNoMaster%>"+"|";
      opr_info += "副卡号码："+f_phone_nos+"|";
      opr_info += "付费金额：全额"+"|";
      
      opr_info += "办理时间：" + "<%=new java.text.SimpleDateFormat("yyyy年MM月dd日", Locale.getDefault()).format(new java.util.Date())%>" + "|";
      opr_info += "生效时间：" + "<%=new java.text.SimpleDateFormat("yyyy年MM月dd日", Locale.getDefault()).format(new java.util.Date())%>" + "|";
      
      note_info1 += "备注：|尊敬的客户您好，您已成功办理合账分享业务，为您所绑定的副卡全额付费，话费月末一次性根据副卡所使用的话费从您的账户中进行扣除，如您号码欠费副卡也会欠费，请您根据主副卡消费情况，及时缴费，以免影响您使用。"+"|";
      
      retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
      retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
      return retInfo;
    }

//添加副卡校验
function go_f_add_check(){
	
	
	/*最多几个副卡是通过服务查询出来的*/
	if(parseInt(NCPN)==$("#upgMainTab tr[type='add']").size()){
		rdShowMessageDialog("添加副卡数量已经达到最大限制");
		return;
	}
	
	
	if($("#f_phone_no").val().trim()==""){
		rdShowMessageDialog("请输入副卡号码");
		return;
	}
	if($("input[name='f_phone_pass']").val().trim()==""){
		rdShowMessageDialog("请输入副卡密码");
		return;
	}
	
	
	var c_i = 0;
	$("#upgMainTab tr").each(function(){
		if($(this).find("td:eq(0)").text().trim()==$("#f_phone_no").val().trim()){
			c_i = 1;
			return false;
		}
	});
	if(c_i==1){
		rdShowMessageDialog("已添加的副卡号码");
		return;
	}
	
    var packet = new AJAXPacket("fm324_4.jsp","请稍后...");
    		
    		packet.data.add("opCode","<%=opCode%>");//opcode
        packet.data.add("iPhoneNoMaster","<%=iPhoneNoMaster%>");//主卡号码
        packet.data.add("iPhoneNoMember",$("#f_phone_no").val().trim());//副卡号码
        packet.data.add("iUserPwdMember",$("input[name='f_phone_pass']").val());//副卡密码
    core.ajax.sendPacket(packet,do_f_add_check);
    packet =null;	
	

}
function do_f_add_check(packet){
	  var error_code = packet.data.findValueByName("code");//返回代码
    var error_msg =  packet.data.findValueByName("msg");//返回信息

    if(error_code=="000000"){//操作成功
    	
    		var accept =  packet.data.findValueByName("accept");
      	var tr_html = "<tr type='add'>"+
								"<td>"+$("#f_phone_no").val()+"</td>"+
								"<td style='display:none'>"+$("input[name='f_phone_pass']").val()+"</td>"+
								"<td><%=currentDate%></td>"+
								"<td>20500101</td>"+
								"<td><input type='button' value='删除' class='b_text' onclick='del_f_this(this)' /></td>"+
								"</tr>"
				$("#upgMainTab tr:eq(0)").after(tr_html);
				
				$("#f_phone_no").val("");
				$("input[name='f_phone_pass']").val("");
				
				$("#cfm_btn").removeAttr("disabled");
				
				//到达最大个数后置灰添加按钮
				if($("#upgMainTab tr[type='add']").size()==parseInt(NCPN)){
					$("#add_memPhone_btn").attr("disabled","disabled");
				}
				
    }else{//调用服务失败
    	rdShowMessageDialog(error_code+":"+error_msg);
    }
}


function del_f_this(bt){
	if(rdShowConfirmDialog('确认删除此副卡么？')!=1) return;
	$(bt).parent().parent().remove();
	
	//添加的副卡删除完置灰提交按钮
	if($("#upgMainTab tr[type='add']").size()==0){
		$("#cfm_btn").attr("disabled","disabled");
	}
	
	$("#add_memPhone_btn").removeAttr("disabled");
}
</SCRIPT>
</HEAD>	
<BODY>
<FORM name="frm" action="" method="post"> 
	<%@ include file="/npage/include/header.jsp" %>	
<div class="title"><div id="title_zi">查询条件</div></div>


<table cellSpacing="0">
		<tr>
	    <td class="blue" width="15%">业务类型</td>
		  <td colspan="3">
			    申请
		  </td>
	</tr>
	<tr>
	    <td class="blue" width="15%">主卡号码</td>
		  <td width="35%">
			    <%=iPhoneNoMaster%>
		  </td>
		  <td class="blue" width="15%">主卡客户名称</td>
		  <td width="35%">
			    <%=cust_name%>
		  </td>
	</tr>
		<tr>
	    <td class="blue" width="15%">副卡号码</td>
		  <td width="35%">
			    <input type="text" id="f_phone_no"/>
		  </td>
		  <td class="blue" width="15%">副卡密码</td>
		  <td width="35%">
		  	   <jsp:include page="/npage/common/pwd_1.jsp">
                  <jsp:param name="width1" value="16%"  />
                  <jsp:param name="width2" value="34%"  />
                  <jsp:param name="pname" value="f_phone_pass"  />
                  <jsp:param name="pwd" value="12345"  />
           </jsp:include> 
		  	<jsp:include page="/npage/common/pwd_comm.jsp"/>
		  </td>
	</tr>
</table>
<table cellSpacing="0">
	 <tr>
	 	<td id="footer">
	 		<input id="add_memPhone_btn" type="button" class="b_text" value="添加副卡" onclick="go_f_add_check()" />
	 	</td>
	</tr>
</table>

<div class="title"><div id="title_zi">副卡列表</div></div>
<TABLE cellSpacing="0" id="upgMainTab">
    <tr>
        <th width="25%">副卡号码</th>
        <th width="25%">开始时间</th>	
        <th width="25%">结束时间</th>	
        <th width="25%">操作</th>	
    </tr>
<%
for(int i=0;i<result_sm324Qry2.length;i++){
	if(!"".equals(result_sm324Qry2[i][0].trim())){
		out.println("<tr>");
		out.println("<td>"+result_sm324Qry2[i][0]+"</td>");
		out.println("<td>"+result_sm324Qry2[i][1]+"</td>");
		out.println("<td>"+result_sm324Qry2[i][2]+"</td>");
		out.println("<td></td>");
		out.println("</tr>");
	}
}
%>
</table>


<table cellSpacing="0">
	 <tr>
	 	<td id="footer">
	 		<input id="cfm_btn" type="button" class="b_foot" value="确定&打印" onclick="goCfm()"      disabled     />
	 		<input type="button" class="b_foot" value="重置" onclick="reSetThis()"         /> 
			<input type="button" class="b_foot" value="关闭" onclick="removeCurrentTab()"  /> 
	 	</td>
	</tr>
</table>

<%@ include file="/npage/include/footer.jsp" %>
</FORM>
</BODY>
</HTML>