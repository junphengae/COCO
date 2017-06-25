<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.logistic.LogisSend"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<%
String id_run = WebUtils.getReqString(request,"id_run");
LogisSend entity = new LogisSend();
entity.setId_run(id_run);
LogisSend.select(entity);

String sum = LogisSend.balance(entity.getItem_run(),entity.getMat_code(),entity.getId_run());
String balance = Money.subtract(entity.getQty_all(),sum);
InventoryMaster inv =  InventoryMaster.select(entity.getMat_code());

%>
<form id="sale_delivery_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td align="right">ชื่อสินค้าจำหน่าย:</td>
				<td align="left"><%=inv.getDescription()%></td>
			</tr>
			<tr>
				<td align="right">จำนวนทั้งหมด :</td>
				<td align="left"><%=entity.getQty_all()+" " + inv.getDes_unit() %>
				</td>												
			</tr>
			<%
			if(entity.getQty().equalsIgnoreCase("") || entity.getQty().equalsIgnoreCase(entity.getQty_all())){
			%>
			<tr>
				<td align="right">:</td>
				<td align="left">
					<input type="radio" name="choose" id="all" value="all" checked="checked">ส่งครบ</input>
					<input type="radio" name="choose" id="some" value="some">ส่งไม่ครบ</input>
				</td>												
			</tr>
			<tr id="tr_qty" class="hide">
				<td align="right">จำนวนที่จะส่ง :</td>
				<td align="left">
					<input type="text" class="txt_box required digits" autocomplete="off" id="qty" name="qty" value="<%=entity.getQty_all()%>" title="ระบุจำนวน!">
					<%=inv.getDes_unit()%>
				</td>												
			</tr>
			<%}else{ %>
			<tr>
				<td align="right">:</td>
				<td align="left">
					<input type="radio" name="choose" id="all" value="all">ส่งครบ</input>
					<input type="radio" name="choose" id="some" value="some"  checked="checked">ส่งไม่ครบ</input>
				</td>												
			</tr>
			<tr id="tr_qty">
				<td align="right">จำนวนที่จะส่ง :</td>
				<td align="left">
					<input type="text" class="txt_box required digits" autocomplete="off" id="qty" name="qty" value="<%=entity.getQty()%>" title="ระบุจำนวน!">
					<%=inv.getDes_unit()%>
				</td>												
			</tr>
			<%} %>
			<tr>
				<td align="right">วันที่ส่ง :</td>
				<td>
					<input type="text" name="send_date" id="send_date" class="txt_box" autocomplete="off" value="<%=WebUtils.getDateValue(entity.getSend_date())%>">
				</td>
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$('#send_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
	
	$('#all').click(function(){
		$('#tr_qty').fadeOut('fast');
		$('#qty').val(<%=entity.getQty_all()%>);
	});
	
	$('#some').click(function(){
		$('#qty').val("");
		$('#tr_qty').fadeIn('fast');
	});
		
	$(function(){
		var form = $('#sale_delivery_form');		
		var v = form.validate({
 			submitHandler: function(){	
				var $duedate = $('#send_date');		
				var duedate = $duedate.val().split('/');
				
				if($('#all').attr('checked')){
					if($('#qty').val() > <%=balance%>){
						alert('กรุณาใส่จำนวนที่จะส่งให้ถูกต้อง!');
						return false;
						$('#qty').focus();
					}
				}else{
					if($('#qty').val() > <%=balance%>){
						alert('กรุณาใส่จำนวนที่จะส่งให้ถูกต้อง!');
						return false;
						$('#qty').focus();	
					}
				}
				
				if(duedate=='')	{
					alert('กรุณากำหนดวันที่ส่ง!');
					$duedate.focus();
				}else{
				var dd = new Date(duedate[2],duedate[1]-1,duedate[0]);
				var today = new Date();
				today = new Date(today.getFullYear(),today.getMonth(),today.getDate());
					if (dd < today){
						alert('กำหนดส่งของ น้อยกว่า วันปัจจุบัน!');
						$duedate.focus();
					} else {
						ajax_load();
						$.post('../logis/LogisManage',form.serialize(),function(resData){			
							ajax_remove();
							if (resData.status == 'success') {
								window.location.reload();
							} else {
								alert(resData.status);
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
		<input type="hidden" name="id_run" value="<%=id_run%>">
		<input type="hidden" name="qty_all" value="<%=entity.getQty_all()%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึก">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="update_plan_send">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>