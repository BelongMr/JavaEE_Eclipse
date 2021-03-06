<%
  /*
   * 功能: 绩效考评
　 * 版本: 1.0
　 * 日期: 2009/04/10
　 * 作者: donglei
　 * 版权: sitech
   *
   *
 　*/
 %>
<%@ page contentType="text/html;charset=gb2312"%>
<%@ include file="/npage/include/public_title_name.jsp" %>

<%@ include file="/npage/callbosspage/K098/checkpermission.jsp" %>

<%@ page import="javax.servlet.http.HttpServletRequest,com.sitech.crmpd.core.wtc.util.*,java.util.*,java.io.OutputStream,com.sitech.boss.util.excel.*,java.text.SimpleDateFormat"%>
<%!
		/**
		 函数说明: 输入一个基本的sql.然后页面参数模式是  [排序号_=_字段名] 或  [排序号_like_字段名]
		 其中column为查询字段.第一位是排序号.排序号不能重复.重复多个将保存一个值.且必须是数字.大小不限如1,11,123.
		 */
    public String returnSql(HttpServletRequest request){
    StringBuffer buffer = new StringBuffer();

   	//输入语句
		Map map = request.getParameterMap();
		Object[] objNames = map.keySet().toArray();
		Map temp = new HashMap();
		String name="";
		String[] names= new String[0];
		String value="";
		//将结果保存在这里.key是数字.对数字进行排序.value里面放置object数组存值
		for (int i = 0; i < objNames.length; i++) {
			name = objNames[i] == null ? "" : objNames[i]
			.toString();
			//String name
			names = name.split("_");
			//将name按照'_'分成3个数组.
			if (names.length >= 3) {
		//如果不能分说明名字不合法.太少区分不了.
		    value = request.getParameter(name);
		//按照名字得到value
		if (value.trim().equals("")) {
			//如果value是""跳过.
			continue;
		}
		Object[] objs = new Object[3];
		objs[0] = names[1];
		//保持 第一个字符串.是like 或是 =
		name = name.substring(name.indexOf("_") + 1);
		name = name.substring(name.indexOf("_") + 1);
		//这地方做数据库的字段处理.第三个'_'以后的都是数据库字段了.
		objs[1] = name;
		//第二个字符串.查询名字.
		objs[2] = value;
		//第三个.查询的值.
	//	System.out.println("~~~~~~~~~~~~~" + objs[0]);
		try {
			temp.put(Integer.valueOf(names[0]), objs);
			//这个地方是将字符串转换成数字.然后进行排序.比如19要在2之后.
		} catch (Exception e) {

		}
		//将排序号码放在key里面,ojbs数组放到value里面.
			}
		}
		Object[] objNos = temp.keySet().toArray();
		//得到一个倒序的数组.
		Arrays.sort(objNos);
		//对数字进行排序.
		for (int i = 0; i < objNos.length; i++) {
			Object[] objs = null;
			objs = (Object[]) temp.get(objNos[i]);
			//下面对like 和 = 分别处理.
			if (objs[0].toString().toLowerCase().equalsIgnoreCase(
			"like")) {
		buffer.append(" and " + objs[1] + " " + objs[0] + " '%%"
				+ objs[2].toString().trim() + "%%' ");
			}
			if (objs[0].toString().equalsIgnoreCase("=")) {
			  if(objs[1].toString().equalsIgnoreCase("acceptid")&&objs[2].toString().equalsIgnoreCase("7")){
               buffer.append(" and op_code='K025' ");
			  }else{
		buffer.append(" and " + objs[1] + " " + objs[0] + " '"
				+ objs[2].toString().trim() + "' ");
				}
			}

			if (objs[0].toString().equalsIgnoreCase("!=")) {
			 if(objs[2].toString().equalsIgnoreCase("Y")){
			  buffer.append(" and " + objs[1] + " = '"
				+ objs[2].toString().trim() + "' ");
			  }else{
		      buffer.append(" and (" + objs[1] + " " + objs[0] + " 'Y' or "+objs[1]+" is null) ");
			  }
			 }
		}

        return buffer.toString();
}
	public  String getCurrDateStr(String str) {
		java.text.SimpleDateFormat objSimpleDateFormat = new java.text.SimpleDateFormat(
				"yyyyMMdd");
		return objSimpleDateFormat.format(new java.util.Date()) + " " + str;
	}
	public  String ReturnSysTime(String strStyle) {
		String s = "";
		java.util.Date date = new java.util.Date();
		java.text.SimpleDateFormat dformat = new java.text.SimpleDateFormat(strStyle);
		s = dformat.format(date);
		return s;
	}
	//zengzq add for 中测 start
	public  String getFirstDateOfMonth() {
  	java.util.Calendar cal = java.util.Calendar.getInstance();
  	cal.set(GregorianCalendar.DAY_OF_MONTH, 1);
  	java.util.Date firstDayOfMonth = cal.getTime();
		java.text.SimpleDateFormat objSimpleDateFormat = new java.text.SimpleDateFormat(
				"yyyyMMdd");
		return objSimpleDateFormat.format(firstDayOfMonth) + " 00:00:00";
	}
	//zengzq add for 中测 end
%>

<%!
//导出Excel
    public void toExcel(String[][] queryList,String[] strHead,HttpServletResponse response){
   			System.out.println( " ==开始导出Excel文件== " );
        XLSExport e  =   new  XLSExport(null);
        String headname = "来电信息查询";//Excel文件名
        try {
        OutputStream os = response.getOutputStream();//取得输出流
        response.reset();//清空输出流
        response.setContentType("application/ms-excel");//定义输出类型
        response.setHeader("Content-disposition", "attachment; filename="+XLSExport.gbToUtf8(headname)+".xls");//设定输出文件头
				int intMaxRow=5000+1;
				ArrayList datalist = new ArrayList();
				for(int i=0;i<queryList.length;i++){
				    String[] dateSour={queryList[i][0],queryList[i][1],queryList[i][2],queryList[i][3],
				                       queryList[i][4],queryList[i][5],queryList[i][6],queryList[i][7],
				                       queryList[i][8],queryList[i][9],queryList[i][10],queryList[i][11],
				                       queryList[i][12],queryList[i][13],queryList[i][14],queryList[i][15],
				                       queryList[i][16],queryList[i][17],queryList[i][18],queryList[i][19],queryList[i][20]};
				    datalist.add(dateSour);
		    }
				XLSExport.excelExport(e, os, strHead, datalist, intMaxRow);
           e.exportXLS(os);
           System.out.println( " 导出Excel文件[成功] ");
        }catch  (Exception e1) {
           System.out.println( " 导出Excel文件[失败] ");
           e1.printStackTrace();
        }
    }
%>

<%
//jiangbing 20091118 批量服务替换
String orgCode_sqlMulKfCfm = (String)session.getAttribute("orgCode");
String regionCode_sqlMulKfCfm = orgCode_sqlMulKfCfm.substring(0,2); 
String sqlMulKfCfm="";
     String opCode="90027";
     String opName="绩效考评";
	  String loginNo = (String)session.getAttribute("workNo");
	  String orgCode = (String)session.getAttribute("orgCode");
	  String kf_longin_no=(String)session.getAttribute("kfWorkNo");

     String sqlStr = "select CONTACT_ID,decode(ACCEPTID,'0','人工','1','自动','2','来人','3','来函','4','传真','5','EMail','6','Web','7','呼出','8','三方通话' ,'9','内部呼叫' ,'10','呼出反馈','11','其它','12','短信'),CUST_NAME,decode(region_code, '01','哈尔滨','02','齐齐哈尔','03','牡丹江','04','佳木斯','05','双鸭山','06','七台河','07','鸡西','08','鹤岗','09','伊春','10','黑河','11','绥化','12','大兴安岭','13','大庆','15','异地或它网','90','省客服中心'),ACCEPT_PHONE,CALLER_PHONE,";
           sqlStr+="CALLEE_PHONE,to_char(BEGIN_DATE,'yyyy-MM-dd hh24:mi:ss'),ACCEPT_LONG,ACCEPT_LOGIN_NO,";
           sqlStr+="decode(STAFFHANGUP,'0','用户','1','话务员','2','密码验证失败自动释放'),decode(QC_FLAG,'Y','已质检','N','未质检','','未质检',NULL,'未质检'),decode(STATISFY_CODE,'0','满意','1','未处理','2','一般','3','不满意','4','满意度调查挂机'),decode(LANG_CODE,'1','普通话','2','英语'),CALLCAUSEDESCS,decode(LISTEN_FLAG,'Y','已听','','未听',NULL,'未听','N','未听'),";
           sqlStr+="decode(USE_FLAG,'Y','是','N','否'),QC_LOGIN_NO,decode(VERTIFY_PASSWD_FLAG,'Y','是','N','否','','否',NULL,'否'),decode(OTHER_PASSWD_FLAG,'Y','是','N','否','','否',NULL,'否'),BAK,TRANSFER_BAK,accept_kf_login_no  from dcallcall";
	 String strCountSql="select to_char(count(*)) count  from dcallcall";
	 String strAcceptLogSql="";
	 String strAcceptTimeSql="";
	 String strDateSql="";
	 String strOrderSql=" order by begin_date desc ";

    String start_date    ="";
    String end_date      ="";
    String region_code   ="";
    String contact_id    = "";
    String accept_login_no="";
    String listen_flag  ="";
    String accept_phone="";
    String contact_address="";
    String mail_address="";
    String grade_code="";
    String contact_phone="";
    String caller_phone="";
    String statisfy_code="";
    String cust_name="";
    String fax_no="";
    String accept_long_begin="";
    String accept_long_end="";
    String callee_phone="";
    String skill_quence="";
    String staffHangup="";
    String acceptid="";
    String oper_code="";
    String con_id="";
    String[][] dataRows = new String[][]{};

    //zengzq add for 中测 start
    String[][] testRows = new String[][]{};
  	//zengzq add for 中测 end

    int rowCount =0;
    int pageSize = 15;            // Rows each page
    int pageCount=0;               // Number of all pages
    int curPage=0;                 // Current page
    String strPage;               // Transfered pages
    String param = "";
    String sqlTemp="";
    String querySql="";

    String[] strHead = { "流水号", "受理方式", "客户姓名", "客户地市", "受理号码", "主叫号码",
			"被叫号码", "受理时间", "受理时长","受理工号", "挂机方", "是否质检", "客户满意度",  "服务语种",
			"来电原因", "录音听取标志", "是否使用放音", "质检员工号", "是否密码验证","是否他机验证", "备注", "转接备注" };
		//String[] conStaffhangup= {"用户","话务员","密码验证失败自动释放"};
		//String[] conStaffcity = {"满意","未处理","一般","不满意","满意度调查挂机"};
		String[] conAcceptid= {"人工","自动","来人","来函","传真","EMail","Web","呼出","三方通话" ,"内部呼叫" ,"呼出反馈","其它","短信"};
      String action = request.getParameter("myaction");

      //zengzq add for 中测 start
      String test_flag = request.getParameter("test_flag");
      //zengzq add for 中测 finished

      String expFlag = request.getParameter("exp");
      start_date        =  request.getParameter("start_date");
      end_date          =  request.getParameter("end_date");
			contact_id        =  request.getParameter("0_=_contact_id");
			region_code       =  request.getParameter("1_=_region_code");
			accept_login_no   =  request.getParameter("2_=_accept_kf_login_no");
			listen_flag       =  request.getParameter("13_!=_listen_flag");
			accept_phone      =  request.getParameter("3_=_accept_phone");
			mail_address      =  request.getParameter("4_=_mail_address");
			contact_address   =  request.getParameter("5_=_contact_address");
      grade_code        =  request.getParameter("6_=_grade_code");
      contact_phone     =  request.getParameter("7_=_contact_phone");
      caller_phone      =  request.getParameter("8_=_caller_phone");   //主叫号码
      statisfy_code     =  request.getParameter("9_=_statisfy_code");
      cust_name         =  request.getParameter("10_=_cust_name");
      fax_no            =  request.getParameter("11_=_fax_no");
      accept_long_begin =  request.getParameter("accept_long_begin");
      accept_long_end   =  request.getParameter("accept_long_end");
      callee_phone      =  request.getParameter("12_=_callee_phone");
      skill_quence      =  request.getParameter("14_=_skill_quence");
      staffHangup       =  request.getParameter("15_=_staffHangup");
      acceptid          =  request.getParameter("16_=_acceptid");
      oper_code         =  request.getParameter("17_=_staffcity");
      con_id            =  request.getParameter("con_id");
      System.out.println("\n\n_______________________region_code__________"+request.getParameter("region"));
      System.out.println("\n\n______________________start_date___________"+start_date);
      ///////查询条件在这
      String sqlFilter=request.getParameter("sqlFilter");
  	  if(sqlFilter==null || sqlFilter.trim().length()==0){
         if(start_date!=null&&!start_date.trim().equals("")&&end_date!=null&&!end_date.trim().equals("")){

             strDateSql=" where 1=1 and  to_char(begin_date,'yyyymmdd hh24:mi:ss')>='"+start_date.trim()+"' and to_char(begin_date,'yyyymmdd hh24:mi:ss')<='"+end_date.trim()+"' ";
             if(accept_long_begin!=null&&accept_long_begin.trim().length()!=0){
                strAcceptTimeSql=" and  accept_long>="+Long.valueOf(accept_long_begin.trim()).longValue();
             }
             if(accept_long_end!=null&&accept_long_end.trim().length()!=0){
               strAcceptTimeSql+=" and accept_long<="+Long.valueOf(accept_long_end.trim()).longValue();
             }
             sqlFilter=start_date.substring(0,6)+strDateSql+returnSql(request)+strAcceptTimeSql+strOrderSql;
        }
    }
%>
<%
	//通过此sql的值判断是否是质检员
	  String tmpCountSql = "SELECT COUNT(CHECK_LOGIN_NO) FROM DQCCHECKGROUPLOGIN "+
	  										 "WHERE TRIM(CHECK_LOGIN_NO)="+kf_longin_no.trim() + " AND VALID_FLAG='Y' ";
	  int tmpCoun = 0;
%>

<%
//zengzq add for 中测 start

 //if(test_flag!=null&&"1".equals(test_flag.trim())){
 		String testStartDate = getFirstDateOfMonth();
 		String testEndDate = getCurrDateStr("23:59:59");
 		String testStrDateSql=" where 1=1 and  to_char(begin_date,'yyyymmdd hh24:mi:ss')>='" + testStartDate + "' and to_char(begin_date,'yyyymmdd hh24:mi:ss')<='" + testEndDate + "'";
 		String sqlFilter1=testStartDate.substring(0,6)+testStrDateSql ;
 		String tQuerySql = sqlStr + sqlFilter1;
 		String tSqlTemp = strCountSql+sqlFilter1;

%>
		<wtc:service name="s151Select" outnum="1">
			<wtc:param value="<%=tSqlTemp%>"/>
			</wtc:service>
		<wtc:array id="tSqlTempData"  scope="end"/>

<%
		int testDataNum = 0;
		if(tSqlTempData.length!=0){
		    testDataNum = Integer.parseInt(tSqlTempData[0][0]);
		 }
		 //若有记录，则产生随机数，用于查询出随机一条记录
		 if(testDataNum>0){
		 int rowNum = (int)(Math.random()*testDataNum);
		 if(rowNum==0){
		 		rowNum = 1;
		 }


%>
			<wtc:service name="s151Select" outnum="24">
					<wtc:param value="<%=tQuerySql%>"/>
			</wtc:service>
			<wtc:array id="tQueryList"  start="0" length="23" scope="end"/>
<%
			testRows = tQueryList;
			System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
			System.out.println("tQueryList[0][0]:"+tQueryList.length);
 		}
 	//}
//zengzq add for 中测 finished
%>
<%	if ("doLoad".equals(action)) {
        sqlStr+=sqlFilter;
     // sqlStr+=sqlStr+start_date.substring(0,6);

        sqlTemp = strCountSql+sqlFilter;
    //  sqlTemp+=sqlTemp+start_date.substring(0,6);
		System.out.println("=========sqlStr========"+sqlStr);
		System.out.println("=========sqlTemp========"+sqlTemp);
%>
    	  	<wtc:service name="s151Select" outnum="1">
						<wtc:param value="<%=tmpCountSql%>"/>
					</wtc:service>
					<wtc:array id="tmpCount"  scope="end"/>
					<%
						if(tmpCount.length!=0){
		      		tmpCoun = Integer.parseInt(tmpCount[0][0]);
		      	}
		      	System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
	  				System.out.println(tmpCountSql);
	  				System.out.println(tmpCoun);
	  				System.out.println(kf_longin_no);
	  				System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
					%>
					<wtc:service name="s151Select" outnum="1">
						<wtc:param value="<%=sqlTemp%>"/>
					</wtc:service>
					<wtc:array id="rowsC4"  scope="end"/>
					<%
	      if(rowsC4.length!=0){
	      	rowCount = Integer.parseInt(rowsC4[0][0]);
	      }
        strPage = request.getParameter("page");
        if ( strPage == null || strPage.equals("") || strPage.trim().length() == 0 ) {
          	curPage = 1;
        }
        else {
        	curPage = Integer.parseInt(strPage);
          	if( curPage < 1 ) curPage = 1;
        }
        pageCount = ( rowCount + pageSize - 1 ) / pageSize;
        if ( curPage > pageCount ) curPage = pageCount;
        querySql = PageFilterSQL.getOraQuerySQL(sqlStr,String.valueOf(curPage),String.valueOf(pageSize),String.valueOf(rowCount));
        %>
           <wtc:service name="s151Select" outnum="24">
						<wtc:param value="<%=querySql%>"/>
					</wtc:service>
				<wtc:array id="queryList"  start="1" length="23" scope="end"/>
				<%
				dataRows = queryList;
   if(con_id!=null){
   //记录与客户接触日志
   strAcceptLogSql="insert into dbcalladm.wloginopr (login_accept,op_code,org_code,op_time,op_date,phone_no,login_no,contact_id,flag,contact_flag) values(SEQ_WLOGINOPR.NEXTVAL,:v1,:v2,sysdate,to_char(sysdate,'yyyymmdd'),:v3,:v4,:v5,'I','Y')&&"+opCode+"^"+orgCode+"^"+accept_phone+"^"+loginNo+"^"+con_id;
   List sqlList=new ArrayList();
   String[] sqlArr = new String[]{};
   sqlList.add(strAcceptLogSql);
   sqlArr = (String[])sqlList.toArray(new String[0]);
   String outnum = String.valueOf(sqlArr.length + 1);
   %>
   <wtc:service name="sModifyMulKfCfm"  outnum="2" routerKey="region" routerValue="<%=regionCode_sqlMulKfCfm%>">
<wtc:param value="<%=sqlMulKfCfm%>"/>
<wtc:param value="dbchange"/>
<wtc:params value="<%=sqlArr%>"/>
</wtc:service>
   <%
    }
    }
   //导出当前显示数据
   if("cur".equalsIgnoreCase(expFlag)){
       sqlStr+=sqlFilter;
       sqlTemp = strCountSql+sqlFilter;
System.out.println("====cur=====sqlStr========"+sqlStr);
System.out.println("======cur===sqlTemp========"+sqlTemp);
    	  %>
					<wtc:service name="s151Select" outnum="1">
						<wtc:param value="<%=sqlTemp%>"/>
					</wtc:service>
					<wtc:array id="rowsC4"  scope="end"/>
					<%
	      if(rowsC4.length!=0){
	      	rowCount = Integer.parseInt(rowsC4[0][0]);
	      }
        strPage = request.getParameter("page");
        if ( strPage == null || strPage.equals("") || strPage.trim().length() == 0 ) {
          	curPage = 1;
        }
        else {
        	curPage = Integer.parseInt(strPage);
          	if( curPage < 1 ) curPage = 1;
        }
        pageCount = ( rowCount + pageSize - 1 ) / pageSize;
        if ( curPage > pageCount ) curPage = pageCount;
        querySql = PageFilterSQL.getOraQuerySQL(sqlStr,String.valueOf(curPage),String.valueOf(pageSize),String.valueOf(rowCount));
        %>
           <wtc:service name="s151Select" outnum="24">
						<wtc:param value="<%=querySql%>"/>
					</wtc:service>
				<wtc:array id="queryList"  start="1" length="22"   scope="end"/>
				<%
				this.toExcel(queryList,strHead,response);
   }
   if("all".equalsIgnoreCase(expFlag)){
       sqlStr+=sqlFilter;
       System.out.println("======all===sqlStr========"+sqlStr);
%>
					<wtc:service name="s151Select" outnum="23">
						<wtc:param value="<%=sqlStr%>"/>
					</wtc:service>
					<wtc:array id="queryList" start="0" length="22" scope="end"/>
<%
				this.toExcel(queryList,strHead,response);
   }

%>


<html>
<head>
<title>绩效考核-话务量查询</title>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/npage/callbosspage/js/datepicker/WdatePicker.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/njs/redialog/redialog.js"></script>

<script language=javascript>
	$(document).ready(
		function()
		{
	    $("td").not("[input]").addClass("blue");
			$("#footer input:button").addClass("b_foot");
			$("td:not(#footer) input:button").addClass("b_text");
			$("input:text[@v_type]").blur(checkElement2);

			$("a").hover(function() {
				$(this).css("color", "orange");
			}, function() {
				$(this).css("color", "blue");
			});
		}
	);

	function checkElement2() {
				checkElement(this);
		}
function doProcessNavcomring(packet)
	 {
	    var retType = packet.data.findValueByName("retType");
	    var retCode = packet.data.findValueByName("retCode");
	    var retMsg = packet.data.findValueByName("retMsg");
	    if(retType=="chkExample"){
	    	if(retCode=="000000"){
	    		//alert("处理成功!");
	    	}else{
	    		//alert("处理失败!");
	    		return false;
	    	}
	    }
	 }

 function doLisenRecord(filepath,contact_id)
{
		   window.top.document.getElementById("recordfile").value=filepath;
		   window.top.document.getElementById("lisenContactId").value=contact_id;
		   window.top.document.getElementById("K042").click();
			var packet = new AJAXPacket("../../../npage/callbosspage/K042/lisenRecord.jsp","正在处理,请稍后...");
	     packet.data.add("retType" ,  "chkExample");
	     packet.data.add("filepath" ,  filepath);
	     packet.data.add("liscontactId" ,contact_id);
	    core.ajax.sendPacket(packet,doProcessNavcomring,true);
			packet =null;
}
function checkCallListen(id){
		if(id==''){
		return;
		}
	var packet = new AJAXPacket(<%=request.getContextPath()%>"/npage/callbosspage/k170/k170_checkIsListen_rpc.jsp","\u6b63\u5728\u5904\u7406,\u8bf7\u7a0d\u540e...");
	packet.data.add("contact_id",id);
	core.ajax.sendPacket(packet,doProcessGetPath,false);
	packet=null;
}
function doProcessGetPath(packet){
   var file_path = packet.data.findValueByName("file_path");
   var flag = packet.data.findValueByName("flag");
   var contact_id = packet.data.findValueByName("contact_id");
   if(flag=='Y'){
   	doLisenRecord(file_path,contact_id);
   	}else{
   	getCallListen(contact_id)	;
   	}

}
 function saveContact()
{
			var packet = new AJAXPacket(<%=request.getContextPath()%>"/npage/callbosspage/k170/k1712_contact_rpc.jsp","正在处理,请稍后...");
			var strContactId =window.top.document.getElementById('contactId').value;
			var strAcceptPhoneNo =window.top.document.getElementById('acceptPhoneNo').value;
	     //alert(strContactId);
	     packet.data.add("strContactId" ,strContactId);
	     packet.data.add("strAcceptPhoneNo" ,strAcceptPhoneNo);
	    core.ajax.sendPacket(packet,dosaveContacting,true);
			packet =null;
}
function dosaveContacting(packet)
	 {
	    var retCode = packet.data.findValueByName("retCode");
	 }

		saveContact();

function getCallListen(id){
	if(id==''){
		return;
		}
//var a=window.showModalDialog("k170_getCallListen.jsp?flag_id="+id,window,"dialogHeight: 650px; dialogWidth: 850px;");
openWinMid("k170_getCallListen.jsp?flag_id="+id,'录音听取',650,850);
}
//=========================================================================
// SUBMIT INPUTS TO THE SERVELET
//=========================================================================
function submitInputCheck(){
	//alert(document.sitechform.end_date.value.substring(0,6));
	//alert(document.sitechform.start_date.value.substring(5,6));
   if( document.sitechform.start_date.value == ""){
    	   showTip(document.sitechform.start_date,"开始时间不能为空");
    	   sitechform.start_date.focus();

    }else if(document.sitechform.end_date.value == ""){
		     showTip(document.sitechform.end_date,"结束时间不能为空");
    	   sitechform.end_date.focus();

    }else if(document.sitechform.end_date.value<=document.sitechform.start_date.value){
		     showTip(document.sitechform.end_date,"结束时间必须大于开始时间");
    	   sitechform.end_date.focus();

    }else if(document.sitechform.end_date.value.substring(0,6)>document.sitechform.start_date.value.substring(0,6)){
		     showTip(document.sitechform.end_date,"只能查询一个月内的记录");
    	   sitechform.end_date.focus();
    }else if(parseInt(document.sitechform.accept_long_end.value)<=parseInt(document.sitechform.accept_long_begin.value)){
		     showTip(document.sitechform.accept_long_end,"受理时长右侧值必须大于左侧值");
    	   sitechform.accept_long_end.focus();

    }
//    else if(document.getElementById('contact_id').value == ""){
//	       showTip(document.getElementById('contact_id'),"流水号不能为空");
//		     document.getElementById('contact_id').focus();
//   }else if(document.getElementById('accept_login_no').value == ""){
//	       showTip(document.getElementById('accept_login_no'),"受理工号不能为空");
//		     document.getElementById('accept_login_no').focus();
//   }else if(document.getElementById('accept_phone').value == ""){
//	       showTip(document.getElementById('accept_phone'),"受理号码不能为空");
//		     document.getElementById('accept_phone').focus();
//   }
    else
    {
         hiddenTip(document.sitechform.start_date);
         hiddenTip(document.sitechform.end_date);
         hiddenTip(document.sitechform.accept_long_end);
         hiddenTip(document.getElementById('contact_id'));
         hiddenTip(document.getElementById('accept_login_no'));
         hiddenTip(document.getElementById('accept_phone'));
         window.sitechform.sqlFilter.value="";//清空已保存的sqlFilter的值
         window.sitechform.sqlWhere.value="<%=sqlFilter%>";
         submitMe('0');

    	}


}

function submitMe(flag){
   window.sitechform.myaction.value="doLoad";
   	if(flag=='0'){
		 var vCon_id='';
		 var objSwap=window.top.document.getElementById('contactId');
		if(objSwap!=null&&objSwap!=null!=''){
			vCon_id=objSwap.value;
		}
       window.sitechform.action="k1712_contact.jsp?con_id="+vCon_id;
		}else{
			 window.sitechform.action="k1712_contact.jsp";
		}
   window.sitechform.method='post';
   window.sitechform.submit();
}

//zengzq add for 中测 start
function testRandomCheck(){
	if(1>'<%=testRows.length%>'){
		rdShowMessageDialog('未获取到随机记录，请重新质检',0);
		return false;
	}else{
		//alert("随机质检:"+'<%=testRows.length%>');
		testCheckPlan('<%=testRows[((int)(Math.random()*testDataNum))][0]%>','<%=testRows[((int)(Math.random()*testDataNum))][22]%>');


	}
}
//zengzq add for 中测 end

//跳转到指定页面
function jumpToPage(operateCode){
	//alert(operateCode);
	 if(operateCode=="jumpToPage")
   {
   	  var thePage=document.getElementById("thePage").value;
   	  if(trim(thePage)!=""){
   		 window.sitechform.page.value=parseInt(thePage);
   		 doLoad('0');
   	  }
   }
   else if(operateCode=="jumpToPage1")
   {
   	  var thePage=document.getElementById("thePage1").value;
   	  if(trim(thePage)!=""){
   		 window.sitechform.page.value=parseInt(thePage);
       doLoad('0');
      }
   }else if(trim(operateCode)!=""){
   	 window.sitechform.page.value=parseInt(operateCode);
   	 doLoad('0');
   }
}
//=========================================================================
// LOAD PAGES.
//=========================================================================
function doLoad(operateCode){
	 var str='1';
   if(operateCode=="load")
   {
   	window.sitechform.page.value="";
   	str='0';
   }
   else if(operateCode=="first")
   {
   	window.sitechform.page.value=1;
   }
   else if(operateCode=="pre")
   {
   	window.sitechform.page.value=<%=(curPage-1)%>;
   }
   else if(operateCode=="next")
   {
   	window.sitechform.page.value=<%=(curPage+1)%>;
   }
   else if(operateCode=="last")
   {
   	window.sitechform.page.value=<%=pageCount%>;
   }
    keepValue();
    submitMe(str);
    }

//清除表单记录
function clearValue(){
var e = document.forms[0].elements;
for(var i=0;i<e.length;i++){
  if(e[i].type=="select-one"||e[i].type=="text"||e[i].type=="hidden"){
  	if(e[i].id=="start_date"){
	  	e[i].value='<%=getCurrDateStr("00:00:00")%>';
	  }else if(e[i].id=="end_date"){
	  	e[i].value='<%=getCurrDateStr("23:59:59")%>';
	  }else{
	  	e[i].value="";
	  }
  }else if(e[i].type=="checkbox"){
  	e[i].checked=false;
  }
 }
 window.location="k1712_contact.jsp";
}

//导出
function expExcel(expFlag){
	  document.sitechform.action="<%=request.getContextPath()%>/npage/callbosspage/k170/k1712_contact.jsp?exp="+expFlag;
    window.sitechform.page.value="<%=curPage%>";
    keepValue();
    document.sitechform.method='post';
    document.sitechform.submit();
}

//显示通话详细信息
function getCallDetail(contact_id,start_date){
	if(contact_id==''){
		return;
		}
		var path="<%=request.getContextPath()%>/npage/callbosspage/k170/k170_getCallDetail.jsp";
    path = path + "?contact_id=" + contact_id;
    path = path + "&start_date=" + start_date;
    openWinMid(path,"信息详情",680,960);
	return true;
}
 //保留查询的值
function keepValue(){
   window.sitechform.statisfy.value="<%=request.getParameter("statisfy")%>";
   window.sitechform.grade.value="<%=request.getParameter("grade")%>";
   window.sitechform.accid.value="<%=request.getParameter("accid")%>";
   window.sitechform.region.value="<%=request.getParameter("region")%>";
   window.sitechform.oper.value="<%=request.getParameter("oper")%>";
   window.sitechform.hangup.value="<%=request.getParameter("hangup")%>";
   window.sitechform.listen.value="<%=request.getParameter("listen")%>";
   window.sitechform.skill.value="<%=request.getParameter("skill")%>";
   window.sitechform.region_code.value="<%=request.getParameter("1_=_region_code")%>";
   window.sitechform.oper_code.value="<%=request.getParameter("17_=_staffcity")%>";
   window.sitechform.statisfy_code.value="<%=request.getParameter("9_=_statisfy_code")%>";
   window.sitechform.grade_code.value="<%=request.getParameter("6_=_grade_code")%>";
   window.sitechform.acceptid.value="<%=request.getParameter("16_=_acceptid")%>";
   window.sitechform.staffHangup.value="<%=request.getParameter("15_=_staffHangup")%>";
   window.sitechform.listen_flag.value="<%=request.getParameter("13_!=_listen_flag")%>";
   window.sitechform.skill_quence.value="<%=request.getParameter("14_=_skill_quence")%>";

   window.sitechform.start_date.value="<%=start_date%>";//为显示详细信息页面传递开始时间
   window.sitechform.end_date.value="<%=end_date%>";
   window.sitechform.sqlFilter.value="<%=sqlFilter%>";
   //window.sitechform.oper_code.value="";//员工地市
   window.sitechform.contact_id.value="<%=contact_id%>";
   window.sitechform.mail_address.value="<%=mail_address%>";
   window.sitechform.accept_login_no.value="<%=accept_login_no%>";
   window.sitechform.accept_phone.value="<%=accept_phone%>";
   window.sitechform.contact_address.value="<%=contact_address%>";
   window.sitechform.contact_phone.value="<%=contact_phone%>";
   window.sitechform.caller_phone.value="<%=caller_phone%>";
   window.sitechform.cust_name.value="<%=cust_name%>";
   window.sitechform.fax_no.value="<%=fax_no%>";
   window.sitechform.accept_long_begin.value="<%=accept_long_begin%>";
   window.sitechform.accept_long_end.value="<%=accept_long_end%>";
   window.sitechform.callee_phone.value="<%=callee_phone%>";

}


//居中打开窗口
function openWinMid(url,name,iHeight,iWidth)
{
  //var url; //转向网页的地址;
  //var name; //网页名称，可为空;
  //var iWidth; //弹出窗口的宽度;
  //var iHeight; //弹出窗口的高度;
  var iTop = (window.screen.availHeight-30-iHeight)/2; //获得窗口的垂直位置;
  var iLeft = (window.screen.availWidth-10-iWidth)/2; //获得窗口的水平位置;
  window.open(url,name,'height='+iHeight+',innerHeight='+iHeight+',width='+iWidth+',innerWidth='+iWidth+',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=yes,resizeable=no,location=no,status=no');
}

function getLoginNo(){
  openWinMid('k170_getLoginNo.jsp','工号查询',240,320);
}
function keepRec(id){
	//rdShowMessageDialog("另存录音到本地",2);
	if(id==''){
		return;
		}
  //var a=window.showModalDialog("k170_getCallListen.jsp?flag_id="+id,window,"dialogHeight: 650px; dialogWidth: 850px;");
 openWinMid("k170_download.jsp?flag_id="+id,'另存录音到本地',450,850);
}
function showCallLoc(){
	//rdShowMessageDialog("显示呼叫轨迹",2);
	//openWinMid("k170_showCallLoc.jsp",'显示呼叫轨迹',480,640);
}

//判断当前工号是否有该流水工号的质检计划
function checkIsHavePlan(serialnum,flag,staffno){
	var mypacket = new AJAXPacket(<%=request.getContextPath()%>"/npage/callbosspage/k170/k170_checkIsHavePlan_rpc.jsp","正在进行计划校验，请稍候......");
	mypacket.data.add("serialnum",serialnum);
  mypacket.data.add("start_date",window.sitechform.start_date.value);
  mypacket.data.add("flag",flag);
  mypacket.data.add("staffno",staffno);
  core.ajax.sendPacket(mypacket,doProcessIsHavePlan,true);
	mypacket=null;
}

function doProcessIsHavePlan(packet){
	var serialnum = packet.data.findValueByName("serialnum");
	var planCounts = packet.data.findValueByName("planCounts");
	var flag = packet.data.findValueByName("flag");
  var staffno = packet.data.findValueByName("staffno");
	//alert(parseInt(checkList)+parseInt(checkMutList));
  if(parseInt(planCounts)>0){
    checkIsQc(serialnum,flag,staffno);
	}else{
		rdShowMessageDialog("您目前无该工号的质检计划！");
	}
}

//质检前判断是否已被质检过
//flag 0:计划外质检 1:计划内质检
function checkIsQc(serialnum,flag,staffno){
	var mypacket = new AJAXPacket(<%=request.getContextPath()%>"/npage/callbosspage/k170/k170_checkIsQc_rpc.jsp","正在进行已质检校验，请稍候......");
	mypacket.data.add("serialnum",serialnum);
  mypacket.data.add("start_date",window.sitechform.start_date.value);
  mypacket.data.add("flag",flag);
  mypacket.data.add("staffno",staffno);
  core.ajax.sendPacket(mypacket,doProcess,true);
	mypacket=null;
}

function doProcess(packet){
	var serialnum = packet.data.findValueByName("serialnum");
	var checkList = packet.data.findValueByName("checkList");
	var isOutPlanflag = packet.data.findValueByName("flag");
  var staffno = packet.data.findValueByName("staffno");
	//alert(parseInt(checkList)+parseInt(checkMutList));
  if(parseInt(checkList)<1){
    planInQua(serialnum,staffno);
	}else{
		rdShowMessageDialog("该流水已经进行过质检，不能重复进行！");
	}
}
/**
  *
  *弹出对流水进行质检窗口
  */
function planInQua(serialnum,staffno){
	var  path = '/npage/callbosspage/checkWork/K217/K218_select_plan.jsp?serialnum=' + serialnum+'&staffno='+staffno;
	//计划内质检tabid为流水加0，计划外质检为流水加1
	if(!parent.parent.document.getElementById(serialnum+0)){
	parent.parent.addTab(true,serialnum+0,'执行质检计划',path);
  }
}

/**
  *
  *弹出对流水计划内质检主窗口
  */
function planInQuaMain(serialnum,staffno,object_id,content_id_checked){
	var  path = '../checkWork/K217/K217_exec_out_plan_qc_main.jsp?serialnum=' + serialnum+'&object_id='+object_id+'&opCode=K218&opName=对流水质检&content_id=' + content_id_checked +'&isOutPlanflag=0&staffno='+staffno;
	var param  = 'dialogWidth=900px;dialogHeight=300px';
	openWinMid(path, '', 760,1024);
}

/**
  *
  *弹出计划外质检窗口
  */
function planOutQua(serialnum,staffno){
	var  path ='/npage/callbosspage/checkWork/K217/K217_select_check_content.jsp?serialnum=' + serialnum+'&staffno='+staffno+'&isOutPlanflag=0';
	var param  = 'dialogWidth=900px;dialogHeight=300px';
	//window.showModalDialog('../checkWork/K217/K217_select_check_content.jsp?serialnum=' + serialnum+'&staffno='+staffno+'&isOutPlanflag=0','', param);
	//window.open(path,'', 'width=900px;height=300px');
	//alert(serialnum);
		if(!parent.parent.document.getElementById(serialnum+1)){
	   parent.parent.addTab(true,serialnum+1,'执行质检计划',path);
    }
}

 //zengzq add for 中测 start
 function testCheckPlan(serialnum,staffno){
 //alert("serialnum:"+serialnum);
 //alert("staffno:"+staffno);
 //return false;
	var  path ='/npage/callbosspage/checkWork/K217/K217_select_check_content.jsp?serialnum=' + serialnum+'&staffno='+staffno+'&isOutPlanflag=0&isTest=0';
	var param  = 'dialogWidth=900px;dialogHeight=300px';
		if(!parent.parent.document.getElementById(serialnum+1)){
	   parent.parent.addTab(true,serialnum+1,'执行质检计划',path);
    }
  self.window.location.href = self.window.location.href;
}
 //zengzq add for 中测 end

/**
  *
  *弹出对流水计划外质检主窗口
  */
  /*
function planOutQuaMain(serialnum,staffno,object_id,content_id){
	//alert("open");
	var param  = 'dialogWidth=900px;dialogHeight=300px';
	//window.showModalDialog('../checkWork/K217/K218_select_plan.jsp?serialnum=' + serialnum+'&staffno='+staffno, '', param);
	//window.open('../K217/K217_exec_out_plan_qc_main.jsp?serialnum=' + serialnum + '&object_id=' +object_id + '&content_id=' + content_id +'&isOutPlanflag=1&staffno='+staffno, '', 'width=1024px;height=768px');
	 openWinMid('../K217/K217_exec_out_plan_qc_main.jsp?serialnum=' + serialnum + '&object_id=' +object_id + '&content_id=' + content_id +'&isOutPlanflag=1&staffno='+staffno,'',760,1024);
}
*/
function keepRecToSer(){
	//rdShowMessageDialog("转存录音到服务器",2);
}
function getWorkInfo(){
	//rdShowMessageDialog("查看对应工单信息",2);
}

	//导出窗口
	function showExpWin(flag){
		window.sitechform.page.value="<%=curPage%>";
		//alert("<%=sqlFilter%>");
	  window.sitechform.sqlWhere.value="<%=sqlFilter%>";

		openWinMid('k171_expSelect.jsp?flag='+flag,'选择导出列',340,320);
	 }

//去左空格;
function ltrim(s){
  return s.replace( /^\s*/, "");
}
//去右空格;
function rtrim(s){
return s.replace( /\s*$/, "");
}
//去左右空格;
function trim(s){
return rtrim(ltrim(s));
}

//选中行高亮显示
var hisObj="";//保存上一个变色对象
var hisColor=""; //保存上一个对象原始颜色

/**
   *hisColor ：当前tr的className
   *obj       ：当前tr对象
   */
function changeColor(color,obj){

  //恢复原来一行的样式
  if(hisObj != ""){
	 for(var i=0;i<hisObj.cells.length;i++){
		var tempTd=hisObj.cells.item(i);
		tempTd.className=hisColor;
	 }
	}
		hisObj   = obj;
		hisColor = color;

  //设置当前行的样式
	for(var i=0;i<obj.cells.length;i++){
		var tempTd=obj.cells.item(i);
		tempTd.className='bright';
	}
}


/**
  *desc  : 中测用，标记流水,中测完毕请删除
  *author: mixh
  *date  : 2009/04/10
  */
function makeSign(){
	var time     = new Date();
	var url      = 'k1711_pop_sign.jsp?time='+time+'&sign_login_no=' + 'sign_login_no' + '&be_sign_login_no=' + 'be_sign_login_no';
	var winParam = 'dialogWidth=800px;dialogHeight=360px';
	window.showModalDialog(url, window, winParam);
}
</script>
<style>
	#Operation_Table {
	margin: 5px;
	padding: 0px;
	width: 100%;
	height:1%;
}
#Operation_Table table{
	font-size: 12px;
	color:#000000;/*#a5b5c0*/
	text-align: left;
	width:100%;
	background-color: #F5F5F5;
	border-top-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-left-style: solid;
	border-top-color: #b9b9b9;
	border-left-color: #b9b9b9;
}
#Operation_Table th{
	padding: 5px;
	text-indent: 5px;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #b9b9b9;
	background-color: #DBE7E8;
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: #b9b9b9;
	margin: 0px;
	font-weight: bold;
	color: #003399;
	text-decoration: none;
	font-size: 12px;
	white-space: nowrap;
}
#Operation_Table td{
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #b9b9b9;
	background-color: #F7F7F7;
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: #b9b9b9;
	margin: 0px;
	padding-top: 3px;
	padding-right: 8px;
	padding-bottom: 3px;
	padding-left: 8px;
	color: #003399;
	white-space: nowrap;
}
#Operation_Table td.Grey {
	color: #003399;
	background-color: #FFFFFF;
}

#Operation_Table td.Blue {
	color: #003399;
	white-space: nowrap;
}

/*hanjc add*/
#Operation_Table td.bright {
	color: #003399;
	background-color: #C1CDCD;
}

#Operation_Table td span {
	white-space: nowrap;
}


#Operation_Table .title {
	background-color: #ececec;
	height: 28px;
	background-image: url(../images/ab.gif);
	background-repeat: no-repeat;
	background-position: 10px 10px;
	padding-left: 28px;
	font-size: 12px;
	font-weight: bold;
	text-decoration: none;
	color: #0066CC;
	text-align: left;
	padding-top: 10px;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #b9b9b9;
}
</style>

</head>


<body >
<form id=sitechform name=sitechform>
<%@ include file="/npage/include/header.jsp"%>
	<div id="Operation_Table">
		<div class="title"> </div>
		<table cellspacing="0" style="width:650px">

      <tr >
      <td > 开始时间 </td>
      <td >
			  <input id="start_date" name ="start_date" type="text"  value="<%=(start_date==null)?getCurrDateStr("00:00:00"):start_date%>" onclick="WdatePicker({dateFmt:'yyyyMMdd HH:mm:ss',position:{top:'under'}});hiddenTip(document.sitechform.start_date);return false;">
		    <img onclick="WdatePicker({el:$dp.$('start_date'),dateFmt:'yyyyMMdd HH:mm:ss',position:{top:'under'}});return false;" src="<%=request.getContextPath()%>/npage/callbosspage/js/datepicker/skin/datePicker.gif" width="16" height="22" align="absmiddle">
		    <font color="orange">*</font>
		  </td>
      <td > 员工地市 </td>
      <td >
			 <select id="oper_code" name="17_=_staffcity" size="1"  onchange="oper.value=this.options[this.selectedIndex].text">
			 	<!-- value 为空，查询时会自动忽略此条件-->
        <%if(oper_code==null || oper_code.equals("")|| request.getParameter("oper")==null || request.getParameter("oper").equals("")){%>
			 	<option value="" selected>--所有员工地市--</option>
				    <wtc:qoption name="s151Select" outnum="2">
				    <wtc:sql>select region_code , region_code|| '-->' ||region_name from scallregioncode where valid_flag = 'Y' order by region_code</wtc:sql>
				  </wtc:qoption>
			 	<%}else {%>
      	 	 	<option value="" >--所有员工地市--</option>
      	 			<option value="<%=oper_code%>" selected >
      	 				<%=request.getParameter("oper")%>
      	 			</option>
				    <wtc:qoption name="s151Select" outnum="2">
				    <wtc:sql>select region_code , region_code|| '-->' ||region_name from scallregioncode where valid_flag = 'Y' and region_code<>'<%=oper_code%>' order by region_code</wtc:sql>
				  </wtc:qoption>
      	 	<%}%>
        </select>
        <input name="oper" type="hidden" value="<%=request.getParameter("oper")%>">
			  <font color="red">+</font>
      </td>
      <td > 流水号 </td>
      <td >
				<input id="contact_id" name="0_=_contact_id" onkeyup="hiddenTip(this)" type="text" value=<%=(contact_id==null)?"":contact_id%>>
				<font color="red">+</font>

      </td>
      <td > 电子邮件 </td>
      <td >
			  <input name="4_=_mail_address" type="text" maxlength="80"  id="mail_address"  value="<%=(mail_address==null)?"":mail_address%>">
      </td>
    </tr>
    <!-- THE SECOND LINE OF THE CONTENT -->
    <tr >
      <td > 结束时间 </td>
      <td >
			  <input id="end_date" name ="end_date" type="text"   value="<%=(end_date==null)?getCurrDateStr("23:59:59"):end_date%>" onclick="WdatePicker({dateFmt:'yyyyMMdd HH:mm:ss',position:{top:'under'}});hiddenTip(document.sitechform.end_date);">
		    <img onclick="WdatePicker({el:$dp.$('end_date'),dateFmt:'yyyyMMdd HH:mm:ss',position:{top:'under'}})" src="<%=request.getContextPath()%>/npage/callbosspage/js/datepicker/skin/datePicker.gif" width="16" height="22" align="absmiddle">
		    <font color="orange">*</font>
		  </td>
		  <td > 受理工号 </td>
      <td >
			  <input name ="2_=_accept_kf_login_no" type="text" id="accept_login_no" onkeyup="hiddenTip(this)"  value="<%=(accept_login_no==null)?"":accept_login_no%>">
		    <img onclick="getLoginNo()" src="<%=request.getContextPath()%>/npage/callbosspage/js/datepicker/skin/datePicker.gif" width="16" height="22" align="absmiddle" >
		    <font color="red">+</font>
		  </td>
		  <td > 受理号码 </td>
      <td >
			  <input name ="3_=_accept_phone"  maxlength="15" type="text" id="accept_phone"  value="<%=(accept_phone==null)?"":accept_phone%>" onkeyup="hiddenTip(this);value=value.replace(/[^\d]/g,'') "onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))">
		   <font color="red">+</font>
		  </td>
		  <td > 联系地址 </td>
      <td >
			  <input name ="5_=_contact_address" type="text" id="contact_address"  value="<%=(contact_address==null)?"":contact_address%>">
     </td>
     </tr>
    <!-- THE THIRD LINE OF THE CONTENT -->
     <tr >
      <td > 客户级别 </td>
      <td >
			  <select name="6_=_grade_code" id="grade_code" size="1" onchange="grade.value=this.options[this.selectedIndex].text">
			  	<%if(grade_code==null || grade_code.equals("") || request.getParameter("grade").equals("") || request.getParameter("grade")==null){%>
			  	 <option value="" selected>--所有客户级别--</option>
					<wtc:qoption name="s151Select" outnum="2">
				<wtc:sql>select accept_code , accept_code|| '-->' ||accept_name from scallgradecode order by accept_code</wtc:sql>
				</wtc:qoption>
			  	<%}else {%>
      	 	 	<option value="" >--所有客户级别--</option>
			  	    <option value="<%=grade_code%>" selected >
      	 				<%=request.getParameter("grade")%>
      	 			</option>
					<wtc:qoption name="s151Select" outnum="2">
				<wtc:sql>select accept_code , accept_code|| '-->' ||accept_name from scallgradecode where accept_code<>'<%=grade_code%>' order by accept_code</wtc:sql>
				</wtc:qoption>
      	 	<%}%>

        </select>
				<input name="grade" type="hidden" value="<%=request.getParameter("grade")%>">
		  </td>
		  <td > 联系电话 </td>
      <td >
			  <input name ="7_=_contact_phone" type="text" id="contact_phone"  value="<%=(contact_phone==null)?"":contact_phone%>">
		  </td>
		  <td > 主叫号码 </td>
      <td >
			  <input name ="8_=_caller_phone" type="text" id="caller_phone"  value="<%=(caller_phone==null)?"":caller_phone%>" onkeyup="value=value.replace(/[^\d]/g,'') "onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))">
		  </td>
		  <td > 客户满意度 </td>
      <td >
      	 <select name="9_=_statisfy_code" id="statisfy_code" size="1" onchange="statisfy.value=this.options[this.selectedIndex].text">
      	 	<%if(statisfy_code==null || statisfy_code.equals("") || request.getParameter("statisfy")==null || request.getParameter("statisfy").equals("")){%>
      	 	<option value="" selected >--所有满意度--</option>
				  <wtc:qoption name="s151Select" outnum="2">
				   <wtc:sql>select satisfy_code , satisfy_code|| '-->' ||satisfy_name from ssatisfytype where valid_flag = '1'</wtc:sql>
				  </wtc:qoption>
      	 	<%}else {%>
      	 	 	<option value="" >--所有满意度--</option>
      	 			<option value="<%=statisfy_code%>" selected >
      	 				<%=request.getParameter("statisfy")%>
      	 			</option>
				  <wtc:qoption name="s151Select" outnum="2">
				   <wtc:sql>select satisfy_code , satisfy_code|| '-->' ||satisfy_name from ssatisfytype where valid_flag = '1' and satisfy_code<>'<%=statisfy_code%>'</wtc:sql>
				  </wtc:qoption>
      	 	<%}%>
        </select>
       <input name="statisfy" type="hidden" value="<%=request.getParameter("statisfy")%>">
		  </td>
     </tr>
    <!-- THE THIRD LINE OF THE CONTENT -->
     <tr >
      <td > 客户姓名 </td>
      <td >
			  <input name ="10_=_cust_name" type="text" id="cust_name"  value="<%=(cust_name==null)?"":cust_name%>">
		  </td>
		  <td > 传真号码 </td>
      <td >
			  <input name ="11_=_fax_no" type="text" id="fax_no"  value="<%=(fax_no==null)?"":fax_no%>">
		  </td>
		  <td > 受理方式 </td>
      <td >
		  <select name="16_=_acceptid" id="acceptid" size="1" onchange="accid.value=this.options[this.selectedIndex].text">
		  	<%if(acceptid==null || acceptid.equals("") || request.getParameter("accid").equals("")|| request.getParameter("accid")==null){%>
		  	  <option value="" selected>--所有受理方式--</option>
				  <wtc:qoption name="s151Select" outnum="2">
				   <wtc:sql>select accept_code , accept_code|| '-->' ||accept_name from SCALLACCEPTCODE</wtc:sql>
				  </wtc:qoption>
		  	<%}else {%>
		  	  <option value="" >--所有受理方式--</option>
          <option value="<%=acceptid%>" selected ><%=request.getParameter("accid")%></option>
				  <wtc:qoption name="s151Select" outnum="2">
				   <wtc:sql>select accept_code , accept_code|| '-->' ||accept_name from SCALLACCEPTCODE where accept_code<>'<%=acceptid%>'</wtc:sql>
				  </wtc:qoption>
      	 	<%}%>
        </select>
        <input name="accid" type="hidden" value="<%=request.getParameter("accid")%>">
		  </td>
		  <td > 受理时长 </td>
      <td >
			  ><input name ="accept_long_begin" type="text" id="accept_long_begin"  maxlength="5" style="width:60px" value="<%=(accept_long_begin==null)?"":accept_long_begin%>" onkeyup="value=value.replace(/[^\d]/g,'') "onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))">
			  <<input name ="accept_long_end" type="text" id="accept_long_end"      maxlength="5" style="width:60px"  value="<%=(accept_long_end==null)?"":accept_long_end%>" onkeyup="value=value.replace(/[^\d]/g,'') "onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))">
		  </td>
     </tr>
    <!-- THE THIRD LINE OF THE CONTENT -->
    <tr >
      <td > 客户地市 </td>
      <td >
			 <select id="region_code" name="1_=_region_code" size="1" onchange="region.value=this.options[this.selectedIndex].text">
			 	<%if(region_code==null || "".equals(region_code)|| request.getParameter("region")==null || request.getParameter("region").equals("")){%>
			 	<option value="" selected>--所有客户地市--</option>
				   <wtc:qoption name="s151Select" outnum="2">
				    <wtc:sql>select region_code , region_code|| '-->' ||region_name from scallregioncode where valid_flag = 'Y' order by region_code</wtc:sql>
				   </wtc:qoption>
			 	<%}else {%>
      	 	 	<option value="" >--所有客户地市--</option>
      	 		<option value="<%=region_code%>" selected ><%=request.getParameter("region")%></option>
				    <wtc:qoption name="s151Select" outnum="2">
				     <wtc:sql>select region_code , region_code|| '-->' ||region_name from scallregioncode where valid_flag = 'Y' and region_code<>'<%=region_code%>' order by region_code</wtc:sql>
				    </wtc:qoption>
      	 <%}%>
        </select>
        <input name="region" type="hidden" value="<%=request.getParameter("region")%>">
      </td>
      <td > 被叫号码 </td>
      <td >
<input name ="12_=_callee_phone" type="text" id="callee_phone"  value="<%=(callee_phone==null)?"":callee_phone%>" onkeyup="value=value.replace(/[^\d]/g,'') "onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))">

      </td>
      <td > 挂机方 </td>
      <td >
        <select name="15_=_staffHangup" id="staffHangup" size="1" onchange="hangup.value=this.options[this.selectedIndex].text">
        	<%if(staffHangup==null|| staffHangup.equals("")||request.getParameter("hangup").equals("") || request.getParameter("hangup")==null){%>
        	   <option value="" selected>全部</option>
				      <wtc:qoption name="s151Select" outnum="2">
				       <wtc:sql>select hangup_code , hangup_code|| '-->' ||hangup_name from staffhangup order by hangup_code</wtc:sql>
				      </wtc:qoption>
        	<%}else {%>
      	 	 	<option value="" >全部</option>
      	 		<option value="<%=staffHangup%>" selected ><%=request.getParameter("hangup")%></option>
				     <wtc:qoption name="s151Select" outnum="2">
				      <wtc:sql>select hangup_code , hangup_code|| '-->' ||hangup_name from staffhangup  where hangup_code<>'<%=staffHangup%>' order by hangup_code</wtc:sql>
				     </wtc:qoption>
      	 	<%}%>
        </select>
        <input name="hangup" type="hidden" value="<%=request.getParameter("hangup")%>">
      </td>
      <td > 录音听取标志 </td>
      <td >
        <select id="listen_flag" name="13_!=_listen_flag" size="1" onchange="listen.value=this.options[this.selectedIndex].text">
        	<%if(listen_flag==null || listen_flag.equals("") || request.getParameter("listen").equals("")|| request.getParameter("listen")==null){%>
        	<option value="" selected>全部</option>
				<wtc:qoption name="s151Select" outnum="2">
				<wtc:sql>select listen_flag_code , listen_flag_code|| '-->' ||listen_flag_name from SLISTENFLAG</wtc:sql>
				</wtc:qoption>
        		<%}else {%>
      	 	 	<option value="" >全部</option>
      	 			<option value="<%=listen_flag%>" selected >
      	 				<%=request.getParameter("listen")%>
      	 			</option>
				<wtc:qoption name="s151Select" outnum="2">
				<wtc:sql>select listen_flag_code , listen_flag_code|| '-->' ||listen_flag_name  from SLISTENFLAG where listen_flag_code<>'<%=listen_flag%>'</wtc:sql>
				</wtc:qoption>
      	 	<%}%>
        </select>
        <input name="listen" type="hidden" value="<%=request.getParameter("listen")%>">
      </td>
    </tr>
        <!-- THE THIRD LINE OF THE CONTENT -->
    <tr >
      <td >技能队列 </td>
      <td colspan="7" >
        <select id="skill_quence" name="14_=_skill_quence" size="1" onchange="skill.value=this.options[this.selectedIndex].text">
        	<%if(skill_quence==null || skill_quence.equals("")|| request.getParameter("skill")==null || request.getParameter("skill").equals("")){%>
        	<option value="" selected>--所有技能队列--</option>
				  <wtc:qoption name="s151Select" outnum="2">
				  <wtc:sql>select skill_queue_id , skill_queue_id|| '-->' ||skill_queud_name from dagskillqueue</wtc:sql>
				  </wtc:qoption>
        	<%}else {%>
           <option value="" >--所有技能队列--</option>
      	 			<option value="<%=skill_quence%>" selected >
      	 				<%=request.getParameter("skill")%>
      	 			</option>
				  <wtc:qoption name="s151Select" outnum="2">
				  <wtc:sql>select skill_queue_id , skill_queue_id|| '-->' ||skill_queud_name from dagskillqueue where skill_queue_id<>'<%=skill_quence%>' </wtc:sql>
				  </wtc:qoption>
      	 	 <%}%>
        </select>
        <input name="skill" type="hidden" value="<%=request.getParameter("skill")%>">
      </td>
    </tr>
	 <tr >

    </tr>
        <!-- ICON IN THE MIDDLE OF THE PAGE-->
    <tr >
      <td colspan="8" align="center" id="footer" style="width:600px">
       <input name="delete_value" type="button"  id="add" value="重设" onClick="clearValue();">
       <!--input name="delete_value" type="button"  id="add" value="重设" onClick="history.go(0);"-->
       <input name="search" type="button"  id="search" value="查询" onClick="submitInputCheck();">

			 <!--input name="export" type="button"  id="search" value="导出" <%if(dataRows.length!=0) out.print("onClick=\"expExcel('cur')\"");%>>
       <input name="exportAll" type="button"  id="add" value="导出全部" <%if(dataRows.length!=0) out.print("onClick=\"expExcel('all')\"");%>-->

       <!--zengzq add for 中测-->

      </td>
    </tr>
		</table>
	</div>
  <div id="Operation_Table">
  	<table  cellspacing="0">
    <tr>
      <td class="blue"  align="left" width="720">
        <%if(pageCount!=0){%>
        第<%=curPage%>页 共 <%=pageCount%>页 共 <%=rowCount%>条
        <%} else{%>
        <font color="orange">当前记录为空！</font>
        <%}%>
        <%if(pageCount!=1 && pageCount!=0){%>
        <a href="#"   onClick="doLoad('first');return false;">首页</a>
        <%}%>
        <%if(curPage>1){%>
        <a href="#"  onClick="doLoad('pre');return false;">上一页</a>
        <%}%>
        <%if(curPage<pageCount){%>
        <a href="#" onClick="doLoad('next');return false;">下一页</a>
        <%}%>
        <%if(pageCount>1){%>
        <a href="#" onClick="doLoad('last');return false;">尾页</a>&nbsp;
        <a>快速选择</a>
        <select onchange="jumpToPage(this.value)">
        <%for(int i=1;i<=pageCount;i++){
        	out.print("<option value='"+i+"'");
        	if(i==curPage){
        	 out.print("selected");
        	}
        	out.print(">"+i+"</option>");
        }%>
      </select style="height:18px">&nbsp;&nbsp;
        <a>快速跳转</a>
        <input id="thePage" name="thePage" type="text" value="<%=curPage%>" style="height:18px;width:30px"  onkeyup="hiddenTip(this);value=value.replace(/[^\d]/g,'') "onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))"/><a href="#" onClick="jumpToPage('jumpToPage');return false;">
        	<font face=粗体>GO</font>
        <%}%>
      </td>
    </tr>
  </table>
      <table  cellSpacing="0" >
			  <input type="hidden" name="page" value="">
			  <input type="hidden" name="myaction" value="">
			  <input type="hidden" name="sqlFilter" value="">
			  <input type="hidden" name="sqlWhere" value="">
          <tr >
       <script>
       	var tempBool ='flase';
      	if(checkRole(K171A_RolesArr)==true||checkRole(K171B_RolesArr)==true||checkRole(K171C_RolesArr)==true||checkRole(K171D_RolesArr)==true||checkRole(K171E_RolesArr)==true||checkRole(K171F_RolesArr)==true||checkRole(K171G_RolesArr)==true||checkRole(K171H_RolesArr)==true){
      		//document.write('<th align="center" class="blue" width="15%" > 操作 </th>');
      		//tempBool='true';
      	}
        </script>
            <th align="center" class="blue" width="8%" > 流水号 </th>
            <th align="center" class="blue" width="8%" > 受理方式</th>
            <th align="center" class="blue" width="8%" > 客户姓名 </th>
            <th align="center" class="blue" width="8%" > 客户地市 </th>
            <th align="center" class="blue" width="8%" > 受理号码</th>
            <th align="center" class="blue" width="8%" > 主叫号码 </th>
            <th align="center" class="blue" width="8%" > 被叫号码</th>
            <th align="center" class="blue" width="8%" > 受理时间</th>
            <th align="center" class="blue" width="8%" > 受理时长</th>
            <th align="center" class="blue" width="8%" > 受理工号</th>
            <th align="center" class="blue" width="8%" > 挂机方 </th>
            <th align="center" class="blue" width="8%" > 是否质检</th>
            <th align="center" class="blue" width="8%" > 客户满意度 </th>
            <th align="center" class="blue" width="8%" > 服务语种</th>
            <th align="center" class="blue" width="8%" > 来电原因</th>
            <th align="center" class="blue" width="8%" > 录音听取标志 </th>
           <!-- <th align="center" class="blue" width="8%" > 是否使用放音</th>-->
            <th align="center" class="blue" width="8%" > 质检员工号</th>
            <th align="center" class="blue" width="8%" > 是否密码验证</th>
            <th align="center" class="blue" width="8%" > 是否他机验证</th>
            <th align="center" class="blue" width="8%" > 备注</th>
            <th align="center" class="blue" width="8%" > 转接备注</th>
          </tr>

          <% for ( int i = 0; i < dataRows.length; i++ ) {
                String tdClass="";
           %>

         <%if((i+1)%2==1){
          tdClass="grey";
          }%>
	   <tr onClick="changeColor('<%=tdClass%>',this);"  >

     
      <!--
       <img style="cursor:hand" onclick="checkCallListen('<%=dataRows[i][0]%>');return false;" alt="听取语音" src="<%=request.getContextPath()%>/nresources/default/images/callimage/operImage/1.gif" width="16" height="16" align="absmiddle"
       <img style="cursor:hand" onclick="getCallDetail('<%=dataRows[i][0]%>','<%=start_date%>');return false;" alt="显示该通话的详细情况" src="<%=request.getContextPath()%>/nresources/default/images/callimage/operImage/4.gif"  width="16" height="16" align="absmiddle">
       <img style="cursor:hand" onclick="keepRec('<%=dataRows[i][0]%>')" alt="另存录音到本地" src="<%=request.getContextPath()%>/nresources/default/images/callimage/operImage/3.gif" width="16" height="16" align="absmiddle">
       <img style="cursor:hand" onclick="showCallLoc()" alt="显示呼叫轨迹" src="<%=request.getContextPath()%>/nresources/default/images/callimage/operImage/11.gif" width="16" height="16" align="absmiddle">
       <img style="cursor:hand" onclick="checkIsHavePlan('<%=dataRows[i][0]%>',1,'<%=dataRows[i][22]%>')" alt="计划内质检考评" src="<%=request.getContextPath()%>/nresources/default/images/callimage/operImage/5.gif" width="16" height="16" align="absmiddle">
       <img style="cursor:hand" onclick="planOutQua('<%=dataRows[i][0]%>','<%=dataRows[i][22]%>')" alt="计划外质检考评" src="<%=request.getContextPath()%>/nresources/default/images/callimage/operImage/9.gif" width="16" height="16" align="absmiddle">
       <img style="cursor:hand" onclick="keepRecToSer()" alt="转存录音到服务器" src="<%=request.getContextPath()%>/nresources/default/images/callimage/operImage/6.gif" width="16" height="16" align="absmiddle">
       <img style="cursor:hand" onclick="getWorkInfo()" alt="查看对应工单信息" src="<%=request.getContextPath()%>/nresources/default/images/callimage/operImage/10.gif" width="16" height="16" align="absmiddle">
       -->
      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][0].length()!=0)?dataRows[i][0]:"&nbsp;"%></td>
      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][1].length()!=0)?dataRows[i][1]:"&nbsp;"%></td>
      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][2].length()!=0)?dataRows[i][2]:"&nbsp;"%></td>
      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][3].length()!=0)?dataRows[i][3]:"&nbsp;"%></td>
       <td align="center" class="<%=tdClass%>" ><%=(dataRows[i][4].length()!=0)?dataRows[i][4]:"&nbsp;"%></td>
      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][5].length()!=0)?dataRows[i][5]:"&nbsp;"%></td>
       <td align="center" class="<%=tdClass%>" ><%=(dataRows[i][6].length()!=0)?dataRows[i][6]:"&nbsp;"%></td>
      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][7].length()!=0)?dataRows[i][7]:"&nbsp;"%></td>
       <td align="center" class="<%=tdClass%>" ><%=(dataRows[i][8].length()!=0)?dataRows[i][8]:"&nbsp;"%></td>
      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][22].length()!=0)?dataRows[i][22]:"&nbsp;"%></td>
       <td align="center" class="<%=tdClass%>" ><%=(dataRows[i][10].length()!=0)?dataRows[i][10]:"&nbsp;"%></td>
      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][11].length()!=0)?dataRows[i][11]:"&nbsp;"%></td>
       <td align="center" class="<%=tdClass%>" ><%=(dataRows[i][12].length()!=0)?dataRows[i][12]:"&nbsp;"%></td>
      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][13].length()!=0)?dataRows[i][13]:"&nbsp;"%></td>
       <td align="center" class="<%=tdClass%>" ><%=(dataRows[i][14].length()!=0)?dataRows[i][14]:"&nbsp;"%></td>

      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][15].length()!=0)?dataRows[i][15]:"&nbsp;"%></td>

       <!--td align="center" class="<%=tdClass%>" ><%=(dataRows[i][16].length()!=0)?dataRows[i][16]:"&nbsp;"%></td-->
      <!--td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][17].length()!=0)?dataRows[i][17]:"&nbsp;"%></td-->
      <td align="center" class="<%=tdClass%>"  ><%=(tmpCoun>0)?((dataRows[i][17].length()!=0)?dataRows[i][17]:"&nbsp;"):"******"%></td>
       <td align="center" class="<%=tdClass%>" ><%=(dataRows[i][18].length()!=0)?dataRows[i][18]:"&nbsp;"%></td>
      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][19].length()!=0)?dataRows[i][19]:"&nbsp;"%></td>
      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][20].length()!=0)?dataRows[i][20]:"&nbsp;"%></td>
      <td align="center" class="<%=tdClass%>"  ><%=(dataRows[i][21].length()!=0)?dataRows[i][21]:"&nbsp;"%></td>
    </tr>
      <% } %>
  </table>

  <table  cellspacing="0">
    <tr >
      <td class="blue"  align="right" width="720">
        <%if(pageCount!=0){%>
        第<%=curPage%>页 共 <%=pageCount%>页 共 <%=rowCount%>条
        <%} else{%>
        <font color="orange">当前记录为空！</font>
        <%}%>
        <%if(pageCount!=1 && pageCount!=0){%>
        <a href="#"   onClick="doLoad('first');return false;">首页</a>
        <%}%>
        <%if(curPage>1){%>
        <a href="#"  onClick="doLoad('pre');return false;">上一页</a>
        <%}%>
        <%if(curPage<pageCount){%>
        <a href="#" onClick="doLoad('next');return false;">下一页</a>
        <%}%>
        <%if(pageCount>1){%>
        <a href="#" onClick="doLoad('last');return false;">尾页</a>&nbsp;
        <a>快速选择</a>
        <select onchange="jumpToPage(this.value)">
        <%for(int i=1;i<=pageCount;i++){
        	out.print("<option value='"+i+"'");
        	if(i==curPage){
        	 out.print("selected");
        	}
        	out.print(">"+i+"</option>");
        }%>
      </select style="height:18px">&nbsp;&nbsp;
        <a>快速跳转</a>
        <input id="thePage1" name="thePage1" type="text" value="<%=curPage%>" style="height:18px;width:30px"  onkeyup="hiddenTip(this);value=value.replace(/[^\d]/g,'') "onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))"/><a href="#" onClick="jumpToPage('jumpToPage1');return false;">
        	<font face=粗体>GO</font>
        <%}%>
      </td>
    </tr>
  </table>
</div>
</form>
<%@ include file="/npage/include/footer.jsp"%>
</body>
</html>

