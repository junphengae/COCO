<%@page import="com.bitmap.bean.sale.Receive"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script src="../js/popup.js" type="text/javascript"></script>
<script src="../js/number.js" type="text/javascript"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<%
Receive entity = new Receive();
WebUtils.bindReqToEntity(entity, request);

Receive.select(entity);

InventoryMaster mat = new InventoryMaster();
mat = InventoryMaster.select(entity.getFG());

%>
<form id="material_edit_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_edit" border="0" >
		<tbody>
			<tr>
				<td width="30%" align="right">รหัสสินค้าจำหน่าย :</td>
				<td width="70%" align="left"><%=entity.getFG()%></td>
			</tr>
			<tr>
				<td align="right">ชื่อสินค้าจำหน่าย:</td>
				<td align="left"><span id="mat_name"><%=mat.getDescription()%></span></td>
			</tr>
			<tr>
				<td align="right">จำนวน :</td>
				<td align="left">
					<input type="text"  value="" class="txt_box required digits" autocomplete="off" id="qty" name="qty" title="ระบุจำนวน!">
				</td>												
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	
	$(function(){
		$('#material_edit_form').submit(function(){
	
			if($('#qty').val() == <%=entity.getQty()%>){
				ajax_load();
				$.post('../sale/SaleManage',$('#material_edit_form').serialize(),function(resData){
					ajax_remove();
					if (resData.status == 'success') {	
						window.location.reload();
					} else {					
						alert(resData.message);
					}
				},'json');		
			}else{
				alert("กรุณาใส่จำนวนให้ถูกต้อง!");
			}
			
		});
		
	});

	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="id_receive" value="<%=entity.getId_receive()%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึก">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="receive_check">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>