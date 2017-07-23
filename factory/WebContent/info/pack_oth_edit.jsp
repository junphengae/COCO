<%@page import="com.coco.inv.pack.InvPackTS"%>
<%@page import="com.coco.inv.pack.InvPackBean"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<%
	String mat_code = request.getParameter("mat_code"); 
	String pack_id = request.getParameter("pack_id"); 
	
	InvPackBean entity = new InvPackBean();
	entity.setMat_code(mat_code);
	entity.setPack_id(pack_id);
	
	entity = InvPackTS.select(entity);
	
%>
<script type="text/javascript">
	$(function(){		
		var $form = $('#packOthEditForm');
			
		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				var addData = $form.serialize();				
					$.post('./InvPackServlet',addData,function(data){
						ajax_remove();
						if (data.status == 'success') {
							window.location.reload();
						} else {
							alert(data.message);
						}
					},'json');
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
		
		$('#province_id').change(function(){
			form_load($('#packOthEditForm'));
				$.post('SaleManage',{'action':'get_zip','province_id':$(this).val()},function(resData){
					form_remove();
					if (resData.status == 'success') {	
						var j = resData.zip_code;
						
						var options = '<option value=""> --- เลือกเขต --- </option>';
						for(var i = 0;i < j.length;i++){
							options += '<option value="' + j[i][0] + '">' + j[i][1] + '</option>';	
						}
						$('#zip_code').html(options);					
					} else{
						alert(resData.message);
					}
				},'json');	
			
		});
	});
</script>
<div>
	<form id="packOthEditForm" onsubmit="return false;">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<input type="hidden" name="mat_code" id="mat_code" value="<%=entity.getMat_code()%>">
	<input type="hidden" name="pack_id" id="pack_id" value="<%=entity.getPack_id()%>">
	<input type="hidden" name="std_unit" id="std_unit" value="<%=entity.getStd_unit()%>">
	<input type="hidden" name="des_unit" id="des_unit" value="<%=entity.getDes_unit()%>">
	<input type="hidden" name="unit_pack" id="unit_pack" value="<%=entity.getUnit_pack()%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>เพิ่มข้อมูลหน่วยนับอื่นๆ</h3></td></tr>
			<tr>
				<td><label>รหัสสินค้า</label></td>
				<td>: <%=entity.getMat_code()%></td>
				
			</tr>
			<tr>
				<td><label>Description</label></td>
				<td>: <input type="text" autocomplete="off" name="description" id="description" class="txt_box s250" value="<%=entity.getDescription()%>" readonly="readonly"></td>
			</tr>
			
			
			<tr>
				<td><label>หน่วยนับอื่น</label></td>
				<td>: <input type="text" autocomplete="off" name="other_unit" id="other_unit" class="txt_box s250 required" value="<%=entity.getOther_unit()%>"></td>
			</tr>
					
			<tr>
				<td><label>Factor</label></td>
				<td>: <input type="text" autocomplete="off" name="factor" id="factor" class="txt_box s150 required"  value="<%=entity.getFactor()%>"></td>
			</tr>
			<tr>
				<td><label>หน่วยนับหลัก</label></td>
				<td>: <input type="text"  name="main_unit" id="main_unit" class="txt_box s250" readonly="readonly" value="<%=entity.getMain_unit()%>"></td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="edit">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	</form>

</div>