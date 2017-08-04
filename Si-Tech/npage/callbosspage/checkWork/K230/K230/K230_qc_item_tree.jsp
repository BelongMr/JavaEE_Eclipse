<%
  /*
   * 功能: 考评项维护页面
　 * 版本: 1.0.0
　 * 日期: 2008/11/05
　 * 作者: mixh
　 * 版权: sitech
   * update:
　 */
%>
<%
		response.setHeader("Pragma","No-cache"); 
		response.setHeader("Cache-Control","no-cache"); 
		response.setDateHeader("Expires", 0);
		%>
<%
	String opCode = "K230";
	String opName = "考评项列表";
%>

<%@ include file="/npage/include/public_title_name.jsp" %>

<%
/*---------------获得默认object_id开始-------------------*/
String object_id = WtcUtil.repNull(request.getParameter("object_id"));
String sqlGetObjectId = "";
if(object_id == null || object_id.equals("")){
	sqlGetObjectId = "select min(object_id) from dqcobject where bak1='Y'";
}
%>
<wtc:service name="s151Select" outnum="8">
<wtc:param value="<%=sqlGetObjectId%>"/>
</wtc:service>
<wtc:array id="object_ids" scope="end"/>
<%
if(object_id == null || object_id.equals("")){
	object_id = object_ids[0][0];
}
/*---------------获得默认object_id结束-------------------*/
%>

<%
/*---------------获得默认content_id开始-------------------*/
String content_id = WtcUtil.repNull(request.getParameter("content_id"));
String sqlGetContent_id = "";
if(content_id == null || content_id.equals("")){
	sqlGetContent_id = "select min(contect_id) from dqccheckcontect where object_id='" + object_id + "' and bak1='Y'";
}
%>
<wtc:service name="s151Select" outnum="8">
<wtc:param value="<%=sqlGetContent_id%>"/>
</wtc:service>
<wtc:array id="content_ids" scope="end"/>
<%
if(content_id == null || content_id.equals("")){
	content_id = content_ids[0][0];
}
/*---------------获得默认content_id结束-------------------*/
%>

<html>
<head>
<link href="<%=request.getContextPath()%>/nresources/default/css/dtmltree_css/dhtmlxtree.css" type=text/css rel=stylesheet>
<script src="<%=request.getContextPath()%>/njs/csp/dhtmlxtree_js/dhtmlxcommon.js" type=text/javascript></script>
<script src="<%=request.getContextPath()%>/njs/csp/dhtmlxtree_js/dhtmlxtree.js" type=text/javascript></script>

<script>

/**
  *
  *打开添加考评项窗口
  *
  */
function add_qc_item(){
	var object_id  = document.getElementById("object_id").value;
	var content_id = document.getElementById("content_id").value;
	
	var current_node_id = tree.getSelectedItemId();
	var father_node_id  = tree.getParentId(current_node_id);
	
	/*
	window.open('K230_add_qc_item.jsp?current_node_id=' + current_node_id + '&object_id=' + object_id + '&content_id=' + content_id + '&father_node_id=' + father_node_id,
	            '',
	            'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,width='+screen.availWidth+',height='+screen.availHeight+',left=0,top=0');
	*/
	var time     = new Date();
	var url      = 'K230_add_qc_item.jsp?time='+time+'&current_node_id=' + current_node_id + '&object_id=' + object_id + 
	               '&content_id=' + content_id + '&father_node_id=' + father_node_id;
	var winParam = 'dialogWidth=800px;dialogHeight=360px';
	window.showModalDialog(url, window, winParam);	
}

/**
  *
  *打开修改考评项窗口
  *
  */
function update_qc_item(){
	var object_id = document.getElementById("object_id").value;
	var content_id = document.getElementById("content_id").value;
	var item_id = tree.getSelectedItemId();
	var parentItem_id = tree.getParentId(item_id);
	if(undefined==item_id||''==item_id||'0'==item_id){
		rdShowMessageDialog('请选择要修改的考评项',0);
			return false;
	}
	/*
	window.open('K230_update_qc_item.jsp?item_id=' + item_id+'&parentItem_id='+parentItem_id,
	            '',
	            'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,width='+screen.availWidth+',height='+screen.availHeight+',left=0,top=0');
	*/
	
	var time     = new Date();
	var winParam = 'dialogWidth=800px;dialogHeight=360px';
	window.showModalDialog('K230_update_qc_item.jsp?time='+time+'&item_id=' + item_id+'&parentItem_id='+parentItem_id+'&object_id='+object_id+'&content_id='+content_id, window, winParam);		
}

/**
  *
  *删除考评项
  *
  */
function delete_qc_item(){
	var item_id = tree.getSelectedItemId();
	var leafNum = tree.getAllSubItems(item_id).length;
	if(undefined==item_id||''==item_id||'0'==item_id){
	rdShowMessageDialog('请选择要删除的考评项',0);
		return false;
	}
	//alert(tree.hasChildren(item_id));
	if(leafNum>0){
	//if(tree.hasChildren(item_id)){
		rdShowMessageDialog('请先删除子考评项',0);
		return false;
		}
		
	if(rdShowConfirmDialog("确认删除当前考评项么？") == 1){
		delQcItem();
	}
}


/*对返回值进行处理*/
function doProcessDelQcItem(packet){
	//alert("Begin call doProcessDelQcItem()......");
	var retType = packet.data.findValueByName("retType");
	var retCode = packet.data.findValueByName("retCode");
	var retMsg = packet.data.findValueByName("retMsg");
	var leafCount = packet.data.findValueByName("leafCount");
	var parentItem_id = packet.data.findValueByName("parentItem_id");
	if(retType=="delQcItem"){
		if(retCode=="000000"){
			//alert("成功删除测评项");
			tree.deleteItem(tree.getSelectedItemId(),true);
			if(leafCount<=1&&!(parentItem_id==0)){
				  tree.setUserData(parentItem_id,"isleaf",'Y');	
				  tree.setItemImage2(parentItem_id,'leaf.gif','folderClosed.gif','folderOpen.gif');		
			}else{
					tree.setUserData(parentItem_id,"isleaf",'N');	
					tree.setItemImage2(parentItem_id,'folderClosed.gif','folderOpen.gif','folderClosed.gif');
			}
			
			rdShowMessageDialog('成功删除测评项', 2);
			
		}else{
			//alert("删除测评项失败!");
			rdShowMessageDialog('删除测评项失败', 0);
			return false;
		}
	}
	//alert("End call doProcessDelQcItem()......");
}

/**
  *
  *删除测评项
  *
  */
function delQcItem(){
	//alert("Begin call delQcItem()....");
	var object_id = document.getElementById("object_id").value;
	var content_id = document.getElementById("content_id").value;
	var item_id = tree.getSelectedItemId();
	var parentItem_id = tree.getParentId(item_id);
	//alert("parentItem_id:"+parentItem_id);
	var chkPacket = new AJAXPacket("<%=request.getContextPath()%>/npage/callbosspage/checkWork/K230/K230_do_delete_qc_item.jsp?parentItem_id="+parentItem_id+"&object_id="+object_id+"&content_id="+content_id,"请稍后...");
	chkPacket.data.add("retType","delQcItem");
	chkPacket.data.add("item_id", tree.getSelectedItemId());
	core.ajax.sendPacket(chkPacket, doProcessDelQcItem, true);
	chkPacket =null;
	//alert("End call delQcItem()....");
}

/**
  *
  *弹出考评项等级维护页面
  *
  */
function manage_level(){
	var selectedItemId = tree.getSelectedItemId();
	//alert(selectedItemId);
	//取是否评分项 0否  1是  zengzq
	var userData1 = tree.getUserData(selectedItemId,"isscored");
	//alert("userData1:"+userData1);
	if("0"==userData1.trim()){
		rdShowMessageDialog('请选择评分的考评项！', 0);
		return false;
		}
	if(selectedItemId == '' || selectedItemId == undefined){
		rdShowMessageDialog('请选择考评项！', 0);
		return false;
	}
	var object_id = document.getElementById("object_id").value;
	var content_id = document.getElementById("content_id").value;
	
	var height = 250;
	var width  = 800;
	var top    = (screen.availHeight - height)/2;
	var left   = (screen.availWidth - width)/2;
	var param  = 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,' +
	             'width=' + width + ',height=' + height + ',left= ' + left + ',top=' + top;
	window.open('K230_qc_item_level_list.jsp?selectedItemId=' + selectedItemId + "&object_id=" + object_id + "&content_id=" + content_id, '', param);
}

</script>

</head>

<body onload="initBaseTree();">
<input type="hidden" name="object_id" id="object_id" value="<%=object_id%>"/>
<input type="hidden" name="content_id" id="content_id" value="<%=content_id%>"/>

<input type="hidden" name="leafNum" id="leafNum" value="12"/>
<input type="hidden" name="itemNum" id="itemNum" value="0"/>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
  <td id="footer"  align="right">
	<input type="button" name="btn_level"  value="等级" class="b_foot" onclick="manage_level();"/>
	<input type="button" name="btn_add"    value="添加" class="b_foot" onclick="add_qc_item()"/>
	<input type="button" name="btn_update" value="修改" class="b_foot" onclick="update_qc_item()"/>
	<input type="button" name="btn_delete" value="删除" class="b_foot" onclick="delete_qc_item()"/>
</td>
</tr>
</table>
<table width="100%">
<tr>
	<td valign="top" width="100%">
	<div id="basetree" ></div>
	</td>
	<td valign=top width="100%">
	<div id="childtree"></div>
	</td>
</tr>
</table>
</body>
</html>

<script type=text/javascript>

/*
 *构建一个动态树
 *
 */
function initBaseTree(){
	tree=new dhtmlXTreeObject("baseTree","100%","100%",-1);
	tree.setImagePath(<%=request.getContextPath()%>"/images/dtmltree_imgs/csh_books/");
	/**/
	tree.setXMLAutoLoading("<%=request.getContextPath()%>/npage/callbosspage/checkWork/K230/K230_create_qc_item_tree_xml.jsp?id=<%=content_id%>&object_id=<%=object_id%>");
	//设置鼠标单击事件
	tree.setOnClickHandler(onNodeClick);
	//tree.setOnSelectStateChange(onGetitemNum);
	tree.enableCheckBoxes(0);
	tree.loadXML("<%=request.getContextPath()%>/npage/callbosspage/checkWork/K230/K230_create_qc_item_tree_xml.jsp?id=<%=content_id%>&object_id=<%=object_id%>");
	document.getElementById('0').click();
}

/*
function onGetitemNum(){
	//alert("111111:"+tree._getLeafCount('0'));
	document.getElementById('itemNum').value = tree.getSubItems('0').length;
	//alert("document:"+document.getElementById('itemNum').value);
	}
	*/
/**
  *响应鼠标单击事件，选中当前节点，并展示当前节点下的子结点
  *
  */
function onNodeClick(){
	//alert(tree.getSelectedItemId());
	//用ajax动态查询数据
	//alert("ssss");
	getTreeListByNodeId(tree.getSelectedItemId());
}

</script>

<script type=text/javascript>


// 根据选中的节点id 返回该节点下子节点
function getTreeListByNodeId(strSelectedNodeid){
	//alert("selectedId:"+strSelectedNodeid);
	var packet = new AJAXPacket("<%=request.getContextPath()%>/npage/callbosspage/checkWork/K230/K230_get_qc_item_child_tree.jsp?object_id=<%=object_id%>&content_id=<%=content_id%>", "...");
	packet.data.add("parent_item_id",strSelectedNodeid);
	core.ajax.sendPacket(packet,doProcessGetList,true);
	//packet=null;
}

//getTreeListByNodeId的回调函数
function doProcessGetList(packet){
	var childNodeList = packet.data.findValueByName("worknos");
	//document.getElementById("leafNum").value=childNodeList.length;
	//alert(document.getElementById("leafNum").value);
	var nodeId= packet.data.findValueByName("nodeId");
	insertChildNodeList(childNodeList);
	//alert("doProcessGetList");
}

//做插入操作的函数
function insertChildNodeList(retData){
   	var varSubItems=tree.getSubItems(tree.getSelectedItemId()) ;
   	var str = new Array();
   	if(varSubItems!=null&&varSubItems!=''){
   		 str=varSubItems.split(",");
   		for(var i=0;i<retData.length;i++){
   		 
   		//alert("getSubItems is not null:\t"+retData[i][3]);
       if(!isStr(retData[i][0],str)){
        //tree.insertNewItem(retData[i][1],retData[i][0],retData[i][2],0,0,0,0,'SELECT') ;
        tree.insertNewItem(retData[i][1],retData[i][0],retData[i][2],0,0,0,0,'SELECT') ;
        tree.setUserData(retData[i][0],"isleaf",retData[i][3]);
        //zengzq
        tree.setUserData(retData[i][0],"isscored",retData[i][4]);
        
       }
        //alert("isleaf0:\t"+retData[i][3]);
       //if(retData[i][3]=='0'){
       if(retData[i][3]=='N'){
        	 //tree.showItemCheckbox(retData[i][0],0);
        	 tree.showItemSign(retData[i][0],1);
        	 tree.setItemImage2(retData[i][0],'folderClosed.gif','folderOpen.gif','folderClosed.gif');
          }
        //if(retData[i][3]=='1'){
        if(retData[i][3]=='Y'){
        	  //tree.showItemCheckbox(retData[i][0],1);
        	  tree.showItemSign(retData[i][0],0);
        	   tree.setItemImage2(retData[i][0],'leaf.gif','folderClosed.gif','folderOpen.gif');
          }

     	}
   }else{
     	for(var i=0;i<retData.length;i++){
        tree.insertNewItem(retData[i][1],retData[i][0],retData[i][2],0,0,0,0,'SELECT') ;
        tree.setUserData(retData[i][0],"isleaf",retData[i][3]);
        //zengzq
        tree.setUserData(retData[i][0],"isscored",retData[i][4]);
         //alert("getSubItems is null:\t"+retData[i][3]);
         if(retData[i][3]=='N'){
        	 //tree.showItemCheckbox(retData[i][0],0);
        	 tree.showItemSign(retData[i][0],1);
        	  tree.setItemImage2(retData[i][0],'folderClosed.gif','folderOpen.gif','folderClosed.gif');
          }
	      if(retData[i][3]=='Y'){
	        	//tree.showItemCheckbox(retData[i][0],1);
	        	tree.showItemSign(retData[i][0],0);
	        	tree.setItemImage2(retData[i][0],'leaf.gif','folderClosed.gif','folderOpen.gif');
          }
     	}
}
//document.getElementById('itemNum').value = tree.getSubItems('0').length;
//alert("document:"+document.getElementById('itemNum').value);
}

//判断一个字符串是否在数组中出现
function isStr(strtreeData,str){
	if(str!=null){
			  for(var j=0;j<str.length;j++){
	 	if(strtreeData.trim()==str[j].trim()){
	 		return true;
	 		}
		}
	}
	return false;
}

</script>