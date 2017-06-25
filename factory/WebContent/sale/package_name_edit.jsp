<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<script src="../js/number.js" type="text/javascript"></script>
<script type="text/javascript" src="../js/popup.js"></script>

<%
Package entity = new Package();
WebUtils.bindReqToEntity(entity, request);
Package.select(entity);
%>
<form id="package_edit_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td align="right">ชื่อรายการ:</td>
				<td align="left"><input type="text" name="name" class="s300 txt_box required" value="<%=entity.getName()%>"/></td>
			</tr>
			<tr><td colspan="2" height="10"></td></tr>
			<tr valign="top">
				<td align="right">ประเภท :</td>
				<td align="left"> 
					<input type="radio" name="pk_type" value="s" id="type_s"> <label for="type_s">เซต / Set</label> 
					<br>
					<input type="radio" name="pk_type" value="p" id="type_p"> <label for="type_p">โปรโมชั่น / Promotion</label>
				</td>
			</tr>
			<tr id="tr_pro" class="<%=(entity.getPk_type().equalsIgnoreCase("p"))?"":"hide"%>">
				<td align="right">จำนวนชุด:</td>
				<td align="left"><input type="text" name="pk_qty" id="pk_qty" class="txt_box required digits" value="<%=entity.getPk_qty()%>"/></td>
			</tr>
			
		</tbody>
	</table>
	
	<script type="text/javascript">
	
	$(function(){
		$('input:radio[name="pk_type"]').filter('[value="<%=entity.getPk_type()%>"]').attr('checked', true);
 		
		$('input:radio[name="pk_type"]').click(function(){
			if($(this).val() == "p"){
				$('#tr_pro').show();
			}else {
				$('#tr_pro').hide();
				$('#pk_qty').val('1');
			}
			
		});
		
		var form = $('#package_edit_form');	
 		var v = form.validate({
 			submitHandler: function(){
				ajax_load();
				$.post('PackageManage',form.serialize(),function(resData){			
					ajax_remove();
					if (resData.status == 'success') {
						window.location.reload();
					} else {
						alert(resData.status);
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
		<input type="hidden" name="action" value="packageName_update">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>