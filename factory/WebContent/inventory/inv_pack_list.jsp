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
<title>ข้อมูลลูกค้า</title>
<%
String cus_name = WebUtils.getReqString(request, "cus_name");

List paramList = new ArrayList();
paramList.add(new String[]{"cus_name",cus_name});

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(30);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}
session.setAttribute("CUS_SEARCH", paramList);

Iterator cusIte = Customer.selectWithCTRL(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">คลังสินค้า |ตารางรายการหน่วยนับ</div>
				<div class="right m_right10">
					<button class="btn_box btn_confirm thickbox" lang="../info/customer_new.jsp?height=450&width=520" title="เพิ่มรายการ">เพิ่มรายการ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="detail_wrap s800 center txt_center">
					<form style="margin: 0; padding: 0;" action="inv_pack_list.jsp" method="get">
						ค้นหาจากรหัสสินค้า: <input type="text" name="mat_code" id="mat_code" value="<%=cus_name%>" class="txt_box s200" autocomplete="off"> 
						<button type="submit" name="btn_search" class="btn_box btn_confirm">ค้นหา</button>
						<button type="button" name="btn_reset" id="btn_reset" class="btn_box" onclick="$('#mat_code').val('');">ล้าง</button>
					</form>
				</div>
				
				<div class="dot_line m_top5"></div>
				
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"customer_list.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<table class="bg-image s900 m_top5">
					<thead>
						<tr>
							<th width="15%" align="left">รหัสสินค้า</th>
							<th width="30%" align="center">Description</th>
							<th width="15%" align="center">หน่วยนับ</th>
							<th width="15%" align="center">Factor</th>		
							<th width="15%" align="center">หน่วยนับหลัก</th>		
							<th width="15%" align="center">&nbsp;</th>
						</tr>
					</thead>
					<%
					while(cusIte.hasNext()){ 
						Customer cus = (Customer) cusIte.next();
					%>
					<tbody>
						<tr>
							<td align="left"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=cus.getCus_id()%>&height=400&width=520"><%=cus.getCus_name()%></div></td>
							<td><%=cus.getCus_contact()%></td>
							<td align="center"><%=cus.getCus_phone()%></td>
							<td align="center"><%=Customer.ship(cus.getCus_ship())%></td>
							<td align="center"><%=Customer.ship(cus.getCus_ship())%></td>
							<td align="center">
								<button class="btn_box thickbox" lang="../info/customer_edit.jsp?cus_id=<%=cus.getCus_id()%>&height=450&width=520" title="แก้ไขข้อมูลลูกค้า">แก้ไข</button>
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