<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src="../js/number.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<%
String mat_code = WebUtils.getReqString(request, "mat_code");
String id = WebUtils.getReqString(request, "id");

InventoryMaster entity = InventoryMaster.select(mat_code);
%>
<script type="text/javascript">
var order_qty = $('#order_qty');
var form = $('#create_order_form');

form.submit(function(){
	if (confirm('ยืนยันการยกเลิก !')) {
		ajax_load();
		$.post('PurchaseManage',form.serialize(),function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				window.location.reload();
			} else {
				alert(resData.message);
			}
		},'json');
	}
	
	return false;
});


</script>
<form id="create_order_form" onsubmit="return false;">
	<table cellpadding="3" cellspacing="3" border="0" class="s400 center">
		<tbody>
			<tr>
				<td width="30%"><label>รหัสสินค้า</label></td>
				<td>: <%=entity.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + entity.getUISubCat().getUICat().getCat_name_short() + ((entity.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + entity.getUISubCat().getSub_cat_name_short():"")%>-<%=entity.getMat_code()%></td>
			</tr>
			<tr valign="top">
				<td><label>ชื่อสินค้า</label></td>
				<td align="left">: <%=entity.getDescription()%></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</tbody>
	</table>

	<div class="m_top10"></div>
	
	<div class="center">
		<div class="left">เหตุผลที่ยกเลิก : &nbsp;</div>
		<div class="left">
			<textarea name="note" rows="4" cols="25" class="txt_box s350 h60 input_focus"></textarea>
		</div>
		<div class="clear"></div>
	</div>
	
	<div class="m_top10"></div>
	<div class="center txt_center">
		<input type="submit" name="add" class="btn_box btn_warn" value="ยกเลิกรายการขอจัดซื้อ">
		<input type="reset" name="reset" class="btn_box" value="ปิด" onclick="tb_remove();">
		<input type="hidden" name="action" value="cancel_pr">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
		<input type="hidden" name="mat_code" value="<%=mat_code%>">
		<input type="hidden" name="id" value="<%=id%>">
	</div>

	<div class="m_top10"></div>
</form>