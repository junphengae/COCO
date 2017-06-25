<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<link type="image/x-icon" href="../images/vbi_16x16.ico" rel="shortcut icon">
	<div class="wrap_header">
		<div class="wrap_logo"><a href="../home.jsp"><img src="../images/homelogo_vbi.png"></a></div>
		<div class="wrap_menu">
			<div class="head_info_left">COCONUT FACTOTY</div>
			<div class="head_info_right"><%=(securProfile.isLogin())?securProfile.getPersonal().getName() + "&nbsp;&nbsp;" + securProfile.getPersonal().getSurname():""%></div>
			<div class="clear"></div>
			<div class="head_line"></div>
			<div class="clear"></div>
			<div class="head_menu_left"></div>
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
