<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.rd.MatTree"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
SaleOrderItem entity = new SaleOrderItem();
WebUtils.bindReqToEntity(entity, request);

SaleOrderItem.select(entity);
Package pac  = new Package();

if(entity.getItem_type().equalsIgnoreCase("p")){
	pac = Package.select(entity.getItem_id());
}
%>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<form id="comfirm_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<div class="left"><%=(entity.getItem_type().equalsIgnoreCase("p")?pac.getName():entity.getUIMat().getDescription())%></div>
		<div class="clear"></div>
		<tbody>
			<tr>
				<td align="right" width="15%">วันที่เริ่มผลิต :</td>
				<td align="left">
					<input type="text" class="txt_box" autocomplete="off" id="start_date" name="start_date" value="<%=WebUtils.getDateValue(entity.getStart_date())%>">
				</td>												
			</tr>
			<tr>
				<td align="right" width="15%">วันที่เสร็จ :</td>
				<td align="left">
					<input type="text" class="txt_box" autocomplete="off" id="confirm_date" name="confirm_date" value="<%=WebUtils.getDateValue(entity.getConfirm_date())%>">
				</td>												
			</tr>
			<tr>
				<td align="right">remark :</td>
				<td align="left">
					<input type="text" class="txt_box s400" autocomplete="off" id="rmk_plan" name="rmk_plan" value="<%=entity.getRmk_plan()%>">
				</td>												
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
		$(function(){
			$('#confirm_date').datepicker({
				showOtherMonths : true,
				slectOtherMonths : true,
				changeMonth : true
			});
			
			$('#start_date').datepicker({
				showOtherMonths : true,
				slectOtherMonths : true,
				changeMonth : true
			});
			
			$('#comfirm_add_form').submit(function(){
				var $duedate = $('#confirm_date');
				var $stdate = $('#start_date');
				
				var duedate = $duedate.val().split('/');
				var stdate = $stdate.val().split('/');
				if(stdate=='')	{
					alert('กรุณากำหนดวันเริ่มผลิต!');
					$stdate.focus();
				} else if(duedate==''){
					alert('กรุณากำหนดวันที่เสร็จ!');
					$duedate.focus();
				}	
				else{
					var sd = new Date(stdate[2],stdate[1]-1,stdate[0]);
					var dd = new Date(duedate[2],duedate[1]-1,duedate[0]);
					
					var today = new Date();
					today = new Date(today.getFullYear(),today.getMonth(),today.getDate());
						if (sd < today){
							alert('กำหนดวันเริ่มผลิต น้อยกว่า วันปัจจุบัน!');
							$stdate.focus();
						}else if (dd < today){
							alert('กำหนดวันที่เสร็จ น้อยกว่า วันปัจจุบัน!');
							$duedate.focus();
						} else {
							ajax_load();
							$.post('../sale/SaleManage',$(this).serialize(),function(resData){
								ajax_remove();
								if (resData.status == 'success') {
										window.location = 'plan_sale.jsp';							
								} else {
									if (resData.message.indexOf('Duplicate entry') == -1) {
										alert(resData.message);
									}
								}
							},'json');	
						}
				}
			});
		});
	
	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="order_id" id="order_id" value="<%=WebUtils.getReqString(request, "order_id")%>">
		<input type="hidden" name="item_id" id="item_id" value="<%=WebUtils.getReqString(request, "item_id")%>">
		<input type="hidden" name="item_type" id="item_type" value="<%=WebUtils.getReqString(request, "item_type")%>">
		<input type="hidden" name="item_run" id="item_run" value="<%=WebUtils.getReqString(request, "item_run")%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="ส่งแผน">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="confirm_add">	
		<input type="hidden" name="confirm_by" value="<%=securProfile.getPersonal().getPer_id()%>">
			
	</div>
</form>