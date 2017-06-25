<%@page import="com.bitmap.bean.hr.Position"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/jquery.validate.js" type="text/javascript"></script>
<%
	String pos_id = WebUtils.getReqString(request,"pos_id");
	Position entity = new Position();
	entity = Position.select(pos_id);
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
	<input type="hidden" name="pos_id" id="pos_id" value="<%=entity.getPos_id()%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="455px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>แก้ไขรายชื่อตำแหน่ง</h3></td></tr>
			<tr>
				<td width="30%"><label>ชื่อตำแหน่ง (ไทย)</label></td>
				<td align="left">: <input type="text" autocomplete="off" name="pos_name_th" id="pos_name_th" class="txt_box s200 required" title="Please insert Thai Position Name!" value="<%=entity.getPos_name_th() %>"></td>
			</tr>
			<tr>
				<td><label>ชื่อตำแหน่ง (อังกฤษ)</label></td>
				<td align="left">: <input type="text" autocomplete="off" name="pos_name_en" id="pos_name_en" class="txt_box s200 required" title="Please insert English Position Name!" value="<%=entity.getPos_name_en() %>"></td>
			</tr>
			
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="แก้ไข" class="btn_box">
					<input type="hidden" name="action" value="edit_pos">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error"></div>
	</form>

</div>