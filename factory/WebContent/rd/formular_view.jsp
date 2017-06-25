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

<link href="../css/style.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/unit.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/loading.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/table.css" rel="stylesheet" type="text/css" media="all">

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

</head>
<body>
<input type="hidden" name="sumQty" id="sumQty" value="<%=sumQty%>">
<div class="wrap_all">
	<jsp:include page="../index/header.jsp"></jsp:include>
	
	<div class="wrap_body">
		<div class="body_content">
			<div class="content_head">
				<div class="left">ขั้นตอนการผลิต</div>
				<div class="right m_right15">
					<button onclick="window.location='formular_step.jsp?mat_code=<%=formular.getMat_code()%>';" class="btn_box btn_warn">แก้ไขขั้นตอน</button>
					<button lang="formular_clone.jsp?mat_code=<%=formular.getMat_code()%>&height=200" class="btn_box btn_confirm thickbox" title="สร้างสูตรใกล้เคียง">สร้างสูตรใกล้เคียง</button>
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
									<td>: <%=(master.getUISubCat().getSub_cat_name_th().length() > 0)?master.getUISubCat().getSub_cat_name_th() :""%></td>
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
						<table width="100%" id="tb_formular" border="0">
							<tbody>		
								<tr>
									<td align="left">R&amp;D Yield</td>
									<td>: <%=formular.getYield()%></td>
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
					
				</fieldset>
				
	
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
				<fieldset class="fset s900">
					<legend>&nbsp;ขั้นตอนการผลิต&nbsp;</legend>
					<div class="box txt_bold">
						<div class="left"><span style="color: #ccc;">ขั้นตอนที่ :</span> <%=i%> - <%=RDFormularStep.step(step.getProcess()).toUpperCase()%></div>
						<div class="right"></div>
						<div class="clear" style="padding-bottom: 0px;margin-bottom: 0px;"></div>
					</div>
					
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
					
				</fieldset>
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