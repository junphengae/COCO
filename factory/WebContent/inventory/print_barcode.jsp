<%@page import="com.bitmap.barcode.Barcode128"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%	
	String mat_code = WebUtils.getReqString(request, "mat_code");
	String lot_no = WebUtils.getReqString(request, "lot_no");
	InventoryMaster master = InventoryMaster.select(mat_code);
%>

<link type="text/css" rel="stylesheet" href="../css/barcode.css">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รหัสสินค้า <%=mat_code%> | Lot เลขที่ <%=lot_no%></title>
<script type="text/javascript">
function setPrint(){
	setTimeout('window.print()',1500); setTimeout('window.close()',2000);
}
</script>
</head>
<body onload="setPrint();">
	<%
		Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_barcode"), master.getMat_code(), master.getMat_code(), 2);
		Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_barcode"), lot_no);
	%>
	<div class="barcode">
		<div class="discription"><%=(master.getDescription().length() >= 45)?master.getDescription().substring(0,45) + "...":master.getDescription()%></div>
		
		<div style="font-size: 10px; margin: 0 auto; margin-top: 1px; text-align: center;">
			<div style="float: left; margin-left: 7px;">code : </div><div style="float: left; margin-left: 5px;"><img src="../path_images/barcode/<%=master.getMat_code()%>.png"></div><div style="clear: both;"></div>
		</div>
		
		<div style="font-size: 10px; margin: 0 auto; margin-top: 1px; text-align: center;">
			<div style="float: left; margin-left: 7px;">lot no.</div><div style="float: left; margin-left: 5px;"><img src="../path_images/barcode/<%=lot_no%>.png"></div><div style="clear: both;"></div>
		</div>
		<!--  
		<div style="float: left; font-size: 10px; margin-left: 7px; text-align: left; margin-top: -5px;">(<%=master.getRef_code()%>)</div>
		<div style="float: right; font-size: 8px; margin-right: 5px; text-align: right; margin-top: -3px;">V.Brother Industry</div>
		<div style="clear: both;"></div>-->
	</div>

</body>
</html>