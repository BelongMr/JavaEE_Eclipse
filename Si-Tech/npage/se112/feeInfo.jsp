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
	String brandId =request.getParameter("brandId");//Ʒ��
	String mode_code =request.getParameter("mode_code");
	String PRI_FEE_CODE=request.getParameter("PRI_FEE_CODE");
	String PRI_FEE_NAME=request.getParameter("PRI_FEE_NAME");
	String group_id = (String)session.getAttribute("groupId");
	System.out.println("clientInfo=xml===AAAAAAAAAAAAAAAAAAAAAA====" + xml);
	String showFlag = "style=\"display:block\"";
	String id_no= request.getParameter("id_no");//�û�ID
	String powerRight=request.getParameter("powerRight");//�û�Ȩ��
	String belong_code=request.getParameter("belong_code");//�û�����
	String act_type=request.getParameter("act_type");//�С��
	String startTime=request.getParameter("startTime");//��ʼʱ��
	String H15   = (String)request.getParameter("H15");//�С��
	String netFlag   = (String)request.getParameter("netFlag");//�С��
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
	//boolean isCtrlMoney = false;//�Ƿ���ڿ��޸Ľڵ�
	//boolean isCtrlMonth = false;//�Ƿ���ڿ��޸Ľڵ�
	//boolean isCtrlRate = false;//�Ƿ���ڿ��޸Ľڵ�
	//boolean isCtrl = false;//�Ƿ���ڿ��޸Ľڵ�
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
			<input type="hidden" name="kx_want"><!--��ӡ�������������--->
			<input type="hidden" name="kx_cancle"><!--��ӡ������ȡ������--->
			<input type="hidden" name="kx_running"><!--��ӡ�����п�ͨ���ײ�--->
			<input type="hidden" name="kx_code_bunch">
			<!--��ѡ�ʷѴ��봮-->
 			<input type="hidden" name="kx_habitus_bunch">
 			<!--��ѡ�ʷ�״̬��-->
 			<input type="hidden" name="kx_operation_bunch">
 			<!--��ѡ�ײ͵���Ч��ʽ��-->
 			<input type="hidden" name="kx_explan_bunch">
 			<!--��ѡ�ײ�˵��-->
 			<input type="hidden" name="kx_code_name_bunch">
 			<!--��ѡ�ײ�����-->
 			<input type="hidden" name="kx_erpi_bunch">
 			<input type="hidden" name="kx_stream_bunch"><!--ԭ��ѡ�ײ͵Ŀ�ͨ��ˮ��-->
				<div id="operation_table">
					 <div class="title">
						<div class="text">
							�ʷ���ϸ��Ϣ
						</div>
					</div>
					<div class="input">
					<table>
							<tr>
								<th>
									С������
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
									<option value="">----------��-----------��ѡ��---------------------</option>
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
								 <td class="blue" width="15%">��ѡ�ײ����</td>
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
									    out.println("<input type=hidden name=oActualOpen value='0'>");    //ʵ�ʿ�ͨ����
										out.println("<input type=hidden name=oDefaultFlag value='N'>");   //�Ƿ���Ĭ�����������
										out.println("<input type=hidden name=oDefaultOpen value='N'>");   //�Ƿ�Ĭ�������Ƿ����һ������
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
									<div id="title_zi">�ײ���Ϣ</div>
								</div>
							   <table id=tr cellSpacing="0" style="display:block">
					          <tr align="center">
						     		 <th <%=showFlag%> nowrap>ѡ��</th>
										 <th nowrap>��ѡ�ײ�����</th>
										 <th nowrap>״̬</th>
										 <th nowrap>��ʼʱ��</th>
										 <th nowrap>����ʱ��</th>
										 <th nowrap>�ײ����</th>
										 <th nowrap>��Ч��ʽ</th>
					                     <th nowrap>��ѡ��ʽ</th>
					                     <th nowrap>С������ѡ��</th>
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
    		tbselect = (String)d.get("temp_buf"); //��Чʱ��,���ڹ�����ӡ
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
	if(data[y][data[0].length-3].equals("0") || data[y][data[0].length-3].equals("1")||data[y][data[0].length-3].equals("4")){//Ĭ������
	
	 System.out.println("+++++++++++++++++++++++++++++++54565656565656++++++++++++++++++"+data[0].length);
%>
				<td <%=showFlag%>><input type="checkbox" name="checkId" checked></td>
	 <%
	 		}

	 		if(data[y][data[0].length-3].equals("2")){//������
	 %>
				<td <%=showFlag%>>
					<input type="checkbox" name="checkId" disabled checked onclick="if(document.all.checkId[<%=y%>+1].checked==false){ document.all.checkId[<%=y%>+1].checked=true;} showDialog('�����룡',1);return false;">
				</td>
	 <%
	 		}

	 		if(data[y][data[0].length-3].equals("a")){//Ĭ������������Чʱ������ʷʱ���ͻ����������
	 %>
				<td <%=showFlag%>>
					<input type="checkbox" name="checkId" onclick="if(document.all.checkId[<%=y%>+1].checked==true){document.all.checkId[<%=y%>+1].checked=false;} showDialog('Ĭ������������Чʱ������ʷʱ���ͻ���������룡',1);return false;">
				</td>
	 <%
	 		}

	 		if(data[y][data[0].length-3].equals("b")){//ǿ������������Чʱ������ʷʱ���ͻ����������
	 %>
				<td <%=showFlag%>>
					<input type="checkbox" name="checkId" onclick="if(document.all.checkId[<%=y%>+1].checked==true){document.all.checkId[<%=y%>+1].checked=false;} showDialog('ǿ������������Чʱ������ʷʱ���ͻ���������룡',1);return false;">
				</td>
	 <%
	 		}

	 		if(data[y][data[0].length-3].equals("d")){//ǿ��ȡ��
	 %>
				<td <%=showFlag%>>
					<input type="checkbox" name="checkId"disabled onclick="if(document.all.checkId[<%=y%>+1].checked==true ){document.all.checkId[<%=y%>+1].checked=false;} showDialog('ǿ��ȡ���������룡',1);return false;">
				</td>
	 <%
	 		}

	 		if(data[y][data[0].length-3].equals("9")){//����ȡ��
	 %>
				<td <%=showFlag%>>
					<input type="checkbox" name="checkId" checked onclick="if(document.all.checkId[<%=y%>+1].checked==false){document.all.checkId[<%=y%>+1].checked=true;} showDialog('�����ѡ�ʷѣ��뵽����ҵ����������',1);return false;">
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
						if(data[y][j].trim().equals("Y"))habitus="�ѿ�ͨ";
						if(data[y][j].trim().equals("N"))habitus="δ��ͨ";
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
				 else if(j==12)//��ѡ�ʷ���С���ʷѱ�ʶ
					{
					    String flag = "";
						if(data[y][j].trim().equals("Y")){
							/* flag="����С���ʷѣ�����ѡ��";
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
							flag="��";
							tbstr = "<td><a >"+flag+"</a><input type='hidden' " +
									" id='R13_" + (y+1)  + "' name='R13_" + (y+1) + "' class='button' value='" +
									data[y][j].trim()  + "'readonly></td>";
						}
					    
					}
				 else if(j==13)//��ѡ�ʷ���С���ʷ��б�
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
						<input type="button" class="b_foot" value="ȷ��" id="btnSubmit"
							name="btnSubmit" onclick="btnRsSubmit()" />
						<input type="button" class="b_foot" value="�ر�" id="btnCancel"
							name="btnCancel" onclick="closeWin()" />
					</div>

			</form>
		</div>
	</body>
	<script type="text/javascript">
   var oActualOpenObj = document.getElementsByName("oActualOpen"); //�����ж�
   var oDefaultFlagObj = document.getElementsByName("oDefaultFlag"); //�����ж�
   var oDefaultOpenObj = document.getElementsByName("oDefaultOpen"); //�����ж�
   var oTypeValueObj = document.getElementsByName("oTypeValue"); //�����ж�
   var oTypeNameObj = document.getElementsByName("oTypeName"); //�����ж�
   var oMinOpenObj = document.getElementsByName("oMinOpen"); //�����ж�
   var oMaxOpenObj = document.getElementsByName("oMaxOpen"); //�����ж�	
   var dynTbIndex=0;
   var token = "|";	
   function closeWin(){
		closeDivWin();
   }
	
   var kx_code_bunch = "";                                     //��ѡ�ʷѴ��봮
   var kx_name_bunch = "";                                     //��ѡ�ʷ����ƴ�
   var kx_code_name_bunch = "";                                 //��ѡ�ʷ����ƴ�
   var kx_habitus_bunch ="";                                   //��ѡ�Է�״̬��
   var kx_erpi_bunch="";										//��ѡ�ײͶ���
   var kx_operation_bunch="";                                  //��ѡ�ײ͵���Ч��ʽ��
   var kx_stream_bunch="";                                     //��ѡ�ײ�ԭ��ͨ��ˮ��
   var kx_explan_bunch="";									//��ѡ�ײ�����
   var kx_begin_time="";									//��ѡ�ײͿ�ʼʱ��
   var tempnm="";												 //��ʱ��������
   var kx_want="";											 //��ӡ���������
   var kx_cancle="";											 //��ӡ��ȡ������
   var kx_running="";											 //��ӡ�����п�ͨ����
   var kx_want_chgrow="0";								     //��ӡ���������,���б�־
   var kx_cancle_chgrow= "0";									 //��ӡ��ȡ������,���б�־
   var kx_running_chgrow="0";									 //��ӡ�����п�ͨ����,���б�־
   var kx_distri_code = "";//��ѡ�ײ���С���ʷѴ���
   var kx_distri_name = "";//��ѡ̫����С���ʷ�����
   var oNotice = "";
   var retflag = 0;
   kx_want =  "���������ѡ�ײͣ�";
   kx_cancle = "����ȡ����ѡ�ײͣ�";	
   var kx_cancle_str=""; //ȡ���Ŀ�ѡ�ײ���ʾ
   function btnRsSubmit(){
	   $("#btnSubmit").attr("disabled", "true");
	   if("<%=code%>"!="000000"){
		   showDialog("<%=message%>",0);
		   return;
	   }
	   
	for(var i=0;i<document.all.checkId.length;i++)
	{
		 		
		if(document.all.checkId[i].checked==true && document.all.R1[i].value=="N" ||//����
			   document.all.checkId[i].checked==false && document.all.R1[i].value=="Y" )//ȡ��
		{
			kx_code_bunch = kx_code_bunch + document.all.R7[i].value + "#"; //��ѡ�ʷѴ��봮
			kx_name_bunch = kx_name_bunch + document.all.R0[i].value + "#"; //��ѡ�ʷ����ƴ�
			kx_habitus_bunch = kx_habitus_bunch + document.all.R1[i].value + "#";       //��ѡ�ʷ�״̬��
			kx_operation_bunch = kx_operation_bunch + document.all.R9[i].value + "#";   //��ѡ�ײ͵���Ч��ʽ��
			kx_stream_bunch = kx_stream_bunch + document.all.R10[i].value + "#";//��ѡ�ײ�ԭ��ͨ��ˮ��
			kx_begin_time = kx_begin_time + document.all.R2[i].value + "#";//��ѡ�ײͿ�ʼʱ��
			var kx_distri_info = $("#R13_"+i).val();
			if(kx_distri_info != "" && kx_distri_info != null &&  kx_distri_info != "N"){
				var kx_distri_arr = kx_distri_info.split("~");
				kx_distri_code = kx_distri_code + kx_distri_arr[0] + "#";//��ѡ�ײ�С����Ϣ
				kx_distri_name = kx_distri_name + kx_distri_arr[1] + "#";//��ѡ�ײ�С����Ϣ
			}else{
				kx_distri_code = kx_distri_code + "NNN#";//��ѡ�ײ�С����Ϣ
				kx_distri_name = kx_distri_name + "NNN#";//��ѡ�ײ�С����Ϣ
			}

			if(document.all.R14[i].value=="��������Ϣ"){
				kx_explan_bunch = kx_explan_bunch ;
			}else{
				kx_explan_bunch = kx_explan_bunch +" "+ document.all.R14[i].value ;
			}
			if(document.all.checkId[i].checked==true && document.all.R1[i].value=="N") //���п�ͨ���
			{
				kx_want = kx_want +  " (" + document.all.R7[i].value+"��"+ document.all.R0[i].value+"��"+document.all.R5[i].value +")" ;  //���봮
				kx_want_chgrow = 1*kx_want_chgrow+1;
			}
			if(document.all.checkId[i].checked==false && document.all.R1[i].value=="Y")//ȡ�����
			{
				kx_cancle = kx_cancle +  " (" + document.all.R7[i].value+"��"+ document.all.R0[i].value+"��"+document.all.R5[i].value +")" ;  //ȡ����
				kx_cancle_chgrow = 1*kx_cancle_chgrow+1;
			}			
		}
	}

	if(trim(kx_cancle)!="����ȡ����ѡ�ײͣ�"){
		alert(kx_cancle);
	}

	retflag = 0;
	var smPacket = new AJAXPacket("getS1270Notice.jsp","���Ժ�......");
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


//=======================================��ѯ��ʧЧ��ʽstart========================================		
		if("<%=act_type%>" == "63"){
			var sPacket = new AJAXPacket("getMktQryEffect.jsp","���Ժ�......");
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
//=======================================��ѯ��ʧЧ��ʽend========================================
		 
//=====================================��ȡ��ʧЧʱ�俪ʼ=====================		
		if("<%=act_type%>" == "63" && oEffType == ""){

		}else{
			var sPacket = new AJAXPacket("getEffectTime.jsp","���Ժ�......");
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
//=====================================��ȡ��ʧЧʱ�����=====================			
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
		oNotice = "Ϊ��������Ȩ�棬��ԭ"+outOldName+"���ʷѰ����Ĳ���ҵ��Ϊ����ѱ���һ�꣬�����ڼ�ҵ��ÿ�·���Ϊ"+outPrice+"Ԫ��ϵͳÿ��������"+outPrice+"Ԫר��൱�����ʹ�á��ñ����Ĳ���ҵ���������ʷ���Ч�����ڿ�ʼ���㣬���ں����ޱ仯���Żݽ��Զ�˳��һ�꣬���б仯ϵͳ����ǰ1���¶���֪ͨ��";
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
                      ��С��ȥ��������С�඼�����ʷ�������ѯ�ӿڣ�չʾ�ʷ�������������ת��Ϣ����
           desc:���չʾ���ʷ���Ϣ���������ʷ���ת��Ϣ����
           showDesc��ǰ̨չʾ�������ʷ���Ϣ�������ʷ���ת��Ϣ
		*/
		multiOffQry();
		var desc = "";
		var showDesc = "";
		
		if("<%=act_type%>" == "71"){
			
			
			//var desc = "";
			if(feed!=null&&feed!=""){
				desc = "�ײ�����: "+trim(priFee)+"��С���ʷѣ�"+feedistinc;
				showDesc = "�ײ�����: "+trim(priFee)+"��С���ʷѣ�"+feedistinc;
			}else{
				desc = "�ײ�����: "+trim(priFee);
				showDesc = "�ײ�����: "+trim(priFee);
			}
			
			if(trim(qryfee_code)!="000000"){
				showDialog("���÷���sMultiOffQryWS_XML��ȡ�ʷ�����ʧ�ܣ�"+qryfee_msg,0);
				return false;
			}else{
				if(gFeeDescStr!=""){
					desc = desc+"���ײ�������"+gFeeDescStr;
					showDesc = showDesc+"���ײ�������"+gFeeDescStr;
				}
				if(gFeeNoteStr!=""){
					showDesc = showDesc+"<br>"+gFeeNoteStr;
				}
			}
			
		}else{
			if(feed!=null&&feed!=""){
				desc = "���ʷѣ��ײ����ƣ�"+trim(priFee)+"��С���ʷѣ�"+feedistinc;
				showDesc = "���ʷѣ��ײ����ƣ�"+trim(priFee)+"��С���ʷѣ�"+feedistinc;
				if(gFeeDescStr!=""){
					desc = desc+"���ײ�������"+gFeeDescStr;
					showDesc = showDesc+"���ײ�������"+gFeeDescStr;
				}
			}else{
				desc = "���ʷѣ��ײ����ƣ� "+trim(priFee);
				showDesc = "���ʷѣ� �ײ����ƣ�"+trim(priFee);
				if(gFeeDescStr!=""){
					desc = desc+"���ײ�������"+gFeeDescStr;
					showDesc = showDesc+"���ײ�������"+gFeeDescStr;
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
	myPacket = new AJAXPacket("multiOffQry.jsp","���Ժ�...");
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
	//���崰�ڲ���
    var h=600;
    var w=720;
    var t=screen.availHeight-h-20;
    var l=screen.availWidth/2-w/2;
    var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no" ;
    var belong_code ="<%=belong_code%>";
    var maincash_no = "<%=mode_code %>";//���ʷѴ�����
    var ip = "<%=PRI_FEE_CODE%>"; //���ʷѴ��� ��
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
			if(a1=="Y")a1Tmp="�ѿ�ͨ";
			if(a1=="N")a1Tmp="δ��ͨ";
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
	$("#R14"+dynTbIndex).val(a12);   //Ϊ�˽������������Ϣ�еĻس����������ʾ��ȫ
 //   getMidPrompt("10442",a7,divid);

    dynTbIndex++;


}
function tohidden(s)// s ��ʾ �ײ����ͣ���openwindow ����
{
	var tmpTr = "";
	for(var a = document.all('tr').rows.length-2 ;a>0; a--)//ɾ����tr1��ʼ��Ϊ������
	{
        if(document.all.R8[a].value==s && document.all.R1[a].value=="N")
        {   			if(document.all.R11[a].value.trim()=="0"||document.all.R11[a].value.trim()=="c")//choice_flag0��cɾ��
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