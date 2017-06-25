<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.rd.MatTree"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
SaleOrderItem entity = new SaleOrderItem();
WebUtils.bindReqToEntity(entity, request);

SaleOrderItem.select(entity);
%>

<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<form id="comfirm_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td align="right">วันที่ร้องขอ :</td>
				<td>
					<input type="text" name="due_date" id="due_date" class="txt_box" autocomplete="off">
				</td>
			</tr>
			<tr>
				<td align="right" width="20%">สถานะ :</td>
				<td align="left">
					<input type="radio" name="status" value="50" checked="checked"> อนุมัติให้เริ่มผลิต
					<input type="radio" name="status" value="60"> อนุมัติแต่ยังไม่ผลิต
				</td>												
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
		$(function(){
			$('#due_date').datepicker({
				showOtherMonths : true,
				slectOtherMonths : true,
				changeMonth : true
			});
			
			$('#comfirm_add_form').submit(function(){
				var $duedate = $('#due_date');		
				var duedate = $duedate.val().split('/');
				if(duedate=='')	{
					alert('กรุณากำหนดวันส่งของ!');
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
							$.post('SaleManage',$(this).serialize(),function(resData){
								ajax_remove();
								if (resData.status == 'success') {
										window.location.reload();							
								} else {
									if (resData.message.indexOf('Duplicate entry') == -1) {
										alert(resData.message);
									}
								}
							},'json');
						}
				}
			});
		});	
	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="order_id" id="order_id" value="<%=WebUtils.getReqString(request, "order_id")%>">
		<input type="hidden" name="item_run" id="item_run" value="<%=WebUtils.getReqString(request, "item_run")%>">
		<input type="hidden" name="item_id" id="item_id" value="<%=entity.getItem_id()%>">
		<input type="hidden" name="qt_id" id="qt_id" value="<%=WebUtils.getReqString(request, "qt_id")%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึก">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="approve_qt">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
			
	</div>
</form>