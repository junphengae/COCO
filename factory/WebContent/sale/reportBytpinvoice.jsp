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
dd = SaleOrderItem.fininv(invoice,"NOINV");

Detailinv inv = new Detailinv();
inv.setNo(invoice);
inv.setType_inv(Detailinv.STATUS_TEMP);
Detailinv.select(inv);
%>



<style type="text/css">
.tb{border-collapse: collapse;}
.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}
</style>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/theme_print_horizon.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<script type="text/javascript">
function setPrint(){
	setTimeout('window.print()',1000); setTimeout('window.close()',2000);
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Viewer</title>


</head>
<body style="font-size: 18px;" onload="setPrint();">
<div class="wrap_print">
	<div style="margin-top: 80px;"></div>
				<div class="txt_center" style="font-size: 22px;"><strong>ใบส่งของชั่วคราว</strong></div>
				<div class="txt_center" style="font-size: 22px;"><strong></strong></div>
				<div class="clear"></div>
		
				<div class="right">
					<fieldset class="right s200" style="border-color: black;">
						<div class="txt_left m_left5">เลขที่ : <%="tmp." + invoice %>  </div>
						<div class="clear"></div>
						<div class="txt_left m_left5">วันที่ : 
						<%=WebUtils.getDateValue(inv.getCreate_date())%>
						</div>
						<div class="clear"></div>
					</fieldset>
						
				</div>
				<div class="clear"></div>
				<div class="left s60">ลูกค้า</div>
				<div class="left">: <%=cus.getCus_name()%><br>
									<%=cus.getCus_address()%>
				</div>
				<div class="clear"></div>
				<br>
				<table class="tb" width="100%">
							<thead>
								<tr>
								<th valign="top" align="center" width="5%">เลขที่<br>(No.)</th>
								<th valign="top" align="center" width="30%">รายการสินค้า<br>(Description)</th>
								<th valign="top" align="center" width="10%">จำนวน<br>(Quantity)</th>
								<th valign="top" align="center" width="15%">บรรจุภัณฑ์</th>
								<th valign="top" align="center" width="10%">ราคาต่อหน่วย<br>(Unit Price)</th>
								<th valign="top" align="center" width="10%">จำนวนเงิน<br>(Amount)</th>								
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
								<td align="center"><%=i%></td>
								<td align="left"><%=(entity.getItem_type().equalsIgnoreCase("s")?entity.getUIMatName():entity.getUIPacName())%></td>
								<td align="center"><%=entity.getItem_qty()%></td>	
								<td align="center"><%=(entity.getItem_type().equalsIgnoreCase("s")?entity.getUIMatType():"ชุด")%></td>
								<td align="center"><%=(entity.getItem_type().equalsIgnoreCase("s")?Money.money(entity.getUnit_price()):Money.divide(entity.getUnit_price(),entity.getItem_qty()))%></td>
								<td align="center">
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
								}
								%>
								</tbody>							
							</table>	
							
							<div class="m_top50 m_left100">
							<div class="left txt_center s200">
								<div class="">......................................................<br>ผู้รับสินค้า</div>
								<div class="">(............................................................)</div>
							</div>
							
							<div class="left m_left50 txt_center s200">
								<div class="">......................................................<br>ผู้ส่งสินค้า</div>
								<div class="">(............................................................)</div>
							</div>
							
							
							<div class="left txt_center m_left70 s200">
								<div class=" ">......................................................<br>บริษัท วี.บราเดอร์ อินดัสตรี้ จำกัด</div>
								<div class="">(............................................................)</div>
								<div class="">(............................................................)</div>
							</div>
							<div class="clear"></div>
						</div>		
</div>
</body>
</html>