<%
    /********************
     version v2.0
     开发商: si-tech
     *
     *update:zhanghonga@2008-08-19 页面改造,修改样式
     *
     ********************/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/npage/include/public_title_name.jsp" %>
<%@ page import="com.sitech.boss.pub.util.*"%>
<script type="text/javascript" src="jquery-1.6.min.js"></script>  
<script type="text/javascript" src="jquery.media.js"></script> 
<%!
    private static HashMap cfgMap = new HashMap(200);//缓存话单格式
    private static String CGI_PATH = "";
    private static String DETAIL_PATH = "";

    static {
        //从公共配置文件中读取配置信息，此信息被多sever共享
        CGI_PATH = SystemUtils.getConfig("CGI_PATH");
        DETAIL_PATH = SystemUtils.getConfig("DETAIL_PATH");
        System.out.println("---liujian----AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CGI_PATH" + CGI_PATH);
        System.out.println("---liujian----BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DETAIL_PATH" + DETAIL_PATH);
        //如果不以"/"格式结束,加上"/"
        if (!CGI_PATH.endsWith("/")) {
            CGI_PATH = CGI_PATH + "/";
            DETAIL_PATH = DETAIL_PATH + "/";
        }
    }
%>
<%
	String workNo = (String)session.getAttribute("workNo");
	String nopass = (String)session.getAttribute("password");
	String workname = (String)session.getAttribute("workName");
    String org_code = (String)session.getAttribute("orgCode");
    String printNote = "0";
	String groupId = (String)session.getAttribute("groupId");
	String[][] favInfo = (String[][])session.getAttribute("favInfo");   //数据格式为String[0][0]---String[n][0]
	int infoLen = favInfo.length;
    String tempStr = null;
    for (int i = 0; i < infoLen; i++) {
        tempStr = (favInfo[i][0]).trim();
        if (tempStr.equals("a092")) printNote = "1";
    }
    //路由
	String regionCode = org_code.substring(0,2);
	//s_kpxm="++"%="++"&="+s_jsheje+"&="+s_hjse+"&="+s_xmmc+"&="+s_ggxh+"&="+s_hsbz+"&="+s_xmdj+"&="+s_xmje+"&="+s_sl+"&="+s_se;
	String s_kpxm = request.getParameter("s_kpxm");
	String s_ghmfc  = request.getParameter("s_ghmfc");
	String s_jsheje  = request.getParameter("s_jsheje");
	String s_hjse = request.getParameter("s_hjse");
 
	String s_hsbz = request.getParameter("s_hsbz");
 
	String s_xmje  = request.getParameter("s_xmje");
 
    
	String invoice_number = WtcUtil.repNull(request.getParameter("invoice_number"));
	String invoice_code = WtcUtil.repNull(request.getParameter("invoice_code"));
	String files=invoice_number+invoice_code;
	
 	String outPath="";
    String out_file="";
    String exePath = "";
	File temp1 = null;
	int secNum=0;
	 
 


	String realPath = request.getSession().getServletContext().getRealPath("/");
	String path1 =  request.getContextPath();
	String path2 =  request.getRealPath("/");
	 
 
	System.out.println("ffffffffffffffffffffffffffff test dzfp s_kpxm is "+s_kpxm+" and realPath is "+realPath+" and path1 is "+path1+" and path2 is "+path2);
	String phoneNo=request.getParameter("s_phone_no");
	String s_login_accept=request.getParameter("invoice_accept");
	String s_dates=request.getParameter("s_dates");
	String file_name="";//"test_haha.txt";//写死的
	file_name="zgar_"+phoneNo+invoice_code+invoice_number;
%>	 
 
<%
	//bill_cancel[0][0]="000000";
	 
			//pdf生成
			 
			//String file_name="test.txt";//"testtes1";//发票号码+发票代码
			String file_path=request.getRealPath("");
			//String filenameIn=file_path+"/txt_tmp/"+file_name;//"/xuxz.txt";
		    outPath=path2+"/cli_file/";
			out_file=outPath+file_name;
			String filenameIn=out_file;
			String filenameOut=file_path+"/pdf_tmp/"+file_name+".pdf";
			System.out.println("cccccccccccccccccccccccccccccc filenameOut is "+filenameOut+" and filenameIn is "+filenameIn);
			File file=new File(filenameIn);
			if(file.exists())    
			{
				BufferedReader br=new BufferedReader(new FileReader(file));
				String temp=null;
				StringBuffer sb=new StringBuffer();
				temp=br.readLine();
				while(temp!=null)
				{
				   sb.append(temp+" ");
				   temp=br.readLine();
				}
				//System.out.println("test is "+sb.toString());
				//System.out.println("111");
				FileOutputStream fileOutputStream;
				try {
					fileOutputStream = new FileOutputStream(new File(filenameOut));
					byte[] byte_pdf = org.apache.axis.encoding.Base64.decode(sb.toString());
					fileOutputStream.write(byte_pdf);
					Thread.sleep(2000);
					fileOutputStream.close();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					%>
						<script language="javascript">
							rdShowMessageDialog("生成pdf失败!");
							history.go(-1);
						</script>
					<%
				}
				%>
				<html>
				<script language="javascript">
					$(function() {   
						 $('a.media').media({width:800, height:600});   
				    });   
				 
					 
					function goback()
					{
						window.location.href="zgar_1.jsp";
					}	
					function doresh()
					{
						window.location.reload();
					}
				</script>
					<META http-equiv=Content-Type content="text/html; charset=GBK">
					<BODY >
					<table cellSpacing="0">
						<tr> 
						  <td id="footer"> 
							<input type="button"  class="b_foot" value="返回" name="back1" onclick="goback()" >
							<input type="button"  class="b_foot" value="刷新" name="refsh" onclick="doresh()" >
						  </td>
						 </tr>
						</table> 
						<a class="media" href="../../pdf_tmp/<%=file_name%>.pdf">PDF File</a>	  
						
					</BODY>
				 
			</html>
			<%
			}
			else
			{
				%>
					<script language="javascript">
						rdShowMessageDialog("<%=filenameIn%>"+"不存在!");
						history.go(-1);
					</script>
				<%
			}
	  %>
			

 
 

	
 
