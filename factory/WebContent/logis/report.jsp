<%@page import="com.bitmap.bean.logistic.LogisSend"%>
<%@page import="com.bitmap.bean.sale.Province"%>
<%@page import="com.bitmap.bean.logistic.SendProduct"%>
<%@page import="com.bitmap.bean.logistic.Busstation"%>
<%@page import="com.bitmap.bean.logistic.Detail_send"%>
<%@page import="com.bitmap.dbutils.DBUtility"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.bitmap.barcode.Barcode128"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.sale.PackageItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.sale.SaleQt"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.bean.inventory.InventoryLotControl"%>
<%@page import="com.bitmap.bean.inventory.InventoryLot"%>
<%@page import="com.bitmap.bean.util.StatusUtil"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.webutils.PageControl"%>
<%@page import="com.bitmap.security.SecurityUnit"%>
<%@page import="com.bitmap.security.SecuritySystem"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
String run = WebUtils.getReqString(request, "run");
String qid = WebUtils.getReqString(request, "qid");
Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_barcode"), run);

SendProduct sendPd = new SendProduct();
sendPd.setRun(run);
SendProduct.select(sendPd);


Busstation bus = new Busstation();
bus = Busstation.selectByQid(qid);

Province pro = new Province();
pro = Province.select(sendPd.getStart());
String start = pro.getProvince_th_name();

pro = Province.select(sendPd.getFinish());
String fin = pro.getProvince_th_name();
%>



<style type="text/css">
.tb{border-collapse: collapse;}
.tb tr, .tb td, .tb th{border: .5pt solid #000;border-top: .5pt solid #000; border-bottom: .5pt solid #000;}
</style>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/theme_print_horizon.css" rel="stylesheet" type="text/css" media="all">

<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<script type="text/javascript">
function setPrint(){
//	setTimeout('window.print()',1000); setTimeout('window.close()',2000);
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Viewer</title>


</head>
<body style="font-size: 18px;" onload="setPrint();">
<div class="wrap_print">
	<div style="margin-top: 80px;"></div>
				<div class="txt_center" style="font-size: 22px;"><strong>รายงานส่งสินค้า</strong></div>
				<div class="txt_center" style="font-size: 22px;"><strong></strong></div>
				<div class="clear"></div>
		
				<div class="right">
					<fieldset class="right s200" style="border-color: black;">
						<div class="txt_left m_left5">เลขที่คิวรถ : <%=run%>  </div>
						<div class="clear"></div>
						<div class="txt_left m_left5">วันที่ : <%=WebUtils.getDateValue(DBUtility.getCurrentDate())%>  </div>
						<div class="clear"></div>
						<div class="txt_left m_left5">กำหนดส่ง : <%=WebUtils.getDateValue(sendPd.getSend_date())%>  </div>
					</fieldset>
						
				</div>
				
				<div class="clear"></div>
				<div class="left">
				<div class="left s60">บริษัท</div>
				<div class="left">: <%=bus.getCompany()%></div>
				<div class="clear"></div>
				
				<div class="left s60">ส่งโดย</div>
				<div class="left">: <%=bus.getDriver()%></div>
				<div class="clear"></div>
				
				<div class="left s60">ต้นทาง</div>
				<div class="left">: <%=start%></div>
				<div class="clear"></div>
				
				<div class="left s60">ปลายทาง</div>
				<div class="left">: <%=fin%></div>
				<div class="clear"></div>
				<br>
				<table class="tb" width="100%">
							<thead>
								<tr>
									<th valign="top" align="center" width="10%">No.</th>
									<th valign="top" align="center" width="10%">ประเภท</th>
									<th valign="top" align="center" width="50%">รายการสินค้า</th>
									<th valign="top" align="center" width="10%">จำนวนทั้งหมด</th>
									<th valign="top" align="center" width="10%">จำนวนที่ส่ง</th>
									<th valign="top" align="center" width="10%">วันที่ส่ง</th>
								</tr>
							</thead>		
							<tbody>
								<%
								List list = Detail_send.selectByRun(run);
								Iterator ite = list.iterator();
								while (ite.hasNext()){
									Detail_send send = (Detail_send) ite.next();
									LogisSend entity = send.getUIlogis_send();
								%>
									<tr>
										<td align="right"><%=entity.getInv()%></td>
										<td align="center"><%=LogisSend.statusInv(entity.getType_inv())%></td>
										<td align="center"><%=send.getUImatname()%></td>
										<td align="center"><%=entity.getQty_all()%></td>
										<td align="center"><%=entity.getQty()%></td>
										<td align="center"><%=WebUtils.getDateValue(entity.getSend_date())%></td>
									</tr>
								<%
								}
								%>	
								</tbody>		
							</table>
							<div class="m_top50 center">
							<div class="left m_left100 txt_center s250">
								<div class="">......................................................<br>หัวหน้าแผนกจัดซื้อ</div>
								<div class="">(............................................................)</div>
								<div class="">(............................................................)</div>
							</div>
							
							<div class="left m_left300 txt_center s200">
								<div class=" ">......................................................<br>ผู้อนุมัติสั่งซื้อ</div>
								<div class="">(............................................................)</div>
								<div class="">(............................................................)</div>
							</div>
							<div class="clear"></div>
						</div>					
</div>
</body>
</html>