<%
  /*
   * ����: ���ⷴ��
�� * �汾: v1.0
�� * ����: 2008��10��25��
�� * ����: piaoyi
�� * ��Ȩ: sitech
   * �޸���ʷ
   * �޸�����      �޸���      �޸�Ŀ��
 ��*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd>
<HTML xmlns="http://www.w3.org/1999/xhtml">
<%@ taglib uri="weblogic-tags.tld" prefix="wl" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ include file="../../npage/common/serverip.jsp" %>
<%@ include file="../../npage/bill/getMaxAccept.jsp" %>
<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>

<%
	response.setHeader("Pragma","No-Cache");
	response.setHeader("Cache-Control","No-Cache");
  response.setDateHeader("Expires", 0);
  String workName = (String)session.getAttribute("workName");
  String ipAddr = (String)session.getAttribute("ipAddr");
  String orgCode = (String)session.getAttribute("orgCode");
  String workNo = (String)session.getAttribute("workNo");
  String password = (String)session.getAttribute("password");
  
  String regionCode = orgCode.substring(0,2);
  String opCode="2029";
  String opName="��Ʒ����������ϵ����";
  String sqlStr="";
  String disabledStr = "";
  
  session.removeAttribute("p_OperType-f2029_1.jsp");//add by wangzn
  session.removeAttribute("p_BusinessMode-f2029_1.jsp");//add by wangzn
  //url������������
  String openFlag = request.getParameter("openFlag");
  String inUnitId = request.getParameter("inUnitId");
  String in_bizCode = request.getParameter("in_bizCode");
  String in_bizName = request.getParameter("in_bizName");
  String inEcId = "";
  
  //�˵��˹�����Ԥ����
  String sm_code = WtcUtil.repNull((String)request.getParameter("sm_code"));
  String in_GrpId = WtcUtil.repNull((String)request.getParameter("in_GrpId"));
  String in_ChanceId = WtcUtil.repNull((String)request.getParameter("in_ChanceId"));
  String IdNo = WtcUtil.repNull((String)request.getParameter("IdNo"));
  String WaNo = WtcUtil.repNull((String)request.getParameter("wa_no1"));
  opCode = WtcUtil.repNull((String)request.getParameter("opCode"));
  opName = WtcUtil.repNull((String)request.getParameter("opName"));
  String busi_req_type = "";
  String in_pospec_number = "";
  String in_productspec_name = "";
  String in_productspec_number = "";
  String Imitation_retInfo="";
  String poorder_type = "";
  String[][] result9103_5 = null;
  String[][] result9103_6 = null;
  System.out.println("====wanghfa==== in_ChanceId = " + in_ChanceId);
  System.out.println("====wanghfa==== regionCode = " + regionCode);
	if(!"".equals(in_ChanceId)){
		%>
		<wtc:service name="s9103Init" routerKey="region" 
				routerValue="<%=regionCode%>"  retcode="retCodeInit" retmsg="retMsgInit" outnum="13">
			<wtc:param value="0"/>
			<wtc:param value="01"/>
			<wtc:param value="2029"/>
			<wtc:param value="<%=workNo%>"/>
			<wtc:param value="<%=password%>"/>
			<wtc:param value=""/>
			<wtc:param value=""/>
			<wtc:param value="<%=in_ChanceId%>"/>
			<wtc:param value="<%=regionCode%>"/>
		</wtc:service>
		<wtc:array id="result1" start="0" length="1" scope="end"/>
		<wtc:array id="result2" start="1" length="1" scope="end"/>
		<wtc:array id="result3" start="2" length="1" scope="end"/>
		<wtc:array id="result4" start="3" length="4" scope="end"/>
		<wtc:array id="result5" start="7" length="3" scope="end"/>
		<wtc:array id="result6" start="10" length="3" scope="end"/>
		<%
		if (!"000000".equals(retCodeInit)) {
			%>
			<script>
				rdShowMessageDialog("s9103Init��ʼ��ʧ�ܣ�<%=retCodeInit%>��<%=retMsgInit%>", 0);
				removeCurrentTab();
			</script>
			<%
			return;
		}
		if (result1.length >0) {
			Imitation_retInfo = result1[0][0];
		}
		if (result2.length >0) {
			busi_req_type = result2[0][0];
		}
		if (result3.length >0) {
			poorder_type = result3[0][0];
		}
		if (result4.length >0) {
			inEcId = result4[0][0];
			in_pospec_number = result4[0][1];
			in_productspec_name = result4[0][2];
			in_productspec_number = result4[0][3];
		}
		result9103_5 = result5;
		result9103_6 = result6;
		
		System.out.println("====wanghfa==== in_ChanceId = " + in_ChanceId);
		System.out.println("====wanghfa==== Imitation_retInfo = " + Imitation_retInfo);
		System.out.println("====wanghfa==== busi_req_type = " + busi_req_type);
		System.out.println("====wanghfa==== poorder_type = " + poorder_type);
		System.out.println("====wanghfa==== inEcId = " + inEcId);
		System.out.println("====wanghfa==== in_pospec_number = " + in_pospec_number);
		System.out.println("====wanghfa==== in_productspec_name = " + in_productspec_name);
		System.out.println("====wanghfa==== in_productspec_number = " + in_productspec_number);
	}
  
  String[][] favInfo =(String[][])session.getAttribute("favInfo");
	System.out.println("@:***favInfo:["+favInfo+"]");
	System.out.println("@:***favInfo.length:["+favInfo.length+"]");
  String[] favStr= new String[favInfo.length];
	System.out.println("@:***favStr:["+favStr+"]");
  for (int i = 0;i < favStr.length;i++)
        favStr[i] = favInfo[i][0].trim();
  for(int aa=0 ;aa<favStr.length;aa++ ){
  	//System.out.println("@:***favStr["+aa+"]:["+favStr[aa]+"]");
  }
	//System.out.println("@:***["+WtcUtil.haveStr(favStr,"b549")+"]");
	
%>
<%
	String printAccept="";
%>
	<wtc:sequence name="TlsPubSelCrm" key="sMaxSysAccept" routerKey="region" 
		 routerValue="<%=regionCode%>"  id="seq"/>
<%
		printAccept = seq;
%>
<HTML>
<HEAD>
<link href="s2002.css" rel="stylesheet" type="text/css">		
	<script type="text/javascript" src="/njs/extend/jquery/portalet/interface_pack.js"></script>
</HEAD>
<BODY>
<FORM name="form1" method="post">
<%@ include file="/npage/include/header.jsp" %>
<div class="title"><div id="title_zi">��Ʒ������Ϣ</div></div>
<table cellSpacing=0>
  <tr>
    <td class="blue" width="15%">
    ��������
    </td>
    <td colspan="3" >
      <span id="close_p_OperType" ><select align="left" name="p_OperType" id=p_OperType width=50>
      <option value="1">��ѯ</option>
      <option value="0">����</option>
      <option value="2">ȡ��</option>
      <option value="3">��ͨ</option>
      <option value="4">�޸�</option>
      <%if(!"".equals(in_ChanceId)){%>
      <option value="5">Ԥ����</option>
      <option value="6">����</option>
      <option value="7">Ԥ����ת����</option>
      <%}else if(WtcUtil.haveStr(favStr,"a334")){%>
      <option value="6">����</option>
      <%}%>
      <%if(WtcUtil.haveStr(favStr,"a335")){%>
      <option value="8">����</option>
      <%}%>
    </select></span>
    </td>
  </tr>
  <tr>
    <td class="blue" width="15%">
    ������Դ
    </td>
    <td width="35%">
    <span id='span_OrderSourceID'>
      <select align="left" name="p_OrderSourceID" id=p_OrderSourceID width=50>
      <option value="">------������------</option>
      <option value="0">ʡBOSS�ϴ�</option>
      <option value="1">EC�ϴ�</option>
      <option value="2">BBOSS����</option>
      </select>
     </span>
    </td>
    <td class="blue" width="15%">
    EC���ſͻ�����
    </td>
    <td width="35%">
      <input name="p_CustomerNumber" id="p_CustomerNumber" v_type="0_9"  v_must="1" size="30" maxlength="30">
      <input name="CustomerNumberCheckDiv" type="button" class="b_text" onclick="checkCustomerNumber()" id="CustomerNumberCheckDiv" value="Ч��">
      <input name="CustomerNumberQueryDiv" type="button" class="b_text" onclick="getOrderInfo()" id="CustomerNumberQueryDiv" value="��ѯ">
    </td>
  </tr>
  <tr>
    <td class="blue">
    ��Ʒ������
    </td>
    <td>
      <input name="p_POOrderNumber" id="p_POOrderNumber" v_type="0_9" size="20" maxlength="16" readonly>
      <input name="POOrderNumberQueryDiv" type="button" class="b_text" onclick="getUserId()" id="POOrderNumberQueryDiv" value="���">
    </td>
    
    <td class="blue">
    ��Ʒ������ϵID
    </td>
    <td>
      <input name="p_ProductOfferingID" id="p_ProductOfferingID" v_type="string" size="20" maxlength="20" readonly>
    </td>
    
    
   </tr>
   <tr>
   	
   	<td class="blue">
    ��Ʒ�������
    </td>
    <td>
      <input name="p_PospecName" id="p_PospecName" v_type="string" size="20" maxlength="20" readonly>
    </td>
    <td  class="blue">
    ��Ʒ�����
    </td>
    <td>
      <input name="p_POSpecNumber" id="p_POSpecNumber" v_type="0_9" size="20" maxlength="9" readonly >
      <input  type="hidden" name="p_POSpecNumber1" id="p_POSpecNumber1" v_type="0_9" size="20" maxlength="9" >
      <input name="POSpecNumberQueryDiv" type="button" class="b_text" onclick="getPOSpecNumber()" id="POSpecNumberQueryDiv" value="��ѯ">
    </td>
    
  </tr>
  
  <tr>
  	
  	<td class="blue">
  	��Ʒ�ʷ�����
  	</td>
  	<td>
  		<input maxlength="20" name="product_name" id="product_name" readonly>
  	</td>
  	<td class="blue">
  	��Ʒ�ʷѱ��
  	</td>
  	<td>
  		<input maxlength="20" name="product_code" id="product_code" readonly>
  		<input type="hidden" name="product_code1" id="product_code1" readonly>
  		<input name="getProductCode" type="button" class="b_text" onclick="getInfo_Prod2()" id="getProductCode" value="��ѯ">
  	</td>
  </tr>
   <tr>
   	<td class="blue">
    ����ʡ
    </td>
    <td>
     <span id="span_p_HostCompany">
      <select name="p_HostCompany" id=p_HostCompany>
       <option value="">------������------</option><!--20090203 wuxy alter -->
       <!--<option value="451">������</option>--><!--20100505 wuxy alter -->
       <%sqlStr ="select detail_code, detail_name from sbbossListCode where list_code = 'CompanyID' order by detail_order ";%>
			 <wtc:qoption name="sPubSelect" outnum="2">
			 <wtc:sql><%=sqlStr%></wtc:sql>
			 </wtc:qoption>
      </select></span>
    </td>
    <td class="blue">
    �ײ���Ч����
    </td>
    <td>
      <select name="p_PORatePolicyEffRule" id=p_PORatePolicyEffRule>
       <option value="">------������------</option>
       <%sqlStr ="select detail_code, detail_name from sbbossListCode where list_code = 'PORatePolicyER' order by detail_order ";%>
			 <wtc:qoption name="sPubSelect" outnum="2">
			 <wtc:sql><%=sqlStr%></wtc:sql>
			 </wtc:qoption>
      </select>
    </td>
    
  </tr>
   <tr>
   	<td class="blue">
    ����״̬
    </td>
    <td><!--wuxy add value=5 20091211-->
      <select name="p_Status" id=p_Status>
       <option value="">------������------</option>
       <option value="1">������Ʒ����</option>
       <option value="2">ȡ����Ʒ����</option>
       <option value="3">��Ʒ��ͣ</option>
       <option value="4">��Ʒ�ָ�</option>
       <option value="5">��ƷԤ��</option>
      </select>
    </td>
    <td class="blue">
    ҵ��չģʽ
    </td>
    <td>
     <span id="p_BusinessMode_span" >
     <select name="p_BusinessMode" id="p_BusinessMode">
      <option value="">------��ѡ��------</option>		
  		 <option value="5">��ʡ������ʡ֧��</option>
  		 <option value="3">����ʡһ������һ��֧��</option>
  		 <option value="4">����ʡһ��������ʡ֧��</option>
  		 <option value="1">���޹�˾һ������һ��֧��</option>
  		 <option value="2">���޹�˾һ��������ʡ֧��</option>
       <!-- <%sqlStr ="select detail_code, detail_name from sbbossListCode where list_code = 'BusinessMode' order by detail_order ";%>
			 <wtc:qoption name="sPubSelect" outnum="2">
			 <wtc:sql><%=sqlStr%></wtc:sql>
			 </wtc:qoption>--><!-- wuxy alter 20090203-->
      </select></span>
    </td>
       
  </tr>
  <tr>
  	<td class="blue">
    ����������
    </td>
    <td>
      <input name="p_SICode" id="p_SICode" v_type="string" size="20" maxlength="20" readonly>
    </td>
    <td class="blue">
    �鵵״̬
    </td>
    <td>
      <input name="p_guidang" id="p_guidang" v_type="string" size="20" maxlength="20" readonly>
    </td>
  </tr>
  <input name="p_operationSubType" id="p_operationSubType" type="hidden" value="">
  <input name="flag" id="flag" type="hidden" value="0">
  <tr>
  	<td class="blue">
    ҵ���ϵȼ�
    </td>
    <td colspan='3'>
    	<select name="busNeedDegree" id="busNeedDegree" >
    		<option value="">------��ѡ��------</option>
    		<option value="1">AAA</option>
    		<option value="2">AA</option>
    		<option value="3">A</option>
    		<option value="4">��ͨ��</option>
    	</select>
    </td>
  </tr>
  <tr>
  	<td class="blue">
    ��ע
    </td>
    <td colspan='3'>
    	<textArea name="notes" id="notes" maxlength="1000" v_type="string" v_maxlength="1000" cols="60" rows="3"></textArea>
    </td>
  </tr>
  <tbody id="feeInfo" style="display:none;">
</table>
<br>

<div name="poAttachmentDiv" id="poAttachmentDiv">
	<div class="title">
		<div id="zi">
			<img id="poAttachment_switch" state="close" src="../../../nresources/default/images/jia.gif" style='cursor:hand' width="15" height="15">
			������Ϣ(������������д��Ϣ)
		</div>
	</div>
	<div style=" overflow:auto;">
	<div name="poAttachmentMsg" id="poAttachmentMsg" style="display:none">
		
		<table>
			<tr>
				<th width="20%">��������</th>
				<th width="20%">��ͬ����</th>
				<th width="30%">��ͬ����</th>
				<th width="20%">��ظ���</th>
				
				
				<th width="30%">��ͬ��ʼ����</th>
				<th width="30%">��ͬ��������</th>
				<th width="30%">�Ƿ��Զ���Լ</th>
				<th width="30%">��Լ����ʱ��</th>
				<th width="30%">ǩԼ�ʷ�</th>
				<th width="30%">�Żݷ���</th>
				<th width="30%">�Զ���Լ����</th>
				<th width="30%">�Ƿ�Ϊ��ǩ��ͬ</th>
				
				<th width="10%">����</th>
			</tr>
		</table>
		<table>
			<tr>
				<th colspan="13" align="center">
					<input type='button' class='b_text' name='addPoAttachmentRowBtn' id='addPoAttachmentRowBtn' value='����' onclick="addRow('poAttachmentMsg')" <%=disabledStr%>/>
				</th>
			</tr>
		</table>
	</div>	
	</div>
</div>


<div id="divold">
<br>
<div class="title"><div id="title_zi">��Ʒ��ҵ�����</div></div>

<table cellSpacing=0>
	
  <tr>
      
    <td class="blue" width="25%">
    	<input type="radio" name="OperationSubTypeIDRadio" value="3" onclick="doClickRadio(this)">
      ��Ʒ��ͣ
    </td class="blue">
    <td class="blue" width="25%">
    	<input type="radio" name="OperationSubTypeIDRadio" value="4" onclick="doClickRadio(this)">
      ��Ʒ�ָ�
    </td class="blue">
    <td class="blue" width="25%">
    	<input type="radio" name="OperationSubTypeIDRadio" value="5" onclick="doClickRadio(this)">
      �޸���Ʒ�ʷ�
    </td class="blue">
    <td class="blue" width="25%">
    	<input id="dis" type="radio" name="OperationSubTypeIDRadio" value="2" onclick="doClickRadio(this)">
      <font id="dis">ȡ����Ʒ����</font>
    </td class="blue">
  </tr>
  <tr>
    <td class="blue" width="25%">
    	<input type="radio" name="OperationSubTypeIDRadio" value="9" onclick="doClickRadio(this)">
      �޸Ķ�����Ʒ����
    </td class="blue">
    <td class="blue" width="25%">
    	<input type="radio" name="OperationSubTypeIDRadio" value="7" onclick="doClickRadio(this)">
      �޸Ķ�����Ʒ��ɹ�ϵ
    </td class="blue">
    <td class="blue" width="25%">
    	<input id="dis" type="radio" name="OperationSubTypeIDRadio" value="8" onclick="doClickRadio(this)">
      <font id="dis">�޸Ľɷѹ�ϵ(����)</font>
    </td class="blue">
    <td class="blue" width="25%">
    	<input id="dis" type="radio" name="OperationSubTypeIDRadio" value="6" onclick="doClickRadio(this)">
      <font id="dis">�����Ա</font>
    </td class="blue">
  </tr>
   <tr>
    <td class="blue" width="25%">
    	<span id='preDeal'>
    	<input type="radio" name="OperationSubTypeIDRadio" value="1" onclick="doClickRadio(this)">
      <span id='preDeal0'>Ԥ����</span><span id='preDeal1' style='display:none' >������Ʒ����</span></span>&nbsp;
    </td class="blue">
    <td class="blue" width="25%">
    	<span id='preDeal13'>
	    	<input type="radio" name="OperationSubTypeIDRadio" value="13" onclick="doClickRadio(this)">
	      ҵ��չʡ������ɾ��
    	</span>
    </td>
    <td class="blue" width="25%">
    	
    	<input   type="radio" name="OperationSubTypeIDRadio" value="21" onclick="doClickRadio(this)">
      ��ͬ���
    
    </td>
    <td class="blue" width="25%">
    	&nbsp;
    </td>
   </tr>
  <input type="hidden" id="OperationTypeID" value="">
</table>

  </div>
  <div id="shangpin">
  	  	<br>
		<div class="title" id="shangpincaozuo"><div id="title_zi">��Ʒ��ҵ�����</div></div>
		<table cellSpacing=0>
		  <tr id="yuxiao1">
		    <td class="blue" width="25%">
		    	<input type="radio" name="OperationSubTypeIDRadio" value="A" onclick="doClickRadio(this)">
		      ��ƷԤ��
		    </td class="blue">
		    <td class="blue" width="25%">
		    	<input type="radio" name="OperationSubTypeIDRadio" value="2" onclick="doClickRadio(this)">
		      ��Ʒȡ��
		      <input type="radio" name="OperationSubTypeIDRadio" value="no" onclick="doClickRadio(this)" checked style="display:none">
		    </td class="blue">
		  </tr>
		  <!-- yuanqs add 100819 �����·��ƶ�400ҵ���Ż�ҵ��֧��ϵͳʵʩ������֪ͨ begin -->
		  <tr id="yuxiao">
		    <td class="blue" width="25%">
		    	<input type="radio" name="OperationSubTypeIDRadio" value="10" onclick="doClickRadio(this)">
		      Ԥȡ����Ʒ����
		    </td class="blue">
		    <td class="blue" width="25%">
		    	<input type="radio" name="OperationSubTypeIDRadio" value="11" onclick="doClickRadio(this)">
		      �䶳�ڻָ���Ʒ����
		    </td class="blue">
		  </tr>
		  <tr><td colspan='2'></td></tr>
		  <!-- yuanqs add 100819 �����·��ƶ�400ҵ���Ż�ҵ��֧��ϵͳʵʩ������֪ͨ end -->
		</table>
  </div>

<div>
	<br/>
	<div class="title">
		<div id="zi">
			<img id="poAudit_switch" state="close" src="../../../nresources/default/images/jia.gif" style='cursor:hand' width="15" height="15">
			ҵ��������Ϣ�б�
		</div>
	</div>
	<div name="poAuditMsg" id="poAuditMsg" style="display:none">
		<table>
			<tr>
				<th width="20%">����������</th>
				<th width="30%">����ʱ��(��ʽ��YYYYMMDDhhmiss)</th>
				<th width="40%">�������</th>
				<th width="10%">����</th>
			</tr>
		</table>
		<table>
			<tr>
				<th colspan="4" align="center">
					<input type='button' class='b_text' name='addPoAuditRowBtn' id='addPoAuditRowBtn' value='����' onclick="addRow('poAuditMsg')" <%=disabledStr%>/>
				</th>
			</tr>
		</table>
	</div>
	<br/>
	<div class="title">
		<div id="zi">
			<img id="contactorInfo_switch" state="close" src="../../../nresources/default/images/jia.gif" style='cursor:hand' width="15" height="15">
			��Ʒ��������ϵ����Ϣ
		</div>
	</div>
	<div name="contactorInfoMsg" id="contactorInfoMsg" style="display:none">
		<table>
			<tr>
				<th width="30%">��ϵ������</th>
				<th width="30%">��ϵ������</th>
				<th width="30%">��ϵ�˵绰</th>
				<th width="10%">����</th>
			</tr>
		</table>
		<table>
			<tr>
				<th colspan="4" align="center">
					<input type='button' class='b_text' name='addContactorInfoRowBtn' id='addContactorInfoRowBtn' value='����' onclick="addRow('contactorInfoMsg')" <%=disabledStr%>/>
				</th>
			</tr>
		</table>
	</div>
</div>
<br>

<DIV id="div1_show"   class="groupItem">
   <DIV class="title">
	    <DIV id="zi"><img id="div1_switch" class="closeEl" src="../../../nresources/default/images/jia.gif" style='cursor:hand' width="15" height="15"></DIV>
   	  <DIV id="zi0">�ײ��б�</DIV>
   </DIV>
   <DIV class="itemContent" id="mydiv1">
	 	  <DIV id="wait1"><img src="/nresources/default/images/protalloading.gif"  width="150" height="30">
	 	  </DIV>
   </DIV>
</DIV>
<DIV id="div2_show"   class="groupItem">
   <DIV class="title">
	    <DIV id="zi"><img id="div2_switch" class="closeEl" src="../../../nresources/default/images/jia.gif" style='cursor:hand' width="15" height="15"></DIV>
   	  <DIV id="zi0">��Ʒ�����б�</DIV>
   </DIV>
   <DIV class="itemContent" id="mydiv2">
	 	  <DIV id="wait2"><img src="/nresources/default/images/protalloading.gif"  width="150" height="30">
	 	  </DIV>
   </DIV>
</DIV>	
<table>
  <tr>
    <td align="center" id="footer" colspan="2">
      <input class="b_foot" name=next id=nextoper type=button value="ȷ��">
      <input class="b_foot" name=butClose type=button value="�ر�" onClick="parent.removeTab('<%=opCode%>');">
      <input  class="b_foot" type=reset name=butReset onClick="location.reload();" value="����">
    </td>
  </tr>
</table>
<input type="hidden" name="hiddendate_PospecratePolicy_num"           id="hiddendate_PospecratePolicy_num"            value="0">
<input type="hidden" name="hiddendate_RatePlans_num"                  id="hiddendate_RatePlans_num"                   value="0">
<input type="hidden" name="hiddendate_POICBs_num"                     id="hiddendate_POICBs_num"                      value="0">
<input type="hidden" name="hiddendate_ProductOrder_num"               id="hiddendate_ProductOrder_num"                value="0">
<input type="hidden" name="hiddendate_ProductOrderRatePlan_num"       id="hiddendate_ProductOrderRatePlan_num"        value="0">
<input type="hidden" name="hiddendate_ProductOrderPOICB_num"          id="hiddendate_ProductOrderPOICB_num"           value="0">
<input type="hidden" name="hiddendate_ProductCodePOICB_num"           id="hiddendate_ProductCodePOICB_num"            value="0">
<input type="hidden" name="hiddendate_PayCompany_num"                 id="hiddendate_PayCompany_num"                  value="0">
<input type="hidden" name="hiddendate_ProductOrderChara_num"          id="hiddendate_ProductOrderChara_num"           value="0">
<input type="hidden" name="hiddendate_PospecratePolicy_num_delete"    id="hiddendate_PospecratePolicy_num_delete"     value="0">
<input type="hidden" name="hiddendate_RatePlans_num_delete"           id="hiddendate_RatePlans_num_delete"            value="0">
<input type="hidden" name="hiddendate_POICBs_num_delete"              id="hiddendate_POICBs_num_delete"               value="0">
<input type="hidden" name="hiddendate_ProductOrder_num_delete"        id="hiddendate_ProductOrder_num_delete"         value="0">
<input type="hidden" name="hiddendate_ProductOrderRatePlan_num_delete"id="hiddendate_ProductOrderRatePlan_num_delete" value="0">
<input type="hidden" name="hiddendate_ProductOrderPOICB_num_delete"   id="hiddendate_ProductOrderPOICB_num_delete"    value="0">
<input type="hidden" name="hiddendate_PayCompany_num_delete"          id="hiddendate_PayCompany_num_delete"           value="0">
<input type="hidden" name="hiddendate_ProductOrderChara_num_delete"   id="hiddendate_ProductOrderChara_num_delete"    value="0">
<input type='hidden' id='sm_code' name='sm_code' value='<%=sm_code%>' />
<input type='hidden' id='biz_type_L' name='biz_type_L' value='' />
<input type='hidden' id='biz_type_S' name='biz_type_S' value='' />
<input type="hidden" id=p_OrderSourceID1 value="">
<input type="hidden" id=p_HostCompany1 value="">
<input type="hidden" id=p_BusinessMode1 value="">
<input type="hidden" id=p_Status1 value="">
<input type="hidden" id=p_PORatePolicyEffRule1 value="">
<input type='hidden' id='op_code' name='op_code' value='<%=opCode%>' />
<input type='hidden' id='op_name' name='op_name' value='<%=opName%>' />
<input type="hidden" id="data_consult" name="data_consult" value="" />
<input type="hidden" id="PoOprFlag" name="PoOprFlag" value="" /><!-- wuxy add 20100203 -->
<input type="hidden" id="PoOprType" name="PoOprType" value="" /><!-- wuxy add 20100203 -->
<input type="hidden" name="hiddendate_ProductOrderManagerChar_num"   id="hiddendate_ProductOrderManagerChar_num"    value="0">
<input type="hidden" name="hiddendate_ProductOrderExamine_num"   id="hiddendate_ProductOrderExamine_num"    value="0">
<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe><!--wangzn 2010-3-22 15:30:48-->
<input type="hidden" id="in_ChanceId" name="in_ChanceId" value="<%=in_ChanceId%>"/><!--wangzn 2010-5-12 14:35:34-->
<input type="hidden" id="WaNo" name="WaNo" value="<%=WaNo%>"/>
<input type='hidden' id='fee_list' name='fee_list' value='' />
<input type='hidden' id='busi_req_type' name='busi_req_type' value='<%=busi_req_type%>' />
<input type="hidden" id="unitName" />
<input type="hidden" id="custId" />
<input type="hidden" id="acconId" />
<input type="hidden" id="printFlag" />
<input type="hidden" id="printAccept" name="printAccept" value="<%=printAccept%>" />


<DIV id="hiddendate_new">
</DIV>
<DIV id="hiddendate_delete">
</DIV>
</DIV>	
</DIV>
<%@ include file="/npage/include/footer.jsp" %>
</FORM>

</BODY>
</HTML>
<script type="text/javascript">
function testWangzn(){
	
	
	$("#p_BusinessMode_span").mousemove( function() {
  		this.setCapture();
  });
  $("#p_BusinessMode_span").mouseout( function() {
  		this.releaseCapture();
  });
	
}
	
	

var nextFalg="0";
function nextoper()
{
	var confirmFlag=0;
	confirmFlag = rdShowConfirmDialog("�Ƿ��ύ���β�����");
	if(confirmFlag!=1){
		return;	
	}
	
	//2012/2/7	wanghfa����
	if (document.getElementsByName("auditor").length == 0) {	//$("#p_OperType").val() == "0" && document.getElementsByName("auditor").length == 0
		rdShowMessageDialog("������дһ��ҵ��������Ϣ��", 1);
		return;
	}
	if ($("#p_OperType").val() != "1") {	//$("#p_OperType").val() == "0" || $("#p_OperType").val() == "5"
		for (var a = 0;a < document.getElementsByName("auditor").length;a ++) {
			if (!checkElement(document.getElementsByName("auditor")[a])) {
				return;
			} else if (!checkElement(document.getElementsByName("auditTime")[a])) {
				return;
			} else if (!checkElement(document.getElementsByName("custName")[a])) {
				return;
			}
		}
		
		var has2Bool = false;
		var has5Bool = false;
		for (var a = 0;a < document.getElementsByName("contactorType").length;a ++) {
			if (document.getElementsByName("contactorType")[a].value == "2") {
				has2Bool = true;
			} else if (document.getElementsByName("contactorType")[a].value == "5") {
				has5Bool = true;
			}
			if (!checkElement(document.getElementsByName("contactorType")[a])) {
				return;
			} else if (!checkElement(document.getElementsByName("contactorName")[a])) {
				return;
			} else if (!checkElement(document.getElementsByName("contactorPhone")[a])) {
				return;
			}
		}
		if (!(has2Bool == true && has5Bool == true)) {
			rdShowMessageDialog("��Ʒ������ϵ����Ϣ�б�����ϵ������Ϊ���ͻ��������͡������ύ�ˡ�����Ϣ������д��", 1);
			return;
		}
		
		for (var a = 0;a < document.getElementsByName("poAttType").length;a ++) {
			if (!checkElement(document.getElementsByName("poAttType")[a])) {
				return;
			} else if (document.getElementsByName("poAttType")[a].value == "1" && document.getElementsByName("poAttCode")[a].value.trim().length == 0) {
				rdShowMessageDialog("��ͬ�����ĺ�ͬ���������д��", 1);
				return;
			} else if (!checkElement(document.getElementsByName("poAttCode")[a])) {
				return;
				} else if (typeof document.getElementsByName("poAttNameLocalFile")[a] != "undefined") {
					if (document.getElementsByName("poAttNameLocalFile")[a].value == "") {
						rdShowMessageDialog("��ͬ���Ϊ" + document.getElementsByName("poAttCode")[a].value + "�ĸ���û���ϴ���", 1);
				return;
				}
			}
			
			//ѡ���Ǹ�������Ϊ��ͬ����
			if(document.getElementsByName("poAttType")[a].value=="1"){
					if (document.getElementsByName("ContEffdate")[a].value.trim()==""){
							rdShowMessageDialog("��ͬ��ʼ���ڱ�����д��", 1);
							return;
					}
					if (!checkElement(document.getElementsByName("ContEffdate")[a])){
						return;
					}
					
					if (document.getElementsByName("ContExpdate")[a].value.trim()==""){
							rdShowMessageDialog("��ͬ�������ڱ�����д��", 1);
							return;
					}
					if (!checkElement(document.getElementsByName("ContExpdate")[a])){
						return;
					}
					
					if (document.getElementsByName("IsAutoRecont")[a].value.trim()==""){
							rdShowMessageDialog("�Ƿ��Զ���Լ������д��", 1);
							return;
					}
					
					if (document.getElementsByName("IsAutoRecont")[a].value==""){
							rdShowMessageDialog("�Ƿ��Զ���Լ������д��", 1);
							return;
					}
					
					if (document.getElementsByName("IsAutoRecont")[a].value=="1"){
							if (document.getElementsByName("RecontExpdate")[a].value.trim()==""){
									rdShowMessageDialog("��Լ����ʱ�������д��", 1);
									return;
							}
					}
					
					if (document.getElementsByName("ContFee")[a].value.trim()==""){
							rdShowMessageDialog("ǩԼ�ʷѱ�����д��", 1);
							return;
					}
					
					if (document.getElementsByName("PerferPlan")[a].value.trim()==""){
							rdShowMessageDialog("�Żݷ���������д��", 1);
							return;
					}
					
					if (document.getElementsByName("AutoRecontCyc")[a].value==""){
							rdShowMessageDialog("�Զ���Լ���ڱ�����д��", 1);
							return;
					}
					
					if (document.getElementsByName("IsRecont")[a].value==""){
							rdShowMessageDialog("�Ƿ�Ϊ��ǩ��ͬ������д��", 1);
							return;
					}
					
					
			}
		}
		
		if (!checkElement(document.getElementById("notes"))) {
			rdShowMessageDialog("��������д��ע��", 1);
			return;
		}
		
		var has1Bool = false;
		if ($("#p_OperType").val() != "5" && $("#p_OperType").val() != "6" && $("input[@name='OperationSubTypeIDRadio']:checked").val() == "1") {
			for (var a = 0;a < document.getElementsByName("poAttType").length;a ++) {
				if (document.getElementsByName("poAttType")[a].value == "1") {
					has1Bool = true;
				}
			}
			if (!has1Bool) {
				rdShowMessageDialog("����Ҫ����һ����ͬ������", 1);
				return;
			}
		}
	}

    
	var PoOprFlag=document.all.PoOprFlag.value;
    if($("#p_OperType").val() == '2' || $("#p_OperType").val() == '4'||$("#p_OperType").val() == '6'||$("#p_OperType").val() == '7'||$("#p_OperType").val() == '5' ){
        var chkFlag = "N";
        $("input[@name='DeleteCheckBox']").each(function()
        {
        	if($(this).attr("checked") && $(this).attr("listFlag") == "N"){
        		rdShowMessageDialog("������Ʒ�����Ų鿴��Ʒ������Ϣ��",0);
                chkFlag = "Y";
                return false;
        	}
        });
        
        if(chkFlag == "Y"){
            return false;
        }
        
        if($("#p_OperType").val() == '4'){
        	var selectNo = 0;
     			var objs = document.getElementsByName("DeleteCheckBox");
        	for (var a = 0;a < objs.length;a ++) {
        		if (objs[a].checked == true) {
        			selectNo ++;
        		}
        	}
        if (selectNo == 0) {
       		rdShowMessageDialog("��ѡ���Ʒ���ʷ�");
       	    return;		
        }
    	}	
    }
	
	if($("#p_OperType").val()=="1")
    {
    	return;
    }
    if($("#p_OperType").val()=="3")
    {
    	var checkTmp="";
    	checkTmp="B|"
    	$("#p_operationSubType").val(checkTmp);
    }
    if($("#p_OperType").val()=="8")
    {
    	var checkTmp="";
    	checkTmp="S|"
    	$("#p_operationSubType").val(checkTmp);
    }
	 //�жϲ������� 0:���� 2:�޸�
	if($("#p_OperType").val()=="2"||$("#p_OperType").val()=="6"||$("#p_OperType").val()=="7")
	{	  	 
		var checkTmp ="";
		
		$("input[@name='OperationSubTypeIDChkBox']").each(function()
		{
			if($(this).attr("checked")){        	 
				checkTmp=checkTmp+$(this).val()+"|"
			}
		});

		$("input[@name='OperationSubTypeIDRadio']").each(function()
		{
			if($(this).attr("checked")){        	 
				 checkTmp=checkTmp+$(this).val()+"|"
			}
		});
       
       
       //alert("��Ʒ������:"+checkTmp);
       if(checkTmp==""){
       	rdShowMessageDialog("��ѡ����Ʒ��ҵ�����!");
       	return;	
       }
       $("#p_operationSubType").val(checkTmp);
       if($("#p_CustomerNumber").val()==""){
       		rdShowMessageDialog("EC���ſͻ����벻��Ϊ��");
       	     return;
        }
        if($("#p_HostCompany").val()==""){
        	rdShowMessageDialog("����ʡ���벻��Ϊ��");
       	     return;
        }
        if(($("#p_BusinessMode").val()=="")||($("#p_BusinessMode").val()==null)){
        	rdShowMessageDialog("ҵ��չģʽ����Ϊ��");
       	     return;
        }
        if($("#p_OperType").val() != "5" && ($("#p_PORatePolicyEffRule").val()=="")||($("#p_PORatePolicyEffRule").val()==null)){
        	rdShowMessageDialog("�ײ���Ч������Ϊ��");
       	     return;
        }
        if($("#p_POOrderNumber").val()==""){
       		rdShowMessageDialog("��Ʒ�����Ų���Ϊ��");
       	     return;
        }
        if($("#p_POSpecNumber").val()==""){
        	rdShowMessageDialog("��Ʒ����Ų���Ϊ��");
       	     return;
        }
        document.all.p_POSpecNumber1.value=$("#p_POSpecNumber").val();
        //�ж��Ƿ�ѡ��
        var check_flag="0";
        
        //alert(document.all.PoOprFlag.value);
        // add by lusc 
        if (typeof document.all.attached == "undefined") {
        	rdShowMessageDialog("��չ����Ʒ�����б�", 1);
        	return;
        }
        var mainPro=document.all.attached.value.split("|");
        var checkedPros="";
        //alert("�ش���ֵ:"+document.all.attached.value);
        //alert("����Ʒ���:"+mainPro[mainPro.length-1]);
        
	   $("input[@name='DeleteCheckBox']").each(function()
	   {
	   		if($(this).attr("checked")){
	   			check_flag="1";
	   			/////add by lusc  2009-4-15
	   			//alert($(this).attr("value"));
	   			checkedPros=checkedPros+$(this).attr("value")+"|";
	   		}
	   });
	   //alert(checkedPros);
	   if(checkedPros.match(mainPro[mainPro.length-1])!=null){
	   		$("input[@name='DeleteCheckBox']").each(function()
	  	 {
	   		if($(this).attr("checked")){
	   			}else{
	   				if(document.all.attached.value.match($(this).attr("value"))!=null){
	   					check_flag="2";
	   				}
	   			}			
	  	 	});
	  	}
	  	//alert("flage:"+check_flag);
	   if(check_flag=="0"){
	   	    if(PoOprFlag!="1")
	   	    {
	   			rdShowMessageDialog("��ѡ��Ҫ�����Ĳ�Ʒ!");
	   			return false;
	   		}
	   	}
	   	///add by lusc 2009-4-13
	   	/*
	   	if(check_flag=="2"){
	   		rdShowMessageDialog("����Ʒѡ��,������Ʒ����ѡ��!!");
	   		var chkbox=document.getElementById("DeleteCheckBox");
				var trchk= chkbox.parentNode.parentNode;
				var ta=trchk.parentNode;
				for(var j=0;j<ta.rows.length-1;j++){
						if(document.all.attached.value.match(ta.rows[j].cells[3].innerHTML.trim())!=null){
							ta.rows[j].cells[0].firstChild.checked=true;
						}
			  }
	   		return false;
	   	}
	   	*/
     var Product_flag=$(".ProductOrder_contenttr").attr("a_OperationSubTypeID");
        if(typeof(Product_flag)=="undefined"){
        	
        	rdShowMessageDialog("���ѡ��Ĳ�Ʒ����Ԥ����ȡ����ѡ��������");
       	    return;
        }
    }
    
    if($("#p_OperType").val()=="0"){  
       if($("#flag").val()=="0"){
       	rdShowMessageDialog("��У��EC���ſͻ�����");
       	     return;	     
    }
    if($("#p_HostCompany").val()==""){
        	rdShowMessageDialog("����ʡ���벻��Ϊ��");
       	     return;
        }
        if(($("#p_BusinessMode").val()=="")||($("#p_BusinessMode").val()==null)){
        	rdShowMessageDialog("ҵ��չģʽ����Ϊ��");
       	     return;
        }
        if($("#p_OperType").val() != "5" && ($("#p_PORatePolicyEffRule").val()=="")||($("#p_PORatePolicyEffRule").val()==null)){
        	rdShowMessageDialog("�ײ���Ч������Ϊ��");
       	     return;
        }
        if($("#p_POOrderNumber").val()==""){
       		rdShowMessageDialog("��Ʒ�����Ų���Ϊ��");
       	     return;
        }
        if($("#p_POSpecNumber").val()==""){
        	rdShowMessageDialog("��Ʒ����Ų���Ϊ��");
       	     return;
        }
       $("#p_operationSubType").val("1|");
       
       //wuxy add 20110523
       if(resultLen >0){
       		var fieldCodeList = "";
        	var fieldValueList = "";
        	for(var ii=0;ii<resultLen;ii++){
            if($("#F"+fieldCodeArr[ii]).val() == ""){
                if(ctrlInfoArr[ii] == "N"){
                    rdShowMessageDialog(fieldNameArr[ii]+"����Ϊ��!",0);
                    $("#F"+fieldCodeArr[ii]).focus();
                    return false;
                }
            }else{
              if(fieldTypeArr[ii] == "13"){ // ���
                  if(!forMoney(document.getElementById("F"+fieldCodeArr[ii]))){
                      return false;
                  }
              }else{
                  
              }
              if (fieldCodeArr[ii] == "10354") {
              	if (!checkElement(document.getElementById("F"+fieldCodeArr[ii]))) {
              		rdShowMessageDialog(fieldNameArr[ii]+"����Ϊ�����������������Ϊ7λ��С�����Ϊ2λ��", 0);
              		return false;
              	} else if (document.getElementById("F"+fieldCodeArr[ii]).value.substr(0, document.getElementById("F"+fieldCodeArr[ii]).value.indexOf(".")).length >7) {
              		rdShowMessageDialog(fieldNameArr[ii]+"����Ϊ�����������������Ϊ7λ��С�����Ϊ2λ��", 0);
              		return false;
              	}
              }
            }
            
            fieldCodeList += fieldCodeArr[ii] + "~";
            fieldValueList += $("#F"+fieldCodeArr[ii]).val() + "~";
        	}
        	$("#fee_list").val(fieldCodeList + "|" + fieldValueList +"|");
        	/* fee_list ��ʽʾ��:" code1~code2~code3~|value1~value2~value3~| " */
       }
       
       
    }
    //add by lusc 2009-04-10
    /*
    if($("#p_OperType").val()=="4"){
    	alert($("#p_operationSubType").val());
    	rdShowMessageDialog("��Ʒ���������Ʒ��������ͻ");
    	return ;
    }  
    */        	
	  //��Ʒ�ײ�-----------------------------------------------
	  $.each($(".pospecratepolicy_contenttr"), function(i){
	  		
  		  var ii  = $("DIV.PospecratePolicy","#hiddendate_new").size();
  	    var newdate=
        "<DIV class='PospecratePolicy' style='display:none'>" +
        "<input type='hidden' name='tableid_POS"+ii+"'              value='1'>"                                       +                                             
        "<input type='hidden' name='a_POSpecRatePolicyID_POS"+ii+"' value='"+$(this).attr("a_POSpecRatePolicyID")     +"'>"+
        "<input type='hidden' name='a_Name_POS"+ii+"'               value='"+$(this).attr("a_Name")                   +"'>"+              
        "<input type='hidden' name='a_POOrderNumber_POS"+ii+"'      value='"+$(this).attr("a_POOrderNumber")          +"'>"+     
        "<input type='hidden' name='a_POSpecNumber_POS"+ii+"'       value='"+$(this).attr("a_POSpecNumber")           +"'>"+        
        "<input type='hidden' name='a_RatePlansListCheck_POS"+ii+"' value='"+$(this).attr("a_RatePlansListCheck")     +"'>"+
        "<input type='hidden' name='a_AcceptID_POS"+ii+"'           value='"+$(this).attr("a_AcceptID")               +"'>"+          
        "</DIV>";
        $("#hiddendate_new").append(newdate);
        //��Ʒ�ʷѼƻ�-----------------------------------------------
        var POSpecRatePolicy_4 = $(this).data("a_RatePlansList");
        if(POSpecRatePolicy_4){      		 
      		 $.each(POSpecRatePolicy_4, function(iii)
      		 {      
      		 		 	
      		 	 var i4  = $("DIV.RatePlans","#hiddendate_new").size();
    	       var newedatei=
    	       "<DIV class='RatePlans' style='display:none'>"+
    	       "<input type='hidden' name='tableid_POSRP"+i4+"'              value='2'>"+    	       
    	       "<input type='hidden' name='a_RatePlanID_POSRP"+i4+"'         value='"+POSpecRatePolicy_4[iii][0]+"'>" + //0
    	       "<input type='hidden' name='a_Description_POSRP"+i4+"'        value='"+POSpecRatePolicy_4[iii][1]+"'>" + //1
    	       "<input type='hidden' name='a_POOrderNumber_POSRP"+i4+"'      value='"+POSpecRatePolicy_4[iii][2]+"'>" + //2
    	       "<input type='hidden' name='a_POSpecNumber_POSRP"+i4+"'       value='"+POSpecRatePolicy_4[iii][3]+"'>" + //3
    	       "<input type='hidden' name='a_POSpecRatePolicyID_POSRP"+i4+"' value='"+POSpecRatePolicy_4[iii][4]+"'>" + //4   	       
    	       "<input type='hidden' name='a_OperType_POSRP"+i4+"'           value='"+POSpecRatePolicy_4[iii][5]+"'>" + //5
    	       "<input type='hidden' name='a_POICBListCheck_POSRP"+i4+"'     value='"+POSpecRatePolicy_4[iii][8]+"'>" + //8    	       
    	       "<input type='hidden' name='a_ParAcceptID_POSRP"+i4+"'        value='"+POSpecRatePolicy_4[iii][9]+"'>" + //9
    	       "<input type='hidden' name='a_AcceptID_POSRP"+i4+"'           value='"+POSpecRatePolicy_4[iii][10]+"'>"+ //10    	        
             "</DIV>";
             $("#hiddendate_new").append(newedatei);
             //��Ʒ�ʷ�POICB--------------------------------------------------------------
             var RatePlan_6=POSpecRatePolicy_4[iii][6];
             if(RatePlan_6){
      		       $.each(RatePlan_6, function(i5)
      		       {  	 
  	      	      	 var i6  = $("DIV.POICBs","#hiddendate_new").size();
    	               var newedateii=
    	               "<DIV class='POICBs' style='display:none' >"+
    	               "<input type='hidden' name='tableid_POICB"+i6+"'              value='3'>"+    	       
    	               "<input type='hidden' name='a_ParameterNumber_POICB"+i6+"'    value='"+RatePlan_6[i5][0]+"'>" + //0
    	               "<input type='hidden' name='a_ParameterName_POICB"+i6+"'      value='"+RatePlan_6[i5][1]+"'>" + //1
    	               "<input type='hidden' name='a_ParameterValue_POICB"+i6+"'     value='"+RatePlan_6[i5][2]+"'>" + //2
    	               "<input type='hidden' name='a_POSpecNumber_POICB"+i6+"'       value='"+RatePlan_6[i5][3]+"'>" + //3
    	               "<input type='hidden' name='a_POOrderNumber_POICB"+i6+"'      value='"+RatePlan_6[i5][4]+"'>" + //4   	       
    	               "<input type='hidden' name='a_POSpecRatePolicyID_POICB"+i6+"' value='"+RatePlan_6[i5][5]+"'>" + //5
    	               "<input type='hidden' name='a_RatePlanID_POICB"+i6+"'         value='"+RatePlan_6[i5][6]+"'>" + //8    	       
    	               "<input type='hidden' name='a_OperType_POICB"+i6+"'           value='"+RatePlan_6[i5][7]+"'>" + //9
    	               "<input type='hidden' name='a_ParAcceptID_POICB"+i6+"'        value='"+RatePlan_6[i5][8]+"'>" + //10    	        
    	               "<input type='hidden' name='a_AcceptID_POICB"+i6+"'           value='"+RatePlan_6[i5][9]+"'>" + //10    	        
                     "</DIV>";
                     $("#hiddendate_new").append(newedateii);	  	    	  
                 });
             }
             //��Ʒ�ʷ�POICB--------------------------------------------------------------                                                                                                                                                                        
      		 });
      	}
      	//��Ʒ�ʷѼƻ�-------------------------------------------------------------------      	      		 
  	});
    //��Ʒ�ײ�----------------------------------------------------------------------------    

	  //��Ʒ����-----------------------------------------------------------------------------------
		$.each($(".ProductOrder_contenttr"), function(i) {
			var iii  = $("DIV.ProductOrder","#hiddendate_new").size();
			var a_OperationSubTypeID = $(this).attr("a_OperationSubTypeID");

			if(a_OperationSubTypeID.indexOf("9")!=-1||a_OperationSubTypeID.indexOf("10")!=-1||a_OperationSubTypeID.indexOf("A")!=-1||a_OperationSubTypeID.indexOf("5")!=-1||(a_OperationSubTypeID.indexOf("1")!=-1&&($("#p_OperType").val()=='6'||$("#p_OperType").val()=='8'))||( a_OperationSubTypeID.indexOf("2")!=-1&&$("#p_OperType").val()=='8')){
				if (document.getElementsByName("DeleteCheckBox")[i].checked) {
					//if (iii < 1) {
						var newdate=
							"<DIV class='ProductOrder' style='display:none'>" + 
							"<input type='hidden' name='tableid_PrdOrd"+iii+"'                    value='0'>"+
							"<input type='hidden' name='a_ProductOrderNumber_PrdOrd"+iii+"'             value='"+$(this).attr("a_ProductOrderNumber")             +"'>"+                                             
							"<input type='hidden' name='a_ProductID_PrdOrd"+iii+"'                      value='"+$(this).attr("a_ProductID")                      +"'>"+
							"<input type='hidden' name='a_ProductSpecNumber_PrdOrd"+iii+"'              value='"+$(this).attr("a_ProductSpecNumber")              +"'>"+              
							"<input type='hidden' name='a_AccessNumber_PrdOrd"+iii+"'                   value='"+$(this).attr("a_AccessNumber")                   +"'>"+     
							"<input type='hidden' name='a_PriAccessNumber_PrdOrd"+iii+"'                value='"+$(this).attr("a_PriAccessNumber")                +"'>"+        
							"<input type='hidden' name='a_Linkman_PrdOrd"+iii+"'                        value='"+$(this).attr("a_Linkman")                        +"'>"+
							"<input type='hidden' name='a_OneTimeFee"+iii+"'                            value='"+$(this).attr("a_OneTimeFee")                     +"'>"+
							"<input type='hidden' name='a_ContactPhone_PrdOrd"+iii+"'                   value='"+$(this).attr("a_ContactPhone")                   +"'>"+          
							"<input type='hidden' name='a_Description_PrdOrd"+iii+"'                    value='"+$(this).attr("a_Description")                    +"'>"+ 
							"<input type='hidden' name='a_ServiceLevelID_PrdOrd"+iii+"'                 value='"+$(this).attr("a_ServiceLevelID")                 +"'>"+ 
							"<input type='hidden' name='a_POOrderNumber_PrdOrd"+iii+"'                  value='"+$(this).attr("a_POOrderNumber")                  +"'>"+ 
							"<input type='hidden' name='a_POSpecNumber_PrdOrd"+iii+"'                   value='"+$(this).attr("a_POSpecNumber")                   +"'>"+ 
							"<input type='hidden' name='a_OperationSubTypeID_PrdOrd"+iii+"'             value='"+$(this).attr("a_OperationSubTypeID")             +"'>"+ 
							"<input type='hidden' name='a_OperType_PrdOrd"+iii+"'                       value='"+$(this).attr("a_OperType")                       +"'>"+ 
							"<input type='hidden' name='a_ProductOrderRateCheckFlag_PrdOrd"+iii+"'      value='"+$(this).attr("a_ProductOrderRateCheckFlag")      +"'>"+ 
							"<input type='hidden' name='a_EnableCompanyCheckFlag_PrdOrd"+iii+"'         value='"+$(this).attr("a_EnableCompanyCheckFlag")         +"'>"+ 
							"<input type='hidden' name='a_ProductOrderCharacterCheckFlag_PrdOrd"+iii+"' value='"+$(this).attr("a_ProductOrderCharacterCheckFlag") +"'>"+ 
							"<input type='hidden' name='a_AcceptID_PrdOrd"+iii+"'                       value='"+$(this).attr("a_AcceptID")                       +"'>"+ 
							"<input type='hidden' name='a_ProductStatus_PrdOrd"+iii+"'                  value='"+$(this).attr("a_ProductStatus")                  +"'>"+ 
							"<input type='hidden' name='p_BIZCODE"+iii+"'                  			   value='"+$(this).attr("p_BIZCODE")                  +"'>"+ 
							"<input type='hidden' name='p_BillType"+iii+"'                 			   value='"+$(this).attr("p_BillType")                  +"'>"+ 
							"<input type='hidden' name='a_selSales"+iii+"'                 			   value='"+$(this).attr("a_selSales")                  +"'>"+ 
							"</DIV>";

						//��Ʒ���ʷ�-----------------------------------------------------------------------
						var ProductOrder_13 = $(this).data("a_PORatePlanList");
						if (ProductOrder_13) { 
							$.each(ProductOrder_13, function(iii){
								var i4  = $("DIV.ProductOrderRatePlan","#hiddendate_new").size();
								var newdatei=	
									"<DIV class='ProductOrderRatePlan' style='display:none'>" + 
									"<input type='hidden' name='tableid_PrdOrdRatePlan"+i4+"' value='4'>" +
									"<input type='hidden' name='a_RatePlanID_PrdOrdRatePlan"+i4+"'                 value='"+ ProductOrder_13[iii][0] +"'>"+                                             
									"<input type='hidden' name='a_Description_PrdOrdRatePlan"+i4+"'                value='"+ ProductOrder_13[iii][1] +"'>"+
									"<input type='hidden' name='a_POOrderNumber_PrdOrdRatePlan"+i4+"'              value='"+ ProductOrder_13[iii][2] +"'>"+              
									"<input type='hidden' name='a_POSpecNumber_PrdOrdRatePlan"+i4+"'               value='"+ ProductOrder_13[iii][3] +"'>"+     
									"<input type='hidden' name='a_ProductOrderNumber_PrdOrdRatePlan"+i4+"'         value='"+ ProductOrder_13[iii][4] +"'>"+        
									"<input type='hidden' name='a_ProdcutOrderICBsCheckFlag_PrdOrdRatePlan"+i4+"'  value='"+ ProductOrder_13[iii][5] +"'>"+
									"<input type='hidden' name='a_OperType_PrdOrdRatePlan"+i4+"'                   value='"+ ProductOrder_13[iii][8] +"'>"+          
									"<input type='hidden' name='a_ProductSpecNumber_PrdOrdRatePlan"+i4+"'          value='"+ ProductOrder_13[iii][9] +"'>"+ 
									"<input type='hidden' name='a_ParAcceptID_PrdOrdRatePlan"+i4+"'                value='"+ ProductOrder_13[iii][10]+"'>"+ 
									"<input type='hidden' name='a_AcceptID_PrdOrdRatePlan"+i4+"'                   value='"+ ProductOrder_13[iii][11]+"'>"+ 
									"</DIV>";
								//��ƷPOICB--------------------------------------------------------------
								var PrdPatePlan_6 = ProductOrder_13[iii][6];
								if(PrdPatePlan_6){
									$.each(PrdPatePlan_6, function(i5) {                      		
										var i6 = $("DIV.ProductOrderPOICB","#hiddendate_new").size();
										var newdateii=	
											"<DIV class='ProductOrderPOICB' style='display:none'>" + 
											"<input type='hidden' name='tableid_PrdOrdPOICB"+i6+"' value='5'>" +
											"<input type='hidden' name='a_ParameterNumber_PrdOrdPOICB"+i6+"'     value='"+ PrdPatePlan_6[i5][0] +"'>"+                                             
											"<input type='hidden' name='a_ParameterName_PrdOrdPOICB"+i6+"'       value='"+ PrdPatePlan_6[i5][1] +"'>"+
											"<input type='hidden' name='a_ParameterValue_PrdOrdPOICB"+i6+"'      value='"+ PrdPatePlan_6[i5][2] +"'>"+              
											"<input type='hidden' name='a_POSpecNumber_PrdOrdPOICB"+i6+"'        value='"+ PrdPatePlan_6[i5][3] +"'>"+     
											"<input type='hidden' name='a_POOrderNumber_PrdOrdPOICB"+i6+"'       value='"+ PrdPatePlan_6[i5][4] +"'>"+        
											"<input type='hidden' name='a_ProductOrderNumber_PrdOrdPOICB"+i6+"'  value='"+ PrdPatePlan_6[i5][5] +"'>"+
											"<input type='hidden' name='a_RatePlanID_PrdOrdPOICB"+i6+"'          value='"+ PrdPatePlan_6[i5][6] +"'>"+          
											"<input type='hidden' name='a_ProductSpecNumber_PrdOrdPOICB"+i6+"'   value='"+ PrdPatePlan_6[i5][8] +"'>"+ 
											"<input type='hidden' name='a_ParAcceptID_PrdOrdPOICB"+i6+"'         value='"+ PrdPatePlan_6[i5][9] +"'>"+ 
											"<input type='hidden' name='a_AcceptID_PrdOrdPOICB"+i6+"'            value='"+ PrdPatePlan_6[i5][10]+"'>"+ 
											"</DIV>";
										$("#hiddendate_new").append(newdateii);
									});
								}
	
								//ȡ��Ʒ����
								var PrdPatePlan_14 = ProductOrder_13[iii][12];
								if (PrdPatePlan_14) {
									$.each(PrdPatePlan_14, function(i5,n){                      		
										var i14 = $("DIV.ProductCodePOICB","#hiddendate_new").size();
										var newdateii=	
										"<DIV class='ProductCodePOICB' style='display:none'>" + 
										"<input type='hidden' name='tableid_PrdCodePOICB"+i4+"' value='5'>" +
										"<input type='hidden' name='a_ProductCode"+i4+"'   oprType='del'  value='"+ PrdPatePlan_14[i5][0] +"'>"+
										"<input type='hidden' name='a_ProductName"+i4+"'  oprType='del'   value='"+ PrdPatePlan_14[i5][1] +"'>"+
										"</DIV>";
										$("#hiddendate_new").append(newdateii);
									});
								}
								
								//��ƷPOICB------------------------------------------------------------------                           
								$("#hiddendate_new").append(newdatei);
							});
						//��Ʒ���ʷ�-----------------------------------------------------------------------                        
						}

						//֧��ʡ---------------------------------------------------------------------------
						var ProductOrder_14 = $(this).data("a_POEnableCompanyList");
						if(ProductOrder_14) {
							$.each(ProductOrder_14, function(iii) {
								var i4 = $("DIV.PayCompany","#hiddendate_new").size();		 
								var newdatei=
									"<DIV class='PayCompany' style='display:none'>" + 
									"<input type='hidden' name='tableid_PayCompany"+i4+"' value='6'>" +
									"<input type='hidden' name='a_PayCompanyID_PayCompany"+i4+"'     value='"+ ProductOrder_14[iii][0] +"'>"+                                             
									"<input type='hidden' name='a_PayCompanyName_PayCompany"+i4+"'       value='"+ ProductOrder_14[iii][1] +"'>"+
									"<input type='hidden' name='a_POOrderNumber_PayCompany"+i4+"'      value='"+ ProductOrder_14[iii][2] +"'>"+              
									"<input type='hidden' name='a_POSpecNumberr_PayCompany"+i4+"'        value='"+ ProductOrder_14[iii][3] +"'>"+     
									"<input type='hidden' name='a_ProductOrderNumber_PayCompany"+i4+"'       value='"+ ProductOrder_14[iii][4] +"'>"+        
									"<input type='hidden' name='a_OperType_PayCompany"+i4+"'  value='"+ ProductOrder_14[iii][5] +"'>"+                           
									"<input type='hidden' name='a_ProductSpecNumber_PayCompany"+i4+"'   value='"+ ProductOrder_14[iii][6] +"'>"+ 
									"<input type='hidden' name='a_ParAcceptID_PayCompany"+i4+"'         value='"+ ProductOrder_14[iii][7] +"'>"+ 
									"<input type='hidden' name='a_AcceptID_PayCompany"+i4+"'            value='"+ ProductOrder_14[iii][8]+"'>"+                                     
									"</DIV>";	
								$("#hiddendate_new").append(newdatei);	
							});
						}
						//֧��ʡ---------------------------------------------------------------------------

						//��Ʒ����---------------------------------------------------------------------------
						var ProductOrder_15 = $(this).data("a_POProductOrderCharacterList");
						//alert(ProductOrder_15);
						if (ProductOrder_15) {
							$.each(ProductOrder_15, function(iii) {
								var i4  = $("DIV.ProductOrderChara","#hiddendate_new").size();		 
								var newdatei=
									"<DIV class='ProductOrderChara' style='display:none'>" + 
									"<input type='hidden' name='tableid_ProOrdChara"+i4+"' value='7'>"                                                    +
									"<input type='hidden' name='a_ProductSpecCharacterNumber_ProOrdChara"+i4+"'    value='"+ ProductOrder_15[iii][0] +"'>"+                                             
									"<input type='hidden' name='a_Name_ProOrdChara"+i4+"'                          value='"+ ProductOrder_15[iii][1] +"'>"+
									"<input type='hidden' name='a_CharacterValue_ProOrdChara"+i4+"'                value='"+ ProductOrder_15[iii][2] +"'>"+              
									"<input type='hidden' name='a_POOrderNumber_ProOrdChara"+i4+"'                 value='"+ ProductOrder_15[iii][3] +"'>"+     
									"<input type='hidden' name='a_POSpecNumber_ProOrdChara"+i4+"'                  value='"+ ProductOrder_15[iii][4] +"'>"+        
									"<input type='hidden' name='a_ProductOrderNumber_ProOrdChara"+i4+"'            value='"+ ProductOrder_15[iii][5] +"'>"+
									"<input type='hidden' name='a_OperType_ProOrdChara"+i4+"'                      value='"+ ProductOrder_15[iii][6] +"'>"+          
									"<input type='hidden' name='a_ProductSpecNumber_ProOrdChara"+i4+"'             value='"+ ProductOrder_15[iii][7] +"'>"+ 
									"<input type='hidden' name='a_ParAcceptID_ProOrdChara"+i4+"'                   value='"+ ProductOrder_15[iii][8] +"'>"+ 
									"<input type='hidden' name='a_AcceptID_ProOrdChara"+i4+"'                      value='"+ ProductOrder_15[iii][9]+"'>"+ 
									"<input type='hidden' name='a_POOrderSeriNum_ProOrdChara"+i4+"'                value='"+ ProductOrder_15[iii][10]+"'>"+ 
									"<input type='hidden' name='a_CharacterGroup"+i4+"'                            value='"+ ProductOrder_15[iii][11]+"'>"+ 
									"</DIV>";
								$("#hiddendate_new").append(newdatei);	
								//alert(" :::::"+ProductOrder_15[iii][0]);
								//alert(" :::::"+ProductOrder_15[iii][10]);
							});
						}
						//��Ʒ����---------------------------------------------------------------------------                                               
						$("#hiddendate_new").append(newdate);

						//��Ʒ����ɾ��---------------------------------------------------------------------------
						var ProductOrder_30 = $(this).data("a_POProductOrderCharacter");
						if(ProductOrder_30){
							$.each(ProductOrder_30, function(iii) {
								//alert("dd10:"+ProductOrder_30[iii][10]);
								//var i4  = $("DIV.ProductOrderChara","#hiddendate_delete").size();
								var iiix = 0;
								while (document.getElementsByName("d_ProductSpecCharacterNumber_ProOrdChara"+iiix).length > 0) {
									iiix ++;
								}
								var deletedate=
									"<DIV class='ProductOrderChara' style='display:none'>" + 
									"<input type='hidden' name='tableid_ProOrdChara"+iiix+"' value='7'>"                                                    +
									"<input type='hidden' name='d_ProductSpecCharacterNumber_ProOrdChara"+iiix+"'    value='"+ ProductOrder_30[iii][0] +"'>"+                                             
									"<input type='hidden' name='d_Name_ProOrdChara"+iiix+"'                          value='"+ ProductOrder_30[iii][1] +"'>"+
									"<input type='hidden' name='d_CharacterValue_ProOrdChara"+iiix+"'                value='"+ ProductOrder_30[iii][2] +"'>"+              
									"<input type='hidden' name='d_POOrderNumber_ProOrdChara"+iiix+"'                 value='"+ ProductOrder_30[iii][3] +"'>"+     
									"<input type='hidden' name='d_POSpecNumber_ProOrdChara"+iiix+"'                  value='"+ ProductOrder_30[iii][4] +"'>"+        
									"<input type='hidden' name='d_ProductOrderNumber_ProOrdChara"+iiix+"'            value='"+ ProductOrder_30[iii][5] +"'>"+
									"<input type='hidden' name='d_OperType_ProOrdChara"+iiix+"'                      value='"+ ProductOrder_30[iii][6] +"'>"+          
									"<input type='hidden' name='d_ProductSpecNumber_ProOrdChara"+iiix+"'             value='"+ ProductOrder_30[iii][7] +"'>"+ 
									"<input type='hidden' name='d_ParAcceptID_ProOrdChara"+iiix+"'                   value='"+ ProductOrder_30[iii][8] +"'>"+ 
									"<input type='hidden' name='d_AcceptID_ProOrdChara"+iiix+"'                      value='"+ ProductOrder_30[iii][9]+"'>"+ 
									"<input type='hidden' name='d_POOrderSeriNum_ProOrdChara"+iiix+"'                value='"+ ProductOrder_30[iii][10]+"'>"+ 
									"<input type='hidden' name='d_CharacterGroup"+iiix+"'                           value='"+ ProductOrder_30[iii][11]+"'>"+ 
									"</DIV>";
								$("#hiddendate_delete").append(deletedate);	                
								// $("#title_zi").append(deletedate);	                                                             
							});
						}
						//��Ʒ����---------------------------------------------------------------------------                                               
						//$("#hiddendate_new").append(newdate)

						//�����ڵ� wangzn2010-4-13 18:51:27
						var ProductOrder_32 = $(this).data("a_ProductOrderManageCharacter");
						if(ProductOrder_32) {
							$.each(ProductOrder_32, function(iii){
								var Managerdata=
									"<DIV class='ProductOrderManager' style='display:none'>" + 
									"<input type='hidden' name='managerType"+iii+"' value='"+ ProductOrder_32[iii][0]+"'>"+ 
									"<input type='hidden' name='productOrderNumber"+iii+"' value='"+ ProductOrder_32[iii][1]+"'>"+ 
									"<input type='hidden' name='operateCode"+iii+"' value='"+ ProductOrder_32[iii][2]+"'>"+ 
									"<input type='hidden' name='characterID"+iii+"' value='"+ ProductOrder_32[iii][3]+"'>"+ 
									"<input type='hidden' name='characterValue"+iii+"' value='"+ ProductOrder_32[iii][4]+"'>"+ 
									"<input type='hidden' name='characterName"+iii+"' value='"+ ProductOrder_32[iii][5]+"'>"+ 
									"<input type='hidden' name='characterDesc"+iii+"' value='"+ ProductOrder_32[iii][6]+"'>"+    					 
									"</DIV>";
								//alert(Managerdata);
								$("#hiddendate_new").append(Managerdata);
							});	
						}
    			
						//���� wangzn 2010-9-25 16:52:05
						var ProductOrder_33 = $(this).data("a_ProductOrderExamine");
						if(ProductOrder_33) {
							$.each(ProductOrder_33, function(iii){
								var ExamineData=
									"<DIV class='ProductOrderExamine' style='display:none'>" + 
									"<input type='hidden' name='ExamineType"+iii+"' value='"+ ProductOrder_33[iii][0]+"'>"+ 
									"<input type='hidden' name='ExamineContent"+iii+"' value='"+ ProductOrder_33[iii][1]+"'>"+ 
									"<input type='hidden' name='ExamineResult"+iii+"' value='"+ ProductOrder_33[iii][2]+"'>"+    					 
									"</DIV>";
								//alert(ExamineData);
								$("#hiddendate_new").append(ExamineData);
							});		
						}

					/*} else {
						rdShowMessageDialog("��Ʒ���Ա��ֻ��������һ����Ʒ");
						return false;
						//window.location.reload();
					}*/
				}
			} else {
				if(document.getElementsByName("DeleteCheckBox")[i].checked){
				  	  var newdate=
			        "<DIV class='ProductOrder' style='display:none'>" + 
			        "<input type='hidden' name='tableid_PrdOrd"+iii+"'                    value='0'>"+
			        "<input type='hidden' name='a_ProductOrderNumber_PrdOrd"+iii+"'             value='"+$(this).attr("a_ProductOrderNumber")             +"'>"+                                             
			        "<input type='hidden' name='a_ProductID_PrdOrd"+iii+"'                      value='"+$(this).attr("a_ProductID")                      +"'>"+
			        "<input type='hidden' name='a_ProductSpecNumber_PrdOrd"+iii+"'              value='"+$(this).attr("a_ProductSpecNumber")              +"'>"+              
			        "<input type='hidden' name='a_AccessNumber_PrdOrd"+iii+"'                   value='"+$(this).attr("a_AccessNumber")                   +"'>"+     
			        "<input type='hidden' name='a_PriAccessNumber_PrdOrd"+iii+"'                value='"+$(this).attr("a_PriAccessNumber")                +"'>"+        
			        "<input type='hidden' name='a_Linkman_PrdOrd"+iii+"'                        value='"+$(this).attr("a_Linkman")                        +"'>"+
			        "<input type='hidden' name='a_OneTimeFee"+iii+"'                            value='"+$(this).attr("a_OneTimeFee")                     +"'>"+
			        "<input type='hidden' name='a_ContactPhone_PrdOrd"+iii+"'                   value='"+$(this).attr("a_ContactPhone")                   +"'>"+          
			        "<input type='hidden' name='a_Description_PrdOrd"+iii+"'                    value='"+$(this).attr("a_Description")                    +"'>"+ 
			        "<input type='hidden' name='a_ServiceLevelID_PrdOrd"+iii+"'                 value='"+$(this).attr("a_ServiceLevelID")                 +"'>"+ 
			        "<input type='hidden' name='a_POOrderNumber_PrdOrd"+iii+"'                  value='"+$(this).attr("a_POOrderNumber")                  +"'>"+ 
			        "<input type='hidden' name='a_POSpecNumber_PrdOrd"+iii+"'                   value='"+$(this).attr("a_POSpecNumber")                   +"'>"+ 
			        "<input type='hidden' name='a_OperationSubTypeID_PrdOrd"+iii+"'             value='"+$(this).attr("a_OperationSubTypeID")             +"'>"+ 
			        "<input type='hidden' name='a_OperType_PrdOrd"+iii+"'                       value='"+$(this).attr("a_OperType")                       +"'>"+ 
			        "<input type='hidden' name='a_ProductOrderRateCheckFlag_PrdOrd"+iii+"'      value='"+$(this).attr("a_ProductOrderRateCheckFlag")      +"'>"+ 
			        "<input type='hidden' name='a_EnableCompanyCheckFlag_PrdOrd"+iii+"'         value='"+$(this).attr("a_EnableCompanyCheckFlag")         +"'>"+ 
			        "<input type='hidden' name='a_ProductOrderCharacterCheckFlag_PrdOrd"+iii+"' value='"+$(this).attr("a_ProductOrderCharacterCheckFlag") +"'>"+ 
			        "<input type='hidden' name='a_AcceptID_PrdOrd"+iii+"'                       value='"+$(this).attr("a_AcceptID")                       +"'>"+ 
			        "<input type='hidden' name='a_ProductStatus_PrdOrd"+iii+"'                  value='"+$(this).attr("a_ProductStatus")                  +"'>"+ 
			        "<input type='hidden' name='p_BIZCODE"+iii+"'                  			   value='"+$(this).attr("p_BIZCODE")                  +"'>"+ 
			        "<input type='hidden' name='p_BillType"+iii+"'                 			   value='"+$(this).attr("p_BillType")                  +"'>"+ 
			        "<input type='hidden' name='a_selSales"+iii+"'                 			   value='"+$(this).attr("a_selSales")                  +"'>"+ 
			        "</DIV>";
			        			        //alert($(this).attr("a_OperationSubTypeID"));
			        //��Ʒ���ʷ�-----------------------------------------------------------------------
			        var ProductOrder_13 = $(this).data("a_PORatePlanList");
			        if(ProductOrder_13){
			        		 
			           $.each(ProductOrder_13, function(iii){
			           var i4  = $("DIV.ProductOrderRatePlan","#hiddendate_new").size();
             		 //alert("i4 = " + i4 + ", iii = " + iii);
			           var newdatei=	
			              "<DIV class='ProductOrderRatePlan' style='display:none'>" + 
			              "<input type='hidden' name='tableid_PrdOrdRatePlan"+i4+"' value='4'>" +
			              "<input type='hidden' name='a_RatePlanID_PrdOrdRatePlan"+i4+"'                 value='"+ ProductOrder_13[iii][0] +"'>"+                                             
			              "<input type='hidden' name='a_Description_PrdOrdRatePlan"+i4+"'                value='"+ ProductOrder_13[iii][1] +"'>"+
			              "<input type='hidden' name='a_POOrderNumber_PrdOrdRatePlan"+i4+"'              value='"+ ProductOrder_13[iii][2] +"'>"+              
			              "<input type='hidden' name='a_POSpecNumber_PrdOrdRatePlan"+i4+"'               value='"+ ProductOrder_13[iii][3] +"'>"+     
			              "<input type='hidden' name='a_ProductOrderNumber_PrdOrdRatePlan"+i4+"'         value='"+ ProductOrder_13[iii][4] +"'>"+        
			              "<input type='hidden' name='a_ProdcutOrderICBsCheckFlag_PrdOrdRatePlan"+i4+"'  value='"+ ProductOrder_13[iii][5] +"'>"+
			              "<input type='hidden' name='a_OperType_PrdOrdRatePlan"+i4+"'                   value='"+ ProductOrder_13[iii][8] +"'>"+          
			              "<input type='hidden' name='a_ProductSpecNumber_PrdOrdRatePlan"+i4+"'          value='"+ ProductOrder_13[iii][9] +"'>"+ 
			              "<input type='hidden' name='a_ParAcceptID_PrdOrdRatePlan"+i4+"'                value='"+ ProductOrder_13[iii][10]+"'>"+ 
			              "<input type='hidden' name='a_AcceptID_PrdOrdRatePlan"+i4+"'                   value='"+ ProductOrder_13[iii][11]+"'>"+ 
			              "</DIV>";
			              //��ƷPOICB--------------------------------------------------------------
			              var PrdPatePlan_6 = ProductOrder_13[iii][6];
			              
			                    
			              
			              if(PrdPatePlan_6){
			              		 
			              	$.each(PrdPatePlan_6, function(i5){                      		
			              		var i6 = $("DIV.ProductOrderPOICB","#hiddendate_new").size();
			              		              		
			                  var newdateii=	
			                  "<DIV class='ProductOrderPOICB' style='display:none'>" + 
			                  "<input type='hidden' name='tableid_PrdOrdPOICB"+i6+"' value='5'>" +
			                  "<input type='hidden' name='a_ParameterNumber_PrdOrdPOICB"+i6+"'     value='"+ PrdPatePlan_6[i5][0] +"'>"+                                             
			                  "<input type='hidden' name='a_ParameterName_PrdOrdPOICB"+i6+"'       value='"+ PrdPatePlan_6[i5][1] +"'>"+
			                  "<input type='hidden' name='a_ParameterValue_PrdOrdPOICB"+i6+"'      value='"+ PrdPatePlan_6[i5][2] +"'>"+              
			                  "<input type='hidden' name='a_POSpecNumber_PrdOrdPOICB"+i6+"'        value='"+ PrdPatePlan_6[i5][3] +"'>"+     
			                  "<input type='hidden' name='a_POOrderNumber_PrdOrdPOICB"+i6+"'       value='"+ PrdPatePlan_6[i5][4] +"'>"+        
			                  "<input type='hidden' name='a_ProductOrderNumber_PrdOrdPOICB"+i6+"'  value='"+ PrdPatePlan_6[i5][5] +"'>"+
			                  "<input type='hidden' name='a_RatePlanID_PrdOrdPOICB"+i6+"'          value='"+ PrdPatePlan_6[i5][6] +"'>"+          
			                  "<input type='hidden' name='a_ProductSpecNumber_PrdOrdPOICB"+i6+"'   value='"+ PrdPatePlan_6[i5][8] +"'>"+ 
			                  "<input type='hidden' name='a_ParAcceptID_PrdOrdPOICB"+i6+"'         value='"+ PrdPatePlan_6[i5][9] +"'>"+ 
			                  "<input type='hidden' name='a_AcceptID_PrdOrdPOICB"+i6+"'            value='"+ PrdPatePlan_6[i5][10]+"'>"+ 
			                  "</DIV>";
			                  $("#hiddendate_new").append(newdateii);
			              	});	
			              }
			              
			              //ȡ��Ʒ����
			              var PrdPatePlan_14 = ProductOrder_13[iii][12];
			              if(PrdPatePlan_14){
			              		 
			              	$.each(PrdPatePlan_14, function(i5,n){                      		
			              		var i14 = $("DIV.ProductCodePOICB","#hiddendate_new").size();
			              		              		
			                  var newdateii=	
			                  "<DIV class='ProductCodePOICB' style='display:none'>" + 
			                  "<input type='hidden' name='tableid_PrdCodePOICB"+i4+"' value='5'>" +
			                  "<input type='hidden' name='a_ProductCode"+i4+"'  oprType='add'   value='"+ PrdPatePlan_14[i5][0] +"'>"+
			                  "<input type='hidden' name='a_ProductName"+i4+"'  oprType='add'   value='"+ PrdPatePlan_14[i5][1] +"'>"+
			                  "</DIV>";
			                  $("#hiddendate_new").append(newdateii);
			              	});	
			              }
			              
			              //��ƷPOICB------------------------------------------------------------------                           
			              $("#hiddendate_new").append(newdatei);
			           });
			           //��Ʒ���ʷ�-----------------------------------------------------------------------                        
			        }        
			                                                                
			        //֧��ʡ---------------------------------------------------------------------------
			        var ProductOrder_14 = $(this).data("a_POEnableCompanyList");
			        if(ProductOrder_14){
			           $.each(ProductOrder_14, function(iii){
			           			 
			           var i4  = $("DIV.PayCompany","#hiddendate_new").size();		 
			           var newdatei=
			                 "<DIV class='PayCompany' style='display:none'>" + 
			                  "<input type='hidden' name='tableid_PayCompany"+i4+"' value='6'>" +
			                  "<input type='hidden' name='a_PayCompanyID_PayCompany"+i4+"'     value='"+ ProductOrder_14[iii][0] +"'>"+                                             
			                  "<input type='hidden' name='a_PayCompanyName_PayCompany"+i4+"'       value='"+ ProductOrder_14[iii][1] +"'>"+
			                  "<input type='hidden' name='a_POOrderNumber_PayCompany"+i4+"'      value='"+ ProductOrder_14[iii][2] +"'>"+              
			                  "<input type='hidden' name='a_POSpecNumberr_PayCompany"+i4+"'        value='"+ ProductOrder_14[iii][3] +"'>"+     
			                  "<input type='hidden' name='a_ProductOrderNumber_PayCompany"+i4+"'       value='"+ ProductOrder_14[iii][4] +"'>"+        
			                  "<input type='hidden' name='a_OperType_PayCompany"+i4+"'  value='"+ ProductOrder_14[iii][5] +"'>"+                           
			                  "<input type='hidden' name='a_ProductSpecNumber_PayCompany"+i4+"'   value='"+ ProductOrder_14[iii][6] +"'>"+ 
			                  "<input type='hidden' name='a_ParAcceptID_PayCompany"+i4+"'         value='"+ ProductOrder_14[iii][7] +"'>"+ 
			                  "<input type='hidden' name='a_AcceptID_PayCompany"+i4+"'            value='"+ ProductOrder_14[iii][8]+"'>"+                                     
			                  "</DIV>";	
			           $("#hiddendate_new").append(newdatei);	
				  	  });
				  	  }
			        //֧��ʡ---------------------------------------------------------------------------
			        
			        
			        //��Ʒ����---------------------------------------------------------------------------
			        var ProductOrder_15 = $(this).data("a_POProductOrderCharacterList");
			        //alert(ProductOrder_15);
			        if(ProductOrder_15){
			        	 
			           $.each(ProductOrder_15, function(iii){
			           var i4  = $("DIV.ProductOrderChara","#hiddendate_new").size();		 
			           var newdatei=
			                  "<DIV class='ProductOrderChara' style='display:none'>" + 
			                  "<input type='hidden' name='tableid_ProOrdChara"+i4+"' value='7'>"                                                    +
			                  "<input type='hidden' name='a_ProductSpecCharacterNumber_ProOrdChara"+i4+"'    value='"+ ProductOrder_15[iii][0] +"'>"+                                             
			                  "<input type='hidden' name='a_Name_ProOrdChara"+i4+"'                          value='"+ ProductOrder_15[iii][1] +"'>"+
			                  "<input type='hidden' name='a_CharacterValue_ProOrdChara"+i4+"'                value='"+ ProductOrder_15[iii][2] +"'>"+              
			                  "<input type='hidden' name='a_POOrderNumber_ProOrdChara"+i4+"'                 value='"+ ProductOrder_15[iii][3] +"'>"+     
			                  "<input type='hidden' name='a_POSpecNumber_ProOrdChara"+i4+"'                  value='"+ ProductOrder_15[iii][4] +"'>"+        
			                  "<input type='hidden' name='a_ProductOrderNumber_ProOrdChara"+i4+"'            value='"+ ProductOrder_15[iii][5] +"'>"+
			                  "<input type='hidden' name='a_OperType_ProOrdChara"+i4+"'                      value='"+ ProductOrder_15[iii][6] +"'>"+          
			                  "<input type='hidden' name='a_ProductSpecNumber_ProOrdChara"+i4+"'             value='"+ ProductOrder_15[iii][7] +"'>"+ 
			                  "<input type='hidden' name='a_ParAcceptID_ProOrdChara"+i4+"'                   value='"+ ProductOrder_15[iii][8] +"'>"+ 
			                  "<input type='hidden' name='a_AcceptID_ProOrdChara"+i4+"'                      value='"+ ProductOrder_15[iii][9]+"'>"+ 
			                  "<input type='hidden' name='a_POOrderSeriNum_ProOrdChara"+i4+"'                value='"+ ProductOrder_15[iii][10]+"'>"+ 
			                  "<input type='hidden' name='a_CharacterGroup"+i4+"'                            value='"+ ProductOrder_15[iii][11]+"'>"+ 
			                  "</DIV>";
			           $("#hiddendate_new").append(newdatei);	
			           //alert(" :::::"+ProductOrder_15[iii][0]);
			           //alert(" :::::"+ProductOrder_15[iii][10]);
				  	  });
				  	  }
				  	  //��Ʒ����---------------------------------------------------------------------------                                               
			    $("#hiddendate_new").append(newdate);
			    
			     //��Ʒ����ɾ��---------------------------------------------------------------------------
			        var ProductOrder_30 = $(this).data("a_POProductOrderCharacter");
			        if(ProductOrder_30){
			        	
			           $.each(ProductOrder_30, function(iii){
			           	//alert("dd0:"+ProductOrder_30[iii][0]);
			           	//alert("dd10:"+ProductOrder_30[iii][10]);
			           var i4  = $("DIV.ProductOrderChara","#hiddendate_delete").size();		 
			           var deletedate=
			                  "<DIV class='ProductOrderChara' style='display:none'>" + 
			                  "<input type='hidden' name='tableid_ProOrdChara"+i4+"' value='7'>"                                                    +
			                  "<input type='hidden' name='d_ProductSpecCharacterNumber_ProOrdChara"+i4+"'    value='"+ ProductOrder_30[iii][0] +"'>"+                                             
			                  "<input type='hidden' name='d_Name_ProOrdChara"+i4+"'                          value='"+ ProductOrder_30[iii][1] +"'>"+
			                  "<input type='hidden' name='d_CharacterValue_ProOrdChara"+i4+"'                value='"+ ProductOrder_30[iii][2] +"'>"+              
			                  "<input type='hidden' name='d_POOrderNumber_ProOrdChara"+i4+"'                 value='"+ ProductOrder_30[iii][3] +"'>"+     
			                  "<input type='hidden' name='d_POSpecNumber_ProOrdChara"+i4+"'                  value='"+ ProductOrder_30[iii][4] +"'>"+        
			                  "<input type='hidden' name='d_ProductOrderNumber_ProOrdChara"+i4+"'            value='"+ ProductOrder_30[iii][5] +"'>"+
			                  "<input type='hidden' name='d_OperType_ProOrdChara"+i4+"'                      value='"+ ProductOrder_30[iii][6] +"'>"+          
			                  "<input type='hidden' name='d_ProductSpecNumber_ProOrdChara"+i4+"'             value='"+ ProductOrder_30[iii][7] +"'>"+ 
			                  "<input type='hidden' name='d_ParAcceptID_ProOrdChara"+i4+"'                   value='"+ ProductOrder_30[iii][8] +"'>"+ 
			                  "<input type='hidden' name='d_AcceptID_ProOrdChara"+i4+"'                      value='"+ ProductOrder_30[iii][9]+"'>"+ 
			                  "<input type='hidden' name='d_POOrderSeriNum_ProOrdChara"+i4+"'                value='"+ ProductOrder_30[iii][10]+"'>"+ 
			                   "<input type='hidden' name='d_CharacterGroup"+i4+"'                           value='"+ ProductOrder_30[iii][11]+"'>"+ 
			                  "</DIV>";
			          $("#hiddendate_delete").append(deletedate);	                
          // $("#title_zi").append(deletedate);	                                                             
	  	  });
	  	  }
	  	  //��Ʒ����---------------------------------------------------------------------------                                               
    //$("#hiddendate_new").append(newdate)
    			 
		}
		}
    });		
    var iiii  = $("DIV.ProductOrder","#hiddendate_new").size();
    //if(iiii<=0&&PoOprFlag!="1"){
    //	rdShowMessageDialog("����ѡ���Ʒ!",0);
    //	return;
    //}
    if("010105001"==$("#p_POSpecNumber").val()&&iiii!=1)
    {
    	rdShowMessageDialog("��ʡ����ҵ��[010105001]��ÿ�ʶ���ֻ�ܲ���һ����Ʒ!",0);
    	return;
    }
    
	$("#hiddendate_PospecratePolicy_num").val($("DIV.PospecratePolicy","#hiddendate_new").size());
    $("#hiddendate_RatePlans_num").val($("DIV.RatePlans","#hiddendate_new").size());
    $("#hiddendate_POICBs_num").val($("DIV.POICBs","#hiddendate_new").size());
    $("#hiddendate_ProductOrder_num").val($("DIV.ProductOrder","#hiddendate_new").size());
    //alert($("DIV.ProductOrder","#hiddendate_new").size());
    $("#hiddendate_ProductOrderRatePlan_num").val($("DIV.ProductOrderRatePlan","#hiddendate_new").size());
    $("#hiddendate_ProductOrderPOICB_num").val($("DIV.ProductOrderPOICB","#hiddendate_new").size());
    $("#hiddendate_ProductCodePOICB_num").val($("DIV.ProductCodePOICB","#hiddendate_new").size());
    $("#hiddendate_PayCompany_num").val($("DIV.PayCompany","#hiddendate_new").size());
    $("#hiddendate_ProductOrderChara_num").val($("DIV.ProductOrderChara","#hiddendate_new").size());

    $("#hiddendate_PospecratePolicy_num_delete").val($("DIV.PospecratePolicy","#hiddendate_delete").size());
    $("#hiddendate_RatePlans_num_delete").val($("DIV.RatePlans","#hiddendate_delete").size());
    $("#hiddendate_POICBs_num_delete").val($("DIV.POICBs","#hiddendate_delete").size());
    $("#hiddendate_ProductOrder_num_delete").val($("DIV.ProductOrder","#hiddendate_delete").size());
    $("#hiddendate_ProductOrderRatePlan_num_delete").val($("DIV.ProductOrderRatePlan","#hiddendate_delete").size());
    $("#hiddendate_ProductOrderPOICB_num_delete").val($("DIV.ProductOrderPOICB","#hiddendate_delete").size());
    $("#hiddendate_PayCompany_num_delete").val($("DIV.PayCompany","#hiddendate_delete").size());
    $("#hiddendate_ProductOrderChara_num_delete").val($("DIV.ProductOrderChara","#hiddendate_delete").size());
    
    //wangzn 2010-4-19 15:29:04
    $("#hiddendate_ProductOrderManagerChar_num").val($("DIV.ProductOrderManager","#hiddendate_new").size());
    $("#hiddendate_ProductOrderExamine_num").val($("DIV.ProductOrderExamine","#hiddendate_new").size());
    //alert($("DIV.ProductOrderManager","#hiddendate_new").size());
    
    //�����������ŵ��������ʼ������Ļ����ȡ�����ύ��ʱ�򻺴�����ݻ��ظ���
    //var confirmFlag=0;
    //confirmFlag = rdShowConfirmDialog("�Ƿ��ύ���β�����");
    if (confirmFlag==1){
    	var inputObj ;
    	var inputI;
    	var form_ = document.form1;
    	for(inputI = 0;inputI<form_.length;inputI++){
    		inputObj = form_.elements[inputI];		
    		inputObj.disabled = false;		
    	}
    	
    	var prodOrderNum = $("#hiddendate_ProductOrder_num").val();
    	var prodOrderDelNum = $("#hiddendate_ProductOrder_num_delete").val();
    	var objs = $("input[name^='a_OperationSubTypeID_PrdOrd']");
    	var changeFlag = "normal";
    	$.each(objs,function(i,n){
    		if($(this).val() == "1|"){
    			changeFlag = "add";
    		}else if($(this).val() == "A|" || $(this).val() == "11|"){
    			changeFlag = "del";
    		}else if($(this).val() == "5|"){
    			changeFlag = "update";
    		}
    	});
    	/*
    	*���ݼ���ecid��ѯ �Ƿ�Ϊ��ʡ���ţ�
    	*���Ϊ��ʡ�������ӡ��������Ϊ��ʡ�����򲻴�ӡ�����
    	*/
    	$("#printFlag").val("");
    	var custmoter_ec_id = $("#p_CustomerNumber").val();
    	var getdataPacket = new AJAXPacket("f2029_getECInfo.jsp","���ڻ�����ݣ����Ժ�......");
			getdataPacket.data.add("custmoter_ec_id",custmoter_ec_id);
			core.ajax.sendPacket(getdataPacket,doGetECInfo);
			getdataPacket = null;
    	if((Number(prodOrderNum) > 0 || Number(prodOrderDelNum) > 0)&&$("#printFlag").val()=='Y'){
    		if(changeFlag == "add" 
    				|| changeFlag == "del" 
    				||changeFlag == "update"){
    				/*��Ʒ�����������������������  ��ӡ���*/
    				doPrint(changeFlag);
    				if(rdShowConfirmDialog("ȷ�ϵ��������")==1){
    				}else{
    					return false;
    				}
    		}
    	}
    	
    	
    	  document.form1.target="_self";
	      document.form1.encoding="application/x-www-form-urlencoded";
	      document.form1.method="post";
        document.form1.action="f2029_cfm.jsp?p_operType="+$("#p_OperType").val();
        document.form1.submit();
        //wuxy add 20090908
        document.form1.nextoper.disabled=true;
        loading();
    }
}
function doGetECInfo(packet){
	var printFlag = packet.data.findValueByName("printFlag");
	$("#printFlag").val(printFlag);
}
function doPrint(printFlag){
	//alert("��ӡ���"+printFlag);
	var ret=showPrtDlg("Detail","ȷʵҪ���е��������ӡ��","Yes",printFlag);
}
function showPrtDlg(printType,DlgMessage,submitCfm,printFlag){  
	//��ʾ��ӡ�Ի���
	var h=210;
	var w=400;
	var t=screen.availHeight/2-h/2;
	var l=screen.availWidth/2-w/2;

	var printStr = printInfo(printFlag);

	var pType="subprint";              // ��ӡ���ͣ�print ��ӡ subprint �ϲ���ӡ
	var billType="1";               //  Ʊ�����ͣ�1���������2��Ʊ��3�վ�
	var sysAccept=$("#printAccept").val();               // ��ˮ��
	var mode_code="";               //�ʷѴ���
	var fav_code="";                 //�ط�����
	var area_code="";             //С������
	var opCode="2029";

	var phoneNo="";                  //�ͻ��绰

	var prop="dialogHeight:"+h+"px; dialogWidth:"+w+"px; dialogLeft:"+l+"px; dialogTop:"+t+"px;toolbar:no; menubar:no; scrollbars:yes; resizable:no;location:no;status:no;help:no";
	var path = "<%=request.getContextPath()%>/npage/innet/hljBillPrint_jc_dz.jsp?DlgMsg=" + DlgMessage+ "&submitCfm=" + submitCfm;
	path=path+"&mode_code="+mode_code+"&fav_code="+fav_code+"&area_code="+area_code+"&opCode=<%=opCode%>&sysAccept="+sysAccept+"&submitCfm="+submitCfm+"&pType="+pType+"&billType="+billType+ "&printInfo=" + printStr.trim();

	var ret=window.showModalDialog(path.trim(),printStr,prop);
  return ret;
}
function printInfo(printFlag)
{
	//alert(printFlag);
	var cust_info="";
	var opr_info="";
	var note_info1="";
	var note_info2="";
	var note_info3="";
	var note_info4="";
	var retInfo = "";
	$("#custId").val("");
	$("#acconId").val("");
	if(printFlag != "add"){
		var ProductID_PrdOrd_Obj = $("input[name^='a_ProductID_PrdOrd']");
		var productID_list = "";
		$.each(ProductID_PrdOrd_Obj,function(i,n){
			productID_list += "'" + $(this).val() + "',";
		});
		productID_list = productID_list.substring(0,productID_list.length-1);
		//alert(productID_list);
		var getdataPacket = new AJAXPacket("f2029_getPrintInfo.jsp","���ڻ�����ݣ����Ժ�......");
		getdataPacket.data.add("productID_list",productID_list);
		core.ajax.sendPacket(getdataPacket,getInfoBack);
		getdataPacket = null;
	}
	/********������Ϣ��**********/
	cust_info+="EC���ſͻ����룺" +$("#p_CustomerNumber").val()+"|";
	cust_info+="���ſͻ����ƣ�"+$("#unitName").val()+"|";
	cust_info+="�����û�ID��"+$("#custId").val()+"|";
	cust_info+="���ѷ�ʽ��"+"�ֽ�"+"|";
	cust_info+="�����˺ţ�"+$("#acconId").val()+"|";
	if(printFlag == "add"){
		opr_info+="����ҵ�񣺼��Ų�Ʒ����"+"|" ;
	}else if(printFlag == "del"){
		opr_info+="����ҵ�񣺼��Ų�Ʒ����"+"|" ;
	}else if(printFlag == "update"){
		opr_info+="����ҵ�񣺼��Ų�Ʒ���"+"|" ;
	}
	opr_info+="������ˮ��"+$("#printAccept").val()+"|" ;
	
	if(printFlag == "add"){
		var prodStr = "";
		var codeObjs = $("input[name^='a_ProductCode'][oprType='add']");
		var nameObjs = $("input[name^='a_ProductName'][oprType='add']");
		$.each(codeObjs,function(i,n){
			prodStr += $(codeObjs[i]).val() + ":" + $(nameObjs[i]).val()+"��";
		});
		opr_info+="�����Ʒ���ƣ�"+prodStr+"|" ;
	}else if(printFlag == "update"){
		var delProdStr = "";
		var delCodeObjs = $("input[name^='a_ProductCode'][oprType='del']");
		var delNameObjs = $("input[name^='a_ProductName'][oprType='del']");
		$.each(delCodeObjs,function(i,n){
			delProdStr += $(delCodeObjs[i]).val() + ":" + $(delNameObjs[i]).val()+"��";
		});
		opr_info+="ԭ��Ʒ���ƣ�"+delProdStr+"|" ;
		
		var addProdStr = "";
		var codeObjs = $("input[name^='a_ProductCode'][oprType='add']");
		var nameObjs = $("input[name^='a_ProductName'][oprType='add']");
		$.each(codeObjs,function(i,n){
			addProdStr += $(codeObjs[i]).val() + ":" + $(nameObjs[i]).val()+"��";
		});
		opr_info+="�²�Ʒ���ƣ�"+addProdStr+"|" ;
	}else if(printFlag == "del"){
		var delProdStr = "";
		var delCodeObjs = $("input[name^='a_ProductCode'][oprType='del']");
		var delNameObjs = $("input[name^='a_ProductName'][oprType='del']");
		$.each(delCodeObjs,function(i,n){
			delProdStr += $(delCodeObjs[i]).val() + ":" + $(delNameObjs[i]).val()+"��";
		});
		opr_info+="������Ʒ���ƣ�"+delProdStr+"|" ;
	}
	/*******��ע��**********/
	note_info1="��ע��"+"|"
	
	retInfo = strcat(cust_info,opr_info,note_info1,note_info2,note_info3,note_info4);
	retInfo=retInfo.replace(new RegExp("#","gm"),"%23");
	return retInfo;
}
function getInfoBack(packet){
	var custId = packet.data.findValueByName("custId");
	var acconId = packet.data.findValueByName("acconId");
	$("#custId").val(custId);
	$("#acconId").val(acconId);
}

var _jspPage =
{"div1_switch":["mydiv1","f2029_POSpecRatePolicys_list.jsp","f"]
,"div2_switch":["mydiv2","f2029_ProductOrder_list.jsp","f"]
};

var resultLen;
var fieldCodeArr;
var fieldNameArr;
var fieldTypeArr;
var fieldLengthArr;
var ctrlInfoArr;
var fieldDefValueArr;
var result11Len;
var selSomeArr;


$("#divold").hide() ;
function hiddenSpider()
{
	document.getElementById("mydiv1").style.display='none';
  document.getElementById("mydiv2").style.display='none';
}

$(document).ready(function () {
	//���ؽ�����
	hiddenSpider();
	$('img.closeEl').bind('click', toggleContent);
	$('#nextoper').click(function(){
		var subMethod = "nextoper();";
		$("input[@name=poAttNameLocalFile]").each(function() {
			if (this.value != "") {
	     	subMethod = "doUpload();";
			}
		});
		eval(subMethod);
  });

  $("#CustomerNumberQueryDiv").show();
  $("#CustomerNumberCheckDiv").hide();
  $("#shangpin").hide() ;	
  $("#yuxiao").hide() ;		//yuanqs 100824
  $("#POSpecNumberQueryDiv").hide();
  $("#getProductCode").hide();
  $("#POOrderNumberQueryDiv").hide();
  //add by wangzn start
  $("#p_BusinessMode").change( function() {
  		document.getElementById("mydiv2").style.display='none';
  });
  //add by wangzn end
  
  $("#p_OperType").change( function() {
		deletePpcMsg();
		$("#busNeedDegree").val("");
		$("#notes").val("");
		document.all.busNeedDegree.disabled=false;
		document.all.notes.disabled=false;
  	$("#p_BusinessMode_span").unbind();
  	$("#nextoper").attr("disabled",false);
  	//wuxy add 20110523
  	$("#fee_list").val("");
  	$("#feeInfo").hide();
  	if($("#p_OperType").val()=="0"){
		
		$("#p_Status").val("1");
		document.all.p_Status1.value=document.all.p_Status.value;
		document.all.p_Status.disabled=true;
		$("#p_OrderSourceID").val("0");
		$("#p_OrderSourceID").children().remove();
		$("#p_OrderSourceID").append("<option value=\"0\">ʡBOSS�ϴ�&nbsp;&nbsp;&nbsp;</option>");
		$("#divold").hide() ;
		$("#div1_show").show() ;
		$("#div2_show").show() ;
		$("#CustomerNumberQueryDiv").hide();
		$("#POSpecNumberQueryDiv").show();
		$("#getProductCode").show();
		$("#POOrderNumberQueryDiv").show();
		$("#CustomerNumberCheckDiv").show();
		$("#shangpin").hide() ;	
			controlAddBtn(false);
  	}else if($("#p_OperType").val()=="1"){
		$("#p_OrderSourceID").children().remove();
		$("#p_OrderSourceID").append("<option value=\"\">------������------</option>");
		$("#p_OrderSourceID").append("<option value=\"0\">ʡBOSS�ϴ�</option>");
		$("#p_OrderSourceID").append("<option value=\"1\">EC�ϴ�</option>");
		$("#p_OrderSourceID").append("<option value=\"2\">BBOSS����</option>");		
		$("#CustomerNumberQueryDiv").show();
		$("#POSpecNumberQueryDiv").hide();
		$("#getProductCode").hide();
		$("#POOrderNumberQueryDiv").hide();
		$("#CustomerNumberCheckDiv").hide();	
		$("#shangpin").hide() ;	 		
		$("#divold").hide() ;
		document.all.p_Status.disabled=false;
			controlAddBtn(true);
  	}else if($("#p_OperType").val()=="2"){
		$("#p_Status").val("");
		document.all.p_Status1.value=document.all.p_Status.value;
		document.all.p_Status.disabled=true;
		$("#p_OrderSourceID").children().remove();
		$("#p_OrderSourceID").append("<option value=\"0\">ʡBOSS�ϴ�&nbsp;&nbsp;&nbsp;</option>");
		$("#divold").hide() ;
		$("#shangpin").show() ;
		$("#shangpincaozuo").show();		
		$("#CustomerNumberQueryDiv").show();
		$("#POSpecNumberQueryDiv").hide();
		$("#getProductCode").hide();
		$("#POOrderNumberQueryDiv").hide();
		$("#CustomerNumberCheckDiv").hide();	
		$("#p_operationSubType").val("A"+"|");//��ʼֵ
			controlAddBtn(false);
  	}else if($("#p_OperType").val()=="3"){//add by rendi����һ����ͨ���ܣ�ͬ��ѯ���ܣ�����Ʒ�ʷѷſ�
  		$("#p_OrderSourceID").children().remove();
  		$("#p_OrderSourceID").append("<option value=\"\">------������------</option>");
  		$("#p_OrderSourceID").append("<option value=\"0\">ʡBOSS�ϴ�</option>");
  		$("#p_OrderSourceID").append("<option value=\"1\">EC�ϴ�</option>");
  		$("#p_OrderSourceID").append("<option value=\"2\">BBOSS����</option>");		
  	  	$("#CustomerNumberQueryDiv").show();
  	  	$("#POSpecNumberQueryDiv").hide();
  	  	$("#getProductCode").hide();
  	  	$("#POOrderNumberQueryDiv").hide();
      	$("#CustomerNumberCheckDiv").hide();		 		
  	  	$("#divold").hide() ;
  	  	$("#shangpin").hide() ;	
  	  	document.all.p_Status.disabled=false;
			controlAddBtn(false);
  	}else if($("#p_OperType").val()=="4"||$("#p_OperType").val()=="6"||$("#p_OperType").val()=="7"){//add by lusc����һ���޸Ĺ��ܣ�ȡ����Ʒ��������Ʒ��ͣ�ͻָ����޸���Ʒ������ϵ�Ͳ�Ʒ����		
			controlAddBtn(false);
		$("#p_Status").val("");
		document.all.p_Status1.value=document.all.p_Status.value;
		if(!$("#p_OperType").val()=="6"){
			$("#p_OrderSourceID").children().remove();
			$("#p_OrderSourceID").append("<option value=\"0\">ʡBOSS�ϴ�&nbsp;&nbsp;&nbsp;</option>");
		}
  		$("#divold").show() ;
  		$("#CustomerNumberQueryDiv").show();
  		$("#POSpecNumberQueryDiv").hide();
  		$("#getProductCode").hide();
		$("#POOrderNumberQueryDiv").hide();
		$("#CustomerNumberCheckDiv").hide();	
		$("#shangpin").hide() ;	
		document.all.p_Status.disabled=false;
		
  	  
		//wangzn 2010-4-17 10:11:58
		if($("#p_OperType").val()=="6"||$("#p_OperType").val()=="7"){
			$("#preDeal").show();	
			if('<%=in_ChanceId%>'!=''){
				$("input[@name='OperationSubTypeIDRadio']").each(function()
				{
					$(this).attr("disabled",true);
				});
			}
			if('03'=='<%=busi_req_type%>'){
				$("#shangpin").show() ;	
				$("#divold").hide() ;
			}else{
				$("#shangpin").hide() ;
			}
		
		}else if($("#p_OperType").val()=="4"){
  	  		$("#preDeal").hide();	
  	  		$("#preDeal13").show();	
  	  	}
  	  	
  	  	$("#preDeal0").show() ;
		$("#preDeal1").hide() ;
  	   /*liujian 2012-7-10 15:32:02 ���ù�����Ӧ����Ʒ��ҵ����� begin*/
	  	if($("#p_OperType").val()=="6" || $("#p_OperType").val() == 6) {
	  		$("#divold").show();
	  		$('#shangpincaozuo').hide();
	  		$('#shangpin').show();
	  	}
  		/*liujian 2012-7-10 15:32:02 ���ù�����Ӧ����Ʒ��ҵ����� end */
  	}else if($("#p_OperType").val()=="5"){
			var tableTemp;
			for (var a = 0; a < $("#poAttType").size(); a ++) {
				tableTemp = document.getElementById("poAttachmentMsg").children[0];
				tableTemp.deleteRow(document.getElementsByName("poAttType")[0].parentElement.parentElement.rowIndex);
			}
  	  $("#poAttachmentDiv").hide();
  	  $("#preDeal").show();	
      $("#p_OrderSourceID").children().remove();
      //$("#p_OrderSourceID").append("<option value=\"\">------������------</option>");
  		$("#p_OrderSourceID").append("<option value=\"0\">ʡBOSS�ϴ�</option>");
  		//$("#p_OrderSourceID").append("<option value=\"1\">EC�ϴ�</option>");
  		//$("#p_OrderSourceID").append("<option value=\"2\">BBOSS����</option>");		
  	  $("#CustomerNumberQueryDiv").show();
  	  $("#POSpecNumberQueryDiv").hide();
  	  $("#getProductCode").hide();
  	  $("#POOrderNumberQueryDiv").hide();
      $("#CustomerNumberCheckDiv").hide();
      $("#shangpin").hide() ;
      		
  	  $("#divold").hide() ;
  	  document.all.p_Status.disabled=false;
  	  
			controlAddBtn(false);
  	}else if($("#p_OperType").val()=="8"){
		$("#p_OrderSourceID").children().remove();
		$("#p_OrderSourceID").append("<option value=\"\">------������------</option>");
		$("#p_OrderSourceID").append("<option value=\"0\">ʡBOSS�ϴ�</option>");
		$("#p_OrderSourceID").append("<option value=\"1\">EC�ϴ�</option>");
		$("#p_OrderSourceID").append("<option value=\"2\">BBOSS����</option>");		
		$("#CustomerNumberQueryDiv").show();
		$("#POSpecNumberQueryDiv").hide();
		$("#getProductCode").hide();
		$("#POOrderNumberQueryDiv").hide();
		$("#CustomerNumberCheckDiv").hide();	
		$("#shangpin").show() ;
		$("#shangpincaozuo").hide();					
		$("#divold").show() ;
		$("#preDeal0").hide() ;
		$("#preDeal1").show() ;
		document.all.p_Status.disabled=false;
			controlAddBtn(false);
  	} else {
			controlAddBtn(false);
  	}
  	document.all.p_CustomerNumber.readOnly=false;
  	document.all.p_OrderSourceID.disabled=false;
  	document.all.p_HostCompany.disabled=false;
  	document.all.p_PORatePolicyEffRule.disabled=false;
  	document.all.p_BusinessMode.disabled=false;
  	document.all.POOrderNumberQueryDiv.disabled=false;
  	$("#p_CustomerNumber").val("");
  	$("#p_POOrderNumber").val("");
  	$("#p_POSpecNumber").val("");
  	$("#p_ProductOfferingID").val("");
  	$("#p_OrderSourceID1").val("");
  	$("#p_SICode").val("");
  	$("#p_OrderSourceID").val("");
  	$("#p_HostCompany").val("");
  	$("#p_HostCompany1").val("");
  	$("#p_PORatePolicyEffRule").val("");
  	$("#p_PORatePolicyEffRule1").val("");
  	$("#p_BusinessMode").val("");	
  	$("#p_BusinessMode1").val("");	
  	$("#p_PospecName").val("");
  	$("#p_guidang").val("");
  	$("#product_code").val("");
  	$("#product_code1").val("");
  	$("#product_name").val("");
  	
  	$("div.itemContent").slideUp(30);
	$("img.closeEl").attr({ src: "../../../nresources/default/images/jia.gif"});
  });

  if('05'=='<%=busi_req_type%>'){
  	
  	if('g'=='<%=poorder_type%>'){
  		$("#p_OperType").val(6);
  	}else{
  		$("#p_OperType").val(5);
  	}
  	$("#p_OperType").change();
 	  $("#close_p_OperType").mousemove( function() {
  		 this.setCapture();
    });
    $("#close_p_OperType").mouseout( function() {
  	 	 this.releaseCapture();
    });
    $("#p_CustomerNumber").val("<%=inEcId%>");
    $("#p_CustomerNumber").attr('readOnly','true');
    $("#CustomerNumberQueryDiv").hide();
    $("#p_OrderSourceID").val('1');
    $("#span_OrderSourceID").mousemove( function() {
  		 this.setCapture();
    });
    $("#span_OrderSourceID").mouseout( function() {
  	 	 this.releaseCapture();
    });
    $("#POOrderNumberQueryDiv").click();
    $("#p_POSpecNumber").val('<%=in_pospec_number%>');
    $("#p_PospecName").val('<%=in_productspec_name%>');
    $("#p_POSpecNumber").attr('readOnly','true');
    $("#p_PospecName").attr('readOnly','true');
    $("#getProductCode").show();
    $("#p_BusinessMode").val('3');
    $("#divold").show();
    $("input[@name='OperationSubTypeIDRadio']").each(function()
 	  { 
 	  	$(this).attr("disabled",true);
    	if($(this).val()=="1"){
    		 $(this).attr("checked",true);
    	   doClickRadio(this);
    	}
  	});
  	
    
    //wangzn ����
    //getOrderInfo();
    //checkCustomerNumber();
    $("#p_HostCompany").val('451');
    $("#span_p_HostCompany").mousemove( function() {
  		 this.setCapture();
    });
    $("#span_p_HostCompany").mouseout( function() {
  	 	 this.releaseCapture();
    });
    
    if('g'=='<%=poorder_type%>'){
    	getOrderInfoRtn("<%=Imitation_retInfo%>");
    	$("#getProductCode").hide();
    } else {
			addOtherMsg();
    }
    //wangzn 2011/6/22 10:13:40 add 
    getPoOneTimeFeeStatus('<%=in_pospec_number%>');
    
  }
  if('01'=='<%=busi_req_type%>'){
  	 $("#p_OperType").val(7);
  	 if('g'=='<%=poorder_type%>'){
  	 	  $("#p_OperType").val(6);
  	 }
  	 $("#p_OperType").change();
 	   $("#close_p_OperType").mousemove( function() {
  	 	 this.setCapture();
     });
     $("#close_p_OperType").mouseout( function() {
  	  	 this.releaseCapture();
     });
     $("#CustomerNumberQueryDiv").hide();
  	 getOrderInfoRtn("<%=Imitation_retInfo%>");
  	 
  	 //wangzn 2011/6/24 9:34:54 add 
  	 getPoOneTimeFeeStatus($('#p_POSpecNumber').val());
  }
  if('02'=='<%=busi_req_type%>'){
  	
  	if('g'=='<%=poorder_type%>'){
  		$("#p_OperType").val(6);
  	}else{
  		$("#p_OperType").val(4);
  	}
  	$("#p_OperType").change();
 	  $("#close_p_OperType").mousemove( function() {
  		 this.setCapture();
    });
    $("#close_p_OperType").mouseout( function() {
  	 	 this.releaseCapture();
    });
    $("#CustomerNumberQueryDiv").hide();
  	 getOrderInfoRtn("<%=Imitation_retInfo%>");
  	 
  
  	$("input[@name='OperationSubTypeIDRadio']").each(function()
 	  { 
 	  	$(this).attr("disabled",true);
    	if($(this).val()=="9"){
    		 $(this).attr("checked",true);
    	   doClickRadio(this);
    	}
  	});
  	
  }
  if('06'=='<%=busi_req_type%>'){
  	
  	if('g'=='<%=poorder_type%>'){
  		$("#p_OperType").val(6);
  	}else{
  		$("#p_OperType").val(4);
  	}
  	$("#p_OperType").change();
 	  $("#close_p_OperType").mousemove( function() {
  		 this.setCapture();
    });
    $("#close_p_OperType").mouseout( function() {
  	 	 this.releaseCapture();
    });
    $("#CustomerNumberQueryDiv").hide();
  	 getOrderInfoRtn("<%=Imitation_retInfo%>");
  	 
  
  	$("input[@name='OperationSubTypeIDRadio']").each(function()
 	  { 
 	  	$(this).attr("disabled",true);
    	if($(this).val()=="5"){
    		 $(this).attr("checked",true);
    	   doClickRadio(this);
    	}
  	});
  	
  }
  
  
  if('03'=='<%=busi_req_type%>'){
  	
  	if('g'=='<%=poorder_type%>'){
  		$("#p_OperType").val(6);
  	}else{
  		$("#p_OperType").val(2);
  	}
  	$("#p_OperType").change();
 	  $("#close_p_OperType").mousemove( function() {
  		 this.setCapture();
    });
    $("#close_p_OperType").mouseout( function() {
  	 	 this.releaseCapture();
    });
    $("#CustomerNumberQueryDiv").hide();
  	 getOrderInfoRtn("<%=Imitation_retInfo%>");
  	 
  
  	$("input[@name='OperationSubTypeIDRadio']").each(function()
 	  { 
 	  	$(this).attr("disabled",true);
    	if($(this).val()=="A"){
    		 $(this).attr("checked",true);
    		 //$(this).parent.parent.parent.show();
    	   doClickRadio(this);
    	}
  	});
  	
  }
  
  //wanghfa
	$("#poAttachment_switch").bind('click', function() {
		if (this.state == "open") {
			$("#poAttachmentMsg").slideUp(300);
			$("#poAttachment_switch").attr({src: "../../../nresources/default/images/jia.gif"});
			this.state = "close";
		} else if (this.state == "close") {
			$("#poAttachmentMsg").slideDown(300);
			$("#poAttachment_switch").attr({src: "../../../nresources/default/images/jian.gif"});
			this.state = "open";
		}
	});
	$("#poAudit_switch").bind('click', function() {
		if (this.state == "open") {
			$("#poAuditMsg").slideUp(300);
			$("#poAudit_switch").attr({src: "../../../nresources/default/images/jia.gif"});
			this.state = "close";
		} else if (this.state == "close") {
			$("#poAuditMsg").slideDown(300);
			$("#poAudit_switch").attr({src: "../../../nresources/default/images/jian.gif"});
			this.state = "open";
		}
	});
	$("#contactorInfo_switch").bind('click', function() {
		if (this.state == "open") {
			$("#contactorInfoMsg").slideUp(300);
			$("#contactorInfo_switch").attr({src: "../../../nresources/default/images/jia.gif"});
			this.state = "close";
		} else if (this.state == "close") {
			$("#contactorInfoMsg").slideDown(300);
			$("#contactorInfo_switch").attr({src: "../../../nresources/default/images/jian.gif"});
			this.state = "open";
		}
	});

});

var toggleContent = function(e)
{
    if($("#p_OperType").val() == '2' || $("#p_OperType").val() == '4'||$("#p_OperType").val() == '6'){
        if(getRadiosVal(document.all.OperationSubTypeIDRadio) == "no"){
            rdShowMessageDialog("��ѡ����Ʒ��ҵ�����!",0);
            return false;
        }
    }
	var targetContent = $( 'DIV.itemContent',this.parentNode.parentNode.parentNode);
	if (targetContent.css('display') == 'none') {	  
		   targetContent.slideDown(300);
		   $(this).attr({ src: "../../../nresources/default/images/jian.gif"});
		   //���÷���
		   try{
		   	var tmp = $(this).attr('id');
		   	var tmp2 = eval("_jspPage."+tmp);
		   	if(tmp2[2]=="f"&&tmp2[1]!=''&&tmp2[1]!=undefined)
		   	{
		   		$("#"+tmp2[0]).load(tmp2[1],{sPOOrderNumber:$("#p_POOrderNumber").val()
		   			                          ,sPOSpecNumber:$("#p_POSpecNumber").val()
		   			                          ,p_OperType:$("#p_OperType").val()
		   			                          ,p_operationSubType:$("#p_operationSubType").val()//add by lusc
		   			                          ,p_BusinessMode:$("#p_BusinessMode").val() //add by wangzn
		   			                          ,OperationSubTypeIDRadio:getRadiosVal(document.all.OperationSubTypeIDRadio)
		   			                          ,in_productspec_number:'<%=in_productspec_number%>'
		   			                          ,in_ChanceId:'<%=in_ChanceId%>'
		   			                          ,poorder_type:'<%=poorder_type%>'
		   			                          });
		   	  //$('#ProductsAdd').click();
		   		//tmp2[2]="t";
		   	}
		   }catch(e)
		   {		   	
		   }
	} else {
		targetContent.slideUp(300);
		$(this).attr({ src: "../../../nresources/default/images/jia.gif"});
	}
	return false;
};

//���ж�����Ϣѡ��----------------------------------
function getOrderInfo()
{
	//wuxy alter 20100203 ������Ʒ������������־PoOprFlag 1���� 0����
    var pageTitle = "������Ϣ";
    var fieldName = "������Դ|EC���ſͻ�����|��Ʒ������|��Ʒ�����|��Ʒ������ϵID|����ʡ|�ײ���Ч����|����״̬|ҵ��չģʽ|����������|��Ʒ�������|�鵵״̬|��Ʒ�ʷ�����|��Ʒ�ʷѱ��|��Ʒ��������־|��Ʒ����������|ҵ���ϵȼ�|��ע|";
    var sqlStr = "";
    var selType = "S";//'S'��ѡ��'M'��ѡ
    var retQuence = "18|0|1|2|3|4|5|6|7|8|9|14|15|17|16|20|21|22|23|";

    var retToField = "p_OrderSourceID|p_CustomerNumber|p_POOrderNumber|p_POSpecNumber|p_ProductOfferingID|p_HostCompany|p_PORatePolicyEffRule|p_Status|p_BusinessMode|p_SICode|p_PospecName|p_guidang|product_name|product_code|PoOprFlag|OperationSubTypeIDRadio|busNeedDegree|notes|";

    var path = "<%=request.getContextPath()%>/npage/s2002/f2029_getOrderInfo.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName="+fieldName;
    path = path + "&selType="+selType;
    path = path + "&retQuence="+retQuence;
    path = path + "&retToField="+retToField;
    path = path + "&sOrderSourceID=" +$("#p_OrderSourceID").val();
    path = path + "&sCustomerNumber="+$("#p_CustomerNumber").val();
    path = path + "&sPOOrderNumber=" +$("#p_POOrderNumber").val();
    path = path + "&sPOSpecNumber="+$("#p_POSpecNumber").val();
    path = path + "&sProductOfferingID="+$("#p_ProductOfferingID").val();
    path = path + "&sHostCompany="+$("#p_HostCompany").val();
    path = path + "&sPORatePolicyEffRule="+$("#p_PORatePolicyEffRule").val();
    path = path + "&p_OperType="+$("#p_OperType").val();
    //wangzn ����
    //alert(path);
    retInfo = window.open(path,
                          "newwindow",
                          "height=450, width=900,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
    return true;
}
function getOrderInfoRtn(retInfo)
{  
	
    var retToField = "p_OrderSourceID|p_CustomerNumber|p_POOrderNumber|p_POSpecNumber|p_ProductOfferingID|p_HostCompany|p_PORatePolicyEffRule|p_Status|p_BusinessMode|p_SICode|p_PospecName|p_guidang|product_name|product_code|PoOprFlag|p_operationSubType|busNeedDegree|notes|";
    
    if (retInfo == undefined)
    {
        return false;
    }
    //alert(retInfo);
    var chPos_field = retToField.indexOf("|");
    var chPos_retStr;
    var valueStr;
    var obj;
    while (chPos_field >-1)
    {
        obj = retToField.substring(0, chPos_field);
        chPos_retInfo = retInfo.indexOf("|");
        valueStr = retInfo.substring(0, chPos_retInfo);
        document.all(obj).value = valueStr;
        if(obj=="p_operationSubType"){
        	$("input[@name='OperationSubTypeIDRadio']").each(function()
 	        { if($(this).val()==valueStr){
 	        	  $(this).attr("checked",true);
 	          }
 	        });
        }
       // alert("ww"+document.all(obj).value);
        
        retToField = retToField.substring(chPos_field + 1);
        retInfo = retInfo.substring(chPos_retInfo + 1);
        chPos_field = retToField.indexOf("|");
    }
    if($("#p_OperType").val()=="1")
    {
    	
    	document.all.p_OrderSourceID1.value=document.all.p_OrderSourceID.value;
    	document.all.p_OrderSourceID.disabled=true;
    	document.all.p_CustomerNumber.readOnly=true;
    	document.all.p_HostCompany1.value=document.all.p_HostCompany.value;
    	document.all.p_HostCompany.disabled=true;
    	document.all.p_PORatePolicyEffRule1.value=document.all.p_PORatePolicyEffRule.value;
    	document.all.p_PORatePolicyEffRule.disabled=true;
    	document.all.p_Status1.value=document.all.p_Status.value;
    	document.all.p_Status.disabled=true;
    	document.all.p_BusinessMode1.value=document.all.p_BusinessMode.value;
    	document.all.p_BusinessMode.disabled=true;
    	document.all.busNeedDegree.disabled=true;
    	document.all.notes.disabled=true;
    }else if($("#p_OperType").val()=="2"){
    	
    	document.all.p_CustomerNumber.readOnly=true;
    	document.all.p_Status1.value=document.all.p_Status.value;
    	document.all.p_Status.disabled=true;
    }else if($("#p_OperType").val()=="3" && $("#product_code").val() == ""){
        $("#getProductCode").show();
    }else if($("#p_OperType").val()=="8"){
    	document.all.p_OrderSourceID1.value=document.all.p_OrderSourceID.value;
    	document.all.p_OrderSourceID.disabled=true;
    	document.all.p_CustomerNumber.readOnly=true;
    	document.all.p_HostCompany1.value=document.all.p_HostCompany.value;
    	document.all.p_HostCompany.disabled=true;
    	document.all.p_PORatePolicyEffRule1.value=document.all.p_PORatePolicyEffRule.value;
    	document.all.p_PORatePolicyEffRule.disabled=true;
    	document.all.p_Status1.value=document.all.p_Status.value;
    	document.all.p_Status.disabled=true;
    	document.all.p_BusinessMode1.value=document.all.p_BusinessMode.value;
    	document.all.p_BusinessMode.disabled=true;
    	$("input[@name='OperationSubTypeIDRadio']").each(function(){
 	          $(this).attr("disabled",true);
		});
    	
    }
    $("div.itemContent").slideUp(30);
	$("img.closeEl").attr({ src: "../../../nresources/default/images/jia.gif"});
	//yuanqs add 100824
	if("01114001" == $("#p_POSpecNumber").val()) {
		$("#yuxiao").show();
		$("#yuxiao1").hide();
	}
	addOtherMsg();
}

function addOtherMsg() {
	//wanghfa
  <%
	if (result9103_5 != null && result9103_5.length > 0) {
		for (int i = 0; i < result9103_5.length; i ++) {
			%>
			addRow("poAuditMsg", "<%=result9103_5[i][0]%>", "<%=result9103_5[i][1]%>", "<%=result9103_5[i][2]%>", "", "1");
			<%
		}
		%>
		$("#poAuditMsg").slideDown(300);
		$("#poAudit_switch").attr({src: "../../../nresources/default/images/jian.gif"});
		$("#poAudit_switch").attr("state", "open");
		<%
	}
	if (result9103_6 != null && result9103_6.length > 0) {
		for (int i = 0; i < result9103_6.length; i ++) {
			%>
			addRow("contactorInfoMsg", "<%=result9103_6[i][0]%>", "<%=result9103_6[i][1]%>", "<%=result9103_6[i][2]%>", "", "1");
			<%
		}
	}
  %>
	addRow("contactorInfoMsg", "5", "<%=workName%>", "", "", "1");
	$("#contactorInfoMsg").slideDown(300);
	$("#contactorInfo_switch").attr({src: "../../../nresources/default/images/jian.gif"});
	$("#contactorInfo_switch").attr("state", "open");
	
	/*var packet = new AJAXPacket("f2029_getPpcMsg.jsp", "���Ժ�......");
	packet.data.add("p_POOrderNumber", $("#p_POOrderNumber").val());
	packet.data.add("OperationSubTypeIDRadio", $("input[@name='OperationSubTypeIDRadio'][@checked]").val());
	core.ajax.sendPacketHtml(packet, doGetPpcMsg, true);
	packet =null;*/
}
function doGetPpcMsg(data) {
	//alert(data);
	deletePpcMsg();
	eval(data.trim());
}
function deletePpcMsg() {
	var tableTemp;
	var no;
	no = $("input[@name=auditor]").size();
	for (var a = 0; a < $("input[@name=auditor]").size(); a ++) {
		tableTemp = document.getElementById("poAuditMsg").children[0];
		tableTemp.deleteRow(1);
	}
	no = $("input[@name=contactorName]").size();
	for (var a = 0; a < no; a ++) {
		tableTemp = document.getElementById("contactorInfoMsg").children[0];
		tableTemp.deleteRow(1);
	}
	no = $("input[@name=poAttCode]").size();
	for (var a = 0; a < $("input[@name=poAttCode]").size(); a ++) {
		tableTemp = document.getElementById("poAttachmentMsg").children[0];
		tableTemp.deleteRow(1);
	}
}

//��ȡ������
function getUserId()
{
	//�õ����Ų�ƷID���͸����û�IDһ��
	var packet = new AJAXPacket("f2029_getOrderId.jsp","���Ժ�......");
 	packet.data.add("idType","1");
    core.ajax.sendPacket(packet);
	packet =null;	
    
    
}



//---------------------------------------------------------------------------------------------------------


//Ч��EC���ſͻ�����-------------------------------------------------------
function checkCustomerNumber()
{ 	
	var packet = new AJAXPacket("f2029_checkCustomerNumber_ajax.jsp","���Ժ�......");
 	packet.data.add("sCustomerNumber",$("#p_CustomerNumber").val());
  core.ajax.sendPacket(packet);
	packet =null;		
}
/*У��EC���ſͻ������getPoOneTimeFeeStatus�����ص�����*/
function doProcess(packet)
{
	
   var retFlag = packet.data.findValueByName("retFlag");
   var ordernumber=packet.data.findValueByName("ordernumber");
   /*getPoOneTimeFeeStatus�����ص�����
   gaopeng 20121120 ȫ��ҵ��չģʽ������洦��
   */
   if(retFlag=="11")
   {
   	  /* add by wuxy @ 20110523 for ��̬չʾ������Ϣ */
   	  resultLen = packet.data.findValueByName("resultLen");
   	  fieldCodeArr = packet.data.findValueByName("fieldCodeArr");
      fieldNameArr = packet.data.findValueByName("fieldNameArr");
      fieldTypeArr = packet.data.findValueByName("fieldTypeArr");
      fieldLengthArr = packet.data.findValueByName("fieldLengthArr");
      ctrlInfoArr = packet.data.findValueByName("ctrlInfoArr");
      fieldDefValueArr = packet.data.findValueByName("fieldDefValueArr");
      result11Len=packet.data.findValueByName("result11Len");
      selSomeArr=packet.data.findValueByName("selSomeArr");
      
      if(resultLen>0){
          var codeTmp = "";
          for(var ii=0;ii<resultLen;ii++){
              var colspan = 1;
              if(ii == resultLen-1 && (resultLen+1)%2!=0){
                  colspan = 3;
              }
              if((ii+1)%2!=0){
                  codeTmp += "<tr>";
              }
              codeTmp += "<td class='blue'>"+fieldNameArr[ii]+"</td>";
              codeTmp += "<td colspan='"+colspan+"'>";
              if(fieldTypeArr[ii] == "13"){   // ���
              	if (fieldCodeArr[ii] == "10354") {
                  codeTmp += "<input type='text' id='F"+fieldCodeArr[ii]+"' name='F"+fieldCodeArr[ii]+"' maxlength='10' value='"+fieldDefValueArr[ii]+"' v_type='cfloat' v_maxlength='7.2' onblur='if(this.value!=\"\" && !forMoney(this)){return false;}'/>";
              	} else {
                  codeTmp += "<input type='text' id='F"+fieldCodeArr[ii]+"' name='F"+fieldCodeArr[ii]+"' maxlength='"+fieldLengthArr+"' value='"+fieldDefValueArr[ii]+"' onblur='if(this.value!=\"\" && !forMoney(this)){return false;}'/>";
              	}
              }
              if(ctrlInfoArr[ii] == "N"){
                  codeTmp += "&nbsp;<font class='orange'>*</font>";
              }
              codeTmp += "</td>";
              if((ii+1)%2==0){
                  codeTmp += "</tr>";
              }
          }
          $("#feeInfo").html(codeTmp);
          $("#feeInfo").show();
      }
      /*gaopeng ��洦�� ��ѯ����ǰѡ�����Ʒ�����  ���Կ�����Щ ҵ��չģʽ */
      if(result11Len>0)
      {
      	
      	var allStr="";
      	for(var jj=0;jj<result11Len;jj++)
      	{
      		if(allStr.length==0)
      		{
      			allStr=selSomeArr[jj];
      		}
      		else
      			{
      				allStr=allStr+","+selSomeArr[jj];
      			}
      	}
      	
      	/*����������ʾ��ȥ�� ��洦�� ��ѯ����ǰѡ�����Ʒ����� gaopeng*/
      	$("#p_BusinessMode").find("option").each(function()
      	{
      		var thisOption= $(this);
      		if(thisOption.val().length!=0)
      		{
      			if(allStr.indexOf(thisOption.val())==-1)
      			{
      				thisOption.remove();
      			}
      			
      		}
      	});
      	
      	if('05'=='<%=busi_req_type%>')
      	{
      		$("#p_BusinessMode").val(3);
      	}
      	
      }
      
      
   			
	
   }else
   {
   		if(ordernumber==""){
   	
   		if(retFlag=="0")   	
   		{
   	 		rdShowMessageDialog("EC���ſͻ�������֤�ɹ�!",2);
   	 		document.all.flag.value="1";
   	 		unitName = packet.data.findValueByName("unitName");
   	 		$("#unitName").val(unitName);
   		}else{
   	 			rdShowMessageDialog("EC���ſͻ�����Ч��ʧ��!",0);
   				}
   		 }
		else {
   		if(retFlag=="0")   	
    	{
   	 		document.all.p_POOrderNumber.value=ordernumber;
   	 		document.all.POOrderNumberQueryDiv.disabled=true;
     	}else {
   	    rdShowMessageDialog("��ȡ������ʧ��!",0);
     	}
   		}
	}
}
//--------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------
function getPOSpecNumber(){	  
	  var pageTitle = "";
    var fieldName = "��Ʒ�����|";
    var sqlStr = "";
    var selType = "S";//'S'��ѡ��'M'��ѡ
    var retQuence = "5|0|1|5|6|7|";

    var retToField = "p_POSpecNumber|p_PospecName|sm_code|biz_type_L|biz_type_S|";

    var path = "<%=request.getContextPath()%>/npage/s2002/f2029_getPOSpecNumber_list.jsp";
    path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
    path = path + "&fieldName="+fieldName;
    path = path + "&selType="+selType;
    path = path + "&retQuence="+retQuence;
    path = path + "&retToField="+retToField;
    path = path + "&sPOSpecNumber=" +$("#p_POSpecNumber").val();
    
    retInfo = window.open(path,
                          "newwindow",
                          "height=400, width=700,top=300,left=350,scrollbars=yes, resizable=no,location=no, status=yes");
    return true;
}
//wuxy add 20110523
/*gaopeng ȫ��ҵ��չģʽ������洦��20121120*/
function getPoOneTimeFeeStatus(Pospec_number)
{
	//alert("wuxy="+Pospec_number);
	var packet = new AJAXPacket("f2029_getPoOneTimeFeeStatus.jsp","���Ժ�......");
 	packet.data.add("PospecNumber",Pospec_number);
    core.ajax.sendPacket(packet);
	packet =null;	
}

function getPOSpecNumberRtn(retInfo)
{
    var retToField = "p_POSpecNumber|p_PospecName|sm_code|biz_type_L|biz_type_S|";
    if (retInfo == undefined)
    {
        return false;
    }
    var chPos_field = retToField.indexOf("|");
    var chPos_retStr;
    var valueStr;
    var obj;
  
    while (chPos_field >-1)
    {
        obj = retToField.substring(0, chPos_field);
        chPos_retInfo = retInfo.indexOf("|");
        valueStr = retInfo.substring(0, chPos_retInfo);
        document.all(obj).value = valueStr;
        retToField = retToField.substring(chPos_field + 1);
        retInfo = retInfo.substring(chPos_retInfo + 1);
        chPos_field = retToField.indexOf("|");
    }
    $("div.itemContent").slideUp(30);
	$("img.closeEl").attr({ src: "../../../nresources/default/images/jia.gif"});
    
}


//------------------------------------------------------------------------------------------------------------	       


/**�����ѡ���ʱ����õĺ���**/
function doClickChkBox(chkbox){
	var radios = document.getElementsByName("OperationSubTypeIDRadio");
	
	//�������е�radio,��ѡȡ���һ��checkbox��ʱ��,ȡ��ѡ�����е�radio
	for(var i=0;i<radios.length;i++){
		if(radios[i].checked){
			radios[i].checked = false;
		}	
	}
	////////////add by lusc 2009-4-9
	$("#p_operationSubType").val("");
	var chkBoxs = document.getElementsByName("OperationSubTypeIDChkBox");
	for(var i=0;i<chkBoxs.length;i++){
		if(chkBoxs[i].checked){
			$("#p_operationSubType").val($("#p_operationSubType").val()+chkBoxs[i].value+"|");//modify 2009-04-09
		}	
	}
	if($("#p_operationSubType").val().match("2")==null&&$("#p_operationSubType").val().match("7")==null){
		$("#products_buttontr").hide();	
	}else {
		$("#products_buttontr").show();	
	}

}

/**�����ѡ���ʱ����õĺ���**/
function doClickRadio(radio)
{
    $("#nextoper").attr("disabled",false);
	var chkBoxs = document.getElementsByName("OperationSubTypeIDChkBox");
	
	//�������е�checkbox,��ѡȡ���һ��radio��ʱ��,ȡ��ѡ�����е�checkbox
	for(var i=0;i<chkBoxs.length;i++){
		if(chkBoxs[i].checked){
			chkBoxs[i].checked = false;
		}	
	}
	////////////add by lusc 2009-4-9
	var radios = document.getElementsByName("OperationSubTypeIDRadio");
	
	for(var i=0;i<radios.length;i++){
		if(radios[i].checked){
			$("#p_operationSubType").val(radios[i].value+"|");
			break;
		}	
	}
	if($("#p_operationSubType").val().match("2")==null&&$("#p_operationSubType").val().match("7")==null){
		$("#products_buttontr").hide();	
	}else {
		$("#products_buttontr").show();	
	}
		document.getElementById("mydiv2").style.display='none';
		$("img.closeEl").attr({ src: "../../../nresources/default/images/jia.gif"});
}



function testFun(){//test by wangzn 090927
	var dataConsult = '';
	$.each($(".ProductOrder_contenttr"), function(k){
		  var ProductOrder_15 = $(this).data("a_POProductOrderCharacterList");
		  if(ProductOrder_15!=undefined){
			  for(var i=0;i<ProductOrder_15.length;i++){
			  	//for(var j=0;j<ProductOrder_15[i].length;j++){
			  	//	dataConsult +=ProductOrder_15[i][j];
			  	//	if(j==ProductOrder_15[i].length-1){
			  	//		break;
			  	//	}
			  	//	dataConsult += '^';
			  	//}
			  	dataConsult = dataConsult + ProductOrder_15[i][0] +'^'+ ProductOrder_15[i][1]+'^' + ProductOrder_15[i][2] +'^' + ProductOrder_15[i][7] + '^' + ProductOrder_15[i][11];
			  	if(i==ProductOrder_15.length-1){
			  		break;
			  	}
			  	dataConsult += '$';
			  	
			  }
     }
		dataConsult += '~';
		//alert(k);
	});
	
	if($("#p_OperType").val() == "4" && $("#p_POSpecNumber").val() == "01114001"){
	    getDataConsult();
	    dataConsult = $("#data_consult").val();
	}
	if($("#p_OperType").val() == "4" && $("#p_POSpecNumber").val() != "01114001"){
	    dataConsult = "";
	}
	
	return dataConsult;
}

function getDataConsult(){
    var packet = new AJAXPacket("f2029_getDataConsult.jsp","���Ժ�...");
    packet.data.add("poorder_id" ,$("#p_POOrderNumber").val());
    packet.data.add("productspec_number" ,"411501");
    core.ajax.sendPacket(packet,doGetDataConsult);
    packet =null;
}

function doGetDataConsult(packet){
    var dataConsultTmp = packet.data.findValueByName("dataConsultTmp") + "~";
    $("#data_consult").val(dataConsultTmp);
}

function getInfo_Prod2()
{
    if($("#p_POSpecNumber").val() == ""){
        rdShowMessageDialog("���Ȳ�ѯ��Ʒ����ţ�",0);
        $("#POSpecNumberQueryDiv").focus();
        return false;
    }
    
    /*
    var temp1="2" ;//[S][]  //��Ʒ����
    var temp2=$("#sm_code").val();//[T][]  //Ʒ��
    var temp3=document.all.p_POSpecNumber.value;//[V][]  //ҵ������ --
    var temp4="" ;//[W][]  //ҵ�����
    var targeturl="bizModeTree.jsp?ProdType="+temp1+"&sm_code="+temp2+"&prod_direct="+temp3+"&biz_code="+temp4;
    
    win=window.open(targeturl,'_blank','height=500,width=300,scrollbars=no');
    */
    
    var pageTitle = "���Ų�Ʒѡ��";
    var fieldName = "";
    var retQuence = "";
    var retToField = "";

    fieldName = "��Ʒ����|��Ʒ����|";
    retQuence = "2|3|4|";
    retToField = "product_code|product_name|";

	var sqlStr = "";
    var selType = "S";//'S'��ѡ��'M'��ѡ

    if(PubSimpSelProd(pageTitle,fieldName,sqlStr,selType,retQuence,retToField));
}

function PubSimpSelProd(pageTitle,fieldName,sqlStr,selType,retQuence,retToField){
    var product_code = document.all.product_code.value;
	var path = "<%=request.getContextPath()%>/npage/s2002/fpubprod_sel.jsp";
	path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
	path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
	path = path + "&selType=" + selType;
	path = path + "&showType=" + "Default";
	path = path + "&op_code=" + document.all.op_code.value;
	path = path + "&sm_code=" + $("#sm_code").val();
	path = path + "&product_code=" + product_code;
	path = path + "&grp_id=" ;
	path = path + "&bizTypeL=" + ($("#biz_type_L").val()==null?'':$("#biz_type_L").val());
	path = path + "&bizTypeS=" + ($("#biz_type_S").val()==null?'':$("#biz_type_S").val());
	path = path + "&biz_code=" +document.all.p_POSpecNumber.value;

    retInfo = window.open(path,"newwindow","height=450, width=800,top=50,left=200,scrollbars=yes, resizable=no,location=no, status=yes");
	return true;
}

function getValueProd2(retInfo, retInfoDetail){
    var retToField = "";
    retToField = "product_code|product_name|";
	if(retInfo ==undefined)      
    {   return false;}

    var chPos_field = retToField.indexOf("|");
    var chPos_retStr;
    var valueStr;
    var obj;
    while(chPos_field >-1)
    {
        obj = retToField.substring(0,chPos_field);
        chPos_retInfo = retInfo.indexOf("|");
        valueStr = retInfo.substring(0,chPos_retInfo);
        document.all(obj).value = valueStr;
        retToField = retToField.substring(chPos_field + 1);
        retInfo = retInfo.substring(chPos_retInfo + 1);
        chPos_field = retToField.indexOf("|");
    }
    
    $("#product_code1").val($("#product_name").val());
}
function doUpload(){
	document.form1.target="hidden_frame";
  document.form1.encoding="multipart/form-data";
  document.form1.action="f2029_upload.jsp";
  document.form1.method="post";
  document.form1.submit();
  $("#sure").attr("disabled",true);
  loading();
}
function doUnLoading(){
  unLoading();
}

function addRow(msgId, msg1, msg2, msg3, msg4, delFlag) {
	var greyStr = "";
	var operType = $("#p_OperType").val();
	if (operType == "1") {	//operType != "0" && operType != "5"
		greyStr = " class = 'InputGrey' readOnly ";
	} else {
		greyStr = "";
	}
	if (typeof msg1 == "undefined") {
		msg1 = "";
	} else if (typeof msg2 == "undefined") {
		msg2 = "";
	} else if (typeof msg3 == "undefined") {
		msg3 = "";
	} else if (typeof msg4 == "undefined") {
		msg4 = "";
	}
	var trTemp = document.getElementById(msgId).children[0].insertRow();
	if (msgId == "poAuditMsg") {	//һ��ҵ��������Ϣ
		trTemp.insertCell().innerHTML = "<input type='text' name='auditor' value='' v_must='1' maxlength='40' v_type='string' v_maxlength='40'" + greyStr + "/>";
		trTemp.insertCell().innerHTML = "<input type='text' name='auditTime' value='' v_must='1' v_type='dateTime' maxlength='14'" + greyStr + "/>";
		trTemp.insertCell().innerHTML = "<input type='text' name='custName' size='40' value='' maxlength='500' v_maxlength='1000' " + greyStr + "/>";
		$("input[name=auditor]:last").val(msg1);
		$("input[name=auditTime]:last").val(msg2);
		$("input[name=custName]:last").val(msg3);
	} else if (msgId == "contactorInfoMsg") {	//һ����Ʒ��������ϵ����Ϣ
		var var1 = "<option value='1'>�ͻ���Ʒ��ϵ��</option>";
		var var2 = "<option value='2'>�ͻ�����</option>";
		var var3 = "<option value='3'>��Ʒ֧����Ա</option>";
		var var4 = "<option value='4'>�ܲ����Ͳ���ϵ��</option>";
		var var5 = "<option value='5'>�����ύ��Ա</option>";
		if (msg1 == "1") {
			var1 = "<option value='1' selected>�ͻ���Ʒ��ϵ��</option>";
		} else if (msg1 == "2") {
			var2 = "<option value='2' selected>�ͻ�����</option>";
		} else if (msg1 == "3") {
			var3 = "<option value='3' selected>��Ʒ֧����Ա</option>";
		} else if (msg1 == "4") {
			var4 = "<option value='4' selected>�ܲ����Ͳ���ϵ��</option>";
		} else if (msg1 == "5") {
			var5 = "<option value='5' selected>�����ύ��Ա</option>";
		}
		if (greyStr != "") {
			trTemp.insertCell().innerHTML = "<select name='contactorType' disabled>" + var1 + var2 + var3 + var4 + var5 + "</select>";
		} else {
		trTemp.insertCell().innerHTML = "<select name='contactorType'>" + var1 + var2 + var3 + var4 + var5 + "</select>";
		}
		trTemp.insertCell().innerHTML = "<input type='text' name='contactorName' value='' v_must='1' maxlength='64' v_type='string' v_maxlength='64' " + greyStr + "/>";
		trTemp.insertCell().innerHTML = "<input type='text' name='contactorPhone' value='' v_must='1' maxlength='64' v_type='string' v_maxlength='64' " + greyStr + "/>";
		//$("input[name=contactorType]:last").val(msg1);
		$("input[name=contactorName]:last").val(msg2);
		$("input[name=contactorPhone]:last").val(msg3);
	} else if (msgId == "poAttachmentMsg") {	//һ����Ʒ������Ӧ�ĸ�����Ϣ
		var var1 = "<option value='1'>��ͬ����</option>";
		var var2 = "<option value='2'>��ͨ����</option>";
		if (msg1 == "1") {
			var1 = "<option value='1' selected>��ͬ����</option>";
			greyStr = " class = 'InputGrey' readOnly ";
		} else if (msg1 == "2") {
			var2 = "<option value='2' selected>��ͨ����</option>";
			greyStr = " class = 'InputGrey' readOnly ";
		} else {
			greyStr = "";
		}
		if (greyStr != "") {
			trTemp.insertCell().innerHTML = "<select disabled>" + var1 + var2 + "</select>"
				 + "<input type='hidden' name='poAttType' value='" + msg1 + "'>";
		} else {
			trTemp.insertCell().innerHTML = "<select name='poAttType'>" + var1 + var2 + "</select>";
		}
		trTemp.insertCell().innerHTML = "<input type='text' name='poAttCode' value='' maxlength='100' v_type='string' v_maxlength='100' " + greyStr + "/>";
		//trTemp.insertCell().innerHTML = "<input type='text' name='contName' size='30' value='' v_must='1' maxlength='256' v_type='string' v_maxlength='256'/>";
		trTemp.insertCell().innerHTML = "<input type='text' name='contName' value='' size='30' class='InputGrey' readOnly/>";
		//$("input[name=poAttType]:last").val(msg1);
		$("input[name=poAttCode]:last").val(msg2);
		$("input[name=contName]:last").val(msg3);
		
		
		
		if (greyStr != "") {
			trTemp.insertCell().innerHTML = "<input type='text' name='poAttName' size='30' value='" + msg4 + "' class='InputGrey' readOnly/>"
			 + "<input type='hidden' name='poAttNameFile' value=''/>";
		} else {
		trTemp.insertCell().innerHTML = "<input type='file' name='poAttNameLocalFile' value='' class='button' style='border-style:solid;border-color:#7F9DB9;border-width:1px;font-size:12px;'/>"
			 + "<input type='hidden' name='poAttNameFile' value=''/>"
			 + "<input type='hidden' name='poAttName' value=''/>";
		}
		//trTemp.insertCell().innerHTML = "<input type='text' name='attachment' value='' maxlength='128' v_maxlength='128' />";
		
		
			
	//��ͬ��ʼ����
	trTemp.insertCell().innerHTML = "<input type='text' name='ContEffdate' maxlength='8' value='' v_type='date' onblur='checkElement(this)' />";
	//��ͬ��������
	trTemp.insertCell().innerHTML = "<input type='text' name='ContExpdate' maxlength='8' value='' v_type='date' onblur='checkElement(this)' />";
	//�Ƿ��Զ���Լ
	trTemp.insertCell().innerHTML = "<select name='IsAutoRecont'><option value=''>--��ѡ��--</option><option value='1'>��</option><option value='0'>��</option></select>";
	//��Լ����ʱ��
	trTemp.insertCell().innerHTML = "<input type='text' name='RecontExpdate' maxlength='8' value='' v_type='date' onblur='checkElement(this)' />";
	//ǩԼ�ʷ�
	trTemp.insertCell().innerHTML = "<input type='text' name='ContFee' maxlength='512' value='' v_type='string' onblur='checkElement(this)' />";
	//�Żݷ���
	trTemp.insertCell().innerHTML = "<input type='text' name='PerferPlan' maxlength='512'  value='' v_type='string' onblur='checkElement(this)' />";
	//�Զ���Լ����
	trTemp.insertCell().innerHTML = "<select name='AutoRecontCyc'><option value=''>--��ѡ��--</option><option value='����'>����</option><option value='������'>������</option><option value='������'>������</option><option value='����'>����</option></select>";
	//�Ƿ�Ϊ��ǩ��ͬ
	trTemp.insertCell().innerHTML = "<select name='IsRecont'><option value=''>--��ѡ��--</option><option value='1'>��</option><option value='0'>��</option></select>";
	

	
	}

	if (delFlag == "1") {
		trTemp.insertCell().innerHTML = "<input type='button' class='b_text' name='' id='' value='ɾ��' onclick='deleteRow(\"" + msgId + "\", this)' disabled/>";
	} else {
		trTemp.insertCell().innerHTML = "<input type='button' class='b_text' name='' id='' value='ɾ��' onclick='deleteRow(\"" + msgId + "\", this)' />";
	}
	
	
	
}

function deleteRow(msgId, obj) {
	var tableTemp = document.getElementById(msgId).children[0];
	tableTemp.deleteRow(obj.parentElement.parentElement.rowIndex);
}

function upLoadSuccess(i, vPoAttNameFile, vPoAttName, vContName) {
	//alert(i + ", " + vPoAttNameFile + ", " + vPoAttName);
	document.getElementsByName("poAttNameFile")[i].value = vPoAttNameFile;
	document.getElementsByName("poAttName")[i].value = vPoAttName;
	document.getElementsByName("contName")[i].value = vContName;
	//for (var a = 0;a < document.getElementsByName("poAttType").length;a ++) {
	//}
}
function controlAddBtn(flag) {
	$("#addPoAttachmentRowBtn").attr("disabled", flag);
	$("#addPoAuditRowBtn").attr("disabled", flag);
	$("#addContactorInfoRowBtn").attr("disabled", flag);
}
</script>