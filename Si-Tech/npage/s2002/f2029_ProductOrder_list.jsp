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
<%@ page import="java.util.*"%>
<%@ page import="com.sitech.crmpd.core.wtc.WtcUtil"%>
<%@ taglib uri="/WEB-INF/wtc.tld" prefix="wtc" %>
<%@ page contentType= "text/html;charset=GBK" %>
<%
	response.setHeader("Pragma","No-Cache");
	response.setHeader("Cache-Control","No-Cache");
  response.setDateHeader("Expires", 0);
  String workNo = (String)session.getAttribute("workNo");
  String password = (String)session.getAttribute("password");
  String org_code = (String)session.getAttribute("orgCode");
  String regionCode=org_code.substring(0,2);
  String sPOOrderNumber = request.getParameter("sPOOrderNumber");
  String sPOSpecNumber = request.getParameter("sPOSpecNumber"); 
  String p_OperType = WtcUtil.repNull(request.getParameter("p_OperType"));//��Ʒ��
  String p_operationSubType=WtcUtil.repNull(request.getParameter("p_operationSubType"));//add by lusc 2009-4-9//��Ʒ��
  String p_BusinessMode = request.getParameter("p_BusinessMode"); //add by wangzn
  String OperationSubTypeIDRadio = request.getParameter("OperationSubTypeIDRadio");
  session.setAttribute("p_OperType_f2029_1.jsp",p_OperType);      //add by wangzn
  session.setAttribute("p_BusinessMode_f2029_1.jsp",p_BusinessMode); // add by wangzn
  // out.println(p_BusinessMode+"----"+p_OperType);add by wangzn for test
  System.out.println("sPOOrderNumber="+sPOOrderNumber);
  System.out.println("sPOSpecNumber="+sPOSpecNumber);
  System.out.println("p_OperType="+p_OperType);
  System.out.println("OperationSubTypeIDRadio====="+OperationSubTypeIDRadio);
  System.out.println("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%%%%");
  
  
  String in_productspec_number = WtcUtil.repNull(request.getParameter("in_productspec_number"));
  String in_ChanceId = WtcUtil.repNull(request.getParameter("in_ChanceId"));
  String in_BatchNo =  WtcUtil.repNull(request.getParameter("in_BatchNo"));
  String poorder_type = WtcUtil.repNull(request.getParameter("poorder_type"));
  String busi_req_type = "";
  String[][] product_order_id = null;
  String[][] batchNo = null;
%>
<div id="form">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<form id="bug_form" method="post" action="">
			<input type="hidden" id="p_operationSubType" value="<%=p_operationSubType%>">
			<input type="hidden" id="attached" value="">
	      <tr>
	      	<th width="10%" nowrap>ѡ��</th>
	        <th width="20%" nowrap>��Ʒ������</th>
	        <th width="20%" nowrap>��Ʒ������ϵID</th>
	        <th width="20%" nowrap>��Ʒ�����</th>
	        <th width="30%" nowrap>��Ʒ״̬</th>	        
	      </tr>
        <tbody>
	<wtc:service name="s9102Init" outnum="20" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode1" retmsg="retMsg1">
		<wtc:param value="0"/>
		<wtc:param value="01"/>
		<wtc:param value="2029"/>
		<wtc:param value="<%=workNo%>"/>
		<wtc:param value="<%=password%>"/>
		<wtc:param value=""/>
		<wtc:param value=""/>
		<wtc:param value="<%=in_ChanceId%>"/>
		<wtc:param value="<%=regionCode%>"/>
		<wtc:param value="<%=sPOOrderNumber%>"/>
		<wtc:param value="<%=OperationSubTypeIDRadio%>"/>
		<wtc:param value="<%=p_OperType%>"/>
	</wtc:service>
	<wtc:array id="result" start="2" length="12" scope="end" />
	<wtc:array id="result2" start="14" length="3" scope="end" />
	<wtc:array id="result3" start="17" length="1" scope="end" />
	<wtc:array id="result4" start="18" length="2" scope="end" />
<%
	if(retCode1.equals("000000")) {
		if("0".equals(result2[0][0].trim())){
			%>
			<script type="text/javascript">
			if($("#p_OperType").val() == '2' || $("#p_OperType").val() == '4'){
			rdShowMessageDialog("<%=result2[0][1]%>",0);
			$("#nextoper").attr("disabled",true);
			}
			</script>
			<%
		}
		if(result.length>0) {
			for(int i=0;i<result.length;i++){
			String chkLabel = "";
			String resultTmp = result[i][11];
			System.out.println("$$$$$$$$$$$$$$$$$$$--"+resultTmp);
			
			String vProductOprType = " ";
			
			System.out.println("@:***p_OperType["+p_OperType+"]OperationSubTypeIDRadio["+OperationSubTypeIDRadio+"]");
			
			if((("2".equals(p_OperType)||"6".equals(p_OperType))&&!"10".equals(OperationSubTypeIDRadio)&&!"11".equals(OperationSubTypeIDRadio)) || "4".equals(p_OperType)){//yuanqs 2010-8-31 17:27:38
    			if("1".equals(resultTmp)){
    			    chkLabel = " checked disabled ";
    		    }else if("2".equals(resultTmp)){
    		        chkLabel = " disabled ";
    		    }else if("3".equals(resultTmp)){
    		        chkLabel = "";
    		    }
    		    if(("2".equals(p_OperType)||"4".equals(p_OperType))&&!"".equals(in_ChanceId))//�����ע����ʱ�� �˵��˵ĵ��� ��Ϊ�ڷ������������ ר��ҵ����ֱ����2029ģ��
    		    {
    		    	chkLabel = "";
    		    }
    		   
		    } else if("2".equals(p_OperType)&&("10".equals(OperationSubTypeIDRadio)||"11".equals(OperationSubTypeIDRadio))) {// yuanqs add 2010/8/31 16:51:51 400��������
		    	if("411501".equals(result[i][2])){
		    			chkLabel = " checked disabled ";
		    	}else{
		    			chkLabel = " disabled ";
		    	}
		    	
    		}else if("8".equals(p_OperType)){
    			%>
					<wtc:pubselect name="sPubSelect" outnum="1" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode" retmsg="retMsg">
					<wtc:sql>SELECT productOprType FROM dProductExamineInfo where productorder_id = '<%=result[i][0]%>' </wtc:sql>
					</wtc:pubselect>
					<wtc:array id="resultOprType" scope="end"/>
			    <%	
			    vProductOprType=resultOprType[0][0];
			    System.out.println("@:*****************\n");
			    System.out.println("@:*****************\n");
			    System.out.println("@:*****************\n");
			    System.out.println("@:***vProductOprType["+vProductOprType+"]***\n");
			    System.out.println("@:*****************\n");
			    System.out.println("@:*****************\n");
			    System.out.println("@:*****************\n");
    		}
			System.out.println("result[i][12]="+result[i][11]);
			if(p_operationSubType.equals("2|")&&result[i][10].equals("ȡ��")){
%>
	  			  <tr class="ProductOrder_contenttr" id="ProductOrder_contenttr"
	  			  	a_ProductOrderNumber="<%=result[i][0]%>"
	  			  	a_ProductID="<%=result[i][1]%>"
	  			  	a_ProductSpecNumber="<%=result[i][2]%>"
	  			  	a_AccessNumber="<%=result[i][3]%>"
	  			  	a_PriAccessNumber="<%=result[i][4]%>"
	  			  	a_Linkman="<%=result[i][5]%>"
	  			  	a_ContactPhone="<%=result[i][6]%>"
	  			  	a_Description="<%=result[i][7]%>"
	  			  	a_ServiceLevelID="<%=result[i][8]%>"
	  			  	a_POOrderNumber="<%=sPOOrderNumber%>"
	  			  	a_POSpecNumber="<%=sPOSpecNumber%>"
	  			  	a_OperationSubTypeID="<%=vProductOprType%>"
	  			  	a_OperType="OLD" 
	  			  	a_ProductOrderRateCheckFlag="0"
	  			  	a_EnableCompanyCheckFlag="0"
	  			  	a_ProductOrderCharacterCheckFlag="0"  			  	
	  			  	a_AcceptID="<%=result[i][11]%>" 
	  			  	a_ProductStatusCode="<%=result[i][9]%>" 
	  			  	a_ProductStatus="<%=result[i][10]%>"          
	  			  	> 
	  			  	<td classes="grey">
	  			  	<input type="checkbox" id="DeleteCheckBox" name="DeleteCheckBox" value="<%=result[i][2]%>" listFlag="N" <%=chkLabel%> >
						  </td>
					    <td><a class="p_ProductOrderNumber" style="cursor:hand;color:orange;" label="<%=i%>"><%=result[i][0]%></a>&nbsp;
						  </td>
						  <td class="p_ProductID"><%=result[i][1]%>&nbsp;					  	
						  </td>
						  <td class="p_ProductSpecNumber"><%=result[i][2]%>&nbsp;				  	
						  </td>	
						  <td class="a_ProductStatus"><%=result[i][10]%>&nbsp;		  	
						  </td>					  					 					 					 					 
		        </tr>
	<%			}else if(p_operationSubType.equals("A|")&&result[i][10].equals("����")){
		%>
 					 <tr class="ProductOrder_contenttr" id="ProductOrder_contenttr"
	  			  	a_ProductOrderNumber="<%=result[i][0]%>"
	  			  	a_ProductID="<%=result[i][1]%>"
	  			  	a_ProductSpecNumber="<%=result[i][2]%>"
	  			  	a_AccessNumber="<%=result[i][3]%>"
	  			  	a_PriAccessNumber="<%=result[i][4]%>"
	  			  	a_Linkman="<%=result[i][5]%>"
	  			  	a_ContactPhone="<%=result[i][6]%>"
	  			  	a_Description="<%=result[i][7]%>"
	  			  	a_ServiceLevelID="<%=result[i][8]%>"
	  			  	a_POOrderNumber="<%=sPOOrderNumber%>"
	  			  	a_POSpecNumber="<%=sPOSpecNumber%>"
	  			  	a_OperationSubTypeID="<%=vProductOprType%>"
	  			  	a_OperType="OLD"
	  			  	a_ProductOrderRateCheckFlag="0"
	  			  	a_EnableCompanyCheckFlag="0"
	  			  	a_ProductOrderCharacterCheckFlag="0"  			  	
	  			  	a_AcceptID="<%=result[i][11]%>"
	  			  	a_ProductStatusCode="<%=result[i][9]%>"
	  			  	a_ProductStatus="<%=result[i][10]%>"          
	  			  	> 
	  			  	<td classes="grey">
	  			  	<input type="checkbox" id="DeleteCheckBox" name="DeleteCheckBox" value="<%=result[i][2]%>" listFlag="N" <%=chkLabel%> >
						  </td>
					    <td><a class="p_ProductOrderNumber" style="cursor: hand;color:orange;" label="<%=i%>"><%=result[i][0]%></a>&nbsp;
						  </td>
						  <td class="p_ProductID"><%=result[i][1]%>&nbsp;					  	
						  </td>
						  <td class="p_ProductSpecNumber"><%=result[i][2]%>&nbsp;					  	
						  </td>	
						  <td class="a_ProductStatus"><%=result[i][10]%>&nbsp;					  	
						  </td>					  					 					 					 					 
		        </tr>				
<%		
					}else{
		%>
 					 <tr class="ProductOrder_contenttr" id="ProductOrder_contenttr"
	  			  	a_ProductOrderNumber="<%=result[i][0]%>"
	  			  	a_ProductID="<%=result[i][1]%>"
	  			  	a_ProductSpecNumber="<%=result[i][2]%>"
	  			  	a_AccessNumber="<%=result[i][3]%>"
	  			  	a_PriAccessNumber="<%=result[i][4]%>"
	  			  	a_Linkman="<%=result[i][5]%>"
	  			  	a_ContactPhone="<%=result[i][6]%>"
	  			  	a_Description="<%=result[i][7]%>"
	  			  	a_ServiceLevelID="<%=result[i][8]%>"
	  			  	a_POOrderNumber="<%=sPOOrderNumber%>"
	  			  	a_POSpecNumber="<%=sPOSpecNumber%>"
	  			  	a_OperationSubTypeID='<%="".equals(result2[0][2])?vProductOprType:result2[0][2]%>'   
	  			  	a_OperType="OLD"
	  			  	a_ProductOrderRateCheckFlag="0"
	  			  	a_EnableCompanyCheckFlag="0"
	  			  	a_ProductOrderCharacterCheckFlag="0"  			  	
	  			  	a_AcceptID="<%=result[i][11]%>"
	  			  	a_ProductStatusCode="<%=result[i][9]%>"
	  			  	a_ProductStatus="<%=result[i][10]%>"          
	  			  	> 
	  			  	<td classes="grey">
	  			  	<input type="checkbox" id="DeleteCheckBox" name="DeleteCheckBox" value="<%=result[i][2]%>" listFlag="N" <%=chkLabel%> >
						  </td>
					    <td><a class="p_ProductOrderNumber" style="cursor: hand;color:orange;" label="<%=i%>"><%=result[i][0]%></a>&nbsp;
						  </td>
						  <td class="p_ProductID"><%=result[i][1]%>&nbsp;					  	
						  </td>
						  <td class="p_ProductSpecNumber"><%=result[i][2]%>&nbsp;					  	
						  </td>	
						  <td class="a_ProductStatus"><%=result[i][10]%>&nbsp;					  	
						  </td>					  					 					 					 					 
		        </tr>				
<%		
					}
       }
		}
		
		if (result3.length > 0) {
			busi_req_type = result3[0][0];
		}
		if (result4.length > 0) {
			product_order_id = (String [][])result4;
		}
		System.out.println("====wanghfa==== busi_req_type = " + busi_req_type);
		for (int i = 0; i < result4.length; i ++) {
			System.out.println("====wanghfa==== product_order_id["+i+"][0] = " + product_order_id[i][0]);
			System.out.println("====wanghfa==== product_order_id["+i+"][1] = " + product_order_id[i][1]);
		}
	}
%>
          <tr id="products_buttontr">
	        	<th colspan="5" align="center">
	        		<input type="button" class="b_text" id="ProductsAdd" value="����">
	        		&nbsp;
	        		<input type="button" class="b_text" id="ProductsDel" value="ɾ��">
	          </th>
	        </tr>
	      </tbody>
		</form>  
	</table>
	<!--div><font color="red">��Ʒ���Ա��ʱֻ��������һ����Ʒ</font></div-->
</div>
<script>
//���ع�����
$("#wait2").hide();
//���º���
function ProductOrderUpdate(){   
	nextFalg="1";
	var ProductOrderTR = $(this).parent().parent();
	//var ProductOrderTR = $("#ProductOrder_contenttr");

   var p_operationSubType="<%=p_operationSubType%>";
	  var ProductOrder=[
	  	        $(ProductOrderTR).attr("a_ProductOrderNumber")            ,  //0
	  	        $(ProductOrderTR).attr("a_ProductID"         )            ,  //1
	  	        $(ProductOrderTR).attr("a_ProductSpecNumber" )            ,  //2
	  	        $(ProductOrderTR).attr("a_AccessNumber"      )            ,  //3
	  	        $(ProductOrderTR).attr("a_PriAccessNumber"   )            ,  //4
	  	        $(ProductOrderTR).attr("a_Linkman"           )            ,  //5
	  	        $(ProductOrderTR).attr("a_ContactPhone"      )            ,  //6
	  	        $(ProductOrderTR).attr("a_Description"       )            ,  //7
	  	        $(ProductOrderTR).attr("a_ServiceLevelID"    )            ,  //8
	  	        '<%=sPOOrderNumber%>'                                     ,  //9
	  	        '<%=sPOSpecNumber%>'                                      ,  //10
	  	        $(ProductOrderTR).attr("a_OperationSubTypeID")            ,  //11
	  	        $("#hiddendate_delete")                                   ,  //12
	  	        $(ProductOrderTR).data("a_PORatePlanList")                ,  //13
	  	        $(ProductOrderTR).data("a_POEnableCompanyList")           ,  //14
	  	        $(ProductOrderTR).data("a_POProductOrderCharacterList")   ,  //15	  	                                    
	  	        $(ProductOrderTR).attr("a_OperType"                   )   ,  //16
	  	        $(ProductOrderTR).attr("a_ProductOrderRateCheckFlag")     ,  //17
	  	        $(ProductOrderTR).attr("a_EnableCompanyCheckFlag")        ,  //18
	  	        $(ProductOrderTR).attr("a_ProductOrderCharacterCheckFlag"),  //19
	  	        $(ProductOrderTR).attr("a_AcceptID")                      ,  //20	  	        
	  	        $(ProductOrderTR).attr("a_ProductStatus")                 ,  //21
	  	        '<%=p_OperType%>'                                          ,  //22 wuxy add
	  	        '1',
	  	        $(ProductOrderTR).attr("p_BIZCODE")                 ,  //24
	  	        $(ProductOrderTR).attr("p_BillType")                , //25
	  	        $("#p_operationSubType").val()      ,    //26 add by lusc 2009-4-9��Ʒ������
	  	        ""                       ,              //27
	  	        ""                       ,              //28
	  	        $(ProductOrderTR).attr("a_OneTimeFee"),  //29
	  	        "",                                        //30 ��Ʒ����ɾ������
	  	        "",//31
	  	        "",//32 �����ڵ�
	  	        "" //33 �����ڵ㣨ʡ�ڣ�
	  	        ];
   var retInfo = window.showModalDialog
   (
   		'f2029_ProductOrder_detail.jsp?idRadio='+getRadiosVal(document.all.OperationSubTypeIDRadio)+'&p_OperType=<%=p_OperType%>&sProductOrderNumber='+ProductOrder[0]+'&in_productspec_number=<%=in_productspec_number%>&in_ChanceId=<%=in_ChanceId%>&in_BatchNo='+$(ProductOrderTR).attr("p_BatchNo")+'&poorder_type=<%=poorder_type%>',	     
   		ProductOrder,
   		'dialogHeight:650px; dialogWidth:850px;scrollbars:yes;resizable:no;location:no;status:no'
   );   
   $(ProductOrderTR).attr("a_ProductOrderNumber" , ProductOrder[0] );   //0
   $(ProductOrderTR).attr("a_ProductID"          , ProductOrder[1] );   //1
   $(ProductOrderTR).attr("a_ProductSpecNumber"  , ProductOrder[2] );   //2
   $(ProductOrderTR).attr("a_AccessNumber"       , ProductOrder[3] );   //3
   $(ProductOrderTR).attr("a_PriAccessNumber"    , ProductOrder[4] );   //4
   $(ProductOrderTR).attr("a_Linkman"            , ProductOrder[5] );   //5
   $(ProductOrderTR).attr("a_ContactPhone"       , ProductOrder[6] );   //6
   $(ProductOrderTR).attr("a_Description"        , ProductOrder[7] );   //7
   $(ProductOrderTR).attr("a_ServiceLevelID"     , ProductOrder[8] );   //8    
   $(ProductOrderTR).attr("a_OperationSubTypeID" , ProductOrder[11]);   //9
   //liujian 2012-8-28 13:46:07 �޸ļ�¼ �������
   $(ProductOrderTR).attr("a_selSales" , ProductOrder[12]);   
   document.all.attached.value=ProductOrder[28];
   //alert(document.all.attached.value);
   if(retInfo){
        if(this.label.trim() != "undefined" && this.label.trim() != undefined){
        	//alert("ww1");alert(this.label.trim());
        	if(document.all.DeleteCheckBox.length!="undefined" && document.all.DeleteCheckBox.length!=undefined){
                document.all.DeleteCheckBox[this.label].listFlag = "Y";
            }else{
                document.all.DeleteCheckBox.listFlag = "Y";
            }
        }
   		 var p_OperType = "<%=p_OperType%>";
   		/*�޸ĵ�ʱ�򲻿���Ԥ������Ʒ*/
   	  if(p_OperType=="4"&&ProductOrder[11]=="A|"){
   	  		if(ProductOrder[27]=="zhu"){
   	 					var chkbox=document.getElementById("DeleteCheckBox");
							var trchk= chkbox.parentNode.parentNode;
							var ta=trchk.parentNode;
							for(var j=0;j<ta.rows.length-1;j++){
									if(ta.rows[j].cells[3].innerHTML.trim()==ProductOrder[2].trim()){
			   						ta.rows[j].cells[0].firstChild.disabled=true;
									}
						  }    	  			
   	  		}else{
   	 					var chkbox=document.getElementById("DeleteCheckBox");
							var trchk= chkbox.parentNode.parentNode;
							var ta=trchk.parentNode;
							for(var j=0;j<ta.rows.length-1;j++){
									if(ta.rows[j].cells[3].innerHTML.trim()==ProductOrder[2].trim()&&ta.rows[j].cells[4].innerHTML.trim()=="����"){
										ta.rows[j].cells[0].firstChild.checked=true;
			   						ta.rows[j].cells[0].firstChild.disabled=true;
									}
						  } 			
   	  		}   	  	
   	  }
   	 // alert(p_OperType);
	 		if(p_OperType=="2"){
	   		if(ProductOrder[27]!=""&&ProductOrder[27]!="no"){
					var chkbox=document.getElementById("DeleteCheckBox");
					var trchk= chkbox.parentNode.parentNode;
					var ta=trchk.parentNode;
					//alert("����:"+ta.rows.length);
					for(var j=0;j<ta.rows.length-1;j++){
						  //alert(".."+ta.rows[j].cells[3].innerHTML+":"+ProductOrder[2]+"..");
							if(ta.rows[j].cells[4].innerHTML.trim()=="����"){
								ta.rows[j].cells[0].firstChild.checked=true;
	   						ta.rows[j].cells[0].firstChild.disabled=true;
							}else{
								ta.rows[j].cells[0].firstChild.disabled=true;
							}
				  }
	   		}else if(ProductOrder[27]==""){  			
					var chkbox=document.getElementById("DeleteCheckBox");
					var trchk= chkbox.parentNode.parentNode;
					var ta=trchk.parentNode;
					//alert("����:"+ta.rows.length);
					for(var j=0;j<ta.rows.length-1;j++){
						  //alert(".."+ta.rows[j].cells[3].innerHTML+":"+ProductOrder[2]+"..");
							if(ta.rows[j].cells[3].innerHTML.trim()==ProductOrder[2].trim()&&ta.rows[j].cells[4].innerHTML.trim()=="����"){
								//alert("���");
								ta.rows[j].cells[0].firstChild.checked=true;
	   						ta.rows[j].cells[0].firstChild.disabled=true;
	   						//alert($(".ProductOrder_contenttr").attr("a_OperationSubTypeID"));
	   						//alert(ProductOrderTR.attr("a_OperationSubTypeID"));
	   						//alert(ProductOrder[11]);
							}
				  }
				}
		}
   			$(ProductOrderTR).attr("a_ProductOrderRateCheckFlag"     ,ProductOrder[17]);
   			$(ProductOrderTR).attr("a_EnableCompanyCheckFlag"        ,ProductOrder[18]);
   			$(ProductOrderTR).attr("a_ProductOrderCharacterCheckFlag",ProductOrder[19]);
   }
   $('.p_ProductOrderNumber',ProductOrderTR).text(ProductOrder[0])                 ; 

   $('.p_ProductID',ProductOrderTR).text(ProductOrder[1])                          ; 
   $('.p_ProductSpecNumber',ProductOrderTR).text(ProductOrder[2])                  ;
   $(ProductOrderTR).data("a_PORatePlanList",ProductOrder[13])                     ;
   $(ProductOrderTR).data("a_POEnableCompanyList",ProductOrder[14])                ;
   $(ProductOrderTR).data("a_POProductOrderCharacterList",ProductOrder[15])        ;
   $(ProductOrderTR).data("a_POProductOrderCharacter",ProductOrder[30]) ;//add by lusc
   $(ProductOrderTR).attr("a_OperType",ProductOrder[16])                           ;
   $(ProductOrderTR).attr("a_AcceptID",ProductOrder[20])                           ;                                                                                
   $(ProductOrderTR).attr("p_BIZCODE",ProductOrder[21])                      ;
   $(ProductOrderTR).attr("p_BillType",ProductOrder[22])                      ;
   $(ProductOrderTR).data("a_ProductOrderManageCharacter",ProductOrder[32]);  //wangzn 2010-4-13 18:34:30 �����ڵ�
   $(ProductOrderTR).data("a_ProductOrderExamine",ProductOrder[33]);          //wangzn 2010-9-25 16:42:58 ����
   $(ProductOrderTR).attr("a_OneTimeFee" , ProductOrder[29]);   // wangzn add 2011/6/23 20:46:09
   return true;                                                           
}

//��������
function ProductOrderAdd(){ 
	   nextFalg="1";
	var pospecnumber='<%=sPOSpecNumber%>';
	 	  if(pospecnumber=="")
	 	  {
	 	  	rdShowMessageDialog("��ѡ��һ����Ʒ���"); 
       	     return;
	 	  }
	var p_businessmode = '<%=p_BusinessMode%>';
	if(p_businessmode==""){
			rdShowMessageDialog("��ѡ��ҵ��չģʽ"); 
       	     return;
	}
	testWangzn();	                                                               
	var ProductOrder=[
	  	        "" ,                  //0 
	  	        "" ,                  //1 
	  	        "" ,                  //2 
	  	        "" ,                  //3 
	  	        "" ,                  //4 
	  	        "" ,                  //5 
	  	        "" ,                  //6 
	  	        "" ,                  //7 
	  	        "" ,                  //8 
	  	        '<%=sPOOrderNumber%>',//9 
	  	        '<%=sPOSpecNumber%>', //10
	  	        "" ,                  //11
	  	        "" ,                  //12
	  	        "" ,                  //13
	  	        "" ,                  //14
	  	        "" ,                  //15
	  	        "NEW",                //16
	  	        "0",                  //17
	  	        "0",                  //18
	  	        "0",                  //19
	  	        "",                   //20
	  	        "",                    //21	  
	  	        '<%=p_OperType%>' ,     //22 wuxy add	 
	  	        '2',
	  	        "",						//24 rendi add ҵ�����
	  	        "",						//25 rendi add ���ѱ�־
	  	        $("#p_operationSubType").val()      ,    //26 add by lusc 2009-4-9��Ʒ������
	  	        "",           //27   ��������Ʒ�ַ���
	  	        "",           //28  //������Ʒ������ʶ
	  	        "",            //29  һ�����ʷ�
	  	        "",						//30 ��Ʒ����ɾ������
	  	        "1",            //31 ��Ʒ������Ϊ�޸ĵ�ʱ�� ��Ʒ��������ʶ
	  	         '<%=p_BusinessMode%>',     //32 ҵ��չģʽ add by wangzn
	  	         window,//33 �����õ�wangzn
	  	        ];  
	 var dataConsult = testFun();//wangzn 090927 
	// alert(dataConsult);	
	// alert('dataConsult.length:['+dataConsult.length+']'); 
	// alert('ProductOrder.length:['+(ProductOrder+'').length+']['+ProductOrder+']');
	// alert(dataConsult.length+(ProductOrder+'').length);
	 
	 if(dataConsult.length+(ProductOrder+'').length>1500){
	 	  var dataV = dataConsult.split('~');
	 	  var productSpecNums = '';
	 	  //alert(dataV.length);
	 	  for(var i = 0;i<dataV.length-1;i++){
	 	  	  var dataRows = dataV[i].split('$');
	 	  	
	 	     	var dataCel = dataRows[0].split('^');
	 	     	
	 	    	productSpecNums = productSpecNums+ "'"+dataCel[3]+"'";
	 	     	if(i!=dataV.length-2)
	 	   	    productSpecNums += ',';
	 	      
	 	  
	 	  }
	 	  // alert(productSpecNums);
	 	  //var sqlStr = "SELECT productspec_number,productspec_name FROM dproductspecInfo WHERE productspec_number IN ("+productSpecNums+")";
	 	  var sqlStr = "90000100";
		 	var params = productSpecNums+"|";
	 	  var selType = "S";    //'S'��ѡ��'M'��ѡ
      var retQuence = "1|0|";//�����ֶ�
      var fieldName = "��Ʒ�����|��Ʒ�������|";//����������ʾ���С�����
      var pageTitle = "���ڻ������������󣬲��ܰ����в�Ʒ������Ϊ���գ���ѡ��һ����Ʒ������Ϊ���գ�";
	 	  var path = "<%=request.getContextPath()%>/npage/public/fPubSimpSel.jsp";
      path = path + "?sqlStr=" + sqlStr + "&retQuence=" + retQuence;
      path = path + "&fieldName=" + fieldName + "&pageTitle=" + pageTitle;
      path = path + "&selType=" + selType+ "&params=" + params;
      var retInfo = window.showModalDialog(path,"","dialogWidth:40");
      if(retInfo ==undefined){
      }
      
      retInfo = retInfo.substring(0,retInfo.indexOf('|'));
	 	  
	 	  for(var i = 0;i<dataV.length-1;i++){
	 	  	  var dataRows = dataV[i].split('$');
	 	  	
	 	     	var dataCel = dataRows[0].split('^');
	 	     	
	 	    	if(dataCel[3]==retInfo){
	 	    		dataConsult = dataV[i];
	 	    		break;
	 	    	} 	
	 	  }
	 	  
	 }
	
   var retInfo = window.showModalDialog                                                         
   (                                                                                            
   "f2029_ProductOrder_detail.jsp?dataConsult="+dataConsult+"&idRadio="+getRadiosVal(document.all.OperationSubTypeIDRadio)+"&inputFlag=add&in_productspec_number=<%=in_productspec_number%>&in_ChanceId=<%=in_ChanceId%>&in_BatchNo=<%=in_BatchNo%>&poorder_type=<%=poorder_type%>",                                                                 
   ProductOrder,                                                                                    
   'dialogHeight:550px; dialogWidth:750px;scrollbars:yes;resizable:no;location:no;status:no'
   );              
   //yuanqs add 2011-3-15 17:11:41 ���Ʋ�Ʒ����Ų����ظ� begin
	var count = $(".ProductOrder_contenttr").size();
	if (count > 0)
	{
		for (var i=0; i<count; i++)
		{
			//��Ʒ�����к�������״̬�Ĳ�Ʒʱ���������� wangleic add 2011-4-6 07:07PM 
			if ( (ProductOrder[2] == $($(".ProductOrder_contenttr").get(i)).attr("a_ProductSpecNumber"))&&($($(".ProductOrder_contenttr").get(i)).attr("a_ProductStatusCode") != "2")&&($($(".ProductOrder_contenttr").get(i)).attr("a_ProductStatusCode") != "5"))
			{
				rdShowMessageDialog("��Ʒ����Ų����ظ�!");
		  		return;
			}
		}
		
	}
	//yuanqs add 2011-3-15 17:11:56 end                                                                             
   //��رհ�ť������                                                                           
   if(retInfo)                                                                                  
   {      
      //alert(ProductOrder[29]);
   	  //alert(ProductOrder[29]);  wuxy alter 20091209  listFlag=\"N\"    Ϊ listFlag=\"Y\"       
   	  //alert(ProductOrder[11]);
      var newtrstr =                                                                            
          "<tr class=\"ProductOrder_contenttr\" "+                                                
		  	  " a_ProductOrderNumber='"            +ProductOrder[0]  +"'"+                                    
		  	  " a_ProductID='"                     +ProductOrder[1]  +"'"+ 
		  	  " a_ProductSpecNumber='"             +ProductOrder[2]  +"'"+                                   			  	  
		  	  " a_AccessNumber='"                  +ProductOrder[3]  +"'"+                                    
		  	  " a_PriAccessNumber='"               +ProductOrder[4]  +"'"+                                    
		  	  " a_Linkman='"                       +ProductOrder[5]  +"'"+                                    
		  	  " a_ContactPhone='"                  +ProductOrder[6]  +"'"+   
		  	  " a_Description='"                   +ProductOrder[7]  +"'"+                                    
		  	  " a_ServiceLevelID='"                +ProductOrder[8]  +"'"+                                    
		  	  " a_POOrderNumber='"                 +ProductOrder[9]  +"'"+                                    
		  	  " a_POSpecNumber='"                  +ProductOrder[10] +"'"+
		  	  " a_OperationSubTypeID='"            +ProductOrder[11] +"'"+	
		  	  " a_selSales='"                      +ProductOrder[12] +"'"+
		  	  " a_OperType='"                      +ProductOrder[16] +"'"+
		  	  " a_ProductOrderRateCheckFlag='"     +ProductOrder[17] +"'"+              
 					" a_EnableCompanyCheckFlag='"        +ProductOrder[18] +"'"+                 
 					" a_ProductOrderCharacterCheckFlag='"+ProductOrder[19] +"'"+
 					" a_AcceptID='"                      +ProductOrder[20] +"'"+ 					
 					" p_BIZCODE='"                 +ProductOrder[21] +"'"+
 					" p_BillType='"                 +ProductOrder[22] +"'"+		
 					" a_OneTimeFee='"                 +ProductOrder[29] +"'"+		  	 		  	  	                                                                                   
		  	  ">"+                                                                                 
				  "<td classes=\"grey\"><input type=\"checkbox\" name=\"DeleteCheckBox\" id=\"DeleteCheckBox\" listFlag=\"Y\" >"+             
			    "&nbsp;</td>"+                                                                             
		      "<td><a class=\"p_ProductOrderNumber\" style=\"cursor: hand;color:orange;\">"+ProductOrder[0]+"</a>"+         
			    "&nbsp;</td>"+                                                                             
			    "<td class=p_ProductID>"+ProductOrder[1]+                                              
			    "&nbsp;</td>"+
			    "<td class=p_ProductSpecNumber>"+ProductOrder[2]+                                              
			    "&nbsp;</td>"+	
			    "<td>&nbsp;</td>"+				    					                                                                   
          "</tr>";
      $("#products_buttontr").before(newtrstr);                                                          
      //Ϊ�����и���������                                                                      
      $(".ProductOrder_contenttr:last").data("a_PORatePlanList",ProductOrder[13]);
      $(".ProductPayCompany_contenttr:last").data("a_POEnableCompanyList",ProductOrder[14]); 
      $(".ProductOrder_contenttr:last").data("a_POProductOrderCharacterList",ProductOrder[15]);
      //ע����º���                                                                            
      $('.p_ProductOrderNumber').bind('click', ProductOrderUpdate);	                               
	  }                                                                                            
}                                                                                               
//ɾ������
function ProductOrderDel(){
	nextFalg="1";
   $("input[@name='DeleteCheckBox']").each(function()
   {
   var checkTR = $(this.parentNode.parentNode);
   if($(this).attr("checked")){
   	  if($(checkTR).attr("a_OperType")=="OLD")//��������ݿ���ȡ�������ݣ����ӵ�ɾ��������
   	  {         
   	  	//wangzn 2011/6/27 18:15:56  Ϊ���ֲ�������һ�£���������d_OperType_PrdOrdRatePlan����ʵûʲô�ô�ֵȫ��OLD��                                  	  	  
   	  	  var i  = $("DIV.ProductOrder","#hiddendate_delete").size();
   	  		var deletedate=
   	  		"<DIV class='ProductOrder' style='display:none'>"+
   	  		"<input type='text' name='tableid_PrdOrd"+i+"'       value='0'>" +
   	  		"<input type='text' name='d_ProductOrderNumber_PrdOrd"+i+"' value='"+$(checkTR).attr("a_ProductOrderNumber")+"'>"+                          
   	  		"<input type='text' name='d_ProductID_PrdOrd"+i+"'          value='"+$(checkTR).attr("a_ProductID")+"'>"+            
   	  		"<input type='text' name='d_AccessNumber_PrdOrd"+i+"'       value='"+$(checkTR).attr("a_AccessNumber")+"'>"+           
   	  		"<input type='text' name='d_PriAccessNumber_PrdOrd"+i+"'    value='"+$(checkTR).attr("a_PriAccessNumber")+"'>"+            
   	  		"<input type='text' name='d_OperType_PrdOrdRatePlan"+i+"'   value='OLD'>" +
   	  		"<input type='text' name='d_Linkman_PrdOrd"+i+"'            value='"+$(checkTR).attr("a_Linkman")+"'>"+
   	  		"<input type='text' name='d_ContactPhone_PrdOrd"+i+"'       value='"+$(checkTR).attr("a_ContactPhone")+"'>"+
   	  		"<input type='text' name='d_Description_PrdOrd"+i+"'        value='"+$(checkTR).attr("a_Description")+"'>"+
   	  		"<input type='text' name='d_ServiceLevelID_PrdOrd"+i+"'     value='"+$(checkTR).attr("a_ServiceLevelID")+"'>"+ 
   	  		"<input type='text' name='d_POOrderNumber_PrdOrd"+i+"'      value='"+$(checkTR).attr("a_POOrderNumber")+"'>"+
   	  		"<input type='text' name='d_POSpecNumber_PrdOrd"+i+"'       value='"+$(checkTR).attr("a_POSpecNumber")+"'>"+
   	  		"<input type='text' name='d_OperationSubTypeID_PrdOrd"+i+"'  value='2|'>"+
   	  		"<input type='text' name='d_AcceptID_PrdOrd"+i+"' value='"+$(checkTR).attr("a_AcceptID")+"'>"+   	  		
   	  		"</DIV>";
   	  		$("#hiddendate_delete").append(deletedate);
   	  }
      checkTR.remove();
   }
   });
}   
$(document).ready(function(){
	//ע����º���
	$('.p_ProductOrderNumber').bind('click', ProductOrderUpdate);
	
	//ע����������
	$('#ProductsAdd').click(function(){
		ProductOrderAdd();
	});
	
	//ע��ɾ������
	$('#ProductsDel').click(function(){
	 ProductOrderDel();
	});
	
	//wuxy alter 20081218
	var p_OperType = "<%=p_OperType%>";
	if(p_OperType=="1"){
		$("#products_buttontr").hide();	
	}
	
	//rendi add for ѡ���ѯ��Ԥ������ͨʱ����ʾ��ť
	if(p_OperType=="2"){
		$("#products_buttontr").hide();	
	}
	if(p_OperType=="3"){
		$("#products_buttontr").hide();	
	}
	if(p_OperType=="8"){
		$("#products_buttontr").hide();	
	}
	
	//lusc add for ��Ʒ���ٿ�
	var p_operationSubType="<%=p_operationSubType%>";
	if(p_OperType=="4"){
	if(p_operationSubType.match("2")==null&&p_operationSubType.match("7")==null)
		$("#products_buttontr").hide();	
	}
	 
	if('05'=='<%=busi_req_type%>') {
		var newtrstr;
		<%
		for (int i = 0; i < result4.length; i ++) {
			%>
			newtrstr = 
				"<tr class=\"ProductOrder_contenttr\" "+
				" a_ProductOrderNumber='<%=product_order_id[i][1]%>'"+
				" a_ProductID=''"+ 
				" a_ProductSpecNumber='<%=in_productspec_number%>'"+
				" a_AccessNumber=''"+
				" a_PriAccessNumber=''"+
				" a_Linkman=''"+
				" a_ContactPhone=''"+
				" a_Description=''"+
				" a_ServiceLevelID=''"+
				" a_POOrderNumber=''"+
				" a_POSpecNumber=''"+
				" a_OperationSubTypeID='<%=OperationSubTypeIDRadio%>'"+	
				" a_selSales=''"+
				" a_OperType=''"+
				" a_ProductOrderRateCheckFlag=''"+
				" a_EnableCompanyCheckFlag=''"+
				" a_ProductOrderCharacterCheckFlag=''"+
				" a_AcceptID=''"+
				" p_BIZCODE=''"+
				" p_BillType=''"+
				" a_OneTimeFee=''"+
				" p_BatchNo='<%=product_order_id[i][0]%>'"+
				">"+
				"<td classes=\"grey\"><input type=\"checkbox\" name=\"DeleteCheckBox\" id=\"DeleteCheckBox\" listFlag=\"N\" >"+
				"&nbsp;</td>"+
				"<td><a class=\"p_ProductOrderNumber\" style=\"cursor: hand;color:orange;\"  label=\"<%=i%>\" ><%=product_order_id[i][1]%>"+"</a>"+
				"&nbsp;</td>"+
				"<td class=p_ProductID>"+
				"&nbsp;</td>"+
				"<td class=p_ProductSpecNumber>"+"<%=in_productspec_number%>"+
				"&nbsp;</td>"+	
				"<td>&nbsp;</td>"+
				"</tr>";
			$("#products_buttontr").before(newtrstr);
			//Ϊ�����и���������
			$(".ProductOrder_contenttr:last").data("a_PORatePlanList",'');
			$(".ProductPayCompany_contenttr:last").data("a_POEnableCompanyList",'');
			$(".ProductOrder_contenttr:last").data("a_POProductOrderCharacterList",'');
			<%
		}
		%>
		
		//ע����º���
		$('.p_ProductOrderNumber').bind('click', ProductOrderUpdate);
		
		$("#products_buttontr").hide();
	}
	
});

function showConsult(obj){
	var dataConsult=obj.toString();
	window.open("<%=request.getContextPath()%>/npage/s2002/f2029_showConsultPage.jsp?dataConsult="+dataConsult,"","toolbar = 0");
}
</script>