<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%
PurchaseRequest purReq = new PurchaseRequest();
WebUtils.bindReqToEntity(purReq, request);

PurchaseRequest.select(purReq);
InventoryMaster master = purReq.getUIInvMaster();
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>


</head>
<body>
<form id="order_approve_form" onsubmit="return false;">
	<div class="center txt_center txt_bold m_top5">
		การอนุมัติขอจัดซื้อ
	</div>
	
	<div class="center m_top10 s450">
		<table>
			<tr class="txt_bold">
				<td width="30%">รหัสสินค้า</td>
				<td width="70%">: <%=master.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + master.getUISubCat().getUICat().getCat_name_short() + ((master.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + master.getUISubCat().getSub_cat_name_short():"")%>-<%=master.getMat_code()%></td>
			</tr>
			<tr class="txt_bold">
				<td>ชื่อสินค้า</td>
				<td>: <%=master.getDescription()%></td>
			</tr>
			<tr><td colspan="2" height="15"></td></tr>
			
			
			<tr>
				<td>ราคาที่สั่งซื้อ</td>
				<td>: <%=purReq.getOrder_price() + " ฿/" + master.getStd_unit() + " | " + Money.money(Money.multiple(purReq.getOrder_price(), master.getUnit_pack())) + " ฿/" + master.getDes_unit()%></td>
			</tr>
			<tr>
				<td>จำนวนขอสั่งซื้อ</td>
				<td>: <%=Money.money(purReq.getOrder_qty()) + " " + master.getStd_unit() + " | (" + Money.divide(purReq.getOrder_qty(), master.getUnit_pack()) + " " + master.getDes_unit() + ")"%></td>
			</tr>
			<tr>
				<td>ราคารวมทั้งหมด</td>
				<td>: <span class="txt_red"><%=Money.money(Money.multiple(purReq.getOrder_qty(), purReq.getOrder_price()))%> บาท </span></td>
			</tr>
			<tr><td colspan="2" height="15"></td></tr>
			<tr>
				<td>หมายเหตุ</td>
				<td>: <input type="text" name="note" class="txt_box s250" value="<%=purReq.getNote()%>"></td>
			</tr>
		</table>
	</div>
	
	<script type="text/javascript">
	$(function(){
		$('#btn_approve').click(function(){
			if (confirm('ยืนยันการอนุมัติขอจัดซื้อ <%=master.getDescription()%> : <%=purReq.getOrder_qty()%> <%=master.getStd_unit()%> !')) {
				ajax_load();
				$.post('PurchaseManage',$('#order_approve_form').serialize() + '&action=md_approve',function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						remove_tr('<%=purReq.getId()%>');
					} else {
						alert(resData.message);
					}
				},'json');
			}
		});
		
		$('#btn_reject').click(function(){
			if (confirm('ท่านต้องการ "ยกเลิก" รายการนี้ ใช่หรือไม่ ?')) {
				ajax_load();
				$.post('PurchaseManage',$('#order_approve_form').serialize() + '&action=md_reject',function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						remove_tr('<%=purReq.getId()%>');
					} else {
						alert(resData.message);
					}
				},'json');
			}
		});
		
		function remove_tr(id){
			$('#tr_' + id).hide();
			tb_remove();
		}
	});
	</script>
	
	<div class="center txt_center m_top10">
		<input type="hidden" name="id" value="<%=purReq.getId()%>">
		<input type="hidden" name="mat_code" value="<%=purReq.getMat_code()%>">
		<input type="hidden" name="approve_by" value="<%=securProfile.getPersonal().getPer_id()%>">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
		<input type="button" class="btn_box btn_confirm" id="btn_approve" value="อนุมัติ">
		<input type="button" class="btn_box btn_confirm" id="btn_reject" value="ไม่อนุมัติ">
		<input type="button" class="btn_box" value="ปิดหน้าต่าง" onclick="javascript: tb_remove();">
	</div>
				
</form>
</body>
</html>