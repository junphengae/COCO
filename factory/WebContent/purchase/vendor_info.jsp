<%@page import="com.bmp.vendor.VendorTS"%>
<%@page import="com.bmp.vendor.VendorBean"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/table.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Vendor Information</title>
<%
String vendor_id = WebUtils.getReqString(request,"vendor_id");
VendorBean entity = VendorTS.select(vendor_id);

String ship_name="";
if(entity.getVendor_ship().equalsIgnoreCase("land")){
	ship_name="ทางบก";
}else 
	if(entity.getVendor_ship().equalsIgnoreCase("sea")){
	ship_name="ทางเรือ";
}else  
	if(entity.getVendor_ship().equalsIgnoreCase("air")){
	ship_name="ทางอากาศ";
}
%>
</head>
<body>
<div class="m_top10"></div>
<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="95%">
	<tbody>
		<tr>
			<td align="left" width="33%"><label>รหัสตัวแทนจำหน่าย</label></td>
			<td align="left" width="67%">: <%=entity.getVendor_code()%></td>
		</tr>
		<tr>
			<td align="left" width="33%"><label>ชื่อผู้ขาย</label></td>
			<td align="left" width="67%">: <%=entity.getVendor_name()%></td>
		</tr>
		<tr>
			<td><label>โทรศัพท์</label></td>
			<td>: <%=entity.getVendor_phone()%></td>
		</tr>
		<tr>
			<td><label>แฟกซ์</label></td>
			<td>: <%=entity.getVendor_fax()%></td>
		</tr>
		<tr valign="top">
			<td><label>ที่อยู่</label></td>
			<td>: <%=entity.getVendor_address()%></td>
		</tr>
		<tr>
			<td valign="top"><label>Email</label></td>
			<td valign="top">: <%=entity.getVendor_email()%></td>
		</tr>
		<tr>
			<td><label>ผู้ติดต่อ</label></td>
			<td>: <%=entity.getVendor_contact()%></td>
		</tr>
		<tr>
			<td><label>ประเภทการส่ง</label></td>
			<td>: <%=ship_name%></td>
		</tr>
		<tr>
			<td><label>เงื่อนไขการจัดส่ง</label></td>
			<td>: <%=entity.getVendor_condition()%></td>
		</tr>
		<tr>
			<td><label>ระยะ credit</label></td>
			<td>: <%=entity.getVendor_credit()%></td>
		</tr>
		<tr><td height="20"></td></tr>

	</tbody>
</table>
<div class="center txt_center m_top5">
<!-- <input type="button" class="btn_box center" value="ปิด"   title="ปิด" onclick="javascript:closed;"> -->
<div class="center txt_center m_top5"><button class="btn_box"  onclick='window.close();'>ปิด</button></div>
</div>
</body>
</html>