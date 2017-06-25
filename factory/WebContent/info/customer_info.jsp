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
	String cus_id = request.getParameter("cus_id"); 
	Customer entity = new Customer();
	entity.setCus_id(cus_id);
	entity = Customer.select(entity);
	Province pro = entity.getUIPro();
	Zipcode zip = entity.getUIZip();
	
	Personal per =  Personal.selectOnlyPerson(entity.getCus_tax());
%>
<div>
	
	<input type="hidden" name="update_by" id="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<input type="hidden" name="cus_id" id="cus_id" value="<%=entity.getCus_id() %>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>ข้อมูลลูกค้า</h3></td></tr>
			<tr>
				<td align="left" width="25%"><label>ชื่อลูกค้า</label></td>
				<td align="left" width="75%">: <%=entity.getCus_name()%></td>
			</tr>
			<tr>
				<td><label>ชื่อพนักงานขาย</label></td>
				<td>: <%=per.getName()+ " " + per.getSurname() %></td>
			</tr>
			<tr>
				<td><label>โทรศัพท์</label></td>
				<td>: <%=entity.getCus_phone()%></td>
			</tr>
			<tr>
				<td><label>แฟกซ์</label></td>
				<td>: <%=entity.getCus_fax()%></td>
			</tr>
			<tr>
				<td><label>ที่อยู่</label></td>
				<td>: <%=entity.getCus_address()%></td>
			</tr>
			<tr>
				<td><label>จังหวัด</label></td>
				<td>: <%=pro.getProvince_th_name()%></td>
			</tr>
			<tr>
				<td><label>รหัสไปรษณีย์</label></td>
				<td>: <%=zip.getZip_th_name()%></td>
			</tr>
			<tr>
				<td><label>ประเทศ</label></td>
				<td>: <%=entity.getCus_country()%></td>
			</tr>
			<tr>
				<td valign="top"><label>Email</label></td>
				<td valign="top">: <%=entity.getCus_email()%></td>
			</tr>
			<tr>
				<td><label>ผู้ติดต่อ</label></td>
				<td>: <%=entity.getCus_contact()%></td>
			</tr>
			<tr>
				<td><label>เงื่อนไขการจัดส่ง</label></td>
				<td>: <%=entity.getCus_condition()%></td>
			</tr>
			<tr>
				<td><label>เครดิต</label></td>
				<td>: <%=entity.getCus_credit()%></td>
			</tr>
			<tr>
				<td><label>ส่วนลด</label></td>
				<td>: <%=entity.getCus_discount()%> %</td>
			</tr>
			<tr>
				<td><label>ส่งโดย</label></td>
				<td>: <%=entity.getSend_by()%></td>
			</tr>
			<tr>
				<td><label>ประเภทการขนส่ง</label></td>
				<td>: <%=Customer.ship(entity.getCus_ship())%></td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="reset" onclick="tb_remove();" value="ปิด" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	

</div>