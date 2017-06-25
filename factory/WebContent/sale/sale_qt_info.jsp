<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.sale.SaleQt"%>
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
<title>รายการขาย</title>
<%
String order_id = WebUtils.getReqString(request, "order_id");
String cus_id = WebUtils.getReqString(request, "cus_id");


SaleOrder order = SaleOrder.selectByID(order_id);
Customer cus = Customer.select(cus_id);

Personal sale = Personal.select(order.getSale_by());


%>

<script type="text/javascript">
$(function(){
	$('.btn_del_item').click(function(){
		if (confirm('ยืนยันการลบ!')) {
			var data = {
						'action':'sale_orderitem_del',
						'item_run':$(this).attr('item_run'),
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
});
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการขาย</div>
				<div class="right btn_box m_right15" onclick="history.back();">ย้อนกลับ</div>
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
							<tr >
								<td width="130">PO</td>
								<td width="370">: <%=order.getPo()%></td>
								
								<td width="130">สถานะ</td>
								<td width="370" class="txt_bold txt_red" >: <%=SaleOrder.status(order.getStatus())%></td>
							</tr>
							
							
							<tr><td colspan="4" height="15"></td></tr>
						</tbody>
					</table>
					<input type="hidden" name="cus_id" value="<%=cus_id%>">
					<input type="hidden" name="order_id" id="order_id" value="<%=order.getOrder_id()%>">
					<input type="hidden" name="action" value="create_qt">
					<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
				
				
				<div class="dot_line m_top10"></div>
				
<%-- 				<div id="formular_list" class="<%=(order.getOrder_type().length() > 0)?"":"hide"%> m_top10"> --%>
<!-- 					เลือกสินค้า -->
<!-- 				</div> -->
				<fieldset class="fset">
						<legend>รายการสินค้า</legend>
						<table class="bg-image s_auto">
							
							<%
								Iterator ite = SaleOrderItem.select(order.getOrder_id()).iterator();
								boolean has = true;
								int i = 1;
								while (ite.hasNext()){
									has = false;
									SaleOrderItem itemOrder = (SaleOrderItem) ite.next();
									InventoryMaster mat = itemOrder.getUIMat(); 
									Package pac = itemOrder.getUIPac();
									String type = itemOrder.getItem_type();
									if(i==1){
							%>
							<thead>
								<tr>
									<th valign="top" align="center" width="28%">รายการสินค้า</th>
									<th valign="top" align="center" width="10%">ราคาต่อหน่วย</th>
									<th valign="top" align="center" width="5%">จำนวน</th>
									<th valign="top" align="center" width="5%">จำนวนที่จอง</th>
									<th valign="top" align="center" width="8%">วันที่ร้องขอ</th>
									<th valign="top" align="center" width="8%">วันที่เริ่มผลิต</th>
									<th valign="top" align="center" width="8%">วันที่เสร็จ</th>
									<th valign="top" align="center" width="12%">สถานะ</th>

								</tr>
							</thead>
									<%
									}
									%>	
							<tbody>
								
							<tr>
								<td valign="top" align="left">
								<div class="thickbox pointer" title="ข้อมูลสินค้า" lang="../info/item_info.jsp?item_id=<%=itemOrder.getItem_id()%>&type=<%=type%>&item_run=<%=itemOrder.getItem_run()%>&height=300&width=520">
									<%=(type.equalsIgnoreCase("p"))?
											pac.getName():mat.getDescription()
									%>
								</div></td>
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
									<%=SaleOrderItem.bookfg(itemOrder.getItem_id(),itemOrder.getItem_type())%>
								</td>
								<td valign="top" align="center">
								<div class="thickbox pointer" title="ข้อมูลสินค้า" lang="../info/item_info.jsp?item_id=<%=itemOrder.getItem_id()%>&type=<%=type%>&item_run=<%=itemOrder.getItem_run()%>&height=300&width=520">
								
									<%=WebUtils.getDateValue(itemOrder.getRequest_date())%>
								</div>
								</td>
								<td valign="top" align="center">
								<div class="thickbox pointer" title="ข้อมูลสินค้า" lang="../info/item_info.jsp?item_id=<%=itemOrder.getItem_id()%>&type=<%=type%>&item_run=<%=itemOrder.getItem_run()%>&height=300&width=520">
									<%=WebUtils.getDateValue(itemOrder.getStart_date())%>
								</div>
								</td>
								<td valign="top" align="center">
								<div class="thickbox pointer" title="ข้อมูลสินค้า" lang="../info/item_info.jsp?item_id=<%=itemOrder.getItem_id()%>&type=<%=type%>&item_run=<%=itemOrder.getItem_run()%>&height=300&width=520">
									<%=WebUtils.getDateValue(itemOrder.getConfirm_date())%>
								</div>
								</td>
								<td valign="top" align="center">
								<div class="thickbox pointer" title="ข้อมูลสินค้า" lang="../info/item_info.jsp?item_id=<%=itemOrder.getItem_id()%>&type=<%=type%>&item_run=<%=itemOrder.getItem_run()%>&height=300&width=520">
									<%=SaleOrderItem.status(itemOrder.getStatus())%>
								<%
								if(itemOrder.getStatus().equalsIgnoreCase(SaleOrderItem.STATUS_PLAN_SUBMIT)){
								%><button type="button" class="btn_box btn_warn btn_del_item" item_run = "<%=itemOrder.getItem_run()%>">ยกเลิก</button>
								<%}%>
								</div>
								</td>
							</tr>
								<%
								i++;
								}
								%>
							</tbody>
						</table>		
					</fieldset>
				</form>
			</div>
			<div class="wrap_desc">
				- หน้าจอนี้ใช้แสดงรายการสินค้าทั้งหมดในแต่ละรายการขาย และบอกสถานะของรายการสินค้านั้นๆ
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>	
</div>

</body>
</html>