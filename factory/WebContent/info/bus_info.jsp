<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.logistic.Busstation"%>
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
	String qid = WebUtils.getReqString(request, "qid"); 
	Busstation entity = new Busstation();
	entity = Busstation.selectByQid(qid);
%>
<div>
	
	<input type="hidden" name="update_by" id="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	<input type="hidden" name="qid" id="cus_id" value="<%=qid%>">
	<table cellpadding="3" cellspacing="3" border="0" style="margin: 0 auto;" width="485px">
		<tbody>
			<tr align="center" height="25"><td colspan="2"><h3>ข้อมูลรถ</h3></td></tr>
			<tr>
				<td align="left" width="25%"><label>ชื่อบริษัท</label></td>
				<td align="left" width="75%">: <%=entity.getCompany()%></td>
			</tr>
			<tr>
				<td><label>ชื่อคนขับ</label></td>
				<td>: <%=entity.getDriver()%></td>
			</tr>
			<tr>
				<td><label>หมายเลขทะเบียนรถ</label></td>
				<td>: <%=entity.getPlate()%></td>
			</tr>
			<tr align="center" valign="bottom" height="30">
				<td colspan="2">
					<input type="reset" onclick="tb_remove();" value="ปิด" class="btn_box">
				</td>
			</tr>
		</tbody>
	</table>
	

</div>