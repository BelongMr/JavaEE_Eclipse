<%
  /*
   * ����: ����Ⱥ��
�� * �汾: 1.0
�� * ����: 2008/10/20
�� * ����: hanjc
�� * ��Ȩ: sitech
   *  
 ��*/
 %>
 
<%@ page language="java" pageEncoding="gb2312"%>
<%@ include file="/npage/include/public_title_name.jsp"%>
<%@ page import="com.sitech.crmpd.core.wtc.util.*,java.util.*"%>
<!--����Ⱥ��-->
<HTML>
	<HEAD>
		<!--LINK href="<%=request.getContextPath()%>/css/dhtmlxtree_css/style.css" type=text/css rel=STYLESHEET -->
		<LINK href="<%=request.getContextPath()%>/nresources/default/css/dtmltree_css/dhtmlxtree.css" type=text/css rel=STYLESHEET>
		<SCRIPT
			src="<%=request.getContextPath()%>/njs/csp/dhtmlxtree_js/dhtmlxcommon.js"
			type=text/javascript></SCRIPT>
		<SCRIPT
			src="<%=request.getContextPath()%>/njs/csp/dhtmlxtree_js/dhtmlxtree.js"
			type=text/javascript></SCRIPT>
	</HEAD>

	<BODY>
		<TABLE>
			<TR>
				<TD vAlign=top width="300" height="450">
					<DIV id="baseTree"></DIV>
				</TD>
			</TR>
		</TABLE>
	</BODY>
</html>
<SCRIPT type=text/javascript> 
function fixImage(id){
	switch(tree.getLevel(id)){
	case -1:	
		tree.setItemImage2(id,'folderClosed.gif','folderOpen.gif','folderClosed.gif');
		break;
	case 0:	
		tree.setItemImage2(id,'folderClosed.gif','folderOpen.gif','folderClosed.gif');
		break;
	case 1:
		tree.setItemImage2(id,'folderClosed.gif','folderOpen.gif','folderClosed.gif');
		break;
	case 2:
		tree.setItemImage2(id,'folderClosed.gif','folderOpen.gif','folderClosed.gif');			
		break;
	case 3:
		tree.setItemImage2(id,'folderClosed.gif','folderOpen.gif','folderClosed.gif');			
		break;			
	default:
		tree.setItemImage2(id,'leaf.gif','folderClosed.gif','folderOpen.gif');			
		break;
	}
}

//�����¼�
function onClickNodeSelect(){        
  if(tree.getUserData(tree.getSelectedItemId(),"isleaf")=='N'){
  		getTreeListByNodeId(tree.getSelectedItemId()); //��ajax��̬��ѯ����
  }
}

//˫���¼�
function onDbClickNodeSelect(){         
	  if(tree.getUserData(tree.getSelectedItemId(),"isleaf")=='N'){
	  		getTreeListByNodeId(tree.getSelectedItemId()); //��ajax��̬��ѯ����
	  }
	  // ��������һ�����ҳ��
	  window.returnValue=tree.getSelectedItemId()+'_'+tree.getSelectedItemText();    
	  window.close();
}
function getSelectItemIdByCheck(){
		return tree.getSelectedItemId();
}

//��Ӧcheckboxѡ���¼�������ʾ��Ϣ��ʾ������һ��ҳ��
function onCheckBoxsBySelect(){
		var allCheckItem=tree.getAllCheckedBranches();
		if(allCheckItem!=null){
				showNodeIdList(allCheckItem);//�����Ż����� ������ȥ��ѯ���ݿ�
		}  
}

//�ж���checkbox�Ƿ���ֵ 
function isCheckBoxsList(){
		var allCheckItem=tree.getAllCheckedBranches();
		if(allCheckItem!=null&&allCheckItem!=''){
				return true;
		}else{
				return false;	
		} 
}
	 


//����һ����̬��
function initBaseTree(){	
		tree=new dhtmlXTreeObject("baseTree","100%","100%",-1);    
    tree.setImagePath(<%=request.getContextPath()%>"/nresources/default/images/callimage/dtmltree_imgs/csh_books/");
    // ����������¼���չ���¼��ڵ�
    tree.setOnClickHandler(onClickNodeSelect);
    tree.setOnDblClickHandler(onDbClickNodeSelect);
    tree.enableHighlighting(0);
    tree.loadXML(<%=request.getContextPath()%>"/npage/callbosspage/checkWork/K204/K204_createXml.jsp");
    
    // ��ʼչ����һ��
    document.getElementById('0').click();
}

// ����ѡ�еĽڵ�id ���ظýڵ����ӽڵ�
function getTreeListByNodeId(){
		var nodeId = tree.getSelectedItemId();
		var varSubItems=tree.getSubItems(tree.getSelectedItemId());
		if(varSubItems!=null&&varSubItems!=''){
				return;
		}
		var packet = new AJAXPacket(<%=request.getContextPath()%>"/npage/callbosspage/checkWork/K204/K204_getChildNodeList.jsp","aa");
		packet.data.add("nodeId",nodeId);
		core.ajax.sendPacket(packet,doProcessGetList,false);
		packet=null;
}

//getTreeListByNodeId�Ļص�����
function doProcessGetList(packet){
   	var childNodeList = packet.data.findValueByName("nodes");
   	var nodeId= packet.data.findValueByName("nodeId");
    insertChildNodeList(childNodeList);
}

//����������ĺ���  
function insertChildNodeList(retData){
   	var varSubItems=tree.getSubItems(tree.getSelectedItemId()) ;
   	var str = new Array();
   	//�жϸýڵ�д�Ƿ����ӽڵ㣬������жϹ���һ�µ�ǰ�ڵ�ֵ�Ƿ������ݿ����ֵһ��
   	if(varSubItems!=null&&varSubItems!=''){
   		 str=varSubItems.split(",");
   		 for(var i=0;i<retData.length;i++){
    	//���˵�ǰ�ڵ����ӽڵ������ݿ��Ƿ���ͬ
       if(!isStr(retData[i][0],str)){
		        tree.insertNewItem(retData[i][1],retData[i][0],retData[i][2],0,0,0,0,'SELECT') ; 
		        tree.setUserData(retData[i][0],"isleaf",retData[i][3]);	     
       }
       //���ýڵ���ʾ��ͼƬ
       if(retData[i][3]=='N'){
        	 tree.setItemImage2(retData[i][0],'folderClosed.gif','folderOpen.gif','folderClosed.gif');
       }	
        if(retData[i][3]=='Y'){
        	   tree.setItemImage2(retData[i][0],'leaf.gif','folderClosed.gif','folderOpen.gif');		
        } 
     }
    //�����ǰ�ڵ������ӽڵ㣬�����䵱ǰ�ڵ��������ӽڵ�
   }else{
     	for(var i=0;i<retData.length;i++){
        tree.insertNewItem(retData[i][1],retData[i][0],retData[i][2],0,0,0,0,'SELECT') ; 
        tree.setUserData(retData[i][0],"isleaf",retData[i][3]);	
         if(retData[i][3]=='N'){
        	  	tree.setItemImage2(retData[i][0],'folderClosed.gif','folderOpen.gif','folderClosed.gif');
          }	
        if(retData[i][3]=='Y'){
        	  	tree.setItemImage2(retData[i][0],'leaf.gif','folderClosed.gif','folderOpen.gif');		
        }     	
     	}
	}

}


//�ж�һ���ַ����Ƿ��������г���
function isStr(strtreeData,str){
	if(str!=null){
		for(var j=0;j<str.length;j++){
     		if(strtreeData==str[j]){
     			return true;
     		}
		}
	}
	return false;
}
   
//��ʼ����
initBaseTree();


</SCRIPT>