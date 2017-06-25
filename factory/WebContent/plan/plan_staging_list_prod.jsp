<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Select production</title>
<%

String stg_no = WebUtils.getReqString(request, "stg_no");
String pro_id = WebUtils.getReqString(request, "pro_id"); 
String status = Production.STATUS_PRODUCE; 
String item_type = WebUtils.getReqString(request, "item_type"); 
String create_date = WebUtils.getReqString(request, "create_date"); 
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();

paramList.add(new String[]{"pro_id",pro_id});
paramList.add(new String[]{"status",status});
paramList.add(new String[]{"item_type",item_type});
paramList.add(new String[]{"create_date",create_date});

session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(20);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = Production.selectWithCTRL(ctrl, paramList).iterator();
%>
<script type="text/javascript">
$(
function(){
	setTimeout(function(){
		window.location.reload();
	}, 60000);
	$('#create_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
	
	$(".btn_select").click(function () {
			ajax_load();
			$.post('../ProductionServlet',{action:'update_production_to_staging',stg_no:<%=stg_no%>,pro_id:$(this).attr("pro_id"),update_by:$("#update_by").val()}, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.opener.location.reload(true);
					location.reload(); 
				} else {
					alert(resData.message);
				}
		    },'json');
		}
	);
	
	
});


</script>
</head>
<body>
<div class="wrap_all">
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">เลือกรายการโปรดักชั่น</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="detail_wrap s600 left">
						<form style="margin: 0; padding: 0;" action="plan_staging_list_prod.jsp" id="search" method="get">
							<input type="hidden" class="txt_box" name="stg_no" id="stg_no" value="<%=stg_no%>">
							เลขที่ โปรดักชั่น : <input type="text" class="txt_box" name="pro_id" id="pro_id" value="<%=pro_id%>"></input>	
							สถานะ: 
							<bmp:ComboBox name="status" listData="<%=Production.statusDropdown2() %>" styleClass="txt_box s150" value="<%=status%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
							</bmp:ComboBox>
							
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
						</form>
					</div>
					<!-- next page -->  
					<div class="right txt_right"><%=PageControl.navigator_en(ctrl,"plan_list_report.jsp",paramList)%></div>
					<div class="clear"></div>
					<!-- next page  -->
					
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="8%">เลขที่โปรดักชั่น</th>
								<th valign="top" align="center" width="8%">วันที่สร้าง</th>
								<th valign="top" align="center" width="25%">รายการ</th>
								<th valign="top" align="center" width="10%">จำนวน</th>		
								<th valign="top" align="center" width="13%">สถานะ</th>
								<th align="center" width="7%"></th>
							</tr>
						</thead>
						<tbody>
						<%
							
							boolean has = true;
							while(ite.hasNext()) {
								Production entity = (Production) ite.next();
								InventoryMaster mat = entity.getUIMat();
								Package pac = entity.getUIPac();
								SaleOrderItem order = entity.getUIorder();
								has = false;
						%>	
						<tr>
							<td valign="top" align="right" style="font-size: 10px"><%=entity.getPro_id()%></td>
							<td valign="top" align="right" style="font-size: 10px"><%=entity.getCreate_date()%></td>
							<td valign="top" align="left" style="font-size: 10px">
							<%
								if(entity.getItem_type().equalsIgnoreCase("PRO")){
								
							%><%=pac.getName()%>
							<%	
								}else {
								%><%=mat.getDescription() %>
								<%
								}
							%>
							</td>
							<!-- <td valign="top" align="center" style="font-size: 11px"><%=Money.money(entity.getItem_qty())%> <%=(entity.getItem_type().equalsIgnoreCase("PRO")?"ชุด":"KG")%></td>  -->
							<td valign="top" align="center" style="font-size: 11px"><%=Money.money(entity.getItem_qty())%></td>
							<td valign="top" align="center"><%=(entity.getStatus().equalsIgnoreCase(Production.STATUS_OUTLET)?Production.status(Production.STATUS_FINNISH):Production.status(entity.getStatus()))%> </td>
							<td valign="top" align="center">
								<button class="btn_box btn_select" pro_id="<%=entity.getPro_id()%>">เลือก</button>
							</td>
						</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการโปรดักชั่น ---- </td></tr>
						<%
							}
						%>
						</tbody>
					</table>				
				</div>
				<input type="hidden" id="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
		</div>
	</div>
</div>
</body>
</html>