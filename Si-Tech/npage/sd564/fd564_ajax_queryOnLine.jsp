<%
/********************
 * version v2.0
 * ������: si-tech
 ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType= "text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_ajax.jsp" %>
<%
		String workNo = (String)session.getAttribute("workNo");
		
		String password = (String)session.getAttribute("password");		//huangrong add for �������� 2011-8-16 
		String regionCode= (String)session.getAttribute("regCode");
		String groupId= (String)session.getAttribute("groupId");
		String searchOpCode = request.getParameter("searchOpCode");
		String phoneNo 	= request.getParameter("phoneNo");
		String custName = request.getParameter("custName");
		String idCardNo = request.getParameter("idCardNo");
		String occupId 	= request.getParameter("occupId");
		String startTime = request.getParameter("startTime");
		String endTime 	= request.getParameter("endTime");
		String selectGroupId 	= request.getParameter("groupId");
		System.out.println("````````````|" + selectGroupId + "|");
		/* ���ѡ���groupIdΪ�գ����빤�ŵ�groupId */
		
		if(selectGroupId == null || "".equals(selectGroupId)){
			selectGroupId = groupId;
		}
			System.out.println("``````selectGroupId``````|" + selectGroupId + "|");
		/* huangrong update ���Ϊ��׼��θ�ʽ��������β�ѯҵ������*/
		String opCode 	= request.getParameter("opCode");		//huangrong add for �������� 2011-8-16 
		String  inputParsm [] = new String[14];
		inputParsm[0] = "";  //��ˮ
		inputParsm[1] = "00"; //������ʶ 
		inputParsm[2] = opCode; //opCode 
		inputParsm[3] = workNo; //����  
		inputParsm[4] = password; //�������� 
		inputParsm[5] = phoneNo; //�ֻ����� 
		inputParsm[6] = "";      //�ֻ����� 
		inputParsm[7] = "";  //��ע 
		inputParsm[8] = custName; //�û����� 
		inputParsm[9] = idCardNo; //����֤�� 
		inputParsm[10] = occupId;  //ԤռID 
		inputParsm[11] = startTime; //��ʼʱ�� 
		inputParsm[12] = endTime; //����ʱ�� 
		inputParsm[13] = selectGroupId; //��֯���� huangrong add ��֯��������� 2011-8-27 
		
%>
		<wtc:service name="sD564Qry" routerKey="region" routerValue="<%=regionCode%>"
					 retcode="retCode" retmsg="retMsg" outnum="8">
				<wtc:param value="<%=inputParsm[0]%>"/>
				<wtc:param value="<%=inputParsm[1]%>"/>
				<wtc:param value="<%=inputParsm[2]%>"/>
				<wtc:param value="<%=inputParsm[3]%>"/>
				<wtc:param value="<%=inputParsm[4]%>"/>
				<wtc:param value="<%=inputParsm[5]%>"/>
				<wtc:param value="<%=inputParsm[6]%>"/>
				<wtc:param value="<%=inputParsm[7]%>"/>
				<wtc:param value="<%=inputParsm[8]%>"/>
				<wtc:param value="<%=inputParsm[9]%>"/>
				<wtc:param value="<%=inputParsm[10]%>"/>
				<wtc:param value="<%=inputParsm[11]%>"/>
				<wtc:param value="<%=inputParsm[12]%>"/>		
				<wtc:param value="<%=inputParsm[13]%>"/>								
		</wtc:service>
		<wtc:array id="ret" scope="end"/>
<%
		if("000000".equals(retCode)){
			System.out.println("============ fd564_qry.jsp ==========" + ret.length);
%>

<body>
<form name="frm1">
  <div id="Main">
		<div id="Operation_Table">
			<div class="title">
				<div id="title_zi">����ԤԼѡ����Ϣ��ѯ�б�</div>
			</div>
			<table cellspacing="0" name="t1" id="t1">
				<tr>
					<th>Ӫҵ������</th>
					<th>�ֻ�����</th>
					<th>������</th>
					<th>����״̬</th>
				</tr>
<%
				int nowPage = 1;
				int allPage = 0;
				if(ret.length==0){
					out.println("<tr height='25' align='center'><td colspan='4'>");
					out.println("û���κμ�¼��");
					out.println("</td></tr>");
				}else if(ret.length>0){
					String tbclass = "";
					for(int i=0;i<ret.length;i++){
							tbclass = (i%2==0)?"Grey":"";
							String tempStr = "";
%>
					<tr align="center" id="row_<%=i%>">
						<td class="<%=tbclass%>"><%=ret[i][5]%></td>
						<td class="<%=tbclass%>"><%=ret[i][0]%></td>
						<td class="<%=tbclass%>"><%=ret[i][3]%></td>
						<td class="<%=tbclass%>"><%=ret[i][6]%></td>
					</tr>
<%
					}
					allPage = (ret.length - 1) / 10 + 1 ;
				}
%>
			</table>
			<div align="center">
				<table align="center">
				<tr>
					<td align="center">
						�ܼ�¼����<font name="totalPertain" id="totalPertain"><%=ret.length%></font>&nbsp;&nbsp;
						��ҳ����<font name="totalPage" id="totalPage"><%=allPage%></font>&nbsp;&nbsp;
						��ǰҳ��<font name="currentPage" id="currentPage">1</font>&nbsp;&nbsp;
						ÿҳ������10
						<a href="javascript:setPage('1');">[��һҳ]</a>&nbsp;&nbsp;
						<a href="javascript:setPage('-1');">[��һҳ]</a>&nbsp;&nbsp;
						<a href="javascript:setPage('+1');">[��һҳ]</a>&nbsp;&nbsp;
						<a href="javascript:setPage('<%=allPage%>');">[���һҳ]</a>&nbsp;&nbsp;
						��ת��
						<select name="toPage" id="toPage" style="width:80px" onchange="setPage(this.value);">
							<%
							for (int i = 1; i <= allPage; i ++) {
							%>
								<option value="<%=i%>">��<%=i%>ҳ</option>
							<%
							}
							%>
						</select>
						ҳ
					</td>
				</tr>
				</table>
			</div>
			<input type="hidden" id="nowPage" />
			<input type="hidden" id="allPage" value="<%= allPage %>" />
		</div>
	</div>
</form>
</body>
<script language="javascript">
	$(document).ready(function(){
		var nowp = "<%= nowPage %>";
		$("#nowPage").val(nowp);
		setPage(nowp);
	});
	function setPage(goPage){
		if (goPage == "-1") {
			setPage(parseInt($("#nowPage").val()) - 1);
			return;
		} else if (goPage.length == 2 && "+1" == goPage) {
			setPage(parseInt($("#nowPage").val()) + 1);
			return;
		}else{ 
			goPage = parseInt(goPage);
			if(goPage < 1){
				return false;
			}else if(goPage > $("#allPage").val()){
				return false;
			}else{
				pageNo = parseInt(goPage);
				//����������
				$("[id^='row_']").hide();
				//��ʾ��
				var startRow = (pageNo - 1) * 10;
				var endRow = pageNo * 10 - 1;
				for(var i = startRow; i <= endRow; i++ ){
					var pageStr = "#row_" + i;
					$(pageStr).show();
				}
				$("#nowPage").val(pageNo);
				$("#currentPage").text(pageNo);
			}
		}
	}
</script>
</html>
<%		
		}else{
%>
			<script language="javascript">
	      rdShowMessageDialog("������룺<%=retCode%><br>������Ϣ��<%=retMsg%>", 0);
	      window.location.href="fd564.jsp";
	   	</script>
<%
		}
%>  	