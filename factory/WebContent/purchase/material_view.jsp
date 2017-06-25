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
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/jquery-1.4.2.min.js" type="text/javascript"></script>
<script src="../js/ajaxfileupload.js" type="text/javascript"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.webcam.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Material Information</title>
<%
String mat_code = WebUtils.getReqString(request, "mat_code");
InventoryMaster invMaster = InventoryMaster.select(mat_code);
session.setAttribute("MAT", invMaster);
%>

<script type="text/javascript">
function ajaxImgUpload(){
	$up = $('#fileToUpload');
	$showImg = $('#showImg');
	var mat_code = '<%=mat_code%>';
	
	if ($up.val() == '') {
		alert('Please select image!');
		$up.focus();
	} else {
		$("#loadingImg")
		.ajaxStart(function(){
			$(this).show();
			$showImg.hide();
		})
		.ajaxComplete(function(){
			$(this).hide();
			$showImg.show();
		});
		
		$.ajaxFileUpload({
			url:'PhotoSnap', 
			secureuri:false,
			fileElementId:'fileToUpload',
			param: 'mat_code:' + mat_code,
			dataType: 'json',
			success: function (data, status){
				window.location.reload();
			},
			error: function (){
				window.location.reload();
			}
		});
	}
	return false;
}
</script>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">1: แสดงข้อมูลสินค้า</div>
				<div class="right m_right10">
					<button class="btn_box" onclick="window.location='PurchaseManage?action=search_after_edit';">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<fieldset class="s450 left fset">
					<legend>ข้อมูลสินค้า</legend>
					<table width="100%">
						<tbody>
							<tr>
								<td width="40%">กลุ่ม</td>
								<td width="60%">: <%=invMaster.getUISubCat().getUICat().getUIGroup().getGroup_name_th()%></td>
							</tr>
							<tr>
								<td>ชนิด</td>
								<td>: <%=invMaster.getUISubCat().getUICat().getCat_name_th()%></td>
							</tr>
							<tr>
								<td>ชนิดย่อย</td>
								<td>: <%=invMaster.getUISubCat().getSub_cat_name_th()%></td>
							</tr>
							<tr><td colspan="2" height="20"></td></tr>
							<tr>
								<td>รหัสสินค้า</td>
								<td>: <%=mat_code%></td>
							</tr>
							<tr>
								<td>ชื่อสินค้า</td>
								<td>: <%=invMaster.getDescription()%></td>
							</tr>
							<%if(invMaster.getGroup_id().equalsIgnoreCase("FG")){ %>
							<tr>
								<td>ชื่อยี่ห้อ</td>
								<td>: <%=invMaster.getBrand_name()%></td>
							</tr>
							<%} %>
							<tr>
								<td>ลักษณะการจัดเก็บ</td>
								<td>: <%=(invMaster.getFifo_flag().equalsIgnoreCase("y"))?"FIFO":"Non FIFO"%></td>
							</tr>
							<tr>
								<td>รหัสเดิม</td>
								<td>: <%=invMaster.getRef_code()%></td>
							</tr>
							<tr><td colspan="2" height="20"></td></tr>
							<tr>
								<td>ราคากลาง</td>
								<td>: <%=invMaster.getPrice()%></td>
							</tr>
							<tr>
								<td>ต้นทุน</td>
								<td>: <%=invMaster.getCost()%></td>
							</tr>
							<tr>
								<td>หน่วยนับ</td>
								<td>: <%=invMaster.getStd_unit()%></td>
							</tr>
							<tr>
								<td>ลักษณะบรรจุภัณฑ์</td>
								<td>: <%=invMaster.getDes_unit()%></td>
							</tr>
							<tr>
								<td>ปริมาณ/บรรจุภัณฑ์</td>
								<td>: <%=invMaster.getUnit_pack()%></td>
							</tr>
							<tr>
								<td>สถานที่เก็บ</td>
								<td>: <%=invMaster.getLocation()%></td>
							</tr>
							<tr>
								<td>จำนวนต่ำสุดที่ต้องสั่งเพิ่ม</td>
								<td>: <%=invMaster.getMor()%></td>
							</tr>
						</tbody>
					</table>
					<div class="center txt_center m_top5">
						<button class="btn_box" onclick="javascript: window.location='material_edit.jsp';">แก้ไขข้อมูลสินค้า</button>
					</div>
				</fieldset>
				
				<fieldset class="s430 right fset">
					<legend>รูปสินค้า</legend>
					
					<div id="div_img" class="center txt_center min_h240">
						<div class="min_h240 center txt_center" style="width: 320px; box-shadow: 0 0px 3px rgba(0,0,0,0.3);">
							<img width="320" height="240" src="../path_images/inventory/<%=mat_code%>.jpg?state=<%=Math.random()%>">
						</div>
						
						<div class="m_top10">
							<input type="radio" name="uploadType" id="upImg"> <label for="upImg">อัพโหลดจากไฟล์</label> &nbsp;&nbsp; 
							<input type="radio" name="uploadType" id="camImg"> <label for="camImg">ถ่ายภาพจากเวปแคม</label>
							<script type="text/javascript">
							$(function(){
								$('#upImg').click(function(){
									if ($('#upImg').is(':checked')) {
										$('#uploadImg').fadeIn(500);
										$('#webcam').hide();
									}
								});
								
								$('#camImg').click(function(){
									if ($('#camImg').is(':checked')) {
										$('#uploadImg').hide();
										$('#webcam').fadeIn(500);
									}
								});
								
								if ($('#upImg').is(':checked')) {
									$('#uploadImg').show();
									$('#webcam').hide();
								}
								
								if ($('#camImg').is(':checked')) {
									$('#uploadImg').hide();
									$('#webcam').show();
								}
							});
							</script>
						</div>
					</div>
					
					<div id="uploadImg" class="txt_center center hide">
						<form enctype="multipart/form-data" method="post" action="" name="imgForm" style="margin: 0px; padding: 0px;">
							<input type="file" id="fileToUpload" name="fileToUpload" readonly="readonly" class="txt_box" onchange="return ajaxImgUpload();">
						</form>
					</div>
					
					<div id="webcam" class="s400 txt_center center hide"></div>
					<div class="clear"></div>
				</fieldset>
				
				<div class="clear"></div>
				
				<fieldset class="s430 fset">
					<legend>สินค้าที่ใช้ทดแทน</legend>
					รอพบกับฟังก์ชั่นสินค้าที่ใช้ทดแทนเร็ว ๆ นี้
				</fieldset>
				
				<div class="clear"></div>
				
				<%if(!(invMaster.getGroup_id().equalsIgnoreCase("FG") || invMaster.getGroup_id().equalsIgnoreCase("SS"))){%>
				<fieldset class="s900 fset">
					<legend>ข้อมูลตัวแทนจำหน่าย</legend>
					<table class="bg-image s700">
						<thead>
							<tr>
								<th valign="top" align="center" width="30%">ชื่อตัวแทนจำหน่าย</th>
								<th valign="top" align="center" width="25%">จัดส่งขั้นต่ำ</th>
								<th valign="top" align="center" width="25%">เวลาจัดส่ง</th>
							</tr>
						</thead>
						<tbody id="vendor_list">
						<%
						Iterator ite = InventoryMasterVendor.selectList(mat_code).iterator();
						while(ite.hasNext()) {
							InventoryMasterVendor masterVendor = (InventoryMasterVendor) ite.next();
							Vendor vendor = masterVendor.getUIVendor();
						%>
							<tr id="vendor_<%=vendor.getVendor_id()%>">
								<td><%=vendor.getVendor_name()%></td>
								<td align="center"><%=masterVendor.getVendor_moq()%></td>
								<td align="center"><%=masterVendor.getVendor_delivery_time()%></td>
							</tr>
						<%
						}
						%>
						</tbody>
					</table>
					
					<div class="center txt_center m_top5">
						<button class="btn_box" onclick="javascript: window.location='material_edit_vendor.jsp';">แก้ไขข้อมูลตัวแทนจำหน่าย</button>
					</div>
				</fieldset>
				
				<fieldset class="s900 fset">
					<legend>รายการ Lot (คลิกที่รายการ เพื่อแก้ไข)</legend>
					<table class="bg-image s900">
						<thead>
							<tr>
								<th valign="top" align="center" width="12%">Lot เลขที่ </th>
								<th valign="top" align="center" width="14%">เลขที่ใบสั่งซื้อ</th>
								<th valign="top" align="center" width="14%">เลขที่ใบแจ้งหนี้</th>
								<th valign="top" align="center" width="12%">วันที่นำเข้า</th>
								<th valign="top" align="center" width="12%">วันหมดอายุ</th>
								<th valign="top" align="center" width="16%">ราคา/หน่วย</th>
								<th valign="top" align="center" width="10%">ยอดนำเข้า</th>
								<th valign="top" align="center" width="10%">ยอดคงเหลือ</th>
								
							</tr>
						</thead>
						<tbody>
						<%
						String up = "0";
						Double total = 0.0;
						Iterator iteLot = InventoryLot.selectActiveList(mat_code).iterator();
						while (iteLot.hasNext()){
							InventoryLot lot = (InventoryLot) iteLot.next();
							InventoryLotControl lotctrl = lot.getUILot_control();
							total += Double.parseDouble(lotctrl.getLot_balance());
						%>
							<tr>
								<td align="right"><div class="thickbox pointer" title="แก้ไขข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_edit.jsp?lot_no=<%=lot.getLot_no()%>"><%=lot.getLot_no()%></div></td>
								<td><div class="thickbox pointer" title="แก้ไขข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_edit.jsp?lot_no=<%=lot.getLot_no()%>"><%=lot.getPo()%></div></td>
								<td><div class="thickbox pointer" title="แก้ไขข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_edit.jsp?lot_no=<%=lot.getLot_no()%>"><%=lot.getInvoice()%></div></td>
								<td align="center"><div class="thickbox pointer" title="แก้ไขข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_edit.jsp?lot_no=<%=lot.getLot_no()%>"><%=WebUtils.getDateValue(lot.getCreate_date())%></div></td>
								<td align="center"><div class="thickbox pointer" title="แก้ไขข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_edit.jsp?lot_no=<%=lot.getLot_no()%>"><%=WebUtils.getDateValue(lot.getLot_expire())%></div></td>
								<td align="right"><div class="thickbox pointer" title="แก้ไขข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_edit.jsp?lot_no=<%=lot.getLot_no()%>"><%=lot.getLot_price()%></div></td>
								<td align="right"><div class="thickbox pointer" title="แก้ไขข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_edit.jsp?lot_no=<%=lot.getLot_no()%>"><%=lot.getLot_qty()%></div></td>
								<td align="right"><div class="thickbox pointer" title="แก้ไขข้อมูลสินค้า Lot NO. <%=lot.getLot_no()%>" lang="lot_edit.jsp?lot_no=<%=lot.getLot_no()%>"><%=lotctrl.getLot_balance()%></div></td>
							</tr>
						<%
						}
						if (invMaster.getUnit_pack().length()>0){
							up = WebUtils.getInteger(Money.divide(total+"", invMaster.getUnit_pack())) + "";
						}
						%>
							<tr>
								<td colspan="8" align="right" class="txt_bold">ยอดที่สามารถเบิกได้: <%=Money.money(total)%> <%=invMaster.getStd_unit()%> [ <%=up%> <%=invMaster.getDes_unit()%> ]</td>
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
								<th valign="top" align="center" width="20%">Lot เลขที่ </th>
								<th valign="top" align="center" width="20%">เลขที่ใบสั่งผลิต</th>
								<th valign="top" align="center" width="20%">วันที่นำเข้า</th>
								<th valign="top" align="center" width="20%">ยอดนำเข้า</th>
								<th valign="top" align="center" width="20%">ยอดคงเหลือ</th>
							</tr>
						</thead>
						<tbody>
						<%
						String up = "0";
						Double total = 0.0;
						Iterator iteLot = InventoryLot.selectActiveList(mat_code).iterator();
						while (iteLot.hasNext()){
							InventoryLot lot = (InventoryLot) iteLot.next();
							InventoryLotControl lotCtrl = lot.getUILot_control();
							total += Double.parseDouble(lotCtrl.getLot_balance());
						%>
							<tr>
								<td><%=lot.getLot_no()%></td>
								<td><%=lot.getPo()%></td>
								<td align="center"><%=WebUtils.getDateValue(lot.getCreate_date())%></td>
								<td align="right"><%=lot.getLot_qty()%></td>
								<td align="right"><%=lotCtrl.getLot_balance()%></td>
							</tr>
						<%
						}
						if (invMaster.getUnit_pack().length()>0){
							up = WebUtils.getInteger(Money.divide(total+"", invMaster.getUnit_pack())) + "";
						}
						%>
							<tr>
							<% if(invMaster.getGroup_id().equalsIgnoreCase("FG")){ %>
								<td colspan="6" align="right" class="txt_bold">ยอดที่สามารถเบิกได้: <%=up + " " + invMaster.getDes_unit()%> ]</td>
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
<script language="JavaScript">
$("#webcam").webcam({
	upload_url: 'PhotoSnap?name=<%=mat_code%>&action=material',
	redirect_url: 'material_view.jsp?mat_code=<%=mat_code%>'
});
</script>
</body>
</html>