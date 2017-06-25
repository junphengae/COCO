<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<script src="../js/number.js" type="text/javascript"></script>
<script type="text/javascript" src="../js/popup.js"></script>

<%
//InventoryMaster mat = new InventoryMaster();
//InventoryMaster.select()
%>
<form id="material_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td width="30%" align="right">เลือกสินค้าจำหน่าย :</td>
				<td width="70%" align="left">
					<input type="text" class="txt_box required" readonly="readonly" name="item_id" id="request_by_autocomplete" title="ระบุวัตถุดิบ!">											
					<button id="btn_open_search" class="btn_box">ค้นหาสินค้าจำหน่าย</button>
				</td>
			</tr>
			<tr>
				<td align="right">ชื่อสินค้าจำหน่าย:</td>
				<td align="left"><span id="mat_name"></span></td>
			</tr>
			<tr>
				<td align="right">ราคา :</td>
				<td align="left">
					<input type="text" class="txt_box required" autocomplete="off" id="unit_price" name="unit_price" title="ระบุราคาต่อหน่วย!">
					*ราคากลาง  (<span id="item_qty2"></span>)
				</td>												
			</tr>
			<tr>
				<td align="right">จำนวนที่มีการจอง :</td>
				<td align="left">
				</td>												
			</tr>
			<tr>
				<td align="right">จำนวน :</td>
				<td align="left">
					<input type="text" class="txt_box required digits" autocomplete="off" id="item_qty" name="item_qty" title="ระบุจำนวน!"><%="  "%><span id="data_unit"></span>
					
				</td>												
			</tr>
			<tr>
				<td align="right">วันที่ร้องขอ :</td>
				<td>
					<input type="text" name="request_date" id="request_date" class="txt_box" autocomplete="off">
				</td>
			</tr>
			<tr>
				<td align="right">หมายเหตุ :</td>
				<td align="left">
					<input type="text" class="txt_box" autocomplete="off" id="remark" name="remark">
				</td>												
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$('#btn_open_search').click(function(){
		popup('fg_search.jsp');
	});
	
	$('#request_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
	
	$(function(){
			var form = $('#material_add_form');		
			var v = form.validate({
	 			submitHandler: function(){	
					var $duedate = $('#request_date');		
	 				var duedate = $duedate.val().split('/');
		 				if(duedate=='')	{
		 					alert('กรุณากำหนดวันที่ร้องขอ!');
		 					$duedate.focus();
		 				} else{
	 					var dd = new Date(duedate[2],duedate[1]-1,duedate[0]);
	 					var today = new Date();
	 					today = new Date(today.getFullYear(),today.getMonth(),today.getDate());
	 						if (dd < today){
	 							alert('กำหนดส่งของ น้อยกว่า วันปัจจุบัน!');
	 							$duedate.focus();
	 						} else {
								ajax_load();
								$.post('SaleManage',form.serialize(),function(resData){			
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
	 				} 	 		
	 			}
		});
			form.submit(function(){
	 			v;
	 			return false;
	 		});	
	});
	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="order_id" value="<%=WebUtils.getReqString(request, "order_id")%>">
		<input type="hidden" name="discount" value="<%=WebUtils.getReqString(request, "dis")%>">
		<input type="hidden" name="item_type" value="s">
		<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึก">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="create_production">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>