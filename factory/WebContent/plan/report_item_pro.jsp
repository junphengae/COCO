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
String pk_id = WebUtils.getReqString(request,"item_id");
String item_run = WebUtils.getReqString(request,"item_run");
String order_id = WebUtils.getReqString(request, "order_id");
String pro_id = WebUtils.getReqString(request, "pro_id");
SaleOrder order = SaleOrder.selectByID(order_id);
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
				Package pac = Package.select(pk_id);
				
				List lists = Production.selectList(item_run, pk_id,pro_id);
				Iterator ite = lists.iterator();
				while (ite.hasNext()){
					Production pro = (Production) ite.next();	
				Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_barcode"),pro.getPro_id());

					
				%>		
						<div class="txt_center" style="font-size: 22px;"><strong>ใบเบิกวัตถุดิบ</strong></div><div class="clear"></div>
						<div class="left"><img src="../path_images/barcode/<%=pro.getPro_id()%>.png"></div>
						<div class="clear"></div>
						<div class="left">Product No. - <%=pro.getPro_id()%></div>
						<%
						if(pro.getRef_pro().equalsIgnoreCase("")){
						}else{
						%>
						<div class="right">Ref No. - <%=pro.getRef_pro()%></div>
						<%
						}
						%>
						<div class="clear"></div>
						<div class="left s200">ประเภท </div><div class="left s550">: <%=SaleOrder.type(order.getOrder_type())%></div>
							<fieldset class="right s200" style="border-color: black;">
							<div class="txt_center left s100">วันที่ผลิตจริง </div><div class="left s100">: <%=DBUtility.getDateValue(pro.getFin_date())%></div>
							</fieldset>
						<div class="clear"></div>
						<div class="left s200">ชื่อสินค้า </div><div class="left">: <%="(PRO) - " + pac.getName()%></div><div class="clear"></div>
						<div class="left s200">จำนวน </div><div class="left">: <%=pro.getItem_qty() + " ชุด"%></div><div class="clear"></div>
						
				<%
				}
				%>
						<table class="tb" width="100%">
							<thead>
								<tr align="center">
									<td width="10%">รหัสเดิม</td>
									<td width="10%">รหัสใหม่</td>
									<td width="10%">ประเภท</td>
									<td width="40%">รายการวัตถุดิบ</td>
									<td width="10%">สถานที่</td>
									<td width="20%">barcode</td>
								</tr>		
							</thead>			
							<tbody>
								<%
								List list =  PackageItem.listPackage(pk_id);
								Iterator itePro = list.iterator();
								while (itePro.hasNext()){
									PackageItem item = (PackageItem) itePro.next();	
									InventoryMaster mat = item.getUIMat();
									
									Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_barcode"),mat.getMat_code());

								%>
								<tr>
									<td align="center"><%=mat.getRef_code()%></td>
									<td align="center"><%=mat.getMat_code()%></td>
									<td align="center"><%=mat.getGroup_id()%></td>
									<td align="left"><%=mat.getDescription()%></td>
									<td align="center"><%=mat.getLocation()%></td>
									<td align="center"><img src="../path_images/barcode/<%=mat.getMat_code()%>.png"></td>
								</tr>
									<% 
								}						
		
				%>
							</tbody>
						</table>	
</div>
</body>
</html>