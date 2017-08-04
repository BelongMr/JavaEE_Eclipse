<%@ page contentType= "text/html;charset=gb2312" %>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UType"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UtypeUtil"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UElement"%>

<%
System.out.println("-----------------------------------ajax_productOfferQryByAttr_m.jsp------------------------");
  String login_no =(String) session.getAttribute("workNo");//工号
  String flag = "N";//是否省级工号
  String offerCode = WtcUtil.repNull(request.getParameter("offerCode"));//销售品编码
  String offerName = WtcUtil.repNull(request.getParameter("offerName"));//销售品名称
  String offerType = WtcUtil.repNull(request.getParameter("offerType"));//销售品类型
  String offerAttrSeq = WtcUtil.repNull(request.getParameter("offerAttrSeq"));//销售品属性标识
  String custGroupId = WtcUtil.repNull(request.getParameter("custGroupId"));//客户群标识
  String channelSegment = WtcUtil.repNull(request.getParameter("channelSegment"));//渠道类型标识
  String group_id =WtcUtil.repNull(request.getParameter("group_id"));//区域标识
  String band_id =WtcUtil.repNull(request.getParameter("band_id"));//品牌标识
  String offer_att_type =WtcUtil.repNull(request.getParameter("offer_att_type"));//销售品分类标识
  String strArray="var retResult; ";  //must
  String regionCode = (String)session.getAttribute("regCode");
  
  String goodFlag = WtcUtil.repNull(request.getParameter("goodFlag"));
  String goodNotype = WtcUtil.repNull(request.getParameter("goodNotype"));
  	/* ningtn 铁通宽带，修改opcode写死问题*/
	String opCode = WtcUtil.repNull(request.getParameter("opCode"));//opCode
  
  String retCodeu = "";
	String retMsgu = ""; 
	String location = "";
	int retValNum = 0;
		System.out.println("--------------------offerCode------------------------"+offerCode);
	System.out.println("--------------------goodNotype----------------------"+goodNotype);
	
  if(goodFlag.equals("1")){
  
  	String qryBandAttrSql = "select band_id,offer_attr_type from product_offer where offer_id = '"+offerCode+"'";
		System.out.println("---------#---------qryBandAttrSql------#----"+qryBandAttrSql);
		

%>
 		<wtc:pubselect name="sPubSelect" outnum="2" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=qryBandAttrSql%></wtc:sql>
 	  </wtc:pubselect>
	 <wtc:array id="result_t" scope="end"/>
<%
	if(result_t.length>0&&code.equals("000000")){
		band_id = result_t[0][0];
		offer_att_type = result_t[0][1];
	}

System.out.println("-----------------login_no------------------------"+login_no);
System.out.println("-----------------flag----------------------------"+flag);
System.out.println("-----------------offerCode-----------------------"+offerCode);
System.out.println("-----------------offerName-----------------------"+offerName);
System.out.println("-----------------offerType-----------------------"+offerType);
System.out.println("-----------------offerAttrSeq--------------------"+offerAttrSeq);
System.out.println("-----------------custGroupId---------------------"+custGroupId);
System.out.println("-----------------channelSegment------------------"+channelSegment);
System.out.println("-----------------group_id------------------------"+group_id);
System.out.println("-----------------band_id-------------------------"+band_id);
System.out.println("-----------------offer_att_type------------------"+offer_att_type);


 %>
<wtc:utype name="sGOfferByAtr" id="retVal2" scope="end">
	<wtc:uparams name="TOfferMsg" iMaxOccurs="1">
			<wtc:uparam value="<%=login_no%>" type="STRING"/>  
			<wtc:uparam value="<%=flag%>" type="STRING"/>  
			<wtc:uparam value="<%=offerCode%>" type="STRING"/>
			<wtc:uparam value="<%=offerName%>" type="STRING"/>  
			<wtc:uparam value="<%=offerType%>" type="LONG"/> 
			<wtc:uparam value="<%=offerAttrSeq%>" type="LONG"/> 
			<wtc:uparam value="<%=custGroupId%>" type="LONG"/> 
			<wtc:uparam value="<%=channelSegment%>" type="STRING"/> 
			<wtc:uparam value="<%=group_id%>" type="LONG"/> 
			<wtc:uparam value="<%=band_id%>" type="LONG"/> 
			<wtc:uparam value="<%=offer_att_type%>" type="STRING"/> 
			<wtc:uparam value="" type="STRING"/>
			<wtc:uparam value="<%=opCode%>" type="STRING"/>
			<wtc:uparam value="" type="STRING"/>    //yull add 20110617
	</wtc:uparams>
</wtc:utype>
<%

	   retCodeu = retVal2.getValue(0);
	   retMsgu = retVal2.getValue(1).replaceAll("\\n"," "); 
	 System.out.println("------------------------retCodeu--------------------"+retCodeu);
	 System.out.println("------------------------retMsgu---------------------"+retMsgu);
	  location = "";
	 if(retCodeu.equals("0"))
	{
  	 retValNum = retVal2.getUtype("2").getSize();
  	System.out.println("------------------------retValNum---------------------"+retValNum);
		strArray = WtcUtil.createArray("retResult",retValNum);	
		
		%>
		<%=strArray%>
		<%
		 for(int i=0;i<retValNum;i++)
		 {
			location = "2."+i;
			int n =0;
			for(int j=0;j<32;j++){
		  	if(j==0||j==2||j==3||j==16||j==17||j==20||j==31){
			    String temp = retVal2.getUtype(location).getValue(j);
					if(temp == null || temp.trim().equals(""))
					{
						temp = "";
					}
					//System.out.println("temp==="+temp);
					temp = temp.replaceAll("\r\n","</br>");  
					temp = temp.replaceAll("\r","</br>"); 
					temp = temp.replaceAll("\n","</br>"); 
					temp = temp.replaceAll("\"","&quot;"); 
					temp = temp.replaceAll("\'","&quot;"); 	
					%>
					retResult[<%=i%>][<%=n%>] = "<%=temp.trim()%>";
					<%
					n++;
			  }
			}
	%>			
	<%		
		}	
	}else{
		%>
		retResult=null;
		<%
		retMsgu="操作错误，请联系管理员";
		}


}else{
	System.out.println("-----------------1--------------1---------------1------------");
	%>
	
<wtc:utype name="sQGoodNoOffer" id="retVal1" scope="end">
	<wtc:uparams name="TOfferMsg" iMaxOccurs="1">
			<wtc:uparam value="<%=login_no%>" type="STRING"/>  
			<wtc:uparam value="<%=flag%>" type="STRING"/>  
			<wtc:uparam value="<%=offerCode%>" type="STRING"/>
			<wtc:uparam value="<%=offerName%>" type="STRING"/>  
			<wtc:uparam value="<%=offerType%>" type="LONG"/> 
			<wtc:uparam value="<%=offerAttrSeq%>" type="LONG"/> 
			<wtc:uparam value="<%=custGroupId%>" type="LONG"/> 
			<wtc:uparam value="<%=channelSegment%>" type="STRING"/> 
			<wtc:uparam value="<%=group_id%>" type="LONG"/> 
			<wtc:uparam value="<%=band_id%>" type="LONG"/> 
			<wtc:uparam value="<%=offer_att_type%>" type="STRING"/> 
			<wtc:uparam value="" type="STRING"/>
			<wtc:uparam value="<%=opCode%>" type="STRING"/>	
			<wtc:uparam value="<%=goodNotype%>" type="STRING"/>		
	</wtc:uparams>
</wtc:utype>
	<%
	   retCodeu = retVal1.getValue(0);
	   retMsgu = retVal1.getValue(1).replaceAll("\\n"," "); 
	 System.out.println("------------------------retCodeu--------------------"+retCodeu);
	 System.out.println("------------------------retMsgu---------------------"+retMsgu);
	  location = "";
	 if(retCodeu.equals("0"))
	{
  	 retValNum = retVal1.getUtype("2").getSize();
  	System.out.println("------------------------retValNum---------------------"+retValNum);
		strArray = WtcUtil.createArray("retResult",retValNum);	
		
		%>
		<%=strArray%>
		<%
		 for(int i=0;i<retValNum;i++)
		 {
			location = "2."+i;
			int n =0;
			for(int j=0;j<32;j++){
		  	if(j==0||j==2||j==3||j==16||j==17||j==20||j==31){
			    String temp = retVal1.getUtype(location).getValue(j);
					if(temp == null || temp.trim().equals(""))
					{
						temp = "";
					}
					//System.out.println("temp==="+temp);
					temp = temp.replaceAll("\r\n","</br>");  
					temp = temp.replaceAll("\r","</br>"); 
					temp = temp.replaceAll("\n","</br>"); 
					temp = temp.replaceAll("\"","&quot;"); 
					temp = temp.replaceAll("\'","&quot;"); 	
					%>
					retResult[<%=i%>][<%=n%>] = "<%=temp.trim()%>";
					<%
					n++;
			  }
			}
	%>			
	<%		
		}	
	}else{
		%>
		retResult=null;
		<%
		retMsgu="操作错误，请联系管理员";
		}

	}%>
 

var response = new AJAXPacket();
response.data.add("retCode","<%=retCodeu%>");
response.data.add("retMsg","<%=retMsgu%>");
response.data.add("retResult",retResult);
core.ajax.receivePacket(response);