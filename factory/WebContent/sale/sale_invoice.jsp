<%@page import="com.bitmap.utils.Money"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.Catch"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="com.bitmap.bean.sale.Package"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.bean.sale.SaleQt"%>
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
<style type="text/css">
.bg-image tfoot td {
    background: none repeat scroll 0 0 #CFD1BD !important;
    font-size: 14px !important; 
}
</style>
<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/table.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>

<script type="text/javascript" src="../js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="../js/popup.js"></script>
<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css">

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ออกใบ invoice</title>
<%
String qt_id = WebUtils.getReqString(request, "qt_id");
String cus_id = WebUtils.getReqString(request, "cus_id");
String page_ = WebUtils.getReqString(request, "page");

List paramList = new ArrayList();
paramList.add(new String[]{"qt_id",qt_id});
paramList.add(new String[]{"cus_id",cus_id});
session.setAttribute("SO_SEARCH", paramList);

Customer cus = new Customer();
WebUtils.bindReqToEntity(cus, request);
Customer.select(cus);


Date today = DBUtility.getCurrentDate();
if(cus.getCus_credit().length() > 0 ){
	try{
		int credit = Integer.parseInt(cus.getCus_credit());
		Calendar cal = Calendar.getInstance();
		cal.setTime(today);
		cal.add(Calendar.DATE,+ credit);
		//cal.add(Calendar.MONTH,+1);
		
		///int aa = cal.get(Calendar.MONTH);
		today = cal.getTime();
	} catch (Exception e) {
		//System.out.println(e.getMessage());
	}
	
}

PageControl ctrl = new PageControl();
ctrl.setLine_per_page(15);
if(page_.length() > 0){
	ctrl.setPage_num(Integer.parseInt(page_));
}


%>
<script type="text/javascript">
$(function(){
	$('#delivery_date').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	});
	
	$('#delivery_date').click(function(){
		$('#delivery_date').val("");
	});

	$('#fin_inv').click(function(){
		$('#fin_inv').val("");
	});
	
	$('#sal_invoice').submit(function(){
		var $duedate = $('#delivery_date');		
		var duedate = $duedate.val().split('/');
		
		if($("input[name='choose']:checked").size() > 0){
			if($('#inv').attr('checked')){
				if(duedate=='')	{
					alert('กรุณากำหนดวันส่งของ!');
					$duedate.focus();
				} else{
					var dd = new Date(duedate[2],duedate[1]-1,duedate[0]);
					var today = new Date();
					today = new Date(today.getFullYear(),today.getMonth(),today.getDate());
					if (dd < today){
						alert('กำหนดวันส่งของ น้อยกว่า วันปัจจุบัน!');
						$duedate.focus();
					} else {
						if($('#a').attr('checked') || $('#b').attr('checked')){
							ajax_load();	
							$.post('SaleManage',$('#sal_invoice').serialize(),function(resData){
								ajax_remove();
								if (resData.status == 'success') {	
									popup('reportByinvoice.jsp?invoice=' + resData.invoice + '&cus_id=<%=cus_id%>');
									window.location = 'sale_invoice.jsp';
								} else {					
									alert(resData.message);
								}
							},'json');	
						}else{
							alert("กรุณาเลือก vat หรือ novat");
						}
					}
				}
			}else{
				if($('#tmp').attr('checked')){
					if(duedate=='')	{
						alert('กรุณากำหนดวันส่งของ!');
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
							$.post('SaleManage',$('#sal_invoice').serialize(),function(resData){
								ajax_remove();
								if (resData.status == 'success'){
									popup('reportByinvoice.jsp?invoice=' + resData.invoice + '&cus_id=<%=cus_id%>');
									window.opener.location = 'sale_invoice.jsp';
								} else {					
									alert(resData.message);
								}
							},'json');	
						}
					}
				}else{
					alert("กรุณาเลือกรูปแบบ");
				}
			}		
		} else {
			alert("กรุณาเลือกรายการ");
		}
		
	});
	
	$('#tmp').click(function(){
		$('#type').fadeOut('slow');
	});
	
	$('#inv').click(function(){	
		$('#type').fadeIn('slow');
	});
	
	$('#type #fin_inv').datepicker({
		showOtherMonths : true,
		slectOtherMonths : true,
		changeMonth : true
	}).datepicker('setDate',new Date());
	
	/******************************************** summary ******************************************************/
	$('#summary_price').html("0.00");
	$('#summary_inc_vat').html("0.00");
	$('#summary_net').html("0.00");
	
	
	
	///######## SUBMIT data to servlet to Gen PDF ##################///
	var isAlreadyClick = false;
	
	$('#sal_invoice #btn_invoice').bind('click',PostAndGen);
	
	
	
	function PostAndGen(){
		if(isAlreadyClick ){
				window.location.reload();
				return false;
		}
		if( ! $('#sal_invoice :checkbox ').is(':checked')  ){
			alert('กรุณาเลือกรายการสินค้าก่อน  เด้อคร้า.....');
			 return false;
		}
 
	}
	
	
	///############################## Manage JavaScript #######################################///
	
	var summary_price = 0;
	var summary_inc_vat = 0;
	var summary_net = 0;
	//resetValue();
	SummaryList();	
	
	function resetValue(){
		$.each($('#sal_invoice .reset_null'),function(){
			switch(this.type){
			case 'text' : $(this).val('0');break;
			}
		});		
	}
	function SummaryList(){
		summary_price = 0;
		summary_inc_vat = 0;
		summary_net = 0;
			$.each( $('#sal_invoice :checkbox'), function() {
				if( $(this).is(':checked') ) {
					summary_price +=  $('.table_row_bill[no="'+$(this).attr('index')+'"]  .prem').attr('val') * 1.00;				
				}
			});	
			
			
				
				if ($('.type_vat:checked').val() == "novat" ) {			
					$('#summary_inc_vat').html("0.00");			
					$('#summary_net').html(summary_price.toFixed(2));
					$('#sal_invoice #sb_total_val').val(summary_price.toFixed(2));
					
					
					$('#sum_inv').val(summary_price.toFixed(2));
					$('#vat_inv').val('0.00');
					$('#sum_net_inv').val(summary_price.toFixed(2));
					
				}
			
			$('#summary_price').html(summary_price.toFixed(2));		
			var sum_vat = (summary_price*7)/100;
			var sun_net = summary_price+sum_vat;						
			$('#summary_inc_vat').html(sum_vat.toFixed(2));
			$('#summary_net').html(sun_net.toFixed(2));
			$('#sal_invoice #sb_total_val').val(sun_net.toFixed(2));
			
			$('#sum_inv').val(summary_price.toFixed(2));
			$('#vat_inv').val(sum_vat.toFixed(2));
			$('#sum_net_inv').val(sun_net.toFixed(2));
	}	
		
	$('#sal_invoice :checkbox').click(function(){
		if($(this).is(':checked')){
			summary_price +=  $('.table_row_bill[no="'+$(this).attr('index')+'"]  .prem').attr('val') * 1.00;
		}else{
			summary_price -= $('.table_row_bill[no="'+$(this).attr('index')+'"]  .prem').attr('val') * 1.00;
		}

		
			
			if ($('.type_vat:checked').val() == "novat" ) {			
				$('#summary_inc_vat').html("0.00");			
				$('#summary_net').html(summary_price.toFixed(2));
				$('#sal_invoice #sb_total_val').val(summary_price.toFixed(2));
				
				
				$('#sum_inv').val(summary_price.toFixed(2));
				$('#vat_inv').val('0.00');
				$('#sum_net_inv').val(summary_price.toFixed(2));
				
			}
			
		
		
		$('#summary_price').html(summary_price.toFixed(2));		
		var sum_vat = (summary_price*7)/100;
		var sun_net = summary_price+sum_vat;						
		$('#summary_inc_vat').html(sum_vat.toFixed(2));
		$('#summary_net').html(sun_net.toFixed(2));
		$('#sal_invoice #sb_total_val').val(sun_net.toFixed(2));
		
		$('#sum_inv').val(summary_price.toFixed(2));
		$('#vat_inv').val(sum_vat.toFixed(2));
		$('#sum_net_inv').val(sun_net.toFixed(2));
		
	});
	
	/******************************************************************************/
	$('#btn_select_all').bind('click',CheckListAll);
	$('#btn_deselect_all').bind('click',DecheckListAll);
	function CheckListAll(){
		$.each( $('#sal_invoice :checkbox'), function() {
			if($(this).is(':checked')){
				
			}else{
			 	$(this).attr('checked','checked');
			}
			SummaryList();
		});			
	}
	
	function DecheckListAll(){				
		$.each( $('#sal_invoice :checkbox'), function() {
			 $(this).attr('checked',false);
		});	
		SummaryList();
	}
	
	function returnFalse(){
		return false;
	}
	
	$('.type_vat').click(function(){	
		if ($('.type_vat:checked').val() == "novat" ) {			
			$('#summary_inc_vat').html("0.00");			
			$('#summary_net').html(summary_price.toFixed(2));
			$('#sal_invoice #sb_total_val').val(summary_price.toFixed(2));
			
			
			$('#sum_inv').val(summary_price.toFixed(2));
			$('#vat_inv').val('0.00');
			$('#sum_net_inv').val(summary_price.toFixed(2));
			
		}else{
			SummaryList();
			}
	});
	/**************************************************************************************************/
	
	
});
</script>

</head>
<body>

<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">ออกใบ invoice</div>

			</div>
			
			<div class="content_body">
			<form style="margin: 0; padding: 0;" action="sale_invoice.jsp" id="search" method="get">
					<div class="detail_wrap s800 center txt_center">
							<% if(!(cus_id.equalsIgnoreCase(""))){%>
							เลขที่ใบ QT: 
							<bmp:ComboBox name="qt_id" styleClass="txt_box s150" listData="<%=SaleOrderItem.qtid(cus_id)%>"  value="<%=qt_id%>">
								<bmp:option value="" text="--- แสดงทั้งหมด ---"></bmp:option>
							</bmp:ComboBox>
							<% } %>
							ลูกค้า :
							<% List listcus =  Customer.namecusinv(); %>							
							<bmp:ComboBox name="cus_id" styleClass="txt_box s200" listData="<%=listcus%>"  value="<%=cus_id%>" onChange="$('#qt_id').val('');$('#search').submit();">
								<bmp:option value="" text="--- เลือกลูกค้า ---"></bmp:option>
							</bmp:ComboBox>
							<br>
							<br>
							<button class="btn_box btn_confirm" type="submit">แสดงผล</button>							
					</div>
			</form>	
					
			<% if(!(cus_id.equalsIgnoreCase(""))){ %>
			<div class="dot_line m_top5"></div>	
			<div class="clear"></div>
			<!-- next page -->  
			<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"sale_invoice.jsp",paramList)%></div>
			<div class="clear"></div>
			<!-- next page  -->
			<form id="sal_invoice" onsubmit="return false;">			
					<div class="dot_line m_top5"></div>				
					<div class="clear"></div>
					<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="5%"></th>
								<th valign="top" align="center" width="5%">No.QT</th>
								<th valign="top" align="center" width="5%">No.PO</th>
								<th valign="top" align="center" width="10%">ประเภท</th>
								<th valign="top" align="center" width="25%">รายการสินค้า</th>
								<th valign="top" align="center" width="10%">กำหนดส่ง</th>
								<!-- <th valign="top" align="center" width="15%">สถานะ</th> -->
								<th valign="top" align="center" width="5%">จำนวน<h6>(Quantity)</h6></th>
								<th valign="top" align="center" width="10%">ราคาต่อหน่วย<h6>(Unit Price)</h6></th>
								<th valign="top" align="center" width="10%">หลังลด<h6>(All Amount)</h6></th>
							</tr>
						</thead>
						<tbody>
						<%
							int no_run = 0;
							boolean has = true;
							Iterator ite = SaleOrderItem.sal_invoiceWithCTRL(ctrl, paramList).iterator();
							String po = "";
							while(ite.hasNext()) {
								SaleOrderItem entity = (SaleOrderItem) ite.next();
								po = entity.getPo();
								has = false;
						%>
							<tr class="table_row_bill" no=<%=++no_run %>>
								<td valign="top" align="center">
									<input type="checkbox" name="choose"  index="<%=no_run%>"  value="<%=entity.getItem_run() + "_" + entity.getStatus()%>">
								</td>
								<td align="right"><%=entity.getQt_id()%></td>
								<td align="right"><%=entity.getPo()%></td>
								<td align="center"><%=SaleOrder.type(entity.getUIOrder().getOrder_type())%></td>
								<td align="left"><%=(entity.getItem_type().equalsIgnoreCase("s")?entity.getUIMatName():entity.getUIPacName())%><br><%=entity.getRemark()%></td>
								<td align="center"><%=WebUtils.getDateValue(entity.getUIOrder().getDue_date())%></td>
								
								<%-- <td align="center">
									<% if(!(entity.getTemp_invoice().equalsIgnoreCase(""))){
										%><%="ใบส่งของชั่วคราว"%>
									<%}else{
									%><%=SaleOrderItem.status(entity.getStatus())%>
									
									<% } %>
								</td> --%>
								<td align="center"  class="item_qty" ><%=entity.getItem_qty()%></td>
								<td align="center" class="unit_price"><%=Money.money(entity.getUnit_price())%></td>
								<%
									String discnt = "0";
									if (entity.getDiscount().length() > 0) {
										discnt = entity.getDiscount();
									}	
									if(entity.getItem_type().equalsIgnoreCase("s")){
										String discount = Money.discount(Money.multiple(entity.getItem_qty(),entity.getUnit_price()),discnt);
									%>
									
									<td class="prem" val="<%=discount%>">
									<%=Money.money(discount)%>
									</td>		
									<%
									}else{
									%>
										<%
										String discount =Money.discount(entity.getUnit_price(),discnt);
										%>
									<td class="prem" val="<%=discount%>">
									<%=discount%>
									</td>
									<%
									}
									%>
								<input type="hidden" style="width: 65px;" maxlength="5" value="0" class="textcenter baht_dc" index="<%=no_run %>"  readonly="readonly">	
							</tr>
						<%
							}
							if(has){
						%>
							<tr><td colspan="9" align="center">---- ไม่พบรายการใบ QT ---- </td></tr>
						<%
							}
							
						%>
						</tbody>
						<tfoot >
						
						
									<tr >	
										<td  colspan="5"  style="border-top: none; ">
										
											<button class="btn_box" type="button" id="btn_select_all"> เลือกทั้งหมด</button>
											<button class="btn_box" type="button" id="btn_deselect_all">ลบทั้งหมด</button>
										
										</td>									
										<td colspan="2" align="right" class="textcenter" style="border-top: none; ">รวมเงิน</td>
										<td ></td>
										<td class="textcenter" style=" border:1px dotted #555555; border-right: none; border-left: none;"><div id="summary_price" class="textcenter reset_null  "></div></td> 										
												
									</tr>	
									<tr>
										<td  colspan="5"  style="border-top: none; "></td>	
										<td colspan="2" align="right" class="textcenter" style="border-top: none; ">ภาษีมูลค่าเพิ่ม(Vat)</td>
										<td style=" border:1px dotted #555555; border-right: none; border-left: none;"></td>
										<td class="textcenter" style=" border:1px dotted #555555; border-right: none; border-left: none;"><div id="summary_inc_vat" class="textcenter  reset_null"></div></td> 
										
									</tr>
									<tr>
										<td  colspan="5"  style="border-top: none; "></td>	
										<td colspan="2" align="right" class="textcenter" style="border-top: none; ">ยอดสุทธิ(Net Total)</td>
										<td style=" border:1px dotted #555555; border-right: none; border-left: none;"></td>
										<td class="textcenter" style=" border:1px dotted #555555; border-right: none; border-left: none;"><div id="summary_net"  class="textcenter  reset_null"></div></td> 
										
									</tr>
						</tfoot>	
					</table>
					<%
					
					if(has == false){
						
					%>
					<fieldset class="fset s500">
					<legend>เลือกรูปแบบ</legend>
						<div class="txt_center">
							<div>
								<input type="radio" name="b" id="tmp" value="tmp" checked="checked"> <label for="tmp">ใบส่งของชั่วคราว</label>
								<input type="radio" name="b" id="inv" value="inv"> <label for="inv">ออก invoice</label>
							</div>
							<div class="clear"></div>
							<div class="hide" id="type">
								<input type="radio" class="type_vat" name="c" id="a" value="vat"> <label for="a">vat</label>
								<input type="radio" class="type_vat" name="c" id="b" value="novat"><label for="b">novat</label>
								<br>
								ครบกำหนดชำระ : <input type="text" name="fin_inv" id="fin_inv" class="txt_box m_top10" value="<%=WebUtils.getDateValue(today)%>">
							</div>
							<div> กำหนดส่งของ : <input type="text" name="delivery_date" id="delivery_date" class="txt_box">
							</div>
		
							<div>
							เลขที่ PO : <input type="text" name="po" id="po" class="txt_box" value="<%=po%>">
							</div>
						
							<button class="btn_box btn_confirm m_top10" id="btn_invoice">ออกใบ invoice</button>
						</div>
						
					</fieldset>
					<%
					}
					%>
					
					<input type="hidden" name="sum_inv" id="sum_inv" >
					<input type="hidden" name="vat_inv" id="vat_inv" >
					<input type="hidden" name="sum_net_inv" id="sum_net_inv" >
					<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">		
					<input type="hidden" name="action" value="add_invoice">		
				</form>	
			<% } else {
			
			List list = SaleOrderItem.waitInvoice(ctrl);
			%>
							
				<div class="dot_line m_top5"></div>	
				<div class="clear"></div>
				<!-- next page -->  
				<div class="right txt_center m_right20"><%=PageControl.navigator_en(ctrl,"sale_invoice.jsp",paramList)%></div>
				<div class="clear"></div>
				<!-- next page  -->
				<table class="bg-image s930">
						<thead>
							<tr>
								<th valign="top" align="center" width="5%">No.QT</th>
								<th valign="top" align="center" width="10%">No.PO</th>
								<th valign="top" align="center" width="10%">ประเภท</th>
								<th valign="top" align="center" width="30%">รายการสินค้า</th>
								<th valign="top" align="center" width="10%">จำนวน</th>
								<th valign="top" align="center" width="10%">กำหนดส่ง</th>
								<th valign="top" align="center" width="15%">สถานะ</th>
							</tr>
						</thead>
						<tbody>
						<%
					Iterator ite = list.iterator();
					while (ite.hasNext()){
						SaleOrderItem item = (SaleOrderItem) ite.next();
					%>
						<tr>
						
							<td align="right"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=item.getUIOrder().getCus_id()%>&height=400&width=520">
						<%=item.getQt_id()%></div></td>
							<td align="right"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=item.getUIOrder().getCus_id()%>&height=400&width=520">
						<%=item.getPo()%></div></td>
							<td align="center"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=item.getUIOrder().getCus_id()%>&height=400&width=520">
						<%=SaleOrder.type(item.getUIOrder().getOrder_type())%></div></td>
							<td align="left"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=item.getUIOrder().getCus_id()%>&height=400&width=520">
						<%=(item.getItem_type().equalsIgnoreCase("s")?item.getUIMatName():item.getUIPacName())%></div></td>
							<td align="center"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=item.getUIOrder().getCus_id()%>&height=400&width=520">
						<%=item.getItem_qty()%></div></td>
							<td align="center"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=item.getUIOrder().getCus_id()%>&height=400&width=520">
						<%=WebUtils.getDateValue(item.getUIOrder().getDue_date())%></div></td>
								<td align="center"><div class="thickbox pointer" title="ข้อมูลลูกค้า" lang="../info/customer_info.jsp?cus_id=<%=item.getUIOrder().getCus_id()%>&height=400&width=520">
									<% if(!(item.getTemp_invoice().equalsIgnoreCase(""))){
										%><%="ใบส่งของชั่วคราว"%>
									<%}else{
									%><%=SaleOrderItem.status(item.getStatus())%>
									<% } %>
							</div></td>
						
						</tr>
						
					<%
					}
					%>
						</tbody>
					</table>
			<%} %>						
			</div>
	</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
</div>
</body>
</html>