<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleQt"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
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

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการเบิก</title>
<%

String order_id = WebUtils.getReqString(request, "order_id");
String item_id = WebUtils.getReqString(request, "item_id");
String cus_id = WebUtils.getReqString(request, "cus_id");
String qt_id = WebUtils.getReqString(request, "qt_id");
String item_run = WebUtils.getReqString(request, "item_run");
String pk_id = WebUtils.getReqString(request, "pk_id");

Package pk =Package.select(item_id);
SaleQt qt = SaleQt.selectQt_id(qt_id);
Customer cus = Customer.select(cus_id);

SaleOrderItem orderItem = new SaleOrderItem();
WebUtils.bindReqToEntity(orderItem, request);
SaleOrderItem.select(orderItem);

Iterator ite  = Production.selectList(item_run).iterator();


%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการเบิก</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
			
					
					<table width="40%" cellpadding="2" cellspacing="2">
						<tbody>
							<tr>
								<td>ชื่อลูกค้า</td>
								<td><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=cus.getCus_id()%>&height=300&width=520">: <%=cus.getCus_name()%></div></td>
							</tr>
							<tr>
								<td>ที่อยู่ </td>
								<td>: <%=cus.getCus_address()%></td>
							</tr>
							<tr>
								<td>Tel</td>
								<td>
									<div class="left">: <%=cus.getCus_phone()%></div>
									<div class="right">Fax : <%=cus.getCus_fax()%></div>
									<div class="clear"></div>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="dot_line m_top15"></div>
					<fieldset class="fset">
						<legend>รายละเอียดสินค้า</legend>
						<table class="s880">
							<tr>								
								<td width="200">ชื่อสินค้า</td>
								<td>: 
									<%=pk.getName()%> 
								</td>
							</tr>					
							<tr>
								<td>จำนวนชุด</td>
								<td>: <%=orderItem.getItem_qty()%> ชุด
								</td>
							</tr>
							<tr>
								<td>วันที่ร้องขอ </td>
								<td>: <%=WebUtils.getDateValue(orderItem.getRequest_date())%>
								</td>
							</tr>
						</table>
						<div class="dot_line m_top15"></div>
						
						<div class="left s200">สินค้าที่ต้องผลิตทั้งหมด : </div>
						<div class="left s650">
						<%
						HashMap<String, PackageItem> map = PackageItem.SumItem(pk.getPk_id());
						Iterator itePK = map.keySet().iterator();
						while (itePK.hasNext()){
							PackageItem item = map.get((String)itePK.next()) ;
						%>
						<div class="left s300"><%=item.getUIMat().getDescription() %></div> 
						<div class="left">จำนวน : <%=Money.multiple(orderItem.getItem_qty(), item.getQty())+ " " + item.getUIMat().getDes_unit()%></div>
						<div class="clear"></div>
						<%
						}
						%>
						</div>
					</fieldset>
					<br>
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="15%">รหัส</th>
								<th valign="top" align="center" width="10%">ประเภท</th>
								<th valign="top" align="center" width="30%">รายการสินค้า</th>
								<th valign="top" align="center" width="10%">จำนวน</th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								Production pro = (Production) ite.next();
								InventoryMaster mat = pro.getUIMat();
								has = false;
						%>	
						<tr>
							<td valign="top" align="right"><%=pro.getItem_id()%></td>
							<td valign="top" align="center"><%=pro.getItem_type()%></td>
							<td valign="top" align="left"><%=mat.getDescription()%></td>
							<td valign="top" align="center"><%=pro.getItem_qty()%></td>
						</tr>
						<%
							}
						%>
						</tbody>
					</table>
					
				</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>

</body>
</html>