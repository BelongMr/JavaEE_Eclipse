<%
/********************
 * version v2.0
 * 开发商: si-tech
 * update by qidp @ 2009-02-05
 ********************/
 System.out.println(" zhouby 9113");
%>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%@ page contentType= "text/html;charset=GBK" %>
<%
//ArrayList arrSession = (ArrayList)session.getAttribute("allArr");
//String[][] baseInfoSession = (String[][])arrSession.get(0);
//String[][] fiveInfoSession = (String[][])arrSession.get(4);
String org_code =(String)session.getAttribute("orgCode");//归属代码
String workNo = (String)session.getAttribute("workNo");
System.out.println("-------------qidp==="+workNo);
String login_passwd = (String)session.getAttribute("password");//工号密码
String region_code = org_code.substring(0,2);

String[][] callData = null;
String stringArray="";
HashMap runCode=new HashMap();
runCode.put("A","正常")     ;
runCode.put("B","冒高")     ;
runCode.put("C","冒单")     ;
runCode.put("D","欠停")     ;
runCode.put("E","欠单")     ;
runCode.put("F","高额")     ;
runCode.put("G","报停")     ;
runCode.put("H","挂失")     ;
runCode.put("I","预销")     ;
runCode.put("J","预拆")     ;
runCode.put("K","强开")     ;
runCode.put("L","强关")     ;
runCode.put("a","销号")     ;
runCode.put("b","拆机")     ;
runCode.put("c","转网")     ;
runCode.put("M","PPS保号期");

HashMap idTypeMap=new HashMap();
idTypeMap.put("A","组织机构代码");
idTypeMap.put("B","单位法人证书");
idTypeMap.put("C","单位证明 ");
idTypeMap.put("0","身份证");
idTypeMap.put("1","军官证");
idTypeMap.put("2","户口簿");
idTypeMap.put("3","港澳通行证");
idTypeMap.put("4","警官证");
idTypeMap.put("5","台湾通行证");
idTypeMap.put("6","外国公民护照");
idTypeMap.put("7","营业执照");
idTypeMap.put("8","护照");
idTypeMap.put("9","其它");

String phoneNo = request.getParameter("phoneno");
String passwd = request.getParameter("passwd")==null?"":request.getParameter("passwd");
String []  inputParam = new String [5] ;
ArrayList retArray = new ArrayList();
inputParam[0]="01";
inputParam[1]=phoneNo;
inputParam[2]=passwd;
inputParam[3]="";
inputParam[4]="";

String retMessage = "";
String custname="";
String runcode="";
String brand="";
String idNo="";
String idtype = "";
String iccid = "";
%>

<wtc:service  name="sPubCustCheck"  routerKey="phone"  routerValue="<%=phoneNo%>"  outnum="5" retcode="return_code" retmsg="return_msg">
	<wtc:param  value="01"/>
	<wtc:param  value="<%=phoneNo%>"/>
	<wtc:param  value="<%=passwd%>"/>
	<wtc:param  value=""/>
	<wtc:param  value=""/>
	<wtc:param  value="<%=workNo%>"/>
</wtc:service>
<wtc:array  id="nameArr"  start="0"  length="1" scope="end" />
<wtc:array  id="statArr"  start="0"  length="1" scope="end" />
<wtc:array  id="brandArr"  start="2"  length="1" scope="end" />
<%
if(return_code.equals("000000")){
	custname=nameArr[0][0];
	runcode=statArr[0][0];
	brand=brandArr[0][0];
	runcode=runcode+"->"+runCode.get(runcode.substring(1,2));

  String password = (String)session.getAttribute("password");
	String work_no = (String)session.getAttribute("workNo");
	String ssss = "根据" + phoneNo + "进行查询";
%>
	<wtc:sequence name="sPubSelect" key="sMaxSysAccept" id="loginAccept"/>
  
  <wtc:service name="sUserCustInfo" outnum="40" >
      <wtc:param value="<%=loginAccept%>"/>
      <wtc:param value="01"/>
      <wtc:param value="9113"/>
      <wtc:param value="<%=work_no%>"/>
      <wtc:param value="<%=password%>"/>
      <wtc:param value="<%=phoneNo%>"/>
      <wtc:param value=""/>
      <wtc:param value=""/>
      <wtc:param value="<%=ssss%>"/>
      <wtc:param value=""/>
      <wtc:param value=""/>
      <wtc:param value=""/>
      <wtc:param value=""/>
  </wtc:service>
    
	<wtc:array id="result_cust">
	<%
	if(result_cust != null){
		callData=result_cust;
		custname=result_cust[0][5];;	
		idNo=result_cust[0][30];
		idtype = (String)idTypeMap.get(result_cust[0][12]);
		iccid = result_cust[0][13];
	} 
	%>
  </wtc:array>
  
<%
	String switchSql="select distinct a.info_code,a.info_name,substr(a.info_code,2,2) info_code,DECODE(NVL (msisdn, '1'), '1', '1', '0') phone_no from (select distinct info_code,info_name from smobileinfocode) a,(select msisdn,switch_type from dmobileinfo where msisdn='"+phoneNo+"' and end_time > sysdate) b where a.info_code=b.switch_type(+)";
	stringArray = "var arrMsg = new Array(";
%>
	<wtc:service name="sPubSelect"  outnum="4" routerKey="phone" routerValue="<%=phoneNo%>">
		<wtc:param value="<%=switchSql%>"/>   
	</wtc:service>                                                
	<wtc:array id="ret2" scope="end" /> 	
<%
	if(ret2!=null){
		callData=ret2;
		int flag = 1;
		for (int i = 0; i < ret2.length; i++) {
	    if (flag == 1) {
	      stringArray += "new Array()";
	      flag = 0;
	    }
	    else if (flag == 0) {
	      stringArray += ",new Array()";
	    }
	  }
  }
	else{
		callData=new String[][]{};
	}
  stringArray += ");"; 
   
}
else{
	callData=new String[][]{};
	stringArray="var arrMsg = new Array();";
}

%>
<%=stringArray%>
<%
for(int i = 0 ; i < callData.length ; i ++){
  for(int j = 0 ; j < callData[i].length ; j ++){
		if(callData[i][j].trim().equals("") || callData[i][j] == null){
		   callData[i][j] = "";
		}
		System.out.println("callData["+i+"]["+j+"]=[" + callData[i][j].trim() + "]");
%>
		arrMsg[<%=i%>][<%=j%>] = "<%=callData[i][j].trim()%>";
<%
  }
}
%> 
var response = new AJAXPacket();
response.guid = '<%= request.getParameter("guid") %>';
response.data.add("verifyType","phoneno");
response.data.add("errorCode","<%=return_code%>");
response.data.add("errorMsg","<%=return_msg%>");
response.data.add("custname","<%=custname%>");
response.data.add("runcode","<%=runcode%>");
response.data.add("brand","<%=brand%>");
response.data.add("idNo","<%=idNo%>");
response.data.add("iccid","<%=iccid%>");
response.data.add("idtype","<%=idtype%>");
response.data.add("backArrMsg",arrMsg );

core.ajax.receivePacket(response);
