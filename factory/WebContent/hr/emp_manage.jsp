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

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายชื่อพนักงาน</title>
<%
List paramList = new ArrayList();

String search = WebUtils.getReqString(request, "search");

paramList.add(new String[]{"search",search});

session.setAttribute("EMP_SEARCH", paramList);
/*
String dep_id = WebUtils.getReqString(request, "dep_id");
String div_id = WebUtils.getReqString(request, "div_id");
String pos_id = WebUtils.getReqString(request, "pos_id");

paramList.add(new String[]{"dep_id",dep_id});
paramList.add(new String[]{"div_id",div_id});
paramList.add(new String[]{"pos_id",pos_id});*/

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("EMP_PAGE", page_);
}

if (WebUtils.getReqString(request, "btn_search").length() == 0 && session.getAttribute("EMP_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("EMP_PAGE")));
}

Iterator perIte = Personal.selectWithCTRL(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายชื่อพนักงาน</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="txt_center">
					<form style="margin: 0; padding: 0;" action="emp_manage.jsp" id="searchForm" method="get">
						ค้นหา: <input type="text" name="search" id="search" value="<%=search%>" class="txt_box s200" autocomplete="off"> 
						<button type="submit" name="btn_search" value="true" class="btn_box btn_confirm">ค้นหา</button>
						<button type="button" name="btn_reset" id="btn_reset" class="btn_box" onclick="$('#search').val('');">ล้าง</button>
					</form>
				</div>
				
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"emp_manage.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<table class="bg-image s_auto m_top5">
					<thead>
						<tr>
							<th width="10%" align="center">รหัสพนักงาน</th>
							<th width="10%" align="center">ชื่อ</th>
							<th width="15%" align="center">นามสกุล</th>
							<th width="15%" align="center">ฝ่าย</th>
							<th width="15%" align="center">แผนก</th>
							<th width="10%" align="center">ตำแหน่ง</th>
							<th width="10%" align="center">สถานะ</th>
							<th width="5%" align="center">&nbsp;</th>
						</tr>
					</thead>
					<%
					while(perIte.hasNext()){ 
						Personal per = (Personal) perIte.next();
					%>
					<tbody>
						<tr>
							<td align="center"><%=per.getPer_id()%></td>
							<td><%=per.getName()%></td>
							<td><%=per.getSurname()%></td>
							<td><%=per.getUIDepartment().getDep_name_th()%></td>
							<td><%=per.getUIDivision().getDiv_name_th()%></td>
							<td><%=per.getUIPosition().getPos_name_th()%></td>
							<td align="center">
							<% if(per.getUISecurity().getActive()!=""){ %>
							<%=per.getUISecurity().getActive()%>
								<button class="pointer btn_edit thickbox" lang="set_status.jsp?user_id=<%=per.getPer_id()%>&height=250&width=500" title="เปลี่ยนสถานะ"></button>
							<%}else{%>
								-
							<% } %>
							</td>
							<td align="center"><div class="btn_box" id="getEmp" onclick="window.location='emp_info.jsp?per_id=<%=per.getPer_id()%>'">View</div></td>
						</tr>
					</tbody>
					
					<%} %>
				</table>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>
</body>
</html>