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
				<td width="30%" align="right">เลือกใบส่งสินค้า :</td>
				<td width="70%" align="left">
					<input type="text" class="txt_box required" readonly="readonly" name="sent_id" id="request_by_autocomplete" title="ระบุใบส่งสินค้า!">											
					<button id="btn_open_search" class="btn_box">ค้นหาใบส่งสินค้า</button>
				</td>
			</tr>
			<tr>
				<td align="right">วันที่ส่ง :</td>
				<td align="left">
					<input type="text" name="request_date" id="request_date" class="txt_box" autocomplete="off" value="">
				</td>												
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$('#btn_open_search').click(function(){
		popup('sendid_search.jsp');
	});
	
	$(function(){		
 		var form = $('#material_add_form');	
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
		<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึก">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="fg_add">	
		<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>