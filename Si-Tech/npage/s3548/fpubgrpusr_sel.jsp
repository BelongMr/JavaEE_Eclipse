   
<%
/********************
 version v2.0
 ������ si-tech
 update hejw@2009-2-11
********************/
%>
              
<%
  String opCode = "3548";
  String opName = "�ǹ�ͨ��Ա����";
%>              

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http//www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http//www.w3.org/1999/xhtml">
	
<%@ include file="/npage/include/public_title_name.jsp" %> 
<%request.setCharacterEncoding("GB2312");%>
<%@ page contentType="text/html;charset=Gb2312"%>
<%@ page import="com.sitech.boss.util.page.*"%>
<%
    //�õ��������
    String return_code,return_message;
    String[][] result = new String[][]{};
    String[][] allNumStr =  new String[][]{};
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
		String iccid = request.getParameter("iccid");
    String cust_id = request.getParameter("cust_id");
    String unit_id = request.getParameter("unit_id");
    String user_no = request.getParameter("user_no");
    String busi_type = request.getParameter("busi_type");
    String sqlFilter = "";
		String regionCode = (String)session.getAttribute("regCode");
    int iPageNumber = request.getParameter("pageNumber")==null?1:Integer.parseInt(request.getParameter("pageNumber"));
    int iPageSize = 25;
    int iStartPos = (iPageNumber-1)*iPageSize;
    int iEndPos = iPageNumber*iPageSize;

    if (iccid != null)
    {
	    if (iccid.trim().length() > 0) 
	    {
	        sqlFilter = sqlFilter + " and a.id_iccid = '" + iccid + "'";
	    }
	}    
    if (cust_id != null)
    {
	    if (cust_id.trim().length() > 0) 
	    {
	        sqlFilter = sqlFilter + " and a.cust_id = " + cust_id + " and b.cust_id = " + cust_id + " and c.cust_id = " + cust_id;
	    }
    }
    if (unit_id != null)
    {
	    if (unit_id.trim().length() > 0) 
	    {
	        sqlFilter = sqlFilter + " and b.unit_id = " + unit_id;
	    }
    }
    if (user_no != null)
    {
	    if (user_no.trim().length() > 0) 
	    {
	        sqlFilter = sqlFilter + " and e.service_type = c.sm_code and e.service_no = '" + user_no + "'";
	    }
    }
    if (busi_type != null)
    {
	    if (user_no.trim().length() > 0) 
	    {
	        sqlFilter = sqlFilter + " and f.busi_type = '" + busi_type + "'";
	    }
    }
	sqlFilter=sqlFilter + " order by a.id_iccid,a.cust_id,b.unit_name";
    String sqlStr =  "SELECT nvl(count(*),0) num"
    				+"  FROM dcustdoc a, dcustdocorgadd b, dgrpusermsg c, sproductcode d, "
    				+"			dAccountIdInfo e, sBusiTypeSmCode f"
    				+" WHERE c.product_code = d.product_code"
    				+"   AND a.cust_id = b.cust_id"
    				+"   AND b.cust_id = c.cust_id"
    				+"   AND c.run_code = 'A'"
    				+"   AND d.product_level = 1"
    				+"   AND d.product_status = 'Y'"
    				+"   AND c.bill_date > Last_Day(sysdate) + 1"
    				+"   and c.user_no = e.msisdn  "
    				+"   and c.sm_code = f.sm_code and c.sm_code = 'CG' "
    				+ sqlFilter;

    String sqlStr1 = "select * from ("
    				+"SELECT a.id_iccid, a.cust_id, TRIM (b.unit_name), c.id_no, Trim(e.service_no),"
    				+"       c.product_code, d.product_name, b.unit_id,"
    				+"       c.account_id,c.sm_code, g.sm_name"
    				+"  FROM dcustdoc a, dcustdocorgadd b, dgrpusermsg c, sproductcode d, "
    				+"			dAccountIdInfo e, sBusiTypeSmCode f, sSmCode g"
    				+" WHERE c.product_code = d.product_code"
    				+"   AND a.cust_id = b.cust_id"
    				+"   AND b.cust_id = c.cust_id"
    				+"   AND c.run_code = 'A'"
    				+"   AND d.product_level = 1"
    				+"   AND d.product_status = 'Y'"
    				+"   AND c.bill_date > Last_Day(sysdate) + 1"
    				+"   and c.user_no = e.msisdn"
    				+"   and c.sm_code = f.sm_code and c.sm_code = 'CG' "
    				+"   and c.region_code = g.region_code"
    				+"   and c.sm_code = g.sm_code"
    				+ sqlFilter
    				+ " )-- where rowid <"+iEndPos+" and rowid>="+iStartPos;

	System.out.println("!!!!!!!!!!!!!!!!!!!!!!!sqlStr1="+sqlStr1);
    String selType = request.getParameter("selType");
    String retQuence = request.getParameter("retQuence");
    //System.out.print("sqlStr="+sqlStr);
    if(selType.compareTo("S") == 0)
    {   selType = "radio";    }
    if(selType.compareTo("M") == 0)
    {   selType = "checkbox";   }
    if(selType.compareTo("N") == 0)
    {   selType = "";   }
    //=====================
    int chPos = 0;
    String typeStr = "";
    String inputStr = "";
    String valueStr = "";
%>

<HTML><HEAD>
<TITLE>���ſͻ���ѯ</TITLE>
</HEAD>
<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>
<BODY >

<SCRIPT type=text/javascript>
function saveTo()
{
      var rIndex;        //ѡ�������
      var retValue = ""; //����ֵ
      var chPos;         //�ַ�λ��
      var obj;
      var fieldNo;        //���������к�
      var retFieldNum = document.fPubSimpSel.retFieldNum.value;
	  //alert(retFieldNum);
      var retQuence = document.fPubSimpSel.retQuence.value;  //�����ֶ��������

      var retNum = retQuence.substring(0,retQuence.indexOf("|"));

      retQuence = retQuence.substring(retQuence.indexOf("|")+1);
//      alert(retQuence);
      var tempQuence;
      if(retFieldNum == "")
      {     return false;   }
       //���ص�����¼retValue
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
                                 obj = "Rinput" + rIndex+"a"+ fieldNo;
                                								
                                retValue = retValue + document.all(obj).value + "|";
						        tempQuence = tempQuence.substring(chPos + 1);
                             }
                             //alert(retValue);
                             //alert(retNum);
                             window.returnValue= retValue;
                       }
                }
            }
        if(retValue =="")
        {
            rdShowMessageDialog("��ѡ����Ϣ�",0);
            return false;
        }
        
        //alert(retValue);
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

<!--**************************************************************************************-->
</HEAD>
<BODY>
<FORM method=post name="fPubSimpSel">
	<%@ include file="/npage/include/header_pop.jsp" %>                         


	<div class="title">
		<div id="title_zi">���ſͻ���ѯ</div>
	</div>
 
  <table  cellspacing="0">
    <tr>
<TR  height=25>
<%  //���ƽ����ͷ
     chPos = fieldName.indexOf("|");
     //out.print("");
     String titleStr = "";
     int tempNum = 0;
     while(chPos != -1)
     {
        valueStr = fieldName.substring(0,chPos);
        //titleStr = "";
        out.print("<Th align=center>" + valueStr + "</Th>");
        fieldName = fieldName.substring(chPos + 1);
        tempNum = tempNum +1;
        chPos = fieldName.indexOf("|");
     }
     out.print("");
     fieldNum = String.valueOf(tempNum+1);
%>
</TR>

<%
    //���ݴ��˵�Sql��ѯ���ݿ⣬�õ����ؽ��
    try
    {
            //retArray = callView.sPubSelect(fieldNum,sqlStr1);
            //retArray1 = callView.sPubSelect("1",sqlStr);
            
            %>
            
    <wtc:pubselect name="sPubSelect" outnum="1" retmsg="msg2" retcode="code2" routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=sqlStr%></wtc:sql>
 	  </wtc:pubselect>
	  <wtc:array id="allNumStr_t" scope="end"/>


		<wtc:pubselect name="sPubSelect" outnum="<%=fieldNum%>" retmsg="msg2" retcode="code2" routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=sqlStr1%></wtc:sql>
 	  </wtc:pubselect>
	  <wtc:array id="result_t" scope="end"/>        
            
            
            <%
            result = result_t;
            allNumStr = allNumStr_t;
            int recordNum = Integer.parseInt(allNumStr[0][0].trim());
            for(int i=0;i<recordNum;i++)
            {
                typeStr = "";
                inputStr = "";
                out.print("<TR>");
                for(int j=0;j<Integer.parseInt(fieldNum)-1;j++)
                {
 
                    if(j==0)
                    {
                        typeStr = "<TD align=center>&nbsp;";
                        if(selType.compareTo("") != 0)
                        {
                            typeStr = typeStr + "<input type='" + selType +
                                "' name='List' style='cursor:hand' RIndex='" + i + "'" +
                                "onkeydown='if(event.keyCode==13)saveTo();'" + ">";
                        }
                        typeStr = typeStr + (result[i][j]).trim() + "<input type='hidden' " +
                            " id='Rinput" + i+"a"+j + "'   value='" +
                            (result[i][j]).trim() + "'   readonly></TD>";
                    }
                    else
                    {
                        inputStr = inputStr + "<TD align=center>&nbsp;" + (result[i][j]).trim() + "<input type='hidden' " +
                            " id='Rinput" + i+"a"+j + "'  value='" +
                            (result[i][j]).trim() + "'   readonly></TD>";
                    }
                }
                out.print(typeStr + inputStr);
                out.print("</TR>");
            }
        }catch(Exception e){

        }
%>
<%


%>
   </tr>
  </table>
<%
    int iQuantity = Integer.parseInt(allNumStr[0][0].trim());
    //int iQuantity = 500;
    Page pg = new Page(iPageNumber,iPageSize,iQuantity);
    PageView view = new PageView(request,out,pg);
%>
		<div style="position:relative;font-size:12px" align="center">
<%
    view.setVisible(true,true,0,0);      
%>
		</div>
<!------------------------------------------------------>
    <TABLE cellSpacing="0">
    <TBODY>
        <TR>
            <TD align=center id="footer">
<%
    if(selType.compareTo("checkbox") == 0)
    {
        out.print("<input  name=allchoose onClick='allChoose()' style='cursor:hand' type=button value=ȫѡ>&nbsp");
        out.print("<input  name=cancelAll onClick='cancelChoose()' style='cursor:hand' type=button value=ȡ��ȫѡ>&nbsp");
    }
%>

<%
                if(selType.compareTo("") != 0)
                {
%>
                <input class="b_foot" name=commit onClick="saveTo()" style="cursor:hand" type=button value=ȷ��>&nbsp;
<%
                }
%>
                <input class="b_foot" name=back onClick="window.close()" style="cursor:hand" type=button value=����>&nbsp;
            </TD>
        </TR>
    </TBODY>
    </TABLE>
 
  <!------------------------>
  <input type="hidden" name="retFieldNum" value=<%=fieldNum%>>
  <input type="hidden" name="retQuence" value=<%=retQuence%>>
  <!------------------------>
  <%@ include file="/npage/include/footer_pop.jsp" %>
</FORM>
</BODY></HTML>