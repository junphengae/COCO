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
<title>รายการสินค้า</title>
<%
String order_id = WebUtils.getReqString(request, "order_id");
String temp_invoice = WebUtils.getReqString(request, "temp_invoice");
String invoice = WebUtils.getReqString(request, "invoice");
String m = WebUtils.getReqString(request, "m");
List paramList = new ArrayList();

if(temp_invoice.equalsIgnoreCase("")){
	paramList.add(new String[]{"invoice",invoice});
}else{
	paramList.add(new String[]{"temp_invoice",temp_invoice});
}

session.setAttribute("SO_SEARCH", paramList);

SaleOrder order = SaleOrder.selectByID(order_id);
Customer cus = Customer.select(order.getCus_id());
Personal sale = Personal.select(order.getSale_by());


%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
			
				<div class="left"><%=(invoice.equalsIgnoreCase("")?"เลขที่ใบส่งของ No. " + temp_invoice:"เลขที่ Invoice No. " + invoice)%></div>
				<div class="right btn_box m_right15" onclick="history.back();">ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<table width="100%" cellpadding="2" cellspacing="2">
					<tbody>
						<tr>
							<td width="50">ชื่อลูกค้า</td>
							<td width="370"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=cus.getCus_id()%>&height=300&width=520">: <%=cus.getCus_name()%></div></td>
						</tr>
					</tbody>
				</table>
				
				<div class="dot_line m_top10"></div>
				
				<form id="sale_order_info" onsubmit="return false;">
				<fieldset class="fset">
						<legend>รายการสินค้า</legend>
						<table class="bg-image s900">
						<thead>
								<tr>
									<th valign="top" align="center" width="28%">รายการสินค้า</th>
									<th valign="top" align="center" width="5%">จำนวน</th>
									<th valign="top" align="center" width="15%">บรรจุภัณฑ์</th>
									<th valign="top" align="center" width="8%">วันที่ร้องขอ</th>
								</tr>
							</thead>	
							<%
								Iterator ite = SaleOrderItem.selectinv(paramList).iterator();
								while (ite.hasNext()){
									SaleOrderItem itemOrder = (SaleOrderItem) ite.next();
							%>
							<tbody>
								
							<tr>
								<td valign="top" align="left">
									<%=(itemOrder.getItem_type().equalsIgnoreCase("p"))?itemOrder.getUIPacName():itemOrder.getUIMatName()
									%>
								</td>
								<td valign="top" align="center">
									<%=itemOrder.getItem_qty()%>
								</td>
								<td valign="top" align="center">
									<%=(itemOrder.getItem_type().equalsIgnoreCase("p"))?"ชุด":itemOrder.getUIMatType()%>
								</td>
								<td valign="top" align="center">
									<%=WebUtils.getDateValue(itemOrder.getRequest_date())%>
								</td>
							</tr>
								<%} %>
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