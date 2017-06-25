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
<script src="../js/number.js" type="text/javascript"></script>

<script type="text/javascript" src="../js/popup.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Verify</title>
<%

String status = "20";
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
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
				<div class="left">Verify</div>
			</div>
			
			<div class="content_body">
			<form id="sal_receive" onsubmit="return false;">			
					<div class="dot_line m_top5"></div>				
					<div class="clear"></div>
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="10%">เลขที่ใบคืน</th>
								<th valign="top" align="center" width="30%">รายการ</th>
								<th valign="top" align="center" width="10%">จำนวน</th>
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
								<td align="center"><%=entity.getQty() + " " + mat.getDes_unit() %></td>
								<td align="center"><%=WebUtils.getDateValue(entity.getReceive_date())%></td>
								<td align="center">
									<button class="btn_box btn_confirm thickbox" title="เลือกประเภท" lang="sale_receive_verify_stat.jsp?width=450&height=300&id_receive=<%=entity.getId_receive()%>&order_id=<%=entity.getOrder_id()%>">เลือก</button>	
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
			
				

	</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>