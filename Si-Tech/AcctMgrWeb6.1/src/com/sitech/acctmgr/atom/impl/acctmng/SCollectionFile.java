package com.sitech.acctmgr.atom.impl.acctmng;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Date;
import java.util.List;

import com.sitech.acctmgr.atom.domains.account.ConTrustEntity;
import com.sitech.acctmgr.atom.domains.account.ContractInfoEntity;
import com.sitech.acctmgr.atom.domains.base.ChngroupRelEntity;
import com.sitech.acctmgr.atom.domains.collection.CollAcctConEntity;
import com.sitech.acctmgr.atom.domains.collection.CollBillAddEntity;
import com.sitech.acctmgr.atom.domains.collection.CollConDealEntity;
import com.sitech.acctmgr.atom.domains.collection.CollConDealRecdEntity;
import com.sitech.acctmgr.atom.domains.collection.CollEntity;
import com.sitech.acctmgr.atom.domains.collection.CollFileDetailEntity;
import com.sitech.acctmgr.atom.domains.collection.CollHeaderConEntity;
import com.sitech.acctmgr.atom.domains.collection.CollectionBillEntity;
import com.sitech.acctmgr.atom.domains.collection.CollectionConf;
import com.sitech.acctmgr.atom.domains.collection.CollectionDispEntity;
import com.sitech.acctmgr.atom.domains.cust.PostBankEntity;
import com.sitech.acctmgr.atom.domains.record.ActCollBillRecdEntity;
import com.sitech.acctmgr.atom.dto.acctmng.SCollectionFileCheckInDTO;
import com.sitech.acctmgr.atom.dto.acctmng.SCollectionFileCheckOutDTO;
import com.sitech.acctmgr.atom.dto.acctmng.SCollectionFileCreateInDTO;
import com.sitech.acctmgr.atom.dto.acctmng.SCollectionFileCreateOutDTO;
import com.sitech.acctmgr.atom.dto.acctmng.SCollectionFileInsertTableInDTO;
import com.sitech.acctmgr.atom.dto.acctmng.SCollectionFileInsertTableOutDTO;
import com.sitech.acctmgr.atom.dto.acctmng.SCollectionFileReCreateInDTO;
import com.sitech.acctmgr.atom.dto.acctmng.SCollectionFileReCreateOutDTO;
import com.sitech.acctmgr.atom.entity.inter.IAccount;
import com.sitech.acctmgr.atom.entity.inter.IBill;
import com.sitech.acctmgr.atom.entity.inter.ICollection;
import com.sitech.acctmgr.atom.entity.inter.IControl;
import com.sitech.acctmgr.atom.entity.inter.IGroup;
import com.sitech.acctmgr.atom.entity.inter.IRecord;
import com.sitech.acctmgr.common.AcctMgrBaseService;
import com.sitech.acctmgr.common.AcctMgrError;
import com.sitech.acctmgr.common.AcctMgrProperties;
import com.sitech.acctmgr.common.utils.DateUtils;
import com.sitech.acctmgr.common.utils.FileUtils;
import com.sitech.acctmgr.inter.acctmng.ICollectionFile;
import com.sitech.jcf.core.exception.BusiException;
import com.sitech.jcfx.anno.ParamType;
import com.sitech.jcfx.anno.ParamTypes;
import com.sitech.jcfx.dt.in.InDTO;
import com.sitech.jcfx.dt.out.OutDTO;
import com.sitech.jcfx.util.DateUtil;

/**
 * Created by wangyla on 2016/7/7.
 */
@ParamTypes({
        @ParamType(c = SCollectionFileCreateInDTO.class, m = "create", oc = SCollectionFileCreateOutDTO.class),
        @ParamType(c = SCollectionFileReCreateInDTO.class, m = "reCreate", oc = SCollectionFileReCreateOutDTO.class),
        @ParamType(c = SCollectionFileCheckInDTO.class, m = "check", oc = SCollectionFileCheckOutDTO.class),
        @ParamType(c = SCollectionFileInsertTableInDTO.class, m = "insertTable", oc = SCollectionFileInsertTableOutDTO.class)
})
public class SCollectionFile extends AcctMgrBaseService implements ICollectionFile {

    private static final String collFilePath = AcctMgrProperties.getConfigByMap("collFilePath");
    private static final String collRdFilePath = AcctMgrProperties.getConfigByMap("collRdFilePath");
    private static final String collRdhisFilePath = AcctMgrProperties.getConfigByMap("collRdhisFilePath");

    private ICollection collection;
    private IGroup group;
    private IBill bill;
    private IAccount account;
    private IRecord record;
    private IControl control;


    @Override
    public OutDTO create(InDTO inParam) {
        SCollectionFileCreateInDTO inDTO = (SCollectionFileCreateInDTO) inParam;

        log.debug("inDto=" + inDTO.getMbean());

        int totalDate = DateUtils.getCurDay();
        String disGroupId = inDTO.getDistrictCode();
        String postBankCode = inDTO.getPostBankCode();
        /**
         * S1：获取归属区县范围内未处理的托收帐户，按指定范围查询
         * S2：对托收帐户进行过滤，1，归属当前区县 2，托收银行为入参值
         * S3：查询每个符合条件的托收帐户的托收明细帐单
         * S4：对每个符合的托收帐户记录操作记录表信息
         * S5：生成托收文件并记录托收文件记录表信息
         */

        ChngroupRelEntity disGroupInfo = group.getRegionDistinct(disGroupId, "2", inDTO.getProvinceId());
        int regionCode = Integer.parseInt(disGroupInfo.getRegionCode());

        PostBankEntity postBankInfo = collection.getPostBankInfo(regionCode, postBankCode);
        if (postBankInfo == null) {
            throw new BusiException(AcctMgrError.getErrorCode("8229", "20002"), "托收银行信息不存在");
        }
        String postAccountNo = postBankInfo.getPostAccount();

        /*获取归属区县托收配置信息*/
        CollectionConf collConfInfo = collection.getCollConfInfo(disGroupId, inDTO.getEnterCode(), inDTO.getOperType()).get(0);

        String agreeNoPrex = this.getAgreeNoPrefix(collConfInfo); //agree_no的前缀，在实际生成时最后一位会添加托收帐户号码

        //托收文件内容
        StringBuilder fileContext = new StringBuilder();

        long paySn = control.getSequence("SEQ_SYSTEM_SN");
        //获取托收帐单信息
        List<CollectionBillEntity> collList = bill.getCollBillList(inDTO.getBegContract(), inDTO.getEndContract(), inDTO.getYearMonth(), disGroupId, inDTO.getProvinceId());
        int recdNum = 0;//托收帐户的个数
        long totalPayFee = 0;
        for (CollectionBillEntity collInfo : collList) {
            ConTrustEntity collBankInfo = account.getContrustInfo(collInfo.getContractNo());

            //没有托收银行帐号或者托收银行和此次查询的邮寄银行不一致的，进行过滤
            if (collBankInfo == null || (collBankInfo != null && !collBankInfo.getPostBankCode().equals(postBankCode))) {
                continue;
            }

            recdNum++;

            CollectionDispEntity collDetInfo = collection.getBillDetByContract(collInfo.getContractNo(), collInfo.getBillCycle());

            totalPayFee += collDetInfo.getPayFee();

            String fileContent = this.getFileContext(collDetInfo, agreeNoPrex, recdNum);
            fileContext.append(fileContent); //累记托收单信息

            /*记录托收文件生成处理日志表*/
            ActCollBillRecdEntity collbillRecd = new ActCollBillRecdEntity();
            collbillRecd.setContractNo(collInfo.getContractNo());
            collbillRecd.setBillCycle(collInfo.getBillCycle());
            collbillRecd.setTotalDate(totalDate);
            collbillRecd.setLoginAccept(paySn);
            collbillRecd.setPayFee(collInfo.getPayFee());
            collbillRecd.setFetchNo(String.valueOf(totalDate));
            collbillRecd.setOpCode(inDTO.getOpCode()); //8229
            collbillRecd.setLoginNo(inDTO.getLoginNo());
            collbillRecd.setGroupId(collInfo.getGroupId());
            collbillRecd.setOrgId(inDTO.getGroupId());
            collbillRecd.setRemark("电子托收生成文件");
            record.saveCollbillRecd(collbillRecd);

            /*LoginOprEntity loginOpr = new LoginOprEntity();
            record.saveLoginOpr(loginOpr);*/

            //TODO 补充过1000用户，生成新文件功能
        }

        if (recdNum == 0) {
            throw new BusiException(AcctMgrError.getErrorCode("8229", "20001"), "没有可托收的托收单");
        }

        String fullFileName = this.saveCollectionFile(collConfInfo, fileContext, recdNum, totalPayFee,
                inDTO.getYearMonth(), inDTO.getLoginNo(), postBankCode, postAccountNo);

        SCollectionFileCreateOutDTO outDTO = new SCollectionFileCreateOutDTO();
        outDTO.setFileName(fullFileName);

        log.debug("outDto=" + outDTO.toJson());

        return outDTO;
    }

    /**
     * 功能：将托收信息写入托收文件并记录托收文件记录信息
     *
     * @param collConfInfo
     * @param fileContext
     * @param recdNum
     * @param totalPayFee
     * @param yearMonth
     * @param loginNo
     * @return fileName
     */
    private String saveCollectionFile(CollectionConf collConfInfo, StringBuilder fileContext, int recdNum,
                                      long totalPayFee, int yearMonth, String loginNo, String postBankCode, String postAccountNo) {

        long collSn = control.getSequence("SEQ_COLLECTION_SN");
        //托收文件文件全路径名
        String fileName = collFilePath + "/" + this.createFileName(collConfInfo, collSn);

        String totalString = this.getTotalString(collConfInfo, totalPayFee, recdNum, collSn, postBankCode, postAccountNo); //获取头汇总信息

        StringBuilder out = new StringBuilder();
        out.append(totalString);
        out.append(fileContext);
        this.writeFile(fileName, out.toString());

        collection.saveCollectionFileRecd(fileName, yearMonth, loginNo);

        return fileName;
    }

    private String getFileContext(CollectionDispEntity collDetInfo, String agreeNoPrex, int recdNum) {
        StringBuilder fileContext = new StringBuilder();
        fileContext.append(String.format("%08d", recdNum));
        fileContext.append(String.format("%12s", collDetInfo.getBankCode()).replace(" ", "0"));
        fileContext.append(String.format("%-32s", collDetInfo.getAccountNo()));
        fileContext.append(String.format("%-60s", collDetInfo.getBankName()));
        fileContext.append(String.format("%-60s", " "));
        fileContext.append(String.format("%015d", collDetInfo.getPayFee()));
        fileContext.append(String.format("%-60s", agreeNoPrex + collDetInfo.getContractNo()));
        fileContext.append(String.format("%-60s", " "));
        fileContext.append("\n");

        return fileContext.toString();
    }

    @Override
    public OutDTO reCreate(InDTO inParam) {

        SCollectionFileReCreateInDTO inDTO = (SCollectionFileReCreateInDTO) inParam;
        log.debug("inDto=" + inDTO.getMbean());

        int totalDate = DateUtils.getCurDay();

        /**
         * 解决方案：确认此模块是否只用于工号归属区县下的托收帐户的补托功能；此时，可以按工号的归属区县进行操作；
         * 后续现场测试过程中，如果局方提出这个问题，可以考虑用以上方案；如果不提，则按现网的不合理的方式进行开发；
         */
        long paySn = control.getSequence("SEQ_SYSTEM_SN");

        List<CollEntity> collInfoList = inDTO.getCollList();
        int yearMonth = inDTO.getYearMonth();
        long contractNo = 0;
        long payFee = 0;
        int recdNum = 0;
        long totalPayFee = 0;
        StringBuilder fileContext = new StringBuilder();
        String fileName = "";
        for (CollEntity collInfo : collInfoList) {
            contractNo = collInfo.getContractNo();
            payFee = collInfo.getPayFee();

            recdNum++;

            ConTrustEntity collBankInfo = account.getContrustInfo(contractNo);
            ContractInfoEntity conInfo = account.getConInfo(contractNo);
            String conGroupId = conInfo.getGroupId();
            String postBankCode = collBankInfo.getPostBankCode();

            ChngroupRelEntity loginGoupInfo = group.getRegionDistinct(conGroupId, "3", inDTO.getProvinceId());
            String disGroupId = loginGoupInfo.getParentGroupId();
            long regionCode = Long.parseLong(loginGoupInfo.getRegionCode());

            PostBankEntity postBankInfo = collection.getPostBankInfo(regionCode, postBankCode);
            if (postBankInfo == null) {
                throw new BusiException(AcctMgrError.getErrorCode("8229", "20002"), "托收银行信息不存在");
            }
            String postAccountNo = postBankInfo.getPostAccount();

            CollectionConf collConfInfo = collection.getCollConfInfo(disGroupId, null, null).get(0);
            String agreeNoPrex = this.getAgreeNoPrefix(collConfInfo);

            CollectionDispEntity collDetInfo = collection.getBillDetByContract(contractNo, yearMonth);
            totalPayFee += collDetInfo.getPayFee();
            
            //托收单生成入表
            CollConDealRecdEntity CollConDealRecdEnt = new CollConDealRecdEntity();
            CollConDealRecdEnt.setContractNo(contractNo);
            CollConDealRecdEnt.setDealFlag("1");
            CollConDealRecdEnt.setDetailSeq(recdNum);
            CollConDealRecdEnt.setLoginNo(inDTO.getLoginNo());
            CollConDealRecdEnt.setLoginSeq(0);
            CollConDealRecdEnt.setOpDate(DateUtils.getCurDay());
            CollConDealRecdEnt.setYearMonth(yearMonth);
            
            collection.saveCollRecord(CollConDealRecdEnt);

            String fileContent = this.getFileContext(collDetInfo, agreeNoPrex, recdNum);

            /*记录托收文件生成处理日志表*/
            ActCollBillRecdEntity collbillRecd = new ActCollBillRecdEntity();
            collbillRecd.setContractNo(contractNo);
            collbillRecd.setBillCycle(yearMonth);
            collbillRecd.setTotalDate(totalDate);
            collbillRecd.setLoginAccept(paySn);
            collbillRecd.setPayFee(collDetInfo.getPayFee());
            collbillRecd.setFetchNo(String.valueOf(totalDate));
            collbillRecd.setOpCode(inDTO.getOpCode()); //3108
            collbillRecd.setLoginNo(inDTO.getLoginNo());
            collbillRecd.setGroupId(conGroupId);
            collbillRecd.setOrgId(inDTO.getGroupId());
            collbillRecd.setRemark("补充生成电子托收");
            record.saveCollbillRecd(collbillRecd);

            fileContext.append(fileContent);
            if (recdNum == collInfoList.size()) {
                fileName = this.saveCollectionFile(collConfInfo, fileContext, recdNum, totalPayFee, yearMonth,
                        inDTO.getLoginNo(), collBankInfo.getPostBankCode(), postAccountNo);

            }

            //记录补托收用户信息
            CollBillAddEntity collBillAddEnt = new CollBillAddEntity();
            collBillAddEnt.setContractNo(contractNo);
            collBillAddEnt.setPayFee(collDetInfo.getPayFee());
            collBillAddEnt.setBillCycle(yearMonth);
            collBillAddEnt.setPostAccount(postAccountNo);
            collBillAddEnt.setCityCode(collConfInfo.getCityCode());
            collection.saveCollBillAdd(collBillAddEnt);
        }

        SCollectionFileReCreateOutDTO outDto = new SCollectionFileReCreateOutDTO();
        outDto.setFileName(fileName);

        log.debug("outDTO=" + outDto.toJson());

        return outDto;
    }

    private String createFileName(CollectionConf collConfInfo, long collSn) {
        StringBuilder sb = new StringBuilder();
        sb.append(collConfInfo.getOpType());
        sb.append(String.format("%6d", DateUtils.getCurDay()).substring(2, 8));
        sb.append(collConfInfo.getCityCode());
        sb.append(collConfInfo.getEnterCode());
        sb.append(String.format("%5d", collSn));
        return sb.toString();
    }

    private String getAgreeNoPrefix(CollectionConf collConfInfo) {
        //sprintf(agree_no,"%4s%5s%5s%1s%ld",city_code,enter_code,oper_type,"0",contract_no);
        StringBuilder sb = new StringBuilder();
        sb.append(collConfInfo.getCityCode());
        sb.append(collConfInfo.getEnterCode());
        sb.append(collConfInfo.getOperType());
        sb.append("0");
        //sb.append();
        return sb.toString();
    }

    private String getTotalString(CollectionConf collConf, long totalPayFee, int recdNum, long loginAccept,
                                  String postBankCode, String postAccountNo) {
        StringBuilder sb = new StringBuilder();
        sb.append(collConf.getBusiCode()); //对应老的oper_code
        sb.append(collConf.getCityCode());
        sb.append(collConf.getEnterCode());
        sb.append(String.format("%-3s", " "));
        sb.append(String.format("%8d", DateUtils.getCurDay()).substring(0, 8));
        sb.append(collConf.getCityCode());
        sb.append(collConf.getEnterCode());
        sb.append(String.format("%05d", loginAccept));
        sb.append("03");
        sb.append(String.format("%12s", postBankCode).replace(" ", "0"));
        sb.append(String.format("%-32s", postAccountNo));
        sb.append(collConf.getOperType());
        sb.append(String.format("%015d", totalPayFee));
        sb.append(String.format("%08d", recdNum));
        sb.append("\n");
        return sb.toString();
    }

    private void writeFile(String fileName, String context) {
        File outFile = new File(fileName);
        FileWriter fw = null;
        try {
            fw = new FileWriter(outFile, false);
            fw.write(context);

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fw != null) {
                try {
                    fw.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

    }

    @Override
    public OutDTO check(InDTO inParam) {

        SCollectionFileCheckInDTO inDto = (SCollectionFileCheckInDTO) inParam;
        log.debug("inDto=" + inDto.getMbean());

        int yearMonth = inDto.getYearMonth();

        List<CollEntity> collList = inDto.getCollList();
        if (collList == null || collList.size() == 0) {
            throw new BusiException(AcctMgrError.getErrorCode("3108", "20001"), "没有需要校验的补托收信息");
        }

        long totalPayFee = 0;
        for (int i = 0; i < collList.size(); i++) {
            CollEntity collEntity = collList.get(i);
            int count = collection.getCollBillAddCount(collEntity.getContractNo(),yearMonth, collEntity.getPayFee());
            if (count > 0) {
                throw new BusiException(AcctMgrError.getErrorCode("3108", "20002"), String.format("输入第%d条补托合同号[%d]已经补托，补托重复！请核对后重新输入！", (i + 1), collEntity.getContractNo()));
            }

            CollectionDispEntity collInfo = null;
            try {
                collInfo = collection.getBillDetByContract(collEntity.getContractNo(), yearMonth);

            } catch (BusiException e) {

            }
            if (collInfo == null) {
                throw new BusiException(AcctMgrError.getErrorCode("3108", "20003"), String.format("输入第%d补托收合同号[%d]不存在，请核对后重新输入！", (i + 1), collEntity.getContractNo()));
            }

            long contractPay = collInfo.getPayFee();

            if (collEntity.getPayFee() != contractPay) {
                throw new BusiException(AcctMgrError.getErrorCode("3108", "20004"), String.format("输入的第%d条托收金额与实际托收金额不符，请验证后重新输入！托收金额为[%d]分", (i + 1), contractPay));
            }

            totalPayFee += contractPay;
        }

        SCollectionFileCheckOutDTO outDTO = new SCollectionFileCheckOutDTO();
        outDTO.setTotalPayFee(totalPayFee);
        return outDTO;
    }

    @Override
    public OutDTO insertTable(InDTO inParam) {
        SCollectionFileInsertTableInDTO inDto = (SCollectionFileInsertTableInDTO) inParam;
        log.debug("inDto=" + inDto.getMbean());

        String rdPath = collRdFilePath; /*从配置文件中获取*/
        int recdNum = 0;
        long totalFee = 0;
        int yearMonth = inDto.getYearMonth();
        int dealFileFlag = 0;
        String sCurDate = DateUtil.format(new Date(), "yyyyMMddHHmmss");
		String totalDate = sCurDate.substring(0, 8);

        /**
         * S1：获取rdPath路径下的所有待处理文件，不包括 .(当前目录)、 ..(父级目录)、RDhis(处理后历史目录)
         * S2：循环处理每一个文件
         * S2.2 处理每一个文件中内容（分两部分，头汇总信息，文件中回销帐户列表信息）
         * S2.2.1 判断记录有没有托收文件打印记录表中数据是否托收成功；不成功，则退出，不处理当前文件；
         * S2.2.2 若处理成功，则记录回销记录表 （ACT_COLLCONDEAL_MID）
         */
        
        List<File> filesList = FileUtils.getFiles(rdPath);
        
        if(filesList == null || filesList.size() == 0){
        	throw new BusiException(AcctMgrError.getErrorCode("8229", "20008"), "该目录下没有可处理文件!"); 
        }
        
        for (File file : filesList) {
        	FileReader reader = null;
        	BufferedReader br = null;
        	
        	try {
        		String headerInfo = null;
        		dealFileFlag = 1;
        		
				reader = new FileReader(file);
				br = new BufferedReader(reader);
				
				headerInfo = br.readLine();

				CollHeaderConEntity collHeaderEnt = new CollHeaderConEntity();
				
				//对头汇总信息做处理
				String operType = headerInfo.substring(0, 5);
				String enterCode = headerInfo.substring(5, 17);
				String opDate = headerInfo.substring(17, 25);
				String dataFileName = headerInfo.substring(25, 47);
				String mobileBankCode = headerInfo.substring(47,59);
				String mobileAccountNo = headerInfo.substring(59,91);
				String shouldPay = headerInfo.substring(91, 106);
				String realPay = headerInfo.substring(106, 121);
				String shouldSum = headerInfo.substring(121, 129);
				String realSum = headerInfo.substring(129, 137);
				String dealSum = headerInfo.substring(137, 145);
				
				collHeaderEnt.setOperType(operType);
				collHeaderEnt.setEnterCode(enterCode);
				collHeaderEnt.setOpDate(opDate);
				collHeaderEnt.setDataFileName(dataFileName);
				collHeaderEnt.setMobileBankCode(mobileBankCode);
				collHeaderEnt.setMobileAccountNo(mobileAccountNo);
				collHeaderEnt.setShouldPay(shouldPay);
				collHeaderEnt.setRealPay(realPay);
				collHeaderEnt.setShouldSum(shouldSum);
				collHeaderEnt.setRealSum(realSum);
				collHeaderEnt.setDealSum(dealSum);
				
				String fileInfo = null;
				CollAcctConEntity collAccountEnt = new CollAcctConEntity(); 
				
				while((fileInfo = br.readLine())!= null){
					//对账户列表信息进行处理
					String recSeq = fileInfo.substring(0, 8);
					String userEnterAccountNo = fileInfo.substring(8, 68).trim();
					long payMoney = Long.parseLong(fileInfo.substring(68, 83).trim());
					String recReturnCode = fileInfo.substring(83, 85);
					String recReturnMsg = fileInfo.substring(85, 145);
					
					collAccountEnt.setRecSeq(recSeq);
					collAccountEnt.setUserEnterAccountNo(userEnterAccountNo);
					collAccountEnt.setPayMoney(payMoney);
					collAccountEnt.setRecReturnCode(recReturnCode);
					collAccountEnt.setRecReturnMsg(recReturnMsg);
					long contractNo = Long.parseLong(userEnterAccountNo.substring(16).trim());
					
					//检查托收文件是否已经处理   dealFileFlag = 0-未处理    dealFileFlag = 1-已处理
					//如果表中没记录则表示文件数据错误  不做处理
					if(!collection.hasCollDealed(contractNo, yearMonth)){
						dealFileFlag = 0;
						log.error("获取账户"+contractNo+"的账务月信息出错!");
						break;
					}
					
					CollFileDetailEntity collFileDetEnt = new CollFileDetailEntity();
					collFileDetEnt.setFileName(file.getName());
					collFileDetEnt.setUserEnterAccountNo(userEnterAccountNo);
					collFileDetEnt.setContractNo(contractNo);
					collFileDetEnt.setLoginNo(inDto.getLoginNo());
					collFileDetEnt.setOpCode(inDto.getOpCode());
					collFileDetEnt.setOpNote("");
					collFileDetEnt.setOpTime(totalDate);
					collFileDetEnt.setPayMoney(payMoney);
					collFileDetEnt.setRecReturnCode(recReturnCode);
					collFileDetEnt.setRecReturnMsg(recReturnMsg);
					collFileDetEnt.setYearMonth(yearMonth);
					
					collection.saveConTotalFileDetailInfo(collFileDetEnt);
					
					if("00".equals(recReturnCode)){
						//处理成功入库后更新回执单处理状态   deal_flag置0(已处理)
						collection.updateDealFlag(contractNo, yearMonth);
					} else {
						dealFileFlag = 0;  //未处理
						log.error("回执单状态变更失败!");
						break;
					}
					
					/*
					 * 存入回执单实体
					 */
					CollConDealEntity collDealEnt = new CollConDealEntity();
					collDealEnt.setContractNo(contractNo);
					collDealEnt.setGroupId(inDto.getGroupId());
					collDealEnt.setLoginNo(inDto.getLoginNo());
					collDealEnt.setOpCode(inDto.getOpCode());
					collDealEnt.setOpNote("");
					collDealEnt.setPayMoney(payMoney);
					collDealEnt.setYearMonth(yearMonth);
					collDealEnt.setPassNo("123456");
					collDealEnt.setPayType("0");
					collDealEnt.setFetchNo(0);
					collDealEnt.setDealFlag("0");//deal_flag = 0已处理   deal_flag = 1未处理
					collection.saveCollConDeal(collDealEnt);
					
					recdNum++;
					totalFee += payMoney; 
				}
				if(1 == dealFileFlag){ //表示已处理完毕的文件
					String fileName = file.getAbsolutePath();
					String command = String.format("mv %s %s",fileName,collRdhisFilePath);
					Process proc = Runtime.getRuntime().exec(command);
					if(proc.waitFor()<0){
						log.info("备份回执处理文件出错!");
						break;
					}
				}
				
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (InterruptedException e) {
				e.printStackTrace();
			} finally {
				try {
					if(reader != null){
						reader.close();
					}
					if(br != null){
						br.close();
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
        
        SCollectionFileInsertTableOutDTO outDto = new SCollectionFileInsertTableOutDTO();
        outDto.setRecdNum(recdNum);
        outDto.setTotalFee(totalFee);

        log.debug("outDto=" + outDto.toJson());
        return outDto;
    }

    public ICollection getCollection() {
        return collection;
    }

    public void setCollection(ICollection collection) {
        this.collection = collection;
    }

    public IGroup getGroup() {
        return group;
    }

    public void setGroup(IGroup group) {
        this.group = group;
    }

    public IBill getBill() {
        return bill;
    }

    public void setBill(IBill bill) {
        this.bill = bill;
    }

    public IAccount getAccount() {
        return account;
    }

    public void setAccount(IAccount account) {
        this.account = account;
    }

    public IRecord getRecord() {
        return record;
    }

    public void setRecord(IRecord record) {
        this.record = record;
    }

    public IControl getControl() {
        return control;
    }

    public void setControl(IControl control) {
        this.control = control;
    }
}
