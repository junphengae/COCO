<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.bitmap.bean.staging.Staging"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.rd.*"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/table.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/popup.js" type="text/javascript"></script>

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>สร้างรายการ staging</title>
<%
String stg_no = WebUtils.getReqString(request, "stg_no"); 
String stg_status = WebUtils.getReqString(request, "status");
String stg_date = WebUtils.getReqString(request, "stg_date");
String pro_id = WebUtils.getReqString(request, "pro_id"); 
String status = WebUtils.getReqString(request, "status"); 
String item_type = WebUtils.getReqString(request, "item_type"); 
String create_date = WebUtils.getReqString(request, "create_date"); 
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();

paramList.add(new String[]{"ref_stg_no",stg_no});
paramList.add(new String[]{"pro_id",pro_id});
paramList.add(new String[]{"item_type",item_type});
paramList.add(new String[]{"create_date",create_date});

session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = Production.selectWithCTRL(ctrl, paramList).iterator();

List param = new ArrayList();
param.add(new String[]{"stg_no",stg_no});
List<Staging> lstStg = Staging.select(ctrl, param);
Personal create_user_obj = Personal.select(lstStg.get(0).getCreate_by());
String create_user = create_user_obj.getName()+" "+create_user_obj.getSurname();
%>
</head>
<body>
	
	<div class="wrap_all">
		<jsp:include page="../index/header.jsp"></jsp:include>

		<div class="wrap_body">
			<div class="body_content">
				<div class="content_head">
					<div class="left">รายการ Staging</div>
					<div class="right m_right10">
						<div class="right btn_box m_right15" onclick='window.location="plan_staging.jsp";'>ย้อนกลับ</div> 
						<%if(Integer.parseInt(lstStg.get(0).getStatus())<30){ %>
							<button id="add_prod"  class="right btn_box btn_confirm"  type="button"  title="เลือกรายการ" onclick="popupSetWH('plan_staging_list_prod.jsp?stg_no=<%=stg_no %>','1050','700');">เพิ่มรายการโปรดักชั่น</button> 
						<%}else{ %>
							<!--<button class="right btn_box"  type="button"  title="เลือกรายการ" disabled="disabled">เพิ่มรายการโปรดักชั่น</button>   -->
						<%} %>
					</div>
					
					<div class="clear"></div>
				</div>

				<div class="content_body">
					<form id="sale_order_info" onsubmit="return false;">
						<table width="100%" cellpadding="2" cellspacing="2">
							<tbody>
								<tr>
									<td width="130" class="txt_bold">เลข staging :
									<td>
									<td width="370"><%=stg_no%></td>
									<td width="130">วันที่สร้าง :</td>
									<td width="370" class="txt_bold "><%=stg_date%></td>
									<td width="130">สถานะ :</td>
									<td width="370" class="txt_bold "><%=Staging.status(lstStg.get(0).getStatus()) %></td>
								</tr>

								<tr>
									<td colspan="4" height="15"></td>
								</tr>
							</tbody>
						</table>

						<div class="dot_line m_top10"></div>
						<fieldset class="fset">
							<legend>รายการโปรดักชั่น</legend>
							<table class="bg-image s900">
								<thead>
									<tr>
										<th valign="top" align="center" width="10%">เลขที่การผลิต</th>
										<th valign="top" align="center" width="30%">รายการสินค้า</th>
										<th valign="top" align="center" width="10%">จำนวน</th>
									</tr>
								</thead>
								<tbody>

									<%
									boolean has = true;
									while(ite.hasNext()) {
										Production entity = (Production) ite.next();
										InventoryMaster mat = entity.getUIMat();
										Package pac = entity.getUIPac();
										SaleOrderItem order = entity.getUIorder();
										has = false;
									
									%>
									<tr>
										<td valign="top" align="center" class="txt_bold"><%=entity.getPro_id()%></td>
										<td valign="top" align="left" class="txt_bold">
											<%
												if(entity.getItem_type().equalsIgnoreCase("PRO")){
											%>
												<%=pac.getName()%>
											<%	
												}else {
												%><%=mat.getDescription() %>
												<%
												}
											%>
										</td>
										<td valign="top" align="right" class="txt_bold"><%=entity.getItem_qty() +" "+mat.getStd_unit()%></td>
									</tr>
									<tr><td></td> <td colspan="2"> สูตรการผลิต และวัตถุดิบที่ต้องใช้  </td></tr>
									<%
												//loop step from R&D
											RDFormular formular = new RDFormular();
											formular.setMat_code(mat.getMat_code());
											RDFormular.select(formular); 
											RDFormularInfo fmInfo = formular.getUIInfo();  
											
											
											int i = 0;
											int c_order =0;
											List<RDFormularStep> listStep = formular.getUIStep();
											for (RDFormularStep step : listStep) {
												i++;
												List<RDFormularDetail> listDetail = step.getUIDetail();
												if (listDetail.size() > 0){
														int j = 0;
																for (RDFormularDetail detail : listDetail) {
																	j++;
																	c_order++;
													%>
													<tr>
														<td align="center"></td>
														<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= c_order+". "+detail.getMaterial() + " - "+ detail.getUIMat().getDescription()%></td>
														<td align="right">
														<% String mat_qty = entity.getItem_qty();
															String qty_ = "";
															
															if(step.getProcess().equalsIgnoreCase("Packing")|| step.getProcess().equalsIgnoreCase("Label") || step.getProcess().equalsIgnoreCase("Keepstock")){
																qty_ = (Double.parseDouble(detail.getUsage_())*Double.parseDouble(mat_qty))+ " "+ detail.getUIMat().getStd_unit();
															}else{
																qty_ = detail.getQty() + " %";
															}
														%>
														<%= qty_%>
														</td>
													</tr>
													<%
													}
												}
											}
										%>
									<tr><td colspan="3" style="background-color: #dfdfdf;"></td></tr>
									<%}
									if(has){
										%>
										<tr><td colspan="8" align="center">---- ไม่พบรายการโปรดักชั่น ---- </td></tr>
									<%
									}else{%>
										<tr>
										<td colspan="3" align="center" style="background-color: #dfdfdf;">
										<%if("20".equals(lstStg.get(0).getStatus())){ %>
											<button id="print_stg"  class="btn_box btn_confirm"  type="button" >พิมม์ใบจัดของ</button>
										<%} %>
										<%if("50".equals(lstStg.get(0).getStatus())){ %>
											<button class="btn_box btn_confirm"  type="button" onclick="window.open('plan_staging_print.jsp?stg_no=<%=stg_no%>&status=<%=stg_status%>&stg_date=<%=stg_date%>&create_by=<%=create_user%>');">พิมม์ใบจัดของอีกครั้ง</button>
										<%} %>
										
										<%if(!"20".equals(lstStg.get(0).getStatus())){%>
											<button id="update_stg_to_packed"  class="btn_box btn_confirm"  type="button" >จัดของเรียบร้อยแล้ว</button>
										<%}%>
										
										</td>
										
									<%
									}
									%>
								</tbody>
							</table>
						</fieldset>
						<input type="hidden" id="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
						<div class="center txt_center">
						</div>
						 
					</form>
				</div>
			</div>
		</div>
		<jsp:include page="../index/footer.jsp"></jsp:include>
	</div>
	
</body>
<script type="text/javascript">
$("#print_stg").click(function () {
	ajax_load();
	$.post('../StagingServlet',{action:'update_staging_to_print_picking_list',stg_no:<%=stg_no%>,update_by:$("#update_by").val()}, function(resData){
		ajax_remove();
		if (resData.status == 'success') {
			window.open('plan_staging_print.jsp?stg_no=<%=stg_no%>&status=<%=stg_status%>&stg_date=<%=stg_date%>&create_by=<%=create_user%>');
		} else {
			alert(resData.message);
		}
    },'json');
}

);

$("#update_stg_to_packed").click(function () {
	ajax_load();
	$.post('../StagingServlet',{action:'update_staging_to_packed',stg_no:<%=stg_no%>,update_by:$("#update_by").val()}, function(resData){
		ajax_remove();
		if (resData.status == 'success') {
			window.location.reload();
		} else {
			alert(resData.message);
		}
    },'json');
});

</script>
</html>