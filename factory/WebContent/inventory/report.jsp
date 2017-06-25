<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
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

<script src="../js/jquery-1.6.1.min.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/popup.js"></script>

<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.datepicker.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inventory Report</title>

<script type="text/javascript">
$(function(){
	$( "#date_start" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true
	});
	$( "#date_end" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true
	});
	var form = $('#report_form');
	var tr_type_time = $('#tr_type_time');
	var tr_date = $('#tr_date');
	var tr_month = $('#tr_month');
	var tr_matcode = $('#tr_matcode');
	var tr_lot_no = $('#tr_lot_no');
	
	
	$('#btn_view').click(function(){
		if($('#report_type').val() == ''){
			alert('กรุณาเลือกรายงานที่ต้องการ');
			$('#report_type').focus();
		}else{
			if ($('#report_type').val() == '<%=StatusUtil.INV_INLET%>' || $('#report_type').val() == '<%=StatusUtil.INV_OUTLET%>') {
				if ($('#type_date').is(':checked')) {
					if ($('#date_start').val() != '' || $('#date_end').val() != '') {
						popup('report_review.jsp?' + form.serialize());
					} else {
						alert('กรุณาระบุวันที่ให้ครบถ้วน !');
					}
				} else if ($('#type_month').is(':checked')) {
					popup('report_review.jsp?' + form.serialize());
				} else {
					alert('กรุณาเลือกช่วงเวลาที่ต้องการดูรายงาน');
				}
			} else {
				popup('report_review.jsp?' + form.serialize());
			}
		}
	});
	
	$('#btn_export').click(function(){
		if($('#report_type').val() == ''){
			alert('กรุณาเลือกรายงานที่ต้องการ');
			$('#report_type').focus();
		}else{
			if ($('#report_type').val() == '<%=StatusUtil.INV_INLET%>' || $('#report_type').val() == '<%=StatusUtil.INV_OUTLET%>') {
				if ($('#type_date').is(':checked')) {
					if ($('#date_start').val() != '' || $('#date_end').val() != '') {
						popup('report_review.jsp?export=true&' + form.serialize());
					} else {
						alert('กรุณาระบุวันที่ให้ครบถ้วน !');
					}
				} else if ($('#type_month').is(':checked')) {
					popup('report_review.jsp?export=true&' + form.serialize());
				} else {
					alert('กรุณาเลือกช่วงเวลาที่ต้องการดูรายงาน');
				}
			} else {
				popup('report_review.jsp?export=true&' + form.serialize());
			}
		}
	});
	
	
	
	$('#report_type').change(function(){
		if ($(this).val() == '<%=StatusUtil.INV_INLET%>' || $(this).val() == '<%=StatusUtil.INV_OUTLET%>') {
			$('#matcode').val("");
			$('#date_start').val("");
			$('#date_end').val("");
			tr_matcode.show();
			tr_type_time.show();
			tr_lot_no.show();
			$('input:radio[name=time]').removeAttr('checked');
			tr_date.hide();
			tr_month.hide();
		} else {
			$('#matcode').val("");
			tr_matcode.hide();
			tr_lot_no.hide();
			tr_type_time.hide();
			tr_date.hide();
			tr_month.hide();
		}
	});
	
	$('#type_date').click(function(){
		tr_date.show();
		tr_month.hide();
	});
	
	$('#type_month').click(function(){
		tr_date.hide();
		tr_month.show();
	});
});
</script>
<style type="text/css">
body table td {padding: 3px 1px;}
</style>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				รายงานคลังสินค้า
			</div>
			
			<div class="content_body">
			<form id="report_form">
				<table>
					<tr>
						<td width="100">ประเภท</td>
						<td>: 
							<bmp:ComboBox name="report_type" styleClass="txt_box s250" value="">
								<bmp:option value="" text="--- กรุณาเลือก ---"></bmp:option>
								<bmp:option value="<%=StatusUtil.INV_BALANCE%>" text="รายงานสินค้าคงคลัง"></bmp:option>
								<bmp:option value="<%=StatusUtil.INV_ACTIVE_LOT%>" text="รายงานสินค้าแยกตาม Lot"></bmp:option>
								<bmp:option value="<%=StatusUtil.INV_INLET%>" text="รายงานการนำเข้าสินค้า"></bmp:option>
								<bmp:option value="<%=StatusUtil.INV_OUTLET%>" text="รายงานการเบิกสินค้า"></bmp:option>
								<bmp:option value="<%=StatusUtil.INV_MOR%>" text="รายงานสินค้าเหลือน้อย"></bmp:option>
							</bmp:ComboBox>
						</td>
					</tr>
					<tr id="tr_matcode" class="hide">
						<td>รหัสสินค้า</td>
						<td>: 
							<input type="text" class="txt_box" name="mat_code" id="mat_code">
						</td>
					</tr>
					<tr id="tr_lot_no" class="hide">
						<td>เลขที่ Lot</td>
						<td>: 
							<input type="text" class="txt_box" name="lot_no" id="lot_no">
						</td>
					</tr>
					<tr id="tr_type_time" class="hide">
						<td>ช่วงเวลา</td>
						<td>: 
							<input type="radio" name="time" id="type_date" value="date"> <label for="type_date"> ประจำวัน</label> &nbsp;&nbsp;
							<input type="radio" name="time" id="type_month" value="month"> <label for="type_month"> ประจำเดือน</label>
						</td>
					</tr>
					<tr id="tr_date" class="hide">
						<td>ระหว่างวันที่</td>
						<td>: 	<input type="text" class="txt_box" name="create_date1" id="date_start">
						&nbsp;ถึงวันที่ &nbsp;
								<input type="text" class="txt_box" name="create_date2" id="date_end">
						</td>
					</tr>
					<tr id="tr_month" class="hide">
						<td>เดือน / ปี</td>
						<td>: 
							<bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value=""></bmp:ComboBox>
							<bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="null"></bmp:ComboBox>
						</td>
					</tr>
				</table>
				<div class="center txt_center"></div>
				<div class="center txt_center">
					<span class="btn_box btn_confirm" id="btn_view">ดูรายงาน</span>
					<span class="btn_box btn_confirm" id="btn_export">บันทึกเป็นไฟล์</span>
				</div>
			</form>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>