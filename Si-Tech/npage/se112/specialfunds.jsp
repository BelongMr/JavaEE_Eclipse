
<%
	/*
	 * ���ܣ� ר����ϸ��Ϣҳ��
	 * �汾�� v1.0
	 * ���ڣ� 20110223 songjia for hlj
	 */
%>
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/se112/public_title_name.jsp"%>
<%@ include file="/npage/se112/footer.jsp"%>
<%@page import="com.sitech.crmpd.core.bean.MapBean"%>
<%@page import="java.util.*"%>
<%@page import="com.sitech.crmpd.core.util.SiUtil"%>
<%
	
	String xml = request.getParameter("specialfunds");
	
	System.out.println("specialfunds=xml===AAAAAAAAAAAAAAAAAAAAAA====" + xml);
	
 	MapBean mb = new MapBean();
 %>	
 <%@ include file="getMapBean.jsp"%>
 <%
	List fundsList = null;
	Iterator it =null;
	
	if(null != mb){
	
		fundsList = mb.getList("OUT_DATA.H02.SPECIAL_FUNDS_LIST.SPECIAL_FUNDS_INFO");
	
		if(null!=fundsList)
			it =fundsList.iterator();
	}
	
 %>
<html>
	<head>
	<title></title>
	</head>
	<body>
		<div id="operation">
		<form method="post" name="frm4938" action="">
				
				<div id="operation_table">
					 <div class="title">
						<div class="text">
							ר����ϸ��Ϣ
						</div>
					</div>
					<div class="input">
					<table>
					<%
						java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd");
						java.util.Calendar calendar =java.util.Calendar.getInstance();// �������� 

						
						if(null!=it){
							while(it.hasNext()){
							Map stMap = mb.isMap(it.next());
							if(null==stMap)continue;
						
							String stagesIndex = (String)stMap.get("INDEX");
							String payType = (String)stMap.get("PAY_TYPE") == null ? "":(String)stMap.get("PAY_TYPE");
							String payMoney = (String)stMap.get("PAY_MONEY") == null ? "":(String)stMap.get("PAY_MONEY");
							String validFlag = (String)stMap.get("VALID_FLAG") == null ?"":(String)stMap.get("VALID_FLAG");
							String comsumeTime = (String)stMap.get("CONSUME_TIME") == null ? "" : (String)stMap.get("CONSUME_TIME");
							String startTime = (String)stMap.get("START_TIME") == null ? "" : (String)stMap.get("START_TIME");
							String returnType = (String)stMap.get("RETURN_TYPE") == null ? "" : (String)stMap.get("RETURN_TYPE");
							String returnClass = (String)stMap.get("RETURN_CLASS") == null ? "" : (String)stMap.get("RETURN_CLASS");
							String feeDirec = (String)stMap.get("FEE_DIREC") == null ? "" : (String)stMap.get("FEE_DIREC");
							String paymentType = (String)stMap.get("PAYMENT_TYPE") == null ?"":(String)stMap.get("PAYMENT_TYPE"); //�ɷ����� 
							String relativeMonth = (String)stMap.get("RELATIVE_MONTH") == null ?"":(String)stMap.get("RELATIVE_MONTH"); //������� 

					 %>
							<tr>
								
								<th>
									ר������
								</th>
								
								<td id="stageDesc<%=stagesIndex%>">
									<%= payType%>					
								</td>
								<th>�շѽ��</th>
								<td>
								<%= payMoney%>
								</td>
							</tr>
							
							<tr>
								
								<th>ר����Ч��ʶ</th>
								<td>
								<%if("0".equals(validFlag)){
									out.print("������Ч");
								}else if("1".equals(validFlag)){
									out.print("������Ч");
								}else if("2".equals(validFlag)){
									out.print("�Զ���ʱ��");
								}else if("3".equals(validFlag)){
									out.print("�������");
								} 
								
								%>
								</td> 
								<th>��������</th>
								<td>
								<%=comsumeTime%>
								</td>
								
							</tr>
							<tr>
								<th>������ʽ</th>
								<td>
								<%if("0".equals(returnType)){
									out.print("�Ԥ��");
								}else if("1".equals(returnType)){
									out.print("����Ԥ��");
								}
								%>
								</td> 
								<th>��������</th>
								<td>
								<%
								if("1".equals(returnClass)){
									out.print("���·����ۼ�");
								}else if("2".equals(returnClass)){
									out.print("���");
								}else if("3".equals(returnClass)){
									out.print("���·����ۼƼӲ��");
								}else if("4".equals(returnClass)){
									out.print("���·������ۼ�");
								}
								%>
								</td>
								
							</tr>
							<% if("2".equals(validFlag)){ %>
							<tr>
								
								<th>��ʼʱ��</th>
								<td>
								<%
							 if("2".equals(validFlag)){
									out.print(startTime);
								}
								%>
								</td>
								<td>
								</td>
							</tr>
							<%} %>
							<tr>
								<th>�ɷ�����</th>
								<td>
								<%
								 if("2".equals(paymentType)){
									 out.print("D�˱�ת��");
								 }else if("1".equals(paymentType)){
									 out.print("��������");
								 }else if("3".equals(paymentType)){
									 out.print("ת��ģʽ");
								 }else if("4".equals(paymentType)){
									 out.print("����ͳ��");
								 }else if("5".equals(paymentType)){
										out.print("ͳһd�ʱ�ת��");
								}else if("6".equals(paymentType)){
										out.print("SPת��ģʽ");
								}
								%>
								</td>
								
							<% 
								if("3".equals(validFlag)){
							%>
									<th>ר����Ч�������</th>
									<td>
									<%
								 	if("3".equals(validFlag)){
										out.print(relativeMonth);
									}
									%>
									</td>
							<%
							}
							%>
								
							</tr>
						<%
							}
						}%>
						</table>
						</div>
					<div id="operation_button">
						<input type="button" class="b_foot" value="�ر�" id="btnCancel"
							name="btnCancel" onclick="closeWin()" />
					</div>
				</div>
			</form>
		</div>
	</body>
	<script type="text/javascript">
	
	function closeWin(){
		closeDivWin();
	}
	
	</script>
</html>