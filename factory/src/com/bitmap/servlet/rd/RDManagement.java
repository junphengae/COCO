package com.bitmap.servlet.rd;

import javax.servlet.ServletException;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.rd.RDFormular;
import com.bitmap.bean.rd.RDFormularDetail;
import com.bitmap.bean.rd.RDFormularInfo;
import com.bitmap.bean.rd.RDFormularStep;
import com.bitmap.bean.util.StatusUtil;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class RDManagement
 */
public class RDManagement extends ServletUtils {

	private static final long serialVersionUID = 1L;
    
    public RDManagement() {
        super();
    }
    
	public void doPost(ReqRes rr) throws ServletException {
		try{
			
			/* ----------- Formular Init ------------ */
			if (checkAction(rr, "formular_init")) {
				RDFormular entityRd = new RDFormular();
				WebUtils.bindReqToEntity(entityRd, rr.req);					
				
				InventoryMaster entity = new InventoryMaster();					
				WebUtils.bindReqToEntity(entity, rr.req);							
				
				if (entity.getMat_code().length() > 0) {
					//if(InventoryMaster.checkNameForEdit(entity)){
					//	kson.setError("ชื่อสูตรในการผลิตซ้ำ กรุณาตรวจสอบ");
					//	kson.setData("focus", "description");
					//}else{
						RDFormular.update(entityRd,entity);
						kson.setSuccess();
						kson.setGson("mat", gson.toJson(entityRd));
					//}
				} else {
					//if(InventoryMaster.checkName(entity)){
					//	kson.setError("ชื่อสูตรในการผลิตซ้ำ กรุณาตรวจสอบ");
					//	kson.setData("focus", "description");
					//}else{
						RDFormular.insert(entityRd, entity);
						
						kson.setSuccess(); 
						kson.setGson("mat", gson.toJson(entityRd));
					//}
				}
				
				rr.outTH(kson.getJson());
			}
			
			/* ----------- Formular Info ------------ */
			if (checkAction(rr, "formular_info")) {
				RDFormularInfo entity = new RDFormularInfo();
				WebUtils.bindReqToEntity(entity, rr.req);
				
				RDFormularInfo.update(entity);
				
				kson.setSuccess();
				rr.outTH(kson.getJson());
			}
			
			
			/* ----------- Formular Step ------------ */
			if (checkAction(rr, "formular_step_add")) {
				RDFormularStep entity = new RDFormularStep();
				WebUtils.bindReqToEntity(entity, rr.req);
				
				RDFormularStep.insert(entity);
				
				kson.setSuccess();
				rr.outTH(kson.getJson());
			}
			
			if (checkAction(rr, "formular_step_edit")) {
				RDFormularStep entity = new RDFormularStep();
				WebUtils.bindReqToEntity(entity, rr.req);
				
				RDFormularStep.update(entity);
				
				kson.setSuccess();
				rr.outTH(kson.getJson());
			}
			
			if (checkAction(rr, "formular_step_delete")) {
				RDFormularStep entity = new RDFormularStep();
				WebUtils.bindReqToEntity(entity, rr.req);
				
				RDFormularStep.delete(entity);
				
				kson.setSuccess();
				rr.outTH(kson.getJson());
			}
			
			/* ----------- Material for Step ------------ */
			if(checkAction(rr, "step_material_add")){
				RDFormularDetail entity = new RDFormularDetail();
				WebUtils.bindReqToEntity(entity, rr.req);
				RDFormularDetail.insert(entity);
				
				kson.setSuccess();
				rr.outTH(kson.getJson());
			}
			
			if(checkAction(rr, "step_material_edit")){
				RDFormularDetail entity = new RDFormularDetail();
				WebUtils.bindReqToEntity(entity, rr.req);
				RDFormularDetail.update(entity);
				
				kson.setSuccess();
				rr.outTH(kson.getJson());
			}
			
			if(checkAction(rr, "step_material_delete")){
				RDFormularDetail entity = new RDFormularDetail();
				WebUtils.bindReqToEntity(entity, rr.req);
				RDFormularDetail.delete(entity);
				
				kson.setSuccess();
				rr.outTH(kson.getJson());
			}
			
			if(checkAction(rr, "RD_Approve")){
				RDFormular entity = new RDFormular();
				WebUtils.bindReqToEntity(entity, rr.req);
				RDFormular.updateStatus(entity, StatusUtil.RD_SUBMIT);
				
				InventoryMaster master = new InventoryMaster();
				WebUtils.bindReqToEntity(master, rr.req);
				master.setStatus(StatusUtil.RD_SUBMIT);
				InventoryMaster.updateStausInfo(master);
				kson.setSuccess();
				rr.outTH(kson.getJson());
			}
			
			if (checkAction(rr, "Formular_Clone")) {
				InventoryMaster master = new InventoryMaster();
				WebUtils.bindAjaxReqToEntity(master, rr.req);
				String mat_code = RDFormular.clone(master);
				
				kson.setSuccess();
				kson.setData("mat_code", mat_code);
				rr.out(kson.getJson());
			}
			
			if (checkAction(rr, "step_order")) {
				RDFormularStep entity = new RDFormularStep();
				WebUtils.bindReqToEntity(entity, rr.req);
				
				String[] li_step = rr.req.getParameterValues("li_step[]");
				RDFormularStep.updateStepOrder(entity, li_step);
				
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			/**
			if (checkAction(rr, "formular_new")) {
				
				
				RDFormular entity = new RDFormular();
				WebUtils.bindReqToEntity(entity, rr.req);				
				//RDFormular.update(entity);
				
				kson.setSuccess();
				kson.setGson("formular", gson.toJson(entity));
				rr.outTH(kson.getJson());
			}
			if(checkAction(rr, "edit_rd_formular")){
				RDFormular entity = new RDFormular();
				WebUtils.bindReqToEntity(entity, rr.req);			
				//RDFormular.update(entity);
				
				kson.setSuccess();
				kson.setGson("formular", gson.toJson(entity));
				rr.outTH(kson.getJson());
			}
			if(checkAction(rr,"updateApproveStatus")){
				InventoryMaster entity = new InventoryMaster();
				WebUtils.bindReqToEntity(entity, rr.req);						
				entity.setStatus(StatusUtil.RD_SUBMIT);//set status = RD SUBMIT				
				InventoryMaster.updateStausInfo(entity);	
				
				kson.setSuccess();
				kson.setGson("formular", gson.toJson(entity));
				rr.outTH(kson.getJson());
			}
						
			if(checkAction(rr,"addMaterial")){
				RDFormularDetail entity = new RDFormularDetail();
				WebUtils.bindReqToEntity(entity, rr.req);	
				RDFormularDetail.insert(entity);
				
				InventoryMaster invEntity = new InventoryMaster();
				invEntity.setStatus(StatusUtil.RD_ACTIVE);//set status = RD ACTIVE
				invEntity.setUpdate_by(rr.getParam("create_by"));//update to inventory	
				invEntity.setMat_code(entity.getMaterial());
				invEntity.setRemark(rr.getAjaxParam("remark"));
				
				InventoryMaster.updateStausInfo(invEntity);
				if(invEntity.getRemark().length()>0){
					InventoryMaster.updateRemark(invEntity);
				}
				
				InventoryMaster.select(invEntity);
				entity.setUIMat(invEntity);
				kson.setSuccess();
				kson.setGson("formular", gson.toJson(entity));
				rr.outTH(kson.getJson());
			}
			
			if(checkAction(rr, "add_formular_step")){
				RDFormularStep entity = new RDFormularStep();
				WebUtils.bindReqToEntity(entity, rr.req);
				RDFormularStep.insert(entity);				
				
				kson.setSuccess();
				kson.setGson("rd_formular_step", gson.toJson(entity));
				rr.outTH(kson.getJson());
			}
			if(checkAction(rr, "add_material_add")){
				RDFormularDetail entity = new RDFormularDetail();
				WebUtils.bindReqToEntity(entity, rr.req);
				RDFormularDetail.insert(entity);
				
				kson.setSuccess();
				kson.setGson("rd_formular_step", gson.toJson(entity));
				rr.outTH(kson.getJson());
			}
			
			if(checkAction(rr, "deleteStep")){				
					RDFormularStep entityStep = new RDFormularStep();
					WebUtils.bindReqToEntity(entityStep, rr.req);
					RDFormularStep.delete(entityStep);
					//System.out.println("==<Step Complete<==");
					RDFormularDetail entity = new RDFormularDetail();				
					WebUtils.bindReqToEntity(entity, rr.req);	
					RDFormularDetail.delete(entity);
					//System.out.println("==<Detail Complete<==");
				InventoryMaster invEntity = new InventoryMaster();
				invEntity.setStatus(StatusUtil.RD_ACTIVE);//set status = RD ACTIVE
				invEntity.setUpdate_by(rr.getParam("update_by"));//update to inventory	
				invEntity.setMat_code(entityStep.getMat_code());				
				InventoryMaster.updateStausInfo(invEntity);
				//System.out.println("==<inventory Complete<==");
				kson.setSuccess();
				kson.setGson("formular", gson.toJson(entity));
				rr.outTH(kson.getJson());
			}			
			if(checkAction(rr, "edit_formular_step")){
				RDFormularStep entity = new RDFormularStep();
				WebUtils.bindReqToEntity(entity, rr.req);
				RDFormularStep.update(entity);
				
				kson.setSuccess();
				kson.setGson("rd_formular_step", gson.toJson(entity));
				rr.outTH(kson.getJson());
			}
			
			if(checkAction(rr, "del_rd_detail_material")){
				RDFormularDetail entity = new RDFormularDetail();
				WebUtils.bindReqToEntity(entity, rr.req);
				RDFormularDetail.delete(entity);
				
				kson.setSuccess();
				kson.setGson("rd_formular_detail", gson.toJson(entity));
				rr.outTH(kson.getJson());
			}
			//edit_rd_detail_material
			if(checkAction(rr, "edit_rd_detail_material")){
				RDFormularDetail entity = new RDFormularDetail();
				WebUtils.bindReqToEntity(entity, rr.req);
				RDFormularDetail.update(entity);
				
				kson.setSuccess();
				kson.setGson("rd_formular_detail", gson.toJson(entity));
				rr.outTH(kson.getJson());
			}**/
			
			
		}catch (Exception e) {
			//System.out.println("ERROR :"+e);
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
	
}
