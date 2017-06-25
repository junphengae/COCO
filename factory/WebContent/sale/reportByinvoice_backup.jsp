<%@page import="com.sun.xml.internal.stream.Entity"%>
<%@page import="com.bitmap.bean.sale.Detailinv"%>
<%@page import="com.bitmap.bean.logistic.N_number"%>
<%@page import="com.bitmap.bean.logistic.P_number"%>
<%@page import="com.bitmap.bean.logistic.Detail_send"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.bitmap.barcode.Barcode128"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.sale.SaleQt"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.bean.util.StatusUtil"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Iterator"%>
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
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/popup.js" type="text/javascript"></script>

<link href="../css/theme_print.css" rel="stylesheet" type="text/css" media="all">



<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Viewer</title>
<%
String invoice = WebUtils.getReqString(request, "invoice");
String cus_id = WebUtils.getReqString(request, "cus_id");

List paramList = new ArrayList();
paramList.add(new String[]{"invoice",invoice});
session.setAttribute("SO_SEARCH", paramList);

List list = SaleOrderItem.selectallitemByinvoice(paramList);


Customer cus = new Customer();
cus = Customer.select(cus_id);


SaleOrderItem dd = new SaleOrderItem();
dd = SaleOrderItem.fininv(invoice,"inv");

Detailinv inv = new Detailinv();
inv.setNo(invoice);
inv.setType_inv(Detailinv.STATUS_INV);
Detailinv.select(inv);

%>

<script type="text/javascript">
function setPrint(){
	setTimeout('window.print()',1500);
	
	 /* $("#Print_PDF").click(function(){ 
       alert("iReport");
	 });  */		
	 //setTimeout('window.close()',2000);
	// alert("iReport");
	
}
</script>


</head>
<body  style="background-color: #CFD1BD; color: #EEEEEE; font-family: 'Trebuchet MS','Helvetica','Arial','Verdana','sans-serif'; font-size: 90%;" onload="setPrint();">
		<div class="body_content">
			<div class="content_head">
				<div class="left" style="color: white; font-size: 20px;"><h3>Report Viewer</h3></div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">	
						<div class="detail_wrap s200 right"  >										
						<div class="txt_left m_left5" style=" border:1px dotted #555555;border-left: none;border-right: none;border-top: none; ">เลขที่ : <%=(inv.getType_vat().equalsIgnoreCase(Detailinv.STATUS_NO_VAT)?"novat.":"vat.") + invoice %>  </div>
						 <div class="clear"></div>
						<div class="txt_left m_left5" style=" border:1px dotted #555555; border-left: none;border-right: none;border-top: none; ">วันที่ : 
						<%=WebUtils.getDateValue(inv.getCreate_date())%>
						</div>
						</div>
					<div class="clear"></div>
					<div class="dot_line m_top5"></div>
					<div class="left s40">ลูกค้า</div>
					<div class="left">: <%=cus.getCus_name()%></div>
					<div class="clear"></div>
					<div class="left s40">ที่อยู่</div>
					<div class="left">:<%=cus.getCus_address()%></div>
					<div class="clear"></div>	
					<div class="dot_line m_top5"></div>				
					<table class="bg-image " >
										
						    <thead>
								<tr>
								<th valign="top" align="center" width="5%">No.</th>
								<th valign="top" align="center" width="30%">รายการสินค้า<br>(Description)</th>
								<th valign="top" align="center" width="10%">จำนวน<br>(Quantity)</th>
								<th valign="top" align="center" width="15%">บรรจุภัณฑ์</th>
								<th valign="top" align="center" width="10%">ราคาต่อหน่วย<br>(Unit Price)</th>
								<th valign="top" align="center" width="10%">ส่วนลด<br>(Discount)</th>
								<th valign="top" align="center" width="10%">หลังลด<br>(All Amount)</th>								
							</tr>		
							</thead>
							
						<tbody>
								<%
								int i = 0;
								String aa = "";
								Iterator ite = list.iterator();
								while (ite.hasNext()){
									i++;
									SaleOrderItem entity = (SaleOrderItem) ite.next();
									
								%>		
								<tr>
								<td width="10%" align="center"><%=i%></td>
								<td width="50%" align="left"><%=(entity.getItem_type().equalsIgnoreCase("s")?entity.getUIMatName():entity.getUIPacName())%></td>
								<td width="10%" align="center"><%=entity.getItem_qty()%></td>	
								<td width="10%" align="center"><%=(entity.getItem_type().equalsIgnoreCase("s")?entity.getUIMatType():"ชุด")%></td>
								<td width="10%" align="center"><%=(entity.getItem_type().equalsIgnoreCase("s")?entity.getUnit_price():Money.divide(entity.getUnit_price(),entity.getItem_qty()))%></td>
								<td width="10%" align="center"><%=(entity.getDiscount().equalsIgnoreCase("")?"0":entity.getDiscount())%></td>
								<td width="10%" align="center">
								<%
									String discnt = "0";
									if (entity.getDiscount().length() > 0) {
										discnt = entity.getDiscount();
									}	
									if(entity.getItem_type().equalsIgnoreCase("s")){
										String discount = Money.discount(Money.multiple(entity.getItem_qty(),entity.getUnit_price()),discnt);
										%><%=Money.money(discount)%><%
									}else{
										%><%=Money.discount(entity.getUnit_price(),discnt)%><%
									}
								%>	
								</td>
								</tr>
								<%
								aa = entity.getUISumAll();
								}
								String vat = "0";
								%>
								
								<tr>
								<td colspan="6" align="right">รวมเงิน</td>
								<td align="center"><%=Money.money(aa)%></td>
								</tr>
								<tr>
								<td colspan="4" rowspan="2" align="left" style=" border:1px dotted #555555; ">ใบเสร็จรับเงินจะเสร็จสมบูรณ์เมื่อเรียกเก็บเงินตามเช็คได้เรียบร้อยแล้ว<br>
								บริษัทจะคิดดอกเบี้ย 1.5% ต่อเดือน เมื่อเกินกำหนดชำระ<br>
								หมายเหตุ : </td>
								<td align="center" colspan="2">ภาษีมูลค่าเพิ่ม<br>(Vat 7%)</td>
								<td align="center">
								<% if(inv.getType_vat().equalsIgnoreCase(Detailinv.STATUS_VAT)){
									vat = Money.divide(Money.multiple("7",aa),"100");
									%><%=Money.money(vat)%>
								<%}else{%>-<%} %>
								</td>					
								</tr>
								
								<tr style=" border:1px dotted #555555; ">
								<td align="center" colspan="2" style=" border:1px dotted #555555; ">ยอดสุทธิ<br>(Net Total)</td>
								<td align="center"><%=Money.money(Money.add(vat,aa))%></td>
								</tr>
								
								
								</tbody>
								<%-- <tfoot>
								<tr>
									<td colspan="8" align="center" height="35px" valign="bottom">
										<input type="button" id="close_form" class="btn_box btn_warn" value="Close Display" >
										<input type="button" id="Print_PDF" class="btn_box btn_confirm" value="พิมพ์รายงาน" go="../ReportInvoiceServlet?invoice=<%=invoice %>&cus_id=<%=cus_id %>" >	
									</td>
								</tr>
								</tfoot> --%>
					</table>
							
				</div>

		</div>
<%-- <form action="../ReportInvoiceServlet?invoice=<%=invoice %>&cus_id=<%=cus_id %>" method="get" id="pdf" target="_blank"></form> --%>

<script type="text/javascript">

			$(function(){
				$("#close_form").click(function(){ 
			       	window.close(); 
				}); 
				
				$("#Print_PDF").click(function(){ 
					window.open($(this).attr("go") );
				});
				
			});
</script>
</body>
</html>