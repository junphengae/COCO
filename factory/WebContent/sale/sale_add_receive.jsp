<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="com.bitmap.bean.sale.Receive"%>
<%@page import="com.bitmap.bean.logistic.SendProduct"%>
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
<title>สร้างรายการคืนสินค้า</title>
<%
String ch = WebUtils.getReqString(request, "ch");
String FG = WebUtils.getReqString(request, "FG");
String order_id = WebUtils.getReqString(request, "order_id");
String invoice = WebUtils.getReqString(request, "invoice");
String type_inv = WebUtils.getReqString(request, "type_inv");
String item_type = WebUtils.getReqString(request, "item_type");
String pk_id = WebUtils.getReqString(request, "pk_id");

String id_receive = WebUtils.getReqString(request, "id_receive");
Receive rec = new Receive();
rec.setId_receive(id_receive);
Receive.select(rec);




SaleOrder order = new SaleOrder();
order = SaleOrder.selectByID(order_id);
%>

<script type="text/javascript">
$(function(){
	$('#receive_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});

	$('#sale_add_receive').submit(function(){
		var $duedate = $('#receive_date');		
		var duedate = $duedate.val().split('/');
		if ($('#qty').val() == ""){
			alert('กรุณาใส่จำนวน!');
			$('#qty').focus();
		}else if(duedate=='')	{
			alert('กรุณาใส่วันรับของคืน!');
			$duedate.focus();
		} else{
					ajax_load();
					$.post('SaleManage',$(this).serialize(),function(resData){
						ajax_remove();
						if (resData.status == 'success') {
							window.location = 'sale_receive.jsp';
						} else {
							alert(resData.message);
						}
					},'json');	
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
				<div class="left">รายการคืน | สร้างรายการคืนสินค้า [1.เลือกจากใบ invoice 2.เลือก <%=(item_type.equalsIgnoreCase("s")?"FG":"Promotion") %>]</div>
				<div class="right btn_box m_right15" onclick="window.location='sale_select_inv.jsp'">ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="sale_add_receive" onsubmit="return false;">
				<table width="100%" cellpadding="2" cellspacing="2">
					<tbody>
						<tr>
							<td width="100">No.</td>
							<td >: <%=invoice%></td>
						<tr>
						<tr>
							<td>ประเภท</td>
							<td >: <%=(type_inv.equalsIgnoreCase("10")?"invoice":"ใบส่งของชั่วคราว")%></td>
						<tr>
							<td>ชื่อลูกค้า</td>
							<td>: <%=order.getUICustomer().getCus_name()%></td>
						</tr>
					</tbody>
				</table>
				
				<div class="dot_line m_top10"></div>
				
				
					<table width="100%" cellpadding="2" cellspacing="2">
						<tbody>
							<% if(item_type.equalsIgnoreCase("p")){ %>
							<tr>
								<td width="130">สินค้าจัดจำหน่าย</td>
								<td>: 
									<bmp:ComboBox name="FG" styleClass="txt_box s250" listData="<%=PackageItem.selectPackage(pk_id)%>"  value="<%=FG%>">
									</bmp:ComboBox>
								</td>
							</tr>
							<% }else{ 
								InventoryMaster mat = InventoryMaster.select(FG);  %>
							<tr>
								<td width="130">สินค้าจัดจำหน่าย</td>
								<td>: <%=mat.getDescription() %></td>
								<input type="hidden" name="FG" value="<%=FG%>">
							</tr>
							<% } %>
							<tr>
								<td width="130">จำนวน</td>
								<td>: <input type="text" name="qty" id="qty" class="txt_box" autocomplete="off" value="<%=rec.getQty()%>"></td>
							</tr>
							<tr>
								<td width="130">วันที่รับของ</td>
								<td>: <input type="text" name="receive_date" id="receive_date" class="txt_box" autocomplete="off" value="<%=WebUtils.getDateValue(rec.getReceive_date())%>"></td>
							</tr>
							<tr><td colspan="4" height="15"></td></tr>
							<tr>
								<td colspan="4" align="center">
									<button class="btn_box btn_confirm" id="btn_add_receiv" type="submit">บันทึก</button>
								</td>
							</tr>
						</tbody>
					</table>
					<input type="hidden" name="action" value="<%=(ch.equalsIgnoreCase("")?"gen_receive_id":"update_receive")%>">
					<input type="hidden" name="<%=(ch.equalsIgnoreCase("")?"create_by":"update_by")%>" value="<%=securProfile.getPersonal().getPer_id()%>">
					<input type="hidden" name="type_inv" value="<%=type_inv%>">
					<input type="hidden" name="invoice" value="<%=invoice%>">
					<input type="hidden" name="order_id" value="<%=order_id%>">
					<input type="hidden" name="id_receive" value="<%=id_receive%>">
					<input type="hidden" name="pk_id" value="<%=pk_id%>">
					<input type="hidden" name="cus_id" value="<%=order.getUICustomer().getCus_id()%>">
				</form>
			</div>
			<div class="wrap_desc">
				- หน้าจอนี้ใช้สร้างรายการรับสินค้าคืนจากลูกค้า โดยให้ใส่จำนวนและวันที่รับของ
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>	
</div>

</body>
</html>