<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<script src="../js/number.js" type="text/javascript"></script>

<%
String mat_code = WebUtils.getReqString(request, "mat_code");
%>
<script type="text/javascript">
$(function(){
	$('#clone_desc').text($('#mat_desc').text());
	$('#input_desc').val($('#mat_desc').text() + ' Copy');
});
</script>

<form id="formular_clone_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" border="0" >
		<tbody>
			<tr><td align="center"><div class="txt_bold">ยืนยันการสร้างสูตรใหม่ ที่ใกล้เคียงกับสูตรของ <span id="clone_desc" class="txt_14"></span></div></td></tr>
			<tr><td height="35"></td></tr>
			<tr>
				<td align="center">ชื่อสูตรใหม่ที่ต้องการสร้าง : <input type="text" class="txt_box s200 input_focus required" autocomplete="off" name="description" id="input_desc" value=""></td>
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$(function(){
		
		var form = $('#formular_clone_form');	
		/*material Form*/
		var v = form.validate({
			submitHandler: function(){
				if (confirm('ยืนยันการสร้างสูตรใกล้เคียง?\n\rระบบจะคัดลอกขั้นตอนทั้งหมดเพื่อสร้างเป็นสูตรใหม่ให้โดยอัตโนมัติ')) {
					ajax_load();
					$.post('RDManagement',form.serialize(),function(data){
						ajax_remove();
						if (data.status == 'success') {
							if (confirm('คุณต้องการไปที่หน้าแก้ไขสูตรใหม่หรือไม่ ?')) {
								window.location='formular_new.jsp?mat_code=' + data.mat_code;
							} else {
								tb_remove();
							}
						} else {
							alert(data.message);
						}
					},'json');
				}
			}
		});
		
		form.submit(function(){
			v;
			return false;
		});	
	});
	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="mat_code" value="<%=WebUtils.getReqString(request, "mat_code")%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="ยืนยันการสร้างสูตรใกล้เคียง">				
		<input type="button" class="btn_box btn_warn" value="ยกเลิก" onclick="tb_remove();">				
		<input type="hidden" name="action" value="Formular_Clone">
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>