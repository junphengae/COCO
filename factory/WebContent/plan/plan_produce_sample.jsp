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
	if(item_type.equalsIgnoreCase("SS")){
		volume = item_qty;
	}else{
		volume = Money.multiple((formular.getVolume().length() > 0)?formular.getVolume():"0",item.getItem_qty());
	}	
	
	if(item_type.equalsIgnoreCase("FG") && status.equalsIgnoreCase("1")){
		volume = Money.multiple((formular.getVolume().length() > 0)?formular.getVolume():"0",item_qty);
	}
%>
<form id="comfirm_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<div class="left s80 m_left40">ชื่อสินค้า </div><div class="left s200">: <%=mat.getDescription()%></div>
	<div class="clear"></div>
	<div class="left s80 m_left40">สินค้าที่ต้องผลิต </div><div class="left s200">: <%=Money.money(volume) + " " + mat.getStd_unit()%></div>
	<div class="clear"></div>

	<div class="left s80 m_left40">R&D Yield </div><div class="left s200">: <%=Money.money(Money.divide(Money.multiple(volume,"100"),(formular.getYield().equalsIgnoreCase("0")?"100":formular.getYield()))) + " " + mat.getStd_unit()%></div>
	<div class="clear"></div>

	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td align="right" width="15%">เลือก :</td>
				<td align="left">
					<input type="radio" name="status" id="status1" value="10" checked="checked"  class="pointer"> สั่งผลิต
					<input type="radio" name="status" id="status2" value="20" class="pointer"> ไม่ผลิต
				</td>													
			</tr>
			<tr>
				<td align="right" width="15%">จำนวน :</td>
				<td align="left">
					<input type="text" class="txt_box required" autocomplete="off" title="ระบุจำนวน!" value="<%=Money.money(Money.divide(Money.multiple(volume,"100"),(formular.getYield().equalsIgnoreCase("0")?"100":formular.getYield())))%>" name="item_qty" id="item_qty"> KG.
					<input type="hidden" class="txt_box" value="<%=Money.money(Money.divide(Money.multiple(volume,"100"),(formular.getYield().equalsIgnoreCase("0")?"100":formular.getYield())))%>" name="item_qty2" id="item_qty2">
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
			
			$('#comfirm_add_form').submit(function(){
				ajax_load();
				$.post('../sale/SaleManage',$(this).serialize(),function(resData){
					ajax_remove();							
					if (resData.status == 'success') {
							window.location.reload();
					} else {
						alert(resData.message);
					}
				},'json');
	 		});
		});
	</script>
	<div class="txt_center m_top20">
		<input type="hidden" name="item_id" id="item_id" value="<%=WebUtils.getReqString(request, "item_id")%>">
		<input type="hidden" name="item_run" id="item_run" value="<%=WebUtils.getReqString(request, "item_run")%>">
		<input type="hidden" name="item_type" id="item_type" value="<%=WebUtils.getReqString(request, "item_type")%>">
		<input type="hidden" name="parent_id" id="parent_id" value="<%=WebUtils.getReqString(request, "parent_id")%>">
		
		<input id="save" type="submit" class="btn_box btn_confirm" value="บันทึก" >
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="add_product_sample">	
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
			
	</div>
</form>