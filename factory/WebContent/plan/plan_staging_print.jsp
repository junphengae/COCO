<%@page import="com.bitmap.bean.sale.Package"%>
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
<script type="text/javascript">
function setPrint(){
	setTimeout('window.print()',500); setTimeout('window.close()',500);
}
</script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ใบจัดของ</title>
<%
String stg_no = WebUtils.getReqString(request, "stg_no"); 
String stg_status = WebUtils.getReqString(request, "status");
String stg_date = WebUtils.getReqString(request, "stg_date");
String pro_id = WebUtils.getReqString(request, "pro_id"); 
String status = WebUtils.getReqString(request, "status"); 
String create_by = WebUtils.getReqString(request, "create_by");
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
%>
</head>
<body onload="setPrint()">
	<div class="wrap_all">
		

		<div class="wrap_body">
			<div class="body_content">
			
					<div class="wrap_logo" style="margin-left: 24px;"><a href="../home.jsp"><img src="../images/logo_coconut_factory_report.png"></a></div>
				<div class="content_head">
				
					<div class="left">
						<table width="700px" cellpadding="2" cellspacing="2">
							<tbody>
								<tr>
									<td width="20%" class="txt_bold" align="right">เลข staging :</td>
									<td width="30%"><%=stg_no%></td>
									<td width="60%" class="txt_bold" align="right"></td>
								</tr>
								<tr>
									<td width="20%" align="right"  class="txt_bold " >วันที่สร้าง :</td>
									<td width="20%"><%=stg_date%></td>
									<td width="60%" class="txt_bold txt_22" align="right">ใบจัดของ</td>
								</tr>
								<tr>
									<td width="20%" align="right" class="txt_bold ">สร้างโดย :</td>
									<td width="20%" ><%=create_by %></td>
									<td width="60%"></td>
								</tr>
								<tr>
									<td width="20%" align="right" class="txt_bold ">สถานะ :</td>
									<td width="20%" ><%=stg_status %></td>
									<td width="60%"></td>
								</tr>

							</tbody>
						</table>

					</div>
					
					<div class="clear"></div>
					<div class="clear"></div>
					<div class="clear"></div>
				</div>

				<div class="content_body">
					<form id="sale_order_info" onsubmit="return false;">

						<div class="dot_line m_top10"></div>
						<fieldset class="fset">
							<table class="bg-image s900">
								<thead>
									<tr>
										<th valign="top" align="center" width="10%" colspan="6">รายการวัตถุดิบ</th>
									</tr>
								</thead>
								<thead>
									<tr>
										<th valign="top" align="center" width="10%">NO.</th>
										<th valign="top" align="center" width="15%">Mat_Code</th>
										<th valign="top" align="center" width="35%">Description</th>
										<th valign="top" align="center" width="15%">เลขที่การผลิต</th>
										<th valign="top" align="center" width="10%">Qty Stg.</th>
										<th valign="top" align="center" width="10%">Unit</th>
									</tr>
								</thead>
								<tbody>

									<%
									boolean has = true;
									int c_mat = 0;
									while(ite.hasNext()) {
										Production entity = (Production) ite.next();
										InventoryMaster mat = entity.getUIMat();
										Package pac = entity.getUIPac();
										SaleOrderItem order = entity.getUIorder();
										has = false;
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
																	c_mat++;
													%>
													<tr>
														<td align="center"><%= c_mat %></td>
														<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= detail.getMaterial()%></td>
														<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= detail.getUIMat().getDescription()%></td>
														<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= entity.getPro_id()%></td>
														<td align="right">
														<% String mat_qty = entity.getItem_qty();
															String qty_ = "";
															String unit_ = "";
															
															if(step.getProcess().equalsIgnoreCase("Packing")|| step.getProcess().equalsIgnoreCase("Label") || step.getProcess().equalsIgnoreCase("Keepstock")){
																qty_ = (Double.parseDouble(detail.getUsage_())*Double.parseDouble(mat_qty))+ " ";
																unit_ = detail.getUIMat().getStd_unit();
															}else{
																qty_ = detail.getQty();
																unit_ =  " % ";
															}
														%>
														<%= qty_%>
														</td>
														<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= unit_%></td>
													</tr>
													<%
													}
												}
											}
										%>
									<tr><td colspan="6" style="background-color: #dfdfdf;"></td></tr>
									<%}
									if(has){
										%>
										<tr><td colspan="8" align="center">---- ไม่พบรายการโปรดักชั่น ---- </td></tr>
									<%
										}
									%>
								</tbody>
							</table>
						</fieldset>
						<div class="center txt_center">
						</div>
						 <div class='' style="position: absolute; bottom: 10px; left:25px;  width: 200px; height: 60px; text-align: center;">
						 	<p>__________________________</p><br>
						 	<span>(ผู้ตั้งเบิก)</span>
						 </div>
						 
						 <div class='' style="position: absolute; bottom: 10px; left:40%;  width: 200px; height: 60px; text-align: center;">
						 	<p>__________________________</p><br>
						 	<span>(ผู้อนุมัติการเบิก)</span>
						 </div>
						 
						 <div class='' style="position: absolute; bottom: 10px; right: 25px; width: 200px; height: 60px; text-align: center;">
						 	<p>__________________________</p><br>
						 	<span>(ผู้จัดของ)</span>
						 </div>
					</form>
				</div>
			</div>
		</div>
		
		<jsp:include page="../index/footer.jsp"></jsp:include>
		
		
	</div>
	
</body>
</html>