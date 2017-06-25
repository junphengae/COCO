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
<title>รายการใบเสนอราคา</title>
<%
String status = WebUtils.getReqString(request, "status");
String order_type = WebUtils.getReqString(request, "order_type");
String cus_name = WebUtils.getReqString(request, "cus_name");
String create_by = WebUtils.getReqString(request, "create_by");	
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"status",status});
paramList.add(new String[]{"order_type",order_type});
paramList.add(new String[]{"create_by",create_by});
paramList.add(new String[]{"cus_name",cus_name});

session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = SaleOrder.select(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการใบเสนอราคา</div>

			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 txt_center">
						<form style="margin: 0; padding: 0;" action="sale_qt.jsp" id="search" method="get">
							ประเภท: 
							<bmp:ComboBox name="order_type" styleClass="txt_box s150" listData="<%=SaleOrder.typeDropDown()%>" value="<%=order_type%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
							</bmp:ComboBox>&nbsp;&nbsp;
							สถานะ: 
							<bmp:ComboBox name="status" styleClass="txt_box s150" value="<%=status%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
								<bmp:option value="20" text="วางแผนแล้ว"></bmp:option>
								<bmp:option value="40" text="รออนุมัติใบเสนอราคา"></bmp:option>
							</bmp:ComboBox>
							<br>
							ลูกค้า :
							<input type="text" class="txt_box" name="cus_name" value="<%=cus_name%>">
							<% List list = Personal.listDropdown("0010");%>
							ชื่อผู้ออก:
							<bmp:ComboBox name="create_by" styleClass="txt_box s150" listData="<%=list%>" value="<%=create_by%>">
								<bmp:option value="" text="---- เลือกทั้งหมด ----"></bmp:option>
							</bmp:ComboBox>	
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>						
						</form>		
					</div>
					
					<div class="dot_line m_top5"></div>
					
					<!-- next page -->  
					<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"sale_qt.jsp",paramList)%></div>
					<div class="clear"></div>
					<!-- next page  -->

					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="15%">Order No.</th>
								<th valign="top" align="center" width="10%">PO</th>
								<th valign="top" align="center" width="20%">ผู้ออก</th>
								<th valign="top" align="center" width="30%">ลูกค้า</th>
								<th valign="top" align="center" width="15%">ประเภท</th>
								<th valign="top" align="center" width="15%">สถานะ</th>
								<th align="center" width="80"></th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							
							while(ite.hasNext()) {
								SaleOrder entity = (SaleOrder) ite.next();
								Customer cus = entity.getUICustomer();
								Personal sale = entity.getUISale();
								has = false;
						%>
							<tr>
								<td align="right"><%=entity.getOrder_id()%></td>
								<td align="right"><%=entity.getPo()%></td>
								<td align="center"><%=sale.getName() + " " + sale.getSurname()%></td>
								<td align="center"><%=cus.getCus_name()%></td>
								<td align="center"><%=SaleOrder.type(entity.getOrder_type())%></td>
								<td align="center"><%=SaleOrder.status(entity.getStatus())%></td>
								<td align="center">	
								<% if(entity.getStatus().equalsIgnoreCase(SaleOrder.STATUS_PLAN_SUBMIT)){ %>
								<button class="btn_box btn_confirm" onclick="window.location='sale_order_info.jsp?order_id=<%=entity.getOrder_id()%>&cus_id=<%=entity.getCus_id()%>';">สร้าง</button>
								<%}else if(entity.getStatus().equalsIgnoreCase(SaleOrder.STATUS_SEND_QT)){ %>
								<button class="btn_box btn_confirm" onclick="window.location='sale_order_info.jsp?order_id=<%=entity.getOrder_id()%>&cus_id=<%=entity.getCus_id()%>';">แก้ไข</button>
								<%}else{ %>
								<button class="btn_box" onclick="window.location='sale_order_info.jsp?order_id=<%=entity.getOrder_id()%>&cus_id=<%=entity.getCus_id()%>';">ดู</button>
								<%} %>						
								</td>
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการใบเสนอราคา ---- </td></tr>
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