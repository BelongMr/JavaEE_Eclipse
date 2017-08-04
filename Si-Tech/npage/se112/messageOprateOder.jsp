<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib uri="/WEB-INF/xservice.tld" prefix="s"%>
<%@ include file="/npage/include/public_title_ajax.jsp"%>
<%@page import="java.util.*"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.sitech.crmpd.core.bean.MapBean"%>
<%@page import="com.sitech.crmpd.core.util.SiUtil"%>
<%@page import="com.sitech.crmpd.core.bean.MapBean"%>
<%@page import="org.json.*"%>

<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="com.sitech.crmpd.core.bean.MapBean"%>
<%@ page import="com.sitech.crmpd.core.exception.BusiAppException"%>
<%@ page import="com.sitech.crmpd.core.wtc.utype.UType"%>
<%@ page import="com.sitech.crmpd.core.xml.IXMLReader"%>
<%@ page import="com.sitech.crmpd.core.xml.impl.StAXReaderFactory"%>
<%@ page import="com.sitech.crmpd.core.xml.impl.Unmarshalling"%>
<%Date start = new Date(); %>
<%!
static Logger logger = Logger.getLogger("messageOprateOder.jsp");

public class SaleXml2Utype {
 
  //utype类型
  public String STRING="STRING";
  public String LONG="LONG";
  public String INT="INT";
  public String DOUBLE="DOUBLE";
  
  //营销domain_type,P：资费 S：积分 Z：资源 F：费用 FQ：银行卡分期付款；PH：手机凭证；SP：SP业务
  public String DOMAIN_TYPE_P="P";
  public String DOMAIN_TYPE_S="S";
  public String DOMAIN_TYPE_Z="Z";
  public String DOMAIN_TYPE_F="F";
  public String DOMAIN_TYPE_FQ="FQ";
  public String DOMAIN_TYPE_PH="PH";
  public String DOMAIN_TYPE_SP="SP";
 
  public String NO_KEY_VALUE="N/A";//如果mapbean没有找到key，一般都是返回N/A
	
  public SaleXml2Utype(){		
  }
	
  public UType chgXml2Utype(String inStr) throws BusiAppException {
 
	//1.xml转成mapbean
	SaleXml2Utype xml2utype=new SaleXml2Utype();
	MapBean mapbean=xml2utype.xml2mapbean(inStr);
		
	String curTime=mapbean.getString("REQUEST_INFO.OPR_INFO.OP_TIME");
	/***
	UType CustInfoRequest = new UType();
	
	UType MsgHeader = new UType();
	CustInfoRequest.setUe(MsgHeader);//定义完就直接set，避免忘记。
	
	String MsgType="0";
	String RecordType="0";
	String Version="0";
	MsgHeader.setUe(STRING, MsgType);
	MsgHeader.setUe(STRING, RecordType);
	MsgHeader.setUe(STRING, Version);
	
	CustInfoRequest.setUe(MsgBody);
	***/
	
	
	UType MsgBody = new UType();
	
	
	//---------------OprInfo------------------
	UType OprInfo = new UType();
	MsgBody.setUe(OprInfo);//定义完就直接set，避免忘记。
	
	String LoginAccept=mapbean.getString("REQUEST_INFO.OPR_INFO.LOGINACCEPT");
	logger.info("----------------LoginAccept="+LoginAccept);
	String OpCode=mapbean.getString("REQUEST_INFO.OPR_INFO.OP_CODE");
	String LoginNo=mapbean.getString("REQUEST_INFO.OPR_INFO.LOGIN_NO");
	String LoginPwd=mapbean.getString("REQUEST_INFO.OPR_INFO.LOGIN_PWD");
	String IpAddress=mapbean.getString("REQUEST_INFO.OPR_INFO.IP_ADDRESS");
	String OprGroupId=mapbean.getString("REQUEST_INFO.OPR_INFO.GROUP_ID");
	String OpTime=curTime;
	String RegionCode=mapbean.getString("REQUEST_INFO.OPR_INFO.REGION_ID");
	String OpNote=mapbean.getString("REQUEST_INFO.OPR_INFO.SYS_NOTE");
	String SiteId=mapbean.getString("REQUEST_INFO.OPR_INFO.GROUP_ID");
	String ObjectId=mapbean.getString("REQUEST_INFO.OPR_INFO.GROUP_ID");
	String ActClass=mapbean.getString("REQUEST_INFO.OPR_INFO.ACTION_TYPE");
	String ActId=mapbean.getString("REQUEST_INFO.OPR_INFO.ACTION_ID");
	String MeansId=mapbean.getString("REQUEST_INFO.OPR_INFO.MEANS_ID");
	System.out.println("OpNote====================="+OpNote);
	
	OprInfo.setUe(LONG, LoginAccept);
	OprInfo.setUe(STRING, OpCode);
	OprInfo.setUe(STRING, LoginNo);
	OprInfo.setUe(STRING, LoginPwd);
	OprInfo.setUe(STRING, IpAddress);
	OprInfo.setUe(STRING, OprGroupId);
	OprInfo.setUe(STRING, OpTime);
	OprInfo.setUe(STRING, RegionCode);
	OprInfo.setUe(STRING, OpNote);
	OprInfo.setUe(STRING, SiteId);
	OprInfo.setUe(STRING, ObjectId);
	OprInfo.setUe(STRING, ActClass);
	OprInfo.setUe(STRING, ActId);
	OprInfo.setUe(STRING, MeansId);
		
	UType PrintInfo = new UType();
	OprInfo.setUe(PrintInfo);
	
	  String AactionName=mapbean.getString("REQUEST_INFO.PRINT_INFO.ACTION_NAME");
	  String CustName=mapbean.getString("REQUEST_INFO.PRINT_INFO.CUST_NAME");
	  String PhoneNo=mapbean.getString("REQUEST_INFO.PRINT_INFO.PHONE_NO");
	  String PrintFlag=mapbean.getString("REQUEST_INFO.PRINT_INFO.PRINT_FLAG");
	  String PayMoneyBig=mapbean.getString("REQUEST_INFO.PRINT_INFO.PAY_MONEYBIG");
	  String PayMoneySmall=mapbean.getString("REQUEST_INFO.PRINT_INFO.PAY_MONEYSMALL");
	  String PaySpecialBig=mapbean.getString("REQUEST_INFO.PRINT_INFO.PAY_SPECIALBIG");
	  String PaySpecailSmall=mapbean.getString("REQUEST_INFO.PRINT_INFO.PAY_SPECIALSMALL");
	  String ResourceBrand=mapbean.getString("REQUEST_INFO.PRINT_INFO.RESOURCEBRAND");
	  String ResourceModel=mapbean.getString("REQUEST_INFO.PRINT_INFO.RESOURCE_MODEL");
	  String IMEICode=mapbean.getString("REQUEST_INFO.PRINT_INFO.IMEI_CODE");
	  String LoginName=mapbean.getString("REQUEST_INFO.PRINT_INFO.LOGIN_NAME");
	  PrintInfo.setUe(STRING, AactionName);
	  PrintInfo.setUe(STRING, CustName);
	  PrintInfo.setUe(STRING, PhoneNo);
	  PrintInfo.setUe(STRING, PrintFlag);
	  PrintInfo.setUe(STRING, PayMoneyBig);
	  PrintInfo.setUe(STRING, PayMoneySmall);
	  PrintInfo.setUe(STRING, PaySpecialBig);
	  PrintInfo.setUe(STRING, PaySpecailSmall);
	  PrintInfo.setUe(STRING, ResourceBrand);
	  PrintInfo.setUe(STRING, ResourceModel);
	  PrintInfo.setUe(LONG, IMEICode);
	  PrintInfo.setUe(STRING, LoginName);
	  
		UType payStages = new UType();
		OprInfo.setUe(payStages);
	  
		List busiInfoNodeList=mapbean.getList("REQUEST_INFO.BUSIINFO_LIST.BUSIINFO");
		int busiInfoNodeSize=busiInfoNodeList.size();
		String domainType="";
		String phoneType="";
		MapBean busiInfoMap=null;
		for(int i=0;i<busiInfoNodeSize;i++){
			busiInfoMap=new MapBean( (Map)busiInfoNodeList.get(i) );
			domainType= busiInfoMap.getString("DOMAIN_TYPE");
			if(domainType.toUpperCase().equals(DOMAIN_TYPE_FQ)){//分期付款
				//判断是否有分期付款STAGES_PAY节点，如果没有，就是默认值0
				Object stagesPayNode=busiInfoMap.getValue("BUSI_MODEL.STAGES_PAY");
				if(null!=stagesPayNode && !stagesPayNode.equals(NO_KEY_VALUE)){
					  String stagesPayType=busiInfoMap.getString("BUSI_MODEL.STAGES_PAY.STAGES_PAY_TYPE");
					  String payBank=busiInfoMap.getString("BUSI_MODEL.STAGES_PAY.PAY_BANK");
					  String payMonths=busiInfoMap.getString("BUSI_MODEL.STAGES_PAY.PAY_MONTH");
					  String monthRate=busiInfoMap.getString("BUSI_MODEL.STAGES_PAY.MONTH_RATE");
					  payStages.setUe(STRING, stagesPayType);
					  payStages.setUe(STRING, payBank);
					  payStages.setUe(STRING, payMonths);
					  payStages.setUe(STRING, monthRate);					
				}else{
					  payStages.setUe(STRING, "0");
					  payStages.setUe(STRING, "0");
					  payStages.setUe(STRING, "0");
					  payStages.setUe(STRING, "0");						
				}

				break;//只需要处理分期付款的数据
			}			
		} //end for.
	
	//oldLoginAccept 取消使用，订购不用，给个固定值0。
	String oldLoginAccept=mapbean.getString("REQUEST_INFO.OPR_INFO.OLD_LOGINACCEPT");
	if(null!=oldLoginAccept && !NO_KEY_VALUE.equals(oldLoginAccept)  ){
		OprInfo.setUe(STRING, oldLoginAccept);
	}else{
		OprInfo.setUe(STRING, "0");
	}
	
	OprInfo.setUe(STRING, mapbean.getString("REQUEST_INFO.OPR_INFO.SERVICE_NO") );//MainPhone
	
	//---------------CustOrder------------------
	UType CustOrder = new UType();
	MsgBody.setUe(CustOrder);
	
	UType CustOrderMsg = new UType();
	CustOrder.setUe(CustOrderMsg);
	  String CustOrderId=mapbean.getString("REQUEST_INFO.OPR_INFO.CUSTORDERID");
	  CustOrderMsg.setUe(STRING, CustOrderId);
	
	
	UType OrderArrayList = new UType();
	CustOrder.setUe(OrderArrayList);
	
	  //OrderArrayListContainer是一个0~n的节点类型，shiyonga说实际业务就是一个节点，因此，放到循环外面处理。
	  UType OrderArrayListContainer = new UType();
	  OrderArrayList.setUe(OrderArrayListContainer);
	  
	    UType OrderArrayMsg = new UType();
	    OrderArrayListContainer.setUe(OrderArrayMsg);
	      String OrderArrayId=mapbean.getString("REQUEST_INFO.OPR_INFO.ORDERARRAYID");
	      OrderArrayMsg.setUe(STRING,OrderArrayId);//OrderArrayId
	  
	  
	    UType ServOrderList = new UType();
	    OrderArrayListContainer.setUe(ServOrderList);
	
	for(int i=0;i<busiInfoNodeSize;i++){
		busiInfoMap=new MapBean( (Map)busiInfoNodeList.get(i) );
		domainType= busiInfoMap.getString("DOMAIN_TYPE");
		phoneType = busiInfoMap.getString("PHONE_TYPE"); //add by lipenga
		
		//if("0".equals(phoneType)){
		  /**
		   sunliang和shiyonga:
		   满足以下条件之一就压ServOrderListContainer数据：
		   1.有BUSI_MODEL节点，并且必须有子节点数据
		   2.sunliang:对于费用节点，在BUSIINFO节点下没有BUSI_MODEL，而直接是ORDER_LINE_FEELIST节点，并且必须有子节点数据
		  */
		  
		  boolean busiModeFlag=false;
		  List tmpList=new ArrayList();
		  Object objtest=busiInfoMap.getValue("BUSI_MODEL");
		  if(null!=objtest && objtest instanceof Map ){
		    this.xmlElement((Map) objtest, tmpList);
		    if(tmpList.size()>0){
		    	busiModeFlag=true;
		    	logger.info("----------------BUSI_MODEL node has child node-----------,DOMAIN_TYPE="+domainType);
		    }
		  }
		  
		  //boolean busiModeFlag=this.hasChildNode(busiInfoMap, "BUSI_MODEL");
		  boolean feeListFlag=this.hasChildNode(busiInfoMap, "ORDER_LINE_FEELIST");
		  if(true == busiModeFlag || true == feeListFlag){
		      //ServOrderListContainer是一个0~n的节点类型
		      UType ServOrderListContainer = new UType();
		      ServOrderList.setUe(ServOrderListContainer);
		      
		        UType ServOrderMsg = new UType();
		        ServOrderListContainer.setUe(ServOrderMsg);
		          ServOrderMsg.setUe(STRING, "");//ServOrderId
		          ServOrderMsg.setUe(STRING, "0");//ServOrderNo
		          ServOrderMsg.setUe(STRING, "0");//ServOrderChangeId
		          ServOrderMsg.setUe(LONG, busiInfoMap.getString("ID_NO"));//IdNo
		          logger.info("ID_NO="+busiInfoMap.getString("ID_NO"));
		          ServOrderMsg.setUe(STRING, busiInfoMap.getString("PHONE_NO"));//ServiceNo
		          logger.info("PHONE_NO="+busiInfoMap.getString("PHONE_NO"));
		          ServOrderMsg.setUe(INT, "0");//DispathRule
		          ServOrderMsg.setUe(INT, "0");//DecomposeRule
		          ServOrderMsg.setUe(LONG, "0");//AddressId
		          ServOrderMsg.setUe(INT, "110");//OrderStatus
		          ServOrderMsg.setUe(STRING, curTime);//StateDate
		          ServOrderMsg.setUe(INT, "3");//StateReasonId
		          ServOrderMsg.setUe(STRING, busiInfoMap.getString("SERVICE_OFFER_ID"));//ServBusiId
		          ServOrderMsg.setUe(STRING, "N");//FinishFlag
		          ServOrderMsg.setUe(STRING, "0");//FinishTime 以前是N
		          ServOrderMsg.setUe(STRING, curTime);//FinishLimitTime
		          ServOrderMsg.setUe(STRING, curTime);//WarningTime
		          ServOrderMsg.setUe(INT, "1");//DealLevel
		          ServOrderMsg.setUe(STRING, "0");//PayStatus
		          ServOrderMsg.setUe(STRING, "0");//BackFlag
		          ServOrderMsg.setUe(INT, "0");//ExceptionTimes
		          ServOrderMsg.setUe(INT, "1");//ServOrderSeq
		          ServOrderMsg.setUe(STRING, "Y");//IsPreCreateStatus
		          ServOrderMsg.setUe(STRING, "0");//ContactPerson
		          ServOrderMsg.setUe(STRING, busiInfoMap.getString("PHONE_NO"));//ContactPhone
		      
		      
		        UType ServOrderDataList = new UType();
		        ServOrderListContainer.setUe(ServOrderDataList);
		        
		          //对应utype的扩展属性的数据，目前放在BUSI_MODEL.DATA_LIST中
		          Object obj=busiInfoMap.getValue("BUSI_MODEL.DATA_LIST");
		          if(null!=obj && obj instanceof Map ){
			          //ServOrderData是一个0~n的节点类型
			          
			          String ClassValue="";	          
			          String ClassCode="";		          
			          ClassValue=busiInfoMap.getString("BUSI_MODEL.DATA_LIST.RESOURCE_MONTH_PAY");
			          if(null!=ClassValue && !NO_KEY_VALUE.equals(ClassValue) && !ClassValue.trim().equals("")){
			        	  ClassCode="30000";
			        	  UType ServOrderData = new UType();
			        	  ServOrderDataList.setUe(ServOrderData);
				          ServOrderData.setUe(LONG, ClassCode);//ClassCode
				          ServOrderData.setUe(INT, "0");//ArraySeq,目前填写0
				          ServOrderData.setUe(STRING, ClassValue);//ClassValue			          
			          }		          
			          
			          ClassValue=busiInfoMap.getString("BUSI_MODEL.DATA_LIST.CHK_LENGTH");
			          if(null!=ClassValue && !NO_KEY_VALUE.equals(ClassValue) && !ClassValue.trim().equals("")){
			        	  ClassCode="30001";
			        	  UType ServOrderData = new UType();
			        	  ServOrderDataList.setUe(ServOrderData);
				          ServOrderData.setUe(LONG, ClassCode);//ClassCode
				          ServOrderData.setUe(INT, "0");//ArraySeq,目前填写0
				          ServOrderData.setUe(STRING, ClassValue);//ClassValue			          
			          }		
			          ClassValue=busiInfoMap.getString("BUSI_MODEL.DATA_LIST.RESOURCE_UNDEADLINE");
			          if(null!=ClassValue && !NO_KEY_VALUE.equals(ClassValue) && !ClassValue.trim().equals("")){
			        	  ClassCode="30002";
			        	  UType ServOrderData = new UType();
			        	  ServOrderDataList.setUe(ServOrderData);
				          ServOrderData.setUe(LONG, ClassCode);//ClassCode
				          ServOrderData.setUe(INT, "0");//ArraySeq,目前填写0
				          ServOrderData.setUe(STRING, ClassValue);//ClassValue	
				          System.out.println("=========================================-----------------------***************ClassValue"+ClassValue);		   
				          
			          }
			          ClassValue=busiInfoMap.getString("BUSI_MODEL.DATA_LIST.CARD_CODE");
			          if(null!=ClassValue && !NO_KEY_VALUE.equals(ClassValue) && !ClassValue.trim().equals("")){
			        	  ClassCode="30032";
			        	  UType ServOrderData = new UType();
			        	  ServOrderDataList.setUe(ServOrderData);
				          ServOrderData.setUe(LONG, ClassCode);//ClassCode
				          ServOrderData.setUe(INT, "0");//ArraySeq,目前填写0
				          ServOrderData.setUe(STRING, ClassValue);//ClassValue	
				          System.out.println("=========================================-----------------------***************ClassValue"+ClassValue);		          
			          }
			          ClassValue=busiInfoMap.getString("BUSI_MODEL.DATA_LIST.SCORE_VALUE");
			          if(null!=ClassValue && !NO_KEY_VALUE.equals(ClassValue) && !ClassValue.trim().equals("")){
			        	  ClassCode="30038";
			        	  UType ServOrderData = new UType();
			        	  ServOrderDataList.setUe(ServOrderData);
				          ServOrderData.setUe(LONG, ClassCode);//ClassCode
				          ServOrderData.setUe(INT, "0");//ArraySeq,目前填写0
				          ServOrderData.setUe(STRING, ClassValue);//ClassValue	
				          System.out.println("=========================================-----------------------***************ClassValue"+ClassValue);		          
			          }			          
			          ClassValue=busiInfoMap.getString("BUSI_MODEL.DATA_LIST.GIFT_CODE");
			          if(null!=ClassValue && !NO_KEY_VALUE.equals(ClassValue) && !ClassValue.trim().equals("")){
			        	  ClassCode="30039";
			        	  UType ServOrderData = new UType();
			        	  ServOrderDataList.setUe(ServOrderData);
				          ServOrderData.setUe(LONG, ClassCode);//ClassCode
				          ServOrderData.setUe(INT, "0");//ArraySeq,目前填写0
				          ServOrderData.setUe(STRING, ClassValue);//ClassValue	
				          System.out.println("=========================================-----------------------***************ClassValue"+ClassValue);		          
			          }			          
			          ClassValue=busiInfoMap.getString("BUSI_MODEL.DATA_LIST.PLANT_FLAG");
			          if(null!=ClassValue && !NO_KEY_VALUE.equals(ClassValue) && !ClassValue.trim().equals("")){
			        	  ClassCode="30040";
			        	  UType ServOrderData = new UType();
			        	  ServOrderDataList.setUe(ServOrderData);
				          ServOrderData.setUe(LONG, ClassCode);//ClassCode
				          ServOrderData.setUe(INT, "0");//ArraySeq,目前填写0
				          ServOrderData.setUe(STRING, ClassValue);//ClassValue	
				          System.out.println("=========================================-----------------------***************ClassValue"+ClassValue);		          
			          }
					  if(domainType.toUpperCase().equals(DOMAIN_TYPE_FQ)){//通用
			        	  Object ob = busiInfoMap.getList("BUSI_MODEL.GSP_STR.GSP_INFO");
				          if(null!=ob && !NO_KEY_VALUE.equals(ob) && ob instanceof List){
				        	  List gspList =  (List) ob;
				        	  int gspSize = gspList.size();
				        	  ClassCode="30003";
				        	  MapBean gspMap=null;
				        	  for(int gsp_i=0;gsp_i<gspSize;gsp_i++){
				        		  if("N/A".equals(gspList.get(gsp_i)))continue;
				        		  UType ServOrderData = new UType();
					        	  ServOrderDataList.setUe(ServOrderData);
					        	  ServOrderData.setUe(LONG, ClassCode);//ClassCode
						          ServOrderData.setUe(INT, gsp_i+"");//ArraySeq,目前填写0
				        		  ClassValue = (String) gspList.get(gsp_i);
						          ServOrderData.setUe(STRING, ClassValue);//ClassValue	
				        	 }
				          }
			          }
			           
		          }
		          logger.info("#########################################资费业务省内魔百合增加"+DOMAIN_TYPE_P);
		          logger.info("#########################################资费业务省内魔百合增加"+domainType.toUpperCase());
		          logger.info("#########################################资费业务省内魔百合增加"+domainType.toUpperCase().equals(DOMAIN_TYPE_P));
		        if(domainType.toUpperCase().equals(DOMAIN_TYPE_P)){//省内魔百合业务增加
		        	Object prodprcNode=busiInfoMap.getValue("BUSI_MODEL.PRODPRC_LIST.PRODPRC");
					if(null!=prodprcNode && !prodprcNode.equals(NO_KEY_VALUE)){
						  List prodprcNodeList=busiInfoMap.getList("BUSI_MODEL.PRODPRC_LIST.PRODPRC");
						  
						  int prodprcNodeSize=prodprcNodeList.size();
						  MapBean prodprcMap=null;
						  for(int prodprcNode_i=0;prodprcNode_i<prodprcNodeSize;prodprcNode_i++){
							  prodprcMap=new MapBean( (Map)prodprcNodeList.get(prodprcNode_i) );
						      if(prodprcNode_i==0){
							  String MNET_CODE=prodprcMap.getString("MNET_CODE").trim();
							  logger.info("#########################################资费业务省内魔百合增加MNET_CODE"+MNET_CODE);
							  	if( !"".equals(MNET_CODE) &&!"N/A".equals(MNET_CODE)&&!"null".equals(MNET_CODE)&&MNET_CODE!=null){
								  UType ServOrderData = new UType();
			        		  		 logger.info("------*****省内魔百合----------="+prodprcNode_i+":"+MNET_CODE);
			        		  		 ServOrderData.setUe(LONG, "50001");//
					          		 ServOrderData.setUe(INT, "0");//ArraySeq
					          		 ServOrderData.setUe(STRING, MNET_CODE);//ClassValue
					          		 ServOrderDataList.setUe(ServOrderData);	  
							  	}
						      }
							} //end for BUSI_MODEL.PRODPRC_LIST.PRODPRC.				
					} //end if.
		        }  
		          
		        logger.info("#########################################SP业务0"+DOMAIN_TYPE_SP);
			          logger.info("#########################################SP业务0"+domainType.toUpperCase());
			          logger.info("#########################################SP业务0"+domainType.toUpperCase().equals(DOMAIN_TYPE_SP));
			         if(domainType.toUpperCase().equals(DOMAIN_TYPE_SP)){//SP业务
			        	  logger.info("#########################################SP业务1");
				        	 Object ob = busiInfoMap.getList("BUSI_MODEL.SP_INFO_LIST.SP_INFO");
				        	 if(null!=ob && !NO_KEY_VALUE.equals(ob) && ob instanceof List){
				        		 logger.info("#########################################SP业务2");
				        	 	List spList =  (List) ob;
					        	  int spSize = spList.size();
					        	  String SPCode="";
					        	  String SPValue="";
					        	  MapBean spMap=null;
					        	  for(int sp_i=0;sp_i<spSize;sp_i++){
					        	  logger.info("#########################################SP业务3");
					        		  if("N/A".equals(spList.get(sp_i)))continue;
					        		  for(int sp_j=0;sp_j<7;sp_j++){
					        		  logger.info("#########################################SP业务4");
					        		  	spMap = new MapBean((Map)spList.get(sp_i));
					        		  	 UType ServOrderData = new UType();
					        		  	 //ServOrderDataList.setUe(ServOrderData);
					        		  	 String spcode = "";
					        		  	 if(sp_j==0){
					        		  		 spcode = spMap.getString("SPID");
					        		  		 System.out.println(sp_i+":"+spcode);
					        		  		 logger.info("--------*****SPSPSPSPS--------="+sp_i+":"+spcode);
					        		  		 ServOrderData.setUe(LONG, "30021");//
							          		 ServOrderData.setUe(INT, sp_i+"");//ArraySeq
							          		 ServOrderData.setUe(STRING, spcode);//ClassValue
							          		 ServOrderDataList.setUe(ServOrderData);
					        		  	 }
					        		  	 if(sp_j==1){
					        		  		 spcode = spMap.getString("BIZCODE");
					        		  		 logger.info("--------*****SPSPSPSPS--------="+sp_i+":"+spcode);
					        		  		 ServOrderData.setUe(LONG, "30022");//
							          		 ServOrderData.setUe(INT, sp_i+"");//ArraySeq
							          		 ServOrderData.setUe(STRING, spcode);//ClassValue
							          		 ServOrderDataList.setUe(ServOrderData);
					        		  	 }
					        		  	 if(sp_j==2){
					        		  		 spcode = spMap.getString("BEGINTIME");
					        		  		 logger.info("-------*****SPSPSPSPS---------="+sp_i+":"+spcode);
					        		  		 ServOrderData.setUe(LONG, "30023");//
							          		 ServOrderData.setUe(INT, sp_i+"");//ArraySeq
							          		 ServOrderData.setUe(STRING, spcode);//ClassValue
							          		 ServOrderDataList.setUe(ServOrderData);
					        		  	 }
					        		  	 if(sp_j==3){
					        		  		 spcode = spMap.getString("ENDTIME");
					        		  		 logger.info("------*****SPSPSPSPS----------="+sp_i+":"+spcode);
					        		  		 ServOrderData.setUe(LONG, "30024");//
							          		 ServOrderData.setUe(INT, sp_i+"");//ArraySeq
							          		 ServOrderData.setUe(STRING, spcode);//ClassValue
							          		 ServOrderDataList.setUe(ServOrderData);
					        		  	 }
					        		  	System.out.println("--------*****SPSPSPSPS------sp_i--="+sp_i+":"+ spMap.getString("BOX_ID"));
					        		  	System.out.println("--------*****SPSPSPSPS------sp_j--="+sp_j+":"+ spMap.getString("BOX_ID"));
					        		  	if(sp_j==4){
					        		  		 spcode = spMap.getString("BOX_ID");
					        		  		if(null!=spcode && !"".equals(spcode.trim())){
						        		  		 logger.info("--------*****SPSPSPSPS--------="+sp_i+":"+spcode);
						        		  		 
						        		  		 ServOrderData.setUe(LONG, "40000");//
								          		 ServOrderData.setUe(INT, sp_i+"");//ArraySeq
								          		 ServOrderData.setUe(STRING, spcode);//ClassValue
								          		 ServOrderDataList.setUe(ServOrderData);
					        		  		 }
					        		  	 }
					        		  	 if(sp_j==5){
					        		  		 spcode = spMap.getString("NET_CODE");
					        		  		if(null!=spcode && !"".equals(spcode.trim())){
						        		  		 logger.info("--------*****SPSPSPSPS--------="+sp_i+":"+spcode);
						        		  		 ServOrderData.setUe(LONG, "40001");
								          		 ServOrderData.setUe(INT, sp_i+"");
								          		 ServOrderData.setUe(STRING, spcode);
								          		 ServOrderDataList.setUe(ServOrderData);
					        		  		 }
					        		  	 }
					        		  	 //add zhangxy 20170410 for 魔百和包年到期续费需求的函
					        		  	 if(sp_j==6){
					        		  		 spcode = spMap.getString("SP_TYPE");
					        		  		if(null!=spcode && !"".equals(spcode.trim())){
						        		  		 logger.info("--------*****SPSPSPSPS--------="+sp_i+":"+spcode);
						        		  		System.out.println("--------*****SPSPSPSPS----SP_TYPE["+spcode+"]----="+sp_i+":"+spcode);

						        		  		 ServOrderData.setUe(LONG, "40002");
								          		 ServOrderData.setUe(INT, sp_i+"");
								          		 ServOrderData.setUe(STRING, spcode);
								          		 ServOrderDataList.setUe(ServOrderData);
					        		  		 }
					        		  	 }
					        		  }
					        	 }
				        	 }
				        }

		          
		        UType ServOrderSlaList = new UType();   
		        ServOrderListContainer.setUe(ServOrderSlaList);          
			    
		        UType ServOrderBookingMsg = new UType();
		        ServOrderListContainer.setUe(ServOrderBookingMsg); 
		        
		        UType ServOrderExcpInfo = new UType();
		        ServOrderListContainer.setUe(ServOrderExcpInfo);
		          ServOrderExcpInfo.setUe(STRING, "0");//SrvOrderExcpId
		          ServOrderExcpInfo.setUe(INT, "1");//ExcpType
		          ServOrderExcpInfo.setUe(STRING, "0");//ExcpReason
		          ServOrderExcpInfo.setUe(STRING, "OK");//HandleResult
		          ServOrderExcpInfo.setUe(STRING, "0");//HandleLogin
		        
		        
		        UType DeductionIntegralBusiList = new UType();
		        ServOrderListContainer.setUe(DeductionIntegralBusiList);
		        
		          if(domainType.toUpperCase().equals(DOMAIN_TYPE_S)){//积分
		        	  obj=busiInfoMap.getValue("BUSI_MODEL.DEDUCTION_INTEGRAL_BUSI_LIST.DEDUCTION_INTEGRAL_BUSI_INFO");
		        	  if(null!=obj && obj instanceof List){
		        		//DeductionIntegralBusi是一个0~n的节点类型
		        		List scoreList=(List) obj;
		        		int scoreSize=scoreList.size();
		        		MapBean scoreMap=null;
		        		for(int score_i=0;score_i<scoreSize;score_i++){
		        			scoreMap=new MapBean( (Map)scoreList.get(score_i) );
					        UType DeductionIntegralBusi = this.setScoreNode(scoreMap);
					        DeductionIntegralBusiList.setUe(DeductionIntegralBusi);	        			
		        		}
		        			
		        	  }else if(null!=obj && obj instanceof Map){
				        MapBean scoreMap=new MapBean( (Map)obj );
				        UType DeductionIntegralBusi = this.setScoreNode(scoreMap);
				        DeductionIntegralBusiList.setUe(DeductionIntegralBusi);
				        
		        	  } 
		         
		          }
		        
		        UType ServsFeeList = new UType();
		        ServOrderListContainer.setUe(ServsFeeList);
		        if(domainType.toUpperCase().equals(DOMAIN_TYPE_F)){//费用。注意:没有BUSI_MODEL节点。
		        	  obj=busiInfoMap.getValue("ORDER_LINE_FEELIST.ORDER_LINE_FEE");
		        	  if(null!=obj && obj instanceof List){
		        		//servFeeLineContainer是一个0~n的节点类型
		        		List feeList=(List) obj;
		        		int feeSize=feeList.size();
		        		MapBean feeMap=null;
		        		for(int fee_i=0;fee_i<feeSize;fee_i++){
		        			feeMap=new MapBean( (Map)feeList.get(fee_i) );
					        UType servFeeLineContainer = this.setFeeNode(feeMap);
					        ServsFeeList.setUe(servFeeLineContainer);	        			
		        		}
		        			
		        	  }else if(null!=obj && obj instanceof Map){
				        MapBean feeMap=new MapBean( (Map)obj );
				        UType servFeeLineContainer = this.setFeeNode(feeMap);
				        ServsFeeList.setUe(servFeeLineContainer);			        
		        	  }	        	
		        }
	 
		        UType ResSellInfoList = new UType();
		        ServOrderListContainer.setUe(ResSellInfoList);
		        if(domainType.toUpperCase().equals(DOMAIN_TYPE_Z)){//资源：促销品,终端
		        	  obj=busiInfoMap.getValue("BUSI_MODEL.RES_INFO_LIST.RES_INFO");
		        	  if(null!=obj && obj instanceof List){
		        		//ResInfoContainer是一个0~n的节点类型
		        		List resList=(List) obj;
		        		int resSize=resList.size();
		        		MapBean resMap=null;
		        		for(int res_i=0;res_i<resSize;res_i++){
		        			resMap=new MapBean( (Map)resList.get(res_i) );
					        UType ResInfoContainer = this.setResNode(resMap);
					        if(ResInfoContainer != null){
					        	ResSellInfoList.setUe(ResInfoContainer);
					        }
		        		}
		        			
		        	  }else if(null!=obj && obj instanceof Map){
				        MapBean resMap=new MapBean( (Map)obj );
				        UType ResInfoContainer = this.setResNode(resMap);
				        if(ResInfoContainer != null){
				        	ResSellInfoList.setUe(ResInfoContainer);
				        }
		        	  }	 	        	
		        }
	 
		        UType phoneCertList = new UType();
		        ServOrderListContainer.setUe(phoneCertList); 
		        if(domainType.toUpperCase().equals(DOMAIN_TYPE_PH)){//手机凭证发放
		        	  obj=busiInfoMap.getValue("BUSI_MODEL.PHONE_CERT");
		        	  if(null!=obj && obj instanceof List){
		        		//phoneCertContainer是一个0~n的节点类型
		        		List phoneList=(List) obj;
		        		int phoneSize=phoneList.size();
		        		MapBean phoneMap=null;
		        		for(int phone_i=0;phone_i<phoneSize;phone_i++){
		        			phoneMap=new MapBean( (Map)phoneList.get(phone_i) );
					        UType phoneCertContainer = this.setPhoneNode(phoneMap);
					        phoneCertList.setUe(phoneCertContainer);	        			
		        		}
		        			
		        	  }else if(null!=obj && obj instanceof Map){
				        MapBean phoneMap=new MapBean( (Map)obj );
				        UType phoneCertContainer = this.setPhoneNode(phoneMap);
				        phoneCertList.setUe(phoneCertContainer);			        
		        	  }	 	        	
		        }
		        
		  } //end BUSI_MODEL 
 
 		//} //end if
	}//end for.         
	
 
	//---------------Customer------------------
	UType Customer = new UType();
	MsgBody.setUe(Customer);
	
	  UType CustDoc = new UType();
	  Customer.setUe(CustDoc);
	    UType CustDocBaseInfo = new UType();
	    CustDoc.setUe(CustDocBaseInfo);
	      CustDocBaseInfo.setUe(LONG, mapbean.getString("REQUEST_INFO.OPR_INFO.CUST_ID"));
	     
	  UType UserInfoList = new UType();
	  Customer.setUe(UserInfoList);
	  
	  String phone_no="",havePhoneNoStr="";
	  int index=-1;
 
	  
	  for(int i=0;i<busiInfoNodeSize;i++){
	    busiInfoMap=new MapBean( (Map)busiInfoNodeList.get(i) );
		domainType= busiInfoMap.getString("DOMAIN_TYPE");
		
		  phone_no=busiInfoMap.getString("PHONE_NO");
		  index=havePhoneNoStr.indexOf(","+phone_no+",");
		  if(index==-1){//用户信息是不能重复的 
			UType UserInfo = new UType();
			UserInfoList.setUe(UserInfo);
			  
			  UType UserBaseInfo = new UType();
			  UserInfo.setUe(UserBaseInfo);
			  UserBaseInfo.setUe(STRING, phone_no );//ServiceNo
			  UserBaseInfo.setUe(LONG, busiInfoMap.getString("ID_NO") );//UserId			  
			  UserBaseInfo.setUe(STRING, busiInfoMap.getString("BRAND_ID") );//Brand
			  UserBaseInfo.setUe(STRING, "" );//UserNo
			  UserBaseInfo.setUe(STRING, busiInfoMap.getString("GROUP_ID") );//GroupId
			  UserBaseInfo.setUe(LONG, busiInfoMap.getString("CUST_ID") );//UseCustId
				
		  
		  havePhoneNoStr=","+phone_no+",";
		  logger.info("----------------havePhoneNoStr="+havePhoneNoStr);
		  
		
		  //如果是资费，还需要处理其他节点，否则，其他节点都是空值。
		  if(domainType.toUpperCase().equals(DOMAIN_TYPE_P)){
		    UType DiscountInfoList = new UType();
		    UserInfo.setUe(DiscountInfoList);
		    
			//判断是否有PRODPRC节点
			Object prodprcNode=busiInfoMap.getValue("BUSI_MODEL.PRODPRC_LIST.PRODPRC");
			if(null!=prodprcNode && !prodprcNode.equals(NO_KEY_VALUE)){
				  List prodprcNodeList=busiInfoMap.getList("BUSI_MODEL.PRODPRC_LIST.PRODPRC");
				  
				  int prodprcNodeSize=prodprcNodeList.size();
				  MapBean prodprcMap=null;
				  for(int prodprcNode_i=0;prodprcNode_i<prodprcNodeSize;prodprcNode_i++){
					  prodprcMap=new MapBean( (Map)prodprcNodeList.get(prodprcNode_i) );
				      //DiscountInfoListContainer是一个0~n的节点类型
				      UType DiscountInfoListContainer = new UType();
				      DiscountInfoList.setUe(DiscountInfoListContainer);
				      
				        UType DiscountInfo = new UType();
				        DiscountInfoListContainer.setUe(DiscountInfo);
				          DiscountInfo.setUe(STRING, prodprcMap.getString("OPERATE_TYPE"));//OperatorFlag
				          DiscountInfo.setUe(STRING, prodprcMap.getString("DISCOUNTPLANINSTID"));//DiscountPlanInstId
				          DiscountInfo.setUe(STRING, prodprcMap.getString("ORDER"));//Order
				          DiscountInfo.setUe(STRING, prodprcMap.getString("CUSTAGREEMENTID"));//CustAgreementId
				          DiscountInfo.setUe(STRING, prodprcMap.getString("STATUS"));//Status
				          DiscountInfo.setUe(STRING, prodprcMap.getString("DEVELOP_NO"));//DevelopLoginNo
				          DiscountInfo.setUe(STRING, busiInfoMap.getString("GROUP_ID") );//ChannelId
				          DiscountInfo.setUe(STRING, prodprcMap.getString("PEI_FEE_CODE"));//DiscountPlanId
				          DiscountInfo.setUe(STRING, prodprcMap.getString("EFF_DATE"));//EffectTime
				          DiscountInfo.setUe(STRING, prodprcMap.getString("EXP_DATE"));//ExpireTime
				          DiscountInfo.setUe(STRING, prodprcMap.getString("DISCOUNTPLANINSTID"));//ParentInstId
				          DiscountInfo.setUe(STRING, prodprcMap.getString("CURLEVEL"));//CurLevel
				      
				      
				        UType DiscountAttrList = new UType();
				        DiscountInfoListContainer.setUe(DiscountAttrList);
				          //DiscountAttr是一个0~n的节点类型，但是目前营销案此节点也就一个，因此，不需要循环处理了。
				          
				          //小区代码为空，就不拼DiscountAttr节点了
				          String distriFeeCode=prodprcMap.getString("DISTRI_FEE_CODE").trim();
				          if( !distriFeeCode.equals("") ){
				        	  UType DiscountAttr = new UType();
				        	  DiscountAttrList.setUe(DiscountAttr);
				        	  //shiyonga要求的转换。
				        	  String operateType=prodprcMap.getString("OPERATE_TYPE");
				        	  if(operateType.equals("3")){
				        		  operateType="2";
				        	  }else{
				        		  operateType="1";
				        	  }
				        	  
				        	  DiscountAttr.setUe(STRING, operateType);//OperatorFlag
				        	  DiscountAttr.setUe(STRING, "");//AttrType
				        	  DiscountAttr.setUe(STRING, "60001");//AttrCode
				        	  DiscountAttr.setUe(STRING, prodprcMap.getString("DISTRI_FEE_CODE"));//AttrValue 
				        	  DiscountAttr.setUe(STRING, "");//AttrRemark 
				        	  DiscountAttr.setUe(STRING, prodprcMap.getString("STATUS"));//StateCd  
				        	  DiscountAttr.setUe(STRING, prodprcMap.getString("EFF_DATE"));//effDate  
				        	  DiscountAttr.setUe(STRING, prodprcMap.getString("EXP_DATE"));//expDate  
				        	
				          }

				        //GroupInstInfo 先拼一个空节点吧，后续待处理【TBD】
					    UType GroupInstInfo = new UType();
					    DiscountInfoListContainer.setUe(GroupInstInfo);
				      
				        UType DiscountParamList = new UType();
				        DiscountInfoListContainer.setUe(DiscountParamList);//DiscountParamList目前是空节点
				      
				     
				    
				  } //end for BUSI_MODEL.PRODPRC_LIST.PRODPRC.				
			} //end if.
			
			  UType UserRelaInfoList = new UType();
			UserInfo.setUe(UserRelaInfoList);//UserRelaInfoList目前是空节点  
			  UType ProductList = new UType();
		    UserInfo.setUe(ProductList);//ProductList目前是空节点  
			  UType UserResList = new UType();
			UserInfo.setUe(UserResList);//UserResList目前是空节点  
			  UType BusiFeeFactorList = new UType();
		    UserInfo.setUe(BusiFeeFactorList);//BusiFeeFactorList目前是空节点  
		        
		  }else{//非资费
		      UType DiscountInfoList = new UType();
			UserInfo.setUe(DiscountInfoList);//DiscountInfoList目前是空节点
			  UType UserRelaInfoList = new UType();
			UserInfo.setUe(UserRelaInfoList);//UserRelaInfoList目前是空节点  
			  UType ProductList = new UType();
		    UserInfo.setUe(ProductList);//ProductList目前是空节点  
			  UType UserResList = new UType();
			UserInfo.setUe(UserResList);//UserResList目前是空节点  
			  UType BusiFeeFactorList = new UType();
		    UserInfo.setUe(BusiFeeFactorList);//BusiFeeFactorList目前是空节点  			  
		  }

		}//end if.判断不重复.
		  
      }//end for.
	 
	return MsgBody;	
  }
	
  
  /**
   * 设置手机凭证节点值
   * @param resMap
   * @return
   */
  private UType setPhoneNode(MapBean resMap){
	  UType phoneCertContainer = new UType();
	  
	  phoneCertContainer.setUe(STRING, resMap.getString("FROMNODE"));//FromNode
	  phoneCertContainer.setUe(STRING, resMap.getString("PASSWD"));//passWd
	  phoneCertContainer.setUe(STRING, resMap.getString("REQTRANSNO"));//reqTransNo
	  phoneCertContainer.setUe(STRING, resMap.getString("REQTIME"));//reqTime
	  phoneCertContainer.setUe(STRING, resMap.getString("MACODE"));//maCode
	  phoneCertContainer.setUe(STRING, resMap.getString("MANAME"));//maName
	  phoneCertContainer.setUe(STRING, resMap.getString("PHONENO"));//phoneNo
	  phoneCertContainer.setUe(STRING, resMap.getString("USERID"));//userId
	  phoneCertContainer.setUe(STRING, resMap.getString("BAGSFLAG"));//bagsFlag
	  phoneCertContainer.setUe(STRING, resMap.getString("BAGSCODE"));//bagsCode
	  phoneCertContainer.setUe(STRING, resMap.getString("BAGSNAME"));//bagsName
	  phoneCertContainer.setUe(STRING, resMap.getString("IFEXCHTIMES"));//ifExchTimes
	  phoneCertContainer.setUe(STRING, resMap.getString("VALIDITY"));//validity
	  phoneCertContainer.setUe(STRING, resMap.getString("GOODSCOUNT"));//goodsCount
	  phoneCertContainer.setUe(STRING, resMap.getString("GOODSINFO"));//goodsInfo
	  phoneCertContainer.setUe(STRING, resMap.getString("BUSCOUNT"));//busCount
	  phoneCertContainer.setUe(STRING, resMap.getString("BUSINFO"));//busiInfo
	  phoneCertContainer.setUe(STRING, resMap.getString("OPERID"));//operId
	  phoneCertContainer.setUe(STRING, resMap.getString("ORGID"));//orgId
	  phoneCertContainer.setUe(STRING, resMap.getString("IFTOKEN"));//ifToken
 
	  return phoneCertContainer;
  }
  
  /**
   * 设置资源节点值
   * @param resMap
   * @return
   */
  private UType setResNode(MapBean resMap){
      UType ResInfoContainer = new UType();
	  String isAward = resMap.getString("IS_AWARD");
	  if("N".equals(isAward)){
		  return null;
	  }
      ResInfoContainer.setUe(STRING, resMap.getString("IMEI_CODE"));//ImeiCode
      ResInfoContainer.setUe(DOUBLE, resMap.getString("SALE_PRICE"));//SalePrice
      ResInfoContainer.setUe(STRING, resMap.getString("SALE_NOTE"));//SaleNote
      ResInfoContainer.setUe(STRING, resMap.getString("SALE_CODE"));//SaleCode
      ResInfoContainer.setUe(STRING, resMap.getString("GIFT_SOURCE"));//GiftSource
      ResInfoContainer.setUe(STRING, resMap.getString("GIFT_NO"));//GiftNo
      ResInfoContainer.setUe(STRING, resMap.getString("GIFT_MODEL"));//GiftModel
      ResInfoContainer.setUe(STRING, resMap.getString("RES_BUSI_TYPE"));//ResBusiType
      String is_phone = "N/A".equals(resMap.getString("IS_PHONE"))?"":resMap.getString("IS_PHONE");
      String means_name = "N/A".equals(resMap.getString("MEANS_NAME"))?"":resMap.getString("MEANS_NAME");
      String gift_name = "N/A".equals(resMap.getString("GIFT_NAME"))?"":resMap.getString("GIFT_NAME");
      String act_name = "N/A".equals(resMap.getString("ACTION_NAME"))?"":resMap.getString("ACTION_NAME");
      String update_no = "N/A".equals(resMap.getString("UPDATE_NO"))?"":resMap.getString("UPDATE_NO");
      String is_apprec = "N/A".equals(resMap.getString("IS_APPREC"))?"":resMap.getString("IS_APPREC");
      String chn_code = "N/A".equals(resMap.getString("CHN_CODE"))?"":resMap.getString("CHN_CODE");
      String gife_num = "N/A".equals(resMap.getString("GIFE_NUM"))?"1":resMap.getString("GIFE_NUM");
      System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%is_phone:"+is_phone);
      System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%is_phone-boolean:"+resMap.getString("IS_PHONE"));
      System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%means_name:"+means_name);
      System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gift_name:"+gift_name);
      System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%act_name:"+act_name);
      System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%update_no:"+update_no);
      System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%is_apprec:"+is_apprec);
      System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%chn_code:"+chn_code);
      System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gife_num:"+gife_num);
      ResInfoContainer.setUe(STRING, is_phone);//isPhone
      ResInfoContainer.setUe(STRING, means_name);//FactorOne
      ResInfoContainer.setUe(STRING, gift_name);//FactorTwo
      ResInfoContainer.setUe(STRING, act_name);//FactorThree
      ResInfoContainer.setUe(STRING, update_no);//FactorFour
      ResInfoContainer.setUe(STRING, is_apprec);//FactorFive
      ResInfoContainer.setUe(STRING, chn_code);//渠道标识
      ResInfoContainer.setUe(STRING, gife_num);//礼品个数
      ResInfoContainer.setUe(STRING, "");//8
      ResInfoContainer.setUe(STRING, "");//9
      ResInfoContainer.setUe(STRING, "");//10
      ResInfoContainer.setUe(STRING, "");//11
      ResInfoContainer.setUe(STRING, "");//12
      ResInfoContainer.setUe(STRING, "");//13
      ResInfoContainer.setUe(STRING, "");//14
      ResInfoContainer.setUe(STRING, "");//15
	  return ResInfoContainer;
  }
  /**
   * 设置费用节点值
   * @param feeMap
   * @return
   */
  private UType setFeeNode(MapBean feeMap){
	  UType servFeeLineContainer = new UType();
	  
	  servFeeLineContainer.setUe(STRING, feeMap.getString("RECEIVE_FEE_TYPE"));//ReceiveFeeType
	  servFeeLineContainer.setUe(STRING, feeMap.getString("RECEIVE_ACC_TYPE"));//ReceiveAccType
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FEE_TYPE"));//FeeType
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FEE_CODE"));//FeeCode
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_ONE"));//FactorOne
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TWO"));//FactorTwo
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_THREE"));//FactorThree
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_FOUR"));//FactorFour
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_FIVE"));//FactorFour
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_SIX"));//FactorSix
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_SEVEN"));//FactorSeven
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_EIGHT"));//FactorEight
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_NINE"));//FactorNine 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TEN"));//FactorTen 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_ELEVEN"));//FactorEleven 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TWELVE"));//FactorTwelve 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_THIRTEEN"));//FactorThirteen 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_FOURTEEN"));//FactorForteen 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_FIFTEEN"));//FactorFifteen 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_SIXTEEN"));//FactorSixteen 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_SEVENTEEN"));//FactorSeventeen 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_EIGHTEEN"));//FactorEighteen 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_NINETEEN"));//FactorEineteen 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TWENTY"));//FactorTwenty 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TWENTYONE"));//FactorTwentyOne 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TWENTYTWO"));//FactorTwentyTwo 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TWENTYTHREE"));//FactorTwentyThree 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TWENTYFOUR"));//FactorTwentyFour 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TWENTYFIVE"));//FactorTwentyFive 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TWENTYFSIX"));//FactorTwentySix 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TWENTYFSEVEN"));//FactorTwentySeven 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TWENTYFEIGHT"));//FactorTwentyEight 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_TWENTYFNINE"));//FactorTwentyNine 
	  servFeeLineContainer.setUe(STRING, feeMap.getString("FACTOR_THRITY"));//FactorThirty 
	  servFeeLineContainer.setUe(LONG, feeMap.getString("SHOULD_PAY"));//ShouldPay 
	  servFeeLineContainer.setUe(LONG, feeMap.getString("BUSI_SHOULD"));//BusiShould 
	  return servFeeLineContainer;	  
  }
  
  /**
   * 设置积分节点值
   * @param scoreMap
   * @return
   */
  private UType setScoreNode(MapBean scoreMap){
      UType DeductionIntegralBusi = new UType();

      DeductionIntegralBusi.setUe(STRING, scoreMap.getString("SCORE_TYPE"));//scoreType
      DeductionIntegralBusi.setUe(STRING, scoreMap.getString("SCORE_VALUE"));//scoreValue
      DeductionIntegralBusi.setUe(STRING, scoreMap.getString("RES_NUM"));//resNum
      DeductionIntegralBusi.setUe(STRING, scoreMap.getString("CON_MONEY"));//conMoney
      DeductionIntegralBusi.setUe(STRING, scoreMap.getString("FACTOR_ONE"));//factorOne
      DeductionIntegralBusi.setUe(STRING, scoreMap.getString("FACTOR_TWO"));//factorTwo
      DeductionIntegralBusi.setUe(STRING, scoreMap.getString("FACTOR_THREE"));//factorThree
      DeductionIntegralBusi.setUe(STRING, scoreMap.getString("FACTOR_FOUR"));//factorFour
      DeductionIntegralBusi.setUe(STRING, scoreMap.getString("FACTOR_FIVE"));//factorFive
      return DeductionIntegralBusi;
  }
  
  /**
   * 判断某个节点下是否还有子节点
   * @param mapBean
   * @param nodeStr
   * @return
   */
  private boolean hasChildNode(MapBean mapBean, String nodeStr){
	  boolean flag=false;
	  
	  Object obj=mapBean.getValue(nodeStr);
	  if(null!=obj && obj instanceof Map ){
		  Map m=(Map) obj;
		  if(!m.isEmpty()){
			  flag = true;
		  }else{
			  flag = false;
		  }
	  }
	  
	  return flag;
  }

  
  /**
   * 主要使用在递归判断是否有元素节点
   * @param cmap
   * @param result
   */
  private void xmlElement(Map cmap, List result)  
  {
  
  	Iterator it = cmap.entrySet().iterator();
  	while (it.hasNext()) 
  	{
  	   Map.Entry entry = (Map.Entry) it.next();
  	   String key = (String)entry.getKey();
  	   Object value = entry.getValue();
   	   
	   if(key.indexOf("_attribute")!=-1){//表明是元素节点
  	     result.add("1");
  	     break;
  	   }
		 
  	   if(value instanceof Map)
  	   {
  		 xmlElement((Map)value,result);  
  	   }
  	   else if(value instanceof List)
  	   {
 
              List list = (List)value;              
              int size = list.size();
              
              for(int i=0; i<size; i++)
              {
                if(list.get(i) instanceof Map)
              	{
                  xmlElement((Map)list.get(i),result);                  		    
              	}
              	
              } 
  	   }  	   

  	}
		
	}
  
	/**
	 * 将xml转换成mapbean
	 * @throws BusiAppException 
	 * @throws IOException 
	 */
  private MapBean xml2mapbean(String inXml) throws BusiAppException{	
    	IXMLReader xmlReader=null;
    	MapBean  mapbean = new MapBean();

    	Map map = new HashMap(13); 
		InputStream is = new ByteArrayInputStream( inXml.getBytes() );
		xmlReader = StAXReaderFactory.getInstance().createReader(is);
	 	Unmarshalling context = new Unmarshalling(xmlReader );		  		  
		context.parseXML(map);     	
		mapbean = new MapBean(map);	
 	    	
		return mapbean;
  }
	
}
%>

<%
	 String XML_STR = request.getParameter("XML_STR")==null?"":request.getParameter("XML_STR");
	 System.out.println("XML_STR:"+XML_STR);
	 String RETURN_CODE ="";
	 String RETURN_MSG ="";
	 
	 String busiId = request.getParameter("busiId")==null?"":request.getParameter("busiId");
	 String chnType = request.getParameter("chnType")==null?"":request.getParameter("chnType");
	 String opCode = request.getParameter("opCode")==null?"":request.getParameter("opCode");
	 String loginNo = request.getParameter("loginNo")==null?"":request.getParameter("loginNo");
	 String loginPwd = request.getParameter("loginPwd")==null?"":request.getParameter("loginPwd");
	 String netCode = request.getParameter("netCode")==null?"":request.getParameter("netCode");
	 String userPwd = request.getParameter("userPwd")==null?"":request.getParameter("userPwd");
	 String phoneChgNo = request.getParameter("phoneChgNo")==null?"":request.getParameter("phoneChgNo");
	 String scoreType = request.getParameter("scoreType")==null?"":request.getParameter("scoreType");
	 String scoreValue = request.getParameter("scoreValue")==null?"":request.getParameter("scoreValue");
	 String scoreMoney = request.getParameter("scoreMoney")==null?"":request.getParameter("scoreMoney");
	 String netSmCode = request.getParameter("netSmCode")==null?"":request.getParameter("netSmCode");
	 String netFlag = request.getParameter("netFlag")==null?"":request.getParameter("netFlag");
	 String dealType = "0";
	 if((!"".equals(scoreValue))&&(!"0".equals(scoreValue))){
		 dealType = "1";
	 }
	 System.out.println("_____________ busiId:"+busiId);
	 System.out.println("_____________ chnType:"+chnType);
	 System.out.println("_____________ opCode:"+opCode);
	 System.out.println("_____________ loginNo:"+loginNo);
	 System.out.println("_____________ loginPwd:"+loginPwd);
	 System.out.println("_____________ netCode:"+netCode);
	 System.out.println("_____________ userPwd:"+userPwd);
	 System.out.println("_____________ phoneChgNo:"+phoneChgNo);
	 System.out.println("_____________ scoreType:"+scoreType);
	 System.out.println("_____________ scoreValue:"+scoreValue);
	 System.out.println("_____________ scoreMoney:"+scoreMoney);
	 System.out.println("_____________ netSmCode:"+netSmCode);
	 System.out.println("_____________ netFlag:"+netFlag);
	 System.out.println("_____________ dealType:"+dealType);
	 
	 String rtnCode = "0";
	 String rtnMsg = "";
	 
	 if("3".equals(scoreType) && "kf".equals(netSmCode)){
		 
		 %>

		 <s:service name="sMarkScoreChgWS_XML">
		 				<s:param name="ROOT">
		 				 		<s:param name="BUSI_ID" type="string" value="<%=busiId %>" />
		 						<s:param name="CHN_TYPE" type="string" value="<%=chnType %>" />
		 						<s:param name="OP_CODE" type="string" value="<%=opCode %>" />
		 				 		<s:param name="LOGIN_NO " type="string" value="<%=loginNo %>" />
		 						<s:param name="LOGIN_PWD" type="string" value="<%=loginPwd %>" />
		 						<s:param name="NET_CODE" type="string" value="<%=netCode %>" />
		 						<s:param name="USER_PWD" type="string" value="<%=userPwd %>" />
		 						<s:param name="PHONE_CHG_NO" type="string" value="<%=phoneChgNo %>" />
		 						<s:param name="SCORE_VALUE" type="string" value="<%=scoreValue %>" />
		 						<s:param name="DEAL_TYPE" type="string" value="<%=dealType %>" />
		 				</s:param>
		 </s:service>

		 <%
		 	rtnCode = result.getString("RETURN_CODE");
		    rtnMsg = result.getString("RETURN_MSG");	
		 	System.out.println("-----------sMarkScoreChgWS_XML rtnCode="+rtnCode);
		 	System.out.println("-----------sMarkScoreChgWS_XML rtnMsg="+rtnMsg);
	 }
	 
	 if(!"".equals(XML_STR) && ("0".equals(rtnCode)||"000000".equals(rtnCode))){
		 System.out.println("+++++++++++++++++++++++++++++进来了++++++++++++rtnCode = "+rtnCode);
		String regionCode = (String)session.getAttribute("regCode");
		XML_STR="<?xml version=\"1.0\" encoding=\"GBK\" standalone=\"no\" ?>"+XML_STR;
		UType custInfoUtype = null;
		try{
			custInfoUtype=new SaleXml2Utype().chgXml2Utype(XML_STR);
		}catch(Exception e){
%>	
			<script type="text/javascript">
				$(document).ready(function(){
						showDialog("订单报文转换错误，请联系管理员！！",0);
				});
			</script>
<%	
		}
%>
		<wtc:utype name="sMarketExecCfm" id="retVal" routerKey="region"
			routerValue="<%=regionCode%>">
			<wtc:uparams name="ctrlInfo" iMaxOccurs="1">
				<wtc:uparam value="0" type="string" />
			</wtc:uparams>
			<wtc:uparams name="batchDataList" iMaxOccurs="1">
				<wtc:uparams name="batchData" iMaxOccurs="-1">
					<wtc:uparam value="0" type="long" />
					<wtc:uparam value="0" type="string" />
					<wtc:uparam value="0" type="string" />
				</wtc:uparams>
			</wtc:uparams>
			<wtc:uparam value="<%=custInfoUtype%>" type="UTYPE" />
		</wtc:utype>
<%
			RETURN_CODE =String.valueOf(retVal.getValue(0));//返回的retCode为LONG类型；
			RETURN_MSG =String.valueOf(retVal.getValue(1));
			System.out.println("++++++++++++++++++++++++++++sMarketExecCfm+进来了++++++++++++RETURN_CODE = "+RETURN_CODE);
			System.out.println("++++++++++++++++++++++++++++sMarketExecCfm+进来了++++++++++++RETURN_MSG = "+RETURN_MSG);
			if(!"0".equals(RETURN_CODE)){
				if("".equals(RETURN_MSG)){
					RETURN_MSG ="调用订单系统返回错误！！";
				}
			}
	}else{
		System.out.println("++++++++++++++++++++++++++++else+进来了++++++++++++rtnCode = "+rtnCode);
		RETURN_CODE = rtnCode;
		RETURN_MSG = rtnMsg;	
	}
			
Date end = new Date();
System.out.println("messageOprateOder.jsp加载时间++++++++mylog++营销订购页面运行毫秒数+++++++++++++++"+(end.getTime() - start.getTime()));
System.out.println("messageOprateOder.jsp加载时间++++RETURN_CODE="+RETURN_CODE);
System.out.println("messageOprateOder.jsp加载时间++++RETURN_MSG="+RETURN_MSG);
%>
var response = new AJAXPacket(); 
var RETURN_CODES = "<%=RETURN_CODE%>";
var RETURN_MSGS = "<%=RETURN_MSG%>";
response.data.add("RETURN_CODE",RETURN_CODES);
response.data.add("RETURN_MSG",RETURN_MSGS);
core.ajax.receivePacket(response);
