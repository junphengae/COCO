<%@page import="com.bitmap.utils.Money"%>
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

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<jsp:useBean id="MAT_SEARCH" class="com.bitmap.bean.inventory.MaterialSearch" scope="session"></jsp:useBean>

<%
List param = new ArrayList();
String name = WebUtils.getReqString(request, "name");
String pk_type = WebUtils.getReqString(request, "pk_type");
String status = WebUtils.getReqString(request, "status");
String page_ = WebUtils.getReqString(request, "page");

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);

param.add(new String[]{"name",name});
param.add(new String[]{"status",status});
param.add(new String[]{"pk_type",pk_type});

session.setAttribute("PK_SEARCH", param);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("PK_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("PK_SEARCH_PAGE")));
}

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("PK_SEARCH_PAGE", page_);
}

List list = Package.selectWithCTRL(ctrl, param);

%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการส่งเสริมการขาย</title>


</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการส่งเสริมการขาย</div>
				<div class="right m_right15">
					<button class="btn_box btn_confirm" onclick="window.location='package_new.jsp';">สร้างรายการส่งเสริมการขาย</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="detail_wrap s900 center">
					<form style="margin: 0; padding: 0;" action="package.jsp" id="search" method="get">
						<table class="center">
							<tr>
								
								<td id="show_keyword" align="right" width="100">ค้นหารายการ</td>
								<td>: 
									<input type="text" class="s120 txt_box" name="name" value="<%=name%>" autocomplete="off">
								</td>
								
								<td align="right" width="80">ประเภท</td>
								<td>: 
									<bmp:ComboBox name="pk_type" styleClass="txt_box s200" value="<%=pk_type%>">
										<bmp:option value="" text="แสดงทั้งหมด"></bmp:option>
										<bmp:option value="s" text="เซต / Set"></bmp:option>
										<bmp:option value="p" text="โปรโมชั่น / Promotion"></bmp:option>
									</bmp:ComboBox>	
								</td>
								<td align="right" width="80">สถานะ</td>
								<td>: 
									<bmp:ComboBox name="status" styleClass="txt_box s200" value="<%=status%>" listData="<%=Package.statusDropdown()%>">
										<bmp:option value="" text="แสดงทั้งหมด"></bmp:option>
									</bmp:ComboBox>	
								</td>
							</tr>
						</table>
					
						<div class="center s300 txt_center m_top5">
							<input type="submit" name="submit" value="ค้นหา" class="btn_box s50">
							<input type="button" name="reset" value="ล้าง" class="btn_box s50 m_left5" onclick="resetSearch();">
							<input type="hidden" name="action" value="search">
						</div>
					</form>
				</div>
				<!-- next page -->  
				<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"package.jsp",param)%></div>
				<div class="clear"></div>
				<!-- next page  -->
				<table class="bg-image s900">
					<thead>
						<tr>
							<th valign="top" align="center" width="50%">ชื่อ</th>
							<th valign="top" align="center" width="20%">ประเภท</th>
							<th valign="top" align="center" width="10%">จำนวน</th>
							<th valign="top" align="center" width="10%">ราคา</th>
							<th valign="top" align="center" width="10%">สถานะ</th>
							<th width="5%"></th>
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
							<td valign="top" align="center"><%=(pk.getPk_type().equalsIgnoreCase("p"))?"โปรโมชั่น / Promotion":"เซต / Set"%></td>
							<td valign="top" align="right"><%=(pk.getPk_type().equalsIgnoreCase("p"))?pk.getPk_qty():"1"%> ชุด</td>
							<td valign="top" align="right"><%=Money.money(pk.getPrice())%></td>
							<td valign="top" align="center"><%=Package.status(pk.getStatus())%></td>
							<td valign="top" align="center">
							<%
							if(pk.getStatus().equalsIgnoreCase(Package.STATUS_ACTIVE) || pk.getStatus().equalsIgnoreCase(Package.STATUS_INACTIVE) ){
								%>
								<button class="btn_box" onclick="window.location='package_view.jsp?pk_id=<%=pk.getPk_id()%>'">ดู</button>
								<%	
							}else{
							%>
								<button class="btn_box" onclick="window.location='package_create_item.jsp?pk_id=<%=pk.getPk_id()%>'">ดู</button>
							<%
							}
							%>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
						
			</div>
			<div class="wrap_desc">
				- หน้าจอนี้ใช้แสดงรายการ Promotion
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
<script type="text/javascript">
	
</script>

</body>
</html>