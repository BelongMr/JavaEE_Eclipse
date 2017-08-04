package com.sitech.acctmgr.atom.impl.pay;

import static com.sitech.acctmgr.common.AcctMgrError.getErrorCode;
import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.nio.file.attribute.GroupPrincipal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.IPayManage;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.busi.pay.inter.ITransType;
import com.sitech.acctmgr.atom.busi.pay.trans.TransFactory;
import com.sitech.acctmgr.atom.busi.query.inter.IRemainFee;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.fee.OutFeeData;
import com.sitech.acctmgr.atom.domains.pay.GroupChargeEntity;
import com.sitech.acctmgr.atom.domains.pay.PayBookEntity;
import com.sitech.acctmgr.atom.domains.pay.PayUserBaseEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.pay.S8296CfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8296CfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S8296DeleteInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8296DeleteOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S8296InitErrInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8296InitErrOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S8296InitHisInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8296InitHisOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S8296InitRecdInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8296InitRecdOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IBalance;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.ICust;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.atom.entity.inter.IUser;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.inter.pay.I8014;
import com.sitech.acctmgr.inter.pay.I8296;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.DtKit;
import com.sitech.jcfx.dt.MBean;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
* @Title:   []
* @Description: 
* @Date : 2016年8月16日上午9:45:05
* @Company: SI-TECH
* @author : LIJXD
* @version : 1.0
* @modify history
*  <p>修改日期    修改人   修改目的<p> 	
*/
@ParamTypes({
	    @ParamType(c=S8296DeleteInDTO.class,oc=S8296DeleteOutDTO.class,m="del"),
	    @ParamType(c=S8296InitRecdInDTO.class,oc=S8296InitRecdOutDTO.class,m="initRecd"),
	    @ParamType(c=S8296InitHisInDTO.class,oc=S8296InitHisOutDTO.class,m="initHis"),
	    @ParamType(c=S8296InitErrInDTO.class,oc=S8296InitErrOutDTO.class,m="initErr"),
        @ParamType(c=S8296CfmInDTO.class,oc=S8296CfmOutDTO.class,m="cfm")

})
public class S8296 extends AcctMgrBaseService implements I8296 {

	protected IRecord 	record;
	protected IGroup 	group;
	protected IControl 	control;
	protected IPreOrder preOrder;
	protected IAccount account;
	protected IBalance balance;
	protected IRemainFee remainFee;
	protected IUser user;	
	protected ICust cust;	
	protected TransFactory transFactory;
	protected IPayManage payManage;

	protected InDTO parseInDTO(MBean in, Class<?> clazz)	{
		InDTO inDTO = DtKit.toDTO(in, clazz);
		return inDTO;
	}
	@Override
	public OutDTO initRecd(InDTO inParam) {
		// TODO Auto-generated method stub

		S8296InitRecdInDTO inDto = (S8296InitRecdInDTO) inParam;
		log.info("S8296InitRecdInDTO->"+inDto.getMbean());
		long groupCon = inDto.getGroupContractNo();

		long prepay_fee = balance.getSumBalacneByPayTypes(groupCon,"0");
		OutFeeData feeData= remainFee.getConRemainFee(groupCon);
		long grpConPrepay = feeData.getRemainFee();
		grpConPrepay = grpConPrepay < prepay_fee ? grpConPrepay : prepay_fee ;

		long payTotal=0;
		String groupProductName="未知";
		
		List<GroupChargeEntity> listGrpCon=  record.getGroupChargeRecdList(groupCon);
		for(GroupChargeEntity entity : listGrpCon){
			payTotal+=entity.getPayMoney();
			if(groupProductName.equals("未知")){
				groupProductName=entity.getGroupProductName();
			}
		}
		
		S8296InitRecdOutDTO outDto = new S8296InitRecdOutDTO();
		outDto.setListGrpCon(listGrpCon);
		outDto.setGrpConSize(listGrpCon.size());
		outDto.setGrpCon(groupCon);
		outDto.setGrpPrepay(grpConPrepay);
		outDto.setPayedSum(payTotal);
		outDto.setGroupProductName(groupProductName);

		log.info("S8296InitRecdOutDTO->"+outDto.toJson());
		return outDto;	
	}

	
	@Override
	public OutDTO cfm(InDTO inParam) {
		// TODO Auto-generated method stub
		Map<String, Object> inForMap = new HashMap<String, Object>();
		//Map<String, Object> outForMap = new HashMap<String, Object>();

		S8296CfmInDTO inDto = (S8296CfmInDTO) inParam;
		log.error("S8296CfmInDTO->"+inDto.getMbean());

		String opCode= inDto.getOpCode();
		String loginNo= inDto.getLoginNo();
		String groupId= inDto.getGroupId();
		long groupCon = inDto.getGroupContractNo();
		String provinceId=inDto.getProvinceId();
		String remark ="集团账户["+groupCon+"]自由划拨";
		String  opType="GrpProduct";

		//构建转账类型实体
		ITransType transType=transFactory.createTransFactory(opType,isOnNet());

		long paySn=0;

		ChngroupRelEntity groupRelEntity = group.getRegionDistinct(groupId, "2", inDto.getProvinceId());
		String regionCode = groupRelEntity.getRegionCode();

		//获取时间
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String totalDate = curTime.substring(0, 8);
		String curYM = curTime.substring(0, 6);

		//获取批次流水lBatchSn
		long newBatchSn =  control.getSequence("SEQ_SYSTEM_SN");

		//处理划拨导入记录，给划拨号码转账

		//1、出账期间不允许转账
		//2、集团行业应用流量包产品转账
		//3、查询集团归属，哈尔滨不发送短信（8014短信函数配置）

		/* 获取用户基本信息 */
		PayUserBaseEntity  baseInfo = getBaseInfo("",groupCon,provinceId);
		long custId = baseInfo.getCustId();
		String outBrandId = baseInfo.getBrandId();
		long outIdNo = baseInfo.getIdNo();

		/* 个性化业务校验  */
		getSpecialBusiness(baseInfo);
		
		//5、转账开始
		//5.1 取集团账户可转预存（只能转0账本）
		//5.2 集团预存<划拨金额||划拨金额<=0，continue
		//5.3 校验用户以及状态（A/B/C/O），失败记录err表
		//5.4 转账、冲销、开机
		//5.5 给非哈尔滨号码发送短信
		//5.6 记录his表，删除recd表
		
		List<GroupChargeEntity>recdList=record.getGroupChargeRecdList(groupCon);
		for(GroupChargeEntity grp: recdList){
			String phoneNo=grp.getPhoneNo();
			long payMoney=grp.getPayMoney();
			long oldAccept=grp.getImportBatchSn();
			long contractNo = grp.getContractNo();
			String errMsg="";
			
			Map<String, Object> inTmpMap =null;
			//Map<String, Object> outTmpMap = null;

			PayUserBaseEntity  userInfo = getBaseInfo(phoneNo,contractNo,provinceId);

			if (!(userInfo.getRunCode().equals("A") || userInfo.getRunCode().equals("B") || userInfo.getRunCode().equals("C") || userInfo.getRunCode().equals("O"))){
				errMsg="用户状态为:"+userInfo.getRunCode()+",不允许划拨!";

				inTmpMap = new HashMap<String, Object>();
				inTmpMap.put("PHONE_NO", phoneNo);
				inTmpMap.put("IMPORT_BATCH_SN", oldAccept);
				inTmpMap.put("TRANS_CODE", opCode);
				inTmpMap.put("TRANS_LOGIN", loginNo);
				inTmpMap.put("ERR_MSG", errMsg);
				record.saveGroupChargeErr(inTmpMap);

				continue;
			}

			// 用户不存在、金额<0 ，记录err表
			if (userInfo == null || payMoney <= 0) {
				inTmpMap = new HashMap<String, Object>();
				inTmpMap.put("PHONE_NO", phoneNo);
				inTmpMap.put("IMPORT_BATCH_SN", oldAccept);
				inTmpMap.put("TRANS_CODE", opCode);
				inTmpMap.put("TRANS_LOGIN", loginNo);
				inTmpMap.put("ERR_MSG", "用户不存在");
				record.saveGroupChargeErr(inTmpMap);

				continue;
			}
			
			try {

				/*入账实体设值*/
				PayBookEntity bookIn = new PayBookEntity();
				bookIn.setBeginTime(curTime);
				bookIn.setForeignSn("");
				bookIn.setGroupId(groupId);
				bookIn.setLoginNo(loginNo);
				bookIn.setOpCode(opCode);
				bookIn.setOpNote(remark);
				bookIn.setPayFee(payMoney);
				bookIn.setPayMethod("0");
				bookIn.setPayPath("11");
				bookIn.setTotalDate(Integer.parseInt(totalDate));
				bookIn.setYearMonth(Long.parseLong(curYM));
				bookIn.setOpTime(curTime);
				bookIn.setForeignSn(String.valueOf(oldAccept));

				//转账\冲销\发送营业日报
				Map inTransCfmMap = new HashMap<String, Object>();
				safeAddToMap(inTransCfmMap, "Header", ((S8296CfmInDTO) inParam).getHeader());
				safeAddToMap(inTransCfmMap, "TRANS_TYPE_OBJ", transType); //转账类型实例化对象
				safeAddToMap(inTransCfmMap, "TRANS_IN", userInfo);  //转入账户基本信息
				safeAddToMap(inTransCfmMap, "TRANS_OUT", baseInfo); //转出账户基本信息
				safeAddToMap(inTransCfmMap, "BOOK_IN", bookIn); //入账实体
				safeAddToMap(inTransCfmMap, "OP_TYPE", opType); //转账类型
				safeAddToMap(inTransCfmMap, "WRITEOFF_FLAG", "Y"); //冲销标志
				safeAddToMap(inTransCfmMap, "LOGINOPR_FLAG", "Y"); //记录营业日报标志
				paySn=payManage.trans(inTransCfmMap);
				
				/*缴费扩展表录入政企客户信息*/
				if(outBrandId.equals("2310ZQ")){
					Map<String,Object> zqMap = new HashMap<String,Object>();
					zqMap.put("PAY_SN", paySn);
					zqMap.put("CUST_ID", custId);
					zqMap.put("OUT_CONTRACT_NO", groupCon);
					zqMap.put("IN_CONTRACT_NO", contractNo);
					zqMap.put("ID_NO", outIdNo);
					zqMap.put("OP_CODE", opCode);
					zqMap.put("LOGIN_NO", loginNo);
					zqMap.put("HEADER", inDto.getHeader());
					zqMap.put("FOREIGN_SN", String.valueOf(oldAccept));
					payManage.insertZQInfo(zqMap);
				}
				
				//发送短信

				//把划拨数据移入his表
				inTmpMap = new HashMap<String, Object>();
				inTmpMap.put("PHONE_NO", phoneNo);
				inTmpMap.put("IMPORT_BATCH_SN", oldAccept);
				inTmpMap.put("TRANS_CODE", opCode);
				inTmpMap.put("TRANS_LOGIN", loginNo);
				inTmpMap.put("TRANS_SN", paySn);
				record.saveGroupChargeHis(inTmpMap);
				
			} catch (Exception e) {
				e.printStackTrace();

				inTmpMap = new HashMap<String, Object>();
				inTmpMap.put("PHONE_NO", phoneNo);
				inTmpMap.put("IMPORT_BATCH_SN", oldAccept);
				inTmpMap.put("TRANS_CODE", opCode);
				inTmpMap.put("TRANS_LOGIN", loginNo);
				inTmpMap.put("ERR_MSG", e.getMessage().substring(0,180));
				record.saveGroupChargeErr(inTmpMap);
			}
		}
		
		//发送统一接触消息
		inForMap = new HashMap<String , Object>();
		safeAddToMap(inForMap,"Header",inDto.getHeader());
		safeAddToMap(inForMap,"PAY_SN", newBatchSn);
		safeAddToMap(inForMap,"LOGIN_NO",loginNo);
		safeAddToMap(inForMap,"GROUP_ID",groupId);
		safeAddToMap(inForMap,"OP_CODE",opCode);
		safeAddToMap(inForMap,"REGION_ID",regionCode);
		safeAddToMap(inForMap,"OP_NOTE",remark);
		safeAddToMap(inForMap,"CUST_ID_TYPE","2");
		safeAddToMap(inForMap,"CUST_ID_VALUE",groupCon);
		safeAddToMap(inForMap,"OP_TIME",curTime);
		preOrder.sendOprCntt(inForMap);
				
		
		S8296CfmOutDTO outDto = new S8296CfmOutDTO();
		outDto.setBatchSn(newBatchSn);
		return outDto;	
	}


	@Override
	public OutDTO del(InDTO inParam) {
		// TODO Auto-generated method stub
		Map<String, Object> inForMap = new HashMap<String, Object>();
		//Map<String, Object> outForMap = new HashMap<String, Object>();
		
		S8296DeleteInDTO inDto = (S8296DeleteInDTO) inParam;
		log.error("S8296DeleteInDTO-->"+inDto.getMbean());
		
		String opCode= inDto.getOpCode();
		String loginNo= inDto.getLoginNo();
		String groupId= inDto.getGroupId();
		long groupCon = inDto.getGroupContractNo();
		String remark ="集团账户["+groupCon+"]删除划拨记录";
		
		ChngroupRelEntity groupRelEntity = group.getRegionDistinct(groupId, "2", inDto.getProvinceId());
		String regionCode = groupRelEntity.getRegionCode();

		//获取时间
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		//String curYm = curTime.substring(0, 6);
		String totalDate = curTime.substring(0, 8);
		
		//获取批次流水lBatchSn
		long batchSn =  control.getSequence("SEQ_SYSTEM_SN");
		
		//删除集团账户下的划拨号码记录
		int delCnt=record.delGroupChargeRecdByGrp(groupCon);
		log.info("集团账户删除划拨记录:delCnt=["+delCnt+"]");
		if(0==delCnt){
			log.error("集团账户删除划拨记录为0 ["+groupCon+"]");
			throw new BusiException(AcctMgrError.getErrorCode("8296","00001"), "集团账户没有划拨记录!");
		}
		
		//统一日志
		LoginOprEntity in = new LoginOprEntity();
		in.setIdNo(0);
		in.setPhoneNo("99999999999");
		in.setPayType("0");
		in.setPayFee(0);
		in.setLoginSn(batchSn);
		in.setLoginNo(loginNo);
		in.setLoginGroup(groupId);
		in.setOpCode(opCode);
		in.setTotalDate(Long.parseLong(totalDate));
		in.setRemark(inDto.getOpCode());
		record.saveLoginOpr(in);
		
		//发送统一接触消息
		inForMap = new HashMap<String , Object>();
		safeAddToMap(inForMap,"Header",inDto.getHeader());
		safeAddToMap(inForMap,"PAY_SN", batchSn);
		safeAddToMap(inForMap,"LOGIN_NO",loginNo);
		safeAddToMap(inForMap,"GROUP_ID",groupId);
		safeAddToMap(inForMap,"OP_CODE",opCode);
		safeAddToMap(inForMap,"REGION_ID",regionCode);
		safeAddToMap(inForMap,"OP_NOTE",remark);
		safeAddToMap(inForMap,"CUST_ID_TYPE","2");
		safeAddToMap(inForMap,"CUST_ID_VALUE",groupCon);
		safeAddToMap(inForMap,"OP_TIME",curTime);
		preOrder.sendOprCntt(inForMap);
				
		
		S8296DeleteOutDTO outDto = new S8296DeleteOutDTO();
		outDto.setBatchSn(batchSn);
		return outDto;	
	}


	@Override
	public OutDTO initHis(InDTO inParam) {
		// TODO Auto-generated method stub
		S8296InitHisInDTO inDto = (S8296InitHisInDTO) inParam;
		log.error("S8296InitHisInDTO-->"+inDto.getMbean());
		long groupCon = inDto.getGroupContractNo();
		String beginTime=inDto.getBeginTime();
		String endTime = inDto.getEndTime();
		Long begin = Long.parseLong(beginTime);
		Long end = Long.parseLong(endTime);
		if(begin > end){
			throw new BusiException(AcctMgrError.getErrorCode("8296", "00003"), "开始时间不得大于结束时间！");
		}
		
		List<GroupChargeEntity> listGrpCon=  record.getGroupChargeHisList(groupCon,beginTime,endTime);
		
		S8296InitHisOutDTO outDto = new S8296InitHisOutDTO();
		outDto.setListGrpCon(listGrpCon);
		outDto.setGrpConSize(listGrpCon.size());
		log.error("S8296InitHisOutDTO-->"+outDto.toJson());
		return outDto;	
	}


	@Override
	public OutDTO initErr(InDTO inParam) {
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
		S8296InitErrInDTO inDto = (S8296InitErrInDTO) inParam;
		log.error("------> 8296InitRecd_in"+inDto.getMbean());
		long groupCon = inDto.getGroupContractNo();
		String beginTime=inDto.getBeginTime();
		String endTime = inDto.getEndTime();
		Long begin = Long.parseLong(beginTime);
		Long end = Long.parseLong(endTime);
		if(begin > end){
			throw new BusiException(AcctMgrError.getErrorCode("8296", "00003"), "开始时间不得大于结束时间！");
		}
		
		List<GroupChargeEntity> listGrpCon=  record.getGroupChargeErrList(groupCon,beginTime,endTime);
		
		log.info("---->9999"+listGrpCon.toString());
		S8296InitErrOutDTO outDto = new S8296InitErrOutDTO();
		outDto.setListGrpCon(listGrpCon);
		outDto.setGrpConSize(listGrpCon.size());
		return outDto;		
	}

	/* 获取用户、客户基本信息 */
	private PayUserBaseEntity getBaseInfo(String inPhoneNo, long inContractNo,String provinceId) {
		log.info("getBaseInfo-->phoneNo:"+inPhoneNo+",contractNo"+ inContractNo);

		String phoneNo = inPhoneNo;
		long contractNo = inContractNo;
		long contractNoTemp=0;
		long idNo=0;
		String brandId = "";
		String runCode="";

		if ( (phoneNo == null || phoneNo.equals(""))&& inContractNo==0 ){
			throw new BusiException(AcctMgrError.getErrorCode("8296", "00002"), "PHONE_NO不能为空和CONTRACT_NO不能同时为空");
		}

		if(phoneNo == null || phoneNo.equals("")){
			String defPhone = account.getPayPhoneByCon(contractNo);
			if (defPhone.equals("")) {
				phoneNo="99999999999";
			}else{
				phoneNo=defPhone;
			}
		}

		if (phoneNo.equals("99999999999")){
			brandId="XX";
			idNo=0;
			runCode="A";
		}else{
			UserInfoEntity  userEntity = user.getUserInfo(phoneNo);
			brandId=userEntity.getBrandId();
			idNo=userEntity.getIdNo();
			runCode=userEntity.getRunCode();
			contractNoTemp=userEntity.getContractNo();
		}

		if(contractNo==0){
			contractNo=contractNoTemp;
		}

		//*获取账户信息*/
		ContractInfoEntity accountEnt = account.getConInfo(contractNo);
		String conGroup= accountEnt.getGroupId();

		//查询账户地市归属信息
		ChngroupRelEntity groupEntity = group.getRegionDistinct(conGroup, "2", provinceId);
		String regionId = groupEntity.getRegionCode();

		// 出参信息
		PayUserBaseEntity baseInfo = new PayUserBaseEntity();
		baseInfo.setContractNo(contractNo);
		baseInfo.setIdNo(idNo);
		baseInfo.setBrandId(brandId);
		baseInfo.setPhoneNo(phoneNo);
		baseInfo.setUserGroupId(conGroup);
		baseInfo.setRegionId(regionId);
		baseInfo.setNetFlag(isOnNet());
		baseInfo.setRunCode(runCode);
		return baseInfo;
	}

	public Map<String, Object> getSpecialBusiness(PayUserBaseEntity baseInfo){
		String brandId = baseInfo.getBrandId();

		/*TODO 集团流量包产品（sm_code="LL"）不允许转账 */
		if (brandId.equals("2310LL")) {
			throw new BaseException(AcctMgrError.getErrorCode("8296", "00017"), "集团行业流量包产品不允许转账!");
		}

		return null;
	}
	

	
	/* 在网、离网判断 */
	public boolean isOnNet() {
			return true;
	}
	
	/**
	 * @param record the record to set
	 */
	public void setRecord(IRecord record) {
		this.record = record;
	}


	/**
	 * @param group the group to set
	 */
	public void setGroup(IGroup group) {
		this.group = group;
	}


	/**
	 * @param control the control to set
	 */
	public void setControl(IControl control) {
		this.control = control;
	}


	/**
	 * @param preOrder the preOrder to set
	 */
	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}


	/**
	 * @param account the account to set
	 */
	public void setAccount(IAccount account) {
		this.account = account;
	}


	/**
	 * @param balance the balance to set
	 */
	public void setBalance(IBalance balance) {
		this.balance = balance;
	}


	/**
	 * @param remainFee the remainFee to set
	 */
	public void setRemainFee(IRemainFee remainFee) {
		this.remainFee = remainFee;
	}


	/**
	 * @param user the user to set
	 */
	public void setUser(IUser user) {
		this.user = user;
	}


	/**
	 * @param cust the cust to set
	 */
	public void setCust(ICust cust) {
		this.cust = cust;
	}


	/**
	 * @param transFactory the transFactory to set
	 */
	public void setTransFactory(TransFactory transFactory) {
		this.transFactory = transFactory;
	}

	public void setPayManage(IPayManage payManage) {
		this.payManage = payManage;
	}
}
