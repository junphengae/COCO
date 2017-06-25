<%@page import="com.bitmap.bean.sale.SaleQt"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/table.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/popup.js" type="text/javascript"></script>
<script src="../js/number.js" type="text/javascript"></script>
<script src="../js/jquery.metadata.js"></script>



<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ใบเสนอราคา</title>
<%
String order_id = WebUtils.getReqString(request, "order_id");
String cus_id = WebUtils.getReqString(request, "cus_id");
String qt_id = WebUtils.getReqString(request, "qt_id");

SaleOrder order = SaleOrder.selectByID(order_id);
SaleQt qt = SaleQt.selectQt_id(qt_id);
Customer cus = Customer.select(cus_id);


%>

<script type="text/javascript">
$(function(){
	
	$('#btn_print').click(function(){
		popup('qt_report.jsp?order_id=<%=order_id%>&cus_id=<%=cus_id%>&qt_id=<%=qt.getQt_id()%>');
	});
	
	$('#sale_order_info').submit(function(){	
			ajax_load();
			$.post('SaleManage',$(this).serialize(),function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {					
					alert(resData.message);
				}
			},'json');			
	});
	
	$('.btn_del_item').click(function(){
		if (confirm('ยืนยันการลบ!')) {
			var data = {
						'action':'del_item_all',
						'order_id':$(this).attr('order_id'),
						'qt_id':$(this).attr('qt_id'),
						'item_id':$(this).attr('item_id'),
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>',
						'item_run':$(this).attr('item_run')
					   };
			
			ajax_load();
			$.post('SaleManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	
	$('.btn_del_pro').click(function(){
		if (confirm('ยืนยันการลบ!')) {
			var data = {
						'action':'del_pro_all',
						'order_id':$(this).attr('order_id'),
						'qt_id':$(this).attr('qt_id'),
						'item_id':$(this).attr('item_id'),
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>',
						'item_run':$(this).attr('item_run')
					   };
			
			ajax_load();
			$.post('SaleManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		}
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
				<div class="left">ใบเสนอราคาเลขที่ <%=qt_id%></div>
				<div class="right btn_box m_right15" onclick="window.location='sale_order_info.jsp?order_id=<%=order_id%>&cus_id=<%=cus_id%>'">ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="right">วันที่ : <%=WebUtils.getDateValue(WebUtils.getCurrentDate())%></div>
				<table width="40%" cellpadding="2" cellspacing="2">
					<tbody>
						<tr>
							<td width="130" align="left">เรียน</td>
							<td width="65%">: <%=cus.getCus_contact()%></td>
						</tr>
						<tr>
							<td>ชื่อลูกค้า</td>
							<td><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=cus.getCus_id()%>&height=300&width=520">: <%=cus.getCus_name()%></div></td>
						</tr>
						<tr>
							<td>ที่อยู่ </td>
							<td>: <%=cus.getCus_address()%></td>
						</tr>
						<tr>
							<td>Tel</td>
							<td>
								<div class="left">: <%=cus.getCus_phone()%></div>
								<div class="right">Fax : <%=cus.getCus_fax()%></div>
								<div class="clear"></div>
							</td>
						</tr>
					</tbody>
				</table>
				
				<form id="sale_order_info" onsubmit="return false;">
				<div class="dot_line m_top10"></div>
				<div class="left">ทางบริษัท ฯ ขอเสนอราคาสินค้ามายังท่านตามรายการ ดังต่อไปนี้</div>
				
						<table class="bg-image s930">
							<thead>
								<tr>
									<th valign="top" align="center" width="5%">No.</th>
									<th valign="top" align="center" width="30%">Product Name</th>
									<th valign="top" align="center" width="6%">ขนาดบรรจุ</th>
									<th valign="top" align="center" width="1%">จำนวน</th>
									<th valign="top" align="center" width="10%">ราคาต่อหน่วย</th>
									<th valign="top" align="center" width="6%">ราคารวม</th>
									<th valign="top" align="center" width="6%"></th>
								</tr>
								<tr>
									
								
							</thead>
								
							<tbody>
								<%
								Iterator ite = SaleOrderItem.selectQt(order_id,qt_id).iterator();
								int i = 1;
								while (ite.hasNext()){
									SaleOrderItem itemOrder = (SaleOrderItem) ite.next();
									InventoryMaster mat = itemOrder.getUIMat();
									RDFormular fm = RDFormular.selectByMatCode(mat.getMat_code());
									Package pac = itemOrder.getUIPac();
									String type = itemOrder.getItem_type();

									if(itemOrder.getItem_type().equalsIgnoreCase("p")){
										HashMap<String, PackageItem> map = PackageItem.SumItem(pac.getPk_id());
										Iterator itePK = map.keySet().iterator();
								%>		
								<tr>
								<td valign="top" align="center">
									<%=i%>
								</td>
								<td valign="top" align="left" colspan="4">
									<%=pac.getName()%>
									<br>
								
								<%
		
										while (itePK.hasNext()){
											PackageItem item = map.get((String)itePK.next()) ;
											
											
											%>- <%=item.getUIMat().getDescription()%> จำนวน  <%=item.getQty()%> <%=item.getUIMat().getDes_unit()%><br>
										<%
										}
										%>
								</td>
	
								<td valign="top" align="right">
									<%=Money.money(pac.getPrice())%>
								</td>
								<td valign="top" align="right">
									<button lang="ap_order_item.jsp?order_id=<%=order_id%>&qt_id=<%=qt_id%>&item_run=<%=itemOrder.getItem_run()%>&width=500&height=150" title="อนุมัติรายการนี้" class="btn_box btn_confirm thickbox" id="Cancel">อนุมัติ</button>
									<button class="btn_box btn_warn m_left5 btn_del_pro" order_id="<%=order_id%>" qt_id="<%=qt_id%>" item_id="<%=itemOrder.getItem_id()%>" item_run="<%=itemOrder.getItem_run()%>">ลบ</button>
								</td>
							</tr>
								<%
										
									}else{
										%>
										<tr>
											<td valign="top" align="center">
												<%=i%>
											</td>
											<td valign="top" align="left">
												<%=mat.getDescription()%>
												<br>
												Code No : <%=mat.getMat_code()%> Ref No :<%=fm.getRef_no()%>
												<br>
												Color : <%=fm.getColour_tone()%>
											</td>
											<td valign="top" align="center"><%=mat.getDes_unit()%></td>
											<td valign="top" align="center"><%=itemOrder.getItem_qty()%></td>
											<td valign="top" align="right">
												<%=Money.money(itemOrder.getUnit_price())%>
												<div class="thickbox txt_red pointer" title="แก้ไขรา คา" 
												lang="sale_price_edit.jsp?order_id=<%=itemOrder.getOrder_id()%>
												&item_run=<%=itemOrder.getItem_run()%>
												&unit_price=<%=itemOrder.getUnit_price()%>
												&item_id=<%=itemOrder.getItem_id()%>
												&qt_id=<%=itemOrder.getQt_id()%>
												&height=300&width=520">แก้ไข</div>						
											</td>
											<td valign="top" align="right"><%=Money.money(Money.multiple(itemOrder.getItem_qty(),itemOrder.getUnit_price()))%></td>
											<td valign="top" align="right">
											<button lang="ap_order_item.jsp?order_id=<%=order_id%>&qt_id=<%=qt_id%>&item_run=<%=itemOrder.getItem_run()%>&width=500&height=150" title="อนุมัติรายการนี้" class="btn_box btn_confirm thickbox" id="Cancel">อนุมัติ</button>
											<button class="btn_box btn_warn m_left5 btn_del_item" order_id="<%=order_id%>" qt_id="<%=qt_id%>" item_id="<%=itemOrder.getItem_id()%>" item_run="<%=itemOrder.getItem_run()%>">ลบ</button>
											</td>
										</tr>
											<%
									
									}
									i++;
									
								}
								%>
								<tr>
									<td colspan="2">เงื่อนไขการชำระเงิน :</td>
									<td colspan="2"><input autocomplete="off" class="txt_box s200" name="credit" type="text" value="<%=(qt.getCredit().equals("")?cus.getCus_credit():qt.getCredit())%>" /></td>
									<td >กำหนดส่งของ :</td>
									<td colspan="3"><input autocomplete="off" class="txt_box s200" name="remark_date" type="text" value="<%=qt.getRemark_date()%>" /></td>
								</tr>
								<tr>
									<td colspan="2">Remark :</td>
									<td colspan="5"><input autocomplete="off" class="txt_box s500"  name="remark" type="text" value="<%=qt.getRemark()%>" /></td>
							</tbody>
						</table>
						<div class="txt_center">
							
					
						</div>					
						
				
						<input type="hidden" name="qt_id" id="qt_id" value="<%=qt_id%>">
						<div class="center txt_center m_top5">
							<button type="submit" name="add" class="btn_box btn_confirm">บันทึก</button>

							<button class="btn_box" id="btn_print">บันทึกเป็นไฟล์</button>
						</div>				
						<input type="hidden" name="action" value="qt_update">	
						<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">		
					
					
				</form>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>	
</div>

</body>
</html>