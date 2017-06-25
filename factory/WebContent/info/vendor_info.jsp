<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Vendor Information</title>
<%
String vendor_id = WebUtils.getReqString(request,"vendor_id");
String mat_code = WebUtils.getReqString(request, "mat_code");
Vendor entity = Vendor.select(vendor_id);
InventoryMasterVendor invVendor = InventoryMasterVendor.select(mat_code, vendor_id);
%>
</head>
<body>
<div class="m_top10"></div>
<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="95%">
	<tbody>
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
			<td>: <%=entity.getVendor_ship()%></td>
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
		<tr>
			<td><label>จำนวนต่ำสุดที่จัดส่ง</label></td>
			<td>: <%=invVendor.getVendor_moq()%></td>
		</tr>
		<tr>
			<td><label>ระยะเวลาในการจัดส่ง</label></td>
			<td>: <%=invVendor.getVendor_delivery_time()%></td>
		</tr>
	</tbody>
</table>
<div class="center txt_center m_top5"><button class="btn_box" onclick="tb_remove();">ปิด</button></div>
</body>
</html>