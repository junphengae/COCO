<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleQt"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.webutils.PageControl"%>
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

<script src="../js/popup.js" type="text/javascript"></script>
<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/jquery.validate.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>อนุมัติรายการใบเสนอราคา</title>
<%
String qt_id = WebUtils.getReqString(request, "qt_id"); 
String cus_name = WebUtils.getReqString(request, "cus_name"); 
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"qt_id",qt_id});
paramList.add(new String[]{"cus_name",cus_name});

session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = SaleOrderItem.selectWithCTRL(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">อนุมัติรายการใบเสนอราคา</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 txt_center">
						<form style="margin: 0; padding: 0;" action="sale_ap_qt.jsp" id="search" method="get">
							ลูกค้า : <input class="txt_box" type="text" name="cus_name" value="<%=cus_name%>">
							&nbsp;&nbsp;
							เลขที่ใบเสนอราคา : <input class="txt_box" type="text" name="qt_id" value="<%=qt_id%>">
							&nbsp;&nbsp;
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
						</form>
					</div>
					
					<div class="dot_line m_top5"></div>
					<!-- next page -->  
					<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"sale_ap_qt.jsp",paramList)%></div>
					<div class="clear"></div>
					<!-- next page  -->

					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="8%">เลขที่ใบเสนอราคา</th>
								<th valign="top" align="center" width="10%">ลูกค้า</th>
								<th valign="top" align="center" width="30%">รายการสินค้า</th>
								<th valign="top" align="center" width="7%">จำนวน</th>
								<th valign="top" align="center" width="10%">ราคา</th>
								<th valign="top" align="center" width="11%">ประเภท</th>
								<th valign="top" align="center" width="10%">สถานะ</th>
								<th align="center" width="10%"></th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								SaleOrderItem entity = (SaleOrderItem) ite.next();
								InventoryMaster mat = entity.getUIMat();
								Package pac = entity.getUIPac();
								SaleOrder order = entity.getUIOrder();
								has = false;
						%>	
						<tr>
							<td valign="top" align="right"><%=entity.getQt_id()%></td>
							<td valign="top" align="left"><%=entity.getUINameCus()%></td>
							<td valign="top" align="left">
							<%
							
								if(entity.getItem_type().equalsIgnoreCase("p")){
								
							%><%="PRO -- " +pac.getName()%>
							<%	
								}else {
								%><%="FG -- " +mat.getMat_code() + " -- " + mat.getDescription() %>
								<%
								}
							%>
							</td>
							<td valign="top" align="center"><%=entity.getItem_qty()%></td>
							<td valign="top" align="center">
									<%
									String sum = "";
									String dis = entity.getDiscount();
									if(entity.getDiscount().equalsIgnoreCase("")){
										dis = "0";
									}
									if(entity.getItem_type().equalsIgnoreCase("s")){
										sum = Money.multiple(entity.getItem_qty(),entity.getUnit_price());
										dis = Money.divide(Money.multiple(sum,dis),"100");
										sum = Money.money(Money.subtract(sum, dis));
										%>
										<%=sum%>
										<%
									}else{	
										sum = Money.divide(Money.multiple(entity.getUnit_price(),dis),"100");
									%>
										<%=sum = Money.money(Money.subtract(entity.getUnit_price(),sum))%>
									<%
									}
									%>
							
							</td>
							<td valign="top" align="center"><%=SaleOrder.type(order.getOrder_type())%></td>
							<td valign="top" align="center"><%=SaleOrderItem.status(entity.getStatus())%></td>
							<td valign="top" align="center">
								<%
								if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_GHOST) || order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_25) || order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_SGI)){
								%>
									<button lang="ap_order.jsp?order_type=<%=order.getOrder_type()%>&order_id=<%=entity.getOrder_id()%>&qt_id=<%=entity.getQt_id()%>&item_run=<%=entity.getItem_run()%>&width=500&height=150" title="อนุมัติรายการนี้" class="btn_box btn_confirm thickbox" id="Cancel">อนุมัติ</button>		
									<%	
								}else if(entity.getStatus().equalsIgnoreCase(SaleOrderItem.STATUS_NOT_AP_YET)){%>
									<button lang="ap_order_wait.jsp?order_id=<%=entity.getOrder_id()%>&qt_id=<%=entity.getQt_id()%>&item_run=<%=entity.getItem_run()%>&width=500&height=150" title="อนุมัติรายการนี้" class="btn_box btn_confirm thickbox" id="Cancel">อนุมัติ</button>						
								<%}else{ %>
									<button lang="ap_order_item.jsp?order_id=<%=entity.getOrder_id()%>&qt_id=<%=entity.getQt_id()%>&item_run=<%=entity.getItem_run()%>&width=500&height=150" title="อนุมัติรายการนี้" class="btn_box btn_confirm thickbox" id="Cancel">อนุมัติ</button>		
									
								<%}%>
								<button lang="plan_noproduce_fg.jsp?item_run=<%=entity.getItem_run()%>&item_id=<%=mat.getMat_code()%>&width=700&height=220" title="เบิกจาก Store" class="btn_box btn_warn thickbox" id="Cancel">เบิกจาก sto.</button>			
							</td>
						</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="7" align="center">---- ไม่พบรายการอนุมัติใบเสนอราคา ---- </td></tr>
						<%
							}
						%>
						</tbody>
					</table>
					
				</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>

</body>
</html>