<%
/********************
 version v2.0
 ������ si-tech
 update hejw@2009-2-19
********************/
%>
              
<%
  String opCode = "5238";
  String opName = "���˲�Ʒ����";
%>              

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http//www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http//www.w3.org/1999/xhtml">
<%@ include file="/npage/include/public_title_name.jsp" %> 

<%@ page import="org.apache.log4j.Logger"%>
<%@ page contentType= "text/html;charset=gb2312" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.text.*"%>
<%
	//��ȡ�û�session��Ϣ
		String workNo   = (String)session.getAttribute("workNo");                //����
	String nopass  = (String)session.getAttribute("password");                    	//��½����
	String regionCode = (String)session.getAttribute("regCode");
	//��ȡ����ҳ�õ�����Ϣ
	String login_accept = request.getParameter("login_accept");	
	String mode_code = request.getParameter("mode_code");
	String mode_name = request.getParameter("mode_name");	
	String region_code = request.getParameter("region_code");	
	String trans_type = request.getParameter("trans_type");   					 
%>

<html>
<head>
<base target="_self">
<title>��Ʒ�����������</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script language="JavaScript"> 
//------��ѯ��Ʒ����-------
function queryModeCode()
{
	document.form1.action="f5238_modeTransFrame.jsp";
	document.form1.target="middle";
	document.form1.submit();
}   
//-------�ύѡ��Ĳ�Ʒ����--------
function submitAdd()
{
	document.form1.conmit.disabled=true;
	top.window.document.middle.commit();
}
//--------ȫ��ѡ��---------
function selectAll()
{
	top.window.document.middle.selectAll();
}

//----ȫ��ȡ��------
function selectNone()
{
	top.window.document.middle.selectNone();
}
/**��ѯ�ʻ�����**/
function querySmCode()
{
    var pageTitle = "Ʒ�Ʋ�ѯ";
    var fieldName = "Ʒ�ƴ���|Ʒ������|";
    var sqlStr ="select sm_code,sm_name from sSmCode  where region_code='<%=region_code%>' order by sm_code ";
	
    var selType = "S";    //'S'��ѡ��'M'��ѡ
    var retQuence = "2|0|1|";
    var retToField = "sm_code_new|smNameCond|";
    if(!PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)) return false;

	return true;
}
function PubSimpSel(pageTitle,fieldName,sqlStr,selType,retQuence,retToField)
{
    var path = "<%=request.getContextPath()%>/npage/public/fPubSimpSel.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
    path = path + "&selType=" + selType;  
    retInfo = window.showModalDialog(path);
    if(retInfo ==undefined)      
    { 
		return false;  
	}
    var chPos_field = retToField.indexOf("|");
    var chPos_retStr;
    var valueStr;
    var obj;
    while(chPos_field > -1)
    {
        obj = retToField.substring(0,chPos_field);
        chPos_retInfo = retInfo.indexOf("|");
        valueStr = retInfo.substring(0,chPos_retInfo);
        document.all(obj).value = valueStr;
        retToField = retToField.substring(chPos_field + 1);
        retInfo = retInfo.substring(chPos_retInfo + 1);
        chPos_field = retToField.indexOf("|");
        
    }
	return true;
}
//ѡ���ʷ����ʹ���
function queryModeType()
{
	if(document.all.sm_code_new.value=="")
	{
	    rdShowMessageDialog("����ѡ��Ʒ�ƴ��룡");
		return ;
	}

    var retToField = "modeTypeCond|modeTypeNameCond|";
    var url = "f5238_queryModeType.jsp?clear_mode_use=1&region_code=<%=region_code%>"+"&smCodeCond="+document.all.sm_code_new.value+"&retToField="+retToField;
	window.open(url,'','height=600,width=700,scrollbars=yes');
}
function doReset()
{
    document.form1.sm_code_new.value="";
	document.form1.smNameCond.value="";
	document.form1.mode_code_new.value="";
	document.form1.modeTypeCond.value="";
	document.form1.modeTypeNameCond.value="";
	document.form1.mode_name_new.value="";
	document.form1.whereSql.value="";
	document.form1.defSendFlag.value="";
}
</script>
</head>

<body  onMouseDown="hideEvent()" onKeyDown="hideEvent()">

 
	  <form name="form1"  method="post">
	  		<%@ include file="/npage/include/header_pop.jsp" %>                         


	<div class="title">
		<div id="title_zi">�ò�Ʒ���뵽������Ʒ�����ת����ϵ����</div>
	</div>
	  	<input type="hidden" name="login_accept" value="<%=login_accept%>">
	  	<input type="hidden" name="mode_code" value="<%=mode_code%>">
	  	<input type="hidden" name="mode_name" value="<%=mode_name%>">
	  	<input type="hidden" name="region_code" value="<%=region_code%>">
	  	<input type="hidden" name="select_type" value="1">
	  	<input type="hidden" name="trans_type" value="<%=trans_type%>">
	  		  	<TABLE    id="mainOne"  cellspacing="0">
	  				<tr  height="23">
	  					<TD colspan="4"><font class="orange">��ѡ����Ҫת���Ĳ�Ʒ���룡</font></td>
	  				</tr>
	  				<tr  height="22">
	  					<TD width="16%" class="blue" >ҵ��Ʒ��</TD>
	  					<TD width="34%">
	  						<input type=text  v_type="string" size=8 v_must=0 v_minlength=1 v_maxlength=8 v_name="Ʒ��"  name=sm_code_new maxlength=8 readonly Class="InputGrey" ></input>
							<input type=text  v_type="string"  v_must=0 v_minlength=1 v_maxlength=20 v_name="Ʒ�ƴ���"  name=smNameCond value="" maxlength=20 readonly Class="InputGrey">
		                    <input class="b_text" type="button" name="query_smcode" onclick="querySmCode()" value="ѡ��">
	  					</TD>
						<TD width="16%"  class="blue" >��Ʒ����</TD>
	  					<TD width="34%" >
	  						<input type=text  v_type="string"  v_must=1 v_minlength=1 v_maxlength=8 v_name="��Ʒ����"  name=mode_code_new maxlength=8 ></input>
	  					</TD>						
	  				</tr>
					<tr  height="22">
	  					<TD width="16%" class="blue"  >��Ʒ����</TD>
	  					<TD width="34%">
	  						<input type=text  v_type="string" size=8 v_must=0 v_minlength=1 v_maxlength=8 v_name="��Ʒ����"  name=modeTypeCond maxlength=8 readonly Class="InputGrey" ></input>
							<input type=text  v_type="string"  v_must=0 v_minlength=1 v_maxlength=20 v_name="��Ʒ����"  name=modeTypeNameCond value="" maxlength=20 readonly Class="InputGrey">
		                    <input  type="button" class="b_text"  name="query_modeType" onclick="queryModeType()" value="ѡ��">
	  					</TD>
						<TD width="16%" class="blue"  >��Ʒ����</TD>
	  					<TD width="34%" >
	  						<input type=text  v_type="string"  v_must=1 v_minlength=1 v_maxlength=30 v_name="��Ʒ����"  name=mode_name_new maxlength=30 ></input>
	  					</TD>
	  				</tr>
					<tr  height="22">
	  					<TD width="16%"  class="blue" >SQL����<font class="orange">( SQL���������� AND �� and ��ͷ�����﷨��ȷ��)</font></TD>
	  					<TD width="34%" colspan=3 >
	  						<textarea name="whereSql" rows="10" cols="75" ></textarea>
	  					</TD>
	  				</tr>
					<tr  height="22">
	  					<TD width="16%" ><font class="orange">  ָ����Ч��ʽ</font></TD>
	  					<TD width="34%" colspan="3">
	  						<select name="defSendFlag"  >
	  						<option value=""> ---��ѡ��--- </option>
	  						<option value="0">0->������Ч</option>
	  						<option value="1">1->ԤԼ��Ч</option>
	  						<option value="2">2->���Ի�ԤԼ</option>
							  </select>
	  					</TD>
	  				</tr>
					<tr>
		                <td colspan=4 align="center">
		                   <input  type="button" name="query_smcode" onclick="queryModeCode()" value="��ѯ" class="b_text" >						   
						   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                   <input  type="button" name="do_reset" onclick="doReset()" value="����" class="b_text" >
		                </td>
	                </tr>
	  			</table>
 
	  			<table  id="mainThree"  cellspacing="0">
	  				<tr height="24" >
      		   	<Th width="10%" >ѡ��</Th>
	  					<Th width="15%">��Ʒ����</Th>
	  					<Th width="55%">��Ʒ����</Th>
	  					<Th width="10%">��Ч��ʽ</Th>
						  <Th width="10%">����Ȩ��</Th>
      		  		</tr>
	  				<tr height="22">
	  					<td colspan="5">
	  						<IFRAME src="f5238_modeTransFrame.jsp?login_accept=<%=login_accept%>&mode_code=<%=mode_code%>&mode_name=<%=mode_name%>&region_code=<%=region_code%>&trans_type=<%=trans_type%>" frameBorder=0 id=middle name=middle scrolling="yes" style="HEIGHT: 300; VISIBILITY: inherit; WIDTH: 100%; Z-INDEX: 1">
      		  	  			</IFRAME>
      		  	  		</td>
	  				</tr>
	          	</TABLE>
	          	<TABLE  cellSpacing=0>
	  			  <TR >
	  				<TD height="30" align="center" id="footer">
	  					<input name="selectall" type="button"  class="b_foot_long" value="ȫ��ѡ��" onClick="selectAll();">
	          	 	    &nbsp;
	          	 	    <input name="selectnone" type="button"  class="b_foot_long"  value="ȫ��ȡ��" onClick="selectNone();">
	          	 	    &nbsp;
	          	 	    <input name="conmit" type="button"  value="ȷ��" onClick="submitAdd();" class="b_foot" >
	          	 	    &nbsp;
	          	 	    <input name="cancel" type="button"  value="ȡ��"  class="b_foot" onClick="window.opener.document.form1.modeTransOtherButton.disabled=false;window.close();">
	  				</TD>
	  			  </TR>
	  	    	</TABLE>
	  	<%@ include file="/npage/include/footer_pop.jsp" %>
	  </form>
</body>
</html>
