<%
   /*
   * 功能: 问题反馈
　 * 版本: v1.0
　 * 日期: 2008年10月25日
　 * 作者: piaoyi
　 * 版权: sitech
   * 修改历史
   * 修改日期      修改人      修改目的
 　*/
%>
<%@ page import="java.util.*"%>
<%@ page import="com.sitech.crmpd.core.wtc.WtcUtil"%>
<%@ taglib uri="/WEB-INF/wtc.tld" prefix="wtc" %>
<%@ page contentType= "text/html;charset=GBK" %>

<%
  String workNo = (String)session.getAttribute("workNo");
  String org_code = (String)session.getAttribute("orgCode");
  String regionCode=org_code.substring(0,2);
  String sPOOrderNumber = request.getParameter("sPOOrderNumber");
  String sPOSpecNumber = request.getParameter("sPOSpecNumber");
  String sProductOrderNumber = request.getParameter("sProductOrderNumber");
  String sCheckFlag1 = request.getParameter("sCheckFlag1");     
  String sProductSpecNumber = request.getParameter("sProductSpecNumber");
  System.out.println("sProductSpecNumber="+sProductSpecNumber);
  String sParAccpetID = request.getParameter("sParAccpetID");  
  String p_OperType = WtcUtil.repNull(request.getParameter("p_OperType"));    //wuxy add
  System.out.println("====wanghfa==== p_OperType = " + p_OperType);
  String product_OperType = WtcUtil.repNull(request.getParameter("product_OperType"));  //lusc add
  String product_add_flag=WtcUtil.repNull(request.getParameter("product_add_flag"));  //lusc add
  System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%sProductOrderNumber="+sProductOrderNumber);
  System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%sProductSpecNumber="+sProductSpecNumber);
   System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%sCheckFlag1="+sCheckFlag1);
   
   String in_ChanceId = WtcUtil.repNull(request.getParameter("in_ChanceId"));
    System.out.println("====wanghfa==== in_ChanceId = " + in_ChanceId);
   
   String in_BatchNo =  WtcUtil.repNull(request.getParameter("in_BatchNo"));
   String busi_req_type = "";
   String in_productspec_number = "";
   if(!"".equals(in_ChanceId)){
          String [] paraIn = new String[2];
          paraIn[0] = "SELECT BUSI_REQ_TYPE FROM DBSALESADM.DMKTCHANCE WHERE CHANCE_ID = :in_ChanceId";    
          paraIn[1] = "in_ChanceId="+in_ChanceId;
          String sqlArrEC = "SELECT a.custmoter_ec_id,d.pospec_number,d.productspec_name,d.productspec_number FROM dcustomerinfo a ,dbsalesadm.dMKTChanceCustRel b ,dbsalesadm.dmktchanceprodrel c,dproductspecinfo d WHERE trim(a.customer_id) = b.cust_id_no AND b.chance_id = c.chance_id AND c.pospec_num = trim(d.pospec_number) AND c.productspec_num = d.productspec_number AND b.chance_id=:in_ChanceId";
          %>
			<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode12" retmsg="retMsg12" outnum="1" >
				<wtc:param value="<%=paraIn[0]%>"/>
				<wtc:param value="<%=paraIn[1]%>"/> 
			</wtc:service>
			<wtc:array id="retArrType" scope="end"/>
				
			<wtc:service name="TlsPubSelCrm" routerKey="region" routerValue="<%=regionCode%>" retcode="retCode12" retmsg="retMsg12" outnum="4" >
				<wtc:param value="<%=sqlArrEC%>"/>
				<wtc:param value="<%=paraIn[1]%>"/> 
			</wtc:service>
			<wtc:array id="retArrEC" scope="end"/>
    <%
       if(retArrType.length>0){
              busi_req_type = retArrType[0][0];
       }
       if(retArrEC.length>0){
              in_productspec_number = retArrEC[0][3];  
       }
   }
%>

<div id="form">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<form id="bug_form" method="post" action="">
			
			<!-- add by lusc 2009-04-09
			--> 
			<input type="hidden" id="product_OperType" value="<%=product_OperType%>">
		  <!--//////////////////// -->
	      <tr>
	      	<th width="15%" nowrap>选择</th>
	        <th width="25%" nowrap>资费计划标识</th>	        	        
	        <th width="60%" nowrap>资费描述</th>
	      </tr>
        <tbody>
<%if(sCheckFlag1.equals("0")){%>
<wtc:service name="s9102DetQry" outnum="14" routerKey="region" routerValue="<%=regionCode%>">		
	<wtc:param value="<%=sProductOrderNumber%>"/>		
	<wtc:param value="<%=sProductSpecNumber%>"/>		
  <wtc:param value="4"/>
	<%
	if (("01".equals(busi_req_type) || "02".equals(busi_req_type)||"03".equals(busi_req_type)) && !"6".equals(p_OperType)) {
		%>
	  <wtc:param value="<%=in_ChanceId%>"/>
		<%
	}
	%>
</wtc:service>
<wtc:array id="result" start="2" length="12" scope="end" />
<%
if(retCode.equals("000000")){
	if(result.length>0){
		for(int i=0;i<result.length;i++){		
%>
  			<tr class="ProductRatePlan_contenttr"
  				 a_RatePlanID         = "<%=result[i][4]%>"
  				 a_Description        = "<%=result[i][5]%>" 			  	 
           a_POOrderNumber      = "<%=sPOOrderNumber%>"
           a_POSpecNumber       = "<%=sPOSpecNumber%>"
           a_ProductOrderNumber = "<%=sProductOrderNumber%>"           
           a_ProdcutOrderICBsCheckFlag="0"
           a_OperType = "<%=result[i][7]%>"
           a_ProductSpecNumber  = "<%=sProductSpecNumber%>"    
           a_ParAcceptID = "<%=sParAccpetID%>" 
           a_AcceptID = "<%=result[i][6]%>"
  			>	
  			  <td classes="grey"><input type="checkbox" name="DeleteCheckBox" value="0">
				  </td>				
				  <td>
				  <a class="p_RatePlanID" style="cursor: hand;"><%=result[i][4]%></a>						  	
				  </td>
				  <td class=p_Description><%=result[i][5]%>
				  &nbsp;</td>
	      </tr>
<%
      }
    }
  }
}
%>
          <tr id="buttontr1">
	        	<th colspan="5" align="center">
	        		<input type="button" class="b_text" id="RatePlanAdd" value="新增">
	        		&nbsp;      
	        		<input type="button" class="b_text" id="RatePlanDel" value="删除">      
	          </th>
	        </tr>
	      </tbody>
		</form>
	</table>
</div>
<script>
//隐藏滚动条
$("#wait2").hide();
	 //更新函数
	function RatePlanUpdate(){
		
    var RatePlanUpdateTR = $(this).parent().parent();    
	 	var RatePlan=[
	 	  	        	$(RatePlanUpdateTR).attr("a_RatePlanID")               ,//0                    
	 	  	        	$(RatePlanUpdateTR).attr("a_Description")              ,//1	  	              
	 	  	        	'<%=sPOOrderNumber%>'                                  ,//2                    
	 	  	        	'<%=sPOSpecNumber%>'                                   ,//3                     	  	        
	 	  	        	'<%=sProductOrderNumber%>'                             ,//4                    
	 	  	        	$(RatePlanUpdateTR).attr("a_ProdcutOrderICBsCheckFlag"),//5 checkflag            
	 	  	        	$(RatePlanUpdateTR).data("a_ProdcutOrderICBsList")     ,//6 ProdcutOrderICBsList 
	 	            	ProductOrder[12]                                       ,//7                                       //7 hidden_delete 
	 	            	$(RatePlanUpdateTR).attr("a_OperType")                 ,//8 OperType
	 	            	$(RatePlanUpdateTR).attr("a_ProductSpecNumber")        ,//9
	 	            	$(RatePlanUpdateTR).attr("a_ParAcceptID")              ,//10
	 	            	$(RatePlanUpdateTR).attr("a_AcceptID")                 , //11
	 	            	'<%=p_OperType%>'  ,                                      //12  wuxy add
	 	            	'1',
	 	            	$(RatePlanUpdateTR).data("a_ProductCodeICBsList") 	//add by rendi 14
	 	            	,$("#product_OperType").val()   //15   add by lusc 2009-04-09
	               ];	  
	  var retInfo = window.showModalDialog
	  (
	  'f2029_ProductOrderRatePlan_detail.jsp?in_ChanceId=<%=in_ChanceId%>&busi_req_type=<%=busi_req_type%>&',
	  RatePlan,
	  'dialogHeight:500px; dialogWidth:700px;scrollbars:yes;resizable:no;location:no;status:no'
	  );
	  if(retInfo){
	    $(RatePlanUpdateTR).attr("a_ProdcutOrderICBsCheckFlag",RatePlan[5] );//5 
	  }
    $(RatePlanUpdateTR).attr("a_RatePlanID"        ,RatePlan[0]  );//0         
    $(RatePlanUpdateTR).attr("a_Description"       ,RatePlan[1]  );//1         
    $(RatePlanUpdateTR).attr("a_POOrderNumber"     ,RatePlan[2]  );//2         
    $(RatePlanUpdateTR).attr("a_POSpecNumber"      ,RatePlan[3]  );//3         
    $(RatePlanUpdateTR).attr("a_ProductOrderNumber",RatePlan[4]  );//4      
    $(RatePlanUpdateTR).attr("a_OperType"          ,RatePlan[8]  );//8
    $(RatePlanUpdateTR).attr("a_ProductSpecNumber" ,RatePlan[9]  );//9
    $(RatePlanUpdateTR).attr("a_ParAcceptID"       ,RatePlan[10] );//10
    $(RatePlanUpdateTR).attr("a_AcceptID"          ,RatePlan[11] );//11
    
    $('.p_RatePlanID' ,RatePlanUpdateTR).text(RatePlan[0]);                 
    $('.p_Description',RatePlanUpdateTR).text(RatePlan[1]);  
    $(RatePlanUpdateTR).data("a_ProdcutOrderICBsList",RatePlan[6]);
    $(RatePlanUpdateTR).data("a_ProductCodeICBsList" ,RatePlan[14] );//14      
    return true;                                                                    
	}
	
//新增函数                                                                                    
function RatePlanAdd(){
	/*
	liujian 2012-7-3 17:40:12 产品级资费列表支持多个
	if($(".ProductRatePlan_contenttr").size()){
  		rdShowMessageDialog("已申请产品资费，请删除后在增加!"); 
  		return;
	}
	*/
	$("#product_OperType").val('<%=product_OperType%>');//wangzn 2010-5-5 13:09:37
	var RatePlan=[
	  	        ""                        ,//0
	  	        ""                        ,//1	  	        
	  	        '<%=sPOOrderNumber%>'     ,//2 
	  	        '<%=sPOSpecNumber%>'      ,//3
	  	        '<%=sProductOrderNumber%>',//4
	  	        '0'                       ,//5  checkflag
	  	        ""                        ,//6  ProdcutOrderICBsList
	  	        ""                        ,//7  hidden_delete
	  	        "NEW"                     ,//8 
	  	        "<%=sProductSpecNumber%>" ,//9
	  	        "<%=sParAccpetID%>"       ,//10
	  	        ""  ,                       //11
	  	        '<%=p_OperType%>',                                        //12  wuxy add    
	  	        '2',
	  	        ""				//add by rendi for返回产品订购信息
	  	        ,$("#product_OperType").val()   //15   add by lusc 2009-04-09
	  	        ,'<%=product_add_flag%>'   //add by lusc 09-4-30 
	  	        ];                                        
   var retInfo = window.showModalDialog                                                         
   (                                                                                            
   "f2029_ProductOrderRatePlan_detail.jsp?in_ChanceId=<%=in_ChanceId%>&busi_req_type=<%=busi_req_type%>&in_productspec_number=<%=in_productspec_number%>&in_BatchNo=<%=in_BatchNo%>",                                                                 
   RatePlan,                                                                                    
   'dialogHeight:550px; dialogWidth:750px;scrollbars:yes;resizable:no;location:no;status:no'    
   );                                                                                           
   //点关闭按钮不新增   
   //yuanqs add 2011-3-15 17:17:34 限制资费计划标识不能重复 begin
	var count = $(".ProductRatePlan_contenttr").size();
	if (count > 0)
	{
		for (var i=0; i<count; i++)
		{
			if ( RatePlan[0] == $($(".ProductRatePlan_contenttr").get(i)).attr("a_RatePlanID") )
			{
				rdShowMessageDialog("资费计划标识不能重复!");
		  		return;
			}
		}
		
	}
	//yuanqs add 2011-3-15 17:17:52 end                                                                        
   if(retInfo)                                                                                  
   {      	                                                                                       
      var newtrstr =                                                                            
           "<tr class=\"ProductRatePlan_contenttr\" "+                                                
		  	  " a_RatePlanID='"                + RatePlan[0]  +"'"+                                    
		  	  " a_Description='"               + RatePlan[1]  +"'"+
		  	  " a_POOrderNumber='"             + RatePlan[2]  +"'"+ 
		  	  " a_POSpecNumber='"              + RatePlan[3]  +"'"+ 
		  	  " a_ProductOrderNumber='"        + RatePlan[4]  +"'"+
		  	  " a_ProdcutOrderICBsCheckFlag='" + RatePlan[5]  +"'"+  
		  	  " a_OperType='"                  + RatePlan[8]  +"'"+ 
		  	  " a_ProductSpecNumber='"         + RatePlan[9]  +"'"+  
		  	  " a_ParAcceptID='"               + RatePlan[10] +"'"+ 
		  	  " a_AcceptID='"                  + RatePlan[11] +"'"+ 
		  	  ">"+                                                                                 
				  "<td classes=\"grey\"><input type=\"checkbox\" name=\"DeleteCheckBox\">"+            
			    "</td>"+                                                                             
		      "<td><a class=\"p_RatePlanID\" style=\"cursor: hand;\">"+RatePlan[0]+"</a>"+         
			    "&nbsp</td>"+                                                           
			    "<td class=p_Description>"+RatePlan[1]+                                              
			    "&nbsp</td>"+					    					                                                                   
          "</tr>";                                                                               
      $("#buttontr1").before(newtrstr);                                                          
      //为新增行赋数组属性                                                                      
      $(".ProductRatePlan_contenttr:last").data("a_ProdcutOrderICBsList",RatePlan[6]);
      $(".ProductRatePlan_contenttr:last").data("a_ProductCodeICBsList",RatePlan[14]);                       
      //注册更新函数                                                                            
      $('.p_RatePlanID').bind('click', RatePlanUpdate);	                               
	  }
}

//删除函数
function RatePlanDel(){
		var i  = $("DIV.ProductOrderRatePlan","#hiddendate_delete").size();
   $("input[@name='DeleteCheckBox']").each(function()
   {
   var checkTR = $(this.parentNode.parentNode);
   if($(this).attr("checked")){
   	  if($(checkTR).attr("a_OperType")=="OLD")//如果是数据库中取出的数据，添加到删除缓冲区
   	  { 	  	 
   	  	  
   	  		var deletedate=
   	  		    "<DIV class='ProductOrderRatePlan' style='display:none'>"+
   	  		    "<input type='text' name='tableid_PrdOrdRatePlan"+i+"'              value='4'>" +
   	  		    "<input type='text' name='d_RatePlanID_PrdOrdRatePlan"+i+"'         value='"+$(checkTR).attr("a_RatePlanID")+"'>"+                          
   	  		    "<input type='text' name='d_Description_PrdOrdRatePlan"+i+"'        value='"+$(checkTR).attr("a_Description")+"'>"+            
   	  		    "<input type='text' name='d_POOrderNumber_PrdOrdRatePlan"+i+"'      value='"+$(checkTR).attr("a_POOrderNumber")+"'>"+
   	  		    "<input type='text' name='d_POSpecNumber_PrdOrdRatePlan"+i+"'       value='"+$(checkTR).attr("a_POSpecNumber")+"'>"+
   	  		    "<input type='text' name='d_ProductOrderNumber_PrdOrdRatePlan"+i+"' value='"+$(checkTR).attr("a_ProductOrderNumber")+"'>"+
   	  		    "<input type='text' name='d_ProductSpecNumber_PrdOrdRatePlan"+i+"'  value='"+$(checkTR).attr("a_ProductSpecNumber")+"'>"+
   	  		    "<input type='text' name='d_ParAcceptID_PrdOrdRatePlan"+i+"'        value='"+$(checkTR).attr("a_ParAcceptID")+"'>"+
   	  		    "<input type='text' name='d_AcceptID_PrdOrdRatePlan"+i+"'           value='"+$(checkTR).attr("a_AcceptID")+"'>"+
   	  		    "</DIV>";
   	  		   alert(i);
   	  		ProductOrder[12].append(deletedate);
   	  		i++;
   	  }
      checkTR.remove();
   }
   });
}

$(document).ready(function(){
	///////////add by lusc 2009-04-08
	var product_OperType="<%=product_OperType%>";
	//alert("产品级操作 "+product_OperType);
	///////////////////////////////////////////////////////
   if(ProductOrder[17]=="1"){
   		if(ProductOrder[13]){
   			 $.each(ProductOrder[13], function(i){   			 	
   			 	   var RatePlan = ProductOrder[13][i];//行数据数组,传递给详细信息页面	
   			     var newtrstr =                                                                            
             "<tr class=\"ProductRatePlan_contenttr\" "+                                                
		  	     " a_RatePlanID='"                + RatePlan[0]  +"'"+                                    
		  	     " a_Description='"               + RatePlan[1]  +"'"+
		  	     " a_POOrderNumber='"             + RatePlan[2]  +"'"+ 
		  	     " a_POSpecNumber='"              + RatePlan[3]  +"'"+ 
		  	     " a_ProductOrderNumber='"        + RatePlan[4]  +"'"+
		  	     " a_ProdcutOrderICBsCheckFlag='" + RatePlan[5]  +"'"+  
		  	     " a_OperType='"                  + RatePlan[8]  +"'"+	 
		  	     " a_ProductSpecNumber='"         + RatePlan[9]  +"'"+	 
		  	     " a_ParAcceptID='"               + RatePlan[10] +"'"+	 	                                                                           
		  	     " a_AcceptID='"                  + RatePlan[11] +"'"+	
		  	     ">"+                                                                                 
				     "<td classes=\"grey\"><input type=\"checkbox\" name=\"DeleteCheckBox\">"+            
			       "</td>"+                                                                             
		         "<td><a class=\"p_RatePlanID\" style=\"cursor: hand;\">"+RatePlan[0]+"</a>"+         
			       "</td>"+                                                           
			       "<td class=p_Description>"+RatePlan[1]+                                              
			       "</td>"+					    					                                                                   
             "</tr>";                                                                                        
             $("#buttontr1").before(newtrstr);
             //为新增行赋数组属性
             $(".ProductRatePlan_contenttr:last").data("a_ProdcutOrderICBsList",RatePlan[6]);
             $(".ProductRatePlan_contenttr:last").data("a_ProductCodeICBsList",RatePlan[12]);
             //注册更新函数
             $('.p_RatePlanID').bind('click', RatePlanUpdate);
   			 });
   			
   		}
   }else{   	  
   	  ProductOrder[17]="1"   	  
   }
   
   //注册更新函数
	 $('.p_RatePlanID').bind('click', RatePlanUpdate);
	 
	 //注册新增函数
	 $('#RatePlanAdd').click(function(){
	     RatePlanAdd();
	 });	 
	 //注册删除函数
	 $('#RatePlanDel').click(function(){
	     RatePlanDel();
	 });
	 //wuxy add
	 var p_OperType = "<%=p_OperType%>";
	 if(p_OperType=="1"){
	 	$("#buttontr1").hide();	
	 } 	 
	 //add by rendi
	 if(p_OperType=="2"){
	 	$("#buttontr1").hide();	
	 } 
	 if(p_OperType=="3"){
	 	$("#buttontr1").hide();	
	 }
	 //add by lusc 2009-04-07
	 if(p_OperType=="4"){
	 		if(product_OperType.match("5")==null){
	 	 		$("#buttontr1").hide();	
	 		}
	 		var flag="<%=product_add_flag%>";
	 		if(flag=="1"){
	 			$("#buttontr1").show();	
	 		}
	 }
	 //wangzn 2010-5-5 17:20:22
	 //if("05"=="<%=busi_req_type%>"){
	 //	  $('#RatePlanAdd').click();
	 //}
	 
	 if(p_OperType=="8"){
	 	$("#buttontr1").hide();	
	 }
	  	 	  
});
</script>
