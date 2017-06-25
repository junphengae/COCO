<%@page import="com.bitmap.bean.inventory.SubCategories"%>
<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<%
String mat_code = WebUtils.getReqString(request, "mat_code");
InventoryMaster invMaster = InventoryMaster.select(mat_code);
session.setAttribute("MAT", invMaster);
%>
				<fieldset class="s400 left fset">
					<legend>ข้อมูลสินค้า</legend>
					<table width="100%">
						<tbody>
							<tr>
								<td width="40%">กลุ่ม</td>
								<td width="60%">: <%=invMaster.getUISubCat().getUICat().getUIGroup().getGroup_name_th()%></td>
							</tr>
							<tr>
								<td>ชนิด</td>
								<td>: <%=invMaster.getUISubCat().getUICat().getCat_name_th()%></td>
							</tr>
							<tr>
								<td>ชนิดย่อย</td>
								<td>: <%=invMaster.getUISubCat().getSub_cat_name_th()%></td>
							</tr>
							<tr><td colspan="2" height="20"></td></tr>
							<tr>
								<td>รหัสสินค้า</td>
								<td>: <%=mat_code%></td>
							</tr>
							<tr>
								<td>ชื่อสินค้า</td>
								<td>: <%=invMaster.getDescription()%></td>
							</tr>
							<%if(invMaster.getGroup_id().equalsIgnoreCase("FG")){ %>
							<tr>
								<td>ชื่อยี่ห้อ</td>
								<td>: <%=invMaster.getBrand_name()%></td>
							</tr>
							<%} %>
							<tr>
								<td>ลักษณะการจัดเก็บ</td>
								<td>: <%=(invMaster.getFifo_flag().equalsIgnoreCase("y"))?"FIFO":"Non FIFO"%></td>
							</tr>
							<tr>
								<td>รหัสเดิม</td>
								<td>: <%=invMaster.getRef_code()%></td>
							</tr>
							<tr>
								<td>ราคากลาง</td>
								<td>: <%=invMaster.getPrice()%></td>
							</tr>
							<tr>
								<td>ต้นทุน</td>
								<td>: <%=invMaster.getCost()%></td>
							</tr>
							<tr>
								<td>หน่วยนับ</td>
								<td>: <%=invMaster.getStd_unit()%></td>
							</tr>
							<tr>
								<td>ลักษณะบรรจุภัณฑ์</td>
								<td>: <%=invMaster.getDes_unit()%></td>
							</tr>
							<tr>
								<td>ปริมาตร/บรรจุภัณฑ์</td>
								<td>: <%=invMaster.getUnit_pack()%> <%=invMaster.getStd_unit()%>/<%=invMaster.getDes_unit()%></td>
							</tr>
							<tr>
								<td>สถานที่เก็บ</td>
								<td>: <%=invMaster.getLocation()%></td>
							</tr>
							<tr>
								<td>จำนวนต่ำสุดที่ต้องสั่งเพิ่ม</td>
								<td>: <%=invMaster.getMor()%></td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				
				<fieldset class="right fset" style="width: 330px;">
					<legend>รูปสินค้า</legend>
					
					<div id="div_img" class="center txt_center" style="width: 320px; height: 240px;">
						<img width="320" height="240" src="../path_images/inventory/<%=mat_code%>.jpg?state=<%=Math.random()%>">
					</div>
					
					<div class="clear"></div>
				</fieldset>
				
				<div class="clear"></div>
				
				<div class="center txt_center m_top10">
					<button class="btn_box" onclick="tb_remove();">ปิด</button>
				</div>
				
				