<%@page import="com.bitmap.bean.sale.Province"%>
<%@page import="com.bitmap.bean.logistic.Busstation"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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
<script src="../js/jquery.validate.js" type="text/javascript"></script>
<script src="../js/jquery.metadata.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>จัดการคิวรถ</title>
<%
String qid = WebUtils.getReqString(request, "qid");

List paramList = new ArrayList();
paramList.add(new String[]{"qid",qid});

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(30);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}
session.setAttribute("BUS_SEARCH", paramList);

Iterator cusIte = Busstation.selectWithCTRL(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">จัดการคิวรถ | แสดงข้อมูลรถ [1. เลือกรถ ]</div>
				<div class="right m_right10">
					<button class="btn_box btn_confirm thickbox" lang="../info/bus_new.jsp?height=200&width=400" title="เพิ่มข้อมูลรถ">เพิ่มข้อมูลรถ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="detail_wrap s800 center txt_center">
					<form style="margin: 0; padding: 0;" action="logis_bus.jsp" method="get">
						ค้นหาจากชื่อบริษัท: <input type="text" name="company" id="company" value="" class="txt_box s200" autocomplete="off"> 
						<button type="submit" name="btn_search" class="btn_box btn_confirm">ค้นหา</button>
						</form>
				</div>
				
				<div class="dot_line m_top5"></div>
				
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"logis_bus.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<table class="bg-image s900 m_top5">
					<thead>
						<tr>
							<th valign="top" align="center" width="25%">ชื่อบริษัท</th>
							<th valign="top" align="center" width="15%">ชื่อคนขับ</th>
							<th valign="top" align="center" width="15%">หมายเลขทะเบียน</th>
							<th align="center" align="center" width="15%" ></th>
						</tr>
					</thead>
					<%
					while(cusIte.hasNext()){ 
						Busstation bus = (Busstation) cusIte.next();
					%>
					<tbody>
						<tr>
							<td align="left"><div class="thickbox pointer" title="ข้อมูลรถ" lang="../info/bus_info.jsp?qid=<%=bus.getQid()%>&height=200&width=400"><%=bus.getCompany()%></div></td>
							<td><%=bus.getDriver()%></td>
							<td align="center"><%=bus.getPlate()%></td>
							<td align="center">
								<button class="btn_box btn_confirm" onclick="window.location='logis_send_product.jsp?qid=<%=bus.getQid()%>';">เลือก</button>
								<button class="btn_box thickbox" lang="../info/bus_edit.jsp?qid=<%=bus.getQid()%>&height=200&width=400" title="แก้ไขข้อมูลรถ">แก้ไข</button>
							</td>
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