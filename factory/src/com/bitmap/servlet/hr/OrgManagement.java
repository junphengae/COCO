package com.bitmap.servlet.hr;

import javax.servlet.ServletException;

import com.bitmap.bean.hr.Department;
import com.bitmap.bean.hr.Division;
import com.bitmap.bean.hr.Position;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class OrgManagement
 */
public class OrgManagement extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public OrgManagement() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (checkAction(rr,"getDiv")) {
				String dep_id = getParam(rr, "dep_id");
				kson.setSuccess();
				kson.setGson("div", gson.toJson(Division.getUIObjectDivision(dep_id)));
				rr.outTH(kson.getJson());
			}
			
			if (checkAction(rr,"add_dep")) {
				Department entity = new Department();
				WebUtils.bindReqToEntity(entity, rr.req);
				Department.insert(entity);
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			
			if (checkAction(rr,"edit_dep")) {
				Department entity = new Department();
				WebUtils.bindReqToEntity(entity, rr.req);
				Department.update(entity);
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			
			if (checkAction(rr,"edit_div")) {
				Division entity = new Division();
				WebUtils.bindReqToEntity(entity, rr.req);
				Division.update(entity);
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			
			if(checkAction(rr,"add_div")){
				Division entity = new Division();
				WebUtils.bindReqToEntity(entity, rr.req);
				Division.insert(entity);
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			
			if(checkAction(rr,"delete_div")){
						
			}
			
			if (checkAction(rr,"add_pos")) {
				Position entity = new Position();
				WebUtils.bindReqToEntity(entity, rr.req);
				Position.insert(entity);
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			
			if (checkAction(rr,"edit_pos")) {
				Position entity = new Position();
				WebUtils.bindReqToEntity(entity, rr.req);
				Position.update(entity);
				kson.setSuccess();
				rr.out(kson.getJson());
			}
			
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}