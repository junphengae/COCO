<%@page import="com.bmp.inv.stock.InventoryInfoTS"%>
<%@page import="com.bmp.inv.stock.bean.InventoryBean"%>
<%@page import="com.bmp.parts.master.bean.PartsMasterBean"%>
<%@page import="com.bmp.parts.master.transaction.PartsMasterTS"%>
<%@page import="com.bitmap.bean.parts.PartMaster"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.parts.PartGroups"%>
<%@page import="com.bitmap.bean.parts.PartCategories"%>
<%@page import="com.bitmap.bean.parts.PartCategoriesSub"%>
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

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/clear_form.js"></script>
<script src="../js/number.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/barcode.css" rel="stylesheet" type="text/css" media="all"> 
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<jsp:include page="../index/SessionUser.jsp"></jsp:include>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
 String check_id = WebUtils.getReqString(request, "check_id");
List paramList = new ArrayList();

String keyword    = WebUtils.getReqString(request, "keyword");
String group_id   = WebUtils.getReqString(request, "group_id");
String cat_id     = WebUtils.getReqString(request, "cat_id");
String sub_cat_id = WebUtils.getReqString(request, "sub_cat_id");


paramList.add(new String[]{"keyword",keyword});
paramList.add(new String[]{"group_id",group_id});
paramList.add(new String[]{"cat_id",cat_id});
paramList.add(new String[]{"sub_cat_id",sub_cat_id});
paramList.add(new String[]{"check_id",check_id});


if(!check_id.equalsIgnoreCase("")|| !check_id.equalsIgnoreCase("0")){
	paramList.add(new String[]{"flag_max_check_id","flag_max_check_id"});
}

session.setAttribute("PART_SEARCH", paramList);

String page_ = WebUtils.getReqString(request, "page");
PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);

if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
	session.setAttribute("PART_PAGE", page_);
}

if (WebUtils.getReqString(request, "action").length() == 0 && session.getAttribute("PART_PAGE") != null){
	ctrl.setPage_num(Integer.parseInt((String) session.getAttribute("PART_PAGE")));
}

//List list = PartsMasterTS.selectWithCTRL(ctrl, paramList,check_id);
List list = InventoryInfoTS.selectWithCTRL(ctrl, paramList,check_id);

%>
<script type="text/javascript">
	
	$(function(){
		var $msg = $('.msg_error');
		var $form = $('#infoForm');
		
		$.metadata.setType("attr", "validate");
		var v = $form.validate({
			submitHandler: function(){
				var addData = $form.serialize() + '&action=edit';
				ajax_load();
				$.post('../PartManagement',addData,function(data){
					ajax_remove();
					if (data.status == 'success') {
						//$msg.text('Update Success.').fadeIn(500);
						var urlredirect = 'part_info.jsp?pn='+$('#pn').val();
						//setTimeout("window.location.href('"+urlredirect+"')",1500);
						window.location =  urlredirect;
					} else {
						alert(data.message);
						$('#' + data.focus).focus();
						//test//
					}
				},'json');
			}
		});
		
		$form.submit(function(){
			v;
			return false;
		});
		

		if($('#group_id').val() != "") {
			$('#edit_group').fadeIn(500).attr('lang','part_group_edit.jsp?height=180&width=440&group_id=' + $('#group_id').val());
			$('#new_cat').fadeIn(500).attr('lang','part_cat_new.jsp?height=180&width=440&group_id=' +$('#group_id').val());
		}
		else{
			$('#edit_group').hide();
			$('#new_cat').hide();
			$('#edit_cat').hide();
			$('#edit_sub_cat').hide();
			$('#new_sub_cat').hide();
		}
		if($('#cat_id').val() != ""){
			$('#new_sub_cat').fadeIn(500).attr('lang','part_sub_cat_new.jsp?height=180&width=440&cat_id=' +$('#cat_id').val() + '&group_id=' + $('#group_id').val());
			$('#edit_cat').fadeIn(500).attr('lang','part_cat_edit.jsp?height=180&width=440&cat_id=' +$('#cat_id').val() + '&group_id=' + $('#group_id').val());
			
		}else{
			$('#edit_cat').hide();
			$('#new_sub_cat').hide();
			$('#edit_sub_cat').hide();
		}
		if($('#sub_cat_id').val() != ""){
			$('#edit_sub_cat').fadeIn(500).attr('lang','part_sub_cat_edit.jsp?height=180&width=440&sub_cat_id=' + $('#sub_cat_id').val() + '&cat_id=' + $('#cat_id').val() + '&group_id=' + $('#group_id').val());
		}else{
			$('#edit_sub_cat').hide();
		}
		
		$('#group_id').change(function(){
			ajax_load();
			$.post('../PartManagement',{group_id: $('#group_id').val(),action:'get_cat_th'}, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					var options = '<option value="">--- เลือกชนิด ---</option>';
	                var j = resData.cat;
	                $.each(j , function (index , object){
	                	 options += '<option value="' + object.cat_id + '">' + object.cat_name_th + ' ' + object.cat_name_short + '</option>';

	                });
	                	
	             	$('#cat_id').html(options);
	             	$('#sub_cat_id').html('<option value="">--- เลือกชนิดย่อย ---</option>');
				} else {
					alert(resData.message);
				}
	        },'json');
			
			if($('#group_id').val() != "") {
				$('#edit_group').fadeIn(500).attr('lang','part_group_edit.jsp?height=180&width=440&group_id=' + $('#group_id').val());
				$('#new_cat').fadeIn(500).attr('lang','part_cat_new.jsp?height=180&width=440&group_id=' +$('#group_id').val());
				$('#edit_cat').hide();
				$('#edit_sub_cat').hide();
				$('#new_sub_cat').hide();
			} else {
				$('#edit_group').hide();
				$('#new_cat').hide();
				$('#edit_cat').hide();
				$('#edit_sub_cat').hide();
				$('#new_sub_cat').hide();
			}
		});
		
		
		$('#cat_id').change(function(){
			ajax_load();
			$.post('../PartManagement',{group_id:$('#group_id').val(),cat_id: $(this).val(),action:'get_sub_cat_th'}, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					var options = '<option value="">--- เลือกชนิดย่อย ---</option>';
	                var j = resData.sub_cat;
		            $.each(j , function (index , object){
	                	 options += '<option value="' + object.sub_cat_id + '">' + object.sub_cat_name_th + ' ' + object.sub_cat_name_short + '</option>';
	                });
	             	$('#sub_cat_id').html(options);
				} else {
					alert(resData.message);
				}
	        },'json');
			
			if($('#cat_id').val() != "") {
				$('#new_sub_cat').fadeIn(500).attr('lang','part_sub_cat_new.jsp?height=180&width=440&cat_id=' +$('#cat_id').val() + '&group_id=' + $('#group_id').val());
				$('#edit_cat').fadeIn(500).attr('lang','part_cat_edit.jsp?height=180&width=440&cat_id=' +$('#cat_id').val() + '&group_id=' + $('#group_id').val());
				$('#edit_sub_cat').hide();
			} else {
				$('#edit_cat').hide();
				$('#edit_sub_cat').hide();
				$('#new_sub_cat').hide();
			}
		});
		
		$('#sub_cat_id').change(function(){
			if($(this).val() != "") {
				$('#edit_sub_cat').fadeIn(500).attr('lang','part_sub_cat_edit.jsp?height=180&width=440&sub_cat_id=' + $('#sub_cat_id').val() + '&cat_id=' + $('#cat_id').val() + '&group_id=' + $('#group_id').val());
			} else {
				$('#edit_sub_cat').hide();
			}
		});
		
		$('.btn_select').click(function(){
			var check_id='<%=check_id%>';
			ajax_load();
			$.post('../CheckStockServlet',{action:'check_stock',check_by:$('#check_by').val(),pn:$(this).attr('pn'),qty:$(this).attr('qty'),flag:$(this).attr('flag'),check_id_:check_id,mat_code_desc:$(this).attr('mat_code_desc')}, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.opener.location.reload(true);
					location.reload(); 
				} else {
					alert(resData.message);
				}
	        },'json');
		});
		$('.btn_select_all').click(function(){
			var check_id='<%=check_id%>';
			ajax_load();
			$.post('../CheckStockServlet',{action:'check_stock',check_by:$('#check_by').val(),flag:$(this).attr('flag'),check_id_:check_id}, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.opener.location.reload(true);
					location.reload(); 
				} else {
					alert(resData.message);
				}
	        },'json');
		});
	});
</script>

<title>Parts</title>

</head>
<body >

<div class="wrap_all">
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">Inventory</div>
				<div class="right">
						<input type="hidden" id="check_by" value="<%=securProfile.getPersonal().getPer_id()%>">
						<input type="button" value="เลือกทั้งหมด" class="btn_box btn_confirm btn_select_all"  flag="all" > 
				</div> 
					<div class="right">
						<!-- <button class="btn_box btn_add" onclick="window.location='part_add.jsp';">Create New Parts</button>  -->
					</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<div class="left">
					<form style="margin: 0; padding: 0;" action="inv_info.jsp" id="search" method="get">
						Keyword: 
						<input type="text" class="s120 txt_box" name="keyword" value="<%=keyword%>" autocomplete="off">  
					 	 Group:
						<%-- <bmp:ComboBox name="group_id" styleClass="txt_box s200" listData="<%=PartGroups.ddl_th() %>" value="<%=group_id%>">
							<bmp:option value="" text="--- All ---"></bmp:option>
						</bmp:ComboBox>   --%>
						
						 <Strong>กลุ่ม</Strong>: 
							<bmp:ComboBox name="group_id" styleClass="txt_box s120" width="120px" listData="<%=PartGroups.ddl_th()%>" validate="true" validateTxt="***** Required!"  value="<%=group_id%>">
								<bmp:option value="" text="--- All ---"></bmp:option>
							</bmp:ComboBox>
						 <Strong>ชนิด</Strong>: 
							<bmp:ComboBox name="cat_id" styleClass="txt_box s120" width="120px" listData="<%=PartCategories.ddl_th(group_id)%>" validate="true" validateTxt=" *** Required!" value="<%=cat_id%>">
								<bmp:option value="" text="--- All ---"></bmp:option>
							</bmp:ComboBox>
						<Strong>ชนิดย่อย</Strong>: 
							<bmp:ComboBox name="sub_cat_id" styleClass="txt_box s120" width="120px" listData="<%=PartCategoriesSub.ddl_th(cat_id, group_id)%>" validate="true" validateTxt=" *** Required!" value="<%=sub_cat_id%>">
								<bmp:option value="" text="--- All ---"></bmp:option>
							</bmp:ComboBox>
						<input type="submit" name="submit" value="Search" class="btn_box btn_confirm">
						<input type="button" name="reset" value="Reset" class="btn_box s50 m_left5" onclick="clear_form('#search');">
						<input type="hidden" name="action" value="search">
						<input type="hidden" name="check_id" value="<%=check_id%>">
					</form>
				</div>
				<div class="right txt_center"><%=PageControl.navigator_en(ctrl,"inv_info.jsp",paramList)%></div>
				<div class="clear"></div>
				
				<div class="dot_line"></div>
				<!-- <div class="scroll"> -->
				<table class="bg-image  s_auto breakword"><!-- เพิมbreakword มาเพื่อตัดคำ -->
					<thead>
						<tr>
							<th valign="top" align="center" width="12%" >Mat code</th>
							<th valign="top" align="center" width="17%">Po no.</th>
							<th valign="top" align="center" width="7%">ลักษณะบรรจุ</th>
							<th valign="top" align="center" width="8%">Lot No.</th>
							<th valign="top" align="center" width="19%" >ชื่อสินค้า</th>
							<th valign="top" align="center" width="11%">วันหมดอายุ</th>
							<th valign="top" align="center" width="8%">On Hand Qty</th> 
							<th align="center" width="8%"></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="10" style="padding: 0px 0px 0px 0px;" width="100%">
								<div class="scroll">
								<table class="bg-image"  style="border-collapse: collapse;" width="100%">
									<%
										boolean has = true;
										Iterator ite = list.iterator();
										while(ite.hasNext()) {
											InventoryBean entity = (InventoryBean) ite.next();
											has = false;
									%>
										<tr>
											<td align="left" valign="top" width="12%">
												<%=entity.getMat_code().trim() %>
											</td>
											<td align="center" valign="top" width="17%">
												<%=entity.getPo_no().trim()%>
											</td>
											<td align="center" valign="top" width="7%">
												<%=entity.getDes_unit().trim()%>
											</td>
											<td align="center" valign="top" width="7%">
												<%=entity.getLot_no().trim()%>
											</td>
											<td align="left" valign="top" width="22%"><%=entity.getProduct_desc().trim() %></td>
											<td align="left" valign="top" width="12%"><%=entity.getLot_expire().trim() %></td>
											<td align="left" valign="top" width="12%">
												<%=entity.getLot_qty().trim() %>
											</td>
											<td align="center" valign="top" width="8%"><input type="button" value="เลือก" class="btn_box btn_confirm btn_select" 
											pn="<%=entity.getPo_no().trim()%>" 
											qty="<%=entity.getLot_qty().trim()%>" 
											flag="one" 
											mat_code_desc="<%=entity.getMat_code()+":"+entity.getProduct_desc() %>" > </td>
											<%-- <td align="left" valign="top" width="8%">
												<a class="btn_view" href="part_info.jsp?pn=<%=entity.getPn()%>&id=1" title="View Parts Information"></a>
													<%if(!entity.getQty().equalsIgnoreCase("0")){%>
														<a class="btn_export thickbox" title="Borrow Parts" lang="borrow_part_create.jsp?pn=<%=entity.getPn()%>"></a>
													<%}%>
											</td> --%>
										</tr>
									<%
										}
										if(has){
									%>
										<tr><td colspan="12" align="center">Parts Master cannot be found!</td></tr>
									<%
										}
									%>
								</table>
								</div>	
							</td>
									
						</tr>			
					</tbody>
				</table>
				<!-- </div> -->
				<div align="center">
				<input type="button" id="close_form" class="btn_box btn_warn" value="Close Display" >
				</div>
				<script type="text/javascript">
				$(function(){
										
					$("#close_form").click(function(){ 					
				       	window.close(); 
					}); 
				});
				</script>
							
			</div>
		</div>
	</div>
	
</div>
</body>
</html>