<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/se112/public_title_name.jsp"%>
<%@ include file="/npage/se112/footer.jsp"%>
<%@page import="com.sitech.crmpd.core.bean.MapBean"%>
<%@page import="java.util.*"%>
<%@page import="com.sitech.crmpd.core.util.SiUtil"%>
<%
	String login_no = (String)session.getAttribute("workNo");
	String password =(String)session.getAttribute("password");
	String xml = request.getParameter("ssfeeInfo");
	String meansId = request.getParameter("meansId");
	String orderId = request.getParameter("orderId");
	String reginCode = request.getParameter("reginCode");
	String phoneNo = request.getParameter("phoneNo");
	String brandId =request.getParameter("brandId");//品牌
	String mode_code =request.getParameter("mode_code");
	String PRI_FEE_CODE=request.getParameter("PRI_FEE_CODE");
	String PRI_FEE_NAME=request.getParameter("PRI_FEE_NAME");
	String group_id = (String)session.getAttribute("groupId");
	System.out.println("clientInfo=xml===AAAAAAAAAAAAAAAAAAAAAA====" + xml);
	String showFlag = "style=\"display:block\"";
	String id_no= request.getParameter("id_no");//用户ID
	String powerRight=request.getParameter("powerRight");//用户权限
	String belong_code=request.getParameter("belong_code");//用户归属
	String act_type=request.getParameter("act_type");//活动小类
	String startTime=request.getParameter("startTime");//开始时间
	String H15   = (String)request.getParameter("H15");//活动小类
	String netFlag   = (String)request.getParameter("netFlag");//活动小类
	System.out.println("brandId================"+brandId);
	System.out.println("mode_code================"+mode_code);
	System.out.println("id_no================"+id_no);
	System.out.println("powerRight================"+powerRight);
	System.out.println("belong_code================"+belong_code);
	System.out.println("PRI_FEE_CODE================"+PRI_FEE_CODE);
	System.out.println("PRI_FEE_NAME================"+PRI_FEE_NAME);
	System.out.println("act_type================"+act_type);
	System.out.println("startTime================"+startTime);
	System.out.println("=++=======H15=====" + H15);
	System.out.println("=++=======netFlag=====" + netFlag);
	String  zzfmc = "";
    String tbselect="";
	//boolean isCtrlMoney = false;//是否存在可修改节点
	//boolean isCtrlMonth = false;//是否存在可修改节点
	//boolean isCtrlRate = false;//是否存在可修改节点
	//boolean isCtrl = false;//是否存在可修改节点
 	MapBean mb = new MapBean();
	
	String code = "000000";
	String message = "";
	
	
 %>	
 <%@ include file="getMapBean.jsp"%>
 <%	
	List feeList = null;
	Iterator it =null;
	String priFeeValid ="";
	if(null!= mb){
		feeList = mb.getList("OUT_DATA.H10.PRI_FEE_LIST.PRI_FEE_INFO");
		System.out.println("_________feeList________" + feeList.toString());
		if(null!=feeList){
			it =feeList.iterator();
			while(it.hasNext()){
			  Map stMap = mb.isMap(it.next());
			  if(null==stMap)continue;
			  String priFeeValidN = (String)stMap.get("PRI_FEE_VALID");
			  if(null != priFeeValidN){
			  	priFeeValid = priFeeValidN;
			  }
			}
			System.out.println("_________priFeeValid________" + priFeeValid);
		}
			
	}
	
 %>
<html>
	<head>
	<title></title>
	</head>
	<body>
		<div id="operation">
		<form method="post" name="frm1147" action="">
			<input type="hidden" name="kx_want"><!--打印－所有申请操作--->
			<input type="hidden" name="kx_cancle"><!--打印－所有取消操作--->
			<input type="hidden" name="kx_running"><!--打印－所有开通的套餐--->
			<input type="hidden" name="kx_code_bunch">
			<!--可选资费代码串-->
 			<input type="hidden" name="kx_habitus_bunch">
 			<!--可选资费状态串-->
 			<input type="hidden" name="kx_operation_bunch">
 			<!--可选套餐的生效方式串-->
 			<input type="hidden" name="kx_explan_bunch">
 			<!--可选套餐说明-->
 			<input type="hidden" name="kx_code_name_bunch">
 			<!--可选套餐名称-->
 			<input type="hidden" name="kx_erpi_bunch">
 			<input type="hidden" name="kx_stream_bunch"><!--原可选套餐的开通流水串-->
				<div id="operation_table">
					 <div class="title">
						<div class="text">
							资费详细信息
						</div>
					</div>
					<div class="input">
					<table>
							<tr>
								<th>
									小区代码
								</th>	
								<s:service name="smktProdQry">
									<s:param name="ROOT">
									 		<s:param name="GROUP_ID " type="string" value="<%=group_id %>" />
											<s:param name="OFFER_NAME" type="string" value="" />
											<s:param name="OP_TYPE" type="string" value="e177" />
											<s:param name="PRI_CODE" type="string" value="<%=PRI_FEE_CODE %>" />
									</s:param>
								</s:service>
								<%						
									Map a = new HashMap();
									List gifelist = result.getList("OUT_DATA.FEE_LIST.FEE_INFO");
									String DETAILMSG = (String)result.getString("DETAIL_MSG");	
								%>
								<td style="width:350px">
								<select id="feedistinc" style="width:350px">
								<%
									if("".equals(DETAILMSG)){
								%>	
									<option value="">----------—-----------请选择---------------------</option>
								<%	
									}
								    for(int i =0;i<gifelist.size();i++){
										a = MapBean.isMap(gifelist.get(i));
										if(a==null) continue;
										String FEE_CODE = (String)a.get("FEE_CODE");
										String FEE_NAME = (String)a.get("FEE_NAME");
								%>
									<option value="<%=FEE_CODE %>"><%=FEE_NAME%></option>
							    <%}%>
								</select>
							</td>					
							</tr>
		      				<tr <%=showFlag%>>
								 <td class="blue" width="15%">可选套餐类别</td>
								 <td colspan="3">
								<s:service name="sMKTAddQry">
									<s:param name="ROOT">
									 		<s:param name="FRI_FEE" type="string" value="<%=PRI_FEE_CODE %>" />
											<s:param name="BRAND_ID" type="string" value="<%=brandId %>" />
											<s:param name="OP_CODE" type="string" value="e177" />
									</s:param>
								</s:service>
							    <%
							    	Map b = new HashMap();
									List felist = result.getList("OUT_DATA.BUSI_INFO");
									for(int i =0;i<felist.size();i++){
										b = MapBean.isMap(felist.get(i));
										if(b==null) continue;
										String TypeValue= (String)b.get("TypeValue");
										String TypeName= (String)b.get("TypeName");
										String fMinOpen= (String)b.get("MinOpen");
										String fMaxOpen= (String)b.get("MaxOpen");
										String SetMenuType= (String)b.get("SetMenuType");
										
									    out.println("<a Href='javascript:openwindow("+'"'+
									          +i+'"'+","+'"'+SetMenuType+'"'+","+'"'+TypeName+'"'+")'>"+TypeValue+" "+TypeName+"</a>");
									    out.println("<input type=hidden name=oActualOpen value='0'>");    //实际开通的数
										out.println("<input type=hidden name=oDefaultFlag value='N'>");   //是否有默认申请的配置
										out.println("<input type=hidden name=oDefaultOpen value='N'>");   //是否默认申请是否存在一个申请
										out.println("<input type=hidden name=oTypeValue value="+TypeValue+">");
										out.println("<input type=hidden name=oTypeName value="+TypeName+">");
										out.println("<input type=hidden name=oMinOpen value="+fMinOpen.trim()+">");
										out.println("<input type=hidden name=oMaxOpen value="+fMaxOpen.trim()+">");
							        }
							           System.out.println("---------------------------------------------------");
                                  %>
						     	</td>				
							</tr>
						</table>
				</div>
				   <s:service name="s1270Must">
						<s:param name="ROOT">
						 		<s:param name="LoginAccept" type="string" value="" />
						 		<s:param name="ChnSource" type="string" value="01" />
						 		<s:param name="OpCode" type="string" value="g794" />
						 		<s:param name="LoginNo" type="string" value="<%=login_no %>" />
						 		<s:param name="LoginPwd" type="string" value="<%=password %>" />
						 		<s:param name="PhoneNo" type="string" value="" />
						 		<s:param name="UserPwd" type="string" value="" />
						 		<s:param name="LoginRight" type="string" value="<%=powerRight %>" />
						 		<s:param name="IdNo" type="string" value="<%=id_no %>" />
						 		<s:param name="OldMode" type="string" value="<%=mode_code %>" />
						 		<s:param name="NewMode" type="string" value="<%=PRI_FEE_CODE %>" />
						 		<s:param name="BelongCode" type="string" value="<%=belong_code %>" />
						</s:param>
					</s:service>
					<div id="Operation_Table">
								<div class="title">
									<div id="title_zi">套餐信息</div>
								</div>
							   <table id=tr cellSpacing="0" style="display:block">
					          <tr align="center">
						     		 <th <%=showFlag%> nowrap>选择</th>
										 <th nowrap>可选套餐名称</th>
										 <th nowrap>状态</th>
										 <th nowrap>开始时间</th>
										 <th nowrap>结束时间</th>
										 <th nowrap>套餐类别</th>
										 <th nowrap>生效方式</th>
					                     <th nowrap>可选方式</th>
					                     <th nowrap>小区代码选择</th>
							  </tr>
								  <tr id="tr0" style="display:none">
								     <td><div align="center"><input type="checkbox" name="checkId" id="checkId"></div></td>
								     <td><div align="center"><input type="text" name="R0" value=""></div></td>
					           		 <td><div align="center"><input type="text" name="R1" value=""></div></td>
								     <td><div align="center"><input type="text" name="R2" value=""></div></td>
								     <td><div align="center"><input type="text" name="R3" value=""></div></td>
								     <td><div align="center"><input type="text" name="R4" value=""></div></td>
								     <td><div align="center"><input type="text" name="R5" value=""></div></td>
								     <td><div align="center"><input type="text" name="R12" value=""></div></td>
								     <td>
										<div align="center">
											<input type="text" name="R6" value="">
											<input type="text" name="R7" value="">
											<input type="text" name="R8" value="">
											<input type="text" name="R9" value="">
											<input type="text" name="R10" value="">
											<input type="text" name="R11" value="">
											<!-- <input type="text" name="R13" value=""> -->
											<input type="text" name="R14" value="">
										</div>
									 </td>
								 </tr>
         <%
           Map d = new HashMap();
       		 List dange = result.getList("OUT_DATA");
			for(int i =0;i<dange.size();i++){
			d = MapBean.isMap(dange.get(i));
				if(b==null) continue;         
            zzfmc = (String)d.get("NewModeName");
    		tbselect = (String)d.get("temp_buf"); //生效时间,用于工单打印
    	}
        Map c = new HashMap();
		List kexuan = result.getList("OUT_DATA.BUSI_INFO");
		String returnCode = result.getString("RETURN_CODE");
		String returnMsg = result.getString("RETURN_MSG");
		
		if(!"000000".equals(returnCode)||"N/A".equals(returnCode)){
			code = returnCode;
			message = retMsg;
		}else{
			
			String[][] data= new String[kexuan.size()][14];
//			  data = result_must_2;
//String test[][] = result_must_2;

System.out.println("+++++++++++++++++++++++++kexuan.size()++++++++++++++++++"+kexuan.size());
		for(int i =0;i<kexuan.size();i++){
			c = MapBean.isMap(kexuan.get(i));
			if(c==null) {
				data[i][0]="";
				data[i][1]="";
				data[i][2]="";
				data[i][3]="";
				data[i][4]="";
				data[i][5]="";
				data[i][6]="";
				data[i][7]="";
				data[i][8]="";
				data[i][9]="";
				data[i][10]="";
				data[i][11]="";
				data[i][12]="";
				data[i][13]="";
				continue;}
				String ModeName= (String)c.get("ModeName")== null?"":(String)c.get("ModeName");
				String ModeStatus= (String)c.get("ModeStatus")== null?"":(String)c.get("ModeStatus");
				String begin_time= (String)c.get("begin_time")== null?"":(String)c.get("begin_time");
				String end_time= (String)c.get("end_time")== null?"":(String)c.get("end_time");
				String ModeTypeName= (String)c.get("ModeTypeName")== null?"":(String)c.get("ModeTypeName");
				String SendFlagName= (String)c.get("SendFlagName")== null?"":(String)c.get("SendFlagName");
				String ModeChoicedName= (String)c.get("ModeChoicedName")== null?"":(String)c.get("ModeChoicedName");
				String mode_coded= (String)c.get("mode_code")== null?"":(String)c.get("mode_code");
				String ModeType= (String)c.get("ModeType")== null?"":(String)c.get("ModeType");
				String SendFlag= (String)c.get("SendFlag")== null?"":(String)c.get("SendFlag");
				String login_accept= (String)c.get("login_accept")== null?"":(String)c.get("login_accept");
				String ModeChoiced= (String)c.get("ModeChoiced")== null?"":(String)c.get("ModeChoiced");
				String XQFlag= (String)c.get("XQFlag")== null?"":(String)c.get("XQFlag");
				String XQInfo= (String)c.get("XQInfo")== null?"":(String)c.get("XQInfo");
				System.out.println("+++++++++++++++++++++++++ModeName++++++++++++++++++"+ModeName);
				System.out.println("+++++++++++++++++++++++++ModeStatus++++++++++++++++++"+ModeStatus);
				System.out.println("+++++++++++++++++++++++++begin_time++++++++++++++++++"+begin_time);
				System.out.println("+++++++++++++++++++++++++end_time++++++++++++++++++"+end_time);
				System.out.println("+++++++++++++++++++++++++ModeTypeName++++++++++++++++++"+ModeTypeName);
				System.out.println("+++++++++++++++++++++++++SendFlagName++++++++++++++++++"+SendFlagName);
				System.out.println("+++++++++++++++++++++++++ModeChoicedName++++++++++++++++++"+ModeChoicedName);
				System.out.println("+++++++++++++++++++++++++mode_coded++++++++++++"+mode_coded);
				System.out.println("+++++++++++++++++++++++++ModeType++++++++++++++++++"+ModeType);
				System.out.println("+++++++++++++++++++++++++SendFlag++++++++++++++++++"+SendFlag);
				System.out.println("+++++++++++++++++++++++++login_accept++++++++++++++++++"+login_accept);
				System.out.println("+++++++++++++++++++++++++ModeChoiced++++++++++++++++++"+ModeChoiced);
				System.out.println("+++++++++++++++++++++++++XQFlag++++++++++++++++++"+XQFlag);		
				System.out.println("+++++++++++++++++++++++++XQInfo++++++++++++++++++"+XQInfo);			
				data[i][0]=ModeName;
				data[i][1]=ModeStatus;
				data[i][2]=begin_time;
				data[i][3]=end_time;
				data[i][4]=ModeTypeName;
				data[i][5]=SendFlagName;
				data[i][6]=ModeChoicedName;
				data[i][7]=mode_coded;
				data[i][8]=ModeType;
				data[i][9]=SendFlag;
				data[i][10]=login_accept;
				data[i][11]=ModeChoiced;
				data[i][12]=XQFlag;
				data[i][13]=XQInfo;
		}
		System.out.println("++++++++++++++++++++****************+++++++++++++++++++++++");	
			  for(int y=0;y<data.length;y++)
			  {
			    String addstr = data[y][0] +"#" +data[y][1]+"#"+y;
 %>
		  <tr id="tr<%=y+1%>" align="center">
<%
	if(data[y][data[0].length-3].equals("0") || data[y][data[0].length-3].equals("1")||data[y][data[0].length-3].equals("4")){//默认申请
	
	 System.out.println("+++++++++++++++++++++++++++++++54565656565656++++++++++++++++++"+data[0].length);
%>
				<td <%=showFlag%>><input type="checkbox" name="checkId" checked></td>
	 <%
	 		}

	 		if(data[y][data[0].length-3].equals("2")){//绑定申请
	 %>
				<td <%=showFlag%>>
					<input type="checkbox" name="checkId" disabled checked onclick="if(document.all.checkId[<%=y%>+1].checked==false){ document.all.checkId[<%=y%>+1].checked=true;} showDialog('绑定申请！',1);return false;">
				</td>
	 <%
	 		}

	 		if(data[y][data[0].length-3].equals("a")){//默认申请下因生效时间与历史时间冲突而不可申请
	 %>
				<td <%=showFlag%>>
					<input type="checkbox" name="checkId" onclick="if(document.all.checkId[<%=y%>+1].checked==true){document.all.checkId[<%=y%>+1].checked=false;} showDialog('默认申请下因生效时间与历史时间冲突而不可申请！',1);return false;">
				</td>
	 <%
	 		}

	 		if(data[y][data[0].length-3].equals("b")){//强制申请下因生效时间与历史时间冲突而不可申请
	 %>
				<td <%=showFlag%>>
					<input type="checkbox" name="checkId" onclick="if(document.all.checkId[<%=y%>+1].checked==true){document.all.checkId[<%=y%>+1].checked=false;} showDialog('强制申请下因生效时间与历史时间冲突而不可申请！',1);return false;">
				</td>
	 <%
	 		}

	 		if(data[y][data[0].length-3].equals("d")){//强制取消
	 %>
				<td <%=showFlag%>>
					<input type="checkbox" name="checkId"disabled onclick="if(document.all.checkId[<%=y%>+1].checked==true ){document.all.checkId[<%=y%>+1].checked=false;} showDialog('强制取消不能申请！',1);return false;">
				</td>
	 <%
	 		}

	 		if(data[y][data[0].length-3].equals("9")){//不可取消
	 %>
				<td <%=showFlag%>>
					<input type="checkbox" name="checkId" checked onclick="if(document.all.checkId[<%=y%>+1].checked==false){document.all.checkId[<%=y%>+1].checked=true;} showDialog('特殊可选资费，请到单独业务界面办理！',1);return false;">
				</td>
	 <%
	 		}

			for(int j=0;j<data[0].length+1;j++){
				 String tbstr="";
				 if(j==0)
					{
						tbstr = "<td><a Href='javascript:openhref("+'"'+data[y][7].trim()+'"'+")'>" +
						data[y][j].trim() + "</a><input type='hidden' " +
						" id='R" + j  + "' name='R" + j + "' class='button' value='" +
						(data[y][j]).trim() + "'readonly></td>";
					}
				 else if(j==1)
					{
						String habitus = "";
						if(data[y][j].trim().equals("Y"))habitus="已开通";
						if(data[y][j].trim().equals("N"))habitus="未开通";
						 tbstr = "<td>" + habitus + "<input type='hidden' " +
						" id='R" + j  + "' name='R" + j + "' class='button' value='" +
						(data[y][j]).trim() + "'readonly></td>";
					}
				 else if(j>6&&j<12)
					{
						 tbstr = "<input type='hidden' " +
						" id='R" + j  + "' name='R" + j + "' class='button' value='" +
						(data[y][j]).trim() + "'readonly>";
					}
				 else if(j==12)//可选资费下小区资费标识
					{
					    String flag = "";
						if(data[y][j].trim().equals("Y")){
							/* flag="存在小区资费，请点此选择";
							tbstr = "<td><a Href='javascript:openDistrihref("+'"'+data[y][13].trim()+'"'+")'>" +
									flag + "</a><input type='hidden' " +
									" id='R" + j  + "' name='R" + j + "' class='button' value='" +
									data[y][j].trim() + "'readonly></td>"; */
							String[] infoArr = data[y][j+1].trim().split(",");
							tbstr ="<td><select id='R13_"+(y+1)+"' name='R13_"+(y+1)+"'>";
							
							for(int t=0;t<infoArr.length;t++){
								String[] info = infoArr[t].split("~");
								System.out.println("+++++++++++info[0]="+info[0]);
								System.out.println("+++++++++++++info[1]="+info[1]);
								tbstr = tbstr +"<option value='"+infoArr[t]+"' >"+infoArr[t]+"</option>";
							}
							
							tbstr =tbstr +"</select></td>";		
						   			
						}else{
							flag="无";
							tbstr = "<td><a >"+flag+"</a><input type='hidden' " +
									" id='R13_" + (y+1)  + "' name='R13_" + (y+1) + "' class='button' value='" +
									data[y][j].trim()  + "'readonly></td>";
						}
					    
					}
				 else if(j==13)//可选资费下小区资费列表
				   {
					 continue;
				   }
				 else if(j==14)
				   {
						tbstr = "<input type='hidden' " +
						" id='R" + j  + "' name='R" + j + "' class='button' value=' '>";
				   }
				  else
					{
						 tbstr = "<td>" + data[y][j].trim() + "<input type='hidden' " +
						" id='R" + j  + "' name='R" + j + "' class='button' value='" +
						(data[y][j]).trim() + "'readonly></td>";
					}
						out.println(tbstr);
			   }
	 %>
		  </tr>
 <%
			}
			
		}
%>	
		

	       </table>
		</div>
					<div id="operation_button">
						<input type="button" class="b_foot" value="确定" id="btnSubmit"
							name="btnSubmit" onclick="btnRsSubmit()" />
						<input type="button" class="b_foot" value="关闭" id="btnCancel"
							name="btnCancel" onclick="closeWin()" />
					</div>

			</form>
		</div>
	</body>
	<script type="text/javascript">
   var oActualOpenObj = document.getElementsByName("oActualOpen"); //用于判断
   var oDefaultFlagObj = document.getElementsByName("oDefaultFlag"); //用于判断
   var oDefaultOpenObj = document.getElementsByName("oDefaultOpen"); //用于判断
   var oTypeValueObj = document.getElementsByName("oTypeValue"); //用于判断
   var oTypeNameObj = document.getElementsByName("oTypeName"); //用于判断
   var oMinOpenObj = document.getElementsByName("oMinOpen"); //用于判断
   var oMaxOpenObj = document.getElementsByName("oMaxOpen"); //用于判断	
   var dynTbIndex=0;
   var token = "|";	
   function closeWin(){
		closeDivWin();
   }
	
   var kx_code_bunch = "";                                     //可选资费代码串
   var kx_name_bunch = "";                                     //可选资费名称串
   var kx_code_name_bunch = "";                                 //可选资费名称串
   var kx_habitus_bunch ="";                                   //可选自费状态串
   var kx_erpi_bunch="";										//可选套餐二批
   var kx_operation_bunch="";                                  //可选套餐的生效方式串
   var kx_stream_bunch="";                                     //可选套餐原开通流水串
   var kx_explan_bunch="";									//可选套餐描述
   var kx_begin_time="";									//可选套餐开始时间
   var tempnm="";												 //临时操作变量
   var kx_want="";											 //打印－申请操作
   var kx_cancle="";											 //打印－取消操作
   var kx_running="";											 //打印－所有开通操作
   var kx_want_chgrow="0";								     //打印－申请操作,换行标志
   var kx_cancle_chgrow= "0";									 //打印－取消操作,换行标志
   var kx_running_chgrow="0";									 //打印－所有开通操作,换行标志
   var kx_distri_code = "";//可选套餐下小区资费代码
   var kx_distri_name = "";//可选太惨下小区资费名称
   var oNotice = "";
   var retflag = 0;
   kx_want =  "本次申请可选套餐：";
   kx_cancle = "本次取消可选套餐：";	
   var kx_cancle_str=""; //取消的可选套餐提示
   function btnRsSubmit(){
	   $("#btnSubmit").attr("disabled", "true");
	   if("<%=code%>"!="000000"){
		   showDialog("<%=message%>",0);
		   return;
	   }
	   
	for(var i=0;i<document.all.checkId.length;i++)
	{
		 		
		if(document.all.checkId[i].checked==true && document.all.R1[i].value=="N" ||//申请
			   document.all.checkId[i].checked==false && document.all.R1[i].value=="Y" )//取消
		{
			kx_code_bunch = kx_code_bunch + document.all.R7[i].value + "#"; //可选资费代码串
			kx_name_bunch = kx_name_bunch + document.all.R0[i].value + "#"; //可选资费名称串
			kx_habitus_bunch = kx_habitus_bunch + document.all.R1[i].value + "#";       //可选资费状态串
			kx_operation_bunch = kx_operation_bunch + document.all.R9[i].value + "#";   //可选套餐的生效方式串
			kx_stream_bunch = kx_stream_bunch + document.all.R10[i].value + "#";//可选套餐原开通流水串
			kx_begin_time = kx_begin_time + document.all.R2[i].value + "#";//可选套餐开始时间
			var kx_distri_info = $("#R13_"+i).val();
			if(kx_distri_info != "" && kx_distri_info != null &&  kx_distri_info != "N"){
				var kx_distri_arr = kx_distri_info.split("~");
				kx_distri_code = kx_distri_code + kx_distri_arr[0] + "#";//可选套餐小区信息
				kx_distri_name = kx_distri_name + kx_distri_arr[1] + "#";//可选套餐小区信息
			}else{
				kx_distri_code = kx_distri_code + "NNN#";//可选套餐小区信息
				kx_distri_name = kx_distri_name + "NNN#";//可选套餐小区信息
			}

			if(document.all.R14[i].value=="无描述信息"){
				kx_explan_bunch = kx_explan_bunch ;
			}else{
				kx_explan_bunch = kx_explan_bunch +" "+ document.all.R14[i].value ;
			}
			if(document.all.checkId[i].checked==true && document.all.R1[i].value=="N") //所有开通情况
			{
				kx_want = kx_want +  " (" + document.all.R7[i].value+"、"+ document.all.R0[i].value+"、"+document.all.R5[i].value +")" ;  //申请串
				kx_want_chgrow = 1*kx_want_chgrow+1;
			}
			if(document.all.checkId[i].checked==false && document.all.R1[i].value=="Y")//取消情况
			{
				kx_cancle = kx_cancle +  " (" + document.all.R7[i].value+"、"+ document.all.R0[i].value+"、"+document.all.R5[i].value +")" ;  //取消串
				kx_cancle_chgrow = 1*kx_cancle_chgrow+1;
			}			
		}
	}

	if(trim(kx_cancle)!="本次取消可选套餐："){
		alert(kx_cancle);
	}

	retflag = 0;
	var smPacket = new AJAXPacket("getS1270Notice.jsp","请稍候......");
        smPacket.data.add("iChnSource","01");
	smPacket.data.add("iLoginNo","<%=login_no%>");
	smPacket.data.add("iLoginPWD","<%=password%>");
	smPacket.data.add("iPhoneNo","<%=phoneNo%>");
	smPacket.data.add("iNewOfferId","<%=PRI_FEE_CODE%>");
	core.ajax.sendPacketHtml(smPacket,doProcess);
	smPacket = null;
	if(retflag == 1){
		return false;
	}


//=======================================查询生失效方式start========================================		
		if("<%=act_type%>" == "63"){
			var sPacket = new AJAXPacket("getMktQryEffect.jsp","请稍候......");
			sPacket.data.add("iChnSource","<%=reginCode%>");
			sPacket.data.add("iLoginNo","<%=login_no%>");
			sPacket.data.add("iLoginPWD","<%=password%>");
			sPacket.data.add("iPhoneNo","<%=phoneNo%>");
			sPacket.data.add("iOprAccept","<%=orderId%>");
			sPacket.data.add("iPhoneNoStr","<%=phoneNo%>");
			sPacket.data.add("iOfferIdStr","<%=PRI_FEE_CODE%>");
			core.ajax.sendPacket(sPacket,doserviceResCats);
			sPacket = null;
		}
//=======================================查询生失效方式end========================================
		 
//=====================================获取生失效时间开始=====================		
		if("<%=act_type%>" == "63" && oEffType == ""){

		}else{
			var sPacket = new AJAXPacket("getEffectTime.jsp","请稍候......");
			if("<%=act_type%>" == "19"&&"<%=netFlag%>" == "5"){
				sPacket.data.add("iLoginAccept","<%=startTime%>");
			}else{
				sPacket.data.add("iLoginAccept","");
			}
			sPacket.data.add("iChnSource","<%=reginCode%>");
			sPacket.data.add("iLoginNo","<%=login_no%>");
			sPacket.data.add("iLoginPWD","<%=password%>");
			sPacket.data.add("iPhoneNo","<%=phoneNo%>");
			sPacket.data.add("iOprAccept","<%=orderId%>");
			sPacket.data.add("iPhoneNoStr","<%=phoneNo%>");
			sPacket.data.add("iOfferIdStr","<%=PRI_FEE_CODE%>");
			sPacket.data.add("iOprTypeStr","1");
			if("<%=act_type%>" == "63" && oEffType != ""){
				sPacket.data.add("iDateTypeStr",oEffType);
			}else if("<%=act_type%>" == "19"&&"<%=netFlag%>" == "5"){
				sPacket.data.add("iDateTypeStr","0");
			}else if(("<%=act_type%>" == "16"&& <%=H15%> == '1')||("<%=act_type%>" == "19"&& "<%=netFlag%>" == "4")){
				sPacket.data.add("iDateTypeStr","2");
			}else{
				sPacket.data.add("iDateTypeStr","<%=priFeeValid%>");
			}
			sPacket.data.add("iOfferTypeStr","0");
			sPacket.data.add("iOffsetStr","x");
			sPacket.data.add("iUnitStr","x");
			sPacket.data.add("meansId","<%=meansId%>");
			core.ajax.sendPacket(sPacket,doserviceResCat);
			sPacket = null;
		}
//=====================================获取生失效时间结束=====================			
}

function doProcess(data){
	var sdata = data.split("~");
	var RETURN_CODE = trim(sdata[0]);
	var RETURN_MSG = sdata[1];
	alert("RETURN_CODE = "+RETURN_CODE+","+RETURN_MSG);
	if(RETURN_CODE != "000000"){
		showDialog(RETURN_MSG,0);
		reSetPriFeeVar();
		retflag = 1;
		return false;
	}
	var outType = sdata[2];
	if(outType =="1"){
		var outPrice = sdata[3];
		var outBusName = sdata[4];
		var outOldName = sdata[5];
		oNotice = "为保障您的权益，您原"+outOldName+"主资费包含的彩铃业务将为您免费保留一年，保留期间业务每月费用为"+outPrice+"元，系统每月赠送您"+outPrice+"元专款，相当于免费使用。该保留的彩铃业务随新主资费生效的日期开始起算，到期后如无变化此优惠将自动顺延一年，如有变化系统将提前1个月短信通知。";
		alert(oNotice);
	}
	
}

//==================================start===================================		
var oEffType = "";
function doserviceResCats(packet){
		var RETURN_CODE = packet.data.findValueByName("RETURN_CODE");
		var RETURN_MSG = packet.data.findValueByName("RETURN_MSG");

		if(RETURN_CODE != "000000"){
			showDialog(RETURN_MSG,0);
			reSetPriFeeVar();
			return false;
		}
		oEffType = packet.data.findValueByName("oEffType");
}
//===================================end==================================		

var kx_begintime = "";
var kx_endtime = "";
var effDateStr = "";
var expDateStr = "";

var gFeeCodeStr = "";
var gFeeDescStr = "";
var gFeeNoteStr = "";
var qryfee_code = "";
var qryfee_msg = "";

function doserviceResCat(packet){
		var RETURN_CODE = packet.data.findValueByName("RETURN_CODE");
		var RETURN_MSG = packet.data.findValueByName("RETURN_MSG");
//=====================================================================		
		effDateStr = packet.data.findValueByName("effDateStr");
		expDateStr = packet.data.findValueByName("expDateStr");
		
		//alert(effDateStr);
		//alert(expDateStr);
		
		if(RETURN_CODE != "000000"){
			showDialog(RETURN_MSG,0);
			reSetPriFeeVar();
			return false;
		}
		
		var priFee= "<%=PRI_FEE_NAME%>";
		var PRI_FEE_CODE="<%=PRI_FEE_CODE%>";
		var feedistinc=$("#feedistinc option:selected").text();
		var feed = $("#feedistinc").val();
		if(feed==null||feed==""){
			feedistinc="";
		}
		if(kx_habitus_bunch != ""){
		
			var kx_habitus_bunchs  = kx_habitus_bunch.substring(0,kx_habitus_bunch.length-1).split("#");
			var kx_begin_times  = kx_begin_time.substring(0,kx_begin_time.length-1).split("#");
			
			for(var i =0; i<kx_habitus_bunchs.length;i++){
				if(kx_habitus_bunchs[i] == "Y"){
					kx_begintime = kx_begintime + kx_begin_times[i] + "#";
					kx_endtime = kx_endtime + effDateStr + "#";
				}else{
					kx_begintime = kx_begintime + effDateStr + "#";
					kx_endtime = kx_endtime + expDateStr + "#";
				}
			}
			
			//alert("kx_begintime:"+kx_begintime);
			//alert("kx_endtime:"+kx_endtime);
			
		}
		
		
		
		/*
		   modify date:2016-03-28
                      将小类去掉，所有小类都掉用资费描述查询接口，展示资费描述及流量结转信息描述
           desc:免填单展示的资费信息，不包含资费流转信息描述
           showDesc：前台展示的所有资费信息，包含资费流转信息
		*/
		multiOffQry();
		var desc = "";
		var showDesc = "";
		
		if("<%=act_type%>" == "71"){
			
			
			//var desc = "";
			if(feed!=null&&feed!=""){
				desc = "套餐名称: "+trim(priFee)+"，小区资费："+feedistinc;
				showDesc = "套餐名称: "+trim(priFee)+"，小区资费："+feedistinc;
			}else{
				desc = "套餐名称: "+trim(priFee);
				showDesc = "套餐名称: "+trim(priFee);
			}
			
			if(trim(qryfee_code)!="000000"){
				showDialog("调用服务sMultiOffQryWS_XML获取资费描述失败："+qryfee_msg,0);
				return false;
			}else{
				if(gFeeDescStr!=""){
					desc = desc+"，套餐描述："+gFeeDescStr;
					showDesc = showDesc+"，套餐描述："+gFeeDescStr;
				}
				if(gFeeNoteStr!=""){
					showDesc = showDesc+"<br>"+gFeeNoteStr;
				}
			}
			
		}else{
			if(feed!=null&&feed!=""){
				desc = "主资费：套餐名称："+trim(priFee)+"，小区资费："+feedistinc;
				showDesc = "主资费：套餐名称："+trim(priFee)+"，小区资费："+feedistinc;
				if(gFeeDescStr!=""){
					desc = desc+"，套餐描述："+gFeeDescStr;
					showDesc = showDesc+"，套餐描述："+gFeeDescStr;
				}
			}else{
				desc = "主资费：套餐名称： "+trim(priFee);
				showDesc = "主资费： 套餐名称："+trim(priFee);
				if(gFeeDescStr!=""){
					desc = desc+"，套餐描述："+gFeeDescStr;
					showDesc = showDesc+"，套餐描述："+gFeeDescStr;
				}
			}
			
			if(gFeeNoteStr!=""){
				showDesc = showDesc+"<br>"+gFeeNoteStr;
				//desc = desc+"<br>"+gFeeNoteStr;
			}
		}
		
		oEffType=oEffType== 2 ?"1":oEffType;
		
		parent.Pri_FeeStr(PRI_FEE_CODE,feed,priFee,feedistinc,kx_code_bunch,kx_habitus_bunch,kx_operation_bunch,kx_name_bunch,"<%=meansId%>",
				effDateStr,expDateStr,kx_stream_bunch,kx_begintime,kx_endtime,kx_distri_code,kx_distri_name);
		parent.mktQryEffect(oEffType);
		parent.document.getElementById("feeDetails<%=meansId%>").innerHTML =trim(showDesc.replace(/[\r\n]/g,""));
		parent.setFeeDetails(desc,gFeeNoteStr);
		parent.setNotice(oNotice);
		parent.mainTraffic_Checkfuc();
		closeDivWin();
}

function multiOffQry(){
	var myPacket = null;
	myPacket = new AJAXPacket("multiOffQry.jsp","请稍后...");
	myPacket.data.add("iLoginAccept","<%=orderId%>");
	myPacket.data.add("iChnSource","01");
	myPacket.data.add("iOpCode","g794");
	myPacket.data.add("iLoginNo","<%=login_no%>");
	myPacket.data.add("iLoginPwd","<%=password%>");
	myPacket.data.add("iPhoneNo","<%=phoneNo%>");
	myPacket.data.add("iUserPwd","");
	myPacket.data.add("iOfferStr","<%=PRI_FEE_CODE%>#");
	core.ajax.sendPacket(myPacket,setMultiOffer);
	myPacket =null;
}
function setMultiOffer(packet){
	var RETURN_CODE = packet.data.findValueByName("RETURN_CODE");
	var RETURN_MSG = packet.data.findValueByName("RETURN_MSG");
	var feeCodeStr = packet.data.findValueByName("feeCodeStr");
	var feeDescStr = packet.data.findValueByName("feeDescStr");
	var feeNoteStr = packet.data.findValueByName("feeNoteStr");
	/* if(trim(RETURN_CODE)!="000000"){
		//showDialog(RETURN_MSG,0);
		//return false;
	} 
	*/
	qryfee_code = RETURN_CODE;
	qryfee_msg = RETURN_MSG;
	gFeeCodeStr = feeCodeStr;
	gFeeDescStr = feeDescStr;
	gFeeNoteStr = feeNoteStr;
}



function openwindow(theNo,p,q)
{
	//定义窗口参数
    var h=600;
    var w=720;
    var t=screen.availHeight-h-20;
    var l=screen.availWidth/2-w/2;
    var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no" ;
    var belong_code ="<%=belong_code%>";
    var maincash_no = "<%=mode_code %>";//主资费代码老
    var ip = "<%=PRI_FEE_CODE%>"; //主资费代码 新
    var cust_id = "<%=id_no%>";
    var sendflag ="<%=tbselect%>".substring(0,1);
	//-----------------linxd--1---------------------------
	var minopen="";
	var maxopen="";
    minopen = oMinOpenObj[theNo].value;
	maxopen = oMaxOpenObj[theNo].value;


    var ret_code = window.showModalDialog("feeFuInfo.jsp?mode_type="+p+"&belong_code="+belong_code+"&maincash_no="+codeChg(maincash_no)+"&ip="+codeChg(ip)+"&cust_id="+cust_id+"&sendflag="+sendflag+"&mode_name="+q+"&minopen="+minopen+"&maxopen="+maxopen+"&login_no=<%=login_no%>","",prop);
    var srcStr = ret_code;
    if(ret_code==null)
    {
        return false;
    }

    if(typeof(srcStr)!="undefined")
	  {
    	tohidden(p);
        getStr(srcStr,token);
    }
}
function getStr(srcStr,token)
	{
		var field_num = 13;
		var i =0;
		var inString = srcStr;
		var retInfo="";
		var tmpPos=0;
	    var chPos;
	    var valueStr;
	    var retValue="";

	    var a0="";
	    var a1="";
	    var a2="";
	    var a3="";
	    var a4="";
		var a5="";
		var a6="";
		var a7="";
        var a8="";
		var a9="";
		var a10="";
		var a11="";
		var a12="";
		var a1Tmp="";
		retInfo = inString;
		chPos = retInfo.indexOf(token);
	    while(chPos > -1)
	    {
		  for( i=0; i<field_num; i++)
		  {
			valueStr = retInfo.substring(0,chPos);

			if(i == 0) a0 = valueStr;
			if(i == 1) a1 = valueStr;
			if(a1=="Y")a1Tmp="已开通";
			if(a1=="N")a1Tmp="未开通";
			if(i == 2) a2 = valueStr;
			if(i == 3) a3 = valueStr;
			if(i == 4) a4 = valueStr;
            if(i == 5) a5 = valueStr;
			if(i == 6) a6 = valueStr;
            if(i == 7) a7 = valueStr;
            if(i == 8) a8 = valueStr;
			if(i == 9) a9 = valueStr;
			if(i == 10) a10 = valueStr;
            if(i == 11) a11 = valueStr;
			if(i == 12) a12 = valueStr;
			if(i == 13) a13 = valueStr;
			if(i == 14) a14 = valueStr;
			//rdShowMessageDialog("a12="+a12);
			retInfo = retInfo.substring(chPos + 1);
			chPos = retInfo.indexOf(token);
            if( !(chPos > -1)) break;
	       }
			  insertTab(a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a1Tmp);
	    }
	}
function insertTab(a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a1Tmp)
{

    var tr1=tr.insertRow();
    tr1.id="tr"+dynTbIndex;
    var divid = "div"+dynTbIndex;
    //rdShowMessageDialog(tr1.id);
	//rdShowMessageDialog("a12="+a12);
	td1 = tr1.insertCell();
	td2 = tr1.insertCell();
	td3 = tr1.insertCell();
	td4 = tr1.insertCell();
	td5 = tr1.insertCell();
	td6 = tr1.insertCell();
	td7 = tr1.insertCell();
	td8 = tr1.insertCell();
	td2.id="div"+dynTbIndex;
	td1.innerHTML = '<div align="center"><input type="checkbox" name="checkId" checked></input></div>';
    td2.innerHTML = '<div align="center"><a Href="javascript:openhref('+"'"+a7+"'"+')">'+a0+'</a><input id=R0 type=hidden value='+a0+'  size=10 readonly></input></div>';
    td3.innerHTML = '<div align="center">'+a1Tmp+'<input id=R1 type=hidden value='+a1+'  size=10 readonly></input></div>';
    td4.innerHTML = '<div align="center">'+a2+'<input id=R2 type=hidden value='+a2+'  size=18 readonly></input></div>';
    td5.innerHTML = '<div align="center">'+a3+'<input id=R3 type=hidden value='+a3+'  size=10 readonly></input></div>';
    td6.innerHTML = '<div align="center">'+a4+'<input id=R4 type=hidden value='+a4+'  size=10 readonly></input></div>';
    td7.innerHTML = '<div align="center">'+a5+'<input id=R5 type=hidden value='+a5+'  size=10 readonly></input></div>';
    td8.innerHTML = '<div align="center">'+a6+'<input id=R6 type=hidden value='+a6+'  size=10 readonly><input id=R7 type=hidden value='+a7+'  size=10 readonly><input id=R8 type=hidden value='+a8+
    '  size=10 readonly><input id=R9 type=hidden value='+a9+'  size=10 readonly><input id=R10 type=hidden value='+a10+
    '  size=10 readonly><input id=R11 type=hidden value='+a11+
    '  size=10 readonly><input id=R12 type=hidden value='+a12+
    '  size=10 readonly><input id=R13 type=hidden value='+a13+
    '  size=10 readonly><input name="R14" id="R14'+dynTbIndex+'" type=hidden  size=10 readonly></input></div>';
	$("#R14"+dynTbIndex).val(a12);   //为了解决返回描述信息中的回车造成数据显示不全
 //   getMidPrompt("10442",a7,divid);

    dynTbIndex++;


}
function tohidden(s)// s 表示 套餐类型，从openwindow 传入
{
	var tmpTr = "";
	for(var a = document.all('tr').rows.length-2 ;a>0; a--)//删除从tr1开始，为第三行
	{
        if(document.all.R8[a].value==s && document.all.R1[a].value=="N")
        {   			if(document.all.R11[a].value.trim()=="0"||document.all.R11[a].value.trim()=="c")//choice_flag0或c删除
            {
                document.all.tr.deleteRow(a+1);
						}
        }
	}

    return true;
}
function codeChg(s)
{
  var str = s.replace(/%/g, "%25").replace(/\+/g, "%2B").replace(/\s/g, "+"); // % + \s
  str = str.replace(/-/g, "%2D").replace(/\*/g, "%2A").replace(/\//g, "%2F"); // - * /
  str = str.replace(/\&/g, "%26").replace(/!/g, "%21").replace(/\=/g, "%3D"); // & ! =
  str = str.replace(/\?/g, "%3F").replace(/:/g, "%3A").replace(/\|/g, "%7C"); // ? : |
  str = str.replace(/\,/g, "%2C").replace(/\./g, "%2E").replace(/#/g, "%23"); // , . #
  return str;
}
function openhref(p)
	{
		var h=600;
		var w=550;
		var t=screen.availHeight-h-20;
		var l=screen.availWidth/2-w/2;
		var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no" ;
		var region_code = '<%=belong_code.substring(0,2)%>';
		var ret_code = window.showModalDialog("feeInfunds.jsp?mode_code="+p+"&region_code="+region_code+"&login_no=<%=login_no%>","",prop);
	}
	
function openhref(p)
{
	var h=600;
	var w=550;
	var t=screen.availHeight-h-20;
	var l=screen.availWidth/2-w/2;
	var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no" ;
	var region_code = '<%=belong_code.substring(0,2)%>';
	var ret_code = window.showModalDialog("feeInfunds.jsp?mode_code="+p+"&region_code="+region_code+"&login_no=<%=login_no%>","",prop);
}
function reSetPriFeeVar(){
	kx_code_bunch = "";
	kx_name_bunch ="";	
	kx_habitus_bunch = "";
	kx_operation_bunch = "";
	kx_stream_bunch = "";
	kx_begin_time = "";
	kx_begintime = "";
	kx_endtime = "";
	effDateStr = "";
	expDateStr = "";
	oEffType = "";
}		

	</script>
</html>
