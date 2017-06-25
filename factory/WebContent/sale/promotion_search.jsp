<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.util.StatusUtil"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/popup.js" type="text/javascript"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ค้นหาโปรโมชั่น(Search Promotion)</title>

<%
List param = new ArrayList();
String name = WebUtils.getReqString(request, "name");
String status = Package.STATUS_DIRECTOR_APPROVE;
String page_ = WebUtils.getReqString(request, "page");

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);

param.add(new String[]{"name",name});
param.add(new String[]{"status",status});

session.setAttribute("PRO_SEARCH", param);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("PRO_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("PRO_SEARCH_PAGE")));
}

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("PRO_SEARCH_PAGE", page_);
}

List list = Package.selectWithCTRL(ctrl, param);
%>
</head>
<body>

<div class="wrap_all">	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">ค้นหาสินค้าจำหน่าย</div>
				<div class="right m_right15">					
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="detail_wrap s900 center">
					<form style="margin: 0; padding: 0;" action="promotion_search.jsp" id="search" method="get">
						<table>
							<tr>								
								<td id="show_keyword" align="right" width="200">ชื่อโปรโมชั่น</td>
								<td>: 
									<input type="text" class="s150 txt_box" name="name" value="<%=name%>" autocomplete="off">
								</td>
							</tr>
						</table>
					
						<div class="center s300 txt_center m_top5">
							<input type="submit" name="submit" value="ค้นหา" class="btn_box">
							<input type="button" name="reset" value="ล้าง" class="btn_box m_left5" onclick="resetSearch();">
							<input type="button" value="ปิดหน้าจอ" class="btn_box m_left5" onclick="window.close();">
							<input type="hidden" name="action" value="search">
						</div>
					</form>
				</div>
				
				<!-- next page  -->
				<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"promotion_search.jsp",param)%></div>
				<div class="clear"></div>
				<!-- next page  -->
				
				
				<table class="bg-image s900">
					<thead>
						<tr>
							<th valign="top" align="center" width="50%">ชื่อโปรโมชั่น</th>
							<th valign="top" align="center" width="15%">ราคา</th>
							<th valign="top" align="center" width="15%">สถานะ</th>
							<th width="15%"></th>
						</tr>
					</thead>
					<tbody>
					<%
					Iterator ite = list.iterator();
					while (ite.hasNext()){
						Package pk = (Package) ite.next();
					%>
						<tr>
						<td valign="top" align="left"><%=pk.getName()%></td>
						<td valign="top" align="right"><%=Money.money(pk.getPrice())%></td>
						<td valign="top" align="center"><%=Package.status(pk.getStatus())%></td>
						<td valign="top" align="center">
							<button class="btn_box btn_confirm btn_select" data_name="<%=pk.getName()%>" data_price="<%=pk.getPrice()%>" data_qty="<%=pk.getPk_qty()%>" data_pk="<%=pk.getPk_id()%>" data_type="<%=pk.getPk_type()%>">เลือก</button>
							<button class="btn_box" onclick="window.location='sale_promotion_view.jsp?pk_id=<%=pk.getPk_id()%>'">ดู</button>
						</td>
						</tr>
					<%
					}
					%>
					</tbody>
				</table>
						
			</div>
		</div>
	</div>
	
</div>
<script type="text/javascript">
	// On load
	$(function(){		
		$(".btn_select").click(function(){ 
	        window.opener.$("#name").text($(this).attr('data_name'));
	        window.opener.$('#pk_qty').val($(this).attr('data_qty'));
	        window.opener.$('#price').text($(this).attr('data_price'));
	        window.opener.$('#item_id').val($(this).attr('data_pk'));
	        
	        if ($(this).attr('data_type') == 's') {
	        	window.opener.$('#pk_qty').removeClass('txt_show').addClass('txt_box').removeAttr('readonly');
			} else {
				window.opener.$('#pk_qty').removeClass('txt_box').addClass('txt_show').attr('readonly','readonly');
			}
	        
	       	window.close(); 
	}); 
	});

	function resetSearch(){
		$('input[name=name]').val('');
	}
</script>
</body>
</html>