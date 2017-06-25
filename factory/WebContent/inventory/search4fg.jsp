<%@page import="com.bitmap.bean.rd.RDFormularDetail"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
<%@page import="com.bitmap.utils.Money"%>
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

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">


<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<jsp:useBean id="MAT_SEARCH" class="com.bitmap.bean.inventory.MaterialSearch" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Search Material</title>

<%
	String material = WebUtils.getReqString(request, "material");
	String page_ = WebUtils.getReqString(request, "page");
	
	List param = new ArrayList();
	param.add(new String[]{"material",material});

	PageControl ctrl = new PageControl();
	ctrl.setLine_per_page(15);
	
	session.setAttribute("FG_SEARCH", param);
	if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("FG_SEARCH_PAGE") != null){
		ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("FG_SEARCH_PAGE")));
	}

	if(page_.length() > 0){
		ctrl.setPage_num(Integer.parseInt(page_));
		session.setAttribute("FG_SEARCH_PAGE", page_);
	}
	List list = RDFormularDetail.SearchMtWithCTRL(ctrl,param);
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				ค้นหาสินค้าคงคลัง
			</div>
			
			<div class="content_body">
				<div class="detail_wrap s900 center">
					<form style="margin: 0; padding: 0;" action="search4fg.jsp" id="search" method="get">
						<div class="center">
							<div class="left s100">รหัส Material</div>
							<div class="left"><input type="text" class="s120 txt_box" name="material" value="<%=material%>">
							</div>
						</div>
						<div class="clear"></div>
						
						<div class="center s300 txt_center m_top5">
							<input type="submit" name="submit" value="ค้นหา" class="btn_box btn_confirm s50">
							<input type="button" name="reset" value="ล้าง" class="btn_box btn_warn s50 m_left5" onclick="resetSearch();">
							<input type="hidden" name="action" value="search">
						</div>
					</form>
				</div>
				
				<!-- next page  -->
				<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"search4fg.jsp",param)%></div>
				<div class="clear"></div>
				<!-- next page  -->
				
				<table class="bg-image s900">
					<thead>
						<tr>
							<th valign="top" align="center" width="10%">รหัสสินค้า</th>
							<th valign="top" align="center" width="10%">ประเภท</th>
							<th valign="top" align="center" width="30%">ชื่อสินค้า</th>
							<th valign="top" align="center" width="10%">รหัสเดิม</th>
							<th valign="top" align="center" width="8%">สถานที่</th>
							<th valign="top" align="center" width="13%">คงคลัง</th>
							<th width="10%"></th>
						</tr>
					</thead>
					<tbody>
					<%
					boolean has = true;
					Iterator ite = list.iterator();
					while(ite.hasNext()) {
						RDFormularDetail rd_detial = (RDFormularDetail) ite.next();
						InventoryMaster entity = rd_detial.getUIMat();
						has = false;
					%>
						<tr>
							<td><%=entity.getMat_code()%></td>
							<td><%=entity.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + entity.getUISubCat().getUICat().getCat_name_short() + ((entity.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + entity.getUISubCat().getSub_cat_name_short():"")%></td>
							<td><%=entity.getDescription()%></td>
							<td><%=entity.getRef_code()%></td>
							<td align="center"><%=entity.getLocation()%></td>
							<td align="right"><%=Money.money(entity.getBalance())%></td>
							<td align="center">
								<img class="pointer" alt="รายละเอียด Material" src="../images/search_16.png" onclick="javascript: window.location='material_view.jsp?mat_code=<%=entity.getMat_code()%>'"></img>&nbsp;
							</td>
						</tr>
					<%
					}
					if(has){
					%>
						<tr><td colspan="7" align="center">-- ไม่พบข้อมูล --</td></tr>
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
</script>
</body>
</html>