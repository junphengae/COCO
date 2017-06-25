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
<title>รายการ Buffer</title>
<%
String create_date = WebUtils.getReqString(request, "create_date");
String status = WebUtils.getReqString(request, "status");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"create_date",create_date});
paramList.add(new String[]{"status",status});

session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = SaleOrder.selectWithCTRLTypeBuffer(ctrl,paramList).iterator();
%>
<script type="text/javascript">
$(function(){
	setTimeout(function(){
		window.location.reload();
	}, 60000);
	$('#create_date').datepicker({
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
				<div class="left">รายการ Buffer</div>
				<div class="right m_right10">
					<button class="btn_box btn_confirm" onclick="window.location='plan_order_buffer.jsp';">สร้างรายการ Buffer</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 center txt_center">
						<form style="margin: 0; padding: 0;" action="plan_buffer.jsp" id="search" method="get">
							สถานะ: 
							<bmp:ComboBox name="status" styleClass="txt_box s150" listData="<%=SaleOrder.statusDropDownForBuffer()%>" value="<%=status%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
							</bmp:ComboBox>
							วันที่สั่งผลิต : 
							<input type="text" name="create_date" id="create_date" class="txt_box" autocomplete="off" value="<%=create_date%>">
							<br><br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
						</form>
					</div>
					
					
					<div class="dot_line m_top5"></div>
					
					
					<div class="clear"></div>
					
					<!-- next page -->  
					<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"plan_buffer.jsp",paramList)%></div>
					<div class="clear"></div>
					<!-- next page  -->
				
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="10%">Buffer No.</th>
								<th valign="top" align="center" width="15%">ผู้ออก</th>
								<th valign="top" align="center" width="15%">วันที่สั่งผลิต</th>
								<th valign="top" align="center" width="15%">สถานะ</th>
								<th valign="top" align="center" width="30%">*หมายเหตุ</th>
								<th align="center" width="10%"></th>
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
								<td align="center"><%=SaleOrder.status(entity.getStatus())%></td>
								<td align="left"><%=entity.getRemark()%></td>
								<td align="center">
									<%
									if(securProfile.getPersonal().getPer_id().equalsIgnoreCase(entity.getCreate_by()) && (entity.getStatus().equalsIgnoreCase(SaleOrder.STATUS_SALE_CREATE))) {
									%>
									<button class="btn_confirm btn_box" onclick="window.location='plan_order_buffer.jsp?order_id=<%=entity.getOrder_id()%>';">กำลังสร้าง</button>
									<%
									}else {
									%>
									<button class="btn_box" onclick="window.location='plan_buffer_info.jsp?order_id=<%=entity.getOrder_id()%>';">ดู</button>
									<%		
									}
									%>								
								</td>
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการ Buffer ---- </td></tr>
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