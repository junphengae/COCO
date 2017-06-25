<%@page import="com.bitmap.bean.sale.PackageItem"%>
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
	<div class="m_top10"></div>
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
	
	
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td align="right" width="15%">ประเภท :</td>
				<td align="left">: สั่งผลิต</td>													
			</tr>
			<tr>
				<td align="right" width="15%">จำนวน :</td>
				<td align="left">
					<input type="text" class="txt_box required" autocomplete="off" title="ระบุจำนวน!" value="<%=WebUtils.getReqString(request, "item_qty")%>" name="item_qty" id="item_qty"> <%=(item_type.equalsIgnoreCase("PRO")?"":"KG")%>
				</td>													
			</tr>
			<tr>
				<td align="right">วันที่ผลิตจริง :</td>
				<td>
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
			
			$('#comfirm_add_form').submit(function(){
				var $findate = $('#fin_date');		
 				var findate = $findate.val().split('/');
 				
	 				if(findate=='')	{
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
									if(resData.check == true){
										if(resData.item_type == "PRO"){
											popup('report_item_pro.jsp?item_run=' + resData.item_run + '&item_id=' + resData.item_id + '&order_id=' + resData.order_id);			
											}else{
											popup('report_item.jsp?item_run=' + resData.item_run + '&item_id=' + resData.item_id + '&order_id=' + resData.order_id);
											}
											window.location.reload();
										}else{								
											window.location.reload();
										}
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
		<input type="hidden" name="item_id" id="item_id" value="<%=WebUtils.getReqString(request, "item_id")%>">
		<input type="hidden" name="item_run" id="item_run" value="<%=WebUtils.getReqString(request, "item_run")%>">
		<input type="hidden" name="item_type" id="item_type" value="<%=WebUtils.getReqString(request, "item_type")%>">
		
		<input id="save" type="submit" class="btn_box btn_confirm hide" value="บันทึก" >
		<input id="print" type="submit" class="btn_box hide" value="พิมพ์" >
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="add_product">	
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
			
	</div>
</form>