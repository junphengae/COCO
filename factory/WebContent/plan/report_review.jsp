<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="com.bitmap.bean.rd.MatTree"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.logistic.ProduceItemMat"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
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
String export = WebUtils.getReqString(request, "export");

String time = WebUtils.getReqString(request, "time");
String year = WebUtils.getReqString(request, "year");
String month = WebUtils.getReqString(request, "month");

if (export.equalsIgnoreCase("true")) {
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=" + report_type + "_" + WebUtils.getDateValue(WebUtils.getCurrentDate()) + ".xls");
%>
<style type="text/css">
.tb{border-collapse: collapse;}
.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}

</style>
<%
} else {
%>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/theme_print.css" rel="stylesheet" type="text/css" media="all">

<%}%>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Viewer</title>

</head>
<body>

	<%
	/** report_fg **/
	if (report_type.equalsIgnoreCase("report_fg")) {
	%>
	<table class="tb">
		<tbody>
			<tr align="center">
				<td width="10%">รหัสเดิม</td>
				<td width="10%">รหัสใหม่</td>
				<td width="5%">ประเภท</td>
				<td width="30%">รายการ</td>
				<td width="15%">จำนวน</td>
				<td width="15%">บรรจุภัณฑ์</td>
			</tr>	
			<%
			HashMap<String, MatTree> map = new HashMap();
			if (time.equalsIgnoreCase("date")){
				map = SaleOrderItem.report_fg(WebUtils.getReqDate(request, "create_date"));
			} else {
				map = SaleOrderItem.report_fg(year, month);
			}

			Iterator itePK = map.keySet().iterator();
			while (itePK.hasNext()){
				MatTree mat = map.get((String)itePK.next()) ;
			%>
			<tr>
				<td align="center"><%=mat.getRef_code()%></td>
				<td align="center"><%=mat.getMat_code()%></td>
				<td align="center">FG</td>
				<td align="left"><%=mat.getDescription()%></td>
				<td align="right"><%=Money.money(mat.getOrder_qty())%></td>
				<td align="center"><%=mat.getGroup_id()%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<%
	}
	
	/** report_mt **/
	if (report_type.equalsIgnoreCase("report_mt")) {
	%>
	<table class="tb">
		<tbody>
			<tr align="center">
				<td width="10%">รหัสเดิม</td>
				<td width="10%">รหัสใหม่</td>
				<td width="10%">ประเภท</td>
				<td width="30%">รายการวัตถุดิบ</td>
				<td width="10%">สถานที่</td>
				<td width="10%">จำนวน (KG)</td>
			</tr>	
			<%
			List<ProduceItemMat> listLot = ProduceItemMat.selectPD();
			for (ProduceItemMat pro : listLot) {
				InventoryMaster mat = pro.getUIMat();
			%>
			<tr>
				<td align="center"><%=mat.getRef_code()%></td>
				<td align="center"><%=pro.getMat_code()%></td>
				<td align="center"><%=pro.getItem_type()%></td>
				<td align="left"><%=mat.getDescription()%></td>
				<td align="center"><%=mat.getLocation()%></td>
				<td align="right"><%=Money.money(pro.getQty())%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<%
	}
	
	/** report_pk **/
	if (report_type.equalsIgnoreCase("report_pk")) {
	%>
	<table class="tb">
		<tbody>
			<tr align="center">
				<td width="10%">รหัสเดิม</td>
				<td width="10%">รหัสใหม่</td>
				<td width="10%">ประเภท</td>
				<td width="30%">รายการวัตถุดิบ</td>
				<td width="10%">สถานที่</td>
				<td width="10%">จำนวน</td>
			</tr>	
			<%
			List<ProduceItemMat> listLot = ProduceItemMat.selectPK();
			for (ProduceItemMat pro : listLot) {
				InventoryMaster mat = pro.getUIMat();
			%>
			<tr>
				<td align="center"><%=mat.getRef_code()%></td>
				<td align="center"><%=pro.getMat_code()%></td>
				<td align="center"><%=pro.getItem_type()%></td>
				<td align="left"><%=mat.getDescription()%></td>
				<td align="center"><%=mat.getLocation()%></td>
				<td align="right"><%=Money.money(pro.getQty()) + " " + mat.getStd_unit()%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<%
	}
	/** report_reciv **/
	if (report_type.equalsIgnoreCase("report_reciv")) {
	%>
	<table class="tb">
		<tbody>
			<thead>
				<tr>
					<th valign="top" align="center" width="10%">ประเภทสินค้า</th>
					<th valign="top" align="center" width="30%">รายการสินค้า</th>
					<th valign="top" align="center" width="5%">จำนวน</th>
					<th valign="top" align="center" width="15%">บรรจุภัณฑ์</th>
				</tr>
			</thead>
			<%
			SaleOrderItem listLot = SaleOrderItem.report_reciv();
			InventoryMaster mat = listLot.getUIMat();
			%>
			<tr>
				<td align="center"><%=mat.getGroup_id()%></td>
				<td align="center"><%=mat.getDescription()%></td>
				<td align="center"><%=listLot.getItem_qty()%></td>
				<td align="center"><%=mat.getDes_unit()%></td>
			</tr>
			<%
			%>
		</tbody>
	</table>
	<%
	}
	/** report_sale **/
	if (report_type.equalsIgnoreCase("report_sale")) {
	%>
	<table class="tb">
		<tbody>
			<tr>
				<th valign="top" align="center" width="10%">Invoice No.</th>
				<th valign="top" align="center" width="30%">รายการสินค้า</th>
				<th valign="top" align="center" width="10%">ราคาต่อหน่วย</th>
				<th valign="top" align="center" width="5%">จำนวน</th>
				<th valign="top" align="center" width="5%">ส่วนลด</th>
				<th valign="top" align="center" width="10%">ราคาหลังลด</th>
				<th valign="top" align="center" width="5%">vat 7%</th>
				<th valign="top" align="center" width="10%">ราคารวมทั้งหมด</th>
			</tr>
			<%
			List<SaleOrderItem> listLot = SaleOrderItem.report_sale();
			for (SaleOrderItem entity : listLot) {
			%>
			<tr>
				<td align="center"><%=entity.getInvoice()%></td>
				<td align="center"><%=(entity.getItem_type().equalsIgnoreCase("s")?entity.getUIMatName():entity.getUIPacName())%></td>
				<td align="center">
				<% 
				String aa = "";
				if(entity.getItem_type().equalsIgnoreCase("s")){
					aa = Money.multiple(entity.getUnit_price(),entity.getItem_qty());
					%><%=Money.money(entity.getUnit_price())%>
				<%
				}else{
					aa = entity.getUnit_price();
					%><%=Money.money(Money.divide(entity.getUnit_price(),entity.getItem_qty()))%>
				<%	
				}
				%>
				</td>
				<td align="right"><%=entity.getItem_qty()%></td>
				<td align="right"><%=entity.getDiscount()%></td>
				<td align="right">
				<%
				String discnt = "0";
				if (entity.getDiscount().length() > 0) {
					discnt = entity.getDiscount();
				}
				String dis = Money.discount(aa,discnt);
				%><%=Money.money(dis)%>
				</td>
				<td align="right">
				<%
				String vat = Money.divide(Money.multiple("7",dis),"100");
				%>
				<%=Money.money(vat)%>
				</td>
				<td align="right"><%=Money.money(Money.add(vat,dis))%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<%
	}
	/** report4acount **/
	if (report_type.equalsIgnoreCase("report4acount")) {
	%>
	<table class="tb">
		<tbody>
			<tr>
				<th valign="top" align="center" width="10%">Invoice No.</th>
				<th valign="top" align="center" width="30%">ลูกค้า</th>
				<th valign="top" align="center" width="10%">ราคารวมทั้งหมด</th>
			</tr>
			<%
			HashMap<String, MatTree> map = SaleOrderItem.report4account();
			Iterator itePK = map.keySet().iterator();
			while (itePK.hasNext()){
				MatTree mat = map.get((String)itePK.next()) ;
			%>
			<tr>
				<td align="center"><%=mat.getRef_code()%></td>
				<td align="center"><%=mat.getDescription()%></td>
				<td align="right"><%=Money.money(mat.getMat_code())%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<%
	}
	/** report_pd **/
	if (report_type.equalsIgnoreCase("report_pd")) {
	%>
	<table class="tb">
		<tbody>
			<tr>
				<th valign="top" align="center" width="8%">เลขที่การผลิต</th>
				<th valign="top" align="center" width="8%">เลขที่อ้างอิง</th>
				<th valign="top" align="center" width="13%">รูปแบบการผลิต</th>
				<th valign="top" align="center" width="10%">ประเภท</th>
				<th valign="top" align="center" width="25%">รายการ</th>
				<th valign="top" align="center" width="10%">จำนวน</th>		
				<th valign="top" align="center" width="13%">สถานะ</th>
			</tr>
			<%
			List list = Production.report_pd();
			Iterator ite = list.iterator();
			while (ite.hasNext()){
				Production entity = (Production) ite.next();
				InventoryMaster mat = entity.getUIMat();
				Package pac = entity.getUIPac();
				SaleOrderItem order = entity.getUIorder();
			%>
			<tr>
				<td valign="top" align="right"><%=entity.getPro_id()%></td>
				<td valign="top" align="right"><%=entity.getRef_pro()%></td>
				<td valign="top" align="center"><%=SaleOrder.type(entity.getUIOrderType())%></td>
				<td valign="top" align="right"><%=(entity.getItem_type().equalsIgnoreCase("PRO")?pac.getPk_id() + " -- PRO":mat.getMat_code() + " -- " + entity.getItem_type())%></td>
				<td valign="top" align="left">
					<%=(entity.getItem_type().equalsIgnoreCase("PRO")?pac.getName():mat.getDescription())%>
				</td>
				<td valign="top" align="center"><%=Money.money(entity.getItem_qty())%> <%=(entity.getItem_type().equalsIgnoreCase("PRO")?"ชุด":"KG")%></td>
				<td valign="top" align="center"><%=(entity.getStatus().equalsIgnoreCase(Production.STATUS_OUTLET)?Production.status(Production.STATUS_FINNISH):Production.status(entity.getStatus()))%> </td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<%
	}
	%>
</body>
</html>