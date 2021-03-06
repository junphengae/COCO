<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.bitmap.bean.sale.Province"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.sale.Zipcode"%>
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
<title>รายการใบส่งของ</title>
<%


String sent_id = WebUtils.getReqString(request, "sent_id"); 
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"sent_id",sent_id});


session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = Production.selectAllProduct(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการใบส่งของ</div>
			</div>
			<div class="content_body">
					<form id="sale_order_info" style="margin: 0; padding: 0;" action="sale_sent_report.jsp" id="search" method="get">
			
					<div class="detail_wrap s800 center txt_center">
							เลขที่ใบเสนอราคา : <input class="txt_box" type="text" name="sent_id" value="<%=sent_id%>">
							&nbsp;&nbsp;
							<br><br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>

						
					</div>
					
									
				<!-- next page -->  
				<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"sale_sent_report.jsp",paramList)%></div>
				<div class="clear"></div>
				<!-- next page  -->
					<div class="dot_line m_top5"></div>
					<div class="clear"></div>
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="5">วันที่เสร็จ</th>
								<th valign="top" align="center" width="15%">ชื่อลูกค้า</th>
								<th valign="top" align="center" width="15%">ผู้ออก</th>
								<th valign="top" align="center" width="40%">รายการสินค้า</th>
								<th valign="top" align="center" width="10%">จำนวน</th>
								<th valign="top" align="center" width="8%">สถานะ</th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								Production entity = (Production) ite.next();
								Customer cus = entity.getUICus();
								Personal sale = entity.getUIPer();
								SaleOrderItem item = entity.getUIorder();
								InventoryMaster mat = entity.getUIMat();
								has = false;
						%>
							<tr>
								<td align="center"><%=WebUtils.getDateValue(item.getConfirm_date())%></td>
								<td align="center"><%=cus.getCus_name()%></td>	
								<td align="center"><%=sale.getName() + " " + sale.getSurname()%></td>
								<td align="left"><%="(" + mat.getGroup_id() + ") - " + mat.getDescription()%></td>
								<td align="right"><%=item.getItem_qty()%></td>	
								<td></td>
							</tr>
						<%
							}
							
							if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการสินค้า ---- </td></tr>
						<%
							}
						%>
						</tbody>
					</table>
					</form>
				</div>
				
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>

</body>
</html>