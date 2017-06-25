<%@page import="com.bitmap.bean.logistic.LogisSend"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleQt"%>
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
<title>ค้นหา</title>

<%
String run = WebUtils.getReqString(request, "run");

List param = new ArrayList();
String page_ = WebUtils.getReqString(request, "page");

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);

session.setAttribute("PRO_SEARCH", param);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("PRO_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("PRO_SEARCH_PAGE")));
}

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("PRO_SEARCH_PAGE", page_);
}
List list = LogisSend.searchForLogis(ctrl, param);
%>
</head>
<body>

<div class="wrap_all">	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="center">ค้นหา</div>
				<div class="right m_right15">					
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">			
				<table class="bg-image s900">
					<thead>
						<tr>
							<th valign="top" align="center" width="5%">No.</th>
							<th valign="top" align="center" width="10%">ประเภท</th>
							<th valign="top" align="center" width="25%">ลูกค้า</th>
							<th valign="top" align="center" width="20%">รายการสินค้า</th>
							<th valign="top" align="center" width="10%">จำนวนทั้งหมด</th>
							<th valign="top" align="center" width="10%">จำนวนที่ส่ง</th>
							<th valign="top" align="center" width="10%">วันที่ส่ง</th>
							<th align="center" width="10%"></th>
						</tr>
					</thead>
					<tbody>
					<%
					Iterator ite = list.iterator();
					while (ite.hasNext()){
						LogisSend entity = (LogisSend) ite.next();
					%>
						<tr>
							<td align="right"><%=entity.getInv()%></td>
							<td align="center"><%=LogisSend.statusInv(entity.getType_inv())%></td>
							<td align="left"><%=entity.getUIorder().getUICustomer().getCus_name()%></td>
							<td align="center"><%=entity.getUImatname()%></td>
							<td align="center"><%=entity.getQty_all()%></td>
							<td align="center"><%=entity.getQty()%></td>
							<td align="center"><%=WebUtils.getDateValue(entity.getSend_date())%></td>
							<td align="center">
								<input type="button" class="btn_box btn_confirm btn_select" id_run = "<%=entity.getId_run()%>" run="<%=run%>" value="เลือก">					
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
	$(function(){		
		$(".btn_select").click(function(){ 
			ajax_load();
			var data = {
					'action':'add_detail',
					'id_run':$(this).attr('id_run'),
					'run':$(this).attr('run'),
					'create_by':'<%=securProfile.getPersonal().getPer_id()%>'
		   	};
			$.post('LogisManage',data,function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.close(); 
					window.opener.location.reload();
				}else{
					alert(resData.message);
				}   	
			},'json');
		});
	});
</script>
</body>
</html>