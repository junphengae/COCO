<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<script type="text/javascript">	
$(function(){
	$('#tmp').click(function(){
		$('#type').fadeOut('slow');
	});
	
	$('#inv').click(function(){
		$('#type').fadeIn('slow');
	});
	
	$('#btn_open_search').click(function(){
		popup('fg_search.jsp');
	});
	
	$('#request_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
	
	$('#order_type').change(function(){
		if($('#order_type').val() == ""){	
			//$('#type1').hide();
			$('#type2').hide();
			$('#add').hide();	
		}else if($('#order_type').val() == "50"){	
			$('#type2').hide();
			//$('#type1').show();	
			$('#add').show();
			$('#request_by_autocomplete').removeClass('required');
			$('#unit_price').removeClass('required');
			$('#item_qty').removeClass('required');
		}else if($('#order_type').val() == "60"){
			//$('#type1').hide();
			$('#type2').show();
			$('#add').show();
			$('#request_by_autocomplete').addClass('required');
			$('#unit_price').addClass('required');
			$('#item_qty').addClass('required');
		}else if($('#order_type').val() == "70"){
			$('#type2').hide();
			//$('#type1').show();	
			$('#add').show();
			$('#request_by_autocomplete').removeClass('required');
			$('#unit_price').removeClass('required');
			$('#item_qty').removeClass('required');
		}
		
	});
		
		
	var form = $('#material_add_form');		
	var v = form.validate({
			submitHandler: function(){
				if($('#order_type').val() == "60"){	
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
								if(resData.status == '70'){
									window.location.reload();
								}else{
									window.location = 'sale_order_create.jsp?order_id=' + resData.order_id + '&cus_id=' + resData.cus_id;			
								}
							} else {
									alert(resData.status);
							}
						},'json'); 				
						}
					} 	
				}else if($('#order_type').val() == "50" || $('#order_type').val() == "70"){	
					ajax_load();
					$.post('SaleManage',form.serialize(),function(resData){			
						ajax_remove();
						if (resData.status == 'success') {
							if(resData.status == '70'){
								window.location.reload();
							}else{
								window.location = 'sale_order_create.jsp?order_id=' + resData.order_id + '&cus_id=' + resData.cus_id;			
							}
						} else {
								alert(resData.status);
						}
					},'json'); 				
				}
			}
	});
	
	form.submit(function(){
		v;
		return false;
	});	
});
</script>

<form id="material_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td align="right">เลือกประเภท </td>
				<td align="left">:
					<bmp:ComboBox name="order_type" styleClass="txt_box s150" listData="<%=SaleOrder.type()%>" value="">
						<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
					</bmp:ComboBox>
				</td>												
			</tr>
		</tbody>
	</table>

	<fieldset id="type2" class="hide fset s400">
	<legend></legend>	
		<div class="txt_center">	
			<div class="left s100">เลือกสินค้าจำหน่าย: </div>
			<div align="left">
					<div class="left"><input type="text" class="txt_box required" readonly="readonly" name="item_id" id="request_by_autocomplete" title="ระบุสินค้า!"></div>											
					<div id="btn_open_search" class="btn_box left m_left5 s120">ค้นหาสินค้าจำหน่าย</div><div class="clear"></div>
			</div>
			<div class="clear"></div>
			<div class="left s100">ราคา</div>
			<div class="left">:
					<input type="text" class="txt_box required" autocomplete="off" id="unit_price" name="unit_price" title="ระบุราคาต่อหน่วย!">
			</div>
			<div class="clear"></div>
			<div class="left s100">จำนวน</div>
			<div class="left">
					: <input type="text" name="item_qty" id="item_qty" class="txt_box" />												
			</div>
			<div class="clear"></div>
			<div class="left s100">วันที่ร้องขอ</div>
			<div class="left">
					: <input type="text" name="request_date" id="request_date" class="txt_box" autocomplete="off">											
			</div>
			<div class="clear"></div>
			<div class="left s100">หมายเหตุ</div>
			<div class="left">
					: <input type="text" class="txt_box" autocomplete="off" id="remark" name="remark">
			</div>
			
			<fieldset class="fset s200">
				<legend>เลือกรูปแบบ</legend>
				<div class="txt_center">
					<div>
						<input type="radio" name="b" id="tmp" value="tmp" checked="checked"> <label for="tmp">invoice ชั่วคราว</label>
						<input type="radio" name="b" id="inv" value="inv"> <label for="inv">มี invoice</label>
					</div>
					<div class="clear"></div>
					<div class="hide" id="type">
						<input type="radio" name="c" id="a" value="vat"> <label for="a">vat</label>
						<input type="radio" name="c" id="b" value="novat"><label for="b">novat</label>
					</div>
				</div>			
			</fieldset>
		</div>
	</fieldset>

	<div class="txt_center m_top10">
		<input type="hidden" name="cus_id"  value="<%=WebUtils.getReqString(request,"cus_id")%>">
		<input type="hidden" name="id_receive"  value="<%=WebUtils.getReqString(request,"id_receive")%>">
		<button name="add" id="add" class="btn_box btn_confirm hide">บันทึก</button>
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">			
		<input type="hidden" name="action" value="verify">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>