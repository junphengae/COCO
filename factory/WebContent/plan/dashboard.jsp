<%@page import="com.bitmap.bean.logistic.LogisSend"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.rd.MatTree"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/jquery.metadata.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/table.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>


</head>
<body>
<%
HashMap<String, MatTree> mapOrder = SaleOrder.sumStatus();
HashMap<String, MatTree> mapPlan = SaleOrderItem.sumStatus("plan_sale");
HashMap<String, MatTree> mapQt = SaleOrderItem.sumStatus("qt");
HashMap<String, MatTree> mapAp = SaleOrderItem.sumStatus("plan_ap");
HashMap<String, MatTree> mapPD = Production.sumStatus();
HashMap<String, MatTree> mapINV = SaleOrderItem.sumStatus("item_inv");
HashMap<String, MatTree> mapSEND = LogisSend.sumStatus();


%>
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_body">	
				<div class="left">ประเมินรายการขาย</div>
				<div class="clear"></div>
					<%
					Iterator itePK = mapPlan.keySet().iterator();
					while (itePK.hasNext()){
						MatTree mat = mapPlan.get((String)itePK.next()) ;
					%>
					<div class="left m_left50 s300">- <%=mat.getGroup_id()%></div>
					<div class="left s100"><%=mat.getDescription()%></div>
					<div class="left s100">รายการ</div>
					<div class="clear"></div>
					<% } %>		
				<div class="dot_line m_top10"></div>	
					
				<div class="left">อนุมัติการผลิต</div>
				<div class="clear"></div>
					<%
					itePK = mapAp.keySet().iterator();
					while (itePK.hasNext()){
						MatTree mat = mapAp.get((String)itePK.next()) ;
					%>
					<div class="left m_left50 s300">- <%=mat.getGroup_id()%></div>
					<div class="left s100"><%=mat.getDescription()%></div>
					<div class="left s100">รายการ</div>
					<div class="clear"></div>
					<% } %>			
				<div class="dot_line m_top10"></div>	
				<div class="left">รายการโปรดักชั่น</div>
				<div class="clear"></div>
					<%
					itePK = mapPD.keySet().iterator();
					while (itePK.hasNext()){
						MatTree mat = mapPD.get((String)itePK.next()) ;
					%>
					<div class="left m_left50 s300">- <%=mat.getGroup_id()%></div>
					<div class="left s100"><%=mat.getDescription()%></div>
					<div class="left s100">รายการ</div>
					<div class="clear"></div>
					<% } %>		
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>

</body>
</html>