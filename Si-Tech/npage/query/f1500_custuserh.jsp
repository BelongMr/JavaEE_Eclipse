<%
/********************
 version v2.0
������: si-tech
*
*update:zhanghonga@2008-08-12 ҳ�����,�޸���ʽ
*
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	
<%@ page contentType= "text/html;charset=gb2312" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
	String opCode = "1500";
  String opName = "�ۺ���Ϣ��ѯ֮�ͻ�-�û���Ӧ��ϵ��ʷ";
	
	String region_code = ((String)session.getAttribute("orgCode")).substring(0,2);

	//������� �ͻ�ID���ͻ��������������š�����Ա����ɫ������
	String cust_id=request.getParameter("custId");
	String cust_name=request.getParameter("custName");
	String work_no=request.getParameter("workNo");
	String work_name=request.getParameter("workName");
	String recodeIDd=request.getParameter("recodeIDd");
	 //add by diling for ��ȫ�ӹ��޸ķ����б�
	String loginNo = (String)session.getAttribute("workNo");
	String password = (String) session.getAttribute("password");

	/**
	ArrayList arlist = new ArrayList();
	try{
		s1550view viewBean = new s1550view();//ʵ����viewBean
		arlist = viewBean.s1500_custuserh(cust_id,region_code); 
	}
	catch(Exception e)
	{
		//System.out.println("����EJB����ʧ�ܣ�");
	}
	**/
%>
	<wtc:service name="s1500_custuserh" routerKey="region" routerValue="<%=region_code%>" retcode="retCode1" retmsg="retMsg1" outnum="10" >
	<wtc:param  value=""/>
  <wtc:param  value="01"/>
  <wtc:param  value="<%=opCode%>"/>
  <wtc:param  value="<%=loginNo%>"/>
  <wtc:param  value="<%=password%>"/>
  <wtc:param  value=""/>
  <wtc:param  value=""/>
	<wtc:param value="<%=cust_id%>"/>
	<wtc:param value="<%=region_code%>"/>
	</wtc:service>
	<wtc:array id="result" scope="end"/>
<%	
	int iretCode=999999; //��Ϊ����ķ���д�ò��淶,��ȷ�Ĳ�һ������������,����Ҫ����ж�
	
	if(retCode1!=null&&!"".equals(retCode1)){
		iretCode=Integer.parseInt(retCode1);
	}
	if(iretCode!=0){
%>
	<script language="javascript">
		history.go(-1);
		rdShowMessageDialog("����δ�ܳɹ�,�������:<%=retCode1%><br>������Ϣ:<%=retMsg1%>!");
	</script>
<%
		return;
	}else if(result==null||result.length==0){
%>
	<script language="javascript">
		history.go(-1);
		rdShowMessageDialog("��ѯ���Ϊ��,�ͻ�-�û���Ӧ��ʷ��ϵ������!");
	</script>
<%
		return;
	}
	
	String return_code =result[0][0];
	String return_message =result[0][1];
	
	if (!return_code.equals("000000")){
%>
		<script language="JavaScript">
			rdShowMessageDialog("<%=return_message%><br>�������:<%=return_code%>");
			history.go(-1);
		</script>
<%	
	}
%>

<HTML><HEAD><TITLE>�ͻ�-�û���Ӧ��ϵ��ʷ��Ϣ</TITLE>
<script language="javascript">
	$(document).ready(function(){
		try{
			parent.parent.oprInfoRecode('','','','',"<%=recodeIDd%>");
		}catch(e){
		}
	});
</script>		
</HEAD>
<body>
<FORM method=post name="f1500_custuserh">
<%@ include file="/npage/include/header.jsp" %>     	
		<div class="title">
			<div id="title_zi">�ͻ�-�û���Ӧ��ϵ��ʷ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ͻ�����:<%=cust_name%></div>
		</div>			

    <TABLE>
      <TBODY>
        <TR cellspacing="0" align="center">
          <th>�������</TD>
          <th>������־</TD>
          <th>���ű��</th>
          <th>����ʱ��</th>
          <th>��������</th>
          <th>��������</th>
          <th>��������</th>
          <th>������ˮ</th>
        </TR>
<%	      
				String tbClass="";
				for(int y=0;y<result.length;y++){
		      if(y%2==0){
						tbClass="Grey";
					}else{
						tbClass="";
					}
%>
	        <tr align="center">
<%    		
					for(int j=2;j<result[0].length;j++){
%>
		  				<td class="<%=tbClass%>"> <%= result[y][j]%> &nbsp;</td>
<%		
					}
%>
          </tr>
<%	      
				}
%>
      </TBODY>
    </TABLE>
          
      <table cellspacing=0>
        <tbody> 
          <tr> 
      	    <td id="footer">
    	      &nbsp; <input class="b_foot" name=back onClick="history.go(-1)" type=button value=����>
    	      &nbsp; <input class="b_foot" name=back onClick="parent.removeTab('<%=opCode%>')" type=button value=�ر�>
    	      &nbsp; 
    	    </td>
          </tr>
        </tbody> 
      </table>
		<%@ include file="/npage/include/footer.jsp" %>
</FORM>
</BODY></HTML>