<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src="../js/number.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<%
String mat_code = WebUtils.getReqString(request, "mat_code");
InventoryMaster entity = InventoryMaster.select(mat_code);
%>
<script type="text/javascript">
var order_price = $('#order_price');
var order_qty = $('#order_qty');
var form = $('#create_order_form');

form.submit(function(){
	if (isNumber(order_price.val()) && (order_price.val()*1) > 0 && order_price.val() != '') {
		if (isNumber(order_qty.val()) && (order_qty.val()*1) > 0 && order_qty.val() != '') {
			if ($("input[name='vendor_id']:radio").is(':checked')){
				if (confirm('ยืนยันการขอจัดซื้อ !')) {
					ajax_load();
					$.post('PurchaseManage',form.serialize(),function(resData){
						ajax_remove();
						if (resData.status == 'success') {
							tb_remove();
						} else {
							alert(resData.message);
						}
					},'json');
				}
			} else {
				alert('กรุณาเลือกตัวแทนจำหน่าย!');
			}
		} else {
			alert('ระบุจำนวนที่ต้องการสั่ง!');
			order_qty.focus();
		}
	} else {
		alert('ระบุราคาที่ต้องการสั่ง!');
		order_price.focus();
	}
		
	return false;
});

order_qty.focus(function(){ var value = $(this).val(); if (!(/^\d+$/.test(value)) || value == '0') { $(this).val(''); }});

</script>
<form id="create_order_form" onsubmit="return false;">
	<fieldset class="fset s800 center m_top10">
		<legend>รายละเอียด</legend>
		<table cellpadding="3" cellspacing="3" border="0" class="s800 center">
			<tbody>
				<tr>
					<td width="20%"><label>สินค้า</label></td>
					<td>: 
						<%=entity.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + entity.getUISubCat().getUICat().getCat_name_short() + ((entity.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + entity.getUISubCat().getSub_cat_name_short():"")%>-<%=entity.getMat_code()%> 
						<%=entity.getDescription()%>
					</td>
				</tr>
				<tr valign="top">
					<td><label>ปริมาตร/บรรจุภัณฑ์</label></td>
					<td align="left">: <%=entity.getUnit_pack() + " " + entity.getStd_unit() + " / " + entity.getDes_unit()%></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td>ราคาต่อหน่วย</td>
					<td>
						: <input type="text" name="order_price" id="order_price" class="txt_box" autocomplete="off" value="<%=(entity.getCost().length() > 0)?entity.getCost():"0"%>">
						ต่อ <%=entity.getStd_unit()%> | หรือ 
						<input type="text" autocomplete="off" id="unit_price" class="txt_box" value="<%=(entity.getCost().length() > 0)?Money.multiple(entity.getCost(), entity.getUnit_pack()):"0"%>"> ต่อ <%=entity.getDes_unit()%>
						<script type="text/javascript">
						$(function(){
							var order_price = $('#order_price');
							var unit_price = $('#unit_price');
							unit_price.blur(function(){
								if (isNumber(unit_price.val())) {
									order_price.val(unit_price.val() / <%=entity.getUnit_pack()%>);
								} else {
									if(unit_price.val() == ''){
										unit_price.val('').focus();
									} else {
										alert('กรุณาระบุราคาต่อ <%=entity.getDes_unit()%> เป็นตัวเลข!');
										unit_price.val('').focus();
										order_price.val('0');
									}
								}
							});
							
							
							order_price.blur(function(){
								if (isNumber(order_price.val())) {
									unit_price.val(order_price.val() * <%=entity.getUnit_pack()%>);
								} else {
									if(order_price.val() == ''){
										order_price.val('').focus();
									} else {
										alert('กรุณาระบุราคาต่อ <%=entity.getStd_unit()%> เป็นตัวเลข!');
										order_price.val('').focus();
										unit_price.val('0');
									}
								}
							});
						});
						</script>
					</td>
				</tr>
				<tr>
					<td>จำนวนที่ต้องการสั่ง</td>
					<td>
						: <input type="text" autocomplete="off" name="order_qty" id="order_qty" class="txt_box required" title="ระบุจำนวนที่ต้องการสั่ง!" value="0">  
						<%=entity.getStd_unit()%> | 
						หรือ 
						<input type="text" autocomplete="off" id="qty_unit" class="txt_box" title="จำนวนที่ต้องการสั่งซื้อเป็น <%=entity.getDes_unit()%>" value=""> <%=entity.getDes_unit()%>
						<script type="text/javascript">
						$(function(){
							var order_qty = $('#order_qty');
							var qty_unit = $('#qty_unit');
							qty_unit.blur(function(){
								if (isNumber(qty_unit.val())) {
									order_qty.val(qty_unit.val() * <%=entity.getUnit_pack()%>);
								} else {
									if(qty_unit.val() == ''){
										qty_unit.val('').focus();
									} else {
										alert('กรุณาระบุจำนวนที่ต้องการสั่งซื้อเป็นตัวเลข!');
										qty_unit.val('').focus();
										order_qty.val('0');
									}
								}
							});
							
							order_qty.blur(function(){
								if (isNumber(order_qty.val())) {
									qty_unit.val(order_qty.val() / <%=entity.getUnit_pack()%>);
								} else {
									if(order_qty.val() == ''){
										order_qty.val('').focus();
									} else {
										alert('กรุณาระบุจำนวนที่ต้องการสั่งซื้อเป็นตัวเลข!');
										order_qty.val('').focus();
										qty_unit.val('0');
									}
								}
							});
						});
						</script>
					</td>
				</tr>
				<tr>
					<td>ราคารวม</td>
					<td>: <span id="sum_price" class="txt_red"></span> 
					<script type="text/javascript">
						$(function(){
							var order_price = $('#order_price');
							var order_qty = $('#order_qty');
							var qty_unit = $('#qty_unit');
							var unit_price = $('#unit_price');
							
							var sum_price = $('#sum_price');
							order_price.blur(function(){
								sumMoney();
							});
							
							order_qty.blur(function(){
								sumMoney();
							});
							
							qty_unit.blur(function(){
								sumMoney();
							});
							
							unit_price.blur(function(){
								sumMoney();
							});
							
							function sumMoney(){
								sum_price.text(order_price.val() * order_qty.val());		
								if(sum_price.text() > 1000000){
									alert('ราคาสินค้ามากกว่า 1,000,000 บาท!!');
								}
								sum_price.text(order_price.val() * order_qty.val() + ' บาท');
							}
						});
						</script>
					</td>
				
				</tr>
				
				<tr>
					<td>หมายเหตุ</td>
					<td>: <input type="text" class="txt_box s400" autocomplete="off" name="note"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</tbody>
		</table>
		
		<table class="bg-image s800" style="color: #fff;">
			<thead>
				<tr>
					<th valign="top" align="center" width="5%"></th>
					<th valign="top" align="center" width="25%">ชื่อตัวแทนจำหน่าย</th>
					<th valign="top" align="center" width="15%">จัดส่งขั้นต่ำ</th>
					<th valign="top" align="center" width="15%">เวลาจัดส่ง</th>
					<th valign="top" align="center" width="20%">เงื่อนไข</th>
					<th valign="top" align="center" width="20%">เครดิต</th>
				</tr>
			</thead>
			<tbody id="vendor_list">
			<%
				Iterator ite = InventoryMasterVendor.selectList(mat_code).iterator();
					while(ite.hasNext()) {
				InventoryMasterVendor masterVendor = (InventoryMasterVendor) ite.next();
				Vendor vendor = masterVendor.getUIVendor();
			%>
			<tr id="vendor_<%=vendor.getVendor_id()%>">
				<td><input type="radio" name="vendor_id" value="<%=vendor.getVendor_id()%>"></td>
				<td><%=vendor.getVendor_name()%></td>
				<td align="center"><%=masterVendor.getVendor_moq()%></td>
				<td align="center"><%=masterVendor.getVendor_delivery_time()%></td>
				<td><%=vendor.getVendor_condition()%></td>
				<td align="center"><%=vendor.getVendor_credit()%></td>
			</tr>
			<%
			}
			%>
			</tbody>
		</table>
		
		<table cellpadding="3" cellspacing="3" border="0" class="s600 center">
			<tbody>
				<tr align="center" valign="bottom" height="30">
					<td colspan="2">
						<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึกลงรายการขอจัดซื้อ">
						<input type="reset" name="reset" class="btn_box" value="ปิด" onclick="tb_remove();">
						<input type="hidden" name="action" value="create_pr">
						<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
						<input type="hidden" name="mat_code" value="<%=mat_code%>">
					</td>
				</tr>
			</tbody>
		</table>
	</fieldset>
	
	<fieldset class="fset s800 center m_top10">
		<legend>ข้อมูลสรุปย้อนหลัง 3 เดือน : <%=entity.getDescription()%></legend>
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
					<td align="right"><%=Money.money(InventoryLot.reportSUM4PR(entity.getMat_code()))%></td>
					<td align="right"><%=Money.money(InventoryLotControl.reportSUM4PR(entity.getMat_code()))%></td>
					<td align="right"><%=Money.money(entity.getBalance())%></td>
					<td align="right"><%=Money.money(PurchaseRequest.pr_opened_list_sum(entity.getMat_code()))%></td>
				</tr>
			</tbody>
		</table>
	</fieldset>
	
	<fieldset class="fset s800 center h250 m_top10">
		<legend>ราคาย้อนหลัง 3 เดือน</legend>
		<div class="scroll_box h200">
			
			<table class="bg-image s780" style="color: #fff;">
				<thead>
					<tr>
						<th valign="top" align="center" width="15%">Lot no.</th>
						<th valign="top" align="center" width="40%">ชื่อตัวแทนจำหน่าย</th>
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
						<td><%=vendor.getVendor_name()%></td>
						<td align="right"><%=Money.money(lot.getLot_qty())%></td>
						<td align="right"><%=lot.getLot_price()%></td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
			
		</div>
		
	</fieldset>
	
	
	<div class="m_top10"></div>
</form>