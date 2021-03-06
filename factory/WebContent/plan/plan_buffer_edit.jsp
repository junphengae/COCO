<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/popup.js" type="text/javascript"></script>
<script src="../js/number.js" type="text/javascript"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<%
SaleOrderItem entity = new SaleOrderItem();
WebUtils.bindReqToEntity(entity, request);

SaleOrderItem.select(entity);

InventoryMaster mat = entity.getUIMat();

%>
<form id="material_edit_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_edit" border="0" >
		<tbody>
			<tr>
				<td width="30%" align="right">รหัสสินค้าจำหน่าย :</td>
				<td width="70%" align="left"><%=entity.getItem_id()%></td>
			</tr>
			<tr>
				<td align="right">ชื่อสินค้าจำหน่าย:</td>
				<td align="left"><span id="mat_name"><%=mat.getDescription()%></span></td>
			</tr>
			<tr>
				<td align="right">จำนวน :</td>
				<td align="left">
					<input type="text"  value="<%=entity.getItem_qty()%>" class="txt_box required digits" autocomplete="off" id="item_qty" name="item_qty" title="ระบุจำนวน!">
				</td>												
			</tr>
			<tr>
				<td align="right">หมายเหตุ :</td>
				<td align="left">
					<input type="text"  value="<%=entity.getRemark()%>" class="txt_box" autocomplete="off" id="remark" name="remark">
				</td>												
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$(function(){
			var form = $('#material_edit_form');		
			var v = form.validate({
	 			submitHandler: function(){	
								ajax_load();
								$.post('../sale/SaleManage',form.serialize(),function(resData){			
									ajax_remove();
									if (resData.status == 'success') {
										window.location.reload();
									} else {
										if (resData.message.indexOf('Duplicate entry') > 0) {
											alert('คุณเลือกรายการสินค้าซ้ำ กรุณาเลือกใหม่อีกครั้ง!');
											$('#request_by_autocomplete').val('');
										} else {
											alert(resData.status);
										}
									}
								},'json'); 				
	 						}
			});
			form.submit(function(){
	 			v;
	 			return false;
	 		});	
	});
	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="order_id" value="<%=entity.getOrder_id()%>">
		<input type="hidden" name="item_type" value="s">
		<input type="hidden" name="item_run" value="<%=entity.getItem_run()%>">
		<input type="hidden" name="item_id" value="<%=entity.getItem_id()%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึก">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="sale_fg_update">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>