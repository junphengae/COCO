<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<script type="text/javascript">
	$(function(){
		var $msg = $('#vendor_msg_error');
		var $form = $('#subCatForm');

		var v = $form.validate({
			submitHandler: function(){
				var addData = $form.serialize();
				$.post('MaterialManagement',addData,function(data){
					if (data.status == 'success') {
						$msg.text('Add new Sub Category: ' + data.status).show();
						$('select[name=sub_cat_id]').append('<option value="' + data.sub_cat_id + '">' + data.sub_cat_name_th + '</option>');
						$('select[name=sub_cat_id]').val(data.sub_cat_id);
						$('#edit_sub_cat').fadeIn(500);
						var attr = '../info/sub_cat_edit.jsp?height=300&width=520&cat_id=' + data.cat_id + '&sub_cat_id=' + data.sub_cat_id + '&group_id=' + data.group_id;
						$('#edit_sub_cat').attr('lang',attr);
						tb_remove();
					} else {
						alert(data.message);
						$('#subCatForm #sub_cat_name_short').focus();
					}
				},'json');
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
		
		
		function addSuccess(data){
			
		}
	});
</script>
<div>
	<form id="subCatForm" action="" method="post" style="margin: 0;padding: 0;">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>เพิ่มชนิดย่อย</h3></td></tr>
			<tr>
				<td align="left" width="25%"><label>ชื่อชนิดย่อย</label></td>
				<td align="left" width="75%">: <input type="text" autocomplete="off" name="sub_cat_name_th" id="sub_cat_name_th" class="txt_box s200 required input_focus"></td>
			</tr>
			<tr>
				<td><label>ชื่อย่อ</label></td>
				<td>: <input type="text" autocomplete="off" name="sub_cat_name_short" id="sub_cat_name_short" class="txt_box s200 required" ></td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="sub_cat_add">
					<input type="hidden" name="cat_id" value="<%=WebUtils.getReqString(request, "cat_id")%>">
					<input type="hidden" name="group_id" value="<%=WebUtils.getReqString(request, "group_id")%>">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
					<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error" id="vendor_msg_error"></div>
	</form>

</div>