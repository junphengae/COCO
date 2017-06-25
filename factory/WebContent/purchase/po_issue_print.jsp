<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
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
<script src="../js/jquery.metadata.js" type="text/javascript"></script>
<script src="../js/jquery.validate.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/number.js" type="text/javascript"></script>

<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.datepicker.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
String po = WebUtils.getReqString(request, "po");
PurchaseOrder PO = PurchaseOrder.select(po);
Vendor vendor = PO.getUIVendor();
Iterator ite = PO.getUIOrderList().iterator();
%>
<title>สร้างใบสั่งซื้อ</title>
<style type="text/css">
.po_head table{border-collapse: collapse; width: 100%;}
.po_head table tr{border: 1px solid #111;}
.po_head table td{padding: 4px 3px;}
a.txt_red:hover{color: #cc0000;}
</style>

<script type="text/javascript">
$(function(){
	$('#btn_print').click(function(){
		var url = 'po_print.jsp?po=<%=po%>';
		window.open(url,'_blank').focus();
		//window.location=url;
	});
});
</script>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการใบสั่งซื้อ [PO] | สร้างใบสั่งซื้อ</div>
				<div class="right m_right10">
					<button class="btn_box" onclick="javascript: window.location='po_list.jsp';">ไปหน้าแสดงรายการใบสั่งซื้อ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<form id="issue_po_form" onsubmit="return false;">
					
						<div class="po_head s350 right">
							<table>
								<tr>
									<td>เลขที่ (P/O. NO.) </td><td>: <%=PO.getPo()%></td>
								</tr>
								<tr>
									<td>วันที่ (Date) </td><td>: <%=WebUtils.getDateValue(PO.getApprove_date())%></td>
								</tr>
								<tr>
									<td>กำหนดส่ง (Delivery Date) </td><td>: <%=(PO.getDelivery_date()==null)?"":WebUtils.getDateValue(PO.getDelivery_date())%></td>
								</tr>
								<tr>
									<td>เครดิต (Credit) </td><td>: <span id="view_vendor_credit"><%=vendor.getVendor_credit() %></span></td>
								</tr>
							</table>
						</div>
						<div class="clear"></div>
						
						<div class="vendor_info b_1 m_top5 pd_5">
							<table width="98%" class="center">
								<tr height="24" valign="top">
									<td width="120">บริษัท (Order To)</td>
									<td>: <span id="view_vendor_name"><%=vendor.getVendor_name() %></span></td>
								</tr>
								<tr height="24" valign="top">
									<td>ถึง (ATTN)</td>
									<td>: <span id="view_vendor_attn"><%=vendor.getVendor_contact()%></span></td>
								</tr>
								<tr height="24" valign="top">
									<td>โทร (TEL)</td>
									<td> 
										<div class="left s350">: <span id="view_vendor_phone"><%=vendor.getVendor_phone() %></span></div>
										<div class="left">แฟกซ์ (FAX) : <span id="view_vendor_fax"><%=vendor.getVendor_fax() %></span></div>
										<div class="clear"></div>
									</td>
								</tr>
							</table>
						</div>
						
						<div class="dot_line m_top10"></div>
						
						<div class="m_top5 center">
							
							<table class="bg-image s930">
								<thead>
									<tr>
										<th align="center" width="6%">ที่<br>(No.)</th>
										<th valign="top" align="center" width="44%">รายการสินค้า<br>(Description)</th>
										<th valign="top" align="center" width="15%">จำนวน<br>(Quantity)</th>
										<th valign="top" align="center" width="20%">ราคาต่อหน่วย<br>(Unit Price)</th>
										<th valign="top" align="center" width="15%">จำนวนเงิน<br>(Amount)</th>
									</tr>
								</thead>
								<tbody>
								<%
									int i = 1;
									String gross_amount = "0";
									while(ite.hasNext()) {
										PurchaseRequest entity = (PurchaseRequest) ite.next();
										InventoryMaster master = entity.getUIInvMaster();
										
										String amt = Money.multiple(entity.getOrder_qty(), entity.getOrder_price());
										gross_amount = Money.add(gross_amount, amt);
										String amount =  Money.money(amt);
								%>
									<tr id="tr_<%=entity.getId()%>" valign="middle">
										<td align="center"><%=i++%></td>
										<td>
											<div class="thickbox pointer" lang="../info/inv_master_info.jsp?width=800&height=380&mat_code=<%=entity.getMat_code()%>" title="ข้อมูลสินค้า"><%=master.getDescription()%></div>
										</td>
										<td align="center"><%=entity.getOrder_qty()%> <%=master.getStd_unit()%></td>
										<td align="center"><%=entity.getOrder_price()%></td>
										<td align="right"><%=amount%></td>
									</tr>
								<%
									}
								%>
									<tr>
										<td colspan="4" align="right">รวมราคา (Gross Amount)</td>
										<td align="right"><span id="span_gross_amount"><%=Money.money(gross_amount) %></span></td>
									</tr>
									<tr>
										<td colspan="4" align="right">ส่วนลด (Discount) <%=PO.getDiscount()%> %</td>
										<td align="right"><%=Money.money(Money.divide(Money.multiple(gross_amount,PO.getDiscount()),"100"))%></td>
									</tr>
									<tr>
										<td colspan="4" align="right">หรือ ส่วนลด (Discount) เป็นบาท</td>
										<td align="right"><%=Money.money(PO.getDiscount_pc())%></td>
									</tr>
									<tr>
										<td colspan="4" align="right">รวมราคาหลังหักส่วนลด (Net Amount)</td>
										<td align="right"><%=Money.money(Money.subtract(Money.discount(gross_amount,PO.getDiscount()),PO.getDiscount_pc()))%></td>
									</tr>
									<tr>
										<td colspan="4" align="right">ภาษีมูลค่าเพิ่ม (VAT) <%=PO.getVat()%> %</td>
										<td align="right"><%=PO.getVat_amount()%></td>
									</tr>
									<tr class="txt_bold">
										<td colspan="4" align="right">รวมเป็นเงิน (Grand Total)</td>
										<td align="right"><%=Money.money(PO.getGrand_total())%></td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="center right m_top5 pd_5">
							<div class="left">หมายเหตุ : </div> 
							<div class="left m_left5"><%=PO.getNote().replaceAll("\n", "<br>").replaceAll(" ", "&nbsp;")%></div>
							<div class="clear"></div>
						</div>
						<div class="clear"></div>
					</form>
					
					<div class="center txt_center m_top5">
						<button class="btn_box btn_confirm" id="btn_print">พิมพ์ใบสั่งซื้อ</button>
					</div>
				</div>
			
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>