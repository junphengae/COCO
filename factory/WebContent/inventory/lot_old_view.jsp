<%@page import="com.bitmap.bean.inventory.SubCategories"%>
<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery-1.4.2.min.js" type="text/javascript"></script>
<script src="../js/ajaxfileupload.js" type="text/javascript"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.webcam.js"></script>

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Material Information</title>
<%
String mat_code = WebUtils.getReqString(request, "mat_code");
InventoryMaster invMaster = InventoryMaster.select(mat_code);
session.setAttribute("MAT", invMaster);
%>

</head>
<body>

<div class="wrap_all">
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">แสดงข้อมูลสินค้า Lot. เก่า</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">									
				<div class="clear"></div>
				
				<%if(!(invMaster.getGroup_id().equalsIgnoreCase("FG") || invMaster.getGroup_id().equalsIgnoreCase("SS"))){%>
			
				<fieldset class="s900 fset">
					<legend>รายการ Lot</legend>
					<table class="bg-image s900">
						<thead>
							<tr>
								<th valign="top" align="center" width="12%">Lot เลขที่ </th>
								<th valign="top" align="center" width="12%">เลขที่ใบสั่งซื้อ</th>
								<th valign="top" align="center" width="12%">เลขที่ใบแจ้งหนี้</th>
								<th valign="top" align="center" width="12%">วันที่นำเข้า</th>
								<th valign="top" align="center" width="12%">วันที่ผลิต</th>
								<th valign="top" align="center" width="12%">วันหมดอายุ</th>
								<th valign="top" align="center" width="10%">ราคา/หน่วย</th>
								<th valign="top" align="center" width="10%">ยอดนำเข้า</th>
								<th valign="top" align="center" width="10%">ยอดคงเหลือ</th>
								<th valign="top" align="center" width="10%" >
								</th>
							</tr>
						</thead>
						<tbody>
						<%
						String up = "0";
						Double total = 0.0;
						Iterator iteLot = InventoryLot.selectActiveList(mat_code , "T").iterator();
						while (iteLot.hasNext()){
							InventoryLot lot = (InventoryLot) iteLot.next();
							InventoryLotControl lotctrl = lot.getUILot_control();
							total += Double.parseDouble(lotctrl.getLot_balance());
							
						%>
							<tr>
								<td align="right"><div class="thickbox pointer" title="ข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=lot.getLot_no()%></div></td>
								<td><div class="thickbox pointer" title="ข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=lot.getPo()%></div></td>
								<td><div class="thickbox pointer" title="ข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=lot.getInvoice()%></div></td>
								<td align="center"><div class="thickbox pointer" title="ข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=WebUtils.getDateValue(lot.getCreate_date())%></div></td>
								<td align="center"><div class="thickbox pointer" title="ข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=WebUtils.getDateValue(lot.getMfg())%></div></td>
								<td align="center"><div class="thickbox pointer" title="ข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=WebUtils.getDateValue(lot.getLot_expire())%></div></td>
								<td align="right"><div class="thickbox pointer" title="ข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=lot.getLot_price()%></div></td>
								<td align="right"><div class="thickbox pointer" title="ข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=lot.getLot_qty()%></div></td>
								<td align="right"><div class="thickbox pointer" title="ข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=lotctrl.getLot_balance() %></div></td>
								<td align="center"><button class="btn_box" onclick="javascript: window.open('print_barcode.jsp?mat_code=<%=invMaster.getMat_code()%>&lot_no=<%=lot.getLot_no()%>','barcode','location=0,toolbar=0,menubar=0,width=500,height=500');">บาร์โค้ท</button></td>
							</tr>
						<%
						
						}
						if (invMaster.getUnit_pack().length()>0){
							String unitP = invMaster.getUnit_pack();
							if (invMaster.getUnit_pack().equalsIgnoreCase("0")){
								unitP = "1";
							}
							up = WebUtils.getInteger(Money.divide(total+"", unitP)) + "";
						}
						%>
							<tr>
								<td colspan="9" align="right" class="txt_bold">ยอดที่สามารถเบิกได้: <%=Money.money(total)%> <%=invMaster.getStd_unit()%> [ <%=up%> <%=invMaster.getDes_unit()%> ]</td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				
				<%
				} else {
				%>
				
				<fieldset class="s900 fset">
					<legend>รายการ Lot</legend>
					<table class="bg-image s900">
						<thead>
							<tr>
								<th valign="top" align="center" width="12%">Lot เลขที่ </th>
								<th valign="top" align="center" width="12%">เลขที่ใบสั่งผลิต</th>
								<th valign="top" align="center" width="12%">วันที่นำเข้า</th>
								<th valign="top" align="center" width="12%">วันที่ผลิต</th>
								<th valign="top" align="center" width="12%">วันหมดอายุ</th>
								<th valign="top" align="center" width="12%">ยอดนำเข้า</th>
								<th valign="top" align="center" width="12%">ยอดคงเหลือ</th>
								<th valign="top" align="center" width="15%"></th>
							</tr>
						</thead>
						<tbody>
						<%
						String up = "0";
						Double total = 0.0;
						Iterator iteLot = InventoryLot.selectActiveList(mat_code , "T").iterator();
						while (iteLot.hasNext()){
							InventoryLot lot = (InventoryLot) iteLot.next();
							InventoryLotControl lotCtrl = lot.getUILot_control();
							total += Double.parseDouble(lotCtrl.getLot_balance());
						%>
							<tr>
								<td><%=lot.getLot_no()%></td>
								<td><%=lot.getPo()%></td>
								<td align="center"><%=WebUtils.getDateValue(lot.getCreate_date())%></td>
								<td align="center"><div class="thickbox pointer" title="ข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=WebUtils.getDateValue(lot.getMfg())%></div></td>
								<td align="center"><div class="thickbox pointer" title="ข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_view.jsp?lot_no=<%=lot.getLot_no()%>"><%=WebUtils.getDateValue(lot.getLot_expire())%></div></td>
								<td align="right"><%=lot.getLot_qty()%></td>
								<td align="right"><%=lotCtrl.getLot_balance()%></td>
								<td align="center"><button class="btn_box" onclick="javascript: window.open('print_barcode.jsp?mat_code=<%=invMaster.getMat_code()%>&lot_no=<%=lot.getLot_no()%>','barcode','location=0,toolbar=0,menubar=0,width=500,height=500');">พิมพ์บาร์โค้ท</button></td>
							</tr>
						<%
						}
						%>
							<tr>
							<% if(invMaster.getGroup_id().equalsIgnoreCase("FG")){ %>
								<td colspan="6" align="right" class="txt_bold">ยอดที่สามารถเบิกได้: <%=invMaster.getBalance() + " " + invMaster.getDes_unit()%></td>
							<%}else{ %>
								<td colspan="6" align="right" class="txt_bold">ยอดที่สามารถเบิกได้: <%=Money.money(total)%> <%=invMaster.getStd_unit()%></td>
							<%} %>
							</tr>
						</tbody>
					</table>
				</fieldset>
				
				<%}%>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>	
</div>
</body>
</html>