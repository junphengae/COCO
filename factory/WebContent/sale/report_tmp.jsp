<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.Province"%>
<%@page import="com.bitmap.bean.logistic.Busstation"%>
<%@page import="com.bitmap.bean.logistic.SendProduct"%>
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
<script src="../js/popup.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการใบส่งของ</title>
<%
String temp_invoice = WebUtils.getReqString(request, "temp_invoice");

List param = new ArrayList();
String page_ = WebUtils.getReqString(request, "page");

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);

param.add(new String[]{"temp_invoice",temp_invoice});
session.setAttribute("PRO_SEARCH", param);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("PRO_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("PRO_SEARCH_PAGE")));
}

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("PRO_SEARCH_PAGE", page_);
}

List list = SaleOrderItem.havetmpInvoice2(ctrl, param);
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการใบส่งของ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 center txt_center">
						<form style="margin: 0; padding: 0;" action="report_tmp.jsp" id="search" method="get">
							ค้นหาเลขที่ใบส่งของ : <input type="text" name="temp_invoice" id="temp_invoice" value="<%=temp_invoice%>" class="txt_box s150" autocomplete="off"> 
							<br><br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
						</form>
					</div>
					
					<div class="dot_line m_top5"></div>
					
					
					<div class="clear"></div>
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="15%">เลขที่ใบส่งของ</th>
								<th valign="top" align="center" width="15%">ประเภทการขาย</th>
								<th valign="top" align="center" width="10%">ref invoice</th>
								<th valign="top" align="center" width="20%">ลูกค้า</th>
								<th valign="top" align="center" width="20%">สถานะ</th>
								<th valign="top" align="center" width="10%"></th>
								
							</tr>
						</thead>
						<tbody>
						<%
					Iterator ite = list.iterator();
					boolean check = false;
					while (ite.hasNext()){
						check = true;
						SaleOrderItem item = (SaleOrderItem) ite.next();

					%>
						<%-- <tr>
							<td valign="top" align="center"><%=item.getTemp_invoice()%></td>
							<td valign="top" align="center"><%=SaleOrder.type(item.getUIOrder().getOrder_type())%></td> 
							<td valign="top" align="center"><%=item.getInvoice()%></td> 
							<td valign="top" align="center"><%=item.getUINameCus()%></td> 
							<td valign="top" align="center"><%=(item.getStatus().equalsIgnoreCase(SaleOrderItem.STATUS_INVOICE)?"ปิด":SaleOrderItem.status(item.getStatus()))%></td>
							<td valign="top" align="center"><img class="pointer" src="../images/clipboard_16.png" onclick="popup('reportBytpinvoice.jsp?invoice=<%=item.getTemp_invoice()%>&cus_id=<%=item.getUIOrder().getCus_id()%>')"></img></td>
						
						</tr> --%>
						
					<%
					}
					%>
					<tr><td valign="top" align="center" colspan="6">--- Comming  Soon ---</td></tr>
					<%
					if(check == false){
						%>
						<tr><td valign="top" align="center" colspan="6">--- ไม่มีรายการส่งของชั่วคราว ---</td></tr>
					<%} %>
						</tbody>
					</table>
					
				</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>

</body>
</html>