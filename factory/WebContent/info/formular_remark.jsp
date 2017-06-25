<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%
InventoryMaster entity = new InventoryMaster();
WebUtils.bindReqToEntity(entity, request);
InventoryMaster.select(entity);
%>
</head>
<body>
<div class="center txt_left">
	<%=entity.getRemark()%>
</div>
</body>
</html>