<%@page import="com.bmp.vendor.VendorTS"%>
<%@page import="com.bmp.vendor.VendorBean"%>
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
<% 
String vendor_id = WebUtils.getReqString(request,"vendor_id");
VendorBean ve = VendorTS.select(vendor_id);
%>
<script type="text/javascript">
$(function(){

	var form = $('#vendor_form_edit');

	$.metadata.setType("attr", "validate");
	var v = form.validate({
		submitHandler: function(){
			ajax_load();
			$.post('./VendorServlet',form.serialize(),function(data){
				ajax_remove();
				if (data.status == 'success') {					
					window.location='vendor_list.jsp';	
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
				<div class="left">ทะเบียนผู้ขาย|แก้ไขข้อมูลตัวแทนจำหน่าย</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
			
			<form id="vendor_form_edit" onsubmit="return false;" style="margin: 0;padding: 0;">
				<table cellpadding="3" cellspacing="3" border="0" class="center s550">
					<tbody>
						<tr>
							<td align="left" width="25%"><label>รหัสตัวแทนจำหน่าย</label></td>
							<td align="left" width="75%">: <input type="text" autocomplete="off" name="vendor_code"  id="vendor_code" value="<%=ve.getVendor_code()%>" maxlength="10" class="txt_box s150 input_focus required"></td>
						</tr>
						<tr>
							<td align="left" width="25%"><label>ชื่อตัวแทนจำหน่าย</label></td>
							<td align="left" width="75%">: <input type="text" autocomplete="off" name="vendor_name" id="vendor_name" value="<%=ve.getVendor_name()%>" class="txt_box s150 input_focus required"></td>
						</tr>
						<tr>
							<td><label>โทรศัพท์</label></td>
							<td>: <input type="text" autocomplete="off" name="vendor_phone" id="vendor_phone" value="<%=ve.getVendor_phone()%>"  class="txt_box s200"></td>
						</tr>
						<tr>
							<td><label>แฟกซ์</label></td>
							<td>: <input type="text" autocomplete="off" name="vendor_fax" id="vendor_fax" value="<%=ve.getVendor_fax()%>" class="txt_box s200"></td>
						</tr>
						<tr>
							<td><label>ที่อยุ่</label></td>
							<td>: <input type="text" autocomplete="off" name="vendor_address" id="vendor_address" value="<%=ve.getVendor_address()%>" class="txt_box s200"></td>
						</tr>
						<tr>
							<td valign="top"><label>Email</label></td>
							<td valign="top">: <input type="text" autocomplete="off" name="vendor_email" id="vendor_email" value="<%=ve.getVendor_email()%>" class="txt_box s200 email"></td>
						</tr>
						<tr>
							<td><label>ชื่อผู้ติดต่อ</label></td>
							<td>: <input type="text" autocomplete="off" name="vendor_contact" id="vendor_contact" value="<%=ve.getVendor_contact()%>" class="txt_box s200"></td>
						</tr>
						<tr>
							<td><label>เงื่อนไขการจัดส่ง</label></td>
							<td>: <input type="text" autocomplete="off" name="vendor_condition" id="vendor_condition" value="<%=ve.getVendor_condition()%>" class="txt_box s200"></td>
						</tr>
						<tr>
							<td><label>เครดิต</label></td>
							<td>: <input type="text" autocomplete="off" name="vendor_credit" id="vendor_credit" value="<%=ve.getVendor_credit()%>" class="txt_box s200"></td>
						</tr>
						<tr>
							<td><label>ประเภทการขนส่ง</label></td>
							<td>: 
								<bmp:ComboBox name="vendor_ship" styleClass="txt_box s100" value="<%=ve.getVendor_ship()%>">
									<bmp:option value="land" text="ทางบก"></bmp:option>
									<bmp:option value="sea" text="ทางเรือ"></bmp:option>
									<bmp:option value="air" text="ทางอากาศ"></bmp:option>
								</bmp:ComboBox>
							</td>
						</tr>
						<tr align="center" valign="bottom" height="30">
							<td colspan="2">
								<input type="submit" id="btnAdd" value="บันทึก" class="btn_box">
								<input type="hidden" name="vendor_id" value="<%=ve.getVendor_id()%>">
								<input type="hidden" name="action" value="vendor_edit">
								<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
								<input type="button" value="ยกเลิก" class="btn_box" onclick="javascript: window.location='vendor_list.jsp';">
								
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