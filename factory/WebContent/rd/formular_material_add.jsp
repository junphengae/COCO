<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<script src="../js/number.js" type="text/javascript"></script>

<form id="material_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td width="20%" align="right">เลือกวัตถุดิบ :</td>
				<td width="80%" align="left">
					<input type="text" class="txt_box required" readonly="readonly" name="material" id="request_by_autocomplete" title="ระบุวัตถุดิบ!">											
					<button id="btn_open_search" class="btn_box">ค้นหาวัตถุดิบ</button>
				</td>
			</tr>
			<tr>
				<td align="right">ชื่อวัตถุดิบ :</td>
				<td align="left"><span id="mat_name"></span></td>
			</tr>
			<tr>
				<td align="right">หน่วยนับที่ใช้ :</td>
				<td align="left"><span id="std_unit"></span></td>
			</tr>
			<tr>
				<td align="right">อัตราส่วน :</td>
				<td align="left">
					<input type="text" class="txt_box required" autocomplete="off" id="qty" name="qty" title="ระบุอัตราส่วน! (ถ้าไม่ระบุให้ใส่ 0)"> / <span id="span_qty"></span>
				</td>												
			</tr>
			<tr>
				<td align="right">Remark :</td>
				<td align="left">
					<input type="text" class="txt_box" autocomplete="off" id="remark" name="remark">
				</td>
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$('#btn_open_search').click(function(){
		popup('material_search.jsp');
	});
	
	$(function(){
		$('#span_qty').text(money(100 - ($('#sumQty').val()*1)));
		
		var form = $('#material_add_form');	
		/*material Form*/
		var v = form.validate({
			submitHandler: function(){
				
				var sumQty = ($('#sumQty').val()*1) + ($('#qty').val()*1);
				if(sumQty<=100){
					ajax_load();
					$.post('RDManagement',form.serialize(),function(resData){			
						ajax_remove();
						if (resData.status == 'success') {
							window.location.reload();
						} else {
							if (resData.message.indexOf('Duplicate entry') > 0) {
								alert('คุณเลือกวัตถุดิบในขั้นตอนที่ <%=WebUtils.getReqString(request, "step")%> ซ้ำ กรุณาตรวจสอบ!');
								$('#request_by_autocomplete').val('');
							} else {
								alert(resData.status);
							}
						}
					},'json');
				}else{
					alert('อัตราส่วนที่ทำการเพิ่ม เกิน 100 % กรุณาแก้ไข!');
					$('#qty').focus();
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
		<input type="hidden" name="step" value="<%=WebUtils.getReqString(request, "step")%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="เพิ่มวัตถุดิบ">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="step_material_add">
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>