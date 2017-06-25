<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<form id="material_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr valign="top">
				<td width="25%" align="right">เลือกโปรโมชั่น :</td>
				<td width="75%" align="left">
					<div class="left s250 required" id="name" title="ระบุโปรโมชั่น!"></div>
					<div id="btn_open_search" class="btn_box left">ค้นหาโปรโมชั่น</div>
					<div class="clear"></div>
				</td>
			</tr>
			<tr>
				<td align="right">ราคา :</td>
				<td align="left"><div id="price"></div></td>												
			</tr>
			<tr>
				<td align="right">จำนวน :</td>
				<td align="left">
					<input type="text" class="txt_show" readonly="readonly" name="item_qty" id="pk_qty" value="" title="ระบุจำนวน!">												
				</td>
			</tr>
			<tr>
				<td align="right">วันที่ร้องขอ :</td>
				<td>
					<input type="text" name="request_date" id="request_date" class="txt_box" autocomplete="off">
				</td>
			</tr>
			<tr>
				<td align="right">หมายเหตุ :</td>
				<td align="left">
					<input type="text" class="txt_box" autocomplete="off" id="remark" name="remark">
				</td>												
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$('#btn_open_search').click(function(){
		popup('promotion_search.jsp');
	});
	
	$('#request_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
	
	$(function(){

				
 			var form = $('#material_add_form');		
 			var v = form.validate({
 	 			submitHandler: function(){	
						var $duedate = $('#request_date');		
		 				var duedate = $duedate.val().split('/');
			 				if(duedate=='')	{
			 					alert('กรุณากำหนดวันที่ร้องขอ!');
			 					$duedate.focus();
			 				} else{
		 					var dd = new Date(duedate[2],duedate[1]-1,duedate[0]);
		 					var today = new Date();
		 					today = new Date(today.getFullYear(),today.getMonth(),today.getDate());
		 						if (dd < today){
		 							alert('กำหนดส่งของ น้อยกว่า วันปัจจุบัน!');
		 							$duedate.focus();
		 						} else {
									ajax_load();
									$.post('SaleManage',form.serialize(),function(resData){			
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
		<input type="hidden" name="order_id" value="<%=WebUtils.getReqString(request, "order_id")%>">
		<input type="hidden" name="discount" value="<%=WebUtils.getReqString(request, "dis")%>">
		<input type="hidden" id="item_id" name="item_id" value="">
		<input type="hidden" name="item_type" value="p">
		<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึก">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="sale_promotion_add">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>