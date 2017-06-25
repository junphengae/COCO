<%@page import="com.bitmap.bean.inventory.WithdrawType"%>
<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
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
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<jsp:useBean id="invMaster" class="com.bitmap.bean.inventory.InventoryMaster" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Outlet fg</title>
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>
<script src="../js/number.js"></script>
<%
	String mat_code = invMaster.getMat_code();
%>
<script type="text/javascript">
$(function(){
	$('#lot_no').focus();
	$('#btn_info').click(function(){
		
	});
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
					1: เบิกสินค้า
				</div>
				<div class="right m_right20">
					<div class="pointer thickbox" id="btn_see_photo" title="รูปสินค้า <%=mat_code%>" lang="../info/view_img.jsp?width=400&height=300&img=<%=mat_code%>"><img src="../images/btn_see_photo.png" width="30" height="24" title="ดูรูป" alt="ดูรูป"></div>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<!-- ข้อมูลสินค้า -->
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
							<tr>
								<td>ลักษณะการจัดเก็บ</td>
								<td>: <%=(invMaster.getFifo_flag().equalsIgnoreCase("y"))?"FIFO":"Non FIFO"%></td>
							</tr>
							<tr>
								<td>รหัสเดิม</td>
								<td>: <%=invMaster.getRef_code()%></td>
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
						</tbody>
					</table>
				</fieldset>
				
				<!-- ข้อมูลการเบิก -->
				<form id="withdrawForm" onsubmit="return false;">
				<fieldset class="s430 right fset">
					<legend>ข้อมูลการเบิก</legend>					
					<table width="100%">
						<tbody>
							<tr id="tr_lot_no">
								<td width="30%">Lot สินค้า</td>
								<td width="70%">: <input type="text" autocomplete="off" name="lot_no" id="lot_no" class="txt_box s150"></td>
							</tr>		
						</tbody>
					</table>
					<table width="100%" id="tb_input" class="hide">
						<tbody>
							<tr>
								<td width="30%">จำนวนสินค้าใน Lot</td>
								<td width="70%">: <span id="lot_balance"></span> <%=invMaster.getDes_unit()%></td>
							</tr>
							<tr><td colspan="2" height="20"></td></tr>
							<tr>
								<td>จำนวนที่เบิก</td>
								<td>: <input type="text" autocomplete="off" name="request_qty" id="request_qty" class="txt_box s150"> <%=invMaster.getDes_unit()%></td>
							</tr>
							<tr>
								<td>เลขอ้างอิงการเบิก</td>
								<td>: <input type="text" autocomplete="off" name="request_no" id="request_no" class="txt_box s150"></td>
							</tr>
							<tr>
								<td>ผู้เบิกสินค้า </td>
								<td>: 
									<input type="text" class="txt_box" id="request_by_autocomplete">
								</td>
							</tr>
							<tr><td colspan="2" height="10"></td></tr>
							<tr>
								<td colspan="2" align="center">
									<button type="button" class="btn_box" id="btn_withdraw">เบิกสินค้า</button>
									<input type="hidden" name="request_by" id="request_by">
									<input type="hidden" name="lot_id" id="lot_id">
									<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									<input type="hidden" name="action" value="withdraw_ss_fg"> 
									<input type="hidden" name="lot_balance" value="">
									<input type="hidden" name="mat_code" value="<%=mat_code%>">
								</td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				</form>
					<script type="text/javascript">
					var lot_no = $('#lot_no');
					var tb_input = $('#tb_input');
					var lot_balance = $('#lot_balance');
					var request_qty = $('#request_qty');
					
					lot_no.keypress(function(e){
						if(e.keyCode == 13){
							ajax_load();
							$.post('OutletManagement',{action:'check_fifo',mat_code:'<%=mat_code%>',lot_no:$(this).val()},function(resData){
								ajax_remove();
								if (resData.status == 'success') {
									lot_no.attr('readOnly',true);
									tb_input.fadeIn(300);
									
									var lot_ctrl = resData.lot.lot_control;
									lot_balance.text(lot_ctrl.lot_balance);
									$('input[name=lot_balance]').val(lot_ctrl.lot_balance);
									$('#lot_id').val(lot_ctrl.lot_id);
									
									request_qty.focus();
								} else {
									alert(resData.message);
								}
							},'json');
						}
					});
					
					$("#request_by_autocomplete").autocomplete({
					    source: "GetEmployee",
					    minLength: 2,
					    select: function(event, ui) {
					       $('#request_by').val(ui.item.id);
					    }
					});

					$('#btn_withdraw').click(function(){
						var reqVal = parseFloat(request_qty.val()) ;
						var balanceVal = parseFloat(lot_balance.text());
						if(isNumber(request_qty.val())){
							if(reqVal != ""){						
								if (reqVal>balanceVal) {
									alert('จำนวนที่ต้องการเบิกมากกว่าจำนวนที่มีในสต๊อก');
									request_qty.focus();
								}else{
									if ($('#request_no').val()!="") {
										if($('#request_by').val()!=""){
											ajax_load();
											var data = $('#withdrawForm').serialize();
											//alert(data);
											$.post('OutletManagement',data,function(resData){
												ajax_remove();
												if (resData.status == 'success') {
													alert('เบิกสินค้าเรียบร้อย');
													window.location = 'outlet_control_fg.jsp';
												} else {
													alert(resData.message);
												}
											},'json');
										} else {
											alert('ยังไม่ได้ระบุผู้เบิกสินค้า!');
											$('#request_by').focus();
										}
									} else {
										alert('ยังไม่ได้ระบุเลขอ้างอิงการเบิก!');
										$('#request_no').focus();
									}
								}
							}
						}else{
							alert('กรุณาระบุจำนวนที่ต้องการเบิกเป็นตัวเลข');
							txt_request_qty.focus();
						}
					});
					</script>
				
				<div class="clear"></div>
				<!-- ข้อมูลสินค้า -->
				
				
				<fieldset class="s900 fset">
					<legend>รายการ Lot</legend>
					<table class="bg-image s900">
						<thead>
							<tr>
								<th valign="top" align="center" width="20%">Lot เลขที่ </th>
								<th valign="top" align="center" width="20%">เลขที่ใบสั่งผลิต</th>
								<th valign="top" align="center" width="30%">วันที่นำเข้า</th>
								<th valign="top" align="center" width="15%">ยอดนำเข้า</th>
								<th valign="top" align="center" width="15%">ยอดคงเหลือ</th>
							</tr>
						</thead>
						<tbody>
						<%
						String up = "0";
						Double total = 0.0;
						Iterator iteLot = InventoryLot.selectActiveList(mat_code).iterator();
						while (iteLot.hasNext()){
							InventoryLot lot = (InventoryLot) iteLot.next();
							InventoryLotControl lot_control = lot.getUILot_control();
							total += Double.parseDouble(lot_control.getLot_balance());
						%>
							<tr>
								<td><%=lot.getLot_no()%></td>
								<td><%=lot.getPo()%></td>
								<td align="center"><%=WebUtils.getDateTimeValue(lot.getCreate_date())%></td>
								<td align="right"><%=lot.getLot_qty()%></td>
								<td align="right"><%=lot_control.getLot_balance()%></td>
							</tr>
						<%
						}
						%>
							<tr>
								<td colspan="5" align="right" class="txt_bold">ยอดที่สามารถเบิกได้: <%=Money.money(total)%> <%=invMaster.getDes_unit()%></td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>