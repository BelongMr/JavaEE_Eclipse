<%
  /*
   * ����: ���˲�������
�� * �汾: v1.00
�� * ����: 2007/09/13
�� * ����: liubo
�� * ��Ȩ: sitech
   * �޸���ʷ
   * �޸�����      �޸���      �޸�Ŀ��
   *
   *update:liutong@20080916
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page contentType="text/html;charset=GBK"%>

<%@ page import="com.sitech.boss.pub.util.Encrypt"%>
<%@ include file="../../include/remark1.htm" %>

<%
    /**
    ArrayList arr = (ArrayList)session.getAttribute("allArr");
    String[][] baseInfo = (String[][])arr.get(0);
    String[][] agentInfo = (String[][])arr.get(2);
    String[][] favInfo = (String[][])arr.get(3);
    String[][] pass = (String[][])arr.get(4);

    String ip_Addr = agentInfo[0][2];
    String workno = baseInfo[0][2];
    String workname = baseInfo[0][3];
    String power_right=baseInfo[0][5];
    String org_code = baseInfo[0][16];
    String nopass  = pass[0][0];
    **/


	String workno =(String)session.getAttribute("workNo");
	String workname =(String)session.getAttribute("workName");
	String org_code = (String)session.getAttribute("orgCode");
	String regionCode = org_code.substring(0,2);
	String ip_Addr = (String)session.getAttribute("ipAddr");
	String nopass = (String)session.getAttribute("password");
	String[][]  temfavStr = (String[][])session.getAttribute("favInfo");
	String  powerCode= (String)session.getAttribute("powerCode");
	String  power_right= (String)session.getAttribute("powerRight");
	String  groupId = (String)session.getAttribute("groupId");

	String accountType = (String)session.getAttribute("accountType");



    String phone="";
    phone = request.getParameter("activePhone");
    if(null==phone||phone.equals("")){
      phone = request.getParameter("phone_no");
    }
    System.out.println(phone+"________________________________________________________________________");

    String regionCode_kf = "";
	String groupId_kf = groupId;
	if(accountType.equals("2")&&(!(null==phone||phone.equals("")))){//����ǿͷ����ţ����²�ѯregionCode
	%>
		<wtc:utype name="sQryRegionCkf" id="retVal" scope="end">
					<wtc:uparam value="<%=workno%>" type="STRING"/>
					<wtc:uparam value="<%=phone%>" type="STRING"/>
					<wtc:uparam value="0" type="LONG"/>
		</wtc:utype>
	<%
		regionCode_kf = retVal.getValue("2.0");
		groupId_kf = retVal.getValue("2.1");
	 }
	System.out.println("----------groupId_kf-----------"+groupId_kf);
    String onloadflag=request.getParameter("flag");
    int    nextFlag=1;
    String OpCode ="6710";
    String sInOpNote  ="������Ϣ��ʼ��";
    String opCode = "6710";
    String opName = "���˲�������";

   // String[][] temfavStr=(String[][])arr.get(3);   ���滻
	  String sqlStr1="";
	//String[][] retListString1 = null;

	  //��ȡ����ҳ�õ�����Ϣ
	  String loginAccept = request.getParameter("login_accept");

	  String matureProdName = "";
	  String mebProdName = "";

	//SPubCallSvrImpl impl = new SPubCallSvrImpl();
		//ArrayList retList1 = new ArrayList();
		if(loginAccept == null)
		{
			//��ȡϵͳ��ˮ
	 		//sqlStr1 ="SELECT sMaxSysAccept.nextval FROM dual";
	 		//retList1 = impl.sPubSelect("1",sqlStr1,"region",regionCode);
	 		//retListString1 = (String[][])retList1.get(0);
	 		%>
           <wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>"  id="retListString1"/>
	 		<%
            loginAccept=retListString1;
		}

	  String op_code = "6710"  ;
	  String dateStr=new java.text.SimpleDateFormat("yyyyMM").format(new java.util.Date());

	  String phone_no           ="";
	  String password           ="";
	  String sOutCustId         ="";             //�ͻ�ID_NO
	  String sOutCustName       ="";             //�ͻ�����
	  String sOutSmCode         ="";             //����Ʒ�ƴ���
	  String sOutSmName         ="";             //����Ʒ������
	  String sOutProductCode    ="";             //����Ʒ����
	  String sOutProductName    ="";             //����Ʒ����
	  String sOutPrePay         ="";             //����Ԥ��
	  String sOutRunCode        ="";             //����״̬����
	  String sOutRunName        ="";             //����״̬����
	  String sOutUsingCRProdCode="";             //�Ѷ��������Ʒ
	  String sOutUsingCRProdName="";             //�Ѷ��������Ʒ����
	  String sOutCustAddress    ="";             //�û���ַ
     String sOutIdIccid        ="";             //֤������

	  String action=request.getParameter("action");

	  if (action!=null&&action.equals("select")){
	    phone_no = request.getParameter("phone_no");
	    password = request.getParameter("password");
	    String Pwd1 = Encrypt.encrypt(password);      	//�ڴ˶��û�������������м���

    //  SPubCallSvrImpl callView = new SPubCallSvrImpl();
		 	String paramsIn[] = new String[6];

		  paramsIn[0]=workno;                                 //��������
	     paramsIn[1]=nopass;                                 //������������
	     paramsIn[2]=OpCode;                                 //��������
	     paramsIn[3]=sInOpNote;                              //��������
	     paramsIn[4]=phone_no;                              //�û��ֻ�����
	     paramsIn[5]=Pwd1;                                   //�û�����

		//	ArrayList acceptList = new ArrayList();


%>
           <wtc:service name="s6710Init" routerKey="regionCode" routerValue="<%=regionCode%>"  retcode="errCode" retmsg="errMsg"  outnum="13" >
					<wtc:param value="<%=  paramsIn[0]%>"/>
					<wtc:param value="<%=  paramsIn[1]%>"/>
					<wtc:param value="<%=  paramsIn[2]%>"/>
					<wtc:param value="<%=  paramsIn[3]%>"/>
					<wtc:param value="<%=  paramsIn[4]%>"/>
					<wtc:param value="<%=  paramsIn[5]%>"/>
			</wtc:service>
			<wtc:array id="result" scope="end" />
<%
		//	acceptList = callView.callFXService("s6710Init", paramsIn, "13");
		//	callView.printRetValue();




		 if(errCode.equals("0")||errCode.equals("000000")){
          System.out.println("���÷���s6710Init in f6710_1.jsp �ɹ�@@@@@@@@@@@@@@@@@@@@@@@@@@");
 	        	if(result.length==0){

 	            }else{
 	            	nextFlag = 2;

					sOutCustId             =result  [0][0];
					sOutCustName        =result  [0][1];
					sOutSmCode          =result  [0][2];
					sOutSmName         =result  [0][3];
					sOutProductCode   =result  [0][4];
					sOutProductName  =result  [0][5];
					sOutPrePay            =result  [0][6].trim();
					sOutRunCode         =result  [0][7];
					sOutRunName         =result [0][8];
					sOutUsingCRProdCode =result [0][9];
					sOutUsingCRProdName =result [0][10];
					sOutCustAddress     =result [0][11];            // �û���ַ
	              sOutIdIccid             =result [0][12];            // ֤������

 	        	}

 	     	}else{

 	         	System.out.println(errCode+"    errCode");
 	     		System.out.println(errMsg+"    errMsg");
 			   System.out.println("���÷���s6710Init in f6710_1.jsp ʧ��@@@@@@@@@@@@@@@@@@@@@@@@@@");

 			   %>
			    <script language='jscript'>
			       rdShowMessageDialog("<%=errCode%>" + "[" + "<%=errMsg%>" + "]" ,0);
			       removeCurrentTab();
		      </script>

			   <%
 			}
	 }
%>

<HTML><HEAD><TITLE>������BOSS-���˲�������</TITLE>

<script language="JavaScript">

onload=function()
{
	<%
	  if(null==onloadflag||onloadflag.equals("")){
	   onloadflag="0";

	  }
	%>

}

function doProcess(packet)
{
	var retType = packet.data.findValueByName("retType");
	var retCode = packet.data.findValueByName("retCode");
	var retMessage = packet.data.findValueByName("retMessage");
	self.status="";
	//�����Ʒ
  if(retType == "changProd"){
	  var triListData = packet.data.findValueByName("tri_list");
	 	var triList=new Array(triListData.length);
	  triList[0]="mebProdCode";
	  document.all("mebProdCode").length=0;
	  document.all("mebProdCode").options.length=triListData.length;
	  for(j=0;j<triListData.length;j++)
	  {
		document.all("mebProdCode").options[j].text=triListData[j][1];
		document.all("mebProdCode").options[j].value=triListData[j][1];
	  }
	  if(triListData.length!=0){
	  	 document.all("mebProdCode").options[0].selected=true;
	  	}

  }
}

//ȷ���ύ
function refain()
{ 	getAfterPrompt();
	if(document.form.mebProdCode.value=="")
	{
		rdShowMessageDialog("��ѡ���Ʒ���룡");
		return false;
	}

	if(document.form.mebMonthFlag.value=="2" || document.form.mebMonthFlag.value=="3" || document.form.mebMonthFlag.value=="5" || document.form.mebMonthFlag.value=="6")
	{
		document.all.opCode.value="6716";
	}
	else if(document.form.mebMonthFlag.value=="1")
	{
		document.all.opCode.value="6710";
	}

	if(document.form.matureFlag.value=="Y")
	{
		if(document.form.matureProdCode.value=="" )
		{
			rdShowMessageDialog("��ѡ����굽��ת���²�Ʒ���룡");
			return false;
		}
	}
	document.all.sysNote.value = "�ֻ�["+(document.all.phone_no.value).trim()+"]�������ҵ��,�����Ʒ["+document.all.mebProdCode.value+"]";
	if((document.all.opNote.value).trim().length==0)
	{
      document.all.opNote.value="<%=workno%>[<%=workname%>]"+"���ֻ�["+(document.all.phone_no.value).trim()+"]���в���"+(document.all.mebMonthFlag.options[document.all.mebMonthFlag.selectedIndex].text).trim()+"ҵ������";
	}

	showPrtDlg("Detail","ȷʵҪ��ӡ���������","Yes");
	if (rdShowConfirmDialog("�Ƿ��ύȷ�ϲ�����")==1){
			document.form.action="f6710_2.jsp";
	       document.form.submit();
	    return true;
		}
}
//�����ֻ��ź����룬��ѯ������Ϣ
function doQuery()
	{
		//alert(action);
		document.form.action = "f6710_1.jsp?action=select&flag=<%=onloadflag%>";
		document.form.submit();
		//document.form.phone.visible=false;
	}




function changeOthers(){
	var mebMonthFlag=document.form.mebMonthFlag.value;
	var tbs2 = document.getElementById("tbs2");
	var tbs3 = document.getElementById("tbs3");
			if(mebMonthFlag=="1"||mebMonthFlag=="4"||mebMonthFlag=="7"){
				tbs2.style.display="none";
				tbs3.style.display="none";//updated by haoyy 20110309 block����>none ��������ѡ�����ص�
			}else if(mebMonthFlag=='2'||mebMonthFlag=='3'||mebMonthFlag=='5'||mebMonthFlag=='6'){
				tbs2.style.display="block";
				tbs3.style.display="none";
				document.form.matureFlag.value="N";
				document.form.matureProdCode.value="";
				document.form.matureProdCode.disabled=true;
			}
}
//���ݲ�Ʒ���ͽ��в�Ʒ���
function tochange()
{
	document.all.sysNote.value="";
	document.all.opNote.value="";
	document.all("mebProdCode").length=0;
	var mebMonthFlag = document.form.mebMonthFlag.value;
	var mode_type="";
	var month_num=1;
	if(mebMonthFlag=="1")
	{
		mode_type="CR01";
		month_num=1;
	}else if(mebMonthFlag=="2"){       //����
		mode_type= "CR02";
		month_num=12;
	}else if(mebMonthFlag=="3"){       //������
		mode_type= "CR02";
		month_num=6;
	}else if(mebMonthFlag=="5"){       //����
		mode_type= "CR02";
		month_num=3;
	}else if(mebMonthFlag=="4"){
		mode_type= "CR05";
		month_num=1;
	}else if(mebMonthFlag=="6"){
		mode_type= "CR02";
		month_num=24;
	}else if(mebMonthFlag=="7"){
		mode_type= "CR05";
		month_num=1;
	}
	/***********
	var sqlStr = "select a.mode_code,a.mode_code||'->'||mode_name from sbillmodecode a,scolormode b "+
				" where a.mode_code like 'CR%' and a.start_time<sysdate  and a.stop_time>sysdate "+
				" and a.power_right<=" + "<%=power_right%>" + " and a.mode_status='Y' "+
				" and a.region_code='" + "<%=regionCode%>" + "' and a.mode_type='"+mode_type+"'"+
				" and a.region_code = b.region_code and a.MODE_CODE = b.PRODUCT_CODE"+
				" and b.mode_bind='0'"+
				" and b.month_num = "+month_num;
	*************
  var sqlStr ="SELECT a.offer_id, a.offer_id||'-->'||a.offer_name  "+
	"  FROM product_offer a, region b, dchngroupinfo c ,scolormode d"+
	"  WHERE a.offer_id = b.offer_id                                "+
	"  AND b.GROUP_ID = c.parent_group_id                           "+
	"  AND to_char(a.offer_id) = rtrim(d.PRODUCT_CODE)              "+
	"  AND a.eff_date < SYSDATE                                     "+
	"  AND a.exp_date > SYSDATE                                     "+
	"  AND a.offer_attr_type = '"+mode_type+"'                      "+
	"  AND a.state = 'A'                                            "+
	"  AND c.GROUP_ID = '<%=groupId_kf%>'                              "+
	"  AND b.RIGHT_LIMIT <= <%=power_right%>                        "+
	"  and d.mode_bind='0'                                          "+
	"  and d.month_num = "+ month_num +
	"	 and a.offer_id not in ('40449','40425','40426','40427','40428','40429','40430','40431','40432','40433','40434','40435','40436')";
	*/
	
  			var sqlStr ="90000085";
				var params = mode_type +"|<%=groupId_kf%>|<%=power_right.trim()%>|"+month_num+"|";
				var outNum = "2";
		var myPacket = new AJAXPacket("/npage/rpt/select_rpc.jsp","���ڻ��ҵ��ģʽ��Ϣ�����Ժ�......");
		myPacket.data.add("retType","changProd");
		myPacket.data.add("sqlStr",sqlStr);
		myPacket.data.add("params",params);
		myPacket.data.add("outNum",outNum);
		core.ajax.sendPacket(myPacket);
		myPacket=null;
		changeOthers();
}

function changeMatureFlag(){
	var matureFlag=document.form.matureFlag.value;
	if(matureFlag=="N"){
	 document.form.matureProdCode.value="";
	 document.form.matureProdCode.disabled=true;
   }else{
   document.form.matureProdCode.disabled=false;
   }
}

function changeHasShow()
{
	if(document.forms[0].has_show.checked)
	{
		document.forms[0].has_show_flag.value = '002';
	}
	else
	{
		document.forms[0].has_show_flag.value = '000';
	}
}

function showPrtDlg(printType,DlgMessage,submitCfm) {  //��ʾ��ӡ�Ի���
			   var h=210;
			   var w=400;
			   var t=screen.availHeight/2-h/2;
			   var l=screen.availWidth/2-w/2;
			   	var pType="subprint";
				var billType="1";
			   var printStr = printInfo(printType);
			   if(printStr == "failed")
			   {    return false;   }
				var mode_code=null;
				var fav_code=null;
				var area_code=null
				var opCode="6710";
			   var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no"
				var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_hw.jsp?DlgMsg=" + DlgMessage;
				var path = path  + "&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode="+opCode+"&sysAccept=<%=loginAccept%>&phoneNo=<%=phone%>&submitCfm=" + submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
			   var ret=window.showModalDialog(path,"",prop);
			}

			function printInfo(printType) {
					var isyear = document.all.mebMonthFlag.value;
					var sInEndChgFlag = document.all.matureFlag.value;
					var matureProdCode = document.all.matureProdCode.value;
					var istime = "";
					var retInfo = "";
			      	var cust_info="";
				 	var opr_info="";
				  	var note_info1="";
				  	var note_info2="";
				  	var note_info3="";
				  	var note_info4="";
					if(isyear==1) {
						isyear="�����������";
						istime="����";
						sInEndChgFlag = "";
						matureProdCode ="";
						cust_info+="�ֻ����룺"+document.all.phone_no.value+"|";
						cust_info+="�ͻ�������"+'<%=sOutCustName%>'+"|";
						cust_info+="֤�����룺"+document.all.sOutIdIccid.value+"|";
						cust_info+="�ͻ���ַ��"+document.all.sOutCustAddress.value+"|";

						opr_info+="ҵ��Ʒ��:"+document.all.sm_name.value+"|";
						opr_info+="����ҵ��:"+isyear+"|";
						opr_info+="������ˮ:"+'<%=loginAccept%>'+"|";
						opr_info+="����ʱ��:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
						opr_info+="�����ʷ�:"+document.all.mebProdCode.value+"|";
						opr_info+="ҵ����Чʱ��:"+istime+"|";
						opr_info+="";

						note_info1+="������ע:"+document.all.opNote.value+"|";
						//wanghfa �޸�
						var mebProdCode = document.all.mebProdCode.value.substr(0,5);
						if (mebProdCode == 33705 || (parseInt(mebProdCode) >= 33719 && parseInt(mebProdCode) <= 33730)) {
							note_info1+="�������ҵ��5Ԫ/�£��������ײ��Żݣ�����24Сʱ����Ч�����뵱�°����¼Ʒѡ�";
						} else {
							note_info1+="�������ҵ��6Ԫ/�£��������ײ��Żݣ�����24Сʱ����Ч�����뵱�°����¼Ʒѡ�";
						}
						note_info1+=""+"|";
						//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
						retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
						retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
						return retInfo;

					}
					if(isyear==2) {
						istime="����";
						isyear="�����������";
						if(sInEndChgFlag=="N"){
							cust_info+="�ֻ����룺"+document.all.phone_no.value+"|";
							cust_info+="�ͻ�������"+'<%=sOutCustName%>'+"|";
							cust_info+="֤�����룺"+document.all.sOutIdIccid.value+"|";
							cust_info+="�ͻ���ַ��"+document.all.sOutCustAddress.value+"|";

							opr_info+="ҵ��Ʒ��:"+document.all.sm_name.value+"|";
							opr_info+="����ҵ��:"+isyear+"|";
							opr_info+="������ˮ:"+'<%=loginAccept%>'+"|";
							opr_info+="����ʱ��:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="�����ʷ�:"+document.all.mebProdCode.value+"|";
							opr_info+="ҵ����Чʱ��:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="������ע:"+document.all.opNote.value+"|";
							if(document.all.mebProdCode.value.split("-->")[0] == 32318)
							{
								note_info1+="50Ԫ����ʹ�÷�Ϊ�������ҵ��ר�ֻ�����ڲ������ҵ��ʹ�ã���ÿ�´�50Ԫ�л���4.16Ԫ�������ֻ��ʻ���֧�����µĲ�����á�"+"|";
							}
							else
							{
								note_info1+="60Ԫ����ʹ�÷�Ϊ�������ҵ��ר�ֻ�����ڲ������ҵ��ʹ�ã���ÿ�´�60Ԫ�л���5Ԫ�������ֻ��ʻ���֧�����µĲ�����á�"+"|";
							}
							note_info1+="ҵ����Ч��Ϊ12���Ʒ��£���ͨ�������ҵ��Ĵ���Ϊ��Ч�ڵĵ�1���Ʒ��¡�"+"|";
							note_info1+="�������δ����ǰȡ��ҵ��ʣ��ķ��ò��ˡ���ת������ҵ��ȡ���Ĵ����µף�ʣ��������ƶ���˾�ջء�"+"|";
							note_info1+="�������ҵ���ں���ϵͳ�Զ�ȡ����ҵ��"+"|";
							note_info1+=""+"|";
							//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
						else
						{
							cust_info+="�ֻ����룺"+document.all.phone_no.value+"|";
							cust_info+="�ͻ�������"+'<%=sOutCustName%>'+"|";
							cust_info+="֤�����룺"+document.all.sOutIdIccid.value+"|";
							cust_info+="�ͻ���ַ��"+document.all.sOutCustAddress.value+"|";

							opr_info+="ҵ��Ʒ��:"+document.all.sm_name.value+"|";
							opr_info+="����ҵ��:"+isyear+"|";
							opr_info+="������ˮ:"+'<%=loginAccept%>'+"|";
							opr_info+="����ʱ��:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="�����ʷ�:"+document.all.mebProdCode.value+"|";
							opr_info+="ҵ����Чʱ��:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="������ע:"+document.all.opNote.value+"|";

							if(document.all.mebProdCode.value.split("-->")[0] == 32318)
							{
								note_info1+="50Ԫ����ʹ�÷�Ϊ�������ҵ��ר�ֻ�����ڲ������ҵ��ʹ�ã���ÿ�´�50Ԫ�л���4.16Ԫ�������ֻ��ʻ���֧�����µĲ�����á�"+"|";
							}
							else
							{
								note_info1+="60Ԫ����ʹ�÷�Ϊ�������ҵ��ר�ֻ�����ڲ������ҵ��ʹ�ã���ÿ�´�60Ԫ�л���5Ԫ�������ֻ��ʻ���֧�����µĲ�����á�"+"|";
							}
							note_info1+="ҵ����Ч��Ϊ12���Ʒ��£���ͨ�������ҵ��Ĵ���Ϊ��Ч�ڵĵ�1���Ʒ��¡�"+"|";
							note_info1+="�������δ����ǰȡ��ҵ��ʣ��ķ��ò��ˡ���ת������ҵ��ȡ���Ĵ����µף�ʣ��������ƶ���˾�ջء�"+"|";
							note_info1+="��������ʷѵ��ں��Զ�תΪ�������ҵ���ʷѱ�׼Ϊ6Ԫ/�¡�"+"|";
							//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
					}
					if(isyear==3) {
						istime="����";
						isyear="�������������";
						if(sInEndChgFlag=="N"){
							cust_info+="�ֻ����룺"+document.all.phone_no.value+"|";
							cust_info+="�ͻ�������"+'<%=sOutCustName%>'+"|";
							cust_info+="֤�����룺"+document.all.sOutIdIccid.value+"|";
							cust_info+="�ͻ���ַ��"+document.all.sOutCustAddress.value+"|";

							opr_info+="ҵ��Ʒ��:"+document.all.sm_name.value+"|";
							opr_info+="����ҵ��:"+isyear+"|";
							opr_info+="������ˮ:"+'<%=loginAccept%>'+"|";
							opr_info+="����ʱ��:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="�����ʷ�:"+document.all.mebProdCode.value+"|";
							opr_info+="ҵ����Чʱ��:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="������ע:"+document.all.opNote.value+"|";
							note_info1+="30Ԫ������ʹ�÷�Ϊ���������ר�ֻ�����ڲ��������ҵ��ʹ�ã���ÿ�´�30Ԫר���л���5Ԫ�������ֻ�������֧�����µĲ�����á�"+"|";
							note_info1+="ҵ����Ч��Ϊ6���Ʒ��£���ͨ���������ҵ��Ĵ���Ϊ��Ч�ڵĵ�1���Ʒ��¡�"+"|";
							note_info1+="���������ҵ��δ����ǰȡ��ҵ��ʣ��ķ��ò��ˡ���ת������ҵ��ȡ���Ĵ����µף����ƶ���˾�ջء�"+"|";
							note_info1+="����������ʷѵ��ں���ϵͳ�Զ�ȡ����ҵ��"+"|";
							note_info1+=""+"|";
							//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
						else
						{
							cust_info+="�ֻ����룺"+document.all.phone_no.value+"|";
							cust_info+="�ͻ�������"+'<%=sOutCustName%>'+"|";
							cust_info+="֤�����룺"+document.all.sOutIdIccid.value+"|";
							cust_info+="�ͻ���ַ��"+document.all.sOutCustAddress.value+"|";

							opr_info+="ҵ��Ʒ��:"+document.all.sm_name.value+"|";
							opr_info+="����ҵ��:"+isyear+"|";
							opr_info+="������ˮ:"+'<%=loginAccept%>'+"|";
							opr_info+="����ʱ��:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="�����ʷ�:"+document.all.mebProdCode.value+"|";
							opr_info+="ҵ����Чʱ��:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="������ע:"+document.all.opNote.value+"|";
							note_info1+="30Ԫ������ʹ�÷�Ϊ���������ר�ֻ�����ڲ��������ҵ��ʹ�ã���ÿ�´�30Ԫר���л���5Ԫ�������ֻ��ʻ���֧�����µĲ�����á�"+"|";
							note_info1+="ҵ����Ч��Ϊ6���Ʒ��£���ͨ���������ҵ��Ĵ���Ϊ��Ч�ڵĵ�1���Ʒ��¡�"+"|";
							note_info1+="���������ҵ��δ����ǰȡ��ҵ��ʣ��ķ��ò��ˡ���ת������ҵ��ȡ���Ĵ����µף����ƶ���˾�ջء�"+"|";
							note_info1+="����������ʷѵ��ں��Զ�תΪ�������ҵ���ʷѱ�׼Ϊ6Ԫ/�¡�"+"|";

							//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
					}
					if(isyear==4) {
						istime="����";
						isyear="���еش�0Ԫ����";
						if(sInEndChgFlag=="N"){
							cust_info+="�ֻ����룺"+document.all.phone_no.value+"|";
							cust_info+="�ͻ�������"+'<%=sOutCustName%>'+"|";
							cust_info+="֤�����룺"+document.all.sOutIdIccid.value+"|";
							cust_info+="�ͻ���ַ��"+document.all.sOutCustAddress.value+"|";

							opr_info+="ҵ��Ʒ��:"+document.all.sm_name.value+"|";
							opr_info+="����ҵ��:"+isyear+"|";
							opr_info+="������ˮ:"+'<%=loginAccept%>'+"|";
							opr_info+="����ʱ��:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="�����ʷ�:"+document.all.mebProdCode.value+"|";
							opr_info+="ҵ����Чʱ��:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="������ע:"+document.all.opNote.value+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
						else
						{
							cust_info+="�ֻ����룺"+document.all.phone_no.value+"|";
							cust_info+="�ͻ�������"+'<%=sOutCustName%>'+"|";
							cust_info+="֤�����룺"+document.all.sOutIdIccid.value+"|";
							cust_info+="�ͻ���ַ��"+document.all.sOutCustAddress.value+"|";

							opr_info+="ҵ��Ʒ��:"+document.all.sm_name.value+"|";
							opr_info+="����ҵ��:"+isyear+"|";
							opr_info+="������ˮ:"+'<%=loginAccept%>'+"|";
							opr_info+="����ʱ��:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="�����ʷ�:"+document.all.mebProdCode.value+"|";
							opr_info+="ҵ����Чʱ��:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="������ע:"+document.all.opNote.value+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
					}
					if(isyear==5) {
						istime="����";
						isyear="�����������";
					if(sInEndChgFlag=="N"){
							cust_info+="�ֻ����룺"+document.all.phone_no.value+"|";
							cust_info+="�ͻ�������"+'<%=sOutCustName%>'+"|";
							cust_info+="֤�����룺"+document.all.sOutIdIccid.value+"|";
							cust_info+="�ͻ���ַ��"+document.all.sOutCustAddress.value+"|";

							opr_info+="ҵ��Ʒ��:"+document.all.sm_name.value+"|";
							opr_info+="����ҵ��:"+isyear+"|";
							opr_info+="������ˮ:"+'<%=loginAccept%>'+"|";
							opr_info+="����ʱ��:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="�����ʷ�:"+document.all.mebProdCode.value+"|";
							opr_info+="ҵ����Чʱ��:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="������ע:"+document.all.opNote.value+"|";
							note_info1+="15Ԫ����ʹ�÷�Ϊ�������ҵ��ר�ֻ�����ڲ������ҵ��ʹ�ã���ÿ�´�15Ԫ�л���5Ԫ�������ֻ��ʻ���֧�����µĲ�����á�"+"|";
							note_info1+="ҵ����Ч��Ϊ3���Ʒ��£���ͨ�������ҵ��Ĵ���Ϊ��Ч�ڵĵ�1���Ʒ��¡�"+"|";
							note_info1+="�������δ����ǰȡ��ҵ��ʣ��ķ��ò��ˡ���ת������ҵ��ȡ���Ĵ����µף�ʣ��������ƶ���˾�ջء�"+"|";
							note_info1+="�������ҵ���ں���ϵͳ�Զ�ȡ����ҵ��"+"|";
							//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
						else
						{
							cust_info+="�ֻ����룺"+document.all.phone_no.value+"|";
							cust_info+="�ͻ�������"+'<%=sOutCustName%>'+"|";
							cust_info+="֤�����룺"+document.all.sOutIdIccid.value+"|";
							cust_info+="�ͻ���ַ��"+document.all.sOutCustAddress.value+"|";

							opr_info+="ҵ��Ʒ��:"+document.all.sm_name.value+"|";
							opr_info+="����ҵ��:"+isyear+"|";
							opr_info+="������ˮ:"+'<%=loginAccept%>'+"|";
							opr_info+="����ʱ��:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="�����ʷ�:"+document.all.mebProdCode.value+"|";
							opr_info+="ҵ����Чʱ��:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="������ע:"+document.all.opNote.value+"|";
							note_info1+="15Ԫ����ʹ�÷�Ϊ�������ҵ��ר�ֻ�����ڲ������ҵ��ʹ�ã���ÿ�´�15Ԫ�л���5Ԫ�������ֻ��ʻ���֧�����µĲ�����á�"+"|";
							note_info1+="ҵ����Ч��Ϊ3���Ʒ��£���ͨ�������ҵ��Ĵ���Ϊ��Ч�ڵĵ�1���Ʒ��¡�"+"|";
							note_info1+="�������δ����ǰȡ��ҵ��ʣ��ķ��ò��ˡ���ת������ҵ��ȡ���Ĵ����µף�ʣ��������ƶ���˾�ջء�"+"|";
							note_info1+="��������ʷѵ��ں��Զ�תΪ�������ҵ���ʷѱ�׼Ϊ6Ԫ/�¡�"+"|";
							//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
					}
					if(isyear==6) {
						istime="����";
						isyear="�������������";
						cust_info+="�ֻ����룺"+document.all.phone_no.value+"|";
						cust_info+="�ͻ�������"+'<%=sOutCustName%>'+"|";
						cust_info+="֤�����룺"+document.all.sOutIdIccid.value+"|";
						cust_info+="�ͻ���ַ��"+document.all.sOutCustAddress.value+"|";

						opr_info+="ҵ��Ʒ��:"+document.all.sm_name.value+"|";
						opr_info+="����ҵ��:"+isyear+"|";
						opr_info+="������ˮ:"+'<%=loginAccept%>'+"|";
						opr_info+="����ʱ��:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
						opr_info+="�����ʷ�:"+document.all.mebProdCode.value+"|";
						opr_info+="ҵ����Чʱ��:"+istime+"|";
						opr_info+=""+"|";
						opr_info+=""+"|";
						opr_info+=""+"|";
						opr_info+=""+"|";

						note_info1+="������ע:"+document.all.opNote.value+"|";
						note_info1+="100Ԫ������ʹ�÷�Ϊ���������ҵ��ר�ֻ�����ڲ��������ҵ��ʹ�ã���ÿ�´�100Ԫ�л���4.16Ԫ�������ֻ��ʻ���֧�����µĲ�����á�"+"|";
						note_info1+="ҵ����Ч��Ϊ24���Ʒ��£���ͨ���������ҵ��Ĵ���Ϊ��Ч�ڵĵ�1���Ʒ��¡�"+"|";
						note_info1+="���������δ����ǰȡ��ҵ��ʣ��ķ��ò��ˡ���ת������ҵ��ȡ���Ĵ����µף�ʣ��������ƶ���˾�ջء�"+"|";
						note_info1+="���������ҵ���ں���ϵͳ�Զ�ȡ����ҵ��"+"|";
						//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
						retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
						retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
						return retInfo;
					}
					if(isyear==7) {
						istime="����";
						isyear="ȫ��ͨ������0Ԫ����";
						if(sInEndChgFlag=="N"){
							cust_info+="�ֻ����룺"+document.all.phone_no.value+"|";
							cust_info+="�ͻ�������"+'<%=sOutCustName%>'+"|";
							cust_info+="֤�����룺"+document.all.sOutIdIccid.value+"|";
							cust_info+="�ͻ���ַ��"+document.all.sOutCustAddress.value+"|";

							opr_info+="ҵ��Ʒ��:"+document.all.sm_name.value+"|";
							opr_info+="����ҵ��:"+isyear+"|";
							opr_info+="������ˮ:"+'<%=loginAccept%>'+"|";
							opr_info+="����ʱ��:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="�����ʷ�:"+document.all.mebProdCode.value+"|";
							opr_info+="ҵ����Чʱ��:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="������ע:"+document.all.opNote.value+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
						else
						{
							cust_info+="�ֻ����룺"+document.all.phone_no.value+"|";
							cust_info+="�ͻ�������"+'<%=sOutCustName%>'+"|";
							cust_info+="֤�����룺"+document.all.sOutIdIccid.value+"|";
							cust_info+="�ͻ���ַ��"+document.all.sOutCustAddress.value+"|";

							opr_info+="ҵ��Ʒ��:"+document.all.sm_name.value+"|";
							opr_info+="����ҵ��:"+isyear+"|";
							opr_info+="������ˮ:"+'<%=loginAccept%>'+"|";
							opr_info+="����ʱ��:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="�����ʷ�:"+document.all.mebProdCode.value+"|";
							opr_info+="ҵ����Чʱ��:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="������ע:"+document.all.opNote.value+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							note_info1+=""+"|";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
					}
			}


</script>
</HEAD>
<BODY>
<FORM action="" method=post name=form>
	 <%@ include file="/npage/include/header.jsp" %>

		<div class="title">
			<div id="title_zi">���˲�������</div>
		</div>

    <table cellspacing="0">
    <input type="hidden" name="opCode" value="6710">
    <input type="hidden" name="loginAccept" value="<%=loginAccept%>">
    <input type="hidden" name="loginNo" value="<%=workno%>">
    <input type="hidden" name="loginPwd" value="<%=nopass%>">
    <input type="hidden" name="orgCode" value="<%=org_code%>">
    <input type="hidden" name="ip_Addr" value="<%=ip_Addr%>">
		     <TR>
		  	     <td  width="15%"  class="blue">�ֻ�����</td>
              <td   width="35%" colspan="3">
               <input type="text" value="<%=phone%>" size="11" v_type="mobphone"  v_must=1 v_minlength=1 v_maxlength=11 name="phone_no"  maxlength="11"  onkeydown="if(event.keyCode==13)doQuery()" <%if(nextFlag==2){out.print("readonly Class=\"InputGrey\"");}%> class="InputGrey" readonly>
               <font class="orange">*</font>
               </td>


            </TR>
<%
	if(nextFlag==1)
	{
%>
            <tr>
				<td class=Lable  nowrap colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4"  id="footer">
					<div align="center">
					<input class="b_foot" name=sure22 type=button value="ȷ��" onClick="doQuery();" style="cursor:hand" <%if(nextFlag==2){out.print("disabled");}%>>
            		<input class="b_foot" name=reset22 type=reset value="���">
            		<input class="b_foot" name=close22 type=button value="�ر�" onclick="removeCurrentTab()">
					</div>
				</td>
			</tr>
<%
	}
%>
            <%
             if(nextFlag==2)//��ѯ����
             {
            %>
                <tr style="display:none">
                  <td>�ͻ�ID</td>
                  <td>
                    <input type="text" name="cust_id" maxlength="6"  class="button" value="<%=sOutCustId%>">
                    <font class="orange">*</font>
                  </td>
                </tr>
                <tr>
                  <td width="15%"  class="blue">�ͻ�����</td>
                  <td width="35%">
                    <input type="text" name="cust_name" value="<%=sOutCustName%>" <%if(nextFlag==2){out.print("readonly Class=\"InputGrey\"");}%> >
                    <input type="hidden" readonly Class="InputGrey"  name="sOutCustAddress"  value="<%=sOutCustAddress%>">
                    <input type="hidden" readonly Class="InputGrey"  name="sOutIdIccid"   value="<%=sOutIdIccid%>">
                    <font class="orange">*</font>
                  </td>
                  <td width="15%"  class="blue">����Ԥ��</td>
                  <td width="35%">
                    <input type="text" readonly Class="InputGrey"  name="PrePay" value="<%=sOutPrePay%>" <%if(nextFlag==2){out.print("readonly");}%>>
                    <font class="orange">*</font>
                  </td>
                </tr>
                <tr>
                  <td   class="blue">ҵ��Ʒ��</td>
                  <td>
                    <input type="hidden" readonly Class="InputGrey"  name="sm_code"  value="<%=sOutSmCode%>">
                    <input type="text"   readonly Class="InputGrey"    name="sm_name"  value="<%=sOutSmName%>" <%if(nextFlag==2){out.print("readonly");}%>>
                    <font class="orange">*</font>
                  </td>
                  <td  class="blue">����״̬</td>
                  <td>
                    <input type="hidden" readonly Class="InputGrey"   name="RunCode" value="<%=sOutRunCode%>">
                    <input type="text"   readonly Class="InputGrey"   name="RunName"  value="<%=sOutRunName%>" <%if(nextFlag==2){out.print("readonly");}%>>
                    <font class="orange">*</font>
                  </td>
                </tr>
                <tr>
                  <td  class="blue">�ʷ��ײ�</td>
                  <td>
                    <input type="hidden" readonly  Class="InputGrey"   name="ProductCode" maxlength="5" value="<%=sOutProductCode%>">
                    <input type="text"   readonly  Class="InputGrey"   name="ProductName" maxlength="5" value="<%=sOutProductName%>" <%if(nextFlag==2){out.print("readonly");}%>>
                    <font class="orange">*</font>
                  </td>
                  <TD>&nbsp;</TD>
                  <TD>&nbsp;</TD>
                  <td  style="display:none"  class="blue">�Ѷ��������Ʒ</td>
                  <td   style="display:none">
                    <input type="hidden" readonly  Class="InputGrey"   name="UsingCRProdCode"  maxlength="20" value="<%=sOutUsingCRProdCode%>">
                    <input type="text" readonly   Class="InputGrey"   name="UsingCRProdName" maxlength="20" value="<%=sOutUsingCRProdName%>" <%if(nextFlag==2){out.print("readonly");}%>>

                  </td>
                </tr>
            <TR>
            <TD   class="blue">
							<div align="left">ҵ������</div>
								</TD>
					       <TD >
									<SELECT name="mebMonthFlag" class="button" id="mebMonthFlag" onChange="tochange()" onclick="changeOthers()">
										<option value="1" selected>������</option>
										<option value="2" >������</option>
										<option value="3" >��������</option>
										<option value="5" >������</option>
										<option value="6" >��������</option>
										<option value="4" >���еش�0Ԫ�ײ�</option>
										<option value="7" >ȫ��ͨ������0Ԫ����</option>
									</SELECT>
									<font class="orange">*</font>
								</TD>
              <TD class="blue">�����Ʒ</TD>
               <TD >
							    <SELECT name="mebProdCode" class="button" id="mebProdCode" onChange="" >
              		<%
										//	SPubCallSvrImpl callView1 = new SPubCallSvrImpl();
										//	ArrayList retArray1 = new ArrayList();
										//	String[][] result1 = new String[][]{};
				              String sqlStr="";
				              int recordNum1=0;
											//sqlStr = "select mode_code,mode_name from sbillmodecode where  mode_code like 'CR%' and mode_type='CR01' and start_time<sysdate  and stop_time>sysdate and region_code="+regionCode;
											sqlStr = "select a.offer_id,a.offer_name from product_offer a ,region b,dchngroupinfo c where a.OFFER_ID = b.OFFER_ID and b.group_id = c.PARENT_GROUP_ID  and a.OFFER_ATTR_TYPE = 'CR01' and a.EFF_DATE <sysdate and a.exp_date >sysdate and c.GROUP_ID='"+groupId_kf+"' and a.offer_id not in ('40449','40425','40426','40427','40428','40429','40430','40431','40432','40433','40434','40435','40436')";
								//			retArray1 = callView1.sPubSelect("2",sqlStr);
								%>
								<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode2" retmsg="retMsg2" outnum="2">
								<wtc:sql><%=sqlStr%></wtc:sql>
								</wtc:pubselect>
								<wtc:array id="result1" scope="end" />
								<%
											//result1 = (String[][])retArray1.get(0);
											  if(retCode2.equals("0")||retCode2.equals("000000")){
									          System.out.println("���÷���sPubSelect in f6710_1.jsp �ɹ�@@@@@@@@@@@@@@@@@@@@@@@@@@");
									 	        	if(result1.length==0){
									 	            }else{
									 	        	  	recordNum1 = result1.length;
														for(int i=0;i<recordNum1;i++)
														{
														out.println("<option  value='" + result1[i][0] +"-->"+result1[i][1] + "'><font size=2>" + result1[i][0]+"-->"+result1[i][1] + "</font></option>");
														}

									 	        	}

									 	     	}else{
									 	         	System.out.println(retCode2+"    ret_code");
									 	     		System.out.println(retMsg2+"    retMsg2");
									 		     	System.out.println("���÷���sPubSelect in f6710_1.jsp ʧ��@@@@@@@@@@@@@@@@@@@@@@@@@@");

									 			}

              		%>
							    </SELECT>
							    <font class="orange">*</font>
							    <input type="hidden" name="mebProdName" value="<%=mebProdName%>">
							</TD>
           </TR>
	 	  <div >
           <TR span=1 id="tbs2" style="display:none">
             <TD nowrap  class="blue">
						���굽��ת����
						  </TD>
						   <TD nowrap colspan="3">
									<SELECT name="matureFlag" class="button" id="matureFlag" onChange="changeMatureFlag()" >
										<option value="Y" >��</option>
										<option value="N" selected>�� </option>
									</SELECT>
								  <SELECT name="matureProdCode" class="button" id="matureProdCode" onChange="" >
		              <%
									//SPubCallSvrImpl callView2 = new SPubCallSvrImpl();
									//ArrayList retArray2 = new ArrayList();
									//String[][] result2 = new String[][]{};
									String sqlStr2="";
		                         int recordNum2=0;
									//sqlStr2 = "select mode_code,mode_name from sbillmodecode where mode_code like 'CR%' and   start_time<sysdate  and stop_time>sysdate and  region_code="+regionCode+"and mode_type='CR01'";
									sqlStr2 = "select a.offer_id,a.offer_name from product_offer a ,region b,dchngroupinfo c where a.OFFER_ID = b.OFFER_ID and b.group_id = c.PARENT_GROUP_ID and a.OFFER_ATTR_TYPE = 'CR01' and a.EFF_DATE <sysdate and a.exp_date >sysdate and c.GROUP_ID='"+groupId_kf+"' and a.offer_id not in ('40449','40425','40426','40427','40428','40429','40430','40431','40432','40433','40434','40435','40436')";
									//retArray2 = callView2.sPubSelect("2",sqlStr2);
									//result2 = (String[][])retArray2.get(0);
									System.out.println("gaopengSeeLog===========sqlStr2="+sqlStr2);
								%>
								<wtc:pubselect name="sPubSelect" routerKey="region" routerValue="<%=regionCode%>"  retcode="retCode3" retmsg="retMsg3" outnum="2">
								<wtc:sql><%=sqlStr2%></wtc:sql>
								</wtc:pubselect>
								<wtc:array id="result2" scope="end" />
								<%
											//result1 = (String[][])retArray1.get(0);
											  if(retCode3.equals("0")||retCode3.equals("000000")){
									          System.out.println("���÷���sPubSelect in f6710_1.jsp �ɹ�@@@@@@@@@@@@@@@@@@@@@@@@@@");
									 	        	if(result2.length==0){
									 	            }else{

															recordNum2 = result2.length;
															for(int i=0;i<recordNum2;i++)
															{
															out.println("<option  value='" + result2[i][0] + "-->"+result2[i][1] +"'><font size=2>"+result2[i][0]+"->"+result2[i][1] + "</font></option>");
															}

									 	        	}

									 	     	}else{
									 	         	System.out.println(retCode3+"    ret_code");
									 	     		System.out.println(retMsg3+"    retMsg2");
									 		     	System.out.println("���÷���sPubSelect in f6710_1.jsp ʧ��@@@@@@@@@@@@@@@@@@@@@@@@@@");

									 			}

									%>
							   </SELECT>
							   <font class="orange">*</font>
							   <input type="hidden" name="matureProdName" value="<%=matureProdName%>">
           </TR>
	   </div>
	   <div >
           <TR id="tbs3" style="display:none">
           	<TD class="blue" colspan="4">&nbsp;
           		<input type="hidden" name="has_show_flag" value="000" />
           		<input type="checkbox" name="has_show" onclick="changeHasShow()">&nbsp;<b>�Ƿ�ͨ������</b>
           	</TD>
           </TR>
	   </div>
          </table>
              <table cellspacing="0">
                <tbody>
                <tr>
                  <td width=15%  class="blue">ϵͳ��ע</td>
                  <td width="85%">
                    <input readonly  Class="InputGrey" name=sysNote value="" size=60 maxlength="60">
                  </td>
                </tr>
                <tr style="display:none">
                  <td   class="blue">�û���ע</td>
                  <td >
                    <input class="button" name=opNote size=60 value="" maxlength="60">
                  </td>
                </tr>
                </tbody>
              </table>
              <table cellspacing="0">
                <tbody>
                <tr>
                  <td align=center id="footer">
                    <input class="b_foot" name=sure type="button" value=ȷ�� onclick="refain()">
                    &nbsp;
                    <input class="b_foot" name=clear type=reset value=��һ�� onClick="location = 'f6710_1.jsp?phone_no=<%=phone%>';">
                    &nbsp;
                    <input class="b_foot" name=reset type=button value=�ر� onClick="removeCurrentTab()">
                  </td>
                </tr>
                </tbody>

				    <%
				    }
				   %>
  </table>
        <%@ include file="/npage/include/footer.jsp" %>
</FORM>
</BODY>
</HTML>