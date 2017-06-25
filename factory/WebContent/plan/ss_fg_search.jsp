<%@page import="com.bitmap.bean.sale.Package"%>
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
<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/popup.js" type="text/javascript"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ค้นหา SS (Search Substate)</title>

<%
List param = new ArrayList();
String where = WebUtils.getReqString(request, "where");
String keyword = WebUtils.getReqString(request, "keyword");
String cat_id = WebUtils.getReqString(request, "cat_id");
String page_ = WebUtils.getReqString(request, "page");

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);

param.add(new String[]{"where",where});
param.add(new String[]{"keyword",keyword});
if (where.length() > 0){param.add(new String[]{where,keyword});}
param.add(new String[]{"cat_id",cat_id});

session.setAttribute("FG_SEARCH", param);

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("FG_SEARCH_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("FG_SEARCH_PAGE")));
}

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("FG_SEARCH_PAGE", page_);
}

List list = InventoryMaster.selectSSWithCTRL(ctrl, param);
%>
</head>
<body>

<div class="wrap_all">	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">ค้นหาสินค้าจำหน่าย</div>
				<div class="right m_right15">					
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="detail_wrap s900 center">
					<form style="margin: 0; padding: 0;" action="ss_fg_search.jsp" id="search" method="get">
						<table>
							<tr>
								<td>ค้นหาจาก</td>
								<td>: 
									<bmp:ComboBox name="where" styleClass="txt_box s150" value="<%=where%>">
										<bmp:option value="description" text="ชื่อสินค้าจำหน่าย"></bmp:option>
										<bmp:option value="mat_code" text="รหัสสินค้าจำหน่าย"></bmp:option>
										<bmp:option value="ref_code" text="รหัสสินค้าเดิม"></bmp:option>
									</bmp:ComboBox>
								</td>
								
								<td id="show_keyword" align="right" width="200">ชื่อวัตถุดิบ</td>
								<td>: 
									<input type="text" class="s150 txt_box" name="keyword" value="<%=keyword%>" autocomplete="off">
								</td>
								
								<td align="right" width="80">ชนิด</td>
								<td>: 
									<bmp:ComboBox name="cat_id" styleClass="txt_box s200" validateTxt="เลือกชนิด!" value="<%=cat_id%>">
										<bmp:option value="" text="--- เลือกชนิด ---"></bmp:option>
									</bmp:ComboBox>	
								</td>
							</tr>
						</table>
					
						<div class="center s300 txt_center m_top5">
							<input type="submit" name="submit" value="ค้นหา" class="btn_box">
							<input type="button" name="reset" value="ล้าง" class="btn_box m_left5" onclick="resetSearch();">
							<input type="button" value="ปิดหน้าจอ" class="btn_box m_left5" onclick="window.close();">
							<input type="hidden" name="action" value="search">
							<input type="hidden" name="group_id" id="group_id" value="SS">
						</div>
					</form>
				</div>
				
				<!-- next page  -->
				<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"ss_fg_search.jsp",param)%></div>
				<div class="clear"></div>
				<!-- next page  -->
				
				
				<table class="bg-image s900">
					<thead>
						<tr>
							<th valign="top" align="center" width="20%">รหัสสินค้า</th>
							<th valign="top" align="center" width="27%">ชื่อสินค้า</th>
							<th valign="top" align="center" width="15%">รหัสเดิม</th>
							<th valign="top" align="center" width="15%">สถานะ</th>
							<th valign="top" align="center" width="8%">หน่วยนับ</th>
							<th width="15%"></th>
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
							<td><%=entity.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + entity.getUISubCat().getUICat().getCat_name_short() + ((entity.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + entity.getUISubCat().getSub_cat_name_short():"") + "-" + entity.getMat_code()%></td>
							<td><%=entity.getDescription()%></td>
							<td><%=entity.getRef_code()%></td>
							<td align="center"><%=StatusUtil.getStatus(entity.getStatus())%></td>
							<td align="center"><%=entity.getStd_unit()%></td>
							<td align="center">
								<button class="btn_box thickbox" title="Material Information" lang="../info/material_view.jsp?mat_code=<%=entity.getMat_code()%>&width=1000&height=450">ดู</button>
								<button class="btn_box btn_select" data_type="<%=entity.getGroup_id()%>" data_name="<%=entity.getDescription()%>" data_id="<%=entity.getMat_code()%>" data_unit="<%=entity.getDes_unit()%>" data_price="<%=entity.getPrice()%>">เลือก</button>
							</td>
						</tr>
					<%
					}
					if(has){
					%>
						<tr><td colspan="6" align="center">-- ไม่พบข้อมูล --</td></tr>
					<%
					}
					%>
					</tbody>
				</table>
						
			</div>
		</div>
	</div>
	
</div>
<script type="text/javascript">
	// On load
	$(function(){
		var show_keyword = $('#show_keyword');
		var val = $('select[name=where]').val();
		
		switch (val) {
		case 'mat_code':
			show_keyword.text('รหัสสินค้าจำหน่าย');
			break;
		case 'description':
			show_keyword.text('ชื่อสินค้าจำหน่าย');
			break;
		case 'ref_code':
			show_keyword.text('รหัสสินค้าเดิม');
			break;
		default:
			break;
		}
		
		if ($('#cat_id').val() != 'n/a') {
			$.post('GetCat',{group_id: 'SS',action:'get_cat_th'}, function(resData){
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
		
		
		$(".btn_select").click(function(){ 
		        window.opener.$("#request_by_autocomplete").val($(this).attr('data_id'));
		        window.opener.$('#mat_name').text($(this).attr('data_name'));
		        window.opener.$('#data_unit').text("KG");
		       	window.close(); 
		}); 
	});

	var show_keyword = $('#show_keyword');
	$('select[name=where]').change(function(){
		var val = $(this).val();
		switch (val) {
		case 'mat_code':
			show_keyword.text('รหัสสินค้าจำหน่าย');
			break;
		case 'description':
			show_keyword.text('ชื่อสินค้าจำหน่าย');
			break;
		case 'ref_code':
			show_keyword.text('รหัสสินค้าเดิม');
			break;
		default:
			break;
		}
	});
	
	function resetSearch(){
		$('input[name=keyword]').val('');
		$('select[name=where]').val('description');
		$('select[name=cat_id]').val('n/a');
		$('#show_keyword').text('ชื่อสินค้าจำหน่าย');
	}
</script>
</body>
</html>