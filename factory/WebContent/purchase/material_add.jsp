<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/number.js"></script>

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Add Material</title>
<script type="text/javascript">
$(function(){
	$('#group_id').change(function(){
		ajax_load();
		$.post('GetCat',{group_id: $(this).val(),action:'get_cat_th'}, function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var options = '<option value="">--- เลือกชนิด ---</option>';
                var j = resData.cat;
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].cat_id + '">' + j[i].cat_name_th + '</option>';
	            }
             	$('#cat_id').html(options);
             	$('#sub_cat_id').html('<option value="">--- เลือกชนิดย่อย ---</option>');
			} else {
				alert(resData.message);
			}
        },'json');
	});
	
	$('#mat_code').keyup(function(){
	    this.value = this.value.toUpperCase();
	});
	
	$('#cat_id').change(function(){
		ajax_load();
		$.post('GetCat',{group_id:$('#group_id').val(),cat_id: $(this).val(),action:'get_sub_cat_th'}, function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var options = '<option value="">--- เลือกชนิดย่อย ---</option>';
                var j = resData.sub_cat;
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].sub_cat_id + '">' + j[i].sub_cat_name_th + '</option>';
	            }
             	$('#sub_cat_id').html(options);
			} else {
				alert(resData.message);
			}
        },'json');
	});
	
	
	var form = $('#material_form');
	
	$.metadata.setType("attr", "validate");
	var v = form.validate({
		submitHandler: function(){
			if (isNumber($('#unit_pack').val())) {
				ajax_load();
				$.post('MaterialManagement',form.serialize(),function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						if (!($('#group_id').val() == 'FG' || $('#group_id').val() == 'SS')) {
							window.location='material_add_vendor.jsp?mat_code=' + resData.mat.mat_code ;
						} else {
							window.location='material_view.jsp?mat_code=' + resData.mat.mat_code ;
						}
					} else {
						alert(resData.message);
					}
				},'json');
			} else {
				alert('ระบุปริมาณ/บรรจุภัณฑ์เป็นตัวเลขที่เท่านั้น!');
				$('#unit_pack').focus();
			}
		}
	});
	
	form.submit(function(){
		v;
		return false;
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
				1: สร้างข้อมูลสินค้า
			</div>
			
			<div class="content_body">
				
				<form id="material_form" onsubmit="return false">
					<table width="100%">
						<tbody>
							<tr>
								<td width="25%">กลุ่ม</td>
								<td width="75%">: 
									<bmp:ComboBox name="group_id" styleClass="txt_box s150" listData="<%=Group.ddl_th()%>" validate="true" validateTxt="เลือกกลุ่ม!">
										<bmp:option value="" text="--- เลือกกลุ่ม ---"></bmp:option>
									</bmp:ComboBox>
									<script type="text/javascript">										
										$('#group_id').change(function(){
											if($(this).val() != "") {
												if($(this).val() == 'FG'){
								             		$('#tb_brand').show();
								             	} else {
								             		$('#tb_brand').hide();
								             	}
												$('#new_cat').fadeIn(500).attr('lang','../info/cat_new.jsp?height=300&width=520&group_id=' + $(this).val());
												$('#edit_cat').hide();
												$('#edit_sub_cat').hide();
												$('#new_sub_cat').hide();
											} else {
												$('#new_cat').hide();
												$('#edit_cat').hide();
												$('#edit_sub_cat').hide();
												$('#new_sub_cat').hide();
												$('#tb_brand').hide();
											}
										});
									</script>
								</td>
							</tr>
							<tr>
								<td>ชนิด</td>
								<td>: 
									<bmp:ComboBox name="cat_id" styleClass="txt_box s150" validate="true" validateTxt="เลือกชนิด!">
										<bmp:option value="" text="--- เลือกชนิด ---"></bmp:option>
									</bmp:ComboBox>
									<input type="button" class="btn_box thickbox hide" id="new_cat" value="เพิ่มชนิด" lang="" title="เพิ่มชนิด">
									<input type="button" class="btn_box thickbox hide" id="edit_cat" value="แก้ไขชนิด" lang="" title="แก้ไขชนิด">
									<script type="text/javascript">										
										$('#cat_id').change(function(){
											if($(this).val() != "") {
												$('#new_sub_cat').fadeIn(500).attr('lang','../info/sub_cat_new.jsp?height=300&width=520&cat_id=' + $(this).val() + '&group_id=' + $('#group_id').val());
												$('#edit_cat').fadeIn(500);
												var attr = '../info/cat_edit.jsp?height=300&width=520&cat_id=' + $(this).val() + '&group_id=' + $('#group_id').val();
												$('#edit_cat').attr('lang',attr);
												$('#edit_sub_cat').hide();
											} else {
												$('#edit_cat').hide();
												$('#edit_sub_cat').hide();
												$('#new_sub_cat').hide();
											}
										});
									</script>
								</td>
							</tr>
							
							<!-- ชนิดย่อย -->
							<tr>
								<td>ชนิดย่อย</td>
								<td>: 
									<bmp:ComboBox name="sub_cat_id" styleClass="txt_box s150" validateTxt="เลือกชนิดย่อย!">
										<bmp:option value="" text="--- เลือกชนิดย่อย ---"></bmp:option>
									</bmp:ComboBox>
									<input type="button" class="btn_box thickbox hide" id="new_sub_cat" value="เพิ่มชนิดย่อย" lang="" title="เพิ่มชนิด">
									<input type="button" class="btn_box thickbox hide" id="edit_sub_cat" value="แก้ไขชนิดย่อย" lang="" title="แก้ไขชนิดย่อย">
									<script type="text/javascript">
										$('#sub_cat_id').change(function(){
											if($(this).val() != "") {
												$('#edit_sub_cat').fadeIn(500);
												var attr = '../info/sub_cat_edit.jsp?height=300&width=520&sub_cat_id=' + $(this).val() + '&cat_id=' + $('#cat_id').val() + '&group_id=' + $('#group_id').val();
												$('#edit_sub_cat').attr('lang',attr);
											} else {
												$('#edit_sub_cat').hide();
											}
										});
									</script>
								</td>
							</tr>	
							<!-- ชนิดย่อย -->
							
							<tr><td colspan="2" height="20"><div class="dot_line"></div></td></tr>
							<tr>
								<td>รหัสสินค้า **</td>
								<td>: <input type="text" autocomplete="off" name="mat_code" id="mat_code" class="txt_box s300 required" title="ระบุรหัสสินค้า!" maxlength="20"></td>
							</tr>
							<tr>
								<td>รหัสเดิม</td>
								<td>: <input type="text" autocomplete="off" name="ref_code" class="txt_box"></td>
							</tr>
							<tr>
								<td>ชื่อสินค้า</td>
								<td>: <input type="text" autocomplete="off" name="description" class="txt_box s300 required" title="ระบุชื่อสินค้า!"></td>
							</tr>
							<tr>
								<td colspan="2">
									<table width="100%" class="hide" id="tb_brand">
										<tbody>
											<tr>
												<td width="25%">ชื่อยี่ห้อ</td>
												<td width="75%">: <input type="text" autocomplete="off" name="brand_name" class="txt_box s300" title="ระบุชื่อยี่ห้อ!"></td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<td>ลักษณะการจัดเก็บ</td>
								<td>: 
									<input type="radio" name="fifo_flag" id="fifo_flag_y" class="txt_box" value="y" checked="checked"><label for="fifo_flag_y"> FIFO</label> &nbsp;&nbsp;
									<input type="radio" name="fifo_flag" id="fifo_flag_n" class="txt_box" value="n"><label for="fifo_flag_n"> Non FIFO</label>
								</td>
							</tr>
							<tr>
								<td>ราคากลาง</td>
								<td>: <input type="text" autocomplete="off" name="price" class="txt_box s60" title="ระบุราคากลาง(เป็นตัวเลขเท่านั้น)!"></td>
							</tr>
							<tr>
								<td>ต้นทุน</td>
								<td>: <input type="text" autocomplete="off" name="cost" class="txt_box s60"></td>
							</tr>
							<tr>
								<td>หน่วยนับ</td>
								<td>: <input type="text" autocomplete="off" name="std_unit" class="txt_box required" title="ระบุหน่วยนับ!"></td>
							</tr>
							<tr>
								<td>ลักษณะบรรจุภัณฑ์</td>
								<td>: <input type="text" autocomplete="off" name="des_unit" class="txt_box" title="ลักษณะผลิตภัณฑ์ ตัวอย่างเช่น ขวด, ถัง, กระป๊อง, ถุง, กระสอบ เป็นต้น"></td>
							</tr>
							<tr>
								<td>ปริมาณ/บรรจุภัณฑ์</td>
								<td>: <input type="text" autocomplete="off" name="unit_pack" id="unit_pack" class="txt_box required" title="ระบุปริมาณ/บรรจุภัณฑ์"></td>
							</tr>
							<tr>
								<td>สถานที่เก็บ</td>
								<td>: <input type="text" autocomplete="off" name="location" class="txt_box"></td>
							</tr>
							<tr>
								<td>จำนวนต่ำสุดที่ต้องสั่งเพิ่ม</td>
								<td>: <input type="text" autocomplete="off" name="mor" class="txt_box"></td>
							</tr>
							<tr>
								<td colspan="2" align="center" height="30">
									<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึก">
									<input type="reset" name="reset" class="btn_box" value="ยกเลิก" onclick="javascript: window.location.reload();">
									<input type="hidden" name="action" value="add_material">
									<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>