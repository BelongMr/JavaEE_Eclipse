<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
  /*
   * ����: �Զ�����
�� * �汾: 1.0.0
�� * ����: 2008/11/05
�� * ����: mixh
�� * ��Ȩ: sitech
   * ˵��: �뽫�Ʊ�������Ϊ4���ո�
   * update: mixh 2009/08/14 ���ӱ��ʼ칤��
�� */
%>
<%!
	public  String getCurrDateStr(String str) {
		  if(str.equals("")){
		    	return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
		  }else{
				 	java.text.SimpleDateFormat objSimpleDateFormat = new java.text.SimpleDateFormat(
							"yyyyMMdd");
				 	return objSimpleDateFormat.format(new java.util.Date())+" "+str;
		  }
	}
%>

<%
	String opCode = request.getParameter("opCode");
	String opName = request.getParameter("opName");
	if(opCode == null || "".equals(opCode)){
			opCode = "K400";
	}
	if(opName == null || "".equals(opName)){
			opName = "�Զ��ʼ�";
	}
%>

<%@ page contentType= "text/html;charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="javax.servlet.http.HttpServletRequest,com.sitech.crmpd.core.wtc.util.*,java.util.*,java.text.SimpleDateFormat"%>

<%
  /*midify by guozw 20091114 ������ѯ�����滻*/
 String myParams="";
 String org_code = (String)session.getAttribute("orgCode");
 String regionCode = org_code.substring(0,2);

	/***************��������еĲ���begin******************/
	String contect_id     = WtcUtil.repNull(request.getParameter("content_id"));     //ʵ��Ϊcontent���������ݣ���db�и��ֶ�ƴд���󣬴˴���db����һ��
	String object_id      = WtcUtil.repNull(request.getParameter("object_id"));
	String contact_id     = WtcUtil.repNull(request.getParameter("serialnum"));      //������ˮ
	String isOutPlanflag  = WtcUtil.repNull(request.getParameter("isOutPlanflag"));  //�ƻ����ʼ��־
	String staffno        = WtcUtil.repNull(request.getParameter("staffno"));        //���칤��
	String plan_id        = WtcUtil.repNull(request.getParameter("plan_id"));        //�ƻ�ID���ƻ����ʼ죩
	String group_flag     = WtcUtil.repNull(request.getParameter("group_flag"));        //����(1),����(0)����
	
	if(group_flag==null ||"".equals(group_flag)||"null".equals(group_flag)||"NULL".equals(group_flag)){
			group_flag = "1" ;
	}
	
	String tabId          = WtcUtil.repNull(request.getParameter("tabId"));          //tabҳ���idֵ
	String evterno        = (String)session.getAttribute("kfWorkNo");                //�ʼ칤�� ƽ̨����
	String workNo        	= (String)session.getAttribute("workNo");   //090922 �޸�Ϊboss����
	String objectName     = WtcUtil.repNull(request.getParameter("qc_objectvalue")); //����ʼ�������
	String contentName    = WtcUtil.repNull(request.getParameter("qc_contentvalue"));//��ÿ������ݿ�ʼ
	String out_returnVal = request.getParameter("out_returnVal");   //ʣ����ˮ��	
	String returnNum = request.getParameter("returnNum");						//�Զ���������
	//String tempQcCount    = replaceNull(request.getParameter("tempQcCount"), "0");    //�ʼ�Ա���������ʼ��¼��Ŀ
	String checktype      = "";                      //�������
	String kind           = "";                      //������ʽ
	String score          = "";                      //�ܷ�
	String vertify_passwd_flag = "";                //�Ƿ�У������	
	
	plan_id = (null == plan_id || "null".equals(plan_id)) ? "":plan_id.trim();
	
	/***************��������еĲ���end******************/
%>

<%
	/***************��ȡ���ʼ죨���ˣ���Ա���� begin******************/
	String loginName = "";
	String work_staffno = "";
	String sqlGetLoginName  = "SELECT v2.login_name,v2.login_no " + 
	                          "FROM dloginmsgrelation v1, dloginmsg v2 " + 
	                          "WHERE :staffno = v1.boss_login_no AND v1.boss_login_no = v2.login_no"; 
	myParams = "staffno="+staffno;        
%>
	<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>"  outnum="4">
	<wtc:param value="<%=sqlGetLoginName%>"/>
	<wtc:param value="<%=myParams%>"/>
	</wtc:service>
	<wtc:array id="loginNameList" scope="end"/>	
<%
	if(loginNameList.length > 0){
	  	loginName = loginNameList[0][0];
	  	work_staffno = loginNameList[0][1];
	}

	/***************��ȡ���ʼ죨���ˣ���Ա���� end******************/
%>

<%
	/***************��õ�ǰ�ʼ�Ա���ʼ�������ʼ******************/
	String starttime = getCurrDateStr("00:00:00");
	String endtime = getCurrDateStr("23:59:59");
	String qccounts="0";
	// flag '0','��ʱ����','1','���ύ','2','���ύ���޸�','3','��ȷ��','4','����')
	String getQcCount = "select to_char(nvl(count(*),0)) from dqcinfo where to_char(starttime,'yyyyMMdd hh24:mi:ss')>= :starttime and to_char(endtime,'yyyyMMdd hh24:mi:ss')<= :endtime and trim(evterno)= :workNo and (flag='1' or flag ='2' or flag='3')  and trim(is_del)='N' and plan_id = :plan_id " ;
myParams = "starttime="+starttime+",endtime="+endtime+",workNo="+workNo+",plan_id="+plan_id ;

%>
	<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>"  outnum="3">
	<wtc:param value="<%=getQcCount%>"/>
	<wtc:param value="<%=myParams%>"/>
	</wtc:service>
	<wtc:array id="qcCount" scope="end"/>
<%
	if(qcCount.length>0){
	  	qccounts=qcCount[0][0];
	}
	/***************��õ�ǰ�ʼ�Ա���ʼ���������******************/
%>  	
  
<%
	/***************��õ�ǰ�ʼ�Ա������������ʼ******************/
	String getQcTempCount = "select to_char(nvl(count(*),0)) from dqcinfo where to_char(starttime,'yyyyMMdd hh24:mi:ss')>= :starttime and trim(evterno)= :workNo  and trim(flag)='0'  and trim(is_del)='N' and plan_id = :plan_id " ;
	myParams = "starttime="+starttime+",workNo="+workNo.trim()+",plan_id="+plan_id ;
%>
	<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>"  outnum="3">
	<wtc:param value="<%=getQcTempCount%>"/>
	<wtc:param value="<%=myParams%>"/>
	</wtc:service>
	<wtc:array id="qcTempCount" scope="end"/>
<%
	/***************��õ�ǰ�ʼ�Ա��������������******************/
%>

<%
	/***************���ͨ����Ϣ��ʼ************ǰ��******/
	String nowYYYYMM   = contact_id.substring(0, 6);
	String nowYYYYMMDD = contact_id.substring(0, 8);
	String tableName   = "dcallcall" + nowYYYYMM;
	String sqlCallcall = "select caller_phone, decode(region_code, '01','������','02','�������','03','ĵ����','04','��ľ˹','05','˫Ѽɽ','06','��̨��','07','����','08','�׸�','09','����','10','�ں�','11','�绯','12','���˰���','13','����','15','��ػ�����','90','ʡ�ͷ�����'),call_cause_id,callcausedescs,vertify_passwd_flag from " + tableName + " where trim(contact_id)= :contact_id ";
	myParams = "contact_id="+contact_id.trim() ;
%>
	<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>"  outnum="5">
	<wtc:param value="<%=sqlCallcall%>"/>
	<wtc:param value="<%=myParams%>"/>
	</wtc:service>
	<wtc:array id="callcallList" scope="end"/>
<%
	if(callcallList.length>0){
		vertify_passwd_flag=callcallList[0][4];
	}
	/***************���ͨ����Ϣ����******************/
%>

<%
/***************����ʼ���Ϣ��ʼ**************ǰ��****/
	String sqlQcDetail = "select decode(t1.check_type,'0','ʵʱ�ʼ�','1','�º��ʼ�'),decode(t1.check_kind,'0','�Զ�����','1','�˹�ָ��'),decode(t1.check_class,'0','��������','1','����','2','����'),t4.object_name,t5.name,t1.check_type,t1.check_kind,t1.plan_id,to_char(t1.current_times) "
	                     +"from dqcplan t1,dqcobject t4,dqccheckcontect t5 "
	                     +"where  t1.object_id=t4.object_id(+) and t1.content_id=t5.contect_id(+)  and trim(t1.content_id)= :contect_id and trim(t1.object_id) = :object_id��and trim(t5.object_id) = :object_id and (t5.contect_id) = :contect_id and t1.plan_id= :plan_id";
	myParams = "contect_id="+contect_id+",object_id="+object_id+",object_id="+object_id+",contect_id="+contect_id+",plan_id="+plan_id ;
%>
	<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>"  outnum="9">
	<wtc:param value="<%=sqlQcDetail%>"/>
	<wtc:param value="<%=myParams%>"/>
	</wtc:service>
	<wtc:array id="qcDetailList" scope="end"/>

<%
	if(qcDetailList.length>0){
		checktype = qcDetailList[0][5];
		kind = qcDetailList[0][6];
	}


/***************����ʼ���Ϣ����********************/	
%>

<%
/***************������ʼ������ʼ******************/
	String completedCounts="";//ʵ������ʼ�����
	String sqlGetTimes = "select to_char(current_times) from dqcloginplan " + 
	                     "where  object_id= :object_id and content_id= :contect_id and plan_id= :plan_id and login_no= :work_staffno";
  myParams = "object_id="+object_id+",contect_id="+contect_id+",plan_id="+plan_id+",work_staffno="+work_staffno ;
%>
	<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>"  outnum="1">
	<wtc:param value="<%=sqlGetTimes%>"/>
	<wtc:param value="<%=myParams%>"/>
	</wtc:service>
	<wtc:array id="qcgetTimeList" scope="end"/>
<%
	if(qcgetTimeList.length>0){
			if("".equals(qcgetTimeList[0][0].trim())){
			  	completedCounts="1";
			}else{
				  int temp =Integer.parseInt(qcgetTimeList[0][0])+1;
				  completedCounts=temp+"";
			}
	}
/***************������ʼ��������******************/
%>

<%
/***************��ÿ������б���ʼ******************/
String sqlStr="select t.item_id, t.item_name, decode(substr(to_char(trim(low_score)),0,1),'.','0'||to_char(trim(low_score)),to_char(low_score)), decode(substr(to_char(trim(high_score)),0,1),'.','0'||to_char(trim(high_score)),to_char(high_score)),t.note " +
              "from dqccheckitem t where trim(t.contect_id)= :contect_id and trim(object_id) = :object_id and is_leaf='Y' and is_scored='Y' "+
              " and bak1='Y' " + "order by t.item_id";
myParams = "contect_id="+contect_id+",object_id="+object_id ;
%>
	<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>"  outnum="6">
	<wtc:param value="<%=sqlStr%>"/>
	<wtc:param value="<%=myParams%>"/>
	</wtc:service>
	<wtc:array id="queryList" scope="end"/>	
<%
/***************��ÿ������б�����******************/
%>

<%
/***************����ʼ���ˮ��ʼ******************/
	String sqlGetSerialNum = "select :nowYYYYMMDD||lpad(seq_qc_result.nextval,11,'0') from dual";
	myParams = "nowYYYYMMDD="+nowYYYYMMDD;
	//����ʼ���ˮ
%>
	<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>"  outnum="1">
	<wtc:param value="<%=sqlGetSerialNum%>"/>
		<wtc:param value="<%=myParams%>"/>
	</wtc:service>
	<wtc:array id="serialNum" scope="end"/>
<%
/***************����ʼ���ˮ����******************/
%>

<%
/***************��øÿ��������ֿܷ�ʼ******************/
	String getTotalScoreSql = "select to_char(sum(high_score)) from dqccheckitem " +
  	                        "where object_id = :object_id and contect_id = :contect_id and is_leaf='Y' "+" and is_scored='Y' "+ " and bak1='Y' ";
 myParams = "object_id="+object_id+",contect_id="+contect_id ;
%>
	<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>"  outnum="3">
	<wtc:param value="<%=getTotalScoreSql%>"/>
	<wtc:param value="<%=myParams%>"/>
	</wtc:service>
	<wtc:array id="totalScore" scope="end"/>
<%
	if(totalScore.length>0){
		score=totalScore[0][0];
	}
/***************��øÿ��������ֽܷ���******************/
%>


<%
/***************����ҳ�漴�����ʼ���Ϣ���ʼ���ϸ��Ϣ kangxq 20090806 begin******************/
/*zengzq modify 090829 ���� �ж��ǵ��˿������Ƕ��˿����ֶ�group_flag  0Ϊ���ˣ�1Ϊ����*/
	String sqlInitQcinfo = "INSERT INTO dqcinfo(serialnum, recordernum, outplanflag, staffno, objectid, contentid, score, starttime, flag, evterno, checktype, kind, is_del, checkflag, vertify_passwd_flag, plan_id, login_name,group_flag) " + 
	                       "VALUES('"+serialNum[0][0] + "','"+contact_id.trim()+"','"+isOutPlanflag+"','"+work_staffno+"','"+object_id.trim()+"','"+contect_id.trim()+"','"+totalScore[0][0]+"',sysdate,'0','"+workNo.trim()+"','"+checktype+"','"+kind+"','N','-1','"+vertify_passwd_flag+"','"+plan_id+"', '" + loginName + "','" + group_flag + "')";
	String[] sqlStrs   = new String[queryList.length + 1];
	StringBuffer sb = new StringBuffer();
	for(int i = 0; i < queryList.length; i++){
		/**sb.append("INSERT INTO dqcinfodetail(serialnum, objectid, contentid, itemid,score) VALUES('"+serialNum[0][0]+"','"+object_id.trim()+"','"+contect_id+"','"+queryList[i][0]+"','"+queryList[i][3]+"')");
		*/
		sb.append("INSERT INTO dqcinfodetail(serialnum, objectid, contentid, itemid,score) VALUES( :v1, :v2, :v3, :v4, :v5)");
		sb.append("&&"+serialNum[0][0]+"^"+object_id.trim()+"^"+contect_id+"^"+queryList[i][0]+"^"+queryList[i][3]);
		
		sqlStrs[i] = sb.toString();
		sb.delete(0, sb.length());
	}
	sqlStrs[queryList.length] = sqlInitQcinfo;
%>
	<wtc:service name="sModifyMulKfCfm"  outnum="2" routerKey="region" routerValue="<%=regionCode%>">
	    <wtc:param value=""/>
	    <wtc:param value="dbchange"/>
	    <wtc:params value="<%=sqlStrs%>"/>
	</wtc:service>
	
<%
/***************����ҳ�漴�����ʼ���Ϣ���ʼ���ϸ��Ϣ kangxq 20090806 end******************/
%> 

<%
/***************����DCALLCALLYYYYMM�е�ǰ��ˮ���ʼ�Ա���ź��Ƿ��ʼ��ʶ��ʼ******************/
/**String sqlUpdDcallcall="update " + tableName + " set QC_LOGIN_NO='" + evterno + "',QC_FLAG='Y' where contact_id='" + contact_id + "'";
*/

String sqlUpdDcallcall="update " + tableName + " set QC_LOGIN_NO= :v1 ,QC_FLAG='Y' where contact_id= :v2 ";

%>
<wtc:service name="sPubModifyKfCfm" outnum="3" routerKey="region" routerValue="<%=regionCode%>">
	<wtc:param value="<%=sqlUpdDcallcall%>"/>
	<wtc:param value="dbchange"/>
	<wtc:param value="<%=evterno%>"/>
	<wtc:param value="<%=contact_id%>"/>
	</wtc:service>
<%
/***************����DCALLCALLYYYYMM�е�ǰ��ˮ���ʼ�Ա���ź��Ƿ��ʼ��ʶ����******************/
%>
	
<%
/***************�������ԭ�����ݿ�ʼ******************/
	//��ȡ����ԭ��
	String tmp_callcause_id = (callcallList.length>0)?callcallList[0][2]:"";
	
	if(tmp_callcause_id.startsWith(",")){
	  	tmp_callcause_id = tmp_callcause_id.substring(1,tmp_callcause_id.length());
	}
	if(tmp_callcause_id.endsWith(",")){
	  	tmp_callcause_id = tmp_callcause_id.substring(0,tmp_callcause_id.length()-1);
	}
	
  String sqlGetCauseInfo = "select callcause_id,caption,fullname from dcallcausecfg where callcause_id in("+tmp_callcause_id+")";

%>
  <wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>"  outnum="3">
  		<wtc:param value="<%=sqlGetCauseInfo%>"/>
  </wtc:service>
  <wtc:array id="causeInfo" scope="end"/>
  	
<%
 	String tmpInfo = "";
 	String tmpId ="";
 	
	for(int i=0;i<causeInfo.length;i++){
			tmpInfo += causeInfo[i][2]+",";
			tmpId += causeInfo[i][0]+",";
	}
	
	if(tmpInfo.endsWith(",")){
	  	tmpInfo = tmpInfo.substring(0,tmpInfo.length()-1);
	  	tmpInfo = tmpInfo.trim();
	}
	
	if(tmpId.endsWith(",")){
	  	tmpId = tmpId.substring(0,tmpId.length()-1);
	  	tmpId = tmpId.trim();
	}
 /***************�������ԭ�����ݽ���******************/
%>
<html>
<head>
<script type="text/javascript" src="<%=request.getContextPath()%>/njs/csp/checkWork_dialog.js"></script>
<link href="<%=request.getContextPath()%>/nresources/default/css/dtmltree_css/dhtmlxtree.css" type=text/css rel=stylesheet>
<script src="<%=request.getContextPath()%>/njs/csp/dhtmlxtree_js/dhtmlxcommon.js" type=text/javascript></script>
<script src="<%=request.getContextPath()%>/njs/csp/dhtmlxtree_js/dhtmlxtree.js" type=text/javascript></script>
<script>

//�������ʾ���ֿ�����˵�� zengzq add 20091012
	function showReadMe(note){
		var note = note;
		if(""==note || note==undefined){
			note = "��������Ŀǰ�����˵����";
		}
		window.document.getElementById('readMeContent').innerText = note;
		window.document.getElementById('readMeContent').className = "blue";
	}

/**
  *�ʼ���Ϸ��ش�������
  */
function doProcessSaveQcInfo(packet){
	var retType = packet.data.findValueByName("retType");
	var retCode = packet.data.findValueByName("retCode");
	var retMsg = packet.data.findValueByName("retMsg");
	var content_id = packet.data.findValueByName("content_id");
	var opCode='<%=opCode%>';
	var haveNum = document.getElementById("haveNum").value;
	var out_returnVal = '<%=out_returnVal%>';
	var getReturnVal;
	 	
	if(retType=="saveQcInfo"){
			if(retCode=="000000"){
				similarMSNPop("�ɹ���¼���������");
			}else{
				similarMSNPop("��¼�������ʧ�ܣ�");
			}
	}
	//��������isSaved��ֵ��Ϊtrue
	document.getElementById("isSaved").value='true';
	
	/*ȡ���صĵ�һ����¼*/
			if(out_returnVal.length>0){
					var loc = out_returnVal.indexOf("_",0);
					if(loc>0){
							getReturnVal = out_returnVal.substr(0,loc);
							out_returnVal = out_returnVal.substring(loc + 1,out_returnVal.length);
					}else{
							getReturnVal = out_returnVal;
					}
					
					var getArr = getReturnVal.split("-");
					var serialnum = getArr[0];
					var staffno = getArr[1];
					var qc_flag = getArr[2];
					/*
					for(var i=0;i<getArr.length;i++){
						alert(getArr[i]);
					}
					*/
					//var tabId = opCode + getArr[0];
			}
			if(parseInt(haveNum)>0){
					 window.autoCheckForm.action="K400_out_plan_qc_form.jsp?opCode=<%=opCode%>&opName=<%=opName%>&object_id=<%=object_id%>&content_id=<%=contect_id%>&isOutPlanflag=<%=isOutPlanflag%>&plan_id=<%=plan_id%>&qc_objectvalue=<%=objectName%>&qc_contentvalue=<%=contentName%>&out_returnVal=" + out_returnVal + "&serialnum=" + serialnum + "&staffno=" + staffno + "&qc_flag=" + qc_flag + "&returnNum=" + haveNum + "&tabId=<%=tabId%>";
				 	 window.autoCheckForm.method='post';
				   window.autoCheckForm.submit(); 
			}else{
					setTimeout("closeWin()",2000);
			}
		
}

/**
  *
  *�ʼ���ϣ������ʼ���
  *
  */
function saveQcInfo() {
	//�ж�������Ϣ���ܹ���
	var wordlength1 = document.getElementById('contentinsum').value.length;
	var wordlength2 = document.getElementById('handleinfo').value.length;
	var wordlength3 = document.getElementById('improveadvice').value.length;
	var wordlength4 = document.getElementById('commentinfo').value.length;
	if(wordlength1>480){
		similarMSNPop("��������ݸſ���Ϣ���ȹ�����");
		document.getElementById('tb_4').click();
		document.getElementById('contentinsum').select();
		return false;
	}
	if(wordlength2>480){
		similarMSNPop("����Ĵ��������Ϣ���ȹ�����");
		document.getElementById('tb_2').click();
		document.getElementById('handleinfo').select();
		return false;
	}
	if(wordlength3>480){
		similarMSNPop("����ĸĽ�������Ϣ���ȹ�����");
		document.getElementById('tb_3').click();
		document.getElementById('improveadvice').select();
		return false;
	}
	if(wordlength4>480){
		similarMSNPop("������ۺ�������Ϣ���ȹ�����");
		document.getElementById('tb_1').click();
		document.getElementById('commentinfo').select();
		return false;
	}
    var chkPacket = new AJAXPacket("<%=request.getContextPath()%>/npage/callbosspage/checkWork/K217/K217_save_out_plan_qc.jsp","���Ժ�...");

		//��ÿ�����÷�
    var scoreValues    = new Array();
    for(var i = 0; i < parseInt('<%=queryList.length%>'); i++){
    		scoreValues[i] = document.getElementById("score"+i).value;
    }
    
    //��ÿ�����id
    var itemIdObjs      = document.getElementsByName("itemId");
    var itemIdValues    = new Array();
    for(var i = 0; i < itemIdObjs.length; i++){
    		itemIdValues[i] = itemIdObjs[i].value;
    }

		//�����ˮ��
		var serialnum = document.getElementById("serialnum").value;
		//���ݸſ�
    var contentinsum = document.getElementById("contentinsum").value;
    //�������
    var handleinfo = document.getElementById("handleinfo").value;
    //�Ľ�����
    var improveadvice = document.getElementById("improveadvice").value;
    //�ۺ�����
    var commentinfo = document.getElementById("commentinfo").value;
    //����ȼ�id
    var error_level_id = document.getElementById("error_level_id").value;
    //����ȼ�
    var error_level_text = document.getElementById("error_level_text").value;
    //������id
    var error_class_ids = document.getElementById("error_class_ids").value;
    //������
    var error_class_texts = document.getElementById("error_class_texts").value;
    //����ԭ��id
    var service_class_ids = document.getElementById("service_class_ids").value;
    //����ԭ��
    var service_class_texts = document.getElementById("service_class_texts").value;
    //����ԭ��id
    var check_reason_ids = document.getElementById("check_reason_ids").value;
    //����ԭ��
    var check_reason_texts = document.getElementById("check_reason_texts").value;
  
    //�ܵ÷�
    var totalScore = document.getElementById("totalScore").value;
    //�ʼ�ʱ��
    var handleTime = document.getElementById("handleTime").innerHTML;
    //��ȡ¼��ʱ��
    var listenTime = document.getElementById("listenTime").innerHTML;
    //����ʱ��
    var adjustTime = document.getElementById("adjustTime").innerHTML;     
    //��ʱ��
    var totalTime = document.getElementById("totalTime").innerHTML; 
    //ȡҳ�汣�����ˮ������Ϣ
		var haveNum = document.getElementById("haveNum").value; 
		//���ư���
    var remarkflag = document.getElementById("idremarkFlag").value; 
		
		chkPacket.data.add("retType", "saveQcInfo");
		chkPacket.data.add("scores", scoreValues);
		chkPacket.data.add("itemIds", itemIdValues);
		chkPacket.data.add("serialnum", serialnum);
		chkPacket.data.add("contact_id", "<%=contact_id%>");
		chkPacket.data.add("plan_id", "<%=plan_id%>");// �ʼ�ƻ�id
		chkPacket.data.add("completedCounts", "<%=completedCounts%>");//�ʼ�ƻ�ִ������
		chkPacket.data.add("contentinsum", contentinsum);
		chkPacket.data.add("handleinfo", handleinfo);
		chkPacket.data.add("improveadvice", improveadvice);
		chkPacket.data.add("commentinfo", commentinfo);
		chkPacket.data.add("error_level_id", error_level_id);
		chkPacket.data.add("error_level_text", error_level_text);
		chkPacket.data.add("error_class_ids", error_class_ids);
		chkPacket.data.add("error_class_texts", error_class_texts);
		chkPacket.data.add("service_class_ids", service_class_ids);
		chkPacket.data.add("service_class_texts", service_class_texts);
    chkPacket.data.add("check_reason_ids", check_reason_ids);
		chkPacket.data.add("check_reason_texts", check_reason_texts);
		chkPacket.data.add("totalScore", totalScore);
		chkPacket.data.add("flag", "1");
		chkPacket.data.add("objectid", "<%=object_id%>");
		chkPacket.data.add("contentid", "<%=contect_id%>");
		chkPacket.data.add("isOutPlanflag", "<%=isOutPlanflag%>");
		chkPacket.data.add("handleTime", handleTime);
		chkPacket.data.add("listenTime", listenTime);
		chkPacket.data.add("adjustTime", adjustTime);	
		chkPacket.data.add("totalTime", totalTime);	
		chkPacket.data.add("staffno","<%=work_staffno%>");
		chkPacket.data.add("haveNum", haveNum);// ��ҳ����������ȡֵ
		chkPacket.data.add("out_returnVal", "<%=out_returnVal%>");// ��δ���ʼ����ˮ
		//¼����Ͱ�����Ϣ
		if(remarkflag == "01"){
				chkPacket.data.add("idremarkFlag",remarkflag);//
			}
	  core.ajax.sendPacket(chkPacket,doProcessSaveQcInfo,true);
		chkPacket =null;
}


/**
  *��ʱ���淵�ش�������
  */
function doProcessTempSaveQcInfo(packet){
		var retType = packet.data.findValueByName("retType");
		var retCode = packet.data.findValueByName("retCode");
		var retMsg = packet.data.findValueByName("retMsg");
		var content_id = packet.data.findValueByName("content_id");
		var opCode='<%=opCode%>';
		var haveNum = document.getElementById("haveNum").value;
		var out_returnVal = '<%=out_returnVal%>';
		var getReturnVal; 
		if(retType=="tempSaveQcInfo"){
				if(retCode=="000000"){
					similarMSNPop("��ʱ�����ʼ����ɹ���");
				}else{
					similarMSNPop("��ʱ�����ʼ���ʧ�ܣ�");
				}
		}
		//��������isSaved��ֵ��Ϊtrue
		document.getElementById("isSaved").value='true';
		
		/*ȡ���صĵ�һ����¼*/
			if(out_returnVal.length>0){
					var loc = out_returnVal.indexOf("_",0);
					if(loc>0){
							getReturnVal = out_returnVal.substr(0,loc);
							out_returnVal = out_returnVal.substring(loc + 1,out_returnVal.length);
					}else{
							getReturnVal = out_returnVal;
					}
					
					var getArr = getReturnVal.split("-");
					var serialnum = getArr[0];
					var staffno = getArr[1];
					var qc_flag = getArr[2];
					/*
					for(var i=0;i<getArr.length;i++){
						alert(getArr[i]);
					}
					*/
					//var tabId = opCode + getArr[0];
			}
		if(parseInt(haveNum)>0){
				 window.autoCheckForm.action="K400_out_plan_qc_form.jsp?opCode=<%=opCode%>&opName=<%=opName%>&object_id=<%=object_id%>&content_id=<%=contect_id%>&isOutPlanflag=<%=isOutPlanflag%>&plan_id=<%=plan_id%>&qc_objectvalue=<%=objectName%>&qc_contentvalue=<%=contentName%>&out_returnVal=" + out_returnVal + "&serialnum=" + serialnum + "&staffno=" + staffno + "&qc_flag=" + qc_flag + "&returnNum=" + haveNum + "&tabId=<%=tabId%>";
			 	 window.autoCheckForm.method='post';
			   window.autoCheckForm.submit(); 
		}else{
				setTimeout("closeWin()",2000);
		}
}


/**
  *
  *��ʱ�����ʼ���
  *
  */
function tempSaveQcInfo(){
	//�ж�������Ϣ���ܹ���
	var wordlength1 = document.getElementById('contentinsum').value.length;
	var wordlength2 = document.getElementById('handleinfo').value.length;
	var wordlength3 = document.getElementById('improveadvice').value.length;
	var wordlength4 = document.getElementById('commentinfo').value.length;
	if(wordlength1>480){
		similarMSNPop("��������ݸſ���Ϣ���ȹ�����");
		document.getElementById('tb_4').click();
		document.getElementById('contentinsum').select();
		return false;
	}
	if(wordlength2>480){
		similarMSNPop("����Ĵ��������Ϣ���ȹ�����");
		document.getElementById('tb_2').click();
		document.getElementById('handleinfo').select();
		return false;
	}
	if(wordlength3>480){
		similarMSNPop("����ĸĽ�������Ϣ���ȹ�����");
		document.getElementById('tb_3').click();
		document.getElementById('improveadvice').select();
		return false;
	}
	if(wordlength4>480){
		similarMSNPop("������ۺ�������Ϣ���ȹ�����");
		document.getElementById('tb_1').click();
		document.getElementById('commentinfo').select();
		return false;
	}
    var chkPacket = new AJAXPacket("<%=request.getContextPath()%>/npage/callbosspage/checkWork/K217/K217_save_out_plan_qc.jsp","���Ժ�...");
		//��ÿ�����÷�
    var scoreValues    = new Array();
    
    for(var i = 0; i < parseInt('<%=queryList.length%>'); i++){
    		scoreValues[i] = document.getElementById("score"+i).value;
    }

    //��ÿ�����id
    var itemIdObjs      = document.getElementsByName("itemId");
    var itemIdValues    = new Array();
    for(var i = 0; i < itemIdObjs.length; i++){
    		itemIdValues[i] = itemIdObjs[i].value;
    }

	//�����ˮ��
	var serialnum = document.getElementById("serialnum").value;
	//���ݸſ�
    var contentinsum = document.getElementById("contentinsum").value;
    //�������
    var handleinfo = document.getElementById("handleinfo").value;
    //�Ľ�����
    var improveadvice = document.getElementById("improveadvice").value;
    //�ۺ�����
    var commentinfo = document.getElementById("commentinfo").value;
    //����ȼ�id
    var error_level_id = document.getElementById("error_level_id").value;
    //����ȼ�
    var error_level_text = document.getElementById("error_level_text").value;
    //������id
    var error_class_ids = document.getElementById("error_class_ids").value;
    //������
    var error_class_texts = document.getElementById("error_class_texts").value;
    //����ԭ��id
    var service_class_ids = document.getElementById("service_class_ids").value;
    //����ԭ��
    var service_class_texts = document.getElementById("service_class_texts").value;
    //����ԭ��id
    var check_reason_ids = document.getElementById("check_reason_ids").value;
    //����ԭ��
    var check_reason_texts = document.getElementById("check_reason_texts").value;
    //�ܵ÷�
    var totalScore = document.getElementById("totalScore").value;
    //�ʼ�ʱ��
    var handleTime = document.getElementById("handleTime").innerHTML;
    //��ȡ¼��ʱ��
    var listenTime = document.getElementById("listenTime").innerHTML;
    //����ʱ��
    var adjustTime = document.getElementById("adjustTime").innerHTML;     
    //��ʱ��
    var totalTime = document.getElementById("totalTime").innerHTML;    
    //ȡҳ�汣�����ˮ������Ϣ
		var haveNum = document.getElementById("haveNum").value; 
		   
		chkPacket.data.add("retType", "tempSaveQcInfo");
		chkPacket.data.add("scores", scoreValues);
		chkPacket.data.add("itemIds", itemIdValues);
		chkPacket.data.add("serialnum", serialnum);
		chkPacket.data.add("contentinsum", contentinsum);
		chkPacket.data.add("handleinfo", handleinfo);
		chkPacket.data.add("improveadvice", improveadvice);
		chkPacket.data.add("commentinfo", commentinfo);
		chkPacket.data.add("error_level_id", error_level_id);
		chkPacket.data.add("error_level_text", error_level_text);
		chkPacket.data.add("error_class_ids", error_class_ids);
		chkPacket.data.add("error_class_texts", error_class_texts);
		chkPacket.data.add("service_class_ids", service_class_ids);
		chkPacket.data.add("service_class_texts", service_class_texts);
    chkPacket.data.add("check_reason_ids", check_reason_ids);
		chkPacket.data.add("check_reason_texts", check_reason_texts);
		chkPacket.data.add("totalScore", totalScore);
		chkPacket.data.add("flag", "0");
		chkPacket.data.add("objectid", "<%=object_id%>");
		chkPacket.data.add("contentid", "<%=contect_id%>");
		chkPacket.data.add("isOutPlanflag", "<%=isOutPlanflag%>");
		chkPacket.data.add("handleTime", handleTime);
		chkPacket.data.add("listenTime", listenTime);
		chkPacket.data.add("adjustTime", adjustTime);		
		chkPacket.data.add("totalTime", totalTime);
		chkPacket.data.add("completedCounts", "<%=completedCounts%>");//�ʼ�ƻ�ִ������	
		chkPacket.data.add("staffno","<%=work_staffno%>");
		chkPacket.data.add("plan_id", "<%=plan_id%>");// �ʼ�ƻ�id
		
		chkPacket.data.add("contact_id", "<%=contact_id%>");  //������ˮ
		chkPacket.data.add("haveNum", haveNum);// ��ҳ����������ȡֵ
		chkPacket.data.add("out_returnVal", "<%=out_returnVal%>");// ��δ���ʼ����ˮ
		<!--����false��ʾͬ��ִ��-->
		core.ajax.sendPacket(chkPacket, doProcessTempSaveQcInfo, false);
		chkPacket =null;
}

/**
  *�������ش�������
  */
function doProcessGiveUpQcInfo(packet) {
		var retType = packet.data.findValueByName("retType");
		var retCode = packet.data.findValueByName("retCode");
		var retMsg = packet.data.findValueByName("retMsg");
		var content_id = packet.data.findValueByName("content_id");
		var opCode='<%=opCode%>';
		var haveNum = document.getElementById("haveNum").value;
		var out_returnVal = '<%=out_returnVal%>';
		var getReturnVal;  
		
		if(retType=="giveUpQcInfo"){
				if(retCode=="000000"){
					similarMSNPop("�ɹ������ʼ죡");
				}else{
					similarMSNPop("�����ʼ�ʧ�ܣ�");
				}
		}
		//��������isSaved��ֵ��Ϊtrue
		document.getElementById("isSaved").value='true';
		
		/*ȡ���صĵ�һ����¼*/
			if(out_returnVal.length>0){
					var loc = out_returnVal.indexOf("_",0);
					if(loc>0){
							getReturnVal = out_returnVal.substr(0,loc);
							out_returnVal = out_returnVal.substring(loc + 1,out_returnVal.length);
					}else{
							getReturnVal = out_returnVal;
					}
					
					var getArr = getReturnVal.split("-");
					var serialnum = getArr[0];
					var staffno = getArr[1];
					var qc_flag = getArr[2];
			}
			if(parseInt(haveNum)>0){
					 window.autoCheckForm.action="K400_out_plan_qc_form.jsp?opCode=<%=opCode%>&opName=<%=opName%>&object_id=<%=object_id%>&content_id=<%=contect_id%>&isOutPlanflag=<%=isOutPlanflag%>&plan_id=<%=plan_id%>&qc_objectvalue=<%=objectName%>&qc_contentvalue=<%=contentName%>&out_returnVal=" + out_returnVal + "&serialnum=" + serialnum + "&staffno=" + staffno + "&qc_flag=" + qc_flag + "&returnNum=" + haveNum + "&tabId=<%=tabId%>";
				 	 window.autoCheckForm.method='post';
				   window.autoCheckForm.submit(); 
			}else{
					setTimeout("closeWin()",2000);
			}
}
//��Ϊ����
function remarkMessage(){
	if(rdShowConfirmDialog("��Ϊ���Ͱ������ύ�ʼ��������Ƿ�ȷ����")=="1"){
			document.getElementById("idremarkFlag").value = "01";
			checkIsSendTip();finishedTimer();	//�ʼ����
	 }else{
	 	return false;
	 	}

	}
	
/**
  *
  *�����ʼ�
  *
  */
function giveUpQcInfo(){
    var chkPacket = new AJAXPacket("<%=request.getContextPath()%>/npage/callbosspage/checkWork/K217/K217_save_out_plan_qc.jsp","���Ժ�...");
	//��ÿ�����÷�
    var scoreValues    = new Array();
    
    for(var i = 0; i < parseInt('<%=queryList.length%>'); i++){
    		scoreValues[i] = document.getElementById("score"+i).value;
    }

    //��ÿ�����id
    var itemIdObjs      = document.getElementsByName("itemId");
    var itemIdValues    = new Array();
    
    for(var i = 0; i < itemIdObjs.length; i++){
    		itemIdValues[i] = itemIdObjs[i].value;
    }

		//�����ˮ��
		var serialnum = document.getElementById("serialnum").value;
		//���ݸſ�
    var contentinsum = document.getElementById("contentinsum").value;
    //�������
    var handleinfo = document.getElementById("handleinfo").value;
    //�Ľ�����
    var improveadvice = document.getElementById("improveadvice").value;
    //�ۺ�����
    var commentinfo = document.getElementById("commentinfo").value;
    
    
    //����ȼ�id
    var error_level_id = document.getElementById("error_level_id").value;
    //����ȼ�
    var error_level_text = document.getElementById("error_level_text").value;
    //������id
    var error_class_ids = document.getElementById("error_class_ids").value;
    //������
    var error_class_texts = document.getElementById("error_class_texts").value;
    //����ԭ��id
    var service_class_ids = document.getElementById("service_class_ids").value;
    //����ԭ��
    var service_class_texts = document.getElementById("service_class_texts").value;
    //����ԭ��id
    var check_reason_ids = document.getElementById("check_reason_ids").value;
    //����ԭ��
    var check_reason_texts = document.getElementById("check_reason_texts").value;
    //����ԭ��id
    var give_up_reason_ids = document.getElementById("give_up_reason_ids").value;    
    //����ԭ��
    var give_up_reason_texts = document.getElementById("give_up_reason_texts").value;
    //�ܵ÷�
    var totalScore = document.getElementById("totalScore").value;
    //�ʼ�ʱ��
    var handleTime = document.getElementById("handleTime").innerHTML;
    //��ȡ¼��ʱ��
    var listenTime = document.getElementById("listenTime").innerHTML;
    //����ʱ��
    var adjustTime = document.getElementById("adjustTime").innerHTML;     
    //��ʱ��
    var totalTime = document.getElementById("totalTime").innerHTML; 
		//ȡҳ�汣�����ˮ������Ϣ
		var haveNum = document.getElementById("haveNum").value; 
		
		chkPacket.data.add("retType", "giveUpQcInfo");
		chkPacket.data.add("scores", scoreValues);
		chkPacket.data.add("itemIds", itemIdValues);
		chkPacket.data.add("serialnum", serialnum);
		chkPacket.data.add("contentinsum", contentinsum);
		chkPacket.data.add("handleinfo", handleinfo);
		chkPacket.data.add("improveadvice", improveadvice);
		chkPacket.data.add("commentinfo", commentinfo);
		chkPacket.data.add("error_level_id", error_level_id);
		chkPacket.data.add("error_level_text", error_level_text);
		chkPacket.data.add("error_class_ids", error_class_ids);
		chkPacket.data.add("error_class_texts", error_class_texts);
		chkPacket.data.add("service_class_ids", service_class_ids);
		chkPacket.data.add("service_class_texts", service_class_texts);
    chkPacket.data.add("check_reason_ids", check_reason_ids);
		chkPacket.data.add("check_reason_texts", check_reason_texts);
		chkPacket.data.add("give_up_reason_ids", give_up_reason_ids);
		chkPacket.data.add("give_up_reason_texts", give_up_reason_texts);	
		chkPacket.data.add("totalScore", totalScore);
		chkPacket.data.add("flag", "4");
		chkPacket.data.add("objectid", "<%=object_id%>");
		chkPacket.data.add("contentid", "<%=contect_id%>");
		chkPacket.data.add("isOutPlanflag", "<%=isOutPlanflag%>");
		chkPacket.data.add("handleTime", handleTime);
		chkPacket.data.add("listenTime", listenTime);
		chkPacket.data.add("adjustTime", adjustTime);		
		chkPacket.data.add("totalTime", totalTime);
		chkPacket.data.add("completedCounts", "<%=completedCounts%>");//�ʼ�ƻ�ִ������
		chkPacket.data.add("staffno","<%=work_staffno%>");
		chkPacket.data.add("plan_id", "<%=plan_id%>");// �ʼ�ƻ�id
		chkPacket.data.add("contact_id", "<%=contact_id%>");  //������ˮ
		chkPacket.data.add("haveNum", haveNum);// ��ҳ����������ȡֵ
		chkPacket.data.add("out_returnVal", "<%=out_returnVal%>");// ��δ���ʼ����ˮ
		
		core.ajax.sendPacket(chkPacket, doProcessGiveUpQcInfo, true);
		chkPacket =null;
}

//��ʾͨ����ϸ��Ϣ
function getCallDetail(){
		var path="<%=request.getContextPath()%>/npage/callbosspage/k170/k170_getCallDetail.jsp";
	  path = path + "?contact_id=" + '<%=contact_id%>';
	  path = path + "&start_date=" + '<%=nowYYYYMM%>';
	  window.open(path,"newwindow","height=768, width=1072,top=50,left=100,scrollbars=yes, resizable=no,location=no, status=yes");
		return true;
}

//ѡ�����ȼ���ı�������ܷ�
function changeScore(i){
    var scorei = document.getElementById("score"+i);
    var itemleveli = document.getElementById("itemlevel"+i);
    var tmpVal = itemleveli.options[itemleveli.selectedIndex].value;
    var tmpArr = tmpVal.split("->");
    scorei.value = tmpArr[0];
    //getLevelValue();
    sumScore();
}

//zengzq add 20091016�����ʼ�ģ�彫ѡ�еĵȼ���������ƴ������������������ʾ
//modified by liujied 20091016 getLenth change to getLength,for
//you want to get the "length" of the list,rturnVal change to
//returnVal,I think you want to got a returned value
//

function getLevelValue(){
		document.getElementById("commentinfo").value = "";
    var getLength = '<%=queryList.length>0?queryList.length:0 %>';
    var returnVal = "";
    var itemleveli = "";
    var tmpVal1 = "";
    var tmpArr;
    var count = 0;
    
    for(var i=0;i < parseInt(getLength); i++){
         itemleveli = document.getElementById("itemlevel"+i);
         tmpVal = itemleveli.options[itemleveli.selectedIndex].value;
         tmpArr = tmpVal.split("->");
         if(tmpArr.length<2){
              continue;
         }else{
         		//zengzq add 20091030 ��ѡ��Ϊ�ȼ���߷����Σ��򲻼�¼�����ۺ�����������������Ϣ
            if(tmpArr[1]=="" || tmpArr[1]=="undefined" || parseInt(tmpArr[0])==parseInt(tmpArr[2])){
					  		continue;
					  }
              count++;
              if(i == parseInt(getLength)-1){
									returnVal = returnVal + count + ":" + tmpArr[1] +"��"+ "\n";
							}else{
						 			returnVal = returnVal + count + ":" + tmpArr[1] +";"+ "\n";
							}
         }
    }
    
    if(!(""==returnVal) && returnVal!="undefined"){
	  		document.getElementById("commentinfo").value = returnVal;
	  }
}

function checkIsSendTip(){
		var tipCheckBox = document.getElementById("sendTip");
		
		if(tipCheckBox.checked==true){
				window.openWinMid("../K217/K217_send_qc_result_tip.jsp","�ʼ�������",150, 400);
		}else{
				saveQcInfo();
		}
}

/**
 *���ܣ���¼�ʼ���֪ͨ
*/
function doQcCfm(flag){
	  var totalScore = document.getElementById("totalScore").value;	
		var mypacket = new AJAXPacket("../K203/K203_appOrCfm_rpc.jsp","���ڷ����������Ժ�......");
		mypacket.data.add("belongno","");
		mypacket.data.add("submitno","<%=workNo%>");
		mypacket.data.add("type",0);
		mypacket.data.add("serialnum","<%=serialNum[0][0]%>");
		mypacket.data.add("staffno","<%=work_staffno%>");
		mypacket.data.add("evterno","<%=workNo%>");
		mypacket.data.add("apptitle","��ˮ�ţ�<%=contact_id%> �����÷֣�"+totalScore);                   	
		mypacket.data.add("content","");  
		mypacket.data.add("flag",flag);  	
		core.ajax.sendPacket(mypacket,doQcCfmdoProcess,true);
		mypacket=null;     
}

//����֪ͨ�ص�����
function doQcCfmdoProcess(packet){	
		var flag = packet.data.findValueByName("flag");
		toSendMsg(flag);
}


//�����ʼ���֪ͨ����
function toSendMsg(flag){
		var mypacket = new AJAXPacket("<%=request.getContextPath()%>/npage/callbosspage/K084/K084_note_rpc.jsp","���ڷ���֪ͨ�����Ժ�......");
		mypacket.data.add("description","�ʼ���");//���ܳ���10λ
		mypacket.data.add("send_login_no","<%=evterno%>");
		mypacket.data.add("receive_login_no","<%=work_staffno%>");
		mypacket.data.add("cityid","");
		mypacket.data.add("content","��鿴��ˮ�ţ�<%=contact_id%>�����ֽ��");
		mypacket.data.add("msg_type",0);
		mypacket.data.add("title","�ʼ���֪ͨ");
	  mypacket.data.add("bak",flag);
	  core.ajax.sendPacket(mypacket,toSendMsgdoProcess,true);
		mypacket=null;
}

//�����ʼ���֪ͨ���ѻص�����
function toSendMsgdoProcess(packet){
		var retCode = packet.data.findValueByName("retCode");
		saveQcInfo();
}

/*-------------��ȡ¼�����ܿ�ʼ-----------------*/
/**
  *����¼���ļ�
  *
  */
function doLisenRecord(filepath,contact_id,idname){
		window.parent.top.document.getElementById("recordfile").value     = filepath;
		window.parent.top.document.getElementById("lisenContactId").value = contact_id;
		window.parent.top.document.getElementById("qcTabId").value        = '<%=tabId%>';
		window.parent.top.document.getElementById(idname).click();
}

function ListenPause(idname){
}

/**
  *���ʼ�TABҳ��򿪵�ʱ���ʼ��ʱ��ȡ¼����ַ��ʹ��ֱ�ӵ�������������ϵĲ��Ű�ť���ɲ���¼���ļ���
  *ע���˷���û�п��ǵ�����ж�����ˮ�����,��û���޸� add by hanjc at 20090714
  *
  */
function initCheckCallListen(id,idname){
		if(id==''){
				return;
		}
		
		var packet = new AJAXPacket(<%=request.getContextPath()%>"/npage/callbosspage/k170/k170_checkIsListen_rpc.jsp","");
		packet.data.add("contact_id",id);
		packet.data.add("idname",idname);
		core.ajax.sendPacket(packet,doProcessGetInitPath,false);
		packet=null;
}	

/**
  *initCheckCallListen�ص�����
  *
  */
function doProcessGetInitPath(packet){
   var file_path   = packet.data.findValueByName("file_path");
   var flag        = packet.data.findValueByName("flag");
   var contact_id  = packet.data.findValueByName("contact_id"); 
   var idname      = packet.data.findValueByName("idname");
   /**add by hanjc 20090714 begin ��ʱ���浱ǰ��ȡ¼������ˮ*/
   document.getElementById("lisenContactId").value = contact_id; 
   /**add by hanjc 20090714 end ��ʱ���浱ǰ��ȡ¼������ˮ*/     
   window.parent.top.document.getElementById("recordfile").value     = file_path;
   window.parent.top.document.getElementById("lisenContactId").value = contact_id;
   window.parent.top.document.getElementById("qcTabId").value        = '<%=tabId%>';
}

/**
  *¼����ȡ���ã�����¼���ļ�·��
  *����˵����
  *id:     ��ˮID
  *idname: opcode
  */
function checkCallListen(id,idname){
	if(id==''){
		return;
	}
	var packet = new AJAXPacket(<%=request.getContextPath()%>"/npage/callbosspage/k170/k170_checkIsListen_rpc.jsp","");
	packet.data.add("contact_id",id);
	packet.data.add("idname",idname);
	core.ajax.sendPacket(packet,doProcessGetPath,false);
	packet=null;
}

/**
  *checkCallListen�ص�����
  *
  */
function doProcessGetPath(packet){
   var file_path   = packet.data.findValueByName("file_path");
   var flag        = packet.data.findValueByName("flag");
   var contact_id  = packet.data.findValueByName("contact_id");
   var idname      = packet.data.findValueByName("idname"); 
 
   if(flag=='Y'){//����¼������ȡ��¼��
   		doLisenRecord(file_path,contact_id,idname);
   }else{//����¼�����¼��ѡ���ļ�
   		getCallListen(contact_id,idname);
   }
}

function getCallListen(id,idname){
		if(id==''){
				return;
		}	
		var path = "<%=request.getContextPath()%>"+"/npage/callbosspage/checkWork/K217/K217_getCallListen.jsp?flag_id="+id;
		openWinMid(path,'¼����ȡ',650,850);
}

/*--------------��ȡ¼�����ܽ���----------------*/

/*----------------������ʱ��ʼ--------------*/

var ListenTimer = null;
function ListenTimeStart(){ 
		var listenTime=document.getElementById("listenTime").innerHTML;
		listenTime=parseInt(listenTime)+1; 
	  document.getElementById("listenTime").innerHTML =listenTime;
	  window.ListenTimer = window.setTimeout("ListenTimeStart()",1000);
}

function ListenTimePause(){
		clearTimeout(window.ListenTimer);
}

function ListenTimeStop(){
		ListenTimePause();
}

function ListenTimeEnd(){
		ListenTimeStop();
}
/*----------------������ʱ����--------------*/

/*--------------��ʱ����ʼ----------------*/
window.onload=function(){
		setTimer();
		initCheckCallListen('<%=contact_id%>','K042');
}
var scan = "";
function setTimer(){
		scan = setInterval("timer()",1000);
}

//�����ʼ�ʱ��
function finishedTimer(){
		clearInterval(scan);
}

function timer(){
		var handleTime = document.getElementById("handleTime").innerHTML; 
		var listenTime = document.getElementById("listenTime").innerHTML;
		handleTime=parseInt(handleTime)+1;
		var totalTime = handleTime;
		document.getElementById("handleTime").innerHTML=handleTime;
		document.getElementById("totalTime").innerHTML=totalTime;
}

/*----------------��ʱ������--------------*/

//���д򿪴���
function openWinMid(url,name,iHeight,iWidth){
	  var iTop = (window.screen.availHeight-30-iHeight)/2; //��ô��ڵĴ�ֱλ��;
	  var iLeft = (window.screen.availWidth-10-iWidth)/2; //��ô��ڵ�ˮƽλ��;
	  window.open(url,name,'height='+iHeight+',innerHeight='+iHeight+',width='+iWidth+',innerWidth='+iWidth+',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=yes,resizeable=no,location=no,status=no');
}

//�رյ�ǰ����
function closeWin(){
		var tabId='<%=tabId%>';
		var isClosed = document.getElementById("isClosed").value;
		if(tabId!=''&& isClosed=='false'){
	    	parent.parent.removeTab(tabId.trim());
	  }
}
</script>

<style>
.content_02
{
	font-size:12px;
}
#tabtit
{
	height:23px;
	padding:0px 0 0 12px;
}
#tabtit ul
{
	height:23px;
	position:absolute;
}
#tabtit ul li
{
	float:left;
	margin-right:2px;
	display:inline;
	text-align:center;
	padding-top:7px;
	cursor:pointer;
	height:22px;
	width:100px;
}
#tabtit .normaltab
{
	color:#3161b1;
	background:url(<%=request.getContextPath()%>/nresources/default/images/callimage/tab_bj_02.gif) no-repeat left top;
	height:23px;
}
#tabtit .hovertab
{
	color:#3161b1;
	background:url(<%=request.getContextPath()%>/nresources/default/images/callimage/tab_bj_01.gif) no-repeat left top;
	height:24px;
}
.dis
{
	display:block;
	border-top:1px solid #6c90ca;
	background:#fff url(<%=request.getContextPath()%>/nresources/default/images/callimage/tab_cont.gif) repeat-x 0px 0px;
	padding:8px 12px;
}
.undis
{
	display:none;
}
.content_02 .dis li
{
	line-height:1.8em;
	padding-left:12px;
}

/*---------------��ȡ¼����ťstyle��ʼ-------*/
#callSearch
{
	height:1.2%;
	width:100%;
	padding:4px 2px;
	font-size:12px;
	z-index:1000000000000;
}

#callSearch img
{
	width:16px;
	height:16px;
	cursor:pointer;
}

/*---------------��ȡ¼����ťstyle����------------*/

#subScore{
border:1px solid #FFF;
}
</style>

</head>
<body>
<table style="table-layout:fixed;">
<tr>
<td valign='top' style="width:170px;height:100%;border-right:3px solid #DFE8F6;">
		<input type="button" name="cTree" class="b_text" value="������" onclick="HoverLiTmp(1);"/>
		<input type="button" name="rMe" class="b_text" value="˵��" onclick="HoverLiTmp(2);"/>	
				
		<div id="checkTree" class="dis">	
		<table width="100%">
		<tr>
			<td valign="top" width="100%">
			<div id="basetree" ></div>
			</td>
			<td valign=top width="100%">
			<div id="childtree"></div>
			</td>
		</tr>
		</table>
		</div>
		<div id="readMe" class="undis" >
			<div id="Operation_Table" style="width:120%;" >
			<table cellspacing="0">
				<tr>
					<td valign="top" id = "readMeContent" class="blue">��ѡ���Ҳ�������!</td>
				</tr>
			</table>
			</div>
		</div>
</td>
<td>
	
	<form name="autoCheckForm">
		<input type="hidden" name="haveNum" id="haveNum" value="0"/>
		<input type="hidden" name="group_flag" id="group_flag" value="<%=group_flag%>"/>
	</form>
<form name="form1">
<input type="hidden" name="serialnum" id="serialnum" value="<%=(serialNum.length>0)?serialNum[0][0]:""%>"/>
	<div id="Operation_Table" >
    <div class="title"><div id="title_zi">
    	�ʼ���Ϣ
<% 
    	         if(isOutPlanflag.equals("0")){
%>
    	         	������üƻ��ʼ죬�������<%=qccounts%>��������������<%=(qcTempCount.length>0)?qcTempCount[0][0]:"0"%>��
<%
    	         }
%>
    </div></div>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
      	<td class="blue">�������</td>
        <td>
		<input type="text" name="" id="" size="10" readonly value="<%=(qcDetailList.length>0)?qcDetailList[0][0]:""%>"/>
        </td>

        <td class="blue">������ʽ</td>
        <td>
     	<input type="text" name="" id="" size="10" readonly value="<%=(qcDetailList.length>0)?qcDetailList[0][1]:""%>"/>
        </td>

      	<td class="blue">��ˮ��</td>
        <td>
        <input type="text" name="" id=""  size="25" readonly value="<%=contact_id%>"/>
        </td>
      </tr>
      <tr>
      	<td class="blue">�ƻ�����</td>
        <td>
        <%if("1".equals(isOutPlanflag)){%>
        		<input type="text" name="" id="" size="10" readonly value=""/>
        <%}else{%>
		       <input type="text" name="" id="" size="10" readonly value="<%=(qcDetailList.length>0)?qcDetailList[0][2]:""%>"/>
		    <%}%>
        </td>

        <td class="blue">�������</td>
        <td>
     	<input type="text" name="" id="" size="10" readonly value="<%=(qcDetailList.length>0)?qcDetailList[0][3] : objectName%>"/>
        </td>

      	<td class="blue">������</td>
        <td>
        <input type="text" name="" id="" size="25"  readonly value="<%=work_staffno%>"/>
        </td>
      </tr>
      <tr>
      	<td class="blue">��������</td>
        <td>
		<input type="text" name="" id="" size="10" readonly value="<%=(qcDetailList.length>0)?qcDetailList[0][4]: contentName%>"/>
        </td>

        <td class="blue">�������</td>
        <td>
     	<input type="text" name="" id="" size="10" readonly value="<%if(callcallList.length>0){out.println(callcallList[0][0]);}%>"/>
        </td>

      	<td class="blue">������</td>
        <td>
        <input type="text" name="" id="" size="25"  readonly value="<%if(callcallList.length>0){out.println(callcallList[0][1]);}%>"/>
        </td>
      </tr>
	<tr>
	<td class="blue" colspan="2">
		<input type="checkbox" name="sendTip" id="sendTip" value=""/>���ͽ��֪ͨ &nbsp;&nbsp;&nbsp;
		<!--input type="button" name="" class="b_text" value="����"/-->
	</td>
	<td align="left" colspan="2">&nbsp;&nbsp;
		<%
		if(Integer.parseInt(returnNum)>1){
		%>
		<input type="button" name="" class="b_text" onClick="gotoNextCheck();" value="��һ��"/>
		<%
		}else{
		%>
		<input type="button" name="" class="b_text" disabled onClick="gotoNextCheck();" value="��һ��"/>
		<%
		}
		%>
		
		<!--input type="button" name="" class="b_text" value="ָ���µļƻ�"/-->
		<input type="button" name="" class="b_text" value="�鿴������Ϣ" onclick="getCallDetail();"/>
		<!--input type="button" name="" class="b_text" value="ѡ����ѵ����"/-->
	</td>
	<td colspan="2">&nbsp;&nbsp;</td>
	</tr>
	</table>
</div>



<div id="Operation_Table"  style="height:150px;width:99%;overflow:auto;">
  <div class="title"><div id="title_zi">
    ������Ŀ &nbsp;����÷ֺϼ� &nbsp;
  	<input type="text" disabled id="subScore" size="6" value="<%=(totalScore.length>0)?totalScore[0][0]:""%>"/> &nbsp;
  </div></div>
  <table id="tb2" width="100%" height="25" border="0" align="center" cellpadding="0px" cellspacing="0">
	  <tr>
	    <td class="blue" width="10%">���</td>
	    <td class="blue" width="40%">����</td>
	    <td class="blue" width="10%">��ͷ�</td>
	    <td class="blue" width="10%">��߷� </td>
	    <td class="blue" width="10%">�÷�</td>
	    <td class="blue" width="20%">�����ȼ�</td>    
	  </tr>

<%
	for(int i = 0; i < queryList.length; i++){
			out.println("<tr>");
			out.println("<td class='Blue' width='30px'>"+i+"</td>");
			out.println("<td class='Blue' width='40%' onclick=showReadMe('"+ queryList[i][4] +"')>");
			out.println(queryList[i][1]);
			out.println("<input type='hidden' name='itemId' value='"+queryList[i][0]+"'/>");
			out.println("</td>");
			out.println("<td class='Blue' width='40px'>"+queryList[i][2]+"</td>");
			out.println("<td class='Blue' width='40px'>"+queryList[i][3]+"</td>");
      //zengzq 20091017 ��ԭ��onblur���õ�sumScore()����ΪjudgeWidth���� �����жϵ�ǰ����ķ���ֵ�Ƿ���ѡ��ȼ���ֵ���� 
	    out.println("<td class='Blue' width='10px'><input type='text' name='score"+i+"' id='score"+i+"' size='6' maxlength='6' onblur='judgeWidth("+i+");' value='"+queryList[i][3]+"' onkeyup=\"value=value.replace(/[^-?\\d+$]/g,'') \"onbeforepaste=\"clipboardData.setData('text',clipboardData.getData('text').replace(/[^\\d]/g,''))\"/></td>");
			out.println("<td class='Blue' width='50px'>");
      //zengzq add 20091017 ����style���� �̶�select���� 
      out.println("<select style='width:100px;' name='itemlevel"+i+"' id='itemlevel"+i+"' onchange='changeScore("+i+");' style='width:80%'>");
      //���Ӽ�¼��������߷��ڲ�ѯ��һ�queryList[i][3](zengzq 20091030)
			%>
	    <wtc:qoption name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" outnum="3">
	    <wtc:sql>
	    	select decode(substr(to_char(trim(score)),0,1),'.','0'||to_char(trim(score)),to_char(trim(score)))||'->'||note||'->'||'<%=queryList[i][3]%>', decode(substr(to_char(trim(low_score)),0,1),'.','0'||to_char(trim(low_score)),to_char(trim(low_score)))||'--'||decode(substr(to_char(trim(score)),0,1),'.','0'||to_char(trim(score)),to_char(trim(score)))||'->'||level_name from dqcckectitemlevel where item_id=<%=(queryList.length>0)?queryList[i][0]:""%> and content_id='<%=contect_id%>' and object_id='<%=object_id%>' order by score desc 
	    </wtc:sql>
	    </wtc:qoption>
<%
	    	out.println("</select>");
				out.println("</td>");
				out.println("</tr>");
            //zengzq  start 20091017 select�еĿ�����������ʱ��������һ��Ĭ��ֵ
%>
<script>
	if(document.getElementById("itemlevel"+ '<%=i%>').options.length<1){
		//document.getElementById("itemlevel"+ '<%=i%>').options.add(new Option('<%=queryList[i][2]%>'+"--"+'<%=queryList[i][3]%>'+"->"+"Ĭ�ϵȼ�",'<%=queryList[i][3]%>'+"->"+"Ĭ�ϵȼ�") );
		document.getElementById("itemlevel"+ '<%=i%>').options[0] = new Option('<%=queryList[i][2]%>'+"--"+'<%=queryList[i][3]%>'+"->"+"Ĭ�ϵȼ�",'<%=queryList[i][3]%>');
	}
</script>
<%
//zengzq  end 20091017 select�еĿ�����������ʱ��������һ��Ĭ��ֵ

	}
%>
</table>
</div>

<div id="Operation_Table">
	<div class="title"><div id="title_zi">��Ч����(<%=qccounts%>)�� &nbsp;</div></div>
	<%
			//�����Զ�������ʾ����ȼ���Ϣ start zengzq add 20091103 
			 String toScore = (totalScore.length>0)?totalScore[0][0]:"0";
			 //zengzq modify ���toScoreֵΪ��ֵ�ǣ��������Ϊ0 20091231
			 toScore = (toScore.length()>0)?toScore:"0";
			 String error_l_texts = "";
			 String error_l_ids = "";
			 if(Integer.parseInt(toScore)>=101){
					 	error_l_texts = "����";
					 	error_l_ids = "01";
			 }else if(Integer.parseInt(toScore)>=91 && Integer.parseInt(toScore)<=100){
			 			error_l_texts = "��";
					 	error_l_ids = "02";
			 }else if(Integer.parseInt(toScore)>=81 && Integer.parseInt(toScore)<=90){
			 			error_l_texts = "��";
					 	error_l_ids = "03";
			 }else if(Integer.parseInt(toScore)>=70 && Integer.parseInt(toScore)<=80){
			 			error_l_texts = "��";
					 	error_l_ids = "04";
			 }else if(Integer.parseInt(toScore)<=69){
			 			error_l_texts = "��";
					 	error_l_ids = "05";
			 }
			 //�����Զ�������ʾ����ȼ���Ϣ end zengzq add 20091103
		%>
	<table width="100%" height=25 border=0 align="center" cellpadding="4" cellspacing="0">
		<tr>
		<td class="blue" align="left" width="8%">����ȼ�</td>
		<td width="22%">
		<input type="text" name="error_level_text" id="error_level_text" size="30" value="<%=error_l_texts%>" readonly />
		<input type="hidden" name="error_level_id" id="error_level_id" value="<%=error_l_ids%>"/>
		<!--input type="button" name="btn_error_level" class="b_text" value="ѡ��" onclick="show_select_error_level_win();"/-->
		</td>
		<td class="blue" align="left" width="8%">������</td>
		<td width="22%">
		<input type="text" name="error_class_texts" id="error_class_texts" size="16" value="" readonly/>
		<input type="hidden" name="error_class_ids" id="error_class_ids" value=""/>
		<input type="button" name="btn_error_class" class="b_text" value="ѡ��" onclick="show_select_error_class_win();"/>
		</td>
		<td class="blue" align="left" width="8%">���ﷶ��</td>
		<td width="22%">
	<!--	<input type="text" name="error_level_text" id="error_level_text" size="30" value="<%=error_l_texts%>" readonly />-->
		<input type="hidden" name="error_level_id" id="error_level_id_answer" value="<%=error_l_ids%>"/>
		<input type="button" name="btn_error_level" class="b_text" value="ѡ��" onclick="show_select_error_level_win();">
		</td>
	</tr>
	<tr>
		<td class="blue" align="left" width="8%">����ԭ��</td>
		<td width="22%">
		<input type="text" name="service_class_texts" id="service_class_texts" size="30" value="<%=tmpInfo%>" readonly/>
		<input type="hidden" name="service_class_ids" id="service_class_ids" value="<%=tmpId%>"/>
		<!--����ԭ��������-->
		<input type="hidden" name="give_up_reason_ids" id="give_up_reason_ids" />
		<input type="hidden" name="give_up_reason_texts" id="give_up_reason_texts" />			
		</td>
    <!--liujied ��������ԭ�� 20091015 start -->
		<td class="blue" align="left" width="8%">����ԭ��</td>
		<td width="22%">
		<input type="text" name="check_reason_texts" id="check_reason_texts" size="16" value="" readonly/>
		<input type="hidden" name="check_reason_ids" id="check_reason_ids" value=""/>
		<input type="button" name="btn_check_reason" value="ѡ��" class="b_text" onclick="show_select_check_reason_win();"/>
		</td>
		<td class="blue" colspan="6" width="8%">&nbsp;</td>
	</tr>
	</table>
</div>

<div id="Operation_Table">
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		<div class="content_02">
			<div id="tabtit">
				<ul>
					<li id="tb_1" class="hovertab" onclick="HoverLi(1);">1 �ۺ�����</li>
					<li id="tb_2" class="normaltab" onclick="HoverLi(2);">2 �������</li>
					<li id="tb_3" class="normaltab" onclick="HoverLi(3);">3 �Ľ�����</li>
					<li id="tb_4" class="normaltab" onclick="HoverLi(4);">4 ���ݸſ�</li>
				</ul>
			</div>
			<div class="dis" id="tbc_01" name=""><!-- �ۺ����� -->
		    	<textarea id="commentinfo" cols="110" rows="5"></textarea>
			</div>
			<div class="undis" id="tbc_02">
				<textarea id="handleinfo" cols="110" rows="5"></textarea>
			</div>
			<div class="undis" id="tbc_03">
				<textarea id="improveadvice" cols="110" rows="5"></textarea>
			</div>
			<div class="undis" id="tbc_04">
				<textarea id="contentinsum" cols="110" rows="5"></textarea>
			</div>
		</div>

		</td>
	</tr>
	</table>

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td class="blue" align="center" id="footer" width="100%">
        <div id="callSearch">
				�ܷ֣�<input type="text" name="totalScore" id="totalScore" size="6" value="<%=(totalScore.length>0)?totalScore[0][0]:""%>" readonly/>
				<input name="confirm" onClick="tempSaveQcInfo();finishedTimer();" type="button" class="b_foot" value="��ʱ����">
				<input name="confirm" onClick="checkIsSendTip();finishedTimer();" type="button" class="b_foot" value="�ʼ����">
				<input name="confirm" onClick="remarkMessage();" type="button" class="b_foot" value="��Ϊ����">
				<input name="remarkFlag" type="hidden" id="idremarkFlag"><!-- �ж��ǵ��Ͱ��������ʼ챣�� -->
				<input name="confirm" onClick="show_select_give_up_reason_win()" type="button" class="b_foot_long" value="����">
				<!--	<input name="back" onClick="grpClose();" type="button" class="b_foot" value="ȡ��">-->
		    <b id="K042" onclick="checkCallListen('<%=contact_id%>','K042');return false;"><img src="<%=request.getContextPath()%>/nresources/default/images/ico_16/img_k042.gif" alt="����" /></b>
		    <b id="K043" onclick="checkCallListen('<%=contact_id%>','K043');return false;"><img src="<%=request.getContextPath()%>/nresources/default/images/ico_16/img_k043.gif" alt="ֹͣ����" /></b>
		    <b id="K044" onclick="checkCallListen('<%=contact_id%>','K044');return false;"><img src="<%=request.getContextPath()%>/nresources/default/images/ico_16/img_k044.gif" alt="��ͣ����" /></b>
		    <b id="K064" onclick="checkCallListen('<%=contact_id%>','K064');return false;"><img src="<%=request.getContextPath()%>/nresources/default/images/ico_16/img_k064.gif" alt="��������" /></b>
		    <b id="K045" onclick="checkCallListen('<%=contact_id%>','K045');return false;"><img src="<%=request.getContextPath()%>/nresources/default/images/ico_16/img_k045.gif" alt="���" /></b>
		    <b id="K046" onclick="checkCallListen('<%=contact_id%>','K046');return false;"><img src="<%=request.getContextPath()%>/nresources/default/images/ico_16/img_k046.gif" alt="����" /></b>
      </div>
			</td>
		</tr>
	</table>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td class="blue" align="left" >�ʼ쿪ʼ��</td>     <td class="blue" align="left" ><%=getCurrDateStr("")%></td>
			<td class="blue" align="left" >�ʼ������</td>     <td class="blue" align="left" >&nbsp;</td>
			<td class="blue" align="left" >����ʱ����</td>     <td class="blue" align="left" id="handleTime">0</td>
		</tr>
		<tr>
			<td class="blue" align="left" >����/����ʱ����</td><td class="blue" align="left" id="listenTime">0</td>
			<td class="blue" align="left" >����ʱ����</td>     <td class="blue" align="left" id="adjustTime">0</td>
			<td class="blue" align="left" >��ʱ����</td>       <td class="blue" align="left" id="totalTime">0</td>
		</tr>		
	</table>	
	<!--������isSavedΪfalse ��ʾ��ǰ���δ�����κα��������������������-->
	<input type='hidden' name='isSaved' id='isSaved' value='false'>
	<!--������isSaved����------------->
	<!--������isClosedΪfalse ���ڿ��ƹر�tabҳ����ֻ�ɵ���һ��-->
	<input type='hidden' name='isClosed' id='isClosed' value='false'>
	<!--������isClosed����------------->
	<!--������lisenContactIdΪ��ǰ�ʼ���ȡ¼������ˮ��-->
	<input type='hidden' name='lisenContactId' id='lisenContactId' value=''>
	<!--������lisenContactId����------------->	

</div>

</form>

</td>
</tr>
</table>
</body > 
</html>

<script language="javascript">

function grpClose(){
		window.opener = null;
		top.close();
}
/*�����һ��������ѡ��ÿ���������ʽ zengzq add 20090831*/
function gotoNextCheck(){
		var haveNum = parseInt('<%=returnNum%>') -1;
		document.getElementById("haveNum").value = haveNum;
		
		window.openWinMid("./K400_sureCheckType.jsp","ѡ��ǰ��ˮ������ʽ",150, 400);
		//window.showModalDialog("./K400_sureCheckType.jsp",'',"dialogWidth=800px;dialogHeight=420px");
		
}
function te1st(){
	window.close();
}

/**
  * �����жϣ���ǰ����ķ�ֵ�����ڵȼ���Χ֮��
  * zengzq 20091017
  */
function judgeWidth(i){
	var itemleveli = document.getElementById("itemlevel"+i);
	var itmeLevelName = itemleveli.options[itemleveli.selectedIndex].innerText;
	var itmeLevelNameArr = itmeLevelName.split("->");
	var scoreArr = itmeLevelNameArr[0].split("--");
	var l_score = scoreArr[0];
	var h_score = scoreArr[1];
	var  s_score = "score"+i;
	var curr_score = document.getElementById(s_score).value;
	if(parseInt(curr_score)>parseInt(h_score) || parseInt(curr_score)<parseInt(l_score)){
			similarMSNPop("����ķ�������ѡ��ĵȼ������Σ����õķ����ظ�Ϊ�÷�������߷֣�");
			document.getElementById(s_score).value = h_score;
			document.getElementById(s_score).select();
	}
	sumScore();
}  

/**
  *������¼���ʧȥ����󣬼��㵱ǰ�÷�
  */
function sumScore(){
		var inputs = document.getElementsByTagName('input');
		var objTotalScore = document.getElementById("totalScore");
		var subScore = document.getElementById("subScore");
		var totalScore = 0;
		//�����Զ���ʾ����ȼ����� start zengzq add 20091103 
		var error_l_texts = "";
		var error_l_ids = ""; 
		//�����Զ���ʾ����ȼ����� end zengzq add 20091103 
		for(var i = 0; i < inputs.length; i++){
				if(inputs[i].name.substring(0,5) == 'score'){
						totalScore += parseFloat(inputs[i].value);
				}
		}
		
		objTotalScore.value = totalScore;
		subScore.value = totalScore;
		//�����Զ�������ʾ����ȼ� start zengzq add 20091103 
		 if(parseInt(totalScore)>=101){
					 	error_l_texts = "����";
					 	error_l_ids = "01";
			 }else if(totalScore>=91 && totalScore<=100){
			 			error_l_texts = "��";
					 	error_l_ids = "02";
			 }else if(totalScore>=81 && totalScore<=90){
			 			error_l_texts = "��";
					 	error_l_ids = "03";
			 }else if(totalScore>=70 && totalScore<=80){
			 			error_l_texts = "��";
					 	error_l_ids = "04";
			 }else if(totalScore<=69){
			 			error_l_texts = "��";
					 	error_l_ids = "05";
			 }
			 document.getElementById("error_level_text").value = error_l_texts;
			 document.getElementById("error_level_id").value = error_l_ids;
			//�����Զ�������ʾ����ȼ� end zengzq add 20091103
}

function g(o){
		return document.getElementById(o);
}
function HoverLi(n){
		for(var i=1;i<=4;i++){
				g('tb_'+i).className='normaltab';
				g('tbc_0'+i).className='undis';
		}
		g('tbc_0'+n).className='dis';
		g('tb_'+n).className='hovertab';
}

/**
  *����ѡ�����ԭ��Ĵ���
  */
function show_select_give_up_reason_win(){
	//�ж�������Ϣ���ܹ���
	var wordlength1 = document.getElementById('contentinsum').value.length;
	var wordlength2 = document.getElementById('handleinfo').value.length;
	var wordlength3 = document.getElementById('improveadvice').value.length;
	var wordlength4 = document.getElementById('commentinfo').value.length;
	if(wordlength1>480){
		similarMSNPop("��������ݸſ���Ϣ���ȹ�����");
		document.getElementById('tb_4').click();
		document.getElementById('contentinsum').select();
		return false;
	}
	if(wordlength2>480){
		similarMSNPop("����Ĵ��������Ϣ���ȹ�����");
		document.getElementById('tb_2').click();
		document.getElementById('handleinfo').select();
		return false;
	}
	if(wordlength3>480){
		similarMSNPop("����ĸĽ�������Ϣ���ȹ�����");
		document.getElementById('tb_3').click();
		document.getElementById('improveadvice').select();
		return false;
	}
	if(wordlength4>480){
		similarMSNPop("������ۺ�������Ϣ���ȹ�����");
		document.getElementById('tb_1').click();
		document.getElementById('commentinfo').select();
		return false;
	}
		var returnValue = window.showModalDialog("../K217/K217_get_give_up_reason.jsp",'',"dialogWidth=800px;dialogHeight=420px");
		if(typeof(returnValue) != "undefined"){
				var give_up_reason_texts = document.getElementById("give_up_reason_texts");
				var give_up_reason_ids   = document.getElementById("give_up_reason_ids");
				var temp = returnValue.split('_');
				give_up_reason_texts.value = trim(temp[0]);
				give_up_reason_ids.value = trim(temp[1]);
				
				var temp1= trim(temp[0]);
				var temp2= trim(temp[1]);
				var texts_temp_level = temp1.split(',');
				var ids_temp_level = temp2.split(',');
				give_up_reason_texts.value="";
				for(var i=0; i<texts_temp_level.length-1; i++){
							if(i!=0&&i%2==0){
							give_up_reason_texts.value +='<br>';
					}
					if(i!=texts_temp_level.length-1){
				    	give_up_reason_texts.value += texts_temp_level[i] + ',';
				  }  
		}
		giveUpQcInfo();
		finishedTimer();
	 }
}


/**
  *����ѡ�����ԭ��Ĵ��� ��д������������ڱ���ס���� 
  *zengzq 20090909
  */
function mult_show_select_give_up_reason_win(returnValue){
	//�ж�������Ϣ���ܹ���
	var wordlength1 = document.getElementById('contentinsum').value.length;
	var wordlength2 = document.getElementById('handleinfo').value.length;
	var wordlength3 = document.getElementById('improveadvice').value.length;
	var wordlength4 = document.getElementById('commentinfo').value.length;
	if(wordlength1>480){
		similarMSNPop("��������ݸſ���Ϣ���ȹ�����");
		document.getElementById('tb_4').click();
		document.getElementById('contentinsum').select();
		return false;
	}
	if(wordlength2>480){
		similarMSNPop("����Ĵ��������Ϣ���ȹ�����");
		document.getElementById('tb_2').click();
		document.getElementById('handleinfo').select();
		return false;
	}
	if(wordlength3>480){
		similarMSNPop("����ĸĽ�������Ϣ���ȹ�����");
		document.getElementById('tb_3').click();
		document.getElementById('improveadvice').select();
		return false;
	}
	if(wordlength4>480){
		similarMSNPop("������ۺ�������Ϣ���ȹ�����");
		document.getElementById('tb_1').click();
		document.getElementById('commentinfo').select();
		return false;
	}
		if(typeof(returnValue) != "undefined"){
				var give_up_reason_texts = document.getElementById("give_up_reason_texts");
				var give_up_reason_ids   = document.getElementById("give_up_reason_ids");
				var temp = returnValue.split('_');
				give_up_reason_texts.value = trim(temp[0]);
				give_up_reason_ids.value = trim(temp[1]);
				
				var temp1= trim(temp[0]);
				var temp2= trim(temp[1]);
				var texts_temp_level = temp1.split(',');
				var ids_temp_level = temp2.split(',');
				give_up_reason_texts.value="";
				for(var i=0; i<texts_temp_level.length-1; i++){
							if(i!=0&&i%2==0){
							give_up_reason_texts.value +='<br>';
					}
					if(i!=texts_temp_level.length-1){
				    	give_up_reason_texts.value += texts_temp_level[i] + ',';
				  }  
		}
		giveUpQcInfo();
		finishedTimer();
	 }
}

/**
  *����ѡ�����ȼ��Ĵ���
  */
function show_select_error_level_win(){
		var returnValue = window.showModalDialog("../K217/K217_get_error_level.jsp",'',"dialogWidth=1000px;dialogHeight=530px");
		/*if(typeof(returnValue) != "undefined"){
				var error_level_text = document.getElementById("commentinfo");
				var error_level_id   = document.getElementById("error_level_id_answer");
				var temp = returnValue.split('_');
				error_level_text.value = trim(temp[0]);
				error_level_id.value = trim(temp[1]);
				
				var temp1= trim(temp[0]);
				var temp2= trim(temp[1]);
				var texts_temp_level = temp1.split(',');
				var ids_temp_level = temp2.split(',');
				error_level_text.value="";
				for(var i=0; i<texts_temp_level.length-1; i++){
						if(i!=0&&i%2==0){
								error_level_text.value +='<br>';
						}
						if(i!=texts_temp_level.length-1){
					    	error_level_text.value += texts_temp_level[i] + ',';
					  } 
				}
		}*/
		if(typeof(returnValue) != "undefined"){
				document.getElementById("commentinfo").value = returnValue;
		}
}

/**
  *����ѡ�������Ĵ���
  */
function show_select_error_class_win(){
		var returnValue = window.showModalDialog("../K217/K217_get_error_class.jsp",'',"dialogWidth=720px;dialogHeight=350px");
		
		if(typeof(returnValue) != "undefined"){
				var error_class_texts = document.getElementById("error_class_texts");
				var error_class_ids  = document.getElementById("error_class_ids");
				var temp = returnValue.split('_');
				error_class_texts.value = trim(temp[0]);
				error_class_ids.value   = trim(temp[1]);
				var temp1= trim(temp[0]);
				var temp2= trim(temp[1]);
				var texts_temp_arr = temp1.split(',');
				var ids_temp_arr = temp2.split(',');
				error_class_texts.value="";
				
				for(var i=0; i<texts_temp_arr.length-1; i++){
					
						if(i!=0&&i%2==0){
								error_class_texts.value +='<br>';
						}
						
						if(i!=texts_temp_arr.length-1){
						  	error_class_texts.value += texts_temp_arr[i] + ',';
						}
				}
		}
}

/**
  *����ѡ������ԭ��Ĵ���
  */
function show_select_service_class_win(){
		if(<%=callcallList.length%>==0||trim('<%=(callcallList.length>0)?callcallList[0][2]:""%>')==""){
				similarMSNPop("����ˮ�޶�Ӧ������ԭ��");
		}else{
				var returnValue = window.showModalDialog("../K217/K217_get_service_class.jsp?call_cause_id=<%=(callcallList.length>0)?callcallList[0][2]:""%>&call_cause_desc=<%=(callcallList.length>0)?callcallList[0][3]:""%>",'',"dialogWidth=800px;dialogHeight=350px");
				
				if(typeof(returnValue) != "undefined"){
						var service_class_texts = document.getElementById("service_class_texts");
						var service_class_ids   = document.getElementById("service_class_ids");
						var temp = returnValue.split('_');
						service_class_texts.value = trim(temp[0]);
						service_class_ids.value   = trim(temp[1]);
				}
		}
}
//added by liujied 20091016
function show_select_check_reason_win(){
		var returnValue = window.showModalDialog("../K217/K217_get_check_reason.jsp",'',"dialogWidth=720px;dialogHeight=350px");
		
		if(typeof(returnValue) != "undefined"){
				var check_reason_texts = document.getElementById("check_reason_texts");
				var check_reason_ids  = document.getElementById("check_reason_ids");
				var temp = returnValue.split('_');
				check_reason_texts.value = trim(temp[0]);
				check_reason_ids.value   = trim(temp[1]);
				var temp1= trim(temp[0]);
				var temp2= trim(temp[1]);
				var texts_temp_arr = temp1.split(',');
				var ids_temp_arr = temp2.split(',');
				check_reason_texts.value="";
				
				for(var i=0; i<texts_temp_arr.length-1; i++){
					
						if(i!=0&&i%2==0){
								check_reason_texts.value +='<br>';
						}
						
						if(i!=texts_temp_arr.length-1){
						  	check_reason_texts.value += texts_temp_arr[i] + ',';
						}
				}
		}
}

/*
 *��ʼ�����ĵ�һ��ڵ�
 */
function initBaseTree(){
	tree=new dhtmlXTreeObject("baseTree","100%","100%",-1);
	tree.setImagePath(<%=request.getContextPath()%>"/nresources/default/images/callimage/dtmltree_imgs/csh_books/");	
	tree.enableCheckBoxes(0);
	tree.enableDragAndDrop(0);
	tree.enableTreeLines(true);
	tree.setOnClickHandler(onNodeClick);
	tree.loadXML("<%=request.getContextPath()%>/npage/callbosspage/checkWork/K230/K230_create_qc_item_tree_xml.jsp?content_id=<%=contect_id%>&object_id=<%=object_id%>");
	//���ĸ��ڵ�Ϊ0
	var subItemsArr = tree.getAllSubItems("0").split(',');
	for(var i = 0; i < subItemsArr.length; i++){
		if(tree.getUserData(subItemsArr[i], 'isleaf') != 'Y'){
			tree.setItemImage2(subItemsArr[i],'folderClosed.gif','folderClosed.gif','folderClosed.gif');
		}
	}
}


/**
  *��Ӧ��굥���¼���ѡ�е�ǰ�ڵ㣬��չʾ��ǰ�ڵ��µ��ӽ��
  */
function onNodeClick(){
	if(tree.getSelectedItemId() == '0'){
		return;
	}
	getTreeListByNodeId();
}

//����ѡ�еĽڵ�id ���ظýڵ����ӽڵ�
function getTreeListByNodeId(){
	var nodeId = tree.getSelectedItemId();
	var varSubItems=tree.getSubItems(tree.getSelectedItemId());
	if(varSubItems!=null&&varSubItems!=''){
		return;
	}

	var packet = new AJAXPacket("<%=request.getContextPath()%>/npage/callbosspage/checkWork/K230/K230_get_qc_item_child_tree.jsp?object_id=<%=object_id%>&content_id=<%=contect_id%>", "...");
	packet.data.add("parent_item_id",nodeId);
	core.ajax.sendPacket(packet,doProcessGetList,true);
}

//getTreeListByNodeId�Ļص�����
function doProcessGetList(packet){
	var childNodeList = packet.data.findValueByName("worknos");
	var nodeId        = packet.data.findValueByName("nodeId");
	insertChildNodeList(childNodeList);
}

/**
  *���������߼�
  */
function insertChildNodeList(retData){
	//alert("begin insertChildNodeList....");
   	var varSubItems=tree.getSubItems(tree.getSelectedItemId());
   	var str = new Array();

   	//�жϸýڵ�д�Ƿ����ӽڵ㣬������жϹ���һ�µ�ǰ�ڵ�ֵ�Ƿ������ݿ����ֵһ��
	if(varSubItems != null && varSubItems != ''){
		str=varSubItems.split(",");
		for(var i=0;i<retData.length;i++){
			//���˵�ǰ�ڵ����ӽڵ������ݿ��Ƿ���ͬ
			if(!isStr(retData[i][0],str)){
				tree.insertNewItem(retData[i][1],retData[i][0],retData[i][2],0,0,0,0,'SELECT') ;
				tree.setUserData(retData[i][0],"isleaf",retData[i][3]);
				tree.setUserData(retData[i][0],"isscored",retData[i][4]);
				tree.setUserData(retData[i][0],"object_id",retData[i][5]);
			}
     	}
	}else{//�����ǰ�ڵ������ӽڵ㣬�����䵱ǰ�ڵ��������ӽڵ�
		for(var i = 0; i < retData.length; i++){
			tree.insertNewItem(retData[i][1], retData[i][0], retData[i][2], 0, 0, 0, 0, 'TOP');
			tree.setUserData(retData[i][0],"isleaf",retData[i][3]);
			tree.setUserData(retData[i][0],"isscored",retData[i][4]);
			tree.setUserData(retData[i][0],"object_id",retData[i][5]);
		}
	}
	//alert("end insertChildNodeList....");
}

//�ж�һ���ַ����Ƿ��������г���
function isStr(strtreeData,str){
		if(str!=null){
				for(var j=0;j<str.length;j++){
						if(strtreeData.trim()==str[j].trim()){
								return true;
						}
				}
		}
		return false;
}

function HoverLiTmp(n){
		if(n==1){
			document.getElementById('checkTree').className='dis';
			document.getElementById('readMe').className='undis';
		}
		if(n==2){
			document.getElementById('checkTree').className='undis';
			document.getElementById('readMe').className='dis';
		}
}

//ȥ��ո�;
function ltrim(s){
  	return s.replace( /^\s*/, "");
}

//ȥ�ҿո�;
function rtrim(s){
		return s.replace( /\s*$/, "");
}

//ȥ���ҿո�;
function trim(s){
		return rtrim(ltrim(s));
}

//��ʼ����
initBaseTree();
</script>