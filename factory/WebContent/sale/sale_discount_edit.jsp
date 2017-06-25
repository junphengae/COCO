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
InventoryMaster mat = entity.getUIMat();

String item_type = WebUtils.getReqString(request, "item_type");
Package pac = Package.select(entity.getItem_id());

%>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<form id="comfirm_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td align="right" width="20%">Product Name :</td>
				<td align="left"><%=(item_type.equalsIgnoreCase("p")?pac.getName():mat.getDescription())%>
				</td>												
			</tr>
			<tr>
				<td align="right" width="20%">ส่่วนลด :</td>
				<td align="left">
					<input type="text" class="txt_box" maxlength="5" autocomplete="off" id="discount" name="discount" value="<%=entity.getDiscount()%>"> %
				</td>												
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$(function(){
		
		$('#comfirm_add_form').submit(function(){
			ajax_load();
			$.post('SaleManage',$(this).serialize(),function(resData){
				ajax_remove();
				if (resData.status == 'success') {
						window.location.reload();							
				} else {
					if (resData.message.indexOf('Duplicate entry') == -1) {
						alert(resData.message);
					}
				}
			},'json');	
		});
	});
	
	</script>
	
	<div class="txt_center m_top20">
		<input type="hidden" name="item_run" id="item_run" value="<%=WebUtils.getReqString(request, "item_run")%>">
		<input type="submit" name="add" class="btn_box btn_confirm" value="บันทึก">				
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">				
		<input type="hidden" name="action" value="discount_update">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
			
	</div>
</form>