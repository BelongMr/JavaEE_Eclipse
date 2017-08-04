<%
/********************
 version v1.0
 开发商: si-tech
 update by wangzn @ 2010-4-28 17:07:41
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
    String opCode = "7483";
    String opName = "组合营销集团成员删除";
    
    String errPhoneList = WtcUtil.repNull((String)request.getParameter("errPhoneList"));
    String errMsgList = WtcUtil.repNull((String)request.getParameter("errMsgList"));
    
    System.out.println("------------------errPhoneList--------------------------"+errPhoneList);
    System.out.println("------------------errMsgList----------------------------"+errMsgList);
    
  	StringTokenizer stPhone = new StringTokenizer(errPhoneList,"|");
    String[] errPhoneArr = new String[stPhone.countTokens()];
    int i = 0;   
    while(stPhone.hasMoreTokens()){
        errPhoneArr[i++] = stPhone.nextToken();
    }
    
    
    StringTokenizer stMsg = new StringTokenizer(errMsgList,"|");
    String[] errMsgArr = new String[stMsg.countTokens()];
    int j = 0;
    while(stMsg.hasMoreTokens()){
        errMsgArr[j++] = stMsg.nextToken();
    }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>组合营销集团成员删除</title>
</head>
<script language="JavaScript">

</script>
<BODY>
<form name="frm" action="" method="post" >
<%@ include file="/npage/include/header.jsp" %>
<div class="title">
	<div id="title_zi">未成功号码列表</div>
</div>
<TABLE cellSpacing="0">
    <TR>
        <TH width='50%' align='center'>未添加成功号码</TH>
        <TH width='50%'>失败原因</TH>
    </TR>
    <%
    for (int k=0;k<errPhoneArr.length;k++)
    {
        String tdClass = "";
        if (k%2==0){
            tdClass = "Grey";
        }
    %>
        <TR>
            <TD class='<%=tdClass%>' align='center'><%=errPhoneArr[k]%></TD>
            <TD class='<%=tdClass%>'><%=errMsgArr[k]%></TD>
        </TR>
    <%
    }
    %>
</TABLE>

<TABLE cellspacing="0">
    <tr id="footer">
        <td>
            <input class="b_foot" name=back onClick="removeCurrentTab()" type=button value=关闭>
            <input class="b_foot" name=back onClick="window.location='f7483_1.jsp'" style="cursor:hand" type=button value=返回>
        </td>
    </tr>
</TABLE>

<%@ include file="/npage/include/footer.jsp" %>
</form>
</BODY>