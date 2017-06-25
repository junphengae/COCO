
<%@page import="com.bitmap.bean.sale.Customer"%>
<%@page import="com.bitmap.bean.sale.SaleOrderItem"%>
<%@page import="com.bitmap.barcode.Barcode128"%>
<%@page import="com.bitmap.utils.Money"%>
<%@page import="com.bitmap.bean.production.Production"%>
<%@page import="com.bitmap.bean.logistic.ProduceItemMat"%>
<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.rd.RDFormularStep"%>
<%@page import="com.bitmap.bean.rd.RDFormularDetail"%>
<%@page import="com.bitmap.bean.rd.RDFormularInfo"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
String pro_id = WebUtils.getReqString(request,"pro_id");
String item_id = WebUtils.getReqString(request, "mat_code");
String cus_id = WebUtils.getReqString(request, "cus_id");

InventoryMaster master = new InventoryMaster();
RDFormular formular = new RDFormular();
WebUtils.bindReqToEntity(formular, request);

RDFormular.select(formular);
master = formular.getUIMat();
RDFormularInfo fmInfo = formular.getUIInfo();

float sumQty = RDFormularDetail.calSumQtyByCondition(formular.getMat_code());

Production pro = new Production();
pro.setPro_id(pro_id);
pro.setItem_id(item_id);
Production.selectByProid(pro);

SaleOrderItem item = SaleOrderItem.selectOrder(pro.getItem_run());
Customer cus = new Customer();
cus = Customer.select(cus_id);

Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_barcode"), pro_id);
Barcode128.genBarcode(WebUtils.getInitParameter(session, "local_path_inventory"),item_id);
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
	//setTimeout('window.print()',1000); setTimeout('window.close()',2000);
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ใบสั่งผลิต: <%=master.getDescription()%></title>


</head>
<body style="font-size: 18px;" onload="setPrint();">
<div class="wrap_print">
	<div class="wrap_body">
		<div class="m_top40"></div>
		<div class="body_content">
		<div class="left">Mat Code <img src="../path_images/inventory/<%=item_id%>.png"></div>
		<div class="clear"></div>
			<table class="tb" width="100%">
				<tbody>
					<tr>
						<td align="center" class="txt_22 txt_bold">แบบฟอร์มการผลิตเลขที่ <%=pro_id %></td>
						<td width="150" align="center"><img src="../path_images/barcode/<%=pro_id%>.png"></td>
					</tr>
				</tbody>
			</table>
			<table class="tb" width="100%" style="margin-top: -1px;">
				<tbody>
					<tr align="center">
						<td>Product Name / ชื่อสินค้า</td>
						<td>Mat Code / รหัสสินค้า</td>
						<td>Old Code / รหัสเดิม</td>
						<td>Reference Number</td>
						<td width="150">Colour Name</td>
					</tr>
					<tr align="center" class="txt_bold">
						<td><%=master.getDescription()%></td>
						<td><%=master.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + master.getUISubCat().getUICat().getCat_name_short() + ((master.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + master.getUISubCat().getSub_cat_name_short():"") + "-" + master.getMat_code()%></td>
						<td><%=master.getRef_code()%></td>
						<td><%=formular.getRef_no()%></td>
						<td><%=formular.getColour_tone_detail()%></td>
					</tr>
					<tr align="center">
						<td>Customer Name</td>
						<td>Quantity(<%=master.getStd_unit()%>)</td>
						<td>ลักษณะบรรจุภัณฑ์</td>
						<td>ปริมาตรต่อบรรจุภัณฑ์ (<%=master.getStd_unit()%>/<%=master.getDes_unit()%>)</td>
						<td>กำหนดเสร็จ</td>
					</tr>
					<tr align="center" class="txt_bold">
						<td><%=cus.getCus_name()%></td>
						<td><%=pro.getItem_qty()%></td>
						<td><%=master.getDes_unit()%></td>
						<td><%=master.getUnit_pack()%></td>
						<td><%=WebUtils.getDateValue(item.getConfirm_date())%></td>
					</tr>
				</tbody>
			</table>
		
			<div class="content_body">
			
					<%
					int i = 0;
					List<RDFormularStep> listStep = formular.getUIStep();
					for(RDFormularStep step:listStep){
						i++;
						String tr_weighing 	= "class=\"hide\"";
						String tr_machine 	= "class=\"hide\"";
						String tr_time 		= "class=\"hide\"";
						String tr_speed 	= "class=\"hide\"";
						String tr_met_grain_size = "class=\"hide\"";
						String tr_met_volume = "class=\"hide\"";
						String tr_temp 		= "class=\"hide\"";
						String tr_mix_spray = "class=\"hide\"";
						String tr_fillter 	= "class=\"hide\"";
						
						if (step.getProcess().equalsIgnoreCase("Weighing")){
							tr_weighing="class=\"show\"";tr_machine="class=\"show\"";tr_time="class=\"hide\"";tr_speed="class=\"hide\"";tr_met_grain_size="class=\"hide\"";tr_met_volume="class=\"hide\"";tr_temp="class=\"hide\"";tr_mix_spray="class=\"hide\"";tr_fillter="class=\"hide\"";
						}
						
						if (step.getProcess().equalsIgnoreCase("Stiring")){
							tr_weighing="class=\"hide\"";tr_machine="class=\"show\"";tr_time="class=\"show\"";tr_speed="class=\"show\"";tr_met_grain_size="class=\"hide\"";tr_met_volume="class=\"hide\"";tr_temp="class=\"hide\"";tr_mix_spray="class=\"hide\"";tr_fillter="class=\"hide\"";
						}
						
						if (step.getProcess().equalsIgnoreCase("Grinding")){
							tr_weighing="class=\"hide\"";tr_machine="class=\"show\"";tr_time="class=\"show\"";tr_speed="class=\"show\"";tr_met_grain_size="class=\"show\"";tr_met_volume="class=\"hide\"";tr_temp="class=\"show\"";tr_mix_spray="class=\"hide\"";tr_fillter="class=\"hide\"";
						}
						
						if (step.getProcess().equalsIgnoreCase("Letdown")){
							tr_weighing="class=\"hide\"";tr_machine="class=\"hide\"";tr_time="class=\"show\"";tr_speed="class=\"hide\"";tr_met_grain_size="class=\"hide\"";tr_met_volume="class=\"hide\"";tr_temp="class=\"hide\"";tr_mix_spray="class=\"hide\"";tr_fillter="class=\"hide\"";
						}
						
						if (step.getProcess().equalsIgnoreCase("Adjust")){
							tr_weighing="class=\"show\"";tr_machine="class=\"show\"";tr_time="class=\"hide\"";tr_speed="class=\"hide\"";tr_met_grain_size="class=\"hide\"";tr_met_volume="class=\"hide\"";tr_temp="class=\"hide\"";tr_mix_spray="class=\"hide\"";tr_fillter="class=\"hide\"";
						}
						
						if (step.getProcess().equalsIgnoreCase("Mixing Spray")){
							tr_weighing="class=\"hide\"";tr_machine="class=\"show\"";tr_time="class=\"hide\"";tr_speed="class=\"hide\"";tr_met_grain_size="class=\"hide\"";tr_met_volume="class=\"hide\"";tr_temp="class=\"hide\"";tr_mix_spray="class=\"show\"";tr_fillter="class=\"hide\"";
						}
						
						if (step.getProcess().equalsIgnoreCase("Baking")){
							tr_weighing="class=\"hide\"";tr_machine="class=\"show\"";tr_time="class=\"show\"";tr_speed="class=\"hide\"";tr_met_grain_size="class=\"hide\"";tr_met_volume="class=\"hide\"";tr_temp="class=\"show\"";tr_mix_spray="class=\"hide\"";tr_fillter="class=\"hide\"";
						}
						
						if (step.getProcess().equalsIgnoreCase("Fillter")){
							tr_weighing="class=\"hide\"";tr_machine="class=\"hide\"";tr_time="class=\"hide\"";tr_speed="class=\"hide\"";tr_met_grain_size="class=\"hide\"";tr_met_volume="class=\"hide\"";tr_temp="class=\"hide\"";tr_mix_spray="class=\"hide\"";tr_fillter="class=\"show\"";
						}
						
						if (step.getProcess().equalsIgnoreCase("Quality check") || step.getProcess().equalsIgnoreCase("Packing") || step.getProcess().equalsIgnoreCase("Label") || step.getProcess().equalsIgnoreCase("Keepstock")){
							tr_weighing="class=\"hide\"";tr_machine="class=\"hide\"";tr_time="class=\"hide\"";tr_speed="class=\"hide\"";tr_met_grain_size="class=\"hide\"";tr_met_volume="class=\"hide\"";tr_temp="class=\"hide\"";tr_mix_spray="class=\"hide\"";tr_fillter="class=\"hide\"";
						}
					%>
					
					<div class="m_top20"></div>
					
					<table width="100%">
						<tbody>
							<tr>
								<td width="65%" class="txt_20 txt_bold">ขั้นตอนที่ : <%=i%> - <%=RDFormularStep.step(step.getProcess()).toUpperCase()%></td>
								<td width="35%" valign="bottom">ผู้รับผิดชอบ ......................................................................................</td>
							</tr>
						</tbody>
					</table>
					
					<table class="tb" width="100%" style="margin-top: -1px;">
						<tbody>
							<tr <%=tr_machine%>>
								<td width="100" align="left">Machine</td>
								<td width="350">: <%=step.getMachine()%></td>
								<td></td>
								<td></td>
							</tr>
							<tr <%=tr_time%>>
								<td width="100" align="left">เวลา</td>
								<td width="350">: <%=step.getTime_start() + ((step.getTime_to().length() > 0)?" - " + step.getTime_to():"") + " " + step.getTime_unit()%></td>
								<td>เวลาเริ่ม : </td>
								<td>เวลาสิ้นสุด : </td>
							</tr>
							<tr <%=tr_speed%>>
								<td width="100" align="left">ความเร็วรอบ</td>
								<td width="350">: <%=step.getSpeed_start() + ((step.getSpeed_to().length() > 0)?" - " + step.getSpeed_to():"") + " " + step.getSpeed_unit()%></td>
								<td></td>
								<td></td>
							</tr>
							<tr <%=tr_weighing%>>
								<td width="100" align="left">ค่าเบี่ยงเบน</td>
								<td width="350">: <%=step.getDeviation()%></td>
								<td></td>
								<td></td>
							</tr>
							<tr <%=tr_fillter%>>
								<td width="100" align="left">ขนาดความถี่</td>
								<td width="350">: <%=step.getFillter()%></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td width="100" align="left">remark</td>
								<%if(step.getProcess().equalsIgnoreCase("Packing")){ %>
								<td width="350">: <%=step.getRemark()%></td>
								<td>บรรจุได้ทั้งหมด : </td>
								<td>เหลือเศษ : </td>
								<%} else { %>
								<td width="350" colspan="3">: <%=step.getRemark()%></td>
								<%}%>
							</tr>
						</tbody>
					</table>
					
					<table class="tb" width="100%" style="margin-top: -1px;">
						<tbody>
							<tr <%=tr_mix_spray%>>
								<td width="100" align="left">ความหนืดที่พ่น</td>
								<td width="350">: <%=step.getStickiness()%></td>
								<td></td>
								<td></td>
							</tr>
							<tr <%=tr_mix_spray%>>
								<td width="100" align="left">แรงดันลม</td>
								<td width="350">: <%=step.getPressure_wind()%></td>
								<td></td>
								<td></td>
							</tr>
							<tr <%=tr_mix_spray%>>
								<td width="100" align="left">แรงดันสี</td>
								<td width="350">: <%=step.getPressure_color()%></td>
								<td></td>
								<td></td>
							</tr>
							<tr <%=tr_mix_spray%>>
								<td width="100" align="left">ระยะห่าง</td>
								<td width="350">: <%=step.getInterval_()%></td>
								<td></td>
								<td></td>
							</tr>
							<tr <%=tr_mix_spray%>>
								<td width="100" align="left">จำนวนรอบพ่น</td>
								<td width="350">: <%=step.getSpray_cyc()%></td>
								<td></td>
								<td></td>
							</tr>
							<tr <%=tr_met_grain_size%>>
								<td width="100" align="left">ขนาดเม็ดทราย</td>
								<td width="350">: <%=step.getMet_grain_size_start() + ((step.getMet_grain_size_to().length() > 0)?" - " + step.getMet_grain_size_to():"") + " " + step.getMet_grain_size_unit()%></td>
								<td></td>
								<td></td>
							</tr>
							<tr <%=tr_met_volume%>>
								<td width="100" align="left">จำนวนเม็ดทราย</td>
								<td width="350">: <%=step.getMet_volume_start() + ((step.getMet_volume_to().length() > 0)?" - " + step.getMet_volume_to():"") + " " + step.getMet_volume_unit()%></td>
								<td></td>
								<td></td>
							</tr>
							<tr <%=tr_temp%>>
								<td width="100" align="left">อุณหภูมิ</td>
								<td width="350">: <%=step.getTemp_start() + ((step.getTemp_to().length() > 0)?" - " + step.getTemp_to():"") + " " + step.getTemp_unit()%></td>
								<td></td>
								<td></td>
							</tr>
						</tbody>
					</table>
					
					
					<%
					List<RDFormularDetail> listDetail = step.getUIDetail();
					
					
					if (listDetail.size() > 0){
					%>
					
					<table class="tb" width="100%" style="margin-top: -1px;">
						<thead>
							<tr>
								<th valign="middle" align="center" width="5%" rowspan="2">ลำดับ</th>
								<th valign="middle" align="center" width="30%" rowspan="2">รหัสวัตถุดิบ</th>
								<th valign="middle" align="center" width="10%" rowspan="2">ปริมาณในสูตร</th>
								<th valign="middle" align="center" width="10%" rowspan="2">หน่วย</th>
								<th valign="middle" align="center" width="10%" colspan="5">ใช้จริง</th>
								
								<th valign="middle" align="center" width="10%" rowspan="2">หมายเหตุ</th>
							</tr>
							<tr>
								<th valign="top" align="center" width="5%">1</th>
								<th valign="top" align="center" width="5%">2</th>
								<th valign="top" align="center" width="5%">3</th>
								<th valign="top" align="center" width="5%">4</th>
								<th valign="top" align="center" width="5%">5</th>
							</tr>
						</thead>
						<tbody id="material_list">
							<%
							int j = 0;
							for(RDFormularDetail detail:listDetail){
								ProduceItemMat mat = new ProduceItemMat();
								mat = ProduceItemMat.selectVal(detail.getUIMat().getMat_code(),pro_id);
								j++;
							%>
							<tr>
								<td align="center"><%=j%></td>
								<td><font style="font-size: 20px"><%=detail.getMaterial() + " - " + detail.getUIMat().getDescription()%></font></td>
								<td align="right"><%=Money.money(mat.getQty())%></td>
								<td align="center"><%=detail.getUIMat().getStd_unit()%></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td><%=detail.getRemark()%></td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</div>
					
				<div class="clear"></div>
					<%
					}
				}
				%>
				
				<div class="m_top20"></div>
					
				<table width="100%">
					<tbody>
						<tr>
							<td width="65%" class="txt_20 txt_bold">การตรวจสอบ</td>
							<td width="35%" valign="bottom"></td>
						</tr>
					</tbody>
				</table>
				
				<table class="tb" width="100%">
					<thead>
						<tr>
							<th valign="middle" align="center" rowspan="2" width="220">การตรวจสอบ</th>
							<th valign="middle" align="center" rowspan="2">% ของแข็ง<br>NV (%)</th>
							<th valign="middle" align="center" colspan="2">ความถ่วงจำเพาะ</th>
							<th valign="middle" align="center" rowspan="2">ความหนืด<br>(KU)</th>
							<th valign="middle" align="center" rowspan="2">ความเงา<br>(GLOSS)</th>
							<th valign="middle" align="center" rowspan="2">การตรวจสอบแม่สี</th>
						</tr>
						<tr>
							<th valign="middle" align="center" width="100">SG (q/ml)</th>
							<th valign="middle" align="center" width="100">Spec Density @ 20&deg;C</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>มาตรฐานการตรวจสอบ(SPEC)</td>
							<td align="center"><%=fmInfo.getSolidity()%></td>
							<td align="center"><%=fmInfo.getSpecific_gravity()%></td>
							<td align="center"></td>
							<td align="center"><%=fmInfo.getViscosity()%></td>
							<td align="center"><%=fmInfo.getGloss()%></td>
							<td align="center">ขนาดเม็ดสี (<%=fmInfo.getGrain_size()%> micron)</td>
							
						</tr>
					</tbody>
				</table>
				
				<div class="center txt_center">
					ผู้ตรวจสอบ ........................................................................................................... 
					วันที่ ......................../............................../...........................
				</div>
		</div>
	</div>
</div>
</body>
</html>