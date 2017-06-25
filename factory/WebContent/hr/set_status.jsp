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
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.datepicker.js"></script>

<script type="text/javascript">
$(function(){
	
	$( "#date_retire" ).hide();
	
	$("#retire").click(function () {		
			
		$( "#date_retire" ).show();
			$( "#date_retire" ).datepicker({
				showOtherMonths: true,
				selectOtherMonths: true,
				changeMonth: true
			});	
			
	 });
	
	$("#active").click(function () {		
		$( "#date_retire" ).hide();
	 });
	
	$("#inActive").click(function () {		
		$( "#date_retire" ).hide();
	 });
		 
		
		var form = $('#EditStatus');	
		form.submit(function(){	
			$.post('EmpManageServlet',form.serialize(),function(resData){			
				if (resData.status == 'success') {
					window.location = 'emp_manage.jsp';
				} else {
					alert(resData.message);
				}
			},'json'); 				
		});	
});	
</script>

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<title>Insert title here</title>
</head>

<body>

<form id="EditStatus"  name="EditStatus" onsubmit="return false;">
		<div class="m_top20" style="width: auto; background-color: #847C5B; padding: 5px 5px 10px 5px; -webkit-border-radius: 4px; -moz-border-radius: 4px; border-radius: 4px;">
			<div><label>  <input name="status" id="active" type="radio" value="true" /> Active</label></div>
			<div><label>  <input name="status" id="inActive"type="radio" value="false" /> InActive</label></div>
			<div><label>  <input name="status" id="retire"type="radio" value="false" /> Retire</label></div>
			<input type="text" name="date_retire" id="date_retire" class="txt_box s150" value="">
						
			
			
			<input type="hidden" name="action" value="addAct">
			<input type="hidden" name="user_id" value="<%=WebUtils.getReqString(request,"user_id")%>">	
		</div>
		<br>
		<input type="submit" id="btnAct" value="บันทึก" class="btn_box">	
</form>

</body>
</html>