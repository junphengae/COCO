<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.inventory.SubCategories"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.rd.*"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>


<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%
InventoryMaster master = new InventoryMaster();
RDFormular formular = new RDFormular();
WebUtils.bindReqToEntity(formular, request);
boolean update = false;
if(formular.getMat_code().length() > 0) {
	RDFormular.select(formular);
	master = formular.getUIMat();
	update = true;
}


/*
ชื่อลูกค้า
หมายเหตุของสูตร
ชื่อสี
รายการ matching ผู้ทำ วันที่ หมายเหตุของ matching
*/
%>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>สร้างสูตรการผลิต (Create Formular)</title>

<script type="text/javascript">
	$(function(){
		$('#date_matching').datepicker({
			showOtherMonths : true,
			slectOtherMonths : true,
			changeYear : true,
			changeMonth : true,
			yearRange: 'c-5:c+10'
		});
		
		$('input[name=fifo_flag]:radio').val(['<%=master.getFifo_flag()%>']);
		
		var formular_init_form = $('#formular_init_form');	
		$.metadata.setType("attr", "validate");
		var v_init = formular_init_form.validate({
			submitHandler: function(){
				ajax_load();
				$.post('RDManagement',formular_init_form.serialize() + "&unit_pack=" + $('#volume').val(),function(resData){			
					ajax_remove();
					if (resData.status == 'success') {
						window.location='formular_new.jsp?mat_code='+resData.mat.mat_code;
					} else {
						alert(resData.message);	
						//$('#' + resData.focus).focus();
					}
				},'json');
			}
		});	
		
		
		formular_init_form.submit(function(){			
			v_init;					
			return false;
		});		
		
		
		var formular_form = $('#formular_info_form');	
		$.metadata.setType("attr", "validate");
		var v = formular_form.validate({
			submitHandler: function(){
				ajax_load();
				$.post('RDManagement',formular_form.serialize(),function(resData){			
					ajax_remove();
					if (resData.status == 'success') {
						window.location='formular_step.jsp?mat_code=<%=formular.getMat_code()%>';
					} else {
						alert(resData.message);
					}
				},'json');
			}
		});	
		
		formular_form.submit(function(){			
			v;					
			return false;
		});		
		
		$('#group_id').change(function(){
			ajax_load();
			if($('#group_id').val() == 'FG') {
				$('#tr_brand').fadeIn(100);
			}else{
				$('#tr_brand').hide();
			}
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
		
		if($('#group_id').val() != "") {
			$('#new_cat').fadeIn(500).attr('lang','../info/cat_new.jsp?height=300&width=520&group_id=' + $('#group_id').val());
			$('#edit_cat').hide();
			$('#edit_sub_cat').hide();
			$('#new_sub_cat').hide();
			if($('#group_id').val() == 'FG') {
				$('#tr_brand').fadeIn(100);
			}else{
				$('#tr_brand').hide();
			}
		}
		
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
		
		if($('#cat_id').val() != "") {
			$('#new_sub_cat').fadeIn(500).attr('lang','../info/sub_cat_new.jsp?height=300&width=520&cat_id=' + $('#cat_id').val() + '&group_id=' + $('#group_id').val());
			$('#edit_cat').fadeIn(500);
			var attr = '../info/cat_edit.jsp?height=300&width=520&cat_id=' + $('#cat_id').val() + '&group_id=' + $('#group_id').val();
			$('#edit_cat').attr('lang',attr);
			$('#edit_sub_cat').hide();
		}
		
		if($('#sub_cat_id').val() != "") {
			$('#edit_sub_cat').fadeIn(500);
			var attr = '../info/sub_cat_edit.jsp?height=300&width=520&sub_cat_id=' + $('#sub_cat_id').val() + '&cat_id=' + $('#cat_id').val() + '&group_id=' + $('#group_id').val();
			$('#edit_sub_cat').attr('lang',attr);
		}
	});
</script>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">สร้างสูตรการผลิต</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="formular_init_form" onsubmit="return false;">
					<fieldset class="fset s900">
						<legend>&nbsp;กำหนดข้อมูลพื้นฐาน&nbsp;</legend>
						<div class="left s500">
							<table width="100%" id="tb_formular" border="0">
								<tbody>		
									<tr>
										<td width="130" align="left">ชื่อสินค้า</td>
										<td width="400">: <input type="text" autocomplete="off" name="description" id="description" class="txt_box s200 required" title="*ระบุ" value="<%=master.getDescription()%>"></td>
									</tr>
									<%if(update){%>
									<tr>
										<td width="100" align="left">รหัสสินค้า</td>
										<td width="250">: <%=master.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + master.getUISubCat().getUICat().getCat_name_short() + ((master.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + master.getUISubCat().getSub_cat_name_short():"") + "-" + master.getMat_code()%></td>
									</tr>
									<%}%>
									<tr>
										<td width="130" align="left">กลุ่ม</td>
										<td width="400">: 
											<bmp:ComboBox name="group_id" styleClass="txt_box s150" listData="<%=Group.ddl_formularGroup()%>" value="<%=master.getGroup_id()%>" validate="true" validateTxt="เลือกกลุ่ม!">
												<bmp:option value="" text="--- เลือกกลุ่ม ---"></bmp:option>
											</bmp:ComboBox>
											<script type="text/javascript">										
												$('#group_id').change(function(){
													if($(this).val() != "") {
														$('#new_cat').fadeIn(500).attr('lang','../info/cat_new.jsp?height=300&width=520&group_id=' + $(this).val());
														$('#edit_cat').hide();
														$('#edit_sub_cat').hide();
														$('#new_sub_cat').hide();
													} else {
														$('#new_cat').hide();
														$('#edit_cat').hide();
														$('#edit_sub_cat').hide();
														$('#new_sub_cat').hide();
													}
												});
											</script>
										</td>
									</tr>
									<tr>
										<td align="left">ชนิด</td>
										<td>: 
											<bmp:ComboBox name="cat_id" styleClass="txt_box s150" listData="<%=Categories.ddl_th(master.getUISubCat().getUICat().getUIGroup().getGroup_id())%>" value="<%=master.getUISubCat().getUICat().getCat_id()%>" validate="true" validateTxt="เลือกชนิด!">
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
										<td align="left">ชนิดย่อย</td>
										<td>: 
											<bmp:ComboBox name="sub_cat_id" styleClass="txt_box s150" listData="<%=SubCategories.ddl_th(master.getUISubCat().getUICat().getCat_id(),master.getUISubCat().getUICat().getUIGroup().getGroup_id())%>" value="<%=master.getUISubCat().getSub_cat_id()%>" validateTxt="เลือกชนิดย่อย!">
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
									<tr>
										<td align="left">รหัสเดิม</td>
										<td>: <input type="text" autocomplete="off" name="ref_code" id="ref_code" class="txt_box s200" value="<%=master.getRef_code()%>"></td>
									</tr>
									<tr><td colspan="2" height="20"></td></tr>
									<tr>
										<td>ลักษณะการจัดเก็บ</td>
										<td>: 
											<input type="radio" name="fifo_flag" id="fifo_flag_y" class="txt_box" value="y"><label for="fifo_flag_y"> FIFO</label> &nbsp;&nbsp;
											<input type="radio" name="fifo_flag" id="fifo_flag_n" class="txt_box" value="n"><label for="fifo_flag_n"> Non FIFO</label>
										</td>
									</tr>
									<tr>
										<td>ราคากลาง</td>
										<td>: <input type="text" autocomplete="off" name="price" class="txt_box s60" title="ระบุราคากลาง(เป็นตัวเลขเท่านั้น)!" value="<%=master.getPrice()%>"></td>
									</tr>
									<tr>
										<td>ต้นทุน</td>
										<td>: <input type="text" autocomplete="off" name="cost" class="txt_box s60" value="<%=master.getCost()%>"></td>
									</tr>
								</tbody>		
							</table>
						</div>
						
						<div class="left s400">
							<table width="100%" id="tb_formular" border="0">
								<tbody>
									<tr>
										<td align="left">R&amp;D Yield (%)</td>
										<td>: <input type="text" class="txt_box s200" name="yield" value="<%=formular.getYield()%>"></td>
									</tr>
									<tr>
										<td align="left">ปริมาตรบรรจุ</td>
										<td>: <input type="text" class="txt_box s200" name="volume" id="volume" value="<%=formular.getVolume()%>"></td>
									</tr>
									<tr>
										<td>หน่วยนับ</td>
										<td>: <input type="text" autocomplete="off" name="std_unit" class="txt_box required" title="ระบุหน่วยนับ!" value="<%=master.getStd_unit()%>"></td>
									</tr>
									<tr>
										<td>ลักษณะผลิตภัณฑ์</td>
										<td>: <input type="text" autocomplete="off" name="des_unit" class="txt_box" title="ลักษณะผลิตภัณฑ์ ตัวอย่างเช่น ขวด, ถัง, กระป๊อง, ถุง, กระสอบ เป็นต้น" value="<%=master.getDes_unit()%>"></td>
									</tr>
									<tr>
										<td valign="top" align="left">หมายเหตุ</td>
										<td valign="top">: <textarea name="remark" rows="4" cols="20" class="txt_box s200 h50"><%=formular.getRemark()%></textarea></td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="clear"></div>
						
						<div class="center txt_center">
							<input type="hidden" name="action" value="formular_init">
							<input type="hidden" name="mat_code" value="<%=master.getMat_code()%>">
							<input type="hidden" name="<%=(update)?"update":"create"%>_by" value="<%=securProfile.getPersonal().getPer_id()%>">
							<input type="submit" name="init" id="btn_formular_init" class="btn_box btn_confirm" value="บันทึกข้อมูลพื้นฐาน">
						</div>
					</fieldset>
				</form>
				
				<%
				if(update){
					RDFormularInfo fmInfo = formular.getUIInfo();
				%>
				<%}%>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>