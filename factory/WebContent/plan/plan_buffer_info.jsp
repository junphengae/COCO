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
<title>รายการ Buffer</title>
<%
String order_id = WebUtils.getReqString(request, "order_id");
String cus_id = WebUtils.getReqString(request, "cus_id");


SaleOrder order = SaleOrder.selectByID(order_id);
Customer cus = Customer.select(cus_id);

Personal sale = Personal.select(order.getSale_by());


%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการ Buffer</div>
				<div class="right btn_box m_right15" onclick='history.back();'>ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="sale_order_info" onsubmit="return false;">
					<table width="100%" cellpadding="2" cellspacing="2">
						<tbody>
							<tr>
								<td width="130">ประเภท :<td>
								<td width="370"> <%=SaleOrder.type(order.getOrder_type())%></td>
								<td width="130">สถานะ :</td>
								<td width="370" class="txt_bold txt_red" ><%=SaleOrder.status(order.getStatus())%></td>
							</tr>
			
							<tr><td colspan="4" height="15"></td></tr>
						</tbody>
					</table>

				<div class="dot_line m_top10"></div>
				<fieldset class="fset">
						<legend>รายการสินค้า</legend>
						<table class="bg-image s900">
							
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

									<th valign="top" align="center" width="10%">ประเภทสินค้า</th>
									<th valign="top" align="center" width="30%">รายการสินค้า</th>
									<th valign="top" align="center" width="10%">จำนวน</th>
								</tr>
							</thead>
									<%
									}
									%>	
							<tbody>
								
							<tr>
								<td valign="top" align="center">
									<%=mat.getGroup_id()%>
								</td>
								<td valign="top" align="left">
									<%=mat.getDescription()%>
								</td>
								<td valign="top" align="center">
									<%=itemOrder.getItem_qty()%> Kg
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
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>	
</div>

</body>
</html>