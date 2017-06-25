<%@page import="com.bitmap.bean.rd.RDFormularDetail"%>
<%@page import="com.bitmap.bean.rd.RDFormularStep"%>
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
SaleOrderItem item = new SaleOrderItem();
WebUtils.bindReqToEntity(item, request);

item = SaleOrderItem.selectOrder(item.getItem_run());
SaleOrder order = new SaleOrder();
order = SaleOrder.selectByID(item.getOrder_id());

String item_run = WebUtils.getReqString(request,"item_run");
String item_id = WebUtils.getReqString(request,"item_id");
String item_qty = WebUtils.getReqString(request,"item_qty");
String item_type = WebUtils.getReqString(request,"item_type");
String status = WebUtils.getReqString(request,"status");

Package pac  = new Package();		
InventoryMaster mat = new InventoryMaster();

RDFormular formular = new RDFormular();
formular.setMat_code(item_id);
RDFormular.select(formular);
String volume = "0";
mat = InventoryMaster.select(item_id);

volume = item_qty;

%>
<form id="comfirm_add_form" onsubmit="return false;">
	<input type="hidden" name="item_real" id="item_real" class="txt_box" value="<%=Money.money(volume)%>">
	<table width="100%" class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td align="right">ชื่อสินค้า</td>
				<td align="left">:<%=mat.getDescription()%></td>													
			</tr>
			<tr>
				<td align="right">สินค้าที่ต้องผลิต</td>
				<td align="left">:<%=Money.money(volume) + " " + mat.getStd_unit()%></td>													
			</tr>
			<tr>
				<td align="right">R&D Yield</td>
				<td align="left">:<%=Money.money(Money.divide(Money.multiple(volume,"100"),((formular.getYield().equalsIgnoreCase("0") || formular.getYield().length() == 0)?"100":formular.getYield()))) + " " + mat.getStd_unit()%></td>													
			</tr>
			<tr>
				<td align="right">ประเภท </td>
				<td align="left">:  สั่งผลิต
				</td>													
			</tr>
			<tr>
				<td align="right">จำนวน</td>
				<td align="left">:
					<input type="text" class="txt_box required" autocomplete="off" title="ระบุจำนวน!" value="<%=Money.money(Money.divide(Money.multiple(volume,"100"),((formular.getYield().equalsIgnoreCase("0") || formular.getYield().length() == 0)?"100":formular.getYield())))%>" name="item_qty" id="item_qty"> KG.
				</td>													
			</tr>
			<%
			if(mat.getGroup_id().equalsIgnoreCase("FG")){ 
				String a = RDFormularStep.selectStepPK(item_id);
				List list = RDFormularDetail.selectList(item_id, a);
				Iterator ite = list.iterator();
				int i = 1;
				while(ite.hasNext()){
					RDFormularDetail entity = (RDFormularDetail) ite.next();
			%>
			<tr>
				<td align="right" width="50%">จำนวนบรรจุภัณฑ์(<%=entity.getUIMat().getDescription()%>) </td>
				<td align="left">:
					<input type="hidden" class="txt_box" name="item_id_pk" value="<%=entity.getUIMat().getMat_code()%>">
					<input type="text" class="txt_box required" autocomplete="off" title="ระบุจำนวนบรรจุภัณฑ์!" name="take<%=i%>" id="take<%=i%>"> ใบ
				</td>													
			</tr>
			<%	
				i++;
				} 
			}
			%>
			<tr>
				<td align="right">วันที่ผลิตจริง :</td>
				<td align="left">
					<input type="text" name="fin_date" id="fin_date" class="txt_box" autocomplete="off">
				</td>
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
		$(function(){
			$('#fin_date').datepicker({
				showOtherMonths : true,
				slectOtherMonths : true,
				changeMonth : true
			});
			
			var form = $('#comfirm_add_form');	
			var v = form.validate({
	 			submitHandler: function(){	
	 					var $findate = $('#fin_date');		
	 	 				var findate = $findate.val().split('/');
	 	 				var val = $('item_qty').val() * 2;
 	 					if($('item_qty').val() > val){
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
 								$.post('../sale/SaleManage',form.serialize(),function(resData){
 									ajax_remove();							
 									if (resData.status == 'success') {							
 											if(resData.item_type == "PRO"){
 												popup('report_item_pro.jsp?item_run=' + resData.item_run + '&item_id=' + resData.item_id + '&order_id=' + resData.order_id + '&pro_id=' + resData.pro_id);			
 											}else{
 												popup('report_item.jsp?item_run=' + resData.item_run + '&item_id=' + resData.item_id + '&order_id=' + resData.order_id + '&pro_id=' + resData.pro_id +'&type=' + resData.type);
 											}
 											window.location.reload();
 									} else {
 										alert(resData.message);
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
		<input type="hidden" name="item_id" id="item_id" value="<%=WebUtils.getReqString(request, "item_id")%>">
		<input type="hidden" name="item_run" id="item_run" value="<%=WebUtils.getReqString(request, "item_run")%>">
		<input type="hidden" name="item_type" id="item_type" value="<%=WebUtils.getReqString(request, "item_type")%>">
		<input type="hidden" name="parent_id" id="parent_id" value="<%=WebUtils.getReqString(request, "parent_id")%>">
		<input type="hidden" name="status" value="10">
		
		<input type="hidden" name="order_type" id="order_type" value="<%=order.getOrder_type()%>">
		<input id="save" type="submit" class="btn_box btn_confirm" value="บันทึก" >
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">	
		
		<% if(item_type.equalsIgnoreCase("SS") && order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_BUFFER)) {
		%>
		<input type="hidden" name="action" value="add_product_buffer">
		<%}else if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_GHOST) || order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_SGI)){ %>			
		<input type="hidden" name="action" value="add_product_ghost_sgi">	
		<%}else{ %>
		<input type="hidden" name="action" value="add_product">	
		<%} %>
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
			
	</div>
</form>