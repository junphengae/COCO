<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
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
<script src="../js/popup.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการขอจัดซื้อ (รออนุมัติจากผู้บริหาร)</title>
<%
String vendor_id = WebUtils.getReqString(request, "vendor_id");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"status",PurchaseRequest.STATUS_ORDER});
paramList.add(new String[]{"vendor_id",vendor_id});

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = PurchaseRequest.selectWithCTRL(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการขอจัดซื้อ</div>
				<div class="right m_right10">
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 center txt_center">
						<form style="margin: 0; padding: 0;" action="pr_list4apv.jsp" id="search" method="get">
							แสดงผลตามตัวแทนจำหน่าย:
							<bmp:ComboBox name="vendor_id" styleClass="txt_box s200" listData="<%=PurchaseRequest.vendorDropdown4PR()%>" value="<%=vendor_id%>" onChange="$('#search').submit();">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
							</bmp:ComboBox>
						</form>
					</div>
					
					<div class="dot_line m_top5"></div>
					
					<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"pr_list4apv.jsp",paramList)%></div>
					<div class="clear"></div>
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="80">วันที่สร้าง</th>
								<th valign="top" align="left" width="190">ชื่อสินค้า</th>
								<th valign="top" align="right" width="130">ราคาที่สั่ง</th>
								<th valign="top" align="right" width="120">จำนวนที่สั่ง</th>
								<th valign="top" align="left" width="150">ตัวแทนจำหน่าย</th>
								<th align="center" width=""></th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								PurchaseRequest entity = (PurchaseRequest) ite.next();
								InventoryMaster master = entity.getUIInvMaster();
								InventoryMasterVendor mVendor = entity.getUIInvVendor();
								Vendor v = mVendor.getUIVendor();
								has = false;
						%>
							<tr id="tr_<%=entity.getId()%>">
								<td align="center"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
								<td><div class="thickbox pointer" lang="../info/inv_master_info.jsp?width=850&height=400&mat_code=<%=entity.getMat_code()%>" title="ข้อมูลสินค้า : <%=master.getDescription()%>"><%=master.getDescription()%></div></td>
								<td align="right"><%=entity.getOrder_price() + " ฿/" + master.getStd_unit() + " <br>" + Money.money(Money.multiple(entity.getOrder_price(), master.getUnit_pack())) + " ฿/" + master.getDes_unit()%></td>
								<td align="right"><%=Money.money(entity.getOrder_qty()) + " " + master.getStd_unit() + " <br> (" + Money.divide(entity.getOrder_qty(), master.getUnit_pack()) + " " + master.getDes_unit() + ")"%></td>
								<td align="left"><div class="thickbox pointer" lang="../info/vendor_info.jsp?width=400&height=320&vendor_id=<%=entity.getVendor_id()%>&mat_code=<%=entity.getMat_code()%>" title="ข้อมูลตัวแทนจำหน่าย"><%=v.getVendor_name()%></div></td>
								<td align="center">
									<%
									if (entity.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_ORDER)){
									%>
									<button class="btn_box thickbox" lang="pr_list4apv_report.jsp?mat_code=<%=entity.getMat_code()%>&width=850&height=500" title="รายงานย้อนหลัง 3 เดือน : <%=entity.getMat_code()%> - <%=master.getDescription()%>">รายงาน</button>
									<input type="button" class="btn_box btn_confirm thickbox" value="อนุมัติ" title="อนุมัติการขอจัดซื้อ" lang="pr_approve.jsp?mat_code=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&width=450&height=300">
									<%} %>
								</td>
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="7" align="center">---- ไม่พบข้อมูลการขอจัดซื้อสินค้า ---- </td></tr>
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