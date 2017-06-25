<%@page import="com.bitmap.bean.logistic.LogisSend"%>
<%@page import="com.bitmap.bean.sale.Province"%>
<%@page import="com.bitmap.bean.logistic.Detail_send"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.logistic.SendProduct"%>
<%@page import="com.bitmap.bean.logistic.Busstation"%>
<%@page import="com.bitmap.bean.hr.Personal"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleOrder"%>
<%@page import="com.bitmap.bean.sale.Customer"%>
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
<script src="../js/popup.js" type="text/javascript"></script>
<script src="../js/number.js" type="text/javascript"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>
<script src="../js/ui/jquery.ui.position.js"></script>
<script src="../js/ui/jquery.ui.autocomplete.js"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>จัดการคิวรถ</title>
<%
String qid = WebUtils.getReqString(request, "qid");
String run = WebUtils.getReqString(request, "run");

Busstation bus = new Busstation();
bus = Busstation.selectByQid(qid);

SendProduct pro = new SendProduct();
pro.setRun(run);
SendProduct.select(pro);
String count = Detail_send.countrow(run);
%>
</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">จัดการคิวรถ | [1. เลือกรถ | 2. เลือกใบส่งสินค้า <%=(run.length() > 0)?"เลขที่ " + run:""%>]</div>
				<div class="right btn_box m_right30" onclick="window.location='logis_bus.jsp'">ย้อนกลับ</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				<form id="send_info" onsubmit="return false;">
				<table width="100%" cellpadding="2" cellspacing="2">
					<tbody>	
						<tr>
							<td width="130">ชื่อบริษัท</td>
							<td width="370"><div class="thickbox pointer" title="ข้อมูลคิวรถ" lang="../info/bus_info.jsp?qid=<%=bus.getQid()%>&height=300&width=520">: <%=bus.getCompany()%></div></td>
							<td width="130">ชื่อคนขับ </td>
							<td>: <%=bus.getDriver()%></td>
						</tr>
						<tr>
							<td>ผู้ตรวจเช็ค</td>
							<td> : <input class="txt_box s250" type="text" id="request_emp_check" value="<%=Personal.selectNameANDSurName(pro.getEmp_check())%>"></td>
							<td>เด็กติดรถ</td>
							<td>: <input class="txt_box s250" type="text" id="request_emp_car" value="<%=Personal.selectNameANDSurName(pro.getEmp_car())%>"></td>
						</tr>	
						<tr>
							<td>เลขที่บัตรน้ำมัน</td>
							<td> : <input class="txt_box s250" type="text" id="no_oil" name="no_oil" value="<%=pro.getNo_oil()%>"></td>
							<td>ปริมาณน้ำมัน</td>
							<td>: <input class="txt_box s250" type="text" id="qty_oil" name="qty_oil" value="<%=pro.getQty_oil()%>"></td>
						</tr>
						<tr>
							<td>เวลาเติมน้ำมัน</td>
							<td> : <input class="txt_box s250" type="text" id="time_oil" name="time_oil" value="<%=pro.getTime_oil()%>"></td>
							<td>ใบแจ้งหนี้ขนส่ง</td>
							<td>: <input class="txt_box s250" type="text" id="reference" name="reference" value="<%=pro.getReference()%>"></td>
						</tr>	
						<tr>
							<td>วันที่ส่งของ</td>
							<td>
								: <input type="text" name="send_date" id="send_date" class="txt_box" autocomplete="off" value="<%=WebUtils.getDateValue(pro.getSend_date())%>">
							</td>
							
							<td><label>ต้นทาง</label></td>
							<td>: <bmp:ComboBox name="start" styleClass="txt_box s200" listData="<%=Province.getComboList()%>" value="<%=pro.getStart()%>"></bmp:ComboBox></td>
						</tr>
						<tr>
							<td>remark</td>
							<td> : <input class="txt_box s250" type="text" id="remark" name="remark" value="<%=pro.getRemark()%>"></td>
							<td><label>ปลายทาง</label></td>
							<td>: <bmp:ComboBox name="finish"  styleClass="txt_box s200" listData="<%=Province.getComboList()%>" value="<%=pro.getFinish()%>"></bmp:ComboBox></td>
						</tr>
						<tr>	
							<td colspan="4" align="center"><button class="btn_box btn_confirm">บันทึก</button></td>
						</tr>
					</tbody>
				</table>
					<input type="hidden" name="emp_car" id="emp_car">
					<input type="hidden" name="emp_check" id="emp_check">		
					<input type="hidden" name="qid" id="qid" value="<%=qid%>">
					<input type="hidden" name="run" id="run" value="<%=run%>">
					<input type="hidden" name="action" value="<%=(run.length()>0)?"update_send_product":"gen_send_product"%>">
					<input type="hidden" name="<%=(run.length()>0)?"update_by":"create_by"%>" value="<%=securProfile.getPersonal().getPer_id()%>">
				</form>
				<%if (qid.length() > 0) {
				List list = Detail_send.selectByRun(run);
				%>

				<div class="dot_line m_top10"></div>
				
				<fieldset class="fset ">
						<legend>รายการใบส่งสินค้า</legend>
						<% if(pro.getStatus().equalsIgnoreCase(SendProduct.STATUS_NOT_SEND)){ %>
						<div class="right">
							<button id="btn_send" class="btn_box btn_confirm" title="เพิ่มใบส่งสินค้า" onclick="popup('sendid_search.jsp?run=<%=run%>')">เพิ่มใบส่งสินค้า</button>
						</div>
						<%} %>
						<div class="clear"></div>
						
						<table class="bg-image s900">
							<thead>
								<tr>
									<th valign="top" align="center" width="5%">No.</th>
									<th valign="top" align="center" width="10%">ประเภท</th>
									<th valign="top" align="center" width="25%">ลูกค้า</th>
									<th valign="top" align="center" width="20%">รายการสินค้า</th>
									<th valign="top" align="center" width="10%">จำนวนทั้งหมด</th>
									<th valign="top" align="center" width="10%">จำนวนที่ส่ง</th>
									<th valign="top" align="center" width="10%">วันที่ส่ง</th>
									<th align="center" width="10%"></th>
								</tr>
							</thead>
								
							<tbody>
								<%
								Iterator ite = list.iterator();
								while (ite.hasNext()){
									Detail_send send = (Detail_send) ite.next();
									LogisSend entity = send.getUIlogis_send();
								%>
									<tr>
										<td align="right"><%=entity.getInv()%></td>
										<td align="center"><%=LogisSend.statusInv(entity.getType_inv())%></td>
										<td align="left"><%=send.getUInamecus()%></td>
										<td align="center"><%=send.getUImatname()%></td>
										<td align="center"><%=entity.getQty_all()%></td>
										<td align="center"><%=entity.getQty()%></td>
										<td align="center"><%=WebUtils.getDateValue(entity.getSend_date())%></td>
										<td align="center">
											<% if(entity.getStatus().equalsIgnoreCase(SendProduct.STATUS_NOT_SEND)){ %>
											<input type="button" class="btn_del_item btn_box btn_warn" value = "ลบ" run="<%=send.getRun()%>" id_run="<%=send.getId_run()%>">
											<%} %>
										</td>
									</tr>
								<%
								}
								%>	
							</tbody>
						</table>						
						
				</fieldset>
				<%} %>
				</div>
				<br>
				<% if(pro.getStatus().equalsIgnoreCase(SendProduct.STATUS_NOT_SEND) && !count.equalsIgnoreCase("0")){ %>
				<div class="center m_top5">
				<input type="hidden" name="qid" value="<%=qid%>">
				<input type="hidden" name="run" value="<%=run%>">
				<div class="txt_center"><button class="btn_box btn_confirm" id="btn_click_send">ยืนยันการส่งสินค้า</button></div>
				</div>
				<%} %>
					
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>	
</div>
<script type="text/javascript">
	$("#request_emp_check").autocomplete({
	    source: "GetEmployee",
	    minLength: 2,
	    select: function(event, ui) {
	       $('#emp_check').val(ui.item.id);
	    }
	});
	$("#request_emp_car").autocomplete({
	    source: "GetEmployee",
	    minLength: 2,
	    select: function(event, ui) {
	       $('#emp_car').val(ui.item.id);
	    }
	});
	$('#send_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
	
	$('.btn_del_item').click(function(){
		if (confirm('ยืนยันการลบ!')) {
			var data = {
						'action':'del_send',
						'run':$(this).attr('run'),
						'id_run':$(this).attr('id_run')
					   };
			
			ajax_load();
			$.post('LogisManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {		
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	
	$('.btn_click').click(function(){
			var data = {
						'action':'update_remark',
						'run':$(this).attr('run'),
						'remark':$('#remark').val(),
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>'
					   };
			
			ajax_load();
			$.post('LogisManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {		
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
	});
	
	$('#send_info').submit(function(){
			var $duedate = $('#send_date');		
				var duedate = $duedate.val().split('/');
 				if(duedate=='')	{
 					alert('กรุณากำหนดวันที่ส่งของ!');
 					$duedate.focus();
 				} else{
					var dd = new Date(duedate[2],duedate[1]-1,duedate[0]);
					var today = new Date();
					today = new Date(today.getFullYear(),today.getMonth(),today.getDate());
						if (dd < today){
							alert('กำหนดวันส่งของ น้อยกว่า วันปัจจุบัน!');
							$duedate.focus();
						} else {
							ajax_load();
							$.post('LogisManage',$(this).serialize(),function(resData){
								ajax_remove();
								if (resData.status == 'success') {
									window.location='logis_send_product.jsp?qid=<%=qid%>&run=' + resData.run;
								} else {
									alert(resData.message);
								}
							},'json');
						}
 				}	
	});
	
	$('#ap_send').submit(function(){
		ajax_load();
		$.post('LogisManage',$(this).serialize(),function(resData){
			ajax_remove();
			if (resData.status == 'success') {
				window.location.reload();
			} else {
				alert(resData.message);
			}
		},'json');
	});

	$('#btn_click_send').click(function(){
		if (confirm('ยืนยันการส่ง!')) {
			var data = {
						'action':'ap_send',
						'qid':$('#qid').val(),
						'run':$('#run').val(),
						'update_by':'<%=securProfile.getPersonal().getPer_id()%>'
					   };
			
			ajax_load();
			$.post('LogisManage',data, function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		}
	});
	

</script>
</body>
</html>