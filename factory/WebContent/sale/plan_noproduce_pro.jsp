<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="com.bitmap.bean.rd.RDFormularDetail"%>
<%@page import="com.bitmap.bean.rd.RDFormularStep"%>
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
String item_id = WebUtils.getReqString(request,"item_id");
String pk_id = WebUtils.getReqString(request,"pk_id");
String item_type = WebUtils.getReqString(request,"item_type");

Package pac  = new Package();		
RDFormular formular = new RDFormular();
formular.setMat_code(item_id);
RDFormular.select(formular);
pac = Package.select(item_id);

List list = PackageItem.getOnePac(pk_id, item_id);
Iterator ite = list.iterator();


%>
<form id="comfirm_add_form" onsubmit="return false;">
	<%
	while (ite.hasNext()){
		PackageItem item = (PackageItem) ite.next();
		InventoryMaster mat = item.getUIMat();	
	%>
	<div class="left s80 m_left40">ชื่อสินค้า </div><div class="left s200">: <%=mat.getDescription()%></div>
	<div class="clear"></div>
	<div class="left s80 m_left40">สินค้าที่ต้องผลิต </div><div class="left s200">: <%=Money.multiple(formular.getVolume(),item.getUISumQty()) + " " + mat.getStd_unit()%></div>
	<div class="clear"></div>
	<div class="left s80 m_left40">R&D Yield </div><div class="left s200">: <%=Money.money(Money.divide(Money.multiple(Money.multiple(formular.getVolume(),item.getUISumQty()),"100"),formular.getYield())) + " " + mat.getStd_unit()%></div>
	<div class="clear"></div>
	
	<%}
	if(item_type.equalsIgnoreCase("PRO")){
		%>
		<div class="left s80 m_left40">ชื่อสินค้า </div><div class="left s220">: <%=pac.getName()%></div>
		<div class="clear"></div>
		<div class="left s80 m_left40">สินค้าที่ต้องผลิต </div><div class="left s200">: <%=pac.getPk_qty()%> ชุด</div>
		<div class="clear"></div>
	<%	
	}
	%>
<script type="text/javascript">
	$(function(){
		var form = $('#comfirm_add_form');	
		var v = form.validate({
 			submitHandler: function(){	
 				ajax_load();
				$.post('../sale/SaleManage',$(this).serialize(),function(resData){
					ajax_remove();							
					if (resData.status == 'success') {		
						popup('report_item_pro.jsp?item_run=' + resData.item_run + '&item_id=' + resData.item_id + '&order_id=' + resData.order_id + '&pro_id=' + resData.pro_id);			
						window.location.reload();
					} else {
						alert(resData.message);
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
		<input type="hidden" name="item_id" id="item_id" value="<%=item_id%>">
		<%-- <input type="hidden" name="item_run" id="item_run" value="<%=item_run%>">
		<input type="hidden" name="item_qty" id="item_qty" value="<%=item.getItem_qty()%>"> --%>
		<input type="hidden" name="item_type" id="item_type" value="FG">
		
		
		<input type="hidden" name="status" id="status" value="<%=Production.STATUS_NO_PRODUCE%>">
		<%-- <input type="hidden" name="order_type" id="order_type" value="<%=order.getOrder_type()%>"> --%>
		<input id="save" type="submit" class="btn_box btn_confirm" value="บันทึก" >
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">	
		<input type="hidden" name="action" value="not_produce">	
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
			
	</div>
</form>