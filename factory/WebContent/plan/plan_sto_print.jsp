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
	//setTimeout('window.print()',500); setTimeout('window.close()',500);
}
</script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ใบจัดของ</title>
<%
String sto_no = WebUtils.getReqString(request, "sto_no"); 
String stg_status = WebUtils.getReqString(request, "status");
String stg_date = WebUtils.getReqString(request, "stg_date");
String pro_id = WebUtils.getReqString(request, "pro_id"); 
String status = WebUtils.getReqString(request, "status"); 
String create_by = WebUtils.getReqString(request, "create_by");
String item_type = WebUtils.getReqString(request, "item_type"); 
String create_date = WebUtils.getReqString(request, "create_date"); 
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();

paramList.add(new String[]{"ref_sto_no",sto_no});
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
				<div style="text-align: center;">
					<h5>บริษัทโคโคนัท แฟคทอรี่ จำกัด</h5>
					<h5>139/6 หมู่2 ตำบลบ้านแพ้ว อำเภอหลักสาม จังหวัดสมุทรสาคร
						74120 โทร 034-481-812-2 โทรสาร 034-481-823</h5>
				</div>
				<div style="text-align: right;">
					<h2 style="margin-right: 30px;">ใบโอนย้ายสินค้า</h2>
				</div>
				<div style="border: 1px solid #3F3B2B; width: 95%; margin-left: 22px;">

					<div class="wrap_logo" style="margin-left: 24px; ">
						<a href="../home.jsp"><img
							src="../images/logo_coconut_factory_report.png"></a>
					</div>
					<div class="content_head">

						<div class="left">
							<table width="750px" cellpadding="2" cellspacing="2" >
								<tbody>
									<tr>
										<td width="15%" class="txt_bold" align="right">จาก :</td>
										<td width="35%"><%=sto_no%></td>
										<td width="20%" class="txt_bold" align="right">เลข STO :</td>
										<td width="30%"><%=sto_no%></td>
									</tr>
									<tr>
										<td width="20%" class="txt_bold" align="right">สถานที่ส่งของ :</td>
										<td width="30%"><%=sto_no%></td>
										<td width="20%" align="right" class="txt_bold ">วันที่สั่งผลิต:</td>
										<td width="30%"><%=stg_date%></td>
									</tr>
									<tr>
										<td width="20%" class="txt_bold" align="right">โทร./แฟกซ์ :</td>
										<td width="30%"><%=sto_no%></td>
										<td width="20%" align="right" class="txt_bold ">สร้างโดย:</td>
										<td width="30%"><%=create_by%></td>
									</tr>
									<tr>
										<td width="20%" class="txt_bold" align="right">ผู้ติดต่อ :</td>
										<td width="30%"><%=sto_no%></td>
										<td width="20%" align="right" class="txt_bold ">สถานะ :</td>
										<td width="30%"><%=stg_status%></td>
									</tr>
									<tr>
										<td style="border-top:1px solid #3F3B2B; " align="right" class="txt_bold ">เงื่อนไขการส่งสินค้า :</td>
										<td colspan="3" style="border-top:1px solid #3F3B2B; " align="right"></td>
									</tr>

								</tbody>
							</table>

						</div>

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
										<th valign="top" align="center" width="10%">ลำดับ</th>
										<th valign="top" align="center" width="15%">รหัส</th>
										<th valign="top" align="center" width="35%">รายการวัตถุดิบที่ใช้</th>
										<th valign="top" align="center" width="15%">Stg_No</th>
										<th valign="top" align="center" width="10%">Production_No</th>
										<th valign="top" align="center" width="10%">จำนวน</th>
										<th valign="top" align="center" width="10%">หน่วยนับ</th>
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
														<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= entity.getRef_stg_no()%></td>
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
									<tr><td colspan="7" style="background-color: #dfdfdf;"></td></tr>
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
						 <div class='' style="position: absolute; bottom: 10px; left:25px;  width: 300px; height: 60px; text-align: center;">
						 	<p>ผู้จ่าย ลงชื่อ__________________________</p><br>
						 	<span>วันที่___________________________</span>
						 </div>
						 
						 
						 <div class='' style="position: absolute; bottom: 10px; right: 25px; width: 300px; height: 60px; text-align: center;">
						 	<p>ผู้รับ ลงชื่อ__________________________</p><br>
						 	<span>วันที่___________________________</span>
						 </div>
					</form>
				</div>
			</div>
		</div>
		
		<jsp:include page="../index/footer.jsp"></jsp:include>
		
		
	</div>
	
</body>
</html>