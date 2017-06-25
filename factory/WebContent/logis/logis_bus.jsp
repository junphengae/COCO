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

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>จัดการคิวรถ</title>
<%
String run = WebUtils.getReqString(request, "run");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"run",run});

session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = SendProduct.selectWithCTRL(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">จัดการคิวรถ</div>
				<div class="right m_right10">
					<button class="btn_box btn_confirm" onclick="window.location='logis_add_bus.jsp';">สร้างคิวรถ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 center txt_center">
						<form style="margin: 0; padding: 0;" action="logis_bus.jsp" id="search" method="get">
							ค้นหาจากเลขที่คิวรถ : <input type="text" name="run" id="run" value="<%=run%>" class="txt_box s200" autocomplete="off"> 
							<br><br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
						</form>
					</div>
					
					<div class="dot_line m_top5"></div>
					
					
					<div class="clear"></div>
					
					<!-- next page -->  
					<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"logis_bus.jsp",paramList)%></div>
					<div class="clear"></div>
					<!-- next page  -->
				
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="10">เลขที่คิวรถ</th>
								<th valign="top" align="center" width="30%">บริษัทขนส่ง</th>
								<th valign="top" align="center" width="20%">ชื่อคนขับ</th>
								<th valign="top" align="center" width="10%">กำหนดส่ง</th>
								<th valign="top" align="center" width="20%">สถานะ</th>
								<th align="center" width="10%"></th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								SendProduct entity = (SendProduct) ite.next();
								Busstation bus = entity.getUIBus();
								has = false;
						%>
							<tr>
								<td valign="top" align="right"><%=entity.getRun()%></td>
								<td valign="top" align="center"><%=bus.getCompany()%></td>
								<td valign="top" align="center"><%=bus.getDriver()%></td>
								<td valign="top" align="center"><%=WebUtils.getDateValue(entity.getSend_date())%></td>
								<td valign="top" align="center"><%=SendProduct.status(entity.getStatus())%></td>
								<td valign="top" align="center">
								<% if(entity.getStatus().equalsIgnoreCase("00")){ %>
								<button class="btn_box btn_confirm" onclick="window.location='logis_send_product.jsp?qid=<%=entity.getQid()%>&run=<%=entity.getRun()%>'">เลือก</button>
								<%}else{%>
								<button class="btn_box" onclick="window.location='logis_send_product.jsp?qid=<%=entity.getQid()%>&run=<%=entity.getRun()%>'">view</button>
								<%} %>
								</td>
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการจัดส่งสินค้า ---- </td></tr>
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