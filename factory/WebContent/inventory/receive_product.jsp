<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.sale.Receive"%>
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

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รับคืน</title>
<%
String id_receive = WebUtils.getReqString(request, "id_receive");
String cus_id = WebUtils.getReqString(request, "cus_id");
String status = "10";
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"id_receive",id_receive});
paramList.add(new String[]{"cus_id",cus_id});
paramList.add(new String[]{"status",status});
session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}


%>
<script type="text/javascript">
$(function(){
	$('#sal_receive').submit(function(){
			ajax_load();	
			$.post('SaleManage',$('#sal_receive').serialize(),function(resData){
				ajax_remove();
				if (resData.status == 'success') {	
					window.location.reload();
				} else {					
					alert(resData.message);
				}
			},'json');	
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
				<div class="left">รับคืน</div>
			</div>
			
			<div class="content_body">
			<form style="margin: 0; padding: 0;" action="receive_product.jsp" id="search" method="get">
					<div class="detail_wrap s800 center txt_center">
							เลขที่ใบคืน: 
							<input type="text" class="txt_box" name="id_receive" value="<%=id_receive%>"> 
							<br>
							<br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>							
					</div>
			</form>	
			<form id="sal_receive" onsubmit="return false;">			
					<div class="dot_line m_top5"></div>				
					<div class="clear"></div>
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="10%">เลขที่ใบคืน</th>
								<th valign="top" align="center" width="30%">รายการ</th>
								<th valign="top" align="center" width="15%">วันที่คืน</th>
								<th valign="top" align="center" width="15%"></th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							Iterator ite = Receive.selectInvWithCTRL(ctrl, paramList).iterator();
							while(ite.hasNext()) {
								Receive entity = (Receive) ite.next();
								InventoryMaster mat = entity.getUImat();
								has = false;
						%>
							<tr>
								<td align="right"><%=entity.getId_receive()%></td>
								<td><%=mat.getDescription()%></td>
								<td align="center"><%=WebUtils.getDateValue(entity.getReceive_date())%></td>
								<td align="center">
									<button class="btn_box btn_confirm thickbox" title="รับเข้า" lang="receive_check.jsp?width=450&height=200&id_receive=<%=entity.getId_receive()%>">เลือก</button>	
								</td>
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการใบคืน ---- </td></tr>
						<%
							}
							
						%>
						</tbody>
					</table>	
				</form>							
			</div>
			
			<div class="wrap_desc">
				- หน้าจอนี้ใช้แสดงรายการรับสินค้าคืนจากพนักงานขาย เพื่อรอการตรวจสอบจำนวนสินค้าที่คืนจากฝ่ายคลังสินค้า
			</div>

		</div>
		
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>