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
String location = master.getLocation();
List list = InventoryLot.selectList(LOT.getMat_code());

//
%>
<script type="text/javascript">

function setPrint(){
	setTimeout('window.print()',1000); setTimeout('window.close()',2000);
}
</script>
</head>
<body onload="setPrint();">

<div class="wrap_all">
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="center txt_center txt_bolder txt_bold txt_ang_62">
					Identify Tag / ป้ายชี้บ่ง บรรจุภัณฑ์
				</div>
				<div class="right">
					
				</div>
				<div class="clear"></div>
			</div>
			<p>&nbsp;</p>
			<div class="">
				
				<table width="100%" class="tb_ident_tag">
					<tbody>
						<tr>
							<td width="50%" class="txt_bold txt_ang_40" colspan="2">รหัส : &nbsp;&nbsp; <span class="txt_ang_100"><%=master.getMat_code()%></span></td>
							<td width="50%" class="txt_bold txt_ang_40" colspan="2">Lot no. : &nbsp;&nbsp;<span class="txt_ang_100"><%=LOT.getLot_no()%></span></td>
						</tr>
						<tr>
							<td class="txt_bold txt_ang_40" colspan="2">ประเภท : &nbsp;&nbsp;<%=master.getCat_id()%></td>
							<td class="txt_bold txt_ang_40" colspan="2">ลำดับที่ : ________/________</td>
						</tr>
						<tr>
							<td class="txt_bold txt_ang_40" colspan="4">ชื่อ : &nbsp;&nbsp;&nbsp;&nbsp;<span class="txt_ang_75"><%=master.getDescription()%></span></td>
						</tr>
						<tr>
							<td class="txt_bold txt_ang_40" colspan="2">จำนวนรับเข้า : &nbsp;&nbsp;<span class="txt_ang_56"><%=LOT.getLot_qty()%></span></td>
							<td class="txt_bold txt_ang_40" colspan="2">หน่วยนับ : &nbsp;&nbsp;<span class="txt_ang_56"><%=master.getStd_unit()%></span></td>
						</tr>
						<tr>
							<td class="txt_bold txt_ang_40" colspan="4">จำนวน / บรรจุภัณฑ์   :  __________________/____________________</td>
						</tr>
						<tr>
							<td class="txt_bold txt_ang_40" colspan="4">วันที่รับเข้า : &nbsp;&nbsp;<%=WebUtils.getDateTimeValue(LOT.getCreate_date())%></td>
						</tr>
						<tr>
						<%if(LOT.getMfg() != null){ %>
							<td class="txt_bold txt_ang_40" colspan="2">วันที่ผลิต :<span class="txt_ang_66"> <%=WebUtils.getDateTimeValue(LOT.getMfg()).substring(0,10)%></span></td>
						<%}else{ %>
							<td class="txt_bold txt_ang_40" colspan="2">วันที่ผลิต :<span class="txt_ang_66">_____________</span></td>
						<%} %>
						
						<%if(LOT.getLot_expire() != null){ %>
							<td class="txt_bold txt_ang_40" colspan="2">วันที่หมดอายุ : <span class="txt_ang_66"><%=WebUtils.getDateTimeValue(LOT.getLot_expire()).substring(0,10)%></span></td>
						<%}else{ %>
							<td class="txt_bold txt_ang_40" colspan="2">วันที่หมดอายุ : <span class="txt_ang_66">_____________</span></td>
						<%} %>
						
							
						</tr>
						<tr>
							<td class="txt_bold txt_ang_40" colspan="4">เลขที่ใบสั่งซื้อ / ใบสั่งผลิต : &nbsp;&nbsp;&nbsp;&nbsp;<span class="txt_ang_62"><%=LOT.getPo()%></span></td>
						</tr>
						<tr>
							<td class="txt_bold txt_ang_40" colspan="4">ชื่อผู้ขาย / ลูกค้า : &nbsp;&nbsp;<%=LOT.getVendor_id()%></td>
						</tr>
						<tr>
							<td class="txt_bold txt_ang_40" colspan="2">ผู้ตรวจรับ : ______________________</td>
							<td class="txt_bold txt_ang_40" colspan="2">QA ผู้ตรวจสอบ : ___________________</td>
						</tr>
						<tr>
							<td class="txt_bold txt_ang_40">วันที่</td>
							<td class="txt_ang_40">____________________________ </td>
							<td class="txt_bold txt_ang_40">วันที่</td>
							<td class="txt_ang_40">____________________________ </td>
						</tr>
					</tbody>
				</table>
				
				<div class="m_top15"></div>
							
				<div class="m_top20"></div>
				
				<table class="tb_iden txt_ang_30" style="width: '100%;">
						<tr>
							<th valign="top" align="center" width="11%">จำนวนตั้งต้น </th>
							<th valign="top" align="center" width="10%">เบิก</th>
							<th valign="top" align="center" width="10%">ลายเซนต์</th>
							<th valign="top" align="center" width="11%">จำนวนตั้งต้น </th>
							<th valign="top" align="center" width="10%">เบิก</th>
							<th valign="top" align="center" width="10%">ลายเซนต์</th>
							<th valign="top" align="center" width="11%">จำนวนตั้งต้น </th>
							<th valign="top" align="center" width="10%">เบิก</th>
							<th valign="top" align="center" width="10%">ลายเซนต์</th>
						</tr>
					<tbody>
							<tr>
								<td align="right"><span class="txt_ang_40"><%=LOT.getLot_qty()%></span></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
					<%
					int i =1;
					while (i < 8){
					%>
						<tr>
							<td><p><span class="txt_ang_40">  &nbsp;</span></p></td>
							<td><p><span class="txt_ang_40">  &nbsp;</span></p></td>
							<td><p><span class="txt_ang_40">  &nbsp;</span></p></td>
							<td><p><span class="txt_ang_40">  &nbsp;</span></p></td>
							<td><p><span class="txt_ang_40">  &nbsp;</span></p></td>
							<td><p><span class="txt_ang_40">  &nbsp;</span></p></td>
							<td><p><span class="txt_ang_40">  &nbsp;</span></p></td>
							<td><p><span class="txt_ang_40">  &nbsp;</span></p></td>
							<td><p><span class="txt_ang_40">  &nbsp;</span></p></td>
						</tr>
					<%
					i++;
					}
					%>
					</tbody>
				</table>
				<p><span class="txt_ang_40">FM-WH-20Rev.00 Effective 15 Jun. 2016</span>
				</p>
			</div>
		</div>
	</div>
</div>

</body>
</html>