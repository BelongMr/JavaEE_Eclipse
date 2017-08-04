<%
  /* *********************
   * 撤单
   * 版本: 1.0
   * 日期: 2013/03/11
   * 版权: si-tech
   * *********************/
%>
<%@ page contentType= "text/html;charset=gbk"%>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%
		String inLoginNo = (String)session.getAttribute("workNo");
		String regionCode= (String)session.getAttribute("regCode");
		String password = (String)session.getAttribute("password");
		
		String accept = WtcUtil.repNull(request.getParameter("accept"));
		String phoneNo = WtcUtil.repNull(request.getParameter("phoneNo"));
		String opCode = (String)request.getParameter("opCode");
		
		String sIpAddress = request.getRemoteAddr();
		String  groupId = (String)session.getAttribute("groupId");
		String sOpTime=new java.text.SimpleDateFormat("yyyyMMdd HH:mm:ss").format(new java.util.Date());//"20080912 09:59:01";
		String orgCode = (String)session.getAttribute("orgCode");
		String sRegionCode = regionCode.substring(0,2);
		String sMark="["+inLoginNo+"]对[" + phoneNo + "]做[撤单]";
		String BureauId = regionCode.substring(0,2);

		String errorCode = "";
		String errorMsg = "";
		
		String sername = "sCustOrderDraw";
		
		String iOpNote = (String)request.getParameter("iOpNote");
		String iGroupId = (String)request.getParameter("iGroupId");
		String iCardNo = (String)request.getParameter("iCardNo");
		String iSIMNo = (String)request.getParameter("iSIMNo");
		
		String iDispatchType = (String)request.getParameter("iDispatchType");
		String iStreamNo = (String)request.getParameter("iStreamNo");
		String iCompanyName = (String)request.getParameter("iCompanyName");
		
		String isDispatch = (String)request.getParameter("isDispatch");
		String iDescInfo = (String)request.getParameter("iDescInfo");
		String iFlag = (String)request.getParameter("iFlag");
		String iMailAddress = (String)request.getParameter("iMailAddress");
		
		/**
		 *@ 输入参数：
		 *select * from dservordermsg where service_no like '209%'
			-[0]---------utype:
			-[0][0]--------long:110303419935
			-[0][1]--------string:q046
			-[0][2]--------string:aaaaxp
			-[0][3]--------string:EIGBDHBHPHHPMJCE
			-[0][4]--------string:10.109.221.11
			-[0][5]--------string:10031
			-[0][6]--------string:20130320 15:00:30
			-[0][7]--------string:01
			-[0][8]--------string:[aaaaxp]对[C0112090500000012]做[一次性费用缴费]
			-[0][9]--------string:01
			-[0][10]--------string:10031
			-[1]---------utype:
			-[1][0]--------string:3
			-[1][1]--------long:3
			-[1][2]--------string:aaaaxp
			-[1][3]--------string:在缴费处统一撤单
			-[1][4]--------long:3
			-[1][5]--------string:20130320 15:00:30
			-[1][6]--------long:2
			-[1][7]--------long:110303419935
			-[1][8]--------long:3
			-[1][9]--------string:
			-[1][10]--------string:
			-[1][11]--------string:
			-[1][12]--------long:110303419935
			-[1][13]--------utype:
			-[1][13][0]-------utype:
			-[1][13][0][0]------string:A0112090500000012
			
			select b.order_array_id from dservordermsg a ,dorderarraymsg b where  b.order_array_id = a.order_array_id and a.service_no='15045869789';
			
			RCustOrderOPChange.log
			sCustOrderDraw
		 
			System.out.println("zhouby opCode " + opCode);
		*/
		
		UType sendInfo  = new UType();
		sendInfo.setUe("LONG",   accept);//流水
		sendInfo.setUe("STRING", "g608");
		sendInfo.setUe("STRING", inLoginNo);//工号
		sendInfo.setUe("STRING", password);//密码
		
		sendInfo.setUe("STRING", sIpAddress);//ip
		sendInfo.setUe("STRING", groupId);//groupid
		sendInfo.setUe("STRING", sOpTime);//操作时间
		sendInfo.setUe("STRING", sRegionCode);//regioncode
		sendInfo.setUe("STRING", sMark);	//[aaaaxp]做[撤单]
		sendInfo.setUe("STRING", BureauId);// regioncode
		sendInfo.setUe("STRING", groupId);	//	(String)session.getAttribute("groupId");
		
		UType orderMsg  = new UType();  
		orderMsg.setUe("STRING", "3");//3是撤单
		orderMsg.setUe("LONG", "3");//1 #lChangeType 变更类型   select * from sOrderArrayChangeType t
		orderMsg.setUe("STRING", inLoginNo);//工号，变更人
		orderMsg.setUe("STRING", "撤单");//变更内容撤单
		orderMsg.setUe("LONG", "3");//变更原因标示（我应该有一个新的）
		orderMsg.setUe("STRING", sOpTime);//当前时间串
		orderMsg.setUe("LONG", "2");// 变更审批结果ID      (不知道是什么)       
		orderMsg.setUe("LONG", accept);//流水
		orderMsg.setUe("LONG", "3");//审核规则标识    
		orderMsg.setUe("STRING", ""); //变更审核人 9
		orderMsg.setUe("STRING", "");//变更审核时间 10
		orderMsg.setUe("STRING", "");//变更审核意见 11
		orderMsg.setUe("LONG", accept);//流水12
		
		UType uCustOrderId  = new UType();
		
		String sql = "select b.order_array_id from dservordermsg a ,dorderarraymsg b where  b.order_array_id = a.order_array_id and a.service_no='" + phoneNo + "'";
%>
		<wtc:pubselect name="sPubSelect" retcode="retCode" retmsg="retMsg" outnum="1">
			<wtc:sql><%=sql%></wtc:sql>
		</wtc:pubselect>
		<wtc:array id="order_array" scope="end" />
			
		var array = [];
<%
		UType uuCustOrderId  = new UType();
		
		if (order_array.length > 0){
				UType us[] = new UType[];
				
				for(int i = 0; i < result.length; i++){
						us[i] = new UType();
						us[i].setUe("STRING", order_array[i]);
						//System.out.println("zhouby---------order_array["+i+"]-------------" + order_array[i]);
						uuCustOrderId.setUe(us[i]);
				}
		}
		
		orderMsg.setUe(uuCustOrderId);
%>
		<wtc:utype name="sername" id="retVal" scope="end" >
			 <wtc:uparam value="<%=sendInfo %>" type="UTYPE"/> 
			 <wtc:uparam value="<%=orderMsg %>" type="UTYPE"/> 
		</wtc:utype>
<%
		if(retVal.getValue(0) != null && retVal.getValue(0).equals("0")){
				errorCode = "000000";
		} else {
				errorCode = retVal.getValue(1); 
		}
		errorMsg = retVal.getValue(1);
		if(errorMsg != null && errorMsg.length() > 35){
				errorMsg = errorMsg.substring(0,35);
		}
%>
		<wtc:service name="sg530Cfm" routerKey="region" 
			routerValue="<%=regionCode%>" retcode="retCode1" retmsg="retMsg1" outnum="10">
				<wtc:param value="<%=accept%>"/>
				<wtc:param value="01"/>
				<wtc:param value="<%=opCode%>"/>
				<wtc:param value="<%=inLoginNo%>"/>
				<wtc:param value="<%=password%>"/>
				<wtc:param value="<%=phoneNo%>"/>
				<wtc:param value=""/>
				
				<wtc:param value="<%=iOpNote%>"/>	
				<wtc:param value="<%=iGroupId%>"/>	
				<wtc:param value="<%=iCardNo%>"/>	
				<wtc:param value="<%=iSIMNo%>"/>	
				
				<wtc:param value="<%=iDispatchType%>"/>	
				<wtc:param value="<%=iStreamNo%>"/>	
				<wtc:param value="<%=iCompanyName%>"/>
				
				<wtc:param value="<%=isDispatch%>"/>	
				<wtc:param value="<%=iDescInfo%>"/>	
				<wtc:param value="<%=iFlag%>"/>
				<wtc:param value="<%=iMailAddress%>"/>
		</wtc:service>
<%
		errorCode = errorCode + retCode1;
		errorMsg = errorMsg + " , " + retMsg1;
%>
		var response = new AJAXPacket();
		response.data.add("errorCode", "<%=errorCode%>");
		response.data.add("errorMsg", "<%=errorMsg%>");
		core.ajax.receivePacket(response);