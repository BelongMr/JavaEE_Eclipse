<%
/********************
 version v2.0
 开发商: si-tech
 update hejw@2009-1-14
********************/
%>
<%
  String opCode = "6727";
  String opName = "集团彩铃删除成员";
%>

<%request.setCharacterEncoding("GB2312");%>
<%@ page contentType="text/html;charset=Gb2312"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.sitech.boss.util.page.*"%>


<%
    //得到输入参数
    String[][] result = new String[][]{};
    String[][] allNumStr =  new String[][]{};
    
    String regionCode = (String)session.getAttribute("regCode");
%>

<%
/*
SQL语句        sql_content
选择类型       sel_type
标题           title
字段1名称      field_name1
*/
    String pageTitle = request.getParameter("pageTitle");
    String fieldNum = "";
    String fieldName = request.getParameter("fieldName");
	  String idIccid = request.getParameter("idIccid");
    String custId = request.getParameter("custId");
    String unitId = request.getParameter("unitId");
    String grpOutNo = request.getParameter("grpOutNo");
    String sqlFilter = "";

    int iPageNumber = request.getParameter("pageNumber")==null?1:Integer.parseInt(request.getParameter("pageNumber"));
    int iPageSize = 25;
    int iStartPos = (iPageNumber-1)*iPageSize;
    int iEndPos = iPageNumber*iPageSize;
    if (idIccid != null && idIccid.trim().length() > 0)
    {
        sqlFilter = sqlFilter + " and a.id_iccid = '" + idIccid + "'";
    }
    if (custId != null && custId.trim().length() > 0)
    {
        sqlFilter = sqlFilter + " and a.cust_id = " + custId + " and b.cust_id = " + custId + " and c.cust_id = " + custId;
    }
    if (unitId != null && unitId.trim().length() > 0)
    {
        sqlFilter = sqlFilter + " and b.unit_id = " + unitId;
    }
    if (grpOutNo != null && grpOutNo.trim().length() > 0)
    {
        sqlFilter = sqlFilter + " and e.service_no = '" + grpOutNo + "'"; 
    }

    String sqlStr = "SELECT nvl(count(*),0) num FROM dcustdoc a, dcustdocorgadd b, dgrpusermsg c, sproductcode d, dAccountIdInfo e,ssmproduct f,ssmcode g WHERE c.run_code='A' AND c.product_code = d.product_code AND a.cust_id = b.cust_id AND b.cust_id = c.cust_id AND d.product_level = 1 AND d.product_status = 'Y' AND c.bill_date > Last_Day(sysdate) + 1 and Trim(c.user_no) = Trim(e.msisdn) and g.region_code=a.region_Code and f.product_code=d.product_code and f.sm_code=g.sm_code and c.sm_code !='pe' and c.sm_code ='CR'  " + sqlFilter ;

    String sqlStr1 = "select * from (SELECT a.id_iccid, a.cust_id,c.id_no, Trim(e.service_no), b.unit_id,g.sm_name,b.unit_name,g.sm_code,rownum id FROM dcustdoc a, dcustdocorgadd b, dgrpusermsg c, sproductcode d, dAccountIdInfo e,ssmproduct f,ssmcode g WHERE c.run_code='A' AND c.product_code = d.product_code AND a.cust_id = b.cust_id AND b.cust_id = c.cust_id AND d.product_level = 1 AND d.product_status = 'Y' AND c.bill_date > Last_Day(sysdate) + 1 and Trim(c.user_no) = Trim(e.msisdn) and g.region_code=a.region_Code and f.product_code=d.product_code and f.sm_code=g.sm_code and c.sm_code !='pe' and c.sm_code ='CR' " + sqlFilter + " ) where id <"+iEndPos+" and id>="+iStartPos;

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
<TITLE>黑龙江BOSS-集团客户查询</TITLE>
</HEAD>
<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>
<BODY bgColor=#FFFFFF leftmargin="0" topmargin="0">

<SCRIPT type=text/javascript>
function saveTo()
{
      var rIndex;        //选择框索引
      var retValue = ""; //返回值
      var chPos;         //字符位置
      var obj;
      var fieldNo;        //返回域序列号
      var retFieldNum = document.fPubSimpSel.retFieldNum.value;
      var retQuence = document.fPubSimpSel.retQuence.value;  //返回字段域的序列
      var retNum = retQuence.substring(0,retQuence.indexOf("|"));
      retQuence = retQuence.substring(retQuence.indexOf("|")+1);
      var tempQuence;
      if(retFieldNum == "")
      {     return false;   }
       //返回单条记录
          for(i=0;i<document.fPubSimpSel.elements.length;i++)
          {
                  if (document.fPubSimpSel.elements[i].name=="List")
                  {    //判断是否是单选或复选框
                       if (document.fPubSimpSel.elements[i].checked==true)
                       {     //判断是否被选中
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
            rdShowMessageDialog("请选择信息项！",0);
            return false;
        }
        opener.getvaluecust(retValue);
        window.close();
}

function allChoose()
{   //复选框全部选中
    for(i=0;i<document.fPubSimpSel.elements.length;i++)
    {
        if(document.fPubSimpSel.elements[i].type=="checkbox")
        {    //判断是否是单选或复选框
            document.fPubSimpSel.elements[i].checked = true;
        }
    }
}

function cancelChoose()
{   //取消复选框全部选中
    for(i=0;i<document.fPubSimpSel.elements.length;i++)
    {
        if(document.fPubSimpSel.elements[i].type =="checkbox")
        {    //判断是否是单选或复选框
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
		<div id="title_zi">黑龙江BOSS-集团客户查询</div>
	</div>

  <table cellspacing="0">
    <tr>
<TR>
	<th>&nbsp;&nbsp;证件号码</th>
	<th>&nbsp;&nbsp;集团客户ID</th>
	<th>&nbsp;&nbsp;集团产品ID</th>
	<th>&nbsp;&nbsp;集团用户编码</th>
	<th>&nbsp;&nbsp;集团编码</th>
	<th>&nbsp;&nbsp;集团产品名称</th>
	<th>&nbsp;&nbsp;集团名称</th>
	<th>&nbsp;&nbsp;产品代码</th></TR>
		
<%  //绘制界面表头
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
    //根据传人的Sql查询数据库，得到返回结果
    try
    {
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
                        typeStr = "<TD>&nbsp;";
                        if(selType.compareTo("") != 0)
                        {
                            typeStr = typeStr + "<input type='" + selType +
                                "' name='List' style='cursor:hand' RIndex='" + i + "'" +
                                "onkeydown='if(event.keyCode==13)saveTo();'" + ">";
                        }
                        typeStr = typeStr + (result[i][j]).trim() + "<input type='hidden' " +
                            " id='Rinput" + i + j + "' class='button' value='" +
                            (result[i][j]).trim() + "'readonly></TD>";
                    }
                    else
                    {
                        inputStr = inputStr + "<TD>&nbsp;" + (result[i][j]).trim() + "<input type='hidden' " +
                            " id='Rinput" + i + j + "' class='button' value='" +
                            (result[i][j]).trim() + "'readonly></TD>";
                    }
                }
                out.print(typeStr + inputStr);
                out.print("</TR>");
            }
        }
        catch(Exception e)
        {
        	System.out.println(e.toString());

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
            <TD align=center>
<%
    if(selType.compareTo("checkbox") == 0)
    {
        out.print("<input  name=allchoose onClick='allChoose()' style='cursor:hand' type=button value=全选>&nbsp");
        out.print("<input  name=cancelAll onClick='cancelChoose()' style='cursor:hand' type=button value=取消全选>&nbsp");
    }
%>

<%
                if(selType.compareTo("") != 0)
                {
%>
                <input class="b_foot" name=commit onClick="saveTo()" style="cursor:hand" type=button value=确认>&nbsp;
<%
                }
%>
                <input class="b_foot" name=back onClick="window.close()" style="cursor:hand" type=button value=返回>&nbsp;
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
