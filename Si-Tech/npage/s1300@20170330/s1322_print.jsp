<%
/********************
 * version v2.0
 * ������: si-tech
 * update by zhangshuaia @ 2009-08-05
 ********************/
%>
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.sitech.util.MoneyUtil"%>
<%	
    String org_Code = (String)session.getAttribute("orgCode");
    String regionCode = org_Code.substring(0,2);				   
 
	String opCode = "1322";
	String opName = "���ŷ�Ʊ��ӡ";  
	MoneyUtil mon = new MoneyUtil();
	String dateStr = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());       
	String loginName = (String)session.getAttribute("workName");   
	String pass = (String)session.getAttribute("password");
	
	//grp_phone_no="+grp_phone_no+"&grp_contract_no="+grp_contract_no+"&s_money="+s_money+"&u_id="+u_id+"&u_name="+u_name;
	String grp_phone_nos[]=request.getParameterValues("grp_phone_no_new"); 
	String grp_contract_nos[]=request.getParameterValues("grp_contract_no"); 
	String s_moneys[]=request.getParameterValues("s_money"); 
	
	String u_id = request.getParameter("u_id");
	String u_name = request.getParameter("u_name");
	String invoice_number = request.getParameter("invoice_number");
	String invoice_code = request.getParameter("invoice_code");
	String work_no = (String)session.getAttribute("workNo");
	 
	String grp_phone_no="";
	String grp_contract_no="";
	String s_money="";
	String s_sum1 = request.getParameter("s_sum1");
	String items = request.getParameter("items");

	String login_accept = request.getParameter("login_accept");
	String begin_ym = request.getParameter("begin_ym");
	String end_ym = request.getParameter("end_ym");
    
 
	//xl add ������֯�ڵ��ѯӪҵ������
	String groupId = (String)session.getAttribute("groupId");
	String[] inParam_yyt = new String[2];
	inParam_yyt[0]="select group_name from dchngroupmsg where group_id=:s_group_id";
	inParam_yyt[1]="s_group_id="+groupId;
	String s_yyt_name="";


	//xl add ����ȡ��ˮ
	String invoice_accept_Arrays[]=request.getParameterValues("s_accepts"); 
	System.out.println("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa invoice_accept_Arrays is "+invoice_accept_Arrays);
	String s_invoice_accept="";
	for(int i =0;i<grp_phone_nos.length;i++)
	{
		grp_phone_no+=grp_phone_nos[i];
		grp_contract_no+=grp_contract_nos[i];
		s_money+=s_moneys[i];
		s_invoice_accept+=invoice_accept_Arrays[i];
	}
	System.out.println("cccccccccccccccccccccccccccccccccccccccc after grp_phone_no is "+grp_phone_no); 
%>
	<wtc:service name="TlsPubSelCrm"  outnum="1" >
		<wtc:param value="<%=inParam_yyt[0]%>"/>
		<wtc:param value="<%=inParam_yyt[1]%>"/>
	</wtc:service>
	<wtc:array id="yyt_name_arr" scope="end" />
<%
	if(yyt_name_arr!=null&&yyt_name_arr.length>0)
	{
		s_yyt_name = yyt_name_arr[0][0];
	}

	System.out.println("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaatesteeeeeeeeeeeeeeeeeeeeeee grp_phone_no is "+grp_phone_no);
%>
<!--�ӿ�Ӧ���ǵ��ӻ����Ľӿڰ�?-->
<wtc:service name="s1322InDB" routerKey="region" routerValue="<%=regionCode%>" retcode="sCodes" retmsg="sMsgs" outnum="3" >
    <wtc:param value="<%=u_id%>"/>
    <wtc:param value="<%=u_name%>"/> 
	<wtc:param value="<%=work_no%>"/> 
	<wtc:param value="<%=grp_phone_no%>"/> 
	<wtc:param value="<%=grp_contract_no%>"/>
	<wtc:param value="<%=s_money%>"/>
	<wtc:param value="<%=opCode%>"/>
	<wtc:param value="<%=invoice_number%>"/>
	<wtc:param value="<%=invoice_code%>"/>
	<wtc:param value="<%=items%>"/>
	<wtc:param value=""/>
	<wtc:param value="<%=begin_ym%>"/>
	<wtc:param value="<%=end_ym%>"/>
	<wtc:param value="<%=s_invoice_accept%>"/>
	<wtc:param value="<%=s_sum1%>"/>
	<wtc:param value="<%=groupId%>"/>
	<wtc:param value="<%=login_accept%>"/>
	<wtc:param value="<%=regionCode%>"/>
	<wtc:param value="1"/>
</wtc:service>
<wtc:array id="sArr" scope="end"/>

 
<%
 
	
	String retCode1= sCodes;
	String retMsg1 = sMsgs;
    if ( sCodes.equals("000000")  )
	{
 
%>
<html>
<META http-equiv=Content-Type content="text/html; charset=GBK">
<SCRIPT language="JavaScript">
    
    function printInvoice()
    {
        var localPath = "C:/billLogo.jpg";
		//alert(2);
        printctrl.Setup(0);
        printctrl.StartPrint();
        printctrl.PageStart();
		var rowInit = 7;
		var fontSizeInit = 9;//�����С
		var fontType = "����";//����
		var fontStrongInit = 0;//�����ϸ
		var vR = 0;
		var lineSpace = 0;
        printctrl.DrawImage(localPath,8,10,40,18);//��������
        printctrl.Print(20, 10, 9, 0, "��Ʊ����: <%=dateStr.substring(0,4)%>��<%=dateStr.substring(4,6)%>��<%=dateStr.substring(6,8)%>��");
		printctrl.Print(115, 10, 9, 0, "���η�Ʊ����: <%=invoice_number%>"); 
  
		printctrl.Print(13, 12, 9, 0, "�ͻ�����: <%=u_name%>");
		printctrl.Print(13, 13, 9, 0, "ҵ�����: ���ŷ�Ʊ����");
		printctrl.Print(125, 13, 9, 0, "�ͻ�Ʒ��: ");

		printctrl.Print(13, 15, 9, 0, "�û����룺 ");	
		printctrl.Print(48, 15, 9, 0, "Э����룺 ");
		printctrl.Print(82, 15, 9, 0, "��������: ");
		printctrl.Print(115, 15, 9, 0, "��ͬ��:");

		printctrl.Print(115, 16, 9, 0, "֧Ʊ��: ");
		printctrl.Print(115, 17, 9, 0, "����ͳ������: <%=u_id%>");//�����ʺ�
		printctrl.Print(16, 18, 9, 0, "��Ʊ��Ŀ:<%=items%>");
		printctrl.Print(16, 19, 9, 0, "���η�Ʊ���:(Сд)��<%=s_sum1.trim()%> ��д���ϼ�:<%=mon.NumToRMBStr(Double.parseDouble(s_sum1))%>");
			
		printctrl.Print(16, 21, 9, 0, "");//��ע 
		printctrl.Print(16, 22, 9, 0, "");//��ע 
		printctrl.Print(16, 23, 9, 0, "");//��ע 

		 
		
		//xl add ��Ʊ��                    �տ                     ���ˣ�
		printctrl.Print(13, 30, 9, 0, "��ˮ�ţ�<%=sArr[0][2]%> ");
		printctrl.Print(54, 30, 9, 0, "��Ʊ�ˣ�<%=loginName%> ");
		printctrl.Print(85, 30, 9, 0, "���ţ�<%=work_no%> ");
		printctrl.Print(110, 30, 9, 0, "Ӫҵ����<%=s_yyt_name%> ");
		//alert(4);
        printctrl.PageEnd();
        printctrl.StopPrint();
        //alert(5);
		 
    }

    function ifprint()
    {
      //alert(1);
        printInvoice();
		rdShowMessageDialog("��Ʊ��ӡ�ɹ�!");
		window.location="s1322.jsp?opCode=zg27&opName=��ֵ˰���ַ�Ʊ��������";
    }
</SCRIPT>

<body onload="ifprint()">
<OBJECT
classid="clsid:0CBD5167-6DF3-45C4-AC69-852C6CB75D32"
codebase="/ocx/PrintEx.dll#version=1,1,0,5" style="display:none;"
id="printctrl"
VIEWASTEXT>
</OBJECT>
 
</body>     
</html>
<%
	}else{

	%>   
	<script language="JavaScript">
		rdShowMessageDialog("���ŷ�Ʊ����ʧ��: <%=retMsg1%>,<%=retCode1%>",0);
		window.location="s1322.jsp?opCode=zg27&opName=��ֵ˰���ַ�Ʊ��������";
		</script>
	<%
	 
}
%>
