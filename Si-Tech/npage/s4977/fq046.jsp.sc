<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http//www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http//www.w3.org/1999/xhtml">
<%
   /*
   * ����: Ӫҵ�շ�
�� * �汾: v1.0
�� * ����: 2009-01-13 14:37
�� * ����: wanglj
�� * ��Ȩ: sitech
   * �޸���ʷ
   * �޸�����      		�޸���      �޸�Ŀ��
 ��*/
%>
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %> 
<%
	String opName =  request.getParameter("opName");
	String opCode =  request.getParameter("opCode");
	
	String work_no = (String)session.getAttribute("workNo");
	String password = (String)session.getAttribute("password");	
%>
<%
	long totalBegin = System.currentTimeMillis();
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=opName%></title>
</head>
<body>
	<%---%%%%%%%%%%%add by liubo@2008-01-10,��Ϊ��ҳ����ؽ���,�Ӹ�����ʵ�ֲ�%%%%%%%%%%%%%--%>
		<style type="text/css">
				#addContainer{ 
				    position: absolute;
				    top: 50%;
				    left: 50%;
				    margin: -150px 0 0 -320px;
						text-align: center;
						width: 640px;
						padding: 20px 0 20px 0;
						border: 1px solid #339;
						background: #EEE;
						white-space: nowrap;
				}
				#addContainer img, #addContainer p{
						display: inline; 
						vertical-align: middle; 
						font: bold 12px "����", serif; 
				}
		</style>
		<script type="text/javascript">
			<!--
			     function loader(){
							var oDiv = document.createElement("div");
							oDiv.noWrap = true;
							oDiv.innerHTML = "<div id='addContainer'><nobr><img src='/nresources/default/images/blue-loading.gif'><p class='orange'>&nbsp;&nbsp;&nbsp;&nbsp;���ڽ���ͳһ�ɷѴ���������򡭡������ʱ��û�м��������ˢ�£�</p></nobr></div>"
							document.body.insertBefore(oDiv,document.body.firstChild);
							if(document.all){
								window.attachEvent("onload",function(){ oDiv.parentNode.removeChild(oDiv);});
							}else{
								window.addEventListener("load",function(){ oDiv.parentNode.removeChild(oDiv);},false);
							}
					 }
			//-->
		</script>
		<script>loader();</script>
	<%---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����add by liubo@2010-01-10%%%%%%%%%%%%%%%%%%%%%%%%%%%%--%>
<%
	long beginTime1 = System.currentTimeMillis();
%>

<%@ include file="/npage/common/qcommon/print_includeq046.jsp" %>

<%
	long endTime1 = System.currentTimeMillis();
	System.out.println("...................���ش�ӡͷ�ļ���ʱ��Ϊ:  " + endTime1 +"-" + beginTime1 + " =="+(endTime1-beginTime1));	
%>

<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.sitech.boss.pub.util.CreatePlanerArray"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UType"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UtypeUtil"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UElement"%>
<%@ page import="com.sitech.crmpd.core.wtc.util.*"%>
<%
		 opName = "һ���Է��ýɷ�";
		 String servPhoneNo = "";
		 String  servOrder  = "";
		 String errCode = "";
		 String errMsg  = "";
		 String gCustId =  request.getParameter("gCustId");		//�ͻ�ID
     String pathFlag = request.getParameter("pathFlag");	
		 String orgCode =(String)session.getAttribute("orgCode");
		 String regionCode = orgCode.substring(0,2);
		 String gCustName = "";
		 String idNo =  request.getParameter("offerSrvId"); 	//�û�ID
		 String custOrderId =  request.getParameter("custOrderId");	//�ͻ�������		 
		 String prtFlag = request.getParameter("prtFlag");		//��ӡ��ʶ,���������ӡ,Y�ϴ�  N�ִ�
		 String loginNo = (String) session.getAttribute("workNo");	//��������		 
		 String selStr = "";	//�տʽ�õ��ַ���
		 String selStrCdma = "<option selected value='1'>ǰ̨Ӫҵ��ȡ</option><option selected value='4'>ϵͳ�Զ�����Ԥ��</option>";//����C���û�,ֻ��ǰ̨Ӫҵ��ȡ		 
		 String siteId  = (String)session.getAttribute("objectId"); //wuln add
		 String siteName = (String)session.getAttribute("siteName");//������,���ڷ�Ʊ��ӡ
		 System.out.println(siteName+"046 siteId list==========================="+siteId);		 
		 //String printinfo   =  WtcUtil.repNull(request.getParameter("printinfo"));  //��ӡʹ�����ݴ�
		 String opcodeadd   =  WtcUtil.repNull(request.getParameter("opcodeadd"));  //��ӡʹ�����ݴ�
		 String oldMSISDN   =  WtcUtil.repNull(request.getParameter("oldMSISDN"));  //4100ԭ�ֻ��� ��ѯʹ��
		 System.out.println("lijy add @20110517");
		 String isMmtel=WtcUtil.repNull(request.getParameter("isMmtel")); //�Ƿ���mmtel�û��ı�־��1��ʾ��mmtel�û���0��ʾ����
		 System.out.println("------------------------isMmtel----------------"+isMmtel);
		 System.out.println("lijy add end@20110517");
		 System.out.println("mylog------------------opcodeadd-------------------"+opcodeadd);
		 System.out.println("mylog------------------oldMSISDN-------------------"+oldMSISDN);
		 String offeridkd = WtcUtil.repNull(request.getParameter("offeridkd"));
		 System.out.println("gaopengSeeLogFq046===================offeridkd==="+offeridkd);
		 System.out.println("gaopengSeeLogFq046===================gCustId==="+gCustId);
		 System.out.println("gaopengSeeLogFq046===================custOrderId==="+custOrderId);
		 //System.out.println("��ӡʹ�����ݴ���ӡʹ�����ݴ���ӡʹ�����ݴ���ӡʹ�����ݴ� siteId list==========================="+printinfo);		 
		 String v_smCode = WtcUtil.repNull(request.getParameter("v_smCode"));/*diling add for Ʒ��@2012/9/18 */
		 String v_isDisabledBtnFlag = "N";/*diling add for ��װ���Ƿ��ȡ�ɹ���ʶ@2012/9/18 */
		 String joinType = WtcUtil.repNull(request.getParameter("joinType"));/*2013/07/24 11:02:27 gaopen*/
		 
		 /*2015/05/06 9:09:31 gaopeng ��ȡ�ֿ۽�� ������CRM�����ֻ����ֶһ�������Ʒ���ܵ�����*/
		 String intePrice = WtcUtil.repNull(request.getParameter("intePrice"));
		 if("".equals(intePrice) || intePrice == null){
		 	intePrice = "0";
		 }
		 /*2015/01/19 10:33:28 gaopeng ��ͨ�����ں���Ŀ ȡ�û��Ŀ������ʷѣ����·���sql */
		 
		 String[] inParamsss1 = new String[2];
	   inParamsss1[0] = "SELECT b.offer_attr_value FROM product_offer a, product_offer_attr b where a.offer_id = b.offer_id and a.offer_id =:bofferid and b.offer_attr_seq = 50001 and a.offer_type = 10";
	   inParamsss1[1] = "bofferid="+offeridkd;
	   String monthFee = "0";
	   String monthFlag = "false";
	   %>
		  <wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode1ss" retmsg="retMsg1ss" outnum="3">			
			<wtc:param value="<%=inParamsss1[0]%>"/>
			<wtc:param value="<%=inParamsss1[1]%>"/>
			</wtc:service>
			<wtc:array id="result0y" scope="end" />
		 <%
		 
		 if(result0y.length>0) {
		 	if(result0y[0][0] != null && !"".equals(result0y[0][0])){
		 		monthFee = result0y[0][0];
		 		monthFlag = "true";
		 	}
		 }
		 
		 Map parametersMap = request.getParameterMap();
		 /*StringBuffer sb = new StringBuffer(80);
		 for(Iterator iterator = parametersMap.keySet().iterator(); iterator.hasNext(); sb.append("&"))
        {
            String key = (String)iterator.next();
            System.out.println("key========" + key);
            System.out.println("parametersMap.get(key)========" + parametersMap.get(key));
            Object values[] = (Object[])parametersMap.get(key);
            Object value = values == null ? "" : values[0];
            System.out.println("value========" + value);
            sb.append(key);
            sb.append("=");
            sb.append(value);
        }
        System.out.println("sb=============="+sb.toString()); //���������˹�����,���½ɷ�ʧ��,���ע�͵��ĳ��������������ȡ����*/ 
		 beginTime1 =  System.currentTimeMillis();
		 
		 	/** tianyang add for pos start **/
			String groupId = (String)session.getAttribute("groupId");
			/** tianyang add for pos end **/
			/* ningtn �����û��Ż�Ȩ����Ϣ�����ÿ��޸Ľ�� */
			String[][] favInfo = (String[][])session.getAttribute("favInfo");
			String[] feeFav = new String[3];
			feeFav[0] = "";
			feeFav[1] = "";
			feeFav[2] = "";
			String tempStr = "";
			for(int feefavi = 0; feefavi< favInfo.length; feefavi++){
				tempStr = (favInfo[feefavi][0]).trim();
				System.out.println("-------- fav -- " + tempStr);
				if(tempStr.compareTo("a002") == 0){
				/*�����������Ż� �����޸Ŀ���Ԥ�桢����Ԥ������Ԥ���*/
					feeFav[0] = favInfo[feefavi][0];
				}else if(tempStr.compareTo("a003") == 0){
					/*����SIM�����Ż� �����޸�SIM������*/
					feeFav[1] = favInfo[feefavi][0];
				}else if(tempStr.compareTo("a004") == 0){
					/*����ѡ�ŷ��Ż� �����޸Ŀ���ѡ�ŷ�*/
					feeFav[2] = favInfo[feefavi][0];
				}
			}
			for(int feei = 0; feei < feeFav.length; feei++){
				System.out.println("======= fav feefav ===== " + feeFav[feei]);
			}
%>
	
	<!-- 2013/11/12 16:06:23 gaopeng �޸��Լ�֮ǰ�ĵڶ����ͻ�������Ϣ���죬��������sUserCustInfo Ϊ  sQBasicInfo-->
	<wtc:utype name="sQBasicInfo" id="retBd0002" scope="end"  routerKey="region" routerValue="<%=regionCode%>">
     <wtc:uparam value="<%=gCustId%>" type="LONG"/>
  </wtc:utype>
  
	<%
	String errCodeGetCust =retBd0002.getValue(0);
	String errMsgGetCust  =retBd0002.getValue(1);

	if(errCodeGetCust.equals("0") || errCodeGetCust.equals("000000")){
		System.out.println("���÷���sQBasicInfo in fq046(s4977).jsp �ɹ�@@@@@@@@@@@@@@@@@@@@@@@@@@");
		gCustName = retBd0002.getValue("2.0");
		System.out.println("���÷���sQBasicInfo in fq046(s4977).jsp custName : "+gCustName);
	}
	else{	 
		System.out.println("���÷���sQBasicInfo in fq046(s4977).jsp ʧ��@@@@@@@@@@@@@@@@@@@@@@@@@@");
	%>
		<script language="JavaScript">
			rdShowMessageDialog("������룺<%=errCodeGetCust%>��������Ϣ��<%=errMsgGetCust%>");
			removeCurrentTab();
		</script>
	<%
	}
	%>

	<%
	String sql_rft = "select receive_fee_type,receive_fee_name from sServReceiveFeeType where receive_fee_type in ('1')";
	%>
	<!--��ѯ��ȡ��ʽ,ƴ��<select>,����selStr  jsp������,�ڴ���������Ϣ��ʱ����=====BEGIN-->
	<wtc:pubselect  name="sPubSelect"  outnum="2">
       <wtc:sql><%=sql_rft%></wtc:sql>													 
    </wtc:pubselect> 
     <wtc:iter id="IdRows" indexId="i">
		<%
				if("1".equals(IdRows[0])){
					selStr += "<option selected value="+IdRows[0]+">"+IdRows[1]+"</option>";
				}else{
					selStr += "<option  value="+IdRows[0]+">"+IdRows[1]+"</option>";	
				}
		%>
  	</wtc:iter>
  	<%
  		endTime1 = System.currentTimeMillis();
	 	System.out.println("...................��ѯ��ȡ��ʽ��ʱ��Ϊ:  " + endTime1 +"-" + beginTime1 + " =="+(endTime1-beginTime1));	
  		selStrCdma = selStr;
  		beginTime1 =  System.currentTimeMillis();
  	%>
  	<!--��ѯ��ȡ��ʽ,ƴ��<select>,����selStr  jsp������,�ڴ���������Ϣ��ʱ����=====END-->
  	
  	<!--����sOrderItemShow����,���ؿͻ�����custOrderId�µ����ж�������,���񶩵�,�ͷ��ÿ�Ŀ,�����д���=====BEGIN-->
  	
<%String regionCode_sOrderItemShow = (String)session.getAttribute("regCode");%>
	 <wtc:utype name="sOrderItemShow" id="retVal" scope="end"  routerKey="region" routerValue="<%=regionCode_sOrderItemShow%>">
			<wtc:uparam value="<%=custOrderId%>" type="STRING"/>  
			<wtc:uparam value="<%=loginNo%>" type="STRING"/>      
			<wtc:uparam value="<%=opCode%>" type="STRING"/>  
     </wtc:utype>
   	
  	<%
  		 	endTime1 = System.currentTimeMillis();
	 		System.out.println("...................���÷��ò�ѯ��ʱ��Ϊ:  " + endTime1 +"-" + beginTime1 + " =="+(endTime1-beginTime1));	
	 		beginTime1 =  System.currentTimeMillis();
     	    String retCode_046 = retVal.getValue(0);
     	    System.out.println("------------------retCode_046---------------------"+retCode_046);
     		String retMsg_046 = retVal.getValue(1);
     		System.out.println("------------------retMsg_046---------------------"+retMsg_046);
     		StringBuffer logBuffer046 = new StringBuffer(80);
			WtcUtil.recursivePrint(retVal,1,"2",logBuffer046);		
			System.out.println(logBuffer046.toString());
			System.out.println(retCode_046+"......................"+retMsg_046);
     		String arrayOrders = "";
     		String servOrders = "";
     		float totalOpFee = 0;	
     		String feeFlag = "0";	//�շѱ�־,�ڻ�ȡ���ÿ�Ŀ��ʱ���޸�Ϊ1,�����Ϊ0,��ֱ��ת��ɷѽ���
     		
     		

     		String ipAddrss1 = (String)session.getAttribute("ipAddr");
     		String beizhussdese1="����custid=["+gCustId+"]���в�ѯ";
 %>
 
 	<wtc:service name="sUserCustInfo" outnum="100" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
			<wtc:param value="0" />
			<wtc:param value="01" />	
			<wtc:param value="4977" />	
			<wtc:param value="<%=loginNo%>" />
			<wtc:param value="<%=password%>" />
			<wtc:param value="" />
			<wtc:param value="" />
			<wtc:param value="<%=ipAddrss1%>" />
			<wtc:param value="<%=beizhussdese1%>" />
			<wtc:param value="<%=gCustId%>" />
	</wtc:service>
	<wtc:array id="result_custInfo" scope="end"/>	
		 	
		 	
	<%	 		
  String custiccids="";
  String custiccidtypes="";
  String custditypesnames="";
  
	if(result_custInfo.length>0){
	if(result_custInfo[0][0].equals("01")) {
		custiccidtypes = result_custInfo[0][12].trim();
		custiccids = result_custInfo[0][13];
		}
	}
	
	if("0".equals(custiccidtypes)) {
		custditypesnames="����֤";
  }else if("1".equals(custiccidtypes)) {
  	custditypesnames="����֤";
 	}else if("2".equals(custiccidtypes)) {
 		custditypesnames="����֤";
 	}else if("3".equals(custiccidtypes)) {
 		custditypesnames="�۰�ͨ��֤";
 	}else if("4".equals(custiccidtypes)) {
 		custditypesnames="����֤";
 	}else if("5".equals(custiccidtypes)) {
 		custditypesnames="̨��ͨ��֤";
 	}else if("6".equals(custiccidtypes)) {
 		custditypesnames="���������";
 	}else if("7".equals(custiccidtypes)) {
 		custditypesnames="����";
 	}else if("8".equals(custiccidtypes)) {
 		custditypesnames="Ӫҵִ��";
 	}else if("9".equals(custiccidtypes)) {
 		custditypesnames="����";
 	}else if("A".equals(custiccidtypes)) {
 		custditypesnames="��֯��������";
 	}else if("B".equals(custiccidtypes)) {
 		custditypesnames="��λ����֤��";
 	}else if("C".equals(custiccidtypes)) {
 		custditypesnames="��λ֤��";
 	}else if("00".equals(custiccidtypes)) {
 		custditypesnames="����֤";
 	}
	
 %>

 <script type="text/javascript" src="<%=request.getContextPath()%>/njs/si/validate_class.js"></script>
 <script>
 	var joinMarket;
 <%
				out.println("var arrayOrder = new Array();");  //������������,����ƴ���������б�
				out.println("var servOrder = new Array();");	//���񶨵�����,����ƴ���񶨵��б�
				out.println("var allFeeArray = new Array();"); //���ÿ�Ŀ����,����ƴ���ÿ�Ŀ�б� ,ѹ��feeOrder����
				out.println("var savenames;");

				
				out.println("var servOrderNoArray = new Array();"); //���񶨵�������,���ڷ�Ʊ��ӡ
				
				out.println("var totalFee1 = '';");		//Ӧ�շ���
				out.println("var totalFee2 = '';");		//�Żݷ���
				out.println("var totalFee3 = '';");		//ʵ�շ���
				out.println("var kdZdType = '';");		//�����ն�����
				String kdZdType = "";
				
				
				Set prtFlagSet = new HashSet();	//ͨ�������������ˮ��������Ʊ��ӡ,��set���ڴ洢 ��������~��ˮ�� ��
				out.println("var prtFlagSet = new Array();");	
				
     		if(retCode_046.equals("0")){
     			int num = retVal.getSize("2");	//ȡ�ö����������
     			for(int i = 0 ;i < num;i++){
     			
     				//��ʾ���������б�
     				
     				UType arrayOrderUtype = retVal.getUtype("2."+i+".0");	//ȡ��������UTYPE
     				String arrayOrderNo046 = arrayOrderUtype.getValue(1);	//ȡ����������
     				String arrayOrderName = arrayOrderUtype.getValue(3);	//��������
     				String isComp = arrayOrderUtype.getValue(7);	//�Ƿ���ϲ�Ʒ��ʶ
     				String isPrtFeeDetail = arrayOrderUtype.getValue(8);	//�Ƿ��ӡ�վ�
     				
     				System.out.println("------------------isPrtFeeDetail---------------------------"+isPrtFeeDetail);
     				
     				arrayOrders = arrayOrders + arrayOrderNo046 + "|" ;
     				
     				for(int j = 0 ; j < arrayOrderUtype.getSize()-2;j++){
     						String tmp = arrayOrderUtype.getValue(j);
     						if(j == 2){					//����	ҵ���������
     						  if("100".equals(tmp)){
     								out.println("arrayOrder.push('��װ');");
     						  }else{
     						  	out.println("arrayOrder.push('�ͻ�����');");	
     						  }
	     					}else{
	     						out.println("arrayOrder.push('" + tmp + "');");
	     					}
     			  }
     			  	
     			  int servNum = retVal.getSize("2."+i+".1");			//ȡ�ö��������µķ��񶩵�����
     			  System.out.println("..................servNum="+servNum);
     			  
     			  for(int j = 0 ; j < servNum ; j++){
     			  
     			   	//��ʾ���񶨵��б�
     			   	
     			   	UType servOrderUtype = retVal.getUtype("2."+i+".1."+j+".0");	//ȡ���񶩵�UTYPE
     			   	out.println("servOrderNoArray.push('"+ servOrderUtype.getValue(0) +"');");	//�����񶩵���ŷ���servOrderNoArray JS������
     			   	servOrders = servOrders + arrayOrderUtype.getValue(1) + "~" + servOrderUtype.getValue(0) + "|" ;	//��������~���񶩵����  ��,���ڽɷ��ύ
     			   	String serv_bus_id = servOrderUtype.getValue(6);	//ȡserv_bus_id,���������sql��ѯ,�õ������������master_serv_type,���master_serv_type��0 ,����C��ҵ��,C��ҵ��ֻ����ȡ��ʽ������
     			   	String master_serv_type = "";
     			   	
%>

						<wtc:pubselect  name="sPubSelect"  outnum="1">
					       <wtc:sql>select c.master_serv_type from product a , service_offer b ,master_server c where a.product_id =b.product_id and a.master_serv_id = c.master_serv_id and b.service_offer_id='?'</wtc:sql>													 
					       <wtc:param value="<%=serv_bus_id%>"/>
					    </wtc:pubselect> 
					   <wtc:iter id="IdRows" indexId="ii">
					    
					<%
							 master_serv_type = IdRows[0];
							 System.out.println("..................master_serv_type="+master_serv_type);
							 

					%>
					</wtc:iter>
					
<%     			   	
     			  	for(int m = 0 ; m < servOrderUtype.getSize()-2;m++){ //��sq046���ܱ���һ�£���
     			  		String tmp = servOrderUtype.getValue(m);
     			  		if(m == 0){
     			  			String phoneNum = "";
     			  			String prePayFee = "";
     			  			String jifen = "";
     			  			String phoneFeeStr  = "";
     			  			if("TRUE".equals(isPrtFeeDetail) || "true".equals(isPrtFeeDetail)){
     			  				UType phoneUtype = new UType();
     			  				servPhoneNo = servOrderUtype.getValue(2);
     			  				//if("0".equals(servPhoneNo))	continue;
     			  				System.out.println(".................servPhoneNo == " + servPhoneNo);
     			  				phoneUtype.setUe("STRING", servPhoneNo);    
     			  				System.out.println("--------------------------------------phoneUtype----------------------"+phoneUtype);			  				
     			  				%>
                 <%String regionCode_sShowNumInfo = (String)session.getAttribute("regCode");%>
     			  					<wtc:utype name="sShowNumInfo" id="retVal2"  scope="end"  routerKey="region" routerValue="<%=regionCode_sShowNumInfo%>">
								          <wtc:uparam value="<%=phoneUtype%>" type="UTYPE"/>      
								      </wtc:utype>
     			  				<%
     			  				
     			  				 errCode  = retVal2.getValue(0);
     			  				 errMsg  = retVal2.getValue(1);
     			  				System.out.println("--------------sShowNumInfo---------------retVal2.getValue(0)------------------------"+retVal2.getValue(0));
     			  				if("0".equals(retVal2.getValue(0))){
     			  				phoneNum = retVal2.getValue("2.0.0");
     			  				prePayFee = retVal2.getValue("2.0.1");
     			  				jifen = retVal2.getValue("2.0.2");
     			  				phoneFeeStr  = phoneNum+"~"+prePayFee+"~"+jifen+"~";
     			  				System.out.println("--------------------------------------phoneFeeStr----------------------"+phoneFeeStr);			  				
     			  				}
     			  				
     			  			}
     			  			//ÿ�����񶩵��᷵��һ����ˮ,�ɶ�������~��ˮ����ӡһ�ŷ�Ʊ, ��������ȷ���set�й����ظ�Ԫ��,��ѹ��JS������
     			  			
     			  			String prtLoginAccept = servOrderUtype.getValue(7);
     			  			String prtFlagElement = arrayOrderNo046 + "~" + prtLoginAccept;
     			  			
     			  			System.out.println("-----------------prtFlagElement-------------------"+prtFlagElement);
     			  			prtFlagSet.add(prtFlagElement) ;
     			  			if("Y".equals(isComp)){
     			  				out.print("servOrder.push('<input type=radio v_isPrtFeeDetail = " + isPrtFeeDetail + "  v_phone_no_str=" + phoneNum + " v_phone_fee_str=" + phoneFeeStr + "  v_prtFlag=" + prtFlagElement + " v_iscomp="+isComp+" v_phoneNo ="+gCustId+" v_opType="+ arrayOrderName +" v_custName= "+ gCustName +" onclick=showMyFee(this.v_span) v_span="+tmp+" name=servOrders value=" +arrayOrderUtype.getValue(1)+"~"+ tmp+"~"+servOrderUtype.getValue(6) + "~" + master_serv_type+">"+ tmp +"');");
     			  			
     			  			}else{
     			  				out.print("servOrder.push('<input type=radio v_isPrtFeeDetail = " + isPrtFeeDetail + "  v_phone_no_str=" + phoneNum + " v_phone_fee_str= " + phoneFeeStr + " v_prtFlag=" + prtFlagElement + " v_iscomp="+isComp+" onclick=showMyFee(this.v_span) v_span="+tmp+" name=servOrders value=" +arrayOrderUtype.getValue(1)+"~"+ tmp+"~"+servOrderUtype.getValue(6) + "~" + master_serv_type+">"+ tmp +"');");	
     			  			
     			  			}
     			  		}else if(m ==5){		//������񶨵��Ľɷ�״̬
     			  		  if("0".equals(tmp)){
     			  				out.println("servOrder.push('δ�ɷ�')");
     			  		  }else if("1".equals(tmp)){
     			  		  	out.println("servOrder.push('�ѽɷ�')");	
     			  		  }else{
     			  		  	out.println("servOrder.push('���ֽɷ�')");		
     			  		  }
	     			  	}else{
	     			  		out.println("servOrder.push('" + tmp + "');");
	     			  	}
     			    }
     			       			    
     			    //��ʾ������Ϣ�б�
     			    
     			    out.println("var feeOrder = new Array();");	// ��ŷ��ÿ�Ŀ��JS����,һ�����񶩵�һ������������,�������з��񶩵��ķ�������ѹ��allFeeArray
     			     
     			    for(int m = 0 ; m < retVal.getSize("2."+i+".1."+j+".1");m++){
     			    	UType feesUtype = retVal.getUtype("2."+i+".1."+j+".1."+m);	//ȡ����UTYPE
     			    	out.println("totalFee1 = Number(totalFee1) + Number("+feesUtype.getValue(1)+")");	       //Ӧ�շ���	�ۼ�
     			    	out.println("totalFee2 = Number(totalFee2) + Number("+feesUtype.getValue(2)+")");          //�Żݷ���	�ۼ�
     			    	out.println("totalFee3 = Number(totalFee3) + Number("+feesUtype.getValue(3)+")");          //ʵ�շ���	�ۼ�
     			    	UType totalUtype = feesUtype.getUtype(4);	//ȡ���ÿ�Ŀ����UTYPE
   			    		String  arrayOrder = arrayOrderUtype.getValue(1);
   			    		servOrder = servOrderUtype.getValue(0);
     			    	int rowcount = totalUtype.getSize();	//ȡ���ÿ�Ŀ���ϸ���
     			    	
     			    	for(int n = 0 ; n< rowcount; n++){
     			    		if("0".equals(feeFlag)) feeFlag = "1"; 	//ֻҪ�з��ÿ�Ŀ,�Ͳ�������ѵ�,Ҫ��ʾ�ɷѽ���
     			    		UType uuu = totalUtype.getUtype(n);
     			    		String textStyle = "";
     			    		String classStyle = "";
     			    		String feeCode = "";	//2011/11/17 wanghfa����
     			    		for (int k = 0 ; k< uuu.getSize()-8;k++){
     			    			String tmp = uuu.getValue(k);
     			    		  if(k == 1) continue;
     			    		  if(k == 0){
     			    		  	String  tmp2 = uuu.getValue(k+1);	//ȡ���ô���
     			    		  	feeCode = uuu.getValue(k+1);	//ȡ���ô���
     			    		  	String  feeName = uuu.getValue(6);	//ȡ��������,��������ǰ���и�������,��������ͺͷ��ô���,�Լ����ÿ�Ŀ�ķ��񶩵��������
     			    		  	if("�����豸�ն˿�".equals(feeName)){
     			    		  		kdZdType = uuu.getValue(13);
     			    		  		System.out.println("gaopeng -222-servOrder="+uuu.getValue(13));
     			    		  		
     			    		  	}
     			    		  	/* ningtn ������װ�Ѳ������޸� */
     			    		  		textStyle = "readonly";
     			    		  		classStyle = "forMoney required";
     			    		  		if(tmp2.equals("21")){
     			    		  			/* �������Ԥ�棬���ɸ� */
     											textStyle = "readonly";
     											classStyle = "forMoney required InputGrey";
     										}else if(tmp2.equals("9001")){
     			    		  			/* SIM������ */
     			    		  			/* SIM�����ã��ָĻ�ԭģʽ��
     			    		  			if(WtcUtil.haveStr(feeFav,"a003")){
     												textStyle = "";
     												classStyle = "forMoney required";
     											}else{
     												textStyle = "readonly";
     												classStyle = "forMoney required InputGrey";
     											}
     											*/
     											textStyle = "";
     											classStyle = "forMoney required";
     										}else if(tmp2.equals("9002")){
     			    		  			/* ����ѡ�ŷ� */
     			    		  			if(WtcUtil.haveStr(feeFav,"a004")){
     												textStyle = "";
     												classStyle = "forMoney required";
     											}else{
     												textStyle = "readonly";
     												classStyle = "forMoney required InputGrey";
     											}
     										}else if(tmp2.equals("1001") || tmp2.equals("2") || tmp2.equals("1000")){
     			    		  			/* ����Ԥ��� ����Ԥ�� ����Ԥ��� */
     			    		  			if(WtcUtil.haveStr(feeFav,"a002")){
     												textStyle = "";
     												classStyle = "forMoney required";
     											}else{
     												textStyle = "readonly";
     												classStyle = "forMoney required InputGrey";
     											}
     										}
     			    		  	if(opcodeadd.equals("4977")){
     										if(tmp2.equals("9003")){
     											textStyle = "readonly";
     											classStyle = "forMoney required InputGrey";
     										}/*2016/5/11 9:30:05 gaopeng kiƷ�� ����ƷԤ���ûҲ����޸�*/
     										else if(tmp2.equals("200") && "ki".equals(v_smCode)){
     											textStyle = "readonly";
	     										classStyle = "forMoney required InputGrey";
	     										System.out.println("gaopengSeelOg20160511==================�����޸���======="+tmp);
     										}
     									}
     			    		  %>
	     									feeOrder.push("<%=servOrder%>");
	     									feeOrder.push("<input type=hidden v_pparent=<%=arrayOrder%> v_type=fee_codes v_mustFee=1 v_parent=<%=servOrder%> name=fee_code<%=n%>_<%=k%> v_feeType=<%=tmp%> value=<%=tmp2%>><input type='text'name=fee_name<%=n%>_<%=k%> value=<%=feeName%>>"); 
	     									
     			    			<%
     			    				continue;
     			    			}
     			    			if(k == 4){
     			    				//����Ӫҵ�Ż�,Ӫ��=ʵ��-����-ʵ��,������ʵ���ı����ĵڶ�����������,��һ����������ʵ�ո���,�����û�����Ƿ�ʱ,�ָ�ԭֵ
     			    			    float opFee0466 = Float.parseFloat(uuu.getValue(2)) -  Float.parseFloat(uuu.getValue(3)) - Float.parseFloat(uuu.getValue(4));
     			    				//�ۼ�Ӫҵ�Ż�
     			    				totalOpFee += opFee0466;	
     			    				String opFee046 = String.valueOf(opFee0466);
     			    				//System.out.println(Float.parseFloat(uuu.getValue(2))+"-"+Float.parseFloat(uuu.getValue(4))+":"+Float.parseFloat(uuu.getValue(3))+" =opFee046  = " +opFee046);
     			    				System.out.println("gaopengSeeFeeCode fq046 feeCode " + feeCode);
     			    				if(feeCode.equals("9003")) {
     			    				//out.println("savenames=realPayFee+"+n+"_"+k");
     			    			%>
     			    			    savenames="realPayFee"+"<%=n%>"+"_"+"<%=k%>";     			    			   
     			    			    
     			    					feeOrder.push("<input type=text size=10  maxLength='15' id=realPayFee<%=n%>_<%=k%> name=realPayFee<%=n%>_<%=k%> v_feeCode=<%=feeCode%> class='<%=classStyle%>' vflag=1  onchange = changeRealPayFee() <%=textStyle%> value='<%=tmp%>'><input type=hidden name=realfee<%=n%>_<%=k%>  value='<%=tmp%>'><input type='text' style='display:none' id='opchangeFee<%=n%>_<%=k%>' value='<%=opFee046%>' v_oldvalue='0'>");
     			    			<%
     			    		    }else if(opcodeadd.equals("4977") && !feeCode.equals("9003")){
     			    		  %>
     			    		   	joinMarket = parent.document.getElementById("<%=gCustId%>").joinMarket;
     			    		   	if(joinMarket == "on"){
     			    		   		/*�μ�Ӫ����*/
     			    		   		/*2013/07/24 11:10:44 gaopeng ����Э���������������˾���ն˴��۹�����Ӫ�������ĺ� ����һ��������joinTypeΪ1ʱ�������ۿ۽����ģ�0����0Ԫ�ʷѽ�����*/
     			    		   		if("<%=joinType%>"=="1")
     			    		   		{
     			    		   			feeOrder.push("<input type=text size=10  maxLength='15' name=realPayFee<%=n%>_<%=k%> v_feeCode=<%=feeCode%> class='<%=classStyle%>' vflag=1  onchange = changeRealPayFee() <%=textStyle%> value='<%=tmp%>'><input type=hidden name=realfee<%=n%>_<%=k%>  value='<%=tmp%>'><input type='text' style='display:none' id='opchangeFee<%=n%>_<%=k%>' value='<%=opFee046%>' v_oldvalue='0'>");
     			    		   		}
	     			    		   	else if("<%=joinType%>"=="0"){
	     			    		   		feeOrder.push("<input type=text size=10  maxLength='15' name=realPayFee<%=n%>_<%=k%> v_feeCode=<%=feeCode%> class='<%=classStyle%>' vflag=1 readonly value='0.00'><input type=hidden name=realfee<%=n%>_<%=k%>  value='<%=tmp%>'><input type='text' style='display:none' id='opchangeFee<%=n%>_<%=k%>' value='<%=opFee046%>' v_oldvalue='0'>");
	     			    		   	}
     			    		   	}else{
     			    		   		/*2015/01/19 9:03:30 gaopeng ������4977�������� ���μ�Ӫ�����Ĳ��ǳ�װ�ѣ�9003����*/
     			    		   		/*200Ϊ����ƷԤ��ķ��ô���*/
     			    		   		if("<%=feeCode%>" == "200"){
     			    		   			if("<%=v_smCode%>" == "kh" && "<%=monthFlag%>" == "true"){
     			    		   				feeOrder.push("<input type=text size=10  maxLength='15' name=realPayFee<%=n%>_<%=k%> v_feeCode=<%=feeCode%> class='<%=classStyle%>' vflag=1  onchange = changeRealPayFee()  value='<%=tmp%>'><input type=hidden name=realfee<%=n%>_<%=k%>  value='<%=tmp%>'><input type='text' style='display:none' id='opchangeFee<%=n%>_<%=k%>' value='<%=opFee046%>' v_oldvalue='0'>");
     			    		   			}else if("<%=v_smCode%>" == "ki"){
     			    		   				feeOrder.push("<input type=text size=10  maxLength='15' name=realPayFee<%=n%>_<%=k%> v_feeCode=<%=feeCode%> class='<%=classStyle%>' <%=textStyle%> vflag=1  onchange = changeRealPayFee()  value='0.0'><input type=hidden name=realfee<%=n%>_<%=k%>  value='0.0'><input type='text' style='display:none' id='opchangeFee<%=n%>_<%=k%>' value='<%=opFee046%>' v_oldvalue='0'>");
     			    		   			}else{
     			    		   				feeOrder.push("<input type=text size=10  maxLength='15' name=realPayFee<%=n%>_<%=k%> v_feeCode=<%=feeCode%> class='<%=classStyle%>' <%=textStyle%> vflag=1  onchange = changeRealPayFee()  value='<%=tmp%>'><input type=hidden name=realfee<%=n%>_<%=k%>  value='<%=tmp%>'><input type='text' style='display:none' id='opchangeFee<%=n%>_<%=k%>' value='<%=opFee046%>' v_oldvalue='0'>");
     			    		   			}
     			    		   		
     			    		   		}else{
     			    		   			feeOrder.push("<input type=text size=10  maxLength='15' name=realPayFee<%=n%>_<%=k%> v_feeCode=<%=feeCode%> class='<%=classStyle%>' <%=textStyle%> vflag=1  onchange = changeRealPayFee()  value='<%=tmp%>'><input type=hidden name=realfee<%=n%>_<%=k%>  value='<%=tmp%>'><input type='text' style='display:none' id='opchangeFee<%=n%>_<%=k%>' value='<%=opFee046%>' v_oldvalue='0'>");
     			    		   		}
     			    		   	}
     			    		  <%
     			    		    }else {
     			    		   %>
     			    		      feeOrder.push("<input type=text size=10  maxLength='15' name=realPayFee<%=n%>_<%=k%> v_feeCode=<%=feeCode%> class='<%=classStyle%>' vflag=1  onchange = changeRealPayFee() <%=textStyle%> value='<%=tmp%>'><input type=hidden name=realfee<%=n%>_<%=k%>  value='<%=tmp%>'><input type='text' style='display:none' id='opchangeFee<%=n%>_<%=k%>' value='<%=opFee046%>' v_oldvalue='0'>");
     			    		   <%
     			    		    }
     			    				continue;
     			    			}
     			    			if(k == 5){	//������û�������Ҫ�ж������⴦��,��ʵ����дѭ����,�����տ�ʼ����ʱ�������ӵ�,��������...
     			    			 	k++;
     			    				continue;
     			    			}
     			    			System.out.println(" ====diling===== ningtn fq046 ====  [" + n + " = " + k + " - " + tmp + "]");
     			    			System.out.println(" ====diling===== feeCode===="+feeCode);
     			    			if(k==2 && feeCode.equals("9003")) {
     			    			
     			    			
     			    			System.out.println(" ====diling===== ningtn fq046 ====  111111111111");
     			    			String chedk1="";
     			    			String chedk2="";
     			    			String chedk3="";
     			    			String chedk4="";
     			    			String chedk5="";
     			    			String chedk6="";
     			    			String chedk7="";
     			    			String chedk8="";
     			    			String chedk9="";
     			    			String chedk10="";
     			    			String chedk11="";
     			    		  //tmp="30";
     			    						if(tmp.equals("80.00")) {
     			    						chedk1=" selected";
     			    						}
     			    						if(tmp.equals("70.00")) {
     			    						chedk2=" selected";
     			    						}
     			    						if(tmp.equals("60.00")) {
     			    						chedk3=" selected";
     			    						}
     			    						 if(tmp.equals("50.00")) {
     			    						chedk4=" selected";
     			    						}
     			    						if(tmp.equals("40.00")) {
     			    						chedk5=" selected";
     			    						}
     			    						if(tmp.equals("30.00")) {
     			    						chedk6=" selected";
     			    						}
     			    						if(tmp.equals("20.00")) {
     			    						chedk7=" selected";
     			    						}
     			    						if(tmp.equals("10.00")) {
     			    						chedk8=" selected";
     			    						}
     			    						if(tmp.equals("0.00")) {
     			    						chedk9=" selected";
     			    						}  
     			    						if(tmp.equals("90.00")) {
     			    						chedk10=" selected";
     			    						}  
     			    						if(tmp.equals("100.00")) {
     			    						chedk11=" selected";
     			    						}    
     			    						/*begin diling add for ��̬�����ݿ��л�ȡ��װ��@2012/9/19 */	
     			    						String  inParams [] = new String[2];
     			    						inParams[0]="SELECT prefee FROM sbandprefee where region_code=:regioncode and sm_code=:smcode ";	 
     			    						inParams[1] = "regioncode="+regionCode+",smcode="+v_smCode;   
     			    						//System.out.println(" ====diling===f046.jsp=====  regioncode="+regionCode);		
     			    						System.out.println(" ====diling===f046.jsp=====  smcode="+v_smCode);					
     			    			%>
     			    			<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCodeFee" retmsg="retMsgFee" outnum="1"> 
                      <wtc:param value="<%=inParams[0]%>"/>
                      <wtc:param value="<%=inParams[1]%>"/> 
                    </wtc:service>  
                    <wtc:array id="retFee"  scope="end"/>
     			    			//alert(<%=k%>+"---"+<%=tmp%>);
     			    			//feeOrder.push("<select onchange=><option value='100.00' <%=chedk11%>>100.00</option><option value='90.00' <%=chedk10%>>90.00</option><option value='80.00' <%=chedk1%>>80.00</option><option value='70.00' <%=chedk2%>>70.00</option><option value='60.00' <%=chedk3%>>60.00</option><option value='50.00' <%=chedk4%>>50.00</option><option value='40.00' <%=chedk5%>>40.00</option><option value='30.00' <%=chedk6%>>30.00</option><option value='20.00' <%=chedk7%>>20.00</option><option value='10.00' <%=chedk8%>>10.00</option><option value='0.00' <%=chedk9%>>0.00</option></select>");
     			    			<%
     			    			String checkFlag="";
     			    			ArrayList feeValues = new ArrayList();
     			    			System.out.println(" ====diling===f046.jsp=====  tmp="+tmp);	
     			    			if("000000".equals(retCodeFee)){
     			    			  if(retFee.length>0){
     			    			    v_isDisabledBtnFlag = "N";
     			    			    /*
     			    			    for(int ii=0;ii<retFee.length;ii++){
     			    			      feeValues.add(ii,retFee[ii][0]);
     			    			    }
     			    			    out.print("feeOrder.push('<select style=width:100px onchange=changeKDvalues(this.value)>");	//ѹ�����JS������
     			    			    for(int z=0;z<feeValues.size();z++){
       			    			    if(tmp.equals((String)feeValues.get(z))){
     			    			        checkFlag = "selected";
     			    			      }else{
     			    			        checkFlag = "";
     			    			      }
     			    			      System.out.println(" ====diling===f046.jsp=====  feeValues.get("+z+")="+feeValues.get(z));	
     			    			       out.print("<option value="+(String)feeValues.get(z)+" "+checkFlag+">"+(String)feeValues.get(z)+"</option>");
     			    			    }
     			    			   
     			    			    out.print("</select>');");	
     			    			    */
     			    			    out.print("feeOrder.push('<select name=chuzhuangfei style=width:100px onchange=changeKDvalues(this.value) onclick=getNowSelectVal(this.value)>");	//ѹ�����JS������
     			    			    for(int ii=0;ii<retFee.length;ii++){
     			    			     System.out.println(" ====diling===f046.jsp===== retFee["+ii+"]="+retFee[ii][0]);	
                          if(tmp.equals(retFee[ii][0])){
                            checkFlag = "selected";
                          }else{
                            checkFlag = "";
                          }
     			    			      out.print("<option value="+retFee[ii][0]+" "+checkFlag+">"+retFee[ii][0]+"</option>");
     			    			    }
     			    			    out.print("</select>');");	
     			    			  }else{
     			    			  %>
     			    			    rdShowMessageDialog("û�л�ȡ����װ�ѣ�������룺<%=retCodeFee%><br>������Ϣ��<%=retMsgFee%>!",0);	
     			    			  <%
     			    			    v_isDisabledBtnFlag = "Y";
     			    			    out.println("feeOrder.push('<select style=width:100px onchange=changeKDvalues(this.value)><option value= ></option></select>');");
     			    			  }
     			    			}else{
     			    			%>
     			    			  rdShowMessageDialog("��ȡ��װ�Ѵ��󣡴�����룺<%=retCodeFee%><br>������Ϣ��<%=retMsgFee%>!",0);	
     			    			<%
     			    			  v_isDisabledBtnFlag = "Y";
     			    			  out.println("feeOrder.push('<select style=width:100px onchange=changeKDvalues(this.value)><option value= ></option></select>');");
     			    			}
                     //out.println("feeOrder.push('<select style=width:100px onchange=changeKDvalues(this.value)><option value=100.00 "+chedk11+">100.00</option><option value=90.00 "+chedk10+">90.00</option><option value=80.00 "+chedk1+">80.00</option><option value=70.00 "+chedk2+">70.00</option><option value=60.00 "+chedk3+">60.00</option><option value=50.00 "+chedk4+">50.00</option><option value=40.00 "+chedk5+">40.00</option><option value=30.00 "+chedk6+">30.00</option><option value=20.00 "+chedk7+">20.00</option><option value=10.00 "+chedk8+">10.00</option><option value=0.00 "+chedk9+">0.00</option></select>');");	//ѹ�����JS������
     			    		   /*end diling add for ��̬�����ݿ��л�ȡ��װ��@2012/9/19 */	
     			    		 }else {
     			  		    out.println("feeOrder.push('" + tmp + "');");	//ѹ�����JS������
     			  		    %>
     			  		    	
     			  		    <%
     			  		    System.out.println(" ====gaopengSeeLogtmp===== "+tmp);
     			  		    }
     			    	  }
     			    	  		if("0".equals(master_serv_type)){	//�����C��ҵ��,��ȡ��ʽΪselStrCdma	,������ı䶨����changeFeeWay����
     			    	 	 %>
     			    	  		feeOrder.push("<select v_type='feeWay' style='width:100px' name='feeWay<%=m%>_<%=n%>' onchange='changeFeeWay()'><%=selStrCdma%></select>");
     			    	   <%
     			    	   		}else{	//����ΪselStr
     			    	   %>
     			    	   		feeOrder.push("<select v_type='feeWay' style='width:100px' name='feeWay<%=m%>_<%=n%>' onchange='changeFeeWay()'><%=selStr%></select>");
     			    	   <%	}
     			    	  		if("9004".equals(uuu.getValue(1))){//ѡ�ŷ�Ĭ�ϲ���ӡ�ڷ�Ʊ�� ��ӡ��ʽ�ı�ʱ,���仯��ֵ�����isPrint������,����ͬ����ӡ��ʽ
     			    	   %>		
		     						feeOrder.push("<select v_type='isPrint' style='width:100px' name='isPrint<%=m%>_<%=n%>' onchange='g(v_type).value=this.options[selectedIndex].value'><br><option value='T'>��ӡ</option><option selected value='F'>����ӡ</option></select>");
		     					<%}else{
		     					%>
		     						feeOrder.push("<select v_type='isPrint' style='width:100px' name='isPrint<%=m%>_<%=n%>' onchange='g(v_type).value=this.options[selectedIndex].value'><br><option selected value='T'>��ӡ</option><option value='F'>����ӡ</option></select>");
		     					<%}
		     					
		     						String feeCodeSeq            = 		uuu.getValue(8).trim();	   //������ϸ���   	
		     						String factorType    		 = 		uuu.getValue(9).trim();    //������������      
		     						String factorCode            = 		uuu.getValue(10).trim();    //�������Ӵ���      
		     						String factorValueBegin      = 		uuu.getValue(11).trim();   //����������ʼֵ    
		     						String factorValueEnd        = 		uuu.getValue(12).trim();   //�������ӽ���ֵ    
		     						String factorDetailCode      = 		uuu.getValue(13).trim();   //����������ϸ����  
		     						String offerId               = 		uuu.getValue(14).trim();   //����Ʒ��ʶ     
		     						String feeParams			 =   	feeCodeSeq + "~" + factorType + "~" + factorCode + "~" + factorValueBegin + "~" + factorValueEnd + "~" + factorDetailCode + "~" + offerId;
		     						System.out.println(".........feeParams = "+feeParams);
		     						
		     					%>
		     					feeOrder.push("<input type='hidden' name='feeParams<%=m%>_<%=n%>' value=<%=feeParams%>><%=uuu.getValue(6)%>");
     			    	  <%
     			      } 
     			    }
     			    out.println(" allFeeArray.push(feeOrder);");
     			  }%>
     			  
     			 
     	<%
       }   
				System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@servOrders =  "+servOrders);
				Iterator it = prtFlagSet.iterator(); 
				while(it.hasNext()){
 					String prtFlagTmp =(String) it.next();
					out.println("prtFlagSet.push('" + prtFlagTmp + "');");
				}

		}else{%>
					rdShowMessageDialog("�ͻ�������ϸ��Ϣ��ѯʧ��!",0);	
					feeFlag = "1";
		<%}%>
</script>


<%

//2010-7-2 19:27 wanghfa���� ��ͨ��������������޸� start
		boolean isTT = false;
		String searchSql = "select count(*) from dloginmsg a,dchngroupmsg b where a.GROUP_ID=b.group_id and b.class_code='200' and a.login_no = '" + loginNo + "'";
%>
		<wtc:pubselect name="sPubSelect" outnum="1" retcode="retCode2" retmsg="retMsg2">
			<wtc:sql><%=searchSql%></wtc:sql>
		</wtc:pubselect>
		<wtc:array id="result2" scope="end"/>
<%
		if ((!"0".equals(result2[0][0])) && (servPhoneNo.substring(0,3).equals("451") || servPhoneNo.substring(0,3).equals("045") || servPhoneNo.substring(0,3).equals("046"))) {
			isTT = true;
			System.out.println("============wanghfa=============�Ƿ�Ϊ��ͨ������ ��");
		} else {
			isTT = false;
			System.out.println("============wanghfa=============�Ƿ�Ϊ��ͨ������ ��");
		}
//2010-7-2 19:27 wanghfa���� ��ͨ��������������޸� end
%>

<%
  if("0".equals(feeFlag.trim())){	// ��ѵ�,ֱ�������ɷ�
%>
    <script language="javaScript">
     window.location = "/npage/sq046/fq046_3.jsp?<%=PageListNav.writeRequestUrl(parametersMap)%>&arrayOrder="+"<%=arrayOrders%>"+"&servOrder="+"<%=servOrders%>";
    </script>
  <%  
  }else{
  	String sql = "SELECT create_accept FROM dservordermsg WHERE serv_order_id ='"+servOrder+"'";
  	System.out.println("sOrderItemShowsOrderItemShowsOrderItemShowsOrderItemShowsOrderItemShowsOrderItemShow"+sql);
%>
<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode5" retmsg="retMsg5" outnum="1">
	<wtc:sql><%=sql%></wtc:sql>
</wtc:pubselect>
<wtc:array id="result5" scope="end" />
<%

%>
<!--����sOrderItemShow����,���ؿͻ�����custOrderId�µ����ж�������,���񶩵�,�ͷ��ÿ�Ŀ,�����д���=====END-->	
<script type="text/JavaScript">
	  var selStr = "";
	  var selStrCdma = "";
	  var closeFlag = false;	//����ӪҵԱ�Ƿ�����,��ɴ������շѶ���,�ڷǷ��رսɷѽ����,����onbeforeonload��¼��־,�趨��һ����־λ
	  
    $(document).ready(function(){/*diling add for ���ȡ������װ�ѣ����ܽ���ͳһ�ɷ�@2012/9/19 */
      if("<%=v_isDisabledBtnFlag%>"=="Y"){
        $("#fee_submit").attr("disabled",true);
      }else{
        $("#fee_submit").attr("disabled",false);
      }
    });
 	  window.onload=function(){
   			
		   	$("#sys_note").val("����Ա<%=loginNo%>�Զ���<%=custOrderId%>����<%=opName%>����");
		   	
		  	var prnFlag = "<%=prtFlag%>";
		  	if(prnFlag == "Y"){
		  	}
		  	
		  	if("<%=feeFlag%>"!="0")
		  	{
					g("tbl0").innerHTML='<table  cellSpacing=0  id="listdiv2"><tr><th>�ͻ��������</th><th>�ͻ�����������</th><th>ҵ���������</th><th>����Ʒ</th><th>��������״̬</th><th>����ʱ��</th><th>����Ա��</th></tr></table>';
					g("tbl1").innerHTML='<table   cellSpacing=0 id="servtbl"><tr><th>���񶨵���</th><th>�ͻ����������</th><th>ҵ�����</th><th>�û�����</th><th>��������</th><th>�ɷ�״̬</th> </tr></table>';
					g("tbl2").innerHTML="<table   cellSpacing=0 id='feetbl'><tr><th>���񶨵���</th><th>���ÿ�Ŀ</th><th>Ӧ�ս��</th><th style=\"display:none\">�Żݽ��</th><th>ʵ�ս��</th><th>��ȡ��ʽ</th><th>��ӡ</th><th>˵��</th></tr></table>";
					selStr = "<%=selStr%>";
					selStrCdma = "<%=selStrCdma%>";
					addTr046('listdiv2','1',arrayOrder ,7);	//�����������б�
					addTr046('servtbl','1',servOrder ,6);		//�����񶨵��б�
					var radioObj = document.getElementsByName("servOrders"); 
					radioObj[0].checked = true;		//ѡ��һ�����񶨵�,���񶩵�ǰ���radioֻ������ѡ����������
					//for(var i =allFeeArray.length-1 ; i>=0; i--){	//ѭ���������б�,һ�����񶩵�һ�������б�,������ʾ
					for(var i =0 ; i<allFeeArray.length; i++){	//ѭ���������б�,һ�����񶩵�һ�������б�,������ʾ
						var tableName = "tbl"+servOrderNoArray[i];	//�����б�������: tbl+���񶩵���
						if(i == 0){				
							g("tbl2").innerHTML ="<table   cellSpacing=0 id='"+ tableName +"'><tr class='showhand'><th>���񶨵���&nbsp;&nbsp; <span id='span"+servOrderNoArray[i]+"' style='cursor:pointer;color:#ff9900' onclick='showhand(this)'>������ϸ</span></th><th>���ÿ�Ŀ</th><th>Ӧ�ս��</th><th  style=\"display:none\">�Żݽ��</th><th>ʵ�ս��</th><th>��ȡ��ʽ</th><th>��ӡ</th><th>˵��</th></tr></table>";			
						}else{				
							g("tbl2").innerHTML = g("tbl2").innerHTML + "<table   cellSpacing=0  id='"+ tableName +"'><tr class='showhand'><th>���񶨵���&nbsp;&nbsp; <span id='span"+servOrderNoArray[i]+"' style='cursor:pointer;color:#ff9900' onclick='showhand(this)'>������ϸ</span></th><th>���ÿ�Ŀ</th><th>Ӧ�ս��</th><th style=\"display:none\">�Żݽ��</th><th>ʵ�ս��</th><th>��ȡ��ʽ</th><th>��ӡ</th><th>˵��</th></tr></table>";
						}
						
						var rowIndex = g(tableName).rows.length;
						addTr046(tableName,"1",allFeeArray[i] ,8);
					
					}
					g("arrayOrder").value = "<%=arrayOrders%>";
					g("servOrder").value = "<%=servOrders%>";
					document.all.form1.totalFee1.value= totalFee1;
					document.all.form1.totalFee2.value= Number(totalFee2) + Number("<%=totalOpFee%>");
					document.all.form1.totalFee3.value= totalFee3;


					//2010-7-2 19:27 wanghfa���� ��ͨ��������������޸� start
<%
					if (isTT == true) {
%>
						document.all.form1.totalFee1.value= "0";
						document.all.form1.totalFee2.value= "0";
						document.all.form1.totalFee3.value= "0";
<%
					}
%>
					//2010-7-2 19:27 wanghfa���� ��ͨ��������������޸� end
		  	}
			//2010-7-2 19:27 wanghfa���� ��ͨ��������������޸� start
<%
			if (isTT == true) {
%>
			submit_cfm();
<%
			}
%>
			//2010-7-2 19:27 wanghfa���� ��ͨ��������������޸� end
			var a = 0;
			var realPayFeeObj;
			while(true) {
				realPayFeeObjs = document.getElementsByName("realPayFee" + a + "_4");
				if (realPayFeeObjs.length > 0) {
					if (realPayFeeObjs[0].v_feeCode == "9001") {
						realPayFeeObjs[0].value = "0";
					}
					
					var inputObj = realPayFeeObjs[0]; 
					
					var feeValue = inputObj.value;
					var trObj = inputObj.parentNode.parentNode;
					var objs = trObj.childNodes;
					var inputObjOld =  objs[4].childNodes[1];	//ʵ���ı�����һ��������,����ǰʵ�ո���,���ڷǷ������Ļָ�
					if(!validateElement(inputObj)){
						inputObj.value = inputObjOld.value;
						return false;	
					}
					var opFee = objs[4].childNodes[2];// ʵ���ı����ڶ���������,�浱ǰӪҵ�Żݶ�
					var ningtnVal = "";
					if($(objs[2]).find("select").length > 0){
						ningtnVal = $(objs[2]).find("select").val();
					}else{
						ningtnVal = objs[2].innerHTML;
					}
					var feeCodeVal = inputObj.v_feeCode;
					var opValueTmp = Number(ningtnVal)-Number(objs[3].innerHTML)-Number(inputObj.value) ;//ʵ�ոı��,�µ�ӪҵԱ�Ż� = Ӧ��-����-��ʵ��
					/* ��ͨ�������û�������������õ����Ԥ��� */
					if("<%=opcodeadd%>" == "4977" && (joinMarket != "on" || feeCodeVal == "9003")){
						//alert(Number(inputObj.value)+"---"+Number(ningtnVal));
						var valueTemp = Number(inputObj.value) + Number("<%=intePrice %>") - Number(ningtnVal);
						if(valueTemp < 0){
							inputObj.value = inputObjOld.value;
							
							rdShowMessageDialog("ʵ�ս���С��Ӧ�ս��!",0);	
							return false;
						}
						if(feeCodeVal == "200" && "<%=v_smCode%>" == "kh" && "<%=monthFlag%>" == "true"){
							var monthMoney = Number("<%=monthFee%>");
							if(Number(inputObj.value)%monthMoney != 0 && monthMoney!=0){
								rdShowMessageDialog("ʵ�ս�������"+monthMoney+"��������!",0);	
								return false;
							}
							
						}
					}
					g("totalFee2").value = Number(g("totalFee2").value) + opValueTmp - Number(opFee.value);//���Ż�+���Ż�-���Ż�(���Ų���)
					opFee.value = opValueTmp;	//����ҲҪ����,���ӳ���Ҫ��үү��	--������Χ�۵�
					
				  g("totalFee3").value = Number(g("totalFee3").value) + Number(feeValue) - Number(inputObjOld.value);	//��ʵ�� ,ȥ�ɼ���
				  inputObjOld.value = feeValue;	//����ҲҪ����,���ӳ���Ҫ��үү��
			 	  //alert(objs[4].childNodes[2].value);
				} else {
					break;
				}
				a ++;
			}
		}
		  
			   /*
		        * ��ʾ�����ط����б�
		       */ 
			  function showhand(srcObj){
					var s = srcObj.innerHTML;
					var tblObj = srcObj.parentNode.parentNode.parentNode;
					var trObjs = tblObj.childNodes;
				if(s.indexOf("������ϸ") >= 0){
					for(i=1;i<trObjs.length;i++)
					{
						trObjs[i].style.display="none";
					}
					srcObj.innerHTML="��ʾ��ϸ";
				}else if (s.indexOf("��ʾ��ϸ") >= 0) {
					for(i=1;i<trObjs.length;i++)
					{
						 trObjs[i].style.display="";
					}
					srcObj.innerHTML="������ϸ";
				}
			}

			/*
	        * ������ÿ�Ŀǰ���radio,�ͻ���ʾ������б�
	       	*/
			function showMyFee(servOrderNo){
				var obj = g("span"+servOrderNo);
				obj.innerHTML="��ʾ��ϸ";
				showhand(obj);	
			}
		  
		   /*
	        * ��ǰ��ajax��ʽ���÷��ò�ѯ,����������ѵ����߽ɷ�ҳ�������,�������ַ�ʽ��
	       	*/
		 /* function initData(){
		  		var myPacket = new AJAXPacket("/npage/sq046/fq046_ajax.jsp","���ڻ�÷�����Ϣ�����Ժ�......");
		  		myPacket.data.add("retType","showAll");
		  		myPacket.data.add("custOrderId","<%=custOrderId%>");
		  		myPacket.data.add("opCode","<%=opCode%>");
		  		core.ajax.sendPacket(myPacket);
			    myPacket=null;
		  }*/
		  
		   /*
	        * �ı���ȡ��ʽ,�����ϵͳ����Ԥ��(4)��ʽʱ,����ӡ��ʽ��Ϊ����ӡ,������ӡ����Ʊ
	       	*/
		  function changeFeeWay(){
		  	var srcObj = event.srcElement;
		  	g(srcObj.v_type).value=srcObj.options[srcObj.selectedIndex].value;	
		  	var trobj = srcObj.parentNode.parentNode;
		  	var tdobjs = trobj.childNodes;
		  	// alert(srcObj.options[srcObj.selectedIndex].value);
		  	if(srcObj.options[srcObj.selectedIndex].value == "4"){
		  		tdobjs[6].childNodes[0].value='F'	;
		  		g(tdobjs[6].childNodes[0].v_type).value = tdobjs[6].childNodes[0].value;	
		  	}else{
		  		tdobjs[6].childNodes[0].value='T'	;	
		  		g(tdobjs[6].childNodes[0].v_type).value=tdobjs[6].childNodes[0].value;
		  	}
		  }
		  
       /*
        *��̬ɾ����
       */ 
     function delTr046(serverOrderNo,tableName){
          var obj = document.getElementById(tableName);
     	    var trObjs = obj.childNodes[0].childNodes;
     	    for ( var i =1; i < trObjs.length; i++)	{
     	    			 var tdObjs = trObjs[i].childNodes;
     	    	     var inputObj = tdObjs[0].childNodes[0];
     	    	     if(inputObj.v_parent == serverOrderNo){
     	    	       if(tableName == "servtbl"){delTr046(inputObj.value,"feetbl");}
     	    	       if(tableName == "feetbl"){
     	    	       		document.all.form1.totalFee1.value= Number(document.all.form1.totalFee1.value)-Number(tdObjs[1].innerHTML);
      								document.all.form1.totalFee2.value= Number(document.all.form1.totalFee2.value)-Number(tdObjs[2].innerHTML)-Number(tdObjs[4].childNodes[0].value);
      								document.all.form1.totalFee3.value= Number(document.all.form1.totalFee3.value)-Number(tdObjs[3].childNodes[0].value);
      								document.all.form1.fee_submit.disabled=true;
     	    	       }
	                 trObjs[i].parentNode.removeChild(trObjs[i]);
	 		      			 i--;    
                 }  
     	    }         
     }
     
       /*
        *ʵ�ս��,����niuycҪ��,ȡ��ӪҵԱ�Ż�,�ſ��ı�ʵ�ս���Ȩ��,Ӫ��=Ӧ��-����-ʵ�� ,���������ֶ�
       */ 	
       
			function changeRealPayFee(){
				var inputObj = event.srcElement; 
				
				var feeValue = inputObj.value;
				var trObj = inputObj.parentNode.parentNode;
				var objs = trObj.childNodes;
				var inputObjOld =  objs[4].childNodes[1];	//ʵ���ı�����һ��������,����ǰʵ�ո���,���ڷǷ������Ļָ�
				if(!validateElement(inputObj)){
					inputObj.value = inputObjOld.value;
					return false;	
				}
				var opFee = objs[4].childNodes[2];// ʵ���ı����ڶ���������,�浱ǰӪҵ�Żݶ�
					var ningtnVal = "";
					if($(objs[2]).find("select").length > 0){
						ningtnVal = $(objs[2]).find("select").val();
					}else{
						ningtnVal = objs[2].innerHTML;
					}
				var feeCodeVal = inputObj.v_feeCode;	
				var opValueTmp = Number(ningtnVal)-Number(objs[3].innerHTML)-Number(inputObj.value) ;//ʵ�ոı��,�µ�ӪҵԱ�Ż� = Ӧ��-����-��ʵ��
				
				/* ��ͨ�������û�������������õ����Ԥ��� */
				if("<%=opcodeadd%>" == "4977"){
					var valueTemp = Number(inputObj.value) + Number("<%=intePrice %>") - Number(ningtnVal);
					if(valueTemp < 0){
						inputObj.value = inputObjOld.value;
						rdShowMessageDialog("ʵ�ս���С��Ӧ�ս��!",0);	
						return false;
					}
					/*2015/01/19 14:02:24 gaopeng ��ͨ�ں����� ����ƷԤ��ʱ��ʵ�ս�������sql����ѯ���Ľ���������*/
					if(feeCodeVal == "200" && "<%=v_smCode%>" == "kh" && "<%=monthFlag%>" == "true"){
							var monthMoney = Number("<%=monthFee%>");
							if(Number(inputObj.value)%monthMoney != 0 ){
								rdShowMessageDialog("ʵ�ս�������"+monthMoney+"��������!",0);	
								return false;
							}
							/*��ֵӦ��Ϊʵ������*/
							//objs[2].innerHTML = inputObj.value;
					}
				}
					/*2015/01/19 14:05:41 gaopeng ���»�ȡһ��Ӧ�ս��*/
					if($(objs[2]).find("select").length > 0){
						ningtnVal = $(objs[2]).find("select").val();
					}else{
						ningtnVal = objs[2].innerHTML;
					}
					var chuzhuangfei = $("select[name='chuzhuangfei']").find("option:selected").val();
				
					var oldTotalFee1All = g("totalFee1").value; 
				
					//2015/01/19 14:27:15 gaopeng Ӧ���ܶ� = ʵ���ܶ�+Ӧ��-ʵ��
					g("totalFee1").value = Number(g("totalFee3").value) + Number(feeValue) - Number(inputObjOld.value) + Number(ningtnVal) - Number(inputObj.value);	
					
					g("totalFee2").value = Number(g("totalFee2").value) + opValueTmp - Number(opFee.value);//���Ż�+���Ż�-���Ż�(���Ų���)
					opFee.value = opValueTmp;	//����ҲҪ����,���ӳ���Ҫ��үү��	--������Χ�۵�
					
				  g("totalFee3").value = Number(g("totalFee3").value) + Number(feeValue) - Number(inputObjOld.value);	//��ʵ�� ,ȥ�ɼ���
				  inputObjOld.value = feeValue;	//����ҲҪ����,���ӳ���Ҫ��үү��
			 	  //alert(objs[4].childNodes[2].value);
			}
	
			/*
	        *��������,��ȡԪ��
	       */ 	
			function g(objectId) 
			{
				if (document.getElementById && document.getElementById(objectId))
				{
					return document.getElementById(objectId);
				}
				else if (document.all && document.all[objectId])
				{
					return document.all[objectId];
				}
				else 
				{
					return false;
				}
			}
	
	
			 /*
	        *��̬������
	       */ 					
			function addTr046(tableID,trIndex,arrTdCont,colNum)
			{
				if(colNum == "undefined")
					colNum = 1;
				var tableId=g(tableID);
				var insertTr=new Array();
				for(var i = 0 ; i < (arrTdCont.length/colNum); i++){
						var k =1+i*colNum;
						//alert(tableID.indexOf("tbl") + "::" +  arrTdCont[k].indexOf("value=2"));
						if(tableID.indexOf("tbl") == 0 && (arrTdCont[k].indexOf("value=22") != -1 || arrTdCont[k].indexOf("value=2") != -1 || arrTdCont[k].indexOf("value=200") != -1 || arrTdCont[k].indexOf("value=20") != -1 || arrTdCont[k].indexOf("value=21") != -1)){
							insertTr[i] = tableId.insertRow(1);		
						}else{
							insertTr[i] = tableId.insertRow(trIndex);			
						}
						var arrTd=new Array();				
						for(var j = 0;j < colNum;j++)
						{
							
							arrTd[j]=insertTr[i].insertCell(j);
							if(tableID.substring(0,3)=="tbl"&&j==1){
								arrTdCont[i*colNum+j] = arrTdCont[i*colNum+j].replace("type='text'","type='text' readOnly class='InputGrey'");
								//alert(arrTdCont[i*colNum+j]);
							}
							arrTd[j].innerHTML = arrTdCont[i*colNum+j];
							//alert(arrTd[j].innerHTML);
							if(tableID.substring(0,3)=="tbl"&&j==3){
								arrTd[j].style.display="none";
							}
							
						}
						trIndex  = Number(trIndex)+1;
						
					}
			}
 
	  	 /*
        *�ص�����
       */ 
     	function doProcess(packet)
     	{
	     		/*tianyang add for pos�ɷ� start*/
					var verifyType = packet.data.findValueByName("verifyType");
					var sysDate = packet.data.findValueByName("sysDate");
					if(verifyType=="getSysDate"){
						document.all.Request_time.value = sysDate;
						return false;
					}
					/*tianyang add for pos�ɷ� end*/
     	}
     
       /*
        *ͬ���ɷѷ�ʽ���Ƿ��ӡ
       */ 
	     function changeAll(vType){
	          var selValue = g(vType).value;
	          var obj = document.form1.elements;
	          for(var i = 0 ; i< obj.length; i ++){
	               if(obj[i].v_type == vType){
	                    var objs = obj[i].childNodes;
	               	 for(var j = 0 ; j < objs.length ; j ++ ){
	               	     if(objs[j].value == selValue){
	               	          objs[j].selected = true;    
	               	     }
	               	 }
	               }
	          }
	     }
	     
	     var custId = "";
function formatNumber(feeValue){
	
	feeValue = feeValue+"";
	if(feeValue.indexOf("\.")!=-1){
		feeValue = feeValue+"00";
	}else{
		feeValue = feeValue+".00";
	}
	return feeValue.substring(0,feeValue.indexOf("\.")+3);
	
}  

var chinaFee = "";
function showPrtDlgbill(printType,DlgMessage,submitCfm){
	var printInfo = "";
	var printInfo1 = "";
	for (var m = 0 ; m < prtFlagSet.length; m ++){
	     			var arrayOrderId = prtFlagSet[m].split("~")[0];
	     			var prtLoginAccept = prtFlagSet[m].split("~")[1];
	     			var opType = "";
	     			var custName = "";
	     			var phoneNo = "";
	     			var userId = "<%=gCustId%>"
	     			var checkNo = "";
	     			
 						var machFee = 0;
 						var simFee = 0;
 						var fee_sumPay = 0;
 						var cashPay = "";
 						var posPay = "0.00"; 						
 						if(document.all.payType.value=="BX" || document.all.payType.value=="BY"){
 							posPay = document.all.totalFee3.value; 							
 						}else{
 							cashPay = document.all.totalFee3.value;
 						}
 						var checkPay = document.all.checkPay.value;
 						
  	
  	var note = custId + phoneNo + "��ͨ����" + "�ֽ�" + cashPay + "֧Ʊ�" + checkPay + "POS���" + posPay;
  	
    printInfo = "<%=loginNo%>|";            //����
    printInfo = printInfo + prtLoginAccept + "|";         //��ˮ
    
    $("#servtbl :radio").each(function(i){
   			if(this.checked){
   				opType   = $(this).parent().parent().find("td:eq(4)").text();
   				custName = $(this).parent().parent().find("td:eq(3)").text();
   				phoneNo  = $(this).parent().parent().find("td:eq(2)").text();
   			}
 		});
 		
  	     	  var tableName = "tbl"+servOrderNoArray[0];
	     	  	var tabobj = g(tableName);
	     	  
				for(i=1; i < tabobj.rows.length; i++){
						var feename = tabobj.rows(i).cells(1).children[1].value;
						if(feename == "SIM������"){
							simFee  +=parseInt(tabobj.rows(i).cells(4).children[0].value);
						}else if(feename.indexOf("Ԥ��")!=-1){
							fee_sumPay +=parseInt(tabobj.rows(i).cells(4).children[0].value);
						}else if(feename.indexOf("������")!=-1){
							machFee +=parseInt(tabobj.rows(i).cells(4).children[0].value);
						}
				}
 
 		
    printInfo = printInfo + opType+"������ϸ" + "|";  
    printInfo +="<%=new java.text.SimpleDateFormat("yyyy",Locale.getDefault()).format(new java.util.Date())%>"+"|";
    printInfo += "<%=new java.text.SimpleDateFormat("MM",Locale.getDefault()).format(new java.util.Date())%>"+"|";
    printInfo += "<%=new java.text.SimpleDateFormat("dd",Locale.getDefault()).format(new java.util.Date())%>"+"|";
    printInfo = printInfo + custName + "|";         //�û���
    printInfo += "|";         //����
    printInfo = printInfo + phoneNo + "|";         //�ֻ���
    printInfo = printInfo + userId + "|";        //Э�����
    printInfo = printInfo + document.all.checkNo.value + "|";       //֧Ʊ����
    printInfo = printInfo + document.all.totalFee3.value + "|"; //��д
    printInfo = printInfo + document.all.totalFee3.value + "|"; //Сд
    printInfo = printInfo + "SIM���ѣ� " + simFee + "~";           //SIM����
    printInfo = printInfo + "����Ԥ��ѣ�" + fee_sumPay + "~";     //����Ԥ��
    printInfo = printInfo + "�ֽ�" + cashPay + "~";          //�ֽ��
    printInfo = printInfo + "֧Ʊ�" + checkPay + "~";       //֧Ʊ��
    printInfo = printInfo + "POS���" + posPay + "~";          /** tianyang add for pos **/
    printInfo = printInfo + "�����ѣ�  " + machFee + "~";          //������
    printInfo = printInfo + "��ע��    " + note + "|";                       //��ע
    printInfo += " |";
    printInfo += " |";
    printInfo += " |";
    printInfo += " |";
    printInfo += " |";
//1		|2	 |3				|4 |5 |6 |7				|8	 |9				|10			 |11			|12						 |13				|14-?		 |15		|16		 |17		|18									 |19			|20-28
//����|��ˮ|ҵ������|��|��|��|�û�����|����|�ƶ�̨��|Э�����|֧Ʊ����|�ϼƽ��(��д)|���(Сд)|ҵ����Ŀ|����Ա|�տ�Ա|IMEINo|�Ƿ����������Ʒ�|֧����ʽ|POS�ɷ���Ŀ
    
    /********tianyang add at 20090928 for POS�ɷ�����****start*****/
    if(document.all.payType.value=="BX" || document.all.payType.value=="BY"){
			printInfo = printInfo + document.all.MerchantNameChs.value + "|";	     	
			printInfo = printInfo + document.all.CardNoPingBi.value + "|";
			printInfo = printInfo + document.all.MerchantId.value + "|";
			printInfo = printInfo + document.all.BatchNo.value + "|";
			printInfo = printInfo + document.all.IssCode.value + "|";
			printInfo = printInfo + document.all.TerminalId.value + "|";
			printInfo = printInfo + document.all.AuthNo.value + "|";
			printInfo = printInfo + document.all.Response_time.value + "|";
			printInfo = printInfo + document.all.Rrn.value + "|";
			printInfo = printInfo + document.all.TraceNo.value + "|";
			printInfo = printInfo + document.all.AcqCode.value + "|";
			printInfo = printInfo + "|";
    }
    /********tianyang add at 20090928 for POS�ɷ�����****end*******/
    
  }
  
	var h=210;
	var w=400;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;
	var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no" 
	var path = "/npage/innet/pubBillPrintCfm.jsp?dlgMsg=" + DlgMessage;
	var loginAccept = prtLoginAccept;
	var path = path + "&infoStr="+printInfo+"&loginAccept="+loginAccept+"&opCode=<%=opCode%>&submitCfm=submitCfm";
	var ret = window.showModalDialog(path,"",prop);
}	     

function showBroadKdZdBill(printType,DlgMessage,submitCfm){
			
	var printInfo = "";
	var prtLoginAccept = "";
	var iccidtypess="<%=custditypesnames%>";
	var iccidnoss="<%=custiccids%>";
	var fysqfss="";
	var  billArgsObj = new Object();
	for (var m = 0 ; m < prtFlagSet.length; m ++){
		var arrayOrderId = prtFlagSet[m].split("~")[0];
		prtLoginAccept = prtFlagSet[m].split("~")[1];
		var opType = "";
		var custName = "";
		var phoneNo = "";
		var feeName = "�����ն˷���";
		var cashPay = document.all.totalFee3.value;
	  $("#servtbl :radio").each(function(i){
 			if(this.checked){
 				opType   = $(this).parent().parent().find("td:eq(4)").text();
 				custName = $(this).parent().parent().find("td:eq(3)").text();
 				phoneNo  = $(this).parent().parent().find("td:eq(2)").text();
 			}
 		});
 		/*2014/09/11 15:18:07 gaopeng �����ʷ�չ�ּ��ն˹���������ϵͳ֧���Ż�����
	  		���� �����豸�ն˿� 
	  	*/
	  	
	  	
	  	var shuilv = 0.17;
	  	
	  	
	  	var kdZdFee = "";
	  	var danjia = 0;
	  	var shuie = 0;
  	var tableName = "tbl"+servOrderNoArray[0];
  	var tabobj = g(tableName);
		for(i=1; i < tabobj.rows.length; i++){
				var feename = tabobj.rows(i).cells(1).children[1].value;
				 if(feename.indexOf("�����豸�ն˿�")!=-1){
					kdZdFee += parseInt(tabobj.rows(i).cells(4).children[0].value);
				}
				 if(feename.indexOf("�����豸�ն�Ѻ��")!=-1){
					kdZdFee += parseInt(tabobj.rows(i).cells(4).children[0].value);
					fysqfss="zsj";
					/*2016/7/25 10:55:51 gaopeng ���ڼ��ſ�����ƷBOSS���ο��������� 
	  				ki  Ѻ���ʱ�� ˰��Ϊ0
	  			*/
	  			if("<%=v_smCode%>" == "ki" ){
	  				shuilv = 0.00;
	  			}
				}				
		}
		
		danjia = Number(kdZdFee) - Number(kdZdFee)*shuilv;
		shuie = Number(kdZdFee)*shuilv;
		getBroadMsg(phoneNo);
 		
			$(billArgsObj).attr("10001","<%=loginNo%>");     //����
			$(billArgsObj).attr("10002","<%=new java.text.SimpleDateFormat("yyyy",Locale.getDefault()).format(new java.util.Date())%>");
			$(billArgsObj).attr("10003","<%=new java.text.SimpleDateFormat("MM",Locale.getDefault()).format(new java.util.Date())%>");
			$(billArgsObj).attr("10004","<%=new java.text.SimpleDateFormat("dd",Locale.getDefault()).format(new java.util.Date())%>");
			$(billArgsObj).attr("10005",custName);   //�ͻ�����
			$(billArgsObj).attr("10006","��������");    //ҵ�����
			$(billArgsObj).attr("10008",phoneNo);    //�û�����
			$(billArgsObj).attr("10015", kdZdFee+"");   //���η�Ʊ���
			$(billArgsObj).attr("10016", kdZdFee+"");   //��д���ϼ�
			$(billArgsObj).attr("10017","*");        //���νɷѣ��ֽ�
			/*10028 10029 ����ӡ*/
		  $(billArgsObj).attr("10028","");   //�����Ӫ������ƣ�
			$(billArgsObj).attr("10029","");	 //Ӫ������	
			$(billArgsObj).attr("10030",prtLoginAccept);   //��ˮ�ţ�--ҵ����ˮ
			$(billArgsObj).attr("10036","<%=opcodeadd%>");   //��������
			/* 2015/04/20 14:42:32 gaopeng ��ONT CPE <%=kdZdType%>��Ϊͳһ�� �����ն˷��� */
			$(billArgsObj).attr("10042","̨");                   //��λ
			$(billArgsObj).attr("10043","1");	                   //����
			$(billArgsObj).attr("10044",kdZdFee+"");	                //����
			/*10045����ӡ*/
			$(billArgsObj).attr("10045","");	       //IMEI
			/*�ͺŲ���*/
			$(billArgsObj).attr("10061","");	       //�ͺ�
			$(billArgsObj).attr("10062",shuilv+"");	//˰��
			$(billArgsObj).attr("10063",shuie+"");	//˰��	   
	    $(billArgsObj).attr("10071","6");	//˰��	
	 		$(billArgsObj).attr("10076",danjia+"");
	 		$(billArgsObj).attr("10077", kdZdFee+""); //�����ն˽��
 			$(billArgsObj).attr("10078", "<%=v_smCode%>"); //����Ʒ��			
 			
 			if(fysqfss=="zsj") {
 			$(billArgsObj).attr("10083", iccidtypess); //֤������
 			$(billArgsObj).attr("10084", iccidnoss); //֤������
 			$(billArgsObj).attr("10085", fysqfss); //����������ȡ��ʽ
 			$(billArgsObj).attr("10086", "�𾴵��û���������������������ʱ����Я��ONT�豸��Ѻ��Ʊ����Ч֤�������ƶ�ָ������Ӫҵ����������Ѻ��"); //��ע
 			$(billArgsObj).attr("10041", "�����ն�Ѻ�����");           //Ʒ����� ʵ���ǿ����ն�����
 			$(billArgsObj).attr("10065", $("#broadNo").val()); //�����˺�
 			
 			}else {
 			$(billArgsObj).attr("10041", "�����ն˷���");           //Ʒ����� ʵ���ǿ����ն�����
 			}
 			
	 		}
			var h=210;
			var w=400;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no" 
			var path = "/npage/public/pubBillPrintCfm_YGZ.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;
			var loginAccept = prtLoginAccept;
			var path = path +"&loginAccept="+loginAccept+"&opCode=<%=opcodeadd%>"+"&submitCfm=submitCfm";
			var ret = window.showModalDialog(path,billArgsObj,prop);		

}

function showBroadBill(printType,DlgMessage,submitCfm){
	var printInfo = "";
	var prtLoginAccept = "";
	var  billArgsObj = new Object();
	for (var m = 0 ; m < prtFlagSet.length; m ++){
		var arrayOrderId = prtFlagSet[m].split("~")[0];
		prtLoginAccept = prtFlagSet[m].split("~")[1];
		var opType = "";
		var custName = "";
		var phoneNo = "";
		var cashPay = document.all.totalFee3.value;
	  $("#servtbl :radio").each(function(i){
 			if(this.checked){
 				opType   = $(this).parent().parent().find("td:eq(4)").text();
 				custName = $(this).parent().parent().find("td:eq(3)").text();
 				phoneNo  = $(this).parent().parent().find("td:eq(2)").text();
 			}
 		});
 		var tableName = "tbl"+servOrderNoArray[0];
	  	var tabobj = g(tableName);
	  	var simcardfee = 0;
	  	var prefee = 0;
	  	var installfee = 0;
	  	/*2014/09/11 15:18:07 gaopeng �����ʷ�չ�ּ��ն˹���������ϵͳ֧���Ż�����
	  		���� �����豸�ն˿� 
	  	*/
	  	var kdZdFee = 0;
		for(i=1; i < tabobj.rows.length; i++){
				var feename = tabobj.rows(i).cells(1).children[1].value;
				if(feename == "SIM������"){
					simcardfee  +=parseInt(tabobj.rows(i).cells(4).children[0].value);
				}else if(feename.indexOf("Ԥ��")!=-1){
					prefee +=parseInt(tabobj.rows(i).cells(4).children[0].value);
				}else if(feename.indexOf("��װ��")!=-1){
					installfee += parseInt(tabobj.rows(i).cells(4).children[0].value);
				}else if(feename.indexOf("�����豸�ն˿�")!=-1){
					kdZdFee += parseInt(tabobj.rows(i).cells(4).children[0].value);
				}else if(feename.indexOf("�����豸�ն�Ѻ��")!=-1){
					kdZdFee += parseInt(tabobj.rows(i).cells(4).children[0].value);
				}
		}
		getBroadMsg(phoneNo);
		printInfo += "<%=new java.text.SimpleDateFormat("yyyy",Locale.getDefault()).format(new java.util.Date())%>" + "|";
		printInfo += "<%=new java.text.SimpleDateFormat("MM",Locale.getDefault()).format(new java.util.Date())%>" + "|";
		printInfo += "<%=new java.text.SimpleDateFormat("dd",Locale.getDefault()).format(new java.util.Date())%>" + "|";
		printInfo += prtLoginAccept + "|";
		printInfo += custName + "|";
		printInfo += " " + "|";
		printInfo += " " + "|";
		printInfo += $("#broadNo").val() + "|";
		printInfo += " " + "|";
		printInfo += cashPay + "|";
		printInfo += cashPay + "|";
		printInfo += "��������" + "|";
		printInfo += "��װ�ѣ�" + installfee + "Ԫ" + "~";
		if(Number(prefee) > 0){
			printInfo += "�����ײ�Ԥ��" + prefee + "Ԫ" + "~";
		}
		//liujian ����pos���ɷ� 
		if(document.all.payType.value=="BX" || document.all.payType.value=="BY"){	
			printInfo +=  "pos����Ϊ��" + document.all.totalFee3.value + "~";						
		}
		if("<%=v_smCode%>" == "kf" || "<%=v_smCode%>" == "ki"){
				printInfo += "�����ն˷��ã�"+kdZdFee+" Ԫ"+ "|";
		}
		/*2014/04/03 15:32:46 gaopeng �ƶ���ͥ�ͻ�����ҵ����Ӫ֧��ϵͳ���� �޸ĵ�Ʒ��Ϊ�ƶ�����(kf)ʱ��������� start*/	
		if("<%=v_smCode%>" == "kf" || "<%=v_smCode%>" == "ki"){
			printInfo += "�ͷ����ߣ�10086" + "|";
		}else{
			printInfo += "�ͷ����ߣ�10050" + "~";
			printInfo += "��ַ��http://www.10050.net" + "|";
		}
		/*2014/04/03 15:32:46 gaopeng �ƶ���ͥ�ͻ�����ҵ����Ӫ֧��ϵͳ���� �޸ĵ�Ʒ��Ϊ�ƶ�����(kf)ʱ��������� end*/	
		//liujian ����pos���ɷ� ��������
		printInfo +=  document.all.payType.value + "|";
		
		$(billArgsObj).attr("10001","<%=loginNo%>");       //����
 		$(billArgsObj).attr("10002","<%=new java.text.SimpleDateFormat("yyyy",Locale.getDefault()).format(new java.util.Date())%>");
 		$(billArgsObj).attr("10003","<%=new java.text.SimpleDateFormat("MM",Locale.getDefault()).format(new java.util.Date())%>");
 		$(billArgsObj).attr("10004","<%=new java.text.SimpleDateFormat("dd",Locale.getDefault()).format(new java.util.Date())%>");
 		$(billArgsObj).attr("10005",custName); //�ͻ�����
 		$(billArgsObj).attr("10006","��������"); //ҵ�����
 		$(billArgsObj).attr("10008",phoneNo); //�û�����
 		$(billArgsObj).attr("10015", ""+Number(Number(cashPay)-Number(kdZdFee))); //���η�Ʊ���(Сд)��
 		$(billArgsObj).attr("10016", ""+Number(Number(cashPay)-Number(kdZdFee))); //��д���ϼ�
 		$(billArgsObj).attr("10036","4977"); //��������	
 		$(billArgsObj).attr("10030",prtLoginAccept); //��ˮ��--ҵ����ˮ
 		$(billArgsObj).attr("10065", $("#broadNo").val()); //�����˺�
 		$(billArgsObj).attr("10066", installfee); //��װ��
 		$(billArgsObj).attr("10067", prefee); //�����ײ�Ԥ���
 		$(billArgsObj).attr("10077", kdZdFee); //�����ն˽��
 		$(billArgsObj).attr("10078", "<%=v_smCode%>"); //����Ʒ��
 		
 		if(document.all.payType.value=="BX" || document.all.payType.value=="BY"){	
 			$(billArgsObj).attr("10019","*"); //ˢ��
 		}else{
 			$(billArgsObj).attr("10017","*"); //���νɷ��ֽ�
 		}
		
	}
	/********tianyang add at 20090928 for POS�ɷ�����****start*****/
    if(document.all.payType.value=="BX" || document.all.payType.value=="BY"){
			printInfo = printInfo + document.all.MerchantNameChs.value + "|";	     	
			printInfo = printInfo + document.all.CardNoPingBi.value + "|";
			printInfo = printInfo + document.all.MerchantId.value + "|";
			printInfo = printInfo + document.all.BatchNo.value + "|";
			printInfo = printInfo + document.all.IssCode.value + "|";
			printInfo = printInfo + document.all.TerminalId.value + "|";
			printInfo = printInfo + document.all.AuthNo.value + "|";
			printInfo = printInfo + document.all.Response_time.value + "|";
			printInfo = printInfo + document.all.Rrn.value + "|";
			printInfo = printInfo + document.all.TraceNo.value + "|";
			printInfo = printInfo + document.all.AcqCode.value + "|";
			printInfo = printInfo + "|";
    }
    /********tianyang add at 20090928 for POS�ɷ�����****end*******/
    /********tianyang add at 20090928 for POS�ɷ�����****start*****/
    if(document.all.payType.value=="BX" || document.all.payType.value=="BY"){
			$(billArgsObj).attr("10049",document.all.payType.value);  //��������   
			$(billArgsObj).attr("10050",document.MerchantNameChs.value); //�̻����ƣ���Ӣ��)
			$(billArgsObj).attr("10051",document.CardNoPingBi.value); //���׿��ţ����Σ�
			$(billArgsObj).attr("10052",document.MerchantId.value); //�̻�����
			$(billArgsObj).attr("10053",document.BatchNo.value); //���κ�
			$(billArgsObj).attr("10054",document.IssCode.value); //�����к�
			$(billArgsObj).attr("10055",document.TerminalId.value); //�ն˱���
			$(billArgsObj).attr("10056",document.AuthNo.value); //��Ȩ��
			$(billArgsObj).attr("10057",document.Response_time.value); //��Ӧ����ʱ��
			$(billArgsObj).attr("10058",document.Rrn.value); //�ο���
			$(billArgsObj).attr("10059",document.TraceNo.value); //��ˮ��----pos��������ˮ
			$(billArgsObj).attr("10060",document.AcqCode.value); //�յ��к�
    }
   $(billArgsObj).attr("10071","8"); //ģ��
    /********tianyang add at 20090928 for POS�ɷ�����****end*******/
    var path ="";
  /*2014/11/21 11:00:25 gaopeng ����ʹ���˿����˺��п�ͷ��ĸ���жϴ�ӡʲô��Ʊ �ҽ���ʹ��Ʒ�ƣ�������������
  	�������ͳһ�ɷѣ��ϵ�ָ��Ļ�ȡ����Ʒ��smcode �Ǹ���ô���أ�
  	�ð죬�ϵ�ָ�����������ȡ����smcode Ҳ�ͻ�ȡ������̬��װ���ˣ���������ʹ����Ҳ��������ò���ʹ�ˡ����ɡ�
  	kh�޸�Ϊ��ͨ�Խ� ��ԭ����kdһ�£��������﷢Ʊ���ø�
  */
	if($("#broadNo").val().indexOf("yd")==0 || $("#broadNo").val().indexOf("jt")==0 || $("#broadNo").val().indexOf("kdz")==0){
		path = "/npage/public/pubBillPrintCfm_YGZ.jsp?dlgMsg=" + "��Ʊ��ӡ";
	}else{
		path = "/npage/public/pubBillPrintBroad.jsp?dlgMsg=" + "��Ʊ��ӡ";
	}
	var h=210;
	var w=400;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;
	var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no" 
	var loginAccept = prtLoginAccept;
	path = path + "&infoStr="+printInfo+"&loginAccept="+loginAccept+"&opCode=4977&submitCfm=submitCfm&phoneNo=" + phoneNo;
	var ret = window.showModalDialog(path,billArgsObj,prop);
}

function getBroadMsg(phoneNo){
		var getdataPacket = new AJAXPacket("/npage/sq046/fq046_getBroadmsg.jsp","���ڻ�����ݣ����Ժ�......");
		getdataPacket.data.add("phoneNo",phoneNo);
		core.ajax.sendPacket(getdataPacket,doBroadMsgBack);
		getdataPacket = null;
}
function doBroadMsgBack(packet){
	retCode = packet.data.findValueByName("retcode");
	retMsg = packet.data.findValueByName("retmsg");
	result = packet.data.findValueByName("result");
	if(retCode == "000000"){
		$("#broadNo").val(result);
	}
}

function ajaxGetToCFee(totalFee){
	var packet1 = new AJAXPacket("/npage/sq046/ajaxGetTcf.jsp","���Ժ�...");
								packet1.data.add("totalFee",totalFee);
								core.ajax.sendPacket(packet1,doAjaxGetToCFee);
								packet1 =null;
}
function doAjaxGetToCFee(packet){
		chinaFee =  packet.data.findValueByName("chinaFee");
}
function showPrtDlg1(printType,DlgMessage,submitCfm,printStr)
{   
	var h=198;
	var w=350;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;
	var pType="subprint";
	var billType="1";
	var sysAccept = "<%=result5[0][0]%>";
	var phone_no	= "<%=servPhoneNo%>";
	
	var mode_code = null;
	var fav_code = null;
	var area_code = null;
	var printStr = printStr;
	
	var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no"; 
	var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc.jsp?DlgMsg=" + DlgMessage;
	var path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=1104&sysAccept="+sysAccept+"&phoneNo="+phone_no+"&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
	var ret=window.showModalDialog(printStr,printStr,prop);
	
	return true;
} 
     	  var printinfo = parent.document.getElementById("<%=gCustId%>").printinfo;
     	  var opcode = "<%=opCode%>";
     	  var i=0;
     	  var iss;
     	  var iss1;
     	  var iss2;
     		function submit_cfm(){
     	  	/*yanpx add*/
     	  	var INSTALLFEEs ="";
     	  	var PREMONEYs="";
     	  	var SIMCARDFEEs="";    	  	
     	  	if(i==0) {
     	  	INSTALLFEEs ="INSTALLFEE";
     	  	PREMONEYs="PREMONEY";
     	  	SIMCARDFEEs="SIMCARDFEE";
     	  	}else {
     	  	INSTALLFEEs =iss;
     	  	PREMONEYs=iss1;
     	  	SIMCARDFEEs=iss2;
     	  	}
     	  	if("<%=opcodeadd%>" =="1104" ||"<%=opcodeadd%>" =="d535" ||"<%=opcodeadd%>" =="4977"){/* lijy add @20110517 d535,4977��֧�����ӣ��û�ims����,�������������ӡ*/
	     	  	var tableName = "tbl"+servOrderNoArray[0];
	     	  	var tabobj = g(tableName);
	     	  	var simcardfee = 0;
	     	  	var prefee = 0;
	     	  	var installfee = 0;
						for(i=1; i < tabobj.rows.length; i++){
								var feename = tabobj.rows(i).cells(1).children[1].value;
								if(feename == "SIM������"){
									simcardfee  +=parseInt(tabobj.rows(i).cells(4).children[0].value);
									//printinfo = printinfo.replace("SIMCARDFEE",tabobj.rows(i).cells(4).children[0].value);
								}else if(feename.indexOf("Ԥ��")!=-1){
									if("<%=opcodeadd%>" =="4977" && joinMarket == "on"){
										prefee += parseInt($(tabobj.rows(i).cells(2)).html());
									}else{
										prefee +=parseInt(tabobj.rows(i).cells(4).children[0].value);
									}
									//printinfo = printinfo.replace("PREMONEY",tabobj.rows(i).cells(4).children[0].value);
								}else if(feename.indexOf("��װ��")!=-1){
									installfee += parseInt(tabobj.rows(i).cells(4).children[0].value);
								}
						}
						printinfo = printinfo.replace(SIMCARDFEEs,simcardfee+".00");
						printinfo = printinfo.replace(PREMONEYs,prefee+".00");
						printinfo = printinfo.replace(INSTALLFEEs,installfee+".00"); 
						iss=installfee+".00";
						iss1=prefee+".00";
						iss2=simcardfee+".00";
						printinfo = printinfo.replace(/\|xg\|/g,"\\");
						i++;
						showPrtDlg1("Detail","ȷʵҪ��ӡ���������","Yes",printinfo);
						//alert(g(tableName).rows(1).cells(1).children[1].value+"|"+g(tableName).rows(1).cells(4).children[0].value);
		   		}
		   		/*end*/
     	  	if("<%=errCode%>"!=0){
     	  		rdShowMessageDialog("����sShowNumInfo��ѯ����<%=errCode%>--<%=errMsg%>");
     	  		return false;
     	  		}
     	  	closeFlag = true;
     	  	doCfm();
     	  }
 		 var map046 = {};
			map046.put = {
			      "items": function(obj,a,c){
			        var b = [];
			        for(var i in obj){
			          if(a == i){
			          	obj[i]=	Number(obj[i]) + Number(c);
			          	  //alert(a+":"+ obj[a]);
						return;
			          }
			         }
			          obj[a] =c;
			//           alert(a+":"+ obj[a]);
			        return b;
			      }
			};
	      function showPrtDlg(){
	     		var prtAccpetLoginStr = "";
	     		//��Ʊ��ӡ���ݶ�������+��ˮ��()ȷ��һ�ŷ�Ʊ ,prtFlagSet�����д洢�ľ��� ��������~��ˮ��
	     		for (var m = 0 ; m < prtFlagSet.length; m ++){
	     			var arrayOrderId = prtFlagSet[m].split("~")[0];
	     			var prtLoginAccept = prtFlagSet[m].split("~")[1];
	     			var phoneFlag = 0;
		        	var  feeArray = {}
	     			
	     				var phoneNo = "";
						var custName = "";
						var opType = "";
						
						 

						var detail="";
						var city="<%=siteName%>";
						
	     			var detailFee1 = 0;
						var detailFee2 = 0;
						var detailFee3 = 0;
						var detailFee4 = 0;
						var amount = 0;
			      var detailstr = "";
		      	var tblObj = g("servtbl");
		      	var trObjs = tblObj.childNodes[0].childNodes;
		      	for(var i = 1;i<trObjs.length;i++){
		      		var tdObjs = trObjs[i].childNodes;
		      		//var inputObj = tdObjs[0].childNodes[0]
		      		
		      		var inputObj = tdObjs[0].childNodes[0]   //update 2009
		      		if( inputObj.v_prtFlag == prtFlagSet[m]){
			      				if(inputObj.v_iscomp == "Y"){
				      				phoneNo = inputObj.v_phoneNo; 
									//custName = inputObj.v_custName;
									opType =  inputObj.v_opType; 
								}else{
									phoneNo = tdObjs[2].innerHTML; 
									//custName = tdObjs[3].innerHTML;
									opType =  tdObjs[4].innerHTML; 	
								}
								var servOrderNo = inputObj.v_span;
								var feeTblObj = g("tbl"+servOrderNo);
								var feeTrObjs = feeTblObj.childNodes[0].childNodes;
								for(var j = 1; j < feeTrObjs.length;j++){
									var feeTdObjs = feeTrObjs[j].childNodes;
									var isprintvalue = feeTdObjs[6].childNodes[0].value;
									if(isprintvalue == "T" && parseFloat(feeTdObjs[4].childNodes[0].value) != 0){//���÷��ÿ�Ŀʵ�շ��ò�Ϊ0����Ϊ��ӡ״̬,�Ŵ�ӡ����Ʊ��
										map046.put.items(feeArray,feeTdObjs[1].childNodes[1].value,feeTdObjs[4].childNodes[0].value);
										detailFee1 += Number(feeTdObjs[2].innerText);
										detailFee3 += Number(feeTdObjs[4].childNodes[0].value);
									}
								}
								if(inputObj.v_isPrtFeeDetail == "TRUE"){
									var feeDetail = "";
									var phoneFeeStr = inputObj.v_phone_fee_str;
									var phoneNoStr = inputObj.v_phone_no_str;
									feeDetail += "�ɷ�ǰ���ѣ�" + phoneFeeStr.split("~")[1] +"|";
									feeDetail += "�ɷ�ǰ���֣�" +  phoneFeeStr.split("~")[2] +"|" ;
									getPayFeeAfter(phoneNoStr);
									var feeStrAfter = g("payFeeAfter").value;
									feeDetail += "�ɷѺ󻰷ѣ�" + feeStrAfter.split("~")[0] +"|";
									feeDetail += "�ɷѺ���֣�" + feeStrAfter.split("~")[1] +"|";
		      						//printDetailBill2(phoneNoStr,arrayOrderId,custName,opType,amount,city,prtLoginAccept,feeDetail,arrayOrderId);
		      					}
							}
						}
						for(var aa in feeArray){
							detail += aa + "��"	+ feeArray[aa] +"|";
						}
					 	amount = detailFee3;
					 	if(detailFee1 == 0 && detailFee3 ==0){
					 		//continue;	
					 	}
					 	custName = document.all.custNameforsQ046.value;
					 	var sqlVq046 = "select id_no from dcustmsg where phone_no= '"+phoneNo+"'";
					 	var packet1 = new AJAXPacket("/npage/offerConfiguration/offerScene/ajaxGetSqlResult.jsp","���Ժ�...");
								packet1.data.add("sqlV1",sqlVq046);
								core.ajax.sendPacket(packet1,doQuerySel);
								packet1 =null;		
						
						city = custId		;
					 	var mode_code = "";
					 	var fav_code = "";
					 	var area_code ="";
					 	var memo = "��ע��"+custId+phoneNo+opType;
					 	
						a=printDetailBill(phoneNo,arrayOrderId,custName,opType,amount,city,prtLoginAccept,detail,arrayOrderId,mode_code,fav_code,area_code,memo);
						
						prtAccpetLoginStr = arrayOrderId + "~" + a + "~|";
					}
					g("prtAccpetLoginStr").value = prtAccpetLoginStr;
				}
			function doQuerySel(packet){
				  var error_code = packet.data.findValueByName("code");
					var error_msg =  packet.data.findValueByName("msg");
					prodCompInfo1 = packet.data.findValueByName("offerLimitArray");
					custId = prodCompInfo1[0][0];
			}  
			function getPayFeeAfter(phoneNoStr)	  {
				var myPacket = new AJAXPacket("/npage/sq046/fq046_getAfterFee.jsp","������֤���룬���Ժ�......");       
				myPacket.data.add("phone_no",phoneNoStr);
				core.ajax.sendPacket(myPacket,getPayFeeAfter046,true);
				myPacket =null;
			}
		function getPayFeeAfter046(packet){
			var retCode = packet.data.findValueByName("retCode");
			if(retCode != "0"){
					rdShowMessageDialog("��ȡ���������Ϣʧ�ܣ��޷���ӡ�վ�!",0)	;
					g("payFeeAfter").value = "0~0~";
			}else{
				var result = packet.data.findValueByName("payFeeAfter");
				g("payFeeAfter").value = result;
			}
		}
			
			 function doCfm()
		    {
		        //��ʾ��ӡ�Ի���
		        var h = 150;
		        var w = 350;
		        var t = screen.availHeight / 2 - h / 2;
		        var l = screen.availWidth / 2 - w / 2;
		        if(g("op_note").value.trim() == "") g("op_note").value=g("sys_note").value;
	      		if(!checksubmit(form1))	
	     				return false;
	     		  //$("#fee_submit").attr("disabled",true);
		        if (rdShowConfirmDialog("ȷ��Ҫ�ύ���β�����") == 1)
		        {
			     	  var printObj = parent.document.getElementById("<%=gCustId%>");
			     	  if(printObj){
			     	  	parent.document.removeChild(printObj);
			     	  }		        	
		            conf();
		        }else{
		        	$("#fee_submit").attr("disabled",false);	
		        }
		    }
		    
	       /*
	        *�ύ����, ���ɷѷ���׼�����ô�,����������~���񶨵����~@���ô���~ʵ��~����~Ӧ��~Ӫ��~��ȡ��ʽ~�Ƿ��ӡ~���ô���~�߸�����
	       */ 
						function conf(){
							var feeStr = "";
							for( var k = 0 ; k < servOrderNoArray.length;k++){
							var obj = document.getElementById("tbl"+servOrderNoArray[k]);
							var trObjs = obj.childNodes[0].childNodes;
							var rowsNum = trObjs.length;
							for ( var i =1; i < trObjs.length; i++)	{
								var tdObjs = trObjs[i].childNodes; 
								//�Ӹ��ж�,ÿ������,���Ӧ��!=����+Ӫ��+ʵ��,˵�����ó�������,��������,return false;
								//alert(Number(tdObjs[2].innerText) +"=="+Number(tdObjs[3].innerText)+"+"+Number(tdObjs[4].childNodes[0].value)+"+"+Number(tdObjs[4].childNodes[2].value));
								//alert(Number(tdObjs[2].innerText)!= Number(tdObjs[3].innerText)+Number(tdObjs[4].childNodes[0].value)+Number(tdObjs[4].childNodes[2].value));
										var ningtnVal = "";
										if($(tdObjs[2]).find("select").length > 0){
											ningtnVal = $(tdObjs[2]).find("select").val();
											//alert(ningtnVal);
											//alert("--111");
										}else{
											ningtnVal = tdObjs[2].innerHTML;
											//alert(ningtnVal);
											//alert("--222");
										}
								if(Number(ningtnVal)!= Number(tdObjs[3].innerText)+Number(tdObjs[4].childNodes[0].value)+Number(tdObjs[4].childNodes[2].value)){
									rdShowMessageDialog("���ó����쳣����,�뵽�ͻ���ҳ���ϵ���������!",0);
									$("#fee_submit").attr("disabled",false);	
									return false;
								
								}    	    	
								for(var j = 1; j < tdObjs.length-1; j++){
									//var inputObj = tdObjs[j].childNodes[0];
									if(j == 1  || j == 4 || j == 5 || j == 6 ){
										var inputObj = tdObjs[j].childNodes[0];
										if(j == 1){
											feeStr += inputObj.v_pparent;
											feeStr += "~";
											feeStr += inputObj.v_parent;
											feeStr += "~@";    	    		           
										}     	    		    
										<%
										if(opcodeadd.equals("4977")){
										%>
											if(joinMarket == "on"){
												/*2013/07/26 5:36:48 gaopeng �����0Ԫ�ʷѿ���*/
												if("<%=joinType%>"=="0"){
													
													if(j == 4){
													var ningtnVal = "";
													if($(tdObjs[2]).find("select").length > 0){
														ningtnVal = $(tdObjs[2]).find("select").val();
			
													}else{
														ningtnVal = tdObjs[2].innerHTML;
													}
													feeStr += ningtnVal;
													feeStr += "~0"; 	
												}else{
													feeStr += inputObj.value; 
												}
													
												}
												/*2013/07/26 5:36:48 gaopeng ����Ǵ��ۿ��� ��Ȼ������*/
												else if("<%=joinType%>"=="1")
													{
														feeStr += inputObj.value; 
													if(j == 4){
														feeStr += "~" + tdObjs[j].childNodes[2].value; 	
													}
													}
												else{
													feeStr += inputObj.value; 
												}
											
											}else{
												feeStr += inputObj.value; 
												if(j == 4){
													feeStr += "~" + tdObjs[j].childNodes[2].value; 	
												}
											}
										<%
										}else{
											%>
												feeStr += inputObj.value; 
												if(j == 4){
													feeStr += "~" + tdObjs[j].childNodes[2].value; 	
												}
											<%
										}
										%>
										
									}else{
										var ningtnVal = "";
										if($(tdObjs[j]).find("select").length > 0){
											ningtnVal = $(tdObjs[j]).find("select").val();

										}else{
											ningtnVal = tdObjs[j].innerHTML;

										}
										feeStr += ningtnVal;
    
									}
									feeStr += "~";
								}
								if(tdObjs[7].childNodes[0].value == "otherFee"){
									rowsNum = rowsNum+1;
									feeStr += tdObjs[1].childNodes[0].v_feeType + "~" + rowsNum  + "~0~0~0~0~0~0" + "|";	
								}else{
									feeStr += tdObjs[1].childNodes[0].v_feeType + "~" + tdObjs[7].childNodes[0].value + "|";  //�����ɷѷ������ӷ�������(ȡ��������ǰ���hidden�ؼ���v_feeType����ֵ)�ͷ�������(ȡ˵��ǰ���hidden�ؼ���valueֵ)����,	
								}
								}
							}
								//alert("gaopeng�����ƷѵĴ�---"+feeStr)						

							
							//alert(document.all.totalFee3.value);
							/**** tianyang add for pos start ****/
							if(Number(document.all.totalFee3.value)>99999){
									rdShowMessageDialog("ʵ���ܶ�ӦС��10��!");
							}else{
									if(document.all.payType.value=="BX")
						    	{
							    		/*set �������*/
											var transerial    = "000000000000";  	                     //����Ψһ�� ������ȡ��
											var trantype      = "00";                                  //��������
											var bMoney        = document.all.totalFee3.value;					 //�ɷѽ��
											var tranoper      = "<%=loginNo%>";                        //���ײ���Ա
											var orgid         = "<%=groupId%>";                        //ӪҵԱ��������
											var trannum       = "<%=servPhoneNo%>";                    //�绰����
											getSysDate();       /*ȡbossϵͳʱ��*/
											var respstamp     = document.all.Request_time.value;       //�ύʱ��
											var transerialold = "";			                               //ԭ����Ψһ��,�ڽɷ�ʱ�����
											var org_code      = "<%=orgCode%>";                        //ӪҵԱ����						
											CCBCommon(transerial,trantype,bMoney,tranoper,orgid,trannum,respstamp,transerialold,org_code);
											if(ccbTran=="succ") posSubmitForm(feeStr);
						    	}
									else if(document.all.payType.value=="BY")
									{
											var transType     = "05";																	/*�������� */         
											var bMoney        = document.all.totalFee3.value;         /*���׽�� */         
											var response_time = "";                                   /*ԭ�������� */       
											var rrn           = "";                                   /*ԭ����ϵͳ������ */ 
											var instNum       = "";                                   /*���ڸ������� */     
											var terminalId    = "";                                   /*ԭ�����ն˺� */			
											getSysDate();       //ȡbossϵͳʱ��                                            
											var request_time  = document.all.Request_time.value;      /*�����ύ���� */     
											var workno        = "<%=loginNo%>";                       /*���ײ���Ա */       
											var orgCode       = "<%=orgCode%>";                       /*ӪҵԱ���� */       
											var groupId       = "<%=groupId%>";                       /*ӪҵԱ�������� */   
											var phoneNo       = "<%=servPhoneNo%>";                   /*���׽ɷѺ� */       
											var toBeUpdate    = "";						                        /*Ԥ���ֶ� */         
											var posFlag = ICBCCommon(transType,bMoney,response_time,rrn,instNum,terminalId,request_time,workno,orgCode,groupId,phoneNo,toBeUpdate);									
											if(icbcTran=="succ") posSubmitForm(feeStr);
									}else{
											posSubmitForm(feeStr);
									}
							}							
							/**** tianyang add for pos end ****/
						}
   
   	function do_cfm(packet){
   		var err_code = packet.data.findValueByName("errorCode");
   		var retMessage = packet.data.findValueByName("retMessage");
   		
   		if(err_code == "0"){
   			if(typeof(parent.frames['user_index'])!="undefined"){
   		    parent.frames['user_index'].location.reload();
   		  }
   		  
   		  /*** tianyang add for pos start *** boss���׳ɹ� ��������ȷ�Ϻ��� *****/
				if(document.all.payType.value=="BX"){
					BankCtrl.TranOK();
					//alert("�����ύ BankCtrl.TranOK()");
				}
				if(document.all.payType.value=="BY"){
					var IfSuccess = KeeperClient.UpdateICBCControlNum();
					//alert("�����ύ var IfSuccess = KeeperClient.UpdateICBCControlNum()");
				}
				/*** tianyang add for pos end *** boss���׳ɹ� ��������ȷ�Ϻ��� *****/
				
			//2010-7-5 8:46 wanghfa�޸� ��ͨ��������ͨ���������ʾ��Ϣ��ͬ start
<%
			if (isTT == true) {
%>
	   			rdShowMessageDialog("ҵ�������ɹ�!",2);
<%
			} else if (isTT == false) {
%>
	   			rdShowMessageDialog("�ɷѳɹ�!",2);
<%
			}
%>
   			//rdShowMessageDialog("�ɷѳɹ�!",2);
			//2010-7-5 8:46 wanghfa�޸� ��ͨ��������ͨ���������ʾ��Ϣ��ͬ end
   			var is_release = packet.data.findValueByName("is_release");
   			 
   			if(is_release == "Y"){
     			removeCurrentTab();
	     	}else{
		      parent.addTab(false,'q025','�ͻ��������','/npage/sq025/fq025.jsp?gCustId=<%=gCustId%>&custOrderId='+g("custOrderId").value+'&opCode=q025&opName=�ͻ��������');
		      if((typeof parent.removeTab )=="function")
					{
						 parent.removeTab('<%=opCode%>');
					}
			}
   		}else{
   			rdShowMessageDialog("�ɷ�ʧ��!"+err_code+retMessage,0);	
   			$("#fee_submit").attr("disabled",false);	
   			return false;
   		}
   	}
       /*
        *������������
       */ 
    function addType()
		{	
			var iWidth=45; //���ڿ���
			var iHeight=35;//���ڸ߶�
			var typeStr="";
			/*for(var i=0;i<parseFloat(document.all.table1.rows.length,10)-1;i++)
			{
				//alert(document.all.table1.rows.length);
				//alert(document.all.table1.rows[i+1].cells[1].innerText)
				typeStr=typeStr+document.all.table1.rows[i+1].cells[1].innerText+"~";
			}*/
			var servOrder = $("input[@type=radio][@name=servOrders][@checked]").val();	//ȡҪ���ӿ�ѡ���õķ��񶨵���  �����~�����~�����ʶ~�����������
			if(typeof(servOrder)=="undefined"){
				rdShowMessageDialog("����ѡ��Ҫ�����������õķ��񶨵�!",0);
				return false;
			}
			var obj = document.form1.elements;
			var servOrderNo = servOrder.split("~")[1];
		 	for(var i = 0 ; i< obj.length; i ++){
             if(obj[i].v_type == "fee_codes" && obj[i].v_mustFee != "1" && obj[i].v_parent == servOrderNo){//�����Ѿ����ӹ�����������,������֤,�����ӵķ����Ƿ�Ϸ�
               typeStr +=  obj[i].v_parent+"@"+obj[i].value+"$";  
             }
      }
			var newUrl="/npage/sq046/fq046_add_type.jsp?typeStr="+typeStr+"&servOrder="+servOrder;
			//var newUrl="f_add_type1.jsp";
			var ss= window.showModalDialog(newUrl,"������Ŀ","dialogWidth:"+iWidth+";dialogHeight:"+iHeight+";");
			//���ص��������ô�:
			//�ֽ��������ô�,��̬���ӵ���Ӧ���񶩵��ķ����б�,����Ԫ��,��ʽ���ѡ������ͬ,ֻ������˵������ɾ����ť,���Խ���ɾ������,����delFee();delTr()
			if(ss != undefined)
			{
				var rowArray =  ss.split("|");
				var arrayOrderNo = rowArray[0].split("~")[0];
				var servOrderNo = rowArray[0].split("~")[1];
				var masterServType = rowArray[0].split("~")[3];
				for(var i =1 ; i < rowArray.length-1; i++){
					var tabRowNum = g("tbl"+servOrderNo).rows.length;
					var colArray = rowArray[i].split("~");
					var trArray = new Array();
					for(var j=0;j< colArray.length-4;j++)
					if(j==0){
						trArray.push(servOrderNo);
						var tmpStr = "<input type=hidden v_type=fee_codes v_pparent="+arrayOrderNo+"  v_parent="+servOrderNo+" name=other_fee_code"+i+" v_feeType=" + colArray[j] + " value=" + colArray[1] + "><input id=other_fee_name"+i+" class='required' name=other_fee_name"+i+" type=text  class='required' value="+colArray[7]+">";
						trArray.push(tmpStr);						
					}else if(j==1){
					}else if(j==4){
						trArray.push("<input type=text size=10 maxLength='15' name=otherRealPayFee_"+i+" class='forMoney required' vflag=1 onchange = changeRealPayFee() value='"+colArray[j]+"'><input type=hidden name=otherRealfee_"+i+"  value='"+colArray[j]+"'><input type=hidden id=otherOpchangeFee_"+i+" value='0' v_oldvalue='0'>");
					}else{
						trArray.push(colArray[j]);
					}
					if(masterServType =="0"){
						trArray.push("<select v_type='feeWay' style='width:100px' name='otherFeeWay_"+i+"' onchange='changeFeeWay()'>"+selStrCdma+"</select>");
					}else{
						trArray.push("<select v_type='feeWay' style='width:100px' name='otherFeeWay_"+i+"' onchange='changeFeeWay()'>"+selStr+"</select>");	
					}
					trArray.push("<select v_type='isPrint' style='width:100px' name='otherIsPrint_"+i+"' onchange='g(v_type).value=this.options[selectedIndex].value'><br><option selected value='T'>��ӡ</option><option value='F'>����ӡ</option></select>");
					
					//1.��ɾ����ť�ؼ�����v_fee1����,�洢�����������ú��ԭʼӦ���ܶ�,�û�ɾ����������ɾ����,�ָ�ԭ���ķ���״̬.
					//2.ɾ����ť�ؼ�ǰ���hidden�ؼ�,�洢�߸��������Ӳ���.д����, 20090330 wangljadd
					
					trArray.push("<input type='hidden' name='otherFeeParams_"+i+"' value='otherFee'><input type='button' v_fee1='"+colArray[2]+"' class='butDel' onclick='delFee();delTr()'>");
					addTr("tbl"+servOrderNo,tabRowNum,trArray,"0|1");
					setselect(g("otherFeeWay_"+i),colArray[5]);
					setselect(g("otherIsPrint_"+i),colArray[6]);
					g("totalFee1").value = Number(g("totalFee1").value)+ Number(colArray[2]); //Ӧ���ܶ�
					g("totalFee2").value = Number(g("totalFee2").value)+ Number(colArray[3]); //�Ż��ܶ�
					g("totalFee3").value = Number(g("totalFee3").value)+ Number(colArray[4]); //ʵ���ܶ�
				}
			}
		}
		
		   /*
        *ɾ����������
       */ 
		function delFee(){
					var obj = event.srcElement;
					var trobj = obj.parentNode.parentNode;
					var tdobjs = trobj.childNodes;
					var inputobj1 = tdobjs[4].childNodes[0];
					var inputobj2 = tdobjs[4].childNodes[2];
					var innerobj3 = tdobjs[3].innerText;
					g("totalFee1").value = Number(g("totalFee1").value)- Number(obj.v_fee1);  //Ӧ���ܶ�
					g("totalFee2").value = Number(g("totalFee2").value)-Number(inputobj2.value)-Number(innerobj3); //�Ż��ܶ�
					g("totalFee3").value = Number(g("totalFee3").value)-Number(inputobj1.value); //ʵ���ܶ�
		}
		
		  /*
        *����������
       */ 
		function setselect(obj,obj_value){
				var objs = obj.childNodes;
				for(var i = 0 ; i<objs.length;i++){
					if(objs[i].value==obj_value){
						objs[i].selected = true; 
					}	
				}
		}
		  /*
	        *Ϊ�˱���������շѺʹ���˵��Ӳ���,����ӪҵԱ
	       */ 
		//window.onbeforeunload =function LeaveWin(){
		//	/*if (rdShowMessageDialog("�����뿪�ɷ�ҳ��֮ǰ,�����нɷѲ���,��ȷ�������������,���нɷ���?") == 1)
	  //      {
	  //         doCfm();
	  //      } */
	  //      if(!closeFlag){
	  //      	//doCfm();
	  //      	closeLog();
	  //      	rdShowMessageDialog("�ö�����δ�ɷ�,���ڴ��շ�״̬,�뵽�ͻ���ҳ��ѯ�ö������жϵ�������������!");
	  //      	
	  //      	
	  //      	
	  //  	}
		//}
		   /*
	        *Ϊ�˷����������շѺʹ���˵��Ӳ��������,�ڷǷ��رսɷ�ҳ���ʱ��,������־��¼����
	       */ 
		function closeLog(){
			var myPacket = new AJAXPacket("/npage/sq046/fq046_log_ajax.jsp","���ڻ����Ϣ�����Ժ�......");
			var opNote = "����Ա<%=loginNo%>�Ƿ��ر�<%=opName%>ҳ��,<%=custOrderId%>�������ڴ��ɷ�״̬";
			myPacket.data.add("opNote",opNote);
			myPacket.data.add("custOrderId",g("custOrderId").value);	
			myPacket.data.add("opCode",g("opCode").value);	
			myPacket.data.add("loginNo","<%=loginNo%>");
			core.ajax.sendPacket(myPacket,getCloseLog);	
			myPacket=null;	
		}
		function getCloseLog(packet){
			var err_code = packet.data.findValueByName("errorCode");
			//alert(err_code);
		}
    		
/*tianyang add POS�ɷ� start*/
function getSysDate()
{
	var myPacket = new AJAXPacket("../s1300/s1300_getSysDate.jsp","���ڻ��ϵͳʱ�䣬���Ժ�......");
	myPacket.data.add("verifyType","getSysDate");
	core.ajax.sendPacket(myPacket);
	myPacket = null;

}
function padLeft(str, pad, count)
{
		while(str.length<count)
		str=pad+str;
		return str;
}
function getCardNoPingBi(cardno)
{
		var cardnopingbi = cardno.substr(0,6);
		for(i=0;i<cardno.length-10;i++)
		{
			cardnopingbi=cardnopingbi+"*";
		}
		cardnopingbi=cardnopingbi+cardno.substr(cardno.length-4,4);
		return cardnopingbi;
}
/* POS�ɷ��� ��ť��Ч���ó�false  start*/
/*function posSetButton(){
		document.form1.fee_submit.disabled=false;
		document.form1.confirm.disabled=false;
}*/
/* POS�ɷ��� ҳ���ύ  start*/
function posSubmitForm(feeStr){
	
		var tableName = "tbl"+servOrderNoArray[0];
  	var tabobj = g(tableName);
  	var kdZdFee = "";
		for(i=1; i < tabobj.rows.length; i++){
				var feename = tabobj.rows(i).cells(1).children[1].value;
				 if(feename.indexOf("�����豸�ն˿�")!=-1){
					kdZdFee += parseInt(tabobj.rows(i).cells(4).children[0].value);
				}
				 if(feename.indexOf("�����豸�ն�Ѻ��")!=-1){
					kdZdFee += parseInt(tabobj.rows(i).cells(4).children[0].value);
				}
		}
				
			<%if(opcodeadd.equals("1104")){%>
				showPrtDlgbill("Bill","ȷʵҪ���з�Ʊ��ӡ��","Yes");
			<%}else if(opcodeadd.equals("4977")){%>
				if(Number(kdZdFee) != 0){
					showBroadKdZdBill("Bill","ȷʵҪ���п����ն˷�Ʊ��ӡ��","Yes");
				}
				showBroadBill("Bill","ȷʵҪ����ͳһ�ɷѷ�Ʊ��ӡ��","Yes");
			<%}%>
					//alert(g("checkPay").value);	
			var myPacket = new AJAXPacket("/npage/sq046/fq046_3_ajax.jsp","���ڻ����Ϣ�����Ժ�......");
			myPacket.data.add("feeStr",feeStr);
			myPacket.data.add("arrayOrder",g("arrayOrder").value);	
			myPacket.data.add("servOrder",g("servOrder").value);	
			myPacket.data.add("custOrderId",g("custOrderId").value);	
			myPacket.data.add("opCode",g("opCode").value);	
			myPacket.data.add("opName",g("opName").value);	
			myPacket.data.add("gCustId",g("gCustId").value);	
			myPacket.data.add("feeWay",g("feeWay").value);	
			myPacket.data.add("isPrint",g("isPrint").value);	
			myPacket.data.add("prtAccpetLoginStr",g("prtAccpetLoginStr").value);			
			myPacket.data.add("checkNo",g("checkNo").value);	
			myPacket.data.add("bankCode",g("bankCode").value);	
			myPacket.data.add("checkPay",g("checkPay").value);
			myPacket.data.add("offeridkd","<%=offeridkd%>");
			/** pos���������� start **/
			/* ningtn ����ô���ȯ�Ļ����ɷ����;���EF */
			if("<%=opcodeadd%>" =="4977" && joinMarket == "on" && "<%=joinType%>"=="0"){
				var payTypeVal = "EF";
				if("<%=v_smCode%>" == "kf"){
					/*�ƶ�����*/
					payTypeVal = "EP";
				}else if("<%=v_smCode%>" == "ke"){
					/*��������*/
					payTypeVal = "EQ";
				}else if("<%=v_smCode%>" == "kd"){
					/*��ͨ����*/
					payTypeVal = "ER";
				}else if("<%=v_smCode%>" == "kg" || "<%=v_smCode%>" == "kh"){ //����Э������ʡ��������������Ӫ�������ں��ײ�����ĺ�����Ʒ���֣�@2014/7/24 
					/*����ʡ���kg������Ʒ��kh*/
					payTypeVal = "WG";
				}
				
				myPacket.data.add("payType" ,payTypeVal);
			}else{
				myPacket.data.add("payType" ,document.all.payType.value);/** �ɷ����� payType=BX �ǽ��� payType=BY �ǹ��� **/
			}
			myPacket.data.add("MerchantNameChs" ,document.all.MerchantNameChs.value);
			myPacket.data.add("MerchantId" ,document.all.MerchantId.value);
			myPacket.data.add("TerminalId" ,document.all.TerminalId.value);
			myPacket.data.add("IssCode" ,document.all.IssCode.value);
			myPacket.data.add("AcqCode" ,document.all.AcqCode.value);
			myPacket.data.add("CardNo" ,document.all.CardNo.value);
			myPacket.data.add("BatchNo" ,document.all.BatchNo.value);
			myPacket.data.add("Response_time" ,document.all.Response_time.value);
			myPacket.data.add("Rrn" ,document.all.Rrn.value);
			myPacket.data.add("AuthNo" ,document.all.AuthNo.value);
			myPacket.data.add("TraceNo" ,document.all.TraceNo.value);
			myPacket.data.add("Request_time" ,document.all.Request_time.value);
			myPacket.data.add("CardNoPingBi" ,document.all.CardNoPingBi.value);
			myPacket.data.add("ExpDate" ,document.all.ExpDate.value);
			myPacket.data.add("Remak" ,document.all.Remak.value);
			myPacket.data.add("TC" ,document.all.TC.value);
			
			/** pos���������� end **/
			core.ajax.sendPacket(myPacket,do_cfm);	
			myPacket=null;
}
/*tianyang add POS�ɷ� end*/ 
  var beforeChangeFee = "";
	/*��ȡ��װ�������б��ı�ǰ�Ľ��*/
	function getNowSelectVal(tmp){
		beforeChangeFee = tmp;
	}   		
  function changeKDvalues(ss) {
    document.getElementById(savenames).value=ss;
    changeRealPayFee();
    							/*var feeStr = "";
							for( var k = 0 ; k < servOrderNoArray.length;k++){
							var obj = document.getElementById("tbl"+servOrderNoArray[k]);
							var trObjs = obj.childNodes[0].childNodes;
							var rowsNum = trObjs.length;
							for ( var i =1; i < trObjs.length; i++)	{
								var tdObjs = trObjs[i].childNodes; 
								//�Ӹ��ж�,ÿ������,���Ӧ��!=����+Ӫ��+ʵ��,˵�����ó�������,��������,return false;
								//alert(Number(tdObjs[2].innerText) +"=="+Number(tdObjs[3].innerText)+"+"+Number(tdObjs[4].childNodes[0].value)+"+"+Number(tdObjs[4].childNodes[2].value));
								
								
													var ningtnVal = "";
										if($(tdObjs[2]).find("select").length > 0){
											ningtnVal = $(tdObjs[2]).find("select").val();
											alert(ningtnVal);
											alert("--111");
										}else{
											ningtnVal = tdObjs[2].innerHTML;
											alert(ningtnVal);
											alert("--222");
										}
										
								
								
								
								alert(Number(ningtnVal)!= Number(tdObjs[3].innerText)+Number(tdObjs[4].childNodes[0].value)+Number(tdObjs[4].childNodes[2].value));
								if(Number(ningtnVal)!= Number(tdObjs[3].innerText)+Number(tdObjs[4].childNodes[0].value)+Number(tdObjs[4].childNodes[2].value)){
									rdShowMessageDialog("���ó����쳣����,�뵽�ͻ���ҳ���ϵ���������!",0);
							  alert(tdObjs[2].innerText);
								alert(tdObjs[3].innerText);
								alert(tdObjs[4].childNodes[0].value);
								//alert(tdObjs[4].childNodes[1].value);--
								alert(tdObjs[4].childNodes[2].value);
								}
																for(var j = 1; j < tdObjs.length-1; j++){
									//var inputObj = tdObjs[j].childNodes[0];
									if(j == 1  || j == 4 || j == 5 || j == 6 ){
										var inputObj = tdObjs[j].childNodes[0];
										if(j == 1){
											feeStr += inputObj.v_pparent;
											feeStr += "~";
											feeStr += inputObj.v_parent;
											feeStr += "~@";    	    		           
										}     	    		    
										feeStr += inputObj.value; 
										if(j == 4){
											feeStr += "~" + tdObjs[j].childNodes[2].value; 	
										}
									}else{
										var ningtnVal = "";
										if($(tdObjs[j]).find("select").length > 0){
											ningtnVal = $(tdObjs[j]).find("select").val();

										}else{
											ningtnVal = tdObjs[j].innerHTML;

										}
										feeStr += ningtnVal;     
									}
									feeStr += "~";
								}
								if(tdObjs[7].childNodes[0].value == "otherFee"){
									rowsNum = rowsNum+1;
									feeStr += tdObjs[1].childNodes[0].v_feeType + "~" + rowsNum  + "~0~0~0~0~0~0" + "|";	
								}else{
									feeStr += tdObjs[1].childNodes[0].v_feeType + "~" + tdObjs[7].childNodes[0].value + "|";  //�����ɷѷ������ӷ�������(ȡ��������ǰ���hidden�ؼ���v_feeType����ֵ)�ͷ�������(ȡ˵��ǰ���hidden�ؼ���valueֵ)����,	
								}
								alert(feeStr)   
								}
  }*/
  } 		
//add by liubo ���볷�� start-----------------------------------------				
function commitJsp3(a,b)
{
		var quetype="q034";
		var reasonType ="3";
		var reasonDescription = "�ڽɷѴ�ͳһ����";		
		var startTime = "";
		var endTime = "";
		var osr="1";
		
 	 //var stateFlag = document.frm.stateFlag[document.frm.stateFlag.selectedIndex].value;		
		var aa=g("arrayOrder").value.substring(0,g("arrayOrder").value.indexOf("|"));    //�ͻ���������ͷ��񶨵�
		var myPacket = new AJAXPacket("/npage/sq046/fq046_cancel.jsp?opcodestr=1&opCode=<%=opCode %>&opName=<%=opName%>","���ڳ��������Ժ�......");
		myPacket.data.add("retType","orderdata");
		myPacket.data.add("quetype",quetype);
		myPacket.data.add("reasonType",reasonType); 
		myPacket.data.add("reasonDescription",reasonDescription);
		myPacket.data.add("quevalue",aa);
		myPacket.data.add("phoneNo",<%=servPhoneNo%>);	
		myPacket.data.add("startTime",startTime);
		myPacket.data.add("endTime",endTime);
		myPacket.data.add("_orderID",g("custOrderId").value+"->"+g("arrayOrder").value);
		myPacket.data.add("workName","<%=loginNo%>");
		core.ajax.sendPacket(myPacket,rollbackPro);		 
		myPacket=null; 
}

function rollbackPro(packet){
	 var errorCode = packet.data.findValueByName("errorCode");
	 var errorMsg = packet.data.findValueByName("errorMsg");
	 if(errorCode!="0"){
		  rdShowMessageDialog("����ʧ��!"+errorMsg,0);
		 
	 }else{
	 	  rdShowMessageDialog("�����ɹ�!");
	 	  parent.user_index.clearPage();	
	}
	return;
}

function checkWay()
{   //֧Ʊ֧����ʽ
    var obj = "check"+0;
    if(document.all.checkRadio.checked == true)
    {
    		document.all.payType.value = "0";/*��������*/
        document.all.checkRadio.checked = true;
        document.all.NocheckRadio.checked = false;
        document.all(obj).style.display = "";	
        /*�����м�����radioȡ��checked
          20100201 ningtn tianyang add for pos*/
        document.all.ccb.checked = false;
        document.all.icbc.checked = false;
        
    }
}    
function NocheckWay()
{   //��֧Ʊ֧����ʽ 
    var obj = "check"+0;
    var obj1 = "chPayNum" + 0;
    if(document.all.NocheckRadio.checked == true)
    {
    		document.all.payType.value = "0";/*��������*/
        document.all.checkRadio.checked = false;
        document.all.NocheckRadio.checked = true;
        document.all(obj).style.display = "none";
        document.all(obj1).style.display = "none";
		
        document.all.checkNo.value = "";
        document.all.bankCode.value = "";
        document.all.bankName.value = "";
        document.all.checkPay.value = "";
				document.all.checkPrePay.value = "";
				/*�����м�����radioȡ��checked
          20100201 ningtn tianyang add for pos*/
        document.all.ccb.checked = false;
        document.all.icbc.checked = false;
        
     }    
}
/** ����POS���ɷ� @20100201 ningtn tianyang add for pos start **/
function checkCCB(){
		//��֧Ʊ�ɷѲ�������
		var obj = "check"+0;
    var obj1 = "chPayNum" + 0;
    if(document.all.ccb.checked == true)
    {    		
    		document.all.payType.value = "BX";/*��������*/
        document.all.checkRadio.checked = false;
        document.all.NocheckRadio.checked = false;
        document.all(obj).style.display = "none";
        document.all(obj1).style.display = "none";		
        document.all.checkNo.value = "";
        document.all.bankCode.value = "";
        document.all.bankName.value = "";
        document.all.checkPay.value = "";
				document.all.checkPrePay.value = ""; 
				/*���������� ȡ����ѡ*/
				document.all.icbc.checked = false;
     }
     
}
function checkICBC(){
		//��֧Ʊ�ɷѲ�������
		var obj = "check"+0;
    var obj1 = "chPayNum" + 0;
    if(document.all.icbc.checked == true)
    {    		
    		document.all.payType.value = "BY";/*��������*/
        document.all.checkRadio.checked = false;
        document.all.NocheckRadio.checked = false;
        document.all(obj).style.display = "none";
        document.all(obj1).style.display = "none";		
        document.all.checkNo.value = "";
        document.all.bankCode.value = "";
        document.all.bankName.value = "";
        document.all.checkPay.value = "";
				document.all.checkPrePay.value = ""; 
				/*���������� ȡ����ѡ*/
				document.all.ccb.checked = false;
     }     
}
/** ����POS���ɷ� @20100201 ningtn tianyang add for pos end **/

function getBankCode()
{ 
  	//���ù���js�õ����д���
    if((document.all.checkNo.value).trim() == "")
    {
        rdShowMessageDialog("������֧Ʊ���룡",0);
        document.all.checkNo.focus();
        return false;
    }
    
  var getCheckInfo_Packet = new AJAXPacket("/npage/sq046/f1104_6.jsp","���ڻ��֧Ʊ�����Ϣ�����Ժ�......");
	getCheckInfo_Packet.data.add("retType","getCheckInfo");
  getCheckInfo_Packet.data.add("checkNo",document.all.checkNo.value);
	core.ajax.sendPacket(getCheckInfo_Packet,doGetBankCode);
	getCheckInfo_Packet=null;   
 } 

function doGetBankCode(packet){   //�õ�֧Ʊ��Ϣ
		var retCode = packet.data.findValueByName("retCode"); 
    var retMessage = packet.data.findValueByName("retMessage");	
    
        var obj = "chPayNum" + 0;        
        if(retCode=="000000")
    	{
            var bankCode = packet.data.findValueByName("bankCode");
            var bankName = packet.data.findValueByName("bankName");
            var checkPrePay = packet.data.findValueByName("checkPrePay");
            if(checkPrePay == "0")
            {
    		        document.all.checkNo = "";
                document.all.bankCode.value = "";
                document.all.bankName.value = "";                
                document.all.checkNo.focus();
                document.all(obj).style.display = "none";
                rdShowMessageDialog("��֧Ʊ���ʻ����Ϊ0��",0);
            }
            else
            {   document.all(obj).style.display = "";            }
            
            document.all.bankCode.value = bankCode;
            document.all.bankName.value = bankName;
            document.all.checkPrePay.value = checkPrePay;            
    	}
    	else
    	{
    		document.all.checkNo.value = "";
            document.all.bankCode.value = "";
            document.all.bankName.value = "";
            document.all(obj).style.display = "none"; 
            document.all.checkNo.focus();
    	    retMessage = retMessage + "[errorCode9:" + retCode + "]";
    		rdShowMessageDialog(retMessage,0);               		
			return false;
    	}	
	}


function getpreFee()
{
 	if(1*document.all.checkPay.value>1*document.all.totalFee3.value){
 		rdShowMessageDialog("����Ҫ�ɿ���",0);               		
 		document.all.checkPay.value = "";
 		document.all.totalFee3.value = document.all.totalFee1.value;
 		document.all.checkPay.focus();
		return false;	
 	}
 	
 	document.all.totalFee3.value = 1*document.all.totalFee3.value - 1*document.all.checkPay.value;
}

 
//add by liubo ���볷�� end-----------------------------------------		


function show4100Page(){
    var path="/npage/sq046/show4100Page.jsp?oldMSISDN=<%=oldMSISDN%>&servPhoneNo=<%=servPhoneNo%>";
    var ret=window.showModalDialog(path,"","dialogWidth:750px;center:yes;");
}
</script>
     <!--ͨ���ͻ�������Ų�ѯ�ͻ�����״̬ -->
     <%
     	long startTime2 = System.currentTimeMillis();
     	System.out.println("------------------custOrderId---------------------"+custOrderId);
     %>
<%String regionCode_sQCustOrderInfo = (String)session.getAttribute("regCode");%>
     <wtc:utype name="sQCustOrderInfo" id="retVal" scope="end"  routerKey="region" routerValue="<%=regionCode_sQCustOrderInfo%>">
          <wtc:uparam value="<%=custOrderId%>" type="STRING"/>      
     </wtc:utype>
<%
		long endTime2 = System.currentTimeMillis();
		System.out.println("...................���ö���״̬��ѯ��ʱ��Ϊ:  " + endTime2 +"-" + startTime2 + " =="+(endTime2-startTime2));

       retCode_046 = retVal.getValue(0);
       retMsg_046 = retVal.getValue(1);
       
      System.out.println("------------------retCode_046---------------------"+retCode_046);
			System.out.println("------------------retMsg_046----------------------"+retMsg_046);
			
     if(!retCode_046.equals("0")){
%>
<script>
       rdShowMessageDialog("��ѯ�ͻ�����״̬��Ϣʧ�ܣ�",0);	   
       window.history.go(-1);
</script>
<%
     }
     System.out.println();
     String feeStatus = retVal.getValue("2.1.0");//�ɷ�״̬,0δ�ɷ�,1�ѽɷ�,2���ֽɷ�
     if(feeStatus.equals("0")){
          feeStatus = "δ�ɷ�";
     }else if(feeStatus.equals("1")){
          feeStatus = "�ѽɷ�";     
     }else{
         feeStatus = "���ֽɷ�";    
     }
%>

<div id = "operation">
  <FORM action="" method="post" name="form1" id="Form" >
<%@ include file="/npage/include/header.jsp" %>  

     <div class="title"><div id="title_zi">�ͻ�������Ϣ</div></div>
     <%@ include file="/npage/common/qcommon/bd_0002.jsp" %>
</div>
<div id="Operation_Table">
     <div class="title"><div id="title_zi">δ�ɷѶ���</div></div>
     <div class="list">
     <table  cellSpacing=0>
     	<tr>
     		<th>ѡ��</th><th>�ͻ��������</th><th>����Ӫҵ��</th><th>��������ʱ��</th><th>����״̬</th><th>��������</th><th>�ɷ�״̬</th>
     	</tr>
     	<tr>
     		<td><input type="radio" checked disabled="true" name="sCustOrderId" id="sCustOrderId" value="<%=custOrderId%>" onclick="FeeCheck()">1</td>
     		<td><%=custOrderId%></td> 
     		<td><%=retVal.getValue("2.0.1")%></td>
     		<td><%=retVal.getValue("2.0.3")%></td>
     		<td><%=retVal.getValue("2.0.4")%></td>
     		<td><%=retVal.getValue("2.0.5")%></td>
     		<td><%=feeStatus%></td>	
     	</tr>
     </table>
     </div>
     </div>
<div id="Operation_Table">
     <div class="title"><div id="title_zi">�ͻ���������</div></div>
     <div class="list">
          <table  cellSpacing=0 id="listdiv2">
               <tr>
                    <th>�ͻ��������</th>
                    <th>�ͻ�����������</th>
                    <th>ҵ���������</th>
                    <th>����Ʒ</th>
                    <th>��������״̬</th> 
                    <th>����ʱ��</th>
                    <th>����Ա��</th>
               </tr>                                                                        
          </table> 
     </div>
     
     
     </div>
<div id="Operation_Table">
     <div class="title"><div id="title_zi">���񶨵���Ϣ</div></div>
		<div class="list" id="tbl1">
          <table  cellSpacing=0 id="servtbl">
          	<tr>
          		 <th>���񶨵���</th><th>�ͻ����������</th><th>ҵ�����</th><th>�û�����</th><th>��������</th><th>�ɷ�״̬</th> 
          	</tr> 
          </table>
     </div>
</div>
<div id="Operation_Table">
    <div class="title"><div id="title_zi">ѡ�����ÿ�Ŀ</div></div>
     <div class="list" id="tbl2">
     	 <table  cellSpacing=0 id="feetbl">
                 <tr>
                 	 <th>���񶨵���</th>
                   <th>���ÿ�Ŀ</th>
                   <th>Ӧ�ս��</th>
                   <th  style=\"display:none\">�Żݽ��</th>
                   <th>ʵ�ս��</th>
                   
                   <th>��ȡ��ʽ</th>
                   <th>��ӡ</th>
                   <th>˵��</th>
                 </tr>            
               </table>
     </div>
	<div class="search">
		<table cellSpacing=0>
		  <tr>
			<td class=blue>Ӧ���ܶ�</td>
			<td>
                    <input type="text" name="totalFee1" class='forMoney required' vflag=1  id="totalFee1" size="15" readonly="true" />
               </td>
               
               <td class=blue>ʵ���ܶ�</td>
            	<td>
                    <input type="text" name="totalFee3" class='forMoney required' vflag=1  id="totalFee3" size="15" readonly="true" />
               </td>
                    <input type="hidden" name="totalFee2"  vflag=1  id="totalFee2" size="15" readonly="true"   />
		   </tr>
		   <TR  > 
                  <TD nowrap   class=blue > 
                    <div align="left">���ʽ</div>
                  </TD>
                  <TD nowrap  > 
                    <input name="checkRadio" type="radio" onclick="checkWay()" value="check"  index="48">
                    ֧Ʊ���� <br>	
                    &nbsp;<input type="radio" name="NocheckRadio" onClick="NocheckWay()" value="nocheck" checked index="49">
                    ��֧Ʊ���� 
                   <!-- ningtn 20100201 tianyang add for pos --><br>
					&nbsp;<input name="ccb" type="radio" onclick="checkCCB()" value="ccb"  index="50">��������POS������<br>					      
				    &nbsp;<input name="icbc" type="radio" onClick="checkICBC()" value="icbc" index="51">��������POS������
                  </TD>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
          </tr>
		</table>
		    
		    <TABLE id=check0  cellSpacing="0" style="display:none">
                <TBODY> 
                <TR > 
                  <TD  nowrap class=blue   width=15%> 
                    <div align="left">֧Ʊ����</div>
                  </TD>
                  <TD  nowrap   width=35%> 
                    <input class="button" v_must=0 v_name="֧Ʊ����" v_type="0_9" name=checkNo maxlength=20 onkeyup="if(event.keyCode==13)getBankCode();" index="50">
                    <font color="red">*</font>
								<input name=bankCodeQuery type=button class="b_text" style="cursor:hand" onClick="getBankCode()" value=��ѯ>
            </TD>
                  <TD nowrap class=blue   width=15%> 
                    <div align="left">���д���</div>
                  </TD>
                  <TD  nowrap   width=35%> 
                    <input name=bankCode  class="button" maxlength="12" readonly Class="InputGrey" size="8">
				<input name=bankName  class="button" readonly Class="InputGrey">
                  </TD>                                              
            </TR>
           </TBODY>
         </TABLE>
        <TABLE id=chPayNum0  cellSpacing="0" style="display:none">
          <TBODY> 
            <TR> 
                  <TD  nowrap class=blue width="15%"> 
                    <div align="left">֧Ʊ����</div>
                  </TD>
            <TD  width="35%">
              	    <input class="button" v_must=1 v_type=money v_account=subentry name=checkPay value=0.00 maxlength=15 onkeyup="getpreFee()" index="51" onblur="checkElement(this)">
                    <font color="red">*</font> </TD> 
                  <TD  class=blue width="15%"> 
                    <div align="left">֧Ʊ���</div>
                  </TD>
                  <TD  width="35%"> 
                    <input class="button" name="checkPrePay" value=0.00 readonly Class="InputGrey">
                  </TD>               
            </TR>            
          </TBODY>
        </TABLE>
         
     </div>
     </div>
<div id="Operation_Table">
 	<div class="title"><div id="title_zi">��ע��Ϣ</div></div> 
 	<div class="input">	
			<table cellSpacing=0>
		 
				<tr>
					<td class=blue>�û���ע</td>
					<td colspan="3">
							<input type="hidden" size="100"  value="" name="op_note" id="op_note"/>
							<input type="text" size="100" maxlength="100"  value=""  name="sys_note" id="sys_note" readOnly class="InputGrey"  />
					</td>
				</tr>			
				<tr>
					<td id=footer colspan=4>
						<div id="operation_button">
	<input type="button" class="b_foot_long" name="b_pay_way" value="ͬ����ȡ��ʽ" onclick="changeAll('feeWay')" style="display:none"/>
	<input type="button" class="b_foot_long" name="b_is_print" value="ͬ����ӡ��ʽ" onclick="changeAll('isPrint')" style="display:none"/>
		<input type="button" class="b_foot_long" name="BAddOtherFee" value="��������" onClick="addType()" style="display:none"/>
		<input type="hidden"  value="<%=offeridkd%>">
    <input type="button" class="b_foot_long" name="fee_submit" id="fee_submit"  onclick="submit_cfm()"   value="�շѴ���" />
   <input class="b_foot" name=confirm  type=button index="8" value="����" onclick="commitJsp3('q034','����')" onkeydown="if(event.keyCode==13){}">
   <%if(opcodeadd.equals("4100")){%>
   	<input class="b_foot_long" name=confirm  type=button index="8" value="��ѯ��ʡ�������" onclick="show4100Page()">
   <%}%>
</div>
					</td>
				</tr>	 
			</table>
		</div>	
</div>

	<%@ include file="/npage/include/footer.jsp" %>
	<input type="hidden" name="arrayOrder" id="arrayOrder" value="">
	<input type="hidden" name="servOrder" id="servOrder" value="">
	<input type="hidden" name="feeStr" id="feeStr" value="">
	<input type="hidden" name="custOrderId" id="custOrderId" value="<%=custOrderId%>">
	<input type="hidden" name="opCode" id="opCode" value="<%=opCode%>">
	<input type="hidden" name="opName" id="opName" value="<%=opName%>">
	<input type="hidden" name="gCustId" id="opName" value="<%=gCustId%>">
	<input type="hidden" name="feeWay" id="feeWay" value="0">
	<input type="hidden" name="isPrint" id="isPrint" value="0">
	<input type="hidden" name="prtAccpetLoginStr" id="prtAccpetLoginStr" value="0">
	<input type="hidden" name="payFeeAfter" id="payFeeAfter" value="0">
	
	<!-- tianyang add at 20100201 for POS�ɷ�����*****start*****-->			
	<input type="hidden" name="payType"  value=""><!-- �ɷ����� payType=BX �ǽ��� payType=BY �ǹ��� -->			
	<input type="hidden" name="MerchantNameChs"  value=""><!-- �Ӵ˿�ʼ����Ϊ���в��� -->
	<input type="hidden" name="MerchantId"  value="">
	<input type="hidden" name="TerminalId"  value="">
	<input type="hidden" name="IssCode"  value="">
	<input type="hidden" name="AcqCode"  value="">
	<input type="hidden" name="CardNo"  value="">
	<input type="hidden" name="BatchNo"  value="">
	<input type="hidden" name="Response_time"  value="">
	<input type="hidden" name="Rrn"  value="">
	<input type="hidden" name="AuthNo"  value="">
	<input type="hidden" name="TraceNo"  value="">
	<input type="hidden" name="Request_time"  value="">
	<input type="hidden" name="CardNoPingBi"  value="">
	<input type="hidden" name="ExpDate"  value="">
	<input type="hidden" name="Remak"  value="">
	<input type="hidden" name="TC"  value="">
	<!-- tianyang add at 20100201 for POS�ɷ�����*****end*******-->
	<input type="hidden" name="broadNo" id="broadNo" value="">
	<input type="hidden" name="joinMarketHid" id="joinMarketHid" value="">
	
</form>
</div>

<!-- **** tianyang add for pos ******���ؽ��пؼ�ҳ BankCtrl ******** -->
<%@ include file="/npage/sq046/posCCB.jsp" %>
<!-- **** tianyang add for pos ******���ع��пؼ�ҳ KeeperClient ******** -->
<%@ include file="/npage/sq046/posICBC.jsp" %>

</body>
</html>
<%
		endTime1 = System.currentTimeMillis();
	 	System.out.println("...................���������ʱ��Ϊ:  " + endTime1 +"-" + beginTime1 + " =="+(endTime1-beginTime1));	
	 	
	 	long totalend =  System.currentTimeMillis();
	 	System.out.println("...................��ʱ��:  " + totalend +"-" + totalBegin + " =="+(totalend-totalBegin));	
	 	
}%>
     