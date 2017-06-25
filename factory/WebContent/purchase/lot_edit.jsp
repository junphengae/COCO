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
%>
<script type="text/javascript">
	$(function(){
		$('#lot_expire').datepicker({
			showOtherMonths : true,
			slectOtherMonths : true,
			changeYear : true,
			changeMonth : true,
			yearRange: 'c-5:c+10'
		});
		
		var $msg = $('#vendor_msg_error');
		var $form = $('#lotEditForm');

		var v = $form.validate({
			submitHandler: function(){
				if (confirm('ยืนยันการแก้ไขข้อมูลสินค้า Lot NO. <%=lot_no%>!')) {
					ajax_load();
					$.post('InletManagement',$form.serialize(),function(resData){
						ajax_remove();
						if (resData.status == 'success') {
							window.location.reload();
						} else {
							alert(resData.message);
						}
					},'json');
				}
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
	});
</script>
<div>
	<div class="m_top15"></div>
	<form id="lotEditForm" action="" method="post" style="margin: 0;padding: 0;">
	<table width="100%" id="tb_input_invoice">
		<tbody>
			<tr>
				<td width="25%">เลขที่ใบสั่งซื้อ</td>
				<td width="75%">: 
					<input type="text" class="txt_box required" name="po" id="po" autocomplete="off" value="<%=lot.getPo()%>" title="ระบุเลขที่ใบสั่งซื้อ!">
				</td>
			</tr>
			<tr>
				<td width="25%">เลขที่ใบแจ้งหนี้</td>
				<td width="75%">: <input type="text" class="txt_box required" name="invoice" autocomplete="off" value="<%=lot.getInvoice()%>" title="ระบุเเลขที่ใบแจ้งหนี้!"></td>
			</tr>
			<tr>
				<td>จำนวน</td>
				<td>: <%=lot.getLot_qty()%> <%=master.getStd_unit()%></td>
			</tr>
			<tr><td colspan="2" height="20"></td></tr>
			<tr>
				<td valign="top">ราคาต่อหน่วย</td>
				<td valign="top">: 
					<input type="text" class="txt_box required" name="lot_price" id="lot_price" autocomplete="off" value="<%=lot.getLot_price()%>" title="ระบุเราคา!">
				</td>
			</tr>
			<tr><td colspan="2" height="20"></td></tr>
			<tr>
				<td>ตัวแทนจำหน่าย</td>
				<td>: 
					<bmp:ComboBox name="vendor_id" styleClass="txt_box s200" validate="true" validateTxt="เลือกตัวแทนจำหน่าย!" listData="<%=Vendor.selectList()%>" value="<%=lot.getVendor_id()%>">
						<bmp:option value="" text="--- select ---"></bmp:option>
					</bmp:ComboBox>
				</td>
			</tr>
			<tr>
				<td>รหัสสินค้าของตัวแทน</td>
				<td>: <input type="text" name="vendor_mat_code" class="txt_box" autocomplete="off" value="<%=lot.getVendor_mat_code()%>"></td>
			</tr>
			<tr>
				<td>เลขที่ Lot สินค้าของตัวแทน</td>
				<td>: <input type="text" name="vendor_lot_no" class="txt_box" autocomplete="off" value="<%=lot.getVendor_lot_no()%>"></td>
			</tr>
			<tr>
				<td>วันหมดอายุ</td>
				<td>: <input type="text" name="lot_expire" id="lot_expire" class="txt_box" autocomplete="off"  value="<%=WebUtils.getDateValue(lot.getLot_expire())%>"></td>
			</tr>
			<tr>
				<td>หมายเหตุ</td>
				<td>: <input type="text" class="txt_box" name="note" autocomplete="off" value="<%=lot.getNote()%>"></td>
			</tr>
			<tr>
				<td colspan="2" align="center" height="30">
					<input type="submit" name="add" class="btn_box" value="บันทึก">
					<input type="hidden" name="action" value="edit_lot">
					<input type="hidden" name="lot_no" value="<%=lot_no%>">
					<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error" id="vendor_msg_error"></div>
	</form>

</div>