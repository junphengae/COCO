<%@page import="com.bmp.parts.check.stock.CheckStockHDBean"%>
<%@page import="com.bmp.parts.check.stock.CheckStockHDTS"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.hr.Division"%>
<%@page import="com.bitmap.bean.hr.Position"%>
<%@page import="com.bitmap.bean.hr.Department"%>
<%@page import="com.bitmap.security.SecurityUser"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script src="../js/number.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/barcode.css" rel="stylesheet" type="text/css" media="all"> 
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	$(function(){
		$('.check_stock_hd').click(function(){
			ajax_load();
			$.post('../CheckStockHDServlet',{action:'add_hd_stock',check_by:$('#check_by').val()}, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location = 'check_stock.jsp?check_id='+resData.check_id;
				} else {
					alert(resData.message);
				}
	        },'json');
		});
		$('.edit_status_approve').click(function(){
			var check_id= $(this).attr('check_id');
			ajax_load();
			$.post('../CheckStockHDServlet',{action:'edit_status_approve',check_id:check_id,update_by:$(this).attr('update_by')}, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location='check_stock.jsp?check_id='+check_id;
				} else {
					alert(resData.message);
				}
	        },'json');
		});
		$('#btn_print').click(function(){
			return true;
		});
	});
</script>

<title>Check Stock</title>
<%

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("PART_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("PART_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("PART_PAGE")));
}

List list = CheckStockHDTS.selectList(ctrl);

CheckStockHDBean entityHD = CheckStockHDTS.getCheckIDSTOCK();

%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
		<input type="hidden" id="check_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Check Stock</div>
					<div class="right">
					
						<%if(entityHD.getStatus().equalsIgnoreCase("10") || entityHD.getStatus().equalsIgnoreCase("20")){ %> 
									 	<input type="button" class="btn_box btn_confirm_stock check_stock_hd" value="check stock"  >
						 <%} else if(entityHD.getCheck_id() == 0 ){%> 
									<input type="button" class="btn_box btn_confirm_stock check_stock_hd" value="check stock" >
						 <%} %>
					</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"stock_info.jsp")%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				<!-- <div class="scroll"> -->
				<form id="form_report" action="../ReportUtilsServlet" target="_blank" method="post" onsubmit="return true;">
				<input type="hidden" name="type" value="check_stock_by_checkId">
				<table class="bg-image  s_auto breakword"><!-- เพิมbreakword มาเพื่อตัดคำ -->
					<thead>
						<tr>
							<th valign="top" align="center" width="14%" >Check ID</th>
							<th valign="top" align="center" width="14%">Status</th>
							<th valign="top" align="center" width="14%">Check Date</th>
							<th valign="top" align="center" width="14%">Check By</th>
							<th valign="top" align="center" width="14%">Approve Date</th>
							<th valign="top" align="center" width="14%">Approve By</th>
							<th valign="top" align="center" width="16%" ></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="10" style="padding: 0px 0px 0px 0px;" width="100%">
								<div class="scroll">
								<table class="bg-image"  style="border-collapse: collapse;" width="100%">
									<%
										boolean has = false;
										Iterator ite = list.iterator();
										while(ite.hasNext()) {
											CheckStockHDBean entity = (CheckStockHDBean) ite.next();
											has = true;
									%>
										<tr>
											<td align="center" valign="top" width="14%">
												<%=entity.getCheck_id()%>
											</td>
											<td align="center" valign="top" width="14%">
												<%if(!entity.getStatus().equalsIgnoreCase("")){ %>
												<%=CheckStockHDTS.status(entity.getStatus())%>
												<%} %>
											</td>
											<td align="center" valign="top" width="14%">
												<%=WebUtils.getDateValue(entity.getCheck_date())%>
											</td>
											<td align="center" valign="top" width="14%">
												<%=entity.getCheck_by()%>
											</td>
											<td align="center" valign="top" width="14%">
												<%=WebUtils.getDateValue(entity.getApprove_date())%>
											</td>
											<td align="center" valign="top" width="14%">
												<%=entity.getApprove_by()%>
											</td>
											<td align="center" valign="top" width="16%">
											
											<%if(entity.getStatus().equalsIgnoreCase("10")){ %>
											
											<%}else if(entity.getStatus().equalsIgnoreCase("00")){ %> 
												<input type="button" class="btn_box edit_status_approve"  value="แก้ไข" check_id="<%=entity.getCheck_id()%>" update_by="<%=securProfile.getPersonal().getPer_id()%>">
												<button  type="submit" class="btn_box  btn_confirm" id="btn_print">พิมพ์</button>
												<input type="hidden" name="check_id" value="<%=entity.getCheck_id()%>">
											<%} else{%>
												<input type="hidden" name="check_id" value="<%=entity.getCheck_id()%>">
												<input type="button" class="btn_box "  value="ดู" onclick="window.location='check_stock.jsp?check_id=<%=entity.getCheck_id()%>' ">
												<button  type="submit" class="btn_box  btn_confirm" id="btn_print">พิมพ์</button>
												<%};%>
											</td>								
										</tr>
									<%
										}
										if(has == false){
									%>	
										<tr>
											<td align="center" colspan="7"> --- ไม่พบรายการ ---</td>
										</tr>
									<%
										}
									%>
								</table>
								</div>	
							</td>		
						</tr>			
					</tbody>
				</table>
				</form>
				<!-- </div> -->
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>