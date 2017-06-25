<%@page import="com.bitmap.bean.logistic.Detail_send"%>
<%@page import="com.bitmap.bean.logistic.SendProduct"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
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

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/jquery.validate.js" type="text/javascript"></script>
<script src="../js/jquery.metadata.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการคืน</title>
<%
String invoice = WebUtils.getReqString(request, "invoice");

List paramList = new ArrayList();
paramList.add(new String[]{"invoice",invoice});
String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(30);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}
session.setAttribute("CUS_SEARCH", paramList);

Iterator cusIte = SaleOrderItem.selectInvWithCTRL(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการคืน | สร้างรายการคืนสินค้า [1:เลือกจากใบ invoice]</div>
				<div class="right m_right10">
					<button class="btn_box" onclick="window.location='sale_receive.jsp';">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="detail_wrap s800 center txt_center">
					<form style="margin: 0; padding: 0;" action="sale_select_inv.jsp" method="get">
						ค้นหาจากใบ invoce : <input type="text" name="invoice" id="invoice" value="<%=invoice%>" class="txt_box s150" autocomplete="off"> 
						&nbsp;&nbsp;
						<br><br>
						<button type="submit" name="btn_search" class="btn_box btn_confirm">ค้นหา</button>
						
						</form>
				</div>
				
				<div class="dot_line m_top5"></div>
				
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"sale_select_inv.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<table class="bg-image s900 m_top5">
					<thead>
						<tr>
							<th width="8%" align="center">No.</th>
							<th width="10%" align="center">ประเภท</th>
							<th width="30%" align="center">รายการ</th>
							<th width="30%" align="center">ลูกค้า</th>
							<th width="10%" align="center"></th>
						</tr>
					</thead>
					<%
					String status = "";
					while(cusIte.hasNext()){ 
						SaleOrderItem item = (SaleOrderItem) cusIte.next();
					%>
					<tbody>
						<tr>
							<td align="center"><%=item.getInvoice()%></td>
							<td align="center"><%=item.getItem_type()%></td>
							<td align="center"><%=item.getItem_type().equalsIgnoreCase("p")?item.getUIPacName():item.getUIMatName()%></td>
							<td align="center"><%=item.getUICustomer().getCus_name()%></td>
							<td align="center"><button class="btn_click btn_box" item_run="<%=item.getItem_run()%>">เลือก</button></td>
						</tr>
					</tbody>
					
					<%} %>
				</table>
				
			</div>
			<div class="wrap_desc">
				- 
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
<script type="text/javascript">
$(function(){
	$('.btn_click').click(function(){
		var data = {"action":"add_receive","item_run":(this).attr("item_run")}
			ajax_load();	
			$.post('SaleManage',data,function(resData){
				ajax_remove();
				if (resData.status == 'success') {	
					window.location.reload();
				} else {					
					alert(resData.message);
				}
			},'json');	
	});
});
</script>
</body>
</html>