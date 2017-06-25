<%@page import="com.bitmap.webutils.LinkControl"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.util.ListUtil"%>
<%@page import="com.bitmap.bean.inventory.SubCategories"%>
<%@page import="com.bitmap.bean.inventory.Categories"%>
<%@page import="com.bitmap.bean.inventory.InventoryMaster"%>
<%@page import="com.bitmap.bean.inventory.Group"%>
<%@page import="com.bitmap.bean.inventory.InventoryMasterVendor"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bitmap.bean.rd.*"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>

<script src="../js/jquery.min.js"></script>
<script src="../js/thickbox.js"></script>
<script src="../js/loading.js"></script>
<script src="../js/jquery.metadata.js"></script>
<script src="../js/jquery.validate.js"></script>
<script src="../js/popup.js" type="text/javascript"></script>

<script src="../js/ui/jquery.ui.core.js"></script>
<script src="../js/ui/jquery.ui.widget.js"></script>
<script src="../js/ui/jquery.ui.tabs.js"></script>
<script src="../js/ui/jquery.ui.mouse.js"></script>
<script src="../js/ui/jquery.ui.sortable.js"></script>

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

<link href="../themes/vbi-theme/jquery.ui.all.css" rel="stylesheet" type="text/css" />

<%
InventoryMaster master = new InventoryMaster();
RDFormular formular = new RDFormular();
WebUtils.bindReqToEntity(formular, request);

RDFormular.select(formular);
master = formular.getUIMat();
RDFormularInfo fmInfo = formular.getUIInfo();

float sumQty = RDFormularDetail.calSumQtyByCondition(formular.getMat_code());
%>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>จัดการขั้นตอนในสูตรการผลิต (Step for Formular)</title>

<script type="text/javascript">
	$(function(){
		var formular_step_form = $('#formular_step_form');	
		$.metadata.setType("attr", "validate");
		var v_init = formular_step_form.validate({
			submitHandler: function(){
				if (confirm('ยืนยันการเพิ่มขั้นตอน!')) {
					ajax_load();
					$.post('RDManagement',formular_step_form.serialize(),function(resData){			
						ajax_remove();
						if (resData.status == 'success') {
							window.location.reload();
						} else {
							alert(resData.message);
						}
					},'json');
				}
			}
		});	
		
		formular_step_form.submit(function(){			
			v_init;					
			return false;
		});
		
		$('#ul_step').sortable({ opacity: 0.5, cursor: 'move'});
		
		$('.step_head').click(function(){
			$('#step_body_' + $(this).attr('id')).slideToggle('slow');
		});
	});
	
	function step_order(){
		if (confirm('ยืนยันการเปลี่ยนแปลงลำดับของขั้นตอน')) {
			var order = $('#ul_step').sortable('serialize');
			ajax_load();
			$.post('RDManagement',order + '&action=step_order&update_by=<%=securProfile.getPersonal().getPer_id()%>&mat_code=<%=master.getMat_code()%>',function(data){
				ajax_remove();
				if (data.status == 'success') {
					window.location.reload();
				} else {
					alert(data.message);
				}
			},'json');
		}
	}
	
	function delete_material(mat_code,step,material){
		if (confirm('ยืนยันการลบวัตถุดิบ!')) {
			ajax_load();
			$.post('RDManagement',{'mat_code':mat_code,'step':step,'material':material,'action':'step_material_delete'},function(resData){
				ajax_remove();
				if (resData.status == 'success') {
					window.location.reload();
				} else {
					alert(resData.message);
				}
			},'json');
		}
	}
	
	function rd_approve(){
		if(confirm('ยืนยันการสร้างสูตร\n\rรหัสสินค้า :<%=master.getMat_code()%>\n\rชื่อสูตร :<%=master.getDescription()%>')){
			
			var sumQty = $('#sumQty').val()*1;
			if(sumQty==100){
				ajax_load();
				$.post('RDManagement',{'mat_code':'<%=master.getMat_code()%>','update_by':'<%=securProfile.getPersonal().getPer_id()%>','action':'RD_Approve'},function(resData){
					ajax_remove();
					if (resData.status == 'success') {					
						window.location='formular_view.jsp?mat_code=<%=master.getMat_code()%>';
					} else {
						alert(resData.status);
					}
				},'json');
			}else{
				alert('อัตราส่วนที่ทำการเพิ่มไม่ครบ 100 % กรุณาเพิ่มเติมหรือแก้ไขอัตราส่วน');
			}
		}
	}
	
	function delete_step(mat_code,step,obj){
		if (confirm($(obj).attr('title'))) {
			ajax_load();
			$.post('RDManagement',{'action':'formular_step_delete','mat_code':mat_code,'step':step},function(data){
				ajax_remove();
				if (data.status == 'success') {
					window.location.reload();
				} else {
					alert(data.message);
				}
			},'json');
		}
	}
</script>

</head>
<body>
<input type="hidden" name="sumQty" id="sumQty" value="<%=sumQty%>">
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">เพิ่ม / ลบ / แก้ไข ขั้นตอนการผลิต</div>
				<div class="right m_right15">
					<button onclick="window.location='<%=LinkControl.link("formular_search.jsp", (List) session.getAttribute("F_SEARCH"))%>';" class="btn_box">กลับไปหน้าค้นหาสูตร</button>
				</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
				
				<fieldset class="fset s900">
					<legend>&nbsp;ข้อมูลพื้นฐาน&nbsp;</legend>
					<div class="left s500">
						<table width="100%" id="tb_formular" border="0">
							<tbody>		
								<tr>
									<td width="130" align="left">ชื่อสินค้า</td>
									<td width="400">: <%=master.getDescription()%></td>
								</tr>
								<tr>
									<td width="100" align="left">รหัสสินค้า</td>
									<td width="250">: <%=master.getUISubCat().getUICat().getUIGroup().getGroup_id() + "-" + master.getUISubCat().getUICat().getCat_name_short() + ((master.getUISubCat().getSub_cat_name_th().length() > 0)?"-" + master.getUISubCat().getSub_cat_name_short():"") + "-" + master.getMat_code()%></td>
								</tr>
								<tr>
									<td width="130" align="left">กลุ่ม</td>
									<td width="400">: <%=master.getUISubCat().getUICat().getUIGroup().getGroup_name_th() %></td>
								</tr>
								<tr>
									<td align="left">ชนิด</td>
									<td>: <%=master.getUISubCat().getUICat().getCat_name_th()%></td>
								</tr>			
								
								<!-- ชนิดย่อย -->
								<tr>
									<td align="left">ชนิดย่อย</td>
									<td>: <%=(master.getUISubCat().getSub_cat_name_th().length() > 0)?master.getUISubCat().getSub_cat_name_th():""%></td>
								</tr>
								<tr>
									<td width="100" align="left">รหัสเดิม</td>
									<td width="250">: <%=master.getRef_code()%></td>
								</tr>
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr>
									<td>ลักษณะการจัดเก็บ</td>
									<td>: <%=(master.getFifo_flag().equalsIgnoreCase("y"))?"FIFO":"Non FIFO"%></td>
								</tr>
								<tr>
									<td>ราคากลาง</td>
									<td>: <%=master.getPrice()%></td>
								</tr>
								<tr>
									<td>ต้นทุน</td>
									<td>: <%=master.getCost()%></td>
								</tr>																															
							</tbody>		
						</table>
					</div>
					
					<div class="left s350">
						<table width="100%" id="tb_formular" border="0">
							<tbody>		
								<tr>
									<td width="130" align="left">Brand สินค้า</td>
									<td width="250">: <%=master.getBrand_name()%></td>
								</tr>
								<tr>
									<td align="left">หมายเลขอ้างอิง</td>
									<td>: <%=formular.getRef_no()%></td>
								</tr>
								<tr>
									<td align="left">Customer name</td>
									<td>: <%=formular.getCus_id()%></td>
								</tr>
								<tr>
									<td align="left">R&amp;D Yield</td>
									<td>: <%=formular.getYield()%></td>
								</tr>
								<tr>
									<td width="100" align="left">Colour Tone</td>
									<td width="250">: <%=formular.getColour_tone()%></td>
								</tr>
								<tr>
									<td align="left">Colour Tone Detail</td>
									<td>: <%=formular.getColour_tone_detail()%></td>
								</tr>
								<tr>
									<td align="left">Date Matching</td>
									<td>: <%=WebUtils.getDateValue(formular.getDate_matching())%></td>
								</tr>
								<tr>
									<td align="left">ปริมาตรบรรจุ</td>
									<td>: <%=formular.getVolume()%></td>
								</tr>
								<tr>
									<td>หน่วยนับ</td>
									<td>: <%=master.getStd_unit()%></td>
								</tr>
								<tr>
									<td>ลักษณะบรรจุภัณฑ์</td>
									<td>: <%=master.getDes_unit()%></td>
								</tr>
								<tr>
									<td valign="top" align="left">หมายเหตุ</td>
									<td valign="top">: <%=formular.getRemark().replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>")%></td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<div class="clear"></div>
					
					<div class="txt_center">
						<button class="btn_box" onclick="window.location='formular_new.jsp?mat_code=<%=formular.getMat_code()%>';">แก้ไขข้อมูลพื้นฐาน</button>
					</div>
				</fieldset>
				

				<ul id="ul_step">
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
						
						if (step.getProcess().equalsIgnoreCase("Quality check") || step.getProcess().equalsIgnoreCase("Packing") || step.getProcess().equalsIgnoreCase("Label") || step.getProcess().equalsIgnoreCase("Keepstock") || step.getProcess().equalsIgnoreCase("Cleaning")){
							tr_weighing="class=\"hide\"";tr_machine="class=\"hide\"";tr_time="class=\"hide\"";tr_speed="class=\"hide\"";tr_met_grain_size="class=\"hide\"";tr_met_volume="class=\"hide\"";tr_temp="class=\"hide\"";tr_mix_spray="class=\"hide\"";tr_fillter="class=\"hide\"";
						}
					%>
				<li id="li_step_<%=step.getStep()%>">
				<fieldset class="fset s900">
					<legend>&nbsp;ขั้นตอนการผลิต&nbsp;</legend>
					<div class="box txt_bold">
						<div class="left step_head pointer" id="<%=i%>"><span style="color: #ccc;">ขั้นตอนที่ :</span> <%=i%> - <%=RDFormularStep.step(step.getProcess()).toUpperCase()%></div>
						<div class="right">
							<button class="btn_box btn_warn m_left5" title="ยืนยันการลบขั้นตอนที่ <%=i%>" onclick="javascript: delete_step('<%=formular.getMat_code()%>','<%=step.getStep()%>',this);">ลบขั้นตอน</button>
							<button class="btn_box thickbox m_left5" lang="formular_step_edit.jsp?mat_code=<%=formular.getMat_code()%>&step=<%=step.getStep()%>&display_step=<%=i%>&width=900&height=250" title="แก้ไขขั้นตอนที่ <%=i%>">แก้ไข</button>
							<button class="btn_box thickbox m_left5" lang="formular_<%=(step.getProcess().equalsIgnoreCase("Packing") || step.getProcess().equalsIgnoreCase("Label") || step.getProcess().equalsIgnoreCase("Keepstock"))?"packing":"material"%>_add.jsp?mat_code=<%=formular.getMat_code()%>&step=<%=step.getStep()%>&width=500&height=200" title="เพิ่มวัตถุดิบ - ขั้นตอนที่ <%=i%>">เพิ่มวัตถุดิบ</button>
						</div>
						<div class="clear" style="padding-bottom: 0px;margin-bottom: 0px;"></div>
					</div>
					
					<div id="step_body_<%=i%>">
						
						<div class="left s100 m_top5">
							<img src="../images/process/<%=step.getProcess().toLowerCase()%>.png" style="border: 3px #4E4730 solid;">
						</div>
						
						<div class="left s450">
						
							<table width="100%" border="0">
								<tbody>
									<tr <%=tr_machine%>>
										<td width="100" align="left">Machine</td>
										<td width="350">: <%=step.getMachine()%></td>
									</tr>
									<tr <%=tr_time%>>
										<td width="100" align="left">เวลา</td>
										<td width="350">: <%=step.getTime_start() + ((step.getTime_to().length() > 0)?" - " + step.getTime_to():"") + " " + step.getTime_unit()%></td>
									</tr>
									<tr <%=tr_speed%>>
										<td width="100" align="left">ความเร็วรอบ</td>
										<td width="350">: <%=step.getSpeed_start() + ((step.getSpeed_to().length() > 0)?" - " + step.getSpeed_to():"") + " " + step.getSpeed_unit()%></td>
									</tr>
									<tr <%=tr_weighing%>>
										<td width="100" align="left">ค่าเบี่ยงเบน</td>
										<td width="350">: <%=step.getDeviation()%></td>
									</tr>
									<tr <%=tr_fillter%>>
										<td width="100" align="left">ขนาดความถี่</td>
										<td width="350">: <%=step.getFillter()%></td>
									</tr>
									<tr>
										<td width="100" align="left">remark</td>
										<td width="350">: <%=step.getRemark()%></td>
									</tr>
								</tbody>		
							</table>
						</div>
						
						<div class="left s350">
							<table width="100%" border="0">
								<tbody>
									<tr <%=tr_mix_spray%>>
										<td width="100" align="left">ความหนืดที่พ่น</td>
										<td width="250">: <%=step.getStickiness()%></td>
									</tr>
									<tr <%=tr_mix_spray%>>
										<td width="100" align="left">แรงดันลม</td>
										<td width="250">: <%=step.getPressure_wind()%></td>
									</tr>
									<tr <%=tr_mix_spray%>>
										<td width="100" align="left">แรงดันสี</td>
										<td width="250">: <%=step.getPressure_color()%></td>
									</tr>
									<tr <%=tr_mix_spray%>>
										<td width="100" align="left">ระยะห่าง</td>
										<td width="250">: <%=step.getInterval_()%></td>
									</tr>
									<tr <%=tr_mix_spray%>>
										<td width="100" align="left">จำนวนรอบพ่น</td>
										<td width="250">: <%=step.getSpray_cyc()%></td>
									</tr>
									<tr <%=tr_met_grain_size%>>
										<td width="100" align="left">ขนาดเม็ดทราย</td>
										<td width="250">: <%=step.getMet_grain_size_start() + ((step.getMet_grain_size_to().length() > 0)?" - " + step.getMet_grain_size_to():"") + " " + step.getMet_grain_size_unit()%></td>
									</tr>
									<tr <%=tr_met_volume%>>
										<td width="100" align="left">จำนวนเม็ดทราย</td>
										<td width="250">: <%=step.getMet_volume_start() + ((step.getMet_volume_to().length() > 0)?" - " + step.getMet_volume_to():"") + " " + step.getMet_volume_unit()%></td>
									</tr>
									<tr <%=tr_temp%>>
										<td width="100" align="left">อุณหภูมิ</td>
										<td width="250">: <%=step.getTemp_start() + ((step.getTemp_to().length() > 0)?" - " + step.getTemp_to():"") + " " + step.getTemp_unit()%></td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="clear"></div>
						
						<%
						List<RDFormularDetail> listDetail = step.getUIDetail();
						if (listDetail.size() > 0){
						%>
						<div class="s800 right">
						<table class="bg-image s800">
							<thead>
								<tr>
									<th valign="top" align="center" width="9%">ลำดับ</th>
									<th valign="top" align="center" width="35%">รหัสวัตถุดิบ</th>
									<th valign="top" align="center" width="15%"><%=(step.getProcess().equalsIgnoreCase("Packing") || step.getProcess().equalsIgnoreCase("Label") || step.getProcess().equalsIgnoreCase("Keepstock"))?"จำนวน":"อัตราส่วน %"%></th>
									<th valign="top" align="center" width="25%">หมายเหตุ</th>				
									<th valign="top" align="center" width="8%"></th>
									<th valign="top" align="center" width="8%"></th>
								</tr>
							</thead>
							<tbody id="material_list">
								<%
								int j = 0;
								for(RDFormularDetail detail:listDetail){
									j++;
								%>
								<tr>
									<td align="center"><%=j%></td>
									<td><%=detail.getMaterial() + " - " + detail.getUIMat().getDescription()%></td>
									<td align="right"><%=(step.getProcess().equalsIgnoreCase("Packing") || step.getProcess().equalsIgnoreCase("Label") || step.getProcess().equalsIgnoreCase("Keepstock"))?detail.getUsage_():detail.getQty()%></td>
									<td><%=detail.getRemark()%></td>
									<td align="center"><button class="thickbox btn_box" lang="formular_<%=(step.getProcess().equalsIgnoreCase("Packing") || step.getProcess().equalsIgnoreCase("Label") || step.getProcess().equalsIgnoreCase("Keepstock"))?"packing":"material"%>_edit.jsp?mat_code=<%=master.getMat_code()%>&step=<%=step.getStep()%>&material=<%=detail.getMaterial()%>&width=500&height=200">แก้ไข</button></td>
									<td align="center"><button class="btn_box btn_warn" onclick="delete_material('<%=master.getMat_code()%>','<%=step.getStep()%>','<%=detail.getMaterial()%>');">ลบ</button></td>
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
						%>
						
					</div>
					
				</fieldset>
				</li>
				<%
				}
				%>
				</ul>
				
				<div class="center txt_center m_top10">
					<button id="btn_step_order" class="btn_box btn_confirm" onclick="javascript: step_order();">บันทึกตำแหน่งของขั้นตอน</button>
				</div>
				
				<div class="dot_line center m_top20"></div>
				<div class="dot_line center"></div>
				
				<!-- ******** for add Step ********* -->
				
				<fieldset class="fset s900 m_top10">
					<legend>&nbsp;กำหนดขั้นตอนการผลิต&nbsp;</legend>
					<form id="formular_step_form" onsubmit="return false;">
						
						<div class="left s500">
							<table width="100%" id="tb_formular" border="0">
								<tbody>
									<tr>
										<td width="100" align="left">ขั้นตอนที่</td>
										<td width="400">: 
											<input type="text" value="<%=i+1%>" class="txt_box txt_center s30" readonly="readonly">
											<input type="hidden" name="step" value="<%=RDFormularStep.selectStepNo(master.getMat_code())%>" class="txt_box txt_center s30" readonly="readonly">
										</td>
									</tr>
									<tr>
										<td align="left">Process</td>
										<td>:
											<bmp:ComboBox name="process" onChange="show_step(this);" styleClass="txt_box s200">
												<bmp:option value="Weighing" text="Weighing / การชั่ง"></bmp:option>
												<bmp:option value="Stiring" text="Stiring / การปั่นผสม"></bmp:option>
												<bmp:option value="Grinding" text="Grinding / การบด"></bmp:option>
												<bmp:option value="Letdown" text="Letdown / การเลทดาล์ว"></bmp:option>
												<bmp:option value="Adjust" text="Adjust / การเติมแต่ง"></bmp:option>
												<bmp:option value="Mixing Spray" text="Mixing Spray / การผสมพ่น"></bmp:option>
												<bmp:option value="Baking" text="Baking / การอบ"></bmp:option>
												<bmp:option value="Quality check" text="Quality check / การตรวจสอบ"></bmp:option>
												<bmp:option value="Fillter" text="Fillter / การกรอง"></bmp:option>
												<bmp:option value="Packing" text="Packing / การบรรจุ"></bmp:option>
												<bmp:option value="Label" text="Label / การติดฉลาก"></bmp:option>
												<bmp:option value="Keepstock" text="Keepstock / การจัดเก็บ"></bmp:option>
												<bmp:option value="Cleaning" text="Cleaning / การล้าง"></bmp:option>
											</bmp:ComboBox>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<script type="text/javascript">
							function show_step(obj){
								var div_weighing = $('#div_weighing');
								var div_machine = $('#div_machine');
								var div_time = $('#div_time');
								var div_speed = $('#div_speed');
								var div_met_grain_size = $('#div_met_grain_size');
								var div_met_volume = $('#div_met_volume');
								var div_temp = $('#div_temp');
								var div_mix_spray = $('#div_mix_spray');
								var div_fillter = $('#div_fillter');
								
								var val = $(obj).val();
								switch (val) {
								case 'Weighing':	div_weighing.show();div_machine.show();div_time.hide();div_speed.hide();div_met_grain_size.hide();div_met_volume.hide();div_temp.hide();div_mix_spray.hide();div_fillter.hide();
									break;
								case 'Stiring': 	div_weighing.hide();div_machine.show();div_time.show();div_speed.show();div_met_grain_size.hide();div_met_volume.hide();div_temp.hide();div_mix_spray.hide();div_fillter.hide();
									break;
								case 'Grinding': 	div_weighing.hide();div_machine.show();div_time.show();div_speed.show();div_met_grain_size.show();div_met_volume.hide();div_temp.show();div_mix_spray.hide();div_fillter.hide();
									break;
								case 'Letdown': 	div_weighing.hide();div_machine.hide();div_time.show();div_speed.hide();div_met_grain_size.hide();div_met_volume.hide();div_temp.hide();div_mix_spray.hide();div_fillter.hide();
									break;
								case 'Adjust': 		div_weighing.show();div_machine.show();div_time.hide();div_speed.hide();div_met_grain_size.hide();div_met_volume.hide();div_temp.hide();div_mix_spray.hide();div_fillter.hide();
									break;
								case 'Mixing Spray':div_weighing.hide();div_machine.show();div_time.hide();div_speed.hide();div_met_grain_size.hide();div_met_volume.hide();div_temp.hide();div_mix_spray.show();div_fillter.hide();
									break;
								case 'Baking': 		div_weighing.hide();div_machine.show();div_time.show();div_speed.hide();div_met_grain_size.hide();div_met_volume.hide();div_temp.show();div_mix_spray.hide();div_fillter.hide();
									break;
								case'Quality check':div_weighing.hide();div_machine.hide();div_time.hide();div_speed.hide();div_met_grain_size.hide();div_met_volume.hide();div_temp.hide();div_mix_spray.hide();div_fillter.hide();
									break;
								case 'Fillter': 	div_weighing.hide();div_machine.hide();div_time.hide();div_speed.hide();div_met_grain_size.hide();div_met_volume.hide();div_temp.hide();div_mix_spray.hide();div_fillter.show();
									break;
								case 'Packing': 	div_weighing.hide();div_machine.hide();div_time.hide();div_speed.hide();div_met_grain_size.hide();div_met_volume.hide();div_temp.hide();div_mix_spray.hide();div_fillter.hide();
									break;
								case 'Label': 		div_weighing.hide();div_machine.hide();div_time.hide();div_speed.hide();div_met_grain_size.hide();div_met_volume.hide();div_temp.hide();div_mix_spray.hide();div_fillter.hide();
									break;
								case 'Keepstock': 	div_weighing.hide();div_machine.hide();div_time.hide();div_speed.hide();div_met_grain_size.hide();div_met_volume.hide();div_temp.hide();div_mix_spray.hide();div_fillter.hide();
									break;
								case 'Cleaning': 	div_weighing.hide();div_machine.hide();div_time.hide();div_speed.hide();div_met_grain_size.hide();div_met_volume.hide();div_temp.hide();div_mix_spray.hide();div_fillter.hide();
								break;
								default:
									break;
								}
							}
						</script>
						
						<div class="left s350">
							
							<div id="div_machine">
								<table width="100%" border="0">
									<tbody>		
										<tr>
											<td width="100" align="left">Machine</td>
											<td width="250">: <input type="text" name="machine" value="" autocomplete="off" class="txt_box s200"></td>
										</tr>
									</tbody>
								</table>
							</div>
							
							<div id="div_weighing">
								<table width="100%" border="0">
									<tbody>		
										<tr>
											<td width="100" align="left">ค่าเบี่ยงเบน</td>
											<td width="250">: <input type="text" name="deviation" value="" autocomplete="off" class="txt_box s200"></td>
										</tr>
									</tbody>
								</table>
							</div>
							
							<div id="div_fillter" class="hide">
								<table width="100%" border="0">
									<tbody>		
										<tr>
											<td width="100" align="left">ขนาดความถี่</td>
											<td width="250">: <input type="text" name="fillter" value="" autocomplete="off" class="txt_box s200"></td>
										</tr>
									</tbody>
								</table>
							</div>
							
							<div id="div_mix_spray" class="hide">
								<table width="100%" border="0">
									<tbody>		
										<tr>
											<td width="100" align="left">ความหนืดที่พ่น</td>
											<td width="250">: <input type="text" name="stickiness" value="" autocomplete="off" class="txt_box s200"></td>
										</tr>
										<tr>
											<td width="100" align="left">แรงดันลม</td>
											<td width="250">: <input type="text" name="pressure_wind" value="" autocomplete="off" class="txt_box s200"></td>
										</tr>
										<tr>
											<td width="100" align="left">แรงดันสี</td>
											<td width="250">: <input type="text" name="pressure_color" value="" autocomplete="off" class="txt_box s200"></td>
										</tr>
										<tr>
											<td width="100" align="left">ระยะห่าง</td>
											<td width="250">: <input type="text" name="interval_" value="" autocomplete="off" class="txt_box s200"></td>
										</tr>
										<tr>
											<td width="100" align="left">จำนวนรอบพ่น</td>
											<td width="250">: <input type="text" name="spray_cyc" value="" autocomplete="off" class="txt_box s200"></td>
										</tr>
									</tbody>
								</table>
							</div>
							
							<div id="div_time" class="hide">
								<table width="100%" border="0">
									<tbody>		
										<tr>
											<td width="100" align="left">เวลา</td>
											<td width="250">: 
												<input type="text" name="time_start" value="" autocomplete="off" class="txt_box s60"> - 
												<input type="text" name="time_to" value="" autocomplete="off" class="txt_box s60"> 
												<%ListUtil.getTimeUnit(pageContext, "time_unit", "", 60);%>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							
							<div id="div_speed" class="hide">
								<table width="100%" border="0">
									<tbody>		
										<tr>
											<td width="100" align="left">ความเร็วรอบ</td>
											<td width="250">: 
												<input type="text" name="speed_start" value="" autocomplete="off" class="txt_box s60"> - 
												<input type="text" name="speed_to" value="" autocomplete="off" class="txt_box s60"> 
												<bmp:ComboBox name="speed_unit" styleClass="txt_box s60">
													<bmp:option value="rpm" text="rpm"></bmp:option>
												</bmp:ComboBox>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							
							<div id="div_met_grain_size" class="hide">
								<table width="100%" border="0">
									<tbody>		
										<tr>
											<td width="100" align="left">ขนาดเม็ดทราย</td>
											<td width="250">: 
												<input type="text" name="met_grain_size_start" value="" autocomplete="off" class="txt_box s60"> - 
												<input type="text" name="met_grain_size_to" value="" autocomplete="off" class="txt_box s60"> 
												<bmp:ComboBox name="met_grain_size_unit" styleClass="txt_box s60">
													<bmp:option value="mm." text="mm."></bmp:option>
												</bmp:ComboBox>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							
							<div id="div_met_volume" class="hide">
								<table width="100%" border="0">
									<tbody>		
										<tr>
											<td width="100" align="left">จำนวนเม็ดทราย</td>
											<td width="250">: 
												<input type="text" name="met_volume_start" value="" autocomplete="off" class="txt_box s60"> - 
												<input type="text" name="met_volume_to" value="" autocomplete="off" class="txt_box s60"> 
												<bmp:ComboBox name="met_volume_unit" styleClass="txt_box s60">
													<bmp:option value="xxx" text="xxx"></bmp:option>
												</bmp:ComboBox>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							
							<div id="div_temp" class="hide">
								<table width="100%" border="0">
									<tbody>		
										<tr>
											<td width="100" align="left">อุณหภูมิ</td>
											<td width="250">: 
												<input type="text" name="temp_start" value="" autocomplete="off" class="txt_box s60"> - 
												<input type="text" name="temp_to" value="" autocomplete="off" class="txt_box s60"> 
												<bmp:ComboBox name="temp_unit" styleClass="txt_box s60">
													<bmp:option value="C" text="C"></bmp:option>
													<bmp:option value="F" text="F"></bmp:option>
												</bmp:ComboBox>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							
							<div>
								<table width="100%" border="0">
									<tbody>		
										<tr>
											<td width="100" align="left">remark</td>
											<td width="250">: <input type="text" name="remark" value="" autocomplete="off" class="txt_box s200"></td>
										</tr>
									</tbody>
								</table>
							</div>
							
						</div>
						
						<div class="clear"></div>
						
						<div class="txt_center">
							<input type="submit" class="btn_box btn_confirm" value="เพิ่มขั้นตอน">
							<input type="hidden" name="mat_code" value="<%=formular.getMat_code()%>">
							<input type="hidden" name="action" value="formular_step_add">
							<input type="hidden" name="create_by" value="<%=securProfile.getPersonal().getPer_id()%>">
						</div>
					</form>
				
				</fieldset>
				
				<div class="dot_line s500 center m_top20"></div>
				<div class="txt_center m_top20">
					<button class="btn_box btn_confirm" onclick="javascript: rd_approve();">ยืนยันการสร้างสูตร</button>
					<button class="btn_box" onclick="javascript: window.location='formular_view.jsp?mat_code=<%=master.getMat_code()%>';">ไม่ยืนยันการสร้างสูตร</button>
				</div>
				<div class="m_top20"></div>
				
			</div>
		</div>
	</div>
	<jsp:include page="../index/footer.jsp"></jsp:include>
	
</div>

</body>
</html>