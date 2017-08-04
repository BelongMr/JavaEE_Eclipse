<%
  /*
   * 功能: 个人彩铃申请
　 * 版本: v1.00
　 * 日期: 2007/09/13
　 * 作者: liubo
　 * 版权: sitech
   * 修改历史
   * 修改日期      修改人      修改目的
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
	if(accountType.equals("2")&&(!(null==phone||phone.equals("")))){//如果是客服工号，重新查询regionCode
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
    String sInOpNote  ="号码信息初始化";
    String opCode = "6710";
    String opName = "个人彩铃申请";

   // String[][] temfavStr=(String[][])arr.get(3);   被替换
	  String sqlStr1="";
	//String[][] retListString1 = null;

	  //获取从上页得到的信息
	  String loginAccept = request.getParameter("login_accept");

	  String matureProdName = "";
	  String mebProdName = "";

	//SPubCallSvrImpl impl = new SPubCallSvrImpl();
		//ArrayList retList1 = new ArrayList();
		if(loginAccept == null)
		{
			//获取系统流水
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
	  String sOutCustId         ="";             //客户ID_NO
	  String sOutCustName       ="";             //客户姓名
	  String sOutSmCode         ="";             //服务品牌代码
	  String sOutSmName         ="";             //服务品牌名称
	  String sOutProductCode    ="";             //主产品代码
	  String sOutProductName    ="";             //主产品名称
	  String sOutPrePay         ="";             //可用预存
	  String sOutRunCode        ="";             //运行状态代码
	  String sOutRunName        ="";             //运行状态名称
	  String sOutUsingCRProdCode="";             //已订购彩铃产品
	  String sOutUsingCRProdName="";             //已订购彩铃产品名称
	  String sOutCustAddress    ="";             //用户地址
     String sOutIdIccid        ="";             //证件号码

	  String action=request.getParameter("action");

	  if (action!=null&&action.equals("select")){
	    phone_no = request.getParameter("phone_no");
	    password = request.getParameter("password");
	    String Pwd1 = Encrypt.encrypt(password);      	//在此对用户传来的密码进行加密

    //  SPubCallSvrImpl callView = new SPubCallSvrImpl();
		 	String paramsIn[] = new String[6];

		  paramsIn[0]=workno;                                 //操作工号
	     paramsIn[1]=nopass;                                 //操作工号密码
	     paramsIn[2]=OpCode;                                 //操作代码
	     paramsIn[3]=sInOpNote;                              //操作描述
	     paramsIn[4]=phone_no;                              //用户手机号码
	     paramsIn[5]=Pwd1;                                   //用户密码

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
          System.out.println("调用服务s6710Init in f6710_1.jsp 成功@@@@@@@@@@@@@@@@@@@@@@@@@@");
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
					sOutCustAddress     =result [0][11];            // 用户地址
	              sOutIdIccid             =result [0][12];            // 证件号码

 	        	}

 	     	}else{

 	         	System.out.println(errCode+"    errCode");
 	     		System.out.println(errMsg+"    errMsg");
 			   System.out.println("调用服务s6710Init in f6710_1.jsp 失败@@@@@@@@@@@@@@@@@@@@@@@@@@");

 			   %>
			    <script language='jscript'>
			       rdShowMessageDialog("<%=errCode%>" + "[" + "<%=errMsg%>" + "]" ,0);
			       removeCurrentTab();
		      </script>

			   <%
 			}
	 }
%>

<HTML><HEAD><TITLE>黑龙江BOSS-个人彩铃申请</TITLE>

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
	//变更产品
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

//确认提交
function refain()
{ 	getAfterPrompt();
	if(document.form.mebProdCode.value=="")
	{
		rdShowMessageDialog("请选择产品代码！");
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
			rdShowMessageDialog("请选择包年到期转包月产品代码！");
			return false;
		}
	}
	document.all.sysNote.value = "手机["+(document.all.phone_no.value).trim()+"]申请彩铃业务,彩铃产品["+document.all.mebProdCode.value+"]";
	if((document.all.opNote.value).trim().length==0)
	{
      document.all.opNote.value="<%=workno%>[<%=workname%>]"+"对手机["+(document.all.phone_no.value).trim()+"]进行彩铃"+(document.all.mebMonthFlag.options[document.all.mebMonthFlag.selectedIndex].text).trim()+"业务申请";
	}

	showPrtDlg("Detail","确实要打印电子免填单吗？","Yes");
	if (rdShowConfirmDialog("是否提交确认操作？")==1){
			document.form.action="f6710_2.jsp";
	       document.form.submit();
	    return true;
		}
}
//输入手机号和密码，查询具体信息
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
				tbs3.style.display="none";//updated by haoyy 20110309 block——>none 将彩铃秀选项隐藏掉
			}else if(mebMonthFlag=='2'||mebMonthFlag=='3'||mebMonthFlag=='5'||mebMonthFlag=='6'){
				tbs2.style.display="block";
				tbs3.style.display="none";
				document.form.matureFlag.value="N";
				document.form.matureProdCode.value="";
				document.form.matureProdCode.disabled=true;
			}
}
//根据产品类型进行产品变更
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
	}else if(mebMonthFlag=="2"){       //包年
		mode_type= "CR02";
		month_num=12;
	}else if(mebMonthFlag=="3"){       //包半年
		mode_type= "CR02";
		month_num=6;
	}else if(mebMonthFlag=="5"){       //包季
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
		var myPacket = new AJAXPacket("/npage/rpt/select_rpc.jsp","正在获得业务模式信息，请稍候......");
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

function showPrtDlg(printType,DlgMessage,submitCfm) {  //显示打印对话框
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
						isyear="彩铃包月申请";
						istime="当日";
						sInEndChgFlag = "";
						matureProdCode ="";
						cust_info+="手机号码："+document.all.phone_no.value+"|";
						cust_info+="客户姓名："+'<%=sOutCustName%>'+"|";
						cust_info+="证件号码："+document.all.sOutIdIccid.value+"|";
						cust_info+="客户地址："+document.all.sOutCustAddress.value+"|";

						opr_info+="业务品牌:"+document.all.sm_name.value+"|";
						opr_info+="办理业务:"+isyear+"|";
						opr_info+="操作流水:"+'<%=loginAccept%>'+"|";
						opr_info+="操作时间:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
						opr_info+="彩铃资费:"+document.all.mebProdCode.value+"|";
						opr_info+="业务生效时间:"+istime+"|";
						opr_info+="";

						note_info1+="操作备注:"+document.all.opNote.value+"|";
						//wanghfa 修改
						var mebProdCode = document.all.mebProdCode.value.substr(0,5);
						if (mebProdCode == 33705 || (parseInt(mebProdCode) >= 33719 && parseInt(mebProdCode) <= 33730)) {
							note_info1+="彩铃包月业务5元/月，不参与套餐优惠，申请24小时内生效。申请当月按整月计费。";
						} else {
							note_info1+="彩铃包月业务6元/月，不参与套餐优惠，申请24小时内生效。申请当月按整月计费。";
						}
						note_info1+=""+"|";
						//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
						retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
						retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
						return retInfo;

					}
					if(isyear==2) {
						istime="次月";
						isyear="彩铃包年申请";
						if(sInEndChgFlag=="N"){
							cust_info+="手机号码："+document.all.phone_no.value+"|";
							cust_info+="客户姓名："+'<%=sOutCustName%>'+"|";
							cust_info+="证件号码："+document.all.sOutIdIccid.value+"|";
							cust_info+="客户地址："+document.all.sOutCustAddress.value+"|";

							opr_info+="业务品牌:"+document.all.sm_name.value+"|";
							opr_info+="办理业务:"+isyear+"|";
							opr_info+="操作流水:"+'<%=loginAccept%>'+"|";
							opr_info+="操作时间:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="彩铃资费:"+document.all.mebProdCode.value+"|";
							opr_info+="业务生效时间:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="操作备注:"+document.all.opNote.value+"|";
							if(document.all.mebProdCode.value.split("-->")[0] == 32318)
							{
								note_info1+="50元包年使用费为彩铃包年业务专款，只能用于彩铃包年业务使用，且每月从50元中划拨4.16元到您的手机帐户中支付当月的彩铃费用。"+"|";
							}
							else
							{
								note_info1+="60元包年使用费为彩铃包年业务专款，只能用于彩铃包年业务使用，且每月从60元中划拨5元到您的手机帐户中支付当月的彩铃费用。"+"|";
							}
							note_info1+="业务有效期为12个计费月，开通彩铃包年业务的次月为有效期的第1个计费月。"+"|";
							note_info1+="彩铃包年未到期前取消业务，剩余的费用不退、不转，且在业务取消的次月月底，剩余费用由移动公司收回。"+"|";
							note_info1+="彩铃包年业务到期后由系统自动取消此业务。"+"|";
							note_info1+=""+"|";
							//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
						else
						{
							cust_info+="手机号码："+document.all.phone_no.value+"|";
							cust_info+="客户姓名："+'<%=sOutCustName%>'+"|";
							cust_info+="证件号码："+document.all.sOutIdIccid.value+"|";
							cust_info+="客户地址："+document.all.sOutCustAddress.value+"|";

							opr_info+="业务品牌:"+document.all.sm_name.value+"|";
							opr_info+="办理业务:"+isyear+"|";
							opr_info+="操作流水:"+'<%=loginAccept%>'+"|";
							opr_info+="操作时间:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="彩铃资费:"+document.all.mebProdCode.value+"|";
							opr_info+="业务生效时间:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="操作备注:"+document.all.opNote.value+"|";

							if(document.all.mebProdCode.value.split("-->")[0] == 32318)
							{
								note_info1+="50元包年使用费为彩铃包年业务专款，只能用于彩铃包年业务使用，且每月从50元中划拨4.16元到您的手机帐户中支付当月的彩铃费用。"+"|";
							}
							else
							{
								note_info1+="60元包年使用费为彩铃包年业务专款，只能用于彩铃包年业务使用，且每月从60元中划拨5元到您的手机帐户中支付当月的彩铃费用。"+"|";
							}
							note_info1+="业务有效期为12个计费月，开通彩铃包年业务的次月为有效期的第1个计费月。"+"|";
							note_info1+="彩铃包年未到期前取消业务，剩余的费用不退、不转，且在业务取消的次月月底，剩余费用由移动公司收回。"+"|";
							note_info1+="彩铃包年资费到期后自动转为彩铃包月业务，资费标准为6元/月。"+"|";
							//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
					}
					if(isyear==3) {
						istime="次月";
						isyear="彩铃包半年申请";
						if(sInEndChgFlag=="N"){
							cust_info+="手机号码："+document.all.phone_no.value+"|";
							cust_info+="客户姓名："+'<%=sOutCustName%>'+"|";
							cust_info+="证件号码："+document.all.sOutIdIccid.value+"|";
							cust_info+="客户地址："+document.all.sOutCustAddress.value+"|";

							opr_info+="业务品牌:"+document.all.sm_name.value+"|";
							opr_info+="办理业务:"+isyear+"|";
							opr_info+="操作流水:"+'<%=loginAccept%>'+"|";
							opr_info+="操作时间:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="彩铃资费:"+document.all.mebProdCode.value+"|";
							opr_info+="业务生效时间:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="操作备注:"+document.all.opNote.value+"|";
							note_info1+="30元包半年使用费为彩铃包半年专款，只能用于彩铃包半年业务使用，且每月从30元专款中划拨5元到您的手机号码中支付当月的彩铃费用。"+"|";
							note_info1+="业务有效期为6个计费月，开通彩铃包半年业务的次月为有效期的第1个计费月。"+"|";
							note_info1+="彩铃包半年业务未到期前取消业务，剩余的费用不退、不转，且在业务取消的次月月底，由移动公司收回。"+"|";
							note_info1+="彩铃包半年资费到期后由系统自动取消此业务。"+"|";
							note_info1+=""+"|";
							//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
						else
						{
							cust_info+="手机号码："+document.all.phone_no.value+"|";
							cust_info+="客户姓名："+'<%=sOutCustName%>'+"|";
							cust_info+="证件号码："+document.all.sOutIdIccid.value+"|";
							cust_info+="客户地址："+document.all.sOutCustAddress.value+"|";

							opr_info+="业务品牌:"+document.all.sm_name.value+"|";
							opr_info+="办理业务:"+isyear+"|";
							opr_info+="操作流水:"+'<%=loginAccept%>'+"|";
							opr_info+="操作时间:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="彩铃资费:"+document.all.mebProdCode.value+"|";
							opr_info+="业务生效时间:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="操作备注:"+document.all.opNote.value+"|";
							note_info1+="30元包半年使用费为彩铃包半年专款，只能用于彩铃包半年业务使用，且每月从30元专款中划拨5元到您的手机帐户中支付当月的彩铃费用。"+"|";
							note_info1+="业务有效期为6个计费月，开通彩铃包半年业务的次月为有效期的第1个计费月。"+"|";
							note_info1+="彩铃包半年业务未到期前取消业务，剩余的费用不退、不转，且在业务取消的次月月底，由移动公司收回。"+"|";
							note_info1+="彩铃包半年资费到期后自动转为彩铃包月业务，资费标准为6元/月。"+"|";

							//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
					}
					if(isyear==4) {
						istime="次月";
						isyear="动感地带0元月租";
						if(sInEndChgFlag=="N"){
							cust_info+="手机号码："+document.all.phone_no.value+"|";
							cust_info+="客户姓名："+'<%=sOutCustName%>'+"|";
							cust_info+="证件号码："+document.all.sOutIdIccid.value+"|";
							cust_info+="客户地址："+document.all.sOutCustAddress.value+"|";

							opr_info+="业务品牌:"+document.all.sm_name.value+"|";
							opr_info+="办理业务:"+isyear+"|";
							opr_info+="操作流水:"+'<%=loginAccept%>'+"|";
							opr_info+="操作时间:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="彩铃资费:"+document.all.mebProdCode.value+"|";
							opr_info+="业务生效时间:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="操作备注:"+document.all.opNote.value+"|";
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
							cust_info+="手机号码："+document.all.phone_no.value+"|";
							cust_info+="客户姓名："+'<%=sOutCustName%>'+"|";
							cust_info+="证件号码："+document.all.sOutIdIccid.value+"|";
							cust_info+="客户地址："+document.all.sOutCustAddress.value+"|";

							opr_info+="业务品牌:"+document.all.sm_name.value+"|";
							opr_info+="办理业务:"+isyear+"|";
							opr_info+="操作流水:"+'<%=loginAccept%>'+"|";
							opr_info+="操作时间:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="彩铃资费:"+document.all.mebProdCode.value+"|";
							opr_info+="业务生效时间:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="操作备注:"+document.all.opNote.value+"|";
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
						istime="次月";
						isyear="彩铃包季申请";
					if(sInEndChgFlag=="N"){
							cust_info+="手机号码："+document.all.phone_no.value+"|";
							cust_info+="客户姓名："+'<%=sOutCustName%>'+"|";
							cust_info+="证件号码："+document.all.sOutIdIccid.value+"|";
							cust_info+="客户地址："+document.all.sOutCustAddress.value+"|";

							opr_info+="业务品牌:"+document.all.sm_name.value+"|";
							opr_info+="办理业务:"+isyear+"|";
							opr_info+="操作流水:"+'<%=loginAccept%>'+"|";
							opr_info+="操作时间:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="彩铃资费:"+document.all.mebProdCode.value+"|";
							opr_info+="业务生效时间:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="操作备注:"+document.all.opNote.value+"|";
							note_info1+="15元包季使用费为彩铃包季业务专款，只能用于彩铃包季业务使用，且每月从15元中划拨5元到您的手机帐户中支付当月的彩铃费用。"+"|";
							note_info1+="业务有效期为3个计费月，开通彩铃包季业务的次月为有效期的第1个计费月。"+"|";
							note_info1+="彩铃包季未到期前取消业务，剩余的费用不退、不转，且在业务取消的次月月底，剩余费用由移动公司收回。"+"|";
							note_info1+="彩铃包季业务到期后由系统自动取消此业务。"+"|";
							//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
						else
						{
							cust_info+="手机号码："+document.all.phone_no.value+"|";
							cust_info+="客户姓名："+'<%=sOutCustName%>'+"|";
							cust_info+="证件号码："+document.all.sOutIdIccid.value+"|";
							cust_info+="客户地址："+document.all.sOutCustAddress.value+"|";

							opr_info+="业务品牌:"+document.all.sm_name.value+"|";
							opr_info+="办理业务:"+isyear+"|";
							opr_info+="操作流水:"+'<%=loginAccept%>'+"|";
							opr_info+="操作时间:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="彩铃资费:"+document.all.mebProdCode.value+"|";
							opr_info+="业务生效时间:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="操作备注:"+document.all.opNote.value+"|";
							note_info1+="15元包季使用费为彩铃包季业务专款，只能用于彩铃包季业务使用，且每月从15元中划拨5元到您的手机帐户中支付当月的彩铃费用。"+"|";
							note_info1+="业务有效期为3个计费月，开通彩铃包季业务的次月为有效期的第1个计费月。"+"|";
							note_info1+="彩铃包季未到期前取消业务，剩余的费用不退、不转，且在业务取消的次月月底，剩余费用由移动公司收回。"+"|";
							note_info1+="彩铃包季资费到期后自动转为彩铃包月业务，资费标准为6元/月。"+"|";
							//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
							retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
							retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
							return retInfo;
						}
					}
					if(isyear==6) {
						istime="次月";
						isyear="彩铃包两年申请";
						cust_info+="手机号码："+document.all.phone_no.value+"|";
						cust_info+="客户姓名："+'<%=sOutCustName%>'+"|";
						cust_info+="证件号码："+document.all.sOutIdIccid.value+"|";
						cust_info+="客户地址："+document.all.sOutCustAddress.value+"|";

						opr_info+="业务品牌:"+document.all.sm_name.value+"|";
						opr_info+="办理业务:"+isyear+"|";
						opr_info+="操作流水:"+'<%=loginAccept%>'+"|";
						opr_info+="操作时间:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
						opr_info+="彩铃资费:"+document.all.mebProdCode.value+"|";
						opr_info+="业务生效时间:"+istime+"|";
						opr_info+=""+"|";
						opr_info+=""+"|";
						opr_info+=""+"|";
						opr_info+=""+"|";

						note_info1+="操作备注:"+document.all.opNote.value+"|";
						note_info1+="100元包两年使用费为彩铃包两年业务专款，只能用于彩铃包两年业务使用，且每月从100元中划拨4.16元到您的手机帐户中支付当月的彩铃费用。"+"|";
						note_info1+="业务有效期为24个计费月，开通彩铃包两年业务的次月为有效期的第1个计费月。"+"|";
						note_info1+="彩铃包两年未到期前取消业务，剩余的费用不退、不转，且在业务取消的次月月底，剩余费用由移动公司收回。"+"|";
						note_info1+="彩铃包两年业务到期后由系统自动取消此业务。"+"|";
						//retInfo = cust_info+"#"+opr_info+"#"+note_info1+"#"+note_info2+"#"+note_info3+"#"+note_info4+"#";
						retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
						retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
						return retInfo;
					}
					if(isyear==7) {
						istime="次月";
						isyear="全球通尊享包0元彩铃";
						if(sInEndChgFlag=="N"){
							cust_info+="手机号码："+document.all.phone_no.value+"|";
							cust_info+="客户姓名："+'<%=sOutCustName%>'+"|";
							cust_info+="证件号码："+document.all.sOutIdIccid.value+"|";
							cust_info+="客户地址："+document.all.sOutCustAddress.value+"|";

							opr_info+="业务品牌:"+document.all.sm_name.value+"|";
							opr_info+="办理业务:"+isyear+"|";
							opr_info+="操作流水:"+'<%=loginAccept%>'+"|";
							opr_info+="操作时间:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="彩铃资费:"+document.all.mebProdCode.value+"|";
							opr_info+="业务生效时间:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="操作备注:"+document.all.opNote.value+"|";
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
							cust_info+="手机号码："+document.all.phone_no.value+"|";
							cust_info+="客户姓名："+'<%=sOutCustName%>'+"|";
							cust_info+="证件号码："+document.all.sOutIdIccid.value+"|";
							cust_info+="客户地址："+document.all.sOutCustAddress.value+"|";

							opr_info+="业务品牌:"+document.all.sm_name.value+"|";
							opr_info+="办理业务:"+isyear+"|";
							opr_info+="操作流水:"+'<%=loginAccept%>'+"|";
							opr_info+="操作时间:"+'<%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new java.util.Date())%>'+"|";
							opr_info+="彩铃资费:"+document.all.mebProdCode.value+"|";
							opr_info+="业务生效时间:"+istime+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";
							opr_info+=""+"|";

							note_info1+="操作备注:"+document.all.opNote.value+"|";
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
			<div id="title_zi">个人彩铃申请</div>
		</div>

    <table cellspacing="0">
    <input type="hidden" name="opCode" value="6710">
    <input type="hidden" name="loginAccept" value="<%=loginAccept%>">
    <input type="hidden" name="loginNo" value="<%=workno%>">
    <input type="hidden" name="loginPwd" value="<%=nopass%>">
    <input type="hidden" name="orgCode" value="<%=org_code%>">
    <input type="hidden" name="ip_Addr" value="<%=ip_Addr%>">
		     <TR>
		  	     <td  width="15%"  class="blue">手机号码</td>
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
					<input class="b_foot" name=sure22 type=button value="确定" onClick="doQuery();" style="cursor:hand" <%if(nextFlag==2){out.print("disabled");}%>>
            		<input class="b_foot" name=reset22 type=reset value="清除">
            		<input class="b_foot" name=close22 type=button value="关闭" onclick="removeCurrentTab()">
					</div>
				</td>
			</tr>
<%
	}
%>
            <%
             if(nextFlag==2)//查询后结果
             {
            %>
                <tr style="display:none">
                  <td>客户ID</td>
                  <td>
                    <input type="text" name="cust_id" maxlength="6"  class="button" value="<%=sOutCustId%>">
                    <font class="orange">*</font>
                  </td>
                </tr>
                <tr>
                  <td width="15%"  class="blue">客户名称</td>
                  <td width="35%">
                    <input type="text" name="cust_name" value="<%=sOutCustName%>" <%if(nextFlag==2){out.print("readonly Class=\"InputGrey\"");}%> >
                    <input type="hidden" readonly Class="InputGrey"  name="sOutCustAddress"  value="<%=sOutCustAddress%>">
                    <input type="hidden" readonly Class="InputGrey"  name="sOutIdIccid"   value="<%=sOutIdIccid%>">
                    <font class="orange">*</font>
                  </td>
                  <td width="15%"  class="blue">可用预存</td>
                  <td width="35%">
                    <input type="text" readonly Class="InputGrey"  name="PrePay" value="<%=sOutPrePay%>" <%if(nextFlag==2){out.print("readonly");}%>>
                    <font class="orange">*</font>
                  </td>
                </tr>
                <tr>
                  <td   class="blue">业务品牌</td>
                  <td>
                    <input type="hidden" readonly Class="InputGrey"  name="sm_code"  value="<%=sOutSmCode%>">
                    <input type="text"   readonly Class="InputGrey"    name="sm_name"  value="<%=sOutSmName%>" <%if(nextFlag==2){out.print("readonly");}%>>
                    <font class="orange">*</font>
                  </td>
                  <td  class="blue">运行状态</td>
                  <td>
                    <input type="hidden" readonly Class="InputGrey"   name="RunCode" value="<%=sOutRunCode%>">
                    <input type="text"   readonly Class="InputGrey"   name="RunName"  value="<%=sOutRunName%>" <%if(nextFlag==2){out.print("readonly");}%>>
                    <font class="orange">*</font>
                  </td>
                </tr>
                <tr>
                  <td  class="blue">资费套餐</td>
                  <td>
                    <input type="hidden" readonly  Class="InputGrey"   name="ProductCode" maxlength="5" value="<%=sOutProductCode%>">
                    <input type="text"   readonly  Class="InputGrey"   name="ProductName" maxlength="5" value="<%=sOutProductName%>" <%if(nextFlag==2){out.print("readonly");}%>>
                    <font class="orange">*</font>
                  </td>
                  <TD>&nbsp;</TD>
                  <TD>&nbsp;</TD>
                  <td  style="display:none"  class="blue">已订购彩铃产品</td>
                  <td   style="display:none">
                    <input type="hidden" readonly  Class="InputGrey"   name="UsingCRProdCode"  maxlength="20" value="<%=sOutUsingCRProdCode%>">
                    <input type="text" readonly   Class="InputGrey"   name="UsingCRProdName" maxlength="20" value="<%=sOutUsingCRProdName%>" <%if(nextFlag==2){out.print("readonly");}%>>

                  </td>
                </tr>
            <TR>
            <TD   class="blue">
							<div align="left">业务类型</div>
								</TD>
					       <TD >
									<SELECT name="mebMonthFlag" class="button" id="mebMonthFlag" onChange="tochange()" onclick="changeOthers()">
										<option value="1" selected>包月类</option>
										<option value="2" >包年类</option>
										<option value="3" >包半年类</option>
										<option value="5" >包季类</option>
										<option value="6" >包两年类</option>
										<option value="4" >动感地带0元套餐</option>
										<option value="7" >全球通尊享包0元彩铃</option>
									</SELECT>
									<font class="orange">*</font>
								</TD>
              <TD class="blue">彩铃产品</TD>
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
									          System.out.println("调用服务sPubSelect in f6710_1.jsp 成功@@@@@@@@@@@@@@@@@@@@@@@@@@");
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
									 		     	System.out.println("调用服务sPubSelect in f6710_1.jsp 失败@@@@@@@@@@@@@@@@@@@@@@@@@@");

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
						包年到期转包月
						  </TD>
						   <TD nowrap colspan="3">
									<SELECT name="matureFlag" class="button" id="matureFlag" onChange="changeMatureFlag()" >
										<option value="Y" >是</option>
										<option value="N" selected>否 </option>
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
									          System.out.println("调用服务sPubSelect in f6710_1.jsp 成功@@@@@@@@@@@@@@@@@@@@@@@@@@");
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
									 		     	System.out.println("调用服务sPubSelect in f6710_1.jsp 失败@@@@@@@@@@@@@@@@@@@@@@@@@@");

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
           		<input type="checkbox" name="has_show" onclick="changeHasShow()">&nbsp;<b>是否开通彩铃秀</b>
           	</TD>
           </TR>
	   </div>
          </table>
              <table cellspacing="0">
                <tbody>
                <tr>
                  <td width=15%  class="blue">系统备注</td>
                  <td width="85%">
                    <input readonly  Class="InputGrey" name=sysNote value="" size=60 maxlength="60">
                  </td>
                </tr>
                <tr style="display:none">
                  <td   class="blue">用户备注</td>
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
                    <input class="b_foot" name=sure type="button" value=确认 onclick="refain()">
                    &nbsp;
                    <input class="b_foot" name=clear type=reset value=上一步 onClick="location = 'f6710_1.jsp?phone_no=<%=phone%>';">
                    &nbsp;
                    <input class="b_foot" name=reset type=button value=关闭 onClick="removeCurrentTab()">
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
