<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.sale.Zipcode"%>
<%@page import="com.bitmap.bean.sale.Province"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<script type="text/javascript">
	$(function(){
		var $form = $('#packOthForm');		
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
		

		$('#packOthForm .mat_code').change(function() {
			var mat_code = $(this).find(":selected").val();
		   // alert(mat_code);
		   $('#packOthForm #mat_code_hit').val(mat_code);	  
		   
		   $.post('./InvPackServlet',{'action':'matCodeInfo','mat_code':mat_code},function(resData){
				form_remove();
				if (resData.status == 'success') {	
					var std_unit = resData.std_unit;
					var des_unit = resData.des_unit;
					var unit_pack = resData.unit_pack;		
					var description = resData.description;		
					 $('#packOthForm #description').val(description);
					 $('#packOthForm #main_unit').val(std_unit);
					 $('#packOthForm #std_unit').val(std_unit);		
					 $('#packOthForm #des_unit').val(des_unit);		
					 $('#packOthForm #unit_pack').val(unit_pack);		
					 
				} else{
					alert(resData.message);
				}
			},'json');		   
		});
			
	});
	
		
	
</script>
<div>
	<form id="packOthForm" onsubmit="return false;">
	<input type="hidden" name="create_by" id="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<input type="hidden" name="mat_code_hit" id="mat_code_hit" >
	<input type="hidden" name="std_unit" id="std_unit" >
	<input type="hidden" name="des_unit" id="des_unit" >
	<input type="hidden" name="unit_pack" id="unit_pack" >
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>เพิ่มข้อมูลหน่วยนับอื่นๆ</h3></td></tr>

			<tr>
				<td><label>รหัสสินค้า</label></td>
				<td>: <% List list = InventoryMaster.listDropdown();%>
						<bmp:ComboBox name="mat_code" styleClass="txt_box s250 required mat_code" listData="<%=list%>">
							<bmp:option value="" text="---- เลือกรหัสสินค้า----"></bmp:option>
						</bmp:ComboBox>
				</td>
			</tr>
			<tr>
				<td><label>Description</label></td>
				<td>: <input type="text" autocomplete="off" name="description" id="description" class="txt_box s250"></td>
			</tr>
			
			
			<tr>
				<td><label>หน่วยนับอื่น</label></td>
				<td>: <input type="text" autocomplete="off" name="other_unit" id="other_unit" class="txt_box s250 required"></td>
			</tr>
					
			<tr>
				<td><label>Factor</label></td>
				<td>: <input type="text" autocomplete="off" name="factor" id="factor" class="txt_box s150 required" ></td>
			</tr>
			<tr>
				<td><label>หน่วยนับหลัก</label></td>
				<td>: <input type="text"  name="main_unit" id="main_unit" class="txt_box s250" readonly="readonly"></td>
			</tr>
			
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="add">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	</form>

</div>