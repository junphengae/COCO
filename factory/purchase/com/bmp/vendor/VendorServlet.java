package com.bmp.vendor;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class VendorServlet
 */
public class VendorServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public VendorServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	@Override
	public void doPost(ReqRes rr) throws ServletException {
		try {
			
			if (isAction(rr)) {				
				if (checkAction(rr, "vendor_add")) {
					VendorBean ve = new VendorBean();
					WebUtils.bindReqToEntity(ve, rr.req);					
					VendorTS.insert(ve);
					kson.setSuccess();
					rr.out(kson.getJson());
				}
				if (checkAction(rr, "vendor_delete")) {
					VendorBean ve = new VendorBean();
					WebUtils.bindReqToEntity(ve, rr.req);					
					boolean checkPOActive = VendorTS.delete(ve);
					//System.out.println("Check PO Active:"+checkPOActive);
					if (!checkPOActive) {
						kson.setSuccess();
					} else {						
						kson.setError("!! ไม่สามารถลบข้อมูลได้เนื่องจาก "+ve.getVendor_id()+" มีการใช้งานอยู่ !!");
					}
					rr.outTH(kson.getJson());												
				}
				
				if (checkAction(rr, "vendor_edit")) {
					VendorBean ve = new VendorBean();
					WebUtils.bindReqToEntity(ve, rr.req);	
					//System.out.println("Vendor_id:"+ve.getVendor_id());
					VendorTS.update(ve);
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
