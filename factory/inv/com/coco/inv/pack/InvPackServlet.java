package com.coco.inv.pack;

import javax.servlet.ServletException;

import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;



public class InvPackServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public InvPackServlet() {
        super();
    }

	@Override
	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				
				if (checkAction(rr, "add")) {
					
					InvPackBean entity = new InvPackBean();
					WebUtils.bindReqToEntity(entity, rr.req);					
					InvPackTS.insert(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "delete")) {
					InvPackBean entity = new InvPackBean();
					WebUtils.bindReqToEntity(entity, rr.req);					
					
					boolean checkActive = InvPackTS.delete(entity);
					
					if (!checkActive) {
						kson.setSuccess();
					} else {						
						kson.setError("!! ไม่สามารถลบข้อมูลได้เนื่องจาก "+entity.getMat_code()+" มีการใช้งานอยู่ !!");
					}
					rr.outTH(kson.getJson());												
				}
				
				if (checkAction(rr, "edit")) {
					
					InvPackBean entity = new InvPackBean();
					WebUtils.bindReqToEntity(entity, rr.req);					
								
					InvPackTS.update(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "matCodeInfo")) {
					
					InventoryMaster entity = new InventoryMaster();
					WebUtils.bindReqToEntity(entity, rr.req);					
							
					InventoryMaster en =InventoryMaster.select(entity.getMat_code());
										
					kson.setSuccess();					
					kson.setData("description",en.getDescription());
					kson.setData("std_unit",en.getStd_unit());
					kson.setData("des_unit",en.getDes_unit());
					kson.setData("unit_pack",en.getUnit_pack());
					rr.outTH(kson.getJson());
				}
				
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
		
	}

	

}
