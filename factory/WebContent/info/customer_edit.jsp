<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.sale.Zipcode"%>
<%@page import="com.bitmap.bean.sale.Province"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<%
	String cus_id = request.getParameter("cus_id"); 
	Customer entity = new Customer();
	entity.setCus_id(cus_id);
	entity = Customer.select(entity);
%>
<script type="text/javascript">
	$(function(){
		
		var $form = $('#cusEditForm');

		var v = $form.validate({
			submitHandler: function(){
				ajax_load();
				var addData = $form.serialize();
				$.post('CustomerManage',addData,function(data){
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
			form_load($('#cusEditForm'));
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
	<form id="cusEditForm" onsubmit="return false;">
	<input type="hidden" name="update_by" id="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<input type="hidden" name="cus_id" id="cus_id" value="<%=entity.getCus_id() %>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>แก้ไขข้อมูลลูกค้า</h3></td></tr>
			<tr>
				<td align="left" width="20%"><label>ชื่อลูกค้า</label></td>
				<td align="left" width="80%">: <input type="text" autocomplete="off" name="cus_name" id="cus_name" class="txt_box s350 input_focus required" value="<%=entity.getCus_name()%>"></td>
			</tr>
			<tr>
				<td><label>พนักงานขาย</label></td>
				<td>: <% List list = Personal.listDropdown("0010");%>
								<bmp:ComboBox name="cus_tax" styleClass="txt_box s150" listData="<%=list%>" value="<%=entity.getCus_tax() %>">
									<bmp:option value="" text="---- เลือกพนักงานขาย----"></bmp:option>
								</bmp:ComboBox>
				</td>
			</tr>
			<tr>
				<td><label>โทรศัพท์</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_phone" id="cus_phone" class="txt_box s350" value="<%=entity.getCus_phone()%>"></td>
			</tr>
			<tr>
				<td><label>แฟกซ์</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_fax" id="cus_fax" class="txt_box s350" value="<%=entity.getCus_fax()%>"></td>
			</tr>
			<tr>
				<td><label>ที่อยู่</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_address" id="cus_address" class="txt_box s350" value="<%=entity.getCus_address()%>"></td>
			</tr>
			<% List<String[]> listProvince = Province.selectList("th", "66"); %>
			<tr>
				<td><label>จังหวัด</label></td>
				<td>: <bmp:ComboBox name="province_id" styleClass="txt_box s350" listData="<%=listProvince%>" value="<%=entity.getProvince_id()%>"></bmp:ComboBox></td>
			</tr>
			<%List<String[]> listZip = Zipcode.getComboList("th",entity.getProvince_id()); %>
			<tr>
				<td><label>รหัสไปรษณีย์</label></td>
				<td>: <bmp:ComboBox name="zip_code" styleClass="txt_box" listData="<%=listZip%>" value="<%=entity.getZip_code()%>"></bmp:ComboBox></td>
			</tr>	
			<tr>
				<td><label>ประเทศ</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_country" id="cus_country" class="txt_box s350" value="<%=entity.getCus_country()%>"></td>
			</tr>
			<tr>
				<td valign="top"><label>Email</label></td>
				<td valign="top">: <input type="text" autocomplete="off" name="cus_email" id="cus_email" class="txt_box s350 email" value="<%=entity.getCus_email()%>"></td>
			</tr>
			<tr>
				<td><label>ผู้ติดต่อ</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_contact" id="cus_contact" class="txt_box s350" value="<%=entity.getCus_contact()%>"></td>
			</tr>
			<tr>
				<td><label>เงื่อนไขการจัดส่ง</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_condition" id="cus_condition" class="txt_box s350" value="<%=entity.getCus_condition()%>"></td>
			</tr>
			<tr>
				<td><label>เครดิต</label></td>
				<td>: <input type="text" autocomplete="off" name="cus_credit" id="cus_credit" class="txt_box s350" value="<%=entity.getCus_credit()%>"></td>
			</tr>
			<tr>
				<td><label>ส่วนลด</label></td>
				<td>: <input type="text" maxlength="3" autocomplete="off" name="cus_discount" id="cus_discount" value="<%=entity.getCus_discount()%>" class="txt_box s350"> %</td>
			</tr>
			<tr>
				<td><label>ส่งโดย</label></td>
				<td>: <input type="text" autocomplete="off" name="send_by" id="send_by" value="<%=entity.getSend_by()%>" class="txt_box s350"></td>
			</tr>
			<tr>
				<td><label>ประเภทการขนส่ง</label></td>
				<td>: 
					<bmp:ComboBox name="cus_ship" styleClass="txt_box s100"  value="<%=entity.getCus_ship()%>">
						<bmp:option value="land" text="ทางบก"></bmp:option>
						<bmp:option value="sea" text="ทางเรือ"></bmp:option>
						<bmp:option value="air" text="ทางอากาศ"></bmp:option>
					</bmp:ComboBox>
				</td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="customer_edit">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	</form>

</div>