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
String item_run = WebUtils.getReqString(request,"item_run");
String item_id = WebUtils.getReqString(request,"item_id");
String item_qty = WebUtils.getReqString(request,"item_qty");
String parent_id = WebUtils.getReqString(request,"parent_id");

SaleOrderItem item = new SaleOrderItem();
item.setItem_run(item_run);
item = SaleOrderItem.selectOrder(item.getItem_run());
SaleOrder order = new SaleOrder();
order = SaleOrder.selectByID(item.getOrder_id());

InventoryMaster mat = new InventoryMaster();
RDFormular formular = new RDFormular();
formular.setMat_code(item_id);
RDFormular.select(formular);
mat = InventoryMaster.select(item_id);


%>
<form id="comfirm_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<div class="left s80 m_left40">ชื่อสินค้า </div><div class="left s200">: <%=mat.getDescription()%></div>
	<div class="clear"></div>
	<div class="left s80 m_left40">สินค้าที่ต้องการ </div><div class="left s200">: <%=Money.money(item_qty) + " KG"%></div>
	<div class="clear"></div>
	
	<script type="text/javascript">
		$(function(){
			
			$('#comfirm_add_form').submit(function(){
					ajax_load();
					$.post('../sale/SaleManage',$(this).serialize(),function(resData){
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
			});
		});
	
	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="item_id" id="item_id" value="<%=item_id%>">
		<input type="hidden" name="item_run" id="item_run" value="<%=item_run%>">
		<input type="hidden" name="item_type" id="item_type" value="SS">
		<input type="hidden" name="item_qty" id="item_qty" value="<%=item_qty%>">
		<input type="hidden" name="parent_id" id="parent_id" value="<%=parent_id%>">
		
		<input type="hidden" name="status" id="status" value="<%=Production.STATUS_NO_PRODUCE%>">
		<input type="hidden" name="order_type" id="order_type" value="<%=order.getOrder_type()%>">
		<input id="save" type="submit" class="btn_box btn_confirm" value="บันทึก" >
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">	
		<input type="hidden" name="action" value="add_product">	
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
			
	</div>
</form>