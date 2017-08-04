package com.sitech.acctmgr.atom.impl.pay;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.GroupUserInfo;
import com.sitech.acctmgr.atom.domains.user.UserBrandEntity;
import com.sitech.acctmgr.atom.dto.pay.S8295CfmInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8295CfmOutDTO;
import com.sitech.acctmgr.atom.dto.pay.S8295InitInDTO;
import com.sitech.acctmgr.atom.dto.pay.S8295InitOutDto;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.utils.FtpUtils;
import com.sitech.acctmgr.inter.pay.I8295;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BaseException;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;

/**
* @Title:   []
* @Description: 
* @Date : 2016年8月11日上午11:17:27
* @Company: SI-TECH
* @author : LIJXD
* @version : 1.0
* @modify history
*  <p>修改日期    修改人   修改目的<p> 	
*/

@ParamTypes({
		@ParamType(c=S8295CfmInDTO.class,oc=S8295CfmOutDTO.class,m="cfm"),
		@ParamType(c=S8295InitInDTO.class,oc=S8295InitOutDto.class,m="init")
})
public class S8295 extends AcctMgrBaseService implements I8295 {

	protected IRecord 	record;
	protected IControl 	control;
	protected IProd 	prod;
	protected IUser 	user;
	protected IGroup 	group;
	protected IPreOrder preOrder;
	protected IBalance 	balance;
	protected ICust  	cust;

	public OutDTO init(InDTO inParam){

		S8295InitInDTO inDto =  (S8295InitInDTO)inParam;
		log.debug("S8295InitInDTO->"+inDto.getMbean());

		long iccId =inDto.getIdIccid();
		long custId=inDto.getCustId();
		long unitId=inDto.getUnitId();
		String unitIdStr = String.valueOf(unitId);
		String custIdStr = String.valueOf(custId);
		String iccIdStr = String.valueOf(iccId);
		if(unitIdStr.equals("0")){
			unitIdStr = null;
		}
		if(custIdStr.equals("0")){
			custIdStr = null;
		}
		if(iccIdStr.equals("0")){
			iccIdStr = null;
		}

		// 根据unit_id查询集团账户
		long contractNo=0;
		long idNo=0;
		String regionName="";
		String groupId="";
		String brandName="";
		String groupCode="";
		String goodsName="";
		String groupNo = "";
		List<GroupUserInfo> userInfoList = new ArrayList<GroupUserInfo>();

		List<GroupUserInfo> userInfoListTmp = user.getGrpInfo(iccIdStr,custIdStr,unitIdStr,null);
		
		for (GroupUserInfo groupUserInfo : userInfoListTmp) {
			
			contractNo = groupUserInfo.getContractNo();
			idNo=groupUserInfo.getIdNo();
			custId=groupUserInfo.getCustId();
			groupId=groupUserInfo.getGroupId();
			unitId =groupUserInfo.getUnitID();
			iccIdStr = groupUserInfo.getIccId();

			//查询产品名称
			goodsName=prod.getUserPrcidInfo(idNo,true).getProdPrcid();

			//查询品牌名称
			UserBrandEntity userBrand=user.getUserBrandRel(idNo);
			brandName=userBrand.getBrandName();

			//取归属d地区
			regionName=group.getRegionDistinct(groupId,null,inDto.getProvinceId()).getRegionName();
			
			//取集团信息
			Map<String,Object> userInfoListTmp2 = new HashMap<String,Object>();
			
			userInfoListTmp2 = (Map<String, Object>) user.getUrGrpInfo(idNo);
			String groupName = (String)userInfoListTmp2.get("GROUP_NAME");
			groupNo = (userInfoListTmp2.get("GROUP_ID")).toString();
			System.out.println(groupNo);
			groupCode = (String)userInfoListTmp2.get("GROUP_CODE");
			if(groupCode == null){
				groupCode = groupNo;
			}

			GroupUserInfo userInfoTmp=new GroupUserInfo();
			userInfoTmp.setUnitID(unitId);
			userInfoTmp.setCustId(custId);
			userInfoTmp.setContractNo(contractNo);
			userInfoTmp.setIdNo(idNo);
			userInfoTmp.setGoodsName(goodsName);
			userInfoTmp.setGroupCode(groupCode);
			userInfoTmp.setGroupName(groupName);
			userInfoTmp.setIccId(iccIdStr);
			userInfoTmp.setBrandName(brandName);
			userInfoTmp.setRegionName(regionName);
			userInfoList.add(userInfoTmp);
			
			
			
		}


		S8295InitOutDto outDto=new S8295InitOutDto();
		outDto.setCnt(userInfoListTmp.size());
		outDto.setUserList(userInfoList);

		log.debug("S8295InitOutDto->"+outDto.toJson());
		return outDto;
	}
	 
	public OutDTO cfm(InDTO inParam) throws IOException {

		Map<String, Object> inForMap = new HashMap<String, Object>();
		Map<String, Object> outForMap = new HashMap<String, Object>();

		S8295CfmInDTO inDto = (S8295CfmInDTO) inParam;
		log.error("S8295CfmInDTO->"+inDto.getMbean());
		
		String opCode= inDto.getOpCode();
		String loginNo= inDto.getLoginNo();
		String groupId= inDto.getGroupId();
		String inFilePath = inDto.getRelPath();
		String remark=inDto.getRemark();
		long groupCon = inDto.getGroupContractNo();
		String groupProductName=inDto.getGroupProductName();
		log.debug("groupProductName->"+groupProductName);

		ChngroupRelEntity groupRelEntity = group.getRegionDistinct(inDto.getGroupId(), "2", inDto.getProvinceId());
		String regionCode = groupRelEntity.getRegionCode();
		
		String phoneTmp ="";

		//获取时间
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String totalDate = curTime.substring(0, 8);
		
		//获取批次流水lBatchSn
		long batchSn =  control.getSequence("SEQ_SYSTEM_SN");
		
		//限制重复号码
		List<String> phoneList = new ArrayList<String>();
		
		//读取&下载 动态表单上传的文件
		String fileName="";
		String enCode=" ";

		try {
			outForMap=FtpUtils.download(inFilePath);
			fileName=outForMap.get("FILENAME").toString();
			enCode=outForMap.get("ENCODE").toString();
		} catch (Exception e) {
			e.printStackTrace();
			throw new BaseException(AcctMgrError.getErrorCode("8295", "00006"),"读取上传文件失败，请检查批量缴费文件上传主机是否正常！");
		}
		log.debug("fileName->"+fileName);
		log.debug("enCode->"+enCode);

		//上传文件不能为空
		InputStreamReader isr_pre1 =null;
		BufferedReader br_re1 = null;
		try{
			isr_pre1 = new InputStreamReader(new FileInputStream(fileName), enCode);
			br_re1  =new BufferedReader(isr_pre1);
			if (br_re1.readLine() == null) {
				throw new BaseException(AcctMgrError.getErrorCode("8295", "00007"),"上传文件不能为空！");
			}
		}catch(Exception e){
			e.printStackTrace();
			throw new BaseException(AcctMgrError.getErrorCode("8295", "00007"),"上传文件不能为空！");
		}finally {
			try {
				if (br_re1 != null) {
					br_re1.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		int iCount=0;
		long totalFee = 0;
		InputStreamReader isr_pre2 =null;
		BufferedReader br_pre2 = null;
		int checkFlag = 0;
		try{
			isr_pre2 = new InputStreamReader(new FileInputStream(fileName), enCode);
			br_pre2  =new BufferedReader(isr_pre2);
			String lineStr =null;
			while ( (lineStr=br_pre2.readLine()) != null ) {

				String phoneNo =  StringUtils.split(lineStr, "|")[0].trim();
				String strPayFee = StringUtils.split(lineStr, "|")[1].trim();
				long payFee =    Math.round(Double.parseDouble(strPayFee)*100);

				if( payFee<0 ){
					checkFlag = 1;
					throw new BaseException(AcctMgrError.getErrorCode("8295", "00004"),"缴费金额范围不正确，请核查数据!");
				}
				
				if(iCount>200){
					checkFlag = 2;
					throw new BaseException(AcctMgrError.getErrorCode("8295", "00002"),"缴费号码每次只能小于等于200个，否则不能批量缴费!");
				}
				
				if (phoneList.contains(phoneNo)) {
					checkFlag = 3;
					phoneTmp = phoneNo;
					throw new BusiException(AcctMgrError.getErrorCode("8295","00003"), "文件中包含重复号码，请核查数据");
				} else {
					phoneList.add(phoneNo);
				}
				
				iCount=iCount+1;
				totalFee+=payFee;
			}

		}catch(Exception e){
			e.printStackTrace();
			if (checkFlag==1){
				throw new BaseException(AcctMgrError.getErrorCode("8295", "00004"),"缴费金额范围不正确，请核查数据!");
			}else if(checkFlag==2){
				throw new BaseException(AcctMgrError.getErrorCode("8295", "00002"),"缴费号码每次只能小于等于200个，否则不能批量缴费!");
			}else if(checkFlag==3){
				throw new BaseException(AcctMgrError.getErrorCode("8295", "00003"),"文件中包含重复号码，请核查数据,[" + phoneTmp + "]");
			}else{
				throw new BaseException(AcctMgrError.getErrorCode("8295", "00005"),"读取上传文件失败，没有以“|”分割！");
			}
		}finally {
			try {
				if (br_pre2 != null) {
					br_pre2.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		//循环处理文件
		int iSucc =0;
		long totalSucc=0;
		long paySn = control.getSequence("SEQ_PAY_SN");
		BufferedReader br_fee = null;
		try{
			String lineStr_fee =null;
			InputStreamReader  isr_fee = new InputStreamReader(new FileInputStream(fileName), enCode);
			br_fee  =new BufferedReader(isr_fee);
			while ( (lineStr_fee=br_fee.readLine()) != null ) {
				//打印每行
				lineStr_fee.trim();

				Map<String, Object>inPayMap=new HashMap<String, Object>();
				Map<String, Object>outPayMap=new HashMap<String, Object>();

				//循环处理文件每一行数据
				String phoneNo="";
				String strPayFee ="";
				long   payFee = 0;

				phoneNo =  StringUtils.split(lineStr_fee, "|")[0].trim();
				strPayFee = StringUtils.split(lineStr_fee, "|")[1].trim();
				payFee =    Math.round(Double.parseDouble(strPayFee)*100);

				inPayMap=new HashMap<String, Object>();
				safeAddToMap(inPayMap, "TOTAL_DATE", totalDate);
				safeAddToMap(inPayMap, "OP_CODE", opCode);
				safeAddToMap(inPayMap, "PHONE_NO", phoneNo);
				safeAddToMap(inPayMap, "CONTRACT_NO", 0L);
				safeAddToMap(inPayMap, "LOGIN_NO", loginNo);
				safeAddToMap(inPayMap, "GROUP_CONTRACT_NO", groupCon);
				safeAddToMap(inPayMap, "GROUP_PRODUCT_NAME",groupProductName);
				safeAddToMap(inPayMap, "FILE_NAME", fileName);
				safeAddToMap(inPayMap, "IMPORT_BATCH_SN", paySn);
				safeAddToMap(inPayMap, "PAY_MONEY", payFee);
				record.saveGroupChargeRecd(inPayMap);

				phoneTmp = phoneNo;
				
			}//遍历节点结束
		}catch(Exception e){
			e.printStackTrace();
			throw new BaseException(AcctMgrError.getErrorCode("0000", "00073"),e.getMessage().substring(0,200));
		}finally {
			//关闭流
			try {
				if (br_fee != null) {
					br_fee.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		//统一日志
		LoginOprEntity in = new LoginOprEntity();
		in.setIdNo(0);
		in.setPhoneNo(phoneTmp);
		in.setPayType("0");
		in.setPayFee(0);
		in.setLoginSn(batchSn);
		in.setLoginNo(inDto.getLoginNo());
		in.setLoginGroup(inDto.getGroupId());
		in.setOpCode(inDto.getOpCode());
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
		safeAddToMap(inForMap,"CUST_ID_TYPE","1");
		safeAddToMap(inForMap,"CUST_ID_VALUE",phoneTmp);
		safeAddToMap(inForMap,"OP_TIME",curTime);
		preOrder.sendOprCntt(inForMap);

		S8295CfmOutDTO outParamDto = new S8295CfmOutDTO();
		outParamDto.setTotalFee(totalFee);
		outParamDto.setTotalNum(iCount);
		outParamDto.setBatchSn(batchSn);

		log.error("S8295CfmOutDTO->" + outParamDto.toJson());
		return outParamDto;
	}



	/**
	 * @param record the record to set
	 */
	public void setRecord(IRecord record) {
		this.record = record;
	}

	/**
	 * @param control the control to set
	 */
	public void setControl(IControl control) {
		this.control = control;
	}

	/**
	 * @param user the user to set
	 */
	public void setUser(IUser user) {
		this.user = user;
	}

	/**
	 * @param group the group to set
	 */
	public void setGroup(IGroup group) {
		this.group = group;
	}

	/**
	 * @param preOrder the preOrder to set
	 */
	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}

	/**
	 * @param balance the balance to set
	 */
	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	/**
	 * @return the prod
	 */
	public IProd getProd() {
		return prod;
	}

	/**
	 * @param prod the prod to set
	 */
	public void setProd(IProd prod) {
		this.prod = prod;
	}
	

}
