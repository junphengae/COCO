package com.bitmap.servlet.hr;

import javax.servlet.ServletException;

import com.bitmap.bean.hr.Division;
import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.hr.Position;
import com.bitmap.security.SecurityUser;
import com.bitmap.security.SecurityUserRole;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class EmpManageServlet
 */
public class EmpManageServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public EmpManageServlet() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "getDivision")){
					String dep_id = WebUtils.getReqString(rr.req, "dep_id");
					rr.out(WebUtils.getResponseString(gson.toJson(Division.getUIObjectDivision(dep_id))));
				}
				
				if (checkAction(rr, "getPosition")){
					String div_id = WebUtils.getReqString(rr.req, "div_id");
					rr.out(WebUtils.getResponseString(gson.toJson(Position.getUIObjectPosition())));
				}
				
				if (checkAction(rr, "add")) {
					Personal personal = new Personal();
					WebUtils.bindReqToEntity(personal, rr.req);
					Personal.insert(personal);
					kson.setSuccess();
					kson.setData("per_id", personal.getPer_id());
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "edit")) {
					Personal personal = new Personal();
					WebUtils.bindReqToEntity(personal, rr.req);
					Personal.update(personal);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				
				if (checkAction(rr, "addRole")) {
					SecurityUserRole entity = new SecurityUserRole();
					WebUtils.bindReqToEntity(entity, rr.req);
					SecurityUserRole.addRole(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "delRole")) {
					SecurityUserRole entity = new SecurityUserRole();
					WebUtils.bindReqToEntity(entity, rr.req);
					SecurityUserRole.delRole(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				
				if (checkAction(rr, "savePass")) {
					SecurityUser entity = new SecurityUser();
					WebUtils.bindReqToEntity(entity, rr.req);
					SecurityUser.updateUserPassword(entity);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "addAct")) {
					SecurityUser entity = new SecurityUser();
				
					WebUtils.bindReqToEntity(entity, rr.req);					
					entity.setActive(WebUtils.getReqString(rr.req,"status"));
					
					SecurityUser.updateActive(entity);
					
					Personal per = new Personal();
					WebUtils.bindReqToEntity(per, rr.req);
					per.setPer_id(entity.getUser_id());
					
					Personal.update_retire(per);
					
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if(checkAction(rr, "getPersonByDep")){
					kson.setSuccess();
					kson.setGson("model", gson.toJson(Personal.listDropdownByDep(WebUtils.getReqString(rr.req, "dep_id"))));
					rr.outTH(kson.getJson());
				}
				
			} else {

			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}

}
