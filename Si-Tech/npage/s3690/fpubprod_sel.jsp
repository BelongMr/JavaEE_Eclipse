<%
/********************
 * version v2.0
 * ������: si-tech
 * update by qidp @ 2009-01-14
 ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%request.setCharacterEncoding("GBK");%>
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>

<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="com.sitech.boss.util.page.*"%>
<%@ page import="com.sitech.boss.pub.*" %>
<%@ page import="com.sitech.boss.pub.config.*" %>
<%@ page import="com.sitech.boss.pub.conn.*" %>
<%@ page import="com.sitech.boss.pub.exception.*" %>
<%@ page import="com.sitech.boss.pub.util.*" %>
<%@ page import="com.sitech.boss.pub.wtc.*" %>

<%@ page import="java.util.ArrayList" %>

<%
    String opName = "���Ų�Ʒ��ѯ";
    //�õ��������
    ArrayList retArray = new ArrayList();
    String return_code,return_message;
    String[][] result = new String[][]{};
	String[][] allNumStr =  new String[][]{};
    String[] paramsIn = null;

    //SPubCallSvrImpl callView = new SPubCallSvrImpl();
    Logger logger = Logger.getLogger("fpubprod_sel.jsp");
    String [] paraIn = new String[2];
%> 	

<%
/*
SQL���        sql_content
ѡ������       sel_type   
����           title      
�ֶ�1����      field_name1
*/

    /*�õ�����Ա�Ĺ��ź�����*/

    String workno = (String)session.getAttribute("workNo");
    String nopass  = (String)session.getAttribute("password");
    String powerRight = ((String)session.getAttribute("powerRight")).trim();
    String orgCode = (String)session.getAttribute("orgCode");
    String regionCode = orgCode.substring(0,2);
    //String group_id = baseInfo[0][21];
    //String province_run = baseInfo[0][22];
    //String org_id = baseInfo[0][23];
    String op_code = request.getParameter("op_code");
    String sm_code = request.getParameter("sm_code");
    String product_attr = request.getParameter("product_attr");

	String group_id = "";
    String org_id = "";
    
	String sqlStr = "";
	//ȡ����ʡ�ݴ��� -- Ϊ�������ӣ�ɽ������ʹ��session
	//String[][] result2  = null;
	sqlStr = "select agent_prov_code FROM sProvinceCode where run_flag='Y'";
	//result2 = (String[][])callView.sPubSelect("1",sqlStr).get(0);
	%>
	<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode1" retmsg="retMsg1"  outnum="1">
    	<wtc:sql><%=sqlStr%></wtc:sql>
    </wtc:pubselect>
    <wtc:array id="result2" scope="end" />
	<%
	String province_run = "";
	if (result2 != null && result2.length != 0) 
	{
		province_run = result2[0][0];
	}
	
    
    String class_code = "";
    int recordNum = 0;
    try
    {
        if(province_run.equals("20"))   //����
        {
        	sqlStr = "select '9999999', a.group_id, nvl(b.innet_type,'99') "
        	        +"  from dLoginMsg a, sTownCode b "
        	        +" where a.login_no =:workno "
        	        +"   and substr(a.org_code,1,2) = b.region_code(+)"
        	        +"   and substr(a.org_code,3,2) = b.district_code(+)"
        	        +"   and substr(a.org_code,5,3) = b.town_code(+)";
        }
        else
        {
        	sqlStr = "select org_id, a.group_id, nvl(b.innet_type,'99') from dLoginMsg a, sTownCode b where a.login_no =:workno and a.group_id = b.group_id(+)";
        }
        System.out.print("sqlStr:"+sqlStr);
        //retArray = callView.sPubSelect("3",sqlStr);
        
        paraIn[0] = sqlStr;    
        paraIn[1]="workno="+workno;
%>
        <wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode2" retmsg="retMsg2" outnum="3" >
        	<wtc:param value="<%=paraIn[0]%>"/>
        	<wtc:param value="<%=paraIn[1]%>"/> 
        </wtc:service>
        <wtc:array id="retArr2" scope="end"/>
<%

        //System.out.print("retArray:"+retArray);
        //result = (String[][])retArray.get(0);
        if(retCode2.equals("000000")){
            result = retArr2;
        }
        if (result[0][0].trim().length() == 0) {
            throw new Exception("��ѯ����Ա��������Ȩ��ʧ�ܣ�");
        }
        org_id = result[0][0];
        group_id = result[0][1];
        class_code = result[0][2];
    }
    catch(Exception e){
        logger.error("��ѯsSmSelPAttr����!");
    }

    String owner_code = "JT";
    String credit_code = "E";
    String product_level = "1"; //����Ʒ
    String business_code = "0"; //����

    String pageTitle = request.getParameter("pageTitle");
    String fieldNum = "";
    String fieldName = request.getParameter("fieldName");

	int iPageNumber = request.getParameter("pageNumber")==null?1:Integer.parseInt(request.getParameter("pageNumber"));
	int iPageSize = 25;
	int iStartPos = (iPageNumber-1)*iPageSize;
	int iEndPos = iPageNumber*iPageSize;

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

<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>������BOSS-���Ų�Ʒ��ѯ</TITLE>
<META content=no-cache http-equiv=Pragma>
<META content=no-cache http-equiv=Cache-Control>

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
                                                           
        					 window.returnValue= retValue;
                       }
    		    }
    		}		
		if(retValue =="")
		{
		    rdShowMessageDialog("��ѡ����Ϣ�");
		    return false;
		}

	/*if (document.all.("Rinput"+rIndex+"2").value=="Y" && document.all.retValue.value=="")
	{
		rdShowMessageDialog("����¼��������ݣ�",0);
		return false;
	}*/
	
		opener.getvalue(retValue, document.all.retValue.value);
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

//���ù������棬���в�Ʒ��Ϣѡ��
function getInfo_Prod_detail(prodCode)
{
	document.all("prod_" + prodCode).checked=true;
    var pageTitle = "��Ʒ���";
    var fieldName = "��Ʒ����|��Ʒ����|�������|��������|�۸����|�۸�����|�շѷ�ʽ|�շѷ�ʽ����|��ȡ��ʽ|��ȡ��ʽ����|�۸�ֵ|";
	var sqlStr = "";
    var selType = "M";    //'S'��ѡ��'M'��ѡ
    var retQuence = "1|0|";
    var retToField = "prodPriceStr|";

    if(PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,prodCode));
}

function PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField,prodCode)
{
    var path = "fpubprod_detail_sel.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;
	path = path + "&prodCode=" + prodCode;
    retInfo = window.open(path,"","height=450, width=800,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
	return true;
}

function getvalue(retValue)
{
	//alert(retValue);
	document.all.retValue.value=retValue;
	
}

</SCRIPT>

<!--**************************************************************************************-->
</HEAD>
<BODY>
<FORM method=post name="fPubSimpSel">
<%@ include file="/npage/include/header_pop.jsp" %>
<div class="title">
	<div id="title_zi">��ѯ���</div>
</div>
   

  <table cellspacing="0">
<TR align="center">
    <TH>��Ʒ����</TH>
    <TH>��Ʒ����</TH>
    <TH>�Ƿ��������</TH>
    </TR> 
<%  //���ƽ����ͷ  
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
     fieldNum = String.valueOf(tempNum);
%> 

<%
    //���ݴ����Sql��ѯ���ݿ⣬�õ����ؽ��
	try
 	{      	
            paramsIn = new String[14];
            paramsIn[0] = workno;
            paramsIn[1] = nopass;
            paramsIn[2] = sm_code;
            paramsIn[3] = op_code;
            paramsIn[4] = org_id;
            paramsIn[5] = group_id;
            paramsIn[6] = owner_code;
            paramsIn[7] = class_code;
            paramsIn[8] = credit_code;
            paramsIn[9] = powerRight;
            paramsIn[10] = product_level;
            paramsIn[11] = product_attr;
            paramsIn[12] = business_code;
            paramsIn[13] = "";

            //retArray = callView.callFXService("sPubMProdSel", paramsIn, "14", "region", "01");
            %>
            <wtc:service name="sPubMProdSel" routerKey="region" routerValue="<%=regionCode%>" retcode="sPubMProdSelCode" retmsg="sPubMProdSelMsg" outnum="15" >
            	<wtc:param value="<%=paramsIn[0]%>"/>
                <wtc:param value="<%=paramsIn[1]%>"/> 
                <wtc:param value="<%=paramsIn[2]%>"/>
                <wtc:param value="<%=paramsIn[3]%>"/>
                <wtc:param value="<%=paramsIn[4]%>"/>
                
                <wtc:param value="<%=paramsIn[5]%>"/>
                <wtc:param value="<%=paramsIn[6]%>"/>
                <wtc:param value="<%=paramsIn[7]%>"/>
                <wtc:param value="<%=paramsIn[8]%>"/>
                <wtc:param value="<%=paramsIn[9]%>"/>
                
                <wtc:param value="<%=paramsIn[10]%>"/>
                <wtc:param value="<%=paramsIn[11]%>"/>
                <wtc:param value="<%=paramsIn[12]%>"/>
                <wtc:param value="<%=paramsIn[13]%>"/>
            </wtc:service>
            <wtc:array id="sPubMProdSelArr" scope="end"/>
            <%
//callView.printRetValue();
      		//result = (String[][])retArray.get(4);
            //allNumStr = (String[][])retArray.get(0);
            //recordNum = result.length;
            recordNum = sPubMProdSelArr.length;
            System.out.println("recordNum:-------" + recordNum);
System.out.println("fieldNum:" + fieldNum);
      		for(int i=0;(i<recordNum) && (i<iEndPos);i++)
      		{
                if (i < iStartPos) continue;
      		    typeStr = "";
      		    inputStr = "";
      		    out.print("<TR>");
      		    for(int j=0;j<Integer.parseInt(fieldNum);j++)
      		    {
                    if(j==0)
                    {
                        typeStr = "<TD>&nbsp;";
                        if(selType.compareTo("") != 0)
                        {
	                        typeStr = typeStr + "<input type='" + selType +  
	          		            "' name='List' id='prod_"+(sPubMProdSelArr[i][3]).trim()+"' style='cursor:hand' RIndex='" + i + "'" + 
	          		            " onkeydown='if(event.keyCode==13)saveTo();'" + ">"; 
						}	          		            
                        typeStr = typeStr + (sPubMProdSelArr[i][3]).trim() + "<input type='hidden' " +
          		            " id='Rinput" + i + j + "' class='button' value='" + 
          		            (sPubMProdSelArr[i][3]).trim() + "'readonly></TD>";          		            
                    }
                    if(j==1)
                    {        		        
                    	if ((sPubMProdSelArr[i][13]).trim().equals("Y"))
                    		inputStr = inputStr + "<TD>" + (sPubMProdSelArr[i][4]).trim();
                    	else
                    		inputStr = inputStr + "<TD>&nbsp;" + (sPubMProdSelArr[i][4]).trim();
          		        inputStr = inputStr + "<input type='hidden' " +
          		            " id='Rinput" + i + j + "' class='button' value='" + 
          		            (sPubMProdSelArr[i][4]).trim() + "'readonly></TD>";          		            
                    }          		           
                    if(j==2)
                    {        	
                    /************liucm******************/
          		             String[][] favInfo = (String[][])session.getAttribute("favInfo");
          		              int infoLen = favInfo.length;
          		              boolean pwrf = false;
  													String tempStr = "";
  													for(int ll=0;ll<infoLen;ll++)
  													{
    														tempStr = (favInfo[ll][0]).trim();
    														System.out.println(tempStr);
    														if(tempStr.compareTo("a290") == 0)
    														{
      															pwrf = true;
    														}
	
  												}
  												/***********liucm end************/
                       if ((sPubMProdSelArr[i][13]).trim().equals("Y")){
                       if(pwrf){
          		        inputStr = inputStr + "<TD>&nbsp;" + (sPubMProdSelArr[i][13]).trim() + "<input type='hidden' " +
          		            " id='Rinput" + i + j + "' class='button' value='" + 
          		            (sPubMProdSelArr[i][13]).trim() + "'readonly>";
          		          }else{
          		            inputStr = inputStr + "<TD>&nbsp;" + "N" + "<input type='hidden' " +
          		            " id='Rinput" + i + j + "' class='button' value='" + 
          		            "N" + "'readonly>";
          		        	 }
          		        	}
          		        	
          		        	
          		            
          		         	if ((sPubMProdSelArr[i][13]).trim().equals("Y")){
          		         			if(pwrf){
          		         						inputStr += "<a href=# onclick=\"getInfo_Prod_detail('"+(sPubMProdSelArr[i][3]).trim()+"')\">" + "&nbsp;-->&nbsp;������&nbsp;" + "</A>";
          		         						inputStr += "</TD>";
          		        			}
          		        	}
                    }
      		    }
      		    out.print(typeStr + inputStr);
      		    out.print("</TR>");
      		}
     	}catch(Exception e){
     		System.out.println(e.toString());
       		
     	}          
%>
  
   </tr>
  </table>
  <TABLE cellSpacing=0>
    <tr><td>
<%	
//    int iQuantity = allNumStr.length;
    Page pg = new Page(iPageNumber,iPageSize,recordNum);
	PageView view = new PageView(request,out,pg); 
   	view.setVisible(true,true,0,0);       
%>
</td></tr>
</table>
<!------------------------------------------------------>
    <TABLE cellSpacing=0>
        <TR id="footer"> 
            <TD align=center>
<%
    if(selType.compareTo("checkbox") == 0)
    {           
        out.print("<input class='button' name=allchoose onClick='allChoose()' style='cursor:hand' type=button value=ȫѡ>&nbsp");
        out.print("<input class='button' name=cancelAll onClick='cancelChoose()' style='cursor:hand' type=button value=ȡ��ȫѡ>&nbsp");       
    } 
%> 

<%
				if(selType.compareTo("") != 0)
				{
%>              
                <input class="b_foot" name=commit onClick="saveTo()" style="cursor:hand" type=button value=ȷ��>
<%
				}
%>             
                <input class="b_foot" name=back onClick="window.close()" style="cursor:hand" type=button value=����>
            </TD>
        </TR>
    </TABLE>
	
  <!------------------------> 
  <input type="hidden" name="retFieldNum" value=<%=fieldNum%>>
  <input type="hidden" name="retQuence" value=<%=retQuence%>>
  <input type="hidden" name="retValue">   
  <!------------------------>  
<%@ include file="/npage/include/footer_pop.jsp" %>
</FORM>
</BODY></HTML>    