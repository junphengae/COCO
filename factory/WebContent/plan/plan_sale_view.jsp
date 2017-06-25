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
<title>ประเมินรายการขาย</title>
<%
String order_id = WebUtils.getReqString(request, "order_id");
String cus_id = WebUtils.getReqString(request, "cus_id");

SaleOrder order = SaleOrder.selectByID(order_id);
Customer cus = Customer.select(cus_id);

Personal sale = Personal.select(order.getSale_by());
%>

<script type="text/javascript">
$(function(){
	$('#due_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
	
	$('#btn_save_order').click(function(){
		$('#sale_order_info').submit();
	});
	
	$('.btn_del_item').click(function(){
		if (confirm('ยืนยันการลบ!')) {
			var data = {
						'action':'sale_orderitem_del',
						'order_id':$(this).attr('order_id'),
						'item_id':$(this).attr('item_id'),
						'item_type':$(this).attr('item_type'),
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>'
					   };
			
			ajax_load();
			$.post('SaleManage',data, function(resData){
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
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>'
					   };
			
			ajax_load();
			$.post('SaleManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	
	$('.btn_click').click(function(){
		if ($('#')) {
			var data = {
						'action':'update_order_status',
						'order_id':$('#order_id').val(),
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>'
					   };
			
			ajax_load();
			$.post('SaleManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	
	$('#sale_order_info').submit(function(){
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
							window.location='sale_order_create.jsp?cus_id=<%=cus_id%>&order_id=' + resData.order_id;
						} else {
							alert(resData.message);
						}
					},'json');	
				}
		}
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
				<div class="left"><%=(order.getStatus().equalsIgnoreCase("50")?"1. อนุมัติใบเสนอราคา | 2. แสดงรายละเอียดสินค้า":"1. ประเมินรายการขาย")%></div>
				<div class="right m_right10 btn_box" onclick="window.location='<%=(order.getStatus().equalsIgnoreCase("50")?"plan_sale_ap.jsp":"plan_sale.jsp")%>'">ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<table width="100%" cellpadding="2" cellspacing="2">
					<tbody>
						<tr>
							<td width="130">ชื่อลูกค้า</td>
							<td width="370"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=cus.getCus_id()%>&height=300&width=520">: <%=cus.getCus_name()%></div></td>
							<td width="130">ชื่อพนักงานขาย  </td>
							<td>: <%=(order.getSale_by().equalsIgnoreCase("all")?"ศูนย์กลาง":sale.getName() + " " + sale.getSurname())%></td>	
						</tr>
					</tbody>
				</table>
				
				<div class="dot_line m_top10"></div>
				
				<form id="sale_order_info" onsubmit="return false;">
					<table width="100%" cellpadding="2" cellspacing="2">
						<tbody>
							<tr>
								<td width="130">ประเภท</td>
								<td width="370">: <%=SaleOrder.type(order.getOrder_type())%></td>
								
								<td width="130">กำหนดส่งของ</td>
								<td>: <%=WebUtils.getDateValue(order.getDue_date())%></td>
							</tr>
							<tr>
								<td>สถานะ</td>
								<td colspan="3" class="txt_bold txt_red">: <%=SaleOrder.status(order.getStatus())%></td>
							</tr>
							<tr><td colspan="4" height="15"></td></tr>
						</tbody>
					</table>
					<input type="hidden" name="cus_id" value="<%=cus_id%>">
					<input type="hidden" name="order_id" id="order_id" value="<%=order.getOrder_id()%>">
					<input type="hidden" name="action" value="<%=(order.getOrder_id().length()>0)?"update_info":"gen_order_id"%>">
					<input type="hidden" name="<%=(order.getOrder_id().length()>0)?"update_by":"create_by"%>" value="<%=securProfile.getPersonal().getPer_id()%>">
				</form>
				
				<fieldset class="fset">
						<legend>รายการสินค้า</legend>						
						<table class="bg-image s900">
							<thead>
								<tr>
									<th valign="top" align="center" width="10%">ประเภทสินค้า</th>
									<th valign="top" align="center" width="30%">รายการสินค้า</th>
									<th valign="top" align="center" width="5%">จำนวน</th>
									<th valign="top" align="center" width="10%">หน่วย</th>
									<th valign="top" align="center" width="8%">วันที่ร้องขอ</th>
									<th valign="top" align="center" width="8%">วันที่เริ่มผลิต</th>
									<th valign="top" align="center" width="8%">วันที่เสร็จ</th>
									<th valign="top" align="center" width="10%"></th>
								</tr>
							</thead>
								
							<tbody>
								<%
								Iterator ite = SaleOrderItem.select(order.getOrder_id()).iterator();
								while (ite.hasNext()){
									SaleOrderItem itemOrder = (SaleOrderItem) ite.next();
									InventoryMaster mat = itemOrder.getUIMat(); 
									Package pac = itemOrder.getUIPac();
									String type = itemOrder.getItem_type(); 
								%>
							<tr>
								<td valign="top" align="center">
									<%=(itemOrder.getItem_type().equalsIgnoreCase("s")?"FG":"PRO")%>
								</td>
								<td valign="top" align="left">
									<%=(type.equalsIgnoreCase("p"))?
											pac.getName():mat.getDescription()
									%>
								</td>
								<td valign="top" align="center">
									<%=itemOrder.getItem_qty()%>
								</td>
								<td valign="top" align="center">
									<%=(itemOrder.getItem_type().equalsIgnoreCase("p")?"ชุด":mat.getDes_unit())%>
								</td>
								<td valign="top" align="center">
									<%=WebUtils.getDateValue(itemOrder.getRequest_date())%>
								</td>
								<td valign="top" align="center">
									<%=WebUtils.getDateValue(itemOrder.getStart_date())%>
								</td>
								<td valign="top" align="center">
									<%=WebUtils.getDateValue(itemOrder.getConfirm_date())%>
								</td>
								<td valign="top" align="center">
									<%if(itemOrder.getItem_type().equalsIgnoreCase(SaleOrderItem.TYPE_FG)){ %>
									<input type="button" class="btn_box m_left5 btn_click" onclick="window.location='plan_sale_fg.jsp?order_id=<%=order_id%>&item_id=<%=mat.getMat_code()%>&cus_id=<%=cus_id%>&item_run=<%=itemOrder.getItem_run()%>'" value="view"/>	
									<%} else { %>
									<input type="button" class="btn_box m_left5" onclick="window.location='plan_sale_promotion.jsp?order_id=<%=order_id%>&pk_id=<%=itemOrder.getItem_id()%>&item_id=<%=itemOrder.getItem_id()%>&cus_id=<%=cus_id%>&item_run=<%=itemOrder.getItem_run()%>'" value="view"/>	
									<%} %>
								</td>	
							</tr>
								<%
								}
								%>
							</tbody>
						</table>						
						
					</fieldset>
					<div class="dot_line m_top10"></div>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>		
</div>
	
</body>
</html>