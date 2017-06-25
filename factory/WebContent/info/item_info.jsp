<%@page import="java.awt.event.ItemEvent"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%

String type = WebUtils.getReqString(request, "type");
String item_run = WebUtils.getReqString(request, "item_run");
String item_id = WebUtils.getReqString(request, "item_id");
InventoryMaster invMaster = InventoryMaster.select(item_id);

SaleOrderItem item = new SaleOrderItem();
item =	SaleOrderItem.selectOrder(item_run);
%>
			<div class="content_body">	
				<% if(type.equalsIgnoreCase("s")){ 
				
				%>
				
				<fieldset class="s450 left fset">
					<legend>ข้อมูลสินค้า</legend>
					<table width="100%">
						<tbody>
							<tr>
								<td>รหัสสินค้า</td>
								<td>: <%=item_id%></td>
							</tr>
							<tr>
								<td>ชื่อสินค้า</td>
								<td>: <%=invMaster.getDescription()%></td>
							</tr>
							<tr>
								<td>จำนวน</td>
								<td>: <%=item.getItem_qty()+ " " + invMaster.getDes_unit()%></td>
							</tr>
							<tr>
								<td class="s150">หมายเหตุของ sale</td>
								<td>: <%=item.getRemark()%></td>
							</tr>
							<tr>
								<td class="s150">หมายเหตุของ planning</td>
								<td>: <%=item.getRmk_plan()%></td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				<div class="clear"></div>
				<%}else{ 
				%>
				<fieldset class="s450 left fset">
					<legend>ข้อมูลสินค้า</legend>
					<table width="100%">
						<tbody>
							<tr>
								<td colspan="2"> 
							<% 
							HashMap<String, PackageItem> map = PackageItem.SumItem(item_id);
							Iterator itePK = map.keySet().iterator();
							while (itePK.hasNext()){
								PackageItem items = map.get((String)itePK.next()) ;
							%>
							
								<div><%="- " +items.getUIMat().getMat_code() + "-" + items.getUIMat().getDescription()+ " จำนวน " + items.getQty() + " " + items.getUIMat().getDes_unit() %></div>
								
							
							<% } %>
								</td>
							</tr> 
							<tr>
								<td class="s150">หมายเหตุของ sale</td>
								<td>: <%=item.getRemark()%></td>
							</tr>
							<tr>
								<td class="s150">หมายเหตุของ planning</td>
								<td>: <%=item.getRmk_plan()%></td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				<%} %>
			</div>