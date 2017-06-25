<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการขอจัดซื้อ</title>
<%
InventoryMaster entity = new InventoryMaster();
WebUtils.bindReqToEntity(entity, request);
InventoryMaster.select(entity);
%>
</head>
<body>

	<fieldset class="fset s_auto center m_top10">
		<legend>ข้อมูลสรุปย้อนหลัง 3 เดือน</legend>
		<table cellpadding="3" cellspacing="3" border="0" class="s_auto center">
			<tbody>
				<tr>
					<td width="25%"><label>สินค้า</label></td>
					<td>: 
						<%=entity.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + entity.getUISubCat().getUICat().getCat_name_short() + ((entity.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + entity.getUISubCat().getSub_cat_name_short():"")%>-<%=entity.getMat_code()%> 
						<%=entity.getDescription()%>
					</td>
				</tr>
				<tr valign="top">
					<td><label>ปริมาตร/บรรจุภัณฑ์</label></td>
					<td align="left">: <%=entity.getUnit_pack() + " " + entity.getStd_unit() + " / " + entity.getDes_unit()%></td>
				</tr>
			</tbody>
		</table>
		
		<table class="bg-image s_auto">
			<thead>
				<tr>
					<th valign="top" align="center" width="25%">ยอดนำเข้า</th>
					<th valign="top" align="center" width="25%">ยอดเบิกออก</th>
					<th valign="top" align="center" width="25%">คงคลัง</th>
					<th valign="top" align="center" width="25%">ยอดที่กำลังสั่งซื้อ</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td align="right">
						<%String in = InventoryLot.reportSUM4PR(entity.getMat_code()); %>
						<%=Money.money(in)%> <%=entity.getStd_unit()%> 
						(<%=Money.divide(in, entity.getUnit_pack())%> <%=entity.getDes_unit()%>)
					</td>
					<td align="right">
						<%String out_ = InventoryLotControl.reportSUM4PR(entity.getMat_code());%>
						<%=Money.money(out_)%> <%=entity.getStd_unit()%> 
						(<%=Money.divide(out_, entity.getUnit_pack())%> <%=entity.getDes_unit()%>)
					</td>
					<td align="right">
						<%=Money.money(entity.getBalance())%> <%=entity.getStd_unit()%> 
						(<%=Money.divide(entity.getBalance(), entity.getUnit_pack())%> <%=entity.getDes_unit()%>)
					</td>
					<td align="right">
						<%String prSum = PurchaseRequest.pr_opened_list_sum(entity.getMat_code());%>
						<%=Money.money(prSum)%> <%=entity.getStd_unit()%> 
						(<%=Money.divide(prSum, entity.getUnit_pack())%> <%=entity.getDes_unit()%>)
					</td>
				</tr>
			</tbody>
		</table>
	</fieldset>

	<fieldset class="fset s_auto center h250 m_top10">
		<legend>ราคาย้อนหลัง 3 เดือน</legend>
		<div class="scroll_box h200">
			
			<table class="bg-image s800" style="color: #fff;">
				<thead>
					<tr>
						<th valign="top" align="center" width="12%">Lot no.</th>
						<th valign="top" align="center" width="18%">วันที่นำเข้า</th>
						<th valign="top" align="center" width="25%">ตัวแทนจำหน่าย</th>
						<th valign="top" align="center" width="25%">จำนวนที่สั่ง</th>
						<th valign="top" align="center" width="20%">ราคาต่อหน่วย</th>
					</tr>
				</thead>
				<tbody id="inlet_list">
					<%
					Iterator iteLot = InventoryLot.report4PR(entity.getMat_code()).iterator();
					while(iteLot.hasNext()){
						InventoryLot lot = (InventoryLot) iteLot.next();
						Vendor vendor = lot.getUIVendor();
					%>
					<tr>
						<td align="right"><%=lot.getLot_no()%></td>
						<td align="center"><%=WebUtils.getDateValue(lot.getCreate_date())%></td>
						<td><%=vendor.getVendor_name()%></td>
						<td align="right"><%=Money.money(lot.getLot_qty())%> <%=entity.getStd_unit()%> (<%=Money.divide(lot.getLot_qty(), entity.getUnit_pack())%> <%=entity.getDes_unit()%>)</td>
						<td align="right"><%=lot.getLot_price()%></td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
			
		</div>
		
	</fieldset>

</body>
</html>