 <%
	/********************
	 version v2.0
	开发商: si-tech
	update:anln@2009-01-16 页面改造,修改样式
	********************/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="com.sitech.boss.util.page.*"%>
<%@ include file="/npage/include/public_title_name.jsp" %>

<%
	    //得到输入参数
	   
	    //String[][] result = new String[][]{};
	   //String[][] allNumStr =  new String[][]{};	   
	    
	    String regionCode = (String)session.getAttribute("regCode");	   
	    String opCode = "3709";	
	    String opName = "黑龙江BOSS-集团客户查询";
%>

<%
	/*
	SQL语句        sql_content
	选择类型       sel_type
	标题           title
	字段1名称      field_name1
	*/  
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
    
    /* baixf modify 20080531 将证件号码模糊匹配改为精确匹配   */
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

    
    String sqlStr = "SELECT nvl(count(*),0) num FROM dcustdoc a, dcustdocorgadd b, dgrpusermsg c, sproductcode d, dAccountIdInfo e,ssmproduct f,ssmcode g,sGrpAllowAddMebCfg h WHERE c.run_code='A' AND c.product_code = d.product_code AND a.cust_id = b.cust_id AND b.cust_id = c.cust_id AND d.product_level = 1 AND d.product_status = 'Y' AND c.bill_date > Last_Day(sysdate) + 1 and Trim(c.user_no) = Trim(e.msisdn) and g.region_code=a.region_Code and f.product_code=d.product_code and f.sm_code=g.sm_code and c.sm_code !='pe' and g.sm_code=h.sm_code and h.op_code='3709' and d.product_attr!='ADC22222' " + sqlFilter ;
    String sqlStr1 = "select * from (SELECT a.id_iccid, a.cust_id,c.id_no, d.product_name, b.unit_id,b.unit_name,d.product_code,c.user_no,c.ACCOUNT_ID,c.sm_code,rownum id FROM dcustdoc a, dcustdocorgadd b, dgrpusermsg c, sproductcode d, dAccountIdInfo e,ssmproduct f,ssmcode g,sGrpAllowAddMebCfg h WHERE c.run_code='A' AND c.product_code = d.product_code AND a.cust_id = b.cust_id AND b.cust_id = c.cust_id AND d.product_level = 1 AND d.product_status = 'Y' AND c.bill_date > Last_Day(sysdate) + 1 and Trim(c.user_no) = Trim(e.msisdn) and g.region_code=a.region_Code and f.product_code=d.product_code and f.sm_code=g.sm_code and c.sm_code !='pe' and c.sm_code!='YM' and g.sm_code=h.sm_code   and h.op_code='3709' and d.product_attr!='ADC22222' " + sqlFilter + " ) where id <"+iEndPos+" and id>="+iStartPos;
    
  
    String selType = request.getParameter("selType");
    String retQuence = request.getParameter("retQuence");
    
    System.out.println(sqlStr1);
    
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
		<TITLE>黑龙江BOSS-集团客户查询</TITLE>
	</HEAD>
	<BODY>
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
	<link href="<%=request.getContextPath()%>/css/jl.css" rel="stylesheet" type="text/css">
</HEAD>
<BODY>
	<FORM method=post name="fPubSimpSel">	
     	 	<%@ include file="/npage/include/header_pop.jsp" %>
		<div class="title">
			<div id="title_zi">集团客户查询</div>
		</div>	

  		<table  cellspacing="0">
  			<TBODY>    		
				<TR>
					<Th>&nbsp;&nbsp;证件号码</Th>
					<Th>&nbsp;&nbsp;集团用户编码</Th>
					<Th>&nbsp;&nbsp;集团编码</Th>
					<Th>&nbsp;&nbsp;集团产品名称</Th>
					<Th>&nbsp;&nbsp;集团名称</Th>
					<Th>&nbsp;&nbsp;产品代码</Th>
					<Th>&nbsp;&nbsp;产品号码</Th>
					<Th>&nbsp;&nbsp;产品帐号</Th>
					<Th>&nbsp;&nbsp;产品品牌</Th>
				</TR>
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
		   
		    //retArray = callView.sPubSelect(fieldNum,sqlStr1);
		    // retArray1 = callView.sPubSelect("1",sqlStr);
		      %>
		     	<wtc:pubselect name="sPubSelect" outnum="<%=fieldNum%>" retmsg="msg1" retcode="code1" routerKey="region" routerValue="<%=regionCode%>">
  	 			<wtc:sql><%=sqlStr1%></wtc:sql>
 	  		</wtc:pubselect>
	  		<wtc:array id="result" scope="end"/>		      	
		      
		      	<wtc:pubselect name="sPubSelect" outnum="1" retmsg="msg2" retcode="code2" routerKey="region" routerValue="<%=regionCode%>">
  	 			<wtc:sql><%=sqlStr%></wtc:sql>
 	 		 </wtc:pubselect>
	  		<wtc:array id="allNumStr" scope="end"/>

		      <%
		      	System.out.println("==================="+result.length);
		           
		            //result = (String[][])retArray.get(0);
		            //allNumStr = (String[][])retArray1.get(0);
		            int recordNum = Integer.parseInt(allNumStr[0][0].trim());		            
		            System.out.println("allNumStr[0][0].trim()="+allNumStr[0][0].trim());
		            System.out.println("recordNum="+recordNum);
		            
		            for(int i=0;i<result.length;i++)
		            {
		                typeStr = "";
		                inputStr = "";
		                out.print("<TR bgcolor='#EEEEEE'>");
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
		                            " id='Rinput" + i + j + "' class='InputGray' value='" +
		                            (result[i][j]).trim() + "'readonly></TD>";
		                    }else if (j == (Integer.parseInt(fieldNum) - 7))
		                	{
		          		        inputStr = inputStr + "" + "<input type='hidden' " +
		          		            " id='Rinput" + i + j + "' class='InputGray' value='" + 
		          		            (result[i][j]).trim() + "'readonly>";          		            
		                	}
		                    else
		                    {
		                        inputStr = inputStr + "<TD>&nbsp;" + (result[i][j]).trim() + "<input type='hidden' " +
		                            " id='Rinput" + i + j + "' class='InputGray' value='" +
		                            (result[i][j]).trim() + "'readonly></TD>";
		                    }
		                }
		                out.print(typeStr + inputStr);
		                out.print("</TR>");
		            }
		        		      
		%>
		</TBODY>		
		  </table>
		<%
				
		    int iQuantity = Integer.parseInt(allNumStr[0][0].trim());
		    //int iQuantity = 500;
		    Page pg = new Page(iPageNumber,iPageSize,iQuantity);
		    PageView view = new PageView(request,out,pg);
		    view.setVisible(true,true,0,0);
		    
		%>

<!------------------------------------------------------>
    <TABLE cellSpacing="0">
    	<TBODY>
        	<TR>
            		<TD id="footer" >
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
  <input type="hidden" name="retFieldNum" value=<%=fieldNum%>>
  <input type="hidden" name="retQuence" value=<%=retQuence%>> 
  <%@ include file="/npage/include/footer_pop.jsp" %> 
</FORM>
</BODY>
</HTML>
