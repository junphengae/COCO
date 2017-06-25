<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<jsp:useBean id="invMaster" class="com.bitmap.bean.inventory.InventoryMaster" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Outlet Withdraw</title>
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>
<script src="../js/number.js"></script>
</head>
<body>
<%
String mat_code = WebUtils.getReqString(request, "mat_code");
String fifo 	= WebUtils.getReqString(request, "fifo");

InventoryMaster entity = new InventoryMaster();
entity = InventoryMaster.select(mat_code);

%>
<form id="withdrawForm" onsubmit="return false;">
<table width="100%" class="m_top10">
	<tbody>	
		<tr>
			<td width="30%">Lot สินค้า</td>
			<td width="70%">: <input type="text" autocomplete="off" name="lot_no" id="lot_no" class="txt_box s200 input_focus"></td>
		</tr>
	</tbody>
</table>

<table width="100%" id="tb_input" class="hide">
	<tbody>
		<tr>
			<td width="30%">จำนวนสินค้าใน Lot</td>
			<td width="70%">: <span id="lot_balance"></span> <%=(entity.getGroup_id().equalsIgnoreCase("FG")?entity.getDes_unit():entity.getStd_unit())%></td>
		</tr>
		<tr><td colspan="2" height="20"></td></tr>
		<tr>
			<td>จำนวนที่เบิก</td>
			<td>: <input type="text" autocomplete="off" name="request_qty" id="request_qty" class="txt_box s200"> <span style="color: red;"><%=(entity.getGroup_id().equalsIgnoreCase("FG")?entity.getDes_unit():entity.getStd_unit())%></span> </td>
		</tr>
		<tr>
			<td>เลขอ้างอิงการเบิก</td>
			<td>: <input type="text" autocomplete="off" name="request_no" id="request_no" class="txt_box s200"></td>
		</tr>
		<tr>
			<td>ผู้เบิกสินค้า</td>
			<td>: 
				<input type="text" class="txt_box" id="request_by_autocomplete">
			</td>
		</tr>
		<tr><td colspan="2" height="10"></td></tr>
		<tr>
			<td colspan="2" align="center">
				<button type="button" class="btn_box" id="btn_withdraw">เบิกสินค้า</button>
				<input type="hidden" name="request_by" id="request_by">
				<input type="hidden" name="request_type" id="request_type">
				<input type="hidden" name="lot_id" id="lot_id">
				<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
				<input type="hidden" name="action" value="withdraw"> 
				<input type="hidden" name="lot_balance" value="">
				<input type="hidden" name="mat_code" value="<%=mat_code%>">
			</td>
		</tr>
	</tbody>
</table>
</form>
<script type="text/javascript">
var mat_code = '<%=mat_code%>';
var txt_lot_no 		= $('#lot_no');
var tb_input		= $('#tb_input');
var td_lot_balance	= $('#lot_balance');
var txt_request_qty	= $('#request_qty');

txt_lot_no.keypress(function(e){
	if(e.keyCode == 13){
		ajax_load();
		$.post('OutletManagement',{action:'check_fifo',mat_code:'<%=mat_code%>',lot_no:$(this).val()},function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				txt_lot_no.attr('readOnly',true);
				tb_input.fadeIn(300);
				
				var lot_ctrl = resData.lot.lot_control;
				td_lot_balance.append(lot_ctrl.lot_balance);
				$('input[name=lot_balance]').val(lot_ctrl.lot_balance);
				$('#lot_id').val(lot_ctrl.lot_id);
				$('#request_type').val($('#dd_request_type').val());
				
				txt_request_qty.focus();
			} else {
				alert(resData.message);
			}
		},'json');
	}
});

$("#request_by_autocomplete").autocomplete({
    source: "GetEmployee",
    minLength: 2,
    select: function(event, ui) {
       $('#request_by').val(ui.item.id);
    }
});



$('#btn_withdraw').click(function(){
	var reqVal = parseFloat(txt_request_qty.val()) ;
	var balanceVal = parseFloat(td_lot_balance.text());
	if(isNumber(txt_request_qty.val())){
		if(reqVal != ""){
			
			if (reqVal>balanceVal) {
				alert('จำนวนที่ต้องการเบิกมากกว่าจำนวนที่มีในสต๊อก');
				txt_request_qty.focus();
			}else{
				if($('#request_by').val()!=""){
					ajax_load();
					var data = $('#withdrawForm').serialize();
					//alert(data);
					$.post('OutletManagement',data,function(resData){
						ajax_remove();
						if (resData.status == 'success') {
							alert('เบิกสินค้าเรียบร้อย');
							<%-- window.location = 'outlet.jsp?mat_code=<%=mat_code%>'; --%>
							window.location = 'outlet.jsp';
						} else {
							alert(resData.message);
						}
					},'json');
				} else {
					alert('ยังไม่ได้ระบุผู้เบิกสินค้า!');
					$('#request_by').focus();
				}
			}
		}
	}else{
		alert('กรุณาระบุจำนวนที่ต้องการเบิกเป็นตัวเลข');
		txt_request_qty.focus();
	}
});
</script>
</body>
</html>