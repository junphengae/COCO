<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Outlet</title>
<%
	String mat_code = WebUtils.getReqString(request, "mat_code");
	session.removeAttribute("invMaster");
%>
<script type="text/javascript">
$(function(){
	//check_material();
	
	$('#mat_code').keypress(function(e){
		if (e.keyCode == 13) {
			$('#pro_id').focus();
		}
	});
	
	$('#pro_id').keypress(function(e){
		if (e.keyCode == 13) {
			check_material();
		}
	});
});

function check_material(){
	var mat_code = $('#mat_code');
	//alert(mat_code);
	if (mat_code.val() != '') {
		ajax_load();
		$.post('OutletManagement',{'action': 'check_code','mat_code':mat_code.val(),'pro_id':$('#pro_id').val()},function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				if(resData.type == 'FG' && resData.check == true){
					window.location='outlet_control_fg.jsp';
				}else if(resData.type == 'SS' && resData.check == true){
					//window.location='outlet_control_ss.jsp';
				}else{
					alert("เลขอ้างอิงในการเบิกไม่อยู่ในรายการโปรดักชั่น!");
					window.location='outlet_control.jsp?request_id=' + $('#pro_id').val();
				}
				
			} else {
				alert(resData.message);
				mat_code.focus();
			}
		},'json');
	} else {
		mat_code.focus();
	}
}
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">
					1: เบิกสินค้า
				</div>
				<div class="right m_right20"></div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">		
				<table width="100%" id="tb_check_mat">
					<tbody>
						<tr>
							<td width="25%">รหัสสินค้า</td>
							<td width="75%">: 
								<input type="text" autocomplete="off" name="mat_code" id="mat_code" class="txt_box s150" value="<%=mat_code%>">
								
							</td>
						</tr>
						<tr>
							<td>เลขอ้างอิงการเบิก</td>
							<td>: <input type="text" autocomplete="off" name="pro_id" id="pro_id" class="txt_box s150">
							<button class="btn_box" onclick="check_material();">ตรวจสอบ</button>
							</td>							
						</tr>
					</tbody>
				</table>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>