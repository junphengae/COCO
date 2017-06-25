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
String order_id = WebUtils.getReqString(request, "order_id");
String cus_id = WebUtils.getReqString(request, "cus_id");
String qt_id = WebUtils.getReqString(request, "qt_id");

SaleOrder order = SaleOrder.selectByID(order_id);
SaleQt qt = SaleQt.selectQt_id(qt_id);
Customer cus = Customer.select(cus_id);

Personal sale = Personal.select(order.getSale_by());
Personal createDoc = Personal.select(order.getCreate_by());

Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_barcode"), qt_id);
%>



<style type="text/css">
.tb{border-collapse: collapse;}
.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}
</style>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/theme_print.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<script type="text/javascript">
function setPrint(){
//	setTimeout('window.print()',1000); setTimeout('window.close()',2000);
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Viewer</title>


</head>
<body style="font-size: 18px;" onload="setPrint();">
<div class="wrap_print">
	<div style="margin-top: 80px;"></div>
				<div class="txt_center" style="font-size: 22px;"><strong>ใบเสนอราคา (QUOTATION)</strong></div>
				<div class="clear"></div>
		
				<div class="right">
					<div class="txt_center"><img src="../path_images/barcode/<%=qt_id%>.png"></div>
					เลขที่ <%=qt_id%> - วันที่ <%=WebUtils.getDateValue(qt.getCreate_date())%></div>
				<div class="clear"></div>
				
				<div class="left s60">เรียน</div>
				<div class="left">: <%=qt.getSend_by()%></div>
				<div class="clear"></div>
				
				<div class="left s60">ชื่อลูกค้า</div>
				<div class="left">: <%=cus.getCus_name()%></div>
				<div class="clear"></div>

				<div class="left s60">ที่อยู่</div>
				<div class="left">: <%=cus.getCus_address()%></div>
				<div class="clear"></div>
				
				<div class="left s100">ประเภทการขนส่ง</div>
				<div class="left s60">: <%=Customer.ship(cus.getCus_ship())%></div>
				<div class="clear"></div>
						
				<div class="left s60">Tel</div>
				<div class="left s150">: <%=cus.getCus_phone()%></div>
				<div class="left">Fax : <%=cus.getCus_fax()%></div>
				<div class="clear"></div>

				
				<div class="m_left60">ทางบริษัท ฯ ขอเสนอราคาสินค้ามายังท่านตามรายการ ดังต่อไปนี้</div>				
						<table class="tb" width="100%">
							<thead>
								<tr align="center">
									<td width="10%">เลขที่</td>
									<td width="40%">รายการสินค้า</td>
									<td>ขนาดบรรจุ</td>
									<td>จำนวน</td>
									<td>ราคาต่อหน่วย</td>
									<td>ส่วนลด</td>
									<td>ราคารวม</td>
								</tr>		
							</thead>
								
							<tbody>
								<%
								Iterator ite = SaleOrderItem.selectQt(order_id,qt_id).iterator();
								int i = 1;
								while (ite.hasNext()){
									SaleOrderItem itemOrder = (SaleOrderItem) ite.next();
									InventoryMaster mat = itemOrder.getUIMat();
									RDFormular fm = RDFormular.selectByMatCode(mat.getMat_code());
									Package pac = itemOrder.getUIPac();
									String type = itemOrder.getItem_type();

									if(itemOrder.getItem_type().equalsIgnoreCase("p")){
										HashMap<String, PackageItem> map = PackageItem.SumItem(pac.getPk_id());
										Iterator itePK = map.keySet().iterator();
								%>		
								<tr>
								<td valign="top" align="center">
									<%=i%>
								</td>
								<td valign="top" align="left" colspan="3">
									<%=pac.getName()%>
									<br>					
								<%
										while (itePK.hasNext()){
											PackageItem item = map.get((String)itePK.next()) ;
											
											
											%>- <span class="txt_16"><%=item.getUIMat().getDescription()%> จำนวน  <%=item.getQty()%> <%=item.getUIMat().getDes_unit()%></span><br>
										<%
										}
										%>
										<%=itemOrder.getRemark()%>
								</td>
	
								<td valign="top" align="right">
									<%=Money.money(pac.getPrice())%>
								</td>
								<td valign="top" align="right"><%=itemOrder.getDiscount()%>%</td>
								<td valign="top" align="right">
								<%
											String sum = "";
											String dis = itemOrder.getDiscount();
											if(itemOrder.getDiscount().equalsIgnoreCase("")){
												dis = "0";
											}
											sum = Money.divide(Money.multiple(itemOrder.getUnit_price(),dis),"100");
											%>
											<% sum = Money.money(Money.subtract(itemOrder.getUnit_price(),sum));%>
											<%=sum%>
								</td>
							</tr>
								<%
										
									}else{
										%>
										<tr>
											<td valign="top" align="center">
												<%=i%>
											</td>
											<td valign="top" align="left">
												<%=mat.getDescription()%>
												<br>
												Code No : <%=mat.getMat_code()%>  Ref No : <%=fm.getRef_no()%>
												<br>
												Color : <%=fm.getColour_tone()%>
												<br>
												<%=itemOrder.getRemark()%>
											</td>
											<td valign="top" align="center"><%=mat.getDes_unit()%></td>
											<td valign="top" align="center"><%=itemOrder.getItem_qty()%></td>
											<td valign="top" align="right">
												<%=Money.money(itemOrder.getUnit_price())%>						
											</td>
											<td valign="top" align="right"><%=itemOrder.getDiscount()%>%</td>
											<td valign="top" align="right">
											<%
											String dis = itemOrder.getDiscount();
											if(itemOrder.getDiscount().equalsIgnoreCase("")){
												dis = "0";
											}
											String sum = Money.multiple(itemOrder.getItem_qty(),itemOrder.getUnit_price());
											dis = Money.divide(Money.multiple(sum,dis),"100");
											sum = Money.money(Money.subtract(sum, dis));
											%>
											<%=sum %>
											</td>
										</tr>
											<%
									
									}
									i++;
									
								}
								%>
								</tbody>
							</table>
								
							<table class="tb" width="100%" style="margin-top: -1px;">
							<tr>
								<td align="center" width="20%">เงื่อนไขการชำระเงิน  <br>(Terms Of Payment)</td>
								<td width="30%"><%=(qt.getCredit().equals("")?cus.getCus_credit():qt.getCredit())%></td>
								<td align="center" width="20%">กำหนดส่งของ<br> (Delivery)</td>
								<td width="30%"><%=qt.getRemark_date()%></td>
							</tr>
						
							</table>
						
						<div>Remark : <%=qt.getRemark()%></div>
						
						
						<div class="m_top50">
							<div class="left txt_center s200">
								<div class="">......................................................<br>ผู้นำเสนอ</div>
								<div class=""><%=(order.getSale_by()=="all"?"ฝ่ายขาย":sale.getName() + " " + sale.getSurname())%></div>
								<div class="">(............................................................)</div>
							</div>
							
							<div class="left m_left50 txt_center s200">
								<div class="">......................................................<br>ผู้ออกใบเสนอราคา</div>
								<div class=""><%=createDoc.getName() + " " + createDoc.getSurname() %></div>
								<div class=""><%=createDoc.getUIPosition().getPos_name_th()%></div>
							</div>
							
							
							<div class="left txt_center m_left70 s200">
								<div class=" ">......................................................<br>ผู้อนุมัติ</div>
								<div class="">(............................................................)</div>
								<div class="">(............................................................)</div>
							</div>
							<div class="clear"></div>
						</div>
						
</div>
</body>
</html>