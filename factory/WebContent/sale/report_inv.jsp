<%@page import="com.bitmap.bean.sale.Detailinv"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.Catch"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.production.Production"%>
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

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="../js/popup.js"></script>
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการ invoice</title>
<%
String No = WebUtils.getReqString(request, "No");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"No",No});
session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

List list = Detailinv.selectWithCTRL(ctrl, paramList);

%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการ invoice</div>

			</div>
			
			<div class="content_body">
			<form style="margin: 0; padding: 0;" action="report_inv.jsp" id="search" method="get">
					<div class="detail_wrap s800 center txt_center">
							เลขที่ใบ INVOICE: 
							<input type="text" class="txt_box" name="No" id="No" value="<%=No%>"> 

							<br>
							<br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>							
					</div>
			</form>	
							
			<div class="dot_line m_top5"></div>	
			<div class="clear"></div>
			
			<!-- next page -->  
			<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"report_inv.jsp",paramList)%></div>
			<div class="clear"></div>
			<!-- next page  -->
			
				<table class="bg-image s930">
					<thead>
						<tr>
								<th valign="top" align="center" width="10%">เลขที่ invoice</th>
								<th valign="top" align="center" width="10%">ประเภทการขาย</th>
								<th valign="top" align="center" width="30%">ลูกค้า</th>
								<th valign="top" align="center" width="15%">วันที่ร้องขอ</th>								
								<th valign="top" align="center" width="10%">สถานะ</th>
								<th valign="top" align="center" width="5%"></th>
						</tr>
					</thead>
					<tbody>
					<%
					Iterator ite = list.iterator();
					boolean check = false;
					
					while (ite.hasNext()){
						check = true;
						Detailinv item = (Detailinv) ite.next();
						String inv =item.getNo();
						SaleOrderItem itemRedate = SaleOrderItem.selectByInvShow(inv);
					%>
					<tr>
						<td align="right"><%=item.getNo()%></td>
						<td align="center"><%=(item.getType_vat().equalsIgnoreCase(Detailinv.STATUS_VAT)?"VAT":"NOVAT")%></td>
						<td ><%=Customer.name(item.getUIcus())%></td>
						
						<td align="center"><%=WebUtils.getDateValue(itemRedate.getRequest_date()) %></td>
						<td align="center"><%=(item.getStatus().equalsIgnoreCase("")?"-":SaleOrder.status(item.getStatus())) %></td>					
						<td align="center">						
						<button class="btn_view_inv" onclick="popup('reportByinvoice.jsp?invoice=<%=item.getNo()%>&cus_id=<%=item.getUIcus()%>');"></button> 						
						</td>
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