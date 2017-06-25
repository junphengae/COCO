<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.bean.rd.RDFormularInfo"%>
<%@page import="com.bitmap.servlet.rd.RDManagement"%>
<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>



<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>formular view</title>
<%
String mat_code = WebUtils.getReqString(request, "mat_code");
//PageControl ctrl = (PageControl) session.getAttribute("PAGE_CTRL");
InventoryMaster invMaster = InventoryMaster.select(mat_code);
session.setAttribute("MAT", invMaster);
%>
<script language="JavaScript">

</script>
</head>
<body>


				
				<fieldset class="s450 center fset">
					<legend>ข้อมูลสินค้า</legend>
					<table width="100%">
						<tbody>
							<tr>
								<td width="40%">กลุ่ม</td>
								<td width="60%">: <%=invMaster.getUISubCat().getUICat().getUIGroup().getGroup_name_th()%></td>
							</tr>
							<tr>
								<td>ชนิด</td>
								<td>: <%=invMaster.getUISubCat().getUICat().getCat_name_th()%></td>
							</tr>
							<tr>
								<td>ชนิดย่อ</td>
								<td>: <%=invMaster.getUISubCat().getSub_cat_name_th()%></td>
							</tr>
							<tr><td colspan="2" height="20"></td></tr>
							<tr>
								<td>รหัสสินค้า</td>
								<td>: <%=mat_code%></td>
							</tr>
							<tr>
								<td>ชื่อสินค้า</td>
								<td>: <%=invMaster.getDescription()%></td>
							</tr>							
						</tbody>
					</table>					
				</fieldset>

				<div class="clear"></div>

				
				
				<fieldset class="s600 fset">
					<legend>รายการวัตถุดิบที่ใช้</legend>					
					<table class="bg-image s600">
						<thead>
							<tr>
								<th valign="top" align="center" width="10%">ขั้นตอน</th>
								<th valign="top" align="center" width="15%">รหัสวัตถุดิบ</th>
								<th valign="top" align="center" width="10%">อัตราส่วน</th>
								<th valign="top" align="center" width="30%">วิธีการเตรียม</th>
								<th valign="top" align="center" width="30%">กระบวนการผลิต</th>								
							</tr>
						</thead>
						<tbody id="material_list">						
							
						</tbody>
					</table>
				</fieldset>
				
		

</body>
</html>