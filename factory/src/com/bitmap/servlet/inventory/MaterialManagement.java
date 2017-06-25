package com.bitmap.servlet.inventory;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.ServletException;

import com.bitmap.bean.inventory.Categories;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.inventory.InventoryMasterVendor;
import com.bitmap.bean.inventory.SubCategories;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bitmap.bean.inventory.Vendor;

/**
 * Servlet implementation class MaterialManagement
 */
public class MaterialManagement extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public MaterialManagement() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (getAction(rr).length() > 0) {
				if (checkAction(rr, "add_material")) {
					InventoryMaster entity = new InventoryMaster();
					WebUtils.bindReqToEntity(entity, rr.req);
					if(InventoryMaster.checkMatCode(entity)){
						kson.setError("รหัสสินค้าซ้ำ กรุณาตรวจสอบ!");
						kson.setData("focus", "mat_code");
					}else{
						InventoryMaster.insert(entity);
						kson.setSuccess();
						kson.setGson("mat", gson.toJson(entity));
					}
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "edit_material")) {
					InventoryMaster entity = new InventoryMaster();
					WebUtils.bindReqToEntity(entity, rr.req);
					InventoryMaster.updateInfo(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "add_material_vendor")) {
					InventoryMasterVendor entity = new InventoryMasterVendor();
					WebUtils.bindReqToEntity(entity, rr.req);
					InventoryMasterVendor.insert(entity);
					kson.setSuccess();
					kson.setGson("vendor", gson.toJson(entity));
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "delete_material_vendor")) {
					InventoryMasterVendor entity = new InventoryMasterVendor();
					WebUtils.bindReqToEntity(entity, rr.req);
					InventoryMasterVendor.delete(entity);
					kson.setSuccess();
					rr.outTH(kson.getJson());
				}
				
				if (checkAction(rr, "cat_add")){
					actionCatAdd(rr);
				}  
					
				if (checkAction(rr, "cat_edit")){
					actionCatEdit(rr);
				}  
				
				if (checkAction(rr, "sub_cat_add")){
					actionSubCatAdd(rr);
				}  
					
				if (checkAction(rr, "sub_cat_edit")){
					actionSubCatEdit(rr);
				}
				
				
				if (checkAction(rr, "vendor_add")){
					actionVendorAdd(rr);
				}  
					
				if (checkAction(rr, "vendor_edit")){
					actionVendorEdit(rr);
				}
				
				if (checkAction(rr, "developUpdateBalance")) {
					InventoryMaster.developUpdateBalance();
					kson.setSuccess();
					rr.out(kson.getJson());
				}
			} else {

			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}

	private void actionVendorAdd(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		Vendor entity = new Vendor();
		WebUtils.bindReqToEntity(entity, rr.req);
		Vendor.insert(entity);
		kson.setSuccess();
		kson.setData("vendor_id", entity.getVendor_id());
		kson.setData("vendor_name", entity.getVendor_name());
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}

	private void actionVendorEdit(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		Vendor entity = new Vendor();
		WebUtils.bindReqToEntity(entity, rr.req);
		Vendor.update(entity);
		kson.setSuccess();
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}
	
	private void actionCatAdd(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		Categories entity = new Categories();
		WebUtils.bindReqToEntity(entity, rr.req);
		if (Categories.checkShortName(entity)) {
			kson.setError("ชื่อย่อซ้ำ ควรเปลี่ยนชื่อย่อใหม่!");
		} else {
			Categories.insert(entity);
			kson.setSuccess();
			kson.setGson(gson.toJson(entity));
		}
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}

	private void actionCatEdit(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		Categories entity = new Categories();
		WebUtils.bindReqToEntity(entity, rr.req);
		if (Categories.checkShortNameForEdit(entity)) {
			kson.setError("ชื่อย่อซ้ำ ควรเปลี่ยนชื่อย่อใหม่!");
		} else {
			Categories.update(entity);
			kson.setSuccess();
		}
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}
	
	
	/*sub cat*/
	private void actionSubCatAdd(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		SubCategories entity = new SubCategories();
		WebUtils.bindReqToEntity(entity, rr.req);
		if (SubCategories.checkShortName(entity)) {
			kson.setError("ชื่อย่อซ้ำ ควรเปลี่ยนชื่อย่อใหม่!");
		} else {
			SubCategories.insert(entity);
			kson.setSuccess();
			kson.setGson(gson.toJson(entity));
		}
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}

	private void actionSubCatEdit(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		SubCategories entity = new SubCategories();
		WebUtils.bindReqToEntity(entity, rr.req);
		if (SubCategories.checkShortNameForEdit(entity)) {
			kson.setError("ชื่อย่อซ้ำ ควรเปลี่ยนชื่อย่อใหม่!");
		} else {
			SubCategories.update(entity);
			kson.setSuccess();
		}
		rr.out(WebUtils.getResponseString(kson.getJson()));
	}
}
