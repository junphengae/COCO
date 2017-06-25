<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.bitmap.bean.sale.Province"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.sale.Zipcode"%>
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

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>รายการใบส่งของ</title>
<%

String zip_code = WebUtils.getAjaxReqString(request, "zip_code");
String province_id = WebUtils.getAjaxReqString(request, "province_id");

String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();

paramList.add(new String[]{"zip_code",zip_code});
paramList.add(new String[]{"province_id",province_id});

session.setAttribute("SO_SEARCH", paramList);

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}

Iterator ite = Production.selectReport(ctrl, paramList).iterator();
%>
</head>

<script type="text/javascript">
$(function(){
	$('#btn_send').click(function(){
		if($("input[name='choose']:checked").size() > 0){
			ajax_load();
			
			$.post('SaleManage',$('#sale_order_info').serialize(),function(resData){
				ajax_remove();
				if (resData.status == 'success') {	
					//window.location.reload();
				} else {					
					alert(resData.message);
				}
			},'json');	
		} else {
			alert("ยังไม่ได้เลือกสักอัน");
		}
		
	});
	$('#province_id').change(function(){
		form_load($('#sale_order_info'));
			$.post('SaleManage',{'action':'get_zip','province_id':$(this).val()},function(resData){
				form_remove();
				if (resData.status == 'success') {	
					var j = resData.zip_code;
					
					var options = '<option value=""> --- เลือกเขต --- </option>';
					for(var i = 0;i < j.length;i++){
						options += '<option value="' + j[i][0] + '">' + j[i][1] + '</option>';	
					}
					$('#zip_code').html(options);					
				} else{
					alert(resData.message);
				}
			},'json');	
		
	});
});
</script>

<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">รายการใบส่งของ</div>
			</div>
			<div class="content_body">
					<form id="sale_order_info" style="margin: 0; padding: 0;" action="logis_report.jsp" id="search" method="get">
			
					<div class="detail_wrap s800 center txt_center">
							zipcode : 
							<bmp:ComboBox name="zip_code" styleClass="txt_box s150" listData="<%=Zipcode.getComboList("th","10")%>" value="<%=zip_code%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
							</bmp:ComboBox>
							&nbsp;&nbsp;
							จังหวัด : 
							<bmp:ComboBox name="province_id" styleClass="txt_box s150" listData="<%=Province.selectList("th","66")%>" value="<%=province_id%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
							</bmp:ComboBox>
							&nbsp;&nbsp;
							
							<br><br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>
							<input type="hidden" name="action" value="report_send">
							<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
				
						
					</div>
					
									
				<!-- next page -->  
				<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"sale_sent_pro.jsp",paramList)%></div>
				<div class="clear"></div>
				<!-- next page  -->
					<div class="dot_line m_top5"></div>
					<div class="clear"></div>
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="5"></th>
								<th valign="top" align="center" width="40">รายการ</th>
								<th valign="top" align="center" width="15%">ผู้ออก</th>
								<th valign="top" align="center" width="10%">กำหนดเสร็จ</th>
								<th valign="top" align="center" width="20%">ลูกค้า</th>
								<th valign="top" align="center" width="13%">สถานะ</th>
							</tr>
						</thead>
						<tbody>
						<%
							int i = 0;
							boolean has = true;
							while(ite.hasNext()) {
								Production entity = (Production) ite.next();
								Customer cus = entity.getUICus();
								Personal sale = entity.getUIPer();
								SaleOrderItem item = entity.getUIorder();
								InventoryMaster mat = entity.getUIMat();
								has = false;
						%>
							<tr>
								<td align="right"><input type="checkbox" name="choose" value="<%=item.getItem_run()%>"></td>
								<td align="left"><%=mat.getDescription() + " (" + mat.getGroup_id() + ")"%></td>
								<td><%=sale.getName() + " " + sale.getSurname()%></td>
								<td align="center"><%=WebUtils.getDateValue(item.getConfirm_date())%></td>
								<td><%=cus.getCus_name()%></td>
								<td align="center"><%=Production.status(entity.getStatus())%></td>
							</tr>
						<%
							i++;
							}
							
							if(has){
						%>
							<tr><td colspan="8" align="center">---- ไม่พบรายการสินค้า ---- </td></tr>
						<%
							}
						%>
						</tbody>
					</table>
					</form>
						<%
						if(i > 1){ 
								%>
								<div class="txt_center">
									<button class="btn_box btn_confirm" id="btn_send">ออกใบส่งของ</button>
								</div>	
								<%
							}	
						%>	
				</div>
				
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>

</body>
</html>