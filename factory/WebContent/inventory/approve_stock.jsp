<%@page import="com.bmp.parts.check.stock.CheckStockBean"%>
<%@page import="com.bmp.parts.check.stock.CheckStockTS"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
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

<title>Approve Stock</title>
<%
String approve_id = WebUtils.getReqString(request, "approve_id");
String check_id   = WebUtils.getReqString(request, "check_id");
String pn = WebUtils.getReqString(request, "pn");


List paramList = new ArrayList();

paramList.add(new String[]{"check_id",check_id});
paramList.add(new String[]{"pn",pn});

session.setAttribute("APPROVE_STOCK_SEARCH", paramList);

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("APPROVE_STOCK_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("APPROVE_STOCK_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("APPROVE_STOCK_PAGE")));
}

List list = CheckStockTS.selectWithCTRL(ctrl, paramList);
%>
<script type="text/javascript">
	$(function(){
		$('.btn_approve').click(function(){
			var approve_id = '<%=approve_id%>';
			var check_id   = '<%=check_id%>';
			if(confirm('คุณต้องการอนุมัติใช่หรือไม่?')){
				ajax_load();
				$.post('../CheckStockHDServlet',{action:'close_stock',approve_by:$('#approve_by').val(),approve_id:approve_id,check_id:check_id}, function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						alert("อนุมัติเรียบร้อย");
						window.location = 'approve_stock_info.jsp';
					} else {
						alert(resData.message);
					}
		        },'json');
			}
		});
		$('.btn_reject').click(function(){
			var approve_id = '<%=approve_id%>';
			var check_id   = '<%=check_id%>';
			if(confirm('คุณไม่อนุมัติใช่หรือไม่?')){
				ajax_load();
				$.post('../CheckStockHDServlet',{action:'reject_stock',approve_by:$('#approve_by').val(),approve_id:approve_id,check_id:check_id}, function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						window.location = 'approve_stock_info.jsp';
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
				<div class="left">Approve Stock</div>
				<div class="right">
					<input type="hidden" id="approve_by"  value="<%=securProfile.getPersonal().getPer_id()%>" >
					<input type="button" class="btn_box" value="back" onclick="window.location='approve_stock_info.jsp';">
				</div> 
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="approve_stock.jsp" id="search" method="get">
						P/N: 
						<input type="text" class="s120 txt_box" name="pn" value="<%=pn%>" autocomplete="off">  
					
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
						<input type="hidden" name="action" value="search">
						
					</form>
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"approve_stock.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				<!-- <div class="scroll"> -->
				<table class="bg-image  s_auto breakword"><!-- เพิมbreakword มาเพื่อตัดคำ -->
					<thead>
						<tr>
							<th valign="top" align="center" width="15%">P/N</th>
							<th valign="top" align="center" width="23%">Description</th>
							<th valign="top" align="center" width="5%">&nbsp; OLD</th>
							<th valign="top" align="center" width="5%">QTY NEW</th>
							<th valign="top" align="center" width="5%">&nbsp; DIFF</th>
							<th valign="top" align="center" width="10%">status</th>
							<th valign="top" align="center" width="10%">check date</th>
							<th valign="top" align="center" width="10%">close date</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="10" style="padding: 0px 0px 0px 0px;" width="100%">
								<div class="scroll">
								<table class="bg-image"  style="border-collapse: collapse;" width="100%">
									<%
										boolean has = true;
										Iterator ite = list.iterator();
										while(ite.hasNext()) {
											CheckStockBean entity = (CheckStockBean) ite.next();
											has = false;
									%>
										<tr>
											<td align="left" valign="top" width="15%">
												<%=entity.getPn().trim()%>
											</td>
											<td align="left" valign="top" width="23%">
												<%=PartMaster.SelectDesc(entity.getPn())%>
											</td>
											<td align="center" valign="top" width="5%">
													<%=entity.getQty_old()%>
											</td>
											<td align="center" valign="top" width="5%">
													<%=entity.getQty_new()%>
											</td>
											<td align="center" valign="top" width="5%">
													<%=entity.getQty_diff()%>
											</td>
											<td align="center" valign="top" width="10%">
												<%-- <%=CheckStockTS.status(entity.getStatus())%> --%>
											</td>
											<td align="center" valign="top" width="10%">
												<%=WebUtils.getDateValue(entity.getCheck_date())%>
											</td>
											<td align="center" valign="top" width="10%">
												<%=WebUtils.getDateValue(entity.getClose_date())%>
											</td>
										</tr>
									<%
										}
										if(has){
									%>
										<tr><td colspan="8" align="center">Parts Master cannot be found!</td></tr>
									<%
										}
									%>
								</table>
								</div>	
							</td>		
						</tr>			
					</tbody>
				</table>
				<!-- </div> -->
				<div class="txt_center">
					<button class="btn_box btn_confirm btn_approve">อนุมัติ</button>
					<button class="btn_box btn_confirm btn_reject">ไม่อนุมัติ</button>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>