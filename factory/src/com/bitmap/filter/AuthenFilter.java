package com.bitmap.filter;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bitmap.security.SecurityProfile;

/**
 * Servlet Filter implementation class AuthenFilter
 */
public class AuthenFilter implements Filter {
	private ArrayList<String> urlList;
	private int totalURLS;

	public void destroy() {
	}

	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain chain) throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;  

		String url = request.getServletPath();
		String[] splitUrl = url.split("/");
		//System.out.println(url);
		boolean allowedRequest = false;  

		for(int i=0; i<totalURLS; i++) {
			if(url.contains(urlList.get(i))) {
				allowedRequest = true;
				break;
		    }
		}
		
		String forwardTo = "home.jsp";
		if (splitUrl.length > 2) {
			forwardTo = "../home.jsp";
		}
		
		if (!allowedRequest) {
			HttpSession session = request.getSession();
			if (null == session) {
				response.sendRedirect(forwardTo);
			} else {
				SecurityProfile profile = (SecurityProfile) session.getAttribute("securProfile");
				if (profile == null) {
					response.sendRedirect(forwardTo);
				}
			}
			chain.doFilter(request, response);
		}
	}

	public void init(FilterConfig config) throws ServletException {
		
	}
}