<%@page import="com.bitmap.bean.hr.Position"%>
<%@page import="com.bitmap.bean.hr.Department"%>
<%@page import="java.util.Iterator"%>
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
<title>โครงสร้างองค์กร</title>
<script type="text/javascript">
	function getDiv(dep_id,dep_name){
		
		var tb_div = $('table#table_division');
		var btn_adddiv =$('#btn_adddiv');
		
		ajax_load();
		$.post('OrgManagement?action=getDiv&dep_id=' + dep_id,function(resData){
			ajax_remove();
			
			$('#head_div').html(dep_name).attr('lang',dep_id);
			
			btn_adddiv.attr('lang','division_new.jsp?height=250&width=480&modal=true&dep_id=' + dep_id +'&dep_name='+ dep_name ).fadeIn(500);
			
			if (resData.status == "success") {
				var div = resData.div;
				
				if (div.length > 0) {
					var tbody = '';
					for (var i = 0; i < div.length; i++) {
						tbody += '<tr><td>' 
							  + div[i].div_name_th + '</td><td>' + div[i].div_name_en + '</td>' 
							  + '<td align="center"><button class="btn_box" onclick="thickbox_init(this);" lang="division_edit.jsp?height=250&width=480&modal=true&div_id=' + div[i].div_id + '&dep_id=' + dep_id + '&dep_name=' + dep_name + '">แก้ไข</button> '
							  + '</td></tr>';
							 
								
						tb_div.children('tbody').html(tbody);
						tb_div.fadeIn(500);
					}
				} else {
					tb_div.children('tbody').html('<td colspan="3" align="center">-- ไม่มีข้อมูล --</td>');
					tb_div.fadeIn(500);
				}
			} else {
				alert(resData.message);
			}
		},'json');
	}
	
	function refreshDiv(dep_id){
		
		var tb_div = $('table#table_division');
		var btn_adddiv =$('#btn_adddiv');
		
		ajax_load();
		$.post('OrgManagement?action=getDiv&dep_id=' + dep_id,function(resData){
			ajax_remove();
			
			btn_adddiv.attr('lang','division_new.jsp?height=250&width=480&modal=true&dep_id=' + dep_id).fadeIn(500);
			
			if (resData.status == "success") {
				var div = resData.div;
				
				if (div.length > 0) {
					var tbody = '';
					for (var i = 0; i < div.length; i++) {
						tbody += '<tr><td>' 
							  + div[i].div_name_th + '</td><td>' + div[i].div_name_en + '</td>' 
							  + '<td align="center"><button class="btn_box" onclick="thickbox_init(this);" lang="division_edit.jsp?height=250&width=480&modal=true&div_id=' + div[i].div_id + '&dep_id=' + dep_id + '">แก้ไข</button> '
							  + '</td></tr>';
							 
								
						tb_div.children('tbody').html(tbody);
						tb_div.fadeIn(500);
					}
				} else {
					tb_div.children('tbody').html('<td colspan="3" align="center">-- ไม่มีข้อมูล --</td>');
					tb_div.fadeIn(500);
				}
			} else {
				alert(resData.message);
			}
		},'json');
	}
	

	function delete_div(btn){
		var div_id = $(btn).attr('lang');
		var dep_id = $('#head_div').attr('lang');
		var dep_name = $('#head_div').text();
		
		if (confirm('คุณต้องการลบตำแหน่งนี้หรือไม่ !')) {
			 tb_load();
		
		     $.post('OrgManagement?action=delete_div&div_id='+ div_id,function(resData){	
				tb_remove();
  				if (resData.status == 'success') {
  		   	   getPos(dep_id , dep_name);
				} else {
					alert(resData.message);
				}
			},'json');
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
				<div class="left">โครงสร้างองค์กร</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
			
				<div class="left txt_bold txt_16">รายชื่อฝ่าย</div>
				<div class="right"><button class="btn_box thickbox" lang="department_new.jsp?height=250&width=480&modal=true" title="Add Department">เพิ่มรายชื่อฝ่าย</button></div>
				<div class="clear"></div>
				
				<table class="bg-image s900">
					<thead>
						<tr>
							<th width="40%">ชื่อฝ่าย(ไทย)</th>
							<th width="40%">ชื่อฝ่าย(อังกฤษ)</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<%
							Iterator ite = Department.listDepartmant().iterator();
							while (ite.hasNext()) {
								Department entity = (Department)ite.next();
						%>
						<tr>
							<td class="pointer" onclick="getDiv('<%=entity.getDep_id() %>','<%=entity.getDep_name_th() %>');"><%=entity.getDep_name_th() %></td>
							<td class="pointer" onclick="getDiv('<%=entity.getDep_id() %>','<%=entity.getDep_name_th() %>');"><%=entity.getDep_name_en() %></td>
							<td align="center"><button class="btn_box thickbox" lang="department_edit.jsp?height=250&width=480&modal=true&dep_id=<%=entity.getDep_id()%>">แก้ไข</button></td>
							
						</tr>
						<%
							}
						%>
					</tbody>
				</table>
			</div>
			
			<div class="m_top20"></div>
			
			<div class="content_body">
			
				<div class="left txt_bold txt_16">รายชื่อแผนก: ภายใต้ฝ่าย <span id="head_div" lang="">---</span></div>
				<div class="right"><button id="btn_adddiv" class="btn_box thickbox hide" lang="division_new.jsp?height=250&width=480&modal=true" title="Add Division">เพิ่มรายชื่อแผนก</button></div>
				<div class="clear"></div>
				
				<table class="bg-image s900 hide" id="table_division">
					<thead>
						<tr>
							<th width="40%">ชื่อแผนก(ไทย)</th>
							<th width="40%">ชื่อแผนก(อังกฤษ)</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>
			</div>
			
			<div class="m_top20"></div>
			<div class="dot_line"></div>
			<div class="m_top20"></div>
			
			<div class="content_body">
			
				<div class="left txt_bold txt_16">จัดการรายชื่อตำแหน่ง: </div>
				<div class="right"><button class="btn_box thickbox" lang="position_new.jsp?height=250&width=480&modal=true" title="Add Position">เพิ่มรายชื่อตำแหน่ง</button></div>
				<div class="clear"></div>
				
				<table class="bg-image s900" id="table_position">
					<thead>
						<tr>
							<th width="40%">ชื่อตำแหน่ง(ไทย)</th>
							<th width="40%">ชื่อตำแหน่ง(อังกฤษ)</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<%
							Iterator itePos = Position.getUIObjectPosition().iterator();
							while (itePos.hasNext()) {
								Position entity = (Position)itePos.next();
						%>
						<tr>
							<td><%=entity.getPos_name_th() %></td>
							<td><%=entity.getPos_name_en() %></td>
							<td align="center"><button class="btn_box thickbox" lang="position_edit.jsp?height=250&width=480&modal=true&pos_id=<%=entity.getPos_id()%>">แก้ไข</button></td>
						</tr>
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
</body>
</html>