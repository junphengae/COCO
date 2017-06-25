<%@page import="com.bitmap.bean.util.ListUtil"%>
<%@page import="com.bitmap.bean.rd.RDFormularStep"%>
<%@page import="java.util.List"%>
<%@page import="com.bitmap.bean.rd.RDFormular"%>
<%@page import="com.bitmap.webutils.WebUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<%	
	String mat_code = WebUtils.getReqString(request, "mat_code");
	String step = WebUtils.getReqString(request, "step");
	String display_step = WebUtils.getReqString(request, "display_step");
	RDFormularStep rdStep = RDFormularStep.selectByCondition(mat_code, step);
%>

<form id="formular_step_edit_form" onsubmit="return false;">
	<div class="m_top10"></div>
	<div class="left s500">
		<table width="100%" id="tb_formular" border="0">
			<tbody>		
				<tr>
					<td width="100" align="left">ขั้นตอนที่</td>
					<td width="400">: <%=display_step%></td>
				</tr>
				<tr>
					<td align="left">Process</td>
					<td>: 
						<bmp:ComboBox name="process" onChange="show_step_edit($(this).val());" value="<%=rdStep.getProcess()%>" styleClass="txt_box s200">
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
						</bmp:ComboBox>
					</td>
				</tr>
			</tbody>		
		</table>
	</div>
	
	<script type="text/javascript">
		$(function(){
			show_step_edit('<%=rdStep.getProcess()%>');
			
			var formular_step_edit_form = $('#formular_step_edit_form');	
			$.metadata.setType("attr", "validate");
			var v_init = formular_step_edit_form.validate({
				submitHandler: function(){
					if (confirm('ยืนยันการแก้ไขขั้นตอนที่ <%=display_step%>!')) {
						ajax_load();
						$.post('RDManagement',formular_step_edit_form.serialize(),function(resData){			
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
			
			formular_step_edit_form.submit(function(){			
				v_init;					
				return false;
			});		
		});
		
		function show_step_edit(val){
			var div_edit_weighing = $('#div_edit_weighing');
			var div_edit_machine = $('#div_edit_machine');
			var div_edit_time = $('#div_edit_time');
			var div_edit_speed = $('#div_edit_speed');
			var div_edit_met_grain_size = $('#div_edit_met_grain_size');
			var div_edit_met_volume = $('#div_edit_met_volume');
			var div_edit_temp = $('#div_edit_temp');
			var div_edit_mix_spray = $('#div_edit_mix_spray');
			var div_edit_fillter = $('#div_edit_fillter');
			
			switch (val) {
			case 'Weighing':	div_edit_weighing.show();div_edit_machine.show();div_edit_time.hide();div_edit_speed.hide();div_edit_met_grain_size.hide();div_edit_met_volume.hide();div_edit_temp.hide();div_edit_mix_spray.hide();div_edit_fillter.hide();
				break;
			case 'Stiring': 	div_edit_weighing.hide();div_edit_machine.show();div_edit_time.show();div_edit_speed.show();div_edit_met_grain_size.hide();div_edit_met_volume.hide();div_edit_temp.hide();div_edit_mix_spray.hide();div_edit_fillter.hide();
				break;
			case 'Grinding': 	div_edit_weighing.hide();div_edit_machine.show();div_edit_time.show();div_edit_speed.show();div_edit_met_grain_size.show();div_edit_met_volume.hide();div_edit_temp.show();div_edit_mix_spray.hide();div_edit_fillter.hide();
				break;
			case 'Letdown': 	div_edit_weighing.hide();div_edit_machine.hide();div_edit_time.show();div_edit_speed.hide();div_edit_met_grain_size.hide();div_edit_met_volume.hide();div_edit_temp.hide();div_edit_mix_spray.hide();div_edit_fillter.hide();
				break;
			case 'Adjust': 		div_edit_weighing.show();div_edit_machine.show();div_edit_time.hide();div_edit_speed.hide();div_edit_met_grain_size.hide();div_edit_met_volume.hide();div_edit_temp.hide();div_edit_mix_spray.hide();div_edit_fillter.hide();
				break;
			case 'Mixing Spray':div_edit_weighing.hide();div_edit_machine.show();div_edit_time.hide();div_edit_speed.hide();div_edit_met_grain_size.hide();div_edit_met_volume.hide();div_edit_temp.hide();div_edit_mix_spray.show();div_edit_fillter.hide();
				break;
			case 'Baking': 		div_edit_weighing.hide();div_edit_machine.show();div_edit_time.show();div_edit_speed.hide();div_edit_met_grain_size.hide();div_edit_met_volume.hide();div_edit_temp.show();div_edit_mix_spray.hide();div_edit_fillter.hide();
				break;
			case'Quality check':div_edit_weighing.hide();div_edit_machine.hide();div_edit_time.hide();div_edit_speed.hide();div_edit_met_grain_size.hide();div_edit_met_volume.hide();div_edit_temp.hide();div_edit_mix_spray.hide();div_edit_fillter.hide();
				break;
			case 'Fillter': 	div_edit_weighing.hide();div_edit_machine.hide();div_edit_time.hide();div_edit_speed.hide();div_edit_met_grain_size.hide();div_edit_met_volume.hide();div_edit_temp.hide();div_edit_mix_spray.hide();div_edit_fillter.show();
				break;
			case 'Packing': 	div_edit_weighing.hide();div_edit_machine.hide();div_edit_time.hide();div_edit_speed.hide();div_edit_met_grain_size.hide();div_edit_met_volume.hide();div_edit_temp.hide();div_edit_mix_spray.hide();div_edit_fillter.hide();
				break;
			case 'Label': 		div_edit_weighing.hide();div_edit_machine.hide();div_edit_time.hide();div_edit_speed.hide();div_edit_met_grain_size.hide();div_edit_met_volume.hide();div_edit_temp.hide();div_edit_mix_spray.hide();div_edit_fillter.hide();
				break;
			case 'Keepstock': 	div_edit_weighing.hide();div_edit_machine.hide();div_edit_time.hide();div_edit_speed.hide();div_edit_met_grain_size.hide();div_edit_met_volume.hide();div_edit_temp.hide();div_edit_mix_spray.hide();div_edit_fillter.hide();
				break;
			default:
				break;
			}
		}
	</script>
	
	<div class="left s350">
		
		<div class="m_top20"></div>
		
		<div id="div_edit_machine">
			<table width="100%" border="0">
				<tbody>		
					<tr>
						<td width="100" align="left">Machine</td>
						<td width="250">: <input type="text" name="machine" value="<%=rdStep.getMachine()%>" autocomplete="off" class="txt_box s200"></td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div id="div_edit_weighing">
			<table width="100%" border="0">
				<tbody>		
					<tr>
						<td width="100" align="left">ค่าเบี่ยงเบน</td>
						<td width="250">: <input type="text" name="deviation" value="<%=rdStep.getDeviation()%>" autocomplete="off" class="txt_box s200"></td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div id="div_edit_fillter" class="hide">
			<table width="100%" border="0">
				<tbody>		
					<tr>
						<td width="100" align="left">ขนาดความถี่</td>
						<td width="250">: <input type="text" name="fillter" value="<%=rdStep.getFillter()%>" autocomplete="off" class="txt_box s200"></td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div id="div_edit_mix_spray" class="hide">
			<table width="100%" border="0">
				<tbody>		
					<tr>
						<td width="100" align="left">ความหนืดที่พ่น</td>
						<td width="250">: <input type="text" name="stickiness" value="<%=rdStep.getStickiness()%>" autocomplete="off" class="txt_box s200"></td>
					</tr>
					<tr>
						<td width="100" align="left">แรงดันลม</td>
						<td width="250">: <input type="text" name="pressure_wind" value="<%=rdStep.getPressure_wind()%>" autocomplete="off" class="txt_box s200"></td>
					</tr>
					<tr>
						<td width="100" align="left">แรงดันสี</td>
						<td width="250">: <input type="text" name="pressure_color" value="<%=rdStep.getPressure_color()%>" autocomplete="off" class="txt_box s200"></td>
					</tr>
					<tr>
						<td width="100" align="left">ระยะห่าง</td>
						<td width="250">: <input type="text" name="interval_" value="<%=rdStep.getInterval_()%>" autocomplete="off" class="txt_box s200"></td>
					</tr>
					<tr>
						<td width="100" align="left">จำนวนรอบพ่น</td>
						<td width="250">: <input type="text" name="spray_cyc" value="<%=rdStep.getSpray_cyc()%>" autocomplete="off" class="txt_box s200"></td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div id="div_edit_time" class="hide">
			<table width="100%" border="0">
				<tbody>		
					<tr>
						<td width="100" align="left">เวลา</td>
						<td width="250">: 
							<input type="text" name="time_start" value="<%=rdStep.getTime_start()%>" autocomplete="off" class="txt_box s60"> - 
							<input type="text" name="time_to" value="<%=rdStep.getTime_to()%>" autocomplete="off" class="txt_box s60"> 
							<%ListUtil.getTimeUnit(pageContext, "time_unit", rdStep.getTime_unit(), 60);%>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div id="div_edit_speed" class="hide">
			<table width="100%" border="0">
				<tbody>
					<tr>
						<td width="100" align="left">ความเร็วรอบ</td>
						<td width="250">: 
							<input type="text" name="speed_start" value="<%=rdStep.getSpeed_start()%>" autocomplete="off" class="txt_box s60"> - 
							<input type="text" name="speed_to" value="<%=rdStep.getSpeed_to()%>" autocomplete="off" class="txt_box s60"> 
							<bmp:ComboBox name="speed_unit" value="<%=rdStep.getSpeed_unit()%>" styleClass="txt_box s60">
								<bmp:option value="rpm" text="rpm"></bmp:option>
							</bmp:ComboBox>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div id="div_edit_met_grain_size" class="hide">
			<table width="100%" border="0">
				<tbody>
					<tr>
						<td width="100" align="left">ขนาดเม็ดทราย</td>
						<td width="250">: 
							<input type="text" name="met_grain_size_start" value="<%=rdStep.getMet_grain_size_start()%>" autocomplete="off" class="txt_box s60"> - 
							<input type="text" name="met_grain_size_to" value="<%=rdStep.getMet_grain_size_to()%>" autocomplete="off" class="txt_box s60"> 
							<bmp:ComboBox name="met_grain_size_unit" value="<%=rdStep.getMet_grain_size_unit()%>" styleClass="txt_box s60">
								<bmp:option value="mm." text="mm."></bmp:option>
							</bmp:ComboBox>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div id="div_edit_met_volume" class="hide">
			<table width="100%" border="0">
				<tbody>
					<tr>
						<td width="100" align="left">จำนวนเม็ดทราย</td>
						<td width="250">: 
							<input type="text" name="met_volume_start" value="<%=rdStep.getMet_volume_start()%>" autocomplete="off" class="txt_box s60"> - 
							<input type="text" name="met_volume_to" value="<%=rdStep.getMet_volume_to()%>" autocomplete="off" class="txt_box s60"> 
							<bmp:ComboBox name="met_volume_unit" value="<%=rdStep.getMet_volume_unit()%>" styleClass="txt_box s60">
								<bmp:option value="xxx" text="xxx"></bmp:option>
							</bmp:ComboBox>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div id="div_edit_temp" class="hide">
			<table width="100%" border="0">
				<tbody>
					<tr>
						<td width="100" align="left">อุณหภูมิ</td>
						<td width="250">: 
							<input type="text" name="temp_start" value="<%=rdStep.getTemp_start()%>" autocomplete="off" class="txt_box s60"> - 
							<input type="text" name="temp_to" value="<%=rdStep.getTemp_to()%>" autocomplete="off" class="txt_box s60"> 
							<bmp:ComboBox name="temp_unit" value="<%=rdStep.getTemp_unit()%>" styleClass="txt_box s60">
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
						<td width="250">: <input type="text" name="remark" value="<%=rdStep.getRemark()%>" class="txt_box s200"></td>
					</tr>
				</tbody>
			</table>
		</div>
		
	</div>
	
	<div class="clear"></div>
	
	<div class="txt_center m_top20">
		<input type="submit" class="btn_box btn_confirm" value="บันทึก">
		<input type="button" class="btn_box btn_warn" value="ปิดหน้าจอ" onclick="tb_remove();">
		<input type="hidden" name="mat_code" value="<%=mat_code%>">
		<input type="hidden" name="step" value="<%=step%>">
		<input type="hidden" name="action" value="formular_step_edit">
		<input type="hidden" name="update_by" value="<%=securProfile.getPersonal().getPer_id()%>">
	</div>
</form>