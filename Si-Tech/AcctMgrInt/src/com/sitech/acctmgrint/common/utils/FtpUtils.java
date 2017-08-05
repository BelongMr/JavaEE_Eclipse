package com.sitech.acctmgrint.common.utils;

import static org.apache.commons.collections.MapUtils.getString;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import org.apache.commons.net.ftp.FTPClient;
import org.ini4j.Ini;
import org.ini4j.InvalidFileFormatException;
import org.ini4j.Profile.Section;

import com.asiainfo.uap.util.des.EncryptInterface;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.net.ftp.FTPClientConfig;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.log4j.Logger;

import com.sitech.acctmgrint.common.AcctMgrProperties;
import com.sitech.acctmgrint.common.StreamGobbler;
import com.sitech.jcf.core.exception.BusiException;



public class FtpUtils {
	
	private Logger logger = Logger.getLogger(FtpUtils.class);
	private String ip;
	private int port;
	private String pwd;
	private String user;
	private FTPClient ftpClient;

	public FtpUtils(){

	}

	public FtpUtils(String ip, int port, String user, String pwd){
		this.ip = ip;
		this.port = port;
		this.user = user;
		this.pwd = pwd;
	}

	
	private static Map<String, Map<String, String>> seqProperties = new HashMap<String, Map<String, String>>();

	public static Map<String,Object> download(String relPath) throws Exception {
		String ip= "";
		int port = 0;
		String userName ="";
		String userPwd = "";

		Map<String, String>mapa = FtpUtils.getFtpInfo();
		ip=mapa.get("HOSTIP");
		port=Integer.parseInt(mapa.get("BATCH_FUNC_FTP_PROT").trim());
		userName=mapa.get("HOSTUSER");// 主机名称
		userPwd=mapa.get("HOSTPASSWD");// 主机密码
		
		System.err.println("---->FTP_INFO_ip="+ip+",port="+port+",userName="+userName+",userPwd="+userPwd);
		
		String absoPath= AcctMgrProperties.getConfigByMap("absoPath");
		String fileName = "";
		
		final Map<String, String> env = System.getenv();
		
		String localPath = getString(env, "HOME");
		localPath=localPath+"/download/";
		System.err.println("localPath:"+localPath);
		
		FTPClient ftp = new FTPClient();
		
		Map<String, Object> outMapTmp = new HashMap<String, Object>();
		System.err.println("env="+env);
		System.err.println("relPath="+relPath);
		System.err.println("remote_ip="+ip);
		
		int lastIndex = relPath.lastIndexOf("/");
		String relPath1 = relPath.substring(0, lastIndex);
		fileName = relPath.substring(lastIndex+1);
		System.out.println("fileName:"+fileName+",relPath1:"+relPath1);
		
		try {
			ftp.connect(ip, port);
			ftp.login(userName, userPwd);
			if (absoPath != null && absoPath.length() > 0) {
			    // 跳转到指定目录
			   System.err.println("------> cd_in"+absoPath+relPath1);
			   ftp.changeWorkingDirectory(absoPath+relPath1);
			   System.err.println("------> cd_pwd"+ ftp.pwd());

			}
	        File localFile = new File(localPath+fileName); 
	        OutputStream is = new FileOutputStream(localFile);  
	        System.out.println("-----> fileup ="+is.toString());
	        ftp.retrieveFile(fileName, is); 
	        is.close(); 

	        ftp.logout();
		}catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                ftp.disconnect();
            } catch (IOException ioe) {
                ioe.printStackTrace();
            }
        }
		
		String enCode=codeString(localPath+fileName);
		outMapTmp.put("FILENAME", localPath+"/"+fileName);
		outMapTmp.put("ENCODE", enCode);
		return outMapTmp;
	}
	
	public static String codeString(String fileName) throws Exception{  
	    BufferedInputStream bin = new BufferedInputStream(  
	    new FileInputStream(fileName));  
	    int p = (bin.read() << 8) + bin.read();  
	    String code = null;  
	      
	    switch (p) {  
	        case 0xefbb:  
	            code = "UTF-8";  
	            break;  
	        case 0xfffe:  
	            code = "Unicode";  
	            break;  
	        case 0xfeff:  
	            code = "UTF-16BE";  
	            break;  
	        default:  
	            code = "GBK";  
	    }  
	      
	    return code;  
	} 
	
	//ftp配置文件读取
	public static Map<String, String> readFtpFile(String name) {

		Map<String, String> outMap = new HashMap<String, String>();
		if (seqProperties != null) {
			Map<String, String> mapa = (Map<String, String>) seqProperties.get(name);
			for (String key : mapa.keySet()) {
				String value = mapa.get(key);
				int nIdxB = value.indexOf("{");
				int nIdxE = value.indexOf("}");
				if (nIdxB != -1 && nIdxE != -1 && nIdxE > nIdxB) {
					String flag_name = value.substring(nIdxB + 1, nIdxE);
					value = getPwdFileDbPwd(flag_name, key);
				}
				System.out.println(key + ":" + value);
				outMap.put(key, value.trim());
			}
		}

		return outMap;
	}
	
	// 根据传入的标签名和key取密码文件中的密文并解密返回
	private static String getPwdFileDbPwd(String flag_name, String key) {
		System.out.println("--getPwdFileDbPwd_in = "+flag_name + ":" +  key);
		
		Map<String, String> mapa = (Map<String, String>) seqProperties.get("MAIN");
		String pwdFileName = mapa.get("PWDCFG");
		System.err.println("--pwdFileName = "+pwdFileName);

		Ini ini = null;
		try {
			ini = new Ini(new File(pwdFileName));
		} catch (InvalidFileFormatException e) {
			e.printStackTrace();
			throw new IllegalStateException("-----读取密码文件失败");
		} catch (IOException e) {
			e.printStackTrace();
			throw new IllegalStateException("-----读取密码文件失败");
		}

		String value = "";

		// 读取密码配置文件中的用户名和密码
		Section section = ini.get(flag_name);
		if (null != section) {
			String password = ini.get(flag_name, key);

			System.out.println("--passwordconfig file:segment=" + flag_name	+ ",key=" + key + "Pwd=" + password);

			if (!"HOSTIP".equals(key)) {
				value = EncryptInterface.desUnEncryptData(password);
			} else {
				value = password;
			}

		} else {
			throw new IllegalStateException("-----根据jndi name[" + flag_name
					+ "]，在密码文件中没有找到与之对应的" + key + "段名，请修正！---");
		}

		return value;
	}

	private static void init() {
		// Map seqProperties = new HashMap<String, Map<String, String>>();
		BufferedReader in = null;
		try {
			String sPath = Thread.currentThread().getContextClassLoader()
					.getResource("acctmgrconfig/acctmgr.properties").getPath();
			in = new BufferedReader(new InputStreamReader(new FileInputStream(
					java.net.URLDecoder.decode(sPath, "UTF-8"))));
			String sConfData = null;
			String sValueData = null;

			while ((sConfData = in.readLine()) != null) {
				if (!sConfData.equals("")) {
					int nIdxB = sConfData.indexOf("[");
					int nIdxE = sConfData.indexOf("]");
					if (nIdxB != -1 && nIdxE != -1 && nIdxE > nIdxB) {
						String sKey = sConfData.substring(nIdxB + 1, nIdxE);
						Map<String, String> mapVal = new LinkedHashMap<String, String>();
						while ((sValueData = in.readLine()) != null && sValueData.contains("=")) {
							int nIdx = sValueData.indexOf("=");
							if (nIdx != -1 && nIdx != sValueData.length() - 1) {
								mapVal.put(sValueData.split("=")[0].trim() , sValueData.split("=")[1].trim());
							}
						}
						seqProperties.put(sKey, mapVal);
					}
				}

			}
			in.close();
		} catch (FileNotFoundException e1) {
			try {
				in.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			e1.printStackTrace();

		} catch (IOException e2) {
			try {
				in.close();
			} catch (IOException e) {

				e.printStackTrace();
			}
			e2.printStackTrace();
		} finally {
			try {
				in.close();
			} catch (IOException e) {

				e.printStackTrace();
			}
		}
	}

	private static Map<String, String> getFtpInfo() {
		FtpUtils.init();
		System.out.println("-------getFtpInfo_begin-------");
		Map<String, String> ftpMap=readFtpFile("BATCH_FUNC_FTP");
		System.out.println("-------getFtpInfo_end-------");
		return   ftpMap;
	}
	
	public static Map<String, String> getFtpInfo(String engineLabel) {
		FtpUtils.init();
		System.out.println("-------getFtpInfo_begin-------");
		Map<String, String> ftpMap=readFtpFile(engineLabel);
		System.out.println("-------getFtpInfo_end-------");
		return   ftpMap;
	}
	
	
	
	
	//crm方法
	/**
	 * 关闭FTP服务器
	 * 
	 * @throws Exception
	 */
	public void closeServer() throws Exception
	{
		logger.info("开始关闭服务");
		if (ftpClient != null)
		{
			ftpClient.logout();
			if (ftpClient.isConnected())
			{
				ftpClient.disconnect();
			}
		}
		logger.info("结束关闭服务");
	}

	/**
	 * 连接FTP服务器
	 * 
	 * @throws Exception
	 */
	public boolean connectServer() throws Exception
	{
		boolean isSuccess = false;
		try
		{
			ftpClient = new FTPClient();
			ftpClient.connect(ip, port);
			ftpClient.setControlEncoding("UTF-8");// 解决中文乱码
			FTPClientConfig conf = new FTPClientConfig(FTPClientConfig.SYST_NT);
			conf.setServerLanguageCode("zh");
			ftpClient.login(user, pwd);
			ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);
			ftpClient.enterLocalActiveMode(); // 主动传输模式
			ftpClient.setDataTimeout(20 * 60 * 1000);
			// ftpClient.enterLocalPassiveMode();//
			// 设置为被动模式传输，否则程序部署到服务器上后选择上传的文件保存后一直处在运行中(不动了,进度条也走得很慢)
			// ftpClient.setDataTimeout(120000);
			if (FTPReply.isPositiveCompletion(ftpClient.getReplyCode()))
			{
				isSuccess = true;
				logger.info("连接ftp服务器" + ip + "成功！");
				// logger.info("username:" + user);
				// logger.info("password:" + pwd);
				// logger.info("当前路径为：" + ftpClient.printWorkingDirectory());
			}
			else
			{
				ftpClient.disconnect();
				logger.error("连接ftp服务器" + ip + "异常！");
				throw new Exception("连接ftp服务器" + ip + "异常！");
			}
		}
		catch (Exception e)
		{
			logger.error("连接FTP服务器" + ip + "异常..", e);
			throw new Exception("连接ftp服务器" + ip + "异常！");
		}
		return isSuccess;
	}

	/**
	 * 远程FTP下载文件,下载指定的文件
	 * 
	 * @param remotePath
	 * @param localPath
	 * @param fileNames
	 * 
	 * @return
	 * @throws Exception
	 */
	public File downloadFile(String remotePath, String localPath, String fileNames) throws Exception
	{

		File fileOut = null;
		InputStream is = null;
		FileOutputStream os = null;
		try
		{
			if (ftpClient.changeWorkingDirectory(remotePath))
			{
				logger.info("下载文件的路径为：" + ftpClient.printWorkingDirectory());

				// 列出所有的文件
				FTPFile[] ftpFiles = ftpClient.listFiles();
				if (ftpFiles == null || ftpFiles.length == 0)
				{
					throw new Exception("目录" + remotePath + "不存在任何文件，请重新选择");
				}
				for (FTPFile file : ftpFiles)
				{
					// 文件名一样的下载
					if (file.getName().equals(fileNames))
					{
						logger.info("开始下载文件：" + file.getName());
						String newStr = new String(file.getName().getBytes("UTF-8"), "ISO8859_1");

						is = ftpClient.retrieveFileStream(newStr);

						if (localPath != null && !localPath.endsWith("/"))
						{
							localPath = localPath + "/";
							File path = new File(localPath);
							if (!path.exists())
							{
								path.mkdirs();
							}
						}
						fileOut = new File(localPath + file.getName());
						os = new FileOutputStream(fileOut);
						byte[] bytes = new byte[1024];
						int c;
						while ((c = is.read(bytes)) != -1)
						{
							os.write(bytes, 0, c);
						}

						os.flush();
						is.close();
						os.close();
						ftpClient.completePendingCommand();
						logger.info("下载文件存放地址为：" + fileOut.getAbsolutePath());
						logger.info("结束下载文件：" + file.getName());
					}
				}
				if (fileOut == null)
				{
					throw new Exception("目录" + remotePath + "下不存在" + fileNames + "文件，请重新选择");
				}

			}
			else
			{
				throw new Exception("远程路径找不到，请核查");
			}
		}
		catch (Exception e)
		{
			logger.error("从FTP服务器下载文件异常：", e);
			throw e;
		}
		return fileOut;
	}

	/**
	 * FTP上传文件，上传指定的文件
	 * 
	 * @param remotePath
	 * @param localPath
	 * @param fileNames
	 * @return
	 * @throws Exception
	 */
	public void uploadFile(String remotePath, String localPath, String fileNames) throws IOException
	{
		try
		{
			if (!this.exists(remotePath))
			{
				boolean flag = this.mkdirs(remotePath);
				if (!flag)
				{
					throw new Exception("创建目录失败");
				}
			}
			if (ftpClient.changeWorkingDirectory(remotePath))
			{
				logger.info("上传文件的路径为：" + ftpClient.printWorkingDirectory());
				// 得到本地路径下的所有文件
				if (localPath != null && !localPath.endsWith("/"))
				{
					localPath = localPath + "/";
				}
				File file = new File(localPath + fileNames);

				logger.info("开始上传文件：" + file.getName());
				OutputStream os = ftpClient.storeFileStream(new String(file.getName().getBytes("UTF-8"), "iso-8859-1"));
				FileInputStream is = new FileInputStream(file);
				byte[] bytes = new byte[1024];
				int c;
				while ((c = is.read(bytes)) != -1)
				{
					os.write(bytes, 0, c);
				}
				os.close();
				is.close();
				ftpClient.completePendingCommand();// 必须写，而且必须在is.close()后面
				logger.info("结束上传文件：" + file.getName());

			}
			else
			{
				throw new Exception("远程目录不存在");
			}
		}
		catch (Exception e)
		{
			logger.error("上传FTP文件异常: ", e);
		}
	}

	/**
	 * FTP上传文件，上传多个文件
	 * 
	 * @param remotePath
	 * @param localPath
	 * @param files
	 * @return
	 * @throws Exception
	 */
	public void uploadFile(String remotePath, List<File> files) throws Exception
	{
		try
		{
			if (!this.exists(remotePath))
			{
				boolean flag = this.mkdirs(remotePath);
				if (!flag)
				{
					throw new Exception("创建目录失败");
				}
			}
			if (ftpClient.changeWorkingDirectory(remotePath))
			{
				logger.info("上传文件的路径为：" + ftpClient.printWorkingDirectory());
				for (File file : files)
				{
					logger.info("开始上传文件：" + file.getName());
					OutputStream os = ftpClient.storeFileStream(file.getName());
					FileInputStream is = new FileInputStream(file);
					byte[] bytes = new byte[1024];
					int c;
					while ((c = is.read(bytes)) != -1)
					{
						os.write(bytes, 0, c);
					}
					os.close();
					is.close();
					ftpClient.completePendingCommand();// 必须写，而且必须在is.close()后面
					logger.info("结束上传文件：" + file.getName());
				}
			}
			else
			{
				throw new Exception("远程目录不存在");
			}
		}
		catch (Exception e)
		{
			logger.error("上传FTP文件异常: ", e);
		}
	}

	/**
	 * @function:判断远程服务器目录是否存在（是相对的还是绝对的；以"/"开头的:绝对的；不以"/"开头的:相对的）
	 * @param remotePath
	 *            远程服务器文件绝对/相对当前路径
	 * @return 目录是否存在。true:存在；false:不存在
	 * @throws IOException
	 */
	public boolean exists(String remotePath) throws IOException
	{

		// 创建目录之前的当前指向路径
		String firstpath = ftpClient.printWorkingDirectory();
		// 处理空
		if (remotePath == null || "".equals(remotePath))
		{
			throw new IOException("目录不能为null或者空字符串");
		}

		/*-------------------- 获得绝对路径---------------------*/
		StringBuffer curdir = new StringBuffer();
		// 处理开头：如果没有"/"，说明是相对当前路径的，转到绝对路径。
		if (remotePath.startsWith("/"))
		{
			curdir.append(remotePath);
		}
		else
		{
			if (firstpath.endsWith("/"))
			{
				curdir.append(firstpath).append(remotePath);
			}
			else
			{
				curdir.append(firstpath).append("/").append(remotePath);
			}
		}
		// 绝对路径
		String absolutePath = curdir.toString();
		// 处理结尾：如果有"/"，就删除这个符号
		if (absolutePath.endsWith("/") && !absolutePath.equals("/"))
		{
			absolutePath = absolutePath.substring(0, absolutePath.length() - 1);
		}
		/*-------------------- 获得绝对路径---------------------*/

		/*-------------------- 判断目录存在否--------------------*/
		if (ftpClient.changeWorkingDirectory(remotePath))
		{
			logger.info("目录：" + absolutePath + "存在");
		}
		else
		{
			logger.info("目录：" + absolutePath + "不存在");
			return false;
		}
		/*-------------------- 判断目录存在否 --------------------*/

		// 由指向原来的路径
		ftpClient.changeWorkingDirectory(firstpath);
		return true;
	}

	/**
	 * @function:递归创建远程服务器目录，如果存在就不创建了（是相对的还是绝对的；以"/"开头的:绝对的；不以"/"开头的:相对的）
	 * @param remotePath
	 *            远程服务器文件绝对/相对当前路径
	 * @return 目录创建是否成功。true:成功；false:失败
	 * @throws IOException
	 */
	public boolean mkdirs(String remotePath) throws IOException
	{
		// 创建目录之前的当前指向路径
		String firstpath = ftpClient.printWorkingDirectory();

		/*-------------------- 获得绝对路径---------------------*/
		StringBuffer curdir = new StringBuffer();
		// 处理开头：如果没有"/"，说明是相对当前路径的，转到绝对路径。
		if (remotePath.startsWith("/"))
		{
			curdir.append(remotePath);
		}
		else
		{
			if (firstpath.endsWith("/"))
			{
				curdir.append(firstpath).append(remotePath);
			}
			else
			{
				curdir.append(firstpath).append("/").append(remotePath);
			}
		}
		// 绝对路径（形式为：/resapp/test或者/:为根目录）
		String absolutePath = curdir.toString();
		// 处理结尾：如果有"/"，就删除这个符号
		if (absolutePath.endsWith("/") && !absolutePath.equals("/"))
		{
			absolutePath = absolutePath.substring(0, absolutePath.length() - 1);
		}
		/*-------------------- 获得绝对路径---------------------*/

		/*---------------- 获得所有子目录----------------*/
		// 最后需要返回的字符串列表
		List<String> list = new ArrayList<String>();
		// 模式
		Pattern p = Pattern.compile("/[^/]*+");
		// 匹配器
		Matcher m = p.matcher(absolutePath);
		// 循环匹配
		while (m.find())
		{
			// 添加匹配到的字符串
			list.add(m.group());
		}
		/*---------------- 获得所有子目录 ----------------*/

		/*---------------- 创建目录 ----------------*/
		curdir.delete(0, curdir.length());
		for (int i = 0; i < list.size(); i++)
		{
			curdir.append(list.get(i));
			if (ftpClient.changeWorkingDirectory(curdir.toString()))
			{
				logger.info("目录：" + curdir.toString() + "存在，无需创建");
			}
			else
			{
				logger.info("创建目录：" + curdir.toString() + "开始");
				if (ftpClient.makeDirectory(curdir.toString()))
				{
					logger.info("创建目录：" + curdir.toString() + "完成");
				}
				else
				{
					logger.info("创建目录：" + curdir.toString() + "失败");
					return false;
				}
			}
		}
		/*---------------- 创建目录 ----------------*/

		// 由指向原来的路径
		ftpClient.changeWorkingDirectory(firstpath);
		return true;
	}

	/**
	 * 下载匹配正则表达式名称的文件
	 * 
	 * @param remote_down_path
	 * @param local_down_path
	 * @param remote_file_regex
	 * @return
	 * @throws Exception
	 */
	public List<File> downloadFileMatchRegex(String remote_down_path, String local_down_path, String remote_file_regex)
			throws Exception
	{
		List<File> result = new ArrayList<File>();
		File fileOut = null;
		InputStream is = null;
		FileOutputStream os = null;
		try
		{
			if (ftpClient.changeWorkingDirectory(remote_down_path))
			{
				logger.info("下载文件的路径为：" + ftpClient.printWorkingDirectory());

				FTPFile[] ftpFiles = ftpClient.listFiles();
				if (ftpFiles == null || ftpFiles.length == 0)
				{
					logger.info("目录" + remote_down_path + "不存在任何文件，请重新选择");
				}
				for (FTPFile file : ftpFiles)
				{
					// 找到符合条件的文件，即文件名开头是给定的那些
					Pattern p = Pattern.compile(remote_file_regex);
					Matcher m = p.matcher(file.getName());
					if (m.find())
					{
						logger.info("开始下载文件：" + file.getName());
						is = ftpClient.retrieveFileStream(file.getName());
						if (local_down_path != null && !local_down_path.endsWith("/"))
						{
							local_down_path = local_down_path + "/";
							File path = new File(local_down_path);
							if (!path.exists())
							{
								path.mkdirs();
							}
						}
						fileOut = new File(local_down_path + file.getName());
						os = new FileOutputStream(fileOut);
						byte[] bytes = new byte[1024];
						int c;
						while ((c = is.read(bytes)) != -1)
						{
							os.write(bytes, 0, c);
						}
						result.add(fileOut);
						os.flush();
						is.close();
						os.close();
						ftpClient.completePendingCommand();
						logger.info("下载文件存放地址为：" + fileOut.getAbsolutePath());
						logger.info("结束下载文件：" + file.getName());
					}
				}
				if (result.size() == 0)
				{
					logger.info("目录" + remote_down_path + "下不存在符合" + remote_file_regex + "的文件");
				}
			}
			else
			{
				throw new Exception("远程路径找不到，请核查");
			}
		}
		catch (Exception e)
		{
			logger.error("FTP异常：", e);
			throw e;
		}
		return result;
	}

	/**
	 * 根据开始文件名匹配文件下载
	 * 
	 * @param remote_down_path
	 * @param local_down_path
	 * @param remote_down_file_name_begin
	 * @return
	 * @throws Exception
	 */
	public List<File> downloadFileBeginWithName(String remote_down_path, String local_down_path,
			String remote_down_file_name_begin) throws Exception
	{
		List<File> result = new ArrayList<File>();
		File fileOut = null;
		InputStream is = null;
		FileOutputStream os = null;
		try
		{
			if (ftpClient.changeWorkingDirectory(remote_down_path))
			{
				logger.info("下载文件的路径为：" + ftpClient.printWorkingDirectory());

				if (!ftpClient.isConnected())
				{
					connectServer();
				}

				logger.info("ftp is connect : " + ftpClient.isConnected());
				FTPFile[] ftpFiles = ftpClient.listFiles();
				if (ftpFiles == null || ftpFiles.length == 0)
				{
					throw new Exception("目录" + remote_down_path + "不存在任何文件，请重新选择");
				}
				for (FTPFile file : ftpFiles)
				{
					// 找到符合条件的文件，即文件名开头是给定的那些
					if (file.getName().startsWith(remote_down_file_name_begin))
					{
						logger.info("开始下载文件：" + file.getName());
						is = ftpClient.retrieveFileStream(file.getName());
						if (local_down_path != null && !local_down_path.endsWith("/"))
						{
							local_down_path = local_down_path + "/";
							File path = new File(local_down_path);
							if (!path.exists())
							{
								path.mkdirs();
							}
						}
						fileOut = new File(local_down_path + file.getName());
						os = new FileOutputStream(fileOut);
						byte[] bytes = new byte[1024];
						int c;
						while ((c = is.read(bytes)) != -1)
						{
							os.write(bytes, 0, c);
						}
						result.add(fileOut);
						os.flush();
						is.close();
						os.close();
						ftpClient.completePendingCommand();
						logger.info("下载文件存放地址为：" + fileOut.getAbsolutePath());
						logger.info("结束下载文件：" + file.getName());
					}
				}
				if (result.size() == 0)
				{
					logger.info("目录" + remote_down_path + "下不存在以" + remote_down_file_name_begin + "开头的文件");
					// throw new Exception("目录" + remote_down_path + "下不存在以" +
					// remote_down_file_name_begin + "开头的文件");
				}
			}
			else
			{
				throw new Exception("远程路径找不到，请核查");
			}
		}
		catch (Exception e)
		{
			logger.error("FTP异常：", e);
			throw e;
		}
		return result;
	}

	/**
	 * 移动文件
	 * 
	 * @param from_path
	 * @param to_path
	 */
	public void moveFile(String from_path, String to_path, String file_name)
	{
		try
		{

			if (to_path != null && !to_path.endsWith("/"))
			{
				to_path = to_path + "/";
			}

			int reply = ftpClient.getReplyCode();
			System.out.println(reply);
			ftpClient.changeWorkingDirectory(from_path);
			ftpClient.rename(file_name, to_path + file_name);
		}
		catch (Exception e)
		{
			e.printStackTrace();
			throw new BusiException("FTP移动文件异常：" + e.getMessage());
		}

	}

	/**
	 * 删除一个文件
	 * 
	 * @param remote_path
	 * @param remote_file_regex
	 * @throws Exception
	 */
	public void deleteFilesMatchRegex(String remote_path, String fileName) throws Exception
	{
		try
		{
			if (ftpClient.changeWorkingDirectory(remote_path))
			{
				logger.info("文件的路径为：" + ftpClient.printWorkingDirectory());

				if (remote_path != null && !remote_path.endsWith("/"))
				{
					remote_path = remote_path + "/";
				}
				logger.info("开始删除文件：" + remote_path + fileName);
				String remote_file_path = new String((remote_path + fileName).getBytes("UTF-8"), "iso-8859-1");
				boolean flag = ftpClient.deleteFile(remote_file_path);

				if (flag == false)
				{
					throw new BusiException("删除FTP远程目录文件失败:" + remote_path + fileName);
				}

			}
			else
			{
				throw new BusiException("远程路径找不到，请核查");
			}
		}
		catch (Exception e)
		{
			logger.error("FTP异常：", e);
			throw e;
		}
	}

	/**
	 * 删除文件名开头的文件
	 * 
	 * @param remote_path
	 * @param remote_down_file_name_begin
	 * @throws Exception
	 */
	public void deleteFilesBeginWithName(String remote_path, String remote_down_file_name_begin) throws Exception
	{
		try
		{
			if (ftpClient.changeWorkingDirectory(remote_path))
			{
				logger.info("文件的路径为：" + ftpClient.printWorkingDirectory());

				if (!ftpClient.isConnected())
				{
					connectServer();
				}

				logger.info("ftp is connect : " + ftpClient.isConnected());

				FTPFile[] ftpFiles = ftpClient.listFiles();
				if (ftpFiles == null || ftpFiles.length == 0)
				{
					throw new Exception("目录" + remote_path + "不存在任何文件，请重新选择");
				}

				if (remote_path != null && !remote_path.endsWith("/"))
				{
					remote_path = remote_path + "/";
				}

				for (FTPFile file : ftpFiles)
				{
					// 找到符合条件的文件，即文件名开头是给定的那些
					if (file.getName().startsWith(remote_down_file_name_begin))
					{
						logger.info("开始删除文件：" + file.getName());
						boolean flag = ftpClient.deleteFile(remote_path + file.getName());
						if (flag == false)
						{
							throw new Exception("删除FTP远程目录文件失败:" + remote_path + file.getName());
						}
					}
				}
			}
			else
			{
				throw new Exception("远程路径找不到，请核查");
			}
		}
		catch (Exception e)
		{
			logger.error("FTP异常：", e);
			throw e;
		}
	}

	/**
	 * 上传文件名开头文件
	 * 
	 * @param remote_up_path
	 * @param local_up_path
	 * @param remote_up_file_name_begin
	 * @throws Exception
	 */
	public void uploadFileBeginWithName(String remote_up_path, String local_up_path, String remote_up_file_name_begin)
			throws Exception
	{
		try
		{
			if (!this.exists(remote_up_path))
			{
				boolean flag = this.mkdirs(remote_up_path);
				if (!flag)
				{
					throw new Exception("创建目录失败:" + remote_up_path);
				}
			}
			if (ftpClient.changeWorkingDirectory(remote_up_path))
			{
				logger.info("上传文件的路径为：" + ftpClient.printWorkingDirectory());
				// 得到本地路径下的所有文件
				File menu = new File(local_up_path);
				File[] files = menu.listFiles();
				for (File file : files)
				{
					if (file.getName().startsWith(remote_up_file_name_begin))
					{
						logger.info("开始上传文件：" + file.getName());
						OutputStream os = ftpClient.storeFileStream(file.getName());
						FileInputStream is = new FileInputStream(file);
						byte[] bytes = new byte[1024];
						int c;
						while ((c = is.read(bytes)) != -1)
						{
							os.write(bytes, 0, c);
						}
						os.close();
						is.close();
						ftpClient.completePendingCommand();// 必须写，而且必须在is.close()后面
						logger.info("结束上传文件：" + file.getName());
					}
				}
			}
			else
			{
				throw new Exception("远程目录不存在");
			}
		}
		catch (Exception e)
		{
			logger.error("上传FTP文件异常: ", e);
			throw e;
		}
	}

	
	/**
	 * * 写控制文件.ctl
	 * 
	 * @param fileRoute
	 *            数据文件地址路径
	 * @param fileName
	 *            数据文件名
	 * @param tableName
	 *            表名
	 * @param fieldName
	 *            要写入表的字段
	 * @param ctlfileName
	 *            控制文件名
	 */
	public static void stlFileWriter(String fileRoute, String fileName, String tableName, String fieldName,
			String ctlfileName){
		FileWriter fw = null;
		/*
		 * String strctl = "OPTIONS (skip=0) \rn" +
		 * " LOAD DATA INFILE '"+fileRoute+""+fileName+"' \rn" +
		 * " APPEND INTO TABLE "+tableName+" \rn" +
		 * " FIELDS TERMINATED BY ',' \rn" +
		 * " OPTIONALLY  ENCLOSED BY \"'\" \rn" +
		 * " TRAILING NULLCOLS "+fieldName+"";
		 */
		StringBuffer sb = new StringBuffer();
		sb.append("Load data \n");
		sb.append("CHARACTERSET \"ZHS16GBK\" \n");
		sb.append("infile " + "\"" + fileRoute + "" + fileName + "\"" + " \n");
		sb.append("into table " + tableName + " append \n");
		sb.append("fields terminated by ',' \n	");
		sb.append("TRAILING NULLCOLS \n");
		sb.append("( \n");
		sb.append(fieldName);
		sb.append(") \n");
		try
		{
			fw = new FileWriter(fileRoute + "" + ctlfileName);
			fw.write(sb.toString());
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				fw.flush();
				fw.close();
			}
			catch (IOException e)
			{
				e.printStackTrace();
			}
		}
	}

	/**
	 * 调用系统DOS命令
	 * 
	 * @param user
	 * @param psw
	 * @param Database
	 * @param fileRoute
	 *            文件路径
	 * @param ctlfileName
	 *            控制文件名
	 * @param logfileName
	 *            日志文件名
	 */
	public static void executiveSqlload(String user, String psw, String Database, String fileRoute, String ctlfileName,
			String recordRoute, String recordFileName, String logRoute, String logfileName)
	{
		InputStream ins = null;
		// 要执行的DOS命令 --数据库 用户名 密码 user/password@database
		String dos = "sqlldr userid=" + user + "/" + psw + "@" + Database + " control=" + fileRoute + "" + ctlfileName
				+ " bad=" + recordRoute + "" + recordFileName + " log=" + logRoute + "" + logfileName;
		System.out.println("---需要执行的DOS命令---:" + dos);
		// String dos="dir";

		System.out.println(dos);
		// String[] cmd = new String[] { "cmd.exe", "/C", dos }; // windows 下
		String[] cmd = new String[] { "/bin/sh", "-c", dos };// linux 下

		try
		{
			Process process = Runtime.getRuntime().exec(cmd);
			ins = process.getInputStream(); // 获取执行cmd命令后的信息
			StreamGobbler errorGobbler = new StreamGobbler(process.getErrorStream(), "Error");
			StreamGobbler outputGobbler = new StreamGobbler(process.getInputStream(), "Output");
			errorGobbler.start();
			outputGobbler.start();
			process.waitFor();
			process.getOutputStream().close(); // 关闭
		}
		catch (Exception e)
		{
			e.printStackTrace();
			System.out.println("--SQL*LOADER执行异常--" + e + e.getMessage());
		}
	}
	
	public static void main(String[] args)	{
		FtpUtils f = new FtpUtils();
		f.setIp("172.21.1.207");
		f.setPort(21);
		f.setPwd("crmnga");
		f.setUser("crmnga");
		String remotePath = "/crmnga/work/liudw/uploadFile";
		String localPath = "./doc";
		String fileNames = "批量开户_BOSS_liudw_1408260944.TXT";

		String s = fileNames.substring(0, fileNames.lastIndexOf("."));
		String x = fileNames.substring(fileNames.lastIndexOf("."));
		String rightPath = "./doc/right";
		String rightName = s + "_right" + x;

		String upPath = "/crmnga/work/liudw/checkFile";

		try{

			if (rightPath != null && !rightPath.endsWith("/"))	{
				rightPath = rightPath + "/";
				File path = new File(rightPath);
				if (!path.exists()){
					path.mkdirs();
				}
			}
			
			File rightTxt = new File(rightPath + rightName);
			if (rightTxt.exists()){
				System.out.print("文件存在");
				rightTxt.delete();
			}else{
				System.out.print("文件不存在");
				rightTxt.createNewFile();// 不存在则创建 }
			}
			
			if (f.connectServer())			{
				System.out.println("连上了");
				File file = f.downloadFile(remotePath, localPath, fileNames);
				BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(file), "GBK"));
				StringBuffer right = new StringBuffer();
				StringBuffer wrong = new StringBuffer();
				String sLine = null;
				while ((sLine = br.readLine()) != null){
					right.append(sLine + "\n");
					wrong.append(wrong);
					System.out.println("****");
				}
				br.close();
				/*
				 * for(int i=0;i<10;i++){ //right.append("\n");
				 * right.append(right+">>"); System.out.println("*****");
				 * //wrong.append("\n"); //wrong.append(wrong); }
				 */

				BufferedWriter output = new BufferedWriter(new FileWriter(rightPath + rightName));
				output.write(right.toString());
				output.close();

				f.uploadFile(upPath, rightPath, rightName);
				System.out.println(file.getPath() + ">>>>>>>>" + file.getName());
			}
		}catch (Exception e)	{
			// TODO Auto-generated catch block
			e.printStackTrace();
			try			{
				f.closeServer();
			}catch (Exception e1){
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}finally{
			try{
				f.closeServer();
			}catch (Exception e){
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
 

		Map<String, String>mapa = FtpUtils.getFtpInfo();
		System.out.println(mapa.get("HOSTIP"));
		System.out.println(Integer.parseInt(mapa.get("BATCH_FUNC_FTP_PROT").trim()));
		System.out.println(mapa.get("HOSTUSER"));// 主机名称
		System.out.println(mapa.get("HOSTPASSWD"));// 主机密码
	}

	
	/**
	 * @return the logger
	 */
	public Logger getLogger() {
		return logger;
	}

	/**
	 * @param logger the logger to set
	 */
	public void setLogger(Logger logger) {
		this.logger = logger;
	}

	/**
	 * @return the ip
	 */
	public String getIp() {
		return ip;
	}

	/**
	 * @param ip the ip to set
	 */
	public void setIp(String ip) {
		this.ip = ip;
	}

	/**
	 * @return the port
	 */
	public int getPort() {
		return port;
	}

	/**
	 * @param port the port to set
	 */
	public void setPort(int port) {
		this.port = port;
	}

	/**
	 * @return the pwd
	 */
	public String getPwd() {
		return pwd;
	}

	/**
	 * @param pwd the pwd to set
	 */
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	/**
	 * @return the user
	 */
	public String getUser() {
		return user;
	}

	/**
	 * @param user the user to set
	 */
	public void setUser(String user) {
		this.user = user;
	}

	/**
	 * @return the ftpClient
	 */
	public FTPClient getFtpClient() {
		return ftpClient;
	}

	/**
	 * @param ftpClient the ftpClient to set
	 */
	public void setFtpClient(FTPClient ftpClient) {
		this.ftpClient = ftpClient;
	}
	
}