<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="com.sitech.crmpd.core.wtc.*"%>
<%@ page import="com.sitech.boss.pub.util.CreatePlanerArray"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UType"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UtypeUtil"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UElement"%>
<%
String currentTime =  new java.text.SimpleDateFormat("yyyyMM").format(new java.util.Date());//��ǰ����
int currentTime2 =  Integer.parseInt(new java.text.SimpleDateFormat("MM").format(new java.util.Date()))-1;
String currentTime3 =  currentTime2<10?"0"+currentTime2:""+currentTime2;
String currentTime1 =  new java.text.SimpleDateFormat("yyyy").format(new java.util.Date())+currentTime3;//��ǰ���ڵ���һ����
String opCode = request.getParameter("opCode");
String opName = request.getParameter("opName");
String saleSeq = request.getParameter("saleSeq")==null?"0":request.getParameter("saleSeq");
System.out.println(opCode+"--------mylog-------saleSeq---"+saleSeq);
String regionCode = (String)session.getAttribute("regCode");
String broadPhone  = WtcUtil.repNull(request.getParameter("broadPhone"));
String forwardFlag  = WtcUtil.repNull(request.getParameter("forwardFlag"));
String phoneNoJv = activePhone;
String querySql1 = "SELECT count(*) FROM dservordermsg where service_no ='"+phoneNoJv+"' and finish_flag <> 'Y' ";

/** tianyang add for pos start **/
String workNo = (String)session.getAttribute("workNo");
String orgCode = (String)session.getAttribute("orgCode");
String groupId = (String)session.getAttribute("groupId");
/** tianyang add for pos end **/
%>
 	 <wtc:pubselect name="sPubSelect" outnum="1" retmsg="msg" retcode="code" routerKey="region" routerValue="<%=regionCode%>">
  	 <wtc:sql><%=querySql1%></wtc:sql>
 	  </wtc:pubselect>
	 <wtc:array id="result_t1" scope="end"/>	

<%
	String retSultSum1 = "0";
	if(result_t1.length>0&&result_t1[0][0]!=null){
		retSultSum1 = result_t1[0][0];
	}
	
if(!retSultSum1.equals("0")){
	if("1".equals(forwardFlag)){//��ҳ�������ģ���ʾ��ͬ
%>
<SCRIPT type=text/javascript>
	//rdShowMessageDialog("�����ɹ���δ�������������Զ�������",1);
	removeCurrentTab();
</SCRIPT>
<%	
	}else{
%>
<SCRIPT type=text/javascript>
	rdShowMessageDialog("���û�����δ�����Ķ������봦�����ٳ���",1);
	removeCurrentTab();
</SCRIPT>
<%		
	}
}
%>

<wtc:sequence name="sPubSelect" key="sMaxSysAccept" routerKey="region" routerValue="<%=regionCode%>"  id="printAccept" />
<HEAD><TITLE>����������ѯ</TITLE>
</HEAD>
<SCRIPT type=text/javascript>

	var _KMap=function(){
	this.init.apply(this,arguments);
	}
	_KMap.prototype={
		init:function(){
			this.map={};
		},
		add:function(key,value){
			if(this.map[key]==null){
				this.map[key]=new Array();
			}
			this.map[key].push(value);
		}

	}
	var printinfo = "";
	var idInfo = new Array();

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
	else if (document.layers && document.layers[objectId])
	{
		return document.layers[objectId];
	}
	else
	{
		return false;
	}
}

	function doSearch(){
		
		var idType = g("idType").value.trim(); //��ѯ����
		
		var servno = document.all.servno.value.trim(); //����ֵ
		if(servno == ""){
		    rdShowMessageDialog("����ֵ����Ϊ�գ�",0);
		    document.all.servno.focus();
		    return false;
		}
		
		var searchDate = document.all.searchDate.value; //��ѯ����
		//$("#searchResult").toggle();
		var packet = new AJAXPacket("searchData.jsp","���Ժ�...");
		packet.data.add("idType",idType);
		packet.data.add("servno",servno);
		packet.data.add("opCodeLimit","<%=opCode%>");
		packet.data.add("saleSeq","<%=saleSeq%>");
		packet.data.add("selFlag",document.all.idType.value);
		packet.data.add("modeFlag",document.all.modeFlag.value);
		
		if(idType == '0' || idType == '4'){
				packet.data.add("searchDate",searchDate);
		}
		core.ajax.sendPacketHtml(packet,doSearchData);
		packet = null;
	}

	function doSearchData(data){
		
		$("#searchResult").html(data);
	}

	function callDetail(){
		window.showModalDialog("callDetail.jsp","","dialogWidth:50;dialogHeight:45;");
	}

	//�����ѡ�򴥷��¼�����ѯ��������ID�İ󶨹�ϵ
	function sBindQuery(obj,lineFlag){
		document.all.lineFlagi.value = lineFlag;
		var orderArrayID = obj.value;
		if(obj.checked == false){
			obj.checked = false;
			var packet = new AJAXPacket("sBindQuery.jsp");
				  packet.data.add("orderArrayID" ,orderArrayID);
				  packet.data.add("retType" ,"sBindQuery1");
				  core.ajax.sendPacket(packet);
				  packet =null;
		}else{
			var packet = new AJAXPacket("sBindQuery.jsp");
				  packet.data.add("orderArrayID" ,orderArrayID);
				  packet.data.add("retType" ,"sBindQuery");
				  core.ajax.sendPacket(packet);
				  packet =null;
		}
	}
 
function doProcess(packet){
	var retType=packet.data.findValueByName("retType");
	var retCode=packet.data.findValueByName("retCode");
	var retMsg=packet.data.findValueByName("retMsg");
	var orderArrayIDs=packet.data.findValueByName("orderArrayIDs");
	var selObj = document.getElementsByName("custOrderIds");	
	/*tianyang add for pos�ɷ� start*/
	var verifyType = packet.data.findValueByName("verifyType");
	var sysDate = packet.data.findValueByName("sysDate");
	/*tianyang add for pos�ɷ� end*/
	if(retType == "sBindQuery"){
		if(retCode == "0"){
			for(var i=0;i<orderArrayIDs.length;i++){
				for(var j=0;j<selObj.length;j++){
					if(orderArrayIDs[i] == selObj[j].value){//���������id�Ͷ�ѡ���е�idֵһ��
						//if(selObj[j].checked == false){
							selObj[j].checked = true;
						//}else{
							//selObj[j].checked = false;
						//}
					}
				}
			}
		}
	}

	if(retType == "sBindQuery1"){
		if(retCode == "0"){
			for(var i=0;i<orderArrayIDs.length;i++){
				for(var j=0;j<selObj.length;j++){
					if(orderArrayIDs[i] == selObj[j].value){//���������id�Ͷ�ѡ���е�idֵһ��
						selObj[j].checked = false;
					}
				}
			}
		}
	}
	if(retType == "StartBackTest"){
		
			if(parseInt(retCode) != '0'){
				rdShowMessageDialog("["+retCode+":] "+retMsg);
			}else{
				/*** tianyang add for pos start *** boss���׳ɹ� ��������ȷ�Ϻ��� *****/
				if(document.all.payType.value=="BX"){
					try{
						BankCtrl.TranOK();
					}catch(e){
						alert("���ý��пؼ�����");
					}
				}
				if(document.all.payType.value=="BY"||document.all.payType.value=="EI"){
					try{
						var IfSuccess = KeeperClient.UpdateICBCControlNum();//�����ɹ��������пؼ�ȷ��
					}catch(e){
						alert("���ù��пؼ�����");
					}
				}
				/*** tianyang add for pos end *** boss���׳ɹ� ��������ȷ�Ϻ��� *****/
				rdShowMessageDialog("���������ɹ���",2);
				location = location+"&forwardFlag=1"; //�����ɹ���ˢ��ҳ��ȡ������ˮ
			}
	}
	if(retType == "queryPrt"){
 		document.all.retResult.value=packet.data.findValueByName("retResultStr");
 		document.all.retNowOfferId.value=packet.data.findValueByName("retNowOfferId");
 		document.all.retRevsOfferId.value=packet.data.findValueByName("retRevsOfferId");
 		document.all.retPPV1.value=packet.data.findValueByName("retPPV1");
 		$("#broadReturnStr").val(packet.data.findValueByName("broadReturnStr"));
	}	
	/*tianyang add for pos�ɷ� start*/
	if(verifyType=="getSysDate"){
		document.all.Request_time.value = sysDate;
		return false;
	}
	/*tianyang add for pos�ɷ� end*/
}

function currentSel(selObj){

	var n = 0;
	for(var j=0;j<selObj.length;j++){
		if(selObj[j].checked == true){
			n++;
		}
	}
	return n;
}
function showPrtDlg(printType,DlgMessage,submitCfm,printInfoStr)
  {  //��ʾ��ӡ�Ի���
		var h=210;
		var w=400;
		var t=screen.availHeight/2-h/2;
		var l=screen.availWidth/2-w/2;

		var pType="subprint";                                      // ��ӡ���ͣ�print ��ӡ subprint �ϲ���ӡ
		var billType="1";                                          //  Ʊ�����ͣ�1���������2��Ʊ��3�վ�
		var sysAccept="<%=printAccept%>";                            // ��ˮ��
		//var printStr=printInfo(printType,printInfoStr);          //����printinfo()���صĴ�ӡ����
		var printStr = "";
		if("<%=opCode%>" != "e093" && "<%=opCode%>" != "e094"){
			printStr=printInfo(printType,printInfoStr);
		}else{
			printStr=printInfoe093(printType,printInfoStr);
		}
		var mode_code=null;                                        //�ʷѴ���
		var fav_code=null;                                         //�ط�����
		var area_code=null;                                        //С������
		var opCode2Hv     = document.getElementById("opCode2Hv"+document.all.lineFlagi.value).value;
		var opCode=opCode2Hv;
		var hiddenStrv    = document.getElementById("hiddenStrv"+document.all.lineFlagi.value).value;
		var hiddenStrvArr = hiddenStrv.split("|");
		var phoneNo=hiddenStrvArr[4];                 //�ͻ��绰
		var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
		var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_hw.jsp?DlgMsg=" + DlgMessage+ "&submitCfm=" + submitCfm;
		path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode="+opCode+"&sysAccept="+sysAccept+"&phoneNo="+phoneNo+"&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr;
		var ret=window.showModalDialog(path,printStr,prop);
		return ret;
  }


  function printInfo(printType,printInfoStr)
  {
  	
  	
		var exeDate = "<%=new java.text.SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(new java.util.Date())%>";//�õ�ִ��ʱ��

		var cust_info=""; //�ͻ���Ϣ
		var opr_info=""; //������Ϣ
		var note_info1=""; //��ע1
		var note_info2=""; //��ע2
		var note_info3=""; //��ע3
		var note_info4=""; //��ע4
		var retInfo = "";  //��ӡ����

		var hiddenStrv    = document.getElementById("hiddenStrv"+document.all.lineFlagi.value).value;
		var hiddenStrvArr = hiddenStrv.split("|");

		var opCode1Hv     = document.getElementById("opCode1Hv"+document.all.lineFlagi.value).value;
		var opName1Hv     = document.getElementById("opName1Hv"+document.all.lineFlagi.value).value;
		var opCode2Hv     = document.getElementById("opCode2Hv"+document.all.lineFlagi.value).value;
		var opName2Hv     = document.getElementById("opName2Hv"+document.all.lineFlagi.value).value;
		var loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;

		var custAddJv = document.getElementById("custAdd"+document.all.lineFlagi.value).value;

		<%
		String currTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new Date());
		%>

		ajaxQueryPrt(hiddenStrvArr[4],hiddenStrvArr[2],opCode1Hv,opCode2Hv,loginAcceptHv);

		cust_info+="�ͻ�������	"+hiddenStrvArr[6]+"|";
    cust_info+="�ֻ����룺	"+hiddenStrvArr[4]+"|";
    cust_info+="֤�����룺	"+hiddenStrvArr[7]+"|";
    cust_info+="�ͻ���ַ��	"+custAddJv+ "|";

    if(opCode2Hv!="3264"){
    	opr_info+="ҵ������ʱ�䣺<%=currTime%>"+"|";
    }

		opr_info+="�û�Ʒ�ƣ�"+document.all.retPPV1.value+"  ����ҵ��"+opName2Hv+ "|";
		opr_info+="������ˮ��<%=printAccept%>"+ "|";

		if(opCode2Hv=="1257"){
			opr_info+="ִ�����ڣ�<%=currTime.substring(0,10)%>"+ "|";
		}

		if(opCode2Hv=="3264")
		{
			opr_info+=document.all.retResult.value;
			opr_info+="ҵ����Чʱ�䣺����"+"|";
			note_info1+="˵���������ʷѽ�������Ч";
		}
		else
		{
			note_info1+="��ע��";
			if(opCode2Hv=="1257")
			{
				note_info1+="����"+hiddenStrvArr[4]+"��";
				note_info1+=printInfoStr;
			}
			else if(opCode2Hv=="127a")
			{
				opr_info+=(printInfoStr+ "|");
				note_info1+="|"
			}

			if(opCode2Hv!="127a")
			{
			 	 if(opCode2Hv=="127b")
			 	 {
					opr_info+=document.all.retResult.value;
					opr_info+=("������������:     "+""+"|");
					opr_info+=("�ײ�˵��:         "+""+"|");
					note_info1+=(document.all.retNowOfferId.value+"24Сʱ����Ч"+document.all.retRevsOfferId.value+"|");
			 	 }
			 	 else
			 	 {
			 	 	if("<%=opCode%>"!="g795"){
			 	 		note_info1+=document.all.retResult.value;
			 		}
				 }
			}
		}

		retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
		retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
		return retInfo;
  }
  
/*2014/04/04 11:02:20 gaopeng ���ù�����ѯ����Ʒ��sm_code*/
function getPubSmCode(kdNo){
		var getdataPacket = new AJAXPacket("/npage/public/pubGetSmCode.jsp","���ڻ�����ݣ����Ժ�......");
		getdataPacket.data.add("phoneNo","");
		getdataPacket.data.add("kdNo",kdNo);
		core.ajax.sendPacket(getdataPacket,doPubSmCodeBack);
		getdataPacket = null;
}
function doPubSmCodeBack(packet){
	retCode = packet.data.findValueByName("retcode");
	retMsg = packet.data.findValueByName("retmsg");
	smCode = packet.data.findValueByName("smCode");
	if(retCode == "000000"){
		$("#pubSmCode").val(smCode);
	}
}
function printInfoe093(printType,printInfoStr){
	getPubSmCode("<%=broadPhone%>");
	var pubSmCode = $("#pubSmCode").val();
	
	var retInfo = "";
	var cust_info="";
	var opr_info="";
	var note_info1="";
	var note_info2="";
	var note_info3="";
	var note_info4="";  
	var opCode1Hv     = document.getElementById("opCode1Hv"+document.all.lineFlagi.value).value;
	var opName1Hv     = document.getElementById("opName1Hv"+document.all.lineFlagi.value).value;
	var opCode2Hv     = document.getElementById("opCode2Hv"+document.all.lineFlagi.value).value;
	var opName2Hv     = document.getElementById("opName2Hv"+document.all.lineFlagi.value).value;
	var loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;
	var hiddenStrv    = document.getElementById("hiddenStrv"+document.all.lineFlagi.value).value;
	var hiddenStrvArr = hiddenStrv.split("|");
	ajaxQueryPrt(hiddenStrvArr[4],hiddenStrvArr[2],opCode1Hv,opCode2Hv,loginAcceptHv);
	cust_info += "�����ʺţ�" + "<%=broadPhone%>" + "|";
	cust_info += "�ͻ�������" + hiddenStrvArr[6] + "|";
	if("<%=opCode%>" == "e093"){
		opr_info += "ҵ��������ƣ����ʷѳ���" ;
	}else if("<%=opCode%>" == "e094"){
		opr_info += "ҵ��������ƣ����ʷ�ԤԼȡ��" ;
	}
	opr_info += "     ������ˮ:" + "<%=printAccept%>" + "|";
	opr_info += $("#broadReturnStr").val();
	if("<%=opCode%>" == "e093"){
		opr_info += "   ԭ�ʷѻָ�ʱ�䣺24Сʱ����Ч" + "|";
	}
	
  if("<%=opCode%>" == "e094"){
  	/* 
     * ����Э������ʡ��������������Ӫ�������ں��ײ�����ĺ�����Ʒ���֣�@2014/7/24 
     * ����ʡ���kg������Ʒ��kh
     */
  	if(pubSmCode == "kf" || pubSmCode == "kg" || pubSmCode == "kh" || pubSmCode == "ki"){
  		
  		note_info1 += "��ע��" + "|" ;
  		note_info1 += "1���û��������ʷ�ԤԼȡ����ԤԼ�����ʷѽ�������Ч����ǰ���ʷѼ���ִ�С�  " + "|" ;
  		note_info1 += "2������ϵ�绰�䶯ʱ���뼰ʱ���ƶ���˾��ϵ���Ա������»�������ʱ��ʱ�յ�֪ͨ��" + "|" ;
  		note_info1 += "3������������벦��������ߣ�10086��" + "|" ;
  	}else{
			note_info1 += "��ע���û��������ʷ�ԤԼȡ����ԤԼ�����ʷѽ�������Ч����ǰ���ʷѼ���ִ�С�" + "|" ;
		}
	}
	if("<%=opCode%>" == "e093"){
		/* 
     * ����Э������ʡ��������������Ӫ�������ں��ײ�����ĺ�����Ʒ���֣�@2014/7/24 
     * ����ʡ���kg������Ʒ��kh
     */
		if(pubSmCode == "kf" || pubSmCode == "kg" || pubSmCode == "kh" || pubSmCode == "ki"){
			
			note_info1 += "��ע��" + "|" ;
			note_info1 += "1������ϵ�绰�䶯ʱ���뼰ʱ���ƶ���˾��ϵ���Ա������»�������ʱ��ʱ�յ�֪ͨ��" + "|" ;
			note_info1 += "2������������벦��������ߣ�10086��" + "|" ;
		}
	}
  retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
	retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
	return retInfo;
}
  function ajaxQueryPrt(phoneNo,serOId,opCode1,opCode2,loginAccept){
  		var packet1 = new AJAXPacket("ajaxQueryPrt.jsp","���Ժ�...");
  			packet1.data.add("retType" ,"queryPrt");
				packet1.data.add("phoneNo",phoneNo);
				packet1.data.add("serOId",serOId);
				packet1.data.add("opCode1",opCode1);
				packet1.data.add("opCode2",opCode2);
				document.all.opcodeCfm.value  = opCode2;
				packet1.data.add("loginAccept",loginAccept);
				core.ajax.sendPacket(packet1);
				packet1 =null;
  	}

  //�ύ����
  function printCommit(subButton){
  	
  	getAfterPrompt();
	controlButt(subButton);//��ʱ���ư�ť�Ŀ�����
	//У��
	setOpNote();//Ϊ��ע��ֵ
    //�ύ����
    frmCfm();
	return true;
  }

var retSultSum = "0";
var retSultCode = "";
var retSultMsg  = "";

	function getAfterPrompt1()
	{
		var opCode2Hv     = document.getElementById("opCode2Hv"+document.all.lineFlagi.value).value;
		var packet = new AJAXPacket("/npage/include/getAfterPrompt.jsp","���Ժ�...");
		packet.data.add("opCode" ,opCode2Hv);
	  core.ajax.sendPacket(packet,doGetAfterPrompt,false);//ͬ��
		packet =null;
	}

	function doGetAfterPrompt(packet)
	{
    var retCode = packet.data.findValueByName("retCode");
    var retMsg = packet.data.findValueByName("retMsg");
    if(retCode=="000000"){
    	promtFrame(retMsg);
    }
	}

function qryContent(){
	
	  //showPrtDlgbill("Bill","ȷʵҪ���з�Ʊ��ӡ��","Yes");//����д��
	
	  if(document.all.lineFlagi.value==""){
	  	rdShowMessageDialog("��ѡ��Ҫ�����Ķ���");
	  	   return false;
	  	  
	  }

	
	   var opcode1=document.getElementById("opCode2Hv"+document.all.lineFlagi.value).value;
	   var opcode1sss=document.getElementById("opCode1Hv"+document.all.lineFlagi.value).value;
	   var loginAccept1sss=document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;
	   //alert(opcode1sss+"--"+loginAccept1sss);

	   if(opcode1sss=="g794") {
	   				var packet1s = new AJAXPacket("checkOldAndNew.jsp");
						packet1s.data.add("loginAccept" ,loginAccept1sss);
						core.ajax.sendPacket(packet1s,setBusInfo);
						packet1s=null;
	   }
	  
	   
	   var phoneNo=$("#searchResult tr:eq(1)").find("td:eq(5)").html();
     
	  if(opcode1=="127a"||opcode1=="1257"){
 
		var packet = new AJAXPacket("qryContent.jsp");
		packet.data.add("opCode" ,opcode1);
		packet.data.add("phoneNo" ,phoneNo);
		core.ajax.sendPacket(packet,doSubmit);
		packet=null;
	}else{
				  doSubmit();
		}

}

function setBusInfo(packet)
{
	var	retCode	=packet.data.findValueByName("retCode"); 	
	var	retMsg	=packet.data.findValueByName("retMsg"); 	

	if (!( retCode=="000000" ) )
	{
      rdShowMessageDialog("��ѯ�Ծɻ��½��ʧ�ܣ�������룺"+retCode+",������Ϣ��"+retMsg);

	}
	else
	{
	var	SUMFEEsd	=packet.data.findValueByName("SUMFEE"); 
	var	EXCHFEEsd	=packet.data.findValueByName("EXCHFEE"); 
	 if(EXCHFEEsd!="0") {
		 rdShowMessageDialog("���û�ʵ��"+"<font color='red' weight=bold size=5px  >"+SUMFEEsd+"</font>Ԫ��������<font color='red' weight=bold size=5px  >"+EXCHFEEsd+"</font>Ԫ�Ծɻ���ƾ֤������ʵ��<font color='red' weight=bold size=5px  >"+SUMFEEsd+"</font>Ԫ������<font color='red' weight=bold size=5px  >"+EXCHFEEsd+"</font>Ԫ�Ծɻ���ƾ֤");
		 }
	}
}

function doSubmit(packet){
	var printInfoStr="";
	var opcode2=document.getElementById("opCode2Hv"+document.all.lineFlagi.value).value;
	if(opcode2=="127a"||opcode2=="1257"){
			printInfoStr=packet.data.findValueByName("printInfo");
	}
	
	//Ӫ��������ʾ��hejwa add 2014��1��22��15:20:58 ���ڿ��������Լ�ƻ�������ҵ��Ȩ�湦�ܵĺ�
	var saleHitFlag = document.getElementById("saleHitFlag"+document.all.lineFlagi.value).value;
		if("1"==saleHitFlag){
			
			rdShowMessageDialog("���֪�ͻ���������Ӫ�������������ҵ����Ϊ������Ч�����·��������룬��ΪԤԼ��Ч���򲻲������ã������û���ʵ���˵�Ϊ׼��");
		}
	getMbhYjMsg();
		
	getAfterPrompt1();
	var selObj = document.getElementsByName("custOrderIds");
	var checkNo = currentSel(selObj);
	if(checkNo == 0){
		rdShowMessageDialog("��ѡ�񶩵�������Ϣ!",0);
		return;
	}
	var map=new _KMap();
	var tab=g("dataTable");
	for(var i=0;(i+1)<tab.rows.length;i++){
		var key=tab.rows[i+1].cells[1].innerText;
		var value=tab.rows[i+1].cells[3].innerText;
		if(selObj[i].checked == true){
			map.add(key,value);
		}
	}
	var result="";
	for(var e in map.map){
		var result2="";//���񶩵���e�ǿͻ�����
		for(var i=0;i<map.map[e].length;i++){
			result2+=map.map[e][i]+"~";
		}
		result2=result2.substring(0,result2.length-1);//ȥ��~
		result+=e+"@"+result2+"|";
	}

ajaxCheckf();
 if(retSultSum=="0"){
	rdShowMessageDialog(retSultCode+":"+retSultMsg);
	return false;
 }
 if(retSultCode!="0"){
	rdShowMessageDialog(retSultCode+":"+retSultMsg);
	return false;
	}
	   var ret = showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes",printInfoStr);
	   
    if(typeof(ret)!="undefined")
    {
      if((ret=="confirm"))
      {
	      frmCfm(result);
	  }
	  if(ret=="continueSub")
	  {
	      frmCfm(result);
	  }
    }
    else
    {
	     frmCfm(result);
    }
}
function ajaxCheckf(){

	  var hiddenStrv    = document.getElementById("hiddenStrv"+document.all.lineFlagi.value).value;
		var hiddenStrvArr = hiddenStrv.split("|");
		var phoneNo=hiddenStrvArr[4];
		var loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;



		var packet = new AJAXPacket("ajaxCheckP.jsp");
		packet.data.add("opCode" ,document.getElementById("opCode2Hv"+document.all.lineFlagi.value).value);
		packet.data.add("phoneNo" ,phoneNo);
		packet.data.add("servId" ,document.getElementById("servId_"+document.all.lineFlagi.value).value);
		packet.data.add("loginAcceptHv" ,loginAcceptHv);
		core.ajax.sendPacket(packet,doAjaxCheckf);
	}

function doAjaxCheckf(packet){
		retSultSum=packet.data.findValueByName("retSultSum");
		retSultCode=packet.data.findValueByName("retCode");
		retSultMsg =packet.data.findValueByName("retMsg");
	}

function getMbhYjMsg(){
		var phoneNo = "<%=phoneNoJv%>";
		var opAccept = "<%=saleSeq%>";
		
		var getdataPacket = new AJAXPacket("/npage/public/getMbhYjMsg.jsp","���ڻ�����ݣ����Ժ�......");
		getdataPacket.data.add("phoneNo",phoneNo);
		getdataPacket.data.add("opAccept",opAccept);
		core.ajax.sendPacket(getdataPacket,doMbhYjMsgBack);
		getdataPacket = null;
}
function doMbhYjMsgBack(packet){
	retCode = packet.data.findValueByName("retCode");
	retMsg = packet.data.findValueByName("retMsg");
	deposit = packet.data.findValueByName("deposit");
	if(retCode == "000000"){
		
		if(Number(deposit) > 0){
			rdShowMessageDialog("�������û�����ħ�ٺ��ն��豸Ѻ�𷵻���Ѻ�𷵻�����Ϊ��g836-Ѻ�𷵻�ҵ��");
		}
	}
}

function frmCfm(result){	
		if (rdShowConfirmDialog("ȷ��Ҫ�ύ���β�����") == 1){
					/*** tianyang add for pos start***/
					document.all.payType.value = document.getElementById("payTypeHv"+document.all.lineFlagi.value).value.trim();/*�ɷ�����*/
					//alert("payType="+document.all.payType.value);
					if(document.all.payType.value=="BX")
					{
							var transerial    = "000000000000";  	                     //����Ψһ��
							var trantype      = "01";                                  //��������
							var bMoney        = document.getElementById("returnMoneyHv"+document.all.lineFlagi.value).value;/*���*/
							if(bMoney.indexOf(".") == -1) bMoney=bMoney+"00";
							//alert(bMoney);
							var tranoper      = "<%=workNo%>";                         //���ײ���Ա
							var orgid         = "<%=groupId%>";                        //ӪҵԱ��������
							var trannum       = "<%=activePhone%>";                    //�绰����
							getSysDate();       							/*ȡbossϵͳʱ��*/
							var respstamp     = document.all.Request_time.value;       //�ύʱ��
							var transerialold = document.getElementById("RrnHv"+document.all.lineFlagi.value).value;/*�ο���*/
							var org_code      = "<%=orgCode%>";                        //ӪҵԱ����
							//alert("bMoney="+bMoney+" transerialold="+transerialold);
							CCBCommon(transerial,trantype,bMoney,tranoper,orgid,trannum,respstamp,transerialold,org_code);
							if(ccbTran=="succ") posSubmitForm(result);
					}
					else if(document.all.payType.value=="BY"||document.all.payType.value=="EI")
					{
							var transType     = "04";
							var bMoney        = document.getElementById("returnMoneyHv"+document.all.lineFlagi.value).value;/*���*/
							if(bMoney.indexOf(".") == -1) bMoney=bMoney+"00";
							//alert(bMoney);
							var response_time = document.getElementById("Response_timeHv"+document.all.lineFlagi.value).value;/*���в࿪��ʱ��*/
							response_time     = response_time.substr(0,8);
							var rrn           = document.getElementById("RrnHv"+document.all.lineFlagi.value).value;/*�ο���*/
							var instNum       = document.getElementById("instNumStrHv"+document.all.lineFlagi.value).value;/*���ڸ�������*/;//
							var terminalId    = document.getElementById("TerminalIdHv"+document.all.lineFlagi.value).value;/*�ն˺�*/
							getSysDate();       	 /*ȡbossϵͳʱ��*/
							var request_time  = document.all.Request_time.value;
							var workno        = "<%=workNo%>";
							var orgCode       = "<%=orgCode%>";
							var groupId       = "<%=groupId%>";
							var phoneNo       = "<%=activePhone%>";
							var toBeUpdate    = "";
							//alert("bMoney="+bMoney+" response_time="+response_time+" rrn="+rrn+" transerialold="+transerialold);
							//bMoney = "600.00";
							//alert("����������������лл\n\ntransType=["+transType+"]\n�������ֵ����ص�Ǯ�����˾����� bMoney=["+bMoney+"]\nresponse_time=["+response_time+"]\nrrn=["+rrn+"]\ninstNum=["+instNum+"]\nterminalId=["+terminalId+"]\nrequest_time=["+request_time+"]\nworkno=["+workno+"]\norgCode=["+orgCode+"]\ngroupId=["+groupId+"]\nphoneNo=["+phoneNo+"]\ntoBeUpdate=["+toBeUpdate+"]");
							
							ICBCCommon(transType,bMoney,response_time,rrn,instNum,terminalId,request_time,workno,orgCode,groupId,phoneNo,toBeUpdate);
							if(icbcTran=="succ") posSubmitForm(result);
					}
					/*** tianyang add for pos end***/
					else
					{
							posSubmitForm(result);
					}
		}
	}
function showValue(){
	document.frm1102.servno.value = ""; 	//add by wangxing@20090817,�������ֵ
	var showFlag = g("idType").value;
	if(showFlag == '0' || showFlag == '4'){
		$("#theValue").show();
	}else{
		$("#theValue").hide();
	}
}

function showBaseInfo(hiddenStrv,opCode1Hv,opCode2Hv,loginAcceptHv){

	var tempArray = hiddenStrv.split("|");
	var phoneNo = tempArray[4];
	var paramValue = "phoneNo="+phoneNo+"&serVId="+tempArray[2]+"&opCode1Hv="+opCode1Hv+"&opCode2Hv="+opCode2Hv+"&loginAcceptHv="+loginAcceptHv + "&opCode=<%=opCode%>";
	var pageName = "showBaseInfoj.jsp?"+paramValue;
	//var resultList = window.open(pageName, "", "dialogWidth=940px;dialogHeight=940px;center=yes;status=yes");
	window.open(pageName,"newwindow","height=450, width=830,top=50,left=100,scrollbars=yes, resizable=no,location=no, status=yes");
}

function showPrtDlgbill(printType,DlgMessage,submitCfm)
{
	ajaxGetBilPrt();
	var h=180;
	var w=350;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;
	var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no" 
	
	//var path = "/npage/public/pubBillPrintCfm_YGZ.jsp?dlgMsg=" + DlgMessage;


	  var j_param11215 = "";
	  var j_param11216 = ""; 
		$("#dataTable input[type='radio']:checked").each(function (){
			  j_param11215 = $(this).parent().parent().find("td:eq(11)").text().trim();
			  j_param11216 = $(this).parent().parent().find("td:eq(9)").text().trim();
			  if(j_param11216.length>6){
			  	j_param11216 = j_param11216.substring(0,6);
			  }
		});
		
		//��Ʊ��Ŀ�޸�Ϊ��·��
		$(billArgsObj).attr("11215",j_param11215); //��ҵ����ˮ
		$(billArgsObj).attr("11216",j_param11216); //ԭҵ������		yyyyMM						
		var path = "/npage/public/billPrtNew/Bill_ELE_Prt.jsp?dlgMsg=" + DlgMessage;
	
	var loginAccept = "<%=printAccept%>";
	var path = path + "&printInfo="+printinfo+"&submitCfm=submitCfm";
	var path = path + "&loginAccept="+loginAccept+"&opCode=<%=opCode%>&submitCfm=submitCfm";
	
	var ret = window.showModalDialog(path,billArgsObj,prop);
	

	
}
//hejwa add Ӫ��������ӡ��Ʊ 2013��7��2��14:00:16 ��ͳһ�ɷѵ�Ӫ����Ʊ���ƣ�������ͬ����
function to_showMarkBillPrt(){
		var custOrderId = "";
		$("#dataTable input[type='radio']:checked").each(function (){
					custOrderId = $(this).parent().parent().find("td:eq(6)").text().trim();
		});
		var getdataPacket = new AJAXPacket("/npage/sq046/ajaxGetSalebillData.jsp","���ڻ�����ݣ����Ժ�......");
				getdataPacket.data.add("custOrderId",custOrderId);
				getdataPacket.data.add("billFlag","1");
				getdataPacket.data.add("opflag","g795");
				getdataPacket.data.add("searchDate",document.all.searchDate.value);
				core.ajax.sendPacket(getdataPacket,doGetSalebillData);
				getdataPacket = null;
}

function doGetSalebillData(packet){
	retCode = packet.data.findValueByName("retCode");
	if(retCode == "000000"||retCode == "0"){
		var getbillArr    = packet.data.findValueByName("getbillArr");
		if(getbillArr.length>0){
				var printFlag = getbillArr[4];//��ӡ��ʶ��0�ϴ�1�ִ�3����
				var jttfflag = document.getElementById("jttfflag"+document.all.lineFlagi.value).value;
		    if("1"==jttfflag) {		    	
		    	showMarkBillPrt_JTTFGJ(getbillArr);//������
		    }else {
				
				if(printFlag=="1"){
					showMarkPrtDlgbill(getbillArr); //Ԥ��
					if(getbillArr[10]!=""){//���ն�
						showMarkPrtDlgbill1(getbillArr);//������
					}
				}else if(printFlag=="0"){
					showMarkPrtDlgbill_H(getbillArr); //Ԥ��
				}
				else if(printFlag=="4") {		
						if(getbillArr[27]=="1") {//����ʱ���ӡ�˹����Ʊ
							showMarkBillPrt_F6(getbillArr);
						  showMarkBillPrt_F7(getbillArr);
						}else {//����ʱ���ӡ�˺�Լ�ײͷѷ�Ʊ
							showMarkBillPrt_F4(getbillArr);
						}
			}else if(printFlag=="5") {
						showMarkBillPrt_F4(getbillArr);	
			}
			}
		}else{
			rdShowMessageDialog("û��ȡ����Ʊ��ӡ����",0);
		}	
	}else{
		rdShowMessageDialog("ȡӪ����Ʊ��Ϣ����");
	}
}
//��Ʊ�ִ�2
function showMarkBillPrt_F4(billArr){
//--------------��ʼƴװ��Ʊ---------------------------
		var custName       = billArr[2];
		var phoneNo        = billArr[3];
		var busiName       = billArr[1];
		var totalFeeC      = billArr[5];
		var totalFee       = billArr[5];
		var printInfo      = "";
		var feeName        = "������";
		var actionId = billArr[14];  
		var shuilv = billArr[15];
	    var shuier = billArr[16];
	    var jsje     =  billArr[17];   //��˰���
	    var  billArgsObj = new Object();
	    if(totalFee>0.01){
			$(billArgsObj).attr("10001","<%=workNo%>");     //����
			$(billArgsObj).attr("10002","<%=new java.text.SimpleDateFormat("yyyy",Locale.getDefault()).format(new java.util.Date())%>");
			$(billArgsObj).attr("10003","<%=new java.text.SimpleDateFormat("MM",Locale.getDefault()).format(new java.util.Date())%>");
			$(billArgsObj).attr("10004","<%=new java.text.SimpleDateFormat("dd",Locale.getDefault()).format(new java.util.Date())%>");
			$(billArgsObj).attr("10005",custName);   //�ͻ�����
			$(billArgsObj).attr("10006",busiName+"����");    //ҵ�����
			$(billArgsObj).attr("10008",phoneNo);    //�û�����
			$(billArgsObj).attr("10015", "-"+totalFee);   //���η�Ʊ���
			$(billArgsObj).attr("10016", "-"+totalFee);   //��д���ϼ�
			$(billArgsObj).attr("10025", "-"+totalFee);   //���ӷ�Ʊ��ϸ���ݲ���Ϊ�� model13 ֻȡ10025 �ֶ� �������ܶ����
			
			$(billArgsObj).attr("10017","*");        //���νɷѣ��ֽ�
		    $(billArgsObj).attr("10028",busiName);   //�����Ӫ������ƣ�
			$(billArgsObj).attr("10029",actionId);	 //Ӫ������	
			$(billArgsObj).attr("10030","<%=printAccept%>");   //��ˮ�ţ�--ҵ����ˮ
			$(billArgsObj).attr("10036","<%=opCode%>");   //��������
			$(billArgsObj).attr("10041", billArr[9]);           //Ʒ�����
			$(billArgsObj).attr("10042","̨");                   //��λ
			$(billArgsObj).attr("10043","1");	                   //����
			$(billArgsObj).attr("10044",billArr[6]);	                //����
			$(billArgsObj).attr("10045",billArr[11]);	       //IMEI
			$(billArgsObj).attr("10061",billArr[10]);	       //�ͺ�
			$(billArgsObj).attr("10038",billArr[23]);
			$(billArgsObj).attr("10039",billArr[24]);
			$(billArgsObj).attr("10040",billArr[25]);
			$(billArgsObj).attr("10037",billArr[26]);
			//$(billArgsObj).attr("10062",shuilv);	//˰��
			//$(billArgsObj).attr("10063",shuier);	//˰��	   
	        $(billArgsObj).attr("10071","6");	//˰��	
	 		$(billArgsObj).attr("10076","-"+totalFee);
	 		$(billArgsObj).attr("10072","2");	//����
		
		var z_loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;
	 		
			var h=210;
			var w=400;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no" 
			//var path = "/npage/public/pubBillPrintCfm_YGZ.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;
			
			//��Ʊ��Ŀ�޸�Ϊ��·��
			var j_param11215 = "";
		  var j_param11216 = ""; 
			$("#dataTable input[type='radio']:checked").each(function (){
				  j_param11215 = $(this).parent().parent().find("td:eq(11)").text().trim();
				  j_param11216 = $(this).parent().parent().find("td:eq(9)").text().trim();
				  if(j_param11216.length>6){
				  	j_param11216 = j_param11216.substring(0,6);
				  }
			});
			
			//��Ʊ��Ŀ�޸�Ϊ��·��
			$(billArgsObj).attr("11215",j_param11215); //��ҵ����ˮ
			$(billArgsObj).attr("11216",j_param11216); //ԭҵ������		yyyyMM		
			$(billArgsObj).attr("11214","HID_PR");	 //�����վݰ�ť
			var path = "/npage/public/billPrtNew/Bill_ELE_Prt.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;
	
			var loginAccept = "<%=printAccept%>";
			var path = path +"&loginAccept="+loginAccept+"&opCode=<%=opCode%>&submitCfm=submitCfm";
			var ret = window.showModalDialog(path,billArgsObj,prop);
		}
}
//��Ʊ�ִ�2
function showMarkBillPrt_F6(billArr){
//--------------��ʼƴװ��Ʊ---------------------------
		var custName       = billArr[2];
		var phoneNo        = billArr[3];
		var busiName       = billArr[1];
		var totalFeeC      = billArr[5];
		var totalFee       = billArr[6];
		var printInfo      = "";
		var feeName        = "������";
		var actionId = billArr[14];  
		var shuilv = billArr[15];
	    var shuier = billArr[16];
	    var jsje     =  billArr[17];   //��˰���
	    var  billArgsObj = new Object();
	    var zongqianshus="";
	    if(totalFee>0.01){
	    	zongqianshus="-"+totalFee;
	    }else {
	    	zongqianshus="0";
	    }
			$(billArgsObj).attr("10001","<%=workNo%>");     //����
			$(billArgsObj).attr("10002","<%=new java.text.SimpleDateFormat("yyyy",Locale.getDefault()).format(new java.util.Date())%>");
			$(billArgsObj).attr("10003","<%=new java.text.SimpleDateFormat("MM",Locale.getDefault()).format(new java.util.Date())%>");
			$(billArgsObj).attr("10004","<%=new java.text.SimpleDateFormat("dd",Locale.getDefault()).format(new java.util.Date())%>");
			$(billArgsObj).attr("10005",custName);   //�ͻ�����
			$(billArgsObj).attr("10006",busiName+"����");    //ҵ�����
			$(billArgsObj).attr("10008",phoneNo);    //�û�����
			$(billArgsObj).attr("10015", zongqianshus);   //���η�Ʊ���
			$(billArgsObj).attr("10016", zongqianshus);   //��д���ϼ�
			$(billArgsObj).attr("10017","*");        //���νɷѣ��ֽ�
		    $(billArgsObj).attr("10028",busiName);   //�����Ӫ������ƣ�
			$(billArgsObj).attr("10029",actionId);	 //Ӫ������	
			$(billArgsObj).attr("10030","<%=printAccept%>");   //��ˮ�ţ�--ҵ����ˮ
			$(billArgsObj).attr("10036","<%=opCode%>");   //��������
			$(billArgsObj).attr("10041", billArr[9]);           //Ʒ�����
			$(billArgsObj).attr("10042","̨");                   //��λ
			$(billArgsObj).attr("10043","1");	                   //����
			$(billArgsObj).attr("10044",billArr[6]);	                //����
			$(billArgsObj).attr("10045",billArr[11]);	       //IMEI
			$(billArgsObj).attr("10061",billArr[10]);	       //�ͺ�
			$(billArgsObj).attr("10062",shuilv);	//˰��
			$(billArgsObj).attr("10063","-"+shuier);	//˰��	   
	        $(billArgsObj).attr("10071","6");	//˰��	
	 		$(billArgsObj).attr("10076","-"+jsje);
	 		$(billArgsObj).attr("10072","2");
		
		var z_loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;
	 		
	 		$(billArgsObj).attr("10081","5"); 
			var h=210;
			var w=400;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no" 
			  //var path = "/npage/public/pubBillPrintCfm_YGZ.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;
			var j_param11215 = "";
		  var j_param11216 = ""; 
			$("#dataTable input[type='radio']:checked").each(function (){
				  j_param11215 = $(this).parent().parent().find("td:eq(11)").text().trim();
				  j_param11216 = $(this).parent().parent().find("td:eq(9)").text().trim();
				  if(j_param11216.length>6){
				  	j_param11216 = j_param11216.substring(0,6);
				  }
			});
			
			//��Ʊ��Ŀ�޸�Ϊ��·��
			$(billArgsObj).attr("11215",j_param11215); //��ҵ����ˮ
			$(billArgsObj).attr("11216",j_param11216); //ԭҵ������		yyyyMM			
			$(billArgsObj).attr("11214","HID_PR");	 //�����վݰ�ť
			var path = "/npage/public/billPrtNew/Bill_ELE_Prt.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;

			var loginAccept = "<%=printAccept%>";
			var path = path +"&loginAccept="+loginAccept+"&opCode=<%=opCode%>&submitCfm=submitCfm";
			var ret = window.showModalDialog(path,billArgsObj,prop);
}

//����ͳ����Ʊֻ�򹺻�����ȷ��
function showMarkBillPrt_JTTFGJ(billArr){
//--------------��ʼƴװ��Ʊ---------------------------
		var custName       = billArr[2];
		var phoneNo        = billArr[3];
		var busiName       = billArr[1];
		var totalFeeC      = billArr[5];
		var totalFee       = billArr[6];
		var printInfo      = "";
		var feeName        = "������";
		var actionId = billArr[14];  
		var shuilv = billArr[15];
	    var shuier = billArr[16];
	    var jsje     =  billArr[17];   //��˰���
	    var  billArgsObj = new Object();
	    var zongqianshus="";
	    if(totalFee>0.01){
	    	zongqianshus="-"+totalFee;
	    }else {
	    	zongqianshus="0";
	    }
	    
	  var prtLoginAcceptjttf = "";
		$("#dataTable input[type='radio']:checked").each(function (){
			  prtLoginAcceptjttf = $(this).parent().parent().find("td:eq(11)").text().trim();
		});
		
			$(billArgsObj).attr("10001","<%=workNo%>");     //����
			$(billArgsObj).attr("10002","<%=new java.text.SimpleDateFormat("yyyy",Locale.getDefault()).format(new java.util.Date())%>");
			$(billArgsObj).attr("10003","<%=new java.text.SimpleDateFormat("MM",Locale.getDefault()).format(new java.util.Date())%>");
			$(billArgsObj).attr("10004","<%=new java.text.SimpleDateFormat("dd",Locale.getDefault()).format(new java.util.Date())%>");
			$(billArgsObj).attr("10005",custName);   //�ͻ�����
			$(billArgsObj).attr("10006",busiName+"����");    //ҵ�����
			$(billArgsObj).attr("10008",phoneNo);    //�û�����
			$(billArgsObj).attr("10015", zongqianshus);   //���η�Ʊ���
			$(billArgsObj).attr("10016", zongqianshus);   //��д���ϼ�
			$(billArgsObj).attr("10017","*");        //���νɷѣ��ֽ�
		    $(billArgsObj).attr("10028",busiName);   //�����Ӫ������ƣ�
			$(billArgsObj).attr("10029",actionId);	 //Ӫ������	
			$(billArgsObj).attr("10030","<%=printAccept%>");   //��ˮ�ţ�--ҵ����ˮ
			$(billArgsObj).attr("10036","<%=opCode%>");   //��������
			$(billArgsObj).attr("10041", billArr[9]);           //Ʒ�����
			$(billArgsObj).attr("10042","̨");                   //��λ
			$(billArgsObj).attr("10043","1");	                   //����
			$(billArgsObj).attr("10044",billArr[6]);	                //����
			$(billArgsObj).attr("10045",billArr[11]);	       //IMEI
			$(billArgsObj).attr("10061",billArr[10]);	       //�ͺ�
			$(billArgsObj).attr("10062",shuilv);	//˰��
			$(billArgsObj).attr("10063","-"+shuier);	//˰��	   
	        $(billArgsObj).attr("10071","6");	//˰��	
	 		$(billArgsObj).attr("10076","-"+jsje);
	 		$(billArgsObj).attr("10072","2");
		
		var z_loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;
	 		
	 		$(billArgsObj).attr("10081","5"); 
	 		$(billArgsObj).attr("10082",prtLoginAcceptjttf); 
			var h=210;
			var w=400;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no" 
			//var path = "/npage/public/pubBillPrintCfm_YGZ_JTTF.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;


			var j_param11215 = "";
		  var j_param11216 = ""; 
			$("#dataTable input[type='radio']:checked").each(function (){
				  j_param11215 = $(this).parent().parent().find("td:eq(11)").text().trim();
				  j_param11216 = $(this).parent().parent().find("td:eq(9)").text().trim();
				  if(j_param11216.length>6){
				  	j_param11216 = j_param11216.substring(0,6);
				  }
			});
			
			//��Ʊ��Ŀ�޸�Ϊ��·��
			$(billArgsObj).attr("11215",j_param11215); //��ҵ����ˮ
			$(billArgsObj).attr("11216",j_param11216); //ԭҵ������		yyyyMM			
			
						
									//��Ʊ��Ŀ�޸�Ϊ��·��
			$(billArgsObj).attr("11214","HID_PR");	 //�����վݰ�ť
			var path = "/npage/public/billPrtNew/Bill_ELE_Prt.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;


			var loginAccept = "<%=printAccept%>";
			var path = path +"&loginAccept="+loginAccept+"&opCode=<%=opCode%>&submitCfm=submitCfm";
			var ret = window.showModalDialog(path,billArgsObj,prop);
}

//��Ʊ�ִ�1
function showMarkBillPrt_F7(billArr){
//--------------��ʼƴװ��Ʊ---------------------------
	var custName       = billArr[2];
	var phoneNo        = billArr[3];
	var busiName       = billArr[1];
	var actionId = 	billArr[14]; 
	var totalFee       = billArr[7];
	var totalFeeC      = billArr[7];
	var printInfo      = "";
	var feeName        = "ר��";
 	if(totalFee>0.01){
		var  billArgsObj = new Object();
		$(billArgsObj).attr("10001","<%=workNo%>");     //����
		$(billArgsObj).attr("10002","<%=new java.text.SimpleDateFormat("yyyy",Locale.getDefault()).format(new java.util.Date())%>");
		$(billArgsObj).attr("10003","<%=new java.text.SimpleDateFormat("MM",Locale.getDefault()).format(new java.util.Date())%>");
		$(billArgsObj).attr("10004","<%=new java.text.SimpleDateFormat("dd",Locale.getDefault()).format(new java.util.Date())%>");
		$(billArgsObj).attr("10005",custName);   //�ͻ�����
		$(billArgsObj).attr("10006",busiName+"����");    //ҵ�����
		$(billArgsObj).attr("10008",phoneNo);    //�û�����
		$(billArgsObj).attr("10015", "-"+totalFee);   //���η�Ʊ���
		$(billArgsObj).attr("10016", "-"+totalFee);   //��д���ϼ�
		$(billArgsObj).attr("10017","*");        //���νɷѣ��ֽ�
		$(billArgsObj).attr("10025","-"+totalFee); //Ԥ�滰��
		$(billArgsObj).attr("10030","<%=printAccept%>");   //��ˮ�ţ�--ҵ����ˮ
		$(billArgsObj).attr("10036","<%=opCode%>");   //��������
		$(billArgsObj).attr("10048","-"+totalFee);	//ͨ�ŷ���Ѻϼ�
    $(billArgsObj).attr("10071","4");	//��ӡģ��
    $(billArgsObj).attr("10028",busiName);   //�����Ӫ������ƣ�
		$(billArgsObj).attr("10029",actionId);	 //Ӫ������	
		$(billArgsObj).attr("10072","2"); 
		
		var z_loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;
		
		
			var h=210;
			var w=400;
			var t=screen.availHeight/2-h/2;
			var l=screen.availWidth/2-w/2;
			var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no" 
			//var path = "/npage/public/pubBillPrintCfm_YGZ.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;



			var j_param11215 = "";
		  var j_param11216 = ""; 
			$("#dataTable input[type='radio']:checked").each(function (){
				  j_param11215 = $(this).parent().parent().find("td:eq(11)").text().trim();
				  j_param11216 = $(this).parent().parent().find("td:eq(9)").text().trim();
				  if(j_param11216.length>6){
				  	j_param11216 = j_param11216.substring(0,6);
				  }
			});
			
			//��Ʊ��Ŀ�޸�Ϊ��·��
			$(billArgsObj).attr("11215",j_param11215); //��ҵ����ˮ
			$(billArgsObj).attr("11216",j_param11216); //ԭҵ������		yyyyMM			
			
						
												//��Ʊ��Ŀ�޸�Ϊ��·��
			var path = "/npage/public/billPrtNew/Bill_ELE_Prt.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;

			var loginAccept = "<%=printAccept%>";
			var path = path +"&loginAccept="+loginAccept+"&opCode=<%=opCode%>&submitCfm=submitCfm";
			var ret = window.showModalDialog(path,billArgsObj,prop);
	}
}

function showMarkPrtDlgbill_H(billArr){   //Ԥ���
	
		var printType      = "Bill";
		var DlgMessage     = "ȷʵҪ���з�Ʊ��ӡ��";
		var submitCfm      = "Yes";
		var custName       = billArr[2];
  	   var phoneNo        = billArr[3];
     	var busiName       = billArr[1];
  	    var totalFee       = billArr[6];
     	var totalFeeC      = billArr[5];
		var actionId = billArr[14];  
		var shuilv = billArr[15];
	    var shuier = billArr[16];  
	    var jsje     =  billArr[17];   //��˰���
  	    var prtLoginAccept = "";
		var printInfo      = "";
		var feeName        = "�ϼƽ��";
		$("#dataTable input[type='radio']:checked").each(function (){
			  prtLoginAccept = $(this).parent().parent().find("td:eq(11)").text().trim();
		});
 	var  billArgsObj = new Object();
	$(billArgsObj).attr("10001","<%=workNo%>");     //����
	$(billArgsObj).attr("10002","<%=new java.text.SimpleDateFormat("yyyy",Locale.getDefault()).format(new java.util.Date())%>");
	$(billArgsObj).attr("10003","<%=new java.text.SimpleDateFormat("MM",Locale.getDefault()).format(new java.util.Date())%>");
	$(billArgsObj).attr("10004","<%=new java.text.SimpleDateFormat("dd",Locale.getDefault()).format(new java.util.Date())%>");
	$(billArgsObj).attr("10005",custName);   //�ͻ�����
	$(billArgsObj).attr("10006", busiName +"����");    //ҵ�����
	$(billArgsObj).attr("10008",phoneNo);    //�û�����
	$(billArgsObj).attr("10015", "-"+totalFee);   //���η�Ʊ���
	$(billArgsObj).attr("10016", "-"+totalFee);   //��д���ϼ�
	
	var sumtypes1="*";
	var sumtypes2="";
	var sumtypes3="";
	$(billArgsObj).attr("10017",sumtypes1);        //���νɷѣ��ֽ�
	$(billArgsObj).attr("10018",sumtypes2);        //֧Ʊ
	$(billArgsObj).attr("10019",sumtypes3);        //ˢ��
    $(billArgsObj).attr("10028",busiName);   //�����Ӫ������ƣ�
	$(billArgsObj).attr("10029",actionId);	 //Ӫ������	
	$(billArgsObj).attr("10030","<%=printAccept%>");   //��ˮ�ţ�--ҵ����ˮ
	$(billArgsObj).attr("10031","<%=workNo%>");    //��Ʊ��
	$(billArgsObj).attr("10036","<%=opCode%>");   //��������
	$(billArgsObj).attr("10071","4");	//��ӡģ��
	$(billArgsObj).attr("10072","2");	//����
		
		var z_loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;
		
 	if(billArr[10]!=""){//���ն�
			$(billArgsObj).attr("10041", billArr[9]);           //Ʒ�����
			$(billArgsObj).attr("10042","̨");                   //��λ
			$(billArgsObj).attr("10043","1");	                   //����
			$(billArgsObj).attr("10044","0.0");	                //����
			$(billArgsObj).attr("10045",billArr[11]);	       //IMEI
			$(billArgsObj).attr("10061",billArr[10]);	       //�ͺ�
			$(billArgsObj).attr("10071","6");	//��ӡģ��
			$(billArgsObj).attr("10062",shuilv);	//˰��
			$(billArgsObj).attr("10063",shuier);	//˰��	 
			$(billArgsObj).attr("10076",jsje);	
			$(billArgsObj).attr("10081","5");
    }else{
	    	$(billArgsObj).attr("10062",shuilv);	//˰��
		    $(billArgsObj).attr("10063",shuier);	//˰��	 
			$(billArgsObj).attr("10071","4");	//��ӡģ��
    }  
		var h=210;
		var w=400;
		var t=screen.availHeight/2-h/2;
		var l=screen.availWidth/2-w/2;
		var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no" 
		//var path ="/npage/public/pubBillPrintCfm_YGZ.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;
		


			var j_param11215 = "";
		  var j_param11216 = ""; 
			$("#dataTable input[type='radio']:checked").each(function (){
				  j_param11215 = $(this).parent().parent().find("td:eq(11)").text().trim();
				  j_param11216 = $(this).parent().parent().find("td:eq(9)").text().trim();
				  if(j_param11216.length>6){
				  	j_param11216 = j_param11216.substring(0,6);
				  }
			});
			
			//��Ʊ��Ŀ�޸�Ϊ��·��
			$(billArgsObj).attr("11215",j_param11215); //��ҵ����ˮ
			$(billArgsObj).attr("11216",j_param11216); //ԭҵ������		yyyyMM			
			
						
												//��Ʊ��Ŀ�޸�Ϊ��·��
			var path = "/npage/public/billPrtNew/Bill_ELE_Prt.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;

		
		var loginAccept = "<%=printAccept%>";
		var path = path + "&loginAccept="+loginAccept+"&opCode=<%=opCode%>&submitCfm=submitCfm";
		var ret = window.showModalDialog(path,billArgsObj,prop);
	
}
function showMarkPrtDlgbill(billArr){   //Ԥ���
	
		var printType      = "Bill";
		var DlgMessage     = "ȷʵҪ���з�Ʊ��ӡ��";
		var submitCfm      = "Yes";
		var custName       = billArr[2];
  	   var phoneNo        = billArr[3];
     	var busiName       = billArr[1];
  	    var totalFee       = billArr[8];
     	var totalFeeC      = billArr[7];
		var actionId = billArr[14];  
  	    var prtLoginAccept = "";
		var printInfo      = "";
		var feeName        = "�ϼƽ��";
		$("#dataTable input[type='radio']:checked").each(function (){
			  prtLoginAccept = $(this).parent().parent().find("td:eq(11)").text().trim();
		});
		if(totalFee>0.01){
 	var  billArgsObj = new Object();
	$(billArgsObj).attr("10001","<%=workNo%>");     //����
	$(billArgsObj).attr("10002","<%=new java.text.SimpleDateFormat("yyyy",Locale.getDefault()).format(new java.util.Date())%>");
	$(billArgsObj).attr("10003","<%=new java.text.SimpleDateFormat("MM",Locale.getDefault()).format(new java.util.Date())%>");
	$(billArgsObj).attr("10004","<%=new java.text.SimpleDateFormat("dd",Locale.getDefault()).format(new java.util.Date())%>");
	$(billArgsObj).attr("10005",custName);   //�ͻ�����
	$(billArgsObj).attr("10006", busiName +"����");    //ҵ�����
	$(billArgsObj).attr("10008",phoneNo);    //�û�����
	$(billArgsObj).attr("10015", "-"+totalFee);   //���η�Ʊ���
	$(billArgsObj).attr("10016", "-"+totalFee);   //��д���ϼ�
	
	var sumtypes1="*";
	var sumtypes2="";
	var sumtypes3="";
	$(billArgsObj).attr("10017",sumtypes1);        //���νɷѣ��ֽ�
	$(billArgsObj).attr("10018",sumtypes2);        //֧Ʊ
	$(billArgsObj).attr("10019",sumtypes3);        //ˢ��
    $(billArgsObj).attr("10028",busiName);   //�����Ӫ������ƣ�
	$(billArgsObj).attr("10029",actionId);	 //Ӫ������	
	$(billArgsObj).attr("10030","<%=printAccept%>");   //��ˮ�ţ�--ҵ����ˮ
	$(billArgsObj).attr("10031","<%=workNo%>");    //��Ʊ��
	$(billArgsObj).attr("10036","<%=opCode%>");   //��������
	$(billArgsObj).attr("10071","4");	//��ӡģ��
	$(billArgsObj).attr("10072","2");	//����
		
		var z_loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;
 
		var h=210;
		var w=400;
		var t=screen.availHeight/2-h/2;
		var l=screen.availWidth/2-w/2;
		var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no" 
		//var path ="/npage/public/pubBillPrintCfm_YGZ.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;


			var j_param11215 = "";
		  var j_param11216 = ""; 
			$("#dataTable input[type='radio']:checked").each(function (){
				  j_param11215 = $(this).parent().parent().find("td:eq(11)").text().trim();
				  j_param11216 = $(this).parent().parent().find("td:eq(9)").text().trim();
				  if(j_param11216.length>6){
				  	j_param11216 = j_param11216.substring(0,6);
				  }
			});
			
			//��Ʊ��Ŀ�޸�Ϊ��·��
			$(billArgsObj).attr("11215",j_param11215); //��ҵ����ˮ
			$(billArgsObj).attr("11216",j_param11216); //ԭҵ������		yyyyMM			
			
							
												//��Ʊ��Ŀ�޸�Ϊ��·��
			var path = "/npage/public/billPrtNew/Bill_ELE_Prt.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;

	
		var loginAccept = "<%=printAccept%>";
		var path = path + "&loginAccept="+loginAccept+"&opCode=<%=opCode%>&submitCfm=submitCfm";
		var ret = window.showModalDialog(path,billArgsObj,prop);
	}
}
function showMarkPrtDlgbill1(billArr){   //������
	
		var printType      = "Bill";
		var DlgMessage     = "ȷʵҪ���з�Ʊ��ӡ��";
		var submitCfm      = "Yes";
		var custName       = billArr[2];
  	   var phoneNo        = billArr[3];
     	var busiName       = billArr[1];
  	    var totalFee       = billArr[6];
     	var totalFeeC      = billArr[5];
		var actionId = billArr[14];  
		var shuilv = billArr[15];
	    var shuier = billArr[16];  	
	    var jsje     =  billArr[17];   //��˰���
  	    var prtLoginAccept = "";
		var printInfo      = "";
		var feeName        = "�ϼƽ��";
		$("#dataTable input[type='radio']:checked").each(function (){
			  prtLoginAccept = $(this).parent().parent().find("td:eq(11)").text().trim();
		});
		if(totalFee>0.01){
 	var  billArgsObj = new Object();
	$(billArgsObj).attr("10001","<%=workNo%>");     //����
	$(billArgsObj).attr("10002","<%=new java.text.SimpleDateFormat("yyyy",Locale.getDefault()).format(new java.util.Date())%>");
	$(billArgsObj).attr("10003","<%=new java.text.SimpleDateFormat("MM",Locale.getDefault()).format(new java.util.Date())%>");
	$(billArgsObj).attr("10004","<%=new java.text.SimpleDateFormat("dd",Locale.getDefault()).format(new java.util.Date())%>");
	$(billArgsObj).attr("10005",custName);   //�ͻ�����
	$(billArgsObj).attr("10006", busiName +"����");    //ҵ�����
	$(billArgsObj).attr("10008",phoneNo);    //�û�����
	$(billArgsObj).attr("10015", "-"+totalFee);   //���η�Ʊ���
	$(billArgsObj).attr("10016", "-"+totalFee);   //��д���ϼ�
	
	var sumtypes1="*";
	var sumtypes2="";
	var sumtypes3="";
	$(billArgsObj).attr("10017",sumtypes1);        //���νɷѣ��ֽ�
	$(billArgsObj).attr("10018",sumtypes2);        //֧Ʊ
	$(billArgsObj).attr("10019",sumtypes3);        //ˢ��
    $(billArgsObj).attr("10028",busiName);   //�����Ӫ������ƣ�
	$(billArgsObj).attr("10029",actionId);	 //Ӫ������	
	$(billArgsObj).attr("10030","<%=printAccept%>");   //��ˮ�ţ�--ҵ����ˮ
	$(billArgsObj).attr("10031","<%=workNo%>");    //��Ʊ��
	$(billArgsObj).attr("10036","<%=opCode%>");   //��������
	$(billArgsObj).attr("10041", billArr[9]);           //Ʒ�����
	$(billArgsObj).attr("10042","̨");                   //��λ
	$(billArgsObj).attr("10043","1");	                   //����
	$(billArgsObj).attr("10044",billArr[6]);	                //����
	$(billArgsObj).attr("10045",billArr[11]);	       //IMEI
	$(billArgsObj).attr("10061",billArr[10]);	       //�ͺ�
	$(billArgsObj).attr("10071","6");	//��ӡģ��
	$(billArgsObj).attr("10062",shuilv);	//˰��
	$(billArgsObj).attr("10063","-"+shuier);	//˰��	 
    $(billArgsObj).attr("10072","2");	//����
   $(billArgsObj).attr("10076","-"+jsje);	
   $(billArgsObj).attr("10081","5");
		
		var z_loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;
    
 
		var h=210;
		var w=400;
		var t=screen.availHeight/2-h/2;
		var l=screen.availWidth/2-w/2;
		var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no" 
		//var path ="/npage/public/pubBillPrintCfm_YGZ.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;
		


			var j_param11215 = "";
		  var j_param11216 = ""; 
			$("#dataTable input[type='radio']:checked").each(function (){
				  j_param11215 = $(this).parent().parent().find("td:eq(11)").text().trim();
				  j_param11216 = $(this).parent().parent().find("td:eq(9)").text().trim();
				  if(j_param11216.length>6){
				  	j_param11216 = j_param11216.substring(0,6);
				  }
			});
			
			//��Ʊ��Ŀ�޸�Ϊ��·��
			$(billArgsObj).attr("11215",j_param11215); //��ҵ����ˮ
			$(billArgsObj).attr("11216",j_param11216); //ԭҵ������		yyyyMM			
			
								
		//��Ʊ��Ŀ�޸�Ϊ��·��
		$(billArgsObj).attr("11214","HID_PR");	 //�����վݰ�ť
		var path = "/npage/public/billPrtNew/Bill_ELE_Prt.jsp?dlgMsg=" + "ȷʵҪ���з�Ʊ��ӡ��"+"&feeName="+feeName;

		var loginAccept = "<%=printAccept%>";
		var path = path + "&loginAccept="+loginAccept+"&opCode=<%=opCode%>&submitCfm=submitCfm";
		var ret = window.showModalDialog(path,billArgsObj,prop);
	}
}
function ajaxGetBilPrt(){
	
	var phoneNoHv = document.getElementById("phoneNoHv"+document.all.lineFlagi.value).value;
	var opCode1Hv = document.getElementById("opCode1Hv"+document.all.lineFlagi.value).value;
	var opCode2Hv = document.getElementById("opCode2Hv"+document.all.lineFlagi.value).value;
	var loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;
	var serVIdHv = document.getElementById("hiddenStrv"+document.all.lineFlagi.value).value.split("|")[2];
	/**������� tianyang add for pos**/
	var returnMoneyHv = document.getElementById("returnMoneyHv"+document.all.lineFlagi.value).value;
		  var packet = new AJAXPacket("ajaxGetBillPrt.jsp");
		  		packet.data.add("phoneNo" ,phoneNoHv);
		  		packet.data.add("serVId" ,serVIdHv);
		  		packet.data.add("opCode1Hv" ,opCode1Hv);
		  		packet.data.add("opCode2Hv" ,opCode2Hv);
		  		/* liujian ��ȫ�ӹ��޸� 2012-4-6 8:59:56 begin */
		  		packet.data.add("opCode" ,'<%=opCode%>');
		  		packet.data.add("opName" ,'<%=opName%>');
		  		/* liujian ��ȫ�ӹ��޸� 2012-4-6 8:59:56 end */
		  		packet.data.add("loginAcceptHv" ,loginAcceptHv);
		  		packet.data.add("openrandom" ,"<%=printAccept%>");
		  		//alert("pos��Ʊ��ӡ");
		  		/**������� tianyang add for pos**/
		  		packet.data.add("payType" ,document.all.payType.value);		  		
			  	packet.data.add("returnMoneyHv" ,returnMoneyHv);
				  core.ajax.sendPacket(packet,doAjaxGetBilPrt);
				  packet =null;
}
var  billArgsObj = new Object();
function doAjaxGetBilPrt(packet){
		billArgsObj = packet.data.findValueByName("retInfo");
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
		$(billArgsObj).attr("10072","2");  
		
		var z_loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;
		
}
function pageSubmit()
{
	
	frm1102.action="f127a_2.jsp";
	frm1102.submit();
}
function pageSubmit_1()
{
	if (document.frm1102.opCode.value=="3264" && document.frm1102.backaccept.value.length==0)
	{
		rdShowMessageDialog("������ҵ����ˮ��");
	  	return false;
	}
	if (rdShowConfirmDialog("ȷ��Ҫ�ύ���β�����") == 1){

		frm1102.action="f1257.jsp";
		frm1102.submit();
	}
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
/* POS�ɷ��� ҳ���ύ  start*/
function posSubmitForm(result){
		if("<%=opCode%>"=="1121"){
			showPrtDlgbill("Bill","ȷʵҪ���з�Ʊ��ӡ��","Yes");
		}
		if("<%=opCode%>"=="m276"){
		
			showPrtDlgbill("Bill","ȷʵҪ���з�Ʊ��ӡ��","Yes");
		}
		if("<%=opCode%>"=="g795"){
			to_showMarkBillPrt();
			
		}
		var idnostrs = document.getElementById("idnoStrs"+document.all.lineFlagi.value).value;
		var packet = new AJAXPacket("f1170Cfm.jsp");		
		packet.data.add("result" ,result);
		packet.data.add("idnostrs" ,idnostrs);
	  packet.data.add("retType" ,"StartBackTest");
	  packet.data.add("srvno",document.frm1102.servno.value.trim());
	  packet.data.add("opCode","<%=opCode%>");
	  packet.data.add("opNameCfm",document.getElementById("opName2Hv"+document.all.lineFlagi.value).value);
	  packet.data.add("servIdArrStr",document.getElementById("servIdArrStrHv"+document.all.lineFlagi.value).value);
	  packet.data.add("opCodeCfm",document.all.opcodeCfm.value);
	  packet.data.add("loginAccept",document.all.loginAccept.value);
	  var loginAcceptHv = document.getElementById("loginAcceptHv"+document.all.lineFlagi.value).value;
	  packet.data.add("loginAcceptHv",loginAcceptHv);
	  //alert(loginAcceptHv);
	  //alert("pos����������");
	  /** pos���������� start **/
		packet.data.add("payType" ,document.all.payType.value);/** �ɷ����� payType=BX �ǽ��� payType=BY �ǹ��� **/
		packet.data.add("MerchantNameChs" ,document.all.MerchantNameChs.value);
		packet.data.add("MerchantId" ,document.all.MerchantId.value);
		packet.data.add("TerminalId" ,document.all.TerminalId.value);
		packet.data.add("IssCode" ,document.all.IssCode.value);
		packet.data.add("AcqCode" ,document.all.AcqCode.value);
		packet.data.add("CardNo" ,document.all.CardNo.value);
		packet.data.add("BatchNo" ,document.all.BatchNo.value);
		packet.data.add("Response_time" ,document.all.Response_time.value);
		packet.data.add("Rrn" ,document.all.Rrn.value);
		packet.data.add("AuthNo" ,document.all.AuthNo.value);
		packet.data.add("TraceNo" ,document.all.TraceNo.value);
		packet.data.add("Request_time" ,document.all.Request_time.value);
		packet.data.add("CardNoPingBi" ,document.all.CardNoPingBi.value);
		packet.data.add("ExpDate" ,document.all.ExpDate.value);
		packet.data.add("Remak" ,document.all.Remak.value);
		packet.data.add("TC" ,document.all.TC.value);
		/** pos���������� end */ 
	  core.ajax.sendPacket(packet);
	  packet =null;
}
/*tianyang add POS�ɷ� end*/
//hejwa add Ӫ���Զ���ѯ  2013-7-1 14:33:29
$(document).ready(function(){
	
	if("<%=opCode%>"=="g795"){
		doSearch();
	}
});
</SCRIPT>
<body>
<FORM method=post name="frm1102">
	<%@ include file="/npage/include/header.jsp" %>
<div class="title">
	<div id="title_zi">��ѯ����</div>
</div>

<input type="hidden" id="lineFlagi" name="lineFlagi">
<input type="hidden" id="retResult" name="retResult">
<input type="hidden" id="retRevsOfferId" name="retRevsOfferId">
<input type="hidden" id="retNowOfferId" name="retNowOfferId">
<input type="hidden" id="retPPV1" name="retPPV1">
<input type="hidden" id="billPath" name="billPath">
<input type="hidden" id="opcodeCfm" name="opcodeCfm">
<input type="hidden" id="loginAccept" name="loginAccept"  value="<%=printAccept%>">


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
<!-- 2014/04/04 11:15:23 gaopeng Ʒ��sm_code -->
<input type="hidden" name="pubSmCode" id="pubSmCode" value="" />
<!-- tianyang add at 20100201 for POS�ɷ�����*****end*******-->



          <table cellspacing=0>
                <TR>
                	<td class='blue' nowrap>��ѯ����</Td>
                  <TD>
                  	<select name="idType" id="idType" onchange="showValue()">
                  		<option value="0">�������</option>
                  	</select>
                  </TD>
	                	 <td class='blue' nowrap>����ֵ</Td>
	                  <TD>
	                    <input type="text" name="servno" class="InputGrey" onchange="" value="<%=activePhone%>" readOnly/>
	                    &nbsp;<font class='orange'>*</font>
	                  </TD>
                </TR>
                <tr id="theValue">
                	<td class='blue' nowrap>ҵ�������·�</Td>
                  <TD  >
                    <select name="searchDate" id="searchDate" onchange="">
                  		<option value="<%=currentTime%>"><%=currentTime%></option>
                  		<%if(!opCode.equals("g795")){%>
                  			<option value="<%=currentTime1%>"><%=currentTime1%></option>
                  		<%}%>
                  	</select>
                  </TD>
                  <td class='blue' nowrap>����ģ��</Td>
                  <TD  >
                    <input type="text" name="modeFlag" id="modeFlag"  value="<%=opCode%>" readOnly class="InputGrey">
                  </TD>
                </tr>
           </table>
		<% if (opCode.equals("3264")  || opCode.equals("1257") || opCode.equals("127a")  ){%>
        <div class="title" style="display:none">
		<div id="title_zi">����2010-01-01 �� 2010-01-08 �������ҵ��</div>
		</div>
			   <table cellspacing=0 style="display:none">
			 <% if (opCode.equals("3264")){%>
              		<tr id="theValue" >
                  <TD  class='blue' nowrap>ҵ����ˮ </TD>
                  <td colspan=3><input class="" name="backaccept" value="" >
                  	<input class="b_foot" onclick="pageSubmit_1()" type=button value="����ȷ��"/>
				  </td>
                  </tr>
                  <%}%>
                <% if (opCode.equals("127a")){%>
                   <tr id="theValue" >
                  <TD  colspan="4">
                    <input class="b_foot" onclick="pageSubmit()"  type="button" value="��ѯ"/>
                  </TD>
                  </tr>
                  <%}%>

                 <% if (opCode.equals("1257")){%>
                   <tr id="theValue" >
                  <TD  colspan="4" >
                    <input class="b_foot" onclick="pageSubmit_1()"  type=button value="����ȷ��"/>
                  </TD>
                  </tr>
                  <%}%>
              </table>
				<input type="hidden" name="opCode" value="<%=opCode%>">
				<input type="hidden" name="opName" value="<%=opName%>">
		<%}%>
      	<div id="searchResult"></div>
   <div id="Operation_Table">
         <div id="footer">
         		<%
         		if(!opCode.equals("g795")){
         		%>
              <input class="b_foot" onclick="doSearch()"  type=button value="��ѯ"/>
             <%}%> 
              <input class="b_foot" id="confirm" onclick="qryContent()"  type=button value="ȷ��&��ӡ"/>
              <input class="b_foot" name="quit"  onclick="removeCurrentTab()"  type=button value="�˳�"/>
		  	</div>
<input type="hidden" name="broadReturnStr" id="broadReturnStr" value="">
  <!------------------------>

<%@ include file="/npage/include/footer.jsp" %>
</form>
</div>

<!-- **** tianyang add for pos ******���ؽ��пؼ�ҳ BankCtrl ******** -->
<%@ include file="/npage/sq046/posCCB.jsp" %>
<!-- **** tianyang add for pos ******���ع��пؼ�ҳ KeeperClient ******** -->
<%@ include file="/npage/sq046/posICBC.jsp" %>

</body>
<%@ include file="/npage/public/hwObject.jsp" %> 
</html>