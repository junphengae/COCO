<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inlet</title>
<%
String mat_code = WebUtils.getReqString(request, "mat_code");
String po = WebUtils.getReqString(request, "po");
List<InventoryLot> listLot = InventoryLot.selectList4PurchaseReport(mat_code, po);
%>
</head>
<body>

<table class="bg-image s_auto">
	<thead>
		<tr>
			<th align="center">เลขที่ Lot</th>
			<th align="center">วันที่รับ</th>
			<th align="center">จำนวนที่รับ</th>
			<th align="center">ราคาต่อหน่วย</th>
			<th align="center">Invoice</th>
		</tr>
	</thead>
	<tbody>
	<%
	boolean has = true;
	Iterator ite = listLot.iterator();
	while(ite.hasNext()){
		InventoryLot lot = (InventoryLot)ite.next();
		has = false;
	%>
		<tr>
			<td><%=lot.getLot_no()%></td>
			<td><%=WebUtils.getDateValue(lot.getCreate_date())%></td>
			<td><%=lot.getLot_qty()%></td>
			<td><%=lot.getLot_price()%></td>
			<td><%=lot.getInvoice()%></td>
		</tr>
	<%
	}
	if(has){
	%>
		<tr><td colspan="5" align="center">---- ยังไม่มีข้อมูลการนำเข้าสินค้า ---- </td></tr>
	<%
		}
	%>
	</tbody>
</table>

</body>
</html>