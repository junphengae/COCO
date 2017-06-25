<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<!-- Date -->
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>


<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Inlet</title>
<%
PurchaseOrder po = new PurchaseOrder();
WebUtils.bindReqToEntity(po, request);
boolean has = PurchaseOrder.check(po);
%>
<script type="text/javascript">
$(function(){
	$('#po').focus();
	
	var form = $('#search');
	//$.metadata.setType("attr", "validate");
	var v = form.validate({
		submitHandler: function(){
			ajax_load();
			$.post('../PurchaseManage',form.serialize(),function(json){
				ajax_remove();
				if (json.status == 'success') {
					window.location='inlet_invoice.jsp?po=' + $('#po').val();
				} else {
					alert(json.message);
					$('#po').val('').focus();
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
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">
					1: รับเข้าสินค้า | 2: รับเข้าจากการสั่งซื้อ
				</div>
				<div class="right m_right20">
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="center txt_center">
						<form onsubmit="return false;" id="search">
							เลขที่ใบสั่งซื้อ: 
							<input type="text" name="po" id="po" class="txt_box required s120" autocomplete="off" value="<%=(has)?po.getPo():""%>" title="*">
							<input type="hidden" name="action" value="checkPO">
							<button class="btn_box btn_confirm" name="submit" type="submit">ค้นหา</button>
							<button class="btn_box" type="button" onclick="clear_form(this.form);$('#po').focus();">ล้าง</button>
						</form>
					</div>
					
					<div class="clear"></div>
					
					<div class="dot_line"></div>
					
					<%if(has){ 
						Vendor vendor = po.getUIVendor();
						Iterator ite = po.getUIOrderList().iterator();
					%>
					<fieldset class="fset">
						<legend>ตัวแทนจำหน่าย</legend>
						<table width="98%" class="center">
							<tr height="24" valign="top">
								<td width="120">บริษัท (Order To)</td>
								<td>: <span id="view_vendor_name"><%=vendor.getVendor_name() %></span></td>
							</tr>
							<tr height="24" valign="top">
								<td>ถึง (ATTN)</td>
								<td>: <span id="view_vendor_attn"><%=vendor.getVendor_contact()%></span></td>
							</tr>
							<tr height="24" valign="top">
								<td>โทร (TEL)</td>
								<td> 
									<div class="left s350">: <span id="view_vendor_phone"><%=vendor.getVendor_phone() %></span></div>
									<div class="left">แฟกซ์ (FAX) : <span id="view_vendor_fax"><%=vendor.getVendor_fax() %></span></div>
									<div class="clear"></div>
								</td>
							</tr>
						</table>
					</fieldset>
					
					<div class="m_top10"></div>
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th align="center" width="8%">ที่<br>(No.)</th>
								<th valign="top" align="center" width="12%">รหัสสินค้า<br>(Mat Code)</th>
								<th valign="top" align="center" width="30%">รายการสินค้า<br>(Description)</th>
								<th valign="top" align="center" width="20%">จำนวนที่สั่ง<br>(Quantity)</th>
								<th valign="top" align="center" width="20%">จำนวนที่รับเข้าแล้ว</th>
								<th></th>
							</tr>
						</thead>
						<tbody>
						<%
							int i = 1;
							String gross_amount = "0";
							while(ite.hasNext()) {
								PurchaseRequest entity = (PurchaseRequest) ite.next();
								InventoryMaster master = entity.getUIInvMaster();
						%>
							<tr id="tr_<%=entity.getId()%>" valign="middle">
								<td align="center"><%=i++%></td>
								<td><%=master.getMat_code()%></td>
								<td>
									<div class="thickbox pointer" lang="../info/inv_master_info.jsp?width=800&height=380&mat_code=<%=entity.getMat_code()%>" title="ข้อมูลสินค้า"><%=master.getDescription()%></div>
								</td>
								<td align="center"><%=entity.getOrder_qty()%> <%=master.getStd_unit()%></td>
								<td align="center"><%=entity.getUIInletSum()%> <%=master.getStd_unit()%></td>
								<td align="center">
									<%if(entity.getStatus().equalsIgnoreCase(PurchaseRequest.STATUS_PO_OPEN)){ %>
									<button class="thickbox btn_box" lang="inlet_control.jsp?width=800&height=600&po=<%=po.getPo()%>&id=<%=entity.getId()%>" title="รายละเอียดการรับเข้า: <%=master.getDescription()%>">รับเข้า</button>
									<%}%>
								</td>
							</tr>
						<%
							}
						%>
						</tbody>
					</table>
					<%}%>
				
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>