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
<script src="../js/jquery.validate.js"></script>



<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการใบเสนอราคา</title>
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
		$('#sale_order_info').submit(function(){
				ajax_load();
				$.post('SaleManage',$(this).serialize(),function(resData){
					ajax_remove();
					if (resData.status == 'success'){	
					popup('qt_report.jsp?order_id=' + resData.order_id + '&cus_id=' + resData.cus_id + '&qt_id=' + resData.qt_id);
						window.location = 'sale_qt.jsp';		
					} else {					
						alert(resData.message);
					}
				},'json');		
		});	
		$('#print').click(function(){
			popup('qt_report.jsp?order_id=<%=order_id%>&cus_id=<%=cus_id%>&qt_id=<%=qt_id%>');			
			
		});
		
	$('.btn_del_item').click(function(){
		if (confirm('ยืนยันการลบ!')) {
			var data = {
						'action':'del_item_all',
						'status':$(this).attr('status'),
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
					if (resData.cancel == true) {
						window.location='sale_qt.jsp';
					} else {
						window.location.reload();
					}
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
				<div class="left">1. รายการใบเสนอราคา | 2. เลือกใบเสนอราคาหมายเลข  <%=qt_id%></div>
				<div class="right btn_box m_right15" onclick="window.location='sale_order_info.jsp?order_id=<%=order_id%>&cus_id=<%=cus_id%>'">ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="sale_order_info" onsubmit="return false;">
				<div class="right">วันที่ : <%=WebUtils.getDateValue(WebUtils.getCurrentDate())%></div>
				<table width="40%" cellpadding="2" cellspacing="2">
					<tbody>
						<tr>
							<td width="130" align="left">เรียน</td>
							<td width="65%">: <input class="txt_box s200" type="text" name="send_by" value="<%=qt.getSend_by()%>" />  </td>
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
						<tr>
							<td>ประเภทการขนส่ง</td>
							<td>: <%=Customer.ship(cus.getCus_ship())%></td>
						</tr>
						<tr>
							<td>วันกำหนดส่ง</td>
							<td>: <%=WebUtils.getDateValue(order.getDue_date())%></td>
						</tr>
					</tbody>
				</table>
				
				
				<div class="dot_line m_top10"></div>
				<div class="left">ทางบริษัท ฯ ขอเสนอราคาสินค้ามายังท่านตามรายการ ดังต่อไปนี้</div>
				
						<table class="bg-image s930">
							<thead>
								<tr>
									<th valign="top" align="center" width="5%">เลขที่</th>
									<th valign="top" align="center" width="30%">รายการสินค้า</th>
									<th valign="top" align="center" width="6%">ขนาดบรรจุ</th>
									<th valign="top" align="center" width="1%">จำนวน</th>
									<th valign="top" align="center" width="12%">ราคาต่อหน่วย</th>
									<th valign="top" align="center" width="6%">ส่วนลด</th>
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
								<td valign="top" align="left" colspan="3">
									<%=pac.getName()%>
									<br>	
									<%
										while (itePK.hasNext()){
											PackageItem item = map.get((String)itePK.next()) ;		
											%>- <%=item.getUIMat().getDescription()%> จำนวน  <%=item.getQty()%> <%=item.getUIMat().getDes_unit()%><br>					
										<%
										}
										%>
										<%=itemOrder.getRemark()%>
								</td>		
								<td valign="top" align="right">
									<%=Money.money(pac.getPrice())%>
								</td>
								<td valign="top" align="right"><%=(itemOrder.getDiscount().equalsIgnoreCase("")?"0":itemOrder.getDiscount())%>%
									<%
									String status = itemOrder.getStatus();
									if(status.equalsIgnoreCase(SaleOrderItem.STATUS_PLAN_SUBMIT) || status.equalsIgnoreCase(SaleOrderItem.STATUS_SEND_QT)){		
									%>
									<div class="thickbox txt_red pointer" title="แก้ไขส่วนลด" 
									lang="sale_discount_edit.jsp?item_run=<%=itemOrder.getItem_run()%>&item_id=<%=itemOrder.getItem_id()%>&item_type=p&height=200&width=450">แก้ไข</div>
									<%
									}
									%>			
								</td>
								<td valign="top" align="right">
											<%
											String sum = "";
											String dis =  itemOrder.getDiscount();
											if(itemOrder.getDiscount().equalsIgnoreCase("")){
												dis = "0";
											}
											sum = Money.divide(Money.multiple(itemOrder.getUnit_price(),dis),"100");
											%>
											<% sum = Money.money(Money.subtract(itemOrder.getUnit_price(),sum));%>
											<%=sum%>
								</td>
								<td valign="top" align="right">
									<%
									if(qt.getStatus().equalsIgnoreCase(SaleQt.STATUS_APPROVE)){
										%>
										<div class="btn_box btn_warn m_left5 btn_del_item" status="<%=itemOrder.getStatus()%>" order_id="<%=order_id%>" qt_id="<%=qt_id%>" item_id="<%=itemOrder.getItem_id()%>" item_run="<%=itemOrder.getItem_run()%>">ลบ</div>
									<%			
									}
									%>
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
												<br>
												<%=itemOrder.getRemark()%>
											</td>
											<td valign="top" align="center"><%=mat.getDes_unit()%></td>
											<td valign="top" align="center"><%=itemOrder.getItem_qty()%></td>
											<td valign="top" align="right">
												<%=Money.money(itemOrder.getUnit_price())%>
												<%
												String status = itemOrder.getStatus();
												if(qt.getStatus().equalsIgnoreCase(SaleQt.STATUS_APPROVE)){
													
												%>
												<div class="thickbox txt_red pointer" title="แก้ไขราคา" 
												lang="sale_price_edit.jsp?order_id=<%=itemOrder.getOrder_id()%>
												&item_run=<%=itemOrder.getItem_run()%>
												&unit_price=<%=itemOrder.getUnit_price()%>
												&item_id=<%=itemOrder.getItem_id()%>
												&qt_id=<%=itemOrder.getQt_id()%>
												&height=200&width=450">แก้ไข</div>
												<%
												}
												%>					
											</td>
											<td valign="top" align="right"><%=(itemOrder.getDiscount().equalsIgnoreCase("")?"0":itemOrder.getDiscount())%>%
												<%
												if(qt.getStatus().equalsIgnoreCase(SaleQt.STATUS_APPROVE)){		
												%>
												<div class="thickbox txt_red pointer" title="แก้ไขส่วนลด" 
												lang="sale_discount_edit.jsp?item_run=<%=itemOrder.getItem_run()%>&item_id=<%=itemOrder.getItem_id()%>&height=200&width=450">แก้ไข</div>
												<%
												}
												%>
											</td>
											<td valign="top" align="right">
												<%
													String sum = "";
													String dis =  itemOrder.getDiscount();
													if(itemOrder.getDiscount().equalsIgnoreCase("")){
														dis = "0";
													}
													sum = Money.multiple(itemOrder.getItem_qty(),itemOrder.getUnit_price());
													dis = Money.divide(Money.multiple(sum,dis),"100");
													sum = Money.money(Money.subtract(sum, dis));
													%>
													<%=sum%>	
											</td>
											<td valign="top" align="center">
											<%
											if(qt.getStatus().equalsIgnoreCase(SaleQt.STATUS_APPROVE)){
												%>
												<div class="btn_box btn_warn m_left5 btn_del_item" status="<%=status%>" order_id="<%=order_id%>" qt_id="<%=qt_id%>" item_id="<%=itemOrder.getItem_id()%>" item_run="<%=itemOrder.getItem_run()%>">ลบ</div>
												<%
											}
											%>
											</td>
										</tr>
											<%
									
									}
									i++;
									
								}
								%>
								<tr>
									<td colspan="2">เงื่อนไขการชำระเงิน :</td>
									<td colspan="2">
									<input autocomplete="off" class="txt_box s200" name="credit" type="text" value="<%=(qt.getCredit().equals("")?cus.getCus_credit():qt.getCredit())%>" /></td>
									<td>ระยะเวลาการส่ง :</td>
									<td colspan="3"><input autocomplete="off" class="txt_box s200" id="remark_date" name="remark_date" type="text" value="<%=qt.getRemark_date()%>" /></td>
								</tr>
								<tr>
									<td colspan="2">Remark :</td>
									<td colspan="6"><input autocomplete="off" class="txt_box s500"  name="remark" type="text" value="<%=qt.getRemark()%>" /></td>
							</tbody>
						</table>
						<div class="txt_center">
							
					
						</div>					
						
				
						<input type="hidden" name="qt_id" id="qt_id" value="<%=qt_id%>">
						<input type="hidden" name="order_id" id="order_id" value="<%=order_id%>">
						<input type="hidden" name="cus_id" id="cus_id" value="<%=cus_id%>">
						<div class="center txt_center m_top5">
						<%
						if(qt.getStatus().equalsIgnoreCase(SaleOrder.STATUS_SEND_QT) || qt.getStatus().equalsIgnoreCase(SaleOrderItem.STATUS_NOT_AP_YET) || qt.getStatus().equalsIgnoreCase(SaleQt.STATUS_APPROVE)){
						%>
							<button type="submit" class="btn_box btn_confirm" id="btn_print">บันทึกเป็นไฟล์</button>
							<input type="hidden" name="action" value="qt_update">	
							<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">		
						<%						
						}else{
						%>						
							<button type="button" class="btn_box" id="print">พิมพ์</button>				
						<%
						}
						%>	
						</div>	
					
				</form>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>	
</div>

</body>
</html>