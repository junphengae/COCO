<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="java.util.Iterator"%>
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
<title>รายการใบสั่งซื้อ [PO List]</title>
<%
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");
String vendor_id = WebUtils.getReqString(request, "vendor_id");
String status = WebUtils.getReqString(request, "status");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
if (year.length() == 0) {
	paramList.add(new String[]{"year",DBUtility.getCurrentYear() + ""});
} else {
	paramList.add(new String[]{"year",year});
}
paramList.add(new String[]{"vendor_id",vendor_id});
paramList.add(new String[]{"status",status});
paramList.add(new String[]{"month",month});

session.setAttribute("PO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(25);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = PurchaseOrder.selectWithCTRL(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการใบสั่งซื้อ [PO]</div>
				<div class="right m_right10">
					<button class="btn_box" onclick="window.location='pr_list.jsp';">รายการขอจัดซื้อ</button>
					<button class="btn_box btn_confirm" onclick="window.location='po_issue.jsp';">สร้างใบสั่งซื้อ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 center txt_center">
						<form style="margin: 0; padding: 0;" action="po_list.jsp" id="search" method="get">
							สถานะ: 
							<bmp:ComboBox name="status" styleClass="txt_box s150" listData="<%=PurchaseRequest.statusDropdown4PO()%>" value="<%=status%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
							</bmp:ComboBox>
							&nbsp;&nbsp;
							
							ตัวแทนจำหน่าย:
							<bmp:ComboBox name="vendor_id" styleClass="txt_box s200" listData="<%=PurchaseRequest.vendorDropdown()%>" value="<%=vendor_id%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
							</bmp:ComboBox>
							&nbsp;&nbsp;
							
							เดือน/ปี: 
							<bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month%>">
								<bmp:option value="" text="--- ทุกเดือน ---"></bmp:option>
							</bmp:ComboBox>
							<bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="<%=(year.length()>0)?year:null%>"></bmp:ComboBox>
							
							<br><br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
						</form>
					</div>
					
					<div class="dot_line m_top5"></div>
					
					<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"po_list.jsp",paramList)%></div>
					<div class="clear"></div>
					
					<table class="bg-image s900">
						<thead>
							<tr>
								<th valign="top" align="left" width="10%">เลขที่ PO</th>
								<th valign="top" align="center" width="10%">วันที่ออก</th>
								<th valign="top" align="center" width="10%">กำหนดส่ง</th>
								<th valign="top" align="center" width="10%">วันที่ปิด</th>
								<th valign="top" align="right" width="15%">ยอดเงิน</th>
								<th valign="top" align="left" width="26%">ตัวแทนจำหน่าย</th>
								<th valign="top" align="center" width="12%">สถานะ</th>
								<th align="center" width="7%"></th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								PurchaseOrder entity = (PurchaseOrder) ite.next();
								Vendor v = entity.getUIVendor();
								has = false;
						%>
							<tr>
								<td><%=entity.getPo()%></td>
								<td><%=WebUtils.getDateValue(entity.getApprove_date())%></td>
								<td><%=WebUtils.getDateValue(entity.getDelivery_date())%></td>
								<td><%=WebUtils.getDateValue(entity.getReceive_date())%></td>
								<td align="right"><%=Money.money(entity.getGrand_total())%></td>
								<td align="left"><div class="thickbox pointer" lang="../info/vendor_info.jsp?width=400&height=320&vendor_id=<%=entity.getVendor_id()%>" title="ข้อมูลตัวแทนจำหน่าย"><%=v.getVendor_name()%></div></td>
								<td align="center"><%=PurchaseRequest.status(entity.getStatus())%></td>
								<td align="center">
									<input type="button" class="btn_box" value="ดู" title="ดูรายละเอียดใบสั่งซื้อ" onclick="javascript: window.location='po_info.jsp?po=<%=entity.getPo()%>';">
								</td>
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการใบสั่งซื้อสินค้า ---- </td></tr>
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