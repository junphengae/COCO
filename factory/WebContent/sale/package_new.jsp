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

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการส่งเสริมการขาย</title>

<script type="text/javascript">
$(function(){
	$('#sale_package').submit(function(){
		var name = $('#name');
		var type = $('input:radio[name=pk_type]');
		
		if(name.val()==""){
			alert("กรุณาระบุชื่อรายการส่งเสริมการขาย");
			name.focus();
		}
		else {
			if(type.is(':checked')){
					ajax_load();
					$.post('PackageManage',$(this).serialize(),function(resData){
						ajax_remove();
						if (resData.status == 'success') {
							window.location='package_create_item.jsp?pk_id='+ resData.pk_id;
						} else {
							alert(resData.message);
						}
					},'json');	
				
			}
			else {
				alert("กรุณาเลือกประเภทรายการส่งเสริมการขาย");
			}
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
				<div class="left">สร้างรายการส่งเสริมการขาย | 1. กำหนดชื่อรายการ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="detail_wrap s900 center">
					<form style="margin: 0; padding: 0;" id="sale_package" onsubmit="return false">
						<table cellpadding="2" cellspacing="2">
							<tr>
								<td>ชื่อรายการ :</td>
								<td>
									<input type="text" class="s500 txt_box" name="name" id="name" value="">
								</td>
							</tr>
							<tr valign="top">
								<td>ประเภท :</td>
								<td> 
									<input type="radio" name="pk_type" value="s" id="type_s"> <label for="type_s">เซต / Set</label> 
									<br>
									<input type="radio" name="pk_type" value="p" id="type_p"> <label for="type_p">โปรโมชั่น / Promotion</label>
								</td>
							</tr>
						</table>
					
						<div class="center s300 txt_center m_top5">
							
							<input type="submit" name="submit" value="ถัดไป" class="btn_box btn_confirm">
							<input type="button" name="cancel" value="ยกเลิก" class="btn_box" onclick="window.location='package.jsp'">
							<input type="hidden" name="action" value="package_new">
							<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
						</div>
					</form>
				</div>
				
				
						
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>