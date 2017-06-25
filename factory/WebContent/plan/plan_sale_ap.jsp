<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
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
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>อนุมัติการผลิต</title>
<%

String status = WebUtils.getReqString(request, "status"); 
String request_date = WebUtils.getReqString(request, "request_date"); 
String cus_name = WebUtils.getReqString(request, "cus_name"); 
String order_type = WebUtils.getReqString(request, "order_type");
String start_date = WebUtils.getReqString(request, "start_date"); 
String description = WebUtils.getReqString(request, "description"); 
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();

paramList.add(new String[]{"status",status});
paramList.add(new String[]{"request_date",request_date});
paramList.add(new String[]{"order_type",order_type});
paramList.add(new String[]{"cus_name",cus_name});
paramList.add(new String[]{"start_date",start_date});
paramList.add(new String[]{"description",description});

session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}


%>
<script type="text/javascript">
$(function(){
	setTimeout(function(){
		window.location.reload();
	}, 60000);
	$('#request_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
	$('#start_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
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
				<div class="left">อนุมัติการผลิต</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 center txt_center">
						<form style="margin: 0; padding: 0;" action="plan_sale_ap.jsp" id="search" method="get">
							ประเภท: 
							<bmp:ComboBox name="order_type" styleClass="txt_box s150" listData="<%=SaleOrder.typeDropDown()%>" value="<%=order_type%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
								<bmp:option value="<%=SaleOrder.TYPE_BUFFER%>" text="Buffer"></bmp:option>
							</bmp:ComboBox>
							กำหนดส่ง : 
							<input type="text" name="request_date" id="request_date" class="txt_box" autocomplete="off" value="<%=request_date%>">
							วันที่เริ่มผลิต : 
							<input type="text" name="start_date" id="start_date" class="txt_box" autocomplete="off" value="<%=start_date%>">
							<br><br>
							ลูกค้า :
							<input type="text" class="txt_box" id="cus_name" name="cus_name" value="<%=cus_name%>">
							
							ชื่อสินค้า :
							<input type="text" class="txt_box" id="description" name="description" value="<%=description%>">
							<br><br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
						</form>
					</div>
					
				<!-- next page -->  
				<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"plan_sale_ap.jsp",paramList)%></div>
				<div class="clear"></div>
				<!-- next page  -->
				
					<div class="dot_line m_top5"></div>
					
					
					<div class="clear"></div>
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="10%">No.</th>
								<th valign="top" align="center" width="20%">ลูกค้า</th>
								<th valign="top" align="center" width="10%">ประเภท</th>
								<th valign="top" align="center" width="10%">กำหนดส่ง</th>
								<th valign="top" align="center" width="30%">รายการสินค้า</th>
								<th valign="top" align="center" width="15%">จำนวน</th>
								<th valign="top" align="center" width="10%">สถานะ</th>
								<th align="center" width="5%"></th>
							</tr>
						</thead>
						<tbody>
						<%
							Iterator ite = SaleOrderItem.select_ap_item(ctrl, paramList).iterator();
							boolean has = true;
							while(ite.hasNext()) {
								SaleOrderItem entity = (SaleOrderItem) ite.next();
								InventoryMaster mat = entity.getUIMat();
								SaleOrder order = entity.getUIOrder();
								Package pac = entity.getUIPac();
								
								has = false;
						%>	
						<tr>
							<td valign="top" align="right"><%=entity.getItem_run()%></td>
							<td valign="top" align="left"><%=entity.getUINameCus()%></td>
							<td valign="top" align="center"><%=SaleOrder.type(order.getOrder_type())%></td>
							<td valign="top" align="center"><%=WebUtils.getDateValue(entity.getRequest_date())%></td>
							<td valign="top" align="left">
							<%
								if(entity.getItem_type().equalsIgnoreCase("p")){
								
							%>PRO-<%=pac.getName()%>
							<%	
								}else {
								%><%=mat.getGroup_id() + "-" + mat.getDescription() %>
								<%
								}
							%>
							</td>
							<td valign="top" align="right">
							<% if(entity.getItem_type().equalsIgnoreCase("p")){
								%><%=pac.getPk_qty() + " ชุด"%>
							<% }else{ 
								if(mat.getGroup_id().equalsIgnoreCase("SS")){
								%><%=entity.getItem_qty()+ " KG"%>	
								<% }else{
								%><%=entity.getItem_qty()+ " " + mat.getDes_unit()%>
							
							<%	}
								} %>	
							</td>
							<td valign="top" align="center"><%=SaleOrderItem.status(entity.getStatus())%></td>
							<td valign="top" align="center">
								<%if(mat.getGroup_id().equalsIgnoreCase("fg")){ 
								%>
									<input type="button" class="btn_box m_left5" onclick="window.location='plan_ap_fg.jsp?order_id=<%=entity.getOrder_id()%>&item_id=<%=mat.getMat_code()%>&cus_id=<%=order.getCus_id()%>&item_run=<%=entity.getItem_run()%>'" value="เลือก"/>	
								<% 
								}else if(mat.getGroup_id().equalsIgnoreCase("ss")) { %>
									<input type="button" class="btn_box m_left5" onclick="window.location='plan_ap_buffer.jsp?order_id=<%=entity.getOrder_id()%>&item_id=<%=mat.getMat_code()%>&item_run=<%=entity.getItem_run()%>'" value="เลือก"/>	
									<%} else{ %>
									<input type="button" class="btn_box m_left5" onclick="window.location='plan_ap_promotion.jsp?order_id=<%=entity.getOrder_id()%>&pk_id=<%=entity.getItem_id()%>&item_id=<%=entity.getItem_id()%>&cus_id=<%=order.getCus_id()%>&item_run=<%=entity.getItem_run()%>'" value="เลือก"/>	
								
								<% }%>			
							</td>
						</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="7" align="center">---- ไม่พบรายการสินค้า ---- </td></tr>
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