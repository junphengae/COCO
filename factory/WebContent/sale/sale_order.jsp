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
<title>รายการขาย</title>
<%

String status = WebUtils.getReqString(request, "status");
String order_type = WebUtils.getReqString(request, "order_type");
String sale_by = WebUtils.getReqString(request, "sale_by");
String create_by = WebUtils.getReqString(request, "create_by");
String due_date = WebUtils.getReqString(request, "due_date");
String cus_name = WebUtils.getReqString(request, "cus_name");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"due_date",due_date});
paramList.add(new String[]{"create_by",create_by});
paramList.add(new String[]{"status",status});
paramList.add(new String[]{"sale_by",sale_by});
paramList.add(new String[]{"cus_name",cus_name});
paramList.add(new String[]{"order_type",order_type});


session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = SaleOrder.selectWithCTRL(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการขาย</div>
				<div class="right m_right10">
					<button class="btn_box btn_confirm" onclick="window.location='sale_order_select_customer.jsp';">สร้างรายการขาย</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 center txt_center">
						<form style="margin: 0; padding: 0;" action="sale_order.jsp" id="search" method="get">
							สถานะ: 
							<bmp:ComboBox name="status" styleClass="txt_box s150" listData="<%=SaleOrder.statusDropDown()%>" value="<%=status%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
							</bmp:ComboBox>
							&nbsp;&nbsp;
							
							ประเภท: 
							<bmp:ComboBox name="order_type" styleClass="txt_box s150" listData="<%=SaleOrder.typeDropDown()%>" value="<%=order_type%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
							</bmp:ComboBox>
							&nbsp;&nbsp;
							
							กำหนดส่ง : 
							<input type="text" name="due_date" id="due_date" class="txt_box" autocomplete="off" value="<%=due_date%>">
							
							<%-- <bmp:ComboBox name="month" styleClass="txt_box s100" style="<%=ComboBoxTag.EngMonthList%>" value="<%=month%>">
								<bmp:option value="" text="--- ทุกเดือน ---"></bmp:option>
							</bmp:ComboBox>
							<bmp:ComboBox name="year" styleClass="txt_box s100" style="<%=ComboBoxTag.EngYearList%>" value="<%=year%>"></bmp:ComboBox>
							 --%>
							 <br><br>
							<% List list = Personal.listDropdown("0010");%>
							ชื่อพนักงานขาย:
								<bmp:ComboBox name="sale_by" styleClass="txt_box s150" listData="<%=list%>" value="<%=sale_by%>">
									<bmp:option value="" text="---- เลือกทั้งหมด ----"></bmp:option>
									<bmp:option value="all" text="ศูนย์กลาง"></bmp:option>
								</bmp:ComboBox>				
							ชื่อผู้ออก:
								<bmp:ComboBox name="create_by" styleClass="txt_box s150" listData="<%=list%>" value="<%=create_by%>">
									<bmp:option value="" text="---- เลือกทั้งหมด ----"></bmp:option>
								</bmp:ComboBox>	
							ลูกค้า :
							<input type="text" class="txt_box" id="cus_name" name="cus_name" value="<%=cus_name%>">
							<br><br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
						</form>
					</div>
					
					<div class="dot_line m_top5"></div>
					
					
					<div class="clear"></div>
					
					<!-- next page -->  
					<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"sale_order.jsp",paramList)%></div>
					<div class="clear"></div>
					<!-- next page  -->
				
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="50">Order No.</th>
								<th valign="top" align="center" width="15%">ผู้ออก</th>
								<th valign="top" align="center" width="10%">วันที่ออก</th>
								<th valign="top" align="center" width="10%">กำหนดส่ง</th>
								<th valign="top" align="center" width="20%">ลูกค้า</th>
								<th valign="top" align="center" width="12%">ประเภท</th>
								<th valign="top" align="center" width="13%">สถานะ</th>
								<th align="center" width="80"></th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								SaleOrder entity = (SaleOrder) ite.next();
								Customer cus = entity.getUICustomer();
								Personal sale = entity.getUISale();
								has = false;
						%>
							<tr>
								<td align="right"><%=entity.getOrder_id()%></td>
								<td><%=sale.getName() + " " + sale.getSurname()%></td>
								<td align="center"><%=WebUtils.getDateValue(entity.getCreate_date())%></td>
								<td align="center"><%=(entity.getDue_date()==null)?"":WebUtils.getDateValue(entity.getDue_date())%></td>
								<td><%=cus.getCus_name()%></td>
								<td align="center"><%=SaleOrder.type(entity.getOrder_type())%></td>
								<td align="center"><%=SaleOrder.status(entity.getStatus())%></td>
								<td align="center">
									<%
									if(securProfile.getPersonal().getPer_id().equalsIgnoreCase(entity.getCreate_by()) && (entity.getStatus().equalsIgnoreCase(SaleOrder.STATUS_SALE_CREATE))) {
									%>
									<button class="btn_confirm btn_box" onclick="window.location='sale_order_<%=(entity.getStatus().equalsIgnoreCase(SaleOrder.STATUS_SALE_CREATE))?"create":"info"%>.jsp?order_id=<%=entity.getOrder_id()%>&cus_id=<%=entity.getCus_id()%>';">กำลังสร้าง</button>
									<%
									}else {
									%>
									<img class="pointer" src="../images/search_16.png" onclick="window.location='sale_qt_info.jsp?order_id=<%=entity.getOrder_id()%>&cus_id=<%=entity.getCus_id()%>';"></img>
									<%		
									}
									if(entity.getStatus().equalsIgnoreCase(SaleOrder.STATUS_FIN)){
									%>
									<img class="pointer img_onclick" height="20" width="20" src="../images/Select-icon.png" order_id="<%=entity.getOrder_id()%>"></img>
									
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
				<div class="wrap_desc">
				- หน้าจอนี้ใช้แสดงรายการขายทั้งหมด รวมทั้งบอกสถานะของรายนั้นๆ ว่ากำลังไปถึงขั้นตอนไหน
				</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	<script type="text/javascript">
	$(function(){
	$('#due_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
	});
	$('.img_onclick').click(function(){
		if (confirm('ยืนยันการรับสินค้า!')) {
			var data = {
						'action':'update_order_end',
						'order_id':$(this).attr('order_id'),
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>'
					   };
			
			ajax_load();
			$.post('SaleManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location = "sale_order.jsp";
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	</script>
</div>

</body>
</html>