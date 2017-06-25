<%@page import="com.bitmap.bean.logistic.ProduceItemMat"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.bean.rd.MatTree"%>
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

String order_id = WebUtils.getReqString(request, "order_id");
String pro_id = WebUtils.getReqString(request, "pro_id");
String item_run = WebUtils.getReqString(request, "item_run");
String item_id = WebUtils.getReqString(request, "item_id");
SaleOrder order = SaleOrder.selectByID(order_id);

List paramList = new ArrayList();

paramList.add(new String[]{"pro_id",pro_id});
paramList.add(new String[]{"item_run",item_run});
session.setAttribute("SO_SEARCH", paramList);
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
	//setTimeout('window.print()',1000); setTimeout('window.close()',2000);
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Viewer</title>


</head>
<body style="font-size: 18px;" onload="setPrint();">
<div class="wrap_print">
	<div style="margin-top: 80px;"></div>
	
				
				<%		
					Iterator itepro = Production.selectList(item_run, item_id,pro_id).iterator();
					String aa = "";
					String sent_id = "";
					while (itepro.hasNext()){
					Production product = (Production) itepro.next();	
					InventoryMaster mat = product.getUIMat();
					RDFormular rd = product.getUIRd();
					
					aa = mat.getGroup_id();
					sent_id = product.getSent_id();
					String volume = product.getItem_qty();
					String vol_yield = Money.divide(Money.multiple(volume, "100"),((rd.getYield().equalsIgnoreCase("0") || rd.getYield().length() == 0)?"100":rd.getYield()));
					
					Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_barcode"), product.getPro_id());
					Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_barcode"), mat.getMat_code());

					
				%>		
						<div class="txt_center" style="font-size: 22px;"><strong><%=(product.getStatus().equalsIgnoreCase(Production.STATUS_FINNISH)?"ใบเบิกสินค้า":"ใบเบิกวัตถุดิบ")%></strong></div>
						
						<div class="clear"></div>
						<br>
						<div class="left"><img src="../path_images/barcode/<%=product.getPro_id()%>.png"></div>
						<div class="clear"></div>
						<%
						if(product.getRef_pro().equalsIgnoreCase("")){
						}else{
						%>
						<div class="right">Ref No. - <%=product.getRef_pro()%></div>
						<%
						}
						%>
						<div class="clear"></div>
						<div class="left s200">ประเภท </div><div class="left s550">: <%=SaleOrder.type(order.getOrder_type())%></div>
						
						<fieldset class="right s200" style="border-color: black;">
						<div class="txt_center left s100">วันที่ผลิตจริง </div><div class="left s100">: <%=(product.getFin_date() == null?"-":DBUtility.getDateValue(product.getFin_date()))%></div>
						
						</fieldset>
						<div class="clear"></div>
						<div class="left s200">ชื่อสินค้า </div><div class="left s400">: <%="(" + mat.getGroup_id() + ") - " + mat.getDescription() + " - " + mat.getMat_code() %></div><div class="left"><img src="../path_images/barcode/<%=mat.getMat_code()%>.png"></div><div class="clear"></div>
						
						<% if(product.getStatus().equalsIgnoreCase(Production.STATUS_FINNISH)){ %>
						<div class="left s200">จำนวนที่ต้องเบิกทั้งหมด </div><div class="left">: <%=product.getItem_qty() + " " + mat.getDes_unit()%></div>
						<div class="clear"></div>
						<%}else{ %>
						<div class="left s200">จำนวนที่ต้องผลิตทั้งหมด </div><div class="left">: <%=Money.money(volume) + " " + mat.getStd_unit()%></div>
						<div class="clear"></div>
						<%} %>
				<%
				}
				if((aa.equalsIgnoreCase("SS") || aa.equalsIgnoreCase("FG")) && sent_id.equalsIgnoreCase(Production.STATUS_PRODUCE)){
				%>
						<table class="tb" width="100%">
							<thead>
								<tr align="center">
									<td width="10%">รหัสเดิม</td>
									<td width="10%">รหัสใหม่</td>
									<td width="10%">ประเภท</td>
									<td width="30%">รายการวัตถุดิบ</td>
									<td width="10%">สถานที่</td>
									<td width="10%">จำนวน (KG)</td>
									<td width="20%">barcode</td>
								</tr>		
							</thead>			
							<tbody>
								<%
								Iterator ite = ProduceItemMat.selectlist(paramList).iterator();
								while (ite.hasNext()){
									ProduceItemMat pro = (ProduceItemMat) ite.next();	
									InventoryMaster mat = pro.getUIMat();
									RDFormular rd = pro.getUIRd();
									Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_barcode"),pro.getMat_code());							
									%>
								<tr>
									<td align="center"><%=mat.getRef_code()%></td>
									<td align="center"><%=pro.getMat_code()%></td>
									<td align="center"><%=pro.getItem_type()%></td>
									<td align="left"><%=mat.getDescription()%></td>
									<td align="center"><%=mat.getLocation()%></td>
									<td align="right"><%=Money.money(pro.getQty())%></td>
									<td align="center"><img src="../path_images/barcode/<%=pro.getMat_code()%>.png"></td>
								</tr>
								<% 
								}						
								%>
							</tbody>
						</table>	
			<% } %>
</div>
</body>
</html>