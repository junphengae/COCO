package com.bitmap.servlet.inventory;

import javax.servlet.ServletException;

import com.bitmap.bean.inventory.InventoryLot;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.production.Production;
import com.bitmap.bean.util.DateUtils;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class InletManagement
 */
public class InletManagement extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public InletManagement() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (getAction(rr).length() > 0) {
				if (checkAction(rr, "check_material")) {
					InventoryMaster entity = new InventoryMaster();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					if (InventoryMaster.select(entity)){
						if (entity.getFifo_flag().length() > 0) {
							kson.setSuccess();
							kson.setGson("material", gson.toJson(entity));
						} else {
							kson.setError("สินค้ารายการนี้ยังไม่ได้กำหนดรายละเอียด กรุณากำหนดรายละเอียดก่อน!");
							kson.setData("action","redirect");
						}
					} else {
						kson.setError("รหัสสินค้าไม่ถูกต้อง กรุณาตรวจสอบใหม่อีกครั้ง!");
						kson.setData("action","focus");
					}
					rr.outTH(kson.getJson());
				}
				/**
				 * 
				 */
				if (checkAction(rr, "check_material_non")) {
					InventoryMaster entity = new InventoryMaster();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					System.out.println("Mat Code:"+entity.getMat_code());
					if (InventoryMaster.select(entity)){
						if (entity.getFifo_flag().length() > 0) {
							kson.setSuccess();
							kson.setGson("material", gson.toJson(entity));
						} else {
							kson.setError("สินค้ารายการนี้ยังไม่ได้กำหนดรายละเอียด กรุณากำหนดรายละเอียดก่อน!");
							kson.setData("action","redirect");
						}
					} else {
						kson.setError("รหัสสินค้าไม่ถูกต้อง กรุณาตรวจสอบใหม่อีกครั้ง!");
						kson.setData("action","focus");
					}
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "inlet")) {
					InventoryLot entity = new InventoryLot();
					WebUtils.bindReqToEntity(entity, rr.getRequest());

					entity.setLot_qty(Double.toString(Double.parseDouble(entity.getLot_qty())));
					InventoryLot.insert(entity);
					
					Production pro = new Production();
					pro.setItem_id(entity.getMat_code());
					pro.setPro_id(entity.getPo());
					pro.setUpdate_by(entity.getCreate_by());
					Production.InletPD(pro,entity.getLot_qty());
					
					kson.setSuccess();
					kson.setGson("LOT", gson.toJson(entity));
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				//** Action: inlet_non_po Date:07/03/2016 *//
				
				if (checkAction(rr, "inlet_non_invoice")) {
					InventoryLot entity = new InventoryLot();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					entity.setLot_qty(Double.toString(Double.parseDouble(entity.getLot_qty())));
					InventoryLot.insert(entity);
					
					Production pro = new Production();
					pro.setItem_id(entity.getMat_code());
					pro.setPro_id(entity.getPo());
					pro.setUpdate_by(entity.getCreate_by());
					Production.InletPD(pro,entity.getLot_qty());
					
					kson.setSuccess();
					kson.setGson("LOT", gson.toJson(entity));
					rr.out(WebUtils.getResponseString(kson.getJson()));
				}
				
				
				if (checkAction(rr, "inlet_invoice")) {
					InventoryLot entity = new InventoryLot();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					entity.setLot_qty(Double.toString(Double.parseDouble(entity.getLot_qty())));
					InventoryLot.insert_by_invoice(entity);
					
					kson.setSuccess();
					kson.setGson("LOT", gson.toJson(entity));
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "edit_lot")) {
					InventoryLot entity = new InventoryLot();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					InventoryLot.update(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "check_product")) {
					Production entity = new Production();
					WebUtils.bindReqToEntity(entity, rr.getRequest());
					
					//boolean check =  Production.Pro_idAndMat_code(entity);
					kson.setSuccess();
					kson.setData("check", true);
					rr.out(kson.getJson());
				}
				
				if(checkAction(rr, "calculate_expire")){
					String str_date_mfg = getParam(rr, "date_mfg");
					int bbf = Integer.parseInt( getParam(rr, "bbf_day"));
					String expire_date = DateUtils.calculateMFG(str_date_mfg, bbf);
					
					kson.setSuccess();
					kson.setData("expire_date", expire_date);
					rr.out(kson.getJson());
				}
			} else {

			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}

}
