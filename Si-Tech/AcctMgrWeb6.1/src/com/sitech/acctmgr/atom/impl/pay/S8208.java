package com.sitech.acctmgr.atom.impl.pay;

import com.alibaba.fastjson.JSON;
import com.sitech.acctmgr.atom.busi.pay.inter.IPreOrder;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.bill.BillEntity;
import com.sitech.acctmgr.atom.domains.pay.BatchPayRecdEntity;
import com.sitech.acctmgr.atom.domains.pay.GiveInfoEntity;
import com.sitech.acctmgr.atom.domains.record.LoginOprEntity;
import com.sitech.acctmgr.atom.domains.user.UserDetailEntity;
import com.sitech.acctmgr.atom.domains.user.UserInfoEntity;
import com.sitech.acctmgr.atom.dto.pay.*;
import com.sitech.acctmgr.atom.entity.inter.*;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.utils.FtpUtils;
import com.sitech.acctmgr.common.constant.PayBusiConst;
import com.sitech.acctmgr.inter.pay.I8208;
import com.sitech.common.utils.StringUtils;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.apache.commons.collections.MapUtils.safeAddToMap;

@ParamTypes({
	@ParamType(c=S8208CfmInDTO.class,oc=S8208CfmOutDTO.class,m="cfm"),
	@ParamType(c=S8208AuditQryInDTO.class,oc=S8208AuditQryOutDTO.class,m="auditQry"),
	@ParamType(c=S8208AuditInDTO.class,oc=S8208AuditOutDTO.class,m="audit"),
	@ParamType(c=S8208AuditInDTO.class,oc=S8208AuditOutDTO.class,m="send"),
	@ParamType(c=S8208DetailInDTO.class,oc=S8208DetailOutDTO.class,m="detail")
})
public class S8208 extends AcctMgrBaseService implements I8208 {

	protected IRecord 	record;
	protected IControl 	control;
	protected IUser 	user;
	protected IGroup 	group;
	protected IPreOrder preOrder;
	protected IBalance 	balance;
	protected IBill bill;
	
	
	public OutDTO cfm(InDTO inParam) {

		Map<String, Object> inForMap = new HashMap<String, Object>();
		Map<String, Object> outForMap = new HashMap<String, Object>();

		// 调用S8011CfmInDTO 获取入参
		S8208CfmInDTO inDto = (S8208CfmInDTO) inParam;
		
		log.error("------> 8208cfm_in" + inDto.getMbean());

		// 获取时间
		String curTime = control.getSysDate().get("CUR_TIME").toString();
		String curYm = curTime.substring(0, 6);
		String totalDate = curTime.substring(0, 8);
		
		ChngroupRelEntity groupRelEntity = group.getRegionDistinct(inDto.getGroupId(), "2", inDto.getProvinceId());
		String LoginRegionCode = groupRelEntity.getRegionCode();
		
		// 获取批次流水lBatchSn
		long batchSn = control.getSequence("SEQ_SYSTEM_SN");

		// 读取&下载 动态表单上传的文件
		String fileName = "";
		String enCode = "";
		try {
			outForMap = FtpUtils.download(inDto.getRelPath());
			fileName = outForMap.get("FILENAME").toString();
			enCode = outForMap.get("ENCODE").toString();
		} catch (Exception e) {
			e.printStackTrace();
			throw new BusiException(AcctMgrError.getErrorCode("8208", "00001"),
					"读取上传文件失败，请检查批量缴费文件上传主机是否正常！");
		}
		log.error("------>fileName=" + fileName);
		log.error("------>enCode" + enCode);

		// 上传文件不能为空
		InputStreamReader isr_pre1 = null;
		BufferedReader br_pre1 = null;
		try {
			isr_pre1 = new InputStreamReader(new FileInputStream(fileName),enCode);
			br_pre1 = new BufferedReader(isr_pre1);
			if (br_pre1.readLine() == null) {
				throw new BusiException(AcctMgrError.getErrorCode("8208","00002"), "上传文件不能为空！");
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new BusiException(AcctMgrError.getErrorCode("8208", "00002"),"上传文件不能为空！");
		} finally {
			try {
				if (br_pre1 != null) {
					br_pre1.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		// 号码重复次数 单个号码金额 总号码数
		String phoneTmp = "";
		long idNoTmp = 0;
		
		// N 未处理 Y审核通过 X审核不通过 S赠送 C取消赠送 F赠送成功 E失败用户 K跨库用户
		String auditFlag = "N";
		if(inDto.getSendType().equals("A")){		//A:表示一次性赠送,不需要审核
			
			auditFlag = "Y";
		}

		// 循环记录赠费中间表
		int totalNum = 0;
		long totalFee = 0;
		InputStreamReader isr_pre2 = null;
		BufferedReader br_pre2 = null;
		int checkFlag = 0;
		List<String> phoneList = new ArrayList<String>();
		String phoneNo ="";
		String dealType = "";
		try {
			isr_pre2 = new InputStreamReader(new FileInputStream(fileName),enCode);
			br_pre2 = new BufferedReader(isr_pre2);
			String lineStr = null;
			while ((lineStr = br_pre2.readLine()) != null) {
				log.debug("--->readLine =" + totalNum + ", lineStr=" + lineStr);

				if(lineStr.matches("\\s*")){
                	checkFlag =10;
                	log.error("文件中出现了空行");
                	throw new BusiException(AcctMgrError.getErrorCode("8208", "00023"),"文件中不能有空行!");
                }
				
				phoneNo = StringUtils.split(lineStr, " ")[0].trim();
				try{
					UserInfoEntity userInfo =  user.getUserEntityAllDb(null, phoneNo, null, true);
				}catch(Exception e){
					e.printStackTrace();
					checkFlag = 11 ;
					throw new BusiException(AcctMgrError.getErrorCode("8208", "00024"),"号码不存在!phoneNo:"+phoneNo );
				}
				
				long contractNo = Long.parseLong(StringUtils.split(lineStr, " ")[1].trim());
				String strPayFee = StringUtils.split(lineStr, " ")[2].trim();
				
				dealType = StringUtils.split(lineStr, " ")[3].trim();
				String codeValue = control.getPubCodeValue(2509, dealType ,null, false);
				if(codeValue == null){
					checkFlag = 9;
					throw new BusiException(AcctMgrError.getErrorCode("8208","00009"), "送费类型不存在[" + dealType + "]]");
				}
				
				long payFee = Math.round(Double.parseDouble(strPayFee) * 100);
				if (phoneList.contains(phoneNo)) {

					checkFlag = 4;
					phoneTmp = phoneNo;
					throw new BusiException(AcctMgrError.getErrorCode("8208",
							"00003"), "文件中包含重复号码，请核查数据" + phoneNo);
				} else {

					phoneList.add(phoneNo);
				}

				if (payFee <= 0 || payFee > 300 * 100) {
					checkFlag = 1;
					throw new BusiException(AcctMgrError.getErrorCode("8208",
							"00020"), "缴费金额范围不正确，请核查数据!");
				}
				if (totalNum > 10000) {
					checkFlag = 2;
					throw new BusiException(AcctMgrError.getErrorCode("8208",
							"00021"), "赠费号码超过10000个！不能批量赠费");
				}
				
				//添加校验如果存在隔月欠费则不允许缴费
				if(isOweFee(phoneNo ,contractNo)){
					checkFlag = 7 ; 
					 throw new BusiException(AcctMgrError.getErrorCode("8208",
							"00010"),"服务号码："+phoneNo+"隔月欠费不允许办理业务");
				}
				

				totalNum++;
				totalFee = totalFee + payFee;
			}
		} catch (Exception e) {
			e.printStackTrace();
			if (checkFlag == 1) {
				throw new BusiException(AcctMgrError.getErrorCode("8208",
						"00020"), "服务号码："+phoneNo+"缴费金额范围不正确，请核查数据!");
			} else if (checkFlag == 2) {
				throw new BusiException(AcctMgrError.getErrorCode("8208",
						"00021"), "赠费号码超过10000个！不能批量赠费");
			} else if (checkFlag == 3) {
				throw new BusiException(AcctMgrError.getErrorCode("8054",
						"00022"), "不能跨地市缴费[" + phoneTmp + "]]");
			} else if (checkFlag == 4) {
				throw new BusiException(AcctMgrError.getErrorCode("8208",
						"00003"), "文件中包含重复号码，请核查数据,[" + phoneTmp + "]");
			}else if (checkFlag == 9) {
				throw new BusiException(AcctMgrError.getErrorCode("8208",
						"00009"), "文件中送费类型不正确，请核查数据");
			}else if(checkFlag == 7){
				 throw new BusiException(AcctMgrError.getErrorCode("8208",
						 "00010"),"服务号码："+phoneNo+"隔月欠费不允许办理业务");
			}else if(checkFlag == 10){
				 throw new BusiException(AcctMgrError.getErrorCode("8208",
						 "000023"),"文件中不能有空行!");
			}else if(checkFlag == 11){
				 throw new BusiException(AcctMgrError.getErrorCode("8208",
						 "000024"),"号码不存在!phoneNo:" + phoneNo);
			}else {
				throw new BusiException(AcctMgrError.getErrorCode("8208","00008"), "文件读取失败，请核查上传文件格式！");
			}

		} finally {
			try {
				if (br_pre2 != null) {
					br_pre2.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		// 循环处理文件
		int setialNo = 0;
		int validNum = 0;
		long validFee = 0;
		BufferedReader br_fee = null;
		String lineStr_fee = null;

		try {
			
			InputStreamReader isr_fee = new InputStreamReader(new FileInputStream(fileName), enCode);
			br_fee = new BufferedReader(isr_fee);
			while ((lineStr_fee = br_fee.readLine()) != null) {
				// 打印每行
				log.debug("--->readLine_setialNo =" + setialNo+ ", lineStr_fee=" + lineStr_fee);
				lineStr_fee.trim();

				Map<String, Object> inPayMap = new HashMap<String, Object>();
				Map<String, Object> outPayMap = new HashMap<String, Object>();

				
				// 循环处理文件每一行数据
				phoneNo = StringUtils.split(lineStr_fee, " ")[0].trim();
				long contractNo = Long.parseLong(StringUtils.split(lineStr_fee, " ")[1].trim());
				String strPayFee = StringUtils.split(lineStr_fee, " ")[2].trim();
				long payFee = Math.round(Double.parseDouble(strPayFee) * 100);

				long paySn = control.getSequence("SEQ_SYSTEM_SN");

				long idNo = 0;
				String opType = "0"; //默认赠费
				// 查询当前用户
				UserInfoEntity userEntity = user.getUserEntityAllDb(null, phoneNo, null, false);
				if (contractNo == 0) {
					contractNo = userEntity.getContractNo();
				}
				idNo = userEntity.getIdNo();
				if (userEntity == null) {
					log.error("------->查询用户失败 phoneNo=" + phoneNo);
					opType = "E";  //用户不存在为 E
				}
				
				ChngroupRelEntity userGroupRelEntity = group.getRegionDistinct(userEntity.getGroupId(), "2", inDto.getProvinceId());
				String userRegionCode = userGroupRelEntity.getRegionCode();
				if(!LoginRegionCode.equals(userRegionCode)){
					checkFlag = 5;
					phoneTmp = phoneNo;
					throw new BusiException(AcctMgrError.getErrorCode("8208","00006"), "不能跨地市赠费[" + phoneNo + "]]");
				}
				
				UserDetailEntity  userDetailEntity = user.getUserdetailEntity(idNo);
				if("ABCGHOD".indexOf(userDetailEntity.getRunCode()) == -1){
					checkFlag = 6;
					phoneTmp = phoneNo;
					throw new BusiException(AcctMgrError.getErrorCode("8208","00007"), "用户状态异常[" + phoneNo + "]]");
				}

				// 插入赠费明细
				inPayMap = new HashMap<String, Object>();
				safeAddToMap(inPayMap, "BATCH_SN", paySn);
				safeAddToMap(inPayMap, "ACT_TYPE", 'B');
				safeAddToMap(inPayMap, "ACT_ID", "0");
				safeAddToMap(inPayMap, "ACT_SN", batchSn);
				safeAddToMap(inPayMap, "PHONE_NO", phoneNo);
				safeAddToMap(inPayMap, "ID_NO", idNo);
				safeAddToMap(inPayMap, "REGION_CODE", LoginRegionCode);
				safeAddToMap(inPayMap, "CONTRACT_NO", contractNo);
				safeAddToMap(inPayMap, "AUDIT_FLAG", auditFlag);
				safeAddToMap(inPayMap, "TOTAL_DATE", totalDate);
				safeAddToMap(inPayMap, "OP_TYPE", opType);
				safeAddToMap(inPayMap, "PAY_TYPE", inDto.getPayType());
				safeAddToMap(inPayMap, "PAY_FEE", payFee);
				safeAddToMap(inPayMap, "PAY_SN", paySn);
				safeAddToMap(inPayMap, "SMS_FLAG", "2");
				safeAddToMap(inPayMap, "LOGIN_NO", inDto.getLoginNo());
				safeAddToMap(inPayMap, "REMARK", inDto.getRemark());
				safeAddToMap(inPayMap, "BEGIN_TIME", inDto.getSendDate() + "010000");
				safeAddToMap(inPayMap, "END_TIME", PayBusiConst.END_TIME2);
				safeAddToMap(inPayMap, "FOREIGN_SN", paySn);
				safeAddToMap(inPayMap, "OP_CODE", inDto.getOpCode());
				safeAddToMap(inPayMap, "YEAR_MONTH", curYm);
				safeAddToMap(inPayMap, "PAY_FLAG", "0");
				safeAddToMap(inPayMap, "PAY_COMMENT", "8208营销话费赠送");
				log.info("qiaolin:" + inDto.getUserPhone());
				safeAddToMap(inPayMap, "USER_PHONE", inDto.getUserPhone());
				safeAddToMap(inPayMap, "FOREIGN_SN", String.valueOf(batchSn));
				balance.saveBatchPayMid(inPayMap);

				setialNo++;
				if ("0".equals(opType)) {
					validNum++;
					validFee = validFee + payFee;
					phoneTmp = phoneNo;
					idNoTmp = idNo;
				}
				log.debug("------------> lPaySn= " + paySn + ",setialNo="+ setialNo);
			
			log.info("------------ end 遍历节点结束,totalFee=" + totalFee
					+ ",totalNum=" + totalNum);
			}// 遍历节点结束
		} catch (Exception e) {
			e.printStackTrace();
			
			if (checkFlag == 5) {
				throw new BusiException(AcctMgrError.getErrorCode("8208","00006"), "不能跨地市赠费[" + phoneTmp + "]]");
			} else if (checkFlag == 6) {
				throw new BusiException(AcctMgrError.getErrorCode("8208","00007"), "用户状态异常[" + phoneTmp + "]]");
			}
		} finally {
			// 关闭流
			try {
				if (br_fee != null) {
					br_fee.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		// 记录赠送总表
		inForMap = new HashMap<String, Object>();
		inForMap.put("REGION_ID", LoginRegionCode);
		inForMap.put("ACT_ID", "0");
		inForMap.put("BATCH_SN", batchSn);
		inForMap.put("ACT_TYPE", "B");
		inForMap.put("MEANS_ID", "");
		inForMap.put("ACT_NAME", inDto.getActName());
		inForMap.put("SEND_DATE", inDto.getSendDate());
		inForMap.put("SMS_FLAG", inDto.getSmsFlag());
		inForMap.put("SEND_MONTH", inDto.getSendMonth());
		inForMap.put("YEAR_MONTH", curYm);
		inForMap.put("LOGIN_NO", inDto.getLoginNo());
		inForMap.put("OP_CODE", inDto.getOpCode());
		inForMap.put("OP_NOTE", inDto.getRemark());
		inForMap.put("FILE_NAME", fileName);
		inForMap.put("AUDIT_FLAG", auditFlag);
		inForMap.put("TOTAL_NUM", totalNum);
		inForMap.put("INVALID_NUM", validNum);
		inForMap.put("TOTAL_FEE", totalFee);
		inForMap.put("INVALID_FEE", validFee);
		inForMap.put("USER_PHONE", inDto.getUserPhone());
		balance.saveBatchPayRecd(inForMap);

		//营业员操作日志
		LoginOprEntity in = new LoginOprEntity();
		in.setIdNo(idNoTmp);
		in.setPhoneNo(phoneTmp);
		in.setPayType(inDto.getPayType());
		in.setPayFee(totalFee);
		in.setLoginSn(batchSn);
		in.setLoginNo(inDto.getLoginNo());
		in.setLoginGroup(inDto.getGroupId());
		in.setOpCode(inDto.getOpCode());
		in.setTotalDate(Long.parseLong(totalDate));
		in.setRemark(inDto.getOpCode());
		record.saveLoginOpr(in);

		// 发送统一接触消息
		inForMap = new HashMap<String, Object>();
		safeAddToMap(inForMap, "Header", inDto.getHeader());
		safeAddToMap(inForMap, "PAY_SN", batchSn);
		safeAddToMap(inForMap, "LOGIN_NO", inDto.getLoginNo());
		safeAddToMap(inForMap, "GROUP_ID", inDto.getGroupId());
		safeAddToMap(inForMap, "OP_CODE", inDto.getOpCode());
		safeAddToMap(inForMap, "REGION_ID", LoginRegionCode);
		safeAddToMap(inForMap, "OP_NOTE", "8208批量赠费");
		safeAddToMap(inForMap, "CUST_ID_TYPE", "1");
		safeAddToMap(inForMap, "CUST_ID_VALUE", "99999999999");
		safeAddToMap(inForMap, "OP_TIME", curTime);
		safeAddToMap(inForMap, "TOTAL_FEE", totalFee);
		preOrder.sendOprCntt(inForMap);

		S8208CfmOutDTO outParamDto = new S8208CfmOutDTO();
		outParamDto.setTotalFee(totalFee);
		outParamDto.setValidFee(validFee);
		outParamDto.setTotalNum(totalNum);
		outParamDto.setValidNum(validNum);
		outParamDto.setBatchSn(batchSn);

		log.error("------> 8208cfm_out" + outParamDto.toJson());
		return outParamDto;
	}

	/*
	 * 审批查询：查询所有导入成功的记录（audit=N 或所有记录 A）
	 */
	public OutDTO auditQry(InDTO inParam) {

		Map<String, Object> inAuditMap = new HashMap<String, Object>();

		S8208AuditQryInDTO inDto = (S8208AuditQryInDTO) inParam;
		log.error("-------> auditQry_in " + inDto.getMbean());
		
		String inFlag = inDto.getQryFlag().trim();
		String[] qryFlagS = null;
		if ("N".equals(inFlag)) { // 审核：查询所有导入记录
			qryFlagS = new String[]{"N"};
		} else if ("A".equals(inFlag)) { // 查询：查询工号指定日期内的导入记录
			qryFlagS = new String[]{"N","Y","X","S","C","F","B"};
		}
		log.error("------> qryFlag =" + inFlag + ",qryFlagS = " + qryFlagS);

		// 查询所有未审批带入记录(默认查询所有未审核记录)
		inAuditMap = new HashMap<String, Object>();
		safeAddToMap(inAuditMap, "AUDIT_FLAG", qryFlagS);
		safeAddToMap(inAuditMap, "ACT_TYPE", "B");
		if ("A".equals(inFlag)) {
			safeAddToMap(inAuditMap, "BEGIN_DATE", inDto.getBeginDate());
			safeAddToMap(inAuditMap, "END_DATE", inDto.getEndDate());
			safeAddToMap(inAuditMap, "LOGIN_NO", inDto.getLoginNo());
		}
		
		//地市工号只能看见本地市的导入记录
		if (!inDto.getLoginNo().substring(0, 2).equals("ss")){
			
			ChngroupRelEntity groupRelEntity = group.getRegionDistinct(inDto.getGroupId(), "2", inDto.getProvinceId());
			String regionCode = groupRelEntity.getRegionCode();
			safeAddToMap(inAuditMap, "REGION_CODE", regionCode);
		}

		List<BatchPayRecdEntity> batchpayList = balance.getBatchpayRecd(inAuditMap, inFlag);
		log.info("------>listMap " + batchpayList.toString());

		long loginAccept = control.getSequence("SEQ_SIGN_ID");
		String sCurDate = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		
		//记录营业员操作日志
		LoginOprEntity in = new LoginOprEntity();
		in.setPhoneNo("");
		in.setPayType("");
		in.setPayFee(0);
		in.setLoginSn(loginAccept);
		in.setLoginNo(inDto.getLoginNo());
		in.setLoginGroup(inDto.getGroupId());
		in.setOpCode(inDto.getOpCode());
		in.setTotalDate(Long.parseLong(sCurDate.substring(0, 8)));
		in.setRemark("8208 查询批量缴费记录");
		record.saveLoginOpr(in);
	
		S8208AuditQryOutDTO outDto = new S8208AuditQryOutDTO();
		outDto.setSendList(batchpayList);
		outDto.setGiveSize(batchpayList.size());
		
		log.error("------> auditQry_out" + outDto.toJson());

		return outDto;
	}

	
	public OutDTO audit(InDTO inParam) {
		
		Map<String, Object> inAuditMap = new HashMap<String, Object>();

		S8208AuditInDTO inDto = (S8208AuditInDTO) inParam;
		log.error("-------> auditCfm_in " + inDto.getMbean());

		// 判断工号是否有审批权限
		ChngroupRelEntity groupRelEntity = group.getRegionDistinct(inDto.getGroupId(), "2", inDto.getProvinceId());
		String regionCode = groupRelEntity.getRegionCode();
		String loginNos = control.getPubCodeValue(2018, "AUDIT_LOGIN", regionCode);
		if (loginNos.indexOf(inDto.getLoginNo()) == -1) {
			throw new BusiException(AcctMgrError.getErrorCode("8208", "00002"),
					"您的工号没有审批权限，请联系管理员配置！");
		}

		// 更改明细
		inAuditMap = new HashMap<String, Object>();
		safeAddToMap(inAuditMap, "ACT_SN", inDto.getBatchSn());
		safeAddToMap(inAuditMap, "AUDIT_FLAG", inDto.getAuditFlag());
		safeAddToMap(inAuditMap, "OLD_AUDIT_FLAG", "N");
		balance.updateBatchPayMid(inAuditMap);

		// 更改总记录
		inAuditMap = new HashMap<String, Object>();
		safeAddToMap(inAuditMap, "BATCH_SN", inDto.getBatchSn());
		safeAddToMap(inAuditMap, "AUDIT_FLAG", inDto.getAuditFlag());
		safeAddToMap(inAuditMap, "OLD_AUDIT_FLAG", "N");
		safeAddToMap(inAuditMap, "AUDIT_LOGIN", inDto.getLoginNo());
		safeAddToMap(inAuditMap, "AUDIT_DESC", inDto.getAuditDesc());
		balance.updateBatchPayRecd(inAuditMap);

		S8208AuditOutDTO outParamDto = new S8208AuditOutDTO();
		outParamDto.setBatchSn(inDto.getBatchSn());
		log.error("------> auditCfm_out" + outParamDto.toJson());
		return outParamDto;
	}


	public OutDTO send(InDTO inParam) {
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
		Map<String, Object> inAuditMap = new HashMap<String, Object>();
		Map<String, Object> outAuditMap = new HashMap<String, Object>();

		S8208AuditInDTO inParamDto = (S8208AuditInDTO) inParam;
		log.error("-------> auditCfm_in " + inParamDto.getMbean());
		long batchSn = inParamDto.getBatchSn();
		String auditFlag = inParamDto.getAuditFlag();
		String auditNote = inParamDto.getAuditDesc();
		String loginNo = inParamDto.getLoginNo();

		// 审批之后才能赠送

		// 更改明细
		inAuditMap = new HashMap<String, Object>();
		safeAddToMap(inAuditMap, "ACT_SN", batchSn);
		safeAddToMap(inAuditMap, "AUDIT_FLAG", auditFlag);
		safeAddToMap(inAuditMap, "OLD_AUDIT_FLAG", "Y");
		balance.updateBatchPayMid(inAuditMap);

		// 更改总记录
		inAuditMap = new HashMap<String, Object>();
		safeAddToMap(inAuditMap, "BATCH_SN", batchSn);
		safeAddToMap(inAuditMap, "AUDIT_FLAG", auditFlag);
		safeAddToMap(inAuditMap, "OLD_AUDIT_FLAG", "Y");
		safeAddToMap(inAuditMap, "AUDIT_LOGIN", loginNo);
		safeAddToMap(inAuditMap, "AUDIT_DESC", auditNote);
		balance.updateBatchPayRecd(inAuditMap);

		S8208AuditOutDTO outParamDto = new S8208AuditOutDTO();
		outParamDto.setBatchSn(batchSn);
		log.error("------> auditCfm_out" + outParamDto.toJson());
		return outParamDto;
	}

	public OutDTO detail(InDTO inParam) { 
		// TODO Auto-generated method stub

		Map<String, Object> inDetailMap = new HashMap<String, Object>();
		// Map<String, Object> outAuditMap = new HashMap<String, Object>();

		S8208DetailInDTO inParamDto = (S8208DetailInDTO) inParam;
		log.error("-------> detail_in " + inParamDto.getMbean());
		String qryDate = inParamDto.getInputTime();
		long batchSn = inParamDto.getBatchSn();

		// 查询选中批次的明细（成功和失败记录）

		// 查询所有未审批带入记录
		inDetailMap = new HashMap<String, Object>();
		safeAddToMap(inDetailMap, "ACT_SN", batchSn);
		safeAddToMap(inDetailMap, "OP_YM", qryDate.substring(0, 6));
		List<Map<String, Object>> listMap = balance.getBatchPayMid(inDetailMap);

		log.error("------>listMap " + listMap.toString());

		List<GiveInfoEntity> listSucc = new ArrayList<GiveInfoEntity>();
		List<GiveInfoEntity> listErr = new ArrayList<GiveInfoEntity>();

		for (Map<String, Object> map : listMap) {
			String auditName = "";
			String auditFlag = map.get("AUDIT_FLAG").toString().trim();
			if ("E".equals(auditFlag)) {
				auditName = "失败";
				map.put("AUDIT_NAME", auditName);
				String jsonFee = JSON.toJSONString(map);
				listErr.add(JSON.parseObject(jsonFee, GiveInfoEntity.class));
			} else {
				auditName = "成功";
				map.put("AUDIT_NAME", auditName);
				String jsonFee = JSON.toJSONString(map);
				listSucc.add(JSON.parseObject(jsonFee, GiveInfoEntity.class));
			}
		}

		long loginAccept = control.getSequence("SEQ_SIGN_ID");
		String sCurDate = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		
		//记录营业员操作日志
		LoginOprEntity in = new LoginOprEntity();
		in.setPayType("");
		in.setPayFee(0);
		in.setLoginSn(loginAccept);
		in.setLoginNo(inParamDto.getLoginNo());
		in.setLoginGroup(inParamDto.getGroupId());
		in.setOpCode(inParamDto.getOpCode());
		in.setTotalDate(Long.parseLong(sCurDate.substring(0, 8)));
		in.setRemark("8208 查询批量缴费详细信息");
		record.saveLoginOpr(in);
		
		S8208DetailOutDTO outParamDto = new S8208DetailOutDTO();
		outParamDto.setListGiveSucc(listSucc);
		outParamDto.setGiveSuccSize(listSucc.size());
		outParamDto.setListGiveErr(listErr);
		outParamDto.setGiveErrSize(listErr.size());
		log.error("------> detail_out" + outParamDto.toJson());
		return outParamDto;
	}	
	
	private  boolean isOweFee(String phoneNo,long contractNo){	
		
		
		List<BillEntity> list = new ArrayList<>();
		if(contractNo == 0 ){
			UserInfoEntity userEntity = user.getUserEntity(null, phoneNo, null, false);
			list =  bill.getUnpayOweOnBillCycle(userEntity.getContractNo(), userEntity.getIdNo());
		}else {
			list =  bill.getUnpayOweOnBillCycle(contractNo,null);
		}
		
		if(list == null || list.size() == 0 ){
			return false;
		}else {
			// 获取当前系统时间
			String sCurDate = DateUtil.format(new Date(), "yyyyMMddHHmmss");
			String sCurYm = sCurDate.substring(0, 6);
			
			log.info("hanfule排序前:"+list.toString());
			Collections.sort(list, new BillComp());
			log.info("hanfule排序后:"+list.toString());
			
			int  firstYm = list.get(0).getNaturalMonth();
			
			String lastMonth = DateUtil.toStringPlusMonths(sCurYm, -1,"yyyyMM");
			
			if(firstYm < Integer.parseInt(lastMonth)){
				return true;
			}else{
				return false;
			}
		}
		
	}
	
	private class BillComp implements Comparator<BillEntity> {

		@Override
		public int compare(BillEntity o1, BillEntity o2) {

			int naturalMonth1 = o1.getNaturalMonth();
			int naturalMonth2 = o2.getNaturalMonth();
			
			if (naturalMonth1 <= naturalMonth2) {
				return -1;
			} else if (naturalMonth1 >= naturalMonth2) {
				return 1;
			}
			return 0;
		}
	}
	
	/**
	 * @return the record
	 */
	public IRecord getRecord() {
		return record;
	}

	/**
	 * @param record the record to set
	 */
	public void setRecord(IRecord record) {
		this.record = record;
	}

	/**
	 * @return the control
	 */
	public IControl getControl() {
		return control;
	}

	/**
	 * @param control the control to set
	 */
	public void setControl(IControl control) {
		this.control = control;
	}

	/**
	 * @return the user
	 */
	public IUser getUser() {
		return user;
	}

	/**
	 * @param user the user to set
	 */
	public void setUser(IUser user) {
		this.user = user;
	}

	/**
	 * @return the group
	 */
	public IGroup getGroup() {
		return group;
	}

	/**
	 * @param group the group to set
	 */
	public void setGroup(IGroup group) {
		this.group = group;
	}

	/**
	 * @return the preOrder
	 */
	public IPreOrder getPreOrder() {
		return preOrder;
	}

	/**
	 * @param preOrder the preOrder to set
	 */
	public void setPreOrder(IPreOrder preOrder) {
		this.preOrder = preOrder;
	}

	/**
	 * @return the balance
	 */
	public IBalance getBalance() {
		return balance;
	}

	/**
	 * @param balance the balance to set
	 */
	public void setBalance(IBalance balance) {
		this.balance = balance;
	}

	/**
	 * @return the bill
	 */
	public IBill getBill() {
		return bill;
	}

	/**
	 * @param bill the bill to set
	 */
	public void setBill(IBill bill) {
		this.bill = bill;
	}
	
}
