 <%
	/********************
	 version v2.0
	������: si-tech
	update:anln@2009-01-20 ҳ�����,�޸���ʽ
	********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType= "text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.sitech.boss.util.page.*"%>
<%
	String opCode = "4112";	
	String opName = "�������Ѽƻ����";	//header.jsp��Ҫ�Ĳ���   
	String regionCode = (String)session.getAttribute("regCode") ;
	
    //�õ��������
    ArrayList retArray = new ArrayList();
    ArrayList retArray1 = new ArrayList();
    String return_code,return_message;
    //String[][] result = new String[][]{};
    //String[][] allNumStr =  new String[][]{};
    //SPubCallSvrImpl callView = new SPubCallSvrImpl();
%>

<%
	/*
	SQL���        sql_content
	ѡ������       sel_type
	����           title
	�ֶ�1����      field_name1
	*/
    	String pageTitle = request.getParameter("pageTitle");
    	String fieldNum = "";
    	String fieldName = request.getParameter("fieldName");
	String idIccid = request.getParameter("iccid");
    	String custId = request.getParameter("cust_id");
    	String unitId = request.getParameter("unit_id");
    	String grpOutNo = request.getParameter("grpOutNo");
    	String sqlFilter = "";


   	 	String selType = request.getParameter("selType");
    		String retQuence = request.getParameter("retQuence");
	    if(selType.compareTo("S") == 0)
	    {   selType = "radio";    }
	    if(selType.compareTo("M") == 0)
	    {   selType = "checkbox";   }
	    if(selType.compareTo("N") == 0)
	    {   selType = "";   }
   
	    int chPos = 0;
	    String typeStr = "";
	    String inputStr = "";
	    String valueStr = "";
%>

<HTML>
	<HEAD>
	<TITLE>������BOSS-���ſͻ���ѯ</TITLE>
	<SCRIPT type=text/javascript>
		function saveTo()
		{
		      var rIndex;        //ѡ�������
		      var retValue = ""; //����ֵ
		      var chPos;         //�ַ�λ��
		      var obj;
		      var fieldNo;        //���������к�
		      var retFieldNum = document.fPubSimpSel.retFieldNum.value;
		      var retQuence = document.fPubSimpSel.retQuence.value;  //�����ֶ��������
		      var retNum = retQuence.substring(0,retQuence.indexOf("|"));
		      retQuence = retQuence.substring(retQuence.indexOf("|")+1);
		      var tempQuence;
		      if(retFieldNum == "")
		      {     return false;   }
		       //���ص�����¼
		          for(i=0;i<document.fPubSimpSel.elements.length;i++)
		          {
		                  if (document.fPubSimpSel.elements[i].name=="List")
		                  {    //�ж��Ƿ��ǵ�ѡ��ѡ��
		                       if (document.fPubSimpSel.elements[i].checked==true)
		                       {     //�ж��Ƿ�ѡ��
		                             //alert(document.fPubSimpSel.elements[i].value);
		                             rIndex = document.fPubSimpSel.elements[i].RIndex;
		                             tempQuence = retQuence;
		                             for(n=0;n<retNum;n++)
		                             {
		                                chPos = tempQuence.indexOf("|");
		                                fieldNo = tempQuence.substring(0,chPos);
		                                //alert(fieldNo);
		                                obj = "Rinput" + rIndex + fieldNo;
		                                //alert(obj);
		                                retValue = retValue + document.all(obj).value + "|";
		                                tempQuence = tempQuence.substring(chPos + 1);
		                             }
		                             //alert(retValue);
		                             window.returnValue= retValue;
		                       }
		                }
		            }
		        if(retValue =="")
		        {
		            rdShowMessageDialog("��ѡ����Ϣ�",0);
		            return false;
		        }
		        opener.getvaluecust(retValue);
		        window.close();
		}
		
		function allChoose()
		{   //��ѡ��ȫ��ѡ��
		    for(i=0;i<document.fPubSimpSel.elements.length;i++)
		    {
		        if(document.fPubSimpSel.elements[i].type=="checkbox")
		        {    //�ж��Ƿ��ǵ�ѡ��ѡ��
		            document.fPubSimpSel.elements[i].checked = true;
		        }
		    }
		}
		
		function cancelChoose()
		{   //ȡ����ѡ��ȫ��ѡ��
		    for(i=0;i<document.fPubSimpSel.elements.length;i++)
		    {
		        if(document.fPubSimpSel.elements[i].type =="checkbox")
		        {    //�ж��Ƿ��ǵ�ѡ��ѡ��
		            document.fPubSimpSel.elements[i].checked = false;
		        }
		    }
		}
	</SCRIPT>	
</HEAD>

<BODY>
	<FORM method=post name="fPubSimpSel">
	<%@ include file="/npage/include/header_pop.jsp" %> 
	<div class="title">
			<div id="title_zi">���ſͻ���ѯ </div>
	</div>	
  	<table cellspacing="0">
    		<tr>
    			<Th>֤������</Th>
				<Th>���ſͻ�ID</Th>
				<Th>���Ų�ƷID</Th>
				<Th>�����û�����</Th>
				<Th>���ű���</Th>
				<Th>���Ų�Ʒ����</Th>
				<Th>��������</TD></Th>
	<%  		//���ƽ����ͷ
		     chPos = fieldName.indexOf("|");
		     out.print("");
		     String titleStr = "";
		     int tempNum = 0;
		     while(chPos != -1)
		     {
		        valueStr = fieldName.substring(0,chPos);
		        titleStr = "";
		        out.print(titleStr);
		        fieldName = fieldName.substring(chPos + 1);
		        tempNum = tempNum +1;
		        chPos = fieldName.indexOf("|");
		     }
		     out.print("");
		     fieldNum = String.valueOf(tempNum+1);
	%>

<%
    //���ݴ��˵�Sql��ѯ���ݿ⣬�õ����ؽ��
    
           // retArray = callView.sPubSelect(fieldNum,sqlStr1);
           // retArray1 = callView.sPubSelect("1",sqlStr);
           System.out.println("===================");
            
 %>
 	<wtc:service name="s4112Init" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode1" retmsg="retMsg1" outnum="8">
        <wtc:param value="<%=idIccid%>"/>
        <wtc:param value="<%=custId%>"/>
        <wtc:param value="<%=unitId%>"/>
        <wtc:param value="<%=grpOutNo%>"/>
        <wtc:param value="<%=regionCode%>"/>
	</wtc:service>
	<wtc:array id="result" scope="end" />
 <%
            int recordNum =0;
            if("000000".equals(retCode1)){
            	recordNum=result.length;
            }
            for(int i=0;i<recordNum;i++)
            {
            	if(result!=null&&result.length>0){
                typeStr = "";
                inputStr = "";
                out.print("<TR>");
                for(int j=0;j<Integer.parseInt(fieldNum)-1;j++)
                {
                    if(j==0)
                    {
                        typeStr = "<TD>&nbsp;";
                        if(selType.compareTo("") != 0)
                        {
                            typeStr = typeStr + "<input type='" + selType +
                                "' name='List' style='cursor:hand' RIndex='" + i + "'" +
                                "onkeydown='if(event.keyCode==13)saveTo();'" + ">";
                        }
                        typeStr = typeStr + (result[i][j]).trim() + "<input type='hidden' " +
                            " id='Rinput" + i + j + "'  value='" +
                            (result[i][j]).trim() + "'readonly></TD>";
                            
                    }else if(j==7){
                      if(result[i][j]!=null){
                         inputStr = inputStr + "<TD style='display:none'>&nbsp;" + (result[i][j]).trim() + "<input type='hidden' " +
                        " id='Rinput" + i + j + "'  value='" +
                        (result[i][j]).trim() + "'readonly></TD>";
                      }else{
                        inputStr = inputStr + "<TD style='display:none'>&nbsp;" + "dd" + "<input type='hidden' " +
                        " id='Rinput" + i + j + "'  value='" +
                        "" + "'readonly></TD>";
                      }
                    }
                    else
                    {
                      if(result[i][j]!=null){
                         inputStr = inputStr + "<TD>&nbsp;" + (result[i][j]).trim() + "<input type='hidden' " +
                            " id='Rinput" + i + j + "'  value='" +
                            (result[i][j]).trim() + "'readonly></TD>";
                      }else{
                        inputStr = inputStr + "<TD>&nbsp;" + "" + "<input type='hidden' " +
                            " id='Rinput" + i + j + "'  value='" +
                            ""+ "'readonly></TD>";
                      }
                    }
                }
                out.print(typeStr + inputStr);
                out.print("</TR>");
                }
            }
        
        
%>
<%


%>
   	</tr>
 </table>

 <TABLE  cellspacing="0">    
        <TR>
            <TD id="footer">
	<%
	    if(selType.compareTo("checkbox") == 0)
	    {
	        out.print("<input  name=allchoose onClick='allChoose()' style='cursor:hand' class=b_foot type=button value=ȫѡ>&nbsp");
	        out.print("<input  name=cancelAll onClick='cancelChoose()' style='cursor:hand' class=b_foot type=button value=ȡ��ȫѡ>&nbsp");
	    }
	%>

<%
                if(selType.compareTo("") != 0){%>
                <input  name=commit onClick="saveTo()" style="cursor:hand" class="b_foot" type=button value=ȷ��>&nbsp;
<%
  		}
%>
                <input  name=back onClick="window.close()" class="b_foot" style="cursor:hand" class="" type=button value=����>&nbsp;
            </TD>
        </TR>   
</TABLE>
  <input type="hidden" name="retFieldNum" value=<%=fieldNum%>>
  <input type="hidden" name="retQuence" value=<%=retQuence%>>
  <%@ include file="/npage/include/footer_pop.jsp" %> 
</FORM>
</BODY>
</HTML>