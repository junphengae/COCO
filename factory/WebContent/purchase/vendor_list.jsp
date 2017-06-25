<%@page import="com.bmp.vendor.VendorBean"%>
<%@page import="com.bmp.vendor.VendorTS"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.purchase.PurchaseRequest"%>
<%@page import="com.bitmap.bean.purchase.PurchaseOrder"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="java.util.Iterator"%>
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

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ทะเบียนผู้ขาย [Vendor List]</title>
<%
String vendor_code = WebUtils.getReqString(request, "vendor_code");
String vendor_name = WebUtils.getReqString(request, "vendor_name");

String page_ = WebUtils.getReqString(request, "page");
List paramList = new ArrayList();
paramList.add(new String[]{"vendor_code",vendor_code});
paramList.add(new String[]{"vendor_name",vendor_name});

session.setAttribute("VENDOR_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(25);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = VendorTS.selectWithCTRL(ctrl, paramList).iterator();

%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">ทะเบียนผู้ขาย</div>
				<div class="right m_right10">					
					<button class="btn_box btn_create" onclick="window.location='vendor_new.jsp';">เพิ่มตัวแทนจำหน่าย</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 center txt_center">
						<form style="margin: 0; padding: 0;" action="vendor_list.jsp" id="search" method="get">
							รหัสตัวแทนจำหน่าย: 
							<input type="text" class="txt_box" id="vendor_code" name="vendor_code">
							&nbsp;&nbsp;					
							ชื่อตัวแทนจำหน่าย:
							<input type="text" class="txt_box" id="vendor_name" name="vendor_name">
							
							<button class="btn_box btn_confirm" type="submit">ค้นหา</button>
						</form>
					</div>
					
					<div class="dot_line m_top5"></div>
					
					<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"vendor_list.jsp",paramList)%></div>
					<div class="clear"></div>
					
					<table class="bg-image s900">
						<thead>
							<tr>
								<th valign="top" align="center" width="20%">รหัส</th>
								<th valign="top" align="center" width="35%">ชื่อตัวแทน</th>														
								<th valign="top" align="center" width="25%">ชื่อผู้ติดต่อ</th>					
								<!-- <th valign="top" align="center" width="10%">เครดิต</th>
								<th valign="top" align="center" width="15%">ประเภทการขนส่ง</th> -->
								<th align="center" width="15%"></th>
							</tr>
						</thead>
						<tbody>
						<%
							boolean has = true;
							while(ite.hasNext()) {
								VendorBean entity = (VendorBean) ite.next();								
								has = false;
								String ship_name="";
								if(entity.getVendor_ship().equalsIgnoreCase("land")){
									ship_name="ทางบก";
								}else 
									if(entity.getVendor_ship().equalsIgnoreCase("sea")){
									ship_name="ทางเรือ";
								}else  
									if(entity.getVendor_ship().equalsIgnoreCase("air")){
									ship_name="ทางอากาศ";
								}
						%>
							<tr>
								<td align="left"><%=entity.getVendor_code()%></td>
								<td align="left"><%=entity.getVendor_name()%></td>
								<td align="left"><%=entity.getVendor_contact()%></td>
								<%-- <td align="center"><%=entity.getVendor_credit()%></td>
																	
								<td align="center">
								<%=ship_name%>
								</td> --%>
								<td align="center">
									<input type="button" class="btn_box" value="ดู"   title="ดูรายละเอียด" onclick="javascript:popup('vendor_info.jsp?vendor_id=<%=entity.getVendor_id()%>','',500,400)">
									<input type="button" class="btn_box" value="แก้ไข" title="แก้ไขข้อมูล" onclick="javascript: window.location='vendor_edit.jsp?vendor_id=<%=entity.getVendor_id()%>';">
									<input type="button" class="btn_box" value="ลบ" title="ลบข้อมูล" onclick="delete_vendor(this);" vendor_id="<%=entity.getVendor_id()%>">
								</td>
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="6" align="center">---- ไม่พบรายการ ---- </td></tr>
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
function popup(url,name,windowWidth,windowHeight){      
    myleft=(screen.width)?(screen.width-windowWidth)/2:100;   
    mytop=(screen.height)?(screen.height-windowHeight)/2:100;     
    properties = "width="+windowWidth+",height="+windowHeight;  
    properties +=",scrollbars=yes, top="+mytop+",left="+myleft;     
    window.open(url,name,properties);  
} 

function delete_vendor(obj){
	var vendor_id = $(obj).attr('vendor_id');
	//alert(vendor_id);
	if (confirm('ยืนยันการลบตัวแทนจำหน่าย?')) {
		ajax_load();
		$.post('./VendorServlet',{'vendor_id': vendor_id,'action': 'vendor_delete'},function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				window.location.reload();
			} else {
				alert(resData.message);
			}
		},'json');
	}
}
</script>
</body>
</html>