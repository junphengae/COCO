package com.bitmap.servlet.sale;

import javax.servlet.ServletException;

import com.bitmap.bean.sale.Package;
import com.bitmap.bean.sale.PackageItem;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

public class PackageManage extends ServletUtils {
	private static final long serialVersionUID = 1L;

    public PackageManage() {
        super();
    }
    public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "package_new")) {
					Package entity = new Package();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Package.insert(entity);
					
					kson.setSuccess();
					kson.setData("pk_id", entity.getPk_id());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "package_create_item")) {
					Package entity = new Package();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Package.insert(entity);
					
					kson.setSuccess();
					kson.setData("pk_id", entity.getPk_id());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "fg_add")) {
					PackageItem entity = new PackageItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					PackageItem.insert(entity);
					
					kson.setSuccess();
					kson.setData("pk_id", entity.getPk_id());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "fg_update")) {
					PackageItem entity = new PackageItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					PackageItem.update(entity);
					
					kson.setSuccess();
					kson.setData("pk_id", entity.getPk_id());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "fg_del")) {
					PackageItem entity = new PackageItem();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					PackageItem.delete(entity);
					
					kson.setSuccess();
					kson.setData("pk_id", entity.getPk_id());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "packageName_update")) {
					Package entity = new Package();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Package.updateName(entity);
					
					kson.setSuccess();
					kson.setData("pk_id", entity.getPk_id());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "Pk_Ap_update")) {
					Package entity = new Package();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Package.updateAp(entity);
					
					kson.setSuccess();
					kson.setData("pk_id", entity.getPk_id());
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "director_update_status")) {
					Package entity = new Package();
					WebUtils.bindReqToEntity(entity, rr.req);
					
					Package.updateStatus(entity);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}

}
