package com.belong.control;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.belong.service.IMusicService;
import com.belong.service.MusicServiceImp;
import com.belong.vo.Music;

/**
 * Servlet implementation class MusicControl
 */
@WebServlet(name="/MusicControl",urlPatterns={"*.do"},
initParams={
		@WebInitParam(name="show",value="/MusicControl.do?action=show"),
		@WebInitParam(name="success",value="show.jsp"),
		@WebInitParam(name="index",value="index.jsp")
})
public class MusicControl extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private Map<String,String> map = new HashMap<String,String>();  
    private IMusicService service = new MusicServiceImp();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MusicControl() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");
		switch(action){
		case "add":
			add(request,response);
			break;
		case "show":
			show(request,response);
			break;
		case "del":
			del(request,response);
			break;
		default:
			break;
		}
	}
	public void add(HttpServletRequest request, HttpServletResponse response){		
		try {
			String name = new String(request.getParameter("name").getBytes("ISO8859-1"),"utf-8");
			String singer = new String(request.getParameter("singer").getBytes("ISO8859-1"),"utf-8");
			String special = new String(request.getParameter("special").getBytes("ISO8859-1"),"utf-8");
			Music music=new Music();
			music.setName(name);
			music.setSinger(singer);
			music.setSpecial(special);
			RequestDispatcher dispatcher = null;
			if(service.addMusic(music)){
				dispatcher = request.getRequestDispatcher(map.get("show"));
			} else {
				dispatcher = request.getRequestDispatcher(map.get("index"));
			}
			try {
				dispatcher.forward(request, response);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}
	public void show(HttpServletRequest request, HttpServletResponse response){
		RequestDispatcher dispatcher = null;
		List<Music> list = service.queryMusic();
		request.setAttribute("mlist", list);
		dispatcher = request.getRequestDispatcher(map.get("success"));
		try {
			dispatcher.forward(request, response);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public void del(HttpServletRequest request, HttpServletResponse response){
		String id = request.getParameter("id");
		Music music = new Music();
		music.setId(Integer.parseInt(id));
		RequestDispatcher dispatcher = null;
		if(service.delMusic(music)){
			dispatcher = request.getRequestDispatcher(map.get("show"));
		}
		try {
			dispatcher.forward(request, response);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	@Override
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		map.put("index",config.getInitParameter("index"));
		map.put("success", config.getInitParameter("success"));
		map.put("show",config.getInitParameter("show"));
	}
	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		super.destroy();
	}
}