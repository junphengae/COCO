<%@page import="com.bitmap.bean.logistic.Detail_send"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="com.bitmap.bean.rd.MatTree"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.logistic.ProduceItemMat"%>
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
<%
String report_type = WebUtils.getReqString(request, "report_type");
String export = WebUtils.getReqString(request, "export");

String time = WebUtils.getReqString(request, "time");
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");

if (export.equalsIgnoreCase("true")) {
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=" + report_type + "_" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls");
%>
<style type="text/css">
.tb{border-collapse: collapse;}
.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}

</style>
<%
} else {
%>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/theme_print.css" rel="stylesheet" type="text/css" media="all">

<%}%>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Viewer</title>

</head>
<body>

	<%
	/** plan_send_pd **/
	if (report_type.equalsIgnoreCase("plan_send_pd")) {
	%>
	<table class="tb">
		<tbody>
			<tr align="center">
				<td width="20%">ชื่อบริษัท</td>
				<td width="30%">รายการสินค้า</td>
				<td width="10%">จำนวน</td>
				<td width="10%">เลขที่บิล</td>
				<td width="10%">น้ำหนัก</td>
				<td width="10%">การตรวจสอบ</td>
			</tr>	
			<tr>
				
			</tr>
		</tbody>
	</table>
	<%
	}
	%>
</body>
</html>