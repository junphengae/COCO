<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
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

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการขอจัดซื้อ</title>
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

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(25);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

session.setAttribute("PR_SEARCH", paramList);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("PR_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("PR_SEARCH_PAGE")));
}

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("PR_SEARCH_PAGE", page_);
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
					<button class="btn_box" onclick="javascript: history.back();">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 center txt_center">
						<form style="margin: 0; padding: 0;" action="pr_list.jsp" id="search" method="get">
							สถานะ: 
							<bmp:ComboBox name="status" styleClass="txt_box s150" listData="<%=PurchaseRequest.statusDropdown()%>" value="<%=status%>">
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
					
					<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"pr_list.jsp",paramList)%></div>
					<div class="clear"></div>
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="80">วันที่สร้าง</th>
								<th valign="top" align="left" width="240">ชื่อสินค้า</th>
								<th valign="top" align="right" width="60">ราคาที่สั่ง</th>
								<th valign="top" align="right" width="100">จำนวนที่สั่ง</th>
								<th valign="top" align="left" width="160">ตัวแทนจำหน่าย</th>
								<th valign="top" align="center" width="60">สถานะ</th>
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
							<tr valign="top">
								<td align="center"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
								<td><div class="thickbox pointer" lang="../info/inv_master_info.jsp?width=800&height=380&mat_code=<%=entity.getMat_code()%>" title="ข้อมูลสินค้า"><%=master.getDescription()%></div></td>
								<td align="right"><%=entity.getOrder_price()%></td>
								<td align="right">
									<%=Money.money(entity.getOrder_qty())%> <%=master.getStd_unit()%><br>
									(<%=Money.divide(entity.getOrder_qty(), master.getUnit_pack())%> <%=master.getDes_unit()%>)
								</td>
								<td align="left"><div class="thickbox pointer" lang="../info/vendor_info.jsp?width=400&height=320&vendor_id=<%=entity.getVendor_id()%>&mat_code=<%=entity.getMat_code()%>" title="ข้อมูลตัวแทนจำหน่าย"><%=v.getVendor_name()%></div></td>
								<td align="center"><%=PurchaseRequest.status(entity.getStatus())%></td>
								<td align="center">
									<a class="btn_report thickbox" href="po_info_detail.jsp?mat_code=<%=entity.getMat_code()%>&po=<%=entity.getPo()%>" title="รายงาน"></a>
									<%
									if (entity.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_ORDER)){
									%>
									<a class="btn_edit thickbox" title="แก้ไขการขอจัดซื้อ" href="pr_update.jsp?mat_code=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&width=700"></a>
									<a class="btn_drop thickbox" title="ยกเลิกการขอจัดซื้อ" href="pr_cancel.jsp?mat_code=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&width=450&height=250"></a>
									<%} else if(entity.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_MD_APPROVED)){%>
									<a class="btn_drop thickbox" title="ยกเลิกการขอจัดซื้อ" href="pr_cancel.jsp?mat_code=<%=entity.getMat_code()%>&id=<%=entity.getId()%>&width=450&height=250"></a>
									<%}%>
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