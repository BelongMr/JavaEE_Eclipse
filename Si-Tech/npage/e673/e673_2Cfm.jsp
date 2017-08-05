<%
	String return_page = "e673_2.jsp";
	String from = request.getParameter("fromMonth").trim();
	String to = request.getParameter("toMonth").trim();
	String region_code = request.getParameter("s_in_ModeTypeCode");
	String dis_code = request.getParameter("s_in_CaseTypeCode");
	if(dis_code.length()==4)
	{
	     dis_code = dis_code.substring(2);
	}
    String bak_dir = request.getRealPath("/npage/invoice")+"/";
	String filedownload = bak_dir+"invoiceused"+region_code+dis_code+from+to+".txt";//�������ص��ļ������·��
System.out.println("filedownload:"+filedownload);
	File f = new File(filedownload);
    OutputStream output = null;
	FileInputStream fis = null;
    BufferedInputStream bis=null;
    BufferedOutputStream osb=null;
    try
    {
		if(!f.exists())
		{
		   response.setContentType("text/plain;charset=GBK");	
		   out.println("<SCRIPT LANGUAGE=\"JavaScript\">alert(\"�����ص��ļ�������!\");window.location.href=\"e673_2.jsp\";</SCRIPT>");	
		   throw new Exception("�ļ�����������ϵ����Ա");		   		
		}
		response.setContentType("APPLICATION/OCTET-STREAM"); 
		response.setHeader("Content-Disposition", "attachment;filename=\"" + "invoiceuesd"+region_code+dis_code+from+to+".txt" + "\""); 
		//�½�File����,ͬ�������ѡ�����Լ���InputStream
		output = response.getOutputStream();
		osb = new BufferedOutputStream(output);
		fis = new FileInputStream(f);
		bis = new BufferedInputStream(fis);
		//����ÿ��д�뻺���С
		byte[] b = new byte[500];
		//�������д��ͻ���
		int i = 0; 
		try{
		    while((i = bis.read(b)) > 0){
		        osb.write(b, 0, i);
		    }
		}catch(IOException e){
		   osb = null;
		   output = null;
		   out.clear();
           out = pageContext.pushBody();
		   return;
		}
		osb.flush();
    }
    catch(Exception e)
    {
        e.printStackTrace();
        return;
    }
   	finally{   	
		if(bis!= null)
		{
			bis.close();
			bis=null;
		}
		if(fis != null){
		    fis.close();
		    fis = null;
		}
		if(osb!=null)
		{
			osb.close();
			osb = null;
		}
		if(output != null){
		    output.close();
		    output = null;
		}
	}
   out.clear();
   out = pageContext.pushBody();

%>
	
</body></html>