package com.sitech.acctmgr.atom.impl.adj;

import com.sitech.acctmgr.atom.busi.adj.inter.IAdjCommon;
import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.domains.adj.AdjBIllEntity;
import com.sitech.acctmgr.atom.domains.adj.AdjExtendEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.pub.PubCodeDictEntity;
import com.sitech.acctmgr.atom.domains.pub.PubWrtoffCtrlEntity;
import com.sitech.acctmgr.atom.domains.query.GprsChangeRecdEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.domains.user.UserPrcEntity;
import com.sitech.acctmgr.atom.dto.adj.SGivenCfmInDTO;
import com.sitech.acctmgr.atom.dto.adj.SGivenCfmOutDTO;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.BaseBusi;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.common.utils.ValueUtils;
import com.sitech.acctmgr.inter.adj.IGivenMicroPay;
import com.sitech.acctmgr.net.Client;
import com.sitech.acctmgr.net.ClientFactory;
import com.sitech.acctmgr.net.ParseDataException;
import com.sitech.acctmgr.net.ResponseData;
import com.sitech.acctmgr.net.ServerInfo;
import com.sitech.acctmgr.net.gprstrans.GprsTransResponseData;
import com.sitech.acctmgrint.atom.busi.intface.IShortMessage;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;
import com.thoughtworks.xstream.mapper.Mapper;

import groovy.lang.Interceptor;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * <p>Title:  求赠赠予扣费  </p>
 * <p>Description: 此服务用于转赠类业务,类似小额支付,跟crm服务组合使用,crm负责办理资费 </p>
 * <p>Copyright: Copyright (c) 2016</p>
 * <p>Company: SI-TECH </p>
 * @author guowy
 * @version 1.0
 */

@ParamTypes({ @ParamType(m = "cfm", c = SGivenCfmInDTO.class, oc = SGivenCfmOutDTO.class)})
public class SGivenMicroPay extends BaseBusi implements IGivenMicroPay{
    private IUser user;
    private IBalance balance;
    private IBill bill;
    private IControl control;
    private IAdjCommon adjCommon;
    private IAdj adj;
    private IRecord record;
    private IProd prod;
    private IShortMessage shortMessage;
    private IPayManage payManage;
    private IPreOrder preOrder;

    @Override
    public OutDTO cfm(InDTO inParam) {
 
    	 SGivenCfmInDTO inDto=(SGivenCfmInDTO)inParam;
    	 String phoneNo=inDto.getPhoneNo();
         String loginNo=inDto.getLoginNo();
         String serveType = inDto.getServeType();
         String opCode="C239";
         
    	 SGivenCfmOutDTO outDto=new SGivenCfmOutDTO();
    	 try{
    		 //判断业务小类是否合法
    		  if(serveType.substring(0, 1).equals("3") || serveType.substring(0, 1).equals("4") || serveType.substring(0, 1).equals("0")
    	        		|| serveType.substring(0, 1).equals("1") || serveType.substring(0, 1).equals("2")){
    			  outDto = cfmAtom(inDto);
    	         }else{
    	        	 throw new BaseException(AcctMgrError.getErrorCode("8010","20221"), "serverType不合法，请输入正确的serverType业务小类");
    	         }
    		 
    	 }catch(BaseException e){
    		 
    		 payManage.rollback();
    		 //发送短信
    		 
    		 if(e.getErrCode().equals("10111109801020220")){
     			//下发出账期间提示短信
       			sendpayMsg(phoneNo,loginNo,opCode,"10111109801020220");
     		 }else if(e.getErrCode().equals("10111109801020200")){
    	         //下发预存不足短信
    	         sendpayMsg(phoneNo,loginNo,opCode,"10111109801020200");
    		 }else if(e.getErrCode().equals("10111109801020203")){
     			//下发流量不足提示短信
       			sendpayMsg(phoneNo,loginNo,opCode,"10111109801020203");
     		 }else{
    			 //下发系统繁忙短信
    			 sendpayMsg(phoneNo,loginNo,opCode,"00000000000000001");
    		 }
    		 
    		 payManage.commit();
    		 throw new BaseException(e);
    	 }
    	 
    	 return outDto;
    }
    
    //为了实现发送短信，将所有的异常抛出后进行处理
    private SGivenCfmOutDTO cfmAtom(SGivenCfmInDTO inDto){
         String phoneNo=inDto.getPhoneNo();
         long giveFee=inDto.getGiveFee();
         String pubFlag=inDto.getPubFlag();
         String serveType=inDto.getServeType();
         String foreignSn=inDto.getForeignSN();
         String gprs=inDto.getGprs();
         String marcPrc=inDto.getMarkPrc();
         String marcSn=inDto.getMarkSn();
         String remark=inDto.getRemark();
         String loginNo=inDto.getLoginNo();
         String groupId=inDto.getGroupId();
         String provinceId=inDto.getProvinceId();
         String opCode="C239";
         

         if("".equals(remark) || remark==null){
             remark="\"求赠+赠予\"业务办理";
         }

         if("3".equals(serveType)){
             remark=serveType+"|"+gprs+"|"+remark;
         }else{
             remark=serveType+"|"+remark;
         }
         
         //判断出账期间不允许办理
         PubWrtoffCtrlEntity wrtoffCtrlEntity = control.getWriteOffFlagAndMonth();
         if (wrtoffCtrlEntity.getWrtoffFlag().equals("1")) { // 出账期间
				
			throw new BaseException(AcctMgrError.getErrorCode("8010","20220"), "系统出账期间不允许办理剩余流量转赠业务");
		}

         //获取当前时间
         String curTime = DateUtil.format(new Date(), PayBusiConst.YYYYMMDDHHMMSS2);
         String yearMonth=String.format("%6s", curTime.substring(0, 6));//当前年月
         int totalDate= Integer.parseInt(String.format("%6s", curTime.substring(0, 8)));

         /*取用户的默认账户,作为小额支付账户*/
         UserInfoEntity userEnt = user.getUserInfo(phoneNo);
         Long contractNo=userEnt.getContractNo();

         /*取用户主资费*/
         //取用户主产品
         UserPrcEntity userPrcEnt = prod.getUserPrcidInfo(userEnt.getIdNo());
         String prodPrcid = userPrcEnt.getProdPrcid();

         /*校验账户预存,预存不足,不允许办理*/
         Map<String, Object> inMap = new HashMap<String, Object>();
         inMap.put("CONTRACT_NO",contractNo);
         inMap.put("PAY_ATTR4","0");
         //inMap.put("SPECIAL_FLAG","1");
         Long curBalance=balance.getAcctBookSumByMap(inMap);
         if(curBalance<giveFee){
             throw new BaseException(AcctMgrError.getErrorCode("8010", "20200"),"可用预存不足,请充值后办理！!");
         }

         /*取补收流水*/
         long paySn=control.getSequence("SEQ_PAY_SN");

         /*取配置账目项*/
         String acctItemCode=control.getPubCodeValue(2418,serveType,null);

         /*取账单bill_day*/
         Map<String, Object> inAdjMap = new HashMap<String, Object>();
         inAdjMap.put("CONTRACT_NO",contractNo);
         inAdjMap.put("BILL_CYCLE",yearMonth);
         inAdjMap.put("BILL_DAY_BEGIN","7000");
         inAdjMap.put("BILL_DAY_END","7999");
         inAdjMap.put("SUFFIX",yearMonth);
         int billDay=bill.getMaxBillDay(inAdjMap);

         //用户基本信息实体设值
         PayUserBaseEntity userBase = new PayUserBaseEntity();
         userBase.setContractNo(contractNo);
         userBase.setCustId(userEnt.getCustId());
         userBase.setIdNo(userEnt.getIdNo());
         userBase.setPhoneNo(phoneNo);
         userBase.setBrandId(userEnt.getBrandId());
         userBase.setUserGroupId(userEnt.getGroupId());
         userBase.setProdPrcid(prodPrcid);

         //补收账单实体设值
         AdjBIllEntity billEnt = new AdjBIllEntity();
         billEnt.setBillCycle(Integer.parseInt(yearMonth));
         billEnt.setNaturalMonth(Integer.parseInt(yearMonth));
         billEnt.setAcctItemCode(acctItemCode);
         billEnt.setShouldPay(giveFee);
         billEnt.setBillDay(billDay);

         //入账实体设值
         PayBookEntity inBook =  new PayBookEntity();
         inBook.setGroupId(groupId);
         inBook.setLoginNo(loginNo);
         inBook.setOpCode(opCode);
         inBook.setOpNote(remark);
         inBook.setPaySn(paySn);

         //补收核心函数
         inAdjMap = new HashMap<String, Object>();
         inAdjMap.put("Header", inDto.getHeader());
         inAdjMap.put("PAY_BOOK_ENTITY", inBook);
         inAdjMap.put("ADJ_BILL_ENTITY", billEnt);
         inAdjMap.put("PAY_USER_BASE_ENTITY", userBase);
         inAdjMap.put("PROVINCE_ID", provinceId);
         inAdjMap.put("BILL_ID", 0L);

         Map<String, Object> outParamMap = adjCommon.MicroAdj(inAdjMap);

         //记录小额支付记录表bal_micropay_info
         inAdjMap = new HashMap<String, Object>();
         inAdjMap.put("PHONE_NO",phoneNo);
         inAdjMap.put("ID_NO",userEnt.getIdNo());
         inAdjMap.put("CONTRACT_NO",contractNo);
         inAdjMap.put("UNIT_CODE","");
         inAdjMap.put("BUSI_CODE",serveType);
         inAdjMap.put("INNET_CODE","");
         inAdjMap.put("OP_TYPE","given");
         inAdjMap.put("AMOUNT", gprs);
         inAdjMap.put("UNIT_PRICE","");
         inAdjMap.put("PAY_TYPE","0");
         inAdjMap.put("PAY_FEE",giveFee);
         inAdjMap.put("FOREIGN_SN",foreignSn);
         inAdjMap.put("PAY_SN",paySn);
         inAdjMap.put("ORI_PAY_SN","");
         inAdjMap.put("ORI_FOREIGN_SN","");
         inAdjMap.put("USE_FLAG","0");
         inAdjMap.put("REMARK",remark);
         inAdjMap.put("FACTOR_ONE",marcPrc);
         inAdjMap.put("FACTOR_TWO",marcSn);
         inAdjMap.put("FACTOR_THREE",pubFlag);
         inAdjMap.put("FACTOR_FOUR","");
         inAdjMap.put("FACTOR_FIVE","");
         inAdjMap.put("LOGIN_NO",loginNo);
         adj.saveMicroPayInfo(inAdjMap);

         //记录营业员操作记录表
         LoginOprEntity loginOprEnt = new LoginOprEntity();
         loginOprEnt.setBrandId(userBase.getBrandId());
         loginOprEnt.setIdNo(userBase.getIdNo());
         loginOprEnt.setLoginGroup(groupId);
         loginOprEnt.setLoginNo(loginNo);
         loginOprEnt.setLoginSn(paySn);
         loginOprEnt.setOpCode(opCode);
         loginOprEnt.setOpTime(curTime);
         loginOprEnt.setPayFee(giveFee);
         loginOprEnt.setPhoneNo(phoneNo);
         loginOprEnt.setRemark(remark);
         loginOprEnt.setPayType("0");
         loginOprEnt.setTotalDate(totalDate);
         record.saveLoginOpr(loginOprEnt);
         String formatGPRS = String.format("%07d", Integer.parseInt(gprs.trim()));
         
         
         
         //向其他系统同步数据（目前：统一接触）
         Map inMapTmp = new HashMap<String, Object>();
         inMapTmp.put("PAY_SN", paySn);
         inMapTmp.put("LOGIN_NO", loginNo);
         inMapTmp.put("GROUP_ID", groupId);
         
         if(serveType.substring(0, 1).equals("3")){
        	 inMapTmp.put("OP_CODE", "C286");
         }else if(serveType.substring(0, 1).equals("4")){
        	 inMapTmp.put("OP_CODE", "C287");
         }else if(serveType.substring(0, 1).equals("0")){
        	 inMapTmp.put("OP_CODE", "C288");
         }else if(serveType.substring(0, 1).equals("1")){
        	 inMapTmp.put("OP_CODE", "C289");
         }else if(serveType.substring(0, 1).equals("2")){
        	 inMapTmp.put("OP_CODE", "C290");
         }
         
         inMapTmp.put("OP_TIME", curTime);
         //inMapTmp.put("REGION_ID", "");
         inMapTmp.put("CUST_ID_TYPE", "1"); // 0客户ID;1-服务号码;2-用户ID;3-账户ID
         inMapTmp.put("CUST_ID_VALUE", phoneNo);
         inMapTmp.put("TOTAL_FEE", giveFee);
       	 inMapTmp.put("OP_NOTE", phoneNo+"求赠赠予:"+ValueUtils.transFenToYuan(giveFee)+"元");
         inMapTmp.put("Header", inDto.getHeader());

         preOrder.sendOprCntt(inMapTmp);
         
         
         
         String status = "";

         if(serveType.substring(0, 1).equals("3") || serveType.substring(0, 1).equals("4")){
             //给计费发话单,计费侧只实现流量扣减，没有流量增加
         	status = sendBill(phoneNo,yearMonth,"X",formatGPRS,"","1");
         	
         	switch(status)
             {
         		case "0":
         			log.info("========"+phoneNo+"流量转赠计费处理成功========");
         			break;
         		case "1":
         		    throw new BaseException(AcctMgrError.getErrorCode("8010", "20201"),"请求包格式错误!");
         		case "2":
         		    throw new BaseException(AcctMgrError.getErrorCode("8010", "20202"),"网络异常（访问1860失败）!");
         		case "3":
         		    throw new BaseException(AcctMgrError.getErrorCode("8010", "20203"),"用户转增流量值非法（剩余量小于用户需要转增的量）!");
         		case "4":
         			throw new BaseException(AcctMgrError.getErrorCode("8010", "20204"),"用户转增流量值非法（转增量不大于0）!");
         		case "5":
         			throw new BaseException(AcctMgrError.getErrorCode("8010", "20205"),"网络异常（访问1860超时）!");
         		case "6":
         			throw new BaseException(AcctMgrError.getErrorCode("8010", "20206"),"系统异常（生成转增话单失败）!");
         		case "7":
         			throw new BaseException(AcctMgrError.getErrorCode("8010", "20207"),"转增的日期非本月!");
         		default:
         			throw new BaseException(AcctMgrError.getErrorCode("8010", "20208"),"其他错误!");
             }
         	
         } 

         SGivenCfmOutDTO outDTO=new SGivenCfmOutDTO();
         outDTO.setPaySn(paySn);
         outDTO.setTotalDate(totalDate);
         log.info("SGivenCfmOutDTO->"+outDTO.toJson());
         return outDTO;
    }
    
    
    /**
	 * 查询集团账户划拨明细
	 * @param phoneNo 服务号码
	 * @param yearMonth 年月
	 * @param busiCode X
	 * @param volum	流量
	 * @param exCode 剔除资费串
	 * @param favType 
	 * @return
     */
    private String sendBill(String phoneNo,String yearMonth,String busiCode,String volum,String exCode,String favType){
    	
    	//根据用户获取路由的请求地址
        ServerInfo serverInfo = control.getPhoneRouteConf(phoneNo.substring(0, 7), "GPRSTRANS");
    	
    	ClientFactory factory = ClientFactory.getInstance();
        Client client = factory.getClient("gprstrans");
        client.setRequestArgs(phoneNo, yearMonth, busiCode, volum, exCode, favType);
//      client.getServerProxy().setServerInfo(serverInfo);
        client.getServerProxy().setServerInfo("10.110.19.135", 9400);
        ResponseData rd = client.getResponseData();
        try {
            rd.parse();
        } catch (ParseDataException ex) {
        	ex.printStackTrace();
        }
        
        GprsTransResponseData frd = null;
        if (rd instanceof GprsTransResponseData) {
            frd = (GprsTransResponseData) rd;
        }

        String status = "";
        if (frd != null) {
        	status = frd.getStatus();
        }

    	return status;
    }
    
    
    
    //发送提示短信
  	private void sendpayMsg(String phoneNo,String loginNo, String opCode,String codeId){
  		
  		Map<String, Object> mapTmp = new HashMap<String, Object>();
  		MBean inMessage = new MBean();
  		
  		//BOSS_8000: ${tmpMsg2}【中国移动】${sms_release} 
  		
  		
  		String msgBody = "";
  		List<PubCodeDictEntity> msgList = control.getPubCodeList(2512L, codeId, null, "0");
  		msgBody = msgList.get(0).getCodeValue();
  		
		mapTmp.put("msg", "尊敬的客户，您好！"+msgBody+"中国移动");
		inMessage.addBody("TEMPLATE_ID", "311200000001");
  		
  		inMessage.addBody("PHONE_NO", phoneNo);
  		inMessage.addBody("LOGIN_NO", loginNo);;
  		inMessage.addBody("OP_CODE", opCode);
  		inMessage.addBody("CHECK_FLAG", true);
  		inMessage.addBody("DATA", mapTmp);
  		
  		String flag = control.getPubCodeValue(2011, "DXFS", null);  // 0:直接发送 1:插入短信接口临时表 2：外系统有问题，直接不发送短信
  		if(flag.equals("0")){
  			inMessage.addBody("SEND_FLAG", 0);
  		}else if(flag.equals("1")){
  			inMessage.addBody("SEND_FLAG", 1);
  		}else if(flag.equals("2")){
  			return;
  		}
  		log.info("发送短信内容：" + inMessage.toString());
  		shortMessage.sendSmsMsg(inMessage, 1);
  	}


    public IUser getUser() {
        return user;
    }

    public void setUser(IUser user) {
        this.user = user;
    }

    public IBalance getBalance() {
        return balance;
    }

    public void setBalance(IBalance balance) {
        this.balance = balance;
    }

    public IBill getBill() {
        return bill;
    }

    public void setBill(IBill bill) {
        this.bill = bill;
    }

    public IControl getControl() {
        return control;
    }

    public void setControl(IControl control) {
        this.control = control;
    }

    public IAdjCommon getAdjCommon() {
        return adjCommon;
    }

    public void setAdjCommon(IAdjCommon adjCommon) {
        this.adjCommon = adjCommon;
    }

    public IAdj getAdj() {
        return adj;
    }

    public void setAdj(IAdj adj) {
        this.adj = adj;
    }

    public IRecord getRecord() {
        return record;
    }

    public void setRecord(IRecord record) {
        this.record = record;
    }

    public IProd getProd() {
        return prod;
    }

    public void setProd(IProd prod) {
        this.prod = prod;
    }


	public IShortMessage getShortMessage() {
		return shortMessage;
	}


	public void setShortMessage(IShortMessage shortMessage) {
		this.shortMessage = shortMessage;
	}

	public IPayManage getPayManage() {
		return payManage;
	}

	public void setPayManage(IPayManage payManage) {
		this.payManage = payManage;
	}

	public IPreOrder getPreOrder() {
		return preOrder;
	}

	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}
}
