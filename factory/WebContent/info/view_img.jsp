<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%
	String img = WebUtils.getReqString(request, "img");
%>
</head>
<body>
<div class="s350 center txt_center m_top20">
	<img src="../path_images/inventory/<%=img%>.jpg">
</div>
</body>
</html>