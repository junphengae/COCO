<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
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
<title>ประเมินรายการขาย</title>
<%
String due_date = WebUtils.getReqString(request, "due_date");
String status = WebUtils.getReqString(request, "status");
String order_type = WebUtils.getReqString(request, "order_type");
String cus_name = WebUtils.getReqString(request, "cus_name");
String create_date = WebUtils.getReqString(request, "create_date");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"status",status});
paramList.add(new String[]{"order_type",order_type});
paramList.add(new String[]{"due_date",due_date});
paramList.add(new String[]{"cus_name",cus_name});
paramList.add(new String[]{"create_date",create_date});

session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = SaleOrderItem.select_PlanSale(ctrl, paramList).iterator();
%>
<script type="text/javascript">
$(function(){
	setTimeout(function(){
		window.location.reload();
	}, 60000);
	
	$('.btn_reject').click(function(){
		if (confirm('ยืนยันการยกเลิก!')) {
			var data = {
						'action':'reject_sale',
						'order_id':$(this).attr('order_id'),
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>'
					   };		
			ajax_load();
			$.post('../sale/SaleManage',data, function(resData){
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
				<div class="left">ประเมินรายการขาย</div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 center txt_center">
						<form style="margin: 0; padding: 0;" action="plan_sale.jsp" id="search" method="get">
							ประเภท: 
							<bmp:ComboBox name="order_type" styleClass="txt_box s150" listData="<%=SaleOrder.typeDropDown()%>" value="<%=order_type%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
							</bmp:ComboBox>
							กำหนดส่ง : 
							<input type="text" name="due_date" id="due_date" class="txt_box" autocomplete="off" value="<%=due_date%>">
							วันที่ร้องขอ : 
							<input type="text" name="create_date" id="create_date" class="txt_box" autocomplete="off" value="<%=create_date%>">
							<br>
							ลูกค้า :
							<input type="text" class="txt_box" id="cus_name" name="cus_name" value="<%=cus_name%>">
							สถานะ: 
							<bmp:ComboBox name="status" styleClass="txt_box s150" value="<%=status%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
								<bmp:option value="20" text="รอวางแผน"></bmp:option>
								<bmp:option value="30" text="วางแผนแล้ว"></bmp:option>
							</bmp:ComboBox>
							&nbsp;&nbsp;
							<br><br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
						</form>
					</div>
					
					<div class="dot_line m_top5"></div>
					
					
					<div class="clear"></div>
					
				<!-- next page  -->
				<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"plan_sale.jsp",paramList)%></div>
				<div class="clear"></div>
				<!-- next page  -->
					<table class="bg-image s930">
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
							boolean has = true;
							while(ite.hasNext()) {
								SaleOrderItem entity = (SaleOrderItem) ite.next();
								has = false;
						%>
							<tr>
							<td valign="top" align="right"><%=entity.getItem_run()%></td>
							<td valign="top" align="left"><%=entity.getUINameCus()%></td>
							<td valign="top" align="center"><%=SaleOrder.type(entity.getUISumAll())%></td>
							<td valign="top" align="center"><%=WebUtils.getDateValue(entity.getRequest_date())%></td>
							<td valign="top" align="left">
							<%
								if(entity.getItem_type().equalsIgnoreCase("p")){
								
							%>PRO-<%=entity.getUIPacName()%>
							<%	
								}else {
								%>FG-<%=entity.getUIMatName()%>
								<%
								}
							%>
							</td>
							<td valign="top" align="right">
							<% if(entity.getItem_type().equalsIgnoreCase("p")){
								%><%=entity.getUIMatType() + " ชุด"%>
							<% }else{ 
								%><%=entity.getItem_qty()%>
							<%
								} %>	
							</td>
							<td valign="top" align="center"><%=SaleOrderItem.status(entity.getStatus())%></td>
							<td valign="top" align="center">
								<%if(entity.getItem_type().equalsIgnoreCase("s")){
								%>
									<input type="button" class="btn_box m_left5" onclick="window.location='plan_sale_fg.jsp?item_run=<%=entity.getItem_run()%>'" value="เลือก"/>	
								<% 
								}else{
								%>	
									<input type="button" class="btn_box m_left5" onclick="window.location='plan_sale_promotion.jsp?pk_id=<%=entity.getItem_id()%>&item_run=<%=entity.getItem_run()%>'" value="เลือก"/>	
								<%} %>	
							</td>
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการใบสั่งซื้อสินค้า ---- </td></tr>
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
<script type="text/javascript">
	$(function(){
	$('#due_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
	$('#create_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
	});
</script>
</body>
</html>