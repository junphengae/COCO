<%@page import="com.bitmap.bean.inventory.SubCategories"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<%	
	String group_id = WebUtils.getReqString(request, "group_id");
	String cat_id = WebUtils.getReqString(request, "cat_id");
	String sub_cat_id = WebUtils.getReqString(request, "sub_cat_id");
	SubCategories entity = new SubCategories();
	entity.setGroup_id(group_id);
	entity.setCat_id(cat_id);
	entity.setSub_cat_id(sub_cat_id);
	entity = SubCategories.select(entity);
%>
<script type="text/javascript">
	$(function(){
		
		var $msg = $('#vendor_msg_error');
		var $form = $('#subCatEditForm');

		var v = $form.validate({
			submitHandler: function(){
				if (confirm('ยืนยันการแก้ไขชนิดย่อย!')) {
					add();
				}
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
		
		function add(){
			var addData = $form.serialize();
			$.post('MaterialManagement',addData,function(data){addSuccess(data);},'json');
		}
		
		function addSuccess(data){
			if (data.status.indexOf('success') == -1) {
				alert(data.message);
				$('#subCatEditForm #sub_cat_name_short').focus();
			} else {
				$msg.text('Edit Sub Category: ' + data.status).show();
				$('select[name=sub_cat_id]').children('option[value=<%=sub_cat_id%>]').attr('text',$('#sub_cat_name_th').val());
				tb_remove();
			}
		}
	});
</script>
<div>
	<form id="subCatEditForm" action="" method="post" style="margin: 0;padding: 0;">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<input type="hidden" name="group_id" id="cat_id" value="<%=entity.getGroup_id() %>">
	<input type="hidden" name="cat_id" id="cat_id" value="<%=entity.getCat_id() %>">
	<input type="hidden" name="sub_cat_id" id="sub_cat_id" value="<%=entity.getSub_cat_id() %>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>แก้ไขชนิด</h3></td></tr>
			<tr>
				<td align="left" width="25%"><label>ชื่อชนิดย่อย</label></td>
				<td align="left" width="75%">: <input type="text" autocomplete="off" name="sub_cat_name_th" id="sub_cat_name_th" class="txt_box s200 required input_focus" value="<%=entity.getSub_cat_name_th()%>"></td>
			</tr>
			<tr>
				<td><label>ชื่อย่อ</label></td>
				<td>: <input type="text" autocomplete="off" name="sub_cat_name_short" id="sub_cat_name_short" class="txt_box s200 required" value="<%=entity.getSub_cat_name_short()%>"></td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="แก้ไข" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="sub_cat_edit">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<div class="msg_error" id="vendor_msg_error"></div>
	</form>

</div>