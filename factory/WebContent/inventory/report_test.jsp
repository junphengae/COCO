<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.bean.util.StatusUtil"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Viewer</title>

</head>

<%
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=lotcontrol_" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls");
%>
<body>
	<table class="tb">
		<tbody>
			<tr align="center">
				<td>รหัสสินค้า</td>
				<td>จำนวน</td>
			</tr>
			<%
			List<InventoryMaster> listLot = InventoryLot.test();
			for (InventoryMaster entity : listLot) {
				
			%>
			<tr>
				<td><%=entity.getMat_code()%></td>
				<td><%=entity.getBalance()%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	