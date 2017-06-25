<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItemMat"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
String pro_id = WebUtils.getReqString(request,"pro_id");

Production pro = Production.select(pro_id);
SaleOrderItem item = SaleOrderItem.selectOrder(pro.getItem_run());

InventoryMaster mat = new InventoryMaster();
RDFormular formular = new RDFormular();
formular.setMat_code(pro.getItem_id());
RDFormular.select(formular);
String volume = "0";
mat = InventoryMaster.select(pro.getItem_id());

%>
<form id="comfirm_add_form" onsubmit="return false;">
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td align="right" width="20%">ชื่อสินค้า</td>
				<td align="left">:
					<%=mat.getDescription()%>
				</td>													
			</tr>
			<tr>
				<td align="right" width="20%">เลือก </td>
				<td align="left">:
					<input type="radio" name="status" id="status1" value="10"  class="pointer"> สั่งผลิต
					<input type="radio" name="status" id="status2" value="20" class="pointer" checked="checked"> ไม่ผลิต
				</td>													
			</tr>
			<tr>
				<td align="right" width="20%">จำนวน</td>
				<td align="left">:
					<input type="text" class="txt_box required" autocomplete="off" title="ระบุจำนวน!" name="item_qty" id="item_qty"> KG.
				</td>													
			</tr>
			<%if(mat.getGroup_id().equalsIgnoreCase("FG")){ %>
			<tr>
				<td align="right" width="20%">จำนวนบรรจุภัณฑ์ </td>
				<td align="left">:
					<input type="text" class="txt_box required" autocomplete="off" title="ระบุจำนวนบรรจุภัณฑ์!" name="take" id="take"> <%=mat.getDes_unit()%>
				</td>													
			</tr>
			<%} %>
			<tr id="date" class="hide">
				<td align="right">วันที่ผลิตจริง </td>
				<td align="left">:
					<input type="text" name="fin_date" id="fin_date" class="txt_box" autocomplete="off">
				</td>
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
		$(function(){
			var status = true;
			
			$('#status1').click(function(){
				$('#date').fadeIn('slow');
				status = true;
			});
			
			$('#status2').click(function(){
				$('#date').fadeOut('slow');
				status = false;
			});
			
			$('#fin_date').datepicker({
				showOtherMonths : true,
				slectOtherMonths : true,
				changeMonth : true
			});
			
			$('#comfirm_add_form').submit(function(){
				
				if (status==true){
				var $findate = $('#fin_date');		
 				var findate = $findate.val().split('/');
 				
 					if($('item_qty').val() == ''){
 					 	alert('กรุณาระบุจำนวนให้ถูกต้อง');	
 					 	$('item_qty').focus();
 					}else if(findate=='')	{
	 					alert('กรุณากำหนดวันที่ผลิตจริง!');
	 					$findate.focus();
	 				} else{
 					var dd = new Date(findate[2],findate[1]-1,findate[0]);
 					var today = new Date();
 					today = new Date(today.getFullYear(),today.getMonth(),today.getDate());
 						if (dd < today){
 							alert('กำหนดวันที่ผลิตจริง น้อยกว่า วันปัจจุบัน!');
 							$findate.focus();
 						} else {
							ajax_load();
							$.post('../sale/SaleManage',$(this).serialize(),function(resData){
								ajax_remove();							
								if (resData.status == 'success') {							
									window.location.reload();	
								} else {
									alert(resData.message);
								}
							},'json');
	 					}
	 				}
				} else {
					if($('item_qty').val() == ''){
 					 	alert('กรุณาระบุจำนวนให้ถูกต้อง');	
 					 	$('item_qty').focus();
 					}else{
						ajax_load();
						$.post('../sale/SaleManage',$(this).serialize(),function(resData){
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
		});
	
	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="pro_id" id="pro_id" value="<%=pro_id%>">
		<input type="hidden" name="item_id" id="item_id" value="<%=pro.getItem_id()%>">
		<input id="save" type="submit" class="btn_box btn_confirm" value="บันทึก" >
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">	
		<input type="hidden" name="action" value="change_pd">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
			
	</div>
</form>