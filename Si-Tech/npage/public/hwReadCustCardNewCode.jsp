<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%
/*
* 功能: 
* 版本: 1.0
* 日期: liangyl 2017/03/01 liangyl 关于实现入网人证一致性查验及调整微信补登记规则的函
* 作者: liangyl
* 版权: si-tech
*/
%>
<%
String hwAccept = request.getParameter("hwAccept")==null ? "1":request.getParameter("hwAccept");
String showBody = request.getParameter("showBody")==null ? "01":request.getParameter("showBody");
String sopcode = request.getParameter("sopcode")==null ? "":request.getParameter("sopcode");
System.out.println("liangyl==== public ==" + hwAccept + "|" + showBody+"| sopcode="+sopcode);
String workNo = (String)session.getAttribute("workNo");
String orgCode = (String)session.getAttribute("orgCode");
String groupId =(String)session.getAttribute("groupId");
String nowDatePub =new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()).toString();
String regionCode = orgCode.substring(0,2);
String reqIdCard = request.getParameter("reqIdCard")==null ? "1":request.getParameter("reqIdCard");
String reqIdName = request.getParameter("reqIdName")==null ? "1":request.getParameter("reqIdName");
String labelName = request.getParameter("labelName");

//String idType = request.getParameter("idType")==null ? "":request.getParameter("idType");
String s_idtype = request.getParameter("s_idtype")==null ? "":request.getParameter("s_idtype");
String idIccid = request.getParameter("idIccid")==null ? "":request.getParameter("idIccid");
String custName = request.getParameter("custName")==null ? "1":request.getParameter("custName");

System.out.println("liangyl====labelName====="+labelName);

System.out.println("liangyl====idIccid====="+idIccid);
System.out.println("liangyl====custName====="+custName);
/* 都展示哪些信息
		01：只展示身份证
		10：只展示附件
		11：身份证与附件都展示
*/
	String iccidInfoStyle = "";
	String accInfoStyle = "";
	if("01".equals(showBody)){
		iccidInfoStyle = "block";
		accInfoStyle = "none";
	}else if("10".equals(showBody)){
		iccidInfoStyle = "none";
		accInfoStyle = "block";
	}else{
		iccidInfoStyle = "block";
		accInfoStyle = "block";
	}

%>
<table cellspacing="0">
	<tr style="display:none;">
		<td class="blue" align="center">旧版录入身份证（第一张）</td>
		<td>
		<input type="button" style="display:none;" name="read_idCard_one1" class="b_text"   value="扫描一代身份证（旧）" onClick="RecogNewIDOnly_one(1)" >
		<input type="button" name="read_idCard_two1" class="b_text"   value="扫描二代身份证正面（旧）" onClick="RecogNewIDOnly_two(1)">
		<input type="button" name="read_idCard_two11" class="b_text"   value="扫描二代身份证背面（旧）" onClick="RecogNewIDOnly_two(11)">
		<input type="button" name="scan_idCard_two1" class="b_text"   value="读卡（旧）" onClick="Idcard(1)" > 
		<%if("1104".equals(sopcode)) {%>
		<input type="button" name="highView"  class="b_text"   value="高拍仪识读" onClick="highViewBtn(1)">
		<%}%>
		<%if(!"".equals(sopcode)) {%>		
	  <input type="button"  class="b_text"   value="上传身份证图像" onClick="sfztpsc()">
		<%}%>
		<input type="hidden" name="firstId" id="firstId" />
		<!-- 证件采集-高拍仪隐藏域 
		<input type="hidden" name="accInfoHid5" id="accInfoHid5" value=""/>
		-->
		</td>
	</tr>
	<tr style="display:none;">
		<td class="blue" align="center">旧版录入身份证（第二张）</td>
		<td>
		<input type="button" style="display:none;" name="read_idCard_one2" class="b_text"   value="扫描一代身份证（旧）" onClick="RecogNewIDOnly_one(2)" >
		<input type="button" name="read_idCard_two2" class="b_text"   value="扫描二代身份证正面（旧）" onClick="RecogNewIDOnly_two(2)">
		<input type="button" name="read_idCard_two22" class="b_text"   value="扫描二代身份证背面（旧）" onClick="RecogNewIDOnly_two(22)">
		<input type="button" name="scan_idCard_two2" class="b_text"   value="读卡（旧）" onClick="Idcard(2)" >
		<%if("1104".equals(sopcode)) {%>
		<input type="button" name="highView"  class="b_text"   value="高拍仪识读" onClick="highViewBtn(2)">
		<%}%>
		<%if(!"".equals(sopcode)) {%>
		 <input type="button"  class="b_text"   value="上传身份证图像" onClick="sfztpsc()">
		<%}%>
		<input type="hidden" name="secondId" id="secondId" />
		<font class="orange">注：只录入一张身份证不需要使用此功能</font>
		</td>
	</tr>
	<tr id='isTypesNo4' style="display:<%=iccidInfoStyle%>;">
		<td class="blue"  width=16%>证件类型录入</td>
		<td width=34%>
			<select id="card_type11" style="display:none;">
		
				<option value='1' >二代身份证</option>			
				<option value='2'>临时身份证</option>
				<option value='3'>户口本</option>
				<option value='4'>中国护照</option>
				<option value='5'>国际护照</option>
				<option value='6'>军官证（士兵证）</option>
				<option value='7'>港澳通行证</option>
				<option value='8'>港澳居民往来内地通行证</option> 
				<option value='9'>台湾居民来往大陆通行证</option>
				<option value='10'>二代证背面</option>
				<option value='11' selected>二代证RFID读取</option>
			</select>
			<input style="display:none;" type="button" id="readByMultisss1" name="readByMultisss1" class="b_text"   value="扫描证件正面（新）" onClick="readByMultiss(1)" >
			<input style="display:none;" type="button" id="readByMultisss2" name="readByMultisss2" class="b_text"   value="扫描证件背面（新）" onClick="readByMultiss(11)" >
			<input type="button" id="photoCollect1" name="photoCollect1" class="b_text"   value="证件采集-高拍仪" onClick="photoCollectAA(1)" >
		</td>	
		<td width=16% class="blue">
              <div align="left">浏览图片</div>
        </td>
        <td width=34%>
			
			<input style="display:none;" type="button" id="photoCollect3" name="photoCollect3" class="b_text"   value="人像采集-高拍仪" onClick="photoCollect33(1)" >
			<input type="button"  class="b_text"   value="上传证件图像" onClick="camsfztpscAA()">
			<font class="orange">*</font>
		</td>
	</tr>	
                <tr id='isTypesNo5' style="display:<%=iccidInfoStyle%>;">
                	<td width=16% class="blue">
                		<div align="left">成立日期</div>
                	</td>
                	<td width=34% class="blue" id="foundDateAA">
                		<input name="foundDate"  id="foundDate"  v_must="1" v_type="date"  value=""  v_minlength=4 v_maxlength=20 v_type="string" onChange="change_idType1(1)" maxlength="20"   index="11" value="" onBlur="checkElement(this)">
                		<font class="orange">*(格式YYYYMMDD)</font>&nbsp;&nbsp;
                	</td>
                	<td width=16% class="blue">
                		<div align="left">法人</div>
                	</td>
                	<td width=34% class="blue">
                		<input name="legalPerson"  id="legalPerson" v_must="1"    value=""  v_minlength=4 v_maxlength=20 v_type="string" onChange="change_idType1(2)" maxlength="20"   index="11" value="" onBlur="checkElement(this)">
                		<font class="orange">*</font>&nbsp;&nbsp;
                	</td>
                </tr>
                <tr id='isTypesNo6' style="display:<%=iccidInfoStyle%>;">
                	<td width=16% class="blue">
                		<div align="left">营业开始日期</div>
                	</td>
                	<td width=34% class="blue">
                		<input name="startDate"  id="startDate"  v_must="1" v_type="date"   value=""  v_minlength=4 v_maxlength=20 v_type="string" onChange="change_idType1(3)" maxlength="20"   index="11" value="" onBlur="checkElement(this)">
						<font class="orange">*(格式YYYYMMDD)</font>&nbsp;&nbsp;                	
                	</td>
                	<td width=16% class="blue">
                		<div align="left">营业结束日期</div>
                	</td>
                	<td width=34% class="blue">
                		<input name="endDate"  id="endDate"  v_must="1" v_type="date"   value=""  v_minlength=4 v_maxlength=20 v_type="string" onChange="change_idType1(4)" maxlength="20"   index="11" value="" onBlur="checkElement(this)">
                		<font class="orange">*(格式YYYYMMDD)</font>&nbsp;&nbsp;
                	</td>
                </tr>
                </tr>	
                <tr id='isTypesNo7' style="display:none">
                	<td width=16% class="blue">
                		<div align="left">机构类型</div>
                	</td>
                	<td width=34% class="blue">
                		<input name="legalPerson1"  id="legalPerson1"  v_must="1"    value=""  v_minlength=4 v_maxlength=20  onChange="change_idType1(5)" maxlength="20"   index="11" value="" onBlur="checkElement(this)">
                		<font class="orange">*</font>&nbsp;&nbsp;
                	</td>
                	<td width=16% class="blue">
                		
                	</td>
                	<td width=34% class="blue">
                		
                	</td>
                </tr>
                <tr id='isTypesNo8' style="display:none">
                	<td width=16% class="blue">
                		<div align="left">有效日期</div>
                	</td>
                	<td width=34% class="blue">
                		<input name="startDate1"  id="startDate1"  v_must="1" v_type="date"   value=""  v_minlength=4 v_maxlength=20 v_type="string" onChange="change_idType1(3)" maxlength="20"   index="11" value="" onBlur="checkElement(this)">
						<font class="orange">*(格式YYYYMMDD)</font>&nbsp;&nbsp;                	
                	</td>
                	<td width=16% class="blue">
                		<div align="left">失效日期</div>
                	</td>
                	<td width=34% class="blue">
                		<input name="endDate1"  id="endDate1"  v_must="1" v_type="date"  value=""  v_minlength=4 v_maxlength=20 v_type="string" onChange="change_idType1(4)" maxlength="20"   index="11" value="" onBlur="checkElement(this)">
                		<font class="orange">*(格式YYYYMMDD)</font>&nbsp;&nbsp;
                	</td>
                </tr>
	<tr style="display:none;">
		<td class="blue" align="center">新版录入证件（第二张）</td>
		<td>
			<select id="card_type22">
			
				<option value='1' >二代身份证</option>			
				<option value='2'>临时身份证</option>
				<option value='3'>户口本</option>
				<option value='4'>中国护照</option>
				<option value='5'>国际护照</option>
				<option value='6'>军官证（士兵证）</option>
				<option value='7'>港澳通行证</option>
				<option value='8'>港澳居民往来内地通行证</option> 
				<option value='9'>台湾居民来往大陆通行证</option>
				<option value='10'>二代证背面</option>
				<option value='11' selected>二代证RFID读取</option>
			</select>
			
		<input type="button" id="readByMultisss1s" name="readByMultisss1s" class="b_text"   value="扫描证件正面（新）" onClick="readByMultiss(2)" >
		<input type="button" id="readByMultisss2s" name="readByMultisss2s" class="b_text"   value="扫描证件背面（新）" onClick="readByMultiss(22)" >
		<input type="button" id="photoCollect2" name="photoCollect2" class="b_text"   value="证件采集-高拍仪" onClick="photoCollectAA(2)" >
		<font class="orange">注：只录入一张身份证不需要使用此功能</font>
		</td>
	</tr>
	<tr style="display:none;">
		<td class="blue" align="center">附件</td>
		<td>
			附件1: <input type="file" name="SCFfile1" id="SCFfile1" onchange="chcek_pic(1);" >
			<input type="button" value="清除..." onclick="SCFfile1.outerHTML=SCFfile1.outerHTML">

			<br>
			&nbsp;附件2: <input type="file" name="SCFfile2" id="SCFfile2" onchange="chcek_pic(2);" >
			<input type="button" value="清除..." onclick="SCFfile2.outerHTML=SCFfile2.outerHTML">
			<br>
			&nbsp;附件3: <input type="file" name="SCFfile3" id="SCFfile3" onchange="chcek_pic(3);" >
			<input type="button" value="清除..." onclick="SCFfile3.outerHTML=SCFfile3.outerHTML">
			<br>
			&nbsp;附件4: <input type="file" name="SCFfile4" id="SCFfile4" onchange="chcek_pic(4);" >
			<input type="button" value="清除..." onclick="SCFfile4.outerHTML=SCFfile4.outerHTML">
			<br>
			注意：附件上传格式为.jpg或.jpeg或.bmp三种格式，附件大小不能超过2M。
			<input type="hidden" name="accInfoHid1" id="accInfoHid1" />
			<input type="hidden" name="accInfoHid2" id="accInfoHid2" />
			<input type="hidden" name="accInfoHid3" id="accInfoHid3" />
			<input type="hidden" name="accInfoHid4" id="accInfoHid4" />
			<input type="text" name="accInfoHid5" id="accInfoHid5" />
		</td>
	</tr>
</table>

<script language="JavaScript">	
	
	var sfznamess="";
	var sfzcodess="";
	var sfzIDaddressss="";
	var sfzbir_dayss="";
	var sfzsexss="";
	var sfzidValidDate_objss="";
	var sfzpicturespathss="";
	var sfzhaoma="";
	var sfzleixing="";
	var sfzminzu="";
	
	sfzhaoma = "<%=reqIdCard%>";
	sfznamess = "<%=reqIdName%>";
	alert("<%=sopcode%>");
	
	
	
	var picpath_n2 = "";
	var picpath_bei2 = "";
	function change_idType1(num){
		if(num==1){
	    	if((document.all.foundDate.value).trim().length != 8)
			{
				rdShowMessageDialog("请按正确格式输入");
				document.all.foundDate.focus();
				return false;
			}
	    }
		if(num==3){
			if((document.all.startDate.value).trim().length != 8)
			{
				rdShowMessageDialog("请按正确格式输入");
				document.all.startDate.focus();
				return false;
			}
		}
		if(num==4){
			if((document.all.endDate.value).trim().length != 8)
			{
				rdShowMessageDialog("请按正确格式输入");
				document.all.endDate.focus();
				return false;
			}
		}
		if(num==5){
			
		}
   
	}
	function change_onBlur(){
		var foundDate =  $('#foundDate').val();
		
	}
	function RecogNewIDOnly_two(cardnum)
	{
		//扫描二代身份证
		var fso = new ActiveXObject("Scripting.FileSystemObject");  //取系统文件对象
		tmpFolder = fso.GetSpecialFolder(0); //取得系统安装目录
		var strtemp= tmpFolder+"";
		var filep1 = strtemp.substring(0,1)//取得系统目录盘符
		var cre_dir = filep1+":\\custID";//创建目录
		if(!fso.FolderExists(cre_dir)) {
			var newFolderName = fso.CreateFolder(cre_dir);
		}
		try{
			if(objIDCard.LibIsLoaded()){

				if(cardnum==1){
					picpath_n2="";
					objIDCard.ImageFileName =  cre_dir + "\\hw_<%=hwAccept%>_pic.jpg";
					picpath_n2 = cre_dir + "\\hw_<%=hwAccept%>_pic.jpg";
				}else if(cardnum==2){
					picpath_n2="";
					objIDCard.ImageFileName =  cre_dir + "\\hw_<%=hwAccept%>_pic2.jpg";
					picpath_n2 = cre_dir + "\\hw_<%=hwAccept%>_pic2.jpg";
				}else if(cardnum==11) {
					picpath_bei2="";
					objIDCard.ImageFileName =  cre_dir + "\\hw_<%=hwAccept%>_pic11.jpg";
					picpath_bei2 = cre_dir + "\\hw_<%=hwAccept%>_pic11.jpg";
				}
				else if(cardnum==22){
					picpath_bei2="";
					objIDCard.ImageFileName =  cre_dir + "\\hw_<%=hwAccept%>_pic22.jpg";
					picpath_bei2 = cre_dir + "\\hw_<%=hwAccept%>_pic22.jpg";
				}
				
				objIDCard.SaveResultFile = true;
				objIDCard.Content = 63;
				if(objIDCard.RecogNewIDCardALL()){
					rdShowMessageDialog("扫描成功！",2);
					if(cardnum==1){
						$("#firstId").val(picpath_n2+"|"+picpath_bei2+"|");
					}else if(cardnum==2){
						$("#secondId").val(picpath_n2+"|"+picpath_bei2+"|");
					}else if(cardnum==11) {
						$("#firstId").val(picpath_n2+"|"+picpath_bei2+"|");
					}else if(cardnum==22) {
						$("#secondId").val(picpath_n2+"|"+picpath_bei2+"|");
					}					
				}			
			}
			else
			{
				rdShowMessageDialog( objIDCard.GetLastErrorInfo(),0 );
			}
		}catch(e){
			rdShowMessageDialog("未连接扫描仪！",0);
		}
	}
	
	function RecogNewIDOnly_one(cardnum)
	{
		//扫描一代身份证
		var fso = new ActiveXObject("Scripting.FileSystemObject");  //取系统文件对象
		tmpFolder = fso.GetSpecialFolder(0); //取得系统安装目录
		var strtemp= tmpFolder+"";
		var filep1 = strtemp.substring(0,1)//取得系统目录盘符
		var cre_dir = filep1+":\\custID";
		if(!fso.FolderExists(cre_dir)) {
			var newFolderName = fso.CreateFolder(cre_dir);
		}
		try{	
			if( objIDCard.LibIsLoaded() )
			{
				var picpath_n = "";
				if(cardnum==1){
					objIDCard.ImageFileName =  cre_dir + "\\hw_<%=hwAccept%>_pic.jpg";
					picpath_n = cre_dir + "\\hw_<%=hwAccept%>_pic.jpg";
				}else if(cardnum==2){
					objIDCard.ImageFileName =  cre_dir + "\\hw_<%=hwAccept%>_pic2.jpg";
					picpath_n = cre_dir + "\\hw_<%=hwAccept%>_pic2.jpg";
				}else if(cardnum==3){
					objIDCard.ImageFileName =  cre_dir + "\\hw_<%=hwAccept%>_pic3.jpg";
					picpath_n = cre_dir + "\\hw_<%=hwAccept%>_pic3.jpg";
				}else if(cardnum==4){
					objIDCard.ImageFileName =  cre_dir + "\\hw_<%=hwAccept%>_pic4.jpg";
					picpath_n = cre_dir + "\\hw_<%=hwAccept%>_pic4.jpg";
				}else if(cardnum==5){
					objIDCard.ImageFileName =  cre_dir + "\\hw_<%=hwAccept%>_pic5.jpg";
					picpath_n = cre_dir + "\\hw_<%=hwAccept%>_pic5.jpg";
				}else if(cardnum==6){
					objIDCard.ImageFileName =  cre_dir + "\\hw_<%=hwAccept%>_pic6.jpg";
					picpath_n = cre_dir + "\\hw_<%=hwAccept%>_pic6.jpg";
				}
				
				objIDCard.SaveResultFile = true;
				objIDCard.Content = 63;
				if( objIDCard.RecogIDCardExALL() ){
					
					rdShowMessageDialog("扫描成功！",2);
					/* ningtn 将路径记录下来 */
					if(cardnum==1){
						$("#firstId").val(picpath_n);
					}else if(cardnum==2){
						$("#secondId").val(picpath_n);
					}else if(cardnum==3){
						$("#accInfoHid1").val(picpath_n);
					}else if(cardnum==4){
						$("#accInfoHid2").val(picpath_n);
					}else if(cardnum==5){
						$("#accInfoHid3").val(picpath_n);
					}else if(cardnum==6){
						$("#accInfoHid4").val(picpath_n);
					}
				}
			}
			else
			{
				rdShowMessageDialog( objIDCard.GetLastErrorInfo() ,0);
			}
		}catch(e){
			rdShowMessageDialog("未连接扫描仪！",0);
		}
	}

	

	
	function Idcard(cardnum)
	{		
		//读取二代身份证
		var fso = new ActiveXObject("Scripting.FileSystemObject");  //取系统文件对象
		tmpFolder = fso.GetSpecialFolder(0); //取得系统安装目录
		var strtemp= tmpFolder+"";
		var filep1 = strtemp.substring(0,1)//取得系统目录盘符
		var cre_dir = filep1+":\\custID";//创建目录
		if(!fso.FolderExists(cre_dir)) {	
			var newFolderName = fso.CreateFolder(cre_dir);  
		}
		
		var picpath_n ;
		if(cardnum==1){
			picpath_n = cre_dir + "\\hw_<%=hwAccept%>_pic.jpg";
		}else if(cardnum==2){
			picpath_n = cre_dir + "\\hw_<%=hwAccept%>_pic2.jpg";
		}
		
		
		var result;
		var result2;
		var result3;
		var username;
		
		sfznamess="";
		sfzcodess="";
		sfzIDaddressss="";
		sfzbir_dayss="";
		sfzsexss="";
		sfzidValidDate_objss="";
		sfzpicturespathss="";
		
		result=IdrControl1.InitComm("1001");
		if (result==1)
		{
			result2=IdrControl1.Authenticate();
			if ( result2>0)
			{              
				result3=IdrControl1.ReadBaseMsgP(picpath_n); 
				if (result3>0)           
				{
				  var name = IdrControl1.GetName();
					var code =  IdrControl1.GetCode();
					var sex = IdrControl1.GetSex();
					var bir_day = IdrControl1.GetBirthYear() + "" + IdrControl1.GetBirthMonth() + "" + IdrControl1.GetBirthDay();
					var IDaddress  =  IdrControl1.GetAddress();
					var idValidDate_obj = IdrControl1.GetValid();
					
					try{
						
						var aa= idValidDate_obj+"";
					  if(aa.indexOf("长期") !=-1) {
					  	/*啥也不干*/
					  	//$("#idValidDate").val("21000101");
					  }else {				  
							  var bb=aa.substring(11,21);
								var cc = bb.replace("\.","");
								var dd = cc.replace("\.","");
								/*dd就是身份证有效期*/
							  //$("#idValidDate").val(dd+"");
								  if(Number("<%=nowDatePub%>") > Number(dd)){
								  	rdShowMessageDialog("证件有效期至：["+Number(dd)+"],证件已过期，不允许办理!");
								  	return false;
								  }
							}
			
						var iccidFilePath = "";
						var iccidfile ; 
						if(cardnum==1){
							iccidfile = fso.CreateTextFile(cre_dir + "\\hw_<%=hwAccept%>_str.txt",true); 
							iccidFilePath = cre_dir + "\\hw_<%=hwAccept%>_str.txt";
						}else if(cardnum==2){
							iccidfile = fso.CreateTextFile(cre_dir + "\\hw_<%=hwAccept%>_str2.txt",true); 
							iccidFilePath = cre_dir + "\\hw_<%=hwAccept%>_str2.txt";
						}
					  iccidfile.WriteLine(name+"|"+code+"|"+IDaddress+"|"+bir_day+"|"+sex+"|"+idValidDate_obj);		
					  		  
					  	 sfznamess=name;
							 sfzcodess=code;
							 sfzIDaddressss=IDaddress;
							 sfzbir_dayss=bir_day;
							 sfzsexss=sex;
							 sfzidValidDate_objss=idValidDate_obj;
							 sfzpicturespathss=picpath_n;
							 
					  iccidfile.Close();
					}catch(e){
						alert("读取二代身份证异常！");
						
					}
					rdShowMessageDialog("读取二代身份证成功！",2);
					/* ningtn 将路径记录下来 */
					if(cardnum==1){
						$("#firstId").val(picpath_n + "||" + iccidFilePath);
					}else if(cardnum==2){
						$("#secondId").val(picpath_n + "||" + iccidFilePath);
					}
			
				}
				else
				{
					rdShowMessageDialog(result3); 
					IdrControl1.CloseComm();
				}
			}
			else
			{
				IdrControl1.CloseComm();
				rdShowMessageDialog("请重新将卡片放到读卡器上");
			}
		}
		else
		{
			IdrControl1.CloseComm();
			rdShowMessageDialog("端口初始化不成功",0);
		}
		IdrControl1.CloseComm();
	}
	
	/*2014/12/01 9:05:53 gaopeng 高拍仪识读按钮*/
  function highViewBtn(cardnum){
  	
  	/*2014/12/04 9:38:18 gaopeng 高拍仪识读 */
  	var fso = new ActiveXObject("Scripting.FileSystemObject");  //取系统文件对象
		tmpFolder = fso.GetSpecialFolder(0); //取得系统安装目录
		var strtemp= tmpFolder+"";
		var filep1 = strtemp.substring(0,1)//取得系统目录盘符
		var cre_dir = filep1+":\\custID";//创建目录
		if(!fso.FolderExists(cre_dir)) {	
			var newFolderName = fso.CreateFolder(cre_dir);  
		}
		
		/*图片路径*/
		var picpath_n ;
		/*
		if(cardnum==1){
			picpath_n = cre_dir + "\\hw_<%=hwAccept%>_pic.jpg";
		}else if(cardnum==2){
			picpath_n = cre_dir + "\\hw_<%=hwAccept%>_pic2.jpg";
		}*/
		
  	
  	var card_type11 = $("select[name = 'card_type11']").find("option:selected").val();
  	var card_type22 = $("select[name = 'card_type22']").find("option:selected").val();
  	
  	
  	
  	
  	//调用代码示例：
		var sys_accept="<%=hwAccept%>";
		var phone_no="<%=hwAccept%>";
		var org_info="<%=groupId%>";
		var work_no="<%=workNo%>";
		
		//模拟form表单post数据
		var xmlStr= "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+
								"<req>"+
									"<sys_accept>"+sys_accept+"</sys_accept>"+
									"<phone_no>"+phone_no+"</phone_no>"+
									"<org_info>"+org_info+"</org_info>"+
									"<work_no>"+work_no+"</work_no>"+
								"</req>";
		//模拟返回报文			
		/*			
		var	retStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
								+"<resp>"
								+"<name>莫小文</name>"
								+"<e_name>Lora</e_name>"
								+"<sex>女</sex>"
								+"<nation>中国</nation>"
								+"<ethnic>汉</ethnic>"
								+"<birthday>19880517</birthday>"
								+"<address>四川省成都市</address>"
								+"<card_no>21310019880517XXXX</card_no>"
								+"<issue_org>青羊公安局</issue_org>"
								+"<issue_date>20060501</issue_date>"
								+"<b_valid_date>20060501</b_valid_date>"
								+"<e_valid_date>20160501</e_valid_date>"
								+"<iccid_path>C:/custID/hw_98765432_pic.jpg</iccid_path>"
								+"</resp>";
		
		window.clipboardData.setData("text",retStr);
		*/
		//访问
		window.showModalDialog("http://10.110.0.100:59000/bp095.go?method=crmOCR&xmlStr="+xmlStr);
		//获取反馈报文解析，自动填入表单
		var authinfo = window.clipboardData.getData("text");
		//alert("返回报文--------"+authinfo);
		var xmlDoc = loadXML(authinfo);
		//获取到resp节点
 		var elementsXml = xmlDoc.getElementsByTagName("resp");
 
 		//开始循环节点
		for (var i = 0; i < elementsXml.length; i++) {
			
      //姓名
      var namea = elementsXml[i].getElementsByTagName("name")[0].firstChild.nodeValue;
      alert(namea);
      //英文姓名
      var e_name = elementsXml[i].getElementsByTagName("e_name")[0].firstChild.nodeValue;
      //性别
      var sex = elementsXml[i].getElementsByTagName("sex")[0].firstChild.nodeValue;
      //国籍
      var nation = elementsXml[i].getElementsByTagName("nation")[0].firstChild.nodeValue;
      //民族
      var ethnic = elementsXml[i].getElementsByTagName("ethnic")[0].firstChild.nodeValue;
      //出生日期
      var birthday = elementsXml[i].getElementsByTagName("birthday")[0].firstChild.nodeValue;
      //地址
      var address = elementsXml[i].getElementsByTagName("address")[0].firstChild.nodeValue;
      //证件号码
      var card_no = elementsXml[i].getElementsByTagName("card_no")[0].firstChild.nodeValue;
      //颁发机关
      var issue_org = elementsXml[i].getElementsByTagName("issue_org")[0].firstChild.nodeValue;
      //颁发日期
      var issue_date = elementsXml[i].getElementsByTagName("issue_date")[0].firstChild.nodeValue;
      //开始有效期
      var b_valid_date = elementsXml[i].getElementsByTagName("b_valid_date")[0].firstChild.nodeValue;
      //结束有效期
      var e_valid_date = elementsXml[i].getElementsByTagName("e_valid_date")[0].firstChild.nodeValue;
      //证件头像路径
      var iccid_path = elementsXml[i].getElementsByTagName("v_iccid_path")[0].firstChild.nodeValue;
      
      /*图片路径赋值*/
      picpath_n = iccid_path;
      
      try{
				var iccidFilePath = "";
				var iccidfile ; 
				if(cardnum==1){
					iccidfile = fso.CreateTextFile(cre_dir + "\\hw_<%=hwAccept%>_str.txt",true); 
					iccidFilePath = cre_dir + "\\hw_<%=hwAccept%>_str.txt";
				}else if(cardnum==2){
					iccidfile = fso.CreateTextFile(cre_dir + "\\hw_<%=hwAccept%>_str2.txt",true); 
					iccidFilePath = cre_dir + "\\hw_<%=hwAccept%>_str2.txt";
				}
			  iccidfile.WriteLine(namea+"|"+card_no+"|"+address+"|"+birthday+"|"+sex+"|"+e_valid_date);		
					 
			  iccidfile.Close();
			}catch(e){
				alert("高拍仪读取二代身份证异常！");
			}
			rdShowMessageDialog("高拍仪读取二代身份证成功！",2);
			/* gaopeng 将路径记录下来 */
			if(cardnum==1){
				$("#firstId").val(picpath_n + "||" + iccidFilePath);
			}else if(cardnum==2){
				$("#secondId").val(picpath_n + "||" + iccidFilePath);
			}
		
		}
  	
  }
  
  /*2014/12/01 9:05:53 gaopeng 证件采集-高拍仪按钮*/
  function photoCollect33(cardnum){
  
		/*图片路径*/
		var picpath_n ;
		
		//访问
		window.showModalDialog("http://10.110.0.100:59000/workflow/camera/getCamera.jsp");
		//window.showModalDialog("http://10.110.13.52:8899/debug/crmDemo.html");
		//获取反馈报文解析，自动填入表单
		var authinfo = window.clipboardData.getData("text");
		alert("返回文件名--------"+authinfo);
		authinfo = $.trim(authinfo);
		/*增加全路径*/
		authinfo = "c:/bmp/"+authinfo;
		alert(authinfo+"全部");
		
		campicpath_n=authinfo;
		alert(campicpath_n);
		var accInfoHid4 = $("#accInfoHid4").val();
		alert(accInfoHid4);
		var infoArray = new Array();
		infoArray = accInfoHid4.split("|");
		/*没有拼接影像图片*/
		if(infoArray.length == 1){
				/*第一个图片*/
				if(cardnum == 1){
					accInfoHid4  = infoArray[0]+"|"+authinfo+"|";
				}
				/*第二个图片拼接到第三个值中*/
				else if(cardnum == 2){
					accInfoHid4  = infoArray[0]+"||"+authinfo;
				}
		}
		else if(infoArray.length == 3){
				/*第一个图片*/
				if(cardnum == 1){
					accInfoHid4 = infoArray[0]+"|"+authinfo+"|"+infoArray[2];
				}
				/*第二个图片拼接到第三个值中*/
				else if(cardnum == 2){
					accInfoHid4 = infoArray[0]+"|"+infoArray[1]+"|"+authinfo;
				}
		}
		
		$("#accInfoHid4").val(accInfoHid4);
		//alert($("#accInfoHid4").val());
  }
  var campicpath_n = "";
  var campicname="";
  function photoCollectAA(cardnum){
	  //$('#foundDate').attr('disabled','disabled');
	  //$('#foundDate').attr('readonly':'readonly');
	  //$("#foundDate").attr(readonly:readonly);
	  //$("#foundDate").attr({ readonly: '' });
	  $('#foundDate').attr('readonly','readonly');
	  alert($('#foundDate').attr('readonly','readonly'));
		/*图片路径*/
		var picpath_n ;
		alert("111111--------"); 
		//访问
		window.showModalDialog("http://10.110.0.100:59000/workflow/camera/getCamera.jsp");
		//window.showModalDialog("http://10.110.13.52:8899/debug/crmDemo.html");
		//获取反馈报文解析，自动填入表单
		var authinfo = window.clipboardData.getData("text");
		authinfo = "20170301202249.jpg";
		alert("返回文件名111111--------"+authinfo);
						
		/*增加全路径*/
		authinfo = "C:/bmp/"+authinfo;
		$("#accInfoHid5").val(authinfo);
		campicpath_n=authinfo;
		alert(campicpath_n);
		
  }
		//将图片上传到数据库中
		function sfztpsc() {
			var v_custId = "";	
			if("<%=sopcode%>"=="1231" || "<%=sopcode%>"=="1230" || "<%=sopcode%>"=="1210" || "<%=sopcode%>"=="1234" || "<%=sopcode%>"=="1235"){
				v_custId = $("#cus_id").val();
			}else if("<%=sopcode%>"=="m058" || "<%=sopcode%>"=="1238"){
				v_custId = $("#new_cus_id").val();
			}else{ //opcode不能包含字母！现此条件适用于1211,1220情况
				v_custId = "<%=sopcode%>";
			}
			window.open("/npage/public/cardInfoSave.jsp?name="+sfznamess+"&code="+sfzcodess+"&IDaddress="+sfzIDaddressss+"&bir_day="+sfzbir_dayss+"&sex="+sfzsexss+"&idValidDate_obj="+sfzidValidDate_objss+"&picpath_n="+sfzpicturespathss+"&opcodes=<%=sopcode%>&v_custId="+v_custId,"","width="+(screen.availWidth*1-900)+",height="+(screen.availHeight*1-570) +",left=450,top=240,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no");
	 }
	 
	 //将图片上传到数据库中
		function camsfztpscAA() {
			var idType = "";
			
			if("<%=sopcode%>"=="i067" || "<%=sopcode%>"=="m349"){
				idType = $("#idTypeSelect").val();//证件类型,picpath_n路径idTypeSelect
				alert(idType);
				idType = idType.split("|")[0];
				if(idType==8){
					var legalPerson = $('#legalPerson').val();//法人
					var foundDate = $('#foundDate').val();//成立日期 
					var startDate = $('#startDate').val();//开始时间
					var endDate = $('#endDate').val();//失效时间
				}else if(idType=="A"){
					var legalPerson = $('#legalPerson1').val();
					var foundDate = $('#foundDate').val();//机构类型
					var startDate = $('#startDate1').val();//开始时间
					var endDate = $('#endDate1').val();//失效时间
				}
				alert(legalPerson+":"+foundDate+":"+startDate+":"+endDate+":"+idType);
				window.open("/npage/public/camCardInfoSaveCode.jsp?legalPerson="+legalPerson+"&idType="+idType+"&sopcode=<%=sopcode%>&regionCode=<%=regionCode%>&workno=<%=workNo%>&foundDate="+foundDate+"&startDate="+startDate+"&picpath_n="+campicpath_n+"&endDate="+endDate,"","width="+(screen.availWidth*1-900)+",height="+(screen.availHeight*1-570) +",left=450,top=240,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no");

			}else if("<%=sopcode%>"=="g049"  ) {
				idType = $("#s_idtype").val();//证件类型,picpath_n路径				
				if(idType==8){
					var legalPerson = $('#legalPerson').val();//法人
					var foundDate = $('#foundDate').val();//成立日期 
					var startDate = $('#startDate').val();//开始时间
					var endDate = $('#endDate').val();//失效时间
				}else if(idType=="A"){
					var legalPerson = $('#legalPerson1').val();
					var foundDate = $('#foundDate').val();//机构类型
					var startDate = $('#startDate1').val();//开始时间
					var endDate = $('#endDate1').val();//失效时间
				}
				alert(legalPerson+":"+foundDate+":"+startDate+":"+endDate+":"+idType);
				window.open("/npage/public/camCardInfoSaveCode.jsp?legalPerson="+legalPerson+"&idType="+idType+"&sopcode=<%=sopcode%>&regionCode=<%=regionCode%>&workno=<%=workNo%>&foundDate="+foundDate+"&startDate="+startDate+"&picpath_n="+campicpath_n+"&endDate="+endDate,"","width="+(screen.availWidth*1-900)+",height="+(screen.availHeight*1-570) +",left=450,top=240,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no");

			}else if("<%=sopcode%>"=="m389" || "<%=sopcode%>"=="m058" || "<%=sopcode%>"=="1238") {
				idType = $("#idType").val();//证件类型,picpath_n路径
				idType = idType.split("|")[0];
				if(idType==8){
					var legalPerson = $('#legalPerson').val();//法人
					var foundDate = $('#foundDate').val();//成立日期 
					var startDate = $('#startDate').val();//开始时间
					var endDate = $('#endDate').val();//失效时间
				}else if(idType=="A"){
					var legalPerson = $('#legalPerson1').val();
					var foundDate = $('#foundDate').val();//机构类型
					var startDate = $('#startDate1').val();//开始时间
					var endDate = $('#endDate1').val();//失效时间
				}
				alert(legalPerson+":"+foundDate+":"+startDate+":"+endDate+":"+idType);
				window.open("/npage/public/camCardInfoSaveCode.jsp?legalPerson="+legalPerson+"&idType="+idType+"&sopcode=<%=sopcode%>&regionCode=<%=regionCode%>&workno=<%=workNo%>&foundDate="+foundDate+"&startDate="+startDate+"&picpath_n="+campicpath_n+"&endDate="+endDate,"","width="+(screen.availWidth*1-900)+",height="+(screen.availHeight*1-570) +",left=450,top=240,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no");
			}else if("<%=sopcode%>"=="1993" ||  "<%=sopcode%>"=="1100" ) {
				idType = document.all.idType.value;
				//idType = $("#idTypeSelect").val();//证件类型,picpath_n路径idTypeSelect
				alert(idType);
				idType = idType.split("|")[0];
				if(idType==8){
					var legalPerson = $('#legalPerson').val();//法人
					var foundDate = $('#foundDate').val();//成立日期 
					var startDate = $('#startDate').val();//开始时间
					var endDate = $('#endDate').val();//失效时间
				}else if(idType=="A"){
					var legalPerson = $('#legalPerson1').val();
					var foundDate = $('#foundDate').val();//机构类型
					var startDate = $('#startDate1').val();//开始时间
					var endDate = $('#endDate1').val();//失效时间
				}
				alert(legalPerson+":"+foundDate+":"+startDate+":"+endDate+":"+idType);
				window.open("/npage/public/camCardInfoSaveCode.jsp?legalPerson="+legalPerson+"&idType="+idType+"&sopcode=<%=sopcode%>&regionCode=<%=regionCode%>&workno=<%=workNo%>&foundDate="+foundDate+"&startDate="+startDate+"&picpath_n="+campicpath_n+"&endDate="+endDate,"","width="+(screen.availWidth*1-900)+",height="+(screen.availHeight*1-570) +",left=450,top=240,resizable=yes,scrollbars=yes,status=yes,location=no,menubar=no");

			}
			
			
			
				 }
	
	function chcek_pic(num)//附件
{

var pic_path = $("#SCFfile" + num).val();	
var d_num = pic_path.indexOf("\.");
var d_numname = pic_path.lastIndexOf("\\");
var file_type = pic_path.substring(d_num+1,pic_path.length);
var file_names = pic_path.substring(d_numname+1,pic_path.length);


if(file_type.toUpperCase()=="JPG" || file_type.toUpperCase()=="JPEG" || file_type.toUpperCase()=="BMP")
{ 

		var fso = new ActiveXObject("Scripting.FileSystemObject");  //取系统文件对象
		tmpFolder = fso.GetSpecialFolder(0); //取得系统安装目录
		var strtemp= tmpFolder+"";
		var filep1 = strtemp.substring(0,1)//取得系统目录盘符
		var cre_dir = filep1+":\\custID";//创建目录
		var   fsss   =   fso.GetFile(pic_path);
		var fileSize = fsss.size; 
		var fileSizeKb = fileSize/1024;//转换为kb
		var filelujing="";
		var iccidfile ;
		if(parseFloat(fileSizeKb)>parseFloat(2048)){
		rdShowMessageDialog("附件大小不能超过2M，请重新上传！");
	  return ;		
		}
		
		
		if(!fso.FolderExists(cre_dir)) {	
			var newFolderName = fso.CreateFolder(cre_dir);  			
		}

		filelujing=cre_dir+"\\"+file_names;
		
		fsss.Copy(filelujing);
		//alert(num); 
		if(num != 4){
			$("#accInfoHid" + num).val(filelujing);
		}
		if(num == 4){
			//alert(611);
			var accInfoHid4 =  $("#accInfoHid4").val();
			var infoArray = new Array();
			infoArray = accInfoHid4.split("|");
			//alert(infoArray.length);
			/*还没拼接图片信息呢*/
			if(infoArray.length == 1){
				$("#accInfoHid4").val(filelujing);
			}
			/*拼接了就需要重新组装*/
			else if(infoArray.length != 1){
				$("#accInfoHid4").val(filelujing+"|"+infoArray[1]+"|"+infoArray[2]);
			}
		}
		
	}
else {
		rdShowMessageDialog("请选择jpg或jpeg或bmp类型文件");
		document.getElementById("SCFfile"+num).outerHTML =document.getElementById("SCFfile"+num).outerHTML;
	  return ;
}

			
	}
	/*wanghyd20130926增加新版二代扫描程序*/
	
	var picpath_n2new = "";
	var picpath_bei2new = "";
	
	function readByMultiss(str){
			//扫描二代身份证
		var fso = new ActiveXObject("Scripting.FileSystemObject");  //取系统文件对象
		tmpFolder = fso.GetSpecialFolder(0); //取得系统安装目录
		var strtemp= tmpFolder+"";
		var filep1 = strtemp.substring(0,1)//取得系统目录盘符
		var cre_dir = filep1+":\\custID";//创建目录
		if(!fso.FolderExists(cre_dir)) {
			var newFolderName = fso.CreateFolder(cre_dir);
		}
	
	var ret_open=CardReader_CMCC.MutiIdCardOpenDevice(1000);
	
	if(ret_open!=0){
		ret_open=CardReader_CMCC.MutiIdCardOpenDevice(1001);
	}	
	if(ret_open==0){
		var cardType="";
			if(str==1 || str==11) {
					cardType = document.getElementById("card_type11").value ;	
			}
			if(str==2 || str==22) {
					cardType = document.getElementById("card_type22").value ;	
			}
		
		if(cardType==11){
			//多功能设备RFID读取
			sfznamess="";
			sfzcodess="";
			sfzIDaddressss="";
			sfzbir_dayss="";
			sfzsexss="";
			sfzidValidDate_objss="";
			sfzpicturespathss="";
			sfzhaoma="";
			sfzleixing="";
			sfzminzu="";
			var ret_getImageMsg=CardReader_CMCC.MutiIdCardGetImageMsg(cardType,"c:\\custID\\cert_head_<%=hwAccept%>"+str+".jpg");
			if(ret_getImageMsg==0){

				//二代证正反面合成
				var xm =CardReader_CMCC.MutiIdCardName;;//"测试";//
				var xb =CardReader_CMCC.MutiIdCardSex;//"1";//
				var mz =CardReader_CMCC.MutiIdCardPeople;//"汉";//
				var cs =CardReader_CMCC.MutiIdCardBirthday;//"1985.01.01";//
				var yx =CardReader_CMCC.MutiIdCardSigndate+"-"+CardReader_CMCC.MutiIdCardValidterm;//"1992.01.01-2020.01.01";//
				var yxks=CardReader_CMCC.MutiIdCardSigndate;//"1992.01.01";//有效开始时间
				var yxqx=CardReader_CMCC.MutiIdCardValidterm;//"2020.01.01";//证件有效期
				var zz =CardReader_CMCC.MutiIdCardAddress;//"黑龙江省哈尔滨市";//
				var qfjg =CardReader_CMCC.MutiIdCardOrgans;//"黑龙江省哈尔滨市公安分局";////签发机关
				var zjhm =CardReader_CMCC.MutiIdCardNumber;//"230102198501010512";////证件号码
				var base64 =CardReader_CMCC.MutiIdCardPhoto;
				var mblj=cre_dir+"cert_model.bmp";
				var sclj=cre_dir+"cert_<%=hwAccept%>_pic.jpg";
				
				
				sfznamess=xm;
				sfzcodess="<%=sopcode%>";
				sfzIDaddressss=zz;
				sfzbir_dayss=cs;
				sfzsexss=xb;
				sfzidValidDate_objss=yxqx;
				sfzpicturespathss="";
				sfzhaoma=zjhm;
				sfzminzu=mz;
				//var ret_cardEmerg=CardReader_CMCC.CardEmerg(xm,xb,mz,cs,yx,zz,qfjg,zjhm,base64,mblj,sclj);			
						try{
							var iccidfile ; 
							iccidfile = fso.CreateTextFile(cre_dir + "\\hw_<%=hwAccept%>_str"+str+".txt",true);
							iccidfile.WriteLine(xm+"|"+zjhm+"|"+zz+"|"+cs+"|"+xb+"|"+yx);			  
					    iccidfile.Close();
					    rdShowMessageDialog("扫描成功！",2);
					  	}catch(e){
						 alert("读取二代身份证异常！");
					}
					
							var picpath_n ;
							var picpath_n2 ;
							if(str==1 || str==11) {
							picpath_n = cre_dir+"\\cert_head_<%=hwAccept%>"+str+".jpg";
							$("#firstId").val(picpath_n + "||" + cre_dir+"\\hw_<%=hwAccept%>_str"+str+".txt");
							}
							if(str==2 || str==22) {
							picpath_n2 = cre_dir+"\\cert_head_<%=hwAccept%>"+str+".jpg";
							$("#secondId").val(picpath_n2 + "||" + cre_dir+"\\hw_<%=hwAccept%>_str"+str+".txt");
							}
							
			}else{
					rdShowMessageDialog("获取信息失败");
					return ;
			}
		}else{
			//多功能设备OCR读取
			var ret_getImageMsg=CardReader_CMCC.MutiIdCardGetImageMsg(cardType,"c:\\custID\\cert_<%=hwAccept%>"+str+".jpg");
			
				if(str==1){
					picpath_n2new="";
					picpath_n2new = "c:\\custID\\cert_<%=hwAccept%>1.jpg";
				}else if(str==2){
					picpath_n2new="";
					picpath_n2new = "c:\\custID\\cert_<%=hwAccept%>2.jpg";
				}else if(str==11) {
					picpath_bei2new="";
					picpath_bei2new = "c:\\custID\\cert_<%=hwAccept%>11.jpg";
				}
				else if(str==22){
					picpath_bei2new="";
					picpath_bei2new = "c:\\custID\\cert_<%=hwAccept%>22.jpg";
				}
								
					rdShowMessageDialog("扫描成功！",2);
					if(str==1){
						$("#firstId").val(picpath_n2new+"|"+picpath_bei2new+"|");
					}else if(str==2){
						$("#secondId").val(picpath_n2new+"|"+picpath_bei2new+"|");
					}else if(str==11) {
						$("#firstId").val(picpath_n2new+"|"+picpath_bei2new+"|");
					}else if(str==22) {
						$("#secondId").val(picpath_n2new+"|"+picpath_bei2new+"|");
					}	

		}
	}else{
					rdShowMessageDialog("打开设备失败");
					return ;
	}
	//关闭设备
	var ret_close=CardReader_CMCC.MutiIdCardCloseDevice();
	if(ret_close!=0){
							rdShowMessageDialog("关闭设备失败");
					return ;
	}
	
}



	function returnSubState(labelName,result){
		if(result=="0"){
			rdShowMessageDialog("人像校验通过!");
		}
		else{
			rdShowMessageDialog("人像校验未通过!");
		}
		$("#"+labelName).val(result);
	}
</script>

<script type='text/javascript'>
	/*2014/12/01 14:33:13 gaopeng 加入loadXML方法*/
    loadXML = function(xmlString){
        var xmlDoc=null;
        //判断浏览器的类型
        //支持IE浏览器 
        if(!window.DOMParser && window.ActiveXObject){   //window.DOMParser 判断是否是非ie浏览器
            var xmlDomVersions = ['MSXML.2.DOMDocument.6.0','MSXML.2.DOMDocument.3.0','Microsoft.XMLDOM'];
            for(var i=0;i<xmlDomVersions.length;i++){
                try{
                    xmlDoc = new ActiveXObject(xmlDomVersions[i]);
                    xmlDoc.async = false;
                    xmlDoc.loadXML(xmlString); //loadXML方法载入xml字符串
                    break;
                }catch(e){
                }
            }
        }
        //支持Mozilla浏览器
        else if(window.DOMParser && document.implementation && document.implementation.createDocument){
            try{
                /* DOMParser 对象解析 XML 文本并返回一个 XML Document 对象。
                 * 要使用 DOMParser，使用不带参数的构造函数来实例化它，然后调用其 parseFromString() 方法
                 * parseFromString(text, contentType) 参数text:要解析的 XML 标记 参数contentType文本的内容类型
                 * 可能是 "text/xml" 、"application/xml" 或 "application/xhtml+xml" 中的一个。注意，不支持 "text/html"。
                 */
                domParser = new  DOMParser();
                xmlDoc = domParser.parseFromString(xmlString, 'text/xml');
            }catch(e){
            }
        }
        else{
            return null;
        }

        return xmlDoc;
    }
</script>


<script language=javascript>
	//判断设备类型
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(!fso.FileExists("C:/WINDOWS/system32/CMCC_IDCard.dll")){
		//document.getElementById('bReadByCardReader').disabled = false;
		//document.getElementById('trCardReader').style.display='none';
		//document.getElementById('PROMPTMSG').innerHTML = "设备状态";
	}
	if(!fso.FileExists("C:/WINDOWS/system32/MutiIdCard.dll")){ 
		//document.getElementById('readByMultisss1').disabled = false;
		document.getElementById('readByMultisss1').disabled = true;
		document.getElementById('readByMultisss2').disabled = true;
		document.getElementById('readByMultisss1s').disabled = true;
		document.getElementById('readByMultisss2s').disabled = true;		
		//document.getElementById('readByMultisss1').style.display='none';
		//document.getElementById('PROMPTMSG').innerHTML = "设备状态";
	}
</script>