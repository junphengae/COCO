<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/table.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/popup.js" type="text/javascript"></script>
<script src="../js/number.js" type="text/javascript"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการ Buffer</title>
<%
String order_id = WebUtils.getReqString(request, "order_id");
SaleOrder order = SaleOrder.selectByID(order_id);


%>

<script type="text/javascript">
$(function(){
	
	$('#btn_save_order').click(function(){
		$('#sale_order_info').submit();
	});
	
	$('.btn_del_item').click(function(){
		if (confirm('ยืนยันการลบ!')) {
			var data = {
						'action':'sale_orderitem_del',
						'order_id':$(this).attr('order_id'),
						'item_id':$(this).attr('item_id'),
						'item_run':$(this).attr('item_run'),
						'item_type':$(this).attr('item_type'),
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>'
					   };
			
			ajax_load();
			$.post('../sale/SaleManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	
	$('#btn_click_send').click(function(){
		if (confirm('ยืนยันการส่ง!')) {
			var data = {
						'action':'update_order_status',
						'order_id':$('#order_id').val(),
						'order_type':$('#order_type').val(),
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>'
					   };
			
			ajax_load();
			$.post('../sale/SaleManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location = "plan_buffer.jsp";
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	
	$('#sale_order_info').submit(function(){
					ajax_load();
					$.post('../sale/SaleManage',$(this).serialize(),function(resData){
						ajax_remove();
						if (resData.status == 'success') {
							window.location='plan_order_buffer.jsp?order_id=' + resData.order_id;
						} else {
							alert(resData.message);
						}
					},'json');	
				});
	});
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการ Buffer | 1. สร้างรายการ Buffer </div>
				<div class="right btn_box m_right15" onclick='history.back();'>ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="sale_order_info" onsubmit="return false;">
					<table width="100%" cellpadding="2" cellspacing="2">
						<tbody>
							<tr>
								<td width="130">ประเภท</td>
								<td width="370">: Buffer</td>
								<td width="130">*หมายเหตุ</td>
								<td>: <input type="text" name="remark" id="remark" class="txt_box s200" autocomplete="off" value=<%=order.getRemark()%>></td>
							</tr>
							<tr><td colspan="4" height="15"></td></tr>
							<tr>
								<td colspan="4" align="center">
									<button class="btn_box btn_confirm" id="btn_save_order" type="button">บันทึก</button>
								<%
								if(order_id.length() > 0){
								%><button class="btn_box btn_warn">ยกเลิก</button>
								<%}%>
				
								</td>
							</tr>
						</tbody>
					</table>
					<input type="hidden" name="order_id" id="order_id" value="<%=order.getOrder_id()%>">
					<input type="hidden" name="order_type" id="order_type" value="<%=SaleOrder.TYPE_BUFFER%>">
					<input type="hidden" name="cus_id" id="cus_id" value="1090">
					<input type="hidden" name="action" value="<%=(order.getOrder_id().length()>0)?"update_info":"gen_order_id"%>">
					<input type="hidden" name="<%=(order.getOrder_id().length()>0)?"update_by":"create_by"%>" value="<%=securProfile.getPersonal().getPer_id()%>">
				</form>
				
				<%if (order.getOrder_type().length() > 0) {%>
				<div class="dot_line m_top10"></div>
				
				<fieldset class="fset ">
						<legend>รายการสินค้า</legend>
						<div class="right">
							<button class="btn_box btn_confirm thickbox" title="เพิ่มสินค้าปกติ" lang="plan_buffer_add.jsp?order_id=<%=order.getOrder_id()%>&width=500&height=200">เพิ่มสินค้าปกติ</button>
						</div>
						<div class="clear"></div>

						<table class="bg-image s900">
							<thead>
								<tr>
									<th valign="top" align="center" width="10%">ประเภทสินค้า</th>
									<th valign="top" align="center" width="30%">รายการสินค้า</th>
									<th valign="top" align="center" width="5%">จำนวน</th>
									<th valign="top" align="center" width="5%">หน่วย</th>
									<th valign="top" align="center" width="12%"></th>
								</tr>
							</thead>
								
							<tbody>
								<%
								boolean check = false;
								Iterator ite = SaleOrderItem.select(order.getOrder_id()).iterator();
								while (ite.hasNext()){
									check = true;
									SaleOrderItem itemOrder = (SaleOrderItem) ite.next();
									InventoryMaster mat = itemOrder.getUIMat(); 
									Package pac = itemOrder.getUIPac();
									String type = itemOrder.getItem_type(); 
								%>
							<tr>
								<td valign="top" align="center"><%=mat.getGroup_id()%></td>
								<td valign="top" align="left"><%=mat.getDescription()%></td>
								<td valign="top" align="center"><%=itemOrder.getItem_qty()%></td>
								<td valign="top" align="center"><%=(mat.getGroup_id().equalsIgnoreCase("SS")?"KG":mat.getDes_unit())%></td>
								<td valign="top" align="center">
									<button class="btn_box thickbox btn_confirm" lang="plan_buffer_edit.jsp?order_id=<%=itemOrder.getOrder_id()%>&item_id=<%=itemOrder.getItem_id()%>&item_run=<%=itemOrder.getItem_run()%>&width=500&height=200" title="แก้ไขรายการสินค้า">แก้ไข</button>
									<input type="button" class="btn_box btn_warn m_left5 btn_del_item" order_id="<%=itemOrder.getOrder_id()%>" item_id="<%=itemOrder.getItem_id()%>" item_type="<%=itemOrder.getItem_type()%>" item_run="<%=itemOrder.getItem_run()%>" value="ลบ"/>	 
								</td>	
							</tr>
								<%
								}
								if(check == false){
								%>
								<tr><td colspan="5" class="txt_center">-- ไม่มีรายการที่เลือก --</td></tr>
								<%		
								}
								%>
							</tbody>
						</table>						
						
					</fieldset>
					<div class="dot_line m_top10"></div>
					<% if(check == true){ %>
					<div class="center txt_center">
						<button class="btn_box btn_confirm" id="btn_click_send">ส่ง</button>
					</div>
				<% }} %>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>	
</div>

</body>
</html>