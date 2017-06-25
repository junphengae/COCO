<%@page import="com.bitmap.security.SecurityProfile"%>
<%@page import="com.bitmap.bean.hr.Division"%>
<%@page import="com.bitmap.bean.hr.Position"%>
<%@page import="com.bitmap.bean.hr.Department"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script type="text/javascript" src="../js/jquery.min.js"></script>
<script type="text/javascript" src="../js/thickbox.js"></script>
<script type="text/javascript" src="../js/loading.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="../js/jquery.metadata.js"></script>
<script type="text/javascript" src="../js/jquery.validate.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>เพิ่มพนักงานใหม่</title>

<script type="text/javascript">
$(function(){
	$( "#date_start" ).datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeYear: true,
		changeMonth: true
	});
	
	var form = $('#infoForm');
	var dep_id = $('#dep_id');
	var div_id = $('#div_id');
	var pos_id = $('#pos_id');
	
	dep_id.change(function(){
		ajax_load();
		$.getJSON('EmpManageServlet',{action:'getDivision',dep_id:$(this).val()},
			function(j){
				ajax_remove();
				var options = '<option value="">--- เลือกแผนก ---</option>';
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].div_id + '">' + j[i].div_name_th + '</option>';
	            }
             	div_id.html(options);
			}
		);
	});
	
	$.metadata.setType("attr", "validate");
	var v = form.validate({
		submitHandler: function(){
			ajax_load();
			$.post('EmpManageServlet',form.serialize(),function(data){
				ajax_remove();
				if (data.status == 'success') {
					window.location ="emp_info.jsp?per_id=" + data.per_id;
				} else {
					alert(data.message);
				}
			},'json');
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
				<div class="left">เพิ่มพนักงานใหม่</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
			
			<form id="infoForm" onsubmit="return false;" style="margin: 0;padding: 0;">
				<table cellpadding="3" cellspacing="3" border="0" class="center s550">
					<tbody>
						<tr>
							<td><label>คำนำหน้า</label></td>
							<td>: 
								<bmp:ComboBox name="prefix" styleClass="txt_box input_focus" width="100px">
									<bmp:option value="นาย" text="นาย"></bmp:option>
									<bmp:option value="นาง" text="นาง"></bmp:option>
									<bmp:option value="นางสาว" text="นางสาว"></bmp:option>
								</bmp:ComboBox>
							</td>
						</tr>
						<tr>
							<td width="20%"><label>ชื่อ</label></td>
							<td align="left">: <input type="text" autocomplete="off" name="name" id="name" class="txt_box s200 required" title="Please insert Name!"></td>
						</tr>
						<tr>
							<td><label>นามสกุล</label></td>
							<td align="left">: <input type="text" autocomplete="off" size="30" name="surname" id="surname" class="txt_box s200 required" title="Please insert Surname!"></td>
						</tr>
						<tr>
							<td><label>มือถือ</label></td>
							<td align="left">: <input type="text" autocomplete="off" size="30" name="mobile" id="mobile" class="txt_box s200"></td>
						</tr>
						<tr>
							<td><label>Email</label></td>
							<td align="left">: <input type="text" autocomplete="off" size="30" name="email" id="email" class="txt_box s200 email"></td>
						</tr>
						<tr>
							<td><label>ฝ่าย</label></td>
							<td align="left">: 
								<bmp:ComboBox name="dep_id" styleClass="txt_box" width="200px" listData="<%=Department.list()%>" validate="true" validateTxt="Please select Department!">
									<bmp:option value="" text="--- เลือกฝ่าย ---"></bmp:option>
								</bmp:ComboBox>
							</td>
						</tr>
						<tr>
							<td><label>แผนก</label></td>
							<td align="left">: 
								<bmp:ComboBox name="div_id" styleClass="txt_box" width="200px" validateTxt="Please select Division!">
									<bmp:option value="" text="--- เลือกแผนก ---"></bmp:option>
								</bmp:ComboBox>
							</td>
						</tr>
						<tr>
							<td><label>ตำแหน่ง</label></td>
							<td align="left">: 
								<bmp:ComboBox name="pos_id" styleClass="txt_box" width="200px" validate="true" validateTxt="Please select Position!" listData="<%=Position.list() %>">
									<bmp:option value="" text="--- เลือกตำแหน่ง ---"></bmp:option>
								</bmp:ComboBox>
							</td>
						</tr>
						<tr>
							<td><label>วันที่บรรจุ</label></td>
							<td align="left">: 
								<input type="text" autocomplete="off" name="date_start" id="date_start" class="txt_box s150">
							</td>
						</tr>
						<tr align="center" valign="bottom" height="30">
							<td colspan="2">
								<input type="submit" id="btnAdd" value="บันทึก" class="btn_box">
								<input type="hidden" name="action" value="add">
								<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
								<input type="reset" value="ยกเลิก" class="btn_box">
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