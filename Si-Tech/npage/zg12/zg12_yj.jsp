<%
/********************
 version v2.0
������: si-tech
*
*update:zhanghonga@2008-08-15 ҳ�����,�޸���ʽ
*
********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=GBK" %>
 
<%@ page import="java.text.*" %> 
<%@ page import="java.util.*" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%
		String q_value =  WtcUtil.repNull(request.getParameter("q_value"));
		//String q_value =  request.getParameter("q_value");
		String opCode = "";//;"zg12";
		if(q_value=="3" ||q_value.equals("3"))
		{
			opCode="zgb3";
		}
		else if(q_value=="4" ||q_value.equals("4"))
		{
			opCode="zgb7";
		}
		else
		{
			opCode="zg12";
		}
		String opName = "��ֵ˰רƱ����";
		String workno = (String)session.getAttribute("workNo");
		String workname = (String)session.getAttribute("workName");
		//��ȡ��˰����Ϣ
		String tax_name = request.getParameter("tax_name");
		String tax_no1 = request.getParameter("tax_no1");
		String tax_address = request.getParameter("tax_address");
		String tax_phone = request.getParameter("tax_phone");
		String tax_khh = request.getParameter("tax_khh");
		String tax_contract_no = request.getParameter("tax_contract_no");
		String org_code = (String)session.getAttribute("orgCode");
		String regionCode = org_code.substring(0,2);
		String s_kpserver="";
		String seller_name="";
		String seller_bank="";
		String s_notes = request.getParameter("s_notes");
		
		String s_xf = request.getParameter("s_xf");
		System.out.println("aaaaaaaaaaaaaaaaaaaaaaaaaa regionCode is "+regionCode+" and s_notes is "+s_notes+" and opCode is "+opCode+" and s_xf is "+s_xf);
		//s_xfΪ�� �������ñ�
		String[] inParas_xf = new String[2];
		if(s_xf==null||s_xf.equals(""))
		{
			System.out.println("dddddddddddddddddddd og here?????????????????");
			inParas_xf[0]="select to_char(s_bank_code) from s_xf_info where region_code=:s_region ";
			inParas_xf[1]="s_region="+regionCode;
			%>
			<wtc:service name="TlsPubSelBoss" routerKey="phone" routerValue="15004675829"  retcode="retCode_xf" retmsg="retMsg_xf" outnum="1">
				<wtc:param value="<%=inParas_xf[0]%>"/>
				<wtc:param value="<%=inParas_xf[1]%>"/>
			</wtc:service>
			<wtc:array id="result_xf" scope="end" />
			<%
			if(result_xf.length>0)
			{
				s_xf=result_xf[0][0];
			}		
		}
		if(regionCode=="01" ||regionCode.equals("01"))
		{
			s_kpserver="10.110.22.31";
			seller_name="�й��������й�����������֧��,"+s_xf;
			seller_bank="���������㷻�������114��,13836103555";
		}
		else if(regionCode=="02"||regionCode.equals("02") )
		{
			s_kpserver="10.110.22.32";
			seller_name="�й��������йɷ����޹�˾�����������֧��,"+s_xf;
			seller_bank="������ʡ�����������ɳ�������ϴ��������·����ڶ���1-14�����һ��,13904520600";
		}
		else if(regionCode=="03" ||regionCode.equals("03"))
		{
			s_kpserver="10.110.22.33";
			seller_name="�й��������йɷ����޹�˾ĵ����̫ƽ·֧��,"+s_xf;
			seller_bank="ĵ�����������������129��,18845386648";
		}
		else if(regionCode=="04" ||regionCode.equals("04"))
		{
			s_kpserver="10.110.22.34";
			seller_name="��ľ˹��������֧��,"+s_xf;
			seller_bank="��ľ˹�г���·766��,13845479099";
		}
		else if(regionCode=="05" ||regionCode.equals("05"))
		{
			s_kpserver="10.110.22.39";
			seller_name="�й��������йɷ����޹�˾˫Ѽɽ����֧��,"+s_xf;
			seller_bank="˫Ѽɽ�м�ɽ����ƽ��·����·,13895897789";
		}
		else if(regionCode=="06" ||regionCode.equals("06"))
		{
			s_kpserver="10.110.22.38";
			seller_name="�й����йɷ����޹�˾��̨�ӷ���,"+s_xf;
			seller_bank="������ʡ��̨������ɽ�����Ͻ�,15946434488";
		}
		else if(regionCode=="07" ||regionCode.equals("07"))
		{
			s_kpserver="10.110.22.36";
			seller_name="�й��������м���������֧��,"+s_xf;
			seller_bank="������ʡ�����м�����201����֧����,0467-8297088";
		}
		else if(regionCode=="08" ||regionCode.equals("08"))
		{
			s_kpserver="10.110.22.41";
			seller_name="�й��������к׸ڷ���Ӫҵ��,"+s_xf;
			seller_bank="�׸��ж����·��������㳡��,04683855200";			
		}
		else if(regionCode=="09" ||regionCode.equals("09"))
		{
			s_kpserver="10.110.22.37";
			seller_name="�й�������������������·֧��,"+s_xf;
			seller_bank="������ʡ�������������������´��Ļ���,0458-3616677";			
		}
		else if(regionCode=="10" ||regionCode.equals("10"))
		{
			s_kpserver="10.110.22.42";
			seller_name="�ںӹ������������֧��,"+s_xf;
			seller_bank="������ʡ�ں��к���������ּ���վ����,13945721900";			
		}
		else if(regionCode=="11" ||regionCode.equals("11"))
		{
			s_kpserver="10.110.22.40";
			seller_name="������ֱ·֧��,"+s_xf;
			seller_bank="�绯�б������϶���·,0455-8361007";			
		}
		else if(regionCode=="12" ||regionCode.equals("12"))
		{
			s_kpserver="10.110.22.43";
			seller_name="�й��������йɷ����޹�˾�Ӹ����֧��,"+s_xf;
			seller_bank="���˰�������Ӹ��������������(����·5�ţ�,13846597800";			
		}
		else if(regionCode=="13" ||regionCode.equals("13"))
		{
			s_kpserver="10.110.22.35";
			seller_name="�й��������йɷ����޹�˾������ҵ֧��,"+s_xf;
			seller_bank="����������ͼ�������´����㳡A��,04592616011";			
		}
		else
		{
			s_kpserver="";
			seller_name="���й�������ֱ֧��,"+s_xf;
			seller_bank="������ʡ���������ɱ�������·168��,13936693030";	
		}
		System.out.println("bbbbbbbbbbbbbbbbbbbbbb regionCode is "+regionCode+" and s_kpserver is "+s_kpserver+" and seller_name is "+seller_name);
%>
<HTML>
<HEAD>
<script src="control.js"  type="text/javascript" charset="utf8" ></script>   
<script language="JavaScript">
 
function loadXML(xmlString){
	var xmlDoc=null;
	//�ж������������
	//֧��IE�����
	if(!window.DOMParser && window.ActiveXObject){ //window.DOMParser �ж��Ƿ��Ƿ�ie�����
		var xmlDomVersions = ['MSXML.2.DOMDocument.6.0','MSXML.2.DOMDocument.3.0','Microsoft.XMLDOM'];
		for(var i=0;i<xmlDomVersions.length;i++){
		try{
		xmlDoc = new ActiveXObject(xmlDomVersions[i]);
		xmlDoc.async = false;
		xmlDoc.loadXML(xmlString); //loadXML��������xml�ַ���
		break;
		}catch(e){
			}
		}
	}
	//֧��Mozilla�����
	else if(window.DOMParser && document.implementation && document.implementation.createDocument){
	try{
	/* DOMParser ������� XML �ı�������һ�� XML Document ����
	* Ҫʹ�� DOMParser��ʹ�ò��������Ĺ��캯����ʵ��������Ȼ������� parseFromString() ����
	* parseFromString(text, contentType) ����text:Ҫ������ XML ��� ����contentType�ı�����������
	* ������ "text/xml" ��"application/xml" �� "application/xhtml+xml" �е�һ����ע�⣬��֧�� "text/html"��
	*/
		domParser = new DOMParser();
		xmlDoc = domParser.parseFromString(xmlString, 'text/xml');
	}catch(e){
		}
	}
	else{
		return null;
		}
	//	alert("xmlDoc is "+xmlDoc);//��
	return xmlDoc;
	}

/*******************************************************
 * ������ȫ�ؼ����屨��,Ŀǰ���÷������汾���� 
 function   window.alert1(str)
  {   
	document.getElementById("div1").value=str; 
  }
 ******************************************************/
  function   window.alert1(str)
  {   
	document.getElementById("div1").value=str; 
  }
	function doPrint(size,i_rate_count)
	{
		/*
		�ҵ��㷨:
		˰��ȫȡ���� 
		if =0.06 һ��
		else if =0.11
		else if=0.17
		else ����
		*/
		var SID14_flag="";
		//xl add for ������������ �ֱ�����Ʒ���� ��� ˰�� ��󴫸�����
		var s_all_spmc=[];
		var s_all_je=[];
		var s_all_se=[];
		
		var  rate6_Arrays=[];  //˰��6��
		var  rate11_Arrays=[]; //˰��11��
		var  rate17_Arrays=[]; //˰��17��
		var ListTaxItem6=[]; //˰Ŀ��4λ���֣���Ʒ������𡾿ɿգ�����ȷ�ϡ�
		var ListGoodsName6=[];
		var ListStandard6=[];
		var ListUnit6=[];
		var ListNumber6=[];
		var ListPrice6=[];
		var ListAmount6=[];
		var ListPriceKind6=[];
		var ListTaxAmount6=[];
		var i_6="";
		//
		var ListTaxItem11=[];
		var ListGoodsName11=[];
		var ListStandard11=[];
		var ListUnit11=[];
		var ListNumber11=[];
		var ListPrice11=[];
		var ListAmount11=[];
		var ListPriceKind11=[];
		var ListTaxAmount11=[];
		var i_11="";
		//
		var ListTaxItem17=[];
		var ListGoodsName17=[];
		var ListStandard17=[];
		var ListUnit17=[];
		var ListNumber17=[];
		var ListPrice17=[];
		var ListAmount17=[];
		var ListPriceKind17=[];//��0
		var ListTaxAmount17=[];
		var i_17="";
		//alert("size is "+size);
		var List_tax_invoice_code=[];
		var List_tax_invoice_number=[];
		var List_tax_rate=[];
		//xl add �ж��Ƿ��Ƕ�˰�ʵ�
		var isMulti="";//0=��˰�� 1=��˰��
		var s_notes = "<%=s_notes%>";
		for (i=0;i<size;i++)
		{
			var tax_rate = document.getElementById("tax_rate"+i).value;
			var ggxh = "";//document.getElementById("ggxh"+i).value;
			var goods_name = document.getElementById("goods_name"+i).value; 
			var ListUnit = "";//document.getElementById("dw"+i).value; 
			var sl = "1";//document.getElementById("sl"+i).value;  
			var dj = document.getElementById("dj"+i).value; 
			var je = document.getElementById("je"+i).value;
			var tax_money = document.getElementById("tax_money"+i).value;//ListTaxAmount17

			//xl add for �ۿ�
			var tax_rate_zk = document.getElementById("tax_rate_zk"+i).value;
			var ggxh_zk = "";//document.getElementById("ggxh_zk"+i).value;
			var goods_name_zk = document.getElementById("goods_name_zk"+i).value; 
			var ListUnit_zk = "";//document.getElementById("dw_zk"+i).value; 
			var sl_zk = "1";//document.getElementById("sl_zk"+i).value;  
			var dj_zk = document.getElementById("dj_zk"+i).value; 
			var je_zk = document.getElementById("je_zk"+i).value;
			var tax_money_zk = document.getElementById("tax_money_zk"+i).value;//ListTaxAmount17
			//alert(tax_rate);
			if(tax_rate=="0.06")
		    {
		 	   ListGoodsName6.push(goods_name);
			   ListStandard6.push(ggxh);
			   ListUnit6.push(ListUnit);
			   ListNumber6.push(sl);
			   ListPrice6.push(dj);
			   ListAmount6.push(je);
			   ListTaxAmount6.push(tax_money);
			   //xl add �����������
			   s_all_spmc.push(goods_name);
			   s_all_je.push(je);
			   s_all_se.push(tax_money);
			   i_6++;
			   //xl add �ۿ�
		//	   alert("aaaaaaaaaaaaa test 0.06�ۿ� dj_zk is "+dj_zk);
			   if(dj_zk<0)
			   {
				   ListGoodsName6.push(goods_name_zk);
				   ListStandard6.push(ggxh_zk);
				   ListUnit6.push(ListUnit_zk);
				   ListNumber6.push(sl_zk);
				   ListPrice6.push(dj_zk);
				   ListAmount6.push(je_zk);
				   ListTaxAmount6.push(tax_money_zk);
				   s_all_spmc.push(goods_name_zk);
				   s_all_je.push(je_zk);
				   s_all_se.push(tax_money_zk);
				   i_6++;
				  
			   }	
			   

			   
			   //alert("0.06 "+ListGoodsName6);
		    }
			else if(tax_rate=="0.11")
		    {
			   ListGoodsName11.push(goods_name);
			   ListStandard11.push(ggxh);
			   ListUnit11.push(ListUnit);
			   ListNumber11.push(sl);
			   ListPrice11.push(dj);
			   ListAmount11.push(je);
			   ListTaxAmount11.push(tax_money);
			   //xl add �����������
			   s_all_spmc.push(goods_name);
			   s_all_je.push(je);
			   s_all_se.push(tax_money);
			   i_11++;
			   //xl add �ۿ�
			   if(dj_zk<0)
			   {
				   ListGoodsName11.push(goods_name_zk);
				   ListStandard11.push(ggxh_zk);
				   ListUnit11.push(ListUnit_zk);
				   ListNumber11.push(sl_zk);
				   ListPrice11.push(dj_zk);
				   ListAmount11.push(je_zk);
				   ListTaxAmount11.push(tax_money_zk);
				   s_all_spmc.push(goods_name_zk);
				   s_all_je.push(je_zk);
				   s_all_se.push(tax_money_zk);
				   i_11++;
				   
			   }	
			   
			   
			   //alert("0.11 ListGoodsName11 is "+ListGoodsName11+" and ListTaxAmount11 is "+ListTaxAmount11);
		    }
		    else if(tax_rate=="0.17")
		    {
			   ListGoodsName17.push(goods_name);
			   ListStandard17.push(ggxh);
			   ListUnit17.push(ListUnit);
			   ListNumber17.push(sl);
			   ListPrice17.push(dj);
			   ListAmount17.push(je);
			   ListTaxAmount17.push(tax_money);
			   //xl add �����������
			   s_all_spmc.push(goods_name);
			   s_all_je.push(je);
			   s_all_se.push(tax_money);	
			   //xl add �ۿ�
			   if(dj_zk<0)
			   {
				   ListGoodsName11.push(goods_name_zk);
				   ListStandard11.push(ggxh_zk);
				   ListUnit11.push(ListUnit_zk);
				   ListNumber11.push(sl_zk);
				   ListPrice11.push(dj_zk);
				   ListAmount11.push(je_zk);
				   ListTaxAmount11.push(tax_money_zk);
				   s_all_spmc.push(goods_name_zk);
				   s_all_je.push(je_zk);
				   s_all_se.push(tax_money_zk);
			   }		
			   

			   i_17++;
			   //alert("0.17 "+ListGoodsName17);
		    }
		    else
		    {
			   alert("˰�ʲ�����");
		    }
			//xl add �ж��Ƿ��Ƕ�˰�ʵ�ȡֵ ListGoodsName11 isMulti
			

		}
		if(ListGoodsName11!="" &&ListGoodsName6!="")
		{
		//	alert("��˰��");
			isMulti=1;
		}
		else
		{
		//	alert("һ��˰��");
			isMulti=0;
		}
		//alert("ListGoodsName11 is "+ListGoodsName11+" and ListGoodsName6 is "+ListGoodsName6+" and i_11 is "+i_11+" and i_6 is "+i_6);
		 alert("ListPrice6 is "+ListPrice6+" and i_6 is "+i_6);
		 alert("ListPrice11 is "+ListPrice11+" and i_11 is "+i_11);
		//�򿪽�˰��
		/*
		var obAISINO = new ActiveXObject("InvSecCtrl.TaxCardEx");
		var strKEY =obAISINO.KEYMsg;  
		if(strKEY == null){
			alert("111��ȡ��˰��ȫ�ؼ���ϢΪ�� ��");
		}
		var KEYString = decode64(strKEY.toString());
		*/
	//	alert("go here ?"+KEYString);//keymsg��ֵ
		var err_code ;
		var err_msg  ;
		/*

		*/
		var gf_tax_code=document.getElementById("tax_no1").value; // "240301201405999";//��crmpd��ȡ
		var TaxCode ; 
		var ServerNo;//="0"; //��Ʊ������
		var ClientNo;//="2"; //�ͻ���
		var fpzl="";
		var lz_fphm="";//��ѯ���ַ�Ʊ����
		var lz_fpdm="";//��ѯ���ַ�Ʊ���� 
		lz_fphm = document.getElementById("lz_fphm").value;
		lz_fpdm = document.getElementById("lz_fpdm").value;
		lz_fphm="";
		lz_fpdm="";//����ʱɾ�� Ϊ�˲��Լӵ�
		/*
		var xmlDoc = loadXML(KEYString.toString());
		var elementsErr = xmlDoc.getElementsByTagName("err");
		var elementsData = xmlDoc.getElementsByTagName("data");
		
	 
		
		for (var i = 0; i < elementsErr.length; i++) {
		     err_code = elementsErr[i].getElementsByTagName("err_code")[0].firstChild.nodeValue;
		     err_msg = elementsErr[i].getElementsByTagName("err_msg")[0].firstChild.nodeValue;  
		}*/
	 	/*
		if(err_code=="0000"){ 
			for(var i=0;i<elementsData.length;i++){
				TaxCode = elementsData[i].getElementsByTagName("TaxCode")[0].firstChild.nodeValue;
				ServerNo = elementsData[i].getElementsByTagName("ServerNo")[0].firstChild.nodeValue;
				ClientNo = elementsData[i].getElementsByTagName("ClientNo")[0].firstChild.nodeValue;
				
			 
			}
		}*/
		var sidType = "SID01";
		var strREQ ;
		fpzl="";
		/*
		strREQ = makeStrs01(sidType,ServerNo,ClientNo,TaxCode,fpzl,lz_fphm,lz_fpdm,"");
		obAISINO.SafeInvoke(strREQ);
		var strSIDMsg =obAISINO.SIDMsg; 
		var sidmsgDom = decode64(strSIDMsg);*/
		var s_flag="";//�жϴ�ӡ�Ƿ�ɹ��ı�ʶ ��ӡ���ŵ�ʱ�������
		
		if(showMesgInfoDetail01("sidmsgDom.toString()",sidType)=="SID01_true")
		{
			
			//alert("sid01ͨ�� ������"); 
			s_flag="Y"; 
			if(isMulti==0)//��˰��
			{
				if(ListGoodsName6.length>0)
				{
					/*xl add �����߼�����
						����isMulti�ж�
						if isMulti=1��˰�� ��дmakestr_muti�� ��֯רƱ��ӡ
						else ��˰�ʵ� �ж�˰���Ƕ��� Ȼ��������6����11��  
					*/
					
					
					//begin ���߼� ���Ҫɾ����
					//xl add sid05��ƱУ�� begin
					var sidType = "SID05";
					var str="";
					str=makes_data_6(sidType,"ServerNo","ClientNo",gf_tax_code,ListGoodsName6,ListStandard6,ListUnit6,ListNumber6,ListPrice6,ListAmount6,ListTaxAmount6,i_6,isMulti,s_notes);
					var strREQ ;
					fpzl="0";
					strREQ = makeStrs(sidType,ServerNo,ClientNo,TaxCode,fpzl,lz_fphm,lz_fpdm,str);
					/*
					obAISINO.SafeInvoke(strREQ);
					var strSIDMsg =obAISINO.SIDMsg; 
					var sidmsgDom = decode64(strSIDMsg);
					*/
					if(showMesgInfoDetail01("sidmsgDom.toString()",sidType,TaxCode,ServerNo,ClientNo)==true)
					{
						//alert("У��ͨ��!");
						//ԭ�߼� begin
						var sidType = "SID14";
						var strREQ ;
						fpzl="0";
						strREQ = makeStrs(sidType,ServerNo,ClientNo,TaxCode,fpzl,lz_fphm,lz_fpdm,"");
						/*obAISINO.SafeInvoke(strREQ);
						var strSIDMsg =obAISINO.SIDMsg; 
						var sidmsgDom = decode64(strSIDMsg);
						*/
						if(showMesgInfoDetail01("sidmsgDom.toString()",sidType,TaxCode,ServerNo,ClientNo)==true)
						{
							var invoice_code = document.getElementById("invoice_code").value;
							var invoice_number = document.getElementById("invoice_number").value;
							var str="";
							str=makes_data_6("sidType","ServerNo","ClientNo",gf_tax_code,ListGoodsName6,ListStandard6,ListUnit6,ListNumber6,ListPrice6,ListAmount6,ListTaxAmount6,i_6,isMulti,s_notes);
							var sidType = "SID11";
							/*
							var strREQ_new = makeStrs(sidType,ServerNo,ClientNo,TaxCode,fpzl,"","",str);
							obAISINO.SafeInvoke(strREQ_new);
							var strSIDMsg =obAISINO.SIDMsg; 
							var sidmsgDom = decode64(strSIDMsg);
							*/
							if(showMesgInfoDetail01("sidmsgDom.toString()",sidType)==true &&(s_flag=="Y"))
							{
							//	alert("��ʼ��ӡ����");
								var sidType = "SID12";
								var strREQ ;
								strREQ = makeStrs(sidType,ServerNo,ClientNo,TaxCode,fpzl,invoice_number,invoice_code,"");
								/*
								obAISINO.SafeInvoke(strREQ);
								var strSIDMsg =obAISINO.SIDMsg; 
								var sidmsgDom = decode64(strSIDMsg);
								*/
							//	alert("sid12 sidmsgDom is "+sidmsgDom);
								if(showMesgInfoDetail01("sidmsgDom.toString()",sidType)==true &&(s_flag=="Y"))
								{
									s_flag="Y";
									if(dj_zk<0)
									{
										//alert("11??");
										List_tax_invoice_code.push("invoice_code",invoice_code);
										List_tax_invoice_number.push("invoice_number",invoice_number);
										List_tax_rate.push("0.06","0.06");
									}
									else
									{
										List_tax_invoice_code.push("invoice_code");
										List_tax_invoice_number.push("invoice_number");
										List_tax_rate.push("0.06");
									}
									
									SID14_flag="Y";
								}
								else
								{
									alert("SID12��ӡʧ��!");
									s_flag="N";
									SID14_flag="N";
								}
							}
							else
							{
								alert("SID11����ʧ��!");
								s_flag="N";
							}
						}
						//end of ԭ�߼�
					}
					//end of sid0 ��ƱУ��
					
					
				}
				else if(ListGoodsName11.length>0)
				{
					
					var sidType = "SID05";
					var str="";
					str=makes_data_11(sidType,"ServerNo","ClientNo",gf_tax_code,ListGoodsName11,ListStandard11,ListUnit11,ListNumber11,ListPrice11,ListAmount11,ListTaxAmount11,i_11,isMulti,s_notes);
					var strREQ ;
					fpzl="0";
					strREQ = makeStrs(sidType,ServerNo,ClientNo,TaxCode,fpzl,lz_fphm,lz_fpdm,str);
					/*
					obAISINO.SafeInvoke(strREQ);
					var strSIDMsg =obAISINO.SIDMsg; 
					var sidmsgDom = decode64(strSIDMsg);
					*/
					if(showMesgInfoDetail01("sidmsgDom.toString()",sidType,TaxCode,ServerNo,ClientNo)==true)
					{
						var sidType = "SID14";
						var strREQ ;
						fpzl="0";
						strREQ = makeStrs(sidType,ServerNo,ClientNo,TaxCode,fpzl,lz_fphm,lz_fpdm,"");
						/*
						obAISINO.SafeInvoke(strREQ);
						var strSIDMsg =obAISINO.SIDMsg; 
						var sidmsgDom = decode64(strSIDMsg);
						*/
						if(showMesgInfoDetail01("sidmsgDom.toString()",sidType,TaxCode,ServerNo,ClientNo)==true)
						{
							var invoice_code = document.getElementById("invoice_code").value;
							var invoice_number = document.getElementById("invoice_number").value;
							var str="";
							str=makes_data_11("sidType","ServerNo","ClientNo",gf_tax_code,ListGoodsName11,ListStandard11,ListUnit11,ListNumber11,ListPrice11,ListAmount11,ListTaxAmount11,i_11,isMulti,s_notes);
							var sidType = "SID11";
							var strREQ_new = makeStrs(sidType,ServerNo,ClientNo,TaxCode,fpzl,"","",str);
							/*
							obAISINO.SafeInvoke(strREQ_new);
							var strSIDMsg =obAISINO.SIDMsg; 
							var sidmsgDom = decode64(strSIDMsg);
							*/
							if(showMesgInfoDetail01("sidmsgDom.toString()",sidType)==true &&(s_flag=="Y"))
							{
								
								var sidType = "SID12"; 
								var strREQ ;
								strREQ = makeStrs(sidType,ServerNo,ClientNo,TaxCode,fpzl,invoice_number,invoice_code,"");
								/*
								obAISINO.SafeInvoke(strREQ);
								var strSIDMsg =obAISINO.SIDMsg; 
								var sidmsgDom = decode64(strSIDMsg);
								*/
								if(showMesgInfoDetail01("sidmsgDom.toString()",sidType)==true &&(s_flag=="Y"))
								{
									s_flag="Y";
									/*
									List_tax_invoice_code.push(invoice_code);
									List_tax_invoice_number.push(invoice_number);
									List_tax_rate.push("0.11");*/
									if(dj_zk<0)
									{
										List_tax_invoice_code.push("invoice_code",invoice_code);
										List_tax_invoice_number.push("invoice_number",invoice_number);
										List_tax_rate.push("0.11","0.11");
									}
									else
									{
										List_tax_invoice_code.push("invoice_code");
										List_tax_invoice_number.push("invoice_number");
										List_tax_rate.push("0.11");
									}
									SID14_flag="Y";
								}
								else
								{
									alert("SID12��ӡʧ��!");
									s_flag="N";
									SID14_flag="N";
								}
							}
							else
							{
								alert("SID11����ʧ��!");
								s_flag="N";
							}
						}
					}
					 
				}
			}
			
			else
			{
				alert("��˰�ʵ�������! dj_zk is "+dj_zk);//�϶��� 11 �� 6�� fpmx�ıȽ���Ū  makes_data_muti
				var sidType = "SID05";
				var str="";
				str=makes_data_muti(sidType,"ServerNo","ClientNo",gf_tax_code,ListGoodsName11,ListStandard11,ListUnit11,ListNumber11,ListPrice11,ListAmount11,ListTaxAmount11,i_11,ListGoodsName6,ListStandard6,ListUnit6,ListNumber6,ListPrice6,ListAmount6,ListTaxAmount6,i_6,s_notes);
				var strREQ ;
				fpzl="0";
				strREQ = makeStrs(sidType,ServerNo,ClientNo,TaxCode,fpzl,lz_fphm,lz_fpdm,str);
				alert1("duozude "+strREQ);
				/*
				obAISINO.SafeInvoke(strREQ);
				var strSIDMsg =obAISINO.SIDMsg; 
				var sidmsgDom = decode64(strSIDMsg);
				*/
				if(showMesgInfoDetail01("sidmsgDom.toString()",sidType,TaxCode,ServerNo,ClientNo)==true)
				{
					var sidType = "SID14";
					var strREQ ;
					fpzl="0";
					strREQ = makeStrs(sidType,ServerNo,ClientNo,TaxCode,fpzl,lz_fphm,lz_fpdm,"");
					/*
					obAISINO.SafeInvoke(strREQ);
					var strSIDMsg =obAISINO.SIDMsg; 
					var sidmsgDom = decode64(strSIDMsg);
					*/
					if(showMesgInfoDetail01("sidmsgDom.toString()",sidType,TaxCode,ServerNo,ClientNo)==true)
					{
						var invoice_code = document.getElementById("invoice_code").value;
						var invoice_number = document.getElementById("invoice_number").value;
						var str="";
						str=makes_data_muti(sidType,"ServerNo","ClientNo",gf_tax_code,ListGoodsName11,ListStandard11,ListUnit11,ListNumber11,ListPrice11,ListAmount11,ListTaxAmount11,i_11,ListGoodsName6,ListStandard6,ListUnit6,ListNumber6,ListPrice6,ListAmount6,ListTaxAmount6,i_6,s_notes);
						var sidType = "SID11";
						var strREQ_new = makeStrs(sidType,ServerNo,ClientNo,TaxCode,fpzl,"","",str);
						/*
						obAISINO.SafeInvoke(strREQ_new);
						var strSIDMsg =obAISINO.SIDMsg; 
						var sidmsgDom = decode64(strSIDMsg);
						*/
						if(showMesgInfoDetail01("sidmsgDom.toString()",sidType)==true &&(s_flag=="Y"))
						{
							
							var sidType = "SID12"; 
							var strREQ ;
							strREQ = makeStrs(sidType,ServerNo,ClientNo,TaxCode,fpzl,invoice_number,invoice_code,"");
							/*
							obAISINO.SafeInvoke(strREQ);
							var strSIDMsg =obAISINO.SIDMsg; 
							var sidmsgDom = decode64(strSIDMsg);
							*/
							if(showMesgInfoDetail01("sidmsgDom.toString()",sidType)==true &&(s_flag=="Y"))
							{
								s_flag="Y";
							
								if(dj_zk<0)
								{
									alert("1");
									//alert("����ϵBOSS���ҽ��!");
									for(var i=0;i<i_6;i++)
									{
										List_tax_invoice_code.push(invoice_code);
										List_tax_invoice_number.push(invoice_number);
										List_tax_rate.push("0.06");
									}
									for(var i=0;i<i_11;i++)
									{
										List_tax_invoice_code.push(invoice_code);
										List_tax_invoice_number.push(invoice_number);
										List_tax_rate.push("0.11");
									}
									SID14_flag="Y";
								}
								else
								{
									alert("2");
									//xl add for xuxz
									for(var i=0;i<i_6;i++)
									{
										List_tax_invoice_code.push(invoice_code);
										List_tax_invoice_number.push(invoice_number);
										List_tax_rate.push("0.06");
									}
									for(var i=0;i<i_11;i++)
									{
										List_tax_invoice_code.push(invoice_code);
										List_tax_invoice_number.push(invoice_number);
										List_tax_rate.push("0.11");
									}
									/*
									List_tax_invoice_code.push(invoice_code,invoice_code);
									List_tax_invoice_number.push(invoice_number,invoice_number);
									List_tax_rate.push("0.06,0.11");*/
									SID14_flag="Y";
								}
							}
							else
							{
								alert("SID12��ӡʧ��!");
								s_flag="N";
								SID14_flag="N";
							}
						}
						else
						{
							alert("SID11����ʧ��!");
							s_flag="N";
						}
					}
				}
			}
			 
 
			var begin_tm = document.getElementById("begindate").value;
			var end_tm = document.getElementById("enddate").value;
			var phone_no = document.getElementById("phone_no").value;
			var yj_date = document.getElementById("yj_date").value;

			var print_sum_money = document.getElementById("print_sum_money").value;
			var print_accept = document.getElementById("print_accept").value;
			var print_ym = document.getElementById("print_ym").value;
			var yj_end_date = document.getElementById("yj_end_date").value;
			var tax_no1 = document.frm.tax_no1.value;
			if(s_flag=="Y")
			{
			//	alert("��ת����ӡ SID14_flag is "+SID14_flag);
				if(SID14_flag=="Y")
				{
					alert("action List_tax_invoice_code is "+List_tax_invoice_code+" and List_tax_rate is "+List_tax_rate);
					window.location="zg12_yjkj.jsp?List_tax_invoice_number="+List_tax_invoice_number+"&List_tax_invoice_code="+List_tax_invoice_code+"&List_tax_rate="+List_tax_rate+"&kpd="+ClientNo+"&ClientNo="+ClientNo+"&yj_date="+yj_date+"&phone_no="+phone_no+"&print_sum_money="+print_sum_money+"&print_accept="+print_accept+"&print_ym="+print_ym+"&s_all_spmc="+s_all_spmc+"&s_all_je="+s_all_je+"&s_all_se="+s_all_se+"&yj_end_date="+yj_end_date+"&tax_no1="+gf_tax_code+"&opCode="+"<%=opCode%>";
				}
				else
				{
					rdShowMessageDialog("�û�ȡ���˴�רƱ��ӡ����!");
				}
				
			}
			else
			{
				rdShowMessageDialog("˰�ػ�����רƱʧ��!");
			}
			
			
		}
	}
	function makeStrs(sidType,key_kpfwq,key_kpd,key_nsrsbh,fpzl,lz_fphm,lz_fpdm,datastr){
		var xmlHeader = "<?xml version=\"1.0\" encoding=\"GBK\"?>" ;
		var send = new String();
		send += "<service>";
		//sid:�ӿڷ���ID�ţ�SID01-������˰����SID02-�رս�˰����SID03-����/�رտ�Ʊϵͳ�ֹ���Ʊ���ϣ�SID04-��Ʊ��ѯ��SID11-��Ʊ��SID12-��Ʊ��ӡ��SID13-��Ʊ���ϣ�SID14-��ѯ��淢Ʊ��SID22-����Զ�̳������ܣ�SID31-��ѯ��淢Ʊ(��������)��SID32-��ѯ��Ʊ������ʷ(��������)��SID33-��ѯ�ѿ���Ʊ����(��������) ��SID34-ȡ��������(��������)��SID35-ȡ��Ʊ���(��������)
		//����
		var s_kpserver = "<%=s_kpserver%>";
		//���� 
		//var s_kpserver ="http://skfpwssl.aisino.com:7067";
		send += "<sid>"+sidType+"</sid>";
		//�°�SID01
		var s_kpserver_new = "<%=s_kpserver%>"+":8001";
		//var s_kpserver_new =s_kpserver;
	//	alert(s_kpserver_new);
		if(sidType=="SID01")
		{
			//alert("test add sid01");
			send += "<CertPassWord>"+s_kpserver_new+"</CertPassWord>";//1����֤������? ò�ƴ����ǿ�Ʊ������ip+�˿� 8001
			send += "<UploadAuto>"+"1"+"</UploadAuto>";//�ϴ�ģʽ 1=�Զ��ϴ�
		}
		send += "<lx>"+"1"+"</lx>";//
		send += "<data_pub>";
		send += "<key_kpd>"+key_kpd+"</key_kpd>";
		send += "<key_kpfwq>"+key_kpfwq+"</key_kpfwq>";
		send += "<key_nsrsbh>"+key_nsrsbh+"</key_nsrsbh>";
		// slserver : http://skfpwssl.aisino.com:7011/tlslserver/slconsole.do http://10.110.22.24:7003/dxslserver/slconsole.do
		//kpserver : 10.110.22.44
		//����
		send += "<slserver>"+"http://10.110.22.24:7003/dxslserver/slconsole.do"+"</slserver>";
		//����
		//send += "<slserver>"+"http://124.127.114.68:7070/dxslserver/slconsole.do"+"</slserver>";
		
		
		send += "<kpserver>"+s_kpserver+"</kpserver>";
		
		send += "</data_pub>";
		
		send += "<data_fp>";
		send += "<HandMade></HandMade>";
		send += "<fpzl>"+fpzl+"</fpzl>";
		send += "<fpdm>"+lz_fpdm+"</fpdm>";
		send += "<fphm>"+lz_fphm+"</fphm>";
		send += "<dylb></dylb>";
		send += "<dybk></dybk>";
		send += "<data>"+datastr+"</data>";
		send += "</data_fp>";
		
		send += "<data_cx>";
		send += "<qjlh></qjlh>";
		send += "<jls></jls>";
		send += "<nsrsbh>"+key_nsrsbh+"</nsrsbh>";
		send += "<kpfwqh>"+key_kpfwq+"</kpfwqh>";
		send += "<kpdh>"+key_kpd+"</kpdh>";
		send += "<qrq></qrq>";
		send += "<zrq></zrq>";
		send += "</data_cx>";
		
		send += "</service>";
		var sendXML = xmlHeader + send;
		alert1("sidType is "+sidType+" and xml is "+sendXML);
		var value1 = encode64(sendXML);
		return value1;
	}
	function makeStrs01(sidType,key_kpfwq,key_kpd,key_nsrsbh,fpzl,lz_fphm,lz_fpdm,datastr){
		var xmlHeader = "<?xml version=\"1.0\" encoding=\"GBK\"?>" ;
		var send = new String();
		send += "<service>";
		//sid:�ӿڷ���ID�ţ�SID01-������˰����SID02-�رս�˰����SID03-����/�رտ�Ʊϵͳ�ֹ���Ʊ���ϣ�SID04-��Ʊ��ѯ��SID11-��Ʊ��SID12-��Ʊ��ӡ��SID13-��Ʊ���ϣ�SID14-��ѯ��淢Ʊ��SID22-����Զ�̳������ܣ�SID31-��ѯ��淢Ʊ(��������)��SID32-��ѯ��Ʊ������ʷ(��������)��SID33-��ѯ�ѿ���Ʊ����(��������) ��SID34-ȡ��������(��������)��SID35-ȡ��Ʊ���(��������)
		var s_kpserver = "<%=s_kpserver%>";
		//����
		//var s_kpserver ="http://skfpwssl.aisino.com:7067";
		var s_kpserver_new = "<%=s_kpserver%>"+":8001";
		//var s_kpserver_new = s_kpserver;
		send += "<sid>"+sidType+"</sid>";
		send += "<lx>"+"1"+"</lx>";//
		//�°�SID01
		if(sidType=="SID01")
		{
			//alert("test add sid01");
			send += "<CertPassWord>"+s_kpserver_new+"</CertPassWord>";//2����֤������? ò�ƴ����ǿ�Ʊ������ip+�˿�
			send += "<UploadAuto>"+"1"+"</UploadAuto>";//�ϴ�ģʽ 1=�Զ��ϴ�
		}
		
		send += "<data_pub>";
		send += "<key_kpd>"+key_kpd+"</key_kpd>";
		send += "<key_kpfwq>"+key_kpfwq+"</key_kpfwq>";
		send += "<key_nsrsbh>"+key_nsrsbh+"</key_nsrsbh>";
		// slserver : http://skfpwssl.aisino.com:7011/tlslserver/slconsole.do http://10.110.22.24:7003/dxslserver/slconsole.do
		//kpserver : 10.110.22.44
		//����
		send += "<slserver>"+"http://10.110.22.24:7003/dxslserver/slconsole.do"+"</slserver>";
		//����
		//send += "<slserver>"+"http://124.127.114.68:7070/dxslserver/slconsole.do"+"</slserver>";
		//var s_kpserver ="skfpwssl.aisino.com";// "<%=s_kpserver%>";
		
		send += "<kpserver>"+s_kpserver+"</kpserver>";
		
		send += "</data_pub>";
		
		send += "</service>";
		var sendXML = xmlHeader + send;
		alert1("sidType is "+sidType+" and xml is "+sendXML);
		var value1 = encode64(sendXML);
		return value1;
	}
	/*
	function showMesgInfoDetail01(sidmsgDom,sidType){
		var xmlInfoDoc = loadXML(sidmsgDom.toString());
		var elementsErr = xmlInfoDoc.getElementsByTagName("err");
		var elementsData = xmlInfoDoc.getElementsByTagName("data");
		if(sidType=="SID01")
		{
			alert1("SID01 xmlInfoDoc is "+xmlInfoDoc +" and elementsErr is "+elementsErr+ "and elementsData is "+elementsData);
			if(showSID01(elementsErr,elementsData,sidType)==true)
			{
				return "SID01_true";
			}
			else
			{
				return "SID01_false";
			}
		}
		if(sidType=="SID14")
		{
			if(showSID01(elementsErr,elementsData,sidType)==true)
			{
				return true;
			}
			else
			{
				return false;
			}
		} 
		if(sidType=="SID04")
		{
			if(showSID01(elementsErr,elementsData,sidType)==true)
			{
				return true;
			}
			else
			{
				return false;
			}
		} 
		if(sidType=="SID05")
		{
			if(showSID01(elementsErr,elementsData,sidType)==true)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		if(sidType=="SID11")
		{
			if(showSID01(elementsErr,elementsData,sidType)==true)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		if(sidType=="SID12")
		{
			if(showSID01(elementsErr,elementsData,sidType)==true)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
				
	}*/
	function showMesgInfoDetail01(sidmsgDom,sidType){
		if(sidType=="SID01")
		{
			return "SID01_true";
		}
		if(sidType=="SID14")
		{
			return true;
		} 
		if(sidType=="SID04")
		{
			return true;
		} 
		if(sidType=="SID05")
		{
			return true;
		}
		if(sidType=="SID11")
		{
			return true;
		}
		if(sidType=="SID12")
		{
			return true;
		}
				
	}
	function showSID01(elementsErr,elementsData,sidType){
		var errcode;
		var message;
		var InvLimit;//��Ʊ�޶��˰����Ʊ���߼�˰�ϼ��޶�
		var TaxCode;//����λ˰��
		var TaxClock;//��˰��ʱ��
		var MachineNo;//��Ʊ�����룬����Ʊ��Ϊ0��
		var IsInvEmpty;//��Ʊ��־��0-��˰�����޿ɿ���Ʊ��1-��Ʊ��
		var IsRepReached;//��˰��־��0-δ����˰�ڣ�1-�ѵ���˰�ڡ�
		var IsLockReached;//������־��0-δ�������ڣ�1-�ѵ������ڡ�

		//SID14��
		var InfoTypeCode;// ��Ʊ����
		var InfoNumber;  // ��Ʊ����
		var InvStock;
		var InfoAmount;//�ܽ��
		var InfoTaxAmount;//��˰��
		for(var i=0;i<elementsErr.length;i++){
			errcode = elementsErr[i].getElementsByTagName("err_code")[0].firstChild.nodeValue;
			message = elementsErr[i].getElementsByTagName("err_msg")[0].firstChild.nodeValue;
		}
		//alert("sidType is "+sidType+" and errcode is "+errcode);
		if(sidType=="SID01")
		{
		//	alert("sid01 errcode is "+errcode);
			if("1011"==errcode){//3001=��˰���ɹ���������ȡ��Ϣ�ɹ�(������)     1011=��˰���ɹ�����
			for(var i=0;i<elementsData.length;i++){
				InvLimit = elementsData[i].getElementsByTagName("InvLimit")[0].firstChild.nodeValue;
				TaxCode  = elementsData[i].getElementsByTagName("TaxCode")[0].firstChild.nodeValue;
				TaxClock = elementsData[i].getElementsByTagName("TaxClock")[0].firstChild.nodeValue;
				MachineNo = elementsData[i].getElementsByTagName("MachineNo")[0].firstChild.nodeValue;
				IsInvEmpty = elementsData[i].getElementsByTagName("IsInvEmpty")[0].firstChild.nodeValue;
				IsRepReached =  elementsData[i].getElementsByTagName("IsRepReached")[0].firstChild.nodeValue;
				IsLockReached =  elementsData[i].getElementsByTagName("IsLockReached")[0].firstChild.nodeValue;
				//alert("����������Ϣ���£�InvLimit:"+InvLimit+";TaxCode:"+TaxCode+";TaxClock:"+TaxClock+";MachineNo:"+MachineNo+";IsInvEmpty:"+IsInvEmpty+";IsRepReached:"+IsRepReached+";IsLockReached"+IsLockReached);
			//	alert("������˰�̳ɹ�����ӡ�����Ҫ�رս�˰�̣�");
				return true;
			}
			}else{
				alert("SID01������Ϣ��ʾ�д�������errcode="+errcode+";err_msg="+message+",����ϵ���Ų�ά����Ա���!");
				return false;
			}
		}
		if(sidType=="SID14")
		{
			if("3011"==errcode){//ԭ����0000
				for(var i=0;i<elementsData.length;i++){
					InfoTypeCode = elementsData[i].getElementsByTagName("InfoTypeCode")[0].firstChild.nodeValue;
					InfoNumber  = elementsData[i].getElementsByTagName("InfoNumber")[0].firstChild.nodeValue;
					InvStock = elementsData[i].getElementsByTagName("InvStock")[0].firstChild.nodeValue;
					TaxClock = elementsData[i].getElementsByTagName("TaxClock")[0].firstChild.nodeValue; 
					//alert("��ֵ˰רƱ��ȡ�ɹ�����ǰ��Ʊ����:"+InfoNumber+",��Ʊ����:"+InfoTypeCode);
					var prtFlag=0;
					prtFlag=rdShowConfirmDialog("��ֵ˰רƱ��ȡ�ɹ�����ǰ��Ʊ����:"+InfoNumber+",��Ʊ����:"+InfoTypeCode+",�Ƿ�ȷ�ϴ�ӡ?");
					if (prtFlag==1)
					{
						document.getElementById("invoice_code").value=InfoTypeCode;
						document.getElementById("invoice_number").value=InfoNumber;
						
						return true;
					}
					else
					{
						SID14_flag="N";
						return false;
					}
					
				}
			}else{
				alert("���Ų෴����Ϣ��ʾ�д�������errcode="+errcode+";err_msg="+message+",����ϵ���Ų�ά����Ա���!");
				return false;
			}
			//alert("�Ƿ�SID14�ⲽ��??????????????? SID14_flag is "+SID14_flag);
		}
		if(sidType=="SID04")
		{
			//alert("SID04�ķ����� "+errcode);
			if("7011"==errcode){//SID04 ��ѯ�ɹ�
				for(var i=0;i<elementsData.length;i++){
					InfoTypeCode = elementsData[i].getElementsByTagName("InfoTypeCode")[0].firstChild.nodeValue;//��Ʊ����
					InfoNumber  = elementsData[i].getElementsByTagName("InfoNumber")[0].firstChild.nodeValue;//��Ʊ����
					InfoAmount = elementsData[i].getElementsByTagName("InfoAmount")[0].firstChild.nodeValue;//�ܽ��
					InfoTaxAmount= elementsData[i].getElementsByTagName("InfoTaxAmount")[0].firstChild.nodeValue;//��˰�� 
					/*��Ʊ��ѯ�����½ڵ� ��֪��֮ǰ��û�� �����ϲ��Ի�����ʱ�������
						InfoTypeCode ��Ʊ����
						InfoNumber   ��Ʊ����
						InfoBillNumber ���۵��ݱ��
						InfoAmount  �ϼƲ���˰���
						InfoTaxAmount  �ϼ�˰��
						InfoInvDate  ��Ʊ����
						PrintFlag  ��ӡ��־(0��δ��ӡ��1���Ѵ�ӡ��
						UploadFlag  ��Ʊ����״̬��0��δ���ͣ�1���ѱ��ͣ�2 ����ʧ�ܣ�3 �����У�4 ��ǩʧ�ܣ�
						CancelFlag ���ϱ�־��0��δ���ϣ�1�������ϣ�
						<Info>���ܵ�xml���� ��ʾ��ϸ��Ϣ->��Щ���ð�?<Info/>
					*/
					//alert("��췢Ʊ�ķ�Ʊ����:"+InfoNumber+",��Ʊ����:"+InfoTypeCode+",�ܽ��:"+InfoAmount+",��˰��:"+InfoTaxAmount);
					//alert("��ѯ�ɹ�");
					return true;

				}
			}else{
				alert("SID04������Ϣ��ʾ��ERROR������errcode="+errcode+";err_msg="+message);
				return false;
			}
		}
		//xl add SID05 ��ƱУ�� begin
		if(sidType=="SID05")
		{
			if("4016"==errcode){ 
			// alert("SID05 У��ɹ�");
			 return true;
			}
			 else{
				alert("SID05 ������Ϣ��ʾ��ERROR������errcode="+errcode+";err_msg="+message);
				return false;
			}
		}
		//end of SID05
		if(sidType=="SID11")
		{
			if("4011"==errcode){ 
			 //alert("SID11 ��Ʊ�ɹ�");
			 return true;
			}
			 else{
				alert("SID11 ������Ϣ��ʾ��ERROR������errcode="+errcode+";err_msg="+message);
				return false;
			}
		}
		if(sidType=="SID12")
		{
			if("5011"==errcode){
			 //alert("SID12 ��ӡ�ɹ�");
			 return true;
			}
			 else{
				alert("SID12������Ϣ��ʾ��ERROR������errcode="+errcode+";err_msg="+message);
				return false;
			}
		} 
	}
	function makes_data_6(sidType,ServerNo,ClientNo,TaxCode,spmc,ggxh,dw,sl,dj,je,se,i_length,isMulti,s_notes)//˰��Ϊ11��
	{
		//alert("%6��s_notes is "+s_notes);
		var xmlHeader = "<?xml version=\"1.0\" encoding=\"GBK\"?>";
		var send = new String();

		var client_name="˼������ֵ˰רƱ��ӡ����";//crmpd�ӿڴ� ��ǰ̨����ȡ Client�ļ���ֵ������ô����
		var seller_name="<%=seller_name%>";//�ӿؼ����Ǳ�ȡ? ��ȷ��
		var seller_bank="<%=seller_bank%>";
		var login_no="<%=workname%>";//��½���� for jiyu ��Ϊ����
		//��Ʊ���ǵ�½���� Checker������ Cashier�տ��˿ɿ�
		//��ȡ��˰����Ϣ
 
		/*------ƴװreq_��ȫ�ؼ�����Start----*/
		client_name = document.getElementById("tax_name").value;
		var tax_no1 = document.getElementById("tax_no1").value;
		var tax_address = document.getElementById("tax_address").value;
		var tax_phone = document.getElementById("tax_phone").value;
		var tax_khh = document.getElementById("tax_khh").value;
		var tax_contract_no = document.getElementById("tax_contract_no").value;
		//xl add for hanfeng���� ��Ϊ����չʾ��"��ַ���绰" ��"�����м��˺�" 
		tax_address=tax_address+" "+tax_phone;
		tax_khh=tax_khh+" "+tax_contract_no;

		send += "<data>";
		send += "<fp>";
		send += "<InfoKind>"+"0"+"</InfoKind>";
		send += "<IsMutiRate>"+"0"+"</IsMutiRate>";
		
		send += "<ClientName>"+client_name+"</ClientName>";
		send += "<ClientTaxCode>"+TaxCode+"</ClientTaxCode>";
		send += "<ClientBankAccount>"+tax_khh+"</ClientBankAccount>";
		send += "<ClientAddressPhone>"+tax_address+"</ClientAddressPhone>";
		send += "<SellerBankAccount>"+seller_name+"</SellerBankAccount>";
		send += "<SellerAddressPhone>"+seller_bank+"</SellerAddressPhone>";
		if(isMulti=="0")
		{
			send += "<TaxRate>6</TaxRate>";//˰���ǹ̶�һ��
		}
		else
		{
			send += "<TaxRate></TaxRate>";
		}
		send += "<Notes>"+s_notes+"</Notes>";
		send += "<Invoicer>"+login_no+"</Invoicer>";
		send += "<Checker></Checker>";
		send += "<Cashier></Cashier>";
		send += "<ListName/>";
		send += "<BillNumber/>";
		send += "</fp>";
		send += "<group>";
		//alert("i_length is "+i_length);
		for(var i=0;i<i_length;i++)
		{
			//alert("��Ʒ:"+spmc[i]);
			send += "<fpmx>";
			send += "<ListTaxItem>"+""+"</ListTaxItem>";
			send += "<ListGoodsName>"+spmc[i]+"</ListGoodsName>";
			send += "<ListStandard>"+ggxh[i]+"</ListStandard>";
			send += "<ListUnit>"+dw[i]+"</ListUnit>";
			send += "<ListNumber>"+sl[i]+"</ListNumber>";
			send += "<ListPrice>"+dj[i]+"</ListPrice>";
			send += "<ListAmount>"+je[i]+"</ListAmount>";
			send += "<ListPriceKind>"+"0"+"</ListPriceKind>";
			send += "<ListTaxAmount>"+se[i]+"</ListTaxAmount>";
			if(isMulti=="0")
			{
				send += "<TaxRate></TaxRate>";
			}
			else
			{
				send += "<TaxRate>6</TaxRate>";
			}
			
			send += "</fpmx>";
			
		}
		send += "</group>";
		send += "</data>";
		var sendXML = xmlHeader + send;
		alert1("sidType is "+sidType+" and xml is "+sendXML);
		var value1 = encode64(sendXML);
		return value1;
		 
	}
	//��˰�ʵ� ����Ū begin
	function makes_data_muti(sidType,ServerNo,ClientNo,TaxCode,spmc11,ggxh11,dw11,sl11,dj11,je11,se11,i_length11,spmc6,ggxh6,dw6,sl6,dj6,je6,se6,i_length6,s_notes)//��˰��
	{
		var xmlHeader = "<?xml version=\"1.0\" encoding=\"GBK\"?>";
		var send = new String();
		var client_name="˼������ֵ˰רƱ��ӡ����";//crmpd�ӿڴ� ��ǰ̨����ȡ Client�ļ���ֵ������ô����
		var seller_name="<%=seller_name%>";//�ӿؼ����Ǳ�ȡ? ��ȷ��
		var seller_bank="<%=seller_bank%>";
		var login_no="<%=workname%>";//��½����
		//��Ʊ���ǵ�½���� Checker������ Cashier�տ��˿ɿ�
		//��ȡ��˰����Ϣ
		
		/*------ƴװreq_��ȫ�ؼ�����Start----*/
		client_name = document.getElementById("tax_name").value;
		var tax_no1 = document.getElementById("tax_no1").value;
		var tax_address = document.getElementById("tax_address").value;
		var tax_phone = document.getElementById("tax_phone").value;
		var tax_khh = document.getElementById("tax_khh").value;
		var tax_contract_no = document.getElementById("tax_contract_no").value;
	    //xl add for hanfeng���� ��Ϊ����չʾ��"��ַ���绰" ��"�����м��˺�" 
		tax_address=tax_address+" "+tax_phone;
		tax_khh=tax_khh+" "+tax_contract_no;

		send += "<data>";
		send += "<fp>";
		send += "<InfoKind>"+"0"+"</InfoKind>";
		send += "<IsMutiRate>"+"1"+"</IsMutiRate>";
		send += "<ClientName>"+client_name+"</ClientName>";
		send += "<ClientTaxCode>"+TaxCode+"</ClientTaxCode>";
		send += "<ClientBankAccount>"+tax_khh+"</ClientBankAccount>";
		send += "<ClientAddressPhone>"+tax_address+"</ClientAddressPhone>";
		send += "<SellerBankAccount>"+seller_name+"</SellerBankAccount>";//�������� �˺�
		send += "<SellerAddressPhone>"+seller_bank+"</SellerAddressPhone>";//����ǵ�ַ�绰
		send += "<TaxRate></TaxRate>";
		send += "<Notes>"+s_notes+"</Notes>";
		send += "<Invoicer>"+login_no+"</Invoicer>";
		send += "<Checker></Checker>";
		send += "<Cashier></Cashier>";
		send += "<ListName/>";
		send += "<BillNumber/>";
		send += "</fp>";
		send += "<group>";
		//alert("i_length is "+i_length);
		for(var i=0;i<i_length6;i++)
		{
			//alert("��Ʒ:"+spmc[i]);
			send += "<fpmx>";
			send += "<ListTaxItem>"+""+"</ListTaxItem>";
			send += "<ListGoodsName>"+spmc6[i]+"</ListGoodsName>";
			send += "<ListStandard>"+ggxh6[i]+"</ListStandard>";
			send += "<ListUnit>"+dw6[i]+"</ListUnit>";
			send += "<ListNumber>"+sl6[i]+"</ListNumber>";
			send += "<ListPrice>"+dj6[i]+"</ListPrice>";
			send += "<ListAmount>"+je6[i]+"</ListAmount>";
			send += "<ListPriceKind>"+"0"+"</ListPriceKind>";
			send += "<ListTaxAmount>"+se6[i]+"</ListTaxAmount>";
			send += "<TaxRate>6</TaxRate>";
			send += "</fpmx>";
		}
		for(var j=0;j<i_length11;j++)
		{
			//alert("��Ʒ:"+spmc[i]);
			send += "<fpmx>";
			send += "<ListTaxItem>"+""+"</ListTaxItem>";
			send += "<ListGoodsName>"+spmc11[j]+"</ListGoodsName>";
			send += "<ListStandard>"+ggxh11[j]+"</ListStandard>";
			send += "<ListUnit>"+dw11[j]+"</ListUnit>";
			send += "<ListNumber>"+sl11[j]+"</ListNumber>";
			send += "<ListPrice>"+dj11[j]+"</ListPrice>";
			send += "<ListAmount>"+je11[j]+"</ListAmount>";
			send += "<ListPriceKind>"+"0"+"</ListPriceKind>";
			send += "<ListTaxAmount>"+se11[j]+"</ListTaxAmount>";
			send += "<TaxRate>11</TaxRate>";
			send += "</fpmx>";
		}
		send += "</group>";
		send += "</data>";
		var sendXML = xmlHeader + send;
		alert1("sidType is "+sidType+" and xml is "+sendXML);
		var value1 = encode64(sendXML);
		return value1;
	}
	//end of ��˰��
	function makes_data_11(sidType,ServerNo,ClientNo,TaxCode,spmc,ggxh,dw,sl,dj,je,se,i_length,isMulti,s_notes)//˰��Ϊ11��
	{
		var xmlHeader = "<?xml version=\"1.0\" encoding=\"GBK\"?>";
		var send = new String();
		var client_name="˼������ֵ˰רƱ��ӡ����";//crmpd�ӿڴ� ��ǰ̨����ȡ Client�ļ���ֵ������ô����
		var seller_name="<%=seller_name%>";//�ӿؼ����Ǳ�ȡ? ��ȷ��
		var seller_bank="<%=seller_bank%>";
		var login_no="<%=workname%>";//��½����
		//��Ʊ���ǵ�½���� Checker������ Cashier�տ��˿ɿ�
		//��ȡ��˰����Ϣ
		
		/*------ƴװreq_��ȫ�ؼ�����Start----*/
		client_name = document.getElementById("tax_name").value;
		var tax_no1 = document.getElementById("tax_no1").value;
		var tax_address = document.getElementById("tax_address").value;
		var tax_phone = document.getElementById("tax_phone").value;
		var tax_khh = document.getElementById("tax_khh").value;
		var tax_contract_no = document.getElementById("tax_contract_no").value;
	    //xl add for hanfeng���� ��Ϊ����չʾ��"��ַ���绰" ��"�����м��˺�" 
		tax_address=tax_address+" "+tax_phone;
		tax_khh=tax_khh+" "+tax_contract_no;

		send += "<data>";
		send += "<fp>";
		send += "<InfoKind>"+"0"+"</InfoKind>";
		send += "<IsMutiRate>"+"0"+"</IsMutiRate>";
		send += "<ClientName>"+client_name+"</ClientName>";
		send += "<ClientTaxCode>"+TaxCode+"</ClientTaxCode>";
		send += "<ClientBankAccount>"+tax_khh+"</ClientBankAccount>";
		send += "<ClientAddressPhone>"+tax_address+"</ClientAddressPhone>";
		send += "<SellerBankAccount>"+seller_name+"</SellerBankAccount>";//�������� �˺�
		send += "<SellerAddressPhone>"+seller_bank+"</SellerAddressPhone>";//����ǵ�ַ�绰
		if(isMulti=="0")
		{
			send += "<TaxRate>11</TaxRate>";//˰���ǹ̶�һ��
		}
		else
		{
			send += "<TaxRate></TaxRate>";
		}	
		
		send += "<Notes>"+s_notes+"</Notes>";
		send += "<Invoicer>"+login_no+"</Invoicer>";
		send += "<Checker></Checker>";
		send += "<Cashier></Cashier>";
		send += "<ListName/>";
		send += "<BillNumber/>";
		send += "</fp>";
		send += "<group>";
		//alert("i_length is "+i_length);
		for(var i=0;i<i_length;i++)
		{
			//alert("��Ʒ:"+spmc[i]);
			send += "<fpmx>";
			send += "<ListTaxItem>"+""+"</ListTaxItem>";
			send += "<ListGoodsName>"+spmc[i]+"</ListGoodsName>";
			send += "<ListStandard>"+ggxh[i]+"</ListStandard>";
			send += "<ListUnit>"+dw[i]+"</ListUnit>";
			send += "<ListNumber>"+sl[i]+"</ListNumber>";
			send += "<ListPrice>"+dj[i]+"</ListPrice>";
			send += "<ListAmount>"+je[i]+"</ListAmount>";
			send += "<ListPriceKind>"+"0"+"</ListPriceKind>";
			send += "<ListTaxAmount>"+se[i]+"</ListTaxAmount>";
			if(isMulti=="0")
			{
				send += "<TaxRate></TaxRate>";
			}
			else
			{
				send += "<TaxRate>11</TaxRate>";
			}
			send += "</fpmx>";
			
		}
		send += "</group>";
		send += "</data>";
		var sendXML = xmlHeader + send;
		alert1("sidType is "+sidType+" and xml is "+sendXML);
		var value1 = encode64(sendXML);
		return value1;
	}
	function makes_data_17(sidType,ServerNo,ClientNo,TaxCode,spmc,ggxh,dw,sl,dj,je,se,i_length)//˰��Ϊ17��
	{
		var xmlHeader = "<?xml version=\"1.0\" encoding=\"GBK\"?>";
		var send = new String();
		var client_name="˼������ֵ˰רƱ��ӡ����";//crmpd�ӿڴ� ��ǰ̨����ȡ Client�ļ���ֵ������ô����
		var seller_name="<%=seller_name%>";//�ӿؼ����Ǳ�ȡ? ��ȷ��
		var seller_bank="<%=seller_bank%>";
		var login_no="<%=workname%>";//��½����
		//��Ʊ���ǵ�½���� Checker������ Cashier�տ��˿ɿ�
		//��ȡ��˰����Ϣ
 
		/*------ƴװreq_��ȫ�ؼ�����Start----*/
		client_name = document.getElementById("tax_name").value;
		var tax_no1 = document.getElementById("tax_no1").value;
		var tax_address = document.getElementById("tax_address").value;
		var tax_phone = document.getElementById("tax_phone").value;
		var tax_khh = document.getElementById("tax_khh").value;
		var tax_contract_no = document.getElementById("tax_contract_no").value;
        //xl add for hanfeng���� ��Ϊ����չʾ��"��ַ���绰" ��"�����м��˺�" 
		tax_address=tax_address+" "+tax_phone;
		tax_khh=tax_khh+" "+tax_contract_no;

		send += "<data>";
		send += "<fp>";
		send += "<InfoKind>"+"0"+"</InfoKind>";
		send += "<ClientName>"+client_name+"</ClientName>";
		send += "<ClientTaxCode>"+TaxCode+"</ClientTaxCode>";
		send += "<ClientBankAccount>"+tax_khh+"</ClientBankAccount>";
		send += "<ClientAddressPhone>"+tax_address+"</ClientAddressPhone>";
		send += "<SellerBankAccount>"+seller_name+"</SellerBankAccount>";
		send += "<SellerAddressPhone>"+seller_bank+"</SellerAddressPhone>";
		send += "<TaxRate></TaxRate>";//˰���ǹ̶�һ��
		send += "<Notes></Notes>";
		send += "<Invoicer>"+login_no+"</Invoicer>";
		send += "<Checker></Checker>";
		send += "<Cashier></Cashier>";
		send += "<ListName/>";
		send += "<BillNumber/>";
		send += "</fp>";
		send += "<group>";
		//alert("i_length is "+i_length);
		for(var i=0;i<i_length;i++)
		{
			//alert("��Ʒ:"+spmc[i]);
			send += "<fpmx>";
			send += "<ListTaxItem>"+""+"</ListTaxItem>";
			send += "<ListGoodsName>"+spmc[i]+"</ListGoodsName>";
			send += "<ListStandard>"+ggxh[i]+"</ListStandard>";
			send += "<ListUnit>"+dw[i]+"</ListUnit>";
			send += "<ListNumber>"+sl[i]+"</ListNumber>";
			send += "<ListPrice>"+dj[i]+"</ListPrice>";
			send += "<ListAmount>"+je[i]+"</ListAmount>";
			send += "<ListPriceKind>"+"0"+"</ListPriceKind>";
			send += "<ListTaxAmount>"+se[i]+"</ListTaxAmount>";
			send += "</fpmx>";
			
		}
		send += "</group>";
		send += "</data>";
		var sendXML = xmlHeader + send;
		alert1("sidType is "+sidType+" and xml is "+sendXML);
		var value1 = encode64(sendXML);
		return value1;
	}
 </script> 
<%
	String nopass = (String)session.getAttribute("password");
	String phone_no = request.getParameter("phone_no");

	String begindate = request.getParameter("begindate");
	String enddate = request.getParameter("enddate");
	//xl add �½���רƱ
	String yj_date = request.getParameter("yj_date"); 
	//xl add for רƱ�ϴ�����
	String yj_end_date = request.getParameter("yj_end_date");
	String dateStr="";
	String[] inParas2 = new String[11];
	//inParas2[0]="select substr(goodsname,0,10),trim(scales),trim(units),to_char(units_money),to_char(small_money),to_char(tax_rate),to_char(tax_money),to_char(tax_invoice_tax_count) from dinvoicecntt where tax_invoice_num='2' ";
	//phone_no="13503685502";
	inParas2[0]="";//��ˮ
	inParas2[1]="02";
	inParas2[2]=opCode;
	inParas2[3]=workno;
	inParas2[4]=nopass;
	inParas2[5]=phone_no;
	inParas2[6]="";
	inParas2[7]="�½�רƱ����";
	inParas2[8]=dateStr;
	inParas2[9]=yj_date;
	 
%>
<wtc:service name="bs_TaxMmInit" retcode="retCode2" retmsg="retMsg2" outnum="14">
	<wtc:param value="<%=inParas2[0]%>"/> 
	<wtc:param value="<%=inParas2[1]%>"/>
	<wtc:param value="<%=inParas2[2]%>"/> 
	<wtc:param value="<%=inParas2[3]%>"/> 
	<wtc:param value="<%=inParas2[4]%>"/> 
	<wtc:param value="<%=inParas2[5]%>"/> 
	<wtc:param value="<%=inParas2[6]%>"/> 
	<wtc:param value="<%=inParas2[7]%>"/> 
	<wtc:param value="<%=inParas2[8]%>"/> 
	<wtc:param value="<%=inParas2[9]%>"/>
	<wtc:param value="<%=yj_end_date%>"/>
 
</wtc:service>
<wtc:array id="ret_code" scope="end" start="0"  length="2" />
<wtc:array id="ret_mx" scope="end" start="2"  length="4" />
<wtc:array id="ret_zk" scope="end" start="6"  length="4" />
<wtc:array id="ret_rate" scope="end" start="10"  length="4" />
<title>������BOSS-��ͨ�ɷ�</title>
</head>
<BODY>
<form action="" method="post" name="frm">
<textarea id="div1"></textarea>
<input type="hidden" name="tax_name" value="<%=tax_name%>">
<input type="hidden" name="tax_no1" value="<%=tax_no1%>">
<input type="hidden" name="tax_address" value="<%=tax_address%>">
<input type="hidden" name="tax_phone" value="<%=tax_phone%>">
<input type="hidden" name="tax_khh" value="<%=tax_khh%>">
<input type="hidden" name="tax_contract_no" value="<%=tax_contract_no%>">

<%
 
 
	
	if(retCode2=="000000" ||retCode2.equals("000000"))
	{
		%>
		 <!--xl add ��ѯ-->

		<input type="hidden" id="invoice_code">	
		<input type="hidden" id="invoice_number">
				<%@ include file="/npage/include/header.jsp" %>   
			<div class="title">
					<div id="title_zi">�������ѯ����</div>
				</div>
		 
		  <table cellSpacing="0">
			<tr>
				<th width="12.5%">��������</th>
				<th width="12.5%">����ͺ�</th>
				<th width="12.5%">��λ</th>
				<th width="12.5%">����</th>
				<th width="12.5%">����</th>
				<th width="12.5%">���</th>
				<th width="12.5%">˰��</th>
				<th width="12.5%">˰��</th>
				
			 
			</tr>
			<%
				int i_rate_count=Integer.parseInt(ret_rate[0][3]);//xuxza�ӿ��ṩ
				for(int i=0;i<ret_mx.length;i++)
				{
					%>
						<tr>
							<td width="12.5%"><%=ret_mx[i][0]%></td>
							<td width="12.5%"></td>
							<td width="12.5%"></td>
							<td width="12.5%">1</td>
							<td width="12.5%"><%=ret_mx[i][1]%></td>
							<td width="12.5%"><%=ret_mx[i][1]%></td>
							<td width="12.5%"><%=ret_mx[i][2]%></td>
							<td width="12.5%"><%=ret_mx[i][3]%></td>
						
						<input type="text" id="goods_name<%=i%>" value="<%=ret_mx[i][0]%>">
						<input type="text" id="dj<%=i%>" value="<%=ret_mx[i][1]%>">
						<input type="text" id="je<%=i%>" value="<%=ret_mx[i][1]%>">
						<input type="text" id="tax_rate<%=i%>" value="<%=ret_mx[i][2]%>">
						<input type="text" id="tax_money<%=i%>" value="<%=ret_mx[i][3]%>">
						</tr>
						 
						
					<%
				}
				//�ۿ�
				for(int i=0;i<ret_zk.length;i++)
				{
					 
					%>
						<tr>
							<td width="12.5%"><%=ret_zk[i][0]%></td>
							<td width="12.5%"></td>
							<td width="12.5%"></td>
							<td width="12.5%">1</td>
							<td width="12.5%"><%=ret_zk[i][1]%></td>
							<td width="12.5%"><%=ret_zk[i][1]%></td>
							<td width="12.5%"><%=ret_zk[i][2]%></td>
							<td width="12.5%"><%=ret_zk[i][3]%></td>
						<input type="text" id="goods_name_zk<%=i%>" value="<%=ret_zk[i][0]%>">
						<input type="text" id="dj_zk<%=i%>" value="<%=ret_zk[i][1]%>">
						<input type="text" id="je_zk<%=i%>" value="<%=ret_zk[i][1]%>">
						<input type="text" id="tax_rate_zk<%=i%>" value="<%=ret_zk[i][2]%>">
						<input type="text" id="tax_money_zk<%=i%>" value="<%=ret_zk[i][3]%>">
						</tr>
						 
						
					<%
					
				}
			%>
			<input type="hidden" value="<%=i_rate_count%>">
			<input type="hidden" id="lz_fphm">
			<input type="hidden" id="lz_fpdm"> 
			<input type="hidden" id="begindate" value="<%=begindate%>">
			<input type="hidden" id="enddate" value="<%=enddate%>">
			<input type="hidden" id="phone_no" value="<%=phone_no%>">
			<input type="hidden" id="yj_date" value="<%=yj_date%>">
			<input type="hidden" id="yj_end_date" value="<%=yj_end_date%>">
			<input type="hidden" id="print_sum_money" value="<%=ret_rate[0][0]%>">
			<input type="hidden" id="print_accept" value="<%=ret_rate[0][1]%>">
			<input type="hidden" id="print_ym" value="<%=ret_rate[0][2]%>">
			<tr> 
			  <td id="footer" colspan=8> 
			    
				  <input type="button" name="return1" class="b_foot" value="רƱ��ӡ" onclick="doPrint('<%=ret_mx.length%>','<%=i_rate_count%>')" >
				  &nbsp;
				  <!--
				  <input type="button" name="return1" class="b_foot" value="רƱ����" onclick="rePrint()" >
				  &nbsp;-->
				  <input type="button" name="return1" class="b_foot" value="����" onclick="window.location.href='zg12_1.jsp'" >
				  &nbsp;
					  <input type="button" name="return2" class="b_foot" value="�ر�" onClick="removeCurrentTab()" >
			  </td>
			</tr>
		  </table>
		<%
	}
	else
	{
		%>
			<script>		
				rdShowMessageDialog('<%=retCode2%>:<%=retMsg2%>',0);
				//document.location.replace('zg12_1.jsp');
				history.go(-1);
				//alert("�رղ���");
				//removeCurrentTab();
			</script>
		<%
	}
%>

	<%@ include file="/npage/include/footer_simple.jsp"%>
  <%@ include file="../../npage/common/pwd_comm.jsp" %>
</form>
 </BODY>
</HTML>