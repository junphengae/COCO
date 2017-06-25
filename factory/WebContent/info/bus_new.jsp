<%@page import="com.bitmap.bean.sale.Zipcode"%>
<%@page import="com.bitmap.bean.sale.Province"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<script type="text/javascript">
	$(function(){
		var $form = $('#busForm');

		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				var addData = $form.serialize();
				$.post('LogisManage',addData,function(data){
					ajax_remove();
					if (data.status == 'success') {
						window.location.reload();
					} else {
						alert(data.message);
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
	<form id="busForm" onsubmit="return false;">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>เพิ่มข้อมูลรถ</h3></td></tr>
			<tr>
				<td align="left" width="25%"><label>ชื่อบริษัท</label></td>
				<td align="left" width="75%">: <input type="text" autocomplete="off" name="company" id="company" class="txt_box s150 input_focus required"></td>
			</tr>
			<tr>
				<td><label>ชื่อคนขับ</label></td>
				<td>: <input type="text" autocomplete="off" name="driver" id="driver" class="txt_box s200"></td>
			</tr>
			<tr>
				<td><label>หมายเลขทะเบียน</label></td>
				<td>: <input type="text" autocomplete="off" name="plate" id="plate" class="txt_box s200"></td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="bus_add">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	</form>

</div>