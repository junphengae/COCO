
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
InventoryMaster master = new InventoryMaster();
RDFormular formular = new RDFormular();
WebUtils.bindReqToEntity(formular, request);

RDFormular.select(formular);
master = formular.getUIMat();
RDFormularInfo fmInfo = formular.getUIInfo();

float sumQty = RDFormularDetail.calSumQtyByCondition(formular.getMat_code());
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
<title>Step for Formular</title>


</head>
<body style="font-size: 18px;" onload="setPrint();">
<div class="wrap_print">
	<div class="wrap_body">
		<div style="margin-top: 80px;"></div>
		<div class="body_content">
			<div class="content_head">
				<div class="txt_center">แบบฟอร์มการผลิต</div>
				<div class="clear"></div>
			</div>
			
			<div class="content_body">
					<div class="left m_left50">ข้อมูลพื้นฐาน</div>
					<div class="clear"></div>
					<div class="left s500 m_left50">
						<table class="tb" width="100%" id="tb_formular" border="0">
							<tbody>	
								<tr>
									<td width="130" align="left">ชื่อสินค้า</td>
									<td width="400">: <span id="mat_desc"><%=master.getDescription()%></span></td>
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
								<tr>
									<td align="left">ชนิดย่อย</td>
									<td>: <%=(master.getUISubCat().getSub_cat_name_th().length() > 0)?master.getUISubCat().getSub_cat_name_th() + " [" + master.getUISubCat().getSub_cat_name_short() + "]":""%></td>
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
					
					<div class="left s400">
						<table class="tb" width="100%" id="tb_formular" border="0">
							<tbody>		
								<tr>
									<td width="135" align="left">Brand สินค้า</td>
									<td width="250">: <%=master.getBrand_name()%></td>
								</tr>
								<tr>
									<td align="left">หมายเลขอ้างอิง</td>
									<td>: <%=formular.getRef_no()%></td>
								</tr>
								<tr>
									<td align="left">R&amp;D Yield</td>
									<td>: <%=formular.getYield()%></td>
								</tr>
								<tr>
									<td align="left">Colour Tone</td>
									<td>: <%=formular.getColour_tone()%></td>
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
				
				<fieldset class="s900 center">
					<legend>&nbsp;Formular Specification&nbsp;</legend>
					
					<div id="div_info">
						<table width="100%">
							<tbody>
								<tr>
									<td width="60%">
										
										<table width="100%">
											<tbody>
												<tr>
													<td width="40%">ความแข็ง/Solidity</td>
													<td width="60%">: <%=fmInfo.getSolidity()%></td>
												</tr>
												<tr>
													<td>ความละเอียดของสี/Grain size</td>
													<td>: <%=fmInfo.getGrain_size()%> micron</td>
												</tr>
												<tr>
													<td>ขนาดเม็ดทราย/Met grain size</td>
													<td>: <%=fmInfo.getMet_grain_size()%> <%=fmInfo.getMet_grain_size_unit()%></td>
												</tr>
												<tr>
													<td>ปริมาณเม็ดทราย/Met volume</td>
													<td>: <%=fmInfo.getMet_volume()%> <%=fmInfo.getMet_volume_unit()%></td>
												</tr>
												<tr>
													<td>ความถ่วงจำเพาะ/Specific gravity</td>
													<td>: <%=fmInfo.getSpecific_gravity()%></td>
												</tr>
												<tr>
													<td>ความหนืด/Viscosity</td>
													<td>: <%=fmInfo.getViscosity()%></td>
												</tr>
												<tr>
													<td>ความเงา/Gloss</td>
													<td>: <%=fmInfo.getGloss()%></td>
												</tr>
												<tr>
													<td>ความหนา/Thickness</td>
													<td>: <%=fmInfo.getThickness()%></td>
												</tr>
											</tbody>
										</table>
										
									</td>
									<td width="40%" valign="top">
										
										<fieldset>
											<legend>&nbsp;CR-400&nbsp;</legend>
											
											<table width="100%">
												<tbody>
													<tr>
														<td width="10%">L</td>
														<td width="40%">: <%=fmInfo.getShade_l()%></td>
														<td width="10%">A</td>
														<td width="40%">: <%=fmInfo.getShade_a()%></td>
													</tr>
													<tr>
														<td>B</td>
														<td>: <%=fmInfo.getShade_b()%></td>
														<td>△E</td>
														<td>: <%=fmInfo.getShade_e()%></td>
													</tr>
												</tbody>
											</table>
											
										</fieldset>
										
									</td>
								</tr>
							</tbody>
						</table>
						
						<div class="dot_line"></div>
						
						<table width="100%">
							<tbody>
								<tr>
									<td width="60%">
										
										<table width="100%">
											<tbody>
												<tr>
													<td width="40%">spray pass</td>
													<td width="60%">: <%=fmInfo.getSpray_pass()%></td>
												</tr>
												<tr>
													<td>spray gun model</td>
													<td>: <%=fmInfo.getSpray_gun_model()%></td>
												</tr>
												<tr>
													<td>nozzle no</td>
													<td>: <%=fmInfo.getNozzle_no()%></td>
												</tr>
												<tr>
													<td>air pressor</td>
													<td>: <%=fmInfo.getAir_pressor()%></td>
												</tr>
												<tr>
													<td>filter no</td>
													<td>: <%=fmInfo.getFilter_no()%></td>
												</tr>
												<tr>
													<td>plastic</td>
													<td>: <%=fmInfo.getPlastic()%></td>
												</tr>
												<tr>
													<td>colour plate</td>
													<td>: <%=fmInfo.getColour_plate()%></td>
												</tr>
												<tr>
													<td>life time</td>
													<td>: <%=fmInfo.getLife_time()%></td>
												</tr>
											</tbody>
										</table>
									</td>
									<td></td>
								</tr>
								<tr>
									<td colspan="2">
										<table width="100%">
											<tbody>
												<tr valign="top">
													<td width="25%">หมายเหตุ : </td>
													<td width="75%" valign="top">
														<%=fmInfo.getRemark().replaceAll("\n", "<br>").replaceAll(" ", "&nbsp;")%>
													</td>
												</tr>
											</tbody>
										</table>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</fieldset>
				
				<fieldset class="s900 center">
					<legend>&nbsp;ขั้นตอนการผลิต&nbsp;</legend>
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
			
					
					<div class="s_auto txt_bold">
						<div class="left">ขั้นตอนที่ : <%=i%> - <%=RDFormularStep.step(step.getProcess()).toUpperCase()%></div>
						<div class="right"></div>
						<div class="clear" style="padding-bottom: 0px;margin-bottom: 0px;"></div>
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
						<table class="tb" width="100%" border="0">
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
					<table class="tb s800">
						<thead>
							<tr>
								<th valign="top" align="center" width="12%">ลำดับ</th>
								<th valign="top" align="center" width="40%">รหัสวัตถุดิบ</th>
								<th valign="top" align="center" width="20%"><%=(step.getProcess().equalsIgnoreCase("Packing") || step.getProcess().equalsIgnoreCase("Label") || step.getProcess().equalsIgnoreCase("Keepstock"))?"จำนวน":"อัตราส่วน %"%></th>
								<th valign="top" align="center" width="28%">หมายเหตุ</th>
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
					
				<br>
				<%
				}
				%>
				
				</fieldset>
				
			</div>
		</div>
	</div>
</div>
</body>
</html>