<%@page import="com.bitmap.bean.logistic.ReportMat2PD"%>
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
String report_type = WebUtils.getReqString(request, "report_type");
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");

List paramList = new ArrayList();
paramList.add(new String[]{"year",year});
paramList.add(new String[]{"month",month});

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
//	setTimeout('window.print()',1000); setTimeout('window.close()',2000);
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Viewer</title>


</head>
<body style="font-size: 18px;" onload="setPrint();">
<div class="wrap_print">
	<div style="margin-top: 80px;"></div>
				<div class="txt_center" style="font-size: 22px;"><strong></strong></div>
				<div class="clear"></div>
				<br><br>
				
				<%
				/* OutletPD */
				if (report_type.equalsIgnoreCase("reportPD")) { %>
				<table class="tb" width="100%">
					<thead>
						<tr>
							<th valign="top" align="center" width="10">เลขที่ใบ PD</th>
							<th valign="top" align="center" width="10">รหัสวัตถุดิบ</th>
							<th valign="top" align="center" width="5">ประเภท</th>
							<th valign="top" align="center" width="35%">ชื่อวัตถุดิบ</th>
							<th valign="top" align="center" width="15%">จำนวนที่ผลิต</th>
							<th valign="top" align="center" width="15%">จำนวนที่เบิกจริง</th>
							<th valign="top" align="center" width="10%">จำนวนที่เหลือใน buffer</th>
							
						</tr>		
					</thead>	
					<tbody>
						<%
						List list = ReportMat2PD.selectBydate(paramList);
						Iterator ite = list.iterator();
						while (ite.hasNext()){
							ReportMat2PD entity = (ReportMat2PD) ite.next();
						%>		
						<tr>
							<td valign="top" align="center" ><%=entity.getPro_id()%></td> 
							<td valign="top" align="center" ><%=entity.getMat_code() %></td>
							<td valign="top" align="center" ><%=entity.getUIMat().getGroup_id() %></td>
							<td valign="top" align="left" ><%=entity.getUIMat().getDescription() %></td>
							<td valign="top" align="right" ><%=Money.money(entity.getSum_qty_pd())%></td>
							<td valign="top" align="right" ><%=Money.money(entity.getSum_qty_store())%></td>
							<td valign="top" align="right" ><%=Money.money(entity.getQty_buffer())%></td>
						</tr>
						<%
						}
						%>
						</tbody>
				</table>	
				
				
				<%
				}
				/* Outlet */
				if (report_type.equalsIgnoreCase("reportOutlet")) { %>
				<table class="tb" width="100%">
					<tbody>
						<tr>
							<td>เลขที่อ้างอิงการเบิก</td>
							<td>เลขที่ Lot</td>
							<td>วัน / เวลาที่เบิก</td>
							<td>จำนวนที่เบิกทั้งหมด</td>
							<td>ประเภทการเบิก</td>
							<td>ผู้เบิก</td>
						</tr>
						<%
						List list2 = InventoryLotControl.outletReport(paramList);
						Iterator ite2 = list2.iterator();
						while (ite2.hasNext()){
							InventoryLotControl entity = (InventoryLotControl) ite2.next();
							Personal per = entity.getUIPersonal();
						%>	
						<tr>
							<td><%=entity.getRequest_no()%></td>
							<td><%=entity.getLot_no()%></td>
							<td><%=WebUtils.getDateTimeValue(entity.getRequest_date())%></td>
							<td align="right"><%=entity.getRequest_qty()%></td>
							<td><%=entity.getRequest_type()%></td>
							<td align="left"><%=per.getName() + " " + per.getSurname()%></td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
				<%
				}
				%>				
</div>
</body>
</html>