
<%@page import="com.bitmap.bean.logistic.Busstation"%>
<%@page import="com.bitmap.bean.logistic.SendProduct"%>
<%@page import="com.bitmap.bean.sale.Province"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.sale.Zipcode"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
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
<script src="../js/popup.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายงานส่งสินค้าประจำวัน</title>
<%

String zip = WebUtils.getAjaxReqString(request, "zip");
String province_id = WebUtils.getAjaxReqString(request, "province_id");
String sent_id = WebUtils.getReqString(request, "sent_id"); 
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"sent_id",sent_id});
paramList.add(new String[]{"zip_code",zip});
paramList.add(new String[]{"province_id",province_id});

session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = SendProduct.selectWithCTRL(ctrl, paramList).iterator();
%>
</head>

<script type="text/javascript">
$(function(){
	$('#province_id').change(function(){
		form_load($('#sale_order_info'));
			$.post('../sale/SaleManage',{'action':'get_zip','province_id':$(this).val()},function(resData){
				form_remove();
				if (resData.status == 'success') {	
					var j = resData.zip_code;
					
					var options = '<option value=""> --- เลือกเขต --- </option>';
					for(var i = 0;i < j.length;i++){
						options += '<option value="' + j[i][0] + '">' + j[i][1] + '</option>';	
					}
					$('#zip_code').html(options);					
				} else{
					alert(resData.message);
				}
			},'json');	
		
	});
});
</script>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายงานส่งสินค้าประจำวัน</div>
			</div>
			<div class="content_body">
					<form id="sale_order_info" style="margin: 0; padding: 0;" action="logis_report.jsp" id="search" method="get">
			
					<div class="detail_wrap s800 center txt_center">
							เลขที่คิวรถ : <input class="txt_box" type="text" name="sent_id" value="<%=sent_id%>">
							&nbsp;&nbsp;
							จังหวัด : 
							<% List<String[]> listProvince = Province.selectList("th", "66"); %>
							<bmp:ComboBox name="province_id" styleClass="txt_box" listData="<%=listProvince%>" value="10"></bmp:ComboBox>
							&nbsp;&nbsp;
							zipcode : 
							<%List<String[]> listZip = Zipcode.getComboList("th", "10"); %>
							<bmp:ComboBox name="zip_code" styleClass="txt_box" listData="<%=listZip%>"></bmp:ComboBox>
							&nbsp;&nbsp;
							<br><br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
							<input type="hidden" name="action" value="report_send">
							<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">		
					</div>
					</form>
									
				<!-- next page -->  
				<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"logis_report.jsp",paramList)%></div>
				<div class="clear"></div>
				<!-- next page  -->
					<div class="dot_line m_top5"></div>
					<div class="clear"></div>
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="10">เลขที่คิวรถ</th>
								<th valign="top" align="center" width="30%">บริษัท</th>
								<th valign="top" align="center" width="20%">คนขับ</th>
								<th valign="top" align="center" width="10%">กำหนดส่ง</th>
								<th valign="top" align="center" width="15%">สถานะ</th>
								<th align="center" width="10%"></th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								SendProduct entity = (SendProduct) ite.next();
								Busstation bus = entity.getUIBus();
								has = false;
						%>
							<tr>
								<td valign="top" align="center"><%=entity.getRun()%></td>
								<td valign="top" align="center"><%=bus.getCompany()%></td>
								<td valign="top" align="center"><%=bus.getDriver()%></td>
								<td valign="top" align="center"><%=WebUtils.getDateValue(entity.getSend_date())%></td>
								<td valign="top" align="center"><%=SendProduct.status(entity.getStatus())%></td>
								<td valign="top" align="center"><img class="pointer" src="../images/clipboard_16.png" onclick="popup('report.jsp?run=<%=entity.getRun()%>&qid=<%=bus.getQid()%>')"></img></td>
							</tr>
						<%
							}
							
							if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการคิวรถ ---- </td></tr>
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