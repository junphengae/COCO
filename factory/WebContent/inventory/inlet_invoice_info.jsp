<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inlet Information</title>
<%
	InventoryLot LOT = new InventoryLot();
	WebUtils.bindReqToEntity(LOT, request);
	InventoryLot.select(LOT);
	
	InventoryMaster master = InventoryMaster.select(LOT.getMat_code());
	List list = InventoryLot.selectList(LOT.getMat_code());
%>
<script type="text/javascript">
$(function(){
	$('#td_show_total').append($('#total').val());
});
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">
					1: รับเข้าสินค้า | 2: แสดงข้อมูลคงคลัง
				</div>
				<div class="right">
					
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<table width="100%">
					<tbody>
						<tr>
							<td width="25%">รหัสสินค้า</td>
							<td width="75%">: <%=master.getMat_code()%> &nbsp;&nbsp;<%=master.getDescription()%></td>
						</tr>
						<tr>
							<td>รหัสเดิม</td>
							<td>: <%=master.getRef_code()%></td>
						</tr>
						<tr>
							<td>สถานที่เก็บ</td>
							<td>: <%=master.getLocation()%></td>
						</tr>
						<tr>
							<td>ลักษณะการจัดเก็บ</td>
							<td>: <%=(master.getFifo_flag().equalsIgnoreCase("y"))?"FIFO":"Non FIFO"%></td>
						</tr>
						<tr>
							<td>หน่วยนับ</td>
							<td>: <%=master.getStd_unit()%></td>
						</tr>
						<tr>
							<td>จำนวนทั้งหมด</td>
							<td id="td_show_total">: </td>
						</tr>
					</tbody>
				</table>
				
				<div class="m_top15"></div>
				
				<fieldset class="fset s700 center">
					<legend>รายการรับเข้าล่าสุด</legend>
					<div class="s400 left">
						<table width="100%">
							<tbody>
								<tr>
									<td width="40%">Lot เลขที่ (VBI Lot no.)</td>
									<td width="60%">: <%=LOT.getLot_no()%></td>
								</tr>
								<tr>
									<td>เลขที่ใบสั่งซื้อ</td>
									<td>: <%=LOT.getPo()%></td>
								</tr>
								<tr>
									<td>เลขที่ใบแจ้งหนี้</td>
									<td>: <%=LOT.getInvoice()%></td>
								</tr>
								<tr>
									<td>จำนวน</td>
									<td>: <%=LOT.getLot_qty()%></td>
								</tr>
								<tr>
									<td>ราคาต่อหน่วย</td>
									<td>: <%=LOT.getLot_price()%></td>
								</tr>
								<tr>
									<td>ตัวแทนจำหน่าย</td>
									<td>: <%=Vendor.select(LOT.getVendor_id()).getVendor_name() %></td>
								</tr>
								<tr>
									<td>รหัสสินค้าของตัวแทน</td>
									<td>: <%=LOT.getVendor_mat_code()%></td>
								</tr>
								<tr>
									<td>เลขที่ Lot ของตัวแทน</td>
									<td>: <%=LOT.getVendor_lot_no()%></td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<div class="s200 right pointer" onclick="javascript: window.open('print_barcode.jsp?mat_code=<%=master.getMat_code()%>&lot_no=<%=LOT.getLot_no()%>','barcode','location=0,toolbar=0,menubar=0,width=500,height=500');">
						<img src="../images/btn_barcode.png">
					</div>
					
					<div class="clear"></div>
				</fieldset>
				
				<div class="m_top20"></div>
				
				<table class="bg-image s900">
					<thead>
						<tr>
							<th valign="top" align="center" width="20%">Lot เลขที่ </th>
							<th valign="top" align="center" width="15%">เลขที่ใบสั่งซื้อ</th>
							<th valign="top" align="center" width="15%">เลขที่ใบแจ้งหนี้</th>
							<th valign="top" align="center" width="15%">จำนวน</th>
							<th valign="top" align="center" width="15%">ราคาต่อหน่วย</th>
							<th valign="top" align="center" width="20%">วันที่นำเข้า</th>
						</tr>
					</thead>
					<tbody>
					<%
					Double total = 0.0;
					Iterator ite = list.iterator();
					while (ite.hasNext()){
						InventoryLot lot = (InventoryLot) ite.next();
						if(lot.getLot_status().equalsIgnoreCase("A")){
							total += Double.parseDouble(lot.getLot_qty());
						}
					%>
						<tr>
							<td><%=lot.getLot_no()%></td>
							<td><%=lot.getPo()%></td>
							<td><%=lot.getInvoice()%></td>
							<td align="right"><%=lot.getLot_qty()%></td>
							<td align="right"><%=lot.getLot_price()%></td>
							<td align="center"><%=WebUtils.getDateValue(lot.getCreate_date())%></td>
						</tr>
					<%
					}
					%>
					</tbody>
				</table>
				<input type="hidden" id="total" value="<%=Money.moneyNoCommas(total)%>">
				
				<div class="s400 center txt_center m_top5">
					<button class="btn_box" onclick="window.location='SearchInventory?action=search_after_edit';">กลับไปหน้าค้นหา</button>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>