<%@page import="com.sun.org.apache.bcel.internal.generic.NEWARRAY"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItemMat"%>
<%@page import="com.bitmap.bean.rd.MatTree"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.bean.rd.RDFormularDetail"%>
<%@page import="com.bitmap.bean.rd.RDFormularStep"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
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

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>


<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">


<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ประเมินรายการขาย</title>
<%
SaleOrderItem orderItem = new SaleOrderItem();
WebUtils.bindReqToEntity(orderItem, request);
SaleOrderItem.selectrun(orderItem);

SaleOrder order = new SaleOrder();
SaleOrder.selectByID(orderItem.getOrder_id());

RDFormular formular = new RDFormular();
formular.setMat_code(orderItem.getItem_id());
RDFormular.select(formular);

String yeild = "0";
if(formular.getYield().length() > 0){
	yeild = formular.getYield();
}
System.out.print(yeild);
String f_volume = "0";
if(formular.getVolume().length() > 0){
	f_volume = formular.getVolume();
}

String volume = Money.multiple(f_volume,orderItem.getItem_qty());
yeild = Money.divide(Money.multiple(volume,"100"),yeild);

InventoryMaster mat = formular.getUIMat();

HashMap<String, MatTree> matMap = new HashMap<String, MatTree>();
HashMap<String, MatTree> pkMap = new HashMap<String, MatTree>();
List<MatTree> ssList = new ArrayList <MatTree>();

RDFormular.ObjectTree(yeild, formular, matMap, pkMap, ssList);


//SaleOrderItem
Iterator iteMap = matMap.keySet().iterator();
%>
<script type="text/javascript">
$(function(){
	
});
</script>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">ประเมินรายการขาย</div>
								<div class="right btn_box m_right15" onclick="history.back();">ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<div class="detail_wrap s900 center">
					<fieldset class="fset">
						<legend>รายละเอียดสินค้า</legend>
						<table class="s880">
							<tr>								
								<td width="150">ชื่อสินค้า</td>
								<td>: <%=mat.getDescription()%></td>
							</tr>
							<tr>
								<td>จำนวนคงคลัง</td>
								<td>: <%=mat.getBalance() + " " + mat.getDes_unit()%>
								</td>								
								<td>จำนวนที่มีการจอง</td>
								<td>: 
								<% String sum = SaleOrderItem.bookfg(mat.getMat_code(),"s");%>
								<%=(sum.equalsIgnoreCase("")?"0":sum) + " " + mat.getDes_unit()%></td>
							</tr>					
							<tr>
								<td>จำนวน</td>
								<td>: <%=orderItem.getItem_qty()%> <%=mat.getDes_unit()%>
								</td>
								<td>สินค้าที่ต้องผลิตทั้งหมด</td>
								<td>: <%=Money.money(volume) + " " + mat.getStd_unit()%>
								</td>
							</tr>
							<tr>
								<td>R&D Yield</td>
								<td>: <%=Money.money(yeild) + " " + mat.getStd_unit()%>
								</td>
								<td>วันที่ร้องขอ </td>
								<td>: <%=WebUtils.getDateValue(orderItem.getRequest_date())%>
								</td>
							</tr>
							<tr>
								<td>วันที่เริ่มผลิต </td>
								<td>: <%=WebUtils.getDateValue(orderItem.getStart_date())%>
								</td>
								<td>วันที่เสร็จ </td>
								<td>: <%=WebUtils.getDateValue(orderItem.getConfirm_date())%>
								</td>
							</tr>
							<tr>
								<td>สถานะ </td>
								<td class="txt_bold txt_red">: <%=SaleOrderItem.status(orderItem.getStatus())%>
								</td>
							</tr>	
						</table>
						
					</fieldset>
					<% if(!(orderItem.getStatus().equalsIgnoreCase(SaleOrderItem.STATUS_WAIT_PLAN_SUBMIT))){ %>
					<div class="center s300 txt_center m_top5">
							<button class="btn_box thickbox btn_confirm" lang="plan_edit_date.jsp?item_run=<%=orderItem.getItem_run()%>&width=500&height=200" title="แก้ไขวันที่">แก้ไข</button>
					</div>
					<% } %>
					<div class="dot_line m_top15"></div>
					
					<fieldset class="fset">
						<legend>จำนวนวัตถุดิบ</legend>
						<div class="clear"></div>
							
						<table class="bg-image s880">
							<thead>
								<tr>
									<th valign="top" align="center" width="13%">รหัส</th>
									<th valign="top" align="center" width="20%">ชื่อวัตถุดิบ</th>
									<th valign="top" align="center" width="9%">จำนวนที่ต้องใช้ (KG)</th>
									<th valign="top" align="center" width="12%">จำนวนคงคลัง (KG)</th>
									<th valign="top" align="center" width="12%">จำนวนที่จอง (KG)</th>
									<th valign="top" align="center" width="12%"></th>
								</tr>
							</thead>
							<tbody>
							<%
							while(iteMap.hasNext()){
								String mat_code = (String) iteMap.next();
								MatTree tree = matMap.get(mat_code);
								if(tree.getGroup_id().equalsIgnoreCase("MT")){
								%>
								<tr>
									<td align="center"><%=mat_code + "  (" + tree.getGroup_id() + ")"%></td>
									<td align="left"><%=tree.getDescription()%></td>
									<td align="right"><%=Money.money(tree.getRequest_qty())%></td>
									<td align="right"><%=Money.money(tree.getInv_qty())%></td>
									<td align="right"><%=Money.money(tree.getPlan_qty())%></td>
									<td align="center"></td>
									
								</tr>		
								<%
								}
							}
							Iterator<MatTree> ss = ssList.iterator();
							while (ss.hasNext()){
								MatTree ssmap = ss.next();
								%>
								<tr onclick="$('#tr_<%=ssmap.getMat_code()%>').slideToggle();" class="pointer">
									<td align="center"><%=ssmap.getMat_code() + "  (" + ssmap.getGroup_id()+ ")"%></td>
									<td align="left"><%=ssmap.getDescription()%></td>
									<td align="right"><%=Money.money(ssmap.getRequest_qty())%></td>
									<td align="right"><%=Money.money(ssmap.getInv_qty())%></td>
									<td align="right"><%=Money.money(ssmap.getPlan_qty())%></td>
									<td align="left"><img src="../images/arrow_down.jpg" height="20" width="20"></td>								
								</tr>
								<tr class="hide" id="tr_<%=ssmap.getMat_code()%>">	
									<td colspan="6">
										<fieldset class="fset">
											<legend><%=ssmap.getMat_code() + " - "+ssmap.getDescription()%></legend>
										
										<table>
										<thead>
											<tr>
												<th valign="top" align="center" width="13%">รหัส</th>
												<th valign="top" align="center" width="20%">ชื่อวัตถุดิบ</th>
												<th valign="top" align="center" width="9%">จำนวนที่ต้องใช้ (KG)</th>
												<th valign="top" align="center" width="12%">จำนวนคงคลัง (KG)</th>
												<th valign="top" align="center" width="12%">จำนวนที่จอง (KG)</th>
											</tr>
										</thead>
										<tbody>	
								<%
								Iterator<MatTree> mtINss = ssmap.getMat().iterator();
								while (mtINss.hasNext()){
									MatTree mt = mtINss.next();
									%>	
										
									<tr>
										<td align="center"><%=mt.getMat_code()+ "  (" + mt.getGroup_id()+ ")"%></td>
										<td align="left"><%=mt.getDescription() %></td>
										<td align="right"><%=Money.money(mt.getRequest_qty())%></td>
										<td align="right"><%=Money.money(mt.getInv_qty())%></td>
										<td align="right"><%=Money.money(mt.getPlan_qty())%></td>								
									</tr>						
									<%	
								}
								%>
									</tbody>
									</table>	
									</fieldset>
									</td>
								</tr>
								<%
							}
							%>
							</tbody>		
						</table>						
						
					</fieldset>
										
					
					<div class="dot_line m_top15"></div>
					
					<fieldset class="fset">
						<legend>จำนวนบรรจุภัณฑ์</legend>
						<div class="clear"></div>
					
							<table class="bg-image s880">
								<thead>
									<tr>
										<th valign="top" align="center" width="13%">รหัส</th>
										<th valign="top" align="center" width="20%">ชื่อวัตถุดิบ</th>
										<th valign="top" align="center" width="12%">จำนวนที่ต้องใช้</th>
										<th valign="top" align="center" width="12%">จำนวนคงคลัง</th>
										<th valign="top" align="center" width="12%">จำนวนที่จอง</th>
										<th valign="top" align="center" width="12%">บรรจุภัณฑ์</th>
									</tr>
								</thead>
								<tbody>
								<%
								Iterator itePk = pkMap.keySet().iterator();
								while(itePk.hasNext()){
									String mat_code = (String) itePk.next();
									MatTree tree = pkMap.get(mat_code);
									InventoryMaster master = new InventoryMaster();
									master = InventoryMaster.select(mat_code);
									
									%>
									<tr>
										<td align="center"><%=mat_code%></td>
										<td align="left"><%=tree.getDescription()%></td>
										<td align="right"><%=Money.multiple(tree.getOrder_qty(),orderItem.getItem_qty())%></td>
										<td align="right"><%=tree.getInv_qty()%></td>
										<td align="right"><%=tree.getPlan_qty()%></td>
										<td align="center"><%=master.getDes_unit()%></td>				
									</tr>		
								<%
								}
								%>
								</tbody>		
							</table>	
					</fieldset>
						<%
						
						if(orderItem.getStatus().equalsIgnoreCase(SaleOrderItem.STATUS_WAIT_PLAN_SUBMIT)){	
							%>
							<div class="center s300 txt_center m_top5">
							<button class="btn_box thickbox btn_confirm" lang="plan_confirm_date.jsp?order_id=<%=orderItem.getOrder_id()%>&item_id=<%=orderItem.getItem_id()%>&item_type=<%=orderItem.getItem_type()%>&item_run=<%=orderItem.getItem_run()%>&width=500&height=200" title="Confirm date">ส่งแผน</button>
							</div>
						<%
						}
						%>		
				</div>				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>