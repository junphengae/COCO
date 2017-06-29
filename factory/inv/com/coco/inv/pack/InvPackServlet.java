package com.coco.inv.pack;

import javax.servlet.ServletException;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;
import com.bmp.vendor.VendorBean;
import com.bmp.vendor.VendorTS;


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
				
				
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
		
	}

	

}
