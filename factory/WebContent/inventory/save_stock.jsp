<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
<%@page import="com.bitmap.bean.hr.Division"%>
<%@page import="com.bitmap.bean.hr.Position"%>
<%@page import="com.bitmap.bean.hr.Department"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
	String qty_old  		= WebUtils.getReqString(request, "qty_old");
	String check_id 	= WebUtils.getReqString(request, "check_id");
	String pn       		= WebUtils.getReqString(request, "pn");
	String seq      		= WebUtils.getReqString(request, "seq");
%>
<script type="text/javascript">
var form = $('#save_stock_form');

form.submit(function(){
		var qty_new = $('#qty_new').val();
		var qty_old = $('#qty_old').val();
		var qty_diff= 0;
		//if(qty_new>qty_old){
			qty_diff= qty_new - qty_old;
		//}else{
			//qty_diff= qty_old - qty_new
		//} 
		$('#qty_diff').val(qty_diff);
			ajax_load();
			$.post('../CheckStockServlet',form.serialize(),function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
});
	function checkNumber(data){
		if(!data.value.match(/^\d*$/)){
			alert("กรอกตัวเลขเท่านั้น");
			data.value='';
			$('#qty_new').focus();
		  }
	}

</script>

<form id="save_stock_form" onsubmit="return false;">
<fieldset style="width: 400px;margin-top: 10px">
<legend>&nbsp;<Strong>Stock Detail</Strong>&nbsp;</legend>
	<table cellpadding="3" cellspacing="3" border="0" class="s400 center">
		<tbody>
			<tr width="50%">
				<td align="right"><label>QTY(New)&nbsp;&nbsp;&nbsp;&nbsp;</label></td>
				<td>:&nbsp;&nbsp;<input type="text" name="qty_new" id="qty_new" onkeyup='checkNumber(this)' autocomplete="off" style="width: 50px"> </td>
			</tr>
			<tr valign="top" width="50%">
				<td align="right"><label>QTY(Old)&nbsp;&nbsp;&nbsp;&nbsp;</label></td>
				<td align="left">: &nbsp;<%=qty_old%><input type="hidden" value="<%=qty_old%>" id="qty_old"></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" class="btn_box " value="Save" style="margin-top: 20px">
					<input type="button" class="btn_box " value="Cancel" onclick="tb_remove();">
					<input type="hidden"  value="save_stock" name="action">
					<input type="hidden"  value="<%=pn%>" name="pn">
					<input type="hidden"  value="<%=check_id%>" name="check_id">
					<input type="hidden"  value="<%=seq%>" name="seq">
					<input type="hidden"  name="qty_diff" id="qty_diff">
					<input type="hidden"  value="<%=securProfile.getPersonal().getPer_id()%>" name="update_by">
				</td>
			</tr>
		</tbody>
	</table>
</fieldset>
</form>
