<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/jquery.validate.js" type="text/javascript"></script>
<%
String dep_id = WebUtils.getReqString(request ,"dep_id");
%>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<script>
	$(function(){
		var $msg = $('.msg_error');
		var $form = $('#infoForm');
		
		var v = $form.validate({
			submitHandler: function(){
				add();
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
		
		function add(){
			var addData = $form.serialize();
		//	alert(addData);
			$.post('OrgManagement',addData,function(resData){
				if (resData.status == "success") {
					$msg.text('เพิ่มแผนกเรียบร้อยแล้ว').show();
					refreshDiv('<%=dep_id%>');
					tb_remove();
				} else {
					$msg.text('Error: ' + resData.message).show();
				}
			},'json');
		}
	});
</script>
<div>
	<form id="infoForm" style="margin: 0;padding: 0;">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="455px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>เพิ่มรายชื่อแผนก</h3></td></tr>
			<tr>
				<td width="30%"><label>ชื่อแผนก (ไทย)</label></td>
				<td align="left">: <input type="text" autocomplete="off" name="div_name_th"  id="div_name_th"   class="txt_box s200 required	input_focus   "  title="Please insert Thai Division Name!"></td>
			</tr>
			<tr>
				<td><label>ชื่อแผนก (อังกฤษ)</label></td>
				<td align="left">: <input type="text" autocomplete="off" name="div_name_en" id="div_name_en" class="txt_box s200 required"  title="Please insert English Division Name!"></td>
			</tr>
					
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="เพิ่ม" class="btn_box">
					<input type="hidden" name="action" value="add_div">
					<input type="hidden" name="dep_id" value="<%=dep_id %>">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error"></div>
	</form>

</div>