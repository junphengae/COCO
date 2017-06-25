<%@page import="com.bitmap.bean.inventory.SubCategories"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.util.ListUtil"%>
<%@page import="com.bitmap.bean.rd.*"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/number.js"></script>
<script src="../js/production_js.js"></script>

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<jsp:useBean id="MAT" class="com.bitmap.bean.inventory.InventoryMaster" scope="session"></jsp:useBean>
<%
InventoryMaster master = new InventoryMaster();
RDFormular formular = new RDFormular();
WebUtils.bindReqToEntity(formular, request);
String prod_qty = WebUtils.getReqString(request, "prod_qty");
String prod_id = WebUtils.getReqString(request, "prod_id");
RDFormular.select(formular);
master = formular.getUIMat();
RDFormularInfo fmInfo = formular.getUIInfo();

float sumQty = RDFormularDetail.calSumQtyByCondition(formular.getMat_code());
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Add New Production</title>
<script type="text/javascript">

</script>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการโปรดักชั่นเลขที่ :  <%=prod_id%></div>
				<div class="right m_right10">
					<button class="btn_box" onclick="window.location='plan_production_add.jsp'">ย้อนกลับ</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<form id="create_production_form" onsubmit="">
					<table width="100%">
						<tbody>
							<tr>
									<td width="130" align="left">ชื่อสินค้า</td>
									<td width="400">: <%=master.getDescription()%></td>
								</tr>
								<tr>
									<td width="100" align="left">รหัสสินค้า</td>
									<td width="250">: <%=master.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + master.getUISubCat().getUICat().getCat_name_short() + ((master.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + master.getUISubCat().getSub_cat_name_short():"") + "-" + master.getMat_code()%></td>
								</tr>
								<tr>
									<td width="130" align="left">กลุ่ม</td>
									<td width="400">: <%=master.getUISubCat().getUICat().getUIGroup().getGroup_name_th() %></td>
								</tr>
								<tr>
									<td align="left">ชนิด</td>
									<td>: <%=master.getUISubCat().getUICat().getCat_name_th()%></td>
								</tr>	
								<tr>
									<td align="left">จำนวนที่ต้องการผลิต</td>
									<td>: <input type="text" class="txt_box" id="production-create-qty" name="item_qty" value="<%=prod_qty %>" disabled="disabled"></td>
								</tr>
								<tr><td colspan="2" height="20"><div class="dot_line"></div></td></tr>

									<div class="s800 right">
										<table class="bg-image s800">
										<thead>
											<tr>
												<th valign="top" align="center" width="9%">ขั้นตอนที่</th>
												<th valign="top" align="left" width="35%">วัตถุดิบที่ใช้ผลิต</th>
												<th valign="top" align="center" width="15%">จำนวน/อัตราส่วน</th>
											</tr>
										</thead>
										<tbody id="material_list">
								<%
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
												<td align="center"><%=step.getStep() %></td>
												<td><%=detail.getMaterial() + " - "+ detail.getUIMat().getDescription()%></td>
												<td align="center"><%=(step.getProcess().equalsIgnoreCase("Packing")|| step.getProcess().equalsIgnoreCase("Label") || step.getProcess().equalsIgnoreCase("Keepstock")) ? detail.getUsage_() : detail.getQty()%></td>
											</tr>
											<%
											}
										}
									}
								%>
										</tbody>
									</table>
								</div>
								<tr>
								<td colspan="2" align="center" height="30">
									<div class="txt_center">
										<input type="button" name="edit" class="btn_box btn_confirm" value="บันทึก" id="btn-confirm"  onclick="createNewProduction()" disabled="disabled">
										<input type="hidden" name="action" value="create_production">
										<input type="hidden" name="item_id" value="<%=master.getMat_code()%>">
										<input type="hidden" name="item_type" value="1">
										<input type="hidden" name="status" value="10">
										<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>