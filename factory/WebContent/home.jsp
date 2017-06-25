<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link href="css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="css/loading.css" rel="stylesheet" type="text/css" media="all">
<link type="image/x-icon" href="images/vbi_16x16.ico" rel="shortcut icon">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
</head>
<body>

<div id="Ajax_overlay" class="Ajax_overlayBG"></div>
<div id="Ajax_window"></div>
<div id="Ajax_load" style="display: block;"><img src="images/loading/loadingAnimation.gif"></div>

<script type="text/javascript">
	window.location="index/index.jsp";
</script>

</body>
</html>