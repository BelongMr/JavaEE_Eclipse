<%@page contentType="text/html;charset=GBK"%>
<%@page import="java.util.*"%>
<%@page import="com.sitech.crmpd.core.bean.MapBean"%>
<%@page import="com.sitech.crmpd.core.util.SiUtil"%>
<%
	String meansjsonstr =(String)request.getParameter("meansjsonstr");
	String flag =(String)request.getParameter("flag");
	String specialfunds =(String)request.getParameter("specialfunds");
	String systempay =(String)request.getParameter("systempay");
	String ssfeeinfo =(String)request.getParameter("ssfeeinfo");
	String assifeeinfo =(String)request.getParameter("assifeeinfo");
	String scoreinfo =(String)request.getParameter("scoreinfo");
	
	//add zhangxy20170505 for 关于终端类营销活动承载数据业务及优化营销管理平台BOSS侧配置选项的函
	String spInfo =(String)request.getParameter("spInfo");

	
	String selectMeansId =(String)request.getParameter("selectMeansId");
	String TEMPLET_TYPE =(String)request.getParameter("TEMPLET_TYPE");
	String money =(String)request.getParameter("money");
	String actType =(String)request.getParameter("actType");
	System.out.println("&&&&&&&&&&&&&&&&&&&&&&&&&&"+scoreinfo);
	System.out.println("selectMeansId=============="+selectMeansId);
	System.out.println("money=======bcd======="+money);
	System.out.println("actType=======bcd======="+actType);
	String xml = specialfunds + systempay + ssfeeinfo + assifeeinfo+scoreinfo+spInfo;
	String priFeeValid ="";
	String resouceMon = "";
	MapBean mb = new MapBean();	
%>
<%@ include file="getMapBean.jsp"%>
<%
	List fundMapList = mb.getList("OUT_DATA.H02.SPECIAL_FUNDS_LIST.SPECIAL_FUNDS_INFO");
	if("N/A".equals(fundMapList.get(0)))fundMapList = new ArrayList();
	List sysPayMapList = mb.getList("OUT_DATA.H04.SYSTEM_PAY_LIST.SYSTEM_PAY_INFO");
	if("N/A".equals(sysPayMapList.get(0)))sysPayMapList = new ArrayList();
	List feeMapList = mb.getList("OUT_DATA.H10.PRI_FEE_LIST.PRI_FEE_INFO");
	if("N/A".equals(feeMapList.get(0)))feeMapList = new ArrayList();

	
	//List addFeeMapList = mb.getList("OUT_DATA.H11.FUND_LIST.FUND_INFO");
	//update 20161210 zhangxy 
	List addFeeMapList = mb.getList("OUT_DATA.H11.ADD_FEE_LIST.ADD_FEE_INFO");
	if(addFeeMapList==null || addFeeMapList.isEmpty() || "N/A".equals(addFeeMapList.get(0)))addFeeMapList = new ArrayList();
	
	//add zhangxy20170505 for 关于终端类营销活动承载数据业务及优化营销管理平台BOSS侧配置选项的函
	List spInfoMapList = mb.getList("OUT_DATA.H12.SP_INFO_LIST.SP_INFO");
	if (spInfoMapList == null || spInfoMapList.isEmpty() || "N/A".equals(spInfoMapList.get(0))) {
		spInfoMapList = new ArrayList();
	}

	String scoreString = mb.getString("OUT_DATA.H42.DEDUCT_MONEY");
	System.out.println("++++++++++++++++scoreString:" + scoreString);
	StringBuffer exStr = new StringBuffer();
	/************************主资费*******************************/
	StringBuffer feeStr = new StringBuffer();
	feeStr.append("<table id='table_fee'>").append("<tr><th>选择主资费</th><th>主资费代码</th><th>主资费名称</th></tr>");
	if (null != feeMapList && feeMapList.size() > 0) {
		Iterator it = feeMapList.iterator();
		while (it.hasNext()) {
			Map stMap = mb.isMap(it.next());
			if (null == stMap)
				continue;
			String priFeeValidN = (String) stMap.get("PRI_FEE_VALID");
			if (null != priFeeValidN) {
				priFeeValid = priFeeValidN;
			}
		}
		System.out.println("_________priFeeValid________" + priFeeValid);
	}
	int feeNum = 0;
	for (int i = 0; i < feeMapList.size(); i++) {
		Map feeMap = (Map) feeMapList.get(i);
		String PRI_FEE_CODE = (String) feeMap.get("PRI_FEE_CODE");
		if (null == PRI_FEE_CODE) {
			continue;
		}
		feeNum++;
		String feeCode = (String) feeMap.get("PRI_FEE_CODE");
		String feeName = (String) feeMap.get("PRI_FEE_NAME");
		String payagenet = (String) feeMap.get("PAYAGENET");
		resouceMon = (String) feeMap.get("RESOUCEAGENET");
		String feeagenet = (String) feeMap.get("FEEAGENET");
		String resFeeTempAge = "";
		if (Integer.parseInt(resouceMon) >= Integer.parseInt(feeagenet)) {

			int cheresouceMon = Integer.parseInt(money) - Integer.parseInt(feeagenet);
			if (cheresouceMon >= 0) {
				resouceMon = feeagenet;
				resFeeTempAge = String.valueOf(cheresouceMon);
			} else {
				resouceMon = money;
				resFeeTempAge = "0";
			}
		} else {
			int cheresouceMon = Integer.parseInt(money) - Integer.parseInt(resouceMon);
			if (cheresouceMon >= 0) {
				resouceMon = resouceMon;
				resFeeTempAge = String.valueOf(cheresouceMon);
			} else {
				resouceMon = money;
				resFeeTempAge = "0";
			}
		}
		System.out.println("payagenet===============BCD========" + payagenet);
		System.out.println("resouceMon===============BCD========" + resouceMon);
		System.out.println("resFeeTempAge===============BCD========" + resFeeTempAge);
		feeStr.append("<tr>").append("<td><input type='radio' name='fee' value='").append(feeCode)
				.append("' size='1' ").append("onclick='getExtFeeAjax(\"").append(feeCode).append("\")' />")
				.append("<input type='hidden' id='hid_feeValid_").append(feeCode).append("' value='")
				.append(priFeeValid).append("' />").append("<input type='hidden' id='hid_feeName_")
				.append(feeCode).append("' value='").append(feeName).append("' />")
				.append("<input type='hidden' id='hid_payagenet_").append(feeCode).append("' value='")
				.append(payagenet).append("' />").append("<input type='hidden' id='hid_resoucemon_")
				.append(feeCode).append("' value='").append(resouceMon).append("' />")
				.append("<input type='hidden' id='hid_resfeeagemon_").append(feeCode).append("' value='")
				.append(resFeeTempAge).append("' />").append("</td>").append("<td>").append(feeCode)
				.append("</td>").append("<td>").append(feeName).append("</td>").append("</tr>");
	}
	System.out.println("++++++++++++++++feeStr:" + feeStr);
	/************************附加资费*******************************/
	/*StringBuffer addFeeStr = new StringBuffer();
	int addFeeNum = 0;
	addFeeStr.append("<table id='table_addFee'>")
	.append("<tr><th>选择附加资费</th><th>附加资费代码</th><th>附加资费名称</th><th>消费期限</th></tr>");
	for(int i=0; i<addFeeMapList.size(); i++){
		Map addFeeMap = (Map)addFeeMapList.get(i);
		addFeeNum ++;
		String addFeeCdoe = (String)addFeeMap.get("ADD_FEE_CODE");
		String addFeeName = (String)addFeeMap.get("ADD_FEE_NAME");
		String addFeeTime = (String)addFeeMap.get("ADD_FEE_TIME");
		addFeeStr.append("<tr>")
			.append("<td><input type='checkbox' name='addFee' value='").append(addFeeCdoe).append("'  />")
				.append("<input type='hidden' id='hid_addfee_time_").append(addFeeCdoe).append("' value='").append(addFeeTime).append("' />")
			.append("</td>")
			.append("<td>").append(addFeeCdoe).append("</td>")
			.append("<td>").append(addFeeName).append("</td>")
			.append("<td>").append(addFeeTime).append("</td>")
			.append("</tr>");
	}
	addFeeStr.append("</table>");
	System.out.println("++++++++++++++++addFeeStr:"+addFeeStr);*/

	/***********update 20161210 zhangxy 附加资费*******************/
	int addFeeNum = 0;
	StringBuffer addFeeStr = new StringBuffer();
	//addFeeMapList index=0 为选择类型 、 生效方式  、 订购时选择 、是否可以提前退订信息
	//addFeeMapList index>=1为附加资费代码、 附加资费名称 、期限信息
	//故在这里判断 addFeeMapList.size()>1
	if (addFeeMapList != null && !addFeeMapList.isEmpty() && addFeeMapList.size() > 1) {
		String addFeeCodesStr = "";
		addFeeStr.append("<table id='table_addFee'>")
				//.append("<tr><th>选择附加资费</th><th>附加资费代码</th><th>附加资费名称</th><th>消费期限</th></tr>");
				.append("<tr><th>附加资费代码</th><th>附加资费名称</th><th>消费期限</th></tr>");
		for (int i = 0; i < addFeeMapList.size(); i++) {
			Map addFeeMap = (Map) addFeeMapList.get(i);
			if (i == 0) {
				String addFeeType = (String) addFeeMap.get("ADD_FEE_TYPE");
				String addFeeCheckChannel = (String) addFeeMap.get("ADD_FEE_CHECK_CANNEL");
				String addFeeValidFalg = (String) addFeeMap.get("ADD_FEE_VALID_FLAG");
				addFeeStr
						.append("<input type='hidden' id='addfee_type_id' value='" + addFeeType + "'></input>");
				addFeeStr.append("<input type='hidden' id='addfee_check_channel_id' value='"
						+ addFeeCheckChannel + "'></input>");
				addFeeStr.append("<input type='hidden' id='addfee_valid_flag_id' value='" + addFeeValidFalg
						+ "'></input>");
				continue;
			}

			addFeeNum++;
			String addFeeName = (String) addFeeMap.get("ADD_FEE_NAME");
			String addFeeCode = (String) addFeeMap.get("ADD_FEE_CODE");
			String addFeeScore = (String) addFeeMap.get("ADD_FEE_SCORE");
			String addFeeOffsetType = (String) addFeeMap.get("ADD_FEE_OFFSET_TYPE");

			addFeeStr.append("<tr>");
			//默认选中第一条附加资费
			//if(i==1){
			//addFeeStr.append("<td><input type='radio' name='addFee' checked='checked' value='").append(addFeeCode).append("'  />");
			//}else{
			//addFeeStr.append("<td><input type='radio' name='addFee' value='").append(addFeeCode).append("'  />");
			//}

			//.append("<input type='hidden' id='addfee_score_").append(addFeeCode).append("' value='").append(addFeeScore).append("' />")
			addFeeCodesStr += addFeeCode + ",";
			addFeeStr.append("</td>").append("<td id='addfee_code_" + addFeeCode + "'>").append(addFeeCode)
					.append("</td>").append("<td id='addfee_name_" + addFeeCode + "'>").append(addFeeName)
					.append("</td>").append("<td id='addfee_score_" + addFeeCode + "'>").append(addFeeScore)
					.append("</td>").append("<input id='addfee_offset_type_" + addFeeCode
							+ "' type='hidden' value='" + addFeeOffsetType + "'></input>")
					.append("</tr>");
		}
		addFeeCodesStr = addFeeCodesStr.substring(0, addFeeCodesStr.length() - 1);
		addFeeStr.append("<input id='addfee_codes_str' type='hidden' value='" + addFeeCodesStr + "'></input>");
		addFeeStr.append("</table>");
		System.out.println("++++++++++++++++addFeeStr:" + addFeeStr);
	}

	/************************专款*******************************/
	String split = "";
	String fpayTypeStr = "";
	String fpayMoneyStr = "";
	String fvalidFlagStr = "";
	String fconsumeTimeStr = "";
	String fallowPayStr = "";
	String fstartTimeStr = "";
	String freturnTypeStr = "";
	String freturnClassStr = "";
	String fpaymentTypeStr = "";
	String frelativeMonthStr = "";
	StringBuffer fundStr = new StringBuffer();
	int fundNum = 0;
	fundStr.append("<table id='table_fund'><tr>");
	fundStr.append("<th>专款类型</th><th>生效标示</th><th>消费期限</th>").append("<th>返还方式</th></tr>");
	for (int i = 0; i < fundMapList.size(); i++) {
		Map fundMap = (Map) fundMapList.get(i);
		fundNum++;
		String payType = (String) fundMap.get("PAY_TYPE") == null ? "" : (String) fundMap.get("PAY_TYPE");
		String payMoney = (String) fundMap.get("PAY_MONEY") == null ? "" : (String) fundMap.get("PAY_MONEY");
		String validFlag = (String) fundMap.get("VALID_FLAG") == null ? "" : (String) fundMap.get("VALID_FLAG");
		String consumeTime = (String) fundMap.get("CONSUME_TIME") == null ? ""
				: (String) fundMap.get("CONSUME_TIME");
		String allowPay = (String) fundMap.get("ALLOW_PAY") == null ? "" : (String) fundMap.get("ALLOW_PAY");
		String startTime = (String) fundMap.get("START_TIME") == null ? "" : (String) fundMap.get("START_TIME");
		String returnType = (String) fundMap.get("RETURN_TYPE") == null ? ""
				: (String) fundMap.get("RETURN_TYPE");
		String returnClass = (String) fundMap.get("RETURN_CLASS") == null ? ""
				: (String) fundMap.get("RETURN_CLASS");
		String paymentType = (String) fundMap.get("PAYMENT_TYPE") == null ? ""
				: (String) fundMap.get("PAYMENT_TYPE");
		String relativeMonth = (String) fundMap.get("RELATIVE_MONTH") == null ? ""
				: (String) fundMap.get("RELATIVE_MONTH");
		String validFlagS = "";
		if ("0".equals(validFlag)) {
			validFlagS = "立即生效";
		}
		if ("1".equals(validFlag)) {
			validFlagS = "下月生效";
		}
		if ("2".equals(validFlag)) {
			validFlagS = "自定义时间";
		}
		String returnTypeS = "";
		if ("0".equals(returnType)) {
			returnTypeS = "活动预存";
		}
		if ("1".equals(returnType)) {
			returnTypeS = "底线预存";
		}
		fundStr.append("<tr>");
		fundStr.append("<td>").append(payType).append("</td>").append("<td>").append(validFlagS).append("</td>")
				.append("<td>").append(consumeTime).append("</td>").append("<td>").append(returnTypeS)
				.append("</td>").append("</tr>");
		//拼串
		fpayTypeStr = fpayTypeStr + split + payType;
		fpayMoneyStr = fpayMoneyStr + split + payMoney;
		fvalidFlagStr = fvalidFlagStr + split + validFlag;
		fconsumeTimeStr = fconsumeTimeStr + split + consumeTime;
		fallowPayStr = fallowPayStr + split + allowPay;
		fstartTimeStr = fstartTimeStr + split + startTime;
		freturnTypeStr = freturnTypeStr + split + returnType;
		freturnClassStr = freturnClassStr + split + returnClass;
		fpaymentTypeStr = fpaymentTypeStr + split + paymentType;
		frelativeMonthStr = frelativeMonthStr + split + relativeMonth;
		split = "#";
	}
	exStr.append("<input type='hidden' id='hid_fund_payTypeStr' value='").append(fpayTypeStr).append("' />");
	exStr.append("<input type='hidden' id='hid_fund_payMoneyStr' value='").append(fpayMoneyStr).append("' />");
	exStr.append("<input type='hidden' id='hid_fund_validFlagStr' value='").append(fvalidFlagStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_fund_consumeTimeStr' value='").append(fconsumeTimeStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_fund_allowPayStr' value='").append(fallowPayStr).append("' />");
	exStr.append("<input type='hidden' id='hid_fund_startTimeStr' value='").append(fstartTimeStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_fund_returnTypeStr' value='").append(freturnTypeStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_fund_returnClassStr' value='").append(freturnClassStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_fund_paymentTypeStr' value='").append(fpaymentTypeStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_fund_relativeMonthStr' value='").append(frelativeMonthStr)
			.append("' />");
	fundStr.append("</table>");
	System.out.println("++++++++++++++++fundStr:" + fundStr);
	/************************系统充值*******************************/
	String split1 = "";
	String sgetWinningStr = "";
	String swinningRateStr = "";
	String spayTypeStr = "";
	String sreturnMoneyStr = "";
	String sreturnMonthStr = "";
	String sperMonthMoneyStr = "";
	String slimitMoneyStr = "";
	String sreturnTypeStr = "";
	String sreturnClassStr = "";
	String sconsumeTimeStr = "";
	String spayFlagStr = "";
	String sassPhoneNoStr = "";
	String sspSystemStr = "";//正常的系统充值，不是sp订购时夹带的，默认是"0"拼的串
	String svalidFlagStr = "";
	StringBuffer sysPayStr = new StringBuffer();
	int sysPayNum = 0;
	sysPayStr.append("<table id='table_syspay'><tr>");
	sysPayStr.append("<th>系统充值类型</th><th>生效标示</th><th>消费期限</th>").append("<th>返还方式</th></tr>");
	for (int i = 0; i < sysPayMapList.size(); i++) {
		Map sysPayMap = (Map) sysPayMapList.get(i);
		sysPayNum++;
		//是否设置中奖率
		String getWinning = (String) sysPayMap.get("GET_WINNING") == null ? ""
				: (String) sysPayMap.get("GET_WINNING");
		//中奖率
		String winningRate = (String) sysPayMap.get("WINNING_RATE") == null ? ""
				: (String) sysPayMap.get("WINNING_RATE");
		//专款类型
		String payType = (String) sysPayMap.get("PAY_TYPE") == null ? "" : (String) sysPayMap.get("PAY_TYPE");
		//返还总金额
		String returnMoney = (String) sysPayMap.get("RETURN_MONEY") == null ? ""
				: (String) sysPayMap.get("RETURN_MONEY");
		//返还月数
		String returnMonth = (String) sysPayMap.get("RETURN_MONTH") == null ? ""
				: (String) sysPayMap.get("RETURN_MONTH");
		//返还金额
		String perMonthMoney = (String) sysPayMap.get("PER_MONTH_MONEY") == null ? ""
				: (String) sysPayMap.get("PER_MONTH_MONEY");
		//最低消费
		String limitMoney = (String) sysPayMap.get("LIMIT_MONEY") == null ? ""
				: (String) sysPayMap.get("LIMIT_MONEY");
		//返还类型
		String returnType = (String) sysPayMap.get("RETURN_TYPE") == null ? ""
				: (String) sysPayMap.get("RETURN_TYPE");//返还类型 :1 按月返还累计 2拆包  3按月返还累计加拆包 4 按月返还不累计
		//返还方式
		String returnClass = (String) sysPayMap.get("RETURN_CLASS") == null ? ""
				: (String) sysPayMap.get("RETURN_CLASS");//返还方式: 0 活动预存 1 底线预存
		//消费期限
		String consumeTime = (String) sysPayMap.get("CONSUME_TIME") == null ? ""
				: (String) sysPayMap.get("CONSUME_TIME");//消费期限2012-02-29
		//系统充值类别
		String payFlag = (String) sysPayMap.get("PAY_FLAG") == null ? "" : (String) sysPayMap.get("PAY_FLAG");
		//生效方式
		String validFlag = (String) sysPayMap.get("VALID_FLAG") == null ? ""
				: (String) sysPayMap.get("VALID_FLAG");
		String validFlagS = "";
		if ("0".equals(validFlag)) {
			validFlagS = "立即生效";
		}
		if ("1".equals(validFlag)) {
			validFlagS = "下月生效";
		}
		if ("2".equals(validFlag)) {
			validFlagS = "自定义时间";
		}
		String returnTypeS = "";
		if ("0".equals(returnType)) {
			returnTypeS = "活动预存";
		}
		if ("1".equals(returnType)) {
			returnTypeS = "底线预存";
		}
		sysPayStr.append("<tr>");
		sysPayStr.append("<td>").append(payType).append("</td>").append("<td>").append(validFlagS)
				.append("</td>").append("<td>").append(consumeTime).append("</td>").append("<td>")
				.append(returnTypeS).append("</td>").append("</tr>");
		sgetWinningStr = sgetWinningStr + split1 + getWinning;
		swinningRateStr = swinningRateStr + split1 + winningRate;
		spayTypeStr = spayTypeStr + split1 + payType;
		sreturnMoneyStr = sreturnMoneyStr + split1 + returnMoney;
		sreturnMonthStr = sreturnMonthStr + split1 + returnMonth;
		sperMonthMoneyStr = sperMonthMoneyStr + split1 + perMonthMoney;
		slimitMoneyStr = slimitMoneyStr + split1 + limitMoney;
		sreturnTypeStr = sreturnTypeStr + split1 + returnType;
		sreturnClassStr = sreturnClassStr + split1 + returnClass;
		sconsumeTimeStr = sconsumeTimeStr + split1 + consumeTime;
		spayFlagStr = spayFlagStr + split1 + payFlag;
		sassPhoneNoStr = sassPhoneNoStr + split1 + "";
		sspSystemStr = sspSystemStr + split1 + "0";
		svalidFlagStr = svalidFlagStr + split1 + validFlag;
		split1 = "#";
	}
	exStr.append("<input type='hidden' id='hid_sysPay_getWinningStr' value='").append(sgetWinningStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_winningRateStr' value='").append(swinningRateStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_payTypeStr' value='").append(spayTypeStr).append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_returnMoneyStr' value='").append(sreturnMoneyStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_returnMonthStr' value='").append(sreturnMonthStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_perMonthMoneyStr' value='").append(sperMonthMoneyStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_limitMoneyStr' value='").append(slimitMoneyStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_returnTypeStr' value='").append(sreturnTypeStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_returnClassStr' value='").append(sreturnClassStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_consumeTimeStr' value='").append(sconsumeTimeStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_payFlagStr' value='").append(spayFlagStr).append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_assPhoneNoStr' value='").append(sassPhoneNoStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_spSystemStr' value='").append(sspSystemStr)
			.append("' />");
	exStr.append("<input type='hidden' id='hid_sysPay_validFlagStr' value='").append(svalidFlagStr)
			.append("' />");
	sysPayStr.append("</table>");

	/************************积分值*******************************/
	StringBuffer scoreStr = new StringBuffer();
	scoreStr.append("<table id='table_score'>")
			.append("<tr><th>配置金额</th><th>合计赠送积分值</th><th>是否有码</th><th>串码</th><th>操作</th></tr>");

	int scoreNum = 0;
	int scoreValue = 0;
	if (scoreString != null && !"".equals(scoreString) && !"N/A".equals(scoreString)) {
		if ("140".equals(actType) && "1".equals(TEMPLET_TYPE)) {
			scoreString = resouceMon;
		}
		scoreValue = Integer.parseInt(scoreString) * 84;
		scoreNum++;
		String smspush = "<input type=\"button\" class=\"b_foot\" value=\"确认短信\" id=\"sms_push\" name=\"sms_push\" onclick=\"smsPush()\" />";
		scoreStr.append("<tr>").append("<td>").append(scoreString).append("</td>").append("<td>")
				.append(scoreValue).append("</td>");
		if ("".equals(selectMeansId) || null == selectMeansId || "null".equals(selectMeansId)) {
			scoreStr.append("<td>")
					.append("<select id=\"gift_type\" name=\"gift_type\" onchange=\"getGiftType();\"><option value='0'>请选择</option><option value='1'>有码用户</option><option value='2'>无码用户</option></select>")
					.append("</td>").append("<td>")
					.append("<input  readonly=\"readonly\" id='hid_gift_code' value=''/>").append("</td>")
					.append("<td>").append(smspush).append("</td>");
		}
		scoreStr.append("</tr>");
		scoreStr.append("<input type='hidden' id='hid_feevalue_Str' value='").append(scoreString)
				.append("' />");
		scoreStr.append("<input type='hidden' id='hid_scorevalue_Str' value='").append(scoreValue)
				.append("' />");
	}
	scoreStr.append("</table>");
	System.out.println("++++++++++++++++scoreStr:" + scoreStr);
	System.out.println("++++++++++++++++scoreNum:" + scoreNum);
	
	/*******************SP元素 START****************************/
	//add zhangxy20170505 for 关于终端类营销活动承载数据业务及优化营销管理平台BOSS侧配置选项的函
	StringBuffer tableSb = new StringBuffer();

	String spType = "";
	String spName = "";
	String spCode = "";
	String spBizCode = "";
	String spSystem = "";
	String spConsumeTime = "";
	String spValidFlag = "";
	
	int spInfoSum = spInfoMapList.size();
	if(spInfoSum>=2){
		//获取SP信息
		Map spInfoMap = (Map)spInfoMapList.get(0);
		spType = (String)spInfoMap.get("SP_TYPE");
		
		spInfoMap = (Map)spInfoMapList.get(1);
		spName = (String)spInfoMap.get("SP_NAME");
		spCode = (String)spInfoMap.get("SP_CODE");
		spBizCode = (String)spInfoMap.get("BIZ_CODE");
		spSystem = (String)spInfoMap.get("SP_SYSTEM");
		spConsumeTime = (String)spInfoMap.get("CONSUME_TIME");
		spValidFlag = (String)spInfoMap.get("VALID_FLAG");
		
		//null转""处理
		spType = (spType==null?"":spType);
		spName = (spName==null?"":spName);
		spCode = (spCode==null?"":spCode);
		spBizCode = (spBizCode==null?"":spBizCode);
		spSystem = (spSystem==null?"":spSystem);
		spConsumeTime = (spConsumeTime==null?"":spConsumeTime);
		spValidFlag = (spValidFlag==null?"":spValidFlag);
		
		//生成Table
		tableSb.append("<table id='table_sp'><tbody>");
			tableSb.append("<tr>");
				tableSb.append("<th>SP名称</th>");
				tableSb.append("<th>SP企业代码</th>");
				tableSb.append("<th>SP业务代码</th>");
			tableSb.append("</tr>");
			tableSb.append("<tr>");
				tableSb.append("<td>"+spName+"</td>");
				tableSb.append("<td>"+spCode+"</td>");
				tableSb.append("<td>"+spBizCode+"</td>");
			tableSb.append("</tr>");
		//非续签魔百盒业务需要
/* 		if(!"4".equals(spType)){
			tableSb.append("<tr>");
			tableSb.append("<td>宽带号<span style='color:red;'>(必填项)*</span>:</td>");
			tableSb.append("<td><input type='text' name='sp_netcode' id='sp_netcode' value='' /></td>");
			tableSb.append("<td><input type='button' class='b_text' name='verify' id='verify' onclick='chknetcode()' value='验证'/></td>");
		tableSb.append("</tr>");
		} */
			
		tableSb.append("</tbody></table>");
		
		//sp信息写入hidden input 中
		exStr.append("<input type='hidden' id='hid_sptype_value_Str' value='").append(spType).append("' />");
		exStr.append("<input type='hidden' id='hid_spname_value_Str' value='").append(spName).append("' />");
		exStr.append("<input type='hidden' id='hid_spcode_value_Str' value='").append(spCode).append("' />");
		exStr.append("<input type='hidden' id='hid_spbiecode_value_Str' value='").append(spBizCode).append("' />");
		exStr.append("<input type='hidden' id='hid_spsystem_value_Str' value='").append(spSystem).append("' />");
		exStr.append("<input type='hidden' id='hid_spconsumetime_value_Str' value='").append(spConsumeTime).append("' />");
		exStr.append("<input type='hidden' id='hid_spvalidflag_value_Str' value='").append(spValidFlag).append("' />");

	}

	/*******************SP元素 END****************************/
	
	//元素的数量
	exStr.append("<input type='hidden' id='feeNum' value='").append(feeNum).append("'>");
	exStr.append("<input type='hidden' id='addFeeNum' value='").append(addFeeNum).append("'>");
	exStr.append("<input type='hidden' id='fundNum' value='").append(fundNum).append("'>");
	exStr.append("<input type='hidden' id='sysPayNum' value='").append(sysPayNum).append("'>");
	exStr.append("<input type='hidden' id='spInfoNum' value='").append(spInfoSum).append("'>");

	System.out.println("++++++++++++++++sysPayStr:" + sysPayStr);
	if (feeNum > 0) {
		exStr.append(feeStr);
	}
	if (addFeeNum > 0) {
		exStr.append(addFeeStr);
	}
	if (fundNum > 0) {
		exStr.append(fundStr);
	}
	if (sysPayNum > 0) {
		exStr.append(sysPayStr);
	}
	if (scoreNum > 0) {
		exStr.append(scoreStr);
	}
	if(spInfoSum>0){
		exStr.append(tableSb.toString());
	}
	System.out.println("zhangxy templetOrderInfo.jsp exStr:" + exStr);
	out.print(exStr);
%>