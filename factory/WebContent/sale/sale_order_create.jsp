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
<title>สร้างรายการขาย</title>
<%
String order_id = WebUtils.getReqString(request, "order_id");
String cus_id = WebUtils.getReqString(request, "cus_id");

SaleOrder order = SaleOrder.selectByID(order_id);
Customer cus = Customer.select(cus_id);
List list = Personal.listDropdown("0010"); 

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
						'item_run':$(this).attr('item_run'),
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
	
	$('.btn_del').click(function(){
		if (confirm('ยืนยันการลบรายการขาย!\n*เมื่อลบไปแล้วจะไม่สามารถกลับมาแก้ไขได้อีก')) {
			var data = {
						'action':'delete_order',
						'order_id':$(this).attr('order_id'),
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>'
					   };
			
			ajax_load();
			$.post('SaleManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location = 'sale_order.jsp';
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
			$.post('SaleManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location = "sale_order.jsp";
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	
	$('#btn_click_qt').click(function(){
		if (confirm('ยืนยันการส่ง(ไม่ผ่านฝ่ายวางแผน)!')) {
			var data = {
						'action':'update_order_qt',
						'order_id':$('#order_id').val(),
						'order_type':$('#order_type').val(),
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>'
					   };
			
			ajax_load();
			$.post('SaleManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location = "sale_qt.jsp";
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	
	$('#sale_order_info').submit(function(){
		var $duedate = $('#due_date');		
		var duedate = $duedate.val().split('/');
		
		if($('#sale_by').val() == ''){
			alert('กรุณากำหนดพนักงานขาย!');
			$('sale_by').focus();
		}else if(duedate=='')	{
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
				<div class="left">รายการขาย | สร้างรายการขาย [1:เลือกลูกค้า | 2:เลือกสูตร]</div>
				<div class="right btn_box m_right15" onclick="window.location='sale_order.jsp'">ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="sale_order_info" onsubmit="return false;">
				<table width="100%" cellpadding="2" cellspacing="2">
					<tbody>
						<tr>
							<td width="130">ชื่อลูกค้า</td>
							<td width="370"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=cus.getCus_id()%>&height=300&width=520">: <%=cus.getCus_name()%></div></td>
							<td width="130">ชื่อพนักงานขาย </td>
							<td> :
								<bmp:ComboBox name="sale_by" styleClass="txt_box s150" listData="<%=list%>" value="<%=order.getSale_by()%>">
									<bmp:option value="" text="---- เลือกพนักงานขาย ----"></bmp:option>
								</bmp:ComboBox>	
							</td>
						</tr>
					</tbody>
				</table>
				
				<div class="dot_line m_top10"></div>
					<!-- input ตัวนี้คืออะไร ไว้ใช้ทำอะไร??? -->
					<%-- <input type="hidden" name="order_type" id="order_type" value="<%=order.getOrder_type()%>"> --%>
					<table width="100%" cellpadding="2" cellspacing="2">
						<tbody>
							<tr>
								<% if(!(order.getOrder_type().equalsIgnoreCase(""))){								
								%>
								<td width="130">ประเภท</td>
								<td width="370">: <%=SaleOrder.type(order.getOrder_type())%></td>
								
								<%
								}else{
								%>
								<td width="130">ประเภท</td>
								<td width="370">: 
									<bmp:ComboBox  name="order_type" styleClass="txt_box s150" listData="<%=SaleOrder.typeDropDown()%>" value="<%=order.getOrder_type()%>">
										
									</bmp:ComboBox>
								</td>
								<% } %>
								<td width="130">กำหนดส่งของ</td>
								<td>: <input type="text" name="due_date" id="due_date" class="txt_box" value="<%=(order.getDue_date()==null)?"":WebUtils.getDateValue(order.getDue_date())%>"></td>
							</tr>
							<tr>
								<td>PO</td>
								<td>: 
								<% if(order_id.length() > 0){ %>
								<%=order.getPo() %>
								<%}else{ %>
								<input type="text" name="po" id="po" class="txt_box" value="<%=order.getPo()%>">
								<%} %>
								</td>
							</tr>
							<tr><td colspan="4" height="15"></td></tr>
							<tr>
								<td colspan="4" align="center">
									<button class="btn_box btn_confirm" id="btn_save_order" type="button">บันทึก</button>
									<%
										if(order_id.length() > 0){
										%><button type="button" class="btn_box btn_warn btn_del" order_id = "<%=order_id%>">ยกเลิก</button>
									<%}%>
				
								</td>
							</tr>
						</tbody>
					</table>
					<input type="hidden" name="cus_id" value="<%=cus_id%>">
					<input type="hidden" name="order_id" id="order_id" value="<%=order.getOrder_id()%>">
					<input type="hidden" name="action" value="<%=(order.getOrder_id().length()>0)?"update_info":"gen_order_id"%>">
					<input type="hidden" name="<%=(order.getOrder_id().length()>0)?"update_by":"create_by"%>" value="<%=securProfile.getPersonal().getPer_id()%>">
					<% if(!(order.getOrder_type().equalsIgnoreCase(""))){	
					%>
					 <input type="hidden" name="order_type" id="order_type" value="<%=order.getOrder_type()%>">
					<%	
					}
					%>
				</form>

				<%if (order.getOrder_type().length() > 0) {%>
				<div class="dot_line m_top10"></div>
				
				<fieldset class="fset ">
						<legend>รายการสินค้า</legend>
						
						<% if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_CHANGE) || order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_MODIFY)){
							
							
						}else if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_SAMPLE)){ %>
						
						<div class="right"><button class="btn_box btn_confirm thickbox" title="เพิ่มสินค้าปกติ" lang="sale_item_add.jsp?order_id=<%=order.getOrder_id()%>&dis=<%=cus.getCus_discount()%>&width=500&height=200">เพิ่มสินค้าปกติ</button></div>
						<%} else{ %>
						
							<div class="right">
							<button class="btn_box btn_confirm thickbox" title="เพิ่มสินค้าปกติ" lang="sale_item_add.jsp?order_id=<%=order.getOrder_id()%>&dis=<%=cus.getCus_discount()%>&width=500&height=250">เพิ่มสินค้าปกติ</button>
						<% if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_SALE)){ %>
							<button class="btn_box btn_confirm thickbox" title="เพิ่มสินค้าโปรโมชั่น" lang="sale_promotion_add.jsp?order_id=<%=order.getOrder_id()%>&dis=<%=cus.getCus_discount()%>&width=500&height=200">เพิ่มสินค้าโปรโมชั่น</button>
						<% } %>
						</div>
						<div class="clear"></div>
						<%} %>
						<table class="bg-image s900">
							<thead>
								<tr>
									<th valign="top" align="center" width="10%">ประเภทสินค้า</th>
									<th valign="top" align="center" width="30%">รายการสินค้า</th>
									<th valign="top" align="center" width="10%">ราคาต่อหน่วย</th>
									<th valign="top" align="center" width="5%">จำนวน</th>
									<th valign="top" align="center" width="10%">จำนวนที่มีการจอง</th>
									<th valign="top" align="center" width="8%">วันที่ร้องขอ</th>
									<th valign="top" align="center" width="12%"></th>
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
								<div class="thickbox pointer" title="ข้อมูลสินค้า" lang="../info/item_info.jsp?item_id=<%=itemOrder.getItem_id()%>&type=<%=type%>&item_run=<%=itemOrder.getItem_run()%>&height=300&width=520">
									<%=(itemOrder.getItem_type().equalsIgnoreCase("s")?"FG":"PRO")%>
								</div>
								</td>
								<td valign="top" align="left">
								<div class="thickbox pointer" title="ข้อมูลสินค้า" lang="../info/item_info.jsp?item_id=<%=itemOrder.getItem_id()%>&type=<%=type%>&item_run=<%=itemOrder.getItem_run()%>&height=300&width=520">
									<%=(type.equalsIgnoreCase("p"))?
											pac.getName():mat.getDescription()
									%>
								</div>
								</td>
								<td valign="top" align="center">
								<div class="thickbox pointer" title="ข้อมูลสินค้า" lang="../info/item_info.jsp?item_id=<%=itemOrder.getItem_id()%>&type=<%=type%>&item_run=<%=itemOrder.getItem_run()%>&height=300&width=520">
									<%=Money.money(itemOrder.getUnit_price())%>
								</div>
								</td>
								<td valign="top" align="center">
								<div class="thickbox pointer" title="ข้อมูลสินค้า" lang="../info/item_info.jsp?item_id=<%=itemOrder.getItem_id()%>&type=<%=type%>&item_run=<%=itemOrder.getItem_run()%>&height=300&width=520">
									<%=itemOrder.getItem_qty()%>
								</div>
								</td>
								
								<td valign="top" align="center">
								<div class="thickbox pointer" title="ข้อมูลสินค้า" lang="../info/item_info.jsp?item_id=<%=itemOrder.getItem_id()%>&type=<%=type%>&item_run=<%=itemOrder.getItem_run()%>&height=300&width=520">
									<%=SaleOrderItem.bookfg(itemOrder.getItem_id(),type)%>
								</div>
								</td>
								
								<td valign="top" align="center">
								<div class="thickbox pointer" title="ข้อมูลสินค้า" lang="../info/item_info.jsp?item_id=<%=itemOrder.getItem_id()%>&type=<%=type%>&item_run=<%=itemOrder.getItem_run()%>&height=300&width=520">
									<%=WebUtils.getDateValue(itemOrder.getRequest_date())%>
								</div>
								</td>
								<td valign="top" align="center">
								<%
								if(itemOrder.getItem_type().equalsIgnoreCase("s")){
								%>
									<button class="btn_box thickbox btn_confirm" lang="sale_item_edit.jsp?order_id=<%=itemOrder.getOrder_id()%>&item_id=<%=itemOrder.getItem_id()%>&item_run=<%=itemOrder.getItem_run()%>&width=500&height=250" title="แก้ไขรายการสินค้า">แก้ไข</button>
									<%	
								}else{
								%>
									<button class="btn_box thickbox btn_confirm" lang="sale_promotion_edit.jsp?order_id=<%=itemOrder.getOrder_id()%>&item_id=<%=itemOrder.getItem_id()%>&item_run=<%=itemOrder.getItem_run()%>&width=500&height=250" title="แก้ไขรายการสินค้า">แก้ไข</button>
								<%
								}
								%>
								
								<% if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_CHANGE) || order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_MODIFY)){}else{ %>
								<input type="button" class="btn_box btn_warn m_left5 btn_del_item" order_id="<%=itemOrder.getOrder_id()%>" item_id="<%=itemOrder.getItem_id()%>" item_type="<%=itemOrder.getItem_type()%>" item_run="<%=itemOrder.getItem_run()%>" value="ลบ"/>	
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
					<div class="center txt_center">
						<button class="btn_box btn_confirm" id="btn_click_send">ส่งฝ่ายวางแผน</button>
						<button class="btn_box btn_confirm" id="btn_click_qt">ออกใบเสนอราคา</button>
					</div>
				<%} %>
			</div>
			<div class="wrap_desc">
				- หน้าจอนี้ใช้ในการเพิ่ม/แก้ไข/ลบรายการสินค้า เมื่อเพิ่มข้อมูลเรียบร้อยให้กดปุ่มส่งฝ่ายวางแผน เพื่อส่งฝ่ายวางแผนต่อไป
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>	
</div>

</body>
</html>