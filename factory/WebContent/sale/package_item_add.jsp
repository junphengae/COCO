<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<script src="../js/number.js" type="text/javascript"></script>
<script type="text/javascript" src="../js/popup.js"></script>

<form id="material_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td width="30%" align="right">เลือกสินค้าจำหน่าย :</td>
				<td width="70%" align="left">
					<input type="text" class="txt_box required" readonly="readonly" name="mat_code" id="request_by_autocomplete" title="ระบุวัตถุดิบ!">											
					<button id="btn_open_search" class="btn_box">ค้นหาสินค้าจำหน่าย</button>
				</td>
			</tr>
			<tr>
				<td align="right">ชื่อสินค้าจำหน่าย:</td>
				<td align="left"><span id="mat_name"></span></td>
			</tr>
			<tr>
				<td align="right">ราคา :</td>
				<td align="left">
					<input type="text" class="txt_box required" autocomplete="off" id="unit_price" name="unit_price" title="ระบุราคาต่อหน่วย!">
				</td>												
			</tr>
			<tr>
				<td align="right">จำนวน :</td>
				<td align="left">
					<input type="text" class="txt_box required digits" autocomplete="off" id="qty" name="qty" title="ระบุจำนวน!">
				</td>												
			</tr>
			<tr>
				<td align="right">ส่วนลด :</td>
				<td align="left">
					<input type="text" class="txt_box required" autocomplete="off" id="discount" name="discount" title="ระบุส่วนลด!"> %
				</td>												
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$('#btn_open_search').click(function(){
		popup('fg_search.jsp');
	});
	
	$(function(){
		
 		var form = $('#material_add_form');	
 		/*material Form*/
 		var v = form.validate({
 			submitHandler: function(){
				
 				
				ajax_load();
				$.post('PackageManage',form.serialize(),function(resData){			
					ajax_remove();
					if (resData.status == 'success') {
						window.location.reload();
					} else {
						if (resData.message.indexOf('Duplicate entry') > 0) {
							alert('คุณเลือกรายการสินค้าซ้ำ กรุณาเลือกใหม่อีกครั้ง!');
							$('#request_by_autocomplete').val('');
						} else {
							alert(resData.status);
						}
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
	
	<div class="txt_center m_top20">
		<input type="hidden" name="pk_id" value="<%=WebUtils.getReqString(request, "pk_id")%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึกข้อมูลแพ๊คเกจ">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="fg_add">	
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>