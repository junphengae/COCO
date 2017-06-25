<%@page import="com.bitmap.bean.hr.Department"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/jquery.validate.js" type="text/javascript"></script>
<%
	String dep_id = WebUtils.getReqString(request,"dep_id");
	Department entity = new Department();
	entity = Department.select(dep_id);
%>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<script>
	$(function(){
		var $msg = $('.msg_error');
		var $form = $('#infoForm');
		
		var v = $form.validate({
			submitHandler: function(){
				var addData = $form.serialize();
				$.post('OrgManagement',addData,function(resData){
					if (resData.status == "success") {
						$msg.text('แก้ไขเรียบร้อยแล้ว').show();
						window.location.reload();
					} else {
						$msg.text('Error: ' + resData.message).show();
					}
				},'json');
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
	});
</script>
<div>
	<form id="infoForm" style="margin: 0;padding: 0;">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<input type="hidden" name="dep_id" id="dep_id" value="<%=entity.getDep_id()%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="455px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>แก้ไขรายชื่อฝ่าย</h3></td></tr>
			<tr>
				<td width="30%"><label>ชื่อฝ่าย (ไทย)</label></td>
				<td align="left">: <input type="text" autocomplete="off" name="dep_name_th" id="dep_name_th" class="txt_box s200 required" title="Please insert Thai Department Name!" value="<%=entity.getDep_name_th() %>"></td>
			</tr>
			<tr>
				<td><label>ชื่อฝ่าย (อังกฤษ)</label></td>
				<td align="left">: <input type="text" autocomplete="off" name="dep_name_en" id="dep_name_en" class="txt_box s200 required" title="Please insert English Department Name!" value="<%=entity.getDep_name_en() %>"></td>
			</tr>
			
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="แก้ไข" class="btn_box">
					<input type="hidden" name="action" value="edit_dep">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error"></div>
	</form>

</div>