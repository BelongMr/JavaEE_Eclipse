<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page contentType="text/html;charset=GBK"%>

<%
   String workNo = (String)session.getAttribute("workNo");
 	 String orgCode = (String)session.getAttribute("orgCode");
	 String regionCode = orgCode.substring(0,2);   
	  /*lijy change@20110722Ϊ�����ַ��񶩵���gmsҵ��or����orIMS�̻�ҵ���޸Ĳ�ѯsql��ԭ�Ȳ�ѯsql��
	 String strSql="SELECT e.CUST_ORDER_ID,f.STATUS_NAME, e.service_no " 
								+" FROM dservordermsg e,sServOrderState f "
								+" WHERE  e.LOGIN_NO='"+workNo.trim()+"' AND e.order_status = f.status " 
								+" AND f.status in(100,110)";
	 
	 String strSql="SELECT e.CUST_ORDER_ID,f.STATUS_NAME, e.service_no,h.master_serv_id" 
								+" FROM dservordermsg e,sServOrderState f ,service_offer g,product h "
								+" WHERE  e.LOGIN_NO='"+workNo.trim()+"' AND e.order_status = f.status " 
								+" AND e.SERV_BUSI_ID=g.SERVICE_OFFER_ID  AND g.PRODUCT_ID=h.PRODUCT_ID " 
								+" AND f.status in(100,110)"
								+" AND g.ORDERUSERFLAG<>'L'";
								
			*/
			
			//hejwa Ӫ���޸�					
				String strSql="	SELECT e.CUST_ORDER_ID,f.STATUS_NAME, e.service_no,h.master_serv_id "+
									    " FROM dservordermsg e,sServOrderState f ,service_offer g,product h, service_offer a "+
									    " WHERE  e.LOGIN_NO='"+workNo.trim()+"' AND e.order_status = f.status "+
									    " AND e.SERV_BUSI_ID=g.SERVICE_OFFER_ID  AND g.PRODUCT_ID=h.PRODUCT_ID "+
									    " AND f.status in(100,110) "+
									    " AND g.ORDERUSERFLAG<>'L' "+
									    " and e.SERV_BUSI_ID = a.service_offer_id "+
									    " and a.action_id not in (5012,5013,5014)		 ";						
	System.out.println("strSql=="+strSql);
	
	String opCode="q099";
	String opName="�쳣������ѯ";
%>
<wtc:pubselect name="sPubSelect" outnum="4" routerKey="region" routerValue="<%=regionCode%>">
	<wtc:sql><%=strSql%></wtc:sql>
</wtc:pubselect>
<wtc:array id="retCustOrder" scope="end"/>
<HTML><HEAD><TITLE>������BOSS-�쳣������ѯ</TITLE>
</HEAD>
<BODY>
<FORM action="" method=post name=form>
  
        <%@ include file="/npage/include/header.jsp" %>   
  	
		<div class="title">
			<div id="title_zi">�쳣������ѯ</div>
		</div>
			<table class="list" width="100%">
				<tr>
					<th>�ͻ�������</th>
					<th>�û�����</th>
					<th>״̬</th>
					<th>����</th>
				</tr>
	<%
	if(retCode.equals("000000"))
	{
		int length = retCustOrder.length;
		for(int i=0;i<length;i++)
		{		
			String custOrderId = retCustOrder[i][0];
			String custOrderstatus = retCustOrder[i][1];
			//String custId = retCustOrder[i][2];
			String phone_no = retCustOrder[i][2];
			//lijy add@20110722
			String master_serv_id=retCustOrder[i][3];
	%>			
				<tr>
					<td nowrap><%=custOrderId%></td>
					<td nowrap><%=phone_no%></td>
					<td nowrap><%=custOrderstatus%></td>
					<td nowrap>
						<a href="javascript:toCancel('<%=custOrderId%>','<%=master_serv_id%>')" >����</a>
					</td>
				</tr>
<%	}
	}
%>		
			</table>
	 <%@ include file="/npage/include/footer_simple.jsp" %>  
</FORM>
</BODY>
</HTML>
<script>	
  function toCancel(custOrderId,master_serv_id) {   
  	  if(master_serv_id == "30")
  	  {
  	  	 parent.L("1","e083","��������","sq034/fq034.jsp?custOrderId="+custOrderId,"000");
  	  }
  	  else{
  	  	parent.L("1","q034","��������","sq034/fq034.jsp?custOrderId="+custOrderId,"000");
  	  }
  }
</script>
<script>
	   $("#wait0").hide();		   
</script>
			