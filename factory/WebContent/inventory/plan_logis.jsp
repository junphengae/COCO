<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.bean.sale.Detailinv"%>
<%@page import="com.bitmap.bean.logistic.LogisSend"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.Province"%>
<%@page import="com.bitmap.bean.logistic.Busstation"%>
<%@page import="com.bitmap.bean.logistic.SendProduct"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.webutils.customtag.ComboBoxTag"%>
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
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<script src="../js/number.js"></script>

<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการจัดสินค้า</title>
<%
String inv = WebUtils.getReqString(request, "inv");
String type_inv = WebUtils.getReqString(request, "type_inv");
String send_date = WebUtils.getReqString(request, "send_date");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"inv",inv});
paramList.add(new String[]{"type_inv",type_inv});
paramList.add(new String[]{"send_date",send_date});
session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = LogisSend.selectWithCTRLForInv(ctrl, paramList).iterator();
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการจัดสินค้า</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s800 center txt_center">
						<form style="margin: 0; padding: 0;" action="plan_logis.jsp" id="search" method="get">
							หมายเลขอ้างอิง:<input type="text" class="txt_box" name="inv" value="<%=inv%>">
							ประเภท: 
							<bmp:ComboBox name="type_inv" styleClass="txt_box s150" value="<%=type_inv%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
								<bmp:option value="20" text="ออกเป็นใบ invoice"></bmp:option>
								<bmp:option value="10" text="ใบส่งของชั่วคราว"></bmp:option>
							</bmp:ComboBox>
							วันจัดส่ง:<input type="text" class="txt_box" id="send_date" name="send_date" value="<%=send_date%>">
							<br><br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
						</form>
					</div>
					
					<div class="dot_line m_top5"></div>
					<div class="clear"></div>
					
					<!-- next page -->  
					<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"plan_logis.jsp",paramList)%></div>
					<div class="clear"></div>
					<!-- next page  -->
					
					<table class="bg-image s_auto">
						<thead>
							<tr>
								<th valign="top" align="center" width="5%">No.</th>
								<th valign="top" align="center" width="10%">ประเภท</th>
								<th valign="top" align="center" width="25%">ลูกค้า</th>
								<th valign="top" align="center" width="25%">สินค้า</th>
								<th valign="top" align="center" width="5%">จำนวน</th>
								<th valign="top" align="center" width="5%">เบิกไปแล้ว</th>
								<th valign="top" align="center" width="10%">หน่วยนับ</th>
								<th valign="top" align="center" width="10%">วันจัดส่ง</th>
								<th width="5%"></th>
							</tr>
						</thead>
						<tbody>
						<%
						boolean has = true;
						while (ite.hasNext()){
							has = false;
							LogisSend entity = (LogisSend) ite.next();
	
						%>
						<tr>
							<td valign="top" align="center"><%=entity.getInv()%></td>
							<td valign="top" align="center"><%=LogisSend.statusInv(entity.getType_inv())%></td>
							<td align="left"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=entity.getUIorder().getUICustomer().getCus_id()%>&height=400&width=520"><%=entity.getUIorder().getUICustomer().getCus_name()%></div></td>
							<td valign="top" align="left"><div class="thickbox pointer" title="สินค้า: <%=entity.getUImaster().getDescription()%>" lang="../info/inv_master_info.jsp?mat_code=<%=entity.getUImaster().getMat_code()%>&width=850&height=450"><%=entity.getUImaster().getDescription()%></div></td>
							<td align="right"><%=entity.getQty()%></td>
							<td align="right"><%=InventoryLotControl.sumTakelot(entity.getId_run())%></td>
							<td align="center"><%=entity.getUImaster().getDes_unit()%></td>
							<td><%=WebUtils.getDateValue(entity.getSend_date())%></td>
							<td>
								 <%if(entity.getStatus().equalsIgnoreCase(LogisSend.STATUS_WAIT) ||entity.getStatus().equalsIgnoreCase(LogisSend.STATUS_RESEND) || entity.getStatus().equalsIgnoreCase(LogisSend.STATUS_PREPARE)){%>
									<button class="btn_box btn_confirm thickbox" title="เบิกสินค้า" lang="plan_logis_outlet.jsp?width=980&height=550&id_run=<%=entity.getId_run()%>">เบิกของ</button>
								<%} else {%>
									เบิกแล้ว
								<%}%> 
							</td>	
						</tr>
						<%
						}
						if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการจัดสินค้า ---- </td></tr>
						<%	
						}
						%>
						</tbody>
					</table>
				</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
<script type="text/javascript">
	$('#send_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
</script>
</body>
</html>