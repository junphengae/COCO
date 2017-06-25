<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="java.awt.print.Printable"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.sun.org.apache.bcel.internal.generic.NEWARRAY"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItemMat"%>
<%@page import="com.bitmap.bean.rd.MatTree"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.bean.rd.RDFormularDetail"%>
<%@page import="com.bitmap.bean.rd.RDFormularStep"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.util.StatusUtil"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
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
<script src="../js/popup.js" type="text/javascript"></script>

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">


<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>อนุมัติการผลิต</title>
<%
SaleOrderItem orderItem = new SaleOrderItem();
WebUtils.bindReqToEntity(orderItem, request);
SaleOrderItem.select(orderItem);

SaleOrder order = new SaleOrder();
order = SaleOrder.selectByID(orderItem.getOrder_id());

Personal sale = new Personal();
sale = Personal.select(order.getSale_by());

RDFormular formular = new RDFormular();
formular.setMat_code(orderItem.getItem_id());
RDFormular.select(formular);

String volume = Money.multiple((formular.getVolume().length() > 0)?formular.getVolume():"0",orderItem.getItem_qty());

String cal_yeild = Money.divide(Money.multiple(volume,"100"),(formular.getYield().equalsIgnoreCase("0")?"100":formular.getYield()));
InventoryMaster mat = formular.getUIMat();

HashMap<String, MatTree> matMap = new HashMap<String, MatTree>();
HashMap<String, MatTree> pkMap = new HashMap<String, MatTree>();
List<MatTree> ssList = new ArrayList <MatTree>();

RDFormular.ObjectTree(cal_yeild, formular, matMap, pkMap, ssList);

Iterator iteMap = matMap.keySet().iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">1. รายการสินค้าสั่งผลิต | 2. วัตถุดิบที่ใช้ในการผลิต</div>
				<div class="right">
					<%-- <button class="btn_box btn_send btn_confirm thickbox" lang="plan_noproduce_fg.jsp?width=500&height=200&item_run=<%=orderItem.getItem_run()%>&item_id=<%=orderItem.getItem_id()%>" title="ไม่ต้องผลิต">ไม่ต้องผลิต</button> --%>
				</div>
				<div class="right btn_box m_right15" onclick="history.back();">ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<div class="detail_wrap s900 center">
				<table width="100%" cellpadding="2" cellspacing="2">
					<tbody>
						<tr>
							<td width="130">ชื่อลูกค้า</td>
							<td width="370"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=order.getCus_id()%>&height=300&width=520">: <%=order.getUICustomer().getCus_name()%></div></td>
							<td width="130">ชื่อพนักงานขาย  </td>
							<td>: <%=(order.getSale_by().equalsIgnoreCase("all")?"ศูนย์กลาง":sale.getName() + " " + sale.getSurname())%></td>
						</tr>
						<tr>
							<td width="130">ประเภท</td>
							<td width="370">: <%=SaleOrder.type(order.getOrder_type())%></td>
							<td width="130">กำหนดส่งของ  </td>
							<td>: <%=DBUtility.getDateValue(order.getDue_date())%></td>
						</tr>
					</tbody>
				</table>
				</div>
				<div class="dot_line m_top10"></div>
				
				<div class="detail_wrap s900 center">
					<fieldset class="fset">
						<legend>รายละเอียดสินค้า</legend>
						<table class="s880">
							<tr>								
								<td width="150">ชื่อสินค้า</td>
								<td>: <%=mat.getDescription()%></td>
							</tr>	
							<tr>
								<td>จำนวนคงคลัง</td>
								<td>: <%=mat.getBalance() + " " + mat.getDes_unit()%>
								</td>								
								<td>จำนวนที่มีการจอง</td>
								<td>:<% String sum = SaleOrderItem.bookfg(mat.getMat_code(),"s");%>
								<%=(sum.equalsIgnoreCase("")?"0":sum) + " " + mat.getDes_unit()%></td>
							</tr>			
							<tr>
								<td>จำนวน</td>
								<td>: <%=orderItem.getItem_qty()%> <%=mat.getDes_unit()%>
								</td>
								<td>จำนวน / บรรจุภัณฑ์</td>
								<td>: <%=formular.getVolume() + " " + mat.getStd_unit()%> / <%=mat.getDes_unit()%> 
								</td>
							</tr>
							<tr>
								<td>สินค้าที่ต้องผลิตทั้งหมด</td>
								<td>: <%=volume + " " + mat.getStd_unit()%>
								</td>
								<td>R&D Yield</td>
								<td>: <%=Money.money(Money.divide(Money.multiple(volume,"100"),formular.getYield())) + " " + mat.getStd_unit()%>
								</td>
							<tr>
								<td>วันที่ร้องขอ </td>
								<td>: <%=WebUtils.getDateValue(orderItem.getRequest_date())%>
								</td>
								<td>วันที่เริ่มผลิต </td>
								<td>: <%=WebUtils.getDateValue(orderItem.getStart_date())%>
								</td>
							</tr>
							<tr>
								<td>วันที่เสร็จ </td>
								<td>: <%=WebUtils.getDateValue(orderItem.getConfirm_date())%>
								</td>
								<td>สถานะ </td>
								<td class="txt_bold txt_red">: <%=SaleOrderItem.status(orderItem.getStatus())%>
								</td>
							</tr>	
						</table>
						
					</fieldset>
					
					<div class="dot_line m_top15"></div>
					
					<fieldset class="fset">
						<legend>จำนวนวัตถุดิบ</legend>
						<div class="clear"></div>
							
						<table class="bg-image s880">
							<thead>
								<tr>
									<th valign="top" align="center" width="13%">รหัส</th>
									<th valign="top" align="center" width="20%">ชื่อวัตถุดิบ</th>
									<th valign="top" align="center" width="9%">จำนวนที่ต้องใช้(KG)</th>
									<th valign="top" align="center" width="12%">จำนวนคงคลัง(KG)</th>
									<th valign="top" align="center" width="12%">จำนวนที่จอง(KG)</th>
									<th valign="top" align="center" width="15%"></th>
								</tr>
							</thead>
							<tbody>
							<%
							int count = 0;
							while(iteMap.hasNext()){
								String mat_code = (String) iteMap.next();
								MatTree tree = matMap.get(mat_code);
								if(tree.getGroup_id().equalsIgnoreCase("MT")){
								%>
								<tr>
									<td align="center"><%=mat_code + "  (" + tree.getGroup_id() + ")"%></td>
									<td align="left"><%=tree.getDescription()%></td>
									<td align="right"><%=Money.money(tree.getRequest_qty())%></td>
									<td align="right"><%=Money.money(tree.getInv_qty())%></td>
									<td align="right"><%=Money.money(tree.getPlan_qty())%></td>
									<td align="center"></td>
									
								</tr>		
								<%
								}
							}
							
							Iterator<MatTree> ss = ssList.iterator();
							while (ss.hasNext()){
								MatTree ssmap = ss.next();
								count++;
								%>
								<tr onclick="$('#tr_<%=ssmap.getMat_code()%>').slideToggle();" class="pointer">
									<td align="center"><%=ssmap.getMat_code() + "  (" + ssmap.getGroup_id()+ ")"%></td>
									<td align="left"><%=ssmap.getDescription()%></td>
									<td align="right"><%=Money.money(ssmap.getRequest_qty())%></td>
									<td align="right"><%=Money.money(ssmap.getInv_qty())%></td>
									<td align="right"><%=Money.money(ssmap.getPlan_qty())%></td>
									<td align="left"><img src="../images/arrow_down.jpg" height="20" width="20">
									<%
									
									
									boolean check = Production.selectSS(orderItem.getItem_run(),ssmap.getMat_code(),orderItem.getItem_id());
									if(check == false){
										if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_SAMPLE)){
										%>
										<button class="btn_confirm btn_box thickbox" lang="plan_produce_sample.jsp?width=500&height=200&item_id=<%=ssmap.getMat_code()%>&item_run=<%=orderItem.getItem_run()%>&item_qty=<%=ssmap.getRequest_qty()%>&item_type=SS&parent_id=<%=orderItem.getItem_id()%>" title="เลือก">เลือก</button>
										<%	
										}else{
										%>
										<button class="btn_confirm btn_box thickbox" lang="plan_produce.jsp?width=500&height=200&item_id=<%=ssmap.getMat_code()%>&item_run=<%=orderItem.getItem_run()%>&item_qty=<%=ssmap.getRequest_qty()%>&item_type=SS&parent_id=<%=orderItem.getItem_id()%>" title="เลือก">เลือก</button>
										<%
										}
									}
									boolean checkHavePD = Production.checkItemrunAndItemid(orderItem.getItem_run(),ssmap.getMat_code());
									if(!(checkHavePD)){
									%>
									<button class="btn_box btn_send btn_confirm thickbox" lang="plan_noproduce_ss.jsp?width=500&height=200&item_run=<%=orderItem.getItem_run()%>&item_id=<%=ssmap.getMat_code()%>&item_qty=<%=ssmap.getRequest_qty()%>&item_type=SS&parent_id=<%=orderItem.getItem_id()%>" title="ไม่ต้องผลิต">ไม่ผลิต</button>
									<%} %>
									</td>								
								</tr>
								<tr class="hide" id="tr_<%=ssmap.getMat_code()%>">	
									<td colspan="6">
										<fieldset class="fset">
											<legend><%=ssmap.getMat_code() + " - "+ssmap.getDescription()%></legend>
										
										<table>
										<thead>
											<tr>
												<th valign="top" align="center" width="13%">รหัส</th>
												<th valign="top" align="center" width="20%">ชื่อวัตถุดิบ</th>
												<th valign="top" align="center" width="9%">จำนวนที่ต้องใช้(KG)</th>
												<th valign="top" align="center" width="12%">จำนวนคงคลัง(KG)</th>
												<th valign="top" align="center" width="12%">จำนวนที่จอง(KG)</th>
												<th valign="top" align="center" width="12%"></th>
											</tr>
										</thead>
										<tbody>	
								<%
								
								HashMap<String, MatTree> sumSS = new HashMap<String, MatTree>();
								sumSS = RDFormular.sumMatcode(ssmap.getMat());
								
								Iterator mtINss = sumSS.keySet().iterator();
								//Iterator<MatTree> mtINss = sumSS.iterator();
								while (mtINss.hasNext()){
									String mat_code = (String) mtINss.next();
									MatTree tree = sumSS.get(mat_code);								
									%>	
										
									<tr>
										<td align="center"><%=tree.getMat_code()+ "  (" + tree.getGroup_id()+ ")"%></td>
										<td align="left"><%=tree.getDescription() %></td>
										<td align="right"><%=Money.money(tree.getRequest_qty())%></td>
										<td align="right"><%=Money.money(tree.getInv_qty())%></td>
										<td align="right"><%=Money.money(tree.getPlan_qty())%></td>
										<td align="center">
											<%
											if(tree.getGroup_id().equalsIgnoreCase("SS")){
											count++;
											boolean checkInSS = Production.selectSS(orderItem.getItem_run(),tree.getMat_code(),ssmap.getMat_code());
												if(checkInSS == false){
													if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_SAMPLE)){
													%>
														<button class="btn_confirm btn_box thickbox" lang="plan_produce_sample.jsp?width=500&height=200&parent_id=<%=ssmap.getMat_code()%>&item_id=<%=tree.getMat_code()%>&item_run=<%=orderItem.getItem_run()%>&item_qty=<%=tree.getRequest_qty()%>&item_type=SS" title="เลือก">เลือก</button>
													<%	
													}else{
													%>
														<button class="btn_confirm btn_box thickbox" lang="plan_produce.jsp?width=500&height=200&parent_id=<%=ssmap.getMat_code()%>&item_id=<%=tree.getMat_code()%>&item_run=<%=orderItem.getItem_run()%>&item_qty=<%=tree.getRequest_qty()%>&item_type=SS" title="เลือก">เลือก</button>
													<%
													}
												}
											}
											%>
										</td>								
									</tr>						
									<%	
								}
								%>
									</tbody>
									</table>	
									</fieldset>
									</td>
								</tr>
								<%
							}
							%>
							</tbody>		
						</table>						
						
					</fieldset>
										
					
					<div class="dot_line m_top15"></div>
					<fieldset class="fset">
						<legend>จำนวนบรรจุภัณฑ์</legend>
						<div class="clear"></div>
					
							<table class="bg-image s880">
								<thead>
									<tr>
										<th valign="top" align="center" width="13%">รหัส</th>
										<th valign="top" align="center" width="20%">ชื่อบรรจุภัณฑ์</th>
										<th valign="top" align="center" width="9%">จำนวนที่ต้องใช้</th>
										<th valign="top" align="center" width="12%">จำนวนคงคลัง</th>
										<th valign="top" align="center" width="12%">จำนวนที่จอง</th>
										<th valign="top" align="center" width="12%">บรรจุภัณฑ์</th>
									</tr>
								</thead>
								
								<tbody>	
								<%
								int i = 0;
								Iterator itePk = pkMap.keySet().iterator();
								while(itePk.hasNext()){
									
									String mat_code = (String) itePk.next();
									MatTree tree = pkMap.get(mat_code);
									InventoryMaster master = new InventoryMaster();
									master = InventoryMaster.select(mat_code);
									
								%>
									<tr>
										<td align="center"><%=mat_code%></td>
										<td align="left"><%=tree.getDescription()%></td>
										<td align="right"><%=Money.multiple(tree.getOrder_qty(),orderItem.getItem_qty())%></td>
										<td align="right"><%=tree.getInv_qty()%></td>
										<td align="right"><%=tree.getPlan_qty()%></td>
										<td align="center"><%=master.getStd_unit()%></td>
										
									</tr>	
								<%
								}			
								%>	
								</tbody>		
							</table>	
					</fieldset>
							
							<div class="center s300 txt_center m_top5">
							<%
							boolean ck_ss = Production.checkItemtype(orderItem.getItem_run(),count,"SS");
							if(ck_ss == true){
								boolean ck_fg = Production.checkItemtype(orderItem.getItem_run(),1,"FG");
								if(ck_fg == false){
									if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_SAMPLE)){
									%>
									<button class="btn_box btn_send btn_confirm thickbox" lang="plan_produce_sample.jsp?width=500&height=200&item_id=<%=orderItem.getItem_id()%>&item_run=<%=orderItem.getItem_run()%>&item_qty=<%=orderItem.getItem_qty()%>&item_type=FG" title="ส่งฝ่ายผลิต">ส่งฝ่ายผลิต</button>
									<% }else if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_SGI)){ 
									%>
									<button class="btn_box btn_send btn_confirm" id="btn_click_send">ส่งฝ่ายผลิต</button>
									<% }else { 
									%>
									<button class="btn_box btn_send btn_confirm thickbox" lang="plan_produce.jsp?width=700&height=250&item_id=<%=orderItem.getItem_id()%>&item_run=<%=orderItem.getItem_run()%>&item_qty=<%=volume%>&item_type=FG" title="ส่งฝ่ายผลิต">ส่งฝ่ายผลิต</button>
									<%
									}
								}
							}
							%>
							</div>	
				</div>				
				<script type="text/javascript">
					$('#btn_click_send').click(function(){
						if (confirm('ยืนยันการส่ง!')) {
							var data = {
										'action':'add_product_ghost_sgi',
										'item_qty2':'<%=volume%>',
										'order_type':'<%=order.getOrder_type()%>',
										'item_type':'FG',
										'status':'20',
										'item_run':'<%=orderItem.getItem_run()%>',
										'item_id':'<%=orderItem.getItem_id()%>',
										'create_by':'<%=securProfile.getPersonal().getPer_id()%>'
									   };
							
							ajax_load();
							$.post('../sale/SaleManage',data, function(resData){
								ajax_remove();
								if (resData.status == 'success') {
									popup('report_item.jsp?item_run=' + resData.item_run + '&item_id=' + resData.item_id + '&order_id=' + resData.order_id + '&pro_id=' + resData.pro_id +'&type=' + resData.type);
									window.location.reload();									
								} else {
										alert(resData.message);
								}
							},'json');
						}
					});
				</script>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>