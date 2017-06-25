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
<script src="../js/number.js" type="text/javascript"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Staging info</title>

<%
	String stg_id = WebUtils.getReqString(request, "stg_id");
%>
</head>
<body>

	<div class="wrap_all">
		<jsp:include page="../index/header.jsp"></jsp:include>

		<div class="wrap_body">
			<div class="body_content">
				<div class="content_head">
					<div class="left">รายการ Staging</div>
					<div class="right btn_box m_right15" onclick='history.back();'>ย้อนกลับ</div>
					<div class="clear"></div>
				</div>

				<div class="content_body">
					<form id="sale_order_info" onsubmit="return false;">
						<table width="100%" cellpadding="2" cellspacing="2">
							<tbody>
								<tr>
									<td width="130" class="txt_bold">เลข staging :
									<td>
									<td width="370">112111</td>
									<td width="130">วันที่สรา้าง :</td>
									<td width="370" class="txt_bold ">22254</td>
									<td width="130">สถานะ :</td>
									<td width="370" class="txt_bold ">xxx</td>
								</tr>

								<tr>
									<td colspan="4" height="15"></td>
								</tr>
							</tbody>
						</table>

						<div class="dot_line m_top10"></div>
						<fieldset class="fset">
							<legend>รายการโปรดักชั่น</legend>
							<table class="bg-image s900">
								<thead>
									<tr>
										<th valign="top" align="center" width="10%">เลขที่การผลิต</th>
										<th valign="top" align="center" width="30%">รายการสินค้า</th>
										<th valign="top" align="center" width="10%">จำนวน</th>
									</tr>
								</thead>
								<tbody>

									<tr>
										<td valign="top" align="center">pd_1111</td>
										<td valign="top" align="left">xxxxx</td>
										<td valign="top" align="center">10</td>
									</tr>
								</tbody>
							</table>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
		<jsp:include page="../index/footer.jsp"></jsp:include>
	</div>

</body>
</html>