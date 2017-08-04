<%
  /**
   * 功能: 质检权限管理->分配质检权限->保存按钮栏
　 * 版本: 1.0.0
　 * 日期: 2008/11/05
　 * 作者: mixh
　 * 版权: sitech
   * update:
　 */
%>
<%@ page language="java" pageEncoding="gbk"%>
<%@ include file="/npage/include/public_title_name.jsp"%>
<HTML>
	<HEAD>
	</HEAD>
	<BODY>
		<TABLE width="100%"  height="25" cellSpacing="0" vAlign=top>
			<TR>
				<TD align="right">
					<input type="button" class="b_text" onclick="saveChange()" value="保存"/>
				</TD>
				<TD align="right" width="30%" >
				</TD>
			</TR>
		</TABLE>
</html>


<script type="text/javascript" src="<%=request.getContextPath()%>/njs/csp/checkWork_dialog.js"></script>

<SCRIPT type=text/javascript> 
//操作栏显示
function saveChange(){
	var checkGroupId=parent.leftCenterTree.tree.getSelectedItemId();
	var loginGroupIdArr=parent.rightCenterTree.tree.getAllCheckedBranches();
  saveLoginNo(checkGroupId,loginGroupIdArr);	
}

function saveLoginNo(checkGroupId,loginGroupIdArr){
	// 这里必须做一下类型转换。否则不会有问题
  var packet = new AJAXPacket(<%=request.getContextPath()%>"/npage/callbosspage/checkWork/K300/k300_saveCheckgGroup.jsp","aa");
	packet.data.add("checkGroupId",""+checkGroupId);
	packet.data.add("loginGroupIdArr",""+loginGroupIdArr);
	core.ajax.sendPacket(packet,doProcessLoginNo,true);
	packet=null;
}

//getLoginNo的回调函数
function doProcessLoginNo(packet){
   	var retCode = packet.data.findValueByName("retCode");
   	if(retCode="000000"){
       similarMSNPop("\u5904\u7406\u6210\u529f");
       window.parent.rightFootLoginNo.CopyHtmlElement();
    return;
		} else {
			similarMSNPop("\u5904\u7406\u5931\u8d25");
			return false;
		}
}

function getUnEqualGroupIdArr(strShort,strLong){
	var strTemp;
	var strArr = new Array();
	for(var j=0;j<strShort.length;j++){
		strTemp+=strShort[j];
		}
	for(var i=0;i<strLong.length;i++){
		if(strTemp.indexOf(strLong[i])==-1){
			strArr[i]=strLong[i];
			}
		}	
	 return strArr;
}

function cancel(){
}	
</SCRIPT>
