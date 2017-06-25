<%@page import="com.bitmap.bean.sale.Detailinv"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.logistic.LogisSend"%>
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
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/jquery.metadata.js" type="text/javascript"></script>
<script src="../js/jquery.validate.js" type="text/javascript"></script>

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ออกแผน</title>
<%

String inv = WebUtils.getReqString(request, "inv");
String type_inv = WebUtils.getReqString(request, "type_inv");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"inv",inv});
paramList.add(new String[]{"type_inv",type_inv});

session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = LogisSend.selectWithCTRL(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">ออกแผน</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 center txt_center">
						<form style="margin: 0; padding: 0;" action="sale_delivery.jsp" id="search" method="get">
							หมายเลข:<input type="text" class="txt_box" name="inv" value="<%=inv%>">
							ประเภท: 
							<bmp:ComboBox name="type_inv" styleClass="txt_box s150" value="<%=type_inv%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
								<bmp:option value="10" text="ใบ invoice"></bmp:option>
								<bmp:option value="20" text="ใบส่งของชั่วคราว"></bmp:option>
							</bmp:ComboBox>
							<br><br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
						</form>
					</div>
					
					<div class="dot_line m_top5"></div>
					
					
					<div class="clear"></div>
					
					<!-- next page -->  
					<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"sale_delivery.jsp",paramList)%></div>
					<div class="clear"></div>
					<!-- next page  -->
				
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="5%">No.</th>
								<th valign="top" align="center" width="10%">ประเภท</th>
								<th valign="top" align="center" width="20%">ลูกค้า</th>
								<th valign="top" align="center" width="20%">รายการสินค้า</th>
								<th valign="top" align="center" width="10%">จำนวนทั้งหมด</th>
								<th valign="top" align="center" width="5%">จำนวนที่ส่ง</th>
								<th valign="top" align="center" width="5%">ส่งไปแล้ว</th>
								<th valign="top" align="center" width="10%">วันที่ส่ง</th>
								<th valign="top" align="center" width="10%">สถานะ</th>
								<th align="center" width="5%"></th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								LogisSend entity = (LogisSend) ite.next();
								has = false;
						%>
							<tr>
								<td align="right"><%=entity.getInv()%></td>
								<td align="center"><%=LogisSend.statusInv(entity.getType_inv())%></td>
								<td align="left"><%=entity.getUIorder().getUICustomer().getCus_name()%></td>
								<td align="center"><%=entity.getUImatname()%></td>
								<td align="center"><%=entity.getQty_all()%></td>
								<td align="center"><%=entity.getQty()%></td>
								<td align="center"><%=LogisSend.sumQtyAndStatus(entity.getItem_run(),entity.getMat_code())%></td>
								<td align="center"><%=WebUtils.getDateValue(entity.getSend_date())%></td>
								<td align="center"><%=LogisSend.statusSend(entity.getStatus())%></td>
								<td align="center">
									<% if(entity.getStatus().equalsIgnoreCase(LogisSend.STATUS_WAIT) || entity.getStatus().equalsIgnoreCase(LogisSend.STATUS_RESEND) ){ %>
									<input type="button" class="btn_box thickbox btn_confirm" title="แก้ไขจำนวนส่งของ" lang="sale_delivery_edit_qty.jsp?width=500&height=250&id_run=<%=entity.getId_run()%>" value="<%=(entity.getStatus().equalsIgnoreCase(LogisSend.STATUS_WAIT)?"ออกแผนส่ง":"เพิ่ม") %>" >					
									<%} %>
								</td>
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการออกแผน ---- </td></tr>
						<%
							}
						%>
						</tbody>
					</table>
					
				</div>
				<div class="wrap_desc">
				- หน้าจอนี้ใช้แสดงรายการการจัดส่งของ โดยพนักงานขายสามารถกำหนดจำนวนและวันที่ส่งของให้ลุกค้าได้
				</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>

</body>
</html>