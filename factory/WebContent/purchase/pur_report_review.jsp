<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.purchase.PurchaseReport"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
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
	/** รายการเปิด PO ประจำช่วงเวลา **/
	if (report_type.equalsIgnoreCase(StatusUtil.PUR_PO_LIST)) {
	%>
	<table>
		<tbody>
			<tr>
				<td>
					รายงานการสั่งซื้อประจำเดือน <%=month%> - <%=year%>
				</td>
			</tr>
		</tbody>
	</table>
	<table class="tb">
		<tbody>
			<tr align="center">
				<td rowspan="2">ตัวแทนจำหน่าย</td>
				<td rowspan="2">เปิด PO</td>
				<td rowspan="2">ยกเลิก PO</td>
				<td colspan="3">ส่งแล้ว</td>
			</tr>
			<tr align="center">
				<td>ส่งตรงกำหนด</td>
				<td>ส่งเกินกำหนด</td>
				<td>ยังไม่จัดส่ง</td>
			</tr>
			<%
			List<PurchaseReport> listLot = new ArrayList();
			
			listLot = PurchaseOrder.report4purchase(year, month);
			
			for (PurchaseReport rp : listLot) {
				String open = "0";//จำนวน po ที่ยังไม่ได้ปิด
				//open = Money.subtract(rp.getPo_sum(), Money.add(rp.getPo_close_on_time(), rp.getPo_close_late()));
			%>
			<tr>
				<td><%=rp.getVendor().getVendor_name()%></td>
				<td align="right"><%=rp.getPo_sum()%></td>
				<td align="right"><%=rp.getPo_terminate()%></td>
				<td align="right"><%=rp.getPo_close_on_time()%></td>
				<td align="right"><%=rp.getPo_close_late()%></td>
				<td align="right"><%=open%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<%
	}
	
	/** Active Lot **/
	if (report_type.equalsIgnoreCase(StatusUtil.INV_ACTIVE_LOT)) {
	%>
	<table class="tb">
		<tbody>
			<tr align="center">
				<td>รหัสสินค้า</td>
				<td>ประเภท</td>
				<td>ชื่อสินค้า</td>
				<td>ลักษณะบรรจุภัณฑ์</td>
				<td>เลขที่ Lot</td>
				<td>ราคาต่อหน่วย</td>
				<td>จำนวนรับเข้า</td>
				<td>จำนวนคงเหลือ</td>
				<td>วันรับเข้า</td>
				<td>วันหมดอายุ</td>
				<td>PO/PD</td>
				<td>Invoice</td>
				<td>ตัวแทนจำหน่าย</td>
			</tr>
			<%
			List<InventoryLot> listLot = InventoryLot.selectActiveList();
			for (InventoryLot lot : listLot) {
				InventoryMaster entity = lot.getUIMat();
				InventoryLotControl lotCtrl = lot.getUILot_control();
				Vendor vendor = lot.getUIVendor();
			%>
			<tr>
				<td><%=entity.getMat_code()%></td>
				<td><%=entity.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + entity.getUISubCat().getUICat().getCat_name_short() + ((entity.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + entity.getUISubCat().getSub_cat_name_short():"")%></td>
				<td><%=entity.getDescription()%></td>
				<td><%=entity.getDes_unit()%></td>
				<td><%=lot.getLot_no()%></td>
				<td align="right"><%=lot.getLot_price()%></td>
				<td align="right"><%=lot.getLot_qty()%></td>
				<td align="right"><%=lotCtrl.getLot_balance()%></td>
				<td align="center"><%=WebUtils.getDateValue(lot.getCreate_date())%></td>
				<td align="center"><%=WebUtils.getDateValue(lot.getLot_expire())%></td>
				<td><%=lot.getPo()%></td>
				<td><%=lot.getInvoice()%></td>
				<td><%=vendor.getVendor_name()%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<%
	}
	%>
	
</body>
</html>