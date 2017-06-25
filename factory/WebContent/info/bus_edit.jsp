<%@page import="com.bitmap.bean.logistic.Busstation"%>
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
	String qid = request.getParameter("qid"); 
	Busstation entity = new Busstation();
	entity.setQid(qid);
	entity = Busstation.select(entity);
%>
<div>
	<form id="busEditForm" onsubmit="return false;">
	<input type="hidden" name="update_by" id="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<input type="hidden" name="qid" id="qid" value="<%=entity.getQid() %>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>แก้ไขข้อมูลรถ</h3></td></tr>
			<tr>
				<td align="left" width="25%"><label>ชื่อบริษัท</label></td>
				<td align="left" width="75%">: <input type="text" autocomplete="off" name="company" value="<%=entity.getCompany()%>" id="company" class="txt_box s150 input_focus required"></td>
			</tr>
			<tr>
				<td><label>ชื่อคนขับ</label></td>
				<td>: <input type="text" autocomplete="off" value="<%=entity.getDriver()%>" name="driver" id="driver" class="txt_box s200"></td>
			</tr>
			<tr>
				<td><label>หมายเลขทะเบียน</label></td>
				<td>: <input type="text" autocomplete="off" value="<%=entity.getPlate()%>" name="plate" id="plate" class="txt_box s200"></td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="submit" id="btnAdd" value="บันทึก" class="btn_box btn_confirm">
					<input type="hidden" name="action" value="bus_edit">
					<input type="reset" onclick="tb_remove();" value="ยกเลิก" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	<script type="text/javascript">
	$(function(){	
		$('#busEditForm').submit(function(){
				ajax_load();
				$.post('LogisManage',$(this).serialize(),function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						window.location.reload();
					} else {
						alert(resData.message);
					}
				},'json');
		});
	});
	</script>
	</form>

</div>