
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="java.awt.event.ItemEvent"%>
<%@page import="com.bitmap.dbconnection.mysql.vbi.DBPool"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.rd.MatTree"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.bean.rd.RDFormularDetail"%>
<%@page import="com.bitmap.bean.rd.RDFormularStep"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
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
<script src="../js/popup.js" type="text/javascript"></script>

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
<jsp:useBean id="MAT_SEARCH" class="com.bitmap.bean.inventory.MaterialSearch" scope="session"></jsp:useBean>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการสินค้าสั่งผลิต</title>
<%
Package pk = new Package();
WebUtils.bindReqToEntity(pk, request);
Package.select(pk);

SaleOrderItem orderItem = new SaleOrderItem();
WebUtils.bindReqToEntity(orderItem, request);
SaleOrderItem.select(orderItem);

int count = 0;
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">1. รายการสินค้าสั่งผลิต | 2. วัตถุดิบที่ใช้ในการผลิต</div>
				<div class="right btn_box m_right15" onclick="window.location='plan_sale_ap.jsp'">ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<div class="detail_wrap s900 center">
					<fieldset class="fset">
						<legend>รายละเอียดสินค้า</legend>
						<table class="s880">
							<tr>								
								<td width="200">ชื่อสินค้า</td>
								<td>: 
									<%=pk.getName()%> 
								</td>
							</tr>					
							<tr>
								<td>จำนวนชุด</td>
								<td>: <%=orderItem.getItem_qty()%> ชุด
								</td>
							</tr>
							<tr>
								<td>วันที่ร้องขอ </td>
								<td>: <%=WebUtils.getDateValue(orderItem.getRequest_date())%>
								</td>
							</tr>
						</table>
						<div class="dot_line m_top15"></div>
						
						<div class="left s200">สินค้าที่ต้องผลิตทั้งหมด : </div>
						<div class="left s650">
						<%
						HashMap<String, PackageItem> map = PackageItem.SumItem(pk.getPk_id());
						Iterator itePK = map.keySet().iterator();
						while (itePK.hasNext()){
							PackageItem item = map.get((String)itePK.next()) ;
						%>
						<div class="left s300"><%=item.getUIMat().getDescription() %></div> 
						<div class="left">จำนวน : <%=item.getQty()+ " " + item.getUIMat().getDes_unit()%></div>
						<div class="right">จำนวนคงคลัง : <%=item.getUIMat().getBalance() + " " + item.getUIMat().getDes_unit()%></div>
						<div class="clear"></div>
						<%
						}
						%>
						</div>
					
						<div class="left s60">สถานะ : </div>
						<div class="left txt_bold txt_red"><%=SaleOrderItem.status(orderItem.getStatus())%></div>
						<div class="clear"></div>

					</fieldset>
					
					<%
					
					itePK = map.keySet().iterator();
					while (itePK.hasNext()){
						PackageItem item = map.get((String)itePK.next()) ;
						InventoryMaster mat = item.getUIMat();
						
						RDFormular formular = new RDFormular();
						formular.setMat_code(item.getMat_code());
						RDFormular.select(formular);
						
						List list = PackageItem.getOnePac(pk.getPk_id(), item.getMat_code());
						Iterator itesum = list.iterator();
						String volume = "";
						while(itesum.hasNext()){
							PackageItem oo = (PackageItem) itesum.next();
							volume = oo.getUISumQty();
						}
						
						String yei_val = "1";
						if(formular.getYield().length() > 0){
							yei_val = formular.getYield();
						}
						String all_volume = Money.multiple(volume,(formular.getVolume().length() > 0)?formular.getVolume():"1");
						String yeild_volume = Money.divide(Money.multiple(all_volume,"100"),yei_val);
													
						HashMap<String, MatTree> matMap = new HashMap<String, MatTree>();
						HashMap<String, MatTree> pkMap = new HashMap<String, MatTree>();
						List<MatTree> ssList = new ArrayList <MatTree>();

						RDFormular.ObjectTree(yeild_volume, formular, matMap, pkMap, ssList);
									
						Iterator iteMap = matMap.keySet().iterator();
						Iterator itePk = pkMap.keySet().iterator();
					%>
					
					<div class="dot_line m_top15"></div>
					
					<div class="box txt_bold">
					<%=item.getUIMat().getDescription()%> จำนวน <%=volume %> <%=mat.getDes_unit()%> : <%=Money.money(Money.multiple(volume,(formular.getVolume().length() > 0)?formular.getVolume():"0"))+" "+ mat.getStd_unit() %>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;R&D Yield : 
					<%=Money.money(yeild_volume) + " " + mat.getStd_unit()%>
					
					<%
					if(ssList.size() == 0){

						boolean count1 = Production.selectSS(orderItem.getItem_run(),item.getMat_code(),item.getPk_id());
						if(count1 == false){
						%>
						<div class="right"><button class="btn_box btn_confirm thickbox" lang="plan_produce.jsp?width=500&height=200&parent_id=<%=item.getPk_id()%>&item_id=<%=item.getMat_code()%>&item_run=<%=orderItem.getItem_run()%>&item_type=FG&item_qty=<%=Money.money(Money.multiple(volume,(formular.getVolume().length() > 0)?formular.getVolume():"0"))%>" title="เลือก">เลือก</button></div>
						<%
						}
					}else{

						String count1 = Production.checkItemPro(orderItem.getItem_run(),"SS",mat.getMat_code());
						int i = Integer.parseInt(count1);
						if(i == ssList.size()){
							
							boolean count2 = Production.selectSS(orderItem.getItem_run(),item.getMat_code(),item.getPk_id());
							if(count2 == false){
							%>
							<div class="right"><button class="btn_box btn_confirm thickbox" lang="plan_produce.jsp?width=500&height=200&parent_id=<%=item.getPk_id()%>&item_id=<%=item.getMat_code()%>&item_run=<%=orderItem.getItem_run()%>&item_type=FG&item_qty=<%=Money.money(Money.multiple(volume,(formular.getVolume().length() > 0)?formular.getVolume():"0"))%>" title="เลือก">เลือก</button></div>
							<%
							}
						}
					}
					
					%>
					</div>
					
					<fieldset class="fset">
						<legend><%=ssList.size()%>จำนวนวัตถุดิบ </legend>
						<div class="clear"></div>
						
						<table class="bg-image s880">
							<thead>
								<tr>
									<th valign="top" align="center" width="120">รหัส</th>
									<th valign="top" align="center" width="300">ชื่อวัตถุดิบ</th>
									<th valign="top" align="center" width="">จำนวนที่ต้องใช้</th>
									<th valign="top" align="center" width="">จำนวนคงคลัง</th>
									<th valign="top" align="center" width="12%">จำนวนที่จอง</th>
									<th valign="top" align="center" width=""></th>
								</tr>
							</thead>
							<tbody>
							<%
							while(iteMap.hasNext()){
								String mat_code = (String) iteMap.next();
								MatTree tree = matMap.get(mat_code);
								%>
								<tr>
									<td align="center"><%=mat_code + "  (" + tree.getGroup_id()+ ")"%></td>
									<td align="left"><%=tree.getDescription()%></td>
									<td align="right"><%=Money.money(tree.getRequest_qty())%></td>
									<td align="right"><%=tree.getInv_qty()%></td>
									<td align="right"><%=Money.money(tree.getPlan_qty())%></td>
									<td align="center"></td>
									
								</tr>		
							<%
							}
							Iterator<MatTree> ss = ssList.iterator();
							while (ss.hasNext()){
								MatTree ssmap = ss.next();
								%>
								<tr onclick="$('#tr_<%=ssmap.getMat_code()%>').slideToggle();" class="pointer">
									<td align="center"><%=ssmap.getMat_code() + "  (" + ssmap.getGroup_id()+ ")"%></td>
									<td align="left"><%=ssmap.getDescription()%></td>
									<td align="right"><%=Money.money(ssmap.getRequest_qty())%></td>
									<td align="right"><%=ssmap.getInv_qty()%></td>
									<td align="right"><%=Money.money(ssmap.getPlan_qty())%></td>
									<td align="left"><img src="../images/arrow_down.jpg" height="20" width="20">
									<%
									boolean check = Production.selectSS(orderItem.getItem_run(),ssmap.getMat_code(),item.getMat_code());
									if(check == false){
										%>
										<button class="btn_confirm btn_box thickbox" lang="plan_produce.jsp?width=500&height=200&item_id=<%=ssmap.getMat_code()%>&item_run=<%=orderItem.getItem_run()%>&item_qty=<%=Money.money(ssmap.getRequest_qty())%>&item_type=SS&parent_id=<%=mat.getMat_code()%>" title="เลือก">เลือก</button>
										<%
									}
									%>
									</td>								
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
												<th valign="top" align="center" width="9%">จำนวนที่ต้องใช้</th>
												<th valign="top" align="center" width="12%">จำนวนคงคลัง</th>
												<th valign="top" align="center" width="12%">จำนวนที่จอง</th>
												<th valign="top" align="center" width="12%"></th>
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
										<td align="left"><%=mt.getDescription()%></td>
										<td align="right"><%=Money.money(mt.getRequest_qty())%></td>
										<td align="right"><%=mt.getInv_qty()%></td>
										<td align="right"><%=Money.money(mt.getPlan_qty())%></td>	
										<td align="center">
											<%
											if(mt.getGroup_id().equalsIgnoreCase("SS")){
											count++;
											boolean checkInSS = Production.selectSS(orderItem.getItem_run(),mt.getMat_code(),ssmap.getMat_code());
												if(checkInSS == false){
													%>
														<button class="btn_confirm btn_box thickbox" lang="plan_produce.jsp?width=500&height=200&parent_id=<%=ssmap.getMat_code()%>&item_id=<%=mt.getMat_code()%>&item_run=<%=orderItem.getItem_run()%>&item_qty=<%=Money.money(mt.getRequest_qty())%>&item_type=SS" title="เลือก">เลือก</button>
													<%
												}
											}					
											%>
										</td>								
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
					
					<fieldset class="fset">
						<legend>จำนวนบรรจุภัณฑ์ </legend>
						
						<div class="clear"></div>
						
						<table class="bg-image s880">
							<thead>
								<tr>
									<th valign="top" align="center" width="120">รหัส</th>
									<th valign="top" align="center" width="300">ชื่อบรรจุภัณฑ์</th>
									<th valign="top" align="center" width="">จำนวนที่ต้องใช้</th>
									<th valign="top" align="center" width="">จำนวนคงคลัง</th>
									<th valign="top" align="center" width="12%">จำนวนที่จอง</th>
									<th valign="top" align="center" width="12%">บรรจุภัณฑ์</th>									
								</tr>
							</thead>
							<tbody>
							<%
							while(itePk.hasNext()){
								String mat_code = (String) itePk.next();
								MatTree tree = pkMap.get(mat_code);
								InventoryMaster master = new InventoryMaster();
								master = InventoryMaster.select(mat_code);
								%>
								<tr>
									<td align="center"><%=mat_code+ "  (" + tree.getGroup_id()+ ")"%></td>
									<td align="left"><%=tree.getDescription()%></td>
									<td align="right"><%=Money.multiple(tree.getOrder_qty(),volume)%></td>
									<td align="right"><%=tree.getInv_qty()%></td>
									<td align="right"><%=tree.getPlan_qty()%></td>		
									<td align="center"><%=master.getStd_unit()%></td>							
								</tr>		
							<%
							}
							
							
							%>
							</tbody>		
						</table>						
						
					</fieldset>
					
					<%
					count++;
					} 
					%>

					<div class="center s300 txt_center m_top5">
						<%
						
							boolean ck_fg = Production.checkItemtype(orderItem.getItem_run(),count,"FG");
							if(ck_fg == true){
								boolean ck_pro = Production.checkItemtype(orderItem.getItem_run(),1,"PRO");
								if(ck_pro == false){
							%>		
							<div class="txt_center"><button class="btn_box btn_confirm thickbox" lang="plan_produce_pro.jsp?width=500&height=200&item_id=<%=pk.getPk_id()%>&item_run=<%=orderItem.getItem_run()%>&item_qty=<%=orderItem.getItem_qty()%>&item_type=PRO" title="เลือก">ส่งฝ่ายผลิต</button></div>
							<%
								}
							}
						
						%>
					</div>
				</div>			
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>