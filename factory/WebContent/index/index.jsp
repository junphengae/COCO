<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/index.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Welcome to VBI</title>
<script type="text/javascript">
	$(function(){
		$('.main_menu').click(function(){
			var position = $(this).position();
			var left = position.left + $(this).outerWidth() + 100;
			
			var $menuSelect = $('#menu_body_' + $(this).attr('lang'));
			$menuSelect.css({'left':left,'top':100});
			
			if ($menuSelect.css('display')=='none') {
				$menuSelect.slideDown();//fadeIn(500);
				$('.wrap_menu_body').not($menuSelect).css({'display':'none'});
			} else {
				$menuSelect.fadeOut(500);
			}
			$('.main_menu').removeClass('active');
		});
		
		$('*').mouseup(function(){
			$('.wrap_menu_body:visible').fadeOut(500);
		});
	});
	
	function setOnLoad(){
		setTimeout("window.location='index.jsp'",600000);
	}
</script>
</head>
<body <%if(!securProfile.isLogin()){%>onload="setOnLoad();"<%}%>>

<div class="wrap_all">
	<jsp:include page="index_header.jsp"></jsp:include>
	<%if(WebUtils.getReqString(request,"SYSTEM").length() > 0){session.setAttribute("SYSTEM",WebUtils.getReqString(request,"SYSTEM"));}%>
	<div class="wrap_body">
	<%
		if(securProfile.isLogin()){
			String stm = "";
			if(session.getAttribute("SYSTEM")!=null){
				stm = (String)session.getAttribute("SYSTEM");
			}
			Iterator sysIte = securProfile.getList().iterator();
			while (sysIte.hasNext()) {
				String active = "";
				SecuritySystem sys = (SecuritySystem) sysIte.next();
				if (stm.equalsIgnoreCase(sys.getSys_id())){
					active = " active";
				}
		%>
		<div class="main_menu <%=active%>" lang="<%=sys.getSys_id()%>"><%=sys.getSys_name()%>
			<div class="wrap_menu_body" id="menu_body_<%=sys.getSys_id()%>">
		<%
				Iterator unitIte = sys.getUIUnitList().iterator();
				while (unitIte.hasNext()) {
					SecurityUnit unit = (SecurityUnit) unitIte.next();
		%>
				<div class="menu" onclick="javascript: window.location='../<%=unit.getUnit_url()%>?SYSTEM=<%=sys.getSys_id()%>';"><a href="../<%=unit.getUnit_url()%>?SYSTEM=<%=sys.getSys_id()%>"><%=unit.getUnit_name()%></a></div>
		<%
				}
		%>
			</div>
		</div>
		<%	
			}
		}
	%>
		<div class="clear"></div>
	</div>
	
	<jsp:include page="footer.jsp"></jsp:include>
	
</div>

</body>
</html>