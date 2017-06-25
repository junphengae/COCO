<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
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
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>


<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<jsp:useBean id="MAT_SEARCH" class="com.bitmap.bean.inventory.MaterialSearch" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการส่งเสริมการขาย</title>
<%
Package entity = new Package();
WebUtils.bindReqToEntity(entity, request);
Package.select(entity);


%>
<script type="text/javascript">
$(function(){
	
	$('.btn_del_item').click(function(){
			if (confirm('ยืนยันการลบ!')) {
				var data = {
							'action':'fg_del',
							'pk_id':$(this).attr('pk_id'),
							'mat_code':$(this).attr('mat_code'),
							'update_by':'<%=securProfile.getPersonal().getPer_id()%>',
							'run':$(this).attr('run')
						   };
				
				ajax_load();
				$.post('PackageManage',data, function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						window.location.reload();
					} else {
						alert(resData.message);
					}
				},'json');
			}
	});
	
	
	$('#sale_create_item').submit(function(){
		ajax_load();
		$.post('PackageManage',$(this).serialize(),function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				window.location='package_create_item.jsp?pk_id='+ resData.pk_id;
			} else {
				alert(resData.message);
			}
		},'json');	
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
				<div class="left">สร้างรายการส่งเสริมการขาย | 1. กำหนดชื่อรายการ | 2. เพิ่มสินค้าในรายการ</div>
				<div class="right btn_box m_right15" onclick="window.location='package.jsp'">ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<div class="detail_wrap s900 center">
					<fieldset class="fset">
						<legend>รายละเอียดรายการส่งเสริมการขาย</legend>
						<table class="s900">
							<tr>								
								<td width="200">ชื่อรายการ</td>
								<td>: 
									<%=entity.getName()%> 
								</td>
							</tr>
							<tr>								
								<td width="200">ประเภทรายการ</td>
								<td>: 
									<%=(entity.getPk_type().equalsIgnoreCase("p"))?"โปรโมชั่น / Promotion":"เซต / Set"%> 
								</td>
							</tr>
							<%
							if(entity.getPk_type().equalsIgnoreCase("p")){
							%>
							<tr>								
								<td width="200">จำนวนชุด</td>
								<td>: 
									<%=entity.getPk_qty()%> 
								</td>
							</tr>
							<%
							}
							%>
							<tr>
								<td colspan="2" align="center">
									<% if(entity.getStatus().equalsIgnoreCase(Package.STATUS_CREATE)){ %>
									<button class="btn_box thickbox btn_confirm center" lang="package_name_edit.jsp?pk_id=<%=entity.getPk_id()%>&width=500&height=200" title="แก้ไขรายละเอียด">แก้ไขรายละเอียด</button>
									<%} %>
									<div class="dot_line m_top10"></div>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<div class="left s400">
										<div class="left s200">ราคารวม</div><div class="left">: <%=Money.money(entity.getPrice())%></div>
										<div class="clear"></div>
									</div>
									<%
									if(entity.getPk_type().equalsIgnoreCase("p")){
									%>
									<div class="left s400">
										<div class="left s200">ราคาต่อชุด</div><div class="left">: <%=Money.money(Money.divide(entity.getPrice(), entity.getPk_qty())) %></div>
										<div class="clear"></div>
									</div>
									<%}%>
									<div class="clear"></div>
								
								</td>
							</tr>
							
							<tr>
								<td>สถานะ</td>
								<td>: <%=Package.status(entity.getStatus())%>
								</td>
							</tr>
								
						</table>
						
					</fieldset>
					
					<div class="dot_line m_top15"></div>
					
					<fieldset class="fset">
						<legend>รายการสินค้า</legend>
						<% if(entity.getStatus().equalsIgnoreCase(Package.STATUS_CREATE)){ %>
						<button class="btn_box thickbox right btn_confirm" lang="package_item_add.jsp?pk_id=<%=entity.getPk_id()%>&width=500&height=200" title="เพิ่มรายการสินค้า">เพิ่มรายการสินค้า</button>
						<%} %>
						<div class="clear"></div>
							
				<table class="bg-image s900">
					<thead>
						<tr>
							<th valign="top" align="center" width="13%">รหัสสินค้าจำหน่าย</th>
							<th valign="top" align="center" width="20%">ชื่อสินค้าจำหน่าย</th>
							<th valign="top" align="center" width="12%">ราคาต่อหน่วย</th>
							<th valign="top" align="center" width="9%">จำนวน</th>
							<th valign="top" align="center" width="12%">ส่วนลด</th>
							<th valign="top" align="center" width="12%">ราคาหลังลด</th>
							<th width="13%"></th>
						</tr>
					</thead>
						
					<tbody>
						<%
						Iterator ite = PackageItem.listByPk(entity.getPk_id()).iterator();
						while (ite.hasNext()){
							PackageItem pk = (PackageItem) ite.next();
							InventoryMaster mat = pk.getUIMat();
							
							
						%>
						<tr>
							<td valign="top" align="center"><%=pk.getMat_code()%></td>
							<td valign="top" align="center"><%=mat.getDescription()%></td>
							<td valign="top" align="center"><%=Money.money(pk.getUnit_price())%></td>
							<td valign="top" align="center"><%=pk.getQty()%></td>
							<td valign="top" align="center"><%=pk.getDiscount()%>%</td>
							<td valign="top" align="center"><%=Money.money(Money.discount(Money.multiple(pk.getQty(), pk.getUnit_price()), pk.getDiscount()))%></td>
							<td valign="top" align="center">
							<% if(entity.getStatus().equalsIgnoreCase(Package.STATUS_DIRECTOR_APPROVE)){ %>
							
							<%}else{ %>
								<button class="btn_box thickbox btn_confirm" lang="package_item_edit.jsp?pk_id=<%=pk.getPk_id()%>&mat_code=<%=pk.getMat_code()%>&run=<%=pk.getRun()%>&width=500&height=200" title="แก้ไขรายการสินค้า">แก้ไข</button>
								<input type="button" class="btn_box btn_warn m_left5 btn_del_item" pk_id="<%=pk.getPk_id()%>" mat_code="<%=pk.getMat_code()%>" run="<%=pk.getRun()%>" value="ลบ"/>
							<%} %>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>						
						
					</fieldset>
					
					
					
						<div class="center s300 txt_center m_top5">
							<input type="hidden" name="action" value="package_create_item">
						</div>
					
				</div>
				
				
						
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>