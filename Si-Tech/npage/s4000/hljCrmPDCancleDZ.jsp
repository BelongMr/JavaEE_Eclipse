<%
/********************
 *开发商: si-tech
 *铁通发票
 *create by ningtn @ 20111026
 ********************/
%>
<%@ page contentType= "text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.sitech.boss.pub.util.*"%>
<%!
 public String oneTok(String str,int loc){
  
		   String temStr="";
		   temStr=str;
		   if(str.charAt(0)=='|')  temStr=str.substring(1,str.length());
		   
		   if(str.charAt((str.length())-1)=='|')  temStr=temStr.substring(0,(temStr.length()-1));
		    
		
			 int temLoc;
			 int temLen;
			 
		    for(int ii=0;ii<loc-1;ii++)
			{
		       temLen=temStr.length();
		       temLoc=temStr.indexOf("|");
		       temStr=temStr.substring(temLoc+1,temLen);
		 	}
			if(temStr.indexOf("|")==-1)
			  return temStr;
			else
		    return temStr.substring(0,temStr.indexOf("|"));
		    }
%>
<%
System.out.println("===================== ningtn hljCrmPDPrintPublic.jsp ====");
		String work_no_bill =(String)session.getAttribute("workNo");
		String org_code_bill =(String)session.getAttribute("orgCode");
		String regionCode_bill = org_code_bill.substring(0,2);
		String regionCode = org_code_bill.substring(0,2);
		//qucc---add
		String groupId = (String) session.getAttribute("groupId");//取营业厅用
		String loginAccept = request.getParameter("loginAccept");
		String op_code = request.getParameter("op_code");
		String retInfo=request.getParameter("retInfo");
		String dirtPage=request.getParameter("dirtPage");
		String infoStr="";
		infoStr=retInfo;
		String print_workNo = "";
		String print_accept = "";
		String print_opName = "";
		String printMessage = oneTok(retInfo,1);
	 
		if(printMessage.length()>0){
		    String resSplitMsg[] = printMessage.split("\\s{1,}")  ;
		    if(resSplitMsg.length==3){
		      print_workNo = resSplitMsg[0];
	        print_accept = resSplitMsg[1];
	        print_opName = resSplitMsg[2];
		    }else if(resSplitMsg.length==2){
	        print_workNo = resSplitMsg[0];
	        print_accept = resSplitMsg[1];
	        print_opName = "";
		    }else{
		      print_workNo = resSplitMsg[0];
	        print_accept = "";
	        print_opName = "";
		    }
		}else{
	%>
		  <SCRIPT type=text/javascript>
	      
	      location="<%=dirtPage%>";
		  </SCRIPT>
	<%
		}

		String id_no =oneTok(infoStr,7);
	
//获取发票号  发票预站
%>
		<wtc:service name="bs_sEInvCancel" routerKey="region" routerValue="<%=regionCode_bill%>" retcode="retCode2" retmsg="retMsg2" outnum="6" >
					<wtc:param value="<%=loginAccept%>"/>
					<wtc:param value="01"/>
					<wtc:param value="<%=op_code%>"/>
					<wtc:param value="<%=print_workNo%>"/>
					<wtc:param value=""/>
					<wtc:param value="<%=oneTok(infoStr,7) %>"/> <!--手机号 -->
					<wtc:param value=""/><!--手机密码 -->
					<wtc:param value="<%=oneTok(infoStr,15) %>"/><!--操作备注 -->
					<wtc:param value=""/><!--操作时间 -->
					<wtc:param value="<%=id_no%>"/><!--用户ID -->
					<wtc:param value=""/><!--用户品牌代码-->	
					<wtc:param value="e"/><!--发票状态-->
					<wtc:param value=""/><!--发票代码-->
					<wtc:param value=""/><!--发票号码-->
					<wtc:param value="异地缴费"/><!--发票号码-->
					<wtc:param value=""/><!--项目单位-->
					<wtc:param value=""/><!--规格型号-->
					<wtc:param value="1"/><!--项目数量-->
					<wtc:param value="0"/><!--含税标识-->
					<wtc:param value="<%=oneTok(infoStr,11)%>"/><!--项目单价-->
					<wtc:param value="0"/><!--税率-->
					<wtc:param value="0"/><!--税额-->
					<wtc:param value="1"/><!--冲红标识-->
					<wtc:param value=""/><!--原始业务流水-->
					<wtc:param value=""/><!--原始业务年月-->
					<wtc:param value=""/><!--账户号码-->
					<wtc:param value="<%=oneTok(infoStr,11)%>"/><!--开票合计金额-->
					<wtc:param value="0"/><!--合计不含税金额-->
					<wtc:param value="0"/><!--合计税额-->
					<wtc:param value=""/><!--电子发票开具流水号-->
				</wtc:service>
				<wtc:array id="RetResult" scope="end"/>
<%
String[][] result2 = new String[][]{};
%>
<script type="text/javascript">

</script>
<%
	if(RetResult.length>0){
		result2 = RetResult;
		if((result2[0][0].equals("000000"))){
			%>
				
						<script language="JavaScript">
						   
						     document.location.replace("<%=dirtPage%>");
						</script>
				
	<%}else{
		%>
		<script>
			
			alert('电子发票取消开具错误！错误码:<%=result2[0][0]%>,错误信息:<%=result2[0][1]%>');
			if(parent.g_activateTab == undefined){
				var l_activateTab = "";
				var lis = parent.document.getElementById('tabtag').getElementsByTagName('li');
				for(var i=0; i<lis.length; i++){
					if(lis[i].className == "current"){
						l_activateTab = lis[i].id;
						break;		        
					} 
				}
				parent.removeTab(l_activateTab);
		     }else{
				parent.removeTab(parent.g_activateTab); 
		     }
		</script>
<%
		}
	}
%>
	

