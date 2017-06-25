<%@page import="com.bitmap.utils.Kson"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.bitmap.dbconnection.mysql.vbi.DBPool"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/TestAreaControl.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SQL Command</title>

<script type="text/javascript">
	$(function(){
		$('#sql_cmd').focus();
		
		var formular_form = $('#formular_form');	
		$.metadata.setType("attr", "validate");
		var v = formular_form.validate({
			submitHandler: function(){
				if (confirm('')) {
					
				}
				ajax_load();
				$.post('GetCat',formular_form.serialize(),function(resData){			
					ajax_remove();
					if (resData.status == 'success') {
						alert(resData.message);
					} else {
						alert(resData.message);	
					}
				},'json');
			}
		});	
		
		formular_form.submit(function(){			
			v;					
			return false;
		});
		
		$('#updateInventory').click(function(){
			if (confirm('Do you want to update Inventory Balance?')) {
				ajax_load();
				$.post('../inventory/MaterialManagement',{'action':'developUpdateBalance'},function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						alert('Success');
					} else {
						alert(resData.message);
					}
				},'json');
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
				<div class="left">SQL Commands</div>
				<div class="right m_right15">
					<button class="btn_box" onclick="window.location='../home.jsp';">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<form id="formular_form" onsubmit="return false">
					<table width="100%" id="tb_formular">
						<tbody>		
							<tr valign="top">
								<td width="15%">SQL : </td>
								<td width="85%">
									<textarea rows="4" cols="10" name="sql_cmd" id="sql_cmd" class="txt_box s500 h150 required" title="Please insert SQL Command." style="padding: 2px;"></textarea>
								</td>
							</tr>
						</tbody>		
					</table>
					
					<center class="m_top10">
						<button type="submit" class="btn_box btn_confirm">Execute</button>
						<button type="button" class="btn_box btn_warn" onclick="window.location='sql_manage.jsp';">Clear</button>
						<input type="hidden" name="action" value="run_command">
					</center>
					</form>
					
					<div class="dot_line m_top10"></div>
					<div class="center txt_center m_top10">
						<button class="btn_box btn_warn" id="updateInventory">Update Inventory Master Balance</button>
					</div>
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>