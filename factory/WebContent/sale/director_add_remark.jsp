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
<form id="material_add_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<table width="100%"  class="center" id="tb_material_add" border="0" >
		<tbody>
			<tr>
				<td align="right">ชื่อรายการ:</td>
				<td align="left"><%=entity.getName()%></td>
			</tr>
			<tr>
				<td align="right">ประเภท :</td>
				<td align="left"><%=(entity.getPk_type().equalsIgnoreCase("p"))?"โปรโมชั่น / Promotion":"เซต / Set"%> 
				</td>												
			</tr>
			<tr>
				<td align="right">หมายเหตุ :</td>
				<td align="left">
					<input type="text" class="txt_box required  s200" autocomplete="off" id="remark" name="remark" title="ระบุหมายเหตุ!">
				</td>												
			</tr>
		</tbody>
	</table>
	
	<script type="text/javascript">
	$(function(){
		
 		var form = $('#material_add_form');	
 		/*material Form*/
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
		<input type="hidden" name="action" value="director_update_status">	
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	</div>
</form>