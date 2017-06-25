<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<%
String lot_no = WebUtils.getReqString(request, "lot_no");
InventoryLot lot = InventoryLot.select(lot_no);

String mat_code = lot.getMat_code();
InventoryMaster master = lot.getUIMat();

Vendor vendor = Vendor.select(lot.getVendor_id());
%>

<div>
	<div class="m_top15"></div>
	<table width="100%" id="tb_input_invoice">
		<tbody>
			<tr>
				<td width="25%">เลขที่ใบสั่งซื้อ</td>
				<td width="75%">: 
					<%=lot.getPo()%>
				</td>
			</tr>
			<tr>
				<td width="25%">เลขที่ใบแจ้งหนี้</td>
				<td width="75%">: <%=lot.getInvoice()%></td>
			</tr>
			<tr>
				<td>จำนวน</td>
				<td>: <%=lot.getLot_qty()%> <%=master.getStd_unit()%></td>
			</tr>
			<tr><td colspan="2" height="20"></td></tr>
			<tr>
				<td valign="top">ราคาต่อหน่วย</td>
				<td valign="top">: 
					<%=lot.getLot_price()%>
				</td>
			</tr>
			<tr><td colspan="2" height="20"></td></tr>
			<tr>
				<td>ตัวแทนจำหน่าย</td>
				<td>: <%=vendor.getVendor_name() %>
				</td>
			</tr>
			<tr>
				<td>รหัสสินค้าของตัวแทน</td>
				<td>: <%=lot.getVendor_mat_code()%></td>
			</tr>
			<tr>
				<td>เลขที่ Lot สินค้าของตัวแทน</td>
				<td>: <%=lot.getVendor_lot_no()%></td>
			</tr>
			<tr>
				<td colspan="2" height="20"></td>
			</tr>
			<tr>
				<td>วันที่รับเข้า</td>
				<td>: <%=WebUtils.getDateValue(lot.getCreate_date())%></td>
			</tr>
			<tr>
				<td>วันหมดอายุ</td>
				<td>: <%=WebUtils.getDateValue(lot.getLot_expire())%></td>
			</tr>
			<tr>
				<td>หมายเหตุ</td>
				<td>: <%=lot.getNote()%></td>
			</tr>
			<tr>
				<td colspan="2" align="center" height="30">
					<input type="button" name="add" class="btn_box" value="ปิด" onclick="tb_remove();">
				</td>
			</tr>
		</tbody>
	</table>

</div>