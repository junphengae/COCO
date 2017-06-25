<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการขอจัดซื้อ</title>
<%
String po = WebUtils.getReqString(request, "po");
PurchaseOrder PO = PurchaseOrder.select(po);
%>
</head>
<body>
	
<div class="center txt_center m_top10">
	<form id="po_form" onsubmit="return false;">
		<div><b>เลือกลักษณะการยกเลิก</b></div>
		<div class="m_top10">
			<input type="radio" name="status" id="po_terminate" value="<%=PurchaseRequest.STATUS_PO_TERMINATE%>"> <label for="po_terminate">ยกเลิกใบสั่งซื้อ</label>&nbsp;&nbsp;
			<input type="radio" name="status" id="po_terminate_4_new" value="<%=PurchaseRequest.STATUS_PO_TERMINATE%>"> <label for="po_terminate_4_new">ยกเลิกเพื่อออกใบใหม่</label>
		</div>
		
		<div class="m_top10">หมายเหตุ: <input type="text" name="note" class="txt_box s300" autocomplete="off"></div>
		
		<div class="m_top15">
			<button type="submit" class="btn_box btn_warn">ทำการยกเลิก</button>
			<button type="button" class="btn_box" onclick="tb_remove();">ปิดหน้าจอ</button>
			<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
			<input type="hidden" name="po" value="<%=po%>">
			<input type="hidden" name="vendor_id" value="<%=PO.getVendor_id()%>">
		</div>
		
	</form>
</div>

<script type="text/javascript">
$(function(){
	$('#po_form').submit(function(){
		if ($('#po_terminate').is(':checked') || $('#po_terminate_4_new').is(':checked')) {
			if (confirm('ยืนยันการยกเลิกใบสั่งซื้อ')) {
				ajax_load();
				
				if ($('#po_terminate').is(':checked')){
					$.post('PurchaseManage',$('#po_form').serialize() + '&action=cancel_po',function(resData){
						ajax_remove();
						if (resData.status == 'success') {
							window.location='<%=LinkControl.link("po_list.jsp", (List)session.getAttribute("PO_SEARCH"))%>';
						} else {
							alert(resData.message);
						}
					},'json');
				} else {
					$.post('PurchaseManage',$('#po_form').serialize() + '&action=cancel_po_4_new',function(resData){
						ajax_remove();
						if (resData.status == 'success') {
							window.location='po_issue_review.jsp?reference_po=<%=po%>&po=' + resData.po;
						} else {
							alert(resData.message);
						}
					},'json');
				}
			}
		} else {
			alert('กรุณาเลือกลักษณะการยกเลิก!');
		}
	});
});
</script>
</body>
</html>