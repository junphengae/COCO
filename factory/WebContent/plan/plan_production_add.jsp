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
<title>ค้นหาสูตรการผลิต(Search Formular)</title>

<%
List param = new ArrayList();
String where = WebUtils.getReqString(request, "where");
String keyword = WebUtils.getReqString(request, "keyword");
String group_id = WebUtils.getReqString(request, "group_id");
String cat_id = WebUtils.getReqString(request, "cat_id");
String page_ = WebUtils.getReqString(request, "page");

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);

param.add(new String[]{"where",where});
param.add(new String[]{"keyword",keyword});
if (where.length() > 0){param.add(new String[]{where,keyword});}
param.add(new String[]{"group_id",group_id});
param.add(new String[]{"cat_id",cat_id});

session.setAttribute("F_SEARCH", param);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("F_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("F_SEARCH_PAGE")));
}

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("F_SEARCH_PAGE", page_);
}

List list = InventoryMaster.selectWithCTRL(ctrl, param);
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left"> สร้างโปรดักชั่นจากสูตรการผลิต</div>
				<div class="right m_right15">
					<button class="btn_box btn_confirm" onclick="window.location='../rd/formular_new.jsp';">สร้างสูตรใหม่</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="detail_wrap s900 center">
					<form style="margin: 0; padding: 0;" action="plan_production_add.jsp" id="search" method="get">
						<table>
							<tr>
								<td>ค้นหาจาก</td>
								<td>: 
									<bmp:ComboBox name="where" styleClass="txt_box s120" value="<%=where%>">
										<bmp:option value="description" text="ชื่อสินค้า"></bmp:option>
										<bmp:option value="mat_code" text="รหัสสินค้า"></bmp:option>
										<bmp:option value="location" text="สถานที่จัดเก็บ"></bmp:option>
										<bmp:option value="ref_code" text="รหัสเดิม"></bmp:option>
									</bmp:ComboBox>
								</td>
								
								<td id="show_keyword" align="right" width="100">ชื่อสินค้า</td>
								<td>: 
									<input type="text" class="s120 txt_box" name="keyword" value="<%=keyword%>" autocomplete="off">
								</td>
								
								<td align="right" width="80">กลุ่ม</td>
								<td>: 
									<bmp:ComboBox name="group_id" styleClass="txt_box s120" listData="<%=Group.ddl_formularGroup()%>" validateTxt="เลือกกลุ่ม!" value="<%=group_id%>">
										<bmp:option value="" text="--- เลือกกลุ่ม ---"></bmp:option>
									</bmp:ComboBox>
								</td>
								
								<td align="right" width="80">ชนิด</td>
								<td>: 
									<bmp:ComboBox name="cat_id" styleClass="txt_box s120" validateTxt="เลือกชนิด!">
										<bmp:option value="" text="--- เลือกชนิด ---"></bmp:option>
									</bmp:ComboBox>	
								</td>
							</tr>
						</table>
					
						<div class="center s300 txt_center m_top5">
							<input type="submit" name="submit" value="ค้นหา" class="btn_box s50">
							<input type="button" name="reset" value="ล้าง" class="btn_box s50 m_left5" onclick="resetSearch();">
							<input type="hidden" name="action" value="search">
						</div>
					</form>
				</div>
				
				<!-- next page  -->
				<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"plan_production_add.jsp",param)%></div>
				<div class="clear"></div>
				<!-- next page  -->
				
				
				<table class="bg-image s900">
					<thead>
						<tr>
							<th valign="top" align="center" width="10%">รหัสสินค้า</th>
							<th valign="top" align="center" width="17%">ประเภท</th>
							<th valign="top" align="center" width="22%">ชื่อสินค้า</th>
							<th valign="top" align="center" width="15%">รหัสเดิม</th>
							<th valign="top" align="center" width="13%">สถานะ</th>
							<th valign="top" align="center" width="10%">หน่วยนับ</th>
							<th width="13%"></th>
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
								<td><%=entity.getRef_code()%></td>
								<td align="center"><%=StatusUtil.getStatus(entity.getStatus())%></td>
								<td align="center"><%=entity.getStd_unit()%></td>
								<td align="center">
									<button class="btn_box" onclick="javascript: window.location='plan_production_add_qty.jsp?mat_code=<%=entity.getMat_code()%>';">สร้างโปรดักชั่น</button>
								</td>
							</tr>
						<%}
						if(has){%>
							<tr><td colspan="7" align="center">-- ไม่พบข้อมูล --</td></tr>
						<%}%>
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
					var options = '<option value="">--- เลือกชนิด ---</option>';
	                var j = resData.cat;
	                var value = '<%=cat_id%>';
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
				var options = '<option value="">--- เลือกชนิด ---</option>';
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
		$('select[name=group_id]').val('');
		$('select[name=cat_id]').val('');
		$('#show_keyword').text('ชื่อสินค้า');
	}
</script>
</body>
</html>