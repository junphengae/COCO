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

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/number.js"></script>

<!-- Date -->
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>


<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inlet</title>
<%
	String mat_code = WebUtils.getReqString(request, "mat_code");
	session.removeAttribute("LOT");
	session.removeAttribute("LOT_LIST");
	InventoryMaster master = new InventoryMaster();
	WebUtils.bindReqToEntity(master, request);
	InventoryMaster.select(master);
%>
<script type="text/javascript">
$(function(){
	
	$('#lot_expire').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeYear : true,
		changeMonth : true,
		yearRange: 'c-5:c+10'
	});
	
	$('#lot_expire_pd').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeYear : true,
		changeMonth : true,
		yearRange: 'c-5:c+10'
	});
	
	
	$.metadata.setType("attr", "validate");
	check_material();
	
	$('#btn_invoice_qty_show').click(function(){
		if ($('#invoice_form #po').val() != '') {
			$('#tb_invoice_detail').show();
			$(this).fadeOut('slow');
		}
	});
	
	/** --------------- product form --------------------- **/
	var product_form = $('#product_form');
	var product_validate = product_form.validate({
		submitHandler: function(){	
			if($('#lot_qty').val() == 0){
				alert("จำนวนไม่ถูกต้อง!");
			}else{
				if (confirm('ยืนยันการนำเข้าสินค้า หมายเลข ' + $('#product_mat_code').val() + '\n\rจำนวน ' + parseFloat($('#product_form #lot_qty').val()) + ' เข้าสู่คลังสินค้า\n\r\n\r** คุณจะไม่สามารถแก้ไขข้อมูลการนำเข้าได้หลังจากกดตกลง **')) {
					ajax_load();
					$.post('InletManagement',product_form.serialize(),function(resData){
						ajax_remove();
						if (resData.status == 'success') {
							window.location='inlet_product_info.jsp?lot_no=' + resData.LOT.lot_no + '&mat_code=' + resData.LOT.mat_code;
						} else {
							alert(resData.message);
						}
					},'json');
				}
			}
		}
	});
	
	product_form.submit(function(){
		product_validate;
		return false;
	});
	
	$('#btn_product_qty_show').click(function(){
		if ($('#product_form #po').val() != '') {
			
			var data = {
				'action':'check_product',
				'item_id':$('#mat_code').val(),
				'pro_id':$('#product_form #po').val()
			   };
				
			$.post('InletManagement',data,function(resData){
				if (resData.status == 'success') {
					if(resData.check == true){
						$('#tb_product_detail').show();
						$('#btn_product_qty_show').hide();
						$('#product_form #po').attr('readonly','readonly');
					}else{
						alert("กรุณาระบุหมายเลขโปรดักชั่นให้ถูกต้อง!");
					}
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	
	$('#mat_code').keypress(function(e){
		if (e.keyCode == 13) {
			check_material();
		}
	});
});

function check_material(){
	var tb_check_mat = $('#tb_check_mat');
	
	var tb_show_mat = $('#tb_show_mat');
	var td_mat_code = $('#td_mat_code');
	var td_mat_description = $('#td_mat_description');
	var td_mat_ref_code = $('#td_mat_ref_code');
	var td_mat_location = $('#td_mat_location');
	var td_mat_fifo = $('#td_mat_fifo');
	var td_mat_std_unit = $('#td_mat_std_unit');
	var td_mat_des_unit = $('#td_mat_des_unit');
	var td_mat_unit_pack = $('#td_mat_unit_pack');
	
	var tb_input_invoice = $('#tb_input_invoice');
	var tb_input_product = $('#tb_input_product');
	
	var mat_code = $('#mat_code');
	if (mat_code.val() != '') {
		$('#invoice_mat_code').val(mat_code.val());
		$('#product_mat_code').val(mat_code.val());
		$('#btn_see_photo').attr({'title':'รูปสินค้า ' + mat_code.val(), 'lang':'../info/view_img.jsp?width=400&height=300&img=' + mat_code.val()});
		ajax_load();
		$.post('InletManagement',{'action': 'check_material','mat_code':mat_code.val()},function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var mat = resData.material;
				
				tb_check_mat.hide();
				
				td_mat_code.append(mat.mat_code);
				td_mat_description.append(mat.description);
				td_mat_ref_code.append(mat.ref_code);
				td_mat_location.append(mat.location);
				td_mat_fifo.append((mat.fifo_flag == 'y')?'FIFO':'Non FIFO');
				td_mat_std_unit.append(mat.std_unit);
				td_mat_des_unit.append(mat.des_unit);
			
				
				td_mat_unit_pack.append(mat.unit_pack);
				tb_show_mat.show();
				
				$('#group_id').val(mat.group_id);
				if (mat.group_id == 'SS' || mat.group_id == 'MT') {
					$('#description').text("KG");
				}else{
					$('#description').text(mat.des_unit);
				}
				
				if (mat.group_id == 'SS') {
					tb_input_product.show();
					$('#product_form #po').focus();
				} else {
					tb_input_invoice.show();
					$('#invoice_form #po').focus();
				}
			} else {
				if (resData.action == 'redirect') {
					alert(resData.message);
					window.location='material_view.jsp?mat_code=' + mat_code.val();
				} else {
					alert(resData.message);
					mat_code.focus();
				}
			}
		},'json');
	} else {
		mat_code.focus();
	}
}
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">
					1: รับเข้าสินค้า
				</div>
				<div class="right m_right20">
					<div class="pointer thickbox" id="btn_see_photo" title="รูปสินค้า <%=mat_code%>" lang="../info/view_img.jsp?width=400&height=300&img=<%=mat_code%>"><img src="../images/btn_see_photo.png" width="30" height="24" title="ดูรูป" alt="ดูรูป"></div>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<%if(!(mat_code.length()>0)){ %>
				<div class="center txt_center" id="inlet_nav">
					<button class="btn_box" onclick="window.location='inlet_invoice.jsp';">รับเข้าจากการสั่งซื้อ</button>
					<button class="btn_box" onclick="$('#tb_check_mat').show();$('#inlet_nav').hide();">รับเข้าจากการผลิต</button>
				</div>
				<%}%>
				
				<table width="100%" id="tb_check_mat" class="hide">
					<tbody>
						<tr>
							<td width="25%">รหัสสินค้า</td>
							<td width="75%">: 
								<input type="text" autocomplete="off" name="mat_code" id="mat_code" class="txt_box s150" value="<%=mat_code%>">
								<button class="btn_box" onclick="check_material();">ตรวจสอบ</button>
							</td>
						</tr>
					</tbody>
				</table>
						
				<table width="100%" id="tb_show_mat" class="hide">
					<tbody>
						<tr>
							<td width="25%">รหัสสินค้า</td>
							<td width="75%" id="td_mat_code">: </td>
						</tr>
						<tr>
							<td>ชื่อสินค้า</td>
							<td id="td_mat_description">: </td>
						</tr>
						<tr>
							<td>รหัสเดิม</td>
							<td id="td_mat_ref_code">: </td>
						</tr>
						<tr>
							<td>สถานที่เก็บ</td>
							<td id="td_mat_location">: </td>
						</tr>
						<tr>
							<td>ลักษณะการจัดเก็บ</td>
							<td id="td_mat_fifo">: </td>
						</tr>
						<tr>
							<td>หน่วยนับ</td>
							<td id="td_mat_std_unit">: </td>
						</tr>
						<tr>
							<td>ลักษณะบรรจุภัณฑ์</td>
							<td id="td_mat_des_unit">: </td>
						</tr>
						<tr>
							<td>ปริมาตร/บรรจุภัณฑ์</td>
							<td id="td_mat_unit_pack">: </td>
						</tr>
					</tbody>
				</table>
				
				<div class="m_top15"></div>
				<input type="hidden" id="group_id" value="">

<!-- ****************   product_form ********************** -->

				<form id="product_form" onsubmit="return false">
					<table width="100%" id="tb_input_product" class="hide">
						<tbody>
							<tr>
								<td width="25%">เลขที่ใบสั่งผลิต</td>
								<td width="75%">: 
									<input type="text" class="txt_box required" name="po" id="po" autocomplete="off" title="ระบุเลขที่ใบสั่งผลิต!">
									<button type="button" class="btn_box" id="btn_product_qty_show">ต่อไป</button>
								</td>
							</tr>
						</tbody>
					</table>
					<table width="100%" id="tb_product_detail" class="hide">
						<tbody>
							<tr>
								<td width="25%">จำนวน</td>
								<td width="75%">: <input type="text" class="txt_box required" name="lot_qty" id="lot_qty" autocomplete="off" title="ระบุเจำนวน!"> <span id="description"></span></td>
							</tr>
							<tr>
								<td>วันหมดอายุ</td>
								<td>: <input type="text" name="lot_expire" id="lot_expire_pd" class="txt_box" autocomplete="off"></td>
							</tr>
							<tr>
								<td>หมายเหตุ</td>
								<td>: <input type="text" class="txt_box" name="note" autocomplete="off"></td>
							</tr>
							<tr>
								<td colspan="2" align="center" height="30">
									<input type="submit" name="add" class="btn_box" value="รับเข้า">
									<input type="hidden" name="action" value="inlet">
									<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									<input type="hidden" name="mat_code" id="product_mat_code" value="">
								</td>
							</tr>
						</tbody>
					</table>
				</form>
<!-- ****************   product_form ********************** -->				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>