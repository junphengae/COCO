<%@page import="com.bitmap.utils.Money"%>
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
<title>Search Material</title>

<%
	session.removeAttribute("MAT");
	PageControl ctrl = (PageControl) session.getAttribute("PAGE_CTRL");
	List list = new ArrayList();
	if(session.getAttribute("MAT_LIST") != null){
		list = (List) session.getAttribute("MAT_LIST");
	}
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				ค้นหาสินค้าคงคลัง
			</div>
			
			<div class="content_body">
				<div class="detail_wrap s900 center">
					<form style="margin: 0; padding: 0;" action="SearchInventory" id="search" method="post">
						<table>
							<tr>
								<td>ค้นหาจาก</td>
								<td>: 
									<bmp:ComboBox name="where" styleClass="txt_box s120" value="<%=MAT_SEARCH.getWhere()%>">
										<bmp:option value="mat_code" text="รหัสสินค้า"></bmp:option>
										<bmp:option value="description" text="ชื่อสินค้า"></bmp:option>
										<bmp:option value="location" text="สถานที่จัดเก็บ"></bmp:option>
										<bmp:option value="ref_code" text="รหัสเดิม"></bmp:option>
									</bmp:ComboBox>
								</td>
								
								<td id="show_keyword" align="right" width="100">รหัสสินค้า</td>
								<td>: 
									<input type="text" class="s120 txt_box" name="keyword" value="<%=MAT_SEARCH.getKeyword()%>" autocomplete="off">
								</td>
								
								<td align="right" width="80">กลุ่ม</td>
								<td>: 
									<bmp:ComboBox name="group_id" styleClass="txt_box s120" listData="<%=Group.ddl_th()%>" validateTxt="เลือกกลุ่ม!" value="<%=MAT_SEARCH.getGroup_id()%>">
										<bmp:option value="n/a" text="--- เลือกกลุ่ม ---"></bmp:option>
									</bmp:ComboBox>
								</td>
								
								<td align="right" width="80">ชนิด</td>
								<td>: 
									<bmp:ComboBox name="cat_id" styleClass="txt_box s120" validateTxt="เลือกชนิด!">
										<bmp:option value="n/a" text="--- เลือกชนิด ---"></bmp:option>
									</bmp:ComboBox>	
								</td>
							</tr>
						</table>
					
						<div class="center s300 txt_center m_top5">
							<input type="checkbox" name="check" id="check" value="true" <%=(MAT_SEARCH.getCheck().equalsIgnoreCase("true"))?"checked='checked'":""%>> 
							<label for="check"> แสดงสินค้าที่ยังไม่ได้กำหนด</label>
							<input type="submit" name="submit" value="ค้นหา" class="btn_box btn_confirm s50">
							<input type="button" name="reset" value="ล้าง" class="btn_box btn_warn s50 m_left5" onclick="resetSearch();">
							<input type="hidden" name="action" value="search">
						</div>
					</form>
				</div>
				
				<!-- next page  -->
				<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"SearchInventory")%></div>
				<div class="clear"></div>
				<!-- next page  -->
				
				
				<table class="bg-image s900">
					<thead>
						<tr>
							<th valign="top" align="center" width="10%">รหัสสินค้า</th>
							<th valign="top" align="center" width="10%">ประเภท</th>
							<th valign="top" align="center" width="40%">ชื่อสินค้า</th>						
							<th valign="top" align="center" width="8%">สถานที่</th>
							<th valign="top" align="center" width="13%">คงคลัง</th>
							<th width="10%"></th>
						</tr>
					</thead>
					<tbody>
					<%
					boolean has = true;
					Iterator ite = list.iterator();
					while(ite.hasNext()) {
						InventoryMaster entity = (InventoryMaster) ite.next();
						has = false;
					%>
						<tr>
							<td><%=entity.getMat_code()%></td>
							<td><%=entity.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + entity.getUISubCat().getUICat().getCat_name_short() + ((entity.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + entity.getUISubCat().getSub_cat_name_short():"")%></td>
							<td><%=entity.getDescription()%></td>							
							<td align="center"><%=entity.getLocation()%></td>
							<td align="right"><%=Money.money(entity.getBalance())%></td>
							<td align="center">
								<img class="pointer" alt="รายละเอียด Material" src="../images/search_16.png" onclick="javascript: window.location='material_view.jsp?mat_code=<%=entity.getMat_code()%>'"></img>&nbsp;
								
								<% if(entity.getGroup_id().equalsIgnoreCase("FG")){ %>
									<img class="pointer" title="รับเข้า" alt="รับเข้า" src="../images/Download_16x16.png" onclick="javascript: window.location='inlet.jsp?mat_code=<%=entity.getMat_code()%>'"></img>&nbsp;
								<%} else if(entity.getGroup_id().equalsIgnoreCase("SS")){%>
									<img class="pointer" title="รับเข้า" alt="รับเข้า" src="../images/Download_16x16.png" onclick="javascript: window.location='inlet_ss.jsp?mat_code=<%=entity.getMat_code()%>'"></img>&nbsp;
								<% }else{ %>
									<img class="pointer" title="รับเข้า" alt="รับเข้า" src="../images/Download_16x16.png" onclick="javascript: window.location='inlet_invoice.jsp'"></img>&nbsp;
								<%} %>
								<img class="pointer" title="เบิกออก" src="../images/Upload_16x16.png" onclick="javascript: window.location='outlet.jsp?mat_code=<%=entity.getMat_code()%>'"></img>		
							</td>
						</tr>
					<%
					}
					if(has){
					%>
						<tr><td colspan="7" align="center">-- ไม่พบข้อมูล --</td></tr>
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
	// On load
	$(function(){
		var show_keyword = $('#show_keyword');
		var val = $('select[name=where]').val();
		
		switch (val) {
		case 'mat_code':
			show_keyword.text('รหัสสินค้า');
			break;
		case 'description':
			show_keyword.text('ชื่อสินค้า');
			break;
		case 'location':
			show_keyword.text('สถานที่จัดเก็บ');
			break;
		case 'ref_code':
			show_keyword.text('รหัสเดิม');
			break;
		default:
			break;
		}
		
		if ($('#group_id').val() != 'n/a') {
			$.post('GetCat',{group_id: $('#group_id').val(),action:'get_cat_th'}, function(resData){
				if (resData.status == 'success') {
					var options = '<option value="n/a">--- เลือกชนิด ---</option>';
	                var j = resData.cat;
	                var value = '<%=MAT_SEARCH.getCat_id()%>';
		            for (var i = 0; i < j.length; i++) {
		            	var selected = '';
		            	if (j[i].cat_id == value) {
		            		selected = ' selected';
						}
		                options += '<option value="' + j[i].cat_id + '"' + selected + '>' + j[i].cat_name_th + '</option>';
		            }
	             	$('#cat_id').html(options);
				} else {
					alert(resData.message);
				}
	        },'json');
		}
	});

	var show_keyword = $('#show_keyword');
	$('select[name=where]').change(function(){
		var val = $(this).val();
		switch (val) {
		case 'mat_code':
			show_keyword.text('รหัสสินค้า');
			break;
		case 'description':
			show_keyword.text('ชื่อสินค้า');
			break;
		case 'location':
			show_keyword.text('สถานที่จัดเก็บ');
			break;
		case 'ref_code':
			show_keyword.text('รหัสเดิม');
			break;
		default:
			break;
		}
	});
	
	$('#group_id').change(function(){
		ajax_load();
		$.post('GetCat',{group_id: $(this).val(),action:'get_cat_th'}, function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				var options = '<option value="n/a">--- เลือกชนิด ---</option>';
                var j = resData.cat;
	            for (var i = 0; i < j.length; i++) {
	                options += '<option value="' + j[i].cat_id + '">' + j[i].cat_name_th + '</option>';
	            }
             	$('#cat_id').html(options);
			} else {
				alert(resData.message);
			}
        },'json');
	});
	
	function resetSearch(){
		$('input[name=keyword]').val('');
		$('select[name=where]').val('description');
		$('select[name=group_id]').val('n/a');
		$('select[name=cat_id]').val('n/a');
		$('#show_keyword').text('ชื่อสินค้า');
	}
</script>
</body>
</html>