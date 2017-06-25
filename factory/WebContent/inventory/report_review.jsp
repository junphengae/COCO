<%@page import="com.bitmap.bean.rd.TreeInv"%>
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

String date_start = WebUtils.getReqString(request, "date_start");
String date_end = WebUtils.getReqString(request, "date_end");

String time = WebUtils.getReqString(request, "time");
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");
String mat_code = WebUtils.getReqString(request, "mat_code");
String lot_no = WebUtils.getReqString(request, "lot_no");

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
	/** Balance **/
	if (report_type.equalsIgnoreCase(StatusUtil.INV_BALANCE)) {
	%>
	<table class="tb">
		<tbody>
			<tr align="center">
				<td>รหัสสินค้า</td>
				<td>ประเภท</td>
				<td>ชื่อสินค้า</td>
				<td>รหัสเดิม</td>
				<td>สถานที่เก็บ</td>
				<td>คงคลัง</td>
				<td>หน่วยนับ</td>
				<td>ลักษณะบรรจุภัณฑ์</td>
				<td>ราคาขายกลาง</td>
				<td>ต้นทุน</td>
			</tr>
			<%
			List<InventoryMaster> listMat = InventoryMaster.selectList();
			for (InventoryMaster entity : listMat) {
			%>
			<tr>
				<td><%=entity.getMat_code()%></td>
				<td><%=entity.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + entity.getUISubCat().getUICat().getCat_name_short() + ((entity.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + entity.getUISubCat().getSub_cat_name_short():"")%></td>
				<td><%=entity.getDescription()%></td>
				<td><%=entity.getRef_code()%></td>
				<td align="center"><%=entity.getLocation()%></td>
				<td align="right"><%=entity.getBalance()%></td>
				<td><%=entity.getStd_unit()%></td>
				<td><%=entity.getDes_unit()%></td>
				<td align="right"><%=entity.getPrice()%></td>
				<td align="right"><%=entity.getCost()%></td>
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
				<td>เลขที่ Lot</td>
				<td>ราคาต่อหน่วย</td>
				<td>จำนวนรับเข้า</td>
				<td>จำนวนคงเหลือ</td>
				<td>หน่วยนับ</td>
				<td>ลักษณะบรรจุภัณฑ์</td>
				<td>วันที่ผลิต</td>
				<td>วันรับเข้า</td>
				<td>วันหมดอายุ</td>
				<td>PO/PD</td>
				<td>Invoice</td>
				<td>ตัวแทนจำหน่าย</td>
			</tr>
			<%
			List<InventoryLot> listLot = InventoryLot.selectActiveListNEW();
			for (InventoryLot lot : listLot) {
				InventoryMaster entity = lot.getUIMat();
			%>
			<tr>
				<td><%=entity.getMat_code()%></td>
				<td><%=entity.getGroup_id() + "-" + lot.getUICatName() + ((lot.getUISubCatName().length() > 0)?"-" + lot.getUISubCatName():"")%></td>
				<td><%=entity.getDescription()%></td>
				<td><%=lot.getLot_no()%></td>
				<td align="right"><%=lot.getLot_price()%></td>
				<td align="right"><%=lot.getLot_qty()%></td>
				<td align="right"><%=lot.getUILotB()%></td>
				<td><%=entity.getStd_unit()%></td>
				<td><%=entity.getDes_unit()%></td>
				<td align="center"><%=WebUtils.getDateValue(lot.getMfg())%></td>
				<td align="center"><%=WebUtils.getDateValue(lot.getCreate_date())%></td>
				<td align="center"><%=WebUtils.getDateValue(lot.getLot_expire())%></td>
				<td><%=lot.getPo()%></td>
				<td><%=lot.getInvoice()%></td>
				<td><%=lot.getUIVendors()%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<%
	}
	
	/** Inlet **/
	if (report_type.equalsIgnoreCase(StatusUtil.INV_INLET)) {
	%>
	<table class="tb">
		<tbody>
			<tr>
				<td>รหัสสินค้า</td>
				<td>ประเภท</td>
				<td>ชื่อสินค้า</td>
				<td>เลขที่ Lot</td>				
				<td>จำนวนรับเข้า</td>
				<td>หน่วยนับ</td>
				<td>ลักษณะบรรจุภัณฑ์</td>
				<td>ราคาต่อหน่วย</td>
				<td>วันที่ผลิต</td>
				<td>วันรับเข้า</td>
				<td>วันหมดอายุ</td>	
				<td>PO/PD</td>
				<td>Invoice</td>
				<td>ตัวแทนจำหน่าย</td>
			</tr>
			<%
			List<InventoryLot> listLot = new ArrayList();
			System.out.println("Radio:"+time);
			if (time.equalsIgnoreCase("date")){
				listLot = InventoryLot.report(WebUtils.getReqDate(request, "create_date1") , WebUtils.getReqDate(request, "create_date2") ,mat_code, lot_no);
			} else {
				listLot = InventoryLot.report(year,month,mat_code, lot_no);
			}
		
			
			for (InventoryLot lot : listLot) {
				InventoryMaster entity = lot.getUIMat();
				Vendor vendor = lot.getUIVendor();
			%>
			<tr>
				<td><%=entity.getMat_code()%></td>
				<td><%=entity.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + entity.getUISubCat().getUICat().getCat_name_short() + ((entity.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + entity.getUISubCat().getSub_cat_name_short():"")%></td>
				<td><%=entity.getDescription()%></td>
				<td><%=lot.getLot_no()%></td>
			
				<td align="center"><%=lot.getLot_qty()%></td>
				<td><%=entity.getStd_unit()%></td>
				<td><%=entity.getDes_unit()%></td>
				<td align="right"><%=lot.getLot_price()%></td>
				<td align="center"><%=WebUtils.getDateValue(lot.getMfg())%></td>
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
	
	/** Outlet **/
	if (report_type.equalsIgnoreCase(StatusUtil.INV_OUTLET)) {
	%>
	<table class="tb">
		<tbody>
			<tr>
				<td>รหัสสินค้า</td>
				<td>ประเภท</td>
				<td>ชื่อสินค้า</td>
				<td>วันที่ผลิต</td>
				<td>วันรับเข้า</td>
				<td>วันหมดอายุ</td>	
				<td>เลขที่ Lot</td>
				<td>วัน / เวลาที่เบิก</td>
				<td>จำนวน</td>
				<td>หน่วยนับ</td>
				<td>ลักษณะบรรจุภัณฑ์</td>
				<td>ประเภทการเบิก</td>
				<td>เลขอ้างอิงการเบิก</td>
				<td>ผู้เบิก</td>
			</tr>
			<%
			List<InventoryLotControl> listLot = new ArrayList();
			System.out.println("Radio:"+time);
			if (time.equalsIgnoreCase("date")){
				listLot = InventoryLotControl.report(WebUtils.getReqDate(request, "create_date1"),WebUtils.getReqDate(request, "create_date2"),mat_code, lot_no);
			} else {
				listLot = InventoryLotControl.report(year,month,mat_code, lot_no);
			}
		
			for (InventoryLotControl lotC : listLot) {
				
				TreeInv entity = lotC.getUItree();
				Personal per = lotC.getUIPersonal();
				InventoryLot lot = InventoryLot.select(lotC.getLot_no());
			%>
			<tr>
				<td><%=entity.getMat_code()%></td>
				<td><%=entity.getGroup_id() + "-" + entity.getCat_name() + ((entity.getSub_cat_name().length() > 0)?"-" + entity.getSub_cat_name():"")%></td>
				<td><%=entity.getDescription()%></td>								
				<td align="center"><%=WebUtils.getDateTimeValue(lot.getMfg())%></td>
				<td align="center"><%=WebUtils.getDateTimeValue(lot.getCreate_date())%></td>
				<td align="center"><%=WebUtils.getDateTimeValue(lot.getLot_expire())%></td>				
				<td><%=lotC.getLot_no()%></td>
				<td><%=WebUtils.getDateTimeValue(lotC.getRequest_date())%></td>
				<td align="right"><%=lotC.getRequest_qty()%></td>
				<td><%=entity.getStd_unit()%></td>
				<td><%=entity.getDes_unit()%></td>
				<td><%=lotC.getRequest_type()%></td>
				<td><%=lotC.getRequest_no()%></td>
				<td align="left"><%=lotC.getUIqty()%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<%
	}
	%>
	
	<%if(report_type.equalsIgnoreCase(StatusUtil.INV_MOR)) { %>
		<table class="tb">
		<tbody>
			<tr align="center">
				<td>รหัสสินค้า</td>
				<td>ชื่อสินค้า</td>
				<td>คงคลัง</td>
				<td>หน่วยนับ</td>
				<td>ลักษณะบรรจุภัณฑ์</td>
				<td>Min</td>
				<td>MOR</td>
			</tr>
			<%
			List<InventoryMaster> listMat = InventoryMaster.reportMOR();
			for (InventoryMaster entity : listMat) {
			%>
			<tr>
				<td><%=entity.getMat_code()%></td>
				<td><%=entity.getDescription()%></td>
				<td align="right"><%=entity.getBalance()%></td>
				<td><%=entity.getStd_unit()%></td>
				<td><%=entity.getDes_unit()%></td>
				<td align="right"><%=entity.getMin()%></td>
				<td align="right"><%=entity.getMor()%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<% } %>
	
</body>
</html>