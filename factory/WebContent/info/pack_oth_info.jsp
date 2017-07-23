<%@page import="com.coco.inv.pack.InvPackTS"%>
<%@page import="com.coco.inv.pack.InvPackBean"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.sale.Zipcode"%>
<%@page import="com.bitmap.bean.sale.Province"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.inventory.Vendor"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<%
	String mat_code = request.getParameter("mat_code"); 
	String pack_id = request.getParameter("pack_id"); 
	
	InvPackBean entity = new InvPackBean();
	entity.setMat_code(mat_code);
	entity.setPack_id(pack_id);
	
	entity = InvPackTS.select(entity);
	
%>
<div>
	
	<input type="hidden" name="update_by" id="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">	
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>เพิ่มข้อมูลหน่วยนับอื่นๆ</h3></td></tr>
			<tr>
				<td align="left" width="25%"><label>รหัสสินค้า</label></td>
				<td align="left" width="75%">: <%=entity.getMat_code()%></td>
			</tr>			
			<tr>
				<td><label>Description</label></td>
				<td>: <%=entity.getDescription()%></td>
			</tr>
			<tr>
				<td><label>หน่วยนับอื่น</label></td>
				<td>: <%=entity.getOther_unit()%></td>
			</tr>
			<tr>
				<td><label>Factor</label></td>
				<td>: <%=entity.getFactor()%></td>
			</tr>
			<tr>
				<td><label>หน่วยนับหลัก</label></td>
				<td>: <%=entity.getMain_unit()%></td>
			</tr>
			<tr>
				<td><label>หน่วยนับ</label></td>
				<td>: <%=entity.getStd_unit()%></td>
			</tr>
			<tr>
				<td><label>ลักษณะบรรจุภัณฑ์</label></td>
				<td>: <%=entity.getDes_unit()%></td>
			</tr>
			<tr>
				<td><label>ปริมาณ/บรรจุภัณฑ์</label></td>
				<td>: <%=entity.getUnit_pack()%></td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="reset" onclick="tb_remove();" value="ปิด" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	

</div>