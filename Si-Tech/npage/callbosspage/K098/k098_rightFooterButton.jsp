<%
  /*
   * 功能: 098权限角色管理->角色列表->保存 按钮界面
　 * 版本: 1.0.0
　 * 日期: 2008/1/16
　 * 作者: fangyuan
　 * 版权: sitech
   * update:
　 */
%>
<%@ page language="java" pageEncoding="gb2312"%>
<%@ include file="/npage/include/public_title_name.jsp"%>
<HTML>
	<HEAD>
	</HEAD>
	<BODY>
<div id="div1" style="display: none" >
		<TABLE width="100%"  height="25" cellSpacing="0" vAlign=top>
			<TR>
				<TD>
					<!--input type="button" class="b_text"  onclick="showCheckItemWin()" value="范围选择"/-->
					<input type="button" class="b_text" onclick="clearAll('loginNo')" value="全部清除"/>
					<input type="button" class="b_text"  onclick="checkAll('loginNo')" value="全部选中"/>
					<input type="button" class="b_text"  onclick="generatejs()" value="生成js文件"/>
					<!--input type="button" class="b_text" onclick="memberMsgWin()" value="查询成员信息"/-->
				<TD align="left">
					<input type="button" class="b_text" onclick="saveChange()" value="保存"/>
					<!--zengzq input type="button" class="b_text"  onclick="cancel()" value="退出"/-->
				</TD>
			</TR>
		</TABLE>
	</div>
</html>
<SCRIPT type=text/javascript> 
//操作栏显示
function showTable(){
var odiv = document.getElementById('div1');
odiv.style.display ="block";
}
//操作栏隐藏
function hiddenTable(){
var odiv = document.getElementById('div1');
odiv.style.display ="none";

}
function clearAll(){
	parent.frameright.window.clearAll('loginNo');
}
function generatejs(){
		parent.frameright.window.generatejs();
	}
	
function checkAll(){
		parent.frameright.window.checkAll('loginNo');
	}
	
function saveChange(){
	
		parent.frameright.window.saveChange();
		//zengzq
		//parent.frameleft.window.location.reload();
}
function showCheckItemWin(){
	window.parent.frameright.window.showCheckItemWin();
	}
function memberMsgWin(){
	parent.frameright.window.memberMsgWin();
}
function cancel(){
	parent.frameright.window.cancel();
}	
showTable();
</SCRIPT>
	
