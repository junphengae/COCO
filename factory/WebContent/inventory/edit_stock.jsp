<%@page import="com.bmp.parts.check.stock.CheckStockTS"%>
<%@page import="com.bmp.parts.check.stock.CheckStockBean"%>
<%@page import="com.bitmap.bean.inventory.StockCardReport"%>
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
	String check_id 	= WebUtils.getReqString(request, "check_id");
	String pn       		= WebUtils.getReqString(request, "pn");
	String seq			= WebUtils.getReqString(request, "seq");
	
	CheckStockBean entity = new CheckStockBean();
	entity.setCheck_id(Integer.parseInt(check_id));
	entity.setPn(pn);
	entity.setSeq(Integer.parseInt(seq));
	CheckStockTS.select(entity);
%>
<script type="text/javascript">
var form = $('#save_stock_form');
	var qty_newed = $('#qty_newed').val();
	var qty_olded = $('#qty_old').val();
	var cal_qty   = parseFloat(qty_newed)-parseFloat(qty_olded);
	$('#qty_diffed').text(cal_qty);
	
form.submit(function(){
	if(confirm("คุณต้องการที่จะเปลี่ยนหรือไม่")){
		ajax_load();
		$.post('../CheckStockServlet',form.serialize(),function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				window.location.reload();
			} else {
				alert(resData.message);
			}
		},'json');
	}else{
		return false;
	}
});
	function  checkNumber(data){
		  if(!data.value.match(/^\d*$/)){
			alert("กรอกตัวเลขเท่านั้น");
			data.value='';
			$('#qty_new').focus();
		  }else{
		  	var qty_old  = $('#qty_old').val();
			var qty_new  = $('#qty_new').val();
			
			var qty_diff = 0;
			/* if(parseFloat(qty_new)>parseFloat(qty_old)){
				qty_diff = parseFloat(qty_new)-parseFloat(qty_old);
			}else{
				qty_diff = parseFloat(qty_old)-parseFloat(qty_new);
			} */
			qty_diff = parseFloat(qty_new)-parseFloat(qty_old);
			$('#qty_diff').val(qty_diff);
			$('#qty_diff_').text(qty_diff);
		  }
	}
</script>

<form id="save_stock_form" onsubmit="return false;">
<input type="hidden"  value="<%=entity.getQty_old()%>" id="qty_old">
<fieldset style="width: 400px;margin-top: 10px">
<legend>&nbsp;<Strong>Stock Detail</Strong>&nbsp;</legend>
	<table cellpadding="3" cellspacing="3" border="0" class="s400 center">
		<tbody>
			<tr>
				<td width="50%" align="right" colspan="2"><label><strong>OLD</strong></label></td>
				<td width="50%" align="center" colspan="2"><label><strong>NEW</strong></label></td>
			</tr>
			<tr>
				<td><label>QTY(New):</label></td>
				<td align="center"><%=entity.getQty_new() %><input type="hidden"  value="<%=entity.getQty_new()%>" id="qty_newed"></td>
				<td colspan="2" align="center"><input type="text" id="qty_new" name="qty_new" onkeyup='checkNumber(this)' style="text-align: center;width: 50px" autocomplete="off" ></td>
			</tr>
			<tr valign="top">
				<td><label>QTY(Old):</label></td>
				<td align="center"><%=entity.getQty_old() %></td>
				<td colspan="2" align="center"><%=entity.getQty_old() %></td>
			</tr>
			<tr valign="top">
				<td><label>Difference:</label></td>
				<td align="center"><label id="qty_diffed"></label></td>
				<td colspan="2" align="center"><label id="qty_diff_" ></label></td>
			</tr>
			<tr>
				<td colspan="4" align="center">
					<input type="submit" class="btn_box " value="Save" style="margin-top: 20px">
					<input type="button" class="btn_box " value="Cancel" onclick="tb_remove();">
					<input type="hidden"  value="edit_stock" name="action">
					<input type="hidden"  value="<%=pn%>" name="pn">
					<input type="hidden"  value="<%=check_id%>" name="check_id">
					<input type="hidden"  value="<%=seq%>" name="seq">
					<input type="hidden"  id="qty_diff" name="qty_diff">
					<input type="hidden"  value="<%=securProfile.getPersonal().getPer_id()%>" name="update_by">
				</td>
			</tr>
		</tbody>
	</table>
</fieldset>
</form>