<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<link type="image/x-icon" href="../images/vbi_16x16.ico" rel="shortcut icon">
<%
if(WebUtils.getReqString(request,"SYSTEM").length() > 0){session.setAttribute("SYSTEM",WebUtils.getReqString(request,"SYSTEM"));}
String stm = "";
if(session.getAttribute("SYSTEM")!=null){
	stm = (String)session.getAttribute("SYSTEM");
}

Iterator sysIte = securProfile.getList().iterator();
String sys_name = "";
SecuritySystem sys = new SecuritySystem();
while (sysIte.hasNext()) {
	sys = (SecuritySystem) sysIte.next();
	if (stm.equalsIgnoreCase(sys.getSys_id())){
		sys_name = sys.getSys_name();
		break;
	}
}
%>
	<div class="wrap_header">
		<div class="wrap_logo"><a href="../home.jsp"><img src="../images/homelogo_vbi.png"></a></div>
		<div class="wrap_menu">
			<div class="head_info_left"><%=sys_name%></div>
			<div class="head_info_right"><%=(securProfile.isLogin())?securProfile.getPersonal().getName() + "&nbsp;&nbsp;" + securProfile.getPersonal().getSurname():""%></div>
			<div class="clear"></div>
			<div class="head_line"></div>
			<div class="clear"></div>
			<div class="head_menu_left">
			<%
			Iterator unitIte = sys.getUIUnitList().iterator();
			while (unitIte.hasNext()) {
				SecurityUnit unit = (SecurityUnit) unitIte.next();
			%>
				<a href="../<%=unit.getUnit_url()%>"><%=unit.getUnit_name()%></a> | 
			<%}%>
			</div>
			<div class="head_menu_right">
			<%if(securProfile.isLogin()){%>
				<a title="logout" class="pointer" onclick="if(confirm('คุณต้องการออกจากระบบหรือไม่?')){window.location='../index/out.jsp'}">Logout</a>
			<%} else { %>
				<a class="thickbox pointer" lang="login.jsp?width=350&height=240" title="เข้าสู่ระบบ">Login</a>
			<%} %>
			</div>
		</div>
		<div class="clear"></div>
	</div>
